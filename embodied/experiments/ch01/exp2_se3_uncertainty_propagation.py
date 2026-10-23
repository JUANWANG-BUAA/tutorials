# -*- coding: utf-8 -*-
"""实验 1.2：SE(3) 刚体位姿变换下的协方差一阶线性传播 vs 蒙特卡洛真实分布。"""

import numpy as np


def main():
    print("=== 实验 1.2：位姿不确定性传播（一阶近似 vs 蒙特卡洛）===")
    np.random.seed(42)

    # 标称位姿：平移 t=[1.0, 2.0], 偏航角 yaw=0.5 rad
    yaw0 = 0.5
    t0 = np.array([1.0, 2.0])
    R0 = np.array([[np.cos(yaw0), -np.sin(yaw0)],
                   [np.sin(yaw0),  np.cos(yaw0)]])

    # 输入噪声协方差 (dx, dy, dyaw)
    Sigma_x = np.diag([0.02**2, 0.02**2, 0.05**2])

    # 局部点 p = [3.0, 1.0]
    p = np.array([3.0, 1.0])

    # 1. 理论一阶雅可比线性传播：y = R(yaw) * p + t
    # dy / d(t) = I_2
    # dy / d(yaw) = dR/dyaw * p = [-sin(yaw)*px - cos(yaw)*py, cos(yaw)*px - sin(yaw)*py]^T
    J_t = np.eye(2)
    J_yaw = np.array([
        [-np.sin(yaw0) * p[0] - np.cos(yaw0) * p[1]],
        [ np.cos(yaw0) * p[0] - np.sin(yaw0) * p[1]]
    ])
    J = np.hstack((J_t, J_yaw))  # (2, 3)

    Sigma_y_linear = J @ Sigma_x @ J.T

    # 2. 蒙特卡洛抽样统计
    N = 100000
    samples_noise = np.random.multivariate_normal(np.zeros(3), Sigma_x, size=N)
    samples_y = np.zeros((N, 2))

    for i in range(N):
        dx, dy, dyaw = samples_noise[i]
        yaw_i = yaw0 + dyaw
        t_i = t0 + np.array([dx, dy])
        R_i = np.array([[np.cos(yaw_i), -np.sin(yaw_i)],
                        [np.sin(yaw_i),  np.cos(yaw_i)]])
        samples_y[i] = R_i @ p + t_i

    Sigma_y_mc = np.cov(samples_y, rowvar=False)

    print("一阶泰勒展开协方差：")
    print(Sigma_y_linear)
    print("\n蒙特卡洛经验协方差：")
    print(Sigma_y_mc)

    rel_diff = np.linalg.norm(Sigma_y_linear - Sigma_y_mc) / np.linalg.norm(Sigma_y_mc)
    print(f"\n相对误差范数: {rel_diff * 100:.3f}%")


if __name__ == "__main__":
    main()
