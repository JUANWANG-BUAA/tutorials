#!/usr/bin/env python3
"""第 8 章实验：一个 supervisor + 两个 worker 的确定性多智能体内核。

它只演示四件事：共享预算账本的原子扣减、带 seq/correlation_id 的消息总线、
冲突投票与证据权重、以及失败时的熔断隔离。三种模式：

    normal      两个 worker 拿到不同来源，冲突由证据权重裁决
    groupthink  两个 worker 复制同一个错误，投票一致但证据单一
    runaway     两个 worker 互相等待确认，直到预算拒绝下一次发送

所有输出都由固定输入决定，不使用随机数、网络或真实模型。
"""

from __future__ import annotations

import argparse
import json
import threading
from collections import Counter, defaultdict
from dataclasses import dataclass
from typing import Any, Iterable


# ---------------------------------------------------------------------------
# 固定任务与证据表
# ---------------------------------------------------------------------------

TASK = {
    "task_id": "t-pay-timeout",
    "question": "支付 API 的超时时间是多少秒？",
    "canonical_ref": "doc/primary-2026",
    "canonical_claim": "10s",
}

EVIDENCE: dict[str, "Evidence"] = {}


@dataclass(frozen=True)
class Evidence:
    """一条可被引用的证据。weight 是三个维度的乘积，不是模型置信度。"""

    ref: str
    text: str
    answer: str
    trust: float          # 来源可信度：一手手册高，匿名博客低
    recency: float        # 时效：当前版本高，过期 runbook 低
    verifiability: float  # 可核验性：能回切原文高，转述低
    status: str           # current / superseded

    @property
    def weight(self) -> float:
        return self.trust * self.recency * self.verifiability


def _load_evidence() -> None:
    docs = [
        Evidence(
            ref="doc/primary-2026",
            text="支付 API 的超时时间是 10 秒；超时后返回 504，不自动重试。",
            answer="10s",
            trust=0.95,
            recency=1.0,
            verifiability=1.0,
            status="current",
        ),
        Evidence(
            ref="doc/secondary-2026",
            text="支付网关调用超时为 10s，客户端应使用同一个上限。",
            answer="10s",
            trust=0.80,
            recency=0.9,
            verifiability=0.9,
            status="current",
        ),
        Evidence(
            ref="doc/legacy-2024",
            text="旧版 runbook：支付 API 超时时间为 30 秒。（2025 年已废弃）",
            answer="30s",
            trust=0.25,
            recency=0.3,
            verifiability=0.6,
            status="superseded",
        ),
        Evidence(
            ref="doc/blog",
            text="某博客转述：把支付超时调到 30 秒可以少报错。",
            answer="30s",
            trust=0.10,
            recency=0.4,
            verifiability=0.2,
            status="unverified",
        ),
    ]
    for doc in docs:
        EVIDENCE[doc.ref] = doc


_load_evidence()

ENVELOPES = {"supervisor": 80, "worker-a": 110, "worker-b": 110}
TOTAL_BUDGET = 300


# ---------------------------------------------------------------------------
# 预算账本：检查与扣减必须在同一个临界区
# ---------------------------------------------------------------------------


class BudgetExhausted(RuntimeError):
    """预算不足。agent 是申请者，reason 是哪个额度先耗尽。"""

    def __init__(self, agent: str, reason: str, detail: str = "") -> None:
        self.agent = agent
        self.reason = reason
        self.detail = detail
        super().__init__(f"{agent}: {reason} {detail}".strip())


