"""工具契约、注册表与内置工具。"""

from __future__ import annotations

import hashlib
import sys
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Any, Callable

from agent.state import State
from sandbox.policy import EgressPolicy, PolicyError, Workspace
from sandbox.runner import Limits, RunResult, run_command


@dataclass(frozen=True)
class ToolSpec:
    name: str
    description: str
    input_schema: dict[str, Any]
    effect: str
    idempotency: str
    auth_scope: str
    handler: Callable[[State, dict[str, Any], "ToolContext"], dict[str, Any]]
    precondition: Callable[[State, dict[str, Any]], str | None] | None = None
    cost: dict[str, Any] = field(default_factory=dict)


@dataclass
class ToolContext:
    workspace: Workspace
    egress: EgressPolicy
    limits: Limits
    allowed_scopes: set[str]


class ToolError(Exception):
    def __init__(self, code: str, message: str, *,
                 retryable: bool = False, suggested_action: str = "stop"):
        super().__init__(message)
        self.code = code
        self.message = message
        self.retryable = retryable
        self.suggested_action = suggested_action


def _now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="milliseconds").replace("+00:00", "Z")


def _sha(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()[:16]


def _require(args: dict[str, Any], key: str, typ: type) -> Any:
    if key not in args:
        raise ToolError("EINVAL", f"missing required field: {key}", suggested_action="fix_args")
    if not isinstance(args[key], typ):
        raise ToolError("EINVAL", f"field {key} must be {typ.__name__}",
                        suggested_action="fix_args")
    return args[key]


# --------------------------------------------------------------------------- #
# handlers
# --------------------------------------------------------------------------- #

def fs_read(state: State, args: dict[str, Any], ctx: ToolContext) -> dict[str, Any]:
    rel = _require(args, "path", str)
    path = ctx.workspace.resolve(rel, must_exist=True)
    if not path.is_file():
        raise ToolError("EISDIR", f"not a regular file: {rel}")
    if path.stat().st_size > 256 << 10:
        raise ToolError("EFBIG", f"file too large: {rel}", suggested_action="read_range")
    content = path.read_text(encoding="utf-8", errors="replace")
    return {"data": {"path": rel, "content": content, "sha256": _sha(content)},
            "refs": [{"kind": "file", "path": rel, "sha256": _sha(content)}]}


def fs_write(state: State, args: dict[str, Any], ctx: ToolContext) -> dict[str, Any]:
    rel = _require(args, "path", str)
    content = _require(args, "content", str)
    if len(content.encode()) > 100 << 10:
        raise ToolError("EFBIG", "content exceeds 100 KiB", suggested_action="split_write")
    path = ctx.workspace.resolve(rel)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    state.world_version = "sha:" + _sha(content)
    return {"data": {"path": rel, "bytes": len(content.encode())},
            "refs": [{"kind": "file", "path": rel, "sha256": _sha(content)}]}


def fs_list(state: State, args: dict[str, Any], ctx: ToolContext) -> dict[str, Any]:
    rel = args.get("path", ".")
    if not isinstance(rel, str):
        raise ToolError("EINVAL", "path must be string")
    base = ctx.workspace.resolve(rel)
    files = sorted(
        str(p.relative_to(ctx.workspace.root))
        for p in base.rglob("*")
        if p.is_file() and ".git" not in p.parts
    )[:200]
    return {"data": {"files": files}}


def patch_apply(state: State, args: dict[str, Any], ctx: ToolContext) -> dict[str, Any]:
    rel = _require(args, "path", str)
    old = _require(args, "old", str)
    new = _require(args, "new", str)
    if not old:
        raise ToolError("EINVAL", "old must not be empty", suggested_action="fix_args")
    path = ctx.workspace.resolve(rel, must_exist=True)
    text = path.read_text(encoding="utf-8")
    count = text.count(old)
    if count == 0:
        raise ToolError("ENOMATCH", f"old text not found in {rel}", suggested_action="read_file")
    if count > 1:
        raise ToolError("EAMBIG", f"old text appears {count} times in {rel}",
                        suggested_action="add_context")
    path.write_text(text.replace(old, new, 1), encoding="utf-8")
    state.world_version = "sha:" + _sha(new)
    return {"data": {"path": rel, "replacements": 1},
            "refs": [{"kind": "file", "path": rel, "sha256": _sha(new)}]}


def test_run(state: State, args: dict[str, Any], ctx: ToolContext) -> dict[str, Any]:
    timeout = min(10.0, max(0.5, state.control.wall_left()))
    proc = run_command(
        [sys.executable, "-m", "unittest", "-q"],
        cwd=ctx.workspace.root,
        timeout_s=timeout,
        limits=ctx.limits,
    )
    state.task.last_test_ok = proc.ok
    return {
        "data": {
            "ok": proc.ok,
            "exit_code": proc.exit_code,
            "term_signal": proc.term_signal,
            "timed_out": proc.timed_out,
            "duration_ms": proc.duration_ms,
            "stdout": proc.stdout,
            "stderr": proc.stderr,
            "truncated": proc.truncated,
        },
        "cost": {"latency_ms": proc.duration_ms},
    }


def task_finish(state: State, args: dict[str, Any], ctx: ToolContext) -> dict[str, Any]:
    answer = _require(args, "answer", str)
    if not state.task.last_test_ok:
        raise ToolError("EPRECOND", "tests have not passed; refusing to finish",
                        suggested_action="run_tests")
    state.task.done = True
    state.task.answer = answer
    return {"data": {"answer": answer}}


# --------------------------------------------------------------------------- #
# registry
# --------------------------------------------------------------------------- #

def default_tools() -> list[ToolSpec]:
    return [
        ToolSpec(
            name="fs.read",
            description="读取工作区中的文本文件。",
            input_schema={
                "type": "object",
                "properties": {"path": {"type": "string"}},
                "required": ["path"],
                "additionalProperties": False,
            },
            effect="read",
            idempotency="idempotent",
            auth_scope="workspace:read",
            handler=fs_read,
            cost={"latency_p95_ms": 20},
        ),
        ToolSpec(
            name="fs.write",
            description="写入工作区中的文本文件；会覆盖原内容。",
            input_schema={
                "type": "object",
                "properties": {"path": {"type": "string"}, "content": {"type": "string"}},
                "required": ["path", "content"],
                "additionalProperties": False,
            },
            effect="write",
            idempotency="not_idempotent",
            auth_scope="workspace:write",
            handler=fs_write,
            cost={"latency_p95_ms": 20},
        ),
        ToolSpec(
            name="fs.list",
            description="列出工作区中的文件。",
            input_schema={
                "type": "object",
                "properties": {"path": {"type": "string"}},
                "required": [],
                "additionalProperties": False,
            },
            effect="read",
            idempotency="idempotent",
            auth_scope="workspace:read",
            handler=fs_list,
        ),
        ToolSpec(
            name="patch.apply",
            description="把文件中的一段唯一文本替换为新文本；old 必须恰好出现一次。",
            input_schema={
                "type": "object",
                "properties": {"path": {"type": "string"}, "old": {"type": "string"},
                               "new": {"type": "string"}},
                "required": ["path", "old", "new"],
                "additionalProperties": False,
            },
            effect="write",
            idempotency="not_idempotent",
            auth_scope="workspace:write",
            handler=patch_apply,
            cost={"latency_p95_ms": 30},
        ),
        ToolSpec(
            name="test.run",
            description="在沙箱中运行工作区的单元测试（python -m unittest -q）。",
            input_schema={"type": "object", "properties": {}, "required": [],
                          "additionalProperties": False},
            effect="exec",
            idempotency="idempotent",
            auth_scope="workspace:exec",
            handler=test_run,
            cost={"latency_p95_ms": 2000, "quota": "exec:5/run"},
        ),
        ToolSpec(
            name="task.finish",
            description="提交最终答案；只有测试已通过时才允许。",
            input_schema={
                "type": "object",
                "properties": {"answer": {"type": "string"}},
                "required": ["answer"],
                "additionalProperties": False,
            },
            effect="control",
            idempotency="not_idempotent",
            auth_scope="task:finish",
            handler=task_finish,
            precondition=lambda st, args: None if st.task.last_test_ok else "tests not passed",
        ),
    ]


class ToolRegistry:
    def __init__(self, tools: list[ToolSpec], ctx: ToolContext):
        self._tools = {t.name: t for t in tools}
        self.ctx = ctx

    def specs(self) -> list[ToolSpec]:
        return list(self._tools.values())

    def validate(self, name: str, args: dict[str, Any]) -> ToolSpec:
        spec = self._tools.get(name)
        if spec is None:
            raise ToolError("ENOTOOL", f"unknown tool: {name}", suggested_action="list_tools")
        if spec.auth_scope not in self.ctx.allowed_scopes:
            raise ToolError("EPERM", f"scope not granted: {spec.auth_scope}",
                            suggested_action="request_scope")
        if not isinstance(args, dict):
            raise ToolError("EINVAL", "arguments must be an object")
        required = spec.input_schema.get("required", [])
        for key in required:
            if key not in args:
                raise ToolError("EINVAL", f"missing required field: {key}",
                                suggested_action="fix_args")
        props = spec.input_schema.get("properties", {})
        if spec.input_schema.get("additionalProperties") is False:
            extra = set(args) - set(props)
            if extra:
                raise ToolError("EINVAL", f"unexpected fields: {sorted(extra)}",
                                suggested_action="fix_args")
        for key, rule in props.items():
            if key in args and rule.get("type") == "string" and not isinstance(args[key], str):
                raise ToolError("EINVAL", f"field {key} must be string",
                                suggested_action="fix_args")
        return spec

    def call(self, state: State, name: str, args: dict[str, Any]) -> dict[str, Any]:
        try:
            spec = self.validate(name, args)
        except ToolError as exc:
            return _envelope(False, error={
                "code": exc.code, "message": exc.message, "retryable": exc.retryable,
                "suggested_action": exc.suggested_action})
        if spec.precondition:
            reason = spec.precondition(state, args)
            if reason:
                return _envelope(False, error={
                    "code": "EPRECOND", "message": reason, "retryable": False,
                    "suggested_action": "run_tests"})
        try:
            payload = spec.handler(state, args, self.ctx)
        except PolicyError as exc:
            return _envelope(False, error={
                "code": exc.code, "message": exc.message, "retryable": False,
                "suggested_action": "stop"})
        except ToolError as exc:
            return _envelope(False, error={
                "code": exc.code, "message": exc.message, "retryable": exc.retryable,
                "suggested_action": exc.suggested_action})
        except (OSError, ValueError) as exc:
            return _envelope(False, error={
                "code": "EIO", "message": str(exc), "retryable": False,
                "suggested_action": "retry_once"})
        return _envelope(True, data=payload.get("data"), refs=payload.get("refs"),
                         cost=payload.get("cost"))


def _envelope(ok: bool, *, data: Any = None, error: dict[str, Any] | None = None,
              refs: list[dict[str, Any]] | None = None,
              cost: dict[str, Any] | None = None) -> dict[str, Any]:
    return {
        "ok": ok,
        "data": data,
        "error": error,
        "refs": refs or [],
        "cost": cost or {},
        "observed_at": _now(),
    }
