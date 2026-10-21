#!/usr/bin/env python3
"""第 6 章优化实验：TAC 上的常量传播/折叠、DCE、LICM 与解释器对拍。

运行：
    python3 experiments/ch06/opt_lab.py

每个程序先由解释器执行原始 TAC，再执行优化后的 TAC，比较
(状态, 输出, 返回值)。安全优化必须全部一致；三个故意写错的
优化（折除零、删 print、无条件外提）必须产生可观察差异，
脚本把它们标成 EXPECTED MISMATCH。

退出码 0 表示安全优化全部一致、故意错误全部按预期失败。
"""

from __future__ import annotations

import copy as cp

UNDEF = "UNDEF"
NAC = "NAC"


# ---------- TAC 表示 ----------
# 指令：(op, dst, args)
#   ("const", dst, (n,))
#   ("copy", dst, (src,))
#   ("bin", dst, (op, a, b))    a/b 是变量名或 int
#   ("load", dst, (arr, idx))
#   ("store", None, (arr, idx, val))
#   ("print", None, (val,))
#   ("read", dst, ())
# 终止：(op, ...)
#   ("jmp", label) / ("br", cond, t, f) / ("ret", val|None)


def const(dst, n):
    return ("const", dst, (n,))


def binop(dst, op, a, b):
    return ("bin", dst, (op, a, b))


def load(dst, arr, idx):
    return ("load", dst, (arr, idx))


def store(arr, idx, val):
    return ("store", None, (arr, idx, val))


def pr(v):
    return ("print", None, (v,))


def read(dst):
    return ("read", dst, ())


def program(blocks, arrays=None, params=()):
    return {"blocks": blocks, "arrays": arrays or {}, "params": set(params)}


def mk_programs():
    progs = {}

    progs["const_dce"] = program({
        "B0": ([const("i", 7), const("j", 12), binop("x", "*", "i", 6),
                binop("y", "+", "j", "i"), const("dead", 99),
                pr("x"), pr("y")], ("ret", 0)),
    }, params={"n"})

    progs["div_zero"] = program({
        "B0": ([const("d", 0), binop("q", "/", 100, "d"), pr("q")], ("ret", "q")),
    })

    progs["side_effect"] = program({
        "B0": ([const("x", 1), pr("x"), const("y", 2), pr("y")], ("ret", 0)),
    })

    progs["licm_safe"] = program({
        "B0": ([const("i", 0), const("k", 2)], ("jmp", "B1")),
        "B1": ([binop("c", "<", "i", "n")], ("br", "c", "B2", "B4")),
        "B2": ([binop("t", "*", "k", 3), binop("s", "+", "s", "t"),
                binop("i", "+", "i", 1)], ("jmp", "B1")),
        "B4": ([pr("s")], ("ret", "s")),
    }, params={"n", "s"})

    progs["licm_trap"] = program({
        "B0": ([const("i", 0), const("d", 0)], ("jmp", "B1")),
        "B1": ([binop("c", "<", "i", "n")], ("br", "c", "B2", "B4")),
        "B2": ([binop("q", "/", 100, "d"), binop("s", "+", "s", "q"),
                binop("i", "+", "i", 1)], ("jmp", "B1")),
        "B4": ([pr("s")], ("ret", "s")),
    }, params={"n", "s"})

    progs["licm_alias"] = program({
        "B0": ([const("i", 0)], ("jmp", "B1")),
        "B1": ([binop("c", "<", "i", 2)], ("br", "c", "B2", "B4")),
        "B2": ([binop("v", "+", "i", 1), store("a", "i", "v"),
                load("t", "a", 0), binop("s", "+", "s", "t"),
                binop("i", "+", "i", 1)], ("jmp", "B1")),
        "B4": ([pr("s")], ("ret", "s")),
    }, arrays={"a": [0, 0, 0]}, params={"s"})

    progs["pipeline_order"] = program({
        "B0": ([const("c", 1)], ("br", "c", "B1", "B2")),
        "B1": ([binop("x", "*", 3, 4), pr("x")], ("jmp", "B3")),
        "B2": ([const("dead", 99), pr(99)], ("jmp", "B3")),
        "B3": ([], ("ret", 0)),
    })
    return progs


