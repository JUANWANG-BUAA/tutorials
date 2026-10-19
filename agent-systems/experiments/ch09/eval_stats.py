#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 9 章实验：一个小型评估集的统计口径。

内置 48 条配对结果（同一批任务上系统 A 与系统 B 各跑一次），实现：

  - 准确率与 Wilson 95% 区间；
  - bootstrap 百分位区间（准确率、均值、P95 延迟）；
  - 配对 bootstrap 差值与近似 p 值，以及 McNemar 精确检验；
  - 按难度、语言分层报告，并验证加权后与总体一致；
  - 延迟 P50/P95/P99（nearest-rank）与成本/工具成功率。

纯标准库、无网络、确定性。bootstrap 的随机性只来自 --seed。

用法：
    python3 experiments/ch09/eval_stats.py                  # 两个系统 + 配对差值
    python3 experiments/ch09/eval_stats.py --compare        # 同上，显式写法
    python3 experiments/ch09/eval_stats.py --strata         # 分层报告
    python3 experiments/ch09/eval_stats.py --seed 7         # 换随机种子
    python3 experiments/ch09/eval_stats.py --compare --json # 机器可读
"""

from __future__ import annotations

import argparse
import json
import math
import random
from dataclasses import dataclass
from typing import Callable, Iterable, Sequence

Z95 = 1.959963984540054
DEFAULT_SEED = 20261019
DEFAULT_BOOT = 4000


@dataclass(frozen=True)
class Item:
    """一条配对评估结果：同一任务，系统 A 与 B 各一次。"""

    item_id: str
    difficulty: str
    language: str
    a_ok: bool
    b_ok: bool
    a_ms: int
    b_ms: int
    a_cost_micros: int
    a_tools: int
    b_tools: int
    a_tool_errors: int
    b_tool_errors: int

    @property
    def b_cost_micros(self) -> int:
        # B 的单价按 A 的 1.18 倍构造：多一轮验证调用，质量略升、成本变贵。
        return round(self.a_cost_micros * 1.18)


# 字段顺序：id, 难度, 语言, A 正确, B 正确, A 延迟, B 延迟,
#           A 成本(微美元), A 工具调用, B 工具调用, A 工具错误, B 工具错误
_RAW: tuple[tuple, ...] = (
    # easy：16 条，A 只错 t05；B 全对。B 平均快约 60 ms。
    ("t01", "easy", "py", 1, 1, 420, 360, 900, 3, 4, 0, 0),
    ("t02", "easy", "ts", 1, 1, 380, 330, 850, 3, 4, 0, 0),
    ("t03", "easy", "py", 1, 1, 510, 470, 1100, 4, 5, 0, 0),
    ("t04", "easy", "ts", 1, 1, 470, 410, 980, 3, 4, 0, 0),
    ("t05", "easy", "py", 0, 1, 560, 520, 1250, 4, 5, 0, 0),
    ("t06", "easy", "ts", 1, 1, 440, 380, 920, 3, 4, 0, 0),
    ("t07", "easy", "py", 1, 1, 390, 340, 880, 3, 4, 1, 0),
    ("t08", "easy", "ts", 1, 1, 620, 540, 1350, 5, 6, 0, 0),
    ("t09", "easy", "py", 1, 1, 480, 420, 1000, 4, 5, 0, 0),
    ("t10", "easy", "ts", 1, 1, 530, 460, 1150, 4, 5, 0, 0),
    ("t11", "easy", "py", 1, 1, 410, 350, 890, 3, 4, 0, 0),
    ("t12", "easy", "ts", 1, 1, 590, 510, 1280, 5, 6, 0, 0),
    ("t13", "easy", "py", 1, 1, 450, 390, 950, 3, 4, 1, 0),
    ("t14", "easy", "ts", 1, 1, 500, 440, 1050, 4, 5, 0, 0),
    ("t15", "easy", "py", 1, 1, 430, 370, 910, 3, 4, 0, 0),
    ("t16", "easy", "ts", 1, 1, 680, 600, 1400, 5, 6, 0, 0),
    # medium：16 条。A 错 18/23/27/30；B 错 18/22/27。
    ("t17", "medium", "py", 1, 1, 820, 700, 1800, 4, 5, 0, 0),
    ("t18", "medium", "ts", 0, 0, 760, 650, 1650, 4, 5, 1, 0),
    ("t19", "medium", "py", 1, 1, 910, 800, 1950, 5, 6, 0, 0),
    ("t20", "medium", "ts", 1, 1, 880, 770, 1880, 4, 5, 0, 0),
    ("t21", "medium", "py", 1, 1, 1040, 920, 2200, 6, 7, 0, 0),
    ("t22", "medium", "ts", 1, 0, 790, 680, 1700, 4, 5, 0, 1),
    ("t23", "medium", "py", 0, 1, 860, 750, 1850, 5, 6, 0, 0),
    ("t24", "medium", "ts", 1, 1, 970, 860, 2100, 6, 7, 0, 0),
    ("t25", "medium", "py", 1, 1, 830, 720, 1780, 4, 5, 0, 0),
    ("t26", "medium", "ts", 1, 1, 920, 810, 1980, 5, 6, 1, 0),
    ("t27", "medium", "py", 0, 0, 780, 670, 1680, 4, 5, 0, 0),
    ("t28", "medium", "ts", 1, 1, 1010, 890, 2150, 6, 7, 0, 0),
    ("t29", "medium", "py", 1, 1, 870, 760, 1900, 5, 6, 0, 0),
    ("t30", "medium", "ts", 0, 1, 940, 830, 2020, 5, 6, 1, 0),
    ("t31", "medium", "py", 1, 1, 810, 700, 1750, 4, 5, 0, 0),
    ("t32", "medium", "ts", 1, 1, 990, 880, 2120, 6, 7, 0, 0),
    # hard：16 条。A 错 8 条；B 错 9 条（t35 是 B 独有的退化）。
    # 延迟尾部：A 的 P95 由 t48=1700 决定；B 的 P95 由 t48=2600 决定。
    ("t33", "hard", "py", 1, 1, 1420, 1050, 3200, 7, 8, 0, 0),
    ("t34", "hard", "ts", 0, 0, 1380, 1180, 3500, 8, 9, 1, 0),
    ("t35", "hard", "py", 1, 0, 1490, 980, 3100, 6, 7, 0, 1),
    ("t36", "hard", "ts", 0, 0, 1460, 1260, 3650, 9, 10, 0, 0),
    ("t37", "hard", "py", 1, 1, 1450, 1100, 3300, 7, 8, 0, 0),
    ("t38", "hard", "ts", 0, 0, 1500, 1320, 3800, 10, 11, 1, 0),
    ("t39", "hard", "py", 1, 1, 1390, 1140, 3450, 8, 9, 0, 0),
    ("t40", "hard", "ts", 0, 0, 2100, 3200, 4200, 11, 12, 0, 1),
    ("t41", "hard", "py", 1, 1, 1470, 1220, 3250, 7, 8, 0, 0),
    ("t42", "hard", "ts", 0, 0, 1440, 1080, 3550, 9, 10, 0, 0),
    ("t43", "hard", "py", 1, 1, 1480, 1360, 3380, 8, 9, 0, 0),
    ("t44", "hard", "ts", 0, 0, 1800, 3000, 4050, 12, 13, 1, 0),
    ("t45", "hard", "py", 1, 1, 1460, 1160, 3500, 9, 10, 0, 0),
    ("t46", "hard", "ts", 0, 0, 1495, 1300, 3720, 10, 11, 0, 0),
    ("t47", "hard", "py", 1, 1, 1430, 1200, 3420, 8, 9, 1, 0),
    ("t48", "hard", "ts", 0, 0, 1700, 2600, 3900, 11, 12, 0, 0),
)


def load_items() -> list[Item]:
    return [
        Item(
            item_id=r[0], difficulty=r[1], language=r[2],
            a_ok=bool(r[3]), b_ok=bool(r[4]),
            a_ms=r[5], b_ms=r[6], a_cost_micros=r[7],
            a_tools=r[8], b_tools=r[9],
            a_tool_errors=r[10], b_tool_errors=r[11],
        )
        for r in _RAW
    ]


# ---------------------------------------------------------------- 基本统计


def accuracy(flags: Sequence[bool]) -> float:
    return sum(1 for x in flags if x) / len(flags) if flags else 0.0


def wilson_ci(k: int, n: int, z: float = Z95) -> tuple[float, float]:
    """Wilson score 区间。k=成功数，n=样本数，z=双侧正态分位数。"""
    if n <= 0:
        return (0.0, 0.0)
    p = k / n
    denom = 1.0 + z * z / n
    center = (p + z * z / (2.0 * n)) / denom
    half = z * math.sqrt(p * (1.0 - p) / n + z * z / (4.0 * n * n)) / denom
    return (max(0.0, center - half), min(1.0, center + half))


def percentile(values: Sequence[float], q: float, *, nearest_rank: bool = False) -> float:
    """分位数。默认线性插值（type 7）；nearest_rank 用于 SLO 口径的 P95/P99。"""
    if not values:
        return 0.0
    xs = sorted(values)
    if nearest_rank:
        rank = math.ceil(q * len(xs))
        rank = min(max(rank, 1), len(xs))
        return float(xs[rank - 1])
    pos = (len(xs) - 1) * q
    lo = math.floor(pos)
    hi = math.ceil(pos)
    if lo == hi:
        return float(xs[lo])
    return float(xs[lo] + (xs[hi] - xs[lo]) * (pos - lo))


def mean(values: Sequence[float]) -> float:
    return sum(values) / len(values) if values else 0.0


def bootstrap_ci(
    values: Sequence[float],
    stat: Callable[[Sequence[float]], float],
    rng: random.Random,
    n_boot: int = DEFAULT_BOOT,
    alpha: float = 0.05,
) -> tuple[float, float]:
    """百分位 bootstrap 区间：按条目有放回重采样，重算统计量。"""
    n = len(values)
    if n == 0:
        return (0.0, 0.0)
    stats = []
    for _ in range(n_boot):
        sample = [values[rng.randrange(n)] for _ in range(n)]
        stats.append(stat(sample))
    stats.sort()
    return (percentile(stats, alpha / 2), percentile(stats, 1 - alpha / 2))


def paired_bootstrap(
    a_flags: Sequence[bool],
    b_flags: Sequence[bool],
    rng: random.Random,
    n_boot: int = DEFAULT_BOOT,
    alpha: float = 0.05,
) -> tuple[float, tuple[float, float], float]:
    """配对 bootstrap：同一组索引同时重采样 A 与 B，返回 (差值, 区间, 近似 p)。"""
    n = len(a_flags)
    if n == 0:
        return (0.0, (0.0, 0.0), 1.0)
    deltas = []
    for _ in range(n_boot):
        idx = [rng.randrange(n) for _ in range(n)]
        a = sum(1 for i in idx if a_flags[i]) / n
        b = sum(1 for i in idx if b_flags[i]) / n
        deltas.append(b - a)
    deltas.sort()
    observed = accuracy(b_flags) - accuracy(a_flags)
    lo = percentile(deltas, alpha / 2)
    hi = percentile(deltas, 1 - alpha / 2)
    left = sum(1 for d in deltas if d <= 0) / n_boot
    right = sum(1 for d in deltas if d >= 0) / n_boot
    p = min(1.0, 2.0 * min(left, right))
    return (observed, (lo, hi), p)


def mcnemar_exact(b: int, c: int) -> float:
    """McNemar 精确检验（双侧）：b、c 是两个方向的不一致对数。"""
    n = b + c
    if n == 0:
        return 1.0
    k = min(b, c)
    tail = sum(math.comb(n, i) for i in range(k + 1)) / (2 ** n)
    return min(1.0, 2.0 * tail)


def pass_at_k(n: int, c: int, k: int) -> float:
    """无偏 pass@k 估计：1 - C(n-c, k) / C(n, k)。"""
    if not (0 <= c <= n) or not (1 <= k <= n):
        raise ValueError("需要 0 <= c <= n 且 1 <= k <= n")
    if n - c < k:
        return 1.0
    return 1.0 - math.comb(n - c, k) / math.comb(n, k)


def cohens_h(p1: float, p2: float) -> float:
    """两个比例的效应量：h = 2*asin(sqrt(p1)) - 2*asin(sqrt(p2))。"""
    return 2.0 * math.asin(math.sqrt(p1)) - 2.0 * math.asin(math.sqrt(p2))


# ---------------------------------------------------------------- 报表


def system_summary(items: Sequence[Item], system: str, rng: random.Random, n_boot: int) -> dict:
    flags = [getattr(it, f"{system}_ok") for it in items]
    lat = [getattr(it, f"{system}_ms") for it in items]
    cost = [it.a_cost_micros if system == "a" else it.b_cost_micros for it in items]
    tools = [getattr(it, f"{system}_tools") for it in items]
    errs = [getattr(it, f"{system}_tool_errors") for it in items]
    k, n = sum(flags), len(flags)
    acc = k / n
    lo, hi = wilson_ci(k, n)
    boot_lo, boot_hi = bootstrap_ci([1.0 if f else 0.0 for f in flags],
                                    mean, rng, n_boot)
    calls = sum(tools)
    return {
        "n": n,
        "correct": k,
        "accuracy": acc,
        "wilson": [lo, hi],
        "bootstrap": [boot_lo, boot_hi],
        "latency_ms": {
            "mean": mean(lat),
            "p50": percentile(lat, 0.50, nearest_rank=True),
            "p95": percentile(lat, 0.95, nearest_rank=True),
            "p99": percentile(lat, 0.99, nearest_rank=True),
            "max": max(lat),
        },
        "cost_micros": {
            "mean": mean(cost),
            "total": sum(cost),
            "per_success": sum(cost) / k if k else float("inf"),
        },
        "tools": {
            "calls": calls,
            "errors": sum(errs),
            "success_rate": 1.0 - sum(errs) / calls if calls else 0.0,
            "per_item": calls / n,
        },
    }


def paired_summary(items: Sequence[Item], rng: random.Random, n_boot: int) -> dict:
    a = [it.a_ok for it in items]
    b = [it.b_ok for it in items]
    delta, ci, p_boot = paired_bootstrap(a, b, rng, n_boot)
    b_only = sum(1 for it in items if it.b_ok and not it.a_ok)
    a_only = sum(1 for it in items if it.a_ok and not it.b_ok)
    d_lat = mean([it.b_ms for it in items]) - mean([it.a_ms for it in items])
    p95_a = percentile([it.a_ms for it in items], 0.95, nearest_rank=True)
    p95_b = percentile([it.b_ms for it in items], 0.95, nearest_rank=True)
    cost_a = mean([it.a_cost_micros for it in items])
    cost_b = mean([it.b_cost_micros for it in items])
    return {
        "delta": delta,
        "ci": [ci[0], ci[1]],
        "p_bootstrap": p_boot,
        "mcnemar_p": mcnemar_exact(b_only, a_only),
        "b_only": b_only,
        "a_only": a_only,
        "effect_h": cohens_h(accuracy(b), accuracy(a)),
        "latency_delta_ms": d_lat,
        "p95_delta_ms": p95_b - p95_a,
        "cost_delta_ratio": cost_b / cost_a - 1.0,
    }


def strata_table(items: Sequence[Item], key: str) -> list[dict]:
    groups: dict[str, list[Item]] = {}
    for it in items:
        groups.setdefault(getattr(it, key), []).append(it)
    out = []
    for name in sorted(groups):
        rows = groups[name]
        a = sum(1 for it in rows if it.a_ok)
        b = sum(1 for it in rows if it.b_ok)
        out.append({
            "stratum": name,
            "n": len(rows),
            "a_correct": a,
            "b_correct": b,
            "a_accuracy": a / len(rows),
            "b_accuracy": b / len(rows),
            "delta": (b - a) / len(rows),
            "b_only": sum(1 for it in rows if it.b_ok and not it.a_ok),
            "a_only": sum(1 for it in rows if it.a_ok and not it.b_ok),
        })
    return out


def weighted_delta(rows: Sequence[dict], total: int) -> float:
    return sum(r["n"] / total * r["delta"] for r in rows)


def fmt_pct(x: float, digits: int = 1) -> str:
    return f"{x * 100:.{digits}f}%"


def fmt_pp(x: float) -> str:
    return f"{x * 100:+.2f}pp"


def fmt_ci(lo: float, hi: float) -> str:
    return f"[{lo * 100:.1f}%, {hi * 100:.1f}%]"


def print_compare(items: Sequence[Item], a: dict, b: dict, paired: dict) -> None:
    print(f"dataset: {len(items)} items · "
          f"{len({it.difficulty for it in items})} difficulty × "
          f"{len({it.language for it in items})} language")
    print(f"{'system':<7}{'n':>3}{'correct':>9}{'accuracy':>10}"
          f"{'Wilson 95%':>20}{'mean ms':>10}{'P50':>7}{'P95':>7}{'P99':>7}")
    for name, s in (("A", a), ("B", b)):
        lat = s["latency_ms"]
        print(f"{name:<7}{s['n']:>3}{s['correct']:>9}{fmt_pct(s['accuracy']):>10}"
              f"{fmt_ci(*s['wilson']):>20}{lat['mean']:>10.0f}"
              f"{lat['p50']:>7.0f}{lat['p95']:>7.0f}{lat['p99']:>7.0f}")
    print()
    print("paired（同一批 48 条，逐条配对）")
    print(f"  Δaccuracy = {fmt_pp(paired['delta'])}   "
          f"bootstrap 95% CI [{paired['ci'][0] * 100:+.1f}pp, {paired['ci'][1] * 100:+.1f}pp]")
    print(f"  配对不一致：B-only={paired['b_only']}  A-only={paired['a_only']}   "
          f"McNemar 精确 p={paired['mcnemar_p']:.3f}   bootstrap p={paired['p_bootstrap']:.2f}")
    print(f"  效应量 Cohen's h = {paired['effect_h']:+.3f}")
    print(f"  Δmean latency = {paired['latency_delta_ms']:+.0f} ms   "
          f"ΔP95 = {paired['p95_delta_ms']:+.0f} ms   "
          f"Δcost/task = {paired['cost_delta_ratio'] * 100:+.1f}%")
    print(f"  mean cost/task: A ${a['cost_micros']['mean'] / 1e6:.5f}  "
          f"B ${b['cost_micros']['mean'] / 1e6:.5f}")
    print(f"  cost per success: A ${a['cost_micros']['per_success'] / 1e6:.5f}  "
          f"B ${b['cost_micros']['per_success'] / 1e6:.5f}  "
          f"（B/A = {b['cost_micros']['per_success'] / a['cost_micros']['per_success']:.2f}×）")
    gate = (paired["ci"][0] > 0 and paired["p95_delta_ms"] <= 0
            and paired["cost_delta_ratio"] <= 0.10)
    print()
    print("gate: " + ("PASS" if gate else
                     "REJECT（质量差值下界未超过 0；P95 与成本同时变差）"))


def print_strata(items: Sequence[Item], key: str, label: str) -> None:
    rows = strata_table(items, key)
    print(f"stratum by {label}")
    print(f"{'stratum':<10}{'n':>3}{'A acc':>9}{'B acc':>9}{'Δ':>10}"
          f"{'B-only':>8}{'A-only':>8}")
    for r in rows:
        print(f"{r['stratum']:<10}{r['n']:>3}{fmt_pct(r['a_accuracy']):>9}"
              f"{fmt_pct(r['b_accuracy']):>9}{fmt_pp(r['delta']):>10}"
              f"{r['b_only']:>8}{r['a_only']:>8}")
    w = weighted_delta(rows, len(items))
    overall = (sum(1 for it in items if it.b_ok) - sum(1 for it in items if it.a_ok)) / len(items)
    print(f"{'weighted':<10}{len(items):>3}"
          f"{fmt_pct(accuracy([it.a_ok for it in items])):>9}"
          f"{fmt_pct(accuracy([it.b_ok for it in items])):>9}"
          f"{fmt_pp(w):>10}{'':>16}")
    print(f"weighted Δ = {fmt_pp(w)}；总体 Δ = {fmt_pp(overall)}；"
          f"差 {abs(w - overall) * 100:.1f}pp（应为 0）")


def main(argv: Iterable[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="第 9 章：评估统计（48 条配对样本）")
    parser.add_argument("--compare", action="store_true", help="打印 A/B 对比与配对差值")
    parser.add_argument("--strata", action="store_true", help="按难度与语言分层")
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED, help="bootstrap 随机种子")
    parser.add_argument("--boot", type=int, default=DEFAULT_BOOT, help="bootstrap 重采样次数")
    parser.add_argument("--json", action="store_true", help="输出 JSON")
    args = parser.parse_args(list(argv) if argv is not None else None)

    items = load_items()
    rng = random.Random(args.seed)
    a = system_summary(items, "a", rng, args.boot)
    b = system_summary(items, "b", rng, args.boot)
    paired = paired_summary(items, rng, args.boot)

    if args.json:
        payload = {
            "dataset": {"items": len(items), "seed": args.seed, "bootstrap": args.boot},
            "systems": {"A": a, "B": b},
            "paired": paired,
            "strata": {
                "difficulty": strata_table(items, "difficulty"),
                "language": strata_table(items, "language"),
            },
        }
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0

    if args.strata:
        print_strata(items, "difficulty", "difficulty")
        print()
        print_strata(items, "language", "language")
        return 0

    # 默认与 --compare 相同：这两个 flag 都打印完整对比。
    print_compare(items, a, b, paired)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
