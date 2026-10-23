# -*- coding: utf-8 -*-
"""实验 7.2：流形上的 IMU 状态预积分与零偏雅可比一阶更新验证。"""

import numpy as np
from scipy.spatial.transform import Rotation as R_scipy


def so3_exp(omega: np.ndarray) -> np.ndarray:
    return R_scipy.from_rotvec(omega).as_matrix()


def main():
    print("=== 实验 7.2：IMU 流形预积分与零偏更新一阶线性修正 ===")
    np.random.seed(42)

    dt = 0.01
    N_steps = 100  # 1 秒预积分区间 (100 Hz)

    # 标称零偏
    ba_nominal = np.array([0.02, -0.01, 0.05])
    bg_nominal = np.array([0.005, -0.002, 0.008])

    # 零偏微小扰动
    delta_bg = np.array([0.001, 0.0005, -0.0008])

    # 预积分累加变量：\Delta R, \Delta v, \Delta p
    delta_R = np.eye(3)
    delta_v = np.zeros(3)
    delta_p = np.zeros(3)

    # 零偏雅可比累加
    J_R_bg = np.zeros((3, 3))

    # 生成 1 秒内的角速度和加速度真值
    omegas = []
    accs = []
    for _ in range(N_steps):
        w = np.array([0.1, 0.2, 0.3]) + bg_nominal
        a = np.array([0.5, -0.2, 9.8]) + ba_nominal
        omegas.append(w)
        accs.append(a)

    # 1. 标称零偏下的预积分与雅可比递推
    for k in range(N_steps):
        w_unbias = omegas[k] - bg_nominal
        a_unbias = accs[k] - ba_nominal

        # 旋转增量 dR = exp(w * dt)
        dR = so3_exp(w_unbias * dt)

        delta_p += delta_v * dt + 0.5 * (delta_R @ a_unbias) * (dt**2)
        delta_v += (delta_R @ a_unbias) * dt

        # 旋转雅可比更新：J_{k+1} = dR^T * J_k - I * dt
        J_R_bg = dR.T @ J_R_bg - np.eye(3) * dt
        delta_R = delta_R @ dR

    # 2. 真实发生零偏变化后：重新全量积分计算真值
    delta_R_recomp = np.eye(3)
    bg_new = bg_nominal + delta_bg
    for k in range(N_steps):
        w_unbias_new = omegas[k] - bg_new
        dR_new = so3_exp(w_unbias_new * dt)
        delta_R_recomp = delta_R_recomp @ dR_new

    # 3. 利用预积分零偏一阶雅可比直接近似预测：
    # \Delta R(bg_nominal + \delta bg) \approx \Delta R * exp(J_R_bg * \delta bg)
    delta_R_taylor = delta_R @ so3_exp(J_R_bg @ delta_bg)

    diff_matrix = delta_R_taylor.T @ delta_R_recomp
    rot_error_norm = np.linalg.norm(R_scipy.from_matrix(diff_matrix).as_rotvec())

    print(f"预积分 100 步累加旋转矩阵 Trace: {np.trace(delta_R):.4f}")
    print(f"重新计算的精确积分旋转 Trace: {np.trace(delta_R_recomp):.4f}")
    print(f"雅可比一阶修正预测旋转 Trace: {np.trace(delta_R_taylor):.4f}")
    print(f"一阶线性化残差角度: {np.degrees(rot_error_norm):.5e} 度（无需重复百次数值积分即可精确复现）")


if __name__ == "__main__":
    main()
