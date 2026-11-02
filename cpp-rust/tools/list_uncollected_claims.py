#!/usr/bin/python3
"""把全书「本节没有采集 X」的声明，和磁盘上真实存在的同类产物并排列出来。

为什么要这个：同一类错抓过两次——第 11 章写「没有采集采样栈」，可 `run-01/queue-sample.txt` 一直在盘上；
第 14 章写「没有生成 profraw 或 profdata」，而第 6 章 6.8 真跑过 PGO，产物在 `extra-02/pgo-data/`。
「未采集」是这本书最诚实的一类句子，也因此最容易写成全称却撑不住的话。

这不是门禁，也不会自动判红：它只负责把「声明」和「可能的反例文件」放在一起摆给冷读者看。
关键词匹配会有误报（比如把 `profile-run.txt` 当成 self-profile 产物），所以要人判，不要拿来当判据。
"""

from __future__ import annotations

import argparse
import glob
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

CLAIM = re.compile(r"[^。\n]*(?:没有采集|未采集|没有采到|没有生成|没有执行|不覆盖采集)[^。\n]*。")

# 声明里的说法 → 归档里值得搜的产物特征（文件名小写子串）
PROBES: list[tuple[str, tuple[str, ...]]] = [
    ("采样栈 / profile 栈", ("sample", "profil")),
    ("self-profile 与逐 pass 转储", ("self-profile", "measureme", "mm_profdata", "-passes", "pre-pass")),
    ("PGO 训练数据", ("profraw", "profdata", "pgo-data")),
    ("重试计数 / 缓存行弹跳", ("retry", "cachemiss", "cache-miss", "bounce", "perf")),
    ("逐请求尾延迟", ("percentile", "per-request", "latency")),
    ("跨平台 / CI 产物", ("ci-", "linux", "x86")),
    # 第 6 章被读者抓到一条这条没覆盖的假陈述：说「各节尺寸增量没有采集」，
    # 而 extra-02/*-size.txt 与 *-nm.txt 就在盘上。
    ("二进制节大小与尺寸增量", ("-size.txt", "-nm.txt", "size.txt", "layout.txt")),
    ("构建耗时", ("build.txt", "build-summary", "timing")),
]


def artifacts() -> list[str]:
    out: list[str] = []
    for base in ("bench", "projects"):
        for path in ROOT.joinpath(base).rglob("*"):
            if not path.is_file() or path.is_symlink():
                continue
            rel = path.relative_to(ROOT).as_posix()
            if any(p in {"target", "build", "__pycache__", ".git"} for p in rel.split("/")):
                continue
            out.append(rel)
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--pages", default="src/part*/ch[0-9][0-9].md")
    ap.add_argument("--only", help="只看这些章号，逗号分隔，如 11,14")
    args = ap.parse_args()
    keep = {s.strip() for s in args.only.split(",")} if args.only else None
    files = artifacts()
    total = 0
    for page in sorted(ROOT.glob(args.pages)):
        chapter = re.search(r"ch(\d+)", page.name)
        if keep and (chapter is None or chapter.group(1).lstrip("0") not in {k.lstrip("0") for k in keep}):
            continue
        text = page.read_text(encoding="utf-8")
        for m in CLAIM.finditer(text):
            line = text[:m.start()].count("\n") + 1
            claim = m.group(0).strip()
            total += 1
            hits = {
                name: [f for f in files if any(k in os.path.basename(f).lower() for k in keys)][:4]
                for name, keys in PROBES
                if any(word in claim for word in word_keys(name))
            }
            hits = {k: v for k, v in hits.items() if v}
            print(f"\n[{page.name}:{line}] {claim.strip()}")
            if hits:
                for name, matched in hits.items():
                    print(f"   ⚠ 疑似已有「{name}」产物：{matched}")
            else:
                print("   ✓ 没有匹配到同类产物（仍需人确认关键词覆盖到了没有）")
    print(f"\n共 {total} 条「未采集/未生成/未执行」类声明。误报是设计内的：这一页只负责把反例摆出来。")
    return 0


def word_keys(label: str) -> tuple[str, ...]:
    """声明里出现哪些词，才值得拿这一类产物去对照。"""
    return {
        "采样栈 / profile 栈": ("采样", "栈", "profile", "profil"),
        "self-profile 与逐 pass 转储": ("self-profile", "逐 pass", "逐pass", "转储"),
        "PGO 训练数据": ("PGO", "pgo", "profraw", "profdata", "profile-use", "训练"),
        "重试计数 / 缓存行弹跳": ("重试", "弹跳", "计数器", "cache"),
        "逐请求尾延迟": ("逐请求", "请求级", "尾延迟"),
        "跨平台 / CI 产物": ("跨平台", "CI"),
        "二进制节大小与尺寸增量": ("尺寸", "节大小", "各节", "__text", "size"),
        "构建耗时": ("构建期", "构建时长", "构建耗时", "编译时间"),
    }[label]


if __name__ == "__main__":
    raise SystemExit(main())
