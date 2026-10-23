#!/usr/bin/env bash
# Cross-compile first; absence of a required compiler/emulator is an error, never PASS.
set -euo pipefail
cd "$(dirname "$0")/../.."
CC="${EDGE_CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
if [[ ! -x "$CC" ]]; then CC="$(command -v clang)"; fi
LD="${EDGE_LD:-/opt/homebrew/opt/lld@22/bin/ld.lld}"
if [[ ! -x "$LD" ]]; then LD="$(command -v ld.lld)"; fi
OBJDUMP="${EDGE_OBJDUMP:-/opt/homebrew/opt/llvm@22/bin/llvm-objdump}"
if [[ ! -x "$OBJDUMP" ]]; then OBJDUMP="$(command -v llvm-objdump)"; fi
out=".build/ch04"
mkdir -p "$out"
"$CC" --version > "$out/versions.txt"
"$LD" --version >> "$out/versions.txt"
qemu-system-arm --version >> "$out/versions.txt"
qemu-system-riscv32 --version >> "$out/versions.txt"
common=(-O2 -g -ffreestanding -fno-builtin -fno-stack-protector -Wall -Wextra -Werror)
"$CC" --target=arm-none-eabi -mcpu=cortex-m3 -mthumb "${common[@]}" -c firmware/ch04/arm/main.c -o "$out/arm-main.o"
"$CC" --target=arm-none-eabi -mcpu=cortex-m3 -mthumb -c firmware/ch04/arm/start.S -o "$out/arm-start.o"
"$LD" -T firmware/ch04/arm/link.ld "$out/arm-main.o" "$out/arm-start.o" -o "$out/arm.elf"
"$CC" --target=riscv32-none-elf -march=rv32im_zicsr -mabi=ilp32 "${common[@]}" -c firmware/ch04/rv32/main.c -o "$out/rv-main.o"
"$CC" --target=riscv32-none-elf -march=rv32im_zicsr -mabi=ilp32 -c firmware/ch04/rv32/switch.S -o "$out/rv-start.o"
"$LD" -T firmware/ch04/rv32/link.ld "$out/rv-main.o" "$out/rv-start.o" -o "$out/rv32.elf"
"$CC" --target=x86_64-unknown-linux-gnu -c firmware/ch04/x86_switch.S -o "$out/x86-switch.o"
"$CC" --target=aarch64-none-elf -c firmware/ch04/a64_switch.S -o "$out/a64-switch.o"
"$OBJDUMP" -d "$out/x86-switch.o" > "$out/x86-disassembly.txt"
"$OBJDUMP" -d "$out/a64-switch.o" > "$out/a64-disassembly.txt"
"$OBJDUMP" -d "$out/arm.elf" > "$out/arm-disassembly.txt"
"$OBJDUMP" -d "$out/rv32.elf" > "$out/rv32-disassembly.txt"
python3 - <<'PY'
import subprocess
from pathlib import Path
cases = {
 'arm': ['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none', '-semihosting-config', 'enable=on,target=native', '-kernel', '.build/ch04/arm.elf'],
 'rv32': ['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none', '-kernel', '.build/ch04/rv32.elf'],
}
for name, args in cases.items():
 result = subprocess.run(args, capture_output=True, text=True, timeout=20)
 output = result.stdout + result.stderr
 Path(f'.build/ch04/{name}-run.txt').write_text(output)
 print(output, end='')
 if result.returncode or 'PASS:' not in output or 'FAIL' in output:
  raise SystemExit(f'{name}: failed exit={result.returncode}')
PY
