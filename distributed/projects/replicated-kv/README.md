# 项目二 · 小型复制 KV（一致性读）

三个 Python 进程组成的复制 KV，用来把「选举、日志复制、提交、线性一致读、去重」压成可运行的代码。

- 简化 Raft：term、随机选举超时、RequestVote、AppendEntries、prevLogIndex/term、冲突截断、多数派提交、当前 term 提交规则；
- 新 leader 追加 no-op，提交后才能安全推进 commitIndex、应用旧 term 已提交项；
- 线性一致读：ReadIndex（心跳确认多数派 + 等 applied 追上）；
- 租约读：leader lease 内本地读；陈旧读：任意节点本地读；
- 客户端按 `(client_id, seq)` 去重；
- 故障注入：`/admin/partition` 双向阻断 peer RPC，不需要 root。

## 1 快速开始

```bash
cd projects/replicated-kv
./run_cluster.sh start          # 7101/7102/7103
python3 kv_client.py status
python3 kv_client.py --key foo --value bar --client-id c1 --seq 1 put
python3 kv_client.py --key foo --consistency linearizable get
python3 kv_client.py --key foo --consistency stale get
./run_cluster.sh stop
```

注意全局参数放在子命令前：`kv_client.py --key foo --value bar put`。

## 2 一致性读

| `consistency` | 谁可以服务 | 机制 | 失败时 |
|:--|:--|:--|:--|
| `linearizable` | 仅 leader | 记录 commitIndex；向多数派发心跳确认 leadership；等 applied ≥ readIndex | 503 `no_quorum`/`apply_lag` |
| `lease` | 仅 leader | lease 未过期且 applied ≥ commitIndex 时本地读 | 503 `lease_expired` |
| `stale` | 任意节点 | 本地 applied 状态读，返回 `stale=true` | 可能读到旧值 |

## 3 测试

```bash
python3 -m unittest -v test_kv.py
```

覆盖：

- 选举 + 写入 + 线性一致读；
- follower 陈旧读；
- 同 `(client_id, seq)` 重复写只应用一次；
- 连续写后立即线性一致读；
- kill leader 后新 leader 保留已提交值；
- 分区旧 leader：线性一致读 503，多数派选新 leader 后仍读到已提交值。

## 4 故障注入

```bash
bash fault_inject.sh --dry-run
bash fault_inject.sh --partition 3     # 隔离节点 3（若它是 leader，观察 503）
bash fault_inject.sh --heal
bash fault_inject.sh --kill-leader
bash fault_inject.sh --all
```

`/admin/partition` 只在教学/测试使用，生产不能暴露。

## 5 文件

```text
raft_node.py      节点：选举、复制、提交、ReadIndex、SQLite 状态机
kv_client.py      客户端：307 跟随、put/get/status/partition
test_kv.py        6 个测试
run_cluster.sh    三节点启停
fault_inject.sh   分区/恢复/杀 leader
```

## 6 已知边界

- 只支持单 key put/get，没有范围查询、快照安装、成员变更；
- 日志不压缩，长期运行会增长；
- 租约读依赖单调时钟与 leader lease 的本地假设；跨机器时钟/GC 停顿的完整讨论见第 9 章；
- 客户端去重只覆盖 `(client_id, seq)`；同键不同参数目前会返回旧结果，生产应加指纹并返回 409（参考项目一）。
- 三节点、单机回环；跨机房延迟/分区需要真实网络环境验证。
