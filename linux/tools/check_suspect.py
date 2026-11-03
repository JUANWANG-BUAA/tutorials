#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""可疑输出扫描：找出「像是真跑出来、其实可能是编的」代码块。

教材里最危险的不是错字，是一段看起来非常真的终端输出。固定 PID、固定内存数值、
`[+] 2301` 这种行，如果块里没有「实测 / 未实测」的口径标注，读者就会当成可复现
的事实。本脚本按章计数，改造某一章时把属于它的条目清零。

用法：
    python3 tools/check_suspect.py              # 全书报告（非阻塞）
    python3 tools/check_suspect.py part0/ch09   # 只看一章
    python3 tools/check_suspect.py --strict     # 有可疑即退出 1

判据是启发式的，命中不等于一定是编的：处置方式只有两种——在真机上重跑换成
真输出，或改写成「怎么观察 + 看到什么算命中」的判读描述。留在原样不算处置。
"""

from __future__ import annotations

import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.normpath(os.path.join(HERE, "..", "src"))

# 开栏语言标签必须全部吃掉：只认 text/sh 之类会让 ```c 的收栏被当成下一块的开栏，
# 配对整体错位一格，把正文段落当代码块扫（ch08 就因此误报过一次）。
BLOCK = re.compile(r"```[A-Za-z0-9_+.-]*\n(.*?)```", re.S)
# 看起来像运行现场的具体值：PID、RSS/VSZ 具体 KB、固定耗时、内存地址
TELLTALES = [
    # 「像是刚跑出来的现场」而不是「示例命令里的占位数字」
    re.compile(r"\bpid[=\s]+(\d{3,6})\b.*\n", re.I),
    re.compile(r"\bPID\s+\d{3,6}\b"),
    re.compile(r"\[pid\s+\d{3,6}\]"),
    re.compile(r"\bVm(RSS|Size):\s+\d+\s*kB"),
    re.compile(r"\breal\s+\d+m\d+\.\d+s\b"),
    re.compile(r"^\s*\[\d+\]\s*[+-]?\s*\d+.*\b(Exit|Done|Stopped|Running)\b", re.M),
]
MARKED = ("实测", "未实测", "示例输出", "示意", "形如")


def scan(rel_filter: str):
    rows = []
    for path in sorted(glob.glob(os.path.join(SRC, "part*", "ch[0-9][0-9].md"))):
        rel = os.path.relpath(path, SRC).replace(os.sep, "/")
        if rel_filter and not rel.startswith(rel_filter):
            continue
        text = open(path, encoding="utf-8").read()
        hits = []
        for block in BLOCK.finditer(text):
            body = block.group(1)
            if any(m in body for m in MARKED):
                continue
            line_no = text[:block.start()].count("\n") + 1
            which = [p.pattern for p in TELLTALES if p.search(body)]
            if which:
                hits.append((line_no, which[0][:26], body.strip().splitlines()[0][:44]))
        if hits:
            rows.append((rel, hits))
    return rows


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    strict = "--strict" in sys.argv
    rows = scan(args[0] if args else "")
    total = sum(len(h) for _, h in rows)
    if not rows:
        print("没有可疑输出块（含具体运行现场数值但未标口径的块为 0）。")
        return 0
    for rel, hits in rows:
        print(f"{rel}  {len(hits)} 处")
        for line, pat, first in hits:
            print(f"   第 {line} 行  [{pat}]  {first}")
    print(f"\n合计 {total} 处，分布在 {len(rows)} 章。"
          f"改造到某章时逐块处置：真机重跑换真输出，或改成判读描述。")
    return 1 if strict else 0


if __name__ == "__main__":
    raise SystemExit(main())
