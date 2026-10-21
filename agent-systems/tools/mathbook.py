#!/usr/bin/env python3
# -*- coding: utf-8 -*-
r"""mathbook — 《Agent 系统工程》的 mdBook 预处理器。

与 Linux 卷共用同一套盒子/交叉引用契约；本书只允许 def/thm/ex/intuition/
method/errata/note/proof/sol 九种盒子，其他类型直接构建失败。

补上 mdBook 原生没有、而数学教材必需的三件事：

1. 语义盒子
       ::: def 定义 1.1.3 · 数域 field {#def-1.1.3}
       正文（Markdown，可含 \( \) 与 $$ $$，可嵌套其他 ::: 盒子）
       :::
   渲染为 <div class="box def p-core" id="def-1.1.3">，样式见 theme/css/na.css。
   可用类型见 BOX_TYPES / PROOF / SOL。

   类型后可加**优先级标记**（可选）：`::: proof[core]`、`::: thm[skip]`，
   取值 core / main / skip，不写则按 PRIORITY_DEFAULT 取类型默认值。
   渲染为附加类 `p-core` / `p-main` / `p-skip`，供 CSS 做阅读分层。

2. 符号化交叉引用
       ……即为 [@def-1.1.3] 中定义的数域。
   渲染为指向该锚点的链接，链接文字从被引用项自动取得（“定义 1.1.3”）。
   引用在整本书范围内解析：写错编号 = 构建失败，而不是静默失效。
   目标在别的页面时自动生成**相对该页的路径**（如 sec11.html#def-1.1.5），
   纯 #锚点 链接只对同页目标生成。
   注意：标题行与 Markdown 链接文字里不允许出现嵌套 <a>（标题会被 mdBook
   包进锚点 <a class="header">，链接文字本身就是 <a>），这些位置的 [@id]
   降级为不带链接的 <span class="crossref">，文字不变。

3. 自动编号（可选）
   若盒子标题里不含数字（如 `::: def 定义 · 数域 {#def-x}`），预处理器按所属
   小节自动编号为 <节号>.<组内序号>（如 1.1.6），并按“定义 / 定理 / 例题”三个
   独立序列计数。节号从章节标题（`1.1.3 数域` → `1.1`）取得。
   迁移自课件的正文一律使用**显式编号**，以便与课件逐条对照；自动编号供新增
   内容与后续章节使用。

实现要点
--------
CommonMark 规定：HTML 块（`<div>` 等块级标签）**遇到空行即结束**。因此若直接
把 `<div>` 与 Markdown 正文混排，正文会落到盒子外面。本预处理器采用
mdbook-admonish 同款做法：**在预处理器内把盒子内的 Markdown 渲染成 HTML**，
再输出成一个不含空行的完整 HTML 块。为此：

- 盒子内的公式先抽出为占位符，避免被 Markdown 误解（如 `$x_1$` 的下划线）；
- 盒内的 `.md` 链接改写为 `.html`（mdBook 之后不会再看到它们）；
- 盒子内不写跨文件相对链接以外的特殊语法；跨引用 [@id] 在此阶段解析。

mdBook 预处理器协议：stdin 读 JSON，stdout 写 JSON；`supports <renderer>` 时以
退出码表示是否支持该渲染后端。
"""

from __future__ import annotations

import json
import posixpath
import re
import sys

try:
    from markdown_it import MarkdownIt
except ImportError:          # pragma: no cover
    MarkdownIt = None

# --------------------------------------------------------------------------- #
# 语法
# --------------------------------------------------------------------------- #

OPEN_RE = re.compile(r"^(\s*):::\s*([A-Za-z][\w-]*)\s*(.*?)\s*$")
CLOSE_RE = re.compile(r"^\s*:::\s*$")
ID_RE = re.compile(r"\s*\{#([^}\s]+)\}\s*$")
REF_RE = re.compile(r"\[@([A-Za-z0-9._:\-]+)\]")
FENCE_RE = re.compile(r"^\s*(`{3,}|~{3,})")
HEADING_RE = re.compile(r"^\s{0,3}#{1,6}\s")
# 行内 Markdown 链接（含图片）。整段先摘走，链接文字里的 [@id] 以纯文本呈现，
# 避免与链接本身的 <a> 形成嵌套。文字部分允许一层方括号嵌套（如 [见 [@x]](u)）。
MD_LINK_RE = re.compile(
    r"(!?\[(?:\[[^\]]*\]|[^\]])*\])\(([^()\s]*(?:\([^()]*\)[^()\s]*)*)\)")
