#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""作业九验算：教材第 10 章习题 10.4（必做）与 10.9（任选）。

10.4  平面 PnP 的解析解 + 基于图像雅可比求逆的位姿估计
10.9  SCARA + 平面目标的「位置式 · 速度分解」视觉伺服仿真，并与图像式对照

依赖：numpy、matplotlib（只用 numpy 画图时也可跑 matplotlib）
输出：assets/ch09/hw09/*.png 与终端表格
"""
from __future__ import annotations

import math
import os
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
BOOK = os.path.dirname(HERE)
OUT = os.path.join(BOOK, "src", "assets", "ch09", "hw09")
os.makedirs(OUT, exist_ok=True)

PI = math.pi
FAIL = []


def check(name, ok, detail=""):
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f"   {detail}" if detail else ""))
    if not ok:
        FAIL.append(name)


def rz(a):
    return np.array([[math.cos(a), -math.sin(a), 0.0],
                     [math.sin(a),  math.cos(a), 0.0],
                     [0.0, 0.0, 1.0]])


def skew(v):
    return np.array([[0.0, -v[2], v[1]],
                     [v[2], 0.0, -v[0]],
                     [-v[1], v[0], 0.0]])


# ---------------------------------------------------------------- 目标模型
# Example 10.1：边长 0.1 m 的正方形，四个特征点在目标系中的坐标（z_o = 0）
OBJ_PTS = np.array([[0.0, 0.0, 0.0],
                    [0.1, 0.0, 0.0],
                    [0.1, 0.1, 0.0],
                    [0.0, 0.1, 0.0]])
SIDE = 0.1

# Example 10.1 给定位姿（英文教材印刷页 422）
R_TRUE = np.array([[0.7071, 0.0, 0.7071],
                   [0.0,    1.0, 0.0],
                   [-0.7071, 0.0, 0.7071]])
O_TRUE = np.array([0.0, 0.0, 0.5])


def project_points(R, o, pts=OBJ_PTS):
    """目标点 → 相机系 → 归一化图像坐标。返回 (n,2) 与深度 (n,)。"""
    Rc = pts @ R.T + o            # (n,3) 相机系坐标
    z = Rc[:, 2].copy()
    z[np.abs(z) < 1e-12] = 1e-12
    return np.column_stack([Rc[:, 0] / z, Rc[:, 1] / z]), z


def point_interaction_matrix(X, Y, zc):
    """教材 (10.27)：单点的相互作用矩阵 L_s（2x6），v_c = [v(3); omega(3)]。"""
    return np.array([
        [-1.0 / zc, 0.0, X / zc, X * Y, -(1.0 + X * X), Y],
        [0.0, -1.0 / zc, Y / zc, 1.0 + Y * Y, -X * Y, -X],
    ])


def line_segment_features(XY):
    """教材 (10.28)：线段特征 (x_bar, y_bar, L, alpha)。"""
    dX = XY[1, 0] - XY[0, 0]
    dY = XY[1, 1] - XY[0, 1]
    L = math.hypot(dX, dY)
    return np.array([0.5 * (XY[0, 0] + XY[1, 0]),
                     0.5 * (XY[0, 1] + XY[1, 1]),
                     L,
                     math.atan2(dY, dX)])


def line_segment_jacobian_features(dX, dY, L):
    """教材 (10.28)：ds/ds1 与 ds/ds2。"""
    J1 = np.array([[0.5, 0.0],
                   [0.0, 0.5],
                   [-dX / L, -dY / L],
                   [dY / L ** 2, -dX / L ** 2]])
    J2 = np.array([[0.5, 0.0],
                   [0.0, 0.5],
                   [dX / L, dY / L],
                   [-dY / L ** 2, dX / L ** 2]])
    return J1, J2


def interaction_of_segment(XY, z):
    """线段的相互作用矩阵（4x6）：ds/ds1 * L_s1 + ds/ds2 * L_s2。"""
    dX = XY[1, 0] - XY[0, 0]
    dY = XY[1, 1] - XY[0, 1]
    L = math.hypot(dX, dY)
    J1, J2 = line_segment_jacobian_features(dX, dY, L)
    Ls1 = point_interaction_matrix(XY[0, 0], XY[0, 1], z[0])
    Ls2 = point_interaction_matrix(XY[1, 0], XY[1, 1], z[1])
    return J1 @ Ls1 + J2 @ Ls2


# ================================================================ Part 1
def part_10_4():
    """教材习题 10.4 的解析部分 + 数值位姿估计。"""
    print("\n=== 习题 10.4 · 平面 PnP 解析解（§9.3） ===")
    s_true, _ = project_points(R_TRUE, O_TRUE)

    # --- (1) 正算：核对教材 Example 10.1 的四个投影坐标
    want = np.array([[0.0, 0.0], [0.1647, 0.0], [0.1647, 0.2329], [0.0, 0.2]])
    err = np.abs(s_true - want).max()
    check("正算：Example 10.1 的 s1..s4 与教材印刷值一致",
          err < 5e-4, f"max|Δs| = {err:.2e}")

    # --- (2) 解析解：按 (9.3-4)(9.3-5) 组 A(s)，SVD 取零空间右奇异向量
    A_blocks = []
    for i in range(4):
        Xi, Yi = s_true[i]
        S = skew(np.array([Xi, Yi, 1.0]))
        A_blocks.append(np.hstack([OBJ_PTS[i, 0] * S, OBJ_PTS[i, 1] * S, S]))
    A = np.vstack(A_blocks)
    rankA = np.linalg.matrix_rank(A, tol=1e-9)
    check("系数矩阵 A 的秩为 8（12 方程 / 9 未知数）", rankA == 8, f"rank = {rankA}")

    _, _, Vt = np.linalg.svd(A)
    h = Vt[-1].reshape(3, 3, order="F")      # 按列摞成 3x3
    h1 = h[:, 0]
    h2 = h[:, 1]
    h3 = h[:, 2]
    zeta_abs = 1.0 / np.linalg.norm(h1)
    check("|ζ| 由单位范数约束给出 1.5", abs(zeta_abs - 1.5) < 2e-3,
          f"|ζ| = {zeta_abs:.5f}")

    # ζ 的符号由「目标在相机前方」定：o_z = (ζ h3)_z > 0
    # （SVD 零向量的整体符号是任意的，不能硬编码）
    zeta = zeta_abs if h3[2] > 0 else -zeta_abs
    r1, r2, o = zeta * h1, zeta * h2, zeta * h3
    r3 = np.cross(r1, r2)
    Q = np.column_stack([r1, r2, r3])
    check("还原的旋转阵与教材给定位姿一致",
          np.abs(Q - R_TRUE).max() < 2e-3, f"max|ΔR| = {np.abs(Q - R_TRUE).max():.2e}")
    check("还原的位置向量与教材给定位姿一致",
          np.abs(o - O_TRUE).max() < 2e-3, f"max|Δo| = {np.abs(o - O_TRUE).max():.2e}")

    # --- (3) 噪声下最近旋转阵 (9.3-10)
    Q_noisy = Q + np.array([[1e-3, 0, 2e-3], [0, -1e-3, 0], [1e-3, 1e-3, 0]])
    U, S, Vt2 = np.linalg.svd(Q_noisy)
    sig = np.linalg.det(U @ Vt2)
    R_hat = U @ np.diag([1.0, 1.0, sig]) @ Vt2
    check("最近旋转阵（(9.3-10)）仍是合法旋转阵",
          abs(np.linalg.det(R_hat) - 1.0) < 1e-9 and
          np.abs(R_hat @ R_hat.T - np.eye(3)).max() < 1e-9,
          f"det = {np.linalg.det(R_hat):.9f}")
    check("最近旋转阵比原 Q 更接近正交阵",
          np.linalg.norm(R_hat - Q_noisy) < np.linalg.norm(Q_noisy - Q_noisy @ Q_noisy.T),
          "")

    print("\n=== 习题 10.4 · 基于图像雅可比求逆的位姿估计（§9.5） ===")
    # 目标：给定特征向量 s，求目标相对相机的位姿 x^c_o = [o^c_o(3); alpha]
    s_meas = np.array([-0.1667, 0.1667, -0.0833, 0.0223])   # 教材习题给定量
    x_true = np.array([-0.1, 0.1, 0.6, -PI / 3.0])          # 由该 s 反推（见下方核对）
    x0 = np.array([0.0, 0.0, 0.5, 0.0])                      # 初值：轴平行、距离 0.5 m

    x_hat, hist = estimate_pose(s_meas, x0, OBJ_PTS[:2], n_steps=400)
    check("位姿估计收敛到教材答案 x^c_o = [-0.1, 0.1, 0.6, -π/3]",
          np.abs(x_hat - x_true).max() < 2e-3,
          f"x = [{x_hat[0]:+.5f}, {x_hat[1]:+.5f}, {x_hat[2]:+.5f}, {x_hat[3]:+.5f}]")

    # 独立核对：给定 x_true 正算，应还原出题给的 s
    XY_chk, _ = project_points(rz(x_true[3]), x_true[:3], OBJ_PTS[:2])
    check("由估计位姿正算的投影与题给特征向量一致",
          np.abs(XY_chk.ravel() - s_meas).max() < 5e-4,
          f"max|Δs| = {np.abs(XY_chk.ravel() - s_meas).max():.2e}")

    return s_meas, x_true


def pose_features(x, pts):
    """由位姿 x = [o(3); alpha] 正算两点特征 s = [X1,Y1,X2,Y2]。"""
    R = rz(x[3])
    Rc = pts @ R.T + x[:3]
    z = Rc[:, 2].copy()
    z[np.abs(z) < 1e-12] = 1e-12
    return np.column_stack([Rc[:, 0] / z, Rc[:, 1] / z]), z


def pose_jacobian(x, pts):
    """d s / d x^c_o（4x4），x = [o(3); alpha]。教材 (10.28) 思路的直接展开。"""
    R = rz(x[3])
    Rc = pts @ R.T + x[:3]
    z = Rc[:, 2].copy()
    z[np.abs(z) < 1e-12] = 1e-12
    XY = np.column_stack([Rc[:, 0] / z, Rc[:, 1] / z])
    J = np.zeros((4, 4))
    for i in range(2):
        Xi, Yi = XY[i]
        J[2 * i, 0] = 1.0 / z[i]
        J[2 * i, 1] = 0.0
        J[2 * i, 2] = -Xi / z[i]
        J[2 * i + 1, 0] = 0.0
        J[2 * i + 1, 1] = 1.0 / z[i]
        J[2 * i + 1, 2] = -Yi / z[i]
        # d/d alpha: xc = cos(a)*a_i - sin(a)*b_i + o_x  =>  dxc/da = -sin(a)*a_i - cos(a)*b_i
        a_i, b_i = pts[i, 0], pts[i, 1]
        dxc = -math.sin(x[3]) * a_i - math.cos(x[3]) * b_i
        dyc = math.cos(x[3]) * a_i - math.sin(x[3]) * b_i
        J[2 * i, 3] = dxc / z[i]
        J[2 * i + 1, 3] = dyc / z[i]
    return J, XY, z


def estimate_pose(s_meas, x0, pts2, n_steps=400, dt=1e-3, Ks=160.0):
    """基于图像雅可比求逆的位姿估计（§9.5 (9.5-5)~(9.5-8)）。"""
    x = x0.copy()
    for _ in range(n_steps):
        XY, _ = pose_features(x, pts2)
        e = s_meas - XY.ravel()
        J, _, _ = pose_jacobian(x, pts2)
        try:
            dx = np.linalg.solve(J, Ks * e)
        except np.linalg.LinAlgError:
            break
        x = x + dt * dx
        if np.linalg.norm(e) < 1e-12:
            break
    return x, None


# ================================================================ Part 2
# SCARA 连杆长度。教材 Fig 2.36 的 SCARA 用 a1 = a2 = 0.5 m（Problem 3.22 / 5.7），
# 但教材 §10.9 给出的相机初始/期望位置到 joint-1 轴的半径是 1.414 m 与 1.551 m，
# 超出 0.5 m 臂长（可达半径 1.0 m）——教材未给 §10.9 的臂长，此处取 a1 = a2 = 1.0 m，
# 使教材给出的相机位姿可达。定性结论（位置式走直线、图像式出现相机后退）与臂长无关。
A1 = A2 = 1.0
Z_CAM = 1.0            # 物体所在平面（基座 z 轴向下）


def scara_pos(q):
    """相机原点相对基座的位置（基座 z 轴向下，d3 为向下伸出量）。"""
    q1, q2, d3, _ = q
    return np.array([A1 * math.cos(q1) + A2 * math.cos(q1 + q2),
                     A1 * math.sin(q1) + A2 * math.sin(q1 + q2),
                     d3])


def scara_heading(q):
    q1, q2, _, q4 = q
    return q1 + q2 + q4


def scara_J_base(q):
    """相机速度（基座系：v_c^b(3); gamma_dot(1)）对 q 的雅可比（4x4）。"""
    q1, q2, _, _ = q
    s1, c1 = math.sin(q1), math.cos(q1)
    s12, c12 = math.sin(q1 + q2), math.cos(q1 + q2)
    Jpos = np.array([[-A1 * s1 - A2 * s12, -A2 * s12, 0.0, 0.0],
                     [A1 * c1 + A2 * c12,  A2 * c12, 0.0, 0.0],
                     [0.0, 0.0, 1.0, 0.0]])
    Jw = np.array([[1.0, 1.0, 0.0, 1.0]])
    return np.vstack([Jpos, Jw])


def scara_J_cam(q):
    """相机速度（相机系：v_c^c(3); omega_zc(1)）对 q 的雅可比（4x4）。"""
    Jb = scara_J_base(q)
    Rc = camera_frame_rotation(q)                 # 基座 -> 相机
    return np.vstack([Rc @ Jb[:3], Jb[3:]])


def camera_frame_rotation(q):
    """基座 → 相机系的旋转 Rz(-gamma)。"""
    return rz(-scara_heading(q))


def object_pose_in_camera(q, o_obj, gamma_obj):
    """目标相对相机的位姿：x = [o^c_o(3); alpha]。"""
    Rc = camera_frame_rotation(q)
    o_co = Rc @ (o_obj - scara_pos(q))
    alpha = gamma_obj - scara_heading(q)
    return np.concatenate([o_co, [alpha]])


def part_10_9():
    """习题 10.9：位置式 · 速度分解视觉伺服（SCARA + 平面目标），与图像式对照。"""
    print("\n=== 习题 10.9 · 位置式速度分解视觉伺服（SCARA，教材 §10.9 工况） ===")

    # --- 工况（教材 §10.9 印刷页 454–455）
    o_cam0 = np.array([1.0, 1.0, 0.5])       # 相机初始位置（基座系）
    gamma_c0 = PI / 4.0                        # 相机初始航向
    o_obj = np.array([1.0, 1.0, 1.0])          # 目标固定在基座系（由 x_{c,o}(0) 反推）
    gamma_obj = gamma_c0                       # 由 alpha(0)=0 反推
    x_d_o = np.array([-0.1, 0.1, 0.6, -PI / 3.0])   # 期望目标相对相机位姿
    T_s = 0.04                                  # 控制周期 25 Hz
    K_pb = np.diag([1.0, 1.0, 1.0, 2.0])       # 位置式速度分解增益
    K_ib = np.eye(4)                            # 图像式速度分解增益

    # 期望位姿：由 x_d_o 反推期望相机位姿（基座系）
    gamma_c_des = gamma_obj - x_d_o[3]
    o_cam_des = o_obj - rz(gamma_c_des) @ x_d_o[:3]
    print(f"  期望相机位置(基座) = [{o_cam_des[0]:+.5f}, {o_cam_des[1]:+.5f}, {o_cam_des[2]:+.5f}]"
          f"   期望航向 = {math.degrees(gamma_c_des):.3f} deg")

    # 目标特征点（目标系）
    pts2 = OBJ_PTS[:2]                        # P1, P2

    # 期望特征：两点特征（教材 §10.9 参考仿真用法）与线段特征（习题 10.9 用）
    XY_des, _ = pose_features(x_d_o, pts2)
    s_pts_des = XY_des.ravel()
    s_seg_des = line_segment_features(XY_des)
    print(f"  期望两点特征 s_d = [{s_pts_des[0]:+.5f}, {s_pts_des[1]:+.5f}, "
          f"{s_pts_des[2]:+.5f}, {s_pts_des[3]:+.5f}]   （教材印刷值 -0.1667 0.1667 -0.0833 0.0223）")
    print(f"  期望线段特征 s_d = [{s_seg_des[0]:+.5f}, {s_seg_des[1]:+.5f}, "
          f"{s_seg_des[2]:+.5f}, {s_seg_des[3]:+.5f}]")

    # 初始关节：使相机在 (o_cam0, gamma_c0)。SCARA 逆运动学（水平面两连杆 + d3 + 工具转角）
    q = scara_inverse(o_cam0, gamma_c0)

    # --- 方案 B：位置式速度分解（位姿估计用线段特征，习题 10.9 的要求）
    trajB = run_pbvs(q.copy(), o_obj, gamma_obj, x_d_o, K_pb, T_s, mode="segment")
    # --- 方案 D：图像式速度分解（两点特征，教材 §10.9 参考仿真用法）
    trajD = run_ibvs(q.copy(), o_obj, gamma_obj, x_d_o, s_pts_des, K_ib, T_s)

    # --- 检查
    errB = trajB["err"][-1]
    check("方案 B：操作空间误差收敛到 0",
          np.abs(errB[:3]).max() < 1e-3 and abs(errB[3]) < 1e-3,
          f"x = [{errB[0]:+.2e}, {errB[1]:+.2e}, {errB[2]:+.2e}, {errB[3]:+.2e}]")
    pB = np.array(trajB["cam"])
    check("方案 B：相机原点走到期望位姿",
          np.abs(pB[-1] - o_cam_des).max() < 2e-3,
          f"max|Δp| = {np.abs(pB[-1] - o_cam_des).max():.2e}")
    check("方案 B：相机航向走到期望航向",
          abs(wrap_pi(trajB["gamma"][-1] - gamma_c_des)) < 2e-3,
          f"Δγ = {math.degrees(wrap_pi(trajB['gamma'][-1] - gamma_c_des)):+.4f} deg")

    # 相机原点路径是否为直线（教材 Fig 10.26 的结论：B 是完美直线）
    seg = pB - pB[0]
    L = np.linalg.norm(seg[-1])
    dev = np.array([np.linalg.norm(np.cross(seg[i], seg[-1])) / L for i in range(len(seg))])
    check("方案 B：相机原点轨迹是一条直线（教材 Fig 10.26 的结论）",
          dev.max() < 5e-3, f"最大偏离直线 {dev.max():.2e} m")

    # --- 方案 D：图像式应出现相机后退
    # 基座 z 轴向下，目标在 z = 1.0 处；相机「后退」= 远离目标 = z 继续变小。
    zB = pB[:, 2]
    zD = np.array(trajD["cam"])[:, 2]
    net = max(abs(zB[-1] - zB[0]), 1e-12)
    over_B = (zB[-1] - zB.min()) / net
    over_D = (zD[-1] - zD.min()) / net
    check("方案 D：出现相机后退（z 分量越过终值继续减小，教材 Fig 10.24）",
          over_D > 0.02, f"相机后退量 = {over_D * 100:.1f} %（教材值约 50 %）")
    check("方案 B：位置式不出现相机后退",
          over_B < 0.02, f"相机后退量 = {over_B * 100:.1f} %")
    print(f"  对照：方案 B 的相机后退量 = {over_B * 100:.1f} %")
    print(f"        方案 D 的相机后退量 = {over_D * 100:.1f} %")
    print(f"        方案 D 的 z 最小值 = {zD.min():.4f} m（终值 {zD[-1]:.4f} m，起始 {zD[0]:.4f} m）")

    errD = trajD["err"][-1]
    check("方案 D：图像特征误差收敛到 0",
          np.abs(errD).max() < 1e-3, f"e_s max = {np.abs(errD).max():.2e}")

    save_figures(trajB, trajD, o_cam_des, gamma_c_des)
    return trajB, trajD


def wrap_pi(a):
    return (a + PI) % (2 * PI) - PI


def scara_inverse(o_cam, gamma_cam):
    """SCARA 逆运动学（水平面两连杆 + d3 + 工具转角），肘部取「上」解。"""
    x, y, z = o_cam
    r = math.hypot(x, y)
    cos_q2 = (r * r - A1 * A1 - A2 * A2) / (2 * A1 * A2)
    q2 = math.acos(max(-1.0, min(1.0, cos_q2)))
    q1 = math.atan2(y, x) - math.atan2(A2 * math.sin(q2), A1 + A2 * math.cos(q2))
    q4 = gamma_cam - (q1 + q2)
    return np.array([q1, q2, z, q4])


def run_pbvs(q, o_obj, gamma_obj, x_d_o, K, T_s, mode="segment", n_ctrl=300):
    """位置式 · 速度分解视觉伺服。

    误差按教材 (10.68)(10.69)：T^d_c = T^d_o (T^c_o)^{-1}，x = [o^d_c(3); phi^d_c]。
    x_pos 的导数按几何推导：d(o^d_c)/dt = R^d_c v_c^c（d 为期望相机系，固定于基座）。
    SCARA 下 T_A = 1（姿态只有一个绕 z_c 的角），故
        x_dot = diag(R^d_c, 1) J_cam(q) q_dot,
    取 q_dot = -J_A_d^{-1} K x（J_A_d = -diag(R^d_c,1) J_cam）即得 x_dot + K x = 0。
    """
    x_est = np.array([0.0, 0.0, 0.5, 0.0])       # 位姿估计初值
    dt_est = 1e-3
    Ks_est = 160.0
    cam, gam, errs, feats = [], [], [], []
    for _ in range(n_ctrl):
        # 视觉测量：由当前相机位姿正算特征（仿真中「测量」= 真值投影）
        x_true = object_pose_in_camera(q, o_obj, gamma_obj)
        XY, z = pose_features(x_true, OBJ_PTS[:2])
        s_seg = line_segment_features(XY)

        # 位姿估计：用线段特征（教材习题 10.9 的要求）
        x_est = estimate_pose_segment(s_seg, x_est, OBJ_PTS[:2], dt_est, Ks_est)

        # 误差：T^d_c = T^d_o (T^c_o)^{-1}
        psi = x_d_o[3] - x_est[3]
        Rd = rz(psi)
        o_dc = x_d_o[:3] - Rd @ x_est[:3]
        x = np.concatenate([o_dc, [psi]])

        # J_A_d = -diag(R^d_c, 1) J_cam(q)
        Jc = scara_J_cam(q)
        J_Ad = -np.vstack([Rd @ Jc[:3], Jc[3:]])
        q_dot = np.linalg.solve(J_Ad, K @ x)
        q = q + T_s * q_dot

        cam.append(scara_pos(q))
        gam.append(scara_heading(q))
        errs.append(x)
        feats.append(s_seg)
    return {"cam": cam, "gamma": gam, "err": errs, "feat": feats, "q": q}


def estimate_pose_segment(s_seg, x0, pts2, dt, Ks, n_steps=30):
    """用线段特征做位姿估计：J_seg = (ds/ds1 L_s1 + ds/ds2 L_s2) 的位姿导数。"""
    x = x0.copy()
    for _ in range(n_steps):
        XY, z = pose_features(x, pts2)
        seg = line_segment_features(XY)
        e = s_seg - seg
        if np.abs(e).max() < 1e-12:
            break
        Jp, _, _ = pose_jacobian(x, pts2)          # d(2 点特征)/d x  (4x4)
        dX = XY[1, 0] - XY[0, 0]
        dY = XY[1, 1] - XY[0, 1]
        L = math.hypot(dX, dY)
        J1, J2 = line_segment_jacobian_features(dX, dY, L)
        # ds_seg/ds_pts  (4x4) : [J1 | J2] @ d(pts 特征)/d x
        Js_pts = np.hstack([J1, J2]) @ Jp
        try:
            dx = np.linalg.solve(Js_pts, Ks * e)
        except np.linalg.LinAlgError:
            break
        x = x + dt * dx
    return x


def run_ibvs(q, o_obj, gamma_obj, x_d_o, s_pts_des, K, T_s, n_ctrl=300):
    """图像式 · 速度分解视觉伺服（教材 (10.87)(10.88)），SCARA 下的 4 维约化形式。

    特征取两点 P1、P2 的归一化坐标 s = [X1,Y1,X2,Y2]（教材 §10.9 的参考仿真用法），
    交互矩阵由两点矩阵堆叠后，按相机可用的 4 个自由度 [vx,vy,vz,omega_z] 约化。
    """
    cam, gam, errs, feats = [], [], [], []
    for _ in range(n_ctrl):
        x_true = object_pose_in_camera(q, o_obj, gamma_obj)
        XY, z = pose_features(x_true, OBJ_PTS[:2])
        s_pts = XY.ravel()
        e = s_pts_des - s_pts

        # 两点的交互矩阵堆叠（4x6），再按可用自由度约化（4x4）
        Ls = np.vstack([point_interaction_matrix(XY[0, 0], XY[0, 1], z[0]),
                        point_interaction_matrix(XY[1, 0], XY[1, 1], z[1])])
        Ls_red = Ls[:, [0, 1, 2, 5]]
        Jc = scara_J_cam(q)
        M = Ls_red @ Jc
        q_dot = np.linalg.solve(M, K @ e)
        q = q + T_s * q_dot

        cam.append(scara_pos(q))
        gam.append(scara_heading(q))
        errs.append(e)
        feats.append(s_pts)
    return {"cam": cam, "gamma": gam, "err": errs, "feat": feats, "q": q}


def save_figures(trajB, trajD, o_cam_des, gamma_c_des):
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
    except Exception as exc:                     # pragma: no cover
        print(f"  (跳过绘图：{exc})")
        return

    # 中文字体：macOS 自带 PingFang SC；找不到就退回英文标签
    from matplotlib import font_manager
    have = {f.name for f in font_manager.fontManager.ttflist}
    cjk = next((n for n in ("PingFang SC", "Heiti SC", "Songti SC", "STHeiti",
                             "Arial Unicode MS", "Hiragino Sans GB", "Noto Sans CJK SC")
                if n in have), None)
    if cjk:
        plt.rcParams["font.sans-serif"] = [cjk]
        plt.rcParams["axes.unicode_minus"] = False
    else:
        print("  (未找到中文字体，图内标签改用英文)")

    tB = np.arange(len(trajB["cam"])) * 0.04
    tD = np.arange(len(trajD["cam"])) * 0.04
    pB = np.array(trajB["cam"])
    pD = np.array(trajD["cam"])

    fig, ax = plt.subplots(1, 3, figsize=(13, 4))
    ax[0].plot(tB, pB[:, 0], label="B 位置式")
    ax[0].plot(tD, pD[:, 0], label="D 图像式")
    ax[0].set_xlabel("t / s"); ax[0].set_ylabel("x / m"); ax[0].legend()
    ax[0].set_title("相机原点 x 分量")
    ax[1].plot(tB, pB[:, 1], label="B 位置式")
    ax[1].plot(tD, pD[:, 1], label="D 图像式")
    ax[1].set_xlabel("t / s"); ax[1].set_ylabel("y / m"); ax[1].legend()
    ax[1].set_title("相机原点 y 分量")
    ax[2].plot(tB, pB[:, 2], label="B 位置式")
    ax[2].plot(tD, pD[:, 2], label="D 图像式")
    ax[2].set_xlabel("t / s"); ax[2].set_ylabel("z / m"); ax[2].legend()
    ax[2].set_title("相机原点 z 分量（图像式出现后退）")
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "fig1_timehistories.png"), dpi=130)
    plt.close(fig)

    fig, ax = plt.subplots(1, 2, figsize=(9, 4.4))
    ax[0].plot(pB[:, 0], pB[:, 1], "-o", ms=3, label="B 位置式速度分解")
    ax[0].plot(pD[:, 0], pD[:, 1], "-s", ms=3, label="D 图像式速度分解")
    ax[0].plot(o_cam_des[0], o_cam_des[1], "*", ms=18, color="k", label="期望")
    ax[0].set_xlabel("x / m"); ax[0].set_ylabel("y / m")
    ax[0].set_title("相机原点水平面路径"); ax[0].legend(); ax[0].grid(alpha=.3)
    ax[1].plot(pB[:, 0], pB[:, 2], "-o", ms=3, label="B 位置式速度分解")
    ax[1].plot(pD[:, 0], pD[:, 2], "-s", ms=3, label="D 图像式速度分解")
    ax[1].plot(o_cam_des[0], o_cam_des[2], "*", ms=18, color="k", label="期望")
    ax[1].set_xlabel("x / m"); ax[1].set_ylabel("z / m")
    ax[1].set_title("相机原点竖直面路径（相机后退）"); ax[1].legend(); ax[1].grid(alpha=.3)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "fig2_camera_paths.png"), dpi=130)
    plt.close(fig)
    print(f"  图已存到 {OUT}/fig1_timehistories.png, fig2_camera_paths.png")


def main():
    print("=" * 74)
    print("作业九验算：教材第 10 章习题 10.4（必做）与 10.9（任选 · 位置式速度分解）")
    print("=" * 74)
    part_10_4()
    part_10_9()
    print("\n" + "=" * 74)
    if FAIL:
        print(f"有 {len(FAIL)} 项未通过：")
        for f in FAIL:
            print("  - " + f)
        raise SystemExit(1)
    print("全部检查通过")


if __name__ == "__main__":
    main()
