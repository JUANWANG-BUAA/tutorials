#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 1 章实验的回归测试：跑 `python3 -m unittest` 或直接执行本文件。"""

from __future__ import annotations

import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mini_loop import run  # noqa: E402


class MiniLoopTest(unittest.TestCase):
    def test_good_run_finishes_and_writes_file(self):
        out = run("sum", "good")
        self.assertEqual(out["stop_reason"], "done")
        self.assertEqual(out["answer"], "sum=23")
        self.assertEqual(out["sum_txt"], "23")
        self.assertEqual(len(out["trace"]), 3)

    def test_loop_hits_budget(self):
        out = run("sum", "loop", max_steps=5)
        self.assertIn(out["stop_reason"], {"max_steps", "max_tool_calls"})
        self.assertEqual(out["steps"], 5)
        self.assertFalse(out["trace"][-1]["state"]["task"]["done"])

    def test_badarg_is_rejected_by_schema(self):
        out = run("sum", "badarg", max_steps=3)
        first = out["trace"][0]["result"]
        self.assertTrue(first["ok"])
        second = out["trace"][1]["result"]
        self.assertFalse(second["ok"])
        self.assertEqual(second["error"], "EINVAL")
        self.assertIn("unexpected fields", second["detail"])

    def test_trace_is_jsonl_serializable(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "trace.jsonl")
            out = run("sum", "good", trace_path=path)
            self.assertEqual(out["stop_reason"], "done")
            with open(path, encoding="utf-8") as fh:
                rows = [json.loads(line) for line in fh]
            self.assertEqual(len(rows), 3)
            for row in rows:
                self.assertIn("decision", row)
                self.assertIn("result", row)
                self.assertIn("state", row)
                self.assertIn("budget_before", row)


if __name__ == "__main__":
    unittest.main(verbosity=2)
