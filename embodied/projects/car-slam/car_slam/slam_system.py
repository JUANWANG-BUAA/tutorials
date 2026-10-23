# -*- coding: utf-8 -*-
"""完整小车 2D SLAM 闭环系统（前端匹配 + 局部子图 + 回环检测 + 后端位姿图 + 占据栅格地图）。"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple
import numpy as np

from car_slam.types import SE2, LaserScan, PoseGraphEdge
from car_slam.scan_matching import ScanMatcher2D
from car_slam.pose_graph import PoseGraphOptimizer2D
from car_slam.occupancy_grid import OccupancyGridMap


@dataclass
class KeyFrame:
    id: int
    pose: SE2
    points: np.ndarray  # 局部激光点集 (N, 2)
    timestamp: float


class CarSLAMSystem:
    """集成小车 SLAM 闭环完整管线。"""

    def __init__(self,
                 keyframe_dist_thresh: float = 0.3,
                 keyframe_rot_thresh: float = 0.25,
                 loop_search_radius: float = 1.5,
                 loop_min_frame_gap: int = 15,
                 loop_score_thresh: float = 0.12,
                 initial_pose: Optional[SE2] = None):
        self.kf_dist_thresh = keyframe_dist_thresh
        self.kf_rot_thresh = keyframe_rot_thresh
        self.loop_search_radius = loop_search_radius
        self.loop_min_frame_gap = loop_min_frame_gap
        self.loop_score_thresh = loop_score_thresh
        # 初始位姿是估计量，必须由调用者显式传入或显式声明为世界原点。
        # 旧实现把首帧强制复位到原点，任何不从原点出发的轨迹都会带一个
        # 恒定的初始化误差，回环优化的增益被这个常量完全掩盖。
        self.initial_pose = initial_pose if initial_pose is not None else SE2(0.0, 0.0, 0.0)

        self.matcher = ScanMatcher2D(max_iterations=25, tolerance=1e-4, max_correspondence_dist=0.6)
        self.optimizer = PoseGraphOptimizer2D(huber_threshold=0.8)
        self.grid_map = OccupancyGridMap(width=25.0, height=25.0, resolution=0.05, origin_x=-12.5, origin_y=-12.5)

        self.keyframes: List[KeyFrame] = []
        self.current_pose = SE2(self.initial_pose.x, self.initial_pose.y, self.initial_pose.theta)
        self.last_keyframe_pose = SE2(self.initial_pose.x, self.initial_pose.y, self.initial_pose.theta)
        self.loop_closures_found: List[Tuple[int, int]] = []

    def get_local_submap_points(self, window_size: int = 8) -> np.ndarray:
        """从最近的局部关键帧中拼接局部参考点云。"""
        if not self.keyframes:
            return np.empty((0, 2), dtype=float)
        recent_kfs = self.keyframes[-window_size:]
        pts_list = []
        for kf in recent_kfs:
            pts_w = kf.pose.transform_points(kf.points)
            pts_list.append(pts_w)
        return np.vstack(pts_list) if pts_list else np.empty((0, 2), dtype=float)

    def is_keyframe_needed(self, pose: SE2) -> bool:
        if not self.keyframes:
            return True
        dp = math.hypot(pose.x - self.last_keyframe_pose.x, pose.y - self.last_keyframe_pose.y)
        dth = abs((pose.theta - self.last_keyframe_pose.theta + math.pi) % (2.0 * math.pi) - math.pi)
        return dp >= self.kf_dist_thresh or dth >= self.kf_rot_thresh

    def process_scan(self, scan: LaserScan, odom_relative: Optional[SE2] = None) -> Tuple[SE2, bool]:
        """处理一帧激光雷达与里程计增量，完成前端跟踪、回环判定与地图更新。"""
        pts = scan.to_points()
        if len(pts) < 10:
            return self.current_pose, False

        # 1. 前端位姿初值推算。首帧不重置：初始位姿可能由调用者继承自
        # 上一段会话或外部先验，重置会凭空丢掉一个常量平移。
        if not self.keyframes:
            initial_guess = self.current_pose
        else:
            if odom_relative is not None:
                initial_guess = self.current_pose @ odom_relative
            else:
                initial_guess = self.current_pose

        # 2. 扫描匹配配准至局部子图
        if len(self.keyframes) > 0:
            target_submap = self.get_local_submap_points(window_size=6)
            T_world_cur, converged, rmse = self.matcher.match(pts, target_submap, initial_guess=initial_guess)
            if converged and rmse < 0.4:
                self.current_pose = T_world_cur
            else:
                self.current_pose = initial_guess
        else:
            self.current_pose = initial_guess

        # 3. 关键帧插入与后端图更新
        is_kf = self.is_keyframe_needed(self.current_pose)
        if is_kf:
            kf_id = len(self.keyframes)
            new_kf = KeyFrame(id=kf_id, pose=self.current_pose, points=pts, timestamp=scan.timestamp)
            self.keyframes.append(new_kf)
            self.optimizer.add_vertex(kf_id, self.current_pose)

            # 添加相邻里程计边
            if kf_id > 0:
                prev_kf = self.keyframes[kf_id - 1]
                meas = prev_kf.pose.inverse() @ self.current_pose
                # 信息矩阵
                info = np.diag([100.0, 100.0, 400.0])
                edge = PoseGraphEdge(i=kf_id - 1, j=kf_id, measurement=meas, information=info, is_loop_closure=False)
                self.optimizer.add_edge(edge)

            # 4. 回环检测检索
            loop_detected = self.check_loop_closure(new_kf)
            if loop_detected:
                # 触发位姿图全局优化
                success, _ = self.optimizer.optimize(max_iterations=15)
                if success:
                    # 将修正后的位姿写回所有关键帧
                    for kf in self.keyframes:
                        kf.pose = self.optimizer.vertices[kf.id]
                    self.current_pose = self.keyframes[-1].pose
                    self.rebuild_grid_map()

            # 更新当前占据栅格
            self.grid_map.update_scan(self.current_pose, pts)
            self.last_keyframe_pose = self.current_pose

        return self.current_pose, is_kf

    def check_loop_closure(self, current_kf: KeyFrame) -> bool:
        """在历史关键帧中搜索回环候选帧并执行验证匹配。"""
        if current_kf.id < self.loop_min_frame_gap:
            return False

        loop_candidate_id = -1
        min_dist = float("inf")

        for kf in self.keyframes:
            if current_kf.id - kf.id < self.loop_min_frame_gap:
                continue
            dist = math.hypot(kf.pose.x - current_kf.pose.x, kf.pose.y - current_kf.pose.y)
            if dist < self.loop_search_radius and dist < min_dist:
                min_dist = dist
                loop_candidate_id = kf.id

        if loop_candidate_id < 0:
            return False

        target_kf = self.keyframes[loop_candidate_id]
        # 在目标关键帧坐标系下匹配
        # 初始猜测：T_target_cur = target_pose.inv * current_pose
        init_rel = target_kf.pose.inverse() @ current_kf.pose
        matched_rel, converged, rmse = self.matcher.match(
            source_pts=current_kf.points,
            target_pts=target_kf.points,
            initial_guess=init_rel
        )

        if converged and rmse < self.loop_score_thresh:
            info = np.diag([200.0, 200.0, 800.0])
            loop_edge = PoseGraphEdge(
                i=target_kf.id,
                j=current_kf.id,
                measurement=matched_rel,
                information=info,
                is_loop_closure=True
            )
            self.optimizer.add_edge(loop_edge)
            self.loop_closures_found.append((target_kf.id, current_kf.id))
            return True

        return False

    def rebuild_grid_map(self) -> None:
        """位姿图优化后清空重绘全局占据栅格地图。"""
        self.grid_map.grid.fill(0.0)
        for kf in self.keyframes:
            self.grid_map.update_scan(kf.pose, kf.points)
