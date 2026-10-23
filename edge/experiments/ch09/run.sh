#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch09

echo "==> [Ch09] 编译并运行功耗模型、DVFS 二次方能耗与 Tickless 主机仿真..."
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined \
 experiments/ch09/power_model.c experiments/ch09/test_host.c -o .build/ch09/test_host
.build/ch09/test_host

echo "==> [Ch09] 编译并运行 ARM Cortex-M3 与 RV32 目标机休眠唤醒固件..."
bash experiments/ch09/run_firmware.sh

echo "==> [Ch09] 运行功耗固件破坏性变异测试..."
bash experiments/ch09/run_mutations.sh

echo "==> [Ch09] 实验验证全部通过！"
