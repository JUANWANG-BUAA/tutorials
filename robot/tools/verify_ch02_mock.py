#!/usr/bin/env python3
"""Recompute chapter-2 exam answers and check the stated DH branch boundaries."""
import contextlib
from fractions import Fraction
import io
import math
from pathlib import Path
import random
import re
import unittest

from verify_ch03_jac import (
    ANTHRO_DH, STANFORD_DH, analytic_geometric, chain, cross, mat_mul,
    numeric_jp,
)
from verify_teaching_examples import planar_fk

SOURCE = Path(__file__).resolve().parents[1] / "src"
TEXT = (SOURCE / "ch02/mock-exam.md").read_text(encoding="utf-8")


def matrix(body):
    return [[float(Fraction(value.strip())) for value in row.split("&")]
            for row in body.split(r"\\")]


def maximum_error(first, second):
    if len(first) != len(second) or any(len(row) != len(other) for row, other in zip(first, second)):
        raise ValueError("Compared matrices must have the same shape")
    return max(abs(a - b) for row, other in zip(first, second) for a, b in zip(row, other))


def spherical_arm_candidates(target, offset):
    """Exam 20 equations, checked below against independent standard-DH products."""
    x, y, z = target
    radius = math.hypot(x, y)
    if radius < offset - 1e-14:
        return []
    if radius == 0:
        return []  # Axis families are tested separately with their free first angle.
    root = math.sqrt(max(0, radius * radius - offset * offset))
    candidates = []
    for radial in ((root, -root) if root > 1e-14 else (0,)):
        extension = math.hypot(radial, z)
        if extension > 0:
            candidates.append((math.atan2(y, x) - math.atan2(offset, radial),
                               math.atan2(radial, z), extension))
    return candidates


