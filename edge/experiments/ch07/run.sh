#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch07
bash experiments/ch07/generate_tables.sh --check
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined \
 experiments/ch07/dsp.c experiments/ch07/wide_c.c experiments/ch07/selftest.c experiments/ch07/test_host.c \
 -lm -o .build/ch07/test_host
.build/ch07/test_host
bash experiments/ch07/run_firmware.sh
