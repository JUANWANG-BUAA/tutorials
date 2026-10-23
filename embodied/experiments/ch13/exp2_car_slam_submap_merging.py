# -*- coding: utf-8 -*-
"""实验 13.2：小车 SLAM 全局地图一致性与子图拼接验收。

验收不只看"图看起来像"，而是三个可复现的量：
  1. 回环是否真的发生（loop_closures_found 非空）；
  2. 占据点包围盒与房间真值（8 m × 6 m）的偏差；
  3. 占据点到最近真实墙面的距离分布（中位数与 90 分位）。

本实验显式把里程计增量交给前端。旧版本漏传 odom_relative，前端只能用
零运动初值，遇到航向阶跃后第 5 帧即卡住，地图拖成扇形；这个失败模式
在正文 13.8 中作为"基准配置伪造结论"的案例保留。
"""

import math
import sys
import os
import numpy as np

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../projects/car-slam")))
from car_slam.types import SE2
from car_slam.simulator import RobotSimulator
from car_slam.slam_system import CarSLAMSystem


def point_to_segment_distance(p, a, b):
    ab = b - a
    denom = float(ab @ ab)
    if denom < 1e-12:
        return float(np.linalg.norm(p - a))
    t = float((p - a) @ ab) / denom
    t = max(0.0, min(1.0, t))
    return float(np.linalg.norm(p - (a + t * ab)))


def distance_to_walls(points, walls):
    """每个占据点到最近墙面线段的距离。"""
    out = np.empty(len(points))
    for k, p in enumerate(points):
        out[k] = min(point_to_segment_distance(p, w.p1, w.p2) for w in walls)
    return out


def main():
    print("=== 实验 13.2：SLAM 全局地图重构与占据栅格一致性检验 ===")
    np.random.seed(42)

    sim = RobotSimulator(noise_odom_linear=0.015, noise_odom_angular=0.008, noise_lidar_range=0.015)
    gt_trajectory = sim.generate_loop_trajectory(num_steps=80)

    slam = CarSLAMSystem(
        keyframe_dist_thresh=0.25,
        keyframe_rot_thresh=0.25,
        loop_search_radius=1.8,
        loop_min_frame_gap=12,
        loop_score_thresh=0.25,
        initial_pose=gt_trajectory[0],
    )

    prev_gt = gt_trajectory[0]
    slam_errors = []
    for i, gt_pose in enumerate(gt_trajectory):
        scan = sim.simulate_scan(gt_pose, timestamp=i * 0.1, num_beams=120)
        rel_gt = prev_gt.inverse() @ gt_pose
        noisy_rel = SE2(
            rel_gt.x + np.random.normal(0, 0.01),
            rel_gt.y + np.random.normal(0, 0.01),
            rel_gt.theta + np.random.normal(0, 0.005),
        )
        cur_pose, _ = slam.process_scan(scan, odom_relative=noisy_rel)
        slam_errors.append(math.hypot(cur_pose.x - gt_pose.x, cur_pose.y - gt_pose.y))
        prev_gt = gt_pose

    prob = slam.grid_map.get_probability_map()
    occ_points = np.asarray(slam.grid_map.get_occupied_points(threshold=0.65), dtype=float)
    expected_w, expected_h = 8.0, 6.0
    bbox_w = float(occ_points[:, 0].max() - occ_points[:, 0].min())
    bbox_h = float(occ_points[:, 1].max() - occ_points[:, 1].min())
    dists = distance_to_walls(occ_points, sim.env.walls)

    print(f"生成的全局占据栅格图尺寸: {prob.shape[0]} x {prob.shape[1]}")
    print(f"关键帧数: {len(slam.keyframes)}, 回环次数: {len(slam.loop_closures_found)}")
    print(f"提取的高置信度障碍物点云数: {len(occ_points)}")
    print(f"占据点包围盒: {bbox_w:.2f} m x {bbox_h:.2f} m（真值 {expected_w:.1f} m x {expected_h:.1f} m）")
    print(f"占据点到最近墙面距离: 中位数 {np.median(dists):.3f} m, "
          f"90 分位 {np.percentile(dists, 90):.3f} m")
    print(f"末端定位误差: {slam_errors[-1]:.3f} m, 全程最大: {max(slam_errors):.3f} m")

    # 验收：必须真的闭环、包围盒接近真值、墙面残差在栅格分辨率量级。
    assert len(slam.loop_closures_found) >= 1, "没有发生回环，地图一致性无从谈起"
    assert abs(bbox_w - expected_w) < 0.5, f"包围盒宽度偏差过大: {bbox_w:.2f}"
    assert abs(bbox_h - expected_h) < 0.5, f"包围盒高度偏差过大: {bbox_h:.2f}"
    assert np.median(dists) < 0.12, f"墙面残差中位数过大: {np.median(dists):.3f} m"
    print("验收通过：回环发生，包围盒与真值一致，墙面残差在栅格分辨率量级。")


if __name__ == "__main__":
    main()
