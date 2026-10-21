#!/usr/bin/env bash
# Chapter 13 experiment: one tour through every stage and the ABI evidence.
set -euo pipefail
cd "$(dirname "$0")/../.."

MINIC="python3 projects/minic/minic.py"
LOOP="projects/minic/examples/loop.mc"

echo "== 1. SSA for the loop (phi at the loop header) =="
$MINIC "$LOOP" --emit=ssa | sed -n '1,24p'

echo
echo "== 2. optimized SSA (constant propagation + DCE) =="
$MINIC "$LOOP" --emit=ssa --opt | sed -n '1,20p'

echo
echo "== 3. interpreter vs generated x86-64 =="
echo -n "interpreter: "; $MINIC "$LOOP" --run
echo -n "interp opt:  "; $MINIC "$LOOP" --run --opt
set +e
COMPILED=$($MINIC "$LOOP" --run-compiled 2>&1); RC=$?
COMPILED_OPT=$($MINIC "$LOOP" --run-compiled --opt 2>&1); RC_OPT=$?
set -e
if [ $RC -eq 0 ]; then echo "compiled:    $COMPILED"; else echo "compiled:    failed ($COMPILED)"; fi
if [ $RC_OPT -eq 0 ]; then echo "compiled opt: $COMPILED_OPT"; else echo "compiled opt: failed ($COMPILED_OPT)"; fi

echo
echo "== 4. stack frame in the emitted assembly =="
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
$MINIC "$LOOP" --emit=asm > "$TMP/loop.s"
sed -n '1,14p' "$TMP/loop.s"

if command -v clang >/dev/null 2>&1; then
  echo
  echo "== 5. llvm-objdump: subq frame is 16-aligned =="
  CLANG=$(command -v clang)
  OBJDUMP=$(command -v llvm-objdump || true)
  if [ -z "$OBJDUMP" ] && [ -x /opt/homebrew/opt/llvm@22/bin/llvm-objdump ]; then
    OBJDUMP=/opt/homebrew/opt/llvm@22/bin/llvm-objdump
  fi
  "$CLANG" -target x86_64-apple-darwin -c "$TMP/loop.s" -o "$TMP/loop.o"
  if [ -n "$OBJDUMP" ]; then
    "$OBJDUMP" -d "$TMP/loop.o" | sed -n '1,12p'
  else
    echo "llvm-objdump not found; assembly check only"
  fi
fi