# ---------- 解释器 ----------

class Trap(Exception):
    pass


def run(prog, inputs, max_steps=10000):
    env = dict(inputs)
    arrays = {k: list(v) for k, v in prog["arrays"].items()}
    out = []
    label = "B0"
    steps = 0
    try:
        while True:
            steps += 1
            if steps > max_steps:
                raise Trap("step limit")
            if label not in prog["blocks"]:
                raise Trap("bad label " + label)
            insns, term = prog["blocks"][label]
            for ins in insns:
                op, dst, args = ins
                if op == "const":
                    env[dst] = args[0]
                elif op == "copy":
                    env[dst] = val_of(args[0], env)
                elif op == "bin":
                    env[dst] = eval_bin(args[0], val_of(args[1], env), val_of(args[2], env))
                elif op == "load":
                    arr = arrays.get(args[0])
                    if arr is None:
                        raise Trap("no array " + args[0])
                    idx = val_of(args[1], env)
                    if idx < 0 or idx >= len(arr):
                        raise Trap("oob load")
                    env[dst] = arr[idx]
                elif op == "store":
                    arr = arrays.get(args[0])
                    if arr is None:
                        raise Trap("no array " + args[0])
                    idx = val_of(args[1], env)
                    if idx < 0 or idx >= len(arr):
                        raise Trap("oob store")
                    arr[idx] = val_of(args[2], env)
                elif op == "print":
                    out.append(val_of(args[0], env))
                elif op == "read":
                    if dst not in inputs:
                        raise Trap("no input " + dst)
                    env[dst] = inputs[dst]
                else:
                    raise Trap("bad op " + op)
            op = term[0]
            if op == "jmp":
                label = term[1]
            elif op == "br":
                label = term[2] if val_of(term[1], env) != 0 else term[3]
            elif op == "ret":
                rv = None if term[1] is None else val_of(term[1], env)
                return ("ok", tuple(out), rv)
            else:
                raise Trap("bad term " + op)
    except Trap as e:
        return ("trap:" + str(e), tuple(out), None)


def val_of(x, env):
    if isinstance(x, int):
        return x
    if x not in env:
        raise Trap("uninitialized " + x)
    return env[x]


def eval_bin(op, a, b):
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    if op == "*":
        return a * b
    if op == "<":
        return int(a < b)
    if op == "==":
        return int(a == b)
    if op == "/":
        if b == 0:
            raise Trap("div0")
        return a // b
    raise Trap("bad bin " + op)


# ---------- 支配与自然循环 ----------

def successors(prog, b):
    term = prog["blocks"][b][1]
    if term[0] == "jmp":
        return [term[1]]
    if term[0] == "br":
        return [term[2], term[3]]
    return []


def preds_of(prog):
    preds = {b: [] for b in prog["blocks"]}
    for b in prog["blocks"]:
        for s in successors(prog, b):
            preds[s].append(b)
    return preds


def dominators(prog):
    blocks = list(prog["blocks"])
    entry = "B0"
    dom = {b: set(blocks) for b in blocks}
    dom[entry] = {entry}
    preds = preds_of(prog)
    changed = True
    while changed:
        changed = False
        for b in blocks:
            if b == entry:
                continue
            ps = preds[b]
            new = set(blocks)
            for p in ps:
                new &= dom[p]
            new |= {b}
            if new != dom[b]:
                dom[b] = new
                changed = True
    return dom


def natural_loops(prog):
    dom = dominators(prog)
    preds = preds_of(prog)
    loops = []
    for b in prog["blocks"]:
        for s in successors(prog, b):
            if s in dom[b]:  # 回边 b -> s
                loop = {s}
                stack = [b]
                while stack:
                    x = stack.pop()
                    if x in loop:
                        continue
                    loop.add(x)
                    for p in preds[x]:
                        if p not in loop:
                            stack.append(p)
                loops.append((s, loop))
    return loops


def loop_exits(prog, loop):
    out = set()
    for b in loop:
        for s in successors(prog, b):
            if s not in loop:
                out.add(b)
    return out


