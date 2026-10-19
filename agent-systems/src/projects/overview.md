# 项目总览与验收路线

## 1. 为什么要做两个项目

前 12 章把机制拆开讲，每章一个实验。拆开的好处是聚焦，坏处是**层与层之间的接缝**没人负责：runner 的超时会不会把 trace 写坏？工具协议的错误码能不能被评估集统计？沙箱拒绝 egress 后，agent 的规划会不会陷入重试？

两个项目就是来补接缝的：

| 项目 | 压什么 | 不做什么 |
|:--|:--|:--|
| [项目一 · 可沙箱执行的代码 agent](../part4/ch13.md) | 第 1–4、10、11 章：循环、工具、沙箱、权限、trace、红队 | 不做通用 IDE、不做多语言支持、不做云部署 |
| [项目二 · 带评估集的工具调用平台](../part4/ch14.md) | 第 2、9、10、12 章：注册表、评估集、统计、门禁、审计 | 不做模型训练、不做排行榜、不做前端大屏 |

两个项目共享同一套工具契约与 trace 字段，所以项目二可以直接评估项目一的 agent。你可以只做一个，但两个都做的收益大于「1+1」：项目一提供真实失败样本，项目二提供回归证据。

## 2. 代码在哪

完整实现放在仓库的两个目录，正文只摘关键 20–40 行：

```text
projects/
  code-agent/
    README.md
    agent/            # loop、state、tools、policy
    sandbox/          # runner、limits、fs/network policy
    tests/            # 单元 + 红队
    run_demo.py
  eval-platform/
    README.md
    platform/         # registry、executor、runner
    evalsets/         # 版本化 JSONL
    stats/            # CI、配对检验、门禁
    report.py
```

每个项目都能用一条命令跑通；不依赖外部 API，默认使用确定性策略或本地 mock 模型。要接真模型时，只替换 `policy` 适配器（第 1.7.5 节）。

## 3. 验收路线

### 项目一：代码 agent

下表中的 `...` 表示沿用上一行 `python3 -m unittest discover -s projects/code-agent/tests` 的前缀；每一行都应在 `agent-systems/` 下运行。

| Stage | 交付 | 验收命令 | 达标线 |
|--:|:--|:--|:--|
| 1 | loop + 状态 + trace | `python3 -m unittest discover -s projects/code-agent/tests -p 'test_loop.py'` | 正常任务 3–6 步完成；trace 每步可解析 |
| 2 | 工具协议 + 校验 | `... -p 'test_tools.py'` | 非法参数被拒；未知工具可见；结果结构化 |
| 3 | 沙箱 runner | `... -p 'test_sandbox.py'` | 超时杀进程组；输出截断；临时根不可逃逸 |
| 4 | 文件/网络策略 | `... -p 'test_tools.py'` | 越界写入拒绝；egress 默认拒绝；DNS 固定 |
| 5 | 观测/回放 | `python3 projects/code-agent/run_demo.py --replay` | 同输入 replay 得到同 trace 结构 |
| 6 | 红队 | `... test_redteam.py` | 注入、路径穿越、资源耗尽用例全过 |

### 项目二：评估平台

下表中的 `...` 表示沿用上一行 `python3 -m unittest discover -s projects/eval-platform/tests` 的前缀。

| Stage | 交付 | 验收命令 | 达标线 |
|--:|:--|:--|:--|
| 1 | 工具注册表 | `python3 -m unittest discover -s projects/eval-platform/tests -p 'test_platform.py'` | schema 校验、版本、权限字段齐全 |
| 2 | 执行器 | `... -p 'test_platform.py'` | 超时/错误/重试可观测；不重复副作用 |
| 3 | 评估集 | `... -p 'test_platform.py'` | 版本固定；分层；污染检查 |
| 4 | 统计 | `... -p 'test_stats.py'` | bootstrap CI 覆盖率符合预期；配对检验可复现 |
| 5 | 门禁 | `... -p 'test_gate.py'` | 回归被拦截；可通过 `--force` 留痕放行 |
| 6 | 报告 | `python3 projects/eval-platform/report.py --run latest` | 含 CI、成本、P95、失败样本 |

这张表说明什么：每个 Stage 都有**可执行**的验收，不靠「看起来完成」。如果某个 Stage 的测试写不出来，说明接口还没设计清楚，先回去改接口。

## 4. 共同约定

### 4.1 工具契约

两个项目使用同一份字段（第 1.4 节）：

```json
{
  "name": "fs.read",
  "description": "读取工作区文件",
  "input_schema": {"type": "object", "properties": {"path": {"type": "string"}}, "required": ["path"], "additionalProperties": false},
  "preconditions": ["path is inside workspace"],
  "effect": "read",
  "idempotency": "idempotent",
  "cost": {"latency_p95_ms": 20, "quota": "fs:1000/run"},
  "auth_scope": "workspace:read"
}
```

### 4.2 trace 字段

两个项目共用：

| 字段 | 类型 | 说明 |
|:--|:--|:--|
| `run_id` | string | 一次运行 |
| `task_id` | string | 一个可验收任务 |
| `step` | int | 步号 |
| `span_id` / `parent_span_id` | string | 调用树 |
| `tool` | string | 工具名 |
| `args_hash` | string | 参数哈希（不存原文） |
| `ok` | bool | 执行是否成功 |
| `error_code` | string? | 结构化错误码 |
| `duration_ms` | int | 耗时 |
| `budget_left` | object | 剩余预算 |
| `world_version` | string | 世界版本（git SHA / etag） |

### 4.3 失败样本

两个项目都把失败样本写入 `evalsets/failures.jsonl`，字段与评估集一致。新失败样本必须附：最小复现输入、期望行为、实际 trace、根因分类（循环/工具/沙箱/上下文/评估/安全）。没有这五项，不算一条可回归的样本。

## 5. 建议顺序

1. 先做项目一的 Stage 1–3，跑通「任务 → 工具 → 沙箱 → trace」。
2. 切到项目二的 Stage 1–3，把项目一的工具注册进去，建立评估集。
3. 回项目一做 Stage 4–6，把红队样本加入项目二的评估集。
4. 做项目二的 Stage 4–6，让门禁能拦截项目一的回归。

这个顺序的好处是：你不会在没有评估的情况下把项目一做得很复杂，也不会在没有真实失败样本的情况下把项目二做成空架子。

## 6. 交付清单

两个项目都完成后，你应该能演示：

```bash
# 1) 项目一：跑一个真实小任务，展示 trace
python3 projects/code-agent/run_demo.py --task fix-off-by-one --trace /tmp/p1.jsonl

# 2) 项目二：用评估集跑项目一，出报告
python3 projects/eval-platform/report.py --suite code-agent-v1 --runs 5

# 3) 门禁：注入一个回归，确认被拦截
python3 projects/eval-platform/gate.py --suite code-agent-v1 --candidate ./candidate.json
```

三条命令都能跑通、输出可解释，才算项目完成。演示时不要只放最终答案；打开 trace，指出哪一步是决策、哪一步是工具、哪一步是沙箱拒绝。
