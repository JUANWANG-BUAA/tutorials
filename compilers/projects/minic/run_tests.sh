#!/usr/bin/env bash
# Run every minic test: 42 cases, 4 execution modes, two asm targets.
set -euo pipefail
cd "$(dirname "$0")"
python3 tests/run_tests.py
