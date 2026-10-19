#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""故障代理：把请求转发给幂等后端，然后按模式制造“响应丢失/延迟/重复”。

用法：
    python3 chaos_proxy.py --listen-port 8082 --upstream-port 8081 --mode delay-response --delay 2
    python3 chaos_proxy.py --listen-port 8082 --upstream-port 8081 --mode drop-response
    python3 chaos_proxy.py --listen-port 8082 --upstream-port 8081 --mode duplicate-request

只支持 HTTP/1.x + Content-Length；够用于本项目的故障注入，不是通用代理。
"""

from __future__ import annotations

import argparse
import json
import socket
import socketserver
import sys
import threading
import time


def recv_until(sock: socket.socket, marker: bytes, limit: int = 1 << 20) -> bytes:
    buf = b""
    while marker not in buf:
        chunk = sock.recv(4096)
        if not chunk:
            break
        buf += chunk
        if len(buf) > limit:
            raise ValueError("header too large")
    return buf


def recv_message(sock: socket.socket, initial: bytes = b"") -> bytes:
    """读取一条 HTTP 消息：header + Content-Length 指定的 body。"""
    buf = initial
    if b"\r\n\r\n" not in buf:
        buf += recv_until(sock, b"\r\n\r\n")
    head, _, rest = buf.partition(b"\r\n\r\n")
    length = 0
    for line in head.split(b"\r\n")[1:]:
        if line.lower().startswith(b"content-length:"):
            length = int(line.split(b":", 1)[1].strip())
    while len(rest) < length:
        chunk = sock.recv(4096)
        if not chunk:
            break
        rest += chunk
    return head + b"\r\n\r\n" + rest[:length]


def force_close(head: bytes) -> bytes:
    """把请求改成 Connection: close，避免上游 keep-alive 让我们等不到 EOF。"""
    lines = [ln for ln in head.split(b"\r\n") if not ln.lower().startswith(b"connection:")]
    lines.append(b"Connection: close")
    return b"\r\n".join(lines) + b"\r\n\r\n"


class Proxy(socketserver.BaseRequestHandler):
    def handle(self) -> None:
        cfg = self.server.cfg  # type: ignore[attr-defined]
        try:
            req = recv_message(self.request)
            if not req:
                return
            head, _, body = req.partition(b"\r\n\r\n")
            req = force_close(head) + body
            upstream = socket.create_connection(("127.0.0.1", cfg.upstream_port), timeout=5)
            upstream.sendall(req)
            resp = recv_message(upstream)
            upstream.close()

            if cfg.mode == "duplicate-request":
                try:
                    up2 = socket.create_connection(("127.0.0.1", cfg.upstream_port), timeout=5)
                    up2.sendall(req)
                    recv_message(up2)
                    up2.close()
                except OSError as exc:
                    print(json.dumps({"event": "dup_failed", "error": str(exc)}), flush=True)

            drop = cfg.mode == "drop-response"
            if cfg.mode == "drop-first":
                with self.server.lock:          # type: ignore[attr-defined]
                    self.server.count += 1      # type: ignore[attr-defined]
                    drop = self.server.count == 1  # type: ignore[attr-defined]
            if drop:
                print(json.dumps({"event": "drop_response",
                                  "bytes": len(resp)}), flush=True)
                self.request.close()
                return
            if cfg.mode == "delay-response":
                time.sleep(cfg.delay)
            self.request.sendall(resp)
            print(json.dumps({"event": "forwarded", "mode": cfg.mode,
                              "bytes": len(resp)}), flush=True)
        except Exception as exc:
            print(json.dumps({"event": "proxy_error", "error": str(exc)}), flush=True)
        finally:
            try:
                self.request.close()
            except OSError:
                pass


class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="HTTP 故障代理")
    ap.add_argument("--listen-port", type=int, default=8082)
    ap.add_argument("--upstream-port", type=int, default=8081)
    ap.add_argument("--mode", choices=["pass", "drop-response", "drop-first",
                                       "delay-response", "duplicate-request"],
                    default="pass")
    ap.add_argument("--delay", type=float, default=2.0)
    args = ap.parse_args(argv)
    srv = Server(("127.0.0.1", args.listen_port), Proxy)
    srv.cfg = args  # type: ignore[attr-defined]
    srv.count = 0   # type: ignore[attr-defined]
    srv.lock = threading.Lock()  # type: ignore[attr-defined]
    print(json.dumps({"event": "proxy_listen", "port": args.listen_port,
                      "upstream": args.upstream_port, "mode": args.mode}), flush=True)
    try:
        srv.serve_forever(poll_interval=0.2)
    except KeyboardInterrupt:
        pass
    finally:
        srv.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
