# -*- coding: utf-8 -*-
"""2D 移动机器人与激光雷达仿真环境生成器。"""

from __future__ import annotations

import math
from typing import List, Tuple
import numpy as np
from car_slam.types import SE2, LaserScan


class LineSegment:
    def __init__(self, x1: float, y1: float, x2: float, y2: float):
        self.p1 = np.array([x1, y1], dtype=float)
        self.p2 = np.array([x2, y2], dtype=float)

    def intersect_ray(self, origin: np.ndarray, angle: float, max_range: float) -> float:
        """射线与线段求交，返回距离。若无交点返回 max_range。"""
        d = np.array([math.cos(angle), math.sin(angle)], dtype=float)
        v1 = origin - self.p1
        v2 = self.p2 - self.p1
        v3 = np.array([-d[1], d[0]], dtype=float)

        dot = np.dot(v2, v3)
        if abs(dot) < 1e-8:
            return max_range

        t1 = (v2[0] * v1[1] - v2[1] * v1[0]) / dot
        t2 = np.dot(v1, v3) / dot

        if t1 >= 0.05 and 0.0 <= t2 <= 1.0:
            return min(float(t1), max_range)
        return max_range


class Environment2D:
    """封闭室内环境（外墙 + 内部矩形障碍柱）。"""

    def __init__(self):
        self.walls: List[LineSegment] = []
        # 外墙 (10m x 8m)
        self.add_box(-4.0, -3.0, 4.0, 3.0)
        # 两个柱子
        self.add_box(-2.0, -1.0, -1.0, 0.0)
        self.add_box(1.0, 0.5, 2.0, 1.5)

    def add_box(self, x_min: float, y_min: float, x_max: float, y_max: float) -> None:
        self.walls.append(LineSegment(x_min, y_min, x_max, y_min))
        self.walls.append(LineSegment(x_max, y_min, x_max, y_max))
        self.walls.append(LineSegment(x_max, y_max, x_min, y_max))
        self.walls.append(LineSegment(x_min, y_max, x_min, y_min))

    def raycast(self, origin: np.ndarray, angle: float, max_range: float = 6.0) -> float:
        min_dist = max_range
        for w in self.walls:
            d = w.intersect_ray(origin, angle, max_range)
            if d < min_dist:
                min_dist = d
        return min_dist


class RobotSimulator:
    """小车回环运动模拟器。"""

    def __init__(self,
                 noise_odom_linear: float = 0.02,
                 noise_odom_angular: float = 0.01,
                 noise_lidar_range: float = 0.015):
        self.env = Environment2D()
        self.noise_linear = noise_odom_linear
        self.noise_angular = noise_odom_angular
        self.noise_range = noise_lidar_range

    def generate_loop_trajectory(self, num_steps: int = 120) -> List[SE2]:
        """生成一个在室内环境中绕行一周的闭环真实轨迹。"""
        # 顺时针环绕 (-2.5, -1.8) -> (2.5, -1.8) -> (2.5, 1.8) -> (-2.5, 1.8) -> 起点
        waypoints = [
            (-2.5, -1.8),
            (2.5, -1.8),
            (2.5, 1.8),
            (-2.5, 1.8),
            (-2.5, -1.8)
        ]
        poses: List[SE2] = []
        n_legs = len(waypoints) - 1
        steps_per_leg = num_steps // n_legs

        cur_x, cur_y = waypoints[0]
        cur_th = 0.0

        for leg in range(n_legs):
            target_x, target_y = waypoints[leg + 1]
            desired_th = math.atan2(target_y - cur_y, target_x - cur_x)

            for s in range(steps_per_leg):
                frac = (s + 1) / steps_per_leg
                x = cur_x + frac * (target_x - cur_x)
                y = cur_y + frac * (target_y - cur_y)
                # 朝向平滑插值
                th = desired_th
                poses.append(SE2(x, y, th))

            cur_x, cur_y = target_x, target_y
            cur_th = desired_th

        return poses

    def simulate_scan(self, pose: SE2, timestamp: float, num_beams: int = 180) -> LaserScan:
        """从真实位姿仿真一次 2D 激光雷达扫描并添加高斯测距噪声。"""
        angle_min = -math.pi
        angle_max = math.pi
        angle_inc = (angle_max - angle_min) / num_beams
        ranges = np.zeros(num_beams, dtype=float)

        origin = np.array([pose.x, pose.y], dtype=float)

        for b in range(num_beams):
            beam_angle = pose.theta + angle_min + b * angle_inc
            r = self.env.raycast(origin, beam_angle, max_range=6.0)
            if r < 6.0:
                r += np.random.normal(0.0, self.noise_range)
            ranges[b] = r

        return LaserScan(
            timestamp=timestamp,
            angle_min=angle_min,
            angle_max=angle_max,
            angle_increment=angle_inc,
            range_min=0.1,
            range_max=6.0,
            ranges=ranges
        )
