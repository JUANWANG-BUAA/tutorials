#!/usr/bin/env python3
"""context_budget.py 的不变量测试：硬约束、输出预留、优先级、压缩保真、去重。

运行：
    python3 -m unittest discover -s experiments/ch05 -v
"""

from __future__ import annotations

import json
import unittest

import context_budget as cb


def plan_at(budget: int, reserve: int | None = None) -> dict:
    segments, removed, saved = cb.build_segments()
    if reserve is None:
        reserve = max(1, budget // 5)
    plan = cb.allocate(segments, budget, reserve)
    plan["dedupe_removed"] = removed
    plan["dedupe_saved"] = saved
    return plan


def texts(plan: dict) -> dict[str, str]:
    return {row.name: row.text for row in plan["rows"]}


class TokenEstimateTest(unittest.TestCase):
    def test_cjk_costs_more_per_char(self):
        # 中文约 1 token/字，ASCII 约 0.27 token/字符；同长度下中文更贵
        zh_text, en_text = "中文内容" * 10, "abcdefgh" * 10
        self.assertAlmostEqual(cb.estimate_tokens(zh_text) / len(zh_text), 1.0, places=2)
        self.assertLess(cb.estimate_tokens(en_text) / len(en_text), 0.35)
        self.assertGreater(cb.estimate_tokens(zh_text), cb.estimate_tokens(en_text))

    def test_clip_respects_budget(self):
        text = "中文与 ascii 混排 " * 200
        for budget in (1, 10, 100):
            self.assertLessEqual(cb.estimate_tokens(cb.clip(text, budget)), budget)


class HardConstraintTest(unittest.TestCase):
    def test_pinned_segments_survive_even_when_over_budget(self):
        # 预算小到连硬约束都装不下：仍然不能丢，只能报 over_budget
        plan = plan_at(200, reserve=40)
        self.assertTrue(plan["over_budget"])
        rows = {row.name: row for row in plan["rows"]}
        self.assertEqual(rows["system"].action, "keep")
        self.assertEqual(rows["task"].action, "keep")
        blob = "\n".join(texts(plan).values())
        for label, needle, where in cb.REQUIRED_FIELDS:
            if where == "task":
                self.assertIn(needle, blob, f"硬约束 {label} 被丢弃")

    def test_over_budget_does_not_fake_capacity(self):
        plan = plan_at(200, reserve=40)
        self.assertGreater(plan["used"], plan["input_cap"])
        self.assertTrue(all(row.granted <= row.requested or row.action == "keep"
                            for row in plan["rows"]))


class OutputReserveTest(unittest.TestCase):
    def test_output_reserve_is_never_consumed_by_input(self):
        plan = plan_at(1200, reserve=240)
        self.assertEqual(sum(r.granted for r in plan["rows"]), 960)
        self.assertLessEqual(plan["used"], 960)
        self.assertEqual(plan["reserve"], 240)

    def test_tiny_budget_still_reserves_output(self):
        plan = plan_at(400, reserve=120)
        self.assertLessEqual(plan["used"], 280)
        self.assertLess(plan["input_cap"], plan["budget"])


class PriorityTest(unittest.TestCase):
    def test_low_priority_loses_the_most(self):
        plan = plan_at(1200, reserve=240)
        rows = {row.name: row for row in plan["rows"]}
        self.assertEqual(rows["system"].action, "keep")
        self.assertEqual(rows["task"].action, "keep")
        self.assertEqual(rows["tool_result"].action, "truncate")
        self.assertGreater(rows["tool_result"].loss, rows["memory"].loss)
        self.assertGreater(rows["history"].loss, rows["memory"].loss)

    def test_actions_are_explained_and_bounded(self):
        plan = plan_at(1200, reserve=240)
        for row in plan["rows"]:
            self.assertTrue(row.reason)
            if row.action != "keep":
                self.assertLessEqual(row.used, row.granted)
                self.assertLess(row.granted, row.requested)


class CompressionFidelityTest(unittest.TestCase):
    def test_key_fields_survive_at_1200(self):
        plan = plan_at(1200, reserve=240)
        fields = cb.verify_fields(plan)
        missing = [f["label"] for f in fields if not f["ok"]]
        self.assertEqual(missing, [], f"关键字段缺失：{missing}")

    def test_failure_evidence_survives_history_summary(self):
        plan = plan_at(1200, reserve=240)
        history = texts(plan)["history"]
        self.assertIn("429", history)
        self.assertIn("除以 100", history)

    def test_units_and_numbers_survive_tool_truncation(self):
        plan = plan_at(1200, reserve=240)
        result = texts(plan)["tool_result"]
        self.assertIn("0.0321", result)
        self.assertIn("ref:web#sha256", result)
        self.assertIn("省略", result)

    def test_numeric_field_is_lost_at_800_but_ref_is_kept(self):
        # 预算不够时允许丢文本，但必须留下可回取的 ref，而不是静默消失
        plan = plan_at(800, reserve=160)
        fields = {f["label"]: f for f in cb.verify_fields(plan)}
        self.assertLess(sum(1 for f in fields.values() if f["ok"]), len(fields))
        self.assertIn("省略", texts(plan)["tool_result"])


class UntrustedContentTest(unittest.TestCase):
    def test_tool_result_is_labelled_untrusted(self):
        segments, _, _ = cb.build_segments()
        row = next(s for s in segments if s.name == "tool_result")
        self.assertEqual(row.trust, "untrusted")
        self.assertTrue(row.ref)

    def test_injection_is_truncated_at_default_budget(self):
        plan = plan_at(1200, reserve=240)
        blob = "\n".join(texts(plan).values())
        self.assertNotIn("IGNORE ALL PREVIOUS INSTRUCTIONS", blob)
        self.assertIn("省略", texts(plan)["tool_result"])

    def test_large_budget_lets_untrusted_text_in(self):
        # 这是风险演示，不是期望：窗口足够大时，截断不再是拦截器，
        # 注入文本会原样进入上下文，必须靠 trust 标记与出口策略（第 11 章）。
        plan = plan_at(2400, reserve=480)
        blob = "\n".join(texts(plan).values())
        self.assertIn("IGNORE ALL PREVIOUS INSTRUCTIONS", blob)


class NaiveBaselineTest(unittest.TestCase):
    def test_naive_has_no_reserve_and_loses_fields(self):
        segments, _, _ = cb.build_segments(do_dedupe=False)
        plan = cb.allocate_naive(segments, 800)
        fields = cb.verify_fields(plan)
        self.assertEqual(plan["reserve"], 0)
        self.assertLessEqual(plan["used"], 800)
        self.assertGreaterEqual(sum(1 for f in fields if not f["ok"]), 3)
        rows = {row.name: row for row in plan["rows"]}
        self.assertIn(rows["tool_result"].action, {"drop", "hard_cut"})

    def test_naive_does_not_dedupe(self):
        segments, removed, saved = cb.build_segments(do_dedupe=False)
        self.assertEqual((removed, saved), (0, 0))
        plain = cb.allocate_naive(segments, 2000)
        self.assertIn("版权声明", "\n".join(texts(plain).values()))


class DedupeTest(unittest.TestCase):
    def test_exact_duplicate_lines_are_removed(self):
        text, removed, saved = cb.dedupe_repeated_lines(cb.TOOL_RESULT)
        self.assertGreaterEqual(removed, 3)
        self.assertGreater(saved, 0)
        self.assertLess(text.count("版权声明"), cb.TOOL_RESULT.count("版权声明"))

    def test_near_duplicate_similarity(self):
        a = "日志 2026-10-19T01:20:12Z GET /refund?window=2025Q3&region=east 200 18ms"
        b = "日志 2026-10-19T01:20:13Z GET /refund?window=2025Q3&region=east 200 17ms"
        c = "用户偏好：报告用中文，不要 emoji。"
        self.assertGreater(cb.jaccard_5gram(a, b), 0.75)
        self.assertLess(cb.jaccard_5gram(a, c), 0.2)


class PlanIntegrityTest(unittest.TestCase):
    def test_plan_is_json_serializable(self):
        plan = plan_at(800, reserve=160)
        payload = {
            "mode": plan["mode"],
            "rows": [{"name": r.name, "action": r.action} for r in plan["rows"]],
            "fields": [{"label": f["label"], "ok": f["ok"]}
                       for f in cb.verify_fields(plan)],
        }
        json.dumps(payload, ensure_ascii=False)

    def test_empty_segment_list(self):
        plan = cb.allocate([], 1000, 200)
        self.assertEqual(plan["used"], 0)


if __name__ == "__main__":
    unittest.main()