# ---------- 常量传播与折叠 ----------

def uses_of(ins):
    op, dst, args = ins
    if op in ("const", "read"):
        return set()
    if op == "copy":
        return {args[0]} if isinstance(args[0], str) else set()
    if op == "bin":
        return {x for x in (args[1], args[2]) if isinstance(x, str)}
    if op == "load":
        return {x for x in (args[0], args[1]) if isinstance(x, str)}
    if op == "store":
        return {x for x in (args[0], args[1], args[2]) if isinstance(x, str)}
    if op == "print":
        return {args[0]} if isinstance(args[0], str) else set()
    return set()


def cval(st, x):
    return x if isinstance(x, int) else st.get(x, UNDEF)


def cp_join(a, b):
    out = {}
    for k in set(a) | set(b):
        x, y = a.get(k, UNDEF), b.get(k, UNDEF)
        if x == UNDEF:
            out[k] = y
        elif y == UNDEF:
            out[k] = x
        else:
            out[k] = x if x == y else NAC
    return out


def block_states(prog, want_out=False):
    blocks = prog["blocks"]
    entry = "B0"
    preds = preds_of(prog)
    init = {b: {} for b in blocks}
    for b in blocks:
        init[b] = {v: UNDEF for v in all_vars(prog)}
    inn = {b: dict(init[b]) for b in blocks}
    out = {b: dict(init[b]) for b in blocks}
    entry_state = {v: (NAC if v in prog["params"] else UNDEF) for v in all_vars(prog)}
    changed = True
    rounds = 0
    while changed and rounds < 50:
        rounds += 1
        changed = False
        for b in blocks:
            if b == entry:
                new_in = dict(entry_state)
            else:
                new_in = init[b]
                for p in preds[b]:
                    new_in = cp_join(new_in, out[p])
            new_out = cp_transfer(prog, b, new_in)
            if new_in != inn[b] or new_out != out[b]:
                inn[b], out[b] = new_in, new_out
                changed = True
    return out if want_out else inn


def cp_transfer(prog, b, state):
    st = dict(state)
    for ins in prog["blocks"][b][0]:
        op, dst, args = ins
        if op == "const":
            st[dst] = args[0]
        elif op == "copy":
            st[dst] = cval(st, args[0])
        elif op == "bin":
            a, c = cval(st, args[1]), cval(st, args[2])
            st[dst] = fold_bin(args[0], a, c, unsafe=False)
        elif op in ("load", "read"):
            st[dst] = NAC
        # store/print 不改变标量状态
    return st


def fold_bin(op, a, b, unsafe=False):
    """返回常量、UNDEF 或 NAC。unsafe=True 时把除零折成 0。"""
    if a == NAC or b == NAC:
        return NAC
    if a == UNDEF or b == UNDEF:
        return UNDEF
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    if op == "*":
        return a * b
    if op == "<":
        return int(a < b)
    if op == "==":
        return int(a == b)
    if op == "/":
        if b == 0:
            return 0 if unsafe else NAC
        return a // b
    return NAC


def const_fold(prog, unsafe_div=False):
    """重写程序：常量操作数变字面量，可折的表达式折成 const。"""
    p = cp.deepcopy(prog)
    states = block_states(p)
    for b, (insns, term) in p["blocks"].items():
        st = dict(states[b])
        new = []
        for ins in insns:
            op, dst, args = ins
            if op == "const":
                st[dst] = args[0]
                new.append(ins)
                continue
            if op == "copy":
                v = cval(st, args[0])
                if isinstance(v, int):
                    new.append(const(dst, v))
                    st[dst] = v
                else:
                    new.append(ins)
                    st[dst] = v
                continue
            if op == "bin":
                a, c = cval(st, args[1]), cval(st, args[2])
                folded = fold_bin(args[0], a, c, unsafe=unsafe_div)
                if isinstance(folded, int):
                    new.append(const(dst, folded))
                    st[dst] = folded
                else:
                    a2 = a if isinstance(a, int) else args[1]
                    c2 = c if isinstance(c, int) else args[2]
                    new.append(binop(dst, args[0], a2, c2))
                    st[dst] = folded
                continue
            if op == "print":
                v = cval(st, args[0])
                new.append(pr(v if isinstance(v, int) else args[0]))
                continue
            if op == "store":
                arr, idx, val = args
                idx2 = cval(st, idx)
                val2 = cval(st, val)
                new.append(store(arr, idx2 if isinstance(idx2, int) else idx,
                                 val2 if isinstance(val2, int) else val))
                continue
            new.append(ins)
        p["blocks"][b] = (new, term)
    return p


