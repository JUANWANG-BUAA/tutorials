#!/usr/bin/env python3
"""Mechanical archive validation, not an independent technical audit."""
from collections import defaultdict
import hashlib
import json
import math
from pathlib import Path
import re
import statistics
import sys

from collapse_sample import collapse


def stats(values):
    ordered = sorted(values)
    return {"mean": statistics.mean(values), "sd": statistics.stdev(values),
            "p50": ordered[math.ceil(.5 * len(values)) - 1],
            "p99": ordered[math.ceil(.99 * len(values)) - 1]}


def main():
    root = Path(sys.argv[1]).resolve()
    for line in (root / "source-sha256.txt").read_text().splitlines():
        expected, original = line.split("  ", 1)
        relative = original.split("/evidence-lab/", 1)[1]
        archived = root / "measured-source" / relative
        assert hashlib.sha256(archived.read_bytes()).hexdigest() == expected, relative
    print("measured source snapshot fingerprints verified")
    total = 0
    for filename in ["cpu-wait.txt", "instrumentation.txt", "feature-default.txt", "feature-checked.txt"]:
        text = (root / filename).read_text()
        groups = defaultdict(list)
        rounds = defaultdict(set)
        sums = defaultdict(set)
        for case, round_id, value, checksum in re.findall(
                r"^raw,([^,]+),round=(\d+),value=([\d.]+),checksum=(\d+)", text, re.M):
            groups[case].append(float(value))
            rounds[case].add(int(round_id))
            sums[case].add(checksum)
        assert groups, filename
        for case, values in groups.items():
            assert len(values) == 21 and rounds[case] == set(range(21))
            assert len(sums[case]) == 1
            assert all(math.isfinite(v) and v > 0 for v in values)
            match = re.search(rf"^summary,{case},n=21,mean=([\d.]+),sd=([\d.]+),p50=([\d.]+),p99=([\d.]+)", text, re.M)
            assert match is not None
            actual = stats(values)
            for key, expected in zip(["mean", "sd", "p50", "p99"], map(float, match.groups())):
                assert abs(actual[key] - expected) < 2e-6, (filename, case, key)
            total += len(values)
            print(filename, case, "n=21, summary verified")
    rows = [json.loads(line) for line in (root / "build-raw.jsonl").read_text().splitlines()]
    assert len(rows) == 126
    summary = json.loads((root / "build-summary.json").read_text())
    for case, result in summary.items():
        selected = [row for row in rows if row["case"] == case]
        assert len(selected) == 21 and {row["round"] for row in selected} == set(range(21))
        for key, value in stats([row["wall_ms"] for row in selected]).items():
            assert math.isclose(value, result[key], rel_tol=1e-12)
    for profile in ["release", "one", "thin"]:
        for round_id in range(21):
            pair = [row for row in rows if row["case"].startswith(profile + "/") and row["round"] == round_id]
            assert len(pair) == 2 and pair[0]["binary_sha256"] == pair[1]["binary_sha256"]
            assert "Fresh evidence-lab" in (root / f"build-{profile}-{round_id:02}-noop.txt").read_text()
    total += len(rows)
    assert total == 273
    for mode in ["cpu", "wait"]:
        text = (root / f"sample-{mode}.txt").read_text()
        count = sum(map(int, re.findall(r"^\s+(\d+) Thread_", text, re.M)))
        folded = collapse(text)
        assert count > 0 and sum(folded.values()) == count
        print("sample", mode, "exclusive total", count)
    for binary in (root / "binaries").iterdir():
        print("binary", binary.name, hashlib.sha256(binary.read_bytes()).hexdigest())
    print("formal observations:", total)
    print("mechanical validation only; no isolation or independent-audit claim")


if __name__ == "__main__":
    main()
