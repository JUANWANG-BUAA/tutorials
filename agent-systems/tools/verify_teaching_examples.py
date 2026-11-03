#!/usr/bin/env python3
"""独立复核工具授权、RRF 与多代理预算的教学算例（标准库，无网络）。

运行：python3 agent-systems/tools/verify_teaching_examples.py
本脚本验证有限教学模型，不证明生产服务已实现授权或并发安全。
"""

from __future__ import annotations

from fractions import Fraction
import itertools
import math
from pathlib import Path
import re
import unittest

SRC = Path(__file__).resolve().parents[1] / "src"


def fuse(channels: list[list[str]]) -> dict[str, Fraction]:
    """按名次从 1 开始逐文档累加，不让通道分数互相替代。"""
    scores: dict[str, Fraction] = {}
    for channel in channels:
        for rank, document in enumerate(channel, start=1):
            scores[document] = scores.get(document, Fraction()) + Fraction(1, 60 + rank)
    return scores


class TeachingExamples(unittest.TestCase):
    """使用精确算术与穷举核对正文；不调用模型或外部服务。"""

    def test_schema_does_not_grant_object_access(self) -> None:
        owners = {"i-7": "A", "i-8": "B"}
        cases = [
            ({"invoice_id": "i-7"}, True, True),
            ({"invoice_id": "i-8"}, True, False),
            ({"invoice_id": "i-8", "tenant_id": "A"}, False, False),
        ]
        for params, expected_schema, expected_access in cases:
            # 这是本例的有限 schema；并非通用 JSON Schema 验证器。
            schema_ok = set(params) == {"invoice_id"} and isinstance(
                params.get("invoice_id"), str
            )
            authorized = schema_ok and owners.get(params["invoice_id"]) == "A"
            self.assertEqual(schema_ok, expected_schema)
            self.assertEqual(authorized, expected_access)

    def test_rrf_against_printed_table(self) -> None:
        scores = fuse([["a", "b", "c"], ["b", "c"]])
        self.assertEqual(sorted(scores, key=scores.__getitem__, reverse=True), ["b", "c", "a"])
        text = (SRC / "part2/ch06.md").read_text()
        rows = re.findall(r"^\| ([abc]) \| .* \| (0\.\d+) \|$", text, re.M)
        self.assertEqual(len(rows), 3)
        for document, printed in rows:
            self.assertEqual(f"{float(scores[document]):.6f}", printed)
        reduced = fuse([["a", "b", "c"], ["b"]])
        self.assertEqual(sorted(reduced, key=reduced.__getitem__, reverse=True), ["b", "a", "c"])
        self.assertEqual(Fraction(1, 3), Fraction(1, ["b", "c", "a"].index("a") + 1))

    def test_budget_counterexample_and_reclaim(self) -> None:
        self.assertLessEqual(40 + 40 + 20, 100)
        self.assertTrue(all(spent <= limit for spent, limit in ((100, 100), (40, 40), (40, 40))))
        self.assertGreater(100 + 40 + 40, 100)
        used = 12 + 25 + 40
        self.assertEqual(used, 77)
        reclaimed = 40 - 25
        parent_remaining = (20 - 12) + reclaimed
        self.assertEqual(parent_remaining, 23)
        self.assertEqual(used + parent_remaining, 100)
        self.assertEqual(40 + 40 + 35, 115)
        # 缩小额度后穷举全部合法局部消费，独立检验树包络。
        for parent, a, b in itertools.product(range(3), range(5), range(5)):
            self.assertLessEqual(parent + a + b, 10)

    def test_idf_and_recall_diagnosis(self) -> None:
        for n in (1, 10, 100):
            raw = math.log(0.5 / (n + 0.5))
            adjusted = math.log1p(0.5 / (n + 0.5))
            self.assertLess(raw, 0)
            self.assertGreater(adjusted, 0)
        relevant = {"a", "b", "c", "d", "e"}
        # 同样 top-5 recall=0.6，候选召回可以是 0.6，也可以是 1。
        short = ["a", "b", "c", "x", "y"]
        complete = short + ["d", "e"]
        self.assertEqual(len(set(short[:5]) & relevant) / 5, 0.6)
        self.assertEqual(len(set(complete[:5]) & relevant) / 5, 0.6)
        self.assertEqual(len(set(complete) & relevant) / 5, 1.0)


if __name__ == "__main__":
    unittest.main(verbosity=2)
