#!/usr/bin/env python3
"""生成四本书的 3D 书封（SVG）。

封面是「图鉴」视觉系统的品牌资产：同一套框架（出版行 / 印鉴 / 卷号 / 细网格），
四种学科各自不同的中央插图与色温。输出到各书 src/assets/covers/，既用于书首页的
CSS 3D 书封，也供教程库首页的 3D 书墙直接引用。

所有图形都是纯 SVG，没有位图、没有外链字体；文字用系统字体栈，离线可读。
"""
from __future__ import annotations

import math
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FONT = "'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif"
MONO = "'SFMono-Regular','Roboto Mono',Consolas,monospace"


def esc(text: str) -> str:
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def txt(x, y, s, size=16, fill="#fff", weight=400, anchor="start", family=FONT, opacity=1, spacing=None, style=""):
    extra = f' letter-spacing="{spacing}"' if spacing else ""
    return (
        f'<text x="{x}" y="{y}" fill="{fill}" font-size="{size}" font-weight="{weight}" '
        f'font-family="{family}" text-anchor="{anchor}" opacity="{opacity}"{extra} style="{style}">{esc(s)}</text>'
    )


def frame(uid: str, top: str, bottom: str, grid: str, accent: str, gold: str):
    """公共封面骨架的 defs 与背景。"""
    return f'''<defs>
  <linearGradient id="{uid}-bg" x1="0" y1="0" x2="0.8" y2="1">
    <stop offset="0" stop-color="{top}"/><stop offset="1" stop-color="{bottom}"/>
  </linearGradient>
  <linearGradient id="{uid}-accent" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="{accent}"/><stop offset="1" stop-color="{gold}"/>
  </linearGradient>
  <radialGradient id="{uid}-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" stop-color="{accent}" stop-opacity=".55"/><stop offset="1" stop-color="{accent}" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="{uid}-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" stop-color="{gold}" stop-opacity=".4"/><stop offset="1" stop-color="{gold}" stop-opacity="0"/>
  </radialGradient>
  <pattern id="{uid}-grid" width="28" height="28" patternUnits="userSpaceOnUse">
    <path d="M28 0H0V28" fill="none" stroke="{grid}" stroke-width="1"/>
  </pattern>
  <pattern id="{uid}-dots" width="22" height="22" patternUnits="userSpaceOnUse">
    <circle cx="1.6" cy="1.6" r="1.1" fill="{grid}"/>
  </pattern>
  <filter id="{uid}-blur" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="12"/></filter>
  <filter id="{uid}-glowf" x="-80%" y="-80%" width="260%" height="260%">
    <feGaussianBlur stdDeviation="3.2" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge>
  </filter>
  <linearGradient id="{uid}-sheen" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" stop-color="#fff" stop-opacity=".17"/><stop offset=".42" stop-color="#fff" stop-opacity=".02"/>
    <stop offset="1" stop-color="#fff" stop-opacity="0"/>
  </linearGradient>
  <linearGradient id="{uid}-fade" x1="0" y1="0" x2="0" y2="1">
    <stop offset="0" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".34"/>
  </linearGradient>
</defs>
<rect width="600" height="800" fill="url(#{uid}-bg)"/>
<rect width="600" height="800" fill="url(#{uid}-dots)" opacity=".55"/>
<circle cx="470" cy="190" r="260" fill="url(#{uid}-glow)" opacity=".7"/>
<circle cx="120" cy="660" r="240" fill="url(#{uid}-glow2)" opacity=".5"/>
<rect width="600" height="800" fill="url(#{uid}-sheen)"/>
<rect x="25" y="25" width="550" height="750" rx="9" fill="none" stroke="#fff" stroke-opacity=".16"/>
<path d="M25 78h550" stroke="#fff" stroke-opacity=".1"/>
<path d="M25 720h550" stroke="#fff" stroke-opacity=".1"/>
<rect x="0" y="0" width="18" height="800" fill="#000" opacity=".26"/>
<rect x="18" y="0" width="2" height="800" fill="#fff" opacity=".1"/>
'''


