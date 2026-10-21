#!/usr/bin/env bash
# 第 1 章实验入口：跑通流水线、对拍、错误模式与可复现性。
set -euo pipefail
cd "$(dirname "$0")/../.."

python3 --version
echo "--- pipeline ---"
python3 experiments/ch01/pipeline_tour.py
echo "--- selftest ---"
python3 experiments/ch01/pipeline_tour.py --selftest
echo "--- failure modes ---"
python3 experiments/ch01/pipeline_tour.py --fail
echo "--- incremental cache ---"
python3 experiments/ch01/pipeline_tour.py --cache

echo "--- undefined variable (semantic check) ---"
python3 experiments/ch01/pipeline_tour.py --undefined

echo "--- reproducibility: two runs must hash identically ---"
h1=$(python3 experiments/ch01/pipeline_tour.py --hash)
h2=$(python3 experiments/ch01/pipeline_tour.py --hash)
printf '%s\n' "$h1"
if [ "$h1" != "$h2" ]; then
  echo "not reproducible: hashes differ" >&2
  exit 1
fi
echo "reproducible: yes"

echo "--- buggy codegen must fail the differential test ---"
set +e
python3 experiments/ch01/pipeline_tour.py --buggy
status=$?
set -e
if [ "$status" -ne 1 ]; then
  echo "expected buggy mode to exit 1, got $status" >&2
  exit 1
fi
echo "buggy codegen rejected: exit=$status"
