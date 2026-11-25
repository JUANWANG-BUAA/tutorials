#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第十章与作业十数值验算：独轮车、差速等效、两轮车秩条件、四步李括号环路与链式变换。"""

from __future__ import annotations

import math
import sys


def det3(m):
    a, b, c = m[0]
    d, e, f = m[1]
    g, h, i = m[2]
    return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)


def det4(m):
    total = 0.0
    for c in range(4):
        sub = [[m[r][j] for j in range(4) if j != c] for r in range(1, 4)]
        sign = 1.0 if c % 2 == 0 else -1.0
        total += sign * m[0][c] * det3(sub)
    return total


def rk4_unicycle(q, v, w, dt, steps):
    x, y, th = q
    for _ in range(steps):
        def rhs(st):
            return (v * math.cos(st[2]), v * math.sin(st[2]), w)
        k1 = rhs((x, y, th))
        k2 = rhs((x + 0.5 * dt * k1[0], y + 0.5 * dt * k1[1], th + 0.5 * dt * k1[2]))
        k3 = rhs((x + 0.5 * dt * k2[0], y + 0.5 * dt * k2[1], th + 0.5 * dt * k2[2]))
        k4 = rhs((x + dt * k3[0], y + dt * k3[1], th + dt * k3[2]))
        x += (dt / 6.0) * (k1[0] + 2 * k2[0] + 2 * k3[0] + k4[0])
        y += (dt / 6.0) * (k1[1] + 2 * k2[1] + 2 * k3[1] + k4[1])
        th += (dt / 6.0) * (k1[2] + 2 * k2[2] + 2 * k3[2] + k4[2])
    return (x, y, th)


