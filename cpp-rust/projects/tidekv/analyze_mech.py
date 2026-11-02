#!/usr/bin/env python3
"""
读机制对照实验的 CSV，算配对差值与 bootstrap 区间，写 statistics.json。

与 analyze.py 同一套算法（配对差值、percentile bootstrap、三态门禁的输入格式），
区别只有两处：
  1. 单位按实验写清楚——编解码是 ns/记录，压缩是 ns/次合并；
  2. 差值方向写进 JSON：编解码实验的 B 是 `dyn` 路径，压缩实验的 B 是子进程路径。
只读同一份 CSV 的统计，不改任何原始数值。
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from analyze import bootstrap_ci, paired, read_csv, summarize  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description="tidekv mechanism-round statistics")
    ap.add_argument("csv", help="机制对照实验的 CSV")
    ap.add_argument("--units", required=True, help="单位，例如 ns_per_record")
    ap.add_argument(
        "--diff-convention",
        required=True,
        help="差值方向的说明，例如 'diff = B(dyn) - A(generic)'",
    )
    ap.add_argument("--out", help="statistics.json 输出路径")
    args = ap.parse_args()

    src = Path(args.csv)
    out = Path(args.out) if args.out else src.parent / "statistics.json"
    meta, rows, _ = read_csv(src)
    seed = int(meta.get("seed", "0"))
    boot_seed = seed ^ 0xB007

    cases = []
    seen = []
    for r in rows:
        if r["case"] not in seen:
            seen.append(r["case"])
    for case in seen:
        pairs, dropped = paired(meta, rows, case)
        if not pairs:
            continue
        a = [p[1] for p in pairs]
        b = [p[2] for p in pairs]
        diffs = [y - x for x, y in zip(a, b)]
        s = summarize(diffs)
        lo, hi = bootstrap_ci(diffs, boot_seed)
        cases.append(
            {
                "case": case,
                "units": args.units,
                "rounds_used": len(pairs),
                "rounds_dropped": dropped,
                "arm_A_mean": sum(a) / len(a),
                "arm_B_mean": sum(b) / len(b),
                "diff_B_minus_A_mean": s["mean"],
                "diff_stddev_sample": s["stddev_sample"],
                "diff_sem": s["sem"],
                "diff_ci95_low": lo,
                "diff_ci95_high": hi,
                "ratio_B_over_A": (sum(b) / len(b)) / (sum(a) / len(a)),
                "per_round": [
                    {"round": rd, "A": x, "B": y, "diff": y - x} for rd, x, y in pairs
                ],
            }
        )

    result = {
        "units": args.units,
        "diff_convention": args.diff_convention,
        "csv": str(src),
        "protocol": {
            k: meta[k]
            for k in (
                "seed",
                "rounds",
                "batches_per_round",
                "ops_per_batch",
                "warmup_ms",
            )
            if k in meta
        },
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
            f"{c['case']:16s} A={c['arm_A_mean']:.3f} B={c['arm_B_mean']:.3f} "
            f"diff(B-A)={c['diff_B_minus_A_mean']:+.3f} "
            f"sd={c['diff_stddev_sample']:.3f} "
            f"CI95=[{c['diff_ci95_low']:+.3f}, {c['diff_ci95_high']:+.3f}] "
            f"rounds={c['rounds_used']} ({args.units})"
        )
    print(f"statistics -> {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
