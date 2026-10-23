# -*- coding: utf-8 -*-
import numpy as np
import pytest
from arm_servoing.interaction_matrix import (
    point_interaction_matrix,
    stacked_interaction_matrix,
    damped_pseudo_inverse,
)


def test_interaction_matrix_pure_translation():
    # 测试在光轴上 (x=0, y=0, Z=2.0) 的点
    # 纯 X 方向平移速度 v_x = 0.1 产生的图像速度 \dot{x} 应为 -v_x / Z = -0.05
    L = point_interaction_matrix(0.0, 0.0, 2.0)
    v_c = np.array([0.1, 0.0, 0.0, 0.0, 0.0, 0.0])
    s_dot = L @ v_c
    np.testing.assert_allclose(s_dot, np.array([-0.05, 0.0]), atol=1e-6)


def test_interaction_matrix_pure_rotation():
    # 测试绕光轴 Z 旋转 \omega_z = 0.5 产生的角速度
    # \dot{x} = y * \omega_z, \dot{y} = -x * \omega_z
    x, y, Z = 0.2, 0.3, 1.5
    L = point_interaction_matrix(x, y, Z)
    v_c = np.array([0.0, 0.0, 0.0, 0.0, 0.0, 0.5])
    s_dot = L @ v_c
    np.testing.assert_allclose(s_dot, np.array([y * 0.5, -x * 0.5]), atol=1e-6)


def test_damped_pseudo_inverse():
    # 测试非奇异状态下的阻尼伪逆恢复
    L = stacked_interaction_matrix([(0.1, 0.1), (-0.1, 0.1), (0.1, -0.1), (-0.1, -0.1)], [1.0, 1.0, 1.0, 1.0])
    L_pinv = damped_pseudo_inverse(L, damping=1e-4)
    # L * L_pinv * L \approx L
    np.testing.assert_allclose(L @ L_pinv @ L, L, atol=1e-4)
