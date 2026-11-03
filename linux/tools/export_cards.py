#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""export_cards — 把本书的「闭卷回忆卡」导出成 Anki 可导入的 TSV 卡组。

用法
----
    python3 tools/export_cards.py                    # 生成 output/cards.tsv
    python3 tools/export_cards.py --stats            # 只统计解析到多少张卡
    python3 tools/export_cards.py -o my/cards.tsv    # 指定输出路径
    python3 tools/export_cards.py --tags             # 输出第三列标签（章标签）
    python3 tools/export_cards.py --only part2/ch02  # 只导出某一章

解析对象
--------
`src/part*/ch*-recall.md`。两代卡片形状都认（与矩阵论同源，盒子语法不同）：

新式（part1/part2，外层 method 盒）：

    ::: method 回忆 1 · 三层对象与一次手推   ← 卡片开始
    问题正文（可多行，可含 $…$ 公式与 [@锚点]）
    ::: sol 答案                            ← 答案开始
    答案正文（可多行）
    :::                                     ← 答案结束
    :::                                     ← 卡片结束

旧式（part0，与矩阵论 recall-cards 同构）：

    ### D1 · 三个 fd                        ← 卡片开始（D = 概念卡 / T = 用法卡）
    问题正文
    ::: sol D1 核对                         ← 答案开始
    答案正文
    :::                                     ← 卡片结束

输出为两列 TSV（三列时第三列为标签），头部 `#separator:tab` / `#html:true`，
Anki「文件 → 导入」直接可用（分隔符选制表符）。转换规则与矩阵论一致：

- 换行 → `<br>`（数学段 $…$ / $$…$$ 内部的物理换行折成空格，交给 MathJax 排版）；
- `**粗体**` → `<strong>`，行内代码 → `<code>`；
- `[@id]` → `(id)`：Anki 里没有站内锚点，保留编号供回到教程查证；
- 制表符替换为空格（TSV 纪律）。

数学公式保留 `$…$` 原样，Anki 里需装 MathJax 支持才渲染。
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"

CARD_RE = re.compile(r"^:::\s*[A-Za-z]+\s+回忆\s+(\d+)\s*·\s*(.+?)\s*$")
# 旧式（part0，与矩阵论同构）：`### D1 · 三个 fd` + `::: sol D1 核对`
OLD_CARD_RE = re.compile(r"^###\s+([DT]\d+)\s*·\s*(.+?)\s*$")
OLD_SOL_RE = re.compile(r"^:::\s*sol\s+([DT]\d+)\s*核对\s*$")
SOL_RE = re.compile(r"^:::\s*sol\b")
OPEN_BOX = re.compile(r"^\s*:::\s*[A-Za-z]")
CLOSE_RE = re.compile(r"^\s*:::\s*$")


class Card:
    __slots__ = ("cid", "title", "front", "back", "chapter", "source")

    def __init__(self, cid, title, chapter, source):
        self.cid = cid            # "回忆 3"
        self.title = title
        self.front: list[str] = []
        self.back: list[str] = []
        self.chapter = chapter    # "2.2"
        self.source = source


def chapter_label(rel: str) -> str:
    """src/part2/ch02-recall.md → 2.2；src/part0/ch05-recall.md → 0.5。"""
    m = re.search(r"part(\d+)/ch(\d+)-recall\.md$", rel)
    if m:
        return f"{m.group(1)}.{int(m.group(2))}"
    return rel


