#!/usr/bin/env bash
# 第 2 章实验入口：词法边界、错误恢复、快照自检与模糊入口。
set -euo pipefail
cd "$(dirname "$0")/../.."

python3 --version
echo "--- cases ---"
python3 experiments/ch02/lexer_lab.py
echo "--- selftest ---"
python3 experiments/ch02/lexer_lab.py --selftest
echo "--- fuzz ---"
python3 experiments/ch02/lexer_lab.py --fuzz 400

echo "--- buggy lexers must be rejected ---"
set +e
python3 experiments/ch02/lexer_lab.py --buggy
status=$?
set -e
if [ "$status" -ne 1 ]; then
  echo "expected buggy mode to exit 1, got $status" >&2
  exit 1
fi
echo "buggy lexers rejected: exit=$status"
