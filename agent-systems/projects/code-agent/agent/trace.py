"""JSONL trace：每步一行，失败也要落盘。"""

from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any


class TraceWriter:
    def __init__(self, path: str | Path | None = None):
        self.path = Path(path).expanduser() if path else None
        self.records: list[dict[str, Any]] = []
        if self.path:
            self.path.parent.mkdir(parents=True, exist_ok=True)
            # 每次运行覆盖，避免把两次运行的 step 混在一起。
            self.path.write_text("", encoding="utf-8")

    def write(self, record: dict[str, Any]) -> None:
        self.records.append(record)
        if self.path:
            with open(self.path, "a", encoding="utf-8") as fh:
                fh.write(json.dumps(record, ensure_ascii=False, sort_keys=True) + "\n")

    def close(self) -> None:
        pass


def read_trace(path: str | Path) -> list[dict[str, Any]]:
    rows = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line:
                rows.append(json.loads(line))
    return rows
