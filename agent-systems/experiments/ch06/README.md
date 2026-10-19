# 第 6 章实验：小型混合检索 + 重排 + 引用

纯 Python 标准库，无网络、无第三方依赖。正文里的 `jq` 命令需要系统安装 `jq`；
实验本身不依赖它，JSON 也可以直接 `python3 -m json.tool` 查看。语料是 30 条人工撰写的手册条目
（退款、发布、值班、数据保留、记忆、RAG、安全），故意包含近邻主题与一条
容易被误召回的变更通知，用来观察 IDF、去重与时效问题。

```bash
cd agent-systems

# 1. BM25 基线
python3 experiments/ch06/rag_lab.py --query "退款多久到账" --k 3

# 2. BM25 + 哈希向量，RRF 融合
python3 experiments/ch06/rag_lab.py --query "退款申请多久到账" --k 3 --hybrid

# 3. 再加关键词覆盖率重排
python3 experiments/ch06/rag_lab.py --query "退款申请多久到账" --k 3 --hybrid --rerank

# 4. 引用前后上下文（span offset 可切回原文）
python3 experiments/ch06/rag_lab.py --query "数据库迁移能自动回滚吗" --k 2 --hybrid --rerank --show-context

# 5. 删除一条文档：墓碑 + 索引重建，之后不再召回
python3 experiments/ch06/rag_lab.py --query "退款多久到账" --delete billing-refund-faq --k 3 --hybrid

# 6. 拒答：查询词全部不在词表里
python3 experiments/ch06/rag_lab.py --query "新人报到要办什么" --k 3 --hybrid

# 7. 离线评估：recall@k / MRR / nDCG / 引用命中率（代理）/ 拒答率
python3 experiments/ch06/rag_lab.py --eval --k 5 --hybrid --rerank

# 8. 单元测试
python3 -m unittest discover -s experiments/ch06 -v
```

## 实现

| 组件 | 做法 | 对应正文 |
|:--|:--|:--|
| 分词 | 中文连续汉字切字符二元组；ASCII 按词 | 6.3 |
| BM25 | `k1=1.2`、`b=0.75`，IDF 用 `ln(1 + (N-df+0.5)/(df+0.5))` | 6.3 |
| 向量 | 512 维 signed hashing trick + L2 归一化，余弦相似度 | 6.3 |
| 混合 | RRF，`1/(60+rank)` 逐路累加，只看名次 | 6.3 |
| 重排 | 正文/标题覆盖率 + 连续短语命中，权重 `0.40/0.45/0.15` | 6.4 |
| 引用 | 句窗内选覆盖率最高的 span，返回 `doc_id/version/start/end/quote/content_hash` | 6.5 |
| 删除 | 文档标记 `deleted`，写墓碑，重建 BM25/向量/df | 6.6 |
| 拒答 | 支持度 = max(正文覆盖, 0.85×标题覆盖, 短语命中)；低于阈值即拒答 | 6.5 |

## 这个实验故意保留的三个缺陷

1. **哈希向量不是语义 embedding。** 它只是词袋 n-gram 的哈希投影，同义改写
   （「报到」vs「入职」）一条都召不回。正文用它说明「混合检索的两路必须有
   独立信息」，而不是证明向量检索万能。
2. **RRF 可能稀释强词面信号。** 在「退款申请多久到账」上，dense 的第一名是
   客服话术，BM25 的第一名是 FAQ；RRF 把客服话术顶到第一。30 条语料上
   `--hybrid` 的 MRR 反而低于纯 BM25，加 `--rerank` 才拉回。
3. **重排不能理解意图。** 「线上事故怎么定级」只命中标题里的「事故」，
   正文覆盖率为 0，系统仍会给出「事故复盘模板」并附上一句不回答问题的引用。
   这正是正文 6.5 节「引用与答案一致性检查」要抓的样本。

## 评估集

13 条查询，其中 11 条可被词面系统命中，2 条是保留的失败样本：

- `线上事故怎么定级` → 应为 `oncall-sev`，实际召回 `oncall-postmortem`（错抓「事故」）；
- `新人报到要办什么` → 应为 `hr-onboarding`，实际拒答（零词面重叠）。

因此 `--eval --k 5 --hybrid --rerank` 的 recall@5 是 `11/13 = 0.8462`，不是 1.0。
这个数字比「全绿」更有用：它把召回层的语义缺口钉在了评估集里。

删除时间固定为 `2026-10-19T09:00:00+08:00`，是为了让墓碑与输出可复现；
生产实现应使用真实时钟，并保证同一删除请求的幂等性。
