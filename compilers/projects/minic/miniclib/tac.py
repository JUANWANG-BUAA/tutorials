"""Three-address code, CFG construction and the reference interpreter.

TAC is a flat instruction list with labels.  The CFG builder slices that list
into basic blocks; SSA construction and the backend consume the block form,
while the interpreter executes the flat form directly.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Callable, Iterable, Union

from .errors import InternalError, MiniRuntimeError
from .nodes import (
    Assign, Binary, Block, Call, Decl, ExprStmt, Expr, Function, If, IntLit,
    Print, Program, Return, Stmt, Unary, Var, While,
)

INT_MIN = -(2**31)
INT_MAX = 2**31 - 1


def to_i32(value: int) -> int:
    value &= 0xFFFFFFFF
    return value - 2**32 if value >= 2**31 else value


def trunc_div(a: int, b: int) -> int:
    q = abs(a) // abs(b)
    return -q if (a < 0) != (b < 0) else q


# ---------------------------------------------------------------------------
# Instructions
# ---------------------------------------------------------------------------

@dataclass
class Const:
    dst: str
    value: int


@dataclass
class Copy:
    dst: str
    src: str


@dataclass
class Bin:
    dst: str
    op: str
    a: str
    b: str


@dataclass
class Un:
    dst: str
    op: str
    a: str


@dataclass
class Label:
    name: str


@dataclass
class Jump:
    target: str


@dataclass
class Branch:
    cond: str
    tlabel: str
    flabel: str


@dataclass
class CallInstr:
    dst: str | None
    func: str
    args: list[str]


@dataclass
class ReturnInstr:
    src: str | None


@dataclass
class PrintInstr:
    src: str


@dataclass
class Phi:
    dst: str
    base: str
    pairs: list[tuple[str, str]] = field(default_factory=list)


Instr = Union[Const, Copy, Bin, Un, Label, Jump, Branch, CallInstr, ReturnInstr, PrintInstr, Phi]
TERMINATORS = (Jump, Branch, ReturnInstr)
SIDE_EFFECTS = (CallInstr, ReturnInstr, PrintInstr, Jump, Branch)


def defs_of(ins: Instr) -> tuple[str, ...]:
    if isinstance(ins, (Const, Copy, Bin, Un, Phi)):
        return (ins.dst,)
    if isinstance(ins, CallInstr) and ins.dst is not None:
        return (ins.dst,)
    return ()


def uses_of(ins: Instr) -> tuple[str, ...]:
    if isinstance(ins, Copy):
        return (ins.src,)
    if isinstance(ins, Bin):
        return (ins.a, ins.b)
    if isinstance(ins, Un):
        return (ins.a,)
    if isinstance(ins, Branch):
        return (ins.cond,)
    if isinstance(ins, CallInstr):
        return tuple(ins.args)
    if isinstance(ins, ReturnInstr):
        return () if ins.src is None else (ins.src,)
    if isinstance(ins, PrintInstr):
        return (ins.src,)
    if isinstance(ins, Phi):
        return tuple(src for _, src in ins.pairs)
    return ()


def format_instr(ins: Instr) -> str:
    if isinstance(ins, Const):
        return f"{ins.dst} = const {ins.value}"
    if isinstance(ins, Copy):
        return f"{ins.dst} = copy {ins.src}"
    if isinstance(ins, Bin):
        return f"{ins.dst} = {ins.a} {ins.op} {ins.b}"
    if isinstance(ins, Un):
        return f"{ins.dst} = {ins.op}{ins.a}"
    if isinstance(ins, Label):
        return f"{ins.name}:"
    if isinstance(ins, Jump):
        return f"jump {ins.target}"
    if isinstance(ins, Branch):
        return f"branch {ins.cond} ? {ins.tlabel} : {ins.flabel}"
    if isinstance(ins, CallInstr):
        prefix = f"{ins.dst} = " if ins.dst else ""
        return f"{prefix}call {ins.func}({', '.join(ins.args)})"
    if isinstance(ins, ReturnInstr):
        return f"return {ins.src}" if ins.src else "return"
    if isinstance(ins, PrintInstr):
        return f"print {ins.src}"
    if isinstance(ins, Phi):
        pairs = ", ".join(f"[{pred}: {src}]" for pred, src in ins.pairs)
        return f"{ins.dst} = phi {pairs}"
    raise TypeError(f"unknown instruction {ins!r}")


@dataclass
class TacFunction:
    name: str
    params: list[str]
    instrs: list[Instr]

    def dump(self) -> str:
        lines = [f"fn {self.name}({', '.join(self.params)}) {{"]
        for ins in self.instrs:
            text = format_instr(ins)
            lines.append(text if isinstance(ins, Label) else "  " + text)
        lines.append("}")
        return "\n".join(lines)


@dataclass
class BasicBlock:
    name: str
    instrs: list[Instr]
    preds: list[str] = field(default_factory=list)
    succs: list[str] = field(default_factory=list)


@dataclass
class CfgFunction:
    name: str
    params: list[str]
    blocks: list[BasicBlock]
    index: dict[str, int] = field(default_factory=dict)

    def block(self, name: str) -> BasicBlock:
        return self.blocks[self.index[name]]


# ---------------------------------------------------------------------------
# TAC generation
# ---------------------------------------------------------------------------

class TacBuilder:
    def __init__(self, fn: Function):
        self.fn = fn
        self.instrs: list[Instr] = []
        self.tmp_n = 0
        self.label_n = 0

    def emit(self, ins: Instr) -> None:
        self.instrs.append(ins)

    def temp(self) -> str:
        name = f"t{self.tmp_n}"
        self.tmp_n += 1
        return name

    def label(self) -> str:
        name = f"L{self.label_n}"
        self.label_n += 1
        return name

    def lower(self) -> TacFunction:
        self.emit(Label("entry"))
        self.lower_stmt(self.fn.body)
        zero = self.temp()
        self.emit(Const(zero, 0))
        self.emit(ReturnInstr(zero))
        params = [sym.tac_name for sym in self.fn.param_syms]
        return TacFunction(self.fn.name, params, self.instrs)

    # -- expressions -------------------------------------------------------
    def lower_expr(self, expr: Expr) -> str:
        if isinstance(expr, IntLit):
            dst = self.temp()
            self.emit(Const(dst, expr.value))
            return dst
        if isinstance(expr, Var):
            if expr.sym is None:
                raise InternalError("variable not resolved")
            return expr.sym.tac_name
        if isinstance(expr, Unary):
            src = self.lower_expr(expr.operand)
            dst = self.temp()
            self.emit(Un(dst, expr.op, src))
            return dst
        if isinstance(expr, Binary):
            if expr.op in ("&&", "||"):
                return self.lower_logic(expr)
            a = self.lower_expr(expr.left)
            b = self.lower_expr(expr.right)
            dst = self.temp()
            self.emit(Bin(dst, expr.op, a, b))
            return dst
        if isinstance(expr, Call):
            args = [self.lower_expr(a) for a in expr.args]
            dst = self.temp()
            self.emit(CallInstr(dst, expr.name, args))
            return dst
        raise InternalError(f"unknown expression {expr!r}")

    def lower_cond(self, expr: Expr, lt: str, lf: str) -> None:
        """Emit branches that jump to lt when expr is nonzero, lf otherwise."""
        if isinstance(expr, Binary) and expr.op in ("==", "!=", "<", "<=", ">", ">="):
            a = self.lower_expr(expr.left)
            b = self.lower_expr(expr.right)
            dst = self.temp()
            self.emit(Bin(dst, expr.op, a, b))
            self.emit(Branch(dst, lt, lf))
            return
        if isinstance(expr, Binary) and expr.op == "&&":
            mid = self.label()
            self.lower_cond(expr.left, mid, lf)
            self.emit(Label(mid))
            self.lower_cond(expr.right, lt, lf)
            return
        if isinstance(expr, Binary) and expr.op == "||":
            mid = self.label()
            self.lower_cond(expr.left, lt, mid)
            self.emit(Label(mid))
            self.lower_cond(expr.right, lt, lf)
            return
        if isinstance(expr, Unary) and expr.op == "!":
            self.lower_cond(expr.operand, lf, lt)
            return
        value = self.lower_expr(expr)
        self.emit(Branch(value, lt, lf))

    def lower_logic(self, expr: Binary) -> str:
        result = self.temp()
        ltrue = self.label()
        lfalse = self.label()
        lend = self.label()
        mid = self.label()
        if expr.op == "&&":
            self.lower_cond(expr.left, mid, lfalse)
            self.emit(Label(mid))
            self.lower_cond(expr.right, ltrue, lfalse)
        else:
            self.lower_cond(expr.left, ltrue, mid)
            self.emit(Label(mid))
            self.lower_cond(expr.right, ltrue, lfalse)
        self.emit(Label(ltrue))
        self.emit(Const(result, 1))
        self.emit(Jump(lend))
        self.emit(Label(lfalse))
        self.emit(Const(result, 0))
        self.emit(Label(lend))
        return result

    # -- statements --------------------------------------------------------
    def lower_stmt(self, stmt: Stmt) -> None:
        if isinstance(stmt, Block):
            for s in stmt.stmts:
                self.lower_stmt(s)
        elif isinstance(stmt, Decl):
            assert stmt.sym is not None
            name = stmt.sym.tac_name
            self.emit(Const(name, 0))
            if stmt.init is not None:
                value = self.lower_expr(stmt.init)
                self.emit(Copy(name, value))
        elif isinstance(stmt, Assign):
            assert stmt.sym is not None
            value = self.lower_expr(stmt.value)
            self.emit(Copy(stmt.sym.tac_name, value))
        elif isinstance(stmt, ExprStmt):
            expr = stmt.expr
            if isinstance(expr, Call):
                args = [self.lower_expr(a) for a in expr.args]
                self.emit(CallInstr(None, expr.name, args))
            else:
                self.lower_expr(expr)
        elif isinstance(stmt, If):
            then_l = self.label()
            if stmt.otherwise is None:
                end_l = self.label()
                self.lower_cond(stmt.cond, then_l, end_l)
                self.emit(Label(then_l))
                self.lower_stmt(stmt.then)
                self.emit(Label(end_l))
            else:
                else_l = self.label()
                end_l = self.label()
                self.lower_cond(stmt.cond, then_l, else_l)
                self.emit(Label(then_l))
                self.lower_stmt(stmt.then)
                self.emit(Jump(end_l))
                self.emit(Label(else_l))
                self.lower_stmt(stmt.otherwise)
                self.emit(Label(end_l))
        elif isinstance(stmt, While):
            head = self.label()
            body = self.label()
            end = self.label()
            self.emit(Label(head))
            self.lower_cond(stmt.cond, body, end)
            self.emit(Label(body))
            self.lower_stmt(stmt.body)
            self.emit(Jump(head))
            self.emit(Label(end))
        elif isinstance(stmt, Return):
            value = self.lower_expr(stmt.value)
            self.emit(ReturnInstr(value))
        elif isinstance(stmt, Print):
            value = self.lower_expr(stmt.value)
            self.emit(PrintInstr(value))
        else:
            raise InternalError(f"unknown statement {stmt!r}")


def lower_program(program: Program) -> list[TacFunction]:
    return [TacBuilder(fn).lower() for fn in program.functions]


# ---------------------------------------------------------------------------
# CFG
# ---------------------------------------------------------------------------

def build_cfg(fn: TacFunction) -> CfgFunction:
    instrs = fn.instrs
    leaders = {0}
    for i, ins in enumerate(instrs):
        if isinstance(ins, Label):
            leaders.add(i)
        if isinstance(ins, TERMINATORS) and i + 1 < len(instrs):
            leaders.add(i + 1)
    starts = sorted(leaders)
    blocks: list[BasicBlock] = []
    for n, start in enumerate(starts):
        end = starts[n + 1] if n + 1 < len(starts) else len(instrs)
        chunk = instrs[start:end]
        if not chunk:
            continue
        first = chunk[0]
        name = first.name if isinstance(first, Label) else ("entry" if start == 0 else f"B{start}")
        blocks.append(BasicBlock(name, chunk))
    index = {b.name: i for i, b in enumerate(blocks)}
    if len(index) != len(blocks):
        raise InternalError(f"duplicate block label in {fn.name}")

    for i, block in enumerate(blocks):
        last = block.instrs[-1]
        succs: list[str] = []
        if isinstance(last, Jump):
            succs = [last.target]
        elif isinstance(last, Branch):
            succs = [last.tlabel, last.flabel]
        elif isinstance(last, ReturnInstr):
            succs = []
        elif i + 1 < len(blocks):
            succs = [blocks[i + 1].name]
        for s in succs:
            if s not in index:
                raise InternalError(f"jump to unknown label {s} in {fn.name}")
        block.succs = list(dict.fromkeys(succs))

    for block in blocks:
        for s in block.succs:
            owner = blocks[index[s]]
            if block.name not in owner.preds:
                owner.preds.append(block.name)
    return CfgFunction(fn.name, fn.params, blocks, index)


def prune_unreachable(cfg: CfgFunction) -> CfgFunction:
    if not cfg.blocks:
        return cfg
    reachable = {cfg.blocks[0].name}
    work = [cfg.blocks[0].name]
    while work:
        name = work.pop()
        for s in cfg.block(name).succs:
            if s not in reachable:
                reachable.add(s)
                work.append(s)
    blocks = [b for b in cfg.blocks if b.name in reachable]
    for b in blocks:
        b.succs = [s for s in b.succs if s in reachable]
        b.preds = [p for p in b.preds if p in reachable]
    index = {b.name: i for i, b in enumerate(blocks)}
    return CfgFunction(cfg.name, cfg.params, blocks, index)


def format_cfg(cfg: CfgFunction) -> str:
    lines = [f"cfg {cfg.name}() {{"]
    for block in cfg.blocks:
        preds = ", ".join(block.preds) if block.preds else "-"
        succs = ", ".join(block.succs) if block.succs else "-"
        lines.append(f"  {block.name}:  preds=[{preds}] succs=[{succs}]")
        for ins in block.instrs:
            lines.append("    " + format_instr(ins))
    lines.append("}")
    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Interpreter
# ---------------------------------------------------------------------------

class Interpreter:
    def __init__(self, functions: Iterable[TacFunction], out: Callable[[str], None] = print,
                 max_steps: int = 20_000_000):
        self.funcs = {fn.name: fn for fn in functions}
        self.out = out
        self.max_steps = max_steps
        self.steps = 0
        self.labels = {name: self._label_map(fn) for name, fn in self.funcs.items()}

    @staticmethod
    def _label_map(fn: TacFunction) -> dict[str, int]:
        return {ins.name: i for i, ins in enumerate(fn.instrs) if isinstance(ins, Label)}

    def run(self) -> int:
        return self.call("main", [])

    def call(self, name: str, args: list[int]) -> int:
        fn = self.funcs.get(name)
        if fn is None:
            raise InternalError(f"call to undefined function {name}")
        if len(args) != len(fn.params):
            raise InternalError(f"arity mismatch calling {name}")
        env: dict[str, int] = {}
        for param, value in zip(fn.params, args):
            env[param] = to_i32(value)
        labels = self.labels[name]
        pc = 0
        while pc < len(fn.instrs):
            ins = fn.instrs[pc]
            self.steps += 1
            if self.steps > self.max_steps:
                raise MiniRuntimeError(f"step limit {self.max_steps} exceeded", name, pc)
            pc += 1
            if isinstance(ins, Const):
                env[ins.dst] = to_i32(ins.value)
            elif isinstance(ins, Copy):
                env[ins.dst] = env[ins.src]
            elif isinstance(ins, Bin):
                env[ins.dst] = self._bin(ins.op, env[ins.a], env[ins.b], name, pc - 1)
            elif isinstance(ins, Un):
                a = env[ins.a]
                env[ins.dst] = to_i32(-a) if ins.op == "-" else (1 if a == 0 else 0)
            elif isinstance(ins, CallInstr):
                values = [env[a] for a in ins.args]
                result = self.call(ins.func, values)
                if ins.dst is not None:
                    env[ins.dst] = result
            elif isinstance(ins, ReturnInstr):
                return 0 if ins.src is None else env[ins.src]
            elif isinstance(ins, PrintInstr):
                self.out(str(env[ins.src]))
            elif isinstance(ins, Jump):
                pc = labels[ins.target]
            elif isinstance(ins, Branch):
                pc = labels[ins.tlabel] if env[ins.cond] != 0 else labels[ins.flabel]
            elif isinstance(ins, Label):
                pass
            elif isinstance(ins, Phi):
                raise InternalError("interpreter received an unresolved phi")
        return 0

    @staticmethod
    def _bin(op: str, a: int, b: int, fn: str, pc: int) -> int:
        if op == "+":
            return to_i32(a + b)
        if op == "-":
            return to_i32(a - b)
        if op == "*":
            return to_i32(a * b)
        if op in ("/", "%"):
            if b == 0:
                raise MiniRuntimeError("division by zero", fn, pc)
            if a == INT_MIN and b == -1:
                raise MiniRuntimeError("integer division overflow (INT_MIN / -1)", fn, pc)
            q = trunc_div(a, b)
            return q if op == "/" else a - q * b
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
        raise InternalError(f"unknown binary operator {op}")
