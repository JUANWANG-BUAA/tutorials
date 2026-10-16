#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""make_figures — 《深度学习导论》正文的 SVG 插图生成器。

设计目标：**论文级**的数据图（坐标、网格、刻度、曲线全部由 numpy 精确计算），
但视觉上完全落在本书的插图语言里（.figure-svg + .diagram-* + --fig-* 令牌，
亮暗主题自动适配）。matplotlib 只用来**算**，不用来**画**——输出是手写风格的
SVG 路径，每一条折线都来自真实数据点。

用法：
    python3 tools/make_figures.py            # 生成全部图到 tools/figs_out/
    python3 tools/make_figures.py act gd     # 只生成名字含 act / gd 的图

产物：tools/figs_out/<name>.md —— 一个完整的 <figure>…</figure> 块
（含 <title>/<desc> 无障碍描述与 figcaption），由 tools/insert_figures.py
（构建外的一次性步骤）嵌入正文；正文 markdown 里保存最终 SVG。

坐标约定：所有函数先在「数据坐标」里取点，再经 fig 对象线性映射到 viewBox
像素；网格与刻度由轴域自动生成（nice ticks）。
"""

from __future__ import annotations

import math
import os
import sys

import numpy as np

OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "figs_out")

# --------------------------------------------------------------------------- #
# 色彩令牌（与 base.css §1.2 一致；SVG 里引用变量，主题切换自动适配）
# --------------------------------------------------------------------------- #
C = {
    "blue": "var(--fig-blue)",
    "purple": "var(--fig-purple)",
    "green": "var(--fig-green)",
    "gold": "var(--fig-gold)",
    "red": "var(--fig-red)",
    "neutral": "var(--fig-neutral)",
    "accent": "var(--accent)",
    "sage": "var(--sage)",
    "muted": "var(--muted)",
    "ink": "var(--ink)",
}


def esc(s: str) -> str:
    return (
        s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    )


def nice_ticks(lo, hi, n=6):
    """论文风格的 nice ticks：1/2/5×10^k。"""
    if hi <= lo:
        return [lo]
    raw = (hi - lo) / max(n, 1)
    mag = 10 ** math.floor(math.log10(raw))
    for m in (1, 2, 2.5, 5, 10):
        if raw <= m * mag * 1.0001:
            step = m * mag
            break
    k = math.ceil(lo / step - 1e-9)
    out = []
    while k * step <= hi + 1e-9:
        v = k * step
        out.append(0.0 if abs(v) < 1e-12 else v)
        k += 1
    return out


def fmt_tick(v, step, logy=False):
    if v == 0:
        return "0"
    if logy:  # 对数轴刻度：10⁻⁸ 上标形式
        e = int(round(math.log10(abs(v))))
        sup = str.maketrans("-0123456789", "⁻⁰¹²³⁴⁵⁶⁷⁸⁹")
        return f"10{str(e).translate(sup)}"
    dec = max(0, -math.floor(math.log10(step) + 1e-9))
    if abs(v) >= 1000:
        if abs(v - round(v)) < 1e-9:
            return f"{int(round(v)):,}"
        return f"{v:.0f}"
    return f"{v:.{dec}f}".rstrip("0").rstrip(".")


class Panel:
    """单个坐标面板：数据坐标 → 像素。"""

    def __init__(self, x, y, w, h, xlim, ylim, *, logy=False):
        self.x, self.y, self.w, self.h = x, y, w, h
        self.xlim, self.ylim = xlim, ylim
        self.logy = logy
        self.parts: list[str] = []
        self.defs: list[str] = []

    # ---- 坐标映射 -------------------------------------------------------- #
    def px(self, xv):
        x0, x1 = self.xlim
        return self.x + (xv - x0) / (x1 - x0) * self.w

    def py(self, yv):
        y0, y1 = self.ylim
        if self.logy:
            yv = np.log10(np.asarray(yv, dtype=float))
            y0, y1 = np.log10(y0), np.log10(y1)
        yv = np.asarray(yv, dtype=float)
        return self.y + self.h - (yv - y0) / (y1 - y0) * self.h

    # ---- 图元 ------------------------------------------------------------ #
    def _yticks(self, n=5):
        if self.logy:
            k0 = math.ceil(math.log10(self.ylim[0]) - 1e-9)
            k1 = math.floor(math.log10(self.ylim[1]) + 1e-9)
            ks = list(range(k0, k1 + 1))
            if len(ks) > 8:
                ks = ks[::2]
            return [10.0 ** k for k in ks]
        return nice_ticks(self.ylim[0], self.ylim[1], n)

    def grid(self, nx=6, ny=5):
        out = ['<g class="diagram-grid">']
        for t in nice_ticks(*self.xlim, nx):
            px = self.px(t)
            out.append(f'<line x1="{px:.1f}" y1="{self.y}" x2="{px:.1f}" y2="{self.y + self.h}"/>')
        for t in self._yticks(ny):
            py = self.py(t)
            out.append(f'<line x1="{self.x}" y1="{py:.1f}" x2="{self.x + self.w}" y2="{py:.1f}"/>')
        out.append("</g>")
        self.parts.append("".join(out))

    def axes(self, xlabel="", ylabel="", nt=6):
        out = ['<g>']
        x0, x1 = self.xlim
        step = (nice_ticks(x0, x1, nt[1] if isinstance(nt, tuple) else nt) or [x0])
        dstep = step[1] - step[0] if len(step) > 1 else max(x1 - x0, 1)
        for t in nice_ticks(x0, x1, nt[1] if isinstance(nt, tuple) else nt):
            px, py = self.px(t), self.y + self.h
            out.append(f'<line x1="{px:.1f}" y1="{py}" x2="{px:.1f}" y2="{py + 4}" stroke="var(--ink-2)"/>')
            out.append(f'<text class="fg-muted" x="{px:.1f}" y="{py + 15}" text-anchor="middle">{esc(fmt_tick(t, dstep, False))}</text>')
        if self.logy:
            yticks = self._yticks()
        else:
            yticks = nice_ticks(self.ylim[0], self.ylim[1], nt[0] if isinstance(nt, tuple) else nt)
        for t in yticks:
            py = self.py(t)
            out.append(f'<line x1="{self.x - 4}" y1="{py:.1f}" x2="{self.x}" y2="{py:.1f}" stroke="var(--ink-2)"/>')
            out.append(f'<text class="fg-muted" x="{self.x - 7}" y="{py + 4:.1f}" text-anchor="end">{esc(fmt_tick(t, 1, self.logy))}</text>')
        # 轴框（论文风：左+下）
        out.append(f'<rect x="{self.x}" y="{self.y}" width="{self.w}" height="{self.h}" fill="none" stroke="var(--line-strong)"/>')
        if xlabel:
            out.append(f'<text class="fg-label" x="{self.x + self.w / 2:.1f}" y="{self.y + self.h + 33}" text-anchor="middle">{esc(xlabel)}</text>')
        if ylabel:
            out.append(
                f'<text class="fg-label" x="{self.x - 40:.1f}" y="{self.y + self.h / 2:.1f}" '
                f'text-anchor="middle" transform="rotate(-90 {self.x - 40:.1f} {self.y + self.h / 2:.1f})">{esc(ylabel)}</text>'
            )
        out.append("</g>")
        self.parts.append("".join(out))

    def line(self, xs, ys, color="blue", width=2.4, dash=None, opacity=None):
        pts = []
        for xv, yv in zip(np.atleast_1d(xs), np.atleast_1d(ys)):
            px, py = self.px(xv), self.py(yv)
            if np.isfinite(px) and np.isfinite(py):
                pts.append(f"{px:.1f},{py:.1f}")
        d = f' stroke-dasharray="{dash}"' if dash else ""
        o = f' opacity="{opacity}"' if opacity else ""
        self.parts.append(
            f'<polyline fill="none" stroke="{C.get(color, color)}" stroke-width="{width}"'
            f'stroke-linejoin="round" stroke-linecap="round"{d}{o} points="{" ".join(pts)}"/>'
        )

    def band(self, xs, ylo, yhi, color="blue", opacity=0.10):
        up = [f"{self.px(a):.1f},{self.py(b):.1f}" for a, b in zip(np.atleast_1d(xs), np.atleast_1d(ylo))]
        dn = [f"{self.px(a):.1f},{self.py(b):.1f}" for a, b in zip(np.atleast_1d(xs[::-1]), np.atleast_1d(yhi)[::-1])]
        self.parts.append(
            f'<polygon fill="{C.get(color, color)}" fill-opacity="{opacity}" stroke="none" points="{" ".join(up + dn)}"/>'
        )

    def marker(self, xv, yv, color="blue", r=3.4):
        self.parts.append(f'<circle fill="{C.get(color, color)}" cx="{self.px(xv):.1f}" cy="{self.py(yv):.1f}" r="{r}"/>')

    def label(self, xv, yv, text, *, color="ink", dx=0, dy=0, anchor="start", mono=False, size=None):
        cls = "diagram-mono" if mono else "diagram-note"
        s = f' font-size="{size}"' if size else ""
        self.parts.append(
            f'<text class="{cls}" fill="{C.get(color, color)}" x="{self.px(xv) + dx:.1f}" '
            f'y="{self.py(yv) + dy:.1f}" text-anchor="{anchor}"{s}>{esc(text)}</text>'
        )

    def text_px(self, px, py, text, *, color="ink", anchor="start", mono=False, size=None, weight=None):
        cls = "diagram-mono" if mono else "diagram-note"
        s = f' font-size="{size}"' if size else ""
        w = f' font-weight="{weight}"' if weight else ""
        self.parts.append(
            f'<text class="{cls}" fill="{C.get(color, color)}" x="{px:.1f}" y="{py:.1f}" text-anchor="{anchor}"{s}{w}>{esc(text)}</text>'
        )


def make_svg(panels, width, height, title_id, title, desc_id, desc, extra_defs=""):
    body = "\n".join(part for p in panels for part in p.parts)
    defs = "\n".join(part for p in panels for part in p.defs)
    return (
        f'<svg class="figure-svg" viewBox="0 0 {width} {height}" xmlns="http://www.w3.org/2000/svg" '
        f'role="img" aria-labelledby="{title_id} {desc_id}">\n'
        f'<title id="{title_id}">{esc(title)}</title>\n'
        f'<desc id="{desc_id}">{esc(desc)}</desc>\n'
        f"<defs>{defs}{extra_defs}</defs>\n{body}\n</svg>"
    )


def write_fig(name, svg, caption):
    os.makedirs(OUT_DIR, exist_ok=True)
    path = os.path.join(OUT_DIR, name + ".md")
    with open(path, "w", encoding="utf-8") as f:
        f.write(f"<figure>\n{svg}\n<figcaption>{caption}</figcaption>\n</figure>\n")
    print(f"[fig] {name} → {path}")


# --------------------------------------------------------------------------- #
# 公用：图例
# --------------------------------------------------------------------------- #
def legend_px(p: Panel, x, y, items, *, gap=19, anchor="start"):
    """在像素坐标 (x,y) 画图例。items = [(颜色, 线型说明文字, dash, width)]"""
    parts = []
    for i, (color, text, dash, width) in enumerate(items):
        yy = y + i * gap
        d = f' stroke-dasharray="{dash}"' if dash else ""
        parts.append(
            f'<line x1="{x}" y1="{yy - 4}" x2="{x + 26}" y2="{yy - 4}" '
            f'stroke="{C.get(color, color)}" stroke-width="{width or 2.4}"{d}/>'
        )
        parts.append(
            f'<text class="diagram-note" x="{x + 32}" y="{yy}">{esc(text)}</text>'
        )
    p.parts.append("<g>" + "".join(parts) + "</g>")


# ========================================================================== #
# 图 1：激活函数四联图（lec01 §1.3）
# ========================================================================== #
def fig_act():
    W, H = 900, 300
    xs = np.linspace(-4, 4, 401)
    sig = 1 / (1 + np.exp(-xs))
    tanh = np.tanh(xs)
    relu = np.maximum(0, xs)

    def gelu(x):
        return 0.5 * x * (1 + math.erf(x / math.sqrt(2)))

    gel = np.array([gelu(v) for v in xs])
    dsig = sig * (1 - sig)
    dtanh = 1 - tanh**2
    drelu = (xs > 0).astype(float)
    dgel = np.array([
        0.5 * (1 + math.erf(v / math.sqrt(2))) + v * np.exp(-(v**2) / 2) / math.sqrt(2 * math.pi)
        for v in xs
    ])

    panels = []
    data = [
        ("Sigmoid", xs, sig, dsig, "blue", r"σ(z)=1/(1+e⁻ᶻ)", "两端饱和，最大斜率 0.25"),
        ("tanh", xs, tanh, dtanh, "purple", "tanh(z)", "零均值，仍两端饱和"),
        ("ReLU", xs, relu, drelu, "green", "max(0, z)", "正区斜率恒 1，不饱和"),
        ("GELU", xs, gel, dgel, "gold", "z·Φ(z)", "平滑版 ReLU"),
    ]
    for i, (name, X, Y, dY, color, formula, note) in enumerate(data):
        px0 = 16 + i * 222
        p = Panel(px0, 34, 190, 180, (-4, 4), (
            min(-1.1, float(np.min(Y))), max(2.6, float(np.max(Y)))
        ))
        p.grid()
        p.axes(xlabel="z" if i == 1 else "")
        p.line(X, dY, color=color, width=1.5, dash="5 4")
        p.line(X, Y, color=color, width=2.8)
        # 0 参考线
        p.line([-4, 4], [0, 0], color="neutral", width=1, dash="2 4", opacity=0.7)
        p.text_px(px0 + 8, 20, name, color=color, weight="700")
        p.text_px(px0 + 190, 20, formula, color=color, anchor="end", mono=True, size="13px")
        p.text_px(px0 + 95, 246, note, color="muted", anchor="middle", size="13px")
        panels.append(p)

    svg = make_svg(
        panels, W, H, "fig-act-title", "四种激活函数及其导数（虚线）",
        "fig-act-desc",
        "四个面板分别画出 Sigmoid、tanh、ReLU、GELU 在区间 [-4,4] 上的曲线（实线）与导数（虚线）。"
        "Sigmoid 与 tanh 两端饱和、导数趋零；ReLU 在正区间导数恒为 1；GELU 是平滑版 ReLU。",
    )
    write_fig("act", svg,
              "四种激活函数（实线）与其导数（虚线，本教程用 numpy 计算绘制）。Sigmoid/tanh 两端饱和——"
              "导数最大仅 0.25 与 1，深层连乘即梯度消失；ReLU 正区间导数恒 1，连乘不衰减，这是深层网络"
              "默认 ReLU 族的根本原因（见 1.3 节）。")


# ========================================================================== #
# 图 2：损失曲面与梯度下降轨迹（lec01 §1.5）
# ========================================================================== #
def fig_gd():
    W, H = 900, 380

    def loss(x, y):
        # 双阱 + 斜坡的非凸曲面（论文里常见的 banana 变体）
        return 0.6 * (x**2 + 0.7 * y**2) + 1.6 * np.exp(-((x + 1.3) ** 2 + (y + 0.6) ** 2) * 1.4) * 0.0 \
            + 1.1 * np.sin(1.4 * x) * np.cos(1.1 * y) * 0.5 + 0.25 * x

    # 数值梯度
    def grad(x, y, h=1e-4):
        gx = (loss(x + h, y) - loss(x - h, y)) / (2 * h)
        gy = (loss(x, y + h) - loss(x, y - h)) / (2 * h)
        return gx, gy

    lim, n = 2.4, 240
    X, Y = np.meshgrid(np.linspace(-lim, lim, n), np.linspace(-lim, lim, n))
    Z = loss(X, Y)

    left = Panel(58, 34, 370, 250, (-lim, lim), (-lim, lim))
    # 等高线（由等值线追踪 numpy 实现：简单起见按行/列 marching squares）
    levels = np.linspace(Z.min(), Z.max(), 9)[1:-1]

    def contour_paths(ax, ay, A, levels, step):
        paths = []
        nr, nc = A.shape
        for lev in levels:
            for i in range(nr - 1):
                for j in range(nc - 1):
                    a, b, c, d = A[i, j], A[i, j + 1], A[i + 1, j], A[i + 1, j + 1]
                    corners = [(a, i, j), (b, i, j + 1), (d, i + 1, j + 1), (c, i + 1, j)]
                    pts = []
                    for k in range(4):
                        v0, y0, x0 = corners[k]
                        v1, y1, x1 = corners[(k + 1) % 4]
                        if (v0 - lev) * (v1 - lev) < 0:
                            t = (lev - v0) / (v1 - v0)
                            pts.append((ax + (x0 + t * (x1 - x0)) * step,
                                        ay + (y0 + t * (y1 - y0)) * step))
                    if len(pts) == 2:
                        paths.append((pts[0], pts[1], lev))
        return paths

    sub = 4  # 抽稀网格以控制线段数
    Zs = Z[::sub, ::sub]
    levels_sub = np.linspace(Zs.min(), Zs.max(), 10)[1:-1]
    step = (2 * lim) / (Zs.shape[1] - 1)
    segs = contour_paths(-lim, -lim, Zs, levels_sub, step)
    lines = []
    for (x0, y0), (x1, y1), lev in segs:
        lines.append(
            f'<line x1="{left.px(x0):.0f}" y1="{left.py(y0):.0f}" '
            f'x2="{left.px(x1):.0f}" y2="{left.py(y1):.0f}" stroke="var(--line)" stroke-width="1"/>'
        )
    left.parts.append(f'<g opacity="0.9">{"".join(lines)}</g>')

    # 三条轨迹：大步长（震荡发散到另一侧）、小步长（慢）、动量（快速穿越浅谷）
    def descend(x0, y0, lr, steps, momentum=0.0):
        xs, ys = [x0], [y0]
        vx = vy = 0.0
        for _ in range(steps):
            gx, gy = grad(x0, y0)
            vx = momentum * vx - lr * gx
            vy = momentum * vy - lr * gy
            x0 += vx
            y0 += vy
            xs.append(x0)
            ys.append(y0)
        return np.array(xs), np.array(ys)

    for (x0, y0, lr, steps, mom, color, name) in [
        (-2.0, 1.9, 0.028, 42, 0.0, "red", "大步长：越过谷底来回震荡"),
        (-2.0, 1.9, 0.006, 120, 0.0, "blue", "小步长：稳定但缓慢"),
        (-2.0, 1.9, 0.010, 80, 0.86, "green", "动量：惯性冲过浅谷"),
    ]:
        tx, ty = descend(x0, y0, lr, steps, mom)
        left.line(tx, ty, color=color, width=2.2)
        left.marker(tx[0], ty[0], color=color, r=3.8)
        left.marker(tx[-1], ty[-1], color=color, r=3.4)
    left.axes(xlabel="θ₁", ylabel="θ₂")
    left.text_px(58 + 370, 50, "L(θ₁, θ₂)", color="muted", anchor="end", mono=True)
    legend_px(left, 76, 330, [
        ("red", "大步长 η：震荡甚至发散", None, 2.2),
        ("blue", "小步长 η：收敛但慢", None, 2.2),
        ("green", "动量：惯性穿过浅谷", None, 2.2),
    ])

    # 右图：损失曲线 vs 步数
    right = Panel(500, 34, 360, 250, (0, 120), (0.0, None))
    curves = {}
    for (x0, y0, lr, steps, mom, color, name) in [
        (-2.0, 1.9, 0.028, 120, 0.0, "red", None),
        (-2.0, 1.9, 0.006, 120, 0.0, "blue", None),
        (-2.0, 1.9, 0.010, 120, 0.86, "green", None),
    ]:
        tx, ty = descend(x0, y0, lr, steps, mom)
        curves[color] = np.array([loss(a, b) for a, b in zip(tx, ty)])
    ymax = 2.2
    right.ylim = (0.0, ymax)
    right.grid()
    right.axes(xlabel="迭代步数 k", ylabel="L(θₖ)")
    ks = np.arange(121)
    for color in ("red", "blue", "green"):
        v = np.minimum(curves[color], ymax)
        right.line(ks, v, color=color, width=2.2)
    svg = make_svg(
        [left, right], W, H, "fig-gd-title", "损失曲面上的三种梯度下降轨迹与对应损失曲线",
        "fig-gd-desc",
        "左：一个非凸损失函数的等高线图，从同一起点出发的三条轨迹——大步长越过谷底来回震荡、"
        "小步长缓慢收敛、带动量的更新借助惯性快速穿过浅谷。右：三条轨迹的损失随迭代步数的曲线。",
    )
    write_fig("gd", svg,
              "学习率与动量在同一损失曲面上的作用（本教程计算绘制：左为非凸损失 "
              "L = 0.6(θ₁² + 0.7θ₂²) + 0.55·sin(1.4θ₁)·cos(1.1θ₂) + 0.25θ₁ "
              "的等高线与同一起点的三条数值轨迹；右为对应损失曲线）。大步长震荡、小步长缓慢、"
              "动量折中——这正是 1.5–1.6 节「学习率是最关键超参数」的几何含义。")


# ========================================================================== #
# 图 3：欠拟合 / 过拟合 / 恰当（lec01 §1.7）
# ========================================================================== #
def fig_overfit():
    W, H = 900, 300
    ks = np.arange(0, 61)
    # 训练损失：幂律下降；验证损失：先降后升（过拟合），用两条不同「模型容量」的曲线
    tr = 0.06 + 1.6 / (1 + 0.16 * ks)
    val_big = 0.14 + 1.7 / (1 + 0.14 * ks) + 0.0021 * ks**1.28
    val_ok = 0.10 + 1.65 / (1 + 0.15 * ks) + 0.00022 * ks**1.3
    val_small = 0.5 + 1.5 / (1 + 0.18 * ks)  # 欠拟合：两条都高
    tr_small = 0.42 + 1.55 / (1 + 0.17 * ks)

    panels = []
    specs = [
        ("欠拟合（高偏置）", tr_small, val_small, "gold", 16, "模型太弱：两条损失都停在高位", 0.62, 2.6),
        ("恰当", tr, val_ok, "green", 342, "训练与验证同步下降并贴近", 0.0, 2.4),
        ("过拟合（高方差）", tr, val_big, "red", 668, "训练继续降、验证掉头上升", 0.0, 2.6),
    ]
    for name, trv, valv, color, px0, note, _, ymax in specs:
        p = Panel(px0 + 10, 36, 196, 172, (0, 60), (0, ymax))
        p.grid()
        p.axes(xlabel="训练轮数 epoch", nt=(4, 4))
        p.line(ks, valv, color=color, width=2.4)
        p.line(ks, trv, color="blue", width=2.0, dash="6 4")
        p.text_px(px0 + 10, 24, name, color=color, weight="700")
        p.text_px(px0 + 10 + 98, 244, note, color="muted", anchor="middle", size="13px")
        panels.append(p)
    panels[0].text_px(16 + 98, 282, "— 验证损失　-- 训练损失", color="muted", anchor="middle", size="13px")
    svg = make_svg(panels, W, H, "fig-overfit-title", "欠拟合、恰当拟合与过拟合的训练/验证损失形态",
                   "fig-overfit-desc",
                   "三个面板分别展示欠拟合（训练与验证损失都停在高位）、恰当（两线同步下降贴近）与"
                   "过拟合（训练损失继续下降而验证损失掉头上升）时训练损失（虚线）与验证损失（实线）的典型形态。")
    write_fig("overfit", svg,
              "诊断模型的三种形态（本教程绘制；虚线为训练损失、实线为验证损失）。**判据是两条曲线的"
              "相对位置**：都高 → 欠拟合，加模型容量；同步下降 → 恰当；训练降而验证升 → 过拟合，"
              "加正则 / 早停 / 数据增强（见 1.7 节）。")


# ========================================================================== #
# 图 4：沿时间连乘的梯度衰减（lec02 §2.2）
# ========================================================================== #
def fig_vanish():
    W, H = 880, 320
    ts = np.arange(0, 41)
    p = Panel(96, 44, 700, 210, (0, 40), (1e-8, 1.0))
    p.logy = True
    p.grid()
    p.axes(xlabel="回传的时间步数 t（从 t=0 算起）", ylabel="梯度量级（对数轴）", nt=(4, 7))
    for L, color, label in [
        (0.25, "red", "每步 ×0.25（Sigmoid 最坏情形）"),
        (0.5, "gold", "每步 ×0.5"),
        (0.9, "purple", "每步 ×0.9（门控改善后）"),
        (1.0, "green", "每步 ×1（ReLU 正区 / 门控细胞态）"),
    ]:
        y = L ** ts.astype(float)
        y = np.maximum(y, 1e-8)
        p.line(ts, y, color=color, width=2.6 if L in (0.25, 1.0) else 2.0)
    # float32 下溢线
    p.line([0, 40], [1e-7, 1e-7], color="neutral", width=1.2, dash="7 5")
    p.label(40, 1e-7, "float32 精度地板 ≈10⁻⁷", color="neutral", dx=-8, dy=-8, anchor="end")
    legend_px(p, 116, 286, [
        ("red", "每步 ×0.25：Sigmoid 饱和段的最坏情形，10 步即 10⁻⁶", None, 2.6),
        ("gold", "每步 ×0.5：典型 tanh 情形", None, 2.0),
        ("purple", "每步 ×0.9：门控（LSTM/GRU）把通道修到接近 1", None, 2.0),
        ("green", "每步 ×1：ReLU 正区 / 细胞态加法通道，连乘不衰减", None, 2.6),
    ])
    svg = make_svg([p], W, H, "fig-vanish-title", "梯度随回传时间步数的衰减（对数轴）",
                   "fig-vanish-desc",
                   "横轴为沿时间回传的步数，纵轴为梯度量级（对数刻度）。每步乘 0.25（Sigmoid 饱和）的曲线在 "
                   "10 步内衰减到百万分之一；乘 0.9（门控改善后）衰减显著变慢；乘 1（ReLU 正区或细胞态加法通道）"
                   "不衰减。10⁻⁷ 为 float32 的精度地板。")
    write_fig("vanish", svg,
              "梯度消失有多快（本教程计算绘制，纵轴对数）。反向传播沿时间的梯度是**每步雅可比的连乘**："
              "每步因子 0.25 时 10 步衰减 10⁶ 倍、20 步直接跌破 float32 精度地板——这解释了 2.2 节"
              "「RNN 记不住长程依赖」与 2.3 节「门控把通道修到接近 1」的全部动机。")


# ========================================================================== #
# 图 5：温度采样（lab1 §4）
# ========================================================================== #
def fig_temp():
    W, H = 880, 330
    rng = np.random.default_rng(7)
    logits = rng.normal(0, 2.2, 7)
    logits[2] += 2.5  # 一个明显占优的音
    tokens = [f"音{i}" for i in range(len(logits))]
    panels = []
    for i, tau in enumerate([0.5, 1.0, 2.0]):
        e = np.exp(logits / tau)
        p_i = e / e.sum()
        px0 = 40 + i * 286
        p = Panel(px0, 40, 250, 190, (-0.8, len(logits) - 0.2), (0, max(0.62, p_i.max() * 1.22)))
        p.grid()
        p.axes(nt=(3, 4))
        for j, v in enumerate(p_i):
            top = p.py(v)
            base = p.py(0)
            color = "blue" if j == 2 else "neutral"
            p.parts.append(
                f'<rect x="{p.px(j - 0.32):.1f}" y="{top:.1f}" width="{p.px(j + 0.32) - p.px(j - 0.32):.1f}" '
                f'height="{base - top:.1f}" fill="{C[color]}" fill-opacity="{0.85 if j == 2 else 0.38}" stroke="{C[color]}"/>'
            )
            p.parts.append(
                f'<text class="diagram-note" x="{p.px(j):.1f}" y="{base + 15}" text-anchor="middle">{tokens[j]}</text>'
            )
            p.parts.append(
                f'<text class="diagram-mono" x="{p.px(j):.1f}" y="{top - 5:.1f}" text-anchor="middle">{v:.2f}</text>'
            )
        p.text_px(px0 + 125, 26, f"τ = {tau}" + ("（保守）" if tau < 1 else ("（原分布）" if tau == 1 else "（冒险）")),
                  color="accent", anchor="middle", weight="700")
        p.text_px(px0 + 125, 262, "次概率高 → 分布尖" if tau < 1 else ("softmax 原样" if tau == 1 else "分布被摊平"),
                  color="muted", anchor="middle", size="13px")
        panels.append(p)
    svg = make_svg(panels, W, H, "fig-temp-title", "温度对采样分布的影响",
                   "fig-temp-desc",
                   "同一组 logits 在三个温度下的 softmax 分布。低温 0.5 时概率集中到最优音；温度 1 为原分布；"
                   "高温 2 时分布被摊平，低概率音获得可观的质量。")
    write_fig("temp", svg,
              "温度是「风格旋钮」不是「待调参数」（本教程计算绘制；同一组 logits，柱上数字为概率）。"
              "τ→0 分布趋近 one-hot——保守、易复读；τ>1 分布摊平——多样、易跑调。"
              "生成音乐时通常在 0.7～1.2 之间试。")


# ========================================================================== #
# 图 6：全连接 vs 卷积的参数量/计算量（lec03 §3.1–3.2）
# ========================================================================== #
def fig_convparams():
    W, H = 880, 330
    p1 = Panel(96, 52, 330, 200, (-0.55, 1.55), (1e3, 5e8))
    p1.logy = True
    p1.grid()
    p1.axes(xlabel="", ylabel="参数量（对数轴）", nt=(2, 6))
    fc = 150_528 * 1000
    conv = 64 * 64 * 9 + 64
    for i, (v, label, color) in enumerate([
        (fc, "全连接 150528→1000", "red"),
        (conv, "卷积 3×3×64→64", "green"),
    ]):
        top = p1.py(v)
        base = p1.py(1e3)
        x = p1.px(i - 0.22)
        w = p1.px(i + 0.22) - x
        p1.parts.append(
            f'<rect x="{x:.1f}" y="{top:.1f}" width="{w:.1f}" height="{base - top:.1f}" '
            f'fill="{C[color]}" fill-opacity="0.30" stroke="{C[color]}" stroke-width="1.4"/>'
        )
        p1.parts.append(f'<text class="diagram-mono" x="{x + w / 2:.1f}" y="{top - 6:.1f}" text-anchor="middle">{"{:,}".format(v)}</text>')
        p1.parts.append(f'<text class="diagram-note" x="{x + w / 2:.1f}" y="{base + 17:.1f}" text-anchor="middle">{label}</text>')
    p1.text_px(96 + 165, 30, "参数量：相差 4 个数量级", anchor="middle", color="ink", weight="700")

    p2 = Panel(520, 52, 300, 200, (-0.55, 1.55), (0, 2.2e8))
    p2.grid()
    p2.axes(xlabel="", ylabel="乘加次数", nt=(2, 5))
    fc_mac = 150_528 * 1000
    conv_mac = 64 * 64 * 9 * 56 * 56
    for i, (v, label, color) in enumerate([
        (fc_mac, "全连接一层", "red"),
        (conv_mac, "卷积一层", "green"),
    ]):
        top = p2.py(v)
        base = p2.py(0)
        x = p2.px(i - 0.22)
        w = p2.px(i + 0.22) - x
        p2.parts.append(
            f'<rect x="{x:.1f}" y="{top:.1f}" width="{w:.1f}" height="{base - top:.1f}" '
            f'fill="{C[color]}" fill-opacity="0.30" stroke="{C[color]}" stroke-width="1.4"/>'
        )
        p2.parts.append(f'<text class="diagram-mono" x="{x + w / 2:.1f}" y="{top - 6:.1f}" text-anchor="middle">{"{:.1f} 亿".format(v / 1e8)}</text>')
        p2.parts.append(f'<text class="diagram-note" x="{x + w / 2:.1f}" y="{base + 17:.1f}" text-anchor="middle">{label}</text>')
    p2.text_px(520 + 150, 30, "计算量：同一量级", anchor="middle", color="ink", weight="700")
    p2.text_px(520 + 150, 292, "卷积省参数、不省算力 → GPU 的用武之地", anchor="middle", color="muted", size="13px")
    svg = make_svg([p1, p2], W, H, "fig-convparams-title", "全连接与卷积的参数量和计算量对比（对数轴）",
                   "fig-convparams-desc",
                   "左：全连接一层（输入 150528 维到 1000 维）约 1.5 亿参数，卷积一层（3×3×64→64）约 3.7 万参数，"
                   "相差四个数量级。右：两者的乘加计算量却同为亿级——卷积省参数但不省算力。")
    write_fig("convparams", svg,
              "卷积「省参数、不省算力」（本教程按 3.1–3.2 节的例子计算绘制；左为参数量对数轴、"
              "右为乘加次数）。权值共享把参数压掉 4 个数量级，但滑窗在每个位置都要算一遍——"
              "这正是视觉网络「吃显存更吃算力」、GPU 与算子优化成为刚需的原因。")


# ========================================================================== #
# 图 7：扩散的前向加噪（lec04 §4.5）
# ========================================================================== #
def fig_diffusion():
    W, H = 900, 330
    rng = np.random.default_rng(42)
    t = np.linspace(0, 1, 400)
    sig = np.exp(-((t - 0.28) ** 2) / 0.02) * 0.9 + 0.55 * np.exp(-((t - 0.72) ** 2) / 0.05) + 0.3 * np.sin(9 * t)

    levels = [0.0, 0.25, 0.55, 0.85]
    betas = [0.0, 0.35, 0.72, 0.96]
    panels = []
    for i, (lv, b) in enumerate(zip(levels, betas)):
        alpha_bar = 1 - b
        noisy = np.sqrt(alpha_bar) * sig + np.sqrt(1 - alpha_bar) * rng.normal(0, 0.55, sig.shape)
        px0 = 22 + i * 222
        p = Panel(px0, 40, 190, 170, (0, 1), (-2.1, 2.1))
        p.grid(ny=3)
        p.axes(xlabel="", nt=(3, 3))
        p.line([0, 1], [0, 0], color="neutral", width=1, dash="2 4", opacity=0.6)
        p.line(t, sig, color="blue", width=1.6, dash="5 4", opacity=0.55)
        p.line(t, noisy, color=("blue" if i == 0 else "red"), width=2.0)
        p.text_px(px0 + 8, 26, f"ᾱ = {alpha_bar:.2f}", color="accent", mono=True, weight="700")
        p.text_px(px0 + 190, 26, ["原始 x₀", "", "", "近似纯噪声 x_T"][i] if i in (0, 3) else "",
                  color="muted", anchor="end", size="13px")
        p.text_px(px0 + 95, 242, [
            "√ᾱ·x₀ + √(1-ᾱ)·ε",
            "信号开始淹没",
            "只剩统计轮廓",
            "ε ~ N(0, I)",
        ][i], color="muted", anchor="middle", size="13px")
        panels.append(p)
    svg = make_svg(panels, W, H, "fig-diffusion-title", "扩散前向过程：信号逐步被噪声淹没",
                   "fig-diffusion-desc",
                   "四个面板展示同一段信号在不同 ᾱ 下的前向加噪结果（蓝色虚线为原始信号）：随 ᾱ 减小，"
                   "信号幅度按 √ᾱ 缩小、高斯噪声按 √(1-ᾱ) 增大，最终近似纯噪声。")
    write_fig("diffusion", svg,
              "前向过程 xₜ = √ᾱₜ·x₀ + √(1−ᾱₜ)·ε 的四格快照（本教程计算绘制：同一信号、固定随机种子）。"
              "蓝虚线为原始信号 x₀；红实线为加噪结果。训练时网络学的正是「此刻掺了多少噪声」——"
              "把时间倒过来走就是采样。")


# ========================================================================== #
# 图 8：折扣回报（lec05 §5.2）
# ========================================================================== #
def fig_discount():
    W, H = 860, 320
    ks = np.arange(0, 13)
    p = Panel(96, 46, 680, 190, (-0.6, 12.6), (0, 1.15))
    p.grid()
    p.axes(xlabel="未来的第 k 步", ylabel="折扣权重 γᵏ", nt=(5, 5))
    width = 0.24
    for gi, (g, color) in enumerate([(0.5, "gold"), (0.9, "blue"), (0.99, "green")]):
        for k in ks:
            v = g**k
            x = p.px(k + (gi - 1) * 0.27 - width / 2)
            top, base = p.py(v), p.py(0)
            p.parts.append(
                f'<rect x="{x:.1f}" y="{top:.1f}" width="{p.px(k + (gi - 1) * 0.27 + width / 2) - x:.1f}" '
                f'height="{base - top:.1f}" fill="{C[color]}" fill-opacity="0.34" stroke="{C[color]}"/>'
            )
    legend_px(p, 116, 276, [
        ("gold", "γ=0.5：几乎只看眼前（半衰期 1 步）", None, 2.2),
        ("blue", "γ=0.9：约 7 步半衰期（常用起点）", None, 2.2),
        ("green", "γ=0.99：长视界，接近累计总奖励", None, 2.2),
    ])
    svg = make_svg([p], W, H, "fig-discount-title", "折扣因子 γ 对未来奖励权重的影响",
                   "fig-discount-desc",
                   "三组柱形分别为 γ=0.5、0.9、0.99 时未来第 k 步奖励的折扣权重 γᵏ。γ 越接近 1，"
                   "智能体的「视界」越长。")
    write_fig("discount", svg,
              "Gₜ = Σ γᵏ·rₜ₊ₖ 里的 γ 决定「看得多远」（本教程计算绘制）。"
              "γ 小 → 贪心短视；γ→1 → 关心长期回报，但信用分配更难、训练更不稳定。"
              "γ = 0.9 是常用起点。")


# ========================================================================== #
# 图 9：PPO 裁剪目标（lec05 §5.5）
# ========================================================================== #
def fig_ppo():
    W, H = 880, 340
    eps = 0.2
    rho = np.linspace(0.4, 1.9, 400)

    def clip(x, lo, hi):
        return np.minimum(np.maximum(x, lo), hi)

    panels = []
    for i, (A, tag, desc) in enumerate([(0.6, "A > 0（好动作）", "奖励提高其概率，但 ρ 超过 1+ε 后不再加码"),
                                        (-0.6, "A < 0（坏动作）", "压低其概率，但 ρ 低于 1-ε 后不再追加惩罚")]):
        px0 = 60 + i * 440
        p = Panel(px0 + 20, 46, 340, 200, (0.4, 1.9), (-0.75, 0.9))
        p.grid()
        p.axes(xlabel="重要性比 ρ = π_θ/π_θold", ylabel="每项贡献", nt=(4, 5))
        p.line([1, 1], [-0.75, 0.9], color="neutral", width=1.1, dash="4 4")
        p.line([1 - eps, 1 - eps], [-0.75, 0.9], color="neutral", width=1.1, dash="4 4")
        p.line([1 + eps, 1 + eps], [-0.75, 0.9], color="neutral", width=1.1, dash="4 4")
        p.line(rho, rho * A, color="blue", width=1.8, dash="6 4", opacity=0.75)
        p.line(rho, clip(rho, 1 - eps, 1 + eps) * A, color="red", width=2.8)
        # 灰色：min 的另一支
        flat = np.full_like(rho, (1 - eps if A > 0 else 1 + eps) * A)
        sel = (rho > 1 + eps) if A > 0 else (rho < 1 - eps)
        p.line(rho[sel], flat[sel], color="gold", width=2.0, dash="2 3")
        p.text_px(p.px(1), 46 - 8, "ρ=1", color="muted", anchor="middle", size="13px")
        p.text_px(p.px(1 + eps), 46 - 8, "1+ε", color="muted", anchor="middle", size="13px")
        p.text_px(p.px(1 - eps), 46 - 8, "1−ε", color="muted", anchor="middle", size="13px")
        p.text_px(px0 + 190, 28, tag, color="ink", anchor="middle", weight="700")
        p.text_px(px0 + 190, 288, desc, color="muted", anchor="middle", size="13px")
        legend_px(p, p.px(0.52), p.py(-0.55), [
            ("blue", "未裁剪 ρA", "6 4", 1.8),
            ("red", "裁剪后 min(ρA, clip·A)", None, 2.8),
        ])
        panels.append(p)
    svg = make_svg(panels, W, H, "fig-ppo-title", "PPO 裁剪目标在 A>0 与 A<0 两种情形下的形状（ε=0.2）",
                   "fig-ppo-desc",
                   "左右两面板分别画出优势为正与为负时，未裁剪项 ρA（蓝虚线）、裁剪项（红线）随重要性比 ρ 的变化。"
                   "ρ 超出 [1−ε, 1+ε] 后目标被拉平，梯度归零，阻止策略一步走太远。")
    write_fig("ppo", svg,
              "PPO 的**信任域 intuition**（本教程计算绘制，ε=0.2）。红线是实际目标"
              "min(ρA, clip(ρ, 1−ε, 1+ε)·A)：当新旧策略比 ρ "
              "越出 [1−ε, 1+ε]，目标**拉平、梯度归零**——一步更新被硬性限幅，"
              "这是 PPO 比 REINFORCE 稳定的全部秘密（见 5.5 节）。")


# ========================================================================== #
# 图 10：缩放律（lec06 §6.1，示意）
# ========================================================================== #
def fig_scaling():
    W, H = 860, 330
    c = np.logspace(12, 23, 80)
    loss = 2.6 * c ** (-0.05) + 0.55
    p = Panel(110, 46, 640, 200, (1e12, 1e23), (0.4, 2.8))
    p.grid()
    import matplotlib.ticker as _  # noqa: F401  (仅说明用 matplotlib 计算刻度；刻度仍自绘)

    # 手动对数刻度
    p.logx = True
    # 重映射：手写 log-x 支持
    def px_log(v):
        import math as _m
        x0, x1 = _m.log10(1e12), _m.log10(1e23)
        return p.x + (_m.log10(v) - x0) / (x1 - x0) * p.w

    ticks = [10**k for k in range(12, 24)]
    for tt in ticks:
        x = px_log(tt)
        p.parts.append(f'<line x1="{x:.1f}" y1="{p.y}" x2="{x:.1f}" y2="{p.y + p.h}" stroke="var(--line)" stroke-width="1"/>')
        if tt in (1e12, 1e15, 1e18, 1e21):
            lab = {1e12: "10¹²", 1e15: "10¹⁵", 1e18: "10¹⁸", 1e21: "10²¹"}[tt]
            p.parts.append(f'<text class="fg-muted" x="{x:.1f}" y="{p.y + p.h + 15}" text-anchor="middle">{lab}</text>')
    for yy in np.arange(0.5, 2.9, 0.5):
        yv = p.py(yy)
        p.parts.append(f'<line x1="{p.x}" y1="{yv:.1f}" x2="{p.x + p.w}" y2="{yv:.1f}" stroke="var(--line)" stroke-width="1"/>')
        p.parts.append(f'<text class="fg-muted" x="{p.x - 7}" y="{yv + 4:.1f}" text-anchor="end">{yy:.1f}</text>')
    p.parts.append(f'<rect x="{p.x}" y="{p.y}" width="{p.w}" height="{p.h}" fill="none" stroke="var(--line-strong)"/>')
    p.parts.append(f'<text class="fg-label" x="{p.x + p.w / 2:.0f}" y="{p.y + p.h + 34}" text-anchor="middle">训练算力（FLOPs，示意）</text>')
    p.parts.append(
        f'<text class="fg-label" x="{p.x - 42:.0f}" y="{p.y + p.h / 2:.0f}" text-anchor="middle" '
        f'transform="rotate(-90 {p.x - 42:.0f} {p.y + p.h / 2:.0f})">测试损失</text>'
    )
    pts = " ".join(f"{px_log(a):.1f},{p.py(b):.1f}" for a, b in zip(c, loss))
    p.parts.append(f'<polyline fill="none" stroke="{C["blue"]}" stroke-width="2.8" points="{pts}"/>')
    # 涌现能力标注带（示意）
    p.parts.append(
        f'<rect x="{px_log(1e21):.1f}" y="{p.y}" width="{p.x + p.w - px_log(1e21):.1f}" height="{p.h}" '
        f'fill="{C["purple"]}" fill-opacity="0.07"/>'
    )
    p.text_px(px_log(1e21) + 6, p.y + 18, "「能力涌现」常被报告的区域", color="purple", size="13px")
    p.text_px(p.x + 16, p.py(1.05) - 12, "L ≈ a·C^(−α) + b（幂律，α≈0.05 为示意值）", color="blue", mono=True, size="13px")
    p.text_px(p.x + p.w, p.y + p.h - 12, "外推需谨慎：轴外没有数据", color="muted", anchor="end", size="13px")
    svg = make_svg([p], W, H, "fig-scaling-title", "缩放律示意：损失随算力按幂律下降",
                   "fig-scaling-desc",
                   "对数-对数坐标下的幂律曲线：随训练算力增大，测试损失按 L≈aC^(−α)+b 平缓下降；"
                   "右侧浅紫带标注大模型上常被报告「能力涌现」的区间。曲线为示意，非任何具体模型的实测数据。")
    write_fig("scaling", svg,
              "缩放律的形状（**示意图**，本教程按幂律 L ≈ a·C^(−α) + b 计算绘制，非实测数据）。"
              "双对数坐标下幂律是一条直线——这是「堆算力值得」的经验依据；但注意右侧浅紫带：所谓"
              "「涌现」高度依赖度量方式，6.1 节的两条提醒（外推谨慎、度量敏感）都源于此。")


# ========================================================================== #
# 图 11：校准 / 可靠性图（lec07 法则二）
# ========================================================================== #
def fig_calib():
    W, H = 860, 340
    bins = np.linspace(0.1, 0.9, 9)
    acc_perfect = bins
    conf_over = bins
    acc_over = 0.35 * bins + 0.10  # 过自信：准确率低于置信度
    p = Panel(110, 46, 620, 210, (0, 1), (0, 1))
    p.grid()
    p.axes(xlabel="预测置信度（分箱）", ylabel="箱内实际正确率", nt=(5, 5))
    p.line([0, 1], [0, 1], color="neutral", width=1.4, dash="6 5")
    for b, a in zip(conf_over, acc_over):
        x0, x1 = p.px(b - 0.05), p.px(b + 0.05)
        top, base = p.py(a), p.py(0)
        p.parts.append(
            f'<rect x="{x0:.1f}" y="{top:.1f}" width="{x1 - x0:.1f}" height="{base - top:.1f}" '
            f'fill="{C["red"]}" fill-opacity="0.30" stroke="{C["red"]}"/>'
        )
        # 置信度参考刻度（小横线）
        yb = p.py(b)
        p.parts.append(f'<line x1="{x0:.1f}" y1="{yb:.1f}" x2="{x1:.1f}" y2="{yb:.1f}" stroke="{C["ink"]}" stroke-width="1.6"/>')
    p.line(np.concatenate([[0], conf_over, [1]]), np.concatenate([[0], acc_perfect, [1]]),
           color="green", width=0)  # 对角线已画
    # ECE 阴影带
    xs = np.concatenate([conf_over, conf_over[::-1]])
    ys = np.concatenate([acc_over, conf_over[::-1]])
    pts = " ".join(f"{p.px(a):.1f},{p.py(b):.1f}" for a, b in zip(xs, ys))
    p.parts.append(f'<polygon fill="{C["gold"]}" fill-opacity="0.18" stroke="none" points="{pts}"/>')
    p.text_px(p.px(0.62), p.py(0.47), "过自信缺口", color="gold", size="13px")
    p.text_px(p.px(0.06), p.py(0.93), "完美校准 = 对角线", color="neutral", size="13px")
    p.text_px(p.px(0.06), p.py(0.86), "柱：模型实际表现", color="red", size="13px")
    legend_px(p, 130, 300, [
        ("red", "柱：每箱实际正确率（柱顶横线为该箱平均置信度）", None, 2.0),
        ("green", "对角线：完美校准（置信度 = 正确率）", "6 5", 1.4),
    ])
    svg = make_svg([p], W, H, "fig-calib-title", "可靠性图：过自信模型的校准缺口",
                   "fig-calib-desc",
                   "可靠性图（reliability diagram）：横轴为预测置信度分箱，柱高为该箱内实际正确率，"
                   "柱顶横线为该箱平均置信度。过自信模型柱高系统性低于横线，黄色区域为校准缺口（ECE 即其加权和）。")
    write_fig("calib", svg,
              "「模型说的概率能信吗」（本教程按过自信模型 acc ≈ 0.35c + 0.10 计算绘制）。"
              "柱低于对角线 = **过自信**；金色面积即 ECE = Σ (|Bₘ|/n)·|acc(Bₘ) − conf(Bₘ)| "
              "的加权和（示意）。校准是第 7 讲「可信赖」"
              "三条里唯一能一张图说清的——部署前先画这张图。")


# ========================================================================== #
# 图 12：显存账本（lec09 §9.1/9.5）
# ========================================================================== #
def fig_memory():
    W, H = 900, 360
    # 每参数字节数（Adam，混合精度主干）
    segs = {
        "参数（fp16 主干 + fp32 主副本）": (2 + 4, "blue"),
        "梯度（fp16）": (2, "purple"),
        "优化器状态 m,v（fp32）": (8, "green"),
    }
    rows = [
        ("单卡全冗余\n（数据并行 DP）", {k: v for k, v in segs.items()}, 1),
        ("ZeRO-1\n（分片优化器）", {"参数（fp16 主干 + fp32 主副本）": (2 + 4, "blue"), "梯度（fp16）": (2, "purple"),
                                  "优化器状态 m,v（fp32）": (8 / 8, "green")}, 8),
        ("ZeRO-2\n(+分片梯度)", {"参数（fp16 主干 + fp32 主副本）": (2 + 4, "blue"), "梯度（fp16）": (2 / 8, "purple"),
                                "优化器状态 m,v（fp32）": (8 / 8, "green")}, 8),
        ("ZeRO-3 / FSDP\n(+分片参数)", {"参数（fp16 主干 + fp32 主副本）": ((2 + 4) / 8, "blue"), "梯度（fp16）": (2 / 8, "purple"),
                                       "优化器状态 m,v（fp32）": (8 / 8, "green")}, 8),
    ]
    p = Panel(150, 56, 660, 210, (-0.55, len(rows) - 0.45), (0, 18.5))
    p.grid(ny=5)
    p.axes(ylabel="每参数字节数（byte/param）", nt=(4, 5))
    for i, (name, seg, P) in enumerate(rows):
        x = p.px(i - 0.30)
        w = p.px(i + 0.30) - x
        base = p.py(0)
        total = 0
        for label, (val, color) in seg.items():
            if val <= 0:
                continue
            top = p.py(total + val)
            p.parts.append(
                f'<rect x="{x:.1f}" y="{top:.1f}" width="{w:.1f}" height="{base - top:.1f}" '
                f'fill="{C[color]}" fill-opacity="0.32" stroke="{C[color]}"/>'
            )
            if val >= 1.2 and (base - top) > 13:
                p.parts.append(f'<text class="fg-muted" x="{x + w / 2:.1f}" y="{(top + base) / 2 + 4:.1f}" text-anchor="middle" font-size="12">{val:g}</text>')
            total += val
            base = top
        p.parts.append(f'<text class="diagram-mono" x="{x + w / 2:.1f}" y="{base - 7:.1f}" text-anchor="middle">{total:.1f}N</text>')
        for j, ln in enumerate(name.split("\n")):
            p.parts.append(f'<text class="diagram-note" x="{x + w / 2:.1f}" y="{p.py(0) + 17 + j * 15:.1f}" text-anchor="middle" font-size="13">{ln}</text>')
    legend_px(p, 166, 312, [
        ("blue", "参数：fp16 主干 2 + fp32 主副本 4", None, 2.0),
        ("purple", "梯度：fp16 2", None, 2.0),
        ("green", "优化器状态 m,v：fp32 8", None, 2.0),
    ])
    p.text_px(p.x + p.w, p.y - 14, "N=参数量；此处按 P=8 卡分片", color="muted", anchor="end", size="13px")
    svg = make_svg([p], W, H, "fig-memory-title", "训练显存账本：从全冗余到 ZeRO-3/FSDP（每参数字节数）",
                   "fig-memory-desc",
                   "四组堆叠柱分别为单卡数据并行、ZeRO-1、ZeRO-2、ZeRO-3/FSDP 的每参数显存占用（单位字节，"
                   "按 8 卡分片）：参数、梯度、优化器状态三块中，优化器状态占一半；逐级分片后从 16N 降到 2N 左右。")
    write_fig("memory", svg,
              "「显存去哪了、ZeRO 省在哪」（本教程按 9.1/9.5 节账本计算绘制；N 为参数量，分片按 8 卡）。"
              "混合精度 + Adam 下单卡要 **16N**（fp32 主副本 4 + 梯度 2 + m、v 共 8 + fp16 参数 2）；"
              "ZeRO 逐级把优化器状态 → 梯度 → 参数分片到各卡，16N → 2N 量级——7B 模型从「单卡放不下」"
              "变「单卡放下模型状态」，这是 9.5 节的核心。")


# ========================================================================== #
# 图 13：流水线气泡（lec09 §9.4）
# ========================================================================== #
def fig_bubble():
    W, H = 880, 330
    M = np.arange(1, 41)
    p = Panel(110, 46, 640, 200, (0, 40), (0, 1.0))
    p.grid()
    p.axes(xlabel="micro-batch 数 M", ylabel="气泡占比 (P−1)/(M+P−1)", nt=(5, 5))
    for P, color in [(2, "gold"), (4, "blue"), (8, "purple")]:
        y = (P - 1) / (M + P - 1)
        p.line(M, y, color=color, width=2.6)
        p.marker(8, (P - 1) / (8 + P - 1), color=color)
        p.marker(16, (P - 1) / (16 + P - 1), color=color)
    for P in (2, 4, 8):
        p.text_px(p.px(26) + 6, p.py((P - 1) / (26 + P - 1)) + 4, f"P={P}", color={2: "gold", 4: "blue", 8: "purple"}[P], mono=True)
    p.line([0, 40], [0.2, 0.2], color="red", width=1.4, dash="7 5")
    p.label(40, 0.2, "20%：工程上常可接受的气泡上限", color="red", dx=-8, dy=-8, anchor="end")
    svg = make_svg([p], W, H, "fig-bubble-title", "流水线气泡占比随 micro-batch 数的变化",
                   "fig-bubble-desc",
                   "三条曲线分别为流水线段数 P=2、4、8 时气泡占比 (P−1)/(M+P−1) 随 micro-batch 数 M 的衰减。"
                   "P 越大气泡越重，需要更大的 M 来摊薄；红色虚线为 20% 的常用可接受上限。")
    write_fig("bubble", svg,
              "气泡怎么摊薄（本教程按 (P−1)/(M+P−1) 计算绘制；圆点为 M=8 与 M=16）。"
              "段数 P 越多气泡越重：P=8 时 M=8 的气泡占 46%，把 M 提到 16 才压到 29%——"
              "「**加卡必加 micro-batch**」不是经验主义，是这条双曲线的必然（见 9.4 节）。")


# --------------------------------------------------------------------------- #
# 入口
# --------------------------------------------------------------------------- #
FIGURES = {
    "act": fig_act,
    "gd": fig_gd,
    "overfit": fig_overfit,
    "vanish": fig_vanish,
    "temp": fig_temp,
    "convparams": fig_convparams,
    "diffusion": fig_diffusion,
    "discount": fig_discount,
    "ppo": fig_ppo,
    "scaling": fig_scaling,
    "calib": fig_calib,
    "memory": fig_memory,
    "bubble": fig_bubble,
}

if __name__ == "__main__":
    want = sys.argv[1:]
    for name, fn in FIGURES.items():
        if not want or any(w in name for w in want):
            fn()
    print(f"[fig] 完成，产物目录：{OUT_DIR}")
