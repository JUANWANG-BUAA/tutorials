#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p .build/ch12/mutations
python3 - <<'PY'
from pathlib import Path
import os
import subprocess
root = Path('.build/ch12/mutations')
source = Path('experiments/ch12/ota.c').read_text()
mutations = {
 'missing-commit': ('    if (get32(p + 28) != 0) return false; /* COMMIT REQUIRED */', ''),
 'unpersisted-trial': ('OtaStatus s = commit_meta(n, m, false); /* PERSIST BEFORE JUMP */', 'OtaStatus s = OTA_OK; /* defect: RAM-only attempt */'),
}
for name, (old, new) in mutations.items():
    assert source.count(old) == 1
    mutant = root / f'{name}.c'
    mutant.write_text(source.replace(old, new))
    binary = root / name
    subprocess.run([os.environ.get('EDGE_HOST_CC', 'clang'), '-std=c11', '-O1', '-Wall', '-Wextra', '-Werror',
                    '-Iexperiments/ch12', str(mutant), 'experiments/ch12/selftest.c',
                    'experiments/ch12/test_host.c', '-o', str(binary)], check=True)
    r = subprocess.run([str(binary)], capture_output=True, text=True, timeout=20)
    output = r.stdout + r.stderr
    (root / f'{name}.log').write_text(output)
    assert r.returncode != 0 and ('assertion' in output.lower() or 'SELFTEST FAIL' in output), output
    print(f'MUTATION PASS {name}: actual policy defect rejected, exit={r.returncode}')
# Target mutation changes VTOR behavior, NOT a test comparison.
asm = Path('firmware/ch12/arm/handoff.S').read_text()
old = 'str r0, [r3]       /* INSTALL APPLICATION VTOR */'
assert asm.count(old) == 1
(root / 'bad-vtor.S').write_text(asm.replace(old, 'str r2, [r3]       /* defect: leave boot VTOR at zero */'))
PY
EDGE_OTA_ARM_HANDOFF=.build/ch12/mutations/bad-vtor.S \
EDGE_OTA_OUT=.build/ch12/mutations/firmware EDGE_OTA_BUILD_ONLY=1 \
    bash experiments/ch12/run_firmware.sh
python3 - <<'PY'
from pathlib import Path
import subprocess
p = Path('.build/ch12/mutations/firmware')
args = ['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none',
        '-semihosting-config', 'enable=on,target=native', '-kernel', str(p / 'arm-boot1.elf')]
for slot, address in enumerate((0x10000, 0x20000)):
    args += ['-device', f'loader,file={p}/arm-app{slot}.bin,addr={address},force-raw=on']
r = subprocess.run(args, capture_output=True, text=True, timeout=20)
output = r.stdout + r.stderr
(p / 'bad-vtor.log').write_text(output)
if r.returncode != 1 or 'ARM OTA FAIL' not in output:
    raise SystemExit(f'VTOR mutation not detected: exit={r.returncode}: {output}')
print('MUTATION PASS bad-vtor: actual vector-base defect rejected on Cortex-M3, explicit FAIL exit=1')
PY
