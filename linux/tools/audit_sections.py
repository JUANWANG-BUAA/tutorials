#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""节级覆盖审计：把母本目录逐节拿去正文里找落点。

不是语义理解，而是**机械筛子**：抽标题里的高信息量中文短语/英文术语，在限定篇目的
正文（去掉代码块与 HTML）里找。零命中/弱命中会被列出，再由人/代理逐条确认。
输出：写作规范/AUDIT-sections.md
"""

from __future__ import annotations

import glob
import os
import re
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, ".."))
TOC = os.path.join(ROOT, "写作规范", "source-toc")
if not os.path.isdir(TOC):
    TOC = os.path.normpath(os.path.join(ROOT, "..", ".work", "source-toc"))
SRC = os.path.join(ROOT, "src")
OUT = os.path.join(ROOT, "写作规范", "AUDIT-sections.md")
OUT_CH = os.path.join(ROOT, "写作规范", "AUDIT-chapters.md")

CHAPTER = re.compile(r"^\s*-\s*第\s*([0-9]+|[零一二三四五六七八九十]+)\s*章[、 ]?\s*(.*?)(?:\s*\[p\d+\])?\s*$")
SECTION = re.compile(r"^\s*-\s*(\d+(?:\.\d+)+)\s+(.*?)(?:\s*\[p\d+\])?\s*$")
CN = {"零": 0, "一": 1, "二": 2, "三": 3, "四": 4, "五": 5,
      "六": 6, "七": 7, "八": 8, "九": 9, "十": 10}

# 每本母本允许匹配的正文范围（减少跨篇误命中）
SCOPES = {
    "kerrisk": ["part0", "part1", "part2", "part3"],
    "csapp": ["part1", "part2"],
    "ostep": ["part1", "part3"],
    "os-harbin": ["part1", "part3"],
    "running-linux": ["part1", "part3", "part4"],
    "network": ["part2", "part4", "part5"],
    "niaoge": ["part0"],
    "shotts": ["part0"],
    "shell-book": ["part0"],
    "cn8": ["part1", "part4", "part5"],
}

BOOKS = [
    ("kerrisk", "K · Kerrisk 系统编程手册", "clean-kerrisk.md"),
    ("csapp", "C · CSAPP 3e", "clean-csapp.md"),
    ("ostep", "O · OSTEP", "clean-ostep-sections.md"),
    ("os-harbin", "L · 操作系统原理、实现与实践", "clean-os-harbin.md"),
    ("running-linux", "R · 奔跑吧 Linux 内核", "clean-running-linux.md"),
    ("network", "N · 深入理解 Linux 网络", "clean-network.md"),
    ("niaoge", "G · 鸟哥的 Linux 私房菜", "niaoge.md"),
    ("shotts", "S · Linux 命令行大全", "clean-shotts.md"),
    ("shell-book", "B · Linux 命令行与 shell 脚本编程大全", "clean-shell-book.md"),
    ("cn8", "W · 计算机网络 8e", "cn8.md"),
]

# 太泛、不适合作为「是否覆盖」判据的词
STOP_CN = {
    "概述", "介绍", "总结", "小结", "练习", "习题", "答案", "参考", "文献",
    "历史", "其他", "更多", "基础", "使用", "一个", "示例", "例子", "问题",
    "方法", "实现", "功能", "内容", "结构", "操作", "管理", "分析", "原理",
    "本章", "重点", "回顾", "简介", "入门", "讨论", "说明", "情况", "方式",
    "时候", "部分", "相关", "主要", "一般", "如何", "什么", "为什么",
}
STOP_EN = {
    "the", "and", "for", "with", "from", "this", "that", "into", "over",
    "linux", "unix", "using", "use", "example", "introduction", "overview",
}


PED = ("重点回顾", "本章习题", "本章练习", "参考资料", "延伸阅读",
       "习题答案", "参考答案", "参考文献", "家庭作业", "练习")


def is_pedagogical(title: str) -> bool:
    return any(x in title for x in PED)


def cn_to_int(s: str) -> int:
    if s.isdigit():
        return int(s)
    if s == "十":
        return 10
    if "十" in s:
        a, b = s.split("十", 1)
        return (CN.get(a, 1) if a else 1) * 10 + (CN.get(b, 0) if b else 0)
    return CN.get(s, -1)


def parse_toc(path: str):
    """返回 [(chapter_no, chapter_title, [(sec_no, sec_title)])]。"""
    out = []
    cur = None
    for line in open(path, encoding="utf-8", errors="ignore"):
        m = CHAPTER.match(line)
        if m:
            n = cn_to_int(m.group(1))
            if n < 0:
                continue
            cur = (n, re.sub(r"\s+", " ", m.group(2)).strip(), [])
            out.append(cur)
            continue
        m = SECTION.match(line)
        if m and cur is not None:
            cur[2].append((m.group(1), re.sub(r"\s+", " ", m.group(2)).strip()))
    return out


def load_pages(parts):
    pages = []
    for part in parts:
        for path in sorted(glob.glob(os.path.join(SRC, part, "*.md"))):
            text = open(path, encoding="utf-8").read()
            # 去掉围栏代码、HTML 标签、行内代码，保留正文与标题
            text = re.sub(r"```.*?```", " ", text, flags=re.S)
            text = re.sub(r"~~~.*?~~~", " ", text, flags=re.S)
            text = re.sub(r"<pre\b[^>]*>.*?</pre>", " ", text, flags=re.S)
            text = re.sub(r"<[^>]+>", " ", text)
            text = re.sub(r"`([^`]*)`", r"\1", text)
            pages.append((os.path.relpath(path, SRC), text))
    return pages


def keywords(title: str):
    """抽高信息量关键词：英文词 + 中文 2–4 字片段。"""
    kws = []
    for w in re.findall(r"[A-Za-z][A-Za-z0-9_+.#/-]{2,}", title):
        wl = w.lower().strip(".-/")
        if wl and wl not in STOP_EN and len(wl) >= 3:
            kws.append((wl, 3))
    # 中文连续段
    for seg in re.findall(r"[\u4e00-\u9fff]+", title):
        seg = seg.strip()
        if len(seg) < 2:
            continue
        # 整段 + 2/3/4 字滑窗：整段权重最高，短词用于容忍不同措辞
        if 2 <= len(seg) <= 8 and seg not in STOP_CN:
            kws.append((seg, len(seg) + 2))
        for n in (4, 3, 2):
            for i in range(0, len(seg) - n + 1):
                sub = seg[i:i + n]
                if sub not in STOP_CN:
                    kws.append((sub, n))
    # 去重，保留最大权重
    best = {}
    for k, w in kws:
        if k not in best or w > best[k]:
            best[k] = w
    return list(best.items())


def score_page(kws, text):
    low = text.lower()
    hit = []
    total = 0
    got = 0
    for k, w in kws:
        total += w
        if k in low:
            got += w
            hit.append(k)
    return got, total, hit


def audit_book(key, label, tocfile, pages):
    toc = parse_toc(os.path.join(TOC, tocfile))
    rows = []
    for chno, chtitle, secs in toc:
        entries = secs if secs else [(str(chno), chtitle)]
        for secno, sectitle in entries:
            if is_pedagogical(sectitle):
                continue
            kws = keywords(sectitle)
            if not kws:
                continue
            best = (None, 0, 0, [])
            for rel, text in pages:
                got, total, hit = score_page(kws, text)
                if got > best[1]:
                    best = (rel, got, total, hit)
            rel, got, total, hit = best
            ratio = got / total if total else 0
            status = "zero" if got == 0 else ("weak" if ratio < 0.34 or len(hit) <= 1 else "ok")
            rows.append({
                "book": label, "ch": chno, "chtitle": chtitle,
                "sec": secno, "sectitle": sectitle,
                "page": rel, "ratio": ratio, "hit": hit, "status": status,
            })
    return rows


def main():
    all_rows = []
    page_cache = {}
    for key, label, tocfile in BOOKS:
        parts = SCOPES[key]
        pages = page_cache.setdefault(tuple(parts), load_pages(parts))
        rows = audit_book(key, label, tocfile, pages)
        all_rows.extend(rows)
        print(f"{key}: {len(rows)} sections")
    bad = [r for r in all_rows if r["status"] != "ok"]
    lines = ["# 节级覆盖审计（机械筛子）", "",
             "> 由 `tools/audit_sections.py` 生成。`zero` 表示标题里的高信息量词在限定篇目正文中一个都没找到；"
             "`weak` 表示只命中一个词或命中率 < 34%。这两类必须人工复核：可能真的漏了，也可能只是换了说法。", "",
             f"共 {len(all_rows)} 个节级条目，`zero` {sum(1 for r in all_rows if r['status']=='zero')}、"
             f"`weak` {sum(1 for r in all_rows if r['status']=='weak')}、`ok` {sum(1 for r in all_rows if r['status']=='ok')}。", "",
             "## 需要复核的条目", "",
             "| 状态 | 母本 | 章 | 节 | 标题 | 最佳落点 | 命中词 |",
             "|:--|:--|:--|:--|:--|:--|:--|"]
    order = {"zero": 0, "weak": 1, "ok": 2}
    for r in sorted(bad, key=lambda x: (order[x["status"]], x["book"], x["ch"], x["sec"])):
        hits = "、".join(r["hit"][:6]) if r["hit"] else "—"
        lines.append(f"| {r['status']} | {r['book']} | {r['ch']} | {r['sec']} | {r['sectitle']} | {r['page']} | {hits} |")
    lines.append("")
    open(OUT, "w", encoding="utf-8").write("\n".join(lines))

    # 章级汇总：每章有多少节、多少 zero/weak，便于定位薄弱章
    agg = {}
    for r in all_rows:
        key = (r["book"], r["ch"], r["chtitle"])
        a = agg.setdefault(key, {"n": 0, "zero": 0, "weak": 0, "titles": []})
        a["n"] += 1
        if r["status"] == "zero":
            a["zero"] += 1
            if len(a["titles"]) < 3:
                a["titles"].append(r["sectitle"])
        elif r["status"] == "weak":
            a["weak"] += 1
    cl = ["# 章级审计汇总", "",
          "> 排除「重点回顾/本章习题/参考资料」等教辅条目后，按章统计节级 zero/weak。",
          "", "| 母本 | 章 | 标题 | 节数 | zero | weak | 零命中节（最多 3 个） |",
          "|:--|--:|:--|--:|--:|--:|:--|"]
    for (book, ch, title), a in sorted(agg.items(), key=lambda kv: (-kv[1]["zero"], -kv[1]["weak"], kv[0][0], int(kv[0][1]) if str(kv[0][1]).isdigit() else 0)):
        ts = "；".join(a["titles"]) if a["titles"] else "—"
        cl.append(f"| {book} | {ch} | {title} | {a['n']} | {a['zero']} | {a['weak']} | {ts} |")
    cl.append("")
    open(OUT_CH, "w", encoding="utf-8").write("\n".join(cl))
    print("wrote", OUT, "bad", len(bad), "chapters", len(agg))


if __name__ == "__main__":
    main()
