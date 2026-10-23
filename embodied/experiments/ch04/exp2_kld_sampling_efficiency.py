# -*- coding: utf-8 -*-
"""实验 4.2：KLD 自适应粒子抽样（KLD-sampling）效率与样本规模自适应测试。"""

import math
import numpy as np


def compute_kld_particles(k: int, epsilon: float = 0.05, delta: float = 0.01) -> int:
    """根据占据网格 bin 数量 k，依据 Wilson-Hilferty 变换计算满足 KL 散度约束的最小粒子数。"""
    if k <= 1:
        return 50
    # 标量分位数 z_{1-\delta}
    from scipy.stats import norm
    z = norm.ppf(1.0 - delta)
    factor = 1.0 - 2.0 / (9.0 * (k - 1)) + math.sqrt(2.0 / (9.0 * (k - 1))) * z
    N_kld = (k - 1) / (2.0 * epsilon) * (factor ** 3)
    return int(max(N_kld, 50))


def main():
    print("=== 实验 4.2：KLD 自适应抽样与固定粒子规模效率对比 ===")
    np.random.seed(42)

    # 模拟场景 1：全局定位初期，后验分布高度发散（覆盖大范围）
    # 模拟场景 2：局部跟踪期，后验高度集中在单个峰附近
    bin_size = 0.2

    # 阶段 1：发散分布
    samples_diffuse = np.random.uniform(-5.0, 5.0, size=5000)
    bins_diffuse = set(np.floor(samples_diffuse / bin_size))
    k_diffuse = len(bins_diffuse)
    n_kld_diffuse = compute_kld_particles(k_diffuse)

    # 阶段 2：集中分布
    samples_focused = np.random.normal(0.0, 0.15, size=5000)
    bins_focused = set(np.floor(samples_focused / bin_size))
    k_focused = len(bins_focused)
    n_kld_focused = compute_kld_particles(k_focused)

    print(f"阶段 1（发散未知状态）: 活跃网格数 k={k_diffuse:2d} -> 自适应粒子数={n_kld_diffuse:4d}")
    print(f"阶段 2（收敛跟踪状态）: 活跃网格数 k={k_focused:2d} -> 自适应粒子数={n_kld_focused:4d}")
    print(f"收敛后算力节约比例: {(1.0 - n_kld_focused / n_kld_diffuse) * 100:.1f}%")


if __name__ == "__main__":
    main()
