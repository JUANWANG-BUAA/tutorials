#!/usr/bin/env python3
"""Scope and symbol-table lab for chapter 3.

The lab parses a tiny block language, resolves every name against a stack of
lexical scopes, type-checks int/bool expressions, and prints snapshots of the
symbol table plus diagnostics with source spans.

Usage:
    python3 scope_lab.py
    python3 scope_lab.py --leak-scope   # reproduce the agent bug: leave() does not pop
"""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass, field
from typing import Iterable


# ---------------------------------------------------------------------------
# Tokens, spans, AST
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Span:
    line: int
    col: int

    def __str__(self) -> str:
        return f"{self.line}:{self.col}"


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    span: Span


KEYWORDS = {"int", "bool", "true", "false", "print"}
SINGLE = set("{}();=+-*/<>")
TWO_CHAR = {"=="}


class LexError(Exception):
    def __init__(self, message: str, span: Span):
        super().__init__(message)
        self.span = span


def lex(source: str) -> list[Token]:
    tokens: list[Token] = []
    i = 0
    line = 1
    col = 1
    n = len(source)
    while i < n:
        ch = source[i]
        if ch == "\n":
            i += 1
            line += 1
            col = 1
            continue
        if ch in " \t\r":
            i += 1
            col += 1
            continue
        span = Span(line, col)
        if ch.isalpha() or ch == "_":
            start = i
            while i < n and (source[i].isalnum() or source[i] == "_"):
                i += 1
                col += 1
            text = source[start:i]
            kind = text if text in KEYWORDS else "ident"
            tokens.append(Token(kind, text, span))
            continue
        if ch.isdigit():
            start = i
            while i < n and source[i].isdigit():
                i += 1
                col += 1
            tokens.append(Token("intlit", source[start:i], span))
            continue
        two = source[i:i + 2]
        if two in TWO_CHAR:
            tokens.append(Token(two, two, span))
            i += 2
            col += 2
            continue
        if ch in SINGLE:
            tokens.append(Token(ch, ch, span))
            i += 1
            col += 1
            continue
        raise LexError(f"unexpected character {ch!r}", span)
    tokens.append(Token("eof", "", Span(line, col)))
    return tokens


@dataclass
class Expr:
    span: Span


@dataclass
class IntLit(Expr):
    value: int


@dataclass
class BoolLit(Expr):
    value: bool


@dataclass
class Var(Expr):
    name: str


@dataclass
class Bin(Expr):
    op: str
    left: Expr
    right: Expr


@dataclass
class Stmt:
    span: Span


@dataclass
class Decl(Stmt):
    name: str
    name_span: Span
    typ: str
    init: Expr


@dataclass
class Assign(Stmt):
    name: str
    name_span: Span
    value: Expr


@dataclass
class Print(Stmt):
    value: Expr


@dataclass
class Block(Stmt):
    body: list[Stmt]


class ParseError(Exception):
    def __init__(self, message: str, span: Span):
        super().__init__(message)
        self.span = span


