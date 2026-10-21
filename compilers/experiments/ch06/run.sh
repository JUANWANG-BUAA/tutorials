#!/usr/bin/env bash
# 第 6 章实验入口：常量折叠/传播、DCE、LICM 与解释器对拍。
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 experiments/ch06/opt_lab.py
