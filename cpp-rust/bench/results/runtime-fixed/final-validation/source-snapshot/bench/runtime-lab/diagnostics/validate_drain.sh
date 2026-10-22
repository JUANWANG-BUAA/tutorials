#!/usr/bin/env bash
# Correctness stress only; concurrent runtimes are intentional, not timing data.
set -euo pipefail
cd "$(dirname "$0")/../../.."
[[ $# == 1 && ! -e "$1" ]] || { echo 'usage: validate_drain.sh NEW_OUT (must not exist)' >&2; exit 2; }
mkdir -p "$1"; out="$(cd "$1" && pwd)"
manifest=bench/runtime-lab/Cargo.toml
{ date -u; uname -a; rustc -Vv; cargo -V; sysctl hw.model machdep.cpu.brand_string hw.ncpu hw.cachelinesize; printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-}"; } > "$out/environment.txt"
ps -axo pid,ppid,command | grep -E 'cargo|rustc' | grep -v grep > "$out/concurrent-build-observation.txt" || true
python3 - "$out" <<'PY'
import hashlib,json,pathlib,shutil,sys
root=pathlib.Path.cwd();out=pathlib.Path(sys.argv[1]);lab=root/'bench/runtime-lab'
files=[]
for folder in ['src','tests','examples','diagnostics']:
    files.extend(p for p in (lab/folder).rglob('*') if p.is_file())
files += [lab/'Cargo.toml',lab/'Cargo.lock',root/'bench/src/lib.rs']
manifest={}
for p in sorted(files):
    rel=p.relative_to(root);manifest[str(rel)]=hashlib.sha256(p.read_bytes()).hexdigest()
    d=out/'source-snapshot'/rel;d.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,d)
(out/'source-hashes.json').write_text(json.dumps(manifest,indent=2)+'\n')
PY
cargo fmt --manifest-path "$manifest" --check > "$out/fmt.txt" 2>&1
cargo clippy --offline --locked --manifest-path "$manifest" --all-targets -- -D warnings > "$out/clippy.txt" 2>&1
for profile in debug release; do
  flags=(--profile dev); [[ "$profile" == debug ]] || flags=(--release)
  cargo build --offline --locked --manifest-path "$manifest" "${flags[@]}" --bins --examples > "$out/build-$profile.txt" 2>&1
  for round in {1..10}; do
    # No --test-threads=1, no ignored failing assertions, no increased grace.
    cargo test --offline --locked --manifest-path "$manifest" "${flags[@]}" > "$out/tests-$profile-$round.txt" 2>&1
    printf 'tests profile=%s round=%s pass\n' "$profile" "$round" | tee -a "$out/status.txt"
  done
  for round in {1..5}; do
    "bench/runtime-lab/target/$profile/examples/process_stress" > "$out/stress-$profile-$round.txt" 2>&1
    printf 'stress profile=%s round=%s pass\n' "$profile" "$round" | tee -a "$out/status.txt"
  done
done
