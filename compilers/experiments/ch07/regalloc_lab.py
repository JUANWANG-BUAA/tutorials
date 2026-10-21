#!/usr/bin/env python3
"""regalloc_lab.py -- 教学用寄存器分配实验（第 7 章）。

输入：一段很小的 TAC IR（内嵌在 PROGRAMS 里，也可以 --ir 读文件）。
输出：活跃区间、冲突图、寄存器压力、图着色/线性扫描的分配与溢出槽，
      以及「未分配 IR 解释器 vs 已分配寄存器机模拟器」的差分结果。

只依赖 Python 3.11+ 标准库。默认 K=4，其中 caller-saved 两个、callee-saved 两个，
便于在 8 条以内的小程序上稳定触发溢出与调用点冲突。
"""

from __future__ import annotations

import argparse
import random
import sys
from dataclasses import dataclass, field

MASK = (1 << 64) - 1
CALLER = ["rax", "rcx", "rdx", "rsi", "rdi", "r8", "r9"]
CALLEE = ["rbx", "r12", "r13", "r14", "r15"]
SCRATCH = ["r10", "r11"]
ALL_REGS = CALLER + CALLEE + SCRATCH


def u64(x: int) -> int:
    return x & MASK


def s64(x: int) -> int:
    x &= MASK
    return x - (1 << 64) if (x >> 63) else x


def call_result(fn: str, n: int) -> int:
    """被调用函数的确定性返回值；两种解释器共用。"""
    base = 7 if fn == "g" else 11
    return (n * 37 + base) % 97 - 30


# --------------------------------------------------------------------------- #
# IR
# --------------------------------------------------------------------------- #

@dataclass
class Ins:
    op: str                      # const copy bin call ret label goto br
    dst: str | None = None
    a: object = None
    b: object = None
    label: str | None = None
    fn: str | None = None        # bin: "+"/"-"/"*"；br: 条件；call: 函数名
    idx: int = 0


@dataclass
class Program:
    name: str
    params: list[str]
    ins: list[Ins] = field(default_factory=list)

    def labels(self) -> dict[str, int]:
        return {i.label: k for k, i in enumerate(self.ins) if i.op == "label"}


def atom(tok: str):
    tok = tok.strip()
    if tok.lstrip("-").isdigit():
        return int(tok)
    return tok


def parse_ir(text: str, name: str) -> Program:
    prog = Program(name=name, params=[])
    for raw in text.splitlines():
        line = raw.split("#", 1)[0].strip()
        if not line:
            continue
        if line.startswith("func "):
            head = line[5:].strip()
            fname, rest = head.split("(", 1)
            prog.name = fname.strip()
            prog.params = [p.strip() for p in rest.rstrip(")").split(",") if p.strip()]
            continue
        if line.endswith(":"):
            prog.ins.append(Ins("label", label=line[:-1].strip()))
            continue
        if line.startswith("goto "):
            prog.ins.append(Ins("goto", label=line[5:].strip()))
            continue
        if line.startswith("if "):
            t = line.split()
            # if a < b goto L
            prog.ins.append(Ins("br", a=atom(t[1]), fn=t[2], b=atom(t[3]), label=t[5]))
            continue
        if line.startswith("ret "):
            prog.ins.append(Ins("ret", a=atom(line[4:])))
            continue
        if "=" not in line:
            raise ValueError(f"cannot parse: {raw!r}")
        dst, rhs = (x.strip() for x in line.split("=", 1))
        if rhs.startswith("call "):
            prog.ins.append(Ins("call", dst=dst, fn=rhs[5:].strip()))
        elif len(rhs.split()) == 3 and rhs.split()[1] in "+-*":
            t = rhs.split()
            prog.ins.append(Ins("bin", dst=dst, a=atom(t[0]), b=atom(t[2]), fn=t[1]))
        elif rhs.lstrip("-").isdigit():
            prog.ins.append(Ins("const", dst=dst, a=int(rhs)))
        else:
            prog.ins.append(Ins("copy", dst=dst, a=atom(rhs)))
    for k, ins in enumerate(prog.ins):
        ins.idx = k
    return prog


