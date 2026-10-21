"""x86-64 SysV code generation from lowered TAC.

The backend is a stack machine: every SSA name gets a 4-byte frame slot and
every operation loads its operands into eax/ecx, computes, and stores the
result.  It is not a register allocator; its job is to make the ABI contract
visible and testable.

Frame invariant:
  callee entry            rsp % 16 == 8
  after push %rbp         rsp % 16 == 0
  after sub $16k, %rsp    rsp % 16 == 0   (frame size is rounded to 16)
  at every call           rsp % 16 == 0
"""

from __future__ import annotations

from dataclasses import dataclass

from .errors import InternalError
from .tac import (
    Bin, Branch, CallInstr, Const, Copy, Jump, Label, Phi, PrintInstr,
    ReturnInstr, TacFunction, Un, defs_of, uses_of,
)

ARG_REGS = ["%edi", "%esi", "%edx", "%ecx", "%r8d", "%r9d"]
COMPARE = {
    "==": "sete", "!=": "setne",
    "<": "setl", "<=": "setle", ">": "setg", ">=": "setge",
}


@dataclass
class Target:
    name: str
    symbol_prefix: str
    text_section: str
    rodata_section: str
    linux: bool


TARGETS = {
    "darwin": Target(
        "darwin", "_",
        ".section __TEXT,__text,regular,pure_instructions",
        ".section __TEXT,__cstring,cstring_literals",
        False,
    ),
    "linux": Target("linux", "", ".text", ".section .rodata", True),
}


class FunctionGen:
    def __init__(self, fn: TacFunction, target: Target):
        self.fn = fn
        self.target = target
        self.slots: dict[str, int] = {}
        self.labels = []
        self._allocate()

    def _allocate(self) -> None:
        order: list[str] = list(self.fn.params)
        for ins in self.fn.instrs:
            for d in defs_of(ins):
                if d not in order:
                    order.append(d)
            for u in uses_of(ins):
                if u not in order:
                    order.append(u)
        for name in order:
            self.slots[name] = 4 * (len(self.slots) + 1)
        self.frame = ((len(self.slots) * 4 + 15) // 16) * 16

    def slot(self, name: str) -> str:
        if name not in self.slots:
            raise InternalError(f"no slot for {name} in {self.fn.name}")
        return f"-{self.slots[name]}(%rbp)"

    def emit(self, text: str) -> None:
        self.labels.append("  " + text)

    def label(self, name: str) -> str:
        return f".L{self.fn.name}_{name}"

    def load(self, name: str, reg: str) -> None:
        self.emit(f"movl {self.slot(name)}, {reg}")

    def store(self, name: str, reg: str) -> None:
        self.emit(f"movl {reg}, {self.slot(name)}")

    def generate(self) -> list[str]:
        t = self.target
        out = []
        out.append(f"  .globl {t.symbol_prefix}{self.fn.name}")
        out.append("  .p2align 2")
        out.append(f"{t.symbol_prefix}{self.fn.name}:")
        out.append("  pushq %rbp")
        out.append("  movq %rsp, %rbp")
        if self.frame:
            out.append(f"  subq ${self.frame}, %rsp")
        out.append(f"  # frame {self.frame} bytes; rsp % 16 == 0 before calls")
        if len(self.fn.params) > len(ARG_REGS):
            raise InternalError("more than six parameters")
        for name, reg in zip(self.fn.params, ARG_REGS):
            self.emit(f"movl {reg}, {self.slot(name)}")
        for ins in self.fn.instrs:
            self.gen_instr(ins)
        out.extend(self.labels)
        out.append("  xorl %eax, %eax")
        out.append("  leave")
        out.append("  ret")
        return out

    def gen_instr(self, ins) -> None:
        if isinstance(ins, Label):
            self.labels.append(f"{self.label(ins.name)}:")
        elif isinstance(ins, Const):
            self.emit(f"movl ${ins.value}, {self.slot(ins.dst)}")
        elif isinstance(ins, Copy):
            self.load(ins.src, "%eax")
            self.store(ins.dst, "%eax")
        elif isinstance(ins, Bin):
            self.load(ins.a, "%eax")
            self.load(ins.b, "%ecx")
            op = ins.op
            if op == "+":
                self.emit("addl %ecx, %eax")
            elif op == "-":
                self.emit("subl %ecx, %eax")
            elif op == "*":
                self.emit("imull %ecx, %eax")
            elif op in ("/", "%"):
                self.emit("cltd")
                self.emit("idivl %ecx")
                if op == "%":
                    self.emit("movl %edx, %eax")
            elif op in COMPARE:
                self.emit("cmpl %ecx, %eax")
                self.emit(f"{COMPARE[op]} %al")
                self.emit("movzbl %al, %eax")
            else:
                raise InternalError(f"no code for binary operator {op}")
            self.store(ins.dst, "%eax")
        elif isinstance(ins, Un):
            self.load(ins.a, "%eax")
            if ins.op == "-":
                self.emit("negl %eax")
            elif ins.op == "!":
                self.emit("cmpl $0, %eax")
                self.emit("sete %al")
                self.emit("movzbl %al, %eax")
            else:
                raise InternalError(f"no code for unary operator {ins.op}")
            self.store(ins.dst, "%eax")
        elif isinstance(ins, Branch):
            self.emit(f"cmpl $0, {self.slot(ins.cond)}")
            self.emit(f"je {self.label(ins.flabel)}")
            self.emit(f"jmp {self.label(ins.tlabel)}")
        elif isinstance(ins, Jump):
            self.emit(f"jmp {self.label(ins.target)}")
        elif isinstance(ins, CallInstr):
            if len(ins.args) > len(ARG_REGS):
                raise InternalError("more than six call arguments")
            for arg, reg in zip(ins.args, ARG_REGS):
                self.load(arg, reg)
            self.emit("xorl %eax, %eax")
            self.emit(f"call {self.target.symbol_prefix}{ins.func}")
            if ins.dst is not None:
                self.store(ins.dst, "%eax")
        elif isinstance(ins, ReturnInstr):
            if ins.src is None:
                self.emit("xorl %eax, %eax")
            else:
                self.load(ins.src, "%eax")
            self.emit("leave")
            self.emit("ret")
        elif isinstance(ins, PrintInstr):
            self.emit("leaq L_.fmt(%rip), %rdi")
            self.load(ins.src, "%esi")
            self.emit("xorl %eax, %eax")
            self.emit(f"call {self.target.symbol_prefix}printf")
        elif isinstance(ins, Phi):
            raise InternalError("codegen received an unresolved phi")
        else:
            raise InternalError(f"no code for {ins!r}")


def generate(functions: list[TacFunction], target_name: str = "darwin") -> str:
    target = TARGETS.get(target_name)
    if target is None:
        raise InternalError(f"unknown target {target_name}")
    lines = [target.text_section, "  .p2align 2"]
    for fn in functions:
        lines.extend(FunctionGen(fn, target).generate())
    lines.append(target.rodata_section)
    lines.append("L_.fmt:")
    lines.append('  .asciz "%d\\n"')
    if target.linux:
        lines.append('.section .note.GNU-stack,"",@progbits')
    return "\n".join(lines) + "\n"
