#!/usr/bin/env python3
"""Render the complete source-disposition ledger and enforce substantive release gates."""

from __future__ import annotations

import argparse
import html
from collections import Counter
from pathlib import Path
from typing import Any

from merge_source_reviews import load_rows, safe_evidence, validate_book
from verify_audits import audit_problems

ROOT = Path(__file__).resolve().parents[1]
Row = dict[str, Any]
DECIDED = {"read-mapped", "excluded-reviewed"}


def cell(value: Any) -> str:
    """Escape source titles for Markdown tables without interpreting embedded HTML."""
    return html.escape(str(value), quote=False).replace("|", "\\|").replace("\n", " ")


def validate_records(
    books: list[Row], web: list[Row], code: list[Row], records: list[Row]
) -> dict[str, Row]:
    """Check actual target anchors and public evidence, not fabricated coverage totals."""
    known = {r["id"] for r in books + web + code}
    by_id: dict[str, Row] = {}
    for record in records:
        key = record["id"]
        if (
            key in by_id
            or record["source"] not in known
            or record["status"] != "read-mapped"
        ):
            raise ValueError(f"invalid/duplicate source mapping: {key}")
        target, anchor = record["target"].split("#", 1)
        page = safe_evidence("src/" + target)
        if "{#" + anchor + "}" not in page.read_text():
            raise ValueError(f"missing manuscript anchor: {record['target']}")
        safe_evidence(record["evidence"])
        by_id[key] = record
    return by_id


def source_obligations(books: list[Row], sections: dict[str, Row]) -> list[str]:
    """Count undisposed known units while retaining unknown-inventory obligations."""
    originals = {
        b["id"]: b for b in load_rows(ROOT / "sources/inventory-original.json")
    }
    problems: list[str] = []
    for book in books:
        if not book.get("section_inventory_complete") or not book["units"]:
            problems.append(f'{book["id"]}: chapter/section inventory not reconciled')
        try:
            validate_book(originals[book["id"]], book, sections)
        except (ValueError, KeyError) as exc:
            problems.append(str(exc))
        for unit in book["units"]:
            if unit.get("status") not in DECIDED:
                problems.append(
                    f'{book["id"]}: undisposed {unit.get("unit_id", unit["title"])}'
                )
    return problems


