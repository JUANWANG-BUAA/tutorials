#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""教材行文体检（非阻塞）。

不替代 check_book.py 的结构门禁；它给「主线 / 文段 / 行文」三视角审读提供客观信号：

- 每节是否有「这一节回答」、`preview`、小结、即时自测；
- 段落是否过长、句子是否过长、是否一句一行；
- 是否出现审计口吻、口号化过渡、绝对化断言；
- 章末五件套是否齐备。

用法（工作目录 linux/）：
    python3 tools/textbook_lint.py                 # 全部正文
    python3 tools/textbook_lint.py src/part0/ch01.md
    python3 tools/textbook_lint.py --summary       # 只看汇总
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SRC = ROOT / "src"

H2 = re.compile(r"^## ", re.M)
SECTION_Q = re.compile(r"这一节回答")
PREVIEW = re.compile(r"^:::\s*preview\b", re.M)
QUIZ = re.compile(r"^:::\s*method\s+即时自测", re.M)
ERRATA = re.compile(r"^:::\s*errata\b", re.M)
DEF = re.compile(r"^:::\s*def\b", re.M)
EX = re.compile(r"^:::\s*ex\b", re.M)
EX_BLOCK = re.compile(r"^:::\s*ex\b[^\n]*\n(.*?)^:::", re.S | re.M)
GUESS = ("先猜", "先预测", "先选", "先写", "先自己")
SOL = re.compile(r"^:::\s*sol\b", re.M)
REF = re.compile(r"\[@[\w.\-]+\]")

BANNED = {
    "本章将介绍": "空话开场",
    "综上所述": "空话收尾",
    "值得注意的是": "口头禅",
    "笔者": "人称漂移",
    "读者": "人称漂移",
    "显然": "跳过步骤",
    "众所周知": "跳过步骤",
    "不难看出": "跳过步骤",
    "本轮": "审计口吻",
    "门禁": "审计口吻",
    "证据链": "审计口吻",
}

# 子串匹配自身的假阳性：`根本|轮不到` 里含「本轮」，FIFO 语境里的「读者/写者」是技术名词。
NOT_BEFORE = {"本轮": "根"}


def count_banned(body: str, word: str) -> int:
    nb = NOT_BEFORE.get(word)
    if not nb:
        return body.count(word)
    return len(re.findall(rf"(?<!{nb}){re.escape(word)}", body))


HARD_TERMS = (
    "文件描述符", "页表", "虚拟内存", "inode", "系统调用", "中断", "DMA",
    "写时复制", "COW", "缺页", "TLB", "缓存行", "伪共享", "原子操作",
    "内存序", "背压", "零拷贝", "namespace", "cgroup", "overlayfs",
    "三次握手", "拥塞控制", "epoll", "io_uring", "VFS", "slab",
)


