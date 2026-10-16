#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""build_glossary — 从**构建产物**里抽出术语表，产出 book/glossary.json。

为什么在构建后跑（与 tools/build_search_js.mjs 同一模式）：
  术语的「一句话」里全是公式，只有渲染过的 HTML 才是读者该看到的样子；从 Markdown
  抽会得到生 LaTeX，塞进工具提示里既难看又要再引一次 KaTeX。

数据来源（三本各自已有的索引页，不新增内容）：
  matrix     src/memory-sheet.md      概念 / 一句话 / 最容易漏
  numerical  src/review/glossary.md   中文 / English / 一句话 / 出处
  robot      src/preface-index.md     术语 / 英文 / 一句话含义 / 出处

产出：book/glossary.json —— 前端由 theme/js/framework.js 读取（渐进增强：
文件缺失或读取失败时页面完全不受影响）。

用法：python3 tools/build_glossary.py <book 目录>      （在 mdbook build 之后）
"""

import html
import json
import os
import posixpath
import re
import sys

SOURCES = {
    "matrix": {
        "page": "memory-sheet.html",
        "columns": {"term": ["概念"], "def": ["一句话"], "extra": ["最容易漏"]},
    },
    "numerical": {
        "page": "review/glossary.html",
        "columns": {"term": ["中文"], "en": ["English"], "def": ["一句话"], "origin": ["出处"]},
    },
    "robot": {
        "page": "preface-index.html",
        "columns": {"term": ["术语"], "en": ["英文"], "def": ["一句话含义"], "origin": ["出处"]},
    },
    "deeplearning": {
        "page": "review/glossary.html",
        "columns": {"term": ["中文"], "en": ["English"], "def": ["一句话"], "origin": ["出处"]},
    },
}

TAG = re.compile(r"<[^>]+>")
ROW = re.compile(r"<tr>(.*?)</tr>", re.S)
CELL = re.compile(r"<t[hd][^>]*>(.*?)</t[hd]>", re.S)
TABLE = re.compile(r"<table>.*?</table>", re.S)
HEADING = re.compile(r'<h([1-6])[^>]*id="([^"]+)"', re.I)
# 术语别名：中日韩、字母数字、连字符、加号（如「2-范数」），长度 2–12
TERM_OK = re.compile(r"^[\u3400-\u9fff\w+\-·]{2,12}$")


def strip_tags(fragment: str) -> str:
    return html.unescape(TAG.sub("", fragment)).strip()


def aliases(raw_html: str):
    """把一个术语单元格拆成若干可匹配的别名。

    「数域 $F$」→ 数域；「极大无关组 / 秩」→ 极大无关组、秩；
    「谱范数（2-范数）」→ 谱范数（括号里是注释，不进正文匹配）。
    """
    text = re.split(r"[（(]", strip_tags(raw_html))[0]
    out = []
    for part in re.split(r"[/、·|]", text):
        part = part.strip("：:，,。. ")
        # 「数域 $F$」这类单元格：取空格前的部分作为正文可匹配的别名
        candidates = [part] + part.split()
        for candidate in candidates:
            candidate = candidate.strip("$，,。.")
            if TERM_OK.match(candidate) and candidate not in out:
                out.append(candidate)
    return out


def locate(header, columns):
    """按表头名字定位各列下标；找不到的列返回 -1。"""
    index = {}
    for key, names in columns.items():
        index[key] = next(
            (i for i, cell in enumerate(header) if any(name in strip_tags(cell) for name in names)),
            -1,
        )
    return index


MATHML = re.compile(r'<span class="katex-mathml">.*?</span>\s*</span>', re.S)
# 更稳的剥法：直接删掉 katex-mathml 与它配对的整段
MATHML_SPAN = re.compile(r'<span class="katex-mathml">.*?</math></span>', re.S)
TAG_ANY = re.compile(r"<[^>]+>")
DEF_TEXT_LIMIT = 420


def trim_html(fragment: str, limit: int = DEF_TEXT_LIMIT) -> str:
    """按「顶层标签边界」截断：够了就停，保证标签配对、不会截断公式中间。"""
    depth = 0
    texts = 0
    cut = len(fragment)
    pos = 0
    for match in TAG_ANY.finditer(fragment):
        texts += len(fragment[pos:match.start()])
        tag = match.group(0)
        if tag.startswith("</"):
            depth -= 1
        elif not tag.endswith("/>"):
            depth += 1
        pos = match.end()
        if depth == 0 and texts > limit:
            cut = pos
            break
    if cut >= len(fragment):
        return fragment
    return fragment[:cut] + "…"


def clean_def(fragment: str) -> str:
    """工具提示里不需要 MathML 副本（读屏用不上提示，视觉部分已足够）。"""
    return trim_html(MATHML_SPAN.sub("", fragment))


def book_relative(fragment: str, base_dir: str) -> str:
    """把单元格里的站内链接改成「相对本书根目录」的路径，前端再按 path_to_root 还原。

    站外链接与纯锚点原样保留。
    """
    def fix(match):
        href = match.group(1)
        if href.startswith(("http://", "https://", "#")):
            return match.group(0)
        return 'href="%s"' % posixpath.normpath(posixpath.join(base_dir, href))

    return re.sub(r'href="([^"]+)"', fix, fragment)


def build(book_dir: str) -> int:
    slug = os.path.basename(os.path.abspath(book_dir))
    cfg = SOURCES.get(slug)
    if cfg is None:
        print("[glossary] 跳过 %s：未配置术语源" % slug, file=sys.stderr)
        return 0

    page_path = os.path.join(book_dir, "book", cfg["page"])
    if not os.path.exists(page_path):
        print("[glossary] 跳过：找不到 %s（请先 mdbook build）" % page_path, file=sys.stderr)
        return 1

    with open(page_path, encoding="utf-8") as handle:
        page = handle.read()

    base_dir = posixpath.dirname(cfg["page"])
    # 标题与表格按文档顺序合并，便于给每条术语记住它所在的章节锚点
    events = [(m.start(), "h", m.group(2)) for m in HEADING.finditer(page)]
    events += [(m.start(), "t", m.group(0)) for m in TABLE.finditer(page)]
    events.sort()

    section = ""
    entries, seen, rows_total, skipped = [], set(), 0, 0
    for _, kind, payload in events:
        if kind == "h":
            section = payload
            continue
        rows = ROW.findall(payload)
        if not rows:
            continue
        header = [c for c in CELL.findall(rows[0])] if "<th" in rows[0] or "<td" in rows[0] else []
        if not header:
            continue
        index = locate(header, cfg["columns"])
        if index.get("term", -1) < 0 or index.get("def", -1) < 0:
            continue
        for row in rows[1:]:
            cols = [c.strip() for c in CELL.findall(row)]
            if len(cols) <= max(index["term"], index["def"]):
                continue
            rows_total += 1
            names = aliases(cols[index["term"]])
            if not names:
                skipped += 1
                continue
            target = cfg["page"] + ("#" + section if section else "")
            if index.get("origin", -1) >= 0 and index["origin"] < len(cols):
                m = re.search(r'href="([^"]+)"', cols[index["origin"]])
                if m and not m.group(1).startswith(("http://", "https://")):
                    target = posixpath.normpath(posixpath.join(base_dir, m.group(1)))
            key = names[0]
            if key in seen:
                skipped += 1
                continue
            seen.add(key)
            entries.append({
                "terms": names,
                "title": strip_tags(cols[index["term"]]),
                "en": strip_tags(cols[index["en"]]) if index.get("en", -1) >= 0 and index["en"] < len(cols) else "",
                "def": clean_def(book_relative(cols[index["def"]], base_dir)),
                "extra": book_relative(cols[index["extra"]], base_dir) if index.get("extra", -1) >= 0 and index["extra"] < len(cols) else "",
                "href": target,
            })

    out_path = os.path.join(book_dir, "book", "glossary.json")
    with open(out_path, "w", encoding="utf-8") as handle:
        json.dump({"page": cfg["page"], "terms": entries}, handle, ensure_ascii=False, separators=(",", ":"))
    marked = mark_pages(book_dir)
    print("[glossary] %s：%d 行 → %d 条术语（跳过 %d），%.1f KB；标记页面 %d 个" % (
        slug, rows_total, len(entries), skipped, os.path.getsize(out_path) / 1024, marked))
    return 0


def mark_pages(book_dir: str) -> int:
    """给构建产物的 <html> 打一枚 data-glossary 标记。

    前端只有看到这枚标记才去取 glossary.json——否则在没有跑本脚本的构建里
    （比如直接 mdbook build 后的本地预览）每一页都会有一个 404。"""
    pages_dir = os.path.join(book_dir, "book")
    marked = 0
    for root, _dirs, files in os.walk(pages_dir):
        for name in files:
            if not name.endswith(".html"):
                continue
            path = os.path.join(root, name)
            with open(path, encoding="utf-8") as handle:
                text = handle.read()
            if 'data-glossary="1"' in text or "<html " not in text:
                continue
            with open(path, "w", encoding="utf-8") as handle:
                handle.write(text.replace("<html ", '<html data-glossary="1" ', 1))
            marked += 1
    return marked


def main(argv) -> int:
    if len(argv) < 2:
        print(__doc__)
        return 2
    return build(argv[1])


if __name__ == "__main__":
    sys.exit(main(sys.argv))
