#!/usr/bin/env python3
"""pipeline_tour.py — 最小可观察编译流水线。

源码 -> token -> AST -> 栈机字节码 -> 解释器。
默认模式打印每一阶段的产物，并用树遍历求值对拍字节码执行。
只用 Python 标准库；Python 3.11+。

用法:
    python3 experiments/ch01/pipeline_tour.py
    python3 experiments/ch01/pipeline_tour.py --no-fold
    python3 experiments/ch01/pipeline_tour.py --selftest
    python3 experiments/ch01/pipeline_tour.py --buggy
    python3 experiments/ch01/pipeline_tour.py --hash
    python3 experiments/ch01/pipeline_tour.py --fail
    python3 experiments/ch01/pipeline_tour.py --cache
"""

from __future__ import annotations

import argparse
import hashlib
import random
import sys
from dataclasses import dataclass

SOURCE = """a = 3 * (4 + 5) - 7 / 2;
b = a * a - 1;
a + b;
"""


# ---------------------------------------------------------------- stage 1: lex
@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    line: int
    col: int


class FrontendError(Exception):
    def __init__(self, stage: str, message: str, line: int, col: int) -> None:
        super().__init__(f"{stage}: {message} at {line}:{col}")
        self.stage = stage
        self.message = message
        self.line = line
        self.col = col


SINGLE = {
    "+": "PLUS",
    "-": "MINUS",
    "*": "STAR",
    "/": "SLASH",
    "(": "LPAREN",
    ")": "RPAREN",
    "=": "ASSIGN",
    ";": "SEMI",
}


def lex(src: str) -> list[Token]:
    out: list[Token] = []
    i, line, col = 0, 1, 1
    while i < len(src):
        c = src[i]
        if c == "\n":
            i += 1
            line += 1
            col = 1
            continue
        if c in " \t\r":
            i += 1
            col += 1
            continue
        if c.isdigit():
            start, scol = i, col
            while i < len(src) and src[i].isdigit():
                i += 1
                col += 1
            out.append(Token("INT", src[start:i], line, scol))
            continue
        if c.isalpha() or c == "_":
            start, scol = i, col
            while i < len(src) and (src[i].isalnum() or src[i] == "_"):
                i += 1
                col += 1
            out.append(Token("IDENT", src[start:i], line, scol))
            continue
        if c in SINGLE:
            out.append(Token(SINGLE[c], c, line, col))
            i += 1
            col += 1
            continue
        raise FrontendError("lex", f"unexpected character {c!r}", line, col)
    out.append(Token("EOF", "", line, col))
    return out


# ---------------------------------------------------------------- stage 2: parse
@dataclass(frozen=True)
class IntLit:
    value: int
    line: int
    col: int


@dataclass(frozen=True)
class Var:
    name: str
    line: int
    col: int


@dataclass(frozen=True)
class Unary:
    op: str
    operand: object
    line: int
    col: int


@dataclass(frozen=True)
class Binary:
    op: str
    left: object
    right: object
    line: int
    col: int


@dataclass(frozen=True)
class Assign:
    name: str
    value: object
    line: int
    col: int


@dataclass(frozen=True)
class ExprStmt:
    expr: object
    line: int
    col: int


@dataclass(frozen=True)
class Program:
    stmts: tuple


BINDING = {
    "PLUS": (10, 11),
    "MINUS": (10, 11),
    "STAR": (20, 21),
    "SLASH": (20, 21),
}


