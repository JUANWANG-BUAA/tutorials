#!/usr/bin/env python3
"""Recompute reviewed teaching examples using only the Python standard library.

Run from any directory: python3 robot/tools/verify_teaching_examples.py
Scope: revised coordinate, Jacobian, gravity, IK, trajectory and gear examples
(rounds 1-2), plus the chapter-6 (dynamics) exercises, mock exam and structure
checks added in round 3.
This checks specific published examples, not every formula in the book.
"""

import math
import re
import contextlib
import io
import random
from fractions import Fraction
from pathlib import Path
import unittest
import xml.etree.ElementTree as ElementTree

SOURCE = Path(__file__).resolve().parents[1] / "src"


def integral_square(coefficients):
    """Integrate a polynomial squared on [0, 1], exactly for rational inputs."""
    return sum(a * b / Fraction(i + j + 1)
               for i, a in enumerate(coefficients)
               for j, b in enumerate(coefficients))


def planar_fk(lengths, angles):
    """Return planar end position and cumulative orientation."""
    x = y = angle = 0.0
    for length, joint in zip(lengths, angles):
        angle += joint
        x += length * math.cos(angle)
        y += length * math.sin(angle)
    return x, y, angle


class WorkspaceTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-10.md").read_text(encoding="utf-8")

    def test_published_two_link_formulas_and_radial_limits(self):
        horizontal = re.search(r"p_x=([^,]+),\\qquad", self.section).group(1)
        vertical = re.search(r"p_y=([^.]*)\.\$\$", self.section).group(1).strip()
        radius_squared = re.search(r"\\rho\^2=p_x\^2\+p_y\^2=([^$]+)\$\$", self.section).group(1)
        generator = random.Random(210)
        for unused in range(120):
            first, second = [generator.uniform(-math.pi, math.pi) for index in range(2)]
            values = {r"\cos q_1": math.cos(first), r"\sin q_1": math.sin(first),
                      r"\cos(q_1+q_2)": math.cos(first + second),
                      r"\sin(q_1+q_2)": math.sin(first + second),
                      r"\cos q_2": math.cos(second), "a_1": 1, "a_2": .6}
            evaluate = QuaternionTeachingChecks.evaluate_matrix
            actual = evaluate(horizontal + r"\\" + vertical, values)
            expected = planar_fk([1, .6], [first, second])[:2]
            for row, target in zip(actual, expected):
                self.assertAlmostEqual(row[0], target, places=12)
            expanded = radius_squared.replace("a_1^2", "1").replace("a_2^2", ".36")
            expanded = expanded.replace("2a_1a_2", "1.2")
            self.assertAlmostEqual(evaluate(expanded, values)[0][0],
                                   sum(value * value for value in expected), places=12)
        for degrees, published in [(150, .5664), (30, 1.5489)]:
            endpoint = planar_fk([1, .6], [.7, math.radians(degrees)])
            self.assertAlmostEqual(math.hypot(*endpoint[:2]), published, places=4)
            self.assertIn(str(published), self.section)

    def test_published_self_motion_table_and_continuous_path(self):
        block = self.section.split("{#ex-2.10.self}", 1)[1].split("::: think", 1)[0]
        rows = re.findall(r"\| \$([-\d.]+)°\$ \| \$([-\d.]+)°\$ \| "
                          r"\$([-\d.]+)°\$ \| \$([-\d.]+)°\$", block)
        self.assertEqual(len(rows), 2)
        for orientation, first, second, third in rows:
            angles = [math.radians(float(value)) for value in [first, second, third]]
            actual = planar_fk([1, 1, .5], angles)
            self.assertAlmostEqual(actual[0], 1, places=5)
            self.assertAlmostEqual(actual[1], 0, places=5)
            self.assertAlmostEqual(actual[2], math.radians(float(orientation)), places=5)
        for index in range(181):
            orientation = index * math.pi / 360
            wrist = [1 - .5 * math.cos(orientation), -.5 * math.sin(orientation)]
            cosine = (sum(value * value for value in wrist) - 2) / 2
            second = math.acos(cosine)
            first = math.atan2(wrist[1], wrist[0]) - second / 2
            actual = planar_fk([1, 1, .5], [first, second, orientation - first - second])
            self.assertAlmostEqual(actual[0], 1, places=12)
            self.assertAlmostEqual(actual[1], 0, places=12)
            self.assertGreater(math.sin(second), .4)

    def test_dexterous_disk_and_singular_instantaneous_counterexample(self):
        self.assertIn("半径 1.5 m 的圆盘", self.section)
        self.assertIn("半径 2.5 m 的圆盘", self.section)
        for radius in [0, .5, 1, 1.5, 1.5001, 2, 2.5]:
            wrist_radii = [math.hypot(radius - .5 * math.cos(index * math.pi / 90),
                                     -.5 * math.sin(index * math.pi / 90))
                           for index in range(181)]
            self.assertEqual(max(wrist_radii) <= 2 + 1e-12, radius <= 1.5)
        for epsilon in [.001, .1, .5]:
            actual = planar_fk([1, 1], [epsilon, -2 * epsilon])
            self.assertAlmostEqual(actual[0], 2 * math.cos(epsilon), places=12)
            self.assertAlmostEqual(actual[1], 0, places=12)
            self.assertLess(actual[0], 2)

    def test_published_svg_equal_link_lengths_and_horizontal_critical_line(self):
        svg = ElementTree.fromstring(re.search(r"<svg.*?</svg>", self.section, re.DOTALL).group(0))
        namespace = {"svg": "http://www.w3.org/2000/svg"}
        paths = [element.attrib["d"] for element in svg.findall("svg:path", namespace)
                 if element.attrib.get("stroke") in {"var(--fig-gold)", "var(--fig-blue)"}]
        self.assertEqual(len(paths), 2)
        for path_data in paths:
            coordinates = [float(value) for value in re.findall(r"-?\d+(?:\.\d+)?", path_data)]
            first_length = math.hypot(coordinates[2] - coordinates[0], coordinates[3] - coordinates[1])
            second_length = math.hypot(coordinates[4] - coordinates[2], coordinates[5] - coordinates[3])
            self.assertAlmostEqual(first_length, 70, places=5)
            self.assertAlmostEqual(second_length, 42, places=5)
        critical = svg.find("svg:line", namespace)
        self.assertEqual(critical.attrib["y1"], critical.attrib["y2"])
        self.assertTrue(65 < float(critical.attrib["y1"]) < 285)

    def test_accuracy_data_and_published_limited_three_link_checkpoint(self):
        values = [float(value) for value in re.search(
            r"三次量测为 \$([\d.,]+)\$", self.section).group(1).split(",")]
        center = sum(values) / len(values)
        self.assertAlmostEqual(center - 100, 1)
        self.assertAlmostEqual(max(abs(value - center) for value in values), .2)
        corrected = [value - 1 for value in values]
        self.assertAlmostEqual(sum(corrected) / len(corrected), 100)
        self.assertAlmostEqual(max(abs(value - 100) for value in corrected), .2)
        exercise = (SOURCE / "ch02/exercises.md").read_text(encoding="utf-8").split("::: ex C4", 1)[1].split("::: ex C5", 1)[0]
        self.assertIn("0.35-0.1\\sqrt3", exercise)
        actual = planar_fk([.5, .3, .2], [0, 2 * math.pi / 3, math.pi / 2])
        self.assertAlmostEqual(actual[0], .35 - .1 * math.sqrt(3))
        self.assertAlmostEqual(actual[1], .15 * math.sqrt(3) - .1)
        self.assertAlmostEqual(math.hypot(*actual[:2]), .2383, places=4)


class CalibrationTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-11.md").read_text(encoding="utf-8")

    @staticmethod
    def solve(rows, values):
        normal = [[0.0, 0.0], [0.0, 0.0]]
        right = [0.0, 0.0]
        for row, value in zip(rows, values):
            for first in range(2):
                right[first] += row[first] * value
                for second in range(2):
                    normal[first][second] += row[first] * row[second]
        determinant = normal[0][0] * normal[1][1] - normal[0][1] ** 2
        return [(normal[1][1] * right[0] - normal[0][1] * right[1]) / determinant,
                (normal[0][0] * right[1] - normal[0][1] * right[0]) / determinant], determinant

    def test_published_parameter_subset_and_residual_conventions(self):
        self.assertIn("实际未知数是 $p\\le4n$", self.section)
        self.assertIn("$\\operatorname{Log}(R_n^{\\mathrm T}R_m)$", self.section)
        self.assertIn("QR/SVD", self.section)
        self.assertIn("$tm\\ge p$", self.section)
        self.assertIn("验证位形", self.section)
        self.assertIn("不是用外部位姿量测估计 DH 参数的几何标定", self.section)

    def test_two_link_synthetic_wide_measurements_recover_lengths(self):
        truth = [0.04, -0.03]
        angles = [(-150, 35), (-90, 105), (-25, -70), (35, 120), (105, -40), (160, 75)]
        rows, values = [], []
        for first, second in angles:
            first_rad, second_rad = math.radians(first), math.radians(second)
            rows.extend([[math.cos(first_rad), math.cos(first_rad + second_rad)],
                         [math.sin(first_rad), math.sin(first_rad + second_rad)]])
            values.extend([rows[-2][0] * truth[0] + rows[-2][1] * truth[1],
                           rows[-1][0] * truth[0] + rows[-1][1] * truth[1]])
        estimate, determinant = self.solve(rows, values)
        self.assertGreater(determinant, 0.1)
        self.assertAlmostEqual(estimate[0], truth[0], places=12)
        self.assertAlmostEqual(estimate[1], truth[1], places=12)

    def test_concentrated_measurements_are_rank_two_but_ill_conditioned(self):
        rows = []
        for index in range(12):
            first = math.radians(20 + (index % 6 - 2.5) * .3)
            second = math.radians(1 + (index % 4 - 1.5) * .03)
            rows.extend([[math.cos(first), math.cos(first + second)],
                         [math.sin(first), math.sin(first + second)]])
        normal = [[sum(row[first] * row[second] for row in rows) for second in range(2)] for first in range(2)]
        determinant = normal[0][0] * normal[1][1] - normal[0][1] ** 2
        trace = normal[0][0] + normal[1][1]
        smallest = (trace - math.sqrt(max(0, trace * trace - 4 * determinant))) / 2
        largest = (trace + math.sqrt(max(0, trace * trace - 4 * determinant))) / 2
        self.assertGreater(determinant, 0)
        self.assertGreater(math.sqrt(largest / smallest), 100)
        self.assertIn("方程数虽增加", self.section)

    def test_published_svg_and_tool_contract(self):
        svg = ElementTree.fromstring(re.search(r"<svg.*?</svg>", self.section, re.DOTALL).group(0))
        labels = " ".join(element.text or "" for element in svg.iter() if element.tag.endswith("text"))
        for phrase in ["正运动学", "与量测作差", "加权求解", "参数更新", "独立验证"]:
            self.assertIn(phrase, labels)
        self.assertIn('data-lab="calibration2d"', self.section)
        self.assertIn("(0.04,-0.03)", self.section)


class InverseKinematicsTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-12.md").read_text(encoding="utf-8")
        cls.lab = (SOURCE.parent / "theme/js/robot-labs-3d.js").read_text(encoding="utf-8")

    def test_published_degeneracy_guards_and_recall_contract(self):
        self.assertIn("避免调用 $\\operatorname{Atan2}(0,0)$", self.section)
        self.assertIn("前两杆完全折叠的更深退化", self.section)
        self.assertIn('data-lab="ik3d"', self.section)
        self.assertIn("FK 校验", self.section)
        self.assertNotIn("ϑ₁mathrm I=operatorname", self.lab)
        self.assertIn("相差 π", self.lab)

    def test_planar_three_link_example_reconstructs_both_branches(self):
        a1 = a2 = 1.0
        wrist = (1.0, 1.0)
        c2 = (wrist[0] ** 2 + wrist[1] ** 2 - a1 ** 2 - a2 ** 2) / (2 * a1 * a2)
        for s2 in (math.sqrt(1 - c2 ** 2), -math.sqrt(1 - c2 ** 2)):
            theta2 = math.atan2(s2, c2)
            s1 = ((a1 + a2 * c2) * wrist[1] - a2 * s2 * wrist[0]) / 2
            c1 = ((a1 + a2 * c2) * wrist[0] + a2 * s2 * wrist[1]) / 2
            theta1 = math.atan2(s1, c1)
            self.assertAlmostEqual(a1 * math.cos(theta1) + a2 * math.cos(theta1 + theta2), wrist[0], places=12)
            self.assertAlmostEqual(a1 * math.sin(theta1) + a2 * math.sin(theta1 + theta2), wrist[1], places=12)


