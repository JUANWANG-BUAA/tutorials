#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《具身感知：SLAM、状态估计与传感器融合》结构与质量契约质检。

用法：
    python3 tools/check_book.py            # 短报告，0 = 全过
    python3 tools/check_book.py --verbose  # 附每章行数/节数/盒子数

检查项：
  1. SUMMARY 每页存在、非空；
  2. 正文章节（part1-4/ch*.md）行数严格在 1000–1500 行；
  3. 每章 1 个 H1、8–12 个编号 H2，每个 H2 具备 sec-embodied.<p>.<c>.<n> 锚点；
  4. 语义盒只用 def/thm/ex/intuition/method/errata/note/proof/sol，配平且锚点唯一；
  5. 代码围栏配平且标注语言；无 TODO/占位符/「综上所述」；
  6. chapter-index、机制图、失败/漂移案例、观测命令、实验入口、母本对应、8–15 条陷阱、出口检查、下一站；
  7. 站内 .md 链接与显式锚点可达；
  8. 显式锚点、HTML id、SVG id 全书唯一；
  9. SVG 有 viewBox/title/desc，且不引用外部资源；
 10. 行内/块级公式定界符配平，数学里不出现裸 < >。
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
H2 = re.compile(r"^##\s+(.+?)\s*$")
H1 = re.compile(r"^#\s+(.+?)\s*$")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)\s*(.*?)\s*$")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
MD_LINK = re.compile(r"\]\(([^)#\s]+\.md)(?:#([^)]*))?\)")
INCLUDE = re.compile(r"\{\{#include\s+([^}]+?)\s*\}\}")
HTML_ID = re.compile(r'\bid="([^"]+)"')
SEC_ANCHOR = re.compile(r"^sec-embodied\.(\d+)\.(\d+)\.(\d+)$")
BOX_ANCHOR = re.compile(r"^(def|thm|ex|intuition|method|errata|note|proof|sol)-embodied\.(\d+)\.(\d+)\.(\d+)\.(\d+)$")
ALLOWED_BOX = {"def", "thm", "ex", "intuition", "method", "errata", "note", "proof", "sol"}
OBS_CMD = re.compile(
    r"\b(python3|bash|ros2|rostopic|rosbag|g2o|evo_traj|evo_ape|evo_rpe|"
    r"pcl_viewer|rviz|rviz2|ceres|ctest|pytest|pip|cmake|make|ninja)\b"
)

# 正文范围：各篇目录下的 chNN.md
CHAPTER_FILE = re.compile(r"^part[1-4][/\\]ch\d{2}\.md$")
SKIP_DIRS = {".git", "book", "_site", "__pycache__"}


def pages_from_summary():
    out = []
    if not os.path.exists(SUMMARY):
        return out
    for line in open(SUMMARY, encoding="utf-8"):
        m = re.match(r"^- \[(.+?)\]\((.+?)\)$", line.strip())
        if m:
            out.append((m.group(1), m.group(2)))
    return out


def strip_fenced(text):
    """返回逐行 (行号, 是否在围栏内, 行文本) 与围栏问题列表。"""
    rows, problems = [], []
    fence = None
    for i, line in enumerate(text.splitlines(), 1):
        m = FENCE.match(line)
        if m:
            marker = m.group(1)
            info = m.group(2).strip()
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


def check_math(text, rows):
    """粗查公式：$$ 成对、每行 $ 成对、数学里无裸 < >。"""
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
                problems.append(f"第 {i} 行数学内含裸 < 或 >（请使用 \\lt / \\gt / \\le / \\ge）")
        if not in_display and n_disp == 0:
            probe = line.replace("\\$", "")
            if probe.count("$") % 2:
                problems.append(f"第 {i} 行 `$` 未配对")
    if in_display:
        problems.append("`$$` 未配对")
    return problems


def anchors_of(text, rows):
    out = []
    for i, in_f, line in rows:
        if in_f:
            continue
        for a in ANCHOR.findall(re.sub(r"`[^`]*`", "", line)):
            out.append((a, i, line))
    return out


def expected_chapter(rel):
    m = re.search(r"ch(\d{2})\.md$", rel)
    return int(m.group(1)) if m else -1


def expected_part(rel):
    m = re.search(r"part(\d)/", rel)
    return int(m.group(1)) if m else -1


