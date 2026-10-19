"""评估 runner：对评估集跑 N 次采样，产出可统计的记录。"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from evalplat.evalset import Case, EvalSet
from evalplat.executor import Executor, build_registry
from evalplat.stats import Interval, mean, percentile, wilson_interval


@dataclass(frozen=True)
class RunConfig:
    name: str
    strict: bool = True
    retries: int = 0
    fail_once: bool = True
    tool_version: str = "v1"
    timeout_ms: int = 500
    samples: int = 1


@dataclass
class Record:
    case_id: str
    sample: int
    ok: bool
    attempts: int
    latency_ms: int
    cost_units: int
    error_code: str | None
    difficulty: str
    tags: tuple[str, ...]


@dataclass
class RunResult:
    config: RunConfig
    evalset_name: str
    evalset_version: str
    records: list[Record] = field(default_factory=list)
    case_scores: dict[str, float] = field(default_factory=dict)

    @property
    def n_cases(self) -> int:
        return len(self.case_scores)

    @property
    def n_samples(self) -> int:
        return len(self.records)

    @property
    def pass_rate(self) -> float:
        return mean(list(self.case_scores.values())) if self.case_scores else 0.0

    @property
    def successes(self) -> int:
        # 以 case 为单位计成功；同一 case 的多次采样按「全过才算过」。
        return int(round(sum(self.case_scores.values())))

    def wilson(self) -> Interval:
        return wilson_interval(self.successes, self.n_cases)

    @property
    def cost_units(self) -> int:
        return sum(r.cost_units for r in self.records)

    @property
    def p95_latency_ms(self) -> float:
        return percentile([r.latency_ms for r in self.records], 95)

    def failures(self) -> list[Record]:
        return [r for r in self.records if not r.ok]


def _matches(actual: dict[str, Any] | None, expected: dict[str, Any]) -> bool:
    if actual is None:
        return False
    for key, want in expected.items():
        if key not in actual:
            return False
        got = actual[key]
        if isinstance(want, list):
            if got != want:
                return False
        elif got != want:
            return False
    return True


def solve_case(case: Case, executor: Executor, config: RunConfig) -> tuple[bool, Any]:
    args = dict(case.args)
    if not config.strict:
        # 模拟「宽松模式」：多传一个调试字段；strict schema 会拒绝。
        args["debug"] = True
    result = executor.call(case.tool, args)
    if not result.ok:
        return False, result
    return _matches(result.data, case.expected), result


def run_suite(evalset: EvalSet, config: RunConfig) -> RunResult:
    registry = build_registry(version=config.tool_version)
    executor = Executor(registry, retries=config.retries,
                        timeout_ms=config.timeout_ms, fail_once=config.fail_once)
    out = RunResult(config=config, evalset_name=evalset.name,
                    evalset_version=evalset.version)
    per_case: dict[str, list[bool]] = {}
    for case in evalset.cases:
        for sample in range(config.samples):
            ok, result = solve_case(case, executor, config)
            if ok:
                err = None
            elif getattr(result, "error", None):
                err = result.error.get("code")
            else:
                err = "EWRONG"
            out.records.append(Record(
                case_id=case.id, sample=sample, ok=ok,
                attempts=getattr(result, "attempts", 0),
                latency_ms=getattr(result, "latency_ms", 0) + 5,
                cost_units=getattr(result, "cost_units", 0),
                error_code=err, difficulty=case.difficulty, tags=case.tags,
            ))
            per_case.setdefault(case.id, []).append(ok)
    out.case_scores = {cid: (1.0 if all(v) else 0.0) for cid, v in per_case.items()}
    return out


def compare(baseline: RunResult, candidate: RunResult) -> dict[str, Any]:
    """按 case 配对，返回差值、失败类型与成本变化。"""
    common = sorted(set(baseline.case_scores) & set(candidate.case_scores))
    b = [baseline.case_scores[c] for c in common]
    c = [candidate.case_scores[c] for c in common]
    diffs = [cc - bb for bb, cc in zip(b, c)]
    return {
        "n": len(common),
        "delta": mean(diffs) if diffs else 0.0,
        "fixed": sum(1 for d in diffs if d > 0),
        "broken": sum(1 for d in diffs if d < 0),
        "cost_ratio": (candidate.cost_units / baseline.cost_units)
                      if baseline.cost_units else 1.0,
        "p95_ratio": (candidate.p95_latency_ms / baseline.p95_latency_ms)
                     if baseline.p95_latency_ms else 1.0,
    }
