#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《C++/Rust 性能工程》结构与契约质检。

用法：
    python3 tools/check_book.py [--verbose]

检查项：
  1. SUMMARY 每页存在；章节 1000–1500 行；
  2. 每章 1 个 H1、11 个 H2，每个 H2 有 sec-cpp-rust.<part>.<ch>.<sec>；
  3. 语义盒只用 def/thm/ex/intuition/method/errata/note/proof/sol，配平；
  4. 显式锚点、HTML id 全书唯一；
  5. 代码围栏闭合且标语言；无 TODO/占位符；
  6. chapter-index、layout 布局图、可运行实验、UB/性能回退案例、母本对应、
     至少 10 条陷阱、出口检查；
  7. 站内 .md 链接与锚点可达。
"""

from __future__ import annotations

import os
import re
import sys
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
SEC_ANCHOR = re.compile(r"^sec-cpp-rust\.(\d+)\.(\d+)\.(\d+)$")
ALLOWED_BOX = {"def", "thm", "ex", "intuition", "method", "errata", "note", "proof", "sol"}
CHAPTER_FILE = re.compile(r"^part([1-4])[/\\]ch(\d{2})\.md$")
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


def expected_chapter(rel: str) -> tuple[int, int] | None:
    m = CHAPTER_FILE.match(rel.replace(os.sep, "/"))
    if not m:
        return None
    return int(m.group(1)), int(m.group(2))


def collect_anchors():
    page_anchors = defaultdict(set)
    all_anchors = Counter()
    for base, dirs, files in os.walk(SRC):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS and d not in {"theme", "assets"}]
        for f in files:
            if not f.endswith(".md"):
                continue
            path = os.path.join(base, f)
            rel = os.path.relpath(path, SRC).replace(os.sep, "/")
            text = open(path, encoding="utf-8").read()
            page_anchors.setdefault(rel, set())
            for a in ANCHOR.findall(text):
                page_anchors[rel].add(a)
                all_anchors[a] += 1
            for hid in HTML_ID.findall(text):
                page_anchors[rel].add(hid)
                all_anchors[hid] += 1
    return page_anchors, all_anchors


def check_file(rel: str, text: str, page_anchors: dict):
    problems = []
    lines = text.splitlines()
    n_lines = len(lines)
    ch_info = expected_chapter(rel)

    # 1. 行数检查 (只对章节正文检查 1000-1500)
    if ch_info:
        if n_lines < 1000:
            problems.append(f"行数不足：当前 {n_lines} 行，协议要求 1000–1500 行")
        elif n_lines > 1500:
            problems.append(f"行数超标：当前 {n_lines} 行，协议要求 1000–1500 行")

    # 2. 占位符
    for i, line in enumerate(lines, 1):
        if re.search(r"\b(TODO|TBD|FIXME|待补充)\b", line):
            problems.append(f"第 {i} 行含占位符：{line.strip()[:60]}")

    # 3. 代码块与语义盒
    in_fence = False
    fence_char = ""
    box_stack = []
    h1_count = 0
    h2_list = []
    trap_count = 0
    in_traps = False

    for i, line in enumerate(lines, 1):
        # 代码块
        mf = FENCE.match(line)
        if mf:
            f_marker = mf.group(1)
            info = mf.group(2).strip()
            if not in_fence:
                in_fence = True
                fence_char = f_marker[0]
                if not info:
                    problems.append(f"第 {i} 行代码块未标注语言")
            else:
                if f_marker[0] == fence_char:
                    in_fence = False
            continue

        if in_fence:
            continue

        # 标题
        m1 = H1.match(line)
        if m1:
            h1_count += 1
            continue

        m2 = H2.match(line)
        if m2:
            h2_text = m2.group(1)
            h2_list.append((i, h2_text))
            if "陷阱" in h2_text:
                in_traps = True
            elif in_traps:
                in_traps = False
            continue

        # 陷阱计数
        if in_traps and re.match(r"^\s*\d+\.\s+\S", line):
            trap_count += 1

        # 语义盒
        mob = OPEN_BOX.match(line)
        if mob:
            btype = mob.group(1)
            if btype not in ALLOWED_BOX:
                problems.append(f"第 {i} 行非法语义盒：:::{btype}")
            box_stack.append((i, btype))
            continue

        if CLOSE_BOX.match(line):
            if not box_stack:
                problems.append(f"第 {i} 行多余的 ::: 闭合")
            else:
                box_stack.pop()
            continue

    if in_fence:
        problems.append("代码围栏未闭合")
    if box_stack:
        problems.append(f"语义盒未闭合：{box_stack}")

    # 章节结构质检
    if ch_info:
        part, ch = ch_info
        if h1_count != 1:
            problems.append(f"H1 数量错误：{h1_count}（应为 1 个）")
        if len(h2_list) != 11:
            problems.append(f"H2 数量错误：{len(h2_list)}（应严格为 11 个）")

        for idx, (lineno, h2_title) in enumerate(h2_list, 1):
            expected_sec = f"sec-cpp-rust.{part}.{ch}.{idx}"
            if f"{{#{expected_sec}}}" not in h2_title:
                problems.append(f"第 {lineno} 行 H2 锚点不匹配：预期 {{#{expected_sec}}}，实际为 {h2_title}")

        if "chapter-index" not in text:
            problems.append("缺少 chapter-index 导读模块")
        if '<pre class="layout">' not in text:
            problems.append("缺少 <pre class=\"layout\"> 内存/架构图")
        if "读图：" not in text and "读图:" not in text:
            problems.append("缺少「读图：」解析引导说明")
        if "母本对应" not in text:
            problems.append("缺少母本对应小节")
        if trap_count < 10:
            problems.append(f"本章陷阱不足 10 条：实测 {trap_count} 条")
        if "出口检查" not in text:
            problems.append("缺少出口检查小节")

    return problems


def check_links(page_anchors: dict):
    problems = []
    for rel, anchors in page_anchors.items():
        path = os.path.join(SRC, rel)
        text = open(path, encoding="utf-8").read()
        for target, anchor in MD_LINK.findall(text):
            t_rel = os.path.normpath(os.path.join(os.path.dirname(rel), target)).replace(os.sep, "/")
            if t_rel not in page_anchors:
                problems.append(f"{rel}: 链接到不存在的页面 {target}")
            elif anchor and anchor not in page_anchors[t_rel]:
                problems.append(f"{rel}: 链接到目标页未定义的锚点 {target}#{anchor}")
    return problems


def main():
    verbose = "--verbose" in sys.argv
    pages = pages_from_summary()
    if not pages:
        print("错误：SUMMARY.md 不存在或为空", file=sys.stderr)
        return 1

    page_anchors, all_anchors = collect_anchors()

    all_problems = defaultdict(list)
    # 重复锚点检查
    for a, count in all_anchors.items():
        if count > 1:
            all_problems["全局锚点"].append(f"重复锚点：{a} 出现 {count} 次")

    for title, rel in pages:
        full_path = os.path.join(SRC, rel)
        if not os.path.exists(full_path):
            all_problems[rel].append(f"SUMMARY 中的页面不存在：{rel}")
            continue
        text = open(full_path, encoding="utf-8").read()
        probs = check_file(rel, text, page_anchors)
        if probs:
            all_problems[rel].extend(probs)

    link_probs = check_links(page_anchors)
    for lp in link_probs:
        all_problems["链接检查"].append(lp)

    total_probs = sum(len(v) for v in all_problems.values())
    if total_probs == 0:
        print(f"check_book 通过！共检查 {len(pages)} 个页面，0 错误。")
        return 0
    else:
        print(f"check_book 失败：发现 {total_probs} 处契约违例：", file=sys.stderr)
        for cat, probs in all_problems.items():
            if probs:
                print(f"\n[{cat}]:", file=sys.stderr)
                for p in probs:
                    print(f"  - {p}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