class Parser:
    def __init__(self, tokens: list[Token]):
        self.tokens = tokens
        self.pos = 0

    def peek(self, offset: int = 0) -> Token:
        idx = min(self.pos + offset, len(self.tokens) - 1)
        return self.tokens[idx]

    def at(self, kind: str) -> bool:
        return self.peek().kind == kind

    def take(self, kind: str) -> Token:
        tok = self.peek()
        if tok.kind != kind:
            raise ParseError(f"expected {kind!r}, found {tok.text!r}", tok.span)
        self.pos += 1
        return tok

    def parse_program(self) -> list[Stmt]:
        stmts = []
        while not self.at("eof"):
            stmts.append(self.parse_stmt())
        return stmts

    def parse_stmt(self) -> Stmt:
        tok = self.peek()
        if tok.kind in ("int", "bool"):
            typ = self.take(tok.kind).text
            name = self.take("ident")
            self.take("=")
            init = self.parse_expr()
            self.take(";")
            return Decl(tok.span, name.text, name.span, typ, init)
        if tok.kind == "ident":
            name = self.take("ident")
            self.take("=")
            value = self.parse_expr()
            self.take(";")
            return Assign(tok.span, name.text, name.span, value)
        if tok.kind == "print":
            start = self.take("print")
            self.take("(")
            value = self.parse_expr()
            self.take(")")
            self.take(";")
            return Print(start.span, value)
        if tok.kind == "{":
            start = self.take("{")
            body = []
            while not self.at("}"):
                if self.at("eof"):
                    raise ParseError("unterminated block", self.peek().span)
                body.append(self.parse_stmt())
            self.take("}")
            return Block(start.span, body)
        raise ParseError(f"unexpected token {tok.text!r}", tok.span)

    def parse_expr(self) -> Expr:
        left = self.parse_add()
        while self.peek().kind in ("<", "=="):
            op = self.peek()
            self.pos += 1
            right = self.parse_add()
            left = Bin(op.span, op.text, left, right)
        return left

    def parse_add(self) -> Expr:
        left = self.parse_mul()
        while self.peek().kind in ("+", "-"):
            op = self.peek()
            self.pos += 1
            right = self.parse_mul()
            left = Bin(op.span, op.text, left, right)
        return left

    def parse_mul(self) -> Expr:
        left = self.parse_unary()
        while self.peek().kind in ("*", "/"):
            op = self.peek()
            self.pos += 1
            right = self.parse_unary()
            left = Bin(op.span, op.text, left, right)
        return left

    def parse_unary(self) -> Expr:
        if self.at("-"):
            op = self.take("-")
            return Bin(op.span, "-", IntLit(op.span, 0), self.parse_unary())
        return self.parse_primary()

    def parse_primary(self) -> Expr:
        tok = self.peek()
        if tok.kind == "intlit":
            self.pos += 1
            return IntLit(tok.span, int(tok.text))
        if tok.kind in ("true", "false"):
            self.pos += 1
            return BoolLit(tok.span, tok.kind == "true")
        if tok.kind == "ident":
            self.pos += 1
            return Var(tok.span, tok.text)
        if tok.kind == "(":
            self.pos += 1
            inner = self.parse_expr()
            self.take(")")
            return inner
        raise ParseError(f"expected expression, found {tok.text!r}", tok.span)


# ---------------------------------------------------------------------------
# Symbols, scopes, diagnostics
# ---------------------------------------------------------------------------

@dataclass
class Binding:
    ident: int
    name: str
    typ: str
    decl_span: Span
    scope_id: int
    uses: int = 0
    alive: bool = True


@dataclass
class Scope:
    ident: int
    span: Span
    bindings: dict[str, Binding] = field(default_factory=dict)
    exited: bool = False


@dataclass
class Diagnostic:
    code: str
    message: str
    span: Span
    note: tuple[Span, str] | None = None


