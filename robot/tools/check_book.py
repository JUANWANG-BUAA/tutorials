#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《机器人控制技术》结构与引用质检。

用法：
    python3 tools/check_book.py            # 短报告，0 = 全过
    python3 tools/check_book.py --verbose  # 附每文件的问题明细

检查项：
  1. SUMMARY 每页存在且非空；
  2. 每个内容文件恰有一个 H1（Markdown 或封面 <h1>）；
  3. 语义盒（:::）配平，类型合法；
  4. 代码围栏配平；
  5. 行内 / 块级公式定界符配平；
  6. {#锚点}、<a id>、标题 slug 全书唯一；[@引用] 与站内链接（含 #锚点）可达；
  7. 相对路径图片存在；
  8. 无 TODO / FIXME 占位符。

锚点体系说明：本书锚点有三种来源——盒子标题的 {#name}、正文里手写的
<a id="sec-x.y.z"></a>（mathbook 预处理器据其生成跳转目标）、以及 mdBook
对标题自动生成的 slug（中文保字、去标点、空格转 -）。三者对 #片段 链接
一律有效。
"""

from __future__ import annotations

import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")

SUMMARY_ENTRY = re.compile(r"\[[^\]]+\]\(([^)#\s]+\.md)(?:#([^)]*))?\)")
FENCE = re.compile(r"^\s*(`{3,}|~{3,})(.*)$")
OPEN_BOX = re.compile(r"^\s*:::\s*([A-Za-z][\w-]*)(\[[^\]]*\])?.*$")
CLOSE_BOX = re.compile(r"^\s*:::\s*$")
ANCHOR_DEF = re.compile(r"\{#([^}\s]+)\}")
HTML_ID = re.compile(r"\bid=\"([^\"]+)\"")
CITE = re.compile(r"\[@([A-Za-z][\w.-]*)\]")
MD_LINK = re.compile(r"\[[^\]]*\]\(([^)\s]+?\.md)(?:#([^)\s]*))?\)")
IMG = re.compile(r"!\[[^\]]*\]\(([^)\s]+)\)")
MD_H1 = re.compile(r"^#\s+\S")
MD_HEADING = re.compile(r"^\s{0,3}(#{1,6})\s+(.*?)\s*#*\s*$")
ALLOWED_BOX = {"def", "thm", "ex", "sol", "note", "think", "intuition",
               "method", "errata", "proof", "preview"}
PLACEHOLDER = re.compile(r"\b(TODO|FIXME)\b")
EXCLUDE_H1 = ("SUMMARY.md",)


def mdbook_slug(text):
    """mdBook 的标题 slug：小写、去标点、空格转 -（保留 CJK 与数字）。"""
    out = []
    for ch in text.strip().lower():
        if ch.isalnum() or ch in "_-":
            out.append(ch)
        elif ch.isspace():
            out.append("-")
    return "".join(out)


def split_fences(lines):
    """Return (code-free numbered lines, fence problems)."""
    out, problems, fence = [], [], None
    for no, line in enumerate(lines, 1):
        m = FENCE.match(line)
        if m:
            if fence is None:
                fence = m.group(1)
            elif m.group(1)[0] == fence[0] and len(m.group(1)) >= len(fence):
                fence = None
            continue
        if fence is None:
            out.append((no, line))
    if fence is not None:
        problems.append("文件结尾：代码围栏未闭合")
    return out, problems


def math_balance(text):
    """块级 $$ 与行内 $ 各自配平（先剥 \\$ 转义与行内代码）。"""
    problems = []
    text = text.replace("\\$", "")
    parts = re.split(r"(`[^`\n]*`)", text)
    dollar_total = 0
    block_total = 0
    for part in parts:
        if part.startswith("`"):
            continue
        block_total += part.count("$$")
        dollar_total += part.replace("$$", "").count("$")
    if block_total % 2:
        problems.append(f"$$ 定界符不配平（{block_total} 个）")
    if dollar_total % 2:
        problems.append(f"行内 $ 不配平（{dollar_total} 个）")
    return problems


def load_book():
    pages = []
    with open(os.path.join(SRC, "SUMMARY.md"), encoding="utf-8") as fh:
        for line in fh:
            m = SUMMARY_ENTRY.search(line)
            if m:
                pages.append(m.group(1))
    return pages


def main():
    verbose = "--verbose" in sys.argv
    problems: dict[str, list[str]] = {}

    pages = load_book()
    files = []
    for base, _dirs, names in os.walk(SRC):
        for name in names:
            if name.endswith(".md"):
                rel = os.path.relpath(os.path.join(base, name), SRC)
                files.append(rel.replace(os.sep, "/"))
    files.sort()

    def flag(path, message):
        problems.setdefault(path, []).append(message)

    # Pass 1: per-file structure; collect anchor definitions.
    texts: dict[str, list[str]] = {}
    anchors: dict[str, str] = {}
    heading_slugs: dict[str, set[str]] = {}
    for rel in files:
        path = os.path.join(SRC, rel)
        with open(path, encoding="utf-8") as fh:
            lines = fh.read().splitlines()
        texts[rel] = lines
        body, fence_problems = split_fences(lines)
        for message in fence_problems:
            flag(rel, message)

        if rel not in EXCLUDE_H1 and not rel.startswith("assets/"):
            h1 = sum(1 for _, line in body if MD_H1.match(line))
            h1 += sum(1 for _, line in body if re.match(r"^\s*<h1[\s>]", line))
            if h1 != 1:
                flag(rel, f"H1 数量为 {h1}（应为 1）")

        depth = 0
        for no, line in body:
            open_m = OPEN_BOX.match(line)
            if open_m and CLOSE_BOX.match(line) is None:
                depth += 1
                if open_m.group(1) not in ALLOWED_BOX:
                    flag(rel, f"L{no}: 未知盒类型 `{open_m.group(1)}`")
            elif CLOSE_BOX.match(line):
                depth -= 1
                if depth < 0:
                    flag(rel, f"L{no}: 多余的 ::: 闭合")
                    depth = 0
        if depth:
            flag(rel, f"语义盒未配平（{depth} 个未闭合）")

        slugs: set[str] = set()
        local_ids: set[str] = set()
        for no, line in body:
            for m in ANCHOR_DEF.finditer(line):
                name = m.group(1)
                if name in anchors:
                    flag(rel, f"L{no}: 锚点 {name} 重复定义（另见 {anchors[name]}）")
                else:
                    anchors[name] = rel
            # HTML id（含 SVG marker/pattern 与手写 <a id>）按 HTML 语义只要求
            # 页面内唯一；跨页复用同一 id（如各图共用的 arrow-* marker）是惯例。
            for m in HTML_ID.finditer(line):
                name = m.group(1)
                if name in local_ids:
                    flag(rel, f"L{no}: 文件内重复 id {name}")
                else:
                    local_ids.add(name)
                if name not in anchors:
                    anchors[name] = rel
            hm = MD_HEADING.match(line)
            if hm:
                # 同页同名标题由 mdBook 自动加 -1/-2 后缀，属正常行为；
                # 只有片段链接真的指向歧义 slug 时才会出问题（Pass 2 已查）。
                slugs.add(mdbook_slug(hm.group(2)))
        heading_slugs[rel] = slugs

        text = "\n".join(lines)
        for message in math_balance(text):
            flag(rel, message)
        for no, line in enumerate(lines, 1):
            if PLACEHOLDER.search(line):
                flag(rel, f"L{no}: 占位符 {PLACEHOLDER.search(line).group(1)}")

    # SUMMARY entries exist and are non-empty.
    for rel in pages:
        if rel not in texts:
            flag("SUMMARY.md", f"条目不存在：{rel}")
        elif len([ln for ln in texts[rel] if ln.strip()]) < 3:
            flag("SUMMARY.md", f"条目近乎为空：{rel}")

    # Pass 2: cross references.
    for rel, lines in texts.items():
        body, _ = split_fences(lines)
        base = os.path.dirname(rel)
        for no, line in body:
            for m in CITE.finditer(line):
                if m.group(1) not in anchors:
                    flag(rel, f"L{no}: [@{m.group(1)}] 无对应锚点")
            for m in MD_LINK.finditer(line):
                target, frag = m.group(1), m.group(2)
                resolved = os.path.normpath(os.path.join(base, target))
                resolved = resolved.replace(os.sep, "/")
                if resolved not in texts:
                    flag(rel, f"L{no}: 链接不可达：{target}")
                    continue
                if frag:
                    defined = {n for n, f in anchors.items() if f == resolved}
                    if (frag not in defined
                            and frag not in heading_slugs.get(resolved, set())):
                        flag(rel, f"L{no}: 锚点缺失：{target}#{frag}")
            for m in IMG.finditer(line):
                src = m.group(1)
                if src.startswith(("http://", "https://", "/")):
                    continue
                resolved = os.path.normpath(os.path.join(base, src))
                if not os.path.exists(os.path.join(SRC, resolved)):
                    flag(rel, f"L{no}: 图片不存在：{src}")

    total = sum(len(v) for v in problems.values())
    if total == 0:
        print(f"check_book: OK（{len(files)} 个文件，{len(anchors)} 个显式锚点，"
              f"{len(pages)} 个 SUMMARY 条目）")
        return 0

    print(f"check_book: {total} 个问题，分布在 {len(problems)} 个文件")
    for rel in sorted(problems):
        print(f"  {rel}")
        items = problems[rel]
        for message in items[:8 if not verbose else None]:
            print(f"    - {message}")
        if not verbose and len(items) > 8:
            print(f"    ... 还有 {len(items) - 8} 条（--verbose 查看）")
    return 1


if __name__ == "__main__":
    sys.exit(main())
