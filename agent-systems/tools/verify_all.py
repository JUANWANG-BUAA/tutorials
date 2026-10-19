#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""一键质量门禁：覆盖矩阵 → 结构检查 → 实验 → mdbook build → 构建后检查。

用法：
    python3 tools/verify_all.py            # 全部
    python3 tools/verify_all.py --no-build # 跳过 mdbook（快速迭代）

任一阶段失败都会继续跑后续阶段（除非 mdbook 失败），最后汇总退出码。
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
PY = sys.executable


def run(name: str, cmd: list[str], *, cwd: str = ROOT, timeout: int = 900):
    print(f"\n=== {name} ===")
    print("$ " + " ".join(cmd))
    t0 = time.monotonic()
    try:
        p = subprocess.run(cmd, cwd=cwd, text=True, timeout=timeout,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        out = p.stdout or ""
    except subprocess.TimeoutExpired:
        print(f"TIMEOUT after {timeout}s")
        return False, ""
    dt = time.monotonic() - t0
    tail = "\n".join(out.strip().splitlines()[-12:])
    print(tail)
    print(f"[{name}] exit={p.returncode} {dt:.1f}s")
    return p.returncode == 0, out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-build", action="store_true")
    ap.add_argument("--no-experiments", action="store_true")
    args = ap.parse_args()

    results = []
    ok, _ = run("coverage", [PY, "tools/build_coverage.py"])
    results.append(("coverage", ok))
    ok, _ = run("check_book", [PY, "tools/check_book.py"])
    results.append(("check_book", ok))
    if not args.no_experiments:
        ok, _ = run("experiments", ["bash", "experiments/run_all.sh"])
        results.append(("experiments", ok))
    if not args.no_build:
        ok, _ = run("mdbook build", ["mdbook", "build", "."])
        results.append(("mdbook", ok))
        if ok:
            ok, _ = run("check_html", [PY, "tools/check_html.py"])
            results.append(("check_html", ok))

    print("\n=== SUMMARY ===")
    for name, ok in results:
        print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    return 0 if all(ok for _, ok in results) else 1


if __name__ == "__main__":
    sys.exit(main())
