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
root = Path('.build/ch08/mutations'); root.mkdir(parents=True, exist_ok=True)

flags = ['-O2', '-g', '-ffreestanding', '-fno-builtin', '-fno-stack-protector', '-Wall', '-Wextra', '-Werror', '-Iexperiments/ch08']

# 1. ARM Mutation: Corrupt pingpong consumption sequence check
arm_src = Path('firmware/ch08/arm/main.c').read_text()
assert 'if (popped.sequence != blk_idx' in arm_src
arm_mutant = root / 'arm_bad_seq.c'
# Invert comparison so it fails on first block
arm_mutant.write_text(arm_src.replace('if (popped.sequence != blk_idx', 'if (popped.sequence == blk_idx'))

subprocess.run([cc, '--target=arm-none-eabi', '-mcpu=cortex-m3', '-mthumb', *flags, '-c', str(arm_mutant), '-o', str(root/'arm_bad_seq.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch04/arm/link.ld', '.build/ch08/arm-start.o', str(root/'arm_bad_seq.o'), '.build/ch08/arm-core.o', '.build/ch08/arm-runtime.o', '-o', str(root/'arm_bad_seq.elf')], check=True)

r = subprocess.run(['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none',
                    '-semihosting-config', 'enable=on,target=native', '-kernel', str(root/'arm_bad_seq.elf')],
                   capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'arm_bad_seq_run.txt').write_text(output)
assert r.returncode == 1 and 'ARM DAQ FAIL' in output, f'ARM mutation failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: ARM sequence mismatch detected, explicit FAIL exit=1')

# 2. RV32 Mutation: Corrupt budget calculation check
rv_src = Path('firmware/ch08/rv32/main.c').read_text()
assert 'if (b.min_queue_depth_blocks != 14)' in rv_src
rv_mutant = root / 'rv_bad_budget.c'
rv_mutant.write_text(rv_src.replace('if (b.min_queue_depth_blocks != 14)', 'if (b.min_queue_depth_blocks == 14)'))

subprocess.run([cc, '--target=riscv32-none-elf', '-march=rv32im_zicsr', '-mabi=ilp32', *flags, '-c', str(rv_mutant), '-o', str(root/'rv_bad_budget.o')], check=True)
subprocess.run([ld, '-T', 'firmware/ch04/rv32/link.ld', '.build/ch08/rv-start.o', str(root/'rv_bad_budget.o'), '.build/ch08/rv-core.o', '.build/ch08/rv-runtime.o', '-o', str(root/'rv_bad_budget.elf')], check=True)

r = subprocess.run(['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none',
                    '-kernel', str(root/'rv_bad_budget.elf')], capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(root / 'rv_bad_budget_run.txt').write_text(output)
assert r.returncode == 1 and 'RV32 DAQ FAIL' in output, f'RV32 mutation failed to detect error: exit={r.returncode}, {output}'
print('MUTATION PASS: RV32 budget calculation mutation detected, explicit FAIL exit=1')
PY
