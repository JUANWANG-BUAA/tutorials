#!/usr/bin/env python3
"""
读 results/run-01/bench.csv，按 A/B 配对差值算统计量，写 statistics.json。

只用标准库。差值定义 d = B(tidekv) - A(基线)，单位 ns/op：
d > 0 表示 tidekv 比进程内基线慢多少，这就是交给 gate.py 判定的「额外开销」。
置信区间对 d 的均值做 percentile bootstrap，种子固定、可复跑。
"""
import json
import math
import random
import sys
from pathlib import Path

UNITS = "ns_per_op"


def read_csv(path):
    meta = {}
    rows = []
    with open(path, newline="") as f:
        lines = [ln for ln in f if not ln.startswith("#")]
        header = lines[0].strip().split(",")
        for ln in lines[1:]:
            parts = ln.rstrip("\n").split(",")
            if len(parts) != len(header):
                continue
            rows.append(dict(zip(header, parts)))
    with open(path) as f:
        for ln in f:
            if not ln.startswith("#"):
                break
            body = ln[1:].strip()
            for tok in body.replace(";", " ").split():
                if "=" in tok:
                    k, v = tok.split("=", 1)
                    meta.setdefault(k, v)
    return meta, rows, header


def paired(meta, rows, case):
    """返回每轮的 (A, B) 对；任一侧缺失则整对删掉。"""
    by_round = {}
    for r in rows:
        if r["kind"] != "BATCH_MEAN" or r["case"] != case:
            continue
        d = by_round.setdefault(int(r["round"]), {})
        arm = r["arm"]
        v = float(r["value_ns_per_op"])
        if arm in d:
            raise SystemExit(f"duplicate {arm} row for case {case} round {r['round']}")
        d[arm] = v
    pairs, dropped = [], []
    for rd in sorted(by_round):
        d = by_round[rd]
        if "A" in d and "B" in d:
            pairs.append((rd, d["A"], d["B"]))
        else:
            dropped.append(rd)
    return pairs, dropped


def summarize(values):
    n = len(values)
    if n == 0:
        return None
    mean = sum(values) / n
    if n > 1:
        var = sum((x - mean) ** 2 for x in values) / (n - 1)  # 分母 N-1
        sd = math.sqrt(var)
    else:
        sd = 0.0
    return {"n": n, "mean": mean, "stddev_sample": sd, "sem": sd / math.sqrt(n)}


def bootstrap_ci(diffs, seed, iters=20000, alpha=0.05):
    rng = random.Random(seed)
    n = len(diffs)
    means = []
    for _ in range(iters):
        sample = [diffs[rng.randrange(n)] for _ in range(n)]
        means.append(sum(sample) / n)
    means.sort()
    lo = means[int((alpha / 2) * iters)]
    hi = means[min(int((1 - alpha / 2) * iters), iters - 1)]
    return lo, hi


def main():
    if len(sys.argv) < 2:
        print("usage: analyze.py <bench.csv> [out.json]", file=sys.stderr)
        raise SystemExit(2)
    src = Path(sys.argv[1])
    out = Path(sys.argv[2]) if len(sys.argv) > 2 else src.parent / "statistics.json"
    meta, rows, _ = read_csv(src)
    seed = int(meta.get("seed", "0"))
    cases = []
    seen = []
    for r in rows:
        if r["case"] not in seen:
            seen.append(r["case"])
    boot_seed = seed ^ 0xB007
    for case in seen:
        pairs, dropped = paired(meta, rows, case)
        if not pairs:
            continue
        a = [p[1] for p in pairs]
        b = [p[2] for p in pairs]
        diffs = [y - x for x, y in zip(a, b)]  # B - A：tidekv 相对基线的额外开销
        s = summarize(diffs)
        lo, hi = bootstrap_ci(diffs, boot_seed)
        cases.append(
            {
                "case": case,
                "rounds_used": len(pairs),
                "rounds_dropped": dropped,
                "arm_A_mean_ns_per_op": sum(a) / len(a),
                "arm_B_mean_ns_per_op": sum(b) / len(b),
                "diff_B_minus_A_mean_ns_per_op": s["mean"],
                "diff_stddev_sample_ns_per_op": s["stddev_sample"],
                "diff_sem_ns_per_op": s["sem"],
                "diff_ci95_low_ns_per_op": lo,
                "diff_ci95_high_ns_per_op": hi,
                "ratio_B_over_A": (sum(b) / len(b)) / (sum(a) / len(a)),
                "per_round": [
                    {"round": rd, "A": x, "B": y, "diff": y - x} for rd, x, y in pairs
                ],
            }
        )
    result = {
        "units": UNITS,
        "diff_convention": "diff = B(tidekv) - A(baseline), ns/op; positive means tidekv is slower",
        "csv": str(src),
        "protocol": {k: meta[k] for k in ("seed", "rounds", "batches_per_round", "ops_per_batch", "warmup_ms", "flush_every") if k in meta},
        "bootstrap": {
            "seed": boot_seed,
            "iterations": 20000,
            "method": "percentile bootstrap of the paired mean difference",
            "confidence": 0.95,
        },
        "cases": cases,
        "overall": {
            "cases_measured": len(cases),
            "rounds_per_case": [c["rounds_used"] for c in cases],
        },
    }
    out.write_text(json.dumps(result, indent=2) + "\n")
    for c in cases:
        print(
            f"{c['case']:12s} A={c['arm_A_mean_ns_per_op']:.1f} B={c['arm_B_mean_ns_per_op']:.1f} "
            f"diff(B-A)={c['diff_B_minus_A_mean_ns_per_op']:+.1f} "
            f"sd={c['diff_stddev_sample_ns_per_op']:.1f} "
            f"CI95=[{c['diff_ci95_low_ns_per_op']:+.1f}, {c['diff_ci95_high_ns_per_op']:+.1f}] "
            f"rounds={c['rounds_used']}"
        )
    print(f"statistics -> {out}")


if __name__ == "__main__":
    main()