PROGRAMS: dict[str, str] = {
    "straight": """
func straight(a, b, c, d, e)
  s = a + b
  t = c + d
  u = s + t
  v = u + e
  w = v + s
  x = w + t
  y = x + a
  z = y + b
  q = z + c
  ret q
""",
    "loop": """
func loop(n)
  i = 0
  acc = 1
L1:
  if i < n goto L2
  goto L3
L2:
  acc = acc * 2
  acc = acc + i
  i = i + 1
  goto L1
L3:
  ret acc
""",
    "calls": """
func calls(a, b)
  s = a + b
  d = a - b
  r = call g
  t = s + d
  q = call h
  u = t + q
  v = s + t
  w = u + v
  ret w
""",
    "branch": """
func branch(a, b)
  if a < b goto L1
  x = a - b
  goto L2
L1:
  x = b - a
L2:
  y = x * 2
  ret y
""",
}


# --------------------------------------------------------------------------- #
# CFG、活跃变量、活跃区间
# --------------------------------------------------------------------------- #

def build_cfg(prog: Program):
    n = len(prog.ins)
    labels = prog.labels()
    succ: list[list[int]] = [[] for _ in range(n)]
    for i, ins in enumerate(prog.ins):
        if ins.op == "goto":
            succ[i] = [labels[ins.label]]
        elif ins.op == "br":
            succ[i] = [labels[ins.label]] + ([i + 1] if i + 1 < n else [])
        elif ins.op == "ret":
            succ[i] = []
        elif i + 1 < n:
            succ[i] = [i + 1]
    return succ, labels


def uses_defs(ins: Ins):
    if ins.op == "const":
        return set(), {ins.dst}
    if ins.op == "copy":
        return {ins.a}, {ins.dst}
    if ins.op == "bin":
        return {x for x in (ins.a, ins.b) if isinstance(x, str)}, {ins.dst}
    if ins.op == "call":
        return set(), ({ins.dst} if ins.dst else set())
    if ins.op == "ret":
        return ({ins.a} if isinstance(ins.a, str) else set()), set()
    if ins.op == "br":
        return {x for x in (ins.a, ins.b) if isinstance(x, str)}, set()
    return set(), set()


def liveness(prog: Program, succ):
    n = len(prog.ins)
    live_in = [set() for _ in range(n)]
    live_out = [set() for _ in range(n)]
    changed = True
    while changed:
        changed = False
        for i in range(n - 1, -1, -1):
            out = set()
            for s in succ[i]:
                out |= live_in[s]
            u, d = uses_defs(prog.ins[i])
            inn = u | (out - d)
            if out != live_out[i] or inn != live_in[i]:
                live_out[i], live_in[i] = out, inn
                changed = True
    return live_in, live_out


def all_vregs(prog: Program) -> set[str]:
    out = set(prog.params)
    for ins in prog.ins:
        if ins.dst:
            out.add(ins.dst)
        for x in (ins.a, ins.b):
            if isinstance(x, str):
                out.add(x)
    return out


def loop_depths(prog: Program, succ) -> dict[int, int]:
    """非平凡 SCC 内的指令记为循环体，深度 1（本实验没有嵌套循环）。"""
    n = len(prog.ins)
    index = [None] * n
    low = [0] * n
    on = [False] * n
    stack: list[int] = []
    counter = [0]
    depth = {i: 0 for i in range(n)}

    def strong(v: int):
        index[v] = low[v] = counter[0]
        counter[0] += 1
        stack.append(v)
        on[v] = True
        for w in succ[v]:
            if index[w] is None:
                strong(w)
                low[v] = min(low[v], low[w])
            elif on[w]:
                low[v] = min(low[v], index[w])
        if low[v] == index[v]:
            comp = []
            while True:
                w = stack.pop()
                on[w] = False
                comp.append(w)
                if w == v:
                    break
            if len(comp) > 1:
                for w in comp:
                    depth[w] = 1

    sys.setrecursionlimit(10000)
    for v in range(n):
        if index[v] is None:
            strong(v)
    return depth


