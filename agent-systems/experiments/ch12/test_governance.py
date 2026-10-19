#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""test_governance.py — 第 12 章实验的回归测试。

覆盖六类断言：
  1. 策略优先级与 tie-break；
  2. 默认拒绝与策略异常 fail-closed；
  3. 策略版本差异与 dry-run 不落盘；
  4. 审计哈希链可验证、可发现篡改；
  5. 审批：四眼、自批拒绝、超时、break-glass、critical 需要 security；
  6. 权限漂移：未使用授予与未授予使用。
"""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from approval_flow import ApprovalFlow, ApprovalRequest, grade
from policy_engine import (
    AuditLog,
    PolicyBundle,
    PolicyEngine,
    Request,
    Rule,
    Subject,
    build_bundle,
    detect_permission_drift,
    verify_chain,
)

SUBJECT = Subject("agent-1", frozenset({"analyst"}), "acme")


def make_request(action: str = "read", **context) -> Request:
    return Request(
        "req-test",
        SUBJECT,
        action,
        "invoice:INV-1",
        "acme",
        context,
    )


def make_engine(bundle: PolicyBundle | None = None) -> PolicyEngine:
    return PolicyEngine(bundle or build_bundle(), log=None)


class PolicyPriorityTest(unittest.TestCase):
    def test_default_deny(self) -> None:
        decision = make_engine().evaluate(make_request("unknown_action"))
        self.assertEqual(decision.decision, "deny")
        self.assertEqual(decision.reason, "default_deny")
        self.assertIsNone(decision.matched_rule)

    def test_higher_priority_wins(self) -> None:
        bundle = PolicyBundle(
            "2026.10.1",
            (
                Rule("allow-read", "allow", 10, "low", lambda r: r.action == "read"),
                Rule("deny-read", "deny", 20, "high", lambda r: r.action == "read"),
            ),
        )
        decision = make_engine(bundle).evaluate(make_request())
        self.assertEqual(decision.decision, "deny")
        self.assertEqual(decision.matched_rule, "deny-read")

    def test_same_priority_prefers_deny(self) -> None:
        bundle = PolicyBundle(
            "2026.10.1",
            (
                Rule("allow-read", "allow", 10, "allow", lambda r: r.action == "read"),
                Rule("deny-read", "deny", 10, "deny", lambda r: r.action == "read"),
            ),
        )
        decision = make_engine(bundle).evaluate(make_request())
        self.assertEqual(decision.decision, "deny", "同优先级必须取更保守的结果")

    def test_policy_error_fails_closed(self) -> None:
        def boom(_: Request) -> bool:
            raise RuntimeError("bad predicate")

        bundle = PolicyBundle(
            "2026.10.1", (Rule("broken", "allow", 100, "broken", boom),)
        )
        decision = make_engine(bundle).evaluate(make_request())
        self.assertEqual(decision.decision, "deny")
        self.assertTrue(decision.reason.startswith("policy_error:"))

    def test_version_changes_same_request(self) -> None:
        request = make_request("refund", amount_cents=200_000)
        v1 = make_engine(build_bundle("2026.10.1", 500_000)).evaluate(request)
        v2 = make_engine(build_bundle("2026.10.2", 100_000)).evaluate(request)
        self.assertEqual(v1.decision, "allow")
        self.assertEqual(v2.decision, "require_approval")
        self.assertNotEqual(v1.policy_version, v2.policy_version)

    def test_dry_run_does_not_write(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "decisions.jsonl"
            engine = PolicyEngine(build_bundle(), log=AuditLog(path))
            decision = engine.decide(make_request(), dry_run=True)
            self.assertTrue(decision.dry_run)
            self.assertFalse(path.exists(), "dry-run 不应创建日志")

    def test_decision_is_logged_with_version(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "decisions.jsonl"
            engine = PolicyEngine(build_bundle("2026.10.9"), log=AuditLog(path))
            engine.decide(make_request())
            event = json.loads(path.read_text().strip())
            self.assertEqual(event["decision"], "allow")
            self.assertEqual(event["policy_version"], "2026.10.9")
            self.assertEqual(event["event_type"], "policy_decision")


class AuditChainTest(unittest.TestCase):
    def test_chain_ok(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "audit.jsonl"
            log = AuditLog(path)
            for i in range(3):
                log.append(
                    "policy_decision",
                    actor=f"agent-{i}",
                    action="read",
                    resource="invoice:1",
                    resource_tenant="acme",
                    decision="allow",
                    policy_version="2026.10.1",
                )
            ok, count, detail = verify_chain(path)
            self.assertTrue(ok, detail)
            self.assertEqual(count, 3)

    def test_tamper_is_detected(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "audit.jsonl"
            log = AuditLog(path)
            for _ in range(2):
                log.append(
                    "policy_decision",
                    actor="agent-1",
                    action="read",
                    resource="invoice:1",
                    resource_tenant="acme",
                    decision="allow",
                    policy_version="2026.10.1",
                )
            lines = path.read_text().splitlines()
            event = json.loads(lines[1])
            event["decision"] = "deny"  # 改一条历史记录
            lines[1] = json.dumps(event, sort_keys=True)
            path.write_text("\n".join(lines) + "\n")
            ok, _, detail = verify_chain(path)
            self.assertFalse(ok)
            self.assertIn("hash 不匹配", detail)


class ApprovalTest(unittest.TestCase):
    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.path = Path(self.tmp.name) / "approvals.jsonl"
        self.now = [1_000]
        self.log = AuditLog(self.path, clock=lambda: "2026-10-19T09:00:00Z")
        self.flow = ApprovalFlow(self.log, now=lambda: self.now[0])

    def events(self) -> list[dict]:
        return [json.loads(line) for line in self.path.read_text().splitlines()]

    def high_request(self, rid: str = "apr-1") -> ApprovalRequest:
        return ApprovalRequest(
            rid,
            "requester-1",
            "refund",
            "invoice:1",
            "acme",
            amount_cents=1_250_000,
            ttl_s=600,
        )

    def test_four_eyes_needs_two_distinct_approvers(self) -> None:
        state = self.flow.submit(self.high_request())
        state = self.flow.approve("apr-1", "finance-1")
        self.assertEqual(state.status, "pending")
        state = self.flow.approve("apr-1", "finance-1")
        self.assertEqual(state.status, "pending", "同一人不能重复计数")
        state = self.flow.approve("apr-1", "finance-2")
        self.assertEqual(state.status, "approved")
        self.assertEqual(state.approvers, ["finance-1", "finance-2"])

    def test_self_approval_is_rejected(self) -> None:
        self.flow.submit(self.high_request())
        state = self.flow.approve("apr-1", "requester-1")
        self.assertEqual(state.status, "pending")
        self.assertEqual(state.approvals, [])
        reasons = [
            e["evidence"]["reason"]
            for e in self.events()
            if e["event_type"] == "approval_rejected"
        ]
        self.assertIn("self_approval", reasons)

    def test_timeout_fails_closed(self) -> None:
        state = self.flow.submit(self.high_request())
        self.assertEqual(state.status, "pending")
        self.now[0] += 600
        expired = self.flow.sweep()
        self.assertEqual(len(expired), 1)
        self.assertEqual(state.status, "denied")
        self.assertEqual(state.reason, "timeout")
        timeout_events = [e for e in self.events() if e["event_type"] == "approval_timeout"]
        self.assertEqual(len(timeout_events), 1)
        self.assertEqual(timeout_events[0]["decision"], "denied")
        self.assertEqual(timeout_events[0]["evidence"]["wait_s"], 600)
        self.assertEqual(state.degraded_to, "deny")

    def test_break_glass_requires_incident_and_is_audited(self) -> None:
        no_incident = ApprovalRequest(
            "apr-bg-bad",
            "ops-1",
            "rollback",
            "service:checkout",
            "acme",
            environment="prod",
            break_glass=True,
        )
        state = self.flow.submit(no_incident)
        self.assertEqual(state.status, "denied")
        self.assertEqual(state.reason, "break_glass_without_incident")

        good = ApprovalRequest(
            "apr-bg",
            "ops-1",
            "rollback",
            "service:checkout",
            "acme",
            environment="prod",
            incident_id="INC-2026-1019",
            break_glass=True,
        )
        state = self.flow.submit(good)
        self.assertEqual(state.status, "approved")
        self.assertEqual(state.mode, "break_glass")
        event = [e for e in self.events() if e["event_type"] == "break_glass_used"][0]
        self.assertEqual(event["evidence"]["incident_id"], "INC-2026-1019")
        self.assertIn("post_review_within_24h", event["obligations"])

    def test_critical_needs_security_approver(self) -> None:
        critical = ApprovalRequest(
            "apr-crit",
            "analyst-1",
            "export",
            "table:customers",
            "globex",
            cross_tenant=True,
            contains_pii=True,
        )
        self.assertEqual(grade(critical).level, "critical")
        self.flow.submit(critical)
        state = self.flow.approve("apr-crit", "finance-1", {"approver", "finance"})
        self.assertEqual(state.approvals, [])
        state = self.flow.approve("apr-crit", "sec-1", {"approver", "security"})
        self.assertEqual(state.status, "pending")
        state = self.flow.approve("apr-crit", "finance-1", {"approver", "finance"})
        self.assertEqual(state.status, "approved")


class DriftTest(unittest.TestCase):
    def test_unused_and_ungranted(self) -> None:
        report = detect_permission_drift(
            {"agent-1": {"repo:read", "prod:deploy"}},
            {"agent-1": {"repo:read"}, "agent-2": {"secret:read"}},
        )
        self.assertFalse(report.clean)
        self.assertEqual(report.unused["agent-1"], ("prod:deploy",))
        self.assertEqual(report.ungranted["agent-2"], ("secret:read",))

    def test_clean_when_sets_match(self) -> None:
        report = detect_permission_drift(
            {"agent-1": {"repo:read", "db:read"}},
            {"agent-1": {"db:read", "repo:read"}},
        )
        self.assertTrue(report.clean)


if __name__ == "__main__":
    unittest.main()
