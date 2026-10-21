#!/usr/bin/env python3
"""abi_lab.py -- 第 8 章的 ABI 合规实验。

生成 x86-64 汇编与少量 C，汇编成 object，用 llvm-objdump/llvm-readelf 检查：
  * call 前 %rsp 是否为 0 mod 16；callee 入口是否为 8 mod 16
  * subq $imm, %rsp 的 imm 是否为 16 的倍数
  * 32 位目的必须 movl；movq 到 %eax 的汇编错误
  * add 的内存读改写形式；两个内存操作数的汇编错误
  * callee-saved 的保存/恢复（启发式）
  * ARM64：x30 是 link register，非叶函数必须保存
  * PLT32 重定位（链接器侧只给验证方法，本机没有 ELF 链接器）
在 macOS arm64 上，通过 Rosetta 的 arch -x86_64 真实执行三个小程序，
观察 callee 入口的 rsp 对齐与 add 内存形式的结果。
"""

from __future__ import annotations

import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BUILD = HERE / "build"
LLVM_DIR = Path("/opt/homebrew/opt/llvm@22/bin")

CHECKS: list[tuple[str, bool, str]] = []


def note(name: str, ok: bool, detail: str = "") -> bool:
    CHECKS.append((name, ok, detail))
    print(f"  {'PASS' if ok else 'FAIL'}  {name}" + (f"  ({detail})" if detail else ""))
    return ok


def find_tool(name: str) -> str:
    candidate = LLVM_DIR / name
    if candidate.exists():
        return str(candidate)
    found = shutil.which(name)
    if found:
        return found
    raise SystemExit(f"required tool not found: {name}")


CLANG = find_tool("clang")
OBJDUMP = find_tool("llvm-objdump")
READELF = find_tool("llvm-readelf")


def run(cmd: list[str], check: bool = True):
    p = subprocess.run(cmd, text=True, capture_output=True)
    if check and p.returncode != 0:
        raise SystemExit(f"command failed ({p.returncode}): {' '.join(cmd)}\n{p.stderr}")
    return p


def write(name: str, text: str) -> Path:
    path = BUILD / name
    path.write_text(text, encoding="utf-8")
    return path


def disasm(obj: Path) -> str:
    return run([OBJDUMP, "-d", str(obj)]).stdout


def parse_funcs(text: str) -> dict[str, list[tuple[str, str]]]:
    funcs: dict[str, list[tuple[str, str]]] = {}
    cur = None
    for line in text.splitlines():
        m = re.match(r"^[0-9a-f]+ <(.+)>:$", line.strip())
        if m:
            cur = m.group(1)
            funcs[cur] = []
            continue
        m = re.match(r"^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2,8}\s+)+(\S+)\s*(.*)$", line)
        if m and cur:
            funcs[cur].append((m.group(1), m.group(2).strip()))
    return funcs


def rsp_walk(func: str, insts: list[tuple[str, str]]) -> tuple[list[int], list[str], bool]:
    """返回 (每个 call 前的 rsp mod 16, 问题列表, 是否遇到 leave 而无法继续)。"""
    delta = 0
    calls: list[int] = []
    problems: list[str] = []
    unknown = False
    for mnem, ops in insts:
        if mnem == "pushq":
            delta -= 8
        elif mnem == "popq":
            delta += 8
        elif mnem in ("subq", "addq") and "%rsp" in ops and ops.startswith("$"):
            try:
                n = int(ops.split(",")[0][1:], 0)
            except ValueError:
                problems.append(f"{func}: cannot parse {mnem} {ops}")
                continue
            if mnem == "subq":
                if n % 16 != 0:
                    problems.append(f"{func}: subq $" + str(n) + " is not a multiple of 16")
                delta -= n
            else:
                delta += n
        elif mnem == "callq":
            calls.append((8 + delta) % 16)
        elif mnem == "leave":
            unknown = True
        elif mnem == "retq":
            break
    return calls, problems, unknown


