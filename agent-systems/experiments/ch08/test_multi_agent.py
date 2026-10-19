#!/usr/bin/env python3
"""第 8 章实验的单元测试：预算、熔断、投票、消息环与群体幻觉纠正。"""

from __future__ import annotations

import threading
import unittest

from multi_agent import (
    BudgetLedger,
    CircuitBreaker,
    Finding,
    MessageBus,
    detect_cycle,
    resolve,
    run_groupthink,
    run_normal,
    run_runaway,
)


class TestBudgetLedger(unittest.TestCase):
    def test_child_envelopes_must_fit_parent(self) -> None:
        with self.assertRaises(ValueError):
            BudgetLedger(100, {"a": 60, "b": 60})

    def test_concurrent_spend_never_overspends(self) -> None:
        ledger = BudgetLedger(500, {"worker-a": 500})
        barrier = threading.Barrier(8)
        successes: list[bool] = []
        lock = threading.Lock()

        def hammer() -> None:
            barrier.wait()
            local: list[bool] = []
            for _ in range(120):
                local.append(ledger.try_spend("worker-a", 7))
            with lock:
                successes.extend(local)

        threads = [threading.Thread(target=hammer) for _ in range(8)]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()

        spent = sum(1 for ok in successes if ok) * 7
        snapshot = ledger.snapshot()
        self.assertEqual(snapshot["spent"], spent)
        self.assertLessEqual(snapshot["spent"], 500)
        self.assertLessEqual(snapshot["agents"]["worker-a"]["used"], 500)


class TestMessageBus(unittest.TestCase):
    def test_duplicate_delivery_is_idempotent(self) -> None:
        ledger = BudgetLedger(100, {"supervisor": 100})
        bus = MessageBus(ledger)
        msg = bus.send("supervisor", "worker-a", "handoff", "c-1", {"ok": True}, tokens=5)
        self.assertEqual(ledger.snapshot()["spent"], 5)
        self.assertTrue(bus.deliver(msg["msg_id"]))
        self.assertFalse(bus.deliver(msg["msg_id"]))
        self.assertEqual(ledger.snapshot()["spent"], 5)

    def test_seq_and_causation_link(self) -> None:
        ledger = BudgetLedger(200, {"supervisor": 100, "worker-a": 100})
        bus = MessageBus(ledger)
        first = bus.send("supervisor", "worker-a", "handoff", "c-2", {"ok": True})
        second = bus.send(
            "worker-a", "supervisor", "result", "c-2", {"ok": True},
            causation_id=first["msg_id"],
        )
        self.assertEqual([first["seq"], second["seq"]], [1, 2])
        self.assertEqual(second["causation_id"], "m001")
        self.assertEqual(second["correlation_id"], "c-2")


class TestResolver(unittest.TestCase):
    def test_tie_is_resolved_by_evidence_weight(self) -> None:
        summary = run_normal()
        self.assertEqual(summary["votes"], {"10s": 1, "30s": 1})
        self.assertEqual(summary["decision"], "evidence_weight")
        self.assertEqual(summary["answer"], "10s")

    def test_groupthink_is_overridden_by_primary_evidence(self) -> None:
        summary = run_groupthink()
        self.assertEqual(summary["votes"], {"30s": 2})
        self.assertEqual(summary["resolution"]["scores"], {"30s": 0.0414})
        self.assertEqual(summary["decision"], "evidence_override")
        self.assertEqual(summary["answer"], "10s")
        self.assertTrue(summary["groupthink_suspected"])
        self.assertEqual(
            summary["resolution"]["audit"]["canonical_ref"], "doc/primary-2026"
        )

    def test_majority_with_independent_sources(self) -> None:
        findings = [
            Finding("worker-a", "10s", 0.8, ("doc/primary-2026",), "primary"),
            Finding("worker-b", "10s", 0.7, ("doc/secondary-2026",), "secondary"),
            Finding("worker-c", "30s", 0.9, ("doc/legacy-2024",), "legacy"),
        ]
        result = resolve(findings)
        self.assertEqual(result["decision"], "majority")
        self.assertEqual(result["answer"], "10s")
        self.assertEqual(result["votes"], {"10s": 2, "30s": 1})


class TestCircuitBreaker(unittest.TestCase):
    def test_opens_after_threshold_and_blocks_work(self) -> None:
        breaker = CircuitBreaker(threshold=2)
        self.assertTrue(breaker.allow("worker-a"))
        self.assertFalse(breaker.record_failure("worker-a", "timeout"))
        self.assertTrue(breaker.record_failure("worker-a", "timeout"))
        self.assertFalse(breaker.allow("worker-a"))
        self.assertEqual(breaker.snapshot()["state"], "open")
        self.assertEqual(breaker.snapshot()["trips"][0]["agent"], "worker-a")


class TestModes(unittest.TestCase):
    def test_normal_budget_and_cycle(self) -> None:
        summary = run_normal()
        budget = summary["budget"]
        self.assertEqual(budget["spent"], 120)
        self.assertEqual(budget["spent"], sum(a["used"] for a in budget["agents"].values()))
        self.assertLessEqual(budget["spent"], budget["total"])
        self.assertEqual(summary["stop_reason"], "done")
        self.assertEqual(summary["cycle"], [])
        self.assertEqual(summary["breaker"]["state"], "closed")

    def test_runaway_stops_on_budget_and_detects_cycle(self) -> None:
        summary = run_runaway()
        self.assertEqual(summary["stop_reason"], "budget_exhausted")
        self.assertEqual(summary["stopped_agent"], "worker-a")
        self.assertEqual(summary["messages"], 11)
        self.assertEqual(summary["budget"]["spent"], 234)
        self.assertEqual(summary["cycle"][0], summary["cycle"][-1])
        self.assertEqual(set(summary["cycle"][:-1]), {"worker-a", "worker-b"})
        self.assertEqual(summary["breaker"]["state"], "open")
        self.assertLessEqual(
            summary["budget"]["agents"]["worker-a"]["used"],
            summary["budget"]["agents"]["worker-a"]["limit"],
        )

    def test_cycle_detector_handles_self_loop(self) -> None:
        messages = [
            {"sender": "worker-a", "recipient": "worker-a", "kind": "confirm"},
        ]
        self.assertEqual(detect_cycle(messages), ["worker-a", "worker-a"])


if __name__ == "__main__":
    unittest.main()
