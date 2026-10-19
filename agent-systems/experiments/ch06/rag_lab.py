#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""rag_lab.py — 第 6 章的小型混合检索实验（纯标准库，无网络）。

它实现四件事：

  1. BM25（k1=1.2, b=0.75）对 30 条内置文档做词面召回；
  2. 哈希向量（signed hashing trick + L2 归一化）做余弦召回；
  3. RRF（Reciprocal Rank Fusion, k=60）融合两路排名；
  4. 关键词覆盖率重排 + span 级引用（doc_id + 版本 + 起止 offset + 原文哈希）。

注意：这里的「向量」是词袋 n-gram 的哈希投影，不是语义 embedding。
它只用来演示检索流水线的形状；跨语言/同义改写它救不了，正文 6.9 节
会拿一个真实失败查询说明这一点。

用法：
    python3 rag_lab.py --query "退款多久到账" --k 3 --hybrid --rerank
    python3 rag_lab.py --query "入职第一天要准备什么" --k 3 --hybrid --show-context
    python3 rag_lab.py --query "退款多久到账" --delete billing-refund-faq --k 3
    python3 rag_lab.py --eval --k 5 --hybrid --rerank

设计约束：
  - 文档、倒排、向量、墓碑都在内存里重建，便于观察「删除后索引是否还召回」；
  - 引用 offset 以 Python 字符串（Unicode 码点）为单位，切回原文必须逐字相等；
  - 拒答由「支持度」阈值决定，阈值可以在命令行覆盖，便于做校准实验。
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import sys
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from typing import Iterable

# --------------------------------------------------------------------------- #
# 语料：一个虚构的内部工程手册 + 产品文档。30 条，人工撰写。
# 重复主题是故意的：BM25 需要 IDF 有区分度，冲突/时效也需要近邻文档。
# --------------------------------------------------------------------------- #

