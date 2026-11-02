#!/usr/bin/env python3
"""检查正文有没有照抄来源：中文长片段重合检测。

教材引用 rCore 这类公开材料时，借的是**机制事实**，不是它的句子。这条脚本把
「借事实、不抄句子」变成可检验的规则：在书稿散文与本地归档之间找共同的中文
长片段（默认 12 字），超过阈值的按段落报出来，附上来源文件与原文片段。

用法：
    python3 tools/check_paraphrase.py                    # 全部来源，报 >= 12 字的片段
    python3 tools/check_paraphrase.py --min 16           # 只报更长的重合
    python3 tools/check_paraphrase.py --sources 'systems/*' --files 'src/part4/ch17.md'
"""

from __future__ import annotations

import argparse
import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
ARCHIVE = ROOT / ".work/cpp-rust-sources"

FENCE = re.compile(r"^```")
TABLE = re.compile(r"^\s*\|")
CJK = re.compile(r"[一-鿿]")
INLINE_CODE = re.compile(r"`[^`]*`")
LINK = re.compile(r"\[[^\]]*\]\([^)]*\)")
TAG = re.compile(r"<[^>]+>")


def prose_of_markdown(text: str) -> list[tuple[int, str]]:
    """返回 (行号, 该行散文)；跳过代码块、表格行、标题、盒标题与纯链接行。"""
    out: list[tuple[int, str]] = []
    in_fence = False
    for index, line in enumerate(text.splitlines(), 1):
        if FENCE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        stripped = line.strip()
        if not stripped or TABLE.match(line) or stripped.startswith("#"):
            continue
        if stripped.startswith(":::"):
            continue
        if LINK.sub("", stripped).strip() in {"", "-"}:
            continue
        out.append((index, stripped))
    return out


def cjk_only(text: str) -> str:
    return "".join(ch for ch in text if CJK.match(ch))


ARTICLE = re.compile(r"(?s)<article[^>]*>(.*?)</article>")
HEADING = re.compile(r"(?s)<h[1-4][^>]*>(.*?)</h[1-4]>")


def source_headings(path: Path) -> str:
    """来源自己的标题文本。引用来源的标题属于正名，不算抄句子。"""
    raw = path.read_text(encoding="utf-8", errors="replace")
    parts = []
    for match in HEADING.finditer(raw):
        parts.append(cjk_only(html.unescape(TAG.sub(" ", match.group(1)))))
    return "".join(parts)


def source_text(path: Path) -> str:
    """只取正文（article 元素），丢掉侧边导航与章节标题表。

    目录条目是来源自己的**标题**，正文引用它们属于正名，不是抄句子；
    拿整页 HTML 去比会把这些正常引用全部误报成重合。
    """
    raw = path.read_text(encoding="utf-8", errors="replace")
    match = ARTICLE.search(raw)
    if match:
        raw = match.group(1)
    raw = re.sub(r"(?s)<(script|style).*?</\1>", " ", raw)
    raw = re.sub(r"(?s)<pre.*?</pre>", " ", raw)
    raw = TAG.sub(" ", raw)
    raw = html.unescape(raw)
    return cjk_only(raw)


def book_text(path: Path) -> tuple[str, list[tuple[int, str]], list[int]]:
    """返回 (散文拼接后的中文字串, 每一行的散文, 每行在拼接串里的起始偏移)。"""
    lines = prose_of_markdown(path.read_text(encoding="utf-8"))
    parts: list[str] = []
    offsets: list[int] = []
    cursor = 0
    for _, line in lines:
        offsets.append(cursor)
        chunk = cjk_only(line)
        parts.append(chunk)
        cursor += len(chunk)
    return "".join(parts), lines, offsets


def line_of(offset: int, offsets: list[int]) -> int:
    """把拼接串里的字符偏移换回行号（取最后一个小于等于它的偏移）。"""
    number = 0
    for index, start in enumerate(offsets):
        if start <= offset:
            number = index
        else:
            break
    return number


def find_matches(book: str, source: str, minimum: int) -> list[tuple[int, int, int]]:
    """返回最长不重叠的共同片段（长度, 书稿起点, 来源起点）。"""
    grams = len(book) - minimum + 1
    index: dict[str, list[int]] = {}
    for pos in range(max(0, len(source) - minimum + 1)):
        index.setdefault(source[pos : pos + minimum], []).append(pos)
    taken = [False] * len(book)
    hits: list[tuple[int, int]] = []
    for i in range(max(0, grams)):
        if taken[i]:
            continue
        candidates = index.get(book[i : i + minimum])
        if not candidates:
            continue
        best = 0
        best_source = candidates[0]
        for sp in candidates:
            length = minimum
            while (
                i + length < len(book)
                and sp + length < len(source)
                and book[i + length] == source[sp + length]
            ):
                length += 1
            if length > best:
                best = length
                best_source = sp
        if best >= minimum:
            hits.append((best, i, best_source))
            for k in range(i, min(i + best, len(book))):
                taken[k] = True
    return hits


def main() -> int:
    ap = argparse.ArgumentParser(description="Chinese long-overlap check against local archives")
    ap.add_argument("--min", type=int, default=12, help="报出的最短重合字数")
    ap.add_argument("--sources", default="*/*", help="来源通配（相对 .work/cpp-rust-sources），如 systems/*")
    ap.add_argument("--files", default="**/*.md", help="书稿通配（相对 src/）")
    ap.add_argument("--show", type=int, default=60, help="每段最多显示多少字")
    ap.add_argument("--strict", action="store_true", help="有散文重合即以非零码退出")
    args = ap.parse_args()

    source_files = sorted(p for p in ARCHIVE.glob(args.sources) if p.is_file())
    book_files = sorted(SRC.glob(args.files))
    if not source_files:
        print("没有找到本地归档，先跑抓取脚本", file=__import__("sys").stderr)
        return 2

    corpus = [(path, source_text(path), source_headings(path)) for path in source_files]
    # 标题正名是全书通用的：某页的标题出现在别页的正文里，也算引用而不是抄句子。
    all_headings = "".join(headings for _, _, headings in corpus)
    total = 0
    titled = 0
    print(f"书稿 {len(book_files)} 页 · 来源 {len(corpus)} 份 · 最短重合 {args.min} 字")
    for book_file in book_files:
        text, lines, offsets = book_text(book_file)
        if len(text) < args.min:
            continue
        for source_path, source, headings in corpus:
            for length, start, source_start in find_matches(text, source, args.min):
                matched = text[start : start + length]
                if matched in headings or matched in all_headings:
                    titled += 1
                    continue
                total += 1
                line_no = line_of(start, offsets)
                print(
                    f"{book_file.relative_to(ROOT)}:{line_no}  与 {source_path.relative_to(ROOT)} "
                    f"重合 {length} 字\n    书稿：{text[start : start + args.show]}\n    来源：{source[source_start : source_start + args.show]}"
                )
    print(f"\n散文重合 {total} 处（>= {args.min} 字）；另有 {titled} 处来自来源标题的正名引用，未计入")
    if args.strict and total:
        print("paraphrase gate rejected: 正文与来源存在逐字重合")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
