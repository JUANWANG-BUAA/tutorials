#!/usr/bin/env python3
"""Validate raw observations, then report N-1 SD and nearest-rank batch quantiles."""
import csv
import math
import pathlib
import statistics
import sys

root = pathlib.Path(sys.argv[1])
groups = {}
for filename in ("admission.csv", "lifecycle.csv"):
    for row in csv.DictReader((root / filename).open()):
        groups.setdefault(row["case"], []).append(row)
assert set(groups) == {"admission-full", "logs-c1-r0", "logs-c1-r4096", "logs-c4-r4096"}
print("case,n,unit,mean,sd_n_minus_1,p50_nearest_rank,p99_nearest_rank,checksum")
for case, rows in groups.items():
    assert len(rows) == 21
    assert sorted(int(r["index"]) for r in rows) == list(range(21))
    operations = 100000 if case == "admission-full" else 8
    assert all(int(r["operations"]) == operations for r in rows)
    checks = {int(r["checksum"]) for r in rows}
    assert len(checks) == 1
    if case == "admission-full":
        assert checks == {100000}
    else:
        hashes = []
        for byte in b"OE":
            h = 0xCBF29CE484222325
            for _ in range(262144):
                h = ((h ^ byte) * 0x100000001B3) & ((1 << 64) - 1)
            hashes.append(h)
        assert checks == {(8 * sum(hashes)) & ((1 << 64) - 1)}
    xs = sorted(int(r["batch_ns"]) / operations for r in rows)
    assert xs[0] > 0
    unit = "ns/rejected-attempt" if operations == 100000 else "ns/tool-batch-mean"
    print(f"{case},21,{unit},{statistics.mean(xs):.3f},{statistics.stdev(xs):.3f},"
          f"{xs[math.ceil(.50 * len(xs))-1]:.3f},{xs[math.ceil(.99 * len(xs))-1]:.3f},"
          f"{next(iter(checks))}")
