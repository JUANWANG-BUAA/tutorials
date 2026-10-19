#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""覆盖矩阵校验：要求主题 0 缺口、锚点全部存在、每章都有落点。

用法：python3 tools/check_coverage.py
数据源：src/appendix/coverage.md
"""

from __future__ import annotations

import os
import re
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")
COVERAGE = os.path.join(SRC, "appendix", "coverage.md")

# 任务书要求 + 本书承诺的主题。名称必须与 coverage.md 第二列逐字一致。
REQUIRED = [
    "请求路径与延迟预算",
    "部分失败与 unknown 状态",
    "超时与 deadline 传播",
    "重试、退避与抖动",
    "重试预算与放大倍数",
    "幂等键与请求指纹",
    "去重表与状态机",
    "背压与并发上限",
    "限流与过载保护",
    "单主复制",
    "多主复制与冲突解决",
    "无主复制与 quorum",
    "复制延迟与读己之写",
    "线性一致性",
    "顺序一致性",
    "因果一致性与会话保证",
    "最终一致性与收敛",
    "CAP 与 PACELC 的精确表述",
    "Paxos",
    "Multi-Paxos 与活锁",
    "Raft 选举",
    "Raft 日志复制与提交",
    "成员变更与快照",
    "线性一致读（ReadIndex/lease）",
    "ACID 与事务边界",
    "隔离级别与异常",
    "MVCC 可见性",
    "分布式事务 2PC/TCC/Saga",
    "Outbox 与幂等消费",
    "队列与日志的区别",
    "投递语义",
    "分区、顺序与消费者组",
    "offset 提交与再平衡",
    "Kafka ISR/acks/事务",
    "CDC 与事件溯源",
    "对象存储语义",
    "缓存模式与一致性",
    "缓存击穿/穿透/雪崩",
    "CDN 与边缘缓存",
    "分布式锁",
    "租约与 fencing token",
    "选主与分裂脑",
    "trace 与上下文传播",
    "指标与分位数",
    "结构化日志",
    "SLO 与错误预算",
    "回放与影子流量",
    "容量与 Little's law",
    "排队与利用率曲线",
    "压测方法",
    "降级、熔断与舱壁",
    "故障演练与爆炸半径",
    "项目一：幂等工具调用后端",
    "项目二：小型复制 KV",
    "项目二的一致性读（ReadIndex/lease/stale）",
]

ANCHOR_RE = re.compile(r"`((?:sec|def|thm|ex|intuition|method|errata|note|proof|sol)-distributed\.\d+\.\d+\.\d+)`")


def anchors_in_src():
    found = set()
    for dirpath, _, files in os.walk(SRC):
        for fn in files:
            if not fn.endswith(".md"):
                continue
            path = os.path.join(dirpath, fn)
            text = open(path, encoding="utf-8").read()
            text = re.sub(r"```.*?```", "", text, flags=re.S)
            text = re.sub(r"`[^`]*`", "", text)
            found.update(re.findall(r"\{#([^}\s]+)\}", text))
    return found


def parse_rows(text):
    rows = []
    for line in text.splitlines():
        if not line.strip().startswith("|"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) < 4:
            continue
        if set(cells[0]) <= set("-: "):
            continue
        rows.append(cells)
    return rows


def main():
    if not os.path.exists(COVERAGE):
        print(f"缺少 {COVERAGE}")
        return 1
    text = open(COVERAGE, encoding="utf-8").read()
    rows = parse_rows(text)
    anchors = anchors_in_src()

    # 主题表：第二列是主题，第四列含锚点
    topics = {}
    missing_anchor = []
    for cells in rows:
        if len(cells) < 4:
            continue
        name = re.sub(r"`", "", cells[1]).strip()
        if name in REQUIRED:
            m = ANCHOR_RE.search(cells[3]) or ANCHOR_RE.search(cells[2])
            if not m:
                missing_anchor.append(name)
            topics[name] = (cells[2], m.group(1) if m else None)

    missing_topics = [t for t in REQUIRED if t not in topics]
    bad_anchors = [(n, a) for n, (_, a) in topics.items() if a and a not in anchors]

    # 每章至少一行
    chapters = [f"{p}/ch{c:02d}.md" for p, n in [(1, 2), (2, 3), (3, 3), (4, 3), (5, 2)]
                for c in range(sum([2, 3, 3, 3, 2][:p - 1]) + 1, sum([2, 3, 3, 3, 2][:p]) + 1)]
    per_chapter = defaultdict(int)
    for name, (loc, _) in topics.items():
        m = re.search(r"\b(\d{1,2})\.\d", loc)
        if m:
            per_chapter[int(m.group(1))] += 1

    print(f"required topics: {len(REQUIRED)}   found: {len(topics)}   anchors: {len(anchors)}")
    if missing_topics:
        print("\n缺口主题:")
        for t in missing_topics:
            print(f"  - {t}")
    if missing_anchor:
        print("\n无锚点主题:")
        for t in missing_anchor:
            print(f"  - {t}")
    if bad_anchors:
        print("\n锚点不存在:")
        for n, a in bad_anchors[:30]:
            print(f"  - {n}: {a}")
    if per_chapter:
        thin = [c for c in range(1, 14) if per_chapter.get(c, 0) < 2]
        if thin:
            print(f"\n落点少于 2 个主题的章: {thin}")
    print("\nOK" if not (missing_topics or missing_anchor or bad_anchors) else "\nFAILED")
    return 0 if not (missing_topics or missing_anchor or bad_anchors) else 1


if __name__ == "__main__":
    sys.exit(main())
