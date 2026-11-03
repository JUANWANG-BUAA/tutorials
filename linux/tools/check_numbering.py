#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""节号连续性扫描：找出 H2 小节号断档与重号。

改造过程中小节会被合并、拆分、改名。丢一两个号是正常现象，但**整号缺失**
（正文里既没有该节、也没有任何链接指向它）意味着早期改写时静默丢了内容，
或者读者在目录里看到 3.1.8 直接跳 3.1.10 时会以为自己漏读了一节。

用法：
    python3 tools/check_numbering.py            # 报告全书
    python3 tools/check_numbering.py --strict   # 有断档/重号即退出 1

处理约定：不单独补号或整章重编号（会牵动全部锚点与跨章引用）。改造到哪一章，
就在该章批次里按新结构连续编号，交回报告确认「节号连续、无断档」。
"""

from __future__ import annotations

import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")

HEAD = re.compile(r"(?m)^## (\d+)\.(\d+)\.(\d+)")
TAIL = re.compile(r"(?m)^## \d+\.\d+\.\d+ (?:本章出口检查|本章小结)")


def scan():
    rows = []
    for path in sorted(glob.glob(os.path.join(SRC, "part*", "ch[0-9][0-9].md"))):
        text = open(path, encoding="utf-8").read()
        nums = [int(m.group(3)) for m in HEAD.finditer(text)]
        if not nums:
            continue
        top = max(nums)
        missing = [n for n in range(1, top + 1) if n not in nums]
        dups = sorted({n for n in nums if nums.count(n) > 1})
        tails = len(TAIL.findall(text))
        notes = []
        if missing:
            notes.append("缺 " + ",".join(str(m) for m in missing))
        if dups:
            notes.append("重 " + ",".join(str(d) for d in dups))
        if tails > 1:
            notes.append(f"章尾检查/小结有 {tails} 节，应只有 1 节")
        if notes:
            rel = os.path.relpath(path, SRC).replace(os.sep, "/")
            rows.append((rel, top, notes))
    return rows


def main() -> int:
    strict = "--strict" in sys.argv
    rows = scan()
    total_sections = len(glob.glob(os.path.join(SRC, "part*", "ch[0-9][0-9].md")))
    if not rows:
        print(f"节号连续、章尾唯一：{total_sections} 章正文无断档、无重号、无重复检查表。")
        return 0
    width = max(len(r[0]) for r in rows)
    print(f"{'chapter'.ljust(width)}{'最大节号':>8}  问题")
    for rel, top, notes in rows:
        print(f"{rel.ljust(width)}{str(top).rjust(10)}  " + "；".join(notes))
    print(f"\n{len(rows)} 章有编号或章尾问题（全书 {total_sections} 章正文）。"
          f"按约定随该章改造批处理：编号连续化；多出的检查/小结表并入唯一那张，并改「本章小结」。")
    return 1 if strict else 0


if __name__ == "__main__":
    raise SystemExit(main())