def cover_robot() -> str:
    uid = "rb"
    top, bottom = "#06101f", "#0b2f5c"
    accent, gold = "#63e6d6", "#f3c26b"
    grid = "#7fa7d9"
    body = frame(uid, top, bottom, grid, accent, gold)
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#b9d3f2", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 01 / ROBOTICS", 10.5, "#b9d3f2", 700, "end", spacing="1.6")
    body += '<rect x="52" y="104" width="496" height="382" rx="20" fill="#ffffff" fill-opacity=".035" stroke="#ffffff" stroke-opacity=".1"/>'
    body += f'<rect x="52" y="104" width="496" height="382" rx="20" fill="url(#{uid}-grid)" opacity=".35"/>'
    # 工作台 / 等距平台
    body += '<ellipse cx="302" cy="430" rx="178" ry="46" fill="#0a1b33" opacity=".7"/>'
    body += '<ellipse cx="302" cy="430" rx="178" ry="46" fill="none" stroke="#7fa7d9" stroke-opacity=".28"/>'
    body += '<ellipse cx="302" cy="430" rx="128" ry="31" fill="none" stroke="#63e6d6" stroke-opacity=".18" stroke-dasharray="3 7"/>'
    for i in range(-4, 5):
        x = 302 + i * 34
        body += f'<path d="M{x} 430 L{302 + i * 62} {398 if abs(i) < 4 else 400}" stroke="#7fa7d9" stroke-opacity=".13"/>'
    # 光束
    body += '<path d="M348 118 L312 430 L390 430 L376 118Z" fill="#63e6d6" opacity=".035"/>'
    # 机械臂：底座 → 大臂 → 小臂 → 腕 → 末端
    arm = [
        ("M302 428 L294 346", 23, "#0c2140"),
        ("M294 346 L320 262", 18, "#0c2140"),
        ("M320 262 L400 214", 14, "#0c2140"),
        ("M400 214 L454 190", 10, "#0c2140"),
    ]
    for d, w, color in arm:
        body += f'<path d="{d}" stroke="{color}" stroke-width="{w+8}" stroke-linecap="round" fill="none"/>'
    for d, w, color in arm:
        body += f'<path d="{d}" stroke="#d9f7ff" stroke-width="{w}" stroke-linecap="round" fill="none"/>'
        body += f'<path d="{d}" stroke="{accent}" stroke-width="{max(2, w*0.32)}" stroke-linecap="round" fill="none" opacity=".9"/>'
    joints = [(302, 428, 18), (294, 346, 15), (320, 262, 13), (400, 214, 10), (454, 190, 8)]
    for cx, cy, r in joints:
        body += f'<circle cx="{cx}" cy="{cy}" r="{r+4}" fill="#06101f"/>'
        body += f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="#0e2b4f" stroke="{accent}" stroke-width="2.4"/>'
        body += f'<circle cx="{cx}" cy="{cy}" r="{max(2, r*0.3)}" fill="{gold}" opacity=".95"/>'
    # 末端坐标架
    ex, ey = 454, 190
    body += f'<g stroke-linecap="round"><path d="M{ex} {ey} L{ex+52} {ey-14}" stroke="#f3c26b" stroke-width="2.4" marker-end="url(#{uid}-arrow)"/><path d="M{ex} {ey} L{ex+18} {ey-54}" stroke="#63e6d6" stroke-width="2.4"/><path d="M{ex} {ey} L{ex+42} {ey+22}" stroke="#ff7c9c" stroke-width="2.4"/></g>'
    body += txt(ex + 56, ey - 16, "x", 10, gold, 700, family=MONO)
    body += txt(ex + 22, ey - 58, "z", 10, accent, 700, family=MONO)
    body += txt(ex + 46, ey + 30, "y", 10, "#ff9db4", 700, family=MONO)
    # 关节编号
    for i, (cx, cy) in enumerate([(294, 346), (320, 262), (400, 214)], start=2):
        body += f'<circle cx="{cx-26}" cy="{cy-20}" r="8.5" fill="#06101f" stroke="#7fa7d9" stroke-opacity=".45"/>'
        body += txt(cx - 26, cy - 16.5, f"J{i}", 7.5, "#a9c6ea", 700, "middle", MONO)
    # 弧线 / 轨迹
    body += f'<path d="M250 330 C 320 190, 430 150, 520 178" fill="none" stroke="{accent}" stroke-opacity=".5" stroke-width="1.6" stroke-dasharray="4 7"/>'
    body += f'<circle cx="520" cy="178" r="4" fill="{accent}"/><circle cx="520" cy="178" r="10" fill="none" stroke="{accent}" stroke-opacity=".3"/>'
    body += txt(480, 154, "TCP", 8.5, "#9eddd8", 700, MONO)
    # 标题
    body += txt(52, 578, "机器人控制技术", 51, "#f2f7ff", 700, spacing="1")
    body += txt(54, 610, "ROBOTICS · MODELING, PLANNING & CONTROL", 12.5, "#9fc4ee", 700, spacing="1.3")
    body += f'<path d="M54 640h172" stroke="url(#{uid}-accent)" stroke-width="3"/>'
    body += txt(54, 674, "位姿与运动学 · 微分运动学与静力学", 12.5, "#c8dcf4")
    body += txt(54, 698, "轨迹规划 · 执行器与传感器", 12.5, "#c8dcf4")
    body += txt(548, 674, "5 CHAPTERS", 10.5, gold, 700, "end", MONO, spacing="1.2")
    body += txt(548, 698, "48 SECTIONS", 10.5, "#9fc4ee", 700, "end", MONO, spacing="1.2")
    body += txt(52, 750, "北京航空航天大学 · 研究生课程定制教程", 10, "#8fb1d8", spacing=".6")
    body += f'<g transform="translate(512 738)"><circle r="19" fill="none" stroke="{gold}" stroke-opacity=".7"/><path d="M-9 1h18M0 -8v18" stroke="{gold}" stroke-width="1.2"/><circle r="4" fill="none" stroke="{gold}"/></g>'
    body += '<marker id="rb-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto"><path d="M0 0 10 5 0 10Z" fill="#f3c26b"/></marker>'
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 800" role="img" aria-label="机器人控制技术书封：机械臂、坐标架与轨迹">\n{body}\n</svg>\n'


