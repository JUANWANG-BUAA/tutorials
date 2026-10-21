"""SSA optimizations: sparse constant propagation, folding and DCE.

The pass is intentionally small but must be conservative:

* a value is CONST only when every path proves it;
* division and modulo are treated as trapping operations and are never
  deleted just because their result is unused;
* calls are never assumed pure.
"""

from __future__ import annotations

import copy
from dataclasses import dataclass

from .errors import InternalError
from .ssa import SsaFunction
from .tac import (
    Bin, Branch, CallInstr, Const, Copy, Jump, Label, Phi, PrintInstr,
    ReturnInstr, Un, defs_of, to_i32, trunc_div, uses_of,
)

UNDEF = None
NAC = ("nac",)


def _const(v: int):
    return ("const", to_i32(v))


@dataclass
class OptStats:
    folded: int = 0
    phis: int = 0
    removed: int = 0
    branches: int = 0


def _eval_bin(op: str, a: int, b: int):
    if op == "+":
        return _const(a + b)
    if op == "-":
        return _const(a - b)
    if op == "*":
        return _const(a * b)
    if op in ("/", "%"):
        if b == 0 or (a == -(2**31) and b == -1):
            return NAC
        q = trunc_div(a, b)
        return _const(q if op == "/" else a - q * b)
    if op == "==":
        return _const(1 if a == b else 0)
    if op == "!=":
        return _const(1 if a != b else 0)
    if op == "<":
        return _const(1 if a < b else 0)
    if op == "<=":
        return _const(1 if a <= b else 0)
    if op == ">":
        return _const(1 if a > b else 0)
    if op == ">=":
        return _const(1 if a >= b else 0)
    raise InternalError(f"unknown operator {op}")


def _combine(values: list):
    if any(v == NAC for v in values):
        return NAC
    defined = [v for v in values if v is not UNDEF]
    if not defined:
        return UNDEF
    first = defined[0]
    return first if all(v == first for v in defined) else NAC


def constant_propagation(fn: SsaFunction) -> dict[str, tuple]:
    values: dict[str, tuple | None] = {p: NAC for p in fn.params}
    for b in fn.blocks:
        for ins in b.instrs:
            for d in defs_of(ins):
                values.setdefault(d, UNDEF)

    def value_of(name: str):
        if name not in values:
            raise InternalError(f"SSA use before def: {name}")
        return values[name]

    changed = True
    rounds = 0
    while changed:
        changed = False
        rounds += 1
        if rounds > 1000:
            raise InternalError("constant propagation did not converge")
        for b in fn.blocks:
            for ins in b.instrs:
                if not defs_of(ins):
                    continue
                if isinstance(ins, Const):
                    new = _const(ins.value)
                elif isinstance(ins, Copy):
                    new = value_of(ins.src)
                elif isinstance(ins, Bin):
                    a, c = value_of(ins.a), value_of(ins.b)
                    if a == NAC or c == NAC:
                        new = NAC
                    elif a is UNDEF or c is UNDEF:
                        new = UNDEF
                    else:
                        new = _eval_bin(ins.op, a[1], c[1])
                elif isinstance(ins, Un):
                    a = value_of(ins.a)
                    if a == NAC:
                        new = NAC
                    elif a is UNDEF:
                        new = UNDEF
                    elif ins.op == "-":
                        new = _const(-a[1])
                    else:
                        new = _const(1 if a[1] == 0 else 0)
                elif isinstance(ins, Phi):
                    new = _combine([value_of(src) for _, src in ins.pairs])
                elif isinstance(ins, CallInstr):
                    new = NAC
                else:
                    continue
                if values[ins.dst] != new:
                    values[ins.dst] = new
                    changed = True
    return values


