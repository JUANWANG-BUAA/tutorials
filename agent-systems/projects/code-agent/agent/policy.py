"""确定性策略：够用来演示循环、工具与失败路径。

真实系统会在这里接 LLM；循环、预算、工具、trace 不需要改（第 1.7.5 节）。
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from agent.state import State


@dataclass
class Action:
    tool: str
    args: dict[str, Any]


class ScriptedPolicy:
    """根据会话状态选择动作；不使用模型，保证实验可复现。"""

    def __init__(self, mode: str = "good") -> None:
        self.mode = mode

    def next(self, state: State) -> Action:
        if self.mode == "loop":
            return Action("fs.read", {"path": "calc.py"})
        if self.mode == "escape":
            return Action("fs.read", {"path": "../secret.txt"})

        results = [m for m in state.messages if m.role == "tool"]
        # 1) 先读源码
        if not any(m.name == "fs.read" for m in results):
            return Action("fs.read", {"path": "calc.py"})
        # 2) 打补丁
        if not any(m.name == "patch.apply" for m in results):
            return Action("patch.apply", {
                "path": "calc.py",
                "old": "return a - b",
                "new": "return a + b",
            })
        # 3) 跑测试
        if not any(m.name == "test.run" for m in results):
            return Action("test.run", {})
        # 4) 测试通过才提交；否则重跑一次再放弃
        if state.task.last_test_ok:
            return Action("task.finish", {"answer": "fixed add(): a + b"})
        test_runs = [m for m in results if m.name == "test.run"]
        if len(test_runs) < 2:
            return Action("test.run", {})
        return Action("task.finish", {"answer": "tests still failing"})
