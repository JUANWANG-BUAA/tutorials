# 2.4 注意力机制：从压缩瓶颈到查询—键—值

[2.3](sec23.md) 结束时留下了两个未解的问题：门控只是**缓解**了梯度消失，而且 LSTM / GRU **仍然逐步递推**，训练无法沿时间并行。更根本的问题是结构性的：无论门控多聪明，编码器都必须把整段输入压进**一个固定维度的向量**，再交给解码器使用。

这一节正面拆掉这个瓶颈。做法朴素到近乎「不讲道理」：**不要压缩，让解码器在每一步都能回看编码器的所有位置，并按需要加权求和**。这个操作就是**注意力**（attention）。它一次解决了三件事——历史不再有损（信息保留在全部位置上）、路径长度变成 $O(1)$（任意两点直接相连）、训练可以并行（所有位置同时算）。

但注意力不是「免费的午餐」。它把「压缩瓶颈」换成了「**平方复杂度**」：$T$ 个查询与 $T$ 个键两两打分，产生一张 $T\times T$ 的分数矩阵，时间与显存都随 $T^2$ 增长。这就是 [2.6](sec26.md) 要摊薄的账，也是 [2.7](sec27.md) 各种新架构的出发点。本节的任务是把它写成干净的数学：**两种经典打分 → 查询—键—值抽象 → 缩放点积注意力 → 为什么要除以 $\sqrt{d_k}$ → 因果掩码 → 复杂度**，并讨论一个被滥用的说法：「注意力权重能当解释」。

## 2.4.1 编码器—解码器与固定长度瓶颈 {#sec-2.4.1}

序列到序列（seq2seq）任务的经典做法是「编码器—解码器」：一个 RNN 读完整个输入，把信息压进最后一个隐状态；另一个 RNN 从这个向量出发，逐步生成输出。

