"""项目一：沙箱 runner 的回归测试。"""
from __future__ import annotations

import os
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sandbox.runner import Limits, run_command  # noqa: E402


class SandboxTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="as-sandbox-")
        self.cwd = Path(self.tmp.name)

    def tearDown(self):
        self.tmp.cleanup()

    def test_normal_exit(self):
        r = run_command([sys.executable, "-c", "print('ok')"], cwd=self.cwd, timeout_s=3)
        self.assertTrue(r.ok)
        self.assertEqual(r.stdout.strip(), "ok")

    def test_nonzero_exit(self):
        r = run_command([sys.executable, "-c", "import sys; sys.exit(42)"],
                        cwd=self.cwd, timeout_s=3)
        self.assertFalse(r.ok)
        self.assertEqual(r.exit_code, 42)

    def test_timeout_kills_process_group(self):
        r = run_command([sys.executable, "-c", "import time; time.sleep(10)"],
                        cwd=self.cwd, timeout_s=0.5)
        self.assertTrue(r.timed_out)
        self.assertLess(r.duration_ms, 3000)

    def test_output_is_truncated(self):
        r = run_command([sys.executable, "-c", "print('x' * 200000)"],
                        cwd=self.cwd, timeout_s=3,
                        limits=Limits(output_bytes=1024))
        self.assertTrue(r.ok)
        self.assertTrue(r.truncated)
        self.assertLessEqual(len(r.stdout), 1024)

    def test_file_size_limit(self):
        r = run_command(
            [sys.executable, "-c",
             "open('big.bin','wb').write(b'x' * (2 << 20))"],
            cwd=self.cwd, timeout_s=3,
            limits=Limits(file_size_bytes=64 << 10),
        )
        self.assertFalse(r.ok)
        # SIGXFSZ 或 Python 的 OSError/SIGKILL，均说明限额生效
        self.assertIn(r.exit_code, (-25, -9, 1))

    def test_cwd_must_exist(self):
        with self.assertRaises(NotADirectoryError):
            run_command([sys.executable, "-c", "pass"], cwd=self.cwd / "nope")


if __name__ == "__main__":
    unittest.main(verbosity=2)
