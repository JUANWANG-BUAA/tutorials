# -*- coding: utf-8 -*-
"""实验 13.1：运行小车 SLAM 闭环系统并在真实回环下检验位姿图优化效果。

用法：
    python3 exp1_car_slam_sim_trajectory.py            # 种子 42，打印正文引用的四项
    python3 exp1_car_slam_sim_trajectory.py --sweep    # 种子 0–5，打印 13.7.4 的对照表
"""

import sys
import os
import numpy as np

# 导入项目一代码
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../projects/car-slam")))
from car_slam.types import SE2
from car_slam.simulator import RobotSimulator
from car_slam.slam_system import CarSLAMSystem


def run_once(seed: int) -> dict:
    """跑一条 80 步闭环轨迹，返回估计规模与末端误差。"""
    np.random.seed(seed)

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

    # 两条估计都从与真值相同的初始位姿出发。若让航位推算从原点起步，
    # 误差里会混入一个与算法无关的常量平移，回环优化的增益无法比较。
    dead_reckoning_pose = gt_trajectory[0]
    dr_errors = []
    slam_errors = []

    prev_gt = gt_trajectory[0]
    for i, gt_pose in enumerate(gt_trajectory):
        scan = sim.simulate_scan(gt_pose, timestamp=i * 0.1, num_beams=120)

        # 构造带累积漂移的纯轮速里程计
        rel_gt = prev_gt.inverse() @ gt_pose
        noisy_rel = SE2(
            rel_gt.x + np.random.normal(0, 0.01),
            rel_gt.y + np.random.normal(0, 0.01),
            rel_gt.theta + np.random.normal(0, 0.005)
        )
        dead_reckoning_pose = dead_reckoning_pose @ noisy_rel

        # SLAM 处理
        cur_slam_pose, _ = slam.process_scan(scan, odom_relative=noisy_rel)

        dr_errors.append(np.hypot(dead_reckoning_pose.x - gt_pose.x,
                                  dead_reckoning_pose.y - gt_pose.y))
        slam_errors.append(np.hypot(cur_slam_pose.x - gt_pose.x,
                                    cur_slam_pose.y - gt_pose.y))
        prev_gt = gt_pose

    return {
        "seed": seed,
        "steps": len(gt_trajectory),
        "keyframes": len(slam.keyframes),
        "loops": len(slam.loop_closures_found),
        "dr_end": dr_errors[-1],
        "slam_end": slam_errors[-1],
    }


def main():
    print("=== 实验 13.1：小车 SLAM 闭环仿真全流程执行 ===")

    if "--sweep" in sys.argv:
        print("种子 | 关键帧 | 回环 | DR 末端 | SLAM 末端")
        for seed in range(6):
            r = run_once(seed)
            print(f"{r['seed']:4d} | {r['keyframes']:6d} | {r['loops']:4d} | "
                  f"{r['dr_end']:.3f} m | {r['slam_end']:.3f} m")
        return

    r = run_once(42)
    print(f"小车运行步数: {r['steps']}, 插入关键帧数: {r['keyframes']}")
    print(f"成功识别并闭合的回环对数: {r['loops']}")
    print(f"纯航位推算（Dead Reckoning）末端漂移: {r['dr_end']:.3f} m")
    print(f"SLAM 回环优化后末端闭环定位误差:       {r['slam_end']:.3f} m")


if __name__ == "__main__":
    main()
