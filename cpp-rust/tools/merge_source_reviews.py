#!/usr/bin/env python3
"""Merge isolated reviewers' proposals without losing original source sections."""

from __future__ import annotations

import argparse
import json
from collections import Counter
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
Row = dict[str, Any]


def load_rows(path: Path) -> list[Row]:
    """Read an explicit array of records, never silently accept another schema."""
    value = json.loads(path.read_text())
    if not isinstance(value, list) or any(not isinstance(x, dict) for x in value):
        raise ValueError(f"expected record array: {path}")
    return value


def safe_evidence(name: str) -> Path:
    """A deliverable evidence pointer cannot depend on private .work data."""
    name, _, anchor = name.partition("#")
    path = (ROOT / name).resolve()
    if not path.is_relative_to(ROOT.resolve()) or not path.is_file():
        raise ValueError(f"missing/public evidence: {name}")
    if anchor:
        text = path.read_text()
        if f"{{#{anchor}}}" not in text and f'id="{anchor}"' not in text:
            raise ValueError(f"missing evidence anchor: {name}#{anchor}")
    return path


def unit_key(unit: Row) -> tuple[str, str]:
    """Titles and hierarchy preserve duplicate native directory entries."""
    return str(unit.get("level", 1)), " ".join(str(unit["title"]).split())


def validate_book(original: Row, proposed: Row, sections: dict[str, Row]) -> None:
    """Require exact source identity and explicit accounting for every native item."""
    for key in ["id", "filename", "sha256"]:
        if original[key] != proposed.get(key):
            raise ValueError(f'{original["id"]}: source identity changed: {key}')
    before = Counter(unit_key(u) for u in original["units"])
    after = Counter(unit_key(u) for u in proposed.get("units", []))
    missing = before - after
    if missing:
        raise ValueError(
            f'{original["id"]}: deleted native entries: {list(missing)[:5]}'
        )
    if not proposed.get("units"):
        raise ValueError(f'{original["id"]}: empty section inventory')
    unit_ids: set[str] = set()
    for index, unit in enumerate(proposed["units"], 1):
        unit.setdefault("unit_id", f'{original["id"]}-U{index:04}')
        if unit["unit_id"] in unit_ids:
            raise ValueError(f'duplicate source unit id: {unit["unit_id"]}')
        unit_ids.add(unit["unit_id"])
        if "pdf_pages" in original:
            page = unit.get("pdf_page")
            if not isinstance(page, int) or not 1 <= page <= original["pdf_pages"]:
                raise ValueError(f'{unit["unit_id"]}: invalid physical page {page}')
        else:
            if not any(unit.get(k) for k in ["xhtml", "locator", "href", "epub_locator"]):
                raise ValueError(f'{unit["unit_id"]}: EPUB locator missing')
        if unit.get("status") not in {
            "read-mapped",
            "excluded-reviewed",
            "unreviewed",
            "unresolved",
            "reviewed-unmapped",
        }:
            raise ValueError(f'{unit["unit_id"]}: unknown review status')
        if unit["status"] in {"unreviewed", "unresolved", "reviewed-unmapped"}:
            continue  # Truthful incomplete proposals can be integrated; release rejects them.
        safe_evidence(str(unit.get("evidence", "")))
        if not unit.get("review_depth"):
            raise ValueError(
                f'{unit["unit_id"]}: content-reading/scope-review depth not specified'
            )
        if unit["status"] == "excluded-reviewed" and not unit.get("reason"):
            raise ValueError(f'{unit["unit_id"]}: exclusion has no scope rationale')
        if unit["status"] == "read-mapped":
            record = sections.get(unit.get("record_id", ""))
            if record is None or record["source"] != original["id"]:
                raise ValueError(
                    f'{unit["unit_id"]}: missing source-consistent mapped record'
                )


