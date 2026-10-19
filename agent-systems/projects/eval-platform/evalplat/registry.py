"""工具注册表：版本、schema、权限、执行统计。"""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass, field
from typing import Any, Callable


class RegistryError(Exception):
    def __init__(self, code: str, message: str):
        super().__init__(message)
        self.code = code
        self.message = message


@dataclass(frozen=True)
class Tool:
    name: str
    version: str
    description: str
    schema: dict[str, Any]
    cost_units: int
    latency_ms: int
    scope: str
    handler: Callable[[dict[str, Any]], dict[str, Any]]

    @property
    def key(self) -> str:
        return f"{self.name}@{self.version}"


@dataclass
class ToolRegistry:
    tools: dict[str, Tool] = field(default_factory=dict)

    def register(self, tool: Tool) -> None:
        if tool.name in self.tools:
            raise RegistryError("EDUP", f"tool already registered: {tool.name}")
        self.tools[tool.name] = tool

    def get(self, name: str, version: str | None = None) -> Tool:
        tool = self.tools.get(name)
        if tool is None:
            raise RegistryError("ENOTOOL", f"unknown tool: {name}")
        if version is not None and tool.version != version:
            raise RegistryError("EVERSION", f"{name} has {tool.version}, not {version}")
        return tool

    def validate(self, name: str, args: dict[str, Any], *, scope: str) -> Tool:
        tool = self.get(name)
        if tool.scope != scope:
            raise RegistryError("EPERM", f"scope {scope} cannot call {tool.scope}")
        if not isinstance(args, dict):
            raise RegistryError("EINVAL", "arguments must be an object")
        schema = tool.schema
        for key in schema.get("required", []):
            if key not in args:
                raise RegistryError("EINVAL", f"missing required field: {key}")
        props = schema.get("properties", {})
        if schema.get("additionalProperties") is False:
            extra = set(args) - set(props)
            if extra:
                raise RegistryError("EINVAL", f"unexpected fields: {sorted(extra)}")
        for key, rule in props.items():
            if key not in args:
                continue
            typ = rule.get("type")
            py = {"string": str, "integer": int, "boolean": bool}.get(typ)
            if py is not None and not isinstance(args[key], py):
                raise RegistryError("EINVAL", f"field {key} must be {typ}")
            if "maximum" in rule and isinstance(args[key], int) and args[key] > rule["maximum"]:
                raise RegistryError("EINVAL", f"field {key} exceeds maximum")
        return tool

    def signature(self) -> str:
        payload = json.dumps(
            [{"name": t.name, "version": t.version, "schema": t.schema}
             for t in sorted(self.tools.values(), key=lambda x: x.name)],
            sort_keys=True, separators=(",", ":"), ensure_ascii=False,
        ).encode()
        return hashlib.sha256(payload).hexdigest()[:16]