def all_vars(prog):
    vs = set(prog["params"])
    for insns, term in prog["blocks"].values():
        for ins in insns:
            op, dst, args = ins
            if dst:
                vs.add(dst)
            vs |= {x for x in args if isinstance(x, str)}
        if term[0] == "br":
            vs.add(term[1])
        if term[0] == "ret" and isinstance(term[1], str):
            vs.add(term[1])
    return vs


# ---------- 分支化简与不可达块 ----------

def simplify_cfg(prog):
    p = cp.deepcopy(prog)
    changed = True
    while changed:
        changed = False
        states = block_states(p, want_out=True)
        for b, (insns, term) in list(p["blocks"].items()):
            if term[0] == "br":
                v = cval(states[b], term[1])
                if isinstance(v, int):
                    p["blocks"][b] = (insns, ("jmp", term[2] if v != 0 else term[3]))
                    changed = True
        reachable = set()
        stack = ["B0"]
        while stack:
            x = stack.pop()
            if x in reachable or x not in p["blocks"]:
                continue
            reachable.add(x)
            stack.extend(successors(p, x))
        for b in list(p["blocks"]):
            if b not in reachable:
                del p["blocks"][b]
                changed = True
    return p


# ---------- 死代码删除 ----------

def liveness(prog):
    blocks = prog["blocks"]
    preds = preds_of(prog)
    succ = {b: successors(prog, b) for b in blocks}
    inn = {b: set() for b in blocks}
    out = {b: set() for b in blocks}
    changed = True
    while changed:
        changed = False
        for b in blocks:
            new_out = set()
            for s in succ[b]:
                new_out |= inn[s]
            use, define = block_use_def(prog, b)
            new_in = use | (new_out - define)
            if new_in != inn[b] or new_out != out[b]:
                inn[b], out[b] = new_in, new_out
                changed = True
    return inn, out


def block_use_def(prog, b):
    use, define = set(), set()
    for ins in prog["blocks"][b][0]:
        for v in uses_of(ins):
            if v not in define:
                use.add(v)
        if ins[1]:
            define.add(ins[1])
    return use, define


def removable(ins, live):
    op, dst, args = ins
    if op in ("print", "store"):
        return False
    if op == "bin" and args[0] == "/":
        # 除零可能 trap；只有除数是已知非零字面量才可删
        return isinstance(args[2], int) and args[2] != 0 and dst not in live
    if op == "load":
        return False  # 可能越界 trap，保守保留
    if op == "read":
        return False
    return dst is not None and dst not in live


def dce(prog, unsafe=False):
    p = cp.deepcopy(prog)
    changed = True
    while changed:
        changed = False
        inn, out = liveness(p)
        for b, (insns, term) in list(p["blocks"].items()):
            live = set(out[b])
            if term[0] == "br":
                live.add(term[1])
            if term[0] == "ret" and isinstance(term[1], str):
                live.add(term[1])
            keep = []
            for ins in reversed(insns):
                op, dst, args = ins
                if unsafe and op == "print":
                    changed = True   # 故意错误：把副作用当死代码
                    continue
                if removable(ins, live):
                    changed = True
                    continue
                keep.append(ins)
                live -= {dst} if dst else set()
                live |= uses_of(ins)
            p["blocks"][b] = (list(reversed(keep)), term)
    return p


# ---------- 循环不变代码外提 ----------

def speculatable(ins, loop):
    op, dst, args = ins
    if op in ("const", "copy"):
        return True
    if op == "bin":
        if args[0] == "/":
            return isinstance(args[2], int) and args[2] != 0
        return True
    return False