# 四种数学定界符都要保护：LaTeX 风格 \(…\) / \[…\] 与 $…$ / $$…$$。
# 若只保护 $ 形式，盒内的 \(W\) 会被 Markdown 当成「转义括号」吃成 (W)，
# KaTeX 之后便再也认不出来。
MATH_PATTERNS = [
    re.compile(r"\$\$.+?\$\$", re.S),
    re.compile(r"\\\[.+?\\\]", re.S),
    re.compile(r"\\\(.+?\\\)", re.S),
    re.compile(r"(?<!\\)\$[^$\n]+?\$"),
]

# 类型 → (CSS 类, 编号序列名)。序列名为 None 表示不参与自动编号。
BOX_TYPES = {
    "def":     ("box def",     "def"),
    "thm":     ("box thm",     "thm"),
    "ex":      ("box ex",      "ex"),
    "intuition": ("box intuition", None),
    "method":  ("box method",  None),
    "errata":  ("box errata",  None),
    "note":    ("note",        None),
}
PROOF = "proof"
SOL = "sol"
KNOWN = set(BOX_TYPES) | {PROOF, SOL}

# --------------------------------------------------------------------------- #
# 盒子优先级（阅读分层）
# --------------------------------------------------------------------------- #
# 全书约 400 个盒子，若视觉权重完全相同，读者无法判断「哪些必记、哪些可跳」。
# 按盒子类型给一个默认优先级，并允许在类型后加 [标记] 覆盖：
#
#     ::: proof[core]   → 这一节的证明就是重点，别跳
#     ::: thm[skip]     → 这个定理只作背景，第一遍可跳
#
# 三个层级：
#   core —— 必记（定义、定理族、速查表、错误清单）：高对比，复习时的骨架
#   main —— 主体（例题、方法、直觉、边注、思考）：正常样式
#   skip —— 第一遍可跳（证明、课程预告）：弱化，二刷再回来
# 渲染为 <div class="… p-core|p-main|p-skip">，样式见 theme/css/na.css §3。
# 注意 note / think 默认是 main：书里的「常见错误清单」「速查表」都挂在这两类上，
# 属于复习骨架；真正可跳的那些已单独标 [skip]。
PRIORITY_DEFAULT = {
    "def": "core", "thm": "core", "prop": "core", "cor": "core", "lem": "core",
    "ex": "main", "method": "main", "intuition": "main",
    "errata": "main", "meta": "main", SOL: "main",
    "note": "main", "think": "main",
    "proof": "skip", "preview": "skip",
}
PRIORITIES = ("core", "main", "skip")
MARKER_RE = re.compile(r"^\[([A-Za-z][\w-]*)\]\s*")


def split_marker(raw: str):
    """剥掉盒子类型后的可选 `[优先级]` 标记，返回 (标记或 None, 剩余标题)。"""
    m = MARKER_RE.match(raw)
    if not m:
        return None, raw
    return m.group(1), raw[m.end():]


def box_priority(typ: str, marker) -> str:
    """标记优先；标记非法时退回类型默认值（合法性由 process() 统一报错）。"""
    if marker in PRIORITIES:
        return marker
    return PRIORITY_DEFAULT.get(typ, "main")


# --------------------------------------------------------------------------- #
# Markdown 渲染器（仅用于盒子内部）
# --------------------------------------------------------------------------- #

def make_md():
    if MarkdownIt is None:
        raise SystemExit(
            "mathbook: 需要 markdown-it-py 来渲染盒子内的 Markdown。\n"
            "         安装： pip3 install -r requirements.txt")
    # 只用 commonmark + 表格/删除线；不开 linkify（避免额外依赖，也不需要自动链接）。
    md = MarkdownIt("commonmark").enable(["table", "strikethrough"])
    md.options["html"] = True
    return md


MD = None


