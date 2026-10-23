#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""单章自检：写章过程中用。

用法：
    python3 tools/check_chapter.py part1/ch02.md
    python3 tools/check_chapter.py part1/ch02.md --strict-links
"""

from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import check_book as cb  # noqa: E402


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    strict = "--strict-links" in sys.argv
    if not args:
        print(__doc__)
        return 2
    rel = args[0].lstrip("./")
    r = cb.check_page(rel, rel)
    problems = list(r["problems"])
    base = os.path.dirname(os.path.join(cb.SRC, rel))
    for link, anchor in r["links"]:
        target = os.path.normpath(os.path.join(base, link))
        if not os.path.exists(target):
            if strict:
                problems.append(f"断链：{link}")
            continue
        if anchor:
            trel = os.path.relpath(target, cb.SRC)
            tr = cb.check_page(trel, trel)
            if anchor not in set(tr["anchors"]):
                problems.append(f"断锚点：{link}#{anchor}")
    print(f"{rel}: {r['lines']} 行, H2={r['h2']}, boxes={dict(r['boxes'])}")
    if problems:
        print("问题:")
        for p in problems:
            print("  -", p)
        return 1
    print("OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
