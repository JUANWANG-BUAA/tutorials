# 第 9 讲 · 大规模并行训练的秘诀

> 前八讲都在回答「**怎么设计**一个能学好的模型」；本讲换一个完全不同的问题：**当模型和数据大到一张卡装不下时，怎么把它训起来**。我们会看到，大规模训练的瓶颈常常不在算力，而在**显存**与**通信**。沿着这两个瓶颈，本讲展开两条主线——**切**（数据并行、张量并行、流水线并行，可组合成 3D 并行）与**省**（混合精度、激活重计算、ZeRO / FSDP 分片）；再给出「给定硬件该怎么选策略」的决策清单，并把它接到 [Lab 3](../labs/lab3.md) 的参数高效微调上。读完你会明白：**并行训练不是「把卡堆起来就快了」，而是一套关于显存、通信与算法三者权衡的工程学。**

<aside class="lesson-brief" aria-label="第 9 讲学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>反向传播与梯度下降、小批量与学习率（第 1 讲）；矩阵乘法的形状与计算量直觉；GPU 显存与带宽的基本概念；对「多卡一起把张量求和」这类集合通信只需有语义直觉即可（本讲会解释）。</p></div>
<div><span class="brief-label">TARGET</span><strong>本讲要建立</strong><p>一次训练步骤的显存账本（参数 / 梯度 / 优化器状态 / 激活）；数据并行与梯度累积；All-Reduce 与同步 / 异步更新；张量并行的列切与行切；流水线并行、micro-batch 与气泡、1F1B；混合精度与损失缩放；激活重计算；ZeRO 三级分片与 FSDP；通信量估算与拓扑（NVLink / InfiniBand）；并行策略决策清单；LoRA 参数高效微调。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能估算给定模型在混合精度 Adam 下的模型状态显存；能说清数据并行每步通信的是什么、为何通信量与批大小无关；能解释张量并行为什么「列切 + 行切」要成对出现；能写出流水线气泡占比并说明如何减小；能说出 ZeRO 三个阶段各分片了什么；能针对「单卡装不下」的不同原因给出并行方案。</p></div>
</aside>

::: method[core] 10 分钟复习版 · 第 9 讲

**一句话**：大规模训练的两堵墙是**显存**与**通信**；对付它们有两条路——**切**（数据并行切数据、张量并行切单层权重、流水线并行切层，三者正交可组合）与**省**（混合精度、激活重计算、ZeRO / FSDP 分片冗余状态）；选方案前先测量瓶颈，验收看**扩展效率**而非堆卡数。

**必记结论**

| 内容 | 要点 |
|:--|:--|
| **三种并行** | 数据并行（切数据、模型复制）、张量并行（切单层权重）、流水线并行（切层）——彼此正交，可组合成「3D 并行」 |
| **显存账本** | 混合精度 Adam 下模型状态 $\approx$ **16 字节/参数**（fp16 权重 2 + fp16 梯度 2 + fp32 主权重 4 + fp32 动量 4 + fp32 方差 4）；此外还有随批增长的**激活** |
| **数据并行** | 每卡一份**完整副本**；全局批 = 单卡批 $\times N$；每步一次**梯度 All-Reduce**（先求和再平均） |
| **DP 通信量** | 梯度 All-Reduce $\approx2\times$ 模型大小（环状算法），**与批大小无关** → 大批量 / 梯度累积摊薄通信开销 |
| **梯度累积** | 攒 $K$ 个 micro-batch 的梯度再更新一次，等效批 = $K\times$ 单卡批 $\times N$；省激活显存，不省参数显存 |
| **同步 vs 异步** | 同步每步等齐所有卡（受最慢卡拖累、结果可复现）；异步不等待但用**陈旧梯度**、收敛更不稳 |
| **张量并行** | 把权重矩阵切到多卡：**列切**输出在输出维分片、无需通信；**行切**需一次 All-Reduce 求和 |
| **TP 组合** | MLP 里「列切 → 逐元素激活 → 行切」，前向只需**一次** All-Reduce；注意力按**头**切，输出投影行并行 |
| **TP 通信特征** | 频繁、延迟敏感 → 必须放在 **NVLink**（单机）域内；并行度一般不超过单机 GPU 数 |
| **流水线并行** | 按层切成 $P$ 个 stage，micro-batch 依次流过；先填充后排出，留下**气泡** |
| **气泡占比** | 朴素调度下 $\approx\dfrac{P-1}{M+P-1}$（$M$ 个 micro-batch）；$M$ 越大气泡越小 |
| **1F1B** | 预热后「一前一后」交替，减小**峰值激活显存**，并让计算与通信更易重叠 |
| **混合精度** | fp16 / bf16 存储与计算 + fp32 主权重；fp16 需**损失缩放**防下溢，bf16 范围宽通常免缩放 |
| **激活重计算** | 只存少数检查点，反向时**重算**中间激活；用一次额外前向换显存 |
| **ZeRO** | 数据并行副本其实冗余：阶段 1 分片**优化器状态**、阶段 2 再分片**梯度**、阶段 3 再分片**参数** |
| **FSDP** | 全分片数据并行：参数 / 梯度 / 优化器状态全切，算前 all-gather、算完 reduce-scatter |
| **拓扑** | 节点内 NVLink（带宽高、延迟低）优先放张量并行；节点间 InfiniBand 放数据 / 流水线并行 |
| **LoRA** | 冻结主干 $W_0$，只训低秩修正 $\Delta W=BA$；优化器状态与梯度只属于适配器 → 单卡可微调 |
| **规模化真相** | 加速比 $<$ 卡数：受**通信开销、流水线气泡、最慢卡**限制；要盯「扩展效率」而非总吞吐 |

**最该记住的四个判断**：① 先分清「装不下」是**模型状态装不下**（→ 省显存 ZeRO / 混合精度，或切模型 TP / PP）还是**激活装不下**（→ 梯度累积 / 激活重计算 / 减小 micro-batch）；② 通信密集的并行（张量并行）放在**快链路**上，通信稀疏的并行（数据 / 流水线并行）可以跨机；③ 并行是为了「**放得下 + 跑得满**」，先测量瓶颈再切分，别凭感觉堆卡；④ 显存受限做微调时，**PEFT / LoRA 往往比任何并行技巧都省**。

:::

## 1.1 问题设定：超过单卡容量

单卡训练的循环在[第 1 讲](lec01.md)已经写清：前向、反向、更新。但当参数量到十亿、百亿乃至更大，训练数据到万亿 token，一张 GPU 会在三个地方撞墙：**装不下**（显存）、**等不起**（时间）、**传不动**（通信）。而这三者里，最先卡住进程的通常是前两个。

::: intuition 瓶颈常在显存与通信，不在「算不动」
很多人以为大规模训练的首要问题是「FLOPs 不够」。其实现代 GPU 的算力相当可观，真正先撞墙的通常是两件事：**显存**——参数、梯度、优化器状态、激活四样要同时驻留，很快就把高带宽显存（HBM）吃光；**通信**——一旦模型被切到多卡，卡与卡之间每步都要交换张量，链路带宽跟不上，GPU 就会**空转等数据**。于是「并行训练」的核心问题变成：**如何在显存装得下的前提下，让每张卡尽量少等、多算**。算力只是分母，显存与通信才是真正的约束。
:::

