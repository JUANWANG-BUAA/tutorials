#!/usr/bin/env python3
"""第 10 章实验的单元测试：父子关系、trace 一致、断链、回放不重复、TZ 空值。

跑法：

    python3 -m unittest discover -s experiments/ch10 -v
"""

from __future__ import annotations

import copy
import io
import json
import os
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import replay  # noqa: E402
import tracer  # noqa: E402


def records_for(**kwargs) -> list[dict]:
    t = tracer.Tracer()
    tracer.SIDE_EFFECTS.clear()
    tracer.run_agent(t, **kwargs)
    return [s.to_record() for s in t.spans]


class TraceShapeTest(unittest.TestCase):
    def test_normal_trace_has_single_root_and_valid_tree(self) -> None:
        spans = records_for()
        rep = replay.check_integrity(spans)
        self.assertTrue(rep.ok, rep.problems)
        self.assertEqual(rep.traces, 1)
        self.assertEqual(rep.roots, 1)
        self.assertEqual(rep.spans, 11)
        self.assertEqual(rep.orphan_spans, [])
        self.assertEqual(rep.containment_violations, [])

    def test_every_non_root_has_parent_in_same_trace(self) -> None:
        spans = records_for()
        ids = {s["span_id"] for s in spans}
        for span in spans:
            if span["parent_span_id"] is None:
                continue
            self.assertIn(span["parent_span_id"], ids)
            parent = next(p for p in spans if p["span_id"] == span["parent_span_id"])
            self.assertEqual(parent["trace_id"], span["trace_id"])

    def test_ids_and_traceparent_are_w3c_shaped(self) -> None:
        t = tracer.Tracer()
        tracer.run_agent(t)
        spans = [s.to_record() for s in t.spans]
        for span in spans:
            self.assertRegex(span["trace_id"], r"^[0-9a-f]{32}$")
            self.assertRegex(span["span_id"], r"^[0-9a-f]{16}$")
            self.assertNotEqual(span["trace_id"], "0" * 32)
        tool = next(s for s in spans
                    if s["attributes"].get("gen_ai.tool.name") == "kb.search")
        header = tool["attributes"]["mcp.request.meta.traceparent"]
        self.assertRegex(header, r"^00-[0-9a-f]{32}-[0-9a-f]{16}-01$")
        parts = header.split("-")
        self.assertEqual(parts[1], tool["trace_id"])
        self.assertEqual(parts[2], tool["span_id"])

    def test_same_seed_same_bytes(self) -> None:
        a = records_for(worker_lag_ms=0)
        b = records_for(worker_lag_ms=0)
        self.assertEqual(json.dumps(a, sort_keys=True), json.dumps(b, sort_keys=True))

    def test_different_seed_different_trace_id(self) -> None:
        t1, t2 = tracer.Tracer(seed=7), tracer.Tracer(seed=8)
        tracer.run_agent(t1)
        tracer.run_agent(t2)
        self.assertNotEqual(t1.spans[0].trace_id, t2.spans[0].trace_id)


class BrokenChainTest(unittest.TestCase):
    def test_break_chain_splits_trace(self) -> None:
        spans = records_for(break_chain=True)
        rep = replay.check_integrity(spans)
        self.assertFalse(rep.ok)
        self.assertEqual(rep.traces, 2)
        self.assertEqual(rep.orphan_spans, [])
        self.assertEqual(len(rep.orphan_roots), 1)
        self.assertTrue(any("没有 run span" in p for p in rep.problems))
        tool = next(s for s in spans
                    if s["attributes"].get("gen_ai.tool.name") == "ticket.update")
        self.assertEqual(tool["attributes"]["app.propagation"], "missing")
        self.assertIsNone(tool["parent_span_id"])

    def test_replay_is_incomplete_when_tool_missing(self) -> None:
        spans = records_for(break_chain=True)
        result = replay.replay(spans)
        self.assertEqual(result["status"], "incomplete")
        self.assertEqual(result["tools_executed"], 0)
        self.assertTrue(any("ticket.update" in m for m in result["missing"]))

    def test_normal_trace_replays_all_recorded_tools(self) -> None:
        spans = records_for()
        result = replay.replay(spans)
        self.assertEqual(result["status"], "replayed")
        self.assertEqual(result["steps"], 3)
        self.assertEqual([a["tool"] for a in result["results"]],
                         ["kb.search", "ticket.update"])
        self.assertTrue(all(a["source"] == "record" for a in result["results"]))


