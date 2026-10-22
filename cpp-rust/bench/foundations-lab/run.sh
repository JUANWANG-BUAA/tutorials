#!/bin/bash
# New archive only. Builds are outside timing lock; sample is a separate run.
set -euo pipefail
cd "$(dirname "$0")"
out="${1:-results/run-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$(dirname "$out")"
mkdir "$out"
out="$(cd "$out" && pwd)"
export CARGO_TARGET_DIR="$PWD/target"
export RUSTFLAGS="-C target-cpu=native"
cargo build --offline --locked --release --bins --examples >"$out/build.txt" 2>&1
cargo rustc --offline --locked --release --lib -- --emit=mir,llvm-ir,asm >>"$out/build.txt" 2>&1
{
  date -u
  rustc -Vv
  cargo -V
  sw_vers
  sysctl hw.model hw.memsize hw.cachelinesize hw.perflevel0.physicalcpu hw.perflevel1.physicalcpu
  printf 'RUSTFLAGS=%s\n' "$RUSTFLAGS"
  printf 'profile=release opt3 codegen-units1 lto=false debug1\n'
  printf 'unit=ns/item except allocation ns/64-byte allocation+fill+read\n'
  printf 'warmup=500ms/case rounds=21 order=rotating\n'
} >"$out/environment.txt"
find src examples -type f -name '*.rs' -exec shasum -a 256 {} \; >"$out/source-sha256.txt"
shasum -a 256 Cargo.toml Cargo.lock analyze.py run.sh >>"$out/source-sha256.txt"
mkdir "$out/codegen"
find target/release/deps -name 'foundations_lab-*.mir' -exec cp {} "$out/codegen/" \;
find target/release/deps -name 'foundations_lab-*.ll' -exec cp {} "$out/codegen/" \;
find target/release/deps -name 'foundations_lab-*.s' -exec cp {} "$out/codegen/" \;
./target/release/examples/layout >"$out/layout.txt"
lock=/Users/juanwang/Desktop/tutorials/.work/cpp-rust-agents/measure.lock
while ! mkdir "$lock" 2>/dev/null; do sleep 2; done
trap 'rmdir "$lock"' EXIT
printf 'foundations pid=%s UTC=%s\n' "$$" "$(date -u)" >"$out/lock-owner.txt"
# Record interference rather than asserting full machine isolation.
pgrep -fl 'cargo|rustc' >"$out/build-processes.txt" || true
for bin in dce paired locality allocation borrow initialization; do
  date -u >>"$out/timeline.txt"
  ./target/release/"$bin" >"$out/$bin.csv"
done
python3 analyze.py "$out" >"$out/statistics-stdout.txt"
# Profiler never attaches to one of the formal CSV measurement processes.
./target/release/locality >"$out/profile-locality.csv-excluded" &
pid=$!
/usr/bin/sample "$pid" 1 1 -file "$out/sample-locality.txt" >"$out/sample-command.txt" 2>&1 || true
wait "$pid"
./target/release/borrow >"$out/profile-borrow.csv-excluded" &
pid=$!
/usr/bin/sample "$pid" 1 1 -file "$out/sample-borrow.txt" >>"$out/sample-command.txt" 2>&1 || true
wait "$pid"
rmdir "$lock"
trap - EXIT
printf '%s\n' "$out"
