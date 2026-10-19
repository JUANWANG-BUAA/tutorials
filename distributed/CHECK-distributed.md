# CHECK-distributed：交付自检与事实核查

> 对象：`distributed/`（《分布式系统与数据面 · 从一次工具调用到可验证的一致性》）
> 时间：2026-10-19
> 环境：macOS 15.6 / Apple Silicon / Python 3.13.13 / SQLite 3.50.x / mdBook 0.5.4 / mdbook-katex 0.10.0
> 性质：只读自检；所有命令在本目录执行，结果可复现。

## 1 结论先读

| 门禁 | 结果 | 证据 |
|:--|:--|:--|
| `mdbook build .` | **0** | `book/` 生成，28 个 HTML 页面；仅 mathbook 的「未引用锚点」提示，无错误 |
| `python3 tools/check_book.py` | **0** | 25 页、16,734 行；0 问题、0 断链、0 断锚点、0 重复锚点 |
| `python3 tools/check_coverage.py` | **0** | 55/55 主题、255 个锚点、0 缺口 |
| `python3 tools/check_projects.py --run` | **0** | 项目一 7 tests OK；项目二 6 tests OK；`bash -n` 全过 |
| 故障注入脚本 | **可执行** | 两个 `fault_inject.sh --dry-run` 均 0；实际场景已跑 |
| 章数 / 篇幅 | **13 章 / 15,574 行** | 每章 1,010–1,310 行，全部在 1000–1400 内 |
| 图 | **18 张 SVG** | 自绘，`<title>/<desc>/<figcaption>` 齐全，id 无重复 |

**没有遗留的构建错误、结构错误、覆盖缺口或项目测试失败。** 未改仓库现有五本书、根 `build.sh`、`shared/` 或根 `site-index.html`。

## 2 章节与篇幅

| 章 | 文件 | 行数 | H2 | 图 | 失败模式 |
|--:|:--|--:|--:|:--|:--|
| 1 | `src/part1/ch01.md` | 1015 | 14 | request-path / request-state / timeout-truth | 超时 |
| 2 | `src/part1/ch02.md` | 1294 | 14 | retry-budget + ASCII | 超时 + 重试风暴 |
| 3 | `src/part2/ch03.md` | 1310 | 15 | replication-topologies / quorum | 分区 |
| 4 | `src/part2/ch04.md` | 1222 | 15 | linearizability | 分区陈旧读 |
| 5 | `src/part2/ch05.md` | 1176 | 16 | raft-states / raft-election | 分区旧主 |
| 6 | `src/part3/ch06.md` | 1249 | 15 | mvcc | 重复（重试） |
| 7 | `src/part3/ch07.md` | 1198 | 14 | log-offsets | 重复 + 乱序 |
| 8 | `src/part3/ch08.md` | 1161 | 14 | cache-path | 陈旧 + 回源风暴 |
| 9 | `src/part4/ch09.md` | 1204 | 14 | fencing | 重复（锁过期） |
| 10 | `src/part4/ch10.md` | 1244 | 15 | trace-waterfall | 重复 span / 观测盲区 |
| 11 | `src/part4/ch11.md` | 1243 | 15 | utilization | 过载 + 重试风暴 |
| 12 | `src/part5/ch12.md` | 1010 | 18 | idempotency-state | 重复（丢响应） |
| 13 | `src/part5/ch13.md` | 1248 | 18 | kv-replication / kv-readindex | 分区旧主 |

合计 **15,574 行**（不含卷首/附录）。每章都有：章首 `本章回答/读完你会`、失败模式、观测命令、真实案例、重试重复副作用、8–15 条陷阱、出口检查、母本对应、下一站。

## 3 构建与结构检查

```bash
cd distributed
mdbook build .                 # exit 0
python3 tools/check_book.py    # exit 0
```

`check_book.py` 的实际输出：

```text
pages: 25   total lines: 16734

OK
```

`--verbose` 的页面行数：

