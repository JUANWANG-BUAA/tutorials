#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""项目一：幂等工具调用后端（Python 标准库 + SQLite）。

不变量
------
1. 同一个 Idempotency-Key 只对应一条 calls 记录；
2. 同一个 call_id 只产生一条 effects 记录（UNIQUE 约束）；
3. 同键不同指纹返回 409，不覆盖原结果；
4. 执行中用 lease 防并发；lease 过期可被接管，但副作用仍由 effect 唯一约束兜底；
5. 崩溃恢复只重放 pending/lease 过期的 calls，不会重复副作用。

运行：
    python3 server.py --port 8081 --db /tmp/idem.db
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import signal
import sqlite3
import sys
import threading
import time
import uuid
from concurrent.futures import ThreadPoolExecutor
from contextlib import contextmanager
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any
from urllib.parse import unquote, urlparse

LEASE_SECONDS = 30.0
MAX_BODY = 1 << 20
TERMINAL = ("succeeded", "failed")


def now() -> float:
    return time.time()


def canonical_args(args: dict) -> str:
    return json.dumps(args, sort_keys=True, separators=(",", ":"), ensure_ascii=False)


def fingerprint(tool: str, args: dict) -> str:
    payload = json.dumps({"tool": tool, "args": args}, sort_keys=True,
                         separators=(",", ":"), ensure_ascii=False)
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def effect_id_for(call_id: str) -> str:
    return "eff_" + hashlib.sha256(call_id.encode("utf-8")).hexdigest()[:16]


@contextmanager
def db_conn(path: str):
    conn = sqlite3.connect(path, timeout=10, isolation_level=None)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA synchronous=FULL")
    conn.execute("PRAGMA busy_timeout=5000")
    conn.execute("PRAGMA foreign_keys=ON")
    try:
        yield conn
    finally:
        conn.close()


SCHEMA = """
CREATE TABLE IF NOT EXISTS calls (
  call_id      TEXT PRIMARY KEY,
  idem_key     TEXT NOT NULL UNIQUE,
  fingerprint  TEXT NOT NULL,
  client_id    TEXT,
  seq          INTEGER,
  tool         TEXT NOT NULL,
  args_json    TEXT NOT NULL,
  status       TEXT NOT NULL,
  result_json  TEXT,
  error_json   TEXT,
  attempt      INTEGER NOT NULL DEFAULT 0,
  lease_until  REAL,
  owner        TEXT,
  effect_id    TEXT,
  created_at   REAL NOT NULL,
  updated_at   REAL NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_calls_status ON calls(status, lease_until);
CREATE INDEX IF NOT EXISTS idx_calls_client_seq ON calls(client_id, seq);

CREATE TABLE IF NOT EXISTS effects (
  effect_id   TEXT PRIMARY KEY,
  call_id     TEXT NOT NULL UNIQUE,
  tool        TEXT NOT NULL,
  amount      INTEGER,
  created_at  REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS audit (
  id       INTEGER PRIMARY KEY AUTOINCREMENT,
  ts       REAL NOT NULL,
  call_id  TEXT,
  event    TEXT NOT NULL,
  detail   TEXT
);
"""


def init_db(path: str) -> None:
    with db_conn(path) as conn:
        conn.executescript(SCHEMA)


def audit(conn: sqlite3.Connection, call_id: str | None, event: str, detail: str = "") -> None:
    conn.execute("INSERT INTO audit(ts, call_id, event, detail) VALUES(?,?,?,?)",
                 (now(), call_id, event, detail))


class ToolError(Exception):
    def __init__(self, message: str, retryable: bool = False, code: str = "tool_error"):
        super().__init__(message)
        self.message = message
        self.retryable = retryable
        self.code = code


