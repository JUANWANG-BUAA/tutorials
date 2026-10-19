#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""approval_flow.py — 第 12 章的审批工作流（标准库、确定性）。

它把「人批准」拆成可执行的状态机：

    submit ──▶ risk grade ──▶ auto / pending / break-glass
                                  │
                    approve ──────┼──────▶ partial / approved
                    timeout ──────┴──────▶ denied（fail-closed）

规则：
  - low           → 自动通过，但仍然写审计；
  - medium        → 1 名审批人（角色 approver）；
  - high/critical → 2 名不同审批人（四眼），requester 不能自批；
  - critical      → 其中 1 名必须是 security；
  - break-glass   → 可绕过审批，但必须带 incident_id，且 24h 内事后复核；
  - 超时          → 拒绝（deny），并按风险等级记录降级动作。

用法：
    python3 approval_flow.py demo  --log /tmp/ch12-approvals.jsonl
    python3 approval_flow.py stats /tmp/ch12-approvals.jsonl
"""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass, field
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable, Iterable

from policy_engine import AuditLog, read_events, verify_chain

POLICY_VERSION = "approval-2026.10.1"
DESTRUCTIVE = {"delete", "drop", "rollback", "revoke"}
WRITE_ACTIONS = {"write", "update", "deploy", "delete", "drop", "rollback", "refund"}
APPROVER_ROLE = "approver"


# --------------------------------------------------------------------------- #
# 请求与风险分级
# --------------------------------------------------------------------------- #


@dataclass(frozen=True)
class ApprovalRequest:
    id: str
    requester: str
    action: str
    resource: str
    resource_tenant: str
    amount_cents: int = 0
    environment: str = "staging"
    reversible: bool = True
    first_time: bool = False
    cross_tenant: bool = False
    contains_pii: bool = False
    rows: int = 0
    incident_id: str = ""
    break_glass: bool = False
    ttl_s: int = 900


@dataclass(frozen=True)
class Risk:
    level: str
    reasons: tuple[str, ...]
    required_approvals: int
    requires_security: bool = False
    fallback: str = "deny"

    def to_dict(self) -> dict[str, Any]:
        return {
            "level": self.level,
            "reasons": list(self.reasons),
            "required_approvals": self.required_approvals,
            "requires_security": self.requires_security,
            "fallback": self.fallback,
        }


def grade(request: ApprovalRequest) -> Risk:
    """确定性的风险分级；顺序从高到低，命中即停。"""
    prod = request.environment == "prod"
    if prod and request.action in DESTRUCTIVE:
        return Risk("critical", ("prod_destructive",), 2, True, "deny_and_page_oncall")
    if request.cross_tenant and request.contains_pii:
        return Risk("critical", ("cross_tenant_pii",), 2, True, "deny_and_page_oncall")
    if request.amount_cents >= 5_000_000:
        return Risk("critical", ("amount_ge_5000000",), 2, True, "deny_and_page_oncall")
    reasons: list[str] = []
    if not request.reversible:
        reasons.append("irreversible")
    if request.amount_cents >= 500_000:
        reasons.append("amount_ge_500000")
    if request.cross_tenant:
        reasons.append("cross_tenant")
    if prod and request.action in WRITE_ACTIONS:
        reasons.append("prod_write")
    if reasons:
        return Risk("high", tuple(reasons), 2)
    if request.first_time:
        reasons.append("first_time")
    if request.amount_cents >= 50_000:
        reasons.append("amount_ge_50000")
    if prod and request.action != "read":
        reasons.append("prod")
    if reasons:
        return Risk("medium", tuple(reasons), 1)
    return Risk("low", ("read_or_staging",), 0)


# --------------------------------------------------------------------------- #
# 状态机
# --------------------------------------------------------------------------- #


@dataclass
class ApprovalState:
    request: ApprovalRequest
    risk: Risk
    status: str = "pending"  # pending / approved / denied
    mode: str = "human"  # auto / human / break_glass
    approvals: list[dict[str, Any]] = field(default_factory=list)
    submitted_at: int = 0
    deadline: int = 0
    decided_at: int | None = None
    reason: str = "pending"
    degraded_to: str | None = None
    post_review_due: int | None = None

    @property
    def wait_s(self) -> int:
        if self.decided_at is None:
            return 0
        return max(0, self.decided_at - self.submitted_at)

    @property
    def approvers(self) -> list[str]:
        return [a["approver"] for a in self.approvals]


class ApprovalFlow:
    def __init__(
        self,
        log: AuditLog,
        now: Callable[[], int],
        *,
        policy_version: str = POLICY_VERSION,
    ):
        self.log = log
        self._now = now
        self.policy_version = policy_version
        self.states: dict[str, ApprovalState] = {}

    # -- 提交 --------------------------------------------------------------- #

    def submit(self, request: ApprovalRequest) -> ApprovalState:
        risk = grade(request)
        now = self._now()
        state = ApprovalState(
            request=request,
            risk=risk,
            submitted_at=now,
            deadline=now + request.ttl_s,
        )
        self.states[request.id] = state
        self.log.append(
            "approval_submitted",
            actor=request.requester,
            action=request.action,
            resource=request.resource,
            resource_tenant=request.resource_tenant,
            decision="pending",
            policy_version=self.policy_version,
            evidence={
                "request_id": request.id,
                "risk": risk.level,
                "reasons": list(risk.reasons),
                "amount_cents": request.amount_cents,
                "environment": request.environment,
                "reversible": request.reversible,
                "cross_tenant": request.cross_tenant,
                "ttl_s": request.ttl_s,
            },
        )

        if request.break_glass:
            return self._break_glass(state, now)
        if risk.level == "low":
            state.status = "approved"
            state.mode = "auto"
            state.decided_at = now
            state.reason = "auto_approved_low_risk"
            self.log.append(
                "approval_auto_approved",
                actor="policy-engine",
                action=request.action,
                resource=request.resource,
                resource_tenant=request.resource_tenant,
                decision="approved",
                policy_version=self.policy_version,
                evidence={"request_id": request.id, "risk": risk.level, "wait_s": 0},
            )
        return state

    def _break_glass(self, state: ApprovalState, now: int) -> ApprovalState:
        request = state.request
        if not request.incident_id.strip():
            state.status = "denied"
            state.decided_at = now
            state.reason = "break_glass_without_incident"
            self.log.append(
                "break_glass_rejected",
                actor=request.requester,
                action=request.action,
                resource=request.resource,
                resource_tenant=request.resource_tenant,
                decision="denied",
                policy_version=self.policy_version,
                evidence={"request_id": request.id, "reason": state.reason},
            )
            return state
        state.status = "approved"
        state.mode = "break_glass"
        state.decided_at = now
        state.reason = "break_glass_with_incident"
        state.post_review_due = now + 86_400
        self.log.append(
            "break_glass_used",
            actor=request.requester,
            action=request.action,
            resource=request.resource,
            resource_tenant=request.resource_tenant,
            decision="approved",
            policy_version=self.policy_version,
            obligations=("security_notify", "post_review_within_24h"),
            evidence={
                "request_id": request.id,
                "incident_id": request.incident_id,
                "risk": state.risk.level,
                "post_review_due": state.post_review_due,
                "wait_s": 0,
            },
        )
        return state

    # -- 审批 --------------------------------------------------------------- #

    def approve(
        self,
        request_id: str,
        approver: str,
        roles: Iterable[str] = (APPROVER_ROLE,),
    ) -> ApprovalState:
        state = self.states[request_id]
        now = self._now()
        self._expire(state, now)
        if state.status != "pending":
            return state
        roles = frozenset(roles)
        request = state.request

        if approver == request.requester:
            self._reject(state, approver, "self_approval", now)
            return state
        if approver in state.approvers:
            self._reject(state, approver, "duplicate_approver", now)
            return state
        if APPROVER_ROLE not in roles:
            self._reject(state, approver, "role_not_allowed", now)
            return state
        if (
            state.risk.requires_security
            and "security" not in roles
            and not any("security" in a["roles"] for a in state.approvals)
        ):
            self._reject(state, approver, "security_approver_required", now)
            return state

        state.approvals.append({"approver": approver, "roles": tuple(sorted(roles))})
        if len(state.approvals) >= state.risk.required_approvals:
            state.status = "approved"
            state.decided_at = now
            state.reason = "approved_by_human"
            self.log.append(
                "approval_granted",
                actor=approver,
                action=request.action,
                resource=request.resource,
                resource_tenant=request.resource_tenant,
                decision="approved",
                policy_version=self.policy_version,
                evidence={
                    "request_id": request.id,
                    "risk": state.risk.level,
                    "approvers": state.approvers,
                    "wait_s": state.wait_s,
                },
            )
        else:
            self.log.append(
                "approval_partial",
                actor=approver,
                action=request.action,
                resource=request.resource,
                resource_tenant=request.resource_tenant,
                decision="pending",
                policy_version=self.policy_version,
                evidence={
                    "request_id": request.id,
                    "approvers": state.approvers,
                    "remaining": state.risk.required_approvals - len(state.approvals),
                },
            )
        return state

    def _reject(
        self, state: ApprovalState, approver: str, reason: str, now: int
    ) -> None:
        self.log.append(
            "approval_rejected",
            actor=approver,
            action=state.request.action,
            resource=state.request.resource,
            resource_tenant=state.request.resource_tenant,
            decision="rejected",
            policy_version=self.policy_version,
            evidence={"request_id": state.request.id, "reason": reason, "at": now},
        )

    # -- 超时 --------------------------------------------------------------- #

    def _expire(self, state: ApprovalState, now: int) -> bool:
        if state.status != "pending" or now < state.deadline:
            return False
        state.status = "denied"
        state.decided_at = state.deadline
        state.reason = "timeout"
        state.degraded_to = state.risk.fallback
        self.log.append(
            "approval_timeout",
            actor="policy-engine",
            action=state.request.action,
            resource=state.request.resource,
            resource_tenant=state.request.resource_tenant,
            decision="denied",
            policy_version=self.policy_version,
            evidence={
                "request_id": state.request.id,
                "risk": state.risk.level,
                "deadline": state.deadline,
                "wait_s": state.wait_s,
                "degraded_to": state.risk.fallback,
            },
        )
        return True

    def sweep(self) -> list[ApprovalState]:
        now = self._now()
        return [s for s in self.states.values() if self._expire(s, now)]


# --------------------------------------------------------------------------- #
# 统计
# --------------------------------------------------------------------------- #


def summarize(path: str | Path) -> dict[str, Any]:
    events = read_events(path)
    counts: dict[str, int] = {}
    waits: list[int] = []
    for event in events:
        kind = event["event_type"]
        counts[kind] = counts.get(kind, 0) + 1
        if kind == "approval_granted":
            waits.append(int(event["evidence"].get("wait_s", 0)))
    granted = counts.get("approval_granted", 0)
    timeout = counts.get("approval_timeout", 0)
    break_glass = counts.get("break_glass_used", 0)
    denominator = granted + timeout
    return {
        "events": len(events),
        "submitted": counts.get("approval_submitted", 0),
        "auto_approved": counts.get("approval_auto_approved", 0),
        "human_approved": granted,
        "timeout": timeout,
        "break_glass": break_glass,
        "rejected_attempts": counts.get("approval_rejected", 0),
        "approval_rate": (granted / denominator) if denominator else 1.0,
        "mean_wait_s": (sum(waits) / len(waits)) if waits else 0.0,
        "anomalous_release": break_glass,
    }


# --------------------------------------------------------------------------- #
# 演示
# --------------------------------------------------------------------------- #


def _print_state(index: int, state: ApprovalState) -> None:
    req = state.request
    print(
        f"[{index}] {req.action:<8} {req.resource:<24} "
        f"risk={state.risk.level:<8} status={state.status:<8} mode={state.mode:<11} "
        f"approvers={state.approvers} wait={state.wait_s}s"
    )
    if state.degraded_to is not None:
        print(f"    degraded_to={state.degraded_to} reason={state.reason}")
    if state.post_review_due is not None:
        due = datetime.fromtimestamp(state.post_review_due, timezone.utc)
        print(f"    post_review_due={due.strftime('%Y-%m-%dT%H:%M:%SZ')} incident={req.incident_id}")


def cmd_demo(args: argparse.Namespace) -> int:
    path = Path(args.log)
    if not args.append:
        path.unlink(missing_ok=True)
    base = datetime(2026, 10, 19, 10, 0, 0, tzinfo=timezone.utc)
    t0 = int(base.timestamp())
    clock_now = {"t": t0}

    def iso() -> str:
        return datetime.fromtimestamp(clock_now["t"], timezone.utc).strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        )

    flow = ApprovalFlow(AuditLog(path, clock=iso), now=lambda: clock_now["t"])

    # 1) 低风险：自动通过，但审计仍留一条。
    clock_now["t"] = t0 + 0
    s1 = flow.submit(
        ApprovalRequest(
            "apr-001", "analyst-7", "read", "invoice:INV-1042", "acme", environment="prod"
        )
    )
    _print_state(1, s1)

    # 2) 中风险：1 名审批人。
    clock_now["t"] = t0 + 10
    s2 = flow.submit(
        ApprovalRequest(
            "apr-002",
            "support-3",
            "update",
            "config:checkout",
            "acme",
            environment="staging",
            first_time=True,
            ttl_s=600,
        )
    )
    clock_now["t"] = t0 + 100
    s2 = flow.approve("apr-002", "sre-lead", {"approver", "sre"})
    _print_state(2, s2)

    # 3) 高风险：四眼；先自批被拒，再两人批准。
    clock_now["t"] = t0 + 200
    s3 = flow.submit(
        ApprovalRequest(
            "apr-003",
            "support-3",
            "refund",
            "invoice:INV-3099",
            "acme",
            amount_cents=1_250_000,
            environment="prod",
            reversible=False,
            ttl_s=900,
        )
    )
    clock_now["t"] = t0 + 220
    flow.approve("apr-003", "support-3", {"approver", "support"})
    clock_now["t"] = t0 + 250
    s3 = flow.approve("apr-003", "finance-2", {"approver", "finance"})
    clock_now["t"] = t0 + 350
    s3 = flow.approve("apr-003", "finance-4", {"approver", "finance"})
    _print_state(3, s3)

    # 4) 高风险：没人处理，超时 fail-closed。
    clock_now["t"] = t0 + 400
    s4 = flow.submit(
        ApprovalRequest(
            "apr-004",
            "analyst-7",
            "export",
            "table:customers",
            "globex",
            environment="prod",
            cross_tenant=True,
            contains_pii=True,
            rows=25_000,
            ttl_s=300,
        )
    )
    clock_now["t"] = t0 + 1_000
    flow.sweep()
    _print_state(4, s4)

    # 5) break-glass：带事件号，放行但强制事后复核。
    clock_now["t"] = t0 + 1_100
    s5 = flow.submit(
        ApprovalRequest(
            "apr-005",
            "ops-2",
            "rollback",
            "service:checkout",
            "acme",
            environment="prod",
            reversible=False,
            incident_id="INC-2026-1019",
            break_glass=True,
        )
    )
    _print_state(5, s5)

    print("\nrejected attempts:")
    for event in read_events(path):
        if event["event_type"] == "approval_rejected":
            print(
                f"  {event['actor']:<12} {event['evidence']['request_id']} "
                f"reason={event['evidence']['reason']}"
            )

    stats = summarize(path)
    print("\nstats:")
    print(
        "  submitted={submitted} auto={auto_approved} human={human_approved} "
        "timeout={timeout} break_glass={break_glass} rejected={rejected_attempts}".format(**stats)
    )
    print(
        "  approval_rate={approval_rate:.3f} mean_wait_s={mean_wait_s:.1f} "
        "anomalous_release={anomalous_release}".format(**stats)
    )
    ok, count, detail = verify_chain(path)
    print(f"  chain={detail} events={count} ok={str(ok).lower()}")
    print(f"log={path}")
    return 0


def cmd_stats(args: argparse.Namespace) -> int:
    stats = summarize(args.path)
    print(
        "submitted={submitted} auto={auto_approved} human={human_approved} "
        "timeout={timeout} break_glass={break_glass} rejected={rejected_attempts}".format(**stats)
    )
    print(
        "approval_rate={approval_rate:.3f} mean_wait_s={mean_wait_s:.1f} "
        "anomalous_release={anomalous_release}".format(**stats)
    )
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="第 12 章审批工作流")
    sub = parser.add_subparsers(dest="cmd", required=True)

    demo = sub.add_parser("demo", help="跑五个演示步骤")
    demo.add_argument("--log", default="/tmp/ch12-approvals.jsonl")
    demo.add_argument("--append", action="store_true")
    demo.set_defaults(func=cmd_demo)

    stats = sub.add_parser("stats", help="统计审批通过率、等待与异常放行")
    stats.add_argument("path")
    stats.set_defaults(func=cmd_stats)
    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    sys.exit(main())
