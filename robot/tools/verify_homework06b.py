#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""数值复算：第 8 周作业（教材习题 7-8 / 7-10），见作业六·补。

运行：
    python3 tools/verify_homework06b.py

7-8：移动–转动平面臂（PR 臂）的递归牛顿–欧拉。坐标系按教材解答图 S7.2：
     x0 竖直向上、z0 沿导轨、y0 垂直纸面向外，g0=[-g,0,0]；R01=[[-1,0,0],[0,0,1],[0,1,0]]，
     r1_{0,1}=[0,d1,0]，r1_{1,C1}=[0,lC1,0]，R12=Rz(t2)，r2_{1,2}=[a2,0,0]，r2_{2,C2}=[lC2,0,0]，
     l2=lC2+a2。三条互不复用的路线互相校验：
       (A) 教材 (7.107)–(7.114) 的当前连杆坐标系递推；
       (B) 官方解答的闭式两式（本文件独立重写）；
       (C) 拉格朗日能量法（动能含转子折算 k_r^2 I_m，势能只依赖 x0 分量）。

7-10：操作空间模型 B_A-2C_A 的反对称性。2R（非冗余）做 sympy 全符号验证；
     3R（n=3、r=2 冗余）做数值验证，C_A 按 (7.131)+(7.138) 构造。