@dataclass
class Info:
    vregs: list[str]
    succ: list[list[int]]
    labels: dict[str, int]
    live_in: list[set]
    live_out: list[set]
    start: dict[str, int]
    end: dict[str, int]
    points: dict[str, set]
    cross: dict[str, bool]
    depth: dict[int, int]
    adj: dict[str, set]
    cost: dict[str, int]
    pressure: list[int]
    call_points: list[int]


def analyze(prog: Program) -> Info:
    succ, labels = build_cfg(prog)
    live_in, live_out = liveness(prog, succ)
    depth = loop_depths(prog, succ)
    vregs = sorted(all_vregs(prog))
    points = {v: set() for v in vregs}
    for i in range(len(prog.ins)):
        for v in live_in[i] | live_out[i]:
            points[v].add(i)
        u, d = uses_defs(prog.ins[i])
        for v in u | d:
            if isinstance(v, str):
                points.setdefault(v, set()).add(i)
    start, end = {}, {}
    for v in vregs:
        if not points[v]:
            points[v].add(0)
        start[v], end[v] = min(points[v]), max(points[v])
    call_points = [i for i, ins in enumerate(prog.ins) if ins.op == "call"]
    cross = {v: any(v in live_in[i] for i in call_points) for v in vregs}
    adj = {v: set() for v in vregs}
    for i in range(len(prog.ins)):
        live = sorted(live_in[i])
        for x in range(len(live)):
            for y in range(x + 1, len(live)):
                adj[live[x]].add(live[y])
                adj[live[y]].add(live[x])
        _, d = uses_defs(prog.ins[i])
        for x in d:
            for v in live_out[i]:
                if v != x:
                    adj[x].add(v)
                    adj[v].add(x)
    cost = {v: 0 for v in vregs}
    for i, ins in enumerate(prog.ins):
        u, d = uses_defs(ins)
        for v in u | d:
            if isinstance(v, str):
                cost[v] += 10 ** depth[i]
    pressure = [len(live_in[i] | live_out[i]) for i in range(len(prog.ins))]
    return Info(vregs, succ, labels, live_in, live_out, start, end, points,
                cross, depth, adj, cost, pressure, call_points)


# --------------------------------------------------------------------------- #
# 分配
# --------------------------------------------------------------------------- #

def color_pool(k: int) -> list[str]:
    if k < 1 or k > len(CALLER + CALLEE):
        raise SystemExit(f"K must be 1..{len(CALLER + CALLEE)}")
    # 默认 K=4 时给 2 个 caller-saved + 2 个 callee-saved，
    # 这样调用点约束才会真正改变分配结果。
    pool = CALLER[:2] + CALLEE + CALLER[2:]
    return pool[:k]


@dataclass
class Alloc:
    kind: str
    loc: dict[str, tuple[str, object]]
    spilled: list[str]
    slots: int
    potential: list[str]
    code: list[tuple] = field(default_factory=list)
    spill_moves: int = 0


def graph_color(program: Program, info: Info, k: int, restrict_calls: bool = True):
    colors = color_pool(k)
    allowed = {v: set(colors) for v in info.vregs}
    if restrict_calls:
        for v in info.vregs:
            if info.cross[v]:
                allowed[v] -= set(CALLER)
    remaining = set(info.vregs)
    removed: set[str] = set()
    stack: list[str] = []
    potential: list[str] = []
    while remaining:
        pick = None
        for v in sorted(remaining):
            deg = sum(1 for w in info.adj[v] if w not in removed)
            if deg < k:
                pick = v
                break
        if pick is None:
            pick = min(remaining, key=lambda x: (info.cost[x] / max(1, len(info.adj[x])), x))
            potential.append(pick)
        stack.append(pick)
        removed.add(pick)
        remaining.remove(pick)
    assign: dict[str, str] = {}
    spilled: list[str] = []
    for v in reversed(stack):
        used = {assign[w] for w in info.adj[v] if w in assign}
        cand = [c for c in colors if c in allowed[v] and c not in used]
        if cand:
            assign[v] = cand[0]
        else:
            spilled.append(v)
    spilled = sorted(set(spilled))
    loc = {v: ("reg", r) for v, r in assign.items()}
    for n, v in enumerate(spilled):
        loc[v] = ("slot", n)
    return Alloc("coloring", loc, spilled, len(spilled), potential), assign