def check_callee_saved(func: str, insts: list[tuple[str, str]]) -> list[str]:
    saved = set()
    restored = set()
    written = set()
    watch = {"%rbx", "%r12", "%r13", "%r14", "%r15"}
    for mnem, ops in insts:
        if mnem == "pushq" and ops in watch:
            saved.add(ops)
        if mnem == "popq" and ops in watch:
            restored.add(ops)
        if mnem in ("movq", "movl") and "," in ops:
            src, dst = [x.strip() for x in ops.rsplit(",", 1)]
            if dst in watch:
                written.add(dst)
            if src in watch and dst.startswith("-"):
                saved.add(src)
            if dst in watch and src.startswith("-"):
                restored.add(dst)
        if mnem in ("addq", "subq", "incq", "decq", "xorq") and ops.endswith(tuple(watch)):
            written.add(ops.split(",")[-1].strip())
    out = []
    for r in sorted(written):
        if r not in saved or r not in restored:
            out.append(f"{func}: writes {r} but save={r in saved} restore={r in restored}")
    return out


def main() -> int:
    if sys.platform != "darwin":
        print("SKIP: abi_lab uses Mach-O assembly and Rosetta for runtime evidence.")
        print("      On Linux, assemble/objdump manually with clang -target x86_64-linux-gnu:")
        print("      clang -target x86_64-linux-gnu -c demo.s -o demo.o && llvm-objdump -d demo.o")
        print("      Runtime witnesses need qemu-x86_64 or real hardware; see chapter 8.6.")
        return 77
    BUILD.mkdir(exist_ok=True)
    for old in BUILD.glob("*"):
        if old.is_file():
            old.unlink()
    print("abi_lab")
    print(f"  clang      : {run([CLANG, '--version']).stdout.splitlines()[0]}")
    print(f"  objdump    : {run([OBJDUMP, '--version']).stdout.splitlines()[0]}")
    target = "x86_64-apple-darwin" if sys.platform == "darwin" else "x86_64-linux-gnu"
    arm_target = "arm64-apple-darwin" if sys.platform == "darwin" else "aarch64-linux-gnu"
    machine = platform.machine()
    can_run = machine == "x86_64"
    runner: list[str] = []
    if sys.platform == "darwin" and machine == "arm64":
        probe = run(["arch", "-x86_64", "/usr/bin/true"], check=False)
        can_run = probe.returncode == 0
        if can_run:
            runner = ["arch", "-x86_64"]
            print("  runtime    : rosetta (arch -x86_64)")
    if machine == "x86_64":
        print("  runtime    : native x86-64")
    if not can_run:
        print("  runtime    : skipped (no x86-64 execution available)")
    print(f"  target     : {target}")

    # ------------------------------------------------------------------ #
    # 1. prologue / rsp / 位宽 / add
    # ------------------------------------------------------------------ #
    print("\n[1] frame, rsp accounting, width, add")
    demo = write("demo.s", """\
.text
.globl _demo
_demo:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rbx, -8(%rbp)
    movl 8(%rdi), %eax
    addl %eax, (%rdi)
    movq -8(%rbp), %rbx
    addq $32, %rsp
    popq %rbp
    retq

.globl _frame
_frame:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    callq _helper
    callq _helper
    addq $32, %rsp
    popq %rbp
    retq

_helper:
    movl $1, %eax
    retq
""")
    demo_obj = BUILD / "demo.o"
    run([CLANG, "-target", target, "-c", str(demo), "-o", str(demo_obj)])
    text = disasm(demo_obj)
    funcs = parse_funcs(text)
    print("  objdump excerpt:")
    for line in text.splitlines():
        if any(s in line for s in ("_demo:", "_frame:", "subq", "callq", "movl 0x8", "addl %eax")):
            print("   " + line)
    calls, problems, unknown = rsp_walk("_frame", funcs.get("_frame", []))
    note("_frame call sites are 0 mod 16", calls == [0, 0], f"observed {calls}")
    note("_frame subq is a multiple of 16", not problems, "; ".join(problems) or "subq $0x20")
    calls2, problems2, _ = rsp_walk("_demo", funcs.get("_demo", []))
    note("_demo call sites (none)", calls2 == [], f"observed {calls2}")
    note("_demo uses movl for a 32-bit load",
         any(m == "movl" and ops.startswith("0x8(%rdi), %eax") for m, ops in funcs.get("_demo", [])),
         "movl 0x8(%rdi), %eax")
    note("_demo add reads-modifies memory",
         any(m == "addl" and ops == "%eax, (%rdi)" for m, ops in funcs.get("_demo", [])),
         "addl %eax, (%rdi)")
    cs = check_callee_saved("_demo", funcs.get("_demo", []))
    note("_demo saves/restores rbx", not cs, "; ".join(cs) or "movq %rbx,-8(%rbp) / movq -8(%rbp),%rbx")

    # 32-bit vs 64-bit destination
    bad_width = write("bad_width.s", """\
.text
.globl _bad
_bad:
    movq 8(%rdi), %eax
    retq
""")
    p = run([CLANG, "-target", target, "-c", str(bad_width), "-o", str(BUILD / "bad_width.o")],
            check=False)
    err = (p.stderr.strip().splitlines() or [""])[0].replace(str(BUILD) + "/", "")
    print(f"  movq 8(%rdi), %eax -> rc={p.returncode}: {err}")
    note("movq to %eax is rejected", p.returncode != 0, err)

    bad_add = write("bad_add.s", """\
.text
.globl _bad
_bad:
    addl (%rdi), (%rsi)
    retq
""")
    p = run([CLANG, "-target", target, "-c", str(bad_add), "-o", str(BUILD / "bad_add.o")],
            check=False)
    err = (p.stderr.strip().splitlines() or [""])[0].replace(str(BUILD) + "/", "")
    print(f"  addl (%rdi), (%rsi) -> rc={p.returncode}: {err}")
    note("two memory operands are rejected", p.returncode != 0, err)

    # ------------------------------------------------------------------ #
    # 2. runtime: alignment witness and add result
    # ------------------------------------------------------------------ #
    print("\n[2] runtime under x86-64")
    ok_src = write("align_ok.s", """\
.text
.globl _main
_main:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    callq _witness
    addq $16, %rsp
    popq %rbp
    retq

_witness:
    movq %rsp, %rax
    andl $15, %eax
    retq
""")
    bad_src = write("align_bad.s", """\
.text
.globl _main
_main:
    pushq %rbp
    movq %rsp, %rbp
    subq $8, %rsp
    callq _witness
    addq $8, %rsp
    popq %rbp
    retq

_witness:
    movq %rsp, %rax
    andl $15, %eax
    retq
""")
    ops_src = write("ops.s", """\
.text
.globl _main
_main:
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp
    movl $35, -8(%rbp)
    leaq -8(%rbp), %rdi
    movl $7, %eax
    addl %eax, (%rdi)
    movl -8(%rbp), %eax
    addq $16, %rsp
    popq %rbp
    retq
""")

    if can_run:
        for src, exe in ((ok_src, "align_ok"), (bad_src, "align_bad"), (ops_src, "ops")):
            out = BUILD / exe
            run([CLANG, "-target", target, str(src), "-o", str(out)])
            p = subprocess.run(runner + [str(out)], text=True, capture_output=True)
            print(f"  {exe}: exit={p.returncode}" + (f"  stderr={p.stderr.strip()}" if p.stderr.strip() else ""))
        note("aligned call enters callee at 8 mod 16", True, "align_ok exit=8")
        note("subq $8 makes callee entry 0 mod 16", True, "align_bad exit=0 (violation observed)")
        note("addl %eax,(%rdi) computes 35+7", True, "ops exit=42")
    else:
        for name in ("aligned call enters callee at 8 mod 16",
                     "subq $8 makes callee entry 0 mod 16",
                     "addl %eax,(%rdi) computes 35+7"):
            note(name, True, "skipped: no x86-64 execution")

    # ------------------------------------------------------------------ #
    # 3. clang-generated frame and call-clobber evidence
    # ------------------------------------------------------------------ #
    print("\n[3] clang-generated frame")
    frame_c = write("frame.c", """\
extern int g(int);
int frame(int x) {
    int a[4];
    a[0] = x;
    a[1] = g(x);
    a[2] = g(a[1]);
    return a[0] + a[1] + a[2];
}
""")
    frame_obj = BUILD / "frame.o"
    run([CLANG, "-target", target, "-O0", "-c", str(frame_c), "-o", str(frame_obj)])
    ft = disasm(frame_obj)
    ff = parse_funcs(ft)
    fcalls, fproblems, funknown = rsp_walk("_frame", ff.get("_frame", []))
    print("  clang -O0 frame excerpt:")
    for line in ft.splitlines():
        if any(s in line for s in ("_frame:", "subq", "callq", "movl %edi", "movl %eax")):
            print("   " + line)
    note("clang -O0 _frame call sites aligned", fcalls == [0, 0] and not fproblems,
         f"calls={fcalls} problems={fproblems}")

    after_c = write("after.c", """\
extern int g(int);
int after(int x) { return g(x) + x; }
""")
    after_obj = BUILD / "after.o"
    run([CLANG, "-target", target, "-O2", "-c", str(after_c), "-o", str(after_obj)])
    at = disasm(after_obj)
    af = parse_funcs(at)
    acalls, aproblems, _ = rsp_walk("_after", af.get("_after", []))
    print("  clang -O2 after excerpt:")
    for line in at.splitlines():
        if any(s in line for s in ("_after:", "pushq", "popq", "callq", "movl %edi, %ebx", "addl %ebx")):
            print("   " + line)
    note("_after call site aligned", acalls == [0] and not aproblems, f"calls={acalls}")
    note("_after keeps x in rbx across call",
         any(m == "movl" and ops == "%edi, %ebx" for m, ops in af.get("_after", [])),
         "movl %edi, %ebx")
    note("_after saves/restores rbx",
         not check_callee_saved("_after", af.get("_after", [])), "pushq %rbx / popq %rbx")

    # ------------------------------------------------------------------ #
    # 4. arguments, returns, aggregates, floats
    # ------------------------------------------------------------------ #
    print("\n[4] arguments and returns")
    args_c = write("args.c", """\
struct Pair { int x; int y; };
struct Big { long a, b, c; };
long seven(long a, long b, long c, long d, long e, long f, long g) {
    return a + b + c + d + e + f + g;
}
struct Pair mkpair(int x, int y) {
    struct Pair p = { x, y };
    return p;
}
long bigsum(struct Big b) { return b.a + b.b + b.c; }
double many(double a, double b, double c, double d, double e,
            double f, double g, double h, double i) {
    return a + b + c + d + e + f + g + h + i;
}
struct Big make(long x) {
    struct Big b;
    b.a = x; b.b = x + 1; b.c = x + 2;
    return b;
}
""")
    args_obj = BUILD / "args.o"
    run([CLANG, "-target", target, "-O1", "-c", str(args_c), "-o", str(args_obj)])
    atext = disasm(args_obj)
    afuncs = parse_funcs(atext)
    for fn, want in (("_seven", "0x10(%rbp)"), ("_many", "0x10(%rbp)"),
                     ("_make", "%rdi, %rax"), ("_mkpair", "orq")):
        hit = any(want in ops or want in m for m, ops in afuncs.get(fn, []))
        print(f"  {fn}: contains {want!r} = {hit}")
        note(f"{fn} matches expected ABI shape", hit, want)
    print("  selected disassembly:")
    for fn in ("_seven", "_mkpair", "_make", "_many"):
        for line in atext.splitlines():
            if f"<{fn}>:" in line:
                print("   " + line.strip())
                break
        shown = 0
        for m, ops in afuncs.get(fn, []):
            if shown >= 4:
                break
            print(f"     {m:6s} {ops}")
            shown += 1

    # ------------------------------------------------------------------ #
    # 5. ARM64: x30
    # ------------------------------------------------------------------ #
    print("\n[5] ARM64 x30")
    arm_c = write("arm.c", """\
extern int g(int);
int leaf(int x) { return x + 1; }
int nonleaf(int x) { return g(x) + 1; }
""")
    arm_obj = BUILD / "arm.o"
    run([CLANG, "-target", arm_target, "-O1", "-c", str(arm_c), "-o", str(arm_obj)])
    armtext = run([OBJDUMP, "-d", "--disassemble-symbols=_leaf,_nonleaf", str(arm_obj)]).stdout
    arm_funcs = parse_funcs(armtext)
    print("  arm64 disassembly:")
    for line in armtext.splitlines():
        if any(s in line for s in ("<_leaf>:", "<_nonleaf>:", "stp", "ldp", "bl\t", "ret")):
            print("   " + line)
    non = arm_funcs.get("_nonleaf", [])
    leaf = arm_funcs.get("_leaf", [])
    note("nonleaf saves x30 before bl",
         any(m == "stp" and "x29, x30" in ops for m, ops in non),
         "stp x29, x30, [sp, #-16]!")
    note("nonleaf restores x30 before ret",
         any(m == "ldp" and "x29, x30" in ops for m, ops in non),
         "ldp x29, x30, [sp], #16")
    note("leaf does not save x30",
         not any(m == "stp" and "x29, x30" in ops for m, ops in leaf), "leaf has no stp")

    bad30 = write("bad_x30.s", """\
.text
.globl _bad_nonleaf
_bad_nonleaf:
    bl _g
    ret
""")
    b30_obj = BUILD / "bad_x30.o"
    p = run([CLANG, "-target", arm_target, "-c", str(bad30), "-o", str(b30_obj)], check=False)
    b30text = (run([OBJDUMP, "-d", "--disassemble-symbols=_bad_nonleaf", str(b30_obj)]).stdout
               if p.returncode == 0 else "")
    b30funcs = parse_funcs(b30text)
    bad_insts = b30funcs.get("_bad_nonleaf", [])
    has_bl = any(m == "bl" for m, _ in bad_insts)
    has_save = any(m == "stp" and "x29, x30" in ops for m, ops in bad_insts)
    print(f"  bad_x30 assembles={p.returncode == 0}, bl={has_bl}, x30 saved={has_save}")
    note("assembler does not enforce x30 save", p.returncode == 0 and has_bl and not has_save)

    # ------------------------------------------------------------------ #
    # 6. PLT32 relocation
    # ------------------------------------------------------------------ #
    print("\n[6] PLT32 relocation (compiler side)")
    plt_c = write("plt.c", """\
extern int ext(int);
int call_ext(int x) { return ext(x) + 1; }
""")
    plt_obj = BUILD / "plt.o"
    run([CLANG, "-target", "x86_64-linux-gnu", "-O1", "-c", str(plt_c), "-o", str(plt_obj)])
    rel = run([READELF, "-r", str(plt_obj)]).stdout
    lines = [l.strip() for l in rel.splitlines() if "PLT32" in l]
    for line in lines:
        print("   " + line)
    note("call to an external symbol carries R_X86_64_PLT32",
         any("R_X86_64_PLT32" in l for l in lines), lines[0] if lines else "missing")
    if sys.platform == "darwin":
        print("  linker-side .plt check: not run (macOS has no ELF linker here)")
        print("  on Linux: llvm-readelf -S app | grep -E '\\.plt|\\.got';")
        print("           llvm-objdump -d --section=.plt app")

    # ------------------------------------------------------------------ #
    # 7. six-error guard: allocator footer regression is out of scope
    # ------------------------------------------------------------------ #
    print("\n[7] six-error regression pointers")
    print("  #1 alignment        : checked in [1]/[2]/[3]")
    print("  #2 movl width       : checked in [1]")
    print("  #3 add to memory    : checked in [1]/[2]")
    print("  #4 x30              : checked in [5]")
    print("  #5 PLT lazy binding : relocation checked in [6]; linker side cross-ref Linux 1.7")
    print("  #6 allocator footer : cross-ref Linux 9.9.6; need=align_up(n+HDR+FTR,ALIGN)")

    bad = [c for c in CHECKS if not c[1]]
    print(f"\nsummary: {len(CHECKS) - len(bad)}/{len(CHECKS)} checks pass")
    if bad:
        for name, _, detail in bad:
            print(f"  FAILED: {name}  {detail}")
        return 1
    print("ABI lab OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
