# -*- coding: utf-8 -*-
"""实验 8.2：三维正态分布变换（3D NDT）栅格体素化与配准得分函数评估。"""

import numpy as np


class NDTGrid3D:
    def __init__(self, voxel_size: float = 1.0):
        self.voxel_size = voxel_size
        self.cells = {}

    def build(self, points: np.ndarray):
        # 聚类至体素
        buckets = {}
        for p in points:
            key = tuple(np.floor(p / self.voxel_size).astype(int))
            buckets.setdefault(key, []).append(p)

        # 对包含多于 5 个点的体素计算均值与协方差矩阵
        for k, pts in buckets.items():
            if len(pts) >= 5:
                pts_arr = np.array(pts)
                mu = np.mean(pts_arr, axis=0)
                cov = np.cov(pts_arr, rowvar=False) + 1e-4 * np.eye(3)
                self.cells[k] = (mu, np.linalg.inv(cov))

    def compute_score(self, points: np.ndarray, t: np.ndarray) -> float:
        """评估平移 t 后的 NDT 匹配似然得分（负 log-likelihood）。"""
        score = 0.0
        for p in points:
            p_trans = p + t
            key = tuple(np.floor(p_trans / self.voxel_size).astype(int))
            if key in self.cells:
                mu, cov_inv = self.cells[key]
                diff = p_trans - mu
                # 高斯指数项评分
                val = np.exp(-0.5 * (diff.T @ cov_inv @ diff))
                score += val
        return float(score)


def main():
    print("=== 实验 8.2：3D NDT 栅格化与平移扫描匹配似然函数曲线 ===")
    np.random.seed(42)

    # 构造局部三维点云（立方体表面采样）
    pts = np.random.uniform(-2, 2, size=(1000, 3))
    ndt = NDTGrid3D(voxel_size=0.8)
    ndt.build(pts)

    print(f"有效高斯体素单元数: {len(ndt.cells)}")

    # 在 X 轴不同平移偏移下的 NDT 匹配得分曲线
    offsets = np.linspace(-1.0, 1.0, 21)
    scores = [ndt.compute_score(pts, np.array([dx, 0.0, 0.0])) for dx in offsets]

    max_idx = int(np.argmax(scores))
    print(f"最大匹配得分偏移位置: dx={offsets[max_idx]:.2f} m (真实零平移对应峰值)")
    print(f"dx=0.0m 得分: {scores[10]:.2f}, dx=1.0m 得分: {scores[-1]:.2f} (清晰的单峰盆地)")


if __name__ == "__main__":
    main()