def linear_scan(program: Program, info: Info, k: int, restrict_calls: bool = True):
    colors = color_pool(k)
    order = sorted(info.vregs, key=lambda v: (info.start[v], info.end[v], v))
    active: list[str] = []
    assign: dict[str, str] = {}
    spilled: list[str] = []

    def allowed(v: str):
        a = set(colors)
        if restrict_calls and info.cross[v]:
            a -= set(CALLER)
        return a

    for v in order:
        active = [a for a in active if info.end[a] >= info.start[v]]
        used = {assign[a] for a in active}
        free = [c for c in colors if c in allowed(v) and c not in used]
        if free:
            assign[v] = free[0]
        else:
            # 只能抢一个对当前区间合法的寄存器；否则溢出当前区间。
            victims = [a for a in active if assign[a] in allowed(v)]
            if victims:
                victim = max(victims, key=lambda x: (info.end[x], x))
                reg = assign.pop(victim)
                active.remove(victim)
                spilled.append(victim)
                assign[v] = reg
            else:
                spilled.append(v)
                continue
        active.append(v)
        active.sort(key=lambda x: (info.end[x], x))
    spilled = sorted(set(spilled) - set(assign))
    loc = {v: ("reg", r) for v, r in assign.items()}
    for n, v in enumerate(spilled):
        loc[v] = ("slot", n)
    return Alloc("linear", loc, spilled, len(spilled), []), assign


# --------------------------------------------------------------------------- #
# 生成「已分配」指令序列：两地址、最多一个内存操作数
# --------------------------------------------------------------------------- #

class Emitter:
    def __init__(self, prog: Program, alloc: Alloc):
        self.prog = prog
        self.alloc = alloc
        self.code: list[tuple] = []
        self.spill_moves = 0
        self._tmp = 0

    def scratch(self) -> str:
        r = SCRATCH[self._tmp % len(SCRATCH)]
        self._tmp += 1
        return r

    def loc(self, v) -> tuple:
        if isinstance(v, int):
            return ("i", v)
        try:
            kind, val = self.alloc.loc[v]
        except KeyError:
            raise SystemExit(f"vreg {v} has no location") from None
        return ("r", val) if kind == "reg" else ("s", val)

    def note_mem(self, *locs):
        if any(l[0] == "s" for l in locs):
            self.spill_moves += 1

    def mov(self, src: tuple, dst: tuple):
        if src == dst:
            return
        if src[0] == "s" and dst[0] == "s":
            t = ("r", self.scratch())
            self.code.append(("mov", src, t))
            self.code.append(("mov", t, dst))
        else:
            self.code.append(("mov", src, dst))
        self.note_mem(src, dst)

    def emit(self):
        for ins in self.prog.ins:
            if ins.op == "label":
                self.code.append(("label", ins.label))
            elif ins.op == "goto":
                self.code.append(("jmp", ins.label))
            elif ins.op == "const":
                self.mov(("i", ins.a), self.loc(ins.dst))
            elif ins.op == "copy":
                self.mov(self.loc(ins.a), self.loc(ins.dst))
            elif ins.op == "bin":
                dst = self.loc(ins.dst)
                srcs = [self.loc(ins.a), self.loc(ins.b)]
                if dst[0] == "r":
                    self.note_mem(srcs[1])
                    # 两地址 lowering：若目的寄存器正好是第二个源，先 mov 会
                    # 覆盖这个源。此时先算到 scratch，再写回目的寄存器。
                    if srcs[1][0] == "r" and srcs[1][1] == dst[1] and srcs[0] != dst:
                        t = ("r", self.scratch())
                        self.mov(srcs[0], t)
                        self.code.append(("bin", ins.fn, srcs[1], t))
                        self.mov(t, dst)
                    else:
                        self.mov(srcs[0], dst)
                        self.code.append(("bin", ins.fn, srcs[1], dst))
                else:
                    t = ("r", self.scratch())
                    self.mov(srcs[0], t)
                    self.code.append(("bin", ins.fn, srcs[1], t))
                    self.mov(t, dst)
            elif ins.op == "call":
                self.code.append(("call", ins.fn))
                if ins.dst:
                    self.mov(("r", "rax"), self.loc(ins.dst))
            elif ins.op == "ret":
                self.mov(self.loc(ins.a), ("r", "rax"))
                self.code.append(("ret",))
            elif ins.op == "br":
                a, b = self.loc(ins.a), self.loc(ins.b)
                if a[0] != "r":
                    t = ("r", self.scratch())
                    self.mov(a, t)
                    a = t
                self.note_mem(b)
                self.code.append(("cmp", b, a))
                self.code.append(("jcc", ins.fn, ins.label))
        self.alloc.code = self.code
        self.alloc.spill_moves = self.spill_moves
        return self


