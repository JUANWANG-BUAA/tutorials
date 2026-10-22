#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
out="${1:-bench/results/local}"
mkdir -p "$out"
{
  date -u '+%Y-%m-%dT%H:%M:%SZ'
  uname -a
  rustc -Vv
  cargo -V
  if [[ "$(uname -s)" == Darwin ]]; then
    sysctl hw.model machdep.cpu.brand_string hw.ncpu hw.memsize hw.cachelinesize
  elif [[ -r /proc/cpuinfo ]]; then
    grep -m 1 'model name' /proc/cpuinfo || true
    getconf _NPROCESSORS_ONLN
  fi
  printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-}"
  printf 'No affinity, governor, thermal isolation or PMU collection configured by this script.\n'
} > "$out/environment.txt"
cargo fmt --manifest-path bench/Cargo.toml --check > "$out/fmt.txt" 2>&1
cargo clippy --offline --manifest-path bench/Cargo.toml --all-targets -- -D warnings > "$out/clippy.txt" 2>&1
cargo test --offline --manifest-path bench/Cargo.toml > "$out/tests.txt" 2>&1
cargo build --offline --release --manifest-path bench/Cargo.toml > "$out/build.txt" 2>&1
# Run measurement processes serially; starting them concurrently would change the workload.
bench/target/release/atomic-contention 1 500000 21 > "$out/atomic-1.txt"
bench/target/release/atomic-contention 4 500000 21 > "$out/atomic-4.txt"
bench/target/release/handoff 5000 21 > "$out/handoff.txt"
bench/target/release/async-poll 100000 21 > "$out/async-poll.txt"
bench/target/release/future-allocation 100000 21 > "$out/future-allocation.txt"
cargo run --offline --release --manifest-path bench/Cargo.toml --example publication > "$out/publication.txt" 2> "$out/publication-build.txt"
cargo run --offline --release --manifest-path bench/Cargo.toml --example future_layout > "$out/future-layout.txt" 2> "$out/future-layout-build.txt"
python3 - "$out" <<'PY'
import hashlib, json, pathlib, sys
root = pathlib.Path.cwd()
out = pathlib.Path(sys.argv[1])
files = sorted((root / 'bench/src').rglob('*.rs')) + sorted((root / 'bench/examples').rglob('*.rs')) + sorted((root / 'bench/probes').rglob('*.rs')) + [root / 'bench/Cargo.toml', root / 'bench/Cargo.lock']
manifest = {str(p.relative_to(root)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
(out / 'source-hashes.json').write_text(json.dumps(manifest, indent=2) + '\n')
PY
printf 'Raw samples and environment saved to %s\n' "$out"