```text
part1/ch01.md 1015   part1/ch02.md 1294   part2/ch03.md 1310
part2/ch04.md 1222   part2/ch05.md 1176   part3/ch06.md 1249
part3/ch07.md 1198   part3/ch08.md 1161   part4/ch09.md 1204
part4/ch10.md 1244   part4/ch11.md 1243   part5/ch12.md 1010
part5/ch13.md 1248
```

构建日志里唯一的提示是：

```text
mathbook: 提示 — 71 个锚点未被任何 [@ref] 引用
```

这不是错误。本书的跨引用主要用普通 Markdown 链接（`ch02.md` / `../part2/ch03.md`），没有大量使用 `[@id]` 语法；未引用锚点不会导致构建失败，已由 `check_book.py` 的锚点/链接检查覆盖。

## 4 覆盖矩阵

```bash
python3 tools/check_coverage.py
```

```text
required topics: 55   found: 55   anchors: 255

OK
```

覆盖矩阵有两份同源文件：

- `src/appendix/coverage.md`（书中页面）；
- `coverage.md`（交付根目录副本，`diff -q` 为 0）。

矩阵包含 55 项主题和 5 组母本映射（谢希仁、张彦飞、《Python 网络编程》、《Linux 系统与内核》、本书自编 + 论文/规范）。「淘汰」行不需要锚点，其余每行都有可跳转锚点。

## 5 项目测试

### 5.1 项目一：幂等工具调用后端

```bash
python3 -m unittest discover -s projects/idempotent-tool -p 'test_*.py'
```

```text
Ran 7 tests in 1.916s
OK
```

覆盖：同键返回同一 call、不同键新建、同键不同参 409、12 并发同键一条 effect、可重试失败重试、提交后崩溃恢复、代理丢首个响应后同键收敛。

实际故障注入：

```bash
bash fault_inject.sh --drop-response   # effects=1
bash fault_inject.sh --crash           # 重启后 succeeded, effects=1
bash fault_inject.sh --concurrent      # 20 并发, effects=1
```

### 5.2 项目二：小型复制 KV

```bash
python3 -m unittest discover -s projects/replicated-kv -p 'test_*.py'
```

```text
Ran 6 tests in 4.056s
OK
```

覆盖：选举 + 写入 + 线性一致读、follower 陈旧读、同 `(client_id,seq)` 重复写只应用一次、连续写后 ReadIndex、kill leader 保留已提交值、分区旧 leader 线性一致读 503 / 新 leader 仍读到旧值。

实际故障注入：

```bash
bash fault_inject.sh --partition 3     # 隔离节点；多数派侧重新选主
bash fault_inject.sh --heal
bash fault_inject.sh --kill-leader     # 新 leader 选出
bash fault_inject.sh --all
```

### 5.3 Shell 与静态检查

```bash
python3 tools/check_projects.py --run
```

```text
python files: 7   shell files: 3
OK
```

所有 `.sh` 通过 `bash -n`；所有 `.py` 通过 `py_compile`；两个 `fault_inject.sh --dry-run` 退出码 0。

## 6 事实核查

