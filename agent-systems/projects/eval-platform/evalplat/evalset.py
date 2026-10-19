"""评估集：加载、校验、版本哈希、分层。"""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

from evalplat.registry import RegistryError, ToolRegistry


class EvalSetError(Exception):
    pass


@dataclass(frozen=True)
class Case:
    id: str
    tool: str
    args: dict[str, Any]
    expected: dict[str, Any]
    difficulty: str = "medium"
    tags: tuple[str, ...] = ()
    failure_mode: str = "none"

    def to_dict(self) -> dict[str, Any]:
        return {
            "id": self.id, "tool": self.tool, "args": self.args,
            "expected": self.expected, "difficulty": self.difficulty,
            "tags": list(self.tags), "failure_mode": self.failure_mode,
        }


@dataclass(frozen=True)
class EvalSet:
    name: str
    version: str
    cases: tuple[Case, ...]

    @property
    def size(self) -> int:
        return len(self.cases)

    def by_difficulty(self) -> dict[str, list[Case]]:
        out: dict[str, list[Case]] = {}
        for c in self.cases:
            out.setdefault(c.difficulty, []).append(c)
        return out

    def by_tag(self, tag: str) -> list[Case]:
        return [c for c in self.cases if tag in c.tags]


def canonical(cases: Iterable[Case]) -> bytes:
    rows = [c.to_dict() for c in cases]
    rows.sort(key=lambda r: r["id"])
    return json.dumps(rows, sort_keys=True, separators=(",", ":"),
                      ensure_ascii=False).encode("utf-8")


def load_evalset(path: str | Path, registry: ToolRegistry | None = None) -> EvalSet:
    p = Path(path)
    if not p.exists():
        raise EvalSetError(f"evalset not found: {p}")
    cases: list[Case] = []
    seen: set[str] = set()
    with open(p, encoding="utf-8") as fh:
        for lineno, line in enumerate(fh, 1):
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            try:
                raw = json.loads(line)
            except json.JSONDecodeError as exc:
                raise EvalSetError(f"{p}:{lineno}: invalid JSON: {exc}") from exc
            missing = {"id", "tool", "args", "expected"} - set(raw)
            if missing:
                raise EvalSetError(f"{p}:{lineno}: missing fields {sorted(missing)}")
            if raw["id"] in seen:
                raise EvalSetError(f"{p}:{lineno}: duplicate id {raw['id']}")
            seen.add(raw["id"])
            if registry is not None:
                try:
                    registry.validate(raw["tool"], raw["args"], scope="eval:run")
                except RegistryError as exc:
                    raise EvalSetError(f"{p}:{lineno}: {exc.code}: {exc.message}") from exc
            cases.append(Case(
                id=raw["id"], tool=raw["tool"], args=raw["args"],
                expected=raw["expected"],
                difficulty=raw.get("difficulty", "medium"),
                tags=tuple(raw.get("tags", [])),
                failure_mode=raw.get("failure_mode", "none"),
            ))
    if not cases:
        raise EvalSetError(f"{p}: empty evalset")
    version = hashlib.sha256(canonical(cases)).hexdigest()[:12]
    return EvalSet(name=p.stem, version=version, cases=tuple(cases))
