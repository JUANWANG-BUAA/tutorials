#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch11

echo "==> [Ch11] 编译并运行 INT8 张量推理、重量化缩放与 Arena 内存池主机仿真..."
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined \
 experiments/ch11/nn_core.c experiments/ch11/test_host.c -o .build/ch11/test_host
.build/ch11/test_host

echo "==> [Ch11] 编译并运行 ARM Cortex-M3 与 RV32 目标机 INT8 推理固件..."
bash experiments/ch11/run_firmware.sh

echo "==> [Ch11] 运行 INT8 推理固件破坏性变异测试..."
bash experiments/ch11/run_mutations.sh

echo "==> [Ch11] 实验验证全部通过！"
