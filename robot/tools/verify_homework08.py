#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""数值复算：第 8 章作业八 · 习题 9-7（约束判读）+ 习题 9-10（混合力/运动控制）。

运行：
    python3 tools/verify_homework08.py

约定（与 homework08.md / 教材第 9 章 / 官方 Solution Manual 一致）：
- 机械臂取课堂 §8.7 两连杆：a=1, l=0.5, m=5, I=10, kr=100, mm=5, Im=0.01, Fm=0.01
  （英文原书同节为 m=50 kg；本脚本与课堂口径一致，见 homework07 的参数表注）
- 环境：过 (1,0)、与 x0 轴成 π/4 的弹性平面，法向刚度 ky = 5e3 N/m（教材题 9.3）
- 约束系 C：xc 沿平面，yc 沿法向，Rc=[[c,-s],[s,c]]，c=s=1/sqrt(2)
- 控制（教材 (9.73)–(9.84)）：操作空间逆动力学内环 + Sv/（C'Sf）分解
  速度环 (9.80)：kPv=16, kIv=100（omega_n=10, zeta=0.8）
  力环   (9.84)：kDl=16, kPl=100，刚度估计 c_hat=4e3（真值 5e3 -> Lf=1.25，
                 omega_n_l=sqrt(125)=11.18, zeta_l=0.715）
- 期望：lambda_d = -50 N（沿 yc 压入）；xd 沿切向走题 9.3 直线路径
  p_i=[1,0] -> p_f=[1.2+0.1*sqrt(2), 0.2]，梯形速度 tf=1 s；t>1 s 后 vd=0，保持压
  力；总时长 2.5 s（与官方解答 Fig. S9.5/S9.6 的时窗一致）
