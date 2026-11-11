#!/usr/bin/env python3
"""生成《图鉴》教学插图（内联 SVG 片段，供 mdBook include）。

设计语法见 tools/ATLAS_FIGURES.md。输出 Markdown 片段到各书 src/assets/figures/。
用法：python3 tools/build_atlas_figures.py [--only slug1,slug2]
"""
from __future__ import annotations

import argparse
import html
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TONES = {
    "accent": "var(--accent)",
    "cyan": "var(--atlas-cyan)",
    "gold": "var(--atlas-gold)",
    "plum": "var(--atlas-plum)",
    "green": "var(--fig-green)",
    "red": "var(--fig-red)",
    "muted": "var(--muted)",
}


def e(text: str) -> str:
    return html.escape(text, quote=True)


def t(x, y, text, cls="pl-label", fill=None, anchor=None, size=None, weight=None, opacity=None):
    attrs = [f'x="{x:.1f}"', f'y="{y:.1f}"', f'class="{cls}"']
    if fill:
        attrs.append(f'style="fill:{fill}"')
    if anchor:
        attrs.append(f'text-anchor="{anchor}"')
    if size:
        attrs.append(f'font-size="{size}"')
    if weight:
        attrs.append(f'font-weight="{weight}"')
    if opacity is not None:
        attrs.append(f'opacity="{opacity}"')
    return f'<text {" ".join(attrs)}>{e(text)}</text>'


def chip(x, y, text, color="var(--accent)", w=None, h=24, cls="pl-mono"):
    width = w or max(48, 12.5 * len(text) + 20)
    return (
        f'<g><rect x="{x:.1f}" y="{y:.1f}" width="{width:.1f}" height="{h}" rx="{h/2:.1f}" '
        f'fill="{color}" fill-opacity=".08" stroke="{color}" stroke-opacity=".28"/>'
        f'{t(x+width/2, y+h/2+3.8, text, cls=cls, fill=color, anchor="middle")}</g>'
    )


def node(x, y, w, h, title, sub, color="var(--accent)", index=None, icon="dot", lines=None):
    out = [f'<g><rect x="{x}" y="{y}" width="{w}" height="{h}" rx="13" fill="var(--paper)" fill-opacity=".92" stroke="{color}" stroke-opacity=".28"/>']
    out.append(f'<rect x="{x}" y="{y+13}" width="4" height="{h-26}" rx="2" fill="{color}" fill-opacity=".75"/>')
    if index:
        out.append(t(x + 18, y + 25, index, cls="pl-mono", fill=color, opacity=.85))
    cx, cy = x + w - 22, y + 22
    if icon == "dot":
        out.append(f'<circle cx="{cx}" cy="{cy}" r="4" fill="{color}"/><circle cx="{cx}" cy="{cy}" r="9" fill="none" stroke="{color}" stroke-opacity=".25"/>')
    elif icon == "square":
        out.append(f'<rect x="{cx-5}" y="{cy-5}" width="10" height="10" rx="2" fill="none" stroke="{color}" stroke-width="1.6"/>')
    elif icon == "wave":
        out.append(f'<path d="M{cx-9} {cy+1} q4 -8 9 0 t9 0" fill="none" stroke="{color}" stroke-width="1.6"/>')
    out.append(t(x + 18, y + (50 if index else 34), title, cls="pl-node-title"))
    if sub:
        subs = sub if isinstance(sub, (list, tuple)) else [sub]
        for i, line in enumerate(subs):
            out.append(t(x + 18, y + (70 if index else 54) + i * 17, line, cls="pl-node-sub"))
    if lines:
        for i, line in enumerate(lines):
            out.append(t(x + 18, y + h - 14 - (len(lines) - 1 - i) * 16, line, cls="pl-small"))
    out.append("</g>")
    return "".join(out)


def arrow(x1, y1, x2, y2, color="var(--accent)", width=1.8, dashed=False, curve=None, label=None, label_pos="mid", label_dx=0, label_dy=-8):
    if color == TONES["red"]:
        marker = "arrow-r"
    elif color == TONES["green"]:
        marker = "arrow-e"
    else:
        marker = "arrow-a" if color == TONES["accent"] else "arrow-c" if color == TONES["cyan"] else "arrow-g" if color == TONES["gold"] else "arrow-p" if color == TONES["plum"] else "arrow-m"
    dash = ' stroke-dasharray="5 6"' if dashed else ""
    d = f"M{x1} {y1} Q{curve[0]} {curve[1]} {x2} {y2}" if curve else f"M{x1} {y1} L{x2} {y2}"
    out = f'<path d="{d}" fill="none" stroke="{color}" stroke-width="{width}" stroke-linecap="round"{dash} marker-end="url(#{marker})"/>'
    if label:
        if label_pos == "mid":
            mx, my = (x1 + x2) / 2 + label_dx, (y1 + y2) / 2 + label_dy
        elif label_pos == "start":
            mx, my = x1 + label_dx, y1 + label_dy
        else:
            mx, my = x2 + label_dx, y2 + label_dy
        out += t(mx, my, label, cls="pl-axis-label", fill=color, anchor="middle")
    return out


def plate(uid, height, kicker, title, subtitle, body, tone="accent", atlas_no="01", caption="", scroll_label=None):
    caption = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", caption)
    accent = TONES[tone]
    cyan = TONES["cyan"]
    scroll_attrs = f' tabindex="0" role="region" aria-label="{e(scroll_label)}"' if scroll_label else ""
    return f'''<figure class="fig-plate fig-wide has-fig-scroll" id="fig-{uid}" data-fig-kind="plate">
<div class="fig-scroll"{scroll_attrs}>
<svg class="figure-svg atlas-plate" viewBox="0 0 900 {height}" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="{uid}-title {uid}-desc">
<title id="{uid}-title">{e(title)}</title>
<desc id="{uid}-desc">{e(subtitle)}</desc>
<defs>
  <linearGradient id="{uid}-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".96"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".96"/>
  </linearGradient>
  <radialGradient id="{uid}-glow" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:{accent}" stop-opacity=".16"/><stop offset="1" style="stop-color:{accent}" stop-opacity="0"/>
  </radialGradient>
  <radialGradient id="{uid}-glow2" cx="50%" cy="50%" r="50%">
    <stop offset="0" style="stop-color:{cyan}" stop-opacity=".10"/><stop offset="1" style="stop-color:{cyan}" stop-opacity="0"/>
  </radialGradient>
  <pattern id="{uid}-grid" width="26" height="26" patternUnits="userSpaceOnUse">
    <path d="M26 0H0V26" fill="none" style="stroke:var(--ink)" stroke-opacity=".045"/>
  </pattern>
  <marker id="arrow-a" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="arrow-c" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:{cyan}"/></marker>
  <marker id="arrow-g" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:{TONES['gold']}"/></marker>
  <marker id="arrow-p" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:{TONES['plum']}"/></marker>
  <marker id="arrow-e" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--fig-green)"/></marker>
  <marker id="arrow-r" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--fig-red)"/></marker>
  <marker id="arrow-m" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6.4" markerHeight="6.4" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="900" height="{height}" fill="url(#{uid}-bg)"/>
<rect x="0" y="0" width="900" height="{height}" fill="url(#{uid}-grid)" opacity=".35"/>
<rect x="0" y="0" width="3" height="{height}" style="fill:{accent}" fill-opacity=".55"/>
<text x="32" y="36" class="pl-kicker">{e(kicker)}</text>
<text x="868" y="36" text-anchor="end" class="pl-mono" opacity=".72">ATLAS / {e(atlas_no)}</text>
<text x="32" y="73" class="pl-title">{e(title)}</text>
<text x="32" y="96" class="pl-sub">{e(subtitle)}</text>
<path d="M32 112H868" style="stroke:var(--line)" stroke-opacity=".8"/>
{body}
</svg>
</div>
<figcaption><span class="fig-index">图解</span>{caption}</figcaption>
</figure>
'''


