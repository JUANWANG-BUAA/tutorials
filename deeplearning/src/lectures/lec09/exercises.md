# 第 9 讲习题集

> 四组难度递进：**A 概念判断 → B 推导证明 → C 编程实现 → D 开放设计**。答案默认折叠，点击展开。
> 用法：先闭卷做 A 组，再对照答案；B 组**手写**推导（涉及形状与账本口径的先写清楚）；C 组上机并跑通验收标准；D 组写成半页方案（方案 + 理由 + 失败判据 + 验证计划）。
> 考点范围限[导览](overview.md) 与 [9.1](sec91.md)–[9.7](sec97.md)，答案均可在正文定位。凡正文标注「需核实」的数字，答案里也要带上这个标注。

## A 组 · 概念判断（8 题）

**判定要求**：必须给**一句话理由或反例**，只写「对 / 错」不给分；涉及数字的必须写出算式。

**A1.** 「混合精度训练能把 7B 模型的**静态**显存从 112 GB 砍到 56 GB。」（依据：[9.1.2](sec91.md#sec-9.1.2)、[例 9.5.1](sec95.md#ex-9.5.1)）

::: sol 答案
**错。** 混合精度把参数与梯度从 $4N+4N$ 压到 $2N+2N$（省 $4N$），但低精度参数上做小步更新会被舍入吃掉（bf16 只有 8 位尾数），因此必须另存 fp32 主权重 $4N$——**省下的正好被吃回去**。故纯 fp32 Adam 与混合精度 Adam 的静态账都是 $16N=112$ GB，只是组成不同（前者 $4+4+8$，后者 $2+2+8+4$）。混合精度真正的红利是**算力吞吐**（16 位张量核心）与**激活 / 临时张量**（bf16 存储直接减半）。要动静态账必须动优化器状态：8-bit 优化器 $16N\to10N$（$112\to70$ GB，省 37.5%）。
:::

**A2.** 「把 $B_{\text{micro}}$ 从 4 降到 1 能显著降低优化器状态的显存占用。」（依据：[定义 9.1.1](sec91.md#def-9.1.1)、[9.1.3](sec91.md#sec-9.1.3)）

::: sol 答案
**错。** 模型状态（参数、梯度、$m$、$v$、主权重）只与参数量 $N$ 成正比，**与批大小无关**；$B_{\text{micro}}$ 只决定「一次有多少 token 的激活在场」。降 $B_{\text{micro}}$ 降的是激活，而且通常要配梯度累积把等效批补回来（[定义 9.2.2](sec92.md#def-9.2.2)）。这句话的方向没错但对象错了——「降批省显存」省的是另一本账。
:::

**A3.** 「批越大，梯度 All-Reduce 的通信量越大，所以大批训练更难跨机。」（依据：[结论 9.2.1](sec92.md#thm-9.2.1)、[9.2.2](sec92.md#sec-9.2.2)）

::: sol 答案
**错，两句话都站不住。** 通信量 $V=2S(k-1)/k\approx2S$，$S$ 是**梯度张量的字节数**，只由模型结构决定（bf16 下 $S=2N$），与批大小、micro-batch 数**完全无关**。批越大，同样的通信摊到更多的矩阵乘上，**通信占比反而更低**。真正让通信占比失控的是「**每卡 token 数太少**」（小批、短序列），这也解释了为什么大规模训练偏爱「小卡数 × 大批 × 长序列」。
:::

**A4.** 「ZeRO 阶段越高训练越快：显存更省，还能开更大的批。」（依据：[定义 9.2.3](sec92.md#def-9.2.3)、[方法 9.2.2](sec92.md#method-9.2.2)）

::: sol 答案
**错。** 三级的分片是递进的，通信代价**不单调**：ZeRO-1 分优化器状态，通信不变（仍一次 All-Reduce）；ZeRO-2 再分梯度，因为每卡只需自己那 $1/k$ 份，可用 reduce-scatter 替代 All-Reduce，通信**减半**；ZeRO-3 连参数也分，于是每次用参数都要先 all-gather，通信**升至约 1.5 倍**（该倍数随分片粒度与预取实现变化，需实测）。$k$ 小（2–4 卡）、模型本来就放得下、跨机小消息多、序列短批小时，分片**反而更慢**。判据：能放下就用 DP + ZeRO-1/2，放不下才上 ZeRO-3 / FSDP2。
:::

**A5.** 「开了 ZeRO-3 / FSDP 之后就不需要激活重计算了。」（依据：[方法 9.1.1](sec91.md#method-9.1.1)、[9.1.3](sec91.md#sec-9.1.3)）

::: sol 答案
**错。** 两者管的是不同的账：ZeRO-3 分的是**模型状态**（参数、梯度、优化器状态、主权重），激活一分不减，而且分片手段（ZeRO-1/2/3）**完全不作用于激活**。这正是「优化器分片做到极限仍然 OOM」的原因。激活的旋钮只有四个：$B_{\text{micro}}$ / $T$、梯度累积、激活重计算、序列并行（[9.1.5](sec91.md#sec-9.1.5) 的情形 B）。
:::

**A6.** 「把张量并行度 $k$ 翻倍，每卡的通信量就减半。」（依据：[例 9.3.1](sec93.md#ex-9.3.1)、张量并行的通信量陷阱框）

::: sol 答案
**错。** 每卡流量 $V=2S(k-1)/k$ 中的 $S$ 是**完整输出张量的字节数**，与 $k$ 无关（分片只发生在**权重**上，归约发生在**完整输出**上）。所以 $k$ 变大时每卡通信量几乎不变（只从 $S$ 缓慢趋近 $2S$），变的只是「消息更小、次数更多」——在带宽受限时没好处，在**延迟受限**时还有害。这也是「TP 度不要超过单机 GPU 数」之外的第二条约束：**能靠更大批解决的问题，不要靠更大 TP 度解决**。
:::

**A7.** 「流水线并行能解决『单层放不下』的问题。」（依据：[定义 9.4.1](sec94.md#def-9.4.1)、[方法 9.1.2](sec91.md#method-9.1.2)）

::: sol 答案
**错。** 流水线并行切的是**层**，一个层本身仍必须放进一张卡——它解决的是「整体放不下」（第 $j$ 段只存自己那几层，每卡模型状态 $16N/P$）。单层放不下（大词表 embedding、超宽 FFN、实体化注意力矩阵）对应情形 C，只能靠**张量并行**（或 TP × PP 叠加）。代价也不同：PP 付气泡 $\frac{P-1}{M+P-1}$ 与段间 P2P，TP 付每层多次 All-Reduce 且必须留在 NVLink 内。
:::

**A8.** 「FP8 也需要缩放，所以照着 fp16 的损失缩放配方做就行。」（依据：[定义 9.5.1](sec95.md#def-9.5.1)、[定义 9.5.2](sec95.md#def-9.5.2)、FP8 陷阱框）

::: sol 答案
**错，粒度不同。** fp16 的 **loss scaling** 是**一个标量乘在损失上**（把整条反向的梯度抬离 $6\times10^{-8}$ 以下的下溢区），只需看损失一个量；FP8 的缩放是**逐张量（甚至逐块）一个因子**，还要用上一步的统计量做**延迟缩放**，才能把缩放计算藏进重叠窗口。另一处常见混淆：FP8 省的只是「存 FP8 的那部分」（激活、部分权重副本），主权重与优化器状态仍是 fp32（$12N$），一分不减。
:::

## B 组 · 推导与证明（6 题）

> 要求：关键步骤逐条写出，不许写「略」；涉及形状与口径的先写清楚（精度、优化器、是否含主权重）。

**B1.** 从「一次训练步骤必须同时驻留的五类张量」出发，**逐项**推导混合精度 Adam 下的 $16N$ 规则；给出三种口径的组成对照（纯 fp32 Adam / 混合精度 Adam / 混合精度 + 8-bit 优化器），并算出 $N=7\times10^{9}$、$1\,\text{GB}=10^{9}$ 字节时的数字。（依据：[方法 9.1.1](sec91.md#method-9.1.1)、[例 9.1.1](sec91.md#ex-9.1.1)、[附录 C.18](../../appendix/derivations.md)）

::: sol 提示与答案
**逐项（每项写成「字节/参数 × $N$」）：** ① 参数：前向与反向都要读，bf16 存储 → $2N$；② 梯度：与参数同精度 → $2N$；③ 优化器状态：Adam 的一阶 / 二阶矩 $m,v$ **必须 fp32**（其数值尺度随梯度方差估计变化，16 位会让长期累积的动量被舍入噪声污染）→ $4N+4N=8N$；④ 主权重：更新式 $w_{\text{fp32}}\leftarrow w_{\text{fp32}}-\eta\hat g$ 需要一份高精度副本（$\eta\hat g$ 的量级常小于 bf16 在该权重附近的间隔，直接更新 16 位参数会出现「加了等于没加」）→ $4N$；⑤ 激活另计（$\propto B_{\text{micro}}T\,L$，不计入常数项）。
$$M_{\text{state}}\approx 2N+2N+8N+4N=\mathbf{16N}\ \text{字节}.$$

**三种口径对照**（注意「纯 fp32」不需要独立主权重，因为参数本身就是 fp32）：

| 口径 | 参数 | 梯度 | $m,v$ | 主权重 | 合计 |
|:--|:--|:--|:--|:--|:--|
| 纯 fp32 Adam | $4N$ | $4N$ | $8N$ | $0$ | $16N$ |
| 混合精度 Adam | $2N$ | $2N$ | $8N$ | $4N$ | $16N$ |
| 混合精度 + 8-bit 优化器 | $2N$ | $2N$ | $2N$ | $4N$ | $10N$ |

**7B 数字**：混合精度 Adam 与纯 fp32 Adam 均为 $112$ GB，逐项 $14+14+28+28+28=112$ ✔（其中 $m$ 与 $v$ 各 $28$ GB、主权重 $28$ GB）；8-bit 优化器 $=10N=70$ GB，省 $37.5\%$。
**两条读法**：优化器相关（$m,v$+主权重）$12N$ 占 $75\%$，参数与梯度只有 $4N$；fp32 相关的 $12N$ 全部来自「为了数值稳定而保留高精度」。推理期只需低精度参数 + KV cache（$2N$ 量级）——这就是「训练比推理难得多」在显存上的定量来源。
:::

**B2.** 推导环状 All-Reduce 的每卡通信量 $V_{\text{ring}}(S)=2S(k-1)/k$；说明它为什么**与批大小无关**；代入 7B 模型（bf16 梯度、$k=8$）算出每卡流量与 InfiniBand（$\beta\approx50$ GB/s）、NVLink（$\approx300$ GB/s）下的时间；再算出 ZeRO-2 的 reduce-scatter 版本。（依据：[结论 9.2.1](sec92.md#thm-9.2.1)、[例 9.2.2](sec92.md#ex-9.2.2)、[例 9.6.1](sec96.md#ex-9.6.1)）

::: sol 提示与答案
**（1）两阶段接力。** 把张量切成 $k$ 块，把 $k$ 张卡排成一个环。
**第一阶段 reduce-scatter**：每一轮，每张卡把手上的一块发给右邻、同时从左邻收一块并**加到自己的对应块上**；转 $k-1$ 轮后，每一块的**总和**恰好落在某一张卡上，每张卡发出的量是 $(k-1)\times S/k=S(k-1)/k$。
**第二阶段 all-gather**：把已经算好的块沿环继续传，每张卡收齐 $k$ 块即得到完整结果，发送量同样是 $S(k-1)/k$。
$$V_{\text{ring}}(S)=2\times\frac{k-1}{k}S\xrightarrow{k\ \text{较大}}2S .$$
（下界论证：每个字节至少要「被每张卡看见一次」，故 $S$ 是下界；环状算法只用两倍下界，且并发走满所有链路、不依赖中心节点。）

**（2）为什么与批无关。** 通信的对象是**梯度张量**，其形状只由模型结构决定；批大小决定的是「算出这个梯度花了多少矩阵乘」，因此批影响**计算 / 通信比**，不影响通信量本身。推论：加卡让通信量略微增大（$2S(k-1)/k$ 逼近 $2S$）而计算按卡数摊薄，所以「卡越多、每卡计算越少、通信占比越高」。

**（3）代入。** $S=2N=2\times7\times10^{9}=14$ GB（bf16 梯度）。
$$V=2\times\frac{7}{8}\times14=24.5\ \text{GB/卡};\qquad t_{\text{IB}}=\frac{24.5}{50}\approx0.49\ \text{s},\qquad t_{\text{NV}}=\frac{24.5}{300}\approx0.08\ \text{s}.$$
（两者都是**乐观下界**：没有减去与计算的重叠，也没有计入延迟与小消息效率损失。）

**（4）ZeRO-2 版本。** 每卡只需要自己那 $1/k$ 份梯度，不需要各自拿到完整平均梯度，于是用「只归约不广播」的 reduce-scatter 替代 All-Reduce：
$$V=\frac{k-1}{k}S=\frac78\times14=12.25\ \text{GB/卡}\Rightarrow t_{\text{IB}}=\frac{12.25}{50}\approx0.25\ \text{s},$$
正好省一半——这就是 ZeRO-2「通信减半」的全部来源。
:::

**B3.** 推导朴素调度（GPipe 风格）下的气泡占比 $\dfrac{P-1}{M+P-1}$，说明每一一步在算什么；然后算 $P=8$、$M=16$ 与 $M=64$ 的气泡率，并求出「气泡 ≤10%」所需的 $M$。（依据：[结论 9.4.1](sec94.md#thm-9.4.1)、[例 9.4.1](sec94.md#ex-9.4.1)）

::: sol 提示与答案
**（i）有效工作量。** 每个 stage 都要处理**全部** $M$ 个 micro-batch（前向一次、反向一次）。把「一个 micro-batch 走完一段」记为一个时间片，每个 stage 的有效工作量为 $M$ 个时间片（教学口径：把一次前向或一次反向都折算成 1 个单位）。

**（ii）墙钟时间由末段决定。** 第 1 个 micro-batch 跑到最后一段需要 $P$ 个时间片；此后每 1 个时间片就有下一个 micro-batch 进入最后一段，于是最后一段处理完 $M$ 个 micro-batch 需要 $M+P-1$ 个时间片。反向按相反顺序进行，同样 $M+P-1$，且前向与反向可部分重叠，故整条流水线的总时长为
$$T_{\text{total}}=M+P-1 .$$
（更严格的论证：第 $j$ 段的启动延迟为 $j-1$，任何 stage 的完工时刻 $\ge M+(\text{启动延迟})$，最慢的末段决定下界 $M+P-1$；GPipe 调度把每段空闲压到最小，故取等号。）

**（iii）气泡 = 墙钟 − 有效。** 每卡有效时间 $M$、墙钟 $M+P-1$，空闲 $P-1$：
$$\text{bubble}=\frac{P-1}{M+P-1}.$$
**两个极限**：$M\to\infty$ 时气泡 $\to0$；$M\ll P$ 时气泡 $\to\frac{P-1}{P}\approx1$（几乎全程空转，等于白买卡）。

**代入**：$P=8,M=16$ → $7/23=30.4\%$（利用率 69.6%）；$M=64$ → $7/71=9.9\%$。**10% 条件**：$\frac{7}{M+7}\le0.1\Rightarrow M+7\ge70\Rightarrow M\ge63\approx9P$ —— 即 $M$ 取 $P$ 的若干倍（约 9 倍）才能把气泡压到 10% 以内。
**口径说明**：本推导把前向与反向折算成等长时间片；实际反向约为前向的两倍耗时，更精确的公式会带一个前 / 反向时间比因子（系数随实现变化，**需实测校准**），但结论方向完全一致：气泡随 $P$ 增大、随 $M$ 减小。
:::

**B4.** 写清列切与行切的**形状**与「是否需要通信」的论证；说明为什么「列切 → 逐元素激活 → 行切」是唯一能把一个块压到一次归约的组合；再代入 $h=4096$、FFN 隐维 $4h=16384$、$k=8$、$B_{\text{micro}}=4$、$T=2048$、bf16，算出一次归约的消息大小、每卡每次的通信量、每层前向的通信量、32 层每步的总量，以及 NVLink / IB 下的时间。（依据：[定义 9.3.1](sec93.md#def-9.3.1)、[结论 9.3.1](sec93.md#thm-9.3.1)、[例 9.3.1](sec93.md#ex-9.3.1)）

::: sol 提示与答案
**（1）两种切法（形状先行）。** 设 $\boldsymbol Y=\boldsymbol XA$，$\boldsymbol X\in\mathbb R^{B\times d_{\text{in}}}$、$A\in\mathbb R^{d_{\text{in}}\times d_{\text{out}}}$。
**列并行**（按输出维切）：$A=[A_1|\cdots|A_k]$，$A_i\in\mathbb R^{d_{\text{in}}\times(d_{\text{out}}/k)}$；每卡用**完整的** $\boldsymbol X$ 算出 $\boldsymbol Y_i=\boldsymbol XA_i\in\mathbb R^{B\times(d_{\text{out}}/k)}$ → **前向无需通信**（$A$ 的每一列只影响输出的对应列，分片留在输出上，物理上各持一段即可）。
**行并行**（按输入维切）：$A=[A_1;\cdots;A_k]$，$A_i\in\mathbb R^{(d_{\text{in}}/k)\times d_{\text{out}}}$，$\boldsymbol X=[\boldsymbol X_1|\cdots|\boldsymbol X_k]$；每卡算部分积 $\boldsymbol X_iA_i\in\mathbb R^{B\times d_{\text{out}}}$，必须做 $\boldsymbol Y=\sum_i\boldsymbol X_iA_i$ → **一次 All-Reduce（或 reduce-scatter）**。

**（2）为什么必须成对。** 列切免通信、把分片留在输出；行切必须是部分和、把结果拼回完整。若两层都列切：第二层需要**完整的输入**（权重按输入维完整），而它拿到的输入是分片的 → 必须先 all-gather，通信次数不省；若两层都行切：每一层后都要归约 → 通信翻倍。因此「列切（免通信）→ 逐元素 $\phi$（免通信：逐元素算子不跨元素）→ 行切（一次归约）」是把一块压到**一次归约**的唯一组合。**每个块前向 1 次、反向对称再 1 次（共 2 次），与 $k$ 无关。**

**（3）代入。** 归约发生在行并行层的输出，形状 $B\times T\times h$：
$$S=4\times2048\times4096\times2\ \text{字节}=6.7\times10^{7}\ \text{字节}\approx67\ \text{MB};$$
$$V=2\times\frac{k-1}{k}S=2\times\frac78\times67\ \text{MB}\approx117\ \text{MB/卡}.$$
前向有 2 个通信点（注意力输出投影、FFN 的 $W_2$）→ 每层前向 $\approx234$ MB；算上反向对称，每层每步约 $700$ MB 量级；32 层合计 $\approx\mathbf{22\ GB/卡/步}$。
时间：NVLink $\approx22/300\approx0.07$ s；IB $\approx22/50\approx0.44$ s（还要乘小消息效率损失）。

**（4）必须留在节点内的理由。** ① **频次**：TP 每层 2 个通信点、32 层就是 64 次/步，而 DP 每步只有 1 次——这么高的频次使**延迟**而非带宽成为瓶颈；② **消息小**：TP 的消息是单层输出（数十 MB）而不是整个模型（GB 量级），小消息对带宽利用率差、对往返延迟敏感。与 DP 相比：TP 的 22 GB/卡/步已接近 DDP 的 24.5 GB/卡/步，但**它分掉的计算量小得多**（并行度切在每一层里），所以通信占比高得多。
:::

**B5.** 从「系统故障率近似等于各组件故障率之和」推出 MTBF $\approx1/(G\lambda)$，并填出 $G=8,512,8192,16384$ 的量级；然后按期望损失最小化求 7B 训练（128 卡、聚合写带宽 2 GB/s、单次故障平均损失 5 分钟进度、恢复 3 分钟）的**最优 checkpoint 间隔**，并计算「每 2 小时存一次」时每小时的额外时间占比。（依据：[9.6.3](sec96.md#sec-9.6.3)、[例 9.6.3](sec96.md#ex-9.6.3)、[9.6.4](sec96.md#sec-9.6.4)）

::: sol 提示与答案
**（1）MTBF。** 设单组件小时故障率 $\lambda$，系统有 $G$ 个组件（GPU、网卡、光模块、电源、交换机端口），任一失效即中断训练，则 $\lambda_{\text{sys}}\approx\sum_g\lambda_g\approx G\lambda$，于是
$$\text{MTBF}\approx\frac{1}{G\lambda}.$$
取 $\lambda\approx3\times10^{-6}$/小时（量级参考，**需核实**）：$G=8$ → $\approx4.2\times10^{4}$ 小时（基本无感）；512 → $\approx650$ 小时（近一个月一次）；8192 → $\approx41$ 小时（一到两天一次）；16384 → $\approx20$ 小时（几乎每天）。**读法**：故障率随规模线性增长，而训练时长不变（数周到数月），于是「每天都坏」是常态而不是意外。

**（2）保存时间。** 分片策略下总写入量 = 模型状态总量 = $112$ GB：
$$t_{\text{save}}=\frac{112}{2}=56\ \text{s}\approx0.93\ \text{min}.$$
（对照全量策略：$128\times112=14{,}336$ GB → 约 2 小时，不可行——这就是「分片是默认」的原因。）

**（3）最优间隔（期望损失最小化）。** 间隔 $T$（小时）：期望故障损失 $\approx0.5\,f\,T\times 8$ 分钟（平均等到间隔中点，每次故障损失 $5+3$ 分钟），保存开销 $\approx(60/T)\times0.93$ 分钟，故每小时的额外时间
$$E(T)=4f\,T+\frac{55.8}{T},\qquad E'(T)=4f-\frac{55.8}{T^{2}}=0\ \Rightarrow\ T^{\star}=\sqrt{\frac{55.8}{4f}}=\sqrt{\frac{13.95}{f}} .$$
$f=0.5$（每两小时一次）→ $T^\star\approx\sqrt{27.9}\approx5.3$ 小时。**间隔越短不一定越好**——保存本身也要时间。

**（4）$T=2$ 小时的额外时间。**
$$\text{额外时间/小时}=0.5\times(5+3)+\frac{60}{120}\times0.93=4+0.47=4.5\ \text{分钟}\approx7.5\%.$$
即**近 8% 的训练时间花在故障与保存上**，必须计入预算。**补一句**：公式之外还有硬约束——「恢复时间必须远小于间隔」与「单次故障不至于丢掉太多算力」；若故障呈批次性（同一批机器反复坏），正确动作是先修机器，而不是加密 checkpoint。
:::

**B6.** 从 $16N$ 的分解出发，推导 ZeRO 三级「每卡模型状态」的公式（$4N+12N/k$、$2N+2N/k+12N/k$、$16N/k$），代入 $N=7\times10^{9}$、$k=8$ 得到 $112\to38.5\to26.25\to14$ GB 的逐项表，并说明每级引入的通信变化与「为什么 ZeRO-1 最划算」。（依据：[定义 9.2.3](sec92.md#def-9.2.3)、[例 9.2.3](sec92.md#ex-9.2.3)）

::: sol 提示与答案
**（1）分解。** $16N$ = 参数 $2N$ + 梯度 $2N$ + 优化器状态（$m,v$）$8N$ + 主权重 $4N$。把「可摊开的」分成两组：**优化器相关 $12N$**（$m,v$ 与主权重）与**梯度 $2N$**。

**（2）三级递进。**
- **ZeRO-1**：只分片优化器状态与主权重 → $2N+2N+\dfrac{12N}{k}=4N+\dfrac{12N}{k}$，通信**不变**（仍是梯度 All-Reduce，$\approx2S$）。
- **ZeRO-2**：再分片梯度 → $2N+\dfrac{2N}{k}+\dfrac{12N}{k}$；因为每卡只需自己那 $1/k$ 份梯度，可用 **reduce-scatter** 替代 All-Reduce → 通信**约减半**（$\approx S$）。
- **ZeRO-3**：再分片参数 → $\dfrac{2N+2N+8N+4N}{k}=\dfrac{16N}{k}$；额外引入每层参数的 **all-gather**（前向、反向各一次）→ 净通信升至约 **1.5 倍**。

**（3）代入 $N=7\times10^{9}$、$k=8$（单位 GB）：**

| 配置 | 参数 | 梯度 | $m,v$ | 主权重 | 合计 / 卡 |
|:--|:--|:--|:--|:--|:--|
| DP（基线） | $14$ | $14$ | $28+28$ | $28$ | $\mathbf{112}$ |
| ZeRO-1 | $14$ | $14$ | $3.5+3.5$ | $3.5$ | $\mathbf{38.5}$ |
| ZeRO-2 | $14$ | $1.75$ | $3.5+3.5$ | $3.5$ | $\mathbf{26.25}$ |
| ZeRO-3 | $1.75$ | $1.75$ | $3.5+3.5$ | $3.5$ | $\mathbf{14}$ |

核对公式：$4N+12N/k=28+10.5=38.5$ ✔；$2N+2N/k+12N/k=14+1.75+10.5=26.25$ ✔；$16N/k=14$ ✔。
**换一组数**：$N=13\times10^{9}$、$k=8$ 时 DP 208、ZeRO-1 71.5、ZeRO-3 26 —— ZeRO-1 **不够**（71.5 GB 之外几乎没有余量），若还要 40 GB 激活则只有 ZeRO-3（26 GB）能过。

**（4）为什么 ZeRO-1 最划算。** 它省掉 $12N-12N/k$ 的显存，而通信**一分不多**——纯赚配置改动的收益，所以「显存差一点」的第一反应就该是它。ZeRO-2 多省梯度那 $2N$ 且通信减半，代价是归约后的梯度只在拥有它的卡上完整，实现复杂度上升；ZeRO-3 省得最多、通信也最多，**只在「否则根本跑不起来」时才是正确选择**。
:::

## C 组 · 编程实现（6 题）

> 依赖仅限 `numpy` / `torch`（C2 / C4 需要 `torch.distributed`，无 GPU 时用 `gloo` 后端 + CPU 同样可跑）。每题给**可运行的验收标准**——不通过就说明对应环节没接上。

**C1.** 写一个显存估算器 `model_state_gb(N, precision, optimizer, eight_bit, zero_stage, k)`，返回每卡模型状态与逐项分解；用它与正文的 112 GB / 70 GB / 38.5 / 26.25 / 14 GB 对齐。（依据：[方法 9.1.1](sec91.md#method-9.1.1)、[例 9.2.3](sec92.md#ex-9.2.3)、[例 9.5.1](sec95.md#ex-9.5.1)）

::: sol 参考实现
```python
def model_state_gb(N, precision="mixed", optimizer="adam", eight_bit=False,
                   zero_stage=0, k=1, gb=1e9):
    """返回 (每卡 GB, 逐项 GB)。口径必须随结果一起打印出来。"""
    if precision == "fp32":
        p = g = 4.0; master = 0.0     # 参数本身就是 fp32，不需要独立主权重
    else:
        p = g = 2.0; master = 4.0     # bf16/fp16 + fp32 主权重
    m = v = (1.0 if eight_bit else 4.0) if optimizer == "adam" else 0.0
    items = {"params": p * N, "grads": g * N, "m": m * N, "v": v * N,
             "master": master * N}
    if zero_stage >= 3:      # 参数、梯度、优化器状态全分片
        div = {key: k for key in items}
    elif zero_stage == 2:    # 再分梯度
        div = {"params": 1, "grads": k, "m": k, "v": k, "master": k}
    elif zero_stage == 1:    # 只分优化器状态与主权重
        div = {"params": 1, "grads": 1, "m": k, "v": k, "master": k}
    else:
        div = {key: 1 for key in items}
    per = {key: val / div[key] / gb for key, val in items.items()}
    return sum(per.values()), per

N = 7e9
print(model_state_gb(N))                                  # 112.0
print(model_state_gb(N, eight_bit=True))                  # 70.0
for s in (1, 2, 3):
    print(s, model_state_gb(N, zero_stage=s, k=8)[0])     # 38.5 / 26.25 / 14
print(model_state_gb(N, precision="fp32"))                # 112.0，但 master == 0
```
**验收标准**：① 混合精度 Adam 与纯 fp32 Adam 都输出 $112$ GB（±0.5），且前者的逐项恰为 $14/14/28/28/28$；② 纯 fp32 的 `master == 0`（断言**组成不同、总额相同**——这正是 A1 的机器验证）；③ `eight_bit=True` 输出 $70$ GB 且恰好省 $37.5\%$（断言比值）；④ `k=8` 时 ZeRO-1/2/3 输出 $38.5/26.25/14$（±0.05）；⑤ `optimizer="sgd"` 时 $m=v=0$（混合精度下合计 $8N$）；⑥ 打印结果时**必须带口径字符串**（精度 + 优化器 + 是否含主权重 + 分片级数），否则数值不可比。
:::

**C2.** 用 `torch.distributed` 跑通 DDP，并验证「各卡平均梯度 == 全批梯度」与「每步末各副本参数完全一致」。（依据：[定义 9.2.1](sec92.md#def-9.2.1)、[9.2.1](sec92.md#sec-9.2.1)）

::: sol 参考实现
```python
# 文件 ddp_check.py；运行：torchrun --standalone --nproc_per_node=2 ddp_check.py
import torch, torch.nn as nn, torch.distributed as dist
def build():                       # 固定种子 → 每个 rank 拿到同一份初始权重
    torch.manual_seed(1234)
    return nn.Sequential(nn.Linear(16, 32), nn.ReLU(), nn.Linear(32, 4))
def main():
    dist.init_process_group("gloo")            # 有 GPU 时换 "nccl"
    rank, world = dist.get_rank(), dist.get_world_size()
    model = build()
    ddp = nn.parallel.DistributedDataParallel(model)
    torch.manual_seed(7)                       # 固定数据，保证可复现
    X, y = torch.randn(64, 16), torch.randint(0, 4, (64,))
    xb, yb = X[rank::world], y[rank::world]    # 每卡只吃 1/world 份 → 合起来是全批
    nn.functional.cross_entropy(ddp(xb), yb).backward()
    ref = build(); ref.load_state_dict(model.state_dict()); ref.zero_grad()
    nn.functional.cross_entropy(ref(X), y).backward()      # 等效大批的参考梯度
    err = max((p.grad - q.grad).abs().max().item()
              for p, q in zip(model.parameters(), ref.parameters()))
    print(f"[rank {rank}/{world}] max|g_ddp - g_full| = {err:.3e}")
    assert err < 1e-5, "DDP 的同步梯度应等于全批梯度"
    torch.optim.SGD(model.parameters(), lr=0.1).step()
    flat = torch.cat([p.detach().reshape(-1) for p in model.parameters()])
    ref_flat = flat.clone(); dist.broadcast(ref_flat, src=0)
    assert torch.allclose(flat, ref_flat, atol=0.0), "每步末各副本必须完全一致"
    dist.destroy_process_group()
if __name__ == "__main__":
    main()
```
**验收标准**：① `max|g_ddp − g_full| < 1e-5`（float32；2 卡与 4 卡都要过）；② 一步更新后各 rank 参数 `allclose(atol=0)`；③ 打印 `world/world_size`、每卡损失与梯度范数；④ **手写同步对照**：对某个参数的梯度做 `dist.all_reduce(g); g /= world`，与 DDP 给出的 `p.grad` 相差 $<10^{-6}$——说明 DDP 就是「累加后取平均」，而不是求和；⑤ 无 GPU 时用 `gloo` + CPU 通过即算达标（语义与 GPU 版一致）。
:::

**C3.** 实现梯度累积，并验证「$K$ 次累积 == 一次等效大批」；同时验证「$K$ 个 micro-batch 只同步一次梯度」。（依据：[定义 9.2.2](sec92.md#def-9.2.2)、[例 9.2.1](sec92.md#ex-9.2.1)）

::: sol 参考实现
```python
def grads_of(model, X, y, K=1, normalize=True):
    model.zero_grad()
    for k in range(K):
        xb, yb = X[k::K], y[k::K]                  # 把大批切成 K 个 micro-batch
        loss = torch.nn.functional.cross_entropy(model(xb), yb)
        (loss / K if normalize else loss).backward()   # 按等效批归一化
    return [p.grad.clone() for p in model.parameters()]
K = 4
g_acc = grads_of(model, X, y, K=K, normalize=True)
g_big = grads_of(model, X, y, K=1, normalize=True)     # 一次吃下全部样本
print(max((a - b).abs().max().item() for a, b in zip(g_acc, g_big)))   # < 1e-6
```
**验收标准**：① `normalize=True` 时累积梯度与「一次大批」梯度差 $<10^{-6}$（用 `float64` 跑）；② `normalize=False` 时梯度恰为 $K$ 倍（相对误差 $<10^{-5}$）——这条同时证明了「必须除以 $K$」；③ **调用计数**：把 `optimizer.step` 包成计数器，跑 3 个等效步（$K=4$）后断言 `step_count == 3`、`backward` 被调 12 次；④ 20 步训练（SGD、$\eta=0.1$）损失下降（末 5 步均值 < 首 5 步均值）；⑤ 有 2 卡时再断言：`all_reduce` 调用次数 `== step` 次数（用 wrapper 计数）——印证「整个等效批只同步一次，通信量不变、通信占比反而下降 $K$ 倍」。
:::

**C4.** 实现**分片 checkpoint** 并验证恢复：每卡只写自己那 $1/k$ 的状态 + 一份元数据；恢复后必须与中断前一致，且「数据流位置 / 优化器步数 / 随机状态」都要恢复。（依据：[方法 9.6.2](sec96.md#method-9.6.2)、[例 9.6.3](sec96.md#ex-9.6.3)、[9.6.4](sec96.md#sec-9.6.4)）

::: sol 参考实现
```python
import os, torch
def save_sharded(model, step, consumed, seed, k, out_dir):
    flat = torch.cat([p.detach().reshape(-1) for p in model.parameters()])
    os.makedirs(out_dir, exist_ok=True)
    chunk = (flat.numel() + k - 1) // k
    for i in range(k):                       # 每片 = 1/k 的参数 + 完整元数据
        torch.save({"shard": flat[i * chunk:(i + 1) * chunk], "step": step,
                    "consumed_samples": consumed, "seed": seed,
                    "k": k, "numel": flat.numel()}, f"{out_dir}/shard_{i}.pt")

def load_sharded(model, k, out_dir):
    parts, meta = [], None
    for i in range(k):
        blob = torch.load(f"{out_dir}/shard_{i}.pt", weights_only=False)
        parts.append(blob["shard"]); meta = blob
    flat = torch.cat(parts)[:meta["numel"]]
    off = 0
    with torch.no_grad():
        for p in model.parameters():
            n = p.numel(); p.copy_(flat[off:off + n].view_as(p)); off += n
    return meta["step"], meta["consumed_samples"], meta["seed"]
```
**验收标准**：① 保存后把参数全部置零，再 `load_sharded` 恢复，与原参数**逐参数** `allclose`（$<10^{-7}$）；② 元数据里 `step`、`consumed_samples`、`seed` 三个值与保存时一致；③ 落盘总量 ≈ **模型状态字节数**而不是 $k\times$（用 `os.path.getsize` 求和断言）——这是「分片」与「全量」的分界；④ **对照实验**：故意把 `consumed_samples` 改成 0 再恢复，打印恢复后前 3 个 batch 的样本索引 → 会从头开始，用来说明「恢复一致性」必须包含数据流位置（否则等于悄悄换了实验条件）；⑤ 进阶（2 卡）：用 `torch.distributed.checkpoint` 的 `save` / `load` 各跑一遍，断言与手工分片的结果一致（**字段名随版本变化，以你所用版本为准**）。
:::

**C5.** 实测 QLoRA 的静态显存、随序列长度的峰值显存增长与吞吐（接 [Lab 3](../../labs/lab3.md)）。（依据：[定义 9.5.5](sec95.md#def-9.5.5)、[例 9.5.4](sec95.md#ex-9.5.4)、[9.7.4](sec97.md#sec-9.7.4)）

::: sol 参考实现
```python
import torch
from transformers import AutoModelForCausalLM, BitsAndBytesConfig
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training

bnb = BitsAndBytesConfig(load_in_4bit=True, bnb_4bit_quant_type="nf4",
                         bnb_4bit_use_double_quant=True,
                         bnb_4bit_compute_dtype=torch.bfloat16)
model = AutoModelForCausalLM.from_pretrained(MODEL_ID, quantization_config=bnb,
                                             device_map={"": 0})
model = prepare_model_for_kbit_training(model)         # 冻结主干、开梯度检查点等
model = get_peft_model(model, LoraConfig(r=8, lora_alpha=16, lora_dropout=0.05,
                       target_modules=["q_proj", "v_proj"], task_type="CAUSAL_LM"))
model.print_trainable_parameters()          # 验收①：可训参数比例 < 0.2%
for T in (512, 1024, 2048):                 # 验收③：峰值显存随 T 的线性度
    peak = fit_one_step(model, T)           # 内部记录 max_memory_allocated
    print(T, f"{peak:.2f} GB")
```
**验收标准**：① `print_trainable_parameters()` 给出的可训比例 $<0.2\%$；② 静态占用与估算 $0.5N$（NF4 主干）+ 适配器（7B 时 $\approx0.08$ GB）+ 激活 的偏差在 $\pm20\%$ 内，并在报告里写清口径（是否含双重量化开销、是否按层反量化出临时副本）；③ `max_length ∈ {512, 1024, 2048}` 各跑 5 步，峰值显存**单调上升**且三点线性拟合 $R^2\gt0.95$（激活 $\propto T$ 的机器验证）；④ 输出 token/s 与「峰值显存 / token 数」两个数，并记录 `reserved − allocated`（碎片与缓存）；⑤ 无 ≥12 GB 显存时降级：用随机初始化的 $N\approx0.1$B 模型按同口径复算，断言主干静态占用 $\approx0.5N$（±10%），并在报告里写明「换算到 7B 的口径」——**注意 4 bit 主干的 0.5 字节/参数是理想值，双重量化会带来额外开销（需实测）**。
:::

**C6.** 实测对账：在四个时刻打印显存并与 $16N$、激活估算对照；再计时测量 All-Reduce 的每卡时间与 $V=2S(k-1)/k$、带宽估算的关系。（依据：[9.1.6](sec91.md#sec-9.1.6)、[方法 9.1.3](sec91.md#method-9.1.3)、[例 9.6.1](sec96.md#ex-9.6.1)）

::: sol 参考实现
```python
def report(tag, dev=0):
    torch.cuda.synchronize(dev)
    print(f"[{tag}] alloc={torch.cuda.memory_allocated(dev)/1e9:.2f}GB "
          f"peak={torch.cuda.max_memory_allocated(dev)/1e9:.2f}GB "
          f"reserved={torch.cuda.memory_reserved(dev)/1e9:.2f}GB")
report("after-model-init")        # 期望 ≈ 2N（bf16 参数）
report("after-optimizer-init")    # 期望增量 ≈ 12N（m,v 与主权重）
report("after-forward")           # 期望增量 ≈ 激活量
report("after-backward")          # 峰值通常出现在反向的早期层

import time, torch.distributed as dist
for MB in (1, 4, 16, 64):                       # 通信计时（2 卡即可）
    t = torch.randn(MB * 250_000, device="cuda")     # float32，约 MB 兆字节
    dist.barrier(); t0 = time.perf_counter()
    for _ in range(10): dist.all_reduce(t)
    torch.cuda.synchronize(); dt = (time.perf_counter() - t0) / 10
    bw = 2 * (dist.get_world_size() - 1) / dist.get_world_size() * t.numel() * 4 / dt / 1e9
    print(f"S≈{MB}MB t={dt*1e3:.2f}ms 等效带宽={bw:.1f}GB/s")
```
**验收标准**：① `after-model-init` 的 `alloc` ≈ 参数字节数（bf16 下 $2N$，±10%）；② `after-optimizer-init` 的增量 ≈ $12N$（±15%）——对不上就查「是否漏了主权重」或「用了 fp32 梯度」；③ `after-forward` 的增量与激活估算同量级（±50%，随注意力实现波动很大）；④ 通信计时里小消息的等效带宽显著低于大消息（**延迟主导**），并验证「时间随 $S$ 近似线性」（相邻点带宽比值 $\ge0.8$）；⑤ 无多卡时用 `gloo` + CPU 只验 ④ 的相对关系；⑥ 结论句必须写出**峰值出现在哪一阶段**，并附你自己机器上的 `reserved − allocated`（常见 OOM 的真凶）。
:::

## D 组 · 开放设计（4 题）

> 每题都要写齐四项：**方案 + 理由 + 失败判据 + 验证计划**（缺一项不给分）。

**D1.** 硬件：8 × 80 GB（**同一节点**、NVLink 互联）。模型：$N=7\times10^{9}$、$L=32$、$h=4096$、$n_h=32$、$T=2048$。任务：全参微调，目标等效批 256，要求扩展效率 $\ge0.7$。给出完整配置。

::: sol 参考方案与评分要点
**方案**：`DDP × ZeRO-2（8 卡同节点），不开 TP / PP`；精度 bf16 参数与梯度 + fp32 主权重（关闭 fp16 的损失缩放）；$B_{\text{micro}}=4$、$K=8$（$256=4\times8\times8$）；重计算先关；AdamW + 学习率线性缩放 ×4 + warmup 3%；`torch.distributed.checkpoint` 分片保存（每 500–1000 步 + 结束时）。
**账（必须写）**：$M_s=16N=112$ GB；ZeRO-1 $38.5$ GB/卡不够宽松，ZeRO-2 $26.25$ GB/卡；$B_{\text{micro}}=4$ 时激活 $\approx9$ GB；加上通信缓冲与碎片（留 15%–30%）后约 $40$ GB/卡——80 GB 卡舒适。
**理由**：单层最大是 FFN（$h\times4h=6.7\times10^7$ 参数 $\approx0.13$ GB，bf16），单卡轻松放下 → **不需要 TP**；层数不是瓶颈、ZeRO-2 已解决整体显存 → **不需要 PP**。配平原则是先满足硬约束（显存 / 整除性 / 拓扑）再优化软目标，同节点时越简单风险越低。
**失败判据**：① 同全局批下 $E\lt0.7$；② 峰值显存 >64 GB（容量的 80%）或 OOM；③ 前 100 步出现 loss 尖峰 / NaN（说明学习率缩放过头）；④ 单步时间波动 >10%（数据管线或通信抖动）。
**验证计划**：10 步跑通链路 → 用 `max_memory_allocated` 对账 $26.25+9$ GB → 跑 20 步取中位数时间并与「单卡同全局批」比出 $E$ → 500 步看 loss 形态与效果对照 → 把卡数、精度、$T$、$B_{\text{micro}}$、$K$、是否重计算、是否分片写进实验记录。
:::

**D2.** 场景：$T=32768$ 的长上下文全参微调，7B 模型，单节点 8 × 80 GB，显存紧张。给出优化方案。

::: sol 参考方案与评分要点
**方案（按收益排序）**：① **先消掉实体化注意力**——$B\,n_h\,T^2$ 项随 $T$ 平方增长（正文口径：$T=2048$ 时约 1 GB/层、32 层约 34 GB），换 FlashAttention 一类分块 + 在线 softmax 实现（[2.6](../lec02/sec26.md)）；② **序列并行 / 上下文并行**——把 LayerNorm、Dropout、残差这类「纯 TP 下仍完整复制」的激活沿 $T$ 切 $k$ 份（正文例：$T=8192$ 时 $4.3\to0.54$ GB；$T=32768$ 时纯 TP 的该项约 17 GB），它与 TP 的 all-gather 融合、**不额外增加通信**；③ **激活重计算**——先 selective（注意力是大户且重算便宜，额外计算个位数百分比），仍不够再 full（每 token 每层 $34\to2$ 字节，额外约 $1/3$ 前向）；④ **状态账**：$k=8$ 的 ZeRO-2 已是 $26.25$ GB/卡，够用就先别上 ZeRO-3；⑤ **批与累积**：$B_{\text{micro}}$ 取 1–2，靠 $K$ 保住等效批，避免「为了凑批而撑爆激活」；⑥ 若开 TP：必须整除头数与 FFN 隐维，且留在节点内。
**失败判据**：① 峰值显存仍超卡容量的 80%；② profiler 里出现 $T\times T$ 量级的显存尖峰（注意力仍被实体化）；③ $E\lt0.5$；④ 长序列下 loss 形态异常（bf16 累加误差、或 dropout 掩码跨卡不一致）。
**验证计划**：$T$ 扫描（4096 → 8192 → 16384 → 32768）记录峰值显存与 token/s → 用 34 / 18 / 2 三种口径与实测对账并标出「需核实」的系数 → 做 SP 开 / 关的对照，检查收益是否达到理论值（$1/k$）→ 检查掩码一致性。
:::

**D3.** 取舍题：只剩一次实验机会，三选一——(A) 把 $B_{\text{micro}}$ 从 2 翻到 4；(B) 打开选择性重计算并把 $T$ 从 2048 提到 4096；(C) 再加 4 张卡（变成跨机 2 节点）。写出你的决策与依据。

::: sol 参考方案与评分要点
**决策树**：先问「哪堵墙最紧」。
- 若**前向能跑、反向 OOM**（激活墙）：**选 B 往往最优**——重计算换来的激活预算正好用来把 $T$ 翻倍，而它只多花个位数百分比的额外前向；长序列通常还是效果侧更需要的旋钮。
- 若**显存有余但单步太慢、算子效率低**：**选 A**——$B_{\text{micro}}$ 翻倍直接改善矩阵乘的尺寸，但激活也翻倍，必须先确认余量。
- **选 C 只在「计算量足够大、通信能被摊薄」时才划算**：跨机把 DP 的梯度 All-Reduce 推到 IB 上（7B、bf16 下 $24.5$ GB/卡 → 下界 $\approx0.49$ s），若每卡 token 数不足，$E$ 会掉到 0.5 以下——**「加卡」是三者中唯一会同时引入新瓶颈的操作**。
**必须写到的量化句**：加卡或改批之后要用 $K$（或 $B_{\text{micro}}$）抵住**全局批不变**，并同步调学习率（线性缩放 + warmup）；否则「更快的配置」可能只是「更短的训练」。
**失败判据**：① 选 C 后同全局批 $E\lt0.5$；② 选 B 后 token/s 下降超 10%（重计算的好处被算子变小吃掉）；③ 选 A 后峰值显存超预算，或单步时间反而变长。
**验证计划**：**每次只改一个变量**；20 步中位数测时间与峰值显存；保留 loss 曲线与 `grad_norm` 做对照；结论写进最小记录集。
:::

**D4.** 场景：8192 卡、计划训练 30 天。设计容错方案，并给出 checkpoint 间隔的定量依据。

::: sol 参考方案与评分要点
**方案**：① **检错**：NCCL 超时 + 健康检查（跑一个小 all-reduce + 矩阵乘自测），把「哪张卡坏了」在几分钟内定位；② **恢复**：分片 checkpoint + 完整元数据（分片布局、优化器步数、已消费样本数、随机状态、学习率调度器位置）；③ **弹性**：坏卡就绪后重配进程组继续（**各框架支持度不同，需核实**）；④ **静默损坏**：周期性抽样校验（手工计算的损失值 / 梯度范数是否落在期望范围）；⑤ **确定性**：固定数据顺序与种子，让「恢复后」与「未中断」一致。
**定量依据（必须写）**：$\lambda\approx3\times10^{-6}$/小时（量级参考，需核实）→ MTBF $\approx1/(8192\times3\times10^{-6})\approx41$ 小时，即约每 1.7 天中断一次、30 天内约 18 次；分片保存一次 $112/2=56$ s；$f=1/41\approx0.024$/小时时
$$E(T)=4fT+\frac{55.8}{T}\ \Rightarrow\ T^{\star}=\sqrt{\frac{13.95}{f}}\approx24\ \text{小时},$$
取 $T=24$ 小时：$E\approx0.5\times0.024\times24\times8+\frac{60}{24}\times0.93\approx2.3+2.3=4.6$ 分钟/小时 $\approx7.7\%$——与「每 2 小时存一次」时的 $7.5\%$ 同量级，说明**这个规模下 checkpoint 的开销与故障损失相当**，两者都要计入预算。
**注意**：公式之外还有硬约束——「恢复时间必须远小于间隔」；若故障呈批次性（同一批机器反复坏），先修机器而不是加密 checkpoint。
**失败判据**：① 每小时额外时间 >8%；② 恢复后一致性校验失败（步数 / 数据流 / 随机状态对不上）；③ 演练中恢复时间 > 间隔的 10%；④ 静默损坏抽样始终无法与基准对齐（说明对照基准本身不可靠）。
**验证计划**：小规模故障注入演练（kill 一个 rank，测恢复时间与一致性）→ 每 100 步记录「已消费样本数 + `grad_norm`」作为一致性证据 → 用 2× 规模的对照训练验证「恢复后的曲线与不中断曲线在预期噪声内」。
:::
