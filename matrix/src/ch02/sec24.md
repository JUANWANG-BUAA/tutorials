# 2.4 特征值与特征向量

2.3 结尾留下一个问题：什么样的基最简单？答案是让矩阵变成**对角形**的那种基。可要找它，先得回答：哪个基向量 $\boldsymbol{\xi}$ 被 $T$ 作用后**方向不变**，只是被拉伸成 $T(\boldsymbol{\xi})=\lambda\boldsymbol{\xi}$？这就是特征值问题。本节的一切都架在一座「桥」上：**线性变换 $T$ 在基下的矩阵为 $A$ 时，$T$ 的特征值就是 $A$ 的特征值，$T$ 的特征向量就是「$A$ 的特征向量这组坐标乘回基」**。有了它，抽象变换的特征问题就完全落地为矩阵计算——而矩阵这部分你在先修课已经练熟。真正的新知识是**特征子空间**：它是 $A-\lambda I$ 的零空间，把 2.2 的亏加秩定理直接接了过来，并引出日后判断「能否对角化」的关键一对量：**几何重数 ≤ 代数重数**。

::: note 素材与说明

本页依据**第 5 周星期 4 第 6,7 节录播**（2026-10-08，王振乾，1:39:09，第 5 周转录稿 00:15:17–00:32:32）整理。该讲官方课件尚未入库（归档中只有 2.1–2.3），故本页**不沿用课件编号**，盒子一律自动编号；课堂口述在正文标注时间戳。老师明确说明特征值的基本求法与迹 / 行列式等性质「我们都在先修课里学过，不再讲解」（00:23:35），本页把这部分压缩为盘点，重心放在**线性变换视角**与**特征子空间**这两个新量上。录播 ASR 错字较多（「特征向量→特定象征」「Jordan 块→阶梁块」「代数重数→代废乘数」等），见 [overview 的素材说明](overview.md)。
:::

<a id="sec-2.4.1"></a>


