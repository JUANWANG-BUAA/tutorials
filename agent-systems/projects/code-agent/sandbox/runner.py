"""受限子进程执行器：超时、进程组、rlimit、输出上限。

设计取舍：
- 用 `start_new_session=True`（setsid）让子进程成为新会话/进程组组长，
  超时后 `killpg` 能连同它派生的子进程一起杀掉；只杀父进程会留下孤儿。
- 输出重定向到临时文件，而不是 pipe + communicate；恶意程序可以无限写
  stdout，pipe 会把内存吃光，临时文件只受磁盘/rlimit 限制。
- rlimit 在 `preexec_fn` 里设置，只影响子进程；不修改父进程。
- macOS 不支持 RLIMIT_AS 的一致语义，默认不用；Linux runner 可另加。
"""

from __future__ import annotations

import os
import resource
import signal
import subprocess
import tempfile
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Mapping, Sequence


@dataclass(frozen=True)
class Limits:
    cpu_seconds: int = 5
    file_size_bytes: int = 1 << 20      # 1 MiB
    open_files: int = 64
    memory_bytes: int | None = None      # Linux 可设；macOS 默认 None
    output_bytes: int = 64 << 10         # 64 KiB 截断


@dataclass
class RunResult:
    argv: list[str]
    exit_code: int
    term_signal: int | None
    timed_out: bool
    duration_ms: int
    stdout: str
    stderr: str
    truncated: bool
    cwd: str

    @property
    def ok(self) -> bool:
        return self.exit_code == 0 and self.term_signal is None and not self.timed_out


def _apply_limits(limits: Limits) -> None:
    def setr(which, soft, hard) -> None:
        try:
            resource.setrlimit(which, (soft, hard))
        except (ValueError, OSError):
            # 某些平台不支持某个资源；沙箱不应因此崩溃，但调用方要知道。
            pass

    setr(resource.RLIMIT_CPU, limits.cpu_seconds, limits.cpu_seconds + 1)
    setr(resource.RLIMIT_FSIZE, limits.file_size_bytes, limits.file_size_bytes)
    setr(resource.RLIMIT_NOFILE, limits.open_files, limits.open_files)
    if limits.memory_bytes is not None and hasattr(resource, "RLIMIT_AS"):
        setr(resource.RLIMIT_AS, limits.memory_bytes, limits.memory_bytes)
    # core dump 不写盘：避免把敏感内存落到工作区。
    setr(resource.RLIMIT_CORE, 0, 0)


def _read_capped(path: Path, limit: int) -> tuple[str, bool]:
    size = path.stat().st_size if path.exists() else 0
    with open(path, "rb") as fh:
        data = fh.read(limit)
    return data.decode("utf-8", "replace"), size > limit


def run_command(
    argv: Sequence[str],
    *,
    cwd: str | Path,
    timeout_s: float = 5.0,
    limits: Limits | None = None,
    env: Mapping[str, str] | None = None,
    stdin_data: bytes | None = None,
) -> RunResult:
    """执行 argv，返回结构化结果；不抛超时/信号异常。"""
    limits = limits or Limits()
    cwd_path = Path(cwd)
    if not cwd_path.is_dir():
        raise NotADirectoryError(str(cwd_path))

    with tempfile.TemporaryDirectory(prefix="as-run-") as td:
        out_path = Path(td) / "stdout"
        err_path = Path(td) / "stderr"
        with open(out_path, "wb") as out, open(err_path, "wb") as err:
            start = time.monotonic()
            proc = subprocess.Popen(
                list(argv),
                cwd=str(cwd_path),
                stdin=subprocess.PIPE if stdin_data is not None else subprocess.DEVNULL,
                stdout=out,
                stderr=err,
                env=dict(env) if env is not None else None,
                start_new_session=True,
                preexec_fn=lambda: _apply_limits(limits),
                close_fds=True,
            )
            timed_out = False
            try:
                proc.communicate(input=stdin_data, timeout=timeout_s)
            except subprocess.TimeoutExpired:
                timed_out = True
                _kill_group(proc)
                try:
                    proc.communicate(timeout=2)
                except subprocess.TimeoutExpired:
                    _kill_group(proc, signal.SIGKILL)
            duration_ms = int((time.monotonic() - start) * 1000)

        stdout, cut_out = _read_capped(out_path, limits.output_bytes)
        stderr, cut_err = _read_capped(err_path, limits.output_bytes)

    rc = proc.returncode if proc.returncode is not None else -signal.SIGKILL
    term = -rc if rc < 0 else None
    return RunResult(
        argv=list(argv),
        exit_code=rc,
        term_signal=term,
        timed_out=timed_out,
        duration_ms=duration_ms,
        stdout=stdout,
        stderr=stderr,
        truncated=cut_out or cut_err,
        cwd=str(cwd_path),
    )


def _kill_group(proc: subprocess.Popen, sig: int = signal.SIGKILL) -> None:
    try:
        os.killpg(proc.pid, sig)
    except ProcessLookupError:
        pass
    except PermissionError:
        # 理论上同用户不会发生；退化为杀单进程。
        try:
            proc.send_signal(sig)
        except ProcessLookupError:
            pass
