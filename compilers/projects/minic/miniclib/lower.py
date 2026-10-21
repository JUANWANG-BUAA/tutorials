"""Lower SSA back to TAC: phi copies on edges, parallel-copy safe.

Phi nodes are not executable.  For every edge whose target has phis, this
pass materialises the copies.  Branch edges get a dedicated edge block; a
fallthrough or jump edge can hold the copies directly because it has only one
successor.  Copies are done in two phases through fresh temporaries, which is
correct even when the phi assignments form a cycle.
"""

from __future__ import annotations

from .ssa import SsaFunction
from .tac import (
    BasicBlock, Branch, Copy, Jump, Label, Phi, ReturnInstr, TacFunction,
)


def _term(block: BasicBlock):
    if not block.instrs:
        return None
    ins = block.instrs[-1]
    if isinstance(ins, (Branch, Jump, ReturnInstr)):
        return ins
    return None


def _phis(block: BasicBlock) -> list[Phi]:
    return [ins for ins in block.instrs if isinstance(ins, Phi)]


def lower_ssa(fn: SsaFunction) -> TacFunction:
    out = []
    edge_n = 0
    copy_n = 0
    by_name = {b.name: b for b in fn.blocks}

    def parallel_copy(target: BasicBlock) -> None:
        nonlocal copy_n
        phis = [p for p in _phis(target) if p.dst]
        if not phis:
            return
        pending = []
        for phi in phis:
            src = ""
            for pred, name in phi.pairs:
                if pred == current_name:
                    src = name
                    break
            if not src:
                continue
            tmp = f"pc{copy_n}"
            copy_n += 1
            pending.append((phi.dst, src, tmp))
        for _, src, tmp in pending:
            out.append(Copy(tmp, src))
        for dst, _, tmp in pending:
            out.append(Copy(dst, tmp))

    for bi, block in enumerate(fn.blocks):
        current_name = block.name
        out.append(Label(block.name))
        for ins in block.instrs:
            if isinstance(ins, (Phi, Label, Branch, Jump, ReturnInstr)):
                continue
            out.append(ins)
        term = _term(block)
        if isinstance(term, Branch):
            edge_targets = {}
            for target_name in (term.tlabel, term.flabel):
                target = by_name[target_name]
                if _phis(target):
                    label = f"E{edge_n}"
                    edge_n += 1
                    edge_targets[target_name] = label
                else:
                    edge_targets[target_name] = target_name
            out.append(Branch(term.cond, edge_targets[term.tlabel], edge_targets[term.flabel]))
            for target_name, label in edge_targets.items():
                if not label.startswith("E"):
                    continue
                out.append(Label(label))
                parallel_copy(by_name[target_name])
                out.append(Jump(target_name))
        elif isinstance(term, Jump):
            parallel_copy(by_name[term.target])
            out.append(Jump(term.target))
        elif isinstance(term, ReturnInstr):
            out.append(term)
        else:
            if bi + 1 < len(fn.blocks):
                parallel_copy(fn.blocks[bi + 1])

    return TacFunction(fn.name, fn.params, out)
