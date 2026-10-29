# 1.6 直和与投影

[1.2](sec12.md) 定义了子空间的和 $W_1+W_2=\{\boldsymbol{w}_1+\boldsymbol{w}_2\}$，但和空间里的向量**未必**只有一种拆法——[1.2.6](sec12.md#sec-1.2.6) 末尾埋下的那个问题（「对称 + 反对称」分解为何唯一）说的正是这个现象。本节是第一章的收束，分上下两个半场把前面两条线索拧成一股：上半场只用线性结构，下半场让内积加入。

**上半场**研究「拆法唯一」的和：**直和**——四条等价判据中「交为零」「维数相加」最常用。在直和分解 $V=W_1\dotplus W_2$ 之下，每个向量有唯一的分量 $\boldsymbol{y}\in W_1$，这就是**投影**；幂等矩阵 $A^2=A$ 把整套理论安放进一个矩阵等式。**下半场**把 [1.5](sec15.md) 的正交性接入：子空间之间也可以正交，而正交自动排除「共享非零向量」，于是每种维度都白送一个由内积**唯一确定**的补空间——**正交补** $W^{\perp}$；沿正交补落下的是**正交投影**，它在正交基下有现成的投影公式，公式的「原料」由 Gram–Schmidt 供应。收官的例 1.6.7 对**任意**方阵给出 $\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$：零空间与共轭值域天生正交，这是「四个基本子空间」的第一块拼图，也是通往最小二乘与谱理论的大门。

::: preview 先抓住一件事

普通的「和」只保证能拆，直和还保证**拆法唯一**。一旦分量唯一，投影才成为确定的运算；再把补空间取成正交补，投影还成为「垂直落下」的法定运算——不依赖任何选择。判断直和不必逐个验证向量的表法唯一；检查两个子空间是否只共享零向量，通常更快。
:::

<a id="sec-1.6.1"></a>

## 1.6.1 直和：拆法唯一的和

和空间只保证「每个向量拆得开」，不保证「拆法唯一」。既然 1.2 节已经见过拆法不唯一的例子，现在就把另一半补上——给「拆法唯一」的和一个正式的名字。

::: def 定义 1.6.1 · 直和与直和分解 direct sum {#def-1.6.1}

设 $W_1$ 与 $W_2$ 是线性空间 $V$ 的子空间。若和空间 $W_1+W_2$ 中任意向量均**唯一地**表示成 $W_1$ 中的一个向量和 $W_2$ 中的一个向量之和，则称 $W_1+W_2$ 是 $W_1$ 与 $W_2$ 的**直和**，记为

$$W_1\dotplus W_2\qquad(\text{部分教材记作 } W_1\oplus W_2).$$

特别地，若 $V=W_1\dotplus W_2$，则称表达式 $V=W_1\dotplus W_2$ 为 $V$ 的一个**直和分解**，并称 $W_1$ 与 $W_2$ 互为**补空间**（$W_2$ 是 $W_1$ 在 $V$ 中的补，反之亦然）。

:::

唯一性会被什么破坏？只要两个子空间在一条非零向量上重叠，就能造出不止一套拆法。例 1.6.1 把这条路径走一遍。

::: ex 例 1.6.1 · 两个坐标平面的和不是直和 {#ex-1.6.1}

在直角坐标系 $O\text{-}xyz$ 中，取 $W_1=xoy$ 平面、$W_2=yz$ 平面。试判断 $W_1+W_2$ 是否为直和。

::: sol 解答

两个平面都过原点，都是 $\mathbb R^3$ 的二维子空间，且 $W_1+W_2=\mathbb R^3$（$(a,b,c)^{\mathrm T}=(a,b,0)^{\mathrm T}+(0,0,c)^{\mathrm T}$）。但**交** $W_1\cap W_2=y$ 轴不是零空间。取交线上的非零向量，它有不止一种拆法：对任意 $\mu\in\mathbb R$，

$$\begin{pmatrix}0\\1\\0\end{pmatrix}
=\begin{pmatrix}0\\\mu+1\\0\end{pmatrix}+\begin{pmatrix}0\\-\mu\\0\end{pmatrix},
\qquad\begin{pmatrix}0\\\mu+1\\0\end{pmatrix}\in W_1,\ \begin{pmatrix}0\\-\mu\\0\end{pmatrix}\in W_2,$$

$\mu$ 取不同值给出不同拆法，表示不唯一。故 $W_1+W_2$ **不是**直和。

对照：把 $W_2$ 换成 $z$ 轴，则 $W_1\cap W_2=\{\boldsymbol{\theta}\}$，$\mathbb R^3=xoy\ \text{平面}\dotplus\ z\ \text{轴}$ 是直和分解（见下图）。

:::

:::

<figure aria-labelledby="fig-ds-caption" class="concept-figure" data-figure="FIG. 1–12">
<svg aria-labelledby="fig-ds-title fig-ds-desc" role="img" viewBox="0 0 680 320">
<title id="fig-ds-title">直和与非直和的对照</title>
<desc id="fig-ds-desc">左：两个平面沿一条直线相交，交不为零向量，不是直和；右：平面与一条不在其中的直线只交于原点，是直和。</desc>
<g>
<text class="diagram-text" x="165" y="26" text-anchor="middle">✕ 不是直和</text>
<text class="diagram-note" x="165" y="48" text-anchor="middle">两平面交于一条直线（交 ≠ θ）</text>
<polygon points="55,160 150,200 255,160 160,120" fill="color-mix(in srgb, var(--fig-blue) 12%, transparent)" stroke="var(--fig-blue)" stroke-width="2"></polygon>
<polygon points="55,160 150,200 240,258 145,218" fill="color-mix(in srgb, var(--fig-purple) 12%, transparent)" stroke="var(--fig-purple)" stroke-width="2"></polygon>
<line x1="55" y1="160" x2="150" y2="200" stroke="var(--fig-gold)" stroke-width="3.4"></line>
<text class="diagram-note" x="250" y="106">W₁</text>
<text class="diagram-note" x="150" y="288" text-anchor="middle">W₂</text>
<text class="diagram-note" x="50" y="184" text-anchor="end">交线</text>
<text class="diagram-text" x="510" y="26" text-anchor="middle">✓ 直和</text>
<text class="diagram-note" x="510" y="48" text-anchor="middle">平面与直线只交于原点（交 = θ）</text>
<polygon points="400,180 555,125 640,190 485,250" fill="color-mix(in srgb, var(--fig-blue) 12%, transparent)" stroke="var(--fig-blue)" stroke-width="2"></polygon>
<line x1="615" y1="85" x2="445" y2="265" stroke="var(--fig-green)" stroke-width="3"></line>
<circle cx="519" cy="186" r="4.5" fill="var(--fig-gold)"></circle>
<text class="diagram-note" x="600" y="72" text-anchor="end">直线 W₂</text>
<text class="diagram-note" x="400" y="285">平面 W₁</text>
<text class="diagram-note" x="548" y="206">θ</text>
</g>
</svg>
<figcaption id="fig-ds-caption">判定直和最快的一眼：「除了零向量，两个子空间还共享别的东西吗？」</figcaption>
</figure>

::: note

**记号说明。**$\dotplus$ 中的加点提醒你「这是**直**的和」；读作「直和」或「点加」。中文教材两种记号（$\dotplus$ 与 $\oplus$）都常见：本教程沿用课件记号 $\dotplus$，并**把 $\oplus$ 留给 [1.6.5](sec16.md#sec-1.6.5) 的「正交直和」专用**——正交的直和信息更多，值得单独一个记号。还有一处反直觉：补空间一般**不唯一**（过原点的任意一条不在 $W_1$ 内的直线都是 $xoy$ 平面的补），这一点马上会在投影的定义里变得要紧。

:::

<a id="sec-1.6.2"></a>

## 1.6.2 直和判定定理

::: note 课堂信号（09-17）· 三条判据的优先级

老师原话要点：证明 $V=W_1\oplus W_2$ 有三条等价路径——**维数相加**、**交为零**、**零元素表示唯一**；其中“**交空间为零**”最常用、也最省事，维数法次之，零元素表示法（反证）最麻烦（09-17 00:14:01）。做题时优先试交集为零；只有题目把维数直接摆出来时，才改用维数法。原话见[课堂口述与考点信号](../lecture-signals.md)。
:::

按定义 1.6.1 判定直和，要把 $W_1+W_2$ 中**每一个**向量的表法逐一核对——向量有无穷多个，这条路在实际问题里根本走不完。下面的定理把「拆法唯一」翻译成另外三条可以逐条下手的等价说法，其中「交为零」与「维数相加」最常用。

::: thm 定理 1.6.1 · 直和判定定理 {#thm-1.6.1}

设 $W_1$ 与 $W_2$ 是线性空间 $V$ 的两个子空间，则以下命题等价：

（1）$W_1+W_2$ 是直和；<br> （2）$W_1+W_2$ 中零元素表法唯一；<br> （3）$W_1\cap W_2=\{\boldsymbol{\theta}\}$；<br> （4）$\dim(W_1+W_2)=\dim W_1+\dim W_2$。

::: proof 证

**（1）⟹（2）。**直和定义要求**任意**向量（零元素当然在内）的表法唯一。

**（2）⟹（1）。**设 $\boldsymbol{x}=\boldsymbol{w}_1+\boldsymbol{w}_2=\boldsymbol{v}_1+\boldsymbol{v}_2$ 是两种拆法（$\boldsymbol{w}_i,\boldsymbol{v}_i\in W_i$）。相减得

$$\boldsymbol{\theta}=(\boldsymbol{w}_1-\boldsymbol{v}_1)+(\boldsymbol{w}_2-\boldsymbol{v}_2),\qquad\boldsymbol{w}_i-\boldsymbol{v}_i\in W_i,$$

这是零元素的一个表法；由于两个子空间都含零向量，$\boldsymbol{\theta}=\boldsymbol{\theta}+\boldsymbol{\theta}$ 也是一个合法的平凡表法。由 (2) 的唯一性，$\boldsymbol{w}_1-\boldsymbol{v}_1=\boldsymbol{\theta}$、$\boldsymbol{w}_2-\boldsymbol{v}_2=\boldsymbol{\theta}$，两种拆法相同。故任意向量表法唯一，是直和。

**（2）⟺（3）。**零元素的任何表法形如 $\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$（$\boldsymbol{u}\in W_1$，$-\boldsymbol{u}\in W_2$ 当且仅当 $\boldsymbol{u}\in W_1\cap W_2$）。于是：

- 若存在非零 $\boldsymbol{u}\in W_1\cap W_2$，则 $\boldsymbol{\theta}=\boldsymbol{\theta}+\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$ 是两个不同表法，(2) 破坏；
- 反之若 $W_1\cap W_2=\{\boldsymbol{\theta}\}$，则表法 $\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$ 强制 $\boldsymbol{u}=\boldsymbol{\theta}$，表法唯一。

**（3）⟺（4）。**由 [1.3.9](sec13.md#sec-1.3.9) 维数公式（[@thm-1.3.5]），

$$\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2),$$

而 $W_1\cap W_2$ 是子空间（[@thm-1.2.2]），「$\dim(W_1\cap W_2)=0$」与「$W_1\cap W_2=\{\boldsymbol{\theta}\}$」说的是同一件事。

:::

:::

::: method 判据怎么选

- **给定了具体的子空间**（平面、直线、解集）：查交 $W_1\cap W_2$ 最快——判据 (3)。
- **只知道维数与秩**（矩阵的值域、抽象计数）：用维数公式——判据 (4)。
- **要证表示唯一**（坐标、分解式）：直接调 (2) 的表述，「零元素表法唯一」就是「两表法相减为零表法」。
- 四条判据里**没有**「$W_1\cup W_2$」的事——并集根本不是子空间（[1.2.5](sec12.md#sec-1.2.5)），不要混入。

:::

::: ex 例 1.6.2 · 对称矩阵 ⊕ 反对称矩阵 {#ex-1.6.2}

取 $V=\mathbb R^{n\times n}$，

$$W_1=\{A\in V\mid A^{\mathrm T}=A\}\ \text{（对称矩阵）},\qquad W_2=\{A\in V\mid A^{\mathrm T}=-A\}\ \text{（反对称矩阵）},$$

证明 $V=W_1\dotplus W_2$。

::: sol 解答

**先证 $V=W_1+W_2$。**由 [1.2.6](sec12.md#sec-1.2.6)（例 1.2.6），任意 $A$ 可分解为

$$A=\tfrac12\big(A^{\mathrm T}+A\big)+\tfrac12\big(-A^{\mathrm T}+A\big),\qquad
\tfrac12\big(A^{\mathrm T}+A\big)\in W_1,\quad\tfrac12\big(-A^{\mathrm T}+A\big)\in W_2.$$

**再证是直和。**设 $B\in W_1\cap W_2$，则 $B^{\mathrm T}=B$ 且 $B^{\mathrm T}=-B$ 同时成立，故 $B=-B$，即 $B=O$。由 [@thm-1.6.1] (3)，$W_1+W_2$ 是直和。

这正是 [1.2.6](sec12.md#sec-1.2.6) 末尾悬念的正式答案：当时直接验证了「分解式唯一」，现在只需一句「交为零」——判定定理把唯一性变成了检查交集的举手之劳。

:::

:::

::: think 迁移 · 复矩阵的 Hermite 分解

把转置换成共轭转置，同一论证逐字成立：$\mathbb C^{n\times n}=H\dotplus K$，其中 $H$ 是 Hermite 矩阵全体（$A^{\mathrm H}=A$，[@def-1.4.2]），$K$ 是反 Hermite 矩阵全体（$A^{\mathrm H}=-A$）：

$$A=\tfrac12\big(A^{\mathrm H}+A\big)+\tfrac12\big(A-A^{\mathrm H}\big).$$

交为零：$B=B^{\mathrm H}=-B^{\mathrm H}$ 迫使 $B=O$。复矩阵的「实部 / 虚部」不是逐元素取，而是沿这个直和分解取——谱理论中「Hermite = 实特征值」的起点。

:::

<a id="sec-1.6.3"></a>

## 1.6.3 投影：直和分解下的分量

::: note 课堂信号（09-17）· 投影 ≠ 正交投影

老师特别提醒：“这是我以前经常犯的错误——总以为投影就已经是正交关系”；**投影只由直和分解定义**，$x=y+z$ 中的 $y$ 就是沿 $W_2$ 到 $W_1$ 的投影，**并不要求 $y\perp z$**；正交投影是再加“$W_1\perp W_2$”之后的特例（09-17 00:14:54）。判断题里“投影”与“正交投影”混用是高频陷阱。原话见[课堂口述与考点信号](../lecture-signals.md)。
:::

有了直和，「分量」就不再是模糊的说法——分解唯一，分量是一个确定的向量。把「取分量」这个动作正式命名下来，就是上半场的主角：**投影**。

::: def 定义 1.6.2 · 投影 projection {#def-1.6.2}

设 $W_1$ 与 $W_2$ 是线性空间 $V$ 的两个子空间且 $V=W_1\dotplus W_2$。由直和定义，$\forall\boldsymbol{x}\in V$ 均可唯一地分解成

$$\boldsymbol{x}=\boldsymbol{y}+\boldsymbol{z},\qquad\boldsymbol{y}\in W_1,\ \boldsymbol{z}\in W_2,$$

此时称向量 $\boldsymbol{y}$ 为向量 $\boldsymbol{x}$ **在 $W_1$ 上的投影**（$\boldsymbol{z}$ 相应地是 $\boldsymbol{x}$ 在 $W_2$ 上的投影）。

:::

<figure aria-labelledby="fig-proj-caption" class="concept-figure" data-figure="FIG. 1–13">
<svg aria-labelledby="fig-proj-title fig-proj-desc" role="img" viewBox="0 0 680 250">
<title id="fig-proj-title">直和分解下的投影</title>
<desc id="fig-proj-desc">向量 x 分解为 W1 中的分量 y 与 W2 中的分量 z，两者唯一。</desc>
<defs><marker id="pr-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<g>
<line x1="60" y1="210" x2="400" y2="130" stroke="var(--fig-blue)" stroke-width="2.2"></line>
<line x1="60" y1="210" x2="420" y2="218" stroke="var(--fig-blue)" stroke-width="2.2"></line>
<line x1="180" y1="195" x2="470" y2="75" stroke="var(--fig-blue)" stroke-width="2.2"></line>
<line x1="180" y1="195" x2="510" y2="175" stroke="var(--fig-blue)" stroke-width="2.2"></line>
<line x1="90" y1="200" x2="490" y2="160" stroke="var(--accent)" stroke-width="2.8" marker-end="url(#pr-arrow)"></line>
<line x1="90" y1="200" x2="290" y2="182" stroke="var(--fig-purple)" stroke-width="2.8" marker-end="url(#pr-arrow)"></line>
<line x1="290" y1="182" x2="490" y2="160" stroke="var(--fig-green)" stroke-width="2.6" stroke-dasharray="7 5" marker-end="url(#pr-arrow)"></line>
<circle cx="290" cy="182" r="4" fill="var(--fig-gold)"></circle>
<text class="diagram-text" x="508" y="168">x</text>
<text class="diagram-text" x="262" y="172">y ∈ W₁</text>
<text class="diagram-text" x="380" y="190">z ∈ W₂</text>
<text class="diagram-note" x="120" y="235">W₁（平面）</text>
<text class="diagram-note" x="480" y="140">W₂（平面）</text>
<text class="diagram-note" x="200" y="60">x = y + z，拆法唯一</text>
</g>
</svg>
<figcaption id="fig-proj-caption">投影是整个分解的产物：$\boldsymbol{y}$ 由「$W_1$ 配哪个补空间」共同决定，不只是由 $W_1$ 决定。</figcaption>
</figure>

<div class="widget" data-widget="vec-decompose">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">投影分量与正交残差</strong></p>
<p class="widget-hint">拖动 $\boldsymbol{x}$ 的端点，或拉动夹角滑块。绿色是 $\boldsymbol{x}$ 在 $\boldsymbol{y}$ 方向上的**分量**，金色是**残差**；读数里那一行「残差与 $\boldsymbol{y}$ 的内积恒为 0」就是这个分解的正交性。</p>
</div>

::: note

**投影依附于分解，而不只依附于 $W_1$。**同一个 $W_1$ 配不同的补空间，投影结果不同。例：$\mathbb R^2$ 中 $W_1=x$ 轴，$\boldsymbol{x}=(1,1)^{\mathrm T}$。配补 $W_2=y$ 轴：$\boldsymbol{x}=(1,0)^{\mathrm T}+(0,1)^{\mathrm T}$，投影为 $(1,0)^{\mathrm T}$；配补 $W_2'=\operatorname{span}\{(1,1)^{\mathrm T}\}$：$\boldsymbol{x}=\boldsymbol{\theta}+(1,1)^{\mathrm T}$，投影为 $\boldsymbol{\theta}$。**谈投影，必须同时说清沿哪个补空间**。（有没有一种补空间，使投影不再依赖选择？有——$W_1$ 的「正交补」$W_1^{\perp}$，见 [1.6.6](sec16.md#sec-1.6.6)；沿它落下的投影称为正交投影，见 [1.6.7](sec16.md#sec-1.6.7)。）

:::

定义只保证投影存在，不告诉你它等于什么。要把投影**算**出来，就得回到分解本身：把 $W_1$ 的基与 $W_2$ 的基拼成 $V$ 的基（直和保证拼起来线性无关、维数正好凑满），求出 $\boldsymbol{x}$ 在这组基下的坐标，再按归属把坐标分组——落在 $W_1$ 那组基上的部分就是 $\boldsymbol{x}$ 在 $W_1$ 上的投影。

::: ex 例 1.6.3 · 求向量在子空间上的投影 {#ex-1.6.3}

设 $V=\mathbb R^3=W_1\dotplus W_2$（标准内积），其中 $W_1=\operatorname{span}\{(1,0,1)^{\mathrm T}\}$，$W_2=\{(x_1,x_2,x_3)^{\mathrm T}\mid x_3=0\}$（$xoy$ 平面）。求向量 $\boldsymbol{x}=(1,1,1)^{\mathrm T}$ 在 $W_2$ 上的投影。

::: sol 解答

**第一步（拼基）。**$W_1$ 的基 $\boldsymbol{\varepsilon}_1=(1,0,1)^{\mathrm T}$ 连同 $W_2$ 的基 $\boldsymbol{\varepsilon}_2=(1,0,0)^{\mathrm T}$、$\boldsymbol{\varepsilon}_3=(0,1,0)^{\mathrm T}$ 构成 $V$ 的基（三个向量行列式为 $1\neq0$）。设

$$\boldsymbol{x}=k_1\boldsymbol{\varepsilon}_1+k_2\boldsymbol{\varepsilon}_2+k_3\boldsymbol{\varepsilon}_3,$$

则 $\boldsymbol{x}$ 在 $W_1$ 和 $W_2$ 上的投影分别为 $\boldsymbol{y}=k_1\boldsymbol{\varepsilon}_1$ 与 $\boldsymbol{z}=k_2\boldsymbol{\varepsilon}_2+k_3\boldsymbol{\varepsilon}_3$。

**第二步（内积方程组）。**分别计算 $\boldsymbol{x}$ 与 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_3$ 的内积，由第一变元线性：

$$
\begin{aligned}
(\boldsymbol{x},\boldsymbol{\varepsilon}_1)&=k_1(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_1)+k_2(\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_1)+k_3(\boldsymbol{\varepsilon}_3,\boldsymbol{\varepsilon}_1),\\
(\boldsymbol{x},\boldsymbol{\varepsilon}_2)&=k_1(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2)+k_2(\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_2)+k_3(\boldsymbol{\varepsilon}_3,\boldsymbol{\varepsilon}_2),\\
(\boldsymbol{x},\boldsymbol{\varepsilon}_3)&=k_1(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_3)+k_2(\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_3)+k_3(\boldsymbol{\varepsilon}_3,\boldsymbol{\varepsilon}_3),
\end{aligned}$$

写成矩阵形式即 Gram 方程组 $G\boldsymbol{k}=\boldsymbol{c}$（$g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$，[@def-1.4.4]）：

$$
\begin{pmatrix}2&1&0\\1&1&0\\0&0&1\end{pmatrix}
\begin{pmatrix}k_1\\k_2\\k_3\end{pmatrix}
=\begin{pmatrix}(\boldsymbol{x},\boldsymbol{\varepsilon}_1)\\(\boldsymbol{x},\boldsymbol{\varepsilon}_2)\\(\boldsymbol{x},\boldsymbol{\varepsilon}_3)\end{pmatrix}
=\begin{pmatrix}2\\1\\1\end{pmatrix}.$$

**第三步（求解与分组）。**前两个方程 $2k_1+k_2=2$、$k_1+k_2=1$ 相减得 $k_1=1$，进而 $k_2=0$；第三式 $k_3=1$。于是

$$\boldsymbol{x}=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_3,\qquad
\underbrace{\boldsymbol{\varepsilon}_1}_{\in W_1}+\underbrace{\boldsymbol{\varepsilon}_3}_{\in W_2}.$$

$\boldsymbol{x}$ 在 $W_2$ 上的投影为 $\boldsymbol{z}=\boldsymbol{\varepsilon}_3=(0,1,0)^{\mathrm T}$（在 $W_1$ 上的投影为 $\boldsymbol{y}=\boldsymbol{\varepsilon}_1=(1,0,1)^{\mathrm T}$）。核对：$\boldsymbol{y}+\boldsymbol{z}=(1,1,1)^{\mathrm T}=\boldsymbol{x}$ ✓。

:::

:::

::: method 求投影的通用算法（例 1.6.3 的一般化）

1. 取 $W_1$ 的基与 $W_2$ 的基，拼成 $V$ 的基（直和保证拼起来无关、维数凑满）；
2. 解 Gram 方程组 $G\boldsymbol{k}=\boldsymbol{c}$，其中 $c_i=(\boldsymbol{x},\boldsymbol{\varepsilon}_i)$、$g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$——$G$ 正定 Hermite（基的度量矩阵，[@def-1.4.4]；实空间即对称正定），方程组必有唯一解；
3. 把坐标按「$W_1$ 的基 / $W_2$ 的基」分组，分别组装即得两个投影。

本质上这就是 [1.3.5](sec13.md#sec-1.3.5) 的坐标求解，只是方程组用内积写出。在 $\mathbb R^n$ 的标准内积下，把拼成的基按列写成 $B$，也可以直接解 $B\boldsymbol{k}=\boldsymbol{x}$；Gram 方程就是再左乘 $B^{\mathrm T}$。正定性保证精确算术下可解，却不保证有限精度下误差小：基向量近相关时，先形成 Gram 矩阵可能放大数据扰动的影响。手算可按本例走，数值实现通常优先用 QR 求坐标（见 [3.4](../ch03/sec34.md)）。这里先记住数学上的唯一可解与计算上的准确可靠是两件事。

:::

::: ex 例 1.6.A · 四条判据各验一遍 {#ex-1.6.A}

在 $\mathbb R^2$ 中取 $W_1=\{(a,0)^{\mathrm T}\}$（$x$ 轴），$W_2=\operatorname{span}\{(1,1)^{\mathrm T}\}$。(1) 证明 $\mathbb R^2=W_1\dotplus W_2$；(2) 求 $\boldsymbol{x}=(3,1)^{\mathrm T}$ 在 $W_1$ 上的投影；(3) 这个投影是「垂直落下」得到的吗？

::: sol 解答

**(1)** 四条判据逐条看：(1′) 设 $(a,b)^{\mathrm T}=(s,0)^{\mathrm T}+t(1,1)^{\mathrm T}$，比较第二分量得 $t=b$，再得 $s=a-b$，表法唯一；(2′) 已含于 (1′)；(3′) $(s,0)^{\mathrm T}=t(1,1)^{\mathrm T}$ 强制 $t=0,s=0$，$W_1\cap W_2=\{\boldsymbol{\theta}\}$；(4′) $\dim W_1+\dim W_2=1+1=2=\dim\mathbb R^2$。四条全部成立（定理保证它们同时成立，验证一条即可，此处仅为演练）。

**(2)** 沿此分解：$(3,1)^{\mathrm T}=(2,0)^{\mathrm T}+(1,1)^{\mathrm T}$，投影为 $(2,0)^{\mathrm T}$。

**(3)** 不是。残差 $\boldsymbol{x}-\boldsymbol{y}=(1,1)^{\mathrm T}\in W_2$ 与 $W_1$ 的内积 $(1,1)\cdot(1,0)=1\neq0$，不垂直。若换成补空间 $y$ 轴，投影为 $(3,0)^{\mathrm T}$，残差 $(0,1)^{\mathrm T}$ 与 $W_1$ 垂直——**同一个 $W_1$，两种补，两个不同的投影**，其中只有后者是正交投影。

:::

:::

::: method 从分解到投影矩阵 · 用值域与零空间检验答案

把例 1.6.A 中的 $(3,1)^{\mathrm T}$ 换成任意 $(a,b)^{\mathrm T}$，分解式是

$$\begin{pmatrix}a\\b\end{pmatrix}=\begin{pmatrix}a-b\\0\end{pmatrix}+\begin{pmatrix}b\\b\end{pmatrix}.$$

因此沿 $W_2$ 投到 $W_1$ 的矩阵为 $P=\begin{pmatrix}1&-1\\0&0\end{pmatrix}$。三个检查各回答一个问题：$P^2=P$ 表示投过一次不再改变；$R(P)=W_1$ 表示落在哪里；$N(P)=W_2$ 表示沿哪个方向被抹掉。这里 $P^{\mathrm T}\ne P$，所以幂等仍不等于正交投影。它把 $(0,1)^{\mathrm T}$ 送到 $(-1,0)^{\mathrm T}$，也与沿 $y$ 轴投影不同。

**迁移练习。**若补空间改为 $\widetilde W_2=\operatorname{span}\{(2,1)^{\mathrm T}\}$，求新投影矩阵，并验证其零空间。

::: sol 核对与下一步

$(a,b)^{\mathrm T}=(a-2b,0)^{\mathrm T}+b(2,1)^{\mathrm T}$，故 $\widetilde P=\begin{pmatrix}1&-2\\0&0\end{pmatrix}$，零空间由 $a=2b$ 给出，正是 $\widetilde W_2$。若只写出投影结果却说不清补空间，重看本节定义；能从矩阵找出这两个空间后，下一小节会把这个过程推广到所有幂等矩阵。想判断何时为正交投影，再读 [1.6.7](sec16.md#sec-1.6.7)。
:::
:::

<a id="sec-1.6.4"></a>

## 1.6.4 幂等矩阵：$A^2=A$ 自动给出直和分解

上半场还剩一个反方向的问题：前面都是「给定分解，算投影」，一个矩阵能不能反过来自带一组直和分解？$A^2=A$ 给出的答案最干净。

::: ex 例 1.6.4 · $A^2=A\ \Rightarrow\ \mathbb C^n=R(A)\dotplus R(I-A)$ {#ex-1.6.4}

设 $A\in\mathbb C^{n\times n}$ 且满足 $A^2=A$（称 $A$ 为**幂等矩阵**），试证明

$$\mathbb C^n=R(A)\dotplus R\big(I-A\big).$$

**分析：**须证明（1）$R(A)+R(I-A)$ 是直和；（2）$R(A)\dotplus R(I-A)$ 与 $\mathbb C^n$ 相等。

::: proof 证明（1）直和

设 $\boldsymbol{x}\in R(A)$、$\boldsymbol{y}\in R(I-A)$，则存在 $\boldsymbol{z}_1,\boldsymbol{z}_2\in\mathbb C^n$ 使

$$\boldsymbol{x}=A\boldsymbol{z}_1,\qquad\boldsymbol{y}=(I-A)\boldsymbol{z}_2.$$

进一步（反复用 $A^2=A$）：

$$A\boldsymbol{x}=A^2\boldsymbol{z}_1=A\boldsymbol{z}_1=\boldsymbol{x},\qquad
A\boldsymbol{y}=A(I-A)\boldsymbol{z}_2=(A-A^2)\boldsymbol{z}_2=\boldsymbol{0}.$$

即：**$R(A)$ 中的向量被 $A$ 作用后不变，$R(I-A)$ 中的向量被 $A$ 作用后变为零向量**。令 $\boldsymbol{w}\in R(A)\cap R(I-A)$，则同时有 $\boldsymbol{w}=A\boldsymbol{w}$（因 $\boldsymbol{w}\in R(A)$）与 $\boldsymbol{w}=A\boldsymbol{w}=\boldsymbol{0}$（因 $\boldsymbol{w}\in R(I-A)$），故 $\boldsymbol{w}=\boldsymbol{0}$。由 [@thm-1.6.1] (3)，$R(A)+R(I-A)$ 是直和。

:::

::: proof 证明（2）与 $\mathbb C^n$ 相等 · 方法一（两集合相等）

$\forall\boldsymbol{x}\in\mathbb C^n$，

$$\boldsymbol{x}=A\boldsymbol{x}+(I-A)\boldsymbol{x},\qquad A\boldsymbol{x}\in R(A),\ (I-A)\boldsymbol{x}\in R(I-A),$$

故 $\mathbb C^n\subseteq R(A)+R(I-A)$。反向包含来自值域的类型：$R(A),R(I-A)\subseteq\mathbb C^n$，而 $\mathbb C^n$ 对加法封闭，所以 $R(A)+R(I-A)\subseteq\mathbb C^n$。因此 $\mathbb C^n=R(A)\dotplus R(I-A)$。

:::

::: proof 证明（2）与 $\mathbb C^n$ 相等 · 方法二（子空间 + 维数相等）

已知 $R(A)+R(I-A)$ 一定是 $\mathbb C^n$ 的子空间，故（结合 (1) 已证的直和）

$$\mathbb C^n=R(A)\dotplus R(I-A)\ \Longleftrightarrow\ \dim R(A)+\dim R(I-A)=n\ \Longleftrightarrow\ \operatorname{rank}A+\operatorname{rank}(I-A)=n.$$

设 $\operatorname{rank}A=r$，须证 $\operatorname{rank}(I-A)=n-r$。**一方面**，根据 $A(I-A)=O$ 得：$I-A$ 的每一列都是方程组 $A\boldsymbol{x}=\boldsymbol{0}$ 的解向量，而该方程组的解空间维数为 $n-r$（先修工具箱 §4 结论 B），故

$$\operatorname{rank}(I-A)\leq n-r.$$

**另一方面**，把 $I=A+(I-A)$ 取秩并用次可加性：

$$n=\operatorname{rank}I=\operatorname{rank}\big(A+(I-A)\big)\leq\operatorname{rank}A+\operatorname{rank}(I-A)=r+\operatorname{rank}(I-A),$$

故 $\operatorname{rank}(I-A)\geq n-r$。综上 $\operatorname{rank}(I-A)=n-r$，命题得证。

:::

:::

::: errata 勘误 E9 · 课件页 11 证明 (1) 中「令 $\boldsymbol{y}=\boldsymbol{x}$」的跳跃

课件证明 $R(A)\cap R(I-A)=\{\boldsymbol{0}\}$ 时写：「进一步，$A\boldsymbol{x}=\boldsymbol{x}$，$A\boldsymbol{y}=\boldsymbol{0}$。令 $\boldsymbol{y}=\boldsymbol{x}$，则有 $\boldsymbol{x}=A\boldsymbol{x}=A\boldsymbol{y}=\boldsymbol{0}$。」两步之间缺了一个关键交代：$\boldsymbol{x}$ 与 $\boldsymbol{y}$ 原本取自**不同**的子空间，不能直接令它们相等；应当先说明「设 $\boldsymbol{w}\in R(A)\cap R(I-A)$，则 $\boldsymbol{w}$ 既可写成 $A\boldsymbol{z}_1$（故 $A\boldsymbol{w}=\boldsymbol{w}$），又可写成 $(I-A)\boldsymbol{z}_2$（故 $A\boldsymbol{w}=\boldsymbol{0}$），两者联立得 $\boldsymbol{w}=\boldsymbol{0}$」。本教程 [1.6.4](sec16.md#sec-1.6.4) 的证明已补足这一层。

:::

<figure aria-labelledby="fig-idem-caption" class="concept-figure" data-figure="FIG. 1–14">
<svg aria-labelledby="fig-idem-title fig-idem-desc" role="img" viewBox="0 0 680 250">
<title id="fig-idem-title">幂等矩阵把每个向量拆成「不动部分 + 零化部分」</title>
<desc id="fig-idem-desc">x 分解为 Ax 与 (I−A)x；A 作用在 Ax 上不变，作用在 (I−A)x 上得到零向量。</desc>
<defs><marker id="id-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<g>
<rect class="diagram-node" height="86" rx="12" width="120" x="40" y="82"></rect>
<text class="diagram-mono" x="62" y="115">x ∈ Cⁿ</text>
<text class="diagram-note" x="60" y="140">任意向量</text>
<line class="diagram-accent" marker-end="url(#id-arrow)" x1="168" x2="268" y1="102" y2="66"></line>
<line class="diagram-accent" marker-end="url(#id-arrow)" x1="168" x2="268" y1="150" y2="186"></line>
<text class="diagram-mono" x="188" y="72">A x</text>
<text class="diagram-mono" x="176" y="182">(I−A) x</text>
<rect class="diagram-node" height="76" rx="12" width="180" x="276" y="28"></rect>
<text class="diagram-mono" x="296" y="58">Ax ∈ R(A)</text>
<text class="diagram-note" x="296" y="84">A(Ax) = Ax 不动</text>
<rect class="diagram-node" height="76" rx="12" width="180" x="276" y="158"></rect>
<text class="diagram-mono" x="296" y="188">(I−A)x</text>
<text class="diagram-note" x="296" y="214">A 作用后为零</text>
<text class="diagram-note" x="486" y="80">两者之和恒等于 x</text>
<text class="diagram-note" x="486" y="106">相交仅 0：Cⁿ = R(A) ∔ R(I−A)</text>
</g>
</svg>
<figcaption id="fig-idem-caption">$A^2=A$ 的全部信息浓缩为一句：$A$ 是「沿 $R(I-A)$ 落到 $R(A)$」的投影。</figcaption>
</figure>

::: think 幂等矩阵就是投影矩阵

例 1.6.4 说：$A^2=A$ 时，映射 $\boldsymbol{x}\mapsto A\boldsymbol{x}$ 恰好是「把 $\boldsymbol{x}$ 沿 $R(I-A)$ 投到 $R(A)$ 上」的投影。还差一步就能看到全貌：此时 $N(A)=R(I-A)$。证明是一行双向包含：

- 若 $A\boldsymbol{x}=\boldsymbol{0}$，则 $\boldsymbol{x}=A\boldsymbol{x}+(I-A)\boldsymbol{x}=(I-A)\boldsymbol{x}\in R(I-A)$；
- 若 $\boldsymbol{x}\in R(I-A)$，则 $\boldsymbol{x}=(I-A)\boldsymbol{z}$，$A\boldsymbol{x}=(A-A^2)\boldsymbol{z}=\boldsymbol{0}$。

于是幂等矩阵给出的是「值域 $\dotplus$ 零空间」分解 $\mathbb C^n=R(A)\dotplus N(A)$——[1.2.7](sec12.md#sec-1.2.7) 里看似不相干的两个子空间，被 $A^2=A$ 一根线穿起。检验一个矩阵是否是投影矩阵，**只需验证 $A^2=A$**，值域分解与拆法唯一性随之成立。特别地，若还满足 $R(A)\perp N(A)$（这要求 $A=A^{\mathrm H}$），投影就是**正交投影**——最小二乘法中「法方程的解」正是它在做事，后续课程展开。（例 1.6.7 将补全这条线：对**任意**矩阵，与 $N(A)$ 天生正交的不是 $R(A)$，而是 $R(A^{\mathrm H})$。）

:::

::: note

**一个简单算例。**$A=\begin{pmatrix}1&0\\0&0\end{pmatrix}$，直接相乘得 $A^2=\begin{pmatrix}1&0\\0&0\end{pmatrix}=A$。$R(A)=\operatorname{span}\{(1,0)^{\mathrm T}\}$（$x$ 轴），$R(I-A)=\operatorname{span}\{(0,1)^{\mathrm T}\}$（$y$ 轴），$\mathbb C^2=x\text{ 轴}\dotplus\ y\text{ 轴}$；$A\boldsymbol{x}$ 把 $(a,b)^{\mathrm T}$ 变成 $(a,0)^{\mathrm T}$——恰是沿 $y$ 轴向 $x$ 轴的（正交）投影。把 $A$ 换成 $\begin{pmatrix}1&1\\0&0\end{pmatrix}$（相乘仍得 $A^2=A$），$R(A)$ 不变，但 $R(I-A)=\operatorname{span}\{(1,-1)^{\mathrm T}\}$ 变了，投影变成**斜**投影——再次印证：投影由「子空间 + 补空间」共同决定。

:::

::: method 半场小结 · 上半场（1.6.1–1.6.4）停一下

到这里，「和」这条线已经走完。上半场的全部内容可以收成四句：

1. **和 → 直和**：多出的信息只有一条——**拆法唯一**；把关的判据里「交为零」最快。
2. **直和 → 投影**：正因为拆法唯一，「分量」才是一个确定的向量，才有资格叫投影。
3. **投影 → 矩阵**：幂等矩阵 $A^2=A$ 把「值域 + 零空间」这套分解压进**一个矩阵等式**。
4. **贯穿的前提**：投影依附于**整个分解**（子空间 + 补空间），不是只依附于目标子空间。

下半场只做一件事：**让内积接管**，把「随便挑一个补空间」升级为「由内积唯一确定的补空间」。从「投影」走到「正交投影」，要补的就是这一步。

:::

<a id="sec-1.6.5"></a>

## 1.6.5 正交的子空间与正交直和

[1.5.5](sec15.md#sec-1.5.5) 定义的是一对向量的正交：$(\boldsymbol{x},\boldsymbol{y})=0$。要把内积接进直和与投影，先得把这个定义升级两次——先升到「向量对子空间」，再升到「子空间对子空间」。升级之后，「垂直」这个词反而要**更小心**地使用：几何直觉会骗人。

::: def 定义 1.6.3 · 向量正交于子空间 {#def-1.6.3}

设 $V$ 是内积空间，$W$ 是 $V$ 的子空间，$\boldsymbol{x}\in V$。若对 $\forall\boldsymbol{y}\in W$ 都有 $\boldsymbol{x}\perp\boldsymbol{y}$，则称 $\boldsymbol{x}$ **正交**（或**垂直**）于子空间 $W$，记为 $\boldsymbol{x}\perp W$。

:::

::: def 定义 1.6.4 · 两子空间正交 {#def-1.6.4}

设 $W_1$ 与 $W_2$ 是内积空间 $V$ 的子空间。若对 $\forall\boldsymbol{x}\in W_1$ 和 $\forall\boldsymbol{y}\in W_2$ 都有 $\boldsymbol{x}\perp\boldsymbol{y}$，则称 $W_1$ 与 $W_2$ **正交**，记为 $W_1\perp W_2$。

:::

::: method 检验正交，只需查基对基

定义要求「每一个对每一个」，看似查不完，实际只需检查**基与基**：设 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_s$ 是 $W_1$ 的基、$\boldsymbol{\beta}_1,\cdots,\boldsymbol{\beta}_t$ 是 $W_2$ 的基，则

$$W_1\perp W_2\quad\Longleftrightarrow\quad(\boldsymbol{\alpha}_i,\boldsymbol{\beta}_j)=0\quad(\forall\,i,j).$$

理由是内积的线性：$W_1$ 中任意向量是 $\boldsymbol{\alpha}_i$ 的组合、$W_2$ 中任意向量是 $\boldsymbol{\beta}_j$ 的组合，按两个变元把内积逐项拆开，每一项都含某个 $(\boldsymbol{\alpha}_i,\boldsymbol{\beta}_j)$。（对照 [@thm-1.5.2] 证明里「两边作内积、正交性消项」的动作——同一个技巧。）

:::

::: ex 例 1.6.5 · 几何上的「垂直」未必是子空间正交 {#ex-1.6.5}

在 $\mathbb R^3$ 中取三个子空间（如图）：直线 $W$ 竖直站立，$W_1$ 是水平地面，$W_2$ 是竖直墙面，$W_1$ 与 $W_2$ 摆成「墙角」——几何上互相垂直。考察：(1) $W$ 与 $W_1$ 是否正交？(2) $W_1$ 与 $W_2$ 是否正交？

::: sol 解答

**(1)** 正交。直线垂直于平面，意味着它与平面内**每一条**直线都垂直（立体几何的事实）；$W_1$ 的每个向量都躺在平面内一条过原点的直线上，故 $W$ 的每个向量与 $W_1$ 的每个向量正交。按定义 1.6.4，$W\perp W_1$。

**(2)** 不正交。两个平面都过原点，其交 $W_1\cap W_2=W_3$ 是一条过原点的直线（维数公式保证 $\dim(W_1\cap W_2)\geq2+2-3=1$；几何上就是墙角的「踢脚线」）。取 $W_3$ 中任一非零向量 $\boldsymbol{u}$：它既属于 $W_1$ 又属于 $W_2$，而 $(\boldsymbol{u},\boldsymbol{u})=\|\boldsymbol{u}\|^2\neq0$——$W_1$ 中存在与 $W_2$ 中向量不正交的对子（$\boldsymbol{u}$ 与它自己）。故 $W_1$ 与 $W_2$ **不**正交。

**教训。**「墙角式垂直」是**逐方向**的：墙面内确有不少方向与地面垂直，但并非每一个方向都与地面的每一个方向垂直——踢脚线是例外。子空间正交是全称命题「每一个对每一个」，比几何直观强得多；它还立刻排除「共享非零向量」的可能——这正是下一条定理的全部证明。

:::

:::

<figure aria-labelledby="fig-oc-caption" class="concept-figure" data-figure="FIG. 1–15">
<svg aria-labelledby="fig-oc-title fig-oc-desc" role="img" viewBox="0 0 680 320">
<title id="fig-oc-title">例 1.6.5：墙角的三个子空间</title>
<desc id="fig-oc-desc">水平地面平面 W1，竖直墙面平面 W2 与它交于直线 W3；竖直直线 W 与地面内每条直线垂直。</desc>
<defs><marker id="oc-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-green)"></path></marker></defs>
<g>
<text class="diagram-text" x="340" y="30" text-anchor="middle">W ⊥ W₁ ✓　　W₁ 与 W₂ ✗</text>
<polygon points="110,272 420,272 556,196 246,196" fill="color-mix(in srgb, var(--fig-blue) 12%, transparent)" stroke="var(--fig-blue)" stroke-width="2"></polygon>
<text class="diagram-note" x="118" y="302">W₁（地面平面）</text>
<polygon points="420,272 556,196 556,86 420,162" fill="color-mix(in srgb, var(--fig-purple) 12%, transparent)" stroke="var(--fig-purple)" stroke-width="2"></polygon>
<text class="diagram-note" x="566" y="112">W₂（墙面平面）</text>
<line x1="420" y1="272" x2="556" y2="196" stroke="var(--fig-gold)" stroke-width="3.4"></line>
<text class="diagram-note" x="428" y="264">W₃ = W₁∩W₂（踢脚线）</text>
<line x1="228" y1="243" x2="228" y2="112" stroke="var(--fig-green)" stroke-width="3" marker-end="url(#oc-arrow)"></line>
<text class="diagram-text" x="240" y="118">W</text>
<circle cx="228" cy="243" r="4.5" fill="var(--fig-gold)"></circle>
<text class="diagram-note" x="204" y="264">O</text>
<path d="M228,225 L216,225 L216,237" fill="none" stroke="var(--muted)" stroke-width="1.6"></path>
<text class="diagram-note" x="392" y="152">墙面内确有方向 ⊥ 地面，</text>
<text class="diagram-note" x="392" y="174">但踢脚线方向是例外</text>
</g>
</svg>
<figcaption id="fig-oc-caption">几何「垂直」是逐方向的；子空间正交要求<b>每一个对每一个</b>——踢脚线 $W_3$ 同时躺在两个平面里，非零向量与自己不正交，所以 $W_1$ 与 $W_2$ 不正交。</figcaption>
</figure>

::: thm 定理 1.6.2 · 正交 ⟹ 直和 {#thm-1.6.2}

设 $W_1$ 与 $W_2$ 是内积空间 $V$ 的子空间。若 $W_1\perp W_2$，则 $W_1+W_2=W_1\dotplus W_2$。

::: proof 证

由 [@thm-1.6.1] (3)，只须证 $W_1\cap W_2=\{\boldsymbol{\theta}\}$。设 $\boldsymbol{u}\in W_1\cap W_2$，把 $\boldsymbol{u}$ 同时当作 $W_1$ 的向量与 $W_2$ 的向量，则 $W_1\perp W_2$ 给出 $(\boldsymbol{u},\boldsymbol{u})=0$；由正定性（[@def-1.4.1] (4)），$\boldsymbol{u}=\boldsymbol{\theta}$。∎

一行证明。例 1.6.5 里「踢脚线上不可能有非零向量」的观察，在这里把「查交」这道工序整个免掉了：只要两个子空间正交，最常用的判据 (3) 就自动成立。

:::

:::

::: def 定义 1.6.5 · 正交直和与正交直和分解 {#def-1.6.5}

设 $W_1$ 与 $W_2$ 是内积空间 $V$ 的子空间。若 $W_1\perp W_2$，则称直和 $W_1\dotplus W_2$ 为 $W_1$ 与 $W_2$ 的**正交直和**，记为 $W_1\oplus W_2$；若 $V=W_1\oplus W_2$，则称表达式 $V=W_1\oplus W_2$ 为 $V$ 的**正交直和分解**。

:::

::: note

**记号收束。**至此补全 [1.6.1](sec16.md#sec-1.6.1) 的记号说明：$\dotplus$ 表示一般直和（拆法唯一），$\oplus$ 专指正交直和（拆法唯一**且**两分量互相垂直）——信息更多，值得单独一个记号。有的教材用 $\oplus$ 兼指两者，阅读时须从上下文分辨；本教程从严区分。

:::

::: errata 勘误 E11 · 定理 1.6.2–1.6.4 与定义 1.6.5–1.6.7 的空间前提

课件在定义 1.6.3、1.6.4 处正确写了「内积空间」，但从定理 1.6.2 起连续把前提写成「线性空间 $V$」（定义 1.6.5–1.6.7、定理 1.6.2–1.6.4 均如此）。「$W_1\perp W_2$」「$W_1^{\perp}$」离开内积**没有定义**——正交是 [1.4](sec14.md) 引入的几何结构，不是线性结构自带的。本教程把这些条目的前提统一改为内积空间。

:::

<a id="sec-1.6.6"></a>

## 1.6.6 正交补：法定的补空间

[1.6.1](sec16.md#sec-1.6.1) 说过：补空间一般不唯一，谈投影必须说清「沿哪个补」。这带来一个尴尬：同一个 $W_1$，换个补就换个投影，「在 $W_1$ 上的投影」还不是 $W_1$ 自己说了算的运算。本节要找一个例外——由内积**唯一确定**、无需任何选择的补空间。

::: def 定义 1.6.6 · 子空间正交补 {#def-1.6.6}

设 $W_1$ 是内积空间 $V$ 的子空间，则集合

$$W_1^{\perp}=\{\boldsymbol{x}\in V\mid\boldsymbol{x}\perp W_1\}$$

称为 $W_1$ 的**正交补**（空间）。

:::

这个定义的读法是：把 $V$ 中「与 $W_1$ 处处垂直」的向量全部收集起来。这个集合天生就是「补」的候选——$W_1$ 中的非零向量不可能与自己垂直（正是定理 1.6.2 的推理），所以 $W_1\cap W_1^{\perp}=\{\boldsymbol{\theta}\}$。但要当补空间，还得回答两个问题：它是不是子空间？它够不够大？下面两条定理依次作答。

::: thm 定理 1.6.3 · 正交补是子空间 {#thm-1.6.3}

设 $W_1$ 是内积空间 $V$ 的子空间，则集合 $W_1^{\perp}$ 是 $V$ 的线性子空间。

::: proof 证

$\boldsymbol{\theta}$ 与任何向量正交（[@ex-1.4.1]），故 $\boldsymbol{\theta}\in W_1^{\perp}$，集合非空。任取 $\boldsymbol{x}_1,\boldsymbol{x}_2\in W_1^{\perp}$、$k\in F$、$\boldsymbol{y}\in W_1$。由**第一变元**线性（[@def-1.4.1] (2)(3)）：

$$(\boldsymbol{x}_1+\boldsymbol{x}_2,\boldsymbol{y})=(\boldsymbol{x}_1,\boldsymbol{y})+(\boldsymbol{x}_2,\boldsymbol{y})=0,\qquad
(k\boldsymbol{x}_1,\boldsymbol{y})=k(\boldsymbol{x}_1,\boldsymbol{y})=0,$$

故 $\boldsymbol{x}_1+\boldsymbol{x}_2\in W_1^{\perp}$、$k\boldsymbol{x}_1\in W_1^{\perp}$。由子空间判定定理（[@thm-1.2.1]），$W_1^{\perp}$ 是 $V$ 的子空间。∎

（「待验证的向量」被放在内积的**第一**变元，这正是本教程「第一变元线性」约定的用处；采用相反约定的教材，把论证放到第二变元即可。）

:::

:::

::: thm 定理 1.6.4 · 正交分解定理 {#thm-1.6.4}

设 $W_1$ 是 $n$ 维内积空间 $V$ 的子空间，则

$$V=W_1\oplus W_1^{\perp}.$$

::: proof 证

**正交性。**按定义 1.6.4 逐字成立：$W_1$ 的每个向量与 $W_1^{\perp}$ 的每个向量正交，即 $W_1\perp W_1^{\perp}$；由 [@thm-1.6.2]，和 $W_1+W_1^{\perp}$ 已是直和。以下只须证 $W_1+W_1^{\perp}=V$。

**构造一组「前段张成 $W_1$」的正交基。**设 $\dim W_1=m$。$m=0$ 时 $W_1^{\perp}=V$，结论平凡。设 $m\geq1$：取 $W_1$ 的任一组基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_m$，由基扩充定理（[@cor-1.3.1]）扩成 $V$ 的基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_m,\boldsymbol{x}_{m+1},\cdots,\boldsymbol{x}_n$，再对整组基施行 Gram–Schmidt（[1.5.6](sec15.md#sec-1.5.6)），得 $V$ 的正交基 $\boldsymbol{v}_1,\cdots,\boldsymbol{v}_n$。

这一步全靠 Gram–Schmidt 的一条性质：它**逐步保持张成不变**（[1.5.6](sec15.md#sec-1.5.6)：$\operatorname{span}(\boldsymbol{v}_1,\cdots,\boldsymbol{v}_k)=\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k)$）。取 $k=m$ 即

$$\operatorname{span}(\boldsymbol{v}_1,\cdots,\boldsymbol{v}_m)=\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_m)=W_1 .$$

而 $\boldsymbol{v}_{m+1},\cdots,\boldsymbol{v}_n$ 与 $\boldsymbol{v}_1,\cdots,\boldsymbol{v}_m$ 两两正交，故每个 $\boldsymbol{v}_j\ (j>m)$ 都与 $W_1$ 的每个向量正交。

::: note 这里有一个容易写错的理由
不要说「$W_1$ 的基本来就两两正交，所以 GS 不动它们，$\boldsymbol{v}_i=\boldsymbol{x}_i$」——$\boldsymbol{x}_1,\cdots,\boldsymbol{x}_m$ 是**任取**的一组基，一般**并不**正交，GS 会实实在在改变它们（例如 $\boldsymbol{v}_2=\boldsymbol{x}_2-\frac{(\boldsymbol{x}_2,\boldsymbol{v}_1)}{(\boldsymbol{v}_1,\boldsymbol{v}_1)}\boldsymbol{v}_1\ne\boldsymbol{x}_2$）。

结论靠的是「**张成不变**」，不是「**向量不变**」：$W_1$ 的正交基未必是原来那 $m$ 个向量，但它们仍张成 $W_1$——这已经够用了。
:::

**拆任意向量。**任取 $\boldsymbol{x}\in V$，按正交基展开并分组：

$$\boldsymbol{x}=\underbrace{\sum_{i=1}^{m}c_i\boldsymbol{v}_i}_{=:\,\boldsymbol{y}\in W_1}+\underbrace{\sum_{i=m+1}^{n}c_i\boldsymbol{v}_i}_{=:\,\boldsymbol{z}},$$

$\boldsymbol{z}$ 是 $\boldsymbol{v}_{m+1},\cdots,\boldsymbol{v}_n$ 的组合，其中每个向量都与 $W_1$ 的基正交；由内积的线性，$\boldsymbol{z}$ 与 $W_1$ 的**每个**向量正交，即 $\boldsymbol{z}\in W_1^{\perp}$。于是 $\boldsymbol{x}=\boldsymbol{y}+\boldsymbol{z}\in W_1+W_1^{\perp}$；反向包含是子空间的类型关系。故 $V=W_1\oplus W_1^{\perp}$。∎

:::

:::

::: note

**维数的红利。**把 $\dim V=n$ 代入正交分解与判据 (4)：

$$\dim W_1+\dim W_1^{\perp}=n .$$

计数立即过关：$\mathbb R^3$ 中平面的正交补是直线、直线的正交补是平面、全空间的正交补是 $\{\boldsymbol{\theta}\}$。另一个顺手的推论是 $(W_1^{\perp})^{\perp}=W_1$：一方面 $W_1\subseteq(W_1^{\perp})^{\perp}$（$W_1$ 的向量与 $W_1^{\perp}$ 的一切向量正交），另一方面两者维数都是 $\dim W_1$；有限维空间里「包含 + 等维 ⟹ 相等」。

:::

::: note

**正交分解里的补空间没有选择余地。**考察任意正交直和分解 $V=W_1\oplus W_2$：按定义，$W_2\subseteq W_1^{\perp}$；而判据 (4) 用两次给出 $\dim W_2=n-\dim W_1=\dim W_1^{\perp}$，故

$$W_2=W_1^{\perp}.$$

这正是 [1.6.3](sec16.md#sec-1.6.3) 末尾遗留问题的答案：**只有沿正交补的投影不依赖「选哪个补」**——它由 $W_1$ 与内积唯一确定。[1.4](sec14.md) 注 3 说内积为线性空间带来「图形化」理解，这里兑现得最彻底：内积替你**选好了**补空间。

:::

<a id="sec-1.6.7"></a>

## 1.6.7 正交投影：沿正交补落下

补空间一旦由内积钉死，投影就不再依赖任何选择，「在 $W_1$ 上的投影」也终于可以省掉后半句。这样的投影值得一个专名，也值得一套专门的算法。

::: def 定义 1.6.7 · 正交投影 {#def-1.6.7}

设 $W_1$ 与 $W_2$ 是内积空间 $V$ 的两个子空间且 $V=W_1\oplus W_2$。$\forall\boldsymbol{x}\in V$ 均可唯一地分解成

$$\boldsymbol{x}=\boldsymbol{y}+\boldsymbol{z},\qquad\boldsymbol{y}\in W_1,\ \boldsymbol{z}\in W_2,$$

此时称向量 $\boldsymbol{y}$ 为向量 $\boldsymbol{x}$ 在 $W_1$ 上的**正交投影**（$\boldsymbol{z}$ 相应地是 $\boldsymbol{x}$ 在 $W_2$ 上的正交投影），记作 $\boldsymbol{y}=\operatorname{Proj}_{W_1}\boldsymbol{x}$。

:::

::: note

**定义为何合法（课件未交代）。**定义里写的是「某个」$W_2$，看似正交投影仍依赖补空间的选择，但这一点由 [1.6.6](sec16.md#sec-1.6.6) 末尾的注直接消掉：正交直和分解中的 $W_2$ **必定**等于 $W_1^{\perp}$。因此「$\boldsymbol{x}$ 在 $W_1$ 上的正交投影」只由 $W_1$（与内积）决定；等价地，可把定义中的分解直接取为 $V=W_1\oplus W_1^{\perp}$（定理 1.6.4 保证它存在）。与一般投影（[@def-1.6.2]）对照：一般投影是「沿**指定**补空间」的运算，正交投影是「沿正交补」的法定运算——谈它时不必再提补空间。

:::

<figure aria-labelledby="fig-op-caption" class="concept-figure" data-figure="FIG. 1–16">
<svg aria-labelledby="fig-op-title fig-op-desc" role="img" viewBox="0 0 680 280">
<title id="fig-op-title">沿正交补落下的正交投影</title>
<desc id="fig-op-desc">平面 W 与直线 W⊥ 互相垂直；向量 x 分解为 W 中的 y 与 W⊥ 中的 z，构成矩形。</desc>
<defs><marker id="op-arrow-a" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker><marker id="op-arrow-z" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-purple)"></path></marker><marker id="op-arrow-y" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-green)"></path></marker></defs>
<g>
<polygon points="140,246 500,246 600,186 240,186" fill="color-mix(in srgb, var(--fig-blue) 12%, transparent)" stroke="var(--fig-blue)" stroke-width="2"></polygon>
<text class="diagram-note" x="146" y="274">W（平面）</text>
<line x1="300" y1="238" x2="300" y2="58" stroke="var(--fig-purple)" stroke-width="2.6" marker-end="url(#op-arrow-z)"></line>
<text class="diagram-text" x="312" y="72">W⊥（直线）</text>
<circle cx="300" cy="238" r="4.5" fill="var(--fig-gold)"></circle>
<text class="diagram-note" x="282" y="262">O</text>
<line x1="300" y1="238" x2="300" y2="118" stroke="var(--fig-purple)" stroke-width="2.8" marker-end="url(#op-arrow-z)"></line>
<text class="diagram-text" x="272" y="156">z</text>
<line x1="300" y1="238" x2="496" y2="238" stroke="var(--fig-green)" stroke-width="2.8" marker-end="url(#op-arrow-y)"></line>
<text class="diagram-text" x="472" y="230">y</text>
<line x1="300" y1="238" x2="496" y2="120" stroke="var(--accent)" stroke-width="2.8" marker-end="url(#op-arrow-a)"></line>
<text class="diagram-text" x="508" y="118">x</text>
<line x1="496" y1="238" x2="496" y2="120" stroke="var(--muted)" stroke-width="1.6" stroke-dasharray="6 4"></line>
<line x1="300" y1="118" x2="496" y2="118" stroke="var(--muted)" stroke-width="1.6" stroke-dasharray="6 4"></line>
<path d="M300,218 L320,218 L320,238" fill="none" stroke="var(--muted)" stroke-width="1.6"></path>
<text class="diagram-note" x="360" y="106">x = y + z（矩形结构）</text>
</g>
</svg>
<figcaption id="fig-op-caption">正交投影的「矩形结构」：$\boldsymbol{x}=\boldsymbol{y}+\boldsymbol{z}$，两分量正交，勾股 $\|\boldsymbol{x}\|^2=\|\boldsymbol{y}\|^2+\|\boldsymbol{z}\|^2$ 顺手成立。</figcaption>
</figure>

::: note

**勾股与「最近点」。**分解 $\boldsymbol{x}=\boldsymbol{y}+\boldsymbol{z}$（$\boldsymbol{y}\perp\boldsymbol{z}$）立刻给出勾股等式（[1.5.5](sec15.md#sec-1.5.5) 注 5）：

$$\|\boldsymbol{x}\|^2=\|\boldsymbol{y}\|^2+\|\boldsymbol{z}\|^2 .$$

再进一步——课件未展开、值得记住的一步——对任意 $\boldsymbol{w}\in W_1$，由 $\boldsymbol{y}-\boldsymbol{w}\in W_1$、$\boldsymbol{x}-\boldsymbol{y}=\boldsymbol{z}\in W_1^{\perp}$ 及勾股：

$$\|\boldsymbol{x}-\boldsymbol{w}\|^2=\|\boldsymbol{y}-\boldsymbol{w}\|^2+\|\boldsymbol{z}\|^2\ \geq\ \|\boldsymbol{z}\|^2=\|\boldsymbol{x}-\boldsymbol{y}\|^2,$$

等号当且仅当 $\boldsymbol{w}=\boldsymbol{y}$。**正交投影是 $W_1$ 中离 $\boldsymbol{x}$ 最近的点**（最佳逼近）——最小二乘法「残差最小」的全部秘密就在这一行（习题 B13 要求完整写出）。

:::

::: ex 例 1.6.6 · 求正交投影的两种方法 {#ex-1.6.6}

在 $\mathbb R^3$（标准内积）中给定线性子空间 $W=\operatorname{span}\{\boldsymbol{x}_1,\boldsymbol{x}_2\}$，其中

$$\boldsymbol{x}_1=(2,5,-1)^{\mathrm T},\qquad\boldsymbol{x}_2=(-2,1,1)^{\mathrm T}.$$

求 $\boldsymbol{x}=(1,2,3)^{\mathrm T}$ 在 $W$ 和 $W^{\perp}$ 上的正交投影。

::: sol 方法一 · 先求补，再相减

**先求 $W^{\perp}$。**设 $\boldsymbol{u}=(a,b,c)^{\mathrm T}$ 与 $\boldsymbol{x}_1,\boldsymbol{x}_2$ 都正交：

$$(\boldsymbol{u},\boldsymbol{x}_1)=2a+5b-c=0,\qquad(\boldsymbol{u},\boldsymbol{x}_2)=-2a+b+c=0,$$

两式相加得 $b=0$，进而 $c=2a$。取 $a=1$ 得 $\boldsymbol{x}_3=(1,0,2)^{\mathrm T}$，故 $W^{\perp}=\operatorname{span}\{\boldsymbol{x}_3\}$（一维，与维数公式 $3-2=1$ 一致）。

**投到一维子空间。**设 $\alpha$ 为 $\boldsymbol{x}$ 与 $\boldsymbol{x}_3$ 的夹角（[@def-1.5.2]），则

$$\boldsymbol{z}=\operatorname{Proj}_{W^{\perp}}\boldsymbol{x}
=\|\boldsymbol{x}\|\cos\alpha\cdot\frac{\boldsymbol{x}_3}{\|\boldsymbol{x}_3\|}
=\frac{(\boldsymbol{x},\boldsymbol{x}_3)}{(\boldsymbol{x}_3,\boldsymbol{x}_3)}\,\boldsymbol{x}_3
=\frac75(1,0,2)^{\mathrm T}
=\Big(\frac75,\,0,\,\frac{14}5\Big)^{\mathrm T},$$

其中第二个等号用了 $\cos\alpha=\dfrac{(\boldsymbol{x},\boldsymbol{x}_3)}{\|\boldsymbol{x}\|\,\|\boldsymbol{x}_3\|}$——这正是 [1.5.2](sec15.md#sec-1.5.2) 证明里那个使「残差与 $\boldsymbol{x}_3$ 正交」的系数。

**相减。**由 $V=W\oplus W^{\perp}$ 的唯一拆解：

$$\boldsymbol{y}=\operatorname{Proj}_{W}\boldsymbol{x}=\boldsymbol{x}-\operatorname{Proj}_{W^{\perp}}\boldsymbol{x}
=\Big(-\frac25,\,2,\,\frac15\Big)^{\mathrm T}.$$

**核对。**$\boldsymbol{z}\perp\boldsymbol{x}_1,\boldsymbol{x}_2$（$\tfrac{14}5\cdot1+\tfrac{14}5\cdot(-1)=0$、$-\tfrac{14}5+\tfrac{14}5=0$）✓；$\boldsymbol{y}=\tfrac3{10}\boldsymbol{x}_1+\tfrac12\boldsymbol{x}_2\in W$ ✓；$\boldsymbol{y}+\boldsymbol{z}=\boldsymbol{x}$ ✓；勾股 $\|\boldsymbol{x}\|^2=14=\tfrac{21}5+\tfrac{49}5=\|\boldsymbol{y}\|^2+\|\boldsymbol{z}\|^2$ ✓。

:::

::: sol 方法二 · 直接投到 $W$（正交基公式）

先检查题给的基：$(\boldsymbol{x}_1,\boldsymbol{x}_2)=-4+5-1=0$，**它恰好已是 $W$ 的正交基**，于是可用命题 1.6.1 的公式直接投影：

$$\operatorname{Proj}_{W}\boldsymbol{x}
=\frac{(\boldsymbol{x},\boldsymbol{x}_1)}{\|\boldsymbol{x}_1\|^2}\,\boldsymbol{x}_1+\frac{(\boldsymbol{x},\boldsymbol{x}_2)}{\|\boldsymbol{x}_2\|^2}\,\boldsymbol{x}_2
=\frac9{30}\boldsymbol{x}_1+\frac36\boldsymbol{x}_2
=\Big(-\frac25,\,2,\,\frac15\Big)^{\mathrm T},$$

其中 $(\boldsymbol{x},\boldsymbol{x}_1)=2+10-3=9$、$\|\boldsymbol{x}_1\|^2=30$；$(\boldsymbol{x},\boldsymbol{x}_2)=-2+2+3=3$、$\|\boldsymbol{x}_2\|^2=6$。与方法一一致，$\boldsymbol{z}=\boldsymbol{x}-\boldsymbol{y}=(\tfrac75,0,\tfrac{14}5)^{\mathrm T}$ 随之重合。两种方法殊途同归并非巧合：正交投影由 $W$ 与内积唯一确定（定义 1.6.7 的合法性注），路径不同，落点必然相同。

:::

:::

::: errata 勘误 E12 · 例 1.6.6 方法二提前使用命题 1.6.1，且未交代前提

课件在方法二直接写出 $\operatorname{Proj}_{W}\boldsymbol{x}=\sum_i\frac{(\boldsymbol{x},\boldsymbol{x}_i)}{\|\boldsymbol{x}_i\|^2}\boldsymbol{x}_i$，但该公式**只对正交基成立**（这正是课件下一页命题 1.6.1 的内容），且课件未指出本题 $\boldsymbol{x}_1\perp\boldsymbol{x}_2$ 恰好使公式合法。若基不正交（如 [@ex-1.6.3] 的情形），此式给出的**不是**投影——反例见习题 A16(c)。本教程在方法二开头补上「先查基是否正交」这一步。

:::

::: thm 命题 1.6.1 · 正交基下的投影公式 {#prop-1.6.1}

若 $W$ 是**有限维内积空间** $V$ 的子空间，$\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是 $W$ 的一组正交基，则对于 $V$ 中任一向量 $\boldsymbol{y}$ 均可唯一地表示为

$$\boldsymbol{y}=\operatorname{Proj}_{W}\boldsymbol{y}+\operatorname{Proj}_{W^{\perp}}\boldsymbol{y},$$

其中 $\operatorname{Proj}_{W}\boldsymbol{y}$、$\operatorname{Proj}_{W^{\perp}}\boldsymbol{y}$ 分别为 $\boldsymbol{y}$ 在空间 $W$ 与补空间 $W^{\perp}$ 上的正交投影，且

$$\operatorname{Proj}_{W}\boldsymbol{y}=\frac{(\boldsymbol{y},\boldsymbol{x}_1)}{(\boldsymbol{x}_1,\boldsymbol{x}_1)}\boldsymbol{x}_1+\cdots+\frac{(\boldsymbol{y},\boldsymbol{x}_n)}{(\boldsymbol{x}_n,\boldsymbol{x}_n)}\boldsymbol{x}_n .$$

特别地，若 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是 $W$ 的一组标准正交基，则

$$\operatorname{Proj}_{W}\boldsymbol{y}=(\boldsymbol{y},\boldsymbol{x}_1)\boldsymbol{x}_1+\cdots+(\boldsymbol{y},\boldsymbol{x}_n)\boldsymbol{x}_n .$$

::: proof 证

**构造。**令

$$\boldsymbol{w}=\sum_{j=1}^{n}\frac{(\boldsymbol{y},\boldsymbol{x}_j)}{(\boldsymbol{x}_j,\boldsymbol{x}_j)}\,\boldsymbol{x}_j\ \in W .$$

**验证残差正交。**对每个基向量 $\boldsymbol{x}_i$，由第一变元线性与两两正交（$j\neq i$ 时 $(\boldsymbol{x}_j,\boldsymbol{x}_i)=0$）：

$$(\boldsymbol{y}-\boldsymbol{w},\,\boldsymbol{x}_i)=(\boldsymbol{y},\boldsymbol{x}_i)-\sum_{j=1}^{n}\frac{(\boldsymbol{y},\boldsymbol{x}_j)}{(\boldsymbol{x}_j,\boldsymbol{x}_j)}(\boldsymbol{x}_j,\boldsymbol{x}_i)=(\boldsymbol{y},\boldsymbol{x}_i)-\frac{(\boldsymbol{y},\boldsymbol{x}_i)}{(\boldsymbol{x}_i,\boldsymbol{x}_i)}(\boldsymbol{x}_i,\boldsymbol{x}_i)=0 .$$

与基正交即与 $W$ 的每个向量正交（线性），故 $\boldsymbol{y}-\boldsymbol{w}\in W^{\perp}$，于是 $\boldsymbol{y}=\boldsymbol{w}+(\boldsymbol{y}-\boldsymbol{w})$ 是 $V=W\oplus W^{\perp}$ 下的一个合法拆解。

**认定。**由拆解唯一性（直和定义），$\boldsymbol{w}=\operatorname{Proj}_{W}\boldsymbol{y}$、$\boldsymbol{y}-\boldsymbol{w}=\operatorname{Proj}_{W^{\perp}}\boldsymbol{y}$，表示的唯一性随之成立。∎

这段「构造 $\boldsymbol{w}$、验证残差正交」的证明，正是定理 1.6.4 中「拆任意向量」一步的直接版本——它不经过基扩充，只要求 $W$ 自己有一组（有限）正交基。

:::

:::

::: method 求正交投影的路线图

设要求 $\operatorname{Proj}_{W}\boldsymbol{x}$，按手头材料选路：

1. **$W$ 的基是正交基** → 命题 1.6.1 公式直投（例 1.6.6 方法二；先检查基是否正交！）。
2. **基不正交** → 先 Gram–Schmidt 化为正交基再用公式（习题 C16、C17）。
3. **$W^{\perp}$ 好求**（低维、约束方程简单）→ 先投补再相减：$\operatorname{Proj}_{W}\boldsymbol{x}=\boldsymbol{x}-\operatorname{Proj}_{W^{\perp}}\boldsymbol{x}$（例 1.6.6 方法一）。
4. **只想解方程组** → 拼基解 Gram 方程组（[@ex-1.6.3] 的通用算法）。

四条路线的共同内核：**残差 $\boldsymbol{x}-\operatorname{Proj}_{W}\boldsymbol{x}$ 正交于 $W$**——[1.5](sec15.md) 的母题「减掉成分、留下正交残差」第四次登场（C–S 证明、Gram–Schmidt、命题 1.6.1、正交投影）。

:::

::: note

**投影公式的矩阵形式（本教程补注）。**设 $W\subseteq\mathbb C^m$，$\boldsymbol{z}_1,\cdots,\boldsymbol{z}_k$ 是 $W$ 的标准正交基，拼成列 $Z=(\boldsymbol{z}_1,\cdots,\boldsymbol{z}_k)\in\mathbb C^{m\times k}$（$Z^{\mathrm H}Z=I_k$）。则命题 1.6.1 的标准正交基版本写成

$$\operatorname{Proj}_{W}\boldsymbol{y}=\sum_{i=1}^{k}(\boldsymbol{y},\boldsymbol{z}_i)\boldsymbol{z}_i=\sum_{i=1}^{k}\boldsymbol{z}_i\big(\boldsymbol{z}_i^{\mathrm H}\boldsymbol{y}\big)=ZZ^{\mathrm H}\boldsymbol{y}.$$

矩阵 $P=ZZ^{\mathrm H}$ 满足 $P^2=P$（幂等）与 $P^{\mathrm H}=P$（Hermite）——对照 [1.6.4](sec16.md#sec-1.6.4) 的思考框：**幂等 + Hermite = 正交投影矩阵**。习题 B14 要求把这条等价链完整证一遍。

:::

<a id="sec-1.6.8"></a>

## 1.6.8 标准正交基的存在性与正线上三角过渡矩阵

[1.5.6](sec15.md#sec-1.5.6) 把 Gram–Schmidt 作为**方法**给出并验证；课件 1.6（下）把它正式立为定理——它回答了 [1.5.5](sec15.md#sec-1.5.5) 思考框「正交组规模的上界能达到吗」的疑问。

::: thm 定理 1.6.5 · 有限维内积空间必存在标准正交基 {#thm-1.6.5}

$n$ 维内积空间必存在标准正交基。

::: proof 证（构造性 · 即 Gram–Schmidt 正交化）

任取一组基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$，令

$$\boldsymbol{y}_1=\boldsymbol{x}_1,\qquad
\boldsymbol{y}_k=\boldsymbol{x}_k-\sum_{i=1}^{k-1}\frac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\,\boldsymbol{y}_i\quad(k=2,\cdots,n),$$

再单位化 $\boldsymbol{z}_k=\boldsymbol{y}_k/\|\boldsymbol{y}_k\|$。[1.5.6](sec15.md#sec-1.5.6) 已完整验证：$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 两两正交、均非零、张成不变，故 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n$ 是含 $n$ 个向量的标准正交向量组，即标准正交基（[@def-1.5.4]）。∎

**几何叙述**（课件页 10–13 的逐步图示）：$\boldsymbol{y}_1=\boldsymbol{x}_1$ 原样保留第一个方向；$\boldsymbol{y}_2=\boldsymbol{x}_2-\operatorname{Proj}_{\boldsymbol{x}_1}\boldsymbol{x}_2$ 减掉沿 $\boldsymbol{x}_1$ 的成分（$\operatorname{Proj}_{\boldsymbol{x}_1}$ 是「投到 $\operatorname{span}\{\boldsymbol{x}_1\}$」的缩写）；第三个向量则要减掉它在**已有两个正交方向**上的全部投影：

$$AD=\boldsymbol{x}_3-\operatorname{Proj}_{\boldsymbol{y}_1}\boldsymbol{x}_3-\operatorname{Proj}_{\boldsymbol{y}_2}\boldsymbol{x}_3$$

（$AD$ 是课件图中从投影终点 $D$ 指向 $\boldsymbol{x}_3$ 终点 $A$ 的箭头）——[1.5.6](sec15.md#sec-1.5.6) 图 1–11 的「减成分、留垂直残差」逐轮重复。

:::

:::

用单位化向量改写公式，得到课件页 14 的**第二种写法**：

$$\boldsymbol{y}_k=\boldsymbol{x}_k-\sum_{i=1}^{k-1}\frac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\,\boldsymbol{y}_i
=\boldsymbol{x}_k-\sum_{i=1}^{k-1}(\boldsymbol{x}_k,\boldsymbol{z}_i)\,\boldsymbol{z}_i ,$$

第二个等号来自 $\boldsymbol{y}_i=\|\boldsymbol{y}_i\|\,\boldsymbol{z}_i$（课件未显式定义 $\boldsymbol{z}_i$，本教程在此补上）。推导只用到一条：$\|\boldsymbol{y}_i\|$ 是**实数**——按第二变元共轭线性的约定，提出来时不带共轭：

$$(\boldsymbol{x}_k,\boldsymbol{y}_i)=(\boldsymbol{x}_k,\|\boldsymbol{y}_i\|\boldsymbol{z}_i)=\|\boldsymbol{y}_i\|\,(\boldsymbol{x}_k,\boldsymbol{z}_i),\qquad
(\boldsymbol{y}_i,\boldsymbol{y}_i)=\|\boldsymbol{y}_i\|^2,$$

两式相除再乘回 $\boldsymbol{y}_i=\|\boldsymbol{y}_i\|\boldsymbol{z}_i$，范数因子全部消去。

**从公式读出过渡矩阵。**把两组基写成行向量形式，由张成不变可设

$$(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)=(\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n)\,A,$$

读第 $k$ 列：$\boldsymbol{x}_k=\sum_i\boldsymbol{z}_i\,a_{ik}$。而第二种写法恰好给出 $\boldsymbol{x}_k$ 按 $\boldsymbol{z}$ 组的展开：

$$\boldsymbol{x}_k=\|\boldsymbol{y}_k\|\,\boldsymbol{z}_k+\sum_{i<k}(\boldsymbol{x}_k,\boldsymbol{z}_i)\,\boldsymbol{z}_i ,$$

对照系数（表示唯一性，[@thm-1.3.1]）：

$$a_{kk}=\|\boldsymbol{y}_k\|\gt0,\qquad a_{ik}=(\boldsymbol{x}_k,\boldsymbol{z}_i)\ \ (i\lt k),\qquad a_{ik}=0\ \ (i\gt k),$$

即

$$A=\begin{pmatrix}
\|\boldsymbol{y}_1\|&(\boldsymbol{x}_2,\boldsymbol{z}_1)&\cdots&(\boldsymbol{x}_n,\boldsymbol{z}_1)\\
0&\|\boldsymbol{y}_2\|&\cdots&(\boldsymbol{x}_n,\boldsymbol{z}_2)\\
\vdots&\vdots&\ddots&\vdots\\
0&0&\cdots&\|\boldsymbol{y}_n\|
\end{pmatrix}$$

上三角、对角元全正——故称**正线上三角矩阵**。（课件页 15 的矩阵只在左下角印了一个 $0$，其余下三角元素省略未印；按上面的推导它们全为 $0$。）

::: errata 勘误 E13 · 定理 1.6.5 缺「有限维」前提

课件陈述为「内积空间必存在标准正交基」，未限定维数。按本章 [@def-1.3.3] 的 Hamel 基理解，该陈述在无限维**不**成立：例如可分的无穷维 Hilbert 空间中，正交向量组至多可数，而无穷维完备空间的 Hamel 基必不可数（Baire 纲论证），两者永远对不上——这与勘误 E10 的「完备正交系 vs Hamel 基」是同一道边界。Gram–Schmidt 的构造性证明也只在有限个向量上操作。本教程把定理限定为 $n$ 维内积空间。

:::

<figure aria-labelledby="fig-qr-caption" class="concept-figure" data-figure="FIG. 1–17">
<svg aria-labelledby="fig-qr-title fig-qr-desc" role="img" viewBox="0 0 680 300">
<title id="fig-qr-title">Gram–Schmidt：从任意基到标准正交基，过渡矩阵正线上三角</title>
<desc id="fig-qr-desc">左侧任意基 x 组，右侧标准正交基 z 组，Gram–Schmidt 把前者化为后者；过渡矩阵 A 为对角元全正的上三角矩阵。</desc>
<defs><marker id="qr-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<g>
<rect class="diagram-node" height="86" rx="12" width="178" x="30" y="40"></rect>
<text class="diagram-mono" x="60" y="72">x₁, …, xₙ</text>
<text class="diagram-note" x="52" y="102">任意基（一般不正交）</text>
<line class="diagram-accent" marker-end="url(#qr-arrow)" x1="222" x2="442" y1="83" y2="83"></line>
<text class="diagram-mono" x="258" y="62">Gram–Schmidt</text>
<text class="diagram-note" x="256" y="112">减成分、留垂直残差 ×(n−1) 轮</text>
<rect class="diagram-node" height="86" rx="12" width="178" x="452" y="40"></rect>
<text class="diagram-mono" x="482" y="72">z₁, …, zₙ</text>
<text class="diagram-note" x="474" y="102">标准正交基（G = I）</text>
<text class="diagram-mono" x="205" y="166">(x₁, …, xₙ) = (z₁, …, zₙ) A</text>
<path d="M248,182 L242,182 L242,286 L248,286" fill="none" stroke="var(--line-strong)" stroke-width="1.6"></path>
<text class="diagram-mono" x="258" y="200">‖y₁‖</text>
<text class="diagram-mono" x="330" y="200">(x₂,z₁)</text>
<text class="diagram-mono" x="410" y="200">⋯</text>
<text class="diagram-mono" x="452" y="200">(xₙ,z₁)</text>
<text class="diagram-mono" x="266" y="228">0</text>
<text class="diagram-mono" x="330" y="228">‖y₂‖</text>
<text class="diagram-mono" x="410" y="228">⋯</text>
<text class="diagram-mono" x="452" y="228">(xₙ,z₂)</text>
<text class="diagram-mono" x="266" y="256">⋮</text>
<text class="diagram-mono" x="330" y="256">⋱</text>
<text class="diagram-mono" x="410" y="256">⋱</text>
<text class="diagram-mono" x="452" y="256">⋮</text>
<text class="diagram-mono" x="266" y="284">0</text>
<text class="diagram-mono" x="330" y="284">0</text>
<text class="diagram-mono" x="410" y="284">⋯</text>
<text class="diagram-mono" x="452" y="284">‖yₙ‖</text>
<path d="M540,182 L546,182 L546,286 L540,286" fill="none" stroke="var(--line-strong)" stroke-width="1.6"></path>
<text class="diagram-note" x="566" y="200">上三角</text>
<text class="diagram-note" x="566" y="228">对角元 ‖yₖ‖ > 0</text>
<text class="diagram-note" x="566" y="256">（正线上三角）</text>
<text class="diagram-note" x="566" y="284">X = QA：QR 雏形</text>
</g>
</svg>
<figcaption id="fig-qr-caption">Gram–Schmidt 不只是「造出正交基」：它同时记录了新旧基之间的关系——过渡矩阵 $A$ 必是正线上三角，这正是 QR 分解中的 $R$。</figcaption>
</figure>

::: think 俯瞰 · Gram–Schmidt 就是 QR 分解

把 $\boldsymbol{x}$ 组、$\boldsymbol{z}$ 组按**列**拼成矩阵 $X=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)$、$Q=(\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n)$，则本节的关系式正是

$$X=QA,\qquad Q^{\mathrm H}Q=I,\qquad A\ \text{正线上三角} .$$

这就是数值代数中的 **QR 分解**（$A$ 扮演其中的 $R$）：任何矩阵都可分解为「酉矩阵 × 上三角矩阵」，而 Gram–Schmidt 是求它的第一条算法。[1.4.7](sec14.md#sec-1.4.7) 思考框预告的整条技术路线——「Gram–Schmidt 正交化 → 标准正交基 → 酉对角化」——此刻走完第一步；习题 C17 让你对一组具体的基算出 $A$。配合命题 1.6.1 的矩阵形式 $\operatorname{Proj}_{W}\boldsymbol{y}=ZZ^{\mathrm H}\boldsymbol{y}$，最小二乘的「QR 解法」只差临门一脚——这条路线的完整展开见[附录 B.5](../appendix/appendix-b.md#sec-B.5)。

:::

<a id="sec-1.6.9"></a>

## 1.6.9 收官：$\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$

上半场以例 1.6.4 收官：$A^2=A$ 的矩阵自动给出直和分解。下半场的收官例把条件全部撤掉——**不做任何假设**，任意方阵都自带一个正交直和分解，代价只是「值域」换成了「共轭值域」。

::: ex 例 1.6.7 · 任意方阵的白送正交分解 {#ex-1.6.7}

设 $A=(a_{ij})\in\mathbb C^{n\times n}$（$\mathbb C^n$ 取标准内积），证明：

$$N(A)\oplus R(A^{\mathrm H})=\mathbb C^n,\qquad\text{且}\qquad R(A^{\mathrm H})=(N(A))^{\perp}.$$

::: proof 证明 · 三步

**第一步（正交）：$R(A^{\mathrm H})\perp N(A)$。**任取 $\boldsymbol{y}\in R(A^{\mathrm H})$，设 $\boldsymbol{y}=A^{\mathrm H}\boldsymbol{u}$；任取 $\boldsymbol{x}\in N(A)$，即 $A\boldsymbol{x}=\boldsymbol{0}$。由标准内积 $(\boldsymbol{y},\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}\boldsymbol{y}$（[@ex-1.4.3]）：

$$(\boldsymbol{y},\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}\boldsymbol{u}=(A\boldsymbol{x})^{\mathrm H}\boldsymbol{u}=\boldsymbol{0}^{\mathrm H}\boldsymbol{u}=0 .$$

由 [@thm-1.6.2]，$N(A)+R(A^{\mathrm H})$ 已是直和。

**第二步（秩）：$\operatorname{rank}A^{\mathrm H}=\operatorname{rank}A$。**共轭转置 = 转置再逐元共轭，两步都不改变秩：转置由「行秩 = 列秩」（先修工具箱 §5）保证；逐元共轭保持线性相关性——若 $\sum_jc_j\overline{\boldsymbol{a}}_j=\boldsymbol{\theta}$，取共轭得 $\sum_j\overline{c_j}\boldsymbol{a}_j=\boldsymbol{\theta}$，非平凡组合一一对应，极大无关组个数不变。

**第三步（维数凑满）。**由先修工具箱 §4 结论 B，$\dim N(A)=n-\operatorname{rank}A$；又 $\dim R(A^{\mathrm H})=\operatorname{rank}A^{\mathrm H}=\operatorname{rank}A$。于是

$$\dim N(A)+\dim R(A^{\mathrm H})=(n-\operatorname{rank}A)+\operatorname{rank}A=n=\dim\mathbb C^n,$$

由 [@thm-1.6.1] (4)，$\mathbb C^n=N(A)\dotplus R(A^{\mathrm H})$；又由第一步 $R(A^{\mathrm H})\subseteq(N(A))^{\perp}$，而

$$\dim (N(A))^{\perp}=n-\dim N(A)=\operatorname{rank}A=\dim R(A^{\mathrm H}),$$

包含 + 等维，故 $R(A^{\mathrm H})=(N(A))^{\perp}$，分解是正交直和。∎

:::

:::

::: note

**「包含 + 等维」这个动作值得单独记。**证明 $R(A^{\mathrm H})=(N(A))^{\perp}$ 时，我们没有直接证反向包含——那要对每个 $\boldsymbol{y}\perp N(A)$ 构造 $\boldsymbol{u}$ 使 $\boldsymbol{y}=A^{\mathrm H}\boldsymbol{u}$，要解方程、用到秩的结构——而是用「$R(A^{\mathrm H})\subseteq(N(A))^{\perp}$ + 维数相等」绕开构造。这是有限维空间的常用省力技巧，与 $(W_1^{\perp})^{\perp}=W_1$ 的证法（[1.6.6](sec16.md#sec-1.6.6)）同一个模板。

:::

<figure aria-labelledby="fig-fs-caption" class="concept-figure" data-figure="FIG. 1–18">
<svg aria-labelledby="fig-fs-title fig-fs-desc" role="img" viewBox="0 0 680 260">
<title id="fig-fs-title">例 1.6.7 与其对偶版本：四个基本子空间</title>
<desc id="fig-fs-desc">左：输入端 ℂⁿ = N(A) ⊕ R(Aᴴ)；右：输出端 ℂⁿ = N(Aᴴ) ⊕ R(A)。A 把 R(Aᴴ) 一一映到 R(A)，把 N(A) 映为零。</desc>
<defs><marker id="fs-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker><marker id="fs-arrow-b" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-blue)"></path></marker><marker id="fs-arrow-g" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-gold)"></path></marker></defs>
<g>
<rect class="diagram-node" height="196" rx="14" width="240" x="30" y="34"></rect>
<text class="diagram-mono" x="62" y="62">ℂⁿ（输入端）</text>
<line x1="66" y1="176" x2="216" y2="176" stroke="var(--fig-blue)" stroke-width="2.8" marker-end="url(#fs-arrow-b)"></line>
<text class="diagram-note" x="118" y="200">R(Aᴴ)</text>
<line x1="150" y1="206" x2="150" y2="96" stroke="var(--fig-gold)" stroke-width="2.8" marker-end="url(#fs-arrow-g)"></line>
<text class="diagram-note" x="160" y="106">N(A)</text>
<path d="M150,166 L138,166 L138,176" fill="none" stroke="var(--muted)" stroke-width="1.6"></path>
<text class="diagram-note" x="62" y="224">N(A) ⊕ R(Aᴴ) = ℂⁿ</text>
<line class="diagram-accent" marker-end="url(#fs-arrow)" x1="286" x2="392" y1="128" y2="128"></line>
<text class="diagram-mono" x="296" y="108">A 作用</text>
<text class="diagram-note" x="292" y="150">R(Aᴴ) → R(A)</text>
<text class="diagram-note" x="304" y="172">N(A) → θ</text>
<rect class="diagram-node" height="196" rx="14" width="240" x="410" y="34"></rect>
<text class="diagram-mono" x="442" y="62">ℂⁿ（输出端）</text>
<line x1="446" y1="176" x2="596" y2="176" stroke="var(--fig-blue)" stroke-width="2.8" marker-end="url(#fs-arrow-b)"></line>
<text class="diagram-note" x="500" y="200">R(A)</text>
<line x1="530" y1="206" x2="530" y2="96" stroke="var(--fig-gold)" stroke-width="2.8" marker-end="url(#fs-arrow-g)"></line>
<text class="diagram-note" x="540" y="106">N(Aᴴ)</text>
<path d="M530,166 L518,166 L518,176" fill="none" stroke="var(--muted)" stroke-width="1.6"></path>
<text class="diagram-note" x="442" y="224">N(Aᴴ) ⊕ R(A) = ℂⁿ</text>
</g>
</svg>
<figcaption id="fig-fs-caption">例 1.6.7 与其对偶版本（把 $A$ 换成 $A^{\mathrm H}$）合称<b>四个基本子空间</b>：秩–零化度定理的几何形态，是两个正交分解。</figcaption>
</figure>

::: think 四个基本子空间 · 与例 1.6.4 的会师

把例 1.6.7 用在 $A^{\mathrm H}$ 上（$(A^{\mathrm H})^{\mathrm H}=A$），得对偶版本 $\mathbb C^n=N(A^{\mathrm H})\oplus R(A)$。合起来就是著名的**四个基本子空间**（方阵情形两组都住在 $\mathbb C^n$；长方阵 $m\times n$ 情形 $R(A),N(A^{\mathrm H})\subseteq\mathbb C^m$）：

$$\mathbb C^n=N(A)\oplus R(A^{\mathrm H}),\qquad\mathbb C^n=N(A^{\mathrm H})\oplus R(A),$$

秩–零化度定理（自测卷 6；严格证明见 [2.2.5](../ch02/sec22.md#thm-2.2.5) 与[定理 2.3.6](../ch02/sec23.md#thm-2.3.6)）在这里获得几何形态：$\dim R(A)+\dim N(A^{\mathrm H})=n$ 不只是计数，还是**正交分解**。与例 1.6.4 会师：若 $A^2=A$，则 $\mathbb C^n=R(A)\dotplus N(A)$；若还有 $A=A^{\mathrm H}$，则 $R(A)=R(A^{\mathrm H})=(N(A))^{\perp}$（例 1.6.7），分解升级为正交直和——**幂等 + Hermite = 正交投影矩阵**，上半场的投影理论与下半场的正交理论在此闭合。这四个子空间是后续奇异值分解、最小二乘与 Moore–Penrose 伪逆的共同地基。

:::

<a id="sec-1.6.10"></a>

## 1.6.10 小结与常见错误

下面这张表把本节的对象压成一页。读它有一个诀窍：「必须记住」一列记的是判据与依赖关系，「高频错误」一列才是真正扣分的地方——两者往往只差一个前提。

| 核心对象 | 必须记住 | 高频错误 |
|:--|:--|:--|
| 直和 $W_1\dotplus W_2$ | 和空间中**每个**向量拆法唯一 | 只验证「某个向量」表法唯一就下结论 |
| 判定定理 1.6.1 | 四条等价：直和 ⟺ 零元表法唯一 ⟺ 交为零 ⟺ 维数相加 | 用 $W_1\cup W_2$ 参与判定；忘记 (4) 依赖维数公式 |
| 投影 | 定义在**整个分解** $V=W_1\dotplus W_2$ 上 | 只说「在 $W_1$ 上的投影」不提补空间；默认投影必垂直 |
| 求投影 | 拼基 → 解 $G\boldsymbol{k}=\boldsymbol{c}$ → 分组组装 | Gram 下标与内积约定不配套（同 [1.4.6](sec14.md#sec-1.4.6) 的易错点） |
| 幂等矩阵 | $A^2=A\Rightarrow\mathbb C^n=R(A)\dotplus N(A)=R(A)\dotplus R(I-A)$ | 以为 $R(I-A)$ 与 $N(A)$ 是两个不同的事实；漏证「相等」只证「直和」 |
| 正交子空间 | $W_1\perp W_2$：每一个对每一个；查**基对基**即可 | 把几何「垂直」当正交（墙角反例 [@ex-1.6.5]）；只抽查部分方向 |
| 正交补 $W^{\perp}$ | $V=W\oplus W^{\perp}$；$\dim W^{\perp}=n-\dim W$；$(W^{\perp})^{\perp}=W$ | 把 $W^{\perp}$ 当「随便一个补」；忘记先有内积才有 $W^{\perp}$（勘误 E11） |
| 正交投影 | 沿 $W^{\perp}$ 落下，只由 $W$ 与内积决定；**最近点** | 谈正交投影还惦记「选补」；以为一般投影自动垂直 |
| 投影公式 | 正交基：$\sum\dfrac{(\boldsymbol{y},\boldsymbol{x}_i)}{(\boldsymbol{x}_i,\boldsymbol{x}_i)}\boldsymbol{x}_i$；标准正交基去掉分母 | **对非正交基直接套用**（勘误 E12 的教训）；用前不查基是否正交 |
| GS 与过渡矩阵 | $(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)=(\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n)A$，$A$ 正线上三角（QR 雏形） | 把对角元写成 $1$（应为 $\|\boldsymbol{y}_k\|$）；上三角元素下标写反 |
| $N(A)\oplus R(A^{\mathrm H})$ | 任意方阵白送的正交分解；$R(A^{\mathrm H})=(N(A))^{\perp}$ | 与 $R(A)$ 混为一谈（仅当 $A=A^{\mathrm H}$ 时二者相等） |

**本节主线：**和空间中拆法不唯一是常态，「交为零」把不唯一性排除掉，得到直和——四条判据各有适用场合。直和分解让每个向量拥有属于各子空间的唯一分量，也就是投影；幂等矩阵 $A^2=A$ 再把分解与投影编码进一个矩阵等式。

下半场让内积接管：正交自动排除共享非零向量（定理 1.6.2 一行证明），正交补成为法定的补空间（定理 1.6.4），正交投影随之唯一、并且是 $W$ 中离 $\boldsymbol{x}$ 最近的点；Gram–Schmidt 供应投影公式所需的正交基，并把换基关系整理成正线上三角矩阵——QR 分解的雏形。最后，任意方阵自带 $\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$，直和、正交补与秩在一行等式里会师。

把这一节放回第一章看：1.1–1.3 搭起线性空间、子空间、基与维数这套线性结构，1.4–1.5 装上内积、长度与正交，本节让两条线在「分解」上合流——线性结构保证拆法唯一，内积再把补空间钉成正交补。全章的两条线索——**分解**与**正交**——在这里第一次同时到位；第二章的线性映射、特征值与正交变换，都从这里长出来。

::: errata 勘误 E14 · 课件页 16–17 页眉沿用 1.5 节标题

课件《1.6 直和与投影》下半部分最后两页（小结页与例 1.6.7 页）的页眉误作「第一章 线性空间引论——**向量长度与夹角**」，系沿用 1.5 课件模板未改；此前各页页眉均为「直和与投影」。

:::

::: errata 勘误 E15 · 课件 1.6（下）的排版与图文小疵

不影响数学内容、一并记录的小问题：① 小结页「基本概念」列举句以顿号「正交投影、」收尾，且「重要结论」只收直和判定定理，漏收定理 1.6.3、1.6.4（正交补是子空间、正交分解定理）；② 页 4 插图中出现正文未定义的 $W_3$ 标签（图文不符，疑复制自例 1.6.5 的图）；③ 页 15 过渡矩阵只印出左下角一个 $0$，其余下三角元素空缺；④ 页 8 公式上标 $\boldsymbol{1}$ 误用粗体数字、页 14 公式末尾的 $\boldsymbol{y}_i$ 误排为细体、页 6 与页 8 插图的原点记号 $O$ 与 $o$ 不一致。

:::

::: method 即时自测 · 1.6

本节覆盖两次课的内容，自测 6 题。失分点集中在「**判定条件用哪个**」「**投影的依赖对象**」，以及下半场的「**正交基公式用错场合**」「**把几何垂直当子空间正交**」。

::: hint 第 1 题 · 记忆

写出直和判定定理的四条等价命题，并给每条标注「适合什么场合使用」。（对应 [1.6.2](sec16.md#sec-1.6.2)）
:::

::: sol 第 1 题答案

（1）$W_1+W_2$ 是直和（定义，证唯一性时用）；（2）零元素表法唯一（证「两表法相减」类问题时用）；（3）$W_1\cap W_2=\{\boldsymbol{\theta}\}$（给了具体子空间时最快）；（4）$\dim(W_1+W_2)=\dim W_1+\dim W_2$（只知道维数 / 秩时用，配维数公式）。
:::

::: hint 第 2 题 · 证明

证明 $\mathbb C^{n\times n}=\{A\mid A^{\mathrm H}=A\}\dotplus\{A\mid A^{\mathrm H}=-A\}$（Hermite ⊕ 反 Hermite），并写出任意复方阵的分解式。（对应 [1.6.2](sec16.md#sec-1.6.2) 的迁移思考）
:::

::: sol 第 2 题答案

分解式 $A=\tfrac12(A^{\mathrm H}+A)+\tfrac12(A-A^{\mathrm H})$，前项满足 $\big[\tfrac12(A^{\mathrm H}+A)\big]^{\mathrm H}$ 对称于自身（Hermite），后项反 Hermite，故和覆盖全空间。若 $B=B^{\mathrm H}=-B^{\mathrm H}$，则 $B=-B$ 即 $B=O$，交为零，由判定定理 (3) 得直和。
:::

::: hint 第 3 题 · 应用

$\mathbb R^3$ 中 $W_1=\operatorname{span}\{(1,0,1)^{\mathrm T}\}$，$W_2=\{(x_1,x_2,x_3)^{\mathrm T}\mid x_3=0\}$。求 $\boldsymbol{x}=(2,1,2)^{\mathrm T}$ 在 $W_1$ 与 $W_2$ 上的投影（沿分解 $V=W_1\dotplus W_2$）。（对应 [1.6.3](sec16.md#sec-1.6.3)）
:::

::: sol 第 3 题答案

$\boldsymbol{x}=(2,1,2)^{\mathrm T}=2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_3$（$\boldsymbol{\varepsilon}_1=(1,0,1)^{\mathrm T}$，$\boldsymbol{\varepsilon}_3=(0,1,0)^{\mathrm T}$），故在 $W_1$ 上的投影为 $2\boldsymbol{\varepsilon}_1=(2,0,2)^{\mathrm T}$，在 $W_2$ 上的投影为 $\boldsymbol{\varepsilon}_3=(0,1,0)^{\mathrm T}$。核对：和为 $(2,1,2)^{\mathrm T}$ ✓。本题数字恰好可以直接读出系数；若系数不能直接读出，就按例 1.6.3 的三步算法走。
:::

::: hint 第 4 题 · 辨析

(1) 「$\boldsymbol{y}$ 是 $\boldsymbol{x}$ 在 $W_1$ 上的投影」这句话缺了什么信息？(2) $A^2=A$ 时 $N(A)$ 等于什么？需要几步证明？（对应 [1.6.3](sec16.md#sec-1.6.3)、[1.6.4](sec16.md#sec-1.6.4)）
:::

::: sol 第 4 题答案

(1) 缺「沿哪个补空间」：同一 $W_1$ 配不同补给出不同投影（$\mathbb R^2$ 中 $x$ 轴分别配 $y$ 轴与配 $\operatorname{span}\{(1,1)\}$，$(1,1)^{\mathrm T}$ 的投影分别是 $(1,0)^{\mathrm T}$ 与 $\boldsymbol{0}$）。只有补取正交补时投影才唯一且「垂直落下」。

(2) $N(A)=R(I-A)$，两步双向包含（见 [1.6.4](sec16.md#sec-1.6.4) 的思考框）：$A\boldsymbol{x}=\boldsymbol{0}\Rightarrow\boldsymbol{x}=(I-A)\boldsymbol{x}\in R(I-A)$；$\boldsymbol{x}\in R(I-A)\Rightarrow A\boldsymbol{x}=\boldsymbol{0}$。
:::

::: hint 第 5 题 · 应用

$\mathbb R^3$ 中 $W=\operatorname{span}\{(1,1,0)^{\mathrm T},(1,1,2)^{\mathrm T}\}$。求 $W^{\perp}$ 与其维数，并求 $\boldsymbol{x}=(1,2,3)^{\mathrm T}$ 的正交投影两分量（先补后投）。（对应 [1.6.6](sec16.md#sec-1.6.6)、[1.6.7](sec16.md#sec-1.6.7)）
:::

::: sol 第 5 题答案

设 $\boldsymbol{u}=(a,b,c)^{\mathrm T}\perp W$：$a+b=0$、$a+b+2c=0$，解得 $b=-a$、$c=0$，故 $W^{\perp}=\operatorname{span}\{(1,-1,0)^{\mathrm T}\}$（一维 $=3-2$ ✓）。于是

$$\boldsymbol{z}=\operatorname{Proj}_{W^{\perp}}\boldsymbol{x}=\frac{(\boldsymbol{x},\boldsymbol{u})}{(\boldsymbol{u},\boldsymbol{u})}\boldsymbol{u}=\frac{-1}{2}(1,-1,0)^{\mathrm T}=\Big(-\tfrac12,\tfrac12,0\Big)^{\mathrm T},$$

$$\boldsymbol{y}=\boldsymbol{x}-\boldsymbol{z}=\Big(\tfrac32,\tfrac32,3\Big)^{\mathrm T}=\tfrac32(1,1,2)^{\mathrm T}\in W\ \checkmark .$$

勾股核对：$\|\boldsymbol{x}\|^2=14=\tfrac{27}{2}+\tfrac12=\|\boldsymbol{y}\|^2+\|\boldsymbol{z}\|^2$ ✓。
:::

::: hint 第 6 题 · 证明

写出例 1.6.7 的三步证明骨架，并回答：证 $R(A^{\mathrm H})=(N(A))^{\perp}$ 为什么用「包含 + 维数相等」而不用双向包含？（对应 [1.6.9](sec16.md#sec-1.6.9)）
:::

::: sol 第 6 题答案

① $R(A^{\mathrm H})\perp N(A)$：$\boldsymbol{y}=A^{\mathrm H}\boldsymbol{u}$、$A\boldsymbol{x}=\boldsymbol{0}$ 时 $(\boldsymbol{y},\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}\boldsymbol{u}=(A\boldsymbol{x})^{\mathrm H}\boldsymbol{u}=0$；② $\operatorname{rank}A^{\mathrm H}=\operatorname{rank}A$（转置由行秩 = 列秩；共轭保持非平凡组合的一一对应）；③ $\dim N(A)+\dim R(A^{\mathrm H})=(n-r)+r=n$，判据 (4) 给出直和，再由 ① 的包含与等维得 $(N(A))^{\perp}=R(A^{\mathrm H})$。

反向包含需要对每个 $\boldsymbol{y}\perp N(A)$ 构造 $\boldsymbol{u}$ 使 $\boldsymbol{y}=A^{\mathrm H}\boldsymbol{u}$（解方程、用秩的结构）；「包含 + 等维」绕开构造，是有限维的省力模板（同 $(W^{\perp})^{\perp}=W$）。
:::

:::
