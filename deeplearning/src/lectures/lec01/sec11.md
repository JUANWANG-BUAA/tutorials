# 1.1 从神经元到感知机

深度学习的原子单元是一个**函数**：把输入按权重加权求和、加偏置、再过一次非线性。本教程的第一节不急着堆层，只回答三个问题：这个函数长什么样？它能做什么、不能做什么？「学习」在这里意味着什么？

这一节的结论会成为全书的起点：**单层结构的能力边界是「线性可分」**，跨过这条边界的唯一办法是先变换、再切分——这就是「深度」的由来。

## 1.1.1 人工神经元的定义

历史线索：McCulloch 与 Pitts 在 1943 年给出第一个形式化神经元模型（阈值单元 *threshold unit*），Rosenblatt 在 1958 年把它变成可学习的分类器（感知机），Minsky 与 Papert 在 1969 年指出它的能力边界，反向传播在 1980 年代给出跨过边界的办法。四个节点构成了本节到第 1.5 节的完整线索。

::: def 定义 1.1.1 · 神经元（neuron） {#def-1.1.1}
给定输入 $\boldsymbol x\in\mathbb R^n$、权向量 $\boldsymbol w\in\mathbb R^n$、偏置 $b\in\mathbb R$ 与激活函数 $\phi:\mathbb R\to\mathbb R$，神经元的输出为

$$z=\sum_{i=1}^{n}w_ix_i+b=\boldsymbol w^{\mathrm T}\boldsymbol x+b,\qquad a=\phi(z).$$

$z$ 称为**预激活**（pre-activation），$a$ 称为**激活值**（activation）或输出。
:::

::: intuition 拆开看，每个符号各管一件事
$w_i$ 回答「第 $i$ 个输入有多重要」，$b$ 回答「整体上要有多容易被激活」，$\phi$ 回答「这个单元的输出长什么样」。**加权求和 + 偏置**只能在输入空间里划一刀（一个超平面），**$\phi$ 决定这一刀怎么被「读出来」**：阶跃读出 0/1 判决、Sigmoid 读出概率、ReLU 读出「只在正方向放行」的强度。第 1.3 节会看到：$\phi$ 的选择直接决定深层网络能不能训得动。
:::

写成矩阵形式（一批数据一次算完）：

::: method 批量形式与形状约定 {#method-1.1.1}
设批大小 $B$、特征维 $n$、输出维 $m$：

| 量 | 形状 | 说明 |
|:--|:--|:--|
| $\boldsymbol X$ | $B\times n$ | 一批输入，一行一个样本 |
| $W$ | $n\times m$ | 权矩阵，一列一个输出单元 |
| $\boldsymbol b$ | $m$ | 偏置向量（广播到每个样本） |
| $\boldsymbol Z=\boldsymbol XW+\mathbf 1\boldsymbol b^{\mathrm T}$ | $B\times m$ | 预激活 |
| $A=\phi(\boldsymbol Z)$ | $B\times m$ | 激活（逐元素） |

本书统一采用「**批优先**」（batch-first）约定：张量的第 0 维永远是批维，且**前向过程中批维大小不变**。这一条是后面所有形状推演的基准，也是排查维度错误时的第一根救命绳。
:::

## 1.1.2 感知机：一个会「学」的线性分类器

把激活取成**阶跃函数** $\phi(z)=\mathbf 1[z\ge0]$，再规定「输出 1 记为正类、0 记为负类」，这个神经元就是最早的**感知机**（perceptron）：$z=0$ 是一条超平面，把输入空间切成两半。

::: def 定义 1.1.2 · 感知机与线性可分 {#def-1.1.2}
**感知机**（perceptron）是激活为阶跃函数、输出经阈值判决的单个神经元，它对输入 $\boldsymbol x$ 的预测为

$$\hat y=\mathbf 1[\boldsymbol w^{\mathrm T}\boldsymbol x+b\ge0].$$

数据集 $\{(\boldsymbol x_i,y_i)\}_{i=1}^{N}$（$y_i\in\{-1,+1\}$）称为**线性可分**（linearly separable），若存在 $\boldsymbol w,b$ 使

$$y_i\bigl(\boldsymbol w^{\mathrm T}\boldsymbol x_i+b\bigr)\gt0,\qquad i=1,\dots,N .$$
:::

**「学习」= 用错误驱动地转超平面。** 感知机学习规则（Rosenblatt 1958）极其朴素：错一个样本，就把超平面往能把它分对的方向推一点。

::: thm 定理 1.1.1 · 感知机收敛定理（Novikoff, 1962） {#thm-1.1.1}
若训练集**线性可分**且**有界**（$\lVert\boldsymbol x_i\rVert\le R$），则对任意间隔 $\gamma\gt0$（满足 $y_i(\boldsymbol w^\star{}^{\mathrm T}\boldsymbol x_i+b^\star)\ge\gamma$ 的 $\boldsymbol w^\star$ 存在），感知机学习规则在至多

$$k\le\left(\frac{R}{\gamma}\right)^{2}$$

次更新后停止，得到一个**完全正确地分开训练集**的超平面。
:::

::: proof 证明（骨架：把「更新一次」的进展量化为两个不等式）
设 $\boldsymbol\theta=(\boldsymbol w,b)$、$\tilde{\boldsymbol x}_i=(\boldsymbol x_i,1)$。每次对误分类样本 $i$ 更新 $\boldsymbol\theta\leftarrow\boldsymbol\theta+\eta y_i\tilde{\boldsymbol x}_i$。

**(i) 与最优方向的夹角只会变小。** 取间隔单位化的 $\boldsymbol\theta^\star$（$\lVert\boldsymbol\theta^\star\rVert=1$），则
$$\boldsymbol\theta_{k}^{\mathrm T}\boldsymbol\theta^\star\ge\boldsymbol\theta_{k-1}^{\mathrm T}\boldsymbol\theta^\star+\eta\gamma\ \Longrightarrow\ \boldsymbol\theta_{k}^{\mathrm T}\boldsymbol\theta^\star\ge k\eta\gamma .$$

**(ii) 范数增长受控。** 因只对误分类样本更新（$y_i\boldsymbol\theta_{k-1}^{\mathrm T}\tilde{\boldsymbol x}_i\le0$），
$$\lVert\boldsymbol\theta_k\rVert^2=\lVert\boldsymbol\theta_{k-1}\rVert^2+2\eta y_i\boldsymbol\theta_{k-1}^{\mathrm T}\tilde{\boldsymbol x}_i+\eta^2\lVert\tilde{\boldsymbol x}_i\rVert^2\le\lVert\boldsymbol\theta_{k-1}\rVert^2+\eta^2R^2,$$
故 $\lVert\boldsymbol\theta_k\rVert^2\le k\eta^2R^2$。

由 $\cos\angle(\boldsymbol\theta_k,\boldsymbol\theta^\star)=\dfrac{\boldsymbol\theta_k^{\mathrm T}\boldsymbol\theta^\star}{\lVert\boldsymbol\theta_k\rVert}\le1$ 得 $\dfrac{k\eta\gamma}{\eta R\sqrt k}\le1$，即 $k\le(R/\gamma)^2$。$\blacksquare$
:::

::: intuition 收敛定理真正说了什么
三句话：① **线性可分时一定收敛**（不会无限打转）；② **收敛步数由数据决定**——间隔 $\gamma$ 越小、数据尺度 $R$ 越大，越慢，且它**与学习率 $\eta$ 无关**（$\eta$ 只放大或缩小参数的尺度，不改变需要更新的次数）；③ 定理**没说**不可分时会怎样——事实上不可分时它永不收敛，会一直震荡。更糟的是：即便可分，这个算法对**噪声标签**也毫无抵抗力，这是它后来被梯度方法取代的直接原因。
:::

::: note[skip] 感知机收敛定理的常见误用
「感知机一定会收敛」是**条件结论**：要求数据严格线性可分且范数有界。工程上常见的数据集几乎不满足前者；把它当成「训练一定成功」的保证，是历史上一类典型误读。想更深入地看间隔与泛化关系，可从支持向量机（最大间隔视角）切入——那是「用间隔换泛化」的正统做法。
:::

## 1.1.3 能力的边界：异或问题

单个神经元只能划一刀。这条边界在哪？答案是**异或（XOR）**。

::: ex 例 1.1.1 · 单个感知机解不了 XOR {#ex-1.1.1}
输入 $(x_1,x_2)\in\{0,1\}^2$，标签 $y=x_1\oplus x_2$（相同为 0、不同为 1）。证明：不存在 $\boldsymbol w,b$ 使四个点全部被正确分类。
::: proof 解
四个点的约束依次为（约定 $y=1\Rightarrow z\ge0$，$y=0\Rightarrow z\lt0$）：

$$(0,0)\mapsto0:\ b\lt0,\qquad (1,1)\mapsto0:\ w_1+w_2+b\lt0,$$
$$(1,0)\mapsto1:\ w_1+b\ge0,\qquad (0,1)\mapsto1:\ w_2+b\ge0 .$$

把后两式相加得 $w_1+w_2+2b\ge0$；而由 $b\lt0$ 与 $w_1+w_2+b\lt0$ 得 $w_1+w_2+2b\lt w_1+w_2+b\lt0$，与上式矛盾。故无解。$\blacksquare$
:::
:::

**几何读法**：四个点构成一个「对角同色」的棋盘，正类在对角线上、负类在另一条对角线上。任何一条直线都无法把两条对角线分开——因为两类在二维空间里**不是线性可分的**。

**出路不是切得更花哨，而是先变换、再切分。** 把输入抬到新空间 $\boldsymbol h=(\mathbf 1[x_1\ \text{AND}\ \lnot x_2],\ \mathbf 1[\lnot x_1\ \text{AND}\ x_2])$，那么在新空间里两类退化成两个可分点；再用一个神经元做一次 OR（或等价地，一次简单线性判别）即可。**两层非线性结构解决了一层线性结构做不到的事**——这是「深度」的第一块基石。

<figure>
<svg class="figure-svg" viewBox="0 0 900 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-xor-title fig-xor-desc">
<title id="fig-xor-title">异或问题：单层线性不可分，先变换后可分</title>
<desc id="fig-xor-desc">左图：原始输入空间 (x1,x2) 中四个点，正类在 (1,0)、(0,1)，负类在 (0,0)、(1,1)，任何直线都无法分开两类。右图：先做特征变换 h=(x1 AND NOT x2, NOT x1 AND x2)，正类映射到 (1,0) 与 (0,1)，负类映射到 (0,0)，再由一层线性判别分开。</desc>
<defs>
<marker id="mk-neutral-xor" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
<path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-neutral)"/>
</marker>
</defs>
<rect x="120" y="30" width="180" height="180" fill="none" stroke="var(--line-strong)"/>
<line x1="120" y1="210" x2="300" y2="210" stroke="var(--line-strong)"/>
<line x1="120" y1="210" x2="120" y2="30" stroke="var(--line-strong)"/>
<circle cx="120" cy="210" r="7" fill="var(--fig-blue)" fill-opacity="0.9"/>
<circle cx="300" cy="30" r="7" fill="var(--fig-blue)" fill-opacity="0.9"/>
<circle cx="300" cy="210" r="7" fill="var(--fig-red)" fill-opacity="0.9"/>
<circle cx="120" cy="30" r="7" fill="var(--fig-red)" fill-opacity="0.9"/>
<text class="diagram-mono" fill="muted" x="128" y="232" font-size="13px">(0,0)</text>
<text class="diagram-mono" fill="muted" x="238" y="232" font-size="13px">(1,0)</text>
<text class="diagram-mono" fill="muted" x="128" y="22" font-size="13px">(0,1)</text>
<text class="diagram-mono" fill="muted" x="240" y="22" font-size="13px">(1,1)</text>
<text class="diagram-note" fill="ink" x="210" y="128" text-anchor="middle" font-size="14px">任何直线都分不开</text>
<text class="diagram-note" fill="var(--fig-red)" x="210" y="150" text-anchor="middle" font-size="13px">正类在对角线上</text>
<text class="diagram-note" fill="ink" x="120" y="272" font-size="14px" font-weight="700">① 原始空间</text>
<line x1="360" y1="120" x2="430" y2="120" stroke="var(--fig-neutral)" stroke-width="1.6" marker-end="url(#mk-neutral-xor)"/>
<text class="diagram-note" fill="muted" x="395" y="108" text-anchor="middle" font-size="13px">特征变换 h</text>
<rect x="470" y="30" width="180" height="180" fill="none" stroke="var(--line-strong)"/>
<line x1="470" y1="210" x2="650" y2="210" stroke="var(--line-strong)"/>
<line x1="470" y1="210" x2="470" y2="30" stroke="var(--line-strong)"/>
<circle cx="470" cy="210" r="7" fill="var(--fig-blue)" fill-opacity="0.9"/>
<circle cx="470" cy="30" r="7" fill="var(--fig-red)" fill-opacity="0.9"/>
<circle cx="650" cy="30" r="7" fill="var(--fig-red)" fill-opacity="0.9"/>
<line x1="452" y1="200" x2="668" y2="60" stroke="var(--fig-green)" stroke-width="1.8" stroke-dasharray="6 4"/>
<text class="diagram-note" fill="var(--fig-green)" x="600" y="86" font-size="13px">一层即可分开</text>
<text class="diagram-note" fill="ink" x="470" y="272" font-size="14px" font-weight="700">② 变换后的空间</text>
<text class="diagram-note" fill="muted" x="716" y="96" font-size="13px">结论：单层的能力边界</text>
<text class="diagram-note" fill="muted" x="716" y="118" font-size="13px">= 线性可分；跨过边界</text>
<text class="diagram-note" fill="muted" x="716" y="140" font-size="13px">只能靠「先变换、再切」</text>
</svg>
<figcaption>异或问题的两种读法（本教程绘制）：左为原始输入空间，两类在对角上，线性不可分；右为先做一层非线性特征变换后的空间，两类变成可用一条直线分开。这就是「多层结构」存在的第一性理由（见 1.2 节与例 1.1.1）。</figcaption>
</figure>

## 1.1.4 从感知机到现代神经元：三处关键改动

从 1958 年的感知机到今天默认的神经元，改的只有三件事，但每一件都决定了深度学习能否成立。

::: method 三处改动与它们各自解决的问题 {#method-1.1.2}
| 改动 | 从 | 到 | 解决了什么 |
|:--|:--|:--|:--|
| **激活函数** | 阶跃 $\mathbf 1[z\ge0]$ | Sigmoid / tanh / **ReLU** | 阶跃函数几乎处处导数为 0，无法用梯度方法学习；光滑激活让梯度有定义 |
| **学习信号** | 错误驱动的离散更新 | **损失的梯度** $\nabla_\theta\mathcal L$ | 可以处理不可分数据、噪声标签，并可推广到多层与任意任务 |
| **组合方式** | 单个单元 | **多单元分层堆叠** | 手工设计特征变换（如上面 XOR 的两个 AND 单元）不可扩展；让网络自己学出中间表示 |

需要注意：**第一处改动是「必要条件」而不是「充分条件」**。把阶跃换成 Sigmoid 之后，单层结构的能力边界**没有改变**——它仍然只能表达线性可分函数（证明见本节习题 B3）。真正跨过边界的是第三处的**分层**，而能训练分层结构的工具是第二处的**梯度**。三者缺一，现代深度学习都不成立。
:::

::: errata 本节的四个常见误解
1. **「感知机 = 神经网络」**：感知机是「单层、阶跃激活」的特例；现代神经元允许任意光滑激活，并且通常以层为单位出现。
2. **「Sigmoid 是感知机的直接升级，所以单层 Sigmoid 单元更强」**：错。激活换光滑后**表达能力没变**（单层仍是线性判别面），变的是「可以用梯度训练」。能力来自分层，不来自激活的光滑性。
3. **「异或反例说明感知机没用」**：Minsky 与 Papert 的论证针对的是**单层**结构，并且他们清楚多层可以解决；历史上把它读成「连接主义整体被证伪」，是过度解读。
4. **「偏置 $b$ 可有可无」**：没有 $b$，超平面必须过原点，大量问题立刻不可分（如本节习题 A2）。偏置提供的是「平移自由度」。
:::

::: method 即时自测 · 1.1
**Q1** 写出单个神经元的前向公式，并说明 $w$、$b$、$\phi$ 各自控制什么。

**Q2** 数据集 $\{(0,0)\to0,\ (1,0)\to1,\ (0,1)\to1,\ (1,1)\to1\}$（即 OR）线性可分吗？给出一个可行的 $(\boldsymbol w,b)$。

**Q3** 为什么「把阶跃换成 Sigmoid」不能跨过 XOR 这类问题的边界？

::: sol 参考要点
**Q1** $z=\boldsymbol w^{\mathrm T}\boldsymbol x+b,\ a=\phi(z)$；$w$ 是各输入的重要性权重、$b$ 是激活门槛（平移自由度）、$\phi$ 决定输出的非线性形态与取值范围。

**Q2** 可分。例如 $\boldsymbol w=(1,1)^{\mathrm T}$、$b=-0.5$：四个点的 $z$ 分别为 $-0.5,0.5,0.5,1.5$，除 $(0,0)$ 外均 $\ge0$，与标签一致。

**Q3** 单层的决策边界由 $z=0$ 决定，无论 $\phi$ 是什么形状，**判决面仍是超平面**；$y$ 对 $x$ 的依赖是否线性可分只与这一超平面有关，与 $\phi$ 的单调形状无关。（$\phi$ 需单调递增才能保号；非单调的 $\phi$ 会改变「谁在一侧」的对应关系，但同层内的可分性仍受限于单一超平面。）
:::
:::

::: note[skip] 延伸阅读
- McCulloch & Pitts, *A Logical Calculus of the Ideas Immanent in Nervous Activity*（1943）——阈值单元原始模型，历史源头。
- Rosenblatt, *The Perceptron: A Probabilistic Model for Information Storage and Organization in the Brain*（1958）——感知机与学习规则原文。
- Minsky & Papert, *Perceptrons*（1969）——线性可分边界的经典分析（含 XOR 讨论的来龙去脉）。
- Novikoff, *On Convergence Proofs on Perceptrons*（1962）——收敛定理原始证明。
- 3Blue1Brown《神经网络》系列第 1–2 集——用几何动画建立「加权求和 + 激活」的手感，适合作为本节的第一遍预习。
:::

**本节小结**：神经元 = 加权求和 + 偏置 + 非线性；单层的天花板是**线性可分**，XOR 是这条边界的最小反例；跨过边界要靠**分层**，而训练分层结构要靠**梯度**。下一节把单元堆成层，给出 MLP 的前向计算、形状推演与通用逼近定理的真正含义。
