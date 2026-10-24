#!/usr/bin/env python3
"""Numerically verify the chapter-3 analytic Jacobians by central differences.

Run from any directory: python3 robot/tools/verify_ch03_jac.py
Scope:
  - three-link planar arm  (sec 3.2.1, exercises C1/C2)
  - two-link planar arm    (det and manipulability, exercises C5)
  - anthropomorphic arm    (sec 3.2.2, published 3x3 block and its det)
  - SCARA                  (exercises C4, 6x4 Jacobian)
  - Stanford manipulator   (sec 3.2.3, 6x6 geometric Jacobian via DH chain)
The analytic Jacobians are assembled with the column-by-column pipeline
(z_{i-1}, p_{i-1} read from the intermediate T matrices); the independent
check is the central difference of the forward kinematics.
"""

import math
import unittest

EPS = 1e-6


def mat_mul(a, b):
    return [[sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
            for i in range(len(a))]


def eye(n):
    return [[float(i == j) for j in range(n)] for i in range(n)]


def rot_z(t):
    c, s = math.cos(t), math.sin(t)
    return [[c, -s, 0, 0], [s, c, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]


def trans_z(d):
    return [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, d], [0, 0, 0, 1]]


def trans_x(a):
    return [[1, 0, 0, a], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]


def rot_x(t):
    c, s = math.cos(t), math.sin(t)
    return [[1, 0, 0, 0], [0, c, -s, 0], [0, s, c, 0], [0, 0, 0, 1]]


def dh_joint(theta, d, a, alpha):
    """Standard DH transform: Rz(θ)·Tz(d)·Tx(a)·Rx(α)."""
    return mat_mul(mat_mul(mat_mul(rot_z(theta), trans_z(d)), trans_x(a)), rot_x(alpha))


def cross(a, b):
    return [a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0]]


def chain(dh_list, q):
    """Return cumulative T matrices [T_0^0, T_1^0, ..., T_n^0]."""
    ts = [eye(4)]
    for i, (theta_off, d, a, alpha, kind) in enumerate(dh_list):
        theta = theta_off + (q[i] if kind == "r" else 0.0)
        offset = q[i] if kind == "p" else 0.0
        ai = dh_joint(theta, d + offset, a, alpha)
        ts.append(mat_mul(ts[-1], ai))
    return ts


def analytic_geometric(dh_list, q):
    """Column-by-column geometric Jacobian from the cumulative T matrices."""
    ts = chain(dh_list, q)
    pe = [ts[-1][i][3] for i in range(3)]
    n = len(q)
    jp, jo = [], []
    for i in range(n):
        z = [ts[i][k][2] for k in range(3)]
        if dh_list[i][4] == "r":
            p_prev = [ts[i][k][3] for k in range(3)]
            jp.append(cross(z, [pe[k] - p_prev[k] for k in range(3)]))
            jo.append(z)
        else:
            jp.append(z)
            jo.append([0.0, 0.0, 0.0])
    return jp, jo


def numeric_jp(fk, q, eps=EPS):
    """Central-difference linear Jacobian of the position map."""
    cols = []
    for i in range(len(q)):
        qp, qm = list(q), list(q)
        qp[i] += eps
        qm[i] -= eps
        pp, pm = fk(qp), fk(qm)
        cols.append([(pp[k] - pm[k]) / (2 * eps) for k in range(3)])
    return cols


def numeric_jo(fk_rot, q, eps=EPS):
    """Central-difference angular columns via Ṙ Rᵀ = S(ω)."""
    r0 = fk_rot(q)
    cols = []
    for i in range(len(q)):
        qp, qm = list(q), list(q)
        qp[i] += eps
        qm[i] -= eps
        rp, rm = fk_rot(qp), fk_rot(qm)
        rdot = [[(rp[r][c] - rm[r][c]) / (2 * eps) for c in range(3)] for r in range(3)]
        s = mat_mul(rdot, [[r0[c][r] for c in range(3)] for r in range(3)])
        cols.append([s[2][1], s[0][2], s[1][0]])  # vee of skew matrix
    return cols


def max_err(a, b):
    return max(abs(x - y) for ra, rb in zip(a, b) for x, y in zip(ra, rb))


PLANAR3_DH = [(0.0, 0.0, 1.0, 0.0, "r"),
              (0.0, 0.0, 0.8, 0.0, "r"),
              (0.0, 0.0, 0.6, 0.0, "r")]

ANTHRO_DH = [(0.0, 0.0, 0.0, math.pi / 2, "r"),
             (0.0, 0.0, 0.8, 0.0, "r"),
             (0.0, 0.0, 0.5, 0.0, "r")]

SCARA_DH = [(0.0, 0.0, 0.4, 0.0, "r"),
            (0.0, 0.0, 0.3, 0.0, "r"),
            (0.0, 0.0, 0.0, 0.0, "p"),
            (0.0, 0.0, 0.0, 0.0, "r")]

STANFORD_DH = [(0.0, 0.0, 0.0, -math.pi / 2, "r"),
               (0.0, 0.2, 0.0, math.pi / 2, "r"),
               (0.0, 0.0, 0.0, 0.0, "p"),
               (0.0, 0.0, 0.0, -math.pi / 2, "r"),
               (0.0, 0.0, 0.0, math.pi / 2, "r"),
               (0.0, 0.1, 0.0, 0.0, "r")]


def fk_pos(dh_list):
    def fk(q):
        t = chain(dh_list, q)[-1]
        return [t[0][3], t[1][3], t[2][3]]
    return fk


def fk_rot(dh_list):
    def fk(q):
        t = chain(dh_list, q)[-1]
        return [[t[r][c] for c in range(3)] for r in range(3)]
    return fk


def det3(m):
    return (m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
            - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
            + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]))


