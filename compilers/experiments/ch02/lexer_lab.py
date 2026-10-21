#!/usr/bin/env python3
"""lexer_lab.py — 词法边界与语法错误恢复实验。

覆盖：
  * '--' 是 DECR 还是注释；'- -' 与 '--' 的最小对
  * '1..2'、'1.5'、'1.' 的最长匹配
  * 行注释、块注释、未闭合块注释
  * 关键字与标识符的最长匹配
  * dangling else 的 AST 形状
  * 缺分号、缺标识符、缺操作数的错误恢复
  * 结合性与括号
  * 快照/span/模糊入口自检

只用 Python 标准库；Python 3.11+。
用法：
    python3 experiments/ch02/lexer_lab.py
    python3 experiments/ch02/lexer_lab.py --case range
    python3 experiments/ch02/lexer_lab.py --buggy
    python3 experiments/ch02/lexer_lab.py --selftest
    python3 experiments/ch02/lexer_lab.py --fuzz 400
"""

from __future__ import annotations

import argparse
import random
import sys
from dataclasses import dataclass

MAX_ERRORS = 8


# ---------------------------------------------------------------- data model
@dataclass(frozen=True)
class Span:
    line: int
    col: int
    end_line: int
    end_col: int

    def __str__(self) -> str:
        return f"{self.line}:{self.col}-{self.end_line}:{self.end_col}"


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    span: Span


@dataclass(frozen=True)
class Diagnostic:
    code: str
    message: str
    span: Span
    hint: str = ""
    severity: str = "error"


KEYWORDS = {
    "let": "LET",
    "if": "IF",
    "else": "ELSE",
    "while": "WHILE",
    "print": "PRINT",
}

TWO_CHAR = {
    "==": "EQ",
    "!=": "NE",
    "<=": "LE",
    ">=": "GE",
    "..": "DOTDOT",
    "--": "DECR",
}

SINGLE = {
    "+": "PLUS",
    "-": "MINUS",
    "*": "STAR",
    "/": "SLASH",
    "(": "LPAREN",
    ")": "RPAREN",
    "{": "LBRACE",
    "}": "RBRACE",
    ";": "SEMI",
    "=": "ASSIGN",
    "<": "LT",
    ">": "GT",
}


