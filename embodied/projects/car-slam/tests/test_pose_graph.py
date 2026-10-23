# -*- coding: utf-8 -*-
import math
import numpy as np
import pytest
from car_slam.types import SE2, PoseGraphEdge
from car_slam.pose_graph import PoseGraphOptimizer2D


def test_pose_graph_single_loop():
    optimizer = PoseGraphOptimizer2D(huber_threshold=1.0)
    # 构造正方形 4 顶点轨迹：
    # 0 -> (0,0,0)
    # 1 -> (1,0,0)
    # 2 -> (1,1,pi/2)
    # 3 -> (0,1,pi)
    # 回环 3 -> 0: rel_gt = T_3^{-1} * T_0
    poses_gt = [
        SE2(0.0, 0.0, 0.0),
        SE2(1.0, 0.0, 0.0),
        SE2(1.0, 1.0, math.pi / 2.0),
        SE2(0.0, 1.0, math.pi)
    ]

    # 添加带漂移的初始顶点估值
    optimizer.add_vertex(0, SE2(0.0, 0.0, 0.0))
    optimizer.add_vertex(1, SE2(1.05, 0.02, 0.01))
    optimizer.add_vertex(2, SE2(1.08, 1.06, math.pi / 2.0 + 0.02))
    optimizer.add_vertex(3, SE2(-0.02, 1.05, math.pi - 0.03))

    info = np.diag([100.0, 100.0, 100.0])

    # 相邻边
    for i in range(3):
        meas = poses_gt[i].inverse() @ poses_gt[i + 1]
        optimizer.add_edge(PoseGraphEdge(i, i + 1, meas, info))

    # 回环边 3 -> 0
    loop_meas = poses_gt[3].inverse() @ poses_gt[0]
    optimizer.add_edge(PoseGraphEdge(3, 0, loop_meas, info, is_loop_closure=True))

    converged, final_chi2 = optimizer.optimize(max_iterations=15)
    assert converged
    assert final_chi2 < 1e-3

    # 验证优化后各顶点精确回到真实位姿
    for vid in range(4):
        est = optimizer.vertices[vid]
        gt = poses_gt[vid]
        assert math.hypot(est.x - gt.x, est.y - gt.y) < 1e-2
        assert abs((est.theta - gt.theta + math.pi) % (2.0 * math.pi) - math.pi) < 1e-2
