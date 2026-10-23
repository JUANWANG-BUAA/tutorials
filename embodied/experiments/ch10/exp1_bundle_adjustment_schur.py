# -*- coding: utf-8 -*-
"""实验 10.1：Bundle Adjustment 稀疏箭头结构与舒尔补（Schur Complement）边缘化消元。"""

import numpy as np


def main():
    print("=== 实验 10.1：BA 舒尔补边缘化与线性系统求解 ===")
    np.random.seed(42)

    # 模拟 BA 问题：m = 3 个相机位姿（各 6 维，共 18 维），n = 20 个三维路标点（各 3 维，共 60 维）
    # 总变量维度 78 维
    # 正规方程：
    # [ B   W ] [ \Delta x_c ] = [ v ]
    # [ W^T C ] [ \Delta x_p ]   [ w ]
    # 其中 C 为块对角矩阵 (20 个 3x3 块对角矩阵，逆极度容易求！)
    dim_c = 18
    dim_p = 60

    # 随机生成正定 B (18 x 18)
    rand_B = np.random.randn(dim_c, dim_c)
    B = rand_B.T @ rand_B + 10.0 * np.eye(dim_c)

    # 生成分块对角 C (60 x 60)，包含 20 个独立 3x3 逆
    C = np.zeros((dim_p, dim_p))
    C_inv = np.zeros((dim_p, dim_p))
    for k in range(20):
        r_c = np.random.randn(3, 3)
        blk = r_c.T @ r_c + 5.0 * np.eye(3)
        C[k*3 : (k+1)*3, k*3 : (k+1)*3] = blk
        C_inv[k*3 : (k+1)*3, k*3 : (k+1)*3] = np.linalg.inv(blk)

    # 稀疏耦合项 W (18 x 60)
    W = np.random.randn(dim_c, dim_p) * 0.5

    # 拼接全 Hessian H (78 x 78)
    H_full = np.block([
        [B,   W],
        [W.T, C]
    ])
    rhs_full = np.random.randn(dim_c + dim_p)
    v = rhs_full[:dim_c]
    w = rhs_full[dim_c:]

    # 1. 直接对 78x78 稠密大矩阵求逆
    delta_full = np.linalg.solve(H_full, rhs_full)
    delta_c_direct = delta_full[:dim_c]
    delta_p_direct = delta_full[dim_c:]

    # 2. 舒尔补（Schur Complement）消元路标点：
    # 边缘化后的相机子系统：(B - W * C^{-1} * W^T) * \Delta x_c = v - W * C^{-1} * w
    S = B - W @ C_inv @ W.T  # 舒尔补矩阵，仅 18 x 18！
    rhs_c = v - W @ C_inv @ w
    delta_c_schur = np.linalg.solve(S, rhs_c)

    # 回代求解各路标点增量：\Delta x_p = C^{-1} * (w - W^T * \Delta x_c)
    delta_p_schur = C_inv @ (w - W.T @ delta_c_schur)

    err_c = np.linalg.norm(delta_c_schur - delta_c_direct)
    err_p = np.linalg.norm(delta_p_schur - delta_p_direct)

    print(f"全矩阵直接求解维度: {dim_c + dim_p} 维")
    print(f"舒尔补降维求解相机子系统: {dim_c} 维")
    print(f"相机位姿解的一致性误差: {err_c:.2e}")
    print(f"路标点回代解的一致性误差: {err_p:.2e} (完全等价，计算复杂度从 O((m+n)^3) 暴降至 O(m^3 + n))")


if __name__ == "__main__":
    main()