def bash_code(body):
    out, buf, on = [], [], False
    for line in body.splitlines():
        m = FENCE.match(line)
        if m:
            if on:
                out.append("\n".join(buf))
                buf, on = [], False
            else:
                on = m.group(2).strip().split()[0] if m.group(2).strip() else ""
                buf = []
            continue
        if on in {"bash", "sh", "console", "shell"}:
            buf.append(line)
    if on in {"bash", "sh", "console", "shell"}:
        out.append("\n".join(buf))
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

    # H1 / H2 编号与锚点
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
    if CHAPTER_FILE.match(rel):
        if not (8 <= len(h2) <= 12):
            r["problems"].append(f"H2 数量={len(h2)}（应在 8–12）")

    anchors = anchors_of(text, rows)
    r["anchors"] = [a for a, _, _ in anchors]
    for a, i, line in anchors:
        ms = SEC_ANCHOR.match(a)
        mb = BOX_ANCHOR.match(a)
        if H2.match(line):
            if not ms:
                r["problems"].append(f"第 {i} 行节锚点不符合 sec-embodied.p.c.n：{a}")
            else:
                p, c, s = map(int, ms.groups())
                num = H2.match(line).group(1).split(" ", 1)[0]
                want = f"{c}.{s}"
                if num != want:
                    r["problems"].append(f"第 {i} 行节号 {num} 与锚点 {a} 不一致")
                if c != expected_chapter(rel):
                    r["problems"].append(f"第 {i} 行章号 {c} 与文件 {rel} 不一致")
                if p != expected_part(rel):
                    r["problems"].append(f"第 {i} 行篇号 {p} 与文件 {rel} 不一致")
        elif mb:
            typ, p, c, sec, n = mb.group(1), *(int(x) for x in mb.groups()[1:])
            if c != expected_chapter(rel):
                r["problems"].append(f"第 {i} 行盒子章号 {c} 与文件 {rel} 不一致")
            if p != expected_part(rel):
                r["problems"].append(f"第 {i} 行盒子篇号 {p} 与文件 {rel} 不一致")
        else:
            r["problems"].append(f"第 {i} 行锚点格式不合契约：{a}")

    # 盒子配平 / 类型 / 锚点
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
            if not re.search(r"\{#[^}]+\}", mo.group(2)):
                if typ in {"def", "thm", "ex"}:
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

    # 禁止项
    if re.search(r"本章正在编写|<!--\s*TODO|^TODO:", text, re.M):
        r["problems"].append("占位符/TODO")
    if "综上所述" in text:
        r["problems"].append("出现「综上所述」")
    if re.search(r":::\s*(warning|caution)\b", body):
        r["problems"].append("出现 warning/caution 盒子")

    r["links"] = MD_LINK.findall(body)
    page_dir = os.path.dirname(os.path.join(SRC, rel))
    for target in INCLUDE.findall(re.sub(r"`[^`]*`", "", body)):
        tp = os.path.normpath(os.path.join(page_dir, target))
        if not os.path.exists(tp):
            r["problems"].append(f"include 不存在：{target}")

    r["problems"] += check_math(text, rows)

    # 章节契约
    if CHAPTER_FILE.match(rel):
        if not (1000 <= len(lines) <= 1500):
            r["problems"].append(f"行数 {len(lines)} 不在 1000–1500 行区间")
        head = "\n".join(lines[:45])
        if 'class="chapter-index"' not in head:
            r["problems"].append("章首缺 chapter-index")
        if "本章回答" not in head or "读完你会" not in head:
            r["problems"].append("chapter-index 缺「本章回答/读完你会」")
        if '<pre class="layout">' not in body and "{{#include" not in body and "<svg" not in body:
            r["problems"].append("缺机制图（pre.layout 或 figure include 或 svg）")
        bash_blocks = bash_code("\n".join(l for _, _, l in rows))
        if not any(OBS_CMD.search(b) for b in bash_blocks):
            r["problems"].append("缺观测/运行命令（bash 块）")
        if f"experiments/ch{expected_chapter(rel):02d}/" not in body and "projects/" not in body:
            r["problems"].append("缺可运行实验入口")
        if not re.search(r"漂移|误匹配|退化|失败|事故|翻车|故障", "\n".join(t for _, t in h2) + body[:6000]):
            r["problems"].append("缺漂移/误匹配/失败案例分析")
        if "母本对应" not in body:
            r["problems"].append("缺「母本对应」节")
        if "本章陷阱" not in body:
            r["problems"].append("缺「本章陷阱」节")
        if "本章出口检查" not in body:
            r["problems"].append("缺「本章出口检查」节")
        if "下一站" not in body:
            r["problems"].append("缺「下一站」节")

        # 陷阱表 8–15 行（强制至少 10 条）
        mt = re.search(r"^##\s*.*?本章陷阱.*?$(.*?)(?=^##\s|\Z)", body, re.M | re.S)
        if mt:
            rows_n = len(re.findall(r"^\|\s*\d+\s*\|", mt.group(1), re.M))
            if not (8 <= rows_n <= 15):
                r["problems"].append(f"陷阱条数={rows_n}（应在 8–15，本书契约要求至少 10 条）")
    return r


def all_src_files():
    out = []
    for base, dirs, files in os.walk(SRC):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for f in files:
            out.append(os.path.normpath(os.path.join(base, f)))
    return out


