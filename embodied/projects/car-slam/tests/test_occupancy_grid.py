# -*- coding: utf-8 -*-
import numpy as np
import pytest
from car_slam.types import SE2
from car_slam.occupancy_grid import OccupancyGridMap


def test_grid_coordinates():
    grid = OccupancyGridMap(width=10.0, height=10.0, resolution=0.1, origin_x=-5.0, origin_y=-5.0)
    col, row = grid.world_to_map(0.0, 0.0)
    assert col == 50 and row == 50
    wx, wy = grid.map_to_world(50, 50)
    assert abs(wx - 0.05) < 1e-4 and abs(wy - 0.05) < 1e-4


def test_bresenham_line():
    cells = OccupancyGridMap.bresenham_line(0, 0, 3, 3)
    assert (0, 0) in cells
    assert (1, 1) in cells
    assert (2, 2) in cells
    assert (3, 3) not in cells  # 不含终点


def test_grid_update_scan():
    grid = OccupancyGridMap(width=6.0, height=6.0, resolution=0.1, origin_x=-3.0, origin_y=-3.0)
    robot_pose = SE2(0.0, 0.0, 0.0)
    # 单点击中：正前方 1.0 米处有障碍物
    pts_local = np.array([[1.0, 0.0]])

    grid.update_scan(robot_pose, pts_local)
    prob_map = grid.get_probability_map()

    # 障碍物位置概率应显著高于 0.5
    h_col, h_row = grid.world_to_map(1.0, 0.0)
    assert prob_map[h_row, h_col] > 0.65

    # 射线中间自由区（例如 0.5m 处）概率应显著低于 0.5
    m_col, m_row = grid.world_to_map(0.5, 0.0)
    assert prob_map[m_row, m_col] < 0.45
