#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""policy_engine.py — 第 12 章的最小策略引擎（标准库、确定性）。

它把一次高风险动作拆成四个可检查的对象：

    主体 subject ── 动作 action ── 资源 resource ── 上下文 context
                                   │
                          策略规则（带版本、优先级、义务）
                                   │
                    allow / require_approval / deny
                                   │
                     追加写审计日志（哈希链）

设计约束：
  - 默认拒绝：没有任何规则匹配时返回 deny；
  - 优先级高的规则获胜；同优先级时更保守的结果获胜（deny > approval > allow）；
  - 策略条件抛异常时 fail-closed，返回 deny 并记录 policy_error；
  - 每条决策都带 policy_version，便于事后回答「当时按哪版策略放行」；
  - 决策日志是 append-only JSONL，每条记录带 prev_hash/hash，可验证是否被改动；
  - dry-run 只计算、不写日志，用于上线前对比。

用法：
    python3 policy_engine.py demo --log /tmp/ch12-decisions.jsonl
    python3 policy_engine.py verify /tmp/ch12-decisions.jsonl
    python3 policy_engine.py stats  /tmp/ch12-decisions.jsonl
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from dataclasses import dataclass, field
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable, Iterable, Mapping

EFFECTS = ("allow", "require_approval", "deny")
EFFECT_RANK = {"allow": 1, "require_approval": 2, "deny": 3}
GENESIS = "0" * 64
CONTEXT_KEYS = (
    "amount_cents",
    "environment",
    "first_time",
    "reversible",
    "break_glass",
    "incident_id",
    "rows",
    "contains_pii",
)


# --------------------------------------------------------------------------- #
# 请求与策略
# --------------------------------------------------------------------------- #


