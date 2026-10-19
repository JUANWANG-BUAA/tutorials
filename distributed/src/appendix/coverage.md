# A.1 母本与主题覆盖矩阵

## 1 怎么读

这张表有两个用途：

1. **主题覆盖**：任务书要求的数据面主题，每一项都必须能在正文找到一个可跳转的节；`tools/check_coverage.py` 会逐行核对锚点是否存在。
2. **母本对应**：四本母本（谢希仁、张彦飞、《Python 网络编程》、《Linux 系统与内核》）的哪些章节被本书引用、哪些明确不重复。母本不覆盖的分布式协议，标为「本书自编 + 论文/规范」。

「深度」列的含义：

- **完整**：概念、机制、失败路径、观测、例子都在正文；
- **精选**：核心机制在正文，冷门细节指路；
- **背景**：只借用事实/视角，不展开；
- **交叉引用**：本书不写，指向 Linux 书对应篇章。

## 2 主题覆盖（55 项，缺口 0）

| # | 主题 | 本书落点 | 锚点 | 深度 | 说明 |
|--:|:--|:--|:--|:--|:--|
| 1 | 请求路径与延迟预算 | 1.1、1.4 | `sec-distributed.1.1.1` | 完整 | 12 个 hop、逐跳预算、p99 放大 |
| 2 | 部分失败与 unknown 状态 | 1.3、1.5、1.6 | `sec-distributed.1.1.5` | 完整 | 七类失败、状态机、超时三种真相 |
| 3 | 超时与 deadline 传播 | 2.2 | `sec-distributed.1.2.2` | 完整 | 绝对 deadline、逐跳换算、取消语义 |
| 4 | 重试、退避与抖动 | 2.3 | `sec-distributed.1.2.3` | 完整 | full jitter、错误分类、hedged request |
| 5 | 重试预算与放大倍数 | 2.5 | `sec-distributed.1.2.5` | 完整 | 正反馈、同步重试、止损顺序 |
| 6 | 幂等键与请求指纹 | 2.4 | `sec-distributed.1.2.4` | 完整 | 键粒度、规范化、唯一约束 |
| 7 | 去重表与状态机 | 12.3、12.5 | `sec-distributed.5.12.5` | 完整 | calls/effects/audit、claim、succeed |
| 8 | 背压与并发上限 | 2.6 | `sec-distributed.1.2.6` | 完整 | Little's law、有界队列、拒绝策略 |
| 9 | 限流与过载保护 | 2.7 | `sec-distributed.1.2.7` | 完整 | 令牌桶、429/503、Retry-After |
| 10 | 单主复制 | 3.1、3.2 | `sec-distributed.2.3.2` | 完整 | 同步/异步/半同步、RPO/RTO |
| 11 | 多主复制与冲突解决 | 3.5、3.6 | `sec-distributed.2.3.5` | 完整 | LWW、版本向量、CRDT |
| 12 | 无主复制与 quorum | 3.7 | `sec-distributed.2.3.7` | 完整 | R+W>N、读修复、hinted handoff、Merkle |
| 13 | 复制延迟与读己之写 | 3.8 | `sec-distributed.2.3.8` | 完整 | lag 来源、会话保证 |
| 14 | 线性一致性 | 4.2 | `sec-distributed.2.4.2` | 完整 | 实时序、全序、判定与反例 |
| 15 | 顺序一致性 | 4.3 | `sec-distributed.2.4.3` | 完整 | 与线性一致的差异 |
| 16 | 因果一致性与会话保证 | 4.4 | `sec-distributed.2.4.4` | 完整 | happens-before、RYW、单调读 |
| 17 | 最终一致性与收敛 | 4.5 | `sec-distributed.2.4.5` | 完整 | 收敛条件、反熵、读修复 |
| 18 | CAP 与 PACELC 的精确表述 | 4.6 | `sec-distributed.2.4.6` | 完整 | 分区时选什么、无分区时的 L/C |
| 19 | Paxos | 5.3 | `sec-distributed.2.5.3` | 完整 | prepare/promise/accept/accepted |
| 20 | Multi-Paxos 与活锁 | 5.4 | `sec-distributed.2.5.4` | 完整 | 双提案者互锁、稳定 leader |
| 21 | Raft 选举 | 5.5 | `sec-distributed.2.5.5` | 完整 | term、投票、随机超时、选举限制 |
| 22 | Raft 日志复制与提交 | 5.6 | `sec-distributed.2.5.6` | 完整 | prevLogIndex/term、当前 term 提交 |
| 23 | 成员变更与快照 | 5.7 | `sec-distributed.2.5.7` | 精选 | 单步/联合共识、快照截断 |
| 24 | 线性一致读（ReadIndex/lease） | 5.8、13.7 | `sec-distributed.2.5.8` | 完整 | ReadIndex、lease read、follower read |
| 25 | ACID 与事务边界 | 6.1 | `sec-distributed.3.6.1` | 完整 | C 是应用不变量、短事务 |
| 26 | 隔离级别与异常 | 6.2 | `sec-distributed.3.6.2` | 完整 | 脏读/不可重复/幻读/写偏斜 |
| 27 | MVCC 可见性 | 6.3、6.4 | `sec-distributed.3.6.3` | 完整 | 版本链、read view、xmin/xmax |
| 28 | 分布式事务 2PC/TCC/Saga | 6.6 | `sec-distributed.3.6.6` | 完整 | 阻塞、空回滚、补偿、选型 |
| 29 | Outbox 与幂等消费 | 6.7 | `sec-distributed.3.6.7` | 完整 | 双写、CDC、去重 |
| 30 | 队列与日志的区别 | 7.1 | `sec-distributed.3.7.1` | 完整 | 删除 vs 保留、重放 |
| 31 | 投递语义 | 7.2 | `sec-distributed.3.7.2` | 完整 | 最多/至少/有效一次 |
| 32 | 分区、顺序与消费者组 | 7.3 | `sec-distributed.3.7.3` | 完整 | 分区键、顺序范围、rebalance |
| 33 | offset 提交与再平衡 | 7.4 | `sec-distributed.3.7.4` | 完整 | 提交窗口、重复投递 |
| 34 | Kafka ISR/acks/事务 | 7.5 | `sec-distributed.3.7.5` | 完整 | acks=all、min.insync、幂等生产者 |
| 35 | CDC 与事件溯源 | 7.6 | `sec-distributed.3.7.6` | 完整 | outbox、binlog、重放 |
| 36 | 对象存储语义 | 8.1、8.2 | `sec-distributed.3.8.1` | 完整 | ETag、条件写、多段上传、强一致 |
| 37 | 缓存模式与一致性 | 8.3、8.4 | `sec-distributed.3.8.3` | 完整 | cache-aside、双写、延迟双删 |
| 38 | 缓存击穿/穿透/雪崩 | 8.5 | `sec-distributed.3.8.5` | 完整 | singleflight、空值、随机 TTL |
| 39 | CDN 与边缘缓存 | 8.6 | `sec-distributed.3.8.6` | 完整 | anycast、cache key、purge |
| 40 | 分布式锁 | 9.1、9.2 | `sec-distributed.4.9.2` | 完整 | SET NX PX、Lua、续期、主从丢锁 |
| 41 | 租约与 fencing token | 9.6、9.7 | `sec-distributed.4.9.6` | 完整 | 单调 token、资源端校验、GC 停顿 |
| 42 | 选主与分裂脑 | 9.5 | `sec-distributed.4.9.5` | 完整 | bully、Raft、lease、旧主自停 |
| 43 | trace 与上下文传播 | 10.2 | `sec-distributed.4.10.2` | 完整 | traceparent、span、采样 |
| 44 | 指标与分位数 | 10.3 | `sec-distributed.4.10.3` | 完整 | RED/USE、histogram、exemplar |
| 45 | 结构化日志 | 10.4 | `sec-distributed.4.10.4` | 完整 | 字段、trace id、成本 |
| 46 | SLO 与错误预算 | 10.6 | `sec-distributed.4.10.6` | 完整 | SLI/SLO、burn rate |
| 47 | 回放与影子流量 | 10.7 | `sec-distributed.4.10.7` | 完整 | 确定性重放、副作用隔离 |
| 48 | 容量与 Little's law | 11.1 | `sec-distributed.4.11.1` | 完整 | L=λW、headroom |
| 49 | 排队与利用率曲线 | 11.2 | `sec-distributed.4.11.2` | 完整 | 1/(1-ρ)、变异性 |
| 50 | 压测方法 | 11.3 | `sec-distributed.4.11.3` | 完整 | 基线、梯度、开放/闭环 |
| 51 | 降级、熔断与舱壁 | 11.5 | `sec-distributed.4.11.5` | 完整 | 熔断状态机、隔离、优先级 |
| 52 | 故障演练与爆炸半径 | 11.7 | `sec-distributed.4.11.7` | 完整 | 假设、注入、回滚、game day |
| 53 | 项目一：幂等工具调用后端 | 12.1–12.17 | `sec-distributed.5.12.1` | 完整 | 可运行服务、7 测试、3 类故障 |
| 54 | 项目二：小型复制 KV | 13.1–13.17 | `sec-distributed.5.13.1` | 完整 | 三节点、选举、复制、一致性读 |
| 55 | 项目二的一致性读（ReadIndex/lease/stale） | 13.7、13.13 | `sec-distributed.5.13.7` | 完整 | 三条读路径、分区旧主、测试证据 |

