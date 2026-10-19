#!/usr/bin/env bash
# 项目一故障注入：丢响应、提交后崩溃、并发同键。
# 用法：
#   bash fault_inject.sh --dry-run
#   bash fault_inject.sh --drop-response
#   bash fault_inject.sh --crash
#   bash fault_inject.sh --concurrent
#   bash fault_inject.sh --all
# 不需要 root；端口可用 PORT / PROXY_PORT 覆盖。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORT="${PORT:-18081}"
PROXY_PORT="${PROXY_PORT:-18082}"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/idem-fault.XXXXXX")"
DB="$WORK/idem.db"
SERVER_PID=""
PROXY_PID=""

log()  { printf '\033[36m[fault]\033[0m %s\n' "$*"; }
fail() { printf '\033[31m[fail]\033[0m %s\n' "$*" >&2; exit 1; }

cleanup() {
  [ -n "$PROXY_PID" ] && kill "$PROXY_PID" 2>/dev/null || true
  [ -n "$SERVER_PID" ] && kill "$SERVER_PID" 2>/dev/null || true
  wait "$PROXY_PID" 2>/dev/null || true
  wait "$SERVER_PID" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT

wait_health() {
  local url="http://127.0.0.1:$1/healthz"
  for _ in $(seq 1 100); do
    if curl -fsS --max-time 0.3 "$url" >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.05
  done
  fail "server on $1 did not become healthy; see $WORK/server.log"
}

start_server() {
  python3 "$ROOT/server.py" --port "$PORT" --db "$DB" "$@" \
    >"$WORK/server.log" 2>&1 &
  SERVER_PID=$!
  wait_health "$PORT"
}

stop_server() {
  if [ -n "$SERVER_PID" ]; then
    kill "$SERVER_PID" 2>/dev/null || true
    wait "$SERVER_PID" 2>/dev/null || true
    SERVER_PID=""
  fi
}

start_proxy() {
  python3 "$ROOT/chaos_proxy.py" --listen-port "$PROXY_PORT" \
    --upstream-port "$PORT" "$@" >"$WORK/proxy.log" 2>&1 &
  PROXY_PID=$!
  for _ in $(seq 1 100); do
    if (exec 3<>"/dev/tcp/127.0.0.1/$PROXY_PORT") 2>/dev/null; then
      exec 3>&- 2>/dev/null || true
      return 0
    fi
    sleep 0.05
  done
  fail "proxy on $PROXY_PORT did not start"
}

show_stats() {
  local stats
  stats="$(curl -fsS "http://127.0.0.1:$PORT/stats")"
  echo "$stats"
  python3 -c 'import json,sys; d=json.load(sys.stdin); sys.exit(0 if d["effects"]==1 else 1)' \
    <<<"$stats" || fail "expected exactly 1 effect, got: $stats"
}

mode_drop() {
  log "场景 1：服务端执行成功，但第一次响应被代理丢弃；客户端用同一个键重试"
  start_server
  start_proxy --mode drop-first
  local key="drop-$(date +%s)"
  # 第一次 attempt 超时；第二次同键请求应命中已有 call。
  python3 "$ROOT/client.py" --base "http://127.0.0.1:$PROXY_PORT" \
    --key "$key" --tool charge --amount 11 --timeout 0.6 --retries 3
  log "服务端直接查询（绕开代理）："
  curl -fsS "http://127.0.0.1:$PORT/v1/tool-calls/by-key/$key" | python3 -m json.tool
  show_stats
  log "通过：同键重试只产生 1 条 effect"
  stop_server
}

mode_crash() {
  log "场景 2：服务端提交后进程崩溃，重启后同键请求返回原结果"
  start_server --enable-chaos
  local key="crash-$(date +%s)"
  set +e
  curl -sS --max-time 5 -X POST "http://127.0.0.1:$PORT/v1/tool-calls" \
    -H "Idempotency-Key: $key" -H 'Content-Type: application/json' \
    -d '{"tool":"charge","args":{"amount":7,"_crash_after_commit":true}}' \
    >"$WORK/crash-response.json" 2>"$WORK/crash-curl.err"
  set -e
  wait "$SERVER_PID" 2>/dev/null || true
  SERVER_PID=""
  log "崩溃后数据库状态："
  python3 - "$DB" <<'PY'
import sqlite3, sys
conn = sqlite3.connect(sys.argv[1])
print("calls:", conn.execute("SELECT call_id,status,attempt FROM calls").fetchall())
print("effects:", conn.execute("SELECT call_id,effect_id FROM effects").fetchall())
PY
  start_server
  log "重启后按幂等键查询："
  local call
  call="$(curl -fsS "http://127.0.0.1:$PORT/v1/tool-calls/by-key/$key")"
  echo "$call" | python3 -m json.tool
  python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["status"]=="succeeded", d; print("status=succeeded attempt=", d["attempt"])' <<<"$call"
  show_stats
  log "通过：崩溃恢复没有产生第二条 effect"
  stop_server
}

mode_concurrent() {
  log "场景 3：20 个并发请求使用同一个键"
  start_server
  local key="concurrent-$(date +%s)"
  local pids=()
  for _ in $(seq 1 20); do
    curl -sS -o /dev/null -X POST "http://127.0.0.1:$PORT/v1/tool-calls" \
      -H "Idempotency-Key: $key" -H 'Content-Type: application/json' \
      -d '{"tool":"charge","args":{"amount":3,"sleep_ms":50}}' &
    pids+=("$!")
  done
  for pid in "${pids[@]}"; do
    wait "$pid" || true
  done
  sleep 0.5
  curl -fsS "http://127.0.0.1:$PORT/v1/tool-calls/by-key/$key" | python3 -m json.tool
  show_stats
  log "通过：并发同键只产生 1 条 effect"
  stop_server
}

dry_run() {
  cat <<EOF
[fault] dry-run：以下命令会被执行（不实际启动服务）
  PORT=$PORT PROXY_PORT=$PROXY_PORT
  1) python3 server.py --port $PORT --db <tmp>/idem.db
     python3 chaos_proxy.py --listen-port $PROXY_PORT --upstream-port $PORT --mode drop-first
     python3 client.py --base http://127.0.0.1:$PROXY_PORT --key drop-... --retries 3
  2) python3 server.py --port $PORT --db <tmp>/idem.db --enable-chaos
     curl -X POST ... -H 'Idempotency-Key: crash-...' -d '{"args":{"_crash_after_commit":true}}'
     重启 server；GET /v1/tool-calls/by-key/crash-...
  3) 20 个并发 curl 同键；GET /stats 断言 effects == 1
[fault] 需要：python3、curl；不需要 root
EOF
}

case "${1:-}" in
  --dry-run) dry_run ;;
  --drop-response) mode_drop ;;
  --crash) mode_crash ;;
  --concurrent) mode_concurrent ;;
  --all) mode_drop; mode_crash; mode_concurrent ;;
  *) sed -n '2,9p' "${BASH_SOURCE[0]}"; exit 1 ;;
esac
