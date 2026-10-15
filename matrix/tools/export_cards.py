#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""export_cards — 把「闭卷回忆卡」导出成 Anki 可导入的 TSV 卡组。

用法
----
    python3 tools/export_cards.py                    # 生成 output/cards.tsv
    python3 tools/export_cards.py --stats            # 只统计解析到多少张卡
    python3 tools/export_cards.py -o my/cards.tsv    # 指定输出路径
    python3 tools/export_cards.py --tags             # 输出第三列标签（章标签）
    python3 tools/export_cards.py --only ch03        # 只导出某一章

解析对象
--------
`src/ch0{1,2,3}/recall-cards.md`。卡片在源文件中的形状固定：

    ### D1 · 数域                     ← 卡片开始（D = 定义卡 / T = 定理卡）
    问题正文（可多行，可含 $…$ 公式与 [@锚点]）
    ::: sol D1 核对                  ← 答案开始
    答案正文（可多行）
    :::                              ← 答案结束（卡片结束）

输出为两列 TSV（三列时第三列为标签），头部 `#separator:tab` / `#html:true`，
Anki「文件 → 导入」直接可用（分隔符选制表符）。转换规则：

- 换行 → `<br>`（数学段 $…$ / $$…$$ 内部的物理换行折成空格，交给 MathJax 排版）；
- `**粗体**` → `<strong>`，行内代码 → `<code>`；
- `[@id]` → `(id)`：Anki 里没有站内锚点，保留编号供回到教程查证；
- 制表符替换为空格（TSV 纪律）。

数学公式保留 `$…$` 原样，Anki 里需装 MathJax 支持才渲染（见 memory-sheet 说明）。
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

# --------------------------------------------------------------------------- #
# 定位：脚本在 matrix/tools/ 下，源文件在 matrix/src/ 下
# --------------------------------------------------------------------------- #

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"

CHAPTERS = [
    ("ch01", "第一章"),
    ("ch02", "第二章"),
    ("ch03", "第三章"),
]

# --------------------------------------------------------------------------- #
# 解析
# --------------------------------------------------------------------------- #

CARD_RE = re.compile(r"^###\s+([DT]\d+)\s*·\s*(.+?)\s*$")
SOL_OPEN_RE = re.compile(r"^:::\s*sol\s+([DT]\d+)\s*核对\s*$")
CLOSE_RE = re.compile(r"^:::\s*$")


class Card:
    __slots__ = ("cid", "title", "front", "back", "chapter", "source")

    def __init__(self, cid, title, chapter, source):
        self.cid = cid            # "D1" / "T12"
        self.title = title        # "数域"
        self.front: list[str] = []
        self.back: list[str] = []
        self.chapter = chapter    # "第一章"
        self.source = source      # 源文件相对路径


def parse_cards(text: str, chapter: str, source: str):
    """按上面的固定形状解析出卡片列表；格式异常直接报错，不静默跳过。"""
    cards: list[Card] = []
    cur: Card | None = None
    mode: str | None = None
    last_lineno = 0

    for lineno, line in enumerate(text.splitlines(), 1):
        last_lineno = lineno
        m = CARD_RE.match(line)
        if m:
            if cur is not None:
                raise ValueError(
                    f"{source}:{lineno}: 上一张卡 {cur.cid} 还没出现 `::: sol … 核对` 或未闭合")
            cur = Card(m.group(1), m.group(2), chapter, source)
            mode = "front"
            continue
        if cur is None:
            continue
        sm = SOL_OPEN_RE.match(line)
        if sm:
            if sm.group(1) != cur.cid:
                raise ValueError(
                    f"{source}:{lineno}: 答案块编号 {sm.group(1)} 与卡 {cur.cid} 不一致")
            if mode != "front":
                raise ValueError(f"{source}:{lineno}: 卡 {cur.cid} 出现重复的答案块")
            mode = "back"
            continue
        if mode == "back" and CLOSE_RE.match(line):
            cards.append(cur)
            cur = None
            mode = None
            continue
        (cur.front if mode == "front" else cur.back).append(line)

    if cur is not None:
        raise ValueError(f"{source}:{last_lineno}: 文件结束时卡 {cur.cid} 未闭合（缺 `:::`）")
    return cards


# --------------------------------------------------------------------------- #
# 渲染（Markdown 片段 → Anki 单元格 HTML）
# --------------------------------------------------------------------------- #