DOCUMENTS_RAW: list[dict[str, object]] = [
    {
        "doc_id": "billing-refund-sla",
        "title": "退款到账时效",
        "text": "退款申请审核通过后，款项一般会在 3 个工作日内退回到原支付渠道。"
                "银行卡退款的到账时间可能延长到 5 个工作日。"
                "如果超过 7 个工作日仍未到账，请提交工单并附上订单号。",
        "source": "handbook/billing/refund-sla.md",
        "version": 4,
        "updated_at": "2026-08-14",
        "tags": ("billing", "refund"),
    },
    {
        "doc_id": "billing-refund-policy",
        "title": "退款政策",
        "text": "未发货订单可以全额退款；已发货订单需在签收后 7 天内申请，且商品保持完好。"
                "定制商品与虚拟商品不支持无理由退款。"
                "退款金额按实付金额计算，不含优惠券。",
        "source": "handbook/billing/refund-policy.md",
        "version": 7,
        "updated_at": "2026-07-02",
        "tags": ("billing", "refund"),
    },
    {
        "doc_id": "billing-changelog-2026-08",
        "title": "计费与退款变更通知（2026-08）",
        "text": "自 2026-08-01 起，退款审核改由风控系统自动处理。"
                "历史工单中的退款流程说明不再适用。"
                "本次变更不影响已提交的退款申请。",
        "source": "changelog/2026-08-billing.md",
        "version": 1,
        "updated_at": "2026-08-01",
        "tags": ("billing", "changelog"),
    },
    {
        "doc_id": "billing-invoice",
        "title": "发票开具",
        "text": "电子发票在订单完成后 24 小时内开出，可在控制台下载。"
                "增值税专用发票需要提供税号与开户行信息，审核周期为 2 个工作日。",
        "source": "handbook/billing/invoice.md",
        "version": 3,
        "updated_at": "2026-06-19",
        "tags": ("billing", "invoice"),
    },
    {
        "doc_id": "deploy-gray",
        "title": "灰度发布流程",
        "text": "灰度发布先放量 1%，观察 30 分钟错误率与延迟，再按 5%、25%、100% 逐步扩大。"
                "每一阶段都要检查核心接口的 P99 与错误率，异常时立即停止放量并执行回滚。",
        "source": "handbook/deploy/gray.md",
        "version": 6,
        "updated_at": "2026-09-03",
        "tags": ("deploy",),
    },
    {
        "doc_id": "deploy-rollback",
        "title": "发布回滚操作",
        "text": "回滚使用上一版本的镜像摘要，执行 deploy rollback --to <sha>，并在 5 分钟内确认流量恢复。"
                "数据库迁移不可自动回滚，必须提前准备反向迁移脚本。",
        "source": "handbook/deploy/rollback.md",
        "version": 5,
        "updated_at": "2026-08-22",
        "tags": ("deploy",),
    },
    {
        "doc_id": "deploy-canary-decision",
        "title": "金丝雀判定指标",
        "text": "金丝雀阶段重点看三类指标：HTTP 5xx 比例、P99 延迟、业务转化率。"
                "5xx 超过 0.5% 或 P99 超过基线 20% 时判定失败。",
        "source": "handbook/deploy/canary.md",
        "version": 2,
        "updated_at": "2026-05-11",
        "tags": ("deploy",),
    },
    {
        "doc_id": "deploy-freeze",
        "title": "发布冻结期",
        "text": "节假日前 48 小时与重大促销期间冻结非紧急发布。"
                "紧急修复需要值班经理与业务负责人双人审批，并在变更单中记录回滚方案。",
        "source": "handbook/deploy/freeze.md",
        "version": 2,
        "updated_at": "2026-04-27",
        "tags": ("deploy",),
    },
    {
        "doc_id": "oncall-sev",
        "title": "故障分级与响应",
        "text": "P0 故障要求 5 分钟内响应、30 分钟内恢复；P1 要求 15 分钟响应。"
                "值班同学先止损再定位，不允许在未恢复服务前做长时间根因分析。",
        "source": "handbook/oncall/severity.md",
        "version": 8,
        "updated_at": "2026-09-18",
        "tags": ("oncall",),
    },
    {
        "doc_id": "oncall-runbook-db",
        "title": "数据库连接池耗尽处置",
        "text": "连接池耗尽时先确认慢查询与连接泄漏，再临时调大 max_connections 并重启受影响实例。"
                "重启前必须摘除流量，避免请求堆积。",
        "source": "handbook/oncall/db-pool.md",
        "version": 3,
        "updated_at": "2026-03-08",
        "tags": ("oncall", "database"),
    },
    {
        "doc_id": "oncall-alert-noise",
        "title": "告警降噪",
        "text": "同一告警在 10 分钟内重复触发只保留一条，按服务与错误码聚合。"
                "阈值调整必须附带过去 7 天的数据，避免把真实故障静音。",
        "source": "handbook/oncall/alert-noise.md",
        "version": 4,
        "updated_at": "2026-07-30",
        "tags": ("oncall",),
    },
    {
        "doc_id": "oncall-postmortem",
        "title": "事故复盘模板",
        "text": "复盘包含时间线、影响面、根因、处置过程与改进项。"
                "改进项必须有负责人与截止日期，并在下一次值班例会上检查关闭情况。",
        "source": "handbook/oncall/postmortem.md",
        "version": 3,
        "updated_at": "2026-02-16",
        "tags": ("oncall",),
    },
    {
        "doc_id": "hr-onboarding",
        "title": "入职指引",
        "text": "新同事第一天领取门禁卡、笔记本与邮箱账号。"
                "导师负责开通代码仓库与文档权限，并在第一周安排环境搭建与团队介绍。",
        "source": "handbook/hr/onboarding.md",
        "version": 5,
        "updated_at": "2026-08-05",
        "tags": ("hr",),
    },
    {
        "doc_id": "hr-onboarding-checklist",
        "title": "入职第一周清单",
        "text": "第一周完成账号开通、安全培训、代码规范阅读与第一个小任务。"
                "权限申请由导师在工单系统提交，默认有效期 90 天。",
        "source": "handbook/hr/onboarding-checklist.md",
        "version": 2,
        "updated_at": "2026-06-12",
        "tags": ("hr",),
    },
    {
        "doc_id": "hr-access-review",
        "title": "权限季度复核",
        "text": "每季度复核一次仓库与生产环境权限，离职与转岗必须在 24 小时内回收。"
                "长期未使用的权限默认拒绝续期。",
        "source": "handbook/hr/access-review.md",
        "version": 3,
        "updated_at": "2026-05-23",
        "tags": ("hr", "security"),
    },
    {
        "doc_id": "data-retention",
        "title": "数据保留策略",
        "text": "对话日志默认保留 30 天，审计日志保留 180 天，计费记录保留 7 年。"
                "超过保留期的数据由定时任务归档或删除，并在元数据中记录删除时间。",
        "source": "handbook/data/retention.md",
        "version": 4,
        "updated_at": "2026-07-19",
        "tags": ("data", "privacy"),
    },
    {
        "doc_id": "data-deletion",
        "title": "用户数据删除请求",
        "text": "收到删除请求后，先冻结相关数据，再在 72 小时内删除主库、索引、缓存与摘要中的副本。"
                "备份中的副本按保留周期滚动清除，并在删除台账中登记。",
        "source": "handbook/data/deletion.md",
        "version": 6,
        "updated_at": "2026-09-09",
        "tags": ("data", "privacy"),
    },
    {
        "doc_id": "data-pii",
        "title": "敏感数据分级",
        "text": "手机号、身份证号、银行卡号属于 L3 数据，禁止写入普通日志与向量库。"
                "需要检索时先做脱敏或令牌化，并限制只有审计角色可以还原。",
        "source": "handbook/data/pii.md",
        "version": 5,
        "updated_at": "2026-08-28",
        "tags": ("data", "security"),
    },
    {
        "doc_id": "mem-design",
        "title": "记忆分层设计",
        "text": "工作记忆保存当前任务的目标与约束；情节记忆保存发生过的事件；"
                "语义记忆保存稳定事实与偏好；程序记忆保存可复用的操作步骤。",
        "source": "handbook/memory/layers.md",
        "version": 3,
        "updated_at": "2026-09-12",
        "tags": ("memory",),
    },
    {
        "doc_id": "mem-write",
        "title": "记忆写入规则",
        "text": "写入前先抽取实体、关系、偏好与约束，再做去重与冲突检测。"
                "与已有事实冲突时，保留来源可信度更高、时间更新的版本，并把旧版本标记为失效。",
        "source": "handbook/memory/write.md",
        "version": 2,
        "updated_at": "2026-09-12",
        "tags": ("memory",),
    },
    {
        "doc_id": "mem-decay",
        "title": "记忆衰减与清理",
        "text": "低置信度、长期未访问的记忆按半衰期衰减权重。"
                "超过 90 天未访问且置信度低于 0.3 的记忆进入待清理队列，由人工抽查后删除。",
        "source": "handbook/memory/decay.md",
        "version": 2,
        "updated_at": "2026-09-12",
        "tags": ("memory",),
    },
    {
        "doc_id": "rag-chunking",
        "title": "文档分块策略",
        "text": "长文档按标题层级切分，每块 300 到 500 字，相邻块重叠 50 字。"
                "表格与代码块单独成块，避免在句子中间截断。",
        "source": "handbook/rag/chunking.md",
        "version": 4,
        "updated_at": "2026-08-31",
        "tags": ("rag",),
    },
    {
        "doc_id": "rag-hybrid",
        "title": "混合检索配置",
        "text": "混合检索同时使用 BM25 与向量召回，用 RRF 融合两路排名。"
                "候选池取 50 条，重排后保留 5 条进入上下文。",
        "source": "handbook/rag/hybrid.md",
        "version": 3,
        "updated_at": "2026-09-02",
        "tags": ("rag",),
    },
    {
        "doc_id": "rag-citation",
        "title": "引用格式",
        "text": "回答中的每个事实都要带引用，引用包含文档 ID、段落起止位置与版本文档。"
                "引用必须能回到原文，不允许只给文档标题。",
        "source": "handbook/rag/citation.md",
        "version": 2,
        "updated_at": "2026-09-06",
        "tags": ("rag",),
    },
    {
        "doc_id": "rag-eval",
        "title": "检索评估指标",
        "text": "离线评估使用 recall@k、MRR 与 nDCG@k，问答质量使用 faithfulness 与引用正确率。"
                "评估集要覆盖同义改写、否定与多跳问题。",
        "source": "handbook/rag/eval.md",
        "version": 3,
        "updated_at": "2026-09-15",
        "tags": ("rag", "eval"),
    },
    {
        "doc_id": "sec-secrets",
        "title": "密钥管理",
        "text": "生产密钥存放在密钥管理服务中，禁止写入代码仓库与配置文件。"
                "应用通过短期凭证访问，凭证有效期不超过 1 小时。",
        "source": "handbook/security/secrets.md",
        "version": 6,
        "updated_at": "2026-07-07",
        "tags": ("security",),
    },
    {
        "doc_id": "sec-injection",
        "title": "间接提示注入",
        "text": "检索到的网页可能包含伪装成指令的文本。"
                "系统必须把检索内容标记为不可信数据，禁止其中的指令触发工具调用。",
        "source": "handbook/security/injection.md",
        "version": 4,
        "updated_at": "2026-09-20",
        "tags": ("security",),
    },
    {
        "doc_id": "support-refund-script",
        "title": "客服退款话术",
        "text": "向用户解释退款时，先确认订单号与支付方式，再说明预计到账时间。"
                "不要承诺具体到账日期，也不要引导用户重复提交退款申请。",
        "source": "handbook/support/refund-script.md",
        "version": 2,
        "updated_at": "2026-08-18",
        "tags": ("support", "refund"),
    },
    {
        "doc_id": "billing-refund-faq",
        "title": "退款常见问题",
        "text": "退款多久到账取决于支付渠道：余额即时到账，银行卡 3 到 5 个工作日，"
                "信用卡 5 到 7 个工作日。审核未通过时会在工单中说明原因。",
        "source": "faq/billing/refund.md",
        "version": 9,
        "updated_at": "2026-09-21",
        "tags": ("billing", "refund", "faq"),
    },
    {
        "doc_id": "deploy-rollback-db",
        "title": "数据库迁移回滚",
        "text": "数据库迁移的回滚脚本必须与正向迁移一起评审。"
                "回滚前先做全量备份，并在预发环境验证反向迁移。",
        "source": "handbook/deploy/rollback-db.md",
        "version": 1,
        "updated_at": "2026-09-05",
        "tags": ("deploy", "database"),
    },
]

