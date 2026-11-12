#!/usr/bin/env bash
# A section edit may break references elsewhere: validate the whole book.
set -euo pipefail
source "$(dirname "$0")/common.sh"
[ "$#" -eq 1 ] || { echo "用法: $0 <本书 src 内的 Markdown 路径>" >&2; exit 2; }
python3 - "$NUMERICAL_ROOT/src" "$1" <<'PYTHON'
from pathlib import Path
import sys
source, target = map(lambda p: Path(p).resolve(), sys.argv[1:])
if not target.is_file() or target.suffix != '.md' or source not in target.parents:
    raise SystemExit('目标必须是本书 src 内存在的 Markdown 文件')
PYTHON
bash "$NUMERICAL_ROOT/tools/check.sh"
