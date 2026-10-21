#!/usr/bin/env python3
"""minic command line entry point.

Examples:
  python3 minic.py examples/fib.mc --emit=ssa
  python3 minic.py examples/fib.mc --run
  python3 minic.py examples/fib.mc --run-compiled --opt
  python3 minic.py examples/fib.mc --emit=asm --target=linux
"""

from __future__ import annotations

import argparse
import sys

from .driver import cmd_action, format_error
from .errors import InternalError, MiniError, MiniRuntimeError
from .driver import read_source


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="minic",
        description="A small C-subset compiler: TAC, SSA, optimization and x86-64.",
    )
    p.add_argument("source", help="source file (.mc)")
    p.add_argument("--emit", choices=["tokens", "ast", "ir", "cfg", "ssa", "asm"],
                   help="print an intermediate artifact instead of executing")
    p.add_argument("--run", action="store_true", help="run with the TAC interpreter")
    p.add_argument("--run-compiled", action="store_true", dest="run_compiled",
                   help="assemble, link and run the generated x86-64 program")
    p.add_argument("--build", action="store_true", help="build an executable")
    p.add_argument("--out", help="output path for --build (default a.out)")
    p.add_argument("--opt", action="store_true", help="run constant propagation and DCE")
    p.add_argument("--target", choices=["darwin", "linux"],
                   default="darwin" if sys.platform == "darwin" else "linux",
                   help="assembly syntax/linking target")
    p.add_argument("--max-steps", type=int, default=20_000_000,
                   help="interpreter step limit (default 20000000)")
    p.add_argument("--verbose", action="store_true", help="print assembler commands")
    p.add_argument("--keep", action="store_true", help="keep temporary files")
    return p


def main(argv: list[str]) -> int:
    args = build_parser().parse_args(argv)
    actions = [bool(args.emit), args.run, args.run_compiled, args.build]
    if sum(actions) != 1:
        print("minic: choose exactly one of --emit, --run, --run-compiled, --build", file=sys.stderr)
        return 2
    source = None
    try:
        source = read_source(args.source)
        return cmd_action(args)
    except MiniError as exc:
        # read_source failures have no span and no source text.
        text = source if source is not None else ""
        print(format_error(args.source, text, exc), file=sys.stderr)
        return 1
    except MiniRuntimeError as exc:
        print(f"runtime error: {exc.message} (function {exc.func}, instruction {exc.pc})", file=sys.stderr)
        return 1
    except RecursionError:
        print("runtime error: call depth exceeded", file=sys.stderr)
        return 1
    except InternalError as exc:
        print(f"internal compiler error: {exc}", file=sys.stderr)
        return 3


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
