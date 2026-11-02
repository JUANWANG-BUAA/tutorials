#!/usr/bin/env python3
"""Prepare the work order for the next independent audit round.

It never writes a verdict: the gate requires two independent reviewers, and
anything this script produced would be a self-review, not an audit. What it
does produce is the exact list an external reviewer needs — every technical
anchor with its evidence path, the sections the previous rounds never covered,
and the files that changed since the audited snapshot was frozen.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

from audit_snapshot import ROOT, make_snapshot

HEADING = re.compile(r"^##\s+(?P<title>.+?)\s*\{#(?P<anchor>sec-cpp-rust\.\d+\.\d+\.\d+)\}\s*$")
HAN = re.compile(r"[一-鿿]")


def part_of(chapter: int) -> int:
    return 1 if chapter <= 4 else 2 if chapter <= 8 else 3 if chapter <= 12 else 4


def section_inventory() -> list[dict]:
    """Every technical anchor in the book, with the file and line a reviewer opens."""
    rows: list[dict] = []
    for chapter in range(1, 18):
        part = part_of(chapter)
        page = ROOT / f"src/part{part}/ch{chapter:02}.md"
        if not page.is_file():
            continue
        lines = page.read_text().splitlines()
        for index, line in enumerate(lines):
            match = HEADING.match(line)
            if not match:
                continue
            body: list[str] = []
            for follow in lines[index + 1 :]:
                if follow.startswith("## "):
                    break
                body.append(follow)
            rows.append(
                {
                    "anchor": match.group("anchor"),
                    "title": match.group("title"),
                    "file": f"src/part{part}/ch{chapter:02}.md",
                    "line": index + 1,
                    "han": len(HAN.findall("\n".join(body))),
                    "chapter": chapter,
                }
            )
    return rows


def audited_anchors() -> set[str]:
    covered: set[str] = set()
    for report in sorted((ROOT / "sources/audits").glob("round*-audit.json")):
        data = json.loads(report.read_text())
        covered.update(s.get("anchor", "") for s in data.get("sections", []))
    return covered


def changed_since_frozen(current: dict[str, str]) -> tuple[list[str], int]:
    """只比较当前评审集合内部的变化。

    冻结快照取自更早的文件选择规则（当时把构建产物也算进去了），整体文件数因此
    不可比；报告时只给出当前评审集合内的真实内容差异，另外单独说明被新规则排除
    的旧文件数，免得评审者被上千个构建产物条目淹没。
    """
    frozen_path = ROOT / "sources/audit-snapshot.json"
    if not frozen_path.is_file():
        return [], 0
    frozen = json.loads(frozen_path.read_text())["files"]
    changed = sorted(n for n in current if frozen.get(n) != current[n])
    dropped = len(set(frozen) - set(current))
    return changed, dropped


def main() -> int:
    snapshot = make_snapshot(ROOT)
    sections = section_inventory()
    covered = audited_anchors()
    changed, dropped = changed_since_frozen(snapshot["files"])
    packet = {
        "schema": 1,
        "kind": "work-order",
        "note": (
            "这是给独立评审者的工作单，不是审计结论。本文件不进入审计台账，"
            "也不满足发布门禁的两轮独立审计要求。"
        ),
        "snapshot_sha256": snapshot["sha256"],
        "snapshot_files": len(snapshot["files"]),
        "sections_total": len(sections),
        "sections_never_audited": [s["anchor"] for s in sections if s["anchor"] not in covered],
        "changed_since_frozen_snapshot": changed,
        "frozen_only_files_excluded_by_current_rules": dropped,
        "sections": sections,
    }
    path = ROOT / "sources/audits/pending-round3-packet.json"
    path.write_text(json.dumps(packet, ensure_ascii=False, indent=2) + "\n")
    print(
        f"audit work order written: {len(sections)} sections, "
        f"{len(packet['sections_never_audited'])} never audited, "
        f"{len(changed)} normative files changed since the frozen snapshot "
        f"({dropped} frozen-only files excluded by the current file-selection rules)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
