#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 3 章实验的回归测试：``python3 -m unittest discover -s experiments/ch03 -v``。"""

from __future__ import annotations

import os
import shutil
import signal
import sys
import tempfile
import time
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sandbox_runner import (  # noqa: E402
    decode_wait_status,
    run_code,
    run_script,
)


class SandboxRunnerTest(unittest.TestCase):
    def test_normal_exit(self):
        result = run_code("print('hello from sandbox')", timeout_s=3)
        self.assertTrue(result["ok"])
        self.assertEqual(result["exit_code"], 0)
        self.assertIsNone(result["signal"])
        self.assertFalse(result["timed_out"])
        self.assertEqual(result["stdout"], "hello from sandbox\n")

    def test_nonzero_exit_is_not_success(self):
        result = run_code("import sys; sys.exit(42)", timeout_s=3)
        self.assertFalse(result["ok"])
        self.assertEqual(result["exit_code"], 42)
        self.assertIsNone(result["signal"])
        self.assertFalse(result["timed_out"])

    def test_timeout_kills_process_group(self):
        code = """
import pathlib, subprocess, sys, time

child = subprocess.Popen([
    sys.executable, "-c",
    "import pathlib, time; time.sleep(1.5); pathlib.Path('late.txt').write_text('alive')",
])
pathlib.Path("child.pid").write_text(str(child.pid))
time.sleep(30)
"""
        result = run_code(code, timeout_s=0.6, keep=True)
        root = Path(result["workspace"])
        self.addCleanup(shutil.rmtree, root, True)
        try:
            self.assertTrue(result["timed_out"])
            self.assertFalse(result["ok"])
            self.assertEqual(result["signal"], signal.SIGKILL)
            self.assertTrue((root / "child.pid").is_file())
            time.sleep(1.9)
            self.assertFalse(
                (root / "late.txt").exists(),
                "grandchild survived killpg and wrote late.txt",
            )
        finally:
            pass

    def test_output_limit_truncates(self):
        result = run_code("print('x' * 200000)", timeout_s=3, max_output_bytes=4096)
        self.assertFalse(result["ok"])
        self.assertTrue(result["output_limited"])
        self.assertTrue(result["stdout_truncated"])
        self.assertLessEqual(len(result["stdout"]), 4096)
        self.assertEqual(result["bytes"]["stdout"], 200001)

    def test_path_escape_is_rejected(self):
        with tempfile.TemporaryDirectory() as outside, tempfile.TemporaryDirectory() as ws:
            script = Path(outside) / "escape.py"
            script.write_text("print('escaped')\n", encoding="utf-8")
            result = run_script(script, workspace=Path(ws), timeout_s=2)
            self.assertFalse(result["ok"])
            self.assertEqual(result["error"], "EPATH")
            self.assertIsNone(result["exit_code"])

            link = Path(ws) / "link.py"
            link.symlink_to(script)
            result = run_script(link, workspace=Path(ws), timeout_s=2)
            self.assertFalse(result["ok"])
            self.assertEqual(result["error"], "EPATH")

    def test_nofile_limit_is_applied(self):
        code = """
import os
fds = []
for i in range(100):
    try:
        fds.append(os.open('/dev/null', os.O_RDONLY))
    except OSError as exc:
        print('failed', i, exc.errno, exc.strerror)
        break
else:
    print('opened all')
"""
        result = run_code(code, timeout_s=3, nofile=32)
        self.assertTrue(result["ok"])
        self.assertEqual(result["exit_code"], 0)  # 脚本自己捕获了 OSError
        self.assertIn("failed", result["stdout"])
        self.assertIn("Too many open files", result["stdout"])

    def test_decode_wait_status(self):
        exited = decode_wait_status(0x2A00)
        self.assertEqual(exited["kind"], "exited")
        self.assertEqual(exited["exit_code"], 42)
        self.assertEqual(exited["raw"], "0x2a00")

        signaled = decode_wait_status(0x000F)
        self.assertEqual(signaled["kind"], "signaled")
        self.assertEqual(signaled["signal"], signal.SIGTERM)
        self.assertIsNone(signaled["exit_code"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