class BudgetLedger:
    """共享账本。try_spend 是唯一的扣减入口，锁内完成检查与扣减。"""

    def __init__(self, total: int, envelopes: dict[str, int]) -> None:
        if total < 0 or any(v < 0 for v in envelopes.values()):
            raise ValueError("budget must be non-negative")
        if sum(envelopes.values()) > total:
            raise ValueError("sum(child envelopes) must not exceed parent budget")
        self.total = total
        self.envelopes = dict(envelopes)
        self._used = {agent: 0 for agent in envelopes}
        self._spent = 0
        self._lock = threading.Lock()

    def try_spend(self, agent: str, tokens: int) -> bool:
        if agent not in self.envelopes:
            raise KeyError(f"unknown agent: {agent}")
        if tokens < 0:
            raise ValueError("tokens must be non-negative")
        with self._lock:
            if self._used[agent] + tokens > self.envelopes[agent]:
                return False
            if self._spent + tokens > self.total:
                return False
            self._used[agent] += tokens
            self._spent += tokens
            return True

    def spend(self, agent: str, tokens: int, reason: str = "") -> None:
        if tokens == 0:
            return
        if not self.try_spend(agent, tokens):
            left = self.envelopes.get(agent, 0) - self._used.get(agent, 0)
            raise BudgetExhausted(
                agent,
                "agent_envelope" if left < tokens else "global_budget",
                f"need={tokens} left={left}",
            )

    def snapshot(self) -> dict[str, Any]:
        with self._lock:
            return {
                "total": self.total,
                "spent": self._spent,
                "remaining": self.total - self._spent,
                "agents": {
                    agent: {
                        "limit": limit,
                        "used": self._used[agent],
                        "remaining": limit - self._used[agent],
                    }
                    for agent, limit in sorted(self.envelopes.items())
                },
            }


# ---------------------------------------------------------------------------
# 消息总线：seq、correlation_id、causation_id 与重复投递
# ---------------------------------------------------------------------------


class MessageBus:
    """把一次发送同时记账：消息成本从发送者额度扣，扣不动就不投递。

    seq 由总线在锁内分配，给同一 run 一个全序；causation_id 指向触发本消息的
    上一条消息，用来在异步拓扑里重建因果边。deliver 模拟消费者侧去重。
    """

    def __init__(self, ledger: BudgetLedger, max_messages: int = 40) -> None:
        self.ledger = ledger
        self.max_messages = max_messages
        self._messages: list[dict[str, Any]] = []
        self._delivered: set[str] = set()
        self._seq = 0
        self._lock = threading.Lock()

    @property
    def messages(self) -> list[dict[str, Any]]:
        with self._lock:
            return list(self._messages)

    def send(
        self,
        sender: str,
        recipient: str,
        kind: str,
        correlation_id: str,
        payload: dict[str, Any],
        *,
        refs: Iterable[str] = (),
        tokens: int = 0,
        causation_id: str | None = None,
    ) -> dict[str, Any]:
        with self._lock:
            if len(self._messages) >= self.max_messages:
                raise BudgetExhausted(sender, "message_budget", f"max={self.max_messages}")
            if tokens:
                self.ledger.spend(sender, tokens, reason=f"send:{kind}")
            self._seq += 1
            msg = {
                "msg_id": f"m{self._seq:03d}",
                "seq": self._seq,
                "sender": sender,
                "recipient": recipient,
                "kind": kind,
                "correlation_id": correlation_id,
                "causation_id": causation_id,
                "refs": list(refs),
                "tokens": tokens,
                "payload": payload,
            }
            self._messages.append(msg)
            return msg

    def emit_event(
        self,
        sender: str,
        recipient: str,
        kind: str,
        correlation_id: str,
        payload: dict[str, Any],
        *,
        causation_id: str | None = None,
    ) -> dict[str, Any]:
        """零成本审计事件。它不参与预算，也绕开消息数上限，只用于记录熔断。"""
        with self._lock:
            self._seq += 1
            msg = {
                "msg_id": f"m{self._seq:03d}",
                "seq": self._seq,
                "sender": sender,
                "recipient": recipient,
                "kind": kind,
                "correlation_id": correlation_id,
                "causation_id": causation_id,
                "refs": [],
                "tokens": 0,
                "payload": payload,
            }
            self._messages.append(msg)
            return msg

    def deliver(self, msg_id: str) -> bool:
        """返回 True 表示首次投递；重复投递返回 False，调用方不得再次执行副作用。"""
        with self._lock:
            if msg_id in self._delivered:
                return False
            self._delivered.add(msg_id)
            return True

    def to_jsonl(self, path: str) -> None:
        with open(path, "w", encoding="utf-8") as fh:
            for msg in self.messages:
                fh.write(json.dumps(msg, ensure_ascii=False, sort_keys=True) + "\n")


# ---------------------------------------------------------------------------
# 熔断器
# ---------------------------------------------------------------------------


