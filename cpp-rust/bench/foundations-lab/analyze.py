#!/usr/bin/env python3
"""Batch summaries and paired bootstrap, stdlib only, fixed resampling seed."""
import csv
import json
import math
import random
import statistics
import sys
from pathlib import Path


def quantile(values, p):
    return sorted(values)[max(0, math.ceil(len(values) * p) - 1)]


def summarize(values):
    return dict(n=len(values), mean=statistics.mean(values), sd=statistics.stdev(values),
                p50=quantile(values, .50), p99=quantile(values, .99))


def paired_interval(a, b):
    # Preserve each round's pairing. Does not remove serial dependence or host bias.
    differences = [y - x for x, y in zip(a, b, strict=True)]
    rng = random.Random(13013)
    draws = [statistics.mean(rng.choices(differences, k=len(differences))) for _ in range(10000)]
    return dict(mean=statistics.mean(differences), sd=statistics.stdev(differences),
                bootstrap95=[quantile(draws, .025), quantile(draws, .975)],
                seed=13013, resamples=10000)


def analyze(path):
    groups = {}
    for row in csv.DictReader(path.open()):
        if row['kind'] != 'raw':
            continue
        groups.setdefault(row['case'], []).append(row)
    values = {}
    for name, rows in groups.items():
        rows.sort(key=lambda row: int(row['round']))
        assert [int(row['round']) for row in rows] == list(range(21))
        assert len({row['checksum'] for row in rows}) == 1
        values[name] = [float(row['ns_per_unit']) for row in rows]
    names = list(values)
    result = {'cases': {name: summarize(v) for name, v in values.items()}}
    if len(names) == 2:
        result['paired_second_minus_first'] = paired_interval(values[names[0]], values[names[1]])
        result['order'] = names
        result['first7_last7'] = {name: [statistics.mean(v[:7]), statistics.mean(v[-7:])]
                                 for name, v in values.items()}
    return result


if __name__ == '__main__':
    root = Path(sys.argv[1])
    result = {p.stem: analyze(p) for p in sorted(root.glob('*.csv'))}
    assert len(result) == 6
    dest = root / 'statistics.json'
    with dest.open('x') as output:
        json.dump(result, output, indent=2)
    print(json.dumps(result, indent=2))
