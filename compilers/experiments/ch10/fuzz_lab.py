#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fuzz_lab.py -- 第 10 章实验：覆盖率引导的差分 fuzz + 最小化。

目标是一个很小的表达式语言：
    expr := term (('+'|'-') term)*
    term := factor (('*'|'/') factor)*
    factor := '-' factor | INT | 'x' | '(' expr ')'

解释器是语义基准；optimize() 做常量折叠与代数化简。为了教学，
optimize() 里故意放了两条不安全的规则：
    e / e   -> 1          （e 求值为 0 时原程序除零，优化后不除零）
    0 / e   -> 0          （同上）
差分 oracle 在若干 x 取值上比较“解释原式”与“解释优化后表达式”。
两者不一致就是一个 bug；对失败输入做 token 级 ddmin 缩减。

用法：
    python3 fuzz_lab.py --seed 20261020 --iters 4000
    python3 fuzz_lab.py --seed 20261020 --iters 4000 --oracle=skip-errors
    python3 fuzz_lab.py --seed 20261020 --iters 4000 --dedup=symptom
"""

from __future__ import annotations

import argparse
import copy
import random
import re
import sys

ENVS = [0, 1, -1, 2, -2, 3]
TOKEN = re.compile(r"\d+|x|[-+*/()]")


# ---------- 解析 ----------

class ParseError(ValueError):
    pass


class Parser:
    def __init__(self, src: str):
        self.src = "".join(src.split())
        self.i = 0

    def peek(self) -> str:
        if self.i >= len(self.src):
            return ""
        return self.src[self.i]

    def eat(self) -> str:
        ch = self.peek()
        self.i += 1
        return ch

    def parse(self):
        node = self.expr()
        if self.i != len(self.src):
            raise ParseError(f"trailing input at {self.i}")
        return node

    def expr(self):
        node = self.term()
        while self.peek() and self.peek() in "+-":
            op = self.eat()
            node = ("add" if op == "+" else "sub", node, self.term())
        return node

    def term(self):
        node = self.factor()
        while self.peek() and self.peek() in "*/":
            op = self.eat()
            node = ("mul" if op == "*" else "div", node, self.factor())
        return node

    def factor(self):
        ch = self.peek()
        if ch == "-":
            self.eat()
            return ("neg", self.factor())
        if ch == "(":
            self.eat()
            node = self.expr()
            if self.peek() != ")":
                raise ParseError("missing )")
            self.eat()
            return node
        if ch == "x":
            self.eat()
            return ("var",)
        if ch.isdigit():
            start = self.i
            while self.peek().isdigit():
                self.i += 1
            return ("num", int(self.src[start:self.i]))
        raise ParseError(f"unexpected {ch!r} at {self.i}")


def parse(src: str):
    return Parser(src).parse()


def to_src(node) -> str:
    tag = node[0]
    if tag == "num":
        return str(node[1])
    if tag == "var":
        return "x"
    if tag == "neg":
        return f"(-{to_src(node[1])})"
    op = {"add": "+", "sub": "-", "mul": "*", "div": "/"}[tag]
    return f"({to_src(node[1])} {op} {to_src(node[2])})"


# ---------- 解释器（语义基准） ----------

def c_div(a: int, b: int) -> int:
    if b == 0:
        raise ZeroDivisionError("division by zero")
    q = abs(a) // abs(b)
    return q if (a >= 0) == (b >= 0) else -q


def eval_ast(node, x: int) -> int:
    tag = node[0]
    if tag == "num":
        return node[1]
    if tag == "var":
        return x
    if tag == "neg":
        return -eval_ast(node[1], x)
    a = eval_ast(node[1], x)
    b = eval_ast(node[2], x)
    if tag == "add":
        return a + b
    if tag == "sub":
        return a - b
    if tag == "mul":
        return a * b
    return c_div(a, b)


# ---------- 被测优化器（含两条故意不安全的规则） ----------

RULES = {"fold": 0, "div_self": 0, "zero_div": 0, "identity": 0, "none": 0}


def optimize(node):
    tag = node[0]
    if tag in ("num", "var"):
        return node
    if tag == "neg":
        a = optimize(node[1])
        if a[0] == "num":
            RULES["fold"] += 1
            return ("num", -a[1])
        return ("neg", a)

    a = optimize(node[1])
    b = optimize(node[2])

    if a[0] == "num" and b[0] == "num":
        if tag == "div" and b[1] == 0:
            pass  # 不折叠，留给下面的（错误）规则
        else:
            RULES["fold"] += 1
            if tag == "add":
                return ("num", a[1] + b[1])
            if tag == "sub":
                return ("num", a[1] - b[1])
            if tag == "mul":
                return ("num", a[1] * b[1])
            return ("num", c_div(a[1], b[1]))

    if tag == "div" and a == b:
        RULES["div_self"] += 1
        return ("num", 1)                      # 故意：忽略 a 可能为 0

    if tag == "div" and a == ("num", 0):
        RULES["zero_div"] += 1
        return ("num", 0)                      # 故意：忽略 b 可能为 0

    if tag == "add" and a == ("num", 0):
        RULES["identity"] += 1
        return b
    if tag == "add" and b == ("num", 0):
        RULES["identity"] += 1
        return a
    if tag == "sub" and b == ("num", 0):
        RULES["identity"] += 1
        return a
    if tag == "mul" and b == ("num", 1):
        RULES["identity"] += 1
        return a
    if tag == "mul" and a == ("num", 1):
        RULES["identity"] += 1
        return b

    RULES["none"] += 1
    return (tag, a, b)


# ---------- 覆盖率：AST 形状特征 ----------

def features(node) -> set[tuple]:
    out: set[tuple] = set()

    def walk(n, depth: int) -> None:
        d = min(depth, 3)
        tag = n[0]
        if tag in ("num", "var"):
            out.add((tag, d))
            return
        if tag == "neg":
            out.add((tag, d, n[1][0]))
            walk(n[1], depth + 1)
            return
        out.add((tag, n[1][0], n[2][0], d))
        walk(n[1], depth + 1)
        walk(n[2], depth + 1)

    walk(node, 0)
    return out


# ---------- 差分 oracle ----------

def diff(node, oracle: str):
    """返回 (env, expected, actual) 或 None。expected/actual 用 'ERR' 表示除零。"""
    opt = optimize(node)
    for x in ENVS:
        try:
            expected = eval_ast(node, x)
        except ZeroDivisionError:
            expected = "ERR"
        try:
            actual = eval_ast(opt, x)
        except ZeroDivisionError:
            actual = "ERR"
        if oracle == "skip-errors":
            if expected == "ERR" or actual == "ERR":
                continue          # 错误被当作“环境问题”跳过：错误 oracle
        if expected != actual:
            return x, expected, actual
    return None


# ---------- 变异 ----------

def collect(node) -> list:
    out = [node]
    if node[0] != "num" and node[0] != "var":
        for child in node[1:]:
            out.extend(collect(child))
    return out


def rand_atom(rng: random.Random):
    return rng.choice([("var",), ("num", rng.choice([0, 1, 2, 3, 7, -1]))])


def rand_expr(depth: int, rng: random.Random):
    if depth <= 0 or rng.random() < 0.35:
        return rand_atom(rng)
    op = rng.choice(["add", "sub", "mul", "div"])
    return (op, rand_expr(depth - 1, rng), rand_expr(depth - 1, rng))


def replace_node(node, target_id: int, repl, counter=None):
    """按先序遍历编号替换一棵子树；返回新树。"""
    if counter is None:
        counter = [0]

    def walk(n):
        idx = counter[0]
        counter[0] += 1
        if idx == target_id:
            return copy.deepcopy(repl)
        if n[0] in ("num", "var"):
            return n
        if n[0] == "neg":
            return ("neg", walk(n[1]))
        return (n[0], walk(n[1]), walk(n[2]))

    return walk(node)


def mutate(node, rng: random.Random):
    nodes = collect(node)
    n = len(nodes)
    choice = rng.random()
    if choice < 0.5:
        target = rng.randrange(n)
        return replace_node(node, target, rand_expr(2, rng))
    if choice < 0.75:
        target = rng.randrange(n)
        source = rng.choice(nodes)
        return replace_node(node, target, source)
    if choice < 0.9:
        # 把一个子树包进新的二元运算
        target = rng.randrange(n)
        op = rng.choice(["add", "sub", "mul", "div"])
        wrapped = (op, copy.deepcopy(nodes[target]), rand_atom(rng))
        return replace_node(node, target, wrapped)
    # 常量扰动
    target = rng.randrange(n)
    return replace_node(node, target, ("num", rng.randrange(-2, 8)))


# ---------- 最小化 ----------

def fails(src: str) -> bool:
    try:
        node = parse(src)
    except ParseError:
        return False
    return diff(node, "exact") is not None


def ddmin(src: str) -> str:
    toks = TOKEN.findall(src)
    if not fails("".join(toks)):
        return src
    n = 2
    while len(toks) >= 2:
        chunk = max(1, (len(toks) + n - 1) // n)
        reduced = False
        for start in range(0, len(toks), chunk):
            cand = "".join(toks[:start] + toks[start + chunk:])
            if cand and fails(cand):
                toks = TOKEN.findall(cand)
                n = max(2, n - 1)
                reduced = True
                break
        if not reduced:
            if n >= len(toks):
                break
            n = min(len(toks), n * 2)
    return "".join(toks)


# ---------- 主循环 ----------

SEEDS = [
    "x + 1",
    "(x + 2) * 3",
    "x / (x + 2)",
    "2 * (x - 1)",
    "(x + 1) / (x + 2)",
    "0 / (x + 2)",
    "x * x + 2 * x + 1",
    "1 / (x + 1)",
    "(x - 1) * (x + 1)",
    "x - (x + 1)",
    "0 * (x + 3)",
    "(x + 1) / (x - 1)",
]


def classify(node) -> str:
    if node[0] == "div" and node[1] == node[2]:
        return "div_self"
    if node[0] == "div" and node[1] == ("num", 0):
        return "zero_div"
    return "other"


def shrink_tree(node):
    """反复用“仍然失败的最小子树”替换当前树。"""
    cur = node
    while True:
        for sub in collect(cur)[1:]:
            if diff(sub, "exact") is not None:
                cur = sub
                break
        else:
            return cur


def minimize(node):
    """子树收缩 + 用 x/0/1 替换子树 + token ddmin。"""
    cur = shrink_tree(node)
    for _ in range(40):
        improved = False
        size = len(collect(cur))
        for idx in range(size):
            for repl in (("var",), ("num", 0), ("num", 1)):
                cand = replace_node(cur, idx, repl)
                if to_src(cand) == to_src(cur):
                    continue
                if diff(cand, "exact") is not None:
                    cur = cand
                    improved = True
                    break
            if improved:
                break
        if not improved:
            break
    src = to_src(shrink_tree(cur))
    if fails(src):
        src = ddmin(src)
    return parse(src)


def main() -> int:

    ap = argparse.ArgumentParser()
    ap.add_argument("--seed", type=int, default=20261020)
    ap.add_argument("--iters", type=int, default=4000)
    ap.add_argument("--oracle", choices=["exact", "skip-errors"], default="exact")
    ap.add_argument("--dedup", choices=["source", "symptom"], default="source")
    ap.add_argument("--trace", action="store_true")
    args = ap.parse_args()

    rng = random.Random(args.seed)
    corpus: list[str] = []
    seen: set[tuple] = set()
    for s in SEEDS:
        node = parse(s)
        corpus.append(s)
        seen |= features(node)

    bugs: dict[str, dict] = {}
    executions = 0
    parse_fail = 0
    mismatches = 0
    other = 0

    for it in range(1, args.iters + 1):
        src = rng.choice(corpus)
        node = parse(src)
        child = mutate(node, rng)
        out = to_src(child)
        try:
            parsed = parse(out)
        except ParseError:
            parse_fail += 1
            continue

        executions += 1
        new = features(parsed) - seen
        if new:
            seen |= new
            corpus.append(out)

        if args.trace and it % 1000 == 0:
            print(f"[iter {it}] corpus={len(corpus)} features={len(seen)} "
                  f"mismatches={mismatches} classes={len(bugs)}")

        hit = diff(parsed, args.oracle)
        if hit is None:
            continue

        mismatches += 1
        small_node = minimize(parsed)
        cls = classify(small_node)
        small = to_src(small_node)
        if cls == "other":
            other += 1
            continue
        if cls not in bugs or len(small) < len(bugs[cls]["src"]):
            found = diff(small_node, "exact") or hit
            x, expected, actual = found
            bugs[cls] = {"src": small, "cls": cls, "x": x,
                         "expected": expected, "actual": actual}
            if args.trace:
                print(f"[iter {it}] NEW BEST {cls}: {small!r} x={x} "
                      f"expected={expected} actual={actual}")

    if args.dedup == "symptom":
        unique = {"hidden-division-by-zero": 1} if bugs else {}
    else:
        unique = bugs

    print(f"seed={args.seed} iters={args.iters} oracle={args.oracle}")
    print(f"executions={executions} parse_failures={parse_fail} "
          f"corpus={len(corpus)} features={len(seen)} rule_hits={sum(RULES.values())}")
    print("optimizer rule hits: " + " ".join(f"{k}={v}" for k, v in RULES.items()))
    print(f"mismatches={mismatches} other_classes={other} "
          f"unique_after_dedup({args.dedup})={len(unique)}")
    for cls, bug in sorted(bugs.items()):
        print(f"  {cls}: minimized={bug['src']!r} env x={bug['x']} "
              f"expected={bug['expected']} actual={bug['actual']}")
    if not bugs:
        print("  no bug found")
    return 0


if __name__ == "__main__":
    sys.exit(main())
