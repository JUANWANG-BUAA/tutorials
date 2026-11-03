#!/usr/bin/env python3
"""Recompute reviewed DL examples with the Python standard library only.

Run: python3 deeplearning/tools/verify_teaching_examples.py
Scope: scoring rules, smoothing, risk gaps, KL and gradient-estimator examples;
plus the first review's shared gradient, attention and receptive-field examples.
Monte Carlo is a seeded diagnostic, not a proof or a machine-speed benchmark.
"""

import math
from pathlib import Path
import random
import statistics
import unittest

SOURCE = Path(__file__).resolve().parents[1] / "src"


def softmax(values):
    """Normalize scores using a common shift for numerical stability."""
    shifted = [math.exp(value - max(values)) for value in values]
    total = sum(shifted)
    return [value / total for value in shifted]


def gaussian_kl(mean, variance):
    """Return one-dimensional KL(N(mean, variance) || N(0, 1))."""
    return (mean ** 2 + variance - 1 - math.log(variance)) / 2


class TeachingExamples(unittest.TestCase):
    def test_brier_risk_and_logit_gradients(self):
        r = 0.8
        for p, expected in ((0.8, 0.16), (0.5, 0.25), (1, 0.2)):
            risk = r * (p - 1) ** 2 + (1 - r) * p ** 2
            self.assertAlmostEqual(risk, expected)
            self.assertAlmostEqual(risk, (p - r) ** 2 + r * (1 - r))
        self.assertAlmostEqual(2 * (0.01 - 1) * 0.01 * 0.99, -0.019602)

    def test_smoothed_ce_can_increase_or_decrease(self):
        logits = (2, 1, 0.1)
        p = softmax(logits)
        ce = -math.log(p[1])
        smoothed = -sum(((0.9 if i == 1 else 0) + 0.1 / 3) * math.log(pi)
                        for i, pi in enumerate(p))
        self.assertAlmostEqual(ce, 1.4170300163, places=9)
        self.assertAlmostEqual(smoothed, 1.4136966829, places=9)
        self.assertLess(smoothed, ce)
        self.assertGreater(-sum(((0.9 if i == 0 else 0) + 0.1 / 3) * math.log(pi)
                                for i, pi in enumerate(p)), -math.log(p[0]))

    def test_risk_telescope_and_dropout(self):
        approximation, estimation = 0.15 - 0.1, 0.3 - 0.15
        for empirical, population in ((0.08, 0.24), (0.06, 0.28)):
            self.assertAlmostEqual(approximation + estimation + population - 0.3,
                                   population - 0.1)
            self.assertGreaterEqual(empirical - 0.05, 0)
            self.assertLess(population - 0.3, 0)
        self.assertAlmostEqual(0.7 ** -8, 17.3466525557, places=9)

    def test_each_gaussian_kl_dimension(self):
        first, second = gaussian_kl(1, 0.25), gaussian_kl(-0.5, 4)
        self.assertAlmostEqual(first, 0.8181471806, places=9)
        self.assertAlmostEqual(second, 0.9318528194, places=9)
        self.assertAlmostEqual(first + second, 1.75)
        self.assertAlmostEqual(gaussian_kl(-0.5, 2), 0.2784264097, places=9)
        self.assertEqual(gaussian_kl(0, 1), 0)
        for mean in (-10, -0.5, 0, 1):
            for logvar in (-10, -2, 0, 2, 10):
                self.assertGreaterEqual(gaussian_kl(mean, math.exp(logvar)), 0)
        self.assertAlmostEqual(0.36 / 2 + first + second, 1.93)
        self.assertEqual((0.36 / 2) / (0.36 / 4 / 2), 4)

    def test_kl_monte_carlo_reports_standard_error(self):
        rng = random.Random(2026)
        values = []
        for _ in range(65536):
            value = 0
            for mean, variance in ((1, 0.25), (-0.5, 4)):
                eps = rng.gauss(0, 1)
                z = mean + math.sqrt(variance) * eps
                value += 0.5 * (z * z - eps * eps - math.log(variance))
            values.append(value)
        estimate = statistics.mean(values)
        error = statistics.stdev(values) / math.sqrt(len(values))
        print(f"KL MC diagnostic: {estimate:.6f}; SE={error:.6f}; exact=1.750000")
        # Broad fixed-seed regression criterion, not a guarantee for arbitrary runs.
        self.assertLess(abs(estimate - 1.75), 6 * error)
        self.assertLess(min(values), 0)  # An integrand draw can be negative.

    def test_path_variance_counterexample(self):
        # Gaussian characteristic function yields exact moments for f=sin(a z).
        a = 10
        mean = a * math.exp(-a * a / 2)
        path_var = a * a * (1 + math.exp(-2 * a * a)) / 2 - mean ** 2
        score_var = (1 - (1 - 4 * a * a) * math.exp(-2 * a * a)) / 2 - mean ** 2
        self.assertAlmostEqual(path_var, 50)
        self.assertAlmostEqual(score_var, 0.5)
        self.assertGreater(path_var, score_var)

    def test_first_review_shared_attention_and_receptive_fields(self):
        self.assertEqual((3 * 1 - 1) * 3, 6)
        self.assertAlmostEqual((3 * 0.4 - 1) ** 2 / 2, 0.02)
        weights = softmax((0, 1 / math.sqrt(2), -math.inf))
        self.assertAlmostEqual(weights[0], 0.33023845, places=7)
        self.assertAlmostEqual(weights[0] * 1 + weights[1] * 3, 2.3395231, places=7)
        self.assertEqual(weights[2], 0)
        for kernel, expected in ((3, 156), (5, 280)):
            receptive, jump = 1, 1
            for _ in range(5):
                for size, stride in ((kernel, 1), (kernel, 1), (2, 2)):
                    receptive += (size - 1) * jump
                    jump *= stride
            self.assertEqual(receptive, expected)
            self.assertEqual(jump, 32)

    def test_published_example_markers(self):
        for file, markers in {
            "lectures/lec01/sec14.md": ("ex-1.4.A", "0.019602"),
            "lectures/lec01/sec17.md": ("ex-1.7.A", "17.35", "2\\delta"),
            "lectures/lec04/sec43.md": ("0.931853", "0.278426", "逐维核对"),
        }.items():
            text = (SOURCE / file).read_text()
            for marker in markers:
                self.assertIn(marker, text, file)


if __name__ == "__main__":
    unittest.main(verbosity=2)