::: def 定义 2.4.1 · 编码器—解码器与上下文向量 {#def-2.4.1}
设输入 $\boldsymbol x_{1:T}$、输出 $\boldsymbol y_{1:S}$。

**编码器**：$\boldsymbol h_t^{\text{enc}}=\phi(W_{hh}^{\text{enc}}\boldsymbol h_{t-1}^{\text{enc}}+W_{xh}^{\text{enc}}\boldsymbol x_t+\boldsymbol b^{\text{enc}})$，取**上下文向量** $\boldsymbol c=\boldsymbol h_T^{\text{enc}}\in\mathbb R^{d_h}$。

**解码器**：$\boldsymbol s_t=\phi(W_{ss}\boldsymbol s_{t-1}+W_{ys}\boldsymbol y_{t-1}+\boldsymbol b_s)$，输出分布 $\hat p(y_t\mid y_{\lt t},\boldsymbol x_{1:T})=\operatorname{softmax}(W_o[\boldsymbol s_t;\boldsymbol c])$。

关键约束是：**无论 $T$ 多大，解码器只能经由 $\boldsymbol c$ 这一个 $d_h$ 维向量获知输入信息**。
:::

::: intuition 瓶颈不是「不够大」，而是「必须固定」
把 $\boldsymbol c$ 想成一张写满摘要的便签：$d_h$ 决定了便签上能写多少字，而输入长度 $T$ 不受限制。信息论上这是有损压缩——存在一类输入，它们的前缀不同但末端统计量相同，任何固定维度的函数都无法区分它们。工程上的典型症状是**长句翻译丢开头**：主语出现在第 3 个词，但它要影响第 40 个词才输出的谓语，而这份信息必须熬过 37 次状态更新才能到达——正是 [2.2](sec22.md) 的连乘衰减在做的事。所以「瓶颈」有两重含义：**容量固定**（压不下）与**路径太长**（传不过去）。注意力同时对两者动手。
:::

## 2.4.2 两种经典打分：加性与乘性 {#sec-2.4.2}

注意力最早的形式出现在神经机器翻译里：让解码器在第 $t$ 步对编码器**每一个**位置的隐状态打分，再用分数做加权平均。区别只在于「怎么打分」。

::: def 定义 2.4.2 · 加性注意力（Bahdanau 式） {#def-2.4.2}
以解码器状态 $\boldsymbol s_{t-1}\in\mathbb R^{d_s}$ 为查询，对编码器隐状态 $\boldsymbol h_j\in\mathbb R^{d_h}$ 打分：

$$e_{tj}=\boldsymbol v_a^{\mathrm T}\tanh\bigl(W_s\boldsymbol s_{t-1}+W_h\boldsymbol h_j\bigr),\qquad
\alpha_{tj}=\frac{\exp(e_{tj})}{\sum_{j'=1}^{T}\exp(e_{tj'})},\qquad
\boldsymbol c_t=\sum_{j=1}^{T}\alpha_{tj}\boldsymbol h_j,$$

其中 $W_s\in\mathbb R^{d_a\times d_s}$、$W_h\in\mathbb R^{d_a\times d_h}$、$\boldsymbol v_a\in\mathbb R^{d_a}$ 是**可学习**的打分器参数。$T$ 随时间步不同（$t$ 是解码步，$j$ 是编码位置），因此这张分数矩阵是长方形的 $S\times T$。
:::

::: intuition 加性打分：把「匹配」外包给一个小型 MLP
$\tanh(W_s\boldsymbol s+W_h\boldsymbol h)$ 的结构说明：先把查询与键各自投影到同一个 $d_a$ 维空间**相加**，过一次非线性，再用 $\boldsymbol v_a$ 投影成一个标量分数。它的表达能力更强（多了一层非线性），代价是每次打分要多算几次矩阵乘。乘性打分（下一条定义）则直接要求「查询与键必须落在同一空间里做内积」——这在实现上就是把两者都投影到 $d_k$ 维再用一次矩阵乘，可以整批并行计算。今天几乎所有注意力实现都是乘性的，原因很简单：**它能被写成矩阵乘法**（$\boldsymbol Q\boldsymbol K^{\mathrm T}$），而 GPU 最擅长的正是矩阵乘法。
:::

::: def 定义 2.4.3 · 乘性注意力（Luong 式） {#def-2.4.3}
同样以 $\boldsymbol s_{t-1}$ 为查询，三种常见形式：

| 形式 | 打分函数 | 引入的参数 | 说明 |
|:--|:--|:--|:--|
| **dot** | $e_{tj}=\boldsymbol s_{t-1}^{\mathrm T}\boldsymbol h_j$ | 无 | 要求 $d_s=d_h$；最简单、最省参数 |
| **general** | $e_{tj}=\boldsymbol s_{t-1}^{\mathrm T}W_a\boldsymbol h_j$ | $W_a\in\mathbb R^{d_s\times d_h}$ | 允许两侧维度不同，是工程上的默认折中 |
| **concat** | $e_{tj}=\boldsymbol v_a^{\mathrm T}\tanh\bigl(W_a[\boldsymbol s_{t-1};\boldsymbol h_j]\bigr)$ | $W_a,\boldsymbol v_a$ | 与加性注意力等价（拼接口径不同） |

三种形式都接同一个 $\operatorname{softmax}$ + 加权求和：$\boldsymbol c_t=\sum_j\alpha_{tj}\boldsymbol h_j$。
:::

::: intuition 三种形式在回答同一个问题：查询与键要不要先「对齐」
- **dot** 要求两侧维度相同、直接内积，最省参数，但对两侧的尺度与量纲敏感（一侧整体放大 $2$ 倍，分数就整体放大 $2$ 倍）；
- **general** 用 $W_a$ 先把两者对齐到同一空间再内积，因此可以处理 $d_s\neq d_h$，也能让某些维度更重要——它是工程上的常见默认；
- **concat** 退回到「拼起来过一个小 MLP」，与加性注意力等价（只是一个用加法写、一个用拼接写）。

三者的差别通常**远小于**后续超参与数据规模的影响；真正决定成败的是「有没有位置信息、有没有正确的掩码」这些结构问题（[2.4.5](#sec-2.4.5) 与 [2.6](sec26.md)）。
:::

把上面的过程抽象一次，就得到今天通用的写法：把「解码器的提问」叫**查询**（query），把「编码位置挂出的标签」叫**键**（key），把「真正被加权取走的内容」叫**值**（value）。这就是下一节的 QKV 抽象——它不是新机制，只是把同一件事写成矩阵形式。

## 2.4.3 查询—键—值：把注意力抽象成一个算子 {#sec-2.4.3}

::: def 定义 2.4.4 · 缩放点积注意力 {#def-2.4.4}
给定查询矩阵 $\boldsymbol Q\in\mathbb R^{T_q\times d_k}$、键矩阵 $\boldsymbol K\in\mathbb R^{T_k\times d_k}$、值矩阵 $\boldsymbol V\in\mathbb R^{T_k\times d_v}$，

$$\operatorname{Attention}(\boldsymbol Q,\boldsymbol K,\boldsymbol V)=\operatorname{softmax}\!\left(\frac{\boldsymbol Q\boldsymbol K^{\mathrm T}}{\sqrt{d_k}}\right)\boldsymbol V .$$

逐步说明形状与语义：

1. $\boldsymbol S=\boldsymbol Q\boldsymbol K^{\mathrm T}\in\mathbb R^{T_q\times T_k}$，第 $(i,j)$ 项是第 $i$ 个查询与第 $j$ 个键的**内积相似度**；
2. $\boldsymbol S/\sqrt{d_k}$ 是对相似度的**缩放**（理由见 [2.4.4](#sec-2.4.4)）；
3. softmax 沿**键维度**（每一行）归一化：$\boldsymbol P=\operatorname{softmax}(\boldsymbol S/\sqrt{d_k})$，每行和为 1，$P_{ij}$ 解释为「第 $i$ 个查询把多少注意力放在第 $j$ 个位置上」；
4. 输出 $\boldsymbol O=\boldsymbol P\boldsymbol V\in\mathbb R^{T_q\times d_v}$：每个查询得到的是 $\boldsymbol V$ 各行的**凸组合**（权重非负且和为 1）。

在**自注意力**（self-attention）中，$T_q=T_k=T$，且 $\boldsymbol Q,\boldsymbol K,\boldsymbol V$ 都来自**同一个**输入序列的线性投影。

`softmax` 中的 `max` 指**逐元素**的「减去最大值以保证数值稳定」——实现里属于细节，不影响数学定义。
:::

::: intuition 查字典：三路输入各司其职
- **Q（query）**：当前位置**想找什么**。解码时它来自解码器状态（「我正要找一个动词的主语」）；自注意力里它来自当前位置的投影。
- **K（key）**：每个位置挂出的**匹配标签**，用来被检索。$\boldsymbol Q\boldsymbol K^{\mathrm T}$ 就是在量「我想找的」与「这里有的」有多像。
- **V（value）**：每个位置**真正被取走的内容**。权重算好后，聚合的是 $\boldsymbol V$ 而**不是** $\boldsymbol K$。**键负责指路，值负责交货**——这一条是初学者最常搞反的地方。

自注意力带来一个关键性质：**任意两个位置之间的信息路径长度是 $O(1)$**——位置 1 与位置 $T$ 在矩阵乘里是「同时」被联系起来的。对比 RNN 的 $\mathcal O(T)$ 串行路径，这解释了为什么注意力擅长长程依赖。代价是：这份便利要用 $T^2$ 个分数换。

<figure>
<svg class="figure-svg" viewBox="0 0 900 350" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-attn-title fig-attn-desc">
<title id="fig-attn-title">缩放点积注意力：一只头的数据流与形状</title>
<desc id="fig-attn-desc">注意力数据流：Q 与 Kᵀ 相乘得 T×T 的相关度矩阵，除以 √d_k 后逐行 softmax 得权重，再右乘 V 得输出；多头即并排 H 份、最后拼接线性变换。</desc>
<defs>
<marker id="mk-blue" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-blue)"/></marker>
<marker id="mk-purple" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-purple)"/></marker>
<marker id="mk-green" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-green)"/></marker>
<marker id="mk-gold" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-gold)"/></marker>
<marker id="mk-red" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-red)"/></marker>
<marker id="mk-neutral" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-neutral)"/></marker>
</defs>
<text class="diagram-note" fill="ink" x="30" y="30" text-anchor="start" font-weight="700">单头：Attention(Q, K, V) = softmax(QKᵀ/√d_k)·V</text>
<rect x="60" y="66" width="120" height="44" rx="9" fill="var(--fig-blue)" fill-opacity="0.1" stroke="var(--fig-blue)" stroke-width="1.5"/>
<text class="diagram-mono" x="120.0" y="92.5" text-anchor="middle" font-size="13px">Q：想找什么</text>
<rect x="60" y="170" width="120" height="44" rx="9" fill="var(--fig-purple)" fill-opacity="0.1" stroke="var(--fig-purple)" stroke-width="1.5"/>
<text class="diagram-mono" x="120.0" y="196.5" text-anchor="middle" font-size="12.5px">Kᵀ：被匹配的标签</text>
<rect x="560" y="250" width="120" height="44" rx="9" fill="var(--fig-green)" fill-opacity="0.1" stroke="var(--fig-green)" stroke-width="1.5"/>
<text class="diagram-mono" x="620.0" y="276.5" text-anchor="middle" font-size="12.5px">V：被取走的内容</text>
<line x1="182" y1="88" x2="250" y2="128" stroke="var(--fig-blue)" stroke-width="1.7" marker-end="url(#mk-blue)"/>
<line x1="182" y1="192" x2="250" y2="152" stroke="var(--fig-purple)" stroke-width="1.7" marker-end="url(#mk-purple)"/>
<rect x="252" y="118" width="130" height="48" rx="9" fill="var(--fig-neutral)" fill-opacity="0.1" stroke="var(--fig-neutral)" stroke-width="1.5"/>
<text class="diagram-mono" x="317.0" y="146.5" text-anchor="middle" font-size="15px">QKᵀ</text>
<text class="diagram-mono" fill="muted" x="317" y="190" text-anchor="middle" font-size="11.5px">T_q×T_k</text>
<line x1="384" y1="142" x2="430" y2="142" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<rect x="432" y="118" width="96" height="48" rx="9" fill="var(--fig-gold)" fill-opacity="0.1" stroke="var(--fig-gold)" stroke-width="1.5"/>
<text class="diagram-mono" x="480.0" y="146.5" text-anchor="middle" font-size="14px">÷ √d_k</text>
<text class="diagram-note" fill="var(--fig-gold)" x="480" y="190" text-anchor="middle" font-size="12px">防 softmax 饱和</text>
<line x1="530" y1="142" x2="570" y2="142" stroke="var(--fig-gold)" stroke-width="1.7" marker-end="url(#mk-gold)"/>
<rect x="572" y="118" width="110" height="48" rx="9" fill="var(--fig-red)" fill-opacity="0.1" stroke="var(--fig-red)" stroke-width="1.5"/>
<text class="diagram-mono" x="627.0" y="146.5" text-anchor="middle" font-size="12px">softmax（按行）</text>
<line x1="684" y1="142" x2="730" y2="190" stroke="var(--fig-red)" stroke-width="1.7" marker-end="url(#mk-red)"/>
<line x1="682" y1="272" x2="736" y2="252" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<rect x="738" y="196" width="130" height="56" rx="9" fill="var(--fig-green)" fill-opacity="0.1" stroke="var(--fig-green)" stroke-width="1.5"/>
<text class="diagram-mono" x="803.0" y="228.5" text-anchor="middle" font-size="14px">权重 · V</text>
<text class="diagram-mono" fill="var(--fig-green)" x="803" y="276" text-anchor="middle" font-size="13px">输出</text>
<text class="diagram-mono" fill="muted" x="803" y="292" text-anchor="middle" font-size="11.5px">T_q×d_v</text>
<rect x="60" y="316" width="400" height="40" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-note" fill="ink" x="260" y="334" text-anchor="middle" font-size="12.5px">多头 = 并排 H 份（各自 d_k = d/H），拼接后线性变换——不同头看不同子空间</text>
<rect x="500" y="316" width="340" height="40" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-note" fill="ink" x="670" y="334" text-anchor="middle" font-size="12.5px">复杂度 O(T²·d)：T 加倍，算力约 ×4（见 2.4.6）</text>
</svg>
<figcaption>缩放点积注意力的数据流（本教程绘，形状以 B×T 序列为例）。三路输入各司其职：Q 提问、K 应答、V 交货；÷√d_k 防止点积方差 ∝ d_k 把 softmax 推入饱和区（推导见 [2.4.4](#sec-2.4.4)，手算见 [例 2.4.1](#ex-2.4.1)）；多头即并排若干份、各看一个子空间，最后拼接并线性变换。平方复杂度 O(T²d) 是长序列的核心瓶颈（[2.6](sec26.md) 专门处理它）。</figcaption>
</figure>
:::

## 2.4.4 为什么除以 √d_k {#sec-2.4.4}

::: thm 定理 2.4.1 · 点积的方差与 softmax 饱和 {#thm-2.4.1}
设 $\boldsymbol q,\boldsymbol k\in\mathbb R^{d_k}$ 的各分量**相互独立、均值为 $0$、方差为 $1$**（$\mathbb E[q_i]=0,\ \operatorname{Var}(q_i)=1$，对 $k_i$ 同理，且两者独立）。则

$$\mathbb E\bigl[\boldsymbol q^{\mathrm T}\boldsymbol k\bigr]=0,\qquad
\operatorname{Var}\bigl(\boldsymbol q^{\mathrm T}\boldsymbol k\bigr)=d_k,\qquad
\text{标准差}=\sqrt{d_k}.$$

**因此**：不缩放时，分数的量级随 $\sqrt{d_k}$ 增长；当 $d_k$ 较大时，同一条查询在各键上的分数差异被放大，softmax 的输入落入**饱和区**——最大项趋近 $1$、其余趋近 $0$，反向梯度趋近于零，训练停滞。除以 $\sqrt{d_k}$ 把方差拉回 $1$，使 softmax 工作在梯度良好的区间。
:::

::: proof 推导 · 从独立同分布假设到 softmax 饱和
**(1) 均值。** 由独立性，$\mathbb E[q_ik_i]=\mathbb E[q_i]\mathbb E[k_i]=0$，故

$$\mathbb E\bigl[\boldsymbol q^{\mathrm T}\boldsymbol k\bigr]=\sum_{i=1}^{d_k}\mathbb E[q_ik_i]=0 .$$

**(2) 方差。** 由独立性，$\operatorname{Var}(q_ik_i)=\mathbb E[q_i^2]\mathbb E[k_i^2]-\bigl(\mathbb E[q_ik_i]\bigr)^2=1\cdot1-0=1$；各分量乘积相互独立故方差可加：

$$\operatorname{Var}\bigl(\boldsymbol q^{\mathrm T}\boldsymbol k\bigr)=\sum_{i=1}^{d_k}\operatorname{Var}(q_ik_i)=d_k .$$

**(3) 缩放后的方差。** 令 $\tilde s=\boldsymbol q^{\mathrm T}\boldsymbol k/\sqrt{d_k}$，则 $\operatorname{Var}(\tilde s)=d_k/d_k=1$——与 $d_k$ 无关。这就是 $\sqrt{d_k}$ 的全部理由：**它让分数的尺度与维度解耦**。

**(4) 饱和的后果（一维示例足够说明）。** 设某行有两个分数 $s_1=0$、$s_2=c$（$c\gt0$）。softmax 给出 $p_1=\frac{1}{1+e^{c}}$、$p_2=\frac{e^{c}}{1+e^{c}}$。对 $c$ 求导：

$$\frac{\partial p_2}{\partial c}=p_2(1-p_2).$$

当 $c$ 很小（未饱和）时导数约 $0.25$；当 $c=10$ 时 $p_2\approx0.99995$，导数约 $5\times10^{-5}$——**梯度小了四个数量级**。而「分数差异」的量级正好随 $\sqrt{d_k}$ 增长：$d_k=1024$ 时标准差是 $32$，两个「随机」键之间的分数差常常就有十几到几十，softmax 早已饱和。

**(5) 一个容易被漏掉的补充项。** 上面讨论的是「固定的两个键」之间的差异。在一行有 $T_k$ 个分数时，最大值本身也会随 $T_k$ 缓慢增长（对独立标准正态分数，$\max_i s_i$ 的期望约 $\sqrt{2\ln T_k}$）。因此缩放后的 logit 尺度仍随 $\log T_k$ 缓慢增长——这也是长序列训练中偶尔需要**温度**或 **logit 归一化**一类技巧的经验来源（属工程惯例，具体做法依实现而异）。但主导项依然是 $\sqrt{d_k}$。$\blacksquare$
:::

::: intuition 一句话：缩放不是为了「数值稳定」，而是为了「梯度可用」
注意区分两件常被混淆的事：**除以 $\sqrt{d_k}$ 不是防止数值溢出**（溢出是 [2.2](sec22.md) 里梯度爆炸那类问题），而是**控制 softmax 的工作点**。softmax 在「输入差异很大」时会输出接近 one-hot 的分布，此时它对输入的导数趋近 0 —— 与第 1 讲里 Sigmoid 饱和是同一个机制：**输出饱和 ⇒ 反向梯度被掐断**。把分数方差拉回 $1$ 相当于把 softmax 拉回它的线性区，让「哪个键更重要」这件事以连续、可微的方式表达出来，而不是变成一次硬选择。
:::

## 2.4.5 自注意力、因果掩码与置换等变性 {#sec-2.4.5}

自注意力让每个位置同时扮演「提问者」与「被检索者」。这在编码器里完全没问题，但在**自回归生成**里立刻出事：位置 $t$ 只应该看到 $\le t$ 的内容，而 $\boldsymbol Q\boldsymbol K^{\mathrm T}$ 天然让 $t$ 看到全部位置（包括未来）。解决办法是**掩码**。

::: def 定义 2.4.5 · 因果掩码（causal mask） {#def-2.4.5}
在 softmax **之前**给分数矩阵加上掩码矩阵 $\boldsymbol M$：

$$\boldsymbol S\leftarrow \boldsymbol S+\boldsymbol M,\qquad
M_{ij}=\begin{cases}0,& j\le i,\\[2pt]-\infty,& j\gt i,\end{cases}
\qquad
\boldsymbol P=\operatorname{softmax}\!\left(\frac{\boldsymbol S}{\sqrt{d_k}}+\boldsymbol M\right).$$

因为 $\exp(-\infty)=0$，上三角（未来位置）的权重被精确置零，且每行的归一化只在本行可见的位置上进行。$\boldsymbol M$ 与数据无关，只需按最大长度预计算一次即可复用。
:::

::: intuition 掩码的三个实现细节（都是 bug 高发区）
① **必须在 softmax 之前加**：加在之后只是把权重改小，行和不再为 1，输出尺度被破坏；② **要用 $-\infty$ 或该 dtype 的最小值**：用 $0$ 会变成「把未来位置当成相似度为 0 的普通键」——权重非零，等于偷看；用固定的 `-1e9` 在 float16 下可能与真实分数相加后仍不够负（且 `-1e9` 在 float16 里直接溢出为 `-inf`，行为依实现而异），稳妥写法是 `torch.finfo(dtype).min` 或先转 float32 再掩码；③ **整行全被掩码时要小心**：如果某个查询位置没有任何可见键（出现在 padding 相关的掩码组合里），softmax 会得到全 `NaN`，工程上通常补一个「至少允许看自己」的保证，或用 mask 后重归一化。
:::

::: thm 定理 2.4.2 · 注意力的置换等变性 {#thm-2.4.2}
设 $\boldsymbol P_\pi$ 是置换矩阵（左乘它等于按 $\pi$ 重排行）。对不带掩码的注意力有

$$\operatorname{Attention}(\boldsymbol P_\pi\boldsymbol X,\boldsymbol P_\pi\boldsymbol X,\boldsymbol P_\pi\boldsymbol X)=\boldsymbol P_\pi\operatorname{Attention}(\boldsymbol X,\boldsymbol X,\boldsymbol X).$$

即：**把输入的行（位置）任意重排，输出只是被同样重排，每个位置实际得到的上下文一模一样。** 因此纯注意力（不加位置编码、不加掩码）**无法区分不同的词序**。
:::

::: proof 证明
设 $\boldsymbol Q=\boldsymbol XW^Q$、$\boldsymbol K=\boldsymbol XW^K$、$\boldsymbol V=\boldsymbol XW^V$。把输入换成 $\boldsymbol P_\pi\boldsymbol X$ 后，三路投影同时左乘 $\boldsymbol P_\pi$（因为 $(\boldsymbol P_\pi\boldsymbol X)W=\boldsymbol P_\pi(\boldsymbol XW)$）。于是

$$\bigl(\boldsymbol P_\pi\boldsymbol Q\bigr)\bigl(\boldsymbol P_\pi\boldsymbol K\bigr)^{\mathrm T}
=\boldsymbol P_\pi\boldsymbol Q\boldsymbol K^{\mathrm T}\boldsymbol P_\pi^{\mathrm T},$$

其中用到了 $\boldsymbol P_\pi^{\mathrm T}=\boldsymbol P_\pi^{-1}$。softmax 是**逐行**运算，而「逐行 softmax」与「行的置换」可交换（只重排了行的顺序，每行内部的计算没有变化），故

$$\operatorname{softmax}\!\Bigl(\frac{\boldsymbol P_\pi\boldsymbol S\boldsymbol P_\pi^{\mathrm T}}{\sqrt{d_k}}\Bigr)
=\boldsymbol P_\pi\,\operatorname{softmax}\!\Bigl(\frac{\boldsymbol S}{\sqrt{d_k}}\Bigr)\boldsymbol P_\pi^{\mathrm T}.$$

右乘值矩阵时再乘上 $\boldsymbol P_\pi\boldsymbol V$：

$$\boldsymbol P_\pi\,\boldsymbol P_{\text{attn}}\,\underbrace{\boldsymbol P_\pi^{\mathrm T}\boldsymbol P_\pi}_{=\boldsymbol I}\boldsymbol V
=\boldsymbol P_\pi\bigl(\boldsymbol P_{\text{attn}}\boldsymbol V\bigr)=\boldsymbol P_\pi\,\boldsymbol O .$$

即输出被同样的置换重排，每个查询拿到的加权组合与原来完全相同。**结论**：「狗咬人」与「人咬狗」在纯注意力看来是同一份数据的两种排列，模型没有依据区分它们——所以位置信息必须显式注入（[2.6](sec26.md)）。$\blacksquare$
:::

::: intuition 等变性是把双刃剑，而掩码是「有意破坏它」
置换等变有两个后果。**好的一面**：注意力对位置不敏感，因此对「同一个模式出现在任何位置」都能用同一套参数处理（这正是 [2.1](sec21.md) 要求的参数共享）；**坏的一面**：词序信息完全丢失。所以现代做法是**主动破坏**这种等变性——加位置编码（[2.6](sec26.md)）、加因果掩码（本节）、或引入相对位置偏置。反过来说，凡是你发现有模型偷偷丢掉了位置信息（例如手写注意力时误把 $\sqrt{d_k}$ 或位置编码漏掉），它的表现就会像「高级词袋模型」：局部词汇统计还行，语序相关的任务全崩。
:::

## 2.4.6 复杂度：O(T²d) 从哪来 {#sec-2.4.6}

::: thm 定理 2.4.3 · 注意力的时间与空间复杂度 {#thm-2.4.3}
对 $\boldsymbol Q\in\mathbb R^{T_q\times d_k}$、$\boldsymbol K,\boldsymbol V\in\mathbb R^{T_k\times d_k/d_v}$：

| 步骤 | 形状 | 时间（乘加次数） | 需要保存的中间量 |
|:--|:--|:--|:--|
| $\boldsymbol S=\boldsymbol Q\boldsymbol K^{\mathrm T}$ | $T_q\times T_k$ | $T_qT_kd_k$ | $T_qT_k$（分数） |
| 缩放 + softmax | $T_q\times T_k$ | $\mathcal O(T_qT_k)$ | $T_qT_k$（权重，可被覆盖） |
| $\boldsymbol O=\boldsymbol P\boldsymbol V$ | $T_q\times d_v$ | $T_qT_kd_v$ | — |

取 $T_q=T_k=T$、$d_k=d_v=d$，得**时间 $O(T^2d)$、显存 $O(T^2)$**（若把权重矩阵物化）。序列长度翻倍 ⇒ 算力约翻四倍，这是 Transformer 长序列的头号瓶颈。
:::

::: proof 推导 · 逐项计数（含「为什么显存也是平方的」）
**(1) 分数矩阵。** $\boldsymbol Q$ 的一行与 $\boldsymbol K$ 的一行做内积需要 $d_k$ 次乘加，共 $T_q\times T_k$ 对，故 $T_qT_kd_k$ 次乘加。

**(2) softmax。** 对每一行的 $T_k$ 个数做 max、exp、求和、除法，每行 $O(T_k)$，共 $O(T_qT_k)$——比矩阵乘便宜一个 $d$ 因子，但**常数不小**（exp 是超越函数）。

**(3) 加权求和。** $\boldsymbol P$（$T_q\times T_k$）乘 $\boldsymbol V$（$T_k\times d_v$）需要 $T_qT_kd_v$ 次乘加。

**(4) 显存。** 反向传播需要 $\boldsymbol P$（或它的等价物）来算对 $\boldsymbol Q,\boldsymbol K$ 的梯度：

$$\frac{\partial\mathcal L}{\partial \boldsymbol Q}=\Bigl(\frac{\partial\mathcal L}{\partial \boldsymbol S}\Bigr)\boldsymbol K,\qquad
\frac{\partial\mathcal L}{\partial \boldsymbol K}=\Bigl(\frac{\partial\mathcal L}{\partial \boldsymbol S}\Bigr)^{\mathrm T}\boldsymbol Q,$$

而 $\partial\mathcal L/\partial\boldsymbol S$ 由 $\boldsymbol P$ 与上游梯度共同决定（softmax 的雅可比作用在 $\boldsymbol P$ 上）。因此标准的「前向存中间量、反向直接用」实现必须保存一张 $T\times T$ 的矩阵：$T=8192$、float16 时约 $8192^2\times2\approx1.3\times10^{8}$ 字节（约 $0.13$ GB，**单个头**的一份；多头与批维还要乘 $B\times H$）。[2.6](sec26.md) 的 FlashAttention 正是来消掉这份显存的：它不物化 $\boldsymbol P$，而是分块重算。

**(5) 与 RNN 的对照。** RNN 的每步计算 $O(d_h^2)$、总时间 $O(Td_h^2)$——**对 $T$ 是线性的**，但串行、且路径长度 $O(T)$。注意力换来了 $O(1)$ 的路径与完全并行，付出的代价就是 $T^2$。$\blacksquare$
:::

::: intuition 把「平方项」与「线性项」分开记
两个符号各管一件事：**分数矩阵的规模只由 $T$ 决定**（$B\times H\times T\times T$，与 $d$ 无关），而每个元素的**计算量**由 $d$ 决定。于是：显存瓶颈按 $T^2$ 恶化，算力瓶颈按 $T^2d$ 恶化。这条不对称立即给出两条不同的对策——**长上下文优先省显存**（不物化权重矩阵、分块重算、KV 压缩），**宽模型优先省算力**（低精度、结构化稀疏）。[2.6](sec26.md) 的「三笔账」正是把这两条细化成可计算的数字。
:::

::: ex 例 2.4.1 · 手算一次 3×3 注意力 {#ex-2.4.1}
取 $d_k=d_v=2$，$T_q=T_k=3$：

$$\boldsymbol Q=\begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix},\qquad
\boldsymbol K=\begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix},\qquad
\boldsymbol V=\begin{pmatrix}1&2\\3&4\\5&6\end{pmatrix}$$

（故意取 $\boldsymbol V\neq\boldsymbol K$，以便看清「聚合的是 $V$」）。求分数矩阵、缩放后的权重、以及输出；并说明「不除以 $\sqrt{d_k}$ 会怎样」。

::: proof 解
**(1) 分数矩阵** $\boldsymbol S=\boldsymbol Q\boldsymbol K^{\mathrm T}$（每个查询分别与三行键做内积）：

$$\boldsymbol S=\begin{pmatrix}1&0&1\\0&1&1\\1&1&2\end{pmatrix}.$$

**(2) 缩放** $\boldsymbol S/\sqrt{2}$（$\sqrt2\approx1.4142$）：

$$\frac{\boldsymbol S}{\sqrt2}=\begin{pmatrix}0.7071&0&0.7071\\0&0.7071&0.7071\\0.7071&0.7071&1.4142\end{pmatrix}.$$

**(3) 逐行 softmax**（每行归一化，保留三位小数）：

$$\boldsymbol P\approx\begin{pmatrix}0.401&0.198&0.401\\0.198&0.401&0.401\\0.248&0.248&0.503\end{pmatrix}.$$

以第一行为例：$e^{0.7071}=2.028$、$e^{0}=1$，和为 $5.056$，故 $2.028/5.056=0.401$、$1/5.056=0.198$。

**(4) 输出** $\boldsymbol O=\boldsymbol P\boldsymbol V$：

$$\boldsymbol O\approx\begin{pmatrix}3.000&4.000\\3.407&4.407\\3.510&4.511\end{pmatrix}.$$

第一行**恰好**等于 $(3,4)$（即 $\boldsymbol V$ 的第二行），这不是巧合：$\boldsymbol q_1=(1,0)$ 与 $\boldsymbol k_2$ 正交，而与 $\boldsymbol k_1,\boldsymbol k_3$ 的分数相同 ⇒ 权重形如 $(a,\ b,\ a)$ 且 $2a+b=1$；代入 $a(1,2)+b(3,4)+a(5,6)=(6a+3b,\ 8a+4b)=(3,\ 4)$——**无论 $a$ 取多少，输出都固定在中间那一行**。这正是「对称性 ⇒ 输出与温度无关」的一个小例子，也提示：当键高度相关时，注意力权重怎么变都不改变输出。

**(5) 不缩放的后果。** 若直接对 $\boldsymbol S$ 做 softmax，第一行变成 $(0.422,\ 0.155,\ 0.422)$，第三行变成 $(0.212,\ 0.212,\ 0.576)$——比缩放后的分布**更尖锐**。本例 $d_k=2$ 差异还不大；当 $d_k=512$（分数标准差约 22.6）时，softmax 会被推到接近 one-hot，梯度随之消失（[定理 2.4.1](#thm-2.4.1)）。
:::
:::

::: method 形状、复杂度与 KV 头的选择 {#method-2.4.1}
以 $B$ 批、$T$ 序列长、$d$ 模型维、$H$ 头（每头 $d_h=d/H$）为例：

| 量 | 形状 | 说明 |
|:--|:--|:--|
| 输入 $\boldsymbol X$ | $B\times T\times d$ | 自注意力的输入与输出形状相同 |
| 单头 $\boldsymbol Q,\boldsymbol K,\boldsymbol V$ | $B\times H\times T\times d_h$ | 实际实现把 $(B,T,d)$ 投影后 reshape 成 $(B,H,T,d_h)$ |
| 分数 / 权重 | $B\times H\times T\times T$ | **平方项在这里**；$B{\cdot}H{\cdot}T^2$ |
| 多头输出 | $B\times T\times d$ | 拼接 $H$ 个头（$H\cdot d_h=d$）后过 $W^O$ |
| FLOPs | $\approx 4BHT^2d_h=4BT^2d$ | 计数见 [定理 2.4.3](#thm-2.4.3) |

**GQA / MQA**：多头注意力的 $\boldsymbol K,\boldsymbol V$ 也是每头一份，于是推理时的 KV cache 随 $H$ 增长。**多查询注意力**（MQA）让所有查询头**共享同一组** $\boldsymbol K,\boldsymbol V$（$n_{kv}=1$）；**分组查询注意力**（GQA）折中为每 $g$ 个查询头共享一组（$n_{kv}=H/g$）。KV cache 与访存带宽按 $g$ 倍下降，而质量损失通常很小——这是 2023 年以来开源大模型的常见默认（细节与代价见 [2.5.6](sec25.md) 与 [2.6.8](sec26.md)）。
:::

## 2.4.7 注意力权重能当解释吗 {#sec-2.4.7}

::: think 「权重高 = 该位置重要」为什么站不住脚
注意力权重可视化很好看，但把它当作**因果解释**需要非常小心。四条理由：

1. **权重不是输出**：输出是 $\boldsymbol P\boldsymbol V$ 的结果。某位置权重为 $0.8$，但它的 $\boldsymbol V$ 行可能几乎为零（甚至被后续线性层投影到「无用子空间」），那它对输出的贡献仍然很小——**权重与贡献之间隔着 $\boldsymbol V$**。
2. **残差与后续层会稀释**：Transformer 块里有残差连接，多个头与多层的结果会相加、再经 FFN 混合。某一层某个头的注意力模式被下游完全改写是很常见的（[2.5](sec25.md)）。
3. **softmax 的归一化耦合**：权重之和恒为 1，所以任何一个位置权重的上升必然压低其他位置。把它读成「该位置贡献上升」在语义上就已经越界——它可能只是别的候选被削弱了。
4. **层与头之间存在冗余**：多头设计本就鼓励不同子空间并行，很多头可以被剪掉而性能几乎不变（这类现象在开源实现里被反复报告）。**「能剪掉的头」不足以承载唯一的解释**。

**要检验一个注意力解释，至少需要**：① 做**消融**（把该位置的键值屏蔽，看输出是否真的变化）；② 看**跨层跨头的稳定性**（换初始化重训后模式是否重现）；③ 与**梯度归因**（对输入的梯度、输入 × 梯度）对照；④ 在有明确**因果结构**的合成任务上验证（例如「必须复制第 3 个 token」这类可判定的任务）。四条都没做就下结论，属于过度解读。本书的态度是：**注意力权重是有用的调试信号，不是解释证据。**
:::

## 2.4.8 代码：手写缩放点积注意力与掩码 {#sec-2.4.8}

```python
import torch, torch.nn.functional as F

def attention_manual(Q, K, V, key_padding_mask=None, causal=False):
    """Q:(B,Tq,d_k)  K:(B,Tk,d_k)  V:(B,Tk,d_v)
       key_padding_mask:(B,Tk) bool，True 表示该键是 pad（应被屏蔽）"""
    d_k = Q.size(-1)
    S = Q @ K.transpose(-2, -1) / d_k ** 0.5        # (B,Tq,Tk)：分数
    if causal:                                       # 因果掩码：位置 i 只能看 j <= i
        Tq, Tk = S.shape[-2], S.shape[-1]
        keep = torch.ones(Tq, Tk, dtype=torch.bool, device=S.device).tril()
        S = S.masked_fill(~keep, float("-inf"))      # 必须在 softmax 之前
    if key_padding_mask is not None:
        S = S.masked_fill(key_padding_mask[:, None, :], float("-inf"))
    P = S.softmax(dim=-1)                            # 沿键维（最后一维）归一化
    P = torch.nan_to_num(P)                          # 整行全 -inf 时 softmax 会产生 NaN
    return P @ V, P

# ① 与 PyTorch 官方实现数值对齐（PyTorch ≥ 2.0）
torch.manual_seed(0)
B, Tq, Tk, d_k, d_v = 2, 5, 5, 16, 16
Q, K, V = (torch.randn(B, Tq, d_k), torch.randn(B, Tk, d_k), torch.randn(B, Tk, d_v))
out_mine, P = attention_manual(Q, K, V, causal=True)
out_ref = F.scaled_dot_product_attention(Q, K, V, is_causal=True)
assert torch.allclose(out_mine, out_ref, atol=1e-5), "实现与官方不一致"
assert torch.allclose(P.triu(1), torch.zeros_like(P.triu(1))), "上三角未被掩掉"

# ② 验证定理 2.4.1：分数标准差随 sqrt(d_k) 增长，缩放后回到 1
for d in (16, 64, 256, 1024):
    q, k = torch.randn(4096, d), torch.randn(4096, d)
    raw = (q * k).sum(-1)                            # 未缩放的点积
    print(f"d_k={d:5d}  std(点积)={raw.std():8.2f}  std/√d_k={raw.std()/d**0.5:6.3f}")
    # 期望：第二列在 ~1 附近（与 d_k 无关），第一列随 √d_k 增长

# ③ 观察饱和：把分数放大 10 倍，softmax 的熵骤降
for scale in (1.0, 3.0, 10.0):
    P_big = (Q[0] @ K[0].T * scale).softmax(dim=-1)
    ent = -(P_big * (P_big + 1e-12).log()).sum(-1).mean()   # 行平均熵
    print(f"分数放大 ×{scale:4.1f}  平均熵={ent:.4f}（最大可能熵={torch.tensor(Tk).float().log():.4f}）")
```

三个断言各自对应本节的一条结论：**① 形状与掩码**（对齐官方实现、确认上三角被精确置零）；**② 缩放的必要性**（第二列稳定在 $1$ 附近，证明 $\sqrt{d_k}$ 把方差与维度解耦）；**③ 饱和的后果**（分数放大后熵下降，分布趋向 one-hot，对应梯度被掐断）。

::: errata 本节五个常见误解
1. **「注意力权重可以直接当解释用」**：见 [2.4.7](#sec-2.4.7) 的四条理由。权重不是贡献，权重上升还伴随其他位置的下降。
2. **「softmax 沿查询维做」**：错。必须**沿键维**（每一行内部）归一化——含义是「这个查询把 100% 的注意力按比例分配给各键」。按查询维归一化会得到「每个键把所有查询的注意力分完」，语义完全不同（在 $T_q\neq T_k$ 时形状也不对）。
3. **「掩码加 0 就行」**：加 0 等于不掩码；加一个「很小的负数」在低精度下会被真实分数淹没。用 $-\infty$（或该 dtype 的 `finfo.min`），并且**必须在 softmax 之前**加。还要处理「整行都被掩码」的情况，否则得到 `NaN`。
4. **「聚合的是 K，因为分数是 QKᵀ 算出来的」**：分数只决定**权重**，真正被加权求和的是 $\boldsymbol V$。把 $\boldsymbol V$ 换成随机数，输出立刻变随机——可以自己动手做这个实验（见 [2.4.8](#sec-2.4.8) 的代码）。
5. **「注意力必须发生在两个不同序列之间」**：自注意力的 $Q,K,V$ 都来自同一个序列；交叉注意力（encoder–decoder attention）才是两个序列。混淆这两者会导致对位置编码与掩码需求的误判：**自注意力需要位置编码，交叉注意力通常不需要**（目标侧位置由解码器自身的位置编码负责）。
:::

::: method 即时自测 · 2.4 {#method-2.4.2}
**Q1** 写出缩放点积注意力的完整公式，并说明 softmax 沿哪一维、输出形状是什么；$\boldsymbol K$ 与 $\boldsymbol V$ 各扮演什么角色。

**Q2** 不除以 $\sqrt{d_k}$ 会发生什么？用「方差 = $d_k$」这条结论把它讲清，并说明它与第 1 讲的 Sigmoid 饱和有何共同点。

**Q3** $T$ 从 4096 加倍到 8192，注意力部分的时间与显存各约变为原来的几倍（定量给出）？若同时把 $d$ 加倍呢？

**Q4** 同事说「我看到某个注意力头专门盯着句首，所以模型在做句法分析」。请给出两条你会要求补充的实验证据。

::: sol 参考要点
**Q1** $\operatorname{Attention}(\boldsymbol Q,\boldsymbol K,\boldsymbol V)=\operatorname{softmax}(\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_k})\boldsymbol V$；softmax 沿**键维**（每行）归一化；输出形状 $T_q\times d_v$。$\boldsymbol K$ 是「被检索的标签」，只参与打分；$\boldsymbol V$ 是「被取走的内容」，加权求和作用在它上面。键指路、值交货。

**Q2** 独立零均值单位方差下点积方差为 $d_k$、标准差为 $\sqrt{d_k}$，所以 $d_k$ 越大分数越分散，softmax 越容易饱和：最大权重趋 1、其余趋 0，$\partial p_i/\partial s$ 趋 0，训练停滞。与 Sigmoid 饱和的共同点是**输出饱和 ⇒ 反向梯度被掐断**，区别是 softmax 的饱和由「输入差异的尺度」控制，而 Sigmoid 的饱和由「单个输入的绝对值」控制。

**Q3** 时间 $O(T^2d)$、显存（分数/权重矩阵）$O(T^2)$：$T$ 从 4096→8192 时**约 4 倍**（时间）与**约 4 倍**（显存）；若 $d$ 也同时加倍，时间再乘 2 ⇒ 约 **8 倍**，显存仍是 4 倍（显存只由 $B,H,T^2$ 决定，与 $d$ 无关）。这个不对称正是长上下文工程要优先处理显存的原因。

**Q4** 至少两条：① **消融**——屏蔽该头（或把该头的输出置零）后，句法相关任务的指标是否显著下降？若几乎不变，说明它可被替代；② **跨初始化稳定性**——换随机种子重训若干次，同样「盯句首」的模式是否重现？此外还可以要求：③ 与梯度归因对照；④ 在一个可判定因果的合成任务上验证该头是否真的在承担所声称的功能。
:::
:::

::: note[skip] 延伸阅读
- Sutskever, Vinyals & Le, *Sequence to Sequence Learning with Neural Networks*（2014, arXiv:1409.3215）——「编码器—解码器 + 定长上下文向量」这一范式的起点，本节的瓶颈就是它的代价。
- Bahdanau, Cho & Bengio, *Neural Machine Translation by Jointly Learning to Align and Translate*（2014, arXiv:1409.0473）——加性注意力的原始论文，第一次用「对齐」解释注意力权重（并明确讨论了长句的改进）。
- Luong, Pham & Manning, *Effective Approaches to Attention-based Neural Machine Translation*（2015, arXiv:1508.04025）——dot / general / concat 三种乘性打分形式的来源与实验对比。
- Vaswani et al., *Attention Is All You Need*（2017, arXiv:1706.03762）——缩放点积注意力、多头注意力与 $\sqrt{d_k}$ 缩放的出处（[2.5](sec25.md) 会逐部件展开）。
- Shazeer, *Fast Transformer Decoding: One Write-Head is All You Need*（2019, arXiv:1911.02150）——MQA 的原始动机（推理时 KV cache 的访存瓶颈）。
- Ainslie et al., *GQA: Training Generalized Multi-Query Transformer Models from Multi-Head Checkpoints*（2023, arXiv:2305.13245）——GQA 的做法与「质量几乎不降」的实验口径。
:::

**本节小结**：注意力把「把所有历史压进一个向量」换成「**按需对所有位置加权聚合**」：$\operatorname{softmax}(\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_k})\boldsymbol V$，其中 softmax 沿键维归一、输出的每个位置是 $\boldsymbol V$ 的凸组合。$\sqrt{d_k}$ 的作用是控制 softmax 的工作点（不缩放会因点积方差 $=d_k$ 而饱和、梯度消失，与 Sigmoid 饱和同源）。自注意力带来 $O(1)$ 的路径长度与可并行训练，代价是 $O(T^2d)$ 的时间与 $O(T^2)$ 的显存；它还**置换等变**，因此位置信息必须显式注入。因果掩码把注意力改造成可用于自回归的形式。下一节把这些部件（多头、FFN、残差、Pre-LN）拼成 Transformer 的主干，并算清它的形状、参数量与 KV cache 显存。