class Checker:
    def __init__(self, source: str, leak_scope: bool = False):
        self.source = source
        self.lines = source.splitlines()
        self.leak_scope = leak_scope
        self.scopes: list[Scope] = []
        self.all_bindings: list[Binding] = []
        self.errors: list[Diagnostic] = []
        self.warnings: list[Diagnostic] = []
        self.trace: list[str] = []
        self.next_binding = 1
        self.next_scope = 1

    # -- scope stack ------------------------------------------------------
    def enter(self, span: Span, label: str = "block") -> None:
        scope = Scope(self.next_scope, span)
        self.next_scope += 1
        self.scopes.append(scope)
        self.trace.append(f"enter {label} @{span} depth={len(self.scopes)}")

    def leave(self, span: Span) -> None:
        if not self.scopes:
            raise AssertionError("leave() without a matching enter()")
        scope = self.scopes[-1]
        scope.exited = True
        for binding in scope.bindings.values():
            binding.alive = False
        if self.leak_scope:
            self.trace.append(f"BUG leave block @{span}: skipped pop, depth={len(self.scopes)}")
            return
        self.scopes.pop()
        self.trace.append(f"leave block @{span} depth={len(self.scopes)}")

    def declare(self, name: str, typ: str, span: Span) -> Binding | None:
        scope = self.scopes[-1]
        previous = scope.bindings.get(name)
        if previous is not None:
            self.trace.append(f"duplicate declare {name} @{span} (first #{previous.ident} @{previous.decl_span})")
            self.errors.append(Diagnostic(
                "E_DUP_DECL",
                f"redeclaration of {name!r} in the same scope",
                span,
                (previous.decl_span, f"previous declaration of {name!r} is here"),
            ))
            return None
        binding = Binding(self.next_binding, name, typ, span, scope.ident)
        self.next_binding += 1
        scope.bindings[name] = binding
        self.all_bindings.append(binding)
        self.trace.append(f"declare #{binding.ident} {name}:{typ} @{span}")
        return binding

    def resolve(self, name: str, span: Span) -> Binding | None:
        for scope in reversed(self.scopes):
            binding = scope.bindings.get(name)
            if binding is None:
                continue
            if scope.exited:
                self.warnings.append(Diagnostic(
                    "W_DEAD_BINDING",
                    f"{name!r} resolves to #{binding.ident} in an exited scope; "
                    "the name should not be visible here",
                    span,
                    (binding.decl_span, "binding was declared here"),
                ))
                self.trace.append(f"resolve {name} -> #{binding.ident} (DEAD, scope exited)")
            else:
                binding.uses += 1
                self.trace.append(f"resolve {name} -> #{binding.ident} ({binding.typ}) @{span}")
            return binding
        self.errors.append(Diagnostic("E_UNDECLARED", f"use of undeclared name {name!r}", span))
        self.trace.append(f"resolve {name} -> <none> @{span}")
        return None

    # -- snapshots --------------------------------------------------------
    def snapshot(self, label: str) -> None:
        parts = []
        for scope in self.scopes:
            entries = " ".join(
                f"{name}:#{b.ident}:{b.typ}@{b.decl_span}"
                + ("[dead]" if scope.exited else "")
                for name, b in scope.bindings.items()
            )
            parts.append(f"scope#{scope.ident}({entries or '-'})")
        print(f"[snap] {label} depth={len(self.scopes)} " + " | ".join(parts))

    # -- type checking ----------------------------------------------------
    def check_expr(self, expr: Expr) -> str:
        if isinstance(expr, IntLit):
            return "int"
        if isinstance(expr, BoolLit):
            return "bool"
        if isinstance(expr, Var):
            binding = self.resolve(expr.name, expr.span)
            return binding.typ if binding is not None else "error"
        if isinstance(expr, Bin):
            left = self.check_expr(expr.left)
            right = self.check_expr(expr.right)
            if expr.op in ("+", "-", "*", "/"):
                if left != "int" or right != "int":
                    self.errors.append(Diagnostic(
                        "E_TYPE_ARITH",
                        f"operator {expr.op!r} expects int operands, got {left} and {right}",
                        expr.span,
                    ))
                return "int"
            if expr.op in ("<", "=="):
                if left != right or left == "error":
                    self.errors.append(Diagnostic(
                        "E_TYPE_COMPARE",
                        f"operator {expr.op!r} expects operands of the same type, got {left} and {right}",
                        expr.span,
                    ))
                return "bool"
            raise AssertionError(expr.op)
        raise AssertionError(type(expr))

    def check_stmt(self, stmt: Stmt) -> None:
        if isinstance(stmt, Block):
            self.enter(stmt.span)
            for inner in stmt.body:
                self.check_stmt(inner)
            self.leave(stmt.span)
            self.snapshot(f"after block @{stmt.span}")
            return
        if isinstance(stmt, Decl):
            actual = self.check_expr(stmt.init)
            if actual != "error" and actual != stmt.typ:
                self.errors.append(Diagnostic(
                    "E_TYPE_DECL",
                    f"initializer of {stmt.name!r} has type {actual}, declared {stmt.typ}",
                    stmt.init.span,
                ))
            self.declare(stmt.name, stmt.typ, stmt.name_span)
            self.snapshot(f"after decl {stmt.name} @{stmt.name_span}")
            return
        if isinstance(stmt, Assign):
            binding = self.resolve(stmt.name, stmt.name_span)
            actual = self.check_expr(stmt.value)
            if binding is not None and actual != "error" and actual != binding.typ:
                self.errors.append(Diagnostic(
                    "E_TYPE_ASSIGN",
                    f"cannot assign {actual} to {binding.typ} variable {stmt.name!r}",
                    stmt.value.span,
                ))
            return
        if isinstance(stmt, Print):
            self.check_expr(stmt.value)
            return
        raise AssertionError(type(stmt))

    def run(self, program: list[Stmt]) -> None:
        self.enter(Span(1, 1), label="program")
        self.snapshot("entry")
        for stmt in program:
            self.check_stmt(stmt)
        self.leave(Span(len(self.lines), 1))
        self.snapshot("exit")

    def report(self) -> None:
        for diag in self.errors:
            print(f"error[{diag.code}] @{diag.span}: {diag.message}")
            self._caret(diag.span)
            if diag.note is not None:
                note_span, message = diag.note
                print(f"  note @{note_span}: {message}")
                self._caret(note_span, prefix="  ")
        for diag in self.warnings:
            print(f"warning[{diag.code}] @{diag.span}: {diag.message}")
            self._caret(diag.span)
            if diag.note is not None:
                note_span, message = diag.note
                print(f"  note @{note_span}: {message}")
                self._caret(note_span, prefix="  ")

    def _caret(self, span: Span, prefix: str = "") -> None:
        if not (1 <= span.line <= len(self.lines)):
            return
        text = self.lines[span.line - 1]
        print(f"{prefix}{span.line:>3} | {text}")
        print(f"{prefix}    | " + " " * (span.col - 1) + "^")

    def binding_table(self) -> None:
        print("bindings:")
        for b in self.all_bindings:
            print(
                f"  #{b.ident:<2d} {b.name:<4s} {b.typ:<4s} decl=@{b.decl_span} "
                f"scope={b.scope_id} alive={'yes' if b.alive else 'no'} uses={b.uses}"
            )