class CallStore:
    """所有状态迁移都在 SQLite 事务里完成；HTTP 层不直接改状态。"""

    def __init__(self, db_path: str, lease_seconds: float = LEASE_SECONDS):
        self.db_path = db_path
        self.lease_seconds = lease_seconds

    def create_or_get(self, key: str, fp: str, tool: str, args: dict,
                      client_id: str | None, seq: int | None) -> tuple[dict, bool]:
        """返回 (call, should_submit)。同键不同指纹抛 ValueError。"""
        ts = now()
        with db_conn(self.db_path) as conn:
            conn.execute("BEGIN IMMEDIATE")
            try:
                row = conn.execute("SELECT * FROM calls WHERE idem_key=?", (key,)).fetchone()
                if row is not None:
                    if row["fingerprint"] != fp:
                        raise ValueError("idempotency key reused with different arguments")
                    if row["status"] == "failed":
                        err = json.loads(row["error_json"] or "{}")
                        if err.get("retryable"):
                            conn.execute(
                                "UPDATE calls SET status='pending', lease_until=NULL, owner=NULL, "
                                "updated_at=? WHERE call_id=?",
                                (ts, row["call_id"]))
                            audit(conn, row["call_id"], "retry_reset", err.get("code", ""))
                            conn.commit()
                            row = conn.execute("SELECT * FROM calls WHERE call_id=?",
                                               (row["call_id"],)).fetchone()
                            return self._row(row), True
                    conn.commit()
                    return self._row(row), False

                call_id = "c_" + uuid.uuid4().hex[:16]
                conn.execute(
                    "INSERT INTO calls(call_id, idem_key, fingerprint, client_id, seq, tool, "
                    "args_json, status, attempt, created_at, updated_at) "
                    "VALUES(?,?,?,?,?,?,?, 'pending', 0, ?, ?)",
                    (call_id, key, fp, client_id, seq, tool, canonical_args(args), ts, ts))
                audit(conn, call_id, "created", tool)
                row = conn.execute("SELECT * FROM calls WHERE call_id=?", (call_id,)).fetchone()
                conn.commit()
                return self._row(row), True
            except Exception:
                conn.rollback()
                raise

    def get(self, call_id: str) -> dict | None:
        with db_conn(self.db_path) as conn:
            row = conn.execute("SELECT * FROM calls WHERE call_id=?", (call_id,)).fetchone()
            return self._row(row) if row else None

    def get_by_key(self, key: str) -> dict | None:
        with db_conn(self.db_path) as conn:
            row = conn.execute("SELECT * FROM calls WHERE idem_key=?", (key,)).fetchone()
            return self._row(row) if row else None

    def claim(self, call_id: str, owner: str) -> dict | None:
        """原子领取：只有 pending 或 running 且租约过期才可领取。"""
        ts = now()
        with db_conn(self.db_path) as conn:
            conn.execute("BEGIN IMMEDIATE")
            try:
                row = conn.execute("SELECT * FROM calls WHERE call_id=?", (call_id,)).fetchone()
                if row is None or row["status"] in TERMINAL:
                    conn.commit()
                    return None
                if row["status"] == "running" and (row["lease_until"] or 0) > ts:
                    conn.commit()
                    return None
                cur = conn.execute(
                    "UPDATE calls SET status='running', attempt=attempt+1, lease_until=?, "
                    "owner=?, updated_at=? WHERE call_id=? AND status!='succeeded' "
                    "AND status!='failed' AND (status!='running' OR lease_until IS NULL "
                    "OR lease_until<=?)",
                    (ts + self.lease_seconds, owner, ts, call_id, ts))
                if cur.rowcount != 1:
                    conn.commit()
                    return None
                audit(conn, call_id, "claimed", owner)
                row = conn.execute("SELECT * FROM calls WHERE call_id=?", (call_id,)).fetchone()
                conn.commit()
                return self._row(row)
            except Exception:
                conn.rollback()
                raise

    def succeed(self, call_id: str, result: dict, effect_id: str | None,
                args: dict) -> dict:
        """副作用与状态在同一个事务里提交；effects 的 UNIQUE 是最后一道闸门。"""
        ts = now()
        with db_conn(self.db_path) as conn:
            conn.execute("BEGIN IMMEDIATE")
            try:
                if effect_id is not None:
                    conn.execute(
                        "INSERT OR IGNORE INTO effects(effect_id, call_id, tool, amount, created_at) "
                        "VALUES(?,?,?,?,?)",
                        (effect_id, call_id, result.get("tool", "unknown"),
                         result.get("amount"), ts))
                row = conn.execute(
                    "UPDATE calls SET status='succeeded', result_json=?, error_json=NULL, "
                    "effect_id=?, lease_until=NULL, owner=NULL, updated_at=? WHERE call_id=?",
                    (json.dumps(result, ensure_ascii=False), effect_id, ts, call_id))
                if row.rowcount != 1:
                    raise RuntimeError(f"call disappeared: {call_id}")
                audit(conn, call_id, "succeeded", effect_id or "")
                conn.commit()
            except Exception:
                conn.rollback()
                raise
        return result

    def fail(self, call_id: str, exc: Exception) -> None:
        ts = now()
        if isinstance(exc, ToolError):
            err = {"code": exc.code, "message": exc.message, "retryable": exc.retryable}
        else:
            err = {"code": "internal", "message": str(exc), "retryable": True}
        with db_conn(self.db_path) as conn:
            conn.execute("BEGIN IMMEDIATE")
            conn.execute(
                "UPDATE calls SET status='failed', error_json=?, lease_until=NULL, owner=NULL, "
                "updated_at=? WHERE call_id=? AND status!='succeeded'",
                (json.dumps(err, ensure_ascii=False), ts, call_id))
            audit(conn, call_id, "failed", err["code"])
            conn.commit()

    def recover(self) -> int:
        """重启后把 running 且租约过期的记录放回 pending；不重放已终态记录。"""
        ts = now()
        with db_conn(self.db_path) as conn:
            conn.execute("BEGIN IMMEDIATE")
            cur = conn.execute(
                "UPDATE calls SET status='pending', lease_until=NULL, owner=NULL, updated_at=? "
                "WHERE status='running' AND (lease_until IS NULL OR lease_until<=?)",
                (ts, ts))
            audit(conn, None, "recover", str(cur.rowcount))
            conn.commit()
            return cur.rowcount

    def pending(self, limit: int = 100) -> list[str]:
        with db_conn(self.db_path) as conn:
            rows = conn.execute(
                "SELECT call_id FROM calls WHERE status='pending' ORDER BY created_at LIMIT ?",
                (limit,)).fetchall()
            return [r["call_id"] for r in rows]

    def stats(self) -> dict:
        with db_conn(self.db_path) as conn:
            by_status = {r["status"]: r["n"] for r in conn.execute(
                "SELECT status, COUNT(*) AS n FROM calls GROUP BY status")}
            effects = conn.execute("SELECT COUNT(*) AS n FROM effects").fetchone()["n"]
            calls = conn.execute("SELECT COUNT(*) AS n FROM calls").fetchone()["n"]
            return {"calls": calls, "effects": effects, "by_status": by_status}

    @staticmethod
    def _row(row: sqlite3.Row) -> dict:
        out = dict(row)
        out["result"] = json.loads(row["result_json"]) if row["result_json"] else None
        out["error"] = json.loads(row["error_json"]) if row["error_json"] else None
        out.pop("result_json", None)
        out.pop("error_json", None)
        out.pop("fingerprint", None)
        out["query_url"] = f"/v1/tool-calls/{row['call_id']}"
        return out


