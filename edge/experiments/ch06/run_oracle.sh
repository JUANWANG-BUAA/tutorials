#!/usr/bin/env bash
# Independent polynomial long division and byte/bit framing oracle.
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 - <<'PY'
import subprocess
from pathlib import Path

def bits(value, width):
    return [int(x) for x in f'{value:0{width}b}']

message = [0] + bits(0x123, 11) + [0, 0, 0] + bits(8, 4)
for byte in [0, 0, 255, 255, 0x55, 0xaa, 0, 0]:
    message += bits(byte, 8)
# GF(2) long division, not the C implementation's feedback-register loop.
work = message + [0] * 15
polynomial = bits(0x8000 | 0x4599, 16)
for i in range(len(message)):
    if work[i]:
        for j, p in enumerate(polynomial): work[i+j] ^= p
raw = message + work[-15:]
stuffed = []
last, run = None, 0
for bit in raw:
    stuffed.append(bit)
    run = run + 1 if bit == last else 1
    last = bit
    if run == 5:
        last = 1 - bit
        stuffed.append(last)
        run = 1
# CRC delimiter, ACK=dominant, ACK delimiter, EOF, intermission.
reference = stuffed + [1, 0] + [1] * 11
result = subprocess.run(['.build/ch06/test_core', '--wire'], capture_output=True, text=True, check=True)
wire = ''.join(map(str, reference))
assert result.stdout.strip() == wire, (result.stdout.strip(), wire)
Path('.build/ch06/reference-wire.txt').write_text(wire + '\n')
print(f'ORACLE PASS: polynomial long division and complete {len(reference)}-bit wire agree')
PY
