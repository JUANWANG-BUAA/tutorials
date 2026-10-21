#!/usr/bin/env python3
"""第 5 章数据流实验：同一个 CFG 上的朴素迭代与工作列表。

常量传播是非 SSA 的教学版本：它假定每个使用点都有支配它的定义；
若程序可能先用后定义，UNDEF 必须单独报告，不能当作常量参与折叠。

运行：
    python3 experiments/ch05/dataflow_lab.py

四种分析：
  1. 到达定值（前向 may）
  2. 活跃变量（后向 may）
  3. 可用表达式（前向 must）
  4. 常量传播（前向，平坦格；单值表示所有路径一致）

脚本对每种分析分别跑朴素轮询与工作列表，打印每轮 IN/OUT、块求值次数，
最后用两个反例展示初始化错误：可用表达式的入口边界写成全集，
以及到达定值把 OUT 初始化成全集（得到最大不动点而不是最小不动点）。

退出码 0 表示：两种算法在四种分析上一致、固定点自检通过、
两个反例都按预期给出了不同的（错误的）结果。
"""

from __future__ import annotations

import re
from collections import deque

NAC = "NAC"    # 常量传播的顶：不是常量
UNDEF = "UNDEF"  # 常量传播的底：还没见到定义

ASSIGN = re.compile(r"^([A-Za-z_]\w*)\s*=\s*(.+)$")
BINOP = re.compile(r"^([A-Za-z_]\w*|\d+)\s*([+\-*/])\s*([A-Za-z_]\w*|\d+)$")
CMPOP = re.compile(r"^([A-Za-z_]\w*|\d+)\s*(==|!=|<=|>=|<|>)\s*([A-Za-z_]\w*|\d+)$")
GOTO = re.compile(r"^goto\s+(\w+)$")
IFGOTO = re.compile(r"^if\s+(\w+)\s+goto\s+(\w+)\s+else\s+(\w+)$")
RETURN = re.compile(r"^return(?:\s+(\w+))?$")


def build_cfg():
    """B0 是入口，B1 是循环头，B2/B3 是循环体，B4 是回边块，B5 是出口。

    p、q、n、s 是函数参数；i、k、h、t0、t1、t2、x、y、z 是局部变量。
    p+q 只在 B2 计算；B5 用同一表达式，但零次循环的路径没有计算过它。
    """
    blocks = {
        "B0": {"insns": ["i = 0", "k = 7", "h = 3 * 4"], "term": ("goto", "B1")},
        "B1": {"insns": ["t0 = i < n"], "term": ("if", "t0", "B2", "B5")},
        "B2": {"insns": ["t1 = p + q", "t2 = i == 0"], "term": ("if", "t2", "B3", "B4")},
        "B3": {"insns": ["s = s + t1", "x = k * 6", "y = h + k"], "term": ("goto", "B4")},
        "B4": {"insns": ["i = i + 1"], "term": ("goto", "B1")},
        "B5": {"insns": ["z = p + q"], "term": ("return", "z")},
    }
    entry = "B0"
    order = ["B0", "B1", "B2", "B3", "B4", "B5"]
    succ = {}
    preds = {b: [] for b in blocks}
    for b, blk in blocks.items():
        term = blk["term"]
        if term[0] == "goto":
            succ[b] = [term[1]]
        elif term[0] == "if":
            succ[b] = [term[2], term[3]]
        else:
            succ[b] = []
        for s in succ[b]:
            preds[s].append(b)
    return blocks, entry, order, succ, preds


def parse_uses(insn):
    m = IFGOTO.match(insn)
    if m:
        return {m.group(1)}
    m = RETURN.match(insn)
    if m and m.group(1):
        return {m.group(1)}
    m = ASSIGN.match(insn)
    if not m:
        return set()
    rhs = m.group(2)
    b = BINOP.match(rhs) or CMPOP.match(rhs)
    if b:
        return {x for x in (b.group(1), b.group(3)) if not x.isdigit()}
    return {rhs} if rhs.isidentifier() else set()