def md_render(markdown_src: str) -> str:
    global MD
    if MD is None:
        MD = make_md()
    math_store = []

    # 占位符必须**不是 HTML 注释**：以 <!--…--> 开头的段落会被 CommonMark
    # 判定为原始 HTML 块，导致整段不再解析 Markdown——凡是「以公式开头」的
    # 句子都会因此丢掉链接、加粗，并把 $…$ 原样显示。
    # 这里改用私有使用区字符，两个解析器都不会赋予它语法含义。
    def stash(m):
        math_store.append(m.group(0))
        return f"\ue000{len(math_store) - 1}\ue001"

    protected = markdown_src
    for pat in MATH_PATTERNS:
        protected = pat.sub(stash, protected)
    html = MD.render(protected)
    for i, tex in enumerate(math_store):
        html = html.replace(f"\ue000{i}\ue001", tex)
    # 盒内相对链接：.md → .html（mdBook 之后看不到这些链接）
    html = re.sub(r'(href="[^"#]*?)\.md(#[^"]*)?(")', r"\1.html\2\3", html)
    return html


# --------------------------------------------------------------------------- #
# 骨架
# --------------------------------------------------------------------------- #

def iter_lines_with_fence_state(content: str):
    """逐行产出 (行号, 是否在代码块内, 行内容)。"""
    fence = None
    for i, line in enumerate(content.splitlines()):
        m = FENCE_RE.match(line)
        if m:
            marker = m.group(1)
            if fence is None:
                fence = marker[0]
                yield i, True, line
                continue
            if marker[0] == fence:
                fence = None
                yield i, True, line
                continue
        yield i, fence is not None, line


def split_id(text: str):
    """从标题尾部剥离 {#id}，返回 (剩余标题, id 或 None)。"""
    m = ID_RE.search(text)
    if not m:
        return text.strip(), None
    return text[: m.start()].strip(), m.group(1)


def ref_text(label: str) -> str:
    """把盒子标题转成适合做链接文字的形式：取 “·” 之前，去掉尾部括注。"""
    head = label.split(" · ", 1)[0].strip()
    head = re.sub(r"[（(][^）)]*[）)]\s*$", "", head).strip()
    return head or label


def auto_label(label: str, num: str) -> str:
    """把编号插入标题：`定义 · 数域` → `定义 1.1.6 · 数域`。"""
    if " · " in label:
        head, tail = label.split(" · ", 1)
        return f"{head} {num} · {tail}"
    return f"{label} {num}"


def section_prefix(number, name: str = "") -> str:
    """自动编号的节号。

    优先从章标题里取（`1.1.3 数域` → `1.1`），因为标题里的编号就是读者看到的
    编号，且不受 SUMMARY.md 结构（卷首/章末等非正文条目）影响；标题无编号时
    退回 mdBook 的位置编号前两段。
    """
    m = re.match(r"\s*(\d+(?:\.\d+)*)", name or "")
    if m:
        parts = m.group(1).split(".")
        return ".".join(parts[:2]) if len(parts) >= 2 else parts[0]
    nums = list(number or [])
    if not nums:
        return "0"
    return ".".join(str(n) for n in nums[:2])


class LabelTable:
    def __init__(self):
        self.full = {}      # id -> 带编号的完整标题（用于输出）
        self.text = {}      # id -> 链接文字
        self.path = {}      # id -> 锚点所在页的输出路径（如 ch01/sec11.html）
        self.used = set()   # 被 [@id] 引用过的 id
        self.errors = []

    def href(self, id_: str, where: str) -> str:
        """交叉引用的 href：同页用纯锚点，跨页用相对当前页的路径。

        `where` 是当前章的 source_path（.md）；目标页记录的是输出路径（.html）。
        """
        target = self.path.get(id_)
        cur = re.sub(r"\.md$", ".html", where or "")
        if not target or target == cur or cur == "":
            return f"#{id_}"
        rel = posixpath.relpath(target, posixpath.dirname(cur))
        return f"{rel}#{id_}"


def book_nodes(book):
    """兼容 mdBook 0.4（sections）与 0.5（items）的书结构。"""
    if "items" in book:
        return book["items"]
    if "sections" in book:
        return book["sections"]
    raise KeyError("书中既无 `items` 也无 `sections`：mdBook 预处理器协议可能有变")


# --------------------------------------------------------------------------- #
# 第一遍：收集标签、分配自动编号
# --------------------------------------------------------------------------- #

