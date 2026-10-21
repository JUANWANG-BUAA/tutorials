#!/usr/bin/env bash
# guard.py 的完整回归：43 个测试，全部通过标准库 unittest。
set -euo pipefail

cd "$(dirname "$0")"
exec python3 -m unittest discover -s tests -v
