#!/usr/bin/env python3
"""Render page-level evidence without equating an anchor to source coverage.

The ledger is intentionally incomplete while reading/writing proceeds.
Exit 1 for unresolved items or an incomplete source-section inventory.
Also updates edge/src/appendix/coverage.md for mdBook build.
"""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parent.parent


def main():
    data = json.loads((ROOT / 'evidence/source-ledger.json').read_text())
    
    # 1. Generate root COVERAGE.md
    lines = ['# 母本逐节覆盖台账', '',
             '**状态：尚未达到缺口 0。** 目录锚点存在不等于正文已正确吸收。', '',
             '页码统一为 PDF 文件物理页（1 起算），不推测纸书页码。', '',
             '## 来源清单', '',
             '| 来源 | 文件 | 页数 | SHA-256 | 逐节目录已完整核录 |',
             '|:--|:--|--:|:--|:--|']
    errors = []
    for source in data['sources']:
        lines.append(f"| {source['id']} | {source['filename']} | {source['pages']} | `{source['sha256']}` | {'是' if source['sections_complete'] else '否'} |")
        if not source['sections_complete']:
            errors.append(f"{source['id']}: 母本逐节目录尚未完整核录")
    lines += ['', '## 已录入节', '',
              '| 母本节 | 标题 | 页 | 状态 | 本书落点 | 证据 |',
              '|:--|:--|:--|:--|:--|:--|']
    
    app_rows = []
    keys = set()
    for item in data['sections']:
        key = (item['source'], item['section'])
        if key in keys:
            errors.append(f'duplicate source section: {key}')
        keys.add(key)
        target = item['landing']
        rel, anchor = target.split('#', 1)
        path = ROOT / 'src' / rel
        if not path.is_file() or ('{#' + anchor + '}') not in path.read_text():
            errors.append(f'absent exact landing: {target}')
        evidence = ROOT / item['evidence']
        if not evidence.is_file():
            errors.append(f'absent evidence: {evidence}')
        if item['status'] != '已抽页核读并落实':
            errors.append(f'unresolved: {key}')
        lines.append(f"| {item['source']} {item['section']} | {item['title']} | {item['pages']} | {item['status']} | [正文](src/{target}) | [{item['note']}]({item['evidence']}) |")
        app_rows.append(f"| {item['source']} {item['section']} | {item['title']} | {item['pages']} | {item['status']} | [正文](../{target}) | `{item['evidence']}` |")
        
    lines += ['', '## 未关闭门槛', ''] + ['- ' + e for e in errors]
    lines += ['', '当前仅追踪已录入单元；未录入来源节不计为已覆盖，更不能被自动排除以获得零缺口。',
              '全书审计要求仍为完整目录录入、逐章抽页、落点审查、实验和连续两轮独立审计。', '']
    (ROOT / 'COVERAGE.md').write_text('\n'.join(lines), encoding='utf-8')
    
    # 2. Generate edge/src/appendix/coverage.md
    app_lines = [
        '# 附录 A · 母本覆盖矩阵', '',
        '<div class="chapter-index">',
        '<div><span class="ci-label">本章回答</span><p>全书的微架构理论、汇编契约与硬件寄存器设计源自哪些权威经典母本？各章节的核心机制与母本具体物理页码如何建立位级对应证据？当前全书还有哪些未关闭的审计门槛？</p></div>',
        '<div><span class="ci-label">读完你会</span><p>建立全书 14 个核心章节与经典母本物理页码的精确溯源证据链；掌握严格的页级核验与工程落地标准；清晰认知当前未关闭项与后续独立技术审计路线。</p></div>',
        '</div>', '',
        '**状态：尚未达到缺口 0。** 目录锚点存在不等于正文已正确吸收。页码统一为 PDF 文件物理页（1 起算）。', '',
        '## A.1 来源清单与核读规范', '',
        '| 来源 | 文件 | 页数 | SHA-256 | 逐节目录已完整核录 |',
        '|:--|:--|--:|:--|:--|'
    ]
    for source in data['sources']:
        app_lines.append(f"| {source['id']} | {source['filename']} | {source['pages']} | `{source['sha256']}` | {'是' if source['sections_complete'] else '否'} |")
    app_lines += ['', '## A.2 母本逐节覆盖台账', '',
                  '| 母本节 | 标题 | 页 | 状态 | 本书落点 | 证据 |',
                  '|:--|:--|:--|:--|:--|:--|']
    app_lines += app_rows
    app_lines += ['', '## A.3 未关闭门槛与独立审计标准', ''] + ['- ' + e for e in errors]
    app_lines += ['', '当前仅追踪已录入单元；未录入来源节不计为已覆盖，更不能被自动排除以获得零缺口。',
                  '全书审计要求仍为完整目录录入、逐章抽页、落点审查、实验和连续两轮独立审计。', '']
    (ROOT / 'src/appendix/coverage.md').write_text('\n'.join(app_lines), encoding='utf-8')
    
    print(f'ledger: {len(data["sections"])} recorded, {len(errors)} unresolved gates')
    return bool(errors)


if __name__ == '__main__':
    raise SystemExit(main())
