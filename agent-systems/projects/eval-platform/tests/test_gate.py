"""门禁的回归测试：通过、拦截、强制留痕。"""
from __future__ import annotations

import json
import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from evalplat.evalset import load_evalset  # noqa: E402
from evalplat.executor import build_registry  # noqa: E402
from evalplat.gate import Thresholds, evaluate  # noqa: E402
from evalplat.runner import RunConfig, run_suite  # noqa: E402


class GateTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        root = Path(__file__).resolve().parents[1]
        cls.es = load_evalset(root / "evalsets" / "tool-calling-v1.jsonl", build_registry())
        cls.base = run_suite(cls.es, RunConfig("baseline", retries=0))
        cls.retry = run_suite(cls.es, RunConfig("retry", retries=1))
        cls.v2 = run_suite(cls.es, RunConfig("v2", retries=1, tool_version="v2"))

    def test_improvement_passes(self):
        d = evaluate(self.base, self.retry)
        self.assertTrue(d.passed, d.reasons)
        self.assertGreater(d.ci.low, 0.05)
        self.assertEqual(d.comparison["broken"], 0)

    def test_regression_blocked(self):
        d = evaluate(self.base, self.v2)
        self.assertFalse(d.passed)
        self.assertEqual(d.comparison["broken"], 2)
        self.assertTrue(any("broken" in r for r in d.reasons))
        self.assertTrue(any("safety" in r for r in d.reasons))

    def test_cost_budget_blocks(self):
        d = evaluate(self.base, self.retry, Thresholds(max_cost_ratio=1.01))
        self.assertFalse(d.passed)
        self.assertTrue(any("cost ratio" in r for r in d.reasons))

    def test_force_passes_and_audits(self):
        with tempfile.TemporaryDirectory() as td:
            audit = Path(td) / "audit.jsonl"
            d = evaluate(self.base, self.v2, force=True, audit_path=audit)
            self.assertTrue(d.passed)
            self.assertTrue(d.forced)
            rows = [json.loads(x) for x in audit.read_text(encoding="utf-8").splitlines()]
            self.assertEqual(len(rows), 1)
            self.assertTrue(rows[0]["decision"]["passed"])
            self.assertFalse(rows[0]["decision"]["original_passed"])
            self.assertTrue(any("FORCED" in r for r in rows[0]["decision"]["reasons"]))


if __name__ == "__main__":
    unittest.main(verbosity=2)
