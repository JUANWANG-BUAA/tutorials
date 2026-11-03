#!/usr/bin/env python3
"""Check the chapter 6/7/9 examples without requiring database or Kafka servers.

Extracts the published visibility and conditional-debit code and exercises it.
SQLite verifies the single-statement example, not PostgreSQL/InnoDB isolation.
"""

import re
import sqlite3
from pathlib import Path
from types import SimpleNamespace
from typing import Any

SRC = Path(__file__).resolve().parents[1] / "src"


def published_block(chapter: str, marker: str) -> str:
    """Find one Python block by its unique function or class marker."""
    content = (SRC / chapter).read_text(encoding="utf-8")
    matches = [block for block in re.findall(r"```python\n(.*?)\n```", content, re.S) if marker in block]
    if len(matches) != 1:
        raise ValueError(f"Expected one code block for {marker}; found {len(matches)}")
    return matches[0]


def verify_mvcc() -> None:
    """Run the actual simplified visibility function against two snapshots."""
    namespace: dict[str, Any] = {}
    exec(published_block("part3/ch06.md", "def visible("), namespace)
    visible = namespace["visible"]
    old = SimpleNamespace(xmin=100, xmax=105, xip={100, 102})
    new = SimpleNamespace(xmin=100, xmax=106, xip={100})
    committed_ids = {90}
    committed = committed_ids.__contains__
    for snapshot, expected in ((old, (True, False)),):
        assert (visible(90, 102, snapshot, 200, committed),
                visible(102, 0, snapshot, 200, committed)) == expected
    committed_ids.add(102)
    assert visible(90, 102, old, 200, committed)
    assert not visible(102, 0, old, 200, committed)
    assert not visible(90, 102, new, 200, committed)
    assert visible(102, 0, new, 200, committed)
    committed_ids.remove(102)
    assert visible(90, 102, new, 200, committed)
    assert not visible(102, 0, new, 200, committed)
    print("ch06: fixed/new snapshots and rollback verified against published code")


def verify_offsets() -> None:
    """Check every completion ordering, then the four rows in the chapter."""
    from itertools import permutations

    records = (100, 101, 102, 103)
    for order in permutations(records):
        completed: set[int] = set()
        for record in order:
            completed.add(record)
            safe = next((item for item in records if item not in completed), 104)
            assert all(item in completed for item in records if item < safe)
            if len(completed) < len(records):
                assert safe not in completed
    completed = set()
    safe_offsets = []
    for record in (102, 100, 103, 101):
        completed.add(record)
        safe_offsets.append(next((item for item in records if item not in completed), 104))
    assert safe_offsets == [100, 101, 101, 104]
    assert set(range(101, 104)) & {100, 102, 103} == {102, 103}
    print("ch07: all 24 completion orders, safe prefix and replay exercise verified")


def verify_fencing() -> None:
    """Execute the actual debit function and verify rollback on invalid writes."""
    namespace: dict[str, Any] = {}
    exec(published_block("part4/ch09.md", "class StaleToken"), namespace)
    debit, rejected = namespace["debit"], namespace["StaleToken"]
    with sqlite3.connect(":memory:") as conn:
        conn.execute("CREATE TABLE accounts (id TEXT PRIMARY KEY, balance_cents INTEGER NOT NULL, fence INTEGER NOT NULL)")
        conn.execute("INSERT INTO accounts VALUES ('acct-1',1000,40)")
        debit(conn, "acct-1", 100, 42)
        for token in (41, 42):
            try:
                debit(conn, "acct-1", 50, token)
            except rejected:
                pass
            else:
                raise AssertionError(f"Unexpected success for token {token}")
        for amount in (0, -100):
            try:
                debit(conn, "acct-1", amount, 43)
            except ValueError:
                pass
            else:
                raise AssertionError("Invalid amount accepted")
        assert conn.execute("SELECT fence,balance_cents FROM accounts").fetchone() == (42, 900)
        conn.execute("UPDATE accounts SET fence=40,balance_cents=1000")
        debit(conn, "acct-1", 100, 41)
        debit(conn, "acct-1", 100, 42)
        assert conn.execute("SELECT fence,balance_cents FROM accounts").fetchone() == (42, 800)
    print("ch09: strict-token ordering, equal-token rejection and input validation verified")


if __name__ == "__main__":
    verify_mvcc()
    verify_offsets()
    verify_fencing()