def cover_matrix() -> str:
    uid = "mx"
    top, bottom = "#150b2e", "#371a63"
    accent, gold = "#b79cff", "#f3c26b"
    grid = "#b49be3"
    body = frame(uid, top, bottom, grid, accent, gold)
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#d8c7ff", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 02 / LINEAR ALGEBRA", 10.5, "#d8c7ff", 700, "end", spacing="1.2")
    body += '<rect x="52" y="104" width="496" height="382" rx="20" fill="#ffffff" fill-opacity=".03" stroke="#ffffff" stroke-opacity=".1"/>'
    body += f'<rect x="52" y="104" width="496" height="382" rx="20" fill="url(#{uid}-grid)" opacity=".3"/>'
    # 等距平面
    ox, oy = 280, 342
    ux, uy = 178, -52
    vx, vy = 98, 112
    body += f'<path d="M{ox} {oy} l{ux} {uy} l{vx} {vy} l{-ux} {-uy}Z" fill="#b79cff" fill-opacity=".06" stroke="#b79cff" stroke-opacity=".32"/>'
    for i in range(0, 7):
        t = i / 6
        body += f'<path d="M{ox+ux*t:.1f} {oy+uy*t:.1f} L{ox+ux*t+vx:.1f} {oy+uy*t+vy:.1f}" stroke="#b79cff" stroke-opacity=".14"/>'
        body += f'<path d="M{ox+vx*t:.1f} {oy+vy*t:.1f} L{ox+vx*t+ux:.1f} {oy+vy*t+uy:.1f}" stroke="#b79cff" stroke-opacity=".14"/>'
    # 单位圆 → 椭圆（线性映射）
    body += f'<ellipse cx="{ox+54}" cy="{oy+38}" rx="112" ry="44" fill="none" stroke="{gold}" stroke-opacity=".5" stroke-dasharray="4 6" transform="rotate(-12 {ox+54} {oy+38})"/>'
    body += f'<ellipse cx="{ox+54}" cy="{oy+38}" rx="70" ry="27" fill="#f3c26b" fill-opacity=".06" stroke="{gold}" stroke-opacity=".75" transform="rotate(-12 {ox+54} {oy+38})"/>'
    # 基向量
    body += f'<path d="M{ox} {oy} L{ox+150} {oy-42}" stroke="{gold}" stroke-width="3" stroke-linecap="round"/>'
    body += f'<path d="M{ox} {oy} L{ox+78} {oy+92}" stroke="{accent}" stroke-width="3" stroke-linecap="round"/>'
    body += f'<circle cx="{ox}" cy="{oy}" r="7" fill="{gold}"/>'
    body += f'<circle cx="{ox}" cy="{oy}" r="16" fill="none" stroke="{gold}" stroke-opacity=".3"/>'
    body += txt(ox + 136, oy - 40, "A e₁", 10.5, gold, 700, MONO)
    body += txt(ox + 70, oy + 92, "A e₂", 10.5, accent, 700, MONO)
    # 矩阵框
    bx, by = 424, 176
    body += f'<g transform="translate({bx} {by})">'
    body += f'<path d="M0 0v94M9 0h-9M9 94h-9" stroke="{accent}" stroke-width="2" fill="none" opacity=".9"/>'
    body += f'<path d="M92 0v94M83 0h9M83 94h9" stroke="{accent}" stroke-width="2" fill="none" opacity=".9"/>'
    vals = [["1", "2", "0"], ["0", "1", "3"], ["2", "0", "1"]]
    for r in range(3):
        for c in range(3):
            x = 22 + c * 24
            y = 26 + r * 24
            body += f'<circle cx="{x}" cy="{y}" r="2" fill="{gold}" opacity=".9"/>'
            body += txt(x + 8, y + 4, vals[r][c], 10, "#e8ddff", 600, MONO, opacity=.9)
    body += '</g>'
    body += txt(424, 296, "A ∈ R³ˣ³", 11, "#e8ddff", 700, MONO)
    # 特征值 / 谱点
    for i, (dx, dy, label) in enumerate([(-34, 186, "λ₁"), (10, 162, "λ₂"), (48, 204, "λ₃")]):
        cx, cy = 306 + dx, 252 + dy
        body += f'<circle cx="{cx}" cy="{cy}" r="4" fill="{gold}"/><circle cx="{cx}" cy="{cy}" r="11" fill="none" stroke="{gold}" stroke-opacity=".25"/>'
        body += txt(cx + 10, cy + 3, label, 8.5, "#f7db9e", 700, MONO)
    body += f'<path d="M162 424 C 252 350, 354 340, 438 390" fill="none" stroke="{accent}" stroke-opacity=".4" stroke-width="1.5" stroke-dasharray="3 7"/>'
    body += '<text x="302" y="438" text-anchor="middle" fill="#d9c9ff" font-size="13" font-family="' + MONO + '" opacity=".82">A = P⁻¹ Γ Q</text>'
    # 标题
    body += txt(52, 584, "矩阵论", 58, "#f7f1ff", 700, spacing="6")
    body += txt(54, 616, "LINEAR SPACE · LINEAR MAPS · FACTORIZATION", 12, "#cbb6f7", 700, spacing="1.1")
    body += f'<path d="M54 644h172" stroke="url(#{uid}-accent)" stroke-width="3"/>'
    body += txt(54, 678, "空间与坐标 · 线性映射", 12.5, "#ded0ff")
    body += txt(54, 702, "相抵 · 满秩 · QR · Schur 分解", 12.5, "#ded0ff")
    body += txt(548, 678, "3 CHAPTERS", 10.5, gold, 700, "end", MONO, spacing="1.2")
    body += txt(548, 702, "PROOF-DRIVEN", 10.5, "#cbb6f7", 700, "end", MONO, spacing="1.2")
    body += txt(52, 750, "北京航空航天大学 · 研究生课程定制教程", 10, "#b79cdf", spacing=".6")
    body += f'<g transform="translate(512 738)"><circle r="19" fill="none" stroke="{gold}" stroke-opacity=".7"/><path d="M-9 1h18M0 -8v18" stroke="{gold}" stroke-width="1.2"/><circle r="4" fill="none" stroke="{gold}"/></g>'
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 800" role="img" aria-label="矩阵论书封：线性映射的网格与特征向量">\n{body}\n</svg>\n'


