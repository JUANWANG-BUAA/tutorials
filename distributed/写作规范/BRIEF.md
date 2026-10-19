# 《分布式系统与数据面》写作 brief（章节作者共用）

> 本文件是章节作者的契约。动笔前先读第 1 章 `src/part1/ch01.md`（样章），再读本文件对应章的大纲。
> 只允许编辑分配给你的那一个 `src/partN/chXX.md`；不要改 SUMMARY、book.toml、tools、theme、其他章节。

## 1 硬指标

| 项 | 要求 |
|:--|:--|
| 行数 | **1000–1400 行**，目标 1100–1250；用 `wc -l` 自查 |
| 章首 | `<div class="chapter-index">` 两栏：`本章回答` / `读完你会` |
| 节 | 12–15 个 H2，编号 `N.1`…`N.k`，每个 H2 必须有 `{#sec-distributed.<part>.<N>.<k>}` |
| 失败模式 | 必须有一节标题以 `失败模式：` 开头，且属于分区/超时/重复/乱序之一 |
| 观测 | 必须有一节标题以 `观测：` 开头，含至少一条可复制命令与读法 |
| 真实案例 | 必须有一节标题以 `真实案例：` 开头，含时间、系统、失败链、教训、链接 |
| 重试重复副作用 | 必须有一节标题以 `重试导致重复副作用：` 开头，或至少一个 `::: ex` 明确写这四个字 |
| 陷阱 | 章末 `::: errata`，**8–15 条**编号条目 |
| 出口检查 | `## N.x 本章出口检查`，8–12 行表格 + `::: method` 自测（4–6 题）+ 嵌套 `::: sol` |
| 母本对应 | `## 母本对应` 表格 ≥ 3 行，写清「不重复什么」 |
| 下一站 | 最后一段 `> **下一站**：...` 链接到下一章 |
| 图 | 至少 1 张：`{{#include ../assets/figures/xxx.md}}` 或 `<pre class="layout">` ASCII；状态机/时序图自己画 |
| 代码 | 至少 2 个带语言围栏；可运行代码标 `python`/`bash`/`sql`/`json`；伪代码才用 `text` |
| 盒子 | 只用 `def/thm/ex/intuition/method/errata/note/proof/sol`，不要优先级标记 `[core]` |
| 禁止 | TODO、占位符、「本章正在编写」、emoji、大段复制母本、重写 TCP/HTTP/K8s 基础 |

## 2 锚点规则

- 节：`sec-distributed.<part>.<N>.<k>`，`<part>` 是篇号 1–5，`<N>` 是全书章号，`<k>` 是节号。
- 盒子：`def-distributed.<part>.<N>.<n>`、`ex-...`、`errata-...` 等，`<n>` 在章内唯一即可（建议顺序编号）。
- 同一章内可以写 `[1.2](#sec-distributed.<part>.<N>.2)`；跨章只写 `[第 3 章](../part2/ch03.md)`，**不要跨章写 #锚点**。
- 不要用 `[@def-...]` 交叉引用；用普通 Markdown 链接，降低构建失败风险。

## 3 写作骨架（照抄结构，不照抄内容）

```markdown
# N 标题

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>…</p></div>
<div><span class="ci-label">读完你会</span><p>…</p></div>
</div>

（3–4 段导语：上一章留下什么；本章解决什么；为什么重要；本章路线）

## N.1 标题 {#sec-distributed.<part>.<N>.1}

（先现象/失败，再机制，再边界；至少一个例子或命令）

::: def 定义 N.1.1 · 名称 {#def-distributed.<part>.<N>.1}
…
:::

## N.k 失败模式：… {#sec-distributed.<part>.<N>.k}
## N.k+1 观测：… {#sec-distributed.<part>.<N>.k+1}
## N.k+2 真实案例：… {#sec-distributed.<part>.<N>.k+2}
## N.k+3 重试导致重复副作用：… {#sec-distributed.<part>.<N>.k+3}
## N.k+4 本章陷阱清单 {#sec-distributed.<part>.<N>.k+4}
::: errata 12 条高频错误
1. …
:::
## N.k+5 本章出口检查 {#sec-distributed.<part>.<N>.k+5}
| 检查项 | 达标线 | 没达标去哪 |
|:--|:--|:--|
…
::: method 即时自测 · N
**Q1** …
::: sol 答案
**A1** …
:::
:::
## 母本对应
| 母本 | 章节 | 本书落点 | 程度 | 说明 |
|:--|:--|:--|:--|:--|
…

> **下一站**：…
```

