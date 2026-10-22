#!/usr/bin/env python3
"""Hash the reviewable book/code/evidence, excluding audit reports and volatile checks."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
CODE_SUFFIXES = {".rs", ".py", ".sh", ".c", ".h", ".cpp", ".toml", ".lock", ".md"}
VOLATILE = (
    "preview-check",
    "release-gate",
    "verify-all",
    "final-check",
    "validation-current",
)


def digest_file(path: Path) -> str:
    """Return an exact byte digest without changing the file."""
    return hashlib.sha256(path.read_bytes()).hexdigest()


def review_files(root: Path) -> list[Path]:
    """Select normative content and immutable measurements, not build products."""
    files: set[Path] = set()
    for directory in ["src", "bench", "projects", "tools"]:
        for path in (root / directory).rglob("*"):
            if not path.is_file() or path.is_symlink():
                continue
            rel = path.relative_to(root)
            if any(
                part
                in {
                    "target",
                    "build",
                    "native-build",
                    "__pycache__",
                    ".git",
                    ".pytest_cache",
                }
                or part.endswith("-target")
                or part.startswith(("target-", "cmake-build"))
                for part in rel.parts
            ):
                continue
            if rel.as_posix() == "src/appendix/coverage.md":
                continue  # Derived verbatim from the separately hashed ledgers.
            if any(word in path.name for word in VOLATILE):
                continue
            if (
                "results" in rel.parts
                or "evidence" in rel.parts
                or rel.parts[0] == "src"
                or path.suffix in CODE_SUFFIXES
                or path.name == "CMakeLists.txt"
            ):
                files.add(path)
    for name in [
        "inventory.json",
        "inventory-original.json",
        "sections.json",
        "web.json",
        "runtime-code.json",
        "chapter-evidence.json",
        "open-findings.json",
    ]:
        path = root / "sources" / name
        if path.is_file():
            files.add(path)
    for path in (root / "sources/reviews").rglob("*"):
        if path.is_file():
            files.add(path)
    if (root / "book.toml").is_file():
        files.add(root / "book.toml")
    return sorted(files)


def make_snapshot(root: Path) -> dict[str, Any]:
    """Build a reproducible fingerprint; no timestamp affects the digest."""
    files = {str(p.relative_to(root)): digest_file(p) for p in review_files(root)}
    encoded = json.dumps(files, sort_keys=True, separators=(",", ":")).encode()
    return {"schema": 1, "sha256": hashlib.sha256(encoded).hexdigest(), "files": files}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    snapshot = make_snapshot(ROOT)
    path = ROOT / "sources/audit-snapshot.json"
    if args.write:
        chapters = list((ROOT / "src").glob("part*/ch*.md"))
        if len(chapters) != 16:
            parser.error("freeze requires all 16 real chapter files")
        path.write_text(json.dumps(snapshot, ensure_ascii=False, indent=2) + "\n")
    if args.check:
        previous = json.loads(path.read_text())
        if previous != snapshot:
            before, after = previous["files"], snapshot["files"]
            changed = sorted(
                k for k in set(before) | set(after) if before.get(k) != after.get(k)
            )
            print("audited snapshot changed:\n" + "\n".join(changed[:30]))
            return 1
    print(f'audit snapshot {snapshot["sha256"]}: {len(snapshot["files"])} files')
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
