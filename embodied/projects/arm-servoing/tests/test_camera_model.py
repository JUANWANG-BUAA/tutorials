# -*- coding: utf-8 -*-
import numpy as np
import pytest
from arm_servoing.camera_model import PinholeCamera


def test_pinhole_projection():
    cam = PinholeCamera(fx=600.0, fy=600.0, cx=320.0, cy=240.0)
    pt_cam = np.array([0.1, -0.2, 1.0])
    u, v, Z = cam.project_point(pt_cam)
    assert abs(Z - 1.0) < 1e-6
    assert abs(u - (600.0 * 0.1 + 320.0)) < 1e-6
    assert abs(v - (600.0 * (-0.2) + 240.0)) < 1e-6


def test_pixel_to_normalized():
    cam = PinholeCamera(fx=500.0, fy=500.0, cx=300.0, cy=200.0)
    u, v = 400.0, 100.0
    xn, yn = cam.pixel_to_normalized(u, v)
    assert abs(xn - 0.2) < 1e-6
    assert abs(yn - (-0.2)) < 1e-6
