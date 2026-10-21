#!/usr/bin/env bash
# 跑全部章节实验；每个实验的自述与通过标准见 experiments/chNN/README.md 或脚本头。
set -u
cd "$(dirname "$0")/.."
pass=0; fail=0; skip=0
for d in experiments/ch*/; do
  [ -d "$d" ] || continue
  run="$d/run.sh"
  if [ ! -x "$run" ]; then
    if [ -f "$run" ]; then chmod +x "$run" 2>/dev/null || true; fi
  fi
  if [ ! -f "$run" ]; then
    echo "SKIP $d (no run.sh)"; skip=$((skip+1)); continue
  fi
  echo "=== $d ==="
  if bash "$run"; then
    pass=$((pass+1))
  else
    rc=$?
    if [ "$rc" = "77" ]; then
      echo "SKIP $d (exit 77)"; skip=$((skip+1))
    else
      echo "FAIL $d (exit $rc)"; fail=$((fail+1))
    fi
  fi
done
echo "experiments: PASS=$pass FAIL=$fail SKIP=$skip"
[ "$fail" -eq 0 ]
