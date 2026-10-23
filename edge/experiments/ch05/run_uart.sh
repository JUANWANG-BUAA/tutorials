#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
CC="${EDGE_CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
LD="${EDGE_LD:-/opt/homebrew/opt/lld@22/bin/ld.lld}"
if [[ ! -x "$CC" ]]; then CC="$(command -v clang)"; fi
if [[ ! -x "$LD" ]]; then LD="$(command -v ld.lld)"; fi
mkdir -p .build/ch05
"$CC" --target=arm-none-eabi -mcpu=cortex-m3 -mthumb -O2 -ffreestanding -fno-builtin -Wall -Wextra -Werror -c firmware/ch05/main.c -o .build/ch05/main.o
"$CC" --target=arm-none-eabi -mcpu=cortex-m3 -mthumb -c firmware/ch05/start.S -o .build/ch05/start.o
"$LD" -T firmware/ch04/arm/link.ld .build/ch05/main.o .build/ch05/start.o -o .build/ch05/uart.elf
python3 - <<'PY'
from pathlib import Path
import subprocess
import socket
import tempfile
import time

# Unix socket isolates guest UART from host terminal line disciplines.
with tempfile.TemporaryDirectory(prefix='edge-uart-') as tmp:
    address = str(Path(tmp) / 'uart.sock')
    args = ['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none',
            '-chardev', f'socket,id=u,path={address},server=on,wait=on', '-serial', 'chardev:u',
            '-semihosting-config', 'enable=on,target=native', '-kernel', '.build/ch05/uart.elf']
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stream = socket.socket(socket.AF_UNIX)
    log = bytearray()
    try:
        deadline = time.monotonic() + 10
        while not Path(address).exists():
            if time.monotonic() > deadline or proc.poll() is not None:
                raise RuntimeError('QEMU did not create UART socket')
            time.sleep(0.01)
        stream.connect(address)
        stream.settimeout(10)
        while b'UART READY\n' not in log:
            chunk = stream.recv(1024)
            if not chunk: raise RuntimeError('UART closed before READY')
            log.extend(chunk)
        # Send separately: this UART test intentionally has FIFO disabled.
        stream.sendall(b'\x55')
        time.sleep(0.05)  # host pacing, not a baud-rate measurement
        stream.sendall(b'\xa3')
        while b'UART PASS: IRQ5 received 0x55 and 0xa3\n' not in log and b'UART FAIL\n' not in log:
            chunk = stream.recv(1024)
            if not chunk: break
            log.extend(chunk)
        stdout, stderr = proc.communicate(timeout=10)
        Path('.build/ch05/uart-run.txt').write_bytes(log + stdout + stderr)
        print(log.decode(), end='')
        if proc.returncode or b'UART PASS:' not in log:
            raise RuntimeError(f'UART IRQ test failed exit={proc.returncode}, stderr={stderr!r}')
    finally:
        stream.close()
        if proc.poll() is None: proc.kill()
        proc.communicate()
PY
