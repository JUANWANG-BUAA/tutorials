# -*- coding: utf-8 -*-
"""实验 1.1：多传感器多坐标系变换树与刚体位姿变换链。"""

import numpy as np


def create_se3(R: np.ndarray, t: np.ndarray) -> np.ndarray:
    T = np.eye(4)
    T[:3, :3] = R
    T[:3, 3] = t
    return T


def invert_se3(T: np.ndarray) -> np.ndarray:
    R = T[:3, :3]
    t = T[:3, 3]
    T_inv = np.eye(4)
    T_inv[:3, :3] = R.T
    T_inv[:3, 3] = -R.T @ t
    return T_inv


def main():
    print("=== 实验 1.1：坐标系变换链计算 ===")
    # 世界系到机器人底盘：W -> B
    theta_wb = np.radians(30.0)
    R_wb = np.array([
        [np.cos(theta_wb), -np.sin(theta_wb), 0.0],
        [np.sin(theta_wb),  np.cos(theta_wb), 0.0],
        [0.0,              0.0,              1.0]
    ])
    t_wb = np.array([2.0, 1.5, 0.0])
    T_wb = create_se3(R_wb, t_wb)

    # 机器人底盘到相机（外参标定）：B -> C
    # 相机朝前微俯仰：X_c 右, Y_c 下, Z_c 前
    R_bc = np.array([
        [0.0,  0.0, 1.0],
        [-1.0, 0.0, 0.0],
        [0.0, -1.0, 0.0]
    ])
    t_bc = np.array([0.2, 0.0, 0.8])
    T_bc = create_se3(R_bc, t_bc)

    # 机器人底盘到激光雷达：B -> L
    R_bl = np.eye(3)
    t_bl = np.array([0.1, 0.0, 0.9])
    T_bl = create_se3(R_bl, t_bl)

    # 计算相机在世界坐标系下的绝对位姿 T_wc = T_wb * T_bc
    T_wc = T_wb @ T_bc
    print(f"相机世界坐标 t_wc: {T_wc[:3, 3]}")

    # 计算雷达到相机的相对外参 T_cl = T_cb * T_bl = inv(T_bc) * T_bl
    T_cb = invert_se3(T_bc)
    T_cl = T_cb @ T_bl
    print(f"雷达到相机相对变换 t_cl: {T_cl[:3, 3]}")

    # 点变换测试：雷达测得前方障碍物点 P_l = [2.0, 0.0, 0.0]^T
    p_l = np.array([2.0, 0.0, 0.0, 1.0])
    p_c = T_cl @ p_l
    p_w = T_wc @ p_c
    print(f"障碍物点在相机系坐标 P_c: {p_c[:3]}")
    print(f"障碍物点在世界系坐标 P_w: {p_w[:3]}")


if __name__ == "__main__":
    main()
