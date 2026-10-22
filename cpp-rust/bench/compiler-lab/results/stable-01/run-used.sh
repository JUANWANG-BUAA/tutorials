#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")" && pwd)
OUT=${1:?usage: bash run.sh NEW_ARCHIVE_DIRECTORY}
mkdir "$OUT"
OUT=$(cd "$OUT" && pwd)
export CARGO_TARGET_DIR="$ROOT/target"
{
  date -u; uname -a; sw_vers; rustc -vV; cargo -V
  rustup toolchain list
  sysctl machdep.cpu.brand_string hw.cachelinesize hw.ncpu
  printf 'profile: opt-level=3 codegen-units=1 lto=false debug=1 panic=unwind\n'
  printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-<unset>}"
} > "$OUT/environment.txt"
find "$ROOT/src" "$ROOT/tests" "$ROOT/probes" -type f -name '*.rs' -print0 |
  xargs -0 shasum -a 256 > "$OUT/source-sha256.txt"
shasum -a 256 "$ROOT/Cargo.toml" "$ROOT/Cargo.lock" "$ROOT/run.sh" >> "$OUT/source-sha256.txt"
cargo fmt --manifest-path "$ROOT/Cargo.toml" --check > "$OUT/fmt.txt" 2>&1
cargo clippy --offline --locked --manifest-path "$ROOT/Cargo.toml" --all-targets -- -D warnings > "$OUT/clippy.txt" 2>&1
cargo test --offline --locked --manifest-path "$ROOT/Cargo.toml" > "$OUT/tests.txt" 2>&1
cargo build --offline --locked --release --manifest-path "$ROOT/Cargo.toml" --bins > "$OUT/build.txt" 2>&1
mkdir "$OUT/binaries" "$OUT/codegen"
for name in move_cost drop_paths dispatch_grain dispatch_visibility vectorize ctfe_table; do
  cp "$ROOT/target/release/$name" "$OUT/binaries/$name"
done
cargo rustc --offline --locked --release --manifest-path "$ROOT/Cargo.toml" --lib -- --emit=mir,llvm-ir,asm > "$OUT/codegen-build.txt" 2>&1
find "$ROOT/target/release/deps" -maxdepth 1 -type f \( -name 'compiler_lab-*.mir' -o -name 'compiler_lab-*.ll' -o -name 'compiler_lab-*.s' \) -exec cp {} "$OUT/codegen/" \;
LOCK=/Users/juanwang/Desktop/tutorials/.work/cpp-rust-agents/measure.lock
while ! mkdir "$LOCK" 2>/dev/null; do sleep 2; done
trap 'rmdir "$LOCK"' EXIT
ps -axo pid,comm,args | grep -E '(cargo|rustc)' | grep -v grep > "$OUT/build-processes-before.txt" || true
for name in move_cost drop_paths dispatch_grain dispatch_visibility vectorize ctfe_table; do
  ps -axo pid,comm,args | grep -E '(cargo|rustc)' | grep -v grep >> "$OUT/build-processes-before.txt" || true
  "$OUT/binaries/$name" > "$OUT/$name.csv"
done
rmdir "$LOCK"
trap - EXIT
# A separate run, deliberately excluded from the 21 timing observations.
"$OUT/binaries/dispatch_grain" > "$OUT/sample-run.csv" &
PID=$!
/usr/bin/sample "$PID" 1 1 -file "$OUT/macos-sample.txt" > "$OUT/sample-command.txt" 2>&1 || true
wait "$PID"
find "$OUT/binaries" "$OUT/codegen" -type f -exec shasum -a 256 {} \; > "$OUT/artifact-sha256.txt"
