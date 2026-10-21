#!/usr/bin/env bash
# 第 5 章实验入口：四种数据流分析 + 两个初始化反例。
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 experiments/ch05/dataflow_lab.py