class Runner:
    def __init__(self, store: CallStore, workers: int = 4, enable_chaos: bool = False):
        self.store = store
        self.pool = ThreadPoolExecutor(max_workers=workers, thread_name_prefix="tool")
        self.enable_chaos = enable_chaos
        self._inflight: set[str] = set()
        self._lock = threading.Lock()
        self._stop = threading.Event()

    def submit(self, call_id: str) -> None:
        with self._lock:
            if call_id in self._inflight or self._stop.is_set():
                return
            self._inflight.add(call_id)
        self.pool.submit(self._run, call_id)

    def _run(self, call_id: str) -> None:
        try:
            self._execute(call_id)
        finally:
            with self._lock:
                self._inflight.discard(call_id)

    def _execute(self, call_id: str) -> None:
        owner = f"{os.getpid()}:{threading.get_ident()}"
        call = self.store.claim(call_id, owner)
        if call is None:
            return
        args = json.loads(call["args_json"])
        tool = call["tool"]
        # 允许测试注入“提交后进程崩溃”，用来验证恢复路径。
        crash_after_commit = bool(args.pop("_crash_after_commit", False)) and self.enable_chaos
        try:
            result = self._invoke(tool, args)
            eid = None
            if tool in ("charge", "send_email"):
                eid = effect_id_for(call_id)
                result["effect_id"] = eid
            self.store.succeed(call_id, result, eid, args)
            if crash_after_commit:
                print(json.dumps({"event": "chaos_crash", "call_id": call_id}), flush=True)
                os._exit(1)
            print(json.dumps({"event": "tool_ok", "call_id": call_id,
                              "tool": tool, "attempt": call["attempt"]}), flush=True)
        except ToolError as exc:
            self.store.fail(call_id, exc)
            print(json.dumps({"event": "tool_fail", "call_id": call_id,
                              "code": exc.code, "retryable": exc.retryable}), flush=True)
        except Exception as exc:                       # 未预期异常也要落状态
            self.store.fail(call_id, exc)
            print(json.dumps({"event": "tool_error", "call_id": call_id,
                              "error": str(exc)}), flush=True)

    def _invoke(self, tool: str, args: dict) -> dict:
        sleep_ms = int(args.get("sleep_ms", 0) or 0)
        if sleep_ms > 0:
            time.sleep(min(sleep_ms, 10_000) / 1000.0)
        if tool == "charge":
            amount = int(args.get("amount", 0))
            if amount <= 0:
                raise ToolError("amount must be positive", retryable=False, code="invalid_amount")
            return {"tool": "charge", "amount": amount,
                    "effect_id": None, "charged": True}
        if tool == "send_email":
            return {"tool": "send_email", "to": args.get("to", ""), "sent": True}
        if tool == "sleep":
            return {"tool": "sleep", "slept_ms": sleep_ms}
        if tool == "fail":
            raise ToolError(str(args.get("message", "simulated failure")),
                            retryable=bool(args.get("retryable", False)))
        raise ToolError(f"unknown tool: {tool}", retryable=False, code="unknown_tool")

    def close(self) -> None:
        self._stop.set()
        self.pool.shutdown(wait=False, cancel_futures=True)


