#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch06
flags=(-std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=address,undefined)
cc "${flags[@]}" experiments/ch06/can_core.c experiments/ch06/core_selftest.c experiments/ch06/test_core.c -o .build/ch06/test_core
.build/ch06/test_core
cc "${flags[@]}" experiments/ch06/can_core.c experiments/ch06/sja_driver.c experiments/ch06/test_sja.c -o .build/ch06/test_sja
.build/ch06/test_sja
bash experiments/ch06/run_x86.sh