class Parser:
    def __init__(self, tokens: list[Token]) -> None:
        self.tokens = tokens
        self.pos = 0

    def peek(self, k: int = 0) -> Token:
        return self.tokens[min(self.pos + k, len(self.tokens) - 1)]

    def take(self, kind: str) -> Token:
        tok = self.peek()
        if tok.kind != kind:
            raise FrontendError(
                "parse", f"expected {kind}, found {tok.kind} {tok.text!r}", tok.line, tok.col
            )
        self.pos += 1
        return tok

    def parse(self) -> Program:
        stmts = []
        while self.peek().kind != "EOF":
            stmts.append(self.parse_stmt())
        return Program(tuple(stmts))

    def parse_stmt(self):
        if self.peek().kind == "IDENT" and self.peek(1).kind == "ASSIGN":
            name = self.take("IDENT")
            self.take("ASSIGN")
            value = self.parse_expr(0)
            self.take("SEMI")
            return Assign(name.text, value, name.line, name.col)
        expr = self.parse_expr(0)
        self.take("SEMI")
        return ExprStmt(expr, expr.line, expr.col)

    def parse_expr(self, min_bp: int):
        tok = self.peek()
        if tok.kind == "INT":
            self.pos += 1
            left = IntLit(int(tok.text), tok.line, tok.col)
        elif tok.kind == "IDENT":
            self.pos += 1
            left = Var(tok.text, tok.line, tok.col)
        elif tok.kind == "MINUS":
            self.pos += 1
            left = Unary("-", self.parse_expr(100), tok.line, tok.col)
        elif tok.kind == "LPAREN":
            self.pos += 1
            left = self.parse_expr(0)
            self.take("RPAREN")
        else:
            raise FrontendError(
                "parse", f"expected expression, found {tok.kind} {tok.text!r}", tok.line, tok.col
            )
        while True:
            bp = BINDING.get(self.peek().kind)
            if bp is None or bp[0] < min_bp:
                break
            op = self.peek()
            self.pos += 1
            right = self.parse_expr(bp[1])
            left = Binary(op.text, left, right, left.line, left.col)
        return left


def dump_ast(node, indent: int = 0) -> str:
    pad = "  " * indent
    if isinstance(node, Program):
        rows = [f"{pad}Program"]
        rows += [dump_ast(s, indent + 1) for s in node.stmts]
        return "\n".join(rows)
    if isinstance(node, Assign):
        return "\n".join(
            [f"{pad}Assign {node.name} @{node.line}:{node.col}", dump_ast(node.value, indent + 1)]
        )
    if isinstance(node, ExprStmt):
        return "\n".join([f"{pad}ExprStmt", dump_ast(node.expr, indent + 1)])
    if isinstance(node, Binary):
        return "\n".join(
            [
                f"{pad}Binary {node.op!r} @{node.line}:{node.col}",
                dump_ast(node.left, indent + 1),
                dump_ast(node.right, indent + 1),
            ]
        )
    if isinstance(node, Unary):
        return "\n".join(
            [f"{pad}Unary {node.op!r}", dump_ast(node.operand, indent + 1)]
        )
    if isinstance(node, IntLit):
        return f"{pad}IntLit {node.value}"
    if isinstance(node, Var):
        return f"{pad}Var {node.name}"
    raise TypeError(f"unknown node {node!r}")


# ---------------------------------------------------------------- stage 3: codegen
@dataclass(frozen=True)
class Instr:
    op: str
    arg: object = None


BINOP = {"+": "ADD", "-": "SUB", "*": "MUL", "/": "DIV"}


def compile_program(prog: Program, swap_operands: bool = False) -> list[Instr]:
    code: list[Instr] = []

    def gen(node) -> None:
        if isinstance(node, IntLit):
            code.append(Instr("CONST", node.value))
        elif isinstance(node, Var):
            code.append(Instr("LOAD", node.name))
        elif isinstance(node, Unary):
            gen(node.operand)
            code.append(Instr("NEG"))
        elif isinstance(node, Binary):
            if swap_operands:  # 错误版本：先右后左，与 VM 的 pop 约定冲突
                gen(node.right)
                gen(node.left)
            else:
                gen(node.left)
                gen(node.right)
            code.append(Instr(BINOP[node.op]))
        elif isinstance(node, Assign):
            gen(node.value)
            code.append(Instr("STORE", node.name))
        elif isinstance(node, ExprStmt):
            gen(node.expr)
            code.append(Instr("PRINT"))
        else:
            raise TypeError(f"unknown node {node!r}")

    for stmt in prog.stmts:
        gen(stmt)
    code.append(Instr("HALT"))
    return code


EFFECT = {
    "CONST": (0, 1),
    "LOAD": (0, 1),
    "STORE": (1, -1),
    "ADD": (2, -1),
    "SUB": (2, -1),
    "MUL": (2, -1),
    "DIV": (2, -1),
    "NEG": (1, 0),
    "PRINT": (1, -1),
    "HALT": (0, 0),
}


