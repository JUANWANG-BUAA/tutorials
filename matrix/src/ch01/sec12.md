# 1.2 线性子空间

线性空间内部的「平直」部分——对线性运算依然封闭的子集——称为子空间。判断一个子集是不是子空间，逐条核对八条公理当然可行，却笨重得没有实用价值；本节给出一条**判定定理**，把八条公理压缩成**两条**（对加法封闭、对数乘封闭），或用**一条**（$k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W$）一次覆盖。有了它，就能认出四类天然子空间：交空间、和空间，以及由矩阵产生的零空间 $N(A)$ 与列空间 $R(A)$——它们是后续「解线性方程组」的语言基础。

::: preview 先抓住一件事

子空间的关键不在形状，而在**对线性组合封闭**。齐次约束通常给出子空间；平移、常数项与不等式则常把零向量挡在门外。这是比记忆例子更可靠的辨别线索。
:::

<a id="sec-1.2.1"></a>

## 1.2.1 子空间的定义与平凡子空间

::: def 定义 1.2.1 · 子空间 subspace {#def-1.2.1}

设 $V$ 是数域 $F$ 上的线性空间，$W$ 是 $V$ 的非空子集。若 $W$ 中的向量关于 $V$ 中定义的加法和数乘运算**也构成** $F$ 上的线性空间，则称 $W$ 是 $V$ 的**子空间**。

:::

::: note

定义里有两个要点，后面都会用到：① $W$ 必须先是 $V$ 的**子集**；② 运算必须继承 $V$ 中已有的定义，不能另行规定。要点 ② 尤其要紧——运算没有换，判定定理才有机会把八条公理压缩下来。

:::

::: ex 例 1.2.1 · 解集合是子空间 {#ex-1.2.1}

取定矩阵 $A\in\mathbb{C}^{m\times n}$，定义集合 $W=\{\boldsymbol{x}\in\mathbb{C}^n\mid A\boldsymbol{x}=\boldsymbol{0}\}$，则 $W$ 是 $\mathbb{C}^n$ 的子空间。

::: sol 解答

首先 $A\boldsymbol{0}=\boldsymbol{0}$，故 $\boldsymbol{0}\in W$，$W$ 非空且是 $\mathbb{C}^n$ 的子集。$\forall\boldsymbol{x},\boldsymbol{y}\in W$ 和 $\mu,\lambda\in\mathbb{C}$：由矩阵运算的线性性（先修知识）

$$A(\mu\boldsymbol{x}+\lambda\boldsymbol{y})=\mu A\boldsymbol{x}+\lambda A\boldsymbol{y}=\mu\boldsymbol{0}+\lambda\boldsymbol{0}=\boldsymbol{0},$$

故 $\mu\boldsymbol{x}+\lambda\boldsymbol{y}\in W$，即 $W$ 对线性运算封闭，从而是 $\mathbb{C}$ 上的线性空间，进而是 $\mathbb{C}^n$ 的子空间。

:::

这个 $W$ 就是**零空间**，也是「齐次方程给出子空间」最典型的例子。它的正式记号与系统讨论见 [1.2.7](sec12.md#sec-1.2.7)。

:::

::: ex 例 1.2.E · 齐次与非齐次：只差一个常数，性质完全不同 {#ex-1.2.E}

在 $\mathbb R^2$ 中比较

$$W=\{(x,y)^{\mathrm T}\mid x+y=0\},\qquad S=\{(x,y)^{\mathrm T}\mid x+y=1\}.$$

它们在图上都是直线。哪一条是子空间？请分别给出最快判断与完整判断。

::: sol 解答

**最快判断。**$W$ 经过原点，$S$ 不经过原点，于是 $S$ 不含零向量，直接排除。但「经过原点」只是必要条件：它替 $W$ 洗清了嫌疑，却不足以证明 $W$ 合格，封闭性仍要验证。

**完整判断。**任取 $\boldsymbol u=(x_1,y_1)^{\mathrm T},\boldsymbol v=(x_2,y_2)^{\mathrm T}\in W$ 与 $a,b\in\mathbb R$，则

$$ (ax_1+bx_2)+(ay_1+by_2)=a(x_1+y_1)+b(x_2+y_2)=0, $$

所以 $a\boldsymbol u+b\boldsymbol v\in W$，由子空间判定定理，$W$ 是子空间。

而 $S$ 不仅不含零向量，也不对数乘封闭：$(1,0)^{\mathrm T}\in S$，但 $2(1,0)^{\mathrm T}=(2,0)^{\mathrm T}\notin S$。

**迁移结论。**线性方程组 $A\boldsymbol x=\boldsymbol0$ 的解集一定是子空间。当 $\boldsymbol b\ne\boldsymbol0$ 时，$A\boldsymbol x=\boldsymbol b$ 的解集**一定不是**子空间：先看它是否非空——若为空集，它本就不是子空间（子空间必须非空，见 [@def-1.2.1]）；若非空，取任一解 $\boldsymbol x_0$，由 $\boldsymbol 0=A\boldsymbol0\ne\boldsymbol b=A\boldsymbol x_0$ 知 $\boldsymbol0$ 不在解集里，同样不是子空间。两种情形都不是子空间，区别只在于是不是空集。

:::

<figure aria-labelledby="fig-hom-aff-caption" class="concept-figure">
<svg aria-labelledby="fig-hom-aff-title fig-hom-aff-desc" role="img" viewBox="0 0 680 250">
<title id="fig-hom-aff-title">齐次直线与非齐次直线的对照</title>
<desc id="fig-hom-aff-desc">左边直线经过原点，对线性组合封闭；右边与它平行但离开原点，不是子空间。</desc>
<defs><marker id="hom-aff-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-neutral)"></path></marker></defs>
<rect class="diagram-node" height="205" rx="12" width="298" x="20" y="22"></rect>
<text class="diagram-mono" x="44" y="48">HOMOGENEOUS · x+y=0</text>
<line marker-end="url(#hom-aff-arrow)" stroke="var(--fig-neutral)" x1="58" x2="280" y1="180" y2="180"></line>
<line marker-end="url(#hom-aff-arrow)" stroke="var(--fig-neutral)" x1="169" x2="169" y1="208" y2="68"></line>
<line stroke="var(--fig-blue)" stroke-width="3" x1="82" x2="254" y1="82" y2="205"></line>
<circle cx="169" cy="180" fill="var(--fig-red)" r="4"></circle>
<text class="diagram-note" x="181" y="174">O 在集合内</text>
<text class="diagram-text" x="50" y="218">✓ 线性组合仍留在直线上</text>
<rect class="diagram-node" height="205" rx="12" width="298" x="362" y="22"></rect>
<text class="diagram-mono" x="386" y="48">NON-HOMOGENEOUS · x+y=1</text>
<line marker-end="url(#hom-aff-arrow)" stroke="var(--fig-neutral)" x1="400" x2="622" y1="180" y2="180"></line>
<line marker-end="url(#hom-aff-arrow)" stroke="var(--fig-neutral)" x1="511" x2="511" y1="208" y2="68"></line>
<line stroke="var(--fig-red)" stroke-width="3" x1="424" x2="596" y1="62" y2="185"></line>
<circle cx="511" cy="180" fill="var(--fig-neutral)" r="4"></circle>
<text class="diagram-note" x="523" y="174">O 不在集合内</text>
<text class="diagram-text" x="392" y="218">✕ 一眼排除：不含零向量</text>
</svg>
<figcaption id="fig-hom-aff-caption"><b>「经过原点」不是装饰条件。</b>齐次方程给出穿过原点的平直集合；非齐次常数项把它整体推离原点，也把子空间性质一起推走。</figcaption>
</figure>

:::

::: ex 例 1.2.2 · 零子空间与平凡子空间 {#ex-1.2.2}

在线性空间 $V$ 中，仅包含单个零向量的集合 $\{\boldsymbol{\theta}\}$ 是线性空间（$\boldsymbol{\theta}+\boldsymbol{\theta}=\boldsymbol{\theta}$，$k\boldsymbol{\theta}=\boldsymbol{\theta}$，八条公理逐条成立），称之为**零子空间**，记为 $\{\boldsymbol{\theta}\}$——它是只含一个元素的集合，不要与零元素 $\boldsymbol{\theta}$（一个向量）混为一谈。空间 $V$ 本身也是 $V$ 的一个子空间。子空间 $\{\boldsymbol{\theta}\}$ 和 $V$ 称为 $V$ 的**平凡子空间**（trivial subspaces）；其余子空间称为**非平凡子空间**。

::: note 两套划分，别混

「平凡 / 非平凡」与「真 / 不真」是**两套不同的划分标准**，不要并成一句：

- **平凡 / 非平凡**：按「是否只有 $\{\boldsymbol{\theta}\}$ 与 $V$ 这两个」划分；
- **真 / 不真**：按「$W\neq V$」划分（$W$ 是 $V$ 的**真**子空间）。

因此 $\{\boldsymbol{\theta}\}$ 既是平凡的、又是真的（只要 $V\neq\{\boldsymbol{\theta}\}$）；而 $V$ 是平凡的、却**不**是真的。说「非平凡」时不含真假判断。
:::

:::

::: ex 例 1.2.3 · 「看起来像」不等于「是」 {#ex-1.2.3}

问：向量空间 $\mathbb{R}^2$ 是 $\mathbb{R}^3$ 的子空间吗？

::: sol 解答

不是。因为 $\mathbb{R}^3$ 中的向量是 3 元有序数组，而 $\mathbb{R}^2$ 中的向量为 2 元有序数组，$\mathbb{R}^2$ **根本不是 $\mathbb{R}^3$ 的子集**——子空间的第一个前提就不满足。

但「像」不等于「是」：集合 $W=\{(\alpha_1,\alpha_2,0)^{\mathrm T}\mid \alpha_1,\alpha_2\in\mathbb{R}\}$ 的每个元素都是三元数组，它确实是 $\mathbb{R}^3$ 的子集；尽管它「很像 $\mathbb{R}^2$」，$W$ 仍是 $\mathbb{R}^3$ 的一个（真）子空间：$\forall\boldsymbol{\alpha},\boldsymbol{\beta}\in W,\ k\in\mathbb{R}$，和与数乘的第三分量仍为 $0$，封闭性成立。

**思考：**$W'=\{(\alpha_1,\alpha_2,\alpha_3)^{\mathrm T}\mid \alpha_i\in\mathbb{R}\ \text{且}\ \alpha_3\neq0\}$ 是 $\mathbb{R}^3$ 的子空间吗？**不是：**零向量 $(0,0,0)^{\mathrm T}$ 的第三分量为 $0$，不在 $W'$ 中；且第三分量非零的两向量相加第三分量可能为零（如 $(0,0,1)^{\mathrm T}+(0,0,-1)^{\mathrm T}$），加法也不封闭。

:::

:::

<a id="sec-1.2.2"></a>

## 1.2.2 子空间判定定理：八条公理压缩成两条

定义要求 $W$ **自己**构成线性空间，可八条公理逐条验证实在繁琐。好在运算继承自 $V$——这正是定义中要点 ② 的作用——多数公理是恒等式、会自动成立。于是判断一个子集能否成为子空间，只剩下「封闭性」这一件事要查。

::: thm 定理 1.2.1 · 子空间判定定理 {#thm-1.2.1}

设 $V$ 是 $F$ 上的线性空间，$W$ 是 $V$ 的一个非空子集。以下命题等价：

（1）$W$ 是 $V$ 的子空间；<br> （2）a. $\forall k\in F,\ \boldsymbol{\alpha}\in W$，有 $k\boldsymbol{\alpha}\in W$；　b. $\forall\boldsymbol{\alpha},\boldsymbol{\beta}\in W$，有 $\boldsymbol{\alpha}+\boldsymbol{\beta}\in W$；<br> （3）$\forall k,l\in F$ 和 $\boldsymbol{\alpha},\boldsymbol{\beta}\in W$，有 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W$。

:::

::: think 条件 (2)a 为什么不能省

课件在条件 (2)a 处留有一条批注「这在干啥？」，答案是：**条件 (2)a 保证了零向量落在 $W$ 中**。因为 $W$ 非空，可取 $\boldsymbol{\alpha}\in W$；令 $k=0$，由 (2)a 得 $0\boldsymbol{\alpha}=\boldsymbol{\theta}\in W$。这就是为什么 (2) 两条就够了，不必再单独验证「零元素存在」「负元素存在」——它们都可由 (2)a 得出（负元素：取 $k=-1$ 得 $-\boldsymbol{\alpha}=(-1)\boldsymbol{\alpha}\in W$）。

:::

::: proof 证（三条循环：(1)⟹(2)⟹(3)⟹(1)）

**(1)⟹(2)：**若 $W$ 是子空间，则 $W$ 自身是线性空间，对加法和数乘封闭，(2)a、(2)b 成立。

**(2)⟹(3)：**设 $k,l\in F$，$\boldsymbol{\alpha},\boldsymbol{\beta}\in W$。由 (2)a（取 $k,l$ 与 $\boldsymbol{\alpha},\boldsymbol{\beta}$）得 $k\boldsymbol{\alpha}\in W,\ l\boldsymbol{\beta}\in W$；再由 (2)b 得 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W$。

**(3)⟹(1)：**需证 $W$ 在继承运算下构成线性空间，即八条公理。八条公理分两类，处理方式并不相同：

· **「等式型」公理自动继承。**交换律、结合律、两条分配律、数乘结合律、单位律都是恒等式：对 $W$ 中任意元素，等式两边是同样的 $V$ 中元素，而等式在 $V$ 中成立，故在 $W$ 中成立。条件 (3)（取 $k=l=1$ 得加法封闭；取 $l=0$ 得数乘封闭）保证运算不跑出 $W$，等式两边因此确实都在 $W$ 内。

· **「存在型」断言必须亲自构造。**零元素与负元素在 $V$ 中存在不能自动搬到 $W$——$V$ 的零元未必落在子集 $W$ 里！利用 (3)：$W$ 非空，取 $\boldsymbol{\alpha}_0\in W$（条件 (3) 里要有两个向量，第二个向量 $\boldsymbol{\beta}$ 可任取——就取 $\boldsymbol{\beta}=\boldsymbol{\alpha}_0$），则

$$\boldsymbol{\theta}=0\boldsymbol{\alpha}_0+0\boldsymbol{\alpha}_0\in W\ (\text{取 } k=l=0);\qquad -\boldsymbol{\alpha}=(-1)\boldsymbol{\alpha}+0\boldsymbol{\alpha}_0\in W\ (\text{取 } k=-1,\,l=0).$$

零元素、负元素都在 $W$ 中且性质照旧成立，故八条公理齐备，$W$ 是 $F$ 上的线性空间，从而是 $V$ 的子空间。

:::

::: note

**注 1。**检验子空间时，**先看零向量在不在 $W$ 中**——这是最快的否决手段：零向量不在，直接判负。真正的验证则常用条件 (3)「一步到位」：任取 $\boldsymbol{\alpha},\boldsymbol{\beta}\in W$，$k,l\in F$，验证 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W$。

:::

::: method 判定流程 · 「$W$ 是不是 $V$ 的子空间」

第 1 步：$W$ 是 $V$ 的子集吗？（$\mathbb{R}^2\subset\mathbb{R}^3$ 这类第一关就倒下）→ 第 2 步：$\boldsymbol{\theta}\in W$ 吗？（不含零向量即可判负）→ 第 3 步：任取 $\boldsymbol{\alpha},\boldsymbol{\beta}\in W$、$k,l\in F$，验证 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W$（用条件 (3)，一次覆盖加法与数乘）。

:::

<a id="sec-1.2.3"></a>

## 1.2.3 矩阵空间中的子空间例题

判定流程给出了顺序，但每一类空间都要亲手算一遍。先看矩阵空间：元素是矩阵，封闭性的检验就得落到转置、迹、秩这些具体结构上。

::: ex 例 1.2.A · 对称、反对称、对角、迹零 {#ex-1.2.A}

取 $V=\mathbb{R}^{n\times n}$（第 (5) 小题设 $n\geq2$）。判断下列集合是否为 $V$ 的子空间：

(1) $W_1=\{A\in V\mid A^{\mathrm T}=A\}$（对称矩阵）；(2) $W_2=\{A\in V\mid A^{\mathrm T}=-A\}$（反对称矩阵）；<br> (3) $D=\{\text{对角矩阵}\}$；(4) $T=\{A\in V\mid \operatorname{tr}A=0\}$（迹为零）；(5) $R_1=\{\text{秩为 }1\text{ 的矩阵}\}\cup\{O\}$。

::: sol 解答

**(1) 是。**$O\in W_1$。任取 $A,B\in W_1$、$k,l\in\mathbb{R}$，则 $(kA+lB)^{\mathrm T}=kA^{\mathrm T}+lB^{\mathrm T}=kA+lB$，故 $kA+lB\in W_1$。

**(2) 是。**同法：$(kA+lB)^{\mathrm T}=kA^{\mathrm T}+lB^{\mathrm T}=-(kA+lB)$。

**(3) 是。**对角矩阵的和、数乘仍是对角矩阵；$O$ 是对角矩阵。

**(4) 是。**$\operatorname{tr}(kA+lB)=k\operatorname{tr}A+l\operatorname{tr}B=0$；$\operatorname{tr}O=0$。

**(5) 不是。**取 $E_{11}=\begin{pmatrix}1&0\\0&0\end{pmatrix}$ 与 $E_{22}=\begin{pmatrix}0&0\\0&1\end{pmatrix}$（以 $n=2$ 为例），两者秩均为 1，但 $E_{11}+E_{22}=I$ 秩为 2，不在集合中——加法不封闭。**「秩恰为某值」的集合几乎从不是子空间**，因为秩对加法**既不单调、也不可加**：只能保证次可加
$$\operatorname{rank}(A+B)\le\operatorname{rank}A+\operatorname{rank}B,$$
等号一般不成立，两个方向都会失手——上例 $E_{11}+E_{22}=I$ 是**变大**（$1+1\to2$），而 $E_{11}+(-E_{11})=O$ 是**变小**（$1+1\to0$）。

**边界提醒（$n=1$ 是例外）。**$\mathbb R^{1\times1}$ 中除 $O$ 外全是秩 1 矩阵，此时 $R_1=\mathbb R^{1\times1}$ **确实**是子空间——所以题干必须限定 $n\geq2$，答案「不是」才成立。这类「看起来对、在小维数翻转」的情形要养成顺手检查的习惯。

:::

:::

<a id="sec-1.2.4"></a>

## 1.2.4 齐次线性差分方程的解集（例 1.2.4）

判定流程并不依赖元素长什么样，换一类元素就该照用。下面的舞台是离散信号：「向量」成了整条双边序列，而检验的仍是同一件事——线性组合会不会跑出集合。

::: ex 例 1.2.4 · 线性滤波器背景 {#ex-1.2.4}

线性滤波器常用 $n$ 阶线性差分方程描述。考查齐次线性差分方程

$$u_{k+n}+a_{n-1}u_{k+n-1}+\cdots+a_1u_{k+1}+a_0u_k=0\qquad(a_i\in\mathbb{R}),$$

问：该差分方程的解集 $\tilde S$（每个解是一个双边序列）是线性空间吗？

::: note

**关于差分方程与线性滤波器。**微分方程联系一个函数及其各阶导数；**差分方程**联系一个序列相邻下标的项，是微分方程的「离散版」——下标 $k$ 扮演离散时刻，$u_{k+j}$ 是「$j$ 步之后」的值。「线性」指各 $u$ 都以一次方出现、系数 $a_i$ 是与 $u$ 无关的常数；「齐次」指右端为 $0$——与微分方程中的同名术语完全平行。它确实来自应用：一个**线性滤波器**把输入信号 $\{u_k\}$ 加工成输出信号 $y_k=c_0u_k+c_1u_{k-1}+\cdots+c_mu_{k-m}$（输出的当前值是输入的一段滑动线性组合），分析这类装置时自然会遇到本例的齐次差分方程。手边最小的例子：$u_{k+2}-u_{k+1}-2u_k=0$。猜解 $u_k=2^k$ 与 $u_k=(-1)^k$：

$$2^{k+2}-2^{k+1}-2\cdot2^k=(4-2-2)\,2^k=0,\qquad (-1)^{k+2}-(-1)^{k+1}-2(-1)^k=(1+1-2)(-1)^k=0,$$

两个等比序列都是解——「等比序列之于常系数差分方程」恰如「指数函数 $e^{\lambda t}$ 之于常系数微分方程」。事实上 [1.3.2](sec13.md#sec-1.3.2) 中的三个信号 $(-1)^k,\,2^k,\,3^k$ 正是方程 $u_{k+3}-4u_{k+2}+u_{k+1}+6u_k=0$ 的三个解（其特征多项式为 $(\lambda+1)(\lambda-2)(\lambda-3)$，做法与微分方程的特征根法同理，本课程不展开）。

:::

::: sol 解答

$\tilde S$ 中的元素是信号（双边序列），故 $\tilde S\subseteq S$（离散时间信号空间）。由于**零序列**（所有 $u_k=0$）满足方程，$\tilde S$ 非空。任取 $\{u_k\},\{v_k\}\in\tilde S$ 与 $\mu,\lambda\in\mathbb{R}$，对每个下标 $k$，利用方程的线性性逐项重排：

$$\begin{aligned}&(\mu u_{k+n}+\lambda v_{k+n})+a_{n-1}(\mu u_{k+n-1}+\lambda v_{k+n-1})+\cdots+a_0(\mu u_k+\lambda v_k)\\
=&\ \mu\big(u_{k+n}+a_{n-1}u_{k+n-1}+\cdots+a_0u_k\big)+\lambda\big(v_{k+n}+a_{n-1}v_{k+n-1}+\cdots+a_0v_k\big)\\
=&\ \mu\cdot 0+\lambda\cdot 0=0,\end{aligned}$$

即 $\{\mu u_k+\lambda v_k\}$ 仍是解，$\mu\{u_k\}+\lambda\{v_k\}\in\tilde S$。由判定定理（条件 (3)），$\tilde S$ 是信号空间 $S$ 的子空间，因而是线性空间。

:::

::: note

**结构对照。**「齐次方程 + 线性运算」→ 解集是子空间，这条规律在 $\{A\boldsymbol{x}=\boldsymbol{0}\}$（[@ex-1.2.1]）、差分方程（本例）中反复出现；反过来，**非齐次**方程（右端非零）的解集从不是子空间——它不含零元素（习题 A8）。

:::

:::

<a id="sec-1.2.5"></a>

## 1.2.5 交、并与和：只有两个是子空间

子空间不只能逐个检验，还能由已有的子空间造出来。最自然的三种造法是交、并、和，可惜它们并不同样可靠。

::: ex 例 1.2.5 · 三个集合的初步考察 {#ex-1.2.5}

设 $W_1,W_2$ 是 $V$ 的子空间，定义三个集合：

$$W_1\cap W_2=\{\boldsymbol{\alpha}\in V\mid \boldsymbol{\alpha}\in W_1\ \text{且}\ \boldsymbol{\alpha}\in W_2\},$$
$$W_1\cup W_2=\{\boldsymbol{\alpha}\in V\mid \boldsymbol{\alpha}\in W_1\ \text{或}\ \boldsymbol{\alpha}\in W_2\},$$
$$W_1+W_2=\{\boldsymbol{\alpha}_1+\boldsymbol{\alpha}_2\mid \boldsymbol{\alpha}_1\in W_1,\ \boldsymbol{\alpha}_2\in W_2\},$$

试判断它们是否是 $V$ 的子空间。

::: sol 分析

取 $W_1=x$ 轴，$W_2=yOz$ 平面（两者都是 $\mathbb{R}^3$ 的子空间）。则

· $W_1\cap W_2=\{\boldsymbol{\theta}\}$（$x$ 轴与 $yOz$ 平面只交于原点）；

· $W_1+W_2=\mathbb{R}^3$（任一向量 $(a,b,c)=(a,0,0)+(0,b,c)$，第一项在 $x$ 轴、第二项在 $yOz$ 平面）；

· $W_1\cup W_2$ 不是子空间：$(1,0,0)\in W_1$、$(0,0,1)\in W_2$，但两者的和 $(1,0,1)$ 既不在 $x$ 轴也不在 $yOz$ 平面——**「或」的集合对加法不封闭**。

:::

<figure aria-labelledby="fig-union-caption">
<svg font-size="11.5" height="200" viewBox="0 0 430 200" width="430" xmlns="http://www.w3.org/2000/svg" aria-labelledby="fig-union-title fig-union-desc" role="img" aria-describedby="fig-union-caption">
<title id="fig-union-title">两个子空间的并集不是子空间</title>
<desc id="fig-union-desc">x 轴 W₁ 与 yOz 平面 W₂ 都是 ℝ³ 的子空间，但它们的并集不是：向量 (1,0,0) 与 (0,0,1) 分别属于两个子空间，其和 (1,0,1) 却既不在 x 轴上也不在 yOz 平面内，说明并集对加法不封闭。</desc>
<defs><marker id="a2" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="2.6"><path d="M0,0 L6.5,2.6 L0,5.2 Z" fill="var(--fig-neutral)"></path></marker></defs>
<!-- yOz plane -->
<polygon fill="var(--fig-blue)" opacity="0.13" points="120,30 265,80 200,180 55,130" stroke="var(--fig-blue)" stroke-width="1.1"></polygon>
<text fill="var(--fig-blue)" x="228" y="72">W₂ = yOz 平面</text>
<!-- x axis (W1) -->
<line marker-end="url(#a2)" stroke="var(--fig-red)" stroke-width="2.2" x1="30" x2="250" y1="160" y2="130"></line>
<text fill="var(--fig-red)" x="240" y="122">W₁ = x 轴</text>
<!-- z axis inside plane -->
<line marker-end="url(#a2)" stroke="var(--fig-neutral)" stroke-width="1.1" x1="138" x2="190" y1="105" y2="30"></line><text fill="var(--fig-neutral)" x="185" y="26">z</text>
<!-- y axis inside plane -->
<line marker-end="url(#a2)" stroke="var(--fig-neutral)" stroke-width="1.1" x1="138" x2="265" y1="105" y2="105"></line><text fill="var(--fig-neutral)" x="268" y="102">y</text>
<circle cx="138" cy="105" fill="var(--fig-neutral)" r="3"></circle><text fill="var(--fig-neutral)" x="122" y="122">O=θ</text>
<!-- vector (1,0,1) dashed -->
<line marker-end="url(#a2)" stroke="var(--fig-green)" stroke-dasharray="5 3" stroke-width="1.8" x1="138" x2="196" y1="105" y2="52"></line>
<text fill="var(--fig-green)" x="212" y="46">(1,0,1)=(1,0,0)+(0,0,1) ∉ W₁∪W₂</text>
</svg>
<figcaption>图 1-2 · 例 1.2.5 的几何图景：交是 $\{\boldsymbol{\theta}\}$，和是全空间；并集 $W_1\cup W_2$ 并不是子空间</figcaption>
<figcaption id="fig-union-caption">x 轴 W₁ 与 yOz 平面 W₂ 都是 ℝ³ 的子空间，但它们的并集不是：向量 (1,0,0) 与 (0,0,1) 分别属于两个子空间，其和 (1,0,1) 却既不在 x 轴上也不在 yOz 平面内，说明并集对加法不封闭。</figcaption>
</figure>

:::

交与和对**任意**两个子空间都成立，并则随时可能失守——下面把这两条普遍结论证出来。

::: thm 定理 1.2.2 · 和空间与交空间 {#thm-1.2.2}

设 $W_1,W_2$ 是数域 $F$ 上线性空间 $V$ 的子空间，则集合

$$W_1\cap W_2=\{\boldsymbol{\alpha}\in V\mid \boldsymbol{\alpha}\in W_1\ \text{且}\ \boldsymbol{\alpha}\in W_2\},\qquad
W_1+W_2=\{\boldsymbol{\alpha}_1+\boldsymbol{\alpha}_2\mid \boldsymbol{\alpha}_1\in W_1,\boldsymbol{\alpha}_2\in W_2\}$$

都是 $V$ 的子空间，分别称为 $W_1$ 与 $W_2$ 的**交（交空间）**与**和（和空间）**（intersection / sum of subspaces）。同理，可定义多个子空间的交与和。而 $W_1\cup W_2$ 一般**不是**子空间。

:::

::: proof 证

**交空间：**$\boldsymbol{\theta}\in W_1$ 且 $\boldsymbol{\theta}\in W_2$，故 $W_1\cap W_2$ 非空。任取 $\boldsymbol{\alpha},\boldsymbol{\beta}\in W_1\cap W_2$、$k,l\in F$：由 $\boldsymbol{\alpha},\boldsymbol{\beta}\in W_1$ 且 $W_1$ 是子空间得 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W_1$；同理 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W_2$。故 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W_1\cap W_2$。由判定定理，$W_1\cap W_2$ 是子空间。

**和空间：**$\boldsymbol{\theta}=\boldsymbol{\theta}+\boldsymbol{\theta}\in W_1+W_2$，非空。任取 $\boldsymbol{\gamma}= \boldsymbol{\alpha}_1+\boldsymbol{\alpha}_2$、$\boldsymbol{\delta}=\boldsymbol{\beta}_1+\boldsymbol{\beta}_2$（下标 1 的属于 $W_1$、下标 2 的属于 $W_2$）与 $k,l\in F$：

$$k\boldsymbol{\gamma}+l\boldsymbol{\delta}=(k\boldsymbol{\alpha}_1+l\boldsymbol{\beta}_1)+(k\boldsymbol{\alpha}_2+l\boldsymbol{\beta}_2),$$

第一个括号 $\in W_1$、第二个括号 $\in W_2$（各自是子空间的元素组合），故 $k\boldsymbol{\gamma}+l\boldsymbol{\delta}\in W_1+W_2$。由判定定理，$W_1+W_2$ 是子空间。

**并不是子空间：**见[@ex-1.2.5] 的反例（也可一般化：$W_1\cup W_2$ 是子空间当且仅当 $W_1\subseteq W_2$ 或 $W_2\subseteq W_1$，证明见习题 B3）。

:::

::: note

**和空间的角色。**$W_1+W_2$ 是「既包含 $W_1$ 又包含 $W_2$」的最小子空间：任何包含 $W_1\cup W_2$ 的子空间必含所有和 $\boldsymbol{\alpha}_1+\boldsymbol{\alpha}_2$。想要「并」的子空间版本，答案就是「和」。

:::

<a id="sec-1.2.6"></a>

## 1.2.6 对称 + 反对称分解（例 1.2.6，完整证明）

交与和这两个工具第一次联手，就把整个矩阵空间拆成了两块：每个方阵都能写成对称矩阵与反对称矩阵之和。

::: ex 例 1.2.6 {#ex-1.2.6}

取 $V=\mathbb{R}^{n\times n}$，定义 $W_1=\{A\in V\mid A^{\mathrm T}=A\}$，$W_2=\{A\in V\mid A^{\mathrm T}=-A\}$。试证明 $W_1,W_2$ 是 $V$ 的子空间，且 $V=W_1+W_2$。

::: proof 证

**第一步（子空间）：**即[@ex-1.2.A] 的 (1)(2)。$O\in W_1\cap W_2$；$\forall A,B\in W_1,\ k,l\in\mathbb{R}$，$(kA+lB)^{\mathrm T}=kA^{\mathrm T}+lB^{\mathrm T}=kA+lB$，故 $kA+lB\in W_1$；$W_2$ 同理。

**第二步（$V=W_1+W_2$）：**先看两个包含关系。若 $S\in W_1$、$K\in W_2$，则二者都属于 $V$，而 $V$ 对加法封闭，所以 $S+K\in V$，即 $W_1+W_2\subseteq V$。因此只须证 $V\subseteq W_1+W_2$。对 $V$ 中任一矩阵 $A$，考察分解式

$$A=\underbrace{\tfrac{1}{2}(A^{\mathrm T}+A)}_{\in W_1}+\underbrace{\tfrac{1}{2}\big({-A}^{\mathrm T}+A\big)}_{\in W_2},$$

两项的归属分别验证：$\big[\tfrac12(A^{\mathrm T}+A)\big]^{\mathrm T}=\tfrac12(A+A^{\mathrm T})=\tfrac12(A^{\mathrm T}+A)$，对称；$\big[\tfrac12(-A^{\mathrm T}+A)\big]^{\mathrm T}=\tfrac12(-A+A^{\mathrm T})=-\tfrac12(-A^{\mathrm T}+A)$，反对称。故任一 $A$ 都能写成 $W_1$ 元素与 $W_2$ 元素之和，$V\subseteq W_1+W_2$，结合反向包含得 $V=W_1+W_2$。

:::

::: think 分解还是唯一的

若 $A=S_1+K_1=S_2+K_2$（$S_i$ 对称、$K_i$ 反对称），则 $S_1-S_2=K_2-K_1$。左边对称、右边反对称，故这个矩阵既对称又反对称：$X^{\mathrm T}=X$ 且 $X^{\mathrm T}=-X$ 联立得 $X=-X$ 即 $X=O$。于是 $S_1=S_2,\ K_1=K_2$——每个方阵的「对称 + 反对称」分解式唯一。这一现象（和空间中分解唯一）与 $W_1\cap W_2=\{\boldsymbol{\theta}\}$（既对称又反对称的矩阵只有零矩阵）直接相关，后续课程将把这种和正式命名为**直和**。

一个数字上的印证（学完 [1.3](sec13.md) 后可回头看）：$\dim V=n^2$，$\dim W_1=\tfrac{n(n+1)}2$，$\dim W_2=\tfrac{n(n-1)}2$，$\dim(W_1\cap W_2)=0$，恰好 $n^2=\tfrac{n(n+1)}2+\tfrac{n(n-1)}2-0$——维数公式（[@thm-1.3.5]）的天然例证。

:::

:::

<a id="sec-1.2.7"></a>

## 1.2.7 矩阵的零空间与列空间：两个最重要的子空间

到此为止，子空间都是我们挑出来再逐个检验的。矩阵却能自己生成子空间，而且是最有用的两个：一个回答「方程组何时有解」，一个刻画「解有多大的自由度」。

::: def 定义 1.2.2 · 矩阵零空间 null space（核空间 kernel） {#def-1.2.2}

设 $A\in\mathbb{C}^{m\times n}$，则矩阵 $A$ 的**零空间**（或核空间）定义为齐次线性方程组 $A\boldsymbol{x}=\boldsymbol{0}$ 的解集：

$$N(A)=\{\boldsymbol{x}\in\mathbb{C}^n\mid A\boldsymbol{x}=\boldsymbol{0}\}.$$

**注 2。**$A$ 的零空间**即**齐次方程组 $A\boldsymbol{x}=\boldsymbol{0}$ 的解空间（solution space）——两者是同一个集合的两种叫法，不是两个待证等价的对象。

:::

::: def 定义 1.2.3 · 矩阵列空间 column space（值空间 range） {#def-1.2.3}

设 $A\in\mathbb{C}^{m\times n}$，则矩阵 $A$ 的**列空间**（或值空间 range）是由 $A$ 的列的所有线性组合组成的集合：

$$R(A)=\{\boldsymbol{y}\in\mathbb{C}^m\mid \boldsymbol{y}=A\boldsymbol{x},\ \boldsymbol{x}\in\mathbb{C}^n\}.$$

:::

::: note

**所在空间。**$A$ 是 $m\times n$ 的，则 $N(A)$ 住在「输入侧」$\mathbb{C}^n$，$R(A)$ 住在「输出侧」$\mathbb{C}^m$——两者所在的空间维度都不同！两者都是子空间：$N(A)$ 即[@ex-1.2.1]；$R(A)$ 的验证：$\boldsymbol{y}_1=A\boldsymbol{x}_1,\ \boldsymbol{y}_2=A\boldsymbol{x}_2$，则 $k\boldsymbol{y}_1+l\boldsymbol{y}_2=A(k\boldsymbol{x}_1+l\boldsymbol{x}_2)\in R(A)$。

:::

::: ex 例 1.2.7 · 列组合观点 {#ex-1.2.7}

设 $A=\begin{pmatrix}1&2\\1&-1\end{pmatrix}$，$\boldsymbol{x}=(x_1,x_2)^{\mathrm T}$，$\boldsymbol{y}=(y_1,y_2)^{\mathrm T}$，则

$$\boldsymbol{y}=A\boldsymbol{x}=\begin{pmatrix}1\\1\end{pmatrix}x_1+\begin{pmatrix}2\\-1\end{pmatrix}x_2,$$

即向量 $\boldsymbol{y}$ 是 $A$ 的列的线性组合。当 $\boldsymbol{x}$ 取遍 $\mathbb{C}^n$ 时，$R(A)$ 表示由 $A$ 的列的所有线性组合组成的集合。

:::

::: def 定义 1.2.4 · 张成（生成）子空间 span {#def-1.2.4}

若 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 是线性空间 $V$ 中一组向量，记

$$W=\{k_1\boldsymbol{\alpha}_1+\cdots+k_n\boldsymbol{\alpha}_n\mid k_i\in F,\ i=1,\cdots,n\},$$

则称 $W$ 是由向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ **张成（生成）的子空间**，记为 $\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$。

:::

::: thm 命题 1.2.1 · $R(A)$ 就是列的 span {#prop-1.2.1}

记 $A=(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$（按列分块），则 $R(A)=\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$。

::: proof 证

$\boldsymbol{y}\in R(A)$ $\Longleftrightarrow$ 存在 $\boldsymbol{x}=(x_1,\cdots,x_n)^{\mathrm T}$ 使 $\boldsymbol{y}=A\boldsymbol{x}$。而按矩阵乘法的按列展开（先修知识），

$$A\boldsymbol{x}=x_1\boldsymbol{\alpha}_1+x_2\boldsymbol{\alpha}_2+\cdots+x_n\boldsymbol{\alpha}_n,$$

故 $\boldsymbol{y}\in R(A)$ $\Longleftrightarrow$ $\boldsymbol{y}$ 是列向量的线性组合 $\Longleftrightarrow$ $\boldsymbol{y}\in\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$。

:::

$\operatorname{span}$ 本身也是子空间：若 $\boldsymbol u=\sum_i a_i\boldsymbol\alpha_i$、$\boldsymbol v=\sum_i b_i\boldsymbol\alpha_i$，则对任意 $s,t\in F$，

$$s\boldsymbol u+t\boldsymbol v=\sum_i(sa_i+tb_i)\boldsymbol\alpha_i,$$

仍是同一向量组的线性组合。它还是「包含这组向量的最小子空间」：任何包含全部 $\boldsymbol\alpha_i$ 的子空间，因对线性组合封闭，也必然包含它们的整个 $\operatorname{span}$。

:::

### 讨论 $\boldsymbol{y}=A\boldsymbol{x}$：可解性的几何

给定 $\boldsymbol{y}$ 时，方程组 $A\boldsymbol{x}=\boldsymbol{y}$ 有解的**充要条件**为 $\boldsymbol{y}\in R(A)$。理由：有解 $\boldsymbol{x}$ $\Longleftrightarrow$ $\boldsymbol{y}$ 能写成 $A\boldsymbol{x}$ $\Longleftrightarrow$ $\boldsymbol{y}$ 是 $A$ 的列的线性组合 $\Longleftrightarrow$ $\boldsymbol{y}\in R(A)$。**「解方程 = 问右端是否落在列空间里」**——这是本节最重要的观点转变。

::: ex 例 1.2.C · 列观点解方程组 {#ex-1.2.C}

考查方程组 $\begin{cases}x_1+2x_2=6\\ x_1-x_2=0\end{cases}$。设 $A=\begin{pmatrix}1&2\\1&-1\end{pmatrix}$，$\boldsymbol{x}=(x_1,x_2)^{\mathrm T}$，$\boldsymbol{b}=(6,0)^{\mathrm T}$，则方程组即 $A\boldsymbol{x}=\boldsymbol{b}$。把它改写成列的组合：

$$\begin{pmatrix}1\\1\end{pmatrix}x_1+\begin{pmatrix}2\\-1\end{pmatrix}x_2=\begin{pmatrix}6\\0\end{pmatrix},\qquad\text{即}\quad \boldsymbol{a}_1x_1+\boldsymbol{a}_2x_2=\boldsymbol{b}.$$

求解方程组，即是找到系数 $x_1,x_2$，使得向量 $\boldsymbol{a}_1,\boldsymbol{a}_2$ 的线性组合恰好等于向量 $\boldsymbol{b}$。由第二个方程 $x_1=x_2$，代入第一个：$3x_1=6$，故 $x_1=x_2=2$。验证列组合观点：

$$2\begin{pmatrix}1\\1\end{pmatrix}+2\begin{pmatrix}2\\-1\end{pmatrix}=\begin{pmatrix}6\\0\end{pmatrix}=\boldsymbol{b}\in R(A),$$

右端确实落在列空间中，方程组可解且解为 $(2,2)^{\mathrm T}$。同一个方程组有两种读法，差别不在算法，而在「问的是什么」：

| 观点 | 方程组的读法 | 本例 |
|:--|:--|:--|
| **行观点**（逐行消元） | 每行是一个约束：$x_1+2x_2=6$ 与 $x_1-x_2=0$ 是两条直线，解是交点 | 两直线交于 $(2,2)$ |
| **列观点**（本节新语言） | 解是「用列向量组合出右端」的组合系数 | $\boldsymbol{b}=2\boldsymbol{a}_1+2\boldsymbol{a}_2$ |

:::

::: ex 例 1.2.B · 具体求 $N(A)$ 与 $R(A)$ {#ex-1.2.B}

(1) $A=\begin{pmatrix}1&1\\2&2\end{pmatrix}$，求 $N(A)$、$R(A)$；<br> (2) $A=\begin{pmatrix}1&0&1\\0&1&1\\1&1&2\end{pmatrix}$，求 $N(A)$、$R(A)$。

::: sol 解答

**(1)** 本课程默认在 $\mathbb{C}$ 上讨论（[@def-1.2.2] 取 $A\in\mathbb{C}^{m\times n}$），解向量允许取复分量；本小题矩阵是实矩阵，实数解已经够用。$N(A)$：解 $x_1+x_2=0$（两行同解，取一行即可），得 $x_2=t,\ x_1=-t$，

$$N(A)=\{t(-1,1)^{\mathrm T}\mid t\in\mathbb{C}\}=\operatorname{span}\{(-1,1)^{\mathrm T}\}.$$

$R(A)$：两列 $(1,2)^{\mathrm T}$ 与 $(1,2)^{\mathrm T}$ 相同，故 $R(A)=\operatorname{span}\{(1,2)^{\mathrm T}\}\subseteq\mathbb{C}^2$。顺带记下数字：$\dim N(A)=1$，$\dim R(A)=1$，两者之和恰为 $n=2$（这不是巧合，见 [1.3.10](sec13.md#sec-1.3.10) 思考题解答）。

**(2)** $N(A)$：解齐次方程组 $A\boldsymbol{x}=\boldsymbol{0}$。高斯消元（对第 3 行作 $r_3\leftarrow r_3-r_1-r_2$）：

$$\begin{pmatrix}1&0&1\\0&1&1\\1&1&2\end{pmatrix}\xrightarrow{\,r_3-r_1-r_2\,}\begin{pmatrix}1&0&1\\0&1&1\\0&0&0\end{pmatrix},$$

得 $x_1=-x_3,\ x_2=-x_3$，取 $x_3=t$：$N(A)=\operatorname{span}\{(1,1,-1)^{\mathrm T}\}\subseteq\mathbb{C}^3$（$(1,1,-1)^{\mathrm T}$ 是 $(-t,-t,t)$ 的 $-1$ 倍，span 相同）。

$R(A)$：三列 $(1,0,1)^{\mathrm T},(0,1,1)^{\mathrm T},(1,1,2)^{\mathrm T}$，且第三列 = 第一列 + 第二列，前两列不成比例（**「不成比例 ⟹ 线性无关」的严格说法在 [1.3](sec13.md) 节建立；此处先按这个朴素判据使用**），故

$$R(A)=\operatorname{span}\{(1,0,1)^{\mathrm T},\ (0,1,1)^{\mathrm T}\}\subseteq\mathbb{C}^3.$$

再次记录：$\dim N(A)=1$，$\dim R(A)=2$，和为 $n=3$。

:::

:::

::: ex 例 1.2.D · $\mathbb{R}^3$ 中的几何子空间 {#ex-1.2.D}

(1) 证明过原点的平面 $W=\{\boldsymbol{x}\in\mathbb{R}^3\mid n_1x_1+n_2x_2+n_3x_3=0\}$（$\boldsymbol{n}=(n_1,n_2,n_3)^{\mathrm T}\neq\boldsymbol{0}$）是 $\mathbb{R}^3$ 的子空间，并写成 $N(\cdot)$ 与 $\operatorname{span}(\cdot)$ 两种形式；<br> (2) 不过原点的平面 $W''=\{\boldsymbol{x}\mid x_3=1\}$ 是子空间吗？

::: sol 解答

**(1)** 记 $\boldsymbol{n}=(n_1,n_2,n_3)^{\mathrm T}\neq\boldsymbol{0}$，则 $W=\{\boldsymbol{x}\mid \boldsymbol{n}^{\mathrm T}\boldsymbol{x}=0\}=N(\boldsymbol{n}^{\mathrm T})$——它是「$1\times3$ 矩阵」$\boldsymbol{n}^{\mathrm T}$ 的零空间，由[@ex-1.2.1] 立得是子空间。

**给出一组可直接使用的基。** 若 $(n_1,n_2)\neq(0,0)$，取

$$\boldsymbol{u}=(-n_2,n_1,0)^{\mathrm T},\qquad \boldsymbol{v}=(-n_1n_3,-n_2n_3,n_1^2+n_2^2)^{\mathrm T};$$

这两个向量不是猜出来的：$\boldsymbol u$ 是「在 $xOy$ 平面内、与 $\boldsymbol n$ 的水平分量 $(n_1,n_2)$ 垂直」的方向（故第三分量为 $0$），$\boldsymbol v$ 用来补足第三个方向。直接计算得 $\boldsymbol n^{\mathrm T}\boldsymbol u=\boldsymbol n^{\mathrm T}\boldsymbol v=0$，故 $\operatorname{span}\{\boldsymbol u,\boldsymbol v\}\subseteq W$。

**反向包含（分三步，逐步收紧）。** 任取 $\boldsymbol{x}\in W$：

1. **消掉第三分量**：令 $t=\dfrac{x_3}{n_1^2+n_2^2}$，则 $\boldsymbol{w}=\boldsymbol{x}-t\boldsymbol{v}$ 的第三分量为 $0$；
2. **把 $\boldsymbol w$ 归入 $\boldsymbol u$ 的方向**：因 $W$ 是子空间且 $\boldsymbol v\in W$，故 $\boldsymbol w\in W$，于是 $n_1w_1+n_2w_2=0$。若 $n_2\neq0$，取 $s=-w_1/n_2$，则 $w_1=-n_2s$，代入方程得 $w_2=n_1s$，即 $\boldsymbol{w}=s\boldsymbol{u}$（若 $n_2=0$，则 $n_1\neq0$，同理可解出 $\boldsymbol{w}=s\boldsymbol{u}$）；
3. **收口**：于是 $\boldsymbol{x}=s\boldsymbol{u}+t\boldsymbol{v}\in\operatorname{span}\{\boldsymbol u,\boldsymbol v\}$。

两个包含合起来即 $W=\operatorname{span}\{\boldsymbol u,\boldsymbol v\}$，且 $\boldsymbol u,\boldsymbol v$ 不成比例（第三分量一为 $0$、一为 $n_1^2+n_2^2\neq0$），这确是 $W$ 的一组基。

**退化情形。** 若 $n_1=n_2=0$（此时 $n_3\neq0$），则 $W=\operatorname{span}\{(1,0,0)^{\mathrm T},(0,1,0)^{\mathrm T}\}$，即 $xOy$ 平面。

**(2)** 不是。$\boldsymbol{\theta}$ 的第三分量是 $0\neq1$，零向量不在 $W''$ 中；从平移的角度看也一样：过原点的平面是子空间，整体平移离开原点之后就不再是。

:::

:::

<a id="sec-1.2.8"></a>

## 1.2.8 小结与常见错误

**小结。**① 基本概念：线性子空间、和空间与交空间、矩阵零空间与列空间；② 重要定理：子空间判定定理。把这份清单串起来看，它其实是一条线：判定定理把「是不是子空间」压成一次线性组合检验；交与和回答「两个子空间能拼出什么」；零空间与列空间则把整套语言接到线性方程组上——[1.3](sec13.md) 讨论维数时，主角正是这两个空间。

::: errata 常见错误清单（1.2 节）

E-g **把「子集」当「子空间」判定的默认前提。**$\mathbb{R}^2$ 不是 $\mathbb{R}^3$ 的子空间，因为根本不是子集（[@ex-1.2.3]）。

E-h **忘记检查零向量。**「非空」不等于「含零元」；$W'$（$\alpha_3\neq0$）、非齐次解集、不过原点的平面都倒在这里。

E-i **把并当和。**需要「子空间意义下的并」时，正确对象是 $W_1+W_2$（[@thm-1.2.2]）。

E-j **混淆 $N(A)$ 与 $R(A)$ 的所在空间。**$N(A)\subseteq\mathbb{C}^n$（输入侧），$R(A)\subseteq\mathbb{C}^m$（输出侧）。

E-k **判定时用具体元素代替任意元素。**「$(1,2)\in W$ 且 $(2,4)\in W$，相加还在」不能代替对任意 $\boldsymbol{\alpha},\boldsymbol{\beta}$ 的论证。

:::

::: method 即时自测 · 1.2

先自行作答，再展开核对。

::: hint 第 1 题 · 记忆

子空间判定定理的三个等价命题是什么？条件 (2)a 中「$\forall k\in F$」为什么不能省？（对应 [1.2.2](sec12.md#sec-1.2.2)）
:::

::: sol 第 1 题答案

(1) $W$ 是子空间；(2)a. $\forall k\in F,\boldsymbol{\alpha}\in W$ 有 $k\boldsymbol{\alpha}\in W$，b. 对加法封闭；(3) $\forall k,l\in F$ 及 $\boldsymbol{\alpha},\boldsymbol{\beta}\in W$ 有 $k\boldsymbol{\alpha}+l\boldsymbol{\beta}\in W$。

**「$k=0$」是关键：**取 $k=0$ 得 $0\boldsymbol{\alpha}=\boldsymbol{\theta}\in W$，零元素是由条件 (2)a **顺便得出**的，所以不必单独验证。这正是 [@thm-1.2.1] 旁边「这在干啥？」批注的答案。
:::

::: hint 第 2 题 · 辨析

下列集合哪些是 $\mathbb{R}^{n\times n}$ 的子空间？哪些不是？各给一条最短理由。(a) 对称矩阵全体；(b) 可逆矩阵全体；(c) 迹为零的矩阵全体；（d）秩恰为 1 的矩阵全体。（对应 [1.2.3](sec12.md#sec-1.2.3)）
:::

::: sol 第 2 题答案

**(a) 是；(b) 不是；(c) 是；(d) 不是。**

- (b) 最快的否决：$0\cdot A=O$ 不可逆，数乘不封闭（也不含零矩阵）。
- (d) 加法不封闭：$E_{11}+E_{22}=I$ 秩为 2。

**归纳出的模式。**由「线性方程 / 等式」刻画的集合通常是子空间（$Ax=0$、$A^{\mathrm T}=A$、$\operatorname{tr}A=0$ 都属此类）；由「不等式 / 排除性条件」刻画的（可逆、秩恰为某值、不含零元）通常不是。
:::

::: hint 第 3 题 · 应用

$A=\begin{pmatrix}1&2&3\\ 2&4&6\end{pmatrix}$。$N(A)$ 与 $R(A)$ 各是 $\mathbb{C}^n$ 里几维的子空间？两者维数之和是多少？（对应 [1.2.7](sec12.md#sec-1.2.7)）
:::

::: sol 第 3 题答案

$\operatorname{rank}A=1$（两行成比例）。故 $\dim N(A)=3-1=2$（住 $\mathbb{C}^3$，输入侧），$\dim R(A)=1$（住 $\mathbb{C}^2$，输出侧）。**和为 3**，恰为 $A$ 的列数 $n$——这正是 [1.3.10](sec13.md#sec-1.3.10) 思考 3、4 合起来的恒等式。

$N(A)$ 与 $R(A)$ 所在的空间连维数都不同（$n$ 与 $m$），把它们当成同一空间的子空间是常见错误（E-j）。
:::

::: hint 第 4 题 · 迁移

「$A\boldsymbol{x}=\boldsymbol{b}$ 有解」用列空间的语言怎么说？为什么非齐次方程组的解集**不是**子空间？（对应 [1.2.7](sec12.md#sec-1.2.7)、习题 A8）
:::

::: sol 第 4 题答案

**有解 $\Longleftrightarrow$ $\boldsymbol{b}\in R(A)$**：「解方程」就是问右端能否用 $A$ 的列组合出来。

解集不是子空间的最快理由：**零向量不在解集中**（否则 $A\boldsymbol{\theta}=\boldsymbol{b}\neq\boldsymbol{\theta}$）。也可看加法：两个解之和代入得 $2\boldsymbol{b}\neq\boldsymbol{b}$。

**对照记忆。**齐次（右端为 0）⟹ 解集是子空间；非齐次 ⟹ 一定不是。这条规律在差分方程（[@ex-1.2.4]）上同样成立。
:::

:::
