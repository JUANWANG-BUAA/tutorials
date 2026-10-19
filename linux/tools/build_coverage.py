#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成 A.4 母本覆盖矩阵，并校验每个母本章节都有落点。

数据源：.work/source-toc/clean-*.md（由 pypdf 书签重导，标题已合并换行）。
映射是**计划**：正文完成后若实际章节号变化，改 MAP 再重跑。
"""

from __future__ import annotations

import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
TOC = os.path.join(ROOT, "写作规范", "source-toc")
if not os.path.isdir(TOC):
    TOC = os.path.normpath(os.path.join(ROOT, "..", ".work", "source-toc"))
OUT = os.path.join(ROOT, "src", "appendix", "coverage.md")

CN_NUM = {"零": 0, "一": 1, "二": 2, "三": 3, "四": 4, "五": 5,
          "六": 6, "七": 7, "八": 8, "九": 9, "十": 10}


def cn_to_int(s: str) -> int:
    if s.isdigit():
        return int(s)
    if s == "十":
        return 10
    if "十" in s:
        a, b = s.split("十", 1)
        return (CN_NUM.get(a, 1) if a else 1) * 10 + (CN_NUM.get(b, 0) if b else 0)
    return CN_NUM.get(s, -1)


def parse_numbered(path: str, prefix: str = "第") -> dict[int, str]:
    """从 clean-*.md 解析 '第N章 标题 [pX]'。容忍 '第4 章'、'第52 OSIX'。"""
    out: dict[int, str] = {}
    if not os.path.exists(path):
        return out
    for line in open(path, encoding="utf-8"):
        m = re.search(rf"{prefix}\s*(\d+)\s*章?\s*(.*?)\s*\[p\d+\]", line)
        if not m:
            continue
        n = int(m.group(1))
        title = m.group(2).strip()
        title = re.sub(r"\s+", " ", title)
        if n not in out or len(title) > len(out[n]):
            out[n] = title
    return out


def parse_cn(path: str) -> dict[int, str]:
    """鸟哥：中文数字章号。"""
    out: dict[int, str] = {}
    if not os.path.exists(path):
        return out
    for line in open(path, encoding="utf-8"):
        m = re.search(r"第([零一二三四五六七八九十]+)章[、 ]\s*(.*)", line)
        if m:
            n = cn_to_int(m.group(1))
            if n >= 0:
                out[n] = m.group(2).strip()
    return out


# --------------------------------------------------------------------------- #
# 章节标题
# --------------------------------------------------------------------------- #
KERRISK = parse_numbered(os.path.join(TOC, "clean-kerrisk.md"))
KERRISK[52] = "POSIX 消息队列"
CSAPP = parse_numbered(os.path.join(TOC, "clean-csapp.md"))
CSAPP[1] = "计算机系统漫游"
RUNNING = parse_numbered(os.path.join(TOC, "clean-running-linux.md"))
NETWORK = parse_numbered(os.path.join(TOC, "clean-network.md"))
NETWORK[1] = "绪论"
NIAOGE = parse_cn(os.path.join(TOC, "clean-niaoge.md"))
SHOTTS = parse_numbered(os.path.join(TOC, "clean-shotts.md"))
SHELLBOOK = parse_numbered(os.path.join(TOC, "clean-shell-book.md"))
CN8 = parse_numbered(os.path.join(TOC, "cn8.md"))

OSTEP_TITLES = [
    "关于本书的对话", "操作系统介绍", "关于虚拟化的对话", "抽象：进程",
    "插叙：进程 API", "机制：受限直接执行", "进程调度：介绍", "调度：多级反馈队列",
    "调度：比例份额", "多处理器调度（高级）", "关于 CPU 虚拟化的总结对话",
    "关于内存虚拟化的对话", "抽象：地址空间", "插叙：内存操作 API", "机制：地址转换",
    "分段", "空闲空间管理", "分页：介绍", "分页：快速地址转换（TLB）",
    "分页：较小的表", "超越物理内存：机制", "超越物理内存：策略", "VAX/VMS 虚拟内存系统",
    "内存虚拟化总结对话", "关于并发的对话", "并发：介绍", "插叙：线程 API", "锁",
    "基于锁的并发数据结构", "条件变量", "信号量", "常见并发问题", "基于事件的并发（进阶）",
    "并发的总结对话", "关于持久性的对话", "I/O 设备", "磁盘驱动器",
    "廉价冗余磁盘阵列（RAID）", "插叙：文件和目录", "文件系统实现", "局部性和快速文件系统",
    "崩溃一致性：FSCK 和日志", "日志结构文件系统", "数据完整性和保护", "关于持久的总结对话",
    "关于分布式的对话", "分布式系统", "Sun 的网络文件系统（NFS）", "Andrew 文件系统（AFS）",
    "关于分布式的总结对话",
]
OSTEP = {i + 1: t for i, t in enumerate(OSTEP_TITLES)}

HARBIN_TITLES = [
    "系统启动——打开电源以后发生的故事", "系统接口——通向操作系统内核的大门",
    "多进程——操作系统最核心的视图", "线程切换与调度——操作系统的发动机",
    "进程同步——让多个进程的推进合理有序", "内存管理——给程序执行提供一个舞台",
    "换入/换出——用磁盘和时间换取一个规整虚拟内存", "设备驱动——从文件视图到 out 指令",
]
HARBIN = {i + 1: t for i, t in enumerate(HARBIN_TITLES)}
for i in range(1, 9):
    HARBIN[f"P{i}"] = f"实践项目{i}"

# --------------------------------------------------------------------------- #
# 映射： (起始, 结束, 落点, 程度, 备注)
# 章号可以是 int，也可以是 'P1' 这种项目编号。
# --------------------------------------------------------------------------- #
MAP: dict[str, list[tuple]] = {
    "K": [
        (1, 2, "0.1 / 2.1", "背景", "内核/用户态边界、系统调用约定"),
        (3, 3, "2.1", "完整", "系统调用、错误、可移植性"),
        (4, 4, "2.2", "完整", "通用 I/O 模型"),
        (5, 5, "2.3", "完整", "原子性、fcntl、mmap、文件锁"),
        (6, 6, "2.7", "完整", "进程与 fork"),
        (7, 7, "1.9.6 / 1.9.10 / 1.9.11", "完整", "用户态分配器；3.9 只作内核侧对照"),
        (8, 9, "2.9", "完整", "用户/组/进程凭证"),
        (10, 10, "2.11", "完整", "时间与定时器"),
        (11, 12, "2.1", "完整", "限制、sysconf、/proc"),
        (13, 13, "2.4", "完整", "stdio 缓冲"),
        (14, 14, "3.12", "精选", "文件系统与 VFS"),
        (15, 17, "2.5", "完整", "属性、xattr、ACL"),
        (18, 19, "2.6", "完整", "目录、链接、inotify"),
        (20, 22, "2.10", "完整", "信号三章"),
        (23, 23, "2.11", "完整", "定时器与休眠"),
        (24, 26, "2.7", "完整", "创建/终止/监控子进程"),
        (27, 28, "2.8", "完整", "exec、system、进程记账"),
        (29, 29, "2.12", "完整", "线程介绍"),
        (30, 30, "2.13", "完整", "线程同步"),
        (31, 33, "2.12 / 2.13", "完整", "线程安全、TLS、取消"),
        (34, 34, "2.19", "完整", "进程组、会话、作业控制"),
        (35, 35, "3.5", "精选", "优先级与调度"),
        (36, 36, "2.1 / 3.15", "精选", "进程资源限制"),
        (37, 37, "2.19", "完整", "守护进程"),
        (38, 38, "2.9 / 5.1", "精选", "安全特权程序"),
        (39, 39, "2.9", "完整", "capability"),
        (40, 40, "0.12.4.1", "精选", "utmp/wtmp/lastlog、last/who、journald"),
        (41, 42, "0.11 / 1.7", "完整", "共享库基础与高级特性"),
        (43, 43, "2.14", "背景", "IPC 总览"),
        (44, 44, "2.14", "完整", "管道与 FIFO"),
        (45, 48, "A.1 / 2.14", "背景", "SysV IPC，主线用 POSIX"),
        (49, 50, "2.3 / 1.9", "完整", "mmap 与虚拟内存操作"),
        (51, 51, "2.14", "背景", "POSIX IPC 总览"),
        (52, 52, "2.14", "完整", "POSIX 消息队列"),
        (53, 53, "2.15", "完整", "POSIX 信号量"),
        (54, 54, "2.15", "完整", "POSIX 共享内存"),
        (55, 55, "2.3", "完整", "文件锁"),
        (56, 56, "2.16", "完整", "socket 基础"),
        (57, 58, "2.16", "完整", "UNIX domain / TCP-IP 基础"),
        (59, 61, "2.17", "完整", "Internet domain、服务器设计、高级主题"),
        (62, 62, "2.19", "完整", "终端"),
        (63, 63, "2.18", "完整", "select/poll/epoll"),
        (64, 64, "2.19", "完整", "伪终端"),
    ],
    "C": [(i, i, f"1.{i}", "完整", "") for i in range(1, 13)],
    "O": [
        (1, 2, "1.13", "背景", "OS 导论"),
        (3, 6, "1.13 / 3.4", "完整", "进程与受限直接执行"),
        (7, 10, "1.13 / 3.5", "完整", "调度"),
        (11, 12, "1.13", "背景", "总结对话"),
        (13, 24, "1.9 / 1.13 / 3.8", "完整", "地址空间、分页、TLB、交换"),
        (25, 34, "1.12 / 2.13 / 3.11", "完整", "并发、锁、条件变量、信号量"),
        (35, 45, "3.12 / 3.13 / 1.13", "完整", "I/O、磁盘、RAID、文件系统、日志"),
        (46, 46, "3.12.8", "背景", "NFS/AFS 的引子"),
        (47, 47, "3.12.8.1", "精选", "RPC/XDR、故障语义与远程文件系统假设"),
        (48, 48, "3.12.8.1", "完整", "NFSv3/v4、缓存一致性、ESTALE、挂载选项"),
        (49, 49, "3.12.8.2", "精选", "AFS 整文件缓存与回调"),
        (50, 50, "3.12.8.3", "背景", "三条边界收束"),
    ],
    "L": [
        (1, 1, "3.2", "完整", "启动"),
        (2, 2, "3.3", "完整", "系统调用接口"),
        (3, 3, "3.4", "完整", "多进程"),
        (4, 4, "3.5 / 2.12", "完整", "线程与调度"),
        (5, 5, "3.11 / 2.13", "完整", "进程同步"),
        (6, 6, "3.7 / 3.8", "完整", "内存管理"),
        (7, 7, "3.10", "完整", "换入/换出"),
        (8, 8, "3.14", "完整", "设备驱动"),
        ("P1", "P8", "3.x / 项目 A1", "背景", "8 个实践项目作为实现侧写"),
    ],
    "R": [
        (1, 1, "1.4 / 3.1", "完整", "处理器体系结构（ARM）"),
        (2, 2, "3.7–3.10", "完整", "内存管理"),
        (3, 3, "3.4–3.6", "完整", "进程管理与调度"),
        (4, 4, "3.11", "完整", "并发与同步"),
        (5, 5, "3.3 / 4.8", "完整", "中断管理"),
        (6, 6, "3.15", "完整", "内核调试"),
    ],
    "N": [
        (1, 1, "4.1", "背景", "网络栈总览"),
        (2, 2, "4.8", "完整", "收包路径"),
        (3, 3, "4.10", "完整", "socket 与 epoll 协作"),
        (4, 4, "4.9", "完整", "发包路径"),
        (5, 5, "4.11", "完整", "本机网络"),
        (6, 6, "4.5", "完整", "TCP 连接建立"),
        (7, 7, "4.11", "完整", "TCP 内存开销"),
        (8, 8, "4.11", "完整", "百万连接"),
        (9, 9, "4.12", "完整", "网络性能优化"),
        (10, 10, "5.6 / 4.12", "完整", "容器网络虚拟化"),
    ],
    "G": [
        (0, 1, "0.1", "背景", "计算机概论、Linux 是什么"),
        (2, 2, "0.10", "完整", "主机规划与磁盘分区"),
        (3, 3, "A.1", "淘汰", "CentOS 7 安装，只讲分区/引导原理"),
        (4, 4, "0.2", "完整", "首次登陆与求助"),
        (5, 5, "0.4", "完整", "文件权限与目录配置"),
        (6, 6, "0.3", "完整", "文件与目录管理"),
        (7, 7, "0.10", "完整", "磁盘与文件系统管理"),
        (8, 8, "0.3 / 0.10", "精选", "压缩、打包与备份"),
        (9, 9, "0.2", "精选", "vim"),
        (10, 10, "0.7", "完整", "BASH"),
        (11, 11, "0.6", "完整", "正则与格式化"),
        (12, 12, "0.7 / 0.8", "完整", "Shell Scripts"),
        (13, 13, "0.4 / 2.9", "完整", "账号管理与 ACL"),
        (14, 14, "0.10.8.1", "完整", "quota/xfs_quota、软硬限、project quota"),
        (15, 15, "0.12", "完整", "例行性工作调度"),
        (16, 16, "0.9", "完整", "程序管理与 SELinux"),
        (17, 17, "0.12", "完整", "系统服务"),
        (18, 18, "0.12 / 3.15", "完整", "登录文件"),
        (19, 19, "0.12 / 3.2", "完整", "开机流程、模块、Loader"),
        (20, 20, "0.10 / 0.12", "精选", "基础设置与备份"),
        (21, 21, "0.11", "完整", "源码与 Tarball"),
        (22, 22, "0.11", "完整", "RPM/SRPM/YUM"),
        (23, 23, "A.1", "淘汰", "X Window 设置，不属本书范围"),
        (24, 24, "0.11 / 3.1", "精选", "核心编译与管理"),
    ],
    "S": [
        (1, 10, "0.1–0.9", "完整", "Shell 基础与文件/进程"),
        (11, 13, "0.2 / 0.8 / 0.14", "精选", "环境、vi、提示符"),
        (14, 18, "0.11 / 0.10 / 0.13 / 0.3", "完整", "包管理、存储、联网、查找、归档"),
        (19, 21, "0.6", "完整", "正则、文本处理"),
        (22, 22, "A.1", "淘汰", "打印，已不在本书范围"),
        (23, 23, "0.11", "完整", "编译程序"),
        (24, 36, "0.7 / 0.8", "完整", "Shell 脚本"),
    ],
    "B": [
        (1, 2, "0.1 / 0.2", "背景", "Linux 与 shell 入门"),
        (3, 4, "0.3", "完整", "基础命令与更多命令"),
        (5, 5, "0.5", "完整", "理解 shell、管道与重定向"),
        (6, 6, "0.7", "完整", "环境变量"),
        (7, 7, "0.4", "完整", "文件权限"),
        (8, 8, "0.10", "完整", "文件系统"),
        (9, 9, "0.11", "完整", "安装软件"),
        (10, 10, "0.2", "精选", "文本编辑器"),
        (11, 17, "0.7 / 0.8 / 0.9", "完整", "脚本基础、结构化命令、函数"),
        (18, 18, "A.1", "淘汰", "图形化桌面脚本，不属本书范围"),
        (19, 22, "0.6", "完整", "sed、gawk、正则"),
        (23, 23, "0.7", "背景", "其他 shell"),
        (24, 25, "0.8", "完整", "实用脚本与工程化"),
    ],
    "W": [
        (1, 1, "4.1", "完整", "概述与分层"),
        (2, 3, "4.2", "完整", "物理层、数据链路层"),
        (4, 4, "4.3", "完整", "网络层"),
        (5, 5, "4.4–4.6", "完整", "运输层与 TCP"),
        (6, 6, "4.7", "完整", "应用层"),
        (7, 7, "4.12 / 5.6", "精选", "网络安全"),
        (8, 8, "4.7", "背景", "音频/视频服务，只作应用层背景"),
        (9, 9, "4.2", "背景", "无线网络，只作链路层背景"),
    ],
}

BOOK_META = {
    "K": ("K", "《Linux/UNIX 系统编程手册》Kerrisk", KERRISK, 1, 64),
    "C": ("C", "《深入理解计算机系统》CSAPP 3e", CSAPP, 1, 12),
    "O": ("O", "《操作系统导论》OSTEP", OSTEP, 1, 50),
    "L": ("L", "《操作系统原理、实现与实践》李治军", HARBIN, 1, 8),
    "R": ("R", "《奔跑吧 Linux 内核》", RUNNING, 1, 6),
    "N": ("N", "《深入理解 Linux 网络》", NETWORK, 1, 10),
    "G": ("G", "《鸟哥的 Linux 私房菜·基础学习篇》4e", NIAOGE, 0, 24),
    "S": ("S", "《Linux 命令行大全》Shotts 2e", SHOTTS, 1, 36),
    "B": ("B", "《Linux 命令行与 shell 脚本编程大全》4e", SHELLBOOK, 1, 25),
    "W": ("W", "《计算机网络》谢希仁 8e", CN8, 1, 9),
}


def expand(entry):
    a, b, landing, degree, note = entry
    if isinstance(a, str):  # P1..P8
        if a.startswith("P") and b.startswith("P"):
            return [f"P{i}" for i in range(int(a[1:]), int(b[1:]) + 1)]
        return [a]
    return list(range(a, b + 1))


def validate():
    errors = []
    for key, (_, name, titles, lo, hi) in BOOK_META.items():
        keys = set()
        for entry in MAP[key]:
            keys.update(expand(entry))
        expected = {i for i in range(lo, hi + 1)}
        if key == "L":
            expected |= {f"P{i}" for i in range(1, 9)}
        missing = expected - keys
        extra = keys - expected
        if missing:
            errors.append(f"{name}: 未映射章 {sorted(missing)}")
        if extra:
            errors.append(f"{name}: 多出章 {sorted(extra)}")
        for n in expected:
            if n not in titles:
                errors.append(f"{name}: 缺标题 {n}")
    return errors


def render():
    lines = [
        "# A.4 母本覆盖矩阵",
        "",
        "## 1. 怎么读这张表",
        "",
        "本表把十本母本的**每一个章节**映射到本书的落点。它是「不遗漏」的验收依据，不是装饰：",
        "",
        "- **完整**：该章的概念、关键 API/路径、边界与例子都在正文出现；",
        "- **精选**：核心概念与常用接口在正文，冷门细节指路；",
        "- **背景**：只保留理解主线所需的最小集；",
        "- **淘汰**：该章内容已过时或超出范围，只在 [A.1](legacy.md) 保留迁移说明。",
        "",
        "若你发现某一章在正文找不到对应内容，请按「母本」列回查；也欢迎提 issue。",
        "",
        "> 映射按**计划**生成；正文完成后由 `tools/build_coverage.py` 复核。章号以母本目录为准，页码随版本漂移，故不列页码。",
        "",
    ]
    for key, (code, name, titles, lo, hi) in BOOK_META.items():
        lines.append(f"## {code} · {name}")
        lines.append("")
        lines.append("| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |")
        lines.append("|:--|:--|:--|:--|:--|")
        for entry in MAP[key]:
            a, b, landing, degree, note = entry
            nums = expand(entry)
            label = f"第 {a} 章" if a == b else f"第 {a}–{b} 章"
            if isinstance(a, str):
                label = f"{a}–{b}"
            title = titles.get(a, "")
            if a != b and not isinstance(a, str):
                title = f"{titles.get(a, '')} … {titles.get(b, '')}"
            lines.append(f"| {label} | {title} | {landing} | {degree} | {note} |")
        lines.append("")
    lines.append("## 覆盖统计")
    lines.append("")
    total = sum(hi - lo + 1 for _, _, _, lo, hi in BOOK_META.values())
    lines.append(f"十本母本合计 **{total}** 个正文章节（李治军另计 8 个实践项目，以 1.13.6 的实现侧写覆盖，未计入章节数）。本表逐章给出落点；缺口为 0 表示每一章都有可指认的正文落点。")
    lines.append("")
    lines.append("| 母本 | 章节数 | 完整 | 精选 | 背景 | 淘汰 | 缺口 |")
    lines.append("|:--|--:|--:|--:|--:|--:|--:|")
    for key, (code, name, titles, lo, hi) in BOOK_META.items():
        counts = {"完整": 0, "精选": 0, "背景": 0, "淘汰": 0}
        for entry in MAP[key]:
            a, b, landing, degree, note = entry
            n = 0 if isinstance(a, str) else (b - a + 1)
            counts[degree] = counts.get(degree, 0) + n
        lines.append(f"| {code} | {sum(counts.values())} | {counts['完整']} | {counts['精选']} | {counts['背景']} | {counts['淘汰']} | 0 |")
    totals = {"完整": 0, "精选": 0, "背景": 0, "淘汰": 0}
    for key in MAP:
        for entry in MAP[key]:
            a, b, landing, degree, note = entry
            n = 0 if isinstance(a, str) else (b - a + 1)
            totals[degree] += n
    lines.append(f"| **合计** | **{total}** | **{totals['完整']}** | **{totals['精选']}** | **{totals['背景']}** | **{totals['淘汰']}** | **0** |")
    lines.append("")
    lines.append(f"逐章统计：完整 {totals['完整']}、精选 {totals['精选']}、背景 {totals['背景']}、淘汰 {totals['淘汰']}、缺口 0。")
    lines.append("## 缺口补记")
    lines.append("")
    lines.append("初版逐章核对时有 3 处零落点（7 章），已在正文补齐：")
    lines.append("")
    lines.append("| 母本 | 章 | 补到 | 补了什么 |")
    lines.append("|:--|:--|:--|:--|")
    lines.append("| O | 第 46–50 章 分布式系统 | 3.12.8 | NFSv3/v4、AFS 整文件缓存、VFS 的远程边界 |")
    lines.append("| K | 第 40 章 登录记账 | 0.12.4.1 | `utmp/wtmp/btmp/lastlog`、`last/who`、`getutxent`、journald 边界 |")
    lines.append("| G | 第 14 章 磁盘配额 | 0.10.8.1 | `quotaon/edquota/setquota/repquota`、XFS `xfs_quota`、project quota |")
    lines.append("")
    lines.append("> 仍有几处「有落点但偏薄」：G 第 8 章 / S 第 18 章（压缩归档只在 0.8.6 用 tar）、K 第 50 章（`mlock/mincore` 只在 3.8/3.10 提及）、S 第 28 章 / B 第 14 章（`read` 的交互选项未展开）、CSAPP 第 9.10 节（GC 从略）。这些不构成「无落点」。")
    lines.append("")
    lines.append("## 附录与前置材料")
    lines.append("")
    lines.append("| 母本 | 附录/前置 | 本书落点 | 程度 | 说明 |")
    lines.append("|:--|:--|:--|:--|:--|")
    lines.append("| K | 附录 A 跟踪系统调用 | 2.1、3.15 | 完整 | `strace`/`ptrace` 与观测工具 |")
    lines.append("| K | 附录 B 解析命令行选项 | 0.8、2.1 | 完整 | `getopt/getopts/getopt_long` |")
    lines.append("| K | 附录 C 对 NULL 指针做转型 | A.1 | 背景 | 历史可移植性写法，现代 C 不需要 |")
    lines.append("| K | 附录 D 内核配置 | 3.1 | 完整 | `Kconfig`/`menuconfig`/`defconfig` |")
    lines.append("| K | 附录 E 更多信息源 | A.5 | 完整 | 规范、man-pages、源码 |")
    lines.append("| K | 附录 F 部分习题解答 | — | 不适用 | 本书自配习题与折叠解答 |")
    lines.append("| C | 附录 A 错误处理 | 2.1 | 完整 | `errno`/`errExit`/`strerror` |")
    lines.append("| O | 附录 A–C 虚拟机监视器 | 5.1 | 背景 | 容器与 VM 的边界；VMM 不展开 |")
    lines.append("| W | 附录 A–C 习题/缩写/参考 | A.5 | 背景 | 教辅与文献，不属正文知识 |")
    lines.append("")
    lines.append("> 附录只保留与正文知识相关的部分；纯习题答案、缩写表、参考文献不重复收录。")
    lines.append("")
    return "\n".join(lines)


def main():
    errors = validate()
    if errors:
        print("映射校验失败：", file=sys.stderr)
        for e in errors:
            print("  -", e, file=sys.stderr)
        return 1
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8").write(render())
    print("wrote", OUT)
    return 0


if __name__ == "__main__":
    sys.exit(main())
