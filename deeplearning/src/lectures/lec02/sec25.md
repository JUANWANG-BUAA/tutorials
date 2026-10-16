# 2.5 Transformer：把注意力堆成主干

[2.4](sec24.md) 给出了一个干净的算子：$\operatorname{softmax}(\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_k})\boldsymbol V$。它一次性解决了三个问题——历史不再被压缩、任意两点的路径长度为 $O(1)$、所有位置的计算可以并行。但一个算子还不是一个模型：单头注意力的表达能力有限，注意力只做「跨位置混合」，而每个位置内部还需要非线性变换；更麻烦的是，把这样的层堆几十层，梯度会像第 1 讲的深层网络一样出问题。

Transformer 的回答是「**只靠注意力 + 前馈层，把工程件补齐**」：多头注意力负责在多个子空间里并行检索，位置前馈层负责位置内的非线性，残差连接与层归一化负责让几十层能训得动。这一节的顺序就按这四个部件展开，然后做三件工程上最要紧的账：**前向形状表、参数量估算、KV cache 显存**。最后讨论一个经常被混淆的区别：**训练时可以一次算完全部位置，推理时却只能逐 token 生成**——这不是实现水平问题，而是自回归目标的结构性后果。

## 2.5.1 多头注意力：并行看多个子空间 {#sec-2.5.1}

