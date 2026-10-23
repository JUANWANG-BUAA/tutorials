#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 - <<'PY'
from pathlib import Path
import os, shutil, subprocess

def tool(env, default, name):
    p = os.environ.get(env) or (default if Path(default).is_file() else shutil.which(name))
    if not p: raise SystemExit(f'missing {name}')
    return p
cc = tool('EDGE_CC', '/opt/homebrew/opt/llvm@22/bin/clang', 'clang')
ld = tool('EDGE_LD', '/opt/homebrew/opt/lld@22/bin/ld.lld', 'ld.lld')
root = Path('.build/ch02/mutations'); root.mkdir(parents=True, exist_ok=True)

# Mutation 1: ARM start.S skips the .data copy loop (jumps directly to .bss zero)
arm_start = Path('firmware/ch02/arm/start.S').read_text()
assert 'b 1b' in arm_start
arm_mutant = root / 'arm_no_copy_start.S'
arm_mutant.write_text(arm_start.replace('b 1b', 'b 2f'))
subprocess.run([cc, '--target=arm-none-eabi', '-mcpu=cortex-m3', '-mthumb', '-c', str(arm_mutant), '-o', str(root/'arm_no_copy.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch02/arm/link.ld', str(root/'arm_no_copy.o'), '.build/ch02/arm-main.o', '-o', str(root/'arm_no_copy.elf')], check=True)

r = subprocess.run(['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none',
                    '-semihosting-config', 'enable=on,target=native', '-kernel', str(root/'arm_no_copy.elf')],
                   capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'arm_no_copy_run.txt').write_text(output)
assert r.returncode == 1 and 'ARM CRT0 FAIL' in output, f'ARM no-copy failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: ARM omitted .data copy detected, explicit FAIL exit=1')

# Mutation 2: RV32 main.c expects .bss to be 0, but mutant sets an initial value in RAM or skips BSS clear
rv_start = Path('firmware/ch02/rv32/start.S').read_text()
assert 'sb zero, 0(t0)' in rv_start
rv_mutant = root / 'rv_no_zero_start.S'
# Write 0xAA instead of zero into BSS
rv_mutant.write_text(rv_start.replace('sb zero, 0(t0)', 'li t2, 0xAA\n sb t2, 0(t0)'))
subprocess.run([cc, '--target=riscv32-none-elf', '-march=rv32im_zicsr', '-mabi=ilp32', '-c', str(rv_mutant), '-o', str(root/'rv_no_zero.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch02/rv32/link.ld', str(root/'rv_no_zero.o'), '.build/ch02/rv-main.o', '-o', str(root/'rv_no_zero.elf')], check=True)

r = subprocess.run(['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none',
                    '-kernel', str(root/'rv_no_zero.elf')], capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'rv_no_zero_run.txt').write_text(output)
assert r.returncode == 1 and 'RV32 CRT0 FAIL' in output, f'RV32 unzeroed BSS failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: RV32 contaminated .bss detected, explicit FAIL exit=1')
PY