def normalize_records(records: list[Row], namespace: str, books: list[Row], web: list[Row]) -> list[Row]:
    """Resolve exact declared source names/URLs and namespace non-unique book IDs.

    Some writers use the mother-book ID as `id` and its filename as `source`.
    Preserve their original proposal, but give each actual mapping its own ID.
    This does not infer reading depth, pages, target or evidence.
    """
    aliases = {b["filename"]: b["id"] for b in books}
    aliases.update({b["id"]: b["id"] for b in books})
    aliases.update({w["url"]: w["id"] for w in web})
    aliases.update({w["id"]: w["id"] for w in web})
    identifiers = Counter(r["id"] for r in records)
    book_ids = {b["id"] for b in books}
    normalized: list[Row] = []
    for index, original in enumerate(records, 1):
        row = dict(original)
        row["source"] = aliases.get(row["source"], row["source"])
        if row["id"] in book_ids or identifiers[row["id"]] > 1:
            row["id"] = f'{namespace.upper()}-{row["source"]}-{index:03}'
        row["contribution"] = f'sources/contributions/{namespace}.json#record-{index}'
        normalized.append(row)
    return normalized


def merge_unique(existing: list[Row], proposals: list[Row]) -> list[Row]:
    """Conflicting IDs are errors rather than last-writer-wins evidence loss."""
    by_id = {r["id"]: r for r in existing}
    for row in proposals:
        key = row["id"]
        if key in by_id and by_id[key] != row:
            raise ValueError(f"conflicting contribution id: {key}")
        by_id[key] = row
    return list(by_id.values())


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--apply", action="store_true", help="write only after all validation succeeds"
    )
    args = parser.parse_args()
    try:
        contributions = ROOT / "sources/contributions"
        sections = load_rows(ROOT / "sources/sections.json")
        web = load_rows(ROOT / "sources/web.json")
        books = load_rows(ROOT / "sources/inventory.json")
        book_proposals: list[Row] = []
        section_proposals: list[Row] = []
        section_batches: list[tuple[str, list[Row]]] = []
        web_proposals: list[Row] = []
        for path in sorted(contributions.glob("*.json")):
            if path.name.endswith("-inventory.json"):
                book_proposals.extend(load_rows(path))
            elif path.name.endswith("-web.json"):
                web_proposals.extend(load_rows(path))
            else:
                records = load_rows(path)
                if records and not all(
                    "target" in r and "source" in r for r in records
                ):
                    raise ValueError(f"unrecognized contribution records: {path}")
                section_batches.append((path.stem, records))
        web = merge_unique(web, web_proposals)
        for namespace, records in section_batches:
            section_proposals.extend(normalize_records(records, namespace, books, web))
        sections = merge_unique(sections, section_proposals)
        known_sources = {b["id"] for b in books} | {w["id"] for w in web}
        known_sources.update(
            r["id"] for r in load_rows(ROOT / "sources/runtime-code.json")
        )
        by_section = {r["id"]: r for r in sections}
        for record in sections:
            if (
                record["source"] not in known_sources
                or record["status"] != "read-mapped"
            ):
                raise ValueError(f'invalid source/status: {record["id"]}')
            target, anchor = record["target"].split("#", 1)
            page = safe_evidence("src/" + target)
            if "{#" + anchor + "}" not in page.read_text():
                raise ValueError(f'missing anchor: {record["target"]}')
            safe_evidence(record["evidence"])
        by_book = {b["id"]: b for b in books}
        seen: set[str] = set()
        for proposed in book_proposals:
            key = proposed["id"]
            if key in seen or key not in by_book:
                raise ValueError(f"duplicate/unknown book proposal: {key}")
            seen.add(key)
            validate_book(by_book[key], proposed, by_section)
            by_book[key] = proposed
        books = list(by_book.values())
        if args.apply:
            # No partial output is written until all cross-file checks above pass.
            for name, records in [
                ("inventory.json", books),
                ("sections.json", sections),
                ("web.json", web),
            ]:
                (ROOT / "sources" / name).write_text(
                    json.dumps(records, ensure_ascii=False, indent=2) + "\n"
                )
        pending = sum(
            u.get("status") not in {"read-mapped", "excluded-reviewed"}
            for b in books
            for u in b["units"]
        )
        print(
            f"validated {len(sections)} section records, {len(seen)} book proposals; {pending} undisposed entries"
        )
        print(
            "This checks evidence integrity, not whether the reviewer's reading claims are true."
        )
        return 0
    except (OSError, ValueError, TypeError, KeyError) as exc:
        print(f"merge rejected: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
