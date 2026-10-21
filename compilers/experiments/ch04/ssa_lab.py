#!/usr/bin/env python3
"""SSA construction and verification lab for chapter 4.

The lab starts from a three-address CFG for a small if/while program,
computes dominators and dominance frontiers, inserts phi functions with the
classic iterated-DF algorithm, renames variables along the dominator tree,
and verifies the result.  It then verifies several deliberately broken SSA
programs and demonstrates a missing loop phi that passes the structural
verifier but computes the wrong answer.

Usage:
    python3 ssa_lab.py
"""

from __future__ import annotations

import copy
from dataclasses import dataclass, field
from typing import Iterable


# ---------------------------------------------------------------------------
# TAC / CFG
# ---------------------------------------------------------------------------

@dataclass
class Instr:
    op: str
    dst: str | None = None
    args: tuple = ()


@dataclass
class Phi:
    var: str
    operands: list[str | None] = field(default_factory=list)
    dst: str = ""


@dataclass
class Block:
    name: str
    instrs: list[Instr] = field(default_factory=list)
    phis: list[Phi] = field(default_factory=list)


def build_program() -> dict[str, Block]:
    return {
        "B0": Block("B0", [
            Instr("const", "i", (0,)),
            Instr("const", "sum", (0,)),
            Instr("jump", args=("B1",)),
        ]),
        "B1": Block("B1", [
            Instr("cmp", "t0", ("i", "<", "3")),
            Instr("branch", args=("t0", "B2", "B6")),
        ]),
        "B2": Block("B2", [
            Instr("cmp", "t1", ("i", "==", "1")),
            Instr("branch", args=("t1", "B3", "B4")),
        ]),
        "B3": Block("B3", [
            Instr("bin", "sum", ("sum", "+", "10")),
            Instr("jump", args=("B5",)),
        ]),
        "B4": Block("B4", [
            Instr("bin", "sum", ("sum", "+", "1")),
            Instr("jump", args=("B5",)),
        ]),
        "B5": Block("B5", [
            Instr("bin", "i", ("i", "+", "1")),
            Instr("jump", args=("B1",)),
        ]),
        "B6": Block("B6", [
            Instr("return", args=("sum",)),
        ]),
    }


def successors(blocks: dict[str, Block]) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {}
    for name, block in blocks.items():
        term = block.instrs[-1]
        if term.op == "jump":
            out[name] = [term.args[0]]
        elif term.op == "branch":
            out[name] = [term.args[1], term.args[2]]
        elif term.op == "return":
            out[name] = []
        else:
            raise AssertionError(f"{name}: last instruction is not a terminator")
    return out


def predecessors(blocks: dict[str, Block], succ: dict[str, list[str]]) -> dict[str, list[str]]:
    pred: dict[str, list[str]] = {name: [] for name in blocks}
    for src, targets in succ.items():
        for dst in targets:
            pred[dst].append(src)
    for name in pred:
        pred[name].sort()
    return pred


def block_key(name: str) -> int:
    return int(name[1:])


def reachable(entry: str, succ: dict[str, list[str]]) -> set[str]:
    seen: set[str] = set()
    stack = [entry]
    while stack:
        node = stack.pop()
        if node in seen:
            continue
        seen.add(node)
        stack.extend(succ[node])
    return seen


def dominators(blocks: dict[str, Block], entry: str,
               pred: dict[str, list[str]]) -> dict[str, set[str]]:
    all_blocks = set(blocks)
    dom = {name: ({entry} if name == entry else set(all_blocks)) for name in blocks}
    changed = True
    while changed:
        changed = False
        for name in sorted(blocks, key=block_key):
            if name == entry:
                continue
            ps = pred[name]
            if not ps:
                new = {name}
            else:
                new = set.intersection(*(dom[p] for p in ps))
                new.add(name)
            if new != dom[name]:
                dom[name] = new
                changed = True
    return dom


def immediate_dominators(blocks: dict[str, Block], entry: str,
                         dom: dict[str, set[str]]) -> dict[str, str | None]:
    idom: dict[str, str | None] = {entry: None}
    for name in blocks:
        if name == entry:
            continue
        strict = dom[name] - {name}
        # Strict dominators are nested.  The closest one has the largest
        # dominator set and is a superset of every other strict dominator.
        idom[name] = max(strict, key=lambda d: len(dom[d]))
    return idom


def dominance_frontiers(blocks: dict[str, Block], entry: str,
                        pred: dict[str, list[str]],
                        idom: dict[str, str | None]) -> dict[str, set[str]]:
    df: dict[str, set[str]] = {name: set() for name in blocks}
    for y in blocks:
        if len(pred[y]) < 2:
            continue
        for p in pred[y]:
            runner = p
            while runner != idom[y]:
                if runner is None:
                    raise AssertionError("walked past the root while computing DF")
                df[runner].add(y)
                runner = idom[runner]
    return df