{{#include ../assets/figures/matrix-eigen.md}}

## 2.4.1 从矩阵到线性变换：特征对的翻译

先修课里，特征值是对**方阵**定义的；现在把它原样搬到**线性变换**上——只把「乘矩阵」换成「作变换」。

::: def 特征值与特征向量（矩阵，先修回顾）{#def-eig-matrix}

设 $A\in\mathbb{C}^{n\times n}$。若存在数 $\lambda$ 与非零向量 $\boldsymbol{x}\in\mathbb{C}^{n}$ 使

$$A\boldsymbol{x}=\lambda\boldsymbol{x},$$

则称 $\lambda$ 为 $A$ 的**特征值**，$\boldsymbol{x}$ 为 $A$ 的属于 $\lambda$ 的**特征向量**。$\det(\lambda I-A)$ 称为 $A$ 的**特征多项式**，特征值即其根。
:::

::: def 线性变换的特征值与特征向量 {#def-eig-transform}

设 $T$ 是数域 $F$ 上线性空间 $V$ 的线性变换。若存在数 $\lambda\in F$ 与非零向量 $\boldsymbol{\xi}\in V$ 使

$$T(\boldsymbol{\xi})=\lambda\boldsymbol{\xi},$$

则称 $\lambda$ 为 $T$ 的**特征值**，$\boldsymbol{\xi}$ 为 $T$ 的属于 $\lambda$ 的**特征向量**。
:::

两个定义写法平行，向量所在的空间却不同：$A$ 的特征向量是 $\mathbb{C}^n$ 里的**坐标列**，$T$ 的特征向量是 $V$ 里的**向量**。桥梁由「取基」架起：

::: thm 特征对的翻译定理 {#thm-eig-bridge}

设 $V$ 是数域 $F$ 上的 $n$ 维线性空间，$\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n$ 是 $V$ 的一组基，线性变换 $T$ 在这组基下的矩阵为 $A$。则：

1. $\lambda$ 是 $T$ 的特征值 $\iff$ $\lambda$ 是 $A$ 的特征值；
2. $\boldsymbol{\xi}=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\boldsymbol{\alpha}$ 是 $T$ 的属于 $\lambda$ 的特征向量 $\iff$ 坐标列 $\boldsymbol{\alpha}$ 是 $A$ 的属于 $\lambda$ 的特征向量。
:::

::: proof

只证第 2 条（第 1 条随之成立）。由坐标公式（[@thm-2.3.4]），对任意 $\boldsymbol{\xi}=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\boldsymbol{\alpha}$，

$$T(\boldsymbol{\xi})=T\big[(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\boldsymbol{\alpha}\big]=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\,A\boldsymbol{\alpha},$$

其中用到 $T$ 保持线性组合（[@thm-2.2.1]）。于是

$$T(\boldsymbol{\xi})=\lambda\boldsymbol{\xi}\iff(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)A\boldsymbol{\alpha}=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\lambda\boldsymbol{\alpha}\iff A\boldsymbol{\alpha}=\lambda\boldsymbol{\alpha},$$

最后一步是因为**同一组基下的坐标唯一**（基的线性无关性）：向量非零当且仅当坐标非零，故得证。
:::

翻译定理落到操作层面，就是老师当堂反复交代的一句话（00:21:44–00:22:47）：

::: method 求线性变换特征对的流程（考试必查最后一行）{#method-eig-procedure}

1. 写出 $T$ 在给定基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n$ 下的矩阵 $A$（第 $j$ 列 $=T(\boldsymbol{\varepsilon}_j)$ 的坐标，[@def-2.3.1]）；
2. 解特征方程 $\det(\lambda I-A)=0$ 得特征值——**这既是 $A$ 的、也是 $T$ 的特征值**；
3. 对每个 $\lambda$，解 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$ 得基础解系 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_s$；
4. **乘回基**：$T$ 的特征向量是 $\boldsymbol{\xi}_k=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\boldsymbol{\alpha}_k$（同一特征值对应的解空间中，非零线性组合仍为特征向量）。

> 老师原话：「矩阵 $A$ 的特征向量……其实是线性变换特征向量的**坐标**……我们还要用这个坐标去**乘以我们所考虑的那一组基**，然后才能完成整个计算过程」（00:22:29–00:22:45）。**漏掉第 4 步、把坐标列当成 $V$ 中的向量交卷，是本节最高频的错误。**
:::

::: ex 例 · 给基与矩阵，求 $T$ 的特征对 {#ex-eig-basic}

设 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 是 $V$ 的一组基，$T\in L(V)$ 在这组基下的矩阵

$$A=\begin{bmatrix}3&1\\0&2\end{bmatrix}.$$

求 $T$ 的特征值与特征向量。

::: sol

特征多项式 $\det(\lambda I-A)=(\lambda-3)(\lambda-2)$，故 $T$ 的特征值为 $\lambda_1=3,\ \lambda_2=2$。

- $\lambda_1=3$：$(A-3I)\boldsymbol{x}=\boldsymbol{0}$ 即 $\begin{bmatrix}0&1\\0&-1\end{bmatrix}\boldsymbol{x}=\boldsymbol{0}$，基础解系 $\boldsymbol{\alpha}_1=(1,0)^{\mathrm T}$。乘回基：$T$ 的属于 $3$ 的特征向量为 $\boldsymbol{\xi}=k_1\boldsymbol{\varepsilon}_1$（$k_1\neq0$）。
- $\lambda_2=2$：$(A-2I)\boldsymbol{x}=\boldsymbol{0}$ 即 $\begin{bmatrix}1&1\\0&0\end{bmatrix}\boldsymbol{x}=\boldsymbol{0}$，基础解系 $\boldsymbol{\alpha}_2=(1,-1)^{\mathrm T}$。乘回基：$T$ 的属于 $2$ 的特征向量为 $\boldsymbol{\xi}=k_2(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)$（$k_2\neq0$）。

最后交卷的形态也值得留意：**特征向量必须用 $\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2$ 这样的 $V$ 中向量表述**，写成 $(1,-1)^{\mathrm T}$ 只完成了前 3 步。∎
:::
:::

<a id="sec-2.4.2"></a>

## 2.4.2 特征值的整体性质：盘点与提醒

有了翻译定理，特征值的问题从此只在矩阵 $A$ 上讨论。下面这些整体性质先修课都已证明，课堂只是「简单过一下」（00:23:05–00:24:01、00:31:48–00:32:32），这里把它们汇成一张**考场上直接引用**的清单。先看两个最常用的量——它们把 $A$ 的迹与行列式直接翻译成特征值的运算：

::: thm 迹、行列式与特征值 {#thm-eig-trace}

设 $A\in\mathbb{C}^{n\times n}$ 的全部特征值为 $\lambda_1,\cdots,\lambda_n$（按代数重数重复计入），则

$$\operatorname{tr}A=\lambda_1+\cdots+\lambda_n,\qquad \det A=\lambda_1\lambda_2\cdots\lambda_n .$$

（系数对照的完整证明——只用到行列式展开与根与系数的关系——见[附录 A.3](../appendix/appendix-a.md#sec-A.3)。）
:::

由 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 出发，让 $A$ 去做幂、做多项式、求逆，$\lambda$ 会跟着做同样的运算：

::: thm 幂与逆的特征值 {#thm-eig-power}

设 $A\in\mathbb{C}^{n\times n}$ 有特征对 $(\lambda,\boldsymbol{x})$，则：

1. 对任意正整数 $k$，$(\lambda^k,\boldsymbol{x})$ 是 $A^k$ 的特征对；一般地，对任意多项式 $f$，$(f(\lambda),\boldsymbol{x})$ 是 $f(A)$ 的特征对；
2. 若 $A$ 可逆，则 $\lambda\neq0$，且 $(\lambda^{-1},\boldsymbol{x})$ 是 $A^{-1}$ 的特征对。
:::

::: proof 证

**1.** 先对 $k$ 归纳证 $A^k\boldsymbol{x}=\lambda^k\boldsymbol{x}$：$k=1$ 即条件；设 $A^k\boldsymbol{x}=\lambda^k\boldsymbol{x}$，则

$$A^{k+1}\boldsymbol{x}=A(A^k\boldsymbol{x})=A(\lambda^k\boldsymbol{x})=\lambda^kA\boldsymbol{x}=\lambda^{k+1}\boldsymbol{x}.$$

再由 $A$ 保持线性组合（$A(c\boldsymbol{u}+d\boldsymbol{v})=cA\boldsymbol{u}+dA\boldsymbol{v}$），对 $f(t)=\sum_j c_jt^j$ 逐项作用：

$$f(A)\boldsymbol{x}=\sum_j c_jA^j\boldsymbol{x}=\sum_j c_j\lambda^j\boldsymbol{x}=f(\lambda)\boldsymbol{x}.$$

**2.** 若 $\lambda=0$，则 $A\boldsymbol{x}=\boldsymbol{0}$ 有非零解，$A$ 不可逆，矛盾，故 $\lambda\neq0$。对 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 两边左乘 $A^{-1}$ 并除以 $\lambda$：

$$A^{-1}\boldsymbol{x}=\frac{1}{\lambda}\boldsymbol{x}.\qquad\blacksquare$$
:::

以上几条说的都是固定的 $A$。一旦换基，$A$ 变成 $P^{-1}AP$，哪些量跟着变、哪些不变？这决定了什么才算**变换自身**的性质：

::: thm 相似不变量 {#thm-sim-invariants}

设 $A\sim B$（即存在可逆 $P$ 使 $B=P^{-1}AP$，见 [@cor-2.3.4]），则 $A$ 与 $B$ 有相同的特征多项式，从而有相同的特征值（含重数）、相同的迹、相同的行列式；并且 $\operatorname{rank}B=\operatorname{rank}A$。

> 相似是「同一个线性变换换基」的矩阵语言（[@thm-2.3.5]），所以这些量都是**线性变换自身**的量，不依赖基的选取——这正是它们重要的原因。
:::

::: proof 证

**特征多项式**：利用行列式对可逆因子的「两边夹」（$\det P^{-1}\det P=1$），

$$\det(\lambda I-B)=\det\big(\lambda P^{-1}P-P^{-1}AP\big)=\det\big(P^{-1}(\lambda I-A)P\big)=\det(P^{-1})\det(\lambda I-A)\det(P)=\det(\lambda I-A).$$

特征值（含重数）由特征多项式唯一决定，故相同。**迹**：由 $\operatorname{tr}(XY)=\operatorname{tr}(YX)$（先修知识，乘积循环不改变迹），

$$\operatorname{tr}B=\operatorname{tr}(P^{-1}AP)=\operatorname{tr}\big((AP)\cdot P^{-1}\big)=\operatorname{tr}\big(A(PP^{-1})\big)=\operatorname{tr}A .$$

**行列式**：$\det B=\det(P^{-1})\det A\det P=\det A$。**秩**：$B=P^{-1}\cdot A\cdot P$ 是三个矩阵的乘积，中间夹着的两个可逆矩阵不改变秩（先修知识：可逆矩阵乘法不改变秩）。∎
:::

最后补上一条关于特征向量独立性的结论——后面论证「能否对角化」时，靠的正是它：

::: thm 不同特征值的特征向量线性无关 {#thm-eig-independent}

设 $\lambda_1,\cdots,\lambda_s$ 是 $A$（或 $T$）的**互不相同**的特征值，$\boldsymbol{x}_1,\cdots,\boldsymbol{x}_s$ 是分别属于它们的特征向量，则 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_s$ 线性无关。
:::

::: proof 证（对 $s$ 归纳）

$s=1$ 时单个非零向量（特征向量非零）线性无关。设结论对 $s-1$ 个互异特征值成立。考察

$$k_1\boldsymbol{x}_1+\cdots+k_s\boldsymbol{x}_s=\boldsymbol{0}.\tag{*}$$

两边作用 $A$，并用 $A\boldsymbol{x}_i=\lambda_i\boldsymbol{x}_i$：

$$k_1\lambda_1\boldsymbol{x}_1+\cdots+k_s\lambda_s\boldsymbol{x}_s=\boldsymbol{0}.\tag{**}$$

再以 $\lambda_s$ 乘 $(*)$ 后与 $(**)$ 相减，$\boldsymbol{x}_s$ 一项被消去：

$$k_1(\lambda_1-\lambda_s)\boldsymbol{x}_1+\cdots+k_{s-1}(\lambda_{s-1}-\lambda_s)\boldsymbol{x}_{s-1}=\boldsymbol{0}.$$

由归纳假设，$\boldsymbol{x}_1,\cdots,\boldsymbol{x}_{s-1}$ 线性无关，故每个系数为零：$k_i(\lambda_i-\lambda_s)=0$；而 $\lambda_i\neq\lambda_s$（$i\lt s$），得 $k_1=\cdots=k_{s-1}=0$。代回 $(*)$ 得 $k_s\boldsymbol{x}_s=\boldsymbol{0}$，而 $\boldsymbol{x}_s\neq\boldsymbol{0}$，故 $k_s=0$。全部系数为零，命题对 $s$ 成立。∎
:::

以上都是代数层面的结论；几何上，$A$ 对特征方向只做拉伸。下面的部件让你亲手把这类方向拖出来。

<a id="sec-2.4.3"></a>

<div class="widget" data-widget="eigen">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">拖出一个特征方向</strong></p>
<p class="widget-hint">拖动向量 $\boldsymbol{v}$，读数里给出 $|\sin\angle(\boldsymbol{v},A\boldsymbol{v})|$。当它变成 $0$，$A\boldsymbol{v}$ 与 $\boldsymbol{v}$ 共线——此刻 $\boldsymbol{v}$ 落在特征方向上，绿色虚线标出的就是这些方向。</p>
</div>

## 2.4.3 特征子空间：几何重数与代数重数

属于同一个 $\lambda$ 的**全体**特征向量，再加上零向量，恰好构成一个子空间。这一步把「$\lambda$ 对应哪些方向」从一堆孤立的向量，升级成一块有维数的空间——维数本身就成了可算的量。

::: def 特征子空间 {#def-eigenspace}

设 $A\in\mathbb{C}^{n\times n}$，$\lambda$ 是 $A$ 的特征值。称

$$V_\lambda=\{\boldsymbol{x}\in\mathbb{C}^{n}\mid A\boldsymbol{x}=\lambda\boldsymbol{x}\}=\{\boldsymbol{x}\mid(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}\}=N(A-\lambda I)$$

为 $A$ 的属于 $\lambda$ 的**特征子空间**。称 $\dim V_\lambda$ 为 $\lambda$ 的**几何重数**；称 $\lambda$ 作为特征多项式根的重数为**代数重数**。
:::

定义里真正有用的是那个等号 $V_\lambda=N(A-\lambda I)$：它把 2.2 的零空间工具直接接了过来（00:25:01–00:25:38）。至于 $V_\lambda$ 本身确实是子空间，验证只用一行——含 $\boldsymbol{0}$、对加法与数乘封闭（00:25:42–00:26:10）：

::: thm 几何重数的计算 {#thm-geom-mult}

$$\dim V_\lambda=\dim N(A-\lambda I)=n-\operatorname{rank}(A-\lambda I).$$
:::

::: proof

$A-\lambda I$ 是 $n$ 阶方阵，对其零空间用亏加秩定理（[@thm-2.2.5]）即得。
:::

::: thm 重数不等式 {#thm-mult-ineq}

设 $\lambda$ 是 $A\in\mathbb{C}^{n\times n}$ 的特征值，则

$$1\ \le\ \dim V_\lambda\ \le\ \text{$\lambda$ 的代数重数}.$$

左端来自「特征向量非零」，故 $V_\lambda$ 至少一维；右端这条不等式先当事实用——老师课堂上的说法是「我们都知道几何重数不能超过代数重数」（00:26:25–00:26:31）。它的完整证明其实并不需要谱理论，只用「取特征子空间的基并扩充」一步，见[附录 A.4](../appendix/appendix-a.md#sec-A.4)。
:::

重数不等式的两端能否取等，才是判断对角化的关键。下面这道例题正是为此准备的（00:26:38 起，老师说「同学们都已经遇到过」）：三个矩阵的特征多项式完全相同，几何重数却各不相同——**特征多项式并没有包含特征结构的全部信息**。

::: ex 经典三矩阵：同一特征多项式，三种几何重数 {#ex-jordan-three}

设

$$J_1=\begin{bmatrix}1&&\\&1&\\&&1\end{bmatrix},\qquad
J_2=\begin{bmatrix}1&1&\\&1&\\&&1\end{bmatrix},\qquad
J_3=\begin{bmatrix}1&1&\\&1&1\\&&1\end{bmatrix}.$$

（$J_2$ 含一个二阶 Jordan 块，$J_3$ 是一个三阶 Jordan 块。）求三者属于 $\lambda=1$ 的特征子空间维数。
::: sol

三者特征多项式都是 $(\lambda-1)^3$：代数重数均为 $3$。几何重数用 [@thm-geom-mult]：

- $J_1-I=O$：零矩阵的零空间是整个 $\mathbb{R}^3$——每个 $(x_1,x_2,x_3)$ 都被映为零向量（00:27:51–00:28:19），故 $\dim V_1=3-0=3$；
- $J_2-I=\begin{bmatrix}0&1&0\\0&0&0\\0&0&0\end{bmatrix}$：方程 $x_2=0$，基础解系 $(1,0,0)^{\mathrm T},(0,0,1)^{\mathrm T}$，故 $\dim V_1=3-1=2$；
- $J_3-I=\begin{bmatrix}0&1&0\\0&0&1\\0&0&0\end{bmatrix}$：方程 $x_2=x_3=0$，基础解系 $(1,0,0)^{\mathrm T}$，故 $\dim V_1=3-2=1$。

三个矩阵的**代数重数**相同、**几何重数** $3>2>1$—— Jordan 块越「长」，特征向量越「少」。老师把这一差别归结成一句话（00:31:27–00:31:46）：几何重数就是 $N(A-\lambda I)$ 的维数。∎
:::
:::

::: note 为什么「几何重数」叫几何的？

$A$ 作为一个映射 $\mathbb{C}^n\to\mathbb{C}^n$，$V_\lambda$ 是「方向被保持（只伸缩）」的向量全体；$\dim V_\lambda$ 数的是这种**独立方向**的个数。 Jordan 块的长度则记录「方向虽不变、但搅进了多少链式结构」——代数重数数根，几何重数数方向。二者相等与否，正是日后「可否对角化」的分水岭。
:::

::: ex 参数只改一个元素，为什么独立特征方向会少一条？

取 $A_t=\begin{pmatrix}1&t&0\\0&1&0\\0&0&2\end{pmatrix}$，$t\in\mathbb R$。无论 $t$ 取什么值，特征多项式总是 $(\lambda-1)^2(\lambda-2)$；但解 $\lambda=1$ 的特征方程得到

$$(A_t-I)\boldsymbol x=0\quad\Longleftrightarrow\quad tx_2=0,\ x_3=0.$$

当 $t=0$，$x_1,x_2$ 都自由，$V_1=\operatorname{span}\{e_1,e_2\}$，几何重数为 $2$；当 $t\ne0$，$x_2$ 被迫为零，只剩 $V_1=\operatorname{span}\{e_1\}$，几何重数为 $1$。而 $V_2=\operatorname{span}\{e_3\}$ 始终只有一维。因此 $t=0$ 时可对角化，$t\ne0$ 时不可对角化。决定答案的是方程组的自由度，不是特征多项式里重复写了几个根。

顺便检验一个易混点：$e_1$ 和 $e_3$ 分别是特征向量，但 $A_t(e_1+e_3)=e_1+2e_3$ 与 $e_1+e_3$ 不成比例。所以「非零线性组合仍是特征向量」只适用于**同一个特征子空间内部**。

**迁移练习。**取 $t=2$，求 $V_1$、$V_2$ 及全部特征向量；若有人列出 $e_1,2e_1,e_3$ 就说凑齐了三条，应指出哪一步错误？

::: sol 核对与回查

$V_1=\operatorname{span}\{e_1\}$、$V_2=\operatorname{span}\{e_3\}$；全部特征向量为 $ae_1$（$a\ne0$）或 $be_3$（$b\ne0$）。$e_1,2e_1$ 相关，三个向量只提供两个独立方向。若把「个数」当作「维数」，回到 [1.3.1](../ch01/sec13.md#sec-1.3.1)；能从自由变量数出维数后，再到 [3.6.1](../ch03/sec36.md#sec-3.6.1) 把它翻译成对角化判据。
:::
:::

<a id="sec-2.4.4"></a>

## 2.4.4 反向考题：设计一组基，使矩阵成为指定形式

2.3 的换基公式 $B=P^{-1}AP$（[@thm-2.3.5]）说的是：**同一个**线性变换，换一组基，矩阵就变一个样。前面两节一直在「给定基、求特征对」，而考题常反过来问——给一个目标形式，要你设计出基来（00:12:45–00:14:17，老师明说这是**上一届考题**的考点）：

::: method 设计基使矩阵为指定形式 {#method-design-basis}

**正向**：已知 $T$ 在基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n$ 下的矩阵 $A$，想找一组新基使 $T$ 的矩阵成为指定形式 $B$（例如对角形）。

1. 判断 / 求出相似变换：$P^{-1}AP=B$，即 $AP=PB$。对角形情形 $B=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$，$P$ 的第 $j$ 列取 $\lambda_j$ 的特征向量（先修课的标准流程）；
2. 新基就是 $\big(\boldsymbol{\varepsilon}'_1,\cdots,\boldsymbol{\varepsilon}'_n\big)=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)P$——**过渡矩阵 $P$ 的列正是新基在旧基下的坐标**（[@def-1.3.5] 的方向）；
3. 验算：$T(\boldsymbol{\varepsilon}'_j)=\lambda_j\boldsymbol{\varepsilon}'_j$。

**考场的变形**（00:14:03–00:14:13）：把上述条件中的某几个改为「未知」，例如给出 $B$ 与新基、反求 $A$ 或 $P$——工具不变，只是把等式 $AP=PB$ 当方程解。「永远运用定理来推导」，不要死记正向流程。
:::

::: ex 例 · 设计一组基，使矩阵成为对角形 {#ex-design-diag}

接[上一节的例题](#ex-eig-basic)：$T$ 在基 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 下的矩阵 $A=\begin{bmatrix}3&1\\0&2\end{bmatrix}$。求一组新基，使 $T$ 在新基下的矩阵为对角形，并写出该对角形。

::: sol

特征值 $3,2$ 互异，特征向量 $\boldsymbol{\varepsilon}_1$（属于 $3$）与 $\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2$（属于 $2$）线性无关，可作新基。取

$$P=\begin{bmatrix}1&1\\0&-1\end{bmatrix},\qquad(\boldsymbol{\varepsilon}'_1,\boldsymbol{\varepsilon}'_2)=(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2)P,$$

即 $\boldsymbol{\varepsilon}'_1=\boldsymbol{\varepsilon}_1,\ \boldsymbol{\varepsilon}'_2=\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2$。则

$$P^{-1}AP=\begin{bmatrix}1&1\\0&-1\end{bmatrix}^{-1}\begin{bmatrix}3&1\\0&2\end{bmatrix}\begin{bmatrix}1&1\\0&-1\end{bmatrix}=\begin{bmatrix}3&0\\0&2\end{bmatrix}.$$

核验第 3 步：$T(\boldsymbol{\varepsilon}'_1)=T(\boldsymbol{\varepsilon}_1)=3\boldsymbol{\varepsilon}_1+0\cdot\boldsymbol{\varepsilon}_2=3\boldsymbol{\varepsilon}'_1$ ✓；$T(\boldsymbol{\varepsilon}'_2)=T(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)=3\boldsymbol{\varepsilon}_1-(\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2)=2(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)=2\boldsymbol{\varepsilon}'_2$ ✓（$T(\boldsymbol{\varepsilon}_2)$ 取 $A$ 的第 2 列 $\begin{bmatrix}1\\2\end{bmatrix}$，故为 $\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2$）。∎
:::
:::

## 2.4 小结与常见错误

::: note 一句话收束

**「矩阵的特征值就是变换的特征值；矩阵的特征向量是变换特征向量的坐标。」** 特征子空间 $V_\lambda=N(A-\lambda I)$ 用亏加秩定理数「被保持的方向」个数（几何重数），特征多项式数「根的重数」（代数重数），恒有 $1\le\dim V_\lambda\le$ 代数重数。
:::

下表把本节最容易失分的地方集中起来，每一条都能在前文找到出处。

| 常见错误 | 正确做法 |
|:--|:--|
| 求出 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$ 的解就直接交卷 | 那只是坐标；**必须乘回基** $\boldsymbol{\xi}=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)\boldsymbol{\alpha}$（[流程](#method-eig-procedure) 第 4 步） |
| 把特征子空间写成「特征向量全体」 | 特征向量全体**不含零向量、不是子空间**；要加回 $\boldsymbol{0}$ 才构成 $V_\lambda$ |
| 混用两种重数 | 几何重数 $=\dim N(A-\lambda I)=n-\operatorname{rank}(A-\lambda I)$；代数重数 $=$ 特征多项式根的重数；判断独立方向的个数只看前者 |
| 认为特征多项式相同 ⟹ 矩阵相似 | [三矩阵例](#ex-jordan-three) 是反例：$(\lambda-1)^3$ 相同，几何重数 $3,2,1$ 各异 |
| 对非方阵谈特征值 | $A$ 必须是 $n$ 阶方阵；对应地 $T$ 必须是**线性变换**（$V\to V$），不是一般线性映射（00:16:11–00:16:16） |

::: think 想一想

1. $T$ 换一组基后，矩阵从 $A$ 变成 $P^{-1}AP$。用 [@thm-sim-invariants] 与 [@thm-eig-bridge] 说明：$T$ 的特征值与 $\dim V_\lambda$ 都不依赖基的选取。那么「特征向量」依赖基吗？
2. [三矩阵例](#ex-jordan-three) 中，$J_2$ 与 $J_3$ 的属于 $\lambda=1$ 的特征子空间分别含哪些向量？它们都是 $\mathbb{R}^3$ 的几维子空间？
3. 若对 $A$ 的**每个**特征值 $\lambda$ 都有 $\dim V_\lambda=$ 代数重数，$A$ 能对角化吗？（结合 [@thm-eig-independent]。）
:::

::: ex 即时自测（不看上文，5 分钟）{#ex-2.4.quiz}

1. 写出「$\lambda$ 是 $T$ 的特征值」的定义，并说明为什么特征向量必须**非零**。
2. 设 $T$ 在基 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 下的矩阵为 $A=\begin{pmatrix}2&1\\0&3\end{pmatrix}$。$A$ 的特征向量是 $\begin{pmatrix}1\\0\end{pmatrix}$ 与 $\begin{pmatrix}1\\1\end{pmatrix}$——$T$ 的特征向量就是它们吗？
3. $A$ 与 $B=P^{-1}AP$ 有哪些量一定相同？哪些**不**一定相同？
4. $A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$：求两种重数，并判断它能否对角化。

::: sol 参考要点

1. 存在**非零**向量 $\boldsymbol{\xi}$ 使 $T\boldsymbol{\xi}=\lambda\boldsymbol{\xi}$。必须非零：若允许 $\boldsymbol{\xi}=\boldsymbol{\theta}$，则对**任意** $\lambda$ 都有 $T\boldsymbol{\theta}=\boldsymbol{\theta}=\lambda\boldsymbol{\theta}$，特征值这个概念就失去意义（[定义](#def-eig-transform)）。
2. 不是。$A$ 的特征向量是**坐标**，$T$ 的特征向量要乘回基：$\boldsymbol{\xi}=(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2)\boldsymbol{\alpha}$。只有基恰好是标准基时两者才数值相同（[流程](#method-eig-procedure) 第 4 步）。
3. 一定相同：特征多项式、特征值（含代数重数）、$\operatorname{tr}A$、$\det A$、$\operatorname{rank}A$、$\dim V_\lambda$（[相似不变量](#thm-sim-invariants)）。不一定相同：特征向量的**坐标**（随基而变）、矩阵的具体元素。
4. $\lambda=1$ 是二重根，故代数重数 $=2$；$A-I=\begin{pmatrix}0&1\\0&0\end{pmatrix}$ 的秩为 $1$，故几何重数 $=2-1=1<2$，**不能**对角化（[重数不等式](#thm-mult-ineq)：几何重数总不超过代数重数，能对角化必须处处取等号）。
:::
:::