# ---------------------------------------------------------------- lexer
class Lexer:
    def __init__(self, src: str, buggy_dash: bool = False,
                 buggy_float: bool = False) -> None:
        self.src = src
        self.buggy_dash = buggy_dash
        self.buggy_float = buggy_float
        self.i = 0
        self.line = 1
        self.col = 1
        self.tokens: list[Token] = []
        self.diags: list[Diagnostic] = []
        self.run()

    def peek(self, k: int = 0) -> str:
        j = self.i + k
        return self.src[j] if j < len(self.src) else ""

    def advance(self) -> str:
        ch = self.src[self.i]
        self.i += 1
        if ch == "\n":
            self.line += 1
            self.col = 1
        else:
            self.col += 1
        return ch

    def emit(self, kind: str, text: str, line: int, col: int) -> None:
        self.tokens.append(Token(kind, text, Span(line, col, self.line, self.col)))

    def error(self, code: str, message: str, line: int, col: int,
              end_line: int | None = None, end_col: int | None = None,
              hint: str = "") -> None:
        self.diags.append(
            Diagnostic(
                code,
                message,
                Span(line, col, end_line if end_line is not None else self.line,
                     end_col if end_col is not None else self.col),
                hint,
            )
        )

    def run(self) -> None:
        while self.i < len(self.src):
            c = self.peek()
            if c in " \t\r\n":
                self.advance()
                continue
            if c == "/" and self.peek(1) == "/":
                while self.i < len(self.src) and self.peek() != "\n":
                    self.advance()
                continue
            if c == "/" and self.peek(1) == "*":
                sl, sc = self.line, self.col
                self.advance()
                self.advance()
                closed = False
                while self.i < len(self.src):
                    if self.peek() == "*" and self.peek(1) == "/":
                        self.advance()
                        self.advance()
                        closed = True
                        break
                    self.advance()
                if not closed:
                    self.error("E1002", "块注释未闭合", sl, sc,
                               hint="补上 '*/'；错误 span 延伸到文件结尾")
                continue
            if c == "-" and self.peek(1) == "-":
                if self.buggy_dash:  # 错误版本：把 DECR 当行注释
                    while self.i < len(self.src) and self.peek() != "\n":
                        self.advance()
                    continue
                sl, sc = self.line, self.col
                self.advance()
                self.advance()
                self.emit("DECR", "--", sl, sc)
                continue
            if c.isdigit() or (self.buggy_float and c == "." and self.peek(1).isdigit()):
                sl, sc = self.line, self.col
                text = ""
                if c == ".":
                    text += self.advance()
                    while self.peek().isdigit():
                        text += self.advance()
                else:
                    while self.peek().isdigit():
                        text += self.advance()
                    if self.peek() == ".":
                        nxt = self.peek(1)
                        if self.buggy_float:
                            text += self.advance()
                            while self.peek().isdigit():
                                text += self.advance()
                        elif nxt.isdigit():
                            text += self.advance()
                            while self.peek().isdigit():
                                text += self.advance()
                kind = "FLOAT" if "." in text else "INT"
                self.emit(kind, text, sl, sc)
                continue
            if c.isalpha() or c == "_":
                sl, sc = self.line, self.col
                text = ""
                while self.peek().isalpha() or self.peek().isdigit() or self.peek() == "_":
                    text += self.advance()
                self.emit(KEYWORDS.get(text, "IDENT"), text, sl, sc)
                continue
            pair = self.peek() + self.peek(1)
            if pair in TWO_CHAR:
                sl, sc = self.line, self.col
                self.advance()
                self.advance()
                self.emit(TWO_CHAR[pair], pair, sl, sc)
                continue
            if c in SINGLE:
                sl, sc = self.line, self.col
                self.advance()
                self.emit(SINGLE[c], c, sl, sc)
                continue
            if c == ".":
                sl, sc = self.line, self.col
                self.advance()
                self.error("E1003", "小数点后缺少数字", sl, sc,
                           hint="本语言不支持 '1.'；写 '1.0' 或整数 '1'")
                continue
            sl, sc = self.line, self.col
            self.advance()
            self.error("E1001", f"非法字符 {c!r}", sl, sc)
        self.tokens.append(Token("EOF", "", Span(self.line, self.col, self.line, self.col)))


# ---------------------------------------------------------------- AST
@dataclass(frozen=True)
class Program:
    stmts: tuple
    span: Span


@dataclass(frozen=True)
class Let:
    name: str
    value: object
    span: Span


@dataclass(frozen=True)
class If:
    cond: object
    then: object
    orelse: object
    span: Span


@dataclass(frozen=True)
class Block:
    stmts: tuple
    span: Span


@dataclass(frozen=True)
class Print:
    expr: object
    span: Span


@dataclass(frozen=True)
class ExprStmt:
    expr: object
    span: Span


@dataclass(frozen=True)
class Binary:
    op: str
    left: object
    right: object
    span: Span


@dataclass(frozen=True)
class Unary:
    op: str
    operand: object
    span: Span


@dataclass(frozen=True)
class IntLit:
    value: int
    span: Span


@dataclass(frozen=True)
class FloatLit:
    value: float
    span: Span


@dataclass(frozen=True)
class Var:
    name: str
    span: Span


@dataclass(frozen=True)
class ErrorNode:
    span: Span


STMT_START = {"IDENT", "INT", "FLOAT", "MINUS", "LPAREN", "LET", "IF", "PRINT", "LBRACE"}
SYNC = {"SEMI", "LET", "IF", "PRINT", "LBRACE", "RBRACE", "EOF"}