def licm(prog, safe=True):
    p = cp.deepcopy(prog)
    loops = natural_loops(p)
    if not loops:
        return p
    header, loop = loops[0]  # 示例程序只有一个自然循环
    preds = preds_of(p)
    outside = [x for x in preds[header] if x not in loop]
    if len(outside) != 1:
        return p
    pre = outside[0]
    exits = loop_exits(p, loop)
    dom = dominators(p)
    loop_defs = {}
    for b in loop:
        for ins in p["blocks"][b][0]:
            if ins[1]:
                loop_defs.setdefault(ins[1], []).append(b)
    stores = [ins for b in loop for ins in p["blocks"][b][0] if ins[0] == "store"]
    hoisted = set()
    changed = True
    while changed:
        changed = False
        for b in list(loop):
            insns, term = p["blocks"][b][0], p["blocks"][b][1]
            keep = []
            for ins in insns:
                op, dst, args = ins
                inv = all((isinstance(x, int) or x in hoisted or x not in all_defs_set(p, loop))
                          for x in uses_of(ins))
                single = dst is not None and len(loop_defs.get(dst, [])) == 1
                safe_here = True
                if safe:
                    if not speculatable(ins, loop):
                        safe_here = all(b in dom.get(x, set()) for x in exits)
                    if op == "load":
                        safe_here = safe_here and not any(s[2][0] == args[0] for s in stores)
                if inv and single and safe_here and op not in ("store", "print"):
                    p["blocks"][pre] = (p["blocks"][pre][0] + [ins], p["blocks"][pre][1])
                    hoisted.add(dst)
                    changed = True
                else:
                    keep.append(ins)
            if changed:
                p["blocks"][b] = (keep, term)
                loop_defs = {}
                for bb in loop:
                    for ii in p["blocks"][bb][0]:
                        if ii[1]:
                            loop_defs.setdefault(ii[1], []).append(bb)
                break
        # 每次只移动一条，重新计算不变性；示例规模很小
    return p


def all_defs_set(prog, loop=None):
    s = set()
    for b, (insns, _) in prog["blocks"].items():
        if loop is not None and b not in loop:
            continue
        for ins in insns:
            if ins[1]:
                s.add(ins[1])
    return s


# ---------- 打印与对拍 ----------

def fmt_ins(ins):
    op, dst, args = ins
    if op == "const":
        return f"{dst} = {args[0]}"
    if op == "copy":
        return f"{dst} = {args[0]}"
    if op == "bin":
        return f"{dst} = {args[1]} {args[0]} {args[2]}"
    if op == "load":
        return f"{dst} = {args[0]}[{args[1]}]"
    if op == "store":
        return f"{args[0]}[{args[1]}] = {args[2]}"
    if op == "print":
        return f"print {args[0]}"
    if op == "read":
        return f"{dst} = read()"
    return str(ins)


def dump(prog, title):
    print(f"--- {title} ---")
    for b in sorted(prog["blocks"]):
        insns, term = prog["blocks"][b]
        for ins in insns:
            print(f"  {b}: {fmt_ins(ins)}")
        if term[0] == "ret":
            print(f"  {b}: ret {term[1]}")
        elif term[0] == "jmp":
            print(f"  {b}: goto {term[1]}")
        else:
            print(f"  {b}: if {term[1]} goto {term[2]} else {term[3]}")


def count_ins(prog):
    return sum(len(v[0]) for v in prog["blocks"].values())


def compare(name, orig, opt, inputs):
    a = run(orig, inputs)
    b = run(opt, inputs)
    same = a == b
    print(f"{name}: before={a} after={b} match={same}")
    return same


