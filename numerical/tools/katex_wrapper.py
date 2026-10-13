#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""katex_wrapper — mdbook-katex 的包装器：渲染后立刻中和字面波浪号。

为什么需要它：mdbook-katex 渲染 `\tilde` / `\widetilde` 等重音符时输出
**字面的 `~` 字符**（`<span class="mord">~</span>`）。GFM 删除线允许单个
`~` 配对——mdBook 的 pulldown-cmark 在 katex 之后解析，会把同页相邻两个
公式的两个 `~` 当作一对删除线定界符，中间的全部内容（连同几十个 span
标签）被吞进 `<del>`，造成删除线横穿正文、整行不换行、公式层叠错位。

包装器在**同一预处理器链位**上工作：把 stdin 原样传给真正的
`mdbook-katex`，拿到它输出的 book JSON 后、交还 mdBook 之前，把 KaTeX
HTML 标签之间的纯波浪号文本节点改写成 `&#126;` 实体（浏览器渲染不变，
Markdown 解析器不再看到字面 `~`）。

book.toml 中这样使用（保持 after = ["mathbook"] 不变）：

    [preprocessor.katex]
    command = "python3 tools/katex_wrapper.py"
    no-css = true
    after = ["mathbook"]

依赖：系统 PATH 中存在 `mdbook-katex`；纯 Python，无第三方包。

在 JSON 文本层面替换是安全的：JSON 的结构字符只有 `{}[]:,"`，内容里的
`>` 与 `~` 都不会转义，因此 `>~<` 序列只可能来自 KaTeX 的字形 span。
"""

import json
import re
import subprocess
import sys

# 标签之间的纯波浪号文本节点：>~~~~~~~<
TILDE_RUN = re.compile(r">(~+)<")
KATEX_BIN = "mdbook-katex"


def neutralize(text: str) -> str:
    return TILDE_RUN.subn(
        lambda m: ">" + "&#126;" * len(m.group(1)) + "<", text)[0]


def main(argv) -> int:
    raw = sys.stdin.buffer.read()

    # supports 探测：透传给真正的 mdbook-katex，以其退出码为准
    if len(argv) >= 2 and argv[1] == "supports":
        return subprocess.run([KATEX_BIN] + argv[1:]).returncode

    # 公式渲染：原文转发给 mdbook-katex
    r = subprocess.run([KATEX_BIN], input=raw, stdout=subprocess.PIPE)
    if r.returncode != 0:
        # 失败时把 katex 的 stderr 透传出去，便于定位
        sys.stderr.write(r.stderr.decode("utf-8", "replace") if r.stderr else "")
        return r.returncode

    text = r.stdout.decode("utf-8")
    before = len(TILDE_RUN.findall(text))
    text = neutralize(text)
    if before:
        print(f"katex_wrapper: 中和 {before} 处字面波浪号", file=sys.stderr)
    sys.stdout.buffer.write(text.encode("utf-8"))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
