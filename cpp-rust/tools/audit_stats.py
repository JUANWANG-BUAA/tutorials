#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""输出《C++/Rust 性能工程》章节字数、结构与元素统计。"""
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
    print(f"{'file':<26} {'lines':>6} {'H2':>3} {'boxes':>6} {'traps':>6} {'code':>5} {'layout':>7}")
    print("-" * 65)
    total_lines = 0
    total_boxes = 0
    total_traps = 0
    total_code = 0
    total_layout = 0

    for base, dirs, files in os.walk(SRC):
        for f in sorted(files):
            rel = os.path.relpath(os.path.join(base, f), SRC).replace(os.sep, "/")
            if not CH.match(rel):
                continue
            text = open(os.path.join(base, f), encoding="utf-8").read()
            lines = text.splitlines()
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

            layout = text.count('<pre class="layout">')
            print(f"{rel:<26} {len(lines):6d} {h2:3d} {boxes:6d} {len(trap_lines):6d} {code:5d} {layout:7d}")
            total_lines += len(lines)
            total_boxes += boxes
            total_traps += len(trap_lines)
            total_code += code
            total_layout += layout

    print("-" * 65)
    print(f"{'TOTAL':<26} {total_lines:6d} {' ':>3} {total_boxes:6d} {total_traps:6d} {total_code:5d} {total_layout:7d}")


if __name__ == "__main__":
    main()
