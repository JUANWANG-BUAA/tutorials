# -*- coding: utf-8 -*-
"""实验 8.1：点到面（Point-to-Plane）ICP 配准算法与走廊滑动退化抵抗力对比。"""

import numpy as np
from scipy.spatial import cKDTree
from scipy.spatial.transform import Rotation as R_scipy


def point_to_plane_icp(source: np.ndarray, target: np.ndarray, target_normals: np.ndarray, max_iters: int = 20):
    kdtree = cKDTree(target)
    T = np.eye(4)

    for _ in range(max_iters):
        # 变换源点云
        s_trans = (source @ T[:3, :3].T) + T[:3, 3]
        dists, indices = kdtree.query(s_trans)

        valid = dists < 0.5
        s_val = s_trans[valid]
        q_val = target[indices[valid]]
        n_val = target_normals[indices[valid]]

        # 正规方程 H \Delta \xi = b
        # 残差 r_i = n_i^T (s_i - q_i)
        # 雅可比 J_i = [ n_i^T,  (s_i x n_i)^T ]
        H = np.zeros((6, 6))
        b = np.zeros(6)

        for i in range(len(s_val)):
            p = s_val[i]
            q = q_val[i]
            n = n_val[i]
            r = np.dot(n, p - q)

            cross = np.cross(p, n)
            J = np.concatenate((n, cross))

            H += np.outer(J, J)
            b += -J * r

        delta_xi = np.linalg.solve(H + 1e-4 * np.eye(6), b)
        # 更新
        dR = R_scipy.from_rotvec(delta_xi[3:]).as_matrix()
        dt = delta_xi[:3]
        dT = np.eye(4)
        dT[:3, :3] = dR
        dT[:3, 3] = dt

        T = dT @ T
        if np.linalg.norm(delta_xi) < 1e-5:
            break

    return T


def main():
    print("=== 实验 8.1：点到面 ICP 算法与平面滑移收敛性测试 ===")
    np.random.seed(42)

    # 构造两个相互垂直的大平面（地面与墙面）
    # 地面 Z=0, 法向量 [0, 0, 1]
    gx = np.linspace(-3, 3, 20)
    gy = np.linspace(-3, 3, 20)
    GXX, GYY = np.meshgrid(gx, gy)
    ground = np.column_stack((GXX.flatten(), GYY.flatten(), np.zeros(400)))
    ground_n = np.tile([0.0, 0.0, 1.0], (400, 1))

    # 墙面 X=3, 法向量 [-1, 0, 0]
    wy = np.linspace(-3, 3, 20)
    wz = np.linspace(0, 3, 20)
    WYY, WZZ = np.meshgrid(wy, wz)
    wall = np.column_stack((3.0 * np.ones(400), WYY.flatten(), WZZ.flatten()))
    wall_n = np.tile([-1.0, 0.0, 0.0], (400, 1))

    # 增加一面 Y=-3 的墙，约束原本无法由地面与 X=3 墙观测的 Y 平移。
    wx = np.linspace(-3, 3, 20)
    X2, Z2 = np.meshgrid(wx, wz)
    side = np.column_stack((X2.flatten(), -3.0 * np.ones(400), Z2.flatten()))
    side_n = np.tile([0.0, 1.0, 0.0], (400, 1))

    target = np.vstack((ground, wall, side))
    target_normals = np.vstack((ground_n, wall_n, side_n))

    # 真实相对变换
    T_gt = np.eye(4)
    T_gt[:3, :3] = R_scipy.from_euler("z", 10, degrees=True).as_matrix()
    T_gt[:3, 3] = np.array([0.15, -0.20, 0.10])

    source = (np.linalg.inv(T_gt)[:3, :3] @ target.T).T + np.linalg.inv(T_gt)[:3, 3]

    T_est = point_to_plane_icp(source, target, target_normals)

    trans_err = np.linalg.norm(T_est[:3, 3] - T_gt[:3, 3])
    rot_err = np.linalg.norm(T_est[:3, :3] - T_gt[:3, :3])

    print(f"真实位姿: t={T_gt[:3, 3]}")
    print(f"估计位姿: t={T_est[:3, 3]}")
    print(f"平移残差范数: {trans_err:.4e} m")
    print(f"旋转矩阵残差范数: {rot_err:.4e}")


if __name__ == "__main__":
    main()
