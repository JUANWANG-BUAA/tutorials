# -*- coding: utf-8 -*-
"""实验 5.2：误差状态卡尔曼滤波（ESKF）融合 100Hz IMU 与 10Hz GNSS/轮速计。"""

import math
import numpy as np


def main():
    print("=== 实验 5.2：ESKF 组合导航滤波融合 ===")
    np.random.seed(42)

    dt_imu = 0.01  # 100 Hz
    dt_gnss = 0.1  # 10 Hz

    # 标称名义状态：p (3), v (3), theta (1)
    # 误差状态：\delta x = [\delta p (3), \delta v (3), \delta \theta (1)]^T \in R^7
    p_nom = np.zeros(3)
    v_nom = np.zeros(3)
    theta_nom = 0.0

    P = np.diag([0.1**2]*3 + [0.05**2]*3 + [0.02**2])

    # 传感器噪声协方差
    Q_imu = np.diag([1e-4]*3 + [1e-3]*3 + [1e-4])
    R_gnss = np.diag([0.2**2, 0.2**2, 0.5**2])

    # 真实小车绕圆周运动：半径 20m，线速度 2.0 m/s -> 角速度 0.1 rad/s
    omega_true = 0.1
    v_lin_true = 2.0
    a_centripetal = v_lin_true * omega_true  # 向心加速度 0.2 m/s^2

    pos_errors = []

    steps = 500
    for s in range(steps):
        t = s * dt_imu
        th_true = omega_true * t
        p_true = np.array([20.0 * np.cos(th_true), 20.0 * np.sin(th_true), 0.0])
        v_true = np.array([-v_lin_true * np.sin(th_true), v_lin_true * np.cos(th_true), 0.0])

        # 模拟 IMU 测量（加速度计 + 陀螺仪带噪声）
        # 车体局部系下：前向线速度 v_x = 2.0，横向向心加速度 a_y = 0.2
        acc_body = np.array([0.0, a_centripetal, 0.0]) + np.random.normal(0, 0.05, 3)
        gyro_z = omega_true + np.random.normal(0, 0.01)

        # 1. 名义状态离散前向积分
        R_mat = np.array([
            [np.cos(theta_nom), -np.sin(theta_nom), 0.0],
            [np.sin(theta_nom),  np.cos(theta_nom), 0.0],
            [0.0,               0.0,              1.0]
        ])
        acc_world = R_mat @ acc_body
        p_nom += v_nom * dt_imu + 0.5 * acc_world * (dt_imu**2)
        v_nom += acc_world * dt_imu
        theta_nom += gyro_z * dt_imu

        # 2. 误差状态协方差传递：F 矩阵
        # \dot{\delta p} = \delta v
        # \dot{\delta v} = -[R a_b]_x \delta \theta
        # \dot{\delta \theta} = 0
        F = np.eye(7)
        F[:3, 3:6] = np.eye(3) * dt_imu
        # 旋转扰动对速度项的雅可比
        skew_acc = np.array([
            [-acc_world[1]],
            [ acc_world[0]],
            [ 0.0]
        ])
        F[3:6, 6:7] = skew_acc * dt_imu

        P = F @ P @ F.T + Q_imu * dt_imu

        # 3. GNSS 观测更新（10 Hz）
        if s % 10 == 0:
            p_gnss_meas = p_true + np.random.normal(0, [0.2, 0.2, 0.5])
            # 残差：y = z - h(x_nom)
            y = p_gnss_meas - p_nom

            # 观测雅可比 H (3 x 7)
            H = np.zeros((3, 7))
            H[:3, :3] = np.eye(3)

            S = H @ P @ H.T + R_gnss
            K = P @ H.T @ np.linalg.inv(S)

            delta_x = K @ y

            # 4. 误差状态注入名义状态并重置
            p_nom += delta_x[:3]
            v_nom += delta_x[3:6]
            theta_nom += delta_x[6]

            # 协方差更新
            P = (np.eye(7) - K @ H) @ P

        pos_errors.append(np.linalg.norm(p_nom - p_true))

    print(f"ESKF 组合导航 500 步运行完成：")
    print(f"最大位置误差: {np.max(pos_errors):.3f} m")
    print(f"最终平稳跟踪均方根误差 (RMSE): {np.sqrt(np.mean(np.array(pos_errors[-200:])**2)):.3f} m")


if __name__ == "__main__":
    main()