## 4 全书分工与章节大纲

### 第 2 章 · RPC：超时、重试、幂等、背压（part1，篇 1，章 2）

文件：`src/part1/ch02.md`。图：`retry-budget.md` 可用；另画一张 ASCII deadline 时间线。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 2.1 | RPC 到底做了什么：stub、IDL、序列化、连接复用 | 一次调用在客户端/服务端的映射；stub 不是魔法；连接复用与多路复用；与第 1 章 hop 表衔接 |
| 2.2 | 超时不是重试的触发器：deadline 传播 | 绝对 deadline、剩余预算、每跳换算；`grpc-timeout` 语义；超时后 unknown |
| 2.3 | 重试策略：指数退避、抖动、预算、对冲 | 退避公式、full jitter、重试预算、hedged request 的代价；哪些错误可重试 |
| 2.4 | 幂等：键、指纹、去重表、状态机 | 键粒度、客户端生成、指纹规范化、唯一约束、状态机、TTL 回收 |
| 2.5 | 失败模式：超时 + 重试风暴 | 时间线；重试放大；同步重试；与第 11 章呼应 |
| 2.6 | 背压：并发上限、队列与 Little's law | 信号量、队列长度、`L=λW`、拒绝策略；不要无限堆队列 |
| 2.7 | 限流与过载：令牌桶、429/503、Retry-After | 令牌桶/漏桶/滑动窗口；`Retry-After` 语义；服务端如何区分过载与依赖失败 |
| 2.8 | 观测：客户端和服务端各看什么 | `curl -w`、重试次数、`attempt` 标签、p99、连接池、队列；一条命令 |
| 2.9 | 真实案例：S3 2017-02-28 的重启与重试 | 时间线、命令错误、重启、缓存重建、重试放大；官方复盘链接 |
| 2.10 | 重试导致重复副作用：支付请求的两个键 | 同一支付 intent 两个键；服务端两条记录；对账；修复 |
| 2.11 | 一份 RPC 契约检查表 | 12–15 项；错误码表；超时/重试/幂等/背压四件套 |
| 2.12 | 本章陷阱清单 | 10–14 条 |
| 2.13 | 本章出口检查 | 8–12 行 + 5 题自测 |

必写代码：Python deadline 传播；带 jitter 的重试；令牌桶；幂等键/指纹（可与第 1 章不同实现）。
必写表：可重试错误 vs 不可重试；重试预算参数。
母本：谢希仁第 5/6 章背景；张彦飞第 4–7 章背景；Python 网络编程精选；Linux 4.4–4.7 交叉引用、不重写。

### 第 3 章 · 复制：主从、多主、无主（part2，篇 2，章 3）