def dominator_tree(blocks: dict[str, Block], idom: dict[str, str | None]) -> dict[str, list[str]]:
    children: dict[str, list[str]] = {name: [] for name in blocks}
    for name, parent in idom.items():
        if parent is not None:
            children[parent].append(name)
    for name in children:
        children[name].sort(key=block_key)
    return children


def insert_phis(blocks: dict[str, Block], pred: dict[str, list[str]],
                df: dict[str, set[str]], tracked: Iterable[str]) -> dict[str, set[str]]:
    phi_blocks: dict[str, set[str]] = {var: set() for var in tracked}
    for var in sorted(tracked):
        def_sites = {name for name, block in blocks.items()
                     if any(inst.dst == var for inst in block.instrs)}
        work = sorted(def_sites, key=block_key)
        while work:
            x = work.pop()
            for y in sorted(df[x], key=block_key):
                if y in phi_blocks[var]:
                    continue
                block = blocks[y]
                block.phis.append(Phi(var=var, operands=[None] * len(pred[y])))
                phi_blocks[var].add(y)
                if y not in def_sites:
                    work.append(y)
    # Deterministic phi order: by block, then by variable.
    for block in blocks.values():
        block.phis.sort(key=lambda p: p.var)
    return phi_blocks


def rename(blocks: dict[str, Block], entry: str, pred: dict[str, list[str]],
           succ: dict[str, list[str]], children: dict[str, list[str]],
           tracked: Iterable[str]) -> None:
    tracked_set = set(tracked)
    counters = {var: 0 for var in tracked_set}
    stacks: dict[str, list[str]] = {var: [] for var in tracked_set}

    def fresh(var: str) -> str:
        name = f"{var}{counters[var]}"
        counters[var] += 1
        return name

    def top(var: str) -> str:
        if var not in stacks or not stacks[var]:
            raise RuntimeError(f"use of {var!r} before its definition")
        return stacks[var][-1]

    def use(name: str) -> str:
        return top(name) if name in tracked_set else name

    def visit(name: str) -> None:
        block = blocks[name]
        pushed: list[str] = []
        for phi in block.phis:
            phi.dst = fresh(phi.var)
            stacks[phi.var].append(phi.dst)
            pushed.append(phi.var)
        for inst in block.instrs:
            if inst.op in ("bin", "cmp"):
                left, op, right = inst.args
                inst.args = (use(left), op, use(right))
            elif inst.op == "copy":
                inst.args = (use(inst.args[0]),)
            elif inst.op == "return":
                inst.args = (use(inst.args[0]),)
            elif inst.op == "branch":
                inst.args = (use(inst.args[0]), inst.args[1], inst.args[2])
            elif inst.op in ("const", "jump"):
                pass
            else:
                raise AssertionError(inst.op)
            if inst.dst is not None and inst.dst in tracked_set:
                new = fresh(inst.dst)
                stacks[inst.dst].append(new)
                pushed.append(inst.dst)
                inst.dst = new
        for s in succ[name]:
            for phi in blocks[s].phis:
                idx = pred[s].index(name)
                phi.operands[idx] = top(phi.var)
        for child in children[name]:
            visit(child)
        for var in reversed(pushed):
            stacks[var].pop()

    visit(entry)


# ---------------------------------------------------------------------------
# Printing
# ---------------------------------------------------------------------------

def fmt_instr(inst: Instr) -> str:
    if inst.op == "const":
        return f"{inst.dst} = {inst.args[0]}"
    if inst.op == "bin":
        return f"{inst.dst} = {inst.args[0]} {inst.args[1]} {inst.args[2]}"
    if inst.op == "cmp":
        return f"{inst.dst} = {inst.args[0]} {inst.args[1]} {inst.args[2]}"
    if inst.op == "copy":
        return f"{inst.dst} = {inst.args[0]}"
    if inst.op == "jump":
        return f"goto {inst.args[0]}"
    if inst.op == "branch":
        return f"if {inst.args[0]} goto {inst.args[1]} else {inst.args[2]}"
    if inst.op == "return":
        return f"return {inst.args[0]}"
    raise AssertionError(inst.op)


