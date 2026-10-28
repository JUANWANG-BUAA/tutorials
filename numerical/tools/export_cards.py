#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""export_cards — 把「闭卷回忆卡」导出成 Anki 可导入的 TSV 卡组。

用法
----
    python3 tools/export_cards.py                    # 生成 output/cards.tsv
    python3 tools/export_cards.py --stats            # 只统计解析到多少张卡
    python3 tools/export_cards.py -o my/cards.tsv    # 指定输出路径
    python3 tools/export_cards.py --tags             # 输出第三列标签（章标签）
    python3 tools/export_cards.py --only ch06        # 只导出某一章

解析对象
--------
主线各章的 `src/course/ch0{2..7}/recall-cards.md`，以及第一章
`src/ch01/recall-cards.md` 与补充篇 `src/supplement/recall-cards.md`。卡片在源文件中的形状固定：

    **A1.** 问题正文（可多行，可含 $…$ 公式与 [@锚点]）
    ::: sol
    答案正文（可多行）
    :::                              ← 答案结束（卡片结束）

输出为两列 TSV（三列时第三列为标签），头部 `#separator:tab` / `#html:true`，
Anki「文件 → 导入」直接可用（分隔符选制表符）。转换规则：

- 换行 → `<br>`（数学段 $…$ / $$…$$ 内部的物理换行折成空格，交给 MathJax 排版）；
- `**粗体**` → `<strong>`，行内代码 → `<code>`；
- `[@id]` → `(id)`：Anki 里没有站内锚点，保留编号供回到教程查证；
- 制表符替换为空格（TSV 纪律）。
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SRC = ROOT / "src"

# 卡片所在页 → 标签（Anki 第三列）
PAGES = [
    ("ch01/recall-cards.md", "第一章"),
    ("supplement/recall-cards.md", "补充篇"),
    ("course/ch02/recall-cards.md", "第2章"),
    ("course/ch03/recall-cards.md", "第3章"),
    ("course/ch04/recall-cards.md", "第4章"),
    ("course/ch05/recall-cards.md", "第5章"),
    ("course/ch06/recall-cards.md", "第6章"),
    ("course/ch07/recall-cards.md", "第7章"),
]

CARD_HEAD = re.compile(r"^\*\*([A-Z]?\d+)\.\*\*\s*(.*)$")
SOL_OPEN = re.compile(r"^:::\s*sol\s*$")
CLOSE = re.compile(r"^:::\s*$")


def strip_code(text: str) -> str:
    """去掉行内代码与围栏代码的内容，避免污染卡面。"""
    text = re.sub(r"```.*?```", "", text, flags=re.S)
    return text


def to_html(text: str) -> str:
    """把 Markdown 片段转成 Anki 能吃的 HTML。"""
    text = strip_code(text)
    # 数学段内部的物理换行折成空格，交给 MathJax 排版
    def fold_math(m):
        return re.sub(r"\s*\n\s*", " ", m.group(0))
    text = re.sub(r"\$\$.+?\$\$", fold_math, text, flags=re.S)
    text = re.sub(r"(?<!\$)\$[^$\n]+\$(?!\$)", fold_math, text)
    text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    # 行内代码
    text = re.sub(r"`([^`\n]+)`", r"<code>\1</code>", text)
    # 粗体 / 斜体
    text = re.sub(r"\*\*([^*\n]+)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"(?<!\*)\*([^*\n]+)\*(?!\*)", r"<em>\1</em>", text)
    # 站内锚点 → 纯文本编号
    text = re.sub(r"\[@([A-Za-z0-9._:\-]+)\]", r"(\1)", text)
    # 其余 markdown 链接保留文字
    text = re.sub(r"\[([^\]]+)\]\(([^)\s]+)\)", r"\1", text)
    # 换行 → <br>
    text = re.sub(r"\s*\n\s*", "<br>", text)
    # 制表符纪律
    text = text.replace("\t", " ")
    return text.strip()


def parse_page(rel: str):
    """返回 [(卡号, 问题, 答案)]。"""
    path = SRC / rel
    if not path.exists():
        return []
    lines = path.read_text(encoding="utf-8").split("\n")
    cards = []
    i = 0
    while i < len(lines):
        m = CARD_HEAD.match(lines[i].strip())
        if not m:
            i += 1
            continue
        number, first = m.group(1), m.group(2)
        question = [first]
        i += 1
        while i < len(lines) and not SOL_OPEN.match(lines[i].strip()):
            if CARD_HEAD.match(lines[i].strip()):
                break
            question.append(lines[i])
            i += 1
        # 跳过 ::: sol
        if i < len(lines) and SOL_OPEN.match(lines[i].strip()):
            i += 1
        answer = []
        while i < len(lines) and not CLOSE.match(lines[i].strip()):
            answer.append(lines[i])
            i += 1
        i += 1  # 跳过 ::: 结束
        cards.append((number, to_html("\n".join(question)), to_html("\n".join(answer))))
    return cards


def main() -> int:
    parser = argparse.ArgumentParser(description="导出闭卷回忆卡为 Anki TSV")
    parser.add_argument("-o", "--output", default=str(ROOT.parent / "output" / "cards.tsv"))
    parser.add_argument("--stats", action="store_true", help="只统计，不写文件")
    parser.add_argument("--tags", action="store_true", help="输出第三列标签")
    parser.add_argument("--only", default="", help="只导出某一章（如 ch06 / ch02 / course/ch05）")
    args = parser.parse_args()

    all_cards = []
    for rel, tag in PAGES:
        if args.only and args.only not in rel:
            continue
        for number, question, answer in parse_page(rel):
            all_cards.append((tag, number, question, answer))

    if args.stats:
        by_page = {}
        for tag, number, _, _ in all_cards:
            by_page[tag] = by_page.get(tag, 0) + 1
        for tag, count in by_page.items():
            print(f"{count:4d}  {tag}")
        print(f"共 {len(all_cards)} 张卡")
        return 0

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("w", encoding="utf-8") as fh:
        fh.write("#separator:tab\n#html:true\n")
        for tag, number, question, answer in all_cards:
            if args.tags:
                fh.write(f"{question}\t{answer}\t{tag}\n")
            else:
                fh.write(f"{question}\t{answer}\n")
    print(f"已导出 {len(all_cards)} 张卡 → {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
