#!/usr/bin/env bash
# Requires normal objects from run.sh. Each defect must explicitly fail, not time out.
set -euo pipefail
cd "$(dirname "$0")/../.."
python3 - <<'PY'
from pathlib import Path
import os,shutil,subprocess

def tool(env,default,name):
    p=os.environ.get(env) or (default if Path(default).is_file() else shutil.which(name))
    if not p: raise SystemExit(f'missing {name}')
    return p
cc=tool('EDGE_CC','/opt/homebrew/opt/llvm@22/bin/clang','clang')
ld=tool('EDGE_LD','/opt/homebrew/opt/lld@22/bin/ld.lld','ld.lld')
root=Path('.build/ch07/mutations');root.mkdir(parents=True,exist_ok=True)
cases=[('arm','unsigned-multiply','mul.S','smull r2, r3, r0, r1','umull r2, r3, r0, r1'),
       ('rv32','unsigned-high','mul.S','mulh t0, a0, a1','mulhu t0, a0, a1'),
       ('arm','missing-ack','main.c','REG(ADC_BASE+0x00c)=8; /* acknowledge */','REG(ADC_BASE+0x00c)=0; /* broken acknowledgement */')]
for name,label,filename,old,new in cases:
    source=Path(f'firmware/ch07/{name}/{filename}').read_text()
    assert source.count(old)==1
    modified=root/f'{label}-{filename}'
    modified.write_text(source.replace(old,new))
    target=['--target=arm-none-eabi','-mcpu=cortex-m3','-mthumb'] if name=='arm' else ['--target=riscv32-none-elf','-march=rv32im_zicsr','-mabi=ilp32']
    obj=root/f'{label}.o'
    subprocess.run([cc,*target,'-O2','-ffreestanding','-fno-builtin','-fno-stack-protector','-Iexperiments/ch07','-c',str(modified),'-o',str(obj)],check=True)
    units=['start','main','runtime','dsp','selftest','mul']
    replace='main' if filename=='main.c' else 'mul'
    objects=[str(obj) if u==replace else f'.build/ch07/{name}-{u}.o' for u in units]
    link=f'firmware/ch04/{name}/link.ld'
    elf=root/f'{label}.elf'
    subprocess.run([ld,'-T',link,*objects,'-o',str(elf)],check=True)
    args=(['qemu-system-arm','-M','lm3s6965evb','-nographic','-monitor','none','-serial','none',
          '-semihosting-config','enable=on,target=native'] if name=='arm' else
          ['qemu-system-riscv32','-M','virt','-nographic','-monitor','none','-bios','none'])
    result=subprocess.run([*args,'-kernel',str(elf)],capture_output=True,text=True,timeout=20)
    output=result.stdout+result.stderr
    (root/f'{label}-run.txt').write_text(output)
    assert result.returncode==1 and 'FAIL' in output,(label,result.returncode,output)
    if label=='missing-ack': assert 'ARM DSP PASS:' in output and 'ARM ADC PASS:' not in output
    else: assert 'DSP PASS:' not in output
    print(f'MUTATION PASS: {label}, explicit target FAIL exit=1')
PY
