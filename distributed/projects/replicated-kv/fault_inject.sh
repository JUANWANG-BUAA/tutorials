#!/usr/bin/env bash
# 项目二故障注入：分区、恢复、杀 leader。
# 用法：
#   bash fault_inject.sh --dry-run
#   bash fault_inject.sh --partition 3
#   bash fault_inject.sh --heal
#   bash fault_inject.sh --kill-leader
#   bash fault_inject.sh --all
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN="${RUN:-$ROOT/.run}"
BASE_PORT="${BASE_PORT:-7101}"
CLI=(python3 "$ROOT/kv_client.py")

log()  { printf '\033[36m[fault]\033[0m %s\n' "$*"; }
fail() { printf '\033[31m[fail]\033[0m %s\n' "$*" >&2; exit 1; }

leader_id() {
  python3 - <<'PY'
import json, urllib.request, sys
for i in (1, 2, 3):
    try:
        with urllib.request.urlopen(f"http://127.0.0.1:{7100+i}/status", timeout=0.4) as r:
            d = json.load(r)
        if d.get("role") == "leader":
            print(i)
            sys.exit(0)
    except Exception:
        pass
sys.exit(1)
PY
}

status_all() {
  "${CLI[@]}" status
}

wait_leader() {
  for _ in $(seq 1 80); do
    if leader_id >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.1
  done
  return 1
}

partition_node() {
  local node="$1"
  local peers
  peers="$(python3 -c 'import sys; n=int(sys.argv[1]); print(",".join(str(i) for i in (1,2,3) if i!=n))' "$node")"
  log "隔离节点 $node，阻断 peers=$peers"
  "${CLI[@]}" --base "http://127.0.0.1:$((BASE_PORT + node - 1))" partition --peers "$peers"
  sleep 1.2
  status_all
  log "旧 leader 的线性一致读应返回 503；新 leader 应在多数派一侧选出"
}

heal_all() {
  log "解除所有节点的分区"
  for node in 1 2 3; do
    curl -fsS -X POST "http://127.0.0.1:$((BASE_PORT + node - 1))/admin/heal" \
      -H 'Content-Type: application/json' -d '{}' >/dev/null || true
  done
  wait_leader || true
  status_all
}

kill_leader() {
  local leader
  wait_leader || fail "没有找到 leader；先 ./run_cluster.sh start"
  leader="$(leader_id)" || fail "没有找到 leader；先 ./run_cluster.sh start"
  local pidfile="$RUN/node-$leader.pid"
  [ -f "$pidfile" ] || fail "缺少 $pidfile"
  local pid
  pid="$(cat "$pidfile")"
  log "kill leader node=$leader pid=$pid"
  kill "$pid"
  wait "$pid" 2>/dev/null || true
  rm -f "$pidfile"
  sleep 1.5
  status_all
  local new
  new="$(leader_id)" || fail "kill 后没有选出新 leader"
  log "新 leader = $new"
  "${CLI[@]}" --key failover --consistency linearizable get || true
}

dry_run() {
  cat <<EOF
[fault] dry-run：以下命令会被执行（不实际注入）
  ./run_cluster.sh start
  # 分区：隔离节点 3
  python3 kv_client.py --base http://127.0.0.1:7103 partition --peers 1,2
  sleep 1.2; python3 kv_client.py status
  # 恢复
  curl -X POST http://127.0.0.1:7101/admin/heal -d '{}'
  # 杀 leader
  kill \$(cat .run/node-<leader>.pid); sleep 1.5; python3 kv_client.py status
[fault] 需要：python3、curl；不需要 root；先启动 ./run_cluster.sh start
EOF
}

case "${1:-}" in
  --dry-run) dry_run ;;
  --partition) [ -n "${2:-}" ] || fail "用法：--partition <1|2|3>"; partition_node "$2" ;;
  --heal) heal_all ;;
  --kill-leader) kill_leader ;;
  --all) partition_node 3; heal_all; kill_leader ;;
  *) sed -n '2,8p' "${BASH_SOURCE[0]}"; exit 1 ;;
esac
