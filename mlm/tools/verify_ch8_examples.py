#!/usr/bin/env python3
"""Verify section 1.4.2 arithmetic from its actual Markdown, including answers."""
from fractions import Fraction
from pathlib import Path
import argparse
import re


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def fields(line: str) -> list[str]:
    return [part.strip() for part in line.strip().strip('|').split('|')]


def numbers(pattern: str, text: str, label: str) -> tuple[Fraction, ...]:
    match = re.search(pattern, text)
    require(match is not None, f'{label}: expected displayed statement missing')
    return tuple(Fraction(value) for value in match.groups())


def verify(chapter: str) -> dict[str, tuple[Fraction, ...]]:
    require(chapter.count('## 1.4.2 ') == 1, 'section heading missing or duplicated')
    section = re.split(r'^## ', chapter.split('## 1.4.2 ', 1)[1],
                       maxsplit=1, flags=re.MULTILINE)[0]
    rows = {}
    ratios = {}
    extra = None
    for line in section.splitlines():
        if not line.startswith('| '):
            continue
        values = fields(line)
        if values[0] in ('甲', '乙', '丙'):
            require(len(values) == 7, 'main table column count changed')
            require(values[0] not in rows, 'duplicate arrangement')
            rows[values[0]] = tuple(Fraction(value) for value in values[1:])
        elif values[0] == '丁':
            require(len(values) == 4 and extra is None, 'extra input malformed')
            extra = tuple(Fraction(value) for value in values[1:])
        elif values[0] in ('甲→乙', '甲→丙'):
            require(len(values) == 7, 'ratio table column count changed')
            require(values[0] not in ratios, 'duplicate ratio row')
            ratios[values[0]] = tuple(Fraction(value.rstrip('%')) /
                                     (100 if value.endswith('%') else 1)
                                     for value in values[1:])
    require(set(rows) == {'甲', '乙', '丙'}, 'main table arrangements missing')
    require(set(ratios) == {'甲→乙', '甲→丙'}, 'ratio comparisons missing')
    require(extra is not None, 'extra exercise input missing')
    for name, row in rows.items():
        n, h, total, output, rate, per_piece = row
        require(n.denominator == 1 and n > 0 and h > 0 and output > 0,
                f'{name}: positive count, hours and output required')
        require(total == n * h, f'{name}: displayed person-hours differ from inputs')
        require(rate == output / total, f'{name}: displayed rate differs from inputs')
        require(per_piece == total / output, f'{name}: displayed inverse rate differs')
    base = rows['甲']
    for name in ('乙', '丙'):
        row = rows[name]
        expected = (row[3] / base[3], row[2] / base[2], row[4] / base[4])
        require(ratios['甲→' + name] == expected + tuple(x - 1 for x in expected),
                f'{name}: displayed ratios or increments differ from actual table')
        require(expected[0] == expected[1] * expected[2], 'ratio identity failed')
    answer = section.split('::: sol 解答1.4.2 ', 1)[1]
    num = r'([0-9]+(?:\.[0-9]+)?(?:/[0-9]+)?)'
    for name, row in rows.items():
        found = numbers(name + '的总人时为' + num + '人时，生产率为' + num +
                        '件/人时，每件投入' + num + '人时', answer, name + ' answer')
        require(found == (row[2], row[4], row[5]), f'{name}: answer differs from inputs')
    n, h, output = extra
    require(n > 0 and n.denominator == 1 and h > 0 and output > 0, 'invalid extra input')
    total, rate = n * h, output / (n * h)
    found = numbers('丁的总人时为' + num + '人时，生产率为' + num + '件/人时',
                    answer, 'extra answer')
    require(found == (total, rate), 'extra answer differs from actual exercise inputs')
    require(rate == rows['乙'][4], 'exercise claim: extra and beta rates must match')
    found = numbers('合格产出却为' + num + '件而非乙的' + num + '件', answer,
                    'extra/beta output statement')
    require(found == (output, rows['乙'][3]), 'extra/beta displayed outputs differ')
    found = numbers('产出增加' + num + '%，总投入增加' + num + '%，生产率增加' +
                    num + '%', answer, 'ratio answer')
    require(tuple(x / 100 for x in found) == ratios['甲→丙'][3:],
            'answer percentage increments differ')
    found = numbers('相应比率为' + num + '、' + num + '与' + num, answer, 'ratio answer')
    require(found == ratios['甲→丙'][:3], 'answer ratios differ')
    lhs, first, second = numbers(num + '=' + num + '×' + num, section, 'product equation')
    require((lhs, first, second) == ratios['甲→丙'][:3], 'displayed product inputs differ')
    require(lhs == first * second, 'displayed product equation false')
    first_answer, second_answer, lhs_answer = numbers(
        '满足' + num + '×' + num + '=' + num, answer, 'answer product equation')
    require((lhs_answer, first_answer, second_answer) == (lhs, first, second),
            'answer product equation differs')
    cross = (first - 1) * (second - 1)
    displayed = numbers('乘积展开还含' + num + '这一交叉项', answer, 'cross term')[0]
    require(displayed == cross, 'displayed cross term differs')
    # Scope statements are explicit assumptions, not empirical facts certified by this script.
    for token in ('人时', '件/人时', '人时/件', '等待', '返工', '维护', '外包', '同一质量要求'):
        require(token in section, f'unit/scope statement missing: {token}')
    return {**rows, '丁': (n, h, total, output, rate)}


def mutation_checks(chapter: str) -> int:
    changes = [
        ('| 甲 | 100 | 8 | 800 | 800 | 1.0 | 1 |',
         '| 甲 | 101 | 8 | 800 | 800 | 1.0 | 1 |'),
        ('| 乙 | 100 | 8 | 800 | 1200 | 1.5 | 2/3 |',
         '| 乙 | 100 | 8 | 800 | 1200 | 1.6 | 2/3 |'),
        ('| 甲→丙 | 1.5 | 1.25 | 1.2 | 50% | 25% | 20% |',
         '| 甲→丙 | 1.5 | 1.25 | 1.2 | 51% | 25% | 20% |'),
        ('| 丁 | 80 | 6 | 720 |', '| 丁 | 81 | 6 | 720 |'),
        ('丁的总人时为480人时', '丁的总人时为481人时'),
        ('乙的总人时为800人时', '乙的总人时为801人时'),
        ('产出增加50%，总投入增加25%，生产率增加20%',
         '产出增加50%，总投入增加25%，生产率增加21%'),
        ('乘积展开还含0.05这一交叉项', '乘积展开还含0.06这一交叉项'),
    ]
    for before, after in changes:
        require(chapter.count(before) == 1, f'mutation target changed: {before}')
        try:
            verify(chapter.replace(before, after, 1))
        except ValueError:
            continue
        raise ValueError(f'mutated display was incorrectly accepted: {after}')
    return len(changes)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('path', nargs='?', type=Path,
                        default=Path(__file__).resolve().parents[1] / 'src/part1/8.md')
    parser.add_argument('--self-test', action='store_true', help='also reject altered Markdown copies')
    args = parser.parse_args()
    try:
        chapter = args.path.read_text()
        rows = verify(chapter)
        for name, values in rows.items():
            print(f'{name}: H={values[2]} person-hours; Q={values[3]}; q={values[4]}')
        if args.self_test:
            print(f'PASS: rejected {mutation_checks(chapter)} altered Markdown copies')
        print(f'PASS: {args.path} section 1.4.2 input, display, ratios and answers')
    except (ValueError, IndexError, ZeroDivisionError) as error:
        raise SystemExit(f'FAIL: {error}') from error


if __name__ == '__main__':
    main()