> 校验：`python3 tools/check_coverage.py`。任何一行锚点不存在、或 REQUIRED 主题缺失，都会退出非 0。

## 3 母本对应

### 3.1 谢希仁《计算机网络》第 8 版

| 母本 | 章节 | 本书落点 | 锚点 | 处理 |
|:--|:--|:--|:--|:--|
| 谢希仁 | 第 1 章 概述（分层、协议） | 1.1、1.11 | `sec-distributed.1.1.1` | 背景：只借用分层视角；不重写体系结构 |
| 谢希仁 | 第 5 章 运输层（TCP/UDP） | 1.1、1.8、2.2 | `sec-distributed.1.2.2` | 交叉引用：TCP 状态机、拥塞控制见 Linux 书 4.4–4.6 |
| 谢希仁 | 第 6 章 应用层（HTTP/DNS） | 8.6、12.4 | `sec-distributed.3.8.6` | 背景：HTTP 语义只用于缓存/重试；报文细节不重写 |
| 谢希仁 | 第 7 章 网络安全 | 2.2、8.1 | `sec-distributed.1.2.2` | 背景：只提 mTLS/鉴权边界，不写 TLS 握手 |
| 谢希仁 | 第 8–10 章（音视频、无线、下一代互联网） | — | — | 淘汰：与数据面主线无关 |

