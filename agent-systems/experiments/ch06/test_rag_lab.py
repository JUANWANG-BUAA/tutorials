#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""第 6 章实验的单元测试（纯标准库）。

运行：
    python3 -m unittest discover -s experiments/ch06 -v
"""

from __future__ import annotations

import hashlib
import pathlib
import sys
import unittest

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

import rag_lab  # noqa: E402


class RagLabTest(unittest.TestCase):
    def setUp(self) -> None:
        self.lab = rag_lab.build_lab()

    def test_bm25_ranks_exact_topic_first(self) -> None:
        result = self.lab.query("P0 故障多久响应", k=3, channel="bm25")
        self.assertFalse(result["refused"])
        ids = [row["doc_id"] for row in result["results"]]
        self.assertEqual(ids[0], "oncall-sev")
        scores = [row["score"] for row in result["results"]]
        self.assertEqual(scores, sorted(scores, reverse=True))
        self.assertGreater(scores[0], 0.0)
        self.assertEqual(result["score_kind"], "bm25")

    def test_hybrid_rrf_uses_rank_not_raw_score(self) -> None:
        query = "退款申请多久到账"
        bm25 = [doc_id for doc_id, _ in self.lab.bm25.search(query)]
        dense = [doc_id for doc_id, _ in self.lab.dense.search(query)]
        result = self.lab.query(query, k=5, channel="hybrid")
        rows = result["results"]

        # 每个融合分数必须能由两路名次精确重算：RRF 只看 rank。
        for row in rows:
            expected = 0.0
            if row["doc_id"] in bm25:
                expected += 1.0 / (rag_lab.RRF_K + bm25.index(row["doc_id"]) + 1)
            if row["doc_id"] in dense:
                expected += 1.0 / (rag_lab.RRF_K + dense.index(row["doc_id"]) + 1)
            self.assertAlmostEqual(row["score"], expected, places=4)

        # 这条查询上，dense 的第一名（客服话术）压过 BM25 的第一名（FAQ），
        # 说明融合确实改变了顺序，而不是把 BM25 原样抄一遍。
        self.assertEqual(dense[0], "support-refund-script")
        self.assertEqual(bm25[0], "billing-refund-faq")
        self.assertEqual(rows[0]["doc_id"], "support-refund-script")
        self.assertNotEqual([row["doc_id"] for row in rows], bm25[:5])

    def test_rerank_changes_order_but_not_recall(self) -> None:
        query = "退款申请多久到账"
        plain = self.lab.query(query, k=3, channel="hybrid")
        reranked = self.lab.query(query, k=3, channel="hybrid", rerank=True)
        self.assertEqual(plain["results"][0]["doc_id"], "support-refund-script")
        self.assertEqual(reranked["results"][0]["doc_id"], "billing-refund-sla")
        self.assertTrue(reranked["results"][0]["citation"]["quote"].startswith("退款申请审核通过后"))
        relevant = {"billing-refund-faq", "billing-refund-sla"}
        self.assertEqual(
            {row["doc_id"] for row in plain["results"][:3]} & relevant,
            {row["doc_id"] for row in reranked["results"][:3]} & relevant,
        )

    def test_citation_offsets_slice_back_to_source(self) -> None:
        queries = [
            "退款多久到账",
            "删除用户数据要清理哪些副本",
            "数据库迁移能自动回滚吗",
            "引用能不能只写文档标题",
        ]
        for query in queries:
            result = self.lab.query(query, k=3, channel="hybrid", rerank=True)
            self.assertFalse(result["refused"], query)
            for row in result["results"]:
                citation = row["citation"]
                doc = self.lab.docs[row["doc_id"]]
                self.assertEqual(
                    doc.text[citation["start"]:citation["end"]],
                    citation["quote"],
                    f"{query} / {row['doc_id']} 的 offset 切不回原文",
                )
                self.assertEqual(citation["version"], doc.version)
                self.assertTrue(citation["quote"].strip())
                self.assertEqual(
                    citation["content_hash"],
                    hashlib.sha256(citation["quote"].encode("utf-8")).hexdigest()[:16],
                )

    def test_deleted_document_is_not_recalled(self) -> None:
        query = "退款多久到账"
        before = self.lab.query(query, k=3, channel="hybrid")
        self.assertIn("billing-refund-faq", [row["doc_id"] for row in before["results"]])

        stone = self.lab.delete("billing-refund-faq", reason="user_request")
        self.assertEqual(stone["doc_id"], "billing-refund-faq")
        self.assertEqual(stone["reason"], "user_request")

        after = self.lab.query(query, k=3, channel="hybrid")
        ids = [row["doc_id"] for row in after["results"]]
        self.assertNotIn("billing-refund-faq", ids)
        self.assertEqual(after["corpus"]["active"], 29)
        self.assertEqual(after["corpus"]["tombstoned"], 1)
        self.assertEqual(after["tombstones"][0]["request_id"], stone["request_id"])
        for row in after["results"]:
            doc = self.lab.docs[row["doc_id"]]
            citation = row["citation"]
            self.assertEqual(doc.text[citation["start"]:citation["end"]], citation["quote"])

        # 二次删除是幂等的：返回同一条墓碑，不重复计数。
        again = self.lab.delete("billing-refund-faq")
        self.assertEqual(again["request_id"], stone["request_id"])
        self.assertEqual(len(self.lab.tombstones), 1)

    def test_refusal_on_out_of_vocabulary_query(self) -> None:
        result = self.lab.query("新人报到要办什么", k=3, channel="hybrid", rerank=True)
        self.assertTrue(result["refused"])
        self.assertEqual(result["reason"], "insufficient_evidence")
        self.assertEqual(result["results"], [])
        self.assertIsNone(result["answer"])
        self.assertLess(result["best_support"], result["min_support"])

    def test_threshold_is_configurable_and_calibration_is_visible(self) -> None:
        query = "线上事故怎么定级"
        default = self.lab.query(query, k=3, channel="hybrid", rerank=True)
        self.assertFalse(default["refused"])
        # 这条查询是已知的坏样本：标题命中「事故」，正文没有回答「定级」。
        self.assertEqual(default["results"][0]["doc_id"], "oncall-postmortem")
        self.assertEqual(default["results"][0]["body_coverage"], 0.0)
        strict = self.lab.query(query, k=3, channel="hybrid", rerank=True, min_support=0.9)
        self.assertTrue(strict["refused"])

    def test_eval_metrics_include_known_failures(self) -> None:
        payload = rag_lab.evaluate(self.lab, k=5, channel="hybrid", rerank=True)
        macro = payload["macro"]
        self.assertAlmostEqual(macro["recall@k"], 11 / 13, places=4)
        self.assertAlmostEqual(macro["mrr"], 11 / 13, places=4)
        self.assertGreater(macro["refusal_rate"], 0.0)
        self.assertLess(macro["recall@k"], 1.0)
        self.assertLess(macro["ndcg@k"], 1.0)

    def test_recall_mrr_ndcg_definitions(self) -> None:
        ranked = ["a", "b", "c"]
        relevant = {"b", "d"}
        self.assertEqual(rag_lab.recall_at_k(ranked, relevant, 3), 0.5)
        self.assertEqual(rag_lab.reciprocal_rank(ranked, relevant), 0.5)
        self.assertAlmostEqual(rag_lab.ndcg_at_k(ranked, {"b"}, 3), 1 / 1.5849625007211563)


if __name__ == "__main__":
    unittest.main()
