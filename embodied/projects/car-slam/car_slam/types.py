# -*- coding: utf-8 -*-
"""SE(2) 刚体变换与传感器基础数据结构。"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import List, Optional, Tuple
import numpy as np


class SE2:
    """二维特殊欧氏群 SE(2) 的流形表示。"""

    def __init__(self, x: float = 0.0, y: float = 0.0, theta: float = 0.0):
        self.x = float(x)
        self.y = float(y)
        # 规约至 [-pi, pi)
        self.theta = (float(theta) + math.pi) % (2.0 * math.pi) - math.pi

    @classmethod
    def from_matrix(cls, T: np.ndarray) -> SE2:
        theta = math.atan2(T[1, 0], T[0, 0])
        return cls(T[0, 2], T[1, 2], theta)

    @classmethod
    def exp(cls, xi: np.ndarray) -> SE2:
        """李代数 se(2) 到 SE(2) 的指数映射。xi = [dx, dy, dtheta]^T"""
        dx, dy, dth = float(xi[0]), float(xi[1]), float(xi[2])
        if abs(dth) < 1e-7:
            return cls(dx, dy, dth)
        s, c = math.sin(dth), math.cos(dth)
        V = np.array([[s / dth, -(1.0 - c) / dth],
                      [(1.0 - c) / dth, s / dth]])
        t = V @ np.array([dx, dy])
        return cls(t[0], t[1], dth)

    def log(self) -> np.ndarray:
        """SE(2) 到李代数 se(2) 的对数映射。返回 [dx, dy, dtheta]^T"""
        dth = self.theta
        if abs(dth) < 1e-7:
            return np.array([self.x, self.y, dth], dtype=float)
        s, c = math.sin(dth), math.cos(dth)
        half_th = 0.5 * dth
        A = (half_th * (1.0 + c)) / s
        V_inv = np.array([[half_th * s / (1.0 - c), half_th],
                          [-half_th, half_th * s / (1.0 - c)]])
        t = V_inv @ np.array([self.x, self.y])
        return np.array([t[0], t[1], dth], dtype=float)

    def to_matrix(self) -> np.ndarray:
        c, s = math.cos(self.theta), math.sin(self.theta)
        return np.array([
            [c, -s, self.x],
            [s,  c, self.y],
            [0.0, 0.0, 1.0]
        ], dtype=float)

    def inverse(self) -> SE2:
        c, s = math.cos(self.theta), math.sin(self.theta)
        inv_x = -(c * self.x + s * self.y)
        inv_y = -(-s * self.x + c * self.y)
        return SE2(inv_x, inv_y, -self.theta)

    def __matmul__(self, other: SE2) -> SE2:
        c, s = math.cos(self.theta), math.sin(self.theta)
        new_x = self.x + c * other.x - s * other.y
        new_y = self.y + s * other.x + c * other.y
        return SE2(new_x, new_y, self.theta + other.theta)

    def transform_point(self, pt: np.ndarray) -> np.ndarray:
        """变换 2D 点 pt = [x, y]"""
        c, s = math.cos(self.theta), math.sin(self.theta)
        return np.array([
            self.x + c * pt[0] - s * pt[1],
            self.y + s * pt[0] + c * pt[1]
        ], dtype=float)

    def transform_points(self, pts: np.ndarray) -> np.ndarray:
        """变换 Nx2 点集"""
        c, s = math.cos(self.theta), math.sin(self.theta)
        R = np.array([[c, -s], [s, c]])
        t = np.array([self.x, self.y])
        return (pts @ R.T) + t

    def to_vector(self) -> np.ndarray:
        return np.array([self.x, self.y, self.theta], dtype=float)

    def __repr__(self) -> str:
        return f"SE2(x={self.x:.3f}, y={self.y:.3f}, th={math.degrees(self.theta):.2f}°)"


@dataclass
class LaserScan:
    """2D 激光扫描数据帧。"""
    timestamp: float
    angle_min: float
    angle_max: float
    angle_increment: float
    range_min: float
    range_max: float
    ranges: np.ndarray  # (N,)

    def to_points(self) -> np.ndarray:
        """转为传感器局部笛卡儿坐标点 (M, 2)，已过滤非法测距。"""
        angles = self.angle_min + np.arange(len(self.ranges)) * self.angle_increment
        valid = (self.ranges >= self.range_min) & (self.ranges <= self.range_max) & np.isfinite(self.ranges)
        r = self.ranges[valid]
        th = angles[valid]
        xs = r * np.cos(th)
        ys = r * np.sin(th)
        return np.column_stack((xs, ys))


@dataclass
class PoseGraphEdge:
    """位姿图边，约束顶点 i 与 j 之间的相对位姿。"""
    i: int
    j: int
    measurement: SE2
    information: np.ndarray  # (3, 3) 协方差逆矩阵
    is_loop_closure: bool = False
