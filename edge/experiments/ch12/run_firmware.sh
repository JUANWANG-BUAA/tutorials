#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
CC="${EDGE_CC:-/opt/homebrew/opt/llvm@22/bin/clang}"
LD="${EDGE_LD:-/opt/homebrew/opt/lld@22/bin/ld.lld}"
OBJDUMP="${EDGE_OBJDUMP:-/opt/homebrew/opt/llvm@22/bin/llvm-objdump}"
OBJCOPY="${EDGE_OBJCOPY:-/opt/homebrew/opt/llvm@22/bin/llvm-objcopy}"
[[ -x "$CC" ]] || CC="$(command -v clang)"
[[ -x "$LD" ]] || LD="$(command -v ld.lld)"
[[ -x "$OBJDUMP" ]] || OBJDUMP="$(command -v llvm-objdump)"
[[ -x "$OBJCOPY" ]] || OBJCOPY="$(command -v llvm-objcopy)"
out="${EDGE_OTA_OUT:-.build/ch12/firmware}"
mkdir -p "$out"
common=(-std=c11 -Oz -g -ffreestanding -fno-builtin -fno-stack-protector
        -fno-unwind-tables -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections
        -Wall -Wextra -Werror -Ifirmware/ch12/include -Ifirmware/ch12 -Iexperiments/ch12)
for arch in arm rv32; do
    if [[ "$arch" == arm ]]; then
        target=(--target=arm-none-eabi -mcpu=cortex-m3 -mthumb)
        bases=(0x10000 0x20000)
        handoff="${EDGE_OTA_ARM_HANDOFF:-firmware/ch12/arm/handoff.S}"
    else
        target=(--target=riscv32-none-elf -march=rv32im_zicsr_zifencei -mabi=ilp32 -mno-relax)
        bases=(0x80200000 0x80300000)
        handoff=firmware/ch12/rv32/handoff.S
    fi
    objects=()
    for source in experiments/ch12/ota.c experiments/ch12/selftest.c firmware/ch12/runtime.c firmware/ch12/platform.c; do
        obj="$out/$arch-$(basename "${source%.c}").o"
        "$CC" "${target[@]}" "${common[@]}" -c "$source" -o "$obj"
        objects+=("$obj")
    done
    "$CC" "${target[@]}" -c "firmware/ch12/$arch/start.S" -o "$out/$arch-start.o"
    "$CC" "${target[@]}" -c "$handoff" -o "$out/$arch-handoff.o"
    for mode in 0 1 2; do
        "$CC" "${target[@]}" "${common[@]}" -DOTA_BOOT_MODE="$mode" -c firmware/ch12/boot.c -o "$out/$arch-boot$mode.o"
        "$LD" --gc-sections -T "firmware/ch12/$arch/boot.ld" -Map="$out/$arch-boot$mode.map" \
            "$out/$arch-start.o" "$out/$arch-handoff.o" "$out/$arch-boot$mode.o" "${objects[@]}" -o "$out/$arch-boot$mode.elf"
        "$OBJDUMP" -d "$out/$arch-boot$mode.elf" > "$out/$arch-boot$mode.dis"
    done
    "$CC" "${target[@]}" -c "firmware/ch12/$arch/app_start.S" -o "$out/$arch-app-start.o"
    for slot in 0 1; do
        "$CC" "${target[@]}" "${common[@]}" -DAPP_BASE="${bases[$slot]}" -DAPP_SLOT="$slot" \
            -c "firmware/ch12/$arch/app.c" -o "$out/$arch-app$slot.o"
        "$LD" --gc-sections --defsym=APP_BASE="${bases[$slot]}" -T "firmware/ch12/$arch/app.ld" \
            -Map="$out/$arch-app$slot.map" "$out/$arch-app-start.o" "$out/$arch-app$slot.o" \
            "$out/$arch-platform.o" -o "$out/$arch-app$slot.elf"
        "$OBJDUMP" -d "$out/$arch-app$slot.elf" > "$out/$arch-app$slot.dis"
        "$OBJCOPY" -O binary "$out/$arch-app$slot.elf" "$out/$arch-app$slot.bin"
    done
done
if [[ "${EDGE_OTA_BUILD_ONLY:-0}" == 1 ]]; then exit 0; fi
python3 - "$out" <<'PY'
from pathlib import Path
import subprocess
import sys
root = Path(sys.argv[1])
for arch in ('arm', 'rv32'):
    for mode, slot in ((0, 'A'), (1, 'B'), (2, 'A')):
        if arch == 'arm':
            args = ['qemu-system-arm', '-M', 'lm3s6965evb', '-nographic', '-monitor', 'none', '-serial', 'none',
                    '-semihosting-config', 'enable=on,target=native']
        else:
            args = ['qemu-system-riscv32', '-M', 'virt', '-nographic', '-monitor', 'none', '-bios', 'none']
        args += ['-kernel', str(root / f'{arch}-boot{mode}.elf')]
        for number, address in enumerate((0x10000, 0x20000) if arch == 'arm' else (0x80200000, 0x80300000)):
            args += ['-device', f'loader,file={root}/{arch}-app{number}.bin,addr={address},force-raw=on']
        result = subprocess.run(args, capture_output=True, text=True, timeout=20)
        output = result.stdout + result.stderr
        (root / f'{arch}-mode{mode}.log').write_text(output)
        print(f'[{arch} mode={mode}]', output, end='')
        if result.returncode != 0 or f'OTA APP {slot} PASS:' not in output or 'FAIL' in output:
            raise SystemExit(f'{arch} mode={mode}: failed, exit={result.returncode}')
PY
