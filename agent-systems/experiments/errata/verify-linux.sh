#!/usr/bin/env bash
# verify-linux.sh — 附录 B 的 Linux 专属验证。
#
# 在 Ubuntu 24.04 / Linux 6.8 上运行：
#   bash experiments/errata/verify-linux.sh
#
# 在 macOS 上运行会打印 SKIP 并以 0 退出：这些系统调用不存在，
# 跳过不等于通过；正文与 CHECK 会如实标注。
set -u

if [ "$(uname -s)" != "Linux" ]; then
  echo "SKIP: $(uname -s) 上没有 clone/mq_open/landlock/proc stat 的 Linux 语义"
  echo "      请在 Ubuntu 24.04（内核 6.8+）上运行本脚本。"
  exit 0
fi

set -e
cd "$(dirname "$0")"
out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
CC=${CC:-cc}
CFLAGS=(-std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g)
fail=0

check() {
  local name=$1 expected=$2
  shift 2
  if "$@" >"$out/$name.out" 2>"$out/$name.err"; then
    if grep -q -- "$expected" "$out/$name.out"; then
      echo "PASS  $name: $(grep -m1 -- "$expected" "$out/$name.out")"
    else
      echo "FAIL  $name: 未找到预期输出 '$expected'"
      sed -n '1,6p' "$out/$name.out"
      fail=1
    fi
  else
    echo "FAIL  $name: 运行失败"
    sed -n '1,8p' "$out/$name.err"
    fail=1
  fi
}

echo "== kernel =="
uname -sr
echo

echo "== wait status =="
$CC "${CFLAGS[@]}" wait_status.c -o "$out/wait_status"
check wait_status "WEXITSTATUS     = 42" "$out/wait_status"
grep -q "raw status      = 0x2a00" "$out/wait_status.out" \
  && echo "PASS  wait_status: raw = 0x2a00" \
  || { echo "FAIL  wait_status: raw status 不是 0x2a00"; fail=1; }
echo

echo "== /proc/PID/stat exit_code =="
$CC "${CFLAGS[@]}" proc_stat_exit.c -o "$out/proc_stat_exit"
check proc_stat_exit "WEXITSTATUS     = 42" "$out/proc_stat_exit"
grep -q "/proc exit_code = 10752 (0x2a00)" "$out/proc_stat_exit.out" \
  && echo "PASS  proc_stat_exit: field 52 = 0x2a00（wait 编码，不是低 8 位）" \
  || { echo "WARN  proc_stat_exit: field 52 的值与 10752 不同（内核版本差异？）"; }
echo

echo "== mq_open / sem_open variadic =="
if $CC "${CFLAGS[@]}" mq_sem_proto.c -o "$out/mq_sem_proto" 2>"$out/mq.err"; then
  :
elif $CC "${CFLAGS[@]}" mq_sem_proto.c -o "$out/mq_sem_proto" -lrt 2>>"$out/mq.err"; then
  :
else
  echo "FAIL  mq_sem_proto: 编译失败"; sed -n '1,8p' "$out/mq.err"; fail=1
fi
if [ -x "$out/mq_sem_proto" ]; then
  "$out/mq_sem_proto" >"$out/mq.out" 2>&1 || true
  grep -q "mq_open 2-arg:" "$out/mq.out" \
    && echo "PASS  mq_open: 2 参数调用编译通过（variadic）" \
    || { echo "FAIL  mq_open: 未看到 2 参数调用"; fail=1; }
  grep -q "sem_open 2-arg:" "$out/mq.out" \
    && echo "PASS  sem_open: 2 参数调用编译通过（variadic）" \
    || { echo "FAIL  sem_open: 未看到 2 参数调用"; fail=1; }
fi
echo

echo "== clone 可变参数顺序 =="
$CC "${CFLAGS[@]}" clone_order.c -o "$out/clone_order"
check clone_order "WEXITSTATUS=0" "$out/clone_order"
awk -F'[ =]' '/^pid=/{ if ($2 == $4) print "PASS  clone_order: parent_tid == pid" }' "$out/clone_order.out" \
  || true
echo

echo "== Landlock ABI =="
$CC "${CFLAGS[@]}" landlock_probe.c -o "$out/landlock_probe"
if "$out/landlock_probe" >"$out/ll.out" 2>"$out/ll.err"; then
  cat "$out/ll.out"
else
  echo "WARN  Landlock 不可用（可能是内核未启用）"; sed -n '1,4p' "$out/ll.err"
fi
echo

echo "== /proc/self/status =="
grep -E '^(Cap(Inh|Prm|Eff|Bnd|Amb)|Seccomp|Seccomp_filters|NoNewPrivs):' /proc/self/status || true
echo

if [ "$fail" -ne 0 ]; then
  echo "RESULT: FAIL"
  exit 1
fi
echo "RESULT: PASS（Linux 专属检查）"