def render(
    books: list[Row],
    web: list[Row],
    code: list[Row],
    sections: dict[str, Row],
    findings: list[Row],
    obligations: list[str],
) -> str:
    """Publish all units, including justified exclusions and reading depth."""
    units = [u for b in books for u in b["units"]]
    counts = Counter(u.get("status", "unreviewed") for u in units)
    unresolved = sum(n for state, n in counts.items() if state not in DECIDED)
    incomplete = sum(not b.get("section_inventory_complete") for b in books)
    lines = [
        "# 母本逐节覆盖与范围裁决",
        "",
        f"16份母本，当前目录{len(units)}项；映射记录{len(sections)}条。",
        f"已知未裁决条目 **{unresolved}**；目录仍待完善的母本 **{incomplete}**。",
        "",
        "**覆盖口径**：每个目录单元都有正文落点或有理由的范围排除；不等于逐字读完全部原书。",
        "`review_depth`区分目录/摘段范围核对、正文抽页、完整节或完整页阅读。",
        "按用户追加要求，C++语法/惯用法与ESP外设等非Rust主线内容可明确排除，但不能从台账删除。",
        "PDF为一基物理页；EPUB为XHTML定位。抽页、全文提取、内容核读、来源映射与独立审计是不同事实。",
        "",
        (
            "**来源范围仍未闭合。**"
            if obligations
            else "**全部已登记目录单元的范围裁决闭合；无未登记裁决缺口。**"
        ),
        "目录粒度、实际读页、索引限制与文本质量见各母本公开review证据；未知目录不冒充0缺口。",
        "",
        "## 母本清单",
        "",
        "|ID|文件|页/定位|目录项|已映射|范围排除|待裁决|",
        "|:--|:--|:--|--:|--:|--:|--:|",
    ]
    for book in books:
        count = Counter(u.get("status", "unreviewed") for u in book["units"])
        pending = sum(n for state, n in count.items() if state not in DECIDED)
        pagination = book.get("pdf_pages", "EPUB XHTML；无固定PDF页")
        lines.append(
            f'|{book["id"]}|{cell(book["filename"])}|{pagination}|{len(book["units"])}|{count["read-mapped"]}|{count["excluded-reviewed"]}|{pending}|'
        )
    lines += [
        "",
        "## 已核读与正文映射",
        "",
        "|母本节|标题|页/版本|状态|本书落点|证据|",
        "|:--|:--|:--|:--|:--|:--|",
    ]
    for record in sections.values():
        target = record["target"]
        lines.append(
            f'|{record["source"]}/{record["id"]}|{cell(record["section"])}|{cell(record["pages"])}|核读映射|[{cell(target)}](../{target})|`{cell(record["evidence"])}`|'
        )
    lines += ["", "## 全目录逐节裁决", ""]
    for book in books:
        lines += [
            f'### {book["id"]} · {cell(book["filename"])} {{#coverage-{book["id"].lower()}}}',
            "",
            "|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|",
            "|:--|:--|:--|:--|:--|:--|",
        ]
        for index, unit in enumerate(book["units"], 1):
            mapped_record = sections.get(unit.get("record_id", ""))
            target = mapped_record["target"] if mapped_record else "—"
            target_cell = f"[{cell(target)}](../{target})" if mapped_record else "—"
            location = unit.get(
                "pdf_page",
                unit.get("xhtml", unit.get("locator", unit.get("href", "未知"))),
            )
            depth = unit.get("review_depth", "未登记")
            state = unit.get("status", "unreviewed")
            evidence = unit.get("evidence", "未登记")
            reason = unit.get(
                "reason",
                unit.get(
                    "rationale", "正文映射见上表" if mapped_record else "尚未裁决"
                ),
            )
            identity = unit.get("unit_id", f'{book["id"]}-native-{index}')
            lines.append(
                f'|{identity}|{cell(unit["title"])}|{cell(location)}|{state} / {cell(depth)}|{target_cell}|`{cell(evidence)}`；{cell(reason)}|'
            )
        lines.append("")
    lines += [
        "## 网页与固定版本源码",
        "",
        "|来源|URL或文件|核读范围/指纹|",
        "|:--|:--|:--|",
    ]
    mapped = {r["source"] for r in sections.values()}
    for source in web:
        state = (
            "sections.json指定部分已核读"
            if source["id"] in mapped
            else "已抓取，核读未登记"
        )
        lines.append(
            f'|{source["id"]}|{cell(source["url"])}|{state}；`{source.get("sha256", "未登记")}`|'
        )
    for source in code:
        ranges = "、".join(f"{a}–{b}" for a, b in source["reviewed_ranges"])
        lines.append(
            f'|{source["id"]}|{source["crate"]}@{source["version"]}/{source["path"]}|{ranges}；`{source["sha256"]}`|'
        )
    lines += ["", "## 开放技术问题", ""]
    active = [f for f in findings if f.get("status") != "closed"]
    if not active:
        lines.append(
            "无登记中的开放问题；历史失败与修复证据仍保留。独立审计另有不可替代的门禁。"
        )
    for finding in active:
        lines.append(
            f'- **{finding["severity"]} / {finding["id"]}**：{cell(finding.get("finding", "未关闭"))}；证据 `{finding["evidence"]}`。'
        )
    lines += [
        "",
        "## 发布口径",
        "",
        "来源裁决闭合不是发布认证。发布还要求16章、每章实验、两个项目测试、代码生成/测量证据和连续两轮独立0 P0/P1。",
        "`python3 tools/build_coverage.py --strict`与`python3 tools/verify_all.py --release`分别验证来源/审计与完整执行链。",
        "",
    ]
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--strict", action="store_true")
    args = parser.parse_args()
    try:
        books = load_rows(ROOT / "sources/inventory.json")
        web = load_rows(ROOT / "sources/web.json")
        code = load_rows(ROOT / "sources/runtime-code.json")
        findings = load_rows(ROOT / "sources/open-findings.json")
        sections = validate_records(
            books, web, code, load_rows(ROOT / "sources/sections.json")
        )
        obligations = source_obligations(books, sections)
        content = render(books, web, code, sections, findings, obligations)
        (ROOT / "src/appendix/coverage.md").write_text(content)
        (ROOT / "COVERAGE.md").write_text(content.replace("](../", "](src/"))
        print(f"source mappings {len(sections)}; source obligations {len(obligations)}")
        if args.strict:
            problems = [
                f'open {f["severity"]}: {f["id"]}'
                for f in findings
                if f.get("status") != "closed" and f.get("severity") in {"P0", "P1"}
            ]
            problems.extend(obligations)
            chapters = list((ROOT / "src").glob("part*/ch*.md"))
            if len(chapters) != 16:
                problems.append(f"only {len(chapters)}/16 chapter files")
            for project in ["agent-runtime", "ffi-bridge"]:
                directory = ROOT / "projects" / project
                for name in ["Cargo.toml", "Cargo.lock", "README.md", "src/lib.rs"]:
                    if not (directory / name).is_file():
                        problems.append(f"project {project}: missing {name}")
                if not list((directory / "tests").glob("*.rs")):
                    problems.append(f"project {project}: no integration tests")
            problems.extend(audit_problems(ROOT))
            if problems:
                print(f"release rejected: {len(problems)} unresolved obligations")
                print("\n".join("  - " + p for p in problems[:25]))
                return 1
            print("source, deliverable and immutable independent-audit gates passed")
        return 0
    except (OSError, ValueError, TypeError, KeyError) as exc:
        print(f"coverage rejected: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
