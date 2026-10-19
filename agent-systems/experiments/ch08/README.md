# 第 8 章实验：supervisor + 2 workers 的预算控制

这个实验把多智能体的四个机制压成一个无依赖、确定性的内核：

- **共享预算账本**：`BudgetLedger.try_spend` 在同一个锁里完成「检查父子额度 + 扣减」，子额度之和不得超过父预算。
- **消息总线**：每条消息有 `seq`、`correlation_id`、`causation_id`、`refs` 与 `tokens`；消费者用 `deliver()` 做重复投递去重。
- **冲突处理**：先看票数与来源独立性，再看证据权重；全票但只有一个低可信来源时，用一手证据覆盖。
- **熔断与环检测**：预算耗尽或失败达到阈值时打开熔断；从 `handoff`/`confirm` 边检测等待环。

不依赖网络、真实模型或第三方库。所有金额、置信度、证据权重都是固定输入。

## 运行

```bash
# 正常：两个 worker 来源不同，1:1 平票由证据权重裁决
python3 experiments/ch08/multi_agent.py --mode normal --log /tmp/ch08-normal.jsonl

# 群体幻觉：两个 worker 复制同一个提示与同一份旧 runbook
python3 experiments/ch08/multi_agent.py --mode groupthink --log /tmp/ch08-groupthink.jsonl

# 无限对话：两个 worker 互相等待确认，直到额度拒绝下一次发送
python3 experiments/ch08/multi_agent.py --mode runaway --log /tmp/ch08-runaway.jsonl

# 离线分析消息日志：每个 agent 的消息数、token、失败率与消息环
python3 experiments/ch08/multi_agent.py --analyze /tmp/ch08-runaway.jsonl
```

三种模式都返回 0，失败模式通过 `stop_reason`、`cycle` 与 `breaker` 字段表达，方便脚本比较。

## 期望结果

| 模式 | answer | 关键字段 | 预算 |
|:--|:--|:--|:--|
| `normal` | `10s` | `decision=evidence_weight`，票数 1:1 | 120/300 |
| `groupthink` | `10s` | 票数 2:0 但 `decision=evidence_override` | 120/300 |
| `runaway` | `null` | `stop_reason=budget_exhausted`，`cycle=worker-a→worker-b→worker-a` | 234/300 |

`groupthink` 的重点不是「模型答错」，而是**投票的独立性假设被破坏**：两个 worker 引用同一条 `doc/legacy-2024`，票数一致并不提供新信息。`runaway` 的重点不是「消息发不出去」，而是**全局还剩 66 token，但 worker-a 的个人额度只剩 10**，所以下一次 25 token 的发送被拒绝——预算必须按 agent 封顶，不能只看总数。

## 测试

```bash
python3 -m unittest discover -s experiments/ch08 -v
```

11 个测试覆盖：

- 子预算之和超过父预算时构造失败；
- 8 个线程并发扣减不超卖；
- 重复投递只产生一次副作用；
- `seq` 连续、`causation_id` 指向上一条消息；
- 平票由证据权重裁决；
- 全票群体幻觉被一手证据覆盖；
- 独立来源的多数票获胜；
- 熔断阈值触发并阻止后续派活；
- normal 预算守恒且无环；
- runaway 在预算耗尽时停止并检出环；
- 自环检测。

## 文件

- `multi_agent.py`：实现与 CLI。
- `test_multi_agent.py`：单元测试。

## 刻意限制

1. `tokens` 是简化的记账单位，一条消息的 `tokens` 包含「生产这条消息的模型回合 + 总线开销」，不是真实 tokenizer 计数。
2. worker 的行为是确定性函数，不存在采样方差；它用来钉住失败模式，不用来评估模型能力。
3. 总线是进程内的，`seq` 是单总线全序。跨进程或跨机时，应改成 per-sender 序号 + `causation_id`，并用外部账本或 CAS 保证预算原子性。
4. 熔断只有 `closed/open` 两态；生产实现还应加 `half-open` 探测、冷却时间与按能力（而非按 agent）隔离。
