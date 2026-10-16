# 2.7 现代序列架构：状态空间、混合专家与线性注意力

::: note 本节定位：教材外拓展
本节**超出母本 MIT 6.S191 Lecture 2 的课堂范围**（母本只讲到 RNN / LSTM 与 Transformer 主干），内容全部来自 2020 年之后的研究线与工程实践。正文严格区分**论文事实**（给出编号的论文报告）、**工程惯例**（开源实现的常见做法）与**本书判断**（本教程的取舍立场）；凡标「需核实」处指实现细节随代码库与版本变化。
读法建议：关心「注意力之外还有什么」，读 [2.7.1](#sec-2.7.1)–[2.7.6](#sec-2.7.6)；关心「怎么把模型做大而不是做贵」，直接读 [2.7.7](#sec-2.7.7)–[2.7.8](#sec-2.7.8)；只想建立选型判断力，读 [2.7.9](#sec-2.7.9) 的对照表与 [2.7.11](#sec-2.7.11) 的陷阱清单。
:::

[2.6](sec26.md) 处理的是「怎么把注意力的三笔账摊薄」：位置怎么写进内积、中间矩阵怎么不落盘、KV cache 怎么压缩。那是在**保留注意力这个算子**的前提下做工程优化。本节换一个问法：**能不能换掉算子本身**——让每 token 的计算量与序列长度无关，让推理状态是常数大小，同时尽量保住长程记忆与并行训练？

三条替代路线各自回答了其中一个方面。**状态空间模型**（state space model, SSM）把 RNN 的 $O(1)$ 状态与线性系统的解析性质结合起来：状态转移是线性的，于是训练时能以卷积或并行扫描并行、推理时以 $O(1)$ 状态流式前进（[2.7.1](#sec-2.7.1)–[2.7.3](#sec-2.7.3)）；**线性注意力**换掉 softmax、用结合律把 $T\times T$ 的分数矩阵折成 $d\times d$ 的状态（[2.7.5](#sec-2.7.5)）；**混合专家**（mixture of experts, MoE）不碰序列结构，而是把「参数量」与「每 token 计算量」解耦（[2.7.7](#sec-2.7.7)）。Mamba-2 又把前两条串起来：在特定结构约束下，SSM 与带因果掩码的注意力是**同一族算子**（[2.7.4](#sec-2.7.4)）。

读这一节要用三条张力做索引：**复杂度**（$O(T)$ 还是 $O(T^{2})$，以及常数多大）、**记忆**（状态能无损保存什么、精确回忆能力如何）、**并行**（训练能不能并行、推理状态是否随序列增长）。每条路线都是在这三者之间做交换，没有一条是全面胜利——这一点会在 [2.7.9](#sec-2.7.9) 的对照表与小结里回收。

## 2.7.1 从连续系统到递推：线性状态空间 {#sec-2.7.1}

::: def 定义 2.7.1 · 线性状态空间模型与零阶保持离散化 {#def-2.7.1}
**连续形式**：给定输入信号 $\boldsymbol x(t)\in\mathbb R^{d}$ 与状态 $\boldsymbol h(t)\in\mathbb R^{N}$，

$$\boldsymbol h'(t)=A\boldsymbol h(t)+B\boldsymbol x(t),\qquad \boldsymbol y(t)=C\boldsymbol h(t)\quad(\text{工程实现常再加一个跳跃项 }D\boldsymbol x),\tag{2.7.1}$$

其中 $A\in\mathbb R^{N\times N}$、$B\in\mathbb R^{N\times d}$、$C\in\mathbb R^{d\times N}$ 是参数。$A$ 决定「历史如何衰减」、$B$ 决定「输入如何写入状态」、$C$ 决定「状态如何读出」。

**离散化（零阶保持，zero-order hold）**：取步长 $\Delta\gt0$，并假设每个区间内输入恒定，则

$$\bar A=\exp(\Delta A),\qquad \bar B=\bigl(\exp(\Delta A)-I\bigr)A^{-1}B,$$

$$\boldsymbol h_t=\bar A\boldsymbol h_{t-1}+\bar B\boldsymbol x_t,\qquad \boldsymbol y_t=C\boldsymbol h_t .\tag{2.7.2}$$
:::

::: intuition 它和 RNN 的关系：同一种递推，不一样的转移
[2.2](sec22.md) 的 RNN 是 $\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t)$：状态转移**含非线性**，且**依赖输入**（经由 $\phi$ 作用后的值）。SSM 的转移是 $\bar A\boldsymbol h_{t-1}+\bar B\boldsymbol x_t$：**对状态是线性的**，而且在时不变设定下 $\bar A,\bar B$ 与 $t$、与输入都无关。这两个差别带来两个直接后果：① 线性递推可以**展开成卷积**（[定理 2.7.1](#thm-2.7.1)），因此训练能沿时间并行；② 但「线性 + 时不变」也意味着「记住或忘记」的规则在整段序列里固定，模型无法按内容决定该记什么——这正是 [2.7.3](#sec-2.7.3) 要修的地方。
:::

::: proof 推导（从一阶线性 ODE 到递推式）
**(1) 通解。** 一阶线性常微分方程 $\boldsymbol h'(t)=A\boldsymbol h(t)+B\boldsymbol x(t)$ 的解（常数变易法）为

$$\boldsymbol h(t)=e^{A(t-t_0)}\boldsymbol h(t_0)+\int_{t_0}^{t}e^{A(t-\tau)}B\boldsymbol x(\tau)\,\mathrm d\tau .$$

**(2) 逐区间积分。** 取 $t_0=(t-1)\Delta$、$t=t\Delta$，得 $\boldsymbol h(t\Delta)=e^{\Delta A}\boldsymbol h\bigl((t-1)\Delta\bigr)+\bigl(\int_0^{\Delta}e^{A\tau}\mathrm d\tau\bigr)B\,\boldsymbol x_t$，其中最后一步用了零阶保持假设：区间 $[(t-1)\Delta,t\Delta)$ 内 $\boldsymbol x(\tau)\equiv\boldsymbol x_t$。

**(3) 读出矩阵形式。** 记 $\bar A=e^{\Delta A}$、$\bar B=\bigl(\int_0^{\Delta}e^{A\tau}\mathrm d\tau\bigr)B$，就得到 (2.7.2) 的前两个式子，$\boldsymbol y_t=C\boldsymbol h_t$ 是直接读出的输出。

**(4) 为什么教科书里写成 $A^{-1}$ 的形式。** 对可逆的 $A$，$\int_0^\Delta e^{A\tau}\mathrm d\tau=A^{-1}\bigl(e^{\Delta A}-I\bigr)$（把 $e^{A\tau}$ 展成幂级数逐项积分即得），这就给出 [定义 2.7.1](#def-2.7.1) 里的 $\bar B$ 形式。**工程实现通常不显式求 $A^{-1}$**：一来 $A$ 未必可逆，二来求逆在数值上既不必要也不划算——实际做法是直接计算 $\int_0^\Delta e^{A\tau}\mathrm d\tau$（例如对 $A$ 施加结构后解析求形，或数值上展开）。**需核实**：不同代码库对 $\bar B$ 的处理细节（例如是否用一阶近似 $\bar B\approx\Delta B$）并不一致，读实现时要看具体公式。
:::

## 2.7.2 S4：让长程记忆有结构 {#sec-2.7.2}

::: thm 定理 2.7.1 · 线性时不变 SSM 的卷积形式 {#thm-2.7.1}
在时不变（$\bar A,\bar B,C$ 与 $t$ 无关）且初态为零（$\boldsymbol h_0=\boldsymbol 0$）的设定下，把递推展开得

$$\boldsymbol h_t=\sum_{j=1}^{t}\bar A^{\,t-j}\bar B\boldsymbol x_j,\qquad
\boldsymbol y_t=C\boldsymbol h_t=\sum_{j=1}^{t}\underbrace{C\bar A^{\,t-j}\bar B}_{\text{核 }\bar K_{t-j}}\boldsymbol x_j .$$

即输出是输入与一个**因果卷积核** $\bar K_t=C\bar A^{t}\bar B$ 的卷积：$\boldsymbol y=\bar K*\boldsymbol x$（只对 $j\le t$ 求和）。
::: proof 推导与它换来的两件事
**(1) 展开。** 从 $\boldsymbol h_1=\bar A\boldsymbol h_0+\bar B\boldsymbol x_1=\bar B\boldsymbol x_1$ 起逐次代入：$\boldsymbol h_t=\bar A(\bar A\boldsymbol h_{t-2}+\bar B\boldsymbol x_{t-1})+\bar B\boldsymbol x_t=\dots=\sum_{j=1}^{t}\bar A^{\,t-j}\bar B\boldsymbol x_j$，再左乘 $C$ 并把「与 $j$ 无关的」$C\bar A^{\,t}$ 移出求和（注意 $\bar A^{\,t-j}=\bar A^{\,t}\bar A^{-j}$ 只在下标意义上成立，稳妥写法是直接定义核 kerns $\bar K_{t-j}=C\bar A^{\,t-j}\bar B$），得到 $\boldsymbol y_t=\sum_{j\le t}\bar K_{t-j}\boldsymbol x_j$。核只依赖**时差**，所以这是卷积而不是一般的线性映射。

**(2) 训练可以并行。** 卷积形式下，全部 $T$ 个输出可以一次算完：直接用 $\bar K$ 与 $\boldsymbol x$ 做因果卷积（朴素代价 $O(T^{2})$，截断核到长度 $L$ 时 $O(TL)$），或者用 FFT 做卷积（$O(T\log T)$）。这就是「线性 SSM 能像卷积网络一样并行训练」的依据。

**(3) 推理只需 $O(1)$ 状态。** 换成递推形式逐 token 推进，每步只更新一个固定大小的状态、不保留历史键值：状态大小 $O(N)$（对角结构下与通道数同阶，见 [2.7.3](#sec-2.7.3)），与 $T$ 无关。**给条件**：所谓 $O(T\log T)$ / $O(T)$ 都是算术复杂度；常数与硬件利用率另算（[2.7.11](#sec-2.7.11) 第 6 条），且 FFT 路径需要把核展开到序列长度、会带来额外的显存与精度开销。

**(4) 核的形状由 $\bar A$ 决定。** 核 $\bar K_t=C\bar A^{t}\bar B$ 是 $\bar A$ 的 $t$ 次幂的线性泛函：$\bar A$ 的特征值模长小于 $1$ 时核随时间衰减（记忆有限），接近 $1$ 时衰减缓慢（记忆更长但数值更敏感）。因此「怎么初始化 / 参数化 $A$」直接决定长程能力——这就是下一段 S4 的核心贡献。$\blacksquare$
:::
:::

::: intuition 卷积与递推是同一个模型的两种读法
把 SSM 想成「一个可学习的、长度为 $T$ 的因果卷积核」：训练时你希望**并行**地把整段卷积一把算完（FFT 或分块），推理时你希望**只带一个压缩状态**往前走。二者能同时成立，恰恰是因为状态转移是**线性且时不变**的：卷积与递推是同一个算子的两种等价计算顺序。RNN 做不到这一点——它的非线性转移把「展开成卷积」这条路堵死了。代价也正来自同一处：时不变意味着记忆规则不随内容变化。
:::

**S4 的贡献不只是「卷积形式」**。上面四条推导对任意时不变 SSM 都成立，并不新鲜；关键在于**参数化**。**论文事实**：Gu et al.（2020, arXiv:2008.07669）提出 HiPPO 框架，用正交多项式（勒让德多项式）投影的视角给出 $A$ 的初始化与结构，使状态能够在线最优地压缩历史；Gu, Goel & Ré（2021, arXiv:2111.00396）把它落到结构化矩阵（对角加低秩、经正规加对角变换）上，报告了在超长序列基准（如 Long Range Arena 一类）上显著优于当时的注意力与递推基线。**本书判断**：S4 的教学要点是「$O(T\log T)$ 的卷积 + $O(1)$ 的推理状态**必须配上合适的 $A$ 初始化**才有长程能力」——把它当成「随便初始化一个线性递推就能记住几千步」是误解。后续的简化（S5, 2022, arXiv:2208.04933：把 $A$ 对角化并用并行扫描实现递推）说明**结构选择可以更简单**，但「$A$ 的结构决定记忆能力」这条结论不变。

## 2.7.3 Mamba：让参数随输入变化 {#sec-2.7.3}

::: def 定义 2.7.2 · 选择性状态空间（selective state space） {#def-2.7.2}
让离散化参数**随输入变化**：对每个时间步 $t$，由当前输入 $\boldsymbol x_t$ 经线性投影与激活函数得到

$$\Delta_t=\operatorname{softplus}\bigl(W_\Delta\boldsymbol x_t+\boldsymbol b_\Delta\bigr),\qquad B_t=W_B\boldsymbol x_t,\qquad C_t=W_C\boldsymbol x_t,$$

并用逐通道的对角转移（$A$ 为实对角，形状 $d\times N$）更新状态：

$$\bar A_t=\exp(\Delta_t A),\qquad \bar B_t\ \text{取}\ \Delta_tB_t\ \text{一类离散化形式},\qquad
\boldsymbol h_t=\bar A_t\boldsymbol h_{t-1}+\bar B_t\boldsymbol x_t,\qquad \boldsymbol y_t=C_t^{\mathsf T}\boldsymbol h_t .$$

由于 $\Delta_t,B_t,C_t$ 依赖输入，模型**不再是时不变的**：$\bar A_t$ 与 $\bar B_t$ 都带时间下标，因此 [定理 2.7.1](#thm-2.7.1) 的卷积形式**不再成立**（不存在一个固定的核 $\bar K$）。出处：Gu & Dao, 2023, arXiv:2312.00752。

**关于 $\bar B$ 的两种写法（**需核实**）**：严格的零阶保持给出 $\bar B_t=\bigl(\exp(\Delta_tA)-I\bigr)A^{-1}B_t$（[定义 2.7.1](#def-2.7.1)），而当 $\Delta_t$ 较小时它约等于 $\Delta_tB_t$（一阶近似）。论文与各实现里采用的离散化约定并不完全一致，比较不同代码的数值结果时，要先确认这一处公式。
:::

::: intuition 「记什么、忘什么」交给输入决定
看三个参数的作用：$\Delta_t$ 是**衰减尺度**——$\Delta_t$ 大 ⇒ $\exp(\Delta_tA)$ 压得更小（状态被快速冲掉，相当于遗忘），$\Delta_t\to0$ ⇒ 转移接近恒等（状态被冻结，相当于记住）；$B_t$ 决定**写入多少**，$C_t$ 决定**读出什么**。三者都由 $\boldsymbol x_t$ 线性投影得到，所以「该记住哪一段」这件事变成了**输入的函数**，而不是固定规则。
与 LSTM 门控的类比：$\Delta_t$ 类似遗忘门（乘性衰减）、$B_t$ 类似输入门（写入强度）；差别在于**非线性放在哪个位置**——LSTM 的状态转移内部含非线性（$\phi$ 作用在预激活上），而选择性 SSM 的状态转移对 $\boldsymbol h$ **仍是线性的**，非线性只出现在「生成系数的路上」。这个差别是决定性的：线性递推可以用结合律做**并行扫描**（[方法 2.7.1](#method-2.7.1)），LSTM 不行。
:::

::: method 硬件感知的并行扫描 {#method-2.7.1}
选择性 SSM 的递推 $\boldsymbol h_t=\bar A_t\boldsymbol h_{t-1}+\bar B_t\boldsymbol x_t$ 是**线性**递推（只是系数随时间变化），因此可以用扫描（scan）把它并行化。**论文报告**的做法是「分块 + 扫描」的两级结构：

```text
输入：x（长度 T）、Δ、A、B、C
1) 把序列切成 T/C 个块，每块长度 C 取到能放进片上内存（SRAM）
2) 块内串行：从零初态出发，逐元素推进 C 步，得到块内输出与该块的“末状态贡献”
3) 块间扫描：对每块的末状态贡献做一次并行前缀扫描（prefix scan），得到各块的初态
4) 用各块初态重算（或修正）块内输出，把 y 写回显存
```

要点有三：① **块内串行、块间并行**，于是整段的并行深度是 $O(T/C)$ 而不是 $O(T)$；② 中间状态尽量留在**片上内存**，不反复往返显存（与 [2.6.7](sec26.md#sec-2.6.7) 的 FlashAttention 是同一类「IO 感知」思路）；③ 推理时不走这条路——直接用递推，**每步只更新一个固定大小的状态**（$O(1)$ 内存、与 $T$ 无关），这正是它在长序列流式场景的优势。复杂度上界：状态更新 $O(T\,d\,N)$、投影 $O(Td^{2})$；**需核实**：分块常数、扫描实现（CUDA / Triton）与融合方式随版本变化。出处：Gu & Dao, 2023, arXiv:2312.00752。
:::

形状上把这一层看一遍（$B$ 批、$T$ 时间步、$d$ 通道、$N$ 每通道状态维）：$\boldsymbol x,\boldsymbol y\in\mathbb R^{B\times T\times d}$；$A\in\mathbb R^{d\times N}$ 是**唯一与 $T$ 无关的大参数**；$\Delta,B_t,C_t\in\mathbb R^{B\times T\times(\cdot)}$ 由输入投影得到；状态 $\boldsymbol h_t\in\mathbb R^{B\times d\times N}$，其大小为 $O(BdN)$——**与 $T$ 无关**。对照 [2.5.6](sec25.md#method-2.5.3) 的 KV cache（$O(BTn_{kv}d_h)$，随 $T$ 线性）：这是「线性复杂度」在显存上的真正含义。

## 2.7.4 Mamba-2 与「注意力 = 状态空间」的对偶 {#sec-2.7.4}

::: thm 定理 2.7.2 · 结构化状态空间对偶（structured state space duality, SSD） {#thm-2.7.2}
**论文证明**（Dao & Gu, 2024, arXiv:2405.21060）：当状态转移被限制为「**标量 × 恒等**」的形式，即 $\bar A_t=a_tI$（每个通道 / 每个头只有一个标量衰减因子）时，SSM 的输出可以写成**矩阵乘法**的形式：

$$\boldsymbol Y=\bigl(M\odot \boldsymbol Q\boldsymbol K^{\mathsf T}\bigr)\boldsymbol V,$$

其中 $\boldsymbol Q,\boldsymbol K,\boldsymbol V$ 由输入投影与 $C_t,B_t,\boldsymbol x_t$ 构造，$M$ 是一个由 $a_t$ 的累积乘积构成的**半可分下三角矩阵**（semiseparable，$M_{ij}=\prod_{k=j+1}^{i}a_k$，$i\ge j$）。也就是说：**在满足该结构约束的前提下，SSM 与「带因果掩码的注意力」属于同一族算子**——后者的掩码是 0 / $-\infty$ 的硬因果掩码，前者的掩码 $M$ 是一个由衰减因子决定的、连续取值的因果掩码。
::: proof 证明思路（完整推导见原文；这里把三个要点写清）
**(1) 状态递推本来就是矩阵形式。** 把 $\boldsymbol h_t=\bar A_t\boldsymbol h_{t-1}+\bar B_t\boldsymbol x_t$ 展开到 $\boldsymbol h_t=\sum_{j\le t}\bigl(\prod_{k=j+1}^{t}a_k\bigr)\bar B_j\boldsymbol x_j$，可见「第 $j$ 个输入对第 $t$ 个输出的影响」由一个**累积乘积**给出——把它写成矩阵，就是下三角矩阵 $M$ 的第 $(t,j)$ 元。当 $a_k$ 恒为常数时它退化成等比数列（这正是 [2.7.2](#sec-2.7.2) 的卷积核）；当 $a_k$ 随输入变化时它是逐元素不同的衰减。

**(2) 「标量 × 恒等」这一步是关键。** 一般 SSM 里 $A$ 是 $N\times N$ 矩阵，$\prod$ 中的因子是矩阵（矩阵乘积不可交换、也无法折成逐元素形式），因此**写不成 $M\odot(\cdot)$ 这种「逐元素乘一个标量掩码再乘 $\boldsymbol V$」的形状**。把 $A$ 限制为标量倍恒等（对角且逐通道同一标量）后，累积乘积变成标量的累积乘积，掩码可以逐元素给出——这才有「矩阵乘 + 逐元素掩码」的注意力等价形式。

**(3) 由此得到两种实现。** 同一算子在训练（长序列、可并行）时用**分块矩阵乘**实现（每块内部算稠密注意力、块之间用状态传递，和 [2.7.3](#sec-2.7.3) 的分块是同一件事的不同视角），在推理（流式）时用**递推**实现（$O(1)$ 状态）。二者数值上等价、性能特征不同。$\blacksquare$
:::
:::

::: intuition 「对偶」到底说明白了什么
它说明的不是「Mamba 比注意力强」，而是「**两者的差别是一个掩码矩阵的结构差异**」：注意力用硬因果掩码（0 / $-\infty$，可以有任意精细的逐元素模式），SSM 用由衰减因子生成的**低秩 / 半可分**掩码（$M_{ij}$ 只由两端的位置累积决定，中间自由度小）。于是「谁能做什么」变成了一个关于掩码矩阵的问题：**需要精确、稀疏、任意模式的检索时，硬掩码更灵活**；**只需要平滑的、随距离衰减的聚合时，半可分掩码更便宜**。这也解释了为什么 Mamba-2 的实现能复用注意力 kernel 的工程成果（分块、片上内存、tiling）。
:::

**工程含义（论文报告 + 本书判断）**：既然是同一算子，系统实现就可以按场景挑路径——预填充 / 长序列训练走分块矩阵乘（吃满 GPU 的矩阵乘吞吐），逐 token 生成走递推（省显存、省带宽）。**限定条件必须写清**：① 对偶**只对满足上述结构约束的 SSM 成立**，一般时不变 SSM（$A$ 为一般矩阵、含低秩修正）与含更复杂耦合的变体不自动等于注意力；② 对偶是「**在给定参数下、两个公式描述同一个映射**」这类算子层面的等价，**不等于表达能力等价**（掩码族的宽度不同，能表达的函数集合就不同）；③ 该结论的推导与实验条件以原文为准。

::: think 它对「架构之争」的意义：别问谁替代谁，问掩码要多宽
把三条路线放进同一个坐标系：**它们都是「用某种掩码 / 状态结构做长程聚合」**——全注意力是稠密掩码，滑窗是带状掩码，SSM 是半可分掩码，线性注意力是「先聚合再查询」的状态掩码（[2.7.5](#sec-2.7.5)）。于是争论的正确形式不是「Mamba 还是 Transformer」，而是四个可回答的工程问题：① 我的任务需要多宽的掩码（能否容忍低秩 / 半可分近似）？② 我的序列有多长、推理是否流式？③ 我能不能接受「训练时卷积 / 扫描」带来的实现复杂度？④ 我有没有足够的质量评估手段来确认替换后不掉点？**本书判断**：2023 年以来「SSM 全面替代 Transformer」的说法从未被证据支持；有证据支持的是「在若干长序列、允许流式的设定下，SSM 与混合架构能达到可比质量且成本更低」。
:::

## 2.7.5 线性注意力与 RWKV {#sec-2.7.5}

::: def 定义 2.7.3 · 线性注意力（linear attention） {#def-2.7.3}
把 softmax 注意力里的 $\exp(\cdot)$ 相似度换成一个**核函数** $\phi$（逐元素特征映射，通常取非负：$\phi(\boldsymbol x)=1+\operatorname{elu}(\boldsymbol x)$ 或 $\operatorname{ReLU}$），并借助矩阵乘法的**结合律**改变计算顺序：

$$\operatorname{Attention}(\boldsymbol Q,\boldsymbol K,\boldsymbol V)=\phi(\boldsymbol Q)\Bigl(\phi(\boldsymbol K)^{\mathsf T}\boldsymbol V\Bigr)\ \ \text{而不是}\ \ \Bigl(\phi(\boldsymbol Q)\phi(\boldsymbol K)^{\mathsf T}\Bigr)\boldsymbol V .$$

因果情形下写成状态递推（$\boldsymbol q_t,\boldsymbol k_t,\boldsymbol v_t$ 是第 $t$ 步的行向量）：$S_t=S_{t-1}+\phi(\boldsymbol k_t)\boldsymbol v_t^{\mathsf T}$、$\boldsymbol o_t=\phi(\boldsymbol q_t)^{\mathsf T}S_t$、$z_t=z_{t-1}+\phi(\boldsymbol k_t)$、$\boldsymbol o_t\leftarrow\boldsymbol o_t/z_t$（分母归一化）。出处：Katharopoulos et al., 2020, arXiv:2006.16236；核化视角的另一个代表是 Performer（Choromanski et al., 2020, arXiv:2009.14794）。
:::

::: intuition 结合律是全部魔法，也是全部代价
把注意力看成一个检索：$\bigl(\phi(\boldsymbol Q)\phi(\boldsymbol K)^{\mathsf T}\bigr)\boldsymbol V$ 是「先对每个查询与所有键两两打分，再加权取 $\boldsymbol V$」——$T\times T$ 的分数矩阵就跑不掉。换成 $\phi(\boldsymbol Q)\bigl(\phi(\boldsymbol K)^{\mathsf T}\boldsymbol V\bigr)$，**先**把键值合成一个 $d\times d$ 的摘要 $S$，**再**用查询去读它——$T\times T$ 的中间量凭空消失。代价也来自这同一步：$S$ 是**固定容量**的摘要（大小 $d\times d$，与 $T$ 无关），它把历史压缩了，压缩就必然有损；softmax 那种「分数差异大时输出接近 one-hot」的**锐化**能力，在核函数相似度里被抹平了。
:::

::: thm 定理 2.7.3 · 复杂度与代价 {#thm-2.7.3}
因果线性注意力的递推形式每步做一次 $d\times d$ 的外积更新与一次 $d\times d$ 的状态读出，因此

$$\text{时间：}\ O(T^{2}d)\ \longrightarrow\ O(Td^{2}),\qquad \text{中间显存：}\ O(T^{2})\ \longrightarrow\ O(d^{2})\ (\text{状态})\ \text{或}\ O(Td)\ (\text{若物化输出}).$$

**前提与代价**：$\phi$ 的输出维度与 $d$ 同阶；$\phi$ 非负以保证分母是合法归一化；softmax 的锐化被核函数替代后，**依赖「精确找出并复制某个位置」的一类能力会受限**（论文报告：在关联回忆 / 复制类任务上弱于 softmax 注意力；**本书判断**：这类任务恰是长上下文的常见需求，因此纯线性注意力在通用长上下文场景里应谨慎评估）。
::: proof 推导（复杂度交换的完整算术与代价的来源）
**(1) 两种结合顺序的代价。** 设 $\boldsymbol Q\in\mathbb R^{T\times d}$、$\boldsymbol K,\boldsymbol V\in\mathbb R^{T\times d}$（为简洁略去头维）。

- 先打分后聚合：$\bigl(\phi(\boldsymbol Q)\phi(\boldsymbol K)^{\mathsf T}\bigr)\boldsymbol V$ —— 中间矩阵 $T\times T$，乘加次数 $T\cdot T\cdot d+T\cdot T\cdot d=2T^{2}d$，中间显存 $T^{2}$。
- 先聚合后查询：$\phi(\boldsymbol Q)\bigl(\phi(\boldsymbol K)^{\mathsf T}\boldsymbol V\bigr)$ —— 中间矩阵 $d\times d$，乘加次数 $2Td^{2}$，中间显存 $d^{2}$。

两者比值 $T^{2}d/(Td^{2})=T/d$：**序列越长于 $d$，线性顺序越占优**。

**(2) 因果 → 递推。** 因果要求每个查询只能看 $\le t$ 的键，逐 token 展开即 $S_t=S_{t-1}+\phi(\boldsymbol k_t)\boldsymbol v_t^{\mathsf T}$（外积累积），读出 $\boldsymbol o_t=\phi(\boldsymbol q_t)^{\mathsf T}S_t$。分母同理累积 $z_t$ 以保证归一化，故推理显存只含 $S_t$（$d\times d$）与 $z_t$——**与 $T$ 无关**。

**(3) 代价的机制。** softmax 的输出权重 $\exp(s_i)/\sum_j\exp(s_j)$ 在分数差异大时**饱和**为近似 one-hot，于是模型可以实现「找出最匹配的那一个键、把它的 $\boldsymbol V$ 原样取出」；核化之后权重是 $\phi(\boldsymbol q)^{\mathsf T}\phi(\boldsymbol k)$ 的连续函数，加上 $S$ 是固定容量的摘要，**「精确挑一个」与「原值复制」都变成近似操作**。书面上这表现为关联回忆类任务（如「复制第 3 个 token」「按 key 取 value」）的明显差距。**论文报告**：线性注意力（Katharopoulos et al., 2020）在这类基准上弱于 softmax 注意力；GLA（Yang, Wang et al., 2023, arXiv:2312.06635）用**门控**（对 $S_t$ 加上随输入变化的衰减）与硬件友好的分块训练，报告在若干语言建模基准上缩小了差距——但代价仍在，它换来的是「更好的遗忘与累积控制」，不是「恢复精确检索」。$\blacksquare$
:::
:::

::: intuition $T$ 与 $d$ 谁大，决定了两条路的胜负
把 $T^{2}d$ 与 $Td^{2}$ 的比值记成 $T/d$：序列越长于模型维度，线性顺序越省；反过来，在短序列（$T$ 不远大于 $d$）里，线性注意力的状态读出（每步 $d\times d$）可能比直接算稠密注意力更贵——这与 [例 2.7.1](#ex-2.7.1) 的第 2 问、[2.7.11](#sec-2.7.11) 第 6 条是同一件事。还有一条容易忽略的代价：$S\in\mathbb R^{d\times d}$ 是**固定容量**的摘要，长序列里旧信息会被新信息挤掉（与 [2.2](sec22.md) 里 RNN 隐状态的有损性是同一种损失），所以「更省」与「记得更少」是同一次交换的两面。
:::

**RWKV（Receptance Weighted Key Value）**走的是同一条「训练可并行、推理常数内存」的路线，但把混合结构写成两个可并行算子的组合：**论文事实**：Peng et al.（2023, arXiv:2305.13048）把注意力的位置权重与递推的时间衰减结合为 WKV 递推，并报告在若干基准上与其同规模 Transformer 可比；Peng et al.（2025, arXiv:2503.14456，RWKV-7）进一步把状态演化写成更一般的形式（动态状态演化），报告了表达力上的改进。**本书判断**：这两篇的结果都在**特定规模、特定数据与特定评测协议**下成立；「训练可并行 + 推理常数内存」这个**结构性**优势是清晰的（与 [2.7.3](#sec-2.7.3) 的动机一致），而「质量是否追平稠密注意力」必须在你自己的任务上验证——把它当作**默认答案**缺乏依据，把它当作**在流式、超长序列、显存受限场景下的可行候选**是稳妥的。

## 2.7.6 混合架构：交错、拆分与门控 {#sec-2.7.6}

既然纯 SSM 在精确检索上弱、全注意力在长序列上贵，一个自然的工程回答是**混合**：在同一个模型里同时放两种层，让它们各自负责擅长的部分。**论文事实（代表）**：Jamba（Lieber et al., 2024, arXiv:2403.19887）把注意力层与 Mamba 层按**约 1:7** 的比例交错（论文描述的块结构是「每 8 层里 1 层注意力 + 7 层 Mamba」，具体配置以原文为准），并在此之上叠加 MoE；论文报告它在长上下文基准上同时取得了吞吐与质量上的优势（条件的核心是「长上下文 + 大吞吐」这一设定）。**本书判断**：混合架构的取舍逻辑只有一句话——**用少量注意力层保住精确检索与全局对齐能力，用大量线性层把长序列的每 token 成本压下来**；混合的价值不在于「两种机制的折中等于最好」，而在于两种成本结构互补。

| 混合方式 | 代表 / 说明 | 解决了什么 | 代价 |
|:--|:--|:--|:--|
| **层间交错** | Jamba（2024, arXiv:2403.19887）：每 8 层 ≈ 1 注意力 + 7 Mamba | KV cache 只由少量注意力层产生；长序列吞吐与显存显著改善 | 两套算子都要实现与调优；注意力层仍是长序列瓶颈（只是层数变少） |
| **层内拆分**（部分头做全局、部分做线性/局部） | 常见工程做法，具体方案因实现而异（**需核实**） | 同一层内混合不同视野，参数量不变 | 一层内跑两种 kernel，调度与显存规划复杂 |
| **门控混合**（按学习到的门加权两路输出） | 与门控线性注意力同源（GLA, 2023, arXiv:2312.06635 用门控控制状态衰减） | 让模型自行决定「何时用精确、何时用便宜」 | 两路的计算成本都付出了，只有当质量收益超过双倍算子开销才划算 |

## 2.7.7 稀疏激活：MoE 层与 top-k 路由 {#sec-2.7.7}

::: def 定义 2.7.4 · 混合专家层与 top-k 路由 {#def-2.7.4}
把一个前馈层（FFN）替换为 $N$ 个**专家** $\{E_i\}_{i=1}^{N}$（每个专家本身就是一个小 FFN，结构与 [2.5.2](sec25.md#sec-2.5.2) 的位置前馈层相同）加一个**路由器**（router）：

$$g(\boldsymbol x)=\operatorname{softmax}\bigl(\operatorname{TopK}(\boldsymbol xW_g)\bigr),\qquad \boldsymbol y=\sum_{i\in\operatorname{TopK}}g_i(\boldsymbol x)\,E_i(\boldsymbol x),$$

其中 $\operatorname{TopK}$ 只保留 logits 最大的 $k$ 个专家（其余位置置 $-\infty$，于是 $g$ 只在被选中的 $k$ 个专家上归一化、和为 1），$W_g\in\mathbb R^{d\times N}$ 是路由权重。这个词用「专家」并不暗示功能分工：**论文报告**（Shazeer et al., 2017, arXiv:1701.06538 起的一系列工作）表明专家会自发出现一定的任务 / 语法分化，但**没有任何机制保证**分工是干净或可命名的（相关口径见 [2.7.11](#sec-2.7.11)）。
:::

::: intuition 为什么专家放在 FFN 上
回到 [2.5.2](sec25.md#sec-2.5.2) 的参数量事实：经典配置 $d_{\text{ff}}=4d$ 下 FFN 占块内参数约**三分之二**（[例 2.5.1](sec25.md#ex-2.5.1) 的手算给出了这个比例）。**要稀疏化，就得在有参数的地方动手**：注意力和归一化加起来只占三分之一，替换它们的收益有限；而 FFN 是「逐位置、参数量大、结构相同」的模块，天然适合拆成多个平行专家并按 token 选择。另一个原因在计算模式：FFN 是**逐 token** 的（不跨位置），因此不同 token 走不同专家时，彼此之间没有依赖——这让「按 token 分派」在实现上可行（代价是通信，见 [2.7.8](#sec-2.7.8)）。
:::

::: thm 定理 2.7.4 · 稀疏激活把「总参数量」与「每 token 计算量」解耦 {#thm-2.7.4}
设 $N$ 个专家、每个专家 $P$ 个参数、每 token 选 $k$ 个（$k\ll N$）。则**专家部分的参数量** $\approx NP$，而**每 token 在专家上的计算量** $\approx kP$（按乘加次数与参数量同阶计）。两者之比为 $N/k$：**总参数与每 token 计算量不再绑定**，这正是 MoE 的规模化机制。
::: proof 推导与两条必须附带的条件
**(1) 参数与计算量分别计数。** 参数：$N$ 个专家各存 $P$ 个参数，**推理时全部要放在显存里**（无论这个 token 是否用到它）⇒ 总参数量 $NP$（再加路由器 $dN$ 个参数与稠密部分）。计算：每 token 只经过被选中的 $k$ 个专家 ⇒ 前向乘加次数约 $kP$；反向亦同。

**(2) 与稠密模型的对照。** 一个参数量相当的稠密 FFN 每 token 要算 $NP$ 次乘加；MoE 把它降到 $kP$，倍数为 $N/k$。举例：$N=8$、$k=2$ ⇒ 每 token 只付 $2/8=25\%$ 的专家计算量，而总参数是单专家的 8 倍。**论文报告**：Mixtral（Jiang et al., 2024, arXiv:2401.04088）的 8×7B / top-2 配置报告总参数约 $46.7$B、每 token 激活约 $12.9$B（**以原文为准**）；DeepSeek-V3（DeepSeek-AI, 2024, arXiv:2412.19437）报告总参数 $671$B、每 token 激活 $37$B（**以原文为准**）。两组数字都是「总参数 ≫ 激活参数」的同一现象。

**(3) 条件之一：通信与调度成本。** $kP$ 只是算术量。真实代价还包括把 token 送到专家所在设备、把结果取回（all-to-all 通信，见 [2.7.8](#sec-2.7.8)），以及负载不均导致的设备空转——这部分在单卡小规模上不明显，在专家并行下可能吃掉大部分收益。

**(4) 条件之二：专家切分方式影响质量。** **论文报告**：DeepSeekMoE（Dai et al., 2024, arXiv:2401.06066）提出两个改动——**细粒度专家**（把专家切得更小更多，让每 token 的组合更灵活）与**共享专家**（总有若干个专家对每个 token 都激活，承载通用知识），并报告在相同激活参数预算下优于更粗的切分。这说明「$N$ 越大越好」并不成立，**粒度与共享结构同样重要**（详见 [2.7.11](#sec-2.7.11) 第 5 条）。$\blacksquare$
:::
:::

::: intuition 为什么这条结论配得上「解耦」两个字
稠密模型的困境是：想提高总参数（容量），就必须把每 token 的计算量一起抬上去——参数量与计算量是**同一个旋钮**。MoE 用一次**条件计算**（conditional computation）把它们拆成两个旋钮：容量由专家总数 $N$ 决定，每 token 成本由 $k$ 决定，$N/k$ 就是那根杠杆。两条工程推论随之而来：① 显存按 $N$ 涨（要装下**所有**专家），吞吐按 $k/N$ 降（每 token 只算 $k$ 个）——所以 MoE 的本质是**显存换吞吐**；② 路由器成了一个「负载均衡器」，它一旦倾斜，模型的有效容量与设备利用率会同时下降，这正是 [2.7.8](#sec-2.7.8) 要单独处理的原因。
:::

## 2.7.8 负载均衡、容量因子与专家并行 {#sec-2.7.8}

::: method 负载均衡损失与容量因子 {#method-2.7.2}
**问题**：路由器是**按每个 token 独立**选的，没有任何机制保证 $N$ 个专家被用得均匀。常见的坍缩是「少数专家吃掉大多数 token、其余专家几乎不被训练」——既浪费参数，也让梯度分布失衡。

**辅助损失（auxiliary loss）**：Switch Transformer（Fedus, Zoph & Shazeer, 2021, arXiv:2101.03961）一类实现用

$$L_{\text{aux}}=\alpha\,N\sum_{i=1}^{N}f_i\,P_i ,$$

逐项解释：$f_i$ = **路由到专家 $i$ 的 token 比例**（由硬选择统计得到，本身不可导）；$P_i$ = **专家 $i$ 的平均路由概率**（softmax 之后的、可导的量）；$N$ = 专家数；$\alpha$ = 系数（Switch 一类实现里常在 $10^{-2}$ 量级，具体取值与是否随步数衰减依实现，**需核实**）。

**为什么用「比例 × 概率」**：$f_i$ 是我们想让它均衡的对象，但它来自硬选择（不可导）；$P_i$ 可导。二者相乘，梯度就能推动「路由概率」向低使用率的专家移动，从而间接改变硬选择。均匀时 $f_i=P_i=1/N$，故 $L_{\text{aux}}=\alpha N\cdot N\cdot N^{-2}=\alpha$，给出一个常数基线——**监控 $L_{\text{aux}}$ 的意义在于看它是否显著高于 $\alpha$**。

**容量因子（capacity factor）与 token 丢弃**：工程实现给每个专家一次最多处理 $\text{CF}\times T_{\text{batch}}/k$ 个 token 的容量（$T_{\text{batch}}$ 是批内 token 总数）。超出容量的 token 被**丢弃**（跳过该 MoE 层、直接走残差）。CF 小 ⇒ 丢弃多、质量受损；CF 大 ⇒ 显存与计算浪费、把负载不均掩盖成缓冲。**本书判断**：CF 与 $\alpha$ 是「吞吐—质量」的两个旋钮，必须与专家数、batch 大小联合调，单独调其中一个很难判断因果。

**无辅助损失的替代方案（论文报告）**：DeepSeek-V3（2024, arXiv:2412.19437）报告用**按使用率动态调整的专家偏置**替代辅助损失：把偏置加在路由 logits 上、按「该专家是否过载」移动偏置，从而在**不引入与语言建模目标竞争的损失项**的前提下维持均衡（具体更新规则以原文为准）。
:::

| 专家并行（EP）的维度 | 做法 | 代价 |
|:--|:--|:--|
| 切分对象 | 专家分布到不同设备，每卡只保存一部分专家的权重 | 单卡专家参数显存下降；但要求专家数足够多、可整除 |
| 通信模式 | 每个 MoE 层两次 all-to-all：**dispatch**（把 token 送到专家所在设备）与 **combine**（取回计算结果） | all-to-all 是带宽瓶颈；通信量随「每 token 激活的专家数」与序列长度增长 |
| 与负载均衡的联系 | 路由越不均，部分设备越忙、其余空转 ⇒ 吞吐塌陷 | 需要负载均衡损失 / 偏置 / CF 共同控制尾延迟 |
| 与计算的重叠 | 现代实现把 all-to-all 与前后层计算做流水重叠 | 需要足够深的流水与合适的批次划分，调度复杂（第 9 讲展开） |

## 2.7.9 架构对比 {#sec-2.7.9}

::: method 复杂度、显存与适用场景对照表 {#method-2.7.3}
下表用于**按约束选型**，不是排行榜。每格的结论都带条件（写在下表的注释里）；表中 $T$ 为序列长、$d$ 为模型维、$N$ 为每通道状态维、$W$ 为窗口大小、$N_{\text{exp}}$ / $k$ 为专家数与每 token 激活数。

| 架构 | 每 token 复杂度（训练 / 推理） | 训练并行度 | 推理状态 | 长程精确回忆 | 训练稳定性 | 典型场景 |
|:--|:--|:--|:--|:--|:--|:--|
| **RNN / LSTM** | $O(d^{2})$ / $O(d^{2})$ | 沿时间**串行** | $O(d)$ | 弱（定长有损摘要，[2.2](sec22.md)） | 门控缓解消失、裁剪治爆炸（[2.3](sec23.md)） | 流式、端侧、小数据、逐点处理 |
| **Transformer（全注意力）** | $O(Td+T^{2}d)$ / 每步 $O(Td)$ | **完全并行** | $O(T)$（KV cache） | **强**（任意两点路径 $O(1)$） | 依赖 Pre-LN / warmup；长序列显存吃紧 | 通用语言模型；需要精确检索与长程依赖 |
| **滑窗 / 稀疏注意力** | $O(TWd)$ / 每步 $O(Wd)$ | 可并行，但 kernel 利用率通常更低 | $O(Wd)$ 或常数 | 中（靠多层堆叠间接覆盖，路径变长） | 同全注意力；掩码实现易错 | 长文档、局部相关主导的模态（音频 / 视觉） |
| **线性注意力 / RWKV** | $O(Td^{2})$ / 每步 $O(d^{2})$ | 可并行（结合律 / 分块） | $O(d^{2})$ | 弱–中（固定容量状态，[2.7.5](#sec-2.7.5)） | 对核函数、门控与归一化敏感 | 超长序列、流式生成、显存受限部署 |
| **SSM（Mamba）** | 状态更新 $O(TdN)$ + 投影 $O(Td^{2})$ / 每步 $O(dN)+O(d^{2})$ | 可并行（并行扫描） | $O(dN)$ | 弱–中（有损摘要；选择性改善「按内容记忆」） | 受 $\Delta$ 与 $A$ 的数值范围、混合精度影响 | 长序列（基因组 / 音频 / 长文档）、推理内存受限 |
| **混合（Jamba 类）** | 介于两者之间（少量 $O(T^{2})$ 层 + 多数 $O(T)$ 层） | 可并行（两类层各自并行） | 注意力层 $O(T)$ + SSM 层 $O(dN)$ | 中–强（保留少量全局注意力层做精确检索） | 两种算子数值特性不同，需分别调 | 既要长上下文、又要精确检索的通用模型 |
| **MoE-Transformer** | 稀疏部分 $O(kP)$ + 稠密部分（注意力 $O(T^{2}d)$） | 可并行，另加 all-to-all 通信 | 同 Transformer，另加**全部**专家参数的显存 | 强（仍是自注意力） | 需要负载均衡 / CF；路由不稳会拖累训练 | 追求「大总参数、小每 token 计算」的规模化训练 |

**注释（必读）**：① 「每 token 复杂度」里 $O(\cdot)$ 只描述**渐近阶**；常数与硬件利用率常决定实测胜负（[2.7.11](#sec-2.7.11) 第 6 条）。② Transformer 的 $O(T^{2}d)$ 在训练时是算术瓶颈，在推理时主要体现为 KV cache 的显存与带宽（[2.6.6](sec26.md#sec-2.6.6)）。③ SSM 的 $O(TdN)$ 与线性注意力的 $O(Td^{2})$ 都**不含**投影矩阵的开销，实际实现里投影往往占比可观。④ 「长程精确回忆」一列是本书基于机制（容量是否随 $T$ 增长、能否锐化到 one-hot）与公开实验给出的判断，**不是单一基准的排名**。⑤ MoE 省的是**每 token 计算量**，不省总参数显存（[2.7.11](#sec-2.7.11) 第 3 条）。
:::

::: ex 例 2.7.1 · 复杂度与显存手算 {#ex-2.7.1}
取 $T=8192$、$d=2048$、FP16（2 字节），注意力按 $H=16$ 头（$d_h=128$）、$B=1$ 计，SSM 按每通道状态维 $N=16$、层数 $L=24$ 计。

(1) 每层自注意力的分数矩阵元素数与显存、以及前向注意力 FLOPs。
(2) 对角 SSM 的状态大小与每 token 更新量（与 $T$ 的关系）；并与注意力的**每 token** 推理开销对照。
(3) 8 个专家、top-2 路由时，专家部分「激活参数 / 总参数」的比例；说明它为什么**不是**整体每 token FLOPs 的比例。

::: proof 解
**(1) 分数矩阵与 FLOPs。** 元素数 $B\cdot H\cdot T^{2}=1\times16\times8192^{2}$。由 $8192=2^{13}$，$T^{2}=2^{26}=6.71\times10^{7}$，乘 16 得 $2^{30}=1.07\times10^{9}$ 个元素；$\times2$ 字节 $=2^{31}$ 字节 $=\mathbf{2\ GiB}$（**单层**）。FLOPs 约

$$4BHT^{2}d_h=4\times1.07\times10^{9}\times128=5.50\times10^{11}\approx\mathbf{0.55\ TFLOP}\ (\text{单层前向}).$$

（对照 [例 2.6.1](sec26.md#ex-2.6.1)：$T$ 从 8192 变 131072、$H$ 从 16 变 32 时，这两项各乘 $16\times2=32$。）

**(2) SSM 的状态与每 token 更新量。** 每通道一个 $N$ 维状态：单层状态 $\boldsymbol h_t\in\mathbb R^{d\times N}$，共 $dN=2048\times16=32768$ 个元素（FP16 约 $64$ KiB），**与 $T$ 无关**；整模型 $L=24$ 层约 $24\times32768=7.86\times10^{5}$ 个元素（$\approx1.5$ MiB，FP16）——这也是「推理状态 $O(1)$」在数字上的样子。每 token 的状态更新是逐元素运算，量级 $O(dN)=3.3\times10^{4}$ 次乘加；此外还要算投影（$\Delta,B,C$ 与输入/输出，量级 $O(d^{2})\approx4.2\times10^{6}$）。对照注意力：**每 token** 推理需与全部历史做注意力，约 $2\cdot T\cdot d=2\times8192\times2048=3.36\times10^{7}$ 次乘加（$T=131072$ 时变成 $5.4\times10^{8}$），而 SSM 的这一项**不随 $T$ 变**。**结论**：SSM 的优势不是「每 token 更便宜」（$T$ 小时两者同量级，投影项甚至更贵），而是「每 token 成本不随 $T$ 增长」。

**(3) 专家的激活比例。** 专家部分：总参数 $\approx N_{\text{exp}}P$，每 token 只用 $k$ 个 ⇒ 激活比例 $k/N_{\text{exp}}=2/8=\mathbf{25\%}$。但它**不是**整体每 token FLOPs 的比例：模型里还有注意力、嵌入、归一化等**稠密**部分（每 token 都要算），而且被激活的 2 个专家仍是完整 FFN。所以正确的读法是：**MoE 把「FFN 这一块」的每 token 计算量降到 $25\%$，整体每 token 计算量高于 $25\%$ 但远低于稠密等参数量模型**。$\blacksquare$
:::
:::

## 2.7.10 代码：分块线性注意力、选择性扫描与 MoE 路由 {#sec-2.7.10}

```python
import torch, torch.nn.functional as F

torch.manual_seed(0)
B, T, d = 2, 16, 8
q, k, v = torch.randn(B, T, d), torch.randn(B, T, d), torch.randn(B, T, d)
phi = lambda x: F.elu(x) + 1.0            # 非负核映射：保证分母是合法归一化

# ① 逐步递推版：S_t = S_{t−1} + φ(k_t) v_tᵀ，o_t = φ(q_t)ᵀ S_t（状态 d×d，与 T 无关）
def linear_attn_step(q, k, v, phi):
    Bn, Tn, dn = q.shape
    S, outs = torch.zeros(Bn, dn, dn), []
    for t in range(Tn):
        S = S + phi(k[:, t]).unsqueeze(-1) * v[:, t].unsqueeze(-2)   # 外积累积到状态
        outs.append((phi(q[:, t]).unsqueeze(-2) @ S).squeeze(-2))    # 用查询读状态
    return torch.stack(outs, 1), S

# 分块版：块内做因果前缀和、块间只通过状态传递（结合律换来的并行度）
def linear_attn_chunked(q, k, v, phi, C=4):
    Bn, Tn, dn = q.shape
    S, outs = torch.zeros(Bn, dn, dn), []
    for s in range(0, Tn, C):
        qc, kc, vc = phi(q[:, s:s + C]), phi(k[:, s:s + C]), v[:, s:s + C]
        intra = (qc @ kc.transpose(-2, -1)).tril() @ vc              # 块内：因果加权
        outs.append(intra + qc @ S)                                  # 块间：读上一块末状态
        S = S + kc.transpose(-2, -1) @ vc                            # 状态更新与块大小无关
    return torch.cat(outs, 1), S

o1, S1 = linear_attn_step(q, k, v, phi)
o2, S2 = linear_attn_chunked(q, k, v, phi, C=4)
assert torch.allclose(o1, o2, atol=1e-5) and torch.allclose(S1, S2, atol=1e-5), "分块与递推不一致"

# ② 循环版选择性扫描（教学版；生产实现用并行扫描，见方法 2.7.1）
def selective_scan(u, delta, A, Bm, Cm):
    """u:(B,T,d) delta:(B,T,d) A:(d,N) Bm,Cm:(B,T,N) → y:(B,T,d)"""
    Bn, Tn, dn = u.shape; N = A.shape[1]
    h, ys = torch.zeros(Bn, dn, N), []
    for t in range(Tn):
        dA = torch.exp(delta[:, t].unsqueeze(-1) * A)                # Ā_t = exp(Δ_t A)：随输入变
        h = dA * h + delta[:, t].unsqueeze(-1) * Bm[:, t].unsqueeze(1) * u[:, t].unsqueeze(-1)
        ys.append((h * Cm[:, t].unsqueeze(1)).sum(-1))               # 由 C_t 读出
    return torch.stack(ys, 1), h

u = torch.randn(B, T, d); delta = F.softplus(torch.randn(B, T, d))
A = -torch.rand(d, 16); Bm = Cm = torch.randn(B, T, 16)
y, h = selective_scan(u, delta, A, Bm, Cm)

# ③ MoE 路由 + 辅助损失（对照 2.7.8 的公式）
class MoELayer(torch.nn.Module):
    def __init__(self, d, n_exp, k):
        super().__init__()
        self.experts = torch.nn.ModuleList([torch.nn.Sequential(
            torch.nn.Linear(d, 4 * d), torch.nn.SiLU(), torch.nn.Linear(4 * d, d)) for _ in range(n_exp)])
        self.gate, self.k = torch.nn.Linear(d, n_exp, bias=False), k
    def forward(self, x):
        logits = self.gate(x)
        topv, topi = logits.topk(self.k, dim=-1)          # 每 token 只挑 k 个专家
        g = F.softmax(topv, dim=-1)                       # 只在 top-k 内归一化
        out = torch.zeros_like(x)
        for j in range(self.k):                           # 只为被选中的专家付计算
            idx = topi[:, j]
            for e in idx.unique():
                m = idx == e
                out[m] += g[m, j].unsqueeze(-1) * self.experts[e](x[m])
        f = F.one_hot(topi, logits.size(-1)).sum(1).float().mean(0)   # f_i：路由到专家 i 的比例
        P = F.softmax(logits, -1).mean(0)                             # P_i：专家 i 的平均路由概率
        return out, (f * P).sum() * logits.size(-1)                   # 辅助损失 ∝ Σ f_i P_i

x = torch.randn(64, d)
y_moe, aux = MoELayer(d, 8, 2)(x)
print("MoE 输出形状", tuple(y_moe.shape), "| aux =", round(aux.item(), 4))   # 均衡时基线为 1.0
```

三段代码对应三条主线：**①** 线性注意力的「分块并行」与「逐步递推」在数值上必须**完全一致**（这个断言是验证实现是否写对的最有效手段）；**②** 选择性扫描写出循环版本即可看清「$\bar A_t$ 随输入变化」——生产实现用并行扫描（[方法 2.7.1](#method-2.7.1)）把它并行化，但数学不变；**③** MoE 的稀疏性体现在「只为 top-k 专家算」（循环里的 `idx.unique()`），辅助损失同时给出可用于监控的标量（均匀时约为 $\alpha N\cdot N^{-1}=\alpha$ 量级的常数）。

## 2.7.11 陷阱与勘误 {#sec-2.7.11}

::: errata 本节六个必须说清的误解
1. **「Mamba / RWKV 已经全面替代 Transformer」**：要求**证据口径**。可核查的表述是：在若干长序列、允许流式的设定下，SSM 与混合架构报告了**可比质量与更低成本**（Mamba 2023, arXiv:2312.00752；Jamba 2024, arXiv:2403.19887；RWKV 2023, arXiv:2305.13048，各自条件见原文）。而在需要**精确检索、任意模式注意力、成熟生态与工具链**的通用场景里，注意力仍是默认选择。「全面替代」既无基准支持，也无部署证据支持；正确的做法是列出任务约束再选型（[2.7.9](#sec-2.7.9)）。
2. **「线性注意力是无损的」**：不是。它把 softmax 的锐化换成核函数相似度、把历史压进固定容量的 $d\times d$ 状态（[定理 2.7.3](#thm-2.7.3)）；在关联回忆 / 复制类任务上弱于 softmax 注意力是**论文报告**的现象。「省了多少」与「丢了多少」必须一起报。
3. **「MoE 省显存」**：它省的是**每 token 计算量**，不省总参数显存——所有专家参数都要常驻（[定理 2.7.4](#thm-2.7.4) 的计数）。MoE 的显存需求反而**更大**（总参数更多），收益是 FLOPs 与吞吐。把「稀疏激活」读成「省内存」会直接算错部署预算。
4. **「SSD 对偶对所有 SSM 成立」**：对偶要求状态转移被限制为「标量 × 恒等」这类结构，从而掩码才可写成半可分形式（[定理 2.7.2](#thm-2.7.2)）。一般时不变 SSM（$A$ 为一般矩阵）与更复杂的变体**不自动**等于注意力；对偶是算子层面的等价，也不等于表达能力等价。
5. **「专家越多越好」**：**论文报告**：DeepSeekMoE（2024, arXiv:2401.06066）的有效性来自**细粒度切分 + 共享专家**的组合，而不是单纯堆专家数；专家过多还会放大路由不稳定、all-to-all 通信与负载不均（[2.7.8](#sec-2.7.8)）。粒度和均衡机制与专家数同等重要。
6. **「$O(T)$ 一定优于 $O(T^{2})$」**：这是本节最需要警惕的一条。渐近阶只描述大 $T$ 行为；实测中矩阵乘能跑满硬件，而扫描 / 逐元素算子常常是访存受限的。在中小 $T$ 上 SSM 与线性注意力**比稠密注意力更慢**是常见现象（[例 2.7.1](#ex-2.7.1) 的 (2) 已经显示：$T=8192$ 时 SSM 的投影项与注意力的每 token 开销同量级）。**本书判断**：报结论时必须附上「$T$、硬件、实现、batch」，否则「线性更快」是不可检验的断言。
:::

::: method 即时自测 · 2.7 {#method-2.7.4}
**Q1** 写出线性 SSM 的连续形式与零阶保持离散化，并说明「线性 + 时不变」带来了哪两个好处、代价是什么。

**Q2** 为什么 Mamba 的「选择性」使 [定理 2.7.1](#thm-2.7.1) 的卷积形式失效？它用什么办法换回训练的并行度？

**Q3** Mamba-2 的对偶说的到底是什么？写出它的限定条件（至少两条）。

**Q4** 8 个专家、top-2 路由：专家部分的「激活参数 / 总参数」是多少？为什么整体每 token FLOPs 的比例不等于这个数？MoE 省的是显存还是计算量？

::: sol 参考要点
**Q1** 连续形式 $\boldsymbol h'=A\boldsymbol h+B\boldsymbol x$、$\boldsymbol y=C\boldsymbol h$；离散化 $\bar A=\exp(\Delta A)$、$\bar B=(\exp(\Delta A)-I)A^{-1}B$、$\boldsymbol h_t=\bar A\boldsymbol h_{t-1}+\bar B\boldsymbol x_t$。好处：① 递推可展开成固定核的**因果卷积**，训练能并行（FFT 或分块）；② 推理只需**与 $T$ 无关**的常数状态。代价：转移线性且时不变 ⇒ 记忆 / 遗忘的规则不随内容变化，「该记什么」不能由输入决定（这正是 [2.7.3](#sec-2.7.3) 的动机）；外加长程能力依赖 $A$ 的初始化（HiPPO 一类）。

**Q2** 因为 $\bar A_t,\bar B_t,C_t$ 都随输入变化，核不再是固定的 $\bar K_{t-j}$，卷积形式（以及 FFT 并行）不再成立。换回并行度的办法是**并行扫描**：把递推视为可结合的线性算子，分块后块内串行、块间做前缀扫描（[方法 2.7.1](#method-2.7.1)），并行深度降到 $O(T/C)$；同时把中间状态留在片上内存、避免反复往返显存。

**Q3** 它说的是：当状态转移被限制为「标量 × 恒等」（$\bar A_t=a_tI$）时，SSM 的输出可写成 $\boldsymbol Y=(M\odot\boldsymbol Q\boldsymbol K^{\mathsf T})\boldsymbol V$，其中 $M$ 是由 $a_t$ 累积乘积构成的**半可分下三角矩阵**——于是 SSM 与「带因果掩码的注意力」同族（论文证明，2405.21060）。限定条件：① 只对满足该结构约束的 SSM 成立（一般 $A$ 不成立）；② 是算子层面的等价，**不等于**表达能力等价（掩码族宽度不同）；③ 它不解决训练稳定性与数值精度问题——那要靠实现层面的处理。

**Q4** 比例是 $k/N_{\text{exp}}=2/8=25\%$（专家部分的激活参数占比）。整体每 token FLOPs 的比例更高，因为注意力、嵌入、归一化等**稠密**部分每 token 都要算，而且被选中的 2 个专家仍是完整 FFN。MoE 省的是**每 token 计算量**（以及由此带来的吞吐收益），**不省总参数显存**：全部专家权重都要常驻。
:::
:::

::: note[skip] 延伸阅读
- Gu et al., *HiPPO*（2020, arXiv:2008.07669）——读「用正交多项式投影在线压缩历史」这一视角：$A$ 的结构从哪来。
- Gu, Goel & Ré, *S4*（2021, arXiv:2111.00396）——读结构化矩阵参数化与长序列基准结果；[2.7.2](#sec-2.7.2) 的依据。
- Smith, Warrington & Linderman, *S5*（2022, arXiv:2208.04933）——读「对角化 $A$ + 并行扫描」如何简化实现。
- Gu & Dao, *Mamba*（2023, arXiv:2312.00752）——读选择性机制、硬件感知扫描与实验条件（[2.7.3](#sec-2.7.3)）。
- Dao & Gu, *Transformers are SSMs*（Mamba-2，2024, arXiv:2405.21060）——读半可分矩阵与对偶的证明思路（[2.7.4](#sec-2.7.4)）。
- Katharopoulos et al., *Transformers are RNNs*（2020, arXiv:2006.16236）、Choromanski et al., *Performer*（2020, arXiv:2009.14794）——线性注意力的两种出发点（结合律 vs 核近似）。
- Yang, Wang et al., *GLA*（2023, arXiv:2312.06635）——读「线性注意力 + 门控」如何改善遗忘与训练效率。
- Peng et al., *RWKV*（2023, arXiv:2305.13048）、Peng et al., *RWKV-7*（2025, arXiv:2503.14456）——读 WKV 递推与「训练并行、推理常数内存」的折中。
- Lieber et al., *Jamba*（2024, arXiv:2403.19887）——读注意力与 SSM 层的交错比例与长上下文实验（[2.7.6](#sec-2.7.6)）。
- Shazeer et al., *Outrageously Large Neural Networks*（2017, arXiv:1701.06538）、Lepikhin et al., *GShard*（2020, arXiv:2006.16668）、Fedus, Zoph & Shazeer, *Switch Transformers*（2021, arXiv:2101.03961）——MoE 的起点、容量因子的来源、辅助损失的来源（[2.7.7](#sec-2.7.7)–[2.7.8](#sec-2.7.8)）。
- Jiang et al., *Mixtral of Experts*（2024, arXiv:2401.04088）、Dai et al., *DeepSeekMoE*（2024, arXiv:2401.06066）、DeepSeek-AI, *DeepSeek-V3*（2024, arXiv:2412.19437）——读总参数 / 激活参数的口径、细粒度专家与共享专家、以及用动态偏置替代辅助损失。
:::

**本节小结**：本节的三条替代路线可以按**复杂度—记忆—并行**三条张力回收。**复杂度**：线性 SSM 与线性注意力把每 token 成本从 $O(Td)$ 级降到 $O(d)$ 或 $O(d^{2})$（且推理状态与 $T$ 无关），代价是「渐近优势只在 $T$ 足够大、且实现能跑满硬件时兑现」。**记忆**：固定容量的状态必然有损——SSM 靠 $A$ 的结构（以及 Mamba 的选择性）改善「按内容记忆」，线性注意力靠门控改善遗忘控制，两者都**不能**恢复 softmax 那种精确检索；混合架构（[2.7.6](#sec-2.7.6)）正是为此保留少量全局注意力层。**并行**：线性递推可以用卷积或并行扫描拿回训练并行度（[定理 2.7.1](#thm-2.7.1)、[方法 2.7.1](#method-2.7.1)），Mamba-2 的对偶（[定理 2.7.2](#thm-2.7.2)）进一步说明它与注意力可共用同一套分块工程；MoE 走的是另一条轴——不动序列结构，只把「总参数量」与「每 token 计算量」解耦，代价是路由、负载均衡与 all-to-all 通信（[2.7.8](#sec-2.7.8)）。选型结论一律带条件（[2.7.9](#sec-2.7.9) 对照表），没有「全面更好」的架构。下一节（[2.8](sec28.md)）把本讲的理论落到一个能跑的实验上：用自回归 + 采样把音乐生成跑通一遍。
