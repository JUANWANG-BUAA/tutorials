# 1.1 线性空间

本节回答一个问题：**什么样的集合上可以做「加法」和「数乘」？**讨论从熟悉的三维几何向量出发，把「实数 × 向量」逐步放宽到「数域 × 任意集合」，最终得到线性空间的公理化定义（[@def-1.1.5]），并建立一套判定集合是否为线性空间的标准流程。

::: preview 先抓住一件事

本节的核心判断是：**一套运算规则是否足够稳定，使加法、数乘的结果始终留在同一个集合内。**肯定一个空间要检查全部结构；否定它通常只需找到一条被破坏的规则。
:::

<a id="sec-1.1.1"></a>

## 1.1.1 集合与空间：从「一堆东西」到「有结构的集合」

**集合**（set）是由确定的、互不相同的对象构成的整体。要讨论「什么样的集合上能做运算」，先把「集合」这个词本身说清楚：一个「整体」要算作集合，必须满足下面三条特性。

| 特性 | 含义 | 正反例 |
|:--:|:--|:--|
| **确定性** | 任一对象是否属于该集合，必须有明确标准 | 「接近 0 的实数」不是集合（「接近」无标准）；$\|x\|\lt 0.01$ 的实数是集合 |
| **互异性** | 集合中的元素彼此不同，不允许重复 | $\{1,1,2\}$ 与 $\{1,2\}$ 是同一集合 |
| **无序性** | 元素没有先后顺序 | $\{1,2,3\}=\{3,1,2\}$ |

本章反复用到的是**确定性**：判定一个集合能否做运算，第一步总是问「某个对象属不属于它」有无明确标准。

但满足这三条的，还只是一堆东西。**空间**（space）在数学中特指**具有特殊性质及额外结构的集合**，即「空间 = 集合 + 结构」：集合只负责装元素，空间还要求元素之间存在可以运算的关系。本章先为集合配上两种运算——加法与数乘；到 [1.4](sec14.md) 节再加入内积，线性空间才升级为能讨论长度、夹角与正交的几何空间。

<a id="sec-1.1.2"></a>

## 1.1.2 n 维向量与向量空间

### 从三维几何向量说起

以三维向量空间为例：取定空间中一点 $O$ 为起点、任意一点 $A$ 为终点，可确定一个向量 $\overrightarrow{OA}$。于是「点 $A$」与「向量 $\overrightarrow{OA}$」一一对应；建立坐标系后，「向量 $\overrightarrow{OA}$」又与三元有序数组 $(a_1,a_2,a_3)$ 一一对应。**两重一一对应把「几何点」翻译成了「数组」**——这就是解析几何的做法，也是「向量」最初的样子。

<figure aria-labelledby="fig-pt-vec-caption">
<svg font-size="12" height="213" viewBox="0 0 340 220" width="330" xmlns="http://www.w3.org/2000/svg" aria-labelledby="fig-pt-vec-title fig-pt-vec-desc" role="img" aria-describedby="fig-pt-vec-caption">
<title id="fig-pt-vec-title">点与向量的两重一一对应</title>
<desc id="fig-pt-vec-desc">取定点 O 为起点、点 A 为终点得到向量 OA，于是点 A 与向量 OA 一一对应；建立坐标系后，向量 OA 又与三元有序数组 (a₁,a₂,a₃) 一一对应。两重对应把几何点翻译成数组。</desc>
<defs><marker id="a1" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="2.6"><path d="M0,0 L6.5,2.6 L0,5.2 Z" fill="var(--fig-neutral)"></path></marker></defs>
<!-- axes -->
<line marker-end="url(#a1)" stroke="var(--fig-neutral)" stroke-width="1.3" x1="60" x2="300" y1="170" y2="170"></line>
<line marker-end="url(#a1)" stroke="var(--fig-neutral)" stroke-width="1.3" x1="60" x2="60" y1="170" y2="30"></line>
<line marker-end="url(#a1)" stroke="var(--fig-neutral)" stroke-width="1.3" x1="60" x2="15" y1="170" y2="200"></line>
<text fill="var(--fig-neutral)" x="305" y="175">x</text><text fill="var(--fig-neutral)" x="55" y="25">y</text><text fill="var(--fig-neutral)" x="8" y="208">z</text>
<text fill="var(--fig-neutral)" x="52" y="184">O</text>
<!-- projections dashed -->
<line stroke="var(--line-strong)" stroke-dasharray="4 3" stroke-width="1" x1="210" x2="210" y1="60" y2="170"></line>
<line stroke="var(--line-strong)" stroke-dasharray="4 3" stroke-width="1" x1="210" x2="60" y1="60" y2="60"></line>
<!-- vector -->
<line marker-end="url(#a1)" stroke="var(--fig-blue)" stroke-width="2.2" x1="60" x2="210" y1="170" y2="60"></line>
<circle cx="210" cy="60" fill="var(--fig-red)" r="3.2"></circle>
<text fill="var(--fig-red)" x="216" y="54">A (a₁, a₂, a₃)</text>
<text fill="var(--fig-blue)" font-style="italic" x="118" y="105">α</text>
<text fill="var(--muted)" x="96" y="60">a₂</text><text fill="var(--muted)" x="210" y="150">a₁</text>
</svg>
<figcaption>图 1-1 · 点 A、向量 $\overrightarrow{OA}$ 与有序数组 $(a_1,a_2,a_3)$ 一一对应</figcaption>
<figcaption id="fig-pt-vec-caption">取定点 O 为起点、点 A 为终点得到向量 OA，于是点 A 与向量 OA 一一对应；建立坐标系后，向量 OA 又与三元有序数组 (a₁,a₂,a₃) 一一对应。两重对应把几何点翻译成数组。</figcaption>
</figure>

把两重对应最右端的「有序数组」单独取出来作为研究对象，就得到本章最基本的角色。

