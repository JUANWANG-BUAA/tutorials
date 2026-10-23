#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch10

echo "==> [Ch10] 编译并运行窗口看门狗状态机、崩溃快照与 FTTI 预算主机仿真..."
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined \
 experiments/ch10/fault_recovery.c experiments/ch10/test_host.c -o .build/ch10/test_host
.build/ch10/test_host

echo "==> [Ch10] 编译并运行 ARM Cortex-M3 与 RV32 目标机看门狗与异常捕获固件..."
bash experiments/ch10/run_firmware.sh

echo "==> [Ch10] 运行故障恢复固件破坏性变异测试..."
bash experiments/ch10/run_mutations.sh

echo "==> [Ch10] 实验验证全部通过！"