def fold(fn: SsaFunction, values: dict[str, tuple]) -> OptStats:
    stats = OptStats()
    for b in fn.blocks:
        for i, ins in enumerate(b.instrs):
            if isinstance(ins, (Const, Copy, Bin, Un, Phi)):
                v = values.get(ins.dst, UNDEF)
                if v not in (UNDEF, NAC):
                    if not (isinstance(ins, Const) and ins.value == v[1]):
                        b.instrs[i] = Const(ins.dst, v[1])
                        stats.folded += 1
                    if isinstance(ins, Phi):
                        stats.phis += 1
            if isinstance(ins, Branch):
                v = values.get(ins.cond, UNDEF)
                if v not in (UNDEF, NAC):
                    target = ins.tlabel if v[1] != 0 else ins.flabel
                    b.instrs[i] = Jump(target)
                    stats.branches += 1
    return stats


def dce(fn: SsaFunction) -> OptStats:
    stats = OptStats()
    defs: dict[str, tuple] = {}
    for b in fn.blocks:
        for i, ins in enumerate(b.instrs):
            for d in defs_of(ins):
                defs[d] = (b, i, ins)

    live: set[int] = set()
    work: list[object] = []

    def mark(ins) -> None:
        if id(ins) in live:
            return
        live.add(id(ins))
        work.append(ins)

    for b in fn.blocks:
        for ins in b.instrs:
            if isinstance(ins, (PrintInstr, CallInstr, ReturnInstr, Jump, Branch, Label)):
                mark(ins)
            elif isinstance(ins, Bin) and ins.op in ("/", "%"):
                mark(ins)

    while work:
        ins = work.pop()
        for use in uses_of(ins):
            if use not in defs:
                continue
            _, _, definition = defs[use]
            mark(definition)

    for b in fn.blocks:
        kept = []
        for ins in b.instrs:
            if defs_of(ins) and id(ins) not in live:
                stats.removed += 1
                continue
            kept.append(ins)
        b.instrs = kept
    return stats


def _term(block):
    if not block.instrs:
        return None
    ins = block.instrs[-1]
    if isinstance(ins, (Branch, Jump, ReturnInstr)):
        return ins
    return None


def _successors(blocks: list, i: int) -> list[str]:
    block = blocks[i]
    term = _term(block)
    if isinstance(term, Branch):
        return [term.tlabel, term.flabel]
    if isinstance(term, Jump):
        return [term.target]
    if isinstance(term, ReturnInstr):
        return []
    return [blocks[i + 1].name] if i + 1 < len(blocks) else []


def cleanup(fn: SsaFunction) -> None:
    """Drop blocks that no longer have a reachable edge and fix phi operands.

    Branch folding can make an arm unreachable while its phi entries remain.
    Rebuilding the CFG keeps the printed SSA honest and lets the verifier run
    after optimization.
    """
    original = fn.blocks
    reachable = {original[0].name}
    work = [original[0].name]
    while work:
        name = work.pop()
        i = next(k for k, b in enumerate(original) if b.name == name)
        for s in _successors(original, i):
            if s not in reachable:
                reachable.add(s)
                work.append(s)
    kept = [b for b in original if b.name in reachable]
    by_name = {b.name: b for b in kept}
    for b in kept:
        b.preds = []
        b.succs = []
    for i, b in enumerate(kept):
        b.succs = [s for s in _successors(kept, i) if s in reachable]
        for s in b.succs:
            by_name[s].preds.append(b.name)
    for b in kept:
        preds = set(b.preds)
        for i, ins in enumerate(b.instrs):
            if isinstance(ins, Phi):
                ins.pairs = [(p, src) for p, src in ins.pairs if p in preds]
                if len(ins.pairs) == 1:
                    b.instrs[i] = Copy(ins.dst, ins.pairs[0][1])
    fn.blocks = kept


def optimize(fn: SsaFunction) -> tuple[SsaFunction, OptStats]:
    work = copy.deepcopy(fn)
    values = constant_propagation(work)
    stats = fold(work, values)
    dce_stats = dce(work)
    stats.removed += dce_stats.removed
    cleanup(work)
    # Single-predecessor phis became copies; propagate once more so the
    # printed SSA and the backend see plain constants.
    values = constant_propagation(work)
    stats.folded += fold(work, values).folded
    stats.removed += dce(work).removed
    cleanup(work)
    return work, stats
