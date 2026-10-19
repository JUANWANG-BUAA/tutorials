"""项目一：循环与 trace 的回归测试。"""
from __future__ import annotations

import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from agent.loop import Agent  # noqa: E402
from agent.policy import ScriptedPolicy  # noqa: E402
from sandbox.policy import Workspace  # noqa: E402

from run_demo import make_workspace  # noqa: E402


class LoopTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="as-loop-")
        self.root = Path(self.tmp.name)
        make_workspace(self.root)

    def tearDown(self):
        self.tmp.cleanup()

    def test_good_run_finishes(self):
        out = Agent(Workspace(self.root), policy=ScriptedPolicy("good")).run("fix add()")
        self.assertEqual(out["stop_reason"], "done")
        self.assertEqual(out["steps"], 4)
        self.assertEqual(out["answer"], "fixed add(): a + b")
        self.assertTrue((self.root / "calc.py").read_text().find("a + b") >= 0)

    def test_trace_has_required_fields(self):
        out = Agent(Workspace(self.root), policy=ScriptedPolicy("good")).run("fix add()")
        for row in out["trace"]:
            for key in ("step", "decision", "result", "duration_ms", "budget_before", "state"):
                self.assertIn(key, row)
            self.assertIn("ok", row["result"])
            self.assertIn("tool_calls", row["state"]["control"])

    def test_loop_stops_by_budget(self):
        out = Agent(Workspace(self.root), policy=ScriptedPolicy("loop"),
                    max_steps=5, max_tool_calls=5).run("loop")
        self.assertIn(out["stop_reason"], {"max_steps", "max_tool_calls", "no_progress"})
        self.assertLessEqual(out["steps"], 5)

    def test_escape_is_denied(self):
        out = Agent(Workspace(self.root), policy=ScriptedPolicy("escape")).run("escape")
        first = out["trace"][0]
        self.assertFalse(first["result"]["ok"])
        self.assertEqual(first["result"]["error"]["code"], "EPERM")


if __name__ == "__main__":
    unittest.main(verbosity=2)
