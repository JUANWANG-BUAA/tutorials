#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
OUT=${1:-results/run-$(date -u +%Y%m%dT%H%M%SZ)-$$}
[[ ! -e "$OUT" ]] || { echo "refuse existing archive: $OUT" >&2; exit 1; }
mkdir -p "$OUT"
OUT=$(cd "$OUT" && pwd)
export RUSTFLAGS='-C target-cpu=native'
{
 date -u; rustc -Vv; cargo -V; uname -a
 sysctl hw.model hw.ncpu hw.cachelinesize machdep.cpu.brand_string
 printf 'RUSTFLAGS=%s\nprofile=release; thin LTO; codegen-units=1; debug=1\n' "$RUSTFLAGS"
} > "$OUT/environment.txt" 2>&1
find src tests -type f -name '*.rs' -exec shasum -a 256 {} \; > "$OUT/source-sha256.txt"
shasum -a 256 Cargo.toml Cargo.lock run.sh >> "$OUT/source-sha256.txt"
cargo fmt --all --check > "$OUT/fmt.txt" 2>&1
cargo clippy --offline --locked --all-targets -- -D warnings > "$OUT/clippy.txt" 2>&1
cargo test --offline --locked > "$OUT/test.txt" 2>&1
cargo build --release --offline --locked --bins > "$OUT/build.txt" 2>&1
cargo rustc --release --offline --locked --lib -- --emit=mir,llvm-ir,asm > "$OUT/codegen.txt" 2>&1
mkdir "$OUT/codegen"
find target/release/deps -maxdepth 1 \( -name 'systems_lab-*.mir' -o -name 'systems_lab-*.ll' -o -name 'systems_lab-*.s' \) -exec cp {} "$OUT/codegen/" \;
target/release/layout > "$OUT/layout.txt"
LOCK=/Users/juanwang/Desktop/tutorials/.work/cpp-rust-agents/measure.lock
while ! mkdir "$LOCK" 2>/dev/null; do sleep 2; done
trap 'rmdir "$LOCK"' EXIT
{ date -u; ps -axo pid,comm,args | grep -E '[c]argo |[r]ustc ' || true; } > "$OUT/interference.txt"
for entry in queue epoch simd views; do
 target/release/"$entry" > "$OUT/$entry.txt"
done
rmdir "$LOCK"
trap - EXIT
# Profiling is a separate process, never mixed with formal observations.
target/release/queue > "$OUT/queue-profile-run.txt" &
pid=$!
/usr/bin/sample "$pid" 1 1 -file "$OUT/queue-sample.txt" > "$OUT/sample-command.txt" 2>&1 || true
wait "$pid"
shasum -a 256 target/release/{queue,epoch,simd,views,layout} > "$OUT/binary-sha256.txt"
printf '%s\n' "$OUT"
