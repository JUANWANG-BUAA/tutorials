# 第 9 章实验：评估统计（Wilson、bootstrap、配对检验、P95）

`eval_stats.py` 把一个小型评估集的统计口径压成可运行的标准库实现：48 条配对结果，
同一批任务上系统 A 与系统 B 各跑一次。它回答四个问题：

1. 准确率是多少，95% 区间有多宽（Wilson）？
2. B 比 A 好多少，配对之后差值区间是什么（bootstrap + McNemar）？
3. 这个「好」是均匀的，还是只发生在某些分层（难度 / 语言）？
4. 平均延迟降了，尾部是不是也降了（P50 / P95 / P99）？

纯标准库、无网络、确定性；bootstrap 的随机性只来自 `--seed`。

## 运行

```bash
# 默认 = --compare：两个系统的准确率、Wilson、延迟分位、配对差值
python3 experiments/ch09/eval_stats.py

# 分层：难度与语言；末尾验证加权 Δ 与总体 Δ 相等
python3 experiments/ch09/eval_stats.py --strata

# 换 bootstrap 种子：区间端点会动，结论不应跟着动
python3 experiments/ch09/eval_stats.py --seed 7

# 机器可读
python3 experiments/ch09/eval_stats.py --compare --json | jq '.paired'

# 测试
python3 -m unittest discover -s experiments/ch09 -v
```

`--boot N` 覆盖重采样次数（默认 4000）；`--json` 与 `--strata` 同用时输出完整 JSON
（含两份分层表）。

## 数据集怎么造的

48 条，`easy / medium / hard` 各 16 条，每种难度内 `py` 与 `ts` 各 8 条。每条记录：

| 字段 | 含义 | 构造方式 |
|:--|:--|:--|
| `a_ok` / `b_ok` | 是否通过验收 | A 35/48，B 36/48；不一致对 B-only=3、A-only=2 |
| `a_ms` / `b_ms` | 端到端延迟 | B 的主体更快，但三条硬任务尾部更慢 |
| `a_cost_micros` | 单次成本（微美元） | 按难度给基数 |
| `b_cost_micros` | B 的单次成本 | 由 A 乘 1.18 得到，模拟多一轮验证调用 |
| `a_tools` / `b_tools` | 工具调用数 | B 平均多约 18% |
| `a_tool_errors` / `b_tool_errors` | 工具错误数 | A 9 次，B 3 次；B 用重试换成功率 |

这是**构造数据**，不是任何厂商的基准：它只保证内部一致、可手算、能把
「平均提升 + 尾部变差 + 分层退化 + 成本上升」四种现象同时摆在一张表上。

## 输出怎么读

```text
dataset: 48 items · 3 difficulty × 2 language
system   n  correct  accuracy          Wilson 95%   mean ms    P50    P95    P99
A       48       35     72.9%      [59.0%, 83.4%]       969    870   1700   2100
B       48       36     75.0%      [61.2%, 85.1%]       905    760   2600   3200

paired（同一批 48 条，逐条配对）
  Δaccuracy = +2.08pp   bootstrap 95% CI [-6.2pp, +10.4pp]
  配对不一致：B-only=3  A-only=2   McNemar 精确 p=1.000   bootstrap p=0.82
  效应量 Cohen's h = +0.047
  Δmean latency = -64 ms   ΔP95 = +900 ms   Δcost/task = +18.0%
  mean cost/task: A $0.00217  B $0.00257
  cost per success: A $0.00298  B $0.00342  （B/A = 1.15×）

gate: REJECT（质量差值下界未超过 0；P95 与成本同时变差）
```

四行关键读数：

- **准确率 +2.08pp，但区间是 [−6.2pp, +10.4pp]**：方向不确定，不能拿点估计放行。
- **McNemar p=1.000**：3 个 B-only 对 2 个 A-only，在这个样本量下与抛硬币无异。
- **均值 −64 ms，P95 +900 ms，P99 +1100 ms**：平均变快是少数快样本拉出来的，
  尾部反而更慢。
