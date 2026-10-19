#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目二测试：选举、复制、重复写、杀主、分区、线性一致读。

运行：
    python3 -m unittest -v test_kv.py
"""

from __future__ import annotations

import json
import os
import socket
import sqlite3
import subprocess
import sys
import tempfile
import time
import unittest
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from kv_client import follow, request  # noqa: E402


def free_port() -> int:
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    p = s.getsockname()[1]
    s.close()
    return p


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


class Cluster:
    def __init__(self):
        self.tmp = tempfile.mkdtemp(prefix="kv-test-")
        self.ports = [free_port() for _ in range(3)]
        self.procs: list[subprocess.Popen] = []
        self.data = os.path.join(self.tmp, "data")
        os.makedirs(self.data, exist_ok=True)
        self.logs = []

    def start(self):
        for i, port in enumerate(self.ports, start=1):
            peers = []
            for j, p2 in enumerate(self.ports, start=1):
                if j != i:
                    peers += ["--peer", f"{j}=http://127.0.0.1:{p2}"]
            log = open(os.path.join(self.tmp, f"node-{i}.log"), "w")
            self.logs.append(log)
            proc = subprocess.Popen(
                [sys.executable, os.path.join(HERE, "raft_node.py"),
                 "--id", str(i), "--port", str(port), "--data-dir", self.data,
                 "--election-ms", "350", "--heartbeat-ms", "80", "--lease-ms", "600",
                 *peers],
                stdout=log, stderr=subprocess.STDOUT)
            self.procs.append(proc)
        for port in self.ports:
            assert wait_http(f"http://127.0.0.1:{port}/healthz"), "node did not start"

    def stop(self):
        for p in self.procs:
            if p.poll() is None:
                p.terminate()
        for p in self.procs:
            try:
                p.wait(timeout=3)
            except subprocess.TimeoutExpired:
                p.kill()
        for f in self.logs:
            f.close()

    def base(self, node_id: int) -> str:
        return f"http://127.0.0.1:{self.ports[node_id - 1]}"

    def status(self, node_id: int) -> dict:
        _, payload, _ = request(self.base(node_id), "GET", "/status", timeout=0.6)
        return payload

    def wait_leader(self, timeout: float = 6.0) -> int:
        deadline = time.monotonic() + timeout
        last = []
        while time.monotonic() < deadline:
            for i in (1, 2, 3):
                try:
                    st = self.status(i)
                    last.append((i, st.get("role"), st.get("term")))
                    if st.get("role") == "leader":
                        return i
                except Exception:
                    pass
            time.sleep(0.1)
        raise AssertionError(f"no leader; last={last}")

    def wait_new_leader(self, old: int, timeout: float = 6.0) -> int:
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            for i in (1, 2, 3):
                if i == old:
                    continue
                try:
                    if self.status(i).get("role") == "leader":
                        return i
                except Exception:
                    pass
            time.sleep(0.1)
        raise AssertionError("no new leader")

    def partition(self, node_id: int, peers: list[int], enabled: bool = True):
        body = {"peers": peers, "enabled": enabled}
        status, payload, _ = request(self.base(node_id), "POST", "/admin/partition", body)
        assert status == 200, payload


class KVTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.c = Cluster()
        cls.c.start()
        cls.leader = cls.c.wait_leader()
        cls.leader_base = cls.c.base(cls.leader)
        cls.followers = [i for i in (1, 2, 3) if i != cls.leader]

    @classmethod
    def tearDownClass(cls):
        cls.c.stop()

    def put(self, key: str, value: str, cid: str, seq: int = 1, base: str | None = None):
        body = {"key": key, "value": value, "client_id": cid, "seq": seq}
        return follow(base or self.leader_base, "POST", "/client/put", body, timeout=4.0)

    def get(self, key: str, consistency: str = "linearizable", base: str | None = None):
        return follow(base or self.leader_base, "GET",
                      f"/client/get?key={key}&consistency={consistency}", timeout=3.0)

    def test_1_put_get_linearizable(self):
        status, payload, _ = self.put("k1", "v1", "c-k1", 1)
        self.assertEqual(status, 200, payload)
        self.assertFalse(payload["duplicate"])
        status, payload, _ = self.get("k1")
        self.assertEqual(status, 200, payload)
        self.assertEqual(payload["value"], "v1")
        self.assertFalse(payload["stale"])

    def test_2_stale_read_from_follower(self):
        self.put("k2", "v2", "c-k2", 1)
        follower = self.c.base(self.followers[0])
        for _ in range(30):
            status, payload, _ = self.get("k2", "stale", base=follower)
            if status == 200 and payload.get("value") == "v2":
                self.assertTrue(payload["stale"])
                return
            time.sleep(0.1)
        self.fail("follower did not catch up")

    def test_3_duplicate_put_same_seq(self):
        status, first, _ = self.put("k3", "v3", "c-k3", 7)
        self.assertEqual(status, 200, first)
        status, second, _ = self.put("k3", "v3", "c-k3", 7)
        self.assertEqual(status, 200, second)
        self.assertTrue(second["duplicate"])
        self.assertEqual(first["version"], second["version"])
        # 各节点 dedup 表最多一条；跟随者可能稍晚应用，轮询等待。
        counts = {}
        for _ in range(50):
            counts = {}
            for i in (1, 2, 3):
                conn = sqlite3.connect(os.path.join(self.c.data, f"node-{i}.db"))
                try:
                    counts[i] = conn.execute(
                        "SELECT COUNT(*) FROM dedup WHERE client_id='c-k3'").fetchone()[0]
                finally:
                    conn.close()
            if all(v == 1 for v in counts.values()):
                break
            time.sleep(0.1)
        self.assertEqual(counts, {1: 1, 2: 1, 3: 1})

    def test_4_read_index_after_write(self):
        for i in range(5):
            self.put(f"k4-{i}", f"v4-{i}", f"c-k4-{i}", 1)
            status, payload, _ = self.get(f"k4-{i}")
            self.assertEqual(status, 200, payload)
            self.assertEqual(payload["value"], f"v4-{i}")


class FailoverTest(unittest.TestCase):
    def setUp(self):
        self.c = Cluster()
        self.c.start()
        self.leader = self.c.wait_leader()

    def tearDown(self):
        self.c.stop()

    def wait_read(self, base: str, key: str, value: str, timeout: float = 8.0) -> dict:
        """选举/恢复有短暂 503 窗口；轮询到读到期望值，避免把时序抖动当失败。"""
        deadline = time.monotonic() + timeout
        last = {}
        while time.monotonic() < deadline:
            try:
                status, payload, _ = follow(
                    base, "GET", f"/client/get?key={key}&consistency=linearizable",
                    timeout=2.0)
            except Exception as exc:                 # 节点正在重启/切主
                last = {"error": str(exc)}
                time.sleep(0.15)
                continue
            if status == 200 and payload.get("value") == value:
                return payload
            last = payload
            time.sleep(0.15)
        self.fail(f"did not read {key}={value}; last={last}")

    def test_kill_leader_then_new_leader_keeps_committed_value(self):
        base = self.c.base(self.leader)
        status, payload, _ = follow(base, "POST", "/client/put",
                                    {"key": "kk", "value": "vv",
                                     "client_id": "c-kk", "seq": 1}, timeout=4.0)
        self.assertEqual(status, 200, payload)
        old = self.leader
        self.c.procs[old - 1].terminate()
        self.c.procs[old - 1].wait(timeout=5)
        new = self.c.wait_new_leader(old)
        self.wait_read(self.c.base(new), "kk", "vv")

    def test_partition_leader_linearizable_read_fails_then_new_leader(self):
        base = self.c.base(self.leader)
        status, payload, _ = follow(base, "POST", "/client/put",
                                    {"key": "kp", "value": "vp",
                                     "client_id": "c-kp", "seq": 1}, timeout=4.0)
        self.assertEqual(status, 200, payload)
        old = self.leader
        peers = [i for i in (1, 2, 3) if i != old]
        self.c.partition(old, peers, True)
        time.sleep(1.2)
        status, payload, _ = follow(base, "GET",
                                    "/client/get?key=kp&consistency=linearizable",
                                    timeout=2.0)
        self.assertEqual(status, 503, payload)
        new = self.c.wait_new_leader(old)
        self.wait_read(self.c.base(new), "kp", "vp")
        # 解除隔离，旧主不应破坏已提交值
        self.c.partition(old, peers, False)
        time.sleep(0.5)
        self.wait_read(self.c.base(new), "kp", "vp")


if __name__ == "__main__":
    unittest.main(verbosity=2)
