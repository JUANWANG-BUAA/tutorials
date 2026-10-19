#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 2 章实验的协议测试：直接用 subprocess 驱动两个时代的 stdio server。

覆盖：握手状态机、tools/list、tools/call、错误分区、MRTR、通知，
以及 mcp_client.py 的端到端退出码。

    python3 -m unittest discover -s experiments/ch02 -v
"""

from __future__ import annotations

import json
import queue
import subprocess
import sys
import tempfile
import threading
import unittest
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
SERVER = HERE / "mcp_stdio_server.py"
CLIENT = HERE / "mcp_client.py"
VERSION_2026 = "2026-07-28"
VERSION_2025 = "2025-11-25"


def meta() -> dict[str, Any]:
    return {
        "io.modelcontextprotocol/protocolVersion": VERSION_2026,
        "io.modelcontextprotocol/clientInfo": {"name": "test-client", "version": "1.0.0"},
        "io.modelcontextprotocol/clientCapabilities": {"elicitation": {}},
    }


class ServerProcess:
    def __init__(self, era: str, root: Path) -> None:
        self.era = era
        self.proc = subprocess.Popen(
            [sys.executable, str(SERVER), "--era", era, "--root", str(root)],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
            bufsize=1,
        )
        assert self.proc.stdin is not None and self.proc.stdout is not None
        self.lines: list[str] = []
        self.inbox: queue.Queue[dict[str, Any] | None] = queue.Queue()
        threading.Thread(target=self._read_loop, daemon=True).start()
        self.next_id = 0

    def _read_loop(self) -> None:
        assert self.proc.stdout is not None
        for line in self.proc.stdout:
            self.lines.append(line)
            stripped = line.strip()
            if not stripped:
                continue
            self.inbox.put(json.loads(stripped))
        self.inbox.put(None)

    def send(self, frame: dict[str, Any]) -> None:
        assert self.proc.stdin is not None
        self.proc.stdin.write(json.dumps(frame, ensure_ascii=False) + "\n")
        self.proc.stdin.flush()

    def recv(self, timeout: float = 5.0) -> dict[str, Any]:
        frame = self.inbox.get(timeout=timeout)
        if frame is None:
            raise EOFError("server closed stdout")
        return frame

    def request(self, method: str, params: dict[str, Any] | None = None,
                *, add_meta: bool = True) -> dict[str, Any]:
        self.next_id += 1
        req_id = self.next_id
        body = dict(params or {})
        if self.era == "2026" and add_meta:
            body["_meta"] = meta()
        self.send({"jsonrpc": "2.0", "id": req_id, "method": method, "params": body})
        while True:
            frame = self.recv()
            if frame.get("id") == req_id:
                return frame

    def notify(self, method: str, params: dict[str, Any] | None = None) -> None:
        frame: dict[str, Any] = {"jsonrpc": "2.0", "method": method}
        if params:
            frame["params"] = params
        self.send(frame)

    def close(self) -> int:
        assert self.proc.stdin is not None
        self.proc.stdin.close()
        try:
            code = self.proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            self.proc.kill()
            code = self.proc.wait(timeout=5)
        if self.proc.stdout is not None:
            self.proc.stdout.close()
        if self.proc.stderr is not None:
            self.proc.stderr.close()
        return code

    def stderr_text(self) -> str:
        if self.proc.stderr is None:
            return ""
        try:
            return self.proc.stderr.read()
        except ValueError:
            return ""


class Base(unittest.TestCase):
    era = "2026"

    def setUp(self) -> None:
        self.tmp = tempfile.TemporaryDirectory(prefix="ch02-test-")
        self.root = Path(self.tmp.name).resolve()
        (self.root / "seed.txt").write_text("alpha\nbeta\n", encoding="utf-8")
        self.server = ServerProcess(self.era, self.root)

    def tearDown(self) -> None:
        if self.server.proc.poll() is None:
            self.server.close()
        self.tmp.cleanup()

    def initialize_2025(self) -> dict[str, Any]:
        response = self.server.request("initialize", {
            "protocolVersion": VERSION_2025,
            "capabilities": {},
            "clientInfo": {"name": "test-client", "version": "1.0.0"},
        })
        self.server.notify("notifications/initialized")
        return response


class Test2026(Base):
    era = "2026"

    def test_discover(self) -> None:
        body = self.server.request("server/discover")["result"]
        self.assertEqual(body["resultType"], "complete")
        self.assertIn(VERSION_2026, body["supportedVersions"])
        self.assertEqual(body["_meta"]["io.modelcontextprotocol/serverInfo"]["name"],
                         "ch02-stdio-server")
        self.assertIsInstance(body["ttlMs"], int)
        self.assertEqual(body["cacheScope"], "public")

    def test_tools_list_is_stable_and_has_schemas(self) -> None:
        first = self.server.request("tools/list")["result"]
        second = self.server.request("tools/list")["result"]
        names = [tool["name"] for tool in first["tools"]]
        self.assertEqual(names, ["fs.read", "calc.add", "fs.write"])
        self.assertEqual(names, [tool["name"] for tool in second["tools"]])
        for tool in first["tools"]:
            self.assertEqual(tool["inputSchema"]["type"], "object")
            self.assertIs(tool["inputSchema"]["additionalProperties"], False)
            self.assertTrue(tool["inputSchema"]["required"])
        self.assertIn("ttlMs", first)
        self.assertIn("cacheScope", first)

    def test_call_success(self) -> None:
        body = self.server.request("tools/call", {
            "name": "calc.add", "arguments": {"a": 2, "b": 3},
        })["result"]
        self.assertFalse(body["isError"])
        self.assertEqual(body["structuredContent"], {"sum": 5})
        self.assertEqual(body["resultType"], "complete")
        self.assertIn("text", body["content"][0])

    def test_input_validation_is_tool_error(self) -> None:
        body = self.server.request("tools/call", {
            "name": "calc.add", "arguments": {"a": "2", "b": 3},
        })["result"]
        self.assertTrue(body["isError"])
        self.assertEqual(body["structuredContent"]["error"]["code"], "EINVAL")
        self.assertTrue(body["structuredContent"]["error"]["retryable"])

    def test_unknown_tool_is_protocol_error(self) -> None:
        frame = self.server.request("tools/call", {"name": "nope", "arguments": {}})
        self.assertEqual(frame["error"]["code"], -32602)

    def test_unknown_method(self) -> None:
        frame = self.server.request("tools/frobnicate", {})
        self.assertEqual(frame["error"]["code"], -32601)

    def test_missing_meta(self) -> None:
        frame = self.server.request("tools/list", {}, add_meta=False)
        self.assertEqual(frame["error"]["code"], -32602)
        self.assertIn("io.modelcontextprotocol/protocolVersion",
                      frame["error"]["data"]["required"])

    def test_wrong_version(self) -> None:
        frame = self.server.request("tools/list", {
            "_meta": {
                "io.modelcontextprotocol/protocolVersion": VERSION_2025,
                "io.modelcontextprotocol/clientCapabilities": {},
            },
        }, add_meta=False)
        self.assertEqual(frame["error"]["code"], -32022)
        self.assertEqual(frame["error"]["data"]["supported"], [VERSION_2026])

    def test_initialize_is_gone(self) -> None:
        frame = self.server.request("initialize", {"protocolVersion": VERSION_2026})
        self.assertEqual(frame["error"]["code"], -32601)

    def test_mrtr_round_trip(self) -> None:
        args = {"path": "out.txt", "content": "hello"}
        first = self.server.request("tools/call", {"name": "fs.write", "arguments": args})["result"]
        self.assertEqual(first["resultType"], "input_required")
        self.assertIn("confirm_write", first["inputRequests"])
        token = first["requestState"]
        self.assertTrue(token)
        self.assertFalse((self.root / "out.txt").exists())

        retry = self.server.request("tools/call", {
            "name": "fs.write",
            "arguments": args,
            "inputResponses": {"confirm_write": {"action": "accept", "content": {"confirm": True}}},
            "requestState": token,
        })["result"]
        self.assertFalse(retry["isError"])
        self.assertEqual((self.root / "out.txt").read_text(encoding="utf-8"), "hello")

    def test_mrtr_request_state_is_integrity_protected(self) -> None:
        args = {"path": "out.txt", "content": "hello"}
        token = self.server.request("tools/call", {
            "name": "fs.write", "arguments": args,
        })["result"]["requestState"]
        flipped = "A" if token[10] != "A" else "B"
        frame = self.server.request("tools/call", {
            "name": "fs.write",
            "arguments": args,
            "inputResponses": {"confirm_write": {"action": "accept", "content": {"confirm": True}}},
            "requestState": token[:10] + flipped + token[11:],
        })
        self.assertEqual(frame["error"]["code"], -32602)
        self.assertFalse((self.root / "out.txt").exists())

    def test_stdout_is_pure_json(self) -> None:
        self.server.request("server/discover")
        self.server.request("tools/list")
        self.server.close()
        for line in self.server.lines:
            frame = json.loads(line)
            self.assertEqual(frame["jsonrpc"], "2.0")


class Test2025(Base):
    era = "2025"

    def test_handshake_is_required(self) -> None:
        frame = self.server.request("tools/list")
        self.assertEqual(frame["error"]["code"], -32600)
        init = self.initialize_2025()
        self.assertEqual(init["result"]["protocolVersion"], VERSION_2025)
        self.assertIn("tools", init["result"]["capabilities"])
        self.assertNotIn("resultType", init["result"])

    def test_initialized_notification_is_required(self) -> None:
        self.server.request("initialize", {
            "protocolVersion": VERSION_2025,
            "capabilities": {},
            "clientInfo": {"name": "test-client", "version": "1.0.0"},
        })
        frame = self.server.request("tools/list")
        self.assertEqual(frame["error"]["code"], -32600)
        self.server.notify("notifications/initialized")
        self.assertIn("tools", self.server.request("tools/list")["result"])

    def test_call_and_legacy_error_code(self) -> None:
        self.initialize_2025()
        body = self.server.request("tools/call", {
            "name": "fs.read", "arguments": {"path": "seed.txt"},
        })["result"]
        self.assertEqual(body["structuredContent"]["content"], "alpha\nbeta\n")
        self.assertNotIn("resultType", body)
        missing = self.server.request("tools/call", {"name": "calc.add", "arguments": {"a": 1}})["result"]
        self.assertTrue(missing["isError"])
        self.assertEqual(missing["structuredContent"]["error"]["code"], "EINVAL")

    def test_ping_logging_and_resources(self) -> None:
        self.initialize_2025()
        self.assertEqual(self.server.request("ping")["result"], {})
        self.assertEqual(self.server.request("logging/setLevel", {"level": "debug"})["result"], {})

        uri = (self.root / "seed.txt").as_uri()
        listing = self.server.request("resources/list")["result"]
        self.assertEqual([item["uri"] for item in listing["resources"]], [uri])
        read = self.server.request("resources/read", {"uri": uri})["result"]
        self.assertEqual(read["contents"][0]["text"], "alpha\nbeta\n")

        self.assertEqual(self.server.request("resources/subscribe", {"uri": uri})["result"], {})
        notification = self.server.recv()
        self.assertEqual(notification["method"], "notifications/resources/updated")
        self.assertEqual(notification["params"]["uri"], uri)

    def test_missing_resource_uses_legacy_code(self) -> None:
        self.initialize_2025()
        frame = self.server.request("resources/read", {"uri": "file:///nope.txt"})
        self.assertEqual(frame["error"]["code"], -32002)

    def test_discover_is_unknown_in_2025(self) -> None:
        self.initialize_2025()
        frame = self.server.request("server/discover")
        self.assertEqual(frame["error"]["code"], -32601)


class TestClientEndToEnd(unittest.TestCase):
    def run_client(self, era: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(CLIENT), "--era", era, "--quiet"],
            text=True, capture_output=True, timeout=60,
        )

    def test_client_2026(self) -> None:
        proc = self.run_client("2026")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertIn("fail=0", proc.stdout)

    def test_client_2025(self) -> None:
        proc = self.run_client("2025")
        self.assertEqual(proc.returncode, 0, proc.stdout + proc.stderr)
        self.assertIn("fail=0", proc.stdout)


if __name__ == "__main__":
    unittest.main()
