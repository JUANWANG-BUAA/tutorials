#!/usr/bin/env python3
"""Numerically verify the chapter-3 analytic Jacobians by central differences.

Run from any directory: python3 robot/tools/verify_ch03_jac.py
Scope:
  - mixed R/P chains       (all-origin velocity recursion, sec 3.1)
  - fixed tool offsets     (position/angular blocks and expression frames)
  - rotation derivatives   (base and body angular-velocity components)
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
import random
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


def analytic_geometric(dh_list, q, tool=None):
    """Column-by-column geometric Jacobian from the cumulative T matrices."""
    ts = chain(dh_list, q)
    endpoint = mat_mul(ts[-1], tool) if tool is not None else ts[-1]
    pe = [endpoint[i][3] for i in range(3)]
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
    def test_revolute_relative_translation_is_not_constant(self):
        theta, rate, length, offset = math.pi / 2, 0.5, 0.8, 0.2
        plus = dh_joint(theta + EPS * rate, offset, length, 0.3)
        minus = dh_joint(theta - EPS * rate, offset, length, 0.3)
        derivative = [(plus[axis][3] - minus[axis][3]) / (2 * EPS) for axis in range(3)]
        for actual, expected in zip(derivative, (-0.4, 0.0, 0.0)):
            self.assertAlmostEqual(actual, expected, places=8)
        self.assertGreater(math.hypot(*derivative), 0.39)

    def test_mixed_dh_velocity_recursion_against_fk(self):
        generator = random.Random(310)
        for sample in range(60):
            dh = [(generator.uniform(-1, 1), generator.uniform(-0.5, 0.5),
                   generator.uniform(0.1, 1), generator.uniform(-2, 2), kind)
                  for kind in ("r", "p", "r", "p")]
            angles = [generator.uniform(-1, 1) for _ in dh]
            rates = [generator.uniform(-2, 2) for _ in dh]
            transforms = chain(dh, angles)
            plus = chain(dh, [value + EPS * rate for value, rate in zip(angles, rates)])
            minus = chain(dh, [value - EPS * rate for value, rate in zip(angles, rates)])
            velocity = [0.0] * 3
            omega = [0.0] * 3
            for joint, (theta_off, offset, length, alpha, kind) in enumerate(dh):
                previous = transforms[joint]
                theta = theta_off + (angles[joint] if kind == "r" else 0)
                local_r = [length * math.cos(theta), length * math.sin(theta),
                           offset + (angles[joint] if kind == "p" else 0)]
                local_dot = ([-rates[joint] * local_r[1], rates[joint] * local_r[0], 0]
                             if kind == "r" else [0, 0, rates[joint]])
                base_r = [sum(previous[row][col] * local_r[col] for col in range(3))
                          for row in range(3)]
                base_dot = [sum(previous[row][col] * local_dot[col] for col in range(3))
                            for row in range(3)]
                transport = cross(omega, base_r)
                velocity = [velocity[axis] + base_dot[axis] + transport[axis] for axis in range(3)]
                if kind == "r":
                    omega = [omega[axis] + rates[joint] * previous[axis][2] for axis in range(3)]
                transform = transforms[joint + 1]
                derivative = [[(plus[joint + 1][row][col] - minus[joint + 1][row][col]) / (2 * EPS)
                               for col in range(3)] for row in range(3)]
                skew = mat_mul(derivative, [[transform[col][row] for col in range(3)] for row in range(3)])
                numeric_omega = [skew[2][1], skew[0][2], skew[1][0]]
                with self.subTest(sample=sample, joint=joint):
                    for axis in range(3):
                        numeric_velocity = (plus[joint + 1][axis][3] - minus[joint + 1][axis][3]) / (2 * EPS)
                        self.assertAlmostEqual(velocity[axis], numeric_velocity, places=7)
                        self.assertAlmostEqual(omega[axis], numeric_omega[axis], places=7)
            columns, angular = analytic_geometric(dh, angles)
            for axis in range(3):
                self.assertAlmostEqual(velocity[axis], sum(columns[joint][axis] * rates[joint] for joint in range(4)), places=10)
                self.assertAlmostEqual(omega[axis], sum(angular[joint][axis] * rates[joint] for joint in range(4)), places=10)

    def test_tool_point_and_expression_frame(self):
        dh = [(0.2, 0.1, 0.7, 0.6, "r"), (-0.4, 0.3, 0.2, -0.8, "p"),
              (0.1, 0.2, 0.5, 0.4, "r")]
        angles = [0.3, 0.4, -0.7]
        tool = mat_mul(mat_mul(trans_x(0.4), trans_z(0.2)), rot_x(0.7))
        columns, angular = analytic_geometric(dh, angles, tool)
        original, original_angular = analytic_geometric(dh, angles)

        def endpoint(values):
            return mat_mul(chain(dh, values)[-1], tool)

        def position(values):
            return [row[3] for row in endpoint(values)[:3]]

        def rotation(values):
            return [row[:3] for row in endpoint(values)[:3]]

        self.assertLess(max_err(columns, numeric_jp(position, angles)), 1e-8)
        self.assertLess(max_err(angular, numeric_jo(rotation, angles)), 1e-8)
        self.assertEqual(angular, original_angular)
        self.assertEqual(columns[1], original[1])
        self.assertGreater(max_err(columns, original), 0.1)
        base_to_u = mat_mul(rot_x(0.9), rot_z(-0.4))

        def express(vector):
            return [sum(base_to_u[row][col] * vector[col] for col in range(3)) for row in range(3)]

        self.assertLess(max_err([express(col) for col in columns], numeric_jp(lambda values: express(position(values)), angles)), 1e-8)
        self.assertLess(max_err([express(col) for col in angular], numeric_jo(lambda values: mat_mul([row[:3] for row in base_to_u[:3]], rotation(values)), angles)), 1e-8)

    def test_base_and_body_angular_velocity(self):
        angles, rates = [0.4, -0.6], [0.8, -0.3]

        def rotation(values):
            return [row[:3] for row in mat_mul(rot_z(values[0]), rot_x(values[1]))[:3]]

        current = rotation(angles)
        transpose = [[current[col][row] for col in range(3)] for row in range(3)]
        plus = rotation([value + EPS * rate for value, rate in zip(angles, rates)])
        minus = rotation([value - EPS * rate for value, rate in zip(angles, rates)])
        derivative = [[(plus[row][col] - minus[row][col]) / (2 * EPS) for col in range(3)] for row in range(3)]
        base_skew = mat_mul(derivative, transpose)
        body_skew = mat_mul(transpose, derivative)
        base = [base_skew[2][1], base_skew[0][2], base_skew[1][0]]
        body = [body_skew[2][1], body_skew[0][2], body_skew[1][0]]
        expected_base = [rates[1] * math.cos(angles[0]), rates[1] * math.sin(angles[0]), rates[0]]
        self.assertGreater(max(abs(base[axis] - body[axis]) for axis in range(3)), 0.1)
        for axis in range(3):
            self.assertAlmostEqual(base[axis], expected_base[axis], places=8)
            self.assertAlmostEqual(body[axis], sum(transpose[axis][col] * base[col] for col in range(3)), places=8)
        self.assertLess(max_err(derivative, mat_mul(base_skew, current)), 1e-8)

    def test_so3_bracket_and_euler_tangent(self):
        """Check the so(3) bracket and distinguish a tangent update from a rotation."""
        def hat(vector):
            x, y, z = vector
            return [[0.0, -z, y], [z, 0.0, -x], [-y, x, 0.0]]

        a, b = [1.0, -2.0, 0.5], [-0.3, 0.7, 1.2]
        left = mat_mul(hat(a), hat(b))
        right = mat_mul(hat(b), hat(a))
        bracket = [[left[row][col] - right[row][col] for col in range(3)] for row in range(3)]
        expected = hat(cross(a, b))
        self.assertLess(max_err(bracket, expected), 1e-12)
        ordinary = left
        self.assertGreater(max(abs(ordinary[row][col] + ordinary[col][row])
                               for row in range(3) for col in range(3)), 0.1)
        omega = [0.0, 0.0, 2.0]
        h = 0.5
        tangent = [[(1.0 if row == col else 0.0) + h * hat(omega)[row][col]
                    for col in range(3)] for row in range(3)]
        gram = mat_mul([[tangent[col][row] for col in range(3)] for row in range(3)], tangent)
        self.assertGreater(max(abs(gram[row][col] - (1.0 if row == col else 0.0))
                               for row in range(3) for col in range(3)), 0.5)

    def test_rz_worked_derivative(self):
        """Reproduce the section's alpha=pi/2, alpha_dot=2 worked example."""
        angle, rate = math.pi / 2, 2.0
        current = [[math.cos(angle), -math.sin(angle), 0.0],
                   [math.sin(angle), math.cos(angle), 0.0], [0.0, 0.0, 1.0]]
        derivative = [[-rate * math.sin(angle), -rate * math.cos(angle), 0.0],
                      [rate * math.cos(angle), -rate * math.sin(angle), 0.0], [0.0, 0.0, 0.0]]
        transpose = [[current[col][row] for col in range(3)] for row in range(3)]
        skew = mat_mul(derivative, transpose)
        self.assertEqual(skew, [[0.0, -2.0, 0.0], [2.0, 0.0, 0.0], [0.0, 0.0, 0.0]])
        self.assertLess(max_err(derivative, [[-2.0, 0.0, 0.0], [0.0, -2.0, 0.0], [0.0, 0.0, 0.0]]), 1e-14)

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

    def test_two_link_cross_chapter_case(self) -> None:
        """Verify both IK branches, orientations, Jacobians and velocity answers."""
        dh = [(0.0, 0.0, 1.0, 0.0, "r"), (0.0, 0.0, 1.0, 0.0, "r")]
        cases = (
            (
                (0.0, math.pi / 2),
                ((-1.0, -1.0), (1.0, 0.0)),
                math.pi / 2,
                (0.0, -0.1),
                (0.1, 0.0),
            ),
            (
                (math.pi / 2, -math.pi / 2),
                ((-1.0, 0.0), (1.0, 1.0)),
                0.0,
                (0.0, 0.1),
                (0.0, 0.1),
            ),
        )
        for angles, expected_jacobian, heading, rates, velocity in cases:
            with self.subTest(angles=angles):
                position = fk_pos(dh)(angles)
                self.assertAlmostEqual(position[0], 1.0)
                self.assertAlmostEqual(position[1], 1.0)
                rotation = fk_rot(dh)(angles)
                self.assertAlmostEqual(math.atan2(rotation[1][0], rotation[0][0]), heading)
                columns, _ = analytic_geometric(dh, angles)
                for row in range(2):
                    for col in range(2):
                        self.assertAlmostEqual(columns[col][row], expected_jacobian[row][col])
                    actual = sum(columns[col][row] * rates[col] for col in range(2))
                    self.assertAlmostEqual(actual, velocity[row])
                self.assertLess(max_err(columns, numeric_jp(fk_pos(dh), angles)), 1e-8)

    def test_two_link_singular_directions(self) -> None:
        """Separate unavailable radial motion from nonunique tangent motion."""
        dh = [(0.0, 0.0, 1.0, 0.0, "r"), (0.0, 0.0, 1.0, 0.0, "r")]
        columns, _ = analytic_geometric(dh, (0.0, 0.0))
        self.assertEqual(columns, [[0.0, 2.0, 0.0], [0.0, 1.0, 0.0]])
        for rates in ((0.0, 0.1), (0.05, 0.0)):
            self.assertAlmostEqual(sum(columns[col][0] * rates[col] for col in range(2)), 0.0)
            self.assertAlmostEqual(sum(columns[col][1] * rates[col] for col in range(2)), 0.1)
        null_rates = (1.0, -2.0)
        for row in range(2):
            self.assertAlmostEqual(sum(columns[col][row] * null_rates[col] for col in range(2)), 0.0)

    def test_two_link_static_reaction_and_power(self) -> None:
        """Check actuator sign using lever arms and nonzero virtual power."""
        dh = [(0.0, 0.0, 1.0, 0.0, "r"), (0.0, 0.0, 1.0, 0.0, "r")]
        angles = (0.0, math.pi / 2)
        columns, _ = analytic_geometric(dh, angles)
        transforms = chain(dh, angles)
        output_force = (0.0, 10.0)
        torques = [sum(column[row] * output_force[row] for row in range(2)) for column in columns]
        self.assertAlmostEqual(torques[0], 10.0)
        self.assertAlmostEqual(torques[1], 0.0)
        for joint in range(2):
            lever_x = transforms[-1][0][3] - transforms[joint][0][3]
            lever_y = transforms[-1][1][3] - transforms[joint][1][3]
            moment = lever_x * output_force[1] - lever_y * output_force[0]
            self.assertAlmostEqual(torques[joint], moment)
            reaction_torque = sum(-columns[joint][row] * output_force[row] for row in range(2))
            self.assertAlmostEqual(torques[joint] + reaction_torque, 0.0)
        for rates, expected_power in (((0.0, -0.1), 0.0), ((0.1, -0.1), 1.0)):
            velocity = [sum(columns[col][row] * rates[col] for col in range(2)) for row in range(2)]
            joint_power = sum(torques[col] * rates[col] for col in range(2))
            output_power = sum(output_force[row] * velocity[row] for row in range(2))
            self.assertAlmostEqual(joint_power, expected_power)
            self.assertAlmostEqual(joint_power, output_power)
            if expected_power:
                self.assertNotAlmostEqual(-joint_power, output_power)

    def test_two_link_damping_tradeoff(self) -> None:
        """Check DLS stationarity, speed bound and inaccessible directions."""
        dh = [(0.0, 0.0, 1.0, 0.0, "r"), (0.0, 0.0, 1.0, 0.0, "r")]
        for angles in ((0.0, 0.0), (0.0, 0.01), (0.4, 0.8)):
            columns, _ = analytic_geometric(dh, angles)
            for target in ((0.1, 0.0), (0.0, 0.1)):
                previous_speed = math.inf
                previous_error = -math.inf
                for damping in (0.1, 0.5):
                    with self.subTest(angles=angles, target=target, damping=damping):
                        metric_xx = sum(column[0] ** 2 for column in columns) + damping**2
                        metric_xy = sum(column[0] * column[1] for column in columns)
                        metric_yy = sum(column[1] ** 2 for column in columns) + damping**2
                        determinant = metric_xx * metric_yy - metric_xy**2
                        self.assertGreater(determinant, 0.0)
                        dual = (
                            (metric_yy * target[0] - metric_xy * target[1]) / determinant,
                            (metric_xx * target[1] - metric_xy * target[0]) / determinant,
                        )
                        rates = [sum(column[row] * dual[row] for row in range(2)) for column in columns]
                        velocity = [sum(columns[col][row] * rates[col] for col in range(2)) for row in range(2)]
                        residual = [velocity[row] - target[row] for row in range(2)]
                        for col in range(2):
                            gradient = damping**2 * rates[col] + sum(columns[col][row] * residual[row] for row in range(2))
                            self.assertAlmostEqual(gradient, 0.0, places=10)
                        speed = math.hypot(*rates)
                        error = math.hypot(*residual)
                        self.assertLessEqual(speed, math.hypot(*target) / (2 * damping) + 1e-10)
                        self.assertLessEqual(speed, previous_speed + 1e-10)
                        self.assertGreaterEqual(error + 1e-10, previous_error)
                        previous_speed, previous_error = speed, error
                        if angles == (0.0, 0.0):
                            self.assertAlmostEqual(velocity[0], 0.0)
                            if target[0]:
                                self.assertAlmostEqual(speed, 0.0)
                            else:
                                self.assertAlmostEqual(rates[0], 0.2 / (5 + damping**2))
                                self.assertAlmostEqual(rates[1], 0.1 / (5 + damping**2))

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

    def test_position_task_loses_rotation_at_shoulder_axis(self):
        q = (0.0, math.pi / 2, 0.0)
        jp, jo = analytic_geometric(ANTHRO_DH, q)
        # A waist rotation leaves endpoint position unchanged, but rotates its frame.
        self.assertLess(max(abs(x) for x in jp[0]), 1e-12)
        self.assertEqual(jo[0], [0.0, 0.0, 1.0])
        self.assertLess(max_err(jp, numeric_jp(fk_pos(ANTHRO_DH), q)), 1e-8)
        self.assertLess(max_err(jo, numeric_jo(fk_rot(ANTHRO_DH), q)), 1e-8)

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

    def test_stanford_compact_axes_and_wrist_blocks(self):
        """Check the lesson's compact directions against DH transforms and FK."""
        generator = random.Random(323)
        for sample in range(30):
            q = [generator.uniform(-math.pi, math.pi) for _ in range(6)]
            q[2] = generator.uniform(0.1, 1.0)
            c1, s1 = math.cos(q[0]), math.sin(q[0])
            c2, s2 = math.cos(q[1]), math.sin(q[1])
            c4, s4 = math.cos(q[3]), math.sin(q[3])
            c5, s5 = math.cos(q[4]), math.sin(q[4])
            u = [c1 * c2, s1 * c2, -s2]
            v = [-s1, c1, 0.0]
            w = [c1 * s2, s1 * s2, c2]
            t = [c4 * u[i] + s4 * v[i] for i in range(3)]
            z4 = [-s4 * u[i] + c4 * v[i] for i in range(3)]
            z5 = [s5 * t[i] + c5 * w[i] for i in range(3)]
            axes = [[0.0, 0.0, 1.0], v, w, w, z4, z5]
            wrist = [0.2 * v[i] + q[2] * w[i] for i in range(3)]
            endpoint = [wrist[i] + 0.1 * z5[i] for i in range(3)]
            columns = [cross(axes[0], endpoint), cross(v, endpoint), w,
                       [0.1 * s5 * z4[i] for i in range(3)],
                       [0.1 * (c5 * t[i] - s5 * w[i]) for i in range(3)],
                       [0.0, 0.0, 0.0]]
            angular = [axes[0], v, [0.0, 0.0, 0.0], w, z4, z5]
            transforms = chain(STANFORD_DH, q)
            with self.subTest(sample=sample):
                self.assertLess(max_err(axes, [[transforms[j][i][2] for i in range(3)] for j in range(6)]), 1e-12)
                for joint in (3, 4, 5):
                    self.assertLess(max(abs(transforms[joint][i][3] - wrist[i]) for i in range(3)), 1e-12)
                self.assertLess(max(abs(transforms[6][i][3] - endpoint[i]) for i in range(3)), 1e-12)
                self.assertLess(max_err(columns, numeric_jp(fk_pos(STANFORD_DH), q)), 1e-8)
                self.assertLess(max_err(angular, numeric_jo(fk_rot(STANFORD_DH), q)), 1e-8)

    def test_stanford_mixed_rates_and_changed_tool_point(self):
        """Verify the worked 6x6 matrix and the independent offset exercise."""
        q = (0.0, math.pi / 2, 0.6, 0.0, math.pi / 2, 0.0)
        published = [[-0.2, -0.1, 1, 0, -0.1, 0],
                     [0.6, 0, 0, 0.1, 0, 0], [0, -0.6, 0, 0, 0, 0],
                     [0, 0, 0, 1, 0, 0], [0, 1, 0, 0, 1, 0],
                     [1, 0, 0, 0, 0, -1]]
        for tool_length, expected_velocity in ((0.1, [0.0, 0.0, 0.0]), (0.0, [0.1, 0.0, 0.0])):
            dh = list(STANFORD_DH)
            dh[-1] = (0.0, tool_length, 0.0, 0.0, "r")
            linear = numeric_jp(fk_pos(dh), q)
            angular = numeric_jo(fk_rot(dh), q)
            if tool_length:
                rows = [[linear[j][i] for j in range(6)] for i in range(3)]
                rows += [[angular[j][i] for j in range(6)] for i in range(3)]
                self.assertLess(max_err(rows, published), 1e-8)
            rates = (0.0, 0.0, 0.1, 0.0, 1.0, 0.0)
            for axis in range(3):
                self.assertAlmostEqual(sum(linear[j][axis] * rates[j] for j in range(6)), expected_velocity[axis], places=8)
                self.assertAlmostEqual(sum(angular[j][axis] * rates[j] for j in range(6)), [0.0, 1.0, 0.0][axis], places=8)


if __name__ == "__main__":
    unittest.main(verbosity=2)