class CircuitBreaker:
    """按 agent 熔断。失败达到阈值或预算耗尽时打开，阻止继续派活。"""

    def __init__(self, threshold: int = 2) -> None:
        self.threshold = threshold
        self.state = "closed"
        self._failures: Counter[str] = Counter()
        self._trips: list[dict[str, Any]] = []
        self._lock = threading.Lock()

    def allow(self, agent: str) -> bool:
        with self._lock:
            return self.state == "closed" or self._failures[agent] < self.threshold

    def record_failure(self, agent: str, reason: str) -> bool:
        with self._lock:
            self._failures[agent] += 1
            if self._failures[agent] >= self.threshold and self.state == "closed":
                self.state = "open"
                self._trips.append(
                    {"agent": agent, "reason": reason, "failures": self._failures[agent]}
                )
                return True
            return False

    def trip(self, agent: str, reason: str) -> None:
        with self._lock:
            self.state = "open"
            self._trips.append(
                {"agent": agent, "reason": reason, "failures": self._failures[agent]}
            )

    def reset(self) -> None:
        with self._lock:
            self.state = "closed"
            self._failures.clear()

    def snapshot(self) -> dict[str, Any]:
        with self._lock:
            return {
                "state": self.state,
                "failures": dict(sorted(self._failures.items())),
                "trips": list(self._trips),
            }


# ---------------------------------------------------------------------------
# 冲突：投票 + 证据权重
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class Finding:
    agent: str
    claim: str
    confidence: float
    refs: tuple[str, ...]
    basis: str


def claim_weight(finding: Finding) -> float:
    """主张权重 = 置信度 × 它所引用证据里最强的一条。"""
    weights = [EVIDENCE[ref].weight for ref in finding.refs if ref in EVIDENCE]
    if not weights:
        return 0.0
    return finding.confidence * max(weights)


def resolve(
    findings: list[Finding],
    *,
    canonical_ref: str = TASK["canonical_ref"],
    canonical_claim: str = TASK["canonical_claim"],
) -> dict[str, Any]:
    """先看票数，再看证据。多数票要求来源独立，否则只是同一错误的回声。"""
    votes = Counter(f.claim for f in findings)
    refs_by_claim: dict[str, set[str]] = defaultdict(set)
    for f in findings:
        refs_by_claim[f.claim].update(f.refs)
    distinct_refs = {ref for f in findings for ref in f.refs}
    scores = {
        claim: round(max(claim_weight(f) for f in findings if f.claim == claim), 4)
        for claim in votes
    }
    ranked = sorted(scores.items(), key=lambda item: (-item[1], item[0]))

    result: dict[str, Any] = {
        "votes": dict(sorted(votes.items())),
        "scores": dict(sorted(scores.items())),
        "distinct_refs": sorted(distinct_refs),
        "independent_sources": len(distinct_refs),
        "groupthink_suspected": False,
    }

    if len(votes) == 1:
        claim = next(iter(votes))
        if len(distinct_refs) >= 2:
            result.update(
                answer=claim,
                decision="majority",
                reason="unanimous_with_independent_sources",
            )
            return result
        # 全票但只有一个来源：检查是否被一手证据反驳。
        canonical = EVIDENCE[canonical_ref]
        cited_weak = all(
            ref != canonical_ref and EVIDENCE.get(ref, canonical).weight < 0.2
            for ref in distinct_refs
        )
        if cited_weak and canonical.status == "current":
            result.update(
                answer=canonical_claim,
                decision="evidence_override",
                reason="unanimous_but_single_low_trust_source",
                groupthink_suspected=True,
                audit={
                    "canonical_ref": canonical_ref,
                    "canonical_claim": canonical_claim,
                    "canonical_weight": round(canonical.weight, 4),
                    "cited_refs": sorted(distinct_refs),
                    "best_cited_weight": max(
                        (round(EVIDENCE[ref].weight, 4) for ref in distinct_refs),
                        default=0.0,
                    ),
                },
            )
            return result
        result.update(answer=claim, decision="unanimous_single_source", reason="no_override")
        return result

    top_claim, top_votes = votes.most_common(1)[0]
    if top_votes > len(findings) / 2 and len(refs_by_claim[top_claim]) >= 2:
        result.update(
            answer=top_claim,
            decision="majority",
            reason="majority_with_independent_sources",
        )
        return result

    top_claim, top_score = ranked[0]
    _, second_score = ranked[1]
    if top_score - second_score >= 0.2:
        result.update(
            answer=top_claim,
            decision="evidence_weight",
            reason="weight_margin_ge_0.2",
            margin=round(top_score - second_score, 4),
        )
        return result

    result.update(answer=None, decision="escalate", reason="scores_too_close")
    return result


