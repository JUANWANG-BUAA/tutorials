#!/usr/bin/env bash
set -euo pipefail
project="$(cd "$(dirname "$0")/.." && pwd)"
root="$(cd "$project/../../.." && pwd)"
out="${1:?usage: bash scripts/measure.sh NEW_OUTPUT_DIRECTORY}"
# mkdir, not mkdir -p: archives are immutable, including partially failed ones.
mkdir "$out"
out="$(cd "$out" && pwd)"
manifest="$project/Cargo.toml"
cargo fmt --manifest-path "$manifest" --check >"$out/fmt.txt" 2>&1
cargo clippy --offline --locked --manifest-path "$manifest" --all-targets -- -D warnings >"$out/clippy.txt" 2>&1
cargo test --offline --locked --manifest-path "$manifest" >"$out/tests.txt" 2>&1
cargo build --release --offline --locked --manifest-path "$manifest" --bins --examples >"$out/build.txt" 2>&1
cargo rustc --release --offline --locked --manifest-path "$manifest" --lib -- --emit=mir,llvm-ir,asm,link >"$out/codegen-lib.txt" 2>&1
cargo rustc --release --offline --locked --manifest-path "$manifest" --bin runtime-bench -- --emit=mir,llvm-ir,asm,link >"$out/codegen-bench.txt" 2>&1
mkdir "$out/native"
find "$project/target/release/deps" -maxdepth 1 -type f \( -name 'agent_runtime-*.mir' -o -name 'agent_runtime-*.ll' -o -name 'agent_runtime-*.s' -o -name 'runtime_bench-*.mir' -o -name 'runtime_bench-*.ll' -o -name 'runtime_bench-*.s' \) -exec cp {} "$out/native/" \;
python3 - "$project" "$out" <<'PY'
import hashlib, pathlib, shutil, sys
p, out = map(pathlib.Path, sys.argv[1:])
files = [p/'Cargo.toml', p/'Cargo.lock']
for sub in ('src', 'tests', 'examples', 'scripts', 'diagnostics'):
    files.extend(f for f in (p/sub).rglob('*') if f.is_file() and '__pycache__' not in str(f))
(out/'source-sha256.txt').write_text(''.join(hashlib.sha256(f.read_bytes()).hexdigest()+'  '+str(f.relative_to(p))+'\n' for f in sorted(files)))
for f in files:
    dst = out/'source-snapshot'/f.relative_to(p)
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(f, dst)
PY
{
  date -u '+%Y-%m-%dT%H:%M:%SZ'
  rustc -Vv
  cargo -V
  uname -a
  sw_vers
  sysctl machdep.cpu.brand_string hw.cachelinesize hw.ncpu
  printf 'release: opt-level=3 debug=1 default codegen-units, no explicit LTO/target-cpu\n'
  printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-<unset>}"
  printf 'CARGO_ENCODED_RUSTFLAGS=%s\n' "${CARGO_ENCODED_RUSTFLAGS-<unset>}"
  printf 'warmup >=500ms per case; 21 observations; process driver Tokio multi_thread workers=2\n'
  printf 'desktop machine; no CPU pinning or frequency control; direct children only\n'
} >"$out/environment.txt"
"$project/target/release/examples/layout" >"$out/layout.csv"
lock="$root/.work/cpp-rust-agents/measure.lock"
while ! mkdir "$lock" 2>/dev/null; do sleep 1; done
trap 'rmdir "$lock"' EXIT
# A snapshot is evidence, not a guarantee that no compiler starts later.
ps -axo pid,comm,args | grep -E '([/]cargo|[/]rustc|[ ]cargo |[ ]rustc )' >"$out/build-process-snapshot.txt" || true
"$project/target/release/runtime-bench" admission >"$out/admission.csv"
"$project/target/release/runtime-bench" lifecycle >"$out/lifecycle.csv"
python3 "$project/scripts/summarize.py" "$out" >"$out/statistics.csv"
# Profiling is a separate process, never a formal raw observation.
"$project/target/release/runtime-bench" profile >"$out/profile-run.txt" 2>&1 &
pid=$!
/usr/bin/sample "$pid" 3 1 -file "$out/macos-sample.txt" >"$out/sample-command.txt" 2>&1
wait "$pid"
shasum -a 256 "$project/target/release/runtime-bench" "$project/target/release/tool-helper" >"$out/binary-sha256.txt"
printf 'archive=%s\n' "$out"