def verify_stack(code: list[Instr]) -> tuple[str | None, int]:
    """只检查栈高度；它不能证明操作数顺序正确。"""
    depth = 0
    peak = 0
    for ip, ins in enumerate(code):
        need, delta = EFFECT[ins.op]
        if depth < need:
            return (
                f"ip={ip} {ins.op}: needs {need} operand(s), stack has {depth}",
                peak,
            )
        depth += delta
        peak = max(peak, depth)
        if ins.op == "HALT":
            if depth != 0:
                return (f"ip={ip} HALT: {depth} value(s) left on stack", peak)
            break
    return (None, peak)


# ---------------------------------------------------------------- stage 4: execute
class VMError(Exception):
    pass


def cdiv(a: int, b: int) -> int:
    if b == 0:
        raise VMError("division by zero")
    q = abs(a) // abs(b)
    return q if (a < 0) == (b < 0) else -q


def run_vm(code: list[Instr], env: dict | None = None, trace: list | None = None,
           trace_limit: int = 0):
    stack: list[int] = []
    env = dict(env or {})
    out: list[int] = []
    ip = 0
    steps = 0
    while True:
        if ip >= len(code):
            raise VMError(f"ip={ip}: fell off end of code")
        ins = code[ip]
        before = list(stack)
        op = ins.op
        if op == "CONST":
            stack.append(int(ins.arg))
        elif op == "LOAD":
            if ins.arg not in env:
                raise VMError(f"ip={ip} LOAD: undefined variable {ins.arg!r}")
            stack.append(env[ins.arg])
        elif op == "STORE":
            if not stack:
                raise VMError(f"ip={ip} STORE: stack underflow")
            env[str(ins.arg)] = stack.pop()
        elif op in {"ADD", "SUB", "MUL", "DIV"}:
            if len(stack) < 2:
                raise VMError(
                    f"ip={ip} {op}: stack underflow (need 2, have {len(stack)})"
                )
            b = stack.pop()
            a = stack.pop()
            if op == "ADD":
                stack.append(a + b)
            elif op == "SUB":
                stack.append(a - b)
            elif op == "MUL":
                stack.append(a * b)
            else:
                stack.append(cdiv(a, b))
        elif op == "NEG":
            if not stack:
                raise VMError(f"ip={ip} NEG: stack underflow")
            stack.append(-stack.pop())
        elif op == "PRINT":
            if not stack:
                raise VMError(f"ip={ip} PRINT: stack underflow")
            out.append(stack.pop())
        elif op == "HALT":
            if stack:
                raise VMError(f"ip={ip} HALT: stack not empty: {stack}")
            steps += 1
            if trace is not None and len(trace) < trace_limit:
                trace.append((ip, ins, before, list(stack), dict(env)))
            return (out[-1] if out else None), steps, out
        else:
            raise VMError(f"ip={ip}: unknown op {op}")
        steps += 1
        if trace is not None and len(trace) < trace_limit:
            trace.append((ip, ins, before, list(stack), dict(env)))
        ip += 1


def eval_expr(node, env: dict, counter: list[int]) -> int:
    counter[0] += 1
    if isinstance(node, IntLit):
        return node.value
    if isinstance(node, Var):
        if node.name not in env:
            raise VMError(f"undefined variable {node.name!r}")
        return env[node.name]
    if isinstance(node, Unary):
        return -eval_expr(node.operand, env, counter)
    if isinstance(node, Binary):
        a = eval_expr(node.left, env, counter)
        b = eval_expr(node.right, env, counter)
        if node.op == "+":
            return a + b
        if node.op == "-":
            return a - b
        if node.op == "*":
            return a * b
        return cdiv(a, b)
    raise TypeError(f"unknown node {node!r}")


def eval_program(prog: Program, env: dict | None = None) -> tuple[int, int]:
    env = dict(env or {})
    counter = [0]
    result = None
    for stmt in prog.stmts:
        if isinstance(stmt, Assign):
            env[stmt.name] = eval_expr(stmt.value, env, counter)
        elif isinstance(stmt, ExprStmt):
            result = eval_expr(stmt.expr, env, counter)
    return (0 if result is None else result), counter[0]


# ---------------------------------------------------------------- stage 5: passes
def apply_bin(op: str, a: int, b: int) -> int:
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    if op == "*":
        return a * b
    if op == "/":
        return cdiv(a, b)
    raise ValueError(op)


