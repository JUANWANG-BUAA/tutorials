"""Semantic analysis: function table, scopes, symbol resolution, checks.

The subset has exactly one type (32-bit int), so type checking is small; most
of this pass is name resolution, arity checking and the structural
"every non-main function returns on every path" check.
"""

from __future__ import annotations

from dataclasses import dataclass

from .errors import MiniError
from .nodes import (
    Assign, Binary, Block, Call, Decl, Expr, ExprStmt, Function, If, IntLit,
    Print, Program, Return, Stmt, Symbol, Unary, Var, While,
)

MAX_PARAMS = 6


@dataclass
class FuncInfo:
    name: str
    arity: int
    node: Function


class Sema:
    def __init__(self, program: Program):
        self.program = program
        self.funcs: dict[str, FuncInfo] = {}
        self.scopes: list[dict[str, Symbol]] = []
        self.uid = 0
        self.current: Function | None = None

    # -- entry -------------------------------------------------------------
    def check(self) -> Program:
        self.collect_functions()
        if "main" not in self.funcs:
            raise MiniError("missing entry point 'int main()'", self.program.span)
        main = self.funcs["main"]
        if main.arity != 0:
            raise MiniError("main must take no parameters", main.node.span)
        for fn in self.program.functions:
            self.check_function(fn)
        return self.program

    def collect_functions(self) -> None:
        for fn in self.program.functions:
            if fn.name == "print":
                raise MiniError("'print' is a statement keyword, not a function", fn.span)
            if fn.name in self.funcs:
                raise MiniError(f"duplicate function '{fn.name}'", fn.span)
            if len(fn.params) > MAX_PARAMS:
                raise MiniError(
                    f"function '{fn.name}' has {len(fn.params)} parameters; minic supports at most {MAX_PARAMS}",
                    fn.span,
                )
            seen = set()
            for p in fn.params:
                if p in seen:
                    raise MiniError(f"duplicate parameter '{p}' in function '{fn.name}'", fn.span)
                seen.add(p)
            self.funcs[fn.name] = FuncInfo(fn.name, len(fn.params), fn)

    # -- scopes ------------------------------------------------------------
    def push(self) -> None:
        self.scopes.append({})

    def pop(self) -> None:
        self.scopes.pop()

    def declare(self, name: str, span, kind: str = "local") -> Symbol:
        if not self.scopes:
            raise MiniError("internal: no scope", span)
        if name in self.scopes[-1]:
            raise MiniError(f"duplicate declaration of '{name}' in this scope", span)
        self.uid += 1
        sym = Symbol(name, self.uid, kind, span)
        self.scopes[-1][name] = sym
        return sym

    def lookup(self, name: str, span) -> Symbol:
        for scope in reversed(self.scopes):
            if name in scope:
                return scope[name]
        raise MiniError(f"undeclared variable '{name}'", span)

    # -- functions and statements -----------------------------------------
    def check_function(self, fn: Function) -> None:
        self.current = fn
        self.uid = 0
        self.scopes = []
        self.push()
        fn.param_syms = [self.declare(p, fn.span, "param") for p in fn.params]
        self.check_block(fn.body, new_scope=False)
        if fn.name != "main" and not definitely_returns(fn.body):
            raise MiniError(
                f"function '{fn.name}' may reach the end without returning a value",
                fn.span,
            )
        self.pop()

    def check_block(self, block: Block, new_scope: bool = True) -> None:
        if new_scope:
            self.push()
        for stmt in block.stmts:
            self.check_stmt(stmt)
        if new_scope:
            self.pop()

    def check_stmt(self, stmt: Stmt) -> None:
        if isinstance(stmt, Block):
            self.check_block(stmt)
        elif isinstance(stmt, Decl):
            sym = self.declare(stmt.name, stmt.span)
            stmt.sym = sym
            if stmt.init is not None:
                self.check_expr(stmt.init)
        elif isinstance(stmt, Assign):
            stmt.sym = self.lookup(stmt.name, stmt.span)
            self.check_expr(stmt.value)
        elif isinstance(stmt, ExprStmt):
            self.check_expr(stmt.expr)
        elif isinstance(stmt, If):
            self.check_expr(stmt.cond)
            # In C the controlled statement has block scope even without
            # braces; model that so a declaration cannot leak past the arm.
            self.push()
            self.check_stmt(stmt.then)
            self.pop()
            if stmt.otherwise is not None:
                self.push()
                self.check_stmt(stmt.otherwise)
                self.pop()
        elif isinstance(stmt, While):
            self.check_expr(stmt.cond)
            self.push()
            self.check_stmt(stmt.body)
            self.pop()
        elif isinstance(stmt, Return):
            self.check_expr(stmt.value)
        elif isinstance(stmt, Print):
            self.check_expr(stmt.value)
        else:  # pragma: no cover - defensive
            raise MiniError(f"internal: unknown statement {type(stmt).__name__}", stmt.span)

    def check_expr(self, expr: Expr) -> None:
        if isinstance(expr, IntLit):
            return
        if isinstance(expr, Var):
            expr.sym = self.lookup(expr.name, expr.span)
        elif isinstance(expr, Unary):
            self.check_expr(expr.operand)
        elif isinstance(expr, Binary):
            self.check_expr(expr.left)
            self.check_expr(expr.right)
        elif isinstance(expr, Call):
            info = self.funcs.get(expr.name)
            if info is None:
                raise MiniError(f"call to unknown function '{expr.name}'", expr.span)
            if expr.name == "main":
                raise MiniError("calling 'main' is not supported", expr.span)
            if len(expr.args) != info.arity:
                raise MiniError(
                    f"function '{expr.name}' expects {info.arity} argument(s), got {len(expr.args)}",
                    expr.span,
                )
            for arg in expr.args:
                self.check_expr(arg)
        else:  # pragma: no cover - defensive
            raise MiniError(f"internal: unknown expression {type(expr).__name__}", expr.span)


def definitely_returns(stmt: Stmt) -> bool:
    """True only when every path through *stmt* executes a return."""
    if isinstance(stmt, Return):
        return True
    if isinstance(stmt, Block):
        return any(definitely_returns(s) for s in stmt.stmts)
    if isinstance(stmt, If):
        return (
            stmt.otherwise is not None
            and definitely_returns(stmt.then)
            and definitely_returns(stmt.otherwise)
        )
    return False


def analyze(program: Program) -> Program:
    return Sema(program).check()
