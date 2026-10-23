# -*- coding: utf-8 -*-
"""实验 7.1：对极几何本质矩阵分解（4 种姿态候选解）与手征性检验（正深度三角化）。"""

import numpy as np


def skew(t: np.ndarray) -> np.ndarray:
    return np.array([
        [0.0, -t[2], t[1]],
        [t[2], 0.0, -t[0]],
        [-t[1], t[0], 0.0]
    ])


def triangulate_point(R: np.ndarray, t: np.ndarray, x1: np.ndarray, x2: np.ndarray) -> np.ndarray:
    """线性 DLT 三角测量单点三维坐标。"""
    # x1 x (P1 X) = 0, x2 x (P2 X) = 0
    # P1 = [I | 0], P2 = [R | t]
    A = np.zeros((4, 4))
    A[0] = x1[0] * np.array([0, 0, 1, 0]) - np.array([1, 0, 0, 0])
    A[1] = x1[1] * np.array([0, 0, 1, 0]) - np.array([0, 1, 0, 0])
    P2 = np.hstack((R, t.reshape(3, 1)))
    A[2] = x2[0] * P2[2] - P2[0]
    A[3] = x2[1] * P2[2] - P2[1]
    _, _, Vt = np.linalg.svd(A)
    X = Vt[-1]
    return X[:3] / X[3]


def main():
    print("=== 实验 7.1：本质矩阵分解与手征性正深度检验 ===")
    np.random.seed(42)

    # 预设相机相对运动：沿 X 轴平移 0.5m，绕 Y 轴偏航 15 度
    theta = np.radians(15.0)
    R_gt = np.array([
        [ np.cos(theta), 0.0, np.sin(theta)],
        [ 0.0,           1.0, 0.0          ],
        [-np.sin(theta), 0.0, np.cos(theta)]
    ])
    t_gt = np.array([0.5, 0.0, 0.0])
    t_gt /= np.linalg.norm(t_gt)

    # 理论本质矩阵 E = [t]_x * R
    E_gt = skew(t_gt) @ R_gt

    # SVD 分解本质矩阵 E = U * diag(1, 1, 0) * V^T
    U, S, Vt = np.linalg.svd(E_gt)
    if np.linalg.det(U) < 0:
        U *= -1
    if np.linalg.det(Vt) < 0:
        Vt *= -1

    W = np.array([[0, -1, 0], [1, 0, 0], [0, 0, 1]])

    # 4 种数学候选解
    R1 = U @ W @ Vt
    R2 = U @ W.T @ Vt
    t1 = U[:, 2]
    t2 = -U[:, 2]

    candidates = [(R1, t1), (R1, t2), (R2, t1), (R2, t2)]

    # 空间测试点 P_w = [0.2, 0.1, 2.5]^T (均在两相机正前方)
    P_gt = np.array([0.2, 0.1, 2.5])
    x1 = P_gt / P_gt[2]
    P2_cam = R_gt @ P_gt + t_gt
    x2 = P2_cam / P2_cam[2]

    print("开始对手征性（Chirality Condition）进行判别：")
    valid_sol = None
    for idx, (R_cand, t_cand) in enumerate(candidates, 1):
        # 三角测量该点
        P_triangulated = triangulate_point(R_cand, t_cand, x1, x2)
        z1 = P_triangulated[2]
        P2_tri = R_cand @ P_triangulated + t_cand
        z2 = P2_tri[2]
        is_positive = (z1 > 0) and (z2 > 0)
        print(f"解 {idx}: 深度 z1={z1:.3f}, z2={z2:.3f} -> {'[有效物理真解]' if is_positive else '[无效虚解]'}")
        if is_positive:
            valid_sol = (R_cand, t_cand)

    R_est, t_est = valid_sol
    rot_err = np.linalg.norm(R_est - R_gt)
    trans_err = np.linalg.norm(t_est - t_gt)
    print(f"\n恢复旋转误差: {rot_err:.2e}, 平移方向误差: {trans_err:.2e}")


if __name__ == "__main__":
    main()
