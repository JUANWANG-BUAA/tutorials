# -*- coding: utf-8 -*-
"""图像相互作用矩阵（Interaction Matrix / 图像雅可比矩阵）与阻尼伪逆。"""

from __future__ import annotations

from typing import List, Tuple
import numpy as np


def point_interaction_matrix(x: float, y: float, Z: float) -> np.ndarray:
    r"""计算归一化平面单个特征点 (x, y) 处的图像相互作用矩阵 L_s \in R^{2x6}。
    
    相机空间速度旋量 v_c = [v_x, v_y, v_z, \omega_x, \omega_y, \omega_z]^T
    图像特征导数 \dot{s} = L_s * v_c:
        \dot{x} = -v_x/Z + x*v_z/Z + x*y*\omega_x - (1+x^2)*\omega_y + y*\omega_z
        \dot{y} = -v_y/Z + y*v_z/Z + (1+y^2)*\omega_x - x*y*\omega_y - x*\omega_z
    """
    assert Z > 1e-4, f"深度 Z 必须大于 0，当前 Z={Z}"
    inv_Z = 1.0 / Z
    return np.array([
        [-inv_Z,  0.0,    x * inv_Z,  x * y,        -(1.0 + x * x),  y],
        [0.0,    -inv_Z,  y * inv_Z,  1.0 + y * y,  -x * y,         -x]
    ], dtype=float)


def stacked_interaction_matrix(features_normalized: List[Tuple[float, float]],
                               depths: List[float]) -> np.ndarray:
    r"""堆叠多特征点的联合相互作用矩阵 L \in R^{2k x 6}。"""
    assert len(features_normalized) == len(depths) and len(depths) >= 3
    L_list = []
    for (x, y), Z in zip(features_normalized, depths):
        L_list.append(point_interaction_matrix(x, y, Z))
    return np.vstack(L_list)


def damped_pseudo_inverse(L: np.ndarray, damping: float = 1e-3) -> np.ndarray:
    r"""计算阻尼最小二乘伪逆 L^+ = L^T (L L^T + \mu^2 I)^{-1}，平滑规避运动学奇异点。"""
    rows, cols = L.shape
    if rows >= cols:
        # 超定方程：L^+ = (L^T L + \mu^2 I)^{-1} L^T
        return np.linalg.solve(L.T @ L + (damping ** 2) * np.eye(cols), L.T)
    else:
        # 欠定方程：L^+ = L^T (L L^T + \mu^2 I)^{-1}
        return L.T @ np.linalg.inv(L @ L.T + (damping ** 2) * np.eye(rows))
