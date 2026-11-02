#!/usr/bin/env python3
"""
三态门禁（机制对照实验专用）：读 analyze_mech.py 的 statistics.json，
把配对差值的 95% 区间与预算 B 比一比。

判定规则与项目主门禁一致：
  U <= B   接受
  L >  B   拒绝
  其它     证据不足
预算 B 从命令行给，单位与被测量一致；判定的每一条都写进 gate.json。
"""
import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from gate import verdict  # noqa: E402


def main():
    ap = argparse.ArgumentParser(description="tidekv mechanism-round three-state gate")
    ap.add_argument("statistics", help="statistics.json from analyze_mech.py")
    ap.add_argument("-B", "--budget", type=float, required=True, help="预算 B，单位同被测量")
    ap.add_argument("-o", "--out", help="gate.json 输出路径")
    ap.add_argument("--budget-note", default="", help="预算的来源说明（写进 gate.json）")
    ap.add_argument(
        "--case",
        action="append",
        help="只判这些 case（可重复）；同一份 statistics.json 里不同分母各有各的预算",
    )
    args = ap.parse_args()

    stats = json.loads(Path(args.statistics).read_text())
    picked = [c for c in stats["cases"] if not args.case or c["case"] in args.case]
    if not picked:
        raise SystemExit(f"没有 case 匹配 {args.case}")
    cases = []
    counts = {"accept": 0, "reject": 0, "insufficient-evidence": 0}
    for c in picked:
        L = c["diff_ci95_low"]
        U = c["diff_ci95_high"]
        v = verdict(L, U, args.budget)
        counts[v] += 1
        cases.append(
            {
                "case": c["case"],
                "units": c.get("units", stats.get("units", "")),
                "rounds_used": c["rounds_used"],
                "arm_A_mean": c["arm_A_mean"],
                "arm_B_mean": c["arm_B_mean"],
                "diff_mean": c["diff_B_minus_A_mean"],
                "ci95_low": L,
                "ci95_high": U,
                "budget_B": args.budget,
                "rule": "U<=B accept; L>B reject; otherwise insufficient-evidence",
                "verdict": v,
            }
        )
        print(f"{c['case']:16s} L={L:+.3f} U={U:+.3f} B={args.budget:.3f} -> {v}")
    out = {
        "budget_B": args.budget,
        "budget_note": args.budget_note,
        "units": stats.get("units", ""),
        "rule": "U <= B accept | L > B reject | else insufficient-evidence",
        "diff_convention": stats.get("diff_convention", ""),
        "cases_judged": [c["case"] for c in picked],
        "bootstrap": stats.get("bootstrap", {}),
        "protocol": stats.get("protocol", {}),
        "counts": counts,
        "cases": cases,
    }
    dest = Path(args.out) if args.out else Path(args.statistics).with_name("gate.json")
    dest.write_text(json.dumps(out, indent=2) + "\n")
    print(
        f"gate -> {dest}  ({counts['accept']} accept / {counts['reject']} reject "
        f"/ {counts['insufficient-evidence']} insufficient)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
