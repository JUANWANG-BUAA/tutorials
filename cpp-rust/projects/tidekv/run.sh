#!/usr/bin/env bash
# 一条命令跑完：环境快照 -> build -> test -> bench -> analyze -> gate。
# 所有输出落盘到 results/run-01/，正文里的数字都来自这里。
set -euo pipefail
cd "$(dirname "$0")"

RES=results/run-01
mkdir -p "$RES"
BUDGET="${BUDGET:-1000}"          # 门禁预算 B：每次操作允许的额外开销上限，单位 ns/op
ROUNDS="${ROUNDS:-21}"            # 配对轮次
BATCHES="${BATCHES:-30}"          # 每轮批次数
OPS="${OPS:-900}"                 # 每批操作数
WARM_MS="${WARM_MS:-500}"         # 每个 case 每个 arm 的预热下限（毫秒）
FLUSH_EVERY="${FLUSH_EVERY:-300}" # B 侧每多少个操作 flush 一次（批生命周期）
SEED="${SEED:-20261028}"

step() { printf '\n===== %s =====\n' "$*"; }

step "environment"
{
  echo "rustc: $(rustc --version)"
  echo "cargo: $(cargo --version)"
  echo "cpu: $(sysctl -n machdep.cpu.brand_string)"
  echo "cachelinesize: $(sysctl -n hw.cachelinesize)"
  echo "ncpu: $(sysctl -n hw.ncpu) (perf-cores $(sysctl -n hw.perfcorenuclear 2>/dev/null || echo '?'), e-cores $(sysctl -n hw.efficiencycorenuclear 2>/dev/null || echo '?'))"
  echo "memsize_bytes: $(sysctl -n hw.memsize)"
  echo "memsize: $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GiB"
  echo "sw_vers: $(sw_vers -productName) $(sw_vers -productVersion) (build $(sw_vers -buildVersion))"
  echo "uname -m: $(uname -m)"
  echo "uname -a: $(uname -a)"
  echo "hv: $(sysctl -n kern.hv_vmm_present 2>/dev/null || echo unknown)"
  echo "l1d: $(sysctl -n hw.l1dcachesize 2>/dev/null || echo unknown) bytes/core"
  echo "l2: $(sysctl -n hw.l2cachesize 2>/dev/null || echo unknown) bytes"
} > "$RES/environment.txt"
cat "$RES/environment.txt"

: > "$RES/run-log.txt"
run() {
  printf '\n$ %s\n' "$*" | tee -a "$RES/run-log.txt"
  "$@" 2>&1 | tee -a "$RES/run-log.txt"
}

step "build"
run cargo build --release --offline

step "lint"
run cargo fmt --check
run cargo clippy --offline --all-targets -- -D warnings
run cargo doc --offline --no-deps

step "test"
run cargo test --release --offline -- --test-threads=4
grep -E "^test result:" "$RES/run-log.txt" > "$RES/test-summary.txt" || true
echo "test binaries: $(grep -c 'Running' "$RES/run-log.txt")" >> "$RES/test-summary.txt"
cat "$RES/test-summary.txt"

step "bench"
run ./target/release/tide-bench \
  --seed "$SEED" --rounds "$ROUNDS" --batches "$BATCHES" --ops "$OPS" \
  --warm-ms "$WARM_MS" --flush-every "$FLUSH_EVERY" \
  --out "$RES/bench.csv" --verify "$RES/bench-verification.txt"

step "analyze"
run python3 analyze.py "$RES/bench.csv" "$RES/statistics.json"

step "gate (B=$BUDGET ns/op)"
run python3 gate.py "$RES/statistics.json" -B "$BUDGET" -o "$RES/gate.json"

# ---------------------------------------------------------------- 机制对照轮
# 17.4 的「泛型 vs dyn 编解码」与 17.7 的「进程内压缩 vs 子进程压缩」单独一轮，
# 与主轮（run-01 的 A/B 基线比较）分开存放，避免两组结论混在一张表里。
MECH_RES=results/run-02
mkdir -p "$MECH_RES"
{
  echo "rustc: $(rustc --version)"
  echo "cargo: $(cargo --version)"
  echo "cpu: $(sysctl -n machdep.cpu.brand_string)"
  echo "cachelinesize: $(sysctl -n hw.cachelinesize)"
  echo "memsize_bytes: $(sysctl -n hw.memsize)"
  echo "sw_vers: $(sw_vers -productName) $(sw_vers -productVersion) (build $(sw_vers -buildVersion))"
  echo "uname -m: $(uname -m)"
} > "$MECH_RES/environment.txt"

step "mech bench (17.4 codec / 17.7 compaction)"
run ./target/release/tide-mech \
  --seed "$SEED" --rounds "$ROUNDS" --batches "$BATCHES" \
  --records "${RECORDS:-4096}" --entries "${ENTRIES:-4096}" --warm-ms "$WARM_MS" \
  --out-codec "$MECH_RES/codec.csv" --out-compaction "$MECH_RES/compaction.csv" \
  --verify "$MECH_RES/mech-verification.txt"

