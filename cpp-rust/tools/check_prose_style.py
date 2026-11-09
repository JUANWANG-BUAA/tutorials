#!/usr/bin/env python3
"""报表：扫描正文里的 AI 式棒读句式，供人工逐条判断，不做机械清零。

口径来源：
  - humanizer-zh skill（Wikipedia:Signs of AI writing 的 24 类中文模式）
  - mlm/写作规范/STYLE.md（「不是 A 而是 B」「正是」「值得注意的是」等实测病灶）

这是**报表**不是门禁：命中不等于要改。引文原文、确需并置两种读法、
数学上的「正是这个值」、术语对照表都允许保留。改写时按 humanizer-zh
「回到上下文判断」原则处理，不追求把计数压到零。

用法：
  python3 tools/check_prose_style.py                 # 全量报表
  python3 tools/check_prose_style.py part3/ch11.md  # 只看某几篇
  python3 tools/check_prose_style.py --json         # 机器可读
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "src"

# (类别, 正则, 说明)。刻意不做边界收紧：宁可多报，由人判断。
PATTERNS: list[tuple[str, str, str]] = [
    ("否定式排比", r"不是[^。；！？\n]{0,40}而是|不仅仅是|不仅[^。；！？\n]{0,40}而且", "两拍句式，连读会腻；引文与真并置可留"),
    ("正是", r"正是", "多为段末装饰性总结；数学/同一性语境可留"),
    ("空转插入语", r"值得注意的是|更有意思的是|耐人寻味的是|不难发现|显而易见", "直接说事或删"),
    ("元话语起手", r"一句话[：:]|必须说清|必须承认|需要强调的是|需要指出的是", "自我辩护/口头禅"),
    ("指示填充", r"这里(有|是|的|，)|这一点(很|是|，)", "句子起手式的填充物"),
    ("AI 高频词", r"此外|至关重要|深入探讨|奠定基础|关键作用|不断演变的|彰显|凸显|标志着|体现了|赋能|全方位", "2023 年后高频的抽象词"),
    ("夸大意义", r"为[^。；\n]{0,12}奠定基础|具有[^。；\n]{0,8}意义|的核心|至关重要的一环|不可或缺的", "把任意细节抬到趋势/遗产层面"),
    ("通用积极结尾", r"值得期待|前景广阔|未来可期|迈出了重要的一步|打下了坚实的基础", "模糊乐观收尾"),
]

# humanizer（英文版）里中文教材同样适用的补充模式。默认不扫，用 --extended 打开，
# 以免改变默认口径、打乱按默认报表做的前后对比。
EXTENDED: list[tuple[str, str, str]] = [
    ("说服力话术", r"真正的问题是|本质上|归根结底|说到底|核心在于|关键在于|更深一层", "§27 装作在切穿噪音，后面往往只是复述"),
    ("预告式元话语", r"让我们|接下来我们|下面来看|不妨先|无需赘言|不言而喻", "§28 宣布要做什么，而不是直接做"),
    ("模糊归因", r"业界普遍|一般认为|有观点认为|专家指出|相关研究表明", "§5 把观点归给不具体的权威"),
    ("句尾附加否定", r"[^。；！？\n]{2,12}[，、]不(猜|啰嗦|赘言|必多说)[。！]", "§9 用碎片代替真句子"),
]

FENCE = re.compile(r"^\s*```")
HEADING = re.compile(r"^\s*#{1,6}\s")
TABLE = re.compile(r"^\s*\|")
INLINE_CODE = re.compile(r"`[^`]*`")
HTML_TAG = re.compile(r"<[^>]+>")


def prose_lines(text: str):
    """逐行给出生散文行；跳过围栏代码块、表格、纯标题、裸 HTML。"""
    in_fence = False
    for lineno, raw in enumerate(text.splitlines(), 1):
        if FENCE.match(raw):
            in_fence = not in_fence
            continue
        if in_fence or not raw.strip():
            continue
        if HEADING.match(raw) or TABLE.match(raw):
            continue
        line = HTML_TAG.sub("", raw)
        line = INLINE_CODE.sub("", line)  # 代码里的 "此外" 之类不算散文
        if not line.strip():
            continue
        yield lineno, line, raw.strip()


def scan(path: Path, patterns: list[tuple[str, str, str]] | None = None) -> dict:
    found: dict[str, list[dict]] = {}
    for lineno, line, raw in prose_lines(path.read_text(encoding="utf-8")):
        for kind, pattern, _ in (patterns if patterns is not None else PATTERNS):
            if re.search(pattern, line):
                found.setdefault(kind, []).append({"line": lineno, "text": raw[:160]})
    return {"file": str(path.relative_to(ROOT)), "hits": found,
            "total": sum(len(v) for v in found.values())}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="*", help="相对 src/ 的文件；缺省扫全部 md")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--extended", action="store_true", help="加扫 humanizer 英文版的补充模式")
    args = parser.parse_args()

    if args.files:
        paths = [ROOT / f for f in args.files]
    else:
        paths = sorted(ROOT.rglob("*.md"))
    patterns = PATTERNS + EXTENDED if args.extended else PATTERNS
    results = [scan(p, patterns) for p in paths if p.is_file()]
    results = [r for r in results if r["total"]]

    if args.json:
        print(json.dumps(results, ensure_ascii=False, indent=2))
        return 0

    total = sum(r["total"] for r in results)
    print(f"AI 式句式报表：{len(results)} 篇有命中，共 {total} 行\n")
    for r in results:
        kinds = "、".join(f"{k}×{len(v)}" for k, v in sorted(r["hits"].items(), key=lambda x: -len(x[1])))
        print(f"{r['file']}  {r['total']:>3}  {kinds}")
    print("\n说明：命中不等于要改；引文、真并置、数学语境、术语表按 humanizer-zh「回到上下文判断」保留。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
