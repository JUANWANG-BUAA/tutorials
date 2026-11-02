# -*- coding: utf-8 -*-
"""检查「纯文本三级小节引用」是否真的存在（13.9.4 那类悬空引用）。

[@def-x.y.z] 与 markdown 链接有 check_links 兜底，但正文里手写的「见 13.5.6」「例 13.5.2」
这种纯文本编号不受任何门禁保护——改一次小节编号、或把母题表指向一个并不存在的例题盒，
都悄悄悬空。这条检查补上两个洞：
  1. 任何 X.Y.Z 纯文本编号都要能落到真实小节/语义盒编号（括号后接、空格后接同样要查）；
  2. 带盒子类型的引用（例 13.4.1 / 定义 3.2.2 / 思考 11.2.1 / 判定 13.2.1）必须存在同编号
     的同类型锚点，不能只因为「这个小节存在」就放行。
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

HEAD = re.compile(r"^#{2,4} (\d+(?:\.\d+){1,2})\b", re.M)
# 编号后接任何东西都算候选：只查「是否存在」，误报代价远低于漏网
REF = re.compile(r"(\d{1,2}\.\d{1,2}\.\d{1,2})(?![\d.])")
# 「例 13.5.2」「[@def-3.2.2] 的定义 3.2.2」这类带类型的引用
KIND = re.compile(r"(例|例题|定义|思考|判定)\s*(\d{1,2}\.\d{1,2}\.\d{1,2})(?![\d.])")
KIND_PREFIX = {"例": "ex", "例题": "ex", "定义": "def", "思考": "think", "判定": "method"}
VERSIONY = re.compile(r"[A-Za-z]|rustc|llvm|clang|版本|macOS|Tokio|手册|页")
# 17 章以外的编号一定不是本书小节（外文章节号、工具版本号都落在这里）
MAX_CHAPTER = 17


def code_free(text: str) -> str:
    out, fence = [], False
    for line in text.split("\n"):
        if line.startswith("```"):
            fence = not fence
            continue
        if fence:
            continue
        line = re.sub(r"`[^`]*`", "", line)
        # 链接目标与锚点名里的编号不算「手写引用」：那些由 check_links 负责
        line = re.sub(r"\]\([^)]*\)", "](LINK)", line)
        line = re.sub(r"(?:sec|def|ex|think|method|sol|card|fig)-[\d.r-]+", "ANCHOR", line)
        line = re.sub(r"\[\[[^\]]*\]\]", "WIKILINK", line)
        out.append(line)
    return "\n".join(out)


def main() -> int:
    existing: set[str] = set()
    anchors: set[str] = set()
    files = sorted((ROOT / "src").rglob("*.md"))
    raw = {f: f.read_text(encoding="utf-8") for f in files}
    texts = {f: code_free(t) for f, t in raw.items()}
    # 锚点必须从原文收集：code_free 会把 {#def-1.1.1} 压成 {#ANCHOR}，
    # 若从去码文本里取锚点，集合恒为空，整条检查就退化成「只查小节标题」。
    for text in raw.values():
        for m in HEAD.finditer(text):
            existing.add(m.group(1))
        for m in re.finditer(r"\{#(?:def|ex|think|method|sol)-([\d.]+)\}", text):
            existing.add(m.group(1))
        for m in re.finditer(r"\{#([a-z]+-[\d.]+)\}", text):
            anchors.add(m.group(1))

    bad, bad_kind = [], []
    for f, text in texts.items():
        if f.parts[1] == "appendix":
            continue  # 附录里是外文章节号，不是本书小节
        for line in text.split("\n"):
            if line.startswith("#"):
                continue
            for m in KIND.finditer(line):
                kind, token = m.group(1), m.group(2)
                want = f"{KIND_PREFIX[kind]}-{token}"
                if want in anchors:
                    continue
                ctx = line[max(0, m.start() - 20):m.end() + 14]
                bad_kind.append((f.relative_to(ROOT), f"{kind} {token}", want, ctx.strip()[:90]))
            for m in REF.finditer(line):
                token = m.group(1)
                if token in existing:
                    continue
                x, y, z = (int(v) for v in token.split("."))
                # 形状过滤：本书小节号一定落在 章1–17 / 节1–11 / 盒1–12 里，
                # 不在这个形状的是 rustc/LLVM 版本号（如 1.99.0），不该报悬空
                if not (1 <= x <= MAX_CHAPTER and 1 <= y <= 11 and 1 <= z <= 12):
                    continue
                ctx = line[max(0, m.start() - 24):m.end() + 12]
                if VERSIONY.search(ctx):
                    continue
                bad.append((f.relative_to(ROOT), token, ctx.strip()[:90]))
    if bad or bad_kind:
        if bad_kind:
            print(f"指向不存在语义盒的类型化引用 {len(bad_kind)} 处：")
            for rel, label, want, ctx in bad_kind:
                print(f"  - {rel}: 「{label}」 需要锚点 `{want}` — {ctx}")
        if bad:
            print(f"悬空的纯文本小节引用 {len(bad)} 处：")
            for rel, token, ctx in bad:
                print(f"  - {rel}: 「{token}」 — {ctx}")
        return 1
    print("纯文本小节引用检查通过：手写的小节编号与带类型的盒引用都指向真实存在的锚点")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
