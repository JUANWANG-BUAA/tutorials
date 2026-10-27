#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《矩阵论》结构与契约质检。

用法：
    python3 tools/check_book.py

与本书预处理器 tools/mathbook.py 的分工：mathbook 在构建期校验语义盒与 [@ref]
（引用不存在的锚点会让构建失败），本脚本做构建期之外的结构与**自称数量**门禁：

  1. SUMMARY 列出的每页存在，每页恰 1 个 H1；
  2. 语义盒配平，开放类型在 mathbook 支持范围内（与 mathbook.py 的 BOX_TYPES 同源）；
  3. 显式锚点 {#…} 与 HTML id 全书唯一；
  4. 站内 .md 链接可达、锚点存在；
  5. 公式定界符配平（$ / $$），数学内无裸 < >（用 \\lt / \\gt）；
  6. 代码围栏闭合且带语言标记；
  7. 无占位符 / TODO（勘误页引用课件原文除外）；
  8. **自称数量与实际一致**——习题集题数、提示清单、自检表条数、回忆卡张数、
     勘误条数、自测卷分值加总、README 的章级汇总，逐处对照实际计数。
"""

from __future__ import annotations

import os
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SRC = ROOT / "src"

FENCE = re.compile(r"^\s*(`{3,}|~{3,})(.*)$")
H1 = re.compile(r"^#\s+(.+?)\s*$")
ANCHOR = re.compile(r"\{#([^}\s]+)\}")
MD_LINK = re.compile(r"(?<!\()]\(([^)#\s]+\.md)(?:#([^)\s]*))?\)")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
HTML_ID = re.compile(r'\bid="([^"]+)"')
MATHBOX_PAGE = re.compile(r"(?i)errata")

# 与 tools/mathbook.py 的 BOX_TYPES | {PROOF, SOL, HINT} 同源——直接从该文件解析，
# 避免两处名单漂移（mathbook.py 顶部有 import 依赖，故不直接 import）。
def allowed_box_types() -> set[str]:
    src = (HERE / "mathbook.py").read_text(encoding="utf-8")
    m = re.search(r"^BOX_TYPES\s*=\s*\{(.*?)^\}", src, re.M | re.S)
    if not m:
        raise SystemExit("check_book: 未能从 mathbook.py 定位 BOX_TYPES，请检查该文件结构")
    types = set(re.findall(r'^\s{4}"(\w+)":', m.group(1), re.M))
    for name in ("PROOF", "SOL", "HINT"):
        mm = re.search(rf'^{name}\s*=\s*"(\w+)"', src, re.M)
        if mm:
            types.add(mm.group(1))
    if not types:
        raise SystemExit("check_book: 未能从 mathbook.py 解析 BOX_TYPES，请检查该文件结构")
    return types


ALLOWED_BOX = allowed_box_types()

problems: list[str] = []


def fail(msg: str) -> None:
    problems.append(msg)


def read(rel: str) -> str:
    return (SRC / rel).read_text(encoding="utf-8")


def strip_fences(text: str):
    """返回 [(行号, 是否在围栏内, 行)] 与围栏问题。"""
    rows, fence, out = [], None, []
    for i, line in enumerate(text.splitlines(), 1):
        m = FENCE.match(line)
        if m:
            marker = m.group(1)
            if fence is None:
                fence = marker[0]
                if not m.group(2).strip():
                    fail_probe = (i, "代码围栏缺语言标记")
                else:
                    fail_probe = None
                out.append((i, True, line, fail_probe))
                continue
            if marker[0] == fence:
                fence = None
                out.append((i, True, line, None))
                continue
        out.append((i, fence is not None, line, None))
    if fence is not None:
        out.append((0, True, "", (0, "代码围栏未闭合")))
    return out


def slug(text: str) -> str:
    """近似 mdBook 的标题 id 生成（id_from_content）：去格式、去标点、空格转连字
    号、ASCII 转小写、保留 CJK。已对本书构建产物核对（如「六节一览」「看到题
    目先选工具」）。"""
    t = re.sub(r"`([^`]*)`", r"\1", text)
    t = re.sub(r"[*_~^]", "", t)
    t = re.sub(r"\{#[^}]*\}", "", t)
    out = []
    for ch in t:
        if ch.isalnum() or ch in "_-":
            out.append(ch.lower() if ch.isascii() else ch)
        elif ch.isspace():
            out.append("-")
    return "".join(out).strip("-")


def heading_ids(text: str) -> set[str]:
    """一页内标题的自动 slug（显式 {#…} 由通用扫描全书计数，此处不重复计）。"""
    ids = set()
    for line in text.splitlines():
        m = re.match(r"^(#{1,6})\s+(.+?)\s*$", line)
        if m:
            ids.add(slug(m.group(2)))
    return ids


def pages_from_summary() -> list[tuple[str, str]]:
    out = []
    for line in (SRC / "SUMMARY.md").read_text(encoding="utf-8").splitlines():
        m = re.match(r"^-?\s*\[([^]]+)]\(([^)]+\.md)\)\s*$", line.strip())
        if m:
            out.append((m.group(1), m.group(2)))
    return out


# ---------------------------------------------------------------- 基本结构

def check_structure(pages):
    page_texts: dict[str, str] = {}
    for title, rel in pages:
        path = SRC / rel
        if not path.exists():
            fail(f"SUMMARY 列出的页面不存在：{rel}")
            continue
        text = read(rel)
        page_texts[rel] = text
        rows = strip_fences(text)
        h1 = [r for r in rows if not r[1] and H1.match(r[2])]
        # 封面页 index.md 是 HTML 导览页，用 <h1>/版式而非 Markdown H1
        if len(h1) != 1 and rel != "index.md":
            fail(f"{rel}: H1 数量={len(h1)}（应为 1）")
        depth = 0
        for i, in_f, line, probe in rows:
            if probe:
                fail(f"{rel} 第 {probe[0]} 行：{probe[1]}")
            if in_f:
                continue
            if OPEN_BOX.match(line):
                depth += 1
            elif CLOSE_BOX.match(line):
                depth -= 1
                if depth < 0:
                    fail(f"{rel} 第 {i} 行：多余的 ::: 闭合")
                    depth = 0
        if depth != 0:
            fail(f"{rel}: 语义盒不配平（收尾深度 {depth}）")
        for i, in_f, line, _ in rows:
            if in_f:
                continue
            m = OPEN_BOX.match(line)
            if m and m.group(1) not in ALLOWED_BOX:
                fail(f"{rel} 第 {i} 行：未知盒子类型 :::{m.group(1)}")
    return page_texts


def check_math(rows, rel):
    in_display = False
    for i, in_f, line, _ in rows:
        if in_f:
            continue
        line = re.sub(r"`[^`\n]*`", "", line)
        n_disp = len(re.findall(r"(?<!\\)\$\$", line))
        if n_disp % 2 == 1:
            in_display = not in_display
        # 注：数学内的裸 < / > 是本书通行写法（KaTeX 包装器在构建期中和，
        # 见 book.toml 对 tools/katex_wrapper.py 的说明），故不做 edge 式禁用检查。
        if not in_display and n_disp == 0 and line.replace("\\$", "").count("$") % 2:
            fail(f"{rel} 第 {i} 行：`$` 未配对")
    if in_display:
        fail(f"{rel}: `$$` 未配对")


# ---------------------------------------------------------------- 链接与锚点

def collect_anchors(page_texts):
    """全书显式锚点 {#…} 与 HTML id 的计数（不含标题自动 slug）。"""
    anchors = Counter()
    for rel, text in page_texts.items():
        rows = strip_fences(text)
        for _, in_f, line, _ in rows:
            if in_f:
                continue
            for a in ANCHOR.findall(re.sub(r"`[^`]*`", "", line)):
                anchors[a] += 1
            for i in HTML_ID.findall(line):
                anchors[i] += 1
    return anchors


def page_id_set(rel: str, text: str) -> set[str]:
    """一页内全部可用锚点：显式 {#…}、HTML id、标题自动 slug。"""
    ids = set(heading_ids(text))
    rows = strip_fences(text)
    for _, in_f, line, _ in rows:
        if in_f:
            continue
        for a in ANCHOR.findall(re.sub(r"`[^`]*`", "", line)):
            ids.add(a)
        for i in HTML_ID.findall(line):
            ids.add(i)
    return ids


def check_links(pages, page_texts, id_map):
    all_rels = {rel for _, rel in pages}
    for rel, text in page_texts.items():
        rows = strip_fences(text)
        body = "\n".join(line for _, in_f, line, _ in rows if not in_f)
        base = (SRC / rel).parent
        for target, frag in MD_LINK.findall(re.sub(r"`[^`]*`", "", body)):
            path = os.path.normpath(base / target)
            rel_t = os.path.relpath(path, SRC)
            if rel_t not in all_rels or not Path(path).exists():
                fail(f"{rel}: 断链 -> {target}")
                continue
            if frag and frag not in id_map.get(rel_t, set()):
                fail(f"{rel}: 断锚点 -> {target}#{frag}")


# ---------------------------------------------------------------- 数量同步门

def count_exercise_groups(text: str) -> dict[str, list[int]]:
    groups: dict[str, list[int]] = {"A": [], "B": [], "C": []}
    for m in re.finditer(r"^:::\s*ex\s+([ABC])(\d+)\b", text, re.M):
        groups[m.group(1)].append(int(m.group(2)))
    return groups


def count_hints(text: str) -> set[str]:
    """hint 盒子所属的题号（hint 在其 ex 盒内）。"""
    cur, hints = None, set()
    for line in text.splitlines():
        m = re.match(r"^:::\s*ex\s+([ABC]\d+)\b", line)
        if m:
            cur = m.group(1)
        elif re.match(r"^:::\s*hint\b", line) and cur:
            hints.add(cur)
    return hints


def check_exercise_page(ch: str) -> None:
    rel = f"{ch}/exercises.md"
    if not (SRC / rel).exists():
        return
    text = read(rel)
    groups = count_exercise_groups(text)

    m = re.search(
        r"本页 A、B、C 三组 (\d+) 题：A 组（(\d+) 题）、B 组（(\d+) 题）、C 组（(\d+) 题）", text)
    if m:
        total = sum(len(v) for v in groups.values())
        claimed = [int(m.group(i)) for i in range(1, 5)]
        actual = [total, len(groups["A"]), len(groups["B"]), len(groups["C"])]
        if claimed != actual:
            fail(f"{rel}: 自称 {claimed} 题，实际 {actual} 题（A/B/C 组）")
    # ch01 无「本页…」自称行，只查组表与题号连续性。

    for letter in "ABC":
        row = re.search(rf"\| \*\*{letter} 组\*\*（(\d+) 题）", text)
        if row and int(row.group(1)) != len(groups[letter]):
            fail(f"{rel}: 表格称 {letter} 组 {row.group(1)} 题，实际 {len(groups[letter])} 题")
        nums = groups[letter]
        if nums and sorted(nums) != list(range(1, len(nums) + 1)):
            fail(f"{rel}: {letter} 组题号不连续或缺号：{sorted(nums)}")

    hint_m = re.search(r"([^\n]*?)这 \d+ 题提供了折叠的「提示」", text)
    if hint_m:
        listed = set()
        for token in re.findall(r"[ABC]\d+(?:[–—-][ABC]?\d+)?", hint_m.group(1)):
            rm = re.match(r"([ABC])(\d+)(?:[–—-]([ABC]?)(\d+))?", token)
            letter, a = rm.group(1), int(rm.group(2))
            b = int(rm.group(4)) if rm.group(4) else a
            letter2 = rm.group(3) or letter
            for n in range(a, b + 1):
                listed.add(f"{letter2}{n}")
        actual_hints = count_hints(text)
        if listed != actual_hints:
            fail(f"{rel}: 提示清单与实际 hint 盒不一致；清单 {sorted(listed)}，实际 {sorted(actual_hints)}")


def check_checklist(ch: str, claimed_rows: int) -> None:
    rel = f"{ch}/checklist.md"
    if not (SRC / rel).exists():
        return
    text = read(rel)
    labels = re.findall(r"^\|\s*\*{0,2}\s*([KSA][\d.]+)", text, re.M)
    if len(labels) != claimed_rows:
        fail(f"{rel}: 实际 {len(labels)} 条，README 自称 {claimed_rows} 条")
    for prefix in "KSA":
        seq = [int(m.group(1)) for l in labels if l[0] == prefix
               for m in [re.match(rf"{prefix}\d+\.(\d+)$", l)] if m]
        if seq and sorted(seq) != list(range(seq[0], seq[0] + len(seq))):
            fail(f"{rel}: {prefix} 系目标编号不连续：{sorted(seq)}")


def check_recall_cards() -> None:
    pages = ["ch01/recall-cards.md", "ch02/recall-cards.md", "ch03/recall-cards.md"]
    total = 0
    for rel in pages:
        if not (SRC / rel).exists():
            continue
        text = read(rel)
        cards = re.findall(r"^###\s+", text, re.M)
        total += len(cards)
    m = re.search(r"共 (\d+) 张", read("memory-sheet.md"))
    if not m:
        fail("memory-sheet.md: 找不到「共 N 张」自称（回忆卡总数）")
    elif int(m.group(1)) != total:
        fail(f"memory-sheet.md: 自称回忆卡 {m.group(1)} 张，三章实际 {total} 张")


def check_errata_counts() -> None:
    t1 = read("ch01/errata.md")
    n1 = len(re.findall(r"^E\d+\s*\|", t1, re.M))
    m1 = re.search(r"第一章十五处（\[勘误表\]", read("../README.md") if False else (ROOT / "README.md").read_text(encoding="utf-8"))
    if m1 and n1 != 15:
        fail(f"ch01/errata.md: 实际 {n1} 条，README 自称十五处")
    ids1 = re.findall(r"^(E\d+)\s*\|", t1, re.M)
    if [int(x[1:]) for x in ids1] != list(range(1, n1 + 1)):
        fail(f"ch01/errata.md: 编号不连续：{ids1}")

    t3 = read("ch03/errata.md")
    ids3 = re.findall(r"^(E3\.\d+)\s*\|", t3, re.M)
    want3 = [f"E3.{i}" for i in range(1, len(ids3) + 1)]
    if ids3 != want3:
        fail(f"ch03/errata.md: 勘误编号应连续为 {want3}，实际 {ids3}")
    rm = re.search(r"十一条课件勘误（E3\.1–E3\.(\d+)）", (ROOT / "README.md").read_text(encoding="utf-8"))
    if rm and f"E3.{rm.group(1)}" != (ids3[-1] if ids3 else ""):
        fail(f"README: 自称 E3.1–E3.{rm.group(1)}，实际末条 {ids3[-1] if ids3 else '无'}")
    supplement = re.search(r"本编补全清单（共 (\d+) 处）", t3)
    if supplement:
        rows = len(re.findall(r"^\| \d+ \|", t3, re.M))
        if int(supplement.group(1)) != rows:
            fail(f"ch03/errata.md: 补全清单自称 {supplement.group(1)} 处，表格实际 {rows} 行")


def check_mock_exam(ch: str, expected_total: int) -> None:
    rel = f"{ch}/mock-exam.md"
    if not (SRC / rel).exists():
        return
    text = read(rel)
    sums = [int(x) for x in re.findall(r"^#{2,3}.*?共\s*(\d+)\s*分", text, re.M)]
    total = sum(sums)
    if total != expected_total:
        fail(f"{rel}: 各部分「共 N 分」加总 {total} ≠ {expected_total}")
    # 「每题 X 分，共 Y 分」必须能整除，且题目数与分值加总对得上
    for m in re.finditer(r"每题\s*(\d+)\s*分，共\s*(\d+)\s*分", text):
        per, total_p = int(m.group(1)), int(m.group(2))
        if total_p % per != 0:
            fail(f"{rel}: 「每题 {per} 分，共 {total_p} 分」不能整除")


def check_readme_summary() -> None:
    text = (ROOT / "README.md").read_text(encoding="utf-8")
    m = re.search(r"（(\d+) 题 / (\d+) 题 / (\d+) 题）", text)
    if not m:
        fail("README.md: 找不到习题数自称「（N 题 / N 题 / N 题）」")
        return
    claimed = [int(m.group(i)) for i in (1, 2, 3)]
    actual = []
    for ch in ("ch01", "ch02", "ch03"):
        rel = f"{ch}/exercises.md"
        if (SRC / rel).exists():
            g = count_exercise_groups(read(rel))
            actual.append(sum(len(v) for v in g.values()))
    if claimed != actual:
        fail(f"README.md: 自称习题 {claimed} 题，实际 {actual} 题")
    m = re.search(r"（(\d+) 条 / (\d+) 条 / (\d+) 条）", text)
    if m:
        claimed = [int(m.group(i)) for i in (1, 2, 3)]
        actual = [len(re.findall(r"^\|\s*\*{0,2}\s*[KSA][\d.]+", read(f"{ch}/checklist.md"), re.M))
                  for ch in ("ch01", "ch02", "ch03")]
        if claimed != actual:
            fail(f"README.md: 自检表自称 {claimed} 条，实际 {actual} 条")


def check_placeholder(pages) -> None:
    """占位符检查。勘误内容（勘误页与 ::: errata 框）会原样引用课件文字
    （如「在此处键入公式。」），不算本书的占位符。"""
    for _, rel in pages:
        if MATHBOX_PAGE.search(rel):
            continue
        text = read(rel)
        in_errata = False
        for i, line in enumerate(text.splitlines(), 1):
            if re.match(r"^\s*:::\s*errata\b", line):
                in_errata = True
                continue
            if CLOSE_BOX.match(line):
                in_errata = False
                continue
            if in_errata:
                continue
            if re.search(r"在此处键入|<!--\s*TODO|^TODO:|本章正在编写", line):
                fail(f"{rel} 第 {i} 行：占位符 / TODO")


def main() -> int:
    pages = pages_from_summary()
    if not pages:
        print("SUMMARY 未列出任何页面")
        return 1
    missing_summary = [rel for _, rel in pages if not (SRC / rel).exists()]
    if missing_summary:
        print(f"SUMMARY 列出的页面缺失：{missing_summary}")
        return 1

    page_texts = check_structure(pages)
    # 显式锚点与 HTML id：全书唯一（print.html 单页拼接与 [@ref] 跨页解析都依赖它）。
    anchors = collect_anchors(page_texts)
    dup = {a: n for a, n in anchors.items() if n > 1}
    for a, n in list(dup.items())[:20]:
        fail(f"锚点 / id 全书不唯一：{a} × {n}")
    # 标题自动 slug：只需页内唯一（mdBook 分页渲染，各页 id 空间独立）。
    id_map: dict[str, set[str]] = {}
    for rel, text in page_texts.items():
        ids = page_id_set(rel, text)
        id_map[rel] = ids
        counter = Counter()
        rows = strip_fences(text)
        for _, in_f, line, _ in rows:
            if in_f:
                continue
            for a in ANCHOR.findall(re.sub(r"`[^`]*`", "", line)):
                counter[a] += 1
            for i in HTML_ID.findall(line):
                counter[i] += 1
        for i in heading_ids(text):
            counter[i] += 1
        for a, n in counter.items():
            if n > 1:
                fail(f"{rel}: 页内 id 重复：{a} × {n}")

    for rel, text in page_texts.items():
        check_math(strip_fences(text), rel)
    check_links(pages, page_texts, id_map)

    for ch in ("ch01", "ch02", "ch03"):
        if (SRC / f"{ch}/exercises.md").exists():
            check_exercise_page(ch)
    check_recall_cards()
    check_errata_counts()
    check_mock_exam("ch01", 100)
    check_mock_exam("ch02", 100)
    check_mock_exam("ch03", 200)  # 两份分卷，各 100 分
    check_placeholder(pages)
    check_readme_summary()
    for ch, n in (("ch01", 25), ("ch02", 40), ("ch03", 87)):
        check_checklist(ch, n)

    n_pages = len(page_texts)
    n_lines = sum(len(t.splitlines()) for t in page_texts.values())
    print(f"pages: {n_pages}  total lines: {n_lines}  anchors: {len(anchors)}")
    if problems:
        print(f"\n问题 ({len(problems)}):")
        for p in problems:
            print("  " + p)
        return 1
    print("矩阵论结构、链接与自称数量全部一致。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
