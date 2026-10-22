#!/usr/bin/env python3
"""Validate two consecutive independent, whole-section audit rounds on this snapshot."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from audit_snapshot import ROOT, make_snapshot


def public_file(root: Path, name: str) -> Path:
    """Reject evidence escaping the deliverable tree."""
    path = (root / name).resolve()
    if not path.is_relative_to(root.resolve()) or not path.is_file():
        raise ValueError(f"missing/non-public evidence: {name}")
    return path


def expected_sections() -> set[str]:
    """The fixed sixteen-chapter writing contract has 176 technical sections."""
    return {
        f"sec-cpp-rust.{(chapter - 1) // 4 + 1}.{chapter}.{section}"
        for chapter in range(1, 17)
        for section in range(1, 12)
    }


def audit_problems(root: Path) -> list[str]:
    """Check coverage and findings, not just an author-supplied zero count."""
    path = root / "sources/independent-audits.json"
    if not path.is_file():
        return ["independent audit round ledger missing"]
    rounds: list[dict[str, Any]] = json.loads(path.read_text())
    if len(rounds) < 2:
        return ["two consecutive independent audit rounds not present"]
    current = make_snapshot(root)["sha256"]
    problems: list[str] = []
    for chapter in range(1, 17):
        part = (chapter - 1) // 4 + 1
        page = root / f"src/part{part}/ch{chapter:02}.md"
        body = page.read_text() if page.is_file() else ""
        for section in range(1, 12):
            if "{#" + f"sec-cpp-rust.{part}.{chapter}.{section}" + "}" not in body:
                problems.append(
                    f"chapter {chapter}: audited section {section} missing in actual manuscript"
                )
    reviewers: set[str] = set()
    previous_number = 0
    for entry in rounds[-2:]:
        number = int(entry.get("round", 0))
        if number <= previous_number or (
            previous_number and number != previous_number + 1
        ):
            problems.append("audit rounds are not consecutive")
        previous_number = number
        if (
            entry.get("kind") != "independent"
            or entry.get("snapshot_sha256") != current
        ):
            problems.append(f"round {number}: not independent/current-snapshot review")
        covered: set[str] = set()
        reviewed_sources: set[str] = set()
        finding_counts = {"P0": 0, "P1": 0}
        reports = entry.get("reports", [])
        if not reports:
            problems.append(f"round {number}: no original reviewer reports")
        for report_name in reports:
            try:
                report = json.loads(public_file(root, report_name).read_text())
                reviewer = report.get("reviewer", "")
                if not reviewer or reviewer in reviewers:
                    problems.append(f"round {number}: reviewer missing/reused")
                reviewers.add(reviewer)
                if (
                    report.get("kind") != "independent"
                    or report.get("snapshot_sha256") != current
                    or not report.get("provenance")
                ):
                    problems.append(f"{report_name}: provenance/snapshot missing")
                for section in report.get("sections", []):
                    if not section.get("notes") or not section.get("evidence"):
                        problems.append(f"{report_name}: unsupported section verdict")
                    if section.get("verdict") not in {"pass", "finding"}:
                        problems.append(f"{report_name}: invalid section verdict")
                    covered.add(section.get("anchor", ""))
                for source in report.get("sources", []):
                    if not source.get("notes") or not source.get("evidence"):
                        problems.append(
                            f"{report_name}: unsupported source-scope verdict"
                        )
                    reviewed_sources.add(source.get("id", ""))
                for finding in report.get("findings", []):
                    severity = finding.get("severity")
                    if severity in finding_counts:
                        finding_counts[severity] += 1
            except (OSError, ValueError, TypeError, KeyError) as exc:
                problems.append(f"{report_name}: {exc}")
        missing = expected_sections() - covered
        if missing:
            problems.append(
                f"round {number}: {len(missing)} sections not independently reviewed"
            )
        if {f"S{n:02}" for n in range(1, 17)} - reviewed_sources:
            problems.append(
                f"round {number}: 16-book scope ledger not independently checked"
            )
        if any(finding_counts.values()):
            problems.append(f"round {number}: actual findings {finding_counts}")
        if (
            entry.get("P0") != finding_counts["P0"]
            or entry.get("P1") != finding_counts["P1"]
        ):
            problems.append(
                f"round {number}: summary counts do not match original findings"
            )
    return problems


def main() -> int:
    try:
        problems = audit_problems(ROOT)
    except (OSError, ValueError, TypeError, KeyError) as exc:
        print(f"audit ledger invalid: {exc}")
        return 1
    if problems:
        print("independent audit gate rejected:\n- " + "\n- ".join(problems))
        return 1
    print(
        "two consecutive independent rounds cover all 176 sections, zero P0/P1, unchanged snapshot"
    )
    print(
        "Identity/provenance is recorded, not a cryptographic proof of reviewer independence."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
