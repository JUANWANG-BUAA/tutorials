"""项目一：工具契约与策略测试。"""
from __future__ import annotations

import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from agent.state import ControlState, State, TaskState  # noqa: E402
from agent.tools import ToolContext, ToolRegistry, default_tools  # noqa: E402
from sandbox.policy import EgressPolicy, PolicyError, Workspace  # noqa: E402
from sandbox.runner import Limits  # noqa: E402


class ToolTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="as-tools-")
        self.ws = Workspace(Path(self.tmp.name))
        self.ctx = ToolContext(self.ws, EgressPolicy(), Limits(),
                               {"workspace:read", "workspace:write",
                                "workspace:exec", "task:finish"})
        self.reg = ToolRegistry(default_tools(), self.ctx)
        self.state = State(self.ws, TaskState(goal="t"), ControlState())

    def tearDown(self):
        self.tmp.cleanup()

    def test_write_then_read(self):
        w = self.reg.call(self.state, "fs.write", {"path": "a.txt", "content": "hello"})
        self.assertTrue(w["ok"])
        r = self.reg.call(self.state, "fs.read", {"path": "a.txt"})
        self.assertTrue(r["ok"])
        self.assertEqual(r["data"]["content"], "hello")

    def test_unknown_tool(self):
        r = self.reg.call(self.state, "no.such", {})
        self.assertFalse(r["ok"])
        self.assertEqual(r["error"]["code"], "ENOTOOL")

    def test_schema_extra_field(self):
        r = self.reg.call(self.state, "fs.read", {"path": "a.txt", "limit": 1})
        self.assertFalse(r["ok"])
        self.assertEqual(r["error"]["code"], "EINVAL")
        self.assertIn("unexpected", r["error"]["message"])

    def test_path_escape(self):
        r = self.reg.call(self.state, "fs.write", {"path": "../x", "content": "x"})
        self.assertFalse(r["ok"])
        self.assertEqual(r["error"]["code"], "EPERM")

    def test_finish_requires_tests(self):
        r = self.reg.call(self.state, "task.finish", {"answer": "done"})
        self.assertFalse(r["ok"])
        self.assertEqual(r["error"]["code"], "EPRECOND")

    def test_missing_scope(self):
        reg = ToolRegistry(default_tools(), ToolContext(self.ws, EgressPolicy(), Limits(), set()))
        r = reg.call(self.state, "fs.read", {"path": "a.txt"})
        self.assertFalse(r["ok"])
        self.assertEqual(r["error"]["code"], "EPERM")

    def test_workspace_symlink_escape(self):
        outside = Path(self.tmp.name).parent / "outside-secret.txt"
        outside.write_text("secret", encoding="utf-8")
        os.symlink(outside, self.ws.root / "link.txt")
        with self.assertRaises(PolicyError):
            self.ws.resolve("link.txt")
        outside.unlink(missing_ok=True)

    def test_egress_default_deny(self):
        with self.assertRaises(PolicyError):
            EgressPolicy().check_url("https://example.com")
        EgressPolicy(frozenset({"example.com"})).check_url("https://example.com")


if __name__ == "__main__":
    unittest.main(verbosity=2)
