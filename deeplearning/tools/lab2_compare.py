#!/usr/bin/env python3
"""Compare paired Lab 2 predictions; training remains in the official notebook."""

import argparse
import csv
import json
import math
import random
import sys
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass(frozen=True)
class Sample:
    """One held-out image, its resampling unit, and both frozen predictions."""

    sample_id: str
    unit_id: str
    group: str
    label: int
    baseline: float
    dbvae: float


def probability(value: str) -> float:
    """Parse a finite probability, rejecting logits and missing values."""
    number = float(value)
    if not math.isfinite(number) or not 0 <= number <= 1:
        raise ValueError("probability/threshold must be finite and in [0, 1]")
    return number


def load_samples(path: Path) -> list[Sample]:
    """Validate a wide paired CSV, preserving missing groups as __unknown__."""
    result: list[Sample] = []
    seen: set[str] = set()
    required = {"sample_id", "unit_id", "group", "label", "baseline_score", "dbvae_score"}
    with path.open(newline="", encoding="utf-8") as stream:
        reader = csv.DictReader(stream)
        fields = reader.fieldnames or []
        if len(fields) != len(set(fields)) or not required.issubset(fields):
            raise ValueError(f"CSV needs unique columns: {sorted(required)}")
        for line, row in enumerate(reader, 2):
            if None in row or any(row[key] is None for key in required):
                raise ValueError(f"line {line}: malformed CSV row")
            sid, unit = row["sample_id"].strip(), row["unit_id"].strip()
            if not sid or not unit or sid in seen or row["label"] not in {"0", "1"}:
                raise ValueError(f"line {line}: empty/duplicate ID or invalid label")
            seen.add(sid)
            result.append(Sample(sid, unit, row["group"].strip() or "__unknown__",
                                 int(row["label"]), probability(row["baseline_score"]),
                                 probability(row["dbvae_score"])))
    if not result:
        raise ValueError("CSV has no samples")
    return result


def metrics(rows: list[Sample], model: str, threshold: float) -> dict[str, Any]:
    """Return confusion counts and rates; zero denominators produce JSON null."""
    counts = {key: 0 for key in ("TP", "TN", "FP", "FN")}
    for row in rows:
        positive = getattr(row, model) >= threshold
        key = ("TP" if positive else "FN") if row.label else ("FP" if positive else "TN")
        counts[key] += 1
    positives = counts["TP"] + counts["FN"]
    negatives = counts["TN"] + counts["FP"]
    return {**counts, "n": len(rows), "units": len({row.unit_id for row in rows}),
            "positives": positives, "negatives": negatives,
            "accuracy": (counts["TP"] + counts["TN"]) / len(rows) if rows else None,
            "FNR": counts["FN"] / positives if positives else None,
            "FPR": counts["FP"] / negatives if negatives else None}


def summarize(rows: list[Sample], groups: list[str], positive_groups: list[str], threshold: float) -> dict[str, Any]:
    """Report pooled and named cohorts plus a fixed-set worst positive FNR."""
    cohorts: dict[str, list[Sample]] = {group: [] for group in groups}
    for row in rows:
        cohorts[row.group].append(row)
    reports = {group: {model: metrics(items, model, threshold)
                       for model in ("baseline", "dbvae")}
               for group, items in [("__overall__", rows), *cohorts.items()]}
    eligible = positive_groups
    worst: dict[str, float | None] = {}
    for model in ("baseline", "dbvae"):
        rates = [reports[g][model]["FNR"] for g in eligible]
        worst[model] = max(rates) if rates and all(x is not None for x in rates) else None
    return {"cohorts": reports, "worst_FNR": worst}


def difference(left: float | None, right: float | None) -> float | None:
    """Return DB-VAE minus baseline, preserving undefined measurements."""
    return None if left is None or right is None else right - left


def percentile(values: list[float], fraction: float) -> float:
    """Linearly interpolate an empirical quantile of sorted values."""
    position = (len(values) - 1) * fraction
    low = int(position)
    high = min(low + 1, len(values) - 1)
    return values[low] + (position - low) * (values[high] - values[low])