文件：`src/part2/ch03.md`。图：`replication-topologies.md`、`quorum.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 3.1 | 复制的三个目标：耐久、读扩展、地理就近 | RPO/RTO；复制不是备份；同步/异步的延迟代价 |
| 3.2 | 单主复制：同步、异步、半同步 | 日志/状态机；半同步的 quorum 变体；提交与可见性 |
| 3.3 | 复制日志与状态机 | 确定性命令、apply 顺序、快照；日志索引/term |
| 3.4 | 故障切换：选主、分裂脑、fencing | 检测、提升、旧主；fencing token 预告 |
| 3.5 | 多主复制：冲突从哪来 | 双写、离线、地域；冲突检测；写冲突 vs 读冲突 |
| 3.6 | 冲突解决：LWW、版本向量、CRDT | LWW 的时钟陷阱；版本向量偏序；CRDT 的交换/结合/幂等 |
| 3.7 | 无主复制：quorum、读修复、hinted handoff、Merkle | R+W>N 的边界；读修复；反熵；sloppy quorum |
| 3.8 | 复制延迟与读己之写 | lag 来源；会话保证；从库读的风险 |
| 3.9 | 失败模式：分区下的双主 | 时间线；两个 leader 都接受写；数据分叉；如何止损 |
| 3.10 | 观测：复制 lag 的四个来源 | `pg_stat_replication`/`SHOW REPLICA STATUS`/Kafka ISR；命令 + 读法 |
| 3.11 | 真实案例：GitHub 2018-10-21 分区与 MySQL 切换 | 24h 11m；网络分区；Orchestrator 切换；数据一致性风险；官方复盘 |
| 3.12 | 重试导致重复副作用：新主重放旧命令 | 客户端重试 + 新主未去重；日志重复；修复 |
| 3.13 | 本章陷阱清单 | 10–14 条 |
| 3.14 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：3 副本 quorum 模拟器（Python，纯标准库）；或日志复制伪代码。
必写 ASCII：一次 failover 时间线。
母本：谢希仁第 5 章背景；张彦飞第 6–8 章背景；Dynamo 论文放参考文献，不复制。

### 第 4 章 · 一致性模型：线性/顺序/最终（part2，篇 2，章 4）

文件：`src/part2/ch04.md`。图：`linearizability.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 4.1 | 历史、实时序与三种操作 | history、invocation/response、读/写/CAS；如何记录 |
| 4.2 | 线性一致性：定义与判定 | 全序 + 实时序 + 读最新写；正例/反例；判定算法思路 |
| 4.3 | 顺序一致性：差在哪 | 全序但不要求实时；经典反例 |
| 4.4 | 因果一致性与会话保证 | happens-before；读己之写、单调读、单调写、写后读 |
| 4.5 | 最终一致性：收敛的条件 | 无新写、反熵、读修复；收敛时间不是 SLA |
| 4.6 | CAP 的精确版本与 PACELC | 分区时 C/A 的确切含义；PACELC；不要口号 |
| 4.7 | 一致性不是隔离级别 | 副本一致性 vs 事务隔离；两个维度表 |
| 4.8 | 失败模式：分区期间的陈旧读 | 时间线；从库 lag；客户端重试读；业务后果 |
| 4.9 | 观测：etcd 的 linearizable vs serializable read | `etcdctl get --consistency=l/s`；命令 + 输出 + 读法 |
| 4.10 | 真实案例：Jepsen 对 MongoDB 3.4 的分析 | 2017-02-07；v0 协议丢多数派确认写；v1 bug；修复版本；链接 |
| 4.11 | 重试导致重复副作用：陈旧读后的二次转账 | 读到旧余额 → 重试 → 二次转账；版本号/CAS 修复 |
| 4.12 | 如何为业务选一致性 | 决策表：余额/库存/Feed/会话；成本 |
| 4.13 | 本章陷阱清单 | 10–14 条 |
| 4.14 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：一个小型历史检查器（枚举全序或简化版）；至少给一段可运行的 `is_linearizable` 伪代码/Python。
必写表：一致性模型对比（实时序/全序/读最新/代价）。
母本：谢希仁第 5/6 章只作背景；Jepsen 分析放参考文献。

### 第 5 章 · 共识：Paxos 与 Raft（part2，篇 2，章 5）

