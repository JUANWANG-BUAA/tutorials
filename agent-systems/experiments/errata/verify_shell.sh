#!/usr/bin/env bash
# verify_shell.sh — 在任意 POSIX bash 上验证 pipefail / PIPESTATUS / ulimit / jobs 的语义。
# 输出是附录 B 表格的证据；macOS 的 bash 3.2 与 Linux 的 bash 5.2 都应得到相同结论。
set -u

echo "== bash =="
echo "version: $BASH_VERSION"

echo
echo "== pipefail =="
set +o pipefail
( exit 3 ) | ( exit 5 ) | true
echo "pipefail off, status=$?"
set -o pipefail
( exit 3 ) | ( exit 5 ) | true
echo "pipefail on,  status=$?"
echo "PIPESTATUS=${PIPESTATUS[*]}"
# 注意：上一条 echo 已经消耗了 PIPESTATUS；这里重新跑一次并立即取。
( exit 3 ) | ( exit 5 ) | true
ps=("${PIPESTATUS[@]}")
echo "PIPESTATUS after rerun: ${ps[*]}"

echo
echo "== ulimit =="
echo "soft nofile: $(ulimit -Sn)"
echo "hard nofile: $(ulimit -Hn)"
echo "bash default (no -S/-H): before S=$(ulimit -Sn) H=$(ulimit -Hn)"
( ulimit -n 512; echo "  after ulimit -n 512: S=$(ulimit -Sn) H=$(ulimit -Hn)" )
echo "zsh/POSIX default only changes soft; see appendix B.6.2"
before=$(ulimit -Sn)
if ulimit -n 1024 2>/dev/null; then
  echo "set soft 1024: ok (now $(ulimit -Sn), was $before)"
else
  echo "set soft 1024: failed (current $(ulimit -Sn))"
fi
if ulimit -Hn 1024 2>/dev/null; then
  echo "lower hard to 1024: ok (now $(ulimit -Hn))"
else
  echo "lower hard to 1024: failed (current $(ulimit -Hn))"
fi
if ulimit -Hn 4096 2>/dev/null; then
  echo "raise hard to 4096: ok (now $(ulimit -Hn))"
else
  echo "raise hard to 4096: failed (current $(ulimit -Hn)); 非 root 不能抬高硬限"
fi

echo
echo "== jobs =="
sleep 1 &
job_pid=$!
echo "parent jobs:"
jobs -l
echo "subshell jobs:"
( jobs -l ) || true
wait "$job_pid" 2>/dev/null
echo "done"
