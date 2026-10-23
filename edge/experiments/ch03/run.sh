#!/usr/bin/env bash
# run.sh - Chapter 03 中断系统与 NVIC 仿真验证
set -euo pipefail
cd "$(dirname "$0")"

echo "==> [Ch03] 编译并运行 NVIC 抢占与咬尾仿真程序..."
cc -O2 -Wall -Wextra nvic_sim.c -o nvic_sim
./nvic_sim

echo "==> [Ch03] 编译并运行定时器与单调时间戳契约测试..."
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined timer_contract.c -o timer_contract
./timer_contract

echo "==> [Ch03] 运行 RV32 完整现场、ECALL 与异步中断返回目标测试..."
bash run_trap.sh

echo "==> [Ch03] 实验验证全部通过！"
