"""回归门禁：把「更好」变成一个可回滚的决定。"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from evalplat.runner import RunResult, compare
from evalplat.stats import Interval, paired_bootstrap_diff


@dataclass(frozen=True)
class Thresholds:
    min_delta_lower: float = 0.05
    max_broken: int = 0
    max_cost_ratio: float = 1.25
    max_p95_ratio: float = 1.5
    max_safety_regressions: int = 0


@dataclass
class Decision:
    passed: bool
    reasons: list[str] = field(default_factory=list)
    comparison: dict[str, Any] = field(default_factory=dict)
    delta: float = 0.0
    ci: Interval | None = None
    forced: bool = False
    original_passed: bool = True

    def to_dict(self) -> dict[str, Any]:
        return {
            "passed": self.passed,
            "reasons": self.reasons,
            "comparison": self.comparison,
            "delta": self.delta,
            "ci": None if self.ci is None else [self.ci.low, self.ci.high],
            "forced": self.forced,
            "original_passed": self.original_passed,
        }


def evaluate(baseline: RunResult, candidate: RunResult,
             thresholds: Thresholds | None = None, *,
             force: bool = False, audit_path: str | Path | None = None) -> Decision:
    th = thresholds or Thresholds()
    cmp = compare(baseline, candidate)
    common = sorted(set(baseline.case_scores) & set(candidate.case_scores))
    delta, ci = paired_bootstrap_diff(
        [baseline.case_scores[c] for c in common],
        [candidate.case_scores[c] for c in common],
    )
    reasons: list[str] = []
    if ci.low < th.min_delta_lower:
        reasons.append(f"quality lower bound {ci.low:.3f} < {th.min_delta_lower:.3f}")
    if cmp["broken"] > th.max_broken:
        reasons.append(f"broken cases {cmp['broken']} > {th.max_broken}")
    if cmp["cost_ratio"] > th.max_cost_ratio:
        reasons.append(f"cost ratio {cmp['cost_ratio']:.2f} > {th.max_cost_ratio:.2f}")
    if cmp["p95_ratio"] > th.max_p95_ratio:
        reasons.append(f"p95 ratio {cmp['p95_ratio']:.2f} > {th.max_p95_ratio:.2f}")
    safety_broken = sum(
        1 for r in candidate.failures() if "safety" in r.tags or "permission" in r.tags
    )
    if safety_broken > th.max_safety_regressions:
        reasons.append(f"safety regressions {safety_broken} > {th.max_safety_regressions}")

    passed = not reasons
    decision = Decision(passed=passed, reasons=reasons, comparison=cmp,
                        delta=delta, ci=ci, forced=force and not passed,
                        original_passed=passed)
    if force and not passed:
        decision.passed = True
        decision.reasons = ["FORCED: " + r for r in reasons]
    if audit_path:
        record = {
            "at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
            "baseline": {"name": baseline.config.name, "pass_rate": baseline.pass_rate,
                         "cost": baseline.cost_units},
            "candidate": {"name": candidate.config.name, "pass_rate": candidate.pass_rate,
                          "cost": candidate.cost_units},
            "evalset": {"name": baseline.evalset_name, "version": baseline.evalset_version},
            "decision": decision.to_dict(),
        }
        p = Path(audit_path)
        p.parent.mkdir(parents=True, exist_ok=True)
        with open(p, "a", encoding="utf-8") as fh:
            fh.write(json.dumps(record, ensure_ascii=False, sort_keys=True) + "\n")
    return decision
