# -*- coding: utf-8 -*-
"""实验 12.2：点云/视觉几何退化检测（Hessian 特征值谱分析与条件数判别）。"""

import numpy as np


def check_degeneration(H: np.ndarray, thresh_cond: float = 1e3, thresh_min_eig: float = 10.0):
    """分析 Hessian 矩阵的特征谱，检测退化自由度。"""
    eigvals, eigvecs = np.linalg.eigh(H)
    min_eig = eigvals[0]
    max_eig = eigvals[-1]
    cond_number = max_eig / max(min_eig, 1e-12)

    is_degenerate = (min_eig < thresh_min_eig) or (cond_number > thresh_cond)
    # 提取退化未约束方向（对应最小特征值特征向量）
    degenerate_direction = eigvecs[:, 0] if is_degenerate else None

    return is_degenerate, min_eig, cond_number, degenerate_direction


def main():
    print("=== 实验 12.2：几何退化环境检测（长廊特征缺失分析）===")
    # 场景 A：结构丰富的十字路口（X 与 Y 方向均有大量法向量点）
    # 法向量平均分布在 X 和 Y 轴
    normals_rich = np.vstack([
        np.tile([1.0, 0.0], (50, 1)),
        np.tile([0.0, 1.0], (50, 1))
    ])
    H_rich = normals_rich.T @ normals_rich

    # 场景 B：长直无特征走廊（只有侧墙，法向量全部垂直于 Y 轴，X 轴完全未约束）
    normals_corridor = np.tile([0.0, 1.0], (100, 1))
    H_corridor = normals_corridor.T @ normals_corridor + np.diag([0.01, 0.0])  # X 轴几乎为零

    deg_a, min_eig_a, cond_a, dir_a = check_degeneration(H_rich)
    deg_b, min_eig_b, cond_b, dir_b = check_degeneration(H_corridor)

    print(f"场景 A（十字路口）：退化={deg_a}, 最小特征值={min_eig_a:.1f}, 条件数={cond_a:.2f}")
    print(f"场景 B（狭长走廊）：退化={deg_b}, 最小特征值={min_eig_b:.3f}, 条件数={cond_b:.2f}")
    if deg_b:
        print(f"场景 B 退化未约束方向向量: {dir_b} (沿走廊前进方向 X 轴严重退化，需切换为里程计/IMU保护)")


if __name__ == "__main__":
    main()
