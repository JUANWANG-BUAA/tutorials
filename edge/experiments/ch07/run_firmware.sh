#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
CC="${EDGE_CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
LD="${EDGE_LD:-/opt/homebrew/opt/lld@22/bin/ld.lld}"
OBJDUMP="${EDGE_OBJDUMP:-/opt/homebrew/opt/llvm@22/bin/llvm-objdump}"
[[ -x "$CC" ]] || CC="$(command -v clang)"
[[ -x "$LD" ]] || LD="$(command -v ld.lld)"
[[ -x "$OBJDUMP" ]] || OBJDUMP="$(command -v llvm-objdump)"
out=.build/ch07
mkdir -p "$out"
"$CC" --version > "$out/versions.txt"
"$LD" --version >> "$out/versions.txt"
qemu-system-arm --version >> "$out/versions.txt"
qemu-system-riscv32 --version >> "$out/versions.txt"
common=(-O2 -g -ffreestanding -fno-builtin -fno-stack-protector -Wall -Wextra -Werror -Iexperiments/ch07)
for name in arm rv32; do
 case "$name" in
 arm) target=(--target=arm-none-eabi -mcpu=cortex-m3 -mthumb); link=firmware/ch04/arm/link.ld;;
 rv32) target=(--target=riscv32-none-elf -march=rv32im_zicsr -mabi=ilp32); link=firmware/ch04/rv32/link.ld;;
 esac
 for unit in dsp selftest; do
  "$CC" "${target[@]}" "${common[@]}" -c "experiments/ch07/$unit.c" -o "$out/$name-$unit.o"
 done
 "$CC" "${target[@]}" "${common[@]}" -c firmware/ch07/runtime.c -o "$out/$name-runtime.o"
 "$CC" "${target[@]}" "${common[@]}" -c "firmware/ch07/$name/main.c" -o "$out/$name-main.o"
 "$CC" "${target[@]}" -c "firmware/ch07/$name/start.S" -o "$out/$name-start.o"
 "$CC" "${target[@]}" -c "firmware/ch07/$name/mul.S" -o "$out/$name-mul.o"
 "$LD" -T "$link" "$out/$name-start.o" "$out/$name-main.o" "$out/$name-runtime.o" \
  "$out/$name-dsp.o" "$out/$name-selftest.o" "$out/$name-mul.o" -o "$out/$name.elf"
 "$OBJDUMP" -d "$out/$name.elf" > "$out/$name-disassembly.txt"
done
"$CC" --target=x86_64-none-elf -c firmware/ch07/x86_mul.S -o "$out/x86-mul.o"
"$CC" --target=aarch64-none-elf -c firmware/ch07/a64_mul.S -o "$out/a64-mul.o"
"$OBJDUMP" -d "$out/x86-mul.o" > "$out/x86-disassembly.txt"
"$OBJDUMP" -d "$out/a64-mul.o" > "$out/a64-disassembly.txt"
python3 - <<'PY'
from pathlib import Path
import subprocess
cases = {
 'arm': ['qemu-system-arm','-M','lm3s6965evb','-nographic','-monitor','none','-serial','none',
         '-semihosting-config','enable=on,target=native','-kernel','.build/ch07/arm.elf'],
 'rv32': ['qemu-system-riscv32','-M','virt','-nographic','-monitor','none','-bios','none','-kernel','.build/ch07/rv32.elf'],
}
for name,args in cases.items():
 r=subprocess.run(args,capture_output=True,text=True,timeout=20)
 output=r.stdout+r.stderr
 Path(f'.build/ch07/{name}-run.txt').write_text(output)
 print(output,end='')
 wanted=['ARM DSP PASS:', 'ARM ADC PASS:'] if name=='arm' else ['RV32 DSP PASS:']
 if r.returncode or any(s not in output for s in wanted) or 'FAIL' in output:
  raise SystemExit(f'{name}: bad execution exit={r.returncode}')
PY