::: def 定义 1.1.1 · n 维向量 {#def-1.1.1}

由 $n$ 个数 $a_1,a_2,\cdots,a_n$ 组成的**有序数组**称为一个 **$n$ 维向量**。若 $n$ 维向量写成 $\begin{pmatrix}a_1\\a_2\\\vdots\\a_n\end{pmatrix}$ 的形式，称为 **$n$ 维列向量**；写成 $(a_1,a_2,\cdots,a_n)$ 的形式，称为 **$n$ 维行向量**。这 $n$ 个数称为该向量的 $n$ 个**分量**（components），其中 $a_i$ 称为第 $i$ 个分量。

:::

设 $\boldsymbol{\alpha}=(a_1,a_2,\cdots,a_n)^{\mathrm T}$，$\boldsymbol{\beta}=(b_1,b_2,\cdots,b_n)^{\mathrm T}$，$k\in\mathbb{R}$，则有**加法**与**数乘**两种运算：

$$\boldsymbol{\alpha}+\boldsymbol{\beta}=\begin{pmatrix}a_1+b_1\\ a_2+b_2\\ \vdots\\ a_n+b_n\end{pmatrix},\qquad k\boldsymbol{\alpha}=\begin{pmatrix}ka_1\\ ka_2\\ \vdots\\ ka_n\end{pmatrix},$$

即加法按分量相加、数乘把 $k$ 乘到每个分量上。几何上，加法是「平行四边形法则」，数乘是「伸缩」（$k\lt0$ 时反向）。而**两个运算的结果仍是同维数组**——结果跑不出这类数组之外，这正是下面「封闭性」的由来。

::: def 定义 1.1.2 · 向量空间 vector space {#def-1.1.2}

设 $V$ 是 $n$ 维实向量的非空集合。若 $V$ 对向量的加法和数乘两种运算都**封闭**，即 $\forall\boldsymbol{\alpha},\boldsymbol{\beta}\in V$ 和 $k\in\mathbb{R}$，都有 $\boldsymbol{\alpha}+\boldsymbol{\beta}\in V$ 和 $k\boldsymbol{\alpha}\in V$，则称集合 $V$ 为**向量空间**。

:::

封闭性往往只差一个分量。下面两个集合几乎一样，结论却相反。

::: ex 例 1.1.1 {#ex-1.1.1}

定义集合 $V_1=\left\{(0,a_2,\cdots,a_n)^{\mathrm T}\mid a_2,\cdots,a_n\in\mathbb{R}\right\}$，判断 $V_1$ 是否为向量空间。

::: sol 解答

$\forall\boldsymbol{\alpha}=(0,a_2,\cdots,a_n)^{\mathrm T},\ \boldsymbol{\beta}=(0,b_2,\cdots,b_n)^{\mathrm T}\in V_1$ 以及 $\forall k\in\mathbb{R}$，有

$$\boldsymbol{\alpha}+\boldsymbol{\beta}=\begin{pmatrix}0\\ a_2+b_2\\ \vdots\\ a_n+b_n\end{pmatrix}\in V_1,\qquad k\boldsymbol{\alpha}=\begin{pmatrix}0\\ ka_2\\ \vdots\\ ka_n\end{pmatrix}\in V_1,$$

所以 $V_1$ 对向量的加法和数乘运算封闭。由[@def-1.1.2] 知，$V_1$ 是向量空间。

:::

:::

::: ex 例 1.1.2 {#ex-1.1.2}

集合 $V_2=\left\{(1,a_2,\cdots,a_n)^{\mathrm T}\mid a_2,\cdots,a_n\in\mathbb{R}\right\}$ 是向量空间吗？

::: sol 解答

$\forall\boldsymbol{\alpha}=(1,a_2,\cdots,a_n)^{\mathrm T},\ \boldsymbol{\beta}=(1,b_2,\cdots,b_n)^{\mathrm T}\in V_2$，取 $k\in\mathbb{R}$，有

$$\boldsymbol{\alpha}+\boldsymbol{\beta}=\begin{pmatrix}2\\ a_2+b_2\\ \vdots\\ a_n+b_n\end{pmatrix}\notin V_2,\qquad k\boldsymbol{\alpha}=\begin{pmatrix}k\\ ka_2\\ \vdots\\ ka_n\end{pmatrix}\notin V_2\ (\text{当 } k\neq1),$$

相加后第一个分量变成 2，数乘后变成 $k$，都不再满足「第一分量恒为 1」这一条：$V_2$ 对加法和数乘都不封闭，不是向量空间。

:::

:::

更有代表性的是**用方程或不等式**给出的集合，这时要检验的是：条件在加法与数乘下能否保持。

::: ex 例 1.1.A · 判定练习：先找零元 {#ex-1.1.A}

判断下列集合是否为 $\mathbb{R}$ 上的向量空间：

(1) $V_3=\left\{(a_1,\cdots,a_n)^{\mathrm T}\in\mathbb{R}^n\ \middle|\ a_1+a_2+\cdots+a_n=0\right\}$；<br> (2) $V_4=\left\{(a_1,\cdots,a_n)^{\mathrm T}\in\mathbb{R}^n\ \middle|\ a_1+a_2+\cdots+a_n=1\right\}$；<br> (3) $V_5=\left\{(a_1,a_2)^{\mathrm T}\in\mathbb{R}^2\ \middle|\ a_1\geq 0\right\}$。

::: sol 解答

**(1) 是。**任取 $\boldsymbol{\alpha},\boldsymbol{\beta}\in V_3$，其分量和分别为 0；则 $\boldsymbol{\alpha}+\boldsymbol{\beta}$ 的分量和为 $0+0=0$，$k\boldsymbol{\alpha}$ 的分量和为 $k\cdot 0=0$，故两者都落在 $V_3$ 中，封闭性成立。（$V_3$ 是 $\mathbb{R}^n$ 中过原点的「**超平面**」：由**一个**线性方程刻画的 $n-1$ 维平直对象——三维空间中的平面、二维空间中的直线都是它的特例；几何讨论见 [@ex-1.2.D]。）

**(2) 不是。**最快的否决法：$0\cdot\boldsymbol{\alpha}=\boldsymbol{0}$ 的分量和为 $0\neq1$，即**零向量不在 $V_4$ 中**（$V_4$ 也不含任何「分量和为 0」的向量）；而任何向量空间必须含零向量。此外加法也不封闭：两个分量和为 1 的向量之和分量和为 2。

**(3) 不是。**对加法封闭（非负 + 非负 = 非负），但数乘不封闭：取 $\boldsymbol{\alpha}=(1,0)^{\mathrm T}\in V_5$，$(-1)\boldsymbol{\alpha}=(-1,0)^{\mathrm T}\notin V_5$。**这说明「只验证加法封闭」是不够的。**

:::

:::

::: method 判定流程 · 「是不是向量空间」

**否定**（任选其一即可）：① 集合不含零向量；② 找到两个具体元素，其和不在集合中；③ 找到一个元素与一个数，数乘积不在集合中。<br> **肯定**：取「任意」元素与「任意」数（不能只取特殊值！），逐一验证加法、数乘封闭（若在更大的已知空间内讨论，封闭即够，理由见 [1.2](sec12.md) 节判定定理；若运算本身是新定义的，则须回到八条公理逐一验证，见[@ex-1.1.3]）。

:::

<a id="sec-1.1.3"></a>

## 1.1.3 数域：数乘中「数」的资格

在向量空间的定义里，「数乘」的「数」固定取自实数集 $\mathbb{R}$。要把定义推广到一般情形，先得回答：什么样的数集有资格充当这个「数」？

::: def 定义 1.1.3 · 数域 field {#def-1.1.3}

设 $F$ 是非空数集。若 $F$ 中包含 $0$ 与 $1$，且 $F$ 中任意两个数的和、差、积、商（除数不为 $0$）仍在该数集中，即对四则运算封闭，则称数集 $F$ 为一个**数域**。

:::

**基本例子。**有理数集 $\mathbb{Q}$、实数集 $\mathbb{R}$、复数集 $\mathbb{C}$ 都是数域；而自然数集 $\mathbb{N}$、整数集 $\mathbb{Z}$ 不是数域——$\mathbb{N}$ 中 $1-2=-1\notin\mathbb{N}$（无论是否把 $0$ 纳入自然数，对差都不封闭），$\mathbb{Z}$ 中 $1\div 2\notin\mathbb{Z}$（对商不封闭）。

::: think 思考 · $\mathbb{Q}(\sqrt2)=\{a+b\sqrt2\mid a,b\in\mathbb{Q}\}$ 是数域吗？

**是。**下面逐条验证[@def-1.1.3]。

::: sol 验证

**含 0 与 1：**取 $a=b=0$ 得 $0$，取 $a=1,b=0$ 得 $1$。

**和、差封闭：**$(a+b\sqrt2)\pm(c+d\sqrt2)=(a\pm c)+(b\pm d)\sqrt2$，系数仍为有理数。

**积封闭：**$(a+b\sqrt2)(c+d\sqrt2)=(ac+2bd)+(ad+bc)\sqrt2$，系数仍为有理数。

**商封闭：**设 $a+b\sqrt2\neq 0$。先把分母有理化：

$$\frac{c+d\sqrt2}{a+b\sqrt2}=\frac{(c+d\sqrt2)(a-b\sqrt2)}{(a+b\sqrt2)(a-b\sqrt2)}=\frac{ac-2bd+(ad-bc)\sqrt2}{a^2-2b^2}.$$

只需说明分母 $a^2-2b^2\neq 0$：若 $a^2=2b^2$ 且 $b\neq0$，则 $(a/b)^2=2$，即 $a/b$ 是 $\sqrt2$，与「$\sqrt2$ 是无理数」矛盾；若 $b=0$，则 $a^2=0$ 即 $a=0$，此时 $a+b\sqrt2=0$，已排除。故分母非零，商形如 $p+q\sqrt2$（$p,q\in\mathbb{Q}$），仍在集合内。

:::

$\mathbb{Q}(\sqrt2)$ 是一个「比 $\mathbb{Q}$ 大、比 $\mathbb{R}$ 小」的数域——数域远不止三个。同法可证 $\mathbb{Q}(i)=\{a+b i\mid a,b\in\mathbb{Q}\}$ 也是数域（习题 B1 要求对 $\{a+b\sqrt[3]{2}\}$ 作否定判断）。

:::

<a id="sec-1.1.4"></a>

## 1.1.4 加群与线性空间：公理化定义

现在把向量空间推广到一般情形，对照着放宽三处：

| 向量空间（[@def-1.1.2]） | 一般线性空间（目标） |
|:--|:--|
| 实数 $\mathbb{R}$ | 一般数域 $F$ |
| $n$ 维实向量的集合 | 任意非空集合 $V$（元素不一定是数组） |
| 数组加法、数组数乘 | 抽象的加法「$+$」与数乘「$\cdot$」（只要是良定义的运算） |

三处放宽里，第三处最费思量：运算不再有现成公式，得自己规定，也就得自己保证它良定义。推广分两步走，次序不能颠倒——先让 $V$ 自身成为一个加群，再让数域 $F$ 中的数作用到 $V$ 上。

::: def 定义 1.1.4 · 加群 additive group {#def-1.1.4}

在非空集合 $V$ 上定义一种代数运算，称之为**加法**，记为「$+$」，使得 $\forall\boldsymbol{\alpha},\boldsymbol{\beta}\in V$ 都有 $V$ 中**唯一**元素 $\boldsymbol{\alpha}+\boldsymbol{\beta}$ 与之对应（该元素称为 $\boldsymbol{\alpha}$ 与 $\boldsymbol{\beta}$ 的和），且满足：

（1）**交换律**：$\boldsymbol{\alpha}+\boldsymbol{\beta}=\boldsymbol{\beta}+\boldsymbol{\alpha}$；<br> （2）**结合律**：$(\boldsymbol{\alpha}+\boldsymbol{\beta})+\boldsymbol{\gamma}=\boldsymbol{\alpha}+(\boldsymbol{\beta}+\boldsymbol{\gamma})$；<br> （3）存在**零元素** $\boldsymbol{\theta}\in V$，使得 $\forall\boldsymbol{\alpha}\in V,\ \boldsymbol{\alpha}+\boldsymbol{\theta}=\boldsymbol{\alpha}$；<br> （4）$\forall\boldsymbol{\alpha}\in V$，存在**负元素** $-\boldsymbol{\alpha}$ 使得 $\boldsymbol{\alpha}+(-\boldsymbol{\alpha})=\boldsymbol{\theta}$。

则称 $V$ 在加法运算下构成一个加群，记为 $(V,+)$。

:::

::: note

**「加群」的来历。**「加群」（additive group）一词借自近世代数：把「一个集合配上一种运算，运算封闭、满足结合律、有单位元、每个元素有逆元」的整体称为**群**；运算还可交换的群称为**交换群**。「加群」＝把运算记作加法、单位元记作 $\boldsymbol{\theta}$ 的交换群——上面四条公理恰好是这句话的逐字展开。教材借这个名词把八条公理**拆成两段打包**：加法四条说「$V$ 自身构成加群」，数乘四条说「数乘与两种加法相容」。本课程**不**需要任何进一步的群论知识——见到「加群」，回想这四条即可。

**关于良定义。**定义中「都有 $V$ 中唯一元素与之对应」就是在说运算**良定义**（well-defined）：结果只由元素本身决定，不依赖元素的写法。一个经典反例：在正分数集合上规定 $\dfrac{a}{b}\oplus\dfrac{c}{d}=\dfrac{a+c}{b+d}$。$\dfrac12$ 与 $\dfrac24$ 是**同一个**元素，但

$$\frac12\oplus\frac13=\frac25,\qquad \frac24\oplus\frac13=\frac37,$$

结果随写法而变——这个「运算」不良定义，没有资格进入公理体系。

:::

加法就位之后，轮到数乘。它把数域 $F$ 中的数与 $V$ 中的向量联系起来，剩下的四条公理就是这种联系的规矩。

::: def 定义 1.1.5 · 线性空间 linear space {#def-1.1.5}

设 $(V,+)$ 是一个加群，$F$ 是一个数域。若在 $F$ 中的数与 $V$ 中元素之间定义了一种代数运算，称为**数乘**，使得 $\forall\lambda\in F,\ \boldsymbol{\alpha}\in V$，有 $V$ 中唯一元素 $\lambda\boldsymbol{\alpha}$ 与之对应（$\lambda\boldsymbol{\alpha}$ 称为 $\lambda$ 与 $\boldsymbol{\alpha}$ 的积），且满足：

（1）**数乘对加法的分配律**：$\lambda(\boldsymbol{\alpha}+\boldsymbol{\beta})=\lambda\boldsymbol{\alpha}+\lambda\boldsymbol{\beta}$；<br> （2）**数乘对数的加法的分配律**：$(\lambda+\mu)\boldsymbol{\alpha}=\lambda\boldsymbol{\alpha}+\mu\boldsymbol{\alpha}$；<br> （3）**数乘结合律**：$(\lambda\mu)\boldsymbol{\alpha}=\lambda(\mu\boldsymbol{\alpha})$；<br> （4）**单位律**：$1\boldsymbol{\alpha}=\boldsymbol{\alpha}$。

则称 $V$ 是数域 $F$ 上的**线性空间**，记为 $(V,+,\cdot)$，$V$ 中元素称为**向量**。当 $F=\mathbb{R}$ 时称为**实线性空间**；当 $F=\mathbb{C}$ 时称为**复线性空间**。

:::

::: note

**读定义的三个要点。**① 「唯一元素与之对应」意为运算封闭且良定义：两向量相加、数乘向量，结果必须仍在 $V$ 中，且不依赖元素的写法。② 加法四条 + 数乘四条合称**八条公理**，一律针对「任意」元素成立——验证时不能只代具体数值。③ 定义里「$F$ 上的线性空间」这一说法提醒我们：**同一个集合，换一个数域，结论可能不同**（见[@ex-1.3.1] 与[@ex-1.3.5]）。

:::

::: think 为什么第 (4) 条 $1\boldsymbol{\alpha}=\boldsymbol{\alpha}$ 不能省？

**这些公理并非彼此独立。**例如加法交换律其实可由其余条款推出：由 $(1+1)(\boldsymbol{\alpha}+\boldsymbol{\beta})=(1+1)\boldsymbol{\alpha}+(1+1)\boldsymbol{\beta}=\boldsymbol{\alpha}+\boldsymbol{\alpha}+\boldsymbol{\beta}+\boldsymbol{\beta}$ 与 $(1+1)(\boldsymbol{\alpha}+\boldsymbol{\beta})=1(\boldsymbol{\alpha}+\boldsymbol{\beta})+1(\boldsymbol{\alpha}+\boldsymbol{\beta})=\boldsymbol{\alpha}+\boldsymbol{\beta}+\boldsymbol{\alpha}+\boldsymbol{\beta}$ 消去即得 $\boldsymbol{\alpha}+\boldsymbol{\beta}=\boldsymbol{\beta}+\boldsymbol{\alpha}$。但第 (4) 条 $1\boldsymbol{\alpha}=\boldsymbol{\alpha}$ 确实不能省，反例就藏在「其余七条」里：任取一个加群 $(V,+)$，定义 $k\cdot\boldsymbol{\alpha}\equiv\boldsymbol{\theta}$（数乘恒给零向量）。则分配律两条、数乘结合律全部成立（两边都是 $\boldsymbol{\theta}$），但 $1\boldsymbol{\alpha}=\boldsymbol{\theta}\neq\boldsymbol{\alpha}$（只要 $\boldsymbol{\alpha}\neq\boldsymbol{\theta}$）。可见「$1$ 乘任何向量不变」是真正的内容，不是废话——满足其余七条并不足以保证是线性空间。

:::

<a id="sec-1.1.5"></a>

## 1.1.5 线性空间的基本性质

八条公理只保证零元素、负元素**存在**，没有保证唯一；而 $-\boldsymbol{\alpha}$ 这样的记号本身，就预设了唯一性。下面注 1 的四条性质补上这个缺口，其中 (3)(4) 还处理了「$0$ 乘向量」「数乘得零」这类看似显然、却只能由公理推出的等式。

::: thm 注 1 · 基本性质 {#thm-basic-props}

设 $V$ 是数域 $F$ 上的线性空间，则：

（1）零向量是唯一的；<br>（2）任一向量的负向量是唯一的；<br> （3）对任意 $k\in F$ 和 $\boldsymbol{\alpha}\in V$，有 $0\boldsymbol{\alpha}=\boldsymbol{\theta}$，$(-1)\boldsymbol{\alpha}=-\boldsymbol{\alpha}$，$k\boldsymbol{\theta}=\boldsymbol{\theta}$；<br> （4）若 $k\boldsymbol{\alpha}=\boldsymbol{\theta}$，则 $k=0$ 或 $\boldsymbol{\alpha}=\boldsymbol{\theta}$。

:::

::: proof 证

**（1）**设 $\boldsymbol{\theta}_1,\boldsymbol{\theta}_2$ 都是零元素。一方面 $\boldsymbol{\theta}_1+\boldsymbol{\theta}_2=\boldsymbol{\theta}_1$（把 $\boldsymbol{\theta}_2$ 当零元素用），另一方面 $\boldsymbol{\theta}_1+\boldsymbol{\theta}_2=\boldsymbol{\theta}_2$（把 $\boldsymbol{\theta}_1$ 当零元素用）。于是 $\boldsymbol{\theta}_1=\boldsymbol{\theta}_2$。

**（2）**设 $\boldsymbol{\beta},\boldsymbol{\gamma}$ 都是 $\boldsymbol{\alpha}$ 的负元素，即 $\boldsymbol{\alpha}+\boldsymbol{\beta}=\boldsymbol{\theta}=\boldsymbol{\alpha}+\boldsymbol{\gamma}$。则

$$\boldsymbol{\beta}=\boldsymbol{\beta}+\boldsymbol{\theta}=\boldsymbol{\beta}+(\boldsymbol{\alpha}+\boldsymbol{\gamma})=(\boldsymbol{\beta}+\boldsymbol{\alpha})+\boldsymbol{\gamma}=\boldsymbol{\theta}+\boldsymbol{\gamma}=\boldsymbol{\gamma},$$

依次用了零元素定义、$\boldsymbol{\gamma}$ 是负元素、结合律、交换律（$\boldsymbol{\beta}+\boldsymbol{\alpha}=\boldsymbol{\alpha}+\boldsymbol{\beta}=\boldsymbol{\theta}$）。

**（3）**先证 $0\boldsymbol{\alpha}=\boldsymbol{\theta}$：由分配律（2），

$$0\boldsymbol{\alpha}=(0+0)\boldsymbol{\alpha}=0\boldsymbol{\alpha}+0\boldsymbol{\alpha},$$

两边加上 $0\boldsymbol{\alpha}$ 的负元素，得 $\boldsymbol{\theta}=0\boldsymbol{\alpha}$。（这一步与「解方程 $x=x+x$」同理，合法性由负元素与结合律保证。）再证 $k\boldsymbol{\theta}=\boldsymbol{\theta}$：由「$\boldsymbol{\theta}=0\boldsymbol{\beta}$ 对任意 $\boldsymbol{\beta}$ 成立」与数乘结合律，

$$k\boldsymbol{\theta}=k(0\boldsymbol{\alpha})=(k\cdot 0)\boldsymbol{\alpha}=0\boldsymbol{\alpha}=\boldsymbol{\theta}.$$

最后证 $(-1)\boldsymbol{\alpha}=-\boldsymbol{\alpha}$：由分配律与刚证的结论，

$$\boldsymbol{\alpha}+(-1)\boldsymbol{\alpha}=1\boldsymbol{\alpha}+(-1)\boldsymbol{\alpha}=(1+(-1))\boldsymbol{\alpha}=0\boldsymbol{\alpha}=\boldsymbol{\theta},$$

即 $(-1)\boldsymbol{\alpha}$ 是 $\boldsymbol{\alpha}$ 的一个负元素；由（2）负元素唯一，故 $(-1)\boldsymbol{\alpha}=-\boldsymbol{\alpha}$。

**（4）**设 $k\boldsymbol{\alpha}=\boldsymbol{\theta}$。若 $k\neq 0$，则 $k$ 在数域 $F$ 中有逆 $k^{-1}$，于是

$$\boldsymbol{\alpha}=1\boldsymbol{\alpha}=(k^{-1}k)\boldsymbol{\alpha}=k^{-1}(k\boldsymbol{\alpha})=k^{-1}\boldsymbol{\theta}=\boldsymbol{\theta}.$$

故 $k=0$ 或 $\boldsymbol{\alpha}=\boldsymbol{\theta}$。

:::

::: note

**注 2。**线性空间中的加法与数乘两种运算合称**线性运算**。「线性」二字的一切后续展开（线性组合、线性子空间、线性相关性）都由这八条公理派生。

:::

<a id="sec-1.1.6"></a>

## 1.1.6 线性组合与线性表示

公理搭好了台子，接下来要回答一个具体问题：**一个向量能不能由给定的几个向量拼出来？**这就是线性组合与线性表示。

::: def 定义 · 线性组合 / 线性表示

设 $V$ 是数域 $F$ 上的线性空间，$\boldsymbol{\alpha},\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n\in V$。若存在 $k_i\in F,\ i=1,\cdots,n$，使得

$$\boldsymbol{\alpha}=k_1\boldsymbol{\alpha}_1+\cdots+k_n\boldsymbol{\alpha}_n,$$

则称 $\boldsymbol{\alpha}$ 是向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 的一个**线性组合**，或者说 $\boldsymbol{\alpha}$ 可由向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ **线性表示**。

:::

几何上，线性组合就是「沿每个方向各走一段，再把终点相加」：

<figure aria-labelledby="fig-span-caption" class="concept-figure" data-figure="FIG. 1–04">
<svg aria-labelledby="fig-span-title fig-span-desc" role="img" viewBox="0 0 680 300">
<title id="fig-span-title">两个基向量张成平面</title>
<desc id="fig-span-desc">从原点出发的两个不共线向量，经过任意数乘和相加，可到达它们所张成平面中的任意点。</desc>
<defs>
<marker id="span-arrow-a" markerHeight="6" markerWidth="6" orient="auto-start-reverse" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker>
<marker id="span-arrow-s" markerHeight="6" markerWidth="6" orient="auto-start-reverse" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--sage)"></path></marker>
</defs>
<path class="diagram-fill-sage" d="M92 238 L360 238 L582 74 L314 74 Z"></path>
<g opacity=".72">
<line class="diagram-grid" x1="92" x2="314" y1="238" y2="74"></line><line class="diagram-grid" x1="181" x2="403" y1="238" y2="74"></line>
<line class="diagram-grid" x1="270" x2="492" y1="238" y2="74"></line><line class="diagram-grid" x1="360" x2="582" y1="238" y2="74"></line>
<line class="diagram-grid" x1="92" x2="360" y1="238" y2="238"></line><line class="diagram-grid" x1="166" x2="434" y1="183" y2="183"></line>
<line class="diagram-grid" x1="240" x2="508" y1="129" y2="129"></line><line class="diagram-grid" x1="314" x2="582" y1="74" y2="74"></line>
</g>
<line class="diagram-accent" marker-end="url(#span-arrow-a)" x1="92" x2="352" y1="238" y2="238"></line>
<line class="diagram-sage" marker-end="url(#span-arrow-s)" x1="92" x2="307" y1="238" y2="80"></line>
<line class="diagram-muted" x1="352" x2="563" y1="238" y2="84"></line><line class="diagram-muted" x1="307" x2="563" y1="80" y2="84"></line>
<circle cx="563" cy="84" fill="var(--ink)" r="5"></circle>
<text class="diagram-mono" x="207" y="262">c₁α₁</text><text class="diagram-mono" x="153" y="130">c₂α₂</text>
<text class="diagram-text" x="432" y="58">相加后的向量 α</text>
<text class="diagram-note" x="398" y="272">系数取遍数域 → 张成整个平面</text>
</svg>
<figcaption id="fig-span-caption"><b>线性组合的几何读法：</b>先沿第一个方向走 $c_1$ 倍，再沿第二个方向走 $c_2$ 倍；所有可到达的终点构成 $\operatorname{span}(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2)$。</figcaption>
</figure>

这里有两件事要记住。其一，$\boldsymbol{\theta}$ 可由任何向量组线性表示，取 $k_1=\cdots=k_n=0$ 即可，称为**平凡表示**。其二，定义并不要求系数唯一——唯一性何时成立，是 [1.3](sec13.md) 节[@thm-1.3.1] 要回答的问题。向量未必是数组，「表示」也就未必等于解方程组：下面的例子发生在矩阵空间里。

::: ex 例 1.1.5 · 矩阵的线性表示 {#ex-1.1.5}

试判断矩阵 $A^2$ 是否可以由 $A$ 和 $I$ 线性表示，其中 $A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$。

::: sol 解答

先算出 $A^2$，再用**待定系数法**找表示式：设 $A^2=xA+yI$（$x,y\in\mathbb{R}$），比较对应元素定出系数。

$$A^2=\begin{pmatrix}1&1\\0&1\end{pmatrix}\begin{pmatrix}1&1\\0&1\end{pmatrix}=\begin{pmatrix}1&2\\0&1\end{pmatrix},\qquad xA+yI=\begin{pmatrix}x+y&x\\0&x+y\end{pmatrix}.$$

比较得 $x=2$（看 $(1,2)$ 元），$x+y=1$ 即 $y=-1$（看对角元）。代回验证：

$$2A-I=\begin{pmatrix}2&2\\0&2\end{pmatrix}-\begin{pmatrix}1&0\\0&1\end{pmatrix}=\begin{pmatrix}1&2\\0&1\end{pmatrix}=A^2 .$$

因此 $A^2$ 可以由 $A$、$I$ 线性表示，表示式为 $A^2=2\cdot A+(-1)\cdot I$。

:::

:::

::: think 思考 · $A^3$、$A^k$ 与任意方阵的 $A^n$（含勘误 E1）

**第一层。**$A^3$ 能由 $A,I$ 表示吗？课件在此处写成 $A^3=A(2A-I)=5A-2I$，属于笔误（勘误 E1）。由 $A^3=A(2A-I)=2A^2-A=2(2A-I)-A$，正确结果是

$$A^3=3A-2I\qquad\Big(\text{直接验证：}A^3=\begin{pmatrix}1&3\\0&1\end{pmatrix}=3\begin{pmatrix}1&1\\0&1\end{pmatrix}-\begin{pmatrix}2&0\\0&2\end{pmatrix}\Big).$$

**第二层。**对任意自然数 $k$，$A^k$ 总可由 $A,I$ 线性表示，且

$$A^k=kA-(k-1)I,\qquad k=1,2,3,\cdots$$

对 $k$ 归纳：$k=1$ 时 $A^1=1\cdot A-0\cdot I$ 成立；设 $A^k=kA-(k-1)I$，则

$$A^{k+1}=A\cdot A^k=kA^2-(k-1)A=k(2A-I)-(k-1)A=(k+1)A-kI,$$

命题对 $k+1$ 成立。也就是说，$k$ 再大，$A^k$ 也始终留在由 $A$ 与 $I$ 张成的集合里。

**第三层。**任意方阵 $A^n$ 是否可以由 $A^{n-1},\cdots,A,I$ 线性表示？**答案：是**，这正是著名结论「任意 $n$ 阶方阵满足自己的特征方程」的直接推论。

:::

::: preview 课程预告

「任意 $n$ 阶方阵 $A$ 都满足一个由它自己决定的 $n$ 次多项式方程（特征方程），从而 $A^n$ 必可写成 $A^{n-1},\cdots,A,I$ 的线性组合」——这一结论称为 **Cayley–Hamilton 定理**，完整证明见[附录 A.5](../appendix/appendix-a.md#sec-A.5)。本讲只要求：对具体的 $2\times2$ 矩阵能亲手验证（习题 C7），从而体会「表示」的含义。

:::

<a id="sec-1.1.7"></a>

## 1.1.7 常见的线性空间（例 1.1.4 全收录）

下列例子今后反复引用，需要逐个确认「元素是什么、数域是什么、运算是什么」。它们说明：线性空间的元素完全不必是「数组」。

::: ex 例 1.1.4 · 常见的线性空间 {#ex-1.1.4}

**（1）向量空间 $\mathbb{R}^n$（$n\geq1$）**是线性空间：按分量加法与数乘后仍得到 $n$ 个实数，故封闭；八条公理逐分量退化为实数的交换律、结合律和分配律等规则。

**（2）复矩阵空间 $\mathbb{C}^{m\times n}$：**设 $V$ 为 $\mathbb{C}$ 上所有 $m\times n$ 矩阵构成的集合，即 $V=\{(a_{ij})_{m\times n}\mid a_{ij}\in\mathbb{C}\}$。在矩阵加法和数乘运算下，$V$ 构成 $\mathbb{C}$ 上的线性空间，称为复矩阵空间，记为 $\mathbb{C}^{m\times n}$。类似地可定义实矩阵空间 $\mathbb{R}^{m\times n}$。**「向量」在这里是一个矩阵。**

**（3）多项式空间 $P_n(x)$：**一元多项式集合

$$P_n(x)=\left\{\sum_{i=0}^{n}a_ix^i\ \middle|\ a_i\in\mathbb{C}\right\}$$

（次数不超过 $n$ 的多项式连同零多项式）在多项式加法与数乘下构成 $\mathbb{C}$ 上的线性空间，称为多项式空间。**「向量」在这里是一个多项式。**要小心的是「次数恰好等于 $n$ 的多项式」全体，它**不是**线性空间——不含零多项式，两个 $n$ 次多项式相加还可能降次（如 $x^n+(-x^n+1)=1$）。

**（4）函数空间链：**在区间 $[a,b]$ 上分别取全体多项式集合 $S_1$、全体可微函数集合 $S_2$、全体连续函数集合 $S_3$、全体可积函数集合 $S_4$、全体函数集合 $S_5$，则

$$S_1\subset S_2\subset S_3\subset S_4\subset S_5,$$

且这五个集合均为 $\mathbb{R}$ 上的线性空间（两个可微函数的和、数乘仍可微；连续、可积同理）。

**（5）离散时间信号空间 $S$：**设 $S$ 是所有双边序列的集合，其中双边序列 $\{x_k\}$ 形如 $\{x_k\mid x_k\in\mathbb{R},\ k=0,\pm1,\pm2,\cdots\}$。定义序列的和 $\{x_k\}+\{y_k\}=\{x_k+y_k\}$ 与数乘 $c\{x_k\}=\{cx_k\}$（逐项运算），则 $S$ 是 $\mathbb{R}$ 上的线性空间，称为离散时间信号空间。**「向量」在这里是一整个信号。**

:::

| 空间 | 「向量」是…… | 数域 | 维数（[1.3](sec13.md) 节揭晓） |
|:--|:--|:--|:--|
| $\mathbb{R}^n$ | $n$ 元有序数组 | $\mathbb{R}$ | $n$ |
| $\mathbb{C}^{m\times n}$ | $m\times n$ 复矩阵 | $\mathbb{C}$ | $mn$ |
| $P_n(x)$ | 次数 $\leq n$ 的多项式 | $\mathbb{C}$ | $n+1$ |
| $S_1\subset\cdots\subset S_5$ | $[a,b]$ 上的函数 | $\mathbb{R}$ | 均为无限维（见 [1.3.8](sec13.md#sec-1.3.8) 注 3） |
| $\mathbb{R}$ 上的 $P_n(x)$ | 次数 $\leq n$ 的**实**系数多项式 | $\mathbb{R}$ | $n+1$（是上表 $S_1$ 的子空间——**同数域**才谈得上子空间） |
| 信号空间 $S$ | 双边序列 $\{x_k\}$ | $\mathbb{R}$ | 无限维（[@ex-1.3.4]） |

表中两处值得停顿：第 5 行说明 $\mathbb{R}$ 上的 $P_n(x)$ 与 $\mathbb{C}$ 上的 $P_n(x)$ 是两个不同的空间——**子空间只在同一数域内比较**；最后一行说明线性空间可以没有有限维数。维数那一列的来历，[1.3](sec13.md) 节给出算法。

<a id="sec-1.1.8"></a>

## 1.1.8 例题精讲：新定义运算下的判定（含例 1.1.3）

当运算不是「天然的」而是**重新定义**的，就不能只查封闭性，必须回到八条公理逐条验证——特别是零元素、负元素会「改头换面」。

::: ex 例 1.1.3 · $\mathbb{R}^+$ 上的非常规运算 {#ex-1.1.3}

设 $V=\mathbb{R}^+$（正实数全体），$F=\mathbb{R}$，定义 $V$ 中加法运算为 $x\oplus y=xy$，定义 $V$ 中元素与 $F$ 中数的数乘为 $k\cdot x=x^k$。证明 $(V,\oplus,\cdot)$ 是实线性空间。

::: proof 证

**封闭性：**$\forall x,y\in V$ 和 $k\in F$，有 $x\oplus y=xy\in V$（正数之积为正）和 $k\cdot x=x^k\in V$（正数的任意实数次幂为正）。

**再逐条验证八条性质。**加法四条：

（1）交换律：$x\oplus y=xy=yx=y\oplus x$；

（2）结合律：$(x\oplus y)\oplus z=(xy)z=x(yz)=x\oplus(y\oplus z)$；

（3）**零元素是 $1$**：$\exists\,1\in V$ 使得 $\forall x\in V,\ x\oplus1=x\cdot1=x$；

（4）**负元素是倒数**：$\forall x\in V,\ \exists\,x^{-1}\in V$ 使得 $x\oplus x^{-1}=x\cdot x^{-1}=1$（加法零元）。

数乘四条（$\forall k,l\in F$，$x,y\in V$）：

（5）$k\cdot(x\oplus y)=(xy)^k=x^ky^k=(k\cdot x)\oplus(k\cdot y)$；

（6）$(k+l)\cdot x=x^{k+l}=x^kx^l=(k\cdot x)\oplus(l\cdot x)$；

（7）$k\cdot(l\cdot x)=(x^l)^k=x^{lk}=x^{kl}=(kl)\cdot x$；

（8）$1\cdot x=x^1=x$。

八条全部成立，故 $(V,\oplus,\cdot)$ 是实线性空间。

:::

::: note

**为什么会这样？**取对数来看：$x\oplus y=xy$ 就是 $\lg x+\lg y$，$k\cdot x=x^k$ 就是 $k\lg x$。这个空间与 $\mathbb{R}$（普通加法与数乘）通过 $\lg$ 一一对应，八条公理原封不动地照搬即可。「换个运算，零元就换了人」，是本题最值得记住的一点。

:::

:::

下面四题都只要找出**一条**被破坏的规则，难的是说准是哪一条。

::: ex 例 1.1.B · 判定题组 {#ex-1.1.B}

判断下列 $(V,F)$ 配上所指运算是否构成线性空间，并说明理由：

(1) $V=\mathbb{R}^+$，$F=\mathbb{R}$，普通加法 $x+y$ 与普通数乘 $kx$；

(2) $V=\{n$ 阶可逆矩阵全体$\}\subset\mathbb{R}^{n\times n}$，$F=\mathbb{R}$，矩阵加法与数乘；

(3) $V=\{n$ 阶正交矩阵全体$\}$，$F=\mathbb{R}$，矩阵加法与数乘；

(4) $V=\mathbb{Q}^n$（分量全为有理数的 $n$ 维向量全体），$F=\mathbb{R}$，普通加法与数乘。

::: sol 解答

**(1) 不是。**数乘不封闭：$x\in V$，$0\cdot x=0\notin\mathbb{R}^+$。也可说：$V$ 不含「普通加法」的零元 $0$。

**(2) 不是。**$0\cdot A=O$（零矩阵）不可逆，故数乘不封闭；$V$ 也不含零矩阵。（加法也不封闭：$A+(-A)=O$。）

**(3) 不是。**正交矩阵 $Q$ 满足 $Q^{\mathrm T}Q=I$，则 $(kQ)^{\mathrm T}(kQ)=k^2I$，当 $k^2\neq1$ 时 $kQ$ 不是正交矩阵——数乘不封闭。（正交矩阵全体对乘法封闭，但这里讨论的是线性运算。）

**(4) 不是。**数乘的「数」必须来自 $F=\mathbb{R}$：取 $\boldsymbol{\alpha}=(1,0,\cdots,0)^{\mathrm T}\in V$，$\sqrt2\,\boldsymbol{\alpha}=(\sqrt2,0,\cdots,0)^{\mathrm T}\notin V$。若改取 $F=\mathbb{Q}$，则 $\mathbb{Q}^n$ 是 $\mathbb{Q}$ 上的线性空间——**「在哪个数域上」是判定的一部分**。

:::

:::

<a id="sec-1.1.9"></a>

## 1.1.9 小结与常见错误

**小结。**① 线性空间的定义（八条公理）与性质（注 1 四条）；② 线性空间的例子（$\mathbb{R}^n$、矩阵、多项式、函数、信号）；③ 线性空间的判定（否定找反例，肯定验任意元素；新运算验八条）。三件事串成一条链：公理定义对象，例子划出边界，判定把它认出来——下一节 [1.2](sec12.md) 讨论子空间，用的正是这条链。

::: errata 常见错误清单（1.1 节）

E-a **只验封闭性就下肯定结论（运算是新定义时）。**新运算必须验八条公理；零元素可能不是 $\boldsymbol{\theta}$（[@ex-1.1.3] 中是 $1$）。

E-b **验证时只代具体数值。**如「$2(1,1)=(2,2)\in V$ 所以数乘封闭」——必须对任意 $k$、任意元素论证。

E-c **把「数域」默认成 $\mathbb{R}$。**同一集合换数域结论会变（[@ex-1.1.B]（4）、[@ex-1.3.1]、[@ex-1.3.5]）。

E-d **认为「对加法封闭」就够。**反例：$\{(a_1,a_2)\mid a_1\geq0\}$（[@ex-1.1.A]（3））。

E-e **把「次数恰为 $n$」当作 $P_n(x)$。**多项式空间必须含零多项式与低次多项式（[@ex-1.1.4]（3））。

E-f **满足七条公理就当作线性空间。**数乘恒为零的反例满足其余七条（见 [1.1.4](sec11.md#sec-1.1.4) 思考框）。

:::

::: method 即时自测 · 1.1

先自行作答，再展开核对。

::: hint 第 1 题 · 记忆

不看正文，写出线性空间八条公理中**数乘的四条**。（对应 [1.1.4](sec11.md#sec-1.1.4)）
:::

::: sol 第 1 题答案

① $\lambda(\boldsymbol{\alpha}+\boldsymbol{\beta})=\lambda\boldsymbol{\alpha}+\lambda\boldsymbol{\beta}$；② $(\lambda+\mu)\boldsymbol{\alpha}=\lambda\boldsymbol{\alpha}+\mu\boldsymbol{\alpha}$；③ $(\lambda\mu)\boldsymbol{\alpha}=\lambda(\mu\boldsymbol{\alpha})$；④ $1\boldsymbol{\alpha}=\boldsymbol{\alpha}$。
若漏掉的是 ④，请回到 [1.1.4](sec11.md#sec-1.1.4) 重读那个反例——它是唯一不能由其余条款推出的。
:::

::: hint 第 2 题 · 辨析

「$V$ 的非空子集 $W$ 对加法封闭，所以 $W$ 是线性空间」——这句话对吗？错在哪？（对应 [1.1.9](sec11.md#sec-1.1.9)）
:::

::: sol 第 2 题答案

**不对。**加法封闭不蕴含数乘封闭，也不保证含零元。反例见 [@ex-1.1.A] 的 (3)：$V_5=\{(a_1,a_2)^{\mathrm T}\mid a_1\geq0\}$ 对加法封闭，但 $(-1)\cdot(1,0)^{\mathrm T}\notin V_5$。
:::

::: hint 第 3 题 · 应用

设 $V=\mathbb{R}^+$，定义 $x\oplus y=\dfrac{xy}{2}$，$k\cdot x=\dfrac{x^k}{2^{k-1}}$。$V$ 是 $\mathbb{R}$ 上的线性空间吗？先说说你第一步会查什么。（对应 [1.1.8](sec11.md#sec-1.1.8)）
:::

::: sol 第 3 题答案

**是。**思路与 [@ex-1.1.3] 完全同构：注意 $\dfrac{xy}{2}=2\cdot\dfrac x2\cdot\dfrac y2$，令 $u=\lg(x/2)$ 即可看出它与 $\mathbb{R}$ 的普通加法数乘一一对应，八条公理同样成立。

**判定的入手点。**新定义运算时不能只查封闭性，应先找零元与负元——它们往往改头换面（本题零元是 $2$，负元是 $4/x$）。找到之后，其余公理通常容易验证。
:::

::: hint 第 4 题 · 迁移

举出一个线性空间，它的「向量」不是数组、不是多项式、也不是函数。（对应 [1.1.7](sec11.md#sec-1.1.7)）
:::

::: sol 第 4 题答案

**离散时间信号空间 $S$**：元素是双边序列 $\{x_k\}$，加法与数乘逐项定义。此外 $\mathbb{C}^{m\times n}$（向量是矩阵）也符合要求。

**换个角度。**线性空间可以是数组、矩阵、多项式、函数或信号——它是公理系统，而不是某一种具体的集合。
:::

:::