def fold_node(node):
    if isinstance(node, IntLit) or isinstance(node, Var):
        return node, False
    if isinstance(node, Unary):
        operand, changed = fold_node(node.operand)
        node = Unary(node.op, operand, node.line, node.col)
        if isinstance(operand, IntLit):
            return IntLit(-operand.value, node.line, node.col), True
        return node, changed
    if isinstance(node, Binary):
        left, cl = fold_node(node.left)
        right, cr = fold_node(node.right)
        node = Binary(node.op, left, right, node.line, node.col)
        if isinstance(left, IntLit) and isinstance(right, IntLit):
            try:
                value = apply_bin(node.op, left.value, right.value)
            except ZeroDivisionError:
                return node, cl or cr
            return IntLit(value, node.line, node.col), True
        return node, cl or cr
    raise TypeError(f"unknown node {node!r}")


def fold_program(prog: Program):
    changed = False
    stmts = []
    for stmt in prog.stmts:
        if isinstance(stmt, Assign):
            value, ch = fold_node(stmt.value)
            stmts.append(Assign(stmt.name, value, stmt.line, stmt.col))
            changed = changed or ch
        elif isinstance(stmt, ExprStmt):
            expr, ch = fold_node(stmt.expr)
            stmts.append(ExprStmt(expr, stmt.line, stmt.col))
            changed = changed or ch
        else:
            stmts.append(stmt)
    return Program(tuple(stmts)), changed


def run_passes(prog: Program, passes, log: list):
    for name, fn in passes:
        rounds = 0
        while True:
            rounds += 1
            prog, changed = fn(prog)
            log.append((name, rounds, changed))
            if not changed:
                break
            if rounds >= 8:
                log.append((name, rounds, "budget-exhausted"))
                break
    return prog


# ---------------------------------------------------------------- reporting
def canonical(prog: Program, tokens: list[Token], code: list[Instr]) -> str:
    parts = ["TOKENS"]
    parts += [f"{t.kind}:{t.text}@{t.line}:{t.col}" for t in tokens]
    parts += ["AST", dump_ast(prog)]
    parts += ["CODE"]
    parts += [f"{ins.op}:{ins.arg}" for ins in code]
    return "\n".join(parts)


def print_tokens(tokens: list[Token]) -> None:
    print(" idx kind      text         pos")
    for i, tok in enumerate(tokens):
        text = repr(tok.text) if tok.text else "''"
        print(f" {i:3d} {tok.kind:<9} {text:<12} {tok.line}:{tok.col}")


def print_code(code: list[Instr]) -> None:
    for ip, ins in enumerate(code):
        arg = "" if ins.arg is None else str(ins.arg)
        print(f" {ip:04d} {ins.op:<8} {arg}")


def print_trace(trace, total_steps: int) -> None:
    for ip, ins, before, after, env in trace:
        arg = "" if ins.arg is None else str(ins.arg)
        envs = " ".join(f"{k}={v}" for k, v in sorted(env.items()))
        print(f" ip={ip:04d} {ins.op:<8} {arg:<6} {str(before):<10} => {str(after):<10} {envs}")
    if total_steps > len(trace):
        print(f" ... {total_steps - len(trace)} more step(s), use --trace-limit 0 to show all")