def print_cfg(blocks: dict[str, Block], pred: dict[str, list[str]],
              succ: dict[str, list[str]]) -> None:
    print("=== CFG (before SSA) ===")
    for name in sorted(blocks, key=block_key):
        print(f"{name}:")
        for inst in blocks[name].instrs:
            print(f"  {fmt_instr(inst)}")
        print(f"  preds: {', '.join(pred[name]) or '-'}; succs: {', '.join(succ[name]) or '-'}")
    print()


def print_dominators(blocks: dict[str, Block], dom: dict[str, set[str]],
                     df: dict[str, set[str]], idom: dict[str, str | None],
                     children: dict[str, list[str]]) -> None:
    print("=== dominators ===")
    for name in sorted(blocks, key=block_key):
        print(f"dom[{name}] = {{{', '.join(sorted(dom[name], key=block_key))}}}")
    print()
    print("dominator tree:")
    def walk(node: str, prefix: str, last: bool) -> None:
        print(prefix + ("└── " if last else "├── ") + node)
        kids = children[node]
        for i, kid in enumerate(kids):
            walk(kid, prefix + ("    " if last else "│   "), i == len(kids) - 1)
    print("B0")
    for i, kid in enumerate(children["B0"]):
        walk(kid, "", i == len(children["B0"]) - 1)
    print()
    print("=== dominance frontiers ===")
    for name in sorted(blocks, key=block_key):
        print(f"DF[{name}] = {{{', '.join(sorted(df[name], key=block_key))}}}")
    print()


def print_ssa(blocks: dict[str, Block], pred: dict[str, list[str]]) -> None:
    print("=== SSA ===")
    for name in sorted(blocks, key=block_key):
        block = blocks[name]
        print(f"{name}:")
        for phi in block.phis:
            operands = ", ".join(x if x is not None else "?" for x in phi.operands)
            print(f"  {phi.dst} = phi({operands})   ; {phi.var}, preds: {', '.join(pred[name])}")
        for inst in block.instrs:
            print(f"  {fmt_instr(inst)}")
    print()


# ---------------------------------------------------------------------------
# Verifier
# ---------------------------------------------------------------------------

def is_literal(value: str) -> bool:
    body = value[1:] if value.startswith("-") else value
    return body.isdigit()


def verify(blocks: dict[str, Block], entry: str,
           pred: dict[str, list[str]], dom: dict[str, set[str]]) -> list[str]:
    errors: list[str] = []
    defs: dict[str, tuple[str, int, str]] = {}

    # Phi definitions occupy position -1; normal definitions keep their index.
    for name in sorted(blocks, key=block_key):
        block = blocks[name]
        for phi in block.phis:
            if name == entry:
                errors.append(f"E_PHI_ENTRY: phi {phi.dst} in entry block {entry}")
            if phi.dst in defs:
                other, _, _ = defs[phi.dst]
                errors.append(f"E_DUP_DEF: {phi.dst!r} defined in {other} and {name}")
            else:
                defs[phi.dst] = (name, -1, "phi")
            if len(phi.operands) != len(pred[name]):
                errors.append(
                    f"E_PHI_ARITY: {phi.dst} has {len(phi.operands)} operands, "
                    f"block {name} has {len(pred[name])} predecessors")
        for idx, inst in enumerate(block.instrs):
            if inst.dst is None:
                continue
            if inst.dst in defs:
                other, _, _ = defs[inst.dst]
                errors.append(f"E_DUP_DEF: {inst.dst!r} defined in {other} and {name}")
            else:
                defs[inst.dst] = (name, idx, "inst")

    def check_value(value: str, block: str, index: int, where: str) -> None:
        if is_literal(value):
            return
        if value not in defs:
            errors.append(f"E_UNDEF: {value!r} used at {where} has no definition")
            return
        dblock, dindex, _ = defs[value]
        if dblock not in dom[block]:
            errors.append(
                f"E_USE_NOT_DOM: {value!r} defined in {dblock} is used at {where} "
                f"in {block}, but {dblock} does not dominate {block}")
        elif dblock == block and dindex >= index and index >= 0:
            errors.append(
                f"E_USE_ORDER: {value!r} used at {where} before its definition "
                f"in the same block")

    for name in sorted(blocks, key=block_key):
        block = blocks[name]
        for phi in block.phis:
            for idx, value in enumerate(phi.operands):
                where = f"phi {phi.dst} edge {pred[name][idx]}->{name}"
                if value is None:
                    errors.append(f"E_UNDEF: {where} has no incoming value")
                    continue
                if is_literal(value):
                    continue
                if value == phi.dst:
                    errors.append(f"E_PHI_SELF: {where} refers to its own result")
                if value not in defs:
                    errors.append(f"E_UNDEF: {value!r} used at {where} has no definition")
                    continue
                dblock, _, _ = defs[value]
                p = pred[name][idx]
                if dblock not in dom[p]:
                    errors.append(
                        f"E_PHI_EDGE: {value!r} defined in {dblock} does not dominate "
                        f"predecessor {p} of {name}")
        for idx, inst in enumerate(block.instrs):
            if inst.op in ("bin", "cmp"):
                left, _, right = inst.args
                check_value(left, name, idx, f"{name}:{idx} ({fmt_instr(inst)})")
                check_value(right, name, idx, f"{name}:{idx} ({fmt_instr(inst)})")
            elif inst.op in ("copy", "return"):
                check_value(inst.args[0], name, idx, f"{name}:{idx} ({fmt_instr(inst)})")
            elif inst.op == "branch":
                check_value(inst.args[0], name, idx, f"{name}:{idx} ({fmt_instr(inst)})")
    return errors