::: def 定义 2.5.1 · 多头自注意力（multi-head self-attention） {#def-2.5.1}
设输入 $\boldsymbol X\in\mathbb R^{T\times d}$，头数 $H$，每头维度 $d_h=d/H$。对第 $j$ 个头用**各自的**投影得到

$$\boldsymbol Q_j=\boldsymbol XW_j^Q,\qquad \boldsymbol K_j=\boldsymbol XW_j^K,\qquad \boldsymbol V_j=\boldsymbol XW_j^V,\qquad W_j^{\bullet}\in\mathbb R^{d\times d_h},$$

各自做一次缩放点积注意力，再拼接、投影融合：

$$\operatorname{head}_j=\operatorname{Attention}\bigl(\boldsymbol Q_j,\boldsymbol K_j,\boldsymbol V_j\bigr),\qquad
\operatorname{MHA}(\boldsymbol X)=\bigl[\operatorname{head}_1;\dots;\operatorname{head}_H\bigr]W^O,\quad W^O\in\mathbb R^{d\times d}.$$

批优先实现里的形状变化：$(B,T,d)\xrightarrow{\ \text{投影+reshape}\ }(B,H,T,d_h)\xrightarrow{\ \text{注意力}\ }(B,H,T,d_h)\xrightarrow{\ \text{合并}\ }(B,T,d)$。
:::

::: intuition 一个头给一组权重，多个头给多组权重
注意力层输出的每个位置是 $\boldsymbol V$ 的一个**凸组合**。单头只能给出一组权重——「这个位置最该看哪里」只能有一个答案。但语言里的依赖是**多重的**：同一个位置可能同时需要（i）前一个词（局部语法）、（ii）主语（句法）、（iii）上一句话里的某个实体（指代）。多头就是把这件事拆成 $H$ 个并行的小注意力：每个头在自己的 $d_h$ 维子空间里独立决定「看哪里」，最后由 $W^O$ 把 $H$ 份结果线性混合。**注意头与头之间没有交互**（各自的 softmax 独立），交互只发生在拼接之后的 $W^O$ 里。
:::

::: thm 定理 2.5.1 · 多头的参数量与它的「不承诺」 {#thm-2.5.1}
设 $d_h=d/H$。则多头注意力的可学习参数量为

$$4d^2+4d\quad(\text{四个 }d\times d\text{ 投影 }W^Q,W^K,W^V,W^O\text{ 各 }d^2\text{，偏置 }4d),$$

**与头数 $H$ 无关**——每头维度按 $1/H$ 缩小，总参数量不变。**但参数量相同不等于表达相同**：多头改变的是**归纳偏置**（并行多组注意力 vs 一组注意力），而不是参数预算。
:::

::: proof 推导 · 为什么总参数与头数无关，以及多头的边界
**(1) 参数计数。** 每头三个投影 $W_j^Q,W_j^K,W_j^V\in\mathbb R^{d\times d_h}$，单头参数量 $3d\,d_h$；$H$ 个头合计

$$H\cdot 3d\,d_h=3d\,(H d_h)=3d\cdot d=3d^2 .$$

输出投影 $W^O\in\mathbb R^{d\times d}$ 提供 $d^2$。总参数 $4d^2$（加偏置 $4d$）。因为 $Hd_h=d$ 是硬约束，**$H$ 只影响「怎么切这块参数」，不影响总量**。

**(2) 与单头的关系。** 在一种特殊情形下二者等价：若所有头的 $\boldsymbol V_j$ 相同、且 $W^O$ 取特定的块结构，多头退化为单头。完整的多头表达力**严格更强**——因为每组 softmax 可以给出不同的权重模式，而这些模式在单头里被强制平均。这不是「多头一定会更好」的证明：**更强的表达力也可能更容易过拟合**，而且 $d_h$ 太小会让每个头的内积空间变小、相似度估计变差。

**(3) 头数的工程边界。** 由 $d_h=d/H$，$H$ 增大 ⇒ $d_h$ 减小 ⇒ 每个头能表达的关系变简单，且 reshape/转置带来的访存开销上升。反过来 $H=1$ 时退化为单头。因此头数的选择是**经验性的超参**（本书立场：在 $d$ 固定的前提下，$H$ 落在 $[8,64]$ 这个区间是常见实践，具体取值依模型与硬件而变；不存在「头越多越好」的结论）。$\blacksquare$
:::

::: intuition 为什么「多头赢了单头」这句话必须带条件
把上面的结论翻译成实验语言：比较「$H=16$、$d_h=64$」与「$H=1$、$d_h=1024$」时，两者的**参数量完全相同**，差别只在归纳偏置。多头之所以在实践中常胜，是因为（a）不同子空间可以各自锐化自己的相似度、不被平均掉；（b）多个头可以并行发展出不同功能（局部、指代、复制等）。但当你看到「多头显著更好」的论文结论时，务必确认它**控制了什么**：同参数量？同计算量？同训练步数？如果不控制参数量，单头只是「参数更少」而已，那就不足以说明多头结构的优越性。
:::

## 2.5.2 前馈层：位置内的两层 MLP {#sec-2.5.2}

::: def 定义 2.5.2 · 位置前馈层与中间维扩张 {#def-2.5.2}
对每个位置**独立**（共享同一套参数）应用同一个两层 MLP：

$$\operatorname{FFN}(\boldsymbol z)=W_2\,\phi(W_1\boldsymbol z+\boldsymbol b_1)+\boldsymbol b_2,\qquad
W_1\in\mathbb R^{d_{\text{ff}}\times d},\quad W_2\in\mathbb R^{d\times d_{\text{ff}}}.$$

经典设定 $d_{\text{ff}}=4d$；现代实现常用**门控变体**（GLU 家族）把两个线性层并列：

$$\operatorname{SwiGLU}(\boldsymbol z)=\bigl(\operatorname{Swish}(\boldsymbol zW_1)\odot \boldsymbol zW_3\bigr)W_2,$$

此时三块矩阵的总参数按 $3\,d\,d_{\text{ff}}$ 计，为保持与 $4d$ 经典版的参数可比，常见做法是把 $d_{\text{ff}}$ 取为约 $\tfrac{8}{3}d$（工程惯例，源自 GLU 变体的宽度缩放实验）。
:::

::: intuition 横与纵：注意力混合位置，FFN 变换特征
注意力做的是**跨位置**的事：把别处的内容取过来。但「取过来」之后还需要**就地加工**——判断特征组合、做非线性映射、把信息压回 $d$ 维。FFN 就是干这个的：逐位置、同一套参数、两层 MLP。**两者缺一不可**：只有注意力，模型只能做凸组合（一层注意力的输出必然落在各位置 $\boldsymbol V$ 之间），表达力受限；只有 FFN，位置之间互不相通，序列结构无从利用。

再记住一个参数量事实：在经典配置 $d_{\text{ff}}=4d$ 下，FFN 的参数是 $8d^2$，注意力是 $4d^2$——**FFN 占了块内参数的三分之二**。这解释了为什么 MoE（[2.7](sec27.md)）把专家结构放在 FFN 上：那里才是有参数可换的地方。
:::

## 2.5.3 残差与归一化：Post-LN、Pre-LN 与 RMSNorm {#sec-2.5.3}

::: def 定义 2.5.3 · Post-LN 块与 Pre-LN 块 {#def-2.5.3}
设子层为 $\operatorname{Sub}(\cdot,\cdot)$（自注意力或 FFN），则两种布局为

$$\textbf{Post-LN：}\quad \boldsymbol Y=\operatorname{LN}\bigl(\boldsymbol X+\operatorname{Sub}(\boldsymbol X)\bigr),$$

$$\textbf{Pre-LN：}\quad \boldsymbol Y=\boldsymbol X+\operatorname{Sub}\bigl(\operatorname{LN}(\boldsymbol X)\bigr).$$

层归一化按**最后一维（特征维）**做标准化：

$$\operatorname{LN}(\boldsymbol x)=\boldsymbol\gamma\odot\frac{\boldsymbol x-\mu}{\sqrt{\sigma^2+\epsilon}}+\boldsymbol\beta,\qquad
\operatorname{RMSNorm}(\boldsymbol x)=\boldsymbol\gamma\odot\frac{\boldsymbol x}{\sqrt{\operatorname{mean}(\boldsymbol x^2)+\epsilon}},$$

其中 $\mu,\sigma^2$ 是**该位置**在特征维上的均值与方差（与批大小无关——这一点与 BatchNorm 的关键区别见 [1.7.4](../lec01/sec17.md#sec-1.7.4)）。RMSNorm 去掉去均值与偏置、只做尺度归一化，计算更省。
:::

::: intuition 残差是「梯度的高速公路」，LN 是「尺度的稳定器」
**残差**的作用第 1 讲已经算过：$\boldsymbol Y=\boldsymbol X+\operatorname{Sub}(\cdot)$ 让反向传播中多出一条恒等路径 $\partial\boldsymbol Y/\partial\boldsymbol X=\boldsymbol I+\cdots$，于是梯度不必只穿过子层那条连乘链，深堆才成为可能。**LayerNorm** 则负责把每个位置的激活尺度拉回可控范围，使学习率、初始化与深度解耦。**Pre-LN 的额外好处**是一眼看出的：主干上是纯粹的加法（$\boldsymbol X\to\boldsymbol X+\operatorname{Sub}(\cdot)$），尺度随深度以温和方式累积；而 Post-LN 在每个子层之后都做一次归一化，反向时必须穿过这些归一化，层数越深数值行为越挑剔。
:::

::: thm 定理 2.5.2 · Pre-LN 与 Post-LN 的梯度尺度差异 {#thm-2.5.2}
**论文报告的结论**（Xiong et al., 2020，arXiv:2002.04745）：在初始化时，

- **Post-LN**：靠近输出层的参数梯度尺度较大（论文的分析给出形如 $d\ln d$ 的量级项），因此需要**学习率预热**（warmup）才能稳定训练；
- **Pre-LN**：梯度尺度与网络深度基本无关，去掉预热也能正常训练。

**代价与条件**：Pre-LN 的主干是恒等累加，前向输出的尺度会随深度增长，因此它的**最后一层表示需要额外归一化**才能接输出头（这也是现代实现里都带一层 final norm 的原因）。此外，该结论是「训练稳定性」层面的，不是「下游效果一定更好」的承诺——架构选择仍取决于数据与规模。
:::

::: proof 一个可跟读的示意性论证（为什么 Post-LN 的尺度更敏感）
不看完整论文分析，只做一个标量级的估算，就能理解两条路的差别。

**(1) Post-LN 的链式因子。** Post-LN 里子层输出先加残差再归一化。设某层的归一化后输出为 $\boldsymbol y=\operatorname{LN}(\boldsymbol u)$，则反向经过它时，梯度要乘上 $\partial \boldsymbol y/\partial \boldsymbol u$——这个雅可比含 $1/\sqrt{\sigma^2+\epsilon}$ 与「去均值 + 去投影」两项。当层数变多时，**每一层的输出尺度都被前一层归一化重新缩放**，于是靠近输出的子层接收到的有效尺度与深度相关；参数梯度里因此累积出随深度增长的因子，必须用 warmup 把最初几步的步长压小。

**(2) Pre-LN 的主干是加法。** Pre-LN 里 $\boldsymbol X_{l+1}=\boldsymbol X_l+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X_l))$，归一化被放在**子层内部**，主干上没有归一化。设 $\lVert\operatorname{Sub}(\operatorname{LN}(\boldsymbol X_l))\rVert=\mathcal O(1)$（这是 LN 的直接后果），则 $\lVert\boldsymbol X_L\rVert=\mathcal O(\sqrt L)$（$L$ 项近似无关的向量叠加，均方增长）。反向时主干上的恒等路径给出与深度无关的传输，子层的贡献被 LN 的尺度锁住——所以梯度尺度对深度不敏感。

**(3) 一个必须说清的推论。** 上面对 Pre-LN 的估算也解释了它的「副作用」：$\lVert\boldsymbol X_L\rVert$ 随 $\sqrt L$ 增长，因此**越深的模型，最后一层的激活范数越大**，必须额外加一层归一化才能接输出头，否则 logits 尺度会随深度漂移。这条现象在开源实现里可以直接观察到（打印各层激活范数即可）。$\blacksquare$
:::

::: intuition Post-LN 与 Pre-LN 的取舍：稳定性换什么
把两条路并排看：**Post-LN** 表示更「规矩」（每层后都重新归一化，尺度不漂），但训练更挑学习率与预热；**Pre-LN** 训练更稳、允许更大的学习率与更少的调参，代价是主干尺度累积、需要收尾归一化，并且有研究指出在很深的设置下 Pre-LN 的有效深度利用不如更精细的布局（这类细节属于活跃研究方向，本书不展开）。实践中，2020 年以后的开源大模型几乎一律采用 Pre-LN（常配 RMSNorm）——这是**工程惯例**，不是理论最优的证明。
:::

## 2.5.4 三种布局：编码器 / 解码器 / 编解码器 {#sec-2.5.4}

::: method 三种 block 的组成与注意力方向 {#method-2.5.1}
| 结构 | 自注意力 | 是否含交叉注意力 | 交叉注意力的 Q / K,V 来源 | 典型用途 |
|:--|:--|:--|:--|:--|
| **编码器块** | 双向（无掩码，每个位置看全序列） | 否 | — | 理解整段输入：分类、句向量、检索嵌入 |
| **解码器块** | 因果掩码（只能看 $\le t$） | 否（GPT 类） | — | 自回归生成：语言模型、代码补全 |
| **编解码器块** | 因果掩码（目标侧） | **是** | Q 来自**解码器**，K / V 来自**编码器输出** | 序列到序列：翻译、摘要、语音转写 |

三个要点：
1. **掩码决定因果性**：同一套注意力代码，加上因果掩码就是解码器，不加就是编码器；
2. **交叉注意力的方向**：查询来自「正在生成的一侧」（要知道自己缺什么），键值来自「被读取的一侧」（提供内容）。写反了模型仍能训练，但含义完全变了；
3. **decoder-only（仅解码器）成为默认**：一方面它天然适配「把任务写成续写」的统一接口（指令、对话、代码），另一方面它便于用同一套因果实现做 KV cache 与流式推理。这是**工程与生态层面的收敛**，不代表「编码器—解码器结构没用」——在语音、翻译等输入输出都很长的场景里，编解码结构仍然常见。
:::

## 2.5.5 前向形状表与参数量估算 {#sec-2.5.5}

取 $B=8$、$T=512$、$d=768$、$H=12$（故 $d_h=64$）、$d_{\text{ff}}=4d=3072$，逐行写出一次前向的张量形状与参数量。

::: method 形状表 · 一次前向的逐层形状 {#method-2.5.2}
| 层 / 运算 | 输出形状 | 参数量 | 说明 |
|:--|:--|:--|:--|
| 词嵌入 $\boldsymbol X$ | $8\times512\times768$ | $V\times768$ | $V$ 为词表大小（权重可与输出层绑定） |
| $W^Q,W^K,W^V$ 投影 | $8\times12\times512\times64$ | $3\times768^2$ | 投影到 $H$ 个头后 reshape 成 4 维 |
| 分数 $\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_h}$ | $8\times12\times512\times512$ | 0 | **平方项**：$B\cdot H\cdot T^2\approx 2.5\times10^7$ 个数 |
| softmax（按键维） | $8\times12\times512\times512$ | 0 | 每行和为 1；掩码在 softmax 前加 |
| 单头输出 $\boldsymbol P\boldsymbol V_j$ | $8\times12\times512\times64$ | 0 | 加权求和得到 |
| 拼接 + $W^O$ | $8\times512\times768$ | $768^2$ | 多头结果线性混合 |
| 残差 + 归一化 | $8\times512\times768$ | $2\times768$ | LN 的 $\gamma,\beta$（RMSNorm 只要 $\gamma$） |
| FFN：$W_1$ | $8\times512\times3072$ | $4\times768^2$ | 扩张 4 倍 |
| FFN：$W_2$ | $8\times512\times768$ | $4\times768^2$ | 压回 $d$ |
| 残差 + 归一化 | $8\times512\times768$ | $2\times768$ | — |
| 输出层（解码器） | $8\times512\times V$ | $V\times768$ | logits；$V=32000$ 时约 $2.46\times10^7$ 参数 |

**读表要点**：只有一行是「平方项」的产地（分数矩阵），它是 $B\times H\times T\times T$——**与 $d$ 无关**；其余各行的规模都由 $B\cdot T\cdot d$ 决定。把这两类分开，长上下文与宽模型的开销来源就一目了然（[2.6.6](sec26.md#sec-2.6.6) 会把它们算成显存与 FLOPs 的具体数字）。
:::

::: ex 例 2.5.1 · 估算一个 12 层 768 维编码器的参数量 {#ex-2.5.1}
用上面的配置计算：
(1) 单个编码器块的参数量，并给出「注意力 / FFN / 归一化」三者的占比；
(2) 12 层堆叠后的总参数量（不含词嵌入与输出层）；
(3) 若把词表 $V=32000$ 的嵌入与输出层也算进来（权重绑定只算一次），总量是多少？

::: proof 解
**(1) 单块参数量**（忽略偏置或单独列出）：

| 部件 | 算式 | 参数量 |
|:--|:--|:--|
| 多头注意力（$W^Q,W^K,W^V,W^O$） | $4\times 768^2$ | $2{,}359{,}296$ |
| 偏置（4 个 $d$） | $4\times768$ | $3{,}072$ |
| FFN（$W_1,W_2$） | $2\times 4\times 768^2=8\times768^2$ | $4{,}718{,}592$ |
| FFN 偏置 | $4d+d$ | $3{,}840$ |
| 两个 LayerNorm | $2\times 2\times 768$ | $3{,}072$ |
| **合计** | — | $\approx 7{,}087{,}872$ |

占比：注意力 $2{,}359{,}296/7{,}087{,}872\approx 33.3\%$；FFN $4{,}718{,}592/7{,}087{,}872\approx 66.6\%$；归一化约 $0.04\%$。**这就是「FFN 占三分之二参数」的来历**——它与 [2.7](sec27.md) 里 MoE 只替换 FFN 的做法直接相关。

**(2) 12 层**：$12\times 7{,}087{,}872\approx 8.51\times10^{7}$，即约 **85M** 参数（$768^2=589{,}824$ 可用来快速心算：每层 $12\times589{,}824=7{,}077{,}888$，再乘 12）。

**(3) 词嵌入与输出层**：$V\times d=32000\times768=2.458\times10^{7}$，权重绑定后只算一次，再含最后一层 LN（$2d$）：总量 $\approx 8.51\times10^{7}+2.46\times10^{7}\approx 1.10\times10^{8}$，即约 **110M** 参数。

**三个可以记住的比例**：① 每层参数 $\approx 12d^2$（$4d^2$ 注意力 + $8d^2$ FFN）；② FFN 占 $2/3$；③ 嵌入与输出层在 $V\approx32\text{k}$、$d=768$ 时约占总量 $20\%$——**词表大时这一项不可忽略**，这也是小模型常常共享嵌入与输出权重的动机。$\blacksquare$
:::
:::

## 2.5.6 训练与推理：一次前向 vs 逐 token {#sec-2.5.6}

::: def 定义 2.5.4 · 自回归解码与 KV cache {#def-2.5.4}
**训练（teacher forcing）**：给定整段 token $\boldsymbol x_{1:T}$，一次前向并行算出所有位置的 logits，损失为

$$\mathcal L=-\sum_{t=1}^{T}\log p_\theta\bigl(x_{t+1}\mid x_{\le t}\bigr),$$

其中「$x_{\le t}$」由因果掩码在**同一次前向**里精确实现（[2.4.5](sec24.md#sec-2.4.5)）。

**推理（自回归）**：第 $t$ 步没有「未来的答案」，只能采样出一个 token、把它接回输入、再算下一步。为免重复计算，把历史位置的键值存下来：

$$\text{KV cache}:\quad \boldsymbol K_{1:t},\boldsymbol V_{1:t}\in\mathbb R^{t\times d_h}\ \text{（每头一份）},$$

每一步只需为新 token 计算 $\boldsymbol Q_t$，再与缓存的 $\boldsymbol K_{1:t}$ 做注意力：增量计算量由 $\mathcal O(t^2d)$ 降为 $\mathcal O(t\,d)$。
:::

::: intuition 为什么「训练并行、推理串行」不是工程缺陷
训练时我们知道正确答案，于是可以用**因果掩码**在同一次矩阵乘里模拟出「每个位置只看自己左边」的效果——$T$ 个位置同时算完，损失一次到位。推理时没有正确答案，第 $t+1$ 个 token 必须**先被生成**才能作为第 $t+2$ 步的输入，因此天然串行。这不是实现偷懒，而是自回归目标的定义：$p(x_{t+1}\mid x_{\le t})$ 的条件里包含模型**自己**的输出。三条常见推论——① 长上下文推理的瓶颈往往在**显存带宽**（每一步都要读整个 KV cache）而非算力；② batch 里不同序列长度不齐会造成「气泡」，因此系统层面要做连续批处理（continuous batching）；③ KV cache 的显存随上下文线性增长，必须靠 GQA、量化、滑窗等办法压缩（[2.6.8](sec26.md)）。
:::

::: method KV cache 的显存账 {#method-2.5.3}
每个 token 的 KV cache（FP16，每元素 2 字节）为

$$\underbrace{2}_{K\text{ 与 }V}\times n_{kv}\times d_h\times 2\ \text{bytes}=4\,n_{kv}d_h\ \text{字节},$$

整段上下文的缓存为

$$2\cdot L\cdot B\cdot T\cdot n_{kv}\cdot d_h\cdot \text{bytes},$$

其中 $L$ 是层数、$B$ 批大小、$T$ 上下文长度、$n_{kv}$ 是**键值头数**。

**例算**（$L=32$、$d=4096$、$H=32$、$d_h=128$、$B=1$、$T=8192$、FP16）：

| 配置 | $n_{kv}$ | KV cache 大小 | 算式 |
|:--|:--|:--|:--|
| MHA（每头独立） | $32$ | **4.0 GiB** | $2\times32\times1\times8192\times32\times128\times2$ 字节 |
| GQA（每 4 个查询头共享 1 组） | $8$ | **1.0 GiB** | 同上，$n_{kv}$ 换成 8 |
| MQA（全部共享） | $1$ | $0.125$ GiB | $n_{kv}=1$ |

结论有三条：① KV cache 与 $T$ **线性**增长，与 $B$ 线性增长——批推理时它是显存的主要消费者；② 把 $n_{kv}$ 从 $H$ 降到 $H/g$ 可把缓存降到 $1/g$，**这是 GQA / MQA 的全部动机**（质量损失通常很小，见 [2.4.6](sec24.md#sec-2.4.6)）；③ 与「权重显存」对比一下：$d=4096$、$L=32$ 的模型参数量约 $12Ld^2\approx6.4\times10^{9}$（6.4B），FP16 权重约 12.8 GB——**在 $T=8192$、batch 稍大时，KV cache 会迅速逼近甚至超过权重显存**。
:::

## 2.5.7 代码：从零搭一个 Pre-LN 块并验证增量解码 {#sec-2.5.7}

```python
import torch, torch.nn as nn, torch.nn.functional as F, math

class RMSNorm(nn.Module):
    def __init__(self, d, eps=1e-6):
        super().__init__(); self.g = nn.Parameter(torch.ones(d)); self.eps = eps
    def forward(self, x):
        # 只按特征维做尺度归一化（无去均值、无偏置）
        return self.g * x * torch.rsqrt(x.pow(2).mean(-1, keepdim=True) + self.eps)

class MHA(nn.Module):
    """多头自注意力：同时支持整段前向与单步增量（KV cache）"""
    def __init__(self, d, H):
        super().__init__()
        assert d % H == 0
        self.H, self.d_h = H, d // H
        self.Wq = nn.Linear(d, d, bias=False)
        self.Wk = nn.Linear(d, d, bias=False)
        self.Wv = nn.Linear(d, d, bias=False)
        self.Wo = nn.Linear(d, d, bias=False)
    def _split(self, x):                     # (B,T,d) -> (B,H,T,d_h)
        B, T, _ = x.shape
        return x.view(B, T, self.H, self.d_h).transpose(1, 2)
    def forward(self, x, cache=None, causal=True):
        B, T, _ = x.shape
        q = self._split(self.Wq(x))          # (B,H,T,d_h)
        k, v = self._split(self.Wk(x)), self._split(self.Wv(x))
        if cache is not None:                # 增量解码：把历史的 K,V 拼到当前步前面
            k = torch.cat([cache[0], k], dim=2)
            v = torch.cat([cache[1], v], dim=2)
        new_cache = (k, v)                   # 本步结束后缓存更新
        S = q @ k.transpose(-2, -1) / math.sqrt(self.d_h)
        if causal and cache is None:         # 整段前向时才需要掩码；增量解码天然只有 1 个查询
            Tq, Tk = S.shape[-2], S.shape[-1]
            keep = torch.ones(Tq, Tk, dtype=torch.bool, device=S.device).tril()
            S = S.masked_fill(~keep, float("-inf"))
        P = S.softmax(-1)
        out = (P @ v).transpose(1, 2).reshape(B, T, self.H * self.d_h)
        return self.Wo(out), new_cache

class PreLNBlock(nn.Module):
    """Pre-LN：主干是恒等加法，归一化放在子层内部"""
    def __init__(self, d, H, d_ff=None):
        super().__init__()
        d_ff = d_ff or 4 * d
        self.n1, self.n2 = RMSNorm(d), RMSNorm(d)
        self.attn = MHA(d, H)
        self.fc1, self.fc2 = nn.Linear(d, d_ff), nn.Linear(d_ff, d)
    def forward(self, x, cache=None):
        y, cache = self.attn(self.n1(x), cache=cache)      # 注意力读「归一化后」的输入
        x = x + y                                          # 残差：主干上是纯加法
        x = x + self.fc2(F.silu(self.fc1(self.n2(x))))      # FFN 同理
        return x, cache

# ① 整段前向：一次算完全部位置（训练用）
torch.manual_seed(0)
B, T, d, H = 2, 16, 64, 8
blk = PreLNBlock(d, H).eval()
x = torch.randn(B, T, d)
full, _ = blk(x)

# ② 增量解码：逐 token 前向 + KV cache，输出应与整段前向逐位置一致
cache, outs = None, []
for t in range(T):
    o, cache = blk(x[:, t:t+1], cache=cache)     # 每次只喂一个位置
    outs.append(o)
inc = torch.cat(outs, dim=1)
assert torch.allclose(full, inc, atol=1e-5), "增量解码与整段前向不一致"
print("KV cache 一致性检查通过；缓存形状：", tuple(cache[0].shape), tuple(cache[1].shape))

# ③ 观察 Pre-LN 的尺度累积：激活范数随深度温和增长
xs = x.clone()
for i, layer in enumerate([PreLNBlock(d, H).eval() for _ in range(12)]):
    xs, _ = layer(xs)
    if i in (0, 3, 7, 11):
        print(f"第 {i+1:2d} 层后平均激活范数 = {xs.norm(dim=-1).mean().item():.3f}")
```

三段代码对应本节的三条主线：**① 整段前向**（训练时一次算完，靠因果掩码保证不偷看未来）；**② 增量解码**（推理时逐 token、KV cache 拼接；断言保证两者数值一致——这是验证实现正确性的强力手段）；**③ 尺度观察**（Pre-LN 主干尺度随深度累积，因此收尾必须有一层归一化，见 [定理 2.5.2](#thm-2.5.2)）。

::: errata 本节五个常见误解
1. **「忘记因果掩码」**：这是最隐蔽也最致命的 bug。缺掩码时训练损失会降得很漂亮（每个位置都能看到答案），但推理时没有未来可看，质量立刻崩坏。**看到「训练完美、生成崩坏」，先查掩码。**
2. **「把 LN 的位置写反还说自己是 Pre-LN」**：Pre-LN 是 $\boldsymbol X+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X))$，归一化**在子层内部、加法之前**；Post-LN 是 $\operatorname{LN}(\boldsymbol X+\operatorname{Sub}(\boldsymbol X))$。写反会让深层训练明显变差，而且症状（需要 warmup）与论文描述的一致，容易被误判为「学习率没调好」。
3. **「前馈层只是装饰」**：FFN 占块内约 $2/3$ 的参数（[例 2.5.1](#ex-2.5.1)），且承担位置内的非线性变换；把它删掉模型会退化成「多层加权平均」结构。
4. **「注意力的参数就是全部参数」**：注意力只占 $1/3$；在小模型 + 大词表场景里，**词嵌入与输出层**还能占两成以上。
5. **「训练能并行，推理也能并行」**：推理必须逐 token（自回归的定义），能并行的只有「同一 batch 内不同序列」与「同一序列的不同采样」。把训练并行度当作推理吞吐的预期，会严重高估上线能力。
:::

::: method 即时自测 · 2.5 {#method-2.5.4}
**Q1** 写出多头自注意力的公式，并说明：为什么头数 $H$ 不改变参数量？$H$ 变大有什么代价？

**Q2** 一个 $d=512$ 的 Transformer 块（经典 FFN），注意力与 FFN 各占多少参数？说出「FFN 占三分之二」的来处。

**Q3** Pre-LN 与 Post-LN 的公式各是什么？为什么前者更容易训深？

**Q4** $L=24$、$d=2048$、$H=16$、$B=1$、$T=4096$、FP16：用 MHA（$n_{kv}=16$）与 GQA（$n_{kv}=4$）时 KV cache 各多大（$d_h=d/H=128$）？

::: sol 参考要点
**Q1** $\operatorname{head}_j=\operatorname{Attention}(\boldsymbol XW_j^Q,\boldsymbol XW_j^K,\boldsymbol XW_j^V)$，$\operatorname{MHA}=[\operatorname{head}_1;\dots;\operatorname{head}_H]W^O$。因为 $d_h=d/H$，每头三个投影共 $3d d_h$，$H$ 头合计 $3d^2$，加 $W^O$ 的 $d^2$。$H$ 变大的代价：每个头的 $d_h$ 变小（内积空间维度下降、单个头的表达能力变弱），reshape/转置等访存开销上升。

**Q2** 注意力 $4d^2$、FFN $8d^2$（$d\to4d\to d$），故 FFN 占 $8/12=2/3$。这就是 MoE 把专家放在 FFN 的原因：那里才有足够多的参数可以做稀疏替换。

**Q3** Post-LN：$\boldsymbol Y=\operatorname{LN}(\boldsymbol X+\operatorname{Sub}(\boldsymbol X))$；Pre-LN：$\boldsymbol Y=\boldsymbol X+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X))$。Pre-LN 把归一化放进子层，主干成为恒等加法通路，梯度尺度与深度基本无关（论文报告：Post-LN 需 warmup、Pre-LN 不需要）；代价是主干激活尺度随深度累积，需要收尾归一化。

**Q4** 公式 $2LB T n_{kv}d_h\times2$ 字节。MHA：$2\times24\times1\times4096\times16\times128\times2=2\times24\times4096\times16\times128\times2$；先算 $4096\times16\times128=8{,}388{,}608$，乘 24 得 $2.013\times10^{8}$，乘 2（K 与 V）得 $4.027\times10^{8}$，再乘 2 字节 $=8.05\times10^{8}$ 字节 ≈ **0.75 GiB**。GQA（$n_{kv}=4$）：按比例降到 $1/4$，约 **0.19 GiB**。注意这两者都比权重显存小得多——**KV cache 是随 $T$ 与 $B$ 增长的项**，长上下文或大 batch 时才会成为瓶颈。
:::
:::

::: note[skip] 延伸阅读
- Vaswani et al., *Attention Is All You Need*（2017, arXiv:1706.03762）——Transformer 原始论文：多头注意力、缩放点积注意力、位置编码与三种布局。
- He et al., *Deep Residual Learning for Image Recognition*（2015, arXiv:1512.03385）——残差连接的原始动机，第 2.5.3 节「梯度高速公路」直觉的来源。
- Ba, Kiros & Hinton, *Layer Normalization*（2016, arXiv:1607.06450）——LayerNorm 的定义与动机（与 BatchNorm 的维度差别）。
- Xiong et al., *On Layer Normalization in the Transformer Architecture*（2020, arXiv:2002.04745）——Pre-LN / Post-LN 的梯度尺度分析与 warmup 的必要性（[定理 2.5.2](#thm-2.5.2) 的依据）。
- Zhang & Sennrich, *Root Mean Square Layer Normalization*（2019, arXiv:1910.07467）——RMSNorm 的原始论文。
- Shazeer, *GLU Variants Improve Transformer*（2020, arXiv:2002.05202）——SwiGLU 与中间维缩放（$\tfrac{8}{3}d$）的来源。
- Ainslie et al., *GQA*（2023, arXiv:2305.13245）与 Shazeer, *Fast Transformer Decoding*（2019, arXiv:1911.02150）——KV 头压缩的两种做法与动机。
:::

**本节小结**：Transformer 块 = **多头注意力（跨位置混合，占 $1/3$ 参数）+ 位置前馈层（位置内变换，占 $2/3$ 参数）+ 残差与 Pre-LN（让几十层可训）**。多头不改变参数量、只改变归纳偏置；Pre-LN 让梯度尺度与深度解耦，代价是主干尺度累积、需要收尾归一化。训练一次前向并行算完全部位置（因果掩码保证不偷看未来），推理必须逐 token 并用 KV cache 复用历史键值；KV cache 随 $B\cdot T\cdot n_{kv}$ 线性增长，是长上下文与大批量推理的主要显存开销。下一节补上最后一块拼图：**位置信息**，并系统处理长序列的三笔账。
