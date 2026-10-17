# 九讲导览

这张表是九讲的**唯一总览**：预习时先扫「一句话」列，复习时只读「必记」列。每讲另有一页**讲导览**（含节一览表、本讲地图与用法）与**讲末材料**（总结、勘误、习题、自检表、回忆卡、自测卷）。


{{#include ../assets/figures/dl-map.md}}

## 九讲一览

| 讲 | 一句话 | 必记 | 配套实验 |
|:--|:--|:--|:--|
| [1 · 深度学习导论](../lectures/lec01/overview.md) | 一切网络 = 结构 + 损失 + 梯度下降 | 前向/反向传播、交叉熵与 MSE、过拟合与正则 | [Lab 1](../labs/lab1.md) |
| [2 · 深度序列建模](../lectures/lec02/overview.md) | 用注意力直接建模任意位置的依赖 | RNN 递推与梯度消失、门控、缩放点积注意力、Transformer、RoPE/GQA | [Lab 1](../labs/lab1.md) |
| [3 · 深度计算机视觉](../lectures/lec03/overview.md) | 用局部性与权值共享压缩图像任务 | 卷积输出尺寸公式、感受野、残差连接、迁移学习、检测与分割 | [Lab 2](../labs/lab2.md) |
| [4 · 深度生成建模](../lectures/lec04/overview.md) | 学会数据分布就能采样出新样本 | VAE 的 ELBO 与重参数化、GAN 极小极大、扩散的噪声预测、流匹配 | — |
| [5 · 深度强化学习](../lectures/lec05/overview.md) | 用回报信号在试错中学习策略 | MDP 与回报、DQN 的经验回放与目标网络、策略梯度、PPO、DPO | — |
| [6 · 新前沿](../lectures/lec06/overview.md) | 规模带来能力，也带来对齐问题 | 缩放律、思维链与测试时计算、VLM/VLA、智能体、评测污染 | [Lab 3](../labs/lab3.md) |
| [7 · AI 的三条法则](../lectures/lec07/overview.md) | 让系统可控、可解释、可信赖 | 对齐与奖励黑客、机制可解释性、公平度量、风险框架 | — |
| [8 · AI for Science](../lectures/lec08/overview.md) | 把科学试错变成可微分的推断 | 结构预测、等变网络、神经算子、PINN 边界、外推 vs 插值 | — |
| [9 · 大规模并行训练](../lectures/lec09/overview.md) | 模型放不下时，切分与通信是核心 | 显存五账单、DP/TP/PP、ZeRO/FSDP、混合精度、LoRA | [Lab 3](../labs/lab3.md) |

## 每讲的固定结构（读法一致）

每一讲都按同一套骨架组织，便于跳读与复习：

```text
讲导览 overview.md     ← 讲首导语 + 节一览表 + 本讲地图
节页   secNN.md        ← 动机 → 定义 → 直觉 → 推导 → 例题 → 代码 → 陷阱 → 即时自测
讲末   summary.md      ← 节一览 + 一条主线 + 三句话带走 + 与后续连接
       errata.md       ← 对照母本的补注 + 术语译误 + 时效补注
       exercises.md    ← A 概念 / B 推导 / C 编程 / D 开放（附答案与验收标准）
       checklist.md    ← 学习目标自检表（含依据与习题编号）
       recall-cards.md ← 闭卷回忆卡（定义/结论/公式/陷阱四组）
       mock-exam.md    ← 闭卷计时自测卷（含评分标准与漏点定位）
```

**读法**：第一遍读「直觉」建立手感，**跳过所有折叠的证明框**；二刷再逐行补推导。每节末尾的「陷阱」与「即时自测」务必看——考试与实战里出错最多的就是那几条。

## 阅读节奏建议

| 目的 | 读法 |
|:--|:--|
| **第一次系统学** | 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9，每讲后做对应 Lab；每讲结束做一次自检表 |
| **只为项目做准备** | 重点读 [1 导览](../lectures/lec01/overview.md)（范式）、[2.4–2.5](../lectures/lec02/sec24.md)（注意力）、[4 导览](../lectures/lec04/overview.md)（生成）、[9.5–9.6](../lectures/lec09/sec95.md)（训练），再做 [Lab 3](../labs/lab3.md) |
| **时间很紧** | 只读每讲的「10 分钟复习版」+ [公式速查卡](../review/formula-cards.md) + [速查背记卡](../memory-sheet.md) |
| **面试 / 答辩前** | [面试与答辩竞技场](../training/arena.md)三轮 + [综合自测卷](../training/exam-sprint.md) |
| **要上手做工程** | [工程工具箱](../toolbox.md) + [最小必读路径 · 路线 5](../review/study-paths.md) |

## 每讲配一条「第二课堂」（建立直觉的交互式资源）

正讲讲原理，这些页面负责给手感——**每讲挑一个，玩 10 分钟胜过读十页**：

| 讲 | 推荐入口 | 它能给你什么 |
|:--|:--|:--|
| 1 | [TensorFlow Playground](https://playground.tensorflow.org) | 亲手调层数/激活/学习率，实时看决策边界变化 |
| 2 | [Transformer Explainer](https://poloclub.github.io/transformer-explainer/) | 在浏览器里跑 GPT-2，看注意力与采样参数的作用 |
| 3 | [CNN Explainer](https://poloclub.github.io/cnn-explainer/) | 逐层看卷积核与特征图 |
| 4 | [Diffusion Explainer](https://poloclub.github.io/diffusion-explainer/) | 文生图流水线（文本编码器 → U-Net → VAE）逐步可视化 |
| 5 | [Spinning Up（OpenAI）](https://spinningup.openai.com) | 概念—公式—代码三件套的 RL 导览 |
| 6 | [LLM Visualization](https://bbycroft.net/llm) | 3D 走查 GPT 的权重与数据流 |
| 7 | [Distill · Circuits](https://distill.pub/2020/circuits/) | 机制可解释性的经典交互长文 |
| 8 | [AlphaFold 官方解读](https://alphafold.ebi.ac.uk)（数据库） | 看真实结构预测结果长什么样 |
| 9 | [TorchTitan 示例](https://github.com/pytorch/torchtitan) | 官方 3D 并行最小可复现配置 |

更多资源见[延伸阅读地图](../reading.md)（课程、论文、开源项目）与[附录 B](../appendix/resources.md)（工具与框架）。

## 九讲之间的依赖

- **第 1 讲是地基**：反向传播、损失、优化器、正则化在第 2–9 讲反复出现。
- **第 2 讲的注意力**是第 6、9 讲的底座（LLM、VLA、并行训练都在它之上）。
- **第 4 讲的重参数化与噪声预测**在扩散、流匹配、VLA 的动作生成里都会复用。
- **第 9 讲的显存与并行**决定第 6 讲的模型能不能训、Lab 3 能不能跑。
- **第 7 讲不是「附加题」**：它给出的是做前面所有事情时的约束（数据、评估、上线）。

每讲页首的**「10 分钟复习版」**给出本讲骨架；缺什么先补什么。