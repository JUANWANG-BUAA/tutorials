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
dump=tool('EDGE_OBJDUMP','/opt/homebrew/opt/llvm@22/bin/llvm-objdump','llvm-objdump')
root=Path('.build/ch03/trap');root.mkdir(parents=True,exist_ok=True)
flags=['--target=riscv32-none-elf','-march=rv32im_zicsr','-mabi=ilp32','-O2','-ffreestanding','-fno-builtin','-fno-stack-protector','-Wall','-Wextra','-Werror']
for unit in ['start.S','main.c','exercise.S']:
 subprocess.run([cc,*flags,'-c',f'firmware/ch03/rv32/{unit}','-o',str(root/(unit+'.o'))],check=True)
trap=Path('firmware/ch03/rv32/trap.S').read_text()
assert trap.count(' lw a1, 44(sp)')==1
main=Path('firmware/ch03/rv32/main.c').read_text()
marker='        /* IRQ returns to the unchanged mepc, not mepc+4. */'
assert main.count(marker)==1
variants=[('normal',trap,main),('bad-a1',trap.replace(' lw a1, 44(sp)',' li a1, 0'),main),
          ('bad-irq-pc',trap,main.replace(marker,'        frame->mepc+=4; /* wrong for an asynchronous IRQ */'))]
for name,assembly,c_source in variants:
 src=root/f'{name}.S';src.write_text(assembly)
 obj=root/f'{name}.o';elf=root/f'{name}.elf'
 c_path=root/f'{name}-main.c';c_path.write_text(c_source)
 c_obj=root/f'{name}-main.o'
 subprocess.run([cc,*flags,'-c',str(c_path),'-o',str(c_obj)],check=True)
 subprocess.run([cc,*flags,'-c',str(src),'-o',str(obj)],check=True)
 subprocess.run([ld,'-T','firmware/ch04/rv32/link.ld',str(root/'start.S.o'),str(c_obj),
                 str(root/'exercise.S.o'),str(obj),'-o',str(elf)],check=True)
 d=subprocess.run([dump,'-d',str(elf)],capture_output=True,text=True,check=True)
 (root/f'{name}-disassembly.txt').write_text(d.stdout)
 args=['qemu-system-riscv32','-M','virt','-nographic','-monitor','none','-bios','none','-kernel',str(elf)]
 r=subprocess.run(args,capture_output=True,text=True,timeout=20)
 output=r.stdout+r.stderr;(root/f'{name}-run.txt').write_text(output)
 expected=0 if name=='normal' else 1
 if r.returncode!=expected or ('TRAP PASS:' if name=='normal' else 'TRAP FAIL') not in output:
  raise SystemExit(f'{name}: exit={r.returncode} {output}')
 print(output,end='')
 if name!='normal': print(f'MUTATION PASS: RV32 {name} detected')
PY
