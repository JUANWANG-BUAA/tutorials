#!/usr/bin/env python3
"""Verify modernization arithmetic for ch8 sections 1.4.7 / 1.4.8 / 1.4.10 from Markdown."""
from fractions import Fraction
from pathlib import Path
import argparse
import re


def require(ok: bool, msg: str) -> None:
    if not ok:
        raise ValueError(msg)


def section_after(chapter: str, heading: str) -> str:
    require(chapter.count(heading) == 1, f'missing or duplicated: {heading}')
    rest = chapter.split(heading, 1)[1]
    return re.split(r'^## ', rest, maxsplit=1, flags=re.MULTILINE)[0]


def verify_148(section: str) -> None:
    require('| 企业内部（A） | 600 | 1200 | 2.0 |' in section, 'A row missing')
    require('| 完整生产过程（B） | 1000 | 1200 | 1.2 |' in section, 'B row missing')
    require('| 外包环节 | 400 | 0' in section, 'outsource row missing')
    q, ha = Fraction(1200), Fraction(600)
    hb = Fraction(600 + 400)
    require(q / ha == Fraction(2), 'A q identity')
    require(q / hb == Fraction(6, 5), 'B q identity')
    require('q_A' in section and 'q_B' in section, 'demo formulas missing')
    require('data-mlm-outsource-demo' in section, 'outsource demo mount missing')
    require('无脚本时直接用上表' in section, 'no-JS fallback missing')


def verify_147(section: str) -> None:
    require('| A | 150 | 250 |' in section, 'contract A missing')
    require('| B | 300 | 100 |' in section, 'contract B missing')
    require(Fraction(400) - Fraction(150) == Fraction(250), 'A balance')
    require(Fraction(400) - Fraction(300) == Fraction(100), 'B balance')
    require('data-mlm-invest-demo' in section, 'invest demo mount missing')
    require('无脚本时用上表' in section, 'invest no-JS fallback missing')
    require('可挪作设备' in section, 'usable-funds formula prose missing')


def verify_1410(section: str) -> None:
    compact = re.sub(r'\s+', '', section).replace('\\', '')
    require('B=Y-C-L-M' in compact, 'budget formula missing')
    require('data-mlm-budget-demo' in section, 'budget demo mount missing')
    require('无脚本时任取一例' in section, 'budget no-JS fallback missing')
    y, c, l, m = 1000, 200, 400, 100
    require(y - c - l - m == 300, 'sample balance identity')


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', nargs='?', type=Path,
                        default=Path(__file__).resolve().parents[1] / 'src/part1/8.md')
    args = parser.parse_args()
    chapter = args.path.read_text()
    verify_147(section_after(chapter, '## 1.4.7 '))
    verify_148(section_after(chapter, '## 1.4.8 '))
    verify_1410(section_after(chapter, '## 1.4.10 '))
    # also keep 1.4.2 gate
    from verify_ch8_examples import verify as verify_142
    verify_142(chapter)
    print(f'PASS: {args.path} modernization checks for 1.4.2/1.4.7/1.4.8/1.4.10')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, IndexError, ZeroDivisionError) as error:
        raise SystemExit(f'FAIL: {error}') from error