### 3.2 张彦飞《深入理解 Linux 网络》

| 母本 | 章节 | 本书落点 | 锚点 | 处理 |
|:--|:--|:--|:--|:--|
| 张彦飞 | 第 4–5 章（TCP 连接、收发） | 1.1、2.2、12.6 | `sec-distributed.5.12.6` | 背景：连接复用/超时只引用；不重写内核路径 |
| 张彦飞 | 第 6 章（连接队列、握手） | 1.1、1.8 | `sec-distributed.1.1.1` | 交叉引用：队列/握手细节见 Linux 书 4.5、4.11 |
| 张彦飞 | 第 7–8 章（socket、epoll） | 12.6、13.9 | `sec-distributed.5.13.1` | 背景：只讲用户态服务模型；epoll 实现不重写 |
| 张彦飞 | 第 9–10 章（性能、容器网络） | 11.1、11.9 | `sec-distributed.4.11.1` | 精选：容量/观测借用指标；容器网络见 Linux 书第 5 篇 |

### 3.3 《Python 网络编程》

| 母本 | 章节 | 本书落点 | 锚点 | 处理 |
|:--|:--|:--|:--|:--|
| Python 网络编程 | socket/HTTP 客户端与服务端 | 12.4、12.8、13.6 | `sec-distributed.5.12.8` | 精选：工程风格；代码全部重写 |
| Python 网络编程 | 并发服务器/线程 | 12.6、12.9 | `sec-distributed.5.12.9` | 精选：只讲与本项目相关的线程/队列 |
| Python 网络编程 | 协议解析/超时 | 2.2、2.3 | `sec-distributed.1.2.3` | 背景：不复制示例，不写 socket API 手册 |

### 3.4 《Linux 系统与内核》

| 母本 | 章节 | 本书落点 | 锚点 | 处理 |
|:--|:--|:--|:--|:--|
| Linux 书 | 第 4 篇 4.1–4.12（网络） | 1.1、2.2、8.6、12.6 | `sec-distributed.1.1.1` | 交叉引用：TCP/IP、socket、epoll、HTTP/DNS/TLS 不重写 |
| Linux 书 | 第 5 篇 5.1–5.6（容器/K8s） | 11.6、11.7 | `sec-distributed.4.11.7` | 交叉引用：容器/编排基础不重写 |
| Linux 书 | 第 2/3 篇（系统编程/内核） | 12.6、13.8 | `sec-distributed.5.13.8` | 背景：线程/文件/持久化只借用概念 |

### 3.5 本书自编 + 论文/规范

| 材料 | 本书落点 | 锚点 | 处理 |
|:--|:--|:--|:--|
| Raft 论文（Ongaro & Ousterhout, 2014） | 5.5–5.8、13.4–13.7 | `sec-distributed.2.5.5` | 自编讲解 + 代码；不复制论文原文/图 |
| Paxos 论文（Lamport, 1998/2001） | 5.3–5.4 | `sec-distributed.2.5.3` | 自编简化模拟器；不复制原文 |
| Dynamo 论文（DeCandia et al., 2007） | 3.7 | `sec-distributed.2.3.7` | 只引用 quorum/vector clock 思想 |
| Spanner 论文（Corbett et al., 2012） | 6.10 | `sec-distributed.3.6.10` | 只引用 TrueTime/2PC 公开结论 |
| Jepsen: MongoDB 3.4（2017） | 4.10 | `sec-distributed.2.4.10` | 只引用公开结论 + 链接 |
| Jepsen: etcd 3.4.3（2020） | 5.11、9.9 | `sec-distributed.2.5.11` | 只引用公开结论 + 链接 |
| Stripe Idempotent requests | 12.14 | `sec-distributed.5.12.14` | 只引用公开接口语义 |
| AWS S3 2017 / GitHub 2018 / Cloudflare 2019 / AWS 2021 / GitLab 2017 | 2.9、3.11、8.9、11.10、10.10 | `sec-distributed.1.2.9` | 只引用官方复盘事实 + 链接 |

> **缺口检查**：以上主题表 55 行全部有锚点；母本表中「淘汰」行不需要落点。`check_coverage.py` 只对主题表做强制校验，母本表用于人工审计。
