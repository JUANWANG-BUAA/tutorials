# 第 5 章实验：上下文预算分配器

`context_budget.py` 把一个 agent 请求拆成六段（system / task / tools / memory / history / tool_result），
在固定 token 预算下做四件事：**去重 → 保底 → 按优先级分配 → 压缩/裁剪**，并回读关键字段证明
压缩没有吃掉硬约束。

纯标准库、无网络、确定性；同一输入永远得到同一输出。

## 运行

```bash
# 默认：budget=1200，输出预留 20%
python3 experiments/ch05/context_budget.py

# 对照：按拼接顺序填满，越界处硬截断，无输出预留
python3 experiments/ch05/context_budget.py --budget 800 --naive

# 同一预算下比较策略
python3 experiments/ch05/context_budget.py --budget 800

# 只估算一个文件的 token（近似，不需要 tiktoken）
python3 experiments/ch05/context_budget.py --count src/part1/ch01.md

# 机器可读的计划
python3 experiments/ch05/context_budget.py --budget 800 --json | jq '.fields'

# 测试
python3 -m unittest discover -s experiments/ch05 -v
```

`--reserve N` 可覆盖默认的输出预留；`--no-dedupe` 关闭重复行去重；`--no-messages` 不打印最终消息。

## 六段与策略

| 段 | 优先级 | 策略 | 为什么 |
|:--|--:|:--|:--|
| system | 100 | `pin` | 规则与安全边界，不可压缩 |
| task | 95 | `pin` | 目标、硬约束、验收条件；压缩会丢否定与单位 |
| tools | 60 | `schema` | 按 tool > input > required > returns 逐层保留，先丢描述 |
| memory | 50 | `extractive` | 按数字、否定、单位、日期、失败原因抽行 |
| history | 40 | `summary` | 失败证据与最近 3 轮优先 |
| tool_result | 30 | `truncate` | 头 55% + 尾 45% + 省略标记 + 可回取 ref |

优先级不是「重要性」，而是 **价值 / 可替代性**：工具结果价值高但可随时用 ref 回取，
所以在预算不足时它先被截断；任务约束不可替代，所以它 pinned。

## 分配器做了什么

1. **扣输出预留**：`input_cap = budget - reserve`；输入永远不能吃掉输出的空间。
2. **去重**：删除重复的非空行（规范化后哈希，长度 ≥ 24），返回删除行数与节省 token。
3. **保底**：非硬段先拿 `min_tokens`，避免低优先级段被完全饿死。
4. **加权分配**：剩余额度按 priority 加权，再轮转补齐到 `input_cap`。
5. **压缩/裁剪**：按段的策略调用对应算子，产出文本不超过分配额度。
6. **回读**：对 10 个关键字段做子串检查（否定、数字、单位、失败原因、日期、ref）。

## 输出怎么读

```text
段             kind         prio    req  alloc   used  action    reason
system        system        100    124    124    124  keep      硬约束：永不丢弃/压缩
tools         tools          60    631    124    109  compress  省略 description，保留 name/input/required
task          task           95    155    155    155  keep      硬约束：永不丢弃/压缩
...
合计：requested=1848  alloc=640  used=597  cap=640  headroom=43
```

- `req` 是原始需求，`alloc` 是分到的额度，`used` 是压缩后实际占用；
  压缩器按整行/整 span 保留，产出小于额度时差额留在 `headroom`，不会为了凑满而切断半句。
- 默认还会打印按顺序拼接的最终消息全文；`--no-messages` 可关闭，`--json` 里每段带 `text` 字段。
- `action` 只有 `keep / compress / summarize / truncate / hard_cut / drop` 六种。
- `关键字段回读` 里 `[MISS]` 表示该字段在最终上下文里找不到；如果有 ref，应回取而不是继续生成。

## 失败与边界

- **token 数是近似值**：ASCII 约 3.7 字符/token，CJK 约 1 字/token，误差通常 ±15%。
  真实计费必须用对应模型的 tokenizer；本实验只用于相对比较。
- **不是真实模型**：没有采样方差，也不评估回答质量；它只验证「预算分配与压缩保真」这一层。
- **硬约束超预算时不会假装成功**：`over_budget=True`，硬段仍然保留，总额超过 `input_cap`，
  正确处置是提高预算或拆任务，而不是继续压缩。
- **`--naive` 是故意写坏的对照**：没有输出预留、没有去重、没有省略标记，用来暴露
  「按顺序填满」在真实请求上的后果。
- **近似重复**只提供 `jaccard_5gram` 供离线判断（阈值 0.75），分配器只做精确重复删除，
  避免误删语义相近但结论不同的两条证据。

## 与正文的对应

- 5.1 预算向量与成本模型：`--budget` / `--reserve` / `--count`
- 5.3 选择与去重：`build_segments`、`dedupe_repeated_lines`、优先级表
- 5.4 压缩与回读：`compress_extractive`、`compress_schema`、`verify_fields`
- 5.5 裁剪：`truncate_head_tail`、`clip`
- 5.8 实验：三组运行对比
- 5.9 失败案例：`--naive 800` 的 3/10 与 `--budget 800` 的 6/10