# ---------------------------------------------------------------------------
# 图与环检测
# ---------------------------------------------------------------------------


def message_edges(messages: list[dict[str, Any]]) -> dict[str, set[str]]:
    """只把 handoff/confirm 当作等待边；result/decision 是返回边，不构成等待。"""
    edges: dict[str, set[str]] = defaultdict(set)
    for msg in messages:
        if msg["kind"] not in {"handoff", "confirm"}:
            continue
        if msg["recipient"] == "broadcast":
            continue
        edges[msg["sender"]].add(msg["recipient"])
    return edges


def detect_cycle(messages: list[dict[str, Any]]) -> list[str]:
    """返回一个环（首尾相同）；没有环返回空列表。"""
    edges = message_edges(messages)
    nodes = sorted(set(edges) | {v for vs in edges.values() for v in vs})
    color: dict[str, int] = {}
    stack: list[str] = []

    def dfs(node: str) -> list[str] | None:
        color[node] = 1
        stack.append(node)
        for nxt in sorted(edges.get(node, ())):
            if color.get(nxt, 0) == 1:
                return stack[stack.index(nxt):] + [nxt]
            if color.get(nxt, 0) == 0:
                found = dfs(nxt)
                if found:
                    return found
        stack.pop()
        color[node] = 2
        return None

    for node in nodes:
        if color.get(node, 0) == 0:
            found = dfs(node)
            if found:
                return found
    return []


def graph_of(messages: list[dict[str, Any]]) -> dict[str, Any]:
    nodes = sorted(
        {m["sender"] for m in messages}
        | {m["recipient"] for m in messages if m["recipient"] != "broadcast"}
    )
    counts = Counter(
        (m["sender"], m["recipient"])
        for m in messages
        if m["recipient"] != "broadcast"
    )
    return {
        "nodes": nodes,
        "edges": [
            {"from": src, "to": dst, "count": count}
            for (src, dst), count in sorted(counts.items())
        ],
    }


# ---------------------------------------------------------------------------
# worker 的确定性行为
# ---------------------------------------------------------------------------


def worker_finding(agent: str, ref: str, confidence: float, basis: str) -> Finding:
    doc = EVIDENCE[ref]
    return Finding(
        agent=agent,
        claim=doc.answer,
        confidence=confidence,
        refs=(ref,),
        basis=basis,
    )


def _finding_json(finding: Finding) -> dict[str, Any]:
    return {
        "agent": finding.agent,
        "claim": finding.claim,
        "confidence": finding.confidence,
        "refs": list(finding.refs),
        "basis": finding.basis,
        "weight": round(claim_weight(finding), 4),
    }


# ---------------------------------------------------------------------------
# 三种运行模式
# ---------------------------------------------------------------------------


def _base_summary(
    mode: str,
    ledger: BudgetLedger,
    bus: MessageBus,
    breaker: CircuitBreaker,
    *,
    stop_reason: str,
    answer: str | None,
    decision: str,
) -> dict[str, Any]:
    return {
        "mode": mode,
        "task": TASK["question"],
        "answer": answer,
        "decision": decision,
        "stop_reason": stop_reason,
        "budget": ledger.snapshot(),
        "messages": len(bus.messages),
        "graph": graph_of(bus.messages),
        "cycle": detect_cycle(bus.messages),
        "breaker": breaker.snapshot(),
    }


