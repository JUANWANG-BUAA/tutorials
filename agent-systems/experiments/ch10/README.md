# 第 10 章实验：最小 tracer 与回放

`tracer.py` 用纯标准库实现一个 span/trace 记录器：`contextvars` 传上下文、JSONL 输出、
虚拟时钟保证可复现。`replay.py` 读 JSONL，做三件事：校验 span 树、按记录重放
（不执行工具）、对比两次运行。`test_trace.py` 把本章的六条不变量钉成 25 个测试。

这个实验不接 OTel SDK、不发 OTLP、不做真实采样。它是一把尺子：正文里的每个概念
（parent/link、status、属性分层、断链、时钟漂移、TZ）都能在输出里找到对应字段。

## 运行

```bash
# 正常跑一遍：11 个 span，1 条 trace；JSONL 写到 /tmp，树打到 stdout
python3 experiments/ch10/tracer.py --out /tmp/ch10-trace.jsonl

# 结构校验 + 按记录重放
python3 experiments/ch10/replay.py --trace /tmp/ch10-trace.jsonl

# 制造断链：异步工具不复制 context
python3 experiments/ch10/tracer.py --break-chain --out /tmp/ch10-broken.jsonl
python3 experiments/ch10/replay.py --diff /tmp/ch10-trace.jsonl /tmp/ch10-broken.jsonl

# 制造时钟漂移：写工具所在机器慢 850ms
python3 experiments/ch10/tracer.py --worker-lag-ms 850 --out /tmp/ch10-lag.jsonl --waterfall
python3 experiments/ch10/replay.py --trace /tmp/ch10-lag.jsonl --check

# 异步投递：独立 trace，用 link 指回原 run
python3 experiments/ch10/tracer.py --followup --out /tmp/ch10-followup.jsonl

# 真实时钟（不可复现，约 2 秒）
python3 experiments/ch10/tracer.py --clock real --summary --out /tmp/ch10-real.jsonl

# 测试
python3 -m unittest discover -s experiments/ch10 -v
```

`--summary` 输出 JSON 摘要，`--json`（replay）输出机器可读结果；两者都能接 `jq`。

## 场景里的 11 个 span

| kind | name | 说明 |
|:--|:--|:--|
| `run` | `invoke_agent support` | 一次任务，根 span |
| `step` ×3 | `step 1..3` | 三个决策步 |
| `llm` ×3 | `chat gpt-4.1-mini` | 决策、决策、收尾；带 token 与成本 |
| `tool` ×2 | `kb.search`、`ticket.update` | 读工具重试一次；写工具有副作用 |
| `guard` | `guard budget` | 预算检查，记录决策与剩余额度 |
| `approval` | `approval ticket.write` | 写操作审批 |

`kb.search` 的第一次尝试超时，重试成功：span 上有一个 `retry` 事件，日志里有一条
`WARN tool.retry`。这是为了演示「span 事件」与「日志」的分工，不是装饰。

## 三个失败模式怎么复现

| 失败 | 开关 | 观测证据 |
|:--|:--|:--|
| span 断链 | `--break-chain` | `traces=2`；`execute_tool ticket.update` 成为另一条 trace 的根；`orphan_roots=1` |
| 时钟漂移 | `--worker-lag-ms 850` | 子 span `Δparent=-205ms`；`containment=1`；时长仍是 240ms |
| TZ 空值 | 测试里的 `TZ=` / `TZ=Not/AZone` | `strftime('%z') == '+0000'`，与 `TZ=Asia/Shanghai` 的 `+0800` 不同 |

断链的根因在 `run_in_thread`：正常路径 `contextvars.copy_context()` 后交给线程，
断链路径直接 `threading.Thread(target=fn)`，于是工作线程里 `_current.get()` 是 `None`，
`Tracer.span` 只能新开一条 trace。

时钟漂移的根因在 `SkewedClock`：`now_ns()` 加偏移，`advance_ms()` 推进内层时钟。
所以**时长正确、绝对时间错位**——这正是跨机器比对时间戳时会遇到的形状。

## 输出怎么读

