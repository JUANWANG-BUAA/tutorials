# A.3 论文、规范与公开复盘索引

> 只列本书实际引用或建议延伸阅读的材料。链接以官方/原始来源优先；产品文档会变，引用时注明版本或访问时间。

## 1 共识与复制

| 材料 | 为什么读 | 链接 |
|:--|:--|:--|
| L. Lamport, *The Part-Time Parliament* (1998) | Paxos 的原始论文；理解 prepare/accept 的安全性 | <https://lamport.azurewebsites.net/pubs/lamport-paxos.pdf> |
| L. Lamport, *Paxos Made Simple* (2001) | 更短的 Paxos 描述 | <https://lamport.azurewebsites.net/pubs/paxos-simple.pdf> |
| D. Ongaro, J. Ousterhout, *In Search of an Understandable Consensus Algorithm* (2014) | Raft 原始论文；选举、日志复制、成员变更 | <https://raft.github.io/raft.pdf> |
| D. Ongaro, *Consensus: Bridging Theory and Practice* (2014) | Raft 博士论文；实现细节与证明 | <https://web.stanford.edu/~ouster/cgi-bin/papers/OngaroPhD.pdf> |
| M. Fischer, N. Lynch, M. Paterson, *Impossibility of Distributed Consensus with One Faulty Process* (1985) | FLP 不可能性；理解为什么需要超时/随机化 | <https://dl.acm.org/doi/10.1145/3149.214121> |
| G. DeCandia et al., *Dynamo: Amazon's Highly Available Key-value Store* (2007) | 无主复制、quorum、vector clock、 hinted handoff | <https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf> |
| J. C. Corbett et al., *Spanner: Google's Globally-Distributed Database* (2012) | TrueTime、外部一致性、2PC 的组合 | <https://research.google/pubs/pub39966/> |

## 2 一致性与验证

| 材料 | 为什么读 | 链接 |
|:--|:--|:--|
| M. Herlihy, J. Wing, *Linearizability: A Correctness Condition for Concurrent Objects* (1990) | 线性一致的形式定义 | <https://dl.acm.org/doi/10.1145/78969.78972> |
| L. Lamport, *How to Make a Multiprocessor Computer That Correctly Executes Multiprocess Programs* (1979) | 顺序一致的定义 | <https://dl.acm.org/doi/10.1109/TC.1979.1675439> |
| P. Bailis et al., *Highly Available Transactions: Virtues and Limitations* (2014) | 事务与一致性模型的组合边界 | <https://www.vldb.org/pvldb/vol7/p181-bailis.pdf> |
| S. Gilbert, N. Lynch, *Brewer's Conjecture and the Feasibility of Consistent, Available, Partition-Tolerant Web Services* (2002) | CAP 的形式化证明 | <https://dl.acm.org/doi/10.1145/564585.564601> |
| D. Abadi, *Consistency Tradeoffs in Modern Distributed Database System Design* (2012) | PACELC 的提出 | <https://www.cs.umd.edu/~abadi/papers/abadi-pacelc.pdf> |
| Jepsen, *MongoDB 3.4.0-rc3* (2017) | 陈旧读、丢失更新、时钟偏斜的公开分析 | <https://jepsen.io/analyses/mongodb-3-4-0-rc3> |
| Jepsen, *etcd 3.4.3* (2020) | Raft 实现的严格可串行化、watch 顺序与锁的互斥边界 | <https://jepsen.io/analyses/etcd-3.4.3> |
| P. Bailis, K. Kingsbury, *The Network Is Reliable* (2014) | 真实网络分区比想象中常见 | <https://queue.acm.org/detail.cfm?id=2655736> |

## 3 事务、存储与消息