# 离线评估集：query -> 相关文档（二值相关性）。故意包含一个「词面不匹配」的查询，
# 它不会被默认评估集使用，留在正文的失败案例里。
EVAL_QUERIES: list[tuple[str, set[str]]] = [
    ("退款多久到账", {"billing-refund-faq", "billing-refund-sla"}),
    # 下面这条是重排的收益点：首轮 top-1 是「客服话术」，它不含具体时效。
    ("退款申请多久到账", {"billing-refund-faq", "billing-refund-sla"}),
    ("灰度发布怎么回滚", {"deploy-gray", "deploy-rollback"}),
    ("P0 故障多久响应", {"oncall-sev"}),
    ("删除用户数据要清理哪些副本", {"data-deletion"}),
    ("入职第一天要准备什么", {"hr-onboarding", "hr-onboarding-checklist"}),
    ("告警太多怎么降噪", {"oncall-alert-noise"}),
    ("长文档怎么切块", {"rag-chunking"}),
    ("数据库迁移能自动回滚吗", {"deploy-rollback", "deploy-rollback-db"}),
    ("引用能不能只写文档标题", {"rag-citation"}),
    ("密钥可以写进配置文件吗", {"sec-secrets"}),
    # 下面两条故意保留为失败样本：一条零词面重叠，一条错抓「事故」。
    ("线上事故怎么定级", {"oncall-sev"}),
    ("新人报到要办什么", {"hr-onboarding"}),
]

