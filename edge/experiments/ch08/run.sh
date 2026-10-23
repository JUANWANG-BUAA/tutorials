#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch08

echo "==> [Ch08] 编译并运行 DAQ 流式管道主机仿真与模型验证..."
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined \
 experiments/ch08/daq_core.c experiments/ch08/test_host.c -o .build/ch08/test_host
.build/ch08/test_host

echo "==> [Ch08] 编译并运行 ARM Cortex-M3 与 RV32 目标机 DAQ 流式固件..."
bash experiments/ch08/run_firmware.sh

echo "==> [Ch08] 运行 DAQ 固件破坏性变异测试..."
bash experiments/ch08/run_mutations.sh

echo "==> [Ch08] 实验验证全部通过！"
