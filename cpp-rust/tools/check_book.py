#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《C++/Rust 性能工程》结构与契约质检。

用法：
    python3 tools/check_book.py [--verbose]

检查项：
  1. SUMMARY 每页存在；章节正文 6000–30000 个汉字，单个 H2 小节不超过 5000 汉字；
  2. 每章 1 个 H1、11 个 H2，每个 H2 有 sec-cpp-rust.<part>.<ch>.<sec>；
  3. 语义盒只用 def/thm/ex/intuition/think/method/errata/note/preview/proof/sol/hint，配平；
  4. 显式锚点、HTML id 全书唯一；
  5. 代码围栏闭合且标语言；无 TODO/占位符；
  6. chapter-index、layout 布局图、可运行实验、UB/性能回退案例、来源/延伸阅读、
     至少 10 条常见错误/陷阱、章末件链接（总结/回忆卡/习题集/自测卷/自检表）；
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
CURLY = re.compile(r"[“‘]([^”’]{1,80})[”’]")
MD_LINK = re.compile(r"\]\(([^)#\s]+\.md)(?:#([^)]*))?\)")
INCLUDE = re.compile(r"\{\{#include\s+([^}]+?)\s*\}\}")
HTML_ID = re.compile(r'\bid="([^"]+)"')
SEC_ANCHOR = re.compile(r"^sec-cpp-rust\.(\d+)\.(\d+)\.(\d+)$")
ALLOWED_BOX = {"def", "thm", "ex", "intuition", "think", "method", "errata", "note",
               "preview", "proof", "sol", "hint"}
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


PARA_BUDGET = 200


def check_paragraph_budget(lines):
    """单段汉字预算：超过 200 字的一段，读者要回读才能抓住主干。

    语义盒里的正文同样计入——盒只是版式，不是长度豁免；列表项按条目计。
    2026-10-30 定的这条，起因是「段均」经实测证明量的是列表密度而不是行文节奏，
    跨书不可比，换成「最长段」这种能直接指向具体段落的上限。
    """
    problems = []
    in_code = False
    depth = 0
    buf = []
    start = 0

    def flush():
        if buf:
            n = sum(len(re.findall(r"[一-鿿]", s)) for s in buf)
            if n > PARA_BUDGET:
                problems.append(
                    f"第 {start} 行段落过长：{n} 个汉字，单段预算 {PARA_BUDGET}，"
                    f"请在句子边界断开")
        buf.clear()

    for i, raw in enumerate(lines, 1):
        s = raw.strip()
        if s.startswith("```"):
            in_code = not in_code
            flush()
            continue
        if in_code:
            continue
        if re.match(r"^::: \w+", s):
            flush()
            depth += 1
            continue
        if s.startswith(":::"):
            flush()
            depth = max(depth - 1, 0)
            continue
        if not s or s.startswith(("#", "|", "<", "!", "---")):
            # 标题、表格、HTML 与 SVG 里的 <desc> 都不算「一段话」：<desc> 是图片替代文本，
            # 本来就要写得比正文密，把它当超长段会制造假告警。
            flush()
            continue
        if re.match(r"^([-*+]|\d+\.)\s", s):
            flush()
            start = i
            buf.append(s)
            continue
        if not buf:
            start = i
        buf.append(s)
    flush()
    return problems


