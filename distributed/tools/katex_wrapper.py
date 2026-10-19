#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""katex_wrapper — mdbook-katex 的包装器：渲染后把「会被 Markdown 误读的字符」中和掉。

mdbook-katex 输出的 HTML 会被 mdBook 交给 pulldown-cmark **再解析一遍**，于是
KaTeX 产物里的两类字符会被当成 Markdown 语法：

① **字面波浪号**。渲染 `\tilde` / `\widetilde` 这类重音符时，KaTeX 输出字面的
   `~`（`<span class="mord">~</span>`）。GFM 删除线允许单个 `~` 配对，同页相邻两个
   公式的两个 `~` 会被当作一对定界符，中间全部内容（连同几十个 span）被吞进
   `<del>`：删除线横穿正文、整行不换行、公式层叠错位。

② **`<annotation>` 里的原始 TeX**。为了让公式可复制、读屏可用，KaTeX 以
   output = htmlAndMathml 渲染，产物带
   `<annotation encoding="application/x-tex">…</annotation>`；annotation 的
   **文本内容**正是原始 TeX，里面有 `*`、`_`、`[`、`|`、`<`、`~`。这些同样会被
   pulldown 当成强调/链接/表格定界符，整页刷出
   `unclosed HTML tag <annotation> while exiting Emphasis` 之类的告警，MathML 与
   可复制的 TeX 一并被打散。

处理办法是同一套：在**预处理器链位上**把 stdin 原样转发给 `mdbook-katex`，拿到它的
book JSON 后、交还 mdBook 之前改写这两类字符——

  · 纯波浪号文本节点（`>~~~<`）→ `&#126;` 实体；
  · annotation 文本里的 `& < > * _ ~ [ ] | \`` → 对应 HTML 实体。

实体在浏览器里渲染出的文字不变，`annotation.textContent` 也仍是**原样 TeX**
（复制出来还是 `k_{\mathcal E}`），而 Markdown 解析器再也看不到这些定界符。

book.toml 中这样使用（保持 after = ["mathbook"] 不变）：

    [preprocessor.katex]
    command = "python3 tools/katex_wrapper.py"
    no-css = true
    after = ["mathbook"]

依赖：系统 PATH 中存在 `mdbook-katex`；纯 Python，无第三方包。

在 JSON 文本层面替换是安全的：JSON 的结构字符只有 `{}[]:,"`，内容里的 `>` 与 `~`
都不会转义，因此 `>~<` 序列只可能来自 KaTeX 的字形 span；而 annotation 的定界串
（含 `encoding="application/x-tex"`）也不会出现在别处。
"""

import json
import re
import subprocess
import sys

# 标签之间的纯波浪号文本节点：>~~~~~~~<
TILDE_RUN = re.compile(r">(~+)<")
# <annotation …>原始 TeX</annotation>
# 注意：这里处理的是 **JSON 文本**，属性里的引号是转义过的（encoding=\"application/x-tex\"），
# 所以标签部分用 [^>]* 泛匹配，不能按未转义的字面串去匹配——那会一个都命中不了。
ANNOTATION = re.compile(r'(<annotation[^>]*>)(.*?)(</annotation>)', re.S)
# 会被 Markdown 解析当定界符的字符：换成实体后 textContent 不变，复制出来的仍是原样 TeX
ANNOTATION_ENTITIES = {
    ord("&"): "&amp;", ord("<"): "&lt;", ord(">"): "&gt;",
    ord("*"): "&#42;", ord("_"): "&#95;", ord("~"): "&#126;",
    ord("["): "&#91;", ord("]"): "&#93;", ord("|"): "&#124;",
    ord("`"): "&#96;",
}

# 代码上下文里的 $ 不是公式定界符：mdbook-katex 会扫描整段文本，把 `$1`、`$PATH`
# 当成公式开头，导致整页被吞进 KaTeX。这里在调用 katex 前把代码里的 $ 换成私用区
# 字符 U+E000，渲染后再换回 $；最终 HTML 不受影响。
PH = "\ue000"
CODE_PATTERNS = [
    re.compile(r"```.*?```", re.S),
    re.compile(r"~~~.*?~~~", re.S),
    re.compile(r"`[^`\n]*`"),
    re.compile(r"<pre\b[^>]*>.*?</pre>", re.S | re.I),
    re.compile(r"<code\b[^>]*>.*?</code>", re.S | re.I),
]

def protect_code(text: str) -> str:
    for pat in CODE_PATTERNS:
        text = pat.sub(lambda m: m.group(0).replace("$", PH), text)
    return text

def restore_code(text: str) -> str:
    return text.replace(PH, "$")

def walk(obj, fn):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k == "content" and isinstance(v, str):
                obj[k] = fn(v)
            else:
                walk(v, fn)
    elif isinstance(obj, list):
        for v in obj:
            walk(v, fn)

KATEX_BIN = "mdbook-katex"


def neutralize_annotations(text: str) -> str:
    def repl(match):
        return match.group(1) + match.group(2).translate(ANNOTATION_ENTITIES) + match.group(3)

    return ANNOTATION.sub(repl, text)


def neutralize(text: str) -> str:
    text = neutralize_annotations(text)
    return TILDE_RUN.subn(
        lambda m: ">" + "&#126;" * len(m.group(1)) + "<", text)[0]


def main(argv) -> int:
    raw = sys.stdin.buffer.read()

    # supports 探测：透传给真正的 mdbook-katex，以其退出码为准
    if len(argv) >= 2 and argv[1] == "supports":
        return subprocess.run([KATEX_BIN] + argv[1:]).returncode

    # 先把代码上下文里的 $ 换成占位符，再交给 mdbook-katex
    try:
        book = json.loads(raw.decode("utf-8"))
        walk(book, protect_code)
        payload = json.dumps(book, ensure_ascii=False).encode("utf-8")
    except Exception as exc:
        print("katex_wrapper: 无法解析 book JSON，原样透传：%s" % exc, file=sys.stderr)
        payload = raw

    r = subprocess.run([KATEX_BIN], input=payload, stdout=subprocess.PIPE)
    if r.returncode != 0:
        # 失败时把 katex 的 stderr 透传出去，便于定位
        sys.stderr.write(r.stderr.decode("utf-8", "replace") if r.stderr else "")
        return r.returncode

    text = r.stdout.decode("utf-8")
    # 渲染后把占位符换回 $（只动 content 字段，避免误改结构）
    try:
        out_book = json.loads(text)
        walk(out_book, restore_code)
        text = json.dumps(out_book, ensure_ascii=False)
    except Exception:
        text = text.replace(PH, "$")
    tildes = len(TILDE_RUN.findall(text))
    annotations = len(ANNOTATION.findall(text))
    text = neutralize(text)
    if tildes or annotations:
        print("katex_wrapper: 中和 %d 处字面波浪号、%d 处 annotation 文本" % (tildes, annotations),
              file=sys.stderr)
    sys.stdout.buffer.write(text.encode("utf-8"))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
