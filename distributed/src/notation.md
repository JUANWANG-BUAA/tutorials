# 符号、单位与代码约定

## 1 时间与延迟

分布式系统里最常见的错误是把不同层次的「时间」混为一谈。本书统一用下面的记号：

| 记号 | 含义 | 单位/例子 |
|:--|:--|:--|
| `t_call` | 客户端发起调用的本地时间 | 单调时钟读数 |
| `t_return` | 客户端收到响应的本地时间 | 单调时钟读数 |
| `D` | 端到端延迟，`D = t_return - t_call` | ms |
| `T` | 客户端设置的超时/deadline | ms |
| `RTT` | 一次网络往返时间 | ms |
| `s` | 服务时间（不含排队） | ms |
| `λ` | 到达率 | req/s |
| `μ` | 单副本服务率 | req/s |
| `ρ` | 利用率，`ρ = λ / (c·μ)` | 0–1 |
| `L` | 系统中平均请求数 | 个 |
| `W` | 平均停留时间，`W = L/λ` | s |

**规则一**：`D > T` 只说明客户端不再等待，不说明服务端没执行。本书把前者叫「超时」，把后者叫「失败」；两者不是同义词。

**规则二**：所有 deadline 都用**绝对时间**在进程间传递，不用「剩余多少毫秒」。原因很简单：剩余时间在每一跳都会因为排队而变短，接收方无法判断发送方已经等了多久。

**规则三**：不要把墙上时钟（wall clock）用于计算超时或顺序。墙上时钟会被 NTP 调整，可能倒退；超时用单调时钟（`time.monotonic()` / `CLOCK_MONOTONIC`）。

## 2 失败模型

本书只用三种失败模型，出现更复杂的模型会明确标注：

| 记号 | 名称 | 允许的失败 | 典型系统 |
|:--|:--|:--|:--|
| `C` | crash-stop | 进程崩溃后不再恢复 | 理论分析、简单选主 |
| `C-R` | crash-recovery | 崩溃后重启，持久化状态保留、内存状态丢失 | 大多数数据库、Raft 节点 |
| `N` | 网络分区/异步 | 消息可丢、可重复、可乱序、可延迟任意长；节点不一定崩溃 | 跨机房系统 |
| `B` | Byzantine | 节点可能发送错误消息 | 区块链；本书只提一句 |

**默认模型是 `C-R + N`**：节点会崩溃重启，网络会分区、会重复、会乱序，但节点不会伪造消息。凡是依赖「消息一定到达」「时钟一定同步」「节点不会同时暂停」的结论，都会在正文里标出假设。

## 3 请求与状态

| 记号 | 含义 |
|:--|:--|
| `req` | 一次逻辑请求，由 `(client_id, seq)` 唯一标识 |
| `key` | 幂等键，客户端生成，同一逻辑请求重试时必须复用 |
| `fp` | 请求指纹，对方法、路径、关键参数做规范化哈希 |
| `attempt` | 一次物理尝试；同一 `req` 可以有多次 `attempt` |
| `state ∈ {pending, running, succeeded, failed, unknown}` | 请求/幂等记录的状态 |
| `lease_until` | 租约到期时间（绝对时间） |
| `fence` | fencing token，单调递增，用来挡住过期持有者 |
| `commit_index` | 日志/复制组已提交位置 |
| `applied_index` | 状态机已应用位置 |
| `read_index` | 线性一致读需要等待达到的提交位置 |

`unknown` 是本书特别强调的状态：它表示「客户端不知道服务端是否执行」。在 UI 上它通常被折叠成「失败」，在协议上它必须被单独处理。

## 4 一致性与事务

| 记号 | 含义 |
|:--|:--|
| `W` / `R` | 写 quorum / 读 quorum |
| `N` | 副本数 |
| `R + W > N` | 读写 quorum 相交，读至少能看到一个最新写 |
| `lin` | 线性一致（linearizable） |
| `seq` | 顺序一致（sequentially consistent） |
| `causal` | 因果一致 |
| `eventual` | 最终一致 |
| `SI` | 快照隔离（snapshot isolation） |
| `SSI` | 可串行化快照隔离（serializable snapshot isolation） |
| `2PC` | 两阶段提交 |

注意：`W + R > N` 只保证「读到的集合与写入的集合相交」，不自动保证线性一致。第 4 章会说明还需要哪些条件（写必须是最新已提交、读必须等待修复、不能有脏读等）。本书不会把 quorum 相交当成线性一致的充分条件。

## 5 代码约定

- 语言：Python 3.11+，只用标准库（`http.server`、`sqlite3`、`threading`、`urllib`、`unittest`、`json`、`hashlib`、`time`）。
- 服务端口默认 `127.0.0.1`，避免暴露到公网；测试用临时端口。
- 每个代码块标注语言：`python`、`bash`、`sql`、`json`、`text`、`http`。
- 伪代码用 `text`，不要伪装成可运行代码。
- 错误处理不能省：捕获具体异常，记录 `request_id`，返回结构化错误。
- 脚本开头 `set -euo pipefail`；需要 root 的命令前标 `sudo` 并给清理命令。
- 不把长代码墙贴进正文：核心函数 20–80 行，完整文件放 `projects/`，正文给路径和行号。

## 6 锚点与交叉引用

本书的锚点采用统一命名：

```text
sec-distributed.<part>.<chapter>.<section>     小节
def-distributed.<part>.<chapter>.<n>           定义
thm-distributed.<part>.<chapter>.<n>           定理/保证
ex-distributed.<part>.<chapter>.<n>            案例/练习
method-distributed.<part>.<chapter>.<n>        方法/清单
errata-distributed.<part>.<chapter>.<n>        误解/陷阱
note-distributed.<part>.<chapter>.<n>          边注
```

`<part>` 是篇号 1–5，`<chapter>` 是全书章号 1–13。例如第 5 章（第 2 篇）第 3 节的锚点是 `sec-distributed.2.5.3`。这样即使章节在篇内移动，锚点仍然可读；所有锚点由 `tools/check_book.py` 检查唯一性。

## 7 代码清单的读法

书中出现下面这种清单时，表示「这段代码在仓库里的位置」：

```text
projects/idempotent-tool/server.py
  ├─ class CallStore        持久化与状态迁移
  ├─ class ToolRunner       工具执行与副作用
  └─ class Handler          HTTP 契约
```

路径相对于本书根目录 `distributed/`。运行命令默认也在该目录下执行。

::: note 关于「行号」
正文引用的行号以交付时的文件为准；如果你在本地改过代码，行号会漂。优先按函数名搜索，不要死记行号。
:::

> **下一站**：[实验环境](env.md)——把端口、依赖和清理命令一次配好。