def assign_labels(sections, table: LabelTable) -> None:
    counters = {}

    def walk(secs):
        for sec in secs:
                if not isinstance(sec, dict) or "Chapter" not in sec:
                    continue
                ch = sec["Chapter"]
                content = ch.get("content") or ""
                where = ch.get("source_path") or ch.get("path") or "?"
                pref = section_prefix(ch.get("number"), ch.get("name", ""))
                page = re.sub(r"\.md$", ".html", where) if where != "?" else ""
                for _, in_fence, line in iter_lines_with_fence_state(content):
                    if in_fence:
                        continue
                    m = OPEN_RE.match(line)
                    if not m or CLOSE_RE.match(line):
                        continue
                    typ, raw = m.group(2), m.group(3)
                    if typ not in KNOWN:
                        table.errors.append(f"{where}: 未知盒子类型 `:::{typ}`")
                        continue
                    marker, raw = split_marker(raw)
                    if marker and marker not in PRIORITIES:
                        table.errors.append(
                            f"{where}: 未知盒子优先级 `[{marker}]`"
                            f"（可用：{'、'.join(PRIORITIES)}）")
                    label, id_ = split_id(raw)
                    if not id_:
                        continue                      # 无锚点则不可被引用
                    if id_ in table.full:
                        table.errors.append(f"{where}: 锚点 `#{id_}` 重复定义")
                        continue
                    series = BOX_TYPES.get(typ, (None, None))[1]
                    if series and label and not re.search(r"\d", label):
                        key = (pref, series)
                        counters[key] = counters.get(key, 0) + 1
                        label = auto_label(label, f"{pref}.{counters[key]}")
                    table.full[id_] = label
                    table.text[id_] = ref_text(label) if label else id_
                    table.path[id_] = page
                walk(ch.get("sub_items") or [])

    walk(sections)


# --------------------------------------------------------------------------- #
# 第二遍：解析盒子树 → 渲染
# --------------------------------------------------------------------------- #

def parse_tree(content: str, where: str, table: LabelTable):
    """把正文解析为节点列表；盒子可任意嵌套。

    节点形如 ("text", "若干行") 或 ("box", {typ,label,id,children})。
    连续正文合并成一个 text 节点，以保留其中的换行。
    """
    root = []
    stack = [root]
    buf = []

    def flush():
        if buf:
            stack[-1].append(("text", "\n".join(buf)))
            buf.clear()

    for _, in_fence, line in iter_lines_with_fence_state(content):
        if in_fence:
            buf.append(line)
            continue
        if CLOSE_RE.match(line):
            if len(stack) == 1:
                table.errors.append(f"{where}: 出现多余的 `:::`（没有对应的开头）")
                buf.append(line)
                continue
            flush()
            stack.pop()
            continue
        m = OPEN_RE.match(line)
        if m:
            typ = m.group(2)
            if typ not in KNOWN:
                # 未知类型已在第一遍报错；此处按普通文本保留
                buf.append(line)
                continue
            marker, rest = split_marker(m.group(3))
            label, id_ = split_id(rest)
            if id_ and id_ in table.full:
                label = table.full[id_]
            flush()
            node = {"typ": typ, "label": label, "id": id_,
                    "prio": box_priority(typ, marker), "children": []}
            stack[-1].append(("box", node))
            stack.append(node["children"])
            continue
        buf.append(line)

    flush()
    if len(stack) != 1:
        table.errors.append(f"{where}: 有 {len(stack) - 1} 个 `:::` 盒子未闭合")
    return root


def emit_open(node) -> str:
    typ, label, id_ = node["typ"], node["label"], node["id"]
    prio = node.get("prio") or PRIORITY_DEFAULT.get(typ, "main")
    cls = BOX_TYPES[typ][0] if typ in BOX_TYPES else ""
    if cls:
        cls = f"{cls} p-{prio}"
    attrs = f' id="{id_}"' if id_ else ""
    if typ in BOX_TYPES:
        tag = f'<span class="box-tag">{label}</span>' if label else ""
        return f'<div class="{cls}"{attrs}>{tag}'
    if typ == PROOF:
        return (f'<div class="proof p-{prio}"{attrs}>'
                f'<span class="pf-label">{label or "证明"}</span>')
    if typ == SOL:
        return (f'<details class="sol-box p-{prio}"{attrs}>'
                f'<summary>{label or "解答"}</summary><div class="sol-inner">')
    raise AssertionError(typ)


