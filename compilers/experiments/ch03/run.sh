#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "== normal =="
python3 scope_lab.py

echo
echo "== leak-scope (agent bug) =="
python3 scope_lab.py --leak-scope
