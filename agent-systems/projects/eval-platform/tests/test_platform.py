"""注册表、评估集、执行器的回归测试。"""
from __future__ import annotations

import json
import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from evalplat.evalset import EvalSetError, load_evalset  # noqa: E402
from evalplat.executor import Executor, build_registry  # noqa: E402
from evalplat.registry import RegistryError, Tool, ToolRegistry  # noqa: E402


class RegistryTest(unittest.TestCase):
    def test_duplicate(self):
        reg = build_registry()
        with self.assertRaises(RegistryError):
            reg.register(Tool("math.add", "v1", "dup", {}, 1, 1, "eval:run", lambda a: {}))

    def test_version_mismatch(self):
        reg = build_registry()
        with self.assertRaises(RegistryError):
            reg.get("lookup.order", "v2")

    def test_schema_extra(self):
        reg = build_registry()
        with self.assertRaises(RegistryError):
            reg.validate("math.add", {"a": 1, "b": 2, "x": 3}, scope="eval:run")

    def test_scope(self):
        reg = build_registry()
        with self.assertRaises(RegistryError):
            reg.validate("billing.refund", {"order_id": "o", "amount_cents": 1,
                                            "idempotency_key": "k"}, scope="read:only")

    def test_signature_changes_with_schema(self):
        a = build_registry().signature()
        b = build_registry().signature()
        self.assertEqual(a, b)
        self.assertEqual(len(a), 16)


class EvalSetTest(unittest.TestCase):
    def test_load_real_evalset(self):
        root = Path(__file__).resolve().parents[1]
        es = load_evalset(root / "evalsets" / "tool-calling-v1.jsonl", build_registry())
        self.assertEqual(es.size, 30)
        self.assertEqual(len(es.version), 12)
        self.assertEqual(len(es.by_difficulty()), 3)
        self.assertEqual(len(es.by_tag("flaky")), 6)

    def test_version_stable(self):
        root = Path(__file__).resolve().parents[1]
        a = load_evalset(root / "evalsets" / "tool-calling-v1.jsonl")
        b = load_evalset(root / "evalsets" / "tool-calling-v1.jsonl")
        self.assertEqual(a.version, b.version)

    def test_invalid_duplicate(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "bad.jsonl"
            row = {"id": "x", "tool": "math.add", "args": {"a": 1, "b": 2},
                   "expected": {"sum": 3}}
            p.write_text(json.dumps(row) + "\n" + json.dumps(row) + "\n", encoding="utf-8")
            with self.assertRaises(EvalSetError):
                load_evalset(p)


class ExecutorTest(unittest.TestCase):
    def test_retry_fixes_flaky(self):
        args = {"query": "alpha"}
        no_retry = Executor(build_registry(), retries=0, fail_once=True)
        r1 = no_retry.call("flaky.search", args)
        self.assertFalse(r1.ok)
        self.assertEqual(r1.error["code"], "ETRANSIENT")
        retry = Executor(build_registry(), retries=1, fail_once=True)
        r2 = retry.call("flaky.search", args)
        self.assertTrue(r2.ok)
        self.assertEqual(r2.attempts, 2)

    def test_timeout_is_retryable(self):
        ex = Executor(build_registry(), retries=0, timeout_ms=10)
        r = ex.call("billing.refund", {"order_id": "o", "amount_cents": 100,
                                       "idempotency_key": "k"})
        self.assertFalse(r.ok)
        self.assertEqual(r.error["code"], "ETIMEDOUT")
        self.assertTrue(r.error["retryable"])

    def test_permission_not_retried(self):
        ex = Executor(build_registry(), retries=3)
        r = ex.call("billing.refund", {"order_id": "o", "amount_cents": 30000,
                                       "idempotency_key": "k"})
        self.assertFalse(r.ok)
        self.assertEqual(r.error["code"], "EPERM")
        self.assertFalse(r.error["retryable"])
        self.assertEqual(r.attempts, 1)


if __name__ == "__main__":
    unittest.main(verbosity=2)
