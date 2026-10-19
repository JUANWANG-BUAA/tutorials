# 第 2 章实验：手写 MCP 协议栈（不依赖 SDK）

四个文件：

| 文件 | 作用 |
|:--|:--|
| `mcp_stdio_server.py` | 换行分隔 JSON-RPC 2.0 的 stdio server，支持两个协议时代 |
| `mcp_client.py` | 启动 server 子进程，按时代发请求、打印每一帧、断言关键路径 |
| `test_protocol.py` | 用 `subprocess` 直接测两个时代的握手、调用、错误与 MRTR |
| `trace-2026.jsonl` / `trace-2025.jsonl` | 客户端生成的协议帧记录，供 `jq` 观测 |

只依赖 Python 3.11+ 标准库。

## 运行

```bash
cd agent-systems

# 2026-07-28：server/discover → tools/list → tools/call → MRTR
python3 experiments/ch02/mcp_client.py --era 2026 \
  --root /tmp/ch02-mcp --trace experiments/ch02/trace-2026.jsonl

# 2025-11-25：initialize → initialized → tools/list → tools/call
python3 experiments/ch02/mcp_client.py --era 2025 \
  --root /tmp/ch02-mcp --trace experiments/ch02/trace-2025.jsonl

# 协议测试（20 条）
python3 -m unittest discover -s experiments/ch02 -v
```

`--quiet` 只打印断言汇总；`--show-stderr` 透传 server 的日志（server 只往
stderr 写日志，stdout 只写协议帧）。

## 两个时代的差别（本实验实现的部分）

| 行为 | `--era 2025` | `--era 2026` |
|:--|:--|:--|
| 握手 | `initialize` + `notifications/initialized` | 无；每个请求带 `_meta` |
| 先调 `tools/list` | `-32600`（未初始化） | 正常返回 |
| 每个请求的版本/能力 | 连接级协商一次 | `_meta.io.modelcontextprotocol/*` |
| 结果类型 | 无 `resultType` | 必带 `resultType: "complete"` |
| `server/discover` | `-32601` | 必须实现 |
| `initialize` | 正常 | `-32601`（已移除） |
| 写入确认 | 由宿主在调用前完成 | MRTR：`resultType:"input_required"` + `inputResponses` |
| 列表缓存 | 无 | `ttlMs` + `cacheScope` |
| `ping` / `logging/setLevel` | 可用 | 已移除，返回 `-32601` |
| 资源变更 | `resources/subscribe` + 通知 | 由 `subscriptions/listen` 承担（本实验未实现） |

工具集合也随时代变化：2025 只有 `fs.read`、`calc.add`；2026 多一个
`fs.write`，用来演示 MRTR 的两轮往返。

## 观测协议帧

```bash
# 每个请求的方法与 id
jq -r 'select(.dir=="send") | [.frame.id, .frame.method] | @tsv' \
  experiments/ch02/trace-2026.jsonl

# 哪些响应是 JSON-RPC 错误，错误码是什么
jq -r 'select(.dir=="recv" and .frame.error) | [.frame.id, .frame.error.code, .frame.error.message] | @tsv' \
  experiments/ch02/trace-2026.jsonl

# 工具结果里 isError 与 resultType 的分布
jq -r 'select(.dir=="recv" and .frame.result) | [.frame.result.resultType, .frame.result.isError] | @tsv' \
  experiments/ch02/trace-2026.jsonl | sort | uniq -c
```

## 边界

- 只实现 tools / resources / prompts 与少量工具方法；没有实现
  `subscriptions/listen`、tasks 扩展、HTTP 传输与 OAuth。
- JSON Schema 校验器只覆盖 `type`、`properties`、`required`、
  `additionalProperties`、`enum`、`minimum/maximum`、`minLength/maxLength`、
  `pattern`，不是完整实现。
- 2025 的握手顺序被实现成严格状态机；真实 SDK 通常更宽松，但协议要求
  客户端先完成握手。
- 这是教学件：没有并发请求、没有超时取消的真实中断、没有持久化。