def parse_def(insn):
    m = ASSIGN.match(insn)
    return m.group(1) if m else None


def rhs_key(insn):
    """可用的表达式键：去空格的二元/比较表达式；纯数字表达式返回 None。"""
    m = ASSIGN.match(insn)
    if not m:
        return None
    rhs = m.group(2)
    b = BINOP.match(rhs) or CMPOP.match(rhs)
    if not b:
        return None
    if b.group(1).isdigit() and b.group(3).isdigit():
        return None
    return f"{b.group(1)}{b.group(2)}{b.group(3)}"


def expr_operands(key):
    m = BINOP.match(key) or CMPOP.match(key)
    return {x for x in (m.group(1), m.group(3)) if not x.isdigit()}


def all_vars(blocks):
    vs = set()
    for blk in blocks.values():
        for insn in blk["insns"]:
            vs |= parse_uses(insn)
            d = parse_def(insn)
            if d:
                vs.add(d)
    return vs


CP_VARS = set()


def all_defs(blocks, order):
    out = {}
    n = 0
    for b in order:
        for insn in blocks[b]["insns"]:
            d = parse_def(insn)
            if d:
                n += 1
                out[f"d{n}"] = (b, d, insn)
    return out


def block_use_def(blocks, b):
    use, defined = set(), set()
    for insn in blocks[b]["insns"]:
        for v in parse_uses(insn):
            if v not in defined:
                use.add(v)
        d = parse_def(insn)
        if d:
            defined.add(d)
    return use, defined


def reach_gen_kill(blocks, b, defs):
    defined = {var for (bb, var, _) in defs.values() if bb == b}
    kill = {d for d, (bb, var, _) in defs.items() if var in defined and bb != b}
    last = {}
    for d, (bb, var, _) in defs.items():
        if bb == b:
            last[var] = d
    gen = set(last.values())
    kill -= gen
    return gen, kill


def avail_universe(blocks):
    u = set()
    for blk in blocks.values():
        for insn in blk["insns"]:
            k = rhs_key(insn)
            if k:
                u.add(k)
    return u


def avail_gen_kill(blocks, b, universe):
    gen, kill = set(), set()
    defined = set()
    for insn in blocks[b]["insns"]:
        k = rhs_key(insn)
        if k:
            gen.add(k)
        d = parse_def(insn)
        if d:
            defined.add(d)
            dead = {e for e in universe if d in expr_operands(e)}
            kill |= dead
            gen -= dead
    return gen, kill


# ---------- 通用求解器 ----------

def solve_forward(blocks, order, entry, transfer, init_out, boundary, join, identity):
    inn = {b: init_out() for b in blocks}
    out = {b: init_out() for b in blocks}
    rounds = 0
    evals = 0
    trace = []
    while True:
        rounds += 1
        changed = False
        snap = {}
        for b in order:
            if b == entry:
                new_in = boundary()
            else:
                new_in = identity()
                for p in blocks[b]["preds"]:
                    new_in = join(new_in, out[p])
            new_out = transfer(b, new_in)
            evals += 1
            if new_in != inn[b] or new_out != out[b]:
                changed = True
            inn[b], out[b] = new_in, new_out
            snap[b] = (new_in, new_out)
        trace.append((rounds, snap, changed))
        if not changed:
            break
    return inn, out, rounds, evals, trace


def solve_forward_worklist(blocks, entry, transfer, init_out, boundary, join, identity):
    inn = {b: init_out() for b in blocks}
    out = {b: init_out() for b in blocks}
    q = deque([entry])
    inq = {entry}
    pops = 0
    updates = 0
    steps = []
    while q:
        b = q.popleft()
        inq.discard(b)
        pops += 1
        if b == entry:
            new_in = boundary()
        else:
            new_in = identity()
            for p in blocks[b]["preds"]:
                new_in = join(new_in, out[p])
        new_out = transfer(b, new_in)
        if new_in != inn[b] or new_out != out[b]:
            updates += 1
            inn[b], out[b] = new_in, new_out
            steps.append((b, "changed", new_in, new_out))
            for s in blocks[b]["succ"]:
                if s not in inq:
                    q.append(s)
                    inq.add(s)
        else:
            steps.append((b, "same", new_in, new_out))
    return inn, out, pops, updates, steps


