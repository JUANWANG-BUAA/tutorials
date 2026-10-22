#!/usr/bin/env bash
set -euo pipefail
cd /Users/juanwang/Desktop/tutorials
out=cpp-rust/bench/results/runtime-fixed/measurements-final
[[ ! -e "$out" ]] || { echo 'Refusing existing measurement archive' >&2; exit 2; }
lock=/Users/juanwang/Desktop/tutorials/.work/cpp-rust-agents/measure.lock
while ! mkdir "$lock" 2>/dev/null; do sleep 1; done
trap 'rmdir "$lock"' EXIT
ps -axo pid,ppid,command | grep -E 'cargo|rustc' | grep -v grep > .work/cpp-rust-agents/drain-debug/measurement-build-observation.txt || true
bash cpp-rust/tools/run_runtime_benchmarks.sh bench/results/runtime-fixed/measurements-final
cp .work/cpp-rust-agents/drain-debug/measurement-build-observation.txt "$out/concurrent-build-observation.txt"
cp .work/cpp-rust-agents/drain-debug/measure-fixed.sh "$out/measurement-wrapper.sh"
python3 - <<'PY'
import pathlib,json,hashlib,shutil
root=pathlib.Path('cpp-rust');out=root/'bench/results/runtime-fixed/measurements-final'
for rel,want in json.loads((out/'source-hashes.json').read_text()).items():
    p=root/rel; assert hashlib.sha256(p.read_bytes()).hexdigest()==want
    d=out/'source-snapshot'/rel;d.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,d)
PY
# Profiling is a separate run, never one of the formal 21 observations.
cpp-rust/bench/runtime-lab/target/release/scheduling > "$out/scheduling-profile-run.txt" 2>&1 &
pid=$!
printf 'Separate run: /usr/bin/sample %s 1 1 -file scheduling-sample.txt\n' "$pid" > "$out/sample-command.txt"
/usr/bin/sample "$pid" 1 1 -file "$out/scheduling-sample.txt" > "$out/sample-command-output.txt" 2>&1
wait "$pid"