class ReplaySafetyTest(unittest.TestCase):
    def test_replay_does_not_execute_side_effects(self) -> None:
        tracer.SIDE_EFFECTS.clear()
        t = tracer.Tracer()
        result = tracer.run_agent(t)
        self.assertEqual(result["side_effects"], 1)
        self.assertEqual(len(tracer.SIDE_EFFECTS), 1)

        spans = [s.to_record() for s in t.spans]
        replay.replay(spans)
        replay.replay(spans)
        # 回放两次，副作用流水仍然只有一条：重放读的是 app.tool.result。
        self.assertEqual(len(tracer.SIDE_EFFECTS), 1)

    def test_replay_never_imports_tool_implementation(self) -> None:
        with open(os.path.join(os.path.dirname(__file__), "replay.py"),
                  encoding="utf-8") as fh:
            source = fh.read()
        self.assertNotIn("import tracer", source)
        self.assertNotIn("subprocess", source)

    def test_answer_comes_from_record(self) -> None:
        t = tracer.Tracer()
        tracer.run_agent(t)
        recorded = next(s.attributes["app.answer"] for s in t.spans if s.kind == "run")
        result = replay.replay([s.to_record() for s in t.spans])
        self.assertEqual(result["answer"], recorded)


class ClockDriftTest(unittest.TestCase):
    def test_worker_lag_creates_negative_offset(self) -> None:
        spans = records_for(worker_lag_ms=850)
        rep = replay.check_integrity(spans)
        self.assertFalse(rep.ok)
        self.assertEqual(len(rep.containment_violations), 1)
        self.assertTrue(any("早于父 span" in p for p in rep.problems))
        tool = next(s for s in spans
                    if s["attributes"].get("gen_ai.tool.name") == "ticket.update")
        self.assertEqual(tool["attributes"]["app.clock.offset_ms"], -850)

    def test_lag_keeps_duration_but_moves_timestamp(self) -> None:
        normal = next(s for s in records_for()
                      if s["attributes"].get("gen_ai.tool.name") == "ticket.update")
        lagged = next(s for s in records_for(worker_lag_ms=850)
                      if s["attributes"].get("gen_ai.tool.name") == "ticket.update")
        self.assertEqual(normal["duration_ms"], lagged["duration_ms"])
        self.assertEqual(normal["start_unix_nano"] - lagged["start_unix_nano"],
                         850 * 1_000_000)

    def test_tree_marks_negative_offset(self) -> None:
        t = tracer.Tracer()
        tracer.run_agent(t, worker_lag_ms=850)
        buf = io.StringIO()
        tracer.render_tree(t.spans, buf)
        self.assertIn("-205ms", buf.getvalue())
        self.assertIn("!!", buf.getvalue())


class LinkTest(unittest.TestCase):
    def test_async_followup_uses_link_not_parent(self) -> None:
        t = tracer.Tracer()
        tracer.run_agent(t)
        run_span = next(s for s in t.spans if s.kind == "run")
        follow = tracer.run_followup(t, link_trace_id=run_span.trace_id,
                                     link_span_id=run_span.span_id)
        spans = [s.to_record() for s in t.spans]
        rep = replay.check_integrity(spans)
        self.assertTrue(rep.ok, rep.problems)
        self.assertEqual(rep.traces, 2)
        self.assertEqual(rep.linked_roots, 1)
        self.assertIsNone(follow.parent_span_id)
        self.assertNotEqual(follow.trace_id, run_span.trace_id)
        self.assertEqual(follow.links[0]["trace_id"], run_span.trace_id)


