#!/usr/bin/env python3
"""Read-only mechanical verification of project capture evidence; no audit claim."""
import csv
import hashlib
import json
import math
import pathlib
import re
import statistics
import sys

PROJECT = pathlib.Path(__file__).resolve().parents[1]
EVIDENCE = PROJECT / "evidence"


def hashes(archive, current=False):
    rows = {}
    for line in (archive / "source-sha256.txt").read_text().splitlines():
        digest, name = line.split("  ", 1)
        snapshot = archive / "source-snapshot" / name
        assert hashlib.sha256(snapshot.read_bytes()).hexdigest() == digest, snapshot
        if current:
            assert hashlib.sha256((PROJECT / name).read_bytes()).hexdigest() == digest, name
        rows[name] = digest
    return rows


def raw_samples(run):
    groups = {}
    for name in ["admission", "lifecycle"]:
        for row in csv.DictReader((run / f"{name}.csv").open()):
            groups.setdefault(row["case"], []).append(row)
    assert len(groups) == 4
    summary = {r["case"]: r for r in csv.DictReader((run / "statistics.csv").open())}
    for case, rows in groups.items():
        assert sorted(int(r["index"]) for r in rows) == list(range(21))
        operations = 100000 if case == "admission-full" else 8
        expected = 100000 if case == "admission-full" else 7596343361303360080
        assert all(int(r["operations"]) == operations and int(r["checksum"]) == expected for r in rows)
        values = [int(r["batch_ns"]) / operations for r in rows]
        ordered = sorted(values)
        calculated = [statistics.mean(values), statistics.stdev(values), ordered[math.ceil(21 * .5) - 1], ordered[math.ceil(21 * .99) - 1]]
        fields = ["mean", "sd_n_minus_1", "p50_nearest_rank", "p99_nearest_rank"]
        for field, value in zip(fields, calculated):
            assert abs(float(summary[case][field]) - value) <= .000501, (case, field)
    return sum(map(len, groups.values()))


def validation(archive):
    tests = reports = races = 0
    for profile in ["debug", "release"]:
        for index in range(1, 11):
            log = (archive / f"{profile}-tests-{index}.txt").read_text()
            assert "test result: FAILED" not in log
            for count in [2, 14]:
                assert f"test result: ok. {count} passed; 0 failed" in log
            assert log.count("test result: ok. 2 passed; 0 failed") == 2
            assert "cli_reports_outcomes_and_exit_codes ... ok" in log
            assert "intended_standard_stream_inheritance_still_hits_drain_grace ... ok" in log
            tests += 18
        for index in range(1, 6):
            log = (archive / f"{profile}-stress-{index}.txt").read_text()
            assert "reports=80 unexpected_failures=0" in log
            lines = [line for line in log.splitlines() if line.startswith("runtime=")]
            assert len(lines) == 80
            identities = set()
            for line in lines:
                match = re.match(r"runtime=(\d+) index=(\d+) ToolResult \{ outcome: (\w+),", line)
                assert match, line
                runtime, index, outcome = match.groups()
                runtime, index = int(runtime), int(index)
                identities.add((runtime, index))
                assert outcome == ("TimedOut" if index == 0 else "Cancelled" if index == 1 else "Success")
                assert "reaped: true" in line and "cleanup_error: None" in line
                assert line.count("eof: true, error: None") == 2
                if index >= 2:
                    assert line.count("total: 262144") == 2
            assert identities == {(r, i) for r in range(8) for i in range(10)}
            reports += len(lines)
        race = archive / f"{profile}-race"
        statuses = (race / "status.txt").read_text().splitlines()
        assert len(statuses) == 4 and all(line.endswith("exit=0") for line in statuses)
        for mode in ["logs", "sleep"]:
            for pipe in [1, 2]:
                gate = race / f"{mode}-pipe{pipe}"
                ready = (gate / "ready").read_text()
                assert "api=pipe2" in ready and ready.count("flags=1") == 2
                pid = (gate / "observed-descendant.pid").read_text().strip()
                listing = (gate / "lsof.txt").read_text()
                assert any(line.split()[1] == pid for line in listing.splitlines()[1:])
                for line in listing.splitlines()[1:]:
                    fields = line.split()
                    if "PIPE" in fields:
                        match = re.match(r"(\d+)", fields[3])
                        assert not match or int(match[1]) <= 2, line
                report = (gate / "report.txt").read_text()
                assert "reaped: true" in report and "cleanup_error: None" in report
                assert report.count("eof: true") == 2 and "error: Some(" not in report
                races += 1
    return {"test_executions": tests, "stress_reports": reports, "adversarial_cases": races}


def main():
    final = EVIDENCE / "run-04"
    final_hashes = hashes(final, current=True)
    repeated = EVIDENCE / "capture-fix-final-validation-02"
    assert hashes(repeated, current=True) == final_hashes
    assert len(list((final / "native").iterdir())) == 6
    for name in ["agent_runtime", "runtime_bench"]:
        for suffix in ["mir", "ll", "s"]:
            assert (final / "native" / f"{name}.{suffix}").stat().st_size > 1000
    assert "16777216" in (final / "native/agent_runtime.ll").read_text()
    assert "pipe_cloexec" in (final / "native/agent_runtime.mir").read_text()
    assert "posix_spawn" in (final / "macos-sample.txt").read_text()
    assert "Log6record" in (final / "macos-sample.txt").read_text()
    old = hashes(EVIDENCE / "run-02")
    assert len(old) == 12
    preservation = json.loads((EVIDENCE / "run-01/pre-capture-fix-preservation.json").read_text())
    assert sum(row["snapshot_preserved"] for row in preservation) == 8
    for row in preservation:
        if row["snapshot_preserved"]:
            source = EVIDENCE / "run-01/source-snapshot" / row["path"]
            assert hashlib.sha256(source.read_bytes()).hexdigest() == row["manifest_sha256"]
    result = validation(repeated)
    result.update({"final_source_files": len(final_hashes), "final_raw_observations": raw_samples(final), "retained_pilot_raw_observations": raw_samples(EVIDENCE / "run-03"), "run02_snapshots": len(old), "run01_available_snapshots": 8, "run01_unavailable_historical_sources": 3, "status": "mechanical verification only, not independent audit"})
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, OSError) as error:
        sys.exit(str(error) or "evidence assertion failed")
