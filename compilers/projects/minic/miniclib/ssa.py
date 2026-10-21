"""SSA construction: dominators, dominance frontiers, phi insertion, renaming.

This is the classic Cytron et al. algorithm.  It is deliberately structural:
blocks come from the TAC CFG, and the pass never needs the AST.
"""

from __future__ import annotations

import copy
from dataclasses import dataclass, field

from .errors import InternalError
from .tac import (
    BasicBlock, Bin, Branch, CallInstr, CfgFunction, Const, Copy, Jump, Label,
    Phi, ReturnInstr, TacFunction, Un, build_cfg, defs_of, format_instr,
    prune_unreachable, uses_of,
)


@dataclass
class SsaFunction:
    name: str
    params: list[str]
    blocks: list[BasicBlock]

    def block(self, name: str) -> BasicBlock:
        for b in self.blocks:
            if b.name == name:
                return b
        raise KeyError(name)

    def dump(self) -> str:
        lines = [f"fn {self.name}({', '.join(self.params)}) {{"]
        for b in self.blocks:
            preds = ", ".join(b.preds) if b.preds else "-"
            lines.append(f"{b.name}:  ; preds = {preds}")
            for ins in b.instrs:
                if isinstance(ins, Label):
                    continue
                lines.append("  " + format_instr(ins))
        lines.append("}")
        return "\n".join(lines)


# ---------------------------------------------------------------------------
# Dominators and dominance frontiers
# ---------------------------------------------------------------------------

def compute_dominators(cfg: CfgFunction) -> tuple[dict[str, set[str]], dict[str, str | None]]:
    names = [b.name for b in cfg.blocks]
    all_names = set(names)
    entry = names[0]
    dom = {n: ({n} if n == entry else set(all_names)) for n in names}
    changed = True
    while changed:
        changed = False
        for n in names[1:]:
            preds = cfg.block(n).preds
            if not preds:
                new = {n}
            else:
                new = {n} | set.intersection(*(dom[p] for p in preds))
            if new != dom[n]:
                dom[n] = new
                changed = True
    idom: dict[str, str | None] = {entry: None}
    for n in names[1:]:
        strict = dom[n] - {n}
        if not strict:
            idom[n] = None
            continue
        # The immediate dominator has the largest dominator set among the
        # strict dominators (domination is a chain).
        idom[n] = max(strict, key=lambda d: (len(dom[d]), d))
    return dom, idom


def dominance_frontiers(cfg: CfgFunction, idom: dict[str, str | None]) -> dict[str, set[str]]:
    df = {b.name: set() for b in cfg.blocks}
    for b in cfg.blocks:
        if len(b.preds) < 2:
            continue
        for p in b.preds:
            runner = p
            while runner != idom.get(b.name) and runner is not None:
                df[runner].add(b.name)
                runner = idom.get(runner)
    return df


# ---------------------------------------------------------------------------
# Phi insertion and renaming
# ---------------------------------------------------------------------------

def compute_liveness(cfg: CfgFunction) -> tuple[dict[str, set[str]], dict[str, set[str]]]:
    """Classic may-liveness.  Used to prune phi insertion to live variables."""
    use: dict[str, set[str]] = {b.name: set() for b in cfg.blocks}
    defs: dict[str, set[str]] = {b.name: set() for b in cfg.blocks}
    for b in cfg.blocks:
        for ins in b.instrs:
            for u in uses_of(ins):
                if u not in defs[b.name]:
                    use[b.name].add(u)
            defs[b.name].update(defs_of(ins))
    live_in = {b.name: set() for b in cfg.blocks}
    live_out = {b.name: set() for b in cfg.blocks}
    changed = True
    while changed:
        changed = False
        for b in reversed(cfg.blocks):
            out = set()
            for s in b.succs:
                out |= live_in[s]
            inn = use[b.name] | (out - defs[b.name])
            if out != live_out[b.name] or inn != live_in[b.name]:
                live_out[b.name] = out
                live_in[b.name] = inn
                changed = True
    return live_in, live_out


def insert_phis(cfg: CfgFunction, df: dict[str, set[str]],
                live_in: dict[str, set[str]]) -> None:
    def_blocks: dict[str, set[str]] = {}
    for b in cfg.blocks:
        for ins in b.instrs:
            for d in defs_of(ins):
                def_blocks.setdefault(d, set()).add(b.name)
    for p in cfg.params:
        def_blocks.setdefault(p, set()).add(cfg.blocks[0].name)

    for var in sorted(def_blocks):
        work = list(def_blocks[var])
        has_phi: set[str] = set()
        while work:
            x = work.pop()
            for y_name in sorted(df.get(x, ())):
                if y_name in has_phi:
                    continue
                # Pruned SSA: a phi is only needed when the variable is live
                # on entry to the merge block.  Without this check, dead
                # temporaries from one arm produce undefined phi operands on
                # the other arm.
                if var not in live_in.get(y_name, set()):
                    continue
                y = cfg.block(y_name)
                has_phi.add(y_name)
                phi = Phi("", var, [(p, "") for p in y.preds])
                pos = 1 if y.instrs and isinstance(y.instrs[0], Label) else 0
                y.instrs.insert(pos, phi)
                work.append(y_name)