def cover_numerical() -> str:
    uid = "na"
    top, bottom = "#03201d", "#06463f"
    accent, gold = "#5fe3cb", "#f3c26b"
    grid = "#78c9bd"
    body = frame(uid, top, bottom, grid, accent, gold)
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#b8f2e9", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 03 / NUMERICAL METHODS", 10.5, "#b8f2e9", 700, "end", spacing="1.1")
    body += '<rect x="52" y="104" width="496" height="382" rx="20" fill="#ffffff" fill-opacity=".03" stroke="#ffffff" stroke-opacity=".1"/>'
    body += f'<rect x="52" y="104" width="496" height="382" rx="20" fill="url(#{uid}-grid)" opacity=".25"/>'
    # 3D 曲面（等距投影）：z = sin(x)cos(y) + 0.25cos(1.7x)
    ox, oy = 300, 332
    sx, sy = 42.0, 30.0
    sy2 = 10.5
    zs = 48.0
    n = 15
    pts = {}
    for i in range(n):
        for j in range(n):
            x = (i / (n - 1) - 0.5) * 2.35
            y = (j / (n - 1) - 0.5) * 2.35
            z = math.sin(x * 1.25) * math.cos(y * 1.15) + 0.35 * math.cos(x * 2.2 + 0.4)
            px = ox + x * sx * 2.4 + y * sy * 2.4
            py = oy + y * sy2 * 2.4 - z * zs
            pts[(i, j)] = (px, py)
    # 网格线：按高度渐变色
    for j in range(n):
        d = "M" + " L".join(f"{pts[(i,j)][0]:.1f} {pts[(i,j)][1]:.1f}" for i in range(n))
        body += f'<path d="{d}" fill="none" stroke="{accent}" stroke-opacity=".38" stroke-width="1.15"/>'
    for i in range(n):
        d = "M" + " L".join(f"{pts[(i,j)][0]:.1f} {pts[(i,j)][1]:.1f}" for j in range(n))
        body += f'<path d="{d}" fill="none" stroke="{accent}" stroke-opacity=".27" stroke-width="1.05"/>'
    # 曲面上的金色曲线
    curve = []
    for k in range(40):
        x = -1.1 + (2.2 * k / 39)
        y = 0.28 * math.sin(x * 2.7)
        z = math.sin(x * 1.25) * math.cos(y * 1.15) + 0.35 * math.cos(x * 2.2 + 0.4)
        px = ox + x * sx * 2.4 + y * sy * 2.4
        py = oy + y * sy2 * 2.4 - z * zs
        curve.append(f"{px:.1f} {py:.1f}")
    body += f'<path d="M{" L".join(curve)}" fill="none" stroke="{gold}" stroke-width="2.6" stroke-linecap="round" filter="url(#{uid}-glowf)"/>'
    # 采样点
    for k in range(0, 40, 5):
        x = -1.1 + (2.2 * k / 39)
        y = 0.28 * math.sin(x * 2.7)
        z = math.sin(x * 1.25) * math.cos(y * 1.15) + 0.35 * math.cos(x * 2.2 + 0.4)
        px = ox + x * sx * 2.4 + y * sy * 2.4
        py = oy + y * sy2 * 2.4 - z * zs
        body += f'<circle cx="{px:.1f}" cy="{py:.1f}" r="3.6" fill="#03201d" stroke="{gold}" stroke-width="1.6"/>'
    # 坐标轴
    body += f'<path d="M{ox-138} {oy+92} h276" stroke="{grid}" stroke-opacity=".4" stroke-dasharray="3 6"/>'
    body += f'<path d="M{ox-110} {oy+92} l-24 -12 M{ox+138} {oy+92} l24 12" stroke="{grid}" stroke-opacity=".35"/>'
    body += txt(ox + 150, oy + 110, "x", 10, "#a9e8dd", 700, MONO)
    body += txt(ox + 48, oy + 74, "y", 10, "#a9e8dd", 700, MONO)
    body += txt(ox + 106, oy - 96, "f(x, y)", 10, "#f7d99b", 700, MONO)
    # 误差 / 条件数注释
    body += f'<g transform="translate(382 138)"><rect width="134" height="52" rx="9" fill="#021714" fill-opacity=".55" stroke="{accent}" stroke-opacity=".25"/><text x="12" y="20" fill="#a9e8dd" font-size="8.5" font-family="{MONO}" letter-spacing="1">CONDITION</text><text x="12" y="40" fill="{gold}" font-size="16" font-weight="700" font-family="{MONO}">κ(A) = 42.7</text></g>'
    body += f'<path d="M92 178 C 150 254, 200 300, 286 364" fill="none" stroke="{accent}" stroke-opacity=".3" stroke-dasharray="3 7"/>'
    body += f'<circle cx="92" cy="178" r="3.5" fill="{accent}"/><circle cx="286" cy="364" r="3.5" fill="{accent}"/>'
    # 标题
    body += txt(52, 584, "数值分析", 56, "#eefffb", 700, spacing="4")
    body += txt(54, 616, "ERRORS · LINEAR SYSTEMS · EIGENVALUES · INTERPOLATION", 12, "#a9e8dd", 700, spacing="1.1")
    body += f'<path d="M54 644h172" stroke="url(#{uid}-accent)" stroke-width="3"/>'
    body += txt(54, 678, "误差与算法 · 线性方程组 · 特征值", 12.5, "#c9f4ec")
    body += txt(54, 702, "非线性方程 · 插值 · 数值积分 · ODE", 12.5, "#c9f4ec")
    body += txt(548, 678, "7 CHAPTERS + SUPPLEMENT", 10.5, gold, 700, "end", MONO, spacing="1.2")
    body += txt(548, 702, "PYTHON VERIFIED", 10.5, "#a9e8dd", 700, "end", MONO, spacing="1.2")
    body += txt(52, 750, "北京航空航天大学 · 研究生课程定制教程", 10, "#8bc9bf", spacing=".6")
    body += f'<g transform="translate(512 738)"><circle r="19" fill="none" stroke="{gold}" stroke-opacity=".7"/><path d="M-9 1h18M0 -8v18" stroke="{gold}" stroke-width="1.2"/><circle r="4" fill="none" stroke="{gold}"/></g>'
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 800" role="img" aria-label="数值分析书封：三维曲面与数值网格">\n{body}\n</svg>\n'


