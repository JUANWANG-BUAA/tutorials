#!/usr/bin/env bash
# run.sh - Chapter 01 验证实验执行脚本
set -euo pipefail
cd "$(dirname "$0")"

echo "==> [Ch01] 编译并运行时钟抖动与内存屏障验证程序..."
cc -O2 -Wall -Wextra -pthread timing_jitter.c -o timing_jitter
./timing_jitter

echo "==> [Ch01] 运行 QEMU Cortex-M3 BASEPRI 优先级与嵌套屏蔽测试..."
bash run_basepri.sh

echo "==> [Ch01] 实验验证全部通过！"
