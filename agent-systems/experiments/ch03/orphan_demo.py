#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""复现 3.7 的「只杀父进程」事故：子进程在父进程死后继续写文件。

    python3 experiments/ch03/orphan_demo.py            # 只 kill 父进程
    python3 experiments/ch03/orphan_demo.py --kill-group  # kill 整个进程组

两次运行的区别只有一行：``os.kill`` 还是 ``os.killpg``。
"""

from __future__ import annotations

import argparse
import os
import shutil
import signal
import subprocess
import sys
import tempfile
import time
from pathlib import Path

CHILD = (
    "import pathlib, time; "
    "time.sleep(1.5); "
    "pathlib.Path('late.txt').write_text('still alive')"
)
PARENT = (
    "import pathlib, subprocess, sys, time; "
    f"subprocess.Popen([sys.executable, '-c', {CHILD!r}]); "
    "pathlib.Path('parent.ready').write_text('1'); "
    "time.sleep(30)"
)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="孤儿进程写文件复现")
    parser.add_argument(
        "--kill-group",
        action="store_true",
        help="向进程组发 SIGKILL（修复后的行为）",
    )
    parser.add_argument("--wait", type=float, default=1.8)
    args = parser.parse_args(argv)

    root = Path(tempfile.mkdtemp(prefix="ch03-orphan-"))
    parent = subprocess.Popen(
        [sys.executable, "-c", PARENT],
        cwd=root,
        start_new_session=True,
    )

    ready = root / "parent.ready"
    deadline = time.monotonic() + 3.0
    while not ready.exists() and time.monotonic() < deadline:
        time.sleep(0.02)

    pgid = os.getpgid(parent.pid)
    print(f"parent pid={parent.pid} pgid={pgid}")
    if args.kill_group:
        os.killpg(pgid, signal.SIGKILL)
        print("sent SIGKILL to process group")
    else:
        os.kill(parent.pid, signal.SIGKILL)
        print("sent SIGKILL to parent only")

    parent.wait(timeout=3)
    time.sleep(args.wait)
    late = root / "late.txt"
    print(f"late.txt exists: {late.exists()}")
    if late.exists():
        print(f"late.txt content: {late.read_text()!r}")
    shutil.rmtree(root, ignore_errors=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
