"""Exercise C6: standard DH FK and planar 3R pose IK. Angles: rad; lengths: m."""
import json
import math

import numpy as np


def fk(dh, q):
    if len(dh) != len(q):
        raise ValueError("每行 DH 参数须对应一个关节变量")
    transform = np.eye(4)
    for (a, alpha, d, theta), joint in zip(dh, q):
        if (d is None) == (theta is None):
            raise ValueError("每行 d、角度中须恰有一项为 None")
        theta = joint if theta is None else theta
        d = joint if d is None else d
        if not all(math.isfinite(value) for value in (a, alpha, d, theta)):
            raise ValueError("DH 参数与关节变量必须有限")
        ct, st, ca, sa = math.cos(theta), math.sin(theta), math.cos(alpha), math.sin(alpha)
        transform = transform @ np.array([
            [ct, -st * ca, st * sa, a * ct],
            [st, ct * ca, -ct * sa, a * st],
            [0, sa, ca, d], [0, 0, 0, 1]])
    return transform


def wrap(angle):
    return math.atan2(math.sin(angle), math.cos(angle))


def planar_ik(lengths, target):
    """Return (kind, solutions); kind is finite, family or none. No joint limits."""
    a1, a2, a3 = lengths
    px, py, phi = target
    if not all(math.isfinite(value) for value in (*lengths, *target)):
        raise ValueError("杆长与目标必须有限")
    if a1 <= 0 or a2 <= 0 or a3 < 0:
        raise ValueError("前两杆须为正，第三杆允许为零")
    wx, wy = px - a3 * math.cos(phi), py - a3 * math.sin(phi)
    if wx == 0 and wy == 0:
        return ("family", []) if a1 == a2 else ("none", [])
    cosine = (wx * wx + wy * wy - a1 * a1 - a2 * a2) / (2 * a1 * a2)
    # Allow round-off at the cosine boundary, not an arbitrary workspace projection.
    tolerance = 64 * np.finfo(float).eps
    if abs(cosine) > 1 + tolerance:
        return "none", []
    cosine = float(np.clip(cosine, -1, 1))
    sine_magnitude = math.sqrt(max(0.0, 1 - cosine * cosine))
    solutions = []
    for sign in ((1, -1) if sine_magnitude > 0 else (1,)):
        sine = sign * sine_magnitude
        second = math.atan2(sine, cosine)
        first = math.atan2(wy, wx) - math.atan2(a2 * sine, a1 + a2 * cosine)
        solutions.append(tuple(wrap(angle) for angle in (first, second, phi - first - second)))
    return "finite", solutions


def folded_family(gamma, phi):
    """Only for equal first two lengths and a zero wrist center."""
    return gamma, math.pi, phi - gamma - math.pi


def pose(lengths, angles):
    transform = fk([(length, 0, 0, None) for length in lengths], angles)
    return np.array([transform[0, 3], transform[1, 3],
                     math.atan2(transform[1, 0], transform[0, 0])])


def pose_error(actual, target):
    return np.array([actual[0] - target[0], actual[1] - target[1], wrap(actual[2] - target[2])])


def numerical_example(lengths, target):
    """Two local solves; their success is checked, rather than presumed."""
    from scipy.optimize import least_squares

    solutions = []
    for initial in ((0.3, 1.2, -1.2), (1.3, -1.2, 0.2)):
        # Position error is divided by 1 m; orientation error by 1 rad in this example.
        result = least_squares(lambda angles: pose_error(pose(lengths, angles), target),
                               initial, ftol=1e-13, xtol=1e-13, gtol=1e-13,
                               max_nfev=300)
        if result.success and np.max(np.abs(result.fun)) < 1e-10:
            candidate = tuple(wrap(angle) for angle in result.x)
            if not any(max(abs(wrap(a - b)) for a, b in zip(candidate, old)) < 1e-7
                       for old in solutions):
                solutions.append(candidate)
    return solutions


def main():
    rng = np.random.default_rng(212)
    lengths = (1.0, 1.0, 0.5)
    largest = 0.0
    for _ in range(100):
        target = pose(lengths, rng.uniform(-2, 2, 3))
        kind, solutions = planar_ik(lengths, target)
        assert kind == "finite" and solutions
        for angles in solutions:
            largest = max(largest, float(np.max(np.abs(pose_error(pose(lengths, angles), target)))))
    assert largest < 1e-12
    target = (1.5, 1.0, 0.0)
    kind, analytic = planar_ik(lengths, target)
    numerical = numerical_example(lengths, target)
    assert kind == "finite" and len(analytic) == len(numerical) == 2
    assert all(any(max(abs(wrap(a - b)) for a, b in zip(angles, other)) < 1e-7
                   for other in numerical) for angles in analytic)
    assert planar_ik(lengths, (3.5, 0, 0))[0] == "none"
    assert planar_ik(lengths, (0.5, 0, 0))[0] == "family"
    assert planar_ik((1, 0.8, 0.5), (0.5, 0, 0))[0] == "none"
    for gamma in (-2, -0.3, 0, 1.7):
        assert np.max(np.abs(pose_error(pose(lengths, folded_family(gamma, 0)), (0.5, 0, 0)))) < 1e-12
    print(json.dumps({"random_targets": 100, "max_pose_error": largest,
                      "analytic_example": analytic, "numerical_example": numerical,
                      "zero_wrist": "family", "unequal_zero_wrist": "none"}, ensure_ascii=False))


if __name__ == "__main__":
    main()
