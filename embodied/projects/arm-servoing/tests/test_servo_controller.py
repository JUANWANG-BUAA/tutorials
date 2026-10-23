# -*- coding: utf-8 -*-
import numpy as np
import pytest
from arm_servoing.servo_controller import (
    IBVSController,
    PBVSController,
    camera_velocity_to_end_effector,
)


def test_ibvs_zero_error():
    controller = IBVSController()
    features = [(0.1, 0.1), (-0.1, 0.1), (0.1, -0.1), (-0.1, -0.1)]
    depths = [1.0, 1.0, 1.0, 1.0]
    v_c, err = controller.compute_control_velocity(features, features, depths)
    assert err == 0.0
    np.testing.assert_allclose(v_c, np.zeros(6), atol=1e-6)


def test_pbvs_zero_error():
    controller = PBVSController()
    T_target = np.eye(4)
    v_c, err = controller.compute_control_velocity(T_target, T_target)
    assert err < 1e-6
    np.testing.assert_allclose(v_c, np.zeros(6), atol=1e-6)


def test_camera_to_end_effector_transform():
    # 纯平移偏置：相机在末端正前方 0.1m 处 (t_ec = [0, 0, 0.1])
    T_ec = np.eye(4)
    T_ec[2, 3] = 0.1
    # 相机绕 Y 轴角速度 \omega_y = 1.0，根据杠杆原理在末端产生 X 轴线速度
    v_c = np.array([0.0, 0.0, 0.0, 0.0, 1.0, 0.0])
    v_e = camera_velocity_to_end_effector(v_c, T_ec)
    # [t_ec]_x * w_c = [0, 0, 0.1] x [0, 1, 0] = [-0.1, 0, 0]
    np.testing.assert_allclose(v_e[:3], np.array([-0.1, 0.0, 0.0]), atol=1e-6)
