#!/usr/bin/env bash
# Fault injection, NOT a performance benchmark. Each profile keeps four cases.
set -euo pipefail
cd "$(dirname "$0")/../../.."
[[ $# == 2 ]] || { echo 'usage: diagnostics/reproduce_descriptor_race.sh NEW_OUT debug|release' >&2; exit 2; }
[[ ! -e "$1" ]] || { echo "Refusing to overwrite $1" >&2; exit 2; }
[[ "$2" == debug || "$2" == release ]] || exit 2
mkdir -p "$1"
out="$(cd "$1" && pwd)"
profile="$2"
manifest="${DRAIN_MANIFEST:-$PWD/bench/runtime-lab/Cargo.toml}"
lab="$(cd "$(dirname "$manifest")" && pwd)"
{
  date -u; uname -a; rustc -Vv; cargo -V; clang --version
  printf 'manifest=%s\nprofile=%s\nRUSTFLAGS=%s\n' "$manifest" "$profile" "${RUSTFLAGS-}"
} > "$out/environment.txt"
python3 - "$lab" "$out" <<'PY'
import hashlib,json,pathlib,shutil,sys
lab,out=map(pathlib.Path,sys.argv[1:]); files=[]
for folder in ['src','tests','examples','diagnostics']:
    files += [p for p in (lab/folder).rglob('*') if p.is_file()]
files += [lab/'Cargo.toml',lab/'Cargo.lock']
manifest={}
for p in files:
    rel=p.relative_to(lab); manifest[str(rel)]=hashlib.sha256(p.read_bytes()).hexdigest()
    dst=out/'source-snapshot'/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dst)
(out/'source-hashes.json').write_text(json.dumps(manifest,indent=2)+'\n')
PY
flags=(--profile dev)
[[ "$profile" == debug ]] || flags=(--release)
cargo build --offline --locked --manifest-path "$manifest" "${flags[@]}" --bin lab-worker --example descriptor_race > "$out/build.txt" 2>&1
clang -Wall -Wextra -Werror -mmacosx-version-min=27.0 -dynamiclib \
  "$lab/diagnostics/pipe_gate.c" -o "$out/pipe_gate.dylib" > "$out/interposer-build.txt" 2>&1
failed=0
for mode in flood sleep; do
  for pipe in 1 2; do
    gate="$out/$mode-pipe$pipe"; mkdir "$gate"
    set +e
    DRAIN_CASE="$mode" DRAIN_GATE_N="$pipe" DRAIN_GATE_DIR="$gate" \
      DYLD_INSERT_LIBRARIES="$out/pipe_gate.dylib" \
      "$lab/target/$profile/examples/descriptor_race" > "$gate/report.txt" 2>&1
    status=$?
    set -e
    printf '%s pipe=%s exit=%s\n' "$mode" "$pipe" "$status" | tee -a "$out/status.txt"
    if [[ $status != 0 ]]; then failed=1; fi
  done
done
exit "$failed"
