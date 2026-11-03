#!/usr/bin/env python3
"""行文腔调检查器（见 写作规范/STYLE.md）。

按「每千字密度」判定，避免长章被绝对次数误伤。

用法：
    python3 mlm/tools/check_style.py --book mlm/src/part2/ch13.md
    python3 mlm/tools/check_style.py --all
退出码 0 = 全部达标；1 = 有超限项。
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import sys

# (名称, 正则, 每千字上限, 说明)
PATTERNS = [
    ("对偶句", r"不是[^。；\n]{2,24}?而是", 0.30, "「不是A而是B」"),
    ("对偶短句", r"不是[^。；\n]{2,24}?，是", 0.15, "「不是A，是B」"),
    ("正是", r"正是", 0.30, "口头禅式收尾"),
    ("值得注意", r"值得注意|更有意思的是|耐人寻味", 0.10, "空转插入语"),
    ("一句话", r"一句话[：:]|换句话说", 0.15, "重复表述"),
    ("自我辩护", r"必须说清|必须承认|需要强调的是", 0.15, "自我辩护腔"),
    ("填充词", r"这里|这一点", 0.50, "起手式填充"),
]

# 引文块内的文字不计（blockquote 里是原著原话，不该被改）
CITE_RE = re.compile(r"^>.*$", re.M)
FENCE_RE = re.compile(r"```.*?```", re.S)
CODE_INLINE_RE = re.compile(r"`[^`]*`")


def strip_nonprose(text: str) -> str:
    text = FENCE_RE.sub("", text)
    text = CODE_INLINE_RE.sub("", text)
    text = CITE_RE.sub("", text)
    return text


def cjk_len(s: str) -> int:
    s = re.sub(r"\s+", "", s)
    return len(s)


def analyse(path: str):
    raw = open(path, encoding="utf-8").read()
    body = strip_nonprose(raw)
    n = cjk_len(body)
    if n == 0:
        return None
    rows = []
    for name, pat, limit, note in PATTERNS:
        hits = re.findall(pat, body)
        cnt = len(hits)
        dens = cnt / n * 1000
        rows.append((name, note, cnt, dens, limit, cnt > 0 and dens > limit))
    return n, rows


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--book")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    if args.book:
        files = [os.path.abspath(args.book)]
    elif args.all:
        files = sorted(glob.glob(os.path.join(root, "src", "part*", "*.md")))
    else:
        files = sorted(glob.glob(os.path.join(root, "src", "part2", "*.md")))

    bad_files = 0
    print(f"{'文件':<14}{'字数':>7}  超标项（次数 / 每千字 / 上限）")
    print("-" * 72)
    for f in files:
        res = analyse(f)
        if res is None:
            continue
        n, rows = res
        over = [r for r in rows if r[5]]
        mark = "✗ " if over else "  "
        if over:
            print(f"{mark}{os.path.basename(f):<12}{n:>7}")
            for name, note, cnt, dens, limit, _ in over:
                print(f"      · {name:<10}{cnt:>4} 次  {dens:>5.2f}/千字  上限 {limit:.2f}  {note}")
        else:
            print(f"{mark}{os.path.basename(f):<12}{n:>7}  达标")
        if args.verbose:
            for name, note, cnt, dens, limit, _ in rows:
                if cnt:
                    print(f"        {name:<10}{cnt:>4} 次  {dens:>5.2f}/千字")
        if over:
            bad_files += 1
    print("-" * 72)
    print(f"达标 {len(files) - bad_files} / {len(files)}")
    return 0 if bad_files == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