```text
traces=1 spans=11
trace b27bc6882af7…  spans=11  start=2026-10-19T09:00:00.000+00:00
invoke_agent support  [1985ms] ok  查询退款到账时间并更新工单
   ├─ step 1  [+0ms +420ms] ok  #1
   │  └─ chat gpt-4.1-mini  [+0ms +420ms] ok  gpt-4.1-mini in=820 out=64 $0.000430
   ├─ step 2  [+420ms +300ms] ok  #2
   │  └─ execute_tool kb.search  [+0ms +300ms] ok  kb.search ok effect=read attempts=2
   └─ step 3  [+720ms +1265ms] ok  #3
      ├─ chat gpt-4.1-mini  [+0ms +610ms] ok  gpt-4.1-mini in=1240 out=72 $0.000611
      ├─ guard budget  [+610ms +5ms] ok  allow steps_remaining >= 3
      ├─ approval ticket.write  [+615ms +30ms] ok  approved by=policy:auto
      ├─ execute_tool ticket.update  [+645ms +240ms] ok  ticket.update ok effect=write attempts=1
      └─ chat gpt-4.1-mini  [+885ms +380ms] ok  gpt-4.1-mini in=1580 out=96 $0.000785
```

方括号里是 `[相对父 span 的偏移 +时长]`。`!!` 表示偏移为负——只可能来自时钟不一致
或父子时间倒挂。`annotate()` 按 kind 选字段：llm 给 token 与金额，tool 给副作用与重试次数，
guard/approval 给决策。

## 回放的三条硬边界

1. **不执行工具。** `replay.py` 不 import `tracer`，没有 `--allow-side-effects` 之外的
   执行路径；传这个参数会被拒绝（退出码 2）。
2. **结果只来自记录。** 工具结果读 `app.tool.result`，答案读 `app.answer`；重放两次，
   `tracer.SIDE_EFFECTS` 仍然只有一条（测试 `test_replay_does_not_execute_side_effects`）。
3. **结构错误不静默修复。** 孤儿、重复 `span_id`、负时长、子 span 越出父 span、无 run 根，
   逐条进 `problems`，退出码 1。有 link 的根（异步任务）不算错误。

## 虚拟时钟与可复现

`VirtualClock` 从 `2026-10-19T09:00:00Z` 起跳，只在 `advance_ms()` 时前进；ID 由
`blake2s(run_id:seed)` 派生。因此同样的参数跑两次，JSONL 逐字节相同
（`test_same_seed_same_bytes`），可以进 diff、可以当金标。真实时钟只用于观察
「一次真实运行」，不用于回归。

## 边界与常见误用

- **单进程内存 tracer**：没有 exporter、没有批量、没有背压。生产要用 OTel SDK + Collector。
- **采样只有 100%**：正文 10.4 讲的尾部采样没有在这里实现；实验只用 `--seed` 改 ID。
- **成本价目是示例**：`PRICES` 里的 0.40/1.60 美元每百万 token 不是任何厂商报价，
  只用来证明「token × 单价 → 微美元」的账能对上（1826 micros = $0.001826）。
- **时钟偏移是人为加的**：真实环境要靠 NTP/chrony 监控与 `resource.clock_offset_ms` 记录，
  本实验只是把形状做出来。
- **TZ 测试依赖 libc**：Windows 没有 `tzset`，测试会 skip；Linux/macOS 上 `TZ=` 与
  不可解析的区名都应得到 `+0000`。
- **P95 在 n=3 时没有意义**：实验输出会打印它，只为演示 `jq` 口径；尾部分位数需要样本量，
  见第 9 章。

## 与正文的对应

- 10.2 span 模型：`Span` 字段、`parent_span_id`、`links`、`kind`、`status`、`events`
- 10.3 属性：`gen_ai.*`、`app.cost.*`、`mcp.request.meta.traceparent`
- 10.4 日志：`Tracer.log` 自动注入 `trace_id/span_id`，`WARN tool.retry`
- 10.5 指标：`Tracer.summary()` 与正文的 `jq` 聚合
- 10.6 回放：`replay.py` 的 `--check` / `--replay` / `--diff`
- 10.7 失败案例：`--break-chain`、`--worker-lag-ms`、`TimezoneTest`
- 10.8 实验：全部命令与读数
