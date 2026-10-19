#!/usr/bin/env python3
"""第 10 章 · 回放与差分：读 JSONL trace，校验结构、按记录重放、对比两次运行。

三条边界写死在代码里：

1. 回放只读记录，**不执行任何工具**；没有 ``--allow-side-effects`` 这种开关；
2. 副作用工具的结果只能来自 trace 里的 ``app.tool.result``；
3. 结构错误（断链、重复 span_id、负时长、子 span 越出父 span）不静默修复，只报告。

用法：

    python3 replay.py --trace /tmp/t.jsonl              # 校验 + 重放
    python3 replay.py --trace /tmp/t.jsonl --check      # 只校验结构
    python3 replay.py --diff a.jsonl b.jsonl            # 差分；有差异退出码 1
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import dataclass, field
from typing import Any

REQUIRED = ("trace_id", "span_id", "name", "kind", "start_unix_nano",
            "duration_ms", "status", "attributes")
CONTAINMENT_TOLERANCE_MS = 2.0


class TraceError(Exception):
    pass


# -- 读取与索引 -------------------------------------------------------------

def load(path: str) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    spans: list[dict[str, Any]] = []
    logs: list[dict[str, Any]] = []
    with open(path, encoding="utf-8") as fh:
        for lineno, line in enumerate(fh, 1):
            line = line.strip()
            if not line:
                continue
            try:
                rec = json.loads(line)
            except json.JSONDecodeError as exc:
                raise TraceError(f"{path}:{lineno}: 不是合法 JSON：{exc}") from exc
            if rec.get("type") == "span":
                missing = [k for k in REQUIRED if k not in rec]
                if missing:
                    raise TraceError(f"{path}:{lineno}: span 缺字段 {missing}")
                spans.append(rec)
            elif rec.get("type") == "log":
                logs.append(rec)
            else:
                raise TraceError(f"{path}:{lineno}: 未知记录类型 {rec.get('type')!r}")
    if not spans:
        raise TraceError(f"{path}: 没有 span 记录")
    return spans, logs


def start_ms(span: dict[str, Any]) -> float:
    return span["start_unix_nano"] / 1e6


def end_ms(span: dict[str, Any]) -> float:
    return start_ms(span) + float(span["duration_ms"])


def children_map(spans: list[dict[str, Any]]) -> dict[str | None, list[dict[str, Any]]]:
    ids = {s["span_id"] for s in spans}
    out: dict[str | None, list[dict[str, Any]]] = {}
    for s in spans:
        parent = s.get("parent_span_id") if s.get("parent_span_id") in ids else None
        out.setdefault(parent, []).append(s)
    for kids in out.values():
        kids.sort(key=lambda s: (s["start_unix_nano"], s["span_id"]))
    return out


def short(span_id: str | None) -> str:
    return (span_id or "-")[:8]


# -- 结构校验 ---------------------------------------------------------------

@dataclass
class Integrity:
    traces: int = 0
    spans: int = 0
    roots: int = 0
    linked_roots: int = 0
    orphan_spans: list[str] = field(default_factory=list)
    orphan_roots: list[str] = field(default_factory=list)
    duplicate_ids: list[str] = field(default_factory=list)
    negative_durations: list[str] = field(default_factory=list)
    containment_violations: list[str] = field(default_factory=list)
    problems: list[str] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.problems

    def as_dict(self) -> dict[str, Any]:
        return {
            "traces": self.traces,
            "spans": self.spans,
            "roots": self.roots,
            "linked_roots": self.linked_roots,
            "orphan_spans": len(self.orphan_spans),
            "orphan_roots": len(self.orphan_roots),
            "duplicate_span_ids": len(self.duplicate_ids),
            "negative_durations": len(self.negative_durations),
            "containment_violations": len(self.containment_violations),
            "status": "ok" if self.ok else "broken",
            "problems": self.problems,
        }


def check_integrity(spans: list[dict[str, Any]]) -> Integrity:
    rep = Integrity(spans=len(spans))
    by_trace: dict[str, list[dict[str, Any]]] = {}
    for s in spans:
        by_trace.setdefault(s["trace_id"], []).append(s)
    rep.traces = len(by_trace)

    seen: set[str] = set()
    for s in spans:
        if s["span_id"] in seen:
            rep.duplicate_ids.append(s["span_id"])
            rep.problems.append(f"重复 span_id {short(s['span_id'])}（{s['name']}）")
        seen.add(s["span_id"])

    for s in spans:
        if float(s["duration_ms"]) < 0:
            rep.negative_durations.append(s["span_id"])
            rep.problems.append(
                f"负时长 {short(s['span_id'])}（{s['name']}）duration_ms={s['duration_ms']}")
        parent_id = s.get("parent_span_id")
        if not parent_id:
            continue
        parent = next((p for p in by_trace[s["trace_id"]] if p["span_id"] == parent_id), None)
        if parent is None:
            rep.orphan_spans.append(s["span_id"])
            rep.problems.append(
                f"孤儿 span {short(s['span_id'])}（{s['name']}）的 parent "
                f"{short(parent_id)} 不在同一 trace")
            continue
        if start_ms(s) < start_ms(parent) - CONTAINMENT_TOLERANCE_MS:
            rep.containment_violations.append(s["span_id"])
            rep.problems.append(
                f"子 span 早于父 span {short(s['span_id'])}（{s['name']}）"
                f"Δparent={start_ms(s) - start_ms(parent):+.0f}ms")
        if end_ms(s) > end_ms(parent) + CONTAINMENT_TOLERANCE_MS:
            rep.containment_violations.append(s["span_id"])
            rep.problems.append(
                f"子 span 晚于父 span 结束 {short(s['span_id'])}（{s['name']}）"
                f"Δend={end_ms(s) - end_ms(parent):+.0f}ms")

    for trace_id, group in by_trace.items():
        roots = [s for s in group if not s.get("parent_span_id")]
        rep.roots += len(roots)
        rep.linked_roots += sum(1 for r in roots if r.get("links"))
        for root in roots:
            if root.get("links"):
                continue
            if root["kind"] != "run":
                rep.orphan_roots.append(root["span_id"])
                rep.problems.append(
                    f"trace {trace_id[:12]}… 的根是 {root['name']}（kind={root['kind']}），"
                    f"没有 run span，也没有 link")
    return rep


# -- 重放 -------------------------------------------------------------------

def replay(spans: list[dict[str, Any]]) -> dict[str, Any]:
    """按记录重放：只读 app.decision / app.tool.result，不调用任何工具实现。"""
    by_trace: dict[str, list[dict[str, Any]]] = {}
    for s in spans:
        by_trace.setdefault(s["trace_id"], []).append(s)
    run_traces = [t for t, group in by_trace.items()
                  if any(s["kind"] == "run" for s in group)]
    if not run_traces:
        return {"status": "no_run", "reason": "没有含 run span 的 trace"}
    if len(run_traces) > 1:
        return {"status": "ambiguous", "reason": f"{len(run_traces)} 个 trace 都含 run span"}

    trace_id = run_traces[0]
    group = by_trace[trace_id]
    kids = children_map(group)
    run_span = next(s for s in group if s["kind"] == "run")
    steps = sorted((s for s in group if s["kind"] == "step"),
                   key=lambda s: int(s["attributes"].get("app.step.index", 0)))

    by_id = {s["span_id"]: s for s in group}

    def step_index(span: dict[str, Any]) -> int:
        cur: dict[str, Any] | None = span
        while cur is not None:
            if cur["kind"] == "step":
                return int(cur["attributes"].get("app.step.index", 0))
            cur = by_id.get(cur.get("parent_span_id") or "")
        return 0

    # 决策在前、工具执行在后（可能落进下一步），所以按时间顺序配对，
    # 而不是假设 tool 与 decision 同一个 step。
    pending: list[dict[str, Any]] = []
    actions: list[dict[str, Any]] = []
    missing: list[str] = []
    ordered = sorted(group, key=lambda s: (s["start_unix_nano"], s["span_id"]))
    for span in ordered:
        attrs = span["attributes"]
        if span["kind"] == "llm":
            decision = attrs.get("app.decision") or {}
            if decision.get("tool"):
                pending.append({"step": step_index(span), "tool": decision["tool"]})
        elif span["kind"] == "tool":
            name = attrs.get("gen_ai.tool.name")
            if pending and pending[0]["tool"] == name:
                want = pending.pop(0)
                actions.append({
                    "step": want["step"],
                    "tool": name,
                    "source": "record",
                    "ok": bool(attrs.get("app.tool.ok", True)),
                    "side_effect": attrs.get("app.tool.side_effect"),
                    "idempotency_key": attrs.get("app.tool.idempotency_key"),
                    "from_span": short(span["span_id"]),
                    "result": attrs.get("app.tool.result"),
                })
            else:
                actions.append({
                    "step": step_index(span),
                    "tool": name,
                    "source": "record_unmatched",
                    "ok": bool(attrs.get("app.tool.ok", True)),
                    "side_effect": attrs.get("app.tool.side_effect"),
                    "idempotency_key": attrs.get("app.tool.idempotency_key"),
                    "from_span": short(span["span_id"]),
                    "result": attrs.get("app.tool.result"),
                })
    for want in pending:
        missing.append(f"step {want['step']}: {want['tool']} 没有对应的 tool span（断链）")

    recorded_tools = [s for s in group if s["kind"] == "tool"]
    unexpected = [s["name"] for s in recorded_tools
                  if s["attributes"].get("gen_ai.tool.name") not in
                  {a["tool"] for a in actions}]
    answer = run_span["attributes"].get("app.answer")
    status = "incomplete" if missing else "replayed"
    return {
        "status": status,
        "trace_id": trace_id,
        "steps": len(steps),
        "tool_calls": len(actions),
        "tools_executed": 0,
        "side_effects": 0,
        "results": actions,
        "unexpected_tool_spans": unexpected,
        "missing": missing,
        "answer": answer,
        "answer_source": "span attribute app.answer",
    }


# -- 差分 -------------------------------------------------------------------

def flatten(spans: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """把森林压成带路径的列表；路径只由名字与同名次序构成，跨运行可对齐。"""
    kids = children_map(spans)
    roots = kids.get(None, [])
    nodes: list[dict[str, Any]] = []

    def walk(span: dict[str, Any], path: str, depth: int) -> None:
        nodes.append({"path": path, "depth": depth, "span": span})
        counter: dict[str, int] = {}
        for kid in kids.get(span["span_id"], []):
            nth = counter.get(kid["name"], 0)
            counter[kid["name"]] = nth + 1
            walk(kid, f"{path}/{kid['name']}#{nth}", depth + 1)

    counter = {}
    for root in roots:
        nth = counter.get(root["name"], 0)
        counter[root["name"]] = nth + 1
        walk(root, f"{root['name']}#{nth}", 0)
    return nodes


def _fingerprint(span: dict[str, Any]) -> dict[str, Any]:
    attrs = span["attributes"]
    return {
        "trace": span["trace_id"][:12],
        "parent": short(span.get("parent_span_id")),
        "dur_ms": round(float(span["duration_ms"]), 1),
        "status": span["status"],
        "tool": attrs.get("gen_ai.tool.name", ""),
        "ok": attrs.get("app.tool.ok", ""),
        "propagation": attrs.get("app.propagation", ""),
        "skew_ms": attrs.get("app.clock.offset_ms", ""),
    }


def diff_traces(baseline: list[dict[str, Any]],
                candidate: list[dict[str, Any]]) -> dict[str, Any]:
    a = {n["path"]: n for n in flatten(baseline)}
    b = {n["path"]: n for n in flatten(candidate)}
    removed = [p for p in a if p not in b]
    added = [p for p in b if p not in a]
    changed: list[tuple[str, dict[str, Any], dict[str, Any]]] = []
    for path in a:
        if path not in b:
            continue
        fa, fb = _fingerprint(a[path]["span"]), _fingerprint(b[path]["span"])
        deltas = {k: (fa[k], fb[k]) for k in fa if fa[k] != fb[k]}
        if deltas:
            changed.append((path, deltas, a[path]["span"]))
    return {
        "baseline": {"spans": len(baseline), "traces": len({s["trace_id"] for s in baseline})},
        "candidate": {"spans": len(candidate), "traces": len({s["trace_id"] for s in candidate})},
        "removed": [{"path": p, "span": a[p]["span"]} for p in removed],
        "added": [{"path": p, "span": b[p]["span"]} for p in added],
        "changed": [{"path": p, "deltas": d} for p, d, _ in changed],
    }


def render_diff(result: dict[str, Any], baseline_path: str,
                candidate_path: str, stream: Any = sys.stdout) -> None:
    stream.write(f"--- {baseline_path}\n+++ {candidate_path}\n")
    for item in result["removed"]:
        s = item["span"]
        stream.write(f"- {item['path']}  trace={s['trace_id'][:12]}  "
                     f"parent={short(s.get('parent_span_id'))}  "
                     f"dur={float(s['duration_ms']):.0f}ms  {s['status']}\n")
    for item in result["added"]:
        s = item["span"]
        stream.write(f"+ {item['path']}  trace={s['trace_id'][:12]}  "
                     f"parent={short(s.get('parent_span_id'))}  "
                     f"dur={float(s['duration_ms']):.0f}ms  {s['status']}\n")
    for item in result["changed"]:
        fields = "  ".join(f"{k}: {v[0]}→{v[1]}" for k, v in item["deltas"].items())
        stream.write(f"~ {item['path']}  {fields}\n")
    base, cand = result["baseline"], result["candidate"]
    stream.write(f"removed={len(result['removed'])} added={len(result['added'])} "
                 f"changed={len(result['changed'])}  "
                 f"spans {base['spans']}→{cand['spans']}  "
                 f"traces {base['traces']}→{cand['traces']}\n")


# -- CLI --------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="第 10 章回放与差分")
    p.add_argument("--trace", metavar="PATH", help="单个 JSONL trace")
    p.add_argument("--check", action="store_true", help="只做结构校验")
    p.add_argument("--replay", action="store_true", help="只做记录重放")
    p.add_argument("--diff", nargs=2, metavar=("BASELINE", "CANDIDATE"),
                   help="对比两份 trace；有差异时退出码 1")
    p.add_argument("--json", action="store_true", help="输出 JSON")
    p.add_argument("--allow-side-effects", action="store_true",
                   help="（被设计拒绝）本工具永不执行工具")
    return p


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    if args.allow_side_effects:
        print("拒绝：回放不执行任何工具。要重做副作用，请在沙箱里用幂等键显式重跑。",
              file=sys.stderr)
        return 2
    if args.diff:
        try:
            base, _ = load(args.diff[0])
            cand, _ = load(args.diff[1])
        except (OSError, TraceError) as exc:
            print(f"error: {exc}", file=sys.stderr)
            return 2
        result = diff_traces(base, cand)
        if args.json:
            payload = {
                "baseline": result["baseline"],
                "candidate": result["candidate"],
                "removed": [i["path"] for i in result["removed"]],
                "added": [i["path"] for i in result["added"]],
                "changed": [{"path": i["path"], "deltas": i["deltas"]}
                            for i in result["changed"]],
            }
            print(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True))
        else:
            render_diff(result, args.diff[0], args.diff[1])
        return 1 if (result["removed"] or result["added"] or result["changed"]) else 0

    if not args.trace:
        build_parser().print_help()
        return 2
    try:
        spans, logs = load(args.trace)
    except (OSError, TraceError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    rep = check_integrity(spans)
    do_check = args.check or not args.replay
    do_replay = args.replay or not args.check
    replay_result = replay(spans) if do_replay else None

    if args.json:
        payload: dict[str, Any] = {"integrity": rep.as_dict(), "logs": len(logs)}
        if replay_result is not None:
            payload["replay"] = replay_result
        print(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True))
    else:
        if do_check:
            print(f"integrity: traces={rep.traces} spans={rep.spans} roots={rep.roots} "
                  f"linked_roots={rep.linked_roots} status={'ok' if rep.ok else 'broken'}")
            print(f"  orphan_spans={len(rep.orphan_spans)} "
                  f"orphan_roots={len(rep.orphan_roots)} "
                  f"duplicate={len(rep.duplicate_ids)} "
                  f"negative_duration={len(rep.negative_durations)} "
                  f"containment={len(rep.containment_violations)}")
            for problem in rep.problems:
                print(f"  ! {problem}")
        if replay_result is not None:
            r = replay_result
            print(f"replay: status={r['status']} trace={str(r.get('trace_id', ''))[:12]}… "
                  f"steps={r.get('steps', 0)} tool_calls={r.get('tool_calls', 0)} "
                  f"tools_executed=0 side_effects=0")
            for action in r.get("results", []):
                print(f"  step {action['step']}  {action['tool']:<14} "
                      f"<- record  ok={str(action['ok']).lower()}  "
                      f"effect={action['side_effect']}  span={action['from_span']}")
            for miss in r.get("missing", []):
                print(f"  ! {miss}")
            if r.get("answer"):
                print(f"  answer: {r['answer']}")
                print("  answer_source: span attribute app.answer（不是重新生成）")
    # 结构错误 → 退出码 1；重放依赖结构，broken 时不假装成功
    return 0 if rep.ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
