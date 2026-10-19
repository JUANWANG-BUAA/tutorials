"""统计函数的回归测试。"""
from __future__ import annotations

import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from evalplat.stats import (  # noqa: E402
    bootstrap_ci, mean, paired_bootstrap_diff, pass_at_k, percentile, wilson_interval,
)


class StatsTest(unittest.TestCase):
    def test_wilson_contains_point(self):
        ci = wilson_interval(8, 10)
        self.assertLessEqual(ci.low, 0.8)
        self.assertGreaterEqual(ci.high, 0.8)

    def test_wilson_extremes(self):
        self.assertEqual(wilson_interval(0, 10).low, 0.0)
        self.assertAlmostEqual(wilson_interval(10, 10).high, 1.0)

    def test_bootstrap_reproducible(self):
        xs = [1, 0, 1, 1, 0, 1, 0, 1]
        a = bootstrap_ci(xs, seed=7)
        b = bootstrap_ci(xs, seed=7)
        self.assertEqual((a.low, a.high), (b.low, b.high))

    def test_percentile(self):
        self.assertEqual(percentile([1, 2, 3, 4], 50), 2.5)
        self.assertEqual(percentile([1], 95), 1)

    def test_paired_diff(self):
        base = [0, 0, 1, 0]
        cand = [1, 1, 1, 0]
        delta, ci = paired_bootstrap_diff(base, cand, seed=1)
        self.assertAlmostEqual(delta, 0.5)
        self.assertLessEqual(ci.low, delta)
        self.assertGreaterEqual(ci.high, delta)

    def test_pass_at_k(self):
        self.assertAlmostEqual(pass_at_k(10, 8, 1), 0.8)
        self.assertAlmostEqual(pass_at_k(10, 8, 2), 1 - (2 * 1) / (10 * 9))
        self.assertEqual(pass_at_k(10, 0, 1), 0.0)
        self.assertEqual(pass_at_k(10, 10, 3), 1.0)

    def test_mean_empty(self):
        with self.assertRaises(ValueError):
            mean([])


if __name__ == "__main__":
    unittest.main(verbosity=2)