def cover_dl() -> str:
    uid = "dl"
    top, bottom = "#1a0d22", "#3c1830"
    accent, gold = "#ffb36b", "#ff7fa8"
    grid = "#d6a7c8"
    body = frame(uid, top, bottom, grid, accent, gold)
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#ffdfc4", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 04 / DEEP LEARNING", 10.5, "#ffdfc4", 700, "end", spacing="1.2")
    body += '<rect x="52" y="104" width="496" height="382" rx="20" fill="#ffffff" fill-opacity=".03" stroke="#ffffff" stroke-opacity=".1"/>'
    body += f'<rect x="52" y="104" width="496" height="382" rx="20" fill="url(#{uid}-grid)" opacity=".2"/>'
    # 3D 神经网络（四层，透视）
    layers = [
        (126, 404, 212, 6, "#ffb36b"),
        (250, 378, 252, 6, "#ff7fa8"),
        (376, 400, 218, 5, "#8fe0ff"),
        (492, 420, 168, 3, "#ffd28a"),
    ]
    nodes = {}
    for li, (x, y, h, count, color) in enumerate(layers):
        for k in range(count):
            yy = y + (k - (count - 1) / 2) * (h / max(count - 1, 1))
            xx = x + (k - (count - 1) / 2) * 8
            nodes[(li, k)] = (xx, yy, color)
    # 层间连线
    for li in range(len(layers) - 1):
        for ka in range(layers[li][3]):
            for kb in range(layers[li + 1][3]):
                x1, y1, c1 = nodes[(li, ka)]
                x2, y2, c2 = nodes[(li + 1, kb)]
                body += f'<path d="M{x1:.1f} {y1:.1f} L{x2:.1f} {y2:.1f}" stroke="{c1}" stroke-opacity=".17" stroke-width="1.1"/>'
    # 节点
    for (li, k), (x, y, color) in nodes.items():
        r = 7.2 if li in (1, 2) else 5.8
        body += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r*2.6}" fill="{color}" opacity=".06"/>'
        body += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r}" fill="#2a1226" stroke="{color}" stroke-width="1.8"/>'
        body += f'<circle cx="{x:.1f}" cy="{y:.1f}" r="1.8" fill="{color}"/>'
    # 层标签
    for li, (x, y, h, count, color) in enumerate(layers):
        body += txt(x, y + h / 2 + 30, ["INPUT", "HIDDEN 1", "HIDDEN 2", "OUTPUT"][li], 8, "#e6c3d8", 700, "middle", MONO, spacing=".8")
    # 张量块 / 3D 框
    body += f'<g transform="translate(402 326) scale(1.16)" opacity=".85"><path d="M0 0 52 -22 104 0 52 22Z" fill="none" stroke="{accent}" stroke-opacity=".5"/><path d="M0 0v40l52 22 52-22V0" fill="{accent}" fill-opacity=".04" stroke="{accent}" stroke-opacity=".5"/><path d="M52 22v40" stroke="{accent}" stroke-opacity=".5"/></g>'
    body += txt(392, 424, "tensor", 8.5, "#ffce9d", 600, MONO)
    # 损失曲线 / 梯度
    body += f'<path d="M96 438 C 160 436, 188 402, 232 414 S 304 468, 354 428 S 424 386, 470 404" fill="none" stroke="{accent}" stroke-opacity=".35" stroke-width="1.5" stroke-dasharray="3 6"/>'
    body += f'<circle cx="354" cy="428" r="3.4" fill="{gold}"/><path d="M354 428 l30 12" stroke="{gold}" stroke-width="1.5" marker-end="url(#{uid}-arrow)"/>'
    body += txt(378, 454, "∇L", 10, "#ffdfc4", 700, MONO)
    body += f'<marker id="dl-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0 0 10 5 0 10Z" fill="{gold}"/></marker>'
    # 标题
    body += txt(52, 584, "深度学习导论", 53, "#fff5ee", 700, spacing=".5")
    body += txt(54, 616, "FROM NEURONS TO WORLD MODELS", 12, "#ffc9a4", 700, spacing="1.3")
    body += f'<path d="M54 644h172" stroke="url(#{uid}-accent)" stroke-width="3"/>'
    body += txt(54, 678, "表示 · 损失 · 优化 · 泛化", 12.5, "#f4d8cd")
    body += txt(54, 702, "序列 · 视觉 · 生成 · 决策", 12.5, "#f4d8cd")
    body += txt(548, 678, "9 LECTURES", 10.5, "#ffd28a", 700, "end", MONO, spacing="1.2")
    body += txt(548, 702, "3 LABS", 10.5, "#ffc9a4", 700, "end", MONO, spacing="1.2")
    body += txt(52, 750, "北京航空航天大学 · 研究生课程定制教程", 10, "#c99ab2", spacing=".6")
    body += f'<g transform="translate(512 738)"><circle r="19" fill="none" stroke="{gold}" stroke-opacity=".7"/><path d="M-9 1h18M0 -8v18" stroke="{gold}" stroke-width="1.2"/><circle r="4" fill="none" stroke="{gold}"/></g>'
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 800" role="img" aria-label="深度学习导论书封：三维神经网络与损失曲面">\n{body}\n</svg>\n'