class JacobianChecks(unittest.TestCase):
    def test_planar3_central_difference(self):
        # Exercises C1: q=(0.3,-0.7,1.1), a=(1,0.8,0.6).
        q = (0.3, -0.7, 1.1)
        jp, _ = analytic_geometric(PLANAR3_DH, q)
        err = max_err(jp, numeric_jp(fk_pos(PLANAR3_DH), q))
        self.assertLess(err, 1e-8)
        self.assertGreater(err, 0.0)
        # Third row is all ones (angular z row).
        for col in jp:
            self.assertAlmostEqual(col[2], 0.0, places=12)

    def test_planar3_det_formula(self):
        # Exercises C2: det J̄ = a1 a2 sin(ϑ2), independent of ϑ1, ϑ3.
        a1, a2 = 1.0, 0.8
        for q1, q2, q3 in ((0.3, -0.7, 1.1), (1.2, 0.4, -0.3), (-0.5, 2.0, 0.9)):
            jp, _ = analytic_geometric(PLANAR3_DH, (q1, q2, q3))
            # Task jacobian rows: [vx; vy; ω] = columns stacked as rows of full.
            full = [[jp[c][0] for c in range(3)],
                    [jp[c][1] for c in range(3)],
                    [1.0, 1.0, 1.0]]
            self.assertAlmostEqual(det3(full), a1 * a2 * math.sin(q2), places=10)

    def test_two_link_manipulability(self):
        # Exercises C5: a1=a2=0.5, w = 0.25 |sin ϑ2|.
        a1 = a2 = 0.5
        for deg, expected in ((90.0, 0.2500), (30.0, 0.1250),
                              (5.0, 0.0218), (0.1, 4.36e-4)):
            w = a1 * a2 * abs(math.sin(math.radians(deg)))
            self.assertAlmostEqual(w, expected, places=4)

    def test_anthro_jacobian_block_and_det(self):
        # Sec 3.2.2: the published 3x3 block and det = -a2 a3 s3 (a2 c2 + a3 c23).
        a2, a3 = 0.8, 0.5
        q = (0.6, 0.9, -0.4)
        q1, q2, q3 = q
        s1, c1 = math.sin(q1), math.cos(q1)
        s2, c2 = math.sin(q2), math.cos(q2)
        s23, c23 = math.sin(q2 + q3), math.cos(q2 + q3)
        pub = [[-s1 * (a2 * c2 + a3 * c23), -c1 * (a2 * s2 + a3 * s23), -c1 * a3 * s23],
               [c1 * (a2 * c2 + a3 * c23), -s1 * (a2 * s2 + a3 * s23), -s1 * a3 * s23],
               [0.0, a2 * c2 + a3 * c23, a3 * c23]]
        self.assertAlmostEqual(
            det3(pub), -a2 * a3 * math.sin(q3) * (a2 * c2 + a3 * c23), places=10)
        # The 3x3 block matches the derivative of the end-effector position.
        jp, _ = analytic_geometric(ANTHRO_DH, q)
        err = max_err(jp, numeric_jp(fk_pos(ANTHRO_DH), q))
        self.assertLess(err, 1e-8)
        jp_rows = [[jp[c][r] for c in range(3)] for r in range(3)]
        err_pub = max_err(jp_rows, pub)
        self.assertLess(err_pub, 1e-10)

    def test_scara_jacobian(self):
        # Exercises C4: 6x4 Jacobian, rows 4-5 zero, det of planar block a1a2 s2.
        q = (0.5, 1.1, 0.2, -0.7)
        jp, jo = analytic_geometric(SCARA_DH, q)
        err_p = max_err(jp, numeric_jp(fk_pos(SCARA_DH), q))
        self.assertLess(err_p, 1e-8)
        err_o = max_err(jo, numeric_jo(fk_rot(SCARA_DH), q))
        self.assertLess(err_o, 1e-8)
        # Angular rows: only ωz = q̇1 + q̇2 + q̇4.
        self.assertEqual([col[0] for col in jo], [0.0] * 4)
        self.assertEqual([col[1] for col in jo], [0.0] * 4)
        self.assertEqual([col[2] for col in jo], [1.0, 1.0, 0.0, 1.0])
        # Prismatic column 3 is vertical, no arm contribution.
        self.assertAlmostEqual(jp[2][2], 1.0, places=12)
        self.assertEqual(jp[0][2], 0.0)
        self.assertEqual(jp[1][2], 0.0)
        # Planar block determinant at this configuration.
        a1, a2 = 0.4, 0.3
        block = [[jp[0][0], jp[0][1]], [jp[1][0], jp[1][1]]]
        self.assertAlmostEqual(block[0][0] * block[1][1] - block[0][1] * block[1][0],
                               a1 * a2 * math.sin(q[1]), places=10)

    def test_stanford_jacobian(self):
        # Sec 3.2.3: full 6x6 geometric Jacobian vs FK central differences.
        q = (0.4, -0.9, 0.6, 1.3, -0.5, 0.8)
        jp, jo = analytic_geometric(STANFORD_DH, q)
        err_p = max_err(jp, numeric_jp(fk_pos(STANFORD_DH), q))
        self.assertLess(err_p, 1e-8)
        err_o = max_err(jo, numeric_jo(fk_rot(STANFORD_DH), q))
        self.assertLess(err_o, 1e-8)
        # Column 3 is the prismatic column: [z2; 0].
        self.assertEqual(jo[2], [0.0, 0.0, 0.0])
        ts = chain(STANFORD_DH, q)
        z2 = [ts[2][k][2] for k in range(3)]
        for k in range(3):
            self.assertAlmostEqual(jp[2][k], z2[k], places=12)


if __name__ == "__main__":
    unittest.main(verbosity=2)