class ChapterTwoCompanionChecks(unittest.TestCase):
    def test_checklist_goal_ids_and_task_links(self):
        checklist = (SOURCE / "ch02/checklist.md").read_text(encoding="utf-8")
        objectives = (SOURCE / "preface-objectives.md").read_text(encoding="utf-8")
        goal_pattern = r"^\| ([KSA]2\.\d+[a-z]?)\b"
        actual = re.findall(goal_pattern, checklist, re.MULTILINE)
        expected = re.findall(goal_pattern, objectives, re.MULTILINE)
        self.assertEqual(len(actual), 20)
        self.assertEqual(len(set(actual)), len(actual))
        self.assertEqual(set(actual), set(expected))
        references = re.findall(r"\]\(([^)]+\.md)(?:#([^)]+))?\)", checklist)
        for relative, anchor in references:
            target = SOURCE / "ch02" / relative
            with self.subTest(target=relative, anchor=anchor):
                self.assertTrue(target.is_file())
                if anchor:
                    text = target.read_text(encoding="utf-8")
                    self.assertTrue('{#' + anchor + '}' in text or 'id="' + anchor + '"' in text)

    def test_overview_published_checkpoint_reconstruction(self):
        text = (SOURCE / "ch02/overview.md").read_text(encoding="utf-8")
        orientation = text.split("::: sol 检查 1 核对", 1)[1].split(":::", 1)[0]
        vectors = re.findall(r"\(([-\d.]+),([-\d.]+),([-\d.]+)\)\^", orientation)
        self.assertEqual(len(vectors), 2)
        original = (1.0, 0.5, 0.0)
        rotation = ((0, -1, 0), (1, 0, 0), (0, 0, 1))
        for vector, transpose in zip(vectors, (False, True)):
            calculated = [sum((rotation[col][row] if transpose else rotation[row][col]) * original[col]
                              for col in range(3)) for row in range(3)]
            self.assertEqual(tuple(map(float, vector)), tuple(calculated))

        inverse = text.split("::: sol 检查 3 核对", 1)[1].split(":::", 1)[0]
        branches = re.findall(r"\((0|\\pi/2),(-?\\pi/2)\)|\((\\pi/2),(-?\\pi/2)\)", inverse)
        self.assertEqual(len(branches), 2)
        for parts, heading in zip(branches, (math.pi / 2, 0)):
            angles = tuple(0.0 if part == "0" else (-1 if part.startswith("-") else 1) * math.pi / 2
                           for part in parts if part)
            result = planar_fk([1, 1], angles)
            for actual, expected in zip(result, (1, 1, heading)):
                self.assertAlmostEqual(actual, expected, places=12)
        chain_answer = text.split("::: sol 检查 2 核对", 1)[1].split(":::", 1)[0]
        published_tip = re.search(r"=\(([-\d.]+),([-\d.]+),([-\d.]+)\)\^", chain_answer).groups()
        tool_endpoint = planar_fk([1, 1.5], [0, math.pi / 2])
        for actual, expected in zip(map(float, published_tip), (*tool_endpoint[:2], 0.0)):
            self.assertAlmostEqual(actual, expected, places=12)
        published_cosine = float(re.search(r"=([\d.]+)>1", inverse).group(1))
        self.assertEqual(published_cosine, (3 ** 2 - 1 ** 2 - 1 ** 2) / 2)
        self.assertGreater(published_cosine, 1)

    def test_published_wrist_velocity_shift(self):
        text = (SOURCE / "ch02/recall-cards.md").read_text(encoding="utf-8")
        example = text.split("::: sol D7 核对", 1)[1].split("例如", 1)[1].split("回读", 1)[0]
        vectors = {name: tuple(map(float, vector.split(",")))
                   for name, vector in re.findall(r"(r|\\omega|v_e|v_w)=\(([-\d.,]+)\)", example)}
        self.assertEqual(set(vectors), {"r", r"\omega", "v_e", "v_w"})
        radius, omega = vectors["r"], vectors[r"\omega"]
        cross = (omega[1] * radius[2] - omega[2] * radius[1],
                 omega[2] * radius[0] - omega[0] * radius[2],
                 omega[0] * radius[1] - omega[1] * radius[0])
        self.assertEqual(tuple(vectors["v_e"][axis] - cross[axis] for axis in range(3)), vectors["v_w"])
        self.assertNotEqual(vectors["v_e"], vectors["v_w"])

    def test_geometric_inverse_collinear_endpoints_and_zero_wrist(self):
        # The geometric alpha +/- beta path must agree with FK at both radius boundaries.
        for first, second in ((1.0, 0.8), (0.8, 1.0), (1.0, 1.0)):
            for radius in (first + second, abs(first - second)):
                if radius == 0:
                    for gamma in (-2.0, 0.0, 1.4):
                        result = planar_fk([first, second, 0.5], [gamma, math.pi, -gamma - math.pi])
                        for actual, expected in zip(result, (0.5, 0, 0)):
                            self.assertAlmostEqual(actual, expected, places=12)
                    continue
                cosine = (radius ** 2 - first ** 2 - second ** 2) / (2 * first * second)
                theta2 = math.acos(max(-1.0, min(1.0, cosine)))
                beta_cosine = (radius ** 2 + first ** 2 - second ** 2) / (2 * first * radius)
                beta = math.acos(max(-1.0, min(1.0, beta_cosine)))
                for sign in (-1, 1):
                    theta1 = -sign * beta
                    result = planar_fk([first, second], [theta1, sign * theta2])
                    self.assertAlmostEqual(result[0], radius, places=7)
                    self.assertAlmostEqual(result[1], 0, places=7)
        # Unequal lengths cannot cancel at the origin.
        self.assertGreater(abs(1.0 - 0.8), 0)
        self.assertGreater(abs((0 - 1.0 ** 2 - 0.8 ** 2) / (2 * 1.0 * 0.8)), 1)


class DHTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-8.md").read_text(encoding="utf-8")

    def assert_matrix_close(self, first, second):
        self.assertEqual(len(first), len(second))
        for row, other in zip(first, second):
            self.assertEqual(len(row), len(other))
            for value, expected in zip(row, other):
                self.assertAlmostEqual(value, expected, places=11)

    @staticmethod
    def elementary(alpha, length, distance, angle):
        cosine, sine = math.cos(angle), math.sin(angle)
        twist_cosine, twist_sine = math.cos(alpha), math.sin(alpha)
        rotate_z = [[cosine, -sine, 0, 0], [sine, cosine, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        translate_z = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, distance], [0, 0, 0, 1]]
        translate_x = [[1, 0, 0, length], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        rotate_x = [[1, 0, 0, 0], [0, twist_cosine, -twist_sine, 0],
                    [0, twist_sine, twist_cosine, 0], [0, 0, 0, 1]]
        multiply = HomogeneousTeachingChecks.multiply
        return multiply(multiply(multiply(rotate_z, translate_z), translate_x), rotate_x)

    def test_actual_published_symbolic_dh_matrix(self):
        block = self.section.split("{#method-2.8.A}", 1)[1].split("{#note-2.8.A.cols}", 1)[0]
        expression = re.findall(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", block, re.DOTALL)[-1]
        generator = random.Random(20261110)
        for alpha, length, distance, angle in (
                (0, 0, 0, 0), (math.pi, 2, -1, math.pi / 2),
                *[(generator.uniform(-math.pi, math.pi), generator.uniform(0, 2),
                   generator.uniform(-1, 1), generator.uniform(-math.pi, math.pi)) for unused in range(180)]):
            values = {r"c_{\vartheta_i}": math.cos(angle), r"s_{\vartheta_i}": math.sin(angle),
                      r"c_{\alpha_i}": math.cos(alpha), r"s_{\alpha_i}": math.sin(alpha),
                      "a_i": length, "d_i": distance}
            actual = QuaternionTeachingChecks.evaluate_matrix(expression, values)
            self.assert_matrix_close(actual, self.elementary(alpha, length, distance, angle))

    def test_actual_published_twisted_row_and_point(self):
        block = self.section.split("{#ex-2.8.B}", 1)[1].split("练习 1", 1)[0]
        published = HomogeneousTeachingChecks.matrices(block)[0]
        self.assert_matrix_close(published, self.elementary(math.pi / 2, 2, 1, math.pi / 2))
        self.assert_matrix_close(HomogeneousTeachingChecks.multiply(published, [[0], [1], [0], [1]]),
                                 [[0], [2], [2], [1]])

    def test_actual_published_mixed_chain_and_base_tool(self):
        block = self.section.split("{#practice-2.8.chain}", 1)[1].split("练习 2", 1)[0]
        first, second, chain, tool_pose = HomogeneousTeachingChecks.matrices(block)
        multiply = HomogeneousTeachingChecks.multiply
        self.assert_matrix_close(first, self.elementary(0, 1, 0.2, math.pi / 2))
        self.assert_matrix_close(second, self.elementary(0, 0.5, 0.3, -math.pi / 2))
        self.assert_matrix_close(multiply(first, second), chain)
        base = [[0, -1, 0, 2], [1, 0, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
        tool = [[1, 0, 0, 0.2], [0, 0, -1, 0], [0, 1, 0, 0.1], [0, 0, 0, 1]]
        self.assert_matrix_close(multiply(multiply(base, chain), tool), tool_pose)
        advanced = multiply(multiply(base, multiply(first, self.elementary(0, 0.5, 0.4, -math.pi / 2))), tool)
        for row in range(4):
            for column in range(4):
                self.assertAlmostEqual(advanced[row][column] - tool_pose[row][column],
                                       0.1 if (row, column) == (2, 3) else 0, places=11)

    def test_published_cylindrical_and_scara_matrices(self):
        exercises = (SOURCE / "ch02/exercises.md").read_text(encoding="utf-8")
        multiply = HomogeneousTeachingChecks.multiply
        identity = [[int(row == column) for column in range(4)] for row in range(4)]
        for title, end, rows in (
                ("::: ex C2", "::: ex C3", [(0, 0, 0, 0.4), (-math.pi / 2, 0, 0.3, 0), (0, 0, 0.7, 0)]),
                ("::: ex C3", "::: ex C4", [(0, 0.5, 0, 0.4), (0, 0.4, 0, -0.7), (0, 0, -0.3, 0), (0, 0, -0.1, 0.2)])):
            block = exercises.split(title, 1)[1].split(end, 1)[0]
            expression = re.search(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", block, re.DOTALL).group(1)
            expected = identity
            for row in rows:
                expected = multiply(expected, self.elementary(*row))
            values = {"c_{124}": math.cos(-0.1), "s_{124}": math.sin(-0.1),
                      "c_{12}": math.cos(-0.3), "s_{12}": math.sin(-0.3),
                      "c_1": math.cos(0.4), "s_1": math.sin(0.4),
                      "a_1": 0.5, "a_2": 0.4, "d_2": 0.3,
                      "d_3": 0.7 if title == "::: ex C2" else -0.3, "d_4": -0.1}
            published = QuaternionTeachingChecks.evaluate_matrix(expression, values)
            self.assert_matrix_close(published, expected)

    def test_four_bar_paths_lengths_and_coordinate_gauge(self):
        self.assertIn(r"C=(2+\sqrt3/2,1/2)", self.section)
        for angle in (-2.1, -0.3, 0, math.pi / 6, math.pi / 2, math.pi):
            elbow = [math.cos(angle), math.sin(angle)]
            first_path = [elbow[0] + 2, elbow[1]]
            second_path = [2 + math.cos(angle), math.sin(angle)]
            self.assertEqual(first_path, second_path)
            self.assertAlmostEqual(math.dist(elbow, first_path), 2)
            self.assertAlmostEqual(math.dist([2, 0], second_path), 1)
        height = 0.7
        base = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, height], [0, 0, 0, 1]]
        relative = [[1, 0, 0, 0.2], [0, 1, 0, -0.4], [0, 0, 1, 1.1 - height], [0, 0, 0, 1]]
        combined = HomogeneousTeachingChecks.multiply(base, relative)
        self.assert_matrix_close(combined, [[1, 0, 0, 0.2], [0, 1, 0, -0.4], [0, 0, 1, 1.1], [0, 0, 0, 1]])


class TypicalMechanismTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-9.md").read_text(encoding="utf-8")
        cls.identity = [[int(row == column) for column in range(4)] for row in range(4)]

    assert_matrix_close = DHTeachingChecks.assert_matrix_close

    def block(self, number):
        return self.section.split('<a id="sec-2.9.' + str(number) + '"></a>', 1)[1].split('<a id="sec-2.9.', 1)[0]

    def chain(self, rows):
        result = self.identity
        for row in rows:
            result = HomogeneousTeachingChecks.multiply(result, DHTeachingChecks.elementary(*row))
        return result

    def published(self, block, values, index=0):
        expression = re.findall(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", block, re.DOTALL)[index]
        expression = expression.replace(r"\big", "")
        return QuaternionTeachingChecks.evaluate_matrix(expression, values)

    def test_published_planar_spherical_anthropomorphic_and_tool(self):
        generator = random.Random(2901)
        for unused in range(100):
            angles = [generator.uniform(-math.pi, math.pi) for joint in range(3)]
            values = {}
            for suffix, angle in (("1", angles[0]), ("2", angles[1]), ("3", angles[2]),
                                  ("{12}", sum(angles[:2])), ("{123}", sum(angles)), ("{23}", sum(angles[1:]))):
                values["c_" + suffix] = math.cos(angle)
                values["s_" + suffix] = math.sin(angle)
            values.update({"a_1": 0.45, "a_2": 0.36, "a_3": 0.26, "d_2": 0.18, "d_3": 0.30})
            planar = self.chain([(0, length, 0, angle) for length, angle in zip((0.45, 0.36, 0.26), angles)])
            anthropomorphic = self.chain([(math.pi / 2, 0, 0, angles[0]), (0, 0.36, 0, angles[1]), (0, 0.26, 0, angles[2])])
            spherical = self.chain([(-math.pi / 2, 0, 0, angles[0]), (math.pi / 2, 0, 0.18, angles[1]), (0, 0, 0.30, 0)])
            self.assert_matrix_close(self.published(self.block(1).split("三者依次连乘", 1)[1], values), planar)
            self.assert_matrix_close(self.published(self.block(3).split("再连乘", 1)[1], values), spherical)
            self.assert_matrix_close(self.published(self.block(4), values), anthropomorphic)
            tool = self.published(self.block(1).split("应补常值变换", 1)[1], {})
            combined = HomogeneousTeachingChecks.multiply(planar, tool)
            for component in range(3):
                self.assertAlmostEqual(combined[component][2], planar[component][0], places=12)
                self.assertAlmostEqual(combined[component][0], -planar[component][2], places=12)
                self.assertAlmostEqual(combined[component][3], planar[component][3], places=12)

    def test_published_closed_chain_and_equivalent_angles(self):
        generator = random.Random(2902)
        for unused in range(100):
            first, second = (generator.uniform(-math.pi, math.pi) for joint in range(2))
            values = {"c_1''": math.cos(second), "s_1''": math.sin(second),
                      "c_1'": math.cos(first), "s_1'": math.sin(first), "a_1''": 0.5, "a_4": 0.3}
            result = self.published(self.block(2), values)
            branch = self.chain([(0, 0.45, 0, first), (0, 0.5, 0, second - first),
                                 (0, 0.45, 0, math.pi - second + first)])
            self.assert_matrix_close(result, HomogeneousTeachingChecks.multiply(branch, DHTeachingChecks.elementary(0, 0.3, 0, 0)))
            self.assert_matrix_close(result, self.chain([(0, 0.5, 0, second), (0, 0.3, 0, first + math.pi - second)]))
            self.assert_matrix_close([[branch[row][3]] for row in range(3)], [[0.5 * math.cos(second)], [0.5 * math.sin(second)], [0]])

    def test_published_full_arm_vectors_and_elbow_reference(self):
        generator = random.Random(2903)
        for unused in range(100):
            angles = [generator.uniform(-math.pi, math.pi) for joint in range(6)]
            values = {prefix + "_" + str(index + 1): function(angle)
                      for index, angle in enumerate(angles) for prefix, function in (("c", math.cos), ("s", math.sin))}
            values.update({"c_{23}": math.cos(angles[1] + angles[2]), "s_{23}": math.sin(angles[1] + angles[2]),
                           "d_2": 0.16, "d_3": 0.2, "d_4": 0.3, "d_6": 0.14, "a_2": 0.55})
            wrist_rows = [(-math.pi / 2, 0, 0, angles[3]), (math.pi / 2, 0, 0, angles[4]), (0, 0, 0.14, angles[5])]
            stanford = self.chain([(-math.pi / 2, 0, 0, angles[0]), (math.pi / 2, 0, 0.16, angles[1]), (0, 0, 0.2, 0)] + wrist_rows)
            anthropomorphic = self.chain([(math.pi / 2, 0, 0, angles[0]), (0, 0.55, 0, angles[1]),
                                          (math.pi / 2, 0, 0, angles[2]), (-math.pi / 2, 0, 0.3, angles[3]),
                                          (math.pi / 2, 0, 0, angles[4]), (0, 0, 0.14, angles[5])])
            position_block = self.block(6).split("其中位置部分", 1)[1]
            self.assert_matrix_close(self.published(position_block, values), [[stanford[row][3]] for row in range(3)])
            self.assert_matrix_close(self.published(position_block, values, 1), [[stanford[row][0]] for row in range(3)])
            self.assert_matrix_close(self.published(self.block(7), values), [[anthropomorphic[row][3]] for row in range(3)])
            old_arm = self.chain([(math.pi / 2, 0, 0, angles[0]), (0, 0.55, 0, angles[1]), (0, 0.3, 0, angles[2] - math.pi / 2)])
            for component in range(3):
                wrist_position = anthropomorphic[component][3] - 0.14 * anthropomorphic[component][2]
                self.assertAlmostEqual(wrist_position, old_arm[component][3], places=12)

    def test_published_dlr_rows_and_torso_compensation(self):
        generator = random.Random(2904)
        for unused in range(100):
            angle = generator.uniform(-math.pi, math.pi)
            values = {"c_i": math.cos(angle), "s_i": math.sin(angle), "d_i": 0.22,
                      "c_7": math.cos(angle), "s_7": math.sin(angle), "d_7": 0.12}
            self.assert_matrix_close(self.published(self.block(8), values), DHTeachingChecks.elementary(math.pi / 2, 0, 0.22, angle))
            self.assert_matrix_close(self.published(self.block(8), values, 1), DHTeachingChecks.elementary(0, 0, 0.12, angle))
            first, second, third = [generator.uniform(-math.pi, math.pi) for joint in range(3)]
            torso = self.chain([(math.pi / 2, 0, 0, first), (0, 0.55, 0, second), (0, 0.3, 0, third)])
            compensation = self.published(self.block(9), {"c_{23}": math.cos(second + third), "s_{23}": math.sin(second + third)})
            combined = HomogeneousTeachingChecks.multiply(torso, compensation)
            expected = DHTeachingChecks.elementary(math.pi / 2, 0, 0, first)
            self.assert_matrix_close([row[:3] for row in combined[:3]], [row[:3] for row in expected[:3]])
        zero = self.chain([(math.pi / 2, 0, distance, 0) for distance in (0, 0, 0.22, 0, 0.2, 0)] + [(0, 0, 0.12, 0)])
        self.assert_matrix_close(zero, [[1, 0, 0, 0], [0, -1, 0, 0], [0, 0, -1, -0.14], [0, 0, 0, 1]])

    def test_published_worked_example_and_exercise(self):
        example = self.section.split("{#ex-2.9.A}", 1)[1].split("::: intuition", 1)[0]
        self.assert_matrix_close(HomogeneousTeachingChecks.matrices(example)[0], self.chain([(0, 0.45, 0, 0), (0, 0.36, 0, math.pi / 2), (0, 0.26, 0, 0)]))
        exercise = self.section.split("{#ex-2.9.B}", 1)[1]
        self.assertIn("(0.36,0.71,0)", exercise)
        self.assertIn("(-0.18,0.40,0)", exercise)
        self.assertIn("(-0.30,0.50,0)", exercise)
        self.assert_matrix_close([[value] for value in planar_fk((0.45, 0.36, 0.26), (math.pi / 2, -math.pi / 2, math.pi / 2))[:2]], [[0.36], [0.71]])

    def test_actual_published_parameter_tables(self):
        sizes = {"a_1": 0.45, "a_2": 0.55, "a_3": 0.3, "a_4": 0.3,
                 "a_1'": 0.45, "a_2'": 0.5, "a_3'": 0.45, "a_1''": 0.5,
                 "d_2": 0.16, "d_3": 0.22, "d_4": 0.3, "d_5": 0.2, "d_6": 0.14, "d_7": 0.12}
        generator = random.Random(2905)
        for unused in range(40):
            angles = [generator.uniform(-math.pi, math.pi) for joint in range(7)]
            values = {**sizes, "0": 0, r"\pi/2": math.pi / 2, r"-\pi/2": -math.pi / 2,
                      **{r"\vartheta_" + str(index + 1): angle for index, angle in enumerate(angles)}}
            for number, expected in (
                    (1, [(0, 0.45, 0, angles[0]), (0, 0.55, 0, angles[1]), (0, 0.3, 0, angles[2])]),
                    (3, [(-math.pi / 2, 0, 0, angles[0]), (math.pi / 2, 0, 0.16, angles[1]), (0, 0, 0.22, 0)]),
                    (4, [(math.pi / 2, 0, 0, angles[0]), (0, 0.55, 0, angles[1]), (0, 0.3, 0, angles[2])]),
                    (5, [(-math.pi / 2, 0, 0, angles[3]), (math.pi / 2, 0, 0, angles[4]), (0, 0, 0.14, angles[5])]),
                    (7, [(math.pi / 2, 0, 0, angles[0]), (0, 0.55, 0, angles[1]), (math.pi / 2, 0, 0, angles[2]),
                         (-math.pi / 2, 0, 0.3, angles[3]), (math.pi / 2, 0, 0, angles[4]), (0, 0, 0.14, angles[5])]),
                    (8, [(math.pi / 2 if index < 6 else 0, 0, distance, angles[index])
                         for index, distance in enumerate((0, 0, 0.22, 0, 0.2, 0, 0.12))])):
                table = []
                for line in self.block(number).splitlines():
                    cells = [cell.strip().strip("$") for cell in line.strip("|").split("|")]
                    if len(cells) != 5 or cells[0] not in tuple(str(index) for index in range(1, 8)):
                        continue
                    length, twist, distance, angle = (values[cell] for cell in cells[1:])
                    table.append((twist, length, distance, angle))
                self.assertEqual(len(table), len(expected))
                self.assert_matrix_close(self.chain(table), self.chain(expected))


class HomogeneousTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-7.md").read_text(encoding="utf-8")
        cls.identity = [[int(row == column) for column in range(4)] for row in range(4)]

    @staticmethod
    def multiply(first, second):
        return [[sum(left * right for left, right in zip(row, column)) for column in zip(*second)] for row in first]

    def assert_matrix_close(self, first, second, places=11):
        self.assertEqual(len(first), len(second))
        for row, other_row in zip(first, second):
            self.assertEqual(len(row), len(other_row))
            for value, other in zip(row, other_row):
                self.assertAlmostEqual(value, other, places=places)

    @staticmethod
    def matrices(text):
        return [[[float(cell) for cell in row.split("&")] for row in expression.split(r"\\")]
                for expression in re.findall(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", text, re.DOTALL)]

    def test_published_point_direction_and_inverse(self):
        example = self.section.split("{#ex-2.7.B}", 1)[1].split("练习 1", 1)[0]
        forward, inverse = self.matrices(example)
        self.assert_matrix_close(self.multiply(forward, inverse), self.identity)
        self.assert_matrix_close(self.multiply(inverse, forward), self.identity)
        for original, expected in (([1, 0, 0, 1], [2, 2, 0, 1]), ([1, 0, 0, 0], [0, 1, 0, 0])):
            transformed = self.multiply(forward, [[value] for value in original])
            self.assert_matrix_close(transformed, [[value] for value in expected])
            self.assert_matrix_close(self.multiply(inverse, transformed), [[value] for value in original])
        wrong = [row[:] for row in inverse]
        for index, value in enumerate([-2, -1, 0]):
            wrong[index][3] = value
        self.assert_matrix_close(self.multiply(wrong, [[2], [2], [0], [1]]), [[0], [-3], [0], [1]])

    def test_published_chain_and_reversed_order(self):
        first = self.matrices(self.section.split("{#ex-2.7.B}", 1)[1].split("练习 1", 1)[0])[0]
        second, combined = self.matrices(self.section.split("{#ex-2.7.C}", 1)[1].split(":::", 1)[0])
        self.assert_matrix_close(self.multiply(first, second), combined)
        point = [[0], [1], [0], [1]]
        self.assert_matrix_close(self.multiply(second, point), [[1], [0], [1], [1]])
        self.assert_matrix_close(self.multiply(combined, point), [[2], [2], [1], [1]])
        self.assert_matrix_close(self.multiply(self.multiply(second, first), point), [[2], [0], [1], [1]])

    def test_published_exercises_distance_and_orthogonality(self):
        translation = [[1, 0, 0, 2], [0, 1, 0, -1], [0, 0, 1, 3], [0, 0, 0, 1]]
        self.assert_matrix_close(self.multiply(translation, [[1], [2], [0], [1]]), [[3], [1], [3], [1]])
        self.assert_matrix_close(self.multiply(translation, [[1], [2], [0], [0]]), [[1], [2], [0], [0]])
        gram = self.multiply([list(row) for row in zip(*translation)], translation)
        self.assertEqual(gram[3][3], 15)
        self.assertNotEqual(gram, self.identity)
        combined = [[0, -1, 0, 2], [1, 0, 0, 2], [0, 0, 1, 0], [0, 0, 0, 1]]
        first = self.multiply(combined, [[0], [1], [0], [1]])
        second = self.multiply(combined, [[1], [1], [0], [1]])
        self.assert_matrix_close(first, [[1], [2], [0], [1]])
        self.assert_matrix_close(second, [[1], [3], [0], [1]])
        self.assertAlmostEqual(math.dist([row[0] for row in first], [row[0] for row in second]), 1)
        self.assertAlmostEqual(math.hypot(*[row[0] for row in first[:3]]), math.sqrt(5))

    def test_published_offset_axis_exponential_and_spatial_velocity(self):
        expression = re.search(r"A\(t\)=\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", self.section, re.DOTALL).group(1)
        generator = [[0, -1, 0, 0], [1, 0, 0, -1], [0, 0, 0, 0], [0, 0, 0, 0]]
        def forward(time):
            return QuaternionTeachingChecks.evaluate_matrix(expression, {r"\cos t": math.cos(time), r"\sin t": math.sin(time)})
        for time in (-1.3, 0, 0.2, math.pi / 2, math.pi):
            published = forward(time)
            term = [row[:] for row in self.identity]
            exponential = [row[:] for row in self.identity]
            for degree in range(1, 65):
                term = [[time * value / degree for value in row] for row in self.multiply(term, generator)]
                exponential = [[left + right for left, right in zip(row, other)] for row, other in zip(exponential, term)]
            self.assert_matrix_close(published, exponential)
            self.assert_matrix_close(self.multiply(published, forward(-time)), self.identity)
            self.assert_matrix_close(self.multiply(published, [[1], [0], [0], [1]]), [[1], [0], [0], [1]])
            derivative = [[(after - before) / 0.000002 for after, before in zip(after_row, before_row)]
                          for after_row, before_row in zip(forward(time + 0.000001), forward(time - 0.000001))]
            self.assert_matrix_close(self.multiply(derivative, forward(-time)), generator, places=8)
        self.assertAlmostEqual(math.sin(math.pi / 2), 1)
        self.assertAlmostEqual(-math.cos(math.pi / 2), 0)


class QuaternionTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-6.md").read_text(encoding="utf-8")

    @staticmethod
    def product(first, second):
        scalar, horizontal, vertical, depth = first
        other_scalar, other_horizontal, other_vertical, other_depth = second
        return [scalar * other_scalar - horizontal * other_horizontal - vertical * other_vertical - depth * other_depth,
                scalar * other_horizontal + horizontal * other_scalar + vertical * other_depth - depth * other_vertical,
                scalar * other_vertical - horizontal * other_depth + vertical * other_scalar + depth * other_horizontal,
                scalar * other_depth + horizontal * other_vertical - vertical * other_horizontal + depth * other_scalar]

    def reference_matrix(self, quaternion):
        inverse = [quaternion[0]] + [-value for value in quaternion[1:]]
        columns = [self.product(self.product(quaternion, [0] + [int(index == column) for index in range(3)]), inverse)[1:]
                   for column in range(3)]
        return [list(row) for row in zip(*columns)]

    def assert_matrix_close(self, first, second):
        self.assertEqual(len(first), len(second))
        for row, other_row in zip(first, second):
            self.assertEqual(len(row), len(other_row))
            for value, other_value in zip(row, other_row):
                self.assertAlmostEqual(value, other_value, places=12)

    @staticmethod
    def evaluate_matrix(expression, substitutions):
        for name, value in substitutions.items():
            expression = expression.replace(name, "(" + repr(value) + ")")
        expression = expression.replace("^", "**")
        return [[eval(re.sub(r"(\)|\d)\s*\(", r"\1*(", cell.strip()), {"__builtins__": {}})
                 for cell in row.split("&")] for row in expression.split(r"\\")]

    def test_published_nine_elements_and_extraction_matrix(self):
        forward = re.search(r"R\(\\eta,\\boldsymbol\\epsilon\)=\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}",
                            self.section, re.DOTALL).group(1)
        extraction = re.search(r"H=\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", self.section, re.DOTALL).group(1)
        generator = random.Random(20261110)
        for raw in ([1, 0, 0, 0], [0, 1, -1, 0], [0, 0, 0, -1], *[[generator.uniform(-1, 1) for unused in range(4)] for case in range(120)]):
            quaternion = [value / math.hypot(*raw) for value in raw]
            matrix = self.reference_matrix(quaternion)
            values = dict(zip((r"\eta", r"\epsilon_x", r"\epsilon_y", r"\epsilon_z"), quaternion))
            self.assert_matrix_close(self.evaluate_matrix(forward, values), matrix)
            entries = {"r_{" + str(row + 1) + str(column + 1) + "}": matrix[row][column]
                       for row in range(3) for column in range(3)}
            symmetric = self.evaluate_matrix(extraction, entries)
            self.assert_matrix_close(symmetric, [[4 * first * second for second in quaternion] for first in quaternion])
            pivot = max(range(4), key=lambda index: symmetric[index][index])
            component = math.sqrt(symmetric[pivot][pivot]) / 2
            self.assertGreaterEqual(component, 0.5 - 1e-12)
            extracted = [row[pivot] / (4 * component) for row in symmetric]
            self.assert_matrix_close(self.reference_matrix(extracted), matrix)

    def test_published_exact_half_turn_counterexample(self):
        example = self.section.split("{#ex-2.6.B}", 1)[1].split(":::", 1)[0]
        matrices = [self.evaluate_matrix(expression, {}) for expression in re.findall(
            r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", example, re.DOTALL)]
        self.assertEqual(len(matrices), 2)
        root = math.sqrt(0.5)
        self.assert_matrix_close(matrices[0], self.reference_matrix([0, root, -root, 0]))
        self.assert_matrix_close(matrices[1], self.reference_matrix([0, root, root, 0]))
        self.assertEqual(max(abs(value - other) for row, other_row in zip(*matrices) for value, other in zip(row, other_row)), 2)

    def test_published_product_and_inverse_exercise(self):
        root = math.sqrt(0.5)
        horizontal = [root, root, 0, 0]
        vertical = [root, 0, 0, root]
        self.assert_matrix_close([self.product(vertical, horizontal)], [[0.5, 0.5, 0.5, 0.5]])
        product = self.product(horizontal, vertical)
        self.assert_matrix_close([product], [[0.5, 0.5, -0.5, 0.5]])
        exercise = self.section.split("练习 2 ·", 1)[1].split("::: note", 1)[0]
        expression = re.search(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", exercise, re.DOTALL).group(1)
        matrix = self.evaluate_matrix(expression, {})
        self.assert_matrix_close(matrix, self.reference_matrix(product))
        self.assert_matrix_close([[row[1] for row in matrix]], [[-1, 0, 0]])
        inverse = [product[0]] + [-value for value in product[1:]]
        self.assert_matrix_close([self.product(product, inverse)], [[1, 0, 0, 0]])

    def test_published_slerp_and_sign_alignment(self):
        first = [math.cos(math.radians(85)), 0, 0, math.sin(math.radians(85))]
        second = [math.cos(math.radians(95)), 0, 0, math.sin(math.radians(95))]
        dot = sum(left * right for left, right in zip(first, second))
        self.assertAlmostEqual(dot, math.cos(math.radians(10)))
        omega = math.acos(dot)
        for fraction in (0, 0.25, 0.5, 0.75, 1):
            interpolated = [(math.sin((1 - fraction) * omega) * left + math.sin(fraction * omega) * right) / math.sin(omega)
                            for left, right in zip(first, second)]
            half_angle = math.radians(85 + 10 * fraction)
            self.assert_matrix_close([interpolated], [[math.cos(half_angle), 0, 0, math.sin(half_angle)]])
            self.assertAlmostEqual(math.hypot(*interpolated), 1)
        self.assertEqual([(left + right) / 2 for left, right in zip([1, 0, 0, 0], [-1, 0, 0, 0])], [0, 0, 0, 0])
        self.assertLess(sum(left * -right for left, right in zip(first, second)), 0)


class AxisAngleTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.section = (SOURCE / "ch02/sec2-5.md").read_text(encoding="utf-8")
        exercises = (SOURCE / "ch02/exercises.md").read_text(encoding="utf-8")
        exercise = exercises.split("::: ex C1 ", 1)[1].split("::: ex C2 ", 1)[0]
        code = re.search(r"~~~python\n(.*?)~~~", exercise, re.DOTALL).group(1)
        cls.functions = {}
        with contextlib.redirect_stdout(io.StringIO()):
            exec(compile(code, "exercises-C1", "exec"), cls.functions)

    def test_published_program_and_input_boundaries(self):
        self.assertEqual(len(self.functions["cases"]), 1015)
        self.assertTrue(all(value < 1e-12 for value in self.functions["maximum"].values()))
        forward = self.functions["axis_matrix"]
        for direction in ([0, 0, 0], [math.nan, 0, 1], [math.inf, 0, 1], [1, 2]):
            with self.assertRaises(ValueError):
                forward(direction, 0)
        with self.assertRaises(ValueError):
            forward([1, 1, 1], math.inf)

    def test_published_nine_element_formula(self):
        expression = re.search(r"R\(\\vartheta,\\boldsymbol r\)=\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}",
                               self.section, re.DOTALL).group(1)
        for direction in ([1, 1, 1], [1, -2, 3], [0, 0, -1]):
            axis = [value / math.hypot(*direction) for value in direction]
            for angle in (0, math.pi, -1.3, 1e-8):
                substituted = expression
                for name, value in zip(("r_x", "r_y", "r_z"), axis):
                    substituted = substituted.replace(name, "(" + repr(value) + ")")
                substituted = substituted.replace("c_\\vartheta", "(" + repr(math.cos(angle)) + ")")
                substituted = substituted.replace("s_\\vartheta", "(" + repr(math.sin(angle)) + ")")
                substituted = substituted.replace("^", "**")
                rows = [[eval(re.sub(r"(\)|\d)\s*\(", r"\1*(", cell.strip()), {"__builtins__": {}})
                         for cell in row.split("&")] for row in substituted.split(r"\\")]
                self.assertLess(self.functions["matrix_error"](rows, self.functions["axis_matrix"](direction, angle)), 1e-12)

    def test_published_cycle_and_mixed_sign_example(self):
        example = self.section.split("{#ex-2.5.C}", 1)[1].split(":::", 1)[0]
        matrix_text = re.search(r"R=\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", example).group(1)
        matrix = [list(map(float, row.split("&"))) for row in matrix_text.split(r"\\")]
        self.assertLess(self.functions["matrix_error"](matrix, self.functions["axis_matrix"]([1, 1, 1], 2 * math.pi / 3)), 1e-12)
        point = [sum(value * component for value, component in zip(row, [1, 2, 3])) for row in matrix]
        self.assertEqual(point, [3, 1, 2])
        mixed = [[0, -1, 0], [-1, 0, 0], [0, 0, -1]]
        self.assertLess(self.functions["matrix_error"](mixed, self.functions["axis_matrix"]([1, -1, 0], math.pi)), 1e-12)
        self.assertGreater(self.functions["matrix_error"](mixed, self.functions["axis_matrix"]([1, 1, 0], math.pi)), 1)

    def test_published_tangent_and_relative_interpolation(self):
        example = self.section.split("::: sol 核对\n主旋转向量", 1)[1].split(":::", 1)[0]
        matrices = [[list(map(float, row.split("&"))) for row in values.split(r"\\")]
                    for values in re.findall(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", example)]
        self.assertEqual(len(matrices), 3)
        self.assertEqual(matrices[1][0][0], -1)
        self.assertLess(self.functions["matrix_error"](
            self.functions["multiply"](matrices[1], [list(column) for column in zip(*matrices[0])]), matrices[2]), 1e-12)
        middle = self.functions["multiply"](self.functions["elementary"]("z", math.pi / 2),
                                             self.functions["elementary"]("z", math.pi / 4))
        self.assertLess(self.functions["matrix_error"](middle, self.functions["elementary"]("z", 3 * math.pi / 4)), 1e-12)
        self.assertGreater(self.functions["matrix_error"](middle, self.functions["elementary"]("z", math.pi / 2)), 0.7)
        exam = (SOURCE / "ch02/mock-exam.md").read_text(encoding="utf-8")
        self.assertIn("迹为 $-2$", exam)
        rotation = self.functions["axis_matrix"]([2, 2, 1], math.pi / 2)
        self.assertLess(self.functions["matrix_error"](rotation, [[4/9, 1/9, 8/9], [7/9, 4/9, -4/9], [-4/9, 8/9, 1/9]]), 1e-12)


class EulerTeachingChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = (SOURCE / "ch02/exercises.md").read_text(encoding="utf-8")
        section = cls.text.split("::: ex C5", 1)[1].split("::: ex C6", 1)[0]
        source = "\n".join(re.findall(r"```python\n(.*?)```", section, re.DOTALL))
        cls.functions = {}
        with contextlib.redirect_stdout(io.StringIO()):
            exec(compile(source, "exercises-C5", "exec"), cls.functions)

    def test_published_code_branches_and_singularities(self):
        forward = self.functions["euler_forward"]
        inverse = self.functions["euler_inverse"]
        error = self.functions["matrix_error"]
        generator = random.Random(20261110)
        for mode in ("zyz", "rpy"):
            for index in range(1000):
                original_angles = [generator.uniform(-math.pi, math.pi) for unused in range(3)]
                original = forward(mode, *original_angles)
                angles, radius, regular = inverse(mode, original)
                self.assertTrue(regular)
                self.assertLess(error(original, forward(mode, *angles)), 1e-12)
                phi, theta, psi = angles
                second = (phi + math.pi, -theta if mode == "zyz" else math.pi - theta, psi + math.pi)
                self.assertLess(error(original, forward(mode, *second)), 1e-12)
            singular_angles = (0, math.pi) if mode == "zyz" else (-math.pi / 2, math.pi / 2)
            for theta in singular_angles:
                original = forward(mode, 0.4, theta, -0.2)
                angles, radius, regular = inverse(mode, original)
                self.assertFalse(regular)
                self.assertEqual(angles[2], 0)
                self.assertLess(error(original, forward(mode, *angles)), 1e-12)
                near_angles = inverse(mode, forward(mode, 0.4, theta + 1e-6, -0.2))
                self.assertTrue(near_angles[2])

    def test_published_zxz_matrix(self):
        section = self.text.split("::: ex B1", 1)[1].split("::: ex B2", 1)[0]
        expression = re.search(r"\\begin\{bmatrix\}(.*?)\\end\{bmatrix\}", section, re.DOTALL).group(1)
        forward_parts = self.functions["rotation"]
        multiply = self.functions["multiply"]
        error = self.functions["matrix_error"]
        for angles in ((0, math.pi / 2, 0), (0.3, 0.7, -0.8), (-1.4, -0.9, 2.1)):
            substituted = expression
            for name, angle in zip((r"\varphi", r"\vartheta", r"\psi"), angles):
                for prefix, function in (("c_", math.cos), ("s_", math.sin)):
                    substituted = substituted.replace(prefix + name, "(" + repr(function(angle)) + ")")
            rows = []
            for row in substituted.split(r"\\"):
                rows.append([eval(re.sub(r"\)\s*\(", ")*(", cell.strip()), {"__builtins__": {}})
                             for cell in row.split("&")])
            reference = multiply(multiply(forward_parts("z", angles[0]), forward_parts("x", angles[1])),
                                 forward_parts("z", angles[2]))
            self.assertLess(error(rows, reference), 1e-12)

    def test_atan2_tangential_sensitivity(self):
        for radius in (1.0, math.sin(math.radians(1)), math.sin(math.radians(0.01))):
            angle, perturbation = 0.4, 1e-10
            horizontal, vertical = radius * math.cos(angle), radius * math.sin(angle)
            perturbed = math.atan2(vertical + perturbation * math.cos(angle),
                                   horizontal - perturbation * math.sin(angle))
            self.assertAlmostEqual((perturbed - angle) * radius / perturbation, 1, places=6)


class PoseRepresentationChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = (SOURCE / "ch02/sec2-1.md").read_text(encoding="utf-8")

    def test_published_pose_and_point_translation(self):
        example = self.text.split("::: ex 带数示范", 1)[1].split("::: think 练习 1", 1)[0]
        origin = tuple(map(float, re.search(r"o'=\(([-\d.,]+)\)", example).group(1).split(",")))
        axes = [tuple(map(float, values.split(","))) for values in
                re.findall(r"boldsymbol [xyz]'=\(([-\d.,]+)\)", example)]
        self.assertEqual(len(axes), 3)
        for first_index, first_axis in enumerate(axes):
            for second_index, second_axis in enumerate(axes):
                self.assertAlmostEqual(sum(first * second for first, second in zip(first_axis, second_axis)),
                                       float(first_index == second_index))
        cross_product = (axes[0][1] * axes[1][2] - axes[0][2] * axes[1][1],
                         axes[0][2] * axes[1][0] - axes[0][0] * axes[1][2],
                         axes[0][0] * axes[1][1] - axes[0][1] * axes[1][0])
        self.assertEqual(cross_product, axes[2])
        matrix_text = re.search(r"R=\\begin\{bmatrix\}(.+?)\\end\{bmatrix\}", example).group(1)
        matrix_rows = [tuple(map(float, row.split("&"))) for row in matrix_text.split(r"\\")]
        self.assertEqual(list(zip(*matrix_rows)), axes)
        diagram = (SOURCE / "assets/figures/robot-pose.md").read_text(encoding="utf-8")
        svg = ElementTree.fromstring(re.search(r"<svg .*?</svg>", diagram, re.DOTALL).group(0))
        cells = {(float(element.attrib["x"]), float(element.attrib["y"])): element.text
                 for element in svg.findall(".//{http://www.w3.org/2000/svg}text")}
        for row_index, row in enumerate(matrix_rows):
            for column_index, value in enumerate(row):
                self.assertEqual(float(cells[(686 + column_index * 56, 229 + row_index * 34)]), value)
        exercise = self.text.split("::: think 练习 1", 1)[1].split("::: think 练习 2", 1)[0]
        question, answer = exercise.split("::: sol", 1)
        offset = tuple(map(float, re.search(r"坐标为 \$\(([-\d.,]+)\)", question).group(1).split(",")))
        translation = float(re.search(r"增加 \$([\d.]+)", question).group(1))
        displacement = tuple(sum(axis[component] * distance for axis, distance in zip(axes, offset))
                             for component in range(3))
        point = tuple(position + distance for position, distance in zip(origin, displacement))
        answers = [tuple(map(float, values.split(","))) for values in re.findall(r"\(([-\d.,]+)\)\^", answer)]
        self.assertEqual(len(answers), 4)
        for actual, expected in zip(point, answers[0]):
            self.assertAlmostEqual(actual, expected)
        translated = (point[0] + translation, point[1], point[2])
        for actual, expected in zip(translated, answers[2]):
            self.assertAlmostEqual(actual, expected)
        self.assertEqual(answers[1], axes[0])
        self.assertEqual(answers[3], axes[0])

    def test_published_reflection_has_wrong_handedness(self):
        question = self.text.split("::: think 练习 2", 1)[1].split("::: sol", 1)[0]
        axes = [tuple(map(int, values.split(","))) for values in
                re.findall(r"boldsymbol [xyz]'=\(([-\d.,]+)\)", question)]
        self.assertEqual(len(axes), 4)
        for first_index, first_axis in enumerate(axes[:3]):
            for second_index, second_axis in enumerate(axes[:3]):
                self.assertEqual(sum(first * second for first, second in zip(first_axis, second_axis)),
                                 int(first_index == second_index))
        cross_product = (axes[0][1] * axes[1][2] - axes[0][2] * axes[1][1],
                         axes[0][2] * axes[1][0] - axes[0][0] * axes[1][2],
                         axes[0][0] * axes[1][1] - axes[0][1] * axes[1][0])
        self.assertEqual(cross_product, tuple(-component for component in axes[2]))
        self.assertEqual(sum(component * normal for component, normal in zip(cross_product, axes[2])), -1)

    def test_component_plot_matches_published_readings(self):
        svg = ElementTree.fromstring(re.search(r"<svg .*?</svg>", self.text, re.DOTALL).group(0))
        namespace = {"svg": "http://www.w3.org/2000/svg"}
        vectors = [element for element in svg.findall(".//svg:line", namespace)
                   if element.attrib.get("x1") in ("100", "560") and
                   element.attrib.get("x2") in ("280", "674")]
        self.assertEqual(len(vectors), 2)
        for vector, components in zip(vectors, ((0.30, 0.20), (0.60, 0.80))):
            horizontal = float(vector.attrib["x2"]) - float(vector.attrib["x1"])
            vertical = float(vector.attrib["y1"]) - float(vector.attrib["y2"])
            self.assertAlmostEqual(horizontal / vertical, components[0] / components[1])
        self.assertAlmostEqual(math.hypot(0.60, 0.80), 1)
        self.assertEqual(round(math.hypot(0.30, 0.20), 3), 0.361)


class BasicRotationChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = (SOURCE / "ch02/sec2-2.md").read_text(encoding="utf-8")
        cls.matrices = {}
        for axis, greek in (("x", "gamma"), ("y", "beta"), ("z", "alpha")):
            pattern = r"R_" + axis + r"\(\\" + greek + r"\)=\\begin\{bmatrix\}(.+?)\\end\{bmatrix\}"
            matrix = re.search(pattern, cls.text).group(1)
            cls.matrices[axis] = [[cell.strip() for cell in row.split("&")]
                                  for row in matrix.split(r"\\")]

    def matrix(self, axis, degrees):
        cosine = math.cos(math.radians(degrees))
        sine = math.sin(math.radians(degrees))

        def component(token):
            if token.startswith("-s_"):
                return -sine
            if token.startswith("s_"):
                return sine
            if token.startswith("c_"):
                return cosine
            return float(token)

        return [[component(token) for token in row] for row in self.matrices[axis]]

    def test_published_basic_rotations_are_right_handed_and_reversible(self):
        for axis in self.matrices:
            for degrees in (-180, -90, -35, 0, 30, 90, 180):
                with self.subTest(axis=axis, degrees=degrees):
                    matrix = self.matrix(axis, degrees)
                    inverse = self.matrix(axis, -degrees)
                    columns = list(zip(*matrix))
                    for first_index, first in enumerate(columns):
                        for second_index, second in enumerate(columns):
                            self.assertAlmostEqual(sum(left * right for left, right in zip(first, second)),
                                                   float(first_index == second_index))
                            self.assertAlmostEqual(matrix[first_index][second_index], inverse[second_index][first_index])
                    cross_product = (columns[0][1] * columns[1][2] - columns[0][2] * columns[1][1],
                                     columns[0][2] * columns[1][0] - columns[0][0] * columns[1][2],
                                     columns[0][0] * columns[1][1] - columns[0][1] * columns[1][0])
                    self.assertAlmostEqual(sum(value * normal for value, normal in zip(cross_product, columns[2])), 1)
        self.assertAlmostEqual(self.matrix("y", 90)[2][0], -1)
        self.assertAlmostEqual(self.matrix("y", 90)[0][2], 1)

    def test_published_active_passive_comparison(self):
        comparison = self.text.split("::: ex 数值对照", 1)[1].split("先在纸上预测", 1)[0]
        initial = tuple(map(float, re.search(r"a=\(([-\d.,]+)\)", comparison).group(1).split(",")))
        expected = [tuple(map(float, values.split(",")))
                    for values in re.findall(r"=\(([-\d.,]+)\)\^", comparison)]
        self.assertEqual(len(expected), 3)
        matrix = self.matrix("z", 90)
        active = tuple(sum(value * component for value, component in zip(row, initial)) for row in matrix)
        passive = tuple(sum(value * component for value, component in zip(column, initial)) for column in zip(*matrix))
        for actual, answer in zip((active, passive), expected[1:]):
            for value, target in zip(actual, answer):
                self.assertAlmostEqual(value, target)
            self.assertAlmostEqual(math.hypot(*actual), math.sqrt(1.25))
        self.assertNotEqual(active, passive)
        half_turn = self.matrix("z", 180)
        for row_index in range(3):
            for column_index in range(3):
                self.assertAlmostEqual(half_turn[row_index][column_index], half_turn[column_index][row_index])


class RotationCompositionChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.text = (SOURCE / "ch02/sec2-3.md").read_text(encoding="utf-8")

    @staticmethod
    def multiply(first, second):
        return [[sum(left * right for left, right in zip(row, column))
                 for column in zip(*second)] for row in first]

    def test_published_two_step_matrices_and_axes(self):
        example = self.text.split("{#ex-2.3.C}", 1)[1].split("<figure>", 1)[0]
        matrices = re.findall(r"\\begin\{bmatrix\}(.+?)\\end\{bmatrix\}", example, re.DOTALL)
        published = [[[int(cell.strip()) for cell in row.split("&")]
                      for row in matrix.strip().split(r"\\")] for matrix in matrices]
        self.assertEqual(len(published), 2)
        rotation_y = [[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
        rotation_z = [[0, -1, 0], [1, 0, 0], [0, 0, 1]]
        self.assertEqual(published[0], self.multiply(rotation_z, rotation_y))
        self.assertEqual(published[1], self.multiply(rotation_y, rotation_z))
        self.assertEqual(list(zip(*published[0])), [(0, 0, -1), (-1, 0, 0), (0, 1, 0)])
        self.assertEqual(list(zip(*published[1])), [(0, 1, 0), (0, 0, 1), (1, 0, 0)])
        svg = ElementTree.fromstring(re.search(r"<svg .*?</svg>", self.text, re.DOTALL).group(0))
        lines = svg.findall(".//{http://www.w3.org/2000/svg}line")
        projection = ((57, 16), (-27, -15), (0, -60))
        for origin, matrix in zip((470, 790), published):
            axes = [line for line in lines if line.attrib.get("x1") == str(origin)
                    and line.attrib.get("stroke-width") == "2.6"]
            self.assertEqual(len(axes), 3)
            for arrow, column in zip(axes, zip(*matrix)):
                for dimension, coordinate in enumerate(("x2", "y2")):
                    expected = sum(value * axis[dimension] for value, axis in zip(column, projection))
                    actual = float(arrow.attrib[coordinate]) - (origin if dimension == 0 else 215)
                    self.assertLessEqual(abs(actual - expected), 1)

    def test_nonidentity_initial_pose_and_half_turn_boundary(self):
        rotation_x = [[1, 0, 0], [0, 0, -1], [0, 1, 0]]
        rotation_y = [[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
        rotation_z = [[0, -1, 0], [1, 0, 0], [0, 0, 1]]
        product = self.multiply(rotation_z, rotation_y)
        fixed = self.multiply(product, rotation_x)
        current = self.multiply(rotation_x, product)
        self.assertEqual([row[0] for row in fixed], [0, 0, -1])
        self.assertEqual([row[0] for row in current], [0, 1, 0])
        half_y = [[-1, 0, 0], [0, 1, 0], [0, 0, -1]]
        half_z = [[-1, 0, 0], [0, -1, 0], [0, 0, 1]]
        expected = [[1, 0, 0], [0, -1, 0], [0, 0, -1]]
        self.assertEqual(self.multiply(half_y, half_z), expected)
        self.assertEqual(self.multiply(half_z, half_y), expected)


class ChapterOneSelectionChecks(unittest.TestCase):
    def test_published_precision_samples(self):
        text = (SOURCE / "ch01/mock-exam.md").read_text(encoding="utf-8")
        question = text.split("**18.（10 分）", 1)[1].split("::: sol", 1)[0]
        rows = re.findall(r"\| \$\(([-\d.]+),([-\d.]+)\)\$ \| (\d+) \|", question)
        self.assertEqual(len(rows), 4)
        samples = [(float(horizontal), float(vertical), int(count))
                   for horizontal, vertical, count in rows]
        total = sum(count for horizontal, vertical, count in samples)
        self.assertEqual(total, 400)
        centroid = tuple(sum(sample[axis] * sample[2] for sample in samples) / total
                         for axis in range(2))
        scatter = max(math.dist(sample[:2], centroid) for sample in samples)
        bias = math.hypot(*centroid)
        self.assertAlmostEqual(centroid[0], 0.20)
        self.assertAlmostEqual(centroid[1], 0.03)
        self.assertAlmostEqual(scatter, 0.010)
        self.assertAlmostEqual(bias, 0.20223748416156684)
        self.assertLessEqual(scatter, 0.05)
        self.assertGreater(bias, 0.20)
        self.assertTrue(all(horizontal > 0.10 for horizontal, vertical, count in samples))
        translation = (0.7, -0.4)
        translated_center = tuple(center + offset for center, offset in zip(centroid, translation))
        translated_scatter = max(math.dist((horizontal + translation[0], vertical + translation[1]),
                                           translated_center)
                                 for horizontal, vertical, count in samples)
        self.assertAlmostEqual(translated_scatter, scatter)
        self.assertNotAlmostEqual(math.hypot(*translated_center), bias)

    def test_published_one_dimensional_precision(self):
        text = (SOURCE / "ch01/sec1-4.md").read_text(encoding="utf-8")
        question = text.split("::: think 精度练习", 1)[1].split("<details", 1)[0]
        target_match = re.search(r"指令目标为 \$(\d+\.\d+)", question)
        arrivals_match = re.search(r"到达位置为 \$([\d.,]+)", question)
        self.assertIsNotNone(target_match)
        self.assertIsNotNone(arrivals_match)
        target = float(target_match.group(1))
        arrivals = [float(value) for value in arrivals_match.group(1).split(",")]
        centroid = sum(arrivals) / len(arrivals)
        self.assertAlmostEqual(centroid, 10.20)
        self.assertAlmostEqual(max(abs(value - centroid) for value in arrivals), 0.01)
        self.assertAlmostEqual(abs(centroid - target), 0.20)

    def test_serial_cycle_and_payload_budget(self):
        text = (SOURCE / "ch01/sec1-4.md").read_text(encoding="utf-8")
        question = text.split("::: think 参数练习", 1)[1].split("<details", 1)[0]
        mass_match = re.search(r"工件 ([\d.]+) kg、夹具及工具附件共 ([\d.]+) kg", question)
        rate_match = re.search(r"要求 (\d+) 件/分钟", question)
        self.assertIsNotNone(mass_match)
        self.assertIsNotNone(rate_match)
        self.assertIn("顺序完成两次完整抓放循环", question)
        total_mass = sum(Fraction(value) for value in mass_match.groups())
        part_budget = Fraction(60, int(rate_match.group(1)))
        cycle_time = Fraction("0.4")
        self.assertEqual(total_mass, Fraction("2.8"))
        self.assertGreater(total_mass, 1)
        self.assertLess(total_mass, 12)
        self.assertEqual(part_budget, Fraction("0.5"))
        self.assertEqual(part_budget / 2, Fraction("0.25"))
        self.assertGreater(2 * cycle_time, part_budget)
        self.assertEqual(60 / (2 * cycle_time), 75)


class ChapterOneCompanionChecks(unittest.TestCase):
    def test_recall_and_exercise_references_exist(self):
        cards = (SOURCE / "ch01/recall-cards.md").read_text(encoding="utf-8")
        exercises = (SOURCE / "ch01/exercises.md").read_text(encoding="utf-8")
        card_ids = set(re.findall(r"^### ([A-D]\d+) ·", cards, re.MULTILINE))
        exercise_ids = set(re.findall(r"^::: ex ([A-D]\d+b?) ·", exercises, re.MULTILINE))
        self.assertEqual(len(card_ids), 36)
        self.assertEqual(len(exercise_ids), 21)
        references = 0
        for path in (SOURCE / "ch01").glob("*.md"):
            text = path.read_text(encoding="utf-8")
            for label, valid_ids in (("回忆卡", card_ids), ("习题", exercise_ids)):
                for match in re.finditer(label + r"\s+([A-D]\d+b?(?:[、/][A-D]\d+b?)*)", text):
                    for identifier in re.split(r"[、/]", match.group(1)):
                        with self.subTest(page=path.name, label=label, identifier=identifier):
                            self.assertIn(identifier, valid_ids)
                        references += 1
        self.assertGreater(references, 0)

    def test_published_mock16_velocity_and_sideways_manoeuvre(self):
        text = (SOURCE / "ch01/mock-exam.md").read_text(encoding="utf-8")
        question = text.split("**16.（10 分）", 1)[1].split("**17.（10 分）", 1)[0]
        horizontal = float(re.search(r"dot x=([\d.]+)", question).group(1))
        vertical = float(re.search(r"dot y=([\d.]+)", question).group(1))
        angle = math.radians(float(re.search(r"theta=(\d+)\^", question).group(1)))
        normal = (-math.sin(angle), math.cos(angle))
        residual = normal[0] * horizontal + normal[1] * vertical
        self.assertAlmostEqual(residual, -0.1267949192431122)
        lateral_vector = tuple(residual * component for component in normal)
        self.assertGreater(lateral_vector[0], 0)
        self.assertLess(lateral_vector[1], 0)
        swapped = -math.cos(angle) * horizontal + math.sin(angle) * vertical
        self.assertAlmostEqual(swapped, -0.4196152422706632)
        forward_velocity = tuple(0.60 * component for component in (math.cos(angle), math.sin(angle)))
        self.assertAlmostEqual(sum(component * speed for component, speed in zip(normal, forward_velocity)), 0)
        turn = math.pi / 2 - angle
        intermediate_angle = angle + turn
        displacement = tuple(0.40 * component for component in (math.cos(intermediate_angle), math.sin(intermediate_angle)))
        self.assertAlmostEqual(displacement[0], 0)
        self.assertAlmostEqual(displacement[1], 0.40)
        self.assertAlmostEqual(intermediate_angle - turn, angle)

    def test_published_mock17_workspace_bounds(self):
        text = (SOURCE / "ch01/mock-exam.md").read_text(encoding="utf-8")
        question = text.split("**17.（10 分）", 1)[1].split("**18.（10 分）", 1)[0]
        points = [tuple(map(float, match)) for match in re.findall(r"[ABC]\(([\d.]+),([\d.]+),([\d.]+)\)", question)]
        radii = [float(value) / 1000 for value in re.findall(r"最大半径 \$(\d+)", question)]
        heights = re.search(r"z\\in\[([-\d.]+),([-\d.]+)\]", question)
        self.assertEqual(len(points), 3)
        self.assertEqual(radii, [0.80, 1.65])
        minimum_height, maximum_height = map(float, heights.groups())
        distances = [math.hypot(*point[:2]) for point in points]
        for actual, expected in zip(distances, (0.100, math.sqrt(1.28), math.sqrt(1.73))):
            self.assertAlmostEqual(actual, expected)
        self.assertTrue(all(not (distance <= radii[0] and minimum_height <= point[2] <= maximum_height)
                            for distance, point in zip(distances, points)))
        self.assertTrue(all(distance < radii[1] for distance in distances))
        annular_inner_boundary = 0.20
        self.assertLess(distances[0], annular_inner_boundary)
        self.assertFalse(annular_inner_boundary <= distances[0] <= radii[1])


class ChapterOneModellingChecks(unittest.TestCase):
    def test_published_slide_time_law_and_limits(self):
        text = (SOURCE / "ch01/sec1-5.md").read_text(encoding="utf-8")
        example = text.split("::: ex 水平滑台示例", 1)[1].split("::: think 规划练习", 1)[0]
        initial = float(re.search(r"q_0=([\d.]+)", example).group(1))
        final = float(re.search(r"q_f=([\d.]+)", example).group(1))
        duration = float(re.search(r"T=([\d.]+)", example).group(1))
        mass = float(re.search(r"质量为 ([\d.]+) kg", example).group(1))

        def reference(time, total_time):
            progress = time / total_time
            distance = final - initial
            return (initial + distance * (3 * progress**2 - 2 * progress**3),
                    distance / total_time * (6 * progress - 6 * progress**2),
                    distance / total_time**2 * (6 - 12 * progress))

        self.assertEqual(reference(0, duration)[:2], (initial, 0))
        endpoint = reference(duration, duration)
        self.assertAlmostEqual(endpoint[0], final)
        self.assertAlmostEqual(endpoint[1], 0)
        position, velocity, acceleration = reference(0.5, duration)
        self.assertAlmostEqual(position, 0.1625)
        self.assertAlmostEqual(velocity, 0.225)
        self.assertAlmostEqual(acceleration, 0.300)
        self.assertAlmostEqual(mass * acceleration, 0.600)
        increment = 1e-5
        plus = reference(0.5 + increment, duration)
        minus = reference(0.5 - increment, duration)
        self.assertAlmostEqual((plus[0] - minus[0]) / (2 * increment), velocity, places=8)
        self.assertAlmostEqual((plus[1] - minus[1]) / (2 * increment), acceleration, places=8)
        peak_force = mass * abs(reference(0, duration)[2])
        self.assertAlmostEqual(peak_force, 1.20)
        self.assertGreater(peak_force, 1.00)
        slower = reference(1.0, 2 * duration)
        self.assertAlmostEqual(slower[0], position)
        self.assertAlmostEqual(slower[1], velocity / 2)
        self.assertAlmostEqual(slower[2], acceleration / 4)
        self.assertAlmostEqual(mass * slower[2], 0.150)
        self.assertLess(mass * abs(reference(0, 2 * duration)[2]), 1.00)
        self.assertGreater(2 * duration, duration)

    def test_published_position_sensor_bias(self):
        text = (SOURCE / "ch01/sec1-5.md").read_text(encoding="utf-8")
        exercise = text.split("::: think 反馈练习", 1)[1].split("</details>", 1)[0]
        target = float(re.search(r"最终目标为 ([\d.]+) m", exercise).group(1))
        actual = float(re.search(r"实际位置为 ([\d.]+) m", exercise).group(1))
        bias = float(re.search(r"恒定多报 ([\d.]+) m", exercise).group(1))
        gain = float(re.search(r"K_p=(\d+)", exercise).group(1))
        self.assertAlmostEqual(gain * (target - actual), 2.0)
        measurement = actual + bias
        self.assertAlmostEqual(measurement, target)
        self.assertAlmostEqual(target - actual, 0.02)
        for multiplier in (1, 10, 100):
            self.assertAlmostEqual(multiplier * gain * (target - measurement), 0)


class TeachingExamples(unittest.TestCase):
    def test_coordinate_round_trip(self):
        # Rz(pi/2), origin (2, 1, 0): independently expand the scalar equations.
        point = (2 - 0, 1 + 1, 0)
        self.assertEqual(point, (2, 2, 0))
        self.assertEqual((point[1] - 1, -(point[0] - 2), 0), (1, 0, 0))
        self.assertEqual((2 - 1, 2 + 0, 0), (1, 2, 0))

    def test_two_jacobian_paths(self):
        h = 1e-6
        angles = (0, math.pi / 2)
        for column, expected in enumerate(((-1, 1), (-1, 0))):
            plus, minus = list(angles), list(angles)
            plus[column] += h
            minus[column] -= h
            pp, pm = planar_fk((1, 1), plus), planar_fk((1, 1), minus)
            for axis in range(2):
                self.assertAlmostEqual((pp[axis] - pm[axis]) / (2 * h),
                                       expected[axis], places=8)

    def test_pendulum_gravity_sign(self):
        q, h = math.pi / 6, 1e-6
        potential = lambda angle: 2 * 9.81 * 0.5 * (1 - math.cos(angle))
        gradient = (potential(q + h) - potential(q - h)) / (2 * h)
        actual_force = 0.5 * math.sin(q) * (-2 * 9.81)
        self.assertAlmostEqual(gradient, 4.905, places=8)
        self.assertAlmostEqual(gradient + actual_force, 0, places=8)
        self.assertAlmostEqual(-gradient / 0.5, -9.81, places=7)
        self.assertAlmostEqual(0.5 * -2 + gradient, 3.905, places=8)

    def test_inverse_kinematics_two_branches_and_degeneracy(self):
        lengths = (1, 1, 0.5)
        for angles in ((0, math.pi / 2, -math.pi / 2),
                       (math.pi / 2, -math.pi / 2, 0)):
            for actual, expected in zip(planar_fk(lengths, angles), (1.5, 1, 0)):
                self.assertAlmostEqual(actual, expected, places=12)
        for gamma in (-2, -0.7, 0, 1.4, 3):
            for actual, expected in zip(
                    planar_fk(lengths, (gamma, math.pi, -gamma - math.pi)),
                    (0.5, 0, 0)):
                self.assertAlmostEqual(actual, expected, places=12)
        # Zero wrist is outside the unequal-length arm's annulus.
        self.assertLess(0, abs(1 - 0.8))

    def test_trajectory_costs_exactly(self):
        # Cubic q=3t²-2t³ has acceleration 6-12t.
        self.assertEqual(integral_square((Fraction(6), Fraction(-12))), 12)
        for u, expected in ((Fraction(1, 3), Fraction(27, 2)),
                            (Fraction(1, 2), Fraction(16)),
                            (Fraction(1, 5), Fraction(125, 8))):
            acceleration = 1 / (u * (1 - u))
            cost = 2 * u * acceleration ** 2
            self.assertEqual(cost, expected)
        self.assertEqual(Fraction(27, 2) / 12, Fraction(9, 8))
        # Derivative of u(1-u)^2: 1 - 4u + 3u², sign changes at 1/3.
        self.assertGreater(1 - 4 * Fraction(1, 4) + 3 * Fraction(1, 4) ** 2, 0)
        self.assertLess(1 - 4 * Fraction(2, 5) + 3 * Fraction(2, 5) ** 2, 0)

    def test_gear_energy_power_and_relative_inertia(self):
        motor_inertia, load_inertia, ratio = 1e-4, 0.05, 100
        reflected = load_inertia / ratio ** 2
        self.assertAlmostEqual(reflected / motor_inertia, 0.05)
        self.assertAlmostEqual(reflected / (reflected + motor_inertia), 1 / 21)
        self.assertAlmostEqual(0.5 * (reflected + motor_inertia) * 100 ** 2, 0.525)
        self.assertEqual((10 / ratio) * 100, 10 * (100 / ratio))
        self.assertAlmostEqual((5 / ratio ** 2) / motor_inertia, 5)
        angle = 2 * math.pi / 100
        self.assertAlmostEqual((angle - math.sin(angle)) / math.sin(angle),
                               0.0006582768, places=9)
        angle = math.pi / 2
        self.assertAlmostEqual((angle - math.sin(angle)) / math.sin(angle),
                               0.5707963268, places=9)

    def test_published_example_markers(self):
        # Tie this finite verification scope to the reviewed pages and values.
        for file, markers in {
            "ch02/sec2-12.md": ("ex-2.12.D", "0.5,0", "无穷多解"),
            "ch04/sec4-2-1.md": ("ex-4.2.D", "15.625", "u=1/3"),
            "ch05/sec5-2-3.md": ("ex-5.2.E", "0.525", "57.08"),
        }.items():
            text = (SOURCE / file).read_text()
            for marker in markers:
                self.assertIn(marker, text, file)


G = 9.81


def planar_arm_terms(q1, q2, qd1, qd2, *, a1=1.0, a2=1.0, l1=0.5, l2=0.5,
                     m1=50.0, m2=50.0, i1=10.0, i2=10.0,
                     kr1=100.0, kr2=100.0, im1=0.01, im2=0.01,
                     mm1=5.0, mm2=5.0):
    """B, h, C and g of the two-link planar arm (Siciliano 7.3.2)."""
    s2, c2 = math.sin(q2), math.cos(q2)
    b11 = (i1 + m1 * l1 ** 2 + kr1 ** 2 * im1 + i2
           + m2 * (a1 ** 2 + l2 ** 2 + 2 * a1 * l2 * c2) + im2 + mm2 * a1 ** 2)
    b12 = i2 + m2 * (l2 ** 2 + a1 * l2 * c2) + kr2 * im2
    b22 = i2 + m2 * l2 ** 2 + kr2 ** 2 * im2
    h = -m2 * a1 * l2 * s2
    c_mat = [[h * qd2, h * (qd1 + qd2)], [-h * qd1, 0.0]]
    cq = [h * (2 * qd1 * qd2 + qd2 ** 2), -h * qd1 ** 2]
    g1 = ((m1 * l1 + mm2 * a1 + m2 * a1) * G * math.cos(q1)
          + m2 * l2 * G * math.cos(q1 + q2))
    g2 = m2 * l2 * G * math.cos(q1 + q2)
    return (b11, b12, b22), h, c_mat, cq, (g1, g2)


class ChapterSixExamples(unittest.TestCase):
    def test_ex_C1_gear_pendulum(self):
        big, feq = 0.6 + 2e-3 * 100 ** 2, 0.1 + 1e-3 * 100 ** 2
        self.assertAlmostEqual(big, 20.6, places=9)
        self.assertAlmostEqual(feq, 10.1, places=9)
        self.assertAlmostEqual((2e-3 * 100 ** 2) / big, 0.9709, places=4)
        grav = 1.2 * G * 0.35 * math.sin(math.pi / 3)
        self.assertAlmostEqual(grav, 3.5682, places=4)
        self.assertAlmostEqual(big + feq * 0.5 + grav, 29.2182, places=4)

    def test_ex_C2_planar_state_and_antisymmetry(self):
        q1, q2, qd1, qd2 = math.pi / 4, -math.pi / 6, 0.5, -0.25
        (b11, b12, b22), h, c_mat, cq, (g1, g2) = planar_arm_terms(q1, q2, qd1, qd2)
        self.assertAlmostEqual(h, 12.5, places=9)
        self.assertAlmostEqual(b11, 243.31127, places=5)
        self.assertAlmostEqual(b12, 45.150635, places=6)
        self.assertAlmostEqual(b22, 122.5, places=9)
        self.assertAlmostEqual(cq[0], -2.34375, places=9)
        self.assertAlmostEqual(cq[1], -3.125, places=9)
        self.assertAlmostEqual(c_mat[0][0], -3.125, places=9)
        self.assertAlmostEqual(c_mat[1][0], -6.25, places=9)
        self.assertAlmostEqual(g1, 791.8307, places=4)
        self.assertAlmostEqual(g2, 236.8933, places=4)
        # N = Bdot - 2C must come out antisymmetric with zero diagonal.
        bdot = [[2 * h * qd2, h * qd2], [h * qd2, 0.0]]
        n = [[bdot[i][j] - 2 * c_mat[i][j] for j in range(2)] for i in range(2)]
        self.assertAlmostEqual(n[0][0], 0.0, places=9)
        self.assertAlmostEqual(n[1][1], 0.0, places=9)
        self.assertAlmostEqual(n[0][1], -9.375, places=9)
        self.assertAlmostEqual(n[1][0], 9.375, places=9)
        self.assertAlmostEqual(n[0][1] + n[1][0], 0.0, places=9)
        # Static inverse dynamics at qdd = 0.
        self.assertAlmostEqual(cq[0] + g1, 789.4870, places=4)
        self.assertAlmostEqual(cq[1] + g2, 233.7683, places=4)

    def test_ex_B5_alt_C_counterexample(self):
        h, qd1, qd2 = -12.5, 0.3, 0.4
        n = [[-2 * h * qd2, -h * qd2], [2 * h * qd1, h * qd1]]
        self.assertEqual([[round(v, 9) for v in row] for row in n],
                         [[10.0, 5.0], [-7.5, -3.75]])
        # (B) holds along the trajectory direction.
        qn = (qd1 ** 2 * n[0][0] + qd1 * qd2 * (n[0][1] + n[1][0])
              + qd2 ** 2 * n[1][1])
        self.assertAlmostEqual(qn, 0.0, places=9)
        # (A) fails for w = (1, 0).
        self.assertAlmostEqual(n[0][0], 10.0, places=9)

    def test_ex_C3_cartesian_nonorthogonal(self):
        m1, m2, mm2, kr1sq_im1, kr2sq_im2 = 3.0, 2.0, 0.5, 0.8, 0.4
        for alpha, off in ((math.pi / 4, 2 * math.cos(math.pi / 4)),
                           (math.pi / 2, 0.0)):
            b11 = m1 + mm2 + m2 + kr1sq_im1
            b22 = m2 + kr2sq_im2
            self.assertAlmostEqual(b11, 6.3, places=9)
            self.assertAlmostEqual(b22, 2.4, places=9)
            det = 6.3 * b22 - off ** 2
            if alpha == math.pi / 4:
                self.assertAlmostEqual(det, 13.12, places=9)
                self.assertAlmostEqual(4 * math.cos(alpha) ** 2, 2.0, places=9)
                tau1 = b11 * 0.5 + off * 1.0 + (m1 + mm2 + m2) * G
                self.assertAlmostEqual(tau1, 58.5192, places=4)
            else:
                self.assertAlmostEqual(det, 15.12, places=9)
                tau1 = b11 * 0.5 + off * 1.0 + (m1 + mm2 + m2) * G
                self.assertAlmostEqual(tau1, 57.105, places=6)

    def test_ex_C4_inverse_dynamics(self):
        q1, q2, qd1, qd2 = math.pi / 4, -math.pi / 6, 0.5, -0.25
        (b11, b12, b22), _, _, cq, g = planar_arm_terms(q1, q2, qd1, qd2)
        tau1 = b11 * 0.2 + b12 * 0.4 + cq[0] + g[0]
        tau2 = b12 * 0.2 + b22 * 0.4 + cq[1] + g[1]
        self.assertAlmostEqual(tau1, 856.209, places=3)
        self.assertAlmostEqual(tau2, 291.798, places=3)
        self.assertAlmostEqual(b11 * 0.2 + b12 * 0.4, 66.7225, places=4)

    def test_ex_C5_least_squares(self):
        sqrt2 = math.sqrt(2)
        y = [[1.0, 0.5], [2.0, 1.0], [0.5, sqrt2 / 2]]
        pi_true = (0.8, 1.0 * G * 0.4)
        self.assertAlmostEqual(pi_true[1], 3.924, places=9)
        tau = [y[i][0] * pi_true[0] + y[i][1] * pi_true[1] for i in range(3)]
        self.assertAlmostEqual(tau[0], 2.762, places=9)
        self.assertAlmostEqual(tau[1], 5.524, places=9)
        self.assertAlmostEqual(tau[2], 3.1747, places=4)
        yty = [[sum(y[k][i] * y[k][j] for k in range(3)) for j in range(2)]
               for i in range(2)]
        ytt = [sum(y[k][i] * tau[k] for k in range(3)) for i in range(2)]
        self.assertAlmostEqual(yty[0][0], 5.25, places=9)
        self.assertAlmostEqual(yty[0][1], 2.8535534, places=6)
        self.assertAlmostEqual(yty[1][1], 1.75, places=9)
        self.assertAlmostEqual(ytt[0], 15.3973, places=4)
        self.assertAlmostEqual(ytt[1], 9.1498, places=4)
        det = yty[0][0] * yty[1][1] - yty[0][1] * yty[1][0]
        pi1 = (ytt[0] * yty[1][1] - yty[0][1] * ytt[1]) / det
        pi2 = (yty[0][0] * ytt[1] - ytt[0] * yty[1][0]) / det
        self.assertAlmostEqual(pi1, pi_true[0], places=9)
        self.assertAlmostEqual(pi2, pi_true[1], places=9)

    def test_ex_C6_energy_identity(self):
        q1, q2, qd1, qd2 = math.pi / 4, -math.pi / 6, 0.5, -0.25
        (_, _, _), h, _, cq, _ = planar_arm_terms(q1, q2, qd1, qd2)
        bdot = [[2 * h * qd2, h * qd2], [h * qd2, 0.0]]
        qd = (qd1, qd2)
        # Path 1: half of qd^T Bdot qd.
        quad_bdot = (qd[0] ** 2 * bdot[0][0]
                     + qd[0] * qd[1] * (bdot[0][1] + bdot[1][0])
                     + qd[1] ** 2 * bdot[1][1])
        # Path 2: qd^T (C qd).
        quad_c = qd[0] * cq[0] + qd[1] * cq[1]
        self.assertAlmostEqual(quad_bdot / 2, quad_c, places=9)
        self.assertAlmostEqual(quad_c, -0.390625, places=9)

    def test_mock16_uniform_rod(self):
        m, l, im, kr = 1.5, 0.6, 2e-4, 50
        io = m * l ** 2 / 3
        big = io + im * kr ** 2
        self.assertAlmostEqual(io, 0.18, places=9)
        self.assertAlmostEqual(big, 0.68, places=9)
        grav = m * G * (l / 2) * math.sin(math.pi / 2)
        self.assertAlmostEqual(grav, 4.4145, places=6)
        self.assertAlmostEqual(big * 3 + grav, 6.4545, places=6)
        # Parallel-axis check: ml^2/12 + m(l/2)^2 = ml^2/3.
        self.assertAlmostEqual(m * l ** 2 / 12 + m * (l / 2) ** 2, io, places=9)

    def test_mock17_small_direct_drive_arm(self):
        kwargs = dict(a1=1.0, a2=1.0, l1=0.5, l2=0.5, m1=1.0, m2=1.0,
                      i1=0.1, i2=0.1, kr1=1.0, kr2=1.0, im1=0.02, im2=0.02,
                      mm1=0.2, mm2=0.2)
        q1, q2, qd1, qd2 = 0.0, math.pi / 2, 0.2, 0.0
        (b11, b12, b22), h, _, cq, g = planar_arm_terms(q1, q2, qd1, qd2, **kwargs)
        self.assertAlmostEqual(h, -0.5, places=9)
        self.assertAlmostEqual(b11, 1.94, places=9)
        self.assertAlmostEqual(b12, 0.37, places=9)
        self.assertAlmostEqual(b22, 0.37, places=9)
        self.assertAlmostEqual(cq[0], 0.0, places=9)
        self.assertAlmostEqual(cq[1], 0.02, places=9)
        self.assertAlmostEqual(g[0], 16.677, places=9)
        self.assertAlmostEqual(g[1], 0.0, places=9)
        # qdd = (0, 0.5): Coriolis keeps joint 2 busy even with qd2 = g2 = 0.
        self.assertAlmostEqual(b12 * 0.5 + g[0], 16.862, places=9)
        self.assertAlmostEqual(b22 * 0.5 + cq[1], 0.205, places=9)

    def test_mock18_end_force_and_power(self):
        a1 = a2 = 0.5
        q1, q2 = math.pi / 6, math.pi / 3
        j = [[-a1 * math.sin(q1) - a2 * math.sin(q1 + q2),
              -a2 * math.sin(q1 + q2)],
             [a1 * math.cos(q1) + a2 * math.cos(q1 + q2),
              a2 * math.cos(q1 + q2)]]
        self.assertAlmostEqual(j[0][0], -0.75, places=9)
        self.assertAlmostEqual(j[1][0], 0.4330127, places=7)
        f = (10.0, -5.0)
        tau_f = (j[0][0] * f[0] + j[1][0] * f[1], j[0][1] * f[0] + j[1][1] * f[1])
        self.assertAlmostEqual(tau_f[0], -9.6650635, places=6)
        self.assertAlmostEqual(tau_f[1], -5.0, places=9)
        qd = (1.0, 0.0)
        v = (j[0][0] * qd[0] + j[0][1] * qd[1], j[1][0] * qd[0] + j[1][1] * qd[1])
        self.assertAlmostEqual(qd[0] * tau_f[0] + qd[1] * tau_f[1],
                               v[0] * f[0] + v[1] * f[1], places=9)

    def test_mock19_lagrange_matches_gear_reduction(self):
        i, im, kr = 0.4, 0.002, 80
        f, fm, m, l = 0.06, 5e-4, 1.0, 0.5
        # Joint side (Lagrange).
        self.assertAlmostEqual(i + im * kr ** 2, 13.2, places=9)
        self.assertAlmostEqual(f + fm * kr ** 2, 3.26, places=9)
        self.assertAlmostEqual(m * G * l, 4.905, places=9)
        # Motor side, times k_r^2 / k_r respectively.
        ieq = im + i / kr ** 2
        feq = fm + f / kr ** 2
        self.assertAlmostEqual(kr ** 2 * ieq, 13.2, places=9)
        self.assertAlmostEqual(kr ** 2 * feq, 3.26, places=9)
        self.assertAlmostEqual(ieq, 0.0020625, places=9)
        self.assertAlmostEqual(feq, 5.09375e-4, places=9)
        self.assertAlmostEqual(kr * (m * G * l / kr), m * G * l, places=9)

    def test_ch06_published_example_markers(self):
        # Tie this finite verification scope to the reviewed pages and values.
        for file, markers in {
            "ch06/sec6-1-2.md": ("ex-6.1.2.A", "4.905"),
            "ch06/exercises.md": ("243.311", "789.487", "3.9240",
                                  "58.519", "856.209", "13.12"),
            "ch06/mock-exam.md": ("6.455", "16.862", "-9.665",
                                  "13.2", "0.0020625"),
            "ch06/recall-cards.md": ("24 张卡", "7.48", "7.49"),
            "ch06/checklist.md": ("K6.9", "S6.2"),
        }.items():
            text = (SOURCE / file).read_text()
            for marker in markers:
                self.assertIn(marker, text, file)


class TwoLinkCourseChecks(unittest.TestCase):
    def test_midpoint_and_time_scaling(self):
        def trajectory(time, duration):
            progress = time / duration
            blend = 3 * progress**2 - 2 * progress**3
            return (math.pi * blend / 2, math.pi / 2 - math.pi * blend)

        for duration in (1.0, 2.0, 4.0):
            self.assertEqual(trajectory(0.0, duration), (0.0, math.pi / 2))
            self.assertEqual(trajectory(duration, duration), (math.pi / 2, -math.pi / 2))
            midpoint = duration / 2
            angles = trajectory(midpoint, duration)
            position = planar_fk((1.0, 1.0), angles)
            self.assertAlmostEqual(position[0], math.sqrt(2))
            self.assertAlmostEqual(position[1], math.sqrt(2))
            increment = 1e-5 * duration
            before = planar_fk((1.0, 1.0), trajectory(midpoint - increment, duration))
            after = planar_fk((1.0, 1.0), trajectory(midpoint + increment, duration))
            for coordinate in range(2):
                self.assertAlmostEqual((after[coordinate] - before[coordinate]) / (2 * increment), 0.0, places=8)
            left_angles = trajectory(midpoint - increment, duration)
            right_angles = trajectory(midpoint + increment, duration)
            first_speed = (right_angles[0] - left_angles[0]) / (2 * increment)
            self.assertAlmostEqual(first_speed, 3 * math.pi / (4 * duration), places=8)

        self.assertAlmostEqual(10 * 3 * math.pi / (4 * 2), 11.78097245096)
        minimum_duration = 3 * math.pi / 4
        self.assertAlmostEqual(10 * 3 * math.pi / (4 * minimum_duration), 10.0)

    def test_uniform_rods_energy_and_gravity(self):
        gravity = 9.81
        increment = 1e-6

        def potential(angles):
            first_height = math.sin(angles[0]) / 2
            second_height = math.sin(angles[0]) + math.sin(sum(angles)) / 2
            return gravity * (first_height + second_height)

        def kinetic(angles, rates):
            first_rate, second_rate = rates
            first_velocity = (-math.sin(angles[0]) * first_rate / 2,
                              math.cos(angles[0]) * first_rate / 2)
            second_velocity = (
                -math.sin(angles[0]) * first_rate - math.sin(sum(angles)) * sum(rates) / 2,
                math.cos(angles[0]) * first_rate + math.cos(sum(angles)) * sum(rates) / 2,
            )
            return (sum(value**2 for value in first_velocity + second_velocity) / 2
                    + (first_rate**2 + (first_rate + second_rate)**2) / 24)

        for angles in ((0.0, math.pi / 2), (0.4, -0.8), (-0.7, 1.2)):
            gravity_terms = (
                gravity * (1.5 * math.cos(angles[0]) + 0.5 * math.cos(sum(angles))),
                gravity * 0.5 * math.cos(sum(angles)),
            )
            for coordinate in range(2):
                plus, minus = list(angles), list(angles)
                plus[coordinate] += increment
                minus[coordinate] -= increment
                gradient = (potential(plus) - potential(minus)) / (2 * increment)
                self.assertAlmostEqual(gradient, gravity_terms[coordinate], places=7)
            inertia_first = 5 / 3 + math.cos(angles[1])
            inertia_cross = 1 / 3 + math.cos(angles[1]) / 2
            inertia_second = 1 / 3
            self.assertAlmostEqual(2 * kinetic(angles, (1.0, 0.0)), inertia_first)
            self.assertAlmostEqual(2 * kinetic(angles, (0.0, 1.0)), inertia_second)
            self.assertAlmostEqual(kinetic(angles, (1.0, 1.0))
                                   - kinetic(angles, (1.0, 0.0))
                                   - kinetic(angles, (0.0, 1.0)), inertia_cross)

        self.assertAlmostEqual(gravity * 1.5, 14.715)
        self.assertAlmostEqual(gravity * 1.5 + 5 / 3, 16.381666666666668)
        self.assertGreater(gravity * 1.5, 12)

    def test_feedback_damping_and_disturbance(self):
        position_gain, damping_gain, inertia, friction = 25.0, 10.0, 2.0, 0.3
        for error, velocity in ((0.0, 1.0), (0.2, -0.7), (-0.1, 0.5)):
            torque_after_gravity = position_gain * error - damping_gain * velocity
            acceleration = (torque_after_gravity - friction * velocity) / inertia
            energy_rate = inertia * velocity * acceleration - position_gain * error * velocity
            self.assertAlmostEqual(energy_rate, -(friction + damping_gain) * velocity**2)
            self.assertLess(energy_rate, 0)
        self.assertEqual(damping_gain**2 - 4 * position_gain, 0)
        self.assertAlmostEqual(0.1 / position_gain, 0.004)
        self.assertAlmostEqual(0.1 / 100, 0.001)


if __name__ == "__main__":
    unittest.main(verbosity=2)
