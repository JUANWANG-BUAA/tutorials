# 期末项目提案指南

MIT 6.S191 的**唯一计分产出是项目提案**。本页给出官方结构、选题方法与自查表，帮助你把提案写成可以实施和评测的方案。

## 一、官方七要素结构

提案按下列七段写，每段都要说明具体的技术选择，不要只写目标和口号。

### 1. Motivation（动机）

**问题是什么、为什么值得做。** 一到两段：现状的痛点 → 现有方法的局限 → 你的切入点。好的动机能一句话说清「谁、在什么场景、遇到什么困难」。

> 反例：「深度学习很强大，我们想用它做点有用的东西。」（没有信息量）
> 正例：「家庭机器人抓取非结构化物体时，物体位姿多变、遮挡严重，传统几何方法泛化差；我们想验证预训练语义先验能否在少样本新物体上提升成功率。」

### 2. Related Work（相关工作）

**别人做到哪了、你与他们的区别。** 分三类介绍：该问题的经典方法、近年深度方法、与你最接近的工作。**必须点出 gap**，说清你的方法相对它们新在哪。

### 3. Proposed Approach（方法与技术路线）

**怎么做。** 这是提案的核心，要写清：基础模型/架构、关键改动（含公式或结构图）、损失函数、训练策略。对写进提案的每一个技术名词，你都要能解释它的含义，并回答「为什么选它」。

### 4. Data & Experimental Setup（数据与实验设置）

**用什么数据、怎么评测。** 数据来源（公开集 / 自建 / 仿真）、规模、预处理；训练/验证/测试划分；硬件与预算约束。**少样本任务要写清每类给多少样本。**

### 5. Evaluation（评价与对照）

**怎么知道成了。** 主指标 + 辅助指标；**必须有对照基线**：

| 对照 | 作用 |
|:--|:--|
| 朴素基线（如最简模型/随机） | 下界 |
| 现有方法复现 | 你的真实对手 |
| 全参数微调（若用 PEFT） | 你的成本优势的上界参照 |
| 消融（你的每个改动去掉一个） | 证明改动有效 |

### 6. Milestones（里程碑）

按周排，每阶段给**可交付物**（不是「继续研究」，而是「跑通基线」/「得到成功率表」）。

### 7. Risks（风险与对策）

诚实列出风险与**具体缓解**：算力不足→LoRA + 梯度累积；仿真到现实差距→域随机化 + 真机验证性实验；数据不够→公开集 + 脚本采集。

## 二、选题方法

好的课程项目提案有三个特征：**范围小、可评测、有对照**。

- **范围小**：8 周能做出初步结果。宁可「在一个小数据集上验证一个明确假设」，不要「做一个通用框架」。
- **可评测**：指标必须能在你的资源下量化（成功率、IoU、困惑度、精确匹配率…）。
- **有对照**：能说出「如果不改进方法，基线的数字会是多少」。

下面几类选题都在课程范围内，可供参考：

| 套路 | 例子 | 依赖讲次 |
|:--|:--|:--|
| 换数据、复现一个方法 | 在自建小数据集上复现 diffusion policy | [4](../lectures/lec04/overview.md) |
| 加一个改动、做消融 | 给注意力加一种位置编码，对比效果 | [2](../lectures/lec02/overview.md) |
| 迁移一个方法到新场景 | 把 VLA 模型微调到你的机械臂任务 | [6](../lectures/lec06/overview.md)、[9](../lectures/lec09/overview.md) |
| 高效微调一个模型 | 用 LoRA 在受限显存上适配下游任务 | [9](../lectures/lec09/overview.md) |

## 三、自查表（提交前逐项核对）

| 检查项 | 状态 |
|:--|:--|
| 七要素齐全，每段都落到具体技术选择 | ☐ |
| 动机能一句话说清「谁、什么场景、什么困难」 | ☐ |
| 相关工作点出了明确的 gap | ☐ |
| 方法含至少一处公式或结构描述 | ☐ |
| 数据来源、规模、划分写清 | ☐ |
| 有**明确的对照基线** | ☐ |
| 里程碑每阶段有可交付物 | ☐ |
| 风险有具体缓解，不是「多加小心」 | ☐ |
| 参考文献格式统一、无虚构 | ☐ |
| 团队分工（若为团队）写清 | ☐ |