文件：`src/part2/ch05.md`。图：`raft-states.md`、`raft-election.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 5.1 | 共识问题：协议要保证什么 | agreement/validity/termination；状态机复制 |
| 5.2 | FLP、故障模型与 quorum | 异步 + 1 崩溃；为什么工程靠超时/随机；quorum 相交 |
| 5.3 | Paxos：prepare/promise/accept/accepted | 两阶段、提案号、多数派、安全性直觉；不写形式化证明全文 |
| 5.4 | Paxos 的活锁与 Multi-Paxos | 双提案者互锁；稳定 leader；日志槽位 |
| 5.5 | Raft：term、角色、选举 | term、投票规则、随机超时、选举限制 |
| 5.6 | Raft：日志复制与提交规则 | prevLogIndex/term、冲突截断、commit 当前 term 规则 |
| 5.7 | 成员变更与快照 | 单步变更/联合共识；快照与日志截断 |
| 5.8 | 线性一致读：ReadIndex、lease read、follower read | 三种读路径；时钟假设；代价 |
| 5.9 | 失败模式：分区后的旧主 | 旧主仍接受读/写；新主已选出；fencing/check quorum |
| 5.10 | 观测：etcd/raft 指标 | `etcdctl endpoint status`、`etcd_server_*`、`raft_terms`；命令 + 读法 |
| 5.11 | 真实案例：Jepsen 对 etcd 3.4.3 的分析 | 2020-01-30；严格可串行化、watch、锁不互斥；链接 |
| 5.12 | 重试导致重复副作用：提案重试与状态机去重 | 客户端重试同一命令；日志两条；request id 去重 |
| 5.13 | 自己实现 Raft 的五个坑 | 提交旧 term、投票持久化、快照、成员变更、读路径 |
| 5.14 | 本章陷阱清单 | 10–14 条 |
| 5.15 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：Paxos acceptor 简化模拟器；Raft 选举/日志检查伪代码。
必写 ASCII：一次分区后旧主被拒的时间线。
母本：谢希仁/张彦飞不覆盖共识；写「本书自编 + Raft 论文/Paxos 论文」；只引用不复制。

### 第 6 章 · 事务：ACID、隔离级别、MVCC（part3，篇 3，章 6）

文件：`src/part3/ch06.md`。图：`mvcc.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 6.1 | ACID 在单机与分布式中的含义 | C 是应用不变量；A/D 的边界；分布式下的 A |
| 6.2 | 隔离级别与异常：从脏读到写偏斜 | 脏读/不可重复/幻读/丢失更新/写偏斜；SQL 标准 vs 实际 |
| 6.3 | MVCC：版本、快照、可见性 | 版本链、read view、xmin/xmax、快照；长事务 |
| 6.4 | InnoDB 与 PostgreSQL 的实现差异 | undo log/read view vs 元组 xmin/xmax；vacuum；SSI |
| 6.5 | 锁、死锁与重试 | 行锁/间隙锁、死锁检测、重试策略；不要盲重试 |
| 6.6 | 分布式事务：2PC、TCC、Saga | 2PC 阻塞；TCC 空回滚/悬挂；Saga 补偿；选型表 |
| 6.7 | Outbox 与幂等消费 | 本地事务 + outbox；CDC；至少一次 + 去重 |
| 6.8 | 失败模式：重试把一次转账做成两次 | 事务重试 + 非幂等 INSERT；唯一约束 |
| 6.9 | 观测：pg_stat_activity / pg_locks / InnoDB status | 一条命令 + 读法；长事务/锁等待/回滚率 |
| 6.10 | 真实案例：Spanner 的 TrueTime + 2PC | 外部一致性；TrueTime 等待；2PC；不是「全球强一致免费」 |
| 6.11 | 重试导致重复副作用：非幂等 INSERT 的重放 | 无唯一键；重试插两条；修复 |
| 6.12 | 事务边界设计清单 | 短事务、幂等、outbox、补偿、隔离级别 |
| 6.13 | 本章陷阱清单 | 10–14 条 |
| 6.14 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：SQL 事务/隔离级别示例（PostgreSQL 语法）；Python 重试 + 唯一约束。
必写 ASCII：2PC 时序；Saga 补偿链。
母本：谢希仁/张彦飞不覆盖事务；写「本书自编 + 数据库教材/论文」；不复制 PostgreSQL 文档长段。

### 第 7 章 · 队列、流与事件驱动（part3，篇 3，章 7）

