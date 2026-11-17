#!/usr/bin/env python3
"""Validate and summarize a Lab 3 measurement ledger (no GPU required)."""

import argparse
import json
import math
import sys
from pathlib import Path
from typing import Any


def main() -> int:
    """Read a JSON ledger, report incomplete data, and compare measurements."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ledger", type=Path, help="UTF-8 JSON measurement ledger")
    args = parser.parse_args()
    try:
        data = json.loads(args.ledger.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        print(f"无法读取 JSON: {exc}", file=sys.stderr)
        return 1

    errors: list[str] = []

    def obj(value: Any, path: str) -> dict[str, Any]:
        if not isinstance(value, dict):
            errors.append(f"{path}: 需要对象")
            return {}
        return value

    def text(item: dict[str, Any], key: str, path: str) -> str:
        value = item.get(key)
        if not isinstance(value, str) or not value.strip():
            errors.append(f"{path}.{key}: 需要非空字符串")
            return ""
        return value

    def number(item: dict[str, Any], key: str, path: str, *, integer: bool = False,
               zero: bool = False, negative: bool = False) -> float:
        value = item.get(key)
        if (isinstance(value, bool) or not isinstance(value, (int, float))
                or not math.isfinite(value) or (not negative and (value < 0 if zero else value <= 0))
                or (integer and not isinstance(value, int))):
            kind = "有限数字" if negative else ("非负" if zero else "正") + ("整数" if integer else "有限数字")
            errors.append(f"{path}.{key}: 需要{kind}")
            return 0
        return value

    root = obj(data, "根")
    meta = obj(root.get("metadata"), "metadata")
    for key in ("model", "model_revision", "task", "split", "environment", "precision",
                "targets", "measurement_method", "validation_metric", "baseline_metric"):
        text(meta, key, "metadata")
    matrices = root.get("matrices")
    shape_sum = 0
    if not isinstance(matrices, list) or not matrices:
        errors.append("matrices: 需要非空数组，列出实际目标矩阵")
    else:
        for index, entry in enumerate(matrices):
            path = f"matrices[{index}]"
            matrix = obj(entry, path)
            text(matrix, "name", path)
            inp = number(matrix, "in", path, integer=True)
            out = number(matrix, "out", path, integer=True)
            count = number(matrix, "count", path, integer=True)
            shape_sum += (inp + out) * count

    runs = root.get("runs")
    summaries: list[dict[str, Any]] = []
    if not isinstance(runs, list) or len(runs) < 2:
        errors.append("runs: 至少需要两组")
        runs = []
    for index, entry in enumerate(runs):
        path = f"runs[{index}]"
        run = obj(entry, path)
        name = text(run, "name", path)
        for key in ("optimizer", "schedule", "config", "curve_file"):
            text(run, key, path)
        rank = number(run, "rank", path, integer=True)
        lr = number(run, "learning_rate", path)
        batch = number(run, "batch", path, integer=True)
        accum = number(run, "accumulation", path, integer=True)
        devices = number(run, "devices", path, integer=True)
        estimated = number(run, "estimated_peak_gb", path)
        peak = number(run, "peak_gb", path)
        latency = number(run, "latency_ms", path)
        estimated_latency = number(run, "estimated_latency_ms", path)
        tokens = number(run, "effective_tokens", path, integer=True)
        metric = number(run, "validation_value", path, negative=True)
        measured_params = number(run, "trainable_params", path, integer=True)
        extra_params = number(run, "extra_trainable_params", path, integer=True, zero=True)
        for key in ("train_loss", "validation_loss"):
            curve = run.get(key)
            if (not isinstance(curve, list) or len(curve) < 2
                    or any(isinstance(v, bool) or not isinstance(v, (int, float))
                           or not math.isfinite(v) or v < 0 for v in curve)):
                errors.append(f"{path}.{key}: 需要至少两个非负有限 loss 值")
        summaries.append(dict(name=name, rank=rank, lr=lr, batch=batch, accum=accum,
                              devices=devices, estimated=estimated, peak=peak, latency=latency,
                              estimated_latency=estimated_latency, tokens=tokens, metric=metric,
                              params=measured_params, extra_params=extra_params))
    if errors:
        print("账本不完整或数据无效：", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print("完整性检查通过；以下估算得分仅比较所填数据，不能证明实测真实性或实验质量。")
    for run in summaries:
        expected = run["rank"] * shape_sum + run["extra_params"]
        print(f"{run['name']}: 可训参数估算 {expected}，实测可训 {run['params']} 参数；"
              f"有效批量 {run['batch'] * run['accum'] * run['devices']} 样本")
        print(f"  峰值估算/实测 {run['estimated']}/{run['peak']} GB；"
              f"延迟估算/实测 {run['estimated_latency']}/{run['latency']} ms；"
              f"有效 token {run['tokens']}；留出指标 {run['metric']}")
        relative_errors = [abs(estimate - actual) / actual for estimate, actual in (
            (expected, run["params"]), (run["estimated"], run["peak"]),
            (run["estimated_latency"], run["latency"]))]
        score = 100 * sum(1 - min(error, 1) for error in relative_errors) / 3
        print(f"  参数/显存/延迟相对误差 {relative_errors[0]:.1%}/{relative_errors[1]:.1%}/{relative_errors[2]:.1%}；"
              f"估算得分 {score:.2f}/100（仅衡量估算误差）")
        if expected != run["params"]:
            print("  参数数目不同：检查目标矩阵、额外可训练参数及共享权重。")
    first = summaries[0]
    for run in summaries[1:]:
        print(f"{run['name']} 相对 {first['name']}: 峰值 {run['peak'] - first['peak']:+.3f} GB，"
              f"延迟 {run['latency'] - first['latency']:+.3f} ms，"
              f"留出指标 {run['metric'] - first['metric']:+.6g}；请人工核对对照条件。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