def solve_backward(blocks, order, exits, transfer, init_in, boundary, join, identity):
    inn = {b: init_in() for b in blocks}
    out = {b: init_in() for b in blocks}
    rounds = 0
    evals = 0
    trace = []
    while True:
        rounds += 1
        changed = False
        snap = {}
        for b in reversed(order):
            if b in exits:
                new_out = boundary()
            else:
                new_out = identity()
                for s in blocks[b]["succ"]:
                    new_out = join(new_out, inn[s])
            new_in = transfer(b, new_out)
            evals += 1
            if new_in != inn[b] or new_out != out[b]:
                changed = True
            inn[b], out[b] = new_in, new_out
            snap[b] = (new_in, new_out)
        trace.append((rounds, snap, changed))
        if not changed:
            break
    return inn, out, rounds, evals, trace


def solve_backward_worklist(blocks, exits, transfer, init_in, boundary, join, identity):
    inn = {b: init_in() for b in blocks}
    out = {b: init_in() for b in blocks}
    q = deque(sorted(exits))
    inq = set(exits)
    pops = 0
    updates = 0
    steps = []
    while q:
        b = q.popleft()
        inq.discard(b)
        pops += 1
        if b in exits:
            new_out = boundary()
        else:
            new_out = identity()
            for s in blocks[b]["succ"]:
                new_out = join(new_out, inn[s])
        new_in = transfer(b, new_out)
        if new_in != inn[b] or new_out != out[b]:
            updates += 1
            inn[b], out[b] = new_in, new_out
            steps.append((b, "changed"))
            for p in blocks[b]["preds"]:
                if p not in inq:
                    q.append(p)
                    inq.add(p)
        else:
            steps.append((b, "same"))
    return inn, out, pops, updates, steps


# ---------- 具体分析 ----------

def reaching(blocks, entry, order, defs, wrong_top=False):
    def transfer(b, s):
        gen, kill = reach_gen_kill(blocks, b, defs)
        return (s - kill) | gen

    init = lambda: set(defs) if wrong_top else set()
    return solve_forward(blocks, order, entry, transfer, init, lambda: set(), lambda a, c: a | c, lambda: set())


def reaching_worklist(blocks, entry, defs):
    def transfer(b, s):
        gen, kill = reach_gen_kill(blocks, b, defs)
        return (s - kill) | gen
    return solve_forward_worklist(blocks, entry, transfer, lambda: set(), lambda: set(), lambda a, c: a | c, lambda: set())


def liveness(blocks, order, exits):
    def transfer(b, s):
        use, defined = block_use_def(blocks, b)
        return use | (s - defined)
    return solve_backward(blocks, order, exits, transfer, lambda: set(), lambda: set(), lambda a, c: a | c, lambda: set())


def liveness_worklist(blocks, exits):
    def transfer(b, s):
        use, defined = block_use_def(blocks, b)
        return use | (s - defined)
    return solve_backward_worklist(blocks, exits, transfer, lambda: set(), lambda: set(), lambda a, c: a | c, lambda: set())


def available(blocks, entry, order, universe, wrong_entry=False):
    def transfer(b, s):
        gen, kill = avail_gen_kill(blocks, b, universe)
        return gen | (s - kill)

    def init():
        return set(universe)
    boundary = (lambda: set(universe)) if wrong_entry else (lambda: set())
    return solve_forward(blocks, order, entry, transfer, init, boundary,
                         lambda a, c: a & c, lambda: set(universe))


def available_worklist(blocks, entry, universe):
    def transfer(b, s):
        gen, kill = avail_gen_kill(blocks, b, universe)
        return gen | (s - kill)
    return solve_forward_worklist(blocks, entry, transfer, lambda: set(universe),
                                  lambda: set(), lambda a, c: a & c, lambda: set(universe))


