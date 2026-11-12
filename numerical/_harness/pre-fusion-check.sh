#!/usr/bin/env bash
# Read-only preflight; source PDFs may be local and are not a CI prerequisite.
set -euo pipefail
source "$(dirname "$0")/common.sh"
[ "$#" -eq 1 ] || { echo "用法: $0 <章号 1–7>" >&2; exit 2; }
chapter="$(chapter_dir "$1")"
[ -d "$chapter" ] || { echo "章节目录缺失: $chapter" >&2; exit 1; }
printf '检查章节: %s\n' "$chapter"
python3 "$NUMERICAL_ROOT/tools/check_book.py"
echo "修改前请保留底稿；原始资料逐项核对不能由时间戳数量替代。"
