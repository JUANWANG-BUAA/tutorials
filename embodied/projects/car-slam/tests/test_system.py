# -*- coding: utf-8 -*-
import math
import numpy as np
import pytest
from car_slam.types import SE2
from car_slam.slam_system import CarSLAMSystem
from car_slam.simulator import RobotSimulator


def test_slam_system_closed_loop():
    np.random.seed(42)
    sim = RobotSimulator(noise_odom_linear=0.01, noise_odom_angular=0.005, noise_lidar_range=0.01)
    gt_trajectory = sim.generate_loop_trajectory(num_steps=60)

    slam = CarSLAMSystem(
        keyframe_dist_thresh=0.3,
        keyframe_rot_thresh=0.3,
        loop_search_radius=1.8,
        loop_min_frame_gap=10,
        loop_score_thresh=0.25
    )

    prev_gt = gt_trajectory[0]
    for i, gt_pose in enumerate(gt_trajectory):
        timestamp = float(i) * 0.1
        scan = sim.simulate_scan(gt_pose, timestamp=timestamp, num_beams=120)

        # 真实增量加噪声作为里程计输入
        true_rel = prev_gt.inverse() @ gt_pose
        noisy_rel = SE2(
            true_rel.x + np.random.normal(0, 0.005),
            true_rel.y + np.random.normal(0, 0.005),
            true_rel.theta + np.random.normal(0, 0.003)
        )

        slam.process_scan(scan, odom_relative=noisy_rel)
        prev_gt = gt_pose

    assert len(slam.keyframes) >= 10
    # 检查地图非空
    occ_pts = slam.grid_map.get_occupied_points()
    assert len(occ_pts) > 50