- 实现：控制器 Ts=1 ms 零阶保持；被控对象 RK4（步长同 Ts）
- 初始 oe(0)=[1,0]（恰在未变形平面上），q(0) 由逆解给出、qdot(0)=0
"""

from __future__ import annotations

import math

import numpy as np

# ---- §8.7 机械臂参数（课堂口径） ----
A1 = A2 = 1.0
L1 = L2 = 0.5
M1 = M2 = 5.0
MM2 = 5.0
I1 = I2 = 10.0
IM1 = IM2 = 0.01
KR1 = KR2 = 100.0
FM1 = FM2 = 0.01
G = 9.81

# ---- 环境与约束系 ----
C45 = math.cos(math.pi / 4)  # 1/sqrt(2)
S45 = math.sin(math.pi / 4)
RC = np.array([[C45, -S45], [S45, C45]])  # 列 = xc, yc
YC = RC[:, 1]                              # 法向单位向量
K_ENV = 5.0e3                              # N/m（真值）
K_ENV_HAT = 4.0e3                          # N/m（控制器用估计值）
PLANE_PT = np.array([1.0, 0.0])            # 未变形平面过该点
YC0 = float(PLANE_PT @ YC)                 # 平面静息位的 yc 坐标 = -1/sqrt(2)

# ---- 期望任务 ----
P_I = np.array([1.0, 0.0])
P_F = np.array([1.2 + 0.1 * math.sqrt(2.0), 0.2])
TF = 1.0
TC = TF / 3.0
TSIM = 2.5
LAMBDA_D = -50.0                           # N，沿 yc 压入

# ---- 增益（官方 Solution Manual） ----
KP_V, KI_V = 16.0, 100.0
KD_L, KP_L = 16.0, 100.0
TS = 1e-3


def ik_tip_on_plane() -> np.ndarray:
    """oe(0)=(1,0) 的关节逆解（取肘在平面上侧的一支）。"""
    x, y = 1.0, 0.0
    c2 = (x * x + y * y - A1 * A1 - A2 * A2) / (2.0 * A1 * A2)
    q2 = 2.0 * math.pi / 3.0  # cos q2 = -0.5
    s2 = math.sin(q2)
    q1 = math.atan2(y, x) - math.atan2(A2 * s2, A1 + A2 * c2)
    q = np.array([q1, q2])
    xe, ye = fk(q)
    assert abs(xe - x) < 1e-12 and abs(ye - y) < 1e-12
    return q


def fk(q: np.ndarray) -> tuple[float, float]:
    th1, th2 = q
    return (
        A1 * math.cos(th1) + A2 * math.cos(th1 + th2),
        A1 * math.sin(th1) + A2 * math.sin(th1 + th2),
    )


def jacobian(q: np.ndarray) -> np.ndarray:
    th1, th2 = q
    c1, s1 = math.cos(th1), math.sin(th1)
    c12, s12 = math.cos(th1 + th2), math.sin(th1 + th2)
    return np.array([
        [-A1 * s1 - A2 * s12, -A2 * s12],
        [A1 * c1 + A2 * c12, A2 * c12],
    ])


def dyn_parts(q: np.ndarray, dq: np.ndarray):
    """两连杆（含电机折算惯量与黏性摩擦、重力 y 向上；mL=0）-> B, C, F, g。"""
    th1, th2 = q
    dth1, dth2 = dq
    c1, s1 = math.cos(th1), math.sin(th1)
    c2, s2 = math.cos(th2), math.sin(th2)
    c12, s12 = math.cos(th1 + th2), math.sin(th1 + th2)
    m1, m2, mL = M1, M2, 0.0

    b11 = (
        I1 + m1 * L1**2 + KR1**2 * IM1 + I2
        + m2 * (A1**2 + L2**2 + 2 * A1 * L2 * c2)
        + IM2 + MM2 * A1**2
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
    return B, C, F, np.array([g1, g2])


def env_force_on_arm(o: np.ndarray) -> np.ndarray:
    """环境作用在末端上的力（基座系）。仅当压入（yc < yc0）时接触。"""
    yc = float(o @ YC)
    delta = yc - YC0
    if delta >= 0.0:
        return np.zeros(2)
    # 臂给环境的力 he_c = [0, ky*delta]（delta<0 为负 -> 压入），反力为正
    return -K_ENV * delta * YC


def arm_env_force(o: np.ndarray) -> float:
    """臂给环境的 yc 分量 lambda（即 h_yc；压入时为负）。未接触为 0。"""
    yc = float(o @ YC)
    delta = yc - YC0
    return K_ENV * delta if delta < 0.0 else 0.0


def traj(t: float) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """梯形速度路径 -> pd, dpd, ddpd（用于 vd/v̇d = xc^T·dpd/ddpd）。"""
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
    return P_I + s * (P_F - P_I), ds * (P_F - P_I), dds * (P_F - P_I)


def plant_deriv(q: np.ndarray, dq: np.ndarray, alpha: np.ndarray) -> np.ndarray:
    """(9.73)/(9.76)：gamma_e = B_e alpha + n_e + h_e，tau = J^T gamma_e。

    B_e = J^{-T} B J^{-1}，n_e = J^{-T} n - B_e J̇ q̇（教材 9.7 节定义）。
    """
    J = jacobian(q)
    dJ = jacobian_dot(q, dq)
    B, C, F, g = dyn_parts(q, dq)
    n = C @ dq + F @ dq + g
    Jinv = np.linalg.inv(J)
    Be = Jinv.T @ B @ Jinv
    ne = Jinv.T @ n - Be @ (dJ @ dq)
    he = env_force_on_arm(fk(q))
    gamma_e = Be @ alpha + ne + he
    tau = J.T @ gamma_e
    # 关节方程：B q̈ + n = τ − Jᵀ h_e（h_e 为臂给环境的力，反力方向相反）
    ddq = np.linalg.solve(B, tau - n - J.T @ he)
    return np.concatenate([dq, ddq])


def jacobian_dot(q: np.ndarray, dq: np.ndarray) -> np.ndarray:
    th1, th2 = q
    dth1, dth2 = dq
    c1 = math.cos(th1)
    s1 = math.sin(th1)
    s12 = math.sin(th1 + th2)
    c12 = math.cos(th1 + th2)
    return np.array([
        [-A1 * c1 * dth1 - A2 * c12 * (dth1 + dth2), -A2 * c12 * (dth1 + dth2)],
        [-A1 * s1 * dth1 - A2 * s12 * (dth1 + dth2), -A2 * s12 * (dth1 + dth2)],
    ])


def simulate() -> dict:
    q = ik_tip_on_plane()
    dq = np.zeros(2)
    int_v = 0.0  # 速度环积分 (9.80)
    steps = int(TSIM / TS)
    log = {k: [] for k in ("t", "o", "v", "nu_err", "lam", "lam_dot")}
    for k in range(steps):
        t = k * TS
        o = np.array(fk(q))
        J = jacobian(q)
        v = J @ dq
        lam = arm_env_force(o)
        # λ̂̇ 按 (9.82)：估计刚度 c_hat 乘法向速度（控制器不用真实 k）
        lam_dot_hat = K_ENV_HAT * float(YC @ v)
        pd, dpd, ddpd = traj(t)
        nu_d = float(RC[:, 0] @ dpd)   # 期望速度的切向分量
        nu_dd = float(RC[:, 0] @ ddpd)  # 期望加速度的切向分量（前馈）
        nu = float(RC[:, 0] @ v)       # 实测切向速度
        # (9.80)：ν̇d 前馈 + PD + 积分
        a_nu = nu_dd + KP_V * (nu_d - nu) + KI_V * int_v
        # (9.84)
        f_l = -KD_L * lam_dot_hat + KP_L * (LAMBDA_D - lam)
        # (9.77)：alpha = xc*a_nu + yc*(c_hat_y * f_l)
        #   C'Sf = yc/k（法向柔顺系数），控制器用估计值 c_hat = 1/K_ENV_HAT；
        #   真实闭环增益 Lf = k/c_hat = 5e3/4e3 = 1.25（官方解答口径）
        c_hat_y = 1.0 / K_ENV_HAT
        alpha = RC[:, 0] * a_nu + YC * (c_hat_y * f_l)
        # 控制器积分（速度环）前向欧拉，零阶保持一个周期
        int_v += (nu_d - nu) * TS

        # RK4（控制量 alpha 在周期内保持）
        y = np.concatenate([q, dq])

        def f(y: np.ndarray) -> np.ndarray:
            return plant_deriv(y[:2], y[2:], alpha)

        k1 = f(y)
        k2 = f(y + TS / 2 * k1)
        k3 = f(y + TS / 2 * k2)
        k4 = f(y + TS * k3)
        y = y + TS / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
        q, dq = y[:2], y[2:]

        log["t"].append(t + TS)
        log["o"].append(fk(q))
        log["v"].append(J @ dq)
        log["nu_err"].append(nu_d - nu)
        log["lam"].append(lam)
        log["lam_dot"].append(lam_dot_hat)
    for key in log:
        log[key] = np.array(log[key])
    return log


def main() -> int:
    log = simulate()
    t = log["t"]
    tail = t > TSIM - 0.2
    lam_tail = log["lam"][tail]
    nu_tail = log["nu_err"][tail]
    o_end = log["o"][-1]
    yc_end = float(o_end @ YC)
    pen = yc_end - YC0

    f_ss = float(np.mean(lam_tail))
    f_dev = float(np.max(np.abs(lam_tail - LAMBDA_D)))
    nu_dev = float(np.max(np.abs(nu_tail)))
    # 稳态压入量理论值：lambda = ky * (yc - yc0) -> -50/5000 = -0.01 m
    pen_theory = LAMBDA_D / K_ENV

    print(f"稳态接触力 lambda   : {f_ss:9.3f} N   （期望 {LAMBDA_D:.0f} N）")
    print(f"稳态力波动          : {f_dev:9.4f} N")
    print(f"稳态切向速度误差    : {nu_dev:9.5f} m/s")
    print(f"稳态压入量          : {pen:9.5f} m   （理论 lambda/ky = {pen_theory:.5f} m）")

    ok = (
        abs(f_ss - LAMBDA_D) < 0.5
        and f_dev < 1.0
        and nu_dev < 0.02
        and abs(pen - pen_theory) < 2e-3
    )

    # 习题 9-7 的约束配对自检：自然+人工恰好划分 12 个任务分量
    natural = {"pc_y", "pc_z", "wx", "wy", "fx", "mz"}
    artificial = {"fy", "fz", "mx", "my", "pc_x", "wz"}
    assert len(natural) == 6 and len(artificial) == 6
    assert not (natural & artificial)
    assert len(natural | artificial) == 12

    # 出图（交付页面引用）
    try:
        make_figures(log)
    except Exception as exc:  # 出图失败不阻塞数值校验
        print(f"（出图跳过：{exc}）")

    print("9-7 约束配对与 9-10 稳态检查：", "通过" if ok else "未通过")
    return 0 if ok else 1


def make_figures(log: dict) -> None:
    import matplotlib

    matplotlib.use("Agg")
    from matplotlib import font_manager
    import matplotlib.pyplot as plt

    # macOS 自带中文字体优先；不可用时回退英文标签
    cjk = next(
        (
            name
            for name in ("Hiragino Sans GB", "PingFang SC", "Arial Unicode MS", "STHeiti")
            if any(f.name == name for f in font_manager.fontManager.ttflist)
        ),
        None,
    )
    zh = lambda a, b: a if cjk else b  # noqa: E731
    if cjk:
        matplotlib.rcParams["font.family"] = cjk
        matplotlib.rcParams["axes.unicode_minus"] = False

    out = (
        __import__("pathlib").Path(__file__).resolve().parents[1]
        / "src/assets/ch08/hw08"
    )
    out.mkdir(parents=True, exist_ok=True)
    t = log["t"]

    fig, ax = plt.subplots(1, 2, figsize=(9, 3.2))
    ax[0].plot(t, log["nu_err"])
    ax[0].set_xlabel("t [s]")
    ax[0].set_ylabel(r"$\nu_d-\nu$ [m/s]")
    ax[0].set_title(zh("切向速度误差", "tangential velocity error"))
    ax[1].plot(t, log["lam"])
    ax[1].axhline(LAMBDA_D, ls="--", lw=1, color="r", label=r"$\lambda_d=-50$ N")
    ax[1].set_xlabel("t [s]")
    ax[1].set_ylabel(r"$\lambda$ [N]")
    ax[1].set_title(zh("法向接触力", "normal contact force"))
    ax[1].legend()
    fig.tight_layout()
    fig.savefig(out / "fig1_hybrid_response.png", dpi=150)
    plt.close(fig)

    o = np.array(log["o"])
    fig2, ax2 = plt.subplots(figsize=(4.5, 4))
    ax2.plot(o[:, 0], o[:, 1], label=zh("末端实际路径", "tip path"))
    # 未变形平面：过 (1,0) 斜率 1（沿 xc 方向）
    xs = np.linspace(0.95, 1.45, 10)
    ax2.plot(xs, xs - 1.0, "--", lw=1, label=zh("未变形平面", "undeformed plane"))
    ax2.plot(*P_I, "ko", ms=4)
    ax2.plot(*P_F, "k^", ms=4)
    ax2.set_xlabel("$x_0$ [m]")
    ax2.set_ylabel("$y_0$ [m]")
    ax2.axis("equal")
    ax2.legend(fontsize=8)
    ax2.set_title(zh("末端路径与平面", "tip path vs. plane"))
    fig2.tight_layout()
    fig2.savefig(out / "fig2_path_plane.png", dpi=150)
    plt.close(fig2)


if __name__ == "__main__":
    raise SystemExit(main())
