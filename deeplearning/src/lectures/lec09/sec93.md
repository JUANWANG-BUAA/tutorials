# 9.3 张量并行：把一层切开

[9.2](sec92.md) 的分片与数据并行都有一个共同前提：**每一层本身能放进一张卡**。它们切的是「谁算哪些数据」或「谁存哪些状态」，从不切开一个矩阵。

但真实模型里存在三种「单层就放不下」的情形：极端宽的 FFN、超大的词表 embedding、以及长序列下实体化的注意力矩阵（[9.1.5](sec91.md) 的情形 C）。这时唯一的办法是**把矩阵本身切成几块，分给不同的卡，再把结果拼回来**——这就是**张量并行（tensor parallelism, TP）**。

代价是新的通信模式：在数据并行里，通信只发生在「一步的末尾」；而张量并行里，**每层中间就要通信**。这决定了它对链路的要求完全不同。本节回答：

1. 一个线性层怎么切？两种切法的通信差在哪？
2. 为什么「列切 + 行切」必须成对出现，才能把通信压到最少？
3. 注意力的多头结构天然适合张量并行，具体怎么切？
4. 序列并行是什么、它解决谁的账？

## 9.3.1 列并行与行并行 {#sec-9.3.1}

::: def 定义 9.3.1 · 线性层的列并行与行并行 {#def-9.3.1}
考虑一个线性层 $\boldsymbol Y=\boldsymbol XA$，其中 $\boldsymbol X\in\mathbb R^{B\times d_{\text{in}}}$、$A\in\mathbb R^{d_{\text{in}}\times d_{\text{out}}}$。把 $A$ 切给 $k$ 张卡：

**列并行（column parallel）**：按**输出维**切
$$A=[A_1\,|\,A_2\,|\,\cdots\,|\,A_k],\qquad A_i\in\mathbb R^{d_{\text{in}}\times (d_{\text{out}}/k)} .$$
每张卡用**完整的输入** $\boldsymbol X$ 算出输出的一个列分片 $\boldsymbol Y_i=\boldsymbol XA_i\in\mathbb R^{B\times(d_{\text{out}}/k)}$。
**前向不需要任何通信**：结果的拼接 $\boldsymbol Y=[\boldsymbol Y_1|\cdots|\boldsymbol Y_k]$ 是「逻辑上完整」，物理上各卡各持一段即可。

**行并行（row parallel）**：按**输入维**切
$$A=\begin{bmatrix}A_1\\ \vdots\\ A_k\end{bmatrix},\qquad A_i\in\mathbb R^{(d_{\text{in}}/k)\times d_{\text{out}}},\qquad \boldsymbol X=[\boldsymbol X_1|\cdots|\boldsymbol X_k] .$$
每张卡算一个**部分积** $\boldsymbol X_iA_i$，再把各部分求和：
$$\boldsymbol Y=\sum_{i=1}^{k}\boldsymbol X_iA_i \quad\Longrightarrow\quad \text{需要一次 All-Reduce（或 reduce-scatter）} .$$
:::

::: intuition 两种切法为什么通信模式相反
一句话：**列切把分片留在输出上（谁都不用拼），行切把分片留在输入上（必须求和才能拼）**。

换个角度看更直观——矩阵乘法 $\boldsymbol Y=\boldsymbol XA$ 里，$A$ 的**每一列**只影响输出的对应列，所以列切天然「各管一摊、互不干扰」；而 $A$ 的**每一行**都参与**所有**输出列的计算，所以行切必然产生「每个输出元素都被多张卡各算了一部分」的局面，必须归约。

工程含义：
- 列切的输出是「沿特征维分片」的，**逐元素激活（GELU / ReLU）可以直接在分片上做**（每个元素独立）；
- 行切的输出是「部分和」，必须先归约才能过任何跨元素的算子（如 softmax、LayerNorm）。
:::

## 9.3.2 列切与行切为什么必须成对出现 {#sec-9.3.2}

::: thm 结论 9.3.1 · MLP 块中的通信点 {#thm-9.3.1}
标准 Transformer 的 FFN 块为
$$\boldsymbol Y=\phi\bigl(\boldsymbol XW_1\bigr)W_2,\qquad W_1\in\mathbb R^{h\times 4h},\ W_2\in\mathbb R^{4h\times h},$$
其中 $\phi$ 是**逐元素**激活（GELU / SiLU）。若 $W_1$ **列并行**、$W_2$ **行并行**，则：

- 前向过程中间张量始终是**沿 $4h$ 维分片**的，$\phi$ **无需通信**；
- 整个块在**前向只需一次 All-Reduce**（在 $W_2$ 的输出处）；
- 反向对称地再需一次 All-Reduce（把 $W_1$ 输入的梯度归约回完整）。

即：**每块前后向各 $1+1=2$ 次 All-Reduce**，与并行度 $k$ **无关**。
:::

::: proof 推导（含形状）
设并行度为 $k$，记 $h'=4h/k$（要求 $k \mid 4h$）。

| 步骤 | 运算 | 各卡持有 | 是否需要通信 |
|:--|:--|:--|:--|
| 输入 | — | $\boldsymbol X$：$B\times h$（**完整**） | — |
| ① 列并行 $W_1$ | $\boldsymbol Z_i=\boldsymbol XW_{1,i}$ | $\boldsymbol Z_i$：$B\times h'$ | **否**（每卡用完整 $\boldsymbol X$） |
| ② 逐元素激活 | $\boldsymbol A_i=\phi(\boldsymbol Z_i)$ | $B\times h'$ | **否**（逐元素 ⇒ 不需要邻居元素） |
| ③ 行并行 $W_2$ | $\boldsymbol P_i=\boldsymbol A_iW_{2,i}$ | $B\times h$（**部分和**） | — |
| ④ 归约 | $\boldsymbol Y=\sum_i \boldsymbol P_i$ | $B\times h$（完整） | **是**：1 次 All-Reduce |

**反过来的情形为什么不行。**

- 两层都列切：第 ③ 步的每张卡只持有 $W_2$ 的一部分**输出列**，但它需要**完整的** $\boldsymbol A$ 才能算——而 $\boldsymbol A$ 恰好是分片的，于是必须先 all-gather 输入，通信次数不变甚至更多。
- 两层都行切：第 ① 步就需要把输入 $\boldsymbol X$ 切开（否则不是部分积），而 $\boldsymbol X$ 是上一层给出的完整张量，于是每块前都要先切片、每块后都要归约，通信翻倍。

**结论**：列切（免通信）→ 逐元素激活（免通信）→ 行切（一次归约）是**唯一**能把「一个块一次归约」压到极限的组合。$\blacksquare$
:::

::: intuition 把「一次归约」记住就够了
工程上只要记住这张图：

```text
       X (完整，B×h)
        │
        ├──► 卡1: X·W1_1 → φ → ·W2_1 ──┐
        ├──► 卡2: X·W1_2 → φ → ·W2_2 ──┼─► All-Reduce ─► Y (完整)
        └──► 卡k: X·W1_k → φ → ·W2_k ──┘
        └───────── 无通信 ─────────┘   └─ 唯一通信点 ─┘
```

**列切让每张卡自己算出「一部分新特征」，行切让每张卡把「一部分贡献」交出来求和。** 前者免通信，后者必须有一次汇总，两者配合正好覆盖「算特征」和「合并贡献」两件事。这也解释了为什么张量并行的实现总是成对改写层：单独切一层会立刻暴露一个未归约的部分和，下一层的形状就对不上。
:::

::: ex 例 9.3.1 · 每层通信量与实际耗时 {#ex-9.3.1}
配置：$h=4096$，FFN 隐维 $4h=16384$，张量并行度 $k=8$，$B_{\text{micro}}=4$，$T=2048$，bf16（2 字节/元素）。整个模型 $L=32$ 层，每层的注意力输出投影与 FFN 各产生一次前向 All-Reduce。

（1）求一次 All-Reduce 的消息大小 $S$；
（2）求每层前向的通信量；
（3）在 NVLink（单向量级约 300 GB/s）与 InfiniBand（约 50 GB/s）上分别估时间，并说明为什么 TP 必须留在节点内。

::: proof 解
**（1）消息大小。** 归约发生在行并行层的输出，形状为 $B\times T\times h$：
$$S=4\times2048\times4096\times2\ \text{字节}=6.7\times10^{7}\ \text{字节}\approx67\ \text{MB}.$$

**（2）每层前向通信量。** 环状 All-Reduce 每卡约
$$V=2\times\frac{k-1}{k}S=2\times\frac78\times67\ \text{MB}\approx117\ \text{MB}.$$
前向有 2 个通信点（注意力输出投影、FFN 的 $W_2$），故每层前向 $\approx234$ MB；若算上前向与反向（反向对称），**每层每步约 $700$ MB 量级**。32 层合计约 **22 GB/卡/步**。

**（3）时间。**

| 链路 | 有效带宽 | 每步通信时间（最乐观） |
|:--|:--|:--|
| NVLink（节点内） | $\approx300$ GB/s | $22/300\approx0.07$ s |
| InfiniBand（跨机） | $\approx50$ GB/s | $22/50\approx0.44$ s |

配合 [例 9.2.2](sec92.md#ex-9.2.2) 的量级看：**张量并行的通信量（22 GB/卡/步）已经接近数据并行的梯度同步量（DDP 下 24.5 GB），但它的计算量小得多**（因为并行度已经切在了每一层里），所以通信占比高得多。跨机时这 0.44 s 还要乘以「小消息效率损失」（67 MB 的消息已经不算小，但仍受链路往返与协议开销影响），实际往往更差。

**结论**：把张量并行留在节点内，是本讲最硬的一条实践约束。$\blacksquare$
:::
:::

::: errata 张量并行的通信量陷阱 {#errata-9.3.1}
**「并行度越大，单卡通信量越小」是错的。** 由 $V=2S(k-1)/k$ 可见：$S$ 是**完整输出**的大小、与 $k$ 无关，因此每卡通信量几乎不随 $k$ 变化（只从 $S$ 缓慢趋近 $2S$）。$k$ 变大带来的是**并行度更高、每次消息更小、通信次数更多**——在带宽受限时没好处（每卡仍要传约 $2S$），在**延迟受限**时还有害（更多、更小的消息）。这是「张量并行度不要超过节点 GPU 数」之外的第二条约束：**能靠更大批解决的问题，不要靠更大 TP 度解决。**
:::

## 9.3.3 注意力的切分：按头分配 {#sec-9.3.3}

::: method 多头注意力的张量并行切法 {#method-9.3.1}
设注意力有 $n_h$ 个头、每头维度 $d_{\text{head}}=h/n_h$，张量并行度 $k$ 满足 $k\mid n_h$。切法是**按头分配**，每个通信点都是「本来就有」的结构自然对齐的：

| 步骤 | 各卡计算 | 通信 |
|:--|:--|:--|
| ① $Q,K,V$ 投影 | 用**完整的**输入 $\boldsymbol X$ 乘本卡持有的列分片，得到 $n_h/k$ 个头的 $Q_i,K_i,V_i$ | **否**（列并行，且输入完整） |
| ② 缩放点积注意力 | $\text{softmax}\bigl(Q_iK_i^{\mathrm T}/\sqrt{d_{\text{head}}}\bigr)V_i$，**只在本卡的头内做** | **否**（不同头之间本来就不交互，[2.4](../lec02/sec24.md)） |
| ③ 输出投影 $W_O$ | 本卡持有 $W_O$ 的**行分片**，算出部分和 | — |
| ④ 归约 | $\boldsymbol Y=\sum_i \boldsymbol P_i$ | **是**：1 次 All-Reduce（可融合进 ③） |

**为什么这是「天然」的**：注意力的多头结构本身就是**可独立计算的并列子空间**——第 $i$ 个头只与第 $i$ 个头的 $Q,K,V$ 打交道。所以按头切分**不引入任何额外的数学近似**，也不需要在 softmax 前通信（softmax 是沿**键（key）维**做的，键在同一头内，仍在本卡上）。

**LayerNorm / Dropout 怎么办**：它们是**跨特征维**（LayerNorm 归约所有 $h$ 维）或**逐元素**的算子。注意：LayerNorm 需要完整的 $h$ 维才能算均值和方差，所以在标准张量并行的切分下，**LayerNorm 的参数与计算在每张卡上复制一份**（各卡都持有完整的 $\gamma,\beta$，输入在归约后已是完整的）——这不会造成不一致，因为每卡算出的结果相同。Dropout 是逐元素的，随机掩码必须**在所有卡上一致**：实现上给不同卡设不同的随机种子、或按位置生成掩码，**否则同一元素在不同卡上的掩码不同，梯度会不一致**（需按你的框架实现核对，这里标注为需核实项）。
:::

::: intuition 为什么按头切不需要 softmax 通信
softmax 沿**键维**归一化。在按头切分下，第 $i$ 个头完整的 $Q_i,K_i$ 都在同一张卡上，因此「对哪些键归一化」这个信息是**局部的**。若换成按**序列维**切（[9.3.4](#sec-9.3.4)），键会被切开，softmax 就需要跨卡通信（这正是 Ulysses / Ring Attention 要解决的问题）。

所以两条判据：
- **沿「头维」切** → 通信少、与数学结构对齐（本节的 TP）；
- **沿「序列维」切** → 必须处理跨卡的注意力（[9.3.4](#sec-9.3.4) 的 SP / CP）。
:::

## 9.3.4 序列并行：把 LayerNorm 与 Dropout 的激活也切开 {#sec-9.3.4}

::: def 定义 9.3.2 · 序列并行（sequence parallelism, SP） {#def-9.3.2}
标准张量并行只切**权重**，不切激活：LayerNorm、Dropout 等算子的激活在每个卡上都是**完整的** $B\times T\times h$。序列并行沿**序列维** $T$ 把这些激活切成 $k$ 份，每卡只保留 $B\times (T/k)\times h$：

- **区域划分**：在张量并行的通信点之间的「非矩阵乘区域」（LayerNorm、Dropout、残差），激活沿 $T$ 维分片；
- **进入矩阵乘前**：用一次 all-gather 把激活沿 $T$ 维拼回**完整**（因为矩阵乘是逐 token 的，各卡需要完整权重 + 各自 token 的激活；但这里为了配合 TP 的权重切分，标准做法是在 TP 的通信点处完成「切分方向」的转换）；
- **效果**：把这几类激活的显存占用从 $BTh$ 降到 $BTh/k$——注意它与 TP **共用同一次通信**（Megatron 系实现中，SP 的通信与 TP 的 all-gather 融合在一起，**不另加通信**）。
:::

::: intuition 序列并行省的是哪一本账
澄清一个常见混淆：**SP 不省权重、不省优化器状态**，它省的是「那些在 TP 下仍被完整复制的激活」。

在纯 TP 下，权重与矩阵乘的激活（$Q,K,V$ 的投影输入）都切了，但 LayerNorm 输入 / 输出、Dropout 掩码、残差流这些 **逐元素或跨特征** 的激活还是完整的。序列越长，这部分越可观：它正比于 $BT h$。沿 $T$ 切开后，只有 $1/k$。

因此 **SP 是「长序列 + 张量并行」配置的标准配件**：TP 切了权重与注意力头，SP 补上剩下那部分激活，两者共用通信。这也解释了框架里的命名——Megatron 把它称为 sequence parallelism，DeepSpeed 的等价物（Ulysses）则更进一步，把切分方式做成 head / seq 之间的 all-to-all 交换，用于支撑超长上下文。
:::

::: ex 例 9.3.2 · SP 省下多少激活 {#ex-9.3.2}
$B=1$，$T=8192$，$h=4096$，$L=32$，bf16，$k=8$。估算「LayerNorm 相关激活」在纯 TP 与 TP+SP 下的每卡占用。

::: proof 解
**纯 TP。** 每层需要保存的 LayerNorm 类激活采用「2 份」（输入与输出）的保守口径，形状均为 $B\times T\times h$：
$$M_{\text{ln}}=2\times BTh\times 2\ \text{字节}=2\times1\times8192\times4096\times2=1.34\times10^{8}\ \text{字节}\approx134\ \text{MB/层}.$$
32 层：$\approx4.3$ GB/卡。

**TP + SP。** 沿 $T$ 切 $k=8$ 份：$M_{\text{ln}}/k\approx16.8$ MB/层，32 层 $\approx0.54$ GB/卡。

**省下约 3.8 GB/卡**，且**不额外增加通信**（与 TP 的 all-gather 融合）。

**量级判断**：在 80 GB 卡上 3.8 GB 不算决定性；但在「长序列 + 小批量」场景下，激活是主要矛盾，且序列长度翻倍时这一项线性增长——$T=32768$ 时纯 TP 的这项就是 17 GB。这就是长上下文训练几乎默认开 SP 的原因。$\blacksquare$
:::
:::

::: method TP 度的选择：三个约束一起看 {#method-9.3.2}
| 约束 | 内容 | 后果 |
|:--|:--|:--|
| **拓扑** | TP 的 all-reduce 延迟敏感 → 应留在 NVLink 域内 | 常规取 $k\le$ 单机 GPU 数（如 8） |
| **整除性** | 需满足 $k\mid n_h$（头数）与 $k\mid 4h$（FFN 隐维） | 头数 32、隐维 4096 时 $k\in\{1,2,4,8,16,32\}$ |
| **批大小** | $k$ 越大，每卡算的 token／特征越少，矩阵乘效率越低 | 小批 + 大 $k$ = 大量小矩阵乘，算力利用率崩 |

**实践取法**：先按「单层放得下」的最小 $k$ 取值；若能同时满足 $k\le 8$ 与较大的 micro-batch，就不要继续加 $k$。当 TP 不够用时，优先考虑「TP × PP」（[9.4](sec94.md)）而不是继续加大 TP。
:::

```python
# ── 张量并行的一个最小可运行骨架（列并行 + 行并行 + 一次 All-Reduce）──
import torch, torch.distributed as dist
from torch import nn

class ColumnParallelLinear(nn.Module):
    """列并行：按输出维切权重；前向不需要通信。"""
    def __init__(self, d_in, d_out, tp_rank, tp_size):
        super().__init__()
        assert d_out % tp_size == 0
        self.local_out = d_out // tp_size
        # 每个 rank 只持有自己那一段输出列，形状 (d_in, d_out/tp_size)
        self.weight = nn.Parameter(torch.empty(d_in, self.local_out))
        nn.init.kaiming_uniform_(self.weight, a=5**0.5)

    def forward(self, x):                      # x: (B, T, d_in) —— 完整输入
        return x @ self.weight                 # -> (B, T, d_out/tp_size)

class RowParallelLinear(nn.Module):
    """行并行：按输入维切权重；前向需要一次 All-Reduce。"""
    def __init__(self, d_in, d_out, tp_rank, tp_size):
        super().__init__()
        assert d_in % tp_size == 0
        self.local_in = d_in // tp_size
        self.weight = nn.Parameter(torch.empty(self.local_in, d_out))  # (d_in/tp, d_out)
        nn.init.kaiming_uniform_(self.weight, a=5**0.5)

    def forward(self, x):                      # x: (B, T, d_in/tp_size) —— 分片输入
        partial = x @ self.weight              # (B, T, d_out) 部分和
        dist.all_reduce(partial)               # 唯一的通信点：求和得到完整输出
        return partial

class ParallelMLP(nn.Module):
    """列切 -> 逐元素激活（免通信）-> 行切。前向一次 All-Reduce。"""
    def __init__(self, h, ffn_h, tp_rank, tp_size):
        super().__init__()
        self.fc1 = ColumnParallelLinear(h, ffn_h, tp_rank, tp_size)   # 输出维分片
        self.fc2 = RowParallelLinear(ffn_h, h, tp_rank, tp_size)      # 输入维分片
        self.act = nn.GELU()                                          # 逐元素：无需通信

    def forward(self, x):
        return self.fc2(self.act(self.fc1(x)))   # 全程只有 fc2 里的一次 all_reduce
```

::: note[skip] 与框架实现的关系
生产实现（Megatron-Core 一类）在上述骨架上增加三件事：① 把 All-Reduce 与相邻的矩阵乘**融合**（fused 通信算子），减少一次张量读写；② 把 LayerNorm / Dropout 的激活按序列维切开（SP），并与 TP 的通信点合并；③ 为注意力提供按头切分的融合内核。**接口与字段名随版本变化，请以你所用版本的官方文档为准**（此项标注为需核实）。
:::

::: errata 张量并行的六个高频误解
1. **「TP 越大越好，反正能省显存」**。TP 省的是权重与部分激活（每卡 $1/k$），但通信**几乎不随 $k$ 下降**（[上面的陷阱框](#errata-9.3.1)）。$k$ 超过单机 GPU 数时，收益常被跨机通信吃掉。
2. **「列切和行切随便选，效果一样」**。完全不同：列切免通信但把分片留在输出；行切必须有归约但把结果拼回完整。单独使用任一种都会在相邻层暴露形状 / 通信问题。
3. **「TP 可以替代 ZeRO」**。两者切的对象不同：TP 切**权重与激活**（每层都要通信），ZeRO 切**模型状态**（不切层）。可以叠加，但不互相替代。
4. **「注意力需要先 all-gather 再做 softmax」**。按**头**切时不需要：每个头的键都在本卡。只有沿**序列**切（SP / CP）才需要为 softmax 交换统计量。
5. **「LayerNorm 在 TP 下要被切开」**。LayerNorm 需要完整的特征维才能归一化。标准做法是输入先被归约成完整张量、参数在各卡复制；**被切开的是它的激活（沿序列维，SP）而不是它的特征维**。
6. **「TP 的通信和 DP 一样，反正都在集合通信里」**。频次相差数量级：DP 每步一次，TP **每层若干次**。前者的时间可被整步计算摊薄，后者必须靠高带宽低延迟链路，或靠融合与重叠藏起来。
:::

::: method 即时自测 · 9.3
**Q1** 设 $\boldsymbol Y=\boldsymbol XA$，$A$ 按输出维切成两份。前向需要通信吗？为什么？输出在每张卡上是什么形状？

**Q2** 一个 FFN 块「列切 → GELU → 行切」，$k=8$、$B=4$、$T=2048$、$h=4096$：写出一共几次 All-Reduce、每次的消息大小与每卡通信量。

**Q3** 为什么张量并行通常限制在单机（NVLink）之内？从频次与消息大小两个角度各说一条理由。

**Q4** 序列并行省的是哪部分显存？它为什么「不额外增加通信」？

::: sol 参考要点
**Q1** 不需要。列切时每张卡需要**完整的输入** $\boldsymbol X$（它本来就完整），且 $A$ 的每一列只影响输出的对应列，所以各卡独立算出输出的一段。输出形状各为 $B\times(d_{\text{out}}/2)$；逻辑上拼起来才是完整的 $\boldsymbol Y$。

**Q2** **前向 1 次** All-Reduce（行切层的输出；反向对称再 1 次）。消息为行并行层的输出：$S=B\cdot T\cdot h\cdot2=4\times2048\times4096\times2=6.7\times10^7$ 字节 ≈ 67 MB。每卡通信量 $V=2\frac{k-1}{k}S=2\times\frac78\times67\approx117$ MB（前向）。若只问「每次消息大小」则是 67 MB。

**Q3** ① **频次**：TP 每层 2 个通信点（前向），32 层就是 64 次/步；DP 每步只有 1 次。这么高的频次使**延迟**而非带宽成为瓶颈，必须低延迟链路。② **消息大小**：TP 的消息是单层输出（数十 MB 量级）而不是整个模型（GB 量级），小消息对带宽利用率差、对往返延迟更敏感；跨机链路的固定开销会显著吃掉收益。

**Q4** SP 省的是**非矩阵乘区域**的激活：LayerNorm 输入 / 输出、Dropout 掩码、残差流等这些在纯 TP 下仍被完整复制的张量，沿序列维切开后每卡只留 $1/k$。它不额外增加通信，是因为它可以与 TP 通信点**融合**——在进入矩阵乘前本就需要把张量在卡间重排，SP 只是把「重排的方向」从特征维换成序列维，复用同一次 all-gather。
:::
:::

::: note[skip] 延伸阅读
- Shoeybi et al., *Megatron-LM: Training Multi-Billion Parameter Language Models Using Model Parallelism*（2019，arXiv:1909.08053）——列并行 / 行并行与按头切注意力的原始方案。
- Narayanan et al., *Efficient Large-Scale Language Model Training on GPU Clusters Using Megatron-LM*（2021，arXiv:2104.04473）——TP × PP × DP 的组合与激活显存口径。
- Korthikanti et al., *Reducing Activation Recomputation in Large Transformer Models*（2022，arXiv:2205.05198）——序列并行与选择性激活重计算的原始论文（本节的 SP 定义与 [9.5.3](sec95.md) 的选择性重计算同源）。
- Jacobs et al., *DeepSpeed Ulysses: System Optimizations for Enabling Training of Extreme Long Sequence Transformer Models*（2023，arXiv:2309.14509）——序列维切分 + all-to-all 换头的长上下文方案。
:::

**本节小结**：张量并行把单个权重矩阵切开，列切免通信（输出分片）、行切需一次 All-Reduce（部分和）；「列切 → 逐元素激活 → 行切」使每个块前后向各只需 $1$ 次归约，且通信量**几乎不随并行度下降**，所以 TP 度受拓扑（留在 NVLink 内）、整除性与批大小三重约束。注意力按**头**切与数学结构天然对齐；序列并行再把 LayerNorm / Dropout 的激活沿序列维切开，与 TP 通信融合、不额外开销。下一节换一种粒度：层内已经切无可切时，把**层**本身分段，这就是流水线并行。