- **cost per success 只涨 15%**：单次成本涨 18%，但 B 多解决了一条任务，
  所以「每次成功」的成本涨幅小于「每次调用」。两个口径都要报。

分层输出（`--strata`）：

```text
stratum by difficulty
stratum     n    A acc    B acc         Δ  B-only  A-only
easy       16    93.8%   100.0%   +6.25pp       1       0
hard       16    50.0%    43.8%   -6.25pp       0       1
medium     16    75.0%    81.2%   +6.25pp       2       1
weighted   48    72.9%    75.0%   +2.08pp
weighted Δ = +2.08pp；总体 Δ = +2.08pp；差 0.0pp（应为 0）
```

整体提升由 easy/medium 拉动，hard 退化 6.25pp。只看总体，这条退化会被平均掉；
只看 hard，又会错过 easy 上的真实收益。分层不是可选项，是读数的前提。

## 公式与实现口径

| 量 | 口径 | 代码 |
|:--|:--|:--|
| 准确率 | 通过数 / n，逐条等权 | `accuracy` |
| Wilson 区间 | score 区间，$z=1.95996$ | `wilson_ci` |
| bootstrap 区间 | 按条目有放回重采样，百分位 2.5/97.5 | `bootstrap_ci` |
| 配对差值 | 同一索引同时重采样 A/B，再用 B−A | `paired_bootstrap` |
| McNemar | 精确二项检验，双侧 | `mcnemar_exact` |
| pass@k | $1-\binom{n-c}{k}/\binom{n}{k}$ | `pass_at_k` |
| P95 | nearest-rank：$\lceil 0.95n \rceil$ 位 | `percentile(..., nearest_rank=True)` |
| 效应量 | Cohen's $h$ | `cohens_h` |

P95 与 P99 用 nearest-rank，是因为 SLO 通常按「第几个最慢请求」数，而不是插值；
bootstrap 区间用线性插值。两套口径都写在代码注释里，不要混用。

## 测试覆盖什么

16 个测试，分三组：

- **公式**：Wilson 的 8/10 与 0/20 已知值、pass@k 的 10/2/5 已知值、
  P95 nearest-rank、McNemar 的 10/2 精确值、Cohen's h 的零点。
- **数据一致性**：48 条、35/36 的准确率、配对差值 = 净不一致对数 / n、
  成本比 1.18、分层加权等于总体、hard 分层为负。
- **可复现**：同一 seed 的摘要完全相等，不同 seed 的区间不同；
  以及「均值下降但 P95 上升」这条本章核心断言。

测试不证明评估集有代表性，只证明统计口径没有被实现写错。

## 边界与常见误用

- **bootstrap p 值是近似的**：它来自重采样分布跨零的比例，不是精确检验；
  二分类配对请以 McNemar 为准，连续指标再用配对 bootstrap。
- **Wilson 假设条目独立**：同一任务多次采样、同一用户的多条记录都不独立，
  聚类数据要先按任务聚合，再算区间，否则区间会偏窄。
- **48 条只够演示**：半宽 5pp 需要约 385 条（$p=0.5$）；要检测 +2pp 的差异，
  配对设计需要的不一致对远多于 5 对。样本量估计见正文 9.4。
- **P95 在 n=48 时只由第 46 位决定**：再删两条样本，P95 可能跳几百毫秒；
  尾部分位数在小样本上极不稳定，必须同时给 n 与 P99。
- **成本是构造的**：真实成本要按输入/输出 token、缓存命中、工具单价分别记账，
  不能用一个倍数代替。
- **不要用 `p<0.05` 代替效应量**：+2.08pp、h=0.047 是「可忽略」量级；
  即使把 n 加到显著，也未必值得上线。

## 与正文的对应

- 9.3 指标：准确率、工具成功率、pass@k 估计量
- 9.4 统计：Wilson、bootstrap、配对、McNemar、样本量
- 9.5 回归：`gate: REJECT` 的多条件判定
- 9.6 成本-延迟-质量：mean/P95/P99、cost per success
- 9.8 失败案例：均值掩盖尾部、分层掩盖 hard 退化
- 9.9 实验：全部命令与读数