class Server(ThreadingHTTPServer):
    daemon_threads = True
    allow_reuse_address = True
    request_queue_size = 128


class App:
    def __init__(self, db_path: str, lease: float = LEASE_SECONDS,
                 workers: int = 4, enable_chaos: bool = False):
        self.db_path = db_path
        self.lease = lease
        self.store = CallStore(db_path, lease)
        self.runner = Runner(self.store, workers, enable_chaos)
        self.started_at = now()
        self._stop = threading.Event()
        self._scheduler = threading.Thread(target=self._schedule, daemon=True)

    def start(self) -> None:
        recovered = self.store.recover()
        print(json.dumps({"event": "startup", "recovered": recovered,
                          "db": self.db_path}), flush=True)
        self._scheduler.start()
        for call_id in self.store.pending():
            self.runner.submit(call_id)

    def _schedule(self) -> None:
        while not self._stop.wait(0.2):
            try:
                # 租约过期的 running 也放回 pending；副作用由 effects 唯一约束兜底。
                self.store.recover()
                for call_id in self.store.pending(50):
                    self.runner.submit(call_id)
            except Exception as exc:                  # 调度线程不能死
                print(json.dumps({"event": "scheduler_error", "error": str(exc)}), flush=True)

    def stop(self) -> None:
        self._stop.set()
        self.runner.close()


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "IdemTool/1.0"

    @property
    def app(self) -> App:
        return self.server.app  # type: ignore[attr-defined]

    def log_message(self, fmt: str, *args: Any) -> None:
        return

    def _send(self, status: int, payload: dict, headers: dict | None = None) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("X-Trace-Id", getattr(self, "trace_id", "-"))
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def _read_json(self) -> dict:
        length = int(self.headers.get("Content-Length", "0") or "0")
        if length <= 0 or length > MAX_BODY:
            raise ValueError("empty or too-large body")
        raw = self.rfile.read(length)
        try:
            data = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError) as exc:
            raise ValueError(f"invalid json: {exc}") from exc
        if not isinstance(data, dict):
            raise ValueError("body must be an object")
        return data

    def do_GET(self) -> None:  # noqa: N802
        self.trace_id = self.headers.get("X-Trace-Id") or uuid.uuid4().hex
        path = urlparse(self.path).path
        if path == "/healthz":
            self._send(200, {"ok": True, "uptime_s": round(now() - self.app.started_at, 3)})
            return
        if path == "/stats":
            self._send(200, self.app.store.stats())
            return
        if path.startswith("/v1/tool-calls/by-key/"):
            key = unquote(path[len("/v1/tool-calls/by-key/"):])
            call = self.app.store.get_by_key(key)
            if call is None:
                self._send(404, {"error": {"code": "not_found", "message": key}})
            else:
                self._send(200, call)
            return
        if path.startswith("/v1/tool-calls/"):
            cid = path[len("/v1/tool-calls/"):]
            call = self.app.store.get(cid)
            if call is None:
                self._send(404, {"error": {"code": "not_found", "message": cid}})
            else:
                self._send(200, call)
            return
        self._send(404, {"error": {"code": "not_found", "message": path}})

    def do_POST(self) -> None:  # noqa: N802
        self.trace_id = self.headers.get("X-Trace-Id") or uuid.uuid4().hex
        path = urlparse(self.path).path
        if path != "/v1/tool-calls":
            self._send(404, {"error": {"code": "not_found", "message": path}})
            return
        key = self.headers.get("Idempotency-Key", "").strip()
        if not key:
            self._send(400, {"error": {"code": "missing_idempotency_key",
                                       "message": "Idempotency-Key header is required"}})
            return
        try:
            body = self._read_json()
        except ValueError as exc:
            self._send(400, {"error": {"code": "bad_request", "message": str(exc)}})
            return
        tool = body.get("tool")
        args = body.get("args", {})
        if not isinstance(tool, str) or not tool:
            self._send(400, {"error": {"code": "bad_request", "message": "tool is required"}})
            return
        if not isinstance(args, dict):
            self._send(400, {"error": {"code": "bad_request", "message": "args must be object"}})
            return
        client_id = body.get("client_id")
        seq = body.get("seq")
        fp = fingerprint(tool, args)
        try:
            call, should_submit = self.app.store.create_or_get(
                key, fp, tool, args, client_id, seq)
        except ValueError:
            self._send(409, {"error": {"code": "idempotency_conflict",
                                       "message": "same key, different fingerprint"}})
            return
        if should_submit:
            self.app.runner.submit(call["call_id"])
        status_code = 200 if call["status"] in TERMINAL else 202
        headers = {}
        if call["status"] in ("pending", "running"):
            headers["Retry-After"] = "0"
        self._send(status_code, call, headers)
        print(json.dumps({"event": "http_post", "trace": self.trace_id,
                          "call_id": call["call_id"], "status": call["status"],
                          "attempt": call["attempt"]}), flush=True)


