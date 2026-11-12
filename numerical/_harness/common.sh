#!/usr/bin/env bash
set -euo pipefail
NUMERICAL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(dirname "$NUMERICAL_ROOT")"
chapter_dir() {
  case "${1:-}" in
    1) printf '%s\n' "$NUMERICAL_ROOT/src/ch01" ;;
    [2-7]) printf '%s\n' "$NUMERICAL_ROOT/src/course/ch0$1" ;;
    *) echo "章号必须为 1–7" >&2; return 2 ;;
  esac
}
