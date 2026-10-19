#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""本书结构质检：不读全文，只做机械检查，输出短报告。

用法：python3 tools/check_book.py [--verbose]
检查项：
  - SUMMARY 中每个页面存在、非空
  - 每页行数、H2 数、代码块是否闭合
  - 语义盒 ::: 是否配平（含嵌套）
  - 显式锚点 {#...} 是否全书唯一
  - 站内 .md 链接目标是否存在
  - TODO / 「本章正在编写」占位符
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

ANCHOR = re.compile(r"\{#([^}\s]+)\}")
MD_LINK = re.compile(r"\]\(([^)#\s]+\.md)(?:#[^)]*)?\)")
MD_LINK_ANCHOR = re.compile(r"\]\(([^)#\s]+\.md)#([^)]+)\)")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
FENCE = re.compile(r"^\s*(`{3,}|~{3,})")


def pages_from_summary():
    out = []
    for line in open(SUMMARY, encoding="utf-8"):
        m = re.match(r"^- \[(.+?)\]\((.+?)\)$", line.strip())
        if m:
            out.append((m.group(1), m.group(2)))
    return out


def check_page(title, rel):
    path = os.path.join(SRC, rel)
    problems = []
    if not os.path.exists(path):
        return {"title": title, "rel": rel, "missing": True, "lines": 0,
                "h2": 0, "problems": ["missing file"], "anchors": [], "links": []}
    text = open(path, encoding="utf-8").read()
    lines = text.splitlines()
    h2 = sum(1 for l in lines if re.match(r"^##\s+", l))
    # 代码块里的 {#...} / ::: / 链接只是示例，不参与结构检查
    body_lines = []
    in_fence = False
    for l in lines:
        if FENCE.match(l):
            in_fence = not in_fence
            body_lines.append("")
        elif in_fence:
            body_lines.append("")
        else:
            body_lines.append(l)
    body = "\n".join(body_lines)
    # 行内代码里的 {#...} 只是字面量（如 ${#a[@]}），不参与锚点检查
    anchor_body = re.sub(r"`[^`]*`", "", body)
    anchors = ANCHOR.findall(anchor_body)
    links = MD_LINK.findall(body)
    anchor_links = MD_LINK_ANCHOR.findall(body)
    # fences
    fences = 0
    for l in lines:
        if FENCE.match(l):
            fences += 1
    if fences % 2:
        problems.append(f"code fences unclosed ({fences})")
    # boxes
    depth = 0
    min_depth = 0
    for l in body_lines:
        if OPEN_BOX.match(l):
            depth += 1
        elif CLOSE_BOX.match(l):
            depth -= 1
            min_depth = min(min_depth, depth)
    if depth != 0:
        problems.append(f"box depth ends at {depth}")
    if min_depth < 0:
        problems.append("extra ::: closing")
    if re.search(r"本章正在编写|<!--\s*TODO|^TODO:", text, re.M):
        problems.append("placeholder/TODO")
    if len(lines) < 20:
        problems.append("too short")
    return {"title": title, "rel": rel, "missing": False, "lines": len(lines),
            "h2": h2, "problems": problems, "anchors": anchors, "links": links,
            "anchor_links": anchor_links}


def main():
    verbose = "--verbose" in sys.argv
    pages = pages_from_summary()
    results = [check_page(t, r) for t, r in pages]
    # duplicate anchors
    seen = defaultdict(list)
    for r in results:
        for a in r["anchors"]:
            seen[a].append(r["rel"])
    dup = {a: v for a, v in seen.items() if len(v) > 1}
    # broken links
    broken = []
    for r in results:
        for link in r["links"]:
            target = os.path.normpath(os.path.join(os.path.dirname(os.path.join(SRC, r["rel"])), link))
            if not os.path.exists(target):
                broken.append((r["rel"], link))
    # broken anchors
    anchors_by_page = {r["rel"]: set(r["anchors"]) for r in results}
    broken_anchors = []
    for r in results:
        for link, anchor in r.get("anchor_links", []):
            target = os.path.normpath(os.path.join(os.path.dirname(os.path.join(SRC, r["rel"])), link))
            trel = os.path.relpath(target, SRC)
            if trel in anchors_by_page and anchor not in anchors_by_page[trel]:
                broken_anchors.append((r["rel"], link + "#" + anchor))
    # report
    total_lines = sum(r["lines"] for r in results)
    done = [r for r in results if not r["problems"] and r["lines"] >= 150]
    print(f"pages: {len(results)}   total lines: {total_lines}   substantial: {len(done)}")
    bad = [r for r in results if r["problems"]]
    if bad:
        print(f"\n问题页 ({len(bad)}):")
        for r in bad:
            print(f"  {r['rel']:28s} {r['lines']:5d}行  " + "; ".join(r["problems"]))
    if dup:
        print(f"\n重复锚点 ({len(dup)}):")
        for a, v in list(dup.items())[:30]:
            print(f"  {a}: {', '.join(v)}")
    if broken:
        print(f"\n断链 ({len(broken)}):")
        for rel, link in broken[:40]:
            print(f"  {rel} -> {link}")
    if broken_anchors:
        print(f"\n断锚点 ({len(broken_anchors)}):")
        for rel, link in broken_anchors[:40]:
            print(f"  {rel} -> {link}")
    if verbose:
        print("\n各页行数:")
        for r in results:
            print(f"  {r['rel']:28s} {r['lines']:5d}  H2={r['h2']}")
    return 1 if (bad or dup or broken or broken_anchors) else 0


if __name__ == "__main__":
    sys.exit(main())
