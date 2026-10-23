#!/usr/bin/env bash
# Run after run_firmware.sh. Faulty variants must reach the explicit FAIL path.
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 - <<'PY'
import os
import shutil
import subprocess
from pathlib import Path

def tool(env, brew, fallback):
    value = os.environ.get(env) or (brew if Path(brew).is_file() else shutil.which(fallback))
    if not value:
        raise SystemExit(f'missing {fallback}')
    return value

cc = tool('EDGE_CC', '/opt/homebrew/opt/llvm@22/bin/clang', 'clang')
ld = tool('EDGE_LD', '/opt/homebrew/opt/lld@22/bin/ld.lld', 'ld.lld')
out = Path('.build/ch04/mutations')
out.mkdir(parents=True, exist_ok=True)
variants = [
 ('arm', 'firmware/ch04/arm/start.S', ' stmdb r0!, {r4-r11, lr}',
  ' stmdb r0!, {r4-r11, lr}\n movs r2, #0\n str r2, [r0]',
  ['--target=arm-none-eabi', '-mcpu=cortex-m3', '-mthumb'],
  'firmware/ch04/arm/link.ld', '.build/ch04/arm-main.o',
  ['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none', '-semihosting-config', 'enable=on,target=native', '-kernel']),
 ('rv32', 'firmware/ch04/rv32/switch.S', ' sw s0, 4(sp)', ' sw zero, 4(sp)',
  ['--target=riscv32-none-elf', '-march=rv32im_zicsr', '-mabi=ilp32'],
  'firmware/ch04/rv32/link.ld', '.build/ch04/rv-main.o',
  ['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none', '-kernel']),
]
for name, source, old, new, flags, link, main, command in variants:
    text = Path(source).read_text()
    assert text.count(old) == 1
    src = out / f'{name}.S'
    obj = out / f'{name}.o'
    elf = out / f'{name}.elf'
    src.write_text(text.replace(old, new))
    subprocess.run([cc, *flags, '-c', str(src), '-o', str(obj)], check=True)
    subprocess.run([ld, '-T', link, main, str(obj), '-o', str(elf)], check=True)
    result = subprocess.run([*command, str(elf)], capture_output=True, text=True, timeout=20)
    output = result.stdout + result.stderr
    (out / f'{name}-run.txt').write_text(output)
    if result.returncode == 0 or 'FAIL' not in output or 'PASS:' in output:
        raise SystemExit(f'mutation not detected: {name}: {result.returncode}: {output}')
    print(f'PASS mutation detected: {name}, explicit FAIL exit={result.returncode}')
PY
