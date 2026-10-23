#!/usr/bin/env python3
"""实验 9.2：一维位姿图的 Huber IRLS；不使用真值计算权重。

这是 SE(2) 位姿图的平移子问题，不宣称验证旋转雅可比。
"""

from __future__ import annotations

import numpy as np

# (起点, 终点, 相对位移, 测量标准差, 是否回环)
EDGES = [
    (0, 1, 1.0, 0.1, False),
    (1, 2, 1.0, 0.1, False),
    (2, 3, 1.0, 0.1, False),
    (3, 4, 1.0, 0.1, False),
    (4, 0, -4.0, 0.1, True),
    (1, 4, 8.0, 0.1, True),  # 错误边：真实相对位移为 3 米
]


def solve_graph(robust: bool, max_iterations: int = 30) -> np.ndarray:
    """固定 x_0=0；每轮按当前估计残差更新回环权重。"""
    x = np.arange(5, dtype=float)  # 来自里程计而非真实坐标的初值；本例无里程计噪声
    delta = 1.5  # 标准化残差空间的 Huber 转折点
    for _ in range(max_iterations):
        A = np.zeros((4, 4))
        b = np.zeros(4)
        for i, j, z, sigma, is_loop in EDGES:
            row = np.zeros(4)
            if i != 0:
                row[i - 1] -= 1.0
            if j != 0:
                row[j - 1] += 1.0
            whitened = (x[j] - x[i] - z) / sigma
            factor = (min(1.0, delta / max(abs(whitened), 1e-12))
                      if robust and is_loop else 1.0)
            weight = factor / sigma**2
            A += weight * np.outer(row, row)
            b += weight * row * z
        next_x = np.r_[0.0, np.linalg.solve(A, b)]
        if np.max(np.abs(next_x - x)) < 1e-10:
            return next_x
        x = next_x
    return x


def main() -> None:
    truth = np.arange(5, dtype=float)  # 仅用于报告误差，绝不进入求解器
    l2, huber = solve_graph(False), solve_graph(True)
    print("=== 实验 9.2：一维图的错误回环与 Huber IRLS ===")
    for name, estimate in (("L2", l2), ("Huber IRLS", huber)):
        print(f"{name:10s} x={np.round(estimate, 4)}, "
              f"最大真值误差={np.max(np.abs(estimate - truth)):.4f} m")
    assert np.max(np.abs(huber - truth)) < np.max(np.abs(l2 - truth))


if __name__ == "__main__":
    main()