def verify_report(label: str, blocks: dict[str, Block], entry: str,
                  pred: dict[str, list[str]], dom: dict[str, set[str]]) -> bool:
    errors = verify(blocks, entry, pred, dom)
    n_defs = sum(len(b.phis) + sum(1 for i in b.instrs if i.dst) for b in blocks.values())
    n_uses = 0
    for b in blocks.values():
        for phi in b.phis:
            n_uses += len(phi.operands)
        for inst in b.instrs:
            if inst.op in ("bin", "cmp"):
                n_uses += 2
            elif inst.op in ("copy", "return", "branch"):
                n_uses += 1
    print(f"verify({label}): {'OK' if not errors else 'REJECT'} "
          f"(defs={n_defs}, uses={n_uses}, phis={sum(len(b.phis) for b in blocks.values())})")
    for error in errors[:6]:
        print("  " + error)
    if len(errors) > 6:
        print(f"  ... {len(errors) - 6} more")
    return not errors


# ---------------------------------------------------------------------------
# Interpreter for SSA TAC
# ---------------------------------------------------------------------------

def interpret(blocks: dict[str, Block], entry: str, pred: dict[str, list[str]],
              limit: int = 1000) -> int:
    env: dict[str, int] = {}
    def value_of(name: str) -> int:
        return int(name) if is_literal(name) else env[name]

    current = entry
    previous: str | None = None
    for _ in range(limit):
        block = blocks[current]
        for phi in block.phis:
            idx = pred[current].index(previous) if previous is not None else 0
            value = phi.operands[idx]
            if value is None or (not is_literal(value) and value not in env):
                raise RuntimeError(f"phi {phi.dst}: missing value {value!r}")
            env[phi.dst] = value_of(value)
        for inst in block.instrs:
            if inst.op == "const":
                env[inst.dst] = int(inst.args[0])
            elif inst.op == "bin":
                a, op, b = inst.args
                left, right = value_of(a), value_of(b)
                if op == "+":
                    env[inst.dst] = left + right
                elif op == "-":
                    env[inst.dst] = left - right
                elif op == "*":
                    env[inst.dst] = left * right
                else:
                    raise AssertionError(op)
            elif inst.op == "cmp":
                a, op, b = inst.args
                left, right = value_of(a), value_of(b)
                env[inst.dst] = int(left < right) if op == "<" else int(left == right)
            elif inst.op == "copy":
                env[inst.dst] = value_of(inst.args[0])
            elif inst.op == "jump":
                previous, current = current, inst.args[0]
                break
            elif inst.op == "branch":
                cond, yes, no = inst.args
                previous, current = current, (yes if env[cond] else no)
                break
            elif inst.op == "return":
                return value_of(inst.args[0])
            else:
                raise AssertionError(inst.op)
        else:
            raise RuntimeError(f"block {current} has no terminator")
    raise RuntimeError(f"step limit {limit} exceeded")


# ---------------------------------------------------------------------------
# Parallel copies
# ---------------------------------------------------------------------------

def sequentialize(copies: list[tuple[str, str]]) -> list[str]:
    """Turn a parallel copy (dst, src)* into sequential moves."""
    pending = list(copies)
    out: list[str] = []
    temp = 0
    while pending:
        sources = {src for _, src in pending}
        ready = next((c for c in pending if c[0] not in sources), None)
        if ready is not None:
            out.append(f"{ready[0]} <- {ready[1]}")
            pending.remove(ready)
            continue
        dst, _ = pending[0]
        name = f"tmp{temp}"
        temp += 1
        out.append(f"{name} <- {dst}")
        pending = [(d, name if s == dst else s) for d, s in pending]
    return out