def interval(values: list[float], repetitions: int) -> dict[str, Any]:
    """Expose missing bootstrap replicates instead of silently dropping them."""
    values.sort()
    # An incomplete distribution cannot define the advertised fixed-cohort CI.
    bounds = [percentile(values, 0.025), percentile(values, 0.975)] if len(values) == repetitions else None
    return {"ci95": bounds, "valid_replicates": len(values), "requested_replicates": repetitions}


def compare(rows: list[Sample], threshold: float, repetitions: int, seed: int) -> dict[str, Any]:
    """Cluster-bootstrap paired model deltas over the same resampled units."""
    groups = sorted({row.group for row in rows})
    if "__overall__" in groups:
        raise ValueError("__overall__ is a reserved group name")
    positive_groups = sorted({row.group for row in rows if row.label and row.group != "__unknown__"})
    point = summarize(rows, groups, positive_groups, threshold)
    units: dict[str, list[Sample]] = defaultdict(list)
    for row in rows:
        units[row.unit_id].append(row)
    clusters = list(units.values())
    draws: dict[tuple[str, str], list[float]] = defaultdict(list)
    worst_draws: list[float] = []
    rng = random.Random(seed)
    for _ in range(repetitions):
        sampled = [row for _ in clusters for row in clusters[rng.randrange(len(clusters))]]
        report = summarize(sampled, groups, positive_groups, threshold)
        for group, models in report["cohorts"].items():
            for metric in ("accuracy", "FNR", "FPR"):
                delta = difference(models["baseline"][metric], models["dbvae"][metric])
                if delta is not None:
                    draws[group, metric].append(delta)
        delta = difference(report["worst_FNR"]["baseline"], report["worst_FNR"]["dbvae"])
        if delta is not None:
            worst_draws.append(delta)
    for group, models in point["cohorts"].items():
        models["paired_delta_dbvae_minus_baseline"] = {
            metric: {"estimate": difference(models["baseline"][metric], models["dbvae"][metric]),
                     **interval(draws[group, metric], repetitions)}
            for metric in ("accuracy", "FNR", "FPR")}
    point["worst_FNR"]["paired_delta_dbvae_minus_baseline"] = {
        "estimate": difference(point["worst_FNR"]["baseline"], point["worst_FNR"]["dbvae"]),
        **interval(worst_draws, repetitions)}
    point["worst_FNR_groups"] = positive_groups
    return point


def main() -> int:
    """Read held-out paired predictions and a pre-frozen validation record."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("predictions", type=Path)
    parser.add_argument("--threshold-record", required=True, type=Path)
    parser.add_argument("--bootstrap", type=int, default=2000)
    parser.add_argument("--seed", type=int, default=191)
    args = parser.parse_args()
    try:
        if args.bootstrap < 100:
            raise ValueError("--bootstrap must be at least 100")
        record = json.loads(args.threshold_record.read_text(encoding="utf-8"))
        if not isinstance(record, dict) or record.get("split") != "validation":
            raise ValueError("threshold record must declare split=validation")
        for key in ("validation_manifest", "selection_rule", "baseline_checkpoint", "dbvae_checkpoint"):
            if not isinstance(record.get(key), str) or not record[key].strip():
                raise ValueError(f"threshold record needs nonempty {key}")
        if isinstance(record.get("threshold"), bool) or not isinstance(record.get("threshold"), (int, float)):
            raise ValueError("threshold must be a JSON number")
        threshold = probability(str(record.get("threshold")))
        rows = load_samples(args.predictions)
        report = compare(rows, threshold, args.bootstrap, args.seed)
        report["metadata"] = {"threshold_record": record, "seed": args.seed,
                              "bootstrap": args.bootstrap, "resampling": "paired unit_id cluster bootstrap",
                              "undefined": "null", "prediction_file": str(args.predictions)}
        print(json.dumps(report, ensure_ascii=False, indent=2, allow_nan=False))
    except (OSError, UnicodeError, ValueError, csv.Error) as exc:
        print(f"lab2_compare: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
