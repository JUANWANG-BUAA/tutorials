#!/usr/bin/env bash
# 第 12 章实验入口：资源限制、超时、cwd/env/fd 与平台策略。
set -euo pipefail
cd "$(dirname "$0")"

python3 -m py_compile sandbox_lab.py
python3 sandbox_lab.py