def cp_transfer(blocks, b, state):
    st = dict(state)
    for insn in blocks[b]["insns"]:
        m = ASSIGN.match(insn)
        if not m:
            continue
        dst, rhs = m.group(1), m.group(2)
        st[dst] = eval_rhs(rhs, st)
    return st


PARAMS = {"p", "q", "n", "s"}


def eval_rhs(rhs, st):
    if rhs.isdigit():
        return int(rhs)
    if rhs.isidentifier():
        return st.get(rhs, UNDEF)
    m = BINOP.match(rhs)
    if m:
        a, op, c = m.group(1), m.group(2), m.group(3)
        va = int(a) if a.isdigit() else st.get(a, UNDEF)
        vc = int(c) if c.isdigit() else st.get(c, UNDEF)
        if va is NAC or vc is NAC:
            return NAC
        if va is UNDEF or vc is UNDEF:
            return UNDEF
        if op == "+":
            return va + vc
        if op == "-":
            return va - vc
        if op == "*":
            return va * vc
        if vc == 0:
            return NAC  # 不把除零折成常量
        return va // vc
    m = CMPOP.match(rhs)
    if m:
        a, op, c = m.group(1), m.group(2), m.group(3)
        va = int(a) if a.isdigit() else st.get(a, UNDEF)
        vc = int(c) if c.isdigit() else st.get(c, UNDEF)
        if va == NAC or vc == NAC:
            return NAC
        if va == UNDEF or vc == UNDEF:
            return UNDEF
        return int({"==": va == vc, "!=": va != vc, "<": va < vc,
                    ">": va > vc, "<=": va <= vc, ">=": va >= vc}[op])
    return NAC


def cp_join_value(a, b):
    if a == UNDEF:
        return b
    if b == UNDEF:
        return a
    return a if a == b else NAC


def cp_join(a, b):
    keys = set(a) | set(b)
    return {k: cp_join_value(a.get(k, UNDEF), b.get(k, UNDEF)) for k in keys}


def cp_entry_state():
    return {v: (NAC if v in PARAMS else UNDEF) for v in CP_VARS}


def constprop(blocks, entry, order):
    def transfer(b, s):
        return cp_transfer(blocks, b, s)
    init = lambda: {v: UNDEF for v in CP_VARS}
    return solve_forward(blocks, order, entry, transfer, init, cp_entry_state, cp_join, init)


def constprop_worklist(blocks, entry):
    def transfer(b, s):
        return cp_transfer(blocks, b, s)
    init = lambda: {v: UNDEF for v in CP_VARS}
    return solve_forward_worklist(blocks, entry, transfer, init, cp_entry_state, cp_join, init)


# ---------- 检查与反例 ----------

def fixed_point_forward(blocks, entry, inn, out, transfer, boundary, join, identity):
    ok = inn[entry] == boundary()
    bad = []
    for b in blocks:
        if b != entry:
            want = identity()
            for p in blocks[b]["preds"]:
                want = join(want, out[p])
            if want != inn[b]:
                bad.append(b)
        if transfer(b, inn[b]) != out[b]:
            bad.append(b)
    return ok and not bad, bad


def mop_available(blocks, entry, target, universe):
    """枚举不重复块的路径（长度 <= 8），返回到达 target 的各路径的可用集与见证路径。"""
    paths = []

    def transfer(b, s):
        gen, kill = avail_gen_kill(blocks, b, universe)
        return gen | (s - kill)

    def walk(node, state, visited, trail):
        if len(trail) > 8:
            return
        st = transfer(node, state)
        for s in blocks[node]["succ"]:
            if s == target:
                paths.append((st, trail + [s]))
            elif s not in visited:
                walk(s, st, visited | {s}, trail + [s])

    walk(entry, set(), {entry}, [entry])
    result = set(universe)
    for st, _ in paths:
        result &= st
    return result, paths


def fmt_set(s):
    return "{" + ",".join(sorted(s)) + "}" if s else "∅"


