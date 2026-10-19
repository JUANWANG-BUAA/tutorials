#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 2 章实验：MCP stdio 客户端（手写 JSON-RPC，不依赖 SDK）。

启动 mcp_stdio_server.py 子进程，按所选时代发请求，打印每一帧，并断言
关键路径。任何断言失败都会以非零码退出。

  python3 mcp_client.py --era 2026 --root /tmp/ch02 --trace trace.jsonl
  python3 mcp_client.py --era 2025 --quiet

2026 路径：server/discover → tools/list → tools/call（成功/校验失败/未知工具）
           → fs.write 的 MRTR 两轮往返
2025 路径：未 initialize 先调用 → initialize → initialized → tools/list
           → tools/call → ping → resources/read → subscribe → logging/setLevel
"""

from __future__ import annotations

import argparse
import json
import os
import queue
import subprocess
import sys
import tempfile
import threading
import time
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
SERVER = HERE / "mcp_stdio_server.py"
VERSION_2026 = "2026-07-28"
VERSION_2025 = "2025-11-25"
SERVER_INFO = {"name": "ch02-stdio-server", "version": "1.0.0"}


class Checks:
    def __init__(self, quiet: bool = False) -> None:
        self.ok = 0
        self.fail = 0
        self.quiet = quiet

    def eq(self, name: str, got: Any, want: Any) -> None:
        if got == want:
            self.ok += 1
            if not self.quiet:
                print(f"PASS {name}")
        else:
            self.fail += 1
            print(f"FAIL {name}: got={got!r} want={want!r}")

    def true(self, name: str, value: Any) -> None:
        self.eq(name, bool(value), True)

    def summary(self) -> int:
        print(f"checks: ok={self.ok} fail={self.fail}")
        return 0 if self.fail == 0 else 1


class StdioClient:
    def __init__(self, era: str, root: Path, trace_path: Path | None = None,
                 quiet: bool = False, show_stderr: bool = False) -> None:
        self.era = era
        self.quiet = quiet
        self.trace_path = trace_path
        self._trace = open(trace_path, "a", encoding="utf-8") if trace_path else None
        stderr = None if show_stderr else subprocess.DEVNULL
        self.proc = subprocess.Popen(
            [sys.executable, str(SERVER), "--era", era, "--root", str(root)],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=stderr,
            text=True,
            encoding="utf-8",
            bufsize=1,
        )
        assert self.proc.stdin is not None and self.proc.stdout is not None
        self._inbox: queue.Queue[dict[str, Any] | None] = queue.Queue()
        self._reader = threading.Thread(target=self._read_loop, daemon=True)
        self._reader.start()
        self._next_id = 0

    def _read_loop(self) -> None:
        assert self.proc.stdout is not None
        for line in self.proc.stdout:
            line = line.strip()
            if not line:
                continue
            try:
                frame = json.loads(line)
            except json.JSONDecodeError:
                self._inbox.put({"broken_line": line})
                continue
            self._inbox.put(frame)
        self._inbox.put(None)

    def _record(self, direction: str, frame: dict[str, Any]) -> None:
        if self._trace is not None:
            self._trace.write(
                json.dumps({"era": self.era, "dir": direction, "frame": frame},
                           ensure_ascii=False) + "\n"
            )
            self._trace.flush()
        if not self.quiet:
            arrow = "-->" if direction == "send" else "<--"
            print(f"{arrow} {json.dumps(frame, ensure_ascii=False, separators=(',', ':'))}")

    def send(self, frame: dict[str, Any]) -> None:
        assert self.proc.stdin is not None
        line = json.dumps(frame, ensure_ascii=False, separators=(",", ":"))
        assert "\n" not in line
        self._record("send", frame)
        self.proc.stdin.write(line + "\n")
        self.proc.stdin.flush()

    def next_id(self) -> int:
        self._next_id += 1
        return self._next_id

    def notify(self, method: str, params: dict[str, Any] | None = None) -> None:
        frame: dict[str, Any] = {"jsonrpc": "2.0", "method": method}
        if params:
            frame["params"] = params
        self.send(frame)

    def request(self, method: str, params: dict[str, Any] | None = None,
                *, add_meta: bool = True, timeout: float = 5.0) -> dict[str, Any]:
        req_id = self.next_id()
        body = dict(params or {})
        if self.era == "2026" and add_meta:
            body["_meta"] = {
                "io.modelcontextprotocol/protocolVersion": VERSION_2026,
                "io.modelcontextprotocol/clientInfo": {"name": "ch02-client", "version": "1.0.0"},
                "io.modelcontextprotocol/clientCapabilities": {"elicitation": {}},
            }
        self.send({"jsonrpc": "2.0", "id": req_id, "method": method, "params": body})
        while True:
            frame = self.read_frame(timeout=timeout)
            if frame.get("id") == req_id:
                return frame
            # 通知不属于任何请求，按到达顺序记为旁路帧。
            if not self.quiet:
                print(f"    (notification while waiting for id={req_id}: {frame.get('method')})")

    def read_frame(self, timeout: float = 5.0) -> dict[str, Any]:
        try:
            frame = self._inbox.get(timeout=timeout)
        except queue.Empty as exc:
            raise TimeoutError(f"no frame within {timeout}s") from exc
        if frame is None:
            raise EOFError("server closed stdout")
        self._record("recv", frame)
        return frame

    def wait_notification(self, method: str, timeout: float = 5.0) -> dict[str, Any]:
        deadline = time.time() + timeout
        while time.time() < deadline:
            frame = self.read_frame(timeout=max(0.1, deadline - time.time()))
            if frame.get("method") == method:
                return frame
        raise TimeoutError(f"notification {method} did not arrive")

    def close(self) -> int:
        self.proc.stdin.close()
        try:
            return self.proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            self.proc.kill()
            return self.proc.wait(timeout=5)
        finally:
            if self._trace is not None:
                self._trace.close()


def result(frame: dict[str, Any]) -> dict[str, Any]:
    return frame.get("result") or {}


def error_code(frame: dict[str, Any]) -> int | None:
    err = frame.get("error")
    return err.get("code") if isinstance(err, dict) else None


def run_2026(client: StdioClient, checks: Checks, root: Path) -> None:
    discover = client.request("server/discover")
    d = result(discover)
    checks.eq("2026 discover resultType", d.get("resultType"), "complete")
    checks.true("2026 discover supports 2026-07-28",
                VERSION_2026 in d.get("supportedVersions", []))
    checks.eq("2026 discover serverInfo", d.get("_meta", {}).get(
        "io.modelcontextprotocol/serverInfo"), SERVER_INFO)
    checks.true("2026 discover cache hints",
                isinstance(d.get("ttlMs"), int) and d.get("cacheScope") == "public")

    listing = client.request("tools/list")
    names = [tool["name"] for tool in result(listing).get("tools", [])]
    checks.eq("2026 tools/list names", names, ["fs.read", "calc.add", "fs.write"])
    checks.true("2026 tools/list cache hints",
                "ttlMs" in result(listing) and "cacheScope" in result(listing))

    read = client.request("tools/call", {"name": "fs.read", "arguments": {"path": "seed.txt"}})
    read_result = result(read)
    checks.eq("2026 fs.read isError", read_result.get("isError"), False)
    checks.eq("2026 fs.read content", read_result.get("structuredContent", {}).get("content"),
              "alpha\nbeta\n")
    checks.eq("2026 fs.read resultType", read_result.get("resultType"), "complete")

    add = client.request("tools/call", {"name": "calc.add", "arguments": {"a": 2, "b": 3}})
    checks.eq("2026 calc.add sum", result(add).get("structuredContent", {}).get("sum"), 5)

    bad_path = client.request("tools/call", {"name": "fs.read", "arguments": {"path": "../etc/passwd"}})
    bad_body = result(bad_path)
    checks.eq("2026 path escape is tool error", bad_body.get("isError"), True)
    checks.eq("2026 path escape code",
              bad_body.get("structuredContent", {}).get("error", {}).get("code"), "EACCES")

    bad_type = client.request("tools/call", {"name": "calc.add", "arguments": {"a": "2", "b": 3}})
    bad_type_body = result(bad_type)
    checks.eq("2026 bad type is tool error", bad_type_body.get("isError"), True)
    checks.eq("2026 bad type code",
              bad_type_body.get("structuredContent", {}).get("error", {}).get("code"), "EINVAL")

    unknown_tool = client.request("tools/call", {"name": "nope", "arguments": {}})
    checks.eq("2026 unknown tool code", error_code(unknown_tool), -32602)

    unknown_method = client.request("tools/frobnicate", {})
    checks.eq("2026 unknown method code", error_code(unknown_method), -32601)

    no_meta = client.request("tools/list", {}, add_meta=False)
    checks.eq("2026 missing _meta code", error_code(no_meta), -32602)

    # 手工构造一个旧版本请求，验证 -32022 与 supported 列表。
    req_id = client.next_id()
    client.send({
        "jsonrpc": "2.0", "id": req_id, "method": "tools/list",
        "params": {"_meta": {
            "io.modelcontextprotocol/protocolVersion": VERSION_2025,
            "io.modelcontextprotocol/clientCapabilities": {},
        }},
    })
    while True:
        frame = client.read_frame()
        if frame.get("id") == req_id:
            wrong_version = frame
            break
    checks.eq("2026 wrong version code", error_code(wrong_version), -32022)
    checks.eq("2026 wrong version supported",
              wrong_version.get("error", {}).get("data", {}).get("supported"), [VERSION_2026])

    first = client.request("tools/call", {"name": "fs.write",
                                          "arguments": {"path": "out.txt", "content": "hello"}})
    first_body = result(first)
    checks.eq("2026 fs.write resultType", first_body.get("resultType"), "input_required")
    checks.true("2026 fs.write inputRequests", "confirm_write" in first_body.get("inputRequests", {}))
    token = first_body.get("requestState", "")
    checks.true("2026 fs.write requestState", isinstance(token, str) and len(token) > 40)

    retry = client.request("tools/call", {
        "name": "fs.write",
        "arguments": {"path": "out.txt", "content": "hello"},
        "inputResponses": {"confirm_write": {"action": "accept", "content": {"confirm": True}}},
        "requestState": token,
    })
    retry_body = result(retry)
    checks.eq("2026 fs.write retry resultType", retry_body.get("resultType"), "complete")
    checks.eq("2026 fs.write retry isError", retry_body.get("isError"), False)

    written = client.request("tools/call", {"name": "fs.read", "arguments": {"path": "out.txt"}})
    checks.eq("2026 fs.write landed", result(written).get("structuredContent", {}).get("content"),
              "hello")
    checks.eq("2026 file on disk", (root / "out.txt").read_text(encoding="utf-8"), "hello")

    flipped = "A" if token[10] != "A" else "B"
    tampered_token = token[:10] + flipped + token[11:]
    tampered = client.request("tools/call", {
        "name": "fs.write",
        "arguments": {"path": "out.txt", "content": "hello"},
        "inputResponses": {"confirm_write": {"action": "accept", "content": {"confirm": True}}},
        "requestState": tampered_token,
    })
    checks.eq("2026 tampered requestState code", error_code(tampered), -32602)

    client.notify("notifications/cancelled", {"requestId": 999, "reason": "demo"})
    checks.eq("2026 server exit", client.close(), 0)


def run_2025(client: StdioClient, checks: Checks, root: Path) -> None:
    early = client.request("tools/list")
    checks.eq("2025 call before initialize", error_code(early), -32600)

    init = client.request("initialize", {
        "protocolVersion": VERSION_2025,
        "capabilities": {},
        "clientInfo": {"name": "ch02-client", "version": "1.0.0"},
    })
    init_body = result(init)
    checks.eq("2025 initialize version", init_body.get("protocolVersion"), VERSION_2025)
    checks.true("2025 initialize capabilities", "tools" in init_body.get("capabilities", {}))
    checks.eq("2025 initialize serverInfo", init_body.get("serverInfo"), SERVER_INFO)
    checks.eq("2025 initialize has no resultType", "resultType" in init_body, False)

    before_ready = client.request("tools/list")
    checks.eq("2025 call before initialized", error_code(before_ready), -32600)

    client.notify("notifications/initialized")

    ping = client.request("ping")
    checks.eq("2025 ping result", result(ping), {})

    listing = client.request("tools/list")
    names = [tool["name"] for tool in result(listing).get("tools", [])]
    checks.eq("2025 tools/list names", names, ["fs.read", "calc.add"])
    checks.eq("2025 tools/list has no resultType", "resultType" in result(listing), False)

    read = client.request("tools/call", {"name": "fs.read", "arguments": {"path": "seed.txt"}})
    checks.eq("2025 fs.read content", result(read).get("structuredContent", {}).get("content"),
              "alpha\nbeta\n")
    checks.eq("2025 fs.read has no resultType", "resultType" in result(read), False)

    bad = client.request("tools/call", {"name": "calc.add", "arguments": {"a": 1}})
    checks.eq("2025 missing arg is tool error", result(bad).get("isError"), True)
    checks.eq("2025 missing arg code",
              result(bad).get("structuredContent", {}).get("error", {}).get("code"), "EINVAL")

    resources = client.request("resources/list")
    uris = [item["uri"] for item in result(resources).get("resources", [])]
    checks.eq("2025 resource uri", uris, [(root / "seed.txt").as_uri()])

    resource = client.request("resources/read", {"uri": (root / "seed.txt").as_uri()})
    contents = result(resource).get("contents", [])
    checks.eq("2025 resource read", contents[0].get("text") if contents else None, "alpha\nbeta\n")

    subscribe = client.request("resources/subscribe", {"uri": (root / "seed.txt").as_uri()})
    checks.eq("2025 subscribe result", result(subscribe), {})
    notification = client.wait_notification("notifications/resources/updated")
    checks.eq("2025 update uri", notification.get("params", {}).get("uri"),
              (root / "seed.txt").as_uri())

    set_level = client.request("logging/setLevel", {"level": "debug"})
    checks.eq("2025 setLevel result", result(set_level), {})

    client.notify("notifications/cancelled", {"requestId": 999, "reason": "demo"})
    checks.eq("2025 server exit", client.close(), 0)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="MCP stdio client (chapter 2)")
    parser.add_argument("--era", choices=["2025", "2026"], default="2026")
    parser.add_argument("--root", help="workspace 根目录；缺省创建临时目录")
    parser.add_argument("--trace", help="把每一帧写成 JSONL")
    parser.add_argument("--quiet", action="store_true", help="只打印断言汇总")
    parser.add_argument("--show-stderr", action="store_true", help="透传 server 的 stderr 日志")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv if argv is not None else sys.argv[1:])
    # 必须先规范化：macOS 的 /tmp 是指向 /private/tmp 的符号链接，而
    # resources/read 的 URI 必须与 server 解析后的规范 URI 完全一致。
    root = Path(args.root).resolve() if args.root else Path(
        tempfile.mkdtemp(prefix="mcp-ch02-client-")
    ).resolve()
    root.mkdir(parents=True, exist_ok=True)
    (root / "seed.txt").write_text("alpha\nbeta\n", encoding="utf-8")
    trace_path = Path(args.trace) if args.trace else None
    if trace_path is not None:
        trace_path.parent.mkdir(parents=True, exist_ok=True)
        trace_path.write_text("", encoding="utf-8")  # 每次运行覆盖旧 trace
    client = StdioClient(args.era, root, trace_path, args.quiet, args.show_stderr)
    checks = Checks(quiet=args.quiet)
    try:
        if args.era == "2026":
            run_2026(client, checks, root)
        else:
            run_2025(client, checks, root)
    finally:
        if client.proc.poll() is None:
            client.close()
    if not args.quiet:
        print(f"root: {root}")
        if trace_path is not None:
            print(f"trace: {trace_path}")
    return checks.summary()


if __name__ == "__main__":
    raise SystemExit(main())
