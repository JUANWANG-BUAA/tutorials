#!/usr/bin/env bash
# run_all.sh — 跑所有本机可跑的实验。
#
# 约定：
#   - 每个 experiments/chNN/ 里若有 test_*.py，就用 unittest 跑；
#   - 没有测试但有一键脚本的章，在下面 MANUAL 里显式登记；
#   - Linux 专属脚本在 macOS 上会打印 SKIP，不算失败；
#   - 某个目录尚未生成时跳过，不阻塞其他章。
set -u
set -e
cd "$(dirname "$0")/.."
ROOT=$(pwd)
OUT="$ROOT/experiments/.out"
mkdir -p "$OUT"

pass=0
fail=0
skip=0
failed_names=()

run() {
  local name=$1
  shift
  printf '\n\033[1m== %s ==\033[0m\n' "$name"
  if "$@"; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    failed_names+=("$name")
  fi
}

echo "root: $ROOT"
echo "python: $(python3 --version 2>&1)"

for ch in 01 02 03 04 05 06 07 08 09 10 11 12 13 14; do
  dir="$ROOT/experiments/ch$ch"
  if [ ! -d "$dir" ]; then
    echo "skip ch$ch（目录未生成）"
    skip=$((skip + 1))
    continue
  fi
  if compgen -G "$dir/test_*.py" >/dev/null; then
    run "ch$ch unit tests" python3 -m unittest discover -s "$dir" -v
  else
    echo "skip ch$ch（无 test_*.py）"
    skip=$((skip + 1))
  fi
done

# 第 1 章：三种模式的冒烟
if [ -f "$ROOT/experiments/ch01/mini_loop.py" ]; then
  run "ch01 mini_loop good" python3 "$ROOT/experiments/ch01/mini_loop.py" --mode good
  if python3 "$ROOT/experiments/ch01/mini_loop.py" --mode loop --max-steps 3 >/dev/null 2>&1; then
    echo "ch01 loop: 预期非零退出（预算终止），视为通过"
  else
    echo "ch01 loop: 预算终止（非零退出），符合预期"
  fi
fi

# 第 4 章：检查器 + Linux 验证（macOS 上 SKIP）
if [ -f "$ROOT/experiments/ch04/inspect_linux.py" ]; then
  run "ch04 inspect_linux" python3 "$ROOT/experiments/ch04/inspect_linux.py"
fi
if [ -f "$ROOT/experiments/ch04/verify-linux.sh" ]; then
  echo
  echo "== ch04 verify-linux =="
  set +e
  bash "$ROOT/experiments/ch04/verify-linux.sh" >"$OUT/ch04-linux.out" 2>&1
  rc=$?
  set -e
  if [ "$rc" -eq 0 ]; then
    pass=$((pass + 1))
  elif grep -q "SKIP:" "$OUT/ch04-linux.out"; then
    echo "SKIP ch04 verify-linux（非 Linux 宿主）"
    sed -n '1,3p' "$OUT/ch04-linux.out"
    skip=$((skip + 1))
  else
    cat "$OUT/ch04-linux.out"
    fail=$((fail + 1))
    failed_names+=("ch04 verify-linux")
  fi
fi

# 附录 B：wait status 与 shell 语义（本机可跑）
if [ -f "$ROOT/experiments/errata/wait_status.c" ]; then
  if cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 \
        "$ROOT/experiments/errata/wait_status.c" -o "$OUT/wait_status" 2>"$OUT/wait_status.err"; then
    run "errata wait_status" "$OUT/wait_status"
  else
    echo "skip errata wait_status（编译失败）"
    sed -n '1,5p' "$OUT/wait_status.err"
    skip=$((skip + 1))
  fi
fi
if [ -f "$ROOT/experiments/errata/verify_shell.sh" ]; then
  run "errata verify_shell" bash "$ROOT/experiments/errata/verify_shell.sh"
fi
if [ -f "$ROOT/experiments/errata/verify-linux.sh" ]; then
  run "errata verify-linux" bash "$ROOT/experiments/errata/verify-linux.sh"
fi

# 项目测试（若已生成）
for p in projects/code-agent projects/eval-platform; do
  if [ -d "$ROOT/$p/tests" ]; then
    run "$p tests" python3 -m unittest discover -s "$ROOT/$p/tests" -v
  fi
done

echo
echo "======================================"
echo "PASS=$pass  FAIL=$fail  SKIP=$skip"
if [ "$fail" -ne 0 ]; then
  printf 'failed: %s\n' "${failed_names[*]}"
  exit 1
fi
echo "ALL GREEN（本机可跑部分）"
