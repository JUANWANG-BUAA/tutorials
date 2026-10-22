#!/usr/bin/env python3
"""Validate 21 observations/case; N-1 SD; nearest-rank batch quantiles."""
import csv
import json
import math
import pathlib
import statistics
import sys

path = pathlib.Path(sys.argv[1])
rows = list(csv.DictReader(path.open()))
names = ["per_element", "batch", "copy_out", "owned_handle"]
summary = {}
assert len(rows) == 84
for name in names:
    case = [r for r in rows if r["case"] == name]
    assert len(case) == 21
    assert sorted(int(r["observation"]) for r in case) == list(range(1, 22))
    assert {int(r["words"]) for r in case} == {8192 * 64}
    assert len({r["checksum"] for r in case}) == 1
    values = sorted(int(r["elapsed_ns"]) / int(r["words"]) for r in case)
    assert all(v > 0 for v in values)
    summary[name] = {
        "n": len(values),
        "unit": "ns/word (batch wall time / 524288 words)",
        "mean": statistics.mean(values),
        "sample_sd": statistics.stdev(values),
        "variance": statistics.variance(values),
        "p50_nearest_rank": values[math.ceil(.50 * len(values)) - 1],
        "p99_nearest_rank": values[math.ceil(.99 * len(values)) - 1],
        "checksum": case[0]["checksum"],
    }
assert summary["per_element"]["checksum"] == summary["batch"]["checksum"]
assert summary["copy_out"]["checksum"] == summary["owned_handle"]["checksum"]
print(json.dumps(summary, indent=2))
