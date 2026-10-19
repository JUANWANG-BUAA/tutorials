#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《分布式系统与数据面》结构质检。

用法：
    python3 tools/check_book.py                 # 全部页面
    python3 tools/check_book.py --only part1/ch01.md
    python3 tools/check_book.py --verbose

检查项：
  - SUMMARY 页面存在、非空
  - 正文章节 1000–1400 行；卷首/附录 ≥ 40 行
  - 代码围栏成对，且开启围栏必须带语言
  - 语义盒配平，只允许 def/thm/ex/intuition/method/errata/note/proof/sol
  - 显式锚点唯一，且符合 sec-/def-/...-distributed.<part>.<ch>.<n>
  - 站内 .md 链接与 #锚点存在
  - 每章：失败模式、观测、真实案例、重复副作用、8–15 条陷阱、出口检查、母本对应、下一站
  - TODO / 占位符
"""

from __future__ import annotations

import os
import re
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")
SUMMARY = os.path.join(SRC, "SUMMARY.md")

ANCHOR = re.compile(r"\{#([^}\s]+)\}")
MD_LINK = re.compile(r"\]\(([^)\s]+?\.md)(?:#([^)\s]+))?\)")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)\s*(.*?)\s*$")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
FENCE = re.compile(r"^\s*(`{3,}|~{3,})(.*)$")
ALLOWED_BOXES = {"def", "thm", "ex", "intuition", "method", "errata", "note", "proof", "sol"}
CHAPTER_MIN, CHAPTER_MAX = 1000, 1400
ANCHOR_RE = re.compile(
    r"^(?:sec|def|thm|ex|intuition|method|errata|note|proof|sol)"
    r"-distributed\.\d+\.\d+\.\d+$")


def pages_from_summary():
    out = []
    for line in open(SUMMARY, encoding="utf-8"):
        m = re.match(r"^\s*(?:-\s*)?\[(.+?)\]\((.+?\.md)\)\s*$", line.strip())
        if m:
            out.append((m.group(1), m.group(2)))
    return out


def is_chapter(rel: str) -> bool:
    return bool(re.match(r"^part\d+/ch\d+\.md$", rel))


def split_fences(lines):
    """返回 (body_lines, fence_count, opening_without_lang)。"""
    body, count, no_lang = [], 0, []
    fence = None
    for line in lines:
        m = FENCE.match(line)
        if m:
            marker, info = m.group(1), m.group(2).strip()
            if fence is None:
                fence = marker[0]
                count += 1
                if not info or info.startswith("{"):
                    # `{...}` 是 mdBook 的属性语法，仍算无语言
                    no_lang.append(line.strip())
                body.append("")
                continue
            if marker[0] == fence:
                fence = None
                count += 1
                body.append("")
                continue
        body.append("" if fence is not None else line)
    return body, count, no_lang


def check_page(title, rel):
    path = os.path.join(SRC, rel)
    if not os.path.exists(path):
        return {"title": title, "rel": rel, "missing": True, "lines": 0, "h2": 0,
                "problems": ["missing file"], "anchors": [], "links": [],
                "anchor_links": [], "body": ""}
    text = open(path, encoding="utf-8").read()
    lines = text.splitlines()
    body_lines, fences, no_lang = split_fences(lines)
    body = "\n".join(body_lines)
    h2 = sum(1 for l in body_lines if re.match(r"^##\s+", l))
    problems = []
    if fences % 2:
        problems.append(f"code fences unclosed ({fences})")
    if no_lang:
        problems.append(f"{len(no_lang)} code fence(s) without language: {no_lang[0][:40]}")
    # 锚点（排除行内代码）
    anchor_body = re.sub(r"`[^`]*`", "", body)
    anchors = ANCHOR.findall(anchor_body)
    mfile = re.match(r"^part(\d+)/ch(\d+)\.md$", rel)
    if mfile and is_chapter(rel):
        part, ch = int(mfile.group(1)), int(mfile.group(2))
        nums = []
        for line in body_lines:
            hm = re.match(r"^##\s+(\d+)\.(\d+)\s", line)
            if not hm:
                continue
            if int(hm.group(1)) != ch:
                problems.append(f"H2 chapter number mismatch: {line[:40]}")
            nums.append(int(hm.group(2)))
            want = f"{{#sec-distributed.{part}.{ch}.{hm.group(2)}}}"
            if want not in line:
                problems.append(f"H2 missing/mismatched anchor: {line[:50]}")
        if nums and sorted(set(nums)) != list(range(1, max(nums) + 1)):
            problems.append(f"H2 numbers not contiguous: {nums}")
    for a in anchors:
        if not ANCHOR_RE.match(a):
            problems.append(f"bad anchor pattern: {a}")
            continue
        if mfile:
            ma = re.match(r"^[a-z]+-distributed\.(\d+)\.(\d+)\.(\d+)$", a)
            if ma and (int(ma.group(1)) != int(mfile.group(1)) or
                       int(ma.group(2)) != int(mfile.group(2))):
                problems.append(f"anchor part/ch mismatch: {a} (file {rel})")
    # 盒子
    depth, min_depth = 0, 0
    for l in body_lines:
        mo = OPEN_BOX.match(l)
        if mo:
            typ, rest = mo.group(1), mo.group(2)
            if typ not in ALLOWED_BOXES:
                problems.append(f"box type not allowed: {typ}")
            if rest.startswith("["):
                problems.append(f"box priority marker not allowed: {l.strip()[:50]}")
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

    links = []
    anchor_links = []
    for m in MD_LINK.finditer(body):
        target, anchor = m.group(1), m.group(2)
        if target.startswith(("http://", "https://", "/")):
            continue
        # 只接受站内相对 .md
        links.append(target)
        if anchor:
            anchor_links.append((target, anchor))

    n = len(lines)
    if is_chapter(rel):
        if not (CHAPTER_MIN <= n <= CHAPTER_MAX):
            problems.append(f"chapter lines {n} not in {CHAPTER_MIN}-{CHAPTER_MAX}")
        if "本章回答" not in body or "读完你会" not in body:
            problems.append("missing chapter-index labels")
        for label, pat in [
            ("失败模式", r"^## .*失败模式"),
            ("观测", r"^## .*观测"),
            ("真实案例", r"^## .*真实案例"),
            ("重试重复副作用", r"重复副作用"),
            ("出口检查", r"^## .*出口检查"),
            ("母本对应", r"^##\s+母本对应"),
            ("下一站", r"下一站"),
        ]:
            if not re.search(pat, body, re.M):
                problems.append(f"missing required: {label}")
        if not re.search(r"^## .*陷阱", body, re.M):
            problems.append("missing required: 陷阱清单 heading")
        # 8–15 条陷阱：最后一个 errata 块里的编号条目
        blocks = re.findall(r"::: errata[^\n]*\n(.*?)\n:::", body, re.S)
        if blocks:
            items = re.findall(r"^\s*\d+\.\s+", blocks[-1], re.M)
            if not (8 <= len(items) <= 15):
                problems.append(f"traps count {len(items)} not in 8-15")
        else:
            problems.append("missing errata box")
        if not re.search(r"assets/figures/|pre class=\"layout\"", body):
            problems.append("missing figure/layout")
        tagged = 0
        fence = None
        for line in lines:
            fm = FENCE.match(line)
            if not fm:
                continue
            marker, info = fm.group(1), fm.group(2).strip()
            if fence is None:
                fence = marker[0]
                if info:
                    tagged += 1
            elif marker[0] == fence:
                fence = None
        if tagged < 2:
            problems.append("fewer than 2 language-tagged code fences")
    else:
        if n < 40:
            problems.append(f"page too short ({n})")

    return {"title": title, "rel": rel, "missing": False, "lines": n, "h2": h2,
            "problems": problems, "anchors": anchors, "links": links,
            "anchor_links": anchor_links, "body": body}


def main(argv):
    verbose = "--verbose" in argv
    only = None
    if "--only" in argv:
        i = argv.index("--only")
        if i + 1 >= len(argv):
            raise SystemExit("--only 需要一个相对 src/ 的路径")
        only = argv[i + 1].lstrip("./")

    pages = pages_from_summary()
    results = [check_page(t, r) for t, r in pages]
    by_rel = {r["rel"]: r for r in results}

    seen = defaultdict(list)
    for r in results:
        for a in r["anchors"]:
            seen[a].append(r["rel"])
    dup = {a: v for a, v in seen.items() if len(v) > 1}

    broken, broken_anchors = [], []
    for r in results:
        if r["missing"]:
            continue
        base = os.path.dirname(os.path.join(SRC, r["rel"]))
        for link in r["links"]:
            target = os.path.normpath(os.path.join(base, link))
            if not os.path.exists(target):
                broken.append((r["rel"], link))
        for link, anchor in r["anchor_links"]:
            target = os.path.normpath(os.path.join(base, link))
            try:
                trel = os.path.relpath(target, SRC)
            except ValueError:
                continue
            if trel in by_rel and anchor not in set(by_rel[trel]["anchors"]):
                broken_anchors.append((r["rel"], link + "#" + anchor))

    if only:
        results = [r for r in results if r["rel"] == only]
        if not results:
            raise SystemExit(f"--only {only} 不在 SUMMARY 中")

    total = sum(r["lines"] for r in results)
    print(f"pages: {len(results)}   total lines: {total}")
    bad = [r for r in results if r["problems"]]
    if bad:
        print(f"\n问题页 ({len(bad)}):")
        for r in bad:
            print(f"  {r['rel']:24s} {r['lines']:5d}行  " + "; ".join(r["problems"]))
    if not only and dup:
        print(f"\n重复锚点 ({len(dup)}):")
        for a, v in list(dup.items())[:30]:
            print(f"  {a}: {', '.join(v)}")
    if not only and broken:
        print(f"\n断链 ({len(broken)}):")
        for rel, link in broken[:40]:
            print(f"  {rel} -> {link}")
    if not only and broken_anchors:
        print(f"\n断锚点 ({len(broken_anchors)}):")
        for rel, link in broken_anchors[:40]:
            print(f"  {rel} -> {link}")
    if verbose:
        print("\n各页行数:")
        for r in results:
            print(f"  {r['rel']:24s} {r['lines']:5d}  H2={r['h2']}")
    ok = not bad and (only or (not dup and not broken and not broken_anchors))
    print("\nOK" if ok else "\nFAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
