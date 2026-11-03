#!/usr/bin/env python3
"""第二篇（政治经济学）深度检查器。

判据来自 mlm/写作规范/CHAPTER-STANDARD.md：旧稿的病是「一节只有三段」，
所以这里量的不是总字数，而是**每一节有没有走到推导与算例**。

用法：
    python3 mlm/tools/check_depth.py                 # 检查全部 part2
    python3 mlm/tools/check_depth.py --book x.md     # 只查一章
    python3 mlm/tools/check_depth.py --all           # 查全部章（含第二篇以外）
退出码 0 表示全部达标，1 表示有缺口。
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import statistics
import sys

# 达标线。理论章要求比历史/实践章高——理论章不推导，等于没写。
GATE_THEORY = {
    "chapter_chars": 20000,
    "min_section": 900,
    "tables": 3,
    "exercises": 6,
    "formulas": 4,
    "deferrals": 2,
}
# 第二篇按原著结构制逐步改为《资本论》逐篇精读，
# 精读章下限 30000（CHAPTER-STANDARD §2）；现有 ch08–10 均在 32k 以上。
GATE_CLOSE_READING = {
    "chapter_chars": 30000,
    "min_section": 900,
    "tables": 3,
    "exercises": 6,
    "formulas": 4,
    "deferrals": 2,
}
GATE_HISTORY = {
    "chapter_chars": 15000,
    "min_section": 900,
    "tables": 2,
    "exercises": 4,
    "formulas": 1,
    "deferrals": 2,
}
GATE_FRONT = {
    "chapter_chars": 3000,
    "min_section": 300,
    "tables": 0,
    "exercises": 0,
    "formulas": 0,
    "deferrals": 4,
}

# 篇 → 达标线
PART_GATE = {
    "part1": GATE_THEORY,    # 唯物史观与辩证法
    "part2": GATE_CLOSE_READING,  # 政治经济学批判（原著逐篇精读）
    "part3": GATE_THEORY,    # 国家、革命与专政
    "part4": GATE_HISTORY,   # 工人运动实践史
    "part5": GATE_HISTORY,   # 中国革命与毛泽东的理论
    "part6": GATE_THEORY,    # 当代问题与方法训练
}


def gate_for(path: str) -> dict:
    m = re.search(r"/(part\d)/", path)
    if m:
        return PART_GATE[m.group(1)]
    return GATE_FRONT

TRANSITION = "<!-- transition -->"
SEC_RE = re.compile(r"\n(?=## )")


def cjk_len(s: str) -> int:
    """按字符数计，去掉空白与标记符，避免被 markdown 语法虚增。"""
    s = re.sub(r"```.*?```", "", s, flags=re.S)
    s = re.sub(r"\s+", "", s)
    return len(s)


def split_sections(text: str):
    parts = SEC_RE.split(text)
    head, secs = parts[0], []
    for p in parts[1:]:
        m = re.match(r"##\s+(.+)", p)
        if m:
            secs.append((m.group(1).strip(), p))
    return head, secs


def count_tables(text: str) -> int:
    """含 >=3 行且至少 6 个数字的表格，视为一个真正的算例表。"""
    n = 0
    for block in re.split(r"\n\s*\n", text):
        lines = [l for l in block.splitlines() if l.strip().startswith("|")]
        if len(lines) >= 4 and sum(len(re.findall(r"\d", l)) for l in lines) >= 12:
            n += 1
    return n


def analyse(path: str, GATE: dict) -> dict:
    text = open(path, encoding="utf-8").read()
    head, secs = split_sections(text)
    lens = []
    thin = []
    for title, body in secs:
        n = cjk_len(body)
        lens.append(n)
        if n < GATE["min_section"] and TRANSITION not in body:
            thin.append((n, title))
    return {
        "path": path,
        "chars": cjk_len(text),
        "sections": len(secs),
        "median": int(statistics.median(lens)) if lens else 0,
        "thin": thin,
        "tables": count_tables(text),
        "exercises": len(re.findall(r"^::: ex\b", text, re.M)),
        "solutions": len(re.findall(r"^::: sol\b", text, re.M)),
        "formulas": len(re.findall(r"\$\$", text)) // 2,
        "deferrals": len(re.findall(r"第\s*\d+\s*章[会再将在]", text)),
        "boxes": len(re.findall(r"^:::\s(?:arg|src|debate|method|errata|def|thm|ex)\b", text, re.M)),
    }


def verdict(m: dict, GATE: dict) -> list[str]:
    gaps = []
    if m["chars"] < GATE["chapter_chars"]:
        gaps.append(f"总字数 {m['chars']} < {GATE['chapter_chars']}（缺 {GATE['chapter_chars'] - m['chars']}）")
    if m["thin"]:
        gaps.append(f"{len(m['thin'])} 节低于 {GATE['min_section']} 字")
    if m["tables"] < GATE["tables"]:
        gaps.append(f"算例表 {m['tables']} < {GATE['tables']}")
    if m["exercises"] < GATE["exercises"]:
        gaps.append(f"练习 {m['exercises']} < {GATE['exercises']}")
    if m["formulas"] < GATE["formulas"]:
        gaps.append(f"公式块 {m['formulas']} < {GATE['formulas']}")
    if m["deferrals"] > GATE["deferrals"]:
        gaps.append(f"「见第 X 章」{m['deferrals']} 处 > {GATE['deferrals']}")
    return gaps


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--book", help="只检查一个文件")
    ap.add_argument("--all", action="store_true", help="检查 part*/ 全部章节")
    ap.add_argument("--verbose", action="store_true", help="打印每节字数")
    ap.add_argument("--summary", action="store_true", help="只打印表格，不展开缺口")
    args = ap.parse_args()

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    src = os.path.join(root, "src")
    if args.book:
        files = [os.path.abspath(args.book)]
    elif args.all:
        files = sorted(glob.glob(os.path.join(src, "part*", "*.md")))
    else:
        files = sorted(glob.glob(os.path.join(src, "part2", "*.md")))

    bad = 0
    print(f"{'文件':<22}{'字数':>7}{'节':>4}{'中位':>6}{'表':>4}{'练':>4}{'式':>4}{'引':>4}")
    print("-" * 56)
    for f in files:
        G = gate_for(f)
        m = analyse(f, G)
        gaps = verdict(m, G)
        mark = "  " if not gaps else "✗ "
        print(f"{mark}{os.path.basename(f):<20}{m['chars']:>7}{m['sections']:>4}"
              f"{m['median']:>6}{m['tables']:>4}{m['exercises']:>4}"
              f"{m['formulas']:>4}{m['deferrals']:>4}")
        if args.verbose:
            _, secs = split_sections(open(f, encoding="utf-8").read())
            for title, body in secs:
                print(f"      {cjk_len(body):5d}  {title[:52]}")
        if not args.summary:
            for g in gaps:
                print(f"      - {g}")
            for n, title in m["thin"]:
                print(f"      · 薄节 {n:4d} 字：{title[:48]}")
        if gaps:
            bad += 1
    print("-" * 56)
    print(f"达标 {len(files) - bad} / {len(files)}")
    return 0 if bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
