#!/usr/bin/env python3
"""Recompute reviewed teaching examples using only the Python standard library.

Run from any directory: python3 robot/tools/verify_teaching_examples.py
Scope: revised coordinate, Jacobian, gravity, IK, trajectory and gear examples
(rounds 1-2), plus the chapter-6 (dynamics) exercises, mock exam and structure
checks added in round 3.
This checks specific published examples, not every formula in the book.
"""

import math
from fractions import Fraction
from pathlib import Path
import unittest

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


if __name__ == "__main__":
    unittest.main(verbosity=2)