CJK_RE = re.compile(r"[\u4e00-\u9fff]+")
WORD_RE = re.compile(r"[a-z0-9]+(?:[._-][a-z0-9]+)*")
SENT_RE = re.compile(r"[^。！？!?\n]+[。！？!?]?")
PUNCT_RE = re.compile(r"[\s，。！？、；：,.!?;:（）()《》“”\"'·]+")
STOP_UNIGRAMS = set("的了是在和与及或对把被这那有个我你他她它")

DENSE_DIM = 512
RRF_K = 60
BM25_K1 = 1.2
BM25_B = 0.75
DEFAULT_MIN_SUPPORT = 0.34


# --------------------------------------------------------------------------- #
# 分词与基本数据结构
# --------------------------------------------------------------------------- #


def tokenize(text: str) -> list[str]:
    """中文按字符二元组、ASCII 按词切分。

    二元组是中文检索里最便宜、最稳的折中：不需要词典，能抓住大部分词，
    代价是「词边界」信息丢失（例如「研究生命」与「研究生/命」不可分）。
    """
    text = text.lower()
    out: list[str] = []
    for match in CJK_RE.finditer(text):
        run = match.group(0)
        if len(run) == 1:
            if run not in STOP_UNIGRAMS:
                out.append(run)
            continue
        out.extend(run[i:i + 2] for i in range(len(run) - 1))
    for match in WORD_RE.finditer(text):
        out.append(match.group(0))
    return out


def normalize_for_phrase(text: str) -> str:
    return PUNCT_RE.sub("", text.lower())


@dataclass
class Document:
    doc_id: str
    title: str
    text: str
    source: str
    version: int
    updated_at: str
    tags: tuple[str, ...] = ()
    status: str = "active"
    deleted_at: str | None = None

    @classmethod
    def from_raw(cls, raw: dict[str, object]) -> "Document":
        return cls(
            doc_id=str(raw["doc_id"]),
            title=str(raw["title"]),
            text=str(raw["text"]),
            source=str(raw["source"]),
            version=int(raw["version"]),
            updated_at=str(raw["updated_at"]),
            tags=tuple(raw.get("tags", ())),  # type: ignore[arg-type]
        )

    def indexed_text(self) -> str:
        # 标题重复两次，给标题一个温和的权重；不做字段级 BM25，保持实现可读。
        return f"{self.title} {self.title} {self.text}"

    def to_dict(self) -> dict[str, object]:
        return {
            "doc_id": self.doc_id,
            "title": self.title,
            "source": self.source,
            "version": self.version,
            "updated_at": self.updated_at,
            "tags": list(self.tags),
            "status": self.status,
            "deleted_at": self.deleted_at,
        }


