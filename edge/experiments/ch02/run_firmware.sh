#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
CC="${EDGE_CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
LD="${EDGE_LD:-/opt/homebrew/opt/lld@22/bin/ld.lld}"
OBJDUMP="${EDGE_OBJDUMP:-/opt/homebrew/opt/llvm@22/bin/llvm-objdump}"
[[ -x "$CC" ]] || CC="$(command -v clang)"
[[ -x "$LD" ]] || LD="$(command -v ld.lld)"
[[ -x "$OBJDUMP" ]] || OBJDUMP="$(command -v llvm-objdump)"
out=.build/ch02
mkdir -p "$out"

common=(-O2 -g -ffreestanding -fno-builtin -fno-stack-protector -Wall -Wextra -Werror)

# 1. ARM Cortex-M3
"$CC" --target=arm-none-eabi -mcpu=cortex-m3 -mthumb "${common[@]}" -c firmware/ch02/arm/main.c -o "$out/arm-main.o"
"$CC" --target=arm-none-eabi -mcpu=cortex-m3 -mthumb -c firmware/ch02/arm/start.S -o "$out/arm-start.o"
"$LD" -T firmware/ch02/arm/link.ld "$out/arm-start.o" "$out/arm-main.o" -o "$out/arm.elf"
"$OBJDUMP" -d "$out/arm.elf" > "$out/arm-disassembly.txt"

# 2. RV32IM
"$CC" --target=riscv32-none-elf -march=rv32im_zicsr -mabi=ilp32 "${common[@]}" -c firmware/ch02/rv32/main.c -o "$out/rv-main.o"
"$CC" --target=riscv32-none-elf -march=rv32im_zicsr -mabi=ilp32 -c firmware/ch02/rv32/start.S -o "$out/rv-start.o"
"$LD" -T firmware/ch02/rv32/link.ld "$out/rv-start.o" "$out/rv-main.o" -o "$out/rv32.elf"
"$OBJDUMP" -d "$out/rv32.elf" > "$out/rv32-disassembly.txt"

python3 - <<'PY'
from pathlib import Path
import subprocess
cases = {
 'arm': ['qemu-system-arm','-M','lm3s6965evb','-nographic','-monitor','none','-serial','none',
         '-semihosting-config','enable=on,target=native','-kernel','.build/ch02/arm.elf'],
 'rv32': ['qemu-system-riscv32','-M','virt','-nographic','-monitor','none','-bios','none','-kernel','.build/ch02/rv32.elf'],
}
for name, args in cases.items():
 r = subprocess.run(args, capture_output=True, text=True, timeout=20)
 output = r.stdout + r.stderr
 Path(f'.build/ch02/{name}-run.txt').write_text(output)
 print(output, end='')
 wanted = 'ARM CRT0 PASS:' if name == 'arm' else 'RV32 CRT0 PASS:'
 if r.returncode or wanted not in output or 'FAIL' in output:
  raise SystemExit(f'{name}: bad execution exit={r.returncode}')
PY