文件：`src/part3/ch07.md`。图：`log-offsets.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 7.1 | 队列与日志：删除 vs 保留 | 队列消费即删；日志保留/重放；offset |
| 7.2 | 投递语义：最多一次、至少一次、有效一次 | 生产者/消费者两侧；重复发生在哪 |
| 7.3 | 分区、顺序与消费者组 | 分区键、顺序保证范围、rebalance |
| 7.4 | Offset 提交与再平衡 | 自动/手动提交；处理成功但提交失败；再平衡 |
| 7.5 | Kafka 的 ISR、acks、幂等生产者、事务 | acks=all/min.insync.replicas；幂等 producer；事务边界 |
| 7.6 | Outbox、CDC 与事件溯源 | 双写问题；outbox 表；Debezium 类 CDC；重放 |
| 7.7 | 失败模式：重复投递与乱序 | 时间线；重复/乱序；业务后果 |
| 7.8 | 观测：consumer lag 与 rebalance | `kafka-consumer-groups.sh --describe`；lag 读法 |
| 7.9 | 真实案例：Kafka 在 LinkedIn 的规模与运维 | 7 万亿条/天；分区/保留/复制的工程取舍；链接 |
| 7.10 | 重试导致重复副作用：offset 提交失败后的二次扣款 | 处理成功 + 提交失败；重投；去重表 |
| 7.11 | 事件设计清单 | 事件 ID、分区键、幂等、schema、重放 |
| 7.12 | 本章陷阱清单 | 10–14 条 |
| 7.13 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：Python outbox + 消费者去重；SQL 表结构。
必写 ASCII：consumer group/offset 时间线。
母本：谢希仁第 6 章只作背景；Kafka 论文/文档放参考文献；不写 Kafka 全配置手册。

### 第 8 章 · 对象存储、缓存与 CDN（part3，篇 3，章 8）

文件：`src/part3/ch08.md`。图：`cache-path.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 8.1 | 对象存储的语义：PUT/GET、ETag、条件写、多段上传 | 不可变对象、ETag、If-Match、multipart、预签名 |
| 8.2 | S3 强一致之后还剩什么坑 | 2020-12 强一致读后写；列表/覆盖/多段/跨区域仍要注意 |
| 8.3 | 缓存模式：cache-aside/read-through/write-through/write-behind | 四种模式的写路径与失败路径 |
| 8.4 | 缓存一致性：TTL、失效、双写、延迟双删 | 先写库后删缓存；删除失败；延迟双删；版本号 |
| 8.5 | 击穿、穿透、雪崩与热点 key | singleflight、空值缓存、随机 TTL、分片 |
| 8.6 | CDN：anycast、边缘缓存、cache key、purge | 命中/回源；cache key 设计；purge 范围；stale-while-revalidate |
| 8.7 | 失败模式：缓存陈旧与回源风暴 | 时间线；TTL 过期同时回源；限流 |
| 8.8 | 观测：Age、X-Cache、命中率、S3 request id | `curl -I`；`redis-cli INFO stats`；读法 |
| 8.9 | 真实案例：2019-07-02 Cloudflare 边缘故障 | WAF 正则规则、CPU 耗尽、全球 27 分钟；官方复盘 |
| 8.10 | 重试导致重复副作用：上传重试与重复扣费 | PUT 重试 + 业务扣费；条件写/幂等键 |
| 8.11 | 缓存与 CDN 设计清单 | TTL/失效/击穿/热点/观测 |
| 8.12 | 本章陷阱清单 | 10–14 条 |
| 8.13 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：cache-aside + singleflight；条件 PUT（`If-None-Match`/`If-Match`）。
必写 ASCII：CDN 回源与 purge 路径。
母本：谢希仁第 6 章应用层背景；S3/Cloudflare 文档放参考文献；不写 CDN 厂商控制台。

### 第 9 章 · 分布式锁、租约与选主（part4，篇 4，章 9）

文件：`src/part4/ch09.md`。图：`fencing.md`。

