#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""insert_figures — 把 tools/figs_out/ 的 <figure> 块嵌入正文（一次性构建步骤）。

每条插入规则 = (md 文件, 定位子串, 图名, 位置)。定位子串必须在文件中**唯一**；
插入点为该子串所在段落块的末尾（after）或下一个段落块之前（before）。
重复运行安全：若图已存在（按 fig 文件的 <title id> 判断）则跳过。

产物是**正文 markdown 内嵌最终 SVG**（与 robot 书同一做法：图即正文）。
tools/make_figures.py / make_diagrams.py 保留生成器与再生成能力。
"""

from __future__ import annotations

import os
import re
import sys

SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "src")
FIGS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "figs_out")

# (file, unique anchor substring, figure name, before/after)
RULES = [
    # ── 第 1 讲 ──
    ("lectures/lec01.md", "## 1.3 激活函数", "mlp", "before"),
    ("lectures/lec01.md", "把多层感知机（Multi-Layer Perceptron, MLP）", "mlp", "skip"),
    ("lectures/lec01.md", "## 1.4 损失函数", "act", "before"),
    ("lectures/lec01.md", "## 1.6 优化器", "backprop", "before"),
    ("lectures/lec01.md", "## 1.7 过拟合", "gd", "before"),
    ("lectures/lec01.md", "## 1.8 本讲陷阱", "overfit", "before"),
    # ── 第 2 讲 ──
    ("lectures/lec02.md", "## 2.3 门控", "rnn", "before"),
    ("lectures/lec02.md", "## 2.4 从压缩瓶颈", "vanish", "before"),
    ("lectures/lec02.md", "## 2.5 Transformer", "lstm", "before"),
    ("lectures/lec02.md", "## 2.6 课堂应用导读", "attn", "before"),
    # ── 第 3 讲 ──
    ("lectures/lec03.md", "## 3.3 池化与下采样", "conv", "before"),
    ("lectures/lec03.md", "## 3.4 经典网络演进", "convparams", "before"),
    ("lectures/lec03.md", "## 3.5 迁移学习", "resnet", "before"),
    # ── 第 4 讲 ──
    ("lectures/lec04.md", "## 4.4 生成对抗网络", "vae", "before"),
    ("lectures/lec04.md", "## 4.6 应用谱系与取舍", "diffusion", "before"),
    # ── 第 5 讲 ──
    ("lectures/lec05.md", "## 1.3 值方法", "mdp", "before"),
    ("lectures/lec05.md", "## 1.4 策略方法", "discount", "before"),
    ("lectures/lec05.md", "## 1.6 前沿", "ppo", "before"),
    # ── 第 6 / 7 讲 ──
    ("lectures/lec06.md", "## 6.2 提示与推理", "scaling", "before"),
    ("lectures/lec07.md", "## 1.4 法则三", "calib", "before"),
    # ── 第 9 讲 ──
    ("lectures/lec09.md", "## 1.2 数据并行", "parallel", "before"),
    ("lectures/lec09.md", "## 1.6 通信与工程", "memory", "before"),
    ("lectures/lec09.md", "## 1.7 与 Lab 3 的连接", "bubble", "before"),
    # ── Lab 1 ──
    ("labs/lab1.md", "## 5. 排错清单", "temp", "before"),
]


def fig_block(name: str) -> str:
    path = os.path.join(FIGS, f"fig-{name}.md")
    if not os.path.exists(path):
        path = os.path.join(FIGS, f"{name}.md")
    with open(path, encoding="utf-8") as f:
        return f.read().strip()


def fig_id(block: str) -> str:
    m = re.search(r'<title id="([^"]+)"', block)
    return m.group(1) if m else None


def main():
    done, skipped = [], []
    for rel, anchor, name, pos in RULES:
        if pos == "skip":
            continue
        path = os.path.join(SRC, rel)
        with open(path, encoding="utf-8") as f:
            text = f.read()
        block = fig_block(name)
        fid = fig_id(block)
        if fid and fid in text:
            skipped.append(f"{rel}:{name}（已存在）")
            continue
        idx = text.find(anchor)
        if idx < 0:
            print(f"[insert] ✗ {rel}: 找不到定位串「{anchor}」", file=sys.stderr)
            sys.exit(1)
        if text.count(anchor) > 1:
            print(f"[insert] ✗ {rel}: 定位串「{anchor}」不唯一", file=sys.stderr)
            sys.exit(1)
        # 插到定位行所在行首之前
        line_start = text.rfind("\n", 0, idx) + 1
        text = text[:line_start] + block + "\n\n" + text[line_start:]
        with open(path, "w", encoding="utf-8") as f:
            f.write(text)
        done.append(f"{rel} ← {name}")
    for d_ in done:
        print(f"[insert] ✓ {d_}")
    for s_ in skipped:
        print(f"[insert] - {s_}")
    print(f"[insert] 共 {len(done)} 处插入，{len(skipped)} 处跳过")


if __name__ == "__main__":
    main()