def demo(trace_limit: int, fold: bool) -> int:
    print("== 0. source ==")
    for line in SOURCE.splitlines():
        print(" " + line)
    tokens = lex(SOURCE)
    ast = Parser(tokens).parse()
    print(f"\n== 1. tokens ({len(tokens) - 1} real + EOF) ==")
    print_tokens(tokens)
    print("\n== 2. AST ==")
    print(dump_ast(ast))

    code = compile_program(ast)
    print(f"\n== 3. stack bytecode ({len(code)} instructions) ==")
    print_code(code)

    print("\n== 4. pass manager: const_fold ==")
    log: list = []
    if fold:
        folded = run_passes(ast, [("const_fold", fold_program)], log)
        for name, rounds, changed in log:
            print(f" run {name}#{rounds}: changed={changed}")
    else:
        folded = ast
        print(" passes disabled (--no-fold)")
    folded_code = compile_program(folded)
    print(f" instructions: {len(code)} -> {len(folded_code)}")
    print("\n after pass manager:")
    print_code(folded_code)

    print(f"\n== 5. VM trace (first {trace_limit if trace_limit else 'all'} steps, folded code) ==")
    trace: list = []
    vm_value, steps, _ = run_vm(folded_code, trace=trace, trace_limit=trace_limit)
    print_trace(trace, steps)

    tree_value, nodes = eval_program(ast)
    vm_plain, plain_steps, _ = run_vm(code)
    print("\n== 6. compare ==")
    print(f" tree eval        = {tree_value}   (AST nodes visited: {nodes})")
    print(f" vm, no pass      = {vm_plain}   (instructions executed: {plain_steps})")
    print(f" vm, const_fold   = {vm_value}   (instructions executed: {steps})")
    print(f" agree            = {tree_value == vm_plain == vm_value}")
    err, peak = verify_stack(code)
    print(f" stack verifier   = {'ok' if err is None else err} (max depth {peak})")
    return 0 if tree_value == vm_value == vm_plain else 1


# ---------------------------------------------------------------- selftest
BINOPS = ["+", "-", "*", "/"]


def gen_expr(rng: random.Random, depth: int) -> str:
    if depth <= 0 or rng.random() < 0.35:
        if rng.random() < 0.55:
            return str(rng.randint(0, 9))
        return rng.choice(["a", "b", "c"])
    left = gen_expr(rng, depth - 1)
    right = gen_expr(rng, depth - 1)
    return f"({left} {rng.choice(BINOPS)} {right})"


def selftest(count: int, seed: int, quiet: bool = False) -> int:
    rng = random.Random(seed)
    env = {"a": 2, "b": 5, "c": 7}
    agree = skipped = 0
    first_bad = None
    for i in range(count):
        expr = gen_expr(rng, 3) + ";"
        prog = Parser(lex(expr)).parse()
        code = compile_program(prog)
        err, _ = verify_stack(code)
        if err is not None:
            first_bad = (i, expr, "stack verifier", err)
            break
        try:
            expected, _ = eval_program(prog, env)
        except VMError:
            skipped += 1
            continue
        got, _, _ = run_vm(code, env)
        if expected != got:
            first_bad = (i, expr, expected, got)
            break
        agree += 1
    if first_bad is not None:
        print(f"FAIL at case {first_bad[0]}: {first_bad[1]}")
        print(f" tree/verifier={first_bad[2]!r} vm={first_bad[3]!r}")
        return 1
    if not quiet:
        print(f"selftest: seed={seed} cases={count} agree={agree} skipped_div0={skipped}")
    return 0


def buggy(trace_limit: int) -> int:
    print("== buggy codegen: right operand emitted first, VM pops left first ==")
    ast = Parser(lex(SOURCE)).parse()
    code = compile_program(ast, swap_operands=True)
    err, peak = verify_stack(code)
    print(f" stack verifier: {'ok' if err is None else err} (max depth {peak})")
    print(" bytecode for 'a = 3 * (4 + 5) - 7 / 2;':")
    print_code(code[:9])
    tree_value, _ = eval_program(ast)
    try:
        vm_value, steps, _ = run_vm(code)
    except VMError as exc:
        print(f" vm error: {exc}")
        return 1
    print(f" tree={tree_value} vm={vm_value} agree={tree_value == vm_value}")
    print(f" executed {steps} instructions")
    rng = random.Random(7)
    env = {"a": 2, "b": 5, "c": 7}
    for i in range(200):
        expr = gen_expr(rng, 2) + ";"
        prog = Parser(lex(expr)).parse()
        try:
            expected, _ = eval_program(prog, env)
            got, _, _ = run_vm(compile_program(prog, swap_operands=True), env)
        except VMError:
            continue
        if expected != got:
            print(f" first random mismatch #{i}: {expr}")
            print(f" tree={expected} vm={got}")
            break
    return 1


def fail_modes() -> int:
    try:
        lex("1 + @;")
    except FrontendError as exc:
        print(f" lex    -> {exc}")
    try:
        Parser(lex("3 +")).parse()
    except FrontendError as exc:
        print(f" parse  -> {exc}")
    bad = [Instr("CONST", 1), Instr("ADD"), Instr("HALT")]
    err, peak = verify_stack(bad)
    print(f" verify -> {err} (max depth {peak})")
    try:
        run_vm(bad)
    except VMError as exc:
        print(f" vm     -> {exc}")
    return 0