| 节 | 标题 | 必写内容 |
|:|:--|:--|
| 9.1 | 锁的三个层次：互斥、租约、fencing | 锁不是「一个 key」；租约有时钟；fencing 是资源端校验 |
| 9.2 | Redis 锁：SET NX PX、Lua 解锁、续期 | 原子加锁/解锁；误删他人锁；续期；主从切换丢锁 |
| 9.3 | Redlock 争议与时钟假设 | 多 Redis 实例；Kleppmann 的批评；antirez 回应；适用边界 |
| 9.4 | ZooKeeper/etcd：临时节点、lease、watch | 会话、临时节点、lease TTL、watch 一次性 |
| 9.5 | 选主：bully、Raft、lease | 选主不是锁；quorum；旧主自停 |
| 9.6 | fencing token：把过期锁挡在资源外 | 单调 token；资源端记录最大 token；拒绝旧 token |
| 9.7 | 失败模式：GC 停顿导致锁过期 | 时间线；两个持有者；副作用 |
| 9.8 | 观测：lease TTL、锁等待、会话 | `etcdctl lease timetolive`、`redis-cli INFO`；读法 |
| 9.9 | 真实案例：Redlock 辩论 | 2016 Kleppmann/antirez；争点；工程结论 |
| 9.10 | 重试导致重复副作用：锁过期后的双执行 | 锁过期 + 客户端重试；双写；fencing 修复 |
| 9.11 | 锁的使用边界 | 能不用锁就不用；幂等/分区/单写者 |
| 9.12 | 本章陷阱清单 | 10–14 条 |
| 9.13 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：Redis Lua 解锁；fencing token 校验（Python）。
必写 ASCII：GC 停顿 + lease 过期 + fence 拒绝时间线。
母本：谢希仁/张彦飞不覆盖锁；写「本书自编 + Kleppmann/Redis 文档」；不复制博客长段。

### 第 10 章 · 可观测性：trace、指标、日志、回放（part4，篇 4，章 10）

