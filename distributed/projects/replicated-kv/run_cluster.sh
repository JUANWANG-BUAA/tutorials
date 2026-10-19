#!/usr/bin/env bash
# 启动/停止三节点复制 KV。
#   ./run_cluster.sh start|stop|restart|status|clean
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN="${RUN:-$ROOT/.run}"
BASE_PORT="${BASE_PORT:-7101}"
IDS=(1 2 3)

start() {
  mkdir -p "$RUN"
  for i in "${IDS[@]}"; do
    local port=$((BASE_PORT + i - 1))
    local peers=()
    for j in "${IDS[@]}"; do
      if [ "$j" -ne "$i" ]; then
        peers+=(--peer "$j=http://127.0.0.1:$((BASE_PORT + j - 1))")
      fi
    done
    python3 "$ROOT/raft_node.py" --id "$i" --port "$port" --data-dir "$RUN" \
      --election-ms 500 --heartbeat-ms 100 --lease-ms 800 "${peers[@]}" \
      >"$RUN/node-$i.log" 2>&1 &
    echo $! >"$RUN/node-$i.pid"
    echo "started node $i on :$port (pid $!)"
  done
  for i in "${IDS[@]}"; do
    local port=$((BASE_PORT + i - 1))
    for _ in $(seq 1 100); do
      if curl -fsS --max-time 0.2 "http://127.0.0.1:$port/healthz" >/dev/null 2>&1; then
        break
      fi
      sleep 0.05
    done
  done
  sleep 0.8
  python3 "$ROOT/kv_client.py" status || true
}

stop() {
  for i in "${IDS[@]}"; do
    local f="$RUN/node-$i.pid"
    if [ -f "$f" ]; then
      local pid
      pid="$(cat "$f")"
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
      rm -f "$f"
    fi
  done
}

status() {
  python3 "$ROOT/kv_client.py" status
}

clean() {
  stop
  rm -rf "$RUN"
}

case "${1:-}" in
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  clean) clean ;;
  *) sed -n '2,4p' "${BASH_SOURCE[0]}"; exit 1 ;;
esac
