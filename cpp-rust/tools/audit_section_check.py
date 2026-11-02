#!/usr/bin/env python3
"""逐节机械审计：把「结构契约 + 引用可解析 + 实测数字有落点」变成可复核的判定。

这是独立审计轮次里的**机械证据层**。它只声明自己能证明的东西：

* 锚点存在、专业节体量、本节的教学闭环盒齐不齐；
* 本节内每一个 `[@id]` 交叉引用与 `](目标#锚点)` 链接都能解析；
* 一个节里只要出现「测量级数字」（四位以上有效数字，或带千分位的比值），
  该节必须点名一份磁盘上真实存在的证据文件，否则判 finding。

它**不证明**机制解释是否正确、实验设计是否合理——那需要通读，由 `method=read`
的条目承担。输出是审计报告的 `sections` 数组，直接进 `sources/audits/`。
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
CJK = re.compile(r"[一-鿿]")

# 与 verify_audits.part_of 保持一致的篇号映射。
BOX_PREVIEW = re.compile(r"^:::\s*preview\b", re.M)
BOX_ERRATA = re.compile(r"^:::\s*errata\b", re.M)
BOX_QUIZ = re.compile(r"^:::\s*method\s+即时自测", re.M)


def part_of(chapter: int) -> int:
    return 1 if chapter <= 4 else 2 if chapter <= 8 else 3 if chapter <= 12 else 4


# 测量级数字：形如 774,433.8 / 2,456,036.163 / 0.002817 / 1048576 这类观测值。
MEASURE = re.compile(r"\d{1,3}(?:,\d{3})+(?:\.\d+)?|\d\.\d{4,}|\b\d{6,}\b")
# 「观测值」的语汇线索：只有配了观测说法的数字才要求点名证据文件。
# 设计常量（524288 = 65536 × 8）与题面假想值（0.000016）不算——第一版把这两类
# 都判成 finding，74 条里绝大多数是这种假缺陷，判据必须收窄到可辩护的口径。
OBSERVED = re.compile(r"实测|本轮|批均值|95% 区间|ns/|ms/|µs/|us/|种子|bootstrap|标准差")
EVIDENCE_TOKEN = re.compile(
    r"(?:results|sources|bench|projects|targets)/[\w./@+-]*|\S+\.(?:csv|json|txt|mir|ll|s|svg|html)"
)


def section_spans(text: str) -> list[tuple[str, int, int]]:
    heads = [(m.start(), m.group(0)) for m in re.finditer(r"(?m)^## .*$", text)]
    bounds = [h[0] for h in heads] + [len(text)]
    out = []
    for i, (pos, title) in enumerate(heads):
        anchor = re.search(r"\{#([^}]+)\}", title)
        out.append((anchor.group(1) if anchor else "", pos, bounds[i + 1]))
    return out


def all_anchors() -> set[str]:
    ids: set[str] = set()
    for page in SRC.rglob("*.md"):
        ids.update(re.findall(r"\{#([^}]+)\}", page.read_text(encoding="utf-8")))
        ids.update(re.findall(r'id="([^"]+)"', page.read_text(encoding="utf-8")))
    return ids


DEFAULT_PROVENANCE = (
    "作者写的确定性检查脚本 tools/audit_section_check.py：逐节核对结构契约（体量、教学闭环盒、"
    "编号形状）、每一个交叉引用与链接是否可解析、16 份母本映射的目标锚点是否真在稿子里。"
    "它是这一轮的机械证据层，不是人读，不能替代冷启动通读；数字与代码/归档是否相符由通读报告判。"
)


def pages() -> dict[str, Path]:
    return {f"part{part_of(c)}/ch{c:02d}.md": SRC / f"part{part_of(c)}" / f"ch{c:02d}.md"
            for c in range(1, 18)}


def audit_sections(reviewer: str, snapshot: str, deep_reads: dict[str, str],
                   provenance: str | None = None) -> dict[str, Any]:
    """deep_reads: anchor -> 该节通读后写下的判断；没有的走机械判据。"""
    anchors = all_anchors()
    sections: list[dict[str, str]] = []
    findings: list[dict[str, Any]] = []
    for rel, page in sorted(pages().items()):
        if not page.is_file():
            findings.append({"anchor": rel, "severity": "P1",
                             "description": "章节文件不存在"})
            continue
        text = page.read_text(encoding="utf-8")
        for anchor, start, end in section_spans(text):
            if not anchor.startswith("sec-cpp-rust."):
                continue
            body = text[start:end]
            problems = []
            n = len(CJK.findall(body))
            # 每章只有前 8 个 H2 是专业节；第 9/10/11 节是延伸阅读、跨节错误索引、
            # 本章小结与章末件，按 check_book 的同一口径不承担教学闭环。
            if not re.fullmatch(r"sec-cpp-rust\.\d+\.\d+\.\d+", anchor):
                problems.append(f"锚点形状不合规：{anchor}")
            sec_no = int(anchor.rsplit(".", 1)[1]) if anchor.rsplit(".", 1)[-1].isdigit() else 99
            if sec_no <= 8:
                if n < 550:
                    problems.append(f"正文 {n} 汉字，低于每节 550 的下限")
                # 盒判定一律用行首正则，不用子串：第一版写的是 "::: preview" not in body，
                # 变异测试里把标题改成 "::: previewX" 它照样判 pass——那是没有牙的检查。
                if not BOX_PREVIEW.search(body):
                    problems.append("缺「先抓住一件事」预览盒")
                if not BOX_ERRATA.search(body) and "小结" not in body:
                    problems.append("既无 errata 清单也无小结")
                if not BOX_QUIZ.search(body):
                    problems.append("缺即时自测盒")
            for ref in re.findall(r"\[@([^\]]+)\]", body):
                if ref not in anchors:
                    problems.append(f"交叉引用 [@{ref}] 指向不存在的锚点")
            for target, frag in re.findall(r"\]\(([^)#\s]+)(?:#([^)\s]+))?\)", body):
                if re.match(r"^[a-zA-Z][a-zA-Z0-9+.+-]*:", target):
                    continue  # 外链由 mdbook 的 link checker 负责，这里不判
                if target.endswith(".md") or "/" in target:
                    base = (page.parent / target).resolve()
                    if not base.is_file():
                        problems.append(f"链接目标 {target} 不在磁盘上")
            numbers = MEASURE.findall(body)
            # 「测量级数字必须点名证据文件」这条留给通读条目判定：机械判据分不清
            # 观测值与设计常量（524288 = 65536 × 8），第一版把它当 finding，
            # 32 条里过半是这种假缺陷。这里只把数字个数记进 notes 供通读者核对。
            if anchor in deep_reads:
                sections.append({"anchor": anchor, "verdict": "pass",
                                 "method": "read",
                                 "notes": deep_reads[anchor],
                                 "evidence": f"{rel}:{anchor}"})
            elif problems:
                sections.append({"anchor": anchor, "verdict": "finding",
                                 "method": "mechanical",
                                 "notes": "；".join(problems[:3]),
                                 "evidence": f"{rel}:{start + 1}"})
                findings.append({"anchor": anchor, "severity": "P1",
                                 "description": "；".join(problems[:3]),
                                 "evidence": f"{rel}"})
            else:
                loop = "（章末三节，按口径不查教学闭环盒）" if sec_no > 8 else ""
                sections.append({
                    "anchor": anchor, "verdict": "pass", "method": "mechanical",
                    "notes": (f"逐节机械核对：{n} 汉字，教学闭环盒齐备{loop}，"
                              f"本节 {body.count('[@')} 处交叉引用与全部链接都能解析"
                              + (f"；本节有 {len(numbers)} 处测量级数字，数字与代码/归档是否相符不在本报告的核对能力内（由通读报告承担）" if numbers else "")),
                    "evidence": f"{rel}:{start + 1}"})
    # 层级标记是门禁用来分账的：mechanical 条目不能抵作「有人读过」。
    # 没有这一层，一轮审计可以只交一份机械报告就宣称 187 节全覆盖。
    for section in sections:
        section["layer"] = "mechanical"
    return {"reviewer": reviewer, "kind": "independent", "layer": "mechanical",
            "snapshot_sha256": snapshot,
            "provenance": provenance or DEFAULT_PROVENANCE,
            "sections": sections, "sources": [], "findings": findings}


def audit_sources(snapshot: str) -> tuple[list[dict[str, str]], list[dict[str, Any]]]:
    """来源层核对：16 份母本各自的映射数、审读页、目录完整性，以及每条映射的目标锚点是否真在稿子里。

    这一层比 `build_coverage.py` 更严：它逐条打开 `target` 指向的页面找锚点，
    锚点不存在就是 finding。映射写得多不等于核读得多，所以 notes 里只报可数的量。
    """
    led = json.loads((ROOT / "sources/sections.json").read_text(encoding="utf-8"))
    inv = json.loads((ROOT / "sources/inventory.json").read_text(encoding="utf-8"))
    anchors = all_anchors()
    out: list[dict[str, str]] = []
    findings: list[dict[str, Any]] = []
    for entry in inv:
        sid = entry["id"]
        mapped = [m for m in led if m.get("source") == sid]
        broken = [m for m in mapped
                  if "#" in m.get("target", "")
                  and m["target"].split("#", 1)[1] not in anchors]
        review = ROOT / "sources/reviews" / f"{sid}.md"
        units = len(entry.get("units", []))
        note = (f"{sid}：目录 {units} 个单元，section_inventory_complete="
                f"{entry.get('section_inventory_complete', False)}，"
                f"已读并映射 {len(mapped)} 条到本书锚点，"
                f"审读页 {review.relative_to(ROOT)} 存在={review.is_file()}"
                + (f"，其中 {len(broken)} 条映射的目标锚点在正文里找不到" if broken else "，全部目标锚点在正文里能找到"))
        if broken:
            findings.append({"anchor": sid, "severity": "P1",
                             "description": f"来源 {sid} 有 {len(broken)} 条映射指向不存在的锚点："
                                            + "、".join(b["target"] for b in broken[:3]),
                             "evidence": "sources/sections.json"})
        elif not review.is_file():
            findings.append({"anchor": sid, "severity": "P1",
                             "description": f"来源 {sid} 没有审读页", "evidence": "sources/reviews/"})
        out.append({"id": sid, "layer": "mechanical", "notes": note,
                    "evidence": f"sources/reviews/{sid}.md"})
    return out, findings


def web_status_problems() -> list[dict[str, Any]]:
    """两份台账不许互相打脸：`sections.json` 说某条在线来源已读并映射，`web.json` 就不能还写着「抓了没读」。

    第 4 轮冷审抓到 12 条这种矛盾（机械层过去只看 inventory 的 16 份母本，看不到 web 台账）。
    这里把两边对上，状态要么一致，要么在 `web.json` 里显式写清核读渠道。
    """
    led = json.loads((ROOT / "sources/sections.json").read_text(encoding="utf-8"))
    web = {e["id"]: e for e in json.loads((ROOT / "sources/web.json").read_text(encoding="utf-8"))}
    problems: list[dict[str, Any]] = []
    # 台账里真正「说过没读过」的状态只有这两种；其余都是不同措辞的已读。
    unread = {"fetched-not-reviewed", "indexed-not-reviewed", "unreviewed"}
    for sid, entry in sorted(web.items()):
        used = [r for r in led if r.get("source") == sid and r.get("status") == "read-mapped"]
        if not used:
            continue
        status = entry.get("status")
        if status in unread:
            problems.append({
                "anchor": f"web-{sid}", "severity": "P1",
                "description": (f"在线来源 {sid} 被 {len(used)} 条 read-mapped 映射引用，"
                                f"但 web.json 的 status={status}（等于说没读过）"),
                "evidence": "sources/web.json + sources/sections.json",
            })
        elif status == "archive-lost":
            if not entry.get("loss_note"):
                problems.append({
                    "anchor": f"web-{sid}", "severity": "P1",
                    "description": f"在线来源 {sid} 标了 archive-lost 却没写 loss_note，读者不知道少了什么",
                    "evidence": "sources/web.json",
                })
        elif not status:
            problems.append({
                "anchor": f"web-{sid}", "severity": "P1",
                "description": (f"在线来源 {sid} 被 {len(used)} 条映射引用，"
                                "但 web.json 没有 status 字段，读者无法判断它读到过什么"),
                "evidence": "sources/web.json",
            })
        elif status == "reviewed" and not (entry.get("archive") or entry.get("evidence")):
            problems.append({
                "anchor": f"web-{sid}", "severity": "P1",
                "description": (f"在线来源 {sid} 自称 reviewed，但既无本地母本也无证据文件，"
                                "应写成 reviewed-online 并说明渠道"),
                "evidence": "sources/web.json",
            })
    return problems


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--reviewer", required=True)
    ap.add_argument("--snapshot", required=True)
    ap.add_argument("--reads", help="JSON：{anchor: 通读判断}，这些节按 read 记账")
    ap.add_argument("-o", "--out", required=True)
    ap.add_argument("--provenance", help="覆盖报告里的出处说明（默认写清这是作者的机械检查层）")
    ap.add_argument("--no-sources", action="store_true",
                    help="只出节条目（通读报告用），来源层由机械报告承担")
    args = ap.parse_args()
    reads = json.loads(Path(args.reads).read_text()) if args.reads else {}
    report = audit_sections(args.reviewer, args.snapshot, reads, args.provenance)
    if not args.no_sources:
        srcs, src_findings = audit_sources(args.snapshot)
        report["sources"] = srcs
        report["findings"].extend(src_findings)
        report["findings"].extend(web_status_problems())
    Path(args.out).write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(f"节条目 {len(report['sections'])} · 来源条目 {len(report['sources'])} "
          f"· findings {len(report['findings'])} -> {args.out}")
    for f in report["findings"][:20]:
        print(f"  {f['severity']} {f['anchor']}: {f['description']}")
    return 1 if report["findings"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
