#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""沙箱实验：资源限制、墙钟超时、cwd/env/fd 与策略拦截。

只依赖 Python 3.11+ 标准库。macOS 与 Linux 都能跑；平台差异会打印出来。
本脚本不执行不可信代码，所有子进程代码都是本文件里的固定字符串。

用法：
    python3 sandbox_lab.py
    python3 sandbox_lab.py --skip-policy
"""

from __future__ import annotations

import argparse
import os
import platform
import resource
import shutil
import signal
import subprocess
import sys
import tempfile
import time


PY = sys.executable
BASE_ENV = {
    "PATH": os.environ.get("PATH", "/usr/bin:/bin:/usr/sbin:/sbin"),
    "LC_ALL": "C",
    "PYTHONNOUSERSITE": "1",
}


def child_env(extra: dict[str, str] | None = None) -> dict[str, str]:
    env = dict(BASE_ENV)
    if extra:
        env.update(extra)
    return env


def run_child(code: str, *, env: dict[str, str], cwd: str,
              preexec=None, timeout: float = 5.0,
              pass_fds: tuple[int, ...] = (),
              args: tuple[str, ...] = ()) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [PY, "-c", code, *args],
        env=env,
        cwd=cwd,
        preexec_fn=preexec,
        pass_fds=pass_fds,
        capture_output=True,
        text=True,
        timeout=timeout,
    )


def show(label: str, p: subprocess.CompletedProcess[str]) -> None:
    out = (p.stdout or "").strip().replace("\n", " | ")
    err = (p.stderr or "").strip().splitlines()
    tail = err[-1] if err else ""
    print(f"[{label}] rc={p.returncode} out={out!r} err_tail={tail!r}")


# ---------------------------------------------------------------- 子进程代码

ENV_CODE = "import os; print('LAB_SECRET=' + os.environ.get('LAB_SECRET', '<missing>'))"

CWD_CODE = (
    "import sys; p=sys.argv[1]; open(p,'w').write('escaped\\n'); "
    "print('wrote ' + p)"
)

FD_CODE = (
    "import os; fd=int(os.environ['LEAK_FD']); "
    "print('fd', fd, '=>', os.read(fd, 128).decode().strip())"
)

CPU_CODE = "while True: pass"

FSIZE_CODE = (
    "import sys; f=open(sys.argv[1],'wb'); f.write(b'x'*200000); f.flush(); "
    "print('wrote 200000 bytes')"
)

NOFILE_CODE = (
    "fs=[]\n"
    "for i in range(40):\n"
    "    fs.append(open('/dev/null'))\n"
    "print('opened', len(fs))"
)

ORPHAN_CHILD = r"""
import subprocess, sys, time
hb = sys.argv[1]
grand = (
    "import sys,time\n"
    "p=sys.argv[1]\n"
    "f=open(p,'a',buffering=1)\n"
    "for i in range(80):\n"
    "    f.write('x'); f.flush(); time.sleep(0.05)\n"
)
subprocess.Popen([sys.executable, "-c", grand, hb],
                 stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                 stderr=subprocess.DEVNULL)
