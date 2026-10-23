# -*- coding: utf-8 -*-
"""2D 占据栅格地图与 Bresenham 光线投射实现。"""

from __future__ import annotations

import math
from typing import List, Tuple
import numpy as np
from car_slam.types import SE2


class OccupancyGridMap:
    """对数几率（Log-odds）占据栅格地图。"""

    def __init__(self,
                 width: float = 30.0,
                 height: float = 30.0,
                 resolution: float = 0.05,
                 origin_x: float = -15.0,
                 origin_y: float = -15.0,
                 prob_hit: float = 0.7,
                 prob_miss: float = 0.4,
                 l_min: float = -5.0,
                 l_max: float = 5.0):
        self.resolution = float(resolution)
        self.origin_x = float(origin_x)
        self.origin_y = float(origin_y)
        self.width_cells = int(math.ceil(width / resolution))
        self.height_cells = int(math.ceil(height / resolution))

        # log-odds 增量
        self.l_hit = math.log(prob_hit / (1.0 - prob_hit))
        self.l_miss = math.log(prob_miss / (1.0 - prob_miss))
        self.l_min = float(l_min)
        self.l_max = float(l_max)

        # 栅格存储（对数几率，初值为 0，对应先验概率 0.5）
        self.grid = np.zeros((self.height_cells, self.width_cells), dtype=np.float32)

    def world_to_map(self, x: float, y: float) -> Tuple[int, int]:
        """世界物理坐标 (m) 转换为栅格索引 (col, row)。若越界则返回 (-1, -1)。"""
        col = int(math.floor((x - self.origin_x) / self.resolution))
        row = int(math.floor((y - self.origin_y) / self.resolution))
        if 0 <= col < self.width_cells and 0 <= row < self.height_cells:
            return col, row
        return -1, -1

    def map_to_world(self, col: int, row: int) -> Tuple[float, float]:
        """栅格索引 (col, row) 转换为中心世界物理坐标 (m)。"""
        x = self.origin_x + (col + 0.5) * self.resolution
        y = self.origin_y + (row + 0.5) * self.resolution
        return x, y

    @staticmethod
    def bresenham_line(x0: int, y0: int, x1: int, y1: int) -> List[Tuple[int, int]]:
        """整数 Bresenham 画线算法，返回从 (x0, y0) 到 (x1, y1) 的栅格单元序列（不含终点）。"""
        points = []
        dx = abs(x1 - x0)
        dy = abs(y1 - y0)
        sx = 1 if x0 < x1 else -1
        sy = 1 if y0 < y1 else -1
        err = dx - dy

        cx, cy = x0, y0
        while cx != x1 or cy != y1:
            points.append((cx, cy))
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                cx += sx
            if e2 < dx:
                err += dx
                cy += sy
        return points

    def update_scan(self, robot_pose: SE2, points_local: np.ndarray) -> None:
        """根据当前机器人位姿及局部激光点集，更新占据栅格地图的对数几率。"""
        if len(points_local) == 0:
            return

        r_col, r_row = self.world_to_map(robot_pose.x, robot_pose.y)
        if r_col < 0 or r_row < 0:
            return

        # 将点投影至世界坐标系
        pts_world = robot_pose.transform_points(points_local)

        for i in range(len(pts_world)):
            wx, wy = pts_world[i, 0], pts_world[i, 1]
            h_col, h_row = self.world_to_map(wx, wy)
            if h_col < 0 or h_row < 0:
                continue

            # 光束传播路径上为自由栅格（更新 miss）
            ray_cells = self.bresenham_line(r_col, r_row, h_col, h_row)
            for c, r in ray_cells:
                if 0 <= c < self.width_cells and 0 <= r < self.height_cells:
                    self.grid[r, c] = max(self.l_min, self.grid[r, c] + self.l_miss)

            # 激光击中点为占据栅格（更新 hit）
            self.grid[h_row, h_col] = min(self.l_max, self.grid[h_row, h_col] + self.l_hit)

    def get_probability_map(self) -> np.ndarray:
        """从 log-odds 恢复占据概率矩阵 [0, 1]。0.5 为未知，>0.5 为占据，<0.5 为空闲。"""
        # p = 1 - 1 / (1 + exp(l))
        return 1.0 - 1.0 / (1.0 + np.exp(self.grid))

    def get_occupied_points(self, threshold: float = 0.65) -> np.ndarray:
        """提取高于占据阈值的栅格世界坐标点集合 (K, 2)。"""
        prob = self.get_probability_map()
        rows, cols = np.where(prob >= threshold)
        if len(rows) == 0:
            return np.empty((0, 2), dtype=float)
        xs = self.origin_x + (cols + 0.5) * self.resolution
        ys = self.origin_y + (rows + 0.5) * self.resolution
        return np.column_stack((xs, ys))
