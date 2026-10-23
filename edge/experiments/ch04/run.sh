#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch04
cc -std=c11 -O2 -g -Wall -Wextra -Werror -fsanitize=undefined,address experiments/ch04/rtos_context_sim.c -o .build/ch04/model
.build/ch04/model
cc -std=c11 -O2 -g -Wall -Wextra -Werror -pthread experiments/ch04/spsc.c -o .build/ch04/spsc
.build/ch04/spsc
bash experiments/ch04/run_firmware.sh
