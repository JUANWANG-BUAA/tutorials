#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""IMP 的最弱前置条件（WP）、验证条件（VC）与有界反例搜索。

只依赖 Python 3.11+ 标准库。没有 SMT 求解器：先做常量折叠与布尔化简，
再在有限整数域上枚举，找 VC 的反例。有限域通过不等于全称证明。

用法：
    python3 proof_lab.py                 # 证明带循环的求和程序
    python3 proof_lab.py --demo parity   # 步长 2 的循环，给出反例
    python3 proof_lab.py --demo vacuous --buggy
    python3 proof_lab.py --demo vacuous
"""

from __future__ import annotations

import argparse
import itertools
import re
import sys
from dataclasses import dataclass
from typing import Iterable


# ---------------------------------------------------------------- 表达式

class Expr:
    pass


@dataclass(frozen=True)
class Const(Expr):
    value: int
    label: str | None = None


@dataclass(frozen=True)
class Var(Expr):
    name: str


@dataclass(frozen=True)
class Un(Expr):
    op: str
    a: Expr


@dataclass(frozen=True)
class Bin(Expr):
    op: str
    a: Expr
    b: Expr


TRUE = Const(1, "true")
FALSE = Const(0, "false")


def is_const(e: Expr) -> bool:
    return isinstance(e, Const)


def truth(e: Expr) -> int:
    assert isinstance(e, Const)
    return e.value


def mk_not(a: Expr) -> Expr:
    a = simplify(a)
    if is_const(a):
        return FALSE if a.value != 0 else TRUE
    if isinstance(a, Un) and a.op == "!":
        return a.a
    return Un("!", a)


def flatten(op: str, parts: Iterable[Expr]) -> list[Expr]:
    out: list[Expr] = []
    for p in parts:
        if isinstance(p, Bin) and p.op == op:
            out.extend(flatten(op, [p.a, p.b]))
        else:
            out.append(p)
    return out


def mk_and(parts: Iterable[Expr]) -> Expr:
    flat = flatten("&&", [simplify(p) for p in parts])
    if any(is_const(p) and p.value == 0 for p in flat):
        return FALSE
    seen: set[str] = set()
    keep: list[Expr] = []
    for p in flat:
        if is_const(p) and p.value != 0:
            continue
        key = render(p)
        if key not in seen:
            seen.add(key)
            keep.append(p)
    if not keep:
        return TRUE
    out = keep[0]
    for p in keep[1:]:
        out = Bin("&&", out, p)
    return out


def mk_or(parts: Iterable[Expr]) -> Expr:
    flat = flatten("||", [simplify(p) for p in parts])
    if any(is_const(p) and p.value != 0 for p in flat):
        return TRUE
    seen: set[str] = set()
    keep: list[Expr] = []
    for p in flat:
        if is_const(p) and p.value == 0:
            continue
        key = render(p)
        if key not in seen:
            seen.add(key)
            keep.append(p)
    if not keep:
        return FALSE
    out = keep[0]
    for p in keep[1:]:
        out = Bin("||", out, p)
    return out


def mk_implies(a: Expr, b: Expr) -> Expr:
    return mk_or([mk_not(a), b])


# ---------------------------------------------------------------- 化简

def eval_bin(op: str, a: int, b: int) -> int:
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    if op == "*":
        return a * b
    if op == "%":
        if b == 0:
            raise ZeroDivisionError("modulo by zero")
        return a % b
    if op == "==":
        return 1 if a == b else 0
    if op == "!=":
        return 1 if a != b else 0
    if op == "<":
        return 1 if a < b else 0
    if op == "<=":
        return 1 if a <= b else 0
    if op == ">":
        return 1 if a > b else 0
    if op == ">=":
        return 1 if a >= b else 0
    if op == "&&":
        return 1 if (a != 0 and b != 0) else 0
    if op == "||":
        return 1 if (a != 0 or b != 0) else 0
    raise ValueError(f"unknown operator {op}")


def simplify(e: Expr) -> Expr:
    if isinstance(e, (Const, Var)):
        return e
    if isinstance(e, Un):
        a = simplify(e.a)
        if e.op == "!":
            if is_const(a):
                return FALSE if a.value != 0 else TRUE
            if isinstance(a, Un) and a.op == "!":
                return a.a
            return Un("!", a)
        if e.op == "-":
            if is_const(a):
                return Const(-a.value)
            if isinstance(a, Un) and a.op == "-":
                return a.a
            return Un("-", a)
        raise ValueError(e.op)
    if isinstance(e, Bin):
        op = e.op
        a = simplify(e.a)
        b = simplify(e.b)
        if op == "&&":
            if (is_const(a) and a.value == 0) or (is_const(b) and b.value == 0):
                return FALSE
            if is_const(a) and a.value != 0:
                return b
            if is_const(b) and b.value != 0:
                return a
            if render(a) == render(b):
                return a
            return mk_and([a, b])
        if op == "||":
            if (is_const(a) and a.value != 0) or (is_const(b) and b.value != 0):
                return TRUE
            if is_const(a) and a.value == 0:
                return b
            if is_const(b) and b.value == 0:
                return a
            if render(a) == render(b):
                return a
            return mk_or([a, b])
        if is_const(a) and is_const(b):
            return Const(eval_bin(op, a.value, b.value))
        # 单位元与零元
        if op == "+":
            if is_const(a) and a.value == 0:
                return b
            if is_const(b) and b.value == 0:
                return a
        if op == "-":
            if is_const(b) and b.value == 0:
                return a
            if is_const(a) and a.value == 0:
                return simplify(Un("-", b))
        if op == "*":
            if (is_const(a) and a.value == 0) or (is_const(b) and b.value == 0):
                return FALSE
            if is_const(a) and a.value == 1:
                return b
            if is_const(b) and b.value == 1:
                return a
            if is_const(a) and a.value == -1:
                return simplify(Un("-", b))
            if is_const(b) and b.value == -1:
                return simplify(Un("-", a))
        if op in ("==", "!=", "<", "<=", ">", ">="):
            if render(a) == render(b):
                return TRUE if op in ("==", "<=", ">=") else FALSE
            # 常量移到同一侧太复杂；留给有界枚举。
        if op == "%" and is_const(b) and b.value == 1:
            return FALSE
        return Bin(op, a, b)
    raise TypeError(type(e))


# 优先级：数值越小绑定越松
PREC = {"||": 1, "&&": 2, "==": 3, "!=": 3, "<": 3, "<=": 3, ">": 3, ">=": 3,
        "+": 4, "-": 4, "*": 5, "%": 5}


def render(e: Expr, parent: int = 0) -> str:
    if isinstance(e, Const):
        return e.label if e.label is not None else str(e.value)
    if isinstance(e, Var):
        return e.name
    if isinstance(e, Un):
        s = ("!" if e.op == "!" else "-") + render(e.a, 6)
        out = s
        return f"({out})" if PREC.get(e.op, 6) < parent else out
    if isinstance(e, Bin):
        p = PREC[e.op]
        s = f"{render(e.a, p)} {e.op} {render(e.b, p + 1)}"
        return f"({s})" if p < parent else s
    raise TypeError(type(e))


# ---------------------------------------------------------------- 替换与 WP

def subst(e: Expr, name: str, value: Expr) -> Expr:
    if isinstance(e, Var):
        return value if e.name == name else e
    if isinstance(e, Const):
        return e
    if isinstance(e, Un):
        return Un(e.op, subst(e.a, name, value))
    if isinstance(e, Bin):
        return Bin(e.op, subst(e.a, name, value), subst(e.b, name, value))
    raise TypeError(type(e))


@dataclass(frozen=True)
class VC:
    kind: str          # entry / preserve / exit
    expr: Expr
    loop_id: int | None = None


# ---------------------------------------------------------------- 语句

class Stmt:
    pass


@dataclass(frozen=True)
class Assign(Stmt):
    name: str
    expr: Expr


@dataclass(frozen=True)
class Assert(Stmt):
    cond: Expr


@dataclass(frozen=True)
class Assume(Stmt):
    cond: Expr


@dataclass(frozen=True)
class Skip(Stmt):
    pass


@dataclass(frozen=True)
class If(Stmt):
    cond: Expr
    then_body: tuple[Stmt, ...]
    else_body: tuple[Stmt, ...]


@dataclass(frozen=True)
class While(Stmt):
    cond: Expr
    inv: Expr
    body: tuple[Stmt, ...]
    loop_id: int


# ---------------------------------------------------------------- 解析

TOKEN_RE = re.compile(
    r"(?P<ws>\s+)"
    r"|(?P<comment>\#[^\n]*)"
    r"|(?P<num>\d+)"
    r"|(?P<id>[A-Za-z_]\w*)"
    r"|(?P<op>==|!=|<=|>=|&&|\|\||[+\-*/%(){};=!<>])"
)


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    pos: int


def lex(text: str) -> list[Token]:
    out: list[Token] = []
    i = 0
    while i < len(text):
        m = TOKEN_RE.match(text, i)
        if not m:
            raise SyntaxError(f"无法识别的字符 {text[i]!r}（位置 {i}）")
        i = m.end()
        kind = m.lastgroup
        if kind in ("ws", "comment"):
            continue
        out.append(Token(kind or "", m.group(), m.start()))
    out.append(Token("eof", "<eof>", len(text)))
    return out


class Parser:
    def __init__(self, text: str):
        self.tokens = lex(text)
        self.i = 0
        self.loop_seq = 0

    def peek(self) -> Token:
        return self.tokens[self.i]

    def take(self, text: str | None = None) -> Token:
        tok = self.peek()
        if text is not None and tok.text != text:
            raise SyntaxError(f"期望 {text!r}，得到 {tok.text!r}（位置 {tok.pos}）")
        self.i += 1
        return tok

    def accept(self, text: str) -> bool:
        if self.peek().text == text:
            self.i += 1
            return True
        return False

    def parse_program(self) -> list[Stmt]:
        body: list[Stmt] = []
        while self.peek().kind != "eof":
            body.append(self.parse_stmt())
        return body

    def parse_block(self) -> tuple[Stmt, ...]:
        self.take("{")
        body: list[Stmt] = []
        while not self.accept("}"):
            if self.peek().kind == "eof":
                raise SyntaxError("块未闭合")
            body.append(self.parse_stmt())
        return tuple(body)

    def parse_stmt(self) -> Stmt:
        tok = self.peek()
        if tok.text == "if":
            self.take()
            self.take("(")
            cond = self.parse_expr()
            self.take(")")
            then_body = self.parse_block()
            else_body: tuple[Stmt, ...] = ()
            if self.accept("else"):
                else_body = self.parse_block()
            return If(cond, then_body, else_body)
        if tok.text == "while":
            self.take()
            self.take("(")
            cond = self.parse_expr()
            self.take(")")
            if not self.accept("invariant"):
                raise SyntaxError("while 需要 invariant (...) 注解")
            self.take("(")
            inv = self.parse_expr()
            self.take(")")
            self.loop_seq += 1
            loop_id = self.loop_seq
            body = self.parse_block()
            return While(cond, inv, body, loop_id)
        if tok.text == "assert":
            self.take()
            self.take("(")
            cond = self.parse_expr()
            self.take(")")
            self.take(";")
            return Assert(cond)
        if tok.text == "assume":
            self.take()
            self.take("(")
            cond = self.parse_expr()
            self.take(")")
            self.take(";")
            return Assume(cond)
        if tok.text == "skip":
            self.take()
            self.take(";")
            return Skip()
        if tok.kind == "id":
            name = self.take().text
            self.take("=")
            expr = self.parse_expr()
            self.take(";")
            return Assign(name, expr)
        raise SyntaxError(f"无法解析语句 {tok.text!r}（位置 {tok.pos}）")

    def parse_expr(self) -> Expr:
        return self.parse_or()

    def parse_or(self) -> Expr:
        e = self.parse_and()
        while self.accept("||"):
            e = Bin("||", e, self.parse_and())
        return e

    def parse_and(self) -> Expr:
        e = self.parse_cmp()
        while self.accept("&&"):
            e = Bin("&&", e, self.parse_cmp())
        return e

    def parse_cmp(self) -> Expr:
        e = self.parse_add()
        if self.peek().text in ("==", "!=", "<", "<=", ">", ">="):
            op = self.take().text
            return Bin(op, e, self.parse_add())
        return e

    def parse_add(self) -> Expr:
        e = self.parse_mul()
        while self.peek().text in ("+", "-"):
            op = self.take().text
            e = Bin(op, e, self.parse_mul())
        return e

    def parse_mul(self) -> Expr:
        e = self.parse_unary()
        while self.peek().text in ("*", "%"):
            op = self.take().text
            e = Bin(op, e, self.parse_unary())
        return e

    def parse_unary(self) -> Expr:
        if self.accept("!"):
            return Un("!", self.parse_unary())
        if self.accept("-"):
            return Un("-", self.parse_unary())
        return self.parse_primary()

    def parse_primary(self) -> Expr:
        tok = self.peek()
        if tok.kind == "num":
            self.take()
            return Const(int(tok.text))
        if tok.kind == "id":
            self.take()
            if tok.text == "true":
                return TRUE
            if tok.text == "false":
                return FALSE
            return Var(tok.text)
        if self.accept("("):
            e = self.parse_expr()
            self.take(")")
            return e
        raise SyntaxError(f"期望表达式，得到 {tok.text!r}（位置 {tok.pos}）")


# ---------------------------------------------------------------- WP 与 VC

def wp_stmt(st: Stmt, post: Expr, vcs: list[VC]) -> Expr:
    if isinstance(st, Assign):
        return subst(post, st.name, st.expr)
    if isinstance(st, Assert):
        return mk_and([st.cond, post])
    if isinstance(st, Assume):
        return mk_implies(st.cond, post)
    if isinstance(st, Skip):
        return post
    if isinstance(st, If):
        t = wp_stmts(st.then_body, post, vcs)
        e = wp_stmts(st.else_body, post, vcs)
        return mk_and([mk_implies(st.cond, t), mk_implies(mk_not(st.cond), e)])
    if isinstance(st, While):
        inv = st.inv
        body_wp = wp_stmts(st.body, inv, vcs)
        vcs.append(VC("preserve", mk_implies(mk_and([inv, st.cond]), body_wp), st.loop_id))
        vcs.append(VC("exit", mk_implies(mk_and([inv, mk_not(st.cond)]), post), st.loop_id))
        return inv
    raise TypeError(type(st))


def wp_stmts(body: tuple[Stmt, ...] | list[Stmt], post: Expr,
             vcs: list[VC]) -> Expr:
    cur = post
    for st in reversed(body):
        cur = wp_stmt(st, cur, vcs)
    return cur


# ---------------------------------------------------------------- 求值

def free_vars(e: Expr) -> set[str]:
    if isinstance(e, Var):
        return {e.name}
    if isinstance(e, Const):
        return set()
    if isinstance(e, Un):
        return free_vars(e.a)
    if isinstance(e, Bin):
        return free_vars(e.a) | free_vars(e.b)
    raise TypeError(type(e))


def ev(e: Expr, env: dict[str, int]) -> int:
    if isinstance(e, Const):
        return e.value
    if isinstance(e, Var):
        return env[e.name]
    if isinstance(e, Un):
        a = ev(e.a, env)
        return (0 if a != 0 else 1) if e.op == "!" else -a
    if isinstance(e, Bin):
        if e.op == "&&":
            return 1 if (ev(e.a, env) != 0 and ev(e.b, env) != 0) else 0
        if e.op == "||":
            return 1 if (ev(e.a, env) != 0 or ev(e.b, env) != 0) else 0
        return eval_bin(e.op, ev(e.a, env), ev(e.b, env))
    raise TypeError(type(e))


@dataclass
class CheckResult:
    status: str                  # valid / invalid / unknown
    counterexample: dict[str, int] | None
    checked: int


def check_bounded(e: Expr, lo: int, hi: int, max_vars: int = 3) -> CheckResult:
    e = simplify(e)
    if isinstance(e, Const):
        if e.value != 0:
            return CheckResult("valid", None, 0)
        return CheckResult("invalid", {}, 0)
    names = sorted(free_vars(e))
    if len(names) > max_vars:
        return CheckResult("unknown", None, 0)
    values = range(lo, hi + 1)
    checked = 0
    for combo in itertools.product(values, repeat=len(names)):
        env = dict(zip(names, combo))
        checked += 1
        if ev(e, env) == 0:
            return CheckResult("invalid", env, checked)
    return CheckResult("valid-in-domain", None, checked)


# ---------------------------------------------------------------- 演示程序

SUM_PROGRAM = r"""
i = 0;
s = 0;
while (i < n) invariant (s == i * n && 0 <= i && i <= n) {
  i = i + 1;
  s = s + n;
}
assert (s == n * n);
"""

PARITY_PROGRAM = r"""
i = 0;
while (i < n) invariant (0 <= i && i <= n) {
  i = i + 2;
}
assert (i == n);
"""

VACUOUS_PROGRAM = r"""
i = 0;
while (i < n) invariant (false) {
  i = i + 1;
}
assert (i == 42);
"""


def demo(name: str) -> tuple[str, str, str]:
    if name == "sum":
        return SUM_PROGRAM, "n >= 0", "s == n * n"
    if name == "parity":
        return PARITY_PROGRAM, "n >= 0", "i == n"
    if name == "vacuous":
        return VACUOUS_PROGRAM, "true", "i == 42"
    raise ValueError(name)


def print_program(body: list[Stmt]) -> None:
    for st in body:
        print_stmt(st, 0)


def print_stmt(st: Stmt, indent: int) -> None:
    pad = "  " * indent
    if isinstance(st, Assign):
        print(f"{pad}{st.name} = {render(st.expr)};")
    elif isinstance(st, Assert):
        print(f"{pad}assert ({render(st.cond)});")
    elif isinstance(st, Assume):
        print(f"{pad}assume ({render(st.cond)});")
    elif isinstance(st, Skip):
        print(f"{pad}skip;")
    elif isinstance(st, If):
        print(f"{pad}if ({render(st.cond)}) {{")
        for s in st.then_body:
            print_stmt(s, indent + 1)
        print(f"{pad}}}")
        if st.else_body:
            print(f"{pad}else {{")
            for s in st.else_body:
                print_stmt(s, indent + 1)
            print(f"{pad}}}")
    elif isinstance(st, While):
        print(f"{pad}while ({render(st.cond)}) invariant ({render(st.inv)}) {{")
        for s in st.body:
            print_stmt(s, indent + 1)
        print(f"{pad}}}")


def vc_name(v: VC) -> str:
    return v.kind if v.loop_id is None else f"{v.kind}@{v.loop_id}"


def main() -> int:
    ap = argparse.ArgumentParser(description="IMP WP / VC 有界检查器")
    ap.add_argument("--demo", choices=["sum", "parity", "vacuous"], default="sum")
    ap.add_argument("--file", help="从文件读 IMP 程序（覆盖 --demo 的程序）")
    ap.add_argument("--pre", help="前置条件表达式（覆盖演示默认）")
    ap.add_argument("--post", help="后置条件表达式（覆盖演示默认）")
    ap.add_argument("--buggy", action="store_true",
                    help="复现 agent 错误：只发循环的 preserve/exit，漏掉 entry")
    ap.add_argument("--lo", type=int, default=-4)
    ap.add_argument("--hi", type=int, default=64)
    ap.add_argument("--max-vars", type=int, default=3)
    args = ap.parse_args()

    text, pre_text, post_text = demo(args.demo)
    if args.file:
        text = open(args.file, encoding="utf-8").read()
    if args.pre is not None:
        pre_text = args.pre
    if args.post is not None:
        post_text = args.post

    try:
        body = Parser(text).parse_program()
        pre = simplify(Parser(pre_text).parse_expr())
        post = simplify(Parser(post_text).parse_expr())
    except SyntaxError as e:
        print(f"parse error: {e}", file=sys.stderr)
        return 2

    print("== IMP program ==")
    print_program(body)
    print()
    print(f"pre : {render(pre)}")
    print(f"post: {render(post)}")
    print()

    vcs: list[VC] = []
    body_wp = wp_stmts(body, post, vcs)
    if not args.buggy:
        vcs.append(VC("entry", mk_implies(pre, body_wp), None))
        # entry 放最前面，便于对照
        vcs.sort(key=lambda v: (0 if v.kind == "entry" else 1, v.loop_id or 0, v.kind))
    else:
        vcs.sort(key=lambda v: (v.loop_id or 0, v.kind))

    print(f"== verification conditions ({len(vcs)}) ==")
    if args.buggy:
        print("[entry] OMITTED by --buggy")
    rendered: list[tuple[VC, Expr]] = []
    for v in vcs:
        e = simplify(v.expr)
        rendered.append((v, e))
        print(f"[{vc_name(v)}] {render(e)}")
    print()

    print(f"== bounded check: D = [{args.lo}, {args.hi}], max_vars={args.max_vars} ==")
    bad: list[tuple[str, dict[str, int]]] = []
    unknown = 0
    for v, e in rendered:
        name = vc_name(v)
        r = check_bounded(e, args.lo, args.hi, args.max_vars)
        if r.status == "invalid":
            assert r.counterexample is not None
            if r.counterexample:
                ce = ", ".join(f"{k}={r.counterexample[k]}" for k in sorted(r.counterexample))
            else:
                ce = "{}"
            print(f"[{name}] INVALID  counterexample: {ce}")
            bad.append((name, r.counterexample))
        elif r.status == "unknown":
            unknown += 1
            print(f"[{name}] UNKNOWN  ({len(free_vars(e))} free vars > max_vars)")
        elif r.status == "valid":
            print(f"[{name}] valid by simplification")
        else:
            print(f"[{name}] no counterexample ({r.checked} assignments)")
    print()

    if args.buggy:
        print("RESULT: CLAIMED-PROVED (unsound: entry VC omitted by --buggy)")
        return 0
    if bad:
        print(f"RESULT: FAIL ({len(bad)} invalid VC(s))")
        return 1
    if unknown:
        print(f"RESULT: UNKNOWN ({unknown} VC(s) beyond enumeration budget)")
        return 0
    print("RESULT: NO-COUNTEREXAMPLE-IN-DOMAIN")
    print("note: bounded enumeration is a test, not an unbounded proof.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