# --------------------------------------------------------------------------- #
# 两个执行器
# --------------------------------------------------------------------------- #

def run_ref(prog: Program, inputs) -> int:
    env = dict(zip(prog.params, inputs))
    labels = prog.labels()
    pc = 0
    calls = 0
    steps = 0
    while pc < len(prog.ins):
        steps += 1
        if steps > 100000:
            raise RuntimeError("reference interpreter: step limit")
        ins = prog.ins[pc]
        if ins.op == "label":
            pass
        elif ins.op == "goto":
            pc = labels[ins.label]
            continue
        elif ins.op == "br":
            a = env[ins.a] if isinstance(ins.a, str) else ins.a
            b = env[ins.b] if isinstance(ins.b, str) else ins.b
            ok = {"<": a < b, "<=": a <= b, ">": a > b, ">=": a >= b,
                  "==": a == b, "!=": a != b}[ins.fn]
            if ok:
                pc = labels[ins.label]
                continue
        elif ins.op == "const":
            env[ins.dst] = ins.a
        elif ins.op == "copy":
            env[ins.dst] = env[ins.a]
        elif ins.op == "bin":
            a = env[ins.a] if isinstance(ins.a, str) else ins.a
            b = env[ins.b] if isinstance(ins.b, str) else ins.b
            env[ins.dst] = s64({"+" : a + b, "-": a - b, "*": a * b}[ins.fn])
        elif ins.op == "call":
            calls += 1
            if ins.dst:
                env[ins.dst] = call_result(ins.fn, calls)
        elif ins.op == "ret":
            return s64(env[ins.a])
        pc += 1
    return 0


def run_alloc(prog: Program, alloc: Alloc, inputs, clobber: bool = True):
    labels = {op[1]: i for i, op in enumerate(alloc.code) if op[0] == "label"}
    regs = {r: 0 for r in ALL_REGS}
    slots = [0] * max(1, alloc.slots)
    for p, val in zip(prog.params, inputs):
        kind, where = alloc.loc[p]
        if kind == "reg":
            regs[where] = val
        else:
            slots[where] = val

    def read(loc):
        if loc[0] == "i":
            return loc[1]
        if loc[0] == "r":
            return regs[loc[1]]
        return slots[loc[1]]

    def write(loc, val):
        if loc[0] == "r":
            regs[loc[1]] = u64(val)
        elif loc[0] == "s":
            slots[loc[1]] = u64(val)

    pc = 0
    flags = 0
    calls = 0
    steps = 0
    while pc < len(alloc.code):
        steps += 1
        if steps > 100000:
            raise RuntimeError("allocated VM: step limit")
        op = alloc.code[pc]
        kind = op[0]
        if kind == "label":
            pass
        elif kind == "mov":
            src, dst = op[1], op[2]
            if src[0] == "s" and dst[0] == "s":
                raise AssertionError("two memory operands in mov")
            write(dst, read(src))
        elif kind == "bin":
            _, fn, src, dst = op
            if dst[0] != "r":
                raise AssertionError("bin destination must be a register")
            a, b = regs[dst[1]], read(src)
            regs[dst[1]] = u64({"+" : a + b, "-": a - b, "*": a * b}[fn])
        elif kind == "cmp":
            _, src, dst = op
            if src[0] == "s" and dst[0] == "s":
                raise AssertionError("two memory operands in cmp")
            d = s64(read(dst) - read(src))
            flags = -1 if d < 0 else (1 if d > 0 else 0)
        elif kind == "jcc":
            _, cond, label = op
            take = {"<": flags < 0, "<=": flags <= 0, ">": flags > 0,
                    ">=": flags >= 0, "==": flags == 0, "!=": flags != 0}[cond]
            if take:
                pc = labels[label]
                continue
        elif kind == "jmp":
            pc = labels[op[1]]
            continue
        elif kind == "call":
            calls += 1
            if clobber:
                for n, r in enumerate(CALLER + SCRATCH):
                    regs[r] = u64(0xC0DE0000 + calls * 0x1000 + n)
            regs["rax"] = u64(call_result(op[1], calls))
        elif kind == "ret":
            return s64(regs["rax"])
        pc += 1
    return 0


