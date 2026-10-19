"""Agent 状态：世界引用、任务、会话、控制。"""

from __future__ import annotations

import time
from dataclasses import dataclass, field
from typing import Any

from sandbox.policy import Workspace


@dataclass
class TaskState:
    goal: str
    done: bool = False
    answer: str | None = None
    last_test_ok: bool = False
    constraints: list[str] = field(default_factory=list)


@dataclass
class ControlState:
    max_steps: int = 12
    max_tool_calls: int = 10
    wall_seconds: float = 20.0
    steps: int = 0
    tool_calls: int = 0
    stop_reason: str | None = None
    started_at: float = field(default_factory=time.monotonic)

    def spend_step(self) -> bool:
        if self.steps >= self.max_steps:
            self.stop_reason = "max_steps"
            return False
        if self.wall_left() <= 0:
            self.stop_reason = "wall_timeout"
            return False
        self.steps += 1
        return True

    def spend_tool(self) -> bool:
        if self.tool_calls >= self.max_tool_calls:
            self.stop_reason = "max_tool_calls"
            return False
        self.tool_calls += 1
        return True

    def wall_left(self) -> float:
        return self.wall_seconds - (time.monotonic() - self.started_at)


@dataclass
class Message:
    role: str
    name: str | None
    content: Any

    def to_dict(self) -> dict[str, Any]:
        return {"role": self.role, "name": self.name, "content": self.content}


@dataclass
class State:
    workspace: Workspace
    task: TaskState
    control: ControlState = field(default_factory=ControlState)
    messages: list[Message] = field(default_factory=list)
    world_version: str = "v1"

    def add_tool_result(self, name: str, result: dict[str, Any]) -> None:
        self.messages.append(Message(role="tool", name=name, content=result))

    def snapshot(self) -> dict[str, Any]:
        return {
            "task": {
                "goal": self.task.goal,
                "done": self.task.done,
                "answer": self.task.answer,
                "last_test_ok": self.task.last_test_ok,
                "constraints": list(self.task.constraints),
            },
            "control": {
                "steps": self.control.steps,
                "tool_calls": self.control.tool_calls,
                "stop_reason": self.control.stop_reason,
            },
            "world_version": self.world_version,
            "messages": len(self.messages),
            "files": sorted(
                str(p.relative_to(self.workspace.root))
                for p in self.workspace.root.rglob("*")
                if p.is_file() and ".git" not in p.parts and "__pycache__" not in p.parts
            )[:50],
        }
