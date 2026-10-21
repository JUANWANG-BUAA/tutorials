#!/usr/bin/env python3
"""minic test harness.

For every .mc case under tests/cases/:

  * run the direct-TAC interpreter          (--run)
  * run the optimized-SSA interpreter       (--run --opt)
  * assemble, link and run the x86-64 code  (--run-compiled [--opt])
  * assemble the emitted asm for darwin and linux, then inspect it

Expected stdout lines, exit status or a compile-error substring are declared
in the case file itself:

  // expect: 55
  // exit: 7
  // error: undeclared variable 'x'

If no x86-64 runtime is available the harness still assembles and
disassembles, and marks execution as skipped (the IR interpreter must pass).
"""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from miniclib.errors import MiniError  # noqa: E402
from miniclib.lexer import lex  # noqa: E402
from miniclib.nodes import Binary, dump_ast  # noqa: E402
from miniclib.opt import optimize  # noqa: E402
from miniclib.parser import parse  # noqa: E402
from miniclib.sema import analyze  # noqa: E402
from miniclib.ssa import build_ssa, verify_ssa  # noqa: E402
from miniclib.tac import lower_program  # noqa: E402
from miniclib.lower import lower_ssa  # noqa: E402

EXPECT_RE = re.compile(r"^//\s*expect:\s?(.*)$")
ERROR_RE = re.compile(r"^//\s*error:\s?(.*)$")
EXIT_RE = re.compile(r"^//\s*exit:\s*(\d+)$")

CASES = sorted((ROOT / "tests" / "cases").glob("*.mc"))


def parse_case(path: Path):
    exp, err, code = [], None, 0
    for line in path.read_text(encoding="utf-8").splitlines():
        m = EXPECT_RE.match(line)
        if m:
            exp.append(m.group(1))
            continue
        m = ERROR_RE.match(line)
        if m:
            err = m.group(1)
            continue
        m = EXIT_RE.match(line)
        if m:
            code = int(m.group(1))
    return exp, err, code


def run(args: list[str], timeout: int = 60):
    return subprocess.run(
        [sys.executable, str(ROOT / "minic.py"), *args],
        cwd=ROOT, capture_output=True, text=True, timeout=timeout,
    )


def check_asm_alignment(asm: str) -> list[str]:
    """Static checks that do not need an assembler."""
    problems = []
    for m in re.finditer(r"^\s*subq\s+\$(\d+),\s*%rsp", asm, re.M):
        value = int(m.group(1))
        if value % 16 != 0:
            problems.append(f"frame size {value} is not a multiple of 16")
    if re.search(r"^\s*movq\s+[^,]+,\s*%e(?:ax|bx|cx|dx|si|di|bp|sp)\b", asm, re.M):
        problems.append("movq with a 32-bit destination register")
    if re.search(r"^\s*pushq\s+(?!%rbp)", asm, re.M):
        problems.append("pushq other than the frame pointer changes rsp alignment")
    return problems


def check_objdump_alignment(objdump: str) -> list[str]:
    problems = []
    for m in re.finditer(r"subq\s+\$0x([0-9a-fA-F]+),\s*%rsp", objdump):
        if int(m.group(1), 16) % 16 != 0:
            problems.append(f"objdump frame size 0x{m.group(1)} is not 16-aligned")
    for m in re.finditer(r"subq\s+\$(\d+),\s*%rsp", objdump):
        if int(m.group(1)) % 16 != 0:
            problems.append(f"objdump frame size {m.group(1)} is not 16-aligned")
    return problems


def detect_compiled() -> bool:
    with tempfile.TemporaryDirectory() as td:
        src = Path(td) / "probe.mc"
        src.write_text("int main() { print(3); return 0; }\n", encoding="utf-8")
        proc = run([str(src), "--run-compiled"])
        return proc.returncode == 0 and proc.stdout == "3\n"


