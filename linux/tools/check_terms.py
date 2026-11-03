#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""术语首现审计：按全书阅读顺序检查「第一次出现有没有解释」。

`textbook_lint.py` 是逐章跑的，它看不见前面的章。于是会出现这种情况：某个术语在
1.9 节里被认真定义了，但它在 0.1 章就被顺口提过一次，那一次没有任何解释——非科班
读者第一次撞上它，恰好就是那一次。

本脚本按 `SUMMARY.md` 的顺序串起全书正文，对每个硬术语只关心**第一次**在散文里
出现的位置（跳过代码围栏与行内代码），并判断那一句附近有没有：

- 括号展开（`（inode，索引节点）`这类中英对照）；
- 定义用语（是/是指/就是/又叫/也称/即/指的是/表示）；
- 该术语此前已被定义过（那就不是首现）。

用法：
    python3 tools/check_terms.py             # 报告所有未解释的首现
    python3 tools/check_terms.py --json      # 机器可读，便于分批处理

命中不等于一定要改：章名、前置声明、明确的「第 X 章会讲」式预告都可以是合理的首现。
判据是「读者在这一页能不能猜出它大概是干什么的」。
"""

from __future__ import annotations

import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(os.path.dirname(HERE), "src")

TERMS = (
    "文件描述符", "页表", "虚拟内存", "inode", "系统调用", "中断", "DMA",
    "写时复制", "COW", "缺页", "TLB", "缓存行", "伪共享", "原子操作",
    "内存序", "背压", "零拷贝", "namespace", "cgroup", "overlayfs",
    "三次握手", "拥塞控制", "epoll", "io_uring", "VFS", "slab",
)

GLOSS_WORDS = ("是指", "指的是", "又叫", "也称", "就是", "表示", "指的是", "即")
FENCE = re.compile(r"^\s*(```|~~~)")


# 已判定为合理的例外：术语第一次出现的地方体裁上不该塞释义。
# 每条都要写清理由和真正的定义在哪一节，否则例外就是赖账。
ACCEPTED = {
    ("系统调用", "part0/ch01.md"):
        "0.1 章导语的「读完你会」是学习目标清单，不是讲解散文；"
        "同一章 0.1.1 的「非科班补一层」盒子给出定义（用户态请内核办事的唯一入口）。",
}


def reading_order():
    """按 SUMMARY.md 的顺序返回**正文章节**路径。

    只取 `src/part*/chNN.md`：卷首页（preface / scope / objectives / roadmap）
    是「地图」体裁，作用是列出全书要讲什么，要求每个术语在那里就给出白话解释
    既不合理也毁掉那几页的用途。
    """
    out, seen = [], set()
    summary = os.path.join(SRC, "SUMMARY.md")
    for line in open(summary, encoding="utf-8"):
        m = re.search(r"\]\(([^)#\s]+\.md)", line)
        if not m:
            continue
        p = os.path.normpath(os.path.join(SRC, m.group(1)))
        rel = os.path.relpath(p, SRC).replace(os.sep, "/")
        if not re.match(r"part\d+/ch\d\d\.md$", rel):
            continue
        if p in seen or not os.path.exists(p):
            continue
        seen.add(p)
        out.append(p)
    return out


def prose_lines(text: str):
    """返回 (行号, 参与匹配的文本, 展示用原文)；跳过代码围栏，行内代码抹掉。"""
    res, in_fence = [], False
    for i, line in enumerate(text.split("\n"), 1):
        if FENCE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        s0 = line.lstrip()
        if s0.startswith("#") or s0.startswith(":::"):
            continue        # 标题与盒名是名字，不是首次使用；解释只能落在正文里
        stripped = re.sub(r"`[^`\n]*`", " ", line)
        stripped = re.sub(r"<[^>\n]*>", " ", stripped)
        if stripped.strip():
            res.append((i, stripped, line.strip()))
    return res


def glossed(sentence: str, term: str) -> bool:
    idx = sentence.find(term)
    tail = sentence[idx: idx + len(term) + 40]
    if "（" in tail[:len(term) + 3] or "(" in tail[:len(term) + 3]:
        return True
    if tail[len(term):len(term) + 1] in ("）", ")"):
        return True         # 术语本身就在括号里，前面那半句已是解释
    if sentence.strip().startswith(term) and re.match(
            re.escape(term) + r"[（ (]*[^一-鿿]{0,24}[是为]", sentence.strip()):
        return True         # 「X 是……」/「X 为……」式的定义句本身就算解释
    window = sentence[max(0, idx - 24): idx + len(term) + 40]
    if any(g in window for g in GLOSS_WORDS):
        return True
    return False


def main() -> int:
    as_json = "--json" in sys.argv
    defined: dict[str, str] = {}
    hits = []
    for path in reading_order():
        rel = os.path.relpath(path, SRC).replace(os.sep, "/")
        for line_no, text, shown in prose_lines(open(path, encoding="utf-8").read()):
            for term in TERMS:
                if term in defined or term not in text:
                    continue
                if glossed(text, term):
                    defined[term] = f"{rel}:{line_no}"
                else:
                    defined[term] = ""      # 首现未解释，后面再遇到不算首现
                    if (term, rel) in ACCEPTED:
                        continue
                    hits.append({"term": term, "where": f"{rel}:{line_no}",
                                 "text": shown[:88],
                                 "note": ACCEPTED.get((term, rel), "")})
    if as_json:
        print(json.dumps(hits, ensure_ascii=False, indent=1))
        return 0
    if not hits:
        print("所有硬术语的首现都带解释或中英对照。")
        return 0
    print(f"未解释的首现：{len(hits)} 个术语")
    for h in hits:
        print(f"  {h['term']:12s} {h['where']}")
        print(f"      {h['text']}")
    print("\n逐条判定：需要补一句白话的，在该章改造批里补；"
          "属于合理预告/章节名的，在本文件末尾记一笔理由。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
