#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""mini_loop.py — 第 1 章的最小 agent 内核（无网络、无第三方依赖）。

它只做五件事：
  1. 维护四层状态（世界 / 任务 / 会话 / 控制）；
  2. 从「模型」拿到一个动作（这里用确定性策略代替 LLM）；
  3. 按工具契约校验参数并执行；
  4. 把观察写回状态；
  5. 在目标达成或预算耗尽时停止，并把每一步写成 JSONL trace。

用法：
    python3 mini_loop.py --task sum --mode good
    python3 mini_loop.py --task sum --mode loop     # 演示死循环与预算终止
    python3 mini_loop.py --task sum --mode badarg   # 演示参数校验失败

设计约束（与正文一致）：
  - 模型只产出「意图 + 参数」，不直接执行任何副作用；
  - 工具返回结构化结果（ok/error），错误也进入观察，而不是抛穿循环；
  - 终止条件由宿主判定，模型不能自己宣布「我完成了」而不经过 finish 工具；
  - 每步都扣预算，trace 中记录余额。
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import tempfile
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Any, Callable

# --------------------------------------------------------------------------- #
# 状态
# --------------------------------------------------------------------------- #


@dataclass
class World:
    """世界状态：agent 之外、可被工具改变的事实。"""

    root: Path
    files: dict[str, str] = field(default_factory=dict)


@dataclass
class Task:
    """任务状态：目标与验收条件。"""

    name: str
    goal: str
    done: bool = False
    answer: str | None = None


@dataclass
class Session:
    """会话状态：消息与工具结果，按时间顺序。"""

    messages: list[dict[str, Any]] = field(default_factory=list)


@dataclass
class Control:
    """控制状态：预算、步数、终止原因。"""

    max_steps: int = 8
    max_tool_calls: int = 6
    steps: int = 0
    tool_calls: int = 0
    stop_reason: str | None = None

    def spend_step(self) -> bool:
        if self.steps >= self.max_steps:
            self.stop_reason = "max_steps"
            return False
        self.steps += 1
        return True

    def spend_tool(self) -> bool:
        if self.tool_calls >= self.max_tool_calls:
            self.stop_reason = "max_tool_calls"
            return False
        self.tool_calls += 1
        return True


@dataclass
class State:
    world: World
    task: Task
    session: Session = field(default_factory=Session)
    control: Control = field(default_factory=Control)

    def snapshot(self) -> dict[str, Any]:
        """给 trace 用的可序列化快照；不要塞进不可序列化对象。"""
        return {
            "task": {"name": self.task.name, "goal": self.task.goal,
                     "done": self.task.done, "answer": self.task.answer},
            "control": asdict(self.control),
            "messages": len(self.session.messages),
            "files": sorted(self.world.files),
        }


# --------------------------------------------------------------------------- #
# 工具：契约 + 执行
# --------------------------------------------------------------------------- #


@dataclass(frozen=True)
class ToolSpec:
    name: str
    description: str
    schema: dict[str, Any]
    fn: Callable[[State, dict[str, Any]], dict[str, Any]]
    idempotent: bool = False
    reversible: bool = True


def _require(args: dict[str, Any], key: str, typ: type) -> Any:
    if key not in args:
        raise ValueError(f"missing required field: {key}")
    value = args[key]
    if not isinstance(value, typ):
        raise ValueError(f"field {key} must be {typ.__name__}, got {type(value).__name__}")
    return value


def tool_read(state: State, args: dict[str, Any]) -> dict[str, Any]:
    path = _require(args, "path", str)
    if path not in state.world.files:
        return {"ok": False, "error": "ENOENT", "path": path}
    return {"ok": True, "path": path, "content": state.world.files[path]}


def tool_write(state: State, args: dict[str, Any]) -> dict[str, Any]:
    path = _require(args, "path", str)
    content = _require(args, "content", str)
    # 沙箱边界：只允许写 root 下的相对路径；第 3 章会把这里换成真正的 rootfs 检查。
    if path.startswith("/") or ".." in Path(path).parts:
        return {"ok": False, "error": "EPERM", "path": path}
    state.world.files[path] = content
    return {"ok": True, "path": path, "bytes": len(content.encode("utf-8"))}


def tool_finish(state: State, args: dict[str, Any]) -> dict[str, Any]:
    answer = _require(args, "answer", str)
    state.task.done = True
    state.task.answer = answer
    return {"ok": True, "answer": answer}


TOOLS: dict[str, ToolSpec] = {
    "fs.read": ToolSpec(
        name="fs.read",
        description="读取沙箱工作区中的一个文本文件",
        schema={
            "type": "object",
            "properties": {"path": {"type": "string"}},
            "required": ["path"],
            "additionalProperties": False,
        },
        fn=tool_read,
        idempotent=True,
    ),
    "fs.write": ToolSpec(
        name="fs.write",
        description="写入沙箱工作区中的一个文本文件",
        schema={
            "type": "object",
            "properties": {
                "path": {"type": "string"},
                "content": {"type": "string"},
            },
            "required": ["path", "content"],
            "additionalProperties": False,
        },
        fn=tool_write,
        idempotent=False,
    ),
    "task.finish": ToolSpec(
        name="task.finish",
        description="提交最终答案并结束任务",
        schema={
            "type": "object",
            "properties": {"answer": {"type": "string"}},
            "required": ["answer"],
            "additionalProperties": False,
        },
        fn=tool_finish,
        idempotent=False,
        reversible=False,
    ),
}


