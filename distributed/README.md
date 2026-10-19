# 《分布式系统与数据面 · 从一次工具调用到可验证的一致性》

本目录是这本书的独立 mdBook 源，slug 为 `distributed`。它不复用也不修改仓库里已有的五本书，只复用 `shared/theme/` 与 `tools/` 的通用构建思路。

## 1 这本书写什么

一句话：**一次远程调用离开本机之后，数据怎么走、状态怎么复制、失败怎么被观测和验证。**

全书 5 篇 13 章：

| 篇 | 章 | 主题 |
|:--|:--|:--|
| 第 1 篇 请求与失败 | 1–2 | 请求状态机、unknown、deadline、重试、幂等、背压 |
| 第 2 篇 复制与一致 | 3–5 | 主从/多主/无主、一致性模型、Paxos 与 Raft |
| 第 3 篇 数据与消息 | 6–8 | 事务/MVCC、队列/流、对象存储/缓存/CDN |
| 第 4 篇 运行与治理 | 9–11 | 锁/租约/选主、可观测性、容量/限流/演练 |
| 第 5 篇 项目 | 12–13 | 幂等工具调用后端、三节点复制 KV |

**不写**：TCP/IP、socket、epoll、HTTP/DNS/TLS（Linux 书第 4 篇），容器与 Kubernetes 基础（Linux 书第 5 篇）。需要时只给交叉链接。

## 2 目录

```text
distributed/
├── book.toml                 mdBook 配置
├── src/
│   ├── SUMMARY.md            目录
│   ├── index.md …            卷首
│   ├── part1/ … part5/       13 章正文
│   ├── appendix/             覆盖矩阵、术语、参考、自检
│   └── assets/figures/       18 张自绘 SVG（tools/build_figures.py 生成）
├── projects/
│   ├── idempotent-tool/      项目一：幂等工具调用后端
│   └── replicated-kv/        项目二：三节点复制 KV
├── theme/                    共享主题符号链接 + distributed.css/js
├── tools/
│   ├── mathbook.py           语义盒 / 交叉引用 / 编号
│   ├── katex_wrapper.py      公式保护
│   ├── build_figures.py      生成 SVG 图版
│   ├── check_book.py         结构 / 锚点 / 链接 / 行数
│   ├── check_coverage.py     覆盖矩阵 0 缺口
│   └── check_projects.py     Python/Shell 静态检查
├── 写作规范/BRIEF.md          章节作者的共享契约
├── coverage.md               覆盖矩阵（根目录副本）
├── CHECK-distributed.md      交付自检报告
└── README.md                 本文件
```

## 3 构建

```bash
cd distributed
mdbook build .          # 产物在 book/
mdbook serve --open     # 默认 http://127.0.0.1:3000/
```

依赖：

```bash
pip3 install -r requirements.txt       # markdown-it-py
cargo install mdbook-katex --version 0.10.0
```

本书是独立站点，不需要改仓库根的 `build.sh`。若要并入总站，在根 `build.sh` 的 `books` 数组里追加 `distributed` 即可（本次不改，避免影响五本现有书）。

## 4 质检

```bash
cd distributed
python3 tools/check_book.py          # 结构 / 锚点 / 链接 / 行数
python3 tools/check_coverage.py      # 54 项主题覆盖，缺口 0
python3 tools/check_projects.py      # py_compile + bash -n
python3 -m unittest discover -s projects/idempotent-tool -p 'test_*.py'
python3 -m unittest discover -s projects/replicated-kv -p 'test_*.py'
```

`check_book.py` 对章节的硬要求：

- 1000–1400 行；
- 章首 `本章回答` / `读完你会`；
- 失败模式、观测、真实案例、重试重复副作用四节；
- 8–15 条陷阱、出口检查、母本对应、下一站；
- 代码围栏全部带语言；只用允许的语义盒；锚点唯一且符合 `*-distributed.<part>.<ch>.<n>`。

## 5 两个项目

### 项目一：幂等工具调用后端

```bash
cd projects/idempotent-tool
python3 -m unittest -v test_server.py       # 7 tests
bash fault_inject.sh --dry-run
bash fault_inject.sh --drop-response
bash fault_inject.sh --crash
bash fault_inject.sh --concurrent
```

核心：HTTP + SQLite；`Idempotency-Key` + 请求指纹 + 状态机 + 租约 + `effects.call_id UNIQUE`；丢响应、提交后崩溃、并发同键都只产生一条副作用。

### 项目二：小型复制 KV

```bash
cd projects/replicated-kv
python3 -m unittest -v test_kv.py            # 6 tests
./run_cluster.sh start                       # 7101/7102/7103
python3 kv_client.py --key foo --value bar --client-id c1 --seq 1 put
python3 kv_client.py --key foo --consistency linearizable get
bash fault_inject.sh --partition 3
bash fault_inject.sh --heal
bash fault_inject.sh --kill-leader
./run_cluster.sh stop
```

核心：简化 Raft（term、选举、AppendEntries、冲突截断、当前 term 提交、新 leader no-op）+ ReadIndex/lease/stale 三种读 + `(client_id,seq)` 去重。6 个测试覆盖选举、复制、重复写、杀主、分区、线性一致读。

## 6 图

18 张图全部自绘，源在 `tools/build_figures.py`：

```bash
python3 tools/build_figures.py
python3 tools/build_figures.py raft-states
```

每张图有 `<title>`、`<desc>`、`<figcaption>`；SVG 内部 id 以图名作前缀，保证跨文件唯一。状态机与时序图不使用现成图库，也不复制论文/产品图。

## 7 写作约定

- 中文为主，术语首次出现给英文/缩写；
- 先失败/现象，再机制，再边界与观测；
- 每个结论带条件（版本、故障模型、配置）；
- 不写「CAP 三选二」口号，给可判定定义与反例；
- 不把分布式写成微服务名词表；
- 公开案例只引用事实与链接，不复制原文；
- 代码只用 Python 标准库，服务可运行，脚本 `bash -n` 通过。

详见 `写作规范/BRIEF.md` 与 `src/appendix/checklist.md`。

## 8 已知边界

- 项目一用 SQLite 单机，真实多实例要换共享数据库；外部副作用要靠下游幂等键，本地事务不能覆盖。
- 项目二没有日志压缩、快照安装、完整成员变更；租约读依赖本地单调时钟假设。
- 压测数字来自单机回环，只代表量级，不代表生产容量。
- 本书不覆盖控制面（调度、编排、服务发现）与安全（TLS/鉴权实现）的完整细节。

## 9 交付

- `book.toml`、`src/SUMMARY.md`、13 章正文；
- `projects/` 两个可运行服务 + 测试 + 故障注入；
- 18 张 SVG 图；
- `coverage.md` / `src/appendix/coverage.md` 覆盖矩阵；
- `CHECK-distributed.md` 自检报告（构建、测试、覆盖、事实核查、回归清单）。
