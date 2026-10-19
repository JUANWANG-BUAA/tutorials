#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 9 章实验的单元测试（纯标准库）。

运行：
    python3 -m unittest discover -s experiments/ch09 -v
"""

from __future__ import annotations

import math
import pathlib
import random
import sys
import unittest

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

import eval_stats as es  # noqa: E402


class FormulaTest(unittest.TestCase):
    def test_wilson_known_values(self) -> None:
        # 8/10 的 Wilson 95% 区间是教科书常用值。
        lo, hi = es.wilson_ci(8, 10)
        self.assertAlmostEqual(lo, 0.4902, places=4)
        self.assertAlmostEqual(hi, 0.9433, places=4)

        # 0/20 与 20/20 都不退化，且关于 0.5 对称。
        lo0, hi0 = es.wilson_ci(0, 20)
        lo1, hi1 = es.wilson_ci(20, 20)
        self.assertEqual(lo0, 0.0)
        self.assertAlmostEqual(hi0, 0.1611, places=4)
        self.assertAlmostEqual(lo1, 1.0 - hi0, places=4)
        self.assertEqual(hi1, 1.0)

    def test_wilson_is_tighter_with_more_samples(self) -> None:
        wide = es.wilson_ci(30, 48)
        narrow = es.wilson_ci(300, 480)
        self.assertLess(narrow[1] - narrow[0], wide[1] - wide[0])

    def test_pass_at_k_known_values(self) -> None:
        # n=10, c=2, k=5：1 - C(8,5)/C(10,5) = 1 - 56/252。
        self.assertAlmostEqual(es.pass_at_k(10, 2, 5), 1 - 56 / 252, places=10)
        self.assertEqual(es.pass_at_k(5, 0, 2), 0.0)
        self.assertEqual(es.pass_at_k(5, 1, 5), 1.0)
        self.assertEqual(es.pass_at_k(10, 10, 3), 1.0)

    def test_pass_at_k_monotone_in_k(self) -> None:
        values = [es.pass_at_k(20, 4, k) for k in range(1, 21)]
        self.assertEqual(values, sorted(values))
        self.assertLessEqual(values[-1], 1.0)

    def test_p95_nearest_rank(self) -> None:
        self.assertEqual(es.percentile(range(1, 101), 0.95, nearest_rank=True), 95.0)
        self.assertEqual(es.percentile(range(1, 49), 0.95, nearest_rank=True), 46.0)
        self.assertEqual(es.percentile(range(1, 49), 0.99, nearest_rank=True), 48.0)
        self.assertEqual(es.percentile(range(1, 49), 0.50, nearest_rank=True), 24.0)

    def test_mcnemar_exact(self) -> None:
        self.assertEqual(es.mcnemar_exact(4, 3), 1.0)
        self.assertEqual(es.mcnemar_exact(0, 0), 1.0)
        # b=10, c=2：2 * P(X<=2 | n=12, p=0.5) = 2 * 79/4096。
        self.assertAlmostEqual(es.mcnemar_exact(10, 2), 2 * 79 / 4096, places=10)

    def test_cohens_h(self) -> None:
        self.assertAlmostEqual(es.cohens_h(0.5, 0.5), 0.0, places=12)
        self.assertGreater(es.cohens_h(0.8, 0.5), 0.6)
        self.assertLess(es.cohens_h(0.5, 0.8), 0.0)


class DatasetTest(unittest.TestCase):
    def setUp(self) -> None:
        self.items = es.load_items()

    def test_dataset_shape(self) -> None:
        self.assertEqual(len(self.items), 48)
        self.assertEqual({it.difficulty for it in self.items}, {"easy", "medium", "hard"})
        self.assertEqual({it.language for it in self.items}, {"py", "ts"})
        self.assertEqual(len({it.item_id for it in self.items}), 48)

    def test_accuracy_and_delta(self) -> None:
        a = es.accuracy([it.a_ok for it in self.items])
        b = es.accuracy([it.b_ok for it in self.items])
        self.assertAlmostEqual(a, 35 / 48, places=12)
        self.assertAlmostEqual(b, 36 / 48, places=12)
        # 配对差值必须等于不一致对的净差，而不是两个独立比例的差。
        self.assertAlmostEqual(b - a, 1 / 48, places=12)

    def test_paired_counts(self) -> None:
        paired = es.paired_summary(self.items, random.Random(1), 200)
        self.assertEqual(paired["b_only"], 3)
        self.assertEqual(paired["a_only"], 2)
        self.assertAlmostEqual(paired["delta"], (3 - 2) / 48, places=12)

    def test_cost_ratio_is_constructed(self) -> None:
        total_a = sum(it.a_cost_micros for it in self.items)
        total_b = sum(it.b_cost_micros for it in self.items)
        self.assertAlmostEqual(total_b / total_a, 1.18, places=3)

    def test_stratified_weights_match_overall(self) -> None:
        for key in ("difficulty", "language"):
            rows = es.strata_table(self.items, key)
            self.assertEqual(sum(r["n"] for r in rows), 48)
            weighted = es.weighted_delta(rows, 48)
            overall = (sum(1 for it in self.items if it.b_ok)
                       - sum(1 for it in self.items if it.a_ok)) / 48
            self.assertAlmostEqual(weighted, overall, places=12)

    def test_hard_stratum_regresses(self) -> None:
        rows = {r["stratum"]: r for r in es.strata_table(self.items, "difficulty")}
        self.assertAlmostEqual(rows["hard"]["delta"], -1 / 16, places=12)
        self.assertGreater(rows["easy"]["delta"], 0)

    def test_mean_improves_but_tail_worsens(self) -> None:
        # 这是本章 9.8 的核心例子：B 的平均延迟更低，P95 明显更高。
        a = [it.a_ms for it in self.items]
        b = [it.b_ms for it in self.items]
        self.assertLess(es.mean(b), es.mean(a))
        self.assertGreater(
            es.percentile(b, 0.95, nearest_rank=True),
            es.percentile(a, 0.95, nearest_rank=True) + 500,
        )

    def test_summary_reproducible_with_seed(self) -> None:
        one = es.system_summary(self.items, "a", random.Random(7), 500)
        two = es.system_summary(self.items, "a", random.Random(7), 500)
        self.assertEqual(one, two)

        p1 = es.paired_summary(self.items, random.Random(7), 500)
        p2 = es.paired_summary(self.items, random.Random(7), 500)
        self.assertEqual(p1, p2)

        p3 = es.paired_summary(self.items, random.Random(8), 500)
        self.assertNotEqual(p1["ci"], p3["ci"])

    def test_wilson_contains_point_estimate(self) -> None:
        s = es.system_summary(self.items, "b", random.Random(3), 200)
        self.assertLess(s["wilson"][0], s["accuracy"])
        self.assertGreater(s["wilson"][1], s["accuracy"])
        self.assertTrue(math.isfinite(s["cost_micros"]["per_success"]))


if __name__ == "__main__":
    unittest.main()
