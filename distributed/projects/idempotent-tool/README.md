# 项目一 · 幂等工具调用后端

一个**可运行**的最小实现：HTTP + SQLite，证明「客户端超时重试」不等于「副作用执行两次」。

- 只用 Python 3.11+ 标准库，无第三方依赖；
- 幂等键 + 请求指纹 + 状态机 + 租约 + 唯一约束；
- 支持「服务端已提交、响应丢失」「提交后进程崩溃」「并发同键」三种故障；
- `python3 -m unittest` 可跑，`fault_inject.sh` 不需要 root。

## 1 快速开始

```bash
cd projects/idempotent-tool
python3 server.py --port 8081 --db /tmp/idem.db

# 另开终端
python3 client.py --base http://127.0.0.1:8081 --key demo-1 --tool charge --amount 100
python3 client.py --base http://127.0.0.1:8081 --key demo-1 --tool charge --amount 100
python3 client.py --base http://127.0.0.1:8081 --stats
```

第二次同键调用应返回同一个 `call_id`，`attempt` 仍为 1，`effects` 仍为 1。

## 2 不变量

1. `calls.idem_key` 唯一：一个键只对应一条逻辑请求；
2. `effects.call_id` 唯一：一次逻辑请求最多一条副作用；
3. 同键不同指纹 → 409，不覆盖原结果；
4. 执行中写 `lease_until`，租约过期可被接管，但副作用仍由 2 兜底；
5. 重启只重放 `pending` 或租约过期的 `running`，不重放终态。

## 3 API

| 方法 | 路径 | 说明 |
|:--|:--|:--|
| POST | `/v1/tool-calls` | 需要 `Idempotency-Key`；body：`tool`、`args`、`client_id`、`seq` |
| GET | `/v1/tool-calls/{call_id}` | 按 call_id 查询 |
| GET | `/v1/tool-calls/by-key/{key}` | 按幂等键查询 |
| GET | `/stats` | calls/effects 计数 |
| GET | `/healthz` | 健康检查 |

返回示例：

```json
{
  "call_id": "c_9f2a...",
  "status": "succeeded",
  "attempt": 1,
  "result": {"tool": "charge", "amount": 100, "effect_id": "eff_..."},
  "error": null,
  "query_url": "/v1/tool-calls/c_9f2a..."
}
```

状态：`pending → running → succeeded | failed`；超时/响应丢失时客户端进入 `unknown`，用同键查询/重试收敛。

## 4 测试

```bash
python3 -m unittest -v test_server.py
```

覆盖：

- 同键返回同一 call，副作用只一次；
- 不同键创建新 call；
- 同键不同参数 409；
- 12 并发同键只一次副作用；
- 可重试失败用同键重试；
- 提交后崩溃、重启恢复；
- 代理丢弃首个响应，同键重试收敛。

## 5 故障注入

```bash
bash fault_inject.sh --dry-run
bash fault_inject.sh --drop-response    # 丢首个响应，同键重试
bash fault_inject.sh --crash           # 提交后崩溃，重启查询
bash fault_inject.sh --concurrent      # 20 并发同键
bash fault_inject.sh --all
```

端口可用 `PORT`/`PROXY_PORT` 覆盖；脚本自己创建/清理临时 DB，不需要 root。

## 6 文件

```text
server.py        HTTP + SQLite + 状态机 + 租约 + worker
client.py        超时重试/轮询客户端
chaos_proxy.py   drop-first / drop-response / delay / duplicate
test_server.py   7 个测试
fault_inject.sh  三种故障场景
```

## 7 已知边界

- `charge` 的「副作用」用 `effects` 表模拟，没有真实外部支付；真实系统要把外部副作用也做成幂等（用 `effect_id` 作为下游幂等键）。
- 租约默认 30 s；工具执行超过租约会被回收，靠 `effects` 唯一约束保证不重复副作用。生产环境要按最长执行时间设置租约，并监控接管次数。
- SQLite 适合单机教学；多实例部署需要把去重表换成共享存储（唯一约束仍是核心）。