def sentence_spans(text: str) -> list[tuple[int, int]]:
    """按中文句末标点切句，保留标点，返回原文字符 offset。"""
    spans: list[tuple[int, int]] = []
    for match in SENT_RE.finditer(text):
        start, end = match.span()
        while start < end and text[start].isspace():
            start += 1
        if end > start:
            spans.append((start, end))
    return spans


# --------------------------------------------------------------------------- #
# BM25
# --------------------------------------------------------------------------- #


class BM25Index:
    def __init__(self, docs: Iterable[Document], k1: float = BM25_K1, b: float = BM25_B):
        self.docs = list(docs)
        self.k1 = k1
        self.b = b
        self.tfs: dict[str, Counter[str]] = {}
        self.lengths: dict[str, int] = {}
        for doc in self.docs:
            tokens = tokenize(doc.indexed_text())
            self.tfs[doc.doc_id] = Counter(tokens)
            self.lengths[doc.doc_id] = len(tokens)
        self.n_docs = len(self.docs)
        self.avgdl = (
            sum(self.lengths.values()) / self.n_docs if self.n_docs else 0.0
        )
        self.df: Counter[str] = Counter()
        for tf in self.tfs.values():
            self.df.update(tf.keys())

    def idf(self, term: str) -> float:
        df = self.df.get(term, 0)
        # Lucene/ Robertson 的平滑形式，保证 df=0 时也有有限值。
        return math.log(1.0 + (self.n_docs - df + 0.5) / (df + 0.5))

    def search(self, query: str, limit: int | None = None) -> list[tuple[str, float]]:
        q_counts = Counter(tokenize(query))
        scores: dict[str, float] = {}
        for doc in self.docs:
            tf = self.tfs[doc.doc_id]
            dl = self.lengths[doc.doc_id]
            score = 0.0
            for term, q_count in q_counts.items():
                freq = tf.get(term, 0)
                if freq == 0:
                    continue
                denom = freq + self.k1 * (1.0 - self.b + self.b * dl / self.avgdl)
                score += q_count * self.idf(term) * freq * (self.k1 + 1.0) / denom
            if score > 0.0:
                scores[doc.doc_id] = score
        ranked = sorted(scores.items(), key=lambda item: (-item[1], item[0]))
        return ranked[:limit] if limit is not None else ranked


# --------------------------------------------------------------------------- #
# 哈希向量（不是语义 embedding）
# --------------------------------------------------------------------------- #


def embed(text: str, dim: int = DENSE_DIM) -> list[float]:
    vector = [0.0] * dim
    for token in tokenize(text):
        digest = hashlib.blake2b(token.encode("utf-8"), digest_size=8).digest()
        h = int.from_bytes(digest, "big")
        index = h % dim
        sign = 1.0 if (h >> 63) & 1 else -1.0
        vector[index] += sign
    norm = math.sqrt(sum(value * value for value in vector))
    if norm == 0.0:
        return vector
    return [value / norm for value in vector]


def cosine(a: list[float], b: list[float]) -> float:
    return sum(x * y for x, y in zip(a, b))


class DenseIndex:
    def __init__(self, docs: Iterable[Document]):
        self.docs = list(docs)
        self.vectors = {doc.doc_id: embed(doc.indexed_text()) for doc in self.docs}

    def search(self, query: str, limit: int | None = None) -> list[tuple[str, float]]:
        qv = embed(query)
        scores: dict[str, float] = {}
        for doc in self.docs:
            score = cosine(qv, self.vectors[doc.doc_id])
            if score > 1e-9:
                scores[doc.doc_id] = score
        ranked = sorted(scores.items(), key=lambda item: (-item[1], item[0]))
        return ranked[:limit] if limit is not None else ranked


# --------------------------------------------------------------------------- #
# 融合与重排
# --------------------------------------------------------------------------- #


def rrf_fuse(
    rankings: dict[str, list[tuple[str, float]]], k: int = RRF_K
) -> list[tuple[str, float]]:
    """Reciprocal Rank Fusion：只看名次，不看原始分数。"""
    fused: defaultdict[str, float] = defaultdict(float)
    for ranked in rankings.values():
        for rank, (doc_id, _score) in enumerate(ranked, start=1):
            fused[doc_id] += 1.0 / (k + rank)
    return sorted(fused.items(), key=lambda item: (-item[1], item[0]))


def _coverage(query_tokens: set[str], text_tokens: set[str]) -> float:
    if not query_tokens:
        return 0.0
    return len(query_tokens & text_tokens) / len(query_tokens)