# ---------------------------------------------------------------- parser
class Parser:
    def __init__(self, tokens: list[Token], diags: list[Diagnostic]) -> None:
        self.tokens = tokens
        self.pos = 0
        self.diags = diags

    def peek(self, k: int = 0) -> Token:
        return self.tokens[min(self.pos + k, len(self.tokens) - 1)]

    def at(self, kind: str) -> bool:
        return self.peek().kind == kind

    def advance(self) -> Token:
        tok = self.peek()
        if tok.kind != "EOF":
            self.pos += 1
        return tok

    def last_span(self) -> Span:
        return self.tokens[self.pos - 1].span if self.pos else self.tokens[0].span

    def error(self, code: str, message: str, tok: Token, hint: str = "") -> None:
        if len(self.diags) >= MAX_ERRORS:
            return
        self.diags.append(Diagnostic(code, message, tok.span, hint))

    def describe(self, tok: Token) -> str:
        if tok.kind == "EOF":
            return "文件结尾"
        return f"'{tok.text}'" if tok.text else tok.kind

    def expect(self, kind: str, display: str, hint: str = "") -> Token | None:
        if self.at(kind):
            return self.advance()
        self.error("E2001", f"期望 {display}，但遇到 {self.describe(self.peek())}",
                   self.peek(), hint)
        return None

    def sync(self) -> None:
        while not self.at("EOF") and self.peek().kind not in SYNC:
            self.advance()
        if self.at("SEMI"):
            self.advance()

    # ---- statements
    def parse_program(self) -> Program:
        stmts = []
        while not self.at("EOF") and len(self.diags) < MAX_ERRORS:
            before = self.pos
            stmt = self.parse_stmt()
            if stmt is not None:
                stmts.append(stmt)
            if self.pos == before:  # 保证前进
                self.advance()
        first = self.tokens[0].span
        end = self.tokens[-1].span
        return Program(tuple(stmts), Span(first.line, first.col, end.end_line, end.end_col))

    def parse_stmt(self):
        tok = self.peek()
        if tok.kind == "LET":
            return self.parse_let()
        if tok.kind == "IF":
            return self.parse_if()
        if tok.kind == "LBRACE":
            return self.parse_block()
        if tok.kind == "PRINT":
            return self.parse_print()
        if tok.kind in STMT_START:
            return self.parse_expr_stmt()
        self.error("E2004", f"无法作为语句开头：{self.describe(tok)}", tok,
                   "跳过该 token，尝试下一个语句")
        self.advance()
        return None

    def parse_let(self):
        kw = self.advance()
        name = self.expect("IDENT", "标识符", "在 'let' 后写变量名")
        if name is None:
            self.sync()
            return ErrorNode(Span(kw.span.line, kw.span.col, self.last_span().end_line,
                                  self.last_span().end_col))
        if not self.expect("ASSIGN", "'='"):
            self.sync()
            return ErrorNode(Span(kw.span.line, kw.span.col, self.last_span().end_line,
                                  self.last_span().end_col))
        value = self.parse_expr(0)
        if isinstance(value, ErrorNode):
            self.sync()
            return ErrorNode(Span(kw.span.line, kw.span.col, value.span.end_line,
                                  value.span.end_col))
        if not self.at("SEMI"):
            self.error("E2001", f"期望 ';'，但遇到 {self.describe(self.peek())}",
                       self.peek(), "在此插入 ';'")
        else:
            self.advance()
        return Let(name.text, value, Span(kw.span.line, kw.span.col,
                                          value.span.end_line, value.span.end_col))

    def parse_print(self):
        kw = self.advance()
        expr = self.parse_expr(0)
        if isinstance(expr, ErrorNode):
            self.sync()
            return ErrorNode(kw.span)
        if not self.at("SEMI"):
            self.error("E2001", f"期望 ';'，但遇到 {self.describe(self.peek())}",
                       self.peek(), "在此插入 ';'")
        else:
            self.advance()
        return Print(expr, Span(kw.span.line, kw.span.col,
                                expr.span.end_line, expr.span.end_col))

    def parse_if(self):
        kw = self.advance()
        if not self.expect("LPAREN", "'('"):
            self.sync()
            return ErrorNode(kw.span)
        cond = self.parse_expr(0)
        self.expect("RPAREN", "')'", "补上右括号")
        then = self.parse_stmt()
        orelse = None
        if self.at("ELSE"):
            self.advance()
            orelse = self.parse_stmt()
        end = (orelse or then or cond).span
        return If(cond, then, orelse, Span(kw.span.line, kw.span.col,
                                           end.end_line, end.end_col))

    def parse_block(self):
        lb = self.advance()
        stmts = []
        while not self.at("RBRACE") and not self.at("EOF") and len(self.diags) < MAX_ERRORS:
            before = self.pos
            stmt = self.parse_stmt()
            if stmt is not None:
                stmts.append(stmt)
            if self.pos == before:
                self.advance()
        if not self.expect("RBRACE", "'}'", "补上 '}'"):
            return ErrorNode(lb.span)
        return Block(tuple(stmts), Span(lb.span.line, lb.span.col,
                                        self.last_span().end_line, self.last_span().end_col))

    def parse_expr_stmt(self):
        expr = self.parse_expr(0)
        if isinstance(expr, ErrorNode):
            self.sync()
            return None
        if not self.at("SEMI"):
            self.error("E2001", f"期望 ';'，但遇到 {self.describe(self.peek())}",
                       self.peek(), "在此插入 ';'")
        else:
            self.advance()
        return ExprStmt(expr, expr.span)

    # ---- Pratt expression parser
    BINDING = {
        "DOTDOT": (1, 2),
        "EQ": (3, 4), "NE": (3, 4), "LT": (3, 4), "LE": (3, 4),
        "GT": (3, 4), "GE": (3, 4),
        "PLUS": (5, 6), "MINUS": (5, 6),
        "STAR": (7, 8), "SLASH": (7, 8),
    }

    def parse_expr(self, min_bp: int):
        tok = self.advance()
        if tok.kind == "INT":
            left = IntLit(int(tok.text), tok.span)
        elif tok.kind == "FLOAT":
            left = FloatLit(float(tok.text), tok.span)
        elif tok.kind == "IDENT":
            left = Var(tok.text, tok.span)
        elif tok.kind == "MINUS":
            left = Unary("-", self.parse_expr(9), tok.span)
        elif tok.kind == "LPAREN":
            left = self.parse_expr(0)
            self.expect("RPAREN", "')'", "补上右括号")
        else:
            if tok.kind != "EOF":
                self.pos -= 1  # 让调用方的 sync 能看到这个 token；EOF 不能回退
            self.error("E2002", f"期望表达式，但遇到 {self.describe(tok)}", tok,
                       "补一个操作数，或删除前面的运算符")
            return ErrorNode(tok.span)
        while True:
            bp = self.BINDING.get(self.peek().kind)
            if bp is None or bp[0] < min_bp:
                break
            op = self.advance()
            right = self.parse_expr(bp[1])
            left = Binary(op.text, left, right, Span(left.span.line, left.span.col,
                                                     right.span.end_line, right.span.end_col))
        return left