def run_normal(log_path: str | None = None) -> dict[str, Any]:
    ledger = BudgetLedger(TOTAL_BUDGET, ENVELOPES)
    bus = MessageBus(ledger, max_messages=40)
    breaker = CircuitBreaker(threshold=2)
    corr = "c-normal-001"

    h1 = bus.send(
        "supervisor", "worker-a", "handoff", corr,
        {"question": TASK["question"], "source": "doc/primary-2026"},
        refs=["doc/primary-2026"], tokens=17,
    )
    h2 = bus.send(
        "supervisor", "worker-b", "handoff", corr,
        {"question": TASK["question"], "source": "doc/legacy-2024"},
        refs=["doc/legacy-2024"], tokens=17,
    )

    f1 = worker_finding(
        "worker-a", "doc/primary-2026", 0.80, "一手运行手册，当前版本"
    )
    bus.send(
        "worker-a", "supervisor", "result", corr,
        {"ok": True, "claim": f1.claim, "confidence": f1.confidence},
        refs=f1.refs, tokens=32, causation_id=h1["msg_id"],
    )

    f2 = worker_finding(
        "worker-b", "doc/legacy-2024", 0.60, "旧 runbook，未核对版本"
    )
    bus.send(
        "worker-b", "supervisor", "result", corr,
        {"ok": True, "claim": f2.claim, "confidence": f2.confidence},
        refs=f2.refs, tokens=32, causation_id=h2["msg_id"],
    )

    resolution = resolve([f1, f2])
    bus.send(
        "supervisor", "broadcast", "decision", corr,
        {
            "ok": True,
            "answer": resolution["answer"],
            "decision": resolution["decision"],
            "votes": resolution["votes"],
        },
        refs=sorted({ref for f in (f1, f2) for ref in f.refs}),
        tokens=22, causation_id=h2["msg_id"],
    )

    summary = _base_summary(
        "normal", ledger, bus, breaker,
        stop_reason="done",
        answer=resolution["answer"],
        decision=resolution["decision"],
    )
    summary["votes"] = resolution["votes"]
    summary["findings"] = [_finding_json(f1), _finding_json(f2)]
    summary["resolution"] = resolution
    if log_path:
        bus.to_jsonl(log_path)
    return summary


def run_groupthink(log_path: str | None = None) -> dict[str, Any]:
    ledger = BudgetLedger(TOTAL_BUDGET, ENVELOPES)
    bus = MessageBus(ledger, max_messages=40)
    breaker = CircuitBreaker(threshold=2)
    corr = "c-groupthink-001"
    hint = "上游说应该是 30 秒，你确认一下。"

    h1 = bus.send(
        "supervisor", "worker-a", "handoff", corr,
        {"question": TASK["question"], "source": "doc/legacy-2024", "hint": hint},
        refs=["doc/legacy-2024"], tokens=17,
    )
    h2 = bus.send(
        "supervisor", "worker-b", "handoff", corr,
        {"question": TASK["question"], "source": "doc/legacy-2024", "hint": hint},
        refs=["doc/legacy-2024"], tokens=17,
    )

    f1 = worker_finding("worker-a", "doc/legacy-2024", 0.92, "与 supervisor 提示一致")
    f2 = worker_finding("worker-b", "doc/legacy-2024", 0.92, "与 supervisor 提示一致")

    bus.send(
        "worker-a", "supervisor", "result", corr,
        {"ok": True, "claim": f1.claim, "confidence": f1.confidence},
        refs=f1.refs, tokens=32, causation_id=h1["msg_id"],
    )
    bus.send(
        "worker-b", "supervisor", "result", corr,
        {"ok": True, "claim": f2.claim, "confidence": f2.confidence},
        refs=f2.refs, tokens=32, causation_id=h2["msg_id"],
    )

    resolution = resolve([f1, f2])
    bus.send(
        "supervisor", "broadcast", "decision", corr,
        {
            "ok": True,
            "answer": resolution["answer"],
            "decision": resolution["decision"],
            "raw_votes": resolution["votes"],
            "override": resolution["decision"] == "evidence_override",
        },
        refs=sorted({ref for f in (f1, f2) for ref in f.refs}),
        tokens=22, causation_id=h2["msg_id"],
    )

    summary = _base_summary(
        "groupthink", ledger, bus, breaker,
        stop_reason="done_with_override",
        answer=resolution["answer"],
        decision=resolution["decision"],
    )
    summary["votes"] = resolution["votes"]
    summary["findings"] = [_finding_json(f1), _finding_json(f2)]
    summary["resolution"] = resolution
    summary["groupthink_suspected"] = resolution["groupthink_suspected"]
    if log_path:
        bus.to_jsonl(log_path)
    return summary


