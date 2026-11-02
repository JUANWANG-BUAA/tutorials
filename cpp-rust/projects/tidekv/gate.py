#!/usr/bin/env python3
"""
三态门禁：读 statistics.json，把每个 case 的配对差值置信区间与预算 B 比一比。

判定用的是「额外开销」d = B(tidekv) - A(基线)，单位 ns/op，预算 B 从命令行给：
  U <= B   接受（最坏情形也没超过预算）
  L >  B   拒绝（最好情形都已经超预算）
  其它     证据不足（区间横跨预算线）
结果写 gate.json，预算与判定口径一并写进去。
"""

import argparse
import json
import sys
from pathlib import Path


def verdict(L, U, budget):
    if U <= budget:
        return "accept"
    if L > budget:
        return "reject"
    return "insufficient-evidence"


def main():
    ap = argparse.ArgumentParser(description="tidekv three-state gate")
    ap.add_argument("statistics", help="statistics.json from analyze.py")
    ap.add_argument(
        "-B",
        "--budget",
        type=float,
        required=True,
        help="允许的额外开销预算 B，单位与被测量一致（ns/op）",
    )
    ap.add_argument("-o", "--out", help="gate.json 输出路径，默认与 statistics.json 同目录")
    args = ap.parse_args()

    stats = json.loads(Path(args.statistics).read_text())
    budget = args.budget
    units = stats.get("units", "ns_per_op")
    cases = []
    counts = {"accept": 0, "reject": 0, "insufficient-evidence": 0}
    for c in stats["cases"]:
        L = c["diff_ci95_low_ns_per_op"]
        U = c["diff_ci95_high_ns_per_op"]
        v = verdict(L, U, budget)
        counts[v] += 1
        cases.append(
            {
                "case": c["case"],
                "rounds_used": c["rounds_used"],
                "diff_mean_ns_per_op": c["diff_B_minus_A_mean_ns_per_op"],
                "ci95_low_ns_per_op": L,
                "ci95_high_ns_per_op": U,
                "budget_B_ns_per_op": budget,
                "rule": "U<=B accept; L>B reject; otherwise insufficient-evidence",
                "verdict": v,
            }
        )
        print(
            f"{c['case']:12s} L={L:+.1f} U={U:+.1f} B={budget:.1f} [{units}] -> {v}"
        )
    out = {
        "budget_B": budget,
        "units": units,
        "rule": "U <= B accept | L > B reject | else insufficient-evidence",
        "diff_convention": stats.get("diff_convention", ""),
        "bootstrap": stats.get("bootstrap", {}),
        "protocol": stats.get("protocol", {}),
        "counts": counts,
        "cases": cases,
        "all_accept": counts["accept"] == len(cases) and len(cases) > 0,
    }
    dest = Path(args.out) if args.out else Path(args.statistics).with_name("gate.json")
    dest.write_text(json.dumps(out, indent=2) + "\n")
    print(f"gate -> {dest}  ({counts['accept']} accept / {counts['reject']} reject / {counts['insufficient-evidence']} insufficient)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
