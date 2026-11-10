#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""把 robot-labs-3d.js 里写在字符串中的 LaTeX 片段（$...$）改写为纯 Unicode 文本。

运行时注入的读数不经过 KaTeX（构建期才渲染），留着 $...$ 会让读者看到源码。
本脚本把每个 $...$ 片段替换成等价的纯文本（希腊字母直接用 Unicode，下标上标用
Unicode 上下标），原字符串里不再有需要运行时解析的 LaTeX。

用法：python3 tools/texlite_rewrite.py [--check]
"""
from __future__ import annotations

import re
import sys

PATH = "theme/js/robot-labs-3d.js"

GREEK = {
    "alpha": "α", "beta": "β", "gamma": "γ", "delta": "δ", "epsilon": "ε",
    "theta": "θ", "vartheta": "ϑ", "phi": "φ", "varphi": "φ", "psi": "ψ",
    "omega": "ω", "lambda": "λ", "Lambda": "Λ", "Delta": "Δ", "Sigma": "Σ",
    "ell": "ℓ", "sigma": "σ", "mu": "μ", "tau": "τ", "eta": "η", "rho": "ρ",
}
OPS = {
    "times": "×", "cdot": "·", "pm": "±", "mp": "∓", "le": "≤", "leq": "≤",
    "ge": "≥", "geq": "≥", "ne": "≠", "neq": "≠", "approx": "≈", "equiv": "≡",
    "in": "∈", "to": "→", "rightarrow": "→", "leftarrow": "←", "infty": "∞",
    "partial": "∂", "nabla": "∇", "forall": "∀", "exists": "∃", "cdot": "·",
    "ll": "≪", "gg": "≫", "propto": "∝", "perp": "⊥", "parallel": "∥",
}
FUNCS = ("operatorname", "mathrm", "mathbf", "mathit", "text", "textrm", "mathsf",
         "sin", "cos", "tan", "cot", "det", "exp", "log", "ln", "max", "min",
         "arctan", "atan2", "sqrt", "frac", "bar", "hat", "tilde", "vec")

SUB = {"0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄", "5": "₅", "6": "₆",
       "7": "₇", "8": "₈", "9": "₉", "a": "ₐ", "e": "ₑ", "i": "ᵢ", "j": "ⱼ",
       "k": "ₖ", "m": "ₘ", "n": "ₙ", "o": "ₒ", "p": "ₚ", "r": "ᵣ", "s": "ₛ",
       "t": "ₜ", "u": "ᵤ", "v": "ᵥ", "x": "ₓ", "-": "₋", "+": "₊", "=": "₌",
       "(": "₍", ")": "₎"}
SUP = {"0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴", "5": "⁵", "6": "⁶",
       "7": "⁷", "8": "⁸", "9": "⁹", "T": "ᵀ", "n": "ⁿ", "i": "ⁱ", "+": "⁺",
       "-": "⁻", "(": "⁽", ")": "⁾"}


def sub_text(s: str) -> str:
    return "".join(SUB.get(ch, ch) for ch in s)


def sup_text(s: str) -> str:
    return "".join(SUP.get(ch, ch) for ch in s)


def convert(tex: str) -> str:
    """把一段 LaTeX 转成纯 Unicode 文本。"""
    out = tex
    # \frac{a}{b} → (a)/(b)
    out = re.sub(r"\\frac\s*\{([^{}]*)\}\s*\{([^{}]*)\}", r"(\1)/(\2)", out)
    out = re.sub(r"\\frac\s*\{([^{}]*)\}\s*([A-Za-z0-9])", r"(\1)/(\2)", out)
    # \sqrt{x} → √(x)
    out = re.sub(r"\\sqrt\s*\{([^{}]*)\}", r"√(\1)", out)
    # 带参数的命令：\dot x → ẋ ；\bar J → J̅
    out = re.sub(r"\\(?:dot|bar|hat|tilde|vec)\s*\{([^{}]*)\}",
                 lambda m: m.group(1), out)
    out = re.sub(r"\\(?:dot|bar|hat|tilde|vec)\s*([A-Za-z])",
                 lambda m: m.group(1) + "̇", out)
    # 无参数命令
    def cmd(m):
        name = m.group(1)
        if name in GREEK:
            return GREEK[name]
        if name in OPS:
            return OPS[name]
        if name in ("operatorname", "mathrm", "mathbf", "mathit", "text",
                    "textrm", "mathsf", "sin", "cos", "tan", "cot", "det",
                    "exp", "log", "ln", "max", "min", "arctan", "atan2"):
            return name
        return ""
    out = re.sub(r"\\([A-Za-z]+)", cmd, out)
    # 上下标
    out = re.sub(r"_\{([^{}]*)\}", lambda m: sub_text(m.group(1)), out)
    out = re.sub(r"\^\{([^{}]*)\}", lambda m: sup_text(m.group(1)), out)
    out = re.sub(r"_([A-Za-z0-9])", lambda m: SUB.get(m.group(1), "_" + m.group(1)), out)
    out = re.sub(r"\^([A-Za-z0-9])", lambda m: SUP.get(m.group(1), "^" + m.group(1)), out)
    # 剩余的 LaTeX 修饰符
    out = out.replace("\\,", " ").replace("\\;", " ").replace("\\!", " ")
    out = out.replace("\\quad", " ").replace("\\qquad", " ")
    out = out.replace("\\left", "").replace("\\right", "")
    out = out.replace("\\{", "{").replace("\\}", "}")
    out = out.replace("\\", "")
    return out


def rewrite(text: str) -> tuple[str, int]:
    count = 0

    def repl(m):
        nonlocal count
        count += 1
        body = m.group(1)
        # 文件里的 \\ 是 JS 字符串里的转义，先还原成真正的反斜杠
        body = body.replace("\\\\", "\\")
        return convert(body)

    new = re.sub(r"\$([^$\n]+)\$", repl, text)
    return new, count


def main() -> int:
    with open(PATH, encoding="utf-8") as fh:
        src = fh.read()
    new, n = rewrite(src)
    if "--check" in sys.argv:
        print(f"待改写的 $...$ 片段：{n} 段")
        return 0
    with open(PATH, "w", encoding="utf-8") as fh:
        fh.write(new)
    print(f"已改写 {n} 段 LaTeX → 纯 Unicode")
    return 0


if __name__ == "__main__":
    sys.exit(main())
