#!/usr/bin/env python3
"""把若干份审计报告组装成一轮独立审计台账，条目只从报告里数出来。

存在的理由：`verify_audits.py` 要求轮次条目里的 `P0`/`P1` 与报告里真实 findings 数目相等。
手工填那两个数就等于给了作者一个可以随手清零的入口，所以这里禁止手写：
计数一律遍历报告的 `findings[]` 得到，锚点与来源覆盖也一律从报告里取并集，
覆盖不全直接报错，不写台账。
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from verify_audits import expected_sections  # noqa: E402


def assemble(round_no: int, report_paths: list[str], snapshot: str) -> dict[str, Any]:
    counts = {"P0": 0, "P1": 0}
    covered: set[str] = set()
    sources: set[str] = set()
    seen_reviewers: set[str] = set()
    read_covered: set[str] = set()
    read_sources: set[str] = set()
    read_reviewers: set[str] = set()
    for name in report_paths:
        report = json.loads((ROOT / name).read_text(encoding="utf-8"))
        reviewer = report.get("reviewer", "")
        if not reviewer or reviewer in seen_reviewers:
            raise SystemExit(f"{name}: reviewer 缺失或重复")
        seen_reviewers.add(reviewer)
        if report.get("snapshot_sha256") != snapshot:
            raise SystemExit(f"{name}: 审的是另一个快照，不能记进本轮")
        # layer=read 才算「有冷读者真读过这一节」。机械层由作者的脚本生成，
        # 它能证结构契约，不能抵作通读——否则一轮只交一份机械报告就自称审完全书。
        cold = report.get("layer") == "read"
        if cold:
            read_reviewers.add(reviewer)
        for section in report.get("sections", []):
            if not section.get("notes") or not section.get("evidence"):
                raise SystemExit(f"{name}: {section.get('anchor')} 判定没有依据")
            if section.get("verdict") not in {"pass", "finding"}:
                raise SystemExit(f"{name}: 非法 verdict")
            covered.add(section["anchor"])
            if cold and section.get("method") == "read":
                read_covered.add(section["anchor"])
        for source in report.get("sources", []):
            if not source.get("notes") or not source.get("evidence"):
                raise SystemExit(f"{name}: 来源 {source.get('id')} 判定没有依据")
            sources.add(source["id"])
            if cold:
                read_sources.add(source["id"])
        for finding in report.get("findings", []):
            if finding.get("severity") in counts:
                counts[finding["severity"]] += 1
    missing = expected_sections() - covered
    if missing:
        raise SystemExit(f"本轮漏审 {len(missing)} 个锚点，例如 {sorted(missing)[:5]}")
    need_sources = {f"S{n:02}" for n in range(1, 17)} - sources
    if need_sources:
        raise SystemExit(f"本轮没有独立核对这些母本范围：{sorted(need_sources)}")
    missing_read = expected_sections() - read_covered
    if missing_read:
        raise SystemExit(
            f"{len(missing_read)} 个锚点没有冷读者通读判定（机械层不能抵作读过），"
            f"例如 {sorted(missing_read)[:5]}"
        )
    if len(read_sources) < 16:
        raise SystemExit(
            f"母本台账只有 {len(read_sources)}/16 条经过冷读者核对，不能写台账"
        )
    if len(read_reviewers) < 6:
        raise SystemExit(
            f"冷启动通读评审者只有 {len(read_reviewers)} 名，少于 6 名，不算一轮独立审计"
        )
    return {
        "round": round_no,
        "kind": "independent",
        "snapshot_sha256": snapshot,
        "P0": counts["P0"],
        "P1": counts["P1"],
        "reports": report_paths,
        "sections_covered": len(covered),
        "sections_read": len(read_covered),
        "sources_covered": len(sources),
        "sources_read": len(read_sources),
        "cold_readers": sorted(read_reviewers),
        "reviewers": sorted(seen_reviewers),
        "method": (
            "两层：①机械层是作者写的确定性检查脚本 tools/audit_section_check.py（187 个锚点的结构契约、"
            "交叉引用与链接可解析、16 份母本映射的目标锚点是否真在稿子里），它不判数字与代码是否相符；"
            f"②通读层是 {len(read_reviewers)} 名冷启动子代理逐节通读，"
            f"{len(read_covered)} 个锚点全部有 layer=read 的判定，每个测量数字回查到源码与归档，"
            "16 份母本逐条回查。P0/P1 一律从各报告的 findings 数出来，不接受手写。"
        ),
    }


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--round", type=int, required=True)
    ap.add_argument("--snapshot", required=True)
    ap.add_argument("--reports", required=True, help="逗号分隔的仓库相对路径")
    ap.add_argument("--ledger", default="sources/independent-audits.json")
    args = ap.parse_args()

    paths = [p.strip() for p in args.reports.split(",") if p.strip()]
    entry = assemble(args.round, paths, args.snapshot)
    ledger_path = ROOT / args.ledger
    rounds = json.loads(ledger_path.read_text()) if ledger_path.is_file() else []
    rounds = [r for r in rounds if int(r.get("round", 0)) != args.round]
    rounds.append(entry)
    rounds.sort(key=lambda r: int(r["round"]))
    ledger_path.write_text(json.dumps(rounds, ensure_ascii=False, indent=2) + "\n")
    print(
        f"round {args.round}: {entry['sections_covered']} 节（其中 {entry['sections_read']} 节有冷读者通读判定，"
        f"由 {len(entry['cold_readers'])} 名读者给出）/ 母本 {entry['sources_read']}/16 经冷读者核对 / "
        f"P0={entry['P0']} P1={entry['P1']} -> {args.ledger}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