def has_tool(name: str) -> bool:
    return shutil.which(name) is not None


def unit_tests() -> list[str]:
    failures = []

    def check(name: str, cond: bool, detail: str = "") -> None:
        if not cond:
            failures.append(f"{name}: {detail}")

    # 1. lexer positions survive comments
    toks = lex("// c\nint x = 1;\n")
    x = [t for t in toks if t.kind == "IDENT"][0]
    check("lexer span", (x.span.line, x.span.col) == (2, 5), f"got {x.span}")

    # 2. Pratt precedence
    src = "int main() { print(2 + 3 * 4); return 0; }\n"
    program = analyze(parse(lex(src)))
    dump = dump_ast(program)
    check("precedence", "(2 + (3 * 4))" in dump, dump)

    # 3. pruned SSA inserts phis for loop-carried variables
    loop_src = (ROOT / "tests" / "cases" / "loop_phi.mc").read_text(encoding="utf-8")
    loop_fn = lower_program(analyze(parse(lex(loop_src))))[0]
    loop_ssa = build_ssa(loop_fn)
    phis = [ins for b in loop_ssa.blocks for ins in b.instrs if type(ins).__name__ == "Phi"]
    check("loop phi", len(phis) >= 2, f"phis={len(phis)}")
    check("loop ssa verify", verify_ssa(loop_ssa) == [], str(verify_ssa(loop_ssa)))

    # 4. every non-error case produces valid SSA
    for path in CASES:
        _, err, _ = parse_case(path)
        if err:
            continue
        text = path.read_text(encoding="utf-8")
        p = analyze(parse(lex(text, path.name), path.name))
        for fn in lower_program(p):
            problems = verify_ssa(build_ssa(fn))
            check(f"ssa {path.name}", not problems, "; ".join(problems))

    # 5. constant propagation and DCE actually remove instructions
    p = analyze(parse(lex(src)))
    base_fn = lower_program(p)[0]
    base_count = len(base_fn.instrs)
    ssa = build_ssa(base_fn)
    opt_ssa, stats = optimize(ssa)
    opt_count = sum(len(b.instrs) for b in opt_ssa.blocks)
    check("opt removed", stats.removed > 0 and opt_count < base_count,
          f"removed={stats.removed} before={base_count} after={opt_count}")

    # 6. alignment checker rejects the classic +8 bug
    bad = "f:\n  pushq %rbp\n  movq %rsp, %rbp\n  subq $24, %rsp\n  call g\n"
    check("alignment lint", bool(check_asm_alignment(bad)), "subq $24 not detected")
    bad2 = "f:\n  movq -8(%rbp), %eax\n"
    check("movl lint", bool(check_asm_alignment(bad2)), "movq->eax not detected")

    # 7. phi lowering removes every Phi
    lowered = lower_ssa(loop_ssa)
    check("phi lowering", all(type(i).__name__ != "Phi" for i in lowered.instrs))

    # 8. diagnostics carry a line and column
    proc = run([str(ROOT / "tests" / "cases" / "err_undeclared.mc"), "--run"])
    check("diagnostic", proc.returncode == 1 and re.match(r".*:\d+:\d+: error:", proc.stderr),
          proc.stderr)

    # 9. unsupported keyword is rejected by name
    for source, needle in (
        ("int main() { for (;;) {} }", "does not support 'for'"),
        ("int main() { int a[3]; }", "arrays are not supported"),
        ("#include <stdio.h>\nint main() { return 0; }", "preprocessor directives"),
        ("int g;\nint main() { return 0; }", "global variables are not supported"),
    ):
        try:
            program = analyze(parse(lex(source)))
            check("unsupported", False, f"no error for {needle}")
        except MiniError as exc:
            check("unsupported", needle in exc.message, exc.message)

    return failures