def parse_cards(text: str, chapter: str, source: str):
    """按上面的固定形状解析；格式异常报错，不静默跳过。

    两代形状共用一套深度计数：
      新式卡 = 回忆 盒一层（depth 从 1 起），内含 sol 盒一层，`:::` 到 0 收卡；
      旧式卡 = `### D1` 标题起（depth 从 0 起），`::: sol D1 核对` 起答案，
               首个 `:::` 收卡；没有 sol 的旧卡在下一张卡标题处收（背面留空）。
    """
    cards: list[Card] = []
    cur: Card | None = None
    mode: str | None = None      # "front" / "back"
    style = ""                   # "new" / "old"
    depth = 0
    last_lineno = 0

    def close_card(lineno: int, warn_no_sol: bool = True):
        nonlocal cur, mode, style, depth
        if cur is None:
            return
        if warn_no_sol and mode == "front":
            print(f"export_cards: 警告 {source}:{lineno}: 卡 {cur.cid} 没有答案盒，"
                  "导出为空背面", file=sys.stderr)
        cards.append(cur)
        cur, mode, style, depth = None, None, "", 0

    for lineno, line in enumerate(text.splitlines(), 1):
        last_lineno = lineno

        m = CARD_RE.match(line)
        om = OLD_CARD_RE.match(line)
        if m or om:
            if cur is not None:
                close_card(lineno, warn_no_sol=(style == "new"))
            if m:
                cur = Card(f"回忆 {m.group(1)}", m.group(2), chapter, source)
                style, depth = "new", 1
            else:
                cur = Card(om.group(1), om.group(2), chapter, source)
                style, depth = "old", 0
            mode = "front"
            continue
        if cur is None:
            continue

        if CLOSE_RE.match(line):
            depth -= 1
            if depth <= 0:
                close_card(lineno)
                continue
            # 内嵌盒子的 `:::` 标记不进单元格；盒子内容照常保留
            continue

        if OPEN_BOX.match(line):
            if SOL_RE.match(line) and depth == (1 if style == "new" else 0):
                if mode != "front":
                    raise ValueError(f"{source}:{lineno}: 卡 {cur.cid} 出现重复的答案块")
                osm = OLD_SOL_RE.match(line)
                if style == "old" and osm and osm.group(1) != cur.cid:
                    raise ValueError(
                        f"{source}:{lineno}: 答案块编号 {osm.group(1)} 与卡 {cur.cid} 不一致")
                mode = "back"
                depth += 1
                continue
            depth += 1
            # 内嵌盒子的 `::: xxx` 标记行不进单元格（Anki 里无渲染意义）
            continue

        (cur.front if mode == "front" else cur.back).append(line)

    if cur is not None:
        raise ValueError(f"{source}:{last_lineno}: 文件结束时卡 {cur.cid} 未闭合（缺 `:::`）")
    return cards


# --------------------------------------------------------------------------- #
# 渲染（Markdown 片段 → Anki 单元格 HTML）
# --------------------------------------------------------------------------- #

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
    paths = sorted(SRC.glob("part*/ch*-recall.md"))
    for path in paths:
        rel = str(path.relative_to(ROOT))
        stem = rel.split("/", 1)[1][:4]          # "ch02"
        key = f"{rel.split('/')[0]}/{stem}"       # "part2/ch02"
        if only and only.rstrip("/") not in (key, rel):
            continue
        chapter = chapter_label(rel)
        cards = parse_cards(path.read_text(encoding="utf-8"), chapter, rel)
        all_cards.extend(cards)
    return all_cards


def main(argv=None):
    ap = argparse.ArgumentParser(description="把闭卷回忆卡导出成 Anki TSV 卡组")
    ap.add_argument("-o", "--output", default=str(ROOT / "output" / "cards.tsv"),
                    help="输出路径（默认 linux/output/cards.tsv）")
    ap.add_argument("--stats", action="store_true", help="只统计卡片数量，不写文件")
    ap.add_argument("--tags", action="store_true", help="输出第三列章标签（Anki tags 列）")
    ap.add_argument("--only", help="只导出某一章（如 part2/ch02）")
    args = ap.parse_args(argv)

    cards = collect(args.only)
    if not cards:
        raise SystemExit("export_cards: 没有解析到任何卡片")

    per_chapter: dict[str, int] = {}
    for c in cards:
        per_chapter[c.chapter] = per_chapter.get(c.chapter, 0) + 1

    if args.stats:
        for ch, n in sorted(per_chapter.items()):
            print(f"{ch}: {n} 张")
        print(f"合计: {len(cards)} 张")
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
            row.append(f"Linux::{c.chapter}")
        rows.append("\t".join(row))

    out.write_text("\n".join(header + rows) + "\n", encoding="utf-8")
    for ch, n in sorted(per_chapter.items()):
        print(f"{ch}: {n} 张")
    print(f"已写入 {out}（共 {len(cards)} 张；Anki 导入时选「制表符」分隔）")
    return 0


if __name__ == "__main__":
    sys.exit(main())