def cover_distributed() -> str:
    uid = "ds"
    top, bottom = "#07111f", "#12233f"
    accent, gold = "#6ee7f0", "#f3c26b"
    grid = "#8fb3d9"
    body = frame(uid, top, bottom, grid, accent, gold)
    body += txt(52, 66, "BUAA · TEACHING ATLAS", 10.5, "#c3dcf7", 700, spacing="2.2")
    body += txt(548, 66, "VOL. 07 / DISTRIBUTED SYSTEMS", 10.5, "#c3dcf7", 700, "end", spacing=".9")
    body += '<rect x="52" y="104" width="496" height="382" rx="20" fill="#ffffff" fill-opacity=".03" stroke="#ffffff" stroke-opacity=".1"/>'
    body += f'<rect x="52" y="104" width="496" height="382" rx="20" fill="url(#{uid}-grid)" opacity=".22"/>'
    # Client
    body += f'<rect x="86" y="182" width="112" height="58" rx="10" fill="#0a1a2c" stroke="{gold}" stroke-opacity=".75"/>'
    body += txt(142, 207, "CLIENT", 12, gold, 700, "middle", MONO, spacing="1.4")
    body += txt(142, 226, "timeout · retry · idem", 6.8, "#cfe3f7", 400, "middle", MONO)
    # Three replicas
    reps = [(326, 168), (438, 258), (326, 348)]
    for i, (x, y) in enumerate(reps):
        body += f'<circle cx="{x}" cy="{y}" r="32" fill="#0a1a2c" stroke="{accent}" stroke-width="1.8"/>'
        body += f'<circle cx="{x}" cy="{y}" r="22" fill="{accent}" fill-opacity=".08"/>'
        body += txt(x, y + 4, f"R{i+1}", 14, "#e9fbff", 700, "middle", MONO)
    # links
    for a, b in [(0, 1), (1, 2), (2, 0)]:
        x1, y1 = reps[a]; x2, y2 = reps[b]
        body += f'<path d="M{x1} {y1} L{x2} {y2}" stroke="{accent}" stroke-opacity=".45" stroke-width="1.5" stroke-dasharray="4 5"/>'
    # client to replicas
    body += f'<path d="M198 211 C 244 211, 266 180, 294 174" fill="none" stroke="{gold}" stroke-width="1.8" marker-end="url(#{uid}-arrow)"/>'
    body += f'<path d="M198 226 C 252 258, 272 262, 294 258" fill="none" stroke="{gold}" stroke-opacity=".55" stroke-width="1.4" stroke-dasharray="4 5"/>'
    body += f'<path d="M198 240 C 244 290, 272 330, 294 344" fill="none" stroke="{gold}" stroke-opacity=".35" stroke-width="1.2" stroke-dasharray="3 6"/>'
    # log entries
    body += f'<rect x="250" y="126" width="210" height="34" rx="7" fill="#06101d" stroke="{accent}" stroke-opacity=".35"/>'
    for j, label in enumerate(["term", "index", "commit"]):
        xx = 264 + j * 66
        body += f'<rect x="{xx}" y="134" width="54" height="18" rx="4" fill="{accent}" fill-opacity="{0.06 + j*0.04}" stroke="{accent}" stroke-opacity=".25"/>'
        body += txt(xx + 27, 147, label, 7.2, "#dffaff", 600, "middle", MONO)
    # split-brain / quorum annotation
    body += f'<g transform="translate(388 300)"><rect width="142" height="58" rx="9" fill="#06101d" fill-opacity=".7" stroke="{gold}" stroke-opacity=".45"/><text x="12" y="19" fill="#cfe3f7" font-size="8" font-family="{MONO}" letter-spacing="1">QUORUM</text><text x="12" y="42" fill="{gold}" font-size="15" font-weight="700" font-family="{MONO}">2 / 3</text></g>'
    # title
    body += txt(52, 572, "分布式系统与数据面", 42, "#f2fbff", 700, spacing="1.6")
    body += txt(54, 608, "FROM ONE RPC TO VERIFIABLE CONSISTENCY", 10.5, "#bfe6f5", 700, spacing="1.1")
    body += f'<path d="M54 636h172" stroke="url(#{uid}-accent)" stroke-width="3"/>'
    body += txt(54, 670, "请求与失败 · 复制与共识 · 事务与消息", 12, "#d8eef8")
    body += txt(54, 694, "缓存与观测 · 容量与演练 · 两个项目", 12, "#d8eef8")
    body += txt(548, 670, "5 PARTS · 13 CHAPTERS", 10, gold, 700, "end", MONO, spacing="1.1")
    body += txt(548, 694, "2 PROJECTS", 10, "#bfe6f5", 700, "end", MONO, spacing="1.2")
    body += txt(52, 744, "北京航空航天大学 · 研究生课程定制教程", 10, "#8fb3d9", spacing=".6")
    body += f'<g transform="translate(512 732)"><circle r="19" fill="none" stroke="{gold}" stroke-opacity=".7"/><path d="M-9 1h18M0 -8v18" stroke="{gold}" stroke-width="1.2"/><circle r="4" fill="none" stroke="{gold}"/></g>'
    body += f'<marker id="{uid}-arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0 0 10 5 0 10Z" fill="{gold}"/></marker>'
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 800" role="img" aria-label="分布式系统与数据面书封：客户端、三副本、法定人数">\n{body}\n</svg>\n'

def main():
    covers = {
        "robot": ("robot.svg", cover_robot()),
        "matrix": ("matrix.svg", cover_matrix()),
        "numerical": ("numerical.svg", cover_numerical()),
        "deeplearning": ("deeplearning.svg", cover_dl()),
        "distributed": ("distributed.svg", cover_distributed()),
    }
    for book, (name, svg) in covers.items():
        out = ROOT / book / "src" / "assets" / "covers" / name
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(svg, encoding="utf-8")
        print(f"{out.relative_to(ROOT)}  {len(svg)/1024:.1f} KB")


if __name__ == "__main__":
    main()