def validate(spec: ToolSpec, args: dict[str, Any]) -> str | None:
    """一个够用的 JSON Schema 子集校验器；生产代码请用 jsonschema。"""
    schema = spec.schema
    if not isinstance(args, dict):
        return "arguments must be an object"
    for key in schema.get("required", []):
        if key not in args:
            return f"missing required field: {key}"
    if schema.get("additionalProperties") is False:
        extra = set(args) - set(schema.get("properties", {}))
        if extra:
            return f"unexpected fields: {sorted(extra)}"
    for key, rule in schema.get("properties", {}).items():
        if key in args and rule.get("type") == "string" and not isinstance(args[key], str):
            return f"field {key} must be string"
    return None


def call_tool(state: State, name: str, args: dict[str, Any]) -> dict[str, Any]:
    spec = TOOLS.get(name)
    if spec is None:
        return {"ok": False, "error": "ENOTOOL", "tool": name}
    if err := validate(spec, args):
        return {"ok": False, "error": "EINVAL", "detail": err}
    try:
        return spec.fn(state, args)
    except ValueError as exc:
        return {"ok": False, "error": "EINVAL", "detail": str(exc)}


# --------------------------------------------------------------------------- #
# 确定性「模型」：只产出动作，不执行
# --------------------------------------------------------------------------- #


def policy(state: State, mode: str) -> dict[str, Any]:
    """一个按状态出招的确定性策略，替代 LLM。

    good：读文件 → 求和 → 写结果 → finish
    loop：永远读同一个文件（演示预算终止）
    badarg：故意多带一个字段（演示 schema 校验）
    """
    if mode == "loop":
        return {"tool": "fs.read", "args": {"path": "numbers.txt"}}
    seen = [m for m in state.session.messages if m.get("role") == "tool"]
    if not seen:
        return {"tool": "fs.read", "args": {"path": "numbers.txt"}}
    if mode == "badarg":
        return {"tool": "fs.read", "args": {"path": "numbers.txt", "limit": 10}}
    content = None
    for m in seen:
        if m.get("name") == "fs.read" and m.get("result", {}).get("ok"):
            content = m["result"].get("content")
    if content is None:
        return {"tool": "task.finish", "args": {"answer": "read failed"}}
    total = sum(int(x) for x in content.split())
    if not any(m.get("name") == "fs.write" for m in seen):
        return {"tool": "fs.write", "args": {"path": "sum.txt", "content": str(total)}}
    return {"tool": "task.finish", "args": {"answer": f"sum={total}"}}


# --------------------------------------------------------------------------- #
# 循环与 trace
# --------------------------------------------------------------------------- #


def run(task_name: str, mode: str = "good", workdir: str | None = None,
        trace_path: str | None = None, max_steps: int = 8) -> dict[str, Any]:
    root = Path(workdir or tempfile.mkdtemp(prefix="mini-loop-"))
    root.mkdir(parents=True, exist_ok=True)
    files = {"numbers.txt": "3 1 4 1 5 9\n"} if task_name == "sum" else {}
    state = State(
        world=World(root=root, files=files),
        task=Task(name=task_name, goal="读取 numbers.txt，求和并写入 sum.txt"),
        control=Control(max_steps=max_steps),
    )
    trace: list[dict[str, Any]] = []

    while not state.task.done:
        if not state.control.spend_step():
            break
        action = policy(state, mode)
        step = {
            "step": state.control.steps,
            "decision": action,
            "budget_before": {"steps_left": state.control.max_steps - state.control.steps,
                              "tools_left": state.control.max_tool_calls - state.control.tool_calls},
        }
        if not state.control.spend_tool():
            step["result"] = {"ok": False, "error": "EBUDGET", "detail": "tool budget exhausted"}
        else:
            step["result"] = call_tool(state, action["tool"], action.get("args", {}))
        state.session.messages.append(
            {"role": "tool", "name": action["tool"], "result": step["result"]}
        )
        step["state"] = state.snapshot()
        trace.append(step)

    if state.task.done:
        state.control.stop_reason = "done"
    elif state.control.stop_reason is None:
        state.control.stop_reason = "unknown"

    out = {
        "task": task_name,
        "mode": mode,
        "stop_reason": state.control.stop_reason,
        "steps": state.control.steps,
        "answer": state.task.answer,
        "files": sorted(state.world.files),
        "sum_txt": state.world.files.get("sum.txt"),
        "trace": trace,
    }
    if trace_path:
        with open(trace_path, "w", encoding="utf-8") as fh:
            for row in trace:
                fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")
    return out


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="第 1 章最小 agent 内核")
    ap.add_argument("--task", default="sum", choices=["sum"])
    ap.add_argument("--mode", default="good", choices=["good", "loop", "badarg"])
    ap.add_argument("--trace", default=None, help="trace JSONL 输出路径")
    ap.add_argument("--max-steps", type=int, default=8)
    args = ap.parse_args(argv)
    result = run(args.task, args.mode, trace_path=args.trace, max_steps=args.max_steps)
    slim = {k: v for k, v in result.items() if k != "trace"}
    slim["trace_steps"] = len(result["trace"])
    print(json.dumps(slim, ensure_ascii=False, indent=2, sort_keys=True))
    if result["trace"]:
        print("\nlast step:")
        print(json.dumps(result["trace"][-1], ensure_ascii=False, indent=2, sort_keys=True))
    return 0 if result["stop_reason"] == "done" else 2


if __name__ == "__main__":
    sys.exit(main())
