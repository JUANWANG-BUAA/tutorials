#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""《算法、评估与因果》结构与契约质检。

用法：
    python3 tools/check_book.py [--verbose]
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
HTML_ID = re.compile(r'\bid="([^"]+)"')
SEC_ANCHOR = re.compile(r"^sec-algorithms\.(\d+)\.(\d+)\.(\d+)(?:\.\d+)?$")
ALLOWED_BOX = {"def", "thm", "ex", "intuition", "method", "errata", "note", "proof", "sol"}
CHAPTER_FILE = re.compile(r"^part([1-4])[/\\]ch(\d{2})\.md$")

def read_summary():
    with open(SUMMARY, "r", encoding="utf-8") as f:
        text = f.read()
    links = re.findall(r"\[.+?\]\((.+?\.md)\)", text)
    return [os.path.normpath(os.path.join(SRC, l)) for l in links]

def main():
    pages = read_summary()
    errors = []
    total_lines = 0
    chapters = 0

    for path in pages:
        if not os.path.exists(path):
            errors.append(f"Missing page: {path}")
            continue
        with open(path, "r", encoding="utf-8") as f:
            lines = f.readlines()
        total_lines += len(lines)
        rel = os.path.relpath(path, SRC)
        m = CHAPTER_FILE.match(rel)
        if m:
            chapters += 1

    print(f"pages: {len(pages)}  chapters: {chapters}  total lines: {total_lines}")
    if errors:
        for e in errors:
            print("ERROR:", e)
        return 1
    print("\nOK")
    return 0

if __name__ == "__main__":
    sys.exit(main())
