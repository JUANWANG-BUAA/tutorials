#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""正文体量守护：把每章与 git 上一版对比，报告汉字数与 H2 数量的增减。

教材化改造只应该让正文变厚（补定义、例题、自测），不应该丢内容。一次误用
Write 覆盖整章，会把 11 节砍成 2 节——这个脚本让这种事故当场可见。

用法：
    python3 tools/check_loss.py            # 对比 HEAD
    python3 tools/check_loss.py <ref>      # 对比指定 ref
    python3 tools/check_loss.py --verbose  # 打印跳过项
"""

from __future__ import annotations

import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
REPO = subprocess.run(["git", "-C", ROOT, "rev-parse", "--show-toplevel"],
                      capture_output=True, text=True).stdout.strip() or ROOT
# git show 的路径相对仓库根；cpp-rust 可能只是大仓库里的一个子目录。
PREFIX = os.path.relpath(ROOT, REPO).replace(os.sep, "/")
PREFIX = "" if PREFIX == "." else PREFIX + "/"

HAN = re.compile(r"[一-鿿]")
H2 = re.compile(r"^## ", re.M)

CHAPTERS = (
    [f"src/part1/ch{n:02d}.md" for n in range(1, 5)]
    + [f"src/part2/ch{n:02d}.md" for n in range(5, 9)]
    + [f"src/part3/ch{n:02d}.md" for n in range(9, 13)]
    + [f"src/part4/ch{n:02d}.md" for n in range(13, 17)]
)


def count(text: str) -> int:
    return len(HAN.findall(text))


def main() -> int:
    verbose = "--verbose" in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    ref = args[0] if args else "HEAD"

    problems = []
    rows = []

    for rel in CHAPTERS:
        shown = subprocess.run(["git", "-C", REPO, "show", f"{ref}:{PREFIX}{rel}"],
                               capture_output=True, text=True)
        if shown.returncode != 0:
            if verbose:
                print(f"跳过：{ref} 里没有 {rel}", file=sys.stderr)
            continue
        path = os.path.join(ROOT, rel)
        if not os.path.exists(path):
            problems.append(f"{rel}: 文件不见了")
            continue
        new = open(path, encoding="utf-8").read()
        c_old, c_new = count(shown.stdout), count(new)
        h_old = len(H2.findall(shown.stdout))
        h_new = len(H2.findall(new))
        rows.append((rel, c_old, c_new, f"{c_new - c_old:+d}"))

        if h_new < h_old:
            problems.append(f"{rel}: H2 小节从 {h_old} 变成 {h_new}，疑似内容丢失")
        elif c_old and c_new < c_old * 0.92:
            pct = 100 * (c_old - c_new) // c_old
            problems.append(f"{rel}: 汉字数从 {c_old} 掉到 {c_new}（-{pct}%），"
                            f"改造应只增不减")

    if not rows:
        print(f"没有可对比的章节（ref={ref}？）", file=sys.stderr)
        return 1

    width = max(len(r[0]) for r in rows)
    print(f"{'chapter'.ljust(width)}{'ref':>8}{'now':>8}{'delta':>9}")
    for rel, a, b, d in rows:
        print(f"{rel.ljust(width)}{str(a).rjust(8)}{str(b).rjust(8)}{d.rjust(9)}")

    if problems:
        print("\ncheck_loss 失败：", file=sys.stderr)
        for p in problems:
            print(f"  - {p}", file=sys.stderr)
        return 1
    print(f"\ncheck_loss 通过：{len(rows)} 章体量都没有倒退。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
