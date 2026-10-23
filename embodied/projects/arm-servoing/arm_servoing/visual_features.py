# -*- coding: utf-8 -*-
"""视觉特征表示与目标误差计算。"""

from __future__ import annotations

from dataclasses import dataclass
from typing import List, Tuple
import numpy as np
from arm_servoing.camera_model import PinholeCamera


@dataclass
class VisualTarget:
    """定义在工件/标靶自身坐标系下的三维几何特征点集合 (K, 3)。"""
    points_target: np.ndarray

    @classmethod
    def create_planar_square(cls, side_length: float = 0.2) -> VisualTarget:
        """创建边长为 side_length (m) 的正方形平面 4 特征点标靶。"""
        half = side_length / 2.0
        pts = np.array([
            [-half, -half, 0.0],
            [ half, -half, 0.0],
            [ half,  half, 0.0],
            [-half,  half, 0.0]
        ], dtype=float)
        return cls(points_target=pts)


class FeatureTracker:
    """视觉特征提取与归一化平面转换器。"""

    def __init__(self, camera: PinholeCamera):
        self.camera = camera

    def get_features_and_depths(self,
                                target: VisualTarget,
                                T_camera_target: np.ndarray) -> Tuple[List[Tuple[float, float]], List[float], np.ndarray]:
        r"""根据当前相机与标靶的相对位姿 T_c_t \in SE(3)，投影计算各特征点在相机坐标系下的坐标、深度与像素位置。
        
        返回：(features_norm, depths, pixels)
        """
        R = T_camera_target[:3, :3]
        t = T_camera_target[:3, 3]

        pts_cam = (target.points_target @ R.T) + t

        features_norm: List[Tuple[float, float]] = []
        depths: List[float] = []
        pixels: List[Tuple[float, float]] = []

        for pt in pts_cam:
            u, v, Z = self.camera.project_point(pt)
            xn, yn = self.camera.pixel_to_normalized(u, v)
            features_norm.append((xn, yn))
            depths.append(Z)
            pixels.append((u, v))

        return features_norm, depths, np.array(pixels, dtype=float)
