#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目二：小型复制 KV（简化 Raft + 一致性读）。

实现范围
--------
- 三节点（可配置）选举：term、随机超时、RequestVote、日志新旧检查；
- 日志复制：AppendEntries、prevLogIndex/term、冲突截断、多数派提交；
- 当前 term 提交规则：leader 只直接提交当前 term 的日志项；
- 线性一致读：ReadIndex（心跳确认多数派 + 等 applied 追上）；
- 租约读：leader lease 内本地读；陈旧读：任意节点本地读；
- 客户端去重：状态机按 (client_id, seq) 去重，重复写返回原结果；
- 故障注入：/admin/partition 阻断与指定 peer 的双向 RPC。

运行：
    python3 raft_node.py --id 1 --port 7101 --data-dir .run \
      --peer 2=http://127.0.0.1:7102 --peer 3=http://127.0.0.1:7103
"""

from __future__ import annotations

import argparse
import json
import os
import random
import signal
import sqlite3
import sys
import threading
import time
import urllib.error
import urllib.request
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

TERM_KEY = "current_term"
VOTE_KEY = "voted_for"
COMMIT_KEY = "commit_index"
APPLIED_KEY = "last_applied"


def mono() -> float:
    return time.monotonic()


class Node:
    def __init__(self, node_id: int, port: int, data_dir: str,
                 peers: dict[int, str], election_ms: int = 500,
                 heartbeat_ms: int = 100, lease_ms: int = 800):
        self.id = node_id
        self.port = port
        self.base = f"http://127.0.0.1:{port}"
        self.peers = peers
        self.election_ms = election_ms
        self.heartbeat_ms = heartbeat_ms
        self.lease_ms = lease_ms
        self.quorum = (len(peers) + 1) // 2 + 1
        os.makedirs(data_dir, exist_ok=True)
        self.db_path = os.path.join(data_dir, f"node-{node_id}.db")
        self.lock = threading.RLock()
        self.cond = threading.Condition(self.lock)
        self.stop = threading.Event()

        self.role = "follower"
        self.current_term = 0
        self.voted_for: int | None = None
        self.commit_index = 0
        self.last_applied = 0
        self.log: list[dict] = []            # index 从 1 开始
        self.leader_id: int | None = None
        self.next_index: dict[int, int] = {}
        self.match_index: dict[int, int] = {}
        self.votes: set[int] = set()
        self.lease_until = 0.0
        self.last_quorum_ack = 0.0
        self.last_heartbeat = 0.0
        self.blocked_peers: set[int] = set()
        self.election_deadline = 0.0

        self._init_db()
        self._load()
        self._reset_election_deadline()
        self._tick_thread = threading.Thread(target=self._tick_loop, daemon=True)
        self._apply_thread = threading.Thread(target=self._apply_loop, daemon=True)

    # ------------------------------------------------------------------ #
    # 持久化
    # ------------------------------------------------------------------ #
    def _conn(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self.db_path, timeout=10, isolation_level=None)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA journal_mode=WAL")
        conn.execute("PRAGMA synchronous=FULL")
        conn.execute("PRAGMA busy_timeout=5000")
        return conn

    def _init_db(self) -> None:
        conn = self._conn()
        try:
            conn.executescript("""
            CREATE TABLE IF NOT EXISTS meta (key TEXT PRIMARY KEY, value TEXT NOT NULL);
            CREATE TABLE IF NOT EXISTS log (
              idx INTEGER PRIMARY KEY, term INTEGER NOT NULL, command TEXT NOT NULL);
            CREATE TABLE IF NOT EXISTS kv (
              key TEXT PRIMARY KEY, value TEXT NOT NULL, version INTEGER NOT NULL,
              client_id TEXT, seq INTEGER);
            CREATE TABLE IF NOT EXISTS dedup (
              client_id TEXT NOT NULL, seq INTEGER NOT NULL, result_json TEXT NOT NULL,
              applied_index INTEGER NOT NULL, PRIMARY KEY (client_id, seq));
            """)
        finally:
            conn.close()

    def _load(self) -> None:
        conn = self._conn()
        try:
            meta = {r["key"]: r["value"] for r in conn.execute("SELECT key,value FROM meta")}
            self.current_term = int(meta.get(TERM_KEY, "0"))
            v = meta.get(VOTE_KEY, "")
            self.voted_for = int(v) if v not in ("", None) else None
            self.commit_index = int(meta.get(COMMIT_KEY, "0"))
            self.last_applied = int(meta.get(APPLIED_KEY, "0"))
            self.log = [dict(r) for r in conn.execute(
                "SELECT idx,term,command FROM log ORDER BY idx")]
        finally:
            conn.close()

    def _persist_meta(self) -> None:
        conn = self._conn()
        try:
            conn.execute("BEGIN IMMEDIATE")
            for k, v in [
                (TERM_KEY, str(self.current_term)),
                (VOTE_KEY, "" if self.voted_for is None else str(self.voted_for)),
                (COMMIT_KEY, str(self.commit_index)),
                (APPLIED_KEY, str(self.last_applied)),
            ]:
                conn.execute("INSERT INTO meta(key,value) VALUES(?,?) "
                             "ON CONFLICT(key) DO UPDATE SET value=excluded.value", (k, v))
            conn.commit()
        finally:
            conn.close()

    def _append_log(self, term: int, command: str) -> int:
        idx = len(self.log) + 1
        conn = self._conn()
        try:
            conn.execute("INSERT INTO log(idx,term,command) VALUES(?,?,?)",
                         (idx, term, command))
        finally:
            conn.close()
        self.log.append({"idx": idx, "term": term, "command": command})
        return idx

    def _truncate_from(self, idx: int) -> None:
        conn = self._conn()
        try:
            conn.execute("DELETE FROM log WHERE idx>=?", (idx,))
        finally:
            conn.close()
        self.log = self.log[:idx - 1]

    @property
    def last_log_index(self) -> int:
        return len(self.log)

    @property
    def last_log_term(self) -> int:
        return self.log[-1]["term"] if self.log else 0

    # ------------------------------------------------------------------ #
    # 计时器
    # ------------------------------------------------------------------ #
    def _reset_election_deadline(self) -> None:
        lo, hi = self.election_ms * 0.5, self.election_ms * 1.5
        self.election_deadline = mono() + random.uniform(lo, hi) / 1000.0

    def _tick_loop(self) -> None:
        while not self.stop.wait(0.02):
            do_election = do_hb = False
            with self.lock:
                t = mono()
                if self.role == "leader":
                    if t - self.last_heartbeat >= self.heartbeat_ms / 1000.0:
                        self.last_heartbeat = t
                        do_hb = True
                    if t - self.last_quorum_ack > self.election_ms * 2 / 1000.0:
                        self._step_down()
                else:
                    if t >= self.election_deadline:
                        do_election = True
            if do_election:
                self._start_election()
            elif do_hb:
                self._replicate_all()

    def _step_down(self, term: int | None = None) -> None:
        with self.lock:
            if term is not None and term > self.current_term:
                self.current_term = term
                self.voted_for = None
                self._persist_meta()
            if self.role == "leader":
                print(json.dumps({"event": "step_down", "node": self.id,
                                  "term": self.current_term}), flush=True)
            self.role = "follower"
            self.leader_id = None
            self.lease_until = 0.0
            self._reset_election_deadline()
            self.cond.notify_all()

    # ------------------------------------------------------------------ #
    # 选举
    # ------------------------------------------------------------------ #
    def _start_election(self) -> None:
        with self.lock:
            if self.role == "leader":
                return
            self.role = "candidate"
            self.current_term += 1
            self.voted_for = self.id
            self.leader_id = None
            self.votes = {self.id}
            self._persist_meta()
            self._reset_election_deadline()
            term = self.current_term
            last_idx, last_term = self.last_log_index, self.last_log_term
        print(json.dumps({"event": "election_start", "node": self.id, "term": term}),
              flush=True)
        for p in self.peers:
            threading.Thread(target=self._ask_vote, args=(p, term, last_idx, last_term),
                             daemon=True).start()

    def _ask_vote(self, peer: int, term: int, last_idx: int, last_term: int) -> None:
        body = {"term": term, "candidate_id": self.id,
                "last_log_index": last_idx, "last_log_term": last_term,
                "from_id": self.id}
        resp = self._post(peer, "/request-vote", body, timeout=0.35)
        if not resp:
            return
        with self.lock:
            if resp.get("term", 0) > self.current_term:
                self._step_down(int(resp["term"]))
                return
            if self.role != "candidate" or self.current_term != term:
                return
            if resp.get("vote_granted"):
                self.votes.add(peer)
            if len(self.votes) >= self.quorum:
                self._become_leader()

    def _become_leader(self) -> None:
        with self.lock:
            if self.role == "leader":
                return
            self.role = "leader"
            self.leader_id = self.id
            # Raft 的 no-op：新 leader 必须先提交一条当前 term 的日志，
            # 才能安全推进 commitIndex、把旧 term 的已提交项一并应用。
            noop_idx = self._append_log(self.current_term, json.dumps({"op": "noop"}))
            self.next_index = {p: noop_idx for p in self.peers}
            self.match_index = {p: 0 for p in self.peers}
            self.last_quorum_ack = mono()
            self.lease_until = mono() + self.lease_ms / 1000.0
            term = self.current_term
        print(json.dumps({"event": "become_leader", "node": self.id, "term": term}),
              flush=True)
        self._replicate_all()

    # ------------------------------------------------------------------ #
    # 复制
    # ------------------------------------------------------------------ #
    def _replicate_all(self) -> None:
        with self.lock:
            if self.role != "leader":
                return
            peers = list(self.peers)
        for p in peers:
            threading.Thread(target=self._replicate_peer, args=(p,), daemon=True).start()

    def _replicate_peer(self, peer: int) -> dict | None:
        if peer in self.blocked_peers:
            return None
        with self.lock:
            if self.role != "leader":
                return None
            ni = self.next_index.get(peer, self.last_log_index + 1)
            ni = max(1, min(ni, self.last_log_index + 1))
            prev = ni - 1
            prev_term = self.log[prev - 1]["term"] if prev > 0 else 0
            entries = [dict(e) for e in self.log[prev:]]
            payload = {"term": self.current_term, "leader_id": self.id,
                       "from_id": self.id, "prev_log_index": prev,
                       "prev_log_term": prev_term, "entries": entries,
                       "leader_commit": self.commit_index}
            term = self.current_term
        resp = self._post(peer, "/append-entries", payload, timeout=0.35)
        if not resp:
            return None
        with self.lock:
            if resp.get("term", 0) > self.current_term:
                self._step_down(int(resp["term"]))
                return resp
            if self.role != "leader" or self.current_term != term:
                return resp
            if resp.get("success"):
                match = int(resp.get("match_index", 0))
                self.match_index[peer] = max(self.match_index.get(peer, 0), match)
                self.next_index[peer] = self.match_index[peer] + 1
                self.last_quorum_ack = mono()
                self.lease_until = max(self.lease_until,
                                       mono() + self.lease_ms / 1000.0)
                self._advance_commit()
            else:
                match = int(resp.get("match_index", 0))
                self.next_index[peer] = max(1, min(ni - 1, match + 1))
        return resp

    def _advance_commit(self) -> None:
        if self.role != "leader":
            return
        for n in range(self.last_log_index, 0, -1):
            count = 1 + sum(1 for p in self.peers if self.match_index.get(p, 0) >= n)
            if count < self.quorum:
                continue
            if self.log[n - 1]["term"] != self.current_term:
                continue
            if n > self.commit_index:
                self.commit_index = n
                self._persist_meta()
                self.cond.notify_all()
            return

    def _read_index(self) -> int | None:
        with self.lock:
            if self.role != "leader":
                return None
            ri = self.commit_index
            term = self.current_term
            peers = list(self.peers)
        acks = 1
        for p in peers:
            if p in self.blocked_peers:
                continue
            resp = self._replicate_peer(p)
            if resp and resp.get("term") == term and resp.get("success"):
                acks += 1
        with self.lock:
            if self.role != "leader" or self.current_term != term:
                return None
            if acks >= self.quorum:
                self.last_quorum_ack = mono()
                return ri
        return None

    # ------------------------------------------------------------------ #
    # RPC handlers
    # ------------------------------------------------------------------ #
    def handle_vote(self, body: dict) -> dict:
        from_id = int(body.get("from_id", 0))
        with self.lock:
            if from_id in self.blocked_peers:
                return {"term": self.current_term, "vote_granted": False}
            term = int(body.get("term", 0))
            if term < self.current_term:
                return {"term": self.current_term, "vote_granted": False}
            if term > self.current_term:
                self._step_down(term)
            cand = int(body.get("candidate_id", 0))
            up_to_date = (int(body.get("last_log_term", 0)) > self.last_log_term or
                          (int(body.get("last_log_term", 0)) == self.last_log_term and
                           int(body.get("last_log_index", 0)) >= self.last_log_index))
            granted = False
            if (self.voted_for in (None, cand)) and up_to_date:
                self.voted_for = cand
                self._persist_meta()
                self._reset_election_deadline()
                granted = True
            return {"term": self.current_term, "vote_granted": granted}

    def handle_append(self, body: dict) -> dict:
        from_id = int(body.get("from_id", 0))
        with self.lock:
            if from_id in self.blocked_peers:
                return {"term": self.current_term, "success": False,
                        "match_index": self.last_log_index}
            term = int(body.get("term", 0))
            if term < self.current_term:
                return {"term": self.current_term, "success": False,
                        "match_index": self.last_log_index}
            if term > self.current_term:
                self._step_down(term)
            self.role = "follower"
            self.leader_id = int(body.get("leader_id", 0))
            self.lease_until = 0.0
            self._reset_election_deadline()
            prev = int(body.get("prev_log_index", 0))
            prev_term = int(body.get("prev_log_term", 0))
            if prev > self.last_log_index:
                return {"term": self.current_term, "success": False,
                        "match_index": self.last_log_index}
            if prev > 0 and self.log[prev - 1]["term"] != prev_term:
                return {"term": self.current_term, "success": False,
                        "match_index": prev - 1}
            for e in body.get("entries", []):
                idx, et, cmd = int(e["idx"]), int(e["term"]), e["command"]
                if idx <= self.last_log_index:
                    if self.log[idx - 1]["term"] == et:
                        continue
                    self._truncate_from(idx)
                if idx != self.last_log_index + 1:
                    return {"term": self.current_term, "success": False,
                            "match_index": self.last_log_index}
                self._append_log(et, cmd)
            lc = int(body.get("leader_commit", 0))
            if lc > self.commit_index:
                self.commit_index = min(lc, self.last_log_index)
                self._persist_meta()
                self.cond.notify_all()
            return {"term": self.current_term, "success": True,
                    "match_index": self.last_log_index}

    # ------------------------------------------------------------------ #
    # 状态机
    # ------------------------------------------------------------------ #
    def _apply_loop(self) -> None:
        while not self.stop.wait(0.02):
            with self.lock:
                if self.last_applied >= self.commit_index:
                    continue
                idx = self.last_applied + 1
                if idx > self.last_log_index:
                    continue
                entry = dict(self.log[idx - 1])
            try:
                self._apply_entry(entry)
            except Exception as exc:
                print(json.dumps({"event": "apply_error", "node": self.id,
                                  "index": entry["idx"], "error": str(exc)}), flush=True)
                time.sleep(0.1)
                continue
            with self.lock:
                self.last_applied = idx
                self._persist_meta()
                self.cond.notify_all()

    def _apply_entry(self, entry: dict) -> None:
        cmd = json.loads(entry["command"])
        if cmd.get("op") != "put":
            return
        key, value = cmd["key"], cmd["value"]
        client_id, seq = cmd.get("client_id"), cmd.get("seq")
        conn = self._conn()
        try:
            conn.execute("BEGIN IMMEDIATE")
            if client_id is not None and seq is not None:
                row = conn.execute(
                    "SELECT result_json FROM dedup WHERE client_id=? AND seq=?",
                    (client_id, seq)).fetchone()
                if row is not None:
                    conn.commit()
                    return
            result = {"key": key, "value": value, "version": entry["idx"]}
            conn.execute("INSERT INTO kv(key,value,version,client_id,seq) VALUES(?,?,?,?,?) "
                         "ON CONFLICT(key) DO UPDATE SET value=excluded.value, "
                         "version=excluded.version, client_id=excluded.client_id, "
                         "seq=excluded.seq", (key, value, entry["idx"], client_id, seq))
            if client_id is not None and seq is not None:
                conn.execute("INSERT OR IGNORE INTO dedup(client_id,seq,result_json,applied_index) "
                             "VALUES(?,?,?,?)",
                             (client_id, seq, json.dumps(result, ensure_ascii=False),
                              entry["idx"]))
            conn.commit()
        finally:
            conn.close()

    def _wait_commit(self, idx: int, timeout: float = 2.0) -> bool:
        deadline = mono() + timeout
        with self.cond:
            while self.commit_index < idx and mono() < deadline:
                if self.role != "leader":
                    return False
                self.cond.wait(0.05)
            return self.commit_index >= idx

    def _wait_applied(self, idx: int, timeout: float = 2.0) -> bool:
        deadline = mono() + timeout
        with self.cond:
            while self.last_applied < idx and mono() < deadline:
                self.cond.wait(0.02)
            return self.last_applied >= idx

    # ------------------------------------------------------------------ #
    # 客户端 API
    # ------------------------------------------------------------------ #
    def handle_put(self, body: dict) -> tuple[int, dict, dict]:
        key = body.get("key")
        value = body.get("value")
        client_id = body.get("client_id")
        seq = body.get("seq")
        if not isinstance(key, str) or value is None:
            return 400, {"error": "key/value required"}, {}
        with self.lock:
            if self.role != "leader":
                return self._redirect()
            existing = self._get_dedup(client_id, seq)
            if existing is not None:
                return 200, {**existing, "duplicate": True, "served_by": self.id,
                            "term": self.current_term}, {}
            cmd = {"op": "put", "key": key, "value": value,
                   "client_id": client_id, "seq": seq}
            idx = self._append_log(self.current_term, json.dumps(cmd, ensure_ascii=False))
            term = self.current_term
        self._replicate_all()
        if self._wait_commit(idx, timeout=2.0):
            self._wait_applied(idx, timeout=1.0)
            result = self._get_dedup(client_id, seq) or {"key": key, "value": value,
                                                          "version": idx}
            return 200, {**result, "duplicate": False, "served_by": self.id,
                         "term": term, "index": idx}, {}
        with self.lock:
            if self.role != "leader":
                return 503, {"error": "leadership_lost", "index": idx}, {}
        return 202, {"status": "pending", "index": idx, "served_by": self.id,
                     "term": term}, {}

    def handle_get(self, key: str, consistency: str) -> tuple[int, dict, dict]:
        consistency = consistency or "linearizable"
        if consistency not in ("linearizable", "lease", "stale"):
            return 400, {"error": "consistency must be linearizable|lease|stale"}, {}
        with self.lock:
            if consistency in ("linearizable", "lease") and self.role != "leader":
                return self._redirect()
        if consistency == "linearizable":
            ri = self._read_index()
            if ri is None:
                return 503, {"error": "no_quorum", "consistency": consistency}, {}
            if not self._wait_applied(ri, timeout=1.0):
                return 503, {"error": "apply_lag", "read_index": ri}, {}
        elif consistency == "lease":
            with self.lock:
                if self.role != "leader" or mono() >= self.lease_until:
                    return 503, {"error": "lease_expired"}, {}
                ri = self.commit_index
            if not self._wait_applied(ri, timeout=1.0):
                return 503, {"error": "apply_lag", "read_index": ri}, {}
        else:
            with self.lock:
                ri = self.last_applied
        conn = self._conn()
        try:
            row = conn.execute("SELECT key,value,version FROM kv WHERE key=?", (key,)).fetchone()
        finally:
            conn.close()
        with self.lock:
            payload = {"key": key, "found": row is not None,
                       "value": row["value"] if row else None,
                       "version": row["version"] if row else None,
                       "consistency": consistency, "stale": consistency == "stale",
                       "read_index": ri, "applied_index": self.last_applied,
                       "served_by": self.id, "term": self.current_term,
                       "leader_id": self.leader_id}
        return 200, payload, {}

    def _get_dedup(self, client_id: str | None, seq: int | None) -> dict | None:
        if client_id is None or seq is None:
            return None
        conn = self._conn()
        try:
            row = conn.execute("SELECT result_json FROM dedup WHERE client_id=? AND seq=?",
                               (client_id, seq)).fetchone()
            return json.loads(row["result_json"]) if row else None
        finally:
            conn.close()

    def _redirect(self) -> tuple[int, dict, dict]:
        if self.leader_id and self.leader_id in self.peers:
            return 307, {"error": "not_leader", "leader_id": self.leader_id,
                         "term": self.current_term}, {"Location": self.peers[self.leader_id]}
        if self.leader_id == self.id:
            return 307, {"error": "not_leader"}, {"Location": self.base}
        return 503, {"error": "no_leader", "term": self.current_term}, {}

    def status(self) -> dict:
        with self.lock:
            return {"node": self.id, "role": self.role, "term": self.current_term,
                    "leader_id": self.leader_id, "commit_index": self.commit_index,
                    "last_applied": self.last_applied, "log_len": self.last_log_index,
                    "last_log_term": self.last_log_term, "quorum": self.quorum,
                    "lease_remaining_ms": max(0, int((self.lease_until - mono()) * 1000)),
                    "blocked_peers": sorted(self.blocked_peers),
                    "peers": self.peers, "base": self.base}

    # ------------------------------------------------------------------ #
    # 网络
    # ------------------------------------------------------------------ #
    def _post(self, peer: int, path: str, body: dict, timeout: float = 0.4) -> dict | None:
        if peer in self.blocked_peers or peer not in self.peers:
            return None
        url = self.peers[peer].rstrip("/") + path
        data = json.dumps(body, ensure_ascii=False).encode("utf-8")
        req = urllib.request.Request(url, data=data, method="POST")
        req.add_header("Content-Type", "application/json")
        try:
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except (urllib.error.URLError, TimeoutError, ConnectionError, json.JSONDecodeError):
            return None

    def start(self) -> None:
        self._tick_thread.start()
        self._apply_thread.start()

    def close(self) -> None:
        self.stop.set()
        with self.cond:
            self.cond.notify_all()


class Server(ThreadingHTTPServer):
    daemon_threads = True
    allow_reuse_address = True
    request_queue_size = 128


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "MiniKV/1.0"

    @property
    def node(self) -> Node:
        return self.server.node  # type: ignore[attr-defined]

    def log_message(self, fmt: str, *args: Any) -> None:
        return

    def _send(self, status: int, payload: dict, headers: dict | None = None) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def _body(self) -> dict:
        n = int(self.headers.get("Content-Length", "0") or "0")
        if n <= 0 or n > (1 << 20):
            return {}
        try:
            return json.loads(self.rfile.read(n).decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            return {}

    def do_GET(self) -> None:  # noqa: N802
        if self.path == "/healthz":
            self._send(200, {"ok": True, "node": self.node.id})
            return
        if self.path == "/status":
            self._send(200, self.node.status())
            return
        if self.path.startswith("/client/get"):
            from urllib.parse import parse_qs, urlparse
            q = parse_qs(urlparse(self.path).query)
            key = (q.get("key") or [""])[0]
            consistency = (q.get("consistency") or ["linearizable"])[0]
            status, payload, headers = self.node.handle_get(key, consistency)
            self._send(status, payload, headers)
            return
        self._send(404, {"error": "not_found"})

    def do_POST(self) -> None:  # noqa: N802
        body = self._body()
        if self.path == "/request-vote":
            self._send(200, self.node.handle_vote(body))
            return
        if self.path == "/append-entries":
            self._send(200, self.node.handle_append(body))
            return
        if self.path == "/client/put":
            status, payload, headers = self.node.handle_put(body)
            self._send(status, payload, headers)
            return
        if self.path == "/admin/partition":
            peers = {int(x) for x in body.get("peers", [])}
            enabled = bool(body.get("enabled", True))
            with self.node.lock:
                if enabled:
                    self.node.blocked_peers |= peers
                else:
                    self.node.blocked_peers -= peers
            self._send(200, {"blocked_peers": sorted(self.node.blocked_peers)})
            return
        if self.path == "/admin/heal":
            with self.node.lock:
                self.node.blocked_peers.clear()
            self._send(200, {"blocked_peers": []})
            return
        self._send(404, {"error": "not_found"})


def parse_peers(items: list[str]) -> dict[int, str]:
    out = {}
    for item in items:
        if "=" not in item:
            raise SystemExit(f"--peer 需要 id=url 形式：{item}")
        k, v = item.split("=", 1)
        out[int(k)] = v.rstrip("/")
    return out


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="小型复制 KV 节点")
    ap.add_argument("--id", type=int, required=True)
    ap.add_argument("--port", type=int, required=True)
    ap.add_argument("--data-dir", default=".run")
    ap.add_argument("--peer", action="append", default=[])
    ap.add_argument("--election-ms", type=int, default=500)
    ap.add_argument("--heartbeat-ms", type=int, default=100)
    ap.add_argument("--lease-ms", type=int, default=800)
    args = ap.parse_args(argv)
    peers = parse_peers(args.peer)
    node = Node(args.id, args.port, args.data_dir, peers,
                args.election_ms, args.heartbeat_ms, args.lease_ms)
    httpd = Server(("127.0.0.1", args.port), Handler)
    httpd.node = node  # type: ignore[attr-defined]
    node.start()
    print(json.dumps({"event": "listen", "node": node.id,
                      "url": node.base, "peers": peers}), flush=True)

    def _stop(signum, frame):  # noqa: ARG001
        node.close()
        threading.Thread(target=httpd.shutdown, daemon=True).start()

    signal.signal(signal.SIGINT, _stop)
    signal.signal(signal.SIGTERM, _stop)
    try:
        httpd.serve_forever(poll_interval=0.1)
    finally:
        node.close()
        httpd.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
