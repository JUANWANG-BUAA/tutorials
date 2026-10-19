#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成《Agent 系统工程》的母本覆盖矩阵，并校验「每一章都有落点」。

数据源：写作规范/source-toc/*.md（每行 `- <n> <标题>`）。
映射是**计划**：正文完成后若章号变化，改 MAP 再重跑。

用法：
    python3 tools/build_coverage.py
输出：
    src/appendix/coverage.md（正文页）
    coverage.md（仓库内副本，便于评审）
校验：
    - 每个编号 1..N 恰好被映射一次；
    - 每个编号都有标题；
    - 落点章号在 1..14 内且该章在 SUMMARY 中存在；
    - 缺口非零时退出码 1，不写文件。
"""

from __future__ import annotations

import os
import re
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
TOC = os.path.join(ROOT, "写作规范", "source-toc")
OUT = os.path.join(ROOT, "src", "appendix", "coverage.md")
COPY = os.path.join(ROOT, "coverage.md")

# code: (文件, 名称, 版本/说明, 映射)
# 每条映射：(起, 止, 落点, 程度, 备注)
# 程度：完整 / 精选 / 背景 / 交叉引用 / 淘汰
SOURCES = [
    ("L2", "linux-part2.md",
     "《Linux 系统与内核》第 2 篇 · Unix/Linux 系统编程", "本仓库 linux/，19 章",
     "只交叉引用，不重写系统编程基础",
     [
         (1, 1, "3.1", "交叉引用", "系统调用、errno、可移植性只作边界说明"),
         (2, 4, "3.3", "交叉引用", "文件 I/O、原子性、mmap 用于沙箱文件策略"),
         (5, 6, "4.1", "交叉引用", "凭证、ACL 与权限模型"),
         (7, 8, "3.2", "交叉引用", "fork/exec/wait 与退出状态，见附录 B 的 0x2a00"),
         (9, 9, "4.2", "交叉引用", "capability 五集合"),
         (10, 11, "3.2", "交叉引用", "信号、定时器与超时"),
         (12, 13, "8.4", "背景", "线程同步作为多 agent 冲突的类比"),
         (14, 15, "8.3", "背景", "消息队列/信号量作为通信原语，含 variadic 原型勘误"),
         (16, 18, "3.4", "交叉引用", "socket 与 epoll 用于网络边界"),
         (19, 19, "13.6", "精选", "作业控制用于沙箱进程组与会话"),
     ]),
    ("L3", "linux-part3.md",
     "《Linux 系统与内核》第 3 篇 · Linux 内核", "本仓库 linux/，15 章",
     "只取隔离与观测相关的机制落点",
     [
         (1, 2, "3.2", "背景", "内核架构与启动，只说明边界"),
         (3, 3, "4.3", "交叉引用", "系统调用入口是 seccomp 的拦截点"),
         (4, 5, "3.2", "背景", "调度与进程组"),
         (6, 7, "3.5", "背景", "内存与换页"),
         (8, 8, "3.3", "背景", "设备与文件"),
         (9, 10, "3.3", "交叉引用", "VFS、挂载与 rootfs"),
         (11, 11, "8.4", "背景", "内核同步原语"),
         (12, 13, "3.5", "背景", "内存/文件系统进阶"),
         (14, 14, "3.3", "背景", "设备驱动"),
         (15, 15, "10.7", "交叉引用", "ftrace/perf 用于回放与定位"),
     ]),
    ("L5", "linux-part5.md",
     "《Linux 系统与内核》第 5 篇 · 云原生", "本仓库 linux/，6 章",
     "容器运行时只作为沙箱的实现参照",
     [
         (1, 2, "3.6", "交叉引用", "OCI 运行时与 namespace"),
         (3, 3, "3.5", "交叉引用", "cgroup v2"),
         (4, 4, "3.4", "交叉引用", "容器网络与 egress"),
         (5, 5, "3.3", "交叉引用", "容器存储与 overlay"),
         (6, 6, "12.3", "背景", "编排层的最小权限"),
     ]),
    ("DL", "deeplearning.md",
     "《深度学习导论》", "本仓库 deeplearning/，9 讲",
     "模型基础只引用，不重写",
     [
         (1, 1, "5.2", "背景", "token 与注意力成本"),
         (2, 2, "5.2", "背景", "上下文窗口与位置偏差"),
         (3, 4, "1.1", "背景", "模型能力边界，不重写网络结构"),
         (5, 5, "7.4", "背景", "MCTS 来自强化学习"),
         (6, 7, "11.1", "背景", "AI 风险框架"),
         (8, 8, "9.1", "背景", "领域评测"),
         (9, 9, "9.6", "背景", "训练/推理成本"),
     ]),
    ("MCP", "mcp-2026-07-28.md",
     "Model Context Protocol Specification", "2026-07-28（对照 2025-11-25）",
     "协议章节逐节落点；旧版生命周期作为迁移对照",
     [
         (1, 1, "2.1", "完整", "host/client/server 三角与 JSON-RPC 2.0"),
         (2, 2, "2.5", "完整", "无状态协议、每请求 _meta"),
         (3, 3, "2.5", "完整", "server/discover 与版本协商"),
         (4, 4, "2.4", "完整", "tools/list、tools/call、inputSchema"),
         (5, 5, "2.7", "完整", "结构化结果与 isError"),
         (6, 6, "2.4", "完整", "resources 与订阅"),
         (7, 7, "2.4", "完整", "prompts 与参数"),
         (8, 8, "2.5", "完整", "MRTR 取代 server-initiated requests"),
         (9, 9, "2.6", "完整", "取消与进度"),
         (10, 10, "2.6", "精选", "subscriptions/listen 长流"),
         (11, 11, "2.6", "完整", "stdio 传输与 stderr 日志"),
         (12, 12, "2.6", "完整", "Streamable HTTP"),
         (13, 13, "2.6", "精选", "Mcp-Method/Mcp-Name 与 Origin"),
         (14, 14, "2.8", "完整", "OAuth 2.1 与 RFC 9728"),
         (15, 15, "2.8", "精选", "OIDC 发现"),
         (16, 16, "2.8", "精选", "CIMD 与 DCR"),
         (17, 17, "2.8", "完整", "token audience 与 RFC 8707"),
         (18, 18, "11.5", "完整", "confused deputy、token passthrough"),
         (19, 19, "11.5", "完整", "状态句柄劫持、SSRF"),
         (20, 20, "11.5", "精选", "本地 server 失陷与 stdio 代理"),
         (21, 21, "5.7", "精选", "ttlMs/cacheScope 与上下文缓存"),
         (22, 22, "2.6", "背景", "分页"),
         (23, 23, "2.5", "精选", "Tasks 扩展"),
         (24, 24, "2.9", "完整", "扩展与能力协商"),
         (25, 25, "2.9", "完整", "Roots/Sampling/Logging 弃用"),
         (26, 26, "2.2", "完整", "JSON Schema 2020-12 默认方言"),
         (27, 27, "2.7", "完整", "错误码分区与 JSON-RPC 映射"),
         (28, 28, "10.3", "精选", "_meta 中的 traceparent"),
         (29, 29, "11.4", "精选", "Registry 与工具供应链"),
         (30, 30, "2.9", "完整", "版本兼容策略"),
     ]),
    ("OAI", "openai-tool-calling.md",
     "OpenAI Function Calling / Tools 文档", "Responses API 与 Chat Completions 对照",
     "厂商协议作为 MCP 的对照面",
     [
         (1, 1, "2.3", "完整", "两种 API 的工具形态差异"),
         (2, 2, "2.2", "完整", "函数 schema 的三段"),
         (3, 3, "2.2", "完整", "strict 的约束与代价"),
         (4, 4, "2.3", "完整", "tool_choice 四态"),
         (5, 5, "2.3", "完整", "parallel_tool_calls"),
         (6, 6, "2.3", "完整", "流式增量与 index"),
         (7, 7, "2.3", "完整", "tool_call_id 与结果回传"),
         (8, 8, "2.7", "完整", "finish_reason 与截断"),
         (9, 9, "2.2", "完整", "json_schema 结构化输出"),
         (10, 10, "2.7", "完整", "校验失败与重试"),
         (11, 11, "9.6", "精选", "工具描述本身占 token"),
     ]),
    ("OCI", "oci-runtime-1.3.md",
     "Open Container Initiative Runtime Spec", "v1.3.0（2025-11）",
     "作为沙箱配置的工业级参照",
     [
         (1, 1, "3.6", "完整", "bundle 布局"),
         (2, 2, "3.6", "完整", "config.json 顶层"),
         (3, 3, "3.2", "完整", "process 与 argv"),
         (4, 4, "4.5", "完整", "uid/gid 映射"),
         (5, 5, "4.2", "完整", "capabilities 五集合"),
         (6, 6, "3.5", "完整", "rlimits"),
         (7, 7, "4.6", "完整", "noNewPrivileges"),
         (8, 8, "4.3", "完整", "seccomp"),
         (9, 9, "3.3", "完整", "mounts 与 rootfs"),
         (10, 10, "4.5", "完整", "namespaces"),
         (11, 11, "12.4", "精选", "hooks 与审批点"),
         (12, 12, "3.6", "完整", "生命周期"),
         (13, 13, "12.2", "精选", "annotations 与审计"),
         (14, 14, "3.5", "完整", "cgroup 资源"),
         (15, 15, "4.6", "精选", "AppArmor/SELinux 与 LSM 次序"),
     ]),
    ("PAPER", "papers.md",
     "Agent / RAG / 评测 / 安全 的关键论文", "按主题选读，不逐篇复述",
     "论文只提供方法与证据，正文重写为工程判断",
     [
         (1, 1, "7.2", "完整", "ReAct"),
         (2, 2, "7.5", "完整", "Reflexion"),
         (3, 3, "7.4", "完整", "Tree of Thoughts"),
         (4, 4, "2.3", "背景", "Toolformer"),
         (5, 5, "6.3", "完整", "RAG"),
         (6, 6, "5.2", "完整", "Lost in the Middle"),
         (7, 7, "6.1", "完整", "MemGPT"),
         (8, 8, "7.5", "精选", "Self-Refine"),
         (9, 9, "1.3", "背景", "CoALA"),
         (10, 10, "2.9", "背景", "ToolLLM"),
         (11, 11, "2.3", "背景", "Gorilla"),
         (12, 12, "9.2", "完整", "τ-bench"),
         (13, 13, "9.2", "完整", "SWE-bench"),
         (14, 14, "9.2", "完整", "AgentBench"),
         (15, 15, "9.2", "精选", "WebArena"),
         (16, 16, "9.2", "精选", "GAIA"),
         (17, 17, "6.7", "背景", "Voyager 的技能积累"),
         (18, 18, "8.2", "完整", "AutoGen"),
         (19, 19, "8.2", "精选", "ChatDev"),
         (20, 20, "8.2", "精选", "CAMEL"),
         (21, 21, "9.7", "完整", "LLM-as-a-judge"),
         (22, 22, "7.6", "完整", "Self-consistency"),
         (23, 23, "11.5", "完整", "CaMeL"),
         (24, 24, "11.7", "完整", "AgentDojo"),
         (25, 25, "11.7", "完整", "InjecAgent"),
         (26, 26, "11.2", "完整", "PromptInject"),
     ]),
    ("STD", "standards.md",
     "标准、规范与治理框架", "版本随正文标注",
     "合规映射只写可执行条款，不抄条文",
     [
         (1, 1, "10.3", "完整", "OTel GenAI spans"),
         (2, 2, "10.3", "完整", "OTel MCP attributes"),
         (3, 3, "10.2", "完整", "W3C Trace Context"),
         (4, 4, "12.6", "完整", "NIST AI RMF"),
         (5, 5, "12.6", "完整", "NIST GenAI Profile"),
         (6, 6, "12.6", "精选", "ISO/IEC 42001"),
         (7, 7, "12.6", "精选", "EU AI Act 时间表"),
         (8, 8, "11.1", "完整", "OWASP LLM Top 10"),
         (9, 9, "11.4", "精选", "SLSA"),
         (10, 10, "11.4", "精选", "Sigstore"),
         (11, 11, "11.4", "精选", "SPDX/CycloneDX"),
         (12, 12, "2.8", "完整", "OAuth 2.1"),
         (13, 13, "2.8", "完整", "RFC 8707"),
         (14, 14, "2.8", "完整", "RFC 9728"),
         (15, 15, "2.2", "完整", "JSON Schema 2020-12"),
         (16, 16, "11.5", "完整", "MCP Security Best Practices"),
     ]),
    ("MAN", "linux-man.md",
     "Linux man-pages 与 Bash 手册（回归清单）", "Linux 6.8 / bash 5.2 / groff man-pages",
     "只写 agent 沙箱与观测会用到的边界；五条历史错误必须在正文或附录 B 纠正",
     [
         (1, 2, "3.2", "完整", "wait status 与 WEXITSTATUS，示例 0x2a00"),
         (3, 3, "4.6", "完整", "clone 可变参数 parent_tid→tls→child_tid"),
         (4, 4, "8.3", "完整", "mq_open variadic 原型"),
         (5, 5, "8.5", "完整", "sem_open variadic 原型"),
         (6, 6, "10.7", "完整", "TZ 空值/无法解释/tzdata 缺失均为 UTC"),
         (7, 7, "3.2", "完整", "pipefail 与 PIPESTATUS"),
         (8, 8, "3.5", "完整", "ulimit 软/硬限制"),
         (9, 9, "13.6", "完整", "jobs 作业表"),
         (10, 10, "4.3", "完整", "seccomp(2)"),
         (11, 11, "4.4", "完整", "landlock(7)"),
         (12, 12, "4.5", "完整", "user_namespaces(7)"),
         (13, 13, "3.3", "完整", "openat2(2)"),
         (14, 14, "3.5", "完整", "cgroup v2"),
         (15, 15, "4.2", "完整", "capabilities(7)"),
         (16, 16, "3.2", "完整", "pidfd_open(2)"),
     ]),
]


def parse_toc(path):
    out = {}
    for line in open(path, encoding="utf-8"):
        m = re.match(r"^-\s*(\d+)\s+(.+?)\s*$", line)
        if m:
            out[int(m.group(1))] = m.group(2)
    return out


def chapter_numbers():
    nums = set()
    summary = os.path.join(ROOT, "src", "SUMMARY.md")
    for line in open(summary, encoding="utf-8"):
        m = re.search(r"\(part\d/ch(\d{2})\.md\)", line)
        if m:
            nums.add(int(m.group(1)))
    return nums


def landing_chapters(landing):
    out = set()
    for tok in re.split(r"[/、,，\s]+", landing):
        m = re.match(r"^(\d+)\.", tok)
        if m:
            out.add(int(m.group(1)))
    return out


def validate():
    errors = []
    stats = []
    for code, fname, name, ver, note, mapping in SOURCES:
        titles = parse_toc(os.path.join(TOC, fname))
        if not titles:
            errors.append(f"{code}: 目录为空或不存在 {fname}")
            continue
        n = max(titles)
        covered = Counter()
        for a, b, landing, degree, why in mapping:
            for i in range(a, b + 1):
                covered[i] += 1
            for c in landing_chapters(landing):
                if c not in chapter_numbers():
                    errors.append(f"{code}: 落点 {landing} 的章 {c} 不在 SUMMARY")
        missing = [i for i in range(1, n + 1) if covered[i] == 0]
        dup = [i for i, c in covered.items() if c > 1]
        if missing:
            errors.append(f"{code}: 缺口 {missing}")
        if dup:
            errors.append(f"{code}: 重复映射 {dup}")
        for i in range(1, n + 1):
            if i not in titles:
                errors.append(f"{code}: 缺标题 {i}")
        stats.append((code, name, ver, note, n, titles, mapping))
    return errors, stats


def degree_counts(mapping):
    c = Counter()
    for a, b, landing, degree, why in mapping:
        c[degree] += b - a + 1
    return c


def render(stats):
    L = []
    L.append("# A 母本覆盖矩阵")
    L.append("")
    L.append("## A.1 这张表怎么读")
    L.append("")
    L.append("本表把本书用到的每一部母本、规范与论文的**每一个章节**映射到正文落点。它是"
             "「不遗漏、不越界」的验收依据，不是装饰：")
    L.append("")
    L.append("- **完整**：该章的概念、关键接口/字段、边界与例子都在正文出现；")
    L.append("- **精选**：核心概念与常用接口在正文，冷门细节只给判断；")
    L.append("- **背景**：只保留理解主线所需的最小集；")
    L.append("- **交叉引用**：该书已覆盖，本书**不重写**，只在 agent 新增层需要时给出落点；")
    L.append("- **淘汰**：内容过时或超出范围，只在附录 B 保留说明。")
    L.append("")
    L.append("《Linux 系统与内核》第 2/3/5 篇与《深度学习导论》是**前置知识**，"
             "本书用「交叉引用」明确边界：进程、信号、IPC、namespace、cgroup、TCP/IP、"
             "容器、神经网络、训练方法都不在这里重讲。若你发现某一节在本书找不到落点，"
             "按「母本」列回查；若发现本书重写了基础，那是缺陷，不是覆盖。")
    L.append("")
    L.append("> 版本基线：MCP `2026-07-28`（对照 `2025-11-25`）、OCI Runtime Spec `v1.3.0`、"
             "OpenTelemetry Semantic Conventions `1.44.0`、Linux 6.8、bash 5.2。"
             "页码随版本漂移，故不列页码。")
    L.append("")
    totals = Counter()
    total_units = 0
    for code, name, ver, note, n, titles, mapping in stats:
        L.append(f"## {code} · {name}")
        L.append("")
        L.append(f"*{ver}。{note}。*")
        L.append("")
        L.append("| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |")
        L.append("|:--|:--|:--|:--|:--|")
        for a, b, landing, degree, why in mapping:
            label = f"第 {a} 章" if a == b else f"第 {a}–{b} 章"
            title = titles.get(a, "")
            if a != b:
                title = f"{titles.get(a, '')} … {titles.get(b, '')}"
            L.append(f"| {label} | {title} | {landing} | {degree} | {why} |")
            totals[degree] += b - a + 1
        L.append("")
        total_units += n
    L.append("## A.2 覆盖统计")
    L.append("")
    L.append("| 母本 | 单元数 | 完整 | 精选 | 背景 | 交叉引用 | 淘汰 | 缺口 |")
    L.append("|:--|--:|--:|--:|--:|--:|--:|--:|")
    grand = Counter()
    for code, name, ver, note, n, titles, mapping in stats:
        c = degree_counts(mapping)
        grand.update(c)
        L.append(f"| {code} | {n} | {c['完整']} | {c['精选']} | {c['背景']} | "
                 f"{c['交叉引用']} | {c['淘汰']} | 0 |")
    L.append(f"| **合计** | **{total_units}** | **{grand['完整']}** | **{grand['精选']}** | "
             f"**{grand['背景']}** | **{grand['交叉引用']}** | **{grand['淘汰']}** | **0** |")
    L.append("")
    L.append(f"逐单元统计：完整 {grand['完整']}、精选 {grand['精选']}、背景 {grand['背景']}、"
             f"交叉引用 {grand['交叉引用']}、淘汰 {grand['淘汰']}、缺口 0。")
    L.append("")
    L.append("## A.3 不重写声明")
    L.append("")
    L.append("| 主题 | 已由谁覆盖 | 本书只做什么 |")
    L.append("|:--|:--|:--|")
    L.append("| 进程、信号、IPC、socket、epoll | Linux 卷第 2 篇 | 在沙箱边界处引用；写清 wait status、"
             "进程组、超时与退出码 |")
    L.append("| namespace、cgroup、seccomp、容器 | Linux 卷第 3/5 篇 | 组合成 code agent 的沙箱；"
             "补 capability/landlock 的次序与陷阱 |")
    L.append("| TCP/IP、DNS、HTTP | Linux 卷第 4 篇 | 只写 egress 策略、代理与 DNS 重绑定风险 |")
    L.append("| 神经网络、注意力、训练 | 《深度学习导论》 | 只引用 token/上下文/成本等工程含义 |")
    L.append("| 云原生编排 | Linux 卷第 5 篇 | 只写 agent 平台的最小权限与审计落点 |")
    L.append("")
    L.append("## A.4 缺口补记")
    L.append("")
    L.append("本版从映射表生成时即要求「缺口 0」，没有事后补记。若后续规范改版"
             "（例如 MCP 再发新版），先改 `写作规范/source-toc/` 与 `tools/build_coverage.py` 的 "
             "`SOURCES`，再重跑本脚本；缺口非零时脚本会拒绝写出页面。")
    L.append("")
    L.append("> 复核命令：`python3 tools/build_coverage.py && python3 tools/check_book.py`。")
    L.append("")
    return "\n".join(L)


def main():
    errors, stats = validate()
    if errors:
        print("覆盖映射校验失败：", file=sys.stderr)
        for e in errors:
            print("  -", e, file=sys.stderr)
        return 1
    text = render(stats)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    open(OUT, "w", encoding="utf-8").write(text)
    open(COPY, "w", encoding="utf-8").write(text)
    total = sum(n for _, _, _, _, n, _, _ in stats)
    print(f"wrote {OUT}  ({total} units, gaps 0)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
