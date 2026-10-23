# -*- coding: utf-8 -*-
"""实验 11.1：2D 占据栅格地图 Bresenham 光线投射与逆传感器模型更新。"""

import numpy as np


def bresenham(x0, y0, x1, y1):
    points = []
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx - dy
    cx, cy = x0, y0
    while cx != x1 or cy != y1:
        points.append((cx, cy))
        e2 = 2 * err
        if e2 > -dy:
            err -= dy
            cx += sx
        if e2 < dx:
            err += dx
            cy += sy
    return points


def main():
    print("=== 实验 11.1：Bresenham 对数几率占据栅格更新 ===")
    grid_size = 50
    grid = np.zeros((grid_size, grid_size))  # 对数几率，0 对应先验 0.5

    l_occ = 0.85   # log(0.7 / 0.3)
    l_free = -0.40 # log(0.4 / 0.6)

    # 机器人在中心 (25, 25)
    rx, ry = 25, 25
    # 模拟 360 条激光束打在半径 15 的圆形障碍物墙壁上
    for th in np.linspace(0, 2*np.pi, 180, endpoint=False):
        hit_x = int(round(rx + 15.0 * np.cos(th)))
        hit_y = int(round(ry + 15.0 * np.sin(th)))

        ray = bresenham(rx, ry, hit_x, hit_y)
        for cx, cy in ray:
            grid[cy, cx] = max(-4.0, grid[cy, cx] + l_free)

        grid[hit_y, hit_x] = min(4.0, grid[hit_y, hit_x] + l_occ)

    prob_map = 1.0 - 1.0 / (1.0 + np.exp(grid))

    free_count = np.sum(prob_map < 0.3)
    occ_count = np.sum(prob_map > 0.7)
    unknown_count = np.sum((prob_map >= 0.3) & (prob_map <= 0.7))

    print(f"栅格总数: {grid_size * grid_size}")
    print(f"空闲（Free）单元数: {free_count}")
    print(f"占据（Occupied）单元数: {occ_count}")
    print(f"未知（Unknown）单元数: {unknown_count}")


if __name__ == "__main__":
    main()
