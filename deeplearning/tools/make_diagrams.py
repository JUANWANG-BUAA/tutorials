#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""make_diagrams — 《深度学习导论》的结构示意插图（网络结构 / 数据流 / 拓扑）。

与 make_figures.py 同一插图语言（.figure-svg + .diagram-* + --fig-* 令牌），
但内容是**结构图**而非数据图：节点用圆角矩形、连线用箭头、数学用 .diagram-mono。
所有几何在脚本里显式给出，可复现、可微调。

用法：
    python3 tools/make_diagrams.py            # 全部
    python3 tools/make_diagrams.py mlp attn   # 按名筛选
"""

from __future__ import annotations

import os
import sys

OUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "figs_out")

C = {
    "blue": "var(--fig-blue)", "purple": "var(--fig-purple)",
    "green": "var(--fig-green)", "gold": "var(--fig-gold)",
    "red": "var(--fig-red)", "neutral": "var(--fig-neutral)",
}


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


class D:
    """结构图画布：像素坐标直写。"""

    def __init__(self, w, h, title_id, title, desc_id, desc):
        self.w, self.h = w, h
        self.ids = (title_id, title, desc_id, desc)
        self.parts = []
        self.markers = {}

    def marker(self, color="muted", key=None):
        key = key or color
        if key not in self.markers:
            self.markers[key] = True
        return key

    def node(self, x, y, w, h, label, *, color="blue", fill=0.10, mono=False,
             rounded=9, size=None, weight=None, dash=None, label_dy=0.5):
        cls = "diagram-mono" if mono else "diagram-text"
        s = f' font-size="{size}"' if size else ""
        wt = f' font-weight="{weight}"' if weight else ""
        d = f' stroke-dasharray="{dash}"' if dash else ""
        fillc = C.get(color, color) if color in C else color
        self.parts.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rounded}" '
            f'fill="{fillc}" fill-opacity="{fill}" stroke="{fillc}" stroke-width="1.5"{d}/>'
        )
        self.parts.append(
            f'<text class="{cls}" x="{x + w / 2}" y="{y + h * label_dy + 4.5}" text-anchor="middle"{s}{wt}>{label}</text>'
        )

    def plain_node(self, x, y, w, h, label, *, stroke="var(--line-strong)",
                   fill="var(--paper-soft)", mono=False, size=None, dash=None, rx=9):
        cls = "diagram-mono" if mono else "diagram-text"
        s = f' font-size="{size}"' if size else ""
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.parts.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" stroke-width="1.3"{d}/>'
        )
        self.parts.append(
            f'<text class="{cls}" x="{x + w / 2}" y="{y + h / 2 + 4.5}" text-anchor="middle"{s}>{label}</text>'
        )

    def circle(self, cx, cy, label, *, color="blue", r=15, size="14px", mono=True):
        fillc = C.get(color, color)
        self.parts.append(
            f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{fillc}" fill-opacity="0.10" '
            f'stroke="{fillc}" stroke-width="1.6"/>'
        )
        self.parts.append(
            f'<text class="diagram-mono" x="{cx}" y="{cy + 4.5}" text-anchor="middle" font-size="{size}">{label}</text>'
        )

    def arrow(self, x1, y1, x2, y2, *, color="muted", width=1.7, dash=None, key=None):
        k = key or color
        col = C.get(color, color) if color in C else color
        if color == "muted":
            col = "var(--muted)"
        d = f' stroke-dasharray="{dash}"' if dash else ""
        self.parts.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{col}" '
            f'stroke-width="{width}"{d} marker-end="url(#mk-{k})"/>'
        )

    def path(self, d, *, color="muted", width=1.7, dash=None, key=None, fill="none"):
        k = key or color
        col = C.get(color, color) if color in C else color
        if color == "muted":
            col = "var(--muted)"
        da = f' stroke-dasharray="{dash}"' if dash else ""
        self.parts.append(
            f'<path d="{d}" fill="{fill}" stroke="{col}" stroke-width="{width}"{da} marker-end="url(#mk-{k})"/>'
        )

    def text(self, x, y, text, *, color="ink", anchor="start", mono=False,
             size=None, weight=None, note=True):
        cls = "diagram-note" if note else "diagram-text"
        if mono:
            cls = "diagram-mono"
        col = color if color.startswith("var(") else C.get(color, color)
        s = f' font-size="{size}"' if size else ""
        w = f' font-weight="{weight}"' if weight else ""
        self.parts.append(
            f'<text class="{cls}" fill="{col}" x="{x}" y="{y}" text-anchor="{anchor}"{s}{w}>{text}</text>'
        )

    def render(self, caption):
        mk = []
        for k in self.markers:
            col = C.get(k, k) if k in C else (k if k.startswith("var(") else "var(--muted)")
            mk.append(
                f'<marker id="mk-{k}" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto">'
                f'<path d="M0,0 L7,3 L0,6 Z" fill="{col}"/></marker>'
            )
        tid, title, did, desc = self.ids
        svg = (
            f'<svg class="figure-svg" viewBox="0 0 {self.w} {self.h}" xmlns="http://www.w3.org/2000/svg" '
            f'role="img" aria-labelledby="{tid} {did}">\n'
            f'<title id="{tid}">{esc(title)}</title>\n<desc id="{did}">{esc(desc)}</desc>\n'
            f'<defs>{"".join(mk)}</defs>\n' + "\n".join(self.parts) + "\n</svg>"
        )
        os.makedirs(OUT_DIR, exist_ok=True)
        name = self.ids[0].replace("-title", "")
        with open(os.path.join(OUT_DIR, name + ".md"), "w", encoding="utf-8") as f:
            f.write(f"<figure>\n{svg}\n<figcaption>{caption}</figcaption>\n</figure>\n")
        print(f"[diag] {name} 完成")


# --------------------------------------------------------------------------- #
# A. 神经元与多层感知机（lec01 §1.1–1.2）
# --------------------------------------------------------------------------- #
def diag_mlp():
    d = D(900, 330, "fig-mlp-title", "单个神经元与两层多层感知机（含张量形状）",
          "fig-mlp-desc",
          "左侧为一个神经元：输入 x₁…xₙ 各乘权重 wᵢ、加上偏置 b、过激活函数 φ 得到输出。"
          "右侧为两层 MLP：输入层 784 维、隐藏层 128 维（ReLU）、输出层 10 维（softmax），"
          "并标注各步的张量形状。")
    # ── 左：神经元 ──
    d.text(30, 30, "① 一个神经元", weight="700", color="ink")
    for i, y in enumerate([70, 110, 150, 190]):
        d.circle(70, y, f"x{chr(0x2081+i)}", color="neutral", r=16)
        d.arrow(88, y, 150, 130, color="neutral", width=1.3, key="neutral")
        d.text(112, y - (14 if y < 130 else -16), f"w{chr(0x2081+i)}", mono=True, size="12px", color="neutral",
               anchor="middle")
    d.circle(165, 130, "Σ", color="blue", r=17, size="15px")
    d.arrow(184, 130, 235, 130, color="blue", key="blue")
    d.text(209, 122, "+b", mono=True, size="12px", color="blue", anchor="middle")
    d.plain_node(238, 112, 46, 36, "φ", mono=True)
    d.arrow(286, 130, 330, 130, color="blue", key="blue")
    d.text(334, 136, "a", mono=True, size="15px", color="blue")
    d.text(70, 232, "z = Σ wᵢxᵢ + b", mono=True, size="13px", anchor="middle", color="ink")
    d.text(70, 252, "a = φ(z)", mono=True, size="13px", anchor="middle", color="ink")
    d.text(70, 286, "加权求和是线性的；", size="13px", anchor="middle", color="muted")
    d.text(70, 302, "非线性全部来自 φ", size="13px", anchor="middle", color="muted")

    # ── 右：MLP ──
    d.text(430, 30, "② 两层 MLP（一个批 B=32）", weight="700", color="ink")
    xs = 450
    # 输入列
    for i in range(5):
        y = 66 + i * 34
        d.circle(xs, y, "", color="neutral", r=8)
    d.text(xs, 250, "x", mono=True, size="15px", anchor="middle", color="neutral")
    d.text(xs, 272, "32×784", mono=True, size="12px", anchor="middle", color="muted")
    d.arrow(xs + 12, 130, 560, 130, color="neutral", width=1.4, key="neutral")
    d.text(505, 116, "W₁ 784×128", mono=True, size="12px", anchor="middle", color="neutral")
    # 隐藏层
    for i in range(6):
        y = 62 + i * 28
        d.circle(560, y, "", color="blue", r=7)
    d.text(560, 250, "ReLU(z₁)", mono=True, size="14px", anchor="middle", color="blue")
    d.text(560, 272, "32×128", mono=True, size="12px", anchor="middle", color="muted")
    d.arrow(572, 130, 672, 130, color="blue", key="blue")
    d.text(622, 116, "W₂ 128×10", mono=True, size="12px", anchor="middle", color="blue")
    # 输出
    for i in range(4):
        y = 84 + i * 30
        d.circle(672, y, "", color="green", r=7)
    d.text(672, 250, "softmax", mono=True, size="14px", anchor="middle", color="green")
    d.text(672, 272, "32×10", mono=True, size="12px", anchor="middle", color="muted")
    # 右侧注释
    d.text(760, 70, "批维 32 全程不变", size="13px", color="muted")
    d.text(760, 90, "参数量 =", size="13px", color="muted")
    d.text(760, 108, "784·128+128", mono=True, size="12px", color="ink")
    d.text(760, 124, "+128·10+10", mono=True, size="12px", color="ink")
    d.text(760, 140, "= 101,770", mono=True, size="12px", color="blue")
    d.path("M 748 130 C 700 130 700 168 688 172", color="muted", dash="4 3", key="muted")
    d.text(760, 176, "去掉全部 φ：塌缩成", size="13px", color="muted")
    d.text(760, 192, "一个线性变换", size="13px", color="muted")
    d.render(
        "神经元 → MLP（本教程绘）。左：神经元只做「加权求和 + 一次非线性」，φ 是唯一的非线性来源；"
        "右：两层 MLP 的每一步都标注张量形状——**批维 32 全程不变**，形状推演是排错的第一技能"
        "（见 1.1–1.2 节与例 1.2）。")


# --------------------------------------------------------------------------- #
# B. 反向传播计算图（lec01 §1.5）
# --------------------------------------------------------------------------- #
def diag_backprop():
    d = D(900, 340, "fig-backprop-title", "两层网络的前向（蓝）与反向（红）计算图",
          "fig-backprop-desc",
          "计算图自左向右为前向传播：x 经 W₁、b₁ 与 φ 得 a¹，再经 W₂ 与 softmax 得 ŷ 与损失 L。"
          "红色虚线为反向传播：误差信号 δ 自 L 逐层回传，每层用同一份 δ 同时计算参数梯度与上游梯度。")
    d.text(30, 30, "前向：蓝实线　反向：红虚线（δ 为误差信号）", weight="700")
    xs = [60, 210, 360, 510, 660, 810]
    labels = [("x", "neutral"), ("z¹ = xW₁+b₁", "blue"), ("a¹ = φ(z¹)", "blue"),
              ("z² = a¹W₂+b₂", "blue"), ("ŷ = softmax(z²)", "green")]
    for (lab, color), x in zip(labels, xs[:5]):
        d.plain_node(x, 120, 120, 44, lab, mono=True, size="12.5px",
                     stroke=C.get(color, "var(--line-strong)"))
    d.plain_node(xs[5] - 60, 50, 90, 40, "L = CE(ŷ, y)", mono=True, size="12px",
                 stroke=C["red"])
    d.arrow(xs[0] + 120, 142, xs[1] - 2, 142, color="blue", key="blue")
    d.arrow(xs[1] + 120, 142, xs[2] - 2, 142, color="blue", key="blue")
    d.arrow(xs[2] + 120, 142, xs[3] - 2, 142, color="blue", key="blue")
    d.arrow(xs[3] + 120, 142, xs[4] - 2, 142, color="blue", key="blue")
    d.path(f"M {xs[4]+120} 142 C {xs[4]+160} 142 {xs[5]-40} 110 {xs[5]-2} 76",
           color="green", key="green")
    # 反向：一条位于盒顶上方的回传总线（y=96），每个节点处下tick
    d.path(f"M {xs[4]+60} 118 C {xs[4]+60} 96 {xs[4]+50} 92 {xs[4]+30} 92",
           color="red", dash="6 4", key="red")
    d.arrow(xs[4] + 30, 92, xs[0] + 30, 92, color="red", dash="6 4", key="red", width=1.7)
    d.text(xs[4] + 66, 76, "δ² = ŷ − y", mono=True, size="12.5px", color="red")
    for x in xs[1:]:
        d.arrow(x + 30, 92, x + 30, 116, color="red", dash="4 3", key="red", width=1.3)
    d.text((xs[2]+xs[3])/2 + 40, 82, "δ¹ = (δ²W₂ᵀ)⊙φ′(z¹)", mono=True, size="12.5px",
           color="red", anchor="middle")
    # 参数梯度标注
    d.text(xs[2] - 20, 210, "∂L/∂W₂ = a¹ᵀ δ²", mono=True, size="12.5px", color="gold")
    d.path(f"M {xs[3]+60} 144 C {xs[3]+40} 190 {xs[2]+30} 196 {xs[2]+30} 214",
           color="gold", dash="3 3", key="gold")
    d.text(xs[0] + 20, 210, "∂L/∂W₁ = xᵀ δ¹", mono=True, size="12.5px", color="gold")
    d.path(f"M {xs[1]+60} 144 C {xs[1]+30} 180 {xs[0]+70} 194 {xs[0]+70} 214",
           color="gold", dash="3 3", key="gold")
    # 关键注释
    d.plain_node(300, 258, 300, 52, "", fill="var(--paper-soft)")
    d.text(450, 280, "同一份 δ 两个用途：① 继续向上游回传　② 与本层输入相乘得参数梯度",
           size="13px", anchor="middle", color="ink")
    d.text(450, 298, "——复用使全部梯度的代价仅为「一次前向 + 一次反向」",
           size="13px", anchor="middle", color="muted")
    d.render(
        "反向传播的计算图视角（本教程绘）。蓝色为前向、红色虚线为误差信号 "
        "δ 的回传路径、金色为参数梯度的「岔路」。关键在**复用**：每层的 "
        "δ⁽ˡ⁾ 既向上游传递又就地算出 "
        "∂L/∂W⁽ˡ⁾ = a⁽ˡ⁻¹⁾ᵀ·δ⁽ˡ⁾"
        "（定理 1.2），复杂度与层数成线性。")


# --------------------------------------------------------------------------- #
# C. RNN 沿时间展开（lec02 §2.2）
# --------------------------------------------------------------------------- #
def diag_rnn():
    d = D(900, 320, "fig-rnn-title", "RNN 沿时间展开：同一组权重在每一步复用",
          "fig-rnn-desc",
          "将 RNN 的隐状态递推沿时间展开成链：每步读入 xₜ、结合上一步的 hₜ₋₁ 计算新的 hₜ 并输出 yₜ。"
          "所有时间步共享同一组 W_hh、W_xh、W_y；反向传播沿时间连乘每步的雅可比。")
    d.text(30, 32, "展开前：h_t = φ(W_hh h_{t−1} + W_xh x_t)　→　展开后：一条链", weight="700")
    n = 4
    xs = [110 + i * 210 for i in range(n)]
    for i, x in enumerate(xs):
        d.node(x - 52, 110, 104, 56, f"h{chr(0x209A)}".replace("ₐ", ""), color="blue", mono=True) if False else None
        d.plain_node(x - 52, 110, 104, 56, "", stroke=C["blue"], fill="var(--paper-soft)")
        d.text(x, 132, f"h{chr(0x2081+i) if i < 3 else '₃'}", mono=True, size="16px", anchor="middle", color="ink")
        d.text(x, 152, "RNN 单元", size="12px", anchor="middle", color="blue")
        # 输入
        d.arrow(x, 220, x, 172, color="neutral", key="neutral")
        d.circle(x, 236, f"x{chr(0x2081+i) if i < 3 else '₃'}", color="neutral", r=15)
        # 输出
        d.arrow(x, 106, x, 62, color="green", key="green")
        d.text(x + 8, 52, f"y{chr(0x2081+i) if i < 3 else '₃'}", mono=True, size="13px", color="green")
        # 隐状态传递
        if i < n - 1:
            d.arrow(x + 56, 138, x + 210 - 58, 138, color="blue", width=2.2, key="blue")
    # 共享权重标注
    d.path("M %d 196 C %d 240 %d 240 %d 196" % (xs[0], xs[0], xs[1], xs[1]),
           color="gold", dash="4 3", key="gold")
    d.path("M %d 196 C %d 240 %d 240 %d 196" % (xs[1], xs[1], xs[2], xs[2]),
           color="gold", dash="4 3", key="gold")
    d.path("M %d 196 C %d 240 %d 240 %d 196" % (xs[2], xs[2], xs[3], xs[3]),
           color="gold", dash="4 3", key="gold")
    d.text((xs[0] + xs[1]) / 2, 262, "同一组 (W_hh, W_xh, W_y)", mono=True, size="12.5px",
           anchor="middle", color="gold")
    # 初始隐状态
    d.arrow(xs[0] - 70, 138, xs[0] - 56, 138, color="blue", key="blue")
    d.text(xs[0] - 74, 142, "h₀", mono=True, size="13px", anchor="end", color="blue")
    # BPTT 警示
    d.plain_node(560, 20, 310, 40, "", fill="var(--paper-soft)")
    d.text(715, 38, "BPTT：∂L/∂h₀ = 连乘 ∏ 雅可比 → 梯度消失 / 爆炸（见下图）",
           size="13px", anchor="middle", color="red")
    d.render(
        "RNN 的「展开」视角（本教程绘）。折叠时是一**个**带反馈的单元；展开后是一**条**共享权重的链。"
        "序列建模的能力（状态记忆）与缺陷（沿时间的连乘雅可比，即 BPTT）都来自这条链——"
        "这正是 2.2 节梯度消失与 2.3 节门控改造的出发点。")


# --------------------------------------------------------------------------- #
# D. LSTM 单元（lec02 §2.3）
# --------------------------------------------------------------------------- #
def diag_lstm():
    d = D(900, 400, "fig-lstm-title", "LSTM 单元：三门与细胞状态的加法通道",
          "fig-lstm-desc",
          "LSTM 单元结构：遗忘门 f、输入门 i、输出门 o 为 σ 门控；细胞状态 c 沿顶部加法通道传递"
          "（c_t = f⊙c_{t−1} + i⊙c̃）；h_t = o⊙tanh(c_t)。")
    d.text(30, 30, "细胞状态 c：一条「梯度高速公路」（绿）", weight="700", color="green")
    # ── 顶部加法通道 ──
    d.arrow(80, 70, 760, 70, color="green", width=3.2, key="green")
    d.text(70, 75, "cₜ₋₁", mono=True, size="14px", anchor="end", color="green")
    d.text(778, 75, "cₜ", mono=True, size="14px", color="green")
    d.circle(330, 70, "×", color="gold", r=15, size="16px")
    d.circle(610, 70, "+", color="blue", r=15, size="16px")
    d.text(300, 44, "f ⊙ cₜ₋₁", mono=True, size="12.5px", anchor="end", color="gold")
    # ── 左：输入堆叠 ──
    d.plain_node(60, 180, 150, 90, "", stroke="var(--line-strong)")
    d.text(135, 212, "[ hₜ₋₁ ; xₜ ]", mono=True, size="14px", anchor="middle", color="ink")
    d.text(135, 236, "拼接输入", size="12px", anchor="middle", color="muted")
    # ── 门控列 ──
    gates = [
        ("f = σ(W_f·[h,x]+b_f)", 100, "gold", "遗忘门"),
        ("i = σ(W_i·[h,x]+b_i)", 160, "blue", "输入门"),
        ("c̃ = tanh(W_c·[h,x]+b_c)", 220, "green", "候选记忆"),
        ("o = σ(W_o·[h,x]+b_o)", 300, "purple", "输出门"),
    ]
    for label, y, color, note in gates:
        d.node(240, y, 200, 38, label, color=color, mono=True, size="11.5px")
        d.text(452, y + 24, note, size="12px", color=color)
        d.arrow(212, 225, 238, y + 19, color=color, key=color, width=1.3)
    # f 上行到 ×
    d.arrow(330, 100, 330, 88, color="gold", key="gold", width=1.6)
    # i 与 c̃ 汇到 ⊗ 再上 + 
    d.circle(505, 210, "⊗", color="blue", r=14, size="14px")
    d.arrow(440, 179, 493, 202, color="blue", key="blue", width=1.4)
    d.arrow(440, 239, 493, 218, color="green", key="green", width=1.4)
    d.path("M 517 202 C 570 200 604 150 610 88", color="blue", key="blue", width=1.6)
    d.text(560, 172, "i ⊙ c̃", mono=True, size="12.5px", color="blue")
    # ── 输出支路 ──
    d.node(590, 150, 130, 38, "tanh(cₜ)", color="green", mono=True, size="13px")
    d.path("M 700 76 C 700 112 688 132 660 148", color="green", key="green", width=1.6)
    d.circle(752, 169, "⊗", color="purple", r=14, size="14px")
    d.arrow(720, 169, 738, 169, color="green", key="green", width=1.6)
    d.path("M 440 319 C 600 319 700 260 745 183", color="purple", key="purple", width=1.6)
    d.text(600, 292, "o", mono=True, size="13px", color="purple")
    d.arrow(766, 169, 800, 169, color="purple", key="purple", width=2.0)
    d.text(806, 152, "hₜ =", mono=True, size="12.5px", color="purple")
    d.text(806, 172, "o⊙tanh(cₜ)", mono=True, size="12.5px", color="purple")
    # ── 底部要点 ──
    d.plain_node(60, 358, 780, 34, "", fill="var(--paper-soft)")
    d.text(450, 374, "关键在顶部的加法通道：cₜ = f⊙cₜ₋₁ + i⊙c̃ —— 梯度对 cₜ₋₁ 的雅可比是 f≈1，不随步数连乘衰减",
           size="12.5px", anchor="middle", color="ink")
    d.render(
        "LSTM 单元（本教程绘）。三个 σ 门（金=遗忘 f、蓝=输入 i、紫=输出 o）"
        "决定信息去留；顶部绿色的细胞状态 c 是一条**加法**通道——cₜ = f⊙cₜ₋₁ + i⊙c̃ "
        "中，梯度对 cₜ₋₁ 的雅可比就是 f≈1，连乘不衰减，长程记忆由此而来。")


# --------------------------------------------------------------------------- #
# E. 缩放点积注意力（lec02 §2.4–2.5）
# --------------------------------------------------------------------------- #
def diag_attn():
    d = D(900, 350, "fig-attn-title", "缩放点积注意力：一只头的数据流与形状",
          "fig-attn-desc",
          "注意力数据流：Q 与 Kᵀ 相乘得 T×T 的相关度矩阵，除以 √d_k 后逐行 softmax 得权重，"
          "再右乘 V 得输出；多头即并排 H 份、最后拼接线性变换。")
    d.text(30, 30, "单头：Attention(Q, K, V) = softmax(QKᵀ/√d_k)·V", weight="700")
    # Q K V 三输入
    d.node(60, 66, 120, 44, "Q：想找什么", color="blue", mono=True, size="13px")
    d.node(60, 170, 120, 44, "Kᵀ：被匹配的标签", color="purple", mono=True, size="12.5px")
    d.node(560, 250, 120, 44, "V：被取走的内容", color="green", mono=True, size="12.5px")
    # QK^T
    d.arrow(182, 88, 250, 128, color="blue", key="blue")
    d.arrow(182, 192, 250, 152, color="purple", key="purple")
    d.node(252, 118, 130, 48, "QKᵀ", color="neutral", mono=True, size="15px")
    d.text(317, 190, "T_q×T_k", mono=True, size="11.5px", anchor="middle", color="muted")
    # scale
    d.arrow(384, 142, 430, 142, color="neutral", key="neutral")
    d.node(432, 118, 96, 48, "÷ √d_k", color="gold", mono=True, size="14px")
    d.text(480, 190, "防 softmax 饱和", size="12px", anchor="middle", color="gold")
    # softmax
    d.arrow(530, 142, 570, 142, color="gold", key="gold")
    d.node(572, 118, 110, 48, "softmax（按行）", color="red", mono=True, size="12px")
    # 权重 × V
    d.arrow(684, 142, 730, 190, color="red", key="red")
    d.arrow(682, 272, 736, 252, color="green", key="green")
    d.node(738, 196, 130, 56, "权重 · V", color="green", mono=True, size="14px")
    d.text(803, 276, "输出", mono=True, size="13px", anchor="middle", color="green")
    d.text(803, 292, "T_q×d_v", mono=True, size="11.5px", anchor="middle", color="muted")
    # 多头注释
    d.plain_node(60, 316, 400, 40, "", fill="var(--paper-soft)")
    d.text(260, 334, "多头 = 并排 H 份（各自 d_k = d/H），拼接后线性变换——"
                     "不同头看不同子空间", size="12.5px", anchor="middle", color="ink")
    d.plain_node(500, 316, 340, 40, "", fill="var(--paper-soft)")
    d.text(670, 334, "复杂度 O(T²·d)：T 加倍，算力×4 —— 长序列的平方瓶颈（2.5 节）",
           size="12.5px", anchor="middle", color="ink")
    d.render(
        "缩放点积注意力的数据流（本教程绘，形状以 B×T 序列为例）。三路输入各司其职："
        "Q 提问、K 应答、V 交货；÷√d_k 防止点积方差 ∝ d_k 把 softmax 推入饱和区"
        "（例 2.2）；多头即并排若干份、各看一个子空间。平方复杂度 O(T²d) 是 Transformer "
        "长序列瓶颈的根源。")


# --------------------------------------------------------------------------- #
# F. 卷积运算（lec03 §3.2）
# --------------------------------------------------------------------------- #
def diag_conv():
    d = D(900, 380, "fig-conv-title", "二维卷积：滑窗 · 步幅与填充 · 输出尺寸公式",
          "fig-conv-desc",
          "左侧为 7×7 输入特征图上 3×3 卷积核（步幅 2、填充 1）滑动的示意；高亮一个输出位置对应的"
          "感受窗口。右侧给出输出尺寸公式与参数量公式，并代入本例。")
    cs = 26  # cell size
    ox, oy = 70, 70

    def grid(x0, y0, n, m, *, hot=None, hotfill=None):
        for i in range(n):
            for j in range(m):
                hotc = hot and (i, j) in hot
                fill = hotfill if hotc else "var(--paper-soft)"
                d.parts.append(
                    f'<rect x="{x0 + j * cs}" y="{y0 + i * cs}" width="{cs}" height="{cs}" '
                    f'fill="{fill}" stroke="var(--line-strong)" stroke-width="1"/>'
                )

    # 输入 7×7，填充圈
    n = 7
    # padding 边框（pad=1 → 9×9 画布上的 7×7 内容）
    px0, py0 = ox - cs, oy - cs
    d.parts.append(
        f'<rect x="{px0}" y="{py0}" width="{cs * 9}" height="{cs * 9}" fill="none" '
        f'stroke="{C["gold"]}" stroke-width="1.4" stroke-dasharray="6 4"/>'
    )
    hot = {(2, 2), (2, 3), (2, 4), (3, 2), (3, 3), (3, 4), (4, 2), (4, 3), (4, 4)}
    grid(ox, oy, n, n, hot=hot, hotfill=C["blue"])
    d.parts.append(
        f'<rect x="{ox + 2 * cs}" y="{oy + 2 * cs}" width="{cs * 3}" height="{cs * 3}" '
        f'fill="none" stroke="{C["blue"]}" stroke-width="2.4"/>'
    )
    d.text(ox + 3.5 * cs, oy - 40, "输入 7×7（金色虚线 = padding=1）", size="13px",
           anchor="middle", color="gold")
    d.text(px0, oy + 9.6 * cs, "一次窗口 = 输出的一个像素", size="12.5px", anchor="middle", color="blue")
    # 核
    kx, ky = 420, 90
    grid(kx, ky, 3, 3, hot={(i, j) for i in range(3) for j in range(3)}, hotfill=C["purple"])
    d.text(kx + 1.5 * cs, ky - 16, "卷积核 3×3", size="13px", anchor="middle", color="purple")
    d.text(kx + 1.5 * cs, ky + 3 * cs + 18, "逐位置相乘再求和", size="12.5px",
           anchor="middle", color="muted")
    # 乘号
    d.text(kx - 34, ky + 1.5 * cs, "×", mono=True, size="20px", anchor="middle", color="muted")
    d.text(kx - 34, ky + 2.2 * cs, "滑动 s=2", size="12px", anchor="middle", color="muted")
    # 输出 4×4
    gx, gy = 620, 100
    grid(gx, gy, 4, 4, hot={(1, 1)}, hotfill=C["green"])
    d.parts.append(f'<rect x="{gx + cs}" y="{gy + cs}" width="{cs}" height="{cs}" '
                   f'fill="none" stroke="{C["green"]}" stroke-width="2.4"/>')
    d.text(gx + 2 * cs, gy - 16, "输出 4×4", size="13px", anchor="middle", color="green")
    # 箭头
    d.arrow(kx + 3 * cs + 14, ky + 1.5 * cs, gx - 16, gy + 2 * cs, color="green", key="green", width=2)
    # 公式面板
    d.plain_node(420, 240, 420, 116, "", fill="var(--paper-soft)", stroke="var(--line-strong)")
    d.text(630, 264, "W_out = ⌊(W_in − k + 2p)/s⌋ + 1", mono=True, size="14px",
           anchor="middle", color="ink")
    d.text(630, 290, "= ⌊(7 − 3 + 2·1)/2⌋ + 1 = 4", mono=True, size="14px", anchor="middle", color="green")
    d.text(630, 316, "参数量 = k·k·C_in·C_out + C_out", mono=True, size="13px",
           anchor="middle", color="ink")
    d.text(630, 340, "本例（C=1）：3·3·1·1 + 1 = 10", mono=True, size="12.5px",
           anchor="middle", color="purple")
    d.render(
        "卷积的三个旋钮（本教程绘）：**核 k、步幅 s、填充 p**。蓝色高亮是当前感受窗口——"
        "它逐位置滑动（s=2 即每步跳两格），每个窗口给输出的一个像素（绿色）；金色虚线是 "
        "p=1 的补零。代入公式：⌊(7−3+2)/2⌋+1 = 4。能当场算出这一格，3.2 节就算过关。")


# --------------------------------------------------------------------------- #
# G. 普通块 vs 残差块（lec03 §3.4）
# --------------------------------------------------------------------------- #
def diag_resnet():
    d = D(900, 300, "fig-resnet-title", "普通块与残差块：恒等捷径让梯度直通",
          "fig-resnet-desc",
          "左：普通块把输入完全经过两层变换；右：残差块额外引入恒等捷径，输出 y = F(x) + x。"
          "反向传播时梯度可经加法直接流回输入，深网络因此可训练。")
    # 左：普通块
    d.text(80, 34, "普通块：y = F(x)", weight="700", color="red")
    d.plain_node(90, 90, 80, 44, "x", mono=True, size="15px")
    d.arrow(172, 112, 232, 112, color="red", key="red")
    d.node(234, 90, 130, 44, "层₁ → ReLU", color="red", mono=True, size="13px")
    d.arrow(366, 112, 426, 112, color="red", key="red")
    d.node(428, 90, 130, 44, "层₂", color="red", mono=True, size="13px")
    d.arrow(560, 112, 610, 112, color="red", key="red")
    d.text(620, 117, "y", mono=True, size="15px")
    d.text(350, 176, "梯度必须穿过两层变换", size="13px", anchor="middle", color="muted")
    d.text(350, 194, "（深了就衰减 → 退化问题）", size="13px", anchor="middle", color="muted")
    # 右：残差块
    d.text(80, 234, "", weight="700")
    # 下半部
    d.plain_node(90, 70 + 130, 80, 44, "x", mono=True, size="15px") if False else None
    # 直接在下半画布（y 基准 210）
    base = 210
    d.plain_node(90, base - 22, 80, 44, "x", mono=True, size="15px")
    d.arrow(172, base, 232, base, color="blue", key="blue")
    d.node(234, base - 22, 130, 44, "F(x)：两层", color="blue", mono=True, size="13px")
    d.arrow(366, base, 426, base, color="blue", key="blue")
    d.circle(446, base, "+", color="green", r=15, size="17px")
    # 捷径
    d.path(f"M 130 {base-24} C 130 {base-86} 400 {base-86} 446 {base-18}",
           color="green", dash="6 4", key="green", width=2)
    d.text(288, base - 92, "恒等捷径（skip connection）", size="13px", anchor="middle", color="green")
    d.arrow(462, base, 512, base, color="green", key="green")
    d.text(522, base + 5, "y = F(x) + x", mono=True, size="14.5px", color="green")
    d.text(470, base + 44, "∂y/∂x = ∂F/∂x + I：多了恒等项，", size="13px", anchor="middle", color="muted")
    d.text(470, base + 62, "梯度可「抄近路」直通浅层", size="13px", anchor="middle", color="muted")
    d.render(
        "残差连接（本教程绘）。上：普通块的梯度必须穿过每层变换，深层连乘后衰减，网络越深"
        "训练误差反而越高（**退化**，不是过拟合）；下：捷径 x 直接汇入输出，"
        "∂y/∂x = ∂F/∂x + I "
        "多了个恒等项——梯度永远有通路，上百层的网络由此可训练（3.4 节）。")


# --------------------------------------------------------------------------- #
# H. AE 与 VAE（lec04 §4.2–4.3）
# --------------------------------------------------------------------------- #
def diag_vae():
    d = D(900, 330, "fig-vae-title", "自编码器与变分自编码器：从「压缩」到「生成」",
          "fig-vae-desc",
          "上：普通自编码器把 x 压成确定性的码 z 再重建，潜空间无结构、不能采样；"
          "下：VAE 编码为分布 N(μ,σ²)，经重参数化 z = μ + σ⊙ε 采样，训练同时约束潜空间接近标准高斯，"
          "因此可以从先验采样、解码生成新样本。")
    # 上：AE
    d.text(60, 34, "① 自编码器：确定性的压缩码（只能重建）", weight="700", color="neutral")
    y = 78
    d.node(70, y, 110, 44, "编码器 q(z|x)", color="neutral", mono=True, size="12.5px")
    d.arrow(182, y + 22, 268, y + 22, color="neutral", key="neutral")
    d.plain_node(270, y, 56, 44, "z", mono=True, size="16px", stroke=C["neutral"])
    d.text(298, y - 12, "一个点", size="12px", anchor="middle", color="muted")
    d.arrow(328, y + 22, 414, y + 22, color="neutral", key="neutral")
    d.node(416, y, 110, 44, "解码器 p(x|z)", color="neutral", mono=True, size="12.5px")
    d.arrow(528, y + 22, 574, y + 22, color="neutral", key="neutral")
    d.text(584, y + 27, "x̂", mono=True, size="15px", color="neutral")
    d.text(330, y + 66, "损失 = 重建误差（z 之间无结构 → 随机采样的 z 解码出噪声）",
           size="12.5px", anchor="middle", color="muted")
    # 下：VAE
    d.text(60, 208, "② VAE：分布式的潜空间 + 重参数化（可以生成）", weight="700", color="blue")
    b = 252
    d.node(70, b, 110, 44, "编码器 q(z|x)", color="blue", mono=True, size="12.5px")
    d.arrow(182, b + 22, 216, b + 22, color="blue", key="blue")
    d.plain_node(218, b, 76, 44, "μ, σ", mono=True, size="14px", stroke=C["blue"])
    # ε
    d.circle(348, b - 24, "ε~N(0,I)", color="purple", r=30, size="10.5px")
    d.arrow(348, b + 4, 348, b + 14, color="purple", key="purple")
    d.circle(348, b + 22, "⊕", color="purple", r=13, size="13px")
    d.arrow(296, b + 22, 333, b + 22, color="blue", key="blue")
    d.arrow(362, b + 22, 398, b + 22, color="purple", key="purple")
    d.plain_node(400, b, 56, 44, "z", mono=True, size="16px", stroke=C["purple"])
    d.text(428, b - 12, "μ+σ⊙ε", size="12px", anchor="middle", color="purple")
    d.arrow(458, b + 22, 494, b + 22, color="purple", key="purple")
    d.node(496, b, 100, 44, "解码器", color="green", mono=True, size="13px")
    d.arrow(598, b + 22, 634, b + 22, color="green", key="green")
    d.text(644, b + 27, "x̂", mono=True, size="15px", color="green")
    # KL 约束
    d.path(f"M 256 {b-2} C 256 {b-46} 620 {b-46} 620 {b-2}", color="gold", dash="5 4", key="gold")
    d.text(438, b - 54, "KL(q(z|x) ‖ N(0, I))：把潜空间拉向标准高斯", size="12.5px",
           anchor="middle", color="gold")
    # 生成路径
    d.path(f"M 760 96 C 780 96 780 {b-20} 760 {b+6}", color="green", dash="4 3", key="green")
    d.circle(760, b + 24, "z~N", color="green", r=17, size="10.5px")
    d.arrow(744, b + 24, 600, b + 24, color="green", dash="4 3", key="green")
    d.text(700, b + 44, "生成：从先验采样", size="12.5px", anchor="middle", color="green")
    d.text(470, 322, "ELBO = 重建项 − KL 项；重参数化把随机性搬进与参数无关的 ε，梯度得以穿过采样",
           size="12.5px", anchor="middle", color="muted")
    d.render(
        "从自编码器到 VAE（本教程绘）。上：AE 的码是**一个点**，潜空间无结构——重建可以、生成不行；"
        "下：VAE 把编码变成分布并用重参数化 z = μ + σ⊙ε 让梯度穿过采样，KL 项把潜空间拉向 N(0, I)——于是"
        "「从先验采样 → 解码」成为合法的生成路径（4.2–4.3 节）。")


# --------------------------------------------------------------------------- #
# I. 智能体-环境循环（lec05 §5.1–5.2）
# --------------------------------------------------------------------------- #
def diag_mdp():
    d = D(900, 300, "fig-mdp-title", "智能体与环境：马尔可夫决策过程的交互循环",
          "fig-mdp-desc",
          "智能体观察状态 s、依策略 π 选动作 a；环境返回奖励 r 并转移到新状态 s′。"
          "学习的目标是最大化折扣累积回报 G = Σ γᵏ r。")
    # 环境（大圆）与智能体
    d.node(300, 70, 200, 160, "环境 Environment", color="green", mono=True, size="15px", label_dy=0.18)
    d.text(400, 190, "转移 P(s′|s,a)　奖励 r(s,a)", size="12.5px", anchor="middle", color="green")
    d.node(640, 70, 160, 160, "智能体 Agent", color="blue", mono=True, size="15px", label_dy=0.18)
    d.text(720, 190, "策略 π(a|s)", size="13px", anchor="middle", color="blue")
    # 动作 a（上弧：agent → env）
    d.path("M 636 76 C 560 20 440 20 366 76", color="blue", key="blue", width=2.2)
    d.text(500, 34, "动作 aₜ", mono=True, size="13.5px", anchor="middle", color="blue")
    # 状态+奖励（下弧：env → agent）
    d.path("M 366 224 C 440 282 560 282 636 224", color="green", key="green", width=2.2)
    d.text(500, 284, "状态 sₜ₊₁ 与奖励 rₜ₊₁", mono=True, size="13.5px", anchor="middle", color="green")
    # 侧注
    d.plain_node(40, 96, 200, 120, "", fill="var(--paper-soft)")
    d.text(140, 120, "没有标签，只有奖励", size="13px", anchor="middle", color="ink")
    d.text(140, 142, "G = Σ γᵏ·rₜ₊ₖ₊₁", mono=True, size="12.5px", anchor="middle", color="ink")
    d.text(140, 164, "γ<1：未来的折扣", size="12.5px", anchor="middle", color="muted")
    d.text(140, 186, "⇒ 探索与利用的张力", size="12.5px", anchor="middle", color="muted")
    d.render(
        "强化学习的世界观（本教程绘）：**循环，而非数据集**。智能体只能通过「动作 → 观察 + 奖励」"
        "影响与感知环境；监督信号弱化为标量奖励 r，目标变成最大化折扣回报 "
        "Gₜ = Σ γᵏ·rₜ₊ₖ（5.1–5.2 节）。探索与利用的矛盾、信用分配难题，"
        "都源自这个循环里「反馈既稀疏又延迟」。")


# --------------------------------------------------------------------------- #
# J. 三种并行（lec09 §9.2–9.4）
# --------------------------------------------------------------------------- #
def diag_parallel():
    d = D(900, 470, "fig-parallel-title", "三种并行：数据 / 张量 / 流量线",
          "fig-parallel-desc",
          "上左：数据并行——每卡一份完整模型、各自处理数据分片，梯度 All-Reduce 同步；上右：张量并行——"
          "把单层权重矩阵按列切到多卡、层内通信；下：流水线并行——按层分段、micro-batch 流动，"
          "甘特图显示 GPipe 调度的前向（绿）/反向（金）与首尾的气泡（红影）。")
    # ── 上左：数据并行 ──
    d.text(210, 30, "① 数据并行：切数据", weight="700", color="blue", anchor="middle")
    for i in range(3):
        y = 52 + i * 78
        d.plain_node(90, y, 130, 48, "模型（同一份）", mono=True, size="11.5px", stroke=C["blue"])
        d.text(250, y + 28, f"数据分片 {i+1}", size="12px", color="muted")
        d.arrow(155 + 0, y, 155, y - 5, color="blue", key="blue", dash="4 3")
    d.parts.append(
        f'<path d="M 90 208 L 230 208" stroke="{C["blue"]}" stroke-width="2" fill="none" '
        'stroke-dasharray="7 4" marker-end="url(#mk-blue)"/>'
    )
    d.text(160, 228, "梯度 All-Reduce 同步", size="12px", anchor="middle", color="blue")
    d.text(210, 258, "通信量与批大小无关；批大小 ∝ 卡数", size="12px", anchor="middle", color="muted")
    d.plain_node(60, 244, 300, 44, "", fill="var(--paper-soft)")

    # ── 上右：张量并行 ──
    d.text(660, 30, "② 张量并行：切单层", weight="700", color="purple", anchor="middle")
    mx, my = 520, 56
    for i in range(4):
        d.parts.append(
            f'<rect x="{mx + i * 30}" y="{my}" width="28" height="130" fill="{C["purple"]}" '
            f'fill-opacity="0.18" stroke="{C["purple"]}"/>'
        )
        d.text(mx + 14 + i * 30, my - 10, f"G{chr(0x2081+i)}", mono=True, size="11px",
               anchor="middle", color="purple")
    d.text(mx + 60, my + 152, "Y = XW → [XW₁ | XW₂ | XW₃ | XW₄]", mono=True, size="11.5px",
           anchor="middle", color="ink")
    d.plain_node(480, 244, 360, 44, "", fill="var(--paper-soft)")
    d.text(660, 262, "每卡持一列切片，层内即需通信", size="12px", anchor="middle", color="ink")
    d.text(660, 280, "→ 张量并行要放在 NVLink 域内", size="12px", anchor="middle", color="muted")

    # ── 下：流水线并行（GPipe 甘特图） ──
    d.text(450, 330, "③ 流水线并行：切层（GPipe 调度，P=4 段 × M=4 个 micro-batch）",
           weight="700", color="green", anchor="middle")
    M, P = 4, 4
    cw, chh = 54, 34
    gx, gy = 90, 352
    total_cols = 2 * M + P - 1  # 11
    for s_ in range(P):
        y = gy + s_ * (chh + 6)
        d.text(gx - 14, y + chh / 2 + 4, f"段{s_+1}", size="12px", anchor="end", color="green")
        # F(s,m) at col m+s
        for m in range(M):
            col = m + s_
            x = gx + col * cw
            d.parts.append(
                f'<rect x="{x+1}" y="{y}" width="{cw-3}" height="{chh}" rx="4" fill="{C["green"]}" '
                f'fill-opacity="0.22" stroke="{C["green"]}" stroke-width="1.1"/>'
            )
            d.text(x + cw / 2, y + chh / 2 + 4, f"F{m+1}", size="10.5px", anchor="middle", color="green")
        # B(s,m)：全部前向排完后反向，col = (M+P-1) + (M-1-m) + (P-1-s)
        for m in range(M):
            col = (M + P - 1) + (M - 1 - m) + (P - 1 - s_)
            x = gx + col * cw
            d.parts.append(
                f'<rect x="{x+1}" y="{y}" width="{cw-3}" height="{chh}" rx="4" fill="{C["gold"]}" '
                f'fill-opacity="0.28" stroke="{C["gold"]}" stroke-width="1.1"/>'
            )
            d.text(x + cw / 2, y + chh / 2 + 4, f"B{m+1}", size="10.5px", anchor="middle", color="gold")
    # 气泡阴影：上三角（段1 的前段等待）与下三角（段4 的尾部等待）
    bub = C["red"]
    for s_ in range(P):
        y = gy + s_ * (chh + 6)
        first_f = s_ * cw
        if s_ > 0:
            d.parts.append(
                f'<rect x="{gx}" y="{y}" width="{first_f}" height="{chh}" fill="{bub}" '
                f'fill-opacity="0.12" stroke="none"/>'
            )
    for s_ in range(P):
        y = gy + s_ * (chh + 6)
        last_b_col = (M + P - 1) + (M - 1) + (P - 1 - s_)
        tail_x = gx + (last_b_col + 1) * cw
        end_x = gx + ((M + P - 1) + (M - 1) + (P - 1) + 1) * cw  # 整体右端
        if tail_x < end_x:
            d.parts.append(
                f'<rect x="{tail_x}" y="{y}" width="{end_x - tail_x}" height="{chh}" fill="{bub}" '
                f'fill-opacity="0.12" stroke="none"/>'
            )
    # 时间轴
    axis_y = gy + P * (chh + 6) + 6
    d.arrow(gx, axis_y, gx + ((M + P - 1) + (M - 1) + P) * cw, axis_y, color="muted", key="muted", width=1.2)
    d.text(gx + ((M + P - 1) + (M - 1) + P) * cw, axis_y + 16, "时间 →", size="12px", anchor="end", color="muted")
    d.text(140, axis_y + 16, "红影 = 气泡（fill / drain）", size="12px", color="red")
    d.text(450, axis_y + 36, "气泡占比 (P−1)/(M+P−1)：加大 M 或改用 1F1B 调度摊薄",
           mono=True, size="12px", anchor="middle", color="red")
    d.render(
        "三种并行的切法（本教程绘）。**数据并行**切数据、模型每卡全份、梯度 All-Reduce 同步；"
        "**张量并行**切单层权重（列切 / 行切成对）、层内就要通信；**流水线并行**按层分段、"
        "micro-batch 流动——甘特图中绿色前向与金色反向之间的红色空档即**气泡**，"
        "占比 (P−1)/(M+P−1)，靠加大 M 或 1F1B 调度摊薄（9.2–9.4 节）。")


def total_cols_extra(M, P):
    return (M + P - 1) + (M - 1) + (P - 1) + 1


DIAGRAMS = {
    "mlp": diag_mlp,
    "backprop": diag_backprop,
    "rnn": diag_rnn,
    "lstm": diag_lstm,
    "attn": diag_attn,
    "conv": diag_conv,
    "resnet": diag_resnet,
    "vae": diag_vae,
    "mdp": diag_mdp,
    "parallel": diag_parallel,
}

if __name__ == "__main__":
    want = sys.argv[1:]
    for name, fn in DIAGRAMS.items():
        if not want or any(w in name for w in want):
            fn()
    print(f"[diag] 完成，产物目录：{OUT_DIR}")
