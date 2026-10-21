#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""static_lab.py -- 第 9 章实验：一个很小的区间抽象解释器。

语言只有赋值、整数四则/取模、带标签的条件跳转和数组写检查。
分析在 CFG 上迭代到不动点，用区间域近似每个程序点的变量取值；
遇到可能的有符号溢出或数组越界就报 warning。

用法：
    python3 static_lab.py                 # C 语义 + 严格溢出检查
    python3 static_lab.py --mod=math      # 把 % 当数学取模（演示漏报）
    python3 static_lab.py --semantics=wrap# 把溢出当回绕（演示漏报）
    python3 static_lab.py --dump          # 先打印五个示例程序
"""

from __future__ import annotations

import argparse
import sys
from collections import Counter, deque
from dataclasses import dataclass

INT_MIN = -(2 ** 31)
INT_MAX = 2 ** 31 - 1


@dataclass(frozen=True)
class Iv:
    """闭区间 [lo, hi]；lo/hi 为 None 表示负/正无穷。"""

    lo: int | None
    hi: int | None


TOP = Iv(None, None)
BOT = None  # 不可达


def fmt(iv: Iv | None) -> str:
    if iv is None:
        return "unreachable"
    lo = "-inf" if iv.lo is None else str(iv.lo)
    hi = "+inf" if iv.hi is None else str(iv.hi)
    return f"[{lo}, {hi}]"


def join_iv(a: Iv | None, b: Iv | None) -> Iv | None:
    if a is None:
        return b
    if b is None:
        return a
    lo = None if a.lo is None or b.lo is None else min(a.lo, b.lo)
    hi = None if a.hi is None or b.hi is None else max(a.hi, b.hi)
    return Iv(lo, hi)


def meet_iv(iv: Iv | None, lo: int | None, hi: int | None) -> Iv | None:
    if iv is None:
        return None
    nlo = iv.lo
    nhi = iv.hi
    if lo is not None:
        nlo = lo if nlo is None else max(nlo, lo)
    if hi is not None:
        nhi = hi if nhi is None else min(nhi, hi)
    if nlo is not None and nhi is not None and nlo > nhi:
        return None
    return Iv(nlo, nhi)


def join_states(a: dict[str, Iv] | None, b: dict[str, Iv] | None) -> dict[str, Iv] | None:
    if a is None:
        return b
    if b is None:
        return a
    out: dict[str, Iv] = {}
    for k in set(a) | set(b):
        out[k] = join_iv(a.get(k, TOP), b.get(k, TOP))  # type: ignore[arg-type]
    return out


def widen_states(old: dict[str, Iv], new: dict[str, Iv]) -> dict[str, Iv]:
    """把增长的方向推到无穷，保证循环上的迭代终止。"""
    out = dict(new)
    for k, nv in new.items():
        ov = old.get(k, TOP)
        lo = nv.lo
        hi = nv.hi
        if ov.lo is None or (lo is not None and lo < ov.lo):
            lo = None
        if ov.hi is None or (hi is not None and hi > ov.hi):
            hi = None
        out[k] = Iv(lo, hi)
    return out


# ---------- 表达式与指令 ----------

Expr = tuple  # ("const", n) | ("var", s) | ("input",) | ("add", a, b) | ...


def e_str(e: Expr) -> str:
    tag = e[0]
    if tag == "const":
        return str(e[1])
    if tag == "var":
        return e[1]
    if tag == "input":
        return "input"
    if tag == "neg":
        return f"(-{e_str(e[1])})"
    op = {"add": "+", "sub": "-", "mul": "*", "mod": "%"}[tag]
    return f"({e_str(e[1])} {op} {e_str(e[2])})"


def eval_expr(st: dict[str, Iv], e: Expr, sem: str, mod: str) -> tuple[Iv, bool]:
    """返回 (区间, 是否可能溢出)。sem=strict|wrap，mod=c|math。"""
    tag = e[0]
    if tag == "const":
        return Iv(e[1], e[1]), False
    if tag == "var":
        return st.get(e[1], TOP), False
    if tag == "input":
        return TOP, False
    if tag == "neg":
        iv, over = eval_expr(st, e[1], sem, mod)
        if iv is None:
            return TOP, over
        poss = ((iv.lo is not None and iv.lo == INT_MIN)
                or (iv.hi is not None and -iv.hi > INT_MAX))
        if poss:
            return TOP, sem == "strict"
        if iv.lo is None or iv.hi is None:
            return TOP, over
        return Iv(-iv.hi, -iv.lo), over

    a, oa = eval_expr(st, e[1], sem, mod)
    b, ob = eval_expr(st, e[2], sem, mod)
    over = oa or ob
    if a is None or b is None:
        return TOP, over

    if tag in ("add", "sub"):
        if tag == "add":
            lo = None if a.lo is None or b.lo is None else a.lo + b.lo
            hi = None if a.hi is None or b.hi is None else a.hi + b.hi
        else:
            lo = None if a.lo is None or b.hi is None else a.lo - b.hi
            hi = None if a.hi is None or b.lo is None else a.hi - b.lo
        poss = (lo is not None and lo < INT_MIN) or (hi is not None and hi > INT_MAX)
        if poss:
            return TOP, sem == "strict"
        if lo is None or hi is None:
            return TOP, False
        return Iv(lo, hi), False

    if tag == "mul":
        if a.lo is None or a.hi is None or b.lo is None or b.hi is None:
            return TOP, over
        vals = [a.lo * b.lo, a.lo * b.hi, a.hi * b.lo, a.hi * b.hi]
        lo, hi = min(vals), max(vals)
        if lo < INT_MIN or hi > INT_MAX:
            return TOP, sem == "strict"
        return Iv(lo, hi), False

    if tag == "mod":
        if b.lo is None or b.hi is None or b.lo != b.hi or b.lo <= 0:
            return TOP, over
        d = b.lo
        if mod == "math":
            return Iv(0, d - 1), False
        # C 的 % 向零截断：负被除数得到非正余数。
        if a.lo is not None and a.lo >= 0:
            return Iv(0, d - 1), False
        return Iv(-(d - 1), d - 1), False

    raise ValueError(f"unknown expr {tag}")


def eval_concrete(e: Expr, env: dict[str, int]) -> int:
    tag = e[0]
    if tag == "const":
        return e[1]
    if tag == "var":
        return env[e[1]]
    if tag == "input":
        raise ValueError("input has no concrete value")
    if tag == "neg":
        return -eval_concrete(e[1], env)
    a = eval_concrete(e[1], env)
    b = eval_concrete(e[2], env)
    if tag == "add":
        return a + b
    if tag == "sub":
        return a - b
    if tag == "mul":
        return a * b
    if tag == "mod":
        # 与 C 一致：向零截断。
        q = abs(a) // abs(b)
        return a - (q if (a >= 0) == (b >= 0) else -q) * b
    raise ValueError(tag)


@dataclass
class Program:
    name: str
    arrays: dict[str, int]
    code: list[tuple]
    witness: dict[str, int]
    witness_note: str


P_GUARDED = Program(
    "guarded", {"a": 8},
    [
        ("assign", "i", ("input",)),
        ("if", ("var", "i"), "<", 0, "END"),
        ("if", ("var", "i"), ">=", 8, "END"),
        ("check", "a", ("var", "i")),
        ("label", "END"),
        ("halt",),
    ],
    {"i": 3}, "i=3 时 a[3] 在界内：分析器与运行时一致，不报。",
)

P_NEGATIVE = Program(
    "negative", {"a": 8},
    [
        ("assign", "i", ("input",)),
        ("if", ("var", "i"), ">=", 8, "END"),
        ("check", "a", ("var", "i")),
        ("label", "END"),
        ("halt",),
    ],
    {"i": -1}, "i=-1 通过上界检查，但 a[-1] 越界：真阳性。",
)

P_RELATIONAL = Program(
    "relational", {"a": 8},
    [
        ("assign", "x", ("input",)),
        ("assign", "y", ("input",)),
        ("if", ("var", "x"), "<", 0, "END"),
        ("if", ("var", "y"), "<", 0, "END"),
        ("if", ("add", ("var", "x"), ("var", "y")), ">", 7, "END"),
        ("check", "a", ("var", "x")),
        ("label", "END"),
        ("halt",),
    ],
    {"x": 3, "y": 4}, "x=3,y=4 满足 x+y<=7，a[3] 安全；区间域丢失相关性，报假阳性。",
)

P_MODULO = Program(
    "modulo", {"a": 8},
    [
        ("assign", "i", ("input",)),
        ("assign", "j", ("mod", ("var", "i"), ("const", 8))),
        ("check", "a", ("var", "j")),
        ("halt",),
    ],
    {"i": -1}, "i=-1 时 C 的 -1%8 == -1，a[-1] 越界；--mod=math 会漏报。",
)

P_OVERFLOW = Program(
    "overflow", {"a": 8},
    [
        ("assign", "x", ("const", INT_MAX)),
        ("assign", "y", ("add", ("var", "x"), ("const", 1))),
        ("halt",),
    ],
    {}, "INT_MAX+1 是有符号溢出；--semantics=wrap 把 UB 当回绕，漏报。",
)

PROGRAMS = [P_GUARDED, P_NEGATIVE, P_RELATIONAL, P_MODULO, P_OVERFLOW]


# ---------- 分析 ----------

def successors(code: list[tuple], pc: int) -> list[tuple[int, str | None]]:
    ins = code[pc]
    if ins[0] == "goto":
        return [(label_index(code, ins[1]), None)]
    if ins[0] == "if":
        return [(label_index(code, ins[4]), "true"), (pc + 1, "false")]
    if ins[0] == "halt":
        return []
    return [(pc + 1, None)]


def label_index(code: list[tuple], name: str) -> int:
    for i, ins in enumerate(code):
        if ins[0] == "label" and ins[1] == name:
            return i
    raise KeyError(name)


def refine(st: dict[str, Iv], cond: tuple, truth: bool) -> dict[str, Iv] | None:
    e, op, k = cond[0], cond[1], cond[2]
    if e[0] != "var":
        return st  # 只对单变量条件做路径细化
    var = e[1]
    iv = st.get(var, TOP)
    if op == "<":
        target = meet_iv(iv, None, k - 1) if truth else meet_iv(iv, k, None)
    elif op == "<=":
        target = meet_iv(iv, None, k) if truth else meet_iv(iv, k + 1, None)
    elif op == ">":
        target = meet_iv(iv, k + 1, None) if truth else meet_iv(iv, None, k)
    elif op == ">=":
        target = meet_iv(iv, k, None) if truth else meet_iv(iv, None, k - 1)
    elif op == "==":
        target = meet_iv(iv, k, k) if truth else iv
    else:  # !=
        target = iv if truth else meet_iv(iv, k, k)
    if target is None:
        return None
    out = dict(st)
    out[var] = target
    return out


def transfer(st: dict[str, Iv], ins: tuple, sem: str, mod: str) -> dict[str, Iv]:
    if ins[0] == "assign":
        iv, _ = eval_expr(st, ins[2], sem, mod)
        out = dict(st)
        out[ins[1]] = iv
        return out
    return st


def analyze(prog: Program, sem: str, mod: str, use_widen: bool = True):
    code = prog.code
    n = len(code)
    IN: list[dict[str, Iv] | None] = [None] * n
    IN[0] = {}
    work = deque([0])
    visits: Counter[int] = Counter()
    rounds = 0

    while work and rounds < 500:
        pc = work.popleft()
        st = IN[pc]
        if st is None:
            continue
        rounds += 1
        out = transfer(st, code[pc], sem, mod)
        for succ, edge in successors(code, pc):
            cand = out
            if edge is not None and code[pc][0] == "if":
                cand = refine(out, (code[pc][1], code[pc][2], code[pc][3]), edge == "true")
            if cand is None:
                continue
            merged = join_states(IN[succ], cand)
            if use_widen and IN[succ] is not None and visits[succ] > 4:
                merged = widen_states(IN[succ], merged)
            if merged != IN[succ]:
                IN[succ] = merged
                work.append(succ)
        visits[pc] += 1

    warnings: list[str] = []
    for pc, ins in enumerate(code):
        st = IN[pc]
        if st is None:
            continue
        if ins[0] == "assign":
            _, over = eval_expr(st, ins[2], sem, mod)
            if over:
                warnings.append(f"pc {pc}: {ins[1]} = {e_str(ins[2])} 可能使 int 溢出")
        elif ins[0] == "check":
            arr, idx = ins[1], ins[2]
            iv, over = eval_expr(st, idx, sem, mod)
            if over:
                warnings.append(f"pc {pc}: 下标表达式 {e_str(idx)} 可能溢出")
            size = prog.arrays[arr]
            bad = iv is None or iv.lo is None or iv.hi is None or iv.lo < 0 or iv.hi >= size
            if bad:
                warnings.append(
                    f"pc {pc}: {arr}[{e_str(idx)}] 可能越界；"
                    f"下标区间 {fmt(iv)}，合法区间 [0, {size - 1}]"
                )
    return warnings, IN, rounds


def concrete_checks(prog: Program, env0: dict[str, int]) -> list[tuple[str, int]]:
    """用具体值走一遍程序，返回每个 check 的 (数组, 下标)。"""
    env = dict(env0)
    code = prog.code
    pc = 0
    out: list[tuple[str, int]] = []
    for _ in range(100):
        if pc >= len(code):
            break
        ins = code[pc]
        tag = ins[0]
        if tag == "assign":
            env[ins[1]] = env0[ins[1]] if ins[2][0] == "input" else eval_concrete(ins[2], env)
            pc += 1
        elif tag == "if":
            left = eval_concrete(ins[1], env)
            right = ins[3]
            ok = {"<": left < right, "<=": left <= right,
                  ">": left > right, ">=": left >= right,
                  "==": left == right, "!=": left != right}[ins[2]]
            pc = label_index(code, ins[4]) if ok else pc + 1
        elif tag == "goto":
            pc = label_index(code, ins[1])
        elif tag == "check":
            out.append((ins[1], eval_concrete(ins[2], env)))
            pc += 1
        elif tag == "halt":
            break
        elif tag == "label":
            pc += 1
    return out


def render(prog: Program) -> list[str]:
    lines = [f"// {prog.name}: int a[{prog.arrays['a']}];"]
    for ins in prog.code:
        tag = ins[0]
        if tag == "label":
            lines.append(f"{ins[1]}:")
        elif tag == "assign":
            lines.append(f"  {ins[1]} = {e_str(ins[2])};")
        elif tag == "if":
            lines.append(f"  if ({e_str(ins[1])} {ins[2]} {ins[3]}) goto {ins[4]};")
        elif tag == "goto":
            lines.append(f"  goto {ins[1]};")
        elif tag == "check":
            lines.append(f"  {ins[1]}[{e_str(ins[2])}] = 0;  // bounds check")
        elif tag == "halt":
            lines.append("  halt;")
    return lines


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mod", choices=["c", "math"], default="c")
    ap.add_argument("--semantics", choices=["strict", "wrap"], default="strict")
    ap.add_argument("--program", default=None)
    ap.add_argument("--dump", action="store_true")
    args = ap.parse_args()

    sem = "strict" if args.semantics == "strict" else "wrap"
    mod = args.mod
    print(f"== static_lab: 区间抽象解释 (semantics={sem}, mod={mod}) ==")

    selected = [p for p in PROGRAMS if args.program in (None, p.name)]
    if not selected:
        print(f"unknown program {args.program}", file=sys.stderr)
        return 2

    if args.dump:
        for p in selected:
            for line in render(p):
                print(line)
            print()

    total_warn = 0
    for p in selected:
        warnings, IN, rounds = analyze(p, sem, mod)
        total_warn += len(warnings)
        print(f"\n[{p.name}]  rounds={rounds}")
        if warnings:
            for w in warnings:
                print("  WARNING " + w)
        else:
            print("  no warning")
        print("  witness: " + p.witness_note)
        if p.witness:
            try:
                for arr, idx in concrete_checks(p, p.witness):
                    size = p.arrays[arr]
                    state = "in bounds" if 0 <= idx < size else "OUT OF BOUNDS"
                    print(f"  concrete: {arr}[{idx}] -> {state}")
            except (KeyError, ValueError, ZeroDivisionError) as exc:
                print(f"  concrete: unavailable ({exc})")

    print(f"\nsummary: programs={len(selected)} warnings={total_warn}")
    print("note: warning 是近似；no warning 不证明安全。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
