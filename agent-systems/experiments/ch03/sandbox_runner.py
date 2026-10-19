#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 3 章实验：一个能限额、能超时、能收尸的 Python 沙箱 runner。

它只做四件事，正好对应正文的四层边界：

  1. 进程：``start_new_session=True`` 建独立进程组；超时后 ``os.killpg``。
  2. 文件：脚本必须落在 workspace 内；符号链接解析后仍须在内。
  3. 资源：``resource.setrlimit`` 设 CPU / FSIZE / NOFILE / (Linux) AS。
  4. 输出：stdout/stderr 落到临时文件，按上限截断并报告。

它不是安全边界。同一个 UID 下的子进程仍能读写宿主文件、绕过路径检查、
用 ``setsid`` 逃出进程组。真正的边界见 3.3–3.6 与第 4 章。
"""

from __future__ import annotations

import argparse
import json
import os
import resource
import shutil
import signal
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

IS_LINUX = sys.platform.startswith("linux")
IS_MACOS = sys.platform == "darwin"

DEFAULT_TIMEOUT_S = 3.0
DEFAULT_CPU_S = 2
DEFAULT_FSIZE_BYTES = 8 * 1024 * 1024
DEFAULT_NOFILE = 64
DEFAULT_MAX_OUTPUT_BYTES = 64 * 1024


class PathEscape(ValueError):
    """脚本路径解析后落在 workspace 之外。"""


def _signal_name(signum: int | None) -> str | None:
    if signum is None:
        return None
    try:
        return signal.Signals(signum).name
    except ValueError:
        return f"SIG{signum}"


def decode_wait_status(status: int) -> dict[str, Any]:
    """把 wait(2) 的原始 status 解成可读字段。

    这不是 ``status & 0xff``：低 7 位是终止信号，第 8 位是 core dump 标志，
    只有 ``WIFEXITED`` 为真时，高字节才是退出码。
    """
    raw = f"0x{status:04x}"
    if os.WIFEXITED(status):
        return {
            "kind": "exited",
            "raw": raw,
            "exit_code": os.WEXITSTATUS(status),
            "signal": None,
            "signal_name": None,
            "core_dumped": False,
        }
    if os.WIFSIGNALED(status):
        sig = os.WTERMSIG(status)
        return {
            "kind": "signaled",
            "raw": raw,
            "exit_code": None,
            "signal": sig,
            "signal_name": _signal_name(sig),
            "core_dumped": bool(os.WCOREDUMP(status)),
        }
    if os.WIFSTOPPED(status):
        sig = os.WSTOPSIG(status)
        return {
            "kind": "stopped",
            "raw": raw,
            "exit_code": None,
            "signal": sig,
            "signal_name": _signal_name(sig),
            "core_dumped": False,
        }
    return {
        "kind": "continued",
        "raw": raw,
        "exit_code": None,
        "signal": None,
        "signal_name": None,
        "core_dumped": False,
    }


def _resolve_inside(root: Path, candidate: Path) -> Path:
    """解析符号链接后，确认 candidate 仍在 root 之内。

    ``Path.resolve()`` 是检查，不是原子打开；检查与 open 之间仍有竞态。
    真正的修复是 ``openat2(RESOLVE_BENEATH)`` 或逐段 ``O_NOFOLLOW``。
    """
    root = root.resolve()
    target = candidate.resolve()
    try:
        target.relative_to(root)
    except ValueError as exc:
        raise PathEscape(f"{candidate} -> {target} is outside {root}") from exc
    return target


def _apply_limits(
    cpu_s: int,
    fsize_bytes: int,
    nofile: int,
    as_bytes: int | None,
) -> None:
    """在子进程 exec 之前设置 rlimit。异常会让子进程以 255 退出。"""
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    if cpu_s > 0:
        resource.setrlimit(resource.RLIMIT_CPU, (cpu_s, cpu_s + 1))
    if fsize_bytes > 0:
        resource.setrlimit(resource.RLIMIT_FSIZE, (fsize_bytes, fsize_bytes))
    if nofile > 0:
        resource.setrlimit(resource.RLIMIT_NOFILE, (nofile, nofile))
    if as_bytes and IS_LINUX:
        # macOS 上 RLIMIT_AS 不可靠：可能直接 ValueError/ENOMEM。
        try:
            resource.setrlimit(resource.RLIMIT_AS, (as_bytes, as_bytes))
        except (ValueError, OSError):
            pass
    # 故意不设 RLIMIT_NPROC：Linux 按真实 UID 计数，macOS 按用户计，
    # 在一个共享账号上设它会影响宿主自身。聚合进程数用 cgroup pids.max。


def _kill_group(pid: int) -> None:
    """向整个进程组发 SIGKILL；组 ID 等于 start_new_session 后的 pid。"""
    try:
        os.killpg(pid, signal.SIGKILL)
    except ProcessLookupError:
        return
    except PermissionError:
        try:
            os.kill(pid, signal.SIGKILL)
        except ProcessLookupError:
            pass


def _truncate(path: Path, limit: int) -> tuple[str, bool, int]:
    """只读前 limit 字节，避免为了截断而把整个大文件读进内存。"""
    size = path.stat().st_size
    with path.open("rb") as fh:
        raw = fh.read(limit)
    truncated = size > limit
    text = raw.decode("utf-8", "replace")
    return text, truncated, size


def _error_result(root: Path, code: str, detail: str) -> dict[str, Any]:
    return {
        "ok": False,
        "exit_code": None,
        "signal": None,
        "signal_name": None,
        "timed_out": False,
        "output_limited": False,
        "duration_ms": 0,
        "stdout": "",
        "stderr": "",
        "stdout_truncated": False,
        "stderr_truncated": False,
        "error": code,
        "detail": detail,
        "workspace": str(root),
        "rlimits": {},
    }


def run_script(
    script_path: str | os.PathLike[str],
    *,
    workspace: str | os.PathLike[str],
    timeout_s: float = DEFAULT_TIMEOUT_S,
    cpu_s: int = DEFAULT_CPU_S,
    fsize_bytes: int = DEFAULT_FSIZE_BYTES,
    nofile: int = DEFAULT_NOFILE,
    as_bytes: int | None = None,
    max_output_bytes: int = DEFAULT_MAX_OUTPUT_BYTES,
    env: dict[str, str] | None = None,
) -> dict[str, Any]:
    """在 workspace 内运行一个 Python 脚本，返回结构化结果。"""
    if timeout_s <= 0:
        raise ValueError("timeout_s must be > 0")
    if max_output_bytes <= 0:
        raise ValueError("max_output_bytes must be > 0")

    root = Path(workspace).expanduser().resolve()
    root.mkdir(parents=True, exist_ok=True)

    try:
        script = _resolve_inside(root, Path(script_path))
    except (PathEscape, RuntimeError, OSError) as exc:
        return _error_result(root, "EPATH", str(exc))

    if not script.is_file():
        return _error_result(root, "ENOENT", f"script not found: {script}")

    io_dir = Path(tempfile.mkdtemp(prefix="ch03-io-"))
    out_path = io_dir / "stdout.log"
    err_path = io_dir / "stderr.log"
    child_env = {
        "PATH": "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin",
        "HOME": str(root),
        "LANG": "C.UTF-8",
        "PYTHONIOENCODING": "utf-8",
    }
    if env:
        child_env.update(env)

    started = time.monotonic()
    timed_out = False
    output_limited = False
    signal_number: int | None = None
    exit_code: int | None = None
    detail = ""

    with out_path.open("wb") as out_fh, err_path.open("wb") as err_fh:
        proc = subprocess.Popen(
            [sys.executable, "-I", str(script)],
            cwd=root,
            stdin=subprocess.DEVNULL,
            stdout=out_fh,
            stderr=err_fh,
            start_new_session=True,
            preexec_fn=lambda: _apply_limits(
                cpu_s, fsize_bytes, nofile, as_bytes
            ),
            env=child_env,
            close_fds=True,
        )
        deadline = started + timeout_s

        while proc.poll() is None:
            if time.monotonic() >= deadline:
                timed_out = True
                _kill_group(proc.pid)
                break
            total = out_path.stat().st_size + err_path.stat().st_size
            if total > max_output_bytes * 2:
                output_limited = True
                _kill_group(proc.pid)
                break
            time.sleep(0.01)

        try:
            returncode = proc.wait(timeout=2.0)
        except subprocess.TimeoutExpired:
            _kill_group(proc.pid)
            try:
                returncode = proc.wait(timeout=2.0)
            except subprocess.TimeoutExpired:
                returncode = None
                detail = "process survived SIGKILL (escaped process group?)"

    duration_ms = int((time.monotonic() - started) * 1000)

    if returncode is None:
        error = "ESCAPED"
    elif returncode < 0:
        signal_number = -returncode
        error = None
    else:
        exit_code = returncode
        error = None

    stdout, out_truncated, out_size = _truncate(out_path, max_output_bytes)
    stderr, err_truncated, err_size = _truncate(err_path, max_output_bytes)
    if out_truncated or err_truncated:
        output_limited = True

    shutil.rmtree(io_dir, ignore_errors=True)

    ok = (
        error is None
        and exit_code == 0
        and not timed_out
        and not output_limited
    )
    return {
        "ok": ok,
        "exit_code": exit_code,
        "signal": signal_number,
        "signal_name": _signal_name(signal_number),
        "timed_out": timed_out,
        "output_limited": output_limited,
        "duration_ms": duration_ms,
        "stdout": stdout,
        "stderr": stderr,
        "stdout_truncated": out_truncated,
        "stderr_truncated": err_truncated,
        "error": error,
        "detail": detail or None,
        "workspace": str(root),
        "rlimits": {
            "cpu_s": cpu_s,
            "fsize_bytes": fsize_bytes,
            "nofile": nofile,
            "as_bytes": as_bytes if IS_LINUX else None,
            "as_enforced": bool(as_bytes and IS_LINUX),
        },
        "bytes": {"stdout": out_size, "stderr": err_size},
    }


def run_code(
    code: str,
    *,
    workspace: str | os.PathLike[str] | None = None,
    keep: bool = False,
    **kwargs: Any,
) -> dict[str, Any]:
    """把 code 写成 workspace/main.py 并运行。

    未给 workspace 时创建临时目录；keep=False 时运行后删除。
    """
    created = workspace is None
    root = Path(workspace or tempfile.mkdtemp(prefix="ch03-sandbox-"))
    root.mkdir(parents=True, exist_ok=True)
    script = root / "main.py"
    script.write_text(code, encoding="utf-8")

    result = run_script(script, workspace=root, **kwargs)
    if created and not keep:
        shutil.rmtree(root, ignore_errors=True)
    return result


def _parse_int(text: str) -> int:
    return int(text, 0)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="第 3 章沙箱 runner")
    parser.add_argument("--code", help="要运行的 Python 代码")
    parser.add_argument("--file", help="要运行的脚本（必须在 workspace 内）")
    parser.add_argument("--workspace", help="工作目录；默认给 --code 建临时目录")
    parser.add_argument("--timeout", type=float, default=DEFAULT_TIMEOUT_S)
    parser.add_argument("--cpu", type=_parse_int, default=DEFAULT_CPU_S)
    parser.add_argument("--fsize", type=_parse_int, default=DEFAULT_FSIZE_BYTES)
    parser.add_argument("--nofile", type=_parse_int, default=DEFAULT_NOFILE)
    parser.add_argument("--as-bytes", type=_parse_int, default=None)
    parser.add_argument("--max-output", type=_parse_int, default=DEFAULT_MAX_OUTPUT_BYTES)
    parser.add_argument("--keep", action="store_true", help="保留工作目录")
    parser.add_argument(
        "--decode-status",
        help="解码 wait status，例如 0x2a00；不运行子进程",
    )
    args = parser.parse_args(argv)

    if args.decode_status:
        status = int(args.decode_status, 0)
        print(json.dumps(decode_wait_status(status), ensure_ascii=False, indent=2))
        return 0

    if bool(args.code) == bool(args.file):
        parser.error("exactly one of --code or --file is required")

    common = {
        "timeout_s": args.timeout,
        "cpu_s": args.cpu,
        "fsize_bytes": args.fsize,
        "nofile": args.nofile,
        "as_bytes": args.as_bytes,
        "max_output_bytes": args.max_output,
    }

    if args.code:
        result = run_code(args.code, workspace=args.workspace, keep=args.keep, **common)
    else:
        file_path = Path(args.file).expanduser()
        workspace = Path(args.workspace).expanduser() if args.workspace else file_path.parent
        result = run_script(file_path, workspace=workspace, **common)

    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result["ok"] else 1


if __name__ == "__main__":
    sys.exit(main())
