#!/usr/bin/env bash
# Report actual gates, never a percentage inferred from checkmarks.
set -euo pipefail
source "$(dirname "$0")/common.sh"
[ "$#" -eq 1 ] || { echo "用法: $0 <章号 1–7>" >&2; exit 2; }
chapter="$(chapter_dir "$1")"
[ -d "$chapter" ] || { echo "章节目录缺失: $chapter" >&2; exit 1; }
printf '章节: %s\n' "$chapter"
bash "$NUMERICAL_ROOT/tools/check.sh"
preview="$(mktemp -d "${TMPDIR:-/tmp}/numerical-chapter.XXXXXX")"
trap 'rm -rf "$preview"' EXIT
mdbook build "$NUMERICAL_ROOT" --dest-dir "$preview/book"
echo "源码检查、选定数学例题及全书构建通过；不据此宣称所有定理或来源已审定。"
