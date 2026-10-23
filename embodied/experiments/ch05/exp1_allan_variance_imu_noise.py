# -*- coding: utf-8 -*-
"""实验 5.1：MEMS IMU 静态仿真数据与 Allan 方差分析（角度随机游走与零偏不稳定性）。"""

import numpy as np


def compute_allan_variance(omega: np.ndarray, fs: float, max_cluster_factor: int = 100):
    """计算离散角速度序列的 Allan 方差曲线。"""
    theta = np.cumsum(omega) / fs  # 角度积分序列
    N = len(theta)

    taus = []
    allan_vars = []

    # 簇大小 m 从 1 到 N // 10
    max_m = N // max_cluster_factor
    m_list = np.unique(np.logspace(0, np.log10(max_m), num=30).astype(int))

    for m in m_list:
        tau = m / fs
        # 簇间平均差分
        diffs = theta[2*m : N : m] - 2.0 * theta[m : N - m : m] + theta[0 : N - 2*m : m]
        if len(diffs) > 0:
            sigma2 = np.mean(diffs**2) / (2.0 * (tau**2))
            taus.append(tau)
            allan_vars.append(sigma2)

    return np.array(taus), np.array(allan_vars)


def main():
    print("=== 实验 5.1：Allan 方差分析 MEMS IMU 噪声项 ===")
    np.random.seed(42)

    fs = 100.0  # 100 Hz
    duration = 3600.0  # 1 小时连续采样
    N = int(fs * duration)

    # 预设理论噪声参数
    # 角度随机游走 N_arw = 0.05 deg / sqrt(hr)
    N_true = np.radians(0.05 / 60.0)  # rad / s^(1/2)
    # 陀螺零偏随机游走 (Bias Instability)
    B_true = np.radians(0.01 / 3600.0)

    # 仿真合成陀螺仪信号：高斯白噪声 + 随机游走零偏
    white_noise = np.random.normal(0, N_true * np.sqrt(fs), size=N)
    random_walk_bias = np.cumsum(np.random.normal(0, B_true / np.sqrt(fs), size=N))
    omega_meas = white_noise + random_walk_bias

    taus, allan_vars = compute_allan_variance(omega_meas, fs)
    allan_dev = np.sqrt(allan_vars)

    # 在 tau = 1s 处的 Allan 偏差即为白噪声系数 N
    idx_1s = np.argmin(np.abs(taus - 1.0))
    N_est = allan_dev[idx_1s]

    print(f"设定白噪声 N_true: {N_true:.4e} rad/s^0.5")
    print(f"Allan 方差在 tau=1s 处估计值: {N_est:.4e} rad/s^0.5")
    print(f"最小 Allan 偏差（零偏不稳定性平台区）: {np.min(allan_dev):.4e} rad/s")


if __name__ == "__main__":
    main()
