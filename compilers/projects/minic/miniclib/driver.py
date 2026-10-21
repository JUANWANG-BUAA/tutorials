"""Command-line driver and the compile pipeline.

Pipeline:
  source -> tokens -> AST -> sema -> TAC -> CFG -> SSA -> [opt] -> asm
The interpreter consumes TAC directly; the backend consumes lowered SSA.
"""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
import tempfile

from .codegen import generate
from .errors import InternalError, MiniError, MiniRuntimeError
from .lexer import format_tokens, lex
from .lower import lower_ssa
from .nodes import dump_ast
from .opt import optimize
from .parser import parse
from .sema import analyze
from .ssa import build_ssa, verify_ssa
from .tac import (
    Interpreter, TacFunction, build_cfg, format_cfg, lower_program,
    prune_unreachable,
)


def read_source(path: str) -> str:
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    except OSError as exc:
        raise MiniError(f"cannot read source file: {exc}") from exc


def format_error(path: str, source: str, exc: MiniError) -> str:
    span = exc.span
    lines = [f"{path}:{span.line}:{span.col}: error: {exc.message}" if span else f"{path}: error: {exc.message}"]
    if span:
        src_lines = source.splitlines()
        if 1 <= span.line <= len(src_lines):
            text = src_lines[span.line - 1].replace("\t", "    ")
            lines.append("  " + text)
            width = max(1, (span.end_col - span.col) if span.end_line == span.line else 1)
            lines.append("  " + " " * (span.col - 1) + "^" * width)
    if exc.note:
        lines.append(f"note: {exc.note}")
    return "\n".join(lines)


def assemble_and_link(asm_text: str, target: str, out_path: str | None,
                      verbose: bool = False) -> tuple[str, str]:
    """Assemble and link; returns (executable path, temp directory)."""
    host = "darwin" if sys.platform == "darwin" else "linux"
    if target != host:
        raise MiniError(f"cannot link a {target} executable on {host}; use --emit=asm")
    cc = os.environ.get("MINIC_CC", "cc")
    if shutil.which(cc) is None:
        raise MiniError(f"C compiler '{cc}' not found (set MINIC_CC)")
    tmp = tempfile.mkdtemp(prefix="minic-")
    asm = os.path.join(tmp, "prog.s")
    obj = os.path.join(tmp, "prog.o")
    exe = out_path or os.path.join(tmp, "prog")
    with open(asm, "w", encoding="utf-8") as f:
        f.write(asm_text)
    if target == "darwin":
        cc_cmd = [cc, "-target", "x86_64-apple-darwin", "-c", asm, "-o", obj]
        link_cmd = [cc, "-arch", "x86_64", obj, "-o", exe]
    else:
        cc_cmd = [cc, "-c", asm, "-o", obj]
        link_cmd = [cc, obj, "-o", exe]
    for cmd in (cc_cmd, link_cmd):
        if verbose:
            print("+ " + " ".join(cmd), file=sys.stderr)
        proc = subprocess.run(cmd, capture_output=True, text=True)
        if proc.returncode != 0:
            raise MiniError(
                "assembler/linker failed: " + " ".join(cmd)
                + "\n" + (proc.stderr or proc.stdout).strip()
            )
    return exe, tmp


def cmd_action(args) -> int:
    source = read_source(args.source)
    tokens = lex(source, args.source)
    if args.emit == "tokens":
        print(format_tokens(tokens))
        return 0
    program = parse(tokens, args.source)
    analyze(program)
    if args.emit == "ast":
        print(dump_ast(program))
        return 0

    tac = lower_program(program)
    ssa = [build_ssa(fn) for fn in tac]
    for fn in ssa:
        problems = verify_ssa(fn)
        if problems:
            raise InternalError("; ".join(problems))
    stats = []
    if args.opt:
        opt_funcs = []
        for fn in ssa:
            fn2, st = optimize(fn)
            problems = verify_ssa(fn2)
            if problems:
                raise InternalError("optimized SSA: " + "; ".join(problems))
            opt_funcs.append(fn2)
            stats.append(st)
        ssa = opt_funcs

    if args.emit == "ir":
        funcs = tac
        if args.opt:
            funcs = [lower_ssa(fn) for fn in ssa]
        print("\n\n".join(fn.dump() for fn in funcs))
        return 0
    if args.emit == "cfg":
        for fn in tac:
            cfg = prune_unreachable(build_cfg(fn))
            print(format_cfg(cfg))
        return 0
    if args.emit == "ssa":
        chunks = []
        if args.opt:
            total = sum(st.folded for st in stats)
            removed = sum(st.removed for st in stats)
            chunks.append(f"; optimized: folded={total} removed={removed}")
        chunks.extend(fn.dump() for fn in ssa)
        print("\n\n".join(chunks))
        return 0

    lowered = [lower_ssa(fn) for fn in ssa]
    if args.emit == "asm":
        sys.stdout.write(generate(lowered, args.target))
        return 0
    if args.run:
        # Without --opt the interpreter executes the direct TAC form, so the
        # differential test crosses the SSA/lowering path used by codegen.
        funcs = lowered if args.opt else tac
        interp = Interpreter(funcs, out=lambda s: print(s), max_steps=args.max_steps)
        result = interp.run()
        return result & 0xFF
    if args.run_compiled:
        asm_text = generate(lowered, args.target)
        exe, tmp = assemble_and_link(asm_text, args.target, None, args.verbose)
        try:
            try:
                proc = subprocess.run([exe])
            except OSError as exc:
                raise MiniError(
                    f"cannot execute {exe}: {exc}; use --run for the interpreter"
                ) from exc
            return proc.returncode & 0xFF
        finally:
            if not args.keep:
                shutil.rmtree(tmp, ignore_errors=True)
            else:
                print(f"kept {tmp}", file=sys.stderr)
    if args.build:
        asm_text = generate(lowered, args.target)
        out = args.out or "a.out"
        exe, tmp = assemble_and_link(asm_text, args.target, os.path.abspath(out), args.verbose)
        shutil.rmtree(tmp, ignore_errors=True)
        print(exe)
        return 0
    raise MiniError("no action selected")