def make_server(db_path: str, port: int = 0, workers: int = 4,
                lease: float = LEASE_SECONDS, enable_chaos: bool = False):
    init_db(db_path)
    app = App(db_path, lease=lease, workers=workers, enable_chaos=enable_chaos)
    httpd = Server(("127.0.0.1", port), Handler)
    httpd.app = app  # type: ignore[attr-defined]
    app.start()
    return httpd, app


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="幂等工具调用后端")
    ap.add_argument("--port", type=int, default=8081)
    ap.add_argument("--db", default="/tmp/idempotent-tool.db")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--lease", type=float, default=LEASE_SECONDS)
    ap.add_argument("--enable-chaos", action="store_true",
                    help="允许 _crash_after_commit 注入（仅测试用）")
    args = ap.parse_args(argv)

    httpd, app = make_server(args.db, args.port, args.workers, args.lease, args.enable_chaos)
    print(json.dumps({"event": "listen", "url": f"http://127.0.0.1:{httpd.server_address[1]}",
                      "db": args.db}), flush=True)

    def _stop(signum, frame):  # noqa: ARG001
        app.stop()
        threading.Thread(target=httpd.shutdown, daemon=True).start()

    signal.signal(signal.SIGINT, _stop)
    signal.signal(signal.SIGTERM, _stop)
    try:
        httpd.serve_forever(poll_interval=0.2)
    finally:
        app.stop()
        httpd.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