# ---------------------------------------------------------------- AST dump
def describe_node(node) -> str:
    if isinstance(node, Program):
        return f"Program @{node.span}"
    if isinstance(node, Let):
        return f"Let {node.name} @{node.span}"
    if isinstance(node, If):
        return f"If @{node.span}"
    if isinstance(node, Block):
        return f"Block @{node.span}"
    if isinstance(node, Print):
        return f"Print @{node.span}"
    if isinstance(node, ExprStmt):
        return f"ExprStmt @{node.span}"
    if isinstance(node, Binary):
        return f"Binary {node.op!r} @{node.span}"
    if isinstance(node, Unary):
        return f"Unary {node.op!r} @{node.span}"
    if isinstance(node, IntLit):
        return f"IntLit {node.value} @{node.span}"
    if isinstance(node, FloatLit):
        return f"FloatLit {node.value} @{node.span}"
    if isinstance(node, Var):
        return f"Var {node.name} @{node.span}"
    if isinstance(node, ErrorNode):
        return f"Error @{node.span}"
    return repr(node)


def children(node):
    if isinstance(node, Program):
        return [("", s) for s in node.stmts]
    if isinstance(node, Let):
        return [("value", node.value)]
    if isinstance(node, If):
        out = [("cond", node.cond), ("then", node.then)]
        if node.orelse is not None:
            out.append(("else", node.orelse))
        return out
    if isinstance(node, Block):
        return [("", s) for s in node.stmts]
    if isinstance(node, Print):
        return [("expr", node.expr)]
    if isinstance(node, ExprStmt):
        return [("expr", node.expr)]
    if isinstance(node, Binary):
        return [("left", node.left), ("right", node.right)]
    if isinstance(node, Unary):
        return [("operand", node.operand)]
    return []


def dump(node, indent: int = 0, label: str = "") -> str:
    pad = "  " * indent
    prefix = f"{label}: " if label else ""
    rows = [f"{pad}{prefix}{describe_node(node)}"]
    for child_label, child in children(node):
        rows.append(dump(child, indent + 1, child_label))
    return "\n".join(rows)