def check_svgs():
    problems, ids = [], defaultdict(list)
    for path in all_src_files():
        if not path.endswith(".svg"):
            continue
        rel = os.path.relpath(path, SRC)
        try:
            tree = ET.parse(path)
        except Exception as exc:  # noqa: BLE001
            problems.append(f"{rel}: SVG 解析失败：{exc}")
            continue
        root = tree.getroot()
        if "viewBox" not in root.attrib:
            problems.append(f"{rel}: 缺 viewBox")
        tags = {el.tag.split("}")[-1] for el in root.iter()}
        if "title" not in tags or "desc" not in tags:
            problems.append(f"{rel}: 缺 <title>/<desc>")
        raw = open(path, encoding="utf-8").read()
        if re.search(r'(?:href|src)=\"https?://', raw) or 'xlink:href="http' in raw:
            problems.append(f"{rel}: 引用了外部资源")
        for i in re.findall(r'\bid="([^"]+)"', raw):
            ids[i].append(rel)
    return problems, ids


def check_figure_fragments():
    problems, ids = [], defaultdict(list)
    figdir = os.path.join(SRC, "assets", "figures")
    if not os.path.isdir(figdir):
        return problems, ids
    for name in sorted(os.listdir(figdir)):
        if not name.endswith(".md"):
            continue
        path = os.path.join(figdir, name)
        text = open(path, encoding="utf-8").read()
        m = re.search(r"<svg\b.*?</svg>", text, re.S)
        if not m:
            continue
        try:
            root = ET.fromstring(m.group(0))
        except ET.ParseError as exc:
            problems.append(f"figures/{name}: SVG 解析失败：{exc}")
            continue
        if "viewBox" not in root.attrib:
            problems.append(f"figures/{name}: 缺 viewBox")
        tags = {el.tag.split("}")[-1] for el in root.iter()}
        if "title" not in tags or "desc" not in tags:
            problems.append(f"figures/{name}: 缺 <title>/<desc>")
        for i in re.findall(r'\bid="([^"]+)"', text):
            ids[i].append(f"figures/{name}")
    return problems, ids


def main():
    verbose = "--verbose" in sys.argv
    pages = pages_from_summary()
    results = [check_page(t, r) for t, r in pages]
    problems = []

    seen_anchor = defaultdict(list)
    seen_id = defaultdict(list)
    for r in results:
        for a in r["anchors"]:
            seen_anchor[a].append(r["rel"])
        p = os.path.join(SRC, r["rel"])
        if os.path.exists(p):
            rows, _ = strip_fenced(open(p, encoding="utf-8").read())
            body = "\n".join(l for _, in_f, l in rows if not in_f)
            for i in HTML_ID.findall(body):
                seen_id[i].append(r["rel"])

    svg_problems, svg_ids = check_svgs()
    fig_problems, fig_ids = check_figure_fragments()
    svg_problems += fig_problems
    for i, where in svg_ids.items():
        seen_id[i].extend(where)
    for i, where in fig_ids.items():
        seen_id[i].extend(where)

    broken, broken_anchors = [], []
    anchor_map = {r["rel"]: set(r["anchors"]) for r in results}
    for r in results:
        base = os.path.dirname(os.path.join(SRC, r["rel"]))
        for link, anchor in r["links"]:
            target = os.path.normpath(os.path.join(base, link))
            if not os.path.exists(target):
                broken.append((r["rel"], link))
                continue
            trel = os.path.relpath(target, SRC)
            if anchor and trel in anchor_map and anchor not in anchor_map[trel]:
                broken_anchors.append((r["rel"], f"{link}#{anchor}"))

    total = sum(r["lines"] for r in results)
    chapters = [r for r in results if CHAPTER_FILE.match(r["rel"])]
    print(f"pages: {len(results)}  chapters: {len(chapters)}  total lines: {total}")
    bad = [r for r in results if r["problems"]]
    if bad:
        print(f"\n问题页 ({len(bad)}):")
        for r in bad:
            print(f"  {r['rel']:26s} {r['lines']:5d}行  " + "; ".join(r["problems"]))
    dup_a = {a: v for a, v in seen_anchor.items() if len(v) > 1}
    if dup_a:
        print(f"\n重复锚点 ({len(dup_a)}):")
        for a, v in list(dup_a.items())[:30]:
            print(f"  {a}: {', '.join(v)}")
    dup_i = {i: v for i, v in seen_id.items() if len(v) > 1}
    if dup_i:
        print(f"\n重复 HTML/SVG id ({len(dup_i)}):")
        for i, v in list(dup_i.items())[:30]:
            print(f"  {i}: {', '.join(v)}")
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
        for p in svg_problems:
            print("  " + p)

    if verbose:
        print("\n各章:")
        for r in chapters:
            print(f"  {r['rel']:26s} {r['lines']:5d}行 H2={r['h2']:2d} "
                  f"boxes={dict(r['boxes'])}")

    ok = not (bad or dup_a or dup_i or broken or broken_anchors or svg_problems)
    print("\nOK" if ok else "\nFAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
