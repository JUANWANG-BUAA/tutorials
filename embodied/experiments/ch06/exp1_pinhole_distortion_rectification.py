# -*- coding: utf-8 -*-
"""实验 6.1：相机径向/切向畸变模型正向合成与牛顿迭代反向去畸变校正。"""

import numpy as np


def add_distortion(x: float, y: float, k1: float, k2: float, p1: float, p2: float):
    """Brown-Conrady 畸变正向模型。"""
    r2 = x**2 + y**2
    radial = 1.0 + k1 * r2 + k2 * (r2**2)
    x_dist = x * radial + 2.0 * p1 * x * y + p2 * (r2 + 2.0 * x**2)
    y_dist = y * radial + p1 * (r2 + 2.0 * y**2) + 2.0 * p2 * x * y
    return x_dist, y_dist


def undistort_point(xd: float, yd: float, k1: float, k2: float, p1: float, p2: float, max_iter: int = 15):
    """牛顿-拉夫逊数值迭代求解未畸变坐标 (x, y)。"""
    x, y = xd, yd
    for _ in range(max_iter):
        r2 = x**2 + y**2
        radial = 1.0 + k1 * r2 + k2 * (r2**2)
        f_x = x * radial + 2.0 * p1 * x * y + p2 * (r2 + 2.0 * x**2) - xd
        f_y = y * radial + p1 * (r2 + 2.0 * y**2) + 2.0 * p2 * x * y - yd

        if abs(f_x) < 1e-8 and abs(f_y) < 1e-8:
            break

        # 偏导数雅可比矩阵
        dfx_dx = radial + x * (2*k1*x + 4*k2*r2*x) + 2*p1*y + 6*p2*x
        dfx_dy = x * (2*k1*y + 4*k2*r2*y) + 2*p1*x + 2*p2*y
        dfy_dx = y * (2*k1*x + 4*k2*r2*x) + 2*p1*x + 2*p2*y
        dfy_dy = radial + y * (2*k1*y + 4*k2*r2*y) + 6*p1*y + 2*p2*x

        J = np.array([[dfx_dx, dfx_dy], [dfy_dx, dfy_dy]])
        delta = np.linalg.solve(J, np.array([f_x, f_y]))
        x -= delta[0]
        y -= delta[1]

    return x, y


def main():
    print("=== 实验 6.1：相机畸变合成与去畸变逆映射验证 ===")
    # 模拟真实广角镜头畸变系数
    k1 = -0.15
    k2 = 0.03
    p1 = 0.001
    p2 = -0.0005

    # 测试视野边缘归一化点 (x=0.6, y=0.45)
    x_true, y_true = 0.6, 0.45
    xd, yd = add_distortion(x_true, y_true, k1, k2, p1, p2)

    dist_px_shift = np.hypot(xd - x_true, yd - y_true) * 600.0  # 假设焦距 600px
    print(f"真实无畸变坐标: ({x_true:.4f}, {y_true:.4f})")
    print(f"畸变后坐标:     ({xd:.4f}, {yd:.4f}) -> 边缘像素偏移: {dist_px_shift:.2f} px")

    # 去畸变逆解
    x_rec, y_rec = undistort_point(xd, yd, k1, k2, p1, p2)
    err = np.hypot(x_rec - x_true, y_rec - y_true)
    print(f"牛顿法恢复坐标: ({x_rec:.6f}, {y_rec:.6f})")
    print(f"反解重投影绝对残差: {err:.2e} (完全达到亚像素极限)")


if __name__ == "__main__":
    main()