文件：`src/part4/ch10.md`。图：`trace-waterfall.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 10.1 | 三支柱与它们的盲区 | trace 采样、指标聚合、日志重复；互补 |
| 10.2 | Trace：context、span、采样 | `traceparent`；span kind；头采样/尾采样；重复 span |
| 10.3 | 指标：RED/USE、直方图、分位数 | counter/gauge/histogram；分位数不能平均；exemplar |
| 10.4 | 日志：结构化、关联、成本 | 结构化字段；trace id；采样；成本 |
| 10.5 | OpenTelemetry 与 collector | API/SDK/collector；batch/retry；不要阻塞业务 |
| 10.6 | SLO、错误预算与告警 | SLI/SLO/error budget； burn rate；告警 |
| 10.7 | 回放：确定性重放、影子流量、事件溯源 | 重放输入/副作用隔离；影子流量；幂等 |
| 10.8 | 失败模式：重试导致的重复 span 与错误指标 | 一次用户操作 N 个 span；指标双算；盲区 |
| 10.9 | 观测：用 trace 找 p99 的那一段 | `curl` trace + `jq`；Prometheus query；读法 |
| 10.10 | 真实案例：GitLab 2017-01-31 数据库误删与恢复 | 5 种备份失效；6 小时数据丢失；观测/流程教训 |
| 10.11 | 重试导致重复副作用：回放流量没有幂等 | 回放生产请求；二次扣款；隔离/幂等 |
| 10.12 | 可观测性设计清单 | 每个关键路径的 trace/metrics/log/SLO |
| 10.13 | 本章陷阱清单 | 10–14 条 |
| 10.14 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：W3C `traceparent` 生成/解析；结构化日志；Prometheus 查询。
必写 ASCII：trace waterfall 的文本版或 span 树。
母本：谢希仁/张彦飞不覆盖可观测性；写「本书自编 + OpenTelemetry/SRE 书」；不复制。

### 第 11 章 · 容量、限流、降级、故障演练（part4，篇 4，章 11）

文件：`src/part4/ch11.md`。图：`utilization.md`。

| 节 | 标题 | 必写内容 |
|--:|:--|:--|
| 11.1 | 容量：Little's law 与利用率曲线 | L=λW；headroom；容量单位 |
| 11.2 | 排队论直觉：为什么 70% 就开始抖 | M/M/1/M/M/c；1/(1-ρ)；变异性 |
| 11.3 | 压测：基线、梯度、开放/闭环 | 开放 vs 闭环；预热；P99；错误率 |
| 11.4 | 限流：令牌桶、漏桶、滑动窗口、分布式限流 | 算法；Redis Lua；热点；公平性 |
| 11.5 | 降级：优先级、熔断、舱壁 | 熔断状态机；半开；舱壁隔离；降级策略 |
| 11.6 | 自动扩缩容的陷阱 | 冷启动；指标延迟；缩容抖动；有状态服务 |
| 11.7 | 故障演练：假设、爆炸半径、game day | 假设、注入、观测、回滚；爆炸半径 |
| 11.8 | 失败模式：重试风暴与过载 | 正反馈；时间线；止损顺序 |
| 11.9 | 观测：tc/netem、wrk、qdisc、metrics | `tc -s qdisc`、`wrk`、`ss -s`；一条命令 |
| 11.10 | 真实案例：2021-12-07 AWS us-east-1 故障 | 内部网络拥塞；控制面/服务受影响；恢复；官方复盘 |
| 11.11 | 重试导致重复副作用：压测回放打到生产 | 回放流量 + 非幂等；隔离/脱敏/幂等 |
| 11.12 | 容量与演练清单 | 基线/梯度/headroom/熔断/回滚 |
| 11.13 | 本章陷阱清单 | 10–14 条 |
| 11.14 | 本章出口检查 | 8–12 行 + 5 题 |

必写代码：令牌桶；熔断器；`tc netem` 故障注入脚本（bash，`bash -n` 通过）。
必写 ASCII：重试风暴正反馈环。
母本：谢希仁/张彦飞不覆盖容量；写「本书自编 + SRE 书/AWS 复盘」；不复制。

### 第 12 章 · 项目一：幂等工具调用后端（part5，篇 5，章 12）

文件：`src/part5/ch12.md`。图：`idempotency-state.md`。
代码在 `projects/idempotent-tool/`（由主线程提供，章节作者**只读**，不要改代码）。
章节要按 `projects/idempotent-tool/` 的实际代码写代码走读、测试、故障注入、压测结果。
若代码尚未就绪，先写设计/契约/测试计划，代码走读处标注「以仓库最终文件为准」，不要编造行号。

必写节：12.1 目标与验收；12.2 需求与不变量；12.3 数据模型；12.4 API 契约；12.5 核心算法；12.6 并发；12.7 崩溃恢复；12.8 客户端重试与轮询；12.9 代码走读；12.10 测试；12.11 故障注入；12.12 压测；12.13 失败模式：丢响应后的重复调用；12.14 真实案例：Stripe idempotency key；12.15 重试导致重复副作用：同一把钥匙的两种结局；12.16 陷阱；12.17 出口检查。
必写：`curl` 命令、SQLite 事务、状态机、测试输出、`fault_inject.sh --dry-run`。
母本：Python 网络编程精选；Linux 4.4–4.11 交叉引用；Stripe 文档放参考文献。

### 第 13 章 · 项目二：小型复制 KV/一致性读（part5，篇 5，章 13）

文件：`src/part5/ch13.md`。图：`kv-replication.md`、`kv-readindex.md`。
代码在 `projects/replicated-kv/`（由主线程提供，章节作者**只读**，不要改代码）。

必写节：13.1 目标与验收；13.2 不变量与故障模型；13.3 架构；13.4 选举；13.5 日志复制与提交；13.6 客户端协议与去重；13.7 一致性读；13.8 持久化与恢复；13.9 代码走读；13.10 测试；13.11 故障注入；13.12 一致性检查器；13.13 失败模式：分区期间的旧主读；13.14 真实案例：etcd ReadIndex；13.15 重试导致重复副作用：客户端重试写；13.16 陷阱；13.17 出口检查。
必写：`kv_client.py` 命令、`curl /status`、`fault_inject.sh --partition`、测试输出、检查器逻辑。
母本：谢希仁第 5 章背景；Raft 论文/etcd 文档放参考文献；不复制 etcd 源码。

## 5 真实案例事实卡（只写这些，不要加戏）

- **S3 2017-02-28**：AWS 官方复盘；一条输入错误的命令导致大量 S3 子系统被移除；重启后缓存重建、请求重试放大；影响约 4 小时。链接 `https://aws.amazon.com/message/41926/`。
- **GitHub 2018-10-21**：网络分区 43 秒，数据库集群故障切换；24 小时 11 分钟降级；为保一致性暂停写入/降级；官方复盘 `https://github.blog/news-insights/company-news/oct21-post-incident-analysis/`。
- **Jepsen MongoDB 3.4**：2017-02-07 发布；v0 复制协议在时钟偏斜/分区下丢失多数派确认写；v1 有多个 bug，3.2.12/3.4.0 修复；`https://jepsen.io/analyses/mongodb-3-4-0-rc3`。
- **Jepsen etcd 3.4.3**：2020-01-30 分析；KV 严格可串行化、watch 按序、etcd 锁不保证互斥（lease 复查 bug + 分布式锁本质）；链接 `https://jepsen.io/analyses/etcd-3.4.3`。
- **Spanner**：2012 论文；TrueTime + 2PC；外部一致性；不是「零延迟强一致」。
- **Kafka/LinkedIn**：LinkedIn 工程博客曾披露每天数万亿条消息；写规模与分区/保留/复制的取舍，不编造事故。
- **Cloudflare 2019-07-02**：WAF 规则中的正则表达式回溯/CPU 耗尽，边缘全球故障约 27 分钟；官方复盘 `https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/`。
- **Redlock 辩论**：2016-02-08 Kleppmann 文章；antirez 回应；争点是时钟/进程暂停下的安全性，不是「Redis 能不能做锁」。
- **GitLab 2017-01-31**：数据库误删；5 种备份/恢复机制失效；约 6 小时数据丢失；官方复盘 `https://about.gitlab.com/blog/2017/02/10/postmortem-of-database-outage-of-january-31/`。
- **AWS us-east-1 2021-12-07**：内部网络自动化活动触发异常，影响控制面与多项服务；官方复盘 `https://aws.amazon.com/message/12721/`。
- **Stripe idempotency keys**：客户端提供 key，服务端保存结果；重试返回原结果；`https://docs.stripe.com/api/idempotent_requests`。
- **etcd ReadIndex**：线性一致读走 ReadIndex/心跳确认；lease read 依赖时钟；官方文档/代码。

