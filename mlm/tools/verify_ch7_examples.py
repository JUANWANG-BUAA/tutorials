#!/usr/bin/env python3
"""Read fictional examples from the published Markdown and check displayed results."""
from fractions import Fraction
from pathlib import Path
import re
import sys


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def cells(line: str) -> list[str]:
    return [item.strip() for item in line.strip().strip('|').split('|')]


def verify(path: Path) -> None:
    chapter = path.read_text()
    section = chapter.split('## 1.3.5 ', 1)[1].split('## 1.3.6 ', 1)[0]
    lines = section.splitlines()
    survey = {}
    for line in lines:
        if re.match(r'^\| (甲|乙|合计) \|', line):
            fields = cells(line)
            require(len(fields) == 5, 'survey columns changed')
            survey[fields[0]] = tuple(int(v) for v in fields[1:])
    require(set(survey) == {'甲', '乙', '合计'}, 'survey rows missing')
    for name in ('甲', '乙'):
        n1, y1, n2, y2 = survey[name]
        require(n1 > 0 and n2 > 0, f'{name}: rates require positive denominator')
        require(0 <= y1 <= n1 and 0 <= y2 <= n2, f'{name}: invalid count')
    totals = tuple(sum(survey[k][i] for k in ('甲', '乙')) for i in range(4))
    require(totals == survey['合计'], 'displayed totals do not match input rows')
    first = Fraction(totals[1], totals[0])
    second = Fraction(totals[3], totals[2])
    group_rates = {k: (Fraction(v[1], v[0]), Fraction(v[3], v[2]))
                   for k, v in survey.items() if k != '合计'}
    weights = {k: Fraction(survey[k][0], totals[0]) for k in group_rates}
    standard = sum(weights[k] * group_rates[k][1] for k in group_rates)
    expected = {
        '实际总体支持率': (first, second),
        '甲岗位支持率': group_rates['甲'],
        '乙岗位支持率': group_rates['乙'],
        '固定第一期岗位权重': (first, standard),
    }
    found = {}
    for line in lines:
        if line.startswith('| ') and cells(line)[0] in expected:
            fields = cells(line)
            found[fields[0]] = tuple(Fraction(v.removesuffix('%')) / 100
                                     for v in fields[1:3])
    require(found == expected, 'displayed rate table differs from computed inputs')
    tracking = {}
    for line in lines:
        if re.match(r'^\| [AB] \|', line):
            fields = cells(line)
            values = tuple(int(v) for v in fields[1:])
            require(len(values) == 7, 'tracking columns changed')
            up, down, yes, no, start, end, changed = values
            require(min(values) >= 0, 'negative tracking count')
            require(up + down + yes + no == totals[0], 'tracking total differs')
            require((down + yes, up + yes, up + down) == (start, end, changed),
                    f'{fields[0]}: displayed tracking results differ')
            require((start, end) == (totals[1], totals[3]), 'tracking endpoints differ')
            tracking[fields[0]] = values
    require(set(tracking) == {'A', 'B'}, 'tracking examples missing')

    def pct(rate: Fraction) -> str:
        value = rate * 100
        require(value.denominator == 1, 'nonintegral display needs explicit formatting')
        return str(value.numerator) + '%'

    # Check the independently written prose/answer results, not just another computed array.
    answer = section.split('::: sol 解答3.5a', 1)[1]
    require(f'总体为{pct(first)}与{pct(second)}' in answer, 'answer total rates differ')
    require(f'甲两期{pct(group_rates["甲"][0])}' in answer, 'answer alpha rate differs')
    require(f'乙两期{pct(group_rates["乙"][0])}' in answer, 'answer beta rate differs')
    delta = (second - first) * 100
    require(delta.denominator == 1, 'nonintegral percentage-point display')
    require(f'总体增加{delta.numerator}个百分点' in answer, 'answer delta differs')
    require(f'标准化为{pct(standard)}' in answer, 'answer standardization differs')
    for name, values in tracking.items():
        require(f'{name}有{values[6]}人改变' in answer, f'answer tracking {name} differs')
    weight_note = next(line for line in lines if line.startswith('| 固定第一期岗位权重 |'))
    require(f'甲{pct(weights["甲"])}、乙{pct(weights["乙"])}' in weight_note,
            'displayed fixed weights differ')
    print(f'PASS {path}: survey {pct(first)} -> {pct(second)}, '
          f'+{delta.numerator} pp; fixed weights {pct(standard)}; '
          f'tracking changes A={tracking["A"][6]}, B={tracking["B"][6]}')


if __name__ == '__main__':
    target = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parents[1] / 'src/part1/7.md'
    try:
        verify(target)
    except (ValueError, KeyError, IndexError) as error:
        raise SystemExit(f'FAIL {target}: {error}') from error
