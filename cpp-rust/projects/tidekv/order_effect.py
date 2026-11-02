#!/usr/bin/env python3
"""从归档 CSV 复算「每轮谁先跑」对配对差值的影响。

三轮测量都把每轮的臂顺序掷了硬币（`arm_order` 列只有 `A_then_B` / `B_then_A`
两个值）。同一轮内两臂各跑一次，位次差直接进了那一轮的差值；把它压回去的是
各轮顺序的分配，不是配对本身。这个脚本按顺序类分组复算三件事：

- 两个顺序类各自的平均差值，以及它们的间距；
- 实际轮数分配相对均衡分配给平均差值带来的偏移；
- 该偏移占本轮 95% 区间半宽的比例。

数字全部来自归档文件，不重新测量：

    python3 order_effect.py results/run-01/bench.csv results/run-01/statistics.json

不带参数时扫描 `results/` 下所有 `run-*` 目录。

**符号约定**：本脚本一律算 `diff = A − B`。run-01 与 run-02 的归档约定是
`diff = B − A`（见各自 statistics JSON 的 `diff_convention`），所以这里的数
与归档差值同号相反；只有「两个顺序类之间的间距」和「不均衡偏移」是本次复算
新增的量，归档里没有现成的列。
"""

from __future__ import annotations

import csv
import json
import statistics
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def read_batches(csv_path: Path):
    """返回 {(case, round): {'A': ns/op, 'B': ns/op, 'order': arm_order}}，只取批均值行。"""
    lines = [ln for ln in csv_path.read_text().splitlines() if ln.strip() and not ln.startswith("#")]
    out = {}
    for row in csv.DictReader(lines):
        if row["kind"] != "BATCH_MEAN":
            continue
        key = (row["case"], int(row["round"]))
        slot = out.setdefault(key, {"order": row["arm_order"]})
        slot[row["arm"]] = float(row["value_ns_per_op"])
    return out


def read_ci(stats_path: Path):
    """从 statistics JSON 取每个 case 的 95% 区间；字段名带单位后缀，按子串找。"""
    cases = json.loads(stats_path.read_text())["cases"]
    ci = {}
    for case in cases:
        low = high = None
        for k, v in case.items():
            if "ci95_low" in k:
                low = v
            elif "ci95_high" in k:
                high = v
        if low is not None and high is not None:
            ci[case["case"]] = (float(low), float(high))
    return ci


def analyse(csv_path: Path, stats_path: Path):
    batches = read_batches(csv_path)
    ci = read_ci(stats_path)
    rows = []
    by_case = defaultdict(list)
    for (case, _), slot in batches.items():
        if "A" in slot and "B" in slot:
            by_case[case].append((slot["order"], slot["A"] - slot["B"]))
    for case in sorted(by_case):
        pairs = by_case[case]
        groups = defaultdict(list)
        for order, diff in pairs:
            groups[order].append(diff)
        if not groups["A_then_B"] or not groups["B_then_A"]:
            continue
        mean_a = statistics.mean(groups["A_then_B"])
        mean_b = statistics.mean(groups["B_then_A"])
        allv = [d for _, d in pairs]
        shift = statistics.mean(allv) - (mean_a + mean_b) / 2.0
        gap = mean_a - mean_b
        if case in ci:
            low, high = ci[case]
            half = (high - low) / 2.0
            ratio = abs(shift) / half if half else float("nan")
        else:
            half, ratio = float("nan"), float("nan")
        rows.append(
            {
                "case": case,
                "n_a": len(groups["A_then_B"]),
                "n_b": len(groups["B_then_A"]),
                "diff_a_first": mean_a,
                "diff_b_first": mean_b,
                "class_gap": gap,
                "imbalance_shift": shift,
                "ci_half": half,
                "shift_over_half": ratio,
            }
        )
    return rows


def fmt(rows, title):
    print(f"\n{title}")
    print("（本表 diff = A − B；归档若约定 B − A，符号相反）")
    print(
        "case                n(A先/B先)  diff|A先      diff|B先      类间间距     不均衡偏移   CI半宽     |偏移|/半宽"
    )
    for r in rows:
        print(
            f"{r['case']:<18} {r['n_a']:>2}/{r['n_b']:<2}      "
            f"{r['diff_a_first']:>11.1f}  {r['diff_b_first']:>11.1f}  "
            f"{r['class_gap']:>+11.1f}  {r['imbalance_shift']:>+11.1f}  "
            f"{r['ci_half']:>9.1f}  {r['shift_over_half']:>9.3f}"
        )


def main(argv: list[str]) -> int:
    if len(argv) >= 3:
        pairs = [(Path(argv[1]), Path(argv[2]))]
    else:
        pairs = []
        for run in sorted((ROOT / "results").glob("run-*")):
            for csv_path in sorted(run.glob("*.csv")):
                stem = csv_path.stem
                for cand in (run / f"statistics-{stem}.json", run / "statistics.json"):
                    if cand.is_file():
                        pairs.append((csv_path, cand))
                        break
    if not pairs:
        print("results/ 下没有找到 CSV", file=sys.stderr)
        return 1
    for csv_path, stats_path in pairs:
        rows = analyse(csv_path, stats_path)
        if rows:
            fmt(rows, f"{csv_path}  ×  {stats_path.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
