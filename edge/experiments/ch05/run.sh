#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch05
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined experiments/ch05/bus_models.c -o .build/ch05/bus_models
.build/ch05/bus_models
bash experiments/ch05/run_uart.sh