@dataclass
class Support:
    window_start: int
    window_end: int
    quote: str
    body_coverage: float
    title_coverage: float
    phrase_match: bool
    support: float
    rerank_score: float


# --------------------------------------------------------------------------- #
# 主实验对象
# --------------------------------------------------------------------------- #


class RagLab:
    def __init__(self, raw_docs: Iterable[dict[str, object]]):
        self.docs: dict[str, Document] = {}
        for raw in raw_docs:
            doc = Document.from_raw(raw)
            self.docs[doc.doc_id] = doc
        self.tombstones: list[dict[str, object]] = []
        self.rebuild()

    # -- 写入 / 删除 ------------------------------------------------------- #

    def active_docs(self) -> list[Document]:
        return [doc for doc in self.docs.values() if doc.status == "active"]

    def rebuild(self) -> None:
        active = self.active_docs()
        self.bm25 = BM25Index(active)
        self.dense = DenseIndex(active)
        self.df: Counter[str] = Counter()
        for doc in active:
            self.df.update(set(tokenize(doc.indexed_text())))

    def delete(self, doc_id: str, reason: str = "user_request") -> dict[str, object]:
        doc = self.docs.get(doc_id)
        if doc is None:
            raise KeyError(f"unknown doc_id: {doc_id}")
        if doc.status == "deleted":
            for stone in self.tombstones:
                if stone["doc_id"] == doc_id:
                    return stone
            raise RuntimeError("deleted document without tombstone")
        doc.status = "deleted"
        doc.deleted_at = "2026-10-19T09:00:00+08:00"
        stone = {
            "doc_id": doc_id,
            "version": doc.version,
            "deleted_at": doc.deleted_at,
            "reason": reason,
            "request_id": f"del-{doc_id}-{len(self.tombstones) + 1}",
        }
        self.tombstones.append(stone)
        self.rebuild()
        return stone

    # -- 支持度与引用 ------------------------------------------------------- #

    def analyze_support(self, query: str, doc: Document, window: int = 2) -> Support:
        query_tokens = set(tokenize(query))
        # 只统计「语料里真的出现过」的查询词：全是不在词表里的词时，支持度为 0。
        content_tokens = {token for token in query_tokens if self.df.get(token, 0) > 0}
        spans = sentence_spans(doc.text)
        best: tuple[float, int, int, str] | None = None
        for i in range(len(spans)):
            for j in range(i, min(i + window, len(spans))):
                start, end = spans[i][0], spans[j][1]
                if end - start > 260:
                    continue
                quote = doc.text[start:end]
                coverage = _coverage(content_tokens, set(tokenize(quote)))
                if best is None or coverage > best[0]:
                    best = (coverage, start, end, quote)
        if best is None:
            start = end = 0
            quote = ""
            body_coverage = 0.0
        else:
            body_coverage, start, end, quote = best

        title_coverage = _coverage(content_tokens, set(tokenize(doc.title)))
        norm_query = normalize_for_phrase(query)
        phrase_match = len(norm_query) >= 4 and norm_query in normalize_for_phrase(
            f"{doc.title} {doc.text}"
        )
        support = max(body_coverage, 0.85 * title_coverage, 0.85 if phrase_match else 0.0)
        rerank_score = (
            0.40 * body_coverage
            + 0.45 * title_coverage
            + 0.15 * (1.0 if phrase_match else 0.0)
        )
        return Support(
            window_start=start,
            window_end=end,
            quote=quote,
            body_coverage=round(body_coverage, 4),
            title_coverage=round(title_coverage, 4),
            phrase_match=phrase_match,
            support=round(support, 4),
            rerank_score=round(rerank_score, 4),
        )

    # -- 查询 --------------------------------------------------------------- #

    def query(
        self,
        query: str,
        k: int = 3,
        channel: str = "bm25",
        rerank: bool = False,
        min_support: float = DEFAULT_MIN_SUPPORT,
        show_context: bool = False,
        pool: int | None = None,
    ) -> dict[str, object]:
        if channel not in {"bm25", "dense", "hybrid"}:
            raise ValueError(f"unknown channel: {channel}")
        bm25_ranked = self.bm25.search(query)
        dense_ranked = self.dense.search(query)
        channels: dict[str, list[tuple[str, float]]] = {}
        if channel in {"bm25", "hybrid"}:
            channels["bm25"] = bm25_ranked
        if channel in {"dense", "hybrid"}:
            channels["dense"] = dense_ranked

        if channel == "hybrid":
            ranked = rrf_fuse({"bm25": bm25_ranked, "dense": dense_ranked})
            score_kind = "rrf"
        elif channel == "bm25":
            ranked = bm25_ranked
            score_kind = "bm25"
        else:
            ranked = dense_ranked
            score_kind = "cosine"
        bm25_scores = dict(bm25_ranked)
        dense_scores = dict(dense_ranked)

        candidate_limit = pool if pool is not None else (max(10, k * 4) if rerank else k)
        candidates = ranked[:candidate_limit]

        rows: list[dict[str, object]] = []
        for doc_id, first_score in candidates:
            doc = self.docs[doc_id]
            support = self.analyze_support(query, doc)
            rows.append(
                {
                    "doc": doc,
                    "first_score": first_score,
                    "support": support,
                }
            )

        if rerank:
            rows.sort(
                key=lambda row: (
                    -row["support"].rerank_score,  # type: ignore[union-attr]
                    -row["first_score"],  # type: ignore[operator]
                    row["doc"].doc_id,  # type: ignore[union-attr]
                )
            )

        best_support = max((row["support"].support for row in rows), default=0.0)
        refused = (not rows) or best_support < min_support
        if refused:
            return {
                "query": query,
                "k": k,
                "mode": channel + ("+rerank" if rerank else ""),
                "score_kind": score_kind,
                "corpus": self.corpus_stats(),
                "channel_sizes": {
                    "bm25": len(bm25_ranked) if channel in {"bm25", "hybrid"} else 0,
                    "dense": len(dense_ranked) if channel in {"dense", "hybrid"} else 0,
                },
                "refused": True,
                "reason": "insufficient_evidence",
                "best_support": best_support,
                "min_support": min_support,
                "answer": None,
                "results": [],
                "tombstones": list(self.tombstones),
            }

        results: list[dict[str, object]] = []
        for rank, row in enumerate(rows[:k], start=1):
            doc = row["doc"]
            support = row["support"]
            citation = {
                "doc_id": doc.doc_id,
                "title": doc.title,
                "version": doc.version,
                "start": support.window_start,
                "end": support.window_end,
                "quote": support.quote,
                "content_hash": hashlib.sha256(support.quote.encode("utf-8")).hexdigest()[:16],
            }
            if show_context:
                citation["context"] = {
                    "before": doc.text[max(0, support.window_start - 40):support.window_start],
                    "after": doc.text[support.window_end:support.window_end + 40],
                }
            results.append(
                {
                    "rank": rank,
                    "doc_id": doc.doc_id,
                    "title": doc.title,
                    "score": round(float(row["first_score"]), 4),
                    "bm25_score": round(bm25_scores.get(doc.doc_id, 0.0), 4),
                    "dense_score": round(dense_scores.get(doc.doc_id, 0.0), 4),
                    "ref": doc.source,
                    "support": support.support,
                    "body_coverage": support.body_coverage,
                    "title_coverage": support.title_coverage,
                    "rerank_score": support.rerank_score,
                    "citation": citation,
                }
            )

        top = results[0]
        answer = f"{top['citation']['quote']}[1]"  # type: ignore[index]
        return {
            "query": query,
            "k": k,
            "mode": channel + ("+rerank" if rerank else ""),
            "score_kind": score_kind,
            "corpus": self.corpus_stats(),
            "channel_sizes": {
                "bm25": len(bm25_ranked) if channel in {"bm25", "hybrid"} else 0,
                "dense": len(dense_ranked) if channel in {"dense", "hybrid"} else 0,
            },
            "refused": False,
            "reason": None,
            "best_support": best_support,
            "min_support": min_support,
            "answer": answer,
            "results": results,
            "tombstones": list(self.tombstones),
        }

    def corpus_stats(self) -> dict[str, object]:
        active = self.active_docs()
        return {
            "documents": len(self.docs),
            "active": len(active),
            "tombstoned": len(self.tombstones),
            "terms": len(self.df),
            "avg_tokens": round(self.bm25.avgdl, 1) if active else 0.0,
        }