## 四、一份可参考的选题骨架

> **面向非结构化环境的机器人抓取：基于扩散策略的视觉-语言-动作模型微调**
>
> - **动机**：家庭/仓储场景物体位姿多变，传统抓取规划泛化受限；
> - **相关工作**：几何抓取（泛化差）、行为克隆（确定性、多峰动作表达弱）、VLA 模型（微调成本高）；
> - **方法**：冻结开源 VLA 主干，用 LoRA 注入动作解耦头，以扩散头输出动作块，损失为噪声预测 MSE，语言指令做任务条件；
> - **数据**：公开示教集子集 + 仿真脚本采集；每类新物体 $K\in\{5,10,20\}$ 条示教；
> - **评价**：主指标抓取成功率，对照「冻结零样本 / 全参数微调（上界）/ 确定性 BC」；
> - **里程碑**：环境搭建 → 方法实现 → 实验消融 → 失败分析 → 报告；
> - **风险**：算力→LoRA + 累积；sim2real→域随机化 + 真机验证。

::: note 为什么推荐"扩散 + LoRA"这类组合
这类组合同时用到课程的四条线：生成建模（[第 4 讲](../lectures/lec04/overview.md)的扩散）、序列/多模态（[第 2、6 讲](../lectures/lec02/overview.md)）、高效训练（[第 9 讲](../lectures/lec09/overview.md)），且在单卡上就能做出初步结果，符合范围小、可评测、有对照这三条选题标准。
:::

## 五、评估设计模板（把「评价」写成可执行的东西）

提案里最容易写得含糊的是「评价」。写提案时就填好下表，把指标、对照和失败判据定下来。

| 项 | 你的填写 | 判据 |
|:--|:--|:--|
| **主指标** | （如成功率 / mAP / 困惑度 / 精确匹配率） | 口径与已有工作一致，说明阈值与平均方式 |
| **辅助指标** | （如延迟、显存、成本、拒答率） | 至少一项工程指标，避免「只谈效果」 |
| **基线 1（下界）** | 最简模型或随机策略 | 你的结果必须显著优于它，否则说明问题被低估 |
| **基线 2（真实对手）** | 复现一个现有方法 | 复现失败也要写进报告（这本身是有价值的结论） |
| **消融** | 你的每个改动去掉一个 | 用**同预算**对照（同数据、同步数、同种子数） |
| **运行次数** | ≥3 个种子 | 报告**均值 ± 标准差**，不挑最好的一次 |
| **失败判据** | （如提升 < 2 个点即判无效） | 事先写死，避免事后编故事 |

::: errata 评估设计的五个常见错误
1. **没有基线**：只有「我们达到了 92%」——92% 到底好不好，无法判断。
2. **只跑一次**：单次结果可能落在方差里；小数据任务尤其明显。
3. **调参用测试集**：这是最常见、后果也最严重的错误（[1.7](../lectures/lec01/sec17.md)、[6.7](../lectures/lec06/sec67.md)）。
4. **指标口径漂移**：与他人对比时改变了 IoU 阈值/最大生成长度/解码策略——结果不可比。
5. **只报平均值**：忽略子群体与长尾（[7.4](../lectures/lec07/sec74.md)），把风险藏在均值后面。
:::

## 六、答辩准备（五问 + 三个高频追问）

