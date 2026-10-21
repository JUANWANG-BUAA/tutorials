#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成第 10 讲（插值）配套插图。

输出到 numerical/src/assets/lectures/：
  lec10-fig-lagrange-basis.png   拉格朗日基函数的 δ 性质
  lec10-fig-exp-error.png        e^x 的线性/二次插值与误差
  lec10-fig-runge.png            Runge 现象：等距 vs Chebyshev
  lec10-fig-hermite.png          Hermite 三次 vs 拉格朗日插值的误差
  lec10-fig-lebesgue.png         等距与 Chebyshev 节点的 Lebesgue 函数

运行：python3 numerical/tools/make_lec10_figures.py
"""
from __future__ import annotations

import os

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

plt.rcParams.update(
    {
        "font.family": ["Songti SC", "STSong", "Noto Serif CJK SC", "DejaVu Serif"],
        "font.size": 11,
        "axes.unicode_minus": False,
        "mathtext.fontset": "cm",
        "figure.facecolor": "white",
        "axes.facecolor": "white",
        "savefig.facecolor": "white",
    }
)

OUT = os.path.join(os.path.dirname(__file__), "..", "src", "assets", "lectures")
os.makedirs(OUT, exist_ok=True)

BLUE = "#2f5d8a"
RED = "#b23a3a"
GREEN = "#3f7d52"
GOLD = "#a8791f"
GRAY = "#666666"


def lagrange_eval(nodes, vals, x):
    x = np.asarray(x, dtype=float)
    out = np.zeros_like(x)
    for i, (xi, fi) in enumerate(zip(nodes, vals)):
        li = np.ones_like(x)
        for j, xj in enumerate(nodes):
            if j != i:
                li *= (x - xj) / (xi - xj)
        out += fi * li
    return out


def lagrange_basis(nodes, i, x):
    x = np.asarray(x, dtype=float)
    li = np.ones_like(x)
    for j, xj in enumerate(nodes):
        if j != i:
            li *= (x - xj) / (nodes[i] - xj)
    return li


def fig_lagrange_basis():
    nodes = np.array([0.0, 1.0, 2.0, 3.0])
    xs = np.linspace(-0.25, 3.25, 1200)
    fig, ax = plt.subplots(figsize=(8.0, 4.5))
    colors = [BLUE, RED, GREEN, GOLD]
    for i in range(4):
        ax.plot(xs, lagrange_basis(nodes, i, xs), color=colors[i], lw=2.0,
                label=fr"$\ell_{i}(x)$")
        ax.plot([nodes[i]], [1], "o", color=colors[i], ms=6, zorder=5)
        ax.plot(nodes[np.arange(4) != i], np.zeros(3), "o", mfc="white",
                mec=colors[i], ms=5, zorder=5)
    ax.axhline(0, color="black", lw=0.8)
    ax.axhline(1, color=GRAY, lw=0.8, ls=":")
    ax.set_xlim(-0.25, 3.25)
    ax.set_ylim(-0.35, 1.25)
    ax.set_xlabel("$x$")
    ax.set_ylabel(r"$\ell_i(x)$")
    ax.set_xticks(nodes)
    ax.set_yticks([0, 1])
    ax.legend(ncol=4, frameon=False, loc="upper center", bbox_to_anchor=(0.5, 1.12))
    ax.set_title(r"拉格朗日基函数：$\ell_i(x_j)=\delta_{ij}$", pad=28)
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "lec10-fig-lagrange-basis.png"), dpi=200)
    plt.close(fig)


def fig_exp_error():
    f = np.exp
    xs = np.linspace(0, 1, 4001)
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10.6, 4.4))
    ax1.plot(xs, f(xs), color="black", lw=1.8, label=r"$f(x)=e^x$")
    for nodes, color, label in [
        ([0.0, 1.0], BLUE, "线性（2 点）"),
        ([0.0, 0.5, 1.0], RED, "二次（3 点）"),
    ]:
        ax1.plot(xs, lagrange_eval(nodes, f(np.array(nodes)), xs), color=color,
                 lw=1.6, label=label)
    ax1.set_xlabel("$x$")
    ax1.set_ylabel("$y$")
    ax1.legend(frameon=False, loc="upper left")
    ax1.set_title("函数与插值多项式", fontsize=11)
    for s in ("top", "right"):
        ax1.spines[s].set_visible(False)

    lin = np.abs(lagrange_eval([0.0, 1.0], f(np.array([0.0, 1.0])), xs) - f(xs))
    quad = np.abs(lagrange_eval([0.0, 0.5, 1.0], f(np.array([0.0, 0.5, 1.0])), xs) - f(xs))
    ax2.semilogy(xs, lin, color=BLUE, lw=1.8, label=r"$|R_1|$，max $=0.212$")
    ax2.semilogy(xs, quad, color=RED, lw=1.8, label=r"$|R_2|$，max $=0.0144$")
    ax2.axhline(np.e / 8, color=BLUE, ls="--", lw=1.0,
                label=r"界 $M_2h^2/8=0.340$")
    ax2.axhline(np.e / 12, color=RED, ls="--", lw=1.0,
                label=r"界 $4Ch^3=0.227$")
    ax2.set_ylim(1e-4, 1)
    ax2.set_xlabel("$x$")
    ax2.set_ylabel("误差")
    ax2.legend(frameon=False, fontsize=8.5, loc="lower center")
    ax2.set_title("误差与误差界（对数坐标）", fontsize=11)
    for s in ("top", "right"):
        ax2.spines[s].set_visible(False)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "lec10-fig-exp-error.png"), dpi=200)
    plt.close(fig)


def fig_runge():
    f = lambda x: 1.0 / (1.0 + 25.0 * x * x)
    xs = np.linspace(-1, 1, 4001)
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10.6, 4.5), sharey=True)
    ax1.plot(xs, f(xs), color="black", lw=2.0, label=r"$f(x)=1/(1+25x^2)$")
    for n, color in [(10, BLUE), (20, RED)]:
        nodes = np.linspace(-1, 1, n + 1)
        ax1.plot(xs, lagrange_eval(nodes, f(nodes), xs), color=color, lw=1.4,
                 label=fr"等距 $n={n}$（max err {np.max(np.abs(lagrange_eval(nodes, f(nodes), xs)-f(xs))):.2g}）")
    ax1.set_ylim(-1.2, 2.2)
    ax1.set_title("等距节点：高次插值发散", fontsize=11)
    ax1.set_xlabel("$x$")
    ax1.set_ylabel("$y$")
    ax1.legend(frameon=False, fontsize=8.5, loc="upper center")
    for s in ("top", "right"):
        ax1.spines[s].set_visible(False)

    ax2.plot(xs, f(xs), color="black", lw=2.0, label=r"$f(x)$")
    for n, color in [(10, GREEN), (20, GOLD)]:
        k = np.arange(n + 1)
        nodes = np.cos((2 * k + 1) * np.pi / (2 * (n + 1)))
        ax2.plot(xs, lagrange_eval(nodes, f(nodes), xs), color=color, lw=1.4,
                 label=fr"Chebyshev $n={n}$（max err {np.max(np.abs(lagrange_eval(nodes, f(nodes), xs)-f(xs))):.2g}）")
    ax2.set_title("Chebyshev 节点：误差受控", fontsize=11)
    ax2.set_xlabel("$x$")
    ax2.legend(frameon=False, fontsize=8.5, loc="upper center")
    for s in ("top", "right"):
        ax2.spines[s].set_visible(False)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "lec10-fig-runge.png"), dpi=200)
    plt.close(fig)


def fig_hermite():
    f = np.exp
    xs = np.linspace(0, 1, 4001)
    fig, ax = plt.subplots(figsize=(8.2, 4.6))
    lin = lagrange_eval([0.0, 1.0], f(np.array([0.0, 1.0])), xs)
    quad = lagrange_eval([0.0, 0.5, 1.0], f(np.array([0.0, 0.5, 1.0])), xs)
    cubic = lagrange_eval([0.0, 1/3, 2/3, 1.0],
                          f(np.array([0.0, 1/3, 2/3, 1.0])), xs)
    a = 1.0
    b = 1.0
    c = 2 * np.e - 5
    d = 3 - np.e
    herm = a + b * xs + c * xs**2 + d * xs**3
    ax.semilogy(xs, np.abs(lin - f(xs)), color=BLUE, lw=1.6,
                label=r"线性 Lagrange：$0.212$")
    ax.semilogy(xs, np.abs(quad - f(xs)), color=RED, lw=1.6,
                label=r"二次 Lagrange：$0.0144$")
    ax.semilogy(xs, np.abs(herm - f(xs)), color=GREEN, lw=1.8,
                label=r"Hermite 三次（端点函数值 + 导数）：$0.00437$")
    ax.semilogy(xs, np.abs(cubic - f(xs)), color=GOLD, lw=1.6,
                label=r"三次 Lagrange（4 点）：$9.24\times10^{-4}$")
    ax.set_xlabel("$x$")
    ax.set_ylabel("$|f-p|$")
    ax.set_ylim(1e-6, 1)
    ax.legend(frameon=False, fontsize=8.5, loc="lower center")
    ax.set_title(r"$e^x$ 在 $[0,1]$ 上：导数信息与节点数的效果", pad=10)
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "lec10-fig-hermite.png"), dpi=200)
    plt.close(fig)


def fig_lebesgue():
    n = 10
    xs = np.linspace(-1, 1, 8001)
    equi = np.linspace(-1, 1, n + 1)
    k = np.arange(n + 1)
    cheb = np.cos((2 * k + 1) * np.pi / (2 * (n + 1)))

    def leb(nodes):
        L = np.zeros_like(xs)
        for i in range(len(nodes)):
            L += np.abs(lagrange_basis(nodes, i, xs))
        return L

    fig, ax = plt.subplots(figsize=(8.2, 4.5))
    ax.semilogy(xs, leb(equi), color=RED, lw=1.8,
                label=r"等距节点：$\Lambda_{10}\approx 29.9$")
    ax.semilogy(xs, leb(cheb), color=GREEN, lw=1.8,
                label=r"Chebyshev 节点：$\Lambda_{10}\approx 2.49$")
    ax.set_xlabel("$x$")
    ax.set_ylabel(r"$\sum_i|\ell_i(x)|$")
    ax.set_title("Lebesgue 函数与插值算子范数", pad=10)
    ax.legend(frameon=False, fontsize=9)
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, "lec10-fig-lebesgue.png"), dpi=200)
    plt.close(fig)


if __name__ == "__main__":
    fig_lagrange_basis()
    fig_exp_error()
    fig_runge()
    fig_hermite()
    fig_lebesgue()
    print("figures written to", os.path.abspath(OUT))
