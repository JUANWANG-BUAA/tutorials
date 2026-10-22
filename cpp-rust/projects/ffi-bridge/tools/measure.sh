#!/usr/bin/env bash
# Run from any working directory; refuse archive replacement.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
if [[ $# != 1 ]]; then echo "usage: $0 NEW_ARCHIVE_DIRECTORY" >&2; exit 2; fi
mkdir "$1"
out=$(cd "$1" && pwd)
cd "$root"
{
  date -u
  uname -a
  rustc -Vv
  cargo -V
  clang --version
  cmake --version
  sysctl hw.model hw.cachelinesize hw.ncpu
  printf '%s\n' 'Rust release opt-level=3 lto=false codegen-units=1 panic=unwind features=test-hooks'
  printf '%s\n' 'CMake Release; C11 -O3 -DNDEBUG -Wall -Wextra -Werror -UNDEBUG; no cross-language LTO'
  printf 'RUSTFLAGS=%s\n' "${RUSTFLAGS-<unset>}"
} > "$out/environment.txt" 2>&1
# External RUSTFLAGS could silently change panic/CPU flags; require explicit edit
# and a new archive if experimenting with them.
if [[ -n ${RUSTFLAGS-} ]]; then echo 'unset RUSTFLAGS for baseline' >&2; exit 2; fi
cargo fmt --check > "$out/fmt.txt" 2>&1
cargo clippy --offline --locked --all-targets --features test-hooks -- -D warnings > "$out/clippy.txt" 2>&1
cargo test --offline --locked --features test-hooks > "$out/rust-tests.txt" 2>&1
cmake -S . -B "$out/build" -DCMAKE_BUILD_TYPE=Release -DRB_TEST_HOOKS=ON > "$out/cmake-configure.txt" 2>&1
cmake --build "$out/build" --parallel 2 > "$out/cmake-build.txt" 2>&1
ctest --test-dir "$out/build" --output-on-failure > "$out/c-tests.txt" 2>&1
"$out/build/bridge_demo" 42 8192 > "$out/demo.txt"
mkdir "$out/codegen"
cargo rustc --offline --locked --release --features test-hooks --lib --target-dir "$out/codegen-target" -- --emit=mir,llvm-ir,asm,link > "$out/codegen-build.txt" 2>&1
find "$out/codegen-target/release/deps" -maxdepth 1 -type f \( -name '*.mir' -o -name '*.ll' -o -name '*.s' \) -exec cp {} "$out/codegen/" \;
clang -std=c11 -O3 -Wall -Wextra -Werror -UNDEBUG -Iinclude -S c/benchmark.c -o "$out/codegen/c-benchmark.s"
python3 - "$root" "$out" <<'PY'
import hashlib,json,pathlib,sys
root,out=map(pathlib.Path,sys.argv[1:])
files=[root/'Cargo.toml',root/'Cargo.lock',root/'CMakeLists.txt']
for d in ['src','tests','c','include','tools']:
    files.extend(p for p in (root/d).rglob('*') if p.is_file())
manifest={str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(files)}
(out/'source-sha256.json').write_text(json.dumps(manifest,indent=2)+'\n')
PY
# This lock is shared with other chapter agents, not a machine-wide scheduler.
lock=/Users/juanwang/Desktop/tutorials/.work/cpp-rust-agents/measure.lock
while ! mkdir "$lock" 2>/dev/null; do sleep 2; done
trap 'rmdir "$lock"' EXIT
printf '%s\n' 'Process snapshot before formal timing; unrelated desktop work remains uncontrolled.' > "$out/interference.txt"
ps -axo pid,ppid,comm,args | grep -E '[c]argo|[r]ustc|[c]lang|bridge_benchmark' >> "$out/interference.txt" || true
"$out/build/bridge_benchmark" > "$out/raw.csv"
python3 tools/summarize.py "$out/raw.csv" > "$out/summary.json"
# Separate profiling execution, never part of formal raw.csv.
"$out/build/bridge_benchmark" --profile-seconds 8 > "$out/profile-driver.txt" 2>&1 &
pid=$!
sleep 3
sample "$pid" 2 1 -file "$out/macos-sample.txt" > "$out/sample-command.txt" 2>&1 || true
wait "$pid"
printf '%s\n' 'Completed. sample exit status alone is not proof: inspect report before interpretation.'
