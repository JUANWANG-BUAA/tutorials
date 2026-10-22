#!/usr/bin/env bash
set -euo pipefail
LAB=$(cd "$(dirname "$0")/.." && pwd)
REPO=$(cd "$LAB/../../.." && pwd)
OUT=${1:?usage: bash tools/measure.sh NEW_OUTPUT_DIRECTORY}
for KEY in RUSTFLAGS CARGO_ENCODED_RUSTFLAGS RUSTC_WRAPPER RUSTC_WORKSPACE_WRAPPER; do
  if [[ -n "${!KEY-}" ]]; then
    printf 'Refusing unrecorded ambient override: %s\n' "$KEY" >&2
    exit 2
  fi
done
mkdir "$OUT"
OUT=$(cd "$OUT" && pwd)
LOCK="$REPO/.work/cpp-rust-agents/measure.lock"
while ! mkdir "$LOCK" 2>/dev/null; do sleep 2; done
trap 'rmdir "$LOCK"' EXIT
# Only executable names are captured; do not dump arbitrary process arguments/environment.
{
  date -u
  uname -a
  rustc -Vv
  cargo -V
  sysctl hw.model hw.cachelinesize hw.ncpu machdep.cpu.brand_string
  printf 'profile.release: debug=1 incremental=false cgu=16 lto=false; one:cgu=1; thin:cgu=1,lto=thin\n'
  printf 'Runtime executable warmup >=500ms each experiment; no profiler on formal runtime samples.\n'
  printf 'Build: new package target per case/round; preinstalled std and warm OS cache; j=1.\n'
  printf 'Build RUSTFLAGS/wrappers cleared; runtime RUSTFLAGS empty in this run.\n'
} > "$OUT/environment.txt"
ps -axo pid,comm | grep -E '(cargo|rustc|clang|ld$)' > "$OUT/processes-before.txt" || true
find "$LAB/src" "$LAB/tools" -type f \( -name '*.rs' -o -name '*.py' -o -name '*.sh' \) -exec shasum -a 256 {} \; > "$OUT/source-sha256.txt"
shasum -a 256 "$LAB/Cargo.toml" "$LAB/Cargo.lock" >> "$OUT/source-sha256.txt"
mkdir -p "$OUT/measured-source"
while IFS= read -r -d '' SOURCE; do
  RELATIVE=${SOURCE#"$LAB/"}
  mkdir -p "$(dirname "$OUT/measured-source/$RELATIVE")"
  cp "$SOURCE" "$OUT/measured-source/$RELATIVE"
done < <(find "$LAB/src" "$LAB/tools" -type f \( -name '*.rs' -o -name '*.py' -o -name '*.sh' \) -print0)
cp "$LAB/Cargo.toml" "$LAB/Cargo.lock" "$OUT/measured-source/"
"$LAB/target/release/cpu_wait" > "$OUT/cpu-wait.txt"
"$LAB/target/release/instrumentation" > "$OUT/instrumentation.txt"
"$LAB/target/release/feature_work" > "$OUT/feature-default.txt"
"$LAB/target-checked/release/feature_work" > "$OUT/feature-checked.txt"
python3 "$LAB/tools/build_matrix.py" "$OUT" > "$OUT/build-summary-stdout.txt"
# Profiling is deliberately separate from the 21-batch timing experiments.
for mode in cpu wait; do
  "$LAB/target/release/cpu_wait" --profile "$mode" > "$OUT/profile-$mode-run.txt" &
  PID=$!
  sleep 0.3
  sample "$PID" 2 1 -file "$OUT/sample-$mode.txt" > "$OUT/sample-$mode-command.txt" 2>&1
  wait "$PID"
done
ps -axo pid,comm | grep -E '(cargo|rustc|clang|ld$)' > "$OUT/processes-after.txt" || true
# Generated-code capture is after all formal measurements.
mkdir "$OUT/codegen"
cargo rustc --offline --locked --release --manifest-path "$LAB/Cargo.toml" --lib --target-dir "$OUT/codegen-target" -- --emit=mir,llvm-ir,asm > "$OUT/codegen-command.txt" 2>&1
find "$OUT/codegen-target/release/deps" -type f \( -name '*.mir' -o -name '*.ll' -o -name '*.s' \) -exec cp {} "$OUT/codegen/" \;
shasum -a 256 "$LAB/target/release/cpu_wait" "$LAB/target/release/instrumentation" "$LAB/target/release/feature_work" "$LAB/target-checked/release/feature_work" > "$OUT/binary-sha256.txt"
mkdir "$OUT/binaries"
cp "$LAB/target/release/cpu_wait" "$LAB/target/release/instrumentation" "$LAB/target/release/feature_work" "$OUT/binaries/"
cp "$LAB/target-checked/release/feature_work" "$OUT/binaries/feature_work_checked"
# Postprocessing added after run-01; that run's original script is in measured-source/.
cargo rustc --offline --locked --release --features checked --manifest-path "$LAB/Cargo.toml" --lib --target-dir "$OUT/checked-codegen-target" -- --emit=mir,llvm-ir,asm > "$OUT/checked-codegen-command.txt" 2>&1
mkdir "$OUT/checked-codegen"
find "$OUT/checked-codegen-target/release/deps" -type f \( -name '*.mir' -o -name '*.ll' -o -name '*.s' \) -exec cp {} "$OUT/checked-codegen/" \;
for mode in cpu wait; do
  python3 "$LAB/tools/collapse_sample.py" "$OUT/sample-$mode.txt" "$OUT/$mode.folded" > "$OUT/collapse-$mode.txt"
done
GATE_STATUS=0
python3 "$LAB/tools/gate.py" "$OUT/feature-default.txt" "$OUT/feature-checked.txt" > "$OUT/gate-rejection.json" || GATE_STATUS=$?
printf 'gate_exit=%s\n' "$GATE_STATUS" > "$OUT/gate-exit.txt"
if (( GATE_STATUS > 1 )); then exit "$GATE_STATUS"; fi
python3 "$LAB/tools/validate_run.py" "$OUT" > "$OUT/mechanical-validation.txt"