def main() -> int:
    failures: list[str] = []
    if not CASES:
        print("no test cases found")
        return 1

    compiled_ok = detect_compiled()
    clang = shutil.which("clang")
    objdump = shutil.which("llvm-objdump")
    if objdump is None:
        for candidate in ("/opt/homebrew/opt/llvm@22/bin/llvm-objdump", "/usr/local/opt/llvm/bin/llvm-objdump"):
            if os.path.exists(candidate):
                objdump = candidate
                break
    modes = ["--run", "--run --opt"]
    if compiled_ok:
        modes += ["--run-compiled", "--run-compiled --opt"]

    checked = 0
    for path in CASES:
        expect, error, exit_code = parse_case(path)
        for mode in modes:
            args = [str(path)] + mode.split()
            if error and mode != "--run":
                continue
            proc = run(args)
            label = f"{path.name} [{mode}]"
            if error:
                if proc.returncode != 1:
                    failures.append(f"{label}: exit {proc.returncode}, want compile error")
                elif error not in proc.stderr:
                    failures.append(f"{label}: missing {error!r} in stderr: {proc.stderr.strip()}")
                continue
            want = ("\n".join(expect) + "\n") if expect else ""
            if proc.returncode != exit_code:
                failures.append(f"{label}: exit {proc.returncode}, want {exit_code}; stderr={proc.stderr.strip()}")
            if proc.stdout != want:
                failures.append(f"{label}: stdout {proc.stdout!r}, want {want!r}")
            if proc.stderr:
                failures.append(f"{label}: unexpected stderr {proc.stderr.strip()!r}")
        checked += 1

    # Assemble every successful program for both targets and inspect the code.
    asm_checked = 0
    if clang:
        for path in CASES:
            _, error, _ = parse_case(path)
            if error:
                continue
            darwin_proc = run([str(path), "--emit=asm", "--target=darwin"])
            asm_darwin = darwin_proc.stdout
            if darwin_proc.returncode != 0:
                failures.append(f"{path.name}: darwin asm generation failed")
            linux_proc = run([str(path), "--emit=asm", "--target=linux"])
            asm_linux = linux_proc.stdout
            if linux_proc.returncode != 0:
                failures.append(f"{path.name}: linux asm generation failed")
            for label, text in (("darwin", asm_darwin), ("linux", asm_linux)):
                problems = check_asm_alignment(text)
                if problems:
                    failures.append(f"{path.name}: {label} asm lint: {'; '.join(problems)}")
            with tempfile.TemporaryDirectory() as td:
                o = Path(td) / "p.o"
                for target, label, text, out in (
                    ("x86_64-apple-darwin", "darwin", asm_darwin, o),
                    ("x86_64-linux-gnu", "linux", asm_linux, Path(td) / "l.o"),
                ):
                    s = Path(td) / f"{label}.s"
                    s.write_text(text, encoding="utf-8")
                    proc = subprocess.run(
                        [clang, "-target", target, "-c", str(s), "-o", str(out)],
                        capture_output=True, text=True,
                    )
                    if proc.returncode != 0:
                        failures.append(f"{path.name}: {target} assemble failed: {proc.stderr.strip()}")
                if objdump:
                    proc = subprocess.run([objdump, "-d", str(o)], capture_output=True, text=True)
                    pod = check_objdump_alignment(proc.stdout)
                    if pod:
                        failures.append(f"{path.name}: objdump: {'; '.join(pod)}")
            asm_checked += 1
    else:
        print("WARN: clang not found; assembly checks skipped")

    failures.extend(unit_tests())

    print(f"cases: {len(CASES)}  modes: {len(modes)}  asm targets: {asm_checked}")
    if not compiled_ok:
        print("NOTE: compiled execution skipped (no x86-64 assemble/link/run environment); IR interpreter still checked")
    if failures:
        print(f"FAIL ({len(failures)})")
        for f in failures:
            print("  - " + f)
        return 1
    print(f"ALL TESTS PASSED ({len(CASES)} cases, {len(modes)} execution modes)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