提案评审与答辩的核心是**五问**（完整版见[竞技场](../training/arena.md#arena-defense)）：问题与成功判据 / 为什么现在 / 怎么做（最不确定的一环）/ 代价（预算减半砍哪一刀）/ 失败预案。

**三个高频追问**，提前准备：

1. **「为什么不用更简单的方法？」**——要有答案：先试过什么、为什么不够（哪怕只是推理），并说明你的方法多付出的成本换来了什么。
2. **「你的指标能证明你声称的东西吗？」**——提前想清楚主指标与结论之间的逻辑链（例如「成功率提升」能否支持「泛化能力提升」？需要什么额外实验？）。
3. **「如果结果和预期相反怎么办？」**——不要只说「负结果也是结果」，要说明会补哪个实验、会怎么修改假设。

## 七、八周排期模板（可按周裁剪）

| 周 | 目标 | 可交付物 |
|:--|:--|:--|
| 0 | **先做评估**：写评分脚本 + 手工标注 30–50 个样本 | 评估脚本 + 基线分数（用最简方法跑一遍） |
| 1 | 数据与管线跑通（哪怕模型很弱） | 能一键复现的数据加载 + 训练脚本 |
| 2 | 复现一个现有方法作为基线 | 基线结果表（含种子数） |
| 3–4 | 实现你的改动 | 能跑通、不破坏原性能的结果 |
| 5 | 消融与对照 | 每个改动一行结果；一次只改一个变量 |
| 6 | 失败案例分析 | 至少 10 个失败样本的分类与原因 |
| 7 | 报告与复现说明 | 报告 + 一页「如何复现」；准备答辩五问 |

**算力预算建议**：把 60% 算力留给「复现基线 + 消融」，30% 留给主实验，10% 留作探索——**不要把所有算力押在一次「大而全」的实验上**。


## 八、前沿实验详细指南：组相对奖励与测试时预算 {#frontier-small-study}

这一项目把[第 6 讲的 GRPO 组内优势](../lectures/lec06/sec63.md#sec-6.3.5)、[测试时计算](../lectures/lec06/sec63.md#sec-6.3.3)和[评估污染](../lectures/lec06/sec67.md)放进同一套对照。以下数值、划分和超参数都是**本教程提出的实验配置，不是已完成训练的结果，也不是 MIT 官方项目要求**。原有机器人等选题仍可照常选择。

### 8.1 先登记两个可被否定的假设

- **H1（训练）**：同样消耗 12,800 次候选采样时，组标准化优势比不减基线的奖励更新有更高的严格正确率。比较组大小 4 与 8 时，保持每步候选总数 64、更新次数 200 不变，而不是保持问题数不变。
- **H2（推理）**：同一冻结策略、同一测试题和同样的候选/验证调用总数下，把预算转给尚未通过验证的题，比每题等额采样再重排更有效。这个收益是否被弱验证器的假阳性抵消？

主指标都是**独立严格判分的题目正确率**，不以训练奖励代替质量。预先约定：主比较为 `group8` 对 `raw8`（H1），以及 `group8` 的 `adaptive` 对 `rerank`、每题平均预算 4（H2）；其余预算、投票和消融属于辅助比较。主比较三种子平均提升须至少 2 个百分点且配对区间下界大于 0，才称为支持该假设；否则写“不支持/证据不足”，不要从众多辅助格子里挑一格替换主比较。

### 8.2 CPU 路径：学会选算式，而不是训练语言模型

任务输入是四元组 `(op,a,b,m)`，求 `(a op b) mod m`，`op` 属于 `+、*、-`。如 `(*,7,8,11)` 的答案是 `1`。候选由四个固定程序产生：加法、乘法、减法、正确答案加 1 后取模。最后一个故意错误的程序只用于机制实验；策略只能按 `op` 学习四种动作的概率，不能生成文本、发现算法或产生 CoT。

训练分布枚举 `a,b=0..29`、`m∈{7,11}`、三种运算，共 5,400 个唯一输入。对规范化输入字符串计算 SHA-256，整数值模 10：余数 0 为测试，1 为验证，其余训练；因此不是保证恰好 80/10/10，程序会打印实际数量。分布外集合固定为 `a,b=30..39`，其余不变，共 600 题，绝不参与训练或调参。按完整输入划分可防止相同题重复，但不能防止算术规则共享，不能据此声称学会了新的推理能力。

严格验证器 `exact` 给正确答案 1，否则 0；弱验证器 `parity` 只检查候选与标准答案奇偶性相同。它们都是人为可控的**结果验证器**，不是过程奖励模型。严格验证器本身会算答案，在真实应用中直接调用它比训练策略合理；这里保留它是为了隔离“选择器、奖励和预算”的机制，而非证明此算术任务需要 RL。弱验证器会接受错误答案：例如 `(+,7,8,11)` 的正确答案是 `4`，候选 `10` 同为偶数，弱验证器会接受，但独立严格判分应记错。

对同题的 $G$ 个奖励，用总体标准差，$A_i=(r_i-\bar r)/(\sigma+10^{-8})$；全等组优势为零并计入日志。下面更新是 $G^{-1}\sum_i A_i\nabla\log p(a_i\mid op)$ 的解析梯度，外加相对均匀参考策略、系数 0.02 的 KL 正则。**这是借用 GRPO 组相对优势的单步、同策略有限动作实验，不是完整 GRPO**：没有旧策略重用、重要性比裁剪、token 损失或神经网络。`raw8` 只把优势换成原始奖励，其余不变；`weak8` 只把训练奖励换成弱验证器；`group4` 只改组大小；`frozen` 不训练，作为零训练成本参照，不把它与训练方法称为同训练预算。

把下面代码保存到自己的实验目录为 `frontier_cpu.py`。需要 Python 3.10+，只用标准库；运行 `python3 frontier_cpu.py > summary.jsonl`，逐题结果写入当前目录的 `frontier_rows.csv`（会覆盖同名结果，应使用新目录）。普通笔记本 CPU、一个进程即可；不承诺运行秒数，实际墙钟时间由脚本输出，磁盘预留 200 MB。课程仓库不需要增加脚本文件，也无需下载模型或数据。

```python
import csv
import hashlib
import json
import math
import random
import time
from collections import Counter

OPS = ("+", "*", "-")
SEEDS = (17, 23, 47)

def answer(x):
    op, a, b, m = x
    return (a + b if op == "+" else a * b if op == "*" else a - b) % m

def candidates(x):
    _, a, b, m = x
    return ((a + b) % m, (a * b) % m, (a - b) % m, (answer(x) + 1) % m)

def verify(x, y, kind):
    target = answer(x)
    return int(y == target if kind == "exact" else y % 2 == target % 2)

def make_data():
    parts = {name: [] for name in ("train", "val", "test", "ood")}
    for op in OPS:
        for a in range(30):
            for b in range(30):
                for m in (7, 11):
                    x = (op, a, b, m)
                    key = f"{op},{a},{b},{m}".encode("ascii")
                    bucket = int(hashlib.sha256(key).hexdigest(), 16) % 10
                    parts["test" if bucket == 0 else "val" if bucket == 1 else "train"].append(x)
        for a in range(30, 40):
            for b in range(30, 40):
                for m in (7, 11):
                    parts["ood"].append((op, a, b, m))
    return parts

def probs(row):
    weights = [math.exp(v - max(row)) for v in row]
    return [v / sum(weights) for v in weights]

def train(data, seed, name):
    theta = [[0.0] * 4 for _ in OPS]
    rng = random.Random(seed)
    zero, groups = 0, 0
    if name == "frozen":
        return theta, zero, groups
    g = 4 if name == "group4" else 8
    reward_kind = "parity" if name == "weak8" else "exact"
    for _ in range(200):
        grad = [[0.0] * 4 for _ in OPS]
        for _ in range(64 // g):
            x = rng.choice(data)
            row = OPS.index(x[0])
            p = probs(theta[row])
            actions = rng.choices(range(4), weights=p, k=g)
            rewards = [verify(x, candidates(x)[a], reward_kind) for a in actions]
            mean = sum(rewards) / g
            sd = math.sqrt(sum((r - mean) ** 2 for r in rewards) / g)
            zero += int(sd == 0)
            groups += 1
            adv = rewards if name == "raw8" else [(r - mean) / (sd + 1e-8) for r in rewards]
            for a, advantage in zip(actions, adv):
                for j in range(4):
                    grad[row][j] += advantage * ((j == a) - p[j]) / 64
        for row in range(3):
            p = probs(theta[row])
            log_ratio = [math.log(v * 4) for v in p]
            kl = sum(v * z for v, z in zip(p, log_ratio))
            for j in range(4):
                theta[row][j] += 0.5 * (grad[row][j] - 0.02 * p[j] * (log_ratio[j] - kl))
    return theta, zero, groups

def evaluate(theta, xs, seed, budget, method, verifier):
    # 每题共享相同的候选前缀，分配策略不能偷看尚未调用的候选。
    streams = []
    for i, x in enumerate(xs):
        rng = random.Random(seed * 1000000 + i)
        p = probs(theta[OPS.index(x[0])])
        streams.append([candidates(x)[a] for a in rng.choices(range(4), weights=p, k=32)])
    n = len(xs)
    seen = [[] for _ in xs]
    accepted = [None] * n
    cursor = 0
    for step in range(budget * n):
        if method != "adaptive":
            i = step % n
        else:
            # 按题号轮询未解决题；每题最多 32 次，不读取真实正确性。
            active = [j for j in range(n) if accepted[j] is None and len(seen[j]) < 32]
            eligible = active or [j for j in range(n) if len(seen[j]) < 32]
            later = [j for j in eligible if j >= cursor]
            i = later[0] if later else eligible[0]
            cursor = (i + 1) % n
        y = streams[i][len(seen[i])]
        seen[i].append(y)
        # 投票也调用验证器，仅用于诊断，确保调用预算一致。
        if verify(xs[i], y, verifier) and accepted[i] is None:
            accepted[i] = y
    output = []
    for i, x in enumerate(xs):
        if method == "vote":
            counts = Counter(seen[i])
            chosen = max(counts, key=counts.get)  # 平票按首次出现
        else:
            chosen = accepted[i] if accepted[i] is not None else seen[i][0]
        correct = int(chosen == answer(x))
        false_accept = int(accepted[i] is not None and accepted[i] != answer(x))
        output.append((correct, len(seen[i]), false_accept, chosen))
    return output

def main():
    started = time.perf_counter()
    parts = make_data()
    print(json.dumps({"sizes": {k: len(v) for k, v in parts.items()}}))
    with open("frontier_rows.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(("seed", "model", "split", "budget", "method", "verifier",
                         "id", "op", "a", "b", "m", "correct", "calls", "false_accept", "chosen"))
        for seed in SEEDS:
            for name in ("frozen", "raw8", "group8", "group4", "weak8"):
                theta, zero, groups = train(parts["train"], seed, name)
                print(json.dumps({"seed": seed, "model": name, "theta": theta,
                                  "zero_groups": zero, "groups": groups,
                                  "train_draws": 0 if name == "frozen" else 12800}))
                for split in ("val", "test", "ood"):
                    xs = parts[split]
                    for budget in (1, 4, 8):
                        for method in ("vote", "rerank", "adaptive"):
                            for verifier in ("exact", "parity"):
                                rows = evaluate(theta, xs, seed, budget, method, verifier)
                                for i, (x, result) in enumerate(zip(xs, rows)):
                                    writer.writerow((seed, name, split, budget, method, verifier, i, *x, *result))
                                print(json.dumps({"seed": seed, "model": name, "split": split,
                                    "budget": budget, "method": method, "verifier": verifier,
                                    "accuracy": sum(r[0] for r in rows) / len(rows),
                                    "calls": sum(r[1] for r in rows),
                                    "false_accept_rate": sum(r[2] for r in rows) / len(rows)}))
    print(json.dumps({"wall_seconds": time.perf_counter() - started}))

if __name__ == "__main__":
    main()
```

`vote` 每题等额采样后多数投票，平票取最先出现者；`rerank` 等额采样后取首个被验证器接受的答案，否则取首个候选；`adaptive` 每题先获得一次机会，随后轮询未通过验证的题，每题上限 32。若全部通过或未通过题已到上限，剩余预算仍轮询其他题，不改变已经选定的答案。

因此三种方法**恰好**消耗 `budget × 题数` 次生成和同样次数的验证，提前停止不会减少这里记录的成本。预算为 1 时三种方法应给出相同答案。投票不使用验证器评分，但仍支付诊断调用的成本，所以这不是实际投票部署的最低成本。预生成候选只用于配对随机数，不允许分配器读取未消费的值；真实系统应按需生成。

先手工核对候选和奖励，再解释大规模实验结果。上述示例的候选应为 `(4,1,10,2)`，严格奖励为 `(0,1,0,0)`，弱奖励也是 `(0,1,0,0)`；换成 `(+,7,8,11)`，候选为 `(4,1,10,5)`，严格奖励 `(1,0,0,0)`，弱奖励 `(1,0,1,0)`，可直接看出假阳性。再按第 6 讲的四奖励示例检查优势。验证器通过不等于答案正确；不同动作也可能产生同一正确答案，因此不要用“选中了哪个程序”代替最终答案判分。

### 8.3 结果怎么记录、统计和解释

保留 Python 版本、操作系统、CPU 型号、代码 SHA-256、上述两份原始输出和实际墙钟时间。脚本不做验证集调参，所有配置预先固定；若要调整学习率或训练步数，只在验证集完成，登记选择过程，冻结后才打开测试/OOD 分数。三个种子的逐题结果必须保留，不允许只交最好的一次。

提交一张长表：`model / split / train_draws / verifier / method / budget / accuracy均值±种子样本标准差 / 配对差区间 / 生成调用 / 验证调用 / 假接受率 / 零方差组比例 / 秒数`。训练组日志没有按步保存，不能据此虚构学习曲线；需要曲线时自行逐步追加日志后重跑并说明新配置。原始 CSV 的 `false_accept` 是“首个被接受的候选错误”，对 `vote` 是验证器诊断，并不等同于最终投票错误率。还应按运算符、模数分别汇总严格正确率，列出至少 10 个错误输入及全部候选、选择结果与假阳性原因；不足 10 个就报告全部错误，不补造案例。

统计按**同题同种子配对**：例如固定测试集、严格验证器、预算 4，将两方法每题 `correct` 相减，再先跨三个种子取均值，得到每题一个差值。以 `random.Random(2026)` 对题号有放回抽样 2,000 次，每次抽原题数个题号，计算差值均值；排序后取第 2.5% 与 97.5% 分位，得到题目 bootstrap 区间。它只描述这三个固定训练种子下的题目不确定性，不包含充分的训练随机性估计；另报三种子均值及样本标准差（分母为 2），有资源时增加种子。不要把同题的多个候选当独立样本。H1 使用同一 `rerank/exact/预算4` 设置；H2 分别在严格与弱验证器下报告，弱验证器结果为机制诊断。OOD 单列，禁止混入 ID 平均数掩盖退化。

预算增加后严格质量若不升，检查：训练是否已经接近饱和、组内奖励是否全等、错误候选是否高度相关、弱验证器是否早早接受错误答案。零方差率是两种更新都会统计的组性质，不代表 `raw8` 也没有梯度。这里的单次采样全是固定程序，无法研究“长链与短链”的差别；候选次数也不等于语言模型 token/FLOPs，CPU 数值结论不能外推到真实 GRPO、通用推理或长思维链。

### 8.4 有 GPU：保持问题不变，换成真实模型实验

只做 CPU 路径也足以完成一份如实记录、可解释的机制研究。若要声称“真实 GRPO 训练”，必须另做以下扩展，并单独列结果，不能把上面的有限动作更新改名。

1. **固定模型和软件。** 选许可证允许训练、可获取权重的 0.5B–1.5B 因果语言模型；登记模型 ID、权重 revision、tokenizer/chat template、PyTorch/Transformers/TRL/PEFT 及 CUDA 的确切版本。用该版本 TRL 的 `GRPOTrainer`，先查本地签名 `python -c "import inspect; from trl import GRPOConfig, GRPOTrainer; print(inspect.signature(GRPOConfig)); print(inspect.signature(GRPOTrainer))"`，按其版本文档构造配置，不从其他版本复制参数名。无需下载新基准，继续用本节生成器和完整输入划分；导出每行 `id、split、prompt、answer` 的 JSONL 后计算哈希。
2. **固定输入与判分。** 提示固定为“计算 `({a} {op} {b}) mod {m}`。可以写推导，最后一行必须为 `FINAL: 整数`。”只接受最后一行完整匹配 `FINAL: -?[0-9]+` 的输出，要求整数处于 `[0,m)`；解析失败、越界、超长截断均奖励 0，不做字符串子串命中，也不自动把越界答案取模。严格/弱验证器沿用 CPU 定义；所有最终质量由独立严格脚本重算。先手验本节两题、负数取模、空输出、多行伪造 FINAL 和越界值，记录 Python 非负余数约定。
3. **真实训练配置。** 同一基座，LoRA `r=8、alpha=16、dropout=0`，目标 `q_proj/v_proj`（选有这些模块的模型并保存实际可训模块表）；AdamW，学习率 `1e-5`，权重衰减 0，梯度范数上限 1，固定学习率；温度 0.8，top-p 1，提示上限 128 token、回答上限 128 token，200 次优化器更新，每次 64 条回答。`G=8` 时每步 8 题，`G=4` 时每步 16 题；microbatch/梯度累积可随显存改，但不能改有效批量。GRPO 裁剪参数 0.2，KL 系数 0.02，冻结原基座为参考，组内总体标准差加 `1e-8`，每批 rollout 只做一轮更新，保存实现采用的精确损失公式和序列/token 归一化方式。若该版本库语义不同，显式配置或修改对应项，报告差异，不能默称与 CPU 更新相同。超长输出的掩码和奖励处理也必须记录。
4. **最少对照与消融。** 冻结原基座、严格奖励 GRPO `G=8`、同预算 `G=4`、弱奖励 `G=8`；再做去掉组标准差（仅减组均值）和去掉 KL 的单变量消融。训练种子仍为 17/23/47，不用验证集反复挑种子。CPU 的 `raw8` 不能充当真实模型基线；若比较原始奖励损失，必须在相同真实训练器内实现并公布公式。
5. **实际运行和资源封顶。** 在自己的实验目录实现数据导出、奖励回调、训练入口和逐题解码入口；建议命令接口固定为 `python train_frontier.py --config group8.json --seed 17` 和 `python eval_frontier.py --checkpoint RUN --split test --budget 1024 --strategy rerank`，其中 JSON 必须落实以上数值而不是空壳，三个种子和全部消融逐一运行。它们是读者要提交的实现接口，不是本仓库已有命令。单张 16–24 GB GPU 可作为 0.5B LoRA 的尝试资源，**不是显存保证**；先用验证集 8 题做一批 rollout+反传，记录峰值显存、tokens/s 和耗时，按 200 步外推总 GPU 小时，给全部实验合计设 12 GPU 小时上限。预计超额时先统一改为 50 步并登记新预算，所有已训对照也按 50 步检查点比较；无法容纳时统一缩小基座或回答上限后从头登记，不用单独缩短某个基线。OOM 和中断计入成本，不填推测分数。
6. **固定推理预算，分开两个问题。** 每个检查点冻结参数，温度 0.8、top-p 1；先做与 CPU 相同的等长 128-token 候选、平均每题 1/4/8 次生成、投票/重排/自适应对照，验证器只读当前输出，不能读取隐蔽严格答案来决定弱验证器分配。再比较“长链/多短链”：每题总回答额度取 512 或 1,024 token，分别分成 `1×B、4×(B/4)、8×(B/8)`；生成到 EOS 可提前终止，不强迫填满。预留额度相同不代表实际计算相同，所以报告实际输出 token、重复输入 token、验证 CPU 时间、峰值显存和总墙钟，不把上限称为实际 FLOPs。跨题自适应分配以整批 `B×题数` 为 token 上限，至少给每题一次最短额度，每次生成前扣留该候选最大额度，结束后归还未用额度，剩余额度不足一个候选就停止；不能先生成后截掉“超预算”的费用。独立判分、失败输出与验证成本不漏记；同时画实际 token—严格准确率曲线，若两法实际成本相差大，只能称“同上限比较”，不能称“同成本提升”。

这条扩展最终应交付可执行代码、锁定依赖、配置 JSON、数据与检查点哈希、完整逐题日志和复现命令，缺少真实训练记录时只能交付“扩展方案”，不能填入推测的模型效果。这里没有提供真实模型训练成绩。

### 8.5 伦理、数据限制与结项标准

合成算术输入不含个人信息，能够公开全部题目和验证逻辑；它也缺少自然语言歧义、开放答案与真实代码安全风险。不要用该实验宣称医疗、法律、机器人控制或安全对齐能力提升。转用公开题库前核对许可证、署名与再分发条款，记录模型可能已见过题目的污染风险；转用用户数据须获得授权、去标识化并限定保留时间。运行模型生成代码时使用隔离、禁网、只读输入和进程/内存/时间限制，不在宿主机直接执行。报告电力/算力成本、失败与负结果；弱验证器只用于受控研究，不作为实际高风险应用的质量保证。

结项至少包含：两道手工核验记录、数据划分计数及哈希、全部预算的前后对照表、预登记主比较的区间、按运算符与模数的质量检查、零方差与假接受分析、原始失败案例和一条能重跑的命令。CPU 路径与 GPU 路径分别标注“有限动作机制实验”及“真实语言模型实验”；只做 CPU 也可形成完整的可复现研究，不需要伪造真实模型训练记录。
