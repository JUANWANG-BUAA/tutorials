#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""输出章节统计，供 CHECK 报告与人工复核使用。"""
from __future__ import annotations

import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")
CH = re.compile(r"part([1-4])[/\\]ch(\d{2})\.md$")
FENCE = re.compile(r"^\s*(`{3,}|~{3,})(.*)$")
BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)")
H2 = re.compile(r"^##\s+(.+?)\s*$")


def main():
    print("file                         lines H2 boxes traps code layout exp")
    total = 0
    for base, dirs, files in os.walk(SRC):
        for f in sorted(files):
            rel = os.path.relpath(os.path.join(base, f), SRC).replace(os.sep, "/")
            if not CH.match(rel):
                continue
            text = open(os.path.join(base, f), encoding="utf-8").read()
            lines = text.splitlines()
            ch = int(CH.match(rel).group(2))
            in_f = False
            boxes = 0
            code = 0
            h2 = 0
            trap_lines = []
            in_traps = False
            for line in lines:
                mf = FENCE.match(line)
                if mf:
                    if not in_f and mf.group(2).strip():
                        code += 1
                    in_f = not in_f
                    continue
                if in_f:
                    continue
                if BOX.match(line):
                    boxes += 1
                mh = H2.match(line)
                if mh:
                    h2 += 1
                    if "陷阱" in mh.group(1):
                        in_traps = True
                        continue
                    elif in_traps:
                        in_traps = False
                if in_traps and re.match(r"^\s*\d+\.\s+\S", line):
                    trap_lines.append(line)
            exp = os.path.isfile(os.path.join(ROOT, "experiments", f"ch{ch:02d}", "run.sh"))
            layout = text.count('<pre class="layout">')
            print(f"{rel:28s} {len(lines):5d} {h2:2d} {boxes:5d} {len(trap_lines):5d} {code:4d} {layout:6d} {'Y' if exp else '-'}")
            total += len(lines)
    print(f"TOTAL {total}")


if __name__ == "__main__":
    main()