step "mech analyze"
run python3 analyze_mech.py "$MECH_RES/codec.csv" --units ns_per_record \
  --diff-convention "diff = B(dyn) - A(monomorphized generic), ns per record; positive means the dyn path costs more" \
  --out "$MECH_RES/statistics-codec.json"
run python3 analyze_mech.py "$MECH_RES/compaction.csv" --units ns_per_compaction \
  --diff-convention "diff = B(subprocess) - A(in-process), ns per merge; positive means the subprocess path costs more" \
  --out "$MECH_RES/statistics-compaction.json"

step "mech gate"
run python3 gate_mech.py "$MECH_RES/statistics-codec.json" -B "${CODEC_BUDGET_NS:-1.0}" \
  --budget-note "1 ns per record: the design rule in 17.4 -- once the extra cost of dyn exceeds this, the type set should be fixed and dyn moved off the hot path" \
  -o "$MECH_RES/gate-codec.json"
run python3 gate_mech.py "$MECH_RES/statistics-compaction.json" -B "${COMPACT_BUDGET_NS:-10000000}" \
  --budget-note "10 ms per merge: a contract declared in 17.7.2 before measuring, not a constant in this code -- there is no background compaction scheduler here (do_compact runs only when the writer thread handles Cmd::Compact; the only entry point is the explicit Tide::compact_two). Anchor: the A arm's own measured cost, 7.70 ms per merge, so the rule reads 'the extra paid for process isolation must not exceed one in-process merge'. The run-02 archive still carries the old wording; see results/run-02/CORRECTION.md" \
  -o "$MECH_RES/gate-compaction.json"

# ---------------------------------------------------------------- 准入对照轮（17.6）
# 门口那道上限调小会带来什么：CAP=64 与 CAP=4 吃同一份突发操作序列，
# 每批的分母（受理数）与段落盘次数一并落盘，比值才可能被别人重算。
ADMIT_RES=results/run-03
mkdir -p "$ADMIT_RES"
{
  echo "rustc: $(rustc --version)"
  echo "cargo: $(cargo --version)"
  echo "cpu: $(sysctl -n machdep.cpu.brand_string)"
  echo "cachelinesize: $(sysctl -n hw.cachelinesize)"
  echo "memsize_bytes: $(sysctl -n hw.memsize)"
  echo "sw_vers: $(sw_vers -productName) $(sw_vers -productVersion) (build $(sw_vers -buildVersion))"
  echo "uname -m: $(uname -m)"
} > "$ADMIT_RES/environment.txt"

step "admit bench (17.6 CAP=64 vs CAP=4)"
run ./target/release/tide-admit \
  --seed "$SEED" --rounds "$ROUNDS" --batches "${ADMIT_BATCHES:-20}" \
  --burst-ops "${BURST_OPS:-240}" --value-bytes "${VALUE_BYTES:-65536}" \
  --flush-bytes "${FLUSH_BYTES:-262144}" --warm-ms "$WARM_MS" \
  --cap-a "${CAP_A:-64}" --cap-b "${CAP_B:-4}" \
  --out "$ADMIT_RES/admit.csv" --verify "$ADMIT_RES/admit-verification.txt"

step "admit recompute (独立重算：比值必须能从 wall_ns 与分母推出来)"
run python3 verify_admit_csv.py "$ADMIT_RES/admit.csv" -o "$ADMIT_RES/recompute.txt"

step "admit analyze"
run python3 analyze_mech.py "$ADMIT_RES/admit.csv" --units ns_per_op \
  --diff-convention "diff = B(CAP=4) - A(CAP=64); two cases share one wall clock and differ only in the denominator" \
  --out "$ADMIT_RES/statistics.json"

step "admit gate (两个口径各自一条规则)"
run python3 gate_mech.py "$ADMIT_RES/statistics.json" -B "${ADMIT_BUDGET_NS:-5000}" --case ns_per_accepted \
  --budget-note "5 us per accepted op: the WAL append floor of one 64 KiB record is 65536 B / 1 GB/s = 65.5 us, and one record carries a quarter of a 256 KiB segment flush; a shift below 8% of that floor cannot change how large CAP should be" \
  -o "$ADMIT_RES/gate-accepted.json"
run python3 gate_mech.py "$ADMIT_RES/statistics.json" -B "${ADMIT_BUDGET_NS:-5000}" --case ns_per_attempted \
  --budget-note "same budget on the per-attempt denominator: accepting here only says the shallow gate did not make each attempt more expensive; the two arms did not do the same amount of work, see 17.6.2" \
  -o "$ADMIT_RES/gate-attempted.json"

step "done"
ls -l "$RES" "$MECH_RES" "$ADMIT_RES"
