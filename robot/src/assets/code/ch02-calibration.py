"""Exercise D2: nonlinear, identifiable 2R calibration with rank diagnostics."""
import json

import numpy as np

NOMINAL = np.array([1.0, 0.8, 0.0])
TRUTH = np.array([1.004, 0.797, 0.006])  # m, m, rad
SCALES = np.array([0.01, 0.01, 0.01])   # 1 cm, 1 cm, 10 mrad
SIGMA = 0.00005                        # independent position noise, m


def predict(parameters, joints):
    a1, a2, beta = parameters
    first = joints[:, 0] + beta
    second = first + joints[:, 1]
    return np.column_stack((a1 * np.cos(first) + a2 * np.cos(second),
                            a1 * np.sin(first) + a2 * np.sin(second)))


def sensitivity(parameters, joints):
    first = joints[:, 0] + parameters[2]
    second = first + joints[:, 1]
    position = predict(parameters, joints)
    matrix = np.empty((2 * len(joints), 3))
    matrix[0::2] = np.column_stack((np.cos(first), np.cos(second), -position[:, 1]))
    matrix[1::2] = np.column_stack((np.sin(first), np.sin(second), position[:, 0]))
    return matrix


def diagnostics(parameters, joints):
    matrix = sensitivity(parameters, joints) * SCALES
    singular = np.linalg.svd(matrix, compute_uv=False)
    rank = int(np.linalg.matrix_rank(matrix))
    condition = float(singular[0] / singular[-1]) if rank == 3 else float("inf")
    return rank, condition


def fit(joints, measured):
    parameters = NOMINAL.copy()
    costs = []
    for _ in range(30):
        residual = (measured - predict(parameters, joints)).ravel()
        matrix = sensitivity(parameters, joints) * SCALES
        scaled_step, _, rank, _ = np.linalg.lstsq(matrix, residual, rcond=None)
        if rank < 3:
            raise ValueError("量测不足或参数不可辨识：不能宣称唯一恢复三个参数")
        cost = float(residual @ residual)
        costs.append(cost)
        if np.linalg.norm(scaled_step) < 1e-9:
            return parameters, costs
        step = scaled_step * SCALES
        accepted = False
        for fraction in (1, 0.5, 0.25, 0.125, 0.0625, 0.03125):
            candidate = parameters + fraction * step
            if min(candidate[:2]) <= 0:
                continue
            next_residual = (measured - predict(candidate, joints)).ravel()
            if float(next_residual @ next_residual) <= cost * (1 + 1e-12):
                parameters, accepted = candidate, True
                break
        if not accepted:
            raise RuntimeError("本次更新未降低残差；需调整步长或检查初值")
    raise RuntimeError("超过迭代上限，不能按已收敛处理")


def local_covariance(parameters, joints):
    """Local small-noise approximation, not a guarantee for any single noise sample."""
    matrix = sensitivity(parameters, joints) * SCALES
    if np.linalg.matrix_rank(matrix) < 3:
        raise ValueError("秩不足，不能给出有限的三参数协方差")
    _, singular, right = np.linalg.svd(matrix, full_matrices=False)
    factor = SCALES[:, None] * right.T / singular
    return SIGMA ** 2 * (factor @ factor.T)


def main():
    rng = np.random.default_rng(211)
    training = rng.uniform([-1.5, -2.0], [1.5, 2.0], (60, 2))
    validation = rng.uniform([-1.4, -1.8], [1.4, 1.8], (80, 2))
    exact, trace = fit(training, predict(TRUTH, training))
    assert np.max(np.abs(exact - TRUTH)) < 1e-10
    noisy = predict(TRUTH, training) + rng.normal(0, SIGMA, (60, 2))
    estimated, noisy_trace = fit(training, noisy)
    validation_rms = float(np.sqrt(np.mean((predict(estimated, validation) - predict(TRUTH, validation)) ** 2)))
    narrow = np.column_stack((np.linspace(-1.5, 1.5, 60), np.linspace(0.7, 0.701, 60)))
    degenerate = np.column_stack((np.linspace(-1.5, 1.5, 60), np.zeros(60)))
    rejected = []
    for label, joints in (("one_pose", training[:1]), ("same_second_angle", degenerate)):
        try:
            fit(joints, predict(TRUTH, joints))
        except ValueError:
            rejected.append(label)
        else:
            raise AssertionError(label + " 未报告秩不足")
    predicted_std = np.sqrt(np.diag(local_covariance(TRUTH, training)))
    samples = [fit(training, predict(TRUTH, training) + rng.normal(0, SIGMA, (60, 2)))[0]
               for _ in range(200)]
    empirical_std = np.std(samples, axis=0, ddof=1)
    print(json.dumps({
        "truth_m_m_rad": TRUTH.tolist(), "noiseless_estimate": exact.tolist(),
        "iterations": len(trace), "noisy_estimate": estimated.tolist(),
        "noisy_cost_trace": noisy_trace, "validation_rms_m": validation_rms,
        "wide_rank_condition": diagnostics(TRUTH, training),
        "narrow_rank_condition": diagnostics(TRUTH, narrow), "rejected": rejected,
        "local_std_m_m_rad": predicted_std.tolist(),
        "empirical_std_m_m_rad": empirical_std.tolist(),
        "empirical_to_local_ratio": (empirical_std / predicted_std).tolist()
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