def emit_close(node) -> str:
    typ = node["typ"]
    if typ in BOX_TYPES:
        return "</div>"
    if typ == PROOF:
        return '<span class="qed">∎</span></div>'
    if typ == SOL:
        return "</div></details>"
    raise AssertionError(typ)


LINK_MASK = "\x03"
CODE_MASK = "\x04"
# 行内代码段：开闭是**等长**的反引号串。按 `split("`")` 的奇偶分段在双反引号
# （``…``）包裹时会错位，导致代码内的内容被误处理，这里用正则整段屏蔽。
CODESPAN_RE = re.compile(r"(`+)(.+?)\1")


def resolve_refs(text: str, table: LabelTable, where: str) -> str:
    """把 [@id] 换成链接；跳过代码块与行内代码。

    两种位置不允许产生 <a>（会形成非法的嵌套链接，浏览器会拆开解析）：
    - 标题行：mdBook 会把标题文字包进锚点 <a class="header">；
    - Markdown 链接的文字部分：本身就是 <a>。
    这些位置的引用降级为 <span class="crossref">，仅呈现文字。
    """
    def substitute(label_text: str, linked: bool) -> str:
        def rep(m):
            id_ = m.group(1)
            if id_ not in table.full:
                table.errors.append(f"{where}: 引用了不存在的锚点 `#{id_}`")
                return m.group(0)
            table.used.add(id_)
            text_ = table.text[id_]
            if linked:
                return f'<a class="crossref" href="{table.href(id_, where)}">{text_}</a>'
            return f'<span class="crossref">{text_}</span>'
        return REF_RE.sub(rep, label_text)

    out = []
    fence = None
    for line in text.split("\n"):
        m = FENCE_RE.match(line)
        if m:
            marker = m.group(1)
            if fence is None:
                fence = marker[0]
            elif marker[0] == fence:
                fence = None
            out.append(line)
            continue
        if fence is not None:
            out.append(line)                 # 围栏代码块内原样保留
            continue
        # 依次屏蔽：行内代码段（连同其中的 [..](..) 与 [@id] 都不动）→ 行内链接
        code_store = []

        def stash_code(mm):
            code_store.append(mm.group(0))
            return f"{CODE_MASK}{len(code_store) - 1}{CODE_MASK}"

        link_store = []

        def stash_link(mm):
            label = substitute(mm.group(1), linked=False)
            link_store.append(f"{label}({mm.group(2)})")
            return f"{LINK_MASK}{len(link_store) - 1}{LINK_MASK}"

        masked = CODESPAN_RE.sub(stash_code, line)
        is_heading = bool(HEADING_RE.match(line))
        masked = substitute(MD_LINK_RE.sub(stash_link, masked),
                            linked=not is_heading)
        for k, original in enumerate(link_store):
            masked = masked.replace(f"{LINK_MASK}{k}{LINK_MASK}", original)
        for k, original in enumerate(code_store):
            masked = masked.replace(f"{CODE_MASK}{k}{CODE_MASK}", original)
        out.append(masked)
    return "\n".join(out)


# CommonMark 的强调分隔符在中文标点旁会失效：
#   **小结：**①  → 无法闭合（前是标点、后是非标点非空白），星号原样显示
#   **小结。**后面 → 同样无法闭合
# 这类写法在中文技术文档里极其常见。稳妥做法是不依赖 Markdown 的强调解析，
# 直接把 **…** 输出为等价的 <strong>…</strong>（内联 HTML 在两个解析器下都成立）。
STRONG_RE = re.compile(r"\*\*(?=\S)([^\n]+?)(?<=\S)\*\*")
MASK = "\x02"


