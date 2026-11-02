#!/usr/bin/env python3
"""Render the complete source-disposition ledger and enforce substantive release gates."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import html
from collections import Counter
from pathlib import Path
from typing import Any

from merge_source_reviews import load_rows, safe_evidence, validate_book
from verify_audits import audit_problems

ROOT = Path(__file__).resolve().parents[1]
Row = dict[str, Any]
DECIDED = {"read-mapped", "excluded-reviewed"}


# 正文全书统一用直角引号；台账里少量母本题名带弯引号，渲染时只换引号字符，
# 不改一个字的内容（2026-11-01 排版统一，见写作规范本轮量尺重校准记录）。
QUOTE_MAP = str.maketrans({
    "“": "「", "”": "」",
    "‘": "『", "’": "』",
})


def cell(value: Any) -> str:
    """Escape source titles for Markdown tables without interpreting embedded HTML."""
    return (html.escape(str(value), quote=False).replace("|", "\\|").replace("\n", " ")
            .translate(QUOTE_MAP))


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


def archive_problems(web: list[Row]) -> list[str]:
    """声明的本地归档必须真的存在，且与登记的指纹一致。

    台账曾出现「写了 archive 路径、文件却早已被清理」的情况：审计看起来有本地副本，
    实际一个字节都拿不出来。缺文件或有未解释的指纹漂移都算问题，必须在台账里写清。
    """
    problems: list[str] = []
    for row in web:
        archive = row.get("archive")
        if not archive:
            continue
        path = ROOT / archive
        if not path.is_file():
            problems.append(f'{row["id"]}: 声明的归档不存在 {archive}')
            continue
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        if digest != row.get("sha256") and not row.get("archive_note"):
            problems.append(
                f'{row["id"]}: 归档指纹与台账不一致且无 archive_note 说明 {archive}'
            )
    return problems


# 过期裁决：章写出来之后仍声称「某章尚不存在/待落点」的子句（写作规范/20「映射登记的回链类型」）。
STALE_PHRASES = ("尚不存在", "未制造 target", "待 ch14", "尚未存在", "等待相应正文落点")


def _claimed_pages(pages: Any) -> set[int]:
    """解析 pages 字段声明的物理页集合（只取括号注记之前的范围部分）。"""
    head = str(pages or "").split("（")[0].split("(")[0]
    found: set[int] = set()
    for m in re.finditer(r"(\d+)\s*[–\-—~]\s*(\d+)", head):
        found.update(range(int(m.group(1)), int(m.group(2)) + 1))
    for m in re.finditer(r"\d+", re.sub(r"\d+\s*[–\-—~]\s*\d+", "", head)):
        found.add(int(m.group(0)))
    return found


def _note_pages(pages: Any) -> set[int]:
    """解析括号注记里点名的页码（含 N–M 区间），用于核对 excluded 页是否写明。"""
    text = str(pages or "")
    note = text.split("（", 1)[1] if "（" in text else ""
    found: set[int] = set()
    for m in re.finditer(r"(\d+)\s*[–\-—~]\s*(\d+)", note):
        found.update(range(int(m.group(1)), int(m.group(2)) + 1))
    for m in re.finditer(r"\d+", re.sub(r"\d+\s*[–\-—~]\s*\d+", "", note)):
        found.add(int(m.group(0)))
    return found


def _unit_spans(book: Row) -> dict[str, tuple[int, int, str]]:
    """单元页跨度：pdf_page 是起始页，覆盖到下一个不同起始页之前一页。"""
    units = sorted(
        (u for u in book["units"] if u.get("pdf_page")),
        key=lambda u: (u["pdf_page"], u.get("unit_id", "")),
    )
    spans: dict[str, tuple[int, int, str]] = {}
    i = 0
    while i < len(units):
        j = i
        while j + 1 < len(units) and units[j + 1]["pdf_page"] == units[i]["pdf_page"]:
            j += 1
        start = units[i]["pdf_page"]
        end = (
            units[j + 1]["pdf_page"] - 1
            if j + 1 < len(units)
            else (book.get("pdf_pages") or start)
        )
        for k in range(i, j + 1):
            spans[units[k]["unit_id"]] = (
                start,
                end,
                units[k].get("status", "unreviewed"),
            )
        i = j + 1
    return spans


def basis_problems(books: list[Row], web: list[Row], records: list[Row]) -> list[str]:
    """每条 read-mapped 映射必须说明「凭什么算已核读」，过期裁决一律判红。

    口径（写作规范/20「映射登记的回链类型」，2026-11-01 起强制）：
    逐单元记录靠 inventory 里 unit.record_id 回链自证；无回链的主题映射必须带
    `basis`——`pdf-unit` 要有 `units`（同源、read-mapped、页跨度与声明页相交，
    声明页里含 excluded-reviewed 单元的必须在注记写明），`online` 的 source 要能在
    web.json / contributions/*-web.json 对核，`artifact` 的 evidence 要在仓内。
    母本侧 reason/scope 不得留「某章尚不存在」这类过期裁决。
    """
    problems: list[str] = []
    by_unit: dict[str, Row] = {u["unit_id"]: b for b in books for u in b["units"]}
    backlinks = {
        u.get("record_id") for b in books for u in b["units"] if u.get("record_id")
    }
    web_ids = {w["id"] for w in web}
    for contrib in (ROOT / "sources" / "contributions").glob("*-web.json"):
        for item in json.loads(contrib.read_text()):
            if isinstance(item, dict) and item.get("id"):
                web_ids.add(str(item["id"]))
    for record in records:
        key = record["id"]
        if record.get("status") != "read-mapped":
            continue
        if key in backlinks:
            continue  # 逐单元记录：回链即说明
        basis = record.get("basis")
        if basis == "online":
            if record["source"] not in web_ids:
                problems.append(
                    f'{key}: online basis 的 source {record["source"]} 不在 web.json/contributions-*-web.json'
                )
            if record.get("units"):
                problems.append(f"{key}: online basis 不带 units")
            continue
        if basis == "artifact":
            evidence = str(record.get("evidence", ""))
            if not evidence or evidence.startswith("http") or not (ROOT / evidence).is_file():
                problems.append(f"{key}: artifact basis 的 evidence 不在仓内 {evidence}")
            continue
        if basis != "pdf-unit":
            problems.append(f"{key}: 无回链的主题映射缺 basis（{basis!r}）")
            continue
        units = record.get("units") or []
        if not units:
            problems.append(f"{key}: pdf-unit 缺 units")
            continue
        book = next((b for b in books if b["id"] == record["source"]), None)
        if not book or not book.get("pdf_pages"):
            problems.append(f"{key}: pdf-unit 的 source {record['source']} 无可核读页码")
            continue
        spans = _unit_spans(book)
        pages = _claimed_pages(record.get("pages"))
        if not pages:
            problems.append(f"{key}: pdf-unit 的 pages 无法解析出声明页")
            continue
        for uid in units:
            owner = by_unit.get(uid)
            if not owner or owner["id"] != record["source"]:
                problems.append(f"{key}: unit {uid} 不存在或不属于 source {record['source']}")
                continue
            start, end, state = spans[uid]
            if state != "read-mapped":
                problems.append(f"{key}: unit {uid} 状态为 {state}，不是 read-mapped")
            if end < min(pages) or start > max(pages):
                problems.append(f"{key}: unit {uid} 页跨度 {start}–{end} 与声明页不相交")
        excluded = {
            p
            for uid, (start, end, state) in spans.items()
            if state == "excluded-reviewed"
            for p in range(start, end + 1)
            if p in pages
        }
        if excluded:
            note = str(record.get("pages", "")).split("（", 1)
            note_text = note[1] if len(note) > 1 else ""
            named = _note_pages(record.get("pages"))
            missing = sorted(excluded - named)
            if missing or "excluded" not in note_text:
                problems.append(
                    f"{key}: 声明页含 excluded-reviewed 单元所在页 {sorted(excluded)}，注记未写明 {missing}"
                )
    for book in books:
        for unit in book["units"]:
            for field in ("reason", "scope", "review_note", "unresolved_reason"):
                text = unit.get(field)
                if isinstance(text, str) and any(p in text for p in STALE_PHRASES):
                    problems.append(
                        f'{unit.get("unit_id", book["id"])}: 过期裁决（{field}）仍含「{next(p for p in STALE_PHRASES if p in text)}」'
                    )
    for record in records:
        for field, text in record.items():
            if isinstance(text, str) and any(p in text for p in STALE_PHRASES):
                problems.append(
                    f'{record["id"]}: 过期裁决（{field}）仍含「{next(p for p in STALE_PHRASES if p in text)}」'
                )
    return problems


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
        f"16份母本，当前目录{len(units)}项；映射记录{len(sections)}条。十七章正文中，第 1–16 章逐节挂靠上述母本；第 17 章的存储结构、近似成员查询、内存回收与测量方法四处认领外部文献（见该章 17.9），但它的数字不来自任何文献，只来自 `projects/tidekv/results/run-01/`。",
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
        "来源裁决闭合不是发布认证。发布还要求17章正文、每章实验、三个项目（`agent-runtime`、`ffi-bridge`、`tidekv`）测试、代码生成/测量证据和连续两轮独立0 P0/P1。",
        "第 17 章是综合大项目：它的**数字**只来自自己的代码与证据包 `projects/tidekv/results/run-01/`，机制逐节回指第 1–16 章；它的**结构选择**认领 17.9 列出的外部文献（LSM、WiscKey、Bloom、Cuckoo Filter、HP/EBR/RCU、测量方法四篇），但没有登记为逐节母本映射。",
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
        archives = archive_problems(web)
        if archives:
            print("source archive check failed:")
            print("\n".join("  - " + p for p in archives[:25]))
            return 1
        link_problems = basis_problems(books, web, list(sections.values()))
        if link_problems:
            print("ledger basis check failed:")
            print("\n".join("  - " + p for p in link_problems[:25]))
            return 1
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
            chapters = [f for f in (ROOT / "src").glob("part*/ch*.md")
                        if re.fullmatch(r"ch\d{2}\.md", f.name)]
            if len(chapters) != 17:
                problems.append(f"only {len(chapters)}/17 chapter files")
            for project in ["agent-runtime", "ffi-bridge", "tidekv"]:
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