| 材料 | 为什么读 | 链接 |
|:--|:--|:--|
| H. Berenson et al., *A Critique of ANSI SQL Isolation Levels* (1995) | 隔离级别与异常的经典辨析 | <https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/tr-95-51.pdf> |
| M. J. Cahill et al., *Serializable Isolation for Snapshot Databases* (2008) | PostgreSQL SSI 的理论基础 | <https://dl.acm.org/doi/10.1145/1376616.1376690> |
| J. Gray, A. Reuter, *Transaction Processing: Concepts and Techniques* (1992) | 事务处理的系统教材 | 书店/图书馆 |
| H. Garcia-Molina, K. Salem, *Sagas* (1987) | Saga 的原始论文与补偿语义 | <https://dl.acm.org/doi/10.1145/38713.38742> |
| P. Helland, *Life beyond Distributed Transactions* (2007) | 大规模系统为什么避免 2PC | <https://queue.acm.org/detail.cfm?id=3025012> |
| J. Kreps, N. Narkhede, J. Rao, *Kafka: a Distributed Messaging System for Log Processing* (2011) | 日志式消息系统的设计 | <https://notes.stephenholiday.com/Kafka.pdf> |
| *Kafka Documentation: Design* | ISR、acks、幂等生产者、事务 | <https://kafka.apache.org/documentation/#design> |
| *Amazon S3 Consistency Model* | S3 的强一致读后写语义 | <https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html#ConsistencyModel> |

## 4 工程与事故复盘

| 材料 | 为什么读 | 链接 |
|:--|:--|:--|
| D. Kegel, *The Tail at Scale* (2013) | 长尾、对冲请求、延迟放大 | <https://research.google/pubs/pub40801/> |
| B. Beyer et al., *Site Reliability Engineering* (2016) | SLO、错误预算、on-call | <https://sre.google/sre-book/table-of-contents/> |
| LinkedIn Engineering, *How LinkedIn customizes Apache Kafka for 7 trillion messages per day* (2019) | 分区元数据、rebalance、配额与跨集群复制 | <https://engineering.linkedin.com/blog/2019/apache-kafka-trillion-messages> |
| AWS, *Summary of the Amazon S3 Service Disruption in the Northern Virginia Region* (2017) | 重启、缓存重建、重试风暴 | <https://aws.amazon.com/message/41926/> |
| GitHub, *October 21 Post-Incident Analysis* (2018) | 网络分区、MySQL 切换、数据一致性 | <https://github.blog/news-insights/company-news/oct21-post-incident-analysis/> |
| AWS, *Summary of the AWS Service Event in the US-East-1 Region* (2021) | 控制面故障、重试与恢复 | <https://aws.amazon.com/message/12721/> |
| GitLab, *Postmortem of database outage of January 31, 2017* | 备份、恢复、观测与流程 | <https://about.gitlab.com/blog/2017/02/10/postmortem-of-database-outage-of-january-31/> |
| M. Kleppmann, *How to do distributed locking* (2016) | Redlock 与 fencing 的争论 | <https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html> |
| antirez, *Is Redlock safe?* (2016) | 对上述批评的回应 | <http://antirez.com/news/101> |
| Stripe, *Idempotent requests* | 幂等键的工业实践 | <https://docs.stripe.com/api/idempotent_requests> |
| U.S. SEC, *SEC Charges Knight Capital With Violations of Market Access Rule* (2013) | 旧代码路径重复下单、部署不一致 | <https://www.sec.gov/news/press-release/2013-222> |
| Cloudflare, *Details of the Cloudflare outage on July 2, 2019* | 边缘配置推送与全局故障 | <https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/> |

## 5 规范

| 规范 | 用途 |
|:--|:--|
| RFC 9293 (TCP) | 只在解释连接复用/超时时引用；不重写 |
| RFC 9110 (HTTP Semantics) | 方法幂等性、状态码、`Retry-After` |
| RFC 7231（已被 9110 取代） | 历史引用，理解 `Idempotency-Key` 的语境 |
| W3C Trace Context | `traceparent` / `tracestate` 传播格式 |
| OpenTelemetry Specification | trace/metrics/logs 的 API 与语义约定 |

::: note 引用原则
本书不复制论文原文、不搬运事故复盘的长段文字；只提取**可核对的事实**（时间、组件、失败链条、官方结论）并给出链接。若你发现链接失效，按标题搜索原始来源，不要依赖二手转述。
:::