def normalize_emphasis(text: str) -> str:
    """把 **加粗** 转成 <strong>加粗</strong>；跳过代码块、行内代码与数学。"""
    out, fence = [], None
    for line in text.split("\n"):
        m = FENCE_RE.match(line)
        if m:
            fence = None if fence else m.group(1)[0]
            out.append(line)
            continue
        if fence is not None:
            out.append(line)
            continue
        # 行内代码段整段屏蔽（双反引号包裹时按 ` 分段会错位，见 CODESPAN_RE 注释）
        code_store = []

        def stash_code(mm):
            code_store.append(mm.group(0))
            return f"{CODE_MASK}{len(code_store) - 1}{CODE_MASK}"

        seg = CODESPAN_RE.sub(stash_code, line)
        store: list[str] = []

        def stash(mm):
            store.append(mm.group(0))
            return f"{MASK}{len(store) - 1}{MASK}"

        for pat in MATH_PATTERNS:          # 数学里的 * 不动
            seg = pat.sub(stash, seg)
        seg = STRONG_RE.sub(lambda mm: "<strong>" + mm.group(1) + "</strong>", seg)
        for k, original in enumerate(store):
            seg = seg.replace(f"{MASK}{k}{MASK}", original)
        for k, original in enumerate(code_store):
            seg = seg.replace(f"{CODE_MASK}{k}{CODE_MASK}", original)
        out.append(seg)
    return "\n".join(out)


CODE_IN_HTML = re.compile(r"<(pre|code)\b[^>]*>.*?</\1>", re.S)


def escape_code_dollars(html: str) -> str:
    """盒子内的代码会先被渲染成 HTML；KaTeX 之后看不到反引号，会把 `$` 当公式。
    把 <pre>/<code> 里的 `$` 换成实体：浏览器仍显示 $，KaTeX 不再看到定界符。"""
    return CODE_IN_HTML.sub(lambda m: m.group(0).replace("$", "&#36;"), html)


def render_box(node, table: LabelTable, where: str) -> str:
    """渲染一个盒子：先把子树变成 Markdown（内层盒子已展开为 HTML），
    再用 markdown-it 渲染，最后包成不含空行的单个 HTML 块。"""
    parts = []
    for kind, val in node["children"]:
        if kind == "text":
            parts.append(resolve_refs(val, table, where))
        else:
            parts.append(render_box(val, table, where))
    inner_md = normalize_emphasis("\n\n".join(parts))
    inner_html = md_render(inner_md) if inner_md.strip() else ""
    inner_html = escape_code_dollars(inner_html)
    # 关键：抹掉空行，使整个盒子成为 pulldown-cmark 眼中的**一个** HTML 块。
    inner_html = re.sub(r"\n\s*\n+", "\n", inner_html).strip()
    return f"{emit_open(node)}\n{inner_html}\n{emit_close(node)}"


def render_tree(root, table: LabelTable, where: str) -> str:
    """顶层：正文仍交给 mdBook 解析（保持原生 Markdown 能力），只把盒子替换掉。"""
    parts = []
    for kind, val in root:
        if kind == "text":
            parts.append(normalize_emphasis(resolve_refs(val, table, where)))
        else:
            parts.append(render_box(val, table, where))
    return "\n\n".join(p for p in parts if p != "")


# --------------------------------------------------------------------------- #
# 驱动
# --------------------------------------------------------------------------- #

def process(book):
    table = LabelTable()
    assign_labels(book_nodes(book), table)

    def walk(secs):
        for sec in secs:
            if not isinstance(sec, dict) or "Chapter" not in sec:
                continue
            ch = sec["Chapter"]
            content = ch.get("content")
            if content:
                where = ch.get("source_path") or ch.get("path") or "?"
                ch["content"] = render_tree(
                    parse_tree(content, where, table), table, where)
            walk(ch.get("sub_items") or [])

    walk(book_nodes(book))
    if table.errors:
        for e in table.errors:
            print(f"mathbook: {e}", file=sys.stderr)
        raise SystemExit(f"mathbook: {len(table.errors)} 处错误，构建中止")
    if orphan := sorted(set(table.full) - table.used):
        print(f"mathbook: 提示 — {len(orphan)} 个锚点未被任何 [@ref] 引用"
              f"（{', '.join(orphan[:5])}{'…' if len(orphan) > 5 else ''}）",
              file=sys.stderr)


def main(argv):
    if len(argv) >= 2 and argv[1] == "supports":
        return 0 if (len(argv) < 3 or argv[2] == "html") else 1
    # mdBook 预处理器协议：stdin 为 JSON 数组 [context, book]，stdout 输出 book。
    data = json.load(sys.stdin)
    if isinstance(data, list):
        _context, book = data[0], data[1]
    else:                                   # 兼容对象形式
        book = data["book"]
    process(book)
    json.dump(book, sys.stdout, ensure_ascii=False)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
