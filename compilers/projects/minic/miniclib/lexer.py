"""Lexer for the minic subset.

The lexer is hand written: one character of lookahead is enough because the
language has no string literals, no preprocessor and no user-defined operators.
Every token carries a line/column span so later stages can report positions.
"""

from __future__ import annotations

from dataclasses import dataclass

from .errors import MiniError, Span

KEYWORDS = {
    "int": "int",
    "if": "if",
    "else": "else",
    "while": "while",
    "return": "return",
    "print": "print",
}

# C keywords that are deliberately outside the subset.  Recognising them here
# turns a confusing parser error ("expected ';'") into a direct diagnostic.
UNSUPPORTED = {
    "for", "do", "break", "continue", "switch", "case", "default", "goto",
    "char", "void", "float", "double", "long", "short", "signed", "unsigned",
    "struct", "union", "enum", "typedef", "sizeof", "static", "extern",
    "const", "volatile", "register", "auto", "inline", "restrict", "bool",
}

TWO_CHAR = {"==", "!=", "<=", ">=", "&&", "||"}
ONE_CHAR = set("+-*/%=<>!(),{};")


@dataclass(frozen=True)
class Token:
    kind: str
    text: str
    span: Span
    value: int | None = None

    def where(self) -> str:
        return f"{self.span.line}:{self.span.col}"


class Lexer:
    def __init__(self, source: str, filename: str = "<source>"):
        self.src = source
        self.filename = filename
        self.i = 0
        self.line = 1
        self.col = 1
        self.tokens: list[Token] = []

    # -- character helpers -------------------------------------------------
    def _peek(self, offset: int = 0) -> str:
        j = self.i + offset
        return self.src[j] if j < len(self.src) else ""

    def _advance(self) -> str:
        ch = self.src[self.i]
        self.i += 1
        if ch == "\n":
            self.line += 1
            self.col = 1
        else:
            self.col += 1
        return ch

    def _span_from(self, line: int, col: int) -> Span:
        return Span(line, col, self.line, self.col)

    # -- scanning ----------------------------------------------------------
    def tokenize(self) -> list[Token]:
        while self.i < len(self.src):
            ch = self._peek()
            if ch in " \t\r\n":
                self._advance()
                continue
            if ch == "/" and self._peek(1) == "/":
                self._line_comment()
                continue
            if ch == "/" and self._peek(1) == "*":
                self._block_comment()
                continue
            if ch.isdigit():
                self._number()
                continue
            if ch.isalpha() or ch == "_":
                self._identifier()
                continue
            two = ch + self._peek(1)
            if two in TWO_CHAR:
                line, col = self.line, self.col
                self._advance()
                self._advance()
                self.tokens.append(Token(two, two, self._span_from(line, col)))
                continue
            hint = {
                "#": "preprocessor directives are not supported",
                "[": "arrays are not supported",
                "]": "arrays are not supported",
                "&": "pointers and address-of are not supported (use && for logical and)",
                "|": "bitwise operators are not supported (use || for logical or)",
            }.get(ch)
            if hint:
                raise MiniError(hint, Span(self.line, self.col, self.line, self.col + 1))
            if ch in ONE_CHAR:
                line, col = self.line, self.col
                self._advance()
                self.tokens.append(Token(ch, ch, self._span_from(line, col)))
                continue
            raise MiniError(f"unexpected character {ch!r}", Span(self.line, self.col, self.line, self.col + 1))
        end = Span(self.line, self.col, self.line, self.col)
        self.tokens.append(Token("EOF", "", end))
        return self.tokens

    def _line_comment(self) -> None:
        while self.i < len(self.src) and self._peek() != "\n":
            self._advance()

    def _block_comment(self) -> None:
        start = Span(self.line, self.col, self.line, self.col + 2)
        self._advance()
        self._advance()
        while self.i < len(self.src):
            if self._peek() == "*" and self._peek(1) == "/":
                self._advance()
                self._advance()
                return
            self._advance()
        raise MiniError("unterminated block comment (missing '*/')", start)

    def _number(self) -> None:
        line, col = self.line, self.col
        start = self.i
        while self._peek().isdigit():
            self._advance()
        text = self.src[start:self.i]
        if self._peek().isalpha() or self._peek() == "_":
            raise MiniError(f"invalid integer literal {text + self._peek()!r}", self._span_from(line, col))
        value = int(text)
        if value > 2**31 - 1:
            raise MiniError(f"integer literal {text} does not fit in 32-bit int", self._span_from(line, col))
        self.tokens.append(Token("INT", text, self._span_from(line, col), value))

    def _identifier(self) -> None:
        line, col = self.line, self.col
        start = self.i
        while self._peek().isalnum() or self._peek() == "_":
            self._advance()
        text = self.src[start:self.i]
        if text in UNSUPPORTED:
            raise MiniError(
                f"minic does not support {text!r}; supported statements are "
                "declaration, assignment, if, while, return and print",
                self._span_from(line, col),
            )
        kind = KEYWORDS.get(text, "IDENT")
        self.tokens.append(Token(kind, text, self._span_from(line, col)))


def lex(source: str, filename: str = "<source>") -> list[Token]:
    return Lexer(source, filename).tokenize()


def format_tokens(tokens: list[Token]) -> str:
    rows = []
    for tok in tokens:
        if tok.kind == "EOF":
            rows.append(f"{'EOF':<8} {'':<12} {tok.span.line}:{tok.span.col}")
            continue
        shown = tok.text.replace("\n", "\\n")
        rows.append(f"{tok.kind:<8} {shown:<12} {tok.span.line}:{tok.span.col}")
    return "\n".join(rows)
