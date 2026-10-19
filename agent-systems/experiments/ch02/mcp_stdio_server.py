#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 2 章实验：手写 MCP stdio server（不依赖 MCP SDK）。

支持两个协议时代：

  --era 2026   2026-07-28：无状态、server/discover、resultType、MRTR
  --era 2025   2025-11-25：initialize 握手 + notifications/initialized

实现的是刻意收窄的子集：tools / resources / prompts，以及 2025 的
ping、logging/setLevel、resources/subscribe。它是教学件，不是框架。

协议帧是换行分隔的 JSON-RPC 2.0；stdout 只写协议帧，日志一律走 stderr。
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import hmac
import json
import secrets
import sys
import tempfile
import time
from pathlib import Path
from typing import Any

VERSION_2026 = "2026-07-28"
VERSION_2025 = "2025-11-25"
SERVER_INFO = {"name": "ch02-stdio-server", "version": "1.0.0"}

# JSON Schema 里只实现本章用到的子集；真实实现应使用完整校验器。
def validate(schema: dict[str, Any], value: Any, path: str = "$") -> list[str]:
    errors: list[str] = []
    expected = schema.get("type")
    if expected == "object":
        if not isinstance(value, dict):
            return [f"{path}: expected object, got {type(value).__name__}"]
        props = schema.get("properties", {})
        for key in schema.get("required", []):
            if key not in value:
                errors.append(f"{path}.{key}: required property is missing")
        if schema.get("additionalProperties") is False:
            for key in value:
                if key not in props:
                    errors.append(f"{path}.{key}: unexpected property")
        for key, sub in props.items():
            if key in value:
                errors.extend(validate(sub, value[key], f"{path}.{key}"))
    elif expected == "string":
        if not isinstance(value, str):
            return [f"{path}: expected string, got {type(value).__name__}"]
        if "minLength" in schema and len(value) < schema["minLength"]:
            errors.append(f"{path}: shorter than {schema['minLength']}")
        if "maxLength" in schema and len(value) > schema["maxLength"]:
            errors.append(f"{path}: longer than {schema['maxLength']}")
        if "pattern" in schema:
            import re

            if re.search(schema["pattern"], value) is None:
                errors.append(f"{path}: does not match {schema['pattern']}")
    elif expected == "integer":
        if isinstance(value, bool) or not isinstance(value, int):
            return [f"{path}: expected integer, got {type(value).__name__}"]
        if "minimum" in schema and value < schema["minimum"]:
            errors.append(f"{path}: less than {schema['minimum']}")
        if "maximum" in schema and value > schema["maximum"]:
            errors.append(f"{path}: greater than {schema['maximum']}")
    elif expected == "number":
        if isinstance(value, bool) or not isinstance(value, (int, float)):
            return [f"{path}: expected number, got {type(value).__name__}"]
        if "minimum" in schema and value < schema["minimum"]:
            errors.append(f"{path}: less than {schema['minimum']}")
        if "maximum" in schema and value > schema["maximum"]:
            errors.append(f"{path}: greater than {schema['maximum']}")
    elif expected == "boolean":
        if not isinstance(value, bool):
            return [f"{path}: expected boolean, got {type(value).__name__}"]
    if "enum" in schema and value not in schema["enum"]:
        errors.append(f"{path}: not one of {schema['enum']}")
    return errors


def error_payload(code: str, message: str, *, retryable: bool = False) -> dict[str, Any]:
    return {"error": {"code": code, "message": message, "retryable": retryable}}


class BadState(Exception):
    """requestState 被篡改、过期或与参数不符。"""


