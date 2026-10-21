#!/usr/bin/env bash
# 第 7 章实验入口：活跃区间、冲突图、图着色/线性扫描、差分对拍。
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 experiments/ch07/regalloc_lab.py --cases 200 --seed 20261020