# --------------------------------------------------------------------------- #
# 报告
# --------------------------------------------------------------------------- #

def fmt_loc(loc: tuple) -> str:
    if loc[0] == "r":
        return "%" + loc[1]
    if loc[0] == "s":
        return f"[spill+{loc[1] * 8}]"
    return str(loc[1])


def show_intervals(prog: Program, info: Info):
    print("vreg      def  last  points                         cross-call  deg  cost  score")
    for v in info.vregs:
        pts = ",".join(str(i) for i in sorted(info.points[v]))
        score = info.cost[v] / max(1, len(info.adj[v]))
        print(f"  {v:<7} {info.start[v]:>3}  {info.end[v]:>4}  {pts:<30} "
              f"{'yes' if info.cross[v] else 'no':<10} {len(info.adj[v]):>3}  "
              f"{info.cost[v]:>4}  {score:>5.2f}")


def show_graph(info: Info):
    edges = []
    for v in info.vregs:
        for w in sorted(info.adj[v]):
            if v < w:
                edges.append(f"{v}-{w}")
    print(f"interference edges ({len(edges)}): " + " ".join(edges))


def show_alloc(alloc: Alloc):
    regs = [(v, l[1]) for v, l in sorted(alloc.loc.items()) if l[0] == "reg"]
    slots = [(v, l[1]) for v, l in sorted(alloc.loc.items()) if l[0] == "slot"]
    print("  regs : " + "  ".join(f"{v}->%{r}" for v, r in regs))
    if slots:
        print("  spill: " + "  ".join(f"{v}->slot{v}" for _, v in slots))
    print(f"  spilled={alloc.spilled or '-'}  slots={alloc.slots}  "
          f"potential={alloc.potential or '-'}")


def show_code(alloc: Alloc):
    print("  allocated code:")
    for n, op in enumerate(alloc.code):
        if op[0] == "label":
            print(f"    {n:>2} {op[1]}:")
        elif op[0] == "mov":
            print(f"    {n:>2} mov {fmt_loc(op[1])}, {fmt_loc(op[2])}")
        elif op[0] == "bin":
            print(f"    {n:>2} {op[1]} {fmt_loc(op[2])}, {fmt_loc(op[3])}")
        elif op[0] == "cmp":
            print(f"    {n:>2} cmp {fmt_loc(op[1])}, {fmt_loc(op[2])}")
        elif op[0] == "jcc":
            print(f"    {n:>2} j{op[1]} {op[2]}")
        elif op[0] == "jmp":
            print(f"    {n:>2} jmp {op[1]}")
        elif op[0] == "call":
            print(f"    {n:>2} call {op[1]}")
        elif op[0] == "ret":
            print(f"    {n:>2} ret")


