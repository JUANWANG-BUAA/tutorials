#!/usr/bin/env python3
"""Run the reviewed chapter-2 exercises, with independent FK and derivative checks.

Requires NumPy, SciPy and Matplotlib. This is a numerical teaching check, not hardware acceptance.
"""
import contextlib
import io
import json
import math
from pathlib import Path
import re
import runpy
import unittest

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

from verify_ch03_jac import chain

ROOT = Path(__file__).resolve().parents[1]
TEXT = (ROOT / "src/ch02/exercises.md").read_text(encoding="utf-8")


def exercise(label, following):
    return TEXT.split("::: ex " + label, 1)[1].split("::: ex " + following, 1)[0]


def execute_blocks(block):
    namespace = {}
    code = "\n".join(re.findall(r"(?:```|~~~)python\n(.*?)(?:```|~~~)", block, re.DOTALL))
    with contextlib.redirect_stdout(io.StringIO()):
        exec(compile(code, "published-exercise", "exec"), namespace)
    return namespace


class ExercisePrograms(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ik = runpy.run_path(str(ROOT / "src/assets/code/ch02-planar-ik.py"))
        cls.calibration = runpy.run_path(str(ROOT / "src/assets/code/ch02-calibration.py"))

    def test_c1_and_c5_all_published_blocks_execute(self):
        axis = execute_blocks(exercise("C1", "C2"))
        self.assertEqual(len(axis["cases"]), 1015)
        self.assertLess(max(axis["maximum"].values()), 1e-12)
        for function in (axis["axis_matrix"], axis["five_steps"]):
            for invalid in ([0, 0, 0], [math.nan, 0, 1], [math.inf, 0, 1], [1, 2]):
                with self.assertRaises(ValueError):
                    function(invalid, 0)
        euler = execute_blocks(exercise("C5", "C6"))
        self.assertIn("other", euler)  # The second published random/branch block ran, too.

    def test_b1_zxz_endpoints_and_b5_second_order_error(self):
        euler = execute_blocks(exercise("C5", "C6"))
        rotation = lambda axis, angle: np.asarray(euler["rotation"](axis, angle))
        for middle in (0, math.pi):
            for first, last in ((0.4, -0.8), (-1.3, 0.7), (2.7, -2.4)):
                original = rotation("z", first) @ rotation("x", middle) @ rotation("z", last)
                representative = math.atan2(original[1, 0], original[0, 0])
                rebuilt = rotation("z", representative) @ rotation("x", middle)
                np.testing.assert_allclose(rebuilt, original, atol=1e-14)
        directions = ((1, 2, -1), (-2, 1, 3))
        errors = []
        for step in (1e-3, 5e-4):
            turns = [[step * value for value in direction] for direction in directions]
            def sequence(values):
                return rotation("x", values[0]) @ rotation("y", values[1]) @ rotation("z", values[2])
            lhs = sequence(turns[0]) @ sequence(turns[1])
            rhs = sequence([a + b for a, b in zip(*turns)])
            errors.append(np.max(np.abs(lhs - rhs)))
        self.assertGreater(errors[0], 1e-7)
        self.assertAlmostEqual(errors[0] / errors[1], 4.0, delta=0.03)

    def test_c4_actual_sampling_code_and_plot(self):
        sampled = execute_blocks(exercise("C4", "C5"))
        self.assertEqual(sampled["sample_count"], 200000)
        self.assertTrue(np.all(np.isfinite(sampled["radius"])))
        self.assertLessEqual(float(np.max(sampled["radius"])), 1.0)
        for index in range(0, 200000, 4096):
            joints = [sampled[name][index] for name in ("first", "second", "third")]
            reference = chain([(0, 0, length, 0, "r") for length in (0.5, 0.3, 0.2)], joints)[-1]
            self.assertAlmostEqual(sampled["horizontal"][index], reference[0][3], places=13)
            self.assertAlmostEqual(sampled["vertical"][index], reference[1][3], places=13)
        self.assertEqual(plt.gca().get_aspect(), 1.0)
        destination = ROOT.parent / "output/playwright/ch02-exercise-c4-sampling.png"
        destination.parent.mkdir(parents=True, exist_ok=True)
        plt.savefig(destination, dpi=150, bbox_inches="tight")
        plt.close("all")

    def test_c6_general_fk_against_elementary_dh_chain(self):
        rng = np.random.default_rng(286)
        for _ in range(60):
            rows, reference, joints = [], [], []
            for kind in ("r", "p", "r", "p"):
                a, alpha, constant, joint = rng.uniform(-1, 1, 4)
                rows.append((a, alpha, constant if kind == "r" else None,
                             None if kind == "r" else constant))
                reference.append((0 if kind == "r" else constant,
                                  constant if kind == "r" else 0, a, alpha, kind))
                joints.append(joint)
            np.testing.assert_allclose(self.ik["fk"](rows, joints), chain(reference, joints)[-1], atol=1e-14)
        with self.assertRaises(ValueError):
            self.ik["fk"]([(1, 0, None, None)], [0])
        with self.assertRaises(ValueError):
            self.ik["fk"]([(1, 0, 0, None)], [])
        with self.assertRaises(ValueError):
            self.ik["fk"]([(1, 0, 0, None)], [math.nan])

    def test_c6_all_returned_branches_against_scalar_fk(self):
        rng = np.random.default_rng(126)
        for lengths in ((1, 1, 0.5), (0.8, 1, 0.3), (1, 0.8, 0)):
            for _ in range(100):
                joints = rng.uniform(-2, 2, 3)
                angles = np.cumsum(joints)
                target = (sum(length * math.cos(angle) for length, angle in zip(lengths, angles)),
                          sum(length * math.sin(angle) for length, angle in zip(lengths, angles)), angles[-1])
                kind, solutions = self.ik["planar_ik"](lengths, target)
                self.assertEqual(kind, "finite")
                self.assertIn(len(solutions), (1, 2))
                for solution in solutions:
                    cumulative = np.cumsum(solution)
                    actual = (sum(length * math.cos(angle) for length, angle in zip(lengths, cumulative)),
                              sum(length * math.sin(angle) for length, angle in zip(lengths, cumulative)))
                    np.testing.assert_allclose(actual, target[:2], atol=1e-12)
                    self.assertAlmostEqual(self.ik["wrap"](cumulative[-1] - target[2]), 0, places=12)
        self.assertEqual(self.ik["planar_ik"]((1, 1, 0.5), (0.5, 0, 0))[0], "family")
        self.assertEqual(self.ik["planar_ik"]((1, 0.8, 0.5), (0.5, 0, 0))[0], "none")
        with contextlib.redirect_stdout(io.StringIO()) as output:
            self.ik["main"]()
        self.assertEqual(json.loads(output.getvalue())["random_targets"], 100)

    def test_d1_actual_boundary_program_and_continuous_families(self):
        boundary = execute_blocks(exercise("D1", "D2"))["boundary_positions"]
        def position(a2, a3, angles):
            return np.asarray(chain([(0, 0, 0, math.pi / 2, "r"),
                                     (0, 0, a2, 0, "r"), (0, 0, a3, 0, "r")], angles)[-1])[:3, 3]
        for a2, a3 in ((0.5, 0.3), (0.3, 0.5)):
            for radius in (a2 + a3, abs(a2 - a3)):
                target = (0.8 * radius, 0, 0.6 * radius)
                kind, solutions = boundary(a2, a3, target)
                self.assertEqual(kind, "finite")
                self.assertEqual(len(solutions), 2)
                for solution in solutions:
                    np.testing.assert_allclose(position(a2, a3, solution), target, atol=1e-14)
                for z in (-radius, radius):
                    kind, solutions = boundary(a2, a3, (0, 0, z))
                    self.assertEqual(kind, "one_parameter")
                    for first in (-2.2, 0, 1.7):
                        _, second, third = solutions[0]
                        np.testing.assert_allclose(position(a2, a3, (first, second, third)), (0, 0, z), atol=1e-14)
        self.assertEqual(boundary(1, 1, (0, 0, 0))[0], "two_parameters")
        self.assertEqual(boundary(1, 1, (1e-14, 0, 0))[0], "not_boundary")
        for first in (-2, 0.1, 1.5):
            for second in (-1.3, 0, 2.2):
                np.testing.assert_allclose(position(1, 1, (first, second, math.pi)), 0, atol=1e-14)
        self.assertEqual(boundary(0.5, 0.3, (0.5, 0, 0.3))[0], "not_boundary")
        # The four explicitly printed boundary examples must each reconstruct its own target.
        block = exercise("D1", "D2")
        examples = re.findall(r"\((0|\\pi),(0|\\pi),(0|\\pi)\)", block)
        self.assertEqual(len(examples), 4)
        for values, target in zip(examples, ((0.8, 0, 0),) * 2 + ((0.2, 0, 0),) * 2):
            solution = [0 if value == "0" else math.pi for value in values]
            np.testing.assert_allclose(position(0.5, 0.3, solution), target, atol=1e-14)

    def test_d2_actual_sensitivity_and_covariance(self):
        model = self.calibration
        rng = np.random.default_rng(211)
        joints = rng.uniform([-1.5, -2], [1.5, 2], (60, 2))
        parameters = model["TRUTH"]
        derivative = model["sensitivity"](parameters, joints)
        numeric = np.empty_like(derivative)
        for column in range(3):
            plus, minus = parameters.copy(), parameters.copy()
            plus[column] += 1e-6
            minus[column] -= 1e-6
            numeric[:, column] = ((model["predict"](plus, joints) - model["predict"](minus, joints)) / 2e-6).ravel()
        np.testing.assert_allclose(derivative, numeric, atol=4e-10)
        for index, angles in enumerate(joints):
            reference = chain([(0, 0, parameters[0], 0, "r"), (0, 0, parameters[1], 0, "r")],
                              [angles[0] + parameters[2], angles[1]])[-1]
            np.testing.assert_allclose(model["predict"](parameters, joints)[index], np.asarray(reference)[:2, 3], atol=1e-14)
        reference_covariance = model["SIGMA"] ** 2 * np.linalg.solve(derivative.T @ derivative, np.eye(3))
        np.testing.assert_allclose(model["local_covariance"](parameters, joints), reference_covariance, rtol=1e-12, atol=1e-20)

    def test_d2_actual_iteration_rank_noise_and_validation(self):
        with contextlib.redirect_stdout(io.StringIO()) as output:
            self.calibration["main"]()
        report = json.loads(output.getvalue())
        np.testing.assert_allclose(report["noiseless_estimate"], report["truth_m_m_rad"], atol=1e-10)
        self.assertGreater(report["iterations"], 1)
        self.assertEqual(report["wide_rank_condition"][0], 3)
        self.assertLess(report["wide_rank_condition"][1], 3)
        self.assertEqual(report["narrow_rank_condition"][0], 3)
        self.assertGreater(report["narrow_rank_condition"][1], 1000)
        self.assertEqual(set(report["rejected"]), {"one_pose", "same_second_angle"})
        self.assertLess(report["validation_rms_m"], self.calibration["SIGMA"])
        self.assertTrue(all(0.7 < ratio < 1.3 for ratio in report["empirical_to_local_ratio"]))

    def test_d4_scara_pose_reconstruction_and_singular_input(self):
        rng = np.random.default_rng(234)
        a1, a2, d4 = 0.7, 0.5, -0.1
        for _ in range(100):
            q1, q2, d3, q4 = rng.uniform(-2, 2, 4)
            target = np.asarray(chain([(0, 0, a1, 0, "r"), (0, 0, a2, 0, "r"),
                                       (0, 0, 0, 0, "p"), (0, d4, 0, 0, "r")], (q1, q2, d3, q4))[-1])
            phi = math.atan2(target[1, 0], target[0, 0])
            kind, solutions = self.ik["planar_ik"]((a1, a2, 0), (target[0, 3], target[1, 3], phi))
            self.assertEqual(kind, "finite")
            for first, second, last in solutions:
                reconstructed = self.ik["fk"]([(a1, 0, 0, None), (a2, 0, 0, None),
                                               (0, 0, None, 0), (0, 0, d4, None)],
                                              (first, second, target[2, 3] - d4, last))
                np.testing.assert_allclose(reconstructed, target, atol=1e-12)
        self.assertEqual(self.ik["planar_ik"]((1, 1, 0), (0, 0, 0))[0], "family")


if __name__ == "__main__":
    unittest.main(verbosity=2)
