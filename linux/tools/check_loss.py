#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""正文体量守护：逐章对比 git 上一版，报告汉字数与 H2 数量的增减。

教材化改造只应该让正文变厚（补场景、例子、小结、自测），不应该丢内容。
一次误用 Write 覆盖整章，会把 18 节砍成 3 节——这个脚本让事故当场可见。

用法（工作目录 linux/）：
    python3 tools/check_loss.py            # 对比 HEAD
    python3 tools/check_loss.py <ref>      # 对比指定 ref
    python3 tools/check_loss.py --verbose  # 打印跳过项
"""

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SRC = ROOT / "src"

REPO = subprocess.run(
    ["git", "-C", str(ROOT), "rev-parse", "--show-toplevel"],
    capture_output=True,
    text=True,
).stdout.strip() or str(ROOT)
PREFIX = ROOT.relative_to(REPO).as_posix()
PREFIX = "" if PREFIX == "." else PREFIX + "/"

HAN = re.compile(r"[一-鿿]")
H2 = re.compile(r"^## ", re.M)
CHAPTER = re.compile(r"^ch\d{2}\.md$")


def chapters() -> list[Path]:
    return sorted(
        p
        for part in sorted(SRC.glob("part*"))
        for p in part.glob("ch*.md")
        if CHAPTER.match(p.name)
    )


def count(text: str) -> int:
    return len(HAN.findall(text))


def main() -> int:
    verbose = "--verbose" in sys.argv
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    ref = args[0] if args else "HEAD"

    problems: list[str] = []
    rows: list[tuple[str, int, int, str, int, int]] = []

    for path in chapters():
        rel = path.relative_to(ROOT).as_posix()
        shown = subprocess.run(
            ["git", "-C", REPO, "show", f"{ref}:{PREFIX}{rel}"],
            capture_output=True,
            text=True,
        )
        if shown.returncode != 0:
            if verbose:
                print(f"跳过：{ref} 里没有 {rel}", file=sys.stderr)
            continue
        new = path.read_text(encoding="utf-8")
        c_old, c_new = count(shown.stdout), count(new)
        h_old = len(H2.findall(shown.stdout))
        h_new = len(H2.findall(new))
        rows.append((rel, c_old, c_new, f"{c_new - c_old:+d}", h_old, h_new))

        if h_new < h_old:
            problems.append(f"{rel}: H2 小节从 {h_old} 变成 {h_new}，疑似内容丢失")
        elif c_old and c_new < c_old * 0.92:
            pct = 100 * (c_old - c_new) // c_old
            problems.append(
                f"{rel}: 汉字数从 {c_old} 掉到 {c_new}（-{pct}%），改造应只增不减"
            )

    if not rows:
        print(f"没有可对比的章节（ref={ref}？）", file=sys.stderr)
        return 1

    width = max(len(r[0]) for r in rows)
    print(f"{'chapter'.ljust(width)}{'han_ref':>9}{'han_now':>9}{'delta':>8}{'H2_ref':>8}{'H2_now':>8}")
    for rel, c_old, c_new, delta, h_old, h_new in rows:
        print(
            f"{rel.ljust(width)}{c_old:>9}{c_new:>9}{delta:>8}{h_old:>8}{h_new:>8}"
        )

    if problems:
        print("\ncheck_loss 失败：", file=sys.stderr)
        for p in problems:
            print(f"  - {p}", file=sys.stderr)
        return 1
    print(f"\ncheck_loss 通过：{len(rows)} 章体量都没有倒退。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
