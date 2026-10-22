#!/usr/bin/env python3
"""Check archived observations/statistics and the exact measured source snapshots."""
from pathlib import Path
import hashlib
import json
import math
import os
import re
import statistics

ROOT = Path(__file__).resolve().parents[1]
SUMMARY = re.compile(r'^([^:]+): mean=([\d.]+) sd=([\d.]+) batch_p50=([\d.]+) batch_p99=([\d.]+) ns/op n=(\d+)$')


def verify_snapshot(results, manifest="source-hashes.json"):
    fingerprints = json.loads((results / manifest).read_text())
    for name, expected in fingerprints.items():
        path = ROOT / name
        archived = results / "source-snapshot" / name
        # Corrections must not erase the actual source behind a historical table.
        # A preserved snapshot is valid evidence; it is not a claim current code
        # still has the same measurements.
        candidates = [p for p in (archived, path) if p.is_file()]
        assert any(hashlib.sha256(p.read_bytes()).hexdigest() == expected for p in candidates), f'measured source unavailable/changed: {name}'


def verify_samples(results, files):
    total = 0
    for filename, cases in files.items():
        raw, summary = {}, {}
        for line in (results / filename).read_text().splitlines():
            parts = line.split(',')
            if len(parts) == 3 and parts[1].isdigit():
                key, index, value = parts[0], int(parts[1]), float(parts[2])
                assert math.isfinite(value) and value >= 0
                assert index not in raw.setdefault(key, {}), f'duplicate sample {filename}/{key}/{index}'
                raw[key][index] = value
            match = SUMMARY.fullmatch(line)
            if match:
                assert match[1] not in summary, f'duplicate summary {filename}/{match[1]}'
                summary[match[1]] = [float(x) for x in match.groups()[1:5]] + [int(match[6])]
        assert set(summary) == set(cases), f'missing summaries in {filename}'
        assert set(raw) == set(cases.values()), f'unexpected raw cases in {filename}'
        for name, raw_key in cases.items():
            values = raw[raw_key]
            assert set(values) == set(range(21)), f'not exactly 21 observations: {filename}/{name}'
            xs = sorted(values.values())
            actual = [statistics.mean(xs), statistics.stdev(xs), xs[10], xs[20]]
            expected = summary[name]
            assert expected[-1] == 21
            assert all(abs(a - e) <= 0.000502 for a, e in zip(actual, expected)), f'statistics mismatch {filename}/{name}'
            total += len(xs)
    return total


def main():
    local = ROOT / 'bench/results/local'
    runtime = ROOT / 'bench/results/runtime-final'
    verify_snapshot(local)
    old = verify_samples(local, {
        **{f'atomic-{n}.txt': {k: k for k in ['Shared-Relaxed', 'Shared-SeqCst', 'Adjacent-Relaxed', 'Padded-Relaxed', 'Batched-Relaxed']} for n in [1, 4]},
        'handoff.txt': {'slot': 'slot', 'sync_channel': 'sync_channel'},
        'async-poll.txt': {'sync': '0', 'async-ready': '1', 'async-self-wake': '2'},
        'future-allocation.txt': {'stack-pin': 'stack', 'box-pin': 'box'},
    })
    assert 'test result: ok. 10 passed' in (local / 'tests.txt').read_text()
    assert 'ready=true payload=0' in (local / 'publication.txt').read_text()
    assert 'across_await size=4097 align=1' in (local / 'future-layout.txt').read_text()
    assert 'before_await size=2 align=1' in (local / 'future-layout.txt').read_text()
    for name in ['atomics.s', 'atomics.ll', 'future-layout.mir', 'future-allocation.s']:
        assert (local / name).stat().st_size > 100
    assert 'Analysis of sampling' in (ROOT / 'bench/results/profile/sample.txt').read_text()
    verify_snapshot(runtime)
    verify_snapshot(runtime, 'diagnostic-source-hashes.json')
    assert 'unexpected_failures=0' in (runtime / 'process-stress.txt').read_text()
    assert 'FAILED' in (runtime / 'preview-failed-parallel-drain.txt').read_text()
    new = verify_samples(runtime, {
        'scheduling.txt': {k: k for k in ['current-q16', 'current-q1024', 'multi4-q16', 'multi4-q1024']},
        'blocking-poll.txt': {'inline': 'inline', 'offload': 'offload'},
        'process-rpc.txt': {'spawn': 'spawn', 'persistent': 'persistent'},
        'pipe-drain.txt': {'prefix128': 'prefix128', 'retain-all': 'retain-all'},
    })
    tests = (runtime / 'tests.txt').read_text()
    assert 'test result: ok. 3 passed' in tests and 'test result: ok. 11 passed' in tests
    assert 'Frame size=16 align=8 wire=24' in (runtime / 'type-layout.txt').read_text()
    for name in ['runtime-lab.s', 'runtime-lab.ll', 'scheduling.s', 'scheduling.ll']:
        assert (runtime / name).stat().st_size > 1000
    assert 'Analysis of sampling' in (ROOT / 'bench/results/runtime-local/scheduling-sample.txt').read_text()
    assert 'Analysis of sampling' in (runtime / 'process-rpc-sample.txt').read_text()
    # Reviewed implementation files are separate from measured application sources.
    cargo_home = Path(os.environ.get('CARGO_HOME', Path.home() / '.cargo'))
    for source in json.loads((ROOT / 'sources/runtime-code.json').read_text()):
        candidates = cargo_home.glob(f'registry/src/*/{source["crate"]}-{source["version"]}/{source["path"]}')
        assert any(hashlib.sha256(p.read_bytes()).hexdigest() == source['sha256'] for p in candidates), f'implementation snapshot missing/changed: {source["id"]}'
    print(f'evidence checks passed: {old + new} archived raw observations; 10 + 14 recorded tests; measured source snapshots verified')
    print('525 batch means + 42 single-notification observations; not 567 production request-tail samples.')
    print('Not a correctness proof, independent audit, or full-book completion check.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
