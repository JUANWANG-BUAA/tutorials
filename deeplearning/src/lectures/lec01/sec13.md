# 1.3 激活函数：非线性从哪来

[1.2 节](sec12.md)反复用到一个事实：网络的表达能力全部来自 $\phi$。但「提供非线性」只是激活函数的**必要条件**，不是它全部的工作。在真实训练里，激活函数还要同时满足三件事：导数在多数区域**不接近零**（否则深层连乘后梯度消失）、计算便宜（每个元素每个 batch 都要算一次）、数值范围可控（不放大到溢出、也不塌缩到零）。

这三条要求之间有冲突。Sigmoid 的导数上限只有 $0.25$；tanh 更好地做到零均值但依然两端饱和；ReLU 在正半区导数恒为 $1$，一举解决饱和问题，却在负半区把梯度直接置零。现代大模型用的又是另一类东西——带门控的 GLU 家族。这一节按「饱和的定量分析 → ReLU 与它的缺陷 → 平滑化 → 门控」的顺序把这些选择讲清楚，最后给出一张可以照着查的对比表。


{{#include ../../assets/figures/dl-activations.md}}

## 1.3.1 为什么非线性是唯一的开关

::: def 定义 1.3.1 · 激活函数（activation function） {#def-1.3.1}
**激活函数**是逐元素作用于预激活 $\boldsymbol z$ 的标量函数 $\phi:\mathbb R\to\mathbb R$，即 $(\boldsymbol A)_{bj}=\phi\bigl((\boldsymbol Z)_{bj}\bigr)$。按它在网络中的位置分两类：

- **隐藏层激活**：作用在中间层，要求**非线性**且在训练中**梯度可传**；
- **输出层激活**：把网络输出映射到任务需要的取值域（分类用 softmax、二分类用 Sigmoid、回归通常不加）。

按导数结构分，常见激活可归为三族：**饱和型**（Sigmoid、tanh，两端导数趋零）、**分段线性型**（ReLU 及 LeakyReLU、ELU 等变体）、**平滑非饱和型**（GELU、SiLU），另有以乘积形式构造的**门控型**（GLU 家族，见 [1.3.5](#sec-1.3.5)）。
:::

::: intuition 激活函数只做一件事：决定「每个神经元在什么区域里活着」
把激活函数想成给每个单元装了一个**音量旋钮**：$\phi'(z)$ 就是当前音量。旋钮太小（$z$ 落在饱和区或 ReLU 的负半区），这个单元对损失的变化几乎无反应，梯度也传不上去；旋钮是 $1$，梯度原样通过。于是「选激活」这个问题的工程版表述是：**希望尽可能多的单元在尽可能长的时间里保持一个接近 $1$ 的旋钮**，同时不要因为旋钮太大而让信号爆炸。
:::

## 1.3.2 对比表：从 Sigmoid 到 SwiGLU

| 激活 | 定义 | 值域 | 导数（关键区间） | 主要优点 | 主要代价 |
|:--|:--|:--|:--|:--|:--|
| **Sigmoid** $\sigma$ | $\dfrac{1}{1+e^{-z}}$ | $(0,1)$ | $\sigma'=\sigma(1-\sigma)\le 0.25$ | 输出可解释为概率；光滑 | 两端饱和→梯度消失；输出非零均值；含指数运算 |
| **tanh** | $\dfrac{e^{z}-e^{-z}}{e^{z}+e^{-z}}$ | $(-1,1)$ | $\tanh'=1-\tanh^2\le 1$ | 零均值，比 Sigmoid 好传梯度 | 仍两端饱和（$|z|\gt3$ 后导数降至 $0.01$ 量级） |
| **ReLU** | $\max(0,z)$ | $[0,\infty)$ | $1$（$z\gt0$）／$0$（$z\lt0$） | 正区不饱和、计算极便宜、激活稀疏 | 负区梯度为 $0$（可死亡）；输出非零均值 |
| **LeakyReLU** | $\max(\alpha z,z)$，$\alpha$ 常取 $0.01$ | $(-\infty,\infty)$ | $1$／$\alpha$ | 负区保留小梯度，缓解死亡 | 多一个超参；收益不稳定 |
| **ELU** | $z$（$z\gt0$）／$\alpha(e^{z}-1)$（$z\le0$） | $(-\alpha,\infty)$ | $1$／$\phi(z)+\alpha$ | 负区饱和到 $-\alpha$，输出接近零均值 | 含指数运算，稍贵 |
| **GELU** | $z\,\Phi(z)$，$\Phi$ 为标准正态 CDF；常用近似 $0.5z\bigl(1+\tanh[\sqrt{2/\pi}(z+0.044715z^3)]\bigr)$ | $\approx(-0.17,\infty)$ | 平滑、非单调（在 $z\approx-0.75$ 附近有极小值） | 平滑、可导、经验上优于 ReLU（在若干任务上） | 比 ReLU 贵；理论优势与任务强相关 |
| **SiLU / Swish** | $z\,\sigma(z)$ | $\approx(-0.28,\infty)$ | $\sigma(z)+z\sigma(z)(1-\sigma(z))$ | 平滑、自门控形式、无饱和上界 | 含指数运算 |
| **GLU / SwiGLU / GeGLU** | $\mathrm{GLU}(\boldsymbol z)=(A\odot\sigma(B))\boldsymbol W$，$A,B$ 是同一输入的两个线性投影 | 视门控而定 | 门控项决定局部增益 | 表达力强，现代 LLM 的默认前馈层选择 | 参数量与计算量比单线性层**更多**（需宽幅缩放，见下） |
| **Softmax** | $\mathrm{softmax}(z)_c=\dfrac{e^{z_c}}{\sum_{c'}e^{z_{c'}}}$ | 单纯形 | $\partial p_c/\partial z_k=p_c(\delta_{ck}-p_k)$ | 把 logits 变成分布 | 只用于输出层（或权重归一化），不是隐藏层激活 |

::: intuition 三类激活的取舍在本质上只有一条分界线
**边界是「导数会不会在某个区间塌到零」**。饱和型（Sigmoid/tanh）在两端塌，于是深层网络的梯度链断了；分段线型（ReLU）在负半区塌，于是部分单元死掉；平滑型（GELU/SiLU）通过「负半区导数很小但不恒为零」在两者之间取折中；门控型（GLU）干脆把「增益」交给另一个学出来的线性投影决定，让网络自己选择每个位置该放大还是该关闭。**条条大路都在回答同一个问题：梯度怎么活着穿过很多层。**
:::

## 1.3.3 饱和与梯度消失：一次定量计算

::: thm 定理 1.3.1 · 全 Sigmoid 网络的梯度衰减 {#thm-1.3.1}
设一个 $L$ 层网络全部使用 Sigmoid 激活，忽略权重的缩放效应，则反向传播中跨过 $L$ 层的梯度至少被乘上因子

$$\prod_{l=1}^{L}\max_z\sigma'(z)=\left(\frac14\right)^{L}.$$

即层数每增加一层，梯度量级至少再乘 $1/4$：$L=10$ 时上界为 $0.25^{10}\approx 9.5\times10^{-7}$，$L=20$ 时约为 $9.1\times10^{-13}$。
:::

::: proof 推导（链式法则连乘）
一层的输入输出关系为 $\boldsymbol a^{(l)}=\sigma(\boldsymbol z^{(l)})$、$\boldsymbol z^{(l)}=\boldsymbol a^{(l-1)}W^{(l)}+\boldsymbol b^{(l)}$。损失对第 $1$ 层预激活的梯度由链式法则写成连乘：

$$\frac{\partial\mathcal L}{\partial\boldsymbol z^{(1)}}=\frac{\partial\mathcal L}{\partial\boldsymbol z^{(L)}}\prod_{l=2}^{L}\Bigl[\frac{\partial\boldsymbol z^{(l)}}{\partial\boldsymbol z^{(l-1)}}\Bigr],\qquad \frac{\partial\boldsymbol z^{(l)}}{\partial\boldsymbol z^{(l-1)}}=\operatorname{diag}\bigl(\sigma'(\boldsymbol z^{(l-1)})\bigr)W^{(l)\mathrm T}.$$

关键在**对角矩阵里的 $\sigma'$**：$\sigma'(t)=\sigma(t)(1-\sigma(t))\le\tfrac14$（在 $t=0$ 取等号），且当 $|t|\gt5$ 时 $\sigma'(t)\lt0.007$。把它代回连乘，并注意每一层的对角因子在**每个元素**上都不超过 $\tfrac14$，即得

$$\Bigl\lVert\prod_{l=2}^{L}\operatorname{diag}(\cdot)\Bigr\rVert\le\prod_{l=2}^{L}\tfrac14\ \text{（在权重尺度不放大信号的前提下）}.$$

因此梯度随深度呈几何衰减；权重的谱范数若大于 $4$ 可以暂时抵消，但那会导致逐层放大，训练中表现为震荡或溢出——这是早期深层网络难以训练的经典困境。$\blacksquare$
:::

::: intuition 连乘为什么致命：把梯度想成一条接力链
反向传播把损失的变化量从最后一层传到第一层，每一层都要乘以本层的「传导率」$\sigma'$。传导率小于 $1$ 时，**多次相乘等于反复打折**：打九折十次是 $0.35$，打二五折十次只剩百万分之一。而且这不是「平均意义上」的折扣——Sigmoid 在 $|z|$ 大时折扣到千分之一，而大 $|z|$ 恰恰是「网络很自信」的样本，也就是说**网络越自信，越学不动**。tanh 把上限从 $0.25$ 提到 $1$，缓解了一个数量级，但没有解决「大输入时塌到零」这个结构性问题。
:::

::: cor 推论 1.3.1 · 初始化与激活必须匹配 {#cor-1.3.1}
由定理 1.3.1 与 [1.2.5](sec12.md)的方差守恒推导可得两条配对规则：Sigmoid / tanh 配 Xavier（增益 $2/(d_{\text{in}}+d_{\text{out}})$），ReLU 族配 Kaiming（增益 $2/d_{\text{in}}$）。**用错配对的症状不同**：Sigmoid 配 Kaiming 会因增益过大而让 $|z|$ 变大、快速进入饱和区（表现为训练初期损失几乎不降）；ReLU 配 Xavier 会因增益偏小而逐层衰减（表现为深层网络的有效深度变小）。
:::

## 1.3.4 ReLU 的死亡问题与缓解

ReLU 在 $z\lt0$ 时输出为 $0$ 且导数为 $0$：**如果一个单元对训练集里的所有样本都落在负半区，它的梯度永远是 $0$，参数永远不会被更新**（包括偏置）——这就是「死亡 ReLU」（dying ReLU）。

::: think 死亡不是瞬时事件，而是一个自我强化的过程
一次过大的梯度更新（通常来自过大的学习率、或某个批里的离群样本）可能把某个单元的偏置推到很负的位置，使它对所有样本都输出 $0$；此后它的梯度恒为 $0$，于是**它再也不能把自己救回来**。与「饱和」的区别是：Sigmoid 的饱和单元只要输入分布变化还会恢复（导数小但非零），死亡 ReLU 的单元是永久失效的。

缓解手段有五种，从弱到强：

1. **降低学习率 / 加学习率 warmup**：减少「一步踢死」的概率（见 [1.6.5](sec16.md)）。
2. **换用带负区斜率的激活**：LeakyReLU（$\alpha=0.01$ 量级）、ELU、SiLU、GELU——负区导数非零或非恒零，单元可以恢复。
3. **改用更温和的初始化**：Kaiming 而非更大增益，避免初始就把大量单元推到负半区。
4. **归一化层**：BatchNorm / LayerNorm 保持每层输入分布稳定，降低「全批全负」的概率（见 [1.7.4](sec17.md)）。
5. **增大宽度**：不是治本方案，只是让「死掉一批」的后果被稀释；在容量充足时常用。
:::

| 现象 | 症状 | 判据 | 首选处置 |
|:--|:--|:--|:--|
| 死亡 ReLU | 某层激活大量恒为 $0$，损失下降到平台 | 统计每层「激活为 0 的比例」持续接近 1 | 换 GELU/SiLU，加 warmup |
| 梯度饱和（Sigmoid/tanh） | 首层梯度范数比末层小若干数量级 | 打印每层梯度范数，比值随深度指数下降 | 换 ReLU 族；改 Xavier 初始化 |
| 梯度爆炸 | 损失出现 NaN / 大幅震荡 | 梯度范数逐层放大 | 梯度裁剪（[1.6.6](sec16.md)）、降学习率 |

## 1.3.5 平滑化与门控：GELU、SiLU 与 GLU 家族 {#sec-1.3.5}

**平滑化路线。** GELU 与 SiLU 都把 ReLU 的硬折角换成光滑曲线：

$$\mathrm{GELU}(z)=z\,\Phi(z),\qquad \mathrm{SiLU}(z)=z\,\sigma(z).$$

两者都可以写成「输入 × 一个门」的形式：GELU 的门是标准正态 CDF，SiLU 的门是 Sigmoid。它们与原 ReLU 的差别有三点：**在 $z=0$ 附近有非零的负值区间**（允许小幅度反向响应）、**在负半区导数为小正数**（不会永久死亡）、**处处可导**（对二阶方法、平滑分析更友好）。代价是需要指数或误差函数的计算（GELU 的 tanh 近似缓解了一部分），以及在部分任务上相对 ReLU 并没有稳定优势——需要以「实证结果」而非「数学更漂亮」来判断。

**门控路线。** GLU 家族换了一个思路：不再对每个坐标单独施加一个固定形状的弯曲，而是**用同一输入的另一个线性投影生成一个逐元素的门**：

::: def 定义 1.3.2 · GLU 家族（gated linear unit） {#def-1.3.2}
给定输入 $\boldsymbol z$，线性门控单元定义为

$$\mathrm{GLU}(\boldsymbol z)=\bigl(W_1\boldsymbol z\bigr)\odot\sigma\bigl(W_2\boldsymbol z\bigr),$$

其中 $\odot$ 为逐元素积，$\sigma$ 为门控激活。替换门控激活即得变体：**GeGLU**（用 GELU）、**SwiGLU**（用 SiLU / Swish）、**ReGLU**（用 ReLU）。在现代 Transformer 的前馈层里，通常写成 $(\mathrm{SiLU}(\boldsymbol xW_{\text{gate}})\odot\boldsymbol xW_{\text{up}})W_{\text{down}}$。
:::

::: intuition 门与固定激活的差别：谁来决定「该不该放行」
ReLU 的开关是**固定**的：$z\gt0$ 就放行。GLU 的开关是**学出来的**：$\sigma(W_2\boldsymbol z)$ 可以依赖输入的任意方向，网络因此能表达「在特征 A 出现时放大特征 B，在特征 A 消失时关闭特征 B」这类**条件性**关系。这就是为什么门控在语言模型里特别有效——语言里的依赖本来就是条件性的（下一个词是什么，取决于前面出现的是什么）。
:::

::: errata 关于 GLU 的两个必须说清的事实
1. **GLU 不是「激活函数」，而是一个含参数的层**。它自带两个线性投影 $W_1,W_2$（以及后续的 $W_{\text{down}}$），因此参数量比「一个线性层 + 一个逐元素激活」更多。工程上为了保持总参数量可比，通常会把隐藏宽度按比例缩小（文献中常见做法是缩到原来的约 $2/3$，具体比例与实现相关，**需核实**你所参考的具体实现）。
2. **「SwiGLU 一定优于 GELU」是过强的说法**。它在若干公开的语言模型对比中被报告为更好，但结论依赖模型规模、数据与训练配置，**不能无条件外推**。稳妥的表述是：**截至 2025 年，多数开源大模型的前馈层默认采用 SwiGLU 类门控**（如 LLaMA 系列的公开配置），这是一个**社区默认做法**，而它的收益幅度需要在你自己的配置上验证。
:::

**顺带说清 RMSNorm。** 现代大模型在归一化上普遍从 LayerNorm 换成了 **RMSNorm**：它只做「按均方根缩放」，不减均值、不学偏置，计算更省且效果相当。这是与激活选择同时发生的另一处默认变更，原理与对比放在 [1.7.4](sec17.md) 统一处理。

::: ex 例 1.3.1 · 一个饱和单元的梯度还剩多少 {#ex-1.3.1}
某隐藏层使用 tanh 激活，某个单元在训练集上的预激活集中在 $z\approx3.0$ 附近（例如该单元已学到一个较大的偏置）。批大小 $B=64$。

(1) 求该单元的 $\tanh'(3.0)$；(2) 若这一层还有 4 个同量级的 tanh 层在它下面（即梯度要再连乘 4 次），第一层收到的梯度是被衰减了多少倍？(3) 把激活换成 ReLU，在 $z=3.0$ 处这个衰减是多少？(4) 为什么这说明「饱和」不是「梯度为零」而是「梯度被系统性打折」？

::: proof 解
**(1)** $\tanh 3.0=0.99505$，故 $\tanh'(3.0)=1-\tanh^2 3.0=1-0.99012=0.00988$。注意它**不是零**——这正是「饱和」而非「死亡」。

**(2)** 单层衰减 $0.00988$，五层连乘（本层 + 下方 4 层）为 $0.00988^{5}\approx9.4\times10^{-11}$。也就是说，这一路的梯度在传到第一层时已经剩下不到百亿分之一。

**(3)** ReLU 在 $z=3.0\gt0$ 处的导数是 $1$，五层连乘为 $1$。**同样的深度、同样的预激活量级，仅因激活不同，梯度相差 $9.4\times10^{-11}$ 倍。**

**(4)** 因为 $0.00988\neq0$：如果输入分布改变（比如归一化层把 $z$ 拉回 $0$ 附近，或数据重新标准化），导数会立刻回升到接近 $1$——单元可以恢复。而死亡 ReLU 的导数是**精确的 $0$**，参数永不更新，也就没有任何机制能把它救回来。**判据**：打印每层梯度范数，若随深度呈几何衰减（比值稳定），是饱和；若某一层直接变成 $0$ 且此后不再变化，是死亡。$\blacksquare$
:::
:::

::: ex 例 1.3.2 · SwiGLU 前馈层的参数量该缩多少 {#ex-1.3.2}
某 Transformer 的模型维度 $d_{\text{model}}=4096$，基线前馈层是「两层线性 + 激活」：`d_model → 4·d_model → d_model`（不含偏置）。若改用 SwiGLU（三个投影：gate / up / down），并要求**总参数量与基线一致**，中间宽度 $d_{\text{ff}}$ 应取多少？

::: proof 解
**基线参数量**（不含偏置）：$d_{\text{model}}\cdot4d_{\text{model}}+4d_{\text{model}}\cdot d_{\text{model}}=8d_{\text{model}}^2$。

**SwiGLU 参数量**（不含偏置）：gate、up、down 三个投影，输入输出分别是 $d_{\text{model}}\to d_{\text{ff}}$、$d_{\text{model}}\to d_{\text{ff}}$、$d_{\text{ff}}\to d_{\text{model}}$，合计

$$2\,d_{\text{model}}d_{\text{ff}}+d_{\text{ff}}d_{\text{model}}=3\,d_{\text{model}}d_{\text{ff}} .$$

**令二者相等**：$3d_{\text{model}}d_{\text{ff}}=8d_{\text{model}}^2\Rightarrow d_{\text{ff}}=\dfrac{8}{3}d_{\text{model}}\approx2.667\,d_{\text{model}}$。

代入 $d_{\text{model}}=4096$：$d_{\text{ff}}\approx10922$。实际工程中通常取一个便于并行切分的整数（如 11008 —— 这是公开的 LLaMA 系列配置中常见的取值，**具体数字以你使用的模型配置为准**），并把结果与「$8d_{\text{model}}^2$ 量级」核对。

**读法**：$8/3\approx2.67$ 这个倍数是「三个矩阵对两个矩阵」的必然结果；它也解释了为什么改用 GLU 家族时**必须重算前馈层宽度**，而不是保留 $4d$ 不动（那会让参数量变成原来的 $1.5$ 倍）。$\blacksquare$
:::
:::

## 1.3.6 形状、参数量与显存：激活选择改变了什么

| 组件 | 参数量（隐藏宽 $d$、前馈宽 $4d$） | 相对代价 | 说明 |
|:--|:--|:--|:--|
| 线性层 + 逐元素激活 | $d\cdot4d+4d\cdot d=8d^2$ | $1\times$ | GELU / ReLU / SiLU 属于此类；不含偏置 |
| SwiGLU（未缩放宽度） | $3\cdot d\cdot4d=12d^2$ | $1.5\times$ | 三个投影：gate / up / down；不含偏置 |
| SwiGLU（宽幅缩至约 $8d/3$） | $3\cdot d\cdot\frac{8d}{3}=8d^2$ | 约 $1\times$ | 与基线参数量相同；实际宽度取整会带来小幅偏差 |

::: method 激活选择与显存的关系（速算）
逐元素激活**不增加参数量**，但增加**激活显存**：反向传播需要保存前向的中间结果，ReLU 只需保存一个 0/1 掩码（甚至可用输入符号重算），而 GELU / SiLU / GLU 的门值需要保存浮点结果。对宽度 $4d$、批 $B$、序列长 $T$ 的前馈层，掩码方案约 $BT\cdot4d$ 比特量级，门控方案约 $BT\cdot4d$ 个浮点数——两者相差一个数据格式的倍数（$16/32$ 倍）。**这就是「换激活会让显存涨一点」的算术依据**，也是激活重计算（activation checkpointing）要处理的量级（见 [第 9 讲](../lec09/overview.md)）。
:::

## 1.3.7 代码：激活的导数、死亡比例与门控层

```python
import torch, torch.nn as nn, torch.nn.functional as F

# ① 用自动微分核对 1.3.2 表里的导数结论（Sigmoid 上限 1/4、tanh 上限 1、ReLU 为 0/1）
z = torch.linspace(-6, 6, 13, requires_grad=True)
for name, fn in [("sigmoid", torch.sigmoid), ("tanh", torch.tanh),
                 ("silu", F.silu), ("gelu", F.gelu), ("relu", F.relu)]:
    g = torch.autograd.grad(fn(z).sum(), z, create_graph=False)[0]
    print(f"{name:8s} max|grad| = {g.abs().max():.4f}  min|grad| = {g.abs().min():.4f}")

# ② 死亡 ReLU 侦察：统计每层激活为 0 的比例（判据来自 1.3.4 的表）
def dead_ratio(model, x, threshold=1e-8):
    ratios, h = [], x
    for layer in model:
        h = layer(h)
        if isinstance(layer, nn.ReLU):
            # 只看 ReLU 输出：逐样本、逐通道统计“恒为零”的比例
            ratios.append((h.abs() < threshold).float().mean().item())
    return ratios

net = nn.Sequential(nn.Linear(64, 256), nn.ReLU(),
                    nn.Linear(256, 256), nn.ReLU(),
                    nn.Linear(256, 64), nn.ReLU())
# 极端初始化（偏置全设为很负的数）：人为制造大面积死亡，观察比例飙升
for m in net.modules():
    if isinstance(m, nn.Linear):
        nn.init.kaiming_normal_(m.weight, nonlinearity="relu")
        nn.init.constant_(m.bias, -3.0)     # 反例：把单元整体推到负半区
print("dead ratio (bad init):", dead_ratio(net, torch.randn(512, 64)))

for m in net.modules():
    if isinstance(m, nn.Linear):
        nn.init.zeros_(m.bias)              # 修正：偏置归零，死亡比例显著回落
print("dead ratio (fixed  ):", dead_ratio(net, torch.randn(512, 64)))

# ③ 门控前馈层的形状与参数量：对照 1.3.6 的表
class SwiGLUFeedForward(nn.Module):
    def __init__(self, d_model, d_ff):
        super().__init__()
        self.gate = nn.Linear(d_model, d_ff, bias=False)  # 门控投影
        self.up   = nn.Linear(d_model, d_ff, bias=False)  # 值投影
        self.down = nn.Linear(d_ff, d_model, bias=False)  # 回到模型维度
    def forward(self, x):                                  # x: (B, T, d_model)
        # 门与值逐元素相乘：门控制每个特征位置放行多少
        return self.down(F.silu(self.gate(x)) * self.up(x))  # -> (B, T, d_model)

ff = SwiGLUFeedForward(512, 1368)   # 4d=2048 时的常见缩放取整（比例需核实具体实现）
print("SwiGLU params:", sum(p.numel() for p in ff.parameters()))     # 3*d*d_ff
plain = nn.Sequential(nn.Linear(512, 2048, bias=False), nn.SiLU(),
                      nn.Linear(2048, 512, bias=False))
print("plain  params:", sum(p.numel() for p in plain.parameters()))  # 2*d*2048
```

## 1.3.8 陷阱与勘误

::: errata 本节六个常见误解
1. **「隐藏层用 Sigmoid 更『神经』」**：直接落进定理 1.3.1 的 $0.25^{L}$ 陷阱。隐藏层默认用 ReLU 族；Sigmoid 只用在需要 $(0,1)$ 输出的位置（二分类输出层、门控里的门）。
2. **「ReLU 的稀疏性天然更好」**：稀疏本身不是优点。负区输出为零意味着**该路径没有学到任何东西**；只有当网络宽度足够、且负区分布是数据驱动的（而非初始化偏差导致）时，稀疏才是无害的。
3. **「换更好的激活就能提点」**：激活的收益与初始化、学习率、归一化层强耦合。只换激活而不动其他超参，常常看不到差别——这也是「GELU 比 ReLU 好」的实验结论在不同配置下不一致的原因之一。
4. **「输出层也可以用 ReLU / GELU」**：输出层要做的是「映射到任务取值域」。回归输出若有明确非负约束才考虑 ReLU / Softplus；分类必须用 softmax（且通常与交叉熵一起由框架的 `CrossEntropyLoss` 处理，见 [1.4.6](sec14.md)）。
5. **「GLU 里的 $\sigma$ 与 Sigmoid 输出层是一回事」**：形式相同，语义不同。门控里的 $\sigma$ 是**逐元素的乘性权重**，不是概率分布；不同的门控激活（Sigmoid / GELU / SiLU）会得到不同变体，不能随意替换。
6. **「激活函数与归一化层可以互相替代」**：不能。激活提供**逐元素非线性**（改变的是「函数形状」），归一化提供**跨样本或跨特征的统计标准化**（改变的是「分布的尺度与位置」）。两者作用维度不同，缺一不可。
:::

::: note[skip] 一个被忽略的实现细节：激活的原地操作与数值精度
框架里的 `nn.ReLU(inplace=True)` 会就地覆盖输入张量以省内存，但**它会破坏反向传播所需的中间值**（反向时要用到预激活的符号）。在残差连接、激活检查点（activation checkpointing）等场景里，原地操作会导致梯度错误或直接报错。**默认建议用 `inplace=False`**，只在显存确实吃紧且该激活的输出不再被其他分支使用时才打开。

另一个是精度问题：SiLU / GELU 在 $z$ 很负时输出极小（SiLU 在 $z=-10$ 处约 $-4.5\times10^{-4}$），在 FP16 中仍可表示，但**在 BF16 中靠近 $10^{-5}$ 量级时会损失有效位**；当这些值还要经过多次连乘（门控 × 投影）时，低精度下的误差会被放大。工程上的做法是：门控乘积通常在更高精度或使用融合算子中计算，而不是逐元素拆开做。**具体实现细节依赖框架版本，遇到低精度下的异常发散时，这是应当检查的一处（需核实具体框架的融合策略）。**
:::

::: method 即时自测 · 1.3
**Q1** 写出 Sigmoid 及其导数，说明为什么「Sigmoid 深层网络训不动」可以用一个数字（导数上限）概括。

**Q2** 死亡 ReLU 与 Sigmoid 饱和这两种「梯度为零」的现象，在机制上有何不同？各自的首选处置是什么？

**Q3** GELU 与 ReLU 在 $z\to-\infty$ 时的行为差别是什么？这个差别为什么有助于缓解死亡问题？

**Q4** 为什么把前馈层的 ReLU 换成 SwiGLU 时，往往要同时把隐藏宽度从 $4d$ 调小？

::: sol 参考要点
**Q1** $\sigma(z)=\frac{1}{1+e^{-z}}$，$\sigma'(z)=\sigma(z)(1-\sigma(z))\le\frac14$，在 $z=0$ 取等。反向传播要连乘各层导数，于是 $L$ 层网络至少把梯度乘上 $(1/4)^L$：$L=10$ 时约 $10^{-6}$。这个上限是**结构性**的，与数据、学习率无关。

**Q2** 机制不同：Sigmoid 的饱和是**当前输入落在饱和区**导致导数很小但**非零**，输入分布变化后单元可以恢复；死亡 ReLU 是**导数恒为 0**，且因为梯度为零，参数永不更新，单元无法自行恢复（自我强化）。处置：饱和问题换 ReLU 族并配对 Xavier / Kaiming 初始化；死亡问题换 GELU/SiLU、降低学习率、加 warmup、或加归一化层。

**Q3** $z\to-\infty$ 时 ReLU 恒为 $0$、导数恒为 $0$；GELU 渐近为 $0$，但导数是一个**很小但严格为正**的值（$\Phi(z)$ 项贡献 $z\varphi(z)$ 量级的负向修正，整体趋向 $0^-$ 但过程中不为零）；更准确地说，SiLU 在负区的导数在 $z\approx-1.28$ 附近达到约 $-0.1$ 的极小值，而不是恒零。这意味着负区单元仍能收到（反向的）梯度信号，从而有机会回到正区。

**Q4** 因为 SwiGLU 有三个权重矩阵（gate / up / down）而不是两个，若不改宽度，参数量与计算量约变为原来的 $1.5$ 倍（$3$ 个矩阵对 $2$ 个矩阵）。为保持与基线可比的总参数量与显存占用，常见的做法是把隐藏宽度按比例缩小（缩到约 $2/3$），具体比例与实现和模型规模有关。
:::
:::

::: note[skip] 延伸阅读
- Hendrycks & Gimpel, *Gaussian Error Linear Units (GELUs)*（2016，arXiv:1606.08415）——GELU 原始论文，含 tanh 近似。
- Elfwing, Uchibe & Doya, *Sigmoid-Weighted Linear Units for Neural Network Function Approximation in Reinforcement Learning*（2017，arXiv:1702.03118）——SiLU / Swish 的原始来源之一。
- Ramachandran, Zoph & Le, *Searching for Activation Functions*（2017，arXiv:1710.05941）——把 SiLU 作为搜索结果的报告，含与 ReLU 的对照实验。
- Dauphin, Fan, Auli & Grangier, *Language Modeling with Gated Convolutional Networks*（2017，arXiv:1612.08083）——GLU 的提出与门控动机。
- Shazeer, *GLU Variants Improve Transformer*（2020，arXiv:2002.05202）——GeGLU / SwiGLU 在 Transformer 上的对比与宽幅缩放。
- Zhang & Sennrich, *Root Mean Square Layer Normalization*（2019，arXiv:1910.07467）——RMSNorm 原始论文（细节见 [1.7.4](sec17.md)）。
:::

**本节小结**：激活函数是网络里唯一的非线性来源，它的选择由「导数会不会塌到零」这一条主线决定：Sigmoid 在两端塌（定量上界 $0.25^{L}$），ReLU 在负半区塌（死亡单元不可自愈），GELU / SiLU 用平滑与小斜率折中，GLU 家族把门控交给学出来的投影。激活必须与初始化（Xavier / Kaiming）、归一化层配合使用，单独换激活通常看不到稳定收益。下一节回答一个被激活问题掩盖的、更根本的问题：**什么叫「好」——损失函数是怎么把任务翻译成可优化的目标的。**
