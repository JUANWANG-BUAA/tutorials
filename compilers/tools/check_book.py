#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《编译器与程序分析》结构与契约质检。

用法：
    python3 tools/check_book.py [--verbose]

本脚本只做机械检查，不评价技术内容。内容事实由 CHECK-compilers.md 记录。

检查项：
  1. SUMMARY 每页存在；章节 1000–1400 行；
  2. 每章 1 个 H1、10–12 个 H2，每个 H2 有 sec-compilers.<part>.<ch>.<sec>；
  3. 语义盒只用 def/thm/ex/intuition/method/errata/note/proof/sol，配平；
  4. 显式锚点、HTML id、SVG id 全书唯一；
  5. 代码围栏闭合且标语言；无 TODO/占位符；
  6. chapter-index、IR/数据流图、可运行实验、agent 出错案例、母本对应、
     8–15 条陷阱、出口检查；
  7. 站内 .md 链接与锚点可达；SVG 含 viewBox/title/desc 且不引外部资源；
  8. 公式定界符配平；数学中不出现裸 < >。
"""

from __future__ import annotations

import os
import re
import sys
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")
SUMMARY = os.path.join(SRC, "SUMMARY.md")

FENCE = re.compile(r"^\s*(`{3,}|~{3,})(.*)$")
ANCHOR = re.compile(r"\{#([^}\s]+)\}")
H1 = re.compile(r"^#\s+(.+?)\s*$")
H2 = re.compile(r"^##\s+(.+?)\s*$")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)\s*(.*?)\s*$")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
MD_LINK = re.compile(r"\]\(([^)#\s]+\.md)(?:#([^)]*))?\)")
INCLUDE = re.compile(r"\{\{#include\s+([^}]+?)\s*\}\}")
HTML_ID = re.compile(r'\bid="([^"]+)"')
SEC_ANCHOR = re.compile(r"^sec-compilers\.(\d+)\.(\d+)\.(\d+)$")
ALLOWED_BOX = {"def", "thm", "ex", "intuition", "method", "errata", "note", "proof", "sol"}
CHAPTER_FILE = re.compile(r"^part([1-4])[/\\]ch(\d{2})\.md$")
PROJECT_CHAPTER = {13, 14}
SKIP_DIRS = {".git", "book", "_site", "__pycache__"}


def pages_from_summary():
    out = []
    for line in open(SUMMARY, encoding="utf-8"):
        m = re.match(r"^- \[(.+?)\]\((.+?)\)$", line.strip())
        if m:
            out.append((m.group(1), m.group(2)))
    return out


def expected_chapter(rel: str) -> int | None:
    m = CHAPTER_FILE.match(rel)
    return int(m.group(2)) if m else None


def expected_part(rel: str) -> int | None:
    m = CHAPTER_FILE.match(rel)
    return int(m.group(1)) if m else None


def strip_fenced(text: str):
    rows, problems = [], []
    fence = None
    for i, line in enumerate(text.splitlines(), 1):
        m = FENCE.match(line)
        if m:
            marker, info = m.group(1), m.group(2).strip()
            if fence is None:
                fence = marker[0]
                if not info:
                    problems.append((i, "代码围栏缺语言标记"))
                rows.append((i, True, line))
                continue
            if marker[0] == fence:
                fence = None
                rows.append((i, True, line))
                continue
        rows.append((i, fence is not None, line))
    if fence is not None:
        problems.append((0, "代码围栏未闭合"))
    return rows, problems


def check_math(rows):
    problems = []
    in_display = False
    for i, in_f, line in rows:
        if in_f:
            continue
        line = re.sub(r"`[^`\n]*`", "", line)
        n_disp = len(re.findall(r"(?<!\\)\$\$", line))
        if n_disp % 2 == 1:
            in_display = not in_display
        if in_display:
            segs = [line]
        else:
            segs = [line[e.start() + 1:e.end() - 1]
                    for e in re.finditer(r"(?<!\\)\$(?!\$)(.+?)(?<!\\)\$(?!\$)", line)]
        for seg in segs:
            if "<" in seg or ">" in seg:
                problems.append(f"第 {i} 行数学内含裸 < 或 >（用 \\lt / \\gt）")
        if not in_display and n_disp == 0:
            probe = line.replace("\\$", "")
            if probe.count("$") % 2:
                problems.append(f"第 {i} 行 `$` 未配对")
    if in_display:
        problems.append("`$$` 未配对")
    return problems


def anchors_of(rows):
    out = []
    for i, in_f, line in rows:
        if in_f:
            continue
        for a in ANCHOR.findall(re.sub(r"`[^`]*`", "", line)):
            out.append((a, i, line))
    return out


def check_page(title, rel):
    path = os.path.join(SRC, rel)
    r = {"title": title, "rel": rel, "missing": False, "lines": 0, "h2": 0,
         "problems": [], "anchors": [], "links": [], "boxes": Counter()}
    if not os.path.exists(path):
        r["missing"] = True
        r["problems"].append("文件不存在")
        return r
    text = open(path, encoding="utf-8").read()
    lines = text.splitlines()
    r["lines"] = len(lines)
    rows, fence_problems = strip_fenced(text)
    r["problems"] += [msg for _, msg in fence_problems]

    body = "\n".join(l for _, in_f, l in rows if not in_f)
    body_no_code = re.sub(r"`[^`]*`", "", body)

    h1s = [l for _, in_f, l in rows if not in_f and H1.match(l)]
    if len(h1s) != 1:
        r["problems"].append(f"H1 数量={len(h1s)}（应为 1）")

    h2 = []
    for i, in_f, line in rows:
        if in_f:
            continue
        m = H2.match(line)
        if m:
            h2.append((i, m.group(1)))
    r["h2"] = len(h2)
    ch = expected_chapter(rel)
    part = expected_part(rel)
    if ch is not None:
        sec_nums = []
        for _, title in h2:
            ma = re.search(r"\{#sec-compilers\.[0-9]+\.[0-9]+\.([0-9]+)\}", title)
            if ma:
                sec_nums.append(int(ma.group(1)))
        if sec_nums and sec_nums != list(range(1, len(sec_nums) + 1)):
            r["problems"].append(f"节编号不连续：{sec_nums}")
        if not (10 <= len(h2) <= 12):
            r["problems"].append(f"H2 数量={len(h2)}（应为 10–12）")

    anchors = anchors_of(rows)
    r["anchors"] = [a for a, _, _ in anchors]
    for a, i, line in anchors:
        ms = SEC_ANCHOR.match(a)
        if H2.match(line) and ch is not None:
            if not ms:
                r["problems"].append(f"第 {i} 行节锚点不符合 sec-compilers.p.c.n：{a}")
            else:
                p, c, s = map(int, ms.groups())
                num = H2.match(line).group(1).split(" ", 1)[0]
                if ch is not None and num != f"{c}.{s}":
                    r["problems"].append(f"第 {i} 行节号 {num} 与锚点 {a} 不一致")
                if ch is not None and c != ch:
                    r["problems"].append(f"第 {i} 行章号 {c} 与文件 {rel} 不一致")
                if part is not None and p != part:
                    r["problems"].append(f"第 {i} 行篇号 {p} 与文件 {rel} 不一致")
        # 盒锚点只要求带类型前缀；具体编号由作者自定，但必须全书唯一。

    # box balance and types
    depth, min_depth = 0, 0
    for i, in_f, line in rows:
        if in_f:
            continue
        mo = OPEN_BOX.match(line)
        if mo:
            typ = mo.group(1)
            r["boxes"][typ] += 1
            if typ not in ALLOWED_BOX:
                r["problems"].append(f"第 {i} 行禁用盒子类型 :::{typ}")
            if typ in {"def", "thm", "ex"} and not re.search(r"\{#[^}]+\}", mo.group(2)):
                r["problems"].append(f"第 {i} 行 :::{typ} 缺锚点")
            depth += 1
            continue
        if CLOSE_BOX.match(line):
            depth -= 1
            min_depth = min(min_depth, depth)
    if depth != 0:
        r["problems"].append(f"盒子深度收尾={depth}")
    if min_depth < 0:
        r["problems"].append("多余的 ::: 闭合")

    # forbidden
    bad_ctrl = sorted({ord(c) for c in text if ord(c) < 32 and c not in "\n\t"})
    if bad_ctrl:
        r["problems"].append("控制字符：" + ",".join(f"U+{c:04X}" for c in bad_ctrl))
    bad_math = re.findall(r"(?<![\\A-Za-z])(?:mathsf|qquad|frac|Gamma|vdash|tau|mathbb|mathcal|mathrm)(?![A-Za-z])", text)
    if bad_math:
        r["problems"].append("疑似丢失反斜杠的 LaTeX 命令：" + ",".join(sorted(set(bad_math))[:6]))
    if re.search(r"\$[^$\n]*\t[^$\n]*\$", text):
        r["problems"].append("数学片段内含制表符（疑似 \tau 被转义）")
    if re.search(r"本章正在编写|<!--\s*TODO|^TODO:", text, re.M):
        r["problems"].append("占位符/TODO")
    if re.search(r":::\s*(warning|caution)\b", body):
        r["problems"].append("出现 warning/caution 盒子")
    # The skeleton comments are intentionally forbidden once a chapter is delivered.
    if re.search(r"本节 .*：90–120 行|（用 3–5 个具体动作写|（按覆盖矩阵填", text):
        r["problems"].append("遗留章节骨架占位")

    r["links"] = MD_LINK.findall(body)
    page_dir = os.path.dirname(os.path.join(SRC, rel))
    for target in INCLUDE.findall(re.sub(r"`[^`]*`", "", body)):
        tp = os.path.normpath(os.path.join(page_dir, target))
        if not os.path.exists(tp):
            r["problems"].append(f"include 不存在：{target}")

    r["problems"] += check_math(rows)

    if ch is not None:
        if not (1000 <= len(lines) <= 1400):
            r["problems"].append(f"行数 {len(lines)} 不在 1000–1400")
        head = "\n".join(lines[:45])
        if 'class="chapter-index"' not in head:
            r["problems"].append("章首缺 chapter-index")
        required_types = {"def", "ex", "errata", "method"}
        missing = required_types - set(r["boxes"])
        if missing:
            r["problems"].append(f"缺盒子类型：{','.join(sorted(missing))}")
        if '<pre class="layout">' not in text:
            r["problems"].append("缺 IR/数据流/机制图（pre.layout）")
        if "读图：" not in body:
            r["problems"].append("缺图后读图结论（读图：）")
        if "本章回答" not in head:
            r["problems"].append("章首缺「本章回答」")
        exp = f"experiments/ch{ch:02d}/"
        if ch not in PROJECT_CHAPTER:
            if exp not in text:
                r["problems"].append(f"正文未引用实验入口 {exp}")
            expdir = os.path.join(ROOT, "experiments", f"ch{ch:02d}")
            if not os.path.isdir(expdir) or not os.path.isfile(os.path.join(expdir, "run.sh")):
                r["problems"].append(f"缺实验目录或 run.sh：{exp}")
        if ch == 13:
            for relp in ("projects/minic/minic.py", "projects/minic/run_tests.sh"):
                if not os.path.isfile(os.path.join(ROOT, relp)):
                    r["problems"].append(f"缺项目文件 {relp}")
        if ch == 14:
            for relp in ("projects/validator/guard.py", "projects/validator/run_tests.sh"):
                if not os.path.isfile(os.path.join(ROOT, relp)):
                    r["problems"].append(f"缺项目文件 {relp}")
        if "母本对应" not in body:
            r["problems"].append("缺「母本对应」")
        if "本章陷阱" not in body:
            r["problems"].append("缺「本章陷阱」")
        if "本章出口检查" not in body:
            r["problems"].append("缺「本章出口检查」")
        if not re.search(r"agent|Agent|agent 生成|智能体", body):
            r["problems"].append("缺 agent 生成代码出错案例")
        # trap count between trap H2 and next H2
        trap_lines = []
        in_traps = False
        for _, in_f, line in rows:
            if in_f:
                continue
            mh = H2.match(line)
            if mh:
                if "陷阱" in mh.group(1):
                    in_traps = True
                    continue
                if in_traps:
                    break
            if in_traps:
                trap_lines.append(line)
        traps = [l for l in trap_lines if re.match(r"^\s*\d+\.\s+\S", l)]
        if not (8 <= len(traps) <= 15):
            r["problems"].append(f"陷阱条数={len(traps)}（应为 8–15）")
        # exit table and self test
        if "method" not in r["boxes"]:
            r["problems"].append("缺 method 自测/方法盒")
    return r


def check_svgs(problems, used_ids):
    for base, dirs, files in os.walk(SRC):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for f in files:
            if not f.endswith(".svg"):
                continue
            path = os.path.join(base, f)
            rel = os.path.relpath(path, ROOT)
            try:
                tree = ET.parse(path)
            except Exception as e:
                problems.append(f"{rel}: SVG 解析失败：{e}")
                continue
            root = tree.getroot()
            if "viewBox" not in root.attrib:
                problems.append(f"{rel}: 缺 viewBox")
            if root.find("{http://www.w3.org/2000/svg}title") is None:
                problems.append(f"{rel}: 缺 title")
            if root.find("{http://www.w3.org/2000/svg}desc") is None:
                problems.append(f"{rel}: 缺 desc")
            text = open(path, encoding="utf-8").read()
            if re.search(r"(?:href|src)=\"(?:https?:)?//", text):
                problems.append(f"{rel}: 引用外部资源")
            for i in HTML_ID.findall(text):
                if i in used_ids:
                    problems.append(f"{rel}: SVG id 重复：{i}")
                used_ids[i] += 1


def main():
    verbose = "--verbose" in sys.argv
    pages = pages_from_summary()
    results = [check_page(t, r) for t, r in pages]
    seen = defaultdict(list)
    used_ids = Counter()
    for r in results:
        for a in r["anchors"]:
            seen[a].append(r["rel"])
            used_ids[a] += 1
        path = os.path.join(SRC, r["rel"])
        if os.path.exists(path):
            text = open(path, encoding="utf-8").read()
            for i in HTML_ID.findall(text):
                used_ids[i] += 1
    # duplicate IDs: only IDs occurring more than once across all pages
    dup = {a: v for a, v in used_ids.items() if v > 1}
    broken = []
    broken_anchors = []
    anchors_by_page = {r["rel"]: set(r["anchors"]) for r in results}
    for r in results:
        base = os.path.dirname(os.path.join(SRC, r["rel"]))
        for link, anchor in r["links"]:
            target = os.path.normpath(os.path.join(base, link))
            trel = os.path.relpath(target, SRC)
            if not os.path.exists(target):
                broken.append((r["rel"], link))
            elif anchor and trel in anchors_by_page and anchor not in anchors_by_page[trel]:
                broken_anchors.append((r["rel"], link + "#" + anchor))
    svg_problems = []
    check_svgs(svg_problems, used_ids)

    total_lines = sum(r["lines"] for r in results)
    print(f"pages: {len(results)}  chapters: {sum(1 for t, r in pages if expected_chapter(r))}  total lines: {total_lines}  substantial: {sum(1 for r in results if r['lines'] >= 150 and not r['problems'])}")
    bad = [r for r in results if r["problems"]]
    if bad:
        print(f"\n问题页 ({len(bad)}):")
        for r in bad:
            print(f"  {r['rel']:28s} {r['lines']:5d}行  " + "; ".join(r["problems"][:8]))
            if len(r["problems"]) > 8:
                print(f"    …另有 {len(r['problems']) - 8} 项")
    if dup:
        print(f"\n重复/冲突 id ({len(dup)}):")
        for a, n in list(dup.items())[:40]:
            print(f"  {a} × {n}")
    if broken:
        print(f"\n断链 ({len(broken)}):")
        for rel, link in broken[:40]:
            print(f"  {rel} -> {link}")
    if broken_anchors:
        print(f"\n断锚点 ({len(broken_anchors)}):")
        for rel, link in broken_anchors[:40]:
            print(f"  {rel} -> {link}")
    if svg_problems:
        print(f"\nSVG 问题 ({len(svg_problems)}):")
        for p in svg_problems[:40]:
            print("  " + p)
    if verbose:
        print("\n各页行数:")
        for r in results:
            print(f"  {r['rel']:28s} {r['lines']:5d}  H2={r['h2']}  boxes={dict(r['boxes'])}")
    return 1 if (bad or dup or broken or broken_anchors or svg_problems) else 0


if __name__ == "__main__":
    sys.exit(main())
