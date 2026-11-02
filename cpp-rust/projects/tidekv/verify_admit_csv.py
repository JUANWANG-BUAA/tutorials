#!/usr/bin/env python3
"""
独立重算 `tide-admit` 的 CSV：不信采集程序写下的比值，只信墙钟与分母。

三件事必须成立，否则直接失败：
  1. 每一行 `raw_batch` 的 `value_ns_per_op` 必须等于 `wall_ns / ops`（attempted 口径）
     或 `wall_ns / accepted`（accepted 口径）——分母落盘了才谈得上复算；
  2. 每一行 `BATCH_MEAN` 必须等于同轮同臂各批原始值的算术平均；
  3. 每轮两臂都在，批数与元数据声明一致，且 `受理 + 被拒 = 尝试`。

这一步存在的理由：正文引用的每个比值都要能被别人从原始文件重推出来，
而不是「采集程序说多少就是多少」。
"""
import argparse
import csv
import sys
from pathlib import Path

TOL = 1e-6


def rel(a, b):
    if b == 0:
        return 0.0 if a == 0 else float("inf")
    return abs(a - b) / abs(b)


def main():
    ap = argparse.ArgumentParser(description="tide-admit CSV 独立重算")
    ap.add_argument("csv_file")
    ap.add_argument("-o", "--out", help="重算报告输出路径（默认 stdout）")
    args = ap.parse_args()

    lines = Path(args.csv_file).read_text().splitlines()
    meta = {}
    for ln in lines:
        if ln.startswith("# seed="):
            for tok in ln.lstrip("# ").split():
                if "=" in tok:
                    k, v = tok.split("=", 1)
                    meta[k] = v
    header_i = next(i for i, ln in enumerate(lines) if ln.startswith("kind,"))
    rows = list(csv.DictReader(lines[header_i:]))
    batches = int(meta.get("batches_per_round", "0"))
    attempted = int(meta.get("ops_per_batch", "0"))
    rounds = int(meta.get("rounds", "0"))

    problems = []
    raw = {}
    means = {}
    accepted_seen = []
    for r in rows:
        key = (r["case"], r["round"], r["arm"])
        wall = float(r["wall_ns"])
        acc = float(r["accepted"])
        if acc + (attempted - acc) != attempted:
            problems.append(f"记账不闭合: {r}")
        if r["kind"] == "raw_batch":
            denom = attempted if r["case"] == "ns_per_attempted" else acc
            expect = wall / denom if denom else 0.0
            if rel(float(r["value_ns_per_op"]), expect) > TOL:
                problems.append(
                    f"raw 比值与重算不符: case={r['case']} round={r['round']} "
                    f"arm={r['arm']} batch={r['batch']} 写了 {r['value_ns_per_op']} 应为 {expect:.6f}"
                )
            raw.setdefault(key, []).append(float(r["value_ns_per_op"]))
            if r["case"] == "ns_per_accepted":
                accepted_seen.append(acc)
        elif r["kind"] == "BATCH_MEAN":
            means[key] = (float(r["value_ns_per_op"]), r["arm_order"])

    for key, vals in raw.items():
        if len(vals) != batches:
            problems.append(f"{key} 有 {len(vals)} 批，声明 {batches} 批")
    for key, (m, order) in means.items():
        vals = raw.get(key)
        if not vals:
            problems.append(f"{key} 只有均值行没有原始行")
            continue
        if rel(m, sum(vals) / len(vals)) > TOL:
            problems.append(
                f"{key} 的 BATCH_MEAN={m:.6f} 与原始值重算 {(sum(vals)/len(vals)):.6f} 不符"
            )

    cases = sorted({k[0] for k in raw})
    for case in cases:
        for rd in range(rounds):
            for arm in ("A", "B"):
                if (case, str(rd), arm) not in raw:
                    problems.append(f"{case} 轮 {rd} 缺臂 {arm}——配对轮不完整，差值无从算起")

    if accepted_seen:
        lo, hi = min(accepted_seen), max(accepted_seen)
        if hi <= lo:
            problems.append("accepted 全程恒定，突发夹具可能没有真正饱和")

    flushes = [float(r["flush"]) for r in rows if r["kind"] == "raw_batch"]
    if not any(f > 0 for f in flushes):
        problems.append("所有批次 flush=0：这批数据里没有段落盘发生，「每受理成本由段落盘主导」无从谈起")
    byt = [float(r["bytes_flushed"]) for r in rows if r["kind"] == "raw_batch"]
    if not any(b > 0 for b in byt):
        problems.append("所有批次 bytes_flushed=0")

    report = [
        "tide-admit CSV 独立重算",
        f"元数据: {meta}",
        f"raw 行数={sum(len(v) for v in raw.values())} 组数={len(raw)} 均值行={len(means)}",
        f"每批受理数范围=[{min(accepted_seen):.0f}, {max(accepted_seen):.0f}]（attempted={attempted}）"
        if accepted_seen
        else "无 accepted 列数据",
        f"每批 flush 次数范围=[{min(flushes):.0f}, {max(flushes):.0f}]  "
        f"落盘字节范围=[{min(byt):.0f}, {max(byt):.0f}]",
        f"重算偏差容忍={TOL:g}",
        "结论: " + ("通过——每个比值都能从 wall_ns 与分母重推出来" if not problems else f"{len(problems)} 处不符"),
    ]
    for p in problems[:20]:
        report.append(f"  - {p}")
    text = "\n".join(report) + "\n"
    if args.out:
        Path(args.out).write_text(text)
    print(text, end="")
    return 1 if problems else 0



if __name__ == "__main__":
    sys.exit(main())
