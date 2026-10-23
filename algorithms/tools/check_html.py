#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""构建后检查：重复 HTML id、站内断链、断锚点。

用法：python3 tools/check_html.py [book_dir]
默认 book_dir = book/。

跳过 http(s)/mailto/javascript/data 与跨书根路径(/tutorials/)。
"""

from __future__ import annotations

import os
import re
import sys
from collections import defaultdict
from html import unescape
from urllib.parse import unquote, urlsplit

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
ID = re.compile(r'\bid="([^"]+)"')
HREF = re.compile(r'\bhref="([^"]+)"')
TAG = re.compile(r"<script\b.*?</script>|<style\b.*?</style>|<pre\b.*?</pre>|<code\b.*?</code>", re.S | re.I)


def html_files(book: str):
    for base, dirs, files in os.walk(book):
        dirs[:] = [d for d in dirs if d not in {"fonts", "css", "js", "images"}]
        for f in files:
            if f.endswith(".html"):
                yield os.path.join(base, f)


def main() -> int:
    book = os.path.abspath(sys.argv[1]) if len(sys.argv) > 1 else os.path.join(ROOT, "book")
    if not os.path.isdir(book):
        print(f"没有构建产物：{book}", file=sys.stderr)
        return 2
    pages = {}
    ids = {}
    dup = []
    for path in html_files(book):
        rel = os.path.relpath(path, book).replace(os.sep, "/")
        text = open(path, encoding="utf-8", errors="replace").read()
        text = TAG.sub("", text)
        found = ID.findall(text)
        pages[rel] = text
        ids[rel] = set(found)
        counts = defaultdict(int)
        for i in found:
            counts[i] += 1
        for i, n in counts.items():
            if n > 1:
                dup.append((rel, i, n))
    broken, broken_anchor = [], []
    for rel, text in pages.items():
        if rel == "404.html":
            continue
        base = os.path.dirname(os.path.join(book, rel))
        for raw in HREF.findall(text):
            url = unescape(raw)
            if not url or url.startswith(("http://", "https://", "mailto:", "javascript:", "data:")):
                continue
            if url.startswith("/tutorials/"):
                continue
            parts = urlsplit(url)
            if parts.scheme or parts.netloc:
                continue
            target = parts.path
            anchor = unquote(parts.fragment) if parts.fragment else ""
            if not target:
                if anchor and anchor not in ids[rel]:
                    broken_anchor.append((rel, "#" + anchor))
                continue
            target_path = os.path.normpath(os.path.join(base, unquote(target)))
            if not os.path.exists(target_path):
                broken.append((rel, url))
                continue
            if anchor:
                trel = os.path.relpath(target_path, book).replace(os.sep, "/")
                if trel in ids and anchor not in ids[trel]:
                    broken_anchor.append((rel, url))
    print(f"html pages: {len(pages)}")
    if dup:
        print(f"\n重复 HTML id ({len(dup)}):")
        for rel, i, n in dup[:40]:
            print(f"  {rel}: {i} x {n}")
    if broken:
        print(f"\n断链 ({len(broken)}):")
        for rel, url in broken[:40]:
            print(f"  {rel} -> {url}")
    if broken_anchor:
        print(f"\n断锚点 ({len(broken_anchor)}):")
        for rel, url in broken_anchor[:40]:
            print(f"  {rel} -> {url}")
    ok = not (dup or broken or broken_anchor)
    print("\nOK" if ok else "\nFAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
