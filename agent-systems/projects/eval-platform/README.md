# 项目二 · 带评估集的工具调用平台

一个能把「改版是否更好」变成可回滚决定的最小平台：工具注册表、执行器、版本化评估集、多次采样、置信区间、配对检验、回归门禁、成本/延迟报告。

## 能力

- 工具注册表：版本、schema、scope、成本与延迟模型；重复注册/版本错配/越权都拒绝
- 执行器：校验、超时、重试、结构化错误；只对可重试错误重试
- 评估集：27+3 条确定性样本、JSONL、版本哈希（12 位）、难度/标签分层
- runner：同一评估集跑 N 次采样，记录 attempts/cost/latency/error_code
- 统计：Wilson 区间、bootstrap CI、配对 bootstrap、pass@k
- 门禁：质量下界、broken 数、成本比、P95 比、安全回归；`--force` 留痕
- 报告：Markdown 表 + JSON；失败样本按错误码聚合

## 运行

```bash
cd projects/eval-platform

# 基线 vs 重试候选，输出报告与门禁
python3 report.py --suite tool-calling-v1 --runs 2 --gate --audit /tmp/audit.jsonl

# 模拟工具 v2 回归：门禁应拦截
python3 report.py --suite tool-calling-v1 --candidate v2 --gate

# 模拟宽松 schema：全量失败
python3 report.py --suite tool-calling-v1 --candidate loose --gate

# 测试
python3 -m unittest discover -s tests -v
```

预期：

- baseline 24/30，候选 30/30；配对差值 +0.20，95% CI [+0.067, +0.367]；门禁 PASS。
- v2 候选 28/30，broken=2，安全回归=2；门禁 FAIL。
- loose 候选 0/30，门禁 FAIL。

## 目录

```text
eval-platform/
  evalplat/
    registry.py   工具注册表与 schema 校验
    executor.py   执行器 + mock 工具（math/order/refund/flaky）
    evalset.py    评估集加载、校验、版本哈希
    runner.py     多次采样、记录、比较
    stats.py      Wilson/bootstrap/配对/pass@k
    gate.py       门禁与审计
  evalsets/
    tool-calling-v1.jsonl
    failures.jsonl
  tests/          22 个测试
  report.py       CLI
```

## 统计口径

- `pass_rate`：以 case 为单位；同一 case 的 N 次采样「全过才算过」。
- `wilson`：case 级成功率的 95% Wilson 区间；小样本比正态近似稳。
- 门禁的配对差值：同一批 case 上 candidate − baseline，bootstrap 2000 次，seed 固定。
- `p95`：所有采样记录的 95 分位延迟（含 mock 的固定延迟与重试）。

## 已知边界

- mock 工具是确定性的，延迟是常数；真实平台应记录真实 P50/P95/P99 与 token 成本。
- 评估集只有 30 条，置信区间很宽；这是教学样例，不是生产基准。
- 没有做污染检查、标注一致性、LLM-as-judge 校准；这些在第 9 章讨论。
- 版本哈希只覆盖 case 内容，不覆盖 runner 代码；生产环境应同时记录 git SHA 与镜像 digest。
