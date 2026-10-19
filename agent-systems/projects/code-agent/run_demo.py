#!/usr/bin/env python3
"""项目一 demo：修一个 off-by-one 的 add()，跑测试，输出 trace。

用法：
    python3 run_demo.py --mode good --trace /tmp/code-agent.jsonl
    python3 run_demo.py --mode loop --max-steps 5
    python3 run_demo.py --mode escape
"""
from __future__ import annotations

import argparse
import json
import tempfile
from pathlib import Path

from agent.loop import Agent
from agent.policy import ScriptedPolicy
from sandbox.policy import Workspace

CALC = "def add(a, b):\n    return a - b\n"
TEST = '''import unittest
from calc import add

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
'''


def make_workspace(root: Path) -> None:
    (root / "calc.py").write_text(CALC, encoding="utf-8")
    (root / "test_calc.py").write_text(TEST, encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mode", default="good", choices=["good", "loop", "escape"])
    ap.add_argument("--max-steps", type=int, default=12)
    ap.add_argument("--trace", default=None)
    ap.add_argument("--keep", action="store_true")
    args = ap.parse_args()

    tmp = tempfile.mkdtemp(prefix="as-code-agent-")
    root = Path(tmp)
    make_workspace(root)
    agent = Agent(Workspace(root), policy=ScriptedPolicy(args.mode),
                  trace_path=args.trace, max_steps=args.max_steps)
    out = agent.run("fix add() so tests pass")
    slim = {k: v for k, v in out.items() if k != "trace"}
    slim["workspace"] = str(root)
    slim["trace_steps"] = len(out["trace"])
    print(json.dumps(slim, ensure_ascii=False, indent=2, sort_keys=True))
    if out["trace"]:
        print("\nlast step:")
        print(json.dumps(out["trace"][-1], ensure_ascii=False, indent=2, sort_keys=True))
    if not args.keep:
        import shutil
        shutil.rmtree(root, ignore_errors=True)
    return 0 if out["stop_reason"] == "done" else 2


if __name__ == "__main__":
    raise SystemExit(main())