def undefined_demo() -> int:
    src = "b = a * a - 1;\n"
    print(f"source: {src.strip()}")
    ast = Parser(lex(src)).parse()
    code = compile_program(ast)
    print("bytecode emitted without a name-resolution pass:")
    print_code(code)
    err, peak = verify_stack(code)
    print(f"stack verifier: {'ok' if err is None else err} (max depth {peak})")
    try:
        run_vm(code)
    except VMError as exc:
        print(f"runtime: {exc}")
    defined: set[str] = set()
    problems: list[tuple[int, int, str]] = []

    def use(node) -> None:
        if isinstance(node, Var):
            if node.name not in defined:
                problems.append((node.line, node.col, node.name))
        elif isinstance(node, Unary):
            use(node.operand)
        elif isinstance(node, Binary):
            use(node.left)
            use(node.right)

    for stmt in ast.stmts:
        if isinstance(stmt, Assign):
            use(stmt.value)
            defined.add(stmt.name)
        elif isinstance(stmt, ExprStmt):
            use(stmt.expr)
    if problems:
        line, col, name = problems[0]
        print(f"static check: undefined variable {name!r} at {line}:{col} (before codegen)")
    return 0


def hash_mode() -> int:
    tokens = lex(SOURCE)
    ast = Parser(tokens).parse()
    code = compile_program(ast)
    folded = run_passes(ast, [("const_fold", fold_program)], [])
    folded_code = compile_program(folded)
    digest = hashlib.sha256(canonical(ast, tokens, code).encode()).hexdigest()
    digest_folded = hashlib.sha256(canonical(folded, tokens, folded_code).encode()).hexdigest()
    print(f"sha256(ast+tokens+code)        = {digest}")
    print(f"sha256(folded_ast+tokens+code) = {digest_folded}")
    print(f"instructions: {len(code)} -> {len(folded_code)}")
    return 0


def cache_demo() -> int:
    def h(text: str) -> str:
        return hashlib.sha256(text.encode()).hexdigest()[:8]

    files = {"a.mc": "1 + 2;", "b.mc": "3 * 4;", "c.mc": "5 - 6;"}
    cache: dict[str, str] = {}
    bad_cache: set[str] = set()

    def build(label: str) -> None:
        for name, src in files.items():
            key = h(src)
            hit = key in cache
            if not hit:
                cache[key] = name
            bad_hit = name in bad_cache
            bad_cache.add(name)
            print(f" {label} {name}: content-key={'HIT ' if hit else 'MISS'} "
                  f"name-key={'HIT ' if bad_hit else 'MISS'} key={key}")

    print("== build #1 ==")
    build("#1")
    print("== build #2 (nothing changed) ==")
    build("#2")
    files["b.mc"] = "3 * 5;"
    print("== build #3 (b.mc edited: 3 * 4 -> 3 * 5) ==")
    build("#3")
    print("name-keyed cache reuses b.mc without looking at its content -> stale artifact")
    return 0


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description="minimal compiler pipeline tour")
    ap.add_argument("--no-fold", action="store_true", help="skip the const_fold pass")
    ap.add_argument("--trace-limit", type=int, default=10, help="0 = all steps")
    ap.add_argument("--selftest", action="store_true")
    ap.add_argument("--count", type=int, default=300)
    ap.add_argument("--seed", type=int, default=20240601)
    ap.add_argument("--buggy", action="store_true")
    ap.add_argument("--hash", action="store_true")
    ap.add_argument("--fail", action="store_true")
    ap.add_argument("--undefined", action="store_true")
    ap.add_argument("--cache", action="store_true")
    args = ap.parse_args(argv)
    if args.selftest:
        return selftest(args.count, args.seed)
    if args.buggy:
        return buggy(args.trace_limit)
    if args.hash:
        return hash_mode()
    if args.fail:
        return fail_modes()
    if args.undefined:
        return undefined_demo()
    if args.cache:
        return cache_demo()
    return demo(args.trace_limit, not args.no_fold)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
