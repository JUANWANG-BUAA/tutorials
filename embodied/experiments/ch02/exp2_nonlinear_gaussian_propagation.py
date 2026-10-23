# -*- coding: utf-8 -*-
"""实验 2.2：强非线性测量函数对高斯分布的畸变与无偏性失效分析。"""

import numpy as np


def main():
    print("=== 实验 2.2：极坐标非线性观测高斯畸变与估计偏差 ===")
    np.random.seed(42)

    # 机器人真实位置 (x, y)，服从高斯分布
    mu_x = 1.0
    mu_y = 10.0
    sigma_x = 0.8
    sigma_y = 0.5
    Sigma = np.diag([sigma_x**2, sigma_y**2])

    # 传感器测量距离 r = sqrt(x^2 + y^2)
    # 1. 经典 EKF 一阶泰勒展开预测：
    # h(mu) = sqrt(mu_x^2 + mu_y^2)
    r_ekf_mean = np.sqrt(mu_x**2 + mu_y**2)
    H = np.array([[mu_x / r_ekf_mean, mu_y / r_ekf_mean]])
    # H 是 (1,2)，结果 (1,1)，用 .item() 取标量；NumPy 2 不再允许 float() 直接转换。
    r_ekf_var = float((H @ Sigma @ H.T).item())

    # 2. 蒙特卡洛 500,000 次真实非线性投影统计
    N = 500000
    samples = np.random.multivariate_normal([mu_x, mu_y], Sigma, size=N)
    samples_r = np.sqrt(samples[:, 0]**2 + samples[:, 1]**2)

    r_mc_mean = float(np.mean(samples_r))
    r_mc_var = float(np.var(samples_r))

    # 3. 二阶泰勒展开修正均值：
    # E[h(x)] \approx h(mu) + 0.5 * Tr(Hessian * Sigma)
    # d^2 r / dx^2 = y^2 / r^3, d^2 r / dy^2 = x^2 / r^3
    r3 = r_ekf_mean**3
    Hessian = np.array([
        [mu_y**2 / r3, -mu_x * mu_y / r3],
        [-mu_x * mu_y / r3, mu_x**2 / r3]
    ])
    r_second_order_mean = r_ekf_mean + 0.5 * np.trace(Hessian @ Sigma)

    print(f"一阶展开预测均值 (EKF):      {r_ekf_mean:.5f}, 方差: {r_ekf_var:.5f}")
    print(f"二阶修正预测均值:            {r_second_order_mean:.5f}")
    print(f"真实蒙特卡洛统计均值 (Ground): {r_mc_mean:.5f}, 方差: {r_mc_var:.5f}")
    print(f"一阶线性化导致的固有系统偏差: {abs(r_ekf_mean - r_mc_mean):.5f}")


if __name__ == "__main__":
    main()
