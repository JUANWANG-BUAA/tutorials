#!/usr/bin/env python3
"""Regression checks for the chapter-4 trajectory closed forms.

Run from any directory: python3 robot/tools/verify_ch04_traj.py
Groups follow the numbering referenced across ch04 pages:
  1  textbook Fig. 4.1 cubic           (exercises C1)
  2  textbook Fig. 4.3 LSPB            (exercises C2)
  3  waypoint velocity rule            (exercises C3)
  4  quintic 4.1                       (homework 4.1)
  5  cubic spline 4.5 with virtual pts (homework 4.5, errata E4.7)
  6  linear + parabolic blends 4.6     (homework 4.6)
Only the Python standard library is used.
"""

import math
import unittest
from fractions import Fraction

F = Fraction


def cubic(t, a):
    return sum(a[i] * t ** i for i in range(len(a)))


def dcubic(t, a):
    return sum(i * a[i] * t ** (i - 1) for i in range(1, len(a)))


def ddcubic(t, a):
    return sum(i * (i - 1) * a[i] * t ** (i - 2) for i in range(2, len(a)))


def solve3(rows, rhs):
    """Exact 3x3 solve with Fractions."""
    m = [list(map(F, r)) + [F(v)] for r, v in zip(rows, rhs)]
    for col in range(3):
        piv = next(r for r in range(col, 3) if m[r][col] != 0)
        m[col], m[piv] = m[piv], m[col]
        inv = m[col][col]
        m[col] = [x / inv for x in m[col]]
        for r in range(3):
            if r != col and m[r][col] != 0:
                factor = m[r][col]
                m[r] = [x - factor * y for x, y in zip(m[r], m[col])]
    return [m[i][3] for i in range(3)]


