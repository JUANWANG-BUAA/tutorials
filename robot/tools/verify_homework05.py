#!/usr/bin/env python3
"""Recompute the published numbers of homework 5 and the chapter-5 C-group
exercises / mock-exam calculations, using only the Python standard library.

Run from any directory: python3 robot/tools/verify_homework05.py
Scope: homework 5.6 / 5.7, chapter-5 exercises C1-C6, mock-exam problems 16-18.
This checks specific published examples, not every formula in the chapter.
"""

import math
import unittest


def skew(r):
    x, y, z = r
    return [[0, -z, y], [z, 0, -x], [-y, x, 0]]


def mat_vec(m, v):
    return [sum(m[i][j] * v[j] for j in range(3)) for i in range(3)]


def mat_mul(a, b):
    return [[sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3)]
            for i in range(3)]


class Homework05(unittest.TestCase):
    def test_5_1_speed_generator_correction(self):
        # (A4): omega_m = (K/kv) * v'_c / (1 + Ra*Fm/(kv*kt)).
        # The published text claims the correction is 5% for the C2 parameters.
        kv = kt = 0.2
        Ra, Fm = 0.2, 0.01
        ratio = Ra * Fm / (kv * kt)
        self.assertAlmostEqual(ratio, 0.05, places=12)
        self.assertAlmostEqual(1.0 / (1.0 + ratio), 0.952381, places=6)
        # (B3): c_m = (kt/ki) * (v'_c - (kv/K) omega_m) / (1 + Ra/(K*ki)),
        # with the 0.2% correction quoted for K = 1e4, ki = 0.01.
        K, ki = 1e4, 0.01
        ratio_b = Ra / (K * ki)
        self.assertAlmostEqual(ratio_b, 0.002, places=12)
        self.assertAlmostEqual(1.0 / (1.0 + ratio_b), 0.998004, places=6)
        # Steady-state check: (5.9) and (5.10) at s = 0 reproduce (5.7) and
        # the kv/K -> 0 form of (5.8).
        Kv, Im, Cl = 1000.0, 0.0014, 0.0
        vel_gain = 1.0 / kv * Kv          # (5.9) numerator at s = 0
        self.assertAlmostEqual(vel_gain, 5000.0, places=9)
        torque_gain = kt / (ki * Fm)      # (5.10) numerator at s = 0
        self.assertAlmostEqual(torque_gain, 2000.0, places=9)
        self.assertAlmostEqual(Im / Fm, 0.14, places=12)
        # The two inequalities in Thm 5.2.B follow from one another.
        self.assertLess(Ra / (kv * kt), 1.0 / Fm)
        self.assertLess(Ra * Im / (kv * kt), Im / Fm)

    def test_5_6_force_transform(self):
        # tau_c = S(r) R f_s + R mu_s with r=[-0.3,0,0.2], R as in the text.
        r = [-0.3, 0, 0.2]
        R = [[0, 0, 1], [0, -1, 0], [1, 0, 0]]
        f_s = [20, 0, 0]
        mu_s = [0, 6, 0]
        f_c = mat_vec(R, f_s)
        mu_c = [a + b for a, b in zip(mat_vec(mat_mul(skew(r), R), f_s),
                                      mat_vec(R, mu_s))]
        self.assertEqual(f_c, [0, 0, 20])
        self.assertEqual(mu_c, [0, 0, 0])
        # The two torque contributions are exact opposites.
        self.assertEqual(mat_vec(mat_mul(skew(r), R), f_s), [0, 6, 0])
        self.assertEqual(mat_vec(R, mu_s), [0, -6, 0])
        # Independent check via |r x f| = |r||f| sin(theta): the text quotes
        # |r| = 0.3606 m, theta = 56.31 deg, lever arm = 6.000 N.m.
        lever = mat_vec(mat_mul(skew(r), R), f_s)
        n_r = math.sqrt(sum(v * v for v in r))
        n_f = math.sqrt(sum(v * v for v in f_c))
        cos_t = sum(a * b for a, b in zip(r, f_c)) / (n_r * n_f)
        self.assertAlmostEqual(n_r, 0.360555, places=6)
        self.assertAlmostEqual(math.degrees(math.acos(cos_t)), 56.30993,
                               places=4)
        self.assertAlmostEqual(n_r * n_f * math.sin(math.acos(cos_t)), 6.0,
                               places=9)
        self.assertAlmostEqual(math.sqrt(sum(v * v for v in lever)), 6.0,
                               places=9)

    def test_5_7_scara_camera(self):
        f, ax, ay, x0, y0 = 8.0, 79.2, 120.5, 250.0, 250.0
        theta = math.pi / 4
        # End-effector pose: x = 0.5 + 0.5 cos45, y = 0.5 sin45, d3 = 0.1.
        ox, oy, oz = 0.5 + 0.5 * math.cos(theta), 0.5 * math.sin(theta), 0.1
        c, s = math.cos(theta), math.sin(theta)
        R = [[c, -s, 0], [s, c, 0], [0, 0, 1]]
        p = [0.8, 0.5, 0.9]
        # p_c = R^T (p - o); the depth component is kept as lambda.
        d = [p[i] - [ox, oy, oz][i] for i in range(3)]
        p_c = [sum(R[j][i] * d[j] for j in range(3)) for i in range(3)]
        self.assertAlmostEqual(p_c[0], 0.06569, places=5)
        self.assertAlmostEqual(p_c[1], 0.14142, places=5)
        self.assertAlmostEqual(p_c[2], 0.8, places=12)
        # Intermediates published in the walked-through solution.
        self.assertAlmostEqual(p_c[0], 0.0656854, places=7)
        self.assertAlmostEqual(p_c[1], 0.1414214, places=7)
        self.assertAlmostEqual(f * p_c[0] / p_c[2], 0.656854, places=6)
        self.assertAlmostEqual(f * p_c[1] / p_c[2], 1.414214, places=6)
        self.assertAlmostEqual(ax * f, 633.6, places=9)
        self.assertAlmostEqual(ay * f, 964.0, places=9)
        # Homogeneous row before the perspective division.
        self.assertAlmostEqual(f * ax * p_c[0] + x0 * p_c[2], 241.618,
                               places=3)
        self.assertAlmostEqual(f * ay * p_c[1] + y0 * p_c[2], 336.330,
                               places=3)
        # Official solution rounds p_c to three decimals first.
        for pc, expect in ((p_c, (302.02, 420.41)),
                           ([0.066, 0.141, 0.8], (302.27, 419.90))):
            x_i = f * ax * pc[0] + x0 * pc[2]
            y_i = f * ay * pc[1] + y0 * pc[2]
            self.assertAlmostEqual(x_i / pc[2], expect[0], places=2)
            self.assertAlmostEqual(y_i / pc[2], expect[1], places=2)

    def test_ex_C1_gear_reflection(self):
        Im, I, Fm, F, Cl = 1e-4, 0.05, 1e-3, 0.02, 5.0
        expected = {1: (5.010e-2, 2.100e-2, 5.0),
                    50: (1.200e-4, 1.008e-3, 0.1),
                    100: (1.050e-4, 1.002e-3, 0.05),
                    200: (1.013e-4, 1.001e-3, 0.025)}
        for kr, (ieq, feq, cl) in expected.items():
            self.assertAlmostEqual(Im + I / kr ** 2, ieq, places=6)
            self.assertAlmostEqual(Fm + F / kr ** 2, feq, places=6)
            self.assertAlmostEqual(Cl / kr, cl, places=9)
        # Load term is 5% of the motor inertia, i.e. 1/21 of I_eq.
        self.assertAlmostEqual((I / 100 ** 2) / Im, 0.05, places=9)
        self.assertAlmostEqual((I / 100 ** 2) / (Im + I / 100 ** 2), 1 / 21,
                               places=9)

    def test_ex_C2_generator_modes(self):
        kv, kt, Ra, Im, Fm, ki = 0.2, 0.2, 0.2, 0.0014, 0.01, 0.01
        self.assertAlmostEqual(1 / kv, 5.0, places=9)
        self.assertAlmostEqual(Ra * Im / (kv * kt), 7.0e-3, places=9)
        self.assertAlmostEqual(Ra / (kv * kt), 5.0, places=9)
        self.assertAlmostEqual(kt / (ki * Fm), 2000.0, places=6)
        self.assertAlmostEqual(Im / Fm, 0.14, places=9)
        self.assertAlmostEqual(1 / Fm, 100.0, places=9)

    def test_ex_C3_encoder_resolution(self):
        res = 2 * math.pi / 2 ** 12
        self.assertAlmostEqual(res, 1.534e-3, places=6)
        self.assertAlmostEqual(math.degrees(res), 0.0879, places=4)
        self.assertAlmostEqual(res / 50, 3.068e-5, places=7)
        self.assertAlmostEqual(res / 100, 1.534e-5, places=7)
        self.assertAlmostEqual(res / 1e-5, 153.4, places=2)  # threshold kr

    def test_ex_C4_camera_projection(self):
        omega_x, omega_y, x0, y0 = 8 * 79.2, 8 * 120.5, 250.0, 250.0
        pc = [0.05, -0.08, 0.6]
        x_i = omega_x * pc[0] + x0 * pc[2]
        y_i = omega_y * pc[1] + y0 * pc[2]
        self.assertAlmostEqual(x_i, 181.68, places=9)
        self.assertAlmostEqual(y_i, 72.88, places=9)
        self.assertAlmostEqual(x_i / pc[2], 302.80, places=2)
        self.assertAlmostEqual(y_i / pc[2], 121.47, places=2)

    def test_ex_C5_sonar_temperature(self):
        t = 12.0e-3
        for temp, dist in ((0, 1.9884), (20, 2.0604), (25, 2.0784)):
            self.assertAlmostEqual((331.4 + 0.6 * temp) * t / 2, dist, places=4)
        self.assertAlmostEqual(2 * 1.5 / (331.4 + 0.6 * 20) * 1e3, 8.736, places=3)

    def test_ex_C6_force_couple(self):
        r = [0.1, 0, -0.15]
        f_s = [0, 0, 30]
        self.assertEqual(mat_vec(skew(r), f_s), [0, -3, 0])

    def test_mock16_generator_numbers(self):
        Ra, kv, Im, Fm, ki = 1.2, 0.11, 2.0e-5, 5.0e-6, 0.80
        self.assertAlmostEqual(1 / kv, 9.09, places=2)
        self.assertAlmostEqual(Ra * Im / (kv * kv), 1.98e-3, places=5)
        self.assertAlmostEqual(kv / (ki * Fm), 2.75e4, places=1)
        self.assertAlmostEqual(Im / Fm, 4.0, places=6)
        self.assertAlmostEqual(Ra / (kv * kv), 99.2, places=1)
        self.assertAlmostEqual(1 / Fm, 2.0e5, places=3)

    def test_mock17_gear_numbers(self):
        Im, I, Fm, F, Cl = 2.0e-4, 6.0, 1.0e-4, 0.20, 40.0
        ieq = Im + I / 80 ** 2
        feq = Fm + F / 80 ** 2
        self.assertAlmostEqual(ieq, 1.138e-3, places=6)
        self.assertAlmostEqual(feq, 1.313e-4, places=6)
        self.assertAlmostEqual((I / 6400) / ieq, 0.824, places=3)
        self.assertAlmostEqual((F / 6400) / feq, 0.238, places=3)
        self.assertAlmostEqual(Cl / 80, 0.5, places=9)
        self.assertAlmostEqual(Im + I / 8 ** 2, 9.395e-2, places=6)
        self.assertAlmostEqual(Cl / 8, 5.0, places=9)

    def test_mock18_encoder_tracks(self):
        self.assertEqual(2 ** 14, 16384)
        self.assertAlmostEqual(360 / 2 ** 14, 0.02197, places=5)
        self.assertAlmostEqual(360 / (2 ** 14 * 50), 4.395e-4, places=7)


if __name__ == "__main__":
    unittest.main(verbosity=2)
