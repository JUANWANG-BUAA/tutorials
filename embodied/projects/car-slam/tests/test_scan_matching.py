# -*- coding: utf-8 -*-
import math
import numpy as np
import pytest
from car_slam.types import SE2
from car_slam.scan_matching import ScanMatcher2D


def test_se2_exp_log():
    xi = np.array([0.3, -0.2, 0.15])
    T = SE2.exp(xi)
    xi_rec = T.log()
    np.testing.assert_allclose(xi, xi_rec, atol=1e-6)


def test_se2_inverse_matmul():
    T1 = SE2(1.2, -0.8, 0.5)
    T2 = SE2(-0.5, 1.0, -0.3)
    T12 = T1 @ T2
    T_id = T1 @ T1.inverse()
    np.testing.assert_allclose(T_id.to_vector(), np.array([0.0, 0.0, 0.0]), atol=1e-6)


def test_scan_matcher_arun_svd():
    matcher = ScanMatcher2D()
    # 构造标准矩形点集
    pts_s = np.array([
        [0.0, 0.0],
        [1.0, 0.0],
        [1.0, 2.0],
        [0.0, 2.0]
    ])
    T_gt = SE2(0.5, -0.3, 0.2)
    pts_t = T_gt.transform_points(pts_s)

    T_est = matcher.align_svd(pts_s, pts_t)
    np.testing.assert_allclose(T_est.to_vector(), T_gt.to_vector(), atol=1e-5)


def test_scan_matcher_gauss_newton():
    matcher = ScanMatcher2D(max_iterations=30, tolerance=1e-5)
    np.random.seed(42)
    # 随机空间特征点云集合
    pts = np.random.uniform(-3.0, 3.0, size=(60, 2))
    T_rel = SE2(0.15, -0.10, 0.08)
    target = pts
    source = T_rel.inverse().transform_points(pts)

    T_est, converged, rmse = matcher.match(source, target, initial_guess=SE2(0.0, 0.0, 0.0))
    assert converged
    assert rmse < 1e-6
    np.testing.assert_allclose(T_est.to_vector(), T_rel.to_vector(), atol=1e-5)