def parallel_copy_demo(blocks: dict[str, Block], pred: dict[str, list[str]]) -> None:
    print("=== parallel copies on the B5->B1 back edge ===")
    edge = "B5"
    index = pred["B1"].index(edge)
    copies = [(phi.dst, phi.operands[index]) for phi in blocks["B1"].phis]
    copies = [(d, s) for d, s in copies if s is not None]
    print("parallel:", ", ".join(f"{d} <- {s}" for d, s in copies))
    for line in sequentialize(copies):
        print("  " + line)
    print("swap example: a <- b, b <- a")
    for line in sequentialize([("a", "b"), ("b", "a")]):
        print("  " + line)
    print("lost-copy example: x <- y, y <- z, z <- x")
    for line in sequentialize([("x", "y"), ("y", "z"), ("z", "x")]):
        print("  " + line)
    print()


# ---------------------------------------------------------------------------
# Broken variants
# ---------------------------------------------------------------------------

def bad_duplicate(blocks: dict[str, Block]) -> None:
    for inst in blocks["B4"].instrs:
        if inst.dst == "sum3":
            inst.dst = "sum2"


def bad_arity(blocks: dict[str, Block]) -> None:
    for phi in blocks["B1"].phis:
        if phi.var == "sum":
            phi.operands = phi.operands[:1]


def bad_use_dominance(blocks: dict[str, Block]) -> None:
    for inst in blocks["B1"].instrs:
        if inst.dst == "t0":
            inst.args = ("i2", "<", "3")


def bad_phi_edge(blocks: dict[str, Block]) -> None:
    for phi in blocks["B1"].phis:
        if phi.var == "sum":
            phi.operands[1] = "sum2"


def missing_loop_phi(blocks: dict[str, Block]) -> None:
    """Remove the loop-carried sum phi but keep the i phi.

    The result is structurally valid SSA: sum0 dominates every use, and the
    unused sum2/sum3 definitions are legal.  It computes 0 instead of 12.
    """
    blocks["B1"].phis = [p for p in blocks["B1"].phis if p.var != "sum"]
    blocks["B5"].phis = []
    for name in ("B3", "B4"):
        for inst in blocks[name].instrs:
            if inst.op == "bin" and inst.dst in ("sum2", "sum3"):
                left, op, right = inst.args
                inst.args = ("sum0", op, right)
    for inst in blocks["B6"].instrs:
        if inst.op == "return":
            inst.args = ("sum0",)


# ---------------------------------------------------------------------------
# Driver
# ---------------------------------------------------------------------------

def main() -> int:
    blocks = build_program()
    succ = successors(blocks)
    pred = predecessors(blocks, succ)
    entry = "B0"
    dom = dominators(blocks, entry, pred)
    idom = immediate_dominators(blocks, entry, dom)
    df = dominance_frontiers(blocks, entry, pred, idom)
    children = dominator_tree(blocks, idom)

    print("ssa_lab: iterated dominance frontier + dominator-tree renaming")
    print("program: i = 0; sum = 0; while (i < 3) { if (i == 1) sum += 10; else sum += 1; i += 1; } return sum;")
    print()
    print_cfg(blocks, pred, succ)
    print_dominators(blocks, dom, df, idom, children)

    tracked = ("i", "sum")
    phi_blocks = insert_phis(blocks, pred, df, tracked)
    print("=== phi placement ===")
    for var in tracked:
        def_sites = {name for name, block in blocks.items()
                     if any(inst.dst == var for inst in block.instrs)}
        print(f"{var}: definitions {{{', '.join(sorted(def_sites, key=block_key))}}}; "
              f"phi at {{{', '.join(sorted(phi_blocks[var], key=block_key))}}}")
    print()

    rename(blocks, entry, pred, succ, children, tracked)
    print_ssa(blocks, pred)
    verify_report("correct SSA", blocks, entry, pred, dom)
    print()

    variants = [
        ("duplicate definition", bad_duplicate),
        ("phi arity mismatch", bad_arity),
        ("use not dominated", bad_use_dominance),
        ("phi operand from wrong edge", bad_phi_edge),
    ]
    for label, mutate in variants:
        broken = copy.deepcopy(blocks)
        mutate(broken)
        verify_report(label, broken, entry, pred, dom)
    print()

    wrong = copy.deepcopy(blocks)
    missing_loop_phi(wrong)
    print("=== missing loop phi: structural verifier cannot see the bug ===")
    verify_report("missing sum phi (structurally)", wrong, entry, pred, dom)
    print(f"interpret correct SSA:     {interpret(blocks, entry, pred)} (expected 12)")
    print(f"interpret missing-phi SSA: {interpret(wrong, entry, pred)} (expected 12)")
    print()

    parallel_copy_demo(blocks, pred)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