def count_nodes(node) -> int:
    return 1 + sum(count_nodes(c) for _, c in children(node))


# ---------------------------------------------------------------- diagnostics
def render(diag: Diagnostic, src: str) -> None:
    lines = src.split("\n")
    line = lines[diag.span.line - 1] if diag.span.line - 1 < len(lines) else ""
    print(f"  {diag.severity}[{diag.code}] {diag.span.line}:{diag.span.col} {diag.message}")
    print(f"    {line}")
    width = max(1, diag.span.end_col - diag.span.col)
    width = min(width, max(1, len(line) - diag.span.col + 1))
    print("    " + " " * (diag.span.col - 1) + "^" * width)
    if diag.hint:
        print(f"    help: {diag.hint}")


# ---------------------------------------------------------------- cases
CASES = {
    "dash": ("-- 是 DECR，注释是 //", "let x = 10--3;\nlet y = 10 - -3;\n"),
    "range": ("1..2 / 1.5 / 1. 的边界", "let r = 1..2;\nlet f = 1.5;\nlet bad = 1.;\n"),
    "comment": ("行注释、块注释与未闭合块注释",
                "let a = 1; // note\nlet b = 2; /* block */\nlet c = 3; /* open\nmore\n"),
    "keyword": ("关键字与标识符", "let ifx = 1;\nif (ifx) print 2;\n"),
    "dangling": ("dangling else", "if (a) if (b) print 1; else print 2;\n"),
    "recover": ("三种错误恢复",
                "let x = 1 let y = 2;\nlet = 3;\nlet z = 1 + ;\nprint z;\n"),
    "assoc": ("结合性与括号", "print a - b - c;\nprint a - (b - c);\n"),
}


def run_case(name: str) -> None:
    title, src = CASES[name]
    print("=" * 68)
    print(f"case {name}: {title}")
    print("source:")
    for i, line in enumerate(src.split("\n"), 1):
        print(f"{i:3d} | {line}")
    lexer = Lexer(src)
    tokens = lexer.tokens
    print(f"tokens ({len(tokens) - 1} + EOF):")
    for i, tok in enumerate(tokens):
        print(f"  #{i:02d} {tok.kind:<9} {tok.text!r:<12} {tok.span}")
    parser = Parser(tokens, lexer.diags)
    ast = parser.parse_program()
    print("AST:")
    print(dump(ast))
    diags = sorted(lexer.diags, key=lambda d: (d.span.line, d.span.col))
    print(f"diagnostics ({len(diags)}):")
    for diag in diags:
        render(diag, src)
    if name == "dangling":
        print("binding: else -> the nearest unmatched if (inner if at 1:12)")
    print(f"summary: tokens={len(tokens) - 1} nodes={count_nodes(ast)} diagnostics={len(diags)}")
    print()


def buggy() -> int:
    src = "let x = 10--3;\n"
    print("== buggy lexer A: '--' treated as a line comment ==")
    print(f"source: {src.rstrip()}")
    good = Lexer(src)
    bad = Lexer(src, buggy_dash=True)
    print("correct tokens:", " ".join(t.kind for t in good.tokens))
    print("buggy   tokens:", " ".join(t.kind for t in bad.tokens))
    bad_ast = Parser(bad.tokens, list(bad.diags)).parse_program()
    print(f"buggy diagnostics={len(bad.diags)} statements={len(bad_ast.stmts)}")
    print("buggy AST:")
    print(dump(bad_ast))
    print("symptom: '--3;' is gone, 'let x = 10' is accepted without an error")
    print()
    print("== correct lexer: '--' is one DECR token, '- -' is two MINUS ==")
    ok = Lexer(src)
    print("tokens:", " ".join(t.kind for t in ok.tokens))
    diags = list(ok.diags)
    parser = Parser(ok.tokens, diags)
    parser.parse_program()
    diags = sorted(diags, key=lambda d: (d.span.line, d.span.col))
    for diag in diags:
        render(diag, src)
    print()

    src2 = "let r = 1..2;\n"
    print("== buggy lexer B: greedy float regex [0-9]+\\.[0-9]* ==")
    print(f"source: {src2.rstrip()}")
    good2 = Lexer(src2)
    bad2 = Lexer(src2, buggy_float=True)
    print("correct tokens:", " ".join(f"{t.kind}({t.text})" for t in good2.tokens))
    print("buggy   tokens:", " ".join(f"{t.kind}({t.text})" for t in bad2.tokens))
    bad2_ast = Parser(bad2.tokens, list(bad2.diags)).parse_program()
    print(f"buggy diagnostics={len(bad2.diags)} statements={len(bad2_ast.stmts)}")
    print("buggy AST:")
    print(dump(bad2_ast))
    print("symptom: '1..2' becomes two adjacent literals; range is lost")
    return 1


