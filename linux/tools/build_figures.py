#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成《Linux 系统与内核》的内联 SVG 图版。

输出 src/assets/figures/<name>.md，每份是一个完整的 <figure>，页面用
    {{#include ../assets/figures/<name>.md}}
引入。颜色全部走 CSS 变量，明暗主题自动跟随。

用法：
    python3 tools/build_figures.py            # 全部重建
    python3 tools/build_figures.py fd-table   # 只重建一张
"""

from __future__ import annotations

import html
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.normpath(os.path.join(HERE, "..", "src", "assets", "figures"))

# 语义色 → CSS 变量。tone 名字在正文里也用作图例。
TONES = {
    "accent": "var(--accent)",
    "cyan": "var(--atlas-cyan)",
    "gold": "var(--atlas-gold)",
    "plum": "var(--atlas-plum)",
    "muted": "var(--muted)",
    "ink": "var(--ink-2)",
    "red": "var(--fig-red, #b4473f)",
    "green": "var(--fig-green, #3f7a55)",
    "paper": "var(--paper)",
}


def esc(s: str) -> str:
    return html.escape(s, quote=True)


def text(x, y, s, size=12, tone="ink", anchor="start", mono=False, bold=False, opacity=1.0, letter=0):
    family = ("'SFMono-Regular','Roboto Mono',Consolas,monospace" if mono
              else "'PingFang SC','Hiragino Sans GB','Noto Sans SC','Microsoft YaHei',sans-serif")
    weight = 700 if bold else 400
    return (f'<text x="{x}" y="{y}" fill="{TONES.get(tone, tone)}" font-size="{size}" '
            f'font-weight="{weight}" font-family="{family}" text-anchor="{anchor}" '
            f'letter-spacing="{letter}" opacity="{opacity}">{esc(s)}</text>')


def box(x, y, w, h, title, sub="", tone="accent", rx=3, fill_opacity=0.05, dashed=False, mono=False):
    stroke = TONES.get(tone, tone)
    dash = ' stroke-dasharray="4 4"' if dashed else ""
    out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{stroke}" '
           f'fill-opacity="{fill_opacity}" stroke="{stroke}" stroke-opacity=".55"{dash}/>']
    if sub:
        out.append(text(x + w / 2, y + h / 2 - 3, title, 12.5, "ink", "middle", mono=mono, bold=True))
        out.append(text(x + w / 2, y + h / 2 + 14, sub, 10, "muted", "middle", mono=mono))
    else:
        out.append(text(x + w / 2, y + h / 2 + 4, title, 12.5, "ink", "middle", mono=mono, bold=True))
    return "".join(out)


def lane(x, y, w, h, label, tone="muted"):
    stroke = TONES.get(tone, tone)
    return (f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="4" fill="{stroke}" fill-opacity=".025" '
            f'stroke="{stroke}" stroke-opacity=".22" stroke-dasharray="2 5"/>'
            + text(x + 10, y + 17, label, 9.5, tone, mono=True, letter=1.1))


def arrow(x1, y1, x2, y2, label="", dashed=False, tone="muted", bidir=False):
    stroke = TONES.get(tone, tone)
    dash = ' stroke-dasharray="4 4"' if dashed else ""
    marker = "arrow-dim" if tone in ("muted",) else "arrow"
    mid = f' marker-end="url(#{marker})"'
    if bidir:
        mid += f' marker-start="url(#{marker})"'
    out = [f'<path d="M{x1} {y1} L{x2} {y2}" stroke="{stroke}" stroke-width="1.3" '
           f'stroke-opacity=".72"{dash}{mid}/>']
    if label:
        out.append(text((x1 + x2) / 2, (y1 + y2) / 2 - 5, label, 9.5, "muted", "middle", mono=True))
    return "".join(out)


def plate(name, title, desc, caption, body, w=900, h=420, kind="plate"):
    return f'''<figure class="fig-plate fig-wide has-fig-scroll" id="fig-{name}" data-fig-kind="{kind}">
<div class="fig-scroll">
<svg class="figure-svg atlas-plate" viewBox="0 0 {w} {h}" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="{name}-title {name}-desc">
<title id="{name}-title">{esc(title)}</title>
<desc id="{name}-desc">{esc(desc)}</desc>
<defs>
  <linearGradient id="{name}-bg" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0" style="stop-color:var(--paper)" stop-opacity=".97"/>
    <stop offset="1" style="stop-color:var(--paper-soft)" stop-opacity=".97"/>
  </linearGradient>
  <pattern id="{name}-grid" width="24" height="24" patternUnits="userSpaceOnUse">
    <path d="M24 0H0V24" fill="none" style="stroke:var(--ink)" stroke-opacity=".04"/>
  </pattern>
  <marker id="arrow" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--accent)"/></marker>
  <marker id="arrow-dim" viewBox="0 0 10 10" refX="8.4" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0 0 10 5 0 10Z" style="fill:var(--muted)"/></marker>
</defs>
<rect x="0" y="0" width="{w}" height="{h}" fill="url(#{name}-bg)"/>
<rect x="0" y="0" width="{w}" height="{h}" fill="url(#{name}-grid)" opacity=".5"/>
<rect x="0" y="0" width="3" height="{h}" style="fill:var(--accent)" fill-opacity=".5"/>
{body}
</svg>
</div>
<figcaption><b>读图：</b>{caption}</figcaption>
</figure>
'''


# --------------------------------------------------------------------------- #
# 图目录
# --------------------------------------------------------------------------- #

def fig_fd_table():
    b = []
    b.append(lane(28, 56, 250, 300, "PROCESS  ·  task_struct"))
    b.append(lane(310, 56, 270, 300, "OPEN FILE DESCRIPTION"))
    b.append(lane(612, 56, 258, 300, "INODE / DENTRY CACHE"))
    b.append(box(44, 88, 218, 36, "files_struct", "fd 表指针", "accent", mono=True))
    # fd rows
    rows = [("0", "stdin", "cyan"), ("1", "stdout", "cyan"), ("2", "stderr", "cyan"), ("3", "access.log", "gold"), ("4", "access.log", "gold")]
    for i, (fd, name, tone) in enumerate(rows):
        y = 142 + i * 38
        b.append(box(44, y, 62, 28, fd, "", tone, fill_opacity=.07, mono=True))
        b.append(box(114, y, 148, 28, name, "", tone, fill_opacity=.04, mono=True))
        b.append(text(222, y + 19, "→", 12, "muted", "end"))
    b.append(box(326, 88, 238, 36, "struct file", "偏移 off_t + 标志 + 引用计数", "gold", mono=True))
    b.append(box(326, 142, 238, 58, "f_count = 2", "dup / fork 共享同一 open file description", "gold", mono=True))
    b.append(box(326, 216, 238, 52, "f_op->read / write", "具体文件系统的方法表", "muted", mono=True))
    b.append(box(326, 284, 238, 52, "f_pos", "共享偏移：两个 fd 指向同一 struct file 时互相影响", "red", mono=True))
    b.append(box(628, 88, 226, 36, "struct inode", "类型 / 权限 / 大小 / 时间", "plum", mono=True))
    b.append(box(628, 142, 226, 52, "i_ino / i_nlink", "磁盘上的对象身份", "plum", mono=True))
    b.append(box(628, 212, 226, 52, "address_space", "page cache 的宿主", "cyan", mono=True))
    b.append(box(628, 282, 226, 52, "i_op / i_fop", "inode 操作与文件操作", "muted", mono=True))
    b.append(arrow(286, 160, 320, 106, "fd → file", tone="muted"))
    b.append(arrow(286, 178, 320, 168, "", tone="muted"))
    b.append(arrow(568, 106, 620, 106, "file → inode", tone="muted"))
    b.append(arrow(568, 230, 620, 236, "", tone="muted"))
    b.append(text(450, 386, "同一 inode 可被多个 struct file 打开；同一 struct file 可被多个 fd 共享（dup/fork）", 11, "muted", "middle"))
    return plate("fd-table", "文件描述符、打开文件描述与 inode 的三层关系",
                 "fd 是进程内的下标；struct file 保存偏移与标志；inode 表示文件本身。",
                 "先看左边 fd 表：0/1/2 指向终端，3/4 指向同一日志文件。3 和 4 是两个独立的 <code>struct file</code>，各有自己的偏移；如果它们由 <code>dup()</code> 或 <code>fork()</code> 产生，则共享同一个 <code>struct file</code>，偏移也共享——这是「两个进程同时写日志却互相覆盖」的根源。",
                 "".join(b))


def fig_io_path():
    b = []
    b.append(lane(28, 54, 844, 116, "USER SPACE"))
    b.append(lane(28, 184, 844, 104, "KERNEL SPACE  ·  PAGE CACHE"))
    b.append(lane(28, 302, 844, 84, "BLOCK / DEVICE"))
    b.append(box(48, 78, 140, 66, "应用缓冲区", "buf / count", "accent", mono=True))
    b.append(box(220, 78, 150, 66, "read()/write()", "系统调用入口", "accent", mono=True))
    b.append(box(402, 78, 170, 66, "copy_to/from_user", "用户页与内核页之间拷贝", "cyan", mono=True))
    b.append(box(604, 78, 244, 66, "返回用户态", "短读 / 部分写 / EINTR", "gold", mono=True))
    b.append(box(48, 208, 180, 58, "page cache", "以 page 为单位缓存文件内容", "cyan", mono=True))
    b.append(box(260, 208, 180, 58, "address_space", "inode 的页集合 + xarray", "plum", mono=True))
    b.append(box(472, 208, 180, 58, "writeback", "脏页回写（pdflush / wb）", "gold", mono=True))
    b.append(box(684, 208, 164, 58, "readahead", "顺序读预取", "accent", mono=True))
    b.append(box(48, 322, 200, 46, "块设备层", "bio / request", "muted", mono=True))
    b.append(box(280, 322, 200, 46, "I/O 调度", "mq-deadline / kyber", "muted", mono=True))
    b.append(box(512, 322, 200, 46, "驱动 + DMA", "NVMe / virtio", "muted", mono=True))
    b.append(box(744, 322, 104, 46, "持久介质", "NAND / 磁盘", "muted", mono=True))
    b.append(arrow(188, 111, 216, 111, tone="accent"))
    b.append(arrow(370, 111, 398, 111, tone="accent"))
    b.append(arrow(572, 111, 600, 111, tone="accent"))
    b.append(arrow(118, 144, 118, 204, "write 命中缓存即返回", tone="cyan"))
    b.append(arrow(468, 144, 468, 204, "read 未命中才下盘", tone="cyan", dashed=True))
    b.append(arrow(228, 237, 256, 237, tone="muted"))
    b.append(arrow(440, 237, 468, 237, tone="muted"))
    b.append(arrow(562, 266, 562, 318, "脏页累积后回写", tone="gold"))
    b.append(arrow(150, 266, 150, 318, "", tone="muted"))
    b.append(arrow(248, 345, 276, 345, tone="muted"))
    b.append(arrow(480, 345, 508, 345, tone="muted"))
    b.append(arrow(712, 345, 740, 345, tone="muted"))
    b.append(text(450, 404, "写路径：用户 → page cache → (延迟) → 块层 → 设备；读路径：page cache 命中则完全不进块层", 11, "muted", "middle"))
    return plate("io-path", "一次 read/write 在用户态、page cache 与块层之间的路径",
                 "写通常只到 page cache；读未命中才触发块层 I/O。",
                 "沿实线看写路径：<code>write()</code> 把数据拷进 page cache 就返回，脏页由回写线程择机下盘；沿虚线看读路径：命中 page cache 时根本不经过块层。因此 <code>write()</code> 返回 ≠ 落盘，<code>read()</code> 也不一定读磁盘。",
                 "".join(b), h=420)


def fig_proc_states():
    b = []
    b.append(text(450, 46, "进程状态机（Linux 6.x，task_struct->__state）", 13, "ink", "middle", bold=True))
    # nodes
    b.append(box(60, 90, 150, 54, "TASK_RUNNING", "可运行 / 正在运行", "green", mono=True))
    b.append(box(300, 90, 150, 54, "TASK_INTERRUPTIBLE", "可被信号唤醒", "cyan", mono=True))
    b.append(box(540, 90, 150, 54, "TASK_UNINTERRUPTIBLE", "不可被信号唤醒", "gold", mono=True))
    b.append(box(300, 230, 150, 54, "TASK_STOPPED", "SIGSTOP / 调试", "muted", mono=True))
    b.append(box(540, 230, 150, 54, "TASK_ZOMBIE", "已退出，等待 wait", "red", mono=True))
    b.append(box(60, 230, 150, 54, "TASK_TRACED", "被 ptrace 暂停", "plum", mono=True))
    b.append(box(300, 340, 150, 54, "EXIT_DEAD", "彻底释放", "muted", mono=True))
    b.append(arrow(210, 117, 296, 117, "等待事件", tone="cyan"))
    b.append(arrow(296, 132, 214, 132, "事件就绪 / 唤醒", tone="green"))
    b.append(arrow(450, 117, 536, 117, "等待 I/O", tone="gold"))
    b.append(arrow(536, 132, 454, 132, "I/O 完成", tone="green"))
    b.append(arrow(360, 144, 360, 226, "SIGSTOP", tone="muted"))
    b.append(arrow(430, 250, 536, 250, "SIGCONT", tone="muted", dashed=True))
    b.append(arrow(600, 144, 600, 226, "exit()", tone="red"))
    b.append(arrow(600, 284, 456, 360, "wait() 回收", tone="muted"))
    b.append(arrow(150, 144, 150, 226, "ptrace", tone="plum"))
    b.append(text(450, 402, "就绪队列只收 TASK_RUNNING；睡眠状态通过等待队列唤醒；ZOMBIE 占的是 task_struct，不是内存页", 10.5, "muted", "middle"))
    return plate("proc-states", "进程状态与迁移",
                 "运行、可中断睡眠、不可中断睡眠、停止、僵尸与退出。",
                 "重点看两条环：可运行 ↔ 可中断睡眠（等待队列 + 唤醒），以及运行 → 僵尸 → 回收。不可中断睡眠（D 状态）不响应信号，常见于磁盘 I/O；大量 D 状态通常意味着 I/O 或文件系统卡住。",
                 "".join(b), h=420)


def fig_va_translate():
    b = []
    b.append(text(450, 44, "x86-64 四级页表：48 位虚拟地址如何变成物理地址", 13, "ink", "middle", bold=True))
    b.append(text(70, 82, "虚拟地址 47…0", 10.5, "muted", mono=True))
    # bit fields
    fields = [("PMLE4", 9, "cyan"), ("PML4", 9, "cyan"), ("PDPT", 9, "accent"), ("PD", 9, "accent"), ("PT", 9, "gold"), ("OFFSET", 12, "green")]
    x = 60
    for name, bits, tone in fields:
        w = bits * 17
        b.append(f'<rect x="{x}" y="94" width="{w}" height="34" fill="{TONES[tone]}" fill-opacity=".08" stroke="{TONES[tone]}" stroke-opacity=".5"/>')
        b.append(text(x + w / 2, 110, name, 9, "ink", "middle", mono=True, bold=True))
        b.append(text(x + w / 2, 124, f"{bits}b", 8.5, "muted", "middle", mono=True))
        x += w + 2
    b.append(text(70, 158, "CR3 → PML4 基址", 10.5, "muted", mono=True))
    # levels
    b.append(box(56, 176, 150, 58, "PML4E", "取 9 位索引 → PDPT", "cyan", mono=True))
    b.append(box(244, 176, 150, 58, "PDPTE", "1 GiB 大页可分叉", "cyan", mono=True))
    b.append(box(432, 176, 150, 58, "PDE", "2 MiB 大页可分叉", "accent", mono=True))
    b.append(box(620, 176, 150, 58, "PTE", "4 KiB 页基址", "gold", mono=True))
    b.append(box(56, 286, 150, 58, "物理页框", "PFN + 权限位", "green", mono=True))
    b.append(box(244, 286, 150, 58, "TLB", "缓存最近翻译", "plum", mono=True))
    b.append(box(432, 286, 150, 58, "缺页异常", "页不在内存 / 权限不符", "red", mono=True))
    b.append(box(620, 286, 150, 58, "page fault 处理", "分配页 / COW / 换入", "muted", mono=True))
    b.append(arrow(206, 205, 240, 205, tone="muted"))
    b.append(arrow(394, 205, 428, 205, tone="muted"))
    b.append(arrow(582, 205, 616, 205, tone="muted"))
    b.append(arrow(131, 234, 131, 282, "命中 TLB 则跳过", tone="plum", dashed=True))
    b.append(arrow(695, 234, 695, 282, "未命中 → 硬件/内核", tone="red"))
    b.append(arrow(506, 315, 616, 315, "处理完重试指令", tone="muted"))
    b.append(text(450, 390, "每级 9 位、页内 12 位：单级页表 512 项；48 位地址空间 = 256 TiB；大页减少级数与 TLB 压力", 10.5, "muted", "middle"))
    return plate("va-translate", "虚拟地址到物理地址的四级翻译",
                 "CR3 指向 PML4，逐级取 9 位索引，最后加 12 位页内偏移。",
                 "从右往左读位域：低 12 位是页内偏移，上面四级各 9 位。每级页表 512 项；TLB 命中时整条路径被短路。PDE/PDPTE 的大页位可以让翻译提前结束——这是 2 MiB/1 GiB 大页降低 TLB miss 的原理。",
                 "".join(b), h=420)


def fig_tcp_handshake():
    b = []
    b.append(text(110, 56, "CLIENT", 11, "cyan", "middle", mono=True, bold=True))
    b.append(text(790, 56, "SERVER", 11, "accent", "middle", mono=True, bold=True))
    b.append(f'<path d="M110 76v300M790 76v300" stroke="{TONES["muted"]}" stroke-opacity=".35" stroke-dasharray="3 5"/>')
    b.append(text(450, 46, "TCP 三次握手与连接队列", 13, "ink", "middle", bold=True))
    b.append(f'<path d="M110 110 L790 160" stroke="{TONES["cyan"]}" stroke-width="1.6" marker-end="url(#arrow)"/>')
    b.append(text(300, 118, "SYN  seq=x", 10, "cyan", mono=True))
    b.append(f'<path d="M790 190 L110 240" stroke="{TONES["accent"]}" stroke-width="1.6" marker-end="url(#arrow)"/>')
    b.append(text(420, 200, "SYN+ACK  seq=y, ack=x+1", 10, "accent", mono=True))
    b.append(f'<path d="M110 270 L790 320" stroke="{TONES["cyan"]}" stroke-width="1.6" marker-end="url(#arrow)"/>')
    b.append(text(300, 278, "ACK  seq=x+1, ack=y+1", 10, "cyan", mono=True))
    # queues
    b.append(box(560, 100, 250, 54, "SYN queue", "半连接：收到 SYN，已回 SYN-ACK", "gold", mono=True))
    b.append(box(560, 180, 250, 54, "accept queue", "全连接：三次握手完成，等待 accept", "green", mono=True))
    b.append(arrow(700, 158, 700, 176, "收到 ACK", tone="gold"))
    b.append(box(250, 340, 400, 46, "backlog = min(somaxconn, listen(fd, n))", "队列满：默认丢弃 / 忽略 ACK", "red", mono=True))
    b.append(text(450, 406, "SYN 队列长度由 tcp_max_syn_backlog 控制；accept 队列由 listen backlog 控制；ss -lnt 的 Recv-Q 是后者当前长度", 10.5, "muted", "middle"))
    return plate("tcp-handshake", "TCP 三次握手与两个连接队列",
                 "SYN 进入半连接队列，ACK 后移入 accept 队列，accept() 取走。",
                 "上半部分是报文时序，下半部分是服务端内核的两个队列。注意：<code>listen()</code> 的 backlog 只约束 accept 队列；SYN flood 打的是 SYN 队列（<code>tcp_syncookies</code> 是另一条防线）。<code>ss -lnt</code> 的 <code>Recv-Q</code> 就是 accept 队列里等待被取走的连接数。",
                 "".join(b), h=420)


def fig_epoll():
    b = []
    b.append(lane(28, 54, 400, 320, "USER"))
    b.append(lane(448, 54, 424, 320, "KERNEL"))
    b.append(box(48, 84, 160, 52, "epoll_create1()", "返回 epfd", "accent", mono=True))
    b.append(box(48, 160, 160, 52, "epoll_ctl(ADD)", "注册 fd + event", "cyan", mono=True))
    b.append(box(48, 236, 160, 52, "epoll_wait()", "阻塞等待就绪链表", "gold", mono=True))
    b.append(box(240, 84, 168, 52, "epfd → eventpoll", "红黑树 + 就绪链表", "accent", mono=True))
    b.append(box(468, 84, 180, 52, "struct eventpoll", "rbr 红黑树 / rdllist 就绪链", "accent", mono=True))
    b.append(box(468, 160, 180, 52, "struct epitem", "每个 fd 一个", "cyan", mono=True))
    b.append(box(468, 236, 180, 52, "等待队列", "epoll_wait 睡眠在这里", "gold", mono=True))
    b.append(box(688, 160, 164, 52, "socket wait queue", "sk_wq / poll 回调", "plum", mono=True))
    b.append(box(688, 236, 164, 52, "就绪回调", "ep_poll_callback", "red", mono=True))
    b.append(arrow(208, 110, 236, 110, tone="muted"))
    b.append(arrow(208, 186, 236, 186, "", tone="muted"))
    b.append(arrow(208, 262, 236, 262, "", tone="muted"))
    b.append(arrow(424, 110, 464, 110, "fd 表", tone="muted"))
    b.append(arrow(558, 136, 558, 156, "", tone="muted"))
    b.append(arrow(558, 212, 558, 232, "", tone="muted"))
    b.append(arrow(648, 186, 684, 186, "注册", tone="cyan"))
    b.append(arrow(770, 212, 770, 232, "", tone="plum"))
    b.append(arrow(684, 262, 652, 262, "事件就绪 → 挂入 rdllist", tone="red"))
    b.append(arrow(648, 262, 212, 262, "唤醒 epoll_wait", tone="gold"))
    b.append(text(450, 402, "epoll 不是「轮询所有 fd」：fd 注册一次，事件由回调挂到就绪链表，epoll_wait 只取链表", 10.5, "muted", "middle"))
    return plate("epoll", "epoll 的红黑树、就绪链表与回调",
                 "epoll_ctl 注册 epitem；事件发生时回调把 epitem 挂到 rdllist；epoll_wait 取链表。",
                 "先看右侧内核：每个被监听的 fd 对应一个 <code>epitem</code>，挂在红黑树上；socket 的等待队列注册 <code>ep_poll_callback</code>。数据到达时回调把 epitem 挂到就绪链表并唤醒 <code>epoll_wait</code>。因此 epoll 的复杂度与「就绪 fd 数」相关，而不是「监听 fd 总数」——这是它能撑百万连接的核心。",
                 "".join(b), h=420)


def fig_rx_path():
    b = []
    b.append(text(450, 42, "Linux 收包路径：从网卡到 socket", 13, "ink", "middle", bold=True))
    stages = [
        ("NIC", "DMA 写入 RX ring", "muted"),
        ("硬中断", "napi_schedule", "red"),
        ("NET_RX_SOFTIRQ", "net_rx_action", "gold"),
        ("NAPI poll", "napi_poll / 驱动 poll", "gold"),
        ("netif_receive_skb", "协议分发", "accent"),
        ("ip_rcv", "路由 / 分片", "accent"),
        ("tcp_v4_rcv", "查 socket", "cyan"),
        ("sk_receive_queue", "唤醒等待者", "cyan"),
    ]
    x = 40
    for i, (t, s, tone) in enumerate(stages):
        b.append(box(x, 92, 92, 76, t, s, tone, mono=True))
        if i < len(stages) - 1:
            b.append(arrow(x + 92, 130, x + 104, 130, tone="muted"))
        x += 104
    b.append(box(40, 224, 300, 62, "上半部：只做最少的事", "关中断 / 记录 / 触发软中断", "red", mono=True))
    b.append(box(370, 224, 300, 62, "下半部：NAPI 轮询 + 协议栈", "可被抢占 / 有预算", "gold", mono=True))
    b.append(box(700, 224, 160, 62, "socket 等待队列", "epoll / 阻塞唤醒", "cyan", mono=True))
    b.append(arrow(190, 168, 190, 220, "", tone="red"))
    b.append(arrow(520, 168, 520, 220, "", tone="gold"))
    b.append(arrow(780, 168, 780, 220, "", tone="cyan"))
    b.append(text(450, 330, "关键点：硬中断不处理协议；NAPI 轮询有 budget；软中断可能被 ksoftirqd 接管；socket 收队列满会丢包", 10.5, "muted", "middle"))
    b.append(text(450, 360, "观测：/proc/softirqs、/proc/net/softnet_stat、ss -tin、bpftrace tracepoint:net:*", 10, "muted", "middle", mono=True))
    return plate("rx-path", "Linux 收包路径与中断/软中断分工",
                 "网卡 DMA → 硬中断 → NAPI 软中断轮询 → 协议栈 → socket 队列。",
                 "从左到右是时间顺序，也是 CPU 上下文切换的顺序。硬中断只做「登记 + 触发软中断」，真正解析报文在 NAPI poll 里；poll 有 budget，超预算就让出 CPU 给 <code>ksoftirqd</code>。排查收包问题要同时看 <code>/proc/softirqs</code> 的 NET_RX、<code>softnet_stat</code> 的 drop，以及 socket 的 <code>Recv-Q</code>。",
                 "".join(b), h=390)


def fig_boot():
    b = []
    b.append(text(450, 42, "从按下电源到登录提示符", 13, "ink", "middle", bold=True))
    stages = [
        ("UEFI/BIOS", "POST → 找 ESP", "muted"),
        ("bootloader", "GRUB / systemd-boot", "muted"),
        ("kernel", "解压 / 初始化 / initcall", "accent"),
        ("initramfs", "加载驱动 / 挂根", "cyan"),
        ("init", "systemd PID 1", "gold"),
        ("target", "multi-user / graphical", "gold"),
        ("login", "getty / sshd", "green"),
    ]
    x = 36
    for i, (t, s, tone) in enumerate(stages):
        b.append(box(x, 92, 112, 72, t, s, tone, mono=True))
        if i < len(stages) - 1:
            b.append(arrow(x + 112, 128, x + 120, 128, tone="muted"))
        x += 120
    b.append(box(36, 222, 390, 70, "内核阶段的关键节点", "start_kernel → rest_init → kernel_init → run_init_process", "accent", mono=True))
    b.append(box(456, 222, 408, 70, "用户态阶段的关键节点", "systemd → 并行启动 unit → 达到 default.target", "gold", mono=True))
    b.append(text(450, 336, "观测：dmesg -T（内核）、journalctl -b（systemd）、systemd-analyze blame / critical-chain", 10.5, "muted", "middle"))
    b.append(text(450, 366, "故障：initramfs 缺驱动 → 卡在「Waiting for root device」；unit 依赖环 → 启动超时", 10.5, "muted", "middle"))
    return plate("boot", "Linux 启动流程：固件、引导、内核、initramfs、systemd",
                 "七个阶段与两个关键分界：内核交棒给用户态、systemd 达到 target。",
                 "从左到右读。前两段是固件与引导器，第三段内核初始化，第四段 initramfs 负责「挂上真正的根」，第五段起是用户态。排启动问题先确定卡在哪一段：<code>dmesg</code> 有输出说明已进内核；<code>journalctl -b</code> 有记录说明 systemd 已接管。",
                 "".join(b), h=390)


def fig_cache():
    b = []
    b.append(text(450, 42, "存储层次：容量、延迟与局部性", 13, "ink", "middle", bold=True))
    levels = [
        ("寄存器", "< 1 ns", "~KB", "accent"),
        ("L1 cache", "~1 ns", "32–64 KB", "cyan"),
        ("L2 cache", "~4 ns", "256 KB–1 MB", "cyan"),
        ("L3 cache", "~10–20 ns", "8–64 MB", "gold"),
        ("DRAM", "~80–100 ns", "GB–TB", "gold"),
        ("NVMe SSD", "~20–100 µs", "TB", "plum"),
        ("HDD / 网络", "~ms", "TB / 无限", "muted"),
    ]
    y = 80
    for i, (name, lat, cap, tone) in enumerate(levels):
        w = 520 - i * 42
        x = 60 + (520 - w) / 2
        b.append(f'<rect x="{x}" y="{y}" width="{w}" height="34" rx="3" fill="{TONES[tone]}" fill-opacity=".06" stroke="{TONES[tone]}" stroke-opacity=".45"/>')
        b.append(text(x + 12, y + 22, name, 11, "ink", mono=True, bold=True))
        b.append(text(x + w - 150, y + 22, lat, 10, "muted", "start", mono=True))
        b.append(text(x + w - 12, y + 22, cap, 10, "muted", "end", mono=True))
        y += 40
    b.append(text(700, 120, "越靠上：越快、越小、越贵", 10.5, "muted", "middle"))
    b.append(text(700, 150, "越靠下：越慢、越大、越便宜", 10.5, "muted", "middle"))
    b.append(text(700, 200, "局部性", 12, "accent", "middle", bold=True))
    b.append(text(700, 224, "时间：刚访问的还会访问", 10, "muted", "middle"))
    b.append(text(700, 246, "空间：相邻地址会被一起取", 10, "muted", "middle"))
    b.append(text(700, 286, "缓存行通常 64 B", 10, "muted", "middle", mono=True))
    b.append(text(700, 310, "miss 惩罚 >> 命中延迟", 10, "muted", "middle"))
    b.append(text(450, 386, "工程含义：顺序访问 > 随机访问；结构体拆分（SoA）> 大结构体数组；循环分块提高复用", 10.5, "muted", "middle"))
    return plate("cache", "存储层次与局部性",
                 "从寄存器到磁盘/网络，容量增大、延迟上升；缓存利用时间与空间局部性。",
                 "左侧金字塔越往下越慢。注意数量级：L1 约 1 ns，DRAM 约 100 ns，NVMe 约几十 µs，网络约 ms——每下一层就是 10–1000 倍。右侧两条局部性是所有性能优化的基础：让下一次访问落在更上一层。",
                 "".join(b), h=420)


def fig_ns_cgroup():
    b = []
    b.append(text(450, 42, "容器 = namespace（看见什么）+ cgroups（能用多少）+ 镜像（根文件系统）", 12.5, "ink", "middle", bold=True))
    b.append(lane(28, 70, 400, 286, "HOST"))
    b.append(lane(452, 70, 420, 286, "CONTAINER  ·  PID 1"))
    b.append(box(48, 98, 160, 58, "PID namespace", "容器内 PID 从 1 开始", "cyan", mono=True))
    b.append(box(228, 98, 180, 58, "mount namespace", "独立挂载树 / rootfs", "accent", mono=True))
    b.append(box(48, 174, 160, 58, "network namespace", "独立网卡 / 路由 / 端口", "gold", mono=True))
    b.append(box(228, 174, 180, 58, "UTS / IPC / user", "主机名 / IPC / uid 映射", "plum", mono=True))
    b.append(box(48, 250, 360, 58, "cgroups v2", "cpu.max / memory.max / pids.max / io.max", "green", mono=True))
    b.append(box(472, 98, 380, 58, "进程视图", "ps 只看到自己 + 少量内核线程", "cyan", mono=True))
    b.append(box(472, 174, 380, 58, "文件系统视图", "overlayfs：lowerdir + upperdir + merged", "accent", mono=True))
    b.append(box(472, 250, 380, 58, "资源视图", "CPU 配额 / 内存上限 / PID 上限 / IO 权重", "green", mono=True))
    b.append(arrow(410, 127, 468, 127, "隔离", tone="cyan"))
    b.append(arrow(410, 203, 468, 203, "挂载", tone="accent"))
    b.append(arrow(410, 279, 468, 279, "限额", tone="green"))
    b.append(text(450, 388, "容器不是轻量虚拟机：没有独立内核，隔离靠内核提供的命名空间与资源控制器；共享内核也意味着共享漏洞面", 10.5, "muted", "middle"))
    return plate("ns-cgroup", "容器的三层隔离：namespace、cgroups、镜像",
                 "namespace 决定「看得见什么」，cgroups 决定「用得了多少」，镜像决定「根文件系统长什么样」。",
                 "左列是内核机制，右列是容器内看到的效果。三者缺一不可：只有 namespace 没有 cgroups，一个容器可以吃光宿主；只有 cgroups 没有 namespace，进程仍能看见彼此。最下方的「共享内核」是容器与虚拟机的根本区别。",
                 "".join(b), h=410)


CATALOG = {
    "fd-table": fig_fd_table,
    "io-path": fig_io_path,
    "proc-states": fig_proc_states,
    "va-translate": fig_va_translate,
    "tcp-handshake": fig_tcp_handshake,
    "epoll": fig_epoll,
    "rx-path": fig_rx_path,
    "boot": fig_boot,
    "cache": fig_cache,
    "ns-cgroup": fig_ns_cgroup,
}


def main():
    os.makedirs(OUT, exist_ok=True)
    names = sys.argv[1:] or list(CATALOG)
    for name in names:
        if name not in CATALOG:
            print("unknown figure:", name, file=sys.stderr)
            continue
        md = CATALOG[name]()
        path = os.path.join(OUT, name + ".md")
        with open(path, "w") as f:
            f.write(md)
        print("wrote", path, len(md), "bytes")


if __name__ == "__main__":
    main()
