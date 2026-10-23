# -*- coding: utf-8 -*-
"""实验 12.1：SLAM 轨迹评估基准指标（ATE RMSE 与 RPE 相对位姿误差计算）。"""

import numpy as np


def align_trajectories_horn(est_pos: np.ndarray, gt_pos: np.ndarray):
    """基于 Horn 四元数/SVD 的 SE(3) 刚体最优配准（消除起始参考系差异）。"""
    mu_est = np.mean(est_pos, axis=0)
    mu_gt = np.mean(gt_pos, axis=0)

    P = est_pos - mu_est
    Q = gt_pos - mu_gt

    W = P.T @ Q
    U, _, Vt = np.linalg.svd(W)
    R = Vt.T @ U.T
    if np.linalg.det(R) < 0:
        Vt[2, :] *= -1
        R = Vt.T @ U.T

    t = mu_gt - R @ mu_est
    aligned_est = (est_pos @ R.T) + t
    return aligned_est, R, t


def compute_ate_rmse(aligned_est: np.ndarray, gt_pos: np.ndarray) -> float:
    diffs = aligned_est - gt_pos
    return float(np.sqrt(np.mean(np.sum(diffs**2, axis=1))))


def compute_rpe(est_pos: np.ndarray, gt_pos: np.ndarray, delta: int = 10) -> float:
    """计算步长为 delta 时的相对位姿误差 RPE。"""
    rpe_list = []
    for i in range(len(est_pos) - delta):
        # 估计位移增量
        d_est = est_pos[i + delta] - est_pos[i]
        d_gt = gt_pos[i + delta] - gt_pos[i]
        rpe_list.append(np.linalg.norm(d_est - d_gt))
    return float(np.sqrt(np.mean(np.array(rpe_list)**2)))


def main():
    print("=== 实验 12.1：ATE 绝对轨迹误差与 RPE 相对位姿误差测评 ===")
    np.random.seed(42)

    # 构造一条长 100 步的真实轨迹（沿圆形绕行）
    N = 100
    t = np.linspace(0, 2*np.pi, N)
    gt_trajectory = np.column_stack((10.0 * np.cos(t), 10.0 * np.sin(t), np.zeros(N)))

    # 模拟带累积漂移的 SLAM 估计轨迹（微小线性偏置 + 累加高斯漂移）
    drift = np.cumsum(np.random.normal(0, 0.05, size=(N, 3)), axis=0)
    # 起始参考系存在随机旋转与平移偏移
    R_init = np.array([
        [0.0, -1.0, 0.0],
        [1.0,  0.0, 0.0],
        [0.0,  0.0, 1.0]
    ])
    t_init = np.array([5.0, -3.0, 0.0])
    est_trajectory = ((gt_trajectory + drift) @ R_init.T) + t_init

    # 1. 轨迹刚体对齐
    aligned_est, R_align, t_align = align_trajectories_horn(est_trajectory, gt_trajectory)

    # 2. 指标结算
    ate_rmse = compute_ate_rmse(aligned_est, gt_trajectory)
    rpe_rmse = compute_rpe(aligned_est, gt_trajectory, delta=5)

    print(f"轨迹总步数: {N}")
    print(f"绝对轨迹均方根误差 (ATE RMSE): {ate_rmse:.4f} m")
    print(f"相对位姿误差 (RPE RMSE, delta=5): {rpe_rmse:.4f} m")


if __name__ == "__main__":
    main()
