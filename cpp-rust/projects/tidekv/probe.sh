#!/usr/bin/env bash
# 代码生成探针：把 lib 与 probe bin 编成 mir/llvm-ir/asm，再用 grep 在真实产物里取证。
# grep 不到就照实写「未出现」，不做美化。
set -uo pipefail
cd "$(dirname "$0")"

RES=results/run-01/codegen
mkdir -p "$RES"
rm -f "$RES"/* 2>/dev/null
LOG="$RES/findings.txt"
: > "$LOG"

note() { printf '%s\n' "$*" | tee -a "$LOG"; }
section() { printf '\n===== %s =====\n' "$*" | tee -a "$LOG"; }
newest() { (cd target/release/deps && ls -t $1 2>/dev/null | head -1 | sed 's|^|target/release/deps/|'); }

section "environment"
note "rustc: $(rustc --version)"
note "cargo: $(cargo --version)"
note "host: $(rustc -vV | awk '/^host:/{print $2}')"
note "cpu: $(sysctl -n machdep.cpu.brand_string), cacheline $(sysctl -n hw.cachelinesize) bytes"

section "emit"
note '$ cargo rustc --release --offline --lib -- --emit=mir,llvm-ir,asm'
if cargo rustc --release --offline --lib -- --emit=mir,llvm-ir,asm >>"$LOG" 2>&1; then
  note "  -> ok"
else
  note "  -> lib 编译失败（输出见上）"
fi
note '$ cargo rustc --release --offline --bin tide-probe -- --emit=mir,llvm-ir,asm'
if cargo rustc --release --offline --bin tide-probe -- --emit=mir,llvm-ir,asm >>"$LOG" 2>&1; then
  note "  -> ok"
else
  note "  -> bin 编译失败（输出见上）"
fi

LIB_ASM=$(newest 'tidekv-*.s');  LIB_LL=$(newest 'tidekv-*.ll');  LIB_MIR=$(newest 'tidekv-*.mir')
BIN_ASM=$(newest 'tide_probe-*.s'); BIN_LL=$(newest 'tide_probe-*.ll'); BIN_MIR=$(newest 'tide_probe-*.mir')
[ -n "$LIB_ASM" ] && cp "$LIB_ASM" "$RES/lib.s"
[ -n "$LIB_LL" ] && cp "$LIB_LL" "$RES/lib.ll"
[ -n "$LIB_MIR" ] && cp "$LIB_MIR" "$RES/lib.mir"
[ -n "$BIN_ASM" ] && cp "$BIN_ASM" "$RES/probe.s"
[ -n "$BIN_LL" ] && cp "$BIN_LL" "$RES/probe.ll"
[ -n "$BIN_MIR" ] && cp "$BIN_MIR" "$RES/probe.mir"
LIB_ASM="$RES/lib.s"; LIB_LL="$RES/lib.ll"; LIB_MIR="$RES/lib.mir"; BIN_ASM="$RES/probe.s"
note "lib asm: ${LIB_ASM} exists=$([ -f "$LIB_ASM" ] && echo yes || echo no)"
note "probe asm: ${BIN_ASM} exists=$([ -f "$BIN_ASM" ] && echo yes || echo no)"

# 从汇编里切出一个符号的函数体：从 `_symbol:` 到下一个顶层标签
body() {
  awk -v sym="$2" '
    $0 == sym":" {inside=1; print; next}
    inside && $0 ~ /^_[A-Za-z0-9_]+:/ {exit}
    inside {print}
  ' "$1"
}

section "1) Bloom::contains 的汇编体：除加载之外有没有调用"
if [ -f "$LIB_ASM" ]; then
  grep -oE '^_[^ ]*Bloom8contains[^ ]*:' "$LIB_ASM" | head -4 | tee -a "$LOG"
  SYM=$(grep -oE '^_[^ ]*Bloom8contains[^ ]*:' "$LIB_ASM" | head -1 | tr -d ':')
  if [ -n "$SYM" ]; then
    body "$LIB_ASM" "$SYM" > "$RES/contains.s"
  else
    : > "$RES/contains.s"
  fi
  n=$(wc -l < "$RES/contains.s" | tr -d ' ')
  note "符号: ${SYM:-未找到}"
  note "函数体行数: $n"
  if [ "$n" -gt 0 ]; then
    note "调用指令 (bl):"
    grep -nE '(^|[[:space:]])bl[[:space:]]' "$RES/contains.s" | tee -a "$LOG"
    note "bl 计数: $(grep -cE '(^|[[:space:]])bl[[:space:]]' "$RES/contains.s")  （0 = 热路径没有函数调用）"
    note "b/br 无条件分支计数: $(grep -cE '(^|[[:space:]])(b|br|b\.)[[:space:]]' "$RES/contains.s")"
    for m in ldp ldr ldur ldrb str stp; do
      note "  $m 行数: $(grep -cE "(^|[[:space:]])$m[[:space:]]" "$RES/contains.s")"
    done
    for m in cmp ccmp csel cinc min smaxp umaxp; do
      note "  $m 行数: $(grep -cE "(^|[[:space:]])$m([[:space:]]|\\.)" "$RES/contains.s")"
    done
  else
    note "未提取到独立函数体（可能已被内联，见第 3 节）"
  fi
else
  note "未出现：lib 汇编文件不存在"
fi

section "2) 自动向量化证据"
if [ -s "$RES/contains.s" ]; then
  note "向量寄存器出现情况:"
  grep -oE '\bv[0-9]+\.[0-9a-z]+' "$RES/contains.s" | sort | uniq -c | sort -rn | tee -a "$LOG"
  note "含 v 寄存器的行数: $(grep -cE '\bv[0-9]+' "$RES/contains.s")"
  note "ldp 行数: $(grep -cE '(^|[[:space:]])ldp[[:space:]]' "$RES/contains.s")"
  note "NEON 比较/归约 (cmeq|umaxp|uminp|min|max|bif|bsl|ld1) 行数: $(grep -cE '(cmeq|umaxp|uminp|\.min|\.max|bif|bsl|ld1)' "$RES/contains.s")"
else
  note "未出现（无 contains 汇编体）"
fi
if [ -f "$LIB_LL" ]; then
  note "lib LLVM-IR 中向量类型/shufflevector 命中行数: $(grep -cE '<16 x i8>|<8 x i16>|<16 x i1>|shufflevector' "$LIB_LL")"
  note "lib LLVM-IR 里的 contains 定义:"
  grep -nE 'define.*Bloom8contains' "$LIB_LL" | tee -a "$LOG"
fi

section "3) 内联证据：符号在哪定义、在哪被调用"
for SRC in "$LIB_ASM" "$BIN_ASM"; do
  [ -f "$SRC" ] || continue
  note "-- 文件 $(basename "$SRC")"
  for pat in Bloom8contains Segment3get Segment12get_no_bloom Memtable3get Tide3get Snapshot3get crc32; do
    defs=$(grep -cE "^_[^ ]*${pat}[^ ]*:" "$SRC")
    calls=$(grep -cE "bl[[:space:]]+_[^ ]*${pat}" "$SRC")
    note "   $(printf '%-22s' "$pat"): 定义 $defs 处, bl 调用 $calls 处"
  done
done
if [ -f "$BIN_ASM" ]; then
  note "probe bin 里所有对 tidekv 符号的调用点:"
  grep -oE 'bl[[:space:]]+_[A-Za-z0-9_.]*tidekv[A-Za-z0-9_.]*' "$BIN_ASM" | sort | uniq -c | sort -rn | head -15 | tee -a "$LOG"
  if [ ! -s "$LOG" ]; then note "未出现"; fi
  note "probe bin 的 probe_bloom 函数体里的调用:"
  PB=$(grep -oE '^_[^ ]*probe_bloom[^ ]*:' "$BIN_ASM" | head -1 | tr -d ':')
  if [ -n "$PB" ]; then
    body "$BIN_ASM" "$PB" > "$RES/probe_bloom.s"
    note "  行数 $(wc -l < "$RES/probe_bloom.s" | tr -d ' ')，bl 计数 $(grep -cE '(^|[[:space:]])bl[[:space:]]' "$RES/probe_bloom.s")"
    grep -nE '(^|[[:space:]])bl[[:space:]]' "$RES/probe_bloom.s" | head -10 | tee -a "$LOG"
  else
    note "  未找到 probe_bloom 符号"
  fi
fi
if [ -s "$RES/contains.s" ]; then
  SYMSEG=$(grep -oE '^_[^ ]*Segment12get_no_bloom[^ ]*:' "$LIB_ASM" | head -1 | tr -d ':')
  if [ -n "$SYMSEG" ]; then
    body "$LIB_ASM" "$SYMSEG" > "$RES/segment_get.s"
    note "Segment::get_no_bloom 体行数 $(wc -l < "$RES/segment_get.s" | tr -d ' ')，其中 bl 计数 $(grep -cE '(^|[[:space:]])bl[[:space:]]' "$RES/segment_get.s")"
    grep -nE '(^|[[:space:]])bl[[:space:]]' "$RES/segment_get.s" | head -10 | tee -a "$LOG"
    note "  ldp 行数 $(grep -cE '(^|[[:space:]])ldp[[:space:]]' "$RES/segment_get.s")，v 寄存器行数 $(grep -cE '\bv[0-9]+' "$RES/segment_get.s")"
  fi
fi

section "4) MIR"
if [ -f "$LIB_MIR" ]; then
  note "lib.mir 行数: $(wc -l < "$LIB_MIR" | tr -d ' ')"
  note "MIR 里 contains 的定义行:"
  grep -nE '^fn .*::contains' "$LIB_MIR" | head -3 | tee -a "$LOG"
  note "MIR 里 contains 的 basic block 数: $(awk '/^fn .*::contains/{f=1} f && /^    bb[0-9]+:/{c++} f&&/^\}/{if(c){print c; exit}}' "$LIB_MIR")"
  note "MIR 里对 Bloom::contains 的调用点个数: $(grep -cE 'Bloom::contains\(' "$LIB_MIR")"
  note "MIR 里 hash64 的调用点个数: $(grep -cE 'bloom::hash64|hash64\(' "$LIB_MIR")"
fi

section "raw counts (machine checkable)"
{
  echo "contains_asm_lines=$( [ -s "$RES/contains.s" ] && wc -l < "$RES/contains.s" | tr -d ' ' || echo 0)"
  echo "contains_bl=$( [ -s "$RES/contains.s" ] && grep -cE '(^|[[:space:]])bl[[:space:]]' "$RES/contains.s" || echo 0)"
  echo "contains_ldp=$( [ -s "$RES/contains.s" ] && grep -cE '(^|[[:space:]])ldp[[:space:]]' "$RES/contains.s" || echo 0)"
  echo "contains_vreg_lines=$( [ -s "$RES/contains.s" ] && grep -cE '\bv[0-9]+' "$RES/contains.s" || echo 0)"
  echo "lib_ll_vector_lines=$( [ -f "$LIB_LL" ] && grep -cE '<16 x i8>|<8 x i16>|<16 x i1>|shufflevector' "$LIB_LL" || echo 0)"
  echo "probe_asm_vreg_lines=$( [ -f "$BIN_ASM" ] && grep -cE '\bv[0-9]+' "$BIN_ASM" || echo 0)"
} | tee -a "$LOG"

note ""
note "产物: $(ls "$RES" | tr '\n' ' ')"
