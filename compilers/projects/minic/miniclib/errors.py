"""Diagnostics shared by every minic stage."""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Span:
    """A half-open source range. Lines and columns are 1-based."""

    line: int
    col: int
    end_line: int
    end_col: int

    @staticmethod
    def synthetic() -> "Span":
        return Span(1, 1, 1, 1)


class MiniError(Exception):
    """A user-visible compile error with an optional source span."""

    def __init__(self, message: str, span: Span | None = None, note: str | None = None):
        super().__init__(message)
        self.message = message
        self.span = span
        self.note = note


class MiniRuntimeError(Exception):
    """A runtime fault raised by the TAC interpreter."""

    def __init__(self, message: str, func: str, pc: int):
        super().__init__(message)
        self.message = message
        self.func = func
        self.pc = pc


class InternalError(Exception):
    """A compiler invariant was violated; this is a bug, not user input."""