def fmt_state(st):
    shown = {k: v for k, v in sorted(st.items()) if v != UNDEF}
    if not shown:
        return "全部 UNDEF"
    return "{" + ",".join(f"{k}={v}" for k, v in shown.items()) + "}，其余 UNDEF"


def print_table(blocks, order, inn, out):
    for b in order:
        print(f"  {b} IN={fmt_set(inn[b]) if isinstance(inn[b], set) else fmt_state(inn[b])}"
              f" OUT={fmt_set(out[b]) if isinstance(out[b], set) else fmt_state(out[b])}")


def main():
    blocks, entry, order, succ, preds = build_cfg()
    global CP_VARS
    CP_VARS = all_vars(blocks)
    for b in blocks:
        blocks[b]["succ"] = succ[b]
        blocks[b]["preds"] = preds[b]
    defs = all_defs(blocks, order)
    universe = avail_universe(blocks)
    exits = {"B5"}

    print("=== CFG（6 块，p/q/n/s 为参数） ===")
    for b in order:
        print(f"{b}: " + " ; ".join(blocks[b]["insns"]) + " ; " + str(blocks[b]["term"]))
    print("前驱：" + "  ".join(f"{b}<-{preds[b]}" for b in order if preds[b]))
    print()

    # 1. 到达定值
    print("=== 1. 到达定值（前向 may，合并=并集） ===")
    inn, out, rounds, evals, trace = reaching(blocks, entry, order, defs)
    for r, snap, changed in trace:
        print(f"-- 第 {r} 轮" + ("（无变化，停止）" if not changed else ""))
        for b in order:
            i, o = snap[b]
            print(f"  {b} IN={fmt_set(i)} OUT={fmt_set(o)}")
    print(f"朴素迭代：轮数={rounds} 块求值={evals}")
    winn, wout, pops, updates, steps = reaching_worklist(blocks, entry, defs)
    print(f"工作列表：pop={pops} 更新={updates} 步序={''.join(s[0] + ('*' if s[1] == 'changed' else ' ') for s in steps)}")
    print(f"两算法一致：{inn == winn and out == wout}")
    print(f"最终 IN[B5]={fmt_set(inn['B5'])}")
    print()

    # 2. 活跃变量
    print("=== 2. 活跃变量（后向 may，合并=并集） ===")
    linn, lout, lrounds, levals, ltrace = liveness(blocks, order, exits)
    print_table(blocks, order, linn, lout)
    lwinn, lwout, lpops, lupdates, _ = liveness_worklist(blocks, exits)
    print(f"朴素：轮数={lrounds} 块求值={levals}；工作列表：pop={lpops} 更新={lupdates}")
    print(f"两算法一致：{linn == lwinn and lout == lwout}")
    print(f"IN[B0]={fmt_set(linn['B0'])}（i 在 B0 定义，不在入口活跃）")
    print()

    # 3. 可用表达式
    print("=== 3. 可用表达式（前向 must，合并=交集） ===")
    ainn, aout, arounds, aevals, _ = available(blocks, entry, order, universe)
    print_table(blocks, order, ainn, aout)
    awinn, awout, apops, aupdates, _ = available_worklist(blocks, entry, universe)
    print(f"朴素：轮数={arounds} 块求值={aevals}；工作列表：pop={apops} 更新={aupdates}")
    print(f"两算法一致：{ainn == awinn and aout == awout}")
    print(f"表达式全集：{fmt_set(universe)}")
    print(f"IN[B5]={fmt_set(ainn['B5'])}（零次循环路径没有计算 p+q）")
    mop, paths = mop_available(blocks, entry, "B5", universe)
    print(f"有界 MOP（{len(paths)} 条简单路径）IN[B5]={fmt_set(mop)}，与不动点一致：{mop == ainn['B5']}")
    for st, trail in paths:
        if "p+q" not in st:
            print("见证路径：" + " -> ".join(trail) + "，该路径不包含 p+q")
            break
    print()

    # 4. 常量传播
    print("=== 4. 常量传播（前向，平坦格） ===")
    cinn, cout, crounds, cevals, _ = constprop(blocks, entry, order)
    for b in order:
        st = cout[b]
        print(f"  {b} OUT: i={st['i']} k={st['k']} h={st['h']} "
              f"x={st['x']} y={st['y']} z={st['z']}")
    cwinn, cwout, cpops, cupdates, _ = constprop_worklist(blocks, entry)
    print(f"朴素：轮数={crounds} 块求值={cevals}；工作列表：pop={cpops} 更新={cupdates}")
    print(f"两算法一致：{cinn == cwinn and cout == cwout}")
    print(f"B3 IN 的 k={cinn['B3']['k']} h={cinn['B3']['h']} i={cinn['B3']['i']}；"
          f"B3 OUT 的 x={cout['B3']['x']} y={cout['B3']['y']}")
    print()

    # 5. 反例 A
    print("=== 反例 A：可用表达式把入口边界写成全集 U ===")
    bad_in, bad_out, br, be, _ = available(blocks, entry, order, universe, wrong_entry=True)
    print(f"错误解的 IN[B5]={fmt_set(bad_in['B5'])}，正确解={fmt_set(ainn['B5'])}")
    print(f"错误解把 p+q 判为在 B5 可用：{'p+q' in bad_in['B5']}；正确解：{'p+q' in ainn['B5']}")
    ok, bad = fixed_point_forward(blocks, entry, bad_in, bad_out,
                                  lambda b, s: (lambda gk: gk[0] | (s - gk[1]))(
                                      avail_gen_kill(blocks, b, universe)),
                                  lambda: set(universe),
                                  lambda a, c: a & c, lambda: set(universe))
    print(f"方程自检（含它自己的边界 U）：{ok}；与 MOP 一致：{bad_in['B5'] == mop}")
    print()

    # 6. 反例 B
    print("=== 反例 B：到达定值把 OUT 初始化成全集 ALL ===")
    top_in, top_out, tr, te, _ = reaching(blocks, entry, order, defs, wrong_top=True)
    print(f"错误解：轮数={tr} 块求值={te}；IN[B5]={fmt_set(top_in['B5'])}（{len(top_in['B5'])} 条定值）")
    print(f"正确解：轮数={rounds} 块求值={evals}；IN[B5]={fmt_set(inn['B5'])}（{len(inn['B5'])} 条定值）")
    print(f"错误解是方程的不动点：{top_out['B1'] == (top_out['B0'] | top_out['B4'])}；"
          f"但它是最大不动点，不是最小不动点")
    print()

    print("=== 固定点自检（正确解） ===")
    ok_r, bad_r = fixed_point_forward(
        blocks, entry, inn, out,
        lambda b, s: (lambda gk: gk[0] | (s - gk[1]))(reach_gen_kill(blocks, b, defs)),
        set, lambda a, c: a | c, set)
    ok_l = all(
        linn[b] == (block_use_def(blocks, b)[0] |
                    (lout[b] - block_use_def(blocks, b)[1])) for b in order)
    ok_a, bad_a = fixed_point_forward(
        blocks, entry, ainn, aout,
        lambda b, s: (lambda gk: gk[0] | (s - gk[1]))(avail_gen_kill(blocks, b, universe)),
        set, lambda a, c: a & c, lambda: set(universe))
    ok_c = all(cout[b] == cp_transfer(blocks, b, cinn[b]) for b in order)
    print(f"到达定值={ok_r} 活跃变量={ok_l} 可用表达式={ok_a} 常量传播={ok_c}")

    good = (inn == winn and out == wout and linn == lwinn and lout == lwout
            and ainn == awinn and aout == awout and cinn == cwinn and cout == cwout
            and ok_r and ok_l and ok_a and ok_c and mop == ainn["B5"]
            and "p+q" in bad_in["B5"] and "p+q" not in ainn["B5"]
            and len(top_in["B5"]) > len(inn["B5"]))
    print("结论：" + ("OK（一致、自检通过、两个反例均按预期偏离）" if good else "FAIL"))
    return 0 if good else 1


if __name__ == "__main__":
    raise SystemExit(main())
