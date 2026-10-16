# 第 2 讲 · 深度序列建模

> 上一讲我们用 MLP 处理**定长向量**：输入 $784$ 维就永远是 $784$ 维。但语言、音乐、时间序列、传感器读数都不是定长的——它们有长度、有顺序、重复出现的模式。本讲把「结构」换成能处理序列的三代设计：**RNN**（沿时间展开的权值共享）→ **门控网络**（LSTM / GRU，用加法通道换梯度稳定性）→ **注意力与 Transformer**（对任意位置加权聚合，彻底摆脱递推）。读完这一讲，你手里就有了大语言模型的主干结构。

<aside class="lesson-brief" aria-label="第 2 讲学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>第 1 讲的 MLP、交叉熵与反向传播；矩阵乘法与雅可比矩阵的含义；softmax 与概率归一化；链式法则的连乘直觉。</p></div>
<div><span class="brief-label">TARGET</span><strong>本讲要建立</strong><p>序列建模的三个要求（变长 / 保序 / 参数共享）；RNN 隐状态递推与沿时间展开；BPTT 的连乘结构与梯度消失 / 爆炸；梯度裁剪；LSTM / GRU 的门控与细胞状态；注意力机制与缩放点积注意力；Transformer 的多头自注意力、前馈层、残差 + LayerNorm、位置编码与 $O(T^2d)$ 复杂度；温度采样与自回归生成。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能手写 RNN 的递推式并说明权重为何共享；能解释连乘雅可比如何导致梯度消失 / 爆炸，以及裁剪与门控各自治哪一个；能写出缩放点积注意力并说明 Q / K / V 的角色与除以 $\sqrt{d_k}$ 的理由；能说明位置编码为何必要（置换等变）；能说清 Transformer 各部件与 $O(T^2d)$ 瓶颈。</p></div>
</aside>

::: method[core] 10 分钟复习版 · 第 2 讲

**一句话**：序列建模的三代方案是「**RNN（递推 + 权值共享）→ 门控（加法式记忆）→ 注意力 / Transformer（对任意位置加权聚合）**」，驱动力始终是同一对矛盾：**长程依赖要稳、序列要能并行**。

**必记结论**

| 内容 | 要点 |
|:--|:--|
| **为什么不用 MLP** | 序列**变长**（维度不定）、顺序有意义、需要**参数共享**；摊平成定长向量会参数量爆炸且无法泛化到新长度 |
| **RNN 递推** | $\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h)$，$\hat{\boldsymbol y}_t=\psi(W_{hy}\boldsymbol h_t+\boldsymbol b_y)$；**同一组权重在每个时间步复用** |
| **沿时间展开** | 把 $T$ 步递推画成 $T$ 层、共享权重的网络；隐状态 $\boldsymbol h_t$ 是过往信息的**定长有损摘要** |
| **BPTT** | $\mathcal L=\sum_t\mathcal L_t$；跨 $s-t$ 步的梯度含 $\bigl(\operatorname{diag}(\phi')W_{hh}^{\mathrm T}\bigr)$ 的**连乘** |
| **梯度消失 / 爆炸** | 连乘因子谱半径 $<1$ 指数衰减、$>1$ 指数增长；这就是 RNN 难捕捉**长程依赖**的根源 |
| **梯度裁剪** | $\boldsymbol g\leftarrow\boldsymbol g\cdot\dfrac{\text{阈值}}{\lVert\boldsymbol g\rVert}$（当 $\lVert\boldsymbol g\rVert$ 超阈值）：**只治爆炸，不治消失** |
| **LSTM** | 遗忘门 / 输入门 / 输出门 + 细胞状态 $\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$ |
| **GRU** | 更新门 / 重置门（两个门），$\boldsymbol h_t=(1-\boldsymbol z_t)\odot\boldsymbol h_{t-1}+\boldsymbol z_t\odot\tilde{\boldsymbol h}_t$ |
| **门控为何有效** | 细胞状态走**加法**通道，$\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}=\operatorname{diag}(\boldsymbol f_t)$，$\boldsymbol f_t\approx1$ 时梯度近似恒等传递（梯度高速通道） |
| **注意力** | 从「编码器把整句压成一个向量」的瓶颈，改为对**所有位置**加权聚合：$\operatorname{softmax}(\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_k})\boldsymbol V$ |
| **Q / K / V** | Q = 当前位置「想找什么」，K = 每个位置的「匹配标签」，V = 每个位置「被取走的内容」 |
| **除以 $\sqrt{d_k}$** | 独立零均值单位方差下点积方差为 $d_k$；不缩放会让 softmax 饱和、梯度趋零 |
| **Transformer 块** | 多头自注意力 → 残差 + LayerNorm → 前馈层 → 残差 + LayerNorm |
| **位置编码** | 注意力**置换等变**，因此**必须**显式注入位置信息（正弦式或学习式） |
| **复杂度** | 自注意力 $O(T^2d)$：随序列长度**平方**增长，是长序列的核心瓶颈 |
| **生成** | 自回归 + 因果 mask；温度采样 $\hat p_i\propto\exp(z_i/\tau)$，$\tau$ 小更保守、$\tau$ 大更多样也更乱 |

**最该记住的四个判断**：① RNN 的问题不是「不够深」，而是**沿时间的连乘雅可比**，门控与裁剪分别针对消失与爆炸；② 注意力**本身不含顺序**，位置编码不是可选项；③ Transformer 用**一次矩阵乘法看全局**换来了训练并行，代价是 $O(T^2d)$；④ 长序列、大数据、需并行 → 倾向 Transformer；超长流式、小数据 → 递推类仍有位置。

:::

## 2.1 为什么需要序列模型

MLP 的输入是一块**定长的**数字。可序列有三个它对付不了的性质。

- **变长**：句子 3 个词还是 300 个词？音频几秒还是几分钟？输入维度不固定，网络无法用一组固定形状的权重接住它。
- **顺序有意义**：「狗咬人」和「人咬狗」是同一堆词的不同排列，含义相反。若把序列当作**无序集合**喂进去，模型区分不了它们。
- **参数共享**：同一个词「猫」出现在第 1 位还是第 50 位，应该由**同一套**参数来处理。若给每个位置单独配一套权重，参数量会随最长序列线性（甚至平方）膨胀，而且训练时没见过那么长的序列就无法外推。

