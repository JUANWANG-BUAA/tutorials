#!/usr/bin/env bash
# Run run.sh first. A changed CRC polynomial must fail on host AND actual x86 execution.
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 - <<'PY'
from pathlib import Path
import os
import shutil
import subprocess

def tool(env, brew, name):
    value = os.environ.get(env) or (brew if Path(brew).is_file() else shutil.which(name))
    if not value: raise SystemExit(f'missing {name}')
    return value
cc = tool('EDGE_CC', '/opt/homebrew/opt/llvm@22/bin/clang', 'clang')
ld = tool('EDGE_LD', '/opt/homebrew/opt/lld@22/bin/ld.lld', 'ld.lld')
objcopy = tool('EDGE_OBJCOPY', '/opt/homebrew/opt/llvm@22/bin/llvm-objcopy', 'llvm-objcopy')
root = Path('.build/ch06/mutations')
root.mkdir(parents=True, exist_ok=True)
text = Path('experiments/ch06/can_core.c').read_text()
assert text.count('0x4599u') == 1
source = root / 'bad-core.c'
source.write_text(text.replace('0x4599u', '0x4598u'))
host = root / 'host'
subprocess.run(['cc', '-O2', '-Iexperiments/ch06', str(source), 'experiments/ch06/core_selftest.c',
                'experiments/ch06/test_core.c', '-o', str(host)], check=True)
r = subprocess.run([str(host)], capture_output=True, text=True, timeout=10)
assert r.returncode == 1 and 'CAN CORE FAIL' in r.stderr
(root / 'host-run.txt').write_text(r.stdout+r.stderr)
print('MUTATION PASS: wrong CRC rejected by host check vector')
obj = root / 'bad-core.o'
subprocess.run([cc, '--target=x86_64-none-elf', '-O2', '-ffreestanding', '-fno-builtin', '-fno-stack-protector',
 '-fno-pic', '-fno-pie', '-mno-red-zone', '-mno-sse', '-mno-sse2', '-mno-mmx', '-Iexperiments/ch06',
 '-c', str(source), '-o', str(obj)], check=True)
elf = root / 'bad64.elf'
subprocess.run([ld, '-m', 'elf_x86_64', '-T', 'firmware/ch06/x86/kernel.ld',
 '.build/ch06/x86-entry.o', '.build/ch06/x86-main.o', str(obj), '.build/ch06/x86-test.o', '-o', str(elf)], check=True)
binary = root / 'bad64.bin'
subprocess.run([objcopy, '-O', 'binary', str(elf), str(binary)], check=True)
boot = root / 'boot.S'
boot.write_text(Path('firmware/ch06/x86/boot.S').read_text().replace('.build/ch06/can64.bin', str(binary)))
subprocess.run([cc, '--target=i386-none-elf', '-c', str(boot), '-o', str(root/'boot.o')], check=True)
subprocess.run([ld, '-m', 'elf_i386', '-T', 'firmware/ch06/x86/boot.ld', str(root/'boot.o'),
 '-o', str(root/'boot.elf')], check=True)
args = ['qemu-system-x86_64', '-accel', 'tcg', '-m', '64M', '-display', 'none', '-serial', 'none',
 '-monitor', 'none', '-debugcon', 'stdio', '-device', 'isa-debug-exit,iobase=0xf4,iosize=0x04',
 '-no-reboot', '-kernel', str(root/'boot.elf')]
r = subprocess.run(args, capture_output=True, text=True, timeout=20)
output = r.stdout+r.stderr
(root/'x86-run.txt').write_text(output)
assert r.returncode == 35 and 'X86 CAN CORE FAIL' in output and 'PASS:' not in output, (r.returncode, output)
print('MUTATION PASS: wrong CRC rejected by x86 long-mode execution, exit=35')
PY
