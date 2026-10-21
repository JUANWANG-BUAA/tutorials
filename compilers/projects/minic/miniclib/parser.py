"""Recursive-descent parser with a Pratt expression parser.

Statements are parsed by recursive descent; binary expressions use binding
powers, so precedence lives in one table (nodes.BIN_PREC) instead of one
function per level.
"""

from __future__ import annotations

from .errors import MiniError, Span
from .lexer import Token
from .nodes import (
    Assign, Binary, Block, BIN_PREC, Call, Decl, ExprStmt, Function, If,
    IntLit, Print, Program, Return, Unary, UNARY_PREC, Var, While,
)

MAX_DEPTH = 200


class Parser:
    def __init__(self, tokens: list[Token], filename: str = "<source>"):
        self.tokens = tokens
        self.filename = filename
        self.pos = 0
        self.depth = 0

    # -- token helpers -----------------------------------------------------
    def peek(self, offset: int = 0) -> Token:
        j = self.pos + offset
        return self.tokens[j] if j < len(self.tokens) else self.tokens[-1]

    def advance(self) -> Token:
        tok = self.tokens[self.pos]
        if tok.kind != "EOF":
            self.pos += 1
        return tok

    def check(self, kind: str) -> bool:
        return self.peek().kind == kind

    def accept(self, kind: str) -> Token | None:
        if self.check(kind):
            return self.advance()
        return None

    def expect(self, kind: str, what: str) -> Token:
        tok = self.peek()
        if tok.kind != kind:
            raise MiniError(f"expected {what}, found {self._describe(tok)}", tok.span)
        return self.advance()

    @staticmethod
    def _describe(tok: Token) -> str:
        if tok.kind == "EOF":
            return "end of file"
        return f"{tok.kind} {tok.text!r}"

    def _enter(self, tok: Token) -> None:
        self.depth += 1
        if self.depth > MAX_DEPTH:
            raise MiniError("nesting too deep (limit 200)", tok.span)

    def _leave(self) -> None:
        self.depth -= 1

    # -- grammar -----------------------------------------------------------
    def parse_program(self) -> Program:
        start = self.peek().span
        functions: list[Function] = []
        while not self.check("EOF"):
            functions.append(self.parse_function())
        if not functions:
            raise MiniError("expected at least one function definition", start)
        return Program(functions, Span(start.line, start.col, functions[-1].span.end_line, functions[-1].span.end_col))

    def parse_function(self) -> Function:
        start = self.expect("int", "'int' before a function definition").span
        name_tok = self.expect("IDENT", "function name")
        if self.check(";") or self.check("="):
            raise MiniError(
                "global variables are not supported; declare variables inside a function",
                self.peek().span,
            )
        self.expect("(", "'(' after the function name")
        params: list[str] = []
        if not self.check(")"):
            while True:
                self.expect("int", "'int' before a parameter")
                p = self.expect("IDENT", "parameter name")
                params.append(p.text)
                if not self.accept(","):
                    break
        self.expect(")", "')' after the parameter list")
        body = self.parse_block()
        return Function(name_tok.text, params, body, Span(start.line, start.col, body.span.end_line, body.span.end_col))

    def parse_block(self) -> Block:
        start = self.expect("{", "'{'").span
        stmts = []
        while not self.check("}"):
            if self.check("EOF"):
                raise MiniError("unterminated block (missing '}')", start)
            stmts.append(self.parse_stmt())
        end = self.advance().span
        return Block(Span(start.line, start.col, end.end_line, end.end_col), stmts)

    def parse_stmt(self):
        tok = self.peek()
        self._enter(tok)
        try:
            if tok.kind == "int":
                return self.parse_decl()
            if tok.kind == "{":
                return self.parse_block()
            if tok.kind == "if":
                return self.parse_if()
            if tok.kind == "while":
                return self.parse_while()
            if tok.kind == "return":
                start = self.advance().span
                value = self.parse_expr()
                end = self.expect(";", "';' after return expression").span
                return Return(Span(start.line, start.col, end.end_line, end.end_col), value)
            if tok.kind == "print":
                start = self.advance().span
                self.expect("(", "'(' after print")
                value = self.parse_expr()
                self.expect(")", "')' after print argument")
                end = self.expect(";", "';' after print").span
                return Print(Span(start.line, start.col, end.end_line, end.end_col), value)
            if tok.kind == "IDENT" and self.peek(1).kind == "=":
                name = self.advance()
                self.advance()
                value = self.parse_expr()
                end = self.expect(";", "';' after assignment").span
                return Assign(Span(name.span.line, name.span.col, end.end_line, end.end_col), name.text, value)
            start = tok.span
            expr = self.parse_expr()
            end = self.expect(";", "';' after expression").span
            return ExprStmt(Span(start.line, start.col, end.end_line, end.end_col), expr)
        finally:
            self._leave()

    def parse_decl(self):
        start = self.expect("int", "'int'").span
        name = self.expect("IDENT", "variable name")
        init = None
        if self.accept("="):
            init = self.parse_expr()
        end = self.expect(";", "';' after declaration").span
        return Decl(Span(start.line, start.col, end.end_line, end.end_col), name.text, init)

    def parse_if(self):
        start = self.expect("if", "'if'").span
        self.expect("(", "'(' after if")
        cond = self.parse_expr()
        self.expect(")", "')' after if condition")
        then = self.parse_stmt()
        otherwise = None
        if self.accept("else"):
            otherwise = self.parse_stmt()
        end = otherwise.span if otherwise is not None else then.span
        return If(Span(start.line, start.col, end.end_line, end.end_col), cond, then, otherwise)

    def parse_while(self):
        start = self.expect("while", "'while'").span
        self.expect("(", "'(' after while")
        cond = self.parse_expr()
        self.expect(")", "')' after while condition")
        body = self.parse_stmt()
        return While(Span(start.line, start.col, body.span.end_line, body.span.end_col), cond, body)

    # -- expressions -------------------------------------------------------
    def parse_expr(self, min_bp: int = 1):
        tok = self.peek()
        self._enter(tok)
        try:
            left = self.parse_prefix()
            while True:
                op_tok = self.peek()
                bp = BIN_PREC.get(op_tok.kind)
                if bp is None or bp < min_bp:
                    break
                self.advance()
                right = self.parse_expr(bp + 1)
                left = Binary(Span(left.span.line, left.span.col, right.span.end_line, right.span.end_col), op_tok.kind, left, right)
            return left
        finally:
            self._leave()

    def parse_prefix(self):
        tok = self.peek()
        if tok.kind == "INT":
            self.advance()
            return IntLit(tok.span, tok.value)
        if tok.kind == "IDENT":
            self.advance()
            if self.accept("("):
                args = []
                if not self.check(")"):
                    while True:
                        args.append(self.parse_expr())
                        if not self.accept(","):
                            break
                end = self.expect(")", "')' after arguments").span
                return Call(Span(tok.span.line, tok.span.col, end.end_line, end.end_col), tok.text, args)
            return Var(tok.span, tok.text)
        if tok.kind == "(":
            self.advance()
            expr = self.parse_expr()
            self.expect(")", "')' after expression")
            return expr
        if tok.kind in ("-", "!"):
            self.advance()
            operand = self.parse_expr(UNARY_PREC)
            return Unary(Span(tok.span.line, tok.span.col, operand.span.end_line, operand.span.end_col), tok.kind, operand)
        raise MiniError(f"expected an expression, found {self._describe(tok)}", tok.span)


def parse(tokens: list[Token], filename: str = "<source>") -> Program:
    return Parser(tokens, filename).parse_program()
