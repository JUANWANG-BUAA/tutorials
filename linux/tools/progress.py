#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""按章统计正文完成度：每节是否达到「preview + 小结 + 即时自测 + ≥550 汉字」。

用法：
    python3 tools/progress.py            # 全书
    python3 tools/progress.py part1      # 只统计第 1 篇
    python3 tools/progress.py --md       # 输出可直接贴进 READINESS 的表格行
"""

from __future__ import annotations

import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.normpath(os.path.join(HERE, "..", "src"))
HAN = re.compile(r"[\u4e00-\u9fff]")
H2 = re.compile(r"^## (.+)$", re.M)
MIN_HAN = 550


def sections(text: str):
    parts = re.split(r"^(## .*)$", text, flags=re.M)
    for i in range(1, len(parts), 2):
        title = parts[i][3:].strip()
        yield title, parts[i + 1]


def audit(path: str):
    text = open(path, encoding="utf-8").read()
    rows = []
    for title, body in sections(text):
        if title.startswith("母本对应"):
            continue
        n = len(HAN.findall(body))
        # 「本章小结」「本章出口检查」是收口节，不要求 preview 开盒
        closing = "小结" in title or "出口检查" in title
        ok = (
            n >= MIN_HAN
            and (closing or re.search(r"^::: preview", body, re.M) is not None)
            and (closing or "小结" in body)
            and "即时自测" in body
        )
        rows.append((title, n, ok))
    return rows, len(HAN.findall(text))


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    md = "--md" in sys.argv
    filter_ = args[0] if args else ""
    for path in sorted(glob.glob(os.path.join(SRC, "part*", "ch[0-9][0-9].md"))):
        rel = os.path.relpath(path, SRC).replace(os.sep, "/")
        if filter_ and not rel.startswith(filter_):
            continue
        rows, total = audit(path)
        done = sum(1 for _, _, ok in rows if ok)
        kits = len(glob.glob(path.replace(".md", "-*.md")))
        if md:
            print(f"| {rel} | {len(rows)} | {done}/{len(rows)} | {kits}/6 | {total} |")
        else:
            print(f"{rel:22s} {done:3d}/{len(rows):<3d} 套件{kits}/6 {total:7d} 汉字")
            if "--detail" in sys.argv:
                for title, n, ok in rows:
                    if not ok:
                        print(f"    - {title[:44]:46s} {n:5d}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
