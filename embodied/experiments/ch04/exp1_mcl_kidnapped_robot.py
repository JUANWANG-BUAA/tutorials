# -*- coding: utf-8 -*-
"""实验 4.1：蒙特卡洛定位（MCL）与机器人绑架问题（Kidnapped Robot）恢复。"""

import numpy as np


def main():
    print("=== 实验 4.1：MCL 蒙特卡洛定位与绑架恢复 ===")
    np.random.seed(42)

    N_particles = 1000
    map_size = 20.0  # 1D 走廊 [0, 20]
    # 三个地标位置
    landmarks = np.array([4.0, 10.0, 16.0])

    # 初始粒子全地图均匀分布（全局定位阶段）
    particles = np.random.uniform(0.0, map_size, size=N_particles)
    weights = np.ones(N_particles) / N_particles

    true_pos = 2.0
    v_true = 0.5  # 步进 0.5m

    # 慢速与快速权重移动平均衰减率（Augmented MCL 绑架检测）
    alpha_slow = 0.05
    alpha_fast = 0.3
    w_slow = 0.0
    w_fast = 0.0

    for t in range(35):
        # 绑架事件注入：在第 20 步突然将机器人搬移至 15.0m 处
        if t == 20:
            print("\n>>> 触发机器人绑架事件！真实位置从 {:.2f}m 突变至 15.0m <<<".format(true_pos))
            true_pos = 15.0
        else:
            true_pos += v_true

        # 1. 运动预测
        particles += v_true + np.random.normal(0, 0.08, size=N_particles)
        particles = np.clip(particles, 0.0, map_size)

        # 2. 测量更新（测量到最近地标的相对距离）
        dists_true = np.abs(landmarks - true_pos)
        meas = np.min(dists_true) + np.random.normal(0, 0.1)

        # 计算每个粒子的似然
        for i in range(N_particles):
            p_dists = np.abs(landmarks - particles[i])
            pred_meas = np.min(p_dists)
            weights[i] = np.exp(-0.5 * ((meas - pred_meas) / 0.15)**2) + 1e-12

        w_avg = np.mean(weights)
        w_slow += alpha_slow * (w_avg - w_slow)
        w_fast += alpha_fast * (w_avg - w_fast)

        weights /= np.sum(weights)

        # 3. 低方差系统重采样 + 绑架恢复注入
        # 随机粒子注入概率：p_rand = max(0, 1 - w_fast / w_slow)
        p_rand = max(0.0, 1.0 - w_fast / max(w_slow, 1e-12))
        n_rand = int(p_rand * N_particles)

        # 重采样
        indices = np.random.choice(N_particles, size=N_particles - n_rand, p=weights)
        new_particles = particles[indices].copy()
        if n_rand > 0:
            rand_particles = np.random.uniform(0.0, map_size, size=n_rand)
            particles = np.concatenate((new_particles, rand_particles))
        else:
            particles = new_particles

        weights.fill(1.0 / N_particles)

        est_pos = float(np.mean(particles))
        std_pos = float(np.std(particles))
        if t in [5, 18, 22, 28, 34]:
            print(f"Step {t:2d}: 真实位置={true_pos:5.2f}m, 估计位置={est_pos:5.2f}m (std={std_pos:4.2f}m), 随机注入比例={p_rand*100:4.1f}%")


if __name__ == "__main__":
    main()