def check_file(rel: str, text: str, page_anchors: dict, known_ids=None):
    problems = []
    lines = text.splitlines()
    n_lines = len(lines)
    ch_info = expected_chapter(rel)

    # 1. 篇幅检查：按汉字数而不是行数。一句一行会把行数虚增两三倍。
    if ch_info:
        cn_count = len(re.findall(r"[\u4e00-\u9fff]", text))
        if cn_count < 6000:
            problems.append(f"正文过短：当前 {cn_count} 个汉字，教材正文至少 6000 个汉字")
        elif cn_count > 30000:
            problems.append(f"正文过长：当前 {cn_count} 个汉字，超过 30000")
        # 单节预算：章节体量大不等于某一节可以写成资料堆。
        # 参照《矩阵论》：一节独立成页约 5000 汉字。
        starts = [i for i, ln in enumerate(lines) if ln.startswith("## ")] + [len(lines)]
        for a, b in zip(starts, starts[1:]):
            seg = "\n".join(lines[a:b])
            n = len(re.findall(r"[\u4e00-\u9fff]", seg))
            if n > 5000:
                problems.append(
                    f"第 {a + 1} 行小节过长：{n} 个汉字，单节预算 5000，"
                    f"请拆到章末件或压缩叙述")
        problems.extend(check_paragraph_budget(lines))

    # 2. 未转义的尖括号：`Vec<u64>` 写在正文里会被当成 HTML 标签吞掉
    allowed = {"div", "span", "pre", "code", "em", "strong", "sub", "sup", "br", "a",
               "img", "p", "ul", "ol", "li", "table", "thead", "tbody", "tr", "td", "th",
               "figure", "figcaption", "details", "summary", "h3", "h4", "label", "input",
               "svg", "defs", "marker", "path", "rect", "line", "circle", "text", "g",
               "title", "desc", "sup"}
    in_fence_now = False
    for i, line in enumerate(lines, 1):
        if FENCE.match(line):
            in_fence_now = not in_fence_now
            continue
        if in_fence_now:
            continue
        mo = OPEN_BOX.match(line)
        if mo and re.search(r"<[A-Za-z]", mo.group(2)):
            problems.append(
                f"第 {i} 行盒子标题里有尖括号：标题不做 Markdown 渲染，"
                f"`Vec<u64>` 会变成 HTML 标签，改写成「Vec 的 u64 元素」之类")
        bare = re.sub(r"`[^`]*`", "", line)          # 行内代码里的泛型是安全的
        bare = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", bare)  # 链接文字同理
        if re.search(r"<(?![A-Za-z/!])", bare):
            problems.append(
                f"第 {i} 行有裸的小于号（后面不是字母）：Markdown 会当成 HTML 标签开头，"
                f"数学里改用 \\lt，正文里写成「小于」或放进反引号")
        for tag in re.findall(r"<([A-Za-z][A-Za-z0-9_]*)", bare):
            if tag not in allowed:
                problems.append(
                    f"第 {i} 行有未转义的尖括号 `<{tag}...>`：放进反引号里，"
                    f"否则会被当成 HTML 标签")
                break

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
    errata_depth = 0

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

        # 2b. 引号排版：中文引用一律用「」/『』，只有纯英文引文允许弯引号
        for mq in CURLY.finditer(line):
            if re.search(r"[一-鿿]", mq.group(1)):
                problems.append(
                    f"第 {i} 行中文引用用了弯引号：改为「」（只换引号字符，不改内容）—— "
                    f"{mq.group(0)[:40]}")

        # 标题
        m1 = H1.match(line)
        if m1:
            h1_count += 1
            continue

        m2 = H2.match(line)
        if m2:
            h2_text = m2.group(1)
            h2_list.append((i, h2_text))
            if "陷阱" in h2_text or "常见错误" in h2_text:
                in_traps = True
            elif in_traps:
                in_traps = False
            continue

        # 语义盒
        mob = OPEN_BOX.match(line)
        if mob:
            btype = mob.group(1)
            if btype not in ALLOWED_BOX:
                problems.append(f"第 {i} 行非法语义盒：:::{btype}")
            box_stack.append((i, btype))
            if btype == "errata":
                errata_depth += 1
            continue

        if CLOSE_BOX.match(line):
            if not box_stack:
                problems.append(f"第 {i} 行多余的 ::: 闭合")
            else:
                _, btype = box_stack.pop()
                if btype == "errata":
                    errata_depth -= 1
            continue

        # 独立成行的锚点 id：mdBook 与 mathbook 只认盒子标题行上的 {#id}，
        # 写成单独一段会让预处理器认为该锚点不存在（构建中止），而本脚本原本
        # 是全文扫 {#id}，看不出这个错位——今天错了三次，故升级为硬错误。
        if re.fullmatch(r"\{#[A-Za-z0-9._:-]+\}", line.strip()):
            problems.append(
                f"第 {i} 行把锚点 id 单独写成一段：id 必须跟在盒子标题行末尾"
                "（形如 `::: def 定义 1.1.1 · 名` 后接花括号井号 id），"
                "否则预处理器不认，mdbook build 会中止")

        # 陷阱计数：章末清单里的编号条目
        if in_traps and re.match(r"^\s*\d+\.\s+\S", line):
            trap_count += 1

        # 节内 errata 盒的每一条 E-x 也算一条常见错误
        if errata_depth > 0:
            trap_count += len(re.findall(r"^\s*E-[a-z0-9]+[\s*：:]", line))

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

        if "新手入口" not in text:
            problems.append("缺少「新手入口」块：开头要告诉零基础读者需要先会什么、先读哪两节、可跳过什么")
        if "chapter-index" not in text:
            problems.append("缺少 chapter-index 导读模块")
        if '<pre class="layout">' not in text and "<svg" not in text:
            problems.append("缺少图示：既没有 <pre class=\"layout\"> 结构图，也没有内联 SVG")
        if "<svg" in text and 'role="img"' not in text:
            problems.append("内联 SVG 缺少 role=\"img\"，读屏软件无法识别为图片")
        if "<svg" in text and "<desc" not in text:
            problems.append("内联 SVG 缺少 <desc> 文字说明，图的内容不可提取")
        if "读图：" not in text and "读图:" not in text:
            problems.append("缺少「读图：」解析引导说明")
        if "母本对应" not in text and "延伸阅读" not in text:
            problems.append("缺少来源/延伸阅读小节")
        if trap_count < 10:
            problems.append(f"本章常见错误/陷阱不足 10 条：实测 {trap_count} 条")
        stem = f"ch{ch:02d}_"
        # 只对「已经开工的章末件」生效：磁盘上有 chNN_*.md 时，正文必须链过去。
        # 未整理的章不报，避免把「第 2–16 章还没做」当成契约违例淹没真正的回归。
        on_disk = {f for f in os.listdir(os.path.dirname(os.path.join(SRC, rel)))
                   if f.startswith(stem) and f.endswith(".md")}
        end_pages = {t for t, _ in MD_LINK.findall(text) if t.startswith(stem)}
        if on_disk and len(end_pages) < 3:
            problems.append(
                f"章末件不足：正文应链到 {stem}summary、{stem}exercises、"
                f"{stem}checklist 等页（实测 {len(end_pages)} 个）")

    # 11a. 同页 `](#id)` 链接必须指向本页真实存在的锚点
    local_ids = page_anchors.get(rel, set())
    for anchor in re.findall(r"\]\(#([^)\s]+)\)", text):
        if anchor not in local_ids:
            problems.append(f"同页链接指向不存在的锚点：](#{anchor})")

    # 11. [@id] 交叉引用必须指向全书某个已定义锚点（预处理器会因悬空引用中止构建）
    if known_ids is not None:
        for rid in re.findall(r"\[@([A-Za-z0-9._:\-]+)\]", text):
            if rid not in known_ids:
                problems.append(f"交叉引用指向不存在的锚点：[@{rid}]")

    return problems


