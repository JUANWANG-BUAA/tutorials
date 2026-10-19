#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目一客户端：超时后用同一个幂等键重试，并轮询最终状态。"""

from __future__ import annotations

import argparse
import json
import sys
import time
import urllib.error
import urllib.request
import uuid


def request_json(method: str, url: str, body: dict | None = None,
                 headers: dict | None = None, timeout: float = 1.0) -> tuple[int, dict]:
    data = json.dumps(body, ensure_ascii=False).encode("utf-8") if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Content-Type", "application/json")
    for k, v in (headers or {}).items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.status, json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        raw = exc.read().decode("utf-8", "replace")
        try:
            payload = json.loads(raw)
        except json.JSONDecodeError:
            payload = {"raw": raw}
        return exc.code, payload


def call_tool(base: str, key: str, tool: str, args: dict, timeout: float = 1.0,
              retries: int = 3, new_key_on_retry: bool = False,
              verbose: bool = True) -> dict:
    """返回服务端的 call 对象；超时/5xx 用同一个 key 重试。"""
    url = base.rstrip("/") + "/v1/tool-calls"
    last: dict = {}
    for attempt in range(retries + 1):
        use_key = key if not new_key_on_retry else f"{key}-{attempt}"
        try:
            status, payload = request_json(
                "POST", url,
                body={"tool": tool, "args": args, "client_id": "demo-client",
                      "seq": int(time.time() * 1000)},
                headers={"Idempotency-Key": use_key,
                         "X-Trace-Id": f"demo-{uuid.uuid4().hex[:8]}"},
                timeout=timeout)
            last = payload
            if verbose:
                print(json.dumps({"attempt": attempt, "http": status,
                                  "key": use_key, "response": payload},
                                 ensure_ascii=False), file=sys.stderr)
            if status in (200, 201, 202, 409, 400, 422):
                return payload
            if status in (429, 503):
                retry_after = float(payload.get("retry_after_ms", 100)) / 1000.0
                time.sleep(min(retry_after, 2.0))
                continue
        except (TimeoutError, urllib.error.URLError, ConnectionError) as exc:
            if verbose:
                print(json.dumps({"attempt": attempt, "error": str(exc),
                                  "key": use_key}, ensure_ascii=False), file=sys.stderr)
        time.sleep(min((2 ** attempt) * 0.1, 1.0) + 0.05)
    return last or {"error": {"code": "retry_exhausted", "message": "no response"}}


def poll(base: str, call_id: str, timeout: float = 5.0, interval: float = 0.1) -> dict:
    url = base.rstrip("/") + f"/v1/tool-calls/{call_id}"
    deadline = time.monotonic() + timeout
    last: dict = {}
    while time.monotonic() < deadline:
        status, payload = request_json("GET", url, timeout=1.0)
        last = payload
        if status == 200 and payload.get("status") in ("succeeded", "failed"):
            return payload
        time.sleep(interval)
    return last


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="幂等工具调用客户端")
    ap.add_argument("--base", default="http://127.0.0.1:8081")
    ap.add_argument("--key", default="")
    ap.add_argument("--tool", default="charge")
    ap.add_argument("--amount", type=int, default=100)
    ap.add_argument("--sleep-ms", type=int, default=0)
    ap.add_argument("--timeout", type=float, default=1.0)
    ap.add_argument("--retries", type=int, default=3)
    ap.add_argument("--new-key-on-retry", action="store_true",
                    help="故意在重试时换键，用来复现重复副作用")
    ap.add_argument("--query", default="", help="按 call_id 查询")
    ap.add_argument("--query-key", default="", help="按 Idempotency-Key 查询")
    ap.add_argument("--stats", action="store_true")
    args = ap.parse_args(argv)

    base = args.base.rstrip("/")
    if args.stats:
        status, payload = request_json("GET", base + "/stats")
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0 if status == 200 else 1
    if args.query:
        status, payload = request_json("GET", base + f"/v1/tool-calls/{args.query}")
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0 if status == 200 else 1
    if args.query_key:
        status, payload = request_json("GET", base + f"/v1/tool-calls/by-key/{args.query_key}")
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0 if status == 200 else 1

    key = args.key or f"demo-{uuid.uuid4().hex[:12]}"
    tool_args: dict = {}
    if args.tool == "charge":
        tool_args = {"amount": args.amount}
    elif args.tool == "send_email":
        tool_args = {"to": "user@example.com"}
    elif args.tool == "sleep":
        tool_args = {"sleep_ms": args.sleep_ms}
    elif args.tool == "fail":
        tool_args = {"message": "simulated", "retryable": False}
    if args.sleep_ms:
        tool_args["sleep_ms"] = args.sleep_ms

    call = call_tool(base, key, args.tool, tool_args, args.timeout,
                     args.retries, args.new_key_on_retry)
    print(json.dumps(call, ensure_ascii=False, indent=2))
    if call.get("call_id") and call.get("status") not in ("succeeded", "failed"):
        final = poll(base, call["call_id"], timeout=5.0)
        print(json.dumps({"final": final}, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
