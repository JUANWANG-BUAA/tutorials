#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成《分布式系统与数据面》的全部 SVG 图版（输出到 src/assets/figures/*.md）。

设计约束
--------
1. 所有图自绘，不复制任何母本/论文/产品图。
2. 每个 SVG 的 id 都以图名作前缀，保证跨文件唯一；页面内联后也不会撞 id。
3. 每张图必须有 <title>、<desc>、<figcaption>，图注以「读图：」开头。
4. 颜色只走主题变量（--accent / --sage / --fig-*），跟随明暗主题。
5. 只用矩形、线、箭头、圆、文本；不依赖外部字体或图片。

用法：
    python3 tools/build_figures.py            # 重建全部
    python3 tools/build_figures.py retry-budget
"""

from __future__ import annotations

import html
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
OUT = os.path.join(ROOT, "src", "assets", "figures")

TONES = {
    "accent": "var(--accent)",
    "sage": "var(--sage)",
    "muted": "var(--muted)",
    "ink": "var(--ink)",
    "ink2": "var(--ink-2)",
    "red": "var(--fig-red,#9c2b25)",
    "gold": "var(--fig-gold,#8a5a00)",
    "blue": "var(--fig-blue,#2456a6)",
    "purple": "var(--fig-purple,#4c3d99)",
    "green": "var(--fig-green,#1f6b3a)",
}
FONT = "'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif"
MONO = "'SFMono-Regular','Roboto Mono',Consolas,monospace"


def esc(text: str) -> str:
    return html.escape(str(text), quote=True)


class Fig:
    def __init__(self, fid: str, w: int, h: int, title: str, desc: str, caption: str):
        self.fid, self.w, self.h = fid, w, h
        self.title, self.desc, self.caption = title, desc, caption
        self.body: list[str] = []
        self.used_tones: set[str] = {"accent", "muted"}

    # ---------- 基础图元 ----------
    def text(self, x, y, s, size=12, anchor="middle", tone="ink2",
             mono=False, weight=400, italic=False):
        fam = MONO if mono else FONT
        style = ' font-style="italic"' if italic else ""
        self.body.append(
            f'<text x="{x}" y="{y}" fill="{TONES[tone]}" font-size="{size}" '
            f'font-weight="{weight}" font-family="{fam}" text-anchor="{anchor}"'
            f'{style}>{esc(s)}</text>')

    def box(self, x, y, w, h, title, sub="", tone="muted", rx=6, dash=False,
            fill="var(--paper)", title_size=13, sub_size=11):
        self.used_tones.add(tone)
        stroke = TONES[tone]
        dash_attr = ' stroke-dasharray="6 5"' if dash else ""
        self.body.append(
            f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" '
            f'fill="{fill}" stroke="{stroke}" stroke-width="1.4"{dash_attr}/>')
        ty = y + (h / 2 - 2 if sub else h / 2 + 4)
        self.text(x + w / 2, ty, title, size=title_size, tone="ink", weight=700)
        if sub:
            self.text(x + w / 2, ty + 17, sub, size=sub_size, tone="ink2")

    def circle(self, cx, cy, r, label, tone="accent", size=12):
        self.used_tones.add(tone)
        self.body.append(
            f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="var(--paper)" '
            f'stroke="{TONES[tone]}" stroke-width="1.6"/>')
        self.text(cx, cy + 4, label, size=size, tone="ink", weight=700)

    def line(self, x1, y1, x2, y2, tone="muted", dash=False, width=1.2):
        self.used_tones.add(tone)
        dash_attr = ' stroke-dasharray="5 5"' if dash else ""
        self.body.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" '
            f'stroke="{TONES[tone]}" stroke-width="{width}"{dash_attr}/>')

    def arrow(self, x1, y1, x2, y2, label="", tone="accent", dash=False,
              both=False, lx=None, ly=None, size=11, label_tone="ink2"):
        self.used_tones.add(tone)
        dash_attr = ' stroke-dasharray="6 5"' if dash else ""
        start = f' marker-start="url(#{self.fid}-ar-{tone})"' if both else ""
        self.body.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" '
            f'stroke="{TONES[tone]}" stroke-width="1.7"{dash_attr}'
            f' marker-end="url(#{self.fid}-ar-{tone})"{start}/>')
        if label:
            mx = lx if lx is not None else (x1 + x2) / 2
            my = ly if ly is not None else (y1 + y2) / 2 - 8
            self.text(mx, my, label, size=size, tone=label_tone)

    def lifeline(self, x, y1, y2, label):
        self.line(x, y1, x, y2, tone="muted", dash=True, width=1)
        self.text(x, y1 - 12, label, size=12, tone="ink", weight=700)

    # ---------- 输出 ----------
    def render(self) -> str:
        defs = []
        for tone in sorted(self.used_tones):
            defs.append(
                f'<marker id="{self.fid}-ar-{tone}" viewBox="0 0 10 10" refX="8.4" '
                f'refY="5" markerWidth="6.5" markerHeight="6.5" orient="auto-start-reverse">'
                f'<path d="M0 0 10 5 0 10Z" fill="{TONES[tone]}"/></marker>')
        defs.append(
            f'<pattern id="{self.fid}-grid" width="24" height="24" '
            f'patternUnits="userSpaceOnUse">'
            f'<path d="M24 0H0V24" fill="none" stroke="var(--ink)" stroke-opacity=".045"/>'
            f'</pattern>')
        title_id, desc_id = f"{self.fid}-title", f"{self.fid}-desc"
        svg = [
            f'<svg class="figure-svg" viewBox="0 0 {self.w} {self.h}" '
            f'xmlns="http://www.w3.org/2000/svg" role="img" '
            f'aria-labelledby="{title_id} {desc_id}">',
            f'<title id="{title_id}">{esc(self.title)}</title>',
            f'<desc id="{desc_id}">{esc(self.desc)}</desc>',
            "<defs>", *defs, "</defs>",
            f'<rect x="0" y="0" width="{self.w}" height="{self.h}" fill="var(--paper)"/>',
            f'<rect x="0" y="0" width="{self.w}" height="{self.h}" fill="url(#{self.fid}-grid)"/>',
            f'<rect x="0" y="0" width="3" height="{self.h}" fill="{TONES["accent"]}" opacity=".55"/>',
            f'<text x="22" y="28" fill="{TONES["ink"]}" font-size="14" font-weight="700" '
            f'font-family="{FONT}">{esc(self.title)}</text>',
            *self.body,
            "</svg>",
        ]
        fig = (
            f'<figure class="fig-plate fig-wide" id="fig-{self.fid}">\n'
            + "\n".join(svg)
            + f'\n<figcaption><b>读图：</b>{self.caption}</figcaption>\n</figure>\n')
        return fig


def save(fig: Fig) -> None:
    path = os.path.join(OUT, f"{fig.fid}.md")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(fig.render())
    print(f"  {fig.fid}.md  {len(fig.render().splitlines())} 行")


# ========================================================================== #
# 图 1：一次工具调用的路径
# ========================================================================== #
def f_request_path():
    f = Fig("request-path", 900, 430,
            "一次工具调用的路径与延迟预算",
            "客户端经过接入层到服务 A、服务 B，再访问存储；下方是各段延迟占总预算的比例。",
            "一次调用不是一个「服务」，而是一串 hop。真正的 p99 往往由最慢的那一跳决定；"
            "把预算按 hop 切开，才能知道该给谁设更短的 deadline。")
    f.box(30, 92, 145, 62, "客户端", "重试 / 超时 / 幂等键", tone="accent")
    f.box(225, 82, 155, 82, "接入层", "鉴权 / 限流 / 路由", tone="sage")
    f.box(430, 82, 150, 82, "服务 A", "RPC / 事务边界", tone="blue")
    f.box(630, 82, 150, 82, "服务 B", "幂等 / 背压", tone="purple")
    f.box(630, 240, 150, 66, "存储", "日志 / MVCC", tone="gold")
    f.arrow(175, 123, 225, 123, "1–3 ms", tone="accent", lx=200, ly=113)
    f.arrow(380, 123, 430, 123, "2–8 ms", tone="sage", lx=405, ly=113)
    f.arrow(580, 123, 630, 123, "5–50 ms", tone="blue", lx=605, ly=113)
    f.arrow(705, 164, 705, 240, "1–10 ms", tone="gold", lx=748, ly=205)
    f.text(430, 205, "每一跳都可能排队；超时预算按跳分配，不按「服务」平均分。",
           size=11.5, tone="muted")
    # 延迟条
    base_y, total = 320, 600
    f.text(30, 292, "1 s 预算怎么花（示例）", size=12, tone="ink", anchor="start", weight=700)
    segs = [("客户端排队 80 ms", 80, "accent"), ("网络 60 ms", 60, "sage"),
            ("A 处理 240 ms", 240, "blue"), ("B 处理 380 ms", 380, "purple"),
            ("存储 160 ms", 160, "gold"), ("余量 80 ms", 80, "muted")]
    x = 30
    for label, ms, tone in segs:
        w = total * ms / 1000
        f.body.append(f'<rect x="{x}" y="{base_y}" width="{w}" height="26" '
                      f'fill="{TONES[tone]}" fill-opacity=".16" stroke="{TONES[tone]}"/>')
        if w > 60:
            f.text(x + w / 2, base_y + 17, str(ms), size=10, tone="ink2", mono=True)
        f.line(x, base_y + 26, x + w, base_y + 26, tone=tone, width=1.5)
        x += w
    f.text(30, base_y + 50, "每条都按 1 s 总预算切；任何一段超时，整条链路应尽快失败，而不是等满 1 s。",
           size=11.5, tone="muted", anchor="start")
    save(f)


# ========================================================================== #
# 图 2：请求状态机
# ========================================================================== #
def f_request_state():
    f = Fig("request-state", 900, 390,
            "一次逻辑请求的状态机：unknown 不是失败",
            "pending、running、succeeded、failed 与 unknown 之间的迁移；超时进入 unknown，查询或同键重试才能离开。",
            "很多系统把 unknown 直接折成 failed，于是客户端重试、服务端再执行一次。"
            "把 unknown 画出来，是为了在代码里给它一个明确的分支，而不是靠异常类型猜。")
    f.box(40, 140, 150, 64, "pending", "已接收，未执行", tone="muted")
    f.box(250, 140, 150, 64, "running", "执行中（有租约）", tone="accent")
    f.box(470, 50, 160, 60, "succeeded", "副作用已提交", tone="green")
    f.box(470, 230, 160, 60, "failed", "确定未提交", tone="red")
    f.box(250, 290, 150, 64, "unknown", "超时 / 响应丢失", tone="gold", dash=True)
    f.arrow(190, 172, 250, 172, "开始", tone="accent", lx=220, ly=162)
    f.arrow(400, 150, 470, 92, "提交 + 响应", tone="green", lx=450, ly=112)
    f.arrow(400, 194, 470, 252, "明确失败", tone="red", lx=452, ly=235)
    f.arrow(325, 204, 325, 290, "客户端超时", tone="gold", lx=380, ly=250)
    f.arrow(400, 322, 500, 290, "查询到成功", tone="green", lx=472, ly=318)
    f.arrow(300, 290, 300, 204, "同键重试/查询", tone="muted", dash=True, lx=245, ly=248)
    f.arrow(470, 292, 395, 320, "确定失败", tone="red", lx=450, ly=312)
    f.text(720, 160, "关键不变量", size=12, tone="ink", weight=700)
    f.text(720, 184, "unknown 不能当 failed", size=11.5, tone="red")
    f.text(720, 204, "只能查询或同键重试", size=11.5, tone="ink2")
    f.text(720, 224, "不能换新键重发", size=11.5, tone="red")
    save(f)


# ========================================================================== #
# 图 3：超时的三种真相
# ========================================================================== #
def f_timeout_truth():
    f = Fig("timeout-truth", 900, 380,
            "超时后的三种真相",
            "客户端在 T 时刻返回 timeout；请求可能没到、执行了但响应丢失、或执行并提交但响应丢失。",
            "同一条 timeout 日志背后可能是三种完全不同的服务端状态。只看客户端错误码，"
            "无法判断该不该重试；这就是为什么需要幂等键和服务端查询接口。")
    c_x, s_x, t_x = 100, 760, 610
    f.lifeline(c_x, 80, 350, "客户端")
    f.lifeline(s_x, 80, 350, "服务端")
    f.line(t_x, 70, t_x, 360, tone="red", dash=True, width=1.6)
    f.text(t_x, 62, "T = 1 s（客户端超时）", size=11, tone="red")
    rows = [
        (110, "① 请求没到", "报文丢失/连接未建立", 360, "server 无记录"),
        (200, "② 执行了，响应丢了", "副作用已发生，客户端不知道", 760, "server 有记录，状态成功"),
        (290, "③ 执行并提交，响应丢了", "数据库已提交，最危险", 760, "server 可查到结果"),
    ]
    for y, title, sub, end_x, note in rows:
        f.text(30, y - 18, title, size=11, tone="ink", anchor="start", weight=700)
        f.arrow(c_x, y, end_x, y, tone="accent" if end_x > c_x else "muted", lx=(c_x + end_x) / 2, ly=y - 6)
        f.text(30, y + 4, sub, size=10.5, tone="muted", anchor="start")
        f.text(790, y - 6, note, size=10.5, tone="ink2", anchor="end")
        if end_x == 760:
            f.box(700, y + 8, 120, 26, "已执行", tone="gold", rx=3, title_size=10)
    f.text(450, 372, "客户端看到的都是 timeout；服务端状态分别是「无」「成功」「成功」。",
           size=11.5, tone="muted")
    save(f)


# ========================================================================== #
# 图 4：重试预算与放大
# ========================================================================== #
def f_retry_budget():
    f = Fig("retry-budget", 900, 410,
            "重试预算：次数不是策略，放大倍数才是",
            "单层 3 次重试乘以两层就是 16 次尝试；带预算与抖动的重试把放大控制在可接受范围。",
            "指数退避只能减少同一时刻的并发，不能消除总放大。真正要限制的是"
            "「重试请求 / 原始请求」的比值；预算耗尽后应快速失败，而不是继续排队。")
    f.line(60, 330, 850, 330, tone="ink", width=1.2)
    for i, t in enumerate([0, 1, 3, 7, 15]):
        x = 60 + t * 48
        f.line(x, 326, x, 336, tone="muted")
        f.text(x, 352, f"{t}s", size=10, tone="muted", mono=True)
    f.text(60, 372, "时间轴（指数退避 + 抖动，单位 s）", size=10.5, tone="muted", anchor="start")
    attempts = [(0, "首次", "accent"), (1, "重试1", "sage"), (3, "重试2", "blue"), (7, "重试3", "purple")]
    for t, label, tone in attempts:
        x = 60 + t * 48
        f.line(x, 250, x, 326, tone=tone, width=1.4, dash=True)
        f.circle(x, 242, 13, str(attempts.index((t, label, tone)) + 1), tone=tone, size=11)
        f.text(x, 218, label, size=10.5, tone="ink2")
    f.box(560, 70, 280, 100, "最坏放大", "4 次尝试/层 × 2 层 = 16", tone="red")
    f.text(700, 200, "若每层都重试 3 次", size=11, tone="red")
    f.text(700, 222, "原始 1 个请求 → 最多 16 个", size=11, tone="ink2")
    f.box(560, 240, 280, 62, "带预算", "重试 ≤ 原始请求的 10%", tone="sage")
    f.text(700, 318, "预算耗尽后返回 503 + Retry-After", size=10.5, tone="muted")
    f.text(260, 160, "退避 + 抖动把重试摊开；预算限制总量。", size=11.5, tone="ink2")
    f.text(260, 182, "没有预算，重试会把下游的慢变成雪崩。", size=11.5, tone="muted")
    save(f)


# ========================================================================== #
# 图 5：三种复制拓扑
# ========================================================================== #
def f_replication_topologies():
    f = Fig("replication-topologies", 900, 440,
            "三种复制拓扑：主从、多主、无主",
            "左：单主写、多个从读；中：两个主都能写；右：任意副本读写，靠 quorum 相交。",
            "拓扑不是「先进程度」排序，而是三种不同的取舍：单主简单但有切换窗口；"
            "多主写延迟低但冲突要解决；无主可用性高但读需要 quorum 与修复。")
    # 单主
    f.text(150, 58, "单主（single-leader）", size=12, tone="accent", weight=700)
    f.box(90, 80, 120, 48, "Leader", "读写", tone="accent")
    f.box(40, 190, 100, 44, "Follower", "只读", tone="muted")
    f.box(160, 190, 100, 44, "Follower", "只读", tone="muted")
    f.arrow(130, 128, 90, 190, "复制", tone="accent", lx=90, ly=158)
    f.arrow(170, 128, 210, 190, "复制", tone="accent", lx=220, ly=158)
    f.text(150, 270, "写只有一条路；切换时选主", size=10.5, tone="muted")
    # 多主
    f.text(450, 58, "多主（multi-leader）", size=12, tone="blue", weight=700)
    f.box(340, 80, 110, 48, "Leader A", "本地写", tone="blue")
    f.box(470, 80, 110, 48, "Leader B", "本地写", tone="purple")
    f.arrow(450, 104, 470, 104, "", tone="gold", both=True, lx=460, ly=88)
    f.box(380, 190, 160, 44, "Follower / 合并", "冲突解决", tone="muted")
    f.arrow(395, 128, 430, 190, "复制", tone="blue", lx=390, ly=160)
    f.arrow(505, 128, 490, 190, "复制", tone="purple", lx=530, ly=160)
    f.text(450, 270, "两个主都能写；冲突必须可解", size=10.5, tone="muted")
    # 无主
    f.text(750, 58, "无主（leaderless）", size=12, tone="sage", weight=700)
    for i, (x, y) in enumerate([(700, 80), (820, 80), (760, 160)]):
        f.circle(x, y, 24, f"N{i+1}", tone="sage", size=11)
    f.arrow(724, 80, 796, 80, "写/读", tone="sage", both=True, lx=760, ly=66)
    f.arrow(712, 102, 748, 140, "", tone="sage", both=True)
    f.arrow(808, 102, 772, 140, "", tone="sage", both=True)
    f.text(750, 230, "R + W > N；读修复/反熵", size=10.5, tone="muted")
    f.text(450, 330, "选择依据：写延迟、RPO/RTO、冲突容忍度、运维复杂度。",
           size=11.5, tone="ink2")
    f.line(290, 40, 290, 300, tone="muted", dash=True)
    f.line(600, 40, 600, 300, tone="muted", dash=True)
    save(f)


# ========================================================================== #
# 图 6：quorum 相交
# ========================================================================== #
def f_quorum():
    f = Fig("quorum", 900, 370,
            "Quorum 相交：R + W > N 只保证集合相交",
            "N=3、W=2、R=2 时，读集合与写集合至少共享一个副本；但共享副本不一定有最新值。",
            "相交只解决「至少一个副本知道这次写」，不解决「读是否等到修复完成」。"
            "要线性一致，还需要写确认、读修复/提交等待与顺序规则。")
    f.circle(300, 180, 120, "", tone="muted", size=1)
    f.circle(500, 180, 120, "", tone="muted", size=1)
    f.text(300, 175, "W = {A, B}", size=14, tone="accent", weight=700)
    f.text(500, 175, "R = {B, C}", size=14, tone="sage", weight=700)
    f.circle(400, 180, 42, "B", tone="gold", size=16)
    f.circle(190, 180, 28, "A", tone="accent", size=13)
    f.circle(610, 180, 28, "C", tone="sage", size=13)
    f.text(400, 260, "交集 B 是读能看到最新写的必要条件", size=11.5, tone="ink2")
    f.box(90, 300, 720, 44,
          "R + W > N  ⇒  读集合 ∩ 写集合 ≠ ∅", tone="gold", title_size=13)
    f.text(820, 120, "常见误读", size=11, tone="red", weight=700)
    f.text(820, 142, "× 相交 = 线性一致", size=10.5, tone="red")
    f.text(820, 162, "× W=all 才安全", size=10.5, tone="red")
    save(f)


# ========================================================================== #
# 图 7：线性一致的历史
# ========================================================================== #
def f_linearizability():
    f = Fig("linearizability", 900, 390,
            "线性一致：读必须看到已返回的写",
            "写 x=1 在 t1 返回；t2 之后开始的读若返回 0，则违反线性一致。",
            "线性一致的判定不是看「有没有复制」，而是看能否找到一个全序，既尊重每个操作的"
            "实时区间，又让读返回该全序中最近一次写的值。图中下半部分给出反例。")
    c1, c2 = 150, 620
    f.lifeline(c1, 90, 330, "客户端 A")
    f.lifeline(c2, 90, 330, "客户端 B")
    # write interval
    f.body.append(f'<rect x="{c1}" y="120" width="230" height="22" fill="{TONES["accent"]}" fill-opacity=".18" stroke="{TONES["accent"]}"/>')
    f.text(c1 + 115, 136, "write x=1", size=11, tone="accent")
    f.line(c1 + 230, 104, c1 + 230, 340, tone="muted", dash=True)
    f.text(c1 + 230, 98, "t1 写返回", size=10.5, tone="ink2")
    # read interval
    f.body.append(f'<rect x="{c2 - 100}" y="210" width="210" height="22" fill="{TONES["sage"]}" fill-opacity=".18" stroke="{TONES["sage"]}"/>')
    f.text(c2 - 0, 226, "read x ?", size=11, tone="sage")
    f.line(c2 - 100, 194, c2 - 100, 340, tone="muted", dash=True)
    f.text(c2 - 100, 188, "t2 读开始", size=10.5, tone="ink2")
    f.text(430, 300, "t2 > t1 ⇒ 读必须返回 1（或更新的值）", size=12, tone="ink", weight=700)
    f.text(430, 330, "返回 0 = stale read = 违反线性一致", size=11.5, tone="red")
    f.text(430, 360, "返回 timeout 只是 unknown，不构成反例", size=10.5, tone="muted")
    save(f)


# ========================================================================== #
# 图 8：Raft 状态机
# ========================================================================== #
def f_raft_states():
    f = Fig("raft-states", 900, 400,
            "Raft 的三个角色与迁移条件",
            "Follower 在选举超时后成为 Candidate；获得多数票成为 Leader；发现更高 term 退回 Follower。",
            "Raft 把「什么时候可以投票」「什么时候可以提交」绑定到 term 和日志新旧。"
            "图中每条边都对应一个必须检查的条件，少一个就会出现双主或丢日志。")
    f.box(90, 150, 170, 72, "Follower", "被动接收 AppendEntries", tone="muted")
    f.box(370, 60, 170, 72, "Candidate", "term+1，拉票", tone="gold")
    f.box(370, 250, 170, 72, "Leader", "心跳 + 复制", tone="accent")
    f.arrow(260, 170, 370, 110, "选举超时", tone="gold", lx=300, ly=120)
    f.arrow(455, 132, 455, 250, "获得多数票", tone="accent", lx=505, ly=195)
    f.arrow(370, 286, 260, 210, "发现更高 term", tone="muted", lx=300, ly=270)
    f.arrow(455, 250, 455, 132, "选举超时/平票", tone="gold", dash=True, lx=505, ly=200)
    f.arrow(455, 60, 455, 36, "", tone="muted", both=False)
    f.text(455, 24, "term 增大", size=10, tone="muted")
    f.arrow(370, 96, 260, 150, "收到更高 term", tone="red", dash=True, lx=300, ly=86)
    f.text(90, 300, "安全规则", size=12, tone="ink", weight=700)
    f.text(90, 324, "· 每个 term 最多投一票", size=10.5, tone="ink2", anchor="start")
    f.text(90, 344, "· 只给日志不旧于自己的候选人投票", size=10.5, tone="ink2", anchor="start")
    f.text(90, 364, "· 只提交当前 term 的日志项（旧 term 间接提交）", size=10.5, tone="ink2", anchor="start")
    save(f)


# ========================================================================== #
# 图 9：一次 Raft 选举
# ========================================================================== #
def f_raft_election():
    f = Fig("raft-election", 900, 430,
            "一次 Raft 选举：term 1 平票，term 2 选出 leader",
            "三个节点在 term 1 各自拉票导致平票；随机超时后节点 B 在 term 2 先发起并赢得多数。",
            "随机化选举超时是打破平票的关键；没有它，三个节点可能在同一时刻反复拉票，"
            "形成活锁。图中 term 2 的 B 先超时，所以它拿到了 A 和 C 的票。")
    xs = [150, 450, 750]
    for x, name in zip(xs, ["A", "B", "C"]):
        f.lifeline(x, 80, 380, f"节点 {name}")
    f.text(450, 60, "term 1：三方同时超时", size=11, tone="gold", weight=700)
    for x in xs:
        f.arrow(x, 105, 450 if x != 450 else 150, 125, "RequestVote", tone="gold",
                lx=(x + 450) / 2, ly=112)
    f.text(450, 160, "都没有拿到多数票 → 超时，term+1", size=10.5, tone="red")
    f.text(450, 205, "term 2：B 先超时（随机 150–300 ms）", size=11, tone="accent", weight=700)
    f.arrow(450, 225, 150, 245, "RequestVote(term=2)", tone="accent", lx=300, ly=228)
    f.arrow(450, 225, 750, 245, "RequestVote(term=2)", tone="accent", lx=600, ly=228)
    f.arrow(150, 265, 450, 285, "投票", tone="sage", lx=300, ly=270)
    f.arrow(750, 265, 450, 285, "投票", tone="sage", lx=600, ly=270)
    f.text(450, 315, "B 获得 2/3 票 → Leader", size=11.5, tone="green", weight=700)
    f.arrow(450, 330, 150, 350, "AppendEntries(term=2)", tone="muted", lx=300, ly=335)
    f.arrow(450, 330, 750, 350, "AppendEntries(term=2)", tone="muted", lx=600, ly=335)
    f.text(450, 405, "关键：每个节点在 term 2 只投一票；B 的日志必须不旧于投票者。",
           size=10.5, tone="muted")
    save(f)


# ========================================================================== #
# 图 10：MVCC 版本链
# ========================================================================== #
def f_mvcc():
    f = Fig("mvcc", 900, 390,
            "MVCC：读快照，写新版本",
            "x 的版本链 0→1→2；事务 T1 的快照看到 1，T2 的快照看到 2，旧版本由 vacuum 回收。",
            "快照隔离下，读不阻塞写、写不阻塞读；代价是旧版本要保留，长事务会拖住回收。"
            "图中 T1 在 T2 提交后仍然读到 1，这不是 bug，而是快照的语义。")
    f.line(70, 190, 840, 190, tone="ink", width=1.6)
    versions = [
        (140, "v0", "x=0", "T0", "muted"),
        (360, "v1", "x=1", "T1 写", "accent"),
        (600, "v2", "x=2", "T2 写", "sage"),
    ]
    for x, v, val, who, tone in versions:
        f.circle(x, 190, 30, v, tone=tone, size=11)
        f.text(x, 240, val, size=12, tone="ink", mono=True)
        f.text(x, 260, who, size=10.5, tone="muted")
    f.arrow(170, 190, 330, 190, "", tone="muted")
    f.arrow(390, 190, 570, 190, "", tone="muted")
    f.box(250, 60, 180, 54, "T1 快照", "可见 v1，不可见 v2", tone="accent", title_size=11)
    f.box(540, 60, 180, 54, "T2 快照", "可见 v2", tone="sage", title_size=11)
    f.arrow(340, 114, 360, 160, "", tone="accent", dash=True)
    f.arrow(630, 114, 600, 160, "", tone="sage", dash=True)
    f.text(450, 320, "旧版本保留到没有快照需要它；长事务 = vacuum 无法回收。",
           size=11, tone="muted")
    f.text(450, 345, "写偏斜：两个事务各读一部分、各写另一部分，快照隔离下仍可能破坏不变量。",
           size=10.5, tone="red")
    save(f)


# ========================================================================== #
# 图 11：日志、offset 与重复投递
# ========================================================================== #
def f_log_offsets():
    f = Fig("log-offsets", 900, 400,
            "日志、消费者 offset 与重复投递",
            "消息 0–7 按顺序写入；消费者处理到 5，但 offset 只提交到 4，崩溃后 5 被重投。",
            "「处理成功」和「offset 提交成功」是两个动作；两者之间崩溃，就会重复。"
            "把业务写与 offset 放在同一个事务里，或者让消费幂等，才能把重复变成无害。")
    f.text(60, 70, "分区日志（append-only）", size=12, tone="ink", weight=700, anchor="start")
    for i in range(8):
        x = 80 + i * 95
        tone = "sage" if i < 5 else ("gold" if i == 5 else "muted")
        f.box(x, 90, 82, 46, f"msg {i}", f"offset {i}", tone=tone, title_size=10, sub_size=9)
    f.line(80, 160, 840, 160, tone="muted")
    f.text(80, 182, "已提交 offset = 4", size=10.5, tone="sage", anchor="start")
    f.text(560, 182, "已处理到 5，但提交前崩溃", size=10.5, tone="red", anchor="start")
    f.arrow(560, 210, 560, 250, "重启后从 5 重投", tone="gold", lx=650, ly=232)
    f.box(500, 255, 130, 40, "msg 5 再来一次", "副作用可能翻倍", tone="red", title_size=10, sub_size=9)
    f.text(450, 335, "至少一次 = 允许重复；有效一次 = 业务去重 + 原子提交。",
           size=11.5, tone="ink2")
    save(f)


# ========================================================================== #
# 图 12：缓存与 CDN 路径
# ========================================================================== #
def f_cache_path():
    f = Fig("cache-path", 900, 420,
            "缓存与 CDN：命中、回源与失效",
            "客户端先到边缘 CDN，再到本地缓存；未命中才回源到对象存储/数据库，失效要同时覆盖边缘与本地。",
            "缓存层数越多，命中率越高，失效路径也越长。一次 purge 只清边缘，本地缓存仍可能返回旧值；"
            "TTL 是兜底，不是一致性方案。")
    f.box(30, 100, 120, 62, "客户端", "浏览器/APP", tone="accent")
    f.box(200, 90, 150, 82, "CDN 边缘", "cache key / TTL", tone="sage")
    f.box(400, 90, 145, 82, "服务缓存", "Redis/本地", tone="blue")
    f.box(600, 90, 150, 82, "源站", "DB/对象存储", tone="gold")
    f.box(600, 250, 150, 62, "对象存储", "S3 兼容", tone="purple")
    f.arrow(150, 131, 200, 131, "1", tone="accent", lx=175, ly=121)
    f.arrow(350, 131, 400, 131, "2", tone="sage", lx=375, ly=121)
    f.arrow(545, 131, 600, 131, "3 回源", tone="blue", lx=572, ly=121)
    f.arrow(675, 172, 675, 250, "读对象", tone="gold", lx=720, ly=212)
    f.text(200, 210, "HIT：直接返回", size=10.5, tone="sage", anchor="start")
    f.text(400, 230, "MISS：回源 + 回填", size=10.5, tone="blue", anchor="start")
    f.text(600, 340, "失效：purge 边缘 + 删本地 + 版本号", size=10.5, tone="red", anchor="start")
    f.arrow(275, 172, 275, 220, "", tone="red", dash=True)
    f.text(275, 240, "stale-while-revalidate", size=10, tone="muted")
    f.text(450, 380, "命中最怕陈旧；回源最怕击穿；失效最怕只清一半。",
           size=11.5, tone="ink2")
    save(f)


# ========================================================================== #
# 图 13：fencing token
# ========================================================================== #
def f_fencing():
    f = Fig("fencing", 900, 400,
            "租约过期与 fencing token",
            "客户端 A 在 GC 停顿时租约过期；B 获得 fence=2；A 恢复后带 fence=1 的写被资源拒绝。",
            "加长 TTL 不能解决停顿，只能降低概率；真正的解法是资源端记住见过的最大 token，"
            "拒绝所有更小的 token。锁服务只负责发号，资源端负责执行。")
    f.lifeline(150, 80, 360, "客户端 A")
    f.lifeline(450, 80, 360, "锁服务")
    f.lifeline(750, 80, 360, "资源端")
    f.arrow(150, 110, 450, 110, "acquire → lease=30s, fence=1", tone="accent", lx=300, ly=100)
    f.box(200, 130, 120, 34, "A 暂停（GC）", "租约继续走", tone="gold", title_size=10, sub_size=9)
    f.arrow(450, 190, 150, 190, "租约到期", tone="red", lx=300, ly=180)
    f.arrow(450, 220, 750, 220, "B acquire → fence=2", tone="sage", lx=600, ly=210)
    f.arrow(750, 250, 750, 280, "接受 fence=2", tone="green", lx=810, ly=268)
    f.arrow(150, 290, 750, 290, "A 恢复：write(fence=1)", tone="red", lx=450, ly=280)
    f.text(750, 315, "拒绝：1 < 2", size=11, tone="red", weight=700)
    f.text(450, 380, "锁的正确性不只在锁服务，还在被保护资源是否校验 token。",
           size=11.5, tone="ink2")
    save(f)


# ========================================================================== #
# 图 14：trace 瀑布
# ========================================================================== #
def f_trace_waterfall():
    f = Fig("trace-waterfall", 900, 420,
            "Trace 瀑布：一次请求的 span 与重复 span",
            "根 span 1 s；下游 A 240 ms，B 380 ms；一次重试产生第二个 B span，总耗时被拉长。",
            "trace 的价值是显示「时间花在哪」，不是「有没有报错」。重复 span 如果不标 attempt，"
            "会被误读成两个独立下游调用；指标也会把重试算成额外流量。")
    f.line(180, 80, 180, 380, tone="muted", width=1)
    f.line(860, 80, 860, 380, tone="muted", width=1)
    f.text(180, 66, "0 ms", size=10, tone="muted", mono=True)
    f.text(860, 66, "1000 ms", size=10, tone="muted", mono=True)
    spans = [
        ("root  POST /tool", 0, 1000, "accent"),
        ("edge  auth/limit", 30, 90, "sage"),
        ("A     rpc", 150, 240, "blue"),
        ("B     rpc (attempt=1)", 220, 380, "purple"),
        ("B     rpc (attempt=2)", 650, 250, "red"),
        ("DB    commit", 700, 120, "gold"),
    ]
    for i, (name, start, dur, tone) in enumerate(spans):
        y = 100 + i * 42
        x = 180 + start * 0.68
        w = max(dur * 0.68, 4)
        f.text(170, y + 14, name, size=10, tone="ink2", anchor="end", mono=True)
        f.body.append(f'<rect x="{x:.1f}" y="{y}" width="{w:.1f}" height="20" '
                      f'fill="{TONES[tone]}" fill-opacity=".22" stroke="{TONES[tone]}"/>')
    f.text(450, 390, "重复 span 必须带 attempt/retry 标记，否则会被当成两次独立调用。",
           size=10.5, tone="red")
    save(f)


# ========================================================================== #
# 图 15：利用率曲线
# ========================================================================== #
def f_utilization():
    f = Fig("utilization", 900, 390,
            "利用率与延迟：70% 之后的非线性",
            "横轴利用率 ρ，纵轴相对延迟；ρ 接近 1 时排队时间按 1/(1-ρ) 增长。",
            "容量规划不能只看 CPU 平均值。70% 是常见的告警起点，90% 时一次小抖动就可能"
            "把队列推满；重试会在高利用率下进一步放大到达率。")
    ox, oy, w, h = 90, 320, 700, 240
    f.line(ox, oy, ox + w, oy, tone="ink", width=1.2)
    f.line(ox, oy, ox, oy - h, tone="ink", width=1.2)
    f.text(ox + w / 2, oy + 45, "利用率 ρ", size=11, tone="ink2")
    f.text(ox - 45, oy - h / 2, "延迟", size=11, tone="ink2")
    for rho, label in [(0.5, "50%"), (0.7, "70%"), (0.9, "90%")]:
        x = ox + rho * w
        f.line(x, oy, x, oy - h, tone="muted", dash=True)
        f.text(x, oy + 18, label, size=10, tone="muted", mono=True)
    # 1/(1-rho) 曲线，归一化
    pts = []
    for i in range(0, 96):
        rho = i / 100
        val = 1 / max(1 - rho, 0.04)
        y = oy - min(val / 12.5, 1.0) * (h - 10)
        pts.append((ox + rho * w, y))
    path = "M" + " L".join(f"{x:.1f} {y:.1f}" for x, y in pts)
    f.body.append(f'<path d="{path}" fill="none" stroke="{TONES["accent"]}" stroke-width="2.4"/>')
    f.line(ox + 0.7 * w, oy, ox + 0.7 * w, oy - 0.35 * h, tone="gold", width=2)
    f.text(ox + 0.72 * w, oy - 0.38 * h, "膝点 70%", size=10.5, tone="gold", anchor="start")
    f.line(ox + 0.9 * w, oy, ox + 0.9 * w, oy - 0.8 * h, tone="red", width=2)
    f.text(ox + 0.8 * w, oy - 0.85 * h, "90%：小抖动即过载", size=10.5, tone="red", anchor="end")
    f.text(450, 380, "留 headroom 不是浪费，是给排队和重试留空间。", size=11, tone="muted")
    save(f)


# ========================================================================== #
# 图 16：幂等记录状态机
# ========================================================================== #
def f_idempotency_state():
    f = Fig("idempotency-state", 900, 410,
            "幂等记录：同一把钥匙只能产生一次副作用",
            "新键创建记录；执行中持有租约；成功后同键请求直接返回结果；失败可重试；租约过期可被接管。",
            "幂等表不是「缓存响应」，而是一台状态机：键、指纹、状态、租约、结果、副作用 ID 缺一不可。"
            "只有状态机才能同时处理并发重复、崩溃恢复和参数冲突。")
    f.box(40, 160, 150, 64, "new", "键不存在", tone="muted")
    f.box(250, 160, 160, 64, "in_progress", "lease_until 未到", tone="accent")
    f.box(480, 60, 160, 60, "succeeded", "结果 + effect_id", tone="green")
    f.box(480, 260, 160, 60, "failed", "可重试/不可重试", tone="red")
    f.box(250, 320, 160, 56, "expired", "租约到期，可接管", tone="gold", dash=True)
    f.arrow(190, 192, 250, 192, "begin", tone="accent", lx=220, ly=182)
    f.arrow(410, 176, 480, 100, "commit", tone="green", lx=455, ly=120)
    f.arrow(410, 208, 480, 270, "error", tone="red", lx=455, ly=250)
    f.arrow(330, 224, 330, 320, "lease 超时", tone="gold", lx=380, ly=280)
    f.arrow(330, 320, 330, 224, "同键重试接管", tone="muted", dash=True, lx=270, ly=280)
    f.arrow(480, 90, 620, 150, "同键请求", tone="sage", lx=560, ly=110)
    f.arrow(620, 150, 620, 250, "", tone="sage")
    f.text(650, 160, "返回原结果", size=10.5, tone="sage", anchor="start")
    f.text(650, 182, "attempts 不增加", size=10.5, tone="muted", anchor="start")
    f.text(650, 280, "参数不同 → 409", size=10.5, tone="red", anchor="start")
    f.text(450, 392, "键相同 + 指纹不同 = 客户端 bug，必须拒绝，不能覆盖。",
           size=10.5, tone="muted")
    save(f)


# ========================================================================== #
# 图 17：复制日志与提交
# ========================================================================== #
def f_kv_replication():
    f = Fig("kv-replication", 900, 440,
            "三节点复制：日志、matchIndex 与 commitIndex",
            "leader 把日志复制到两个 follower；多数派 matchIndex 达到 3 后 commitIndex 推进到 3，状态机应用。",
            "提交不是「leader 写了」而是「多数派持久化了」。图中 follower B 只到 2，但 A+C 已到 3，"
            "所以 3 可以提交；如果 leader 在提交前崩溃，新 leader 必须带上已提交的日志。")
    f.box(50, 90, 150, 52, "客户端", "put k=v", tone="accent")
    f.box(300, 80, 180, 70, "Leader A", "term=2, commit=2", tone="accent")
    f.box(620, 60, 170, 56, "Follower B", "match=2", tone="muted")
    f.box(620, 150, 170, 56, "Follower C", "match=3", tone="sage")
    f.arrow(200, 116, 300, 116, "append", tone="accent", lx=250, ly=106)
    f.arrow(480, 100, 620, 88, "AppendEntries", tone="accent", lx=550, ly=80)
    f.arrow(480, 130, 620, 178, "AppendEntries", tone="accent", lx=550, ly=168)
    f.arrow(620, 116, 480, 116, "ack 2", tone="muted", lx=550, ly=132)
    f.arrow(620, 206, 480, 140, "ack 3", tone="sage", lx=550, ly=200)
    # logs
    f.text(300, 240, "日志索引", size=11, tone="ink", weight=700, anchor="start")
    for i in range(1, 5):
        x = 300 + (i - 1) * 70
        committed = i <= 3
        f.box(x, 255, 58, 36, str(i), "已提交" if committed else "未提交",
              tone="sage" if committed else "muted", title_size=11, sub_size=8)
    f.text(300, 320, "commitIndex = 3：多数派（A、C）match ≥ 3", size=11, tone="green", anchor="start")
    f.text(300, 345, "状态机 apply 到 3；读请求至少等待 applied ≥ readIndex", size=10.5, tone="muted", anchor="start")
    f.text(300, 380, "若 leader 崩溃：新 leader 必须包含 index 3 的日志（选举限制）。",
           size=10.5, tone="red", anchor="start")
    save(f)


# ========================================================================== #
# 图 18：ReadIndex 线性一致读
# ========================================================================== #
def f_kv_readindex():
    f = Fig("kv-readindex", 900, 400,
            "ReadIndex：线性一致读为什么要一次心跳",
            "leader 记录当前 commitIndex 作为 readIndex，向多数派确认自己仍是 leader，再等 applied ≥ readIndex。",
            "如果 leader 已经被分区隔离，它本地仍有数据，直接读会返回旧值。ReadIndex 的心跳"
            "确认「多数派还认我」，然后再等状态机追上；两步缺一不可。")
    f.lifeline(120, 80, 350, "客户端")
    f.lifeline(400, 80, 350, "Leader")
    f.lifeline(700, 80, 350, "Follower 多数派")
    f.arrow(120, 110, 400, 110, "GET k (linearizable)", tone="accent", lx=260, ly=100)
    f.arrow(400, 140, 700, 140, "heartbeat（确认 leadership）", tone="gold", lx=550, ly=130)
    f.arrow(700, 170, 400, 170, "ack（多数派）", tone="sage", lx=550, ly=160)
    f.box(330, 190, 140, 44, "readIndex = commit", "记录当前提交位置", tone="gold", title_size=10, sub_size=9)
    f.arrow(400, 240, 400, 280, "等待 applied ≥ readIndex", tone="blue", lx=520, ly=260)
    f.arrow(400, 300, 120, 320, "返回 200 + value", tone="green", lx=260, ly=310)
    f.text(700, 230, "若心跳拿不到多数派", size=10.5, tone="red", anchor="start")
    f.text(700, 250, "→ 拒绝读，不返回旧值", size=10.5, tone="red", anchor="start")
    f.text(450, 385, "lease read 省掉心跳，但依赖时钟；ReadIndex 不依赖时钟，代价是多一次 RTT。",
           size=10.5, tone="muted")
    save(f)


FIGURES = {
    "request-path": f_request_path,
    "request-state": f_request_state,
    "timeout-truth": f_timeout_truth,
    "retry-budget": f_retry_budget,
    "replication-topologies": f_replication_topologies,
    "quorum": f_quorum,
    "linearizability": f_linearizability,
    "raft-states": f_raft_states,
    "raft-election": f_raft_election,
    "mvcc": f_mvcc,
    "log-offsets": f_log_offsets,
    "cache-path": f_cache_path,
    "fencing": f_fencing,
    "trace-waterfall": f_trace_waterfall,
    "utilization": f_utilization,
    "idempotency-state": f_idempotency_state,
    "kv-replication": f_kv_replication,
    "kv-readindex": f_kv_readindex,
}


def main(argv):
    os.makedirs(OUT, exist_ok=True)
    names = argv[1:] or list(FIGURES)
    for name in names:
        if name not in FIGURES:
            raise SystemExit(f"未知图名：{name}（可用：{', '.join(FIGURES)}）")
        FIGURES[name]()
    if not argv[1:]:
        print(f"共 {len(FIGURES)} 张图 → {OUT}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