def check_endmatter_contract(root_dir: str):
    """章末件的内容契约：自测卷必须有主线归堆表，自检表必须有指向它的指针，
    习题集每题必须有解答盒。

    这三样都是一轮一轮补出来的，没有门禁就会在下一轮改写里悄悄掉回去。
    只检查「已经存在的页」，避免把未开工的章当成契约违例。
    """
    problems = []
    for part in ("part1", "part2", "part3", "part4"):
        directory = os.path.join(root_dir, part)
        if not os.path.isdir(directory):
            continue
        for name in sorted(os.listdir(directory)):
            if name.endswith("_exam.md"):
                text = open(os.path.join(directory, name), encoding="utf-8").read()
                if "每题落在主线哪一步" not in text:
                    problems.append(
                        f"{part}/{name}: 缺少「每题落在主线哪一步」表——"
                        f"自测卷必须逐题标出主导步，否则分数说不出缺哪一步的证据")
            elif name.endswith("_checklist.md"):
                text = open(os.path.join(directory, name), encoding="utf-8").read()
                if "每题落在主线哪一步" not in text:
                    problems.append(
                        f"{part}/{name}: 自检表没有指向自测卷主线归堆表的指针，"
                        f"两处会各自长出一份口径")
            elif name.endswith("_exercises.md"):
                text = open(os.path.join(directory, name), encoding="utf-8").read()
                marks = [(m.start(), m.group(1))
                         for m in re.finditer(r"(?m)^::: (ex|sol|hint) ", text)]
                for i, (pos, kind) in enumerate(marks):
                    if kind != "ex":
                        continue
                    rest = [k for _, k in marks[i + 1:]]
                    if "sol" not in rest[:rest.index("ex") if "ex" in rest else len(rest)]:
                        title = text[pos:pos + 60].splitlines()[0].strip()
                        problems.append(
                            f"{part}/{name}: 「{title}」没有解答盒——"
                            f"习题集每题都要有可展开的解答，否则读者无法自查")
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
        probs = check_file(rel, text, page_anchors, set(all_anchors))
        if probs:
            all_problems[rel].extend(probs)

    for problem in check_endmatter_contract(SRC):
        all_problems["章末件契约"].append(problem)

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