class Trajectory(unittest.TestCase):
    def test_group1_textbook_cubic(self):
        # q(t) = -2πt³ + 3πt²; π factors out, so verify the scaled polynomial
        # s(t) = 3t² - 2t³ (q = π·s) exactly.
        s = [F(0), F(0), F(3), F(-2)]
        self.assertEqual(cubic(0, s), 0)
        self.assertEqual(cubic(1, s), 1)
        self.assertEqual(dcubic(0, s), 0)
        self.assertEqual(dcubic(1, s), 0)
        # peak velocity at t=1/2 is 3/2·π; accelerations ±6π at the ends.
        self.assertEqual(dcubic(F(1, 2), s), F(3, 2))
        self.assertEqual(ddcubic(0, s), 6)
        self.assertEqual(ddcubic(1, s), -6)

    def test_group2_textbook_lspb(self):
        qf, tf, acc = math.pi, 1.0, 6 * math.pi
        disc = tf ** 2 * acc - 4 * qf
        tc = tf / 2 - 0.5 * math.sqrt(disc / acc)
        self.assertAlmostEqual(tc, 0.5 - 1 / (2 * math.sqrt(3)), places=12)
        self.assertAlmostEqual(math.sqrt(disc / acc), 1 / math.sqrt(3), places=12)
        vc = acc * tc
        self.assertAlmostEqual(vc, 3.983, places=3)
        self.assertGreater(vc, qf / tf)          # above mean speed
        self.assertLessEqual(vc, 2 * qf / tf)    # below twice mean
        # Piecewise position: continuity and total displacement.
        def q(t):
            if t <= tc:
                return 0.5 * acc * t * t
            if t <= tf - tc:
                return vc * (t - tc / 2)
            return qf - 0.5 * acc * (tf - t) ** 2
        self.assertAlmostEqual(q(tc), 0.5 * acc * tc ** 2, places=12)
        self.assertAlmostEqual(q(tc + 1e-9), vc * (tc + 1e-9 - tc / 2), places=6)
        self.assertAlmostEqual(q(tf), qf, places=12)
        # Triangle limit: |acc| = 4·|Δq|/tf² ⇒ tc = tf/2, cruise vanishes.
        acc_tri = 4 * math.pi
        disc_tri = acc_tri - 4 * math.pi
        self.assertAlmostEqual(disc_tri, 0.0, places=12)
        self.assertAlmostEqual(tf / 2 - 0.0, tf / 2, places=12)

    def test_group3_waypoint_velocity_rule(self):
        q = [0.0, 2 * math.pi, math.pi / 2, math.pi]
        t = [0.0, 2.0, 3.0, 5.0]
        slopes = [(q[k + 1] - q[k]) / (t[k + 1] - t[k]) for k in range(3)]
        self.assertAlmostEqual(slopes[0], math.pi, places=12)
        self.assertAlmostEqual(slopes[1], -1.5 * math.pi, places=12)
        self.assertAlmostEqual(slopes[2], math.pi / 4, places=12)
        # Rule (4.12): opposite signs ⇒ zero velocity at the interior points.
        for k in (1, 2):
            left, right = slopes[k - 1], slopes[k]
            self.assertLessEqual(left * right, 0.0)
        # Same-sign case: velocity is the average of the two slopes.
        self.assertAlmostEqual((1.0 + 0.5) / 2, 0.75, places=12)

    def test_group4_quintic_4_1(self):
        # q(t) = 1 + 15/4 t³ - 45/16 t⁴ + 9/16 t⁵
        a = [F(1), F(0), F(0), F(15, 4), F(-45, 16), F(9, 16)]
        self.assertEqual(cubic(0, a), 1)
        self.assertEqual(cubic(2, a), 4)
        self.assertEqual(dcubic(0, a), 0)
        self.assertEqual(dcubic(2, a), 0)
        self.assertEqual(ddcubic(0, a), 0)
        self.assertEqual(ddcubic(2, a), 0)
        # Normalised 10-15-6 form: s(η)=10η³-15η⁴+6η⁵ hits 0 at η=0 and 1 at η=1;
        # expanding 1 + 3·s(t/2) reproduces the coefficients above.
        for eta_num, expected in ((F(1), F(1)), (F(0), F(0))):
            self.assertEqual(10 * eta_num ** 3 - 15 * eta_num ** 4 + 6 * eta_num ** 5,
                             expected)
        s2 = [F(1), F(0), F(0), 3 * F(10) / 8, 3 * F(-15) / 16, 3 * F(6) / 32]
        self.assertEqual([cubic(0, s2), cubic(2, s2)], [F(1), F(4)])
        self.assertEqual(s2[3:], [F(15, 4), F(-45, 16), F(9, 16)])

    def test_group5_spline_4_5(self):
        # Corrected system (errata E4.7): rows from q3=2, q5=3, v5=0.
        rows = ([F(1), F(1, 6), F(0)],
                [F(2), F(11, 6), F(1)],
                [F(1), F(1), F(1)])
        a2, a3, a4 = solve3(rows, [2, 1, 0])
        self.assertEqual((a2, a3, a4), (F(9, 4), F(-3, 2), F(-3, 4)))
        # Recursion for node velocities and virtual-point values.
        v = [F(0), a2 / 2, None, None, F(0)]
        v[2] = v[1] + (a2 + a3) / 2
        v[3] = v[2] + (a3 + a4) / 2
        self.assertEqual(v[4], v[3] + (a4 + F(0)) / 2)  # v5 = 0 exact
        self.assertEqual((v[1], v[2], v[3]), (F(9, 8), F(3, 2), F(3, 8)))
        q2 = a2 / 6
        q4 = F(2) + v[2] + a3 / 2 + (a4 - a3) / 6
        self.assertEqual(q2, F(3, 8))
        self.assertEqual(q4, F(23, 8))
        # Published segment table (τ = t - t_k on each unit interval).
        segs = {
            1: [F(0), F(0), F(0), F(3, 8)],
            2: [F(3, 8), F(9, 8), F(9, 8), F(-5, 8)],
            3: [F(2), F(3, 2), F(-3, 4), F(1, 8)],
            4: [F(23, 8), F(3, 8), F(-3, 8), F(1, 8)],
        }
        # Interpolation at path points.
        self.assertEqual(cubic(0, segs[1]), 0)
        self.assertEqual(cubic(1, segs[2]), 2)
        self.assertEqual(cubic(1, segs[4]), 3)
        # Virtual-point values emerge from continuity, not specification.
        self.assertEqual(cubic(1, segs[1]), q2)
        self.assertEqual(cubic(1, segs[3]), q4)
        # Endpoint velocity and acceleration are zero.
        for coeffs in (segs[1], segs[4]):
            if coeffs is segs[1]:
                self.assertEqual(dcubic(0, coeffs), 0)
                self.assertEqual(ddcubic(0, coeffs), 0)
            else:
                self.assertEqual(dcubic(1, coeffs), 0)
                self.assertEqual(ddcubic(1, coeffs), 0)
        # C0/C1/C2 continuity at t = 1, 2, 3.
        for k in (1, 2, 3):
            left, right = segs[k], segs[k + 1]
            self.assertEqual(cubic(1, left), cubic(0, right))
            self.assertEqual(dcubic(1, left), dcubic(0, right))
            self.assertEqual(ddcubic(1, left), ddcubic(0, right))
        # Node accelerations match the solved system.
        self.assertEqual(ddcubic(1, segs[1]), a2)
        self.assertEqual(ddcubic(1, segs[2]), a3)
        self.assertEqual(ddcubic(1, segs[3]), a4)
        # The superseded 51/23 solve violates the final-velocity condition.
        bad = (F(51, 23), F(-30, 23), F(-18, 23))
        v5_bad = bad[0] + bad[1] + bad[2]  # a2 + a3 + a4 (sum = -v5 chain residue)
        self.assertNotEqual(v5_bad, 0)
        self.assertEqual(F(v5_bad), F(3, 23))

    def test_group6_blends_4_6(self):
        dq = 0.2  # Δt'_k for all three blends
        vprev = [F(0), F(1), F(1, 2)]   # incoming slope at points 1,2,3
        vnext = [F(1), F(1, 2), F(0)]   # outgoing slope at points 1,2,3
        qk = [F(0), F(2), F(3)]
        for k in range(3):
            b1 = (vnext[k] + vprev[k]) / 2
            b2 = (vnext[k] - vprev[k]) / (2 * F(dq).limit_denominator(10))
            b0 = qk[k] + (vnext[k] - vprev[k]) * F(dq).limit_denominator(10) / 8
            if k == 0:
                self.assertEqual((b0, b1, b2), (F(1, 40), F(1, 2), F(5, 2)))
            elif k == 1:
                self.assertEqual((b0, b1, b2), (F(159, 80), F(3, 4), F(-5, 4)))
            else:
                self.assertEqual((b0, b1, b2), (F(239, 80), F(1, 4), F(-5, 4)))
            # Vertex deviation from the path point (the "via point" offset).
            self.assertEqual(abs(qk[k] - b0),
                             abs((vnext[k] - vprev[k]) * F(dq).limit_denominator(10) / 8))
        # Deviations at points 2 and 3 are both 0.0125.
        self.assertEqual(F(2) - F(159, 80), F(1, 80))
        self.assertEqual(F(3) - F(239, 80), F(1, 80))
        self.assertEqual(float(F(1, 80)), 0.0125)
        # Position/velocity continuity of blend 2 against both linear pieces:
        # linear 1: q = 0 + 1·τ ends at the blend start; blend 2 sits on [2-0.1, 2+0.1].
        lin1 = lambda t: 1 * t                     # segment [0, 2]
        lin2 = lambda t: 2 + F(1, 2) * (t - 2)      # segment [2, 4]
        blend2 = lambda s: F(159, 80) + F(3, 4) * s + F(-5, 4) * s * s
        dblend2 = lambda s: F(3, 4) + 2 * F(-5, 4) * s
        half = F(dq).limit_denominator(10) / 2      # 0.1
        t_mid = F(2)
        # blend coordinate s = t - 2; check s = -0.1 and s = +0.1
        for s_edge, lin, t_val in ((F(-1, 10), lin1, t_mid - half),
                                   (F(1, 10), lin2, t_mid + half)):
            self.assertEqual(blend2(s_edge), lin(t_val))
            self.assertEqual(dblend2(s_edge), F(1) if lin is lin1 else F(1, 2))


if __name__ == "__main__":
    unittest.main(verbosity=2)
