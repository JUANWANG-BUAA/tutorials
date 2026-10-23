#!/usr/bin/env bash
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
objdump=tool('EDGE_OBJDUMP','/opt/homebrew/opt/llvm@22/bin/llvm-objdump','llvm-objdump')
root=Path('.build/ch01/basepri');root.mkdir(parents=True,exist_ok=True)
flags=['--target=arm-none-eabi','-mcpu=cortex-m3','-mthumb','-O2','-ffreestanding','-fno-builtin','-fno-stack-protector','-Wall','-Wextra','-Werror']
subprocess.run([cc,*flags,'-c','firmware/ch01/arm/start.S','-o',str(root/'start.o')],check=True)
source=Path('firmware/ch01/arm/basepri.c').read_text()
assert source.count('msr basepri_max, %0')==1
for name,text in [('normal',source),('weakened',source.replace('msr basepri_max, %0','msr basepri, %0'))]:
 path=root/f'{name}.c';path.write_text(text)
 obj=root/f'{name}.o';elf=root/f'{name}.elf'
 subprocess.run([cc,*flags,'-c',str(path),'-o',str(obj)],check=True)
 subprocess.run([ld,'-T','firmware/ch04/arm/link.ld',str(root/'start.o'),str(obj),'-o',str(elf)],check=True)
 dump=subprocess.run([objdump,'-d',str(elf)],capture_output=True,text=True,check=True)
 (root/f'{name}-disassembly.txt').write_text(dump.stdout)
 args=['qemu-system-arm','-M','lm3s6965evb','-nographic','-monitor','none','-serial','none',
       '-semihosting-config','enable=on,target=native','-kernel',str(elf)]
 result=subprocess.run(args,capture_output=True,text=True,timeout=20)
 output=result.stdout+result.stderr;(root/f'{name}-run.txt').write_text(output)
 expected=0 if name=='normal' else 1
 if result.returncode!=expected or ('BASEPRI PASS:' if name=='normal' else 'BASEPRI FAIL') not in output:
  raise SystemExit(f'{name}: exit={result.returncode}, output={output}')
 print(output,end='')
 if name!='normal': print('MUTATION PASS: weakening BASEPRI instead of BASEPRI_MAX detected')
PY
