"""最小可控 agent：预算、指纹、工具、trace。"""

from __future__ import annotations

import hashlib
import json
import time
from pathlib import Path
from typing import Any

from agent.policy import Action, ScriptedPolicy
from agent.state import ControlState, State, TaskState
from agent.tools import ToolContext, ToolRegistry, default_tools
from agent.trace import TraceWriter
from sandbox.policy import EgressPolicy, Workspace
from sandbox.runner import Limits


def _fingerprint(action: dict[str, Any], result: dict[str, Any], world_version: str) -> str:
    payload = json.dumps({"a": action, "o": result, "w": world_version},
                         sort_keys=True, separators=(",", ":"), ensure_ascii=False)
    return hashlib.sha256(payload.encode()).hexdigest()[:12]


class Agent:
    def __init__(
        self,
        workspace: Workspace,
        *,
        policy: ScriptedPolicy | None = None,
        limits: Limits | None = None,
        trace_path: str | Path | None = None,
        max_steps: int = 12,
        max_tool_calls: int = 10,
        wall_seconds: float = 20.0,
        allowed_scopes: set[str] | None = None,
    ):
        self.workspace = workspace
        self.policy = policy or ScriptedPolicy("good")
        self.limits = limits or Limits()
        self.trace = TraceWriter(trace_path)
        self.control = ControlState(max_steps=max_steps, max_tool_calls=max_tool_calls,
                                    wall_seconds=wall_seconds)
        scopes = allowed_scopes or {"workspace:read", "workspace:write",
                                    "workspace:exec", "task:finish"}
        ctx = ToolContext(workspace=workspace, egress=EgressPolicy(),
                          limits=self.limits, allowed_scopes=scopes)
        self.registry = ToolRegistry(default_tools(), ctx)

    def run(self, goal: str = "fix add()") -> dict[str, Any]:
        state = State(
            workspace=self.workspace,
            task=TaskState(goal=goal, constraints=["do not touch tests"]),
            control=self.control,
        )
        window: list[str] = []
        started = time.monotonic()

        while not state.task.done:
            if not state.control.spend_step():
                break
            try:
                action = self.policy.next(state)
            except Exception as exc:  # noqa: BLE001 - 策略失败也要可观察
                state.control.stop_reason = "policy_error"
                self.trace.write({"step": state.control.steps, "error": repr(exc),
                                  "state": state.snapshot()})
                break

            before = {"steps_left": state.control.max_steps - state.control.steps,
                      "tools_left": state.control.max_tool_calls - state.control.tool_calls}
            t0 = time.monotonic()
            if not state.control.spend_tool():
                result = {"ok": False, "error": {"code": "EBUDGET", "message": "tool budget exhausted"},
                          "data": None, "refs": [], "cost": {}}
            else:
                result = self.registry.call(state, action.tool, action.args)
            duration_ms = int((time.monotonic() - t0) * 1000)

            state.add_tool_result(action.tool, result)
            step = {
                "step": state.control.steps,
                "decision": {"tool": action.tool, "args": action.args},
                "result": result,
                "duration_ms": duration_ms,
                "budget_before": before,
                "state": state.snapshot(),
            }
            self.trace.write(step)

            fp = _fingerprint({"tool": action.tool, "args": action.args},
                              result, state.world_version)
            window.append(fp)
            window = window[-3:]
            if len(window) == 3 and len(set(window)) == 1:
                state.control.stop_reason = "no_progress"
                break

        if state.task.done:
            state.control.stop_reason = "done"
        elif state.control.stop_reason is None:
            state.control.stop_reason = "unknown"

        return {
            "goal": goal,
            "stop_reason": state.control.stop_reason,
            "steps": state.control.steps,
            "tool_calls": state.control.tool_calls,
            "answer": state.task.answer,
            "duration_ms": int((time.monotonic() - started) * 1000),
            "trace": self.trace.records,
        }
