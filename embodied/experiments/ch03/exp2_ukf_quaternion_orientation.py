# -*- coding: utf-8 -*-
"""实验 3.2：无迹卡尔曼滤波（UKF）与无迹变换（UT）参数整定对比。"""

import numpy as np


def unscented_transform(mean: np.ndarray, cov: np.ndarray, alpha: float = 1e-3, beta: float = 2.0, kappa: float = 0.0):
    n = len(mean)
    lambda_param = alpha**2 * (n + kappa) - n
    c = n + lambda_param

    sigma_points = np.zeros((2 * n + 1, n))
    sigma_points[0] = mean

    # 矩阵平方根 Cholesky 分解
    L = np.linalg.cholesky(c * cov)

    for i in range(n):
        sigma_points[i + 1] = mean + L[:, i]
        sigma_points[n + i + 1] = mean - L[:, i]

    # 权重向量
    w_m = np.zeros(2 * n + 1)
    w_c = np.zeros(2 * n + 1)
    w_m[0] = lambda_param / c
    w_c[0] = lambda_param / c + (1.0 - alpha**2 + beta)

    w_val = 1.0 / (2.0 * c)
    w_m[1:] = w_val
    w_c[1:] = w_val

    return sigma_points, w_m, w_c


def main():
    print("=== 实验 3.2：无迹变换 UT 准确性与非线性映射恢复 ===")
    np.random.seed(42)

    # 二维状态 x ~ N(mu, Sigma)
    mu = np.array([1.5, 2.5])
    cov = np.array([
        [0.4, 0.1],
        [0.1, 0.3]
    ])

    # 非线性测量函数：极坐标变换 [r, theta]^T
    def g(x):
        r = np.sqrt(x[0]**2 + x[1]**2)
        th = np.arctan2(x[1], x[0])
        return np.array([r, th])

    # 1. 蒙特卡洛抽样真值 (N=200,000)
    samples = np.random.multivariate_normal(mu, cov, size=200000)
    samples_y = np.array([g(s) for s in samples])
    mc_mean = np.mean(samples_y, axis=0)
    mc_cov = np.cov(samples_y, rowvar=False)

    # 2. 无迹变换 (UT, 仅需 2n+1 = 5 个点)
    sigma_pts, w_m, w_c = unscented_transform(mu, cov)
    y_pts = np.array([g(sp) for sp in sigma_pts])

    ut_mean = np.sum(w_m[:, None] * y_pts, axis=0)
    diff = y_pts - ut_mean
    ut_cov = diff.T @ np.diag(w_c) @ diff

    print(f"蒙特卡洛均值:   r={mc_mean[0]:.4f}, theta={mc_mean[1]:.4f}")
    print(f"无迹变换 UT 均值: r={ut_mean[0]:.4f}, theta={ut_mean[1]:.4f}")
    print(f"均值绝对误差:   dr={abs(mc_mean[0] - ut_mean[0]):.6f}, dtheta={abs(mc_mean[1] - ut_mean[1]):.6f}")

    print("\n蒙特卡洛协方差：\n", mc_cov)
    print("无迹变换 UT 协方差：\n", ut_cov)


if __name__ == "__main__":
    main()