@dataclass(frozen=True)
class Subject:
    """发起动作的主体；roles 是策略判断的主要依据，tenant 用于跨租户检查。"""

    id: str
    roles: frozenset[str]
    tenant: str
    attrs: Mapping[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class Request:
    """一次待决策的请求；context 只放策略需要的结构化字段，不放自由文本。"""

    id: str
    subject: Subject
    action: str
    resource: str
    resource_tenant: str
    context: Mapping[str, Any] = field(default_factory=dict)

    def flag(self, name: str, default: Any = None) -> Any:
        return self.context.get(name, default)


@dataclass(frozen=True)
class Rule:
    """一条策略规则；when 是纯函数，返回 True 表示命中。"""

    id: str
    effect: str
    priority: int
    description: str
    when: Callable[[Request], bool]
    obligations: tuple[str, ...] = ()

    def matches(self, request: Request) -> bool:
        return bool(self.when(request))


@dataclass(frozen=True)
class PolicyBundle:
    """一组不可变规则 + 版本号；发布新策略就是发布新 bundle。"""

    version: str
    rules: tuple[Rule, ...]

    def validate(self) -> None:
        if not self.version.strip():
            raise ValueError("policy version 不能为空")
        seen: set[str] = set()
        for rule in self.rules:
            if rule.effect not in EFFECTS:
                raise ValueError(f"{rule.id}: 未知 effect {rule.effect!r}")
            if rule.id in seen:
                raise ValueError(f"规则 id 重复：{rule.id}")
            seen.add(rule.id)

    def ordered(self) -> list[Rule]:
        """高优先级在前；同优先级时 deny 在前，保证 tie-break 是确定且保守的。"""
        return sorted(
            self.rules,
            key=lambda r: (-r.priority, -EFFECT_RANK[r.effect], r.id),
        )


@dataclass(frozen=True)
class Decision:
    request_id: str
    decision: str
    policy_version: str
    matched_rule: str | None
    reason: str
    obligations: tuple[str, ...] = ()
    dry_run: bool = False

    def to_dict(self) -> dict[str, Any]:
        return {
            "request_id": self.request_id,
            "decision": self.decision,
            "policy_version": self.policy_version,
            "matched_rule": self.matched_rule,
            "reason": self.reason,
            "obligations": list(self.obligations),
            "dry_run": self.dry_run,
        }


# --------------------------------------------------------------------------- #
# 审计日志：append-only + 哈希链
# --------------------------------------------------------------------------- #


def utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def canonical(payload: Mapping[str, Any]) -> bytes:
    return json.dumps(
        payload, sort_keys=True, separators=(",", ":"), ensure_ascii=False
    ).encode("utf-8")


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sanitize_context(context: Mapping[str, Any]) -> dict[str, Any]:
    """只保留白名单字段；自由文本、token、文件内容一律不进审计日志。"""
    return {k: context[k] for k in CONTEXT_KEYS if k in context}


class AuditLog:
    """append-only JSONL；每条记录的 hash 覆盖前一条的 hash，形成链。"""

    def __init__(self, path: str | Path, clock: Callable[[], str] = utc_now):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self._clock = clock
        self.seq, self.head = self._tail()

    def _tail(self) -> tuple[int, str]:
        if not self.path.exists() or self.path.stat().st_size == 0:
            return 0, GENESIS
        last: dict[str, Any] | None = None
        with self.path.open("r", encoding="utf-8") as fh:
            for line in fh:
                if line.strip():
                    last = json.loads(line)
        if last is None:
            return 0, GENESIS
        return int(last["seq"]), str(last["hash"])

    def append(
        self,
        event_type: str,
        *,
        actor: str,
        action: str,
        resource: str,
        resource_tenant: str,
        decision: str,
        policy_version: str,
        evidence: Mapping[str, Any] | None = None,
        obligations: Iterable[str] = (),
    ) -> dict[str, Any]:
        self.seq += 1
        payload: dict[str, Any] = {
            "seq": self.seq,
            "event_id": f"evt-{self.seq:06d}",
            "recorded_at": self._clock(),
            "event_type": event_type,
            "actor": actor,
            "action": action,
            "resource": resource,
            "resource_tenant": resource_tenant,
            "policy_version": policy_version,
            "decision": decision,
            "obligations": list(obligations),
            "evidence": dict(evidence or {}),
            "prev_hash": self.head,
        }
        digest = sha256_hex(canonical(payload))
        payload["hash"] = digest
        line = json.dumps(payload, sort_keys=True, ensure_ascii=False)
        with self.path.open("a", encoding="utf-8") as fh:
            fh.write(line + "\n")
            fh.flush()
        self.head = digest
        return payload


def verify_chain(path: str | Path) -> tuple[bool, int, str]:
    """重算整条链；返回 (ok, 事件数, 说明)。"""
    prev = GENESIS
    count = 0
    with Path(path).open("r", encoding="utf-8") as fh:
        for lineno, line in enumerate(fh, 1):
            if not line.strip():
                continue
            event = json.loads(line)
            count += 1
            stored = event.pop("hash", None)
            if event.get("prev_hash") != prev:
                return False, count, f"第 {lineno} 行 prev_hash 不匹配"
            if stored != sha256_hex(canonical(event)):
                return False, count, f"第 {lineno} 行 hash 不匹配（内容被改动）"
            prev = stored
    return True, count, "chain OK"


def read_events(path: str | Path) -> list[dict[str, Any]]:
    events = []
    with Path(path).open("r", encoding="utf-8") as fh:
        for line in fh:
            if line.strip():
                events.append(json.loads(line))
    return events


# --------------------------------------------------------------------------- #
# 引擎
# --------------------------------------------------------------------------- #


class PolicyEngine:
    def __init__(self, bundle: PolicyBundle, log: AuditLog | None = None):
        bundle.validate()
        self.bundle = bundle
        self.log = log

    def evaluate(self, request: Request) -> Decision:
        for rule in self.bundle.ordered():
            try:
                hit = rule.matches(request)
            except Exception as exc:  # 策略写错时不能静默跳过
                return Decision(
                    request_id=request.id,
                    decision="deny",
                    policy_version=self.bundle.version,
                    matched_rule=rule.id,
                    reason=f"policy_error:{type(exc).__name__}",
                )
            if hit:
                return Decision(
                    request_id=request.id,
                    decision=rule.effect,
                    policy_version=self.bundle.version,
                    matched_rule=rule.id,
                    reason=rule.description,
                    obligations=rule.obligations,
                )
        return Decision(
            request_id=request.id,
            decision="deny",
            policy_version=self.bundle.version,
            matched_rule=None,
            reason="default_deny",
        )

    def decide(
        self,
        request: Request,
        *,
        dry_run: bool = False,
        evidence: Mapping[str, Any] | None = None,
    ) -> Decision:
        decision = self.evaluate(request)
        if dry_run:
            return Decision(
                request_id=decision.request_id,
                decision=decision.decision,
                policy_version=decision.policy_version,
                matched_rule=decision.matched_rule,
                reason=decision.reason,
                obligations=decision.obligations,
                dry_run=True,
            )
        if self.log is not None:
            self.log.append(
                "policy_decision",
                actor=request.subject.id,
                action=request.action,
                resource=request.resource,
                resource_tenant=request.resource_tenant,
                decision=decision.decision,
                policy_version=decision.policy_version,
                obligations=decision.obligations,
                evidence={
                    "request_id": request.id,
                    "reason": decision.reason,
                    "matched_rule": decision.matched_rule,
                    "context": sanitize_context(request.context),
                    **(dict(evidence or {})),
                },
            )
        return decision


# --------------------------------------------------------------------------- #
# 默认策略包
# --------------------------------------------------------------------------- #


def _same_tenant(r: Request) -> bool:
    return r.subject.tenant == r.resource_tenant


def _amount(r: Request) -> int:
    return int(r.flag("amount_cents", 0) or 0)


def _prod(r: Request) -> bool:
    return r.flag("environment", "staging") == "prod"


def build_bundle(
    version: str = "2026.10.1", high_value_threshold: int = 500_000
) -> PolicyBundle:
    """默认策略；改阈值或规则即得到一个新版本，旧日志仍然可解释。"""
    rules = (
        Rule(
            "break-glass-prod-destructive",
            "allow",
            120,
            "生产破坏性动作带 break-glass 事件号：放行但强制通知与事后复核",
            lambda r: _prod(r)
            and r.action in {"delete", "rollback", "drop"}
            and bool(r.flag("break_glass", False))
            and bool(str(r.flag("incident_id", "")).strip()),
            ("security_notify", "post_review_within_24h"),
        ),
        Rule(
            "deny-prod-destructive",
            "deny",
            100,
            "生产破坏性动作默认拒绝；break-glass 必须带事件号",
            lambda r: _prod(r) and r.action in {"delete", "rollback", "drop"},
        ),
        Rule(
            "deny-cross-tenant",
            "deny",
            95,
            "跨租户访问默认拒绝，除非有单独的数据共享授权",
            lambda r: not _same_tenant(r),
        ),
        Rule(
            "require-approval-high-value-refund",
            "require_approval",
            80,
            f"退款金额超过 {high_value_threshold} 分，需要人工审批",
            lambda r: r.action == "refund" and _amount(r) > high_value_threshold,
            ("four_eyes", "finance_ticket"),
        ),
        Rule(
            "require-approval-prod-write",
            "require_approval",
            70,
            "生产写操作首次执行需要人工审批",
            lambda r: _prod(r)
            and r.action in {"write", "deploy", "update"}
            and bool(r.flag("first_time", False)),
            ("change_ticket",),
        ),
        Rule(
            "require-approval-sensitive-export",
            "require_approval",
            60,
            "导出含 PII 或超过 1000 行需要审批",
            lambda r: r.action == "export"
            and (bool(r.flag("contains_pii", False)) or int(r.flag("rows", 0) or 0) > 1000),
            ("data_owner_approval", "watermark"),
        ),
        Rule(
            "allow-own-tenant-read",
            "allow",
            30,
            "同租户只读操作允许",
            lambda r: r.action == "read" and _same_tenant(r),
        ),
        Rule(
            "allow-small-refund",
            "allow",
            20,
            "小额退款且同租户，允许自动执行",
            lambda r: r.action == "refund" and _amount(r) <= high_value_threshold and _same_tenant(r),
        ),
    )
    return PolicyBundle(version=version, rules=rules)


# --------------------------------------------------------------------------- #
# 权限漂移检测：授予集合 vs 实际使用集合
# --------------------------------------------------------------------------- #


@dataclass(frozen=True)
class DriftReport:
    unused: dict[str, tuple[str, ...]]
    ungranted: dict[str, tuple[str, ...]]

    @property
    def clean(self) -> bool:
        return not self.unused and not self.ungranted

    def to_dict(self) -> dict[str, Any]:
        return {
            "clean": self.clean,
            "unused": {k: list(v) for k, v in sorted(self.unused.items())},
            "ungranted": {k: list(v) for k, v in sorted(self.ungranted.items())},
        }


def detect_permission_drift(
    granted: Mapping[str, Iterable[str]],
    used: Mapping[str, Iterable[str]],
) -> DriftReport:
    """对比「授予」与「实际使用」。

    unused    = 授予了但窗口期内从未使用（应回收）；
    ungranted = 使用了但从未授予（越权、旁路或日志缺失）。
    """
    subjects = sorted(set(granted) | set(used))
    unused: dict[str, tuple[str, ...]] = {}
    ungranted: dict[str, tuple[str, ...]] = {}
    for subject in subjects:
        g = set(granted.get(subject, ()))
        u = set(used.get(subject, ()))
        if g - u:
            unused[subject] = tuple(sorted(g - u))
        if u - g:
            ungranted[subject] = tuple(sorted(u - g))
    return DriftReport(unused=unused, ungranted=ungranted)


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #


def _demo_requests() -> list[Request]:
    analyst = Subject("analyst-7", frozenset({"analyst"}), "acme")
    support = Subject("support-3", frozenset({"support"}), "acme")
    ops = Subject("ops-2", frozenset({"sre"}), "acme")
    return [
        Request(
            "req-001",
            analyst,
            "read",
            "invoice:INV-1042",
            "acme",
            {"environment": "prod"},
        ),
        Request(
            "req-002",
            support,
            "refund",
            "invoice:INV-2091",
            "acme",
            {"environment": "prod", "amount_cents": 1_250_000, "reversible": False},
        ),
        Request(
            "req-003",
            ops,
            "delete",
            "db:prod-orders",
            "acme",
            {"environment": "prod", "reversible": False},
        ),
        Request(
            "req-004",
            analyst,
            "export",
            "table:customers",
            "acme",
            {"environment": "prod", "rows": 25_000, "contains_pii": True},
        ),
    ]


def cmd_demo(args: argparse.Namespace) -> int:
    path = Path(args.log)
    if not args.append:
        path.unlink(missing_ok=True)
    clock = _DemoClock()
    log = AuditLog(path, clock=clock)
    engine = PolicyEngine(build_bundle(), log=log)
    for request in _demo_requests():
        dry_run = args.dry_run or request.id == "req-004"
        decision = engine.decide(request, dry_run=dry_run)
        print(
            f"[{decision.decision:>16}] {request.id} "
            f"{request.action:<7} {request.resource:<22} "
            f"rule={decision.matched_rule or '-':<34} "
            f"policy={decision.policy_version} dry_run={str(dry_run).lower()}"
        )
        if decision.obligations:
            print(f"{'':19}obligations={','.join(decision.obligations)}")
        if decision.reason.startswith("policy_error"):
            print(f"{'':19}reason={decision.reason}")
    print(f"log={path} events={log.seq}")
    ok, count, detail = verify_chain(path) if path.exists() else (True, 0, "empty")
    print(f"chain={detail} events={count}")
    return 0


class _DemoClock:
    """确定性时钟：每次取时间前进 1 秒，保证演示输出可复现。"""

    def __init__(self) -> None:
        self._base = datetime(2026, 10, 19, 9, 0, 0, tzinfo=timezone.utc)
        self._n = -1

    def __call__(self) -> str:
        self._n += 1
        return (self._base + timedelta(seconds=self._n)).strftime("%Y-%m-%dT%H:%M:%SZ")


def cmd_verify(args: argparse.Namespace) -> int:
    ok, count, detail = verify_chain(args.path)
    print(f"{'OK' if ok else 'BROKEN'}: {detail}; events={count}")
    return 0 if ok else 1


def cmd_stats(args: argparse.Namespace) -> int:
    events = read_events(args.path)
    counts: dict[str, int] = {}
    anomalous = 0
    for event in events:
        counts[event["decision"]] = counts.get(event["decision"], 0) + 1
        ctx = event.get("evidence", {}).get("context", {})
        if event["decision"] == "allow" and (
            event.get("obligations") or ctx.get("break_glass")
        ):
            anomalous += 1
    total = len(events)
    print(f"events={total}")
    for key in sorted(counts):
        print(f"  {key:<18} {counts[key]}")
    approvals = counts.get("require_approval", 0)
    print(f"approval_required_ratio={approvals / total:.3f}" if total else "approval_required_ratio=0")
    print(f"anomalous_allow={anomalous}")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="第 12 章策略引擎")
    sub = parser.add_subparsers(dest="cmd", required=True)

    demo = sub.add_parser("demo", help="跑四个请求：allow / require_approval / deny / dry-run")
    demo.add_argument("--log", default="/tmp/ch12-decisions.jsonl")
    demo.add_argument("--append", action="store_true", help="追加而不是重建日志")
    demo.add_argument("--dry-run", action="store_true", help="全部只计算，不写日志")
    demo.set_defaults(func=cmd_demo)

    verify = sub.add_parser("verify", help="验证哈希链")
    verify.add_argument("path")
    verify.set_defaults(func=cmd_verify)

    stats = sub.add_parser("stats", help="按决策统计")
    stats.add_argument("path")
    stats.set_defaults(func=cmd_stats)

    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    sys.exit(main())
