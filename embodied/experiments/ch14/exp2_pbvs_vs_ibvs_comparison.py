# -*- coding: utf-8 -*-
"""实验 14.2：IBVS 与 PBVS 在大角度旋转工况下的三维笛卡儿空间与图像特征轨迹对比（Camera Retreat 分析）。"""

import sys
import os
import numpy as np
from scipy.spatial.transform import Rotation as R_scipy

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "../../projects/arm-servoing")))
from arm_servoing.camera_model import PinholeCamera
from arm_servoing.simulator import ArmServoingSimulator


def main():
    print("=== 实验 14.2：IBVS 与 PBVS 大角度旋转下的相机后退（Camera Retreat）对比 ===")
    camera = PinholeCamera(fx=600.0, fy=600.0, cx=320.0, cy=240.0)
    sim = ArmServoingSimulator(camera)

    T_desired = np.eye(4)
    T_desired[2, 3] = 0.8

    # 大角度纯旋转工况：绕光轴 Z 旋转 60 度
    rot_init = R_scipy.from_euler("z", 60, degrees=True).as_matrix()
    T_init = np.eye(4)
    T_init[:3, :3] = rot_init
    T_init[:3, 3] = np.array([0.0, 0.0, 0.8])

    res_ibvs = sim.run_ibvs_simulation(T_init, T_desired, max_steps=120, dt=0.04)
    res_pbvs = sim.run_pbvs_simulation(T_init, T_desired, max_steps=120, dt=0.04)

    # 考察 IBVS 与 PBVS 在 Z 方向上的最大位移（后退现象）
    z_ibvs = res_ibvs["positions"][:, 2]
    z_pbvs = res_pbvs["positions"][:, 2]

    print(f"IBVS 在纯旋转时 Z 轴最大位置: {np.max(z_ibvs):.3f} m (发生了向后退行以缩小图像特征)")
    print(f"PBVS 在纯旋转时 Z 轴最大位置: {np.max(z_pbvs):.3f} m (在笛卡儿空间保持不动原地自转)")
    print("结论：IBVS 保证图像平面特征平滑，但笛卡儿空间易发生相机后退；PBVS 保证三维空间直线运动，但对标定和特征跑出视野敏感。")


if __name__ == "__main__":
    main()