# --------------------------------------------------------------------------- #
# 评估
# --------------------------------------------------------------------------- #


def recall_at_k(ranked: list[str], relevant: set[str], k: int) -> float:
    if not relevant:
        return 0.0
    return len(set(ranked[:k]) & relevant) / len(relevant)


def reciprocal_rank(ranked: list[str], relevant: set[str]) -> float:
    for rank, doc_id in enumerate(ranked, start=1):
        if doc_id in relevant:
            return 1.0 / rank
    return 0.0


def ndcg_at_k(ranked: list[str], relevant: set[str], k: int) -> float:
    gains = [1.0 if doc_id in relevant else 0.0 for doc_id in ranked[:k]]
    dcg = sum(gain / math.log2(index + 2) for index, gain in enumerate(gains))
    ideal = sorted((1.0 for _ in relevant), reverse=True)[:k]
    idcg = sum(gain / math.log2(index + 2) for index, gain in enumerate(ideal))
    return dcg / idcg if idcg > 0 else 0.0


def evaluate(
    lab: RagLab, k: int, channel: str, rerank: bool, pool: int | None = None
) -> dict[str, object]:
    per_query: list[dict[str, object]] = []
    for query, relevant in EVAL_QUERIES:
        result = lab.query(query, k=k, channel=channel, rerank=rerank, pool=pool)
        ranked = [row["doc_id"] for row in result["results"]]  # type: ignore[index]
        citation = result["results"][0]["citation"]["doc_id"] if result["results"] else None  # type: ignore[index]
        per_query.append(
            {
                "query": query,
                "relevant": sorted(relevant),
                "returned": ranked,
                "refused": result["refused"],
                "recall": round(recall_at_k(ranked, relevant, k), 4),
                "rr": round(reciprocal_rank(ranked, relevant), 4),
                "ndcg": round(ndcg_at_k(ranked, relevant, k), 4),
                "citation_doc": citation,
                "citation_ok": citation in relevant if citation else False,
            }
        )
    count = len(per_query) or 1
    macro = {
        "recall@k": round(sum(float(row["recall"]) for row in per_query) / count, 4),
        "mrr": round(sum(float(row["rr"]) for row in per_query) / count, 4),
        "ndcg@k": round(sum(float(row["ndcg"]) for row in per_query) / count, 4),
        "citation_relevance": round(
            sum(1.0 for row in per_query if row["citation_ok"]) / count, 4
        ),
        "refusal_rate": round(
            sum(1.0 for row in per_query if row["refused"]) / count, 4
        ),
    }
    return {"k": k, "mode": channel + ("+rerank" if rerank else ""), "macro": macro, "queries": per_query}


