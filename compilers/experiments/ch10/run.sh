#!/usr/bin/env bash
# 第 10 章实验入口：覆盖率引导差分 fuzz、最小化与去重。
# 用法（在 compilers/ 下）：bash experiments/ch10/run.sh
set -euo pipefail

cd "$(dirname "$0")"

echo "===== 0. 工具链 ====="
python3 --version
uname -sm

echo
echo "===== 1. 差分 fuzz（固定 seed，exact oracle） ====="
python3 fuzz_lab.py --seed 20261020 --iters 4000 --trace

echo
echo "===== 2. 错误 oracle：把除零错误当“跳过” ====="
python3 fuzz_lab.py --seed 20261020 --iters 4000 --oracle=skip-errors

echo
echo "===== 3. 错误去重键：只按症状合并 ====="
python3 fuzz_lab.py --seed 20261020 --iters 4000 --dedup=symptom

echo
echo "全部实验完成。"