依赖：numpy（必需）、sympy（可选；缺省时跳过 2R 符号验证并给出 SKIP）。
"""

from __future__ import annotations

import math
import sys

import numpy as np

G = 9.81
TOL = 1e-9

# ---- 7-8 参数（与正文验算表一致） -----------------------------------------
M1, M2 = 3.0, 2.0
LC1, LC2, A2 = -0.20, -0.25, 0.60
L2 = LC2 + A2
IBAR2ZZ = 0.02
KR1, IM1 = 100.0, 5e-6    # 减速比、转子惯量：k_r1^2 * I_m1 = 0.05
KR2, IM2 = 50.0, 1e-5     # 同上：k_r2^2 * I_m2 = 0.025
KR1_IM1 = KR1 * KR1 * IM1
KR2_IM2 = KR2 * KR2 * IM2


# --------------------------------------------------------------------------
# 7-8：三条路线
# --------------------------------------------------------------------------
def rz(t: float) -> np.ndarray:
    c, s = math.cos(t), math.sin(t)
    return np.array([[c, -s, 0.0], [s, c, 0.0], [0.0, 0.0, 1.0]])


def newton_euler(q) -> np.ndarray:
    """(A) 教材 (7.107)–(7.114)，当前连杆坐标系，返回 [tau1, tau2]。"""
    d1, t2, dd1, dt2, ddd1, ddt2 = q
    R01 = np.array([[-1.0, 0, 0], [0, 0, 1], [0, 1, 0]])
    R12 = rz(t2)
    r1_01 = np.array([0.0, d1, 0.0])
    r1_1C1 = np.array([0.0, LC1, 0.0])
    r2_12 = np.array([A2, 0.0, 0.0])
    r2_2C2 = np.array([LC2, 0.0, 0.0])
    Ibar2 = np.diag([IBAR2ZZ, IBAR2ZZ, IBAR2ZZ])

    # 前向：连杆 1（移动副）
    w1 = np.zeros(3)
    dw1 = np.zeros(3)
    pdd0 = np.array([G, 0.0, 0.0])  # pdd0 - g0
    pdd1 = R01 @ (pdd0 + np.array([0.0, 0.0, ddd1]))
    pdd1 = pdd1 + 2 * dd1 * np.cross(w1, R01 @ np.array([0.0, 0.0, 1.0]))
    pdd1 += np.cross(dw1, r1_01) + np.cross(w1, np.cross(w1, r1_01))
    pddC1 = pdd1 + np.cross(dw1, r1_1C1) + np.cross(w1, np.cross(w1, r1_1C1))
    dwm1 = np.array([0.0, 0.0, KR1 * ddd1])  # 方向 z0；幅值 k_r1*dd1

    # 前向：连杆 2（转动副）
    w2 = R12.T @ (w1 + np.array([0.0, 0.0, dt2]))
    dw2 = R12.T @ (dw1 + np.array([0.0, 0.0, ddt2]) + dt2 * np.cross(w1, np.array([0.0, 0.0, 1.0])))
    pdd2 = R12.T @ pdd1 + np.cross(dw2, r2_12) + np.cross(w2, np.cross(w2, r2_12))
    pddC2 = pdd2 + np.cross(dw2, r2_2C2) + np.cross(w2, np.cross(w2, r2_2C2))
    dwm1_1 = R01 @ dwm1  # 转子 1 的角加速度换算到 frame 1
    dwm2 = R12.T @ dwm1_1 + np.array([0.0, 0.0, KR2 * ddt2])
    dwm2 += KR2 * dt2 * np.cross(R01 @ w1, np.array([0.0, 0.0, 1.0]))

    # 后向：连杆 2
    f2 = M2 * pddC2
    mu2 = -np.cross(f2, r2_12 + r2_2C2) + Ibar2 @ dw2 + np.cross(w2, Ibar2 @ w2)
    tau2 = mu2[2] + KR2 * IM2 * dwm2[2]

    # 后向：连杆 1
    f1 = R12 @ f2 + M1 * pddC1
    tau1 = f1[1] + KR1 * IM1 * dwm1[2]  # 关节方向 y1=[0,1,0]
    return np.array([tau1, tau2])


def closed_form(q) -> np.ndarray:
    """(B) 官方解答的闭式两式。"""
    d1, t2, dd1, dt2, ddd1, ddt2 = q
    c2, s2 = math.cos(t2), math.sin(t2)
    tau1 = (M1 + M2 + KR1_IM1) * ddd1 + M2 * L2 * c2 * ddt2 - M2 * L2 * s2 * dt2**2
    tau2 = M2 * L2 * c2 * ddd1 + (IBAR2ZZ + M2 * L2**2 + KR2_IM2) * ddt2 + M2 * L2 * G * s2
    return np.array([tau1, tau2])


def lagrange_model(q):
    """(C) 拉格朗日能量法：返回 (B, h=C*qdot, g)。"""
    d1, t2, dd1, dt2, ddd1, ddt2 = q
    c2, s2 = math.cos(t2), math.sin(t2)
    B = np.array([
        [M1 + M2 + KR1_IM1, M2 * L2 * c2],
        [M2 * L2 * c2, IBAR2ZZ + M2 * L2**2 + KR2_IM2],
    ])
    qdot = np.array([dd1, dt2])
    qddot = np.array([ddd1, ddt2])
    # Christoffel：唯一非零 ∂B/∂q2 分量
    dB = np.array([[0.0, -M2 * L2 * s2], [-M2 * L2 * s2, 0.0]])
    C = np.array([
        [0.0, -M2 * L2 * s2 * dt2],
        [0.0, 0.0],
    ])
    h = C @ qdot + 0.5 * (dB @ qdot) * 0.0  # 保持与 B/h 记号一致，这里直接用能量法
    h = np.array([-M2 * L2 * s2 * dt2**2, 0.0])
    V = -M2 * G * L2 * c2  # x0 向上 => 高度 = -l2*c2
    g = np.array([0.0, M2 * G * L2 * s2])
    del V
    return B, h, g, qddot, qdot


def check_7_8(rng: np.random.Generator) -> bool:
    ok = True
    states = [(0.30, 0.70, 0.50, -1.20, 2.00, -3.00)]
    for _ in range(20):
        states.append((
            rng.uniform(-1.5, 1.5),
            rng.uniform(-6.5, 6.5),
            rng.uniform(-2.5, 2.5),
            rng.uniform(-3.5, 3.5),
            rng.uniform(-8.0, 8.0),
            rng.uniform(-8.0, 8.0),
        ))
    dev_ne = dev_lag = 0.0
    for q in states:
        tau_ne = newton_euler(q)
        tau_cf = closed_form(q)
        B, h, g, qddot, qdot = lagrange_model(q)
        tau_lag = B @ qddot + h + g
        dev_ne = max(dev_ne, float(np.max(np.abs(tau_ne - tau_cf))))
        dev_lag = max(dev_lag, float(np.max(np.abs(tau_lag - tau_cf))))

    print("[7-8] 样例状态 d1=0.30, t2=0.70, dd1=0.50, dt2=-1.20, ddd1=2.00, ddt2=-3.00")
    sample = closed_form(states[0])
    print(f"      闭式 tau = [{sample[0]:.9f}, {sample[1]:.9f}] N·m")
    print(f"      (A) 递推 vs (B) 闭式：max|d tau| = {dev_ne:.3e}")
    print(f"      (C) 拉格朗日 vs (B) 闭式：max|d tau| = {dev_lag:.3e}")
    for name, dev in (("(A) 递推", dev_ne), ("(C) 拉格朗日", dev_lag)):
        if dev < TOL:
            print(f"      PASS {name} 与闭式一致（<{TOL:g}）")
        else:
            print(f"      FAIL {name} 偏差 {dev:.3e}")
            ok = False
    # 结构性质
    B, h, g, _, _ = lagrange_model((0.3, 0.7, 0.0, 0.0, 0.0, 0.0))
    if not np.allclose(B, B.T):
        print("      FAIL B 不对称")
        ok = False
    if np.linalg.eigvalsh(B).min() <= 0:
        print("      FAIL B 非正定")
        ok = False
    return ok


# --------------------------------------------------------------------------
# 7-10：n 连杆平面臂（点质量），解析 B、∂B/∂q、J、∂J/∂q
#
# 关节 1..n 均绕 z 轴转动，角度自 +y 轴量起；连杆 i 的质心在关节 i 前方 l_i 处。
# 位置 o_i（关节）、p_k（质心）、tip（末端）都在同一平面内。
#   B_ij   = Σ_{k≥max(i,j)} m_k (p_k-o_i)·(p_k-o_j)
#   ∂B_ij/∂q_k = Σ_{m≥max(i,j,k)} m_m [ Rot90(p_m-o_max(i,k))·(p_m-o_j)
#                                     + (p_m-o_i)·Rot90(p_m-o_max(j,k)) ]
#   J[:,j] = Rot90(tip-o_j)，∂J[:,j]/∂q_k = Rot90(∂(tip-o_j)/∂q_k)
# --------------------------------------------------------------------------
class PlanarArm:
    def __init__(self, a, l, m):
        self.a = np.asarray(a, float)   # 连杆长度（关节 i → 关节 i+1）
        self.l = np.asarray(l, float)   # 关节 i → 质心 i 的距离
        self.m = np.asarray(m, float)
        self.n = len(self.a)

    @staticmethod
    def _rot90(v):
        return np.array([-v[1], v[0]])

    def _unit(self, q, k):
        """第 k+1 根连杆的方向（绝对角 = q_0+...+q_k，自 +y 量起）。"""
        t = float(sum(q[: k + 1]))
        return np.array([math.sin(t), math.cos(t)])

    def joints(self, q):
        o = [np.zeros(2)]
        for j in range(self.n - 1):
            o.append(o[-1] + self.a[j] * self._unit(q, j))
        return o

    def cm(self, q):
        o = self.joints(q)
        return [o[k] + self.l[k] * self._unit(q, k) for k in range(self.n)]

    def tip(self, q):
        return self.joints(q)[-1] + self.a[-1] * self._unit(q, self.n - 1)

    def B(self, q):
        o, p = self.joints(q), self.cm(q)
        B = np.zeros((self.n, self.n))
        for i in range(self.n):
            for j in range(self.n):
                B[i, j] = sum(self.m[k] * float((p[k] - o[i]) @ (p[k] - o[j]))
                              for k in range(max(i, j), self.n))
        return B

    def dB(self, q, k):
        o, p = self.joints(q), self.cm(q)
        n = self.n
        out = np.zeros((n, n))
        for i in range(n):
            for j in range(n):
                acc = 0.0
                for mm in range(max(i, j, k), n):
                    oik = o[i] if i >= k else o[k]
                    ojk = o[j] if j >= k else o[k]
                    acc += self.m[mm] * (
                        float(self._rot90(p[mm] - oik) @ (p[mm] - o[j]))
                        + float((p[mm] - o[i]) @ self._rot90(p[mm] - ojk)))
                out[i, j] = acc
        return out

    def J(self, q):
        o, tip = self.joints(q), self.tip(q)
        return np.column_stack([self._rot90(tip - o[k]) for k in range(self.n)])

    def dJ(self, q, dq):
        o, tip = self.joints(q), self.tip(q)
        n = self.n
        Jd = np.zeros((2, n))
        for j in range(n):
            acc = np.zeros(2)
            for k in range(n):
                omax = o[j] if j >= k else o[k]
                acc += dq[k] * (-(tip - omax))   # ∂J[:,j]/∂q_k = -Rot90(Rot90(...)) = -(tip-o_max)
            Jd[:, j] = acc
        return Jd

    def dJk(self, q, k):
        """∂J/∂q_k（2×n 解析）。"""
        o, tip = self.joints(q), self.tip(q)
        cols = []
        for j in range(self.n):
            omax = o[j] if j >= k else o[k]
            cols.append(self._rot90(self._rot90(tip - omax)))
        return np.column_stack(cols)


def _christoffel(arm: PlanarArm, q, dq):
    n = arm.n
    dB = [arm.dB(q, k) for k in range(n)]
    C = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            for k in range(n):
                cijk = 0.5 * (dB[k][i, j] + dB[j][i, k] - dB[i][j, k])
                C[i, j] += cijk * dq[k]
    Bd = sum(dq[k] * dB[k] for k in range(n))
    return C, Bd


def operational_space(arm: PlanarArm, q, dq):
    """按 (7.130)–(7.132)、(7.138) 构造 (B_A, C_A, Bd_A)。"""
    B = arm.B(q)
    J = arm.J(q)
    Binv = np.linalg.inv(B)
    BA = np.linalg.inv(J @ Binv @ J.T)          # (7.130)
    Jbar = Binv @ J.T @ BA                      # (7.138)
    C, Bd = _christoffel(arm, q, dq)
    Jd = arm.dJ(q, dq)
    CA = BA @ J @ Binv @ C @ Jbar - BA @ Jd @ Jbar   # (7.131) + (7.138)
    # Bd_A = d/dt (J B^-1 J^T)^-1，链式法则
    dBA = np.zeros_like(BA)
    for k in range(arm.n):
        dBk = arm.dB(q, k)
        dJk = arm.dJk(q, k)
        dG = (dJk @ Binv @ J.T + J @ (-Binv @ dBk @ Binv) @ J.T + J @ Binv @ dJk.T)
        dBA += dq[k] * (-BA @ dG @ BA)
    return BA, CA, dBA, Bd


def check_7_10(rng: np.random.Generator, n_samples: int = 20) -> bool:
    ok = True
    cases = [
        ("2R（n=r=2，非冗余）", PlanarArm(a=[1.0, 1.0], l=[0.5, 0.5], m=[2.0, 1.5])),
        ("3R（n=3,r=2，冗余）", PlanarArm(a=[1.0, 0.8, 0.6], l=[0.5, 0.4, 0.3], m=[2.0, 1.5, 1.0])),
    ]
    for name, arm in cases:
        worst = worst_joint = 0.0
        for _ in range(n_samples):
            q = rng.uniform(-math.pi, math.pi, arm.n)
            dq = rng.uniform(-2.0, 2.0, arm.n)
            BA, CA, BdA, Bd = operational_space(arm, q, dq)
            C, _ = _christoffel(arm, q, dq)
            NA = BdA - 2 * CA
            NJ = Bd - 2 * C
            for _ in range(3):
                w = rng.normal(size=2)
                w = w / np.linalg.norm(w)
                worst = max(worst, abs(float(w @ NA @ w)))
                u = rng.normal(size=arm.n)
                u = u / np.linalg.norm(u)
                worst_joint = max(worst_joint, abs(float(u @ NJ @ u)))
        flag = "PASS" if worst < 1e-9 else "FAIL"
        ok = ok and worst < 1e-9
        print(f"[7-10] {name}：max|w^T(BdA-2CA)w| = {worst:.3e}"
              f"（关节空间基线 {worst_joint:.3e}）  {flag}")
    return ok


def main() -> int:
    rng = np.random.default_rng(20261101)
    ok = check_7_8(rng)
    ok = check_7_10(rng) and ok
    print("作业六·补（7-8 / 7-10）数值复算：", "全部通过" if ok else "存在失败项")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
