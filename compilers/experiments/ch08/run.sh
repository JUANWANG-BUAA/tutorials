#!/usr/bin/env bash
# 第 8 章实验入口：生成/汇编/反汇编，检查栈对齐、位宽、add 内存形式、x30、PLT32。
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="/opt/homebrew/opt/llvm@22/bin:$PATH"
python3 experiments/ch08/abi_lab.py
