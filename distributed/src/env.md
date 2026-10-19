# 实验环境与复现方式

## 1 最低配置

| 项 | 要求 | 检查命令 |
|:--|:--|:--|
| 操作系统 | macOS 13+ / Linux 5.15+ / Windows 11 + WSL2 | `uname -a` |
| Python | 3.11+（3.13 亦可） | `python3 -V` |
| SQLite | 3.35+（`BEGIN IMMEDIATE`、WAL、`RETURNING` 可用） | `python3 -c "import sqlite3;print(sqlite3.sqlite_version)"` |
| 构建 | mdBook 0.5+、mdbook-katex 0.10+ | `mdbook --version` |
| 观测工具 | `curl`、`jq`、`sqlite3`、`ss`/`lsof` | `curl --version` |
| 可选 | `wrk`/`hey`（压测）、`tc`（需要 root） | `which wrk hey tc` |

两个项目**不需要** Docker、Kubernetes、Redis、Kafka 或云账号。原因不是这些系统不重要，而是本书想让你先看清「重复、超时、分区」的最小机制；真实系统只是在同样的机制上加了更多优化。

## 2 目录

```text
distributed/
├── book.toml
├── src/                     正文与图
├── projects/
│   ├── idempotent-tool/     项目一：幂等工具调用后端
│   └── replicated-kv/       项目二：三节点复制 KV
├── tools/                   mathbook / check_book / check_coverage / check_projects
├── coverage.md              覆盖矩阵（与 src/appendix/coverage.md 同源）
├── CHECK-distributed.md     交付自检报告
└── README.md
```

## 3 构建本书

```bash
cd distributed
mdbook build .
# 产物在 book/；打开 book/index.html
```

本地预览：

```bash
mdbook serve --open
# 默认 http://127.0.0.1:3000/
```

构建依赖：

```bash
pip3 install -r requirements.txt     # markdown-it-py，供 mathbook 预处理器使用
cargo install mdbook-katex --version 0.10.0
```

质检：

```bash
python3 tools/check_book.py          # 结构、锚点、链接、盒子、行数
python3 tools/check_coverage.py      # 覆盖矩阵 0 缺口
python3 tools/check_projects.py      # py_compile + bash -n
```

## 4 运行项目一

```bash
cd projects/idempotent-tool
python3 server.py --port 8081 --db /tmp/idem.db
# 另开一个终端
python3 client.py --base http://127.0.0.1:8081 --key demo-1 --tool charge --amount 100
```

预期：

```json
{"call_id":"...","status":"succeeded","effect_id":"...","attempts":1}
```

同一把钥匙再发一次，返回同一个 `call_id`，`attempts` 不增加；换一把钥匙、同参数，得到新的 `call_id`——这两句话是项目一的核心验收。

完整测试：

```bash
python3 -m unittest -v test_server.py
bash fault_inject.sh --dry-run
bash fault_inject.sh --drop-response
```

## 5 运行项目二

```bash
cd projects/replicated-kv
./run_cluster.sh start          # 启动 3 个节点：7101/7102/7103
python3 kv_client.py status
python3 kv_client.py --key k --value v put
python3 kv_client.py --key k --consistency linearizable get
```

故障注入：

```bash
bash fault_inject.sh --dry-run
bash fault_inject.sh --partition 1          # 隔离节点 1，观察重新选主
bash fault_inject.sh --heal
bash fault_inject.sh --kill-leader
```

完整测试：

```bash
python3 -m unittest -v test_kv.py
```

## 6 端口与清理

| 项目 | 端口 | 清理 |
|:--|:--|:--|
| 项目一 | 8081 | `pkill -f idempotent-tool/server.py` |
| 项目二 | 7101–7103 | `./run_cluster.sh stop` |
| 本书预览 | 3000 | `Ctrl-C` |

端口冲突时，两个服务都支持 `--port`/`--base-port`；测试使用 `--port 0` 让内核分配临时端口。

## 7 非 root 与 root 的边界

- 项目一、项目二、`python3 -m unittest` 都**不需要 root**。
- `fault_inject.sh` 的 `--partition` 通过服务内置的 `/admin/partition` 接口实现，不需要 `iptables`；这样在 macOS 和 CI 里都能跑。
- 只有 `tc netem` 的丢包/延迟实验需要 root；脚本会先检查 `id -u`，不是 root 时打印替代命令并退出 0（`--dry-run` 永远 0）。
- 不要在生产机器上跑 `tc`/`iptables` 实验；用容器或虚拟机。

## 8 版本与可复现性

书中所有「实测输出」都来自以下环境之一：

```text
macOS 15.6 / Apple Silicon / Python 3.13.13 / SQLite 3.50.x
Ubuntu 24.04 / x86-64 / Python 3.12.x / SQLite 3.45.x
```

端口、PID、时间戳、随机数会不同；**结构化的字段名、状态迁移、错误码**应当一致。如果你的输出在字段层面不同，先检查版本，再检查是否用了 `--db` 指向旧库。

::: method 第一次运行的最小检查单
1. `python3 -V` ≥ 3.11；
2. `python3 -c "import sqlite3; print(sqlite3.sqlite_version)"` ≥ 3.35；
3. `mdbook build .` 退出码 0；
4. `python3 tools/check_book.py` 退出码 0；
5. `python3 -m unittest discover -s projects/idempotent-tool -p 'test_*.py'` 通过；
6. `python3 -m unittest discover -s projects/replicated-kv -p 'test_*.py'` 通过。
:::

> **下一站**：[三条阅读路线](roadmap.md)——按你的目标选择顺序，不必从第一页读到最后一页。
