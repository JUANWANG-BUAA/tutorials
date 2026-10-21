#!/usr/bin/env bash
# 第 11 章实验入口：WP/VC + 有界反例搜索。
set -euo pipefail
cd "$(dirname "$0")"

python3 -m py_compile proof_lab.py

echo "== sum loop: expected NO-COUNTEREXAMPLE-IN-DOMAIN =="
python3 proof_lab.py

echo "== parity loop: expected FAIL with i=0, n=1 =="
if python3 proof_lab.py --demo parity; then
  echo "unexpected: parity demo passed" >&2
  exit 1
else
  echo "(exit $? as expected: a real counterexample)"
fi

echo "== vacuous invariant with --buggy: expected CLAIMED-PROVED =="
python3 proof_lab.py --demo vacuous --buggy

echo "== same program without --buggy: expected FAIL at entry =="
if python3 proof_lab.py --demo vacuous; then
  echo "unexpected: vacuous demo passed" >&2
  exit 1
else
  echo "(exit $? as expected: entry VC catches it)"
fi
