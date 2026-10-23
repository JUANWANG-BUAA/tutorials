# -*- coding: utf-8 -*-
"""针孔相机模型与齐次坐标投影。"""

from __future__ import annotations

from typing import Tuple
import numpy as np


class PinholeCamera:
    """标准针孔相机内参模型。"""

    def __init__(self,
                 fx: float = 600.0,
                 fy: float = 600.0,
                 cx: float = 320.0,
                 cy: float = 240.0,
                 width: int = 640,
                 height: int = 480):
        self.fx = float(fx)
        self.fy = float(fy)
        self.cx = float(cx)
        self.cy = float(cy)
        self.width = int(width)
        self.height = int(height)

        self.K = np.array([
            [self.fx, 0.0, self.cx],
            [0.0, self.fy, self.cy],
            [0.0, 0.0, 1.0]
        ], dtype=float)
        self.K_inv = np.linalg.inv(self.K)

    def project_point(self, point_camera: np.ndarray) -> Tuple[float, float, float]:
        """将相机坐标系三维点 (X, Y, Z) 投影至像素坐标 (u, v) 及归一化平面坐标 (xn, yn)。"""
        X, Y, Z = float(point_camera[0]), float(point_camera[1]), float(point_camera[2])
        if Z <= 1e-4:
            raise ValueError(f"三维点深度非法：Z={Z:.4f} <= 0")
        xn = X / Z
        yn = Y / Z
        u = self.fx * xn + self.cx
        v = self.fy * yn + self.cy
        return u, v, Z

    def pixel_to_normalized(self, u: float, v: float) -> Tuple[float, float]:
        """将像素坐标 (u, v) 反投影至归一化图像平面坐标 (xn, yn)。"""
        xn = (float(u) - self.cx) / self.fx
        yn = (float(v) - self.cy) / self.fy
        return xn, yn