# ---------------------------------------------------------------- selftest
VALID = [
    "let x = 1;",
    "let x = 1 + 2 * 3;",
    "print (1 + 2) * 3;",
    "if (a) print 1; else print 2;",
    "if (a) { print 1; } else { print 2; }",
    "let r = 1..2;",
    "// c\nlet x = 1; /* c */ print x;",
    "let ifx = 1; print ifx;",
]

INVALID = [
    "let = 3;",
    "let x = 1 let y = 2;",
    "let x = 1 + ;",
    "print 1",
    "1 + @;",
    "if (a print 1;",
    "/* open",
    "let r = 1..;",
]


def spans_ok(src: str, tokens: list[Token]) -> bool:
    lines = src.split("\n")
    for tok in tokens:
        if tok.kind == "EOF":
            continue
        if tok.span.line != tok.span.end_line:
            return False
        line = lines[tok.span.line - 1]
        if line[tok.span.col - 1:tok.span.end_col - 1] != tok.text:
            return False
    return True


def selftest() -> int:
    good = 0
    for src in VALID:
        lexer = Lexer(src)
        parser = Parser(lexer.tokens, lexer.diags)
        ast = parser.parse_program()
        if lexer.diags or not spans_ok(src, lexer.tokens) or len(ast.stmts) == 0:
            print(f"FAIL valid: {src!r} diags={[d.message for d in lexer.diags]}")
            return 1
        good += 1
    bad = 0
    for src in INVALID:
        lexer = Lexer(src)
        parser = Parser(lexer.tokens, lexer.diags)
        try:
            parser.parse_program()
        except Exception as exc:  # noqa: BLE001
            print(f"FAIL invalid: {src!r} raised {exc!r}")
            return 1
        if not lexer.diags:
            print(f"FAIL invalid: {src!r} produced no diagnostic")
            return 1
        bad += 1
    print(f"selftest: valid={good}/{len(VALID)} invalid={bad}/{len(INVALID)} spans=ok")
    return 0


ALPHABET = "abcxyz0123+-*/=<>!.(){}; \n@\"'"


def fuzz(n: int, seed: int) -> int:
    rng = random.Random(seed)
    exceptions = 0
    with_diag = 0
    max_tokens = 0
    for _ in range(n):
        src = "".join(rng.choice(ALPHABET) for _ in range(rng.randint(0, 60)))
        try:
            lexer = Lexer(src)
            Parser(lexer.tokens, list(lexer.diags)).parse_program()
        except Exception:  # noqa: BLE001
            exceptions += 1
        if lexer.diags:
            with_diag += 1
        max_tokens = max(max_tokens, len(lexer.tokens))
    print(f"fuzz: seed={seed} inputs={n} exceptions={exceptions} "
          f"with_diagnostics={with_diag} max_tokens={max_tokens}")
    return 0 if exceptions == 0 else 1


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description="lexer and parser lab")
    ap.add_argument("--case", choices=sorted(CASES))
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--buggy", action="store_true")
    ap.add_argument("--selftest", action="store_true")
    ap.add_argument("--fuzz", type=int, default=0)
    ap.add_argument("--seed", type=int, default=20240602)
    args = ap.parse_args(argv)
    if args.list:
        for name, (title, _) in CASES.items():
            print(f"{name:<10} {title}")
        return 0
    if args.selftest:
        return selftest()
    if args.fuzz:
        return fuzz(args.fuzz, args.seed)
    if args.buggy:
        return buggy()
    names = [args.case] if args.case else list(CASES)
    for name in names:
        run_case(name)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
