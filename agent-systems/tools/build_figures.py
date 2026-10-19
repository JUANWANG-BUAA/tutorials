#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成《Agent 系统工程》的 SVG 机制图（内联片段，供 mdBook include）。

每张图输出 `src/assets/figures/<name>.md`，页面用
    {{#include ../assets/figures/<name>.md}}
引入。约束：
  - 所有 id 以 `as-<name>-` 开头，全书唯一；
  - 颜色只走 CSS 变量，明暗主题自动跟随；
  - 每图有 <title>/<desc>/<figcaption>，图注以「读图：」开头；
  - 不引用外部字体、图片或脚本。

用法：python3 tools/build_figures.py [--only loop protocol ...]
"""

from __future__ import annotations

import argparse
import html
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
OUT = os.path.join(ROOT, "src", "assets", "figures")

SANS = "'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif"
MONO = "'SFMono-Regular','Roboto Mono',Consolas,monospace"
W = 900


def esc(s: str) -> str:
    return html.escape(s, quote=True)


def header(key: str, w: int, h: int, title: str, desc: str) -> str:
    return f'''<svg class="figure-svg atlas-plate" viewBox="0 0 {w} {h}" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="{key}-title {key}-desc">
<title id="{key}-title">{esc(title)}</title>
<desc id="{key}-desc">{esc(desc)}</desc>
<defs>
  <linearGradient id="{key}-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="{key}-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="{key}-arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="{key}-arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="{w}" height="{h}" fill="url(#{key}-bg)"/>
<rect x="0" y="0" width="{w}" height="{h}" fill="url(#{key}-grid)" opacity=".55"/>
<rect x="0" y="0" width="3" height="{h}" style="fill:var(--accent)" fill-opacity=".5"/>'''


def footer() -> str:
    return "</svg>"


def txt(x, y, s, size=12.5, weight=400, color="var(--ink-2)", anchor="middle",
        family=None, opacity=1.0, mono=False):
    fam = MONO if mono else (family or SANS)
    return (f'<text x="{x}" y="{y}" fill="{color}" font-size="{size}" '
            f'font-weight="{weight}" font-family="{fam}" text-anchor="{anchor}" '
            f'opacity="{opacity}">{esc(s)}</text>')


def box(x, y, w, h, label, sub="", kind="muted", lines=None, mono=False):
    if kind == "accent":
        fill, stroke = "var(--accent)", "var(--accent)"
    elif kind == "gold":
        fill, stroke = "var(--atlas-gold)", "var(--atlas-gold)"
    elif kind == "cyan":
        fill, stroke = "var(--atlas-cyan)", "var(--atlas-cyan)"
    else:
        fill, stroke = "var(--muted)", "var(--muted)"
    out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="3" '
           f'fill="{fill}" fill-opacity="0.05" stroke="{stroke}" stroke-opacity=".55"/>']
    cx = x + w / 2
    if sub:
        out.append(txt(cx, y + h / 2 - 4, label, 12.5, 700, mono=mono))
        out.append(txt(cx, y + h / 2 + 13, sub, 10, 400, "var(--muted)", mono=True))
    else:
        out.append(txt(cx, y + h / 2 + 4, label, 12.5, 700, mono=mono))
    if lines:
        for i, ln in enumerate(lines):
            out.append(txt(cx, y + h + 16 + i * 14, ln, 10, 400, "var(--muted)"))
    return "\n".join(out)


def arrow(x1, y1, x2, y2, key, dim=False, width=1.3, dash=None):
    marker = f"{key}-arrow-dim" if dim else f"{key}-arrow"
    color = "var(--muted)" if dim else "var(--accent)"
    d = f' stroke-dasharray="{dash}"' if dash else ""
    return (f'<path d="M{x1} {y1} L{x2} {y2}" stroke="{color}" stroke-width="{width}" '
            f'stroke-opacity=".75" fill="none" marker-end="url(#{marker})"{d}/>')


def path(d, key, dim=False, width=1.4, dash=None):
    marker = f"{key}-arrow-dim" if dim else f"{key}-arrow"
    color = "var(--muted)" if dim else "var(--accent)"
    da = f' stroke-dasharray="{dash}"' if dash else ""
    return (f'<path d="{d}" stroke="{color}" stroke-width="{width}" '
            f'stroke-opacity=".8" fill="none" marker-end="url(#{marker})"{da}/>')


def wrap(name, key, title, caption, body, h):
    svg = header(key, W, h, title, caption) + "\n" + body + "\n" + footer()
    frag = (f'<figure class="fig-plate fig-wide has-fig-scroll" id="fig-as-{name}" '
            f'data-fig-kind="plate">\n<div class="fig-scroll">\n{svg}\n</div>\n'
            f'<figcaption><b>读图：</b>{caption}</figcaption>\n</figure>\n')
    return frag


# --------------------------------------------------------------------------- #
# 1. Agent 循环
# --------------------------------------------------------------------------- #
def fig_loop():
    key, h = "as-loop", 380
    b = [txt(450, 40, "一次 step 是五件事，不是一次模型调用", 13, 700)]
    y = 86
    labels = [
        ("输入 / 目标", "task + tools", "muted"),
        ("观察", "tool result", "cyan"),
        ("决策", "policy / LLM", "accent"),
        ("行动", "tool call", "gold"),
        ("更新", "state + budget", "muted"),
        ("终止？", "answer / abort", "accent"),
    ]
    x = 40
    wid = 124
    gap = 22
    centers = []
    for i, (lab, sub, kind) in enumerate(labels):
        cx = x + i * (wid + gap)
        b.append(box(cx, y, wid, 64, lab, sub, kind))
        centers.append(cx + wid / 2)
    for i in range(len(labels) - 1):
        b.append(arrow(centers[i] + wid / 2 - 2, y + 32, centers[i + 1] - wid / 2 + 2, y + 32, key))
    # 反馈弧
    b.append(path(f"M{centers[-1]} {y + 66} C{centers[-1]} 220, {centers[0]} 220, {centers[0]} {y + 68}",
                  key, dim=True, dash="5 4"))
    b.append(txt(450, 214, "未终止：带着新观察回到循环；预算与步数每轮递减", 10.5, 400, "var(--muted)"))
    # 状态与预算
    b.append(f'<rect x="150" y="252" width="600" height="82" rx="3" fill="var(--accent)" fill-opacity="0.05" stroke="var(--accent)" stroke-opacity=".5"/>')
    b.append(txt(450, 278, "STATE：世界状态 / 任务状态 / 会话状态 / 控制状态", 12, 700))
    b.append(txt(450, 300, "BUDGET：steps · wall-clock · tokens · tool calls · money", 10.5, 400, "var(--muted)", mono=True))
    b.append(txt(450, 320, "终止条件必须三者同时成立：目标满足 ∧ 预算未耗尽 ∧ 无待处理工具结果", 10, 400, "var(--muted)"))
    b.append(txt(450, 360, "观测：每一步写一条 step 记录（决策、调用、结果、耗时、余额）；没有记录就不算可复现", 10.5, 400, "var(--muted)"))
    cap = ("横向读是「一步」，弧线读是「多步」。真正把 agent 与单次调用区分开的是弧线与中间那层 STATE/BUDGET："
           "没有状态，下一步不知道上一步做了什么；没有预算，循环不知道何时停。图中「终止？」是判定节点，"
           "不是又一个模型调用——终止必须由宿主用可检查的条件执行。")
    return wrap("loop", key, "Agent 循环：观察、决策、行动、更新、终止", cap, "\n".join(b), h)


# --------------------------------------------------------------------------- #
# 2. 工具协议分层
# --------------------------------------------------------------------------- #
def fig_protocol():
    key, h = "as-protocol", 420
    b = [txt(450, 40, "同一份工具契约，穿过四处边界", 13, 700)]
    # 四列
    xs = [36, 246, 456, 666]
    wid = 168
    rows = [
        ("模型 provider", "tool_calls / JSON 参数", "accent"),
        ("宿主 runtime", "校验、授权、调度", "gold"),
        ("MCP client", "JSON-RPC 2.0 请求", "cyan"),
        ("MCP server / 工具", "进程、文件、网络副作用", "muted"),
    ]
    for i, (lab, sub, kind) in enumerate(rows):
        b.append(box(xs[i], 80, wid, 76, lab, sub, kind))
    for i in range(3):
        b.append(arrow(xs[i] + wid + 2, 118, xs[i + 1] - 2, 118, key))
    # 线上帧
    b.append(txt(450, 190, "线上传输的是「意图 + 参数」，不是权限", 11.5, 700, "var(--accent-strong)"))
    b.append(f'<rect x="36" y="208" width="828" height="96" rx="3" fill="var(--paper)" stroke="var(--line-strong)"/>')
    b.append(txt(60, 232, "tools/call 请求", 11, 700, anchor="start", mono=True))
    b.append(txt(60, 252, '{"jsonrpc":"2.0","id":7,"method":"tools/call",', 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(60, 270, ' "params":{"name":"fs.read","arguments":{"path":"/work/a.txt"},', 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(60, 288, ' "_meta":{"traceparent":"00-..."}}}', 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(500, 232, "宿主必须自己回答四问", 11, 700, anchor="start"))
    b.append(txt(500, 252, "① schema 合法？ ② 这个调用者有权？", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(500, 270, "③ 参数是否来自不可信数据？ ④ 失败如何回传？", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(500, 288, "协议只规定格式，授权与副作用由宿主与 server 负责。", 10.5, 400, "var(--muted)", anchor="start"))
    # 三个版本
    b.append(box(36, 330, 250, 56, "2025-11-25", "initialize 握手 + 会话", "muted"))
    b.append(box(325, 330, 250, 56, "2026-07-28", "无状态 + server/discover + MRTR", "accent"))
    b.append(box(614, 330, 250, 56, "弃用窗口", "Roots / Sampling / Logging", "gold"))
    cap = ("从左到右是控制流，不是信任流。模型产出的只是 tool_calls；宿主做校验、授权、路由；MCP 只负责"
           "把调用送到 server。读到中间的请求帧要意识到：参数可以来自网页、文件或另一个工具的输出，"
           "所以「schema 合法」不等于「可以执行」。底部两行是版本坐标：新版把 initialize 与协议级会话去掉了，"
           "新实现不应再把握手当默认前提。")
    return wrap("protocol", key, "工具协议的三方与四层边界", cap, "\n".join(b), h)


# --------------------------------------------------------------------------- #
# 3. 上下文预算
# --------------------------------------------------------------------------- #
def fig_context():
    key, h = "as-context", 400
    b = [txt(450, 40, "上下文预算：先分配，再填充，最后才压缩", 13, 700)]
    total = 828
    x0 = 36
    segs = [
        ("系统与安全", 12, "accent"),
        ("任务与约束", 10, "gold"),
        ("工具 schema", 14, "cyan"),
        ("检索/记忆", 26, "muted"),
        ("对话历史", 22, "muted"),
        ("输出预留", 16, "accent"),
    ]
    x = x0
    for lab, pct, kind in segs:
        w = total * pct / 100
        fill = {"accent": "var(--accent)", "gold": "var(--atlas-gold)",
                "cyan": "var(--atlas-cyan)", "muted": "var(--muted)"}[kind]
        b.append(f'<rect x="{x:.1f}" y="80" width="{w:.1f}" height="58" fill="{fill}" fill-opacity=".10" stroke="{fill}" stroke-opacity=".55"/>')
        b.append(txt(x + w / 2, 105, lab, 10.5, 700))
        b.append(txt(x + w / 2, 123, f"{pct}%", 11, 700, "var(--accent-strong)", mono=True))
        x += w
    b.append(txt(450, 162, "总预算 100%：任何一段超支，都必须从另一段扣除——不能靠「再塞一点」", 10.5, 400, "var(--muted)"))
    # 压缩阶梯
    steps = [
        ("① 去重", "同文多次出现只留一次"),
        ("② 抽取", "只留与当前子目标相关的 span"),
        ("③ 摘要", "保留约束、数字、失败原因"),
        ("④ 裁剪", "滑窗 / 引用替换 / 硬截断"),
    ]
    for i, (a, c) in enumerate(steps):
        bx = 36 + i * 210
        b.append(box(bx, 196, 192, 66, a, c, "accent" if i == 0 else "muted"))
        if i < 3:
            b.append(arrow(bx + 194, 229, bx + 206, 229, key, dim=True))
    b.append(f'<rect x="36" y="292" width="828" height="66" rx="3" fill="var(--atlas-gold)" fill-opacity="0.06" stroke="var(--atlas-gold)" stroke-opacity=".5"/>')
    b.append(txt(60, 318, "顺序不能反", 11.5, 700, "var(--ink-2)", anchor="start"))
    b.append(txt(60, 338, "先压缩再分配 = 把预算浪费在低价值内容上；先分配再压缩 = 每段都知道自己为什么存在。", 10.5, 400, "var(--muted)", anchor="start"))
    cap = ("顶部条是预算分配，不是实际占用；实际占用要靠 tokenizer 计数，不能按字符数估。右侧「输出预留」"
           "必须提前扣掉：很多 agent 的失败不是输入超限，而是输入刚好塞满、输出没有空间，导致回答被截断。"
           "下方四级是压缩顺序：先去重，再抽取，最后才摘要；摘要会不可逆地丢约束，放在最后。")
    return wrap("context-budget", key, "上下文预算的分配与压缩顺序", cap, "\n".join(b), h)


# --------------------------------------------------------------------------- #
# 4. 规划策略
# --------------------------------------------------------------------------- #
def fig_planning():
    key, h = "as-planning", 430
    b = [txt(450, 40, "三种规划：交错、先计划后执行、搜索", 13, 700)]
    # panel 1 ReAct
    b.append(txt(150, 78, "ReAct", 12, 700, "var(--accent-strong)"))
    b.append(box(48, 96, 204, 52, "Thought", "下一步做什么", "accent"))
    b.append(box(48, 168, 204, 52, "Action", "一次工具调用", "gold"))
    b.append(box(48, 240, 204, 52, "Observation", "结果 / 错误", "cyan"))
    b.append(path("M150 148 L150 166", key))
    b.append(path("M150 220 L150 238", key))
    b.append(path("M48 266 C18 266, 18 122, 48 122", key, dim=True, dash="5 4"))
    b.append(txt(150, 330, "局部 reactive；无全局计划", 10, 400, "var(--muted)"))
    # panel 2 plan-execute
    b.append(txt(450, 78, "Plan-Execute", 12, 700, "var(--accent-strong)"))
    b.append(box(330, 96, 240, 52, "Planner", "输出步骤 DAG", "accent"))
    for i, (lab, x) in enumerate([("S1", 330), ("S2", 448), ("S3", 566)]):
        b.append(box(x, 178, 90, 48, lab, "可重试", "muted"))
    b.append(path("M450 148 L450 160 L375 160 L375 176", key))
    b.append(path("M450 148 L450 176", key))
    b.append(path("M450 148 L450 160 L611 160 L611 176", key))
    b.append(arrow(422, 202, 446, 202, key, dim=True))
    b.append(arrow(540, 202, 564, 202, key, dim=True))
    b.append(box(330, 250, 240, 48, "Replan", "失败/新信息触发", "gold"))
    b.append(path("M450 226 L450 248", key))
    b.append(txt(450, 330, "全局计划；重规划成本高", 10, 400, "var(--muted)"))
    # panel 3 tree
    b.append(txt(760, 78, "Tree search", 12, 700, "var(--accent-strong)"))
    nodes = [(760, 100), (700, 160), (820, 160), (670, 220), (730, 220), (790, 220), (850, 220)]
    edges = [(0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6)]
    for a, c in edges:
        b.append(f'<path d="M{nodes[a][0]} {nodes[a][1] + 12} L{nodes[c][0]} {nodes[c][1] - 12}" stroke="var(--muted)" stroke-width="1.1" stroke-opacity=".65" fill="none"/>')
    for i, (x, y) in enumerate(nodes):
        hot = i in (4, 5)
        b.append(f'<circle cx="{x}" cy="{y}" r="12" fill="{"var(--accent)" if hot else "var(--paper)"}" fill-opacity="{0.18 if hot else 1}" stroke="{"var(--accent)" if hot else "var(--muted)"}" stroke-width="1.2"/>')
        b.append(txt(x, y + 3.5, "✓" if hot else "", 10, 700, "var(--accent-strong)"))
    b.append(txt(760, 262, "展开 + 评估 + 回传价值", 10, 400, "var(--muted)"))
    b.append(txt(760, 330, "预算换质量；需要价值函数", 10, 400, "var(--muted)"))
    b.append(f'<rect x="36" y="356" width="828" height="46" rx="3" fill="var(--muted)" fill-opacity="0.04" stroke="var(--line)"/>')
    b.append(txt(450, 383, "选择依据：任务可分解性、验证器强度、单步成本、失败可逆性——不是「哪个更高级」", 10.5, 400, "var(--muted)"))
    cap = ("三块不是难度阶梯，而是三种搜索结构。ReAct 每一步只看局部，适合反馈快、步数少的任务；"
           "Plan-Execute 先付一笔规划成本换全局一致性，适合步骤可预判、可并行的任务；树搜索把预算花在"
           "展开候选上，只有在价值函数能区分好坏时才划算。没有验证器时，树搜索往往只是把同一个错误"
           "复制成四份。")
    return wrap("planning", key, "ReAct、Plan-Execute 与树搜索的结构对比", cap, "\n".join(b), h)


# --------------------------------------------------------------------------- #
# 5. Trace 瀑布
# --------------------------------------------------------------------------- #
def fig_trace():
    key, h = "as-trace", 430
    b = [txt(450, 40, "一条 agent trace：span 的父子、耗时与关键属性", 13, 700)]
    # 时间轴
    x0, x1 = 230, 860
    b.append(f'<line x1="{x0}" y1="72" x2="{x1}" y2="72" stroke="var(--line-strong)"/>')
    for i, t in enumerate([0, 500, 1000, 1500, 2000, 2500]):
        x = x0 + (x1 - x0) * i / 5
        b.append(f'<line x1="{x}" y1="68" x2="{x}" y2="76" stroke="var(--muted)" stroke-opacity=".5"/>')
        b.append(txt(x, 62, f"{t}ms", 9, 400, "var(--muted)", mono=True))
    rows = [
        ("run", 0, 2500, "acme.support · 9 steps", "accent"),
        ("  llm #1", 20, 420, "gpt · 1.2k in / 180 out", "muted"),
        ("  tool #1", 450, 260, "search_orders · ok", "gold"),
        ("  llm #2", 730, 520, "gpt · 2.9k in / 240 out", "muted"),
        ("  tool #2", 1270, 610, "refund · 1.8s · retry=0", "gold"),
        ("  guard", 1900, 90, "egress deny", "cyan"),
        ("  llm #3", 2010, 470, "final answer", "muted"),
    ]
    y = 96
    for i, (name, a, dur, note, kind) in enumerate(rows):
        yy = y + i * 40
        color = {"accent": "var(--accent)", "gold": "var(--atlas-gold)",
                 "cyan": "var(--atlas-cyan)", "muted": "var(--muted)"}[kind]
        b.append(txt(40, yy + 16, name, 10.5, 700, anchor="start", mono=True))
        xa = x0 + (x1 - x0) * a / 2500
        w = max(4, (x1 - x0) * dur / 2500)
        b.append(f'<rect x="{xa:.1f}" y="{yy + 4}" width="{w:.1f}" height="18" rx="2" fill="{color}" fill-opacity=".16" stroke="{color}" stroke-opacity=".6"/>')
        b.append(txt(xa + 8, yy + 17, note, 9.5, 400, "var(--ink-2)", anchor="start"))
    b.append(txt(40, 398, "关键路径：run 2.5s = llm 1.41s + tool 0.87s + guard 0.09s + 调度 0.13s", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(40, 418, "每个 span 至少带：trace_id / span_id / parent_span_id / gen_ai.operation.name / status", 10, 400, "var(--muted)", anchor="start", mono=True))
    cap = ("横轴是时间，纵轴是调用栈。看三件事：哪一段最长（llm #2 与 tool #2）、哪一段是并行/串行、"
           "哪个 span 失败了（guard 拒绝出口）。trace 的价值不是「有记录」，而是能把一次失败定位到"
           "具体 span 的输入、输出与属性；如果 span 断链，回放就只能靠猜。")
    return wrap("trace", key, "Agent trace 的瀑布视图与关键路径", cap, "\n".join(b), h)


# --------------------------------------------------------------------------- #
# 6. 评估与门禁
# --------------------------------------------------------------------------- #
def fig_eval():
    key, h = "as-eval", 400
    b = [txt(450, 40, "评估流水线：从版本化数据集到可回滚的门禁", 13, 700)]
    stages = [
        ("数据集 v3", "分层 + 污染检查"),
        ("runner", "N 次采样 + 成本"),
        ("指标", "准确率 / 工具 / 引用"),
        ("统计", "CI + 配对检验"),
        ("门禁", "阈值 + 灰度"),
    ]
    for i, (a, c) in enumerate(stages):
        x = 36 + i * 172
        b.append(box(x, 84, 158, 68, a, c, "accent" if i in (1, 4) else "muted"))
        if i < 4:
            b.append(arrow(x + 160, 118, x + 168, 118, key))
    b.append(f'<rect x="36" y="184" width="400" height="128" rx="3" fill="var(--accent)" fill-opacity="0.04" stroke="var(--accent)" stroke-opacity=".45"/>')
    b.append(txt(56, 210, "一次比较要同时报告", 11.5, 700, "var(--accent-strong)", anchor="start"))
    b.append(txt(56, 234, "Δ质量 = +4.2pp  [95% CI +1.1, +7.3]", 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(56, 254, "Δ成本 = +18%    ΔP95 = +240ms", 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(56, 274, "n = 400 配对样本；同一 seed 集", 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(56, 294, "失败样本：12 个新增，3 个修复", 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(f'<rect x="464" y="184" width="400" height="128" rx="3" fill="var(--atlas-gold)" fill-opacity="0.05" stroke="var(--atlas-gold)" stroke-opacity=".45"/>')
    b.append(txt(484, 210, "门禁不是单指标", 11.5, 700, "var(--ink-2)", anchor="start"))
    b.append(txt(484, 234, "① 质量下界 > baseline（配对）", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(484, 254, "② 安全用例 0 回归", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(484, 274, "③ 成本/延迟在预算内", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(484, 294, "④ 任一失败 → 可回滚到上一版本", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(450, 350, "没有「平均分涨了」就放行；平均分可以掩盖尾部、失败类型与成本漂移。", 10.5, 400, "var(--muted)"))
    b.append(txt(450, 374, "观测：每次评估写 dataset_version / model / prompt_hash / seed / git_sha，否则结果不可复现。", 10, 400, "var(--muted)"))
    cap = ("从左到右是流水线，从右往左是回滚路径。门禁读的不是一个分数，而是一组带不确定性的差值："
           "质量差值的置信区间下界、安全回归数、成本与 P95 延迟。图中「门禁」是唯一有写权限的环节，"
           "runner 与统计只产出证据；没有证据链的放行，等于把发布交给运气。")
    return wrap("eval", key, "评估流水线与回归门禁", cap, "\n".join(b), h)


# --------------------------------------------------------------------------- #
# 7. 沙箱分层
# --------------------------------------------------------------------------- #
def fig_sandbox():
    key, h = "as-sandbox", 410
    b = [txt(450, 40, "代码 agent 的四层边界：每层挡不同的逃逸", 13, 700)]
    layers = [
        ("进程", "fork/exec · 进程组 · 超时 · 收尸", "accent"),
        ("文件", "rootfs · pivot_root · openat2 · 临时目录", "gold"),
        ("网络", "netns · egress allowlist · DNS 固定", "cyan"),
        ("资源", "rlimit · cgroup v2 · pids.max · 墙钟", "muted"),
    ]
    for i, (a, c, kind) in enumerate(layers):
        x = 70 + i * 200
        b.append(box(x, 84, 170, 74, a, c, kind))
        if i < 3:
            b.append(txt(x + 185, 126, "+", 18, 700, "var(--muted)"))
    b.append(f'<rect x="70" y="196" width="770" height="76" rx="3" fill="var(--paper)" stroke="var(--line-strong)"/>')
    b.append(txt(90, 222, "共同前提", 11, 700, anchor="start"))
    b.append(txt(90, 244, "低权限 UID + no_new_privs + 最小 capability + seccomp 白名单 + landlock 路径规则", 10.5, 400, "var(--muted)", anchor="start", mono=True))
    b.append(txt(90, 262, "顺序：userns → mount/rootfs → drop caps → no_new_privs → seccomp → landlock（细节见第 4 章）", 10, 400, "var(--muted)", anchor="start"))
    b.append(f'<rect x="70" y="290" width="770" height="92" rx="3" fill="var(--accent)" fill-opacity="0.04" stroke="var(--accent)" stroke-opacity=".45"/>')
    b.append(txt(90, 316, "四条事故路径（每层一条）", 11, 700, "var(--accent-strong)", anchor="start"))
    b.append(txt(90, 338, "① 不设进程组 → 超时只杀父进程，子进程继续跑    ② 不换根 → 读到宿主 ~/.ssh", 10.5, 400, "var(--muted)", anchor="start"))
    b.append(txt(90, 358, "③ 不隔离网络 → 把数据 POST 出去    ④ 不设 pids.max → fork 炸弹拖垮宿主", 10.5, 400, "var(--muted)", anchor="start"))
    cap = ("四层不是四个可选项，而是四种失败模式的一一对应。只做进程超时、不做进程组，超时后子进程仍在写文件；"
           "只做文件只读、不做网络隔离，agent 仍可把读到的内容发出去。共同前提那一行是第 4 章的主题："
           "边界要靠「丢权」而不是「加限制」来实现。")
    return wrap("sandbox", key, "代码 agent 的四层沙箱边界", cap, "\n".join(b), h)


FIGURES = {
    "loop": fig_loop,
    "protocol": fig_protocol,
    "context-budget": fig_context,
    "planning": fig_planning,
    "trace": fig_trace,
    "eval": fig_eval,
    "sandbox": fig_sandbox,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", nargs="*", choices=sorted(FIGURES))
    args = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    names = args.only or sorted(FIGURES)
    for name in names:
        frag = FIGURES[name]()
        path = os.path.join(OUT, f"{name}.md")
        open(path, "w", encoding="utf-8").write(frag)
        print("wrote", os.path.relpath(path, ROOT))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
