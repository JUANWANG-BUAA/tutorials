"""Regression tests for immutable snapshots and genuine per-section audit gates."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent))
import merge_source_reviews as merging
from audit_snapshot import make_snapshot
from verify_audits import audit_problems, expected_sections, public_file


def save(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data))


@pytest.fixture
def reviewed(tmp_path: Path) -> Path:
    for chapter in range(1, 17):
        part = (chapter - 1) // 4 + 1
        page = tmp_path / f"src/part{part}/ch{chapter:02}.md"
        page.parent.mkdir(parents=True, exist_ok=True)
        page.write_text(
            "\n".join(
                f"## Section {section} {{#sec-cpp-rust.{part}.{chapter}.{section}}}"
                for section in range(1, 12)
            )
        )
    snapshot = make_snapshot(tmp_path)["sha256"]
    rounds = []
    for number in [1, 2]:
        report_name = f"sources/audits/r{number}.json"
        report = {
            "reviewer": f"separate-session-{number}",
            "kind": "independent",
            "snapshot_sha256": snapshot,
            "provenance": "isolated CLI run receipt",
            "sections": [
                {
                    "anchor": anchor,
                    "verdict": "pass",
                    "notes": "proof checked",
                    "evidence": "src/part1/ch01.md:1",
                }
                for anchor in sorted(expected_sections())
            ],
            "sources": [
                {
                    "id": f"S{i:02}",
                    "notes": "scope dispositions checked",
                    "evidence": "sources/reviews",
                }
                for i in range(1, 17)
            ],
            "findings": [],
        }
        save(tmp_path / report_name, report)
        rounds.append(
            {
                "round": number,
                "kind": "independent",
                "snapshot_sha256": snapshot,
                "P0": 0,
                "P1": 0,
                "reports": [report_name],
            }
        )
    save(tmp_path / "sources/independent-audits.json", rounds)
    return tmp_path


def test_two_complete_rounds(reviewed: Path) -> None:
    assert audit_problems(reviewed) == []


def test_edit_after_review_rejects_snapshot(reviewed: Path) -> None:
    (reviewed / "src/part1/ch01.md").write_text("changed after review")
    assert any("snapshot" in x for x in audit_problems(reviewed))


def test_summary_zero_cannot_hide_real_p1(reviewed: Path) -> None:
    path = reviewed / "sources/audits/r2.json"
    report = json.loads(path.read_text())
    report["findings"] = [{"severity": "P1", "id": "real-finding"}]
    save(path, report)
    assert any("actual findings" in x for x in audit_problems(reviewed))
    assert any("summary counts" in x for x in audit_problems(reviewed))


def test_missing_section_cannot_pass(reviewed: Path) -> None:
    path = reviewed / "sources/audits/r2.json"
    report = json.loads(path.read_text())
    report["sections"].pop()
    save(path, report)
    assert any("not independently reviewed" in x for x in audit_problems(reviewed))


def test_same_reviewer_reuse_rejected(reviewed: Path) -> None:
    path = reviewed / "sources/audits/r2.json"
    report = json.loads(path.read_text())
    report["reviewer"] = "separate-session-1"
    save(path, report)
    assert any("reviewer missing/reused" in x for x in audit_problems(reviewed))


def test_missing_provenance_rejected(reviewed: Path) -> None:
    path = reviewed / "sources/audits/r2.json"
    report = json.loads(path.read_text())
    del report["provenance"]
    save(path, report)
    assert any("provenance" in x for x in audit_problems(reviewed))


def test_unsupported_verdict_rejected(reviewed: Path) -> None:
    path = reviewed / "sources/audits/r2.json"
    report = json.loads(path.read_text())
    report["sections"][0]["notes"] = ""
    report["sections"][1]["verdict"] = "unchecked"
    save(path, report)
    assert any("unsupported section" in x for x in audit_problems(reviewed))
    assert any("invalid section" in x for x in audit_problems(reviewed))


def test_missing_source_scope_rejected(reviewed: Path) -> None:
    path = reviewed / "sources/audits/r2.json"
    report = json.loads(path.read_text())
    report["sources"] = []
    save(path, report)
    assert any("16-book" in x for x in audit_problems(reviewed))


def test_path_escape_rejected(tmp_path: Path) -> None:
    with pytest.raises(ValueError):
        public_file(tmp_path, "../not-public.json")


def test_round_gaps_and_missing_reports_rejected(reviewed: Path) -> None:
    path = reviewed / "sources/independent-audits.json"
    rounds = json.loads(path.read_text())
    rounds[1]["round"] = 4
    rounds[1]["reports"] = []
    save(path, rounds)
    assert any("not consecutive" in x for x in audit_problems(reviewed))
    assert any("no original" in x for x in audit_problems(reviewed))


def test_audit_files_and_volatile_logs_do_not_change_content_hash(
    reviewed: Path,
) -> None:
    before = make_snapshot(reviewed)
    (reviewed / "sources/audits/r1.json").write_text("updated reviewer notes")
    (reviewed / "bench/results").mkdir(parents=True)
    (reviewed / "bench/results/preview-check.txt").write_text("new validation log")
    assert make_snapshot(reviewed) == before


def test_required_immutable_data_does_change_hash(reviewed: Path) -> None:
    before = make_snapshot(reviewed)
    (reviewed / "bench/results").mkdir(parents=True)
    (reviewed / "bench/results/raw.csv").write_text("case,0,10.0\n")
    assert make_snapshot(reviewed) != before


def test_source_identity_and_native_units_cannot_be_erased(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(merging, "ROOT", tmp_path)
    evidence = tmp_path / "sources/reviews/S01.md"
    evidence.parent.mkdir(parents=True)
    evidence.write_text('<a id="scope"></a> rationale')
    original = {
        "id": "S01",
        "filename": "source.pdf",
        "sha256": "exact",
        "pdf_pages": 4,
        "units": [{"level": 1, "title": "Original section", "pdf_page": 2}],
    }
    proposal: dict[str, Any] = {
        **original,
        "units": [
            {
                "level": 1,
                "title": "Original section",
                "pdf_page": 2,
                "status": "excluded-reviewed",
                "evidence": "sources/reviews/S01.md#scope",
                "review_depth": "scope-only",
                "reason": "specific out-of-scope language syntax",
            }
        ],
    }
    merging.validate_book(original, proposal, {})
    with pytest.raises(ValueError, match="identity"):
        merging.validate_book(original, {**proposal, "sha256": "different"}, {})
    with pytest.raises(ValueError, match="deleted native"):
        merging.validate_book(original, {**proposal, "units": []}, {})
    proposal["units"][0]["pdf_page"] = 5
    with pytest.raises(ValueError, match="physical page"):
        merging.validate_book(original, proposal, {})


def test_mapping_needs_real_source_record_and_public_evidence(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(merging, "ROOT", tmp_path)
    evidence = tmp_path / "proof.md"
    evidence.write_text("real review")
    original = {
        "id": "S08",
        "filename": "book.pdf",
        "sha256": "same",
        "pdf_pages": 10,
        "units": [],
    }
    proposal: dict[str, Any] = {
        **original,
        "units": [
            {
                "title": "Item",
                "pdf_page": 3,
                "status": "read-mapped",
                "record_id": "r",
                "evidence": "proof.md",
                "review_depth": "body-sampled",
            }
        ],
    }
    with pytest.raises(ValueError, match="source-consistent"):
        merging.validate_book(original, proposal, {})
    merging.validate_book(original, proposal, {"r": {"source": "S08"}})
    proposal["units"][0]["evidence"] = "proof.md#invented-anchor"
    with pytest.raises(ValueError, match="anchor"):
        merging.validate_book(original, proposal, {"r": {"source": "S08"}})


def test_scope_exclusion_needs_reason_and_no_duplicate_unit_ids(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(merging, "ROOT", tmp_path)
    (tmp_path / "proof.md").write_text("read")
    original = {"id": "S16", "filename": "cmake.epub", "sha256": "same", "units": []}
    unit = {
        "unit_id": "S16-U001",
        "title": "Chapter",
        "xhtml": "EPUB/ch1.xhtml",
        "status": "excluded-reviewed",
        "evidence": "proof.md",
        "review_depth": "scope-only",
    }
    proposal = {**original, "units": [unit]}
    with pytest.raises(ValueError, match="rationale"):
        merging.validate_book(original, proposal, {})
    unit["reason"] = "out of declared scope"
    merging.validate_book(original, proposal, {})
    proposal["units"] = [unit, dict(unit)]
    with pytest.raises(ValueError, match="duplicate source unit"):
        merging.validate_book(original, proposal, {})


def test_conflicting_contribution_ids_are_not_last_writer_wins() -> None:
    with pytest.raises(ValueError, match="conflicting"):
        merging.merge_unique(
            [{"id": "r", "source": "S01"}], [{"id": "r", "source": "S02"}]
        )
    assert len(merging.merge_unique([{"id": "r"}], [{"id": "r"}])) == 1


def test_missing_ledger_or_single_round(tmp_path: Path) -> None:
    assert audit_problems(tmp_path)
    save(tmp_path / "sources/independent-audits.json", [{"round": 1}])
    assert audit_problems(tmp_path)
