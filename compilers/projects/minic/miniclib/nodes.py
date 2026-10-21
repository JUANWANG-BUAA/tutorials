"""AST node definitions for minic.

Expressions and statements are plain dataclasses.  The parser produces them,
sema annotates variable nodes with resolved Symbol objects, and every later
stage reads the annotations instead of doing its own name lookup.
"""

from __future__ import annotations

from dataclasses import dataclass, field

from .errors import Span


@dataclass
class Symbol:
    name: str
    uid: int
    kind: str  # "param" | "local"
    span: Span

    @property
    def tac_name(self) -> str:
        return f"{self.name}.{self.uid}"


@dataclass
class Expr:
    span: Span


@dataclass
class IntLit(Expr):
    value: int


@dataclass
class Var(Expr):
    name: str
    sym: Symbol | None = None


@dataclass
class Unary(Expr):
    op: str
    operand: Expr


@dataclass
class Binary(Expr):
    op: str
    left: Expr
    right: Expr


@dataclass
class Call(Expr):
    name: str
    args: list[Expr] = field(default_factory=list)


@dataclass
class Stmt:
    span: Span


@dataclass
class Block(Stmt):
    stmts: list[Stmt] = field(default_factory=list)


@dataclass
class Decl(Stmt):
    name: str
    init: Expr | None = None
    sym: Symbol | None = None


@dataclass
class Assign(Stmt):
    name: str
    value: Expr | None = None
    sym: Symbol | None = None


@dataclass
class ExprStmt(Stmt):
    expr: Expr | None = None


@dataclass
class If(Stmt):
    cond: Expr | None = None
    then: Stmt | None = None
    otherwise: Stmt | None = None


@dataclass
class While(Stmt):
    cond: Expr | None = None
    body: Stmt | None = None


@dataclass
class Return(Stmt):
    value: Expr | None = None


@dataclass
class Print(Stmt):
    value: Expr | None = None


@dataclass
class Function:
    name: str
    params: list[str]
    body: Block
    span: Span
    param_syms: list[Symbol] = field(default_factory=list)


@dataclass
class Program:
    functions: list[Function]
    span: Span


BIN_PREC = {
    "||": 1,
    "&&": 2,
    "==": 3, "!=": 3,
    "<": 4, "<=": 4, ">": 4, ">=": 4,
    "+": 5, "-": 5,
    "*": 6, "/": 6, "%": 6,
}
UNARY_PREC = 7


def dump_ast(program: Program) -> str:
    out: list[str] = []
    for fn in program.functions:
        params = ", ".join(fn.params)
        out.append(f"fn {fn.name}({params}) {{")
        _dump_stmt(fn.body, out, 1)
        out.append("}")
    return "\n".join(out)


def _dump_stmt(stmt: Stmt, out: list[str], depth: int) -> None:
    pad = "  " * depth
    if isinstance(stmt, Block):
        out.append(f"{pad}block")
        for s in stmt.stmts:
            _dump_stmt(s, out, depth + 1)
    elif isinstance(stmt, Decl):
        text = f"{pad}decl {stmt.name}"
        if stmt.init is not None:
            text += " = " + _expr(stmt.init)
        out.append(text)
    elif isinstance(stmt, Assign):
        out.append(f"{pad}assign {stmt.name} = {_expr(stmt.value)}")
    elif isinstance(stmt, ExprStmt):
        out.append(f"{pad}expr {_expr(stmt.expr)}")
    elif isinstance(stmt, If):
        out.append(f"{pad}if ({_expr(stmt.cond)})")
        _dump_stmt(stmt.then, out, depth + 1)
        if stmt.otherwise is not None:
            out.append(f"{pad}else")
            _dump_stmt(stmt.otherwise, out, depth + 1)
    elif isinstance(stmt, While):
        out.append(f"{pad}while ({_expr(stmt.cond)})")
        _dump_stmt(stmt.body, out, depth + 1)
    elif isinstance(stmt, Return):
        out.append(f"{pad}return {_expr(stmt.value)}")
    elif isinstance(stmt, Print):
        out.append(f"{pad}print {_expr(stmt.value)}")
    else:  # pragma: no cover - defensive
        raise TypeError(f"unknown statement {stmt!r}")


def _expr(expr: Expr) -> str:
    if isinstance(expr, IntLit):
        return str(expr.value)
    if isinstance(expr, Var):
        return expr.name
    if isinstance(expr, Unary):
        return f"({expr.op}{_expr(expr.operand)})"
    if isinstance(expr, Binary):
        return f"({_expr(expr.left)} {expr.op} {_expr(expr.right)})"
    if isinstance(expr, Call):
        args = ", ".join(_expr(a) for a in expr.args)
        return f"{expr.name}({args})"
    raise TypeError(f"unknown expression {expr!r}")
