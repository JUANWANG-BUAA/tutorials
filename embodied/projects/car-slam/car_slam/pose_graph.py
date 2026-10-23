# -*- coding: utf-8 -*-
"""SE(2) 流形位姿图优化器（Pose Graph Optimizer）与 Huber 鲁棒后端。"""

from __future__ import annotations

import math
from typing import Dict, List, Tuple
import numpy as np
from car_slam.types import SE2, PoseGraphEdge


def adjoint_se2(T: SE2) -> np.ndarray:
    r"""计算 SE(2) 元素的伴随变换矩阵 Ad_T \in R^{3x3}。"""
    c, s = math.cos(T.theta), math.sin(T.theta)
    return np.array([
        [c, -s,  T.y],
        [s,  c, -T.x],
        [0.0, 0.0, 1.0]
    ], dtype=float)


class PoseGraphOptimizer2D:
    """基于李代数李群与鲁棒核函数的二维位姿图优化器。"""

    def __init__(self, huber_threshold: float = 1.0):
        self.vertices: Dict[int, SE2] = {}
        self.edges: List[PoseGraphEdge] = []
        self.huber_threshold = huber_threshold

    def add_vertex(self, vertex_id: int, pose: SE2) -> None:
        self.vertices[vertex_id] = pose

    def add_edge(self, edge: PoseGraphEdge) -> None:
        self.edges.append(edge)

    def compute_edge_residual_and_jacobians(self, edge: PoseGraphEdge) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
        r"""计算单边相对位姿残差及两端顶点的雅可比矩阵。
        
        边残差定义：e_ij = \log( T_ij^{-1} * T_i^{-1} * T_j )^\vee \in R^3
        右乘扰动求导（T_i <- T_i * exp(\delta \xi_i), T_j <- T_j * exp(\delta \xi_j)）：
            J_i = - Ad(T_ij^{-1}) \in R^{3x3}
            J_j = I_{3x3}
        """
        Ti = self.vertices[edge.i]
        Tj = self.vertices[edge.j]
        Tij = edge.measurement

        # 理论预测相对位姿 T_pred = Ti^{-1} * Tj
        T_pred = Ti.inverse() @ Tj
        # 误差元素 T_err = Tij^{-1} * T_pred
        T_err = Tij.inverse() @ T_pred
        error_vec = T_err.log()

        # 雅可比计算（右乘流形扰动形式）
        Ji = -adjoint_se2(Tij.inverse())
        Jj = np.eye(3, dtype=float)

        return error_vec, Ji, Jj

    def optimize(self, max_iterations: int = 20, tolerance: float = 1e-4) -> Tuple[bool, float]:
        """执行阻尼高斯-牛顿迭代优化，顶点 0 固定为世界原点。"""
        n_vertices = len(self.vertices)
        if n_vertices <= 1:
            return True, 0.0

        vertex_ids = sorted(self.vertices.keys())
        id_to_idx = {vid: idx for idx, vid in enumerate(vertex_ids)}

        initial_cost = 0.0
        for edge in self.edges:
            e, _, _ = self.compute_edge_residual_and_jacobians(edge)
            initial_cost += float(e.T @ edge.information @ e)

        for iteration in range(max_iterations):
            dim = n_vertices * 3
            H = np.zeros((dim, dim), dtype=float)
            b = np.zeros(dim, dtype=float)

            total_chi2 = 0.0

            for edge in self.edges:
                idx_i = id_to_idx[edge.i]
                idx_j = id_to_idx[edge.j]

                e, Ji, Jj = self.compute_edge_residual_and_jacobians(edge)
                chi2 = float(e.T @ edge.information @ e)
                total_chi2 += chi2

                # Huber 鲁棒加权（尤其是针对可能存在误匹配的回环边）
                weight = 1.0
                r_norm = math.sqrt(chi2)
                if edge.is_loop_closure and r_norm > self.huber_threshold:
                    weight = self.huber_threshold / r_norm

                Omega = edge.information * weight

                # 累积子矩阵
                H_ii = Ji.T @ Omega @ Ji
                H_ij = Ji.T @ Omega @ Jj
                H_jj = Jj.T @ Omega @ Jj

                b_i = -Ji.T @ Omega @ e
                b_j = -Jj.T @ Omega @ e

                H[idx_i*3 : (idx_i+1)*3, idx_i*3 : (idx_i+1)*3] += H_ii
                H[idx_i*3 : (idx_i+1)*3, idx_j*3 : (idx_j+1)*3] += H_ij
                H[idx_j*3 : (idx_j+1)*3, idx_i*3 : (idx_i+1)*3] += H_ij.T
                H[idx_j*3 : (idx_j+1)*3, idx_j*3 : (idx_j+1)*3] += H_jj

                b[idx_i*3 : (idx_i+1)*3] += b_i
                b[idx_j*3 : (idx_j+1)*3] += b_j

            # 固定第一个顶点以消除尺度与坐标系规范自由度（Gauge Freedom）
            fixed_idx = id_to_idx[vertex_ids[0]]
            H[fixed_idx*3 : (fixed_idx+1)*3, :] = 0.0
            H[:, fixed_idx*3 : (fixed_idx+1)*3] = 0.0
            H[fixed_idx*3 : (fixed_idx+1)*3, fixed_idx*3 : (fixed_idx+1)*3] = np.eye(3) * 1e9
            b[fixed_idx*3 : (fixed_idx+1)*3] = 0.0

            # 阻尼增强正规方程条件数
            H_damped = H + 1e-6 * np.eye(dim)

            try:
                delta = np.linalg.solve(H_damped, b)
            except np.linalg.LinAlgError:
                return False, total_chi2

            # 更新各顶点流形状态（右乘局部摄动更新）
            max_step = 0.0
            for vid, idx in id_to_idx.items():
                if idx == fixed_idx:
                    continue
                d_xi = delta[idx*3 : (idx+1)*3]
                max_step = max(max_step, float(np.linalg.norm(d_xi)))
                self.vertices[vid] = self.vertices[vid] @ SE2.exp(d_xi)

            if max_step < tolerance:
                return True, total_chi2

        return True, total_chi2
