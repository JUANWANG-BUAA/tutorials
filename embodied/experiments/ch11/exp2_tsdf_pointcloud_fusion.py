# -*- coding: utf-8 -*-
"""实验 11.2：截断符号距离函数（TSDF）三维体素融合与零等值面重建。"""

import numpy as np


class TSDFVoxelGrid:
    def __init__(self, size: int = 40, voxel_size: float = 0.05, trunc_margin: float = 0.15):
        self.size = size
        self.voxel_size = voxel_size
        self.trunc = trunc_margin

        # TSDF 距离场 D 与 权重场 W
        self.D = np.zeros((size, size, size), dtype=float)
        self.W = np.zeros((size, size, size), dtype=float)

    def integrate_depth(self, surface_z: float, weight: float = 1.0):
        """融合一个垂直于 Z 轴、真实深度为 surface_z 的平面点云。"""
        for z_idx in range(self.size):
            voxel_z = (z_idx + 0.5) * self.voxel_size
            # 符号距离 sdf = 表面深度 - 体素深度（体素在表面前为正，表面后为负）
            sdf = surface_z - voxel_z

            if sdf >= -self.trunc:
                tsdf_val = np.clip(sdf / self.trunc, -1.0, 1.0)
                w_old = self.W[:, :, z_idx]
                d_old = self.D[:, :, z_idx]

                w_new = w_old + weight
                self.D[:, :, z_idx] = (d_old * w_old + tsdf_val * weight) / w_new
                self.W[:, :, z_idx] = w_new


def main():
    print("=== 实验 11.2：TSDF 深度体素融合与零等值面零穿越 ===")
    grid = TSDFVoxelGrid(size=30, voxel_size=0.05, trunc_margin=0.15)

    # 模拟真实物体表面位于 Z = 0.75m 处
    # 模拟从两个不同相机帧观测该表面（带少许高斯噪声）
    grid.integrate_depth(surface_z=0.74, weight=1.0)
    grid.integrate_depth(surface_z=0.76, weight=1.0)

    # 提取沿 Z 轴的 TSDF 曲线
    z_coords = (np.arange(30) + 0.5) * 0.05
    tsdf_profile = grid.D[15, 15, :]

    # 寻找零穿越点 (Zero-crossing)
    zero_cross_idx = np.where(np.diff(np.sign(tsdf_profile)))[0]
    if len(zero_cross_idx) > 0:
        idx = zero_cross_idx[0]
        # 线性插值求精确零点
        z0 = z_coords[idx]
        z1 = z_coords[idx + 1]
        d0 = tsdf_profile[idx]
        d1 = tsdf_profile[idx + 1]
        z_surface_est = z0 - d0 * (z1 - z0) / (d1 - d0)
        print(f"设定真实表面 Z_gt: 0.750 m")
        print(f"TSDF 零等值面估计深度 Z_est: {z_surface_est:.4f} m (通过多帧融合自动消除观测噪声)")


if __name__ == "__main__":
    main()
