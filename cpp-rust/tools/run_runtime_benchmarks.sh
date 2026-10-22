#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:-bench/results/runtime-reproduction}"
# Refuse to replace archived samples, even accidentally.
if [[ -e "$out/environment.txt" ]]; then echo "Choose a fresh output directory: $out" >&2; exit 1; fi
mkdir -p "$out"
manifest=bench/runtime-lab/Cargo.toml
{
  date -u '+%Y-%m-%dT%H:%M:%SZ'
  uname -a; rustc -Vv; cargo -V
  if [[ "$(uname -s)" == Darwin ]]; then sysctl hw.model machdep.cpu.brand_string hw.ncpu hw.cachelinesize; fi
  printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-}"
  echo 'No CPU affinity, thermal/frequency isolation or PMU; cases rotated and benchmarks sequential.'
} > "$out/environment.txt"
cargo fmt --manifest-path "$manifest" --check > "$out/fmt.txt" 2>&1
cargo clippy --offline --locked --manifest-path "$manifest" --all-targets -- -D warnings > "$out/clippy.txt" 2>&1
cargo test --offline --locked --manifest-path "$manifest" > "$out/tests.txt" 2>&1
cargo build --offline --locked --release --manifest-path "$manifest" > "$out/build.txt" 2>&1
for binary in scheduling blocking-poll process-rpc pipe-drain; do
  "bench/runtime-lab/target/release/$binary" > "$out/$binary.txt"
done
cargo rustc --offline --locked --release --manifest-path "$manifest" --lib -- --emit=llvm-ir,asm > "$out/ir-build.txt" 2>&1
cargo rustc --offline --locked --release --manifest-path "$manifest" --bin scheduling -- --emit=llvm-ir,asm > "$out/scheduling-ir-build.txt" 2>&1
cargo run --offline --locked --release --manifest-path "$manifest" --example type_layout > "$out/type-layout.txt" 2> "$out/layout-build.txt"
python3 - "$out" <<'PY'
import hashlib, json, pathlib, sys, shutil
root=pathlib.Path.cwd(); out=pathlib.Path(sys.argv[1]); lab=root/'bench/runtime-lab'
files=sorted((lab/'src').rglob('*.rs'))+sorted((lab/'tests').rglob('*.rs'))+sorted((lab/'examples').rglob('*.rs'))+[lab/'Cargo.toml',lab/'Cargo.lock',root/'bench/src/lib.rs']
(out/'source-hashes.json').write_text(json.dumps({str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},indent=2)+'\n')
for prefix, name in [('runtime_lab','runtime-lab'),('scheduling','scheduling')]:
    for suffix in ['s','ll']:
        candidates=list((lab/'target/release/deps').glob(prefix+'-*.'+suffix))
        assert candidates
        shutil.copyfile(max(candidates,key=lambda p:p.stat().st_mtime),out/(name+'.'+suffix))
PY
echo "Saved runtime and process evidence: $out"
