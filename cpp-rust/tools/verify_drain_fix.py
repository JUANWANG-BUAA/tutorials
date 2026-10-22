#!/usr/bin/env python3
"""Verify preserved CLOEXEC race evidence; never infer a fix from rerun success alone."""
from __future__ import annotations

from collections import Counter
import hashlib
import json
from pathlib import Path
import re

from verify_evidence import verify_samples, verify_snapshot

ROOT = Path(__file__).resolve().parents[1]
RESULTS = ROOT / "bench/results/runtime-fixed"


def check_manifest(directory: Path, *, current: bool = False) -> None:
    """Require original bytes behind every archived experiment, and current fix bytes."""
    manifest = json.loads((directory / "source-hashes.json").read_text())
    for relative, expected in manifest.items():
        archived = directory / "source-snapshot" / relative
        if hashlib.sha256(archived.read_bytes()).hexdigest() != expected:
            raise ValueError(f"archived source changed: {archived}")
        if current and hashlib.sha256((ROOT / relative).read_bytes()).hexdigest() != expected:
            raise ValueError(f"current fix differs from validated source: {relative}")


def main() -> int:
    try:
        verify_snapshot(ROOT / "bench/results/runtime-final")
        for suite in ["baseline-debug", "baseline-release", "fixed-debug", "fixed-release"]:
            directory = RESULTS / suite
            check_manifest(directory)
            baseline = suite.startswith("baseline")
            statuses = (directory / "status.txt").read_text().splitlines()
            if len(statuses) != 4 or not all(line.endswith("exit=" + ("101" if baseline else "0")) for line in statuses):
                raise ValueError(f"wrong adversarial outcomes: {suite}")
            for mode in ["flood", "sleep"]:
                for pipe in [1, 2]:
                    case = directory / f"{mode}-pipe{pipe}"
                    report = (case / "report.txt").read_text()
                    descriptors = (case / "lsof.txt").read_text()
                    observed = re.search(r"gate: api=(\w+) pid=\d+ read_fd=\d+ flags=(\d+) write_fd=\d+ flags=(\d+)", report)
                    if observed is None:
                        raise ValueError(f"missing syscall flag observation: {case}")
                    if baseline:
                        if (observed.groups() != ("pipe", "0", "0") or "eof: false" not in report
                                or "drain grace expired" not in report or len(re.findall(r"\sPIPE\s", descriptors)) < 2):
                            raise ValueError(f"baseline does not establish descriptor leak: {case}")
                    elif (observed.groups() != ("pipe2", "1", "1") or "eof: false" in report
                          or "reader_errors: []" not in report or re.search(r"\sPIPE\s", descriptors)):
                        raise ValueError(f"fixed same-interleaving outcome incorrect: {case}")
        directory = RESULTS / "final-validation"
        check_manifest(directory, current=True)
        counts: Counter[str] = Counter()
        for profile in ["debug", "release"]:
            for run in range(1, 11):
                log = (directory / f"tests-{profile}-{run}.txt").read_text()
                if "test result: ok. 6 passed" not in log or "test result: ok. 12 passed" not in log or "FAILED" in log:
                    raise ValueError(f"parallel test run failed: {profile}/{run}")
            for run in range(1, 6):
                log = (directory / f"stress-{profile}-{run}.txt").read_text()
                rows = [line for line in log.splitlines() if line.startswith("round=")]
                if len(rows) != 80 or "unexpected_failures=0" not in log:
                    raise ValueError(f"incomplete structured stress: {profile}/{run}")
                for line in rows:
                    match = re.search(r"mode=(\w+)", line)
                    if match is None or not all(s in line for s in ["expected=true", "child_pid:", "pending_polls:", "dropped_after: Some("]):
                        raise ValueError("stress omitted lifecycle evidence")
                    counts[match[1]] += 1
        if counts != {"flood": 600, "sleep": 100, "inherit": 100}:
            raise ValueError(f"wrong stress coverage: {counts}")
        measured = RESULTS / "measurements-final"
        check_manifest(measured, current=True)
        raw = verify_samples(measured, {
            "scheduling.txt": {k: k for k in ["current-q16", "current-q1024", "multi4-q16", "multi4-q1024"]},
            "blocking-poll.txt": {"inline": "inline", "offload": "offload"},
            "process-rpc.txt": {"spawn": "spawn", "persistent": "persistent"},
            "pipe-drain.txt": {"prefix128": "prefix128", "retain-all": "retain-all"},
        })
        if raw != 210:
            raise ValueError(f"wrong new timing count: {raw}")
        artifacts = json.loads((RESULTS / "artifact-hashes.json").read_text())
        for relative, expected in artifacts.items():
            if hashlib.sha256((RESULTS / relative).read_bytes()).hexdigest() != expected:
                raise ValueError(f"diagnostic artifact changed: {relative}")
        print("CLOEXEC: 8 deterministic original failures / 8 fixed passes with FD evidence")
        print("final fix: 20 parallel test runs (360 test executions), 800 structured child reports, 210 timing observations")
        print("Original intermittent incident has insufficient telemetry for unique retrospective attribution.")
        print("This is engineering evidence, not independent audit or whole-platform correctness proof.")
        return 0
    except (OSError, ValueError, TypeError, KeyError, AssertionError) as exc:
        print(f"drain verification rejected: {exc}")
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
