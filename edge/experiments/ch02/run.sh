#!/usr/bin/env bash
# run.sh - Chapter 02 裸机启动与重定位验证
set -euo pipefail
cd "$(dirname "$0")"

echo "==> [Ch02] 编译并运行 CRT0 内存重定位仿真程序..."
cc -O2 -Wall -Wextra crt0_sim.c -o crt0_sim
./crt0_sim

echo "==> [Ch02] 编译并运行 ARM Cortex-M3 与 RV32 目标机 CRT0 启动固件..."
bash run_firmware.sh

echo "==> [Ch02] 执行 CRT0 破坏性变异测试 (跳过数据搬移 / BSS污染)..."
bash run_mutations.sh

echo "==> [Ch02] 实验验证全部通过！"
