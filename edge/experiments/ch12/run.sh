#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
cc="${EDGE_HOST_CC:-clang}"
mkdir -p .build/ch12
"$cc" -std=c11 -Wall -Wextra -Werror -O1 -g -fsanitize=address,undefined \
    -Iexperiments/ch12 experiments/ch12/{ota,selftest,test_host}.c -o .build/ch12/test-host
.build/ch12/test-host | tee .build/ch12/host-run.txt
python3 experiments/ch12/signature_test.py | tee .build/ch12/signature-run.txt
bash experiments/ch12/run_firmware.sh
bash experiments/ch12/run_mutations.sh
