# 第 7 章实验：三种规划策略在同一批任务上的对比

纯 Python 标准库，无网络、无第三方依赖。一张 5×6 左右的小地图、六个任务、
三种策略、同一份预算；同一命令两次运行输出逐字节相同。

三种策略：

| 策略 | 内部结构 | 规划成本 | 典型失效 |
|:--|:--|:--|:--|
| `react` | 每步按到目标的曼哈顿距离贪心，带访问惩罚与失败黑名单 | 每步 1 次状态评估 | 没有子目标：不会主动为钥匙绕路 |
| `plan` | 简化模型 BFS 出一条完整动作序列，执行；偏离时重规划 | BFS 扩展 + 执行步数 | 规划器模型与执行器不一致：单向门、未观测到的塌桥 |
| `tot` | 宽度 4 的 beam 搜索，完整模型展开，按价值函数排序 | 每个候选节点 1 次扩展 | 扩展预算：窄走廊上宽度 4 与小预算不匹配 |

## 运行

```bash
cd agent-systems

# 1. 全量对比表
python3 experiments/ch07/planners.py --suite

# 2. 单个任务、单个策略，带逐步 JSONL trace
python3 experiments/ch07/planners.py --task key-door --strategy react --trace /tmp/ch07-react.jsonl
python3 experiments/ch07/planners.py --task key-door --strategy plan  --trace /tmp/ch07-plan.jsonl

# 3. 看每步的动作、观察、价值、已扩展数、剩余预算
jq -r '[.step, .action, .observation, .value, .expansions, .steps_left] | @tsv' \
  /tmp/ch07-react.jsonl | head -n 8

# 4. 单元测试
python3 -m unittest discover -s experiments/ch07 -v
```

## 实测输出

`python3 experiments/ch07/planners.py --suite` 在 macOS、Python 3.13.13 上的真实输出：

```text
task                 strategy  ok   stop          steps  exp  replans  cost
---------------------------------------------------------------------------
open-field           react    True  done             10   10       0  12.00
open-field           plan     True  done             10   34       0  16.80
open-field           tot      True  done             10  102       0  30.40
key-door             react    False budget           40   40       0  48.00
key-door             plan     True  done             15   66       0  28.20
key-door             tot      True  done             15  158       0  46.60
one-way-return       react    True  done             16   16       0  19.20
one-way-return       plan     False replan_loop       4   96       2  23.20
one-way-return       tot      True  done             15  103       0  35.60
collapse-bridge      react    True  done             18   18       0  21.60
collapse-bridge      plan     True  done             10   33       1  16.60
collapse-bridge      tot      True  done             10   27       0  15.40
detour               react    True  done             12   12       0  14.40
detour               plan     True  done             10   22       0  14.40
detour               tot      True  done             10   47       0  19.40
long-corridor        react    True  done              9    9       0  10.80
long-corridor        plan     True  done              9   13       0  11.60
long-corridor        tot      False budget            0   21       0   4.20

summary
{"avg_cost": 21.0, "avg_expansions": 17.5, "avg_steps": 13.0, "strategy": "react", "success_rate": 0.833}
{"avg_cost": 18.47, "avg_expansions": 44.0, "avg_steps": 10.8, "strategy": "plan", "success_rate": 0.833}
{"avg_cost": 25.27, "avg_expansions": 76.33, "avg_steps": 12.0, "strategy": "tot", "success_rate": 0.833}
```

`cost = steps + 0.2 × expansions`。权重 0.2 是人为设定的「一次扩展约为 0.2 个
动作当量」，只用于把两种预算放到同一把尺子上；换成 0.1 或 0.5 会改变排序，
正文 7.8 节会讨论这个敏感性。`avg_steps` 只统计成功的任务，`avg_cost` 统计全部
任务（失败也计成本）。

## 任务与地图

符号：`#` 墙、`.` 地板、`S` 起点、`G` 目标、`K` 钥匙、`D` 门、`T` 触发器、
`B` 会塌的桥、`g` 单向门（默认只能向东）。

