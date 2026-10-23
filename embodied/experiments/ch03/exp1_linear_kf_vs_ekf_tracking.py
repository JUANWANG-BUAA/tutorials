# -*- coding: utf-8 -*-
"""实验 3.1：雷达距离-方位角跟踪目标（线性 KF vs 扩展卡尔曼滤波 EKF 及 Joseph 形式对比）。"""

import math
import numpy as np


def main():
    print("=== 实验 3.1：目标跟踪 EKF 滤波与 Joseph 形式稳定性 ===")
    np.random.seed(42)

    dt = 0.1
    # 状态向量：x = [px, vx, py, vy]^T
    F = np.array([
        [1.0,  dt, 0.0, 0.0],
        [0.0, 1.0, 0.0, 0.0],
        [0.0, 0.0, 1.0,  dt],
        [0.0, 0.0, 0.0, 1.0]
    ])
    # 过程噪声
    q_var = 0.1
    Q = np.diag([0.25 * dt**4, dt**2, 0.25 * dt**4, dt**2]) * q_var

    # 观测噪声协方差 R (距离方差 0.5m^2, 方位角方差 (1 deg)^2)
    R = np.diag([0.5**2, np.radians(1.0)**2])

    # 初始状态与协方差
    x_true = np.array([10.0, 2.0, 15.0, -1.0])
    x_est = np.array([8.0, 0.0, 18.0, 0.0])
    P_est = np.diag([10.0, 5.0, 10.0, 5.0])

    errors_pos = []

    for step in range(50):
        # 1. 真实系统推进
        w = np.random.multivariate_normal(np.zeros(4), Q)
        x_true = F @ x_true + w

        # 2. 真实非线性观测：距离 r 与 方位角 theta
        r_true = math.hypot(x_true[0], x_true[2])
        th_true = math.atan2(x_true[2], x_true[0])
        v = np.random.multivariate_normal(np.zeros(2), R)
        z = np.array([r_true + v[0], th_true + v[1]])

        # 3. EKF 预测步
        x_prior = F @ x_est
        P_prior = F @ P_est @ F.T + Q

        # 4. EKF 更新步
        px, py = x_prior[0], x_prior[2]
        r_pred = math.hypot(px, py)
        th_pred = math.atan2(py, px)
        z_pred = np.array([r_pred, th_pred])

        # 观测雅可比 H (2 x 4)
        r2 = px**2 + py**2
        H = np.array([
            [px / r_pred, 0.0, py / r_pred, 0.0],
            [-py / r2,    0.0,  px / r2,    0.0]
        ])

        # 残差与角度规约
        y = z - z_pred
        y[1] = (y[1] + math.pi) % (2.0 * math.pi) - math.pi

        # 卡尔曼增益
        S = H @ P_prior @ H.T + R
        K = P_prior @ H.T @ np.linalg.inv(S)

        x_est = x_prior + K @ y

        # Joseph 形式保证协方差对称正定：P = (I - KH) P (I - KH)^T + K R K^T
        I_KH = np.eye(4) - K @ H
        P_est = I_KH @ P_prior @ I_KH.T + K @ R @ K.T

        err = math.hypot(x_est[0] - x_true[0], x_est[2] - x_true[2])
        errors_pos.append(err)

    print(f"初始定位误差: {errors_pos[0]:.3f} m")
    print(f"收敛后平均定位误差 (最后10步): {np.mean(errors_pos[-10:]):.3f} m")


if __name__ == "__main__":
    main()