::: def 定义 2.1 · 序列建模问题 {#def-2-1}
给定序列 $\boldsymbol x_{1:T}=(\boldsymbol x_1,\dots,\boldsymbol x_T)$，每个 $\boldsymbol x_t\in\mathbb R^{d_x}$，长度 $T$ 可变。序列建模就是学一个**参数不随 $T$ 变化**的函数 $f_\theta$，按输出形态分三类：

| 任务形态 | 目标 | 例子 |
|:--|:--|:--|
| 序列 → 类别 | $\hat y=f_\theta(\boldsymbol x_{1:T})$ | 情感分类、音频事件识别 |
| 序列 → 序列 | $\hat{\boldsymbol y}_{1:T}=f_\theta(\boldsymbol x_{1:T})$ | 词性标注、机器翻译 |
| **自回归生成** | 建模 $p(\boldsymbol x_t\mid\boldsymbol x_{\lt t})$，把上一步输出接回输入 | 语言模型、音乐生成 |

关键约束落在「参数不随 $T$ 变化」上：它既是**权值共享**的要求，也是模型能处理训练时未见长度的前提。
:::

::: intuition 序列模型的统一图景：状态随时间演化
把序列看成一个**离散时间动力系统**：在每个时刻 $t$，模型维护一个状态，读入当前输入 $\boldsymbol x_t$，更新状态，再据此输出。MLP 是「$T$ 个互不相关位置各自算」，而真正的序列模型要求「第 $t$ 步的结果依赖前 $t-1$ 步」。所有序列架构——RNN 的隐状态、LSTM 的细胞状态、注意力里的键值表——本质都是**状态的载体**，区别只在于：状态怎么更新、装得下多少历史、能不能一步看全局。
:::

## 2.2 RNN：沿时间展开的权值共享

最朴素的想法：让网络自带一个「记忆」，每读一个输入就更新一次。

::: def 定义 2.2 · 循环神经网络（RNN） {#def-2-2}
给定输入 $\boldsymbol x_t\in\mathbb R^{d_x}$，RNN 用隐状态 $\boldsymbol h_t\in\mathbb R^{d_h}$ 递推：

$$\boldsymbol h_t=\phi\bigl(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h\bigr),\qquad
\hat{\boldsymbol y}_t=\psi\bigl(W_{hy}\boldsymbol h_t+\boldsymbol b_y\bigr).$$

其中 $\boldsymbol h_0$ 常取零向量，$W_{hh}\in\mathbb R^{d_h\times d_h}$、$W_{xh}\in\mathbb R^{d_h\times d_x}$、$W_{hy}\in\mathbb R^{d_y\times d_h}$；$\phi$ 常用 $\tanh$，$\psi$ 按任务选（分类配 softmax）。**同一组 $W_{hh},W_{xh}$ 在所有时间步复用**——这正是 [2.1](#21-为什么需要序列模型) 要求的参数共享。
:::

**沿时间展开（unrolling）**：把 $t=1,\dots,T$ 的递推平铺开，RNN 就变成一个 $T$ 层深的网络，且每一层的权重完全相同、相邻层之间还有一条「隐状态」通路。$\boldsymbol h_t$ 是**前 $t$ 步所有输入和更新的函数**，因此它扮演了「把整段历史压进一个固定维度向量」的角色。

::: intuition 隐状态是一个有损摘要，不是完整记忆
$\boldsymbol h_t$ 的维度 $d_h$ 是固定的，而它要承载的历史长度 $t$ 可以任意增长。信息论上，把任意长的历史无损塞进固定维度是不可能的——所以 $\boldsymbol h_t$ 只能是一个**有损摘要**。这就是 RNN 的**信息瓶颈**：越早的信息越容易被后续更新「覆盖」。请先记住这一点，[2.4](#24-从压缩瓶颈到注意力机制) 的注意力机制正是来拆掉这个瓶颈的。
:::

### 沿时间反向传播（BPTT）与梯度消失 / 爆炸

序列到序列或逐步损失的情形下，总损失是各步损失之和 $\mathcal L=\sum_{t=1}^{T}\mathcal L_t$。要对 $W_{hh}$ 求梯度，就得把误差传回早期时间步——做法与第 1 讲的反向传播完全一样（仍是链式法则），只是「层」变成了「时间步」，因此叫**沿时间反向传播**（Backpropagation Through Time, BPTT）。

::: thm 定理 2.1 · BPTT 的连乘结构 {#thm-2-1}
令 $\boldsymbol z_k=W_{hh}\boldsymbol h_{k-1}+W_{xh}\boldsymbol x_k+\boldsymbol b_h$。则由链式法则，

$$\frac{\partial \boldsymbol h_k}{\partial \boldsymbol h_{k-1}}=\operatorname{diag}\bigl(\phi'(\boldsymbol z_k)\bigr)W_{hh},\qquad
\frac{\partial \boldsymbol h_s}{\partial \boldsymbol h_t}=\prod_{k=t+1}^{s}\frac{\partial \boldsymbol h_k}{\partial \boldsymbol h_{k-1}}
=\prod_{k=t+1}^{s}\operatorname{diag}\bigl(\phi'(\boldsymbol z_k)\bigr)W_{hh}.$$

于是「$t$ 时刻的状态经由 $s-t$ 步影响 $s$ 时刻的损失」这条路径上，梯度含 $W_{hh}$（经 $\phi'$ 调制）的 $(s-t)$ 次**连乘**。
:::

::: ex 例 2.1 · 连乘为什么导致梯度消失与爆炸（标量直觉） {#ex-2-1}
把 RNN 退化成标量 $h_t=\phi(w\,h_{t-1}+\cdots)$，讨论跨 $n$ 步的梯度因子。

::: proof 解
标量情形下 $\dfrac{\partial h_t}{\partial h_{t-n}}=\displaystyle\prod_{k=t-n+1}^{t}w\,\phi'(\boldsymbol z_k)=(w)^n\prod_k\phi'(\boldsymbol z_k)$。取 $\phi=\tanh$，其导数满足 $\lvert\phi'\rvert\le1$，于是

$$\left\lvert\frac{\partial h_t}{\partial h_{t-n}}\right\rvert\le\lvert w\rvert^{\,n}.$$

- 若 $\lvert w\rvert\lt1$：因子随 $n$ 指数**衰减**，远处的梯度几乎传不回来 → 梯度消失；
- 若 $\lvert w\rvert\gt1$：因子随 $n$ 指数**增长**，梯度随步数爆掉 → 梯度爆炸。

多维权重的情形同理，把 $\lvert w\rvert$ 换成 $\operatorname{diag}(\phi')W_{hh}$ 的谱半径（最大特征值模长）即可：**梯度能否跨 $n$ 步存活，取决于这个连乘的伸缩率**，而它与 $n$ 成指数关系，因此没有临界性可言——不是衰减到零就是涨到溢出。
:::

:::

这正是 RNN 难以捕捉**长程依赖**的数学根源：想让「第 5 位的词」影响「第 200 步的输出」，所需的梯度要穿过 195 次连乘，几乎必然消失或爆炸。工程上的对策有两条主线：

::: method 梯度裁剪（gradient clipping）：治爆炸 {#method-2-1}
爆炸的后果是数值溢出（`NaN`）、损失瞬间飞掉。裁剪在**更新前**把梯度的尺度压回可控范围：

$$\boldsymbol g\leftarrow\boldsymbol g\cdot\min\!\left(1,\ \frac{\text{阈值}}{\lVert\boldsymbol g\rVert}\right),$$

即梯度范数超阈值时按比例等比缩小、**方向不变**。它是几乎所有 RNN / Transformer 训练的标配。**注意它的边界**：裁剪只压得住爆炸，对消失无能为力——梯度已经小到接近零，再乘一个系数也救不回来。消失要靠下面 2.3 的门控结构。
:::

::: intuition 消失是"乘法"的宿命，门控用"加法"来破
连乘雅可比是问题核心：既有**参数量级**问题（$\lvert w\rvert$ 偏离 1 就指数偏离），也有**非线性压缩**问题（$\tanh$ 导数常年在 $1$ 以下，反向每穿一层就打一次折）。注意，问题出在**乘**。如果状态更新写成 $\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+(\cdots)$，那么 $\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}=\operatorname{diag}(\boldsymbol f_t)$ **不再含 $W$ 的连乘**，只要门 $\boldsymbol f_t\approx1$ 就能把梯度近似恒等地送回去。门控网络的全部巧思，就是造出这样一条**加法式的梯度通道**。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 900 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-rnn-title fig-rnn-desc">
<title id="fig-rnn-title">RNN 沿时间展开：同一组权重在每一步复用</title>
<desc id="fig-rnn-desc">将 RNN 的隐状态递推沿时间展开成链：每步读入 xₜ、结合上一步的 hₜ₋₁ 计算新的 hₜ 并输出 yₜ。所有时间步共享同一组 W_hh、W_xh、W_y；反向传播沿时间连乘每步的雅可比。</desc>
<defs></defs>
<text class="diagram-note" fill="ink" x="30" y="32" text-anchor="start" font-weight="700">展开前：h_t = φ(W_hh h_{t−1} + W_xh x_t)　→　展开后：一条链</text>
<rect x="58" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-text" x="110.0" y="142.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="110" y="132" text-anchor="middle" font-size="16px">h₁</text>
<text class="diagram-note" fill="var(--fig-blue)" x="110" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="110" y1="220" x2="110" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="110" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="110" y="240.5" text-anchor="middle" font-size="14px">x₁</text>
<line x1="110" y1="106" x2="110" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="118" y="52" text-anchor="start" font-size="13px">y₁</text>
<line x1="166" y1="138" x2="262" y2="138" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#mk-blue)"/>
<rect x="268" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-text" x="320.0" y="142.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="320" y="132" text-anchor="middle" font-size="16px">h₂</text>
<text class="diagram-note" fill="var(--fig-blue)" x="320" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="320" y1="220" x2="320" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="320" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="320" y="240.5" text-anchor="middle" font-size="14px">x₂</text>
<line x1="320" y1="106" x2="320" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="328" y="52" text-anchor="start" font-size="13px">y₂</text>
<line x1="376" y1="138" x2="472" y2="138" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#mk-blue)"/>
<rect x="478" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-text" x="530.0" y="142.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="530" y="132" text-anchor="middle" font-size="16px">h₃</text>
<text class="diagram-note" fill="var(--fig-blue)" x="530" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="530" y1="220" x2="530" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="530" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="530" y="240.5" text-anchor="middle" font-size="14px">x₃</text>
<line x1="530" y1="106" x2="530" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="538" y="52" text-anchor="start" font-size="13px">y₃</text>
<line x1="586" y1="138" x2="682" y2="138" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#mk-blue)"/>
<rect x="688" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-text" x="740.0" y="142.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="740" y="132" text-anchor="middle" font-size="16px">h₃</text>
<text class="diagram-note" fill="var(--fig-blue)" x="740" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="740" y1="220" x2="740" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="740" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="740" y="240.5" text-anchor="middle" font-size="14px">x₃</text>
<line x1="740" y1="106" x2="740" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="748" y="52" text-anchor="start" font-size="13px">y₃</text>
<path d="M 110 196 C 110 240 320 240 320 196" fill="none" stroke="var(--fig-gold)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-gold)"/>
<path d="M 320 196 C 320 240 530 240 530 196" fill="none" stroke="var(--fig-gold)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-gold)"/>
<path d="M 530 196 C 530 240 740 240 740 196" fill="none" stroke="var(--fig-gold)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-gold)"/>
<text class="diagram-mono" fill="var(--fig-gold)" x="215.0" y="262" text-anchor="middle" font-size="12.5px">同一组 (W_hh, W_xh, W_y)</text>
<line x1="40" y1="138" x2="54" y2="138" stroke="var(--fig-blue)" stroke-width="1.7" marker-end="url(#mk-blue)"/>
<text class="diagram-mono" fill="var(--fig-blue)" x="36" y="142" text-anchor="end" font-size="13px">h₀</text>
<rect x="560" y="20" width="310" height="40" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="715.0" y="44.5" text-anchor="middle"></text>
<text class="diagram-note" fill="var(--fig-red)" x="715" y="38" text-anchor="middle" font-size="13px">BPTT：∂L/∂h₀ = 连乘 ∏ 雅可比 → 梯度消失 / 爆炸（见下图）</text>
</svg>
<figcaption>RNN 的「展开」视角（本教程绘）。折叠时是一**个**带反馈的单元；展开后是一**条**共享权重的链。序列建模的能力（状态记忆）与缺陷（沿时间的连乘雅可比，即 BPTT）都来自这条链——这正是 2.2 节梯度消失与 2.3 节门控改造的出发点。</figcaption>
</figure>

## 2.3 门控：LSTM 与 GRU

**长短期记忆网络**（Long Short-Term Memory, LSTM）引入一条独立的**细胞状态** $\boldsymbol c_t$ 与三个**门**（都是 $\sigma$ 输出的 $0\sim1$ 之间的向量，用来逐元素地「放行 / 拦截」）：

::: def 定义 2.3 · LSTM {#def-2-3}
用 $[\boldsymbol h_{t-1},\boldsymbol x_t]$ 表示二者拼接，则

$$\boldsymbol f_t=\sigma\bigl(W_f[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_f\bigr),\qquad
\boldsymbol i_t=\sigma\bigl(W_i[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_i\bigr),\qquad
\boldsymbol o_t=\sigma\bigl(W_o[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_o\bigr),$$

$$\tilde{\boldsymbol c}_t=\tanh\bigl(W_c[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_c\bigr),\qquad
\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t,\qquad
\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t).$$

**遗忘门** $\boldsymbol f_t$ 决定旧细胞状态保留多少，**输入门** $\boldsymbol i_t$ 决定新候选 $\tilde{\boldsymbol c}_t$ 写入多少，**输出门** $\boldsymbol o_t$ 决定细胞状态有多少暴露给隐状态 $\boldsymbol h_t$（$\odot$ 为逐元素乘）。
:::

**门控循环单元**（Gated Recurrent Unit, GRU）是更精简的版本，把三个门合并成两个：

::: def 定义 2.4 · GRU {#def-2-4}
$$\boldsymbol z_t=\sigma\bigl(W_z[\boldsymbol h_{t-1},\boldsymbol x_t]\bigr),\qquad
\boldsymbol r_t=\sigma\bigl(W_r[\boldsymbol h_{t-1},\boldsymbol x_t]\bigr),$$

$$\tilde{\boldsymbol h}_t=\tanh\bigl(W_h[\boldsymbol r_t\odot\boldsymbol h_{t-1},\boldsymbol x_t]\bigr),\qquad
\boldsymbol h_t=(1-\boldsymbol z_t)\odot\boldsymbol h_{t-1}+\boldsymbol z_t\odot\tilde{\boldsymbol h}_t .$$

**更新门** $\boldsymbol z_t$ 在「旧状态」与「新候选」之间做逐元素插值，**重置门** $\boldsymbol r_t$ 决定计算候选时忽略多少旧状态。GRU 没有独立的细胞状态，参数比 LSTM 少。
:::

::: intuition 加法式更新为什么让梯度更稳
对比两种更新对**上一状态**的雅可比：

- RNN：$\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+\cdots)$，$\dfrac{\partial\boldsymbol h_t}{\partial\boldsymbol h_{t-1}}=\operatorname{diag}(\phi')W_{hh}$——**矩阵连乘**，伸缩率由谱半径决定，指数级别的衰减或增长。
- LSTM：$\dfrac{\partial\boldsymbol c_t}{\partial\boldsymbol c_{t-1}}=\operatorname{diag}(\boldsymbol f_t)$——就是一个**对角矩阵**。遗忘门 $\boldsymbol f_t$ 由网络学出来，当它接近 $1$ 时梯度近似**原样传回**，不经过任何矩阵乘或非线性压缩。

于是 LSTM 在细胞状态上开出了一条「**常数误差传送带**」（constant error carousel）：需要记住多久，就让 $\boldsymbol f_t$ 停在 $1$ 附近多久。GRU 的 $(1-\boldsymbol z_t)\odot\boldsymbol h_{t-1}$ 同理——$\boldsymbol z_t\to0$ 时旧状态被直通保留。这也是为什么门控网络能记住上百步的依赖，而朴素 RNN 连几十步都吃力。

**但要划清边界**：门控是**缓解**而非根治。$\boldsymbol f_t$ 是 sigmoid 输出，仍可能被学到接近 $0$；更根本的是，LSTM / GRU **仍是逐步递推**，第 $t$ 步必须等第 $t-1$ 步算完——训练无法沿时间并行，长序列上这是致命的效率问题。这一缺点要等到注意力机制才被解决。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 880 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-vanish-title fig-vanish-desc">
<title id="fig-vanish-title">梯度随回传时间步数的衰减（对数轴）</title>
<desc id="fig-vanish-desc">横轴为沿时间回传的步数，纵轴为梯度量级（对数刻度）。每步乘 0.25（Sigmoid 饱和）的曲线在 10 步内衰减到百万分之一；乘 0.9（门控改善后）衰减显著变慢；乘 1（ReLU 正区或细胞态加法通道）不衰减。10⁻⁷ 为 float32 的精度地板。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="96.0" y1="44" x2="96.0" y2="254"/><line x1="271.0" y1="44" x2="271.0" y2="254"/><line x1="446.0" y1="44" x2="446.0" y2="254"/><line x1="621.0" y1="44" x2="621.0" y2="254"/><line x1="796.0" y1="44" x2="796.0" y2="254"/><line x1="96" y1="254.0" x2="796" y2="254.0"/><line x1="96" y1="201.5" x2="796" y2="201.5"/><line x1="96" y1="149.0" x2="796" y2="149.0"/><line x1="96" y1="96.5" x2="796" y2="96.5"/><line x1="96" y1="44.0" x2="796" y2="44.0"/></g>
<g><line x1="96.0" y1="254" x2="96.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="96.0" y="269" text-anchor="middle">0</text><line x1="271.0" y1="254" x2="271.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="271.0" y="269" text-anchor="middle">1</text><line x1="446.0" y1="254" x2="446.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="446.0" y="269" text-anchor="middle">2</text><line x1="621.0" y1="254" x2="621.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="621.0" y="269" text-anchor="middle">3</text><line x1="796.0" y1="254" x2="796.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="796.0" y="269" text-anchor="middle">4</text><line x1="92" y1="254.0" x2="96" y2="254.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="258.0" text-anchor="end">10⁻⁸</text><line x1="92" y1="201.5" x2="96" y2="201.5" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="205.5" text-anchor="end">10⁻⁶</text><line x1="92" y1="149.0" x2="96" y2="149.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="153.0" text-anchor="end">10⁻⁴</text><line x1="92" y1="96.5" x2="96" y2="96.5" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="100.5" text-anchor="end">10⁻²</text><line x1="92" y1="44.0" x2="96" y2="44.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="48.0" text-anchor="end">10⁰</text><rect x="96" y="44" width="700" height="210" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="446.0" y="287" text-anchor="middle">回传的时间步数 t（从 t=0 算起）</text><text class="fg-label" x="56.0" y="149.0" text-anchor="middle" transform="rotate(-90 56.0 149.0)">梯度量级（对数轴）</text></g>
<polyline fill="none" stroke="var(--fig-red)" stroke-width="2.6"stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,59.8 131.0,75.6 148.5,91.4 166.0,107.2 183.5,123.0 201.0,138.8 218.5,154.6 236.0,170.4 253.5,186.2 271.0,202.0 288.5,217.8 306.0,233.6 323.5,249.5 341.0,254.0 358.5,254.0 376.0,254.0 393.5,254.0 411.0,254.0 428.5,254.0 446.0,254.0 463.5,254.0 481.0,254.0 498.5,254.0 516.0,254.0 533.5,254.0 551.0,254.0 568.5,254.0 586.0,254.0 603.5,254.0 621.0,254.0 638.5,254.0 656.0,254.0 673.5,254.0 691.0,254.0 708.5,254.0 726.0,254.0 743.5,254.0 761.0,254.0 778.5,254.0 796.0,254.0"/>
<polyline fill="none" stroke="var(--fig-gold)" stroke-width="2.0"stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,51.9 131.0,59.8 148.5,67.7 166.0,75.6 183.5,83.5 201.0,91.4 218.5,99.3 236.0,107.2 253.5,115.1 271.0,123.0 288.5,130.9 306.0,138.8 323.5,146.7 341.0,154.6 358.5,162.5 376.0,170.4 393.5,178.3 411.0,186.2 428.5,194.1 446.0,202.0 463.5,209.9 481.0,217.8 498.5,225.7 516.0,233.6 533.5,241.6 551.0,249.5 568.5,254.0 586.0,254.0 603.5,254.0 621.0,254.0 638.5,254.0 656.0,254.0 673.5,254.0 691.0,254.0 708.5,254.0 726.0,254.0 743.5,254.0 761.0,254.0 778.5,254.0 796.0,254.0"/>
<polyline fill="none" stroke="var(--fig-purple)" stroke-width="2.0"stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,45.2 131.0,46.4 148.5,47.6 166.0,48.8 183.5,50.0 201.0,51.2 218.5,52.4 236.0,53.6 253.5,54.8 271.0,56.0 288.5,57.2 306.0,58.4 323.5,59.6 341.0,60.8 358.5,62.0 376.0,63.2 393.5,64.4 411.0,65.6 428.5,66.8 446.0,68.0 463.5,69.2 481.0,70.4 498.5,71.6 516.0,72.8 533.5,74.0 551.0,75.2 568.5,76.4 586.0,77.6 603.5,78.8 621.0,80.0 638.5,81.2 656.0,82.4 673.5,83.6 691.0,84.8 708.5,86.0 726.0,87.2 743.5,88.4 761.0,89.6 778.5,90.8 796.0,92.0"/>
<polyline fill="none" stroke="var(--fig-green)" stroke-width="2.6"stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,44.0 131.0,44.0 148.5,44.0 166.0,44.0 183.5,44.0 201.0,44.0 218.5,44.0 236.0,44.0 253.5,44.0 271.0,44.0 288.5,44.0 306.0,44.0 323.5,44.0 341.0,44.0 358.5,44.0 376.0,44.0 393.5,44.0 411.0,44.0 428.5,44.0 446.0,44.0 463.5,44.0 481.0,44.0 498.5,44.0 516.0,44.0 533.5,44.0 551.0,44.0 568.5,44.0 586.0,44.0 603.5,44.0 621.0,44.0 638.5,44.0 656.0,44.0 673.5,44.0 691.0,44.0 708.5,44.0 726.0,44.0 743.5,44.0 761.0,44.0 778.5,44.0 796.0,44.0"/>
<polyline fill="none" stroke="var(--fig-neutral)" stroke-width="1.2"stroke-linejoin="round" stroke-linecap="round" stroke-dasharray="7 5" points="96.0,227.8 796.0,227.8"/>
<text class="diagram-note" fill="var(--fig-neutral)" x="788.0" y="219.8" text-anchor="end">float32 精度地板 ≈10⁻⁷</text>
<g><line x1="116" y1="282" x2="142" y2="282" stroke="var(--fig-red)" stroke-width="2.6"/><text class="diagram-note" x="148" y="286">每步 ×0.25：Sigmoid 饱和段的最坏情形，10 步即 10⁻⁶</text><line x1="116" y1="301" x2="142" y2="301" stroke="var(--fig-gold)" stroke-width="2.0"/><text class="diagram-note" x="148" y="305">每步 ×0.5：典型 tanh 情形</text><line x1="116" y1="320" x2="142" y2="320" stroke="var(--fig-purple)" stroke-width="2.0"/><text class="diagram-note" x="148" y="324">每步 ×0.9：门控（LSTM/GRU）把通道修到接近 1</text><line x1="116" y1="339" x2="142" y2="339" stroke="var(--fig-green)" stroke-width="2.6"/><text class="diagram-note" x="148" y="343">每步 ×1：ReLU 正区 / 细胞态加法通道，连乘不衰减</text></g>
</svg>
<figcaption>梯度消失有多快（本教程计算绘制，纵轴对数）。反向传播沿时间的梯度是**每步雅可比的连乘**：每步因子 0.25 时 10 步衰减 10⁶ 倍、20 步直接跌破 float32 精度地板——这解释了 2.2 节「RNN 记不住长程依赖」与 2.3 节「门控把通道修到接近 1」的全部动机。</figcaption>
</figure>

## 2.4 从压缩瓶颈到注意力机制

先看**序列到序列**（seq2seq）的经典做法：一个 **编码器** RNN 读完整个输入，把信息压进**最后一个隐状态**，作为**上下文向量**交给**解码器** RNN 逐步生成输出。

问题一目了然：无论输入多长，编码器都必须把它塞进**同一个定长向量**（[2.2](#22-rnn沿时间展开的权值共享) 说的信息瓶颈）。句子一长，早期信息在递推中就被冲淡了——翻译长句时开头的主语常被丢掉就是这个原因。

**注意力**（attention）的解法很直接：**别压缩，让解码器每一步都能回看编码器的所有位置**，并**按需加权**。解码器在生成第 $t$ 个词时，给编码器每一个隐状态打一个相关性分数，用分数的 softmax 作权重，对这些隐状态做加权求和作为上下文——需要哪里就看哪里，不再走「全压成一个向量」这道独木桥。

::: def 定义 2.5 · 缩放点积注意力（scaled dot-product attention） {#def-2-5}
给定查询矩阵 $\boldsymbol Q\in\mathbb R^{T_q\times d_k}$、键矩阵 $\boldsymbol K\in\mathbb R^{T_k\times d_k}$、值矩阵 $\boldsymbol V\in\mathbb R^{T_k\times d_v}$，

$$\operatorname{Attention}(\boldsymbol Q,\boldsymbol K,\boldsymbol V)=\operatorname{softmax}\!\left(\frac{\boldsymbol Q\boldsymbol K^{\mathrm T}}{\sqrt{d_k}}\right)\boldsymbol V .$$

分数矩阵 $\boldsymbol Q\boldsymbol K^{\mathrm T}\in\mathbb R^{T_q\times T_k}$ 的第 $(i,j)$ 项是**第 $i$ 个查询与第 $j$ 个键的内积相似度**；softmax **沿键维度**（每行）归一化成权重；再对 $\boldsymbol V$ 的**行**做加权求和，得到每个查询对应的输出。
:::

::: intuition Q / K / V 到底各是什么
用「查字典」类比这三个矩阵，一次就记住：

- **Q（query，查询）**：当前位置**想找什么**。比如解码时「我正在找一个动词的主语」。
- **K（key，键）**：每个位置挂出的**匹配标签**，用来和 query 比对。$\boldsymbol Q\boldsymbol K^{\mathrm T}$ 就是在量「我想找的」和「这里有的」有多像。
- **V（value，值）**：每个位置**真正被取走的内容**。权重算好后，模型实际聚合的是 $\boldsymbol V$，而**不是** $\boldsymbol K$。键负责「指路」，值负责「给货」。

在**自注意力**里，$\boldsymbol Q,\boldsymbol K,\boldsymbol V$ 全部来自**同一个序列**的线性变换——每个位置同时扮演提问者和被检索者。于是每个位置都能**一步**直接读到序列里任意另一个位置，路径长度永远为 $O(1)$：这正是 RNN 递推所做不到的。
:::

::: ex 例 2.2 · 为什么要除以 $\sqrt{d_k}$ {#ex-2-2}
缩放因子 $\sqrt{d_k}$ 不是随手加的装饰，而是为了控制点积的量级。

::: proof 解
设 $\boldsymbol q,\boldsymbol k\in\mathbb R^{d_k}$ 的各分量**相互独立、零均值、单位方差**（$\mathbb E[q_i]=0,\ \operatorname{Var}(q_i)=1$，对 $k_i$ 同理）。对点积 $\boldsymbol q^{\mathrm T}\boldsymbol k=\sum_{i=1}^{d_k}q_ik_i$：

$$\mathbb E[q_ik_i]=\mathbb E[q_i]\,\mathbb E[k_i]=0,\qquad
\operatorname{Var}(q_ik_i)=\mathbb E[q_i^2]\,\mathbb E[k_i^2]=1,$$

各分量独立故方差可加：

$$\mathbb E\bigl[\boldsymbol q^{\mathrm T}\boldsymbol k\bigr]=0,\qquad
\operatorname{Var}\bigl(\boldsymbol q^{\mathrm T}\boldsymbol k\bigr)=\sum_{i=1}^{d_k}\operatorname{Var}(q_ik_i)=d_k .$$

即点积的**标准差是 $\sqrt{d_k}$**，随维度增长。若不缩放，$d_k$ 大时分数会很大且分散，softmax 落进**饱和区**——最大值那一项趋近 $1$、其余趋近 $0$，输出接近 one-hot，梯度几乎为零，训练停滞（与第 1 讲里 Sigmoid 饱和的问题同源）。除以 $\sqrt{d_k}$ 把分数方差拉回 $1$，让 softmax 工作在梯度良好的区间。
:::

:::

<figure>
<svg class="figure-svg" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-lstm-title fig-lstm-desc">
<title id="fig-lstm-title">LSTM 单元：三门与细胞状态的加法通道</title>
<desc id="fig-lstm-desc">LSTM 单元结构：遗忘门 f、输入门 i、输出门 o 为 σ 门控；细胞状态 c 沿顶部加法通道传递（c_t = f⊙c_{t−1} + i⊙c̃）；h_t = o⊙tanh(c_t)。</desc>
<defs></defs>
<text class="diagram-note" fill="var(--fig-green)" x="30" y="30" text-anchor="start" font-weight="700">细胞状态 c：一条「梯度高速公路」（绿）</text>
<line x1="80" y1="70" x2="760" y2="70" stroke="var(--fig-green)" stroke-width="3.2" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="70" y="75" text-anchor="end" font-size="14px">cₜ₋₁</text>
<text class="diagram-mono" fill="var(--fig-green)" x="778" y="75" text-anchor="start" font-size="14px">cₜ</text>
<circle cx="330" cy="70" r="15" fill="var(--fig-gold)" fill-opacity="0.10" stroke="var(--fig-gold)" stroke-width="1.6"/>
<text class="diagram-mono" x="330" y="74.5" text-anchor="middle" font-size="16px">×</text>
<circle cx="610" cy="70" r="15" fill="var(--fig-blue)" fill-opacity="0.10" stroke="var(--fig-blue)" stroke-width="1.6"/>
<text class="diagram-mono" x="610" y="74.5" text-anchor="middle" font-size="16px">+</text>
<text class="diagram-mono" fill="var(--fig-gold)" x="300" y="44" text-anchor="end" font-size="12.5px">f ⊙ cₜ₋₁</text>
<rect x="60" y="180" width="150" height="90" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="135.0" y="229.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="135" y="212" text-anchor="middle" font-size="14px">[ hₜ₋₁ ; xₜ ]</text>
<text class="diagram-note" fill="muted" x="135" y="236" text-anchor="middle" font-size="12px">拼接输入</text>
<rect x="240" y="100" width="200" height="38" rx="9" fill="var(--fig-gold)" fill-opacity="0.1" stroke="var(--fig-gold)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="123.5" text-anchor="middle" font-size="11.5px">f = σ(W_f·[h,x]+b_f)</text>
<text class="diagram-note" fill="var(--fig-gold)" x="452" y="124" text-anchor="start" font-size="12px">遗忘门</text>
<line x1="212" y1="225" x2="238" y2="119" stroke="var(--fig-gold)" stroke-width="1.3" marker-end="url(#mk-gold)"/>
<rect x="240" y="160" width="200" height="38" rx="9" fill="var(--fig-blue)" fill-opacity="0.1" stroke="var(--fig-blue)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="183.5" text-anchor="middle" font-size="11.5px">i = σ(W_i·[h,x]+b_i)</text>
<text class="diagram-note" fill="var(--fig-blue)" x="452" y="184" text-anchor="start" font-size="12px">输入门</text>
<line x1="212" y1="225" x2="238" y2="179" stroke="var(--fig-blue)" stroke-width="1.3" marker-end="url(#mk-blue)"/>
<rect x="240" y="220" width="200" height="38" rx="9" fill="var(--fig-green)" fill-opacity="0.1" stroke="var(--fig-green)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="243.5" text-anchor="middle" font-size="11.5px">c̃ = tanh(W_c·[h,x]+b_c)</text>
<text class="diagram-note" fill="var(--fig-green)" x="452" y="244" text-anchor="start" font-size="12px">候选记忆</text>
<line x1="212" y1="225" x2="238" y2="239" stroke="var(--fig-green)" stroke-width="1.3" marker-end="url(#mk-green)"/>
<rect x="240" y="300" width="200" height="38" rx="9" fill="var(--fig-purple)" fill-opacity="0.1" stroke="var(--fig-purple)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="323.5" text-anchor="middle" font-size="11.5px">o = σ(W_o·[h,x]+b_o)</text>
<text class="diagram-note" fill="var(--fig-purple)" x="452" y="324" text-anchor="start" font-size="12px">输出门</text>
<line x1="212" y1="225" x2="238" y2="319" stroke="var(--fig-purple)" stroke-width="1.3" marker-end="url(#mk-purple)"/>
<line x1="330" y1="100" x2="330" y2="88" stroke="var(--fig-gold)" stroke-width="1.6" marker-end="url(#mk-gold)"/>
<circle cx="505" cy="210" r="14" fill="var(--fig-blue)" fill-opacity="0.10" stroke="var(--fig-blue)" stroke-width="1.6"/>
<text class="diagram-mono" x="505" y="214.5" text-anchor="middle" font-size="14px">⊗</text>
<line x1="440" y1="179" x2="493" y2="202" stroke="var(--fig-blue)" stroke-width="1.4" marker-end="url(#mk-blue)"/>
<line x1="440" y1="239" x2="493" y2="218" stroke="var(--fig-green)" stroke-width="1.4" marker-end="url(#mk-green)"/>
<path d="M 517 202 C 570 200 604 150 610 88" fill="none" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#mk-blue)"/>
<text class="diagram-mono" fill="var(--fig-blue)" x="560" y="172" text-anchor="start" font-size="12.5px">i ⊙ c̃</text>
<rect x="590" y="150" width="130" height="38" rx="9" fill="var(--fig-green)" fill-opacity="0.1" stroke="var(--fig-green)" stroke-width="1.5"/>
<text class="diagram-mono" x="655.0" y="173.5" text-anchor="middle" font-size="13px">tanh(cₜ)</text>
<path d="M 700 76 C 700 112 688 132 660 148" fill="none" stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#mk-green)"/>
<circle cx="752" cy="169" r="14" fill="var(--fig-purple)" fill-opacity="0.10" stroke="var(--fig-purple)" stroke-width="1.6"/>
<text class="diagram-mono" x="752" y="173.5" text-anchor="middle" font-size="14px">⊗</text>
<line x1="720" y1="169" x2="738" y2="169" stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#mk-green)"/>
<path d="M 440 319 C 600 319 700 260 745 183" fill="none" stroke="var(--fig-purple)" stroke-width="1.6" marker-end="url(#mk-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="600" y="292" text-anchor="start" font-size="13px">o</text>
<line x1="766" y1="169" x2="800" y2="169" stroke="var(--fig-purple)" stroke-width="2.0" marker-end="url(#mk-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="806" y="152" text-anchor="start" font-size="12.5px">hₜ =</text>
<text class="diagram-mono" fill="var(--fig-purple)" x="806" y="172" text-anchor="start" font-size="12.5px">o⊙tanh(cₜ)</text>
<rect x="60" y="358" width="780" height="34" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="450.0" y="379.5" text-anchor="middle"></text>
<text class="diagram-note" fill="ink" x="450" y="374" text-anchor="middle" font-size="12.5px">关键在顶部的加法通道：cₜ = f⊙cₜ₋₁ + i⊙c̃ —— 梯度对 cₜ₋₁ 的雅可比是 f≈1，不随步数连乘衰减</text>
</svg>
<figcaption>LSTM 单元（本教程绘）。三个 σ 门（金=遗忘 f、蓝=输入 i、紫=输出 o）决定信息去留；顶部绿色的细胞状态 c 是一条**加法**通道——cₜ = f⊙cₜ₋₁ + i⊙c̃ 中，梯度对 cₜ₋₁ 的雅可比就是 f≈1，连乘不衰减，长程记忆由此而来。</figcaption>
</figure>

## 2.5 Transformer：把注意力堆成主干

Transformer 的核心主张是：**只靠注意力 + 前馈层**就能建起序列模型，完全去掉递推。这样第 $t$ 个位置不再依赖第 $t-1$ 步的**串行**计算，所有位置可以**并行**处理。

::: def 定义 2.6 · 多头自注意力（multi-head self-attention） {#def-2-6}
把注意力**并行做 $h$ 次**。第 $j$ 个头用自己的投影矩阵 $W_j^Q,W_j^K,W_j^V$ 从输入 $\boldsymbol X$ 得到 $\boldsymbol Q_j=\boldsymbol XW_j^Q$、$\boldsymbol K_j=\boldsymbol XW_j^K$、$\boldsymbol V_j=\boldsymbol XW_j^V$，各自独立算一次缩放点积注意力，再拼接、投影融合：

$$\operatorname{head}_j=\operatorname{Attention}\bigl(\boldsymbol XW_j^Q,\ \boldsymbol XW_j^K,\ \boldsymbol XW_j^V\bigr),$$

$$\operatorname{MHA}(\boldsymbol X)=\bigl[\operatorname{head}_1;\dots;\operatorname{head}_h\bigr]W^O .$$

每个头在**自己的子空间**里关注不同的关系（一个头管语法主谓、另一个头管指代、再一个头管局部相邻……）；拼接后由 $W^O$ 线性融合。单个头的 softmax 只能给出一组权重，多头则允许**同时**并行地表达多种注意力模式。
:::

**Transformer 块**由两个子层交替堆叠，每个子层都带**残差连接**与 **LayerNorm**：

$$\boldsymbol Z=\operatorname{LN}\bigl(\boldsymbol X+\operatorname{MHA}(\boldsymbol X)\bigr),\qquad
\boldsymbol Y=\operatorname{LN}\bigl(\boldsymbol Z+\operatorname{FFN}(\boldsymbol Z)\bigr),\qquad
\operatorname{FFN}(\boldsymbol z)=W_2\,\phi(W_1\boldsymbol z+\boldsymbol b_1)+\boldsymbol b_2 .$$

- **前馈层（FFN）**：一个逐位置独立应用的两层 MLP（对所有位置共享同一套权重）。注意力负责**跨位置**混合信息，FFN 负责在**每个位置内部**做非线性变换——两者一横一纵。
- **残差连接**：给梯度一条恒等短路，让深层可训练（第 1 讲里「梯度连乘衰减」的解药）。
- **LayerNorm**：在同一位置的**特征维度**上做归一化，稳定每层激活的分布、加速收敛。二者合起来是「深堆 Transformer」的前提。

### 位置编码：注意力本身不认顺序

这里有一个极易被忽略、却是 Transformer 设计的关键事实：**自注意力对输入位置是置换等变的**（permutation equivariant）。

::: intuition 打乱输入的行，输出只是同样被打乱
设 $\boldsymbol P$ 是一个置换矩阵，用它左乘输入 $\boldsymbol X$ 就是把行（位置）重新排列。代入注意力式：

$$\operatorname{softmax}\!\left(\frac{(\boldsymbol {PX})\boldsymbol K^{\mathrm T}}{\sqrt{d_k}}\right)\boldsymbol V
=\boldsymbol P\cdot\operatorname{softmax}\!\left(\frac{\boldsymbol X\boldsymbol K^{\mathrm T}}{\sqrt{d_k}}\right)\boldsymbol V
=\boldsymbol P\,\operatorname{Attention}(\boldsymbol X,\boldsymbol K,\boldsymbol V).$$

（软件里逐行做 softmax，与置换可交换；$\boldsymbol P$ 作用于输出的行。）这说明：**把序列词序打乱，注意力输出只是跟着打乱，每个位置拿到的上下文一模一样**。也就是说，纯注意力**根本不知道谁在前、谁在后**——「狗咬人」和「人咬狗」对它没有区别。这正是一句名言的反面：注意力**因为**不含顺序，才**必须**显式把位置信息灌进去。
:::

::: def 定义 2.7 · 位置编码（positional encoding） {#def-2-7}
给每个位置 $pos$ 和维度索引 $i$ 生成一个向量 $\boldsymbol{PE}_{pos}$，**加到输入嵌入上**（$\boldsymbol x_{pos}\leftarrow\boldsymbol x_{pos}+\boldsymbol{PE}_{pos}$），把顺序信息注入进去。原始 Transformer 用的是**正弦式**编码：

$$PE_{(pos,\,2i)}=\sin\!\left(\frac{pos}{10000^{\,2i/d_{\mathrm{model}}}}\right),\qquad
PE_{(pos,\,2i+1)}=\cos\!\left(\frac{pos}{10000^{\,2i/d_{\mathrm{model}}}}\right).$$

不同频率的正弦 / 余弦给出位置的**唯一指纹**；相对位移还能被表达为位置向量的线性变换，因此模型容易学到「相隔 $k$ 步」这类相对关系。实践中**学习式**位置嵌入（当作可训练参数）同样常用，且适用于有固定最大长度的场景。
:::

::: think 为什么是"加"而不是"接"
把位置向量**相加**到词嵌入上，看似会与词义互相污染，但只要嵌入维度足够高，模型就能留出一部分子空间专门编码位置——相加等价于让「词身份 + 位置」共享同一段表示预算。拼接（concatenate）会增大维度、也可行，但相加更省参数、更简单，且被原始设计验证足够好用。
:::

### 复杂度与长序列瓶颈

自注意力的核心运算是 $\boldsymbol Q\boldsymbol K^{\mathrm T}$：$\boldsymbol Q\in\mathbb R^{T\times d_k}$、$\boldsymbol K^{\mathrm T}\in\mathbb R^{d_k\times T}$，乘积是 $T\times T$ 的分数矩阵，代价 $O(T^2 d_k)$；其后 softmax 与 $\cdot\,\boldsymbol V$ 也是 $O(T^2 d_v)$。于是

$$\text{自注意力复杂度}=O(T^2 d).$$

**对序列长度是平方的**：序列翻倍，算力与显存开销约翻四倍（那一张 $T\times T$ 的注意力矩阵就占 $O(T^2)$ 内存）。这是 Transformer 处理**长序列**的头号瓶颈，也是后续一大类改进的着力点——稀疏 / 局部注意力、线性注意力、以及把注意力与递推混合的架构，都是在「保住全局建模能力」与「压掉 $T^2$」之间做取舍。

::: method 编码器 / 解码器与自回归生成 {#method-2-2}
- **编码器块**：自注意力（双向，每个位置看全序列）+ FFN。用于理解整段输入，位置之间无因果限制。
- **解码器块**：三明治结构——**带因果 mask 的自注意力** + **对编码器输出的交叉注意力** + FFN。交叉注意力里 $\boldsymbol Q$ 来自解码器、$\boldsymbol K,\boldsymbol V$ 来自编码器输出，实现「生成时回看源句」。
- **因果 mask（自回归的关键）**：在生成第 $t$ 个 token 时，位置 $t$ **只允许看 $\le t$ 的位置**。实现方式是把分数矩阵上三角部分（未来位置）在 softmax 前置为 $-\infty$，使权重归零。
- **训练可并行、生成却是串行**：训练时对每个位置同时预测下一个 token（$p(\boldsymbol x_t\mid\boldsymbol x_{\lt t})$），一次前向算完全部损失；生成时没有未来答案，只能**逐 token** 采样、把新 token 接回输入再算下一步——这就是**自回归**的代价。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 900 350" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-attn-title fig-attn-desc">
<title id="fig-attn-title">缩放点积注意力：一只头的数据流与形状</title>
<desc id="fig-attn-desc">注意力数据流：Q 与 Kᵀ 相乘得 T×T 的相关度矩阵，除以 √d_k 后逐行 softmax 得权重，再右乘 V 得输出；多头即并排 H 份、最后拼接线性变换。</desc>
<defs></defs>
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
<text class="diagram-text" x="260.0" y="340.5" text-anchor="middle"></text>
<text class="diagram-note" fill="ink" x="260" y="334" text-anchor="middle" font-size="12.5px">多头 = 并排 H 份（各自 d_k = d/H），拼接后线性变换——不同头看不同子空间</text>
<rect x="500" y="316" width="340" height="40" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="670.0" y="340.5" text-anchor="middle"></text>
<text class="diagram-note" fill="ink" x="670" y="334" text-anchor="middle" font-size="12.5px">复杂度 O(T²·d)：T 加倍，算力×4 —— 长序列的平方瓶颈（2.5 节）</text>
</svg>
<figcaption>缩放点积注意力的数据流（本教程绘，形状以 B×T 序列为例）。三路输入各司其职：Q 提问、K 应答、V 交货；÷√d_k 防止点积方差 ∝ d_k 把 softmax 推入饱和区（例 2.2）；多头即并排若干份、各看一个子空间。平方复杂度 O(T²d) 是 Transformer 长序列瓶颈的根源。</figcaption>
</figure>

## 2.6 课堂应用导读：Lab 1 的音乐生成

[Lab 1](../labs/lab1.md) 用一个最小的语言模型思路做音乐生成，本讲的结构会在那里跑通一遍。

**把音乐变成 token 序列**。音乐不是文本，但可以编码成序列：用 ABC 记谱把旋律写成字符流，或把 MIDI 的「音符 / 音高 / 时长 / 起止」等**事件**离散化为 token。这样一段旋律就是一个 token 序列，音符与音符之间的**顺序、重复、主题再现**——恰好是序列模型擅长捕捉的结构。每个 token 做 one-hot，喂给 RNN / LSTM。

**训练**。用自回归目标：给定前缀 token，预测下一个 token，损失是逐位置的交叉熵（第 1 讲）。让模型学会 $p(\text{下一个 token}\mid\text{之前的 token})$——本质上是学到了「什么样的旋律听起来合理」的隐式分布。

**生成**。从一小段**初始旋律**（seed）或一个起始 token 出发，每一步输出对下一个 token 的概率分布，**采样**出一个 token，把它接回输入，再预测再采样——旋律就这样**逐步长出来**。这也是第 4 讲生成建模的同一个「逐步采样」套路。

::: method 温度采样（temperature sampling） {#method-2-3}
模型每步给出的是 logits $\boldsymbol z$。直接取 argmax 会得到最确定但**单调重复**的旋律；直接按原概率采样又可能太跳脱。**温度** $\tau\gt0$ 在两者之间连续调节：

$$\hat p_i=\frac{\exp(z_i/\tau)}{\sum_j\exp(z_j/\tau)} .$$

- $\tau\to0$：分布趋近 one-hot，退化为**贪心**——最保守、最"安全"，但容易陷入循环、缺乏新意；
- $\tau=1$：忠实使用模型的原始分布；
- $\tau\gt1$：分布被**压平**，低概率 token 也被抬高——输出更**多样、更出人意料**，但也更容易跑调、结构松散。

**实践**：在验证集上先粗扫 $\tau$（例如先试几个量级差一档的取值），在「音乐是否连贯」与「是否有变化」之间人工试听挑选；配合 top-$k$ / top-$p$ 截断（只在概率最高的前若干个 token 里采样）通常比单独调 $\tau$ 更稳。
:::

## 2.7 本讲陷阱

::: errata 常见误解清单
1. **「序列越长越该用 RNN」**：恰恰相反——长程依赖正是 RNN 的**短板**。要记住上百步之前的依赖，递推的连乘雅可比几乎必然消失或爆炸，而注意力可以 $O(1)$ 直达任意位置。长序列应优先考虑注意力类结构（同时正视它的 $O(T^2d)$ 成本）。
2. **「注意力没有顺序概念，所以位置编码可有可无」**：正好反了。注意力**置换等变**，不给位置编码它就把「狗咬人」和「人咬狗」当成一回事。**位置编码不是可选项，是必需品。**
3. **「RNN 不能并行，所以一无是处」**：训练不能沿时间并行是事实，但推理时 RNN 每步只需 $O(1)$ 状态与计算、天然支持**流式与无限长输入**，显存不随序列增长；在设备端、流式信号、小数据场景里它仍是有竞争力的选择。
4. **「$\boldsymbol h_t$ 记住了全部历史」**：固定维度的隐状态是**有损摘要**，越早的信息越容易被覆盖。别指望 RNN 精确回忆远处的细节。
5. **「梯度裁剪解决了梯度消失」**：裁剪只压制**爆炸**（防溢出），对**消失**无效——梯度已经接近零，等比缩放救不回来。消失要靠门控（LSTM / GRU）、重置初始化或残差结构。
6. **「LSTM 门越多越好，一定强于 GRU / 朴素 RNN」**：门控缓解了梯度问题，但带来更多参数与计算；**GRU 用两个门在许多任务上与 LSTM 相当甚至更划算**。谁更好取决于数据规模与任务，不存在无条件最优。
7. **「Transformer 全面强于 RNN」**：Transformer 的优势建立在**大数据 + 长程建模 + 可并行**上；数据很少时，RNN / CNN 这类带强**归纳偏置**的结构反而更不容易过拟合。结构要与数据量、序列长度、部署约束匹配。
8. **「自回归训练忘了加因果 mask」**：这是最隐蔽也最致命的一个 bug。mask 缺失时位置 $t$ 能看到未来的真实 token，训练损失降得很漂亮，但生成时没有「未来」可看，质量立刻崩坏。**看到"训练完美、生成崩坏"，先查 mask。**
9. **「把注意力权重当成可解释的因果」**：注意力权重是一种**中间计算量**，权重高不等于该位置对输出重要（值、后续层、残差都在起作用）。把它当作唯一的解释证据是不严谨的。
:::

## 2.8 本讲小结

**三句话带走**：

1. 序列的三个要求（**变长 / 保序 / 参数共享**）引出**沿时间展开的递推**：$\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h)$，权重在每个时间步复用，隐状态是过往信息的定长摘要。
2. 递推的连乘雅可比导致**梯度消失 / 爆炸**——**裁剪**治爆炸，**门控**（LSTM / GRU 的加法式细胞状态）治消失；而**注意力**把「整句压成一个向量」换成「对所有位置加权聚合」，**Transformer** 用多头自注意力 + 前馈层 + 残差 / LayerNorm + 位置编码，把序列建模变成可并行、可深堆的架构，代价是 $O(T^2d)$ 的长序列瓶颈。
3. 生成任务的统一动作是**自回归 + 采样**：把上一步输出接回输入逐步生成，用**温度**、top-$k$ / top-$p$ 在「连贯」与「多样」之间调速。

**与后续的连接**：[Lab 1](../labs/lab1.md) 用 RNN / LSTM 把「音符当 token」的音乐生成跑一遍；[第 4 讲](lec04.md)把这里的「逐步采样」正式发展成生成建模；[第 6 讲](lec06.md)的新前沿（预训练、注意力之后的演进）与[第 9 讲](lec09.md)的大规模并行训练，全部以本讲的 **Transformer** 为主干——你今天在 2.5 节写下的那三个公式，就是它们的起点。