def run_program(name: str, text: str, k: int, cases: int, seed: int, verbose: bool,
                dump_code: bool = False):
    prog = parse_ir(text, name)
    info = analyze(prog)
    print(f"\n== {prog.name} ==")
    tac_ops = sum(1 for i in prog.ins if i.op != "label")
    print(f"TAC ops={tac_ops}  vregs={len(info.vregs)}  "
          f"max_pressure={max(info.pressure)} at point {info.pressure.index(max(info.pressure))}")
    if verbose:
        show_intervals(prog, info)
        show_graph(info)
        print("pressure per point: " + " ".join(f"{i}:{p}" for i, p in enumerate(info.pressure)))
    else:
        print("intervals: " + "  ".join(
            f"{v}[{info.start[v]},{info.end[v]}]{'*' if info.cross[v] else ''}" for v in info.vregs))
        print(f"interference edges={sum(len(info.adj[v]) for v in info.vregs) // 2}")
    print(f"callee-saved live-across-call: "
          f"{[v for v in info.vregs if info.cross[v]] or '-'}")

    results = {}
    for kind in ("coloring", "linear"):
        if kind == "coloring":
            alloc, _ = graph_color(prog, info, k)
        else:
            alloc, _ = linear_scan(prog, info, k)
        Emitter(prog, alloc).emit()
        results[kind] = alloc
        print(f"\n[{kind}]")
        show_alloc(alloc)
        print(f"  allocated ops={sum(1 for op in alloc.code if op[0] != 'label')} "
              f"(tac={tac_ops}, spill moves={alloc.spill_moves})")
        if dump_code:
            show_code(alloc)

    rng = random.Random(seed)
    for kind, alloc in results.items():
        bad = 0
        first = None
        for c in range(cases):
            vals = [rng.randint(-40, 40) for _ in prog.params]
            if "n" in prog.params:
                vals[prog.params.index("n")] = rng.randint(0, 8)
            want = run_ref(prog, vals)
            got = run_alloc(prog, alloc, vals, clobber=True)
            if want != got:
                bad += 1
                if first is None:
                    first = (c, vals, want, got)
        if bad:
            print(f"  differential {kind}: {cases - bad}/{cases} match  FIRST MISMATCH {first}")
        else:
            print(f"  differential {kind}: {cases}/{cases} match")
    return prog, info, results


def negative_control(prog: Program, info: Info, k: int, cases: int, seed: int):
    print("\n== negative control: allow caller-saved across call ==")
    alloc, _ = graph_color(prog, info, k, restrict_calls=False)
    Emitter(prog, alloc).emit()
    show_alloc(alloc)
    bad = [v for v in info.vregs
           if info.cross[v] and alloc.loc[v][0] == "reg" and alloc.loc[v][1] in CALLER]
    print(f"  cross-call values in caller-saved: {bad or '-'}")
    rng = random.Random(seed)
    for c in range(cases):
        vals = [rng.randint(-40, 40) for _ in prog.params]
        want = run_ref(prog, vals)
        got = run_alloc(prog, alloc, vals, clobber=True)
        if want != got:
            print(f"  case {c}: inputs={vals} reference={want} allocated={got}")
            for v in bad:
                print(f"    {v}: assigned %{alloc.loc[v][1]}, live across call, "
                      f"clobbered by the callee")
            print(f"  negative control OK: the unconstrained allocator is wrong on "
                  f"{'this case' if c == 0 else f'case {c}'}")
            return True
    print("  negative control FAILED: bug not triggered")
    return False


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--program", default="all", choices=["all", *PROGRAMS])
    ap.add_argument("--k", type=int, default=4)
    ap.add_argument("--cases", type=int, default=200)
    ap.add_argument("--seed", type=int, default=20261020)
    ap.add_argument("--dump-intervals", action="store_true")
    ap.add_argument("--dump-code", action="store_true")
    ap.add_argument("--no-negative-control", action="store_true")
    args = ap.parse_args()

    colors = color_pool(args.k)
    print("regalloc_lab  seed=%d  K=%d  colors=%s" % (args.seed, args.k, ",".join(colors)))
    print("caller-saved: " + ",".join(c for c in colors if c in CALLER))
    print("callee-saved: " + (",".join(c for c in colors if c in CALLEE) or "-"))
    names = list(PROGRAMS) if args.program == "all" else [args.program]
    ok = True
    seen = {}
    for name in names:
        prog, info, _ = run_program(name, PROGRAMS[name], args.k, args.cases,
                                     args.seed, args.dump_intervals, args.dump_code)
        seen[name] = (prog, info)
    if not args.no_negative_control and "calls" in seen:
        prog, info = seen["calls"]
        ok = negative_control(prog, info, args.k, 8, args.seed) and ok
    print("\nsummary: " + ("OK" if ok else "FAIL"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