def _rename_uses(ins, current):
    if isinstance(ins, Copy):
        ins.src = current(ins.src)
    elif isinstance(ins, Bin):
        ins.a = current(ins.a)
        ins.b = current(ins.b)
    elif isinstance(ins, Un):
        ins.a = current(ins.a)
    elif isinstance(ins, Branch):
        ins.cond = current(ins.cond)
    elif isinstance(ins, CallInstr):
        ins.args = [current(a) for a in ins.args]
    elif isinstance(ins, ReturnInstr):
        if ins.src is not None:
            ins.src = current(ins.src)
    elif isinstance(ins, Phi):
        raise InternalError("phi operands are filled by the predecessor")
    else:
        # PrintInstr
        if hasattr(ins, "src") and ins.src is not None:
            ins.src = current(ins.src)


def rename(cfg: CfgFunction) -> SsaFunction:
    dom, idom = compute_dominators(cfg)
    df = dominance_frontiers(cfg, idom)
    live_in, _ = compute_liveness(cfg)
    insert_phis(cfg, df, live_in)
    children: dict[str, list[str]] = {b.name: [] for b in cfg.blocks}
    for b in cfg.blocks:
        parent = idom[b.name]
        if parent is not None:
            children[parent].append(b.name)

    counters: dict[str, int] = {}
    stacks: dict[str, list[str]] = {}
    param_out: list[str] = []

    def fresh(var: str) -> str:
        n = counters.get(var, 0) + 1
        counters[var] = n
        name = f"{var}_{n}"
        stacks.setdefault(var, []).append(name)
        return name

    def current(var: str) -> str:
        stack = stacks.get(var)
        if not stack:
            raise InternalError(f"use of unrenamed variable {var} in {cfg.name}")
        return stack[-1]

    def rename_block(b: BasicBlock) -> None:
        pushed: list[str] = []
        for ins in b.instrs:
            if isinstance(ins, Phi):
                new = fresh(ins.base)
                ins.dst = new
                pushed.append(ins.base)
            elif isinstance(ins, Label):
                continue
            else:
                _rename_uses(ins, current)
                for d in defs_of(ins):
                    new = fresh(d)
                    if isinstance(ins, (Const, Copy, Bin, Un)):
                        ins.dst = new
                    elif isinstance(ins, CallInstr):
                        ins.dst = new
                    else:
                        raise InternalError(f"cannot rename def in {ins!r}")
                    pushed.append(d)
        for succ_name in b.succs:
            succ = cfg.block(succ_name)
            for ins in succ.instrs:
                if isinstance(ins, Phi):
                    found = False
                    for i, (pred, _) in enumerate(ins.pairs):
                        if pred == b.name:
                            ins.pairs[i] = (pred, current(ins.base))
                            found = True
                            break
                    if not found:
                        raise InternalError(f"phi {ins.dst} missing predecessor {b.name}")
        for child in children[b.name]:
            rename_block(cfg.block(child))
        for var in pushed:
            stacks[var].pop()

    for p in cfg.params:
        param_out.append(fresh(p))
    rename_block(cfg.blocks[0])
    return SsaFunction(cfg.name, param_out, cfg.blocks)


def build_ssa(fn: TacFunction) -> SsaFunction:
    # Renaming mutates instruction objects in place.  Work on a copy so the
    # direct TAC form remains available as an independent reference for the
    # interpreter used by --run.
    work = TacFunction(fn.name, list(fn.params), copy.deepcopy(fn.instrs))
    cfg = prune_unreachable(build_cfg(work))
    return rename(cfg)


def verify_ssa(fn: SsaFunction) -> list[str]:
    problems: list[str] = []
    # Parameters are defined at function entry without an explicit instruction.
    defs: dict[str, str] = {p: fn.blocks[0].name for p in fn.params}
    uses: list[str] = []
    names = {b.name for b in fn.blocks}
    for b in fn.blocks:
        if b.name != fn.blocks[0].name and not b.preds:
            problems.append(f"block {b.name} is unreachable")
        for ins in b.instrs:
            for d in defs_of(ins):
                if d in defs:
                    problems.append(f"variable {d} defined twice ({defs[d]}, {b.name})")
                defs[d] = b.name
            uses.extend(uses_of(ins))
            if isinstance(ins, Phi):
                preds = {p for p, _ in ins.pairs}
                if preds != set(b.preds) or len(ins.pairs) != len(b.preds):
                    problems.append(f"phi {ins.dst} operands do not match preds of {b.name}")
            if isinstance(ins, Branch):
                if ins.tlabel not in names or ins.flabel not in names:
                    problems.append(f"branch in {b.name} targets a missing block")
            if isinstance(ins, Jump):
                if ins.target not in names:
                    problems.append(f"jump in {b.name} targets a missing block")
    for u in uses:
        if u not in defs:
            problems.append(f"use of undefined SSA name {u}")
    for p in fn.params:
        if p not in defs:
            problems.append(f"parameter {p} has no definition")
    return problems
