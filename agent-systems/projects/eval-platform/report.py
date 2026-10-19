#!/usr/bin/env python3
"""项目二 CLI：跑评估集、比较 baseline/candidate、输出报告与门禁决定。

用法：
    python3 report.py --suite tool-calling-v1 --runs 3
    python3 report.py --suite tool-calling-v1 --candidate v2 --json /tmp/report.json
    python3 report.py --suite tool-calling-v1 --gate --audit /tmp/audit.jsonl
"""
from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from evalplat.evalset import load_evalset  # noqa: E402
from evalplat.executor import build_registry  # noqa: E402
from evalplat.gate import evaluate  # noqa: E402
from evalplat.runner import RunConfig, run_suite  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--suite", default="tool-calling-v1")
    ap.add_argument("--runs", type=int, default=1, help="每个 case 的采样数")
    ap.add_argument("--candidate", default="retry", choices=["retry", "v2", "loose"])
    ap.add_argument("--gate", action="store_true")
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--audit", default=None)
    ap.add_argument("--json", default=None)
    args = ap.parse_args()

    path = HERE / "evalsets" / f"{args.suite}.jsonl"
    evalset = load_evalset(path, build_registry())
    baseline_cfg = RunConfig("baseline", retries=0, samples=args.runs)
    if args.candidate == "retry":
        cand_cfg = RunConfig("retry", retries=1, samples=args.runs)
    elif args.candidate == "v2":
        cand_cfg = RunConfig("v2", retries=1, tool_version="v2", samples=args.runs)
    else:
        cand_cfg = RunConfig("loose", strict=False, retries=0, samples=args.runs)

    baseline = run_suite(evalset, baseline_cfg)
    candidate = run_suite(evalset, cand_cfg)

    print(f"# 评估报告 · {evalset.name}@{evalset.version}")
    print()
    print("| run | pass rate | 95% Wilson | cost units | P95 ms | failures |")
    print("|:--|--:|:--|--:|--:|--:|")
    for r in (baseline, candidate):
        print(f"| {r.config.name} | {r.pass_rate:.1%} | {r.wilson()} | "
              f"{r.cost_units} | {r.p95_latency_ms:.0f} | {len(r.failures())} |")
    print()
    if candidate.failures():
        print("## 失败样本")
        print()
        print("| case | code | attempts | tags |")
        print("|:--|:--|--:|:--|")
        for rec in candidate.failures()[:12]:
            print(f"| {rec.case_id} | {rec.error_code} | {rec.attempts} | "
                  f"{', '.join(rec.tags)} |")
        print()

    decision = None
    if args.gate:
        decision = evaluate(baseline, candidate, force=args.force, audit_path=args.audit)
        print("## 门禁")
        print()
        print(f"- 结论：**{'PASS' if decision.passed else 'FAIL'}**"
              + ("（force）" if decision.forced else ""))
        print(f"- 配对差值：{decision.delta:+.3f}，95% CI "
              f"[{decision.ci.low:+.3f}, {decision.ci.high:+.3f}]")
        c = decision.comparison
        print(f"- fixed={c['fixed']} broken={c['broken']} "
              f"cost_ratio={c['cost_ratio']:.2f} p95_ratio={c['p95_ratio']:.2f}")
        for reason in decision.reasons:
            print(f"- {reason}")
        print()

    payload = {
        "suite": {"name": evalset.name, "version": evalset.version, "size": evalset.size},
        "baseline": {"config": asdict(baseline.config), "pass_rate": baseline.pass_rate,
                     "wilson": [baseline.wilson().low, baseline.wilson().high],
                     "cost": baseline.cost_units, "p95_ms": baseline.p95_latency_ms},
        "candidate": {"config": asdict(candidate.config), "pass_rate": candidate.pass_rate,
                      "wilson": [candidate.wilson().low, candidate.wilson().high],
                      "cost": candidate.cost_units, "p95_ms": candidate.p95_latency_ms},
        "decision": None if decision is None else decision.to_dict(),
    }
    if args.json:
        Path(args.json).write_text(json.dumps(payload, ensure_ascii=False, indent=2),
                                   encoding="utf-8")
        print(f"wrote {args.json}")
    return 0 if decision is None or decision.passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
