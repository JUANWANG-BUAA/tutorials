#!/usr/bin/env python3
"""Recalculate archived timing statistics and validate every batch checksum."""
from pathlib import Path
import hashlib
import json
import math
import statistics
import sys

archive = Path(sys.argv[1]).resolve()
mask = (1 << 64) - 1
values = [(i * 6364136223846793005 + 1) & mask for i in range(16384)]
sum_expected = sum(values) & mask
transformed = [((v * 17 + 29) & mask) for v in values]
dispatch_expected = sum(((v << 7) | (v >> 57)) & mask for v in transformed) & mask
expected = {
    'move_cost': {'borrow': sum_expected, 'clone': sum_expected},
    'drop_paths': {'implicit': 8192, 'option': 8192},
    'dispatch_grain': {'generic': dispatch_expected, 'dyn_item': dispatch_expected, 'dyn_batch': dispatch_expected},
    'dispatch_visibility': {'known_dyn': dispatch_expected, 'opaque_dyn': dispatch_expected},
    'vectorize': {'zip': sum_expected, 'calls': sum_expected},
    'ctfe_table': {'static_table': 1024, 'rebuild_table': 1024},
}
report = {'archive': str(archive), 'cases': [], 'raw_observations': 0, 'checksum_validation': True}
for entry, checks in expected.items():
    groups = {case: [] for case in checks}
    rounds = {case: [] for case in checks}
    summaries = {}
    for line in (archive / (entry + '.csv')).read_text().splitlines()[1:]:
        row = line.split(',')
        if row[0] == 'summary':
            summaries[row[1]] = list(map(float, row[2:]))
            continue
        case, round_number, repeats, units, elapsed, value, checksum = row
        repeats, units, elapsed = int(repeats), int(units), int(elapsed)
        assert int(checksum) == (checks[case] * repeats) & mask, (entry, case, 'checksum')
        calculated = elapsed / (repeats * units)
        assert abs(calculated - float(value)) < 1e-8
        groups[case].append(calculated)
        rounds[case].append(int(round_number))
    for case, observations in groups.items():
        assert sorted(rounds[case]) == list(range(21)), (entry, case, 'rounds')
        ordered = sorted(observations)
        numbers = [statistics.mean(observations), statistics.stdev(observations),
                   ordered[math.ceil(.5 * len(ordered)) - 1], ordered[math.ceil(.99 * len(ordered)) - 1]]
        assert all(abs(a - b) < 1e-8 for a, b in zip(numbers, summaries[case]))
        report['cases'].append(dict(entry=entry, case=case, n=21, unit='ns/input-unit',
                                    mean=numbers[0], sd_n_minus_1=numbers[1], p50=numbers[2], p99=numbers[3]))
        report['raw_observations'] += len(observations)
for file in ['source-sha256.txt', 'artifact-sha256.txt']:
    for row in (archive / file).read_text().splitlines():
        digest, path = row.split(None, 1)
        assert hashlib.sha256(Path(path.strip()).read_bytes()).hexdigest() == digest, path
assert report['raw_observations'] == 273
assert 'dynamic_items' in (archive / 'macos-sample.txt').read_text()
print(json.dumps(report, indent=2, ensure_ascii=False))
