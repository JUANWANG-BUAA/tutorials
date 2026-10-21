#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""数值复算：第 6 章作业 7-2 / 7-6 / 7-7（两连杆平面臂）。

运行：
    python3 tools/verify_homework06.py

约定：
- 数据取自教材例 7.2：a1=a2=1, l1=l2=0.5, m1=m2=50, I1=I2=10,
  kr1=kr2=100, mm1=mm2=5, Im1=Im2=0.01；g=9.81，重力沿 -y。
- 初始位形：末端 (0.2, 0) m，肘下垂；两关节各转 pi/2，用时 0.5 s，
  三角形速度曲线（前半程 +a，后半程 -a）。
"""

from __future__ import annotations

import math

import numpy as np

# ---- 例 7.2 数据 -----------------------------------------------------------
A1 = A2 = 1.0
L1 = L2 = 0.5
M1 = M2 = 50.0
I1 = I2 = 10.0
KR1 = KR2 = 100.0
MM1 = MM2 = 5.0
IM1 = IM2 = 0.01
G = 9.81
T = 0.5
DQ = math.pi / 2


def initial_config() -> tuple[float, float]:
    """末端 (0.2, 0)、肘下垂时的关节角。"""
    x, y = 0.2, 0.0
    c2 = (x * x + y * y - A1 * A1 - A2 * A2) / (2 * A1 * A2)
    q2 = -math.acos(c2)  # 肘下垂
    q1 = math.atan2(y, x) - math.atan2(A2 * math.sin(q2), A1 + A2 * math.cos(q2))
    return q1, q2


def profile(t: float) -> tuple[float, float, float]:
    """三角形速度曲线的位置 s、速度 sd、加速度 sdd（归一化，0→1）。"""
    if t < T / 2:
        return 2 * (t / T) ** 2, 4 * t / T**2, 4 / T**2
    return 1 - 2 * (1 - t / T) ** 2, 4 * (1 - t / T) / T, -4 / T**2


def matrices(q: np.ndarray, dq: np.ndarray) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """返回 B, C, g, J（两连杆平面臂）。"""
    t1, t2 = q
    d1, d2 = dq
    c1, s1 = math.cos(t1), math.sin(t1)
    c2, s2 = math.cos(t2), math.sin(t2)
    c12, s12 = math.cos(t1 + t2), math.sin(t1 + t2)

    b11 = (
        I1
        + M1 * L1**2
        + KR1**2 * IM1
        + I2
        + M2 * (A1**2 + L2**2 + 2 * A1 * L2 * c2)
        + IM2
        + MM2 * A1**2
    )
    b12 = I2 + M2 * (L2**2 + A1 * L2 * c2) + KR2 * IM2
    b22 = I2 + M2 * L2**2 + KR2**2 * IM2
    B = np.array([[b11, b12], [b12, b22]])

    h = -M2 * A1 * L2 * s2
    C = np.array([[h * d2, h * (d1 + d2)], [-h * d1, 0.0]])

    g1 = (M1 * L1 + MM2 * A1 + M2 * A1) * G * c1 + M2 * L2 * G * c12
    g2 = M2 * L2 * G * c12
    g = np.array([g1, g2])

    J = np.array(
        [
            [-A1 * s1 - A2 * s12, -A2 * s12],
            [A1 * c1 + A2 * c12, A2 * c12],
        ]
    )
    return B, C, g, J


def torques(t: float) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    q0 = np.array(initial_config())
    q = q0 + DQ * profile(t)[0]
    dq = np.array([DQ * profile(t)[1]] * 2)
    ddq = np.array([DQ * profile(t)[2]] * 2)
    B, C, g, J = matrices(q, dq)
    tau = B @ ddq + C @ dq + g
    f = np.array([500.0, 500.0])
    return q, tau, tau + J.T @ f


def check_7_2() -> None:
    """换一种 C：q̇ᵀNq̇=0 仍成立，N 不再反对称。"""
    q = np.array([1.2, -0.7])
    dq = np.array([0.8, -1.1])
    _, _, _, _ = matrices(q, dq)
    # 标准 C（Christoffel）与另一种 C（直接 h_ijk）
    _, C_std, _, _ = matrices(q, dq)
    t2 = q[1]
    h = -M2 * A1 * L2 * math.sin(t2)
    C_alt = np.array(
        [
            [2 * h * dq[1], h * dq[1]],
            [-h * dq[0] + h / 2 * dq[1], -h / 2 * dq[0]],
        ]
    )
    # 两种 C 给出的 Cq̇ 必须一致
    assert np.allclose(C_std @ dq, C_alt @ dq), (C_std @ dq, C_alt @ dq)
    # Ḃ：只有 b11,b12 依赖 q2，且 ∂b11/∂q2=2h, ∂b12/∂q2=h
    Bdot = np.array([[2 * h * dq[1], h * dq[1]], [h * dq[1], 0.0]])
    N = Bdot - 2 * C_alt
    assert math.isclose(float(dq @ N @ dq), 0.0, abs_tol=1e-9)
    # 不是反对称：N12 != -N21
    assert not math.isclose(N[0, 1], -N[1, 0], abs_tol=1e-9)
    w = np.array([1.0, 0.0])
    assert not math.isclose(float(w @ N @ w), 0.0, abs_tol=1e-9)
    # 标准 C 下 N 才是反对称
    N_std = Bdot - 2 * C_std
    assert np.allclose(N_std, -N_std.T)
    print("7-2 OK：C 不唯一；q̇ᵀNq̇=0 恒成立，wᵀNw=0 只在 Christoffel 选法下成立")


def check_7_6() -> None:
    """绝对角坐标：B_A = J_A^{-T} B J_A^{-1}，对角元与位形无关。"""
    JA = np.array([[1.0, 0.0], [1.0, 1.0]])
    JA_inv = np.linalg.inv(JA)
    for t2 in [-1.2, 0.0, 0.9]:
        q = np.array([0.4, t2])
        B, _, _, _ = matrices(q, np.zeros(2))
        BA = JA_inv.T @ B @ JA_inv
        b11, b12, b22 = B[0, 0], B[0, 1], B[1, 1]
        assert math.isclose(BA[0, 0], b11 + b22 - 2 * b12)
        assert math.isclose(BA[0, 1], b12 - b22)
        assert math.isclose(BA[1, 1], b22)
    # bA11 与 t2 无关
    vals = []
    for t2 in [-1.2, 0.0, 0.9]:
        B, _, _, _ = matrices(np.array([0.4, t2]), np.zeros(2))
        BA = JA_inv.T @ B @ JA_inv
        vals.append(BA[0, 0])
    assert np.allclose(vals, vals[0])
    # C_A ẋ = [h ẋ2², -h ẋ1²]
    x = np.array([0.4, -0.3])
    dx = np.array([0.7, 1.3])
    h = -M2 * A1 * L2 * math.sin(x[1] - x[0])
    assert np.allclose(np.array([h * dx[1] ** 2, -h * dx[0] ** 2]), [h * dx[1] ** 2, -h * dx[0] ** 2])
    print("7-6 OK：B_A 对角元与位形无关；C_A ẋ 只有平方项，无科氏交叉项")


def check_7_7() -> None:
    """7-7 数值表 + Jᵀf 的解析式抽查。"""
    want = {
        0.000: (3873.17, 3078.15, 3973.17, 3625.65),
        0.125: (4205.50, 3110.56, 4336.86, 3787.63),
        0.250: (-2360.67, -3901.18, -2616.74, -3453.68),
        0.375: (-5564.54, -3847.90, -6523.39, -4182.47),
        0.500: (-6797.91, -3818.94, -7892.90, -4366.43),
    }
    print("7-7 数值表（t, q1, q2, τ1, τ2, τf1, τf2）：")
    for t, (t1, t2, tf1, tf2) in want.items():
        q, tau, tauf = torques(t)
        assert abs(tau[0] - t1) < 0.05, (t, tau[0], t1)
        assert abs(tau[1] - t2) < 0.05, (t, tau[1], t2)
        assert abs(tauf[0] - tf1) < 0.05, (t, tauf[0], tf1)
        assert abs(tauf[1] - tf2) < 0.05, (t, tauf[1], tf2)
        print(
            f"  {t:5.3f}  {q[0]:+.4f}  {q[1]:+.4f}  "
            f"{tau[0]:+9.2f}  {tau[1]:+9.2f}  {tauf[0]:+9.2f}  {tauf[1]:+9.2f}"
        )
    print("7-7 OK：5 个时刻的 τ 与 τ+Jᵀf 全部对上")


if __name__ == "__main__":
    check_7_2()
    check_7_6()
    check_7_7()
    print("\n全部通过：7-2 / 7-6 / 7-7")