class DetectorTest(unittest.TestCase):
    def test_duplicate_span_id_detected(self) -> None:
        spans = records_for()
        bad = copy.deepcopy(spans)
        bad[3]["span_id"] = bad[2]["span_id"]
        rep = replay.check_integrity(bad)
        self.assertFalse(rep.ok)
        self.assertEqual(len(rep.duplicate_ids), 1)

    def test_negative_duration_detected(self) -> None:
        spans = records_for()
        bad = copy.deepcopy(spans)
        bad[4]["duration_ms"] = -1.0
        rep = replay.check_integrity(bad)
        self.assertFalse(rep.ok)
        self.assertEqual(len(rep.negative_durations), 1)

    def test_orphan_span_detected(self) -> None:
        spans = records_for()
        bad = copy.deepcopy(spans)
        bad[5]["parent_span_id"] = "deadbeefdeadbeef"
        rep = replay.check_integrity(bad)
        self.assertFalse(rep.ok)
        self.assertEqual(len(rep.orphan_spans), 1)

    def test_no_run_root_detected(self) -> None:
        spans = records_for()
        bad = copy.deepcopy(spans)
        root = next(s for s in bad if s["parent_span_id"] is None)
        root["kind"] = "step"
        rep = replay.check_integrity(bad)
        self.assertFalse(rep.ok)


class DiffTest(unittest.TestCase):
    def test_diff_finds_missing_tool_and_new_root(self) -> None:
        normal = records_for()
        broken = records_for(break_chain=True)
        result = replay.diff_traces(normal, broken)
        removed = [i["path"] for i in result["removed"]]
        added = [i["path"] for i in result["added"]]
        self.assertEqual(len(removed), 1)
        self.assertIn("ticket.update", removed[0])
        self.assertEqual(len(added), 1)
        self.assertTrue(added[0].startswith("execute_tool ticket.update"))
        self.assertEqual(result["baseline"]["traces"], 1)
        self.assertEqual(result["candidate"]["traces"], 2)

    def test_identical_traces_have_empty_diff(self) -> None:
        a = records_for()
        b = records_for()
        result = replay.diff_traces(a, b)
        self.assertEqual(result["removed"], [])
        self.assertEqual(result["added"], [])
        self.assertEqual(result["changed"], [])


class JsonlTest(unittest.TestCase):
    def test_roundtrip_and_required_fields(self) -> None:
        t = tracer.Tracer()
        tracer.run_agent(t)
        with tempfile.TemporaryDirectory() as tmp:
            path = os.path.join(tmp, "trace.jsonl")
            with open(path, "w", encoding="utf-8") as fh:
                n = t.dump(fh)
            self.assertEqual(n, len(t.spans) + len(t.logs))
            spans, logs = replay.load(path)
            self.assertEqual(len(spans), 11)
            self.assertEqual(len(logs), len(t.logs))
            for span in spans:
                for key in replay.REQUIRED:
                    self.assertIn(key, span)


class TimezoneTest(unittest.TestCase):
    """TZ 空串 / 无法解释 → UTC。这是内核与 libc 的行为，不是 Python 的约定。"""

    def _offset(self, tz: str) -> str:
        env = dict(os.environ)
        env["TZ"] = tz
        code = "import time; time.tzset(); print(time.strftime('%z'))"
        out = subprocess.run([sys.executable, "-c", code], env=env,
                             capture_output=True, text=True, check=True)
        return out.stdout.strip()

    @unittest.skipIf(sys.platform.startswith("win"), "Windows 没有 tzset")
    def test_empty_tz_is_utc(self) -> None:
        self.assertEqual(self._offset(""), "+0000")

    @unittest.skipIf(sys.platform.startswith("win"), "Windows 没有 tzset")
    def test_uninterpretable_tz_is_utc(self) -> None:
        self.assertEqual(self._offset("Not/AZone"), "+0000")

    @unittest.skipIf(sys.platform.startswith("win"), "Windows 没有 tzset")
    def test_valid_zone_is_not_utc(self) -> None:
        try:
            import zoneinfo
            zoneinfo.ZoneInfo("Asia/Shanghai")
        except Exception:  # pragma: no cover - 没有 tzdata 的机器
            self.skipTest("本机缺少 Asia/Shanghai")
        self.assertEqual(self._offset("Asia/Shanghai"), "+0800")


if __name__ == "__main__":
    unittest.main(verbosity=2)