def run_runaway(log_path: str | None = None) -> dict[str, Any]:
    ledger = BudgetLedger(TOTAL_BUDGET, ENVELOPES)
    bus = MessageBus(ledger, max_messages=20)
    breaker = CircuitBreaker(threshold=2)
    corr = "c-runaway-001"

    bus.send(
        "supervisor", "worker-a", "handoff", corr,
        {"question": TASK["question"], "ask": "完成后请向 worker-b 确认"},
        tokens=17,
    )
    last = bus.send(
        "supervisor", "worker-b", "handoff", corr,
        {"question": TASK["question"], "ask": "完成后请向 worker-a 确认"},
        tokens=17,
    )["msg_id"]

    stop_reason = "message_budget"
    stopped_agent = ""
    error = ""
    for round_no in range(1, 21):
        sender = "worker-a" if round_no % 2 == 1 else "worker-b"
        recipient = "worker-b" if sender == "worker-a" else "worker-a"
        try:
            msg = bus.send(
                sender, recipient, "confirm", corr,
                {
                    "ok": True,
                    "round": round_no,
                    "text": f"{sender} 请 {recipient} 确认收到，收到后再回复确认",
                },
                tokens=25, causation_id=last,
            )
            last = msg["msg_id"]
        except BudgetExhausted as exc:
            stop_reason = "message_budget" if exc.reason == "message_budget" else "budget_exhausted"
            stopped_agent = sender
            error = str(exc)
            breaker.trip(sender, "budget_exhausted")
            bus.emit_event(
                "supervisor", "broadcast", "breaker", corr,
                {"ok": False, "agent": sender, "reason": "budget_exhausted"},
                causation_id=last,
            )
            break

    summary = _base_summary(
        "runaway", ledger, bus, breaker,
        stop_reason=stop_reason,
        answer=None,
        decision="none",
    )
    summary["votes"] = {}
    summary["findings"] = []
    summary["resolution"] = None
    summary["stopped_agent"] = stopped_agent
    summary["error"] = error
    if log_path:
        bus.to_jsonl(log_path)
    return summary


def run(mode: str, log_path: str | None = None) -> dict[str, Any]:
    if mode == "normal":
        return run_normal(log_path)
    if mode == "groupthink":
        return run_groupthink(log_path)
    if mode == "runaway":
        return run_runaway(log_path)
    raise ValueError(f"unknown mode: {mode}")


# ---------------------------------------------------------------------------
# 从 JSONL 消息日志做离线分析
# ---------------------------------------------------------------------------


def analyze(path: str) -> dict[str, Any]:
    records: list[dict[str, Any]] = []
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line:
                records.append(json.loads(line))

    stats: dict[str, dict[str, Any]] = {}
    for msg in records:
        row = stats.setdefault(
            msg["sender"],
            {"messages": 0, "tokens": 0, "failures": 0, "failure_rate": 0.0},
        )
        row["messages"] += 1
        row["tokens"] += int(msg.get("tokens", 0))
        if msg.get("payload", {}).get("ok") is False:
            row["failures"] += 1
    for row in stats.values():
        row["failure_rate"] = round(row["failures"] / row["messages"], 4)

    return {
        "messages": len(records),
        "by_agent": dict(sorted(stats.items())),
        "kinds": dict(sorted(Counter(m["kind"] for m in records).items())),
        "correlation_ids": sorted({m["correlation_id"] for m in records}),
        "cycle": detect_cycle(records),
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="supervisor + 2 workers 的预算控制实验")
    parser.add_argument("--mode", choices=["normal", "groupthink", "runaway"], default="normal")
    parser.add_argument("--log", help="把消息日志写成 JSONL")
    parser.add_argument("--analyze", metavar="JSONL", help="离线分析消息日志并输出 JSON")
    args = parser.parse_args(argv)

    if args.analyze:
        print(json.dumps(analyze(args.analyze), ensure_ascii=False, indent=2, sort_keys=True))
        return 0

    summary = run(args.mode, args.log)
    print(json.dumps(summary, ensure_ascii=False, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
