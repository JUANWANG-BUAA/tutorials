#!/usr/bin/env bash
# macOS-only fault injection; not a timing run. No overwrite of failed archives.
set -euo pipefail
project="$(cd "$(dirname "$0")/.." && pwd)"
[[ $# == 2 && ( "$2" == debug || "$2" == release ) ]] || { echo 'usage: bash diagnostics/reproduce_descriptor_race.sh NEW_OUT debug|release' >&2; exit 2; }
mkdir "$1"
out="$(cd "$1" && pwd)"
profile="$2"
{ date -u; uname -a; sw_vers; rustc -Vv; clang --version; printf 'profile=%s\n' "$profile"; } >"$out/environment.txt"
flags=()
[[ "$profile" == debug ]] || flags=(--release)
cargo build --offline --locked --manifest-path "$project/Cargo.toml" "${flags[@]}" --bins --examples >"$out/build.txt" 2>&1
clang -Wall -Wextra -Werror -mmacosx-version-min=27.0 -dynamiclib "$project/diagnostics/pipe_gate.c" -o "$out/pipe_gate.dylib" >"$out/interposer-build.txt" 2>&1
failed=0
for mode in logs sleep; do
  for pipe in 1 2; do
    gate="$out/$mode-pipe$pipe"; mkdir "$gate"
    set +e
    DRAIN_CASE="$mode" DRAIN_GATE_N="$pipe" DRAIN_GATE_DIR="$gate" \
      DYLD_INSERT_LIBRARIES="$out/pipe_gate.dylib" \
      "$project/target/$profile/examples/descriptor_race" >"$gate/report.txt" 2>&1
    status=$?
    set -e
    printf '%s pipe=%s exit=%s\n' "$mode" "$pipe" "$status" | tee -a "$out/status.txt"
    [[ "$status" == 0 ]] || failed=1
  done
done
exit "$failed"
