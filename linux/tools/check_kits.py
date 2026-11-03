#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""章末件覆盖率清点（非阻塞）。

每章应有 6 个页面：章总览 + 章末总结 + 闭卷回忆卡 + 习题集 + 学习目标自检表 + 勘误与版本注记。
本脚本只检查“有没有、有没有关键标题”，不判断内容质量；内容质量看 72-章节审读表。

用法（工作目录 linux/）：
    python3 tools/check_kits.py            # 打印覆盖率与缺件
    python3 tools/check_kits.py --strict   # 有缺件时 exit 1
    python3 tools/check_kits.py --complete # 只列已齐的章
"""

from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SRC = ROOT / "src"

KIT = ["overview", "summary", "recall", "exercises", "checklist", "errata"]

REQUIRED = {
    "overview": ["读完你会", "本章路线", "章末件"],
    "summary": ["单元", "主线"],
    "recall": ["回忆卡"],
    "exercises": ["A 组", "B 组", "C 组"],
    "checklist": ["达标检验"],
    "errata": ["版本"],
}


def chapters() -> list[Path]:
    return sorted(p for p in SRC.glob("part*/ch[0-9][0-9].md"))


def check(path: Path) -> tuple[int, list[str], list[str]]:
    missing, bad = [], []
    for name in KIT:
        p = path.with_name(f"{path.stem}-{name}.md")
        if not p.exists():
            missing.append(name)
            continue
        text = p.read_text(encoding="utf-8")
        lost = [k for k in REQUIRED[name] if k not in text]
        if lost:
            bad.append(f"{name}:缺{'/'.join(lost)}")
    return len(KIT) - len(missing), missing, bad


def main() -> int:
    strict = "--strict" in sys.argv
    only_complete = "--complete" in sys.argv
    rows = [(p, *check(p)) for p in chapters()]
    complete = [r for r in rows if r[1] == len(KIT) and not r[3]]
    print(f"章末件覆盖：{len(complete)}/{len(rows)} 章齐备（6/6）")
    print(f"{'chapter':24}{'kit':>5}  缺件 / 缺标题")
    for p, n, missing, bad in rows:
        if only_complete and (n < len(KIT) or bad):
            continue
        detail = []
        if missing:
            detail.append("缺文件：" + ",".join(missing))
        if bad:
            detail.append("；".join(bad))
        print(f"{p.relative_to(SRC).as_posix():24}{n:>5}/6  " + ("；".join(detail) if detail else "OK"))
    if strict and (len(complete) != len(rows)):
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
