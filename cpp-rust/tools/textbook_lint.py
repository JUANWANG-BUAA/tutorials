#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""教材就绪度报告（非阻塞）。

不替代 check_book.py 的结构门禁；它回答两个问题：

1. **有没有教材件**：学习目标、先修、例题、实验、小结、习题、参考答案。
2. **像不像《矩阵论》那本教程**：每节是否按「先抓住一件事 → 定义盒 → 例题盒套折叠解答
   → 思考盒 → 常见错误清单 → 即时自测」推进，章首是否有路线图与母题，
   概念之间是否用 `[@id]` 互相指回。

用法：python3 tools/textbook_lint.py [章节文件...]
"""
from __future__ import annotations

import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
SRC = os.path.join(ROOT, "src")

TEACH_BOX = {
    "preview": re.compile(r"^:::\s*preview\b", re.M),
    "def": re.compile(r"^:::\s*def\b", re.M),
    "ex": re.compile(r"^:::\s*ex\b", re.M),
    "sol": re.compile(r"^:::\s*sol\b", re.M),
    "think": re.compile(r"^:::\s*think\b", re.M),
    "errata": re.compile(r"^:::\s*errata\b", re.M),
    "quiz": re.compile(r"^:::\s*method\s+即时自测", re.M),
}


# 零基础读者最容易被卡住的术语：首次出现在正文里时，最好紧跟一句括号解释。
HARD_TERMS = ("缓存行", "伪共享", "内联", "单态化", "去虚化", "缺页", "TLB", "内存序",
              "happens-before", "背压", "线性化点", "hazard pointer", "epoch", "RCU",
              "向量化", "零拷贝", "系统调用", "页缓存", "分配器", "niche", "vtable",
              "位模式", "探针", "预取", "寄存器")


def first_use_unglossed(text: str):
    """返回「首次出现在**散文**里、但没有括号解释」的术语列表。

    口径（2026-10-29 收窄）：只看散文行。以下位置不算首现，因为它们的职责不是
    解释术语——代码块、表格行（`|` 开头）、标题行（`#` 开头）、HTML/图行（`<` 开头）、
    语义盒的标题行（`::: def …` 这类带标签的行）。盒子里的正文仍然算散文。
    收窄之前，表格里的一个词就能让整章被标记，而正确改法（在正文首现处加释义）
    并不会消除该标记，指标因此失去信号价值。
    """
    out, infence = [], False
    body = []
    for line in text.splitlines():
        if line.strip().startswith("```"):
            infence = not infence
            continue
        if infence:
            continue
        s = line.strip()
        if s.startswith(("|", "#", "<", "!", "---")):
            continue
        if re.match(r"^:::\s*\w+\s+\S", s):   # 盒标题行；单独一行的 ::: 是闭合，不会命中
            continue
        body.append(line)
    body = "\n".join(body)
    for term in HARD_TERMS:
        i = body.find(term)
        if i < 0:
            continue
        window = body[i: i + 24]
        if "（" not in window and "(" not in window:
            out.append(term)
    return out


def prose_stats(text: str):
    in_code = False
    paras, cur = [], []
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        # 列表项各自成段：旧口径把整张项目符号表并成一段，
        # 于是「段均」量的其实是一章里列表的密度，不是行文节奏。
        if re.match(r"^([-*+]|\d+\.)\s", s):
            if cur:
                paras.append("".join(cur))
                cur = []
            paras.append(s)
            continue
        if not s or s.startswith(("#", "|", "<", ":::", "!", "---")):
            if cur:
                paras.append("".join(cur))
                cur = []
        else:
            cur.append(s)
    if cur:
        paras.append("".join(cur))
    chars = sum(len(re.findall(r"[\u4e00-\u9fff]", p)) for p in paras)
    sents = sum(p.count("。") + p.count("！") + p.count("？") for p in paras) or 1
    neg = len(re.findall(r"不能|不要|不应|不得|不是|并非|避免|禁止|严禁", text))
    total = len(re.findall(r"[\u4e00-\u9fff]", text)) or 1
    return {
        "chars": total,
        "para_avg": chars / len(paras) if paras else 0,
        "para_max": max((len(re.findall(r"[\u4e00-\u9fff]", p)) for p in paras), default=0),
        "sent_avg": chars / sents,
        "neg_per_k": neg / total * 1000,
        "neg_prose_per_k": prose_only_neg(text),
    }


def prose_only_neg(text: str) -> float:
    """只数语义盒之外的连贯正文里的「不能 / 不是 / 避免」。

    errata 与即时自测天生是说「不许干什么」的，把它们的密度混进整章会反过来误导：
    2026-10-30 实测本书正文 7.8/千字、盒内 6.8/千字——方向是错的，
    边界句应该集中在清单盒里，正文该写成正面条件。《矩阵论》同口径正文为 3.2。
    """
    in_code = False
    depth = 0
    chars = negs = 0
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        if re.match(r"^::: \w+", s):
            depth += 1
            continue
        if s.startswith(":::"):
            depth = max(depth - 1, 0)
            continue
        if depth or not s or s.startswith(("#", "|", "<", "!", "---")):
            continue
        chars += len(re.findall(r"[\u4e00-\u9fff]", s))
        negs += len(re.findall(r"不能|不要|不应|不得|不是|并非|避免|禁止|严禁", s))
    return negs / chars * 1000 if chars else 0.0


def answers_complete(chapter_path: str) -> bool:
    """本章习题集里每一道 `::: ex` 都在下一题之前有一枚 `::: sol` 解答盒。"""
    path = os.path.join(os.path.dirname(chapter_path),
                        os.path.basename(chapter_path)[:-3] + "_exercises.md")
    if not os.path.exists(path):
        return False
    marks = [(m.group(1)) for m in
             re.finditer(r"(?m)^::: (ex|sol|hint) ", open(path, encoding="utf-8").read())]
    total = 0
    for i, kind in enumerate(marks):
        if kind != "ex":
            continue
        total += 1
        rest = marks[i + 1:]
        nxt = rest.index("ex") if "ex" in rest else len(rest)
        if "sol" not in rest[:nxt]:
            return False
    return total > 0


def analyse(path: str):
    text = open(path, encoding="utf-8").read()
    rel = os.path.relpath(path, SRC).replace(os.sep, "/")
    counts = {k: len(r.findall(text)) for k, r in TEACH_BOX.items()}
    refs = len(re.findall(r"\[@[\w.\-]+\]", text))
    lines = text.splitlines()
    starts = [i for i, ln in enumerate(lines) if ln.startswith("## ")] + [len(lines)]
    # 章末三节（延伸阅读 / 常见错误 / 小结与章末件）不承担教学闭环，只数专业节。
    spans = starts[:-1][:max(len(starts) - 4, 1)]
    core = len(spans)
    # 「节覆盖」按节判定：一个专业节里有 preview 盒才算覆盖。
    # 旧口径直接数全章 preview 个数，一节内多加一个说明盒就会报出 9/8 这种假超额。
    covered = sum(1 for a, b in zip(starts, starts[1:])
                  if a in spans and "::: preview" in "\n".join(lines[a:b]))
    teach = {
        "目标": "学习目标" in text,
        "先修": "先修" in text,
        "路线": "本章路线" in text,
        "母题": "母题" in text,
        "例题": counts["ex"] >= 2,
        "小结": "本章小结" in text,
        "习题": "习题" in text,
        # 「答案」按习题集逐题核对：每题要有可展开的 ::: sol 解答盒。
        # 旧口径只在全章正文里找「参考答案」四个字，把 16 章误报成没有答案。
        "答案": answers_complete(path),
    }
    return rel, teach, counts, refs, core, covered, prose_stats(text), first_use_unglossed(text)


END_PAGES = ("summary", "recall", "exercises", "exam", "checklist")


def main():
    files = sys.argv[1:] or sorted(
        f for f in glob.glob(os.path.join(SRC, "part*", "ch*.md"))
        if re.fullmatch(r"ch\d{2}\.md", os.path.basename(f)))
    print("【教材件】")
    print(f"{'chapter':16}" + "".join(f"{k:>5}" for k in ("目标", "先修", "路线", "母题", "例题", "小结", "习题", "答案")))
    for path in files:
        rel, teach, *_ = analyse(path)
        marks = "".join(f"{'✓' if v else '·':>5}" for v in teach.values())
        print(f"{rel:16}{marks}")

    print("\n【章末件】每章应有 总结/回忆卡/习题集/自测卷/自检表 五页")
    for path in files:
        rel = os.path.relpath(path, SRC).replace(os.sep, "/")
        stem = os.path.basename(path)[:-3] + "_"
        d = os.path.dirname(path)
        have = [k for k in END_PAGES
                if os.path.exists(os.path.join(d, f"{stem}{k}.md"))]
        print(f"{rel:16}{len(have)}/5  " + " ".join(
            f"{'✓' if k in have else '·'}{k}" for k in END_PAGES))

    print("\n【《矩阵论》骨架对照】节覆盖率 = 带「先抓住一件事」的专业节 / 专业节总数")
    print(f"{'chapter':16}{'节覆盖':>8}{'preview':>9}{'def':>5}{'ex':>4}{'sol':>5}{'think':>7}{'errata':>8}{'自测':>6}{'交叉引用':>9}"
          f"{'段均':>6}{'最长段':>7}{'句均':>6}{'否定/千字':>10}{'正文否定':>9}")
    for path in files:
        rel, _, counts, refs, core, covered, m, unglossed = analyse(path)
        print(f"{rel:16}{covered}/{core:<6}{counts['preview']:>9}{counts['def']:>5}{counts['ex']:>4}{counts['sol']:>5}"
              f"{counts['think']:>7}{counts['errata']:>8}{counts['quiz']:>6}{refs:>9}"
              f"{m['para_avg']:6.0f}{m['para_max']:7d}{m['sent_avg']:6.1f}{m['neg_per_k']:10.1f}{m['neg_prose_per_k']:9.1f}"
              + (f"   首现无解释：{'、'.join(unglossed[:6])}" if unglossed else ""))


if __name__ == "__main__":
    raise SystemExit(main())
