#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目静态检查：Python 语法、Shell 语法、README/测试/故障脚本是否齐全。

用法：
    python3 tools/check_projects.py            # 只做静态检查
    python3 tools/check_projects.py --run      # 额外跑两个项目的 unittest
"""

from __future__ import annotations

import os
import py_compile
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
PROJECTS = os.path.join(ROOT, "projects")

REQUIRED = {
    "idempotent-tool": ["server.py", "client.py", "chaos_proxy.py", "test_server.py",
                        "fault_inject.sh", "README.md"],
    "replicated-kv": ["raft_node.py", "kv_client.py", "test_kv.py",
                      "fault_inject.sh", "run_cluster.sh", "README.md"],
}


def run(cmd, cwd=None):
    return subprocess.run(cmd, cwd=cwd, stdout=subprocess.PIPE,
                          stderr=subprocess.STDOUT, text=True)


def main(argv):
    problems = []
    py_files, sh_files = [], []
    for dirpath, _, files in os.walk(PROJECTS):
        for fn in files:
            path = os.path.join(dirpath, fn)
            if fn.endswith(".py"):
                py_files.append(path)
            elif fn.endswith(".sh"):
                sh_files.append(path)

    for path in sorted(py_files):
        try:
            py_compile.compile(path, doraise=True)
        except py_compile.PyCompileError as exc:
            problems.append(f"py_compile: {os.path.relpath(path, ROOT)}: {exc.msg}")

    for path in sorted(sh_files):
        r = run(["bash", "-n", path])
        if r.returncode != 0:
            problems.append(f"bash -n: {os.path.relpath(path, ROOT)}: {r.stdout.strip()}")

    for proj, files in REQUIRED.items():
        for fn in files:
            if not os.path.exists(os.path.join(PROJECTS, proj, fn)):
                problems.append(f"missing: projects/{proj}/{fn}")

    print(f"python files: {len(py_files)}   shell files: {len(sh_files)}")
    if problems:
        print("\n问题:")
        for p in problems:
            print(f"  - {p}")
    if "--run" in argv:
        for proj, pattern in [("idempotent-tool", "test_*.py"), ("replicated-kv", "test_*.py")]:
            r = run([sys.executable, "-m", "unittest", "discover", "-s",
                     os.path.join(PROJECTS, proj), "-p", pattern, "-v"])
            print(f"\n[{proj}] exit={r.returncode}")
            print(r.stdout[-3000:])
            if r.returncode != 0:
                problems.append(f"unittest failed: {proj}")
    print("\nOK" if not problems else "\nFAILED")
    return 0 if not problems else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
