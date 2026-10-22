#!/usr/bin/env bash
# Correctness validation only; default test parallelism, no grace adjustments.
set -euo pipefail
project="$(cd "$(dirname "$0")/.." && pwd)"
mkdir "${1:?usage: bash diagnostics/validate_capture.sh NEW_OUT}"
out="$(cd "$1" && pwd)"
manifest="$project/Cargo.toml"
{ date -u; rustc -Vv; cargo -V; sw_vers; printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-}"; } >"$out/environment.txt"
cargo fmt --manifest-path "$manifest" --check >"$out/fmt.txt" 2>&1
cargo clippy --offline --locked --manifest-path "$manifest" --all-targets -- -D warnings >"$out/clippy.txt" 2>&1
for profile in debug release; do
  flags=()
  [[ "$profile" == debug ]] || flags=(--release)
  cargo build --offline --locked --manifest-path "$manifest" "${flags[@]}" --bins --examples >"$out/$profile-build.txt" 2>&1
  for round in {1..10}; do
    cargo test --offline --locked --manifest-path "$manifest" "${flags[@]}" >"$out/$profile-tests-$round.txt" 2>&1
  done
  for round in {1..5}; do
    "$project/target/$profile/examples/runtime_stress" >"$out/$profile-stress-$round.txt" 2>&1
  done
  cargo run --offline --locked --manifest-path "$manifest" "${flags[@]}" --example library -- "$project/target/$profile/tool-helper" >"$out/$profile-library.txt" 2>&1
  bash "$project/diagnostics/reproduce_descriptor_race.sh" "$out/$profile-race" "$profile"
done
python3 - "$project" "$out" <<'PY'
import hashlib, pathlib, shutil, sys
p, out = map(pathlib.Path, sys.argv[1:])
files = [p/'Cargo.toml', p/'Cargo.lock']
for sub in ('src','tests','examples','scripts','diagnostics'):
    files += [f for f in (p/sub).rglob('*') if f.is_file() and '__pycache__' not in str(f)]
(out/'source-sha256.txt').write_text(''.join(hashlib.sha256(f.read_bytes()).hexdigest()+'  '+str(f.relative_to(p))+'\n' for f in sorted(files)))
for f in files:
    dst = out/'source-snapshot'/f.relative_to(p)
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(f,dst)
PY
printf 'validation=%s\n' "$out"