def main():
    progs = mk_programs()
    failures = []

    print("=== 支配与自然循环（licm_safe） ===")
    dom = dominators(progs["licm_safe"])
    for b in sorted(dom):
        print(f"  dom[{b}] = {sorted(dom[b])}")
    loops = natural_loops(progs["licm_safe"])
    for h, lp in loops:
        print(f"  回边目标={h} 循环块={sorted(lp)} 出口块={sorted(loop_exits(progs['licm_safe'], lp))}")
    print()

    dump(licm(progs["licm_safe"], safe=True), "licm_safe 仅做安全 LICM")

    print("=== 安全优化：常量折叠 + DCE + LICM，逐个程序对拍 ===")
    safe_cases = [
        ("const_dce", {"n": 1}),
        ("div_zero", {}),
        ("side_effect", {}),
        ("licm_safe", {"n": 3, "s": 0}),
        ("licm_trap", {"n": 0, "s": 0}),
        ("licm_alias", {"s": 0}),
    ]
    for name, inp in safe_cases:
        orig = progs[name]
        opt = licm(orig, safe=True)
        opt = const_fold(opt)
        opt = dce(opt)
        dump(opt, name + " 优化后")
        if not compare(name, orig, opt, inp):
            failures.append(name)
    print()

    print("=== 反例 1：把 100/0 折成常量 0 ===")
    orig = progs["div_zero"]
    unsafe = const_fold(orig, unsafe_div=True)
    dump(unsafe, "div_zero 错误折叠")
    a = run(orig, {})
    b = run(unsafe, {})
    print(f"正确语义={a} 错误折叠={b} 差异={a != b}")
    if a == b:
        failures.append("div-zero-fold")

    print()
    print("=== 反例 2：把 print 当死代码删掉 ===")
    orig = progs["side_effect"]
    unsafe = dce(orig, unsafe=True)
    dump(unsafe, "side_effect 错误 DCE")
    a = run(orig, {})
    b = run(unsafe, {})
    print(f"正确语义={a} 错误 DCE={b} 差异={a != b}")
    if a == b:
        failures.append("dce-print")

    print()
    print("=== 反例 3：不安全 LICM 外提 100/d ===")
    orig = progs["licm_trap"]
    unsafe = licm(orig, safe=False)
    dump(unsafe, "licm_trap 错误外提")
    a = run(orig, {"n": 0, "s": 0})
    b = run(unsafe, {"n": 0, "s": 0})
    print(f"n=0 正确语义={a} 错误外提={b} 差异={a != b}")
    if a == b:
        failures.append("licm-trap")

    print()
    print("=== 反例 4：不安全 LICM 外提 a[0] 越过 a[i] 写 ===")
    orig = progs["licm_alias"]
    unsafe = licm(orig, safe=False)
    dump(unsafe, "licm_alias 错误外提")
    a = run(orig, {"s": 0})
    b = run(unsafe, {"s": 0})
    print(f"正确语义={a} 错误外提={b} 差异={a != b}")
    if a == b:
        failures.append("licm-alias")

    print()
    print("=== pass 顺序：先折叠后化简 vs 先 DCE 后折叠 ===")
    orig = progs["pipeline_order"]
    a = simplify_cfg(const_fold(orig))
    a = dce(a)
    b = const_fold(dce(orig))
    dump(a, "顺序 A: fold -> simplify -> dce")
    dump(b, "顺序 B: dce -> fold（不再 simplify）")
    print(f"A 指令数={count_ins(a)} B 指令数={count_ins(b)} "
          f"输出一致={run(a, {}) == run(b, {})}")
    b2 = simplify_cfg(b)
    b2 = dce(b2)
    print(f"B 再跑一轮 simplify+dce 后指令数={count_ins(b2)}，与 A 文本相等={a == b2}")
    if count_ins(a) >= count_ins(b):
        failures.append("pipeline-order")

    print()
    print("=== 常量传播的边界 ===")
    print(f"fold_bin('/', 100, 0) = {fold_bin('/', 100, 0)}（NAC，不折）")
    print(f"fold_bin('/', 100, 0, unsafe=True) = {fold_bin('/', 100, 0, unsafe=True)}（错误）")
    print(f"fold_bin('+', UNDEF, 1) = {fold_bin('+', UNDEF, 1)}")
    print()

    print("=== 汇总 ===")
    if failures:
        print("FAIL:", ", ".join(failures))
        return 1
    print("安全优化全部 match；四个故意错误全部按预期 mismatch；顺序差异在固定点后消失")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
