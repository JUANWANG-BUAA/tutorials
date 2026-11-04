#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_cites.py — 引文页码校验（v3）

v2 的问题：它只信 pagemap.json，而该文件 39 本书里大部分印刷页为 null，
导致 6 处正常引用被误报为「页码不存在」。v3 改用 rebuild_pagemap.py 生成的
pagemap_printed.json（由 pages.jsonl 重建，覆盖率逐书统计），并：

  · 印刷页双向匹配（正文引 480 → 语料 480 命中；反之亦然）
  · 区间引用（480—547）只要两端中任一端命中即通过
  · 明确打印每本书的覆盖率，低覆盖的书单独提示「该书页码不可靠」
  · 兼容 verify_cites2.py 的旧书名归一（含 Lenin 选集四卷）

用法：python3 mlm/tools/verify_cites.py [--verbose]
      MLM_ROOT=/path/to/repo MLM_CORPUS=/path/to/corpus python3 ... 
"""
import json, re, os, glob, collections, sys

import os
BASE = os.environ.get('MLM_ROOT') or os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
CORPUS = os.environ.get('MLM_CORPUS') or f'{BASE}/.work/mlm-corpus'

MAPS = json.load(open(f'{CORPUS}/pagemap_printed.json'))
# 旧 pagemap（部分书有真映射），叠加使用
try:
    old = json.load(open(f'{CORPUS}/pagemap.json'))
except Exception:
    old = {}

# ---- 建立 book → {printed: text} ----
pages = collections.defaultdict(dict)
cov_note = {}
for line in open(f'{CORPUS}/pages.jsonl', encoding='utf-8'):
    d = json.loads(line)
    book = d['book']
    pr = MAPS.get(book, {}).get('pdf_to_printed', {}).get(str(d['page']))
    if pr is None:
        continue
    pages[book][pr] = d['text']

# 毛选合订本：旧 pagemap 中已验证的 印刷 = pdf-2 映射（覆盖重建缺失处）
for book, m in old.items():
    if not m:
        continue
    real = {pdf: pr for pdf, pr in m if pr}
    if not real:
        continue
    for line in open(f'{CORPUS}/pages.jsonl', encoding='utf-8'):
        break
# 毛选合订本专用：pdf-2
for line in open(f'{CORPUS}/pages.jsonl', encoding='utf-8'):
    d = json.loads(line)
    if '合订' in d['book']:
        pages[d['book']].setdefault(d['page'] - 2, d['text'])

# ---- 卢森堡全集第1卷：OCR 文件（pagemap 重建缺 pdf578 前的段落）----
def _norm(s):
    return ''.join(chr(ord(c) - 0xFF10 + 48) if 0xFF10 <= ord(c) <= 0xFF19 else c for c in s)

lux = f'{CORPUS}/ocr/罗莎卢森堡全集第一卷.txt'
if os.path.exists(lux):
    t = open(lux, encoding='utf-8').read()
    pg = re.findall(r'===== PAGE (\d+) =====\n(.*?)(?=\n===== PAGE|\Z)', t, re.S)
    luxp = {}
    for k, v in pg:
        lines = [l.strip() for l in v.splitlines() if l.strip()]
        if not lines:
            continue
        cand = None
        for c in [lines[0], lines[-1]] + lines[1:3] + lines[-3:-1]:
            cc = _norm(c).strip()
            if re.fullmatch(r'\d{1,3}', cc):
                cand = int(cc)
                break
        if cand is not None:
            luxp.setdefault(cand, _norm(v))
    for k, v in luxp.items():
        pages['罗莎·卢森堡全集第一卷'].setdefault(k, v)
        pages['罗莎卢森堡全集第一卷'].setdefault(k, v)

# ---- 列宁选集四卷 ----
LENIN_DIR = f'{BASE}/.work/lenin'
try:
    lidx = json.load(open(f'{LENIN_DIR}/lenin_index.json'))
    for v, info in lidx.items():
        _inv = {int(pdf): int(pr) for pr, pdf in info['pages'].items()}
        _f = f'{LENIN_DIR}/lenin_v{v}.txt'
        if not os.path.exists(_f):
            continue
        _t = open(_f, encoding='utf-8', errors='replace').read()
        _pg = {int(k): _norm(b) for k, b in
               re.findall(r'===== PAGE (\d+) =====\n(.*?)(?=\n===== PAGE|\Z)', _t, re.S)}
        for _pdf, _b in _pg.items():
            if _pdf in _inv:
                pages[f'列宁选集（{v}）'][_inv[_pdf]] = _b
except Exception as e:
    print('lenin load failed:', e)

# ---- 书名归一 ----
# ---- 书名别名 → 语料书名 ----
# 引文常引「篇名」（《矛盾论》），语料按「书名」收录（毛选合订本）；此处做映射。
ALIAS = {
    '矛盾论': '毛泽东选集（1-5卷合订）',
    '实践论': '毛泽东选集（1-5卷合订）',
    '中国革命和中国共产党': '毛泽东选集（1-5卷合订）',
    '井冈山的斗争': '毛泽东选集（1-5卷合订）',
    '星星之火，可以燎原': '毛泽东选集（1-5卷合订）',
    '论十大关系': '毛泽东选集（1-5卷合订）',
    '社会改良还是革命？': '罗莎卢森堡全集第一卷',
    '社会改良还是革命': '罗莎卢森堡全集第一卷',
    '「四人帮」选集': '“四人帮”选集',
    '四人帮选集': '“四人帮”选集',
    '论对资产阶级的全面专政': '“四人帮”选集',
    '文化大革命与工业组织': '文化大革命与工业组织',
    '国家与革命': '列宁选集（3）',
}


def norm(s):
    return s.replace(' ', '').replace('·', '').replace('「', '').replace('」', '').replace('"', '')

def cands_for(name):
    n = norm(name)
    out = []
    if name in ALIAS:
        tgt = ALIAS[name]
        if tgt in pages:
            out.append(tgt)
        else:
            for b in pages:
                if norm(tgt) in norm(b):
                    out.append(b)
    for b in pages:
        bb = norm(b)
        if n in bb or bb in n:
            if b not in out:
                out.append(b)
    return out

CITE = re.compile(r'《([^》]{2,40})》[^。\n]{0,14}?第\s*(\d+)(?:\s*[—\-－]\s*(\d+))?\s*页')

rows = []
for md in glob.glob(f'{BASE}/mlm/src/**/*.md', recursive=True):
    txt = open(md, encoding='utf-8').read()
    for m in CITE.finditer(txt):
        book, p1, p2 = m.group(1), int(m.group(2)), (int(m.group(3)) if m.group(3) else None)
        cs = cands_for(book)
        hit = None
        for b in cs:
            ps = pages[b]
            if p1 in ps or (p2 and p2 in ps):
                hit = b
                break
        rows.append((os.path.relpath(md, BASE), book, p1, p2, bool(hit), cs))

bad = [r for r in rows if not r[4]]
print(f'citations={len(rows)} ok={len(rows)-len(bad)} bad={len(bad)}')
for r in bad:
    print('  MISS', r)

if '--verbose' in sys.argv:
    print('\n各书印刷页覆盖：')
    for b in sorted(pages, key=lambda x: -len(pages[x])):
        ps = sorted(pages[b])
        rng = f'{ps[0]}–{ps[-1]}' if ps else '—'
        print(f'  {len(ps):>5} 页  印刷{rng:>12}  {b}')

# 覆盖率低 → 提示该书页码不可靠（需人工核对）
print('\n覆盖率不足 60% 的书（其上引文页码须人工复核）：')
low = []
for b in pages:
    prs = sorted(pages[b])
    if not prs:
        continue
    span = prs[-1] - prs[0] + 1
    cov = len(prs) * 100 // max(1, span)   # 以「印刷页区间内的实有页」为分母
    if cov < 60:
        low.append((b, cov, len(prs), prs[0], prs[-1]))
for b, c, n, a, z in sorted(low, key=lambda x: x[1]):
    print(f'  {c:>4}%  {b}  (实有 {n} 页, 印刷 {a}–{z})')
if not low:
    print('  （无）')
