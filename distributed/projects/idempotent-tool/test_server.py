#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目一测试：同键去重、并发、崩溃恢复、丢响应重试。

运行：
    python3 -m unittest -v test_server.py
"""

from __future__ import annotations

import json
import os
import socket
import sqlite3
import subprocess
import sys
import tempfile
import threading
import time
import unittest
import urllib.error
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from client import call_tool, poll                    # noqa: E402
from server import make_server                       # noqa: E402


def free_port() -> int:
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    port = s.getsockname()[1]
    s.close()
    return port


def http_json(method: str, url: str, body: dict | None = None,
              headers: dict | None = None, timeout: float = 2.0):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Content-Type", "application/json")
    for k, v in (headers or {}).items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return resp.status, json.loads(resp.read().decode())
    except urllib.error.HTTPError as exc:
        return exc.code, json.loads(exc.read().decode())


def wait_http(url: str, timeout: float = 5.0) -> bool:
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        try:
            with urllib.request.urlopen(url, timeout=0.3) as resp:
                if resp.status == 200:
                    return True
        except Exception:
            time.sleep(0.05)
    return False


class ServerTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.mkdtemp(prefix="idem-test-")
        cls.db = os.path.join(cls.tmp, "test.db")
        cls.httpd, cls.app = make_server(cls.db, port=0, workers=8, lease=30.0)
        cls.port = cls.httpd.server_address[1]
        cls.base = f"http://127.0.0.1:{cls.port}"
        cls.thread = threading.Thread(target=cls.httpd.serve_forever, daemon=True)
        cls.thread.start()
        assert wait_http(cls.base + "/healthz"), "server did not start"

    @classmethod
    def tearDownClass(cls):
        cls.app.stop()
        cls.httpd.shutdown()
        cls.httpd.server_close()

    def setUp(self):
        """等上一用例可能遗留的异步副作用落地，避免跨用例的 effects 计数干扰。"""
        deadline = time.monotonic() + 5.0
        while time.monotonic() < deadline:
            conn = sqlite3.connect(self.db)
            try:
                pending = conn.execute(
                    "SELECT COUNT(*) FROM calls "
                    "WHERE status NOT IN ('succeeded', 'failed')").fetchone()[0]
            finally:
                conn.close()
            if pending == 0:
                return
            time.sleep(0.02)

    def post(self, key: str, tool: str = "charge", args: dict | None = None,
             timeout: float = 3.0):
        return http_json("POST", self.base + "/v1/tool-calls",
                         body={"tool": tool, "args": args or {"amount": 100},
                               "client_id": "test", "seq": 1},
                         headers={"Idempotency-Key": key}, timeout=timeout)

    def effects(self) -> int:
        conn = sqlite3.connect(self.db)
        try:
            return conn.execute("SELECT COUNT(*) FROM effects").fetchone()[0]
        finally:
            conn.close()

    def wait_status(self, call_id: str, timeout: float = 5.0) -> dict:
        deadline = time.monotonic() + timeout
        last = {}
        while time.monotonic() < deadline:
            status, last = http_json("GET", f"{self.base}/v1/tool-calls/{call_id}")
            if status == 200 and last.get("status") in ("succeeded", "failed"):
                return last
            time.sleep(0.05)
        return last

    def test_same_key_returns_same_call(self):
        before = self.effects()
        status, first = self.post("k-same", args={"amount": 11})
        self.assertEqual(status, 202, first)
        done = self.wait_status(first["call_id"])
        self.assertEqual(done["status"], "succeeded")
        status2, second = self.post("k-same", args={"amount": 11})
        self.assertEqual(status2, 200, second)
        self.assertEqual(first["call_id"], second["call_id"])
        self.assertEqual(self.effects(), before + 1)
        self.assertEqual(second["attempt"], 1)       # 没有再次执行

    def test_different_key_creates_new_call(self):
        before = self.effects()
        _, a = self.post("k-a", args={"amount": 1})
        _, b = self.post("k-b", args={"amount": 1})
        self.assertNotEqual(a["call_id"], b["call_id"])
        self.wait_status(a["call_id"])
        self.wait_status(b["call_id"])
        self.assertEqual(self.effects(), before + 2)

    def test_same_key_different_args_conflict(self):
        status0, first = self.post("k-conflict", args={"amount": 1})
        self.assertEqual(status0, 202, first)
        self.wait_status(first["call_id"])   # 等副作用落地，避免干扰后续用例计数
        status, payload = self.post("k-conflict", args={"amount": 2})
        self.assertEqual(status, 409, payload)
        self.assertEqual(payload["error"]["code"], "idempotency_conflict")

    def test_concurrent_same_key_one_effect(self):
        before = self.effects()
        results: list[dict] = []
        lock = threading.Lock()

        def worker():
            _, payload = self.post("k-concurrent", args={"amount": 3, "sleep_ms": 100})
            with lock:
                results.append(payload)

        threads = [threading.Thread(target=worker) for _ in range(12)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        ids = {r["call_id"] for r in results}
        self.assertEqual(len(ids), 1, results)
        self.wait_status(results[0]["call_id"])
        self.assertEqual(self.effects(), before + 1)

    def test_failed_retryable_can_be_retried(self):
        status, first = self.post("k-fail", tool="fail",
                                  args={"message": "boom", "retryable": True})
        self.assertEqual(status, 202)
        done = self.wait_status(first["call_id"])
        self.assertEqual(done["status"], "failed")
        self.assertTrue(done["error"]["retryable"])
        status2, second = self.post("k-fail", tool="fail",
                                    args={"message": "boom", "retryable": True})
        self.assertEqual(status2, 202, second)
        self.assertEqual(first["call_id"], second["call_id"])
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            _, current = http_json("GET", f"{self.base}/v1/tool-calls/{first['call_id']}")
            if current.get("attempt", 0) >= 2:
                break
            time.sleep(0.05)
        self.assertGreaterEqual(current["attempt"], 2)


class CrashRecoveryTest(unittest.TestCase):
    def test_crash_after_commit_then_restart(self):
        tmp = tempfile.mkdtemp(prefix="idem-crash-")
        db = os.path.join(tmp, "crash.db")
        port = free_port()
        proc = subprocess.Popen(
            [sys.executable, os.path.join(HERE, "server.py"),
             "--port", str(port), "--db", db, "--enable-chaos"],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        base = f"http://127.0.0.1:{port}"
        try:
            self.assertTrue(wait_http(base + "/healthz"), "server did not start")
            status, payload = http_json(
                "POST", base + "/v1/tool-calls",
                body={"tool": "charge",
                      "args": {"amount": 7, "_crash_after_commit": True},
                      "client_id": "crash", "seq": 1},
                headers={"Idempotency-Key": "k-crash"}, timeout=2.0)
            # 服务端提交后直接退出，客户端通常拿不到响应；无论 status 是什么，
            # 只要 calls/effects 已提交，就算“响应丢失但副作用已发生”。
            self.assertIn(status, (200, 202, 500), payload)
        except (urllib.error.URLError, ConnectionError, TimeoutError):
            pass
        finally:
            try:
                proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                proc.kill()

        conn = sqlite3.connect(db)
        try:
            rows = conn.execute("SELECT status FROM calls WHERE idem_key='k-crash'").fetchall()
            effects = conn.execute("SELECT COUNT(*) FROM effects").fetchone()[0]
        finally:
            conn.close()
        self.assertEqual(len(rows), 1, rows)
        self.assertEqual(effects, 1)

        # 重启：同键请求应返回原 call，而不是再发一张。
        port2 = free_port()
        proc2 = subprocess.Popen(
            [sys.executable, os.path.join(HERE, "server.py"),
             "--port", str(port2), "--db", db],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        base2 = f"http://127.0.0.1:{port2}"
        try:
            self.assertTrue(wait_http(base2 + "/healthz"), "server did not restart")
            status, again = http_json(
                "POST", base2 + "/v1/tool-calls",
                body={"tool": "charge",
                      "args": {"amount": 7, "_crash_after_commit": True},
                      "client_id": "crash", "seq": 1},
                headers={"Idempotency-Key": "k-crash"}, timeout=2.0)
            self.assertEqual(status, 200, again)
            self.assertEqual(again["status"], "succeeded")
            self.assertEqual(again["attempt"], 1)
            conn = sqlite3.connect(db)
            try:
                self.assertEqual(
                    conn.execute("SELECT COUNT(*) FROM effects").fetchone()[0], 1)
            finally:
                conn.close()
        finally:
            proc2.terminate()
            try:
                proc2.wait(timeout=5)
            except subprocess.TimeoutExpired:
                proc2.kill()


class ProxyTest(unittest.TestCase):
    def test_delay_response_then_retry_same_key(self):
        tmp = tempfile.mkdtemp(prefix="idem-proxy-")
        db = os.path.join(tmp, "proxy.db")
        port = free_port()
        proxy_port = free_port()
        server = subprocess.Popen(
            [sys.executable, os.path.join(HERE, "server.py"),
             "--port", str(port), "--db", db],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        proxy = subprocess.Popen(
            [sys.executable, os.path.join(HERE, "chaos_proxy.py"),
             "--listen-port", str(proxy_port), "--upstream-port", str(port),
             "--mode", "drop-first"],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        base = f"http://127.0.0.1:{port}"
        proxy_base = f"http://127.0.0.1:{proxy_port}"
        try:
            self.assertTrue(wait_http(base + "/healthz"))
            time.sleep(0.2)
            payload = call_tool(proxy_base, "k-proxy", "charge", {"amount": 9},
                                timeout=0.6, retries=3, verbose=False)
            self.assertIn(payload.get("status"), ("succeeded", "running", "pending"),
                          payload)
            call_id = payload.get("call_id")
            self.assertTrue(call_id)
            final = poll(base, call_id, timeout=5)
            self.assertEqual(final["status"], "succeeded")
            conn = sqlite3.connect(db)
            try:
                self.assertEqual(
                    conn.execute("SELECT COUNT(*) FROM effects").fetchone()[0], 1)
                self.assertEqual(
                    conn.execute("SELECT COUNT(*) FROM calls").fetchone()[0], 1)
            finally:
                conn.close()
        finally:
            proxy.terminate()
            server.terminate()
            for p in (proxy, server):
                try:
                    p.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    p.kill()


if __name__ == "__main__":
    unittest.main(verbosity=2)
