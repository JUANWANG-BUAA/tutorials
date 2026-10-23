# -*- coding: utf-8 -*-
"""2D 激光扫描匹配（ICP / 高斯-牛顿法）与鲁棒核函数。"""

from __future__ import annotations

import math
from typing import Optional, Tuple
import numpy as np
from scipy.spatial import cKDTree
from car_slam.types import SE2


class ScanMatcher2D:
    """基于 SE(2) 李代数扰动模型与 KD 树最近邻的高斯-牛顿点云配准器。"""

    def __init__(self,
                 max_iterations: int = 30,
                 tolerance: float = 1e-4,
                 max_correspondence_dist: float = 0.5,
                 huber_k: float = 0.1):
        self.max_iterations = max_iterations
        self.tolerance = tolerance
        self.max_correspondence_dist = max_correspondence_dist
        self.huber_k = huber_k

    def huber_weight(self, r_norm: float) -> float:
        """Huber 鲁棒核函数的权重因子 w(r) = psi'(r) / r。"""
        if r_norm <= self.huber_k:
            return 1.0
        return self.huber_k / max(r_norm, 1e-8)

    def align_svd(self, source_pts: np.ndarray, target_pts: np.ndarray) -> SE2:
        """已知严格一一对应关系下的 2D Arun SVD 闭式解。"""
        assert len(source_pts) == len(target_pts) and len(source_pts) >= 2
        mu_s = np.mean(source_pts, axis=0)
        mu_t = np.mean(target_pts, axis=0)
        s_prime = source_pts - mu_s
        t_prime = target_pts - mu_t

        W = s_prime.T @ t_prime  # (2, 2)
        U, _, Vt = np.linalg.svd(W)
        R = Vt.T @ U.T
        if np.linalg.det(R) < 0:
            Vt[1, :] *= -1
            R = Vt.T @ U.T

        theta = math.atan2(R[1, 0], R[0, 0])
        t = mu_t - R @ mu_s
        return SE2(t[0], t[1], theta)

    def match(self,
              source_pts: np.ndarray,
              target_pts: np.ndarray,
              initial_guess: Optional[SE2] = None) -> Tuple[SE2, bool, float]:
        r"""将 source_pts 配准到 target_pts（目标参考点云）。
        
        状态流形：T \in SE(2)
        残差：e_i(T) = T * p_i - q_i \in R^2
        左乘扰动 \xi = [\delta x, \delta y, \delta \theta]^T:
            \partial e_i / \partial \xi = [ I_{2x2},  [- (R p_i)_y,  (R p_i)_x]^T ]
        
        返回：(估计相对变换 T_target_source, 是否收敛, 最终均方根残差)
        """
        if len(source_pts) < 5 or len(target_pts) < 5:
            return initial_guess or SE2(), False, float("inf")

        kdtree = cKDTree(target_pts)
        T_cur = initial_guess if initial_guess is not None else SE2()

        last_error = float("inf")
        converged = False

        for it in range(self.max_iterations):
            # 将当前 source 点变换至 target 坐标系
            transformed_pts = T_cur.transform_points(source_pts)
            dists, indices = kdtree.query(transformed_pts, k=1)

            # 剔除距离过大的异常值
            valid_mask = dists < self.max_correspondence_dist
            n_inliers = np.sum(valid_mask)
            if n_inliers < 5:
                break

            inlier_dists = dists[valid_mask]
            inlier_source = source_pts[valid_mask]
            inlier_target = target_pts[indices[valid_mask]]

            # 累积正规方程 H \Delta \xi = b
            H = np.zeros((3, 3), dtype=float)
            b = np.zeros(3, dtype=float)
            total_weighted_loss = 0.0

            # 变换后的点坐标 q_i = R * p_i + t
            c, s = math.cos(T_cur.theta), math.sin(T_cur.theta)
            R = np.array([[c, -s], [s, c]])
            q_all = (inlier_source @ R.T) + np.array([T_cur.x, T_cur.y])

            # 残差向量 r_i = q_i - target_i
            res = q_all - inlier_target

            for i in range(n_inliers):
                r = res[i]
                r_norm = math.sqrt(r[0] * r[0] + r[1] * r[1])
                w = self.huber_weight(r_norm)

                # 左乘李代数扰动雅可比 J_i (2 x 3)：力臂由全局变换后的点坐标 q 决定
                qx, qy = q_all[i, 0], q_all[i, 1]
                J = np.array([
                    [1.0, 0.0, -qy],
                    [0.0, 1.0,  qx]
                ], dtype=float)

                H += w * (J.T @ J)
                b += -w * (J.T @ r)
                total_weighted_loss += w * (r_norm ** 2)

            # 求解阻尼高斯-牛顿步长
            H_damped = H + 1e-4 * np.eye(3)
            try:
                delta_xi = np.linalg.solve(H_damped, b)
            except np.linalg.LinAlgError:
                break

            # 扰动更新：T_new = exp(delta_xi) * T_cur
            dT = SE2.exp(delta_xi)
            T_cur = dT @ T_cur

            rmse = math.sqrt(total_weighted_loss / n_inliers)
            step_norm = np.linalg.norm(delta_xi)

            if step_norm < self.tolerance or abs(last_error - rmse) < 1e-6:
                converged = True
                break

            last_error = rmse

        final_pts = T_cur.transform_points(source_pts)
        dists, _ = kdtree.query(final_pts, k=1)
        final_rmse = float(np.mean(dists[dists < self.max_correspondence_dist] ** 2) ** 0.5) if np.any(dists < self.max_correspondence_dist) else float("inf")
        return T_cur, converged, final_rmse
