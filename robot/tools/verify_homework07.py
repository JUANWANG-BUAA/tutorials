#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""数值复算：第 7 章作业七 · 习题 8-12（关节空间逆动力学）。

运行：
    python3 tools/verify_homework07.py

约定（与 homework07.md / 课堂 §8.7 一致）：
- 几何与驱动取课堂幻灯片：a=1, l=0.5, m=5, I=10, kr=100, mm=5, Im=0.01, Fm=0.01
- 末端集中负载 mL=10 kg（题 8-11）
- 轨迹：qi=[0, π/4] → qf=[π/2, π/2]，tf=1 s，梯形速度 tc=tf/3
- 增益：Kp=25 I，Kd=5 I（ωn=5, ζ=0.5）；Ts=1 ms；RK4 + ZOH
- 重力：y 向上，g0=[0,-g,0]
"""

from __future__ import annotations

import math

import numpy as np

A1 = A2 = 1.0
L1 = L2 = 0.5
M1 = M2 = 5.0
ML = 10.0
MM2 = 5.0
I1 = I2 = 10.0
IM1 = IM2 = 0.01
KR1 = KR2 = 100.0
FM1 = FM2 = 0.01
G = 9.81

KP = 25.0 * np.eye(2)
KD = 5.0 * np.eye(2)
TS = 1e-3
TF = 1.0
TC = TF / 3.0
TSIM = TF + 0.5

QI = np.array([0.0, math.pi / 4])
QF = np.array([math.pi / 2, math.pi / 2])

# MATLAB R2026b 实测（run_hw812.m），允许相对偏差
REF_EMAX = np.array([7.939427e-04, 4.070200e-04])
REF_ERMS = np.array([4.702411e-04, 2.421392e-04])
REF_UMAX = np.array([1709.33, 835.67])


def traj_trap(t: float) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    delta = QF - QI
    if t <= 0.0:
        s = ds = dds = 0.0
    elif t >= TF:
        s, ds, dds = 1.0, 0.0, 0.0
    else:
        vmax = 1.0 / (TF - TC)
        a = vmax / TC
        if t < TC:
            dds = a
            ds = a * t
            s = 0.5 * a * t * t
        elif t <= TF - TC:
            dds = 0.0
            ds = vmax
            s = 0.5 * a * TC * TC + vmax * (t - TC)
        else:
            dds = -a
            ds = vmax - a * (t - (TF - TC))
            s = 1.0 - 0.5 * a * (TF - t) ** 2
    return QI + s * delta, ds * delta, dds * delta


def plant(q: np.ndarray, dq: np.ndarray, m1: float = M1, m2: float = M2, mL: float = ML):
    th1, th2 = q
    dth1, dth2 = dq
    c1 = math.cos(th1)
    c2 = math.cos(th2)
    c12 = math.cos(th1 + th2)
    s2 = math.sin(th2)

    b11 = (
        I1
        + m1 * L1**2
        + KR1**2 * IM1
        + I2
        + m2 * (A1**2 + L2**2 + 2 * A1 * L2 * c2)
        + IM2
        + MM2 * A1**2
        + mL * (A1**2 + A2**2 + 2 * A1 * A2 * c2)
    )
    b12 = I2 + m2 * (L2**2 + A1 * L2 * c2) + KR2 * IM2 + mL * (A2**2 + A1 * A2 * c2)
    b22 = I2 + m2 * L2**2 + KR2**2 * IM2 + mL * A2**2
    B = np.array([[b11, b12], [b12, b22]])

    h = -m2 * A1 * L2 * s2 - mL * A1 * A2 * s2
    C = np.array([[h * dth2, h * (dth1 + dth2)], [-h * dth1, 0.0]])
    F = np.diag([FM1 * KR1**2, FM2 * KR2**2])
    g1 = (m1 * L1 + MM2 * A1 + m2 * A1 + mL * A1) * G * c1 + (m2 * L2 + mL * A2) * G * c12
    g2 = (m2 * L2 + mL * A2) * G * c12
    g = np.array([g1, g2])
    return B, C, F, g


def ode(x: np.ndarray, u: np.ndarray, **kw) -> np.ndarray:
    q, dq = x[:2], x[2:]
    B, C, F, g = plant(q, dq, **kw)
    ddq = np.linalg.solve(B, u - C @ dq - F @ dq - g)
    return np.concatenate([dq, ddq])


def simulate(*, plant_scale: float = 1.0, ctrl_use_true: bool = True) -> dict:
    """plant_scale: 被控对象质量相对标称的倍率；ctrl_use_true=False 时控制器用标称模型。"""
    t = np.arange(0.0, TSIM + 0.5 * TS, TS)
    n = t.size
    x = np.concatenate([QI, np.zeros(2)])
    e_log = np.zeros((2, n))
    u_log = np.zeros((2, n))
    q_log = np.zeros((2, n))

    plant_kw = dict(m1=M1 * plant_scale, m2=M2 * plant_scale, mL=ML * plant_scale)
    ctrl_kw = dict(m1=M1, m2=M2, mL=ML) if not ctrl_use_true else plant_kw

    for k, tk in enumerate(t):
        q, dq = x[:2], x[2:]
        qd, dqd, ddqd = traj_trap(tk)
        e = qd - q
        de = dqd - dq
        B, C, F, g = plant(q, dq, **ctrl_kw)
        y = ddqd + KD @ de + KP @ e
        u = B @ y + C @ dq + F @ dq + g

        q_log[:, k] = q
        e_log[:, k] = e
        u_log[:, k] = u

        if k < n - 1:
            f = lambda xx: ode(xx, u, **plant_kw)
            k1 = f(x)
            k2 = f(x + 0.5 * TS * k1)
            k3 = f(x + 0.5 * TS * k2)
            k4 = f(x + TS * k3)
            x = x + (TS / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4)

    return {
        "t": t,
        "q": q_log,
        "e": e_log,
        "u": u_log,
        "emax": np.max(np.abs(e_log), axis=1),
        "erms": np.sqrt(np.mean(e_log**2, axis=1)),
        "umax": np.max(np.abs(u_log), axis=1),
    }


def approx(a: np.ndarray, b: np.ndarray, rtol: float = 2e-2, atol: float = 1e-6) -> bool:
    return bool(np.allclose(a, b, rtol=rtol, atol=atol))


def main() -> int:
    nom = simulate()
    mism = simulate(plant_scale=1.10, ctrl_use_true=False)

    print("=== 作业七 · 8-12 逆动力学 ===")
    print(f"nominal  emax={nom['emax']}, erms={nom['erms']}, umax={nom['umax']}")
    print(f"mismatch emax={mism['emax']}  (plant +10%, ctrl nominal)")

    checks = [
        ("emax vs MATLAB", approx(nom["emax"], REF_EMAX, rtol=3e-2, atol=1e-6)),
        ("erms vs MATLAB", approx(nom["erms"], REF_ERMS, rtol=3e-2, atol=1e-6)),
        ("umax vs MATLAB", approx(nom["umax"], REF_UMAX, rtol=3e-2, atol=1.0)),
        ("nominal emax < 2e-3", bool(np.all(nom["emax"] < 2e-3))),
        ("mismatch worse", bool(np.all(mism["emax"] > nom["emax"]))),
    ]
    ok = True
    for name, passed in checks:
        print(f"  [{'PASS' if passed else 'FAIL'}] {name}")
        ok = ok and passed
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