::: ex 例 9.1（一次训练步骤的显存账本） {#ex-9-1}
设模型有 $P$ 个参数，用**混合精度 + Adam** 训练。请估算「模型状态」（与优化器相关、必须常驻的部分）需要多少显存，并以 $P=7\times10^{10}$（约 700 亿参数）为例给出数量级。

::: proof 解
混合精度 Adam 对每个参数要保存五份数值：

| 项 | 精度 | 字节 / 参数 |
|:--|:--|:--|
| 参数（参与计算） | fp16 | 2 |
| 梯度 | fp16 | 2 |
| 主权重（master weight） | fp32 | 4 |
| 一阶矩 $m$ | fp32 | 4 |
| 二阶矩 $v$ | fp32 | 4 |

合计 $16$ 字节 / 参数，故模型状态显存 $\approx16P$ 字节。代入 $P=7\times10^{10}$：$16\times7\times10^{10}\approx1.1\times10^{12}$ 字节 $\approx1.1\ \mathrm{TB}$。

再叠加**激活**（前向中间结果，随批大小与序列长度增长），单张 80 GB 级 GPU 远远装不下——**这就是「单卡装不下」最直接的含义**。（这是纯记账：不含通信缓冲、显存碎片与框架开销，实际只会更多。）
:::

:::

于是「并行」有两层含义：**切模型**（把参数与计算分到多张卡上：张量并行、流水线并行）与**切数据**（每张卡放一份完整模型、各自处理一部分数据：数据并行）。此外还有一整套**省显存**的手段（混合精度、激活重计算、分片冗余状态）。下面依次展开。

<figure>
<svg class="figure-svg" viewBox="0 0 900 470" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-parallel-title fig-parallel-desc">
<title id="fig-parallel-title">三种并行：数据 / 张量 / 流量线</title>
<desc id="fig-parallel-desc">上左：数据并行——每卡一份完整模型、各自处理数据分片，梯度 All-Reduce 同步；上右：张量并行——把单层权重矩阵按列切到多卡、层内通信；下：流水线并行——按层分段、micro-batch 流动，甘特图显示 GPipe 调度的前向（绿）/反向（金）与首尾的气泡（红影）。</desc>
<defs></defs>
<text class="diagram-note" fill="var(--fig-blue)" x="210" y="30" text-anchor="middle" font-weight="700">① 数据并行：切数据</text>
<rect x="90" y="52" width="130" height="48" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" x="155.0" y="80.5" text-anchor="middle" font-size="11.5px">模型（同一份）</text>
<text class="diagram-note" fill="muted" x="250" y="80" text-anchor="start" font-size="12px">数据分片 1</text>
<line x1="155" y1="52" x2="155" y2="47" stroke="var(--fig-blue)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-blue)"/>
<rect x="90" y="130" width="130" height="48" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" x="155.0" y="158.5" text-anchor="middle" font-size="11.5px">模型（同一份）</text>
<text class="diagram-note" fill="muted" x="250" y="158" text-anchor="start" font-size="12px">数据分片 2</text>
<line x1="155" y1="130" x2="155" y2="125" stroke="var(--fig-blue)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-blue)"/>
<rect x="90" y="208" width="130" height="48" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" x="155.0" y="236.5" text-anchor="middle" font-size="11.5px">模型（同一份）</text>
<text class="diagram-note" fill="muted" x="250" y="236" text-anchor="start" font-size="12px">数据分片 3</text>
<line x1="155" y1="208" x2="155" y2="203" stroke="var(--fig-blue)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-blue)"/>
<path d="M 90 208 L 230 208" stroke="var(--fig-blue)" stroke-width="2" fill="none" stroke-dasharray="7 4" marker-end="url(#mk-blue)"/>
<text class="diagram-note" fill="var(--fig-blue)" x="160" y="228" text-anchor="middle" font-size="12px">梯度 All-Reduce 同步</text>
<text class="diagram-note" fill="muted" x="210" y="258" text-anchor="middle" font-size="12px">通信量与批大小无关；批大小 ∝ 卡数</text>
<rect x="60" y="244" width="300" height="44" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="210.0" y="270.5" text-anchor="middle"></text>
<text class="diagram-note" fill="var(--fig-purple)" x="660" y="30" text-anchor="middle" font-weight="700">② 张量并行：切单层</text>
<rect x="520" y="56" width="28" height="130" fill="var(--fig-purple)" fill-opacity="0.18" stroke="var(--fig-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="534" y="46" text-anchor="middle" font-size="11px">G₁</text>
<rect x="550" y="56" width="28" height="130" fill="var(--fig-purple)" fill-opacity="0.18" stroke="var(--fig-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="564" y="46" text-anchor="middle" font-size="11px">G₂</text>
<rect x="580" y="56" width="28" height="130" fill="var(--fig-purple)" fill-opacity="0.18" stroke="var(--fig-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="594" y="46" text-anchor="middle" font-size="11px">G₃</text>
<rect x="610" y="56" width="28" height="130" fill="var(--fig-purple)" fill-opacity="0.18" stroke="var(--fig-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="624" y="46" text-anchor="middle" font-size="11px">G₄</text>
<text class="diagram-mono" fill="ink" x="580" y="208" text-anchor="middle" font-size="11.5px">Y = XW → [XW₁ | XW₂ | XW₃ | XW₄]</text>
<rect x="480" y="244" width="360" height="44" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="660.0" y="270.5" text-anchor="middle"></text>
<text class="diagram-note" fill="ink" x="660" y="262" text-anchor="middle" font-size="12px">每卡持一列切片，层内即需通信</text>
<text class="diagram-note" fill="muted" x="660" y="280" text-anchor="middle" font-size="12px">→ 张量并行要放在 NVLink 域内</text>
<text class="diagram-note" fill="var(--fig-green)" x="450" y="330" text-anchor="middle" font-weight="700">③ 流水线并行：切层（GPipe 调度，P=4 段 × M=4 个 micro-batch）</text>
<text class="diagram-note" fill="var(--fig-green)" x="76" y="373.0" text-anchor="end" font-size="12px">段1</text>
<rect x="91" y="352" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="117.0" y="373.0" text-anchor="middle" font-size="10.5px">F1</text>
<rect x="145" y="352" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="171.0" y="373.0" text-anchor="middle" font-size="10.5px">F2</text>
<rect x="199" y="352" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="225.0" y="373.0" text-anchor="middle" font-size="10.5px">F3</text>
<rect x="253" y="352" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="279.0" y="373.0" text-anchor="middle" font-size="10.5px">F4</text>
<rect x="793" y="352" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="819.0" y="373.0" text-anchor="middle" font-size="10.5px">B1</text>
<rect x="739" y="352" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="765.0" y="373.0" text-anchor="middle" font-size="10.5px">B2</text>
<rect x="685" y="352" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="711.0" y="373.0" text-anchor="middle" font-size="10.5px">B3</text>
<rect x="631" y="352" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="657.0" y="373.0" text-anchor="middle" font-size="10.5px">B4</text>
<text class="diagram-note" fill="var(--fig-green)" x="76" y="413.0" text-anchor="end" font-size="12px">段2</text>
<rect x="145" y="392" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="171.0" y="413.0" text-anchor="middle" font-size="10.5px">F1</text>
<rect x="199" y="392" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="225.0" y="413.0" text-anchor="middle" font-size="10.5px">F2</text>
<rect x="253" y="392" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="279.0" y="413.0" text-anchor="middle" font-size="10.5px">F3</text>
<rect x="307" y="392" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="333.0" y="413.0" text-anchor="middle" font-size="10.5px">F4</text>
<rect x="739" y="392" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="765.0" y="413.0" text-anchor="middle" font-size="10.5px">B1</text>
<rect x="685" y="392" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="711.0" y="413.0" text-anchor="middle" font-size="10.5px">B2</text>
<rect x="631" y="392" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="657.0" y="413.0" text-anchor="middle" font-size="10.5px">B3</text>
<rect x="577" y="392" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="603.0" y="413.0" text-anchor="middle" font-size="10.5px">B4</text>
<text class="diagram-note" fill="var(--fig-green)" x="76" y="453.0" text-anchor="end" font-size="12px">段3</text>
<rect x="199" y="432" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="225.0" y="453.0" text-anchor="middle" font-size="10.5px">F1</text>
<rect x="253" y="432" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="279.0" y="453.0" text-anchor="middle" font-size="10.5px">F2</text>
<rect x="307" y="432" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="333.0" y="453.0" text-anchor="middle" font-size="10.5px">F3</text>
<rect x="361" y="432" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="387.0" y="453.0" text-anchor="middle" font-size="10.5px">F4</text>
<rect x="685" y="432" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="711.0" y="453.0" text-anchor="middle" font-size="10.5px">B1</text>
<rect x="631" y="432" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="657.0" y="453.0" text-anchor="middle" font-size="10.5px">B2</text>
<rect x="577" y="432" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="603.0" y="453.0" text-anchor="middle" font-size="10.5px">B3</text>
<rect x="523" y="432" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="549.0" y="453.0" text-anchor="middle" font-size="10.5px">B4</text>
<text class="diagram-note" fill="var(--fig-green)" x="76" y="493.0" text-anchor="end" font-size="12px">段4</text>
<rect x="253" y="472" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="279.0" y="493.0" text-anchor="middle" font-size="10.5px">F1</text>
<rect x="307" y="472" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="333.0" y="493.0" text-anchor="middle" font-size="10.5px">F2</text>
<rect x="361" y="472" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="387.0" y="493.0" text-anchor="middle" font-size="10.5px">F3</text>
<rect x="415" y="472" width="51" height="34" rx="4" fill="var(--fig-green)" fill-opacity="0.22" stroke="var(--fig-green)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-green)" x="441.0" y="493.0" text-anchor="middle" font-size="10.5px">F4</text>
<rect x="631" y="472" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="657.0" y="493.0" text-anchor="middle" font-size="10.5px">B1</text>
<rect x="577" y="472" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="603.0" y="493.0" text-anchor="middle" font-size="10.5px">B2</text>
<rect x="523" y="472" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="549.0" y="493.0" text-anchor="middle" font-size="10.5px">B3</text>
<rect x="469" y="472" width="51" height="34" rx="4" fill="var(--fig-gold)" fill-opacity="0.28" stroke="var(--fig-gold)" stroke-width="1.1"/>
<text class="diagram-note" fill="var(--fig-gold)" x="495.0" y="493.0" text-anchor="middle" font-size="10.5px">B4</text>
<rect x="90" y="392" width="54" height="34" fill="var(--fig-red)" fill-opacity="0.12" stroke="none"/>
<rect x="90" y="432" width="108" height="34" fill="var(--fig-red)" fill-opacity="0.12" stroke="none"/>
<rect x="90" y="472" width="162" height="34" fill="var(--fig-red)" fill-opacity="0.12" stroke="none"/>
<rect x="792" y="392" width="54" height="34" fill="var(--fig-red)" fill-opacity="0.12" stroke="none"/>
<rect x="738" y="432" width="108" height="34" fill="var(--fig-red)" fill-opacity="0.12" stroke="none"/>
<rect x="684" y="472" width="162" height="34" fill="var(--fig-red)" fill-opacity="0.12" stroke="none"/>
<line x1="90" y1="518" x2="846" y2="518" stroke="var(--muted)" stroke-width="1.2" marker-end="url(#mk-muted)"/>
<text class="diagram-note" fill="muted" x="846" y="534" text-anchor="end" font-size="12px">时间 →</text>
<text class="diagram-note" fill="var(--fig-red)" x="140" y="534" text-anchor="start" font-size="12px">红影 = 气泡（fill / drain）</text>
<text class="diagram-mono" fill="var(--fig-red)" x="450" y="554" text-anchor="middle" font-size="12px">气泡占比 (P−1)/(M+P−1)：加大 M 或改用 1F1B 调度摊薄</text>
</svg>
<figcaption>三种并行的切法（本教程绘）。**数据并行**切数据、模型每卡全份、梯度 All-Reduce 同步；**张量并行**切单层权重（列切 / 行切成对）、层内就要通信；**流水线并行**按层分段、micro-batch 流动——甘特图中绿色前向与金色反向之间的红色空档即**气泡**，占比 (P−1)/(M+P−1)，靠加大 M 或 1F1B 调度摊薄（9.2–9.4 节）。</figcaption>
</figure>

## 1.2 数据并行（Data Parallel）

最自然的加速方式：不改模型，只把数据摊开。

::: def 定义 9.1 · 数据并行 {#def-9-1}
把 $N$ 张卡组成一个**副本组**：每张卡都保存一份**完整的模型**（参数、梯度、优化器状态），但只处理总批的一个分片。第 $t$ 步的流程为：

1. 每张卡用**自己那份数据**做前向与反向，得到**局部梯度** $\boldsymbol g_i$；
2. 通过 **All-Reduce** 把所有卡的梯度求和、再除以 $N$ 得到平均：
$$\bar{\boldsymbol g}=\frac1N\sum_{i=1}^{N}\boldsymbol g_i ;$$
3. 每张卡用**同一个**平均梯度 $\bar{\boldsymbol g}$ 更新参数。

于是所有副本在每一步末尾**参数完全一致**，逻辑上等价于「批大小为 $B\times N$ 的单卡训练」：$N$ 张卡被用来**加速**，而不改变模型本身。
:::

::: intuition 数据并行「简单」在哪、「贵」在哪
**简单**：不必改模型定义，只改数据加载与梯度同步——所以它是所有框架的默认并行方式，也是「先上数据并行」这条经验的原因。
**贵**：每张卡都存**完整**的模型状态（[例 9.1](#11-问题设定超过单卡容量)里那 $16P$ 字节要复制 $N$ 份），且每步必须**同步一次梯度**。梯度 All-Reduce 的通信量约等于**两份模型大小**，而且**与批大小无关**——批越大，同样的通信被摊到越多计算上，通信占比反而越低。这解释了两条常见经验：**增大批大小能提高扩展效率**；而**梯度累积能省显存、却省不了通信**（它把多个 micro-batch 合进一次同步）。
:::

批大小放大后，学习率通常也要跟着调：常用**线性缩放规则**——批扩大 $k$ 倍，学习率也乘 $k$（并配合**预热**使早期稳定）。记住它是**启发式**，不是定律（见[本讲陷阱](#18-本讲陷阱)）。而当显存装不下想用的批大小时，就用梯度累积来「假装」有一个大批量。

::: method 梯度累积（gradient accumulation） {#method-9-1}
把一个大 batch 拆成 $K$ 个 **micro-batch** 依次前向 / 反向，但**不立刻更新**，而是把梯度累积在缓冲区；攒够 $K$ 个后再做一次优化器更新，并清零梯度：
$$\text{等效批大小}=K\times B_{\text{micro}}\times N .$$

```text
for micro_step = 1 .. K:
    前向 + 反向（梯度累加，不 step）
if micro_step % K == 0:
    All-Reduce 梯度            # 每个“等效 batch”只同步一次
    优化器 step
    梯度清零
```

**要点**：① 损失要按「整个等效 batch」归一化（各 micro-batch 的损失先除以 $K$ 再累加），否则等效批与真大批的梯度尺度不一致；② 它模拟的是**大批量的梯度**，与之接近但不完全相同——依赖批统计的层（BatchNorm）行为会变，而 Transformer 用 LayerNorm，无此顾虑；③ 它省的是**激活显存**（每次只驻留一个 micro-batch），**不省**参数与优化器显存。
:::

::: note 同步更新 vs 异步更新
- **同步（默认）**：每步所有卡都用自己算的梯度、经 All-Reduce 后一起更新。数学上等价于大批量训练、结果可复现；代价是**每步都要等齐**，最慢的卡（straggler）拖住全场，且通信常与计算串行叠加。
- **异步**：卡各自算完就把梯度推给参数服务器并立刻取回最新参数，互不等待。没有同步屏障、吞吐更高，但用的是**陈旧（stale）梯度**——慢卡可能基于若干步之前的参数计算梯度，破坏了「所有副本一致」的前提，收敛更不稳。现代大模型训练**绝大多数用同步 All-Reduce**（配合通信-计算重叠与更快的集合通信算法），异步多用于容错或异构集群。
:::

## 1.3 张量并行（Tensor Parallel）

数据并行解决不了**单卡放不下整个模型**的问题——因为每张卡仍要一份完整模型。要真正「切模型」，从最细的粒度开始：切**单个层的权重矩阵**。

::: def 定义 9.2 · 张量并行（列切与行切） {#def-9-2}
考虑线性层 $\boldsymbol Y=\boldsymbol XA$（$\boldsymbol X$ 为 $B\times d_{\text{in}}$，$A$ 为 $d_{\text{in}}\times d_{\text{out}}$），把 $A$ 切到 $N$ 张卡上：

- **列并行（column parallel）**：按**输出维**把 $A$ 切成 $A_1,\dots,A_N$（每块 $d_{\text{in}}\times\frac{d_{\text{out}}}{N}$），每卡算 $\boldsymbol Y_i=\boldsymbol XA_i$。每卡只需**完整输入** $\boldsymbol X$，得到**输出的一部分**。前向**无需通信**（各持输出的一个列分片）。
- **行并行（row parallel）**：按**输入维**把 $A$ 切成 $A_1,\dots,A_N$（每块 $\frac{d_{\text{in}}}{N}\times d_{\text{out}}$），输入也相应切成 $\boldsymbol X_1,\dots,\boldsymbol X_N$，每卡算部分积 $\boldsymbol X_iA_i$，再 **All-Reduce 求和**得 $\boldsymbol Y=\sum_i\boldsymbol X_iA_i$。

两者的通信模式恰相反：列切**免费**，但把分片留在了输出维；行切要**一次 All-Reduce**，却把结果拼回完整。
:::

::: intuition 为什么「列切 + 行切」必须成对出现
一个 MLP block 为 $\boldsymbol Y=\phi\bigl(\boldsymbol X\,\underbrace{W_1}_{\text{列切}}\bigr)\underbrace{W_2}_{\text{行切}}$——第一层**列并行**，输出在隐维上分片；中间的激活 $\phi$（GELU / ReLU 等）是**逐元素**运算，就在分片上本地做，不必通信；第二层**行并行**，把各卡的部分和用一次 All-Reduce 拼回完整输出。于是一前一后，**每个 MLP block 在前向只需一次 All-Reduce**，通信被压到最低。

若两层都列切，中间结果会一直保持分片、下一层又要重排，反而多出通信；若都行切，输入又要先拼。这种「列—行配对」是刻意设计。注意力同理：**注意力头**天然独立，可把不同的头分到各卡，最后用行并行的输出投影合回。
:::

::: think 张量并行适合谁
张量并行切的是**单个大矩阵**，所以它最擅长对付**超大单层**——例如 Transformer 里那个很宽的前馈网络与巨大的词嵌入。代价是**通信非常频繁**（每层若干次 All-Reduce）且**对延迟敏感**，因此必须跑在**高带宽、低延迟**的链路上：实践中张量并行度通常不超过**单机 GPU 数**，让通信留在 NVLink 内；跨机做张量并行往往得不偿失。
:::

## 1.4 流水线并行（Pipeline Parallel）

另一种切模型的粒度更粗：不切层内的矩阵，而是**把不同的层放到不同的卡上**。这天然契合模型「一层接一层」的结构，就像工厂流水线。

::: def 定义 9.3 · 流水线并行与气泡 {#def-9-3}
把模型的 $L$ 层按顺序切成 $P$ 段（**stage**），第 $j$ 段放到第 $j$ 张卡上。为填满流水线，把一个小批拆成 $M$ 个 **micro-batch** 依次送入：
$$\text{stage }1\to\text{stage }2\to\cdots\to\text{stage }P .$$
micro-batch 1 在第 1 段算完就传给第 2 段，同时 micro-batch 2 进入第 1 段……**各段并行工作**。代价是**启动与收尾**时有卡在空转：开头 $P-1$ 个时间段用来「填充」，结尾 $P-1$ 个用来「排空」，中间这些空档就是**气泡（bubble）**。
:::

::: ex 例 9.2（气泡占多大比例） {#ex-9-2}
设 $P$ 段流水线、每段处理一个 micro-batch 的耗时相同，共 $M$ 个 micro-batch。用最朴素的「先全部前向、再全部反向」调度，求气泡（空闲）时间占总时间的比例。

::: proof 解
把「一个 micro-batch 走完一段」记为一个时间片。理想情况（无气泡）下，$M$ 个 micro-batch 全部流过只需 $M$ 个时间片（每段一直忙）。实际还要加上填充与排空各 $P-1$ 个时间片，故总时长为
$$T_{\text{total}}=M+P-1 .$$
其中第 1 段只在 $M$ 个时间片里忙，其余 $P-1$ 片空转，于是气泡占比
$$\text{bubble}=\frac{P-1}{M+P-1}.$$

**结论**：$M\gg P$ 时气泡趋近于 0。所以要么**增大 micro-batch 数**（切得更细），要么**减少 stage 数**，都能压小气泡——但 micro-batch 太小又会让每段的矩阵乘效率下降，故存在折中。
:::

:::

::: intuition 1F1B：让「前向」和「反向」交替填坑
朴素调度（GPipe 风格）把所有 micro-batch 的**前向**排完再统一做**反向**，需要把全部中间激活留在显存里，峰值很高。**1F1B（One-Forward-One-Backward）** 在预热后让每段交替执行「一个前向、一个反向」：反向一旦能开始就立刻开始，激活可以**尽早释放**，峰值显存大幅下降；同时前向与反向的通信 / 计算也更容易**重叠**。它不消除气泡，但显著改善「同样的卡数能塞下多大的批」，是大模型训练里流水线的默认调度思路。进一步把每张卡负责多个**虚拟段**交错调度，还能再把气泡压小。
:::

::: think 流水线并行 vs 数据并行
两者都「每张卡放一部分、都要通信」，但切的对象完全不同：数据并行**每卡一整份模型**、切**数据**，通信的是**梯度**（大、每步一次）；流水线并行**每卡一段层**、切**模型**，通信的是**段边界的激活**（小、点对点）。因此只有流水线（以及张量）并行能突破「单卡装不下整个模型」的限制，数据并行不能。二者可以**叠加**：把模型切成 $P$ 段，每段再复制 $N$ 份做数据并行——这就是「流水线 × 数据」的二维组合，也是 [1.6](#16-通信与工程)决策清单里的常用配置。
:::

## 1.5 显存优化

切分能解决「放不下」，但切分本身要通信。另一条更「便宜」的路是**直接省显存**。按收益从大到小，三件武器：混合精度、激活重计算、ZeRO / FSDP。

### 混合精度

::: def 定义 9.4 · 混合精度训练与损失缩放 {#def-9-4}
**混合精度**用 16 位浮点（fp16 或 bf16）做**存储与矩阵乘**，同时保留一份 **fp32 主权重**用于参数更新：前向 / 反向走低精度，快且省显存；优化器在 fp32 上更新主权重，再转成低精度供下一步使用，避免小步更新在低精度里被舍入掉。

两种 16 位格式的关键差别在**指数位**：

| 格式 | 符号 / 指数 / 尾数 | 特点 |
|:--|:--|:--|
| fp16 | 1 / 5 / 10 | 精度高，但**动态范围窄**，梯度下溢为 0 或上溢为 inf 的风险大 |
| bf16 | 1 / 8 / 7 | 指数位与 fp32 相同，**范围宽**，通常不需特殊处理；尾数少，精度稍低 |

**损失缩放（loss scaling）**：把损失乘一个因子 $S$（如 $2^{16}$）再反向，使梯度整体放大、逃离 fp16 的下溢区；更新前再除以 $S$ 还原。$S$ 常做成**动态**的（发现溢出就减半，长时间不溢出就翻倍）。bf16 因范围宽，多数情况**不需要**损失缩放。
:::

::: intuition 为什么混合精度「几乎白拿」
显存上：fp16 的权重与梯度只占 2 字节，比 fp32 省一半；算力上：现代 GPU 的 16 位张量核心吞吐远高于 fp32。于是同一张卡能放更大模型、跑得更快——而 fp32 主权重与损失缩放保证了数值上**通常**不掉点。这也是「混合精度是默认配置」的原因：它几乎是零成本的显存与速度红利。**但**它并非「一定不掉点」——fp16 溢出、缩放设置不当都会损害精度，详见[本讲陷阱](#18-本讲陷阱)；bf16 通常更省心。
:::

### 激活重计算

::: intuition 激活重计算（gradient checkpointing）
反向传播需要前向的**中间激活**（[第 1 讲](lec01.md)的反向公式里全是它们）。层数越多、批越大，激活显存越可怕——它常常才是 OOM 的元凶，而且**不受 ZeRO 分片**（ZeRO 分的是模型状态，不是激活）。**激活重计算**的做法是：前向时只在少数「检查点」处保存激活，反向时**按需重新计算**中间结果。代价是**多花一次前向的计算**（对一层而言，前向计算量约为反向的两倍，重算一次相当于整步多花约三分之一），换来激活显存从「随层数线性增长」降到**亚线性**（均匀设检查点时可做到 $\sim\sqrt{L}$ 量级）。一句话：**用算力换显存**——显存是瓶颈、算力有余时，它几乎是必选项。
:::

### ZeRO 与 FSDP

::: def 定义 9.5 · ZeRO 的三级分片 {#def-9-5}
数据并行的每个副本都保存了**完整**的模型状态，这其实是巨大的冗余：$N$ 张卡各存一份一模一样的优化器状态。**ZeRO**（Zero Redundancy Optimizer）把这些**本可平摊**的状态切开放到各卡，分三级递进：

| 阶段 | 分片对象 | 效果 |
|:--|:--|:--|
| **阶段 1** | **优化器状态**（$m$、$v$、fp32 主权重） | 优化器显存降到约 $1/N$，通信量几乎不变 |
| **阶段 2** | 再加 **梯度** | 梯度显存也降到约 $1/N$，用 reduce-scatter 替代 all-reduce |
| **阶段 3** | 再加 **参数** | 参数显存也降到约 $1/N$；算某层前 **all-gather** 该层参数，算完丢弃 |

三级叠加后，每卡的模型状态显存从 $16P$ 降到约 $16P/N$，代价是**更多的集合通信**（阶段越高、通信越频繁）。**FSDP**（Fully Sharded Data Parallel）是同一思想在工程上的实现：参数、梯度、优化器状态**全部分片**，前向 / 反向时按需 all-gather 参数、算完 reduce-scatter 梯度，并在层与层之间**预取**以重叠通信与计算。
:::

::: intuition ZeRO 与「数据并行」的关系
ZeRO 不是一种全新的并行方式，而是**给数据并行打补丁**：数据并行「必须有 $N$ 份完整副本」这个前提没变（副本用于并行处理数据），但 **ZeRO 把副本里冗余的模型状态去掉了**，只在真正计算某一层时才把参数临时聚齐。于是它既保留了数据并行「实现简单、不改模型结构」的优点，又把显存降到了接近张量并行的水平。实践含义：**显存不够时，第一反应应当是「上 ZeRO-2/3 或 FSDP」，而不是立刻去改模型切分**。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 900 360" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-memory-title fig-memory-desc">
<title id="fig-memory-title">训练显存账本：从全冗余到 ZeRO-3/FSDP（每参数字节数）</title>
<desc id="fig-memory-desc">四组堆叠柱分别为单卡数据并行、ZeRO-1、ZeRO-2、ZeRO-3/FSDP 的每参数显存占用（单位字节，按 8 卡分片）：参数、梯度、优化器状态三块中，优化器状态占一半；逐级分片后从 16N 降到 2N 左右。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="238.5" y1="56" x2="238.5" y2="266"/><line x1="399.5" y1="56" x2="399.5" y2="266"/><line x1="560.5" y1="56" x2="560.5" y2="266"/><line x1="721.5" y1="56" x2="721.5" y2="266"/><line x1="150" y1="266.0" x2="810" y2="266.0"/><line x1="150" y1="209.2" x2="810" y2="209.2"/><line x1="150" y1="152.5" x2="810" y2="152.5"/><line x1="150" y1="95.7" x2="810" y2="95.7"/></g>
<g><line x1="238.5" y1="266" x2="238.5" y2="270" stroke="var(--ink-2)"/><text class="fg-muted" x="238.5" y="281" text-anchor="middle">0</text><line x1="399.5" y1="266" x2="399.5" y2="270" stroke="var(--ink-2)"/><text class="fg-muted" x="399.5" y="281" text-anchor="middle">1</text><line x1="560.5" y1="266" x2="560.5" y2="270" stroke="var(--ink-2)"/><text class="fg-muted" x="560.5" y="281" text-anchor="middle">2</text><line x1="721.5" y1="266" x2="721.5" y2="270" stroke="var(--ink-2)"/><text class="fg-muted" x="721.5" y="281" text-anchor="middle">3</text><line x1="146" y1="266.0" x2="150" y2="266.0" stroke="var(--ink-2)"/><text class="fg-muted" x="143" y="270.0" text-anchor="end">0</text><line x1="146" y1="209.2" x2="150" y2="209.2" stroke="var(--ink-2)"/><text class="fg-muted" x="143" y="213.2" text-anchor="end">5</text><line x1="146" y1="152.5" x2="150" y2="152.5" stroke="var(--ink-2)"/><text class="fg-muted" x="143" y="156.5" text-anchor="end">1</text><line x1="146" y1="95.7" x2="150" y2="95.7" stroke="var(--ink-2)"/><text class="fg-muted" x="143" y="99.7" text-anchor="end">15</text><rect x="150" y="56" width="660" height="210" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="110.0" y="161.0" text-anchor="middle" transform="rotate(-90 110.0 161.0)">每参数字节数（byte/param）</text></g>
<rect x="190.2" y="197.9" width="96.6" height="68.1" fill="var(--fig-blue)" fill-opacity="0.32" stroke="var(--fig-blue)"/>
<text class="fg-muted" x="238.5" y="235.9" text-anchor="middle" font-size="12">6</text>
<rect x="190.2" y="175.2" width="96.6" height="22.7" fill="var(--fig-purple)" fill-opacity="0.32" stroke="var(--fig-purple)"/>
<text class="fg-muted" x="238.5" y="190.5" text-anchor="middle" font-size="12">2</text>
<rect x="190.2" y="84.4" width="96.6" height="90.8" fill="var(--fig-green)" fill-opacity="0.32" stroke="var(--fig-green)"/>
<text class="fg-muted" x="238.5" y="133.8" text-anchor="middle" font-size="12">8</text>
<text class="diagram-mono" x="238.5" y="77.4" text-anchor="middle">16.0N</text>
<text class="diagram-note" x="238.5" y="283.0" text-anchor="middle" font-size="13">单卡全冗余</text>
<text class="diagram-note" x="238.5" y="298.0" text-anchor="middle" font-size="13">（数据并行 DP）</text>
<rect x="351.2" y="197.9" width="96.6" height="68.1" fill="var(--fig-blue)" fill-opacity="0.32" stroke="var(--fig-blue)"/>
<text class="fg-muted" x="399.5" y="235.9" text-anchor="middle" font-size="12">6</text>
<rect x="351.2" y="175.2" width="96.6" height="22.7" fill="var(--fig-purple)" fill-opacity="0.32" stroke="var(--fig-purple)"/>
<text class="fg-muted" x="399.5" y="190.5" text-anchor="middle" font-size="12">2</text>
<rect x="351.2" y="163.8" width="96.6" height="11.4" fill="var(--fig-green)" fill-opacity="0.32" stroke="var(--fig-green)"/>
<text class="diagram-mono" x="399.5" y="156.8" text-anchor="middle">9.0N</text>
<text class="diagram-note" x="399.5" y="283.0" text-anchor="middle" font-size="13">ZeRO-1</text>
<text class="diagram-note" x="399.5" y="298.0" text-anchor="middle" font-size="13">（分片优化器）</text>
<rect x="512.2" y="197.9" width="96.6" height="68.1" fill="var(--fig-blue)" fill-opacity="0.32" stroke="var(--fig-blue)"/>
<text class="fg-muted" x="560.5" y="235.9" text-anchor="middle" font-size="12">6</text>
<rect x="512.2" y="195.1" width="96.6" height="2.8" fill="var(--fig-purple)" fill-opacity="0.32" stroke="var(--fig-purple)"/>
<rect x="512.2" y="183.7" width="96.6" height="11.4" fill="var(--fig-green)" fill-opacity="0.32" stroke="var(--fig-green)"/>
<text class="diagram-mono" x="560.5" y="176.7" text-anchor="middle">7.2N</text>
<text class="diagram-note" x="560.5" y="283.0" text-anchor="middle" font-size="13">ZeRO-2</text>
<text class="diagram-note" x="560.5" y="298.0" text-anchor="middle" font-size="13">(+分片梯度)</text>
<rect x="673.2" y="257.5" width="96.6" height="8.5" fill="var(--fig-blue)" fill-opacity="0.32" stroke="var(--fig-blue)"/>
<rect x="673.2" y="254.6" width="96.6" height="2.8" fill="var(--fig-purple)" fill-opacity="0.32" stroke="var(--fig-purple)"/>
<rect x="673.2" y="243.3" width="96.6" height="11.4" fill="var(--fig-green)" fill-opacity="0.32" stroke="var(--fig-green)"/>
<text class="diagram-mono" x="721.5" y="236.3" text-anchor="middle">2.0N</text>
<text class="diagram-note" x="721.5" y="283.0" text-anchor="middle" font-size="13">ZeRO-3 / FSDP</text>
<text class="diagram-note" x="721.5" y="298.0" text-anchor="middle" font-size="13">(+分片参数)</text>
<g><line x1="166" y1="308" x2="192" y2="308" stroke="var(--fig-blue)" stroke-width="2.0"/><text class="diagram-note" x="198" y="312">参数：fp16 主干 2 + fp32 主副本 4</text><line x1="166" y1="327" x2="192" y2="327" stroke="var(--fig-purple)" stroke-width="2.0"/><text class="diagram-note" x="198" y="331">梯度：fp16 2</text><line x1="166" y1="346" x2="192" y2="346" stroke="var(--fig-green)" stroke-width="2.0"/><text class="diagram-note" x="198" y="350">优化器状态 m,v：fp32 8</text></g>
<text class="diagram-note" fill="var(--muted)" x="810.0" y="42.0" text-anchor="end" font-size="13px">N=参数量；此处按 P=8 卡分片</text>
</svg>
<figcaption>「显存去哪了、ZeRO 省在哪」（本教程按 9.1/9.5 节账本计算绘制；N 为参数量，分片按 8 卡）。混合精度 + Adam 下单卡要 **16N**（fp32 主副本 4 + 梯度 2 + m、v 共 8 + fp16 参数 2）；ZeRO 逐级把优化器状态 → 梯度 → 参数分片到各卡，16N → 2N 量级——7B 模型从「单卡放不下」变「单卡放下模型状态」，这是 9.5 节的核心。</figcaption>
</figure>

## 1.6 通信与工程

并行方案的效果最终由**通信**决定。要会做两个估算：通信**量**（多少数据过线）与通信**频率 / 延迟**（多密、多急）。

::: note All-Reduce 的通信量：为什么是「两倍模型大小」
多卡求和（All-Reduce）最常用的**环状（ring）算法**让数据在卡间切成小块、绕环传递。对大小为 $S$ 的消息，每张卡的通信量约为
$$2S\cdot\frac{N-1}{N}\ \xrightarrow{\ N\ \text{较大}\ }\ 2S .$$
用于**梯度同步**时 $S\approx$ 模型大小（字节），所以每步通信量约等于**两份模型**，而且**与批大小无关**。由此得到几条实用推论：

- **增大批大小**（或梯度累积）能提高「计算 / 通信」比，扩展效率更好；
- **模型越大，通信越贵**，数据并行的可扩展性越差；
- All-Reduce 可分解为 **reduce-scatter + all-gather**，两者各约 $S$——这正是 ZeRO 阶段 2/3 复用的通信原语。
:::

三种并行各切什么、怎么通信，一表看清：

| 维度 | 数据并行 DP | 张量并行 TP | 流水线并行 PP |
|:--|:--|:--|:--|
| **切什么** | 数据（模型复制） | 单层权重矩阵 | 层的分段 |
| **每卡存什么** | 完整模型状态（ZeRO 后分片） | 一层的一部分 | 一段层 |
| **通信内容** | 梯度（每步一次） | 激活（每层若干次） | 段边界激活（点对点） |
| **通信量 / 频率** | 大 / 低 | 中 / 极高 | 小 / 中 |
| **对链路的要求** | 中（可跨机） | **高（需 NVLink）** | 低（可跨机） |
| **主要解决** | 加速、扩大批 | 单卡装不下大层 | 单卡装不下整模型 |

::: note 拓扑：NVLink 与 InfiniBand 各管一段
一个 GPU 集群通常分两级网络：**节点内**用 **NVLink** 之类的高速互联，带宽最高、延迟最低；**节点间**用 **InfiniBand / RoCE** 之类的网络，带宽低一个数量级、延迟也更高。安排并行时按「通信密集程度」对号入座：

- **张量并行**：通信最频繁、最吃延迟 → 放在**节点内**（NVLink），并行度一般不超过单机 GPU 数；
- **流水线并行**：只在段边界传激活，量小 → 可以跨节点；
- **数据并行 / ZeRO**：每步一次大 All-Reduce → 跨节点也可，但要注意带宽。

此外要主动做 **通信与计算重叠**：把下一层的参数预取、把梯度 All-Reduce 与反向计算分块交错，让网卡与计算单元同时忙——这是「跑得满」的关键工程手段。
:::

::: method 决策清单：给定硬件怎么选并行策略 {#method-9-2}
先问三个问题，再按清单办。

**问题 1：单卡装得下整个模型（含优化器状态）吗？**
- 装得下 → 用**数据并行**（+ 梯度累积调批大小）；显存紧就加 **ZeRO-1/2** 与**混合精度 / 激活重计算**。
- 装不下 → 进入问题 2。

**问题 2：是「某几层特别大」，还是「层数太多、整体太大」？**
- 单层 / 单个矩阵大到切不开 → 用**张量并行**（度 ≤ 单机 GPU 数，跑 NVLink）。
- 整体层数多 → 用**流水线并行**（micro-batch 数取大以压气泡，优先 **1F1B**）。

**问题 3：显存目标还差多少？**
- 差得多 → 上 **ZeRO-3 / FSDP**（参数也分片）；差一点 → ZeRO-2 往往够。

**组合与调优**：
- 大规模训练通常是 **3D 并行**：张量并行（机内）$\times$ 流水线并行（跨机）$\times$ 数据并行（最外层）。
- 之后按顺序调：**micro-batch 大小**（压气泡、提效率）→ **梯度累积**（补等效批）→ **重计算粒度**（换显存）→ **学习率**（配合批大小放大，记得预热）。
- **永远先测量再切分**：先看是 OOM（显存瓶颈）还是 GPU 利用率低（通信 / 气泡瓶颈），别凭感觉堆卡。**扩展效率 = 实际加速比 / 卡数**，它才是真正的验收指标。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 880 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-bubble-title fig-bubble-desc">
<title id="fig-bubble-title">流水线气泡占比随 micro-batch 数的变化</title>
<desc id="fig-bubble-desc">三条曲线分别为流水线段数 P=2、4、8 时气泡占比 (P−1)/(M+P−1) 随 micro-batch 数 M 的衰减。P 越大气泡越重，需要更大的 M 来摊薄；红色虚线为 20% 的常用可接受上限。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="110.0" y1="46" x2="110.0" y2="246"/><line x1="270.0" y1="46" x2="270.0" y2="246"/><line x1="430.0" y1="46" x2="430.0" y2="246"/><line x1="590.0" y1="46" x2="590.0" y2="246"/><line x1="750.0" y1="46" x2="750.0" y2="246"/><line x1="110" y1="246.0" x2="750" y2="246.0"/><line x1="110" y1="206.0" x2="750" y2="206.0"/><line x1="110" y1="166.0" x2="750" y2="166.0"/><line x1="110" y1="126.0" x2="750" y2="126.0"/><line x1="110" y1="86.0" x2="750" y2="86.0"/><line x1="110" y1="46.0" x2="750" y2="46.0"/></g>
<g><line x1="110.0" y1="246" x2="110.0" y2="250" stroke="var(--ink-2)"/><text class="fg-muted" x="110.0" y="261" text-anchor="middle">0</text><line x1="270.0" y1="246" x2="270.0" y2="250" stroke="var(--ink-2)"/><text class="fg-muted" x="270.0" y="261" text-anchor="middle">1</text><line x1="430.0" y1="246" x2="430.0" y2="250" stroke="var(--ink-2)"/><text class="fg-muted" x="430.0" y="261" text-anchor="middle">2</text><line x1="590.0" y1="246" x2="590.0" y2="250" stroke="var(--ink-2)"/><text class="fg-muted" x="590.0" y="261" text-anchor="middle">3</text><line x1="750.0" y1="246" x2="750.0" y2="250" stroke="var(--ink-2)"/><text class="fg-muted" x="750.0" y="261" text-anchor="middle">4</text><line x1="106" y1="246.0" x2="110" y2="246.0" stroke="var(--ink-2)"/><text class="fg-muted" x="103" y="250.0" text-anchor="end">0</text><line x1="106" y1="206.0" x2="110" y2="206.0" stroke="var(--ink-2)"/><text class="fg-muted" x="103" y="210.0" text-anchor="end"></text><line x1="106" y1="166.0" x2="110" y2="166.0" stroke="var(--ink-2)"/><text class="fg-muted" x="103" y="170.0" text-anchor="end"></text><line x1="106" y1="126.0" x2="110" y2="126.0" stroke="var(--ink-2)"/><text class="fg-muted" x="103" y="130.0" text-anchor="end">1</text><line x1="106" y1="86.0" x2="110" y2="86.0" stroke="var(--ink-2)"/><text class="fg-muted" x="103" y="90.0" text-anchor="end">1</text><line x1="106" y1="46.0" x2="110" y2="46.0" stroke="var(--ink-2)"/><text class="fg-muted" x="103" y="50.0" text-anchor="end">1</text><rect x="110" y="46" width="640" height="200" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="430.0" y="279" text-anchor="middle">micro-batch 数 M</text><text class="fg-label" x="70.0" y="146.0" text-anchor="middle" transform="rotate(-90 70.0 146.0)">气泡占比 (P−1)/(M+P−1)</text></g>
<polyline fill="none" stroke="var(--fig-gold)" stroke-width="2.6"stroke-linejoin="round" stroke-linecap="round" points="126.0,146.0 142.0,179.3 158.0,196.0 174.0,206.0 190.0,212.7 206.0,217.4 222.0,221.0 238.0,223.8 254.0,226.0 270.0,227.8 286.0,229.3 302.0,230.6 318.0,231.7 334.0,232.7 350.0,233.5 366.0,234.2 382.0,234.9 398.0,235.5 414.0,236.0 430.0,236.5 446.0,236.9 462.0,237.3 478.0,237.7 494.0,238.0 510.0,238.3 526.0,238.6 542.0,238.9 558.0,239.1 574.0,239.3 590.0,239.5 606.0,239.8 622.0,239.9 638.0,240.1 654.0,240.3 670.0,240.4 686.0,240.6 702.0,240.7 718.0,240.9 734.0,241.0 750.0,241.1"/>
<circle fill="var(--fig-gold)" cx="238.0" cy="223.8" r="3.4"/>
<circle fill="var(--fig-gold)" cx="366.0" cy="234.2" r="3.4"/>
<polyline fill="none" stroke="var(--fig-blue)" stroke-width="2.6"stroke-linejoin="round" stroke-linecap="round" points="126.0,96.0 142.0,126.0 158.0,146.0 174.0,160.3 190.0,171.0 206.0,179.3 222.0,186.0 238.0,191.5 254.0,196.0 270.0,199.8 286.0,203.1 302.0,206.0 318.0,208.5 334.0,210.7 350.0,212.7 366.0,214.4 382.0,216.0 398.0,217.4 414.0,218.7 430.0,219.9 446.0,221.0 462.0,222.0 478.0,222.9 494.0,223.8 510.0,224.6 526.0,225.3 542.0,226.0 558.0,226.6 574.0,227.2 590.0,227.8 606.0,228.4 622.0,228.9 638.0,229.3 654.0,229.8 670.0,230.2 686.0,230.6 702.0,231.0 718.0,231.4 734.0,231.7 750.0,232.0"/>
<circle fill="var(--fig-blue)" cx="238.0" cy="191.5" r="3.4"/>
<circle fill="var(--fig-blue)" cx="366.0" cy="214.4" r="3.4"/>
<polyline fill="none" stroke="var(--fig-purple)" stroke-width="2.6"stroke-linejoin="round" stroke-linecap="round" points="126.0,71.0 142.0,90.4 158.0,106.0 174.0,118.7 190.0,129.3 206.0,138.3 222.0,146.0 238.0,152.7 254.0,158.5 270.0,163.6 286.0,168.2 302.0,172.3 318.0,176.0 334.0,179.3 350.0,182.4 366.0,185.1 382.0,187.7 398.0,190.0 414.0,192.2 430.0,194.1 446.0,196.0 462.0,197.7 478.0,199.3 494.0,200.8 510.0,202.2 526.0,203.6 542.0,204.8 558.0,206.0 574.0,207.1 590.0,208.2 606.0,209.2 622.0,210.1 638.0,211.0 654.0,211.9 670.0,212.7 686.0,213.4 702.0,214.2 718.0,214.9 734.0,215.6 750.0,216.2"/>
<circle fill="var(--fig-purple)" cx="238.0" cy="152.7" r="3.4"/>
<circle fill="var(--fig-purple)" cx="366.0" cy="185.1" r="3.4"/>
<text class="diagram-mono" fill="var(--fig-gold)" x="532.0" y="242.6" text-anchor="start">P=2</text>
<text class="diagram-mono" fill="var(--fig-blue)" x="532.0" y="229.3" text-anchor="start">P=4</text>
<text class="diagram-mono" fill="var(--fig-purple)" x="532.0" y="207.6" text-anchor="start">P=8</text>
<polyline fill="none" stroke="var(--fig-red)" stroke-width="1.4"stroke-linejoin="round" stroke-linecap="round" stroke-dasharray="7 5" points="110.0,206.0 750.0,206.0"/>
<text class="diagram-note" fill="var(--fig-red)" x="742.0" y="198.0" text-anchor="end">20%：工程上常可接受的气泡上限</text>
</svg>
<figcaption>气泡怎么摊薄（本教程按 (P−1)/(M+P−1) 计算绘制；圆点为 M=8 与 M=16）。段数 P 越多气泡越重：P=8 时 M=8 的气泡占 46%，把 M 提到 16 才压到 29%——「**加卡必加 micro-batch**」不是经验主义，是这条双曲线的必然（见 9.4 节）。</figcaption>
</figure>

## 1.7 与 Lab 3 的连接

上面所有手段都假定「你有一批 GPU，要把它们用满」。但更常见的情形是：**只有一块（或很少几块）显存有限的卡，想微调一个大模型**。此时把大模型的状态全塞进显存仍不可能，而 ZeRO / 张量并行又需要多卡——出路是**参数高效微调（PEFT）**：不训练全部参数，只训练极少数新增参数。

::: def 定义 9.6 · LoRA（低秩适配） {#def-9-6}
**LoRA**（Low-Rank Adaptation）把要更新的权重写成「原权重 + 低秩修正」：
$$W=W_0+\Delta W=W_0+\frac{\alpha}{r}\,BA,$$
其中 $W_0\in\mathbb R^{d\times k}$ 是**冻结**的预训练权重，$B\in\mathbb R^{d\times r}$、$A\in\mathbb R^{r\times k}$ 是**可训练**的低秩矩阵，$r\ll\min(d,k)$（常取几到几十）。初始化使训练开始时 $\Delta W=0$（如 $B=0$），不破坏已有能力。**只有 $A$、$B$ 参与优化**——参数量、梯度与优化器状态都从 $O(dk)$ 降到 $O(r(d+k))$。
:::

::: intuition 为什么 LoRA 在受限算力下如此关键
对照 [@ex-9-1] 的账本就清楚了：全参数微调时，光优化器状态就要 $16$ 字节 / 参数，动辄上 TB；而 LoRA 冻结主干后，需要优化器**照料的只有那对极小的低秩矩阵**，优化器显存几乎可以忽略。同时主干权重可以低精度只读驻留。于是**一块消费级 GPU 就能微调一个原本「装不下」的模型**——这正是 [Lab 3](../labs/lab3.md) 的立足点：预训练主干已经给出通用能力，微调要做的往往只是「把它对齐到你的任务」，而这件事所需的改动量常常是**低秩**的。它也是 RLHF（[第 5 讲](lec05.md)）里给大模型做 SFT / 偏好优化的现实做法。

**与并行的关系**：LoRA 不是并行的替代，而是「先问要不要并行」的答案——**如果改动量本就很小，就别去付出通信与切分的代价**。当真要全参数训练时，再回到本讲的 DP / TP / PP / ZeRO 工具箱。
:::

## 1.8 本讲陷阱

::: errata 常见误解清单
1. **「加卡就能线性加速」**：加速比等于卡数，只在**通信为零、负载完美均衡**的理想世界成立。现实中每加一批卡，通信开销、同步等待与流水线气泡都在增长，实际加速比 $<\;$卡数。**要盯扩展效率，而不是只看总吞吐**；卡数翻倍而吞吐只涨一点，说明瓶颈在通信或气泡，此时加卡无用。
2. **「混合精度一定不掉点」**：fp16 动态范围窄，梯度会**下溢为 0** 或**上溢为 inf / nan**；不做**损失缩放**、或缩放因子设置不当，训练会悄悄坏掉（损失突然变 nan）。bf16 通常更省心，但仍要**在验证集上核对**，别把「开了混合精度」当成「精度无损」的承诺。
3. **「流水线并行等于数据并行」**：两者切的东西完全不同——数据并行切**数据**、每卡一份完整模型；流水线并行切**模型层**、每卡一段。只有流水线（以及张量）并行才能让「单卡装不下整个模型」成为可能；数据并行永远要求每卡放得下完整模型状态（除非叠加 ZeRO）。
4. **「大批量必然学得更好，直接把学习率放大就行」**：批大小 $\times k$ 时常配合学习率 $\times k$（线性缩放规则），但这是**启发式**，在很大批下往往需要**学习率预热**、甚至改用更温和的缩放（如按平方根），否则训练早期就会发散。
5. **「张量并行度可以随便设」**：张量并行通信频繁且延迟敏感，一旦**跨节点**（走 InfiniBand 而非 NVLink），收益常被通信吃掉。实践上把张量并行限制在**单机之内**，别硬跨机。
6. **「ZeRO 阶段越高越好」**：分片越彻底，**通信越多**（阶段 3 每算一层都要 all-gather 参数）。阶段 1/2 常常已经够用；盲目上阶段 3 可能换来更慢的训练。
7. **「只算参数量，忘了激活」**：激活随**批大小与序列长度**增长，常常才是 OOM 的元凶，而它**不受** ZeRO 分片影响（ZeRO 分的是模型状态）。激活装不下要靠**减小 micro-batch / 梯度累积 / 激活重计算**。
8. **「数据并行的通信量随批大小增长」**：恰恰相反——梯度 All-Reduce 的通信量由**模型大小**决定，与批大小**无关**。所以增大批大小（或梯度累积）能提高计算 / 通信比、改善扩展效率。以为「批大了通信也大」会得出相反的结论。
9. **「分布式训练结果应当逐比特可复现」**：浮点求和的**结合律不成立**，归约顺序、通信实现的差异都会带来微小数值差别。单卡与多卡、不同并行配置下结果**通常不会逐位相同**，只要在容差内、指标一致即可。
:::

## 1.9 本讲小结

**三句话带走**：

1. 大规模训练撞的两堵墙是**显存**与**通信**，不是纯算力；一条对策是**切**（数据并行 / 张量并行 / 流水线并行，可组合成 3D 并行），一条是**省**（混合精度、激活重计算、ZeRO / FSDP 分片冗余状态）。
2. 三者各司其职且通信模式迥异：**数据并行**切数据、每步 All-Reduce 梯度（通信量与批大小无关）；**张量并行**切单层权重、列切 / 行切成对出现、通信密集要放在 NVLink 内；**流水线并行**切层、按 micro-batch 流动、气泡占比 $\approx\dfrac{P-1}{M+P-1}$，靠增大 micro-batch 与 1F1B 改善。**显存不够时，ZeRO / FSDP 常常是最省心的第一选择。**
3. 并行是**工程权衡**：先测量瓶颈（OOM 还是空转），再选策略——**扩展效率才是验收指标**。而当算力受限、只想做微调时，**LoRA 这类参数高效方法**往往比任何并行技巧都更省。

**与后续的连接**：本讲把前八讲的「模型怎么设计」补上了「**这么大的模型怎么训起来**」这一环——反向传播与梯度下降（[第 1 讲](lec01.md)）依旧是不变的地基，而 Adam 的优化器状态正是 [1.5](#15-显存优化)里最占显存的那一项。Transformer 的巨大单层（[第 2 讲](lec02.md)中的自注意力与前馈网络）是张量并行的主战场；[第 6 讲](lec06.md)讲的「规模为何带来能力」，其背后的训练工程就是本讲；而 RLHF（[第 5 讲](lec05.md)）里对大模型做 SFT 与偏好优化，也绕不开这里的显存账本与并行抉择。最后，[Lab 3](../labs/lab3.md) 用一个真实的大语言模型微调任务，让你亲手体会「冻结主干、只训低秩适配器」如何把本讲的全部显存账本变得可以承受。