def read_body(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    out, in_fence = [], False
    for line in text.splitlines():
        if line.strip().startswith("```"):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        out.append(line)
    return "\n".join(out)


def paragraphs(body: str) -> list[str]:
    """按空行切段，跳过标题、表格、HTML、盒子标记。"""
    paras, cur = [], []
    for line in body.splitlines():
        s = line.strip()
        if not s or s.startswith(("#", "|", "<", ":::", "![", "---", ">")):
            if cur:
                paras.append("".join(cur))
                cur = []
            continue
        if s.startswith(("- ", "* ")) or re.match(r"^\d+\. ", s):
            continue
        cur.append(s)
    if cur:
        paras.append("".join(cur))
    return paras


def han(s: str) -> int:
    return len(re.findall(r"[\u4e00-\u9fff]", s))


def stats(path: Path) -> dict:
    text = path.read_text(encoding="utf-8")
    body = read_body(path)
    # 「母本对应」是书末对照附录，不是教学节：不参与「这一节回答/自测/术语首现」计数
    body = re.split(r"^## 母本对应", body, flags=re.M)[0]
    paras = paragraphs(body)
    paras = [
        p for p in paras
        if not re.match(r"^\*\*[QA]\d", p)
        and not p.rstrip().endswith(("：", ":"))
    ]
    chars = [han(p) for p in paras]
    sents = [p.count("。") + p.count("！") + p.count("？") for p in paras]
    total_han = sum(chars) or 1
    one_line = sum(1 for s in sents if s <= 1)
    bullets = sum(1 for l in body.splitlines() if l.strip().startswith(("- ", "* ")))
    nonempty = sum(1 for l in body.splitlines() if l.strip()) or 1
    banned = {k: n for k in BANNED for n in [count_banned(body, k)] if n}
    unglossed = []
    # 标题行不算「首现」：`# 1.9 虚拟内存` 这类章名会把自己报成未加注的术语。
    prose = "\n".join(l for l in body.splitlines() if not l.lstrip().startswith("#"))
    for term in HARD_TERMS:
        i = prose.find(term)
        if i < 0:
            continue
        window = prose[max(0, i - 8): i + len(term) + 28]
        if any(x in window for x in ("（", "(")):
            continue
        # 另一种合法加注：术语本身就在括号里被解释，如「写时复制（copy-on-write, COW）」。
        # 向后找一对没闭合的左括号，中间不能有右括号。
        back = prose[max(0, i - 100):i]
        if max(back.rfind("（"), back.rfind("(")) > max(back.rfind("）"), back.rfind(")")):
            continue
        unglossed.append(term)
    return {
        "h2": len(H2.findall(body)),
        "q": len(SECTION_Q.findall(body)),
        "preview": len(PREVIEW.findall(text)),
        "quiz": len(QUIZ.findall(text)),
        "errata": len(ERRATA.findall(text)),
        "def": len(DEF.findall(text)),
        "ex": len(EX.findall(text)),
        "ex_guess": sum(1 for b in EX_BLOCK.findall(text) if any(w in b for w in GUESS)),
        "sol": len(SOL.findall(text)),
        "refs": len(REF.findall(body)),
        "para_avg": sum(chars) / len(paras) if paras else 0,
        "para_max": max(chars) if chars else 0,
        "sent_avg": total_han / (sum(sents) or 1),
        "one_line_pct": 100 * one_line / (len(paras) or 1),
        "bullet_pct": 100 * bullets / nonempty,
        "banned": banned,
        "unglossed": unglossed,
    }


def kit_status(path: Path) -> tuple[int, list[str]]:
    stem = path.stem
    d = path.parent
    names = ["summary", "recall", "exercises", "checklist", "errata"]
    have = [n for n in names if (d / f"{stem}-{n}.md").exists()]
    return len(have), have


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    summary_only = "--summary" in sys.argv
    files = [Path(a).resolve() if not Path(a).is_absolute() else Path(a) for a in args] if args else sorted(
        p for p in SRC.glob("part*/ch[0-9][0-9].md")
    )
    rows = []
    for path in files:
        s = stats(path)
        kit_n, _ = kit_status(path)
        rows.append((path, s, kit_n))

    if not summary_only:
        print("【章节行文体检】")
        print(
            f"{'chapter':22}{'H2':>4}{'问题':>5}{'preview':>8}{'自测':>5}"
            f"{'errata':>7}{'段均':>6}{'段最大':>7}{'句均':>6}{'一行段%':>8}{'bullet%':>8}{'套件':>5}"
        )
        for path, s, kit_n in rows:
            print(
                f"{path.relative_to(ROOT).as_posix():22}{s['h2']:>4}{s['q']:>5}{s['preview']:>8}"
                f"{s['quiz']:>5}{s['errata']:>7}{s['para_avg']:>6.0f}{s['para_max']:>7}"
                f"{s['sent_avg']:>6.1f}{s['one_line_pct']:>8.1f}{s['bullet_pct']:>8.1f}{kit_n:>5}/5"
            )

    print("\n【需要优先处理的信号】")
    for path, s, kit_n in rows:
        issues = []
        if s["h2"] and s["q"] < s["h2"]:
            issues.append(f"缺「这一节回答」{s['h2'] - s['q']}/{s['h2']}")
        if s["h2"] and s["quiz"] < s["h2"]:
            issues.append(f"缺即时自测 {s['h2'] - s['quiz']}/{s['h2']}")
        # 骨架齐却一个例题都没有：progress.py 与 check_book 都查不出这个缺口（2.8 曾如此）
        if s["h2"] and s["q"] >= s["h2"] and s["quiz"] >= s["h2"] and s["ex"] == 0:
            issues.append("骨架齐但例题盒为 0")
        if s["ex"] and s["ex_guess"] < s["ex"]:
            issues.append(f"例题缺先猜 {s['ex'] - s['ex_guess']}/{s['ex']}")
        if s["para_max"] > 320:
            issues.append(f"最长段落 {s['para_max']} 字")
        if s["sent_avg"] > 60:
            issues.append(f"句均 {s['sent_avg']:.0f} 字")
        if s["one_line_pct"] > 35:
            issues.append(f"一行段 {s['one_line_pct']:.0f}%")
        if s["banned"]:
            issues.append("口头禅/审计口吻：" + "、".join(s["banned"]))
        if s["unglossed"]:
            issues.append("首现未解释：" + "、".join(s["unglossed"][:5]))
        if kit_n < 5:
            issues.append(f"章末件 {kit_n}/5")
        if issues:
            print(f"- {path.relative_to(ROOT).as_posix()}: " + "；".join(issues))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