time.sleep(10)
"""


def limits_section(root: str) -> None:
    print("== A. resource limits (per-process, inherited) ==")

    def cpu_limit() -> None:
        resource.setrlimit(resource.RLIMIT_CPU, (1, 1))

    t0 = time.monotonic()
    p = run_child(CPU_CODE, env=child_env(), cwd=root, preexec=cpu_limit, timeout=4)
    print(f"[RLIMIT_CPU=1s] rc={p.returncode} elapsed={time.monotonic()-t0:.2f}s")
    print("  note: macOS returns -24 (SIGXCPU); Linux normally also -24.")

    def fsize_limit() -> None:
        resource.setrlimit(resource.RLIMIT_FSIZE, (4096, 4096))

    out = os.path.join(root, "fsize.bin")
    p = run_child(FSIZE_CODE, env=child_env(), cwd=root, preexec=fsize_limit,
                  args=(out,))
    show("RLIMIT_FSIZE=4KiB", p)

    def nofile_limit() -> None:
        resource.setrlimit(resource.RLIMIT_NOFILE, (16, 16))

    p = run_child(NOFILE_CODE, env=child_env(), cwd=root, preexec=nofile_limit)
    show("RLIMIT_NOFILE=16", p)

    # macOS 上 RLIMIT_AS/RLIMIT_DATA 的有限值通常会被内核拒绝。
    # 在 fork 的子进程里试，避免万一成功时把本进程也限制住。
    if sys.platform == "darwin":
        sys.stdout.flush()
        pid = os.fork()
        if pid == 0:
            try:
                resource.setrlimit(resource.RLIMIT_AS, (64 << 20, 64 << 20))
                print("[RLIMIT_AS=64MiB] setrlimit accepted")
            except (ValueError, OSError) as e:
                soft, hard = resource.getrlimit(resource.RLIMIT_AS)
                print(f"[RLIMIT_AS=64MiB] setrlimit rejected: {e}")
                print(f"  current soft={soft} hard={hard} (RLIM_INFINITY={resource.RLIM_INFINITY})")
            sys.stdout.flush()
            os._exit(0)
        os.waitpid(pid, 0)
        q = subprocess.run(["bash", "-c", "ulimit -v 65536"],
                           capture_output=True, text=True)
        q2 = subprocess.run(["bash", "-c", "ulimit -v"],
                            capture_output=True, text=True)
        print(f"[ulimit -v 65536] rc={q.returncode} "
              f"err={q.stderr.strip()!r} current={q2.stdout.strip()!r}")
    else:
        def as_limit() -> None:
            resource.setrlimit(resource.RLIMIT_AS, (128 << 20, 128 << 20))

        p = run_child(
            "a=bytearray(256*1024*1024); print('allocated', len(a))",
            env=child_env(), cwd=root, preexec=as_limit,
        )
        show("RLIMIT_AS=128MiB/alloc256MiB", p)


def isolation_section(root: str) -> None:
    print("\n== B. isolation: cwd, env, inherited fd ==")
    sandbox = os.path.join(root, "sandbox")
    outside = os.path.join(root, "outside")
    os.makedirs(sandbox, exist_ok=True)
    os.makedirs(outside, exist_ok=True)

    # 1. cwd 只是相对路径的基准，不是文件系统边界。
    target = os.path.join(outside, "escape.txt")
    p = run_child(CWD_CODE, env=child_env(), cwd=sandbox, args=(target,))
    print(f"[cwd] child cwd=sandbox/ wrote outside exists={os.path.exists(target)}")
    print(f"  content={open(target).read().strip()!r}")

    # 2. 环境变量：清理后看不到，继承时看得到。env 不是能力。
    os.environ["LAB_SECRET"] = "ENV_SECRET=alpha"
    p = run_child(ENV_CODE, env=child_env(), cwd=sandbox)
    show("env cleaned", p)
    p = run_child(ENV_CODE, env=child_env({"LAB_SECRET": os.environ["LAB_SECRET"]}),
                  cwd=sandbox)
    show("env passed", p)

    # 3. 继承 fd：资源限制不会撤销已经打开的句柄。
    secret = os.path.join(root, "secret.txt")
    with open(secret, "w", encoding="utf-8") as f:
        f.write("TOP_SECRET=swordfish\n")
    fd = os.open(secret, os.O_RDONLY)
    env = child_env({"LEAK_FD": str(fd)})
    try:
        p = run_child(FD_CODE, env=env, cwd=sandbox, pass_fds=(fd,))
        show("fd passed", p)
        p = run_child(FD_CODE, env=env, cwd=sandbox)
        show("fd closed", p)
    finally:
        os.close(fd)


def timeout_section(root: str) -> None:
    print("\n== C. wall timeout vs descendants ==")
    hb = os.path.join(root, "heartbeat.bin")
    open(hb, "wb").close()
    p = subprocess.Popen(
        [PY, "-c", ORPHAN_CHILD, hb],
        start_new_session=True,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    timed_out = False
    try:
        p.wait(timeout=0.4)
        print(f"[timeout] child exited early rc={p.returncode}")
    except subprocess.TimeoutExpired:
        timed_out = True
        print("[timeout] wall clock hit 0.4s; subprocess.run would kill only the child")
        p.kill()
        p.wait()
    try:
        time.sleep(0.2)
        before = os.path.getsize(hb)
        time.sleep(0.6)
        after = os.path.getsize(hb)
        print(f"[descendant] heartbeat after child kill: {before} -> {after} "
              f"(grew {after-before} bytes)")
        try:
            os.killpg(p.pid, signal.SIGKILL)
            print("[descendant] killpg(SIGKILL) sent")
        except ProcessLookupError:
            print("[descendant] killpg: group already gone")
        time.sleep(0.2)
        s1 = os.path.getsize(hb)
        time.sleep(0.4)
        s2 = os.path.getsize(hb)
        print(f"[descendant] after killpg: {s1} -> {s2} (grew {s2-s1} bytes)")
    finally:
        if timed_out:
            try:
                os.killpg(p.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            try:
                p.wait(timeout=2)
            except subprocess.TimeoutExpired:
                pass


def policy_section(root: str) -> None:
    print("\n== D. platform policy (macOS only) ==")
    if sys.platform != "darwin":
        print("[policy] skipped: this build targets Linux; use seccomp/landlock there")
        return
    exe = shutil.which("sandbox-exec")
    if not exe:
        print("[policy] sandbox-exec not found; macOS has no seccomp either")
        return
    secret = os.path.join(root, "policy-secret.txt")
    with open(secret, "w", encoding="utf-8") as f:
        f.write("POLICY_SECRET=beta\n")
    real = os.path.realpath(secret)
    profile = os.path.join(root, "deny.sb")
    with open(profile, "w", encoding="utf-8") as f:
        f.write('(version 1)\n(allow default)\n')
        f.write(f'(deny file-read-data (literal "{real}"))\n')
    p = subprocess.run([exe, "-f", profile, "/bin/cat", real],
                       capture_output=True, text=True)
    err = p.stderr.strip().replace(os.path.dirname(real), "$LAB")
    print(f"[sandbox-exec] rc={p.returncode} out={p.stdout.strip()!r} "
          f"err={err!r}")
    print("  note: sandbox-exec is deprecated; App Sandbox/XPC is the supported boundary.")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--skip-policy", action="store_true")
    args = ap.parse_args()

    print("== sandbox-lab ==")
    print(f"platform: {platform.platform()}")
    print(f"python: {sys.version.split()[0]}")
    print(f"seccomp: {'yes (Linux)' if sys.platform.startswith('linux') else 'no'}")
    print()

    root = tempfile.mkdtemp(prefix="sandbox-lab-")
    try:
        limits_section(root)
        isolation_section(root)
        timeout_section(root)
        if not args.skip_policy:
            policy_section(root)
    finally:
        shutil.rmtree(root, ignore_errors=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
