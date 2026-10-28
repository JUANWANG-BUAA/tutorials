#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《数值分析》结构与契约质检。

用法：
    python3 tools/check_book.py

与本书预处理器 tools/mathbook.py 的分工：mathbook 在构建期校验语义盒与 [@ref]
（引用不存在的锚点会让构建失败），本脚本做构建期之外的结构与**自称数量**门禁：

  1. SUMMARY 列出的每页存在，每页恰 1 个 H1；
  2. 语义盒配平，开放类型在 mathbook 支持范围内（与 mathbook.py 的 BOX_TYPES 同源）；
  3. 显式锚点 {#…} 与 HTML id 全书唯一；
  4. 站内 .md 链接可达、锚点存在；
  5. 公式定界符配平（$ / $$），**行内数学一律用 $…$**（禁 \\(…\\)），
     代码围栏闭合且带语言标记；
  6. 无占位符 / TODO；
  7. **自称数量与实际一致**——讲次数、每讲页结构、习题题号覆盖、覆盖矩阵状态、
     回忆卡张数、模拟卷分值、README 章级汇总，逐处对照实际计数；
  8. **章节契约**——文件名 ↔ 首个小节号一致、小节号全书不重复、
     编者自撰小节（先修 / 例题 / 习题 / 对比）不占教材小节号、
     每章必备件套（summary / checklist / recall-cards / mock-exam / errata）。

为什么第 5 条要单列 \\(…\\)：CommonMark 把 `\\(` 当成转义括号吃掉，
mdbook-katex 又不认这种定界符，于是表格与普通段落里的行内公式会退化成
纯文本（`\\lVert x\\rVert` 之类原样露出）。统一成 `$…$` 才是可依赖的写法。
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
HEADING = re.compile(r"^(#{2,6})\s+(.+?)\s*$")
SECNO = re.compile(r"^(\d+(?:\.\d+)*)\s")
ANCHOR = re.compile(r"\{#([^}\s]+)\}")
MD_LINK = re.compile(r"(?<!\()]\(([^)#\s]+\.md)(?:#([^)\s]*))?\)")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
HTML_ID = re.compile(r'\bid="([^"]+)"')

# 教材实体小节之外的编者自撰小节：这些标题不带教材小节号。
EDITORIAL_HEADS = ("习题", "先修", "例题", "数值实验", "对比", "小结", "补充")

# 章级件套（矩阵教程同款「学 → 练 → 测」闭环）
CHAPTER_DIRS = [f"course/ch0{i}" for i in range(2, 8)]
KIT = {
    "overview.md": "章导览",
    "coverage.md": "覆盖矩阵",
    "exercises.md": "章末习题",
    "summary.md": "全章总结",
    "checklist.md": "学习目标自检表",
    "recall-cards.md": "闭卷回忆卡",
    "mock-exam.md": "综合自测卷",
    "errata.md": "勘误与补注",
}

problems: list[str] = []


def fail(msg: str) -> None:
    problems.append(msg)


def read(rel: str) -> str:
    return (SRC / rel).read_text(encoding="utf-8")


def allowed_box_types() -> set[str]:
    """与 mathbook.py 的 BOX_TYPES 同源——直接从该文件解析，避免两处名单漂移。"""
    src = (HERE / "mathbook.py").read_text(encoding="utf-8")
    m = re.search(r"^BOX_TYPES\s*=\s*\{(.*?)^\}", src, re.M | re.S)
    if not m:
        raise SystemExit("check_book: 未能从 mathbook.py 定位 BOX_TYPES")
    types = set(re.findall(r'^\s{4}"(\w+)":', m.group(1), re.M))
    for name in ("PROOF", "SOL"):
        mm = re.search(rf'^{name}\s*=\s*"(\w+)"', src, re.M)
        if mm:
            types.add(mm.group(1))
    return types


ALLOWED_BOX = allowed_box_types()


def strip_fences(text: str):
    """返回 [(行号, 是否在围栏内, 行)] 与围栏问题。"""
    rows, fence = [], None
    for i, line in enumerate(text.splitlines(), 1):
        m = FENCE.match(line)
        if m:
            marker = m.group(1)
            if fence is None:
                fence = marker[0]
                probe = None if m.group(2).strip() else (i, "代码围栏缺语言标记")
                rows.append((i, True, line, probe))
                continue
            if marker[0] == fence:
                fence = None
                rows.append((i, True, line, None))
                continue
        rows.append((i, fence is not None, line, None))
    if fence is not None:
        rows.append((0, True, "", (0, "代码围栏未闭合")))
    return rows


def slug(text: str) -> str:
    """近似 mdBook 的标题 id 生成（id_from_content）：去格式、去标点、空格转连字
    号、ASCII 转小写、保留 CJK。"""
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
    ids = set()
    for line in text.splitlines():
        m = HEADING.match(line)
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


# ---------------------------------------------------------------- 数学与围栏

def check_math(rows, rel):
    """行内数学的 `$` 必须成对。

    按**段落**而不是按行计数：行内公式允许跨行（KaTeX 会把换行当空格），
    逐行计数会把这种合法写法误判成「未配对」。`$$` 显示式同样按段落配平。
    """
    for i, in_f, line, _ in rows:
        if in_f:
            continue
        # 禁 \(…\)：CommonMark 会吃掉反斜杠，KaTeX 又不认这种定界符。
        if re.search(r"\\\(.+?\\\)", line):
            fail(f"{rel} 第 {i} 行：行内数学用了 \\(…\\)，应改成 $…$")

    para: list[str] = []
    start = 0

    def flush(end_line):
        if not para:
            return
        text = re.sub(r"`[^`\n]*`", "", "\n".join(para))
        n_disp = len(re.findall(r"(?<!\\)\$\$", text))
        if n_disp % 2:
            fail(f"{rel} 第 {start}–{end_line} 行：`$$` 未配对")
        rest = re.sub(r"\$\$", "", text)
        if rest.count("$") % 2:
            fail(f"{rel} 第 {start}–{end_line} 行：行内 `$` 未配对")
        para.clear()

    for i, in_f, line, _ in rows:
        if in_f:
            continue
        if not line.strip():
            flush(i - 1)
            continue
        if not para:
            start = i
        para.append(line)
    flush(len(rows))


# ---------------------------------------------------------------- 链接与锚点

def collect_anchors(page_texts):
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


def built_ids():
    """若已构建，读取产物里每页的真实 id——比近似 slug 可靠得多。"""
    book = ROOT / "book"
    if not book.is_dir():
        return None
    out = {}
    for f in book.rglob("*.html"):
        rel = str(f.relative_to(book)).replace(".html", ".md")
        out[rel] = set(re.findall(r'id="([^"]+)"', f.read_text(encoding="utf-8")))
    return out or None


def check_links(pages, page_texts, id_map):
    all_rels = {rel for _, rel in pages}
    built = built_ids()
    if built:
        id_map = built
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


# ---------------------------------------------------------------- 章节契约

def chapter_files():
    """course/ch0X 下按目录扫描（不依赖 SUMMARY，便于发现漏挂载的文件）。"""
    out = {}
    for d in CHAPTER_DIRS:
        p = SRC / d
        if not p.is_dir():
            continue
        out[d] = sorted(x.name for x in p.glob("*.md"))
    return out


def check_file_names_match_sections(page_texts):
    """文件名 ↔ 首个小节号一致：sec41.md 必须以 4.1 开头，sec24b.md 记作 2.4 的第二篇。

    规则：secNN（两位数字）→ 章.节，如 sec61 → 6.1；secNNN（三位）→ 章.节.小节；
    字母后缀（sec24b）表示同一节的第二篇，首个小节号仍应是 章.节。
    """
    for rel, text in page_texts.items():
        m = re.match(r"^course/ch0\d/(sec[\w-]*)\.md$", rel)
        if not m:
            continue
        stem = m.group(1)
        digits = re.findall(r"\d+", stem)
        if not digits:
            continue
        d = "".join(digits)
        if len(d) == 2:
            want = f"{d[0]}.{d[1]}"
        elif len(d) == 3:
            want = f"{d[0]}.{d[1]}.{d[2]}"
        else:
            want = None
        secs = []
        for line in text.splitlines():
            h = HEADING.match(line)
            if h:
                s = SECNO.match(h.group(2))
                if s:
                    secs.append(s.group(1))
        if not secs:
            continue
        first = secs[0]
        if want and not first.startswith(want):
            fail(f"{rel}: 文件名暗示 {want}.x，首个小节却是 {first}")
        # 同一文件内小节号不得重复
        dup = {s: n for s, n in Counter(secs).items() if n > 1}
        for s, n in dup.items():
            fail(f"{rel}: 小节号 {s} 重复 {n} 次")


def check_section_numbers_unique(page_texts):
    """全书小节号唯一（教材小节号是本书与读者之间的公共坐标，不能重号）。"""
    seen: dict[str, list[str]] = {}
    for rel, text in page_texts.items():
        # 导览与覆盖矩阵是**索引页**：它们会复述本章的小节号，不是正文小节。
        if not rel.startswith("course/") or rel.endswith(("overview.md", "coverage.md")):
            continue
        for line in text.splitlines():
            h = HEADING.match(line)
            if not h:
                continue
            s = SECNO.match(h.group(2))
            if s:
                seen.setdefault(s.group(1), []).append(rel)
    for s, rels in sorted(seen.items()):
        if len(rels) > 1:
            fail(f"小节号 {s} 在多页重复：{sorted(set(rels))}")


def check_editorial_sections_unnumbered(page_texts):
    """编者自撰小节（习题 / 先修 / 例题 / 对比…）不得占用教材小节号。"""
    for rel, text in page_texts.items():
        # 只有 course/ 下的小节号与教材原书对齐，才需要让出教材号；
        # 第一章的 1.1.1… 与讲座页的 12.5 是本书自己的细分编号。
        if not rel.startswith("course/"):
            continue
        for i, line in enumerate(text.splitlines(), 1):
            h = HEADING.match(line)
            if not h:
                continue
            title = h.group(2)
            if not SECNO.match(title):
                continue
            if any(k in title for k in EDITORIAL_HEADS):
                fail(f"{rel} 第 {i} 行：编者自撰小节占了教材号「{title}」，应改为无号标题")


def check_kit(chapters):
    """每章必备件套（与矩阵教程同款「学 → 练 → 测」闭环）。"""
    for d, files in chapters.items():
        for name, label in KIT.items():
            if name not in files:
                fail(f"{d}: 缺章级件套「{label}」（{name}）")


# ---------------------------------------------------------------- 数量同步门

def parse_num_ranges(cell: str) -> list[int]:
    """把「1–2」「3」「7–8」这样的题号单元格展开成题号列表。"""
    out = []
    for part in re.split(r"[、,，]", cell):
        part = part.strip()
        if not part:
            continue
        m = re.match(r"^(\d+)\s*[–—-]\s*(\d+)$", part)
        if m:
            out.extend(range(int(m.group(1)), int(m.group(2)) + 1))
        elif part.isdigit():
            out.append(int(part))
    return out


def check_chapter_exercises(chapters):
    """course/ch0X 习题：标题自称的「教材 1–N」必须被表格逐题覆盖。"""
    for d in chapters:
        rel = f"{d}/exercises.md"
        if not (SRC / rel).exists():
            continue
        text = read(rel)
        m = re.search(r"教材\s*1\s*[–—-]\s*(\d+)", text)
        if not m:
            fail(f"{rel}: 标题未声明「教材 1–N」题号范围")
            continue
        want = set(range(1, int(m.group(1)) + 1))
        got: set[int] = set()
        for line in text.splitlines():
            if not line.startswith("|"):
                continue
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if not cells or not cells[0]:
                continue
            nums = parse_num_ranges(re.sub(r"<[^>]+>", "", cells[0]))
            got.update(nums)
        missing = sorted(want - got)
        extra = sorted(got - want)
        if missing:
            fail(f"{rel}: 教材题号缺 {missing}")
        if extra:
            fail(f"{rel}: 出现超出范围的题号 {extra}")


def check_coverage_matrix(chapters):
    """覆盖矩阵：必须存在、不得留待办标记、逐行都要有状态。"""
    for d in chapters:
        rel = f"{d}/coverage.md"
        if not (SRC / rel).exists():
            continue
        text = read(rel)
        for i, line in enumerate(text.splitlines(), 1):
            if not line.startswith("|"):
                continue
            if re.match(r"^\|[\s:|-]+\|$", line):
                continue
            if "⏳" in line:
                fail(f"{rel} 第 {i} 行：仍有待办标记 ⏳")
            if "p.?" in line:
                fail(f"{rel} 第 {i} 行：页码仍是占位符 p.?")
        if "p.?" in text:
            fail(f"{rel}: 仍有页码占位符 p.?")


def check_lectures(page_texts):
    """讲座页：编号连续、页首有「10 分钟复习版」、有课堂时间线。"""
    lec = sorted(p.name for p in (SRC / "lectures").glob("lec*.md"))
    nums = sorted(int(re.search(r"lec(\d+)", n).group(1)) for n in lec)
    if nums != list(range(1, len(nums) + 1)):
        fail(f"lectures/lec*.md 编号不连续：{nums}")
    n_lect = len(nums)
    for name in lec:
        rel = f"lectures/{name}"
        text = page_texts.get(rel) or read(rel)
        if "10 分钟复习版" not in text:
            fail(f"{rel}: 缺少页首「10 分钟复习版」")
        if "课堂时间线" not in text:
            fail(f"{rel}: 缺少「课堂时间线」")
    # 各处自称的讲数
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    index = read("index.md")
    ov = read("lectures/overview.md")
    for label, text in (("README.md", readme), ("index.md", index),
                        ("lectures/overview.md", ov)):
        for m in re.finditer(r"(\d+)\s*讲", text):
            if int(m.group(1)) != n_lect and m.group(1) != "0":
                # 允许「前十讲」这类非计数说法，只对明确的「N 讲全程/逐讲」报警
                ctx = text[max(0, m.start() - 12): m.end() + 6]
                if any(k in ctx for k in ("全程", "逐讲", "实录", "课堂精编", "讲（", "讲 ·")):
                    fail(f"{label}: 自称 {m.group(1)} 讲，实际讲座页 {n_lect} 讲")
    # SUMMARY 里的讲次条目
    summary = (SRC / "SUMMARY.md").read_text(encoding="utf-8")
    s_lect = sorted({int(x) for x in re.findall(r"\[第\s*(\d+)\s*讲", summary)})
    if s_lect != list(range(1, n_lect + 1)):
        fail(f"SUMMARY.md: 讲次条目为 {s_lect}，实际讲座页 {n_lect} 讲")


def check_recall_cards(page_texts):
    """回忆卡：卡数与页面自称一致。"""
    for rel in ("ch01/recall-cards.md", "supplement/recall-cards.md"):
        if rel not in page_texts:
            continue
        text = page_texts[rel]
        cards = len(re.findall(r"^\*\*[A-Z]?\d+\.\*\*", text, re.M))
        if not cards:
            cards = len(re.findall(r"^###\s+", text, re.M))
        m = re.search(r"共\s*(\d+)\s*张|全页\s*(\d+)\s*张", text)
        if not m:
            fail(f"{rel}: 找不到回忆卡总数的自称")
            continue
        claimed = int(m.group(1) or m.group(2))
        if claimed != cards:
            fail(f"{rel}: 自称 {claimed} 张，实际 {cards} 张")


def check_mock_exam(page_texts):
    """模拟卷：各部分分值加总 = 100。

    两种写法都认：标题行「（10 题 × 3 分 = 30 分）」与正文「共 30 分」。
    """
    for rel, text in page_texts.items():
        if not rel.endswith("mock-exam.md"):
            continue
        sums = []
        for m in re.finditer(r"^#{2,3}[^\n]*[（(][^\n]*?=\s*(\d+)\s*分", text, re.M):
            sums.append(int(m.group(1)))
        sums += [int(x) for x in re.findall(r"共\s*(\d+)\s*分", text)]
        if not sums:
            fail(f"{rel}: 找不到任何「共 N 分」或「= N 分」的分值声明")
            continue
        if sum(sums) != 100:
            fail(f"{rel}: 各部分分值加总 {sum(sums)} ≠ 100（{sums}）")
        for m in re.finditer(r"每题\s*(\d+)\s*分，共\s*(\d+)\s*分", text):
            per, total_p = int(m.group(1)), int(m.group(2))
            if total_p % per != 0:
                fail(f"{rel}: 「每题 {per} 分，共 {total_p} 分」不能整除")


def check_placeholder(pages):
    for _, rel in pages:
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
            if re.search(r"在此处键入|<!--\s*TODO|^TODO:|本章正在编写|p\.\?\?", line):
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
    anchors = collect_anchors(page_texts)
    for a, n in list({a: n for a, n in anchors.items() if n > 1}.items())[:20]:
        fail(f"锚点 / id 全书不唯一：{a} × {n}")

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

    chapters = chapter_files()
    check_file_names_match_sections(page_texts)
    check_section_numbers_unique(page_texts)
    check_editorial_sections_unnumbered(page_texts)
    check_kit(chapters)
    check_chapter_exercises(chapters)
    check_coverage_matrix(chapters)
    check_lectures(page_texts)
    check_recall_cards(page_texts)
    check_mock_exam(page_texts)
    check_placeholder(pages)

    n_pages = len(page_texts)
    n_lines = sum(len(t.splitlines()) for t in page_texts.values())
    print(f"pages: {n_pages}  total lines: {n_lines}  anchors: {len(anchors)}")
    if problems:
        print(f"\n问题 ({len(problems)}):")
        for p in problems:
            print("  " + p)
        return 1
    print("数值分析结构、链接、章节契约与自称数量全部一致。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