class ExamAnswers(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        exercises = (SOURCE / "ch02/exercises.md").read_text(encoding="utf-8")
        block = exercises.split("::: ex C5", 1)[1].split("::: ex C6", 1)[0]
        cls.euler = {}
        with contextlib.redirect_stdout(io.StringIO()):
            exec("\n".join(re.findall(r"```python\n(.*?)```", block, re.S)), cls.euler)

    def test_exam16_published_matrices_and_image(self):
        block = TEXT.split("**16.（1）**", 1)[1].split("**17.（1）**", 1)[0]
        scaled = []
        for divisor, body in re.findall(r"\\frac1([39])\\begin\{bmatrix\}([-0-9.&\\\s]+?)\\end\{bmatrix\}", block):
            scaled.append([[value / int(divisor) for value in row] for row in matrix(body)])
        square_matrices = [value for value in scaled if len(value[0]) == 3]
        skew, squared, rotation = square_matrices[0], square_matrices[1], square_matrices[-1]
        self.assertLess(maximum_error(mat_mul(skew, skew), squared), 1e-14)
        # Build the reference by rotating each coordinate axis, using Rodrigues' vector formula.
        axis = [2/3, 2/3, 1/3]
        reference = [[axis[row] * axis[column] + cross(axis, [float(i == column) for i in range(3)])[row]
                      for column in range(3)] for row in range(3)]
        self.assertLess(maximum_error(rotation, reference), 1e-14)
        image = mat_mul(rotation, [[1], [2], [2]])
        self.assertLess(maximum_error(image, scaled[-1]), 1e-14)
        self.assertAlmostEqual(sum(rotation[i][i] for i in range(3)), 1)

    def test_exam17_published_two_branches_and_rounding(self):
        rows = re.findall(r"\| \$s_2([<>])0\$ \| ([−\d.]+) \| ([−\d.]+) \| ([−\d.]+) \|", TEXT)
        self.assertEqual(len(rows), 2)
        wx, wy = .6 - .2 * math.cos(math.pi / 6), .2
        cosine = (wx * wx + wy * wy - .5**2 - .4**2) / .4
        published = float(re.search(r"c_2=.*?\\approx(-[\d.]+)", TEXT, re.S).group(1).rstrip(","))
        self.assertAlmostEqual(published, cosine, places=8)
        for sign, *values in rows:
            degrees = [float(value.replace("−", "-")) for value in values]
            angles = [math.radians(value) for value in degrees]
            sine = math.copysign(math.sqrt(1 - cosine * cosine), 1 if sign == ">" else -1)
            exact_second = math.atan2(sine, cosine)
            exact_first = math.atan2(wy, wx) - math.atan2(.4 * sine, .5 + .4 * cosine)
            exact = [exact_first, exact_second, math.pi / 6 - exact_first - exact_second]
            for printed, expected in zip(degrees, exact):
                self.assertLessEqual(abs(printed - math.degrees(expected)), .005)
            x, y, orientation = planar_fk([.5, .4, .2], angles)
            self.assertLess(math.hypot(x - .6, y - .3), .0001)
            self.assertAlmostEqual(orientation, math.pi / 6, places=12)

    def test_exam18_published_velocity_and_singular_directions(self):
        block = TEXT.split("**18.（1）**", 1)[1].split("## 第四部分", 1)[0]
        published_j = matrix(re.search(r"=\\begin\{bmatrix\}(-1\.300.*?0\.000)\\end\{bmatrix\}", block, re.S).group(1))
        model = [(0, 0, 1, 0, "r"), (0, 0, .8, 0, "r")]
        angles = [math.pi / 6, math.pi / 3]
        numeric = numeric_jp(lambda q: [chain(model, q)[-1][i][3] for i in range(3)], angles)
        reference = [[numeric[column][row] for column in range(2)] for row in range(2)]
        self.assertLess(maximum_error(published_j, reference), .00005)
        vectors = re.search(r"\\dot q\\approx\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}.*?\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", block, re.S)
        precise, rounded = [matrix(value) for value in vectors.groups()]
        for velocity, tolerance in ((precise, 1e-8), (rounded, .0003)):
            actual = mat_mul(reference, velocity)
            self.assertLess(maximum_error(actual, [[.1], [-.05]]), tolerance)
            self.assertTrue(all(abs(row[0]) <= 2 for row in velocity))
        for second in (0, math.pi):
            linear, _ = analytic_geometric(model, [0, second])
            self.assertAlmostEqual(linear[0][0], 0)
            self.assertAlmostEqual(linear[1][0], 0)
            self.assertGreater(abs(linear[0][1]), 0)

    def test_exam14_point_shift_against_center_position_differences(self):
        rng = random.Random(214)
        center_model = list(STANFORD_DH)
        center_model[-1] = (0, 0, 0, 0, "r")
        for _ in range(30):
            joints = [rng.uniform(-2, 2) for _ in range(6)]
            joints[2] = rng.uniform(.2, .8)
            tip = chain(STANFORD_DH, joints)[-1]
            center = chain(center_model, joints)[-1]
            offset = [tip[i][3] - center[i][3] for i in range(3)]
            linear, angular = analytic_geometric(STANFORD_DH, joints)
            numeric = numeric_jp(lambda q: [chain(center_model, q)[-1][i][3] for i in range(3)], joints)
            for column in range(6):
                shifted = [linear[column][i] + cross(offset, angular[column])[i] for i in range(3)]
                for actual, expected in zip(shifted, numeric[column]):
                    self.assertAlmostEqual(actual, expected, places=8)
            self.assertLess(max(abs(value) for column in numeric[3:] for value in column), 1e-9)

    def test_exam19_shoulder_axis_keeps_angular_column(self):
        linear, angular = analytic_geometric(ANTHRO_DH, [.4, math.pi / 2, 0])
        self.assertLess(max(abs(value) for value in linear[0]), 1e-14)
        self.assertEqual(angular[0], [0, 0, 1])

    def test_exam20_all_normal_candidates_rebuild_complete_dh_pose(self):
        rng = random.Random(220)
        for _ in range(100):
            joints = [rng.uniform(-2, 2) for _ in range(6)]
            joints[1] = rng.uniform(.2, 2.8)
            joints[2] = rng.uniform(.2, .8)
            joints[4] = rng.uniform(.2, 2.8)
            target = chain(STANFORD_DH, joints)[-1]
            wrist = [target[i][3] - .1 * target[i][2] for i in range(3)]
            arms = spherical_arm_candidates(wrist, .2)
            self.assertEqual(len(arms), 2)
            for arm in arms:
                base = chain(STANFORD_DH[:3], arm)[-1]
                relative = [[sum(base[k][row] * target[k][column] for k in range(3))
                             for column in range(3)] for row in range(3)]
                angles, _, regular = self.euler["euler_inverse"]("zyz", relative)
                self.assertTrue(regular)
                first, middle, last = angles
                for wrist_angles in (angles, (first + math.pi, -middle, last + math.pi)):
                    actual = chain(STANFORD_DH, (*arm, *wrist_angles))[-1]
                    self.assertLess(maximum_error(actual, target), 1e-12)

    def test_exam20_boundary_axis_and_wrist_families(self):
        self.assertEqual(spherical_arm_candidates((.1, 0, .4), .2), [])
        boundary = spherical_arm_candidates((.2, 0, .4), .2)
        self.assertEqual(len(boundary), 1)
        for arm in boundary:
            actual = chain(STANFORD_DH[:3], arm)[-1]
            self.assertLess(maximum_error([[actual[i][3]] for i in range(3)], [[.2], [0], [.4]]), 1e-14)
        axis_model = list(STANFORD_DH[:3])
        axis_model[1] = (0, 0, 0, math.pi / 2, "r")
        for height in (-.4, .4):
            for first in (-2, 0, 1.7):
                actual = chain(axis_model, [first, 0 if height > 0 else math.pi, abs(height)])[-1]
                self.assertLess(maximum_error([[actual[i][3]] for i in range(3)], [[0], [0], [height]]), 1e-14)
        for middle in (0, math.pi):
            original = self.euler["euler_forward"]("zyz", .4, middle, -.8)
            combined = -.4 if middle == 0 else 1.2
            for first in (-2, -.1, 1.7):
                last = combined - first if middle == 0 else first - combined
                actual = self.euler["euler_forward"]("zyz", first, middle, last)
                self.assertLess(maximum_error(original, actual), 1e-14)


if __name__ == "__main__":
    unittest.main(verbosity=2)