# --------------------------------------------------------------------------- #
# CLI
# --------------------------------------------------------------------------- #


def build_lab() -> RagLab:
    return RagLab(DOCUMENTS_RAW)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="第 6 章小型混合检索实验（BM25 + 哈希向量 + RRF + span 引用）"
    )
    parser.add_argument("--query", help="查询文本")
    parser.add_argument("--k", type=int, default=3, help="返回条数（默认 3）")
    parser.add_argument(
        "--hybrid", action="store_true", help="BM25 + 哈希向量，RRF 融合"
    )
    parser.add_argument(
        "--channel", choices=["bm25", "dense", "hybrid"], default=None,
        help="显式选择单路或混合检索；--hybrid 等价于 --channel hybrid",
    )
    parser.add_argument("--rerank", action="store_true", help="对候选集做关键词覆盖率重排")
    parser.add_argument("--show-context", action="store_true", help="引用前后各打印 40 字上下文")
    parser.add_argument("--delete", action="append", default=[], metavar="DOC_ID",
                        help="查询前删除文档（可重复），用于观察墓碑与索引重建")
    parser.add_argument("--min-support", type=float, default=DEFAULT_MIN_SUPPORT,
                        help=f"拒答阈值（默认 {DEFAULT_MIN_SUPPORT}）")
    parser.add_argument("--pool", type=int, default=None, help="重排候选池大小")
    parser.add_argument("--eval", action="store_true", help="跑离线评估集，打印 recall/MRR/nDCG")
    parser.add_argument("--list-docs", action="store_true", help="列出语料后退出")
    args = parser.parse_args(argv)
    if args.channel is None:
        args.channel = "hybrid" if args.hybrid else "bm25"
    if not args.eval and not args.query and not args.list_docs:
        parser.error("需要 --query、--eval 或 --list-docs")
    if args.k < 1:
        parser.error("--k 必须 >= 1")
    return args


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    lab = build_lab()
    for doc_id in args.delete:
        try:
            lab.delete(doc_id)
        except KeyError as exc:
            print(json.dumps({"error": str(exc)}, ensure_ascii=False))
            return 2

    if args.list_docs:
        payload = {
            "corpus": lab.corpus_stats(),
            "documents": [doc.to_dict() for doc in lab.docs.values()],
            "tombstones": lab.tombstones,
        }
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0

    if args.eval:
        payload = evaluate(lab, args.k, args.channel, args.rerank, pool=args.pool)
        payload["corpus"] = lab.corpus_stats()
        payload["tombstones"] = lab.tombstones
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0

    payload = lab.query(
        args.query,
        k=args.k,
        channel=args.channel,
        rerank=args.rerank,
        min_support=args.min_support,
        show_context=args.show_context,
        pool=args.pool,
    )
    payload["tombstones"] = lab.tombstones
    print(json.dumps(payload, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