- `open-field`：无钥匙无门，三种策略都应成功；比较固定开销。
- `key-door`：钥匙在反方向，门挡住唯一通路；ReAct 不会主动为钥匙绕路。
- `one-way-return`：单向门在捷径上；`plan` 的简化模型把门当双向，重规划仍用
  同一模型，于是重复同一份错计划，触发 `replan_loop`。
- `collapse-bridge`：踩到 `T` 会塌桥；`plan` 的执行偏离预期后把塌桥加入
  `learned`，重规划一次后改走下方通道。
- `detour`：U 形墙；贪心先撞墙再绕路，动作数比 BFS 多 2。
- `long-corridor`：窄走廊，扩展预算只有 20；beam 宽度 4 在分支上生成大量候选，
  在第 9 层耗尽扩展预算。

每个任务给三种策略同一份 `(step_budget, expansion_budget)`；任务之间预算不同，
因为地图大小与分支因子不同。这是「同一任务上公平比较」，不是「所有任务同一预算」。

## 读表：三个反直觉结果

**1. ReAct 不是输在步数，是输在没有子目标。** `key-door` 里门在目标方向，
钥匙在反方向；按到目标的距离贪心，在到达钥匙之前不会主动退回去拿钥匙。
前 21 步反复移动，始终没去左上角拿钥匙，第 22 步才偶然经过钥匙，第 40 步停在离目标一格
的位置；40 步预算耗尽，成本 48.00，是全场最贵的一次失败。给它加一条「没钥匙
就先去找钥匙」的规则，它就不再是纯反应式策略，而是在内部藏了一个两级计划。

**2. Plan-Execute 不是输在计划质量，是输在计划模型。** `one-way-return` 的
简化模型把单向门当普通地板，BFS 找出的最短计划要求从东侧向西穿门；执行器
拒绝，重规划仍用同一模型，得到同一份计划。两次重规划后被判为 `replan_loop`，
成本 23.20。修复不是「多试几次」，而是把失败动作的方向约束写回规划模型，或者
让规划器在执行前用真实转移函数校验每一步的前置条件。

**3. 树搜索不是输在搜索能力，是输在预算分配。** `long-corridor` 只有一条正确
走廊，宽度 4 的 beam 虽然每层只有一个可行候选，但每次扩展仍要尝试多个动作；到第 9 层用掉 21 次扩展，
超过 20 的预算，连一个可执行的计划都没有返回。把宽度降到 1，它用 20 次扩展
成功，但 `key-door` 与 `collapse-bridge` 会失败；把它的扩展预算提高到 30，它
用 28 次扩展成功。宽度与预算没有全局最优，只有预算与任务分布的匹配。

另外两个结果值得注意：

- `open-field` 上 `react` 最便宜（12.00）。Plan 的 BFS 要扩展 34 个节点才找到
  一条本来就走得通的直线；树搜索更贵（102 次扩展）。全局规划的固定开销在简单
  任务上收不回来。
- `detour` 上 `plan` 的动作数少 2，但规划扩展把总成本拉回与 `react` 相同的
  14.40。这就是「计划更短」与「总成本更低」不是同一件事。

## 这个实验故意保留的四个限制

1. **ReAct 是手写贪心，不是 LLM。** 它没有语言推理，也没有「先拿钥匙」的
   子目标；这让我们能钉死「无全局约束」这一失效条件，但不能代表带强推理的
   ReAct 的上限。
2. **Plan 的简化模型是刻意设成不完整的。** 真实系统里规划器可能调用同一个
   模拟器，也可能用另一份世界模型；两者不一致正是 7.7 节「计划幻觉」的来源。
3. **价值函数是手写启发式。** `heuristic()` 把「先钥匙后门」和「塌桥罚 6」
   写死在代码里；换成学出来的价值函数，偏差会换一种形式出现，不会消失。
4. **网格与单元动作过于干净。** 真实工具的动作有延迟、失败率、并发与副作用；
   这里的每一步都是确定、即时、可逆（除了单向门与塌桥）。实验验证的是搜索
   结构与预算核算，不是生产环境的鲁棒性。

## 文件

| 文件 | 内容 |
|:--|:--|
| `planners.py` | 地图、转移、三种策略、预算、trace、CLI |
| `test_planners.py` | 可复现、最优解、预算终止、重规划触发 |
| `README.md` | 本文件 |
