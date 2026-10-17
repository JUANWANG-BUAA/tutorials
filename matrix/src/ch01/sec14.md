# 1.4 内积空间

线性空间只规定了向量怎样相加、怎样数乘，却没有说明向量之间如何比较长度和方向。缺的这一步由内积补上：它把一对向量变成一个标量，让几何信息在任意线性空间里也能计算。本节先固定「第一变元线性」的约定，再从标准内积推广到正定 Hermite 矩阵诱导的内积，最后说明内积在一组基下如何由 Gram 矩阵记录，以及换基时为什么出现矩阵合同。

::: preview 先抓住一件事

内积不是随便一个「像点积」的公式，它必须满足四条公理。**Hermite 性保证交换两个输入时结果自洽**，**正定性保证非零向量不会被量成零长度**；Gram 矩阵则是内积在某组基下的记录。
:::

<a id="sec-1.4.1"></a>

## 1.4.1 内积的四条公理

要把「比较长度与方向」搬进任意线性空间，先得回答一个更基本的问题：一套合格的测量规则必须满足什么？三维空间的点积是现成的范例，只是它有坐标公式撑腰，看不出哪几条性质才是真正必需的。把点积满足的性质逐条抽出来、作为公理，内积就能定义在任何线性空间上。

::: def 定义 1.4.1 · 内积空间 inner product space {#def-1.4.1}

设 $F=\mathbb R$ 或 $\mathbb C$，$V$ 是 $F$ 上的线性空间。若对任意 $\boldsymbol{x},\boldsymbol{y}\in V$，都有一个标量 $(\boldsymbol{x},\boldsymbol{y})\in F$，并且对任意 $\boldsymbol{x},\boldsymbol{y},\boldsymbol{z}\in V$ 和 $k\in F$ 满足：

（1）**共轭对称性**：$(\boldsymbol{x},\boldsymbol{y})=\overline{(\boldsymbol{y},\boldsymbol{x})}$；<br> （2）**第一变元可加性**：$(\boldsymbol{x}+\boldsymbol{y},\boldsymbol{z})=(\boldsymbol{x},\boldsymbol{z})+(\boldsymbol{y},\boldsymbol{z})$；<br> （3）**第一变元齐次性**：$(k\boldsymbol{x},\boldsymbol{y})=k(\boldsymbol{x},\boldsymbol{y})$；<br> （4）**正定性**：$(\boldsymbol{x},\boldsymbol{x})\geq0$，且 $(\boldsymbol{x},\boldsymbol{x})=0\Longleftrightarrow\boldsymbol{x}=\boldsymbol{\theta}$。

此时称 $V$ 为**内积空间**，$(\boldsymbol{x},\boldsymbol{y})$ 称为 $\boldsymbol{x}$ 与 $\boldsymbol{y}$ 的**内积**。有限维实内积空间称为欧几里得空间，有限维复内积空间称为酉空间。

:::

::: note

**约定。**内积对**第一变元线性**，对第二变元共轭线性。有些教材采用相反约定，两种都自洽，但不能在同一套推导中混用。实数情形下共轭不起作用，内积对两个变元都线性。

:::

::: note

**术语说明。**「欧几里得空间」（有限维实内积空间）是平面与立体解析几何的公理化推广，长度 $\sqrt{(\boldsymbol{x},\boldsymbol{x})}$、夹角公式与几何直觉完全一致。「**酉空间**」是有限维复内积空间的别名；**酉**是 unitary 的音译用字（音同「有」）。后续将遇到的**酉矩阵**指满足 $P^{\mathrm H}P=I$（等价于 $P^{-1}=P^{\mathrm H}$）的复方阵——实情形下就是正交矩阵；**酉变换**则指保持复内积不变的线性变换。名字陌生，但它们扮演的角色与实空间中的「正交」相当。

:::

四条公理只逐条规定了**第一变元**的行为；第二变元做什么，得由共轭对称性推出来。例 1.4.1 把这份「推出来的行为」整理成公式。

::: ex 例 1.4.1 · 第二变元的运算律与零向量 {#ex-1.4.1}

由内积四条公理证明：对任意 $\boldsymbol{x},\boldsymbol{y},\boldsymbol{z}\in V$ 与 $k\in F$，有

$$\begin{aligned}
(\boldsymbol{x},\boldsymbol{y}+\boldsymbol{z})&=(\boldsymbol{x},\boldsymbol{y})+(\boldsymbol{x},\boldsymbol{z}),\\
(\boldsymbol{x},k\boldsymbol{y})&=\overline{k}(\boldsymbol{x},\boldsymbol{y}),\\
(\boldsymbol{\theta},\boldsymbol{y})&=(\boldsymbol{x},\boldsymbol{\theta})=0.
\end{aligned}$$

::: sol 推导

第二变元可加性来自「交换变元，在第一变元中拆开，再交换回来」：

$$\begin{aligned}
(\boldsymbol{x},\boldsymbol{y}+\boldsymbol{z})
&=\overline{(\boldsymbol{y}+\boldsymbol{z},\boldsymbol{x})}
=\overline{(\boldsymbol{y},\boldsymbol{x})+(\boldsymbol{z},\boldsymbol{x})}\\
&=(\boldsymbol{x},\boldsymbol{y})+(\boldsymbol{x},\boldsymbol{z}).
\end{aligned}$$

同理，

$$ (\boldsymbol{x},k\boldsymbol{y})=\overline{(k\boldsymbol{y},\boldsymbol{x})}=\overline{k(\boldsymbol{y},\boldsymbol{x})}=\overline{k}(\boldsymbol{x},\boldsymbol{y}). $$

最后，$(\boldsymbol{\theta},\boldsymbol{y})=(0\boldsymbol{x},\boldsymbol{y})=0(\boldsymbol{x},\boldsymbol{y})=0$；共轭对称性再给出 $(\boldsymbol{x},\boldsymbol{\theta})=0$。这也回答了原课件页 3 的思考题。

:::

:::

<figure aria-labelledby="fig-inner-caption" class="concept-figure" data-figure="FIG. 1–07">
<svg aria-labelledby="fig-inner-title fig-inner-desc" role="img" viewBox="0 0 680 250">
<title id="fig-inner-title">内积为线性空间增加几何信息</title>
<desc id="fig-inner-desc">向量加法与数乘构成线性结构，内积把两个向量映到一个标量，从而支持长度、夹角和正交的后续定义。</desc>
<defs><marker id="inner-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<rect class="diagram-node" height="118" rx="12" width="176" x="34" y="58"></rect>
<text class="diagram-mono" x="57" y="87">LINEAR SPACE</text><text class="diagram-text" x="57" y="116">线性结构</text>
<text class="diagram-note" x="57" y="145">加法 · 数乘 · 线性组合</text>
<line class="diagram-accent" marker-end="url(#inner-arrow)" x1="228" x2="440" y1="117" y2="117"></line>
<text class="diagram-mono" x="273" y="99">(·,·) : V × V → F</text>
<text class="diagram-note" x="270" y="146">两个向量 → 一个标量</text>
<rect class="diagram-node" height="118" rx="12" width="188" x="458" y="58"></rect>
<text class="diagram-mono" x="481" y="87">GEOMETRY</text><text class="diagram-text" x="481" y="116">几何结构</text>
<text class="diagram-note" x="481" y="145">长度 · 夹角 · 正交</text>
<text class="diagram-note" x="167" y="218">本节完成中间这一步；范数与正交化将在后续课次展开</text>
</svg>
<figcaption id="fig-inner-caption">内积不替换原有的线性结构，而是在其上叠加一层可计算的几何信息。</figcaption>
</figure>

<a id="sec-1.4.2"></a>

## 1.4.2 实与复向量空间的标准内积

公理只说了「满足什么才配叫内积」，还没说明数组空间里它长什么样。先从最熟悉的 $\mathbb R^n$ 开始，再走到 $\mathbb C^n$：复数情形不能照抄实数公式，这条边界必须现在就分清。

::: ex 例 1.4.2 · $\mathbb R^n$ 的标准内积 {#ex-1.4.2}

对 $\boldsymbol{x}=(x_1,\ldots,x_n)^{\mathrm T}$、$\boldsymbol{y}=(y_1,\ldots,y_n)^{\mathrm T}\in\mathbb R^n$，令

$$ (\boldsymbol{x},\boldsymbol{y})=\boldsymbol{y}^{\mathrm T}\boldsymbol{x}=\sum_{i=1}^{n}x_i y_i. $$

验证它是 $\mathbb R^n$ 上的内积。

::: sol 解答

对称性来自标量乘法可交换，可加性与齐次性来自矩阵乘法的分配律；而

$$ (\boldsymbol{x},\boldsymbol{x})=x_1^2+\cdots+x_n^2\geq0,\qquad (\boldsymbol{x},\boldsymbol{x})=0\Longleftrightarrow x_1=\cdots=x_n=0, $$

因此它确实是内积。

:::

:::

实数情形到此结束。把同一个公式原样搬进 $\mathbb C^n$，正定性会第一个出问题。

::: ex 例 1.4.3 · 在 $\mathbb C^n$ 中不能只用转置 {#ex-1.4.3}

在 $\mathbb C^n$ 上照搬实数公式 $(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{y}^{\mathrm T}\boldsymbol{x}$，还能是内积吗？若不能，正确的定义是什么？

::: sol 解答

不能。在 $\mathbb C^1$ 中取 $\boldsymbol{x}=i$，便有 $(i,i)=i^2=-1$，违反正定性。故复向量空间必须使用**共轭转置**：

$$ (\boldsymbol{x},\boldsymbol{y})=\boldsymbol{y}^{\mathrm H}\boldsymbol{x}=\sum_{i=1}^{n}x_i\overline{y_i}. $$

此时 $(\boldsymbol{x},\boldsymbol{x})=\sum_i|x_i|^2\geq0$，且只有零向量取到零。

:::

:::

换成共轭转置后，计算要多想一步「谁取共轭」。用一组具体数字走一遍：

::: ex 例 1.4.A · 复内积的共轭对称自检 {#ex-1.4.A}

取 $\boldsymbol{x}=(1,i)^{\mathrm T}$，$\boldsymbol{y}=(1-i,2)^{\mathrm T}$。计算 $(\boldsymbol{x},\boldsymbol{y})$ 与 $(\boldsymbol{y},\boldsymbol{x})$，并验证 $(\boldsymbol{y},\boldsymbol{x})=\overline{(\boldsymbol{x},\boldsymbol{y})}$。

::: sol 解答

$$ (\boldsymbol{x},\boldsymbol{y})=\boldsymbol{y}^{\mathrm H}\boldsymbol{x}=(1+i)\cdot1+2i=1+3i, $$
$$ (\boldsymbol{y},\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}\boldsymbol{y}=1\cdot(1-i)-i\cdot2=1-3i=\overline{(\boldsymbol{x},\boldsymbol{y})}. $$

检查复内积时，「交换两个向量以后取共轭」是最直接的数值自检。

:::

:::

<a id="sec-1.4.3"></a>

## 1.4.3 矩阵诱导的内积

两个标准公式 $\boldsymbol y^{\mathrm T}\boldsymbol x$ 与 $\boldsymbol y^{\mathrm H}\boldsymbol x$ 形状相同，差别只在转置与共轭转置。既然中间可以插一个转置，就可以插一个矩阵：把 $A$ 塞进 $\boldsymbol y^{\mathrm H}A\boldsymbol x$，还算不算内积？

::: ex 例 1.4.4 · $(\boldsymbol{x},\boldsymbol{y})_A=\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 何时是内积 {#ex-1.4.4}

对 $A\in\mathbb C^{n\times n}$，证明：表达式

$$ (\boldsymbol{x},\boldsymbol{y})_A=\boldsymbol{y}^{\mathrm H}A\boldsymbol{x} $$

定义 $\mathbb C^n$ 上的内积的充要条件是 $A$ 为**正定 Hermite 矩阵**，即

$$ A=A^{\mathrm H},\qquad \boldsymbol{x}^{\mathrm H}A\boldsymbol{x}\gt0\quad(\boldsymbol{x}\neq\boldsymbol{0}). $$

::: sol 必要性

可加性和第一变元齐次性对任意 $A$ 都成立。共轭对称性要求

$$\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}
=\overline{\boldsymbol{x}^{\mathrm H}A\boldsymbol{y}}
=\boldsymbol{y}^{\mathrm H}A^{\mathrm H}\boldsymbol{x}\qquad(\forall\boldsymbol{x},\boldsymbol{y}).$$

因此 $\boldsymbol{y}^{\mathrm H}(A-A^{\mathrm H})\boldsymbol{x}=0$ 对任意 $\boldsymbol{x},\boldsymbol{y}$ 成立。依次取 $\boldsymbol{y}=\boldsymbol{e}_i$、$\boldsymbol{x}=\boldsymbol{e}_j$，得 $A-A^{\mathrm H}$ 的每个元素都为零，故 $A=A^{\mathrm H}$。正定公理又直接要求 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}\gt0$ 对每个非零 $\boldsymbol{x}$ 成立。

:::

::: sol 充分性

反过来，若 $A=A^{\mathrm H}$ 且 $A$ 正定，上述计算倒过来即得共轭对称性，矩阵乘法给出可加性与齐次性，正定性由假设保证，四条公理全部成立。

:::

:::

::: method 判定流程

面对 $\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 型表达式，先查 $A=A^{\mathrm H}$，再查 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$ 对非零向量是否恒正；可加性与齐次性由矩阵乘法自动继承。

:::

换一个正定的 $A$，等于换一把尺子。下面的例子把「换尺子」的后果算给你看。

::: ex 例 1.4.E · 换一个内积，长度和垂直都会改变 {#ex-1.4.E}

在 $\mathbb R^2$ 上取

$$A=\begin{pmatrix}4&0\\0&1\end{pmatrix},\qquad (\boldsymbol x,\boldsymbol y)_A=\boldsymbol y^{\mathrm T}A\boldsymbol x.$$

(1) 比较 $\boldsymbol x=(1,1)^{\mathrm T}$ 的标准长度与 $A$-长度；(2) 判断 $\boldsymbol x=(1,1)^{\mathrm T}$、$\boldsymbol y=(1,-1)^{\mathrm T}$ 在两种内积下是否正交；(3) 写出 $A$-单位圆。

::: sol 解答

**长度。**标准长度为 $\sqrt{1^2+1^2}=\sqrt2$；而

$$\|\boldsymbol x\|_A=\sqrt{\boldsymbol x^{\mathrm T}A\boldsymbol x}=\sqrt{4+1}=\sqrt5.$$

**正交。**标准内积给出 $\boldsymbol x^{\mathrm T}\boldsymbol y=1-1=0$，所以二者在通常几何中正交；但

$$ (\boldsymbol x,\boldsymbol y)_A=\boldsymbol y^{\mathrm T}A\boldsymbol x=(1,-1)\begin{pmatrix}4\\1\end{pmatrix}=3\ne0, $$

所以它们在 $A$-内积下不正交。

**单位圆。**$\|\boldsymbol z\|_A=1$ 等价于 $4z_1^2+z_2^2=1$，在普通坐标纸上看是一条椭圆。内积没有改变向量加法，却改变了测量长度与夹角的「尺子」。

:::

<figure aria-labelledby="fig-metric-shape-caption" class="concept-figure">
<svg aria-labelledby="fig-metric-shape-title fig-metric-shape-desc" role="img" viewBox="0 0 680 260">
<title id="fig-metric-shape-title">标准内积和加权内积的单位圆</title>
<desc id="fig-metric-shape-desc">标准内积的单位长度点组成圆，加权内积的单位长度点在普通坐标中组成椭圆。</desc>
<rect class="diagram-node" height="216" rx="12" width="300" x="20" y="22"></rect>
<text class="diagram-mono" x="42" y="48">STANDARD METRIC · I</text>
<line stroke="var(--fig-neutral)" x1="62" x2="278" y1="142" y2="142"></line>
<line stroke="var(--fig-neutral)" x1="170" x2="170" y1="232" y2="62"></line>
<circle cx="170" cy="142" fill="var(--fig-blue)" fill-opacity="0.10" r="70" stroke="var(--fig-blue)" stroke-width="2.5"></circle>
<text class="diagram-text" text-anchor="middle" x="170" y="222">z₁²+z₂²=1</text>
<rect class="diagram-node" height="216" rx="12" width="300" x="360" y="22"></rect>
<text class="diagram-mono" x="382" y="48">WEIGHTED METRIC · diag(4,1)</text>
<line stroke="var(--fig-neutral)" x1="402" x2="618" y1="142" y2="142"></line>
<line stroke="var(--fig-neutral)" x1="510" x2="510" y1="232" y2="62"></line>
<ellipse cx="510" cy="142" fill="var(--fig-red)" fill-opacity="0.10" rx="35" ry="70" stroke="var(--fig-red)" stroke-width="2.5"></ellipse>
<text class="diagram-text" text-anchor="middle" x="510" y="222">4z₁²+z₂²=1</text>
</svg>
<figcaption id="fig-metric-shape-caption"><b>「单位圆」把内积画了出来。</b>若某个方向权重更大，同样的坐标位移会被量得更长，于是单位集合在那个方向收缩。</figcaption>
</figure>

:::

<a id="sec-1.4.4"></a>

## 1.4.4 Hermite 矩阵与正定矩阵

例 1.4.4 把「$\boldsymbol y^{\mathrm H}A\boldsymbol x$ 什么时候是内积」压缩成了两个条件：$A=A^{\mathrm H}$ 与 $A$ 正定。这两个条件本身就是本节后半段的主角，值得各自定义清楚。先看第一个。

::: def 定义 1.4.2 · Hermite 矩阵 {#def-1.4.2}

设 $A\in\mathbb C^{n\times n}$。若 $A^{\mathrm H}=A$，称 $A$ 为 **Hermite 矩阵**（也常称 Hermitian 矩阵或埃尔米特矩阵）；若 $A^{\mathrm H}=-A$，称 $A$ 为**反 Hermite 矩阵**。

:::

定义只有一行，检验也只有一步：转置之后再逐元素取共轭。先做一遍完整的计算，再看一个「对角元不是实数」的矩阵如何违反内积公理 (1)。

::: ex 例 1.4.5 · 共轭转置的逐步检查（含一个反例）{#ex-1.4.5}

对

$$ A=\begin{pmatrix}1&i\\-i&2\end{pmatrix}, $$

求 $A^{\mathrm H}$，并判断 $A$ 是否为 Hermite 矩阵。

::: sol 解答

先转置再逐元素共轭：

$$ A^{\mathrm H}=\overline{A^{\mathrm T}}
=\overline{\begin{pmatrix}1&-i\\i&2\end{pmatrix}}
=\begin{pmatrix}1&i\\-i&2\end{pmatrix}=A. $$

共轭转置把 $A$ 原样送回，所以 $A$ 是 Hermite 矩阵。

**(2) 反例：对角元不是实数的矩阵。** 取 $B=\begin{pmatrix}i&0\\0&i\end{pmatrix}$，则 $B^{\mathrm H}=\overline{B^{\mathrm T}}=\begin{pmatrix}-i&0\\0&-i\end{pmatrix}\neq B$，$B$ 不是 Hermite 矩阵。后果是具体的：对 $\boldsymbol{x}=(1,0)^{\mathrm T}\neq\boldsymbol{0}$，

$$\boldsymbol{x}^{\mathrm H}B\boldsymbol{x}=i\,|1|^2=i\notin\mathbb R .$$

**「非零向量算出的值竟然不是实数」**——这直接违反内积公理 (1)（共轭对称要求 $(\boldsymbol{x},\boldsymbol{x})$ 等于自己的共轭，从而必为实数）。这就是为什么复内积**必须**要求共轭对称、而不能只要求对称：只要求对称的话，$B$ 这样的矩阵也会混进来。

:::

:::

::: note

实数的共轭是它自己，于是「实矩阵是 Hermite 的」等价于「实矩阵是对称的」，实反对称矩阵则是反 Hermite 矩阵的特例——**Hermite 矩阵就是「对称」在复数域上的正确推广**。本科线性代数大多只在实数域上工作，所以这可能是你第一次真正需要复矩阵语言。两个立即可验的外观特征：Hermite 矩阵的对角元必为实数（$a_{ii}=\overline{a_{ii}}$），反 Hermite 矩阵的对角元必为零或纯虚数（$a_{ii}=-\overline{a_{ii}}$ 迫使实部为零）；例 1.4.5 中的 $A$ 正是前一种的样子。

:::

「正定」要靠不等式 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}\gt0$ 来表述，而「大于零」只对实数才有意义。那么 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$ 什么时候是实数？先把定义写下来，紧接着的命题 1.4.1 回答这个问题。

::: def 定义 1.4.3 · 正定与半正定矩阵 {#def-1.4.3}

设 $A=A^{\mathrm H}$，复二次型 $f(\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$。若对所有非零 $\boldsymbol{x}\in\mathbb C^n$ 有 $f(\boldsymbol{x})\gt0$，称 $f$ 为正定二次型，$A$ 为**正定矩阵**。若只要求 $f(\boldsymbol{x})\geq0$，则称 $A$ 为**半正定矩阵**。负定、半负定的定义类似。

:::

::: thm 命题 1.4.1 · $A$ 为 Hermite 矩阵时，$\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$ 必为实数 {#prop-1.4.1}

设 $A=A^{\mathrm H}$，则对一切 $\boldsymbol{x}\in\mathbb C^n$，复二次型 $f(\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$ 取实数值。

::: proof 证

$f(\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$ 是 $1\times1$ 矩阵（一个数），它的共轭转置就是它的复共轭。利用 $(BC)^{\mathrm H}=C^{\mathrm H}B^{\mathrm H}$ 与 $\left(B^{\mathrm H}\right)^{\mathrm H}=B$（转置的相应性质对共轭转置同样成立）：

$$\overline{f(\boldsymbol{x})}=\big(\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}\big)^{\mathrm H}=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}=f(\boldsymbol{x}),$$

一个复数等于自身的共轭，当且仅当它是实数。

:::

:::

::: note

定义 1.4.3 用到 $f(\boldsymbol{x})\gt0$ 与 $f(\boldsymbol{x})\geq0$，而「大于零」只对实数才有意义。[@prop-1.4.1] 说明：只要 $A$ 是 Hermite 矩阵，$f$ 自动取实值，「正定、半正定」的比较才有资格进行。这也解释了定义为何**只对 Hermite 矩阵**给出：若 $A\neq A^{\mathrm H}$（例如纯虚对角元情形），$f$ 一般取复值，根本谈不上正负。

:::

对具体的 $2\times2$ 矩阵，判断正定最快的办法往往是配方。下面两个矩阵只差一个元素，结论却从正定掉到半正定。

::: ex 例 1.4.6 · 用完全平方区分正定与半正定 {#ex-1.4.6}

用配方法判断 $A_1=\begin{pmatrix}1&i\\-i&2\end{pmatrix}$ 是否正定；再把右下角的 $2$ 改成 $1$（记作 $A_2$），结论有何不同？

::: sol 解答

令 $\boldsymbol{x}=(x_1,x_2)^{\mathrm T}$，对 $A_1$ 直接展开并配方：

$$\begin{aligned}
\boldsymbol{x}^{\mathrm H}A_1\boldsymbol{x}
&=|x_1|^2+i\overline{x_1}x_2-i\overline{x_2}x_1+2|x_2|^2\\
&=|x_1+i x_2|^2+|x_2|^2.
\end{aligned}$$

两项同时为零强制 $x_2=0$、$x_1=0$，故 $A_1$ 正定。若把右下角的 $2$ 改成 $1$，得

$$ A_2=\begin{pmatrix}1&i\\-i&1\end{pmatrix},\qquad
\boldsymbol{x}^{\mathrm H}A_2\boldsymbol{x}=|x_1+i x_2|^2\geq0. $$

但取 $x_1=-i x_2\neq0$ 便取到零，因而 $A_2$ 只是半正定。**区别不在「能不能小于零」，而在「非零向量能不能取到零」。**

:::

:::

<a id="sec-1.4.5"></a>

## 1.4.5 同一空间上的内积例库

一个线性空间上并非只有一种内积可选。课件的注 3 强调：**同一个线性空间可以定义不同的内积**——在 $\mathbb C^n$ 上，标准内积对应 $A=I$，任意正定 Hermite 矩阵 $A$ 又给出一个新内积 $\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$。

**先给一个统一视角。**本节出现的所有内积，最终都能写成 $\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 的形状——只要把「向量」翻译成坐标列、把「两两内积」翻译成一个矩阵。下表每一行都是它的一个化身：

| 例子 | 向量是什么 | 统一形式 $\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 中的 $A$ |
|:--|:--|:--|
| $\mathbb C^n$ 标准内积 | 列向量 | $A=I$ |
| $\mathbb C^n$ 加权内积 | 列向量 | $A$ 正定 Hermite |
| 多项式积分内积 | 多项式 | $A$ 是基下的 Gram 矩阵（[1.4.6](sec14.md#sec-1.4.6)） |
| 矩阵 Frobenius 内积 | 矩阵 | $A=I$（先把矩阵**拉直**成列向量） |

记住这张表：除去第一行的标准内积，其余三行——加权内积、多项式积分内积、矩阵 Frobenius 内积——就不再是三条孤立的规定，而是同一个机制在不同对象上的表现。

::: ex 例 1.4.B · 多项式空间的积分内积 {#ex-1.4.B}

在实多项式空间 $P_2(t)$ 上定义

$$ (p,q)=\int_0^1 p(t)q(t)\,\mathrm dt. $$

验证它是内积，并计算 $(1+t,t)$。

::: sol 解答

对称、可加和齐次性由积分的线性性质给出。又因 $p(t)^2\geq0$，$(p,p)=\int_0^1p(t)^2\,\mathrm dt\geq0$；若积分为零，连续函数 $p(t)^2$ 必在 $[0,1]$ 上恒为零，所以 $p$ 是零多项式。因此该定义是内积。

例如 $(1+t,t)=\int_0^1(t+t^2)\,\mathrm dt=\tfrac12+\tfrac13=\tfrac56$。

:::

:::

::: ex 例 1.4.C · 矩阵空间的 Frobenius 内积 {#ex-1.4.C}

在 $\mathbb C^{m\times n}$ 上定义

$$ (X,Y)=\operatorname{tr}(Y^{\mathrm H}X)=\sum_{i=1}^{m}\sum_{j=1}^{n}x_{ij}\overline{y_{ij}}. $$

验证它是内积。

::: sol 解答

这就是把矩阵的 $mn$ 个元素排成向量后使用标准内积：共轭对称、可加与齐次性来自转置、迹与矩阵乘法的运算律；特别地，$(X,X)=\sum_{i,j}|x_{ij}|^2\geq0$，且和为零迫使每个 $x_{ij}=0$，因此满足正定性。由它诱导的矩阵「长度」$\|X\|_F=\sqrt{(X,X)}$ 称为 **Frobenius 范数**——向量欧氏长度的直接推广，后续章节衡量矩阵「整体大小」时反复使用。

:::

:::

<a id="sec-1.4.6"></a>

## 1.4.6 度量矩阵与坐标公式

上一小节的统一形式只在 $\mathbb C^n$ 里现成可用；换成一般的线性空间 $V$，向量本身不是数组，坐标得先靠一组基翻译出来。而要真的算出 $(\boldsymbol{x},\boldsymbol{y})$，只需知道基向量两两的内积——把这些数排成方阵，就是内积在给定基下的完整记录。

设 $\boldsymbol{\varepsilon}_1,\ldots,\boldsymbol{\varepsilon}_n$ 是内积空间 $V$ 的一组基，$\boldsymbol{x}$、$\boldsymbol{y}$ 在该基下的坐标分别为 $\boldsymbol{\xi}=(\xi_1,\ldots,\xi_n)^{\mathrm T}$、$\boldsymbol{\eta}=(\eta_1,\ldots,\eta_n)^{\mathrm T}$，即

$$\boldsymbol{x}=\sum_{j=1}^{n}\xi_j\boldsymbol{\varepsilon}_j,\qquad \boldsymbol{y}=\sum_{i=1}^{n}\eta_i\boldsymbol{\varepsilon}_i .$$

推导只有一步实质操作：把两个向量按基展开后代入，先用**第一变元线性**把 $\boldsymbol x$ 拆开，再用**第二变元共轭线性**把 $\boldsymbol y$ 拆开（系数出共轭）：

$$(\boldsymbol{x},\boldsymbol{y})=\Big(\sum_j\xi_j\boldsymbol{\varepsilon}_j,\ \sum_i\eta_i\boldsymbol{\varepsilon}_i\Big)=\sum_{j=1}^{n}\xi_j\sum_{i=1}^{n}\overline{\eta_i}\,(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)=\sum_{i,j}\overline{\eta_i}\,(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)\,\xi_j .$$

展开后的双重和恰好是「行向量 $\boldsymbol{\eta}^{\mathrm H}$ × 某个矩阵 × 列向量 $\boldsymbol{\xi}$」的形状——矩阵乘法 $\boldsymbol{\eta}^{\mathrm H}G\boldsymbol{\xi}$ 把 $\overline{\eta_i}$ 配给**行**、$\xi_j$ 配给**列**，所以第 $(i,j)$ 元必须放 $(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$。把这件事正式记下来，就得到度量矩阵：

::: def 定义 1.4.4 · 度量矩阵 metric matrix / Gram matrix {#def-1.4.4}

在本教程「第一变元线性」约定下，定义基 $\mathcal E=(\boldsymbol{\varepsilon}_1,\ldots,\boldsymbol{\varepsilon}_n)$ 的度量矩阵为

$$G_{\mathcal E}=\big(g_{ij}\big)_{n\times n},\qquad
g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i).$$

也就是「第 $i$ 行第 $j$ 列」放 $(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$。**为什么下标要反过来？** 因为坐标 $\eta_i$ 来自**第二**变元、展开时带共轭并落在行位置，$\xi_j$ 来自第一变元、落在列位置；只有把 $(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$ 放在 $(i,j)$ 元上，才能与上面的展开式逐项对上。若改用「第二变元线性」的相反约定，则须改取 $g_{ij}=(\boldsymbol{\varepsilon}_i,\boldsymbol{\varepsilon}_j)$——**约定与公式必须配套**，这正是勘误 E3 的要点。

于是上面的展开式紧凑地写成

$$ (\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm H}G_{\mathcal E}\boldsymbol{\xi}. $$

$G_{\mathcal E}$ 一定是正定 Hermite 矩阵（这是命题 1.4.2 的内容，证明见 [@prop-1.4.2]，此处先记结论）。若这组基在该内积下两两正交，且每个基向量与**自身**的内积为 $1$（即它是标准正交基），则 $G_{\mathcal E}=I$。

:::

::: errata 勘误 E3 · 课件页 15–16 的下标约定

原课件展开矩阵的第 $i$ 行第 $j$ 列实际是 $(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$，这与坐标公式 $\boldsymbol{\eta}^{\mathrm H}G\boldsymbol{\xi}$ 一致；但课件的紧凑记号写成了 $((\boldsymbol{\varepsilon}_i,\boldsymbol{\varepsilon}_j))$。若照通常的「下标顺序 = 行、列」理解，两者差一个转置。本教程明确采用 $g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$，从而与展开矩阵和坐标公式同时一致。

:::

::: ex 例 1.4.D · 非标准基下用 Gram 矩阵计算内积 {#ex-1.4.D}

在 $\mathbb R^2$ 的标准内积下，取基 $\boldsymbol{\varepsilon}_1=(1,0)^{\mathrm T}$、$\boldsymbol{\varepsilon}_2=(1,1)^{\mathrm T}$。(1) 求度量矩阵 $G_{\mathcal E}$；(2) 若 $[\boldsymbol{x}]_{\mathcal E}=\boldsymbol{\xi}=(2,-1)^{\mathrm T}$，$[\boldsymbol{y}]_{\mathcal E}=\boldsymbol{\eta}=(1,3)^{\mathrm T}$，用坐标公式计算 $(\boldsymbol{x},\boldsymbol{y})$，并直接回代验证。

::: sol 解答

**(1)** 由定义 $g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$：

$$G_{\mathcal E}=\begin{pmatrix}1&1\\1&2\end{pmatrix}.$$

**(2)** 代入坐标公式：

$$ (\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm T}G_{\mathcal E}\boldsymbol{\xi}
=\begin{pmatrix}1&3\end{pmatrix}\begin{pmatrix}1&1\\1&2\end{pmatrix}\begin{pmatrix}2\\-1\end{pmatrix}=1. $$

直接验算：$\boldsymbol{x}=2\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2=(1,-1)^{\mathrm T}$，$\boldsymbol{y}=\boldsymbol{\varepsilon}_1+3\boldsymbol{\varepsilon}_2=(4,3)^{\mathrm T}$，点积为 $4-3=1$，两种算法一致。

:::

:::

<a id="sec-1.4.7"></a>

## 1.4.7 换基与矩阵合同

内积是空间固有的对象，与基无关；度量矩阵却是它在某组基下的记录。换一组基，记录必然跟着变，问题只在按什么规律变。下面的命题给出答案，顺带说清度量矩阵为什么一定是正定 Hermite 的——定义 1.4.4 里那句「先记结论」就此兑现。

::: thm 命题 1.4.2 · 度量矩阵的性质 {#prop-1.4.2}

设 $\mathcal E=(\boldsymbol{\varepsilon}_1,\ldots,\boldsymbol{\varepsilon}_n)$ 和 $\mathcal F=(\boldsymbol{\phi}_1,\ldots,\boldsymbol{\phi}_n)$ 是内积空间 $V$ 的两组基，$P$ 是由 $\mathcal E$ 到 $\mathcal F$ 的过渡矩阵：

$$ (\boldsymbol{\phi}_1,\ldots,\boldsymbol{\phi}_n)
=(\boldsymbol{\varepsilon}_1,\ldots,\boldsymbol{\varepsilon}_n)P. $$

则：（1）$G_{\mathcal E}$、$G_{\mathcal F}$ 都是正定 Hermite 矩阵；（2）两者满足

$$ G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P, $$

因而它们称为**合同**（congruent）。

:::

::: proof 证

先看 Hermite 性：$(G_{\mathcal E})_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)=\overline{(\boldsymbol{\varepsilon}_i,\boldsymbol{\varepsilon}_j)}=\overline{(G_{\mathcal E})_{ji}}$，故 $G_{\mathcal E}^{\mathrm H}=G_{\mathcal E}$。对任意非零坐标 $\boldsymbol{\xi}$，其对应向量 $\boldsymbol{x}\neq\boldsymbol{\theta}$，所以

$$ \boldsymbol{\xi}^{\mathrm H}G_{\mathcal E}\boldsymbol{\xi}=(\boldsymbol{x},\boldsymbol{x})\gt0, $$

即 $G_{\mathcal E}$ 正定；$G_{\mathcal F}$ 同理。再设向量 $\boldsymbol{x}$ 在两组基下的坐标分别为 $\boldsymbol{\xi}$、$\boldsymbol{\alpha}$。由 [1.3.7](sec13.md#sec-1.3.7) 的换基公式有 $\boldsymbol{\xi}=P\boldsymbol{\alpha}$，因而

$$ (\boldsymbol{x},\boldsymbol{x})
=\boldsymbol{\xi}^{\mathrm H}G_{\mathcal E}\boldsymbol{\xi}
=\boldsymbol{\alpha}^{\mathrm H}P^{\mathrm H}G_{\mathcal E}P\boldsymbol{\alpha}. $$

另一方面 $(\boldsymbol{x},\boldsymbol{x})=\boldsymbol{\alpha}^{\mathrm H}G_{\mathcal F}\boldsymbol{\alpha}$。令 $H=G_{\mathcal F}-P^{\mathrm H}G_{\mathcal E}P$，则 $H$ 是 Hermite 矩阵且 $\boldsymbol\alpha^{\mathrm H}H\boldsymbol\alpha=0$ 对任意 $\boldsymbol\alpha$ 成立。依次取 $\boldsymbol\alpha=\boldsymbol e_i$ 得 $h_{ii}=0$；取 $\boldsymbol e_i+\boldsymbol e_j$ 得 $\operatorname{Re}h_{ij}=0$；取 $\boldsymbol e_i+i\boldsymbol e_j$ 得 $\operatorname{Im}h_{ij}=0$。故 $H=O$，即 $G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P$。

:::

<figure aria-labelledby="fig-gram-caption" class="concept-figure" data-figure="FIG. 1–08">
<svg aria-labelledby="fig-gram-title fig-gram-desc" role="img" viewBox="0 0 680 270">
<title id="fig-gram-title">同一内积在不同基下的度量矩阵通过合同变换联系</title>
<desc id="fig-gram-desc">从旧基度量矩阵出发，左乘过渡矩阵的共轭转置，右乘过渡矩阵，得到新基度量矩阵。</desc>
<defs><marker id="gram-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<rect class="diagram-node" height="124" rx="12" width="176" x="42" y="69"></rect>
<text class="diagram-mono" x="67" y="98">BASIS E</text><text class="diagram-text" x="67" y="128">旧基的度量矩阵</text><text class="diagram-note" x="67" y="163">Gₑ</text>
<line class="diagram-accent" marker-end="url(#gram-arrow)" x1="238" x2="438" y1="130" y2="130"></line>
<text class="diagram-mono" x="276" y="108">Pᴴ (·) P</text><text class="diagram-note" x="267" y="164">换基作用于内积的两个变元</text>
<rect class="diagram-node" height="124" rx="12" width="180" x="458" y="69"></rect>
<text class="diagram-mono" x="483" y="98">BASIS F</text><text class="diagram-text" x="483" y="128">新基的度量矩阵</text><text class="diagram-note" x="483" y="163">Gᶠ = PᴴGₑP</text>
<text class="diagram-note" x="155" y="235">内积本身未变；变的是它在不同坐标系中的矩阵表示</text>
</svg>
<figcaption id="fig-gram-caption">合同变换与 1.3 节的坐标变换是同一件事的两面：坐标通过 $P$ 变换，二次型的矩阵因而通过 $P^{\mathrm H}(\cdot)P$ 变换。</figcaption>
</figure>

::: errata 勘误 E4 · 课件页 16 注 4 缺少前提

课件写「内积空间中内积与度量矩阵是一一对应的」。更严格的表述是：**固定线性空间的一组基以后**，内积与正定 Hermite 矩阵一一对应。如果换基，同一个内积会得到不同但合同的度量矩阵，正如[@prop-1.4.2] 所示。

:::

::: think 术语与对比 · 「合同」与本科见过的「相似」

本科线性代数（特征值部分）见过的是**相似**：$B=P^{-1}AP$，刻画同一个线性变换在不同基下的矩阵。本节的**合同**：$B=P^{\mathrm H}AP$，刻画同一个内积（或二次型）在不同基下的矩阵。两者都是「换基引起的矩阵变化」，但配方不同、守护的信息不同：

| | 相似 $B=P^{-1}AP$ | 合同 $B=P^{\mathrm H}AP$ |
|:--|:--|:--|
| 对象 | 线性变换 $\boldsymbol{x}\mapsto A\boldsymbol{x}$（吃进、吐出各**一个**变元） | 内积 / 二次型（吃进**两个**变元） |
| 为何是这个配方 | 线性变换作用后换基，$P$ 只出现一次 | 坐标按 $\boldsymbol\xi=P\boldsymbol\alpha$ 变（[1.3.7](sec13.md#sec-1.3.7)），两个变元各变一次，两边各挤出一个 $P$，得 $P^{\mathrm H}(\cdot)P$ |
| 保持的量 | 特征值、行列式、迹、秩 | 秩、正定性（不保持特征值） |
| 典型问题 | 对角化：$P^{-1}AP=\Lambda$ | 化简二次型：$P^{\mathrm H}AP=\Lambda$ |

相似与合同互不包含（$P^{\mathrm H}$ 一般不等于 $P^{-1}$），但有一个重要的交汇点：当过渡矩阵 $P$ 是**酉矩阵**（满足 $P^{\mathrm H}P=I$，于是 $P^{-1}=P^{\mathrm H}$；定义见本节开头的术语说明）时，$P^{\mathrm H}AP=P^{-1}AP$，合同与相似合二为一，称为**酉相似**。后续「Gram–Schmidt 正交化 → 标准正交基 → 酉对角化」整条技术路线，本质上就是想办法把过渡矩阵取成酉矩阵，让两种变换同时受益。

:::

<a id="sec-1.4.8"></a>

## 1.4.8 小结与常见错误

下表把本节的核心对象、必须记住的结论与高频错误并排放一次——最后一列才是真正要盯住的地方。

| 核心对象 | 必须记住 | 高频错误 |
|:--|:--|:--|
| 复内积 | 第一变元线性，第二变元共轭线性 | 把 $\boldsymbol y^{\mathrm H}\boldsymbol x$ 误写成 $\boldsymbol y^{\mathrm T}\boldsymbol x$ |
| $\boldsymbol y^{\mathrm H}A\boldsymbol x$ | 定义内积当且仅当 $A$ 正定 Hermite | 只验证 $A=A^{\mathrm H}$，漏掉正定性 |
| 半正定矩阵 | 二次型恒非负（正定也算半正定） | 把半正定矩阵诱导的形式当成内积 |
| 半正定**但非正定** | 此时才**存在非零向量使二次型为 $0$**（如 $A=O$，或 $\begin{pmatrix}1&0\\0&0\end{pmatrix}$ 取 $\boldsymbol x=(0,1)^{\mathrm T}$） | 以为「半正定」就等于「有非零向量被零化」——正定矩阵就没有 |
| Gram 矩阵 | 下标约定要与 $\boldsymbol\eta^{\mathrm H}G\boldsymbol\xi$ 一致 | 忽略「第一变元线性」约定而错一个转置 |
| 换基 | $G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P$ | 把合同变换误当相似变换 $P^{-1}GP$ |

**本节主线：**内积公理规定「什么是可用的几何测量」；正定 Hermite 矩阵在坐标中构造这种测量；固定一组基后，Gram 矩阵记录内积；换基时，这个记录按合同关系变化。

::: method 即时自测 · 1.4

本节的失分点集中在「**符号约定**」——线性变元记错、转置与共轭转置混用、Gram 下标与公式不配套。

::: hint 第 1 题 · 记忆

写出内积四条公理。为什么说「第一变元线性」是本教程声明的**约定**，而不是公理本身？「欧几里得空间」与「酉空间」分别指什么？（对应 [1.4.1](sec14.md#sec-1.4.1)）
:::

::: sol 第 1 题答案

① 共轭对称性：$(\boldsymbol{x},\boldsymbol{y})=\overline{(\boldsymbol{y},\boldsymbol{x})}$；② 第一变元可加性；③ 第一变元齐次性；④ 正定性。

**声明的是「第一变元线性」这一约定**（于是第二变元共轭线性）：公理 (2)(3) 只规定第一变元如何拆开，把线性性安排在哪个变元上本可自由选择——有些教材取相反约定，两者都自洽，但不能混用。

「欧几里得空间」= 有限维**实**内积空间；「酉空间」= 有限维**复**内积空间（酉是 unitary 的音译）。
:::

::: hint 第 2 题 · 辨析

设 $A\in\mathbb{C}^{n\times n}$。$(\boldsymbol{x},\boldsymbol{y})_A=\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 定义内积的**充要条件**是什么？只验证 $A=A^{\mathrm H}$ 够不够？（对应 [1.4.3](sec14.md#sec-1.4.3)）
:::

::: sol 第 2 题答案

**充要条件是 $A$ 为 Hermite 且正定**：$A=A^{\mathrm H}$ 且对一切 $\boldsymbol{x}\neq\boldsymbol{0}$ 有 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}>0$。

**只验 Hermite 不够。**反例：$A=\begin{pmatrix}1&i\\-i&1\end{pmatrix}$ 是 Hermite，但 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}=|x_1+ix_2|^2$ 会在某个**非零**向量处取到零（取 $x_1=-ix_2\neq0$），违反正定性（[@ex-1.4.6]）。**半正定矩阵只能给出「半内积」。**

**记忆要点：**可加性与齐次性对**任意** $A$ 自动成立（矩阵乘法给的），真正需要检查的只有**共轭对称（$\Rightarrow$ Hermite）**与**正定**两项。
:::

::: hint 第 3 题 · 应用

在 $\mathbb{R}^2$ 的标准内积下取基 $\boldsymbol{\varepsilon}_1=(1,0)^{\mathrm T}$、$\boldsymbol{\varepsilon}_2=(1,1)^{\mathrm T}$。求度量矩阵 $G$，并用坐标公式计算 $\boldsymbol{x}=2\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2$、$\boldsymbol{y}=\boldsymbol{\varepsilon}_1+3\boldsymbol{\varepsilon}_2$ 的内积。（对应 [1.4.6](sec14.md#sec-1.4.6)）
:::

::: sol 第 3 题答案

$G=\begin{pmatrix}1&1\\1&2\end{pmatrix}$（按本教程约定 $g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$；实空间中共轭不起作用）。

坐标 $\boldsymbol{\xi}=(2,-1)^{\mathrm T}$、$\boldsymbol{\eta}=(1,3)^{\mathrm T}$，故

$$(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm T}G\boldsymbol{\xi}=\begin{pmatrix}1&3\end{pmatrix}\begin{pmatrix}1&1\\1&2\end{pmatrix}\begin{pmatrix}2\\-1\end{pmatrix}=1.$$

**回代验证：**$\boldsymbol{x}=(1,-1)^{\mathrm T}$、$\boldsymbol{y}=(4,3)^{\mathrm T}$，点积 $4-3=1$ ✓。

**两条纪律。**① 换基后**内积的数值不变**，变的只是它的矩阵表示；② 用 $G$ 计算时，下标约定要与 $\boldsymbol{\eta}^{\mathrm H}G\boldsymbol{\xi}$ 配套（这正是勘误 E3 的内容）。
:::

::: hint 第 4 题 · 迁移

「相似」$B=P^{-1}AP$ 与「合同」$B=P^{\mathrm H}AP$ 各自守护什么信息？什么条件下两者重合？（对应 [1.4.7](sec14.md#sec-1.4.7)）
:::

::: sol 第 4 题答案

**相似**刻画同一个**线性变换**在不同基下的矩阵，保持特征值、行列式、迹、秩；**合同**刻画同一个**内积 / 二次型**在不同基下的矩阵，保持秩与**正定性**（但一般**不保持特征值**）。

两者配方不同的根源：线性变换只「吃进一个变元」，换基时 $P$ 出现一次；内积有两个变元，坐标按 $\boldsymbol{\xi}=P\boldsymbol{\alpha}$ 变，两边各挤出一个，故得 $P^{\mathrm H}(\cdot)P$。

**重合条件：$P$ 是酉矩阵**（$P^{\mathrm H}P=I$，于是 $P^{-1}=P^{\mathrm H}$），此时合同 = 相似，称为**酉相似**。后续整条「Gram–Schmidt 正交化 → 标准正交基 → 酉对角化」的技术路线，本质就是想办法把过渡矩阵取成酉矩阵。
:::

:::
