#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
rebuild_pagemap.py — 从 pages.jsonl 重建每本书的 pdf页 → 印刷页 映射

背景
----
pagemap.json 中 39 本书的大部分印刷页为 null，导致 verify_cites2.py 对 6 处
正常引用误报「页码不存在」。实测各书页码形态不同：

  · 《四人帮》选集   页首独立数字行，pdf−printed = 16（全书恒定）
  · 毛选 1–5 合订本  页尾独立数字行，pdf−printed = 2（全书恒定）
  · 卢森堡全集第1卷  页脚数字，分段偏移 16 / 28 / 50 / 94 / 96 / 98（卷首、目录、
                     各正文段各自起算，故需多偏移并存）
  · 论再生产等       无任何页码 → 不可重建，本脚本据实标 0%，不臆造

算法（偏移量投票）
------------------
1. 每页收集「独立数字行」候选（全文任意位置，页首/页尾/页中均可）。
2. 对每个 (页, 候选) 计算偏移 offset = pdf − candidate，用它投票。
3. 取得票数 ≥ 3 次的偏移集合；每页若某候选命中其中一个偏移，即采用该候选。
4. 合并为连续段（pdf 连续 且 印刷页连续），只保留长度 ≥ 3 的段。
5. 输出 pagemap_printed.json，含 pdf_to_printed / segments / coverage_pct。

只读 pages.jsonl，不改动任何既有语料文件。

用法：python3 mlm/tools/rebuild_pagemap.py
      MLM_CORPUS=/path/to/corpus python3 mlm/tools/rebuild_pagemap.py
"""
import json, re, os, collections

# 语料库在 .work/mlm-corpus（不入版本库），本脚本随书存放以便复现
CORPUS = os.environ.get('MLM_CORPUS') or os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    '.work', 'mlm-corpus')
SRC = os.path.join(CORPUS, 'pages.jsonl')
OUT = os.path.join(CORPUS, 'pagemap_printed.json')

NUM = re.compile(r'(?m)^[ \t　]*(\d{1,4})[ \t　]*$')


def candidates(text):
    out = []
    for m in NUM.finditer(text):
        v = int(m.group(1))
        if 0 < v <= 2000:
            out.append(v)
    return out


def resolve(pages):
    """返回 (pdf_to_printed dict, segments list)。"""
    pdfs = [r['page'] for r in pages]
    cands = [candidates(r['text']) for r in pages]

    # --- 1. 偏移投票 ---
    votes = collections.Counter()
    for pdf, cs in zip(pdfs, cands):
        for v in cs:
            votes[pdf - v] += 1

    # 候选偏移：票数最多的若干个，且每个至少 3 票
    ranked = [off for off, c in votes.most_common() if c >= 3]
    if not ranked:
        return {}, []

    # --- 2. 逐页采用：命中任一候选偏移的候选值，取最接近该页"主流"的 ---
    # 先用最大票偏移做种子，逐步吸收其它偏移（防止目录数字误判）
    accepted = []
    for off in ranked:
        cand = {pdf: [] for pdf in pdfs}
        for pdf, cs in zip(pdfs, cands):
            for v in cs:
                if pdf - v == off:
                    cand[pdf].append(v)
        if accepted:
            prev = accepted[-1]
            # 只接受与已有偏移互补的：未覆盖页占比
            covered = sum(1 for pdf in pdfs if cand[pdf])
            if covered < len(pdfs) * 0.05:
                break
        accepted.append(off)

    # --- 3. 逐页定值 ---
    assigned = {}
    for pdf, cs in zip(pdfs, cands):
        best = None
        for off in accepted:
            for v in cs:
                if pdf - v == off:
                    # 同一页多个候选时取最小偏移优先（正文页页脚唯一）
                    best = v if best is None else min(best, v)
                    break
            if best is not None:
                break
        if best is not None:
            assigned[pdf] = best

    # --- 3b. 锚点间线性填充 ---
    # 若相邻两锚点满足 (pdf2-pdf1) == (pr2-pr1)，则中间缺失页可按同一偏移补齐。
    # 这修掉了「该页 OCR 没吐出数字行」造成的空洞（如《资本论》第三卷 907 页）。
    anchors = dict(assigned)
    filled = dict(anchors)
    ks = sorted(anchors)
    for i in range(len(ks) - 1):
        a, b = ks[i], ks[i + 1]
        dpdf, dpr = b - a, anchors[b] - anchors[a]
        if dpr <= 0 or dpdf <= 1:
            continue
        if dpdf == dpr:
            for pdf in range(a + 1, b):
                filled[pdf] = anchors[a] + (pdf - a)
        elif dpdf > dpr:
            # 中间允许有缺页：按印刷页等差补，只补前 dpr 个
            for k in range(1, dpr):
                pdf = a + k
                if pdf < b:
                    filled.setdefault(pdf, anchors[a] + k)
    assigned = filled

    # --- 4. 连续段 ---
    segs = []
    cur = None
    for pdf in pdfs:
        pr = assigned.get(pdf)
        if pr is None:
            cur = None
            continue
        if cur and pdf == cur[1] + 1 and pr == cur[3] + 1:
            cur[1], cur[3] = pdf, pr
            continue
        cur = [pdf, pdf, pr, pr]
        segs.append(cur)
    good = [s for s in segs if s[1] - s[0] >= 2]

    pdf2pr = {}
    for s in good:
        for pdf in range(s[0], s[1] + 1):
            pdf2pr[pdf] = s[2] + (pdf - s[0])
    return pdf2pr, good


def main():
    by = collections.defaultdict(list)
    for line in open(SRC, encoding='utf-8'):
        d = json.loads(line)
        by[d['book']].append(d)

    out = {}
    print(f"{'书':<46} {'页':>5} {'有页码':>6} {'段':>4} {'覆盖':>6}  段示例")
    print('-' * 110)
    for book, pages in sorted(by.items(), key=lambda x: -len(x[1])):
        pages.sort(key=lambda r: r['page'])
        pdf2pr, segs = resolve(pages)
        total = len(pages)
        cov = len(pdf2pr) * 100 // max(1, total)
        out[book] = {
            'pdf_to_printed': {str(k): v for k, v in sorted(pdf2pr.items())},
            'segments': segs,
            'coverage_pct': cov,
            'pages': total,
        }
        ex = ''
        if segs:
            s = max(segs, key=lambda x: x[1] - x[0])
            ex = f"pdf{s[0]}-{s[1]}→印刷{s[2]}-{s[3]}"
        print(f"{book[:44]:<46} {total:>5} {len(pdf2pr):>6} {len(segs):>4} {cov:>5}%  {ex}")
    json.dump(out, open(OUT, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f'\n写出 {OUT}（{len(out)} 本）')


if __name__ == '__main__':
    main()