| 案例 | 章 | 本书使用的公开事实 | 来源 |
|:--|--:|:--|:--|
| Knight Capital | 1 | 2012-08-01，约 45 分钟，约 4.4 亿美元损失，8 台服务器 7 台更新，SEC 2013 年 1200 万美元罚款（Rule 15c3-5） | SEC press release 2013-222；公开报道 |
| AWS S3 | 2 | 2017-02-28，us-east-1，授权人员命令参数错误，索引/放置子系统受影响，重启 + 缓存重建 + 重试放大，约 4 小时 | <https://aws.amazon.com/message/41926/> |
| GitHub | 3 | 2018-10-21，约 43 秒网络分区触发 MySQL 故障切换，约 24 小时 11 分钟降级，暂停写入/降级保证一致性 | <https://github.blog/news-insights/company-news/oct21-post-incident-analysis/> |
| Jepsen MongoDB | 4 | 2017-02-07；v0 4525 次插入 / 322 保留 / 93 已确认后丢失；v1 6078 / 932 / 417；3.2.12 与 3.4.0 修复 | <https://jepsen.io/analyses/mongodb-3-4-0-rc3> |
| Jepsen etcd | 5 | 2020-01-30；etcd 3.4.3；KV 读/写/事务严格可串行化；watch 按序；锁不保证互斥（lease 复查 bug） | <https://jepsen.io/analyses/etcd-3.4.3> |
| Spanner | 6 | 2012 论文；TrueTime + 2PC；外部一致性；不是「零延迟强一致」 | <https://research.google/pubs/pub39966/> |
| LinkedIn Kafka | 7 | 2019-10-08；100+ 集群、4000+ broker、10 万+ topic、700 万分区、7 万亿条/天 | LinkedIn Engineering 博客（2019） |
| Cloudflare | 8 | 2019-07-02；WAF 正则灾难性回溯；边缘 CPU 打满；约 27 分钟；simulate 模式仍有成本 | <https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/> |
| Redlock 辩论 | 9 | 2016-02-08 Kleppmann 文章；antirez 回应；争点是进程暂停/时钟假设与 fencing | <https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html>；<http://antirez.com/news/101> |
| GitLab | 10 | 2017-01-31；约 300 GB 数据被删；5 道备份/恢复机制未提供可用恢复点；回到约 6 小时前快照 | <https://about.gitlab.com/blog/2017/02/10/postmortem-of-database-outage-of-january-31/> |
| AWS us-east-1 | 11 | 2021-12-07；内部网络自动化活动触发非预期行为；网络设备拥塞；控制面/多项服务受影响；停止自动化并逐步恢复 | <https://aws.amazon.com/message/12721/> |
| Stripe | 12 | 客户端提供 `Idempotency-Key`；同键重试返回原结果；同键不同参报错；key 有保留期限 | <https://docs.stripe.com/api/idempotent_requests> |
| etcd ReadIndex | 13 | leader 记录 readIndex，向多数派确认 leadership，再等 applied 追上；lease read 依赖时钟；stale read 允许旧值 | etcd 官方文档 / ReadIndex 设计 |

### 6.1 一处已修正的事实问题

初稿的 `BRIEF.md` 和 `src/appendix/references.md` 曾把 Jepsen 的 etcd 分析写成「3.3 / 2018」，链接 `https://jepsen.io/analyses/etcd-3-3-0` 实际返回 404。核查后改为：

- 版本 **etcd 3.4.3**；
- 时间 **2020-01-30**；
- 链接 **<https://jepsen.io/analyses/etcd-3.4.3>**；
- 结论按公开报告：KV 严格可串行化、watch 按序、锁不保证互斥（lease 复查 bug + 分布式锁本质）。

已同步修改 `src/part2/ch05.md` 的节标题/正文、`src/appendix/references.md`、`写作规范/BRIEF.md`、`src/appendix/coverage.md`。**没有再保留 3.3 的结论或旧链接。**

## 7 前作错误回归清单

用户列出的五个前作错误，本书逐项检查：

| # | 前作错误 | 本书出现次数 | 说明 |
|--:|:--|--:|:--|
| 1 | 使用 6.8 已不存在的 `request_sock_queue` 字段 | **0** | 本书不重写内核连接队列；需要时只链接 Linux 书 4.5/4.11 |
| 2 | LAST-ACK 收 ACK 画到 TIME-WAIT | **0** | 本书不画 TCP 状态机；无 LAST-ACK/TIME-WAIT 迁移图 |
| 3 | MSS/窗口缩放「双方取 min」 | **0** | 本书不写 MSS/窗口协商；只引用 TCP 事实 |
| 4 | SACK 长度写 10+8n | **0** | 本书不写 SACK 选项格式 |
| 5 | `conntrack -C` 当 NAT 连接数、`[ASSURED]` 说反 | **0** | 本书不写 conntrack |

核查命令与结果：

