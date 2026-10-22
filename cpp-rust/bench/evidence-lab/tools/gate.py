#!/usr/bin/env python3
"""Fail-closed local gate. This is descriptive thresholding, not a significance test."""
import argparse
import json
from pathlib import Path
import re
import sys


def load_runtime(path):
    text = Path(path).read_text()
    rows = re.findall(r"^raw,([^,]+),round=(\d+),value=([\d.]+),checksum=(\d+)", text, re.M)
    if len(rows) != 21 or {int(row[1]) for row in rows} != set(range(21)):
        raise ValueError("expected exactly 21 distinct rounds")
    values = [float(row[2]) for row in rows]
    if any(not (0 < value < float("inf")) for value in values):
        raise ValueError("nonpositive or nonfinite sample")
    checksums = {row[3] for row in rows}
    if len(checksums) != 1:
        raise ValueError("inconsistent checksum")
    units = re.search(r"^unit=([^;]+)", text, re.M)
    if units is None:
        raise ValueError("unit missing")
    return {"mean": sum(values) / 21, "unit": units[1], "checksum": checksums.pop()}


def compare(baseline, candidate, budget):
    if budget < 0:
        raise ValueError("budget must be nonnegative")
    if baseline["unit"] != candidate["unit"] or baseline["checksum"] != candidate["checksum"]:
        raise ValueError("unit or correctness evidence differs")
    ratio = candidate["mean"] / baseline["mean"]
    return {"ratio": ratio, "budget": budget, "pass": ratio <= 1 + budget,
            "scope": "local workload only; no statistical significance or SLA claim"}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("baseline")
    parser.add_argument("candidate")
    parser.add_argument("--budget", type=float, default=.2)
    args = parser.parse_args()
    try:
        result = compare(load_runtime(args.baseline), load_runtime(args.candidate), args.budget)
    except (ValueError, OSError) as error:
        print(json.dumps({"pass": False, "error": str(error)}))
        return 2
    print(json.dumps(result, indent=2))
    return 0 if result["pass"] else 1


if __name__ == "__main__":
    sys.exit(main())