# ---------------------------------------------------------------------------
# Cases and driver
# ---------------------------------------------------------------------------

CASES: list[tuple[str, str]] = [
    (
        "nested shadowing",
        "int x = 1;\n"
        "{\n"
        "  bool x = true;\n"
        "  print(x);\n"
        "}\n"
        "print(x);\n",
    ),
    (
        "name leaves its block",
        "{\n"
        "  int y = 2;\n"
        "  print(y);\n"
        "}\n"
        "print(y);\n",
    ),
    (
        "duplicate declaration",
        "int z = 1;\n"
        "int z = 2;\n",
    ),
    (
        "declaration type mismatch",
        "int n = true;\n"
        "n = false;\n",
    ),
    (
        "inner assignment type mismatch",
        "int x = 1;\n"
        "{\n"
        "  bool x = true;\n"
        "  x = 1;\n"
        "}\n",
    ),
]


def show_source(source: str) -> None:
    print("source:")
    for number, line in enumerate(source.splitlines(), 1):
        print(f"{number:>3} | {line}")


def run_case(name: str, source: str, leak_scope: bool) -> None:
    print(f"=== case: {name} ===")
    if leak_scope:
        # The leak demo uses a block whose name is used after the block.
        source = "{\n  int y = 2;\n  print(y);\n}\nprint(y);\n"
    show_source(source)
    try:
        tokens = lex(source)
        program = Parser(tokens).parse_program()
    except (LexError, ParseError) as exc:
        print(f"parse error @{exc.span}: {exc}")
        print()
        return
    checker = Checker(source, leak_scope=leak_scope)
    checker.run(program)
    print("trace:")
    for line in checker.trace:
        print("  " + line)
    print(f"diagnostics: {len(checker.errors)} error(s), {len(checker.warnings)} warning(s)")
    checker.report()
    checker.binding_table()
    print()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--leak-scope", action="store_true",
                        help="reproduce the agent bug: leave() marks the scope exited but never pops it")
    args = parser.parse_args()
    print("scope_lab: stack of lexical scopes, binding ids, typed names")
    print(f"mode: {'leak-scope (buggy)' if args.leak_scope else 'normal'}")
    print()
    if args.leak_scope:
        run_case("agent bug: block exit does not pop", "", True)
    else:
        for name, source in CASES:
            run_case(name, source, False)
    print("summary: shadowing creates a new binding; leaving a block removes every binding it declared")
    return 0


if __name__ == "__main__":
    sys.exit(main())
