#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""一键质量门禁：覆盖矩阵 -> 结构 -> 实验 -> 项目 -> mdbook -> 构建后检查。

用法：
    python3 tools/verify_all.py
    python3 tools/verify_all.py --no-build --no-experiments
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


def run(name: str, cmd: list[str], *, cwd: str = ROOT, timeout: int = 1200, allow_fail=False):
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
    tail = "\n".join(out.strip().splitlines()[-16:])
    print(tail)
    print(f"[{name}] exit={p.returncode} {dt:.1f}s")
    ok = p.returncode == 0
    if allow_fail:
        ok = True
    return ok, out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-build", action="store_true")
    ap.add_argument("--no-experiments", action="store_true")
    ap.add_argument("--no-projects", action="store_true")
    args = ap.parse_args()
    results = []

    ok, _ = run("coverage", [PY, "tools/build_coverage.py"])
    results.append(("coverage", ok))
    ok, _ = run("check_book", [PY, "tools/check_book.py"])
    results.append(("check_book", ok))
    ok, _ = run("snippets", [PY, "tools/check_snippets.py"])
    results.append(("snippets", ok))
    if not args.no_experiments:
        ok, _ = run("experiments", ["bash", "experiments/run_all.sh"])
        results.append(("experiments", ok))
    if not args.no_projects:
        for proj in ("minic", "validator"):
            script = os.path.join("projects", proj, "run_tests.sh")
            if os.path.exists(os.path.join(ROOT, script)):
                ok, _ = run(f"project-{proj}", ["bash", script])
                results.append((f"project-{proj}", ok))
            else:
                print(f"\n[project-{proj}] MISSING {script}")
                results.append((f"project-{proj}", False))
    if not args.no_build:
        ok, out = run("mdbook build", ["mdbook", "build", "."])
        warn = [l for l in out.splitlines() if "WARN" in l or "ERROR" in l or "Rendering failed" in l]
        if warn:
            print(f"构建警告/错误 {len(warn)} 条：")
            for l in warn[:20]:
                print("  " + l)
            ok = False
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
