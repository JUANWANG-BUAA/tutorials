#!/usr/bin/env bash
# 第 14 章实验入口：复现 accept / reject / quarantine 三类裁决。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/projects/validator"

run_case() {
  local expected="$1"
  local label="$2"
  shift 2
  local out rc verdict
  if out="$(python3 guard.py "$@" --policy policy.json --brief)"; then
    rc=0
  else
    rc=$?
  fi
  verdict="$(printf '%s' "$out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["verdict"])')"
  printf '%-12s verdict=%-10s exit=%s\n' "$label" "$verdict" "$rc"
  if [ "$rc" -ne "$expected" ]; then
    printf 'expected exit %s, got %s\n' "$expected" "$rc" >&2
    exit 1
  fi
}

run_case 0 accept     fixtures/good/sum.py --compile --run --tests fixtures/tests/sum.json
run_case 1 reject     fixtures/c/warn_unused.c --compile
run_case 2 quarantine fixtures/quarantine/timeout_loop.py --compile --run --tests fixtures/tests/timeout.json