def main() -> int:
    print("=== 作业十 · 独轮车、差速等效与两轮车数学性质核验 ===")

    # 1. 独轮车 A^T G = 0 与 det([g1, g2, g3]) = -1
    max_atg = 0.0
    max_det_err = 0.0
    for deg in range(-180, 181, 15):
        th = math.radians(deg)
        c, s = math.cos(th), math.sin(th)
        at = [s, -c, 0.0]
        g1 = [c, s, 0.0]
        g2 = [0.0, 0.0, 1.0]
        g3 = [s, -c, 0.0]
        max_atg = max(max_atg, abs(sum(a * b for a, b in zip(at, g1))),
                      abs(sum(a * b for a, b in zip(at, g2))))
        mat = [[g1[r], g2[r], g3[r]] for r in range(3)]
        max_det_err = max(max_det_err, abs(det3(mat) - 1.0))
    assert max_atg < 1e-12
    assert max_det_err < 1e-12
    print(f"  [PASS] 独轮车零空间正交性 A^T G = 0            max|A^T G| = {max_atg:.2e}")
    print(f"  [PASS] 独轮车对合闭包满秩 det([g1,g2,g3]) = +1   max|det-1| = {max_det_err:.2e}")

    # 2. 差速驱动正逆变换
    r_wheel, d_track = 0.05, 0.30
    max_diff_err = 0.0
    for v_in, w_in in [(0.4, 0.0), (0.0, 1.2), (0.6, -0.8), (-0.3, 0.5)]:
        w_r = (v_in + 0.5 * d_track * w_in) / r_wheel
        w_l = (v_in - 0.5 * d_track * w_in) / r_wheel
        v_rec = 0.5 * r_wheel * (w_r + w_l)
        w_rec = r_wheel * (w_r - w_l) / d_track
        max_diff_err = max(max_diff_err, abs(v_in - v_rec), abs(w_in - w_rec))
    assert max_diff_err < 1e-12
    print(f"  [PASS] 差速驱动正逆映射往返误差 = 0              max|err|   = {max_diff_err:.2e}")

    # 3. 四步小回环 (g1 -> g2 -> -g1 -> -g2)，验证李括号侧向位移 ~ eps^2 * [0, -1, 0]
    eps = 0.1
    q = (0.0, 0.0, 0.0)
    q = rk4_unicycle(q, 1.0, 0.0, eps / 20.0, 20)
    q = rk4_unicycle(q, 0.0, 1.0, eps / 20.0, 20)
    q = rk4_unicycle(q, -1.0, 0.0, eps / 20.0, 20)
    q = rk4_unicycle(q, 0.0, -1.0, eps / 20.0, 20)
    # 理论一阶主部：eps^2 * [g1,g2](0) = [0, -eps^2, 0]
    assert abs(q[0]) < 1e-3 and q[1] < -0.5 * eps * eps and abs(q[2]) < 1e-12
    print("  [PASS] 四步小回环 (g1→g2→-g1→-g2) 产生侧向净位移（验证李括号方向）")

    # 4. 两轮车后驱 4x4 行列式 = 1 / (l^2 cos^4 phi)
    l_wb = 2.5
    max_bi_err = 0.0
    for th_deg in (-60, 0, 35, 110):
        for phi_deg in (-35, -15, 0, 20, 40):
            th = math.radians(th_deg)
            phi = math.radians(phi_deg)
            c, s = math.cos(th), math.sin(th)
            cp = math.cos(phi)
            tp = math.tan(phi)
            g1 = [c, s, tp / l_wb, 0.0]
            g2 = [0.0, 0.0, 0.0, 1.0]
            g3 = [0.0, 0.0, -1.0 / (l_wb * cp * cp), 0.0]
            g4 = [-s / (l_wb * cp * cp), c / (l_wb * cp * cp), 0.0, 0.0]
            mat4 = [[g1[r], g2[r], g3[r], g4[r]] for r in range(4)]
            got = det4(mat4)
            expected = 1.0 / (l_wb * l_wb * cp ** 4)
            max_bi_err = max(max_bi_err, abs(got - expected))
    assert max_bi_err < 1e-12
    print(f"  [PASS] 两轮车后驱 det([g1,g2,g3,g4]) = 1/(l^2 cos^4 φ)   max|err| = {max_bi_err:.2e}")

    # 5. 链式变换数值微分自洽性（独轮车 + 两轮车）
    max_chain_err = 0.0
    # 独轮车
    x, y, th = 1.2, -0.7, 0.45
    v1, v2 = 0.8, -0.35
    z3 = x * math.sin(th) - y * math.cos(th)
    v, w = v2 + z3 * v1, v1
    xd, yd, thd = v * math.cos(th), v * math.sin(th), w
    z1d = thd
    z2d = xd * math.cos(th) + yd * math.sin(th) + (-x * math.sin(th) + y * math.cos(th)) * thd
    z3d = xd * math.sin(th) - yd * math.cos(th) + (x * math.cos(th) + y * math.sin(th)) * thd
    z2 = x * math.cos(th) + y * math.sin(th)
    max_chain_err = max(max_chain_err, abs(z1d - v1), abs(z2d - v2), abs(z3d - z2 * v1))

    # 两轮车（采用正文 10.6-4 核对修正后的式子）
    th, phi = 0.35, 0.4
    v1, v2 = 1.1, 0.25
    v = v1 / math.cos(th)
    phid = (-3.0 / l_wb) * v1 * (1.0 / math.cos(th)) * math.tan(th) * (math.sin(phi) ** 2) + \
           l_wb * v2 * (math.cos(th) ** 3) * (math.cos(phi) ** 2)
    xd, yd, thd = v * math.cos(th), v * math.sin(th), (v / l_wb) * math.tan(phi)
    z2 = (1.0 / l_wb) * (1.0 / math.cos(th) ** 3) * math.tan(phi)
    z3 = math.tan(th)
    z1d = xd
    z2d = (3.0 / l_wb) * (1.0 / math.cos(th) ** 3) * math.tan(th) * math.tan(phi) * thd + \
          (1.0 / l_wb) * (1.0 / math.cos(th) ** 3) * (1.0 / math.cos(phi) ** 2) * phid
    z3d = (1.0 / math.cos(th) ** 2) * thd
    z4d = yd
    max_chain_err = max(max_chain_err, abs(z1d - v1), abs(z2d - v2), abs(z3d - z2 * v1), abs(z4d - z3 * v1))
    assert max_chain_err < 1e-12
    print(f"  [PASS] 独轮车链式变换与两轮车链式变换求导逐项自洽       max|err| = {max_chain_err:.2e}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
