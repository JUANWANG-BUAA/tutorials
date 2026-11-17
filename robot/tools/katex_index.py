#!/usr/bin/env python3
"""Keep TeX annotations available without indexing them twice in mdBook."""

import html
import json
import re
import subprocess
import sys
from urllib.parse import quote

ANNOTATION = re.compile(r'(<annotation\b[^>]*>)(.*?)(</annotation>)', re.S)


def externalize(text: str) -> str:
    """Store each TeX annotation as a standards-based data URI in its src."""
    def replace(match: re.Match[str]) -> str:
        start, body, end = match.groups()
        if 'encoding="application/x-tex"' not in start:
            return match.group(0)
        # KaTeX escapes its annotation as HTML; the shared wrapper escapes it
        # a second time to protect it from Markdown parsing.
        tex = html.unescape(html.unescape(body))
        uri = "data:application/x-tex," + quote(tex, safe="")
        return start[:-1] + f' src="{uri}">' + end

    return ANNOTATION.sub(replace, text)


def transform(value: object) -> None:
    if isinstance(value, list):
        for item in value:
            transform(item)
    elif isinstance(value, dict):
        for key, item in value.items():
            if key == "content" and isinstance(item, str):
                value[key] = externalize(item)
            else:
                transform(item)


def main() -> int:
    command = [sys.executable, "../tools/katex_wrapper.py", *sys.argv[1:]]
    result = subprocess.run(command, input=sys.stdin.buffer.read(), stdout=subprocess.PIPE)
    if result.returncode:
        return result.returncode
    if len(sys.argv) > 1 and sys.argv[1] == "supports":
        return 0
    book = json.loads(result.stdout)
    transform(book)
    json.dump(book, sys.stdout, ensure_ascii=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
