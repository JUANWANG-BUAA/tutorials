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
root = Path('.build/ch10/mutations'); root.mkdir(parents=True, exist_ok=True)

flags = ['-O2', '-g', '-ffreestanding', '-fno-builtin', '-fno-stack-protector', '-Wall', '-Wextra', '-Werror', '-Iexperiments/ch10']

# 1. ARM Mutation: Corrupt WDT unlock key (write 0x12345678 instead of 0x1ACCE551)
arm_src = Path('firmware/ch10/arm/main.c').read_text()
assert '#define WDT_UNLOCK_KEY 0x1ACCE551UL' in arm_src
arm_mutant = root / 'arm_bad_key.c'
arm_mutant.write_text(arm_src.replace('#define WDT_UNLOCK_KEY 0x1ACCE551UL',
                                      '#define WDT_UNLOCK_KEY 0x12345678UL'))

subprocess.run([cc, '--target=arm-none-eabi', '-mcpu=cortex-m3', '-mthumb', *flags, '-c', str(arm_mutant), '-o', str(root/'arm_bad_key.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch04/arm/link.ld', '.build/ch10/arm-start.o', str(root/'arm_bad_key.o'), '.build/ch10/arm-core.o', '.build/ch10/arm-runtime.o', '-o', str(root/'arm_bad_key.elf')], check=True)

r = subprocess.run(['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none',
                    '-semihosting-config', 'enable=on,target=native', '-kernel', str(root/'arm_bad_key.elf')],
                   capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'arm_bad_key_run.txt').write_text(output)
assert r.returncode == 1 and 'ARM FAULT FAIL' in output, f'ARM mutation failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: ARM locked WDT write failure detected, explicit FAIL exit=1')

# 2. RV32 Mutation: Corrupt mcause status verification
rv_src = Path('firmware/ch10/rv32/main.c').read_text()
assert 'if (g_captured_crash.status_reg != 3) finish(1);' in rv_src
rv_mutant = root / 'rv_bad_cause.c'
rv_mutant.write_text(rv_src.replace('if (g_captured_crash.status_reg != 3) finish(1);',
                                    'if (g_captured_crash.status_reg == 3) finish(1);'))

subprocess.run([cc, '--target=riscv32-none-elf', '-march=rv32im_zicsr', '-mabi=ilp32', *flags, '-c', str(rv_mutant), '-o', str(root/'rv_bad_cause.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch04/rv32/link.ld', '.build/ch10/rv-start.o', str(root/'rv_bad_cause.o'), '.build/ch10/rv-core.o', '.build/ch10/rv-runtime.o', '-o', str(root/'rv_bad_cause.elf')], check=True)

r = subprocess.run(['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none',
                    '-kernel', str(root/'rv_bad_cause.elf')], capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'rv_bad_cause_run.txt').write_text(output)
assert r.returncode == 1 and 'RV32 FAULT FAIL' in output, f'RV32 mutation failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: RV32 inverted mcause check detected, explicit FAIL exit=1')
PY
