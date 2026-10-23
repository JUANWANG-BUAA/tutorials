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
root = Path('.build/ch09/mutations'); root.mkdir(parents=True, exist_ok=True)

flags = ['-O2', '-g', '-ffreestanding', '-fno-builtin', '-fno-stack-protector', '-Wall', '-Wextra', '-Werror', '-Iexperiments/ch09']

# 1. ARM Mutation: Corrupt SCR check (fails if SLEEPONEXIT is set)
arm_src = Path('firmware/ch09/arm/main.c').read_text()
assert 'if (!(REG(SCB_SCR) & SCR_SLEEPONEXIT)) finish(1);' in arm_src
arm_mutant = root / 'arm_bad_scr.c'
arm_mutant.write_text(arm_src.replace('if (!(REG(SCB_SCR) & SCR_SLEEPONEXIT)) finish(1);',
                                      'if (REG(SCB_SCR) & SCR_SLEEPONEXIT) finish(1);'))

subprocess.run([cc, '--target=arm-none-eabi', '-mcpu=cortex-m3', '-mthumb', *flags, '-c', str(arm_mutant), '-o', str(root/'arm_bad_scr.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch04/arm/link.ld', '.build/ch09/arm-start.o', str(root/'arm_bad_scr.o'), '.build/ch09/arm-core.o', '.build/ch09/arm-runtime.o', '-o', str(root/'arm_bad_scr.elf')], check=True)

r = subprocess.run(['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none',
                    '-semihosting-config', 'enable=on,target=native', '-kernel', str(root/'arm_bad_scr.elf')],
                   capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'arm_bad_scr_run.txt').write_text(output)
assert r.returncode == 1 and 'ARM POWER FAIL' in output, f'ARM mutation failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: ARM corrupted SCR check detected, explicit FAIL exit=1')

# 2. RV32 Mutation: Corrupt wake count threshold check
rv_src = Path('firmware/ch09/rv32/main.c').read_text()
assert 'if (g_wake_count < 64) finish(1);' in rv_src
rv_mutant = root / 'rv_bad_wake.c'
rv_mutant.write_text(rv_src.replace('if (g_wake_count < 64) finish(1);',
                                    'if (g_wake_count >= 64) finish(1);'))

subprocess.run([cc, '--target=riscv32-none-elf', '-march=rv32im_zicsr', '-mabi=ilp32', *flags, '-c', str(rv_mutant), '-o', str(root/'rv_bad_wake.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch04/rv32/link.ld', '.build/ch09/rv-start.o', str(root/'rv_bad_wake.o'), '.build/ch09/rv-core.o', '.build/ch09/rv-runtime.o', '-o', str(root/'rv_bad_wake.elf')], check=True)

r = subprocess.run(['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none',
                    '-kernel', str(root/'rv_bad_wake.elf')], capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'rv_bad_wake_run.txt').write_text(output)
assert r.returncode == 1 and 'RV32 POWER FAIL' in output, f'RV32 mutation failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: RV32 corrupted wake count check detected, explicit FAIL exit=1')
PY
