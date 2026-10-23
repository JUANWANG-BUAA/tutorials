# -*- coding: utf-8 -*-
import numpy as np
import pytest
from scipy.spatial.transform import Rotation as R_scipy
from arm_servoing.camera_model import PinholeCamera
from arm_servoing.simulator import ArmServoingSimulator


def test_ibvs_simulation_convergence():
    cam = PinholeCamera(fx=600.0, fy=600.0, cx=320.0, cy=240.0)
    sim = ArmServoingSimulator(cam)

    # 期望位姿：相机位于标靶正前方 0.8 米处
    T_desired = np.eye(4)
    T_desired[2, 3] = 0.8

    # 初始位姿：存在平移偏差 (0.1m, -0.08m, +0.15m) 与小旋转偏差 (5 deg)
    rot_init = R_scipy.from_euler("xyz", [3, -4, 5], degrees=True).as_matrix()
    T_init = np.eye(4)
    T_init[:3, :3] = rot_init
    T_init[:3, 3] = np.array([0.1, -0.08, 0.95])

    res = sim.run_ibvs_simulation(T_init, T_desired, max_steps=80, dt=0.05, tolerance=2e-3)
    errors = res["errors"]
    assert len(errors) > 5
    # 验证误差显著单调下降收敛
    assert errors[-1] < errors[0] * 0.05


def test_pbvs_simulation_convergence():
    cam = PinholeCamera(fx=600.0, fy=600.0, cx=320.0, cy=240.0)
    sim = ArmServoingSimulator(cam)

    T_desired = np.eye(4)
    T_desired[2, 3] = 0.8

    rot_init = R_scipy.from_euler("xyz", [-4, 5, -3], degrees=True).as_matrix()
    T_init = np.eye(4)
    T_init[:3, :3] = rot_init
    T_init[:3, 3] = np.array([-0.12, 0.10, 0.92])

    res = sim.run_pbvs_simulation(T_init, T_desired, max_steps=80, dt=0.05, tolerance=1e-3)
    errors = res["errors"]
    assert len(errors) > 5
    assert errors[-1] < errors[0] * 0.05