# 数学段整体先行摘出，避免其中的 ** 与换行被误处理
MATH_SPAN_RE = re.compile(r"\$\$.+?\$\$|\$[^$\n]+?\$", re.S)
CODE_SPAN_RE = re.compile(r"(`+)(.+?)\1")
REF_RE = re.compile(r"\[@([A-Za-z0-9._:\-]+)\]")
STRONG_RE = re.compile(r"\*\*(?=\S)([^\n]+?)(?<=\S)\*\*")


def render_cell(lines: list[str]) -> str:
    text = "\n".join(lines).strip()
    if not text:
        return ""

    # 1) 数学段：内部的物理换行折成空格（LaTeX 换行靠 \\，不靠物理换行）
    store = []

    def stash_math(m):
        store.append(re.sub(r"\s*\n\s*", " ", m.group(0)))
        return f"\x01{len(store) - 1}\x01"

    text = MATH_SPAN_RE.sub(stash_math, text)

    # 2) 行内代码同样先摘走
    code_store = []

    def stash_code(m):
        code_store.append(m.group(2))
        return f"\x02{len(code_store) - 1}\x02"

    text = CODE_SPAN_RE.sub(stash_code, text)

    # 3) 轻量 Markdown：粗体、锚点降级
    text = STRONG_RE.sub(lambda m: "<strong>" + m.group(1) + "</strong>", text)
    text = REF_RE.sub(lambda m: "(" + m.group(1) + ")", text)

    # 4) 换行 → <br>；制表符 → 空格（TSV 纪律）
    text = text.replace("\t", " ")
    text = re.sub(r"\n{2,}", "<br><br>", text)
    text = text.replace("\n", "<br>")

    # 5) 回填
    for i, c in enumerate(code_store):
        text = text.replace(f"\x02{i}\x02", f"<code>{c}</code>")
    for i, m in enumerate(store):
        text = text.replace(f"\x01{i}\x01", m)
    return text


# --------------------------------------------------------------------------- #
# 主流程
# --------------------------------------------------------------------------- #

def collect(only: str | None):
    all_cards = []
    for folder, chapter in CHAPTERS:
        if only and folder != only:
            continue
        path = SRC / folder / "recall-cards.md"
        if not path.exists():
            print(f"export_cards: 跳过不存在的 {path.relative_to(ROOT)}", file=sys.stderr)
            continue
        rel = str(path.relative_to(ROOT))
        cards = parse_cards(path.read_text(encoding="utf-8"), chapter, rel)
        all_cards.extend(cards)
    return all_cards


def main(argv=None):
    ap = argparse.ArgumentParser(description="把闭卷回忆卡导出成 Anki TSV 卡组")
    ap.add_argument("-o", "--output", default=str(ROOT / "output" / "cards.tsv"),
                    help="输出路径（默认 matrix/output/cards.tsv）")
    ap.add_argument("--stats", action="store_true", help="只统计卡片数量，不写文件")
    ap.add_argument("--tags", action="store_true", help="输出第三列章标签（Anki tags 列）")
    ap.add_argument("--only", choices=[c[0] for c in CHAPTERS], help="只导出某一章")
    args = ap.parse_args(argv)

    cards = collect(args.only)
    if not cards:
        raise SystemExit("export_cards: 没有解析到任何卡片")

    per_chapter = {}
    for c in cards:
        per_chapter[c.chapter] = per_chapter.get(c.chapter, 0) + 1

    if args.stats:
        for ch, n in per_chapter.items():
            print(f"{ch}: {n} 张")
        print(f"合计: {len(cards)} 张（定义卡 {sum(1 for c in cards if c.cid[0] == 'D')}、"
              f"定理卡 {sum(1 for c in cards if c.cid[0] == 'T')}）")
        return 0

    out = Path(args.output)
    out.parent.mkdir(parents=True, exist_ok=True)

    header = ["#separator:tab", "#html:true"]
    if args.tags:
        header.append("#tags column:3")

    rows = []
    for c in cards:
        front = f"【{c.chapter}】{c.cid} · {c.title}<br>{render_cell(c.front)}"
        back = render_cell(c.back)
        row = [front, back]
        if args.tags:
            row.append(f"矩阵论::{c.chapter}")
        rows.append("\t".join(row))

    out.write_text("\n".join(header + rows) + "\n", encoding="utf-8")
    for ch, n in per_chapter.items():
        print(f"{ch}: {n} 张")
    print(f"已写入 {out}（共 {len(cards)} 张；Anki 导入时选「制表符」分隔）")
    return 0


if __name__ == "__main__":
    sys.exit(main())