```bash
for pat in request_sock_queue inet_csk_reqsk_queue LAST-ACK LAST_ACK \
           MSS SACK 窗口缩放 conntrack ASSURED; do
  echo "== $pat"; grep -RIn "$pat" src/part* src/appendix | head
done
# 全部无输出
```

这不是「本书比前作更懂 TCP」，而是**本书明确不重写这部分**：TCP/IP、socket、epoll、HTTP/DNS/TLS 归 Linux 书第 4 篇；容器/K8s 归第 5 篇。本书只在需要解释「请求离开本机之后」时交叉引用。

## 8 不重复检查

| 不应重写的内容 | 本书处理 | 证据 |
|:--|:--|:--|
| TCP 三次握手/四次挥手/状态机 | 只引用 | `grep -R "三次握手\|TIME_WAIT" src/part*` 仅出现在背景表/观测 |
| TCP 可靠传输/拥塞控制 | 不写 | 无 RTO/慢启动/CUBIC/BBR 实现段 |
| socket/epoll/连接队列 | 只引用 | 项目用 Python 标准库 HTTP server，不实现事件循环 |
| HTTP/DNS/TLS | 只引用 | 无 HTTP 报文解析、TLS 握手、DNS 递归解析段 |
| 容器/K8s 基础 | 只引用 | 无 namespace/cgroup/OCI/K8s 原语教程 |
| CAP 口号 | 明确反驳 | 4.6 给定义、反例、PACELC；无「三选二」推荐 |

## 9 已知边界与未实测项

| 项 | 状态 | 说明 |
|:--|:--|:--|
| `etcdctl` / `psql` / `kafka-consumer-groups.sh` 示例 | **未在本机启动对应产品** | 命令与输出按官方语义编写；不作为本机实测结果 |
| `tc netem` / `iptables` 命令 | **未执行** | 需要 root/Linux；第 11 章给出 `tc -s qdisc` 观测与 `bash -n` 通过的注入脚本 |
| 项目一 SQLite 单机 | 已实测 | 多实例部署需换共享数据库；外部副作用需下游幂等 |
| 项目二简化 Raft | 已实测 | 无日志压缩、快照安装、完整成员变更；lease 读是演示，不是线性一致替代 |
| 压测数字 | 本机实测 | 300 请求、20 并发、单机回环；只代表量级，不代表生产容量 |
| 跨书绝对链接 | 已核对目标 | 8 个 `/tutorials/linux/...` 目标在 `_site/linux/` 存在；本次未重新构建总站 |

## 10 交付文件

```text
distributed/
├── book.toml
├── README.md
├── coverage.md
├── CHECK-distributed.md
├── requirements.txt
├── src/
│   ├── SUMMARY.md
│   ├── index.md / preface.md / scope.md / notation.md / env.md
│   ├── roadmap.md / objectives.md / entry-test.md
│   ├── part1/ch01.md ch02.md
│   ├── part2/ch03.md ch04.md ch05.md
│   ├── part3/ch06.md ch07.md ch08.md
│   ├── part4/ch09.md ch10.md ch11.md
│   ├── part5/ch12.md ch13.md
│   ├── appendix/coverage.md glossary.md references.md checklist.md
│   └── assets/figures/*.md（18 张 SVG）
├── projects/
│   ├── idempotent-tool/（server/client/proxy/tests/fault_inject/README）
│   └── replicated-kv/（node/client/tests/run_cluster/fault_inject/README）
├── theme/（共享符号链接 + distributed.css/js）
├── tools/（mathbook/katex_wrapper/build_figures/check_book/check_coverage/check_projects）
└── 写作规范/BRIEF.md
```

## 11 复现命令

```bash
cd distributed
pip3 install -r requirements.txt
mdbook build .
python3 tools/check_book.py
python3 tools/check_coverage.py
python3 tools/check_projects.py --run
bash projects/idempotent-tool/fault_inject.sh --dry-run
bash projects/replicated-kv/fault_inject.sh --dry-run
```

六个门禁都应为 0 / OK。若任何一项非 0，先按输出定位，不要用「重跑一次」掩盖时序问题。
