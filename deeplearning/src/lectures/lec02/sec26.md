# 2.6 位置编码、长序列与高效注意力

::: note 本节定位：教材外拓展
本节**超出母本 MIT 6.S191 Lecture 2 的课堂范围**：母本只给了「位置编码可以是正弦式或学习式」一句话，这里把位置注入的四类做法、长序列的三笔账、FlashAttention 的访存算术与 KV cache 压缩系统化。正文里凡涉及具体机制，都区分**论文事实**、**工程惯例**与**本书判断**三种口径；凡标「需核实」处，指实现细节随框架版本变化。读法建议：只想搞清「RoPE 为什么好、FlashAttention 为什么快」，读 [2.6.1](#sec-2.6.1)、[2.6.4](#sec-2.6.4)、[2.6.6](#sec-2.6.6)–[2.6.7](#sec-2.6.7)；要做长上下文实验，再加 [2.6.8](#sec-2.6.8)–[2.6.10](#sec-2.6.10)。
:::

[2.5](sec25.md) 结尾留下两笔没还的账。第一笔来自 [2.4.5](sec24.md#sec-2.4.5)：自注意力**置换等变**（permutation equivariant），它不知道谁在前谁在后，位置信息必须由外部显式注入；第二笔来自 [2.4.6](sec24.md#sec-2.4.6)：注意力对序列长度是**平方**的，推理时的 KV cache 又随 $T$ 线性增长——两笔账一起把长上下文变成显存与带宽的问题，而不只是算力问题。

本节按「先补位置、再摊薄账」展开：位置注入的四种主流做法（**加性嵌入**、**RoPE 旋转**、**分数加性偏差**）→ 三笔账的定量清单 → FlashAttention 的分块与在线 softmax（**不改变数学，只改变访存**）→ 稀疏滑窗、KV 压缩、序列并行 → 代码与陷阱。读的时候请把每条结论和它的**代价**绑在一起：RoPE 不省算力、FlashAttention 不减 FLOPs、滑窗省的是密集矩阵而非长程能力、KV 量化省的是字节数而非访存次数。没有一笔账是免费的。

## 2.6.1 为什么一定要显式喂位置 {#sec-2.6.1}

::: thm 定理 2.6.1 · 自注意力的置换等变性 {#thm-2.6.1}
设 $\boldsymbol P_\pi$ 为置换矩阵。对不带掩码的注意力（[定理 2.4.2](sec24.md#thm-2.4.2)）有 $\operatorname{Attention}(\boldsymbol P_\pi\boldsymbol X,\boldsymbol P_\pi\boldsymbol X,\boldsymbol P_\pi\boldsymbol X)=\boldsymbol P_\pi\operatorname{Attention}(\boldsymbol X,\boldsymbol X,\boldsymbol X)$：**输入的行（位置）被任意重排后，输出只是被同样重排，每个位置实际得到的上下文完全不变**。因此不含位置信息的自注意力**无法区分不同的词序**，它的假设空间里「狗咬人」与「人咬狗」不可分辨。
::: proof 证明与它的工程含义
数学部分已由 [定理 2.4.2](sec24.md#thm-2.4.2) 给出（关键两步：$(\boldsymbol P_\pi\boldsymbol X)W=\boldsymbol P_\pi(\boldsymbol XW)$；逐行 softmax 与行置换可交换）。把它翻成四条工程含义：

1. **位置是必需品，不是调优项**。没有位置注入，模型优化的是另一个（更容易的）目标：对语序置换不变的「词袋式」预测。损失可以降得很低——语言里有大量语序无关的统计信号——但语序相关任务会系统性崩坏。
2. **掩码不能替代位置编码**。因果掩码只提供「谁在谁左边」这一位**方向**信息，不提供距离与位置本身；只用掩码的模型能学出「只看前一个 token」，却无法表达「相隔 7 步」。
3. **它是一个诊断工具**。把输入的词序打乱、看输出是否只是被同样打乱，就能判断位置注入是否真的生效；常见 bug（位置张量切片错位、批内共用同一段位置、位置表尺寸不匹配被静默截断）都表现为「打乱后输出几乎不变」，而损失曲线看不出异常。**工程惯例**：把这条检查写进单测。
4. **它给出一条反面判据**：困惑度尚可、却在复制 / 排序 / 指代上崩盘的模型，先怀疑位置信息没真正注入，再怀疑容量不足。
:::
:::

::: intuition 「狗咬人」与「人咬狗」：等变性到底意味着什么
把一句话看成一个**多集**：纯注意力看到的正是「这些词各出现一次」，它与顺序无关；等变性进一步保证打乱输入后每个位置拿到的上下文一模一样。于是模型的输出分布在两种语序上必然是同一分布的两种排列——它没有任何依据把「咬」的施事者与受事者对上号。要区分这两句话，模型必须能问出「这个词在左边第几个位置」，而这类问题的答案**只能来自显式注入的位置信息**（嵌入加性、QK 旋转或分数偏差）。一句话：**注意力负责内容，位置必须另行交代；两者缺一，模型只能做高级词袋。**
:::

## 2.6.2 正弦位置编码与它的线性性质 {#sec-2.6.2}

::: def 定义 2.6.1 · 正弦位置编码（sinusoidal positional encoding） {#def-2.6.1}
对位置 $pos=0,\dots,T-1$ 与维度索引 $i=0,\dots,d/2-1$：$PE_{(pos,2i)}=\sin\bigl(pos/10000^{2i/d}\bigr)$、$PE_{(pos,2i+1)}=\cos\bigl(pos/10000^{2i/d}\bigr)$，并把它**加**到词嵌入上（不是拼接）：$\boldsymbol x_{pos}\leftarrow\boldsymbol e_{pos}+\boldsymbol{PE}_{pos}\in\mathbb R^{d}$。写成频率族：$\omega_i=10000^{-2i/d}$，第 $i$ 对维度就是相位点 $(\sin(pos\,\omega_i),\cos(pos\,\omega_i))$，频率从 $1$ 按几何级数衰减到约 $1/10000$。$\boldsymbol{PE}$ 与数据无关（只与 $T$、$d$ 有关，可预计算）；原始 Transformer 论文（Vaswani et al., 2017, arXiv:1706.03762）给出这个设计，并报告学习式在实验上表现接近。
:::

::: intuition 为什么是「多个频率的正弦波」，以及为什么用加法
它是**多分辨率的位置指纹**：最低频的维度在整个序列上转不到一圈，给出「粗位置」；最高频的维度每步换相位，给出「细分辨率」——很像用二进制计数表示整数，只是用连续相位代替了离散位数，于是相邻位置的编码平滑变化。至于**加法**：它让位置与词义共享同一段 $d$ 维表示预算，模型可自行划出一部分子空间编码位置；代价是「位置占用」与「词义占用」互相挤占——这正是 RoPE 要绕开的地方。
:::

::: thm 定理 2.6.2 · 相对位移的线性表示 {#thm-2.6.2}
对任意位移 $k$，存在**与 $pos$ 无关**的块对角矩阵 $\boldsymbol R_k$ 使 $\boldsymbol{PE}_{pos+k}=\boldsymbol R_k\,\boldsymbol{PE}_{pos}$ 对所有 $pos$ 成立，其中第 $i$ 个 $2\times2$ 分块（$\omega_i=10000^{-2i/d}$）为

$$\boldsymbol R_k^{(i)}=\begin{pmatrix}\cos(k\omega_i)&\sin(k\omega_i)\\[2pt]-\sin(k\omega_i)&\cos(k\omega_i)\end{pmatrix},\qquad \boldsymbol R_k=\operatorname{diag}\bigl(\boldsymbol R_k^{(1)},\dots,\boldsymbol R_k^{(d/2)}\bigr),$$

它是一个**旋转矩阵**：$\boldsymbol R_k^{\mathrm T}\boldsymbol R_k=\boldsymbol I$、$\boldsymbol R_k^{-1}=\boldsymbol R_{-k}$。
::: proof 推导（逐块验证 + 一条必要的限定）
**(1) 逐块验证。** 第 $i$ 对维度上，$\boldsymbol{PE}_{pos}$ 的两个分量写成列向量 $(\sin(pos\omega),\cos(pos\omega))^{\mathrm T}$（$\omega=\omega_i$），左乘分块后得

$$\begin{pmatrix}\cos(k\omega)\sin(pos\omega)+\sin(k\omega)\cos(pos\omega)\\-\sin(k\omega)\sin(pos\omega)+\cos(k\omega)\cos(pos\omega)\end{pmatrix}=\begin{pmatrix}\sin\bigl((pos+k)\omega\bigr)\\\cos\bigl((pos+k)\omega\bigr)\end{pmatrix},$$

两个分量分别由和角公式得到，正是 $\boldsymbol{PE}_{pos+k}$ 在第 $i$ 对维度上的取值；对每对维度成立，故整块结论成立。

**(2) 「与 pos 无关」是关键**：$\boldsymbol R_k$ 只依赖位移 $k$ 与频率 $\omega_i$，所以「从 $pos$ 的编码推出 $pos+k$ 的编码」在所有位置上用的是同一个线性变换——这正是正弦式被认为「内含相对位置信息」的原因。

**(3) 但这是表示能力，不是学习保证。** 上式只说明**模型原则上可以**用固定线性映射表达相对位移，**不说明**训练后一定会学到相对位置机制：注意力真正用的是 $\boldsymbol q^{\mathrm T}\boldsymbol k$，而 $\boldsymbol q,\boldsymbol k$ 是「词嵌入 + 位置编码」再投影的结果，投影会把位置与词义两个子空间混在一起。**工程经验 + 本书判断**：原生正弦式在训练长度之外同样明显退化，「正弦式可外推」只在很有限的长度范围与任务上成立（对照口径见 [2.6.3](#sec-2.6.3)）。$\blacksquare$
:::
:::

::: intuition 为什么这条定理是 RoPE 的前奏
记住 $\boldsymbol R_k$ 的形状：块对角、每块 $2\times2$、角度正比于位移。有意思的是——**同样的形状，如果作用对象从「嵌入」换成「查询与键」，得到的就是 RoPE**（[2.6.4](#sec-2.6.4)）。区别只有两点：作用对象不同，以及 RoPE 不与词嵌入相加。这个差别带来实质优点：旋转发生在**投影之后**，$\boldsymbol q,\boldsymbol k$ 里不再混有「位置与词义互相占用」的纠缠，内积天然只含相对位移。
:::

## 2.6.3 学习式位置嵌入与「外推」问题 {#sec-2.6.3}

::: def 定义 2.6.2 · 学习式位置嵌入（learned positional embedding） {#def-2.6.2}
准备形状为 $L_{\max}\times d$ 的**可训练参数表** $\boldsymbol P$，第 $pos$ 行作为该位置的位置向量，同样**加**到词嵌入上：$\boldsymbol x_{pos}\leftarrow\boldsymbol e_{pos}+\boldsymbol P_{pos}$。它没有公式，完全由数据学出。

关键推论（**机制层面**，可直接从参数形状推出）：**$\boldsymbol P$ 只有 $L_{\max}$ 行**，所以 $T\gt L_{\max}$ 时位置 $L_{\max}$ 及之后**根本没有参数**，只有三种处置：① **截断**——只能处理 $pos\lt L_{\max}$；② **插值**——把位置索引重新映射进 $[0,L_{\max})$（如按比例压缩），代价是训练时学到的「相邻步距离」被改了尺度，需要少量继续训练适应；③ **外推**——硬用未见过的索引（需要额外构造规则，否则无参数可用）。
:::

::: intuition 学习式嵌入是「查表」，它的上限写在形状里
它就是「把第几个位置当成离散类别特征、每个类别学一个向量」，像词表一样查表。于是它继承了查表的全部优点（表达自由、实现简单；**工程惯例**：早期开源模型多采用，公开配置里常见上限在 512–1024 之间，具体取值以对应实现为准）与全部缺点：表外无参数，且每个位置的参数只被该位置的样本更新——靠后的行训练样本更少，往往学得不如靠前的行充分。
:::

| 方案 | 参数 | 训练长度之外的行为 | 口径 |
|:--|:--|:--|:--|
| 正弦式（[定义 2.6.1](#def-2.6.1)） | 0（算式固定） | 公式在任意 $pos$ 有定义，但实测同样退化 | **工程经验 + 本书判断**：公式有定义不等于分布匹配 |
| 学习式（[定义 2.6.2](#def-2.6.2)） | $L_{\max}\times d$ | 超出 $L_{\max}$ 无参数，只能截断 / 插值 / 外推 | 机制推论：由参数形状直接得到 |
| RoPE（[定义 2.6.3](#def-2.6.3)） | 0 | 内积只含相对位移；位移超出训练范围时相位混叠 | **论文报告**（Su et al., 2021）：长文本上优于正弦式与学习式 |
| ALiBi / T5 偏差（[定义 2.6.4](#def-2.6.4)、[定义 2.6.5](#def-2.6.5)） | 每头 1 个斜率 / 每桶 1 个标量 | 偏差总有定义；ALiBi 报告长度外推明显更好 | **论文报告**（Press et al., 2021）：短训长测设定，以原文条件为准 |

**读表要点**：只有第一列（参数量）与第二列的机制推论是可靠的；第三列全部是**特定实验设定下**的观察，不是对任意模型、任意数据的承诺。

## 2.6.4 RoPE：把位置写进内积 {#sec-2.6.4}

::: def 定义 2.6.3 · 旋转位置编码（Rotary Position Embedding, RoPE） {#def-2.6.3}
不往嵌入上加位置，而是**对查询与键施加位置相关的旋转**。设每头维度 $d_h$（下文简写 $d$），频率族 $\theta_i=10000^{-2i/d}$（$i=0,\dots,d/2-1$）。对位置 $m$ 的向量 $\boldsymbol x$（$\boldsymbol q$ 或 $\boldsymbol k$），按二维子空间 $(2i,2i+1)$ 施加旋转：

$$(\boldsymbol R_m\boldsymbol x)_{2i}=x_{2i}\cos(m\theta_i)-x_{2i+1}\sin(m\theta_i),\qquad (\boldsymbol R_m\boldsymbol x)_{2i+1}=x_{2i}\sin(m\theta_i)+x_{2i+1}\cos(m\theta_i),$$

即 $\boldsymbol R_m$ 是与 [定理 2.6.2](#thm-2.6.2) 同一种块对角旋转矩阵。**作用对象是 $\boldsymbol q,\boldsymbol k$，不是嵌入**：$\boldsymbol q_m\leftarrow\boldsymbol R_m\boldsymbol q_m$、$\boldsymbol k_n\leftarrow\boldsymbol R_n\boldsymbol k_n$，而 $\boldsymbol v$ 与残差主干完全不动。于是分数变成 $s_{mn}=\langle\boldsymbol R_m\boldsymbol q_m,\boldsymbol R_n\boldsymbol k_n\rangle/\sqrt{d_h}$。RoPE **不引入任何可训练参数**，也不改变形状。出处：Su et al., 2021, arXiv:2104.09864。
:::

::: intuition 把位置从「加」搬到「乘」：省下嵌入预算，换来实现细节
加性嵌入在**内容**上做加法；RoPE 在**几何**上做旋转。差别有两条：① 位置不再占用嵌入子空间，不再与词义抢同一份 $d$ 维预算；② 相对位移直接落在**内积**这个注意力真正使用的位置上，不需要模型先学会把位置子空间解耦。代价也要说清：旋转必须在注意力实现里多一步逐元素乘加（频率表可预计算复用；**工程惯例**是把它融合进 kernel，否则为 $\boldsymbol q,\boldsymbol k$ 多付一次读写）；另外 RoPE 的配对是 $(2i,2i+1)$，若实现为适配 kernel 改成「前半与后半配对」，两套写法并不等价，需按实现的约定（**需核实**具体框架的排布）。
:::

::: thm 定理 2.6.3 · RoPE 的相对位置性质 {#thm-2.6.3}
对任意位置 $m,n$ 与任意 $\boldsymbol q,\boldsymbol k\in\mathbb R^{d_h}$：$\langle\boldsymbol R_m\boldsymbol q,\boldsymbol R_n\boldsymbol k\rangle=\langle\boldsymbol q,\boldsymbol R_{n-m}\boldsymbol k\rangle$。即**缩放前的分数只依赖相对位移 $n-m$**，依据是旋转矩阵的正交性与角度可加性 $\boldsymbol R_m^{\mathrm T}\boldsymbol R_n=\boldsymbol R_{-m}\boldsymbol R_n=\boldsymbol R_{n-m}$。
::: proof 推导（三行代数 + 两条限定）
**(1) 主体推导。**

$$\langle\boldsymbol R_m\boldsymbol q,\boldsymbol R_n\boldsymbol k\rangle=(\boldsymbol R_m\boldsymbol q)^{\mathrm T}(\boldsymbol R_n\boldsymbol k)=\boldsymbol q^{\mathrm T}\boldsymbol R_m^{\mathrm T}\boldsymbol R_n\boldsymbol k=\boldsymbol q^{\mathrm T}\boldsymbol R_{-m}\boldsymbol R_n\boldsymbol k=\boldsymbol q^{\mathrm T}\boldsymbol R_{n-m}\boldsymbol k=\langle\boldsymbol q,\boldsymbol R_{n-m}\boldsymbol k\rangle,$$

依次用到 $(\boldsymbol A\boldsymbol x)^{\mathrm T}=\boldsymbol x^{\mathrm T}\boldsymbol A^{\mathrm T}$、$\boldsymbol R_m^{\mathrm T}=\boldsymbol R_m^{-1}=\boldsymbol R_{-m}$（正交）、以及「角度可加」——每个 $2\times2$ 分块上 $-m\theta_i+n\theta_i=(n-m)\theta_i$，块对角矩阵相乘仍是块对角旋转。$\blacksquare$

**(2) 「分数只依赖相对位移」的确切含义**：对**给定的** $\boldsymbol q_m,\boldsymbol k_n$，分数是位移的函数 $s(n-m)$。两处不能过度解读：① softmax 之后，第 $m$ 行第 $n$ 列的**权重**含该行所有键各自位移决定的分母，是「整行相对结构」的函数，不是只看这一个 $n-m$；② 推导把 $\boldsymbol q_m,\boldsymbol k_n$ 当给定向量，而它们还包含内容与残差带来的历史，所以它说的是**位置通道**的相对性。

**(3) 它不等于自动获得无限长度外推。** $\theta_i$ 越大，相位 $m\theta_i$ 转得越快；训练只覆盖 $|n-m|\le L_{\text{train}}$，外推到更远位移时**高频维度的相位会绕圈**：相差 $2\pi/\theta_i$ 的两处给出相同相位，模型无法区分（混叠），分数分布相对训练区间系统性偏移。**论文报告**：RoPE 在长文本任务上优于正弦式与学习式；**本书判断**：那是「同长度区间内更好」，与「无限外推」是两件事。扩大上下文时通常要额外做位置插值 / 频率缩放一类处理（名称与公式因实现而异，**需核实**）。
:::
:::

::: intuition 把位置写进内积意味着什么，不意味着什么
意味着：位置信息进入了**唯一被注意力读取的通道**（内积），模型不必再额外学会「去哪里找位置」；它也解释了为什么 RoPE 对**每个头**都生效（各头共享同一组频率 $\theta_i$，但用的是自己的投影 $\boldsymbol q,\boldsymbol k$），而加性嵌入要靠投影矩阵自行把位置与词义解耦。不意味着：① 模型一定用上相对结构——训练目标里没有直接奖励这一点的项；② 长于训练长度的位移仍然可靠——相位混叠是几何事实，与「内积形式很干净」无关。
:::

## 2.6.5 ALiBi 与相对位置偏差 {#sec-2.6.5}

::: def 定义 2.6.4 · ALiBi（Attention with Linear Biases） {#def-2.6.4}
不加位置向量、不旋转 $\boldsymbol q,\boldsymbol k$，而是直接在**分数**上加一个与相对距离成比例的惩罚：$s_{ij}\mathrel{+}=-m_h\,(i-j)$（因果情形 $i\ge j$，$i$ 为查询位置、$j$ 为键位置），其中 $m_h\gt0$ 是**每个头各自**的斜率（论文取一组按头排开的系数，具体取值以原文为准）。距离越远扣得越多，于是每个头获得一个「注意力半径」。出处：Press, Smith & Lewis, 2021, arXiv:2108.12409——**论文报告**：在「短序列训练、长序列测试」的设定下，外推明显优于正弦式与学习式（条件是论文设定的模型与数据）。
:::

::: intuition 每头一个斜率 = 每头一个「看得多远」
ALiBi 只改 logits：不改嵌入、不加参数表、不动 $\boldsymbol q,\boldsymbol k$ 的计算，因此能挂在任何注意力实现上。「每头一个斜率」还有一个副作用：不同头天然拥有不同的有效窗口（斜率大⇒只看近处），多头因此获得**尺度上的多样性**，而不只是子空间的多样性。代价是：训练区间内 $i-j$ 很小，这个线性惩罚**几乎没被用到远处的键上**，外推行为完全依赖这个被强加的先验形状，而不是从数据里学出来的。
:::

::: def 定义 2.6.5 · 相对位置偏差（T5 式分桶） {#def-2.6.5}
把相对距离 $i-j$（通常只取因果一侧）**分桶**，每桶配一个**可学习标量**偏差，在 softmax 前加到分数上：$s_{ij}\mathrel{+}=b_{\text{bucket}(i-j)}$，近处每步一桶、远处按对数分桶，桶数固定。出处：Raffel et al., 2019, arXiv:1910.10683（T5）；同族思想更早见于 Shaw, Uszkoreit & Vaswani, 2018, arXiv:1803.02155（每个相对位移学一个向量加在键上）。
:::

::: intuition 分桶：用有限参数覆盖任意距离
学习式嵌入的窘境是「表外无参数」；分桶把「距离」从 $O(T)$ 种取值压成固定数量的桶，于是**任意长**的距离都有参数可用——这是典型的**分辨率换覆盖范围**：近处分辨率高，远处多个不同距离共用同一偏差。好处是外推时有定义、行为可预期；代价是远处的距离区分度被牺牲，桶边界本身也是人为超参。
:::

::: think 按「注入位置」分类，三种做法各付什么代价
| 注入位置 | 代表 | 一条最主要的代价 |
|:--|:--|:--|
| **嵌入加性**（加到词嵌入上） | 正弦式、学习式 | 与词义共享嵌入容量；学习式有硬上限 $L_{\max}$，表外无参数 |
| **QK 乘性**（旋转 $\boldsymbol q,\boldsymbol k$） | RoPE | 旋转必须进 kernel（否则多付读写）；外推需额外处理；对维度配对顺序敏感 |
| **分数加性**（加在 logits 上） | ALiBi、T5 分桶、Shaw 式 | 偏差形状是人为先验（ALiBi 的线性惩罚在训练区间内几乎没被激活）；分桶牺牲远处分辨率 |

**本书判断**：这三类不该用「谁更先进」判断，而该问「要解决哪一笔账」——同长度内要更好的相对位置表达，选 QK 乘性；要「短训长测」的行为可预期，分数加性更容易论证与调试；只想最小改动地补上位置，嵌入加性最省事。
:::

## 2.6.6 长上下文的三个瓶颈 {#sec-2.6.6}

::: method 长上下文的三笔账 {#method-2.6.1}
设批 $B$、头数 $H$、每头维度 $d_h$、序列长 $T$、层数 $L$、KV 头数 $n_{kv}$（MHA 时 $n_{kv}=H$；GQA/MQA 见 [2.4.6](sec24.md#sec-2.4.6) 与 [2.5.6](sec25.md#method-2.5.3)），FP16（每元素 2 字节）。

1. **分数 / 权重矩阵**（**每层**一份，若物化）：元素数 $B\cdot H\cdot T^{2}$，显存 $=B\,H\,T^{2}\times2$ 字节。
2. **注意力 FLOPs**（前向，$\boldsymbol Q\boldsymbol K^{\mathrm T}$ 与 $\boldsymbol P\boldsymbol V$ 各一次矩阵乘）：约 $4\,B\,H\,T^{2}d_h$ 次乘加 ⇒ $O(T^{2}d)$ 量级。
3. **KV cache**（**整模型**、推理时逐 token 复用，公式与 [2.5.6](sec25.md#method-2.5.3) 一致）：$2\times L\times B\times T\times n_{kv}\times d_h\times2$ 字节。

代入 $T=32768$、$d_h=128$、$H=32$、$B=1$、$L=32$、FP16：**①** $1\times32\times32768^{2}=3.44\times10^{10}$ 个元素，$\times2$ 字节 $=6.87\times10^{10}$ 字节 $\approx\mathbf{64\ GiB}$（单层）；**②** $4\times32\times32768^{2}\times128=1.76\times10^{13}\approx\mathbf{17.6\ TFLOP}$（单层前向）；**③** $2\times32\times32768\times32\times128=8.59\times10^{9}$ 个 K/V 元素，$\times2$ 字节 $\approx\mathbf{16\ GiB}$（整模型，MHA）。

| $T$ | ① 分数矩阵（单层，FP16） | ② 注意力 FLOPs（单层，前向） | ③ KV cache（$L=32$，MHA） |
|:--|:--|:--|:--|
| $8192$ | $4\ \text{GiB}$ | $1.1\ \text{TFLOP}$ | $4\ \text{GiB}$ |
| $32768$ | $64\ \text{GiB}$ | $17.6\ \text{TFLOP}$ | $16\ \text{GiB}$ |
| $131072$ | $1024\ \text{GiB}$（$1$ TiB） | $281\ \text{TFLOP}$ | $64\ \text{GiB}$ |

**三条读法**：① 增长阶不同——①② 是 $O(T^{2})$、③ 是 $O(T)$；$T$ 每乘 4，①②各乘 16、③只乘 4。② **显存**问题先于**算力**问题出现：$T=32768$ 时单层分数矩阵就是 64 GiB（这正是不物化它的动机，见 [2.6.7](#sec-2.6.7)），而 KV cache 是**推理**时的主要消费者（权重只占一次，KV 随 $T$、$B$ 无限增长）。③ 三笔账可**分别**交易：不物化中间矩阵、压缩 KV（GQA / 量化 / 淘汰）、把序列切到多卡（[2.6.9](#sec-2.6.9)）——**本书判断**：先量化再优化，哪一笔最先撑不住就先治哪一笔；混成一句「长上下文很贵」会让人选错手段。
:::

## 2.6.7 FlashAttention：不改变数学，只改变访存 {#sec-2.6.7}

::: thm 定理 2.6.4 · 分块注意力与在线 softmax 的等价性 {#thm-2.6.4}
把键（与值）沿序列维切成块，逐块累积并维护每行一个的运行统计量：运行最大值 $m_j$、指数和 $\ell_j$、未归一化输出累加 $\boldsymbol O_j$（$j$ 遍历键块，$i$ 遍历当前块内位置）：

$$m_j=\max\bigl(m_{j-1},\ \max_i s_{ij}\bigr),\qquad \ell_j=e^{\,m_{j-1}-m_j}\ell_{j-1}+\sum_i e^{\,s_{ij}-m_j},$$

$$\boldsymbol O_j=e^{\,m_{j-1}-m_j}\boldsymbol O_{j-1}+\sum_i e^{\,s_{ij}-m_j}\boldsymbol v_i .$$

则最终输出 $\boldsymbol O=\boldsymbol O_J/\ell_J$ 与「整块 softmax 再乘 $\boldsymbol V$」结果**完全相同**，差别只在浮点舍入。**FLOPs 不变**：分块改变的是运算顺序与中间量的存放位置，不是乘加次数。出处：Dao et al., 2022, arXiv:2205.14135。
::: proof 推导（为什么「分块累加 + 重新缩放」能精确复现 softmax）
**(1) softmax 的稳定形式。** 取 $m=\max_i s_i$，则 $\operatorname{softmax}(s)_i=e^{s_i-m}/\sum_{i'}e^{s_{i'}-m}$：减去最大值不改变结果（分子分母同乘 $e^{-m}$），但保证指数不溢出。第 $i$ 个位置的权重 = 未归一化权重 $e^{s_i-m}$ ÷ 归一化因子 $\ell=\sum_{i'}e^{s_{i'}-m}$。

**(2) 归纳假设与归纳步。** 假设处理完前 $j-1$ 块后，$\ell_{j-1}=\sum_{i\lt j}e^{s_i-m_{j-1}}$、$\boldsymbol O_{j-1}=\sum_{i\lt j}e^{s_i-m_{j-1}}\boldsymbol v_i$（**以 $m_{j-1}$ 为基准**）。第 $j$ 块带来新最大值 $m_j\ge m_{j-1}$；把旧累加换成以 $m_j$ 为基准，只需每项乘 $e^{\,m_{j-1}-m_j}$，这正是递推式里的**重缩放因子**：

$$\ell_j=e^{\,m_{j-1}-m_j}\underbrace{\sum_{i\lt j}e^{\,s_i-m_{j-1}}}_{\ell_{j-1}}+\sum_{i\in\text{块}j}e^{\,s_i-m_j}=\sum_{i\le j\text{ 已处理}}e^{\,s_i-m_j},$$

$\boldsymbol O_j$ 同理。归纳到最后一个键块得 $\boldsymbol O_J/\ell_J$ 正是 softmax 加权和；与整块计算的差异只来自不同求和顺序在浮点下的舍入（实现要用 FP32 累积统计量，**工程惯例**）。

**(3) 分块之后每步处理什么。** 取查询块大小 $B_q$、键块大小 $B_c$：

| 量 | 形状 | 说明 |
|:--|:--|:--|
| 查询块 $\boldsymbol Q_i$ | $B\times H\times B_q\times d_h$ | 外层循环索引 $i$ |
| 键 / 值块 $\boldsymbol K_j,\boldsymbol V_j$ | $B\times H\times B_c\times d_h$ | 内层循环索引 $j$ |
| 块分数 $\boldsymbol S_{ij}$ | $B\times H\times B_q\times B_c$ | **只在片上 SRAM 存在，从不写回 HBM** |
| 运行最大值 / 指数和 | $B\times H\times B_q$（各一份） | 每行两个标量；高精度累积 |
| 输出累加 $\boldsymbol O_i$ | $B\times H\times B_q\times d_h$ | 未归一化，最后除以 $\ell_J$ |

**(4) 变的是哪一笔账。** 中间矩阵留在片上、不落盘，反向传播**重算**块分数而不保存它，于是中间显存从 $O(T^{2})$ 降到 $O(T)$。**论文报告**的表述是 HBM 访问量从 $\Theta(T^{2}d)$ 量级降到 $\Theta(T^{2}d^{2}/M)$ 量级（$M$ 为片上内存容量，以原文为准）。数学与 FLOPs 都不变——这是它与稀疏/近似注意力的根本区别（[2.6.8](#sec-2.6.8)）。$\blacksquare$
:::
:::

::: intuition 一句话：FlashAttention 治的是「三笔账里第一笔的访存代价」
[2.6.6](#sec-2.6.6) 的第一笔账是**显存**（单层 64 GiB 的中间矩阵），FlashAttention 把它彻底消掉：中间量只在片上活一小块。但两件事必须看清：① **算力账没变**，$O(T^{2}d)$ 的 FLOPs 一步没少，所以它不能让 $T$ 免费上涨；② 它换来的是**可用显存**与**实际带宽开销**：GPU 上矩阵乘很快、HBM 读写很慢，省掉一次 $T\times T$ 矩阵的读写往往比省同样多的 FLOPs 更值钱。抓手是「快，是因为少搬了几趟数据，不是少算了」。
:::

| 版本 | 主要改进 | 论文报告的效率结论（条件：随硬件、序列长度、版本变化） |
|:--|:--|:--|
| FA-1（2022, arXiv:2205.14135） | 分块 + 在线 softmax + 反向重计算，全程不物化 $T\times T$；IO 感知 | 论文报告长序列下显著快于当时的常规实现，中间显存从 $O(T^{2})$ 降到 $O(T)$（倍数随配置变化，以原文为准） |
| FA-2（2023, arXiv:2307.08691） | 更好的并行度与工作划分（沿序列切分、减少非矩阵乘开销、warp 级并行与更少同步） | 论文报告 A100 上相对 FA-1 约 $2\times$ 吞吐（以原文为准） |
| FA-3（2024, arXiv:2407.08608） | 面向 Hopper 的异步（TMA）+ warp specialization，并把 FP8 纳入流水 | 论文报告 H100、FP8 下相对 FA-2 约 $1.5\sim2\times$（以原文为准）；低精度对数值与精度的影响需在目标任务上评估 |

三个版本的共同点比差异更重要：**它们都是精确注意力**（等价于 [定理 2.6.4](#thm-2.6.4)），差异集中在「怎么把这套分块流水喂满某代硬件」。**本书判断**：把 FlashAttention 的加速比当作可移植常数是危险的，它高度依赖存储层次与算子融合质量。

## 2.6.8 稀疏、滑窗与 KV cache 压缩 {#sec-2.6.8}

::: def 定义 2.6.6 · 滑窗注意力与稀疏注意力 {#def-2.6.6}
**滑窗注意力**（sliding-window attention）限制每个查询只看附近窗口内的键：因果情形 $\mathcal S=\{(i,j):0\le i-j\le W-1\}$，且权重**只在窗口内**归一化，$o_i=\sum_{j:(i-j)\in[0,W)}e^{s_{ij}}\boldsymbol v_j/\sum_{j:(i-j)\in[0,W)}e^{s_{ij}}$，复杂度 $O(T\,W\,d)$（$W$ 固定时对 $T$ 线性）。**稀疏注意力**（sparse attention）把两者统一：给定稀疏模式 $\mathcal S\subseteq[T]\times[T]$，只在 $\mathcal S$ 上计算——稠密是 $\lvert\mathcal S\rvert=T^{2}$ 的特例，滑窗是 $\lvert\mathcal S\rvert\approx T\,W$ 的特例，一般模式代价为 $O(\lvert\mathcal S\rvert\,d)$。

要紧的一点：**稀疏化省的是哪一笔，取决于实现**。若只是把掩码置零、仍走稠密矩阵乘，省下的只有数学上的权重（实现开销不变）；只有真正**跳过被掩掉的块**（块稀疏），才省下 FLOPs 与带宽。
:::

::: intuition 滑窗是「用层数换视野」
单层滑窗只看 $W$ 步，但**多层堆叠会把有效感受野逐层扩大**：第 $l$ 层的一个位置间接看到约 $l(W-1)+1$ 步之前的内容，视野随深度线性增长。所以「滑窗 = 放弃长程」只在**单层**意义上成立。代价随之而来：路径长度从 $O(1)$ 变成 $O(T/W)$，多层中转让「精确回忆某个远处位置的原值」变难（每一步都在混合）。这也解释了混合架构（[2.7.6](sec27.md#sec-2.7.6)）为什么总要在滑窗/线性层之间插入少量**全局**注意力层。
:::

::: method 长序列的工程手段对照表 {#method-2.6.2}
| 手段 | 省哪一笔 | 代价是什么（条件） |
|:--|:--|:--|
| **滑窗**（Longformer, 2020, arXiv:2004.05150） | 分数矩阵与 FLOPs：$O(T^2)\to O(TW)$ | 单层视野只有 $W$；远处信息经多层中转，路径变长；kernel 利用率通常低于稠密矩阵乘 |
| **稀疏模式 + 全局 token**（BigBird, 2020, arXiv:2007.14062） | 同上，另加少量全局位置 | 随机/全局连接的收益依赖任务（**论文报告**，条件见原文）；实现复杂度高 |
| **固定稀疏模式**（Sparse Transformers, 2019, arXiv:1904.10509） | 分数矩阵与 FLOPs | 模式是**人为先验**，跨任务迁移不保证；模式选择成为超参 |
| **注意力汇 + 滑窗**（StreamingLLM, 2023, arXiv:2309.17453） | 推理 KV cache：$O(T)$ 压到常数 | **信息被永久丢弃**：超出「最初若干 sink token + 最近窗口」的历史不可见，长程回忆必然退化；换来流式长跑不爆显存（论文报告的关键现象是「保留最初几个 token」对稳定性至关重要） |
| **按重要度淘汰 KV**（H2O, 2023, arXiv:2306.14048） | 推理 KV cache：固定预算内留 heavy hitters | 淘汰依据是**历史**累积注意力分数，对未来查询不一定可靠；需预算超参，误淘汰直接伤质量 |
| **KV 头压缩**（GQA 2023, arXiv:2305.13245；MQA 2019, arXiv:1911.02150） | KV cache 与读取带宽：按 $H/n_{kv}$ 下降（$4\times\sim32\times$） | KV 头变少、每个 KV 组服务多个查询头，表达力略降（**论文报告**质量损失很小，且可从 MHA 检查点继续训练恢复；条件是在相应规模与任务上，需自行验证） |
| **KV 量化**（常见工程做法） | KV cache 的**字节数**：FP16→INT8 约 $2\times$、→INT4 约 $4\times$ | 低精度下单 token 误差会沿时间累积，需要 per-channel 尺度与离群值处理；具体实现依框架（**需核实**） |

**两条读表纪律**：① 先分清「省显存」「省 FLOPs」「省带宽」——三者不是一回事（滑窗省密集矩阵，StreamingLLM 省推理 cache 字节）；② 每一种都不是纯收益，省下资源、付出的是「看得更少」「存得更粗」或「淘汰得可能错」。**本书判断**：先写清任务是否依赖**精确回忆远处的具体内容**（检索式问答、长代码依赖分析）；若是，滑窗与淘汰类要格外小心，而 GQA 与 KV 量化这类「不改变可见范围」的手段相对安全。
:::

## 2.6.9 序列并行与 Ring Attention（一段导读） {#sec-2.6.9}

三笔账都可以用「把序列切成几段分到多张卡」摊薄，但切法不同、通信模式就不同。**Ring Attention**（Liu, Wang & Abbeel, 2023, arXiv:2310.01889）沿序列维切分查询、键、值，各卡在环状拓扑上互相传递键值块（P2P 通信），一边算本地块一边把收到的块转发下一张卡，使**通信与计算重叠**；论文报告「可用序列长度随设备数线性增长」，条件的核心是通信能被计算掩盖。**DeepSpeed-Ulysses**（Jacobs et al., 2023, arXiv:2309.14509）走另一条路：沿序列维切分后用 all-to-all 把「序列切分」换成「头切分」，让每张卡在不同阶段分别拥有完整的头或完整的序列——代价是**头数必须能被并行度整除**，且 all-to-all 通信量大。**Megatron 序列并行**（Korthikanti et al., 2022, arXiv:2205.05198）处理更朴素的一类激活：LayerNorm、Dropout 等**逐位置**算子在张量并行下原本要复制激活，按序列维切分后这部分也随之摊薄（该文还给出选择性激活重计算，**论文报告**把额外计算压到很小比例）。

三个判断：① 序列并行**不减少** $O(T^{2})$ 的算术量，减少的是**每张卡上的显存**；② 三种切法的差别主要在「切完怎么换数据」（环状 P2P、all-to-all、无需通信）与各自的整除约束；③ 长序列的真实上限往往是通信带宽与重叠效率，而不是算术峰值。第 9 讲会把并行策略统一放进显存与通信的框架，届时这张小表会并进那张总表。

| 手段 | 切什么维 | 通信模式 | 关键限制 |
|:--|:--|:--|:--|
| Ring Attention（2023, arXiv:2310.01889） | 序列（Q/K/V 都切） | 环状 P2P 传 KV 块，与计算重叠 | 依赖通信被计算掩盖；环越长尾部等待越明显 |
| DeepSpeed-Ulysses（2023, arXiv:2309.14509） | 先切序列、再按头切 | all-to-all（前向 + 反向各一次） | 头数需被并行度整除；all-to-all 通信量大 |
| Megatron 序列并行（2022, arXiv:2205.05198） | 序列（针对逐位置激活） | 常规 TP 通信即可 | 只摊薄激活，不解决注意力本身的 $T^2$；常与选择性重计算配合 |

## 2.6.10 代码：RoPE、滑窗掩码与 SDPA 后端 {#sec-2.6.10}

```python
import torch, torch.nn.functional as F, math

def rope(x, pos, base=10000.0):
    """x:(B,H,T,d_h) pos:(k,) → 对每两维一组施加位置旋转"""
    B, H, T, d = x.shape
    assert d % 2 == 0, "RoPE 要求每个头的维度成对"
    i = torch.arange(0, d // 2, dtype=torch.float32)
    theta = base ** (-2.0 * i / d)                 # 频率族 theta_i = 10000^{-2i/d}
    ang = pos.float()[:, None] * theta[None, :]    # (k, d/2)：每位置每对的旋转角
    x1, x2 = x[..., 0::2], x[..., 1::2]            # 偶数维 / 奇数维配成一对
    o1 = x1 * ang.cos() - x2 * ang.sin()           # 2×2 分块 [c,−s; s,c] 作用在 (x1,x2)
    o2 = x1 * ang.sin() + x2 * ang.cos()
    return torch.stack([o1, o2], dim=-1).flatten(-2)

torch.manual_seed(0)
B, H, T, d = 1, 2, 8, 8
q, k = torch.randn(B, H, T, d), torch.randn(B, H, T, d)
pos, m, n = torch.arange(T, dtype=torch.float32), 5, 2
# ① 定理 2.6.3：⟨R_m q, R_n k⟩ 应与 ⟨q, R_{n−m} k⟩ 数值相等
lhs = (rope(q, pos)[:, :, m] * rope(k, pos)[:, :, n]).sum(-1)
rhs = (q[:, :, m] * rope(k[:, :, n:n+1], torch.tensor([float(n - m)]))[:, :, 0]).sum(-1)
assert torch.allclose(lhs, rhs, atol=1e-5), "RoPE 的相对位置性质未通过数值检查"

# ② 滑窗掩码＋手工注意力：窗口外的键必须在 softmax 之前置为 −inf
W = 3
keep = torch.ones(T, T, dtype=torch.bool).tril().triu(diagonal=-(W - 1))   # 只看最近 W 个位置
P = (q @ k.transpose(-2, -1) / math.sqrt(d)).masked_fill(~keep, float("-inf")).softmax(-1)
v = torch.randn(B, H, T, d)
out = P @ v                                              # 行和重新归一化后才是合法权重
print("窗口内可见键数：", keep.sum(-1).tolist())          # 期望 [1,2,3,3,...]

# ③ 官方 SDPA：后端在 flash / memory-efficient / math 之间自动选择，
#    数学结果与 ② 一致（“等价但快”）；选择后端的 API 依版本而异，需核实当前版本文档
mask = torch.zeros(T, T).masked_fill(~keep, float("-inf"))
ref = F.scaled_dot_product_attention(q, k, v, attn_mask=mask)
assert torch.allclose(out, ref, atol=1e-5), "SDPA 与手工滑窗注意力不一致"
print("SDPA 输出形状：", tuple(ref.shape))
```

三段代码各钉住一条结论：**①** [定理 2.6.3](#thm-2.6.3) 的相对位移性质可被数值验证（这与「模型一定学到相对位置」是两回事）；**②** 滑窗掩码必须在 **softmax 之前**加并重新归一化（否则行和不为 1、输出尺度被破坏）；**③** 官方 `scaled_dot_product_attention` 与手工实现数值一致，印证 [2.6.7](#sec-2.6.7) 的「数学不变、只改访存」。

::: ex 例 2.6.1 · 长上下文的显存与 FLOPs 手算 {#ex-2.6.1}
取 $T=131072$（128k）、$d_h=128$、$H=32$、$B=1$、层数 $L=32$、FP16。(1) 每层分数矩阵有多少元素、占多少显存？(2) 每层注意力（前向）约多少 FLOPs，与 $T=32768$ 相比涨几倍？(3) MHA（$n_{kv}=32$）下整模型 KV cache 多大？换 GQA（$n_{kv}=8$）后呢？(4) 该模型（$d=H\cdot d_h=4096$、$L=32$）权重约占多少 FP16 显存？把结论与 (3) 对照。
::: proof 解
**(1) 分数矩阵。** 元素数 $B\cdot H\cdot T^{2}=1\times32\times131072^{2}$。因 $131072=2^{17}$，$T^{2}=2^{34}=1.718\times10^{10}$，乘 32 得 $1\times32\times2^{34}=2^{39}=5.50\times10^{11}$ 个元素；$\times2$ 字节 $=2^{40}$ 字节 $=\mathbf{1024\ GiB=1\ TiB}$（**单层**）——这个数字本身就是「必须分块、不可物化」的全部理由。

**(2) FLOPs。** $4BHT^{2}d_h=4\times32\times1.718\times10^{10}\times128=2.81\times10^{14}\approx\mathbf{281\ TFLOP}$（单层前向）。与 $T=32768$ 的 17.6 TFLOP 相比：$T$ 乘 4 ⇒ 分数矩阵与 FLOPs 各乘 $4^{2}=16$，$17.6\times16=281.6$ ✓，与直接计算一致。

**(3) KV cache。** 按 [2.5.6](sec25.md#method-2.5.3) 的算式 $2LB\,T\,n_{kv}d_h\times2$ 字节：

$$2\times32\times1\times131072\times32\times128\times2=6.87\times10^{10}\ \text{字节}\approx\mathbf{64\ GiB}\quad(n_{kv}=32).$$

换 GQA（$n_{kv}=8$，4 个查询头共享一组 KV）后按比例降到 $1/4$：$\approx\mathbf{16\ GiB}$。注意**分数矩阵与此无关**（它由查询头数 $H$ 决定）——这正是 GQA 治的是第三笔账、不是第一笔账的原因。

**(4) 与权重显存对照。** 参数量约 $12Ld^{2}=12\times32\times4096^{2}=6.44\times10^{9}$（6.4B），FP16 权重 $\approx\mathbf{12.9\ GB}$。于是 $T=131072$、$B=1$ 时 **KV cache（64 GiB）是权重显存的约 5 倍**；把 $B$ 提到 8，KV cache 约 512 GiB 而权重不变。**结论**：长上下文推理的第一瓶颈不是「模型太大」，而是「缓存的键值太多」；三笔账里最先撞墙的是第三笔，而它的缓解手段（GQA、量化、淘汰）各有质量代价。$\blacksquare$
:::
:::

## 2.6.11 陷阱与勘误 {#sec-2.6.11}

::: errata 本节六个必须说清的误解
1. **「位置编码可有可无」**：与 [定理 2.6.1](#thm-2.6.1) 直接冲突。没有位置注入，目标函数对语序置换不变，模型学到的是词袋式预测；症状是困惑度尚可、语序任务崩坏。掩码只给方向、不给距离，替代不了位置编码。
2. **「RoPE / ALiBi 自带无限外推」**：内积只依赖相对位移是**表示**层面性质（[定理 2.6.3](#thm-2.6.3)）；外推时高频维度相位混叠，分布相对训练区间系统性偏移。ALiBi 的论文报告也只在「短训长测」的特定设定下成立。扩大上下文时，位置插值/频率缩放一类处理通常是必需的（**需核实**）。
3. **「FlashAttention 是近似算法」**：它是**精确**注意力（[定理 2.6.4](#thm-2.6.4)），只是不物化中间矩阵、反向重算；把它与稀疏/低秩近似混为一谈，会带来错误的精度担忧与错误的优化决策（很多人因此错过了免费的显存）。**FLOPs 不变**。
4. **「滑窗就是放弃长程」**：单层视野只有 $W$，但有效感受野随深度线性增长（[2.6.8](#sec-2.6.8)）；真正的代价是**路径变长**与**精确回忆变难**——远处内容被多层加权平均混合，不是简单地「看不到」。
5. **「KV cache 可以无限增长，加机器就行」**：它随 $B\cdot T\cdot n_{kv}$ 线性增长，128k 上下文下可达权重显存的数倍（[例 2.6.1](#ex-2.6.1)）；推理每步都要把它读一遍，即使显存够，**带宽**也会成为瓶颈（推理是 memory-bound，见 [附录 C.5](../../appendix/derivations.md)）。可行方向是 GQA / KV 量化 / 滑窗与淘汰，每类都有质量代价。
6. **「$O(T)$ 一定比 $O(T^{2})$ 快」**：复杂度是渐近量，常数与硬件利用率同样重要。稠密注意力是**矩阵乘**（GPU 最擅长的算子），许多线性/稀疏实现则是逐元素或访存受限算子（峰值利用率低）。在小到中等 $T$ 上线性方案**实际更慢**是常见现象；只有 $T$ 远大于某个由实现与硬件决定的交叉点，渐近优势才兑现。**本书判断**：任何「线性注意力更快」的论断都必须附带「在多大 $T$、什么硬件、哪个实现」。
:::

::: method 即时自测 · 2.6 {#method-2.6.3}
**Q1** 写出正弦位置编码的公式与 [定理 2.6.2](#thm-2.6.2) 的结论。它是「表示能力」还是「学习保证」？为什么这个区别重要？

**Q2** RoPE 作用在哪两个张量上？写出 $\langle\boldsymbol R_m\boldsymbol q,\boldsymbol R_n\boldsymbol k\rangle$ 的化简过程，并解释「分数只依赖相对位移」的确切含义与它**不包含**什么。

**Q3** 对 $B=1$、$H=32$、$d_h=128$、$L=32$、FP16：$T$ 从 8192 增到 32768 时，① 分数矩阵显存、② 注意力 FLOPs、③ KV cache（MHA）各涨几倍？给出关键算式。

**Q4** 一句话说明 FlashAttention 为什么快，并解释它为什么**不是**近似算法。

::: sol 参考要点
**Q1** $PE_{(pos,2i)}=\sin(pos/10000^{2i/d})$、$PE_{(pos,2i+1)}=\cos(pos/10000^{2i/d})$，加到词嵌入上；结论 $\boldsymbol{PE}_{pos+k}=\boldsymbol R_k\boldsymbol{PE}_{pos}$，$\boldsymbol R_k$ 是与 $pos$ 无关的块对角旋转矩阵。它是**表示能力**：模型原则上能用固定线性变换表达相对位移，但**不保证**训练后学到相对位置机制（$\boldsymbol q,\boldsymbol k$ 是「嵌入 + 位置」再投影的结果，位置与词义会在投影中混合）。区别重要，是因为「公式里有」不能当成「实验中会外推」——正弦式在训练长度外同样退化。

**Q2** 作用在 $\boldsymbol q,\boldsymbol k$ 上（$\boldsymbol v$ 与残差主干不动）。化简：$\langle\boldsymbol R_m\boldsymbol q,\boldsymbol R_n\boldsymbol k\rangle=\boldsymbol q^{\mathrm T}\boldsymbol R_m^{\mathrm T}\boldsymbol R_n\boldsymbol k=\boldsymbol q^{\mathrm T}\boldsymbol R_{-m}\boldsymbol R_n\boldsymbol k=\boldsymbol q^{\mathrm T}\boldsymbol R_{n-m}\boldsymbol k$。含义：给定 $\boldsymbol q_m,\boldsymbol k_n$ 时，缩放前分数是位移 $n-m$ 的函数。不包含：① softmax 之后每行权重还依赖该行**所有**键的相对位移（分母）；② 它只说位置通道的相对性，不含内容与残差带来的绝对信息；③ 它不承诺超出训练位移范围的外推能力（相位混叠）。

**Q3** ① 分数矩阵 $\propto H\cdot T^{2}$：$T$ 乘 4 ⇒ **16 倍**（4 GiB → 64 GiB）；② FLOPs $\propto H\cdot T^{2}d_h$ ⇒ 同样 **16 倍**（1.1 TFLOP → 17.6 TFLOP）；③ KV cache $\propto L\cdot T\cdot n_{kv}d_h$ ⇒ 只涨 **4 倍**（4 GiB → 16 GiB）。关键算式：$32\times32768^{2}\times2$ 字节 $=64$ GiB；$2\times32\times32768\times32\times128\times2$ 字节 $=16$ GiB。

**Q4** 它把不物化的分数矩阵留在**片上内存**、用在线 softmax 边算边累积（[定理 2.6.4](#thm-2.6.4)），省掉了 $T\times T$ 矩阵在 HBM 上的读写与存放，反向用重计算代替保存。它不是近似：分块递推与整块 softmax 的数学结果**完全相同**，差别只有浮点舍入——它以 FLOPs 不变换取显存与带宽。
:::
:::

::: note[skip] 延伸阅读
- Vaswani et al., *Attention Is All You Need*（2017, arXiv:1706.03762）——读 3.5 节：正弦式的设计理由与「为什么用加法」。
- Shaw, Uszkoreit & Vaswani, *Self-Attention with Relative Position Representations*（2018, arXiv:1803.02155）——分数加性偏差的来源。
- Dai et al., *Transformer-XL*（2019, arXiv:1901.02860）——看相对位置编码如何与段间记忆复用结合。
- Raffel et al., *T5*（2019, arXiv:1910.10683）——相对位置分桶的实现细节（近处细、远处粗）。
- Su et al., *RoFormer*（2021, arXiv:2104.09864）——RoPE 的推导与长文本实验；[定理 2.6.3](#thm-2.6.3) 的依据。
- Press, Smith & Lewis, *Train Short, Test Long*（2021, arXiv:2108.12409）——ALiBi 的斜率设置与「短训长测」实验口径。
- Dao et al., *FlashAttention*（2022, arXiv:2205.14135）、Dao, *FlashAttention-2*（2023, arXiv:2307.08691）、Shah et al., *FlashAttention-3*（2024, arXiv:2407.08608）——三代的分块算法、并行度诊断与异步/低精度流水。
- Liu, Wang & Abbeel, *Ring Attention*（2023, arXiv:2310.01889）、Jacobs et al., *DeepSpeed Ulysses*（2023, arXiv:2309.14509）、Korthikanti et al., *Megatron 序列并行*（2022, arXiv:2205.05198）——三种序列切法的通信模式与整除约束。
- Beltagy et al., *Longformer*（2020, arXiv:2004.05150）、Zaheer et al., *Big Bird*（2020, arXiv:2007.14062）、Child et al., *Sparse Transformers*（2019, arXiv:1904.10509）——稀疏/滑窗路线的三种代表模式。
- Xiao et al., *StreamingLLM*（2023, arXiv:2309.17453）、Zhang et al., *H2O*（2023, arXiv:2306.14048）——推理期 KV 压缩（保留 sink + 窗口 / 按重要度淘汰）。
- Ainslie et al., *GQA*（2023, arXiv:2305.13245）、Shazeer, *Fast Transformer Decoding*（2019, arXiv:1911.02150）——KV 头压缩的做法与动机（与 [2.4.6](sec24.md#sec-2.4.6)、[2.5.6](sec25.md#method-2.5.3) 对照读）。
:::

**本节小结**：注意力不认识顺序，位置必须显式注入——按注入位置分三类：**嵌入加性**（正弦式 / 学习式，代价是占用嵌入容量与硬上限）、**QK 乘性**（RoPE，内积只依赖相对位移，代价是 kernel 与配对顺序的实现细节）、**分数加性**（ALiBi / T5 分桶，代价是人为先验与远处分辨率）。长上下文有三笔**增长阶不同**的账：分数矩阵 $O(T^{2})$ 显存、注意力 $O(T^{2}d)$ FLOPs、KV cache $O(T)$ 但常数大；$T$ 乘 4 时前两者乘 16、后者只乘 4，于是瓶颈从算力迁移到显存与带宽。FlashAttention 用分块与在线 softmax **只改访存、不改数学**（FLOPs 不变、输出精确一致），滑窗 / 稀疏 / KV 压缩 / 序列并行则各自交易一笔账，且每一种都有质量或实现代价。下一节追问更根本的一件事：**能不能换一种架构，让这三笔账里最贵的两笔根本不出现**——[2.7](sec27.md) 从「注意力是一个算子」走到「序列模型是一族算子」：线性状态空间（S4）、选择性状态空间（Mamba）、与注意力同族的对偶（Mamba-2）、线性注意力与 RWKV、混合架构，以及把总参数量与每 token 计算量解耦的稀疏专家层。
