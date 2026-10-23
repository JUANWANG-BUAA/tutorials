#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
CC="${EDGE_CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
LD="${EDGE_LD:-/opt/homebrew/opt/lld@22/bin/ld.lld}"
OBJCOPY="${EDGE_OBJCOPY:-/opt/homebrew/opt/llvm@22/bin/llvm-objcopy}"
OBJDUMP="${EDGE_OBJDUMP:-/opt/homebrew/opt/llvm@22/bin/llvm-objdump}"
for var in CC LD OBJCOPY OBJDUMP; do
 if [[ ! -x "${!var}" ]]; then
  case "$var" in CC) fallback=clang;; LD) fallback=ld.lld;; OBJCOPY) fallback=llvm-objcopy;; OBJDUMP) fallback=llvm-objdump;; esac
  printf -v "$var" '%s' "$(command -v "$fallback")"
 fi
done
out=.build/ch06
mkdir -p "$out"
"$CC" --version > "$out/versions.txt"
"$LD" --version >> "$out/versions.txt"
qemu-system-x86_64 --version >> "$out/versions.txt"
common=(-O2 -ffreestanding -fno-builtin -fno-stack-protector -fno-pic -fno-pie -Wall -Wextra -Werror -Iexperiments/ch06)
xflags=(--target=x86_64-none-elf -mno-red-zone -mno-sse -mno-sse2 -mno-mmx)
"$CC" "${xflags[@]}" "${common[@]}" -c experiments/ch06/can_core.c -o "$out/x86-core.o"
"$CC" "${xflags[@]}" "${common[@]}" -c experiments/ch06/core_selftest.c -o "$out/x86-test.o"
"$CC" "${xflags[@]}" "${common[@]}" -c firmware/ch06/x86/main.c -o "$out/x86-main.o"
"$CC" --target=x86_64-none-elf -c firmware/ch06/x86/entry.S -o "$out/x86-entry.o"
"$LD" -m elf_x86_64 -T firmware/ch06/x86/kernel.ld "$out/x86-entry.o" "$out/x86-main.o" "$out/x86-core.o" "$out/x86-test.o" -o "$out/can64.elf"
"$OBJCOPY" -O binary "$out/can64.elf" "$out/can64.bin"
"$CC" --target=i386-none-elf -c firmware/ch06/x86/boot.S -o "$out/boot32.o"
"$LD" -m elf_i386 -T firmware/ch06/x86/boot.ld "$out/boot32.o" -o "$out/boot32.elf"
"$OBJDUMP" -d "$out/can64.elf" > "$out/x86-disassembly.txt"
# The same driver/core are also cross-compiled, but not claimed to execute on these three targets.
for name in arm rv32 a64; do
 case "$name" in
  arm) target=(--target=arm-none-eabi -mcpu=cortex-m3 -mthumb);;
  rv32) target=(--target=riscv32-none-elf -march=rv32im_zicsr -mabi=ilp32);;
  a64) target=(--target=aarch64-none-elf -mgeneral-regs-only);;
 esac
 "$CC" "${target[@]}" "${common[@]}" -c experiments/ch06/can_core.c -o "$out/$name-core.o"
 "$CC" "${target[@]}" "${common[@]}" -c experiments/ch06/sja_driver.c -o "$out/$name-sja.o"
done
python3 - <<'PY'
from pathlib import Path
import subprocess
args = ['qemu-system-x86_64', '-accel', 'tcg', '-m', '64M', '-display', 'none',
        '-serial', 'none', '-monitor', 'none', '-debugcon', 'stdio',
        '-device', 'isa-debug-exit,iobase=0xf4,iosize=0x04', '-no-reboot',
        '-kernel', '.build/ch06/boot32.elf']
r = subprocess.run(args, capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
Path('.build/ch06/x86-run.txt').write_text(output)
print(output, end='')
# isa-debug-exit maps guest value 0x10 to host status (0x10<<1)|1 == 33.
if r.returncode != 33 or 'X86 CAN CORE PASS:' not in output or 'FAIL' in output:
    raise SystemExit(f'x86 failed: exit={r.returncode}')
PY