## 6 观测命令的最低要求

每章至少一条命令，必须包含：

1. 命令本身（`bash` 围栏）；
2. 一段示例输出（`text` 围栏）；
3. 「怎么读」表或 3 条要点；
4. 正常/异常的分界。

不要写「用 Prometheus 看一下」这种没有查询语句的话。用具体查询/CLI。

## 7 母本对应表模板

| 母本 | 章节 | 本书落点 | 程度 | 说明 |
|:--|:--|:--|:--|:--|
| 谢希仁《计算机网络》第 8 版 | 第 5/6 章 | N.x | 背景 | 只借用分层/协议事实，不重写 |
| 张彦飞《深入理解 Linux 网络》 | 第 4–7 章 | N.x | 背景 | 连接/超时只引用 |
| 《Python 网络编程》 | socket/HTTP/并发 | N.x | 精选 | 工程风格；代码重写 |
| 《Linux 系统与内核》第 4/5 篇 | 4.1–4.11 / 5.1–5.6 | N.x | 交叉引用 | 明确不重复 TCP/HTTP/K8s |
| 本书自编 + 论文/规范 | … | N.x | 完整 | 只引用事实，不复制原文 |

## 8 交付前

```bash
cd distributed
wc -l src/partN/chXX.md
python3 tools/check_book.py --only partN/chXX.md
```

必须看到 `OK`。若行数不足，**加实质内容**（例子、代码、边界、观测、反例），不要用空行/重复句子凑数。

写完后回报：文件路径、行数、H2 数、图/代码块数量、check 结果。