def fig_robot_system():
    uid = "robot-system"
    body = []
    specs = [
        (230, 174, 180, 88, "控制系统", ["比较目标与测量", "计算命令"], "plum"),
        (470, 174, 150, 88, "执行系统", ["驱动器 · 电机", "产生并传递驱动力"], "green"),
        (680, 174, 180, 88, "机械系统", ["连杆 · 关节 · 夹爪", "运动并作用于环境"], "gold"),
        (450, 332, 200, 88, "传感系统", ["测量内部状态与环境", "输出测量值 y"], "cyan"),
    ]
    for i, (x, y, w, h, title, subs, tone) in enumerate(specs):
        body.append(node(x, y, w, h, title, subs, TONES[tone]))
    body.append(chip(32, 204, "目标 r", TONES["accent"], w=135, h=28))
    body.append(arrow(169, 218, 228, 218, TONES["accent"]))
    body.append(arrow(412, 218, 468, 218, TONES["plum"]))
    body.append(t(440, 196, "命令 u", cls="pl-mono", anchor="middle", fill=TONES["plum"]))
    body.append(arrow(622, 218, 678, 218, TONES["green"]))
    body.append(t(650, 196, "驱动力", cls="pl-mono", anchor="middle", fill=TONES["green"]))
    body.append('<path d="M770 264V376H652" fill="none" stroke="var(--atlas-cyan)" '
                'stroke-width="1.8" marker-end="url(#arrow-c)"/>')
    body.append(t(780, 306, "运动结果", cls="pl-mono", fill=TONES["cyan"]))
    body.append('<path d="M448 376H320V264" fill="none" stroke="var(--atlas-cyan)" '
                'stroke-width="1.8" marker-end="url(#arrow-c)"/>')
    body.append(t(320, 317, "测量值 y", cls="pl-mono", anchor="middle", fill=TONES["cyan"]))
    body.append(t(450, 461, "命令沿上方传递；运动结果经传感器测量后，沿下方返回控制器。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>从目标出发，依次追踪控制、执行、机械运动，再沿下方箭头经过传感系统返回控制系统。四个方框对应四个子系统；目标是外部输入。箭头表示信号或作用的传递方向，并非全是电能传递。<b>本教程绘</b>，不是原书图 1.1。"
    return plate(uid, 492, "ROBOTICS · SYSTEM ANATOMY / 01", "四个子系统怎样协作",
                 "执行系统提供驱动力，机械系统产生运动，传感器测量结果，控制器据此调整命令。",
                 "".join(body), "accent", "R-01", caption,
                 scroll_label="四个子系统怎样协作，可左右滚动查看")


def fig_robot_pose():
    body = []
    reference_origin = (170, 330)
    body_origin = (430, 255)
    projected_axes = ((100, 30), (-70, 35), (0, -100))
    body_axes = (projected_axes[1], (-100, -30), projected_axes[2])
    body.append('<ellipse cx="440" cy="268" rx="105" ry="52" fill="var(--accent)" fill-opacity=".06" stroke="var(--accent)" stroke-opacity=".28"/>')
    body.append(arrow(*reference_origin, *body_origin, TONES["cyan"], 2.6))
    body.append(t(292, 279, "o′：从 O 指向 O′", cls="pl-small", fill=TONES["cyan"], anchor="middle"))
    for origin, vectors, labels in ((reference_origin, projected_axes, ("x", "y", "z")),
                                    (body_origin, body_axes, ("x′ = y", "y′ = −x", "z′ = z"))):
        for vector, color, label in zip(vectors, (TONES["red"], TONES["green"], TONES["accent"]), labels):
            endpoint = (origin[0] + vector[0], origin[1] + vector[1])
            body.append(arrow(*origin, *endpoint, color, 2))
            label_offset = 12 if vector[0] >= 0 else -12
            label_height = endpoint[1] + 24 if label == "x′ = y" else endpoint[1] - 8
            body.append(t(endpoint[0] + label_offset, label_height, label, cls="pl-mono", fill=color,
                          anchor="start" if vector[0] >= 0 else "end"))
        body.append(f'<circle cx="{origin[0]}" cy="{origin[1]}" r="4" fill="var(--ink)"/>')
    body.append(t(154, 352, "O", cls="pl-mono"))
    body.append(t(442, 274, "O′", cls="pl-mono"))
    body.append('<rect x="635" y="144" width="230" height="218" rx="12" fill="var(--paper)" stroke="var(--line)"/>')
    body.append(t(650, 171, "姿态：绕参考 z 正转 90°", cls="pl-small"))
    body.append(t(650, 196, "列依次为 x′、y′、z′", cls="pl-small"))
    for row_index, row_values in enumerate(((0, -1, 0), (1, 0, 0), (0, 0, 1))):
        for column_index, value in enumerate(row_values):
            body.append(t(686 + column_index * 56, 229 + row_index * 34, str(value), cls="pl-mono", anchor="middle"))
    body.append(t(650, 338, "方向余弦无量纲", cls="pl-small"))
    body.append(t(55, 400, "先确定 O′ 在哪里，再确定三根本体轴的方向。", cls="pl-small"))
    body.append(t(55, 424, "空间投影示意；屏幕上的夹角不等于实际三维夹角。", cls="pl-small"))
    caption = "<b>读图：</b>蓝色箭头是位置向量 O→O′；两组三轴使用同一线性投影。此例本体 x′ 与参考 y 同向，y′ 与参考 x 反向，z′ 与参考 z 同向，右侧按列列出方向余弦。位置以长度计，方向余弦无量纲。自由刚体的位置与姿态各有三个局部独立变量；图的投影不用于量角。"
    return plate("robot-pose", 440, "ROBOTICS · POSE / 02", "位姿 = 位置 + 姿态",
                 "同一个参考点位置，可以对应不同的三轴朝向；位置和姿态须分别说明。",
                 "".join(body), "accent", "R-02", caption)


def fig_matrix_map():
    uid = "matrix-map"
    body = []
    stops = [
        ("01", "线性空间", "向量与八条公理", "accent"),
        ("02", "线性子空间", "对加法与数乘封闭", "cyan"),
        ("03", "基与坐标", "一组基 = 一套语言", "gold"),
        ("04", "内积空间", "长度、夹角、正交", "plum"),
        ("05", "范数与夹角", "三种「尺子」", "green"),
        ("06", "直和与投影", "把空间拆开", "red"),
    ]
    y0 = 220
    xs = [78 + i * 146 for i in range(6)]
    body.append(f'<path d="M{xs[0]} {y0} C 200 170, 700 270, {xs[-1]} {y0}" fill="none" stroke="var(--line-strong)" stroke-opacity=".45" stroke-width="2" stroke-dasharray="3 8"/>')
    for i, ((num, title, sub, tone), x) in enumerate(zip(stops, xs)):
        color = TONES[tone]
        cy = y0 - 60 if i % 2 == 0 else y0 + 58
        w, h = 132, 72
        body.append(f'<path d="M{x} {y0} L{x} {cy + (h/2 if i % 2 else -h/2)}" stroke="{color}" stroke-opacity=".35" stroke-dasharray="3 4"/>')
        body.append(f'<circle cx="{x}" cy="{y0}" r="8" fill="var(--paper)" stroke="{color}" stroke-width="2.4"/>')
        body.append(f'<circle cx="{x}" cy="{y0}" r="17" fill="{color}" fill-opacity=".08"/>')
        body.append(node(x - w / 2, cy - h / 2, w, h, title, sub, color, index=num))
    body.append(chip(34, 320, "结构", TONES["accent"], w=72))
    body.append(chip(114, 320, "坐标", TONES["gold"], w=72))
    body.append(chip(194, 320, "度量", TONES["plum"], w=72))
    body.append(t(868, 334, "每往右一站，就多一件可计算的工具。", cls="pl-note", anchor="end"))
    caption = "<b>读图：</b>六站依次加装工具：空间 → 子空间 → 基与坐标 → 内积 → 正交 → 投影；后一步使用前一步建立的结构。"
    return plate(uid, 348, "MATRIX · CHAPTER 1 MAP / 03", "第一章：六站一条线",
                 "空间 → 子空间 → 基 → 内积 → 度量 → 直和：每往右一步，就多一件可计算的工具。",
                 "".join(body), "plum", "M-01", caption)


def fig_numerical_pipeline():
    uid = "numerical-pipeline"
    body = []
    steps = [
        ("01", "实际问题", "物理 / 工程对象", "gold"),
        ("02", "数学模型", "方程、初边值条件", "accent"),
        ("03", "数值方法", "离散化、迭代格式", "cyan"),
        ("04", "误差分析", "截断 + 舍入 + 传播", "plum"),
        ("05", "可计算的结果", "误差界与可信度", "green"),
    ]
    xs = [38 + i * 168 for i in range(5)]
    for i, ((num, title, sub, tone), x) in enumerate(zip(steps, xs)):
        color = TONES[tone]
        body.append(node(x, 158, 146, 82, title, sub, color, index=num))
        if i < 4:
            body.append(arrow(x + 148, 198, x + 166, 198, color, 1.8))
    body.append(f'<path d="M{xs[-1]+73} 246 C 720 322, 250 322, {xs[1]+73} 252" fill="none" stroke="{TONES["plum"]}" stroke-opacity=".55" stroke-width="1.8" stroke-dasharray="5 6" marker-end="url(#arrow-p)"/>')
    body.append(t(450, 310, "条件数 / 稳定性：模型误差会被方法放大多少？", cls="pl-mono", anchor="middle", fill=TONES["plum"]))
    # 误差类型
    body.append(chip(98, 124, "模型误差", TONES["gold"], w=90))
    body.append(chip(314, 124, "截断误差", TONES["cyan"], w=90))
    body.append(chip(530, 124, "舍入误差", TONES["green"], w=90))
    body.append(chip(746, 124, "传播误差", TONES["plum"], w=90))
    body.append(t(450, 348, "数值分析给出的是带误差界的近似解。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>上半排是计算路径；下半排的虚线是**分析路径**。误差在每一步进入，并被后续运算放大或抑制；条件数描述问题本身的敏感性，稳定性描述算法是否额外放大误差。"
    return plate(uid, 368, "NUMERICAL · WORKFLOW / 04", "数值分析在做什么？",
                 "给出的是带误差界的近似解。",
                 "".join(body), "cyan", "N-01", caption)


def fig_dl_map():
    uid = "dl-map"
    body = []
    strands = [
        ("I · 表示与优化", "accent", [("1", "神经网络基础", "神经元 → MLP → 反向传播"), ("2", "优化与泛化", "SGD / AdamW · 正则 · 归一化")]),
        ("II · 序列与视觉", "cyan", [("3", "序列建模", "RNN · LSTM · Transformer"), ("4", "计算机视觉", "CNN · 检测 · 分割")]),
        ("III · 生成与决策", "gold", [("5", "生成模型", "VAE · GAN · Diffusion"), ("6", "强化学习", "MDP · Q-learning · Policy")]),
        ("IV · 前沿", "plum", [("7", "规模化", "Scaling · LLM · 多模态"), ("8", "可靠性", "对齐 · 评测 · 安全")]),
    ]
    # 三条纵向主线
    x0 = 42
    for i, (title, tone, items) in enumerate(strands):
        color = TONES[tone]
        x = x0 + i * 213
        body.append(f'<path d="M{x} 132 V330" stroke="{color}" stroke-opacity=".2" stroke-width="1.4" stroke-dasharray="3 6"/>')
        body.append(chip(x, 138, title, color, w=168, h=26))
        for j, (num, name, sub) in enumerate(items):
            y = 190 + j * 82
            body.append(f'<circle cx="{x+13}" cy="{y+22}" r="12" fill="{color}" fill-opacity=".1" stroke="{color}" stroke-opacity=".4"/>')
            body.append(t(x + 13, y + 26, num, cls="pl-mono", anchor="middle", fill=color, size="10"))
            body.append(t(x + 34, y + 20, name, cls="pl-node-title", size="15"))
            body.append(t(x + 34, y + 38, sub, cls="pl-small"))
    body.append('<path d="M58 362 H842" stroke="var(--line-strong)" stroke-opacity=".5" stroke-dasharray="2 6"/>')
    body.append(t(450, 384, "同一套训练语言：定义结构 → 定义损失 → 梯度下降 → 评测与泛化", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>纵向是四条支线，横向是共同范式。无论 RNN、CNN、Diffusion 还是 RL，训练循环都可以写成**结构 + 损失 + 梯度 + 评测**四件事；差别只在结构如何归纳偏置、损失如何定义任务。"
    return plate(uid, 400, "DEEP LEARNING · CURRICULUM MAP / 05", "九讲，四条支线，一个范式",
                 "结构 + 损失 + 梯度 + 评测：所有模型共享同一套训练语言。",
                 "".join(body), "gold", "D-01", caption)




def flow_plate(uid, kicker, title, subtitle, steps, caption, tone="accent", atlas_no="F", chips=None, feedback=None, note=None, height=356):
    """横向流程：4–5 张卡 + 可选反馈弧。steps = [(tag,title,sub,color), ...]。"""
    body = []
    n = len(steps)
    x0, gap = 32, 18
    w = int((900 - 2 * x0 - (n - 1) * gap) / n)
    y, h = 172, 86
    for i, (tag, name, subs, color_name) in enumerate(steps):
        x = x0 + i * (w + gap)
        color = TONES.get(color_name, color_name)
        body.append(node(x, y, w, h, name, subs, color, index=tag))
        if i < n - 1:
            body.append(arrow(x + w + 2, y + h / 2, x + w + gap - 3, y + h / 2, "var(--muted)", 1.6))
    if chips:
        for i, (label, color_name, cx) in enumerate(chips):
            body.append(chip(cx, 122, label, TONES.get(color_name, color_name), w=max(76, 13 * len(label) + 18)))
    if feedback:
        label, fy, swing = feedback
        sx = x0 + (n - 1) * (w + gap) + w / 2
        ex = x0 + w / 2
        body.append(arrow(sx, y + h + 4, ex, y + h + 4, TONES["cyan"], 1.8, curve=(450, fy)))
        body.append(t(450, fy + swing, label, cls="pl-mono", anchor="middle", fill=TONES["cyan"]))
    if note:
        body.append(t(450, height - 24, note, cls="pl-note", anchor="middle"))
    return plate(uid, height, kicker, title, subtitle, "".join(body), tone, atlas_no, caption)


def matrix_block(x, y, rows, cols, label=None, color="var(--accent)", cell=20, gap=4, entries=None, labels=None, bracket=True):
    """画一个带方括号的矩阵块，返回 (svg, width, height)。entries 为 0–1 填充强度。"""
    out = []
    ww, hh = cols * (cell + gap) - gap, rows * (cell + gap) - gap
    if bracket:
        out.append(f'<path d="M{x-9} {y-7} h-7 v{hh+14} h7" fill="none" stroke="{color}" stroke-width="1.6" opacity=".8"/>')
        out.append(f'<path d="M{x+ww+9} {y-7} h7 v{hh+14} h-7" fill="none" stroke="{color}" stroke-width="1.6" opacity=".8"/>')
    for r in range(rows):
        for c in range(cols):
            cx, cy = x + c * (cell + gap), y + r * (cell + gap)
            strength = 0.04
            if entries and r < len(entries) and c < len(entries[r]):
                strength = entries[r][c]
            out.append(f'<rect x="{cx}" y="{cy}" width="{cell}" height="{cell}" rx="4" fill="{color}" fill-opacity="{0.04 + 0.22*strength:.3f}" stroke="{color}" stroke-opacity=".22"/>')
            if labels and r < len(labels) and c < len(labels[r]) and labels[r][c]:
                out.append(t(cx + cell / 2, cy + cell / 2 + 3.5, labels[r][c], cls="pl-mono", anchor="middle", fill=color, size="9"))
    if label:
        out.append(t(x + ww / 2, y - 16, label, cls="pl-mono", anchor="middle", fill=color))
    return "".join(out), ww, hh


def eq_plate(uid, kicker, title, subtitle, body, caption, tone="accent", atlas_no="E", height=350):
    return plate(uid, height, kicker, title, subtitle, body, tone, atlas_no, caption)


def plot_axes(x, y, w, h, xlabel="", ylabel="", xticks=None, yticks=None):
    out = []
    out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".7"/>')
    for i in range(1, 5):
        gx = x + w * i / 5
        gy = y + h * i / 5
        out.append(f'<path d="M{gx:.1f} {y} V{y+h}" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/>')
        out.append(f'<path d="M{x} {gy:.1f} H{x+w}" stroke="var(--line)" stroke-opacity=".38" stroke-dasharray="2 6"/>')
    out.append(f'<path d="M{x} {y+h} H{x+w}" stroke="var(--ink-2)" stroke-opacity=".65" stroke-width="1.2"/>')
    out.append(f'<path d="M{x} {y+h} V{y}" stroke="var(--ink-2)" stroke-opacity=".65" stroke-width="1.2"/>')
    if xlabel:
        out.append(t(x + w / 2, y + h + 22, xlabel, cls="pl-axis-label", anchor="middle"))
    if ylabel:
        out.append(f'<text x="{x-12}" y="{y+12}" class="pl-axis-label" text-anchor="middle" transform="rotate(-90 {x-12} {y+12})">{e(ylabel)}</text>')
    if xticks:
        for value, px in xticks:
            out.append(t(px, y + h + 16, value, cls="pl-axis-label", anchor="middle"))
    if yticks:
        for value, py in yticks:
            out.append(t(x - 6, py + 4, value, cls="pl-axis-label", anchor="end"))
    return "".join(out)


def poly_path(points, color, width=2.4, dashed=False, fill=False, close=False):
    if not points:
        return ""
    d = "M" + " L".join(f"{x:.1f} {y:.1f}" for x, y in points)
    if close:
        d += " Z"
    dash = ' stroke-dasharray="5 6"' if dashed else ""
    fill_attr = f' fill="{color}" fill-opacity=".09"' if fill else ' fill="none"'
    return f'<path d="{d}" stroke="{color}" stroke-width="{width}" stroke-linejoin="round" stroke-linecap="round"{dash}{fill_attr}/>'


def dot(x, y, color, r=4, label=None, anchor="start"):
    out = f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r}" fill="var(--paper)" stroke="{color}" stroke-width="2"/>'
    if label:
        out += t(x + (r + 6 if anchor == "start" else -r - 6), y + 4, label, cls="pl-mono", fill=color, anchor=anchor)
    return out


def plot_plate(uid, kicker, title, subtitle, draw, caption, tone="accent", atlas_no="P", note="", height=436):
    """单幅大图 + 右侧读法。draw(x,y,w,h) 返回 SVG。"""
    body = []
    body.append(draw(32, 138, 566, 250))
    # 右侧读法卡
    px, py, pw, ph = 626, 138, 242, 250
    body.append(f'<rect x="{px}" y="{py}" width="{pw}" height="{ph}" rx="14" fill="var(--paper)" fill-opacity=".7" stroke="var(--line)" stroke-opacity=".8"/>')
    body.append(t(px + 18, py + 28, "读 法", cls="pl-kicker", fill=TONES[tone]))
    if note:
        lines = note.split("|")
        for i, line in enumerate(lines):
            body.append(t(px + 18, py + 58 + i * 30, line, cls="pl-small"))
    return plate(uid, height, kicker, title, subtitle, "".join(body), tone, atlas_no, caption)


def network_plate(uid, kicker, title, subtitle, layers, caption, tone="cyan", atlas_no="N", note_lines=None, height=420):
    """层状网络：layers = [(name, count, color), ...]，最多 4 层。"""
    body = []
    x0, x1 = 128, 650
    ys0, ys1 = 172, 352
    positions = []
    n = len(layers)
    for li, (name, count, color_name) in enumerate(layers):
        x = x0 + (x1 - x0) * li / max(1, n - 1)
        color = TONES.get(color_name, color_name)
        ys = [ys0 + (ys1 - ys0) * (k / max(1, count - 1)) for k in range(count)] if count > 1 else [(ys0 + ys1) / 2]
        coords = []
        for k, y in enumerate(ys):
            coords.append((x, y))
        positions.append((x, coords, color, name, count))
        body.append(t(x, ys1 + 36, name, cls="pl-mono", anchor="middle", fill=color, opacity=.9))
        body.append(t(x, ys1 + 54, f"{count} 个单元", cls="pl-small", anchor="middle"))
    for li in range(n - 1):
        x1_, co1, _, _, _ = positions[li]
        _, co2, _, _, _ = positions[li + 1]
        for (ax, ay) in co1:
            for (bx, by) in co2:
                body.append(f'<path d="M{ax+8:.1f} {ay:.1f} L{bx-8:.1f} {by:.1f}" stroke="var(--muted)" stroke-opacity=".13" stroke-width="1"/>')
    for x, coords, color, name, count in positions:
        for k, (cx, cy) in enumerate(coords):
            body.append(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="18" fill="{color}" fill-opacity=".06"/>')
            body.append(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="8" fill="var(--paper)" stroke="{color}" stroke-width="1.9"/>')
            body.append(f'<circle cx="{cx:.1f}" cy="{cy:.1f}" r="2.8" fill="{color}"/>')
    body.append(t(450, height - 22, "每一列是一个张量；连线是权重；前向是矩阵乘，反向是链式法则。", cls="pl-note", anchor="middle"))
    if note_lines:
        px, py = 690, 158
        body.append(f'<rect x="{px}" y="{py}" width="178" height="226" rx="14" fill="var(--paper)" fill-opacity=".72" stroke="var(--line)" stroke-opacity=".8"/>')
        body.append(t(px + 16, py + 27, "SHAPES", cls="pl-kicker", fill=TONES[tone]))
        for i, line in enumerate(note_lines):
            body.append(t(px + 16, py + 56 + i * 26, line, cls="pl-small"))
    return plate(uid, height, kicker, title, subtitle, "".join(body), tone, atlas_no, caption)




def fig_robot_actuator():
    uid = "robot-actuator"
    steps = [
        ("01", "电源 / 驱动器", ["电流环 · PWM"], "gold"),
        ("02", "电机", ["转矩 → 转速"], "accent"),
        ("03", "减速器", ["降速 · 增矩"], "cyan"),
        ("04", "传动 / 关节", ["皮带 · 丝杠 · 轴承"], "plum"),
        ("05", "末端执行器", ["抓取 · 加工 · 移动"], "green"),
    ]
    caption = "<b>读图：</b>从电到运动，功率链是<b>驱动器 → 电机 → 减速器 → 传动 → 关节/末端</b>；传感器（编码器、力矩、视觉）从另一端把状态送回控制器。选型时四个量互相拉扯：<b>转矩、转速、精度、带宽</b>——减速比越大，转矩越大，但转速与带宽越低。"
    return flow_plate(uid, "ROBOTICS · ACTUATION / 06", "执行器链：从电流到运动",
                      "电机给出高速低矩，减速器换成低速高矩，传动与关节再把运动送到末端。",
                      [x for x in steps], caption, "gold", "R-06",
                      chips=[("功率链", "gold", 42), ("反馈链", "cyan", 760)],
                      feedback=("编码器 · 力矩 · 视觉 → 反馈", 320, 0),
                      note="选型的四个约束：转矩、转速、精度、带宽。", height=380)


def fig_matrix_equiv():
    uid = "matrix-equiv"
    body = []
    # A
    svg_a, wa, ha = matrix_block(78, 176, 3, 4, "A  (m×n)", TONES["accent"], 24, 5, entries=[[0.2,0.8,0.5,0.1],[0.7,0.4,0.2,0.6],[0.3,0.2,0.9,0.4]])
    body.append(svg_a)
    body.append(t(78 + wa / 2, 176 + ha + 24, "任意矩阵", cls="pl-small", anchor="middle"))
    body.append(t(78 + wa + 26, 186, "=", cls="pl-title", size="28", fill=TONES["muted"]))
    # P^-1
    px = 78 + wa + 58
    svg_p, wp, hp = matrix_block(px, 176, 3, 3, "P⁻¹  (m×m)", TONES["plum"], 24, 5, entries=[[0.5,0.2,0.1],[0.2,0.7,0.2],[0.1,0.3,0.6]])
    body.append(svg_p)
    body.append(t(px + wp / 2, 176 + hp + 24, "可逆 · 换基", cls="pl-small", anchor="middle"))
    # Gamma
    gx = px + wp + 44
    svg_g, wg, hg = matrix_block(gx, 176, 3, 4, "Γ  (m×n)", TONES["gold"], 24, 5, entries=[[1,1,0,0],[1,1,0,0],[0,0,0,0]], labels=[["1","1","0","0"],["1","1","0","0"],["0","0","0","0"]])
    body.append(svg_g)
    body.append(t(gx + wg / 2, 176 + hg + 24, "相抵标准形", cls="pl-small", anchor="middle"))
    body.append(t(gx + wg + 26, 186, "·", cls="pl-title", size="28", fill=TONES["muted"]))
    # Q
    qx = gx + wg + 56
    svg_q, wq, hq = matrix_block(qx, 176, 4, 4, "Q  (n×n)", TONES["cyan"], 24, 5, entries=[[0.4,0.2,0.1,0.1],[0.2,0.5,0.2,0.1],[0.1,0.2,0.6,0.2],[0.1,0.1,0.2,0.5]])
    body.append(svg_q)
    body.append(t(qx + wq / 2, 176 + hq + 24, "可逆", cls="pl-small", anchor="middle"))
    # 秩注记
    body.append(f'<rect x="78" y="298" width="354" height="30" rx="8" fill="{TONES["gold"]}" fill-opacity=".07" stroke="{TONES["gold"]}" stroke-opacity=".22"/>')
    body.append(t(96, 318, "Γ 的左上角 Iᵣ 是单位阵，r = rank(A)；Γ 只由 r 决定。", cls="pl-small"))
    body.append(t(760, 318, "不唯一：P、Q 都可以换。", cls="pl-small", fill=TONES["plum"], anchor="middle"))
    caption = "<b>读图：</b>任何矩阵都能被两个可逆矩阵「夹」成一个只由秩决定的标准形 Γ。左乘 P⁻¹ 换到达端的基，右乘 Q 换出发端的基——<b>矩阵在换基，映射本身没变</b>。这也解释了为什么相抵标准形唯一、分解式不唯一。"
    return eq_plate(uid, "MATRIX · EQUIVALENCE / 07", "相抵分解：把矩阵压成一副标准像",
                    "A = P⁻¹ Γ Q：左右各换一次基，任何矩阵都化为同一个只由秩决定的标准形。",
                    "".join(body), caption, "plum", "M-07", 356)


def fig_dl_activations():
    uid = "dl-activations"
    def draw(x, y, w, h):
        out = [plot_axes(x, y, w, h, "输入 z", "激活值")]
        xmin, xmax, ymin, ymax = -6, 6, -1.2, 2.2
        def px(v): return x + (v - xmin) / (xmax - xmin) * w
        def py(v): return y + h - (v - ymin) / (ymax - ymin) * h
        def curve(fn, color, label, width=2.4, dash=False):
            pts = []
            for i in range(121):
                z = xmin + (xmax - xmin) * i / 120
                pts.append((px(z), py(fn(z))))
            out.append(poly_path(pts, color, width, dash))
            out.append(t(px(6) - 4, py(fn(6)) - 8, label, cls="pl-mono", fill=color, anchor="end"))
        curve(lambda z: 1 / (1 + math.exp(-z)), TONES["cyan"], "sigmoid")
        curve(lambda z: math.tanh(z), TONES["plum"], "tanh")
        curve(lambda z: max(0.0, z), TONES["gold"], "ReLU")
        curve(lambda z: 0.5 * z * (1 + math.tanh(0.7978845608 * (z + 0.044715 * z ** 3))), TONES["green"], "GELU")
        out.append(f'<path d="M{px(0)} {y} V{y+h}" stroke="var(--line-strong)" stroke-opacity=".55" stroke-dasharray="4 5"/>')
        out.append(t(px(0) + 8, y + 20, "z = 0", cls="pl-axis-label"))
        return "".join(out)
    note = "sigmoid / tanh：两端饱和，梯度趋零|ReLU：正半轴梯度恒为 1，负半轴死亡|GELU：平滑门控，Transformer 常用|选择看任务、初始化与数值稳定"
    caption = "<b>读图：</b>四条曲线都是「把线性输出压成非线性」的不同方式。看三个位置：<b>z→±∞</b> 是否饱和、<b>z=0</b> 附近是否平滑、<b>负半轴</b> 是否还有梯度。深度网络里，饱和会把反向传播的梯度吃掉；ReLU 用「死亡」换来了稀疏与速度。"
    return plot_plate(uid, "DEEP LEARNING · ACTIVATIONS / 08", "激活函数：非线性到底从哪来",
                      "同一个仿射输出，经过不同门控，得到不同的梯度形状。", draw, caption, "cyan", "D-08", note)


def fig_dl_mlp():
    uid = "dl-mlp"
    layers = [("输入 x", 4, "cyan"), ("隐藏 h₁", 6, "accent"), ("隐藏 h₂", 5, "plum"), ("输出 ŷ", 3, "gold")]
    caption = "<b>读图：</b>把每层读成一次 <b>Wᵀh + b</b>：上一层的向量被矩阵搬到新维度，再加偏置、过激活。左边是网络结构，右边是张量形状；两张图说的是同一件事，只是后者把 batch 维写了出来。"
    return network_plate(uid, "DEEP LEARNING · MLP / 09", "MLP：一层就是一次矩阵乘",
                         "前向传播是「线性变换 + 逐元素激活」的重复。",
                         layers, caption, "cyan", "D-09",
                         ["x  : (B, 784)", "h₁ : (B, 128)", "h₂ : (B, 64)", "ŷ  : (B, 10)"], height=448)


def fig_numerical_subspaces():
    uid = "numerical-subspaces"
    body = []
    body.append(f'<rect x="56" y="150" width="300" height="196" rx="14" fill="var(--paper)" fill-opacity=".72" stroke="var(--line)" stroke-opacity=".8"/>')
    body.append(t(76, 176, "出发端  ℝⁿ", cls="pl-mono", fill=TONES["accent"]))
    body.append(f'<rect x="76" y="192" width="260" height="54" rx="8" fill="{TONES["accent"]}" fill-opacity=".12" stroke="{TONES["accent"]}" stroke-opacity=".35"/>')
    body.append(t(96, 215, "行空间  row(A)", cls="pl-label", fill=TONES["accent"]))
    body.append(t(96, 234, "dim = r", cls="pl-mono", fill=TONES["accent"]))
    body.append(f'<rect x="76" y="270" width="260" height="54" rx="8" fill="{TONES["plum"]}" fill-opacity=".08" stroke="{TONES["plum"]}" stroke-opacity=".3"/>')
    body.append(t(96, 293, "零空间  null(A)", cls="pl-label", fill=TONES["plum"]))
    body.append(t(96, 312, "dim = n − r", cls="pl-mono", fill=TONES["plum"]))
    body.append(f'<rect x="544" y="150" width="300" height="196" rx="14" fill="var(--paper)" fill-opacity=".72" stroke="var(--line)" stroke-opacity=".8"/>')
    body.append(t(564, 176, "到达端  ℝᵐ", cls="pl-mono", fill=TONES["cyan"]))
    body.append(f'<rect x="564" y="192" width="260" height="54" rx="8" fill="{TONES["cyan"]}" fill-opacity=".1" stroke="{TONES["cyan"]}" stroke-opacity=".32"/>')
    body.append(t(584, 215, "列空间  col(A)", cls="pl-label", fill=TONES["cyan"]))
    body.append(t(584, 234, "dim = r", cls="pl-mono", fill=TONES["cyan"]))
    body.append(f'<rect x="564" y="270" width="260" height="54" rx="8" fill="{TONES["gold"]}" fill-opacity=".08" stroke="{TONES["gold"]}" stroke-opacity=".3"/>')
    body.append(t(584, 293, "左零空间  null(Aᵀ)", cls="pl-label", fill=TONES["gold"]))
    body.append(t(584, 312, "dim = m − r", cls="pl-mono", fill=TONES["gold"]))
    body.append(arrow(340, 219, 556, 219, TONES["accent"], 2.2, label="A", label_dy=-10))
    body.append(t(448, 244, "同构", cls="pl-axis-label", anchor="middle", fill=TONES["accent"]))
    body.append(arrow(338, 297, 404, 297, TONES["plum"], 1.8, dashed=True))
    body.append(f'<circle cx="422" cy="297" r="14" fill="{TONES["plum"]}" fill-opacity=".08" stroke="{TONES["plum"]}" stroke-opacity=".45"/>')
    body.append(t(422, 301, "0", cls="pl-mono", anchor="middle", fill=TONES["plum"]))
    body.append(t(448, 320, "Ax = 0", cls="pl-small", anchor="middle", fill=TONES["plum"]))
    body.append(t(450, 376, "row(A) ⊥ null(A)    ·    col(A) ⊥ null(Aᵀ)", cls="pl-mono", anchor="middle", fill=TONES["gold"]))
    body.append(t(450, 400, "维数账本：r + (n−r) = n    r + (m−r) = m", cls="pl-mono", anchor="middle", fill=TONES["gold"]))
    caption = "<b>读图：</b>四个框两两配对：<b>行空间 ↔ 零空间</b>在出发端拼成整个 ℝⁿ，<b>列空间 ↔ 左零空间</b>在到达端拼成 ℝᵐ。A 在行空间上是<b>同构</b>，把零空间压成 0；秩 r 是这两本维数账本的同一个数。虚线标出「A 把零空间映成 0」，它不连接零空间与左零空间。"
    return plate(uid, 424, "NUMERICAL · LINEAR ALGEBRA / 10", "四个基本子空间与秩",
                 "A 把 ℝⁿ 劈成行空间与零空间，把 ℝᵐ 劈成列空间与左零空间。",
                 "".join(body), "accent", "N-10", caption)


def fig_robot_euler():
    uid = "robot-euler"
    body = []
    cx, cy = 300, 270
    # 三个万向环
    for r, color, label, tilt in [(142, TONES["accent"], "ZYZ", 0), (108, TONES["cyan"], "β", 1), (74, TONES["gold"], "γ", 2)]:
        body.append(f'<ellipse cx="{cx}" cy="{cy}" rx="{r}" ry="{r*0.42}" fill="none" stroke="{color}" stroke-width="2" stroke-opacity=".65" transform="rotate({-18 + tilt*9} {cx} {cy})"/>')
        body.append(f'<circle cx="{cx + r*0.94:.1f}" cy="{cy - r*0.18:.1f}" r="4" fill="{color}"/>')
    body.append(f'<circle cx="{cx}" cy="{cy}" r="9" fill="var(--paper)" stroke="{TONES["accent"]}" stroke-width="2"/>')
    body.append(arrow(cx, cy, cx + 118, cy - 54, TONES["red"], 2, label="x", label_dy=-8))
    body.append(arrow(cx, cy, cx - 88, cy + 62, TONES["green"], 2, label="y", label_dy=12))
    body.append(arrow(cx, cy, cx, cy - 118, TONES["accent"], 2, label="z", label_dy=-8))
    # 三个角标
    body.append(chip(492, 172, "φ  绕 z", TONES["accent"], w=94))
    body.append(chip(492, 216, "ϑ  绕 y′", TONES["cyan"], w=94))
    body.append(chip(492, 260, "ψ  绕 z″", TONES["gold"], w=94))
    body.append(t(492, 306, "ZYZ：内旋三次，顺序不能换。", cls="pl-small"))
    # 万向节锁
    body.append(f'<rect x="492" y="326" width="344" height="54" rx="10" fill="{TONES["red"]}" fill-opacity=".06" stroke="{TONES["red"]}" stroke-opacity=".28"/>')
    body.append(t(510, 348, "表示奇点  ϑ = 0 或 π", cls="pl-mono", fill=TONES["red"]))
    body.append(t(510, 367, "首末转轴共线，首末角不能独立反解。", cls="pl-small"))
    caption = "<b>读图：</b>ZYZ 是「先绕 z 转 φ，再绕新 y 转 ϑ，最后绕新 z 转 ψ」的当前轴序列。圆环仅表示三个参数，不是给定角度的几何投影。ϑ=0 时只能确定 φ+ψ，ϑ=π 时只能确定 φ−ψ；这是表示退化，不表示刚体真实转动自由度消失。"
    return plate(uid, 410, "ROBOTICS · EULER ANGLES / 11", "欧拉角：三个环，三次旋转",
                 "ZYZ 与 RPY 都是把姿态拆成三个可读的角，但读数依赖顺序，也会遇到万向节锁。",
                 "".join(body), "accent", "R-11", caption)


def fig_matrix_eigen():
    uid = "matrix-eigen"
    def draw(x, y, w, h):
        out = [plot_axes(x, y, w, h, "x", "y")]
        out.append(f'<defs><clipPath id="{uid}-clip"><rect x="{x+1}" y="{y+1}" width="{w-2}" height="{h-2}" rx="8"/></clipPath></defs>')
        out.append(f'<g clip-path="url(#{uid}-clip)">')
        cx, cy = x + w / 2, y + h / 2
        scale = 46
        A = ((1.8, 0.6), (0.4, 0.9))
        def tr(u, v):
            return (cx + (A[0][0] * u + A[0][1] * v) * scale, cy - (A[1][0] * u + A[1][1] * v) * scale)
        def raw(u, v):
            return (cx + u * scale, cy - v * scale)
        for k in range(-2, 3):
            a, b = raw(k, -2), raw(k, 2)
            out.append(f'<path d="M{a[0]:.1f} {a[1]:.1f} L{b[0]:.1f} {b[1]:.1f}" stroke="var(--line-strong)" stroke-opacity=".3" stroke-dasharray="2 5"/>')
            a, b = raw(-2, k), raw(2, k)
            out.append(f'<path d="M{a[0]:.1f} {a[1]:.1f} L{b[0]:.1f} {b[1]:.1f}" stroke="var(--line-strong)" stroke-opacity=".3" stroke-dasharray="2 5"/>')
        for k in range(-2, 3):
            a, b = tr(k, -2), tr(k, 2)
            out.append(f'<path d="M{a[0]:.1f} {a[1]:.1f} L{b[0]:.1f} {b[1]:.1f}" stroke="{TONES["accent"]}" stroke-opacity=".3" stroke-width="1.2"/>')
            a, b = tr(-2, k), tr(2, k)
            out.append(f'<path d="M{a[0]:.1f} {a[1]:.1f} L{b[0]:.1f} {b[1]:.1f}" stroke="{TONES["accent"]}" stroke-opacity=".3" stroke-width="1.2"/>')
        circle = [raw(math.cos(t), math.sin(t)) for t in [i * math.pi / 60 for i in range(120)]]
        out.append(poly_path(circle, TONES["muted"], 1.3, True))
        ellipse = [tr(math.cos(t), math.sin(t)) for t in [i * math.pi / 60 for i in range(120)]]
        out.append(poly_path(ellipse, TONES["gold"], 2.8, fill=True, close=True))
        for vec, color, label, ly in [((0.94, 0.34), TONES["gold"], "v₁", -12), ((-0.47, 0.88), TONES["cyan"], "v₂", -8)]:
            e = raw(vec[0] * 2.4, vec[1] * 2.4)
            out.append(arrow(cx, cy, e[0], e[1], color, 2.2))
            out.append(t(e[0] + 8, e[1] + ly, label, cls="pl-mono", fill=color))
        out.append('</g>')
        out.append(t(x + w / 2, y + h + 20, "灰色虚线：原网格 / 单位圆　　彩色：A 作用之后", cls="pl-axis-label", anchor="middle"))
        return "".join(out)
    note = "特征向量：A v = λ v|方向不变，只伸缩 λ 倍|λ₁ ≈ 2.02  → 拉伸|λ₂ ≈ 0.69  → 压缩"
    caption = "<b>读图：</b>把单位圆和正交网格一起做 A 变换：网格变成斜网格，圆变成椭圆。绝大多数方向都被「转了一下」，只有两条特殊方向保持原方向、只改变长度——那就是<b>特征方向</b>，长度比就是<b>特征值</b>。这里 λ₁ &gt; 1（拉伸），λ₂ &lt; 1（压缩）。"
    return plot_plate(uid, "MATRIX · EIGEN / 12", "特征向量：变换中不转的那两条线",
                      "A 把圆压成椭圆；椭圆的长短轴方向，就是特征方向。", draw, caption, "gold", "M-12", note)


def fig_robot_dh():
    uid = "robot-dh"
    body = []
    operations = [
        ("① Rot_z(θᵢ)", "绕当前 z 转", "关节 i 的正轴为 zᵢ₋₁"),
        ("② Trans_z(dᵢ)", "沿当前 z 移", "到公垂线的垂足"),
        ("③ Trans_x(aᵢ)", "沿当前 x 移", "沿公垂线到新原点"),
        ("④ Rot_x(αᵢ)", "绕当前 x 转", "把 z 转到 zᵢ"),
    ]
    for index, (operation, action, meaning) in enumerate(operations):
        horizontal = 32 + 213 * index
        body.append(f'<rect x="{horizontal}" y="145" width="195" height="120" rx="8" fill="var(--paper)" stroke="var(--line)"/>')
        body.append(t(horizontal + 97, 175, operation, cls="pl-mono", anchor="middle", fill=TONES["accent"]))
        body.append(t(horizontal + 97, 208, action, cls="pl-small", anchor="middle"))
        body.append(t(horizontal + 97, 242, meaning, cls="pl-note", anchor="middle"))
        if index < 3:
            body.append(t(horizontal + 204, 209, "→", cls="pl-mono", anchor="middle"))
    body.append(t(450, 303, "从系 i−1 起步，按当前轴逐步右乘，最后得到系 i 的位姿", cls="pl-small", anchor="middle"))
    body.append(t(450, 335, "四因子作用到一个列向量时，仍从最右侧先算", cls="pl-note", anchor="middle"))
    body.append(t(450, 375, "固定几何的 R 行：θᵢ 变化；P 行：dᵢ 变化。aᵢ、αᵢ 恒定。", cls="pl-small", anchor="middle"))
    caption = "<b>读图：</b>本书标准 DH 的每一行都用 aᵢ、αᵢ、dᵢ、θᵢ。箭头是构造坐标系的时序，各步绕或沿当前轴，故在乘积中依次右乘；用矩阵换算点坐标时则从右向左作用。四参数依赖选系，并不把一般刚体位姿的六维自由度改成四维。"
    return plate(uid, 420, "ROBOTICS · DH PARAMETERS / 13", "标准 DH：一行参数，四步建系",
                 "先定轴向、原点与零位，再沿同一套约定连乘。",
                 "".join(body), "accent", "R-13", caption)


def fig_robot_trajectory():
    uid = "robot-trajectory"
    def draw_path(x, y, w, h):
        out = [plot_axes(x, y, w, h, "x", "y")]
        cx, cy = x + w / 2, y + h / 2
        pts = []
        for i in range(100):
            u = i / 99
            px = cx - 190 + 380 * u
            py = cy + 70 * math.sin(u * math.pi * 1.5) - 40 * u
            pts.append((px, py))
        out.append(poly_path(pts, TONES["accent"], 3, fill=False))
        # 路径点
        for idx in (0, 30, 60, 99):
            px, py = pts[idx]
            out.append(dot(px, py, TONES["gold"], 5))
            out.append(t(px + 9, py - 8, "q" + str(idx), cls="pl-mono", fill=TONES["gold"]))
        # 路径 vs 轨迹
        out.append(t(cx, y + 22, "路径：空间中的曲线", cls="pl-mono", anchor="middle", fill=TONES["accent"]))
        out.append(t(cx, y + 42, "只有几何，没有时间", cls="pl-small", anchor="middle"))
        return "".join(out)
    def draw_time(x, y, w, h):
        out = [plot_axes(x, y, w, h, "t", "")]
        sx = lambda u: x + 30 + u * (w - 52)
        sy = lambda v: y + h - 18 - v * (h - 44)
        p = [(sx(i/99), sy(0.04 + 0.86 * (0.5 - 0.5*math.cos(math.pi*i/99)))) for i in range(100)]
        v = [(sx(i/99), sy(0.04 + 0.72*math.sin(math.pi*i/99))) for i in range(100)]
        out.append(poly_path(v + [(sx(1), sy(0.04)), (sx(0), sy(0.04))], TONES["gold"], 1.4, fill=True, close=True))
        out.append(poly_path(v, TONES["gold"], 2.4))
        out.append(poly_path(p, TONES["accent"], 2.6))
        out.append(f'<path d="M{sx(.5)} {y+8} V{y+h-18}" stroke="var(--line-strong)" stroke-opacity=".45" stroke-dasharray="3 5"/>')
        out.append(t(x + 14, y + 24, "s(t)", cls="pl-mono", fill=TONES["accent"]))
        out.append(t(x + 14, y + 42, "v(t)", cls="pl-mono", fill=TONES["gold"]))
        out.append(t(sx(.5), y + 24, "T/2", cls="pl-axis-label", anchor="middle"))
        out.append(t(sx(1), y + h + 20, "T", cls="pl-axis-label", anchor="end"))
        out.append(t(x + w/2, y + 20, "轨迹：再加一条时间律", cls="pl-mono", anchor="middle", fill=TONES["gold"]))
        return "".join(out)

    # 自己拼两块
    body = []
    body.append(draw_path(32, 130, 408, 250))
    body.append(draw_time(470, 130, 398, 250))
    body.append(arrow(444, 255, 466, 255, TONES["accent"], 2))
    body.append(t(450, 402, "同一条几何路径，配上不同的 s(t)，就是不同的轨迹。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>左边只回答「经过哪些点」，是<b>路径规划</b>；右边再给每个点一个时刻，是<b>轨迹规划</b>。同一个几何路径可以配无数条时间律——不同的速度、加速度、平滑度，会直接改变电机与机械结构的负担。"
    return plate(uid, 430, "ROBOTICS · TRAJECTORY / 14", "路径 vs 轨迹：几何之外，还要时间",
                 "路径只描述「走哪条线」；轨迹还要说明「什么时候到哪」。",
                 "".join(body), "cyan", "R-14", caption)


def fig_dl_transformer():
    uid = "dl-transformer"
    body = []
    # 编码器
    ex, ey, ew = 74, 146, 196
    body.append(f'<rect x="{ex}" y="{ey}" width="{ew}" height="238" rx="14" fill="{TONES["accent"]}" fill-opacity=".04" stroke="{TONES["accent"]}" stroke-opacity=".32"/>')
    body.append(t(ex + 18, ey + 28, "ENCODER × N", cls="pl-kicker", fill=TONES["accent"]))
    blocks = [("Multi-Head\nSelf-Attention", "accent"), ("Add & Norm", "muted"), ("Feed-Forward", "cyan"), ("Add & Norm", "muted")]
    for i, (label, tone) in enumerate(blocks):
        bx, by = ex + 16, ey + 48 + i * 44
        color = TONES[tone]
        body.append(f'<rect x="{bx}" y="{by}" width="{ew-32}" height="28" rx="7" fill="var(--paper)" stroke="{color}" stroke-opacity=".4"/>')
        for j, part in enumerate(label.split("\n")):
            body.append(t(bx + 10, by + 18 + j * 11, part, cls="pl-small", fill=color if tone != "muted" else "var(--muted)", size="10.5" if j == 0 else "9.5"))
    # 解码器
    dx, dy, dw = 340, 146, 210
    body.append(f'<rect x="{dx}" y="{dy}" width="{dw}" height="238" rx="14" fill="{TONES["plum"]}" fill-opacity=".04" stroke="{TONES["plum"]}" stroke-opacity=".32"/>')
    body.append(t(dx + 18, dy + 28, "DECODER × N", cls="pl-kicker", fill=TONES["plum"]))
    dblocks = [("Masked Self-Attn", "plum"), ("Add & Norm", "muted"), ("Cross-Attention", "gold"), ("Feed-Forward", "cyan")]
    for i, (label, tone) in enumerate(dblocks):
        bx, by = dx + 16, dy + 48 + i * 44
        color = TONES[tone]
        body.append(f'<rect x="{bx}" y="{by}" width="{dw-32}" height="28" rx="7" fill="var(--paper)" stroke="{color}" stroke-opacity=".4"/>')
        body.append(t(bx + 10, by + 18, label, cls="pl-small", fill=color if tone != "muted" else "var(--muted)", size="10.5"))
    # 右侧注意力热图
    hx, hy, cell = 610, 158, 20
    body.append(f'<rect x="{hx-18}" y="{hy-18}" width="248" height="246" rx="14" fill="var(--paper)" fill-opacity=".72" stroke="var(--line)" stroke-opacity=".8"/>')
    body.append(t(hx, hy - 2, "注意力矩阵", cls="pl-kicker", fill=TONES["gold"]))
    weights = [[0.7,0.2,0.05,0.05],[0.1,0.6,0.2,0.1],[0.05,0.15,0.7,0.1],[0.05,0.1,0.2,0.65]]
    for r in range(4):
        for c in range(4):
            val = weights[r][c]
            body.append(f'<rect x="{hx + c*cell}" y="{hy + 24 + r*cell}" width="{cell-3}" height="{cell-3}" rx="3" fill="{TONES["gold"]}" fill-opacity="{0.06 + 0.8*val:.2f}"/>')
    body.append(t(hx + 40, hy + 130, "每个位置", cls="pl-small"))
    body.append(t(hx + 40, hy + 148, "看谁更多？", cls="pl-small"))
    body.append(t(hx + 40, hy + 180, "行 = query · 列 = key", cls="pl-mono", fill=TONES["gold"], size="9.5"))
    # 箭头
    body.append(arrow(278, 250, 332, 250, TONES["muted"], 1.8))
    body.append(t(305, 240, "K, V", cls="pl-mono", fill=TONES["muted"], anchor="middle"))
    caption = "<b>读图：</b>左边编码器把输入序列压成上下文表示；右边解码器在生成每个词时做两件事——<b>masked self-attention</b> 看已生成的前文，<b>cross-attention</b> 回看编码器。右下角热图只是把「每个 query 分给各个 key 的权重」画出来。"
    return plate(uid, 430, "DEEP LEARNING · TRANSFORMER / 15", "Transformer：把注意力堆成主干",
                 "编码器负责「理解」，解码器负责「生成」；两者共享同一个注意力算子。",
                 "".join(body), "plum", "D-15", caption)




def fig_numerical_svd():
    uid = "numerical-svd"
    body = []
    lx, ly, lw, lh = 32, 140, 448, 246
    body.append(f'<defs><clipPath id="{uid}-clip"><rect x="{lx+1}" y="{ly+1}" width="{lw-2}" height="{lh-2}" rx="12"/></clipPath></defs><g clip-path="url(#{uid}-clip)">')
    # 左：圆 → 椭圆
    body.append(f'<rect x="{lx}" y="{ly}" width="{lw}" height="{lh}" rx="12" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/>')
    cx, cy = lx + lw / 2, ly + lh / 2 + 8
    scale = 68
    theta = math.radians(18)
    phi = math.radians(34)
    s1, s2 = 1.85, 0.72
    def A(x, y):
        # U Σ V^T
        xv = math.cos(phi) * x + math.sin(phi) * y
        yv = -math.sin(phi) * x + math.cos(phi) * y
        xv, yv = s1 * xv, s2 * yv
        return (math.cos(theta) * xv - math.sin(theta) * yv, math.sin(theta) * xv + math.cos(theta) * yv)
    for k in range(-2, 3):
        a = (cx + k * scale, cy - 2 * scale); b = (cx + k * scale, cy + 2 * scale)
        body.append(f'<path d="M{a[0]} {a[1]} L{b[0]} {b[1]}" stroke="var(--line-strong)" stroke-opacity=".28" stroke-dasharray="2 5"/>')
        a = (cx - 2 * scale, cy - k * scale); b = (cx + 2 * scale, cy - k * scale)
        body.append(f'<path d="M{a[0]} {a[1]} L{b[0]} {b[1]}" stroke="var(--line-strong)" stroke-opacity=".28" stroke-dasharray="2 5"/>')
    # 变换后的网格
    for k in range(-2, 3):
        pts1 = [(cx + A(k, t)[0] * scale, cy - A(k, t)[1] * scale) for t in (-2, 2)]
        pts2 = [(cx + A(t, k)[0] * scale, cy - A(t, k)[1] * scale) for t in (-2, 2)]
        body.append(poly_path(pts1, TONES["accent"], 1.15))
        body.append(poly_path(pts2, TONES["accent"], 1.15))
    circle = [(cx + math.cos(t) * scale, cy - math.sin(t) * scale) for t in [i * math.pi / 72 for i in range(144)]]
    body.append(poly_path(circle, TONES["muted"], 1.3, True))
    ellipse = [(cx + A(math.cos(t), math.sin(t))[0] * scale, cy - A(math.cos(t), math.sin(t))[1] * scale) for t in [i * math.pi / 72 for i in range(144)]]
    body.append(poly_path(ellipse, TONES["gold"], 2.7, fill=True, close=True))
    for (ux, uy), color, label, length in [((math.cos(theta), math.sin(theta)), TONES["gold"], "σ₁", s1), ((math.cos(theta + math.pi/2), math.sin(theta + math.pi/2)), TONES["cyan"], "σ₂", s2)]:
        ax, ay = ux * length * scale, uy * length * scale
        body.append(arrow(cx, cy, cx + ax, cy - ay, color, 2.2))
        body.append(t(cx + ax * 1.08, cy - ay * 1.08 + (12 if label.startswith("σ₂") else -2), label, cls="pl-mono", fill=color, anchor="middle", size="11"))
    body.append(t(lx + 22, ly + 26, "A 把单位圆变成椭圆", cls="pl-mono", fill=TONES["accent"]))
    body.append(t(lx + 22, ly + 45, "半轴长度 = 奇异值", cls="pl-small"))
    body.append("</g>")
    # 右：奇异值条形 / 截断
    rx, ry, rw, rh = 508, 140, 360, 246
    body.append(f'<rect x="{rx}" y="{ry}" width="{rw}" height="{rh}" rx="12" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/>')
    body.append(t(rx + 22, ry + 26, "奇异值谱与低秩截断", cls="pl-mono", fill=TONES["gold"]))
    sig = [2.1, 1.25, 0.62, 0.28, 0.09]
    base = ry + 188
    bw, gap = 42, 18
    for i, v in enumerate(sig):
        x = rx + 40 + i * (bw + gap)
        h = v / 2.2 * 120
        active = i < 2
        color = TONES["gold"] if active else TONES["muted"]
        body.append(f'<rect x="{x}" y="{base-h:.1f}" width="{bw}" height="{h:.1f}" rx="4" fill="{color}" fill-opacity="{0.78 if active else 0.18}" stroke="{color}" stroke-opacity="{.55 if active else .2}"/>')
        body.append(t(x + bw/2, base + 17, f"σ{i+1}", cls="pl-mono", anchor="middle", fill=color, size="9.5"))
        body.append(t(x + bw/2, base - h - 7, f"{v:.2f}", cls="pl-axis-label", anchor="middle"))
    cut = rx + 40 + 2 * (bw + gap) - gap/2
    body.append(f'<path d="M{cut} {ry+42} V{base+2}" stroke="{TONES["cyan"]}" stroke-dasharray="4 5" stroke-opacity=".8"/>')
    body.append(t(cut + 7, ry + 62, "k = 2", cls="pl-mono", fill=TONES["cyan"]))
    body.append(t(rx + 22, ry + 236, "保留最大的 k 个奇异值 → 秩 k 最优近似。", cls="pl-small"))
    body.append(t(450, 424, "A = U Σ Vᵀ     ·     Σ = diag(σ₁ ≥ σ₂ ≥ … ≥ 0)", cls="pl-mono", anchor="middle", fill=TONES["gold"], size="13"))
    caption = "<b>读图：</b>SVD 把任意矩阵拆成<b>旋转 → 沿坐标轴拉伸 → 再旋转</b>：Vᵀ 转过去，Σ 把单位圆拉成椭圆，U 再转回来。奇异值就是椭圆半轴的长度；只保留最大的 k 个，就得到秩 k 的最优近似（Eckart–Young）。"
    return plate(uid, 444, "NUMERICAL · SVD / 16", "SVD：圆变成椭圆，奇异值就是半轴",
                 "A = UΣVᵀ：先转、再拉、再转；奇异值谱决定「保留多少」。",
                 "".join(body), "gold", "N-16", caption)


def fig_matrix_kernel():
    uid = "matrix-kernel"
    body = []
    # 出发端
    body.append(f'<rect x="42" y="140" width="370" height="236" rx="14" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/>')
    body.append(t(64, 166, "出发端  ℝⁿ", cls="pl-mono", fill=TONES["accent"]))
    ox, oy, sc = 210, 300, 62
    for k in range(-2, 3):
        body.append(f'<path d="M{ox+k*sc} {oy-2*sc} V{oy+2*sc}" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/>')
        body.append(f'<path d="M{ox-2*sc} {oy-k*sc} H{ox+2*sc}" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/>')
    body.append(arrow(ox, oy, ox + 150, oy + 38, TONES["accent"], 3, label="x_row", label_dy=-10))
    body.append(arrow(ox, oy, ox - 78, oy + 54, TONES["plum"], 2.2, dashed=True, label="x_null", label_dy=16))
    body.append(f'<path d="M{ox-96} {oy+64} L{ox+72} {oy+92}" stroke="{TONES["plum"]}" stroke-width="4" stroke-opacity=".5"/>')
    body.append(t(ox+86, oy+110, "ker A", cls="pl-mono", fill=TONES["plum"], anchor="middle"))
    # 到达端
    body.append(f'<rect x="488" y="140" width="370" height="236" rx="14" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/>')
    body.append(t(510, 166, "到达端  ℝᵐ", cls="pl-mono", fill=TONES["cyan"]))
    ox2, oy2 = 655, 300
    for k in range(-2, 3):
        body.append(f'<path d="M{ox2+k*sc} {oy2-2*sc} V{oy2+2*sc}" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/>')
        body.append(f'<path d="M{ox2-2*sc} {oy2-k*sc} H{ox2+2*sc}" stroke="var(--line-strong)" stroke-opacity=".24" stroke-dasharray="2 5"/>')
    body.append(arrow(ox2, oy2, ox2 + 150, oy2 + 38, TONES["cyan"], 3, label="Ax = A x_row", label_dy=-10))
    body.append(f'<circle cx="{ox2}" cy="{oy2}" r="5" fill="var(--ink)"/>')
    body.append(t(ox2 - 8, oy2 + 22, "0", cls="pl-mono", anchor="end"))
    body.append(chip(510, 342, "A x_null = 0", TONES["plum"], w=132))
    # 中间箭头
    body.append(arrow(416, 256, 480, 256, TONES["accent"], 2.6, label="A", label_dy=-10))
    body.append(t(448, 282, "同构", cls="pl-axis-label", anchor="middle", fill=TONES["accent"]))
    # 标题 / 公式
    body.append(t(450, 400, "rank(A) + dim ker(A) = n", cls="pl-mono", anchor="middle", fill=TONES["gold"], size="13"))
    body.append(t(450, 424, "A 只看 x_row；x_null 被压成 0。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>把 x 拆成两半：<b>x_row</b> 落在行空间里，被 A 同构地送到列空间；<b>x_null</b> 落在核里，被 A 直接压成 0。于是「A 的像」只由 x_row 决定，秩与零空间维数的账本也就自然成立。"
    return plate(uid, 440, "MATRIX · KERNEL / 17", "核与像：A 到底丢掉了什么",
                 "x 被拆成行空间分量与核分量；前者决定像，后者被压成 0。",
                 "".join(body), "plum", "M-17", caption)


def fig_dl_neuron():
    uid = "dl-neuron"
    body = []
    # 输入
    ins = [(120, 150, "x₁"), (120, 200, "x₂"), (120, 250, "x₃"), (120, 300, "x₄")]
    for i, (x, y, label) in enumerate(ins):
        body.append(f'<circle cx="{x}" cy="{y}" r="17" fill="{TONES["cyan"]}" fill-opacity=".08" stroke="{TONES["cyan"]}" stroke-opacity=".45"/>')
        body.append(t(x, y + 4, label, cls="pl-mono", anchor="middle", fill=TONES["cyan"]))
    # 权重线
    sx, sy = 384, 224
    for i, (x, y, label) in enumerate(ins):
        body.append(f'<path d="M{x+18} {y} C 250 {y}, 300 {sy}, {sx-56} {sy}" fill="none" stroke="var(--muted)" stroke-opacity=".2" stroke-width="1.2"/>')
        body.append(t(250, y + (8 if i < 2 else -8), f"w{i+1}", cls="pl-mono", fill="var(--muted)", size="9.5"))
    # 神经元
    body.append(f'<circle cx="{sx}" cy="{sy}" r="62" fill="{TONES["accent"]}" fill-opacity=".06" stroke="{TONES["accent"]}" stroke-opacity=".38" stroke-width="1.6"/>')
    body.append(f'<circle cx="{sx}" cy="{sy}" r="48" fill="var(--paper)" stroke="{TONES["accent"]}" stroke-opacity=".25" stroke-width="1.2"/>')
    body.append(t(sx, sy + 2, "Σ", cls="pl-title", anchor="middle", size="36", fill=TONES["accent"]))
    body.append(t(sx, sy + 30, "加权求和", cls="pl-small", anchor="middle"))
    body.append(t(sx, sy - 80, "b（偏置）", cls="pl-mono", anchor="middle", fill=TONES["gold"], size="10"))
    # 激活
    ax, ay = 520, 224
    body.append(arrow(sx + 64, sy, ax - 4, ay, TONES["accent"], 2))
    body.append(f'<rect x="{ax}" y="{ay-42}" width="108" height="84" rx="12" fill="{TONES["gold"]}" fill-opacity=".06" stroke="{TONES["gold"]}" stroke-opacity=".35"/>')
    body.append(t(ax + 54, ay - 4, "φ(·)", cls="pl-title", anchor="middle", size="24", fill=TONES["gold"]))
    body.append(t(ax + 54, ay + 20, "激活函数", cls="pl-small", anchor="middle"))
    # 输出
    ox = 740
    body.append(arrow(ax + 110, ay, ox - 22, ay, TONES["gold"], 2))
    body.append(f'<circle cx="{ox}" cy="{ay}" r="24" fill="{TONES["green"]}" fill-opacity=".07" stroke="{TONES["green"]}" stroke-opacity=".4"/>')
    body.append(t(ox, ay + 5, "y", cls="pl-title", anchor="middle", size="22", fill=TONES["green"]))
    body.append(t(ox, ay + 48, "输出", cls="pl-small", anchor="middle"))
    # 公式
    body.append(f'<rect x="222" y="356" width="456" height="34" rx="10" fill="{TONES["accent"]}" fill-opacity=".06" stroke="{TONES["accent"]}" stroke-opacity=".22"/>')
    body.append(t(450, 378, "y = φ( w₁x₁ + w₂x₂ + w₃x₃ + w₄x₄ + b )", cls="pl-mono", anchor="middle", fill=TONES["accent"], size="12.5"))
    body.append(t(450, 420, "一个神经元 = 一次加权求和 + 一次非线性门控；堆起来就是网络。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>左边是输入，中间是<b>加权求和</b>，右边是<b>激活</b>。没有 φ，堆多少层都等价于一次线性变换；有了 φ，网络才有能力逼近非线性函数。偏置 b 让超平面可以平移。"
    return plate(uid, 442, "DEEP LEARNING · NEURON / 18", "一个神经元：加权、求和、再过一道门",
                 "y = φ(wᵀx + b)：线性组合负责「看什么」，激活函数负责「怎么响应」。",
                 "".join(body), "cyan", "D-18", caption)


def fig_robot_jacobian():
    uid = "robot-jacobian"
    body = []
    # 两连杆
    p0, p1, p2 = (230, 318), (330, 210), (470, 246)
    body.append(f'<path d="M{p0[0]} {p0[1]} L{p1[0]} {p1[1]}" stroke="{TONES["accent"]}" stroke-width="16" stroke-linecap="round" opacity=".22"/>')
    body.append(f'<path d="M{p1[0]} {p1[1]} L{p2[0]} {p2[1]}" stroke="{TONES["cyan"]}" stroke-width="14" stroke-linecap="round" opacity=".24"/>')
    body.append(f'<path d="M{p0[0]} {p0[1]} L{p1[0]} {p1[1]}" stroke="{TONES["accent"]}" stroke-width="5" stroke-linecap="round"/>')
    body.append(f'<path d="M{p1[0]} {p1[1]} L{p2[0]} {p2[1]}" stroke="{TONES["cyan"]}" stroke-width="4" stroke-linecap="round"/>')
    for (x, y), r, color, label in [(p0, 11, TONES["gold"], "q₁"), (p1, 9, TONES["gold"], "q₂"), (p2, 7, TONES["gold"], "TCP")]:
        body.append(f'<circle cx="{x}" cy="{y}" r="{r+4}" fill="var(--paper)" stroke="{color}" stroke-width="2"/>')
        body.append(t(x - r - 10, y - 2, label, cls="pl-mono", anchor="end", fill=color))
    # 关节角速度弧
    body.append(t(p0[0]-34, p0[1]+34, "q̇₁ = 0（锁住）", cls="pl-mono", anchor="middle", fill=TONES["plum"]))
    body.append(f'<path d="M{p1[0]-9} {p1[1]-25} A 26 26 0 0 0 {p1[0]-26} {p1[1]}" fill="none" stroke="{TONES["plum"]}" stroke-width="2" marker-end="url(#arrow-p)"/>')
    body.append(t(p1[0]-44, p1[1]-42, "q̇₂ = +1 rad/s", cls="pl-mono", fill=TONES["plum"]))
    # 末端速度
    body.append(arrow(p2[0], p2[1], p2[0] - 27, p2[1] - 105, TONES["red"], 2.6, label="v", label_dy=-10))
    body.append(f'<circle cx="510" cy="286" r="12" fill="none" stroke="{TONES["green"]}" stroke-width="2"/>')
    body.append(f'<circle cx="510" cy="286" r="3" fill="{TONES["green"]}"/>')
    body.append(t(510, 318, "ω：出纸面", cls="pl-small", anchor="middle", fill=TONES["green"]))
    # 右侧雅可比
    bx, by = 606, 146
    body.append(f'<rect x="{bx}" y="{by}" width="256" height="222" rx="14" fill="var(--paper)" fill-opacity=".58" stroke="var(--line)" stroke-opacity=".8"/>')
    body.append(t(bx+18, by+26, "平面位置块 Jₚ,xy（2×2）", cls="pl-kicker", fill=TONES["gold"]))
    body.append(t(bx+119, by+58, "关节 1", cls="pl-mono", anchor="middle", fill=TONES["plum"], size="10"))
    body.append(t(bx+189, by+58, "关节 2", cls="pl-mono", anchor="middle", fill=TONES["plum"], size="10"))
    cells = [("∂pₓ/∂q₁", "∂pₓ/∂q₂"), ("∂pᵧ/∂q₁", "∂pᵧ/∂q₂")]
    for r in range(2):
        for c in range(2):
            cx, cy = bx + 88 + c * 70, by + 68 + r * 52
            body.append(f'<rect x="{cx}" y="{cy}" width="62" height="42" rx="6" fill="{TONES["accent"]}" fill-opacity="{.1 if c == 0 else .05}" stroke="{TONES["accent"]}" stroke-opacity=".26"/>')
            body.append(t(cx+31, cy+26, cells[r][c], cls="pl-mono", anchor="middle", fill=TONES["accent"], size="11.5"))
    body.append(t(bx+76, by+94, "pₓ 行", cls="pl-mono", anchor="end", fill=TONES["muted"], size="10"))
    body.append(t(bx+76, by+146, "pᵧ 行", cls="pl-mono", anchor="end", fill=TONES["muted"], size="10"))
    body.append(t(bx+128, by+188, "角速度行另计：ωz = q̇₁ + q̇₂", cls="pl-small", anchor="middle"))
    body.append(t(bx+128, by+210, "完整几何雅可比为 6×2", cls="pl-small", anchor="middle"))
    body.append(t(450, 400, "(vₓ, vᵧ)ᵀ = Jₚ,xy(q) q̇；ω 的正方向沿 +z 出纸面。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>右表只列<b>位置对关节角的偏导</b>，乘关节速度后得到平面线速度；完整几何雅可比还包括角速度行。左图锁住关节 1，关节 2 以 +1 rad/s 逆时针转动，v 垂直于第二杆、朝左上，ω 沿 +z 出纸面。速度箭头长度仅为示意，未给定杆长。"
    return plate(uid, 420, "ROBOTICS · JACOBIAN / 19", "雅可比：把关节速度翻译成末端速度",
                 "v = J(q)q̇；J 的每一列，都是一个关节对末端的「贡献方向」。",
                 "".join(body), "red", "R-19", caption)




def fig_numerical_condition():
    uid = "numerical-condition"
    body = []
    def panel(x, y, w, h, s1, s2, title, color, cond):
        out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" fill="var(--paper)" fill-opacity=".55" stroke="var(--line)" stroke-opacity=".75"/>']
        out.append(t(x + 20, y + 26, title, cls="pl-mono", fill=color))
        cx, cy = x + w / 2, y + h / 2 + 12
        scale = 46
        for k in range(-2, 3):
            out.append(f'<path d="M{cx+k*scale} {cy-2*scale} V{cy+2*scale}" stroke="var(--line-strong)" stroke-opacity=".2" stroke-dasharray="2 5"/>')
            out.append(f'<path d="M{cx-2*scale} {cy-k*scale} H{cx+2*scale}" stroke="var(--line-strong)" stroke-opacity=".2" stroke-dasharray="2 5"/>')
        circle = [(cx + math.cos(tt) * scale, cy - math.sin(tt) * scale) for tt in [i * math.pi / 72 for i in range(144)]]
        out.append(poly_path(circle, TONES["muted"], 1.3, True))
        ellipse = [(cx + math.cos(tt) * s1 * scale, cy - math.sin(tt) * s2 * scale) for tt in [i * math.pi / 72 for i in range(144)]]
        out.append(poly_path(ellipse, color, 2.4, fill=True, close=True))
        out.append(t(cx, y + h - 42, f"σ₁ / σ₂ = {s1:.1f} / {s2:.2f}", cls="pl-mono", anchor="middle", fill=color, size="10.5"))
        out.append(t(cx, y + h - 20, f"κ = {cond:.1f}", cls="pl-mono", anchor="middle", fill=TONES["gold"], size="12"))
        return "".join(out)
    body.append(panel(32, 140, 400, 236, 1.55, 1.25, "良条件：圆几乎还是圆", TONES["cyan"], 1.24))
    body.append(panel(468, 140, 400, 236, 2.1, 0.3, "病态：圆被压成细椭圆", TONES["red"], 7.0))
    body.append(t(450, 244, "同一个扰动 →", cls="pl-mono", anchor="middle", fill=TONES["muted"]))
    body.append(t(450, 268, "不同程度的放大", cls="pl-small", anchor="middle"))
    body.append(arrow(436, 256, 462, 256, TONES["gold"], 2))
    body.append(t(450, 402, "κ(A) = σmax / σmin：条件数把「输入的小扰动」换算成「输出的大误差」。", cls="pl-note", anchor="middle"))
    caption = "<b>读图：</b>左图里单位圆的像接近圆，输入扰动经过 A 后基本不变形；右图里同一个圆被压成细椭圆，短轴方向上的小扰动会被放大成很大的相对误差。条件数 <b>κ = σmax / σmin</b> 是这个最坏放大倍数，描述问题本身的敏感性；算法稳定性是另一件事。"
    return plate(uid, 424, "NUMERICAL · CONDITION / 20", "条件数：问题本身有多敏感",
                 "同一个圆，经过良条件矩阵几乎不变形，经过病态矩阵会被压成细椭圆。",
                 "".join(body), "red", "N-20", caption)


def fig_num_linear_systems():
    uid = "num-linear-systems"
    steps = [
        ("01", "看结构", "稠密 / 稀疏 / 病态", "gold"),
        ("02", "直接法", "Gauss · 列主元 · LU", "accent"),
        ("03", "三角求解", "Ly=b → Ux=y", "cyan"),
        ("04", "迭代法", "x_{k+1}=Gx_k+d", "plum"),
        ("05", "收敛判据", "ρ(G)<1 / ‖G‖<1", "green"),
    ]
    caption = ("<b>读图：</b>先判断矩阵结构，再选算法。稠密小规模用列主元/LU；三对角用追赶法 O(n)；"
               "大规模稀疏用迭代法，但先要过 <b>ρ(G)&lt;1</b> 或 <b>‖G‖&lt;1</b> 这一关。直接法与迭代法不是二选一，"
               "而是同一张决策图上的两条分支。")
    return flow_plate(uid, "NUMERICAL · LINEAR SYSTEMS / 02", "先看结构，再选算法",
                      "直接法与迭代法不是二选一，而是同一张决策图上的两条分支。",
                      steps, caption, tone="cyan", atlas_no="N-21",
                      feedback=("病态？先看 cond(A)", 300, 16),
                      note="稀疏三对角 → 追赶法 O(n)；稠密小规模 → 列主元 LU。",
                      height=380)


def fig_num_power():
    uid = "num-power"

    def draw(x, y, w, h):
        def X(k):
            return x + k / 20 * w

        def Y(v):
            return y + h - (v + 6) / 6 * h

        out = [plot_axes(x, y, w, h, xlabel="", ylabel="log10 误差",
                         xticks=[("0", X(0)), ("5", X(5)), ("10", X(10)), ("15", X(15)), ("20", X(20))],
                         yticks=[("0", Y(0)), ("-2", Y(-2)), ("-4", Y(-4)), ("-6", Y(-6))])]
        out.append(t(x + w / 2, y + h + 36, "迭代步 k", cls="pl-axis-label", anchor="middle"))
        for q, color, label in [(0.9, TONES["red"], "q=0.9"),
                                (0.6, TONES["gold"], "q=0.6"),
                                (0.3, TONES["cyan"], "q=0.3")]:
            pts = []
            for k in range(21):
                lv = max(-6.0, k * math.log10(q))
                pts.append((X(k), Y(lv)))
            out.append(poly_path(pts, color, 2.2))
            last = max(-6.0, 19 * math.log10(q))
            out.append(t(X(19), Y(last) - 8, label, cls="pl-mono", fill=color, anchor="end", size="10.5"))
        out.append(t(X(10), Y(-5.35), "半对数坐标：斜率 = log10 q", cls="pl-small", anchor="middle", fill=TONES["muted"]))
        return "".join(out)

    caption = ("<b>读图：</b>幂法误差按 <b>q^k</b> 几何下降，q = |λ₂|/|λ₁|。三条线在半对数坐标下都是直线，"
               "斜率就是 log10 q：q 越接近 1，谱间隙越小，收敛越慢；q=0.3 时十几步就到机器精度，q=0.9 时"
               "二十步才降一个量级。")
    return plot_plate(uid, "NUMERICAL · POWER METHOD / 03", "幂法：误差按 q^k 缩",
                      "q = |λ₂| / |λ₁|；谱间隙越小，收敛越慢。", draw, caption,
                      tone="plum", atlas_no="N-22",
                      note="q=0.9：20 步只降约 1 个量级|q=0.6：20 步降约 4 个量级|q 由谱间隙决定|q 越接近 1 越慢")


def fig_num_newton():
    uid = "num-newton"

    def draw(x, y, w, h):
        xmin, xmax = 1.0, 2.0
        ymin, ymax = -1.2, 2.2

        def X(v):
            return x + (v - xmin) / (xmax - xmin) * w

        def Y(v):
            return y + h - (v - ymin) / (ymax - ymin) * h

        out = [plot_axes(x, y, w, h, xlabel="", ylabel="f(x)",
                         xticks=[("1.0", X(1.0)), ("1.5", X(1.5)), ("2.0", X(2.0))],
                         yticks=[("-1", Y(-1)), ("0", Y(0)), ("1", Y(1)), ("2", Y(2))])]
        out.append(t(x + w / 2, y + h + 36, "x", cls="pl-axis-label", anchor="middle"))
        out.append(f'<path d="M{X(xmin)} {Y(0)} H{X(xmax)}" stroke="var(--line-strong)" stroke-opacity=".55" stroke-width="1.2"/>')
        pts = []
        for i in range(121):
            xv = xmin + i * (xmax - xmin) / 120
            pts.append((X(xv), Y(xv * xv - 2)))
        out.append(poly_path(pts, TONES["accent"], 2.4))
        x0, f0, fp = 1.8, 1.8 * 1.8 - 2, 2 * 1.8
        xt = x0 - f0 / fp
        x1, f1 = 1.2, 1.2 * 1.2 - 2
        xs = x1 - f1 * (x1 - x0) / (f1 - f0)
        out.append(poly_path([(X(x0), Y(f0)), (X(xt), Y(0))], TONES["cyan"], 1.9))
        out.append(poly_path([(X(x0), Y(f0)), (X(x1), Y(f1))], TONES["gold"], 1.9))
        out.append(dot(X(x0), Y(f0), TONES["cyan"], 5, "x0", "end"))
        out.append(dot(X(x1), Y(f1), TONES["gold"], 5, "x1", "end"))
        out.append(dot(X(xt), Y(0), TONES["cyan"], 4))
        out.append(dot(X(xs), Y(0), TONES["gold"], 4))
        out.append(dot(X(math.sqrt(2)), Y(0), TONES["red"], 4, "s"))
        out.append(t(X(1.62), Y(1.35), "切线", cls="pl-mono", fill=TONES["cyan"], size="10.5"))
        out.append(t(X(1.46), Y(-0.75), "割线", cls="pl-mono", fill=TONES["gold"], size="10.5"))
        out.append(t(X(1.88), Y(0.25), "f(x)=x²−2", cls="pl-small", fill=TONES["accent"], size="10"))
        return "".join(out)

    caption = ("<b>读图：</b>牛顿法在 x_k 处作切线，切线与 x 轴的交点就是下一步；割线法用过两点的割线替代切线。"
               "前者需要 f′(x_k)、二阶收敛；后者不需要导数、但需要两个初值，收敛阶降为 1.618。")
    return plot_plate(uid, "NUMERICAL · NEWTON / 04", "切线 vs 割线：一步之差",
                      "牛顿用一点加导数，割线用两点加差商。", draw, caption,
                      tone="cyan", atlas_no="N-23",
                      note="切线：一点 + f′(x_k)|割线：两点 + 差商|牛顿：二阶，需导数|割线：1.618，需两初值")


def fig_num_vandermonde():
    uid = "num-vandermonde"
    data = [(2, 0.42), (3, 1.18), (4, 2.00), (5, 2.84), (6, 3.69),
            (7, 4.56), (8, 5.43), (9, 6.30), (10, 7.18), (11, 8.06), (12, 8.95)]

    def draw(x, y, w, h):
        def X(n):
            return x + (n - 2) / 10 * w

        def Y(v):
            return y + h - v / 9 * h

        out = [plot_axes(x, y, w, h, xlabel="", ylabel="log10 cond(V)",
                         xticks=[("2", X(2)), ("4", X(4)), ("6", X(6)), ("8", X(8)), ("10", X(10)), ("12", X(12))],
                         yticks=[("0", Y(0)), ("3", Y(3)), ("6", Y(6)), ("9", Y(9))])]
        out.append(t(x + w / 2, y + h + 36, "节点数 n", cls="pl-axis-label", anchor="middle"))
        out.append(poly_path([(X(n), Y(v)) for n, v in data], TONES["red"], 2.4))
        for n, v in data:
            out.append(dot(X(n), Y(v), TONES["red"], 3.2))
        out.append(t(X(6.2), Y(2.0), "等距节点：每加几个点，条件数涨一个量级", cls="pl-small", fill=TONES["muted"], size="10"))
        out.append(t(X(12), Y(8.95) - 10, "n=12：κ≈8.8×10⁸", cls="pl-mono", fill=TONES["red"], anchor="end", size="10.5"))
        return "".join(out)

    caption = ("<b>读图：</b>等距节点上，范德蒙德矩阵的条件数随 n 近似指数增长：n=8 时约 10⁵，n=12 时约 10⁹。"
               "这意味着用 1,x,…,xⁿ 这组基直接解系数，会丢掉约 9 位有效数字——“存在唯一”不等于“能算出来”。")
    return plot_plate(uid, "NUMERICAL · INTERPOLATION / 05", "范德蒙德：存在唯一，但病态",
                      "节点越多，系数方程越难解；换基（拉格朗日）才是出路。", draw, caption,
                      tone="gold", atlas_no="N-24",
                      note="n=2：κ≈2.6|n=8：κ≈2.7×10⁵|n=12：κ≈8.8×10⁸|每加几个点涨一个量级")




def fig_num_quadrature():
    uid = "num-quadrature"
    steps = [
        ("01", "分割", "把 [a,b] 切成小段", "gold"),
        ("02", "低阶公式", "梯形 / Simpson", "accent"),
        ("03", "复化累加", "T_n / S_n", "cyan"),
        ("04", "外推", "Romberg · Richardson", "plum"),
        ("05", "Gauss", "节点也自由", "green"),
    ]
    caption = ("<b>读图：</b>先分割，再用低阶公式；复化把误差降到 O(h²)/O(h⁴)，"
               "Romberg 用外推再抬阶，Gauss 让节点也参与优化。精度不是免费的："
               "Gauss 节点不固定、权重需预计算，适合光滑函数。")
    return flow_plate(uid, "NUMERICAL · QUADRATURE / 06", "从梯形到 Gauss：精度是怎么抬上去的",
                      "同一张图上看清复化、外推、Gauss 三条加速路线。",
                      steps, caption, tone="cyan", atlas_no="N-25",
                      note="复化 Simpson O(h⁴)；Romberg 每列再抬 2 阶；n 点 Gauss 精确到 2n-1 次。",
                      height=380)


def fig_num_ode():
    uid = "num-ode"
    steps = [
        ("01", "初值问题", "y'=f(t,y), y(t0)=y0", "gold"),
        ("02", "Euler", "沿切线走一步", "accent"),
        ("03", "RK", "多取几个斜率", "cyan"),
        ("04", "多步法", "用历史值", "plum"),
        ("05", "刚性", "隐式 / A-稳定", "green"),
    ]
    caption = ("<b>读图：</b>Euler 只用一个斜率，RK 用多个斜率加权，多步法用历史点；"
               "刚性方程的限制不在精度，而在绝对稳定区域——显式方法被迫用小步长，"
               "隐式方法才能走大步。")
    return flow_plate(uid, "NUMERICAL · ODE / 07", "单步、RK、多步：三条路线",
                      "精度看阶，稳定看测试方程；刚性方程优先隐式。",
                      steps, caption, tone="plum", atlas_no="N-26",
                      note="Euler O(h)；RK4 O(h⁴)；Adams 每步一次函数值但要启动。",
                      height=380)

def disk_panel(x, y, w, h, disks, eigvals, title, legend, tone):
    """复平面面板：画盖尔圆盘 + 特征值点。上下留白固定，保证圆盘不压标题。"""
    out = []
    out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" fill="var(--paper)" '
               f'fill-opacity=".55" stroke="var(--line)" stroke-opacity=".7"/>')
    xr, yr = (-2.6, 13.6), (-4.4, 4.4)
    body_top, body_bot = y + 26, y + h - 54
    scale = min((w - 20) / (xr[1] - xr[0]), (body_bot - body_top) / (yr[1] - yr[0]))
    cx, cy = sum(xr) / 2, 0.0
    px, py = x + w / 2, (body_top + body_bot) / 2

    def P(re_, im_):
        return px + (re_ - cx) * scale, py - (im_ - cy) * scale

    for i in range(int(xr[0]) + 1, int(xr[1]) + 1, 2):
        gx, _ = P(i, 0)
        out.append(f'<path d="M{gx:.1f} {body_top:.1f} V{body_bot:.1f}" stroke="var(--line)" stroke-opacity=".26" stroke-dasharray="2 6"/>')
        out.append(t(gx, body_bot + 13, str(i), cls="pl-axis-label", anchor="middle"))
    ax0, ay0 = P(xr[0], 0)
    ax1, _ = P(xr[1], 0)
    out.append(f'<path d="M{ax0:.1f} {ay0:.1f} H{ax1:.1f}" stroke="var(--ink-2)" stroke-opacity=".5" stroke-width="1.2"/>')
    out.append(t(ax1 - 2, ay0 - 6, "Re", cls="pl-axis-label", anchor="end"))

    palette = {"accent": TONES["accent"], "gold": TONES["gold"], "cyan": TONES["cyan"],
               "green": TONES["green"], "plum": TONES["plum"]}
    for name, re_, im_, r, col, dash in disks:
        gx, gy = P(re_, im_)
        rr = r * scale
        stroke = palette.get(col, TONES["accent"])
        dash_attr = ' stroke-dasharray="6 5"' if dash else ""
        out.append(f'<circle cx="{gx:.1f}" cy="{gy:.1f}" r="{rr:.1f}" fill="{stroke}" fill-opacity=".08" '
                   f'stroke="{stroke}" stroke-opacity=".9" stroke-width="1.8"{dash_attr}/>')
        out.append(t(gx, gy - rr - 7, name, cls="pl-mono", fill=stroke, anchor="middle", size="11.5"))
        out.append(t(gx - rr + 7, gy + 15, f"r = {r:g}", cls="pl-mono", fill=stroke, anchor="start", size="9.5"))
    for re_, im_ in eigvals:
        gx, gy = P(re_, im_)
        out.append(f'<path d="M{gx:.1f} {gy-5:.1f} L{gx+5:.1f} {gy:.1f} L{gx:.1f} {gy+5:.1f} L{gx-5:.1f} {gy:.1f} Z" '
                   f'fill="var(--fig-red)" stroke="var(--paper)" stroke-width="1.2"/>')
    out.append(t(x + 12, y + 17, title, cls="pl-mono", fill=palette.get(tone, TONES["accent"]), size="11"))
    out.append(t(x + w / 2, y + h - 14, legend, cls="pl-mono", anchor="middle", size="9.5", fill=TONES["muted"]))
    return "".join(out)


def fig_matrix_gershgorin():
    uid = "matrix-gershgorin"
    ev = [(9.3038, 0.0), (3.0320, 0.0563), (-0.3357, 0.9285)]
    body = []
    body.append(disk_panel(
        32, 132, 422, 272,
        [("G₁", 9, 0, 2, "accent", False),
         ("G₂", 0, 1, 2, "cyan", False),
         ("G₃", 3, 0, 2, "green", False)],
        ev, "① D = I：G₂ 与 G₃ 交成一片，只有 G₁ 孤立",
        "★ 真实特征值 9.30 / 3.03+0.06i / −0.34+0.93i（均在各自圆盘内）", "accent"))
    body.append(disk_panel(
        466, 132, 402, 272,
        [("G₁′", 9, 0, 4, "accent", True),
         ("G₂′", 0, 1, 1.5, "cyan", True),
         ("G₃′", 3, 0, 1.5, "green", True)],
        ev, "② D = diag(2,1,1)：三个圆盘两两分离",
        "圆心一个没动（仍是对角元），只有半径变成 4 / 1.5 / 1.5", "plum"))
    caption = ("<b>读图：</b>四角星是真实特征值，圆盘是盖尔圆给它们的「领地」——圆心是第 i 个对角元，半径是第 i 行"
               "「除去对角元」的绝对值之和。左图（D = I）里 G₂（心在 i、半径 2）与 G₃（心在 3、半径 2）重叠成一个"
               "连通区，两个圆盘 ⇒ 那里恰有 2 个特征值；只有 G₁ 孤立，所以能断言的只有「有一个特征值在 [7,11] 内」。"
               "右图取 D = diag(2,1,1)：第一行放大 2 倍、第一列缩小一半，圆心一个没动，"
               "半径却分成 4 / 1.5 / 1.5，三个圆盘各自孤立——结论升到「三个特征值互异」。"
               "<b>相似变换不改变谱，只改变我们对它的描述精度。</b>")
    return plate(uid, 440, "MATRIX · GERSHGORIN / 16",
                 "盖尔圆盘：挪一挪圆盘，把 1 个数成 3 个",
                 "例 4.5.8：A = [[9,1,1],[1,i,1],[1,1,3]]，D = I 与 D = diag(2,1,1) 两种看法的对比。",
                 "".join(body), tone="accent", atlas_no="M-16", caption=caption)


def tr(x, y, raw, cls="pl-label", fill=None, anchor=None, size=None, opacity=None):
    """同 t()，但不转义：用于需要 <tspan> 上下标的文字。"""
    attrs = [f'x="{x:.1f}"', f'y="{y:.1f}"', f'class="{cls}"']
    if fill:
        attrs.append(f'style="fill:{fill}"')
    if anchor:
        attrs.append(f'text-anchor="{anchor}"')
    if size:
        attrs.append(f'font-size="{size}"')
    if opacity is not None:
        attrs.append(f'opacity="{opacity}"')
    return f'<text {" ".join(attrs)}>{raw}</text>'


def abel_panel(x, y, w, h, dots, title, verdict, verdict_color, tone, on_ring=False):
    """一个复平面小面板：单位收敛圆 + 若干谱点。dots = [(re, im, color)]。"""
    out = []
    out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" fill="var(--paper)" '
               f'fill-opacity=".55" stroke="var(--line)" stroke-opacity=".7"/>')
    cx, cy, r = x + w / 2, y + 96, 58
    for i in (-1, 1):
        out.append(f'<path d="M{cx + i * r:.1f} {y + 28} V{y + h - 54}" stroke="var(--line)" stroke-opacity=".20" stroke-dasharray="2 6"/>')
        out.append(f'<path d="M{x + 12} {cy + i * r:.1f} H{x + w - 12}" stroke="var(--line)" stroke-opacity=".20" stroke-dasharray="2 6"/>')
    out.append(f'<path d="M{x + 12} {cy} H{x + w - 12}" stroke="var(--ink-2)" stroke-opacity=".45" stroke-width="1.1"/>')
    out.append(f'<path d="M{cx} {y + 28} V{y + h - 54}" stroke="var(--ink-2)" stroke-opacity=".45" stroke-width="1.1"/>')
    out.append(f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="{TONES["accent"]}" stroke-width="2"'
               f'{" stroke-dasharray=\"6 5\"" if on_ring else ""}/>')
    # 半径示意线 + 标签
    out.append(f'<path d="M{cx} {cy} L{cx + r * 0.5:.1f} {cy - r * 0.866:.1f}" stroke="{TONES["accent"]}" '
               f'stroke-opacity=".55" stroke-width="1.2" stroke-dasharray="3 3"/>')
    out.append(tr(cx + r * 0.30, cy - r * 0.34, "r", cls="pl-mono", fill=TONES["accent"], size="11"))
    for re_, im_, col in dots:
        gx, gy = cx + re_ * r, cy - im_ * r
        out.append(f'<circle cx="{gx:.1f}" cy="{gy:.1f}" r="5" fill="{col}" stroke="var(--paper)" stroke-width="1.3"/>')
    out.append(tr(x + 12, y + 18, title, cls="pl-mono", fill=TONES[tone], size="11"))
    out.append(tr(x + w / 2, y + h - 26, verdict, cls="pl-mono", anchor="middle", fill=verdict_color, size="11.5"))
    return "".join(out)


def fig_matrix_abel():
    uid = "matrix-abel"
    body = []
    green, red = TONES["green"], "var(--fig-red)"
    body.append(abel_panel(
        32, 132, 272, 216,
        [(0.34, 0.20, green), (-0.30, 0.22, green)],
        "\u2460 \u03c1(A) = 0.4",
        "\u03c1 &lt; r\uff1a\u7edd\u5bf9\u6536\u655b", green, "accent"))
    body.append(abel_panel(
        312, 132, 272, 216,
        [(-1.0, 0.0, red)],
        "\u2461 \u03c1(A) = 1 = r",
        "\u03c1 = r\uff1a\u5b9a\u7406\u5931\u6548\uff0c\u53e6\u7b97", red, "gold", on_ring=True))
    body.append(abel_panel(
        592, 132, 272, 216,
        [(1.30, 0.55, red), (-1.15, -0.75, red)],
        "\u2462 \u03c1(A) = 1.4",
        "\u03c1 &gt; r\uff1a\u53d1\u6563", red, "plum"))
    body.append(f'<rect x="32" y="356" width="832" height="62" rx="14" fill="var(--paper)" '
                f'fill-opacity=".7" stroke="var(--line)" stroke-opacity=".8"/>')
    body.append(tr(50, 378, "判据只看最远的那个特征值，不看矩阵元素有多大：", cls="pl-small"))
    body.append(tr(50, 402, "ρ(A) &lt; r 时总存在一把范数使 ‖A‖ &lt; r（定理 4.5.2），化归成数值幂级数；ρ(A) = r 时范数再调也没用。",
                   cls="pl-small"))
    caption = ("<b>读图：</b>圆圈是数值幂级数 Σcₘzᵐ 的收敛圆（半径 r），圆点是各矩阵的谱。①全部特征值在圆内（ρ &lt; r）"
               "——矩阵幂级数绝对收敛，哪怕 ‖A‖ 的读数大于 r；②特征值恰在圆周上（ρ = r）——定理失效，必须回到定义逐项判断；"
               "③有特征值在圆外（ρ &gt; r）——幂级数的通项不趋于零，必然发散。"
               "<b>所以「ρ &lt; r」是充分条件，「ρ &gt; r」是必然发散的，边界要单独验。</b>"
               "例 4.6.7 就卡在第②种：A 的谱半径恰是 1，ΣAᵏ/k 发散，而同一个 A 换成 ΣAᵏ/k² 就收敛。")
    return plate(uid, 440, "MATRIX \u00b7 ABEL / 17",
                 "Abel \u578b\u5b9a\u7406\uff1a\u8c31\u534a\u5f84\u843d\u5728\u6536\u655b\u5706\u7684\u54ea\u4e00\u8fb9",
                 "\u77e9\u9635\u5e42\u7ea7\u6570 \u03a3 c_k A^k \u7684\u655b\u6563\u6027\u7531 \u03c1(A) \u4e0e\u6536\u655b\u534a\u5f84 r \u7684\u5927\u5c0f\u51b3\u5b9a\u3002",
                 "".join(body), tone="cyan", atlas_no="M-17", caption=caption)


FIGURES = {
    "matrix-gershgorin": ("matrix", fig_matrix_gershgorin),
    "matrix-abel": ("matrix", fig_matrix_abel),
    "robot-system": ("robot", fig_robot_system),
    "robot-pose": ("robot", fig_robot_pose),
    "matrix-map": ("matrix", fig_matrix_map),
    "numerical-pipeline": ("numerical", fig_numerical_pipeline),
    "dl-map": ("deeplearning", fig_dl_map),
    "robot-actuator": ("robot", fig_robot_actuator),
    "matrix-equiv": ("matrix", fig_matrix_equiv),
    "dl-activations": ("deeplearning", fig_dl_activations),
    "dl-mlp": ("deeplearning", fig_dl_mlp),
    "numerical-subspaces": ("numerical", fig_numerical_subspaces),
    "robot-euler": ("robot", fig_robot_euler),
    "matrix-eigen": ("matrix", fig_matrix_eigen),
    "robot-dh": ("robot", fig_robot_dh),
    "robot-trajectory": ("robot", fig_robot_trajectory),
    "dl-transformer": ("deeplearning", fig_dl_transformer),
    "numerical-svd": ("numerical", fig_numerical_svd),
    "matrix-kernel": ("matrix", fig_matrix_kernel),
    "dl-neuron": ("deeplearning", fig_dl_neuron),
    "robot-jacobian": ("robot", fig_robot_jacobian),
    "numerical-condition": ("numerical", fig_numerical_condition),
    "num-linear-systems": ("numerical", fig_num_linear_systems),
    "num-power": ("numerical", fig_num_power),
    "num-newton": ("numerical", fig_num_newton),
    "num-vandermonde": ("numerical", fig_num_vandermonde),
    "num-quadrature": ("numerical", fig_num_quadrature),
    "num-ode": ("numerical", fig_num_ode),
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", default="")
    args = parser.parse_args()
    wanted = [s for s in args.only.split(",") if s]
    for slug, (book, fn) in FIGURES.items():
        if wanted and slug not in wanted:
            continue
        out = ROOT / book / "src" / "assets" / "figures" / (slug + ".md")
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(fn(), encoding="utf-8")
        print(f"{out.relative_to(ROOT)}  {len(out.read_text())/1024:.1f} KB")


if __name__ == "__main__":
    main()
