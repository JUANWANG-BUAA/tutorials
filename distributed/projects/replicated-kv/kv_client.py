#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目二客户端：跟随 leader 重定向，支持 put/get/status/partition。"""

from __future__ import annotations

import argparse
import http.client
import json
import sys
import time
import urllib.parse
import uuid


def split_base(base: str):
    u = urllib.parse.urlparse(base)
    return u.hostname or "127.0.0.1", u.port or 80


def request(base: str, method: str, path: str, body: dict | None = None,
            timeout: float = 2.0) -> tuple[int, dict, dict]:
    host, port = split_base(base)
    conn = http.client.HTTPConnection(host, port, timeout=timeout)
    data = json.dumps(body, ensure_ascii=False).encode() if body is not None else None
    headers = {"Content-Type": "application/json"} if body is not None else {}
    try:
        conn.request(method, path, body=data, headers=headers)
        resp = conn.getresponse()
        raw = resp.read()
        try:
            payload = json.loads(raw.decode()) if raw else {}
        except json.JSONDecodeError:
            payload = {"raw": raw.decode("utf-8", "replace")}
        return resp.status, payload, {k.lower(): v for k, v in resp.getheaders()}
    finally:
        conn.close()


def follow(base: str, method: str, path: str, body: dict | None = None,
           timeout: float = 2.0, hops: int = 3) -> tuple[int, dict, str]:
    """跟随 307；返回 (status, payload, 最终 base)。"""
    current = base.rstrip("/")
    for _ in range(hops):
        status, payload, headers = request(current, method, path, body, timeout)
        if status == 307:
            loc = headers.get("location")
            if not loc:
                return status, payload, current
            current = loc.rstrip("/")
            continue
        return status, payload, current
    return 508, {"error": "too_many_redirects"}, current


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="小型复制 KV 客户端")
    ap.add_argument("--base", action="append", default=[],
                    help="节点地址，可重复；默认 7101/7102/7103")
    ap.add_argument("--key", default="k")
    ap.add_argument("--value", default="v")
    ap.add_argument("--client-id", default="")
    ap.add_argument("--seq", type=int, default=1)
    ap.add_argument("--consistency", choices=["linearizable", "lease", "stale"],
                    default="linearizable")
    sub = ap.add_subparsers(dest="cmd")
    sub.add_parser("put")
    sub.add_parser("get")
    sub.add_parser("status")
    sub.add_parser("demo")
    p = sub.add_parser("partition")
    p.add_argument("--peers", default="2,3")
    p.add_argument("--enabled", action="store_true", default=True)
    p.add_argument("--disable", action="store_true")
    sub.add_parser("heal")
    args = ap.parse_args(argv)

    bases = args.base or ["http://127.0.0.1:7101",
                          "http://127.0.0.1:7102",
                          "http://127.0.0.1:7103"]
    base = bases[0]
    cmd = args.cmd or "demo"
    if cmd == "status":
        for b in bases:
            try:
                status, payload, _ = request(b, "GET", "/status", timeout=0.8)
                print(json.dumps({"base": b, "http": status, "status": payload},
                                 ensure_ascii=False, indent=2))
            except Exception as exc:
                print(json.dumps({"base": b, "error": str(exc)}))
        return 0
    if cmd == "partition":
        peers = [int(x) for x in args.peers.split(",") if x.strip()]
        body = {"peers": peers, "enabled": not args.disable}
        status, payload, _ = request(base, "POST", "/admin/partition", body)
        print(json.dumps({"http": status, "response": payload}, ensure_ascii=False, indent=2))
        return 0 if status == 200 else 1
    if cmd == "heal":
        # 对所有可达节点解除隔离
        for b in bases:
            try:
                status, payload, _ = request(b, "POST", "/admin/heal", {})
                print(json.dumps({"base": b, "http": status, "response": payload},
                                 ensure_ascii=False))
            except Exception as exc:
                print(json.dumps({"base": b, "error": str(exc)}))
        return 0

    client_id = args.client_id or f"cli-{uuid.uuid4().hex[:8]}"
    if cmd == "put":
        body = {"key": args.key, "value": args.value,
                "client_id": client_id, "seq": args.seq}
        status, payload, served = follow(base, "POST", "/client/put", body, timeout=3.0)
        print(json.dumps({"http": status, "served_by": served, "response": payload},
                         ensure_ascii=False, indent=2))
        return 0 if status in (200, 202) else 1
    if cmd == "get":
        q = urllib.parse.urlencode({"key": args.key, "consistency": args.consistency})
        status, payload, served = follow(base, "GET", f"/client/get?{q}", timeout=2.0)
        print(json.dumps({"http": status, "served_by": served, "response": payload},
                         ensure_ascii=False, indent=2))
        return 0 if status == 200 else 1
    # demo
    body = {"key": args.key, "value": args.value,
            "client_id": client_id, "seq": args.seq}
    status, payload, served = follow(base, "POST", "/client/put", body, timeout=3.0)
    print(json.dumps({"put": {"http": status, "served_by": served, "response": payload}},
                     ensure_ascii=False, indent=2))
    time.sleep(0.2)
    q = urllib.parse.urlencode({"key": args.key, "consistency": args.consistency})
    status, payload, served = follow(base, "GET", f"/client/get?{q}", timeout=2.0)
    print(json.dumps({"get": {"http": status, "served_by": served, "response": payload}},
                     ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
