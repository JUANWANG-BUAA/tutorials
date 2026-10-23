# -*- coding: utf-8 -*-
"""实验 2.1：离散环形世界中的一维贝叶斯滤波器（预测 + 更新 + 信息熵收敛）。"""

import numpy as np


def entropy(p: np.ndarray) -> float:
    p_safe = p[p > 1e-12]
    return float(-np.sum(p_safe * np.log2(p_safe)))


def main():
    print("=== 实验 2.1：离散贝叶斯网格滤波器 ===")
    N = 20  # 20 个离散网格单元 [0, 19]
    # 先验：均匀分布（最大不确定性）
    belief = np.ones(N) / N

    # 地标真实分布：网格 5 和网格 15 处各有一根特征立柱
    landmarks = [5, 15]

    # 控制输入：每次向前移动 2 格，带噪声转移概率：移动2格概率0.7，移动1格0.15，移动3格0.15
    motion_kernel = [(2, 0.7), (1, 0.15), (3, 0.15)]

    # 传感器模型：立柱前检测到特征概率 0.85，其他位置误报概率 0.10
    prob_see_given_landmark = 0.85
    prob_see_given_nothing = 0.10

    print(f"初始先验信息熵: {entropy(belief):.4f} bits (理论最大值: {np.log2(N):.4f})")

    # 模拟真实机器人从网格 3 出发，执行 3 步运动与观测
    true_pos = 3
    for step in range(1, 4):
        # 1. 运动预测（全概率公式 / 卷积）
        prior = np.zeros(N)
        for offset, prob in motion_kernel:
            prior += prob * np.roll(belief, offset)

        # 真实状态推移
        true_pos = (true_pos + 2) % N
        has_landmark = true_pos in landmarks

        # 2. 测量更新（贝叶斯法则）
        likelihood = np.zeros(N)
        for i in range(N):
            if i in landmarks:
                likelihood[i] = prob_see_given_landmark if has_landmark else (1.0 - prob_see_given_landmark)
            else:
                likelihood[i] = prob_see_given_nothing if has_landmark else (1.0 - prob_see_given_nothing)

        unnorm_posterior = likelihood * prior
        belief = unnorm_posterior / np.sum(unnorm_posterior)

        h = entropy(belief)
        max_idx = int(np.argmax(belief))
        print(f"Step {step}: 真实位置={true_pos}, 最大后验位置={max_idx} (置信度={belief[max_idx]:.3f}), 信息熵={h:.4f} bits")


if __name__ == "__main__":
    main()