class Server:
    def __init__(self, era: str, root: Path) -> None:
        self.era = era
        self.root = root.resolve()
        self.root.mkdir(parents=True, exist_ok=True)
        self.handshaken = False
        self.ready = False
        self.log_level = "info"
        self.subscribed = False
        self.state_key = secrets.token_bytes(32)
        self.tools = self._build_tools()

    # ---------- 协议输出 ----------

    def send(self, message: dict[str, Any]) -> None:
        line = json.dumps(message, ensure_ascii=False, separators=(",", ":"))
        assert "\n" not in line, "stdio 帧内不能有裸换行"
        sys.stdout.write(line + "\n")
        sys.stdout.flush()

    def log(self, message: str) -> None:
        print(f"[server:{self.era}] {message}", file=sys.stderr, flush=True)

    def result(self, req_id: Any, payload: dict[str, Any]) -> dict[str, Any]:
        if self.era == "2026":
            payload = {"resultType": "complete", **payload}
        return {"jsonrpc": "2.0", "id": req_id, "result": payload}

    def error(
        self,
        req_id: Any,
        code: int,
        message: str,
        data: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        err: dict[str, Any] = {"code": code, "message": message}
        if data is not None:
            err["data"] = data
        return {"jsonrpc": "2.0", "id": req_id, "error": err}

    # ---------- 工具与资源 ----------

    def _build_tools(self) -> dict[str, dict[str, Any]]:
        tools: dict[str, dict[str, Any]] = {
            "fs.read": {
                "name": "fs.read",
                "title": "Read a text file",
                "description": (
                    "读取 workspace 根目录内的 UTF-8 文本文件。path 必须是相对路径；"
                    "不要用于读取二进制文件或目录。"
                ),
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "path": {"type": "string", "minLength": 1, "maxLength": 200}
                    },
                    "required": ["path"],
                    "additionalProperties": False,
                },
                "outputSchema": {
                    "type": "object",
                    "properties": {
                        "path": {"type": "string"},
                        "bytes": {"type": "integer", "minimum": 0},
                        "content": {"type": "string"},
                    },
                    "required": ["path", "bytes", "content"],
                    "additionalProperties": False,
                },
                "annotations": {
                    "readOnlyHint": True,
                    "destructiveHint": False,
                    "idempotentHint": True,
                    "openWorldHint": False,
                },
            },
            "calc.add": {
                "name": "calc.add",
                "title": "Add two numbers",
                "description": "返回两个有限数值之和。仅用于算术，不执行表达式或代码。",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "a": {"type": "number", "minimum": -1000000, "maximum": 1000000},
                        "b": {"type": "number", "minimum": -1000000, "maximum": 1000000},
                    },
                    "required": ["a", "b"],
                    "additionalProperties": False,
                },
                "outputSchema": {
                    "type": "object",
                    "properties": {"sum": {"type": "number"}},
                    "required": ["sum"],
                    "additionalProperties": False,
                },
                "annotations": {
                    "readOnlyHint": True,
                    "destructiveHint": False,
                    "idempotentHint": True,
                    "openWorldHint": False,
                },
            },
        }
        if self.era == "2026":
            tools["fs.write"] = {
                "name": "fs.write",
                "title": "Write a text file (with confirmation)",
                "description": (
                    "在 workspace 根目录内写入 UTF-8 文本文件。写入前 server 会通过 "
                    "MRTR 请求用户确认；确认信息由客户端回传，不占工具参数。"
                ),
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "path": {"type": "string", "minLength": 1, "maxLength": 200},
                        "content": {"type": "string", "maxLength": 4096},
                    },
                    "required": ["path", "content"],
                    "additionalProperties": False,
                },
                "outputSchema": {
                    "type": "object",
                    "properties": {
                        "path": {"type": "string"},
                        "bytes": {"type": "integer", "minimum": 0},
                        "sha256": {"type": "string"},
                    },
                    "required": ["path", "bytes", "sha256"],
                    "additionalProperties": False,
                },
                "annotations": {
                    "readOnlyHint": False,
                    "destructiveHint": True,
                    "idempotentHint": True,
                    "openWorldHint": False,
                },
            }
        return tools

    def resources(self) -> list[dict[str, Any]]:
        uri = (self.root / "seed.txt").as_uri()
        return [
            {
                "uri": uri,
                "name": "seed.txt",
                "title": "Seed file",
                "description": "实验用的只读文本文件",
                "mimeType": "text/plain",
                "annotations": {"audience": ["assistant"], "priority": 0.5},
            }
        ]

    def prompts(self) -> list[dict[str, Any]]:
        return [
            {
                "name": "summarize",
                "title": "Summarize a workspace file",
                "description": "生成一条要求模型总结指定文件的用户消息。",
                "arguments": [
                    {"name": "path", "description": "相对 workspace 根目录的路径", "required": True}
                ],
            }
        ]

    def read_text(self, rel: str) -> tuple[Path, str]:
        candidate = Path(rel)
        if candidate.is_absolute():
            raise PermissionError("absolute path is not allowed")
        target = (self.root / candidate).resolve()
        if target != self.root and self.root not in target.parents:
            raise PermissionError("path escapes workspace root")
        if not target.is_file():
            raise FileNotFoundError(rel)
        return target, target.read_text(encoding="utf-8")

    def tool_result(
        self, payload: dict[str, Any], *, is_error: bool | None = None
    ) -> dict[str, Any]:
        # 没有显式指定时，按载荷形状推断：含 error 字段即工具执行错误。
        if is_error is None:
            is_error = "error" in payload
        body: dict[str, Any] = {
            "content": [
                {"type": "text", "text": json.dumps(payload, ensure_ascii=False, sort_keys=True)}
            ],
            "structuredContent": payload,
            "isError": is_error,
        }
        if self.era == "2026":
            body["resultType"] = "complete"
        return body

    # ---------- 2026：每个请求自带元数据 ----------

    def check_meta(self, req_id: Any, params: dict[str, Any]) -> dict[str, Any] | None:
        meta = params.get("_meta")
        if not isinstance(meta, dict):
            return self.error(
                req_id,
                -32602,
                "Invalid params: missing _meta",
                {"required": ["io.modelcontextprotocol/protocolVersion",
                              "io.modelcontextprotocol/clientCapabilities"]},
            )
        version = meta.get("io.modelcontextprotocol/protocolVersion")
        caps = meta.get("io.modelcontextprotocol/clientCapabilities")
        if not isinstance(version, str) or not isinstance(caps, dict):
            return self.error(
                req_id,
                -32602,
                "Invalid params: missing per-request protocol metadata",
                {"got": sorted(meta)},
            )
        if version != VERSION_2026:
            return self.error(
                req_id,
                -32022,
                "Unsupported protocol version",
                {"supported": [VERSION_2026], "requested": version},
            )
        return None

    def handle_2026(self, req_id: Any, method: str, params: dict[str, Any]) -> dict[str, Any]:
        # 先判方法是否存在：旧客户端可能不带 _meta 直接发 initialize。
        if method == "initialize":
            return self.error(req_id, -32601, "Method not found: initialize")
        meta_error = self.check_meta(req_id, params)
        if meta_error is not None:
            return meta_error
        if method == "server/discover":
            return self.result(
                req_id,
                {
                    "supportedVersions": [VERSION_2026],
                    "capabilities": {
                        "tools": {"listChanged": False},
                        "resources": {"listChanged": False},
                        "prompts": {"listChanged": False},
                    },
                    "_meta": {"io.modelcontextprotocol/serverInfo": SERVER_INFO},
                    "instructions": "教学 server：工具、资源、提示词各一个最小集合。",
                    "ttlMs": 3600000,
                    "cacheScope": "public",
                },
            )
        if method == "tools/list":
            return self.result(
                req_id,
                {"tools": list(self.tools.values()), "ttlMs": 300000, "cacheScope": "public"},
            )
        if method == "tools/call":
            return self.call_tool_2026(req_id, params)
        if method == "resources/list":
            return self.result(
                req_id,
                {"resources": self.resources(), "ttlMs": 60000, "cacheScope": "private"},
            )
        if method == "resources/templates/list":
            return self.result(
                req_id,
                {
                    "resourceTemplates": [
                        {
                            "uriTemplate": "file://{+path}",
                            "name": "workspace-file",
                            "description": "workspace 内的任意文本文件（由 server 再做根目录校验）",
                            "mimeType": "text/plain",
                        }
                    ],
                    "ttlMs": 60000,
                    "cacheScope": "private",
                },
            )
        if method == "resources/read":
            return self.resources_read_2026(req_id, params)
        if method == "prompts/list":
            return self.result(
                req_id,
                {"prompts": self.prompts(), "ttlMs": 300000, "cacheScope": "public"},
            )
        if method == "prompts/get":
            return self.prompts_get(req_id, params)
        return self.error(req_id, -32601, f"Method not found: {method}")

    def resources_read_2026(self, req_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        uri = params.get("uri")
        if not isinstance(uri, str):
            return self.error(req_id, -32602, "Invalid params: uri is required")
        expected = (self.root / "seed.txt").as_uri()
        if uri != expected:
            return self.error(req_id, -32602, "Resource not found", {"uri": uri})
        try:
            _, text = self.read_text("seed.txt")
        except (OSError, UnicodeError):
            return self.error(req_id, -32602, "Resource not found", {"uri": uri})
        return self.result(
            req_id,
            {
                "contents": [{"uri": uri, "mimeType": "text/plain", "text": text}],
                "ttlMs": 60000,
                "cacheScope": "private",
            },
        )

    def prompts_get(self, req_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        if params.get("name") != "summarize":
            return self.error(req_id, -32602, "Unknown prompt", {"name": params.get("name")})
        args = params.get("arguments") or {}
        path = args.get("path")
        if not isinstance(path, str):
            return self.error(req_id, -32602, "Missing required argument: path")
        return self.result(
            req_id,
            {
                "description": f"总结 {path}",
                "messages": [
                    {
                        "role": "user",
                        "content": {
                            "type": "text",
                            "text": f"请用三句话总结文件 {path} 的内容，并指出它没有回答的问题。",
                        },
                    }
                ],
            },
        )

    def call_tool_2026(self, req_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        name = params.get("name")
        if name not in self.tools:
            return self.error(req_id, -32602, f"Unknown tool: {name}")
        arguments = params.get("arguments")
        if arguments is None:
            arguments = {}
        if not isinstance(arguments, dict):
            return self.error(req_id, -32602, "Invalid params: arguments must be an object")
        schema = self.tools[name]["inputSchema"]
        problems = validate(schema, arguments)
        if problems:
            return self.result(
                req_id,
                self.tool_result(error_payload("EINVAL", "; ".join(problems), retryable=True),
                                 is_error=True),
            )
        if name == "fs.read":
            return self.result(req_id, self.tool_result(self.do_fs_read(arguments)))
        if name == "calc.add":
            return self.result(req_id, self.tool_result(self.do_calc_add(arguments)))
        return self.fs_write(req_id, params, arguments)

    def do_fs_read(self, arguments: dict[str, Any]) -> dict[str, Any]:
        try:
            _, text = self.read_text(arguments["path"])
        except PermissionError as exc:
            return error_payload("EACCES", str(exc))
        except FileNotFoundError:
            return error_payload("ENOENT", f"no such file: {arguments['path']}")
        except UnicodeDecodeError:
            return error_payload("EINVAL", "file is not valid UTF-8")
        return {"path": arguments["path"], "bytes": len(text.encode("utf-8")), "content": text}

    def do_calc_add(self, arguments: dict[str, Any]) -> dict[str, Any]:
        total = arguments["a"] + arguments["b"]
        if abs(total) > 1e15:
            return error_payload("EOVERFLOW", "result is too large")
        return {"sum": total}

    # ---------- 2026：MRTR ----------

    def make_state(self, path: str, content: str) -> str:
        payload = json.dumps(
            {
                "path": path,
                "sha256": hashlib.sha256(content.encode("utf-8")).hexdigest(),
                "iat": int(time.time()),
            },
            separators=(",", ":"),
            sort_keys=True,
        ).encode("utf-8")
        mac = hmac.new(self.state_key, payload, hashlib.sha256).digest()
        envelope = {
            "p": base64.b64encode(payload).decode("ascii"),
            "m": base64.b64encode(mac).decode("ascii"),
        }
        return base64.urlsafe_b64encode(json.dumps(envelope).encode("ascii")).decode("ascii")

    def read_state(self, token: str, path: str, content: str) -> dict[str, Any]:
        try:
            envelope = json.loads(base64.urlsafe_b64decode(token.encode("ascii")))
            payload = base64.b64decode(envelope["p"])
            mac = base64.b64decode(envelope["m"])
        except (ValueError, KeyError, TypeError) as exc:
            raise BadState(f"requestState is not decodable: {type(exc).__name__}") from exc
        expected = hmac.new(self.state_key, payload, hashlib.sha256).digest()
        if not hmac.compare_digest(mac, expected):
            raise BadState("requestState integrity check failed")
        data = json.loads(payload)
        if int(time.time()) - int(data.get("iat", 0)) > 300:
            raise BadState("requestState expired")
        if data.get("path") != path:
            raise BadState("requestState was issued for a different path")
        if data.get("sha256") != hashlib.sha256(content.encode("utf-8")).hexdigest():
            raise BadState("requestState was issued for different content")
        return data

    def fs_write(self, req_id: Any, params: dict[str, Any], arguments: dict[str, Any]) -> dict[str, Any]:
        path = arguments["path"]
        content = arguments["content"]
        responses = params.get("inputResponses")
        if responses is None:
            caps = params.get("_meta", {}).get("io.modelcontextprotocol/clientCapabilities", {})
            if not isinstance(caps, dict) or "elicitation" not in caps:
                return self.error(
                    req_id,
                    -32021,
                    "Missing required client capability",
                    {"requiredCapabilities": ["elicitation"]},
                )
            token = self.make_state(path, content)
            return self.result(
                req_id,
                {
                    "resultType": "input_required",
                    "inputRequests": {
                        "confirm_write": {
                            "method": "elicitation/create",
                            "params": {
                                "mode": "form",
                                "message": f"允许写入 {path}（{len(content.encode('utf-8'))} 字节）？",
                                "requestedSchema": {
                                    "type": "object",
                                    "properties": {"confirm": {"type": "boolean"}},
                                    "required": ["confirm"],
                                    "additionalProperties": False,
                                },
                            },
                        }
                    },
                    "requestState": token,
                },
            )
        token = params.get("requestState")
        if not isinstance(token, str):
            return self.error(req_id, -32602, "Invalid params: requestState is required on retry")
        try:
            self.read_state(token, path, content)
        except BadState as exc:
            return self.error(req_id, -32602, "Invalid params: bad requestState", {"reason": str(exc)})
        answer = responses.get("confirm_write")
        if not isinstance(answer, dict) or answer.get("action") != "accept":
            return self.result(
                req_id,
                self.tool_result(error_payload("EUSERDECLINED", "user declined the write"),
                                 is_error=True),
            )
        content_info = answer.get("content")
        if not isinstance(content_info, dict) or content_info.get("confirm") is not True:
            return self.result(
                req_id,
                self.tool_result(error_payload("EUSERDECLINED", "confirmation was not granted"),
                                 is_error=True),
            )
        try:
            target = Path(path)
            if target.is_absolute():
                raise PermissionError("absolute path is not allowed")
            resolved = (self.root / target).resolve()
            if resolved != self.root and self.root not in resolved.parents:
                raise PermissionError("path escapes workspace root")
            data = content.encode("utf-8")
            resolved.write_bytes(data)
        except PermissionError as exc:
            return self.result(req_id, self.tool_result(error_payload("EACCES", str(exc)),
                                                        is_error=True))
        except OSError as exc:
            return self.result(req_id, self.tool_result(error_payload("EIO", str(exc)),
                                                        is_error=True))
        return self.result(
            req_id,
            self.tool_result(
                {
                    "path": path,
                    "bytes": len(data),
                    "sha256": hashlib.sha256(data).hexdigest(),
                }
            ),
        )

    # ---------- 2025：握手、会话、旧原语 ----------

    def handle_2025(self, req_id: Any, method: str, params: dict[str, Any]) -> dict[str, Any]:
        if method == "initialize":
            if self.handshaken:
                return self.error(req_id, -32600, "Server is already initialized")
            version = params.get("protocolVersion")
            if version != VERSION_2025:
                return self.error(
                    req_id,
                    -32602,
                    "Unsupported protocol version",
                    {"supported": [VERSION_2025], "requested": version},
                )
            self.handshaken = True
            return self.result(
                req_id,
                {
                    "protocolVersion": VERSION_2025,
                    "capabilities": {
                        "tools": {"listChanged": False},
                        "resources": {"subscribe": True, "listChanged": False},
                        "prompts": {"listChanged": False},
                        "logging": {},
                    },
                    "serverInfo": SERVER_INFO,
                    "instructions": "教学 server：先 initialize，再发 initialized 通知。",
                },
            )
        if not self.handshaken:
            return self.error(
                req_id, -32600, "Server not initialized: send initialize first"
            )
        if method == "ping":
            return self.result(req_id, {})
        if not self.ready:
            return self.error(
                req_id, -32600, "Handshake incomplete: send notifications/initialized first"
            )
        if method == "tools/list":
            return self.result(req_id, {"tools": list(self.tools.values())})
        if method == "tools/call":
            return self.call_tool_2025(req_id, params)
        if method == "resources/list":
            return self.result(req_id, {"resources": self.resources()})
        if method == "resources/templates/list":
            return self.result(req_id, {"resourceTemplates": []})
        if method == "resources/read":
            uri = params.get("uri")
            expected = (self.root / "seed.txt").as_uri()
            if uri != expected:
                return self.error(req_id, -32002, "Resource not found", {"uri": uri})
            try:
                _, text = self.read_text("seed.txt")
            except (OSError, UnicodeError):
                return self.error(req_id, -32002, "Resource not found", {"uri": uri})
            return self.result(
                req_id, {"contents": [{"uri": uri, "mimeType": "text/plain", "text": text}]}
            )
        if method == "resources/subscribe":
            self.subscribed = True
            uri = params.get("uri")
            expected = (self.root / "seed.txt").as_uri()
            if uri != expected:
                return self.error(req_id, -32002, "Resource not found", {"uri": uri})
            # 先回响应，再推一条变更通知：客户端必须能按 id 分流。
            response = self.result(req_id, {})
            self.send(response)
            self.send(
                {
                    "jsonrpc": "2.0",
                    "method": "notifications/resources/updated",
                    "params": {"uri": expected},
                }
            )
            return None
        if method == "logging/setLevel":
            level = params.get("level")
            if level not in {"debug", "info", "warning", "error"}:
                return self.error(req_id, -32602, "Invalid log level", {"level": level})
            self.log_level = level
            self.log(f"log level set to {level}")
            return self.result(req_id, {})
        if method == "prompts/list":
            return self.result(req_id, {"prompts": self.prompts()})
        if method == "prompts/get":
            return self.prompts_get(req_id, params)
        return self.error(req_id, -32601, f"Method not found: {method}")

    def call_tool_2025(self, req_id: Any, params: dict[str, Any]) -> dict[str, Any]:
        name = params.get("name")
        if name not in self.tools:
            return self.error(req_id, -32602, f"Unknown tool: {name}")
        arguments = params.get("arguments") or {}
        if not isinstance(arguments, dict):
            return self.error(req_id, -32602, "Invalid params: arguments must be an object")
        problems = validate(self.tools[name]["inputSchema"], arguments)
        if problems:
            return self.result(
                req_id,
                self.tool_result(error_payload("EINVAL", "; ".join(problems), retryable=True),
                                 is_error=True),
            )
        if name == "fs.read":
            return self.result(req_id, self.tool_result(self.do_fs_read(arguments)))
        return self.result(req_id, self.tool_result(self.do_calc_add(arguments)))

    # ---------- 分发 ----------

    def handle_notification(self, method: str, params: dict[str, Any]) -> None:
        if method == "notifications/initialized":
            if self.era == "2025" and self.handshaken:
                self.ready = True
                self.log("client is initialized")
            else:
                self.log("ignoring notifications/initialized (not used in this era)")
            return
        if method == "notifications/cancelled":
            self.log(f"cancelled request {params.get('requestId')!r}: {params.get('reason')!r}")
            return
        self.log(f"ignoring notification {method}")

    def handle(self, message: Any) -> dict[str, Any] | None:
        if not isinstance(message, dict):
            return self.error(None, -32600, "Invalid Request")
        if message.get("jsonrpc") != "2.0":
            return self.error(message.get("id"), -32600, "Invalid Request: jsonrpc must be 2.0")
        method = message.get("method")
        if not isinstance(method, str):
            return self.error(message.get("id"), -32600, "Invalid Request: method is required")
        params = message.get("params")
        if params is None:
            params = {}
        if not isinstance(params, dict):
            return self.error(message.get("id"), -32602, "Invalid params: must be an object")
        if "id" not in message:
            self.handle_notification(method, params)
            return None
        req_id = message["id"]
        if isinstance(req_id, bool) or not isinstance(req_id, (str, int)):
            return self.error(None, -32600, "Invalid Request: id must be string or integer")
        try:
            if self.era == "2026":
                return self.handle_2026(req_id, method, params)
            return self.handle_2025(req_id, method, params)
        except Exception as exc:  # noqa: BLE001 - 教学 server 也要把崩溃变成协议错误
            self.log(f"internal error: {type(exc).__name__}: {exc}")
            return self.error(req_id, -32603, "Internal error", {"kind": type(exc).__name__})


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Hand-written MCP stdio server (chapter 2)")
    parser.add_argument("--era", choices=["2025", "2026"], default="2026")
    parser.add_argument("--root", help="workspace 根目录；缺省创建临时目录")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv if argv is not None else sys.argv[1:])
    root = Path(args.root) if args.root else Path(tempfile.mkdtemp(prefix="mcp-ch02-"))
    server = Server(args.era, root)
    server.log(f"ready; root={server.root}; protocol={VERSION_2026 if args.era == '2026' else VERSION_2025}")
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            message = json.loads(line)
        except json.JSONDecodeError as exc:
            server.send(server.error(None, -32700, "Parse error", {"detail": str(exc)}))
            continue
        response = server.handle(message)
        if response is not None:
            server.send(response)
    server.log("stdin closed; exiting")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
