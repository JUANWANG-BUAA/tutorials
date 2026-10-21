#!/usr/bin/env python3
"""Reproduce two classic backend bugs and show which checks catch them.

1. A prologue that subtracts 8 too many bytes (rsp becomes 8 mod 16 at the
   call).  The static lint and llvm-objdump reader both reject it.
2. A loop whose header is missing its phi nodes.  The SSA verifier reports
   uses of undefined names; the differential test would fail if it ran.

This script is a demonstration, not a compiler mode: it never patches the
compiler itself.
"""

from __future__ import annotations

import copy
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "tests"))

from miniclib.codegen import generate  # noqa: E402
from miniclib.lexer import lex  # noqa: E402
from miniclib.lower import lower_ssa  # noqa: E402
from miniclib.parser import parse  # noqa: E402
from miniclib.sema import analyze  # noqa: E402
from miniclib.ssa import build_ssa, verify_ssa  # noqa: E402
from miniclib.tac import lower_program  # noqa: E402
from run_tests import check_asm_alignment, check_objdump_alignment  # noqa: E402


def main() -> int:
    src = (ROOT / "examples" / "loop.mc").read_text(encoding="utf-8")
    program = analyze(parse(lex(src, "loop.mc"), "loop.mc"))
    tac = lower_program(program)
    ssa = build_ssa(tac[0])

    print("== bug 1: loop header without phi ==")
    broken = copy.deepcopy(ssa)
    for block in broken.blocks:
        block.instrs = [ins for ins in block.instrs if type(ins).__name__ != "Phi"]
    problems = verify_ssa(broken)
    for p in problems[:3]:
        print("  verify_ssa:", p)
    print(f"  detected: {bool(problems)}")

    print("== bug 2: prologue subtracts 8 too much ==")
    asm = generate([lower_ssa(ssa)], "darwin")
    match = re.search(r"subq \$(\d+), %rsp", asm)
    assert match is not None
    bad_asm = asm[:match.start(1)] + str(int(match.group(1)) + 8) + asm[match.end(1):]
    print("  patched line:", [l for l in bad_asm.splitlines() if "subq" in l][0].strip())
    lint = check_asm_alignment(bad_asm)
    print("  asm lint:", lint[0] if lint else "not detected")

    clang = shutil.which("clang")
    objdump = shutil.which("llvm-objdump") or (
        "/opt/homebrew/opt/llvm@22/bin/llvm-objdump"
        if Path("/opt/homebrew/opt/llvm@22/bin/llvm-objdump").exists() else None
    )
    if clang and objdump:
        with tempfile.TemporaryDirectory() as td:
            s = Path(td) / "bad.s"
            o = Path(td) / "bad.o"
            s.write_text(bad_asm, encoding="utf-8")
            proc = subprocess.run([clang, "-target", "x86_64-apple-darwin", "-c", str(s), "-o", str(o)],
                                  capture_output=True, text=True)
            if proc.returncode == 0:
                dis = subprocess.run([objdump, "-d", str(o)], capture_output=True, text=True).stdout
                found = check_objdump_alignment(dis)
                print("  objdump:", found[0] if found else "not detected")
                for line in dis.splitlines():
                    if "subq" in line:
                        print("  " + line.strip())
                        break
            else:
                print("  assemble failed:", proc.stderr.strip())
    return 0


if __name__ == "__main__":
    sys.exit(main())
