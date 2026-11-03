# 4.6 矩阵级数

4.5 的最后一个问题是：「$A^k\to O$ 什么时候成立？」答案是 $\rho(A)\lt1$（[定理 4.6.3](#thm-4.6.3)）。这一节把问题推进一步：不是「$A^k$ 会不会趋于零」，而是**「把无穷多个矩阵加起来，会不会收敛」**。

这个问题的答案是本章最重要的一个公式：

$$(I-A)^{-1}=I+A+A^2+\cdots\qquad(\rho(A)\lt1).$$

它把**逆矩阵**（一个有限的对象）写成**无穷级数**（一个极限的对象）。这一步跨过去之后，矩阵函数才有定义——$e^A$、$\sin A$、$\sqrt{A}$ 全都是「把 $A$ 代进幂级数」，而它们能成立，靠的正是本节建立的两件工具：**范数定量控制收敛**（4.6.1–4.6.4）与**谱半径判定敛散**（4.6.5）。

本节的主线是四级台阶：

1. **序列**（4.6.1–4.6.3）：向量序列与矩阵序列的收敛、三种收敛（按范数 / 按坐标 / 按元素）为什么等价、极限运算的保号性。核心工具是 [定理 4.1.2](sec41.md#thm-4.1.2) 的范数等价。
2. **级数**（4.6.4）：矩阵级数的收敛 ⟺ 各元素数值级数收敛；绝对收敛的三条性质（可重排、可左乘右乘）。
3. **幂级数**（4.6.5）：Abel 型定理——**收敛圆内的谱半径 ⇒ 绝对收敛，圆外的谱半径 ⇒ 发散**；边界 $\rho(A)=r$ 要另算（这是本节最容易丢分的地方）。
4. **Neumann 级数**（4.6.5 末）：$\rho(A)\lt1\iff\sum A^m$ 收敛，且和为 $(I-A)^{-1}$。它就是 [定理 4.3.6](sec43.md#thm-4.3.6) 的「不可改进版」。

一句话概括：**4.6 把「矩阵能不能求逆」变成「谱半径够不够小」，再把「谱半径够不够小」交给 4.5 的工具去判。**

::: note 素材与说明（本节无录播）

本页依据课程第四章课件第二分册（`_sources/matrix/2-矩阵理论-第四章2.pdf`，70 页，文字版）的 4.6 节（第 37–70 页）整理，并与教材《矩阵基本理论与应用（第 2 版）》4.6 节（书页 197–204）逐条对照——**编号完全一致**（定义 4.6.1–4.6.6、定理 4.6.1–4.6.5、命题 4.6.1–4.6.3、推论 4.6.1–4.6.5、引理 4.6.1、例 4.6.1–4.6.9）。教材在 4.6 结束后直接接 4.7 矩阵函数（书页 205），与本编「4.7 待补」的说明一致。**本节无对应录播**，故不引用课堂口述与时间戳：课件的定义、定理、命题、引理、注记、例题**照录并保留原编号**（定义 4.6.1–4.6.6、定理 4.6.1–4.6.5、命题 4.6.1–4.6.3、推论 4.6.1–4.6.5、引理 4.6.1、注 1 与注 3、例 4.6.1–4.6.9）；课件只述不证、只给结论或未给答案的「思考」，由本编补出并逐处标注「本编补」；新增例题用字母编号（[4.6.A](#ex-4.6.A)–[4.6.C](#ex-4.6.C)）。课件本节缺「注 2」（第 30 页之后直接是注 3），正文按原编号照录并在[勘误](errata.md)中说明。

本节的[Abel 判别图版](#fig-abel-anchor)把「谱半径落在收敛圆哪一边」画成三种处境；正文所有算例均由 `tools/verify_teaching_examples.py` 精确复核（含 $\rho(A)$、$\sum A^k$ 的部分和、Neumann 级数的截断误差）。
:::

<a id="sec-4.6.1"></a>

## 4.6.1 向量序列：按范数收敛

级数是「部分和序列的极限」，所以先要把**序列收敛**说清楚。

::: def 定义 4.6.1 · 向量序列按范数收敛（课件原文） {#def-4.6.1}

设 $(V,\|\cdot\|_\alpha)$ 是 $n$ 维赋范线性空间，$\boldsymbol x_1,\boldsymbol x_2,\cdots,\boldsymbol x_k,\cdots$ 是 $V$ 中一个向量序列，记为 $\{\boldsymbol x_k\}$。若存在 $V$ 的向量 $\boldsymbol x$ 满足

$$\lim_{k\to\infty}\|\boldsymbol x_k-\boldsymbol x\|_\alpha=0,$$

则称向量序列 $\{\boldsymbol x_k\}$ **按范数 $\|\cdot\|_\alpha$ 收敛**于 $\boldsymbol x$，记作

$$\lim_{k\to\infty}\boldsymbol x_k=\boldsymbol x\quad\text{或}\quad \boldsymbol x_k\xrightarrow{\ \alpha\ }\boldsymbol x .$$

不收敛的向量序列称为**发散的**。
:::

这个定义与微积分里的 $\lim a_k=a$ 是同一个句式，只把「$|a_k-a|$」换成了「$\|\boldsymbol x_k-\boldsymbol x\|_\alpha$」——**把「距离」抽象成「范数」**。

::: ex 例 4.6.1（课件原文）· 一维情形退化为微积分 {#ex-4.6.1}

设 $V=\mathbb R$，$\|\cdot\|_\alpha$ 取为绝对值，则 [定义 4.6.1](#def-4.6.1) 中的敛散性与高等数学中的相关概念一致。

::: sol 说明（本编补一句）

$V=\mathbb R$ 时向量就是实数，$\|\boldsymbol x_k-\boldsymbol x\|_\alpha=|x_k-x|$，于是「按范数收敛」四个字退化为「$|x_k-x|\to0$」，正是微积分里数列收敛的定义。**这说明新定义不是新东西，而是旧定义的推广**——推广的意义在于它同时覆盖了 $\mathbb R^n$、$\mathbb C^n$、$\mathbb C^{m\times n}$（拉直后）以及任何有限维赋范空间。
:::
:::

::: thm 定理 4.6.1（课件原文）· 有限维空间里「按范数收敛」不依赖范数 {#thm-4.6.1}

设 $(V,\|\cdot\|)$ 是 $n$ 维赋范线性空间，$\{\boldsymbol x_k\}$ 是 $V$ 的一个向量序列。若序列 $\{\boldsymbol x_k\}$ 按某种范数收敛于 $\boldsymbol x$，则序列 $\{\boldsymbol x_k\}$ 按**任意**范数收敛于 $\boldsymbol x$，即有限维空间中按范数收敛是**等价**的。
:::

::: proof 证明（本编补：直接用范数等价夹逼）

设 $\|\cdot\|_\alpha$ 与 $\|\cdot\|_\beta$ 是 $V$ 上任意两个范数。由 [定理 4.1.2](sec41.md#thm-4.1.2)，存在正数 $k_1,k_2$ 使

$$k_1\|\boldsymbol x\|_\beta\le\|\boldsymbol x\|_\alpha\le k_2\|\boldsymbol x\|_\beta\qquad(\forall\boldsymbol x\in V).$$

取 $\boldsymbol x=\boldsymbol x_k-\boldsymbol x$，得

$$k_1\|\boldsymbol x_k-\boldsymbol x\|_\beta\le\|\boldsymbol x_k-\boldsymbol x\|_\alpha\le k_2\|\boldsymbol x_k-\boldsymbol x\|_\beta .$$

若 $\|\boldsymbol x_k-\boldsymbol x\|_\alpha\to0$，左式给出 $\|\boldsymbol x_k-\boldsymbol x\|_\beta\to0$（被 $1/k_2$ 倍的 $\alpha$-距离夹住）；反向由右式同理。∎

**这条定理是整个 4.6 的「地基」**：它保证后面凡是涉及收敛的证明，都可以**随手挑一把最好算的范数**（通常是 $\|\cdot\|_F$ 或 $\|\cdot\|_\infty$），而不必担心换一把范数结论就变。代价是：**收敛速度会变**（常数因子不同），但「收不收敛」与「极限是谁」都不变。
:::

::: def 定义 4.6.2 · 向量序列按坐标收敛（课件原文） {#def-4.6.2}

设 $(V,\|\cdot\|_\alpha)$ 是 $n$ 维赋范线性空间，$\boldsymbol\varepsilon_1,\cdots,\boldsymbol\varepsilon_n$ 是 $V$ 中一组基，$\{\boldsymbol x_k\}$ 是 $V$ 中一个向量序列，并记 $\boldsymbol x_k$ 在 $\boldsymbol\varepsilon_1,\cdots,\boldsymbol\varepsilon_n$ 下的坐标为

$$\boldsymbol\xi_k=\big(\xi_1^{(k)},\cdots,\xi_n^{(k)}\big)^{\mathrm T}\in F^n .$$

若存在 $V$ 的向量 $\boldsymbol x$（其坐标为 $\boldsymbol\xi=(\xi_1,\cdots,\xi_n)^{\mathrm T}$）满足

$$\lim_{k\to\infty}\xi_i^{(k)}=\xi_i,\qquad i=1,\cdots,n,$$

则称向量序列 $\{\boldsymbol x_k\}$ **按坐标收敛**于向量 $\boldsymbol x$。
:::

::: thm 定理 4.6.2（课件原文）· 按范数收敛 $\iff$ 按坐标收敛 {#thm-4.6.2}

设 $(V,\|\cdot\|)$ 是 $n$ 维赋范线性空间，$\{\boldsymbol x_k\}$ 是 $V$ 的一个向量序列且 $\boldsymbol x\in V$。向量序列 $\{\boldsymbol x_k\}$ 按范数收敛于 $\boldsymbol x$ **当且仅当**它按坐标收敛于 $\boldsymbol x$。
:::

::: proof 证明（本编补：把坐标范数夹在任意范数两侧）

记 $\boldsymbol x-\boldsymbol x_k$ 在基下的坐标为 $\boldsymbol\xi-\boldsymbol\xi_k=(\xi_1-\xi_1^{(k)},\cdots,\xi_n-\xi_n^{(k)})^{\mathrm T}$。「按坐标收敛」意思是每个分量趋于零，等价于

$$\|\boldsymbol\xi-\boldsymbol\xi_k\|_\infty=\max_i|\xi_i-\xi_i^{(k)}|\to0 .$$

**（1）坐标 $\Rightarrow$ 范数**。定义 $V$ 上的**坐标范数**

$$\|\boldsymbol x\|_c=\|\boldsymbol\xi\|_\infty=\max_i|\xi_i| .$$

它是范数（[例 4.1.2](sec41.md#ex-4.1.2)）。由 [定理 4.1.2](sec41.md#thm-4.1.2)（或 [定理 4.6.1](#thm-4.6.1)），$\|\cdot\|_c$ 与题给的 $\|\cdot\|$ 等价：存在 $k_2\gt0$ 使 $\|\boldsymbol x\|\le k_2\|\boldsymbol x\|_c$。于是

$$\|\boldsymbol x_k-\boldsymbol x\|\le k_2\|\boldsymbol x_k-\boldsymbol x\|_c=k_2\|\boldsymbol\xi-\boldsymbol\xi_k\|_\infty\to0 .$$

**（2）范数 $\Rightarrow$ 坐标**。同一个等价关系给出 $k_1\gt0$ 使 $k_1\|\boldsymbol y\|_c\le\|\boldsymbol y\|$，取 $\boldsymbol y=\boldsymbol x_k-\boldsymbol x$：

$$\|\boldsymbol\xi-\boldsymbol\xi_k\|_\infty=\|\boldsymbol x_k-\boldsymbol x\|_c\le\frac{1}{k_1}\|\boldsymbol x_k-\boldsymbol x\|\to0,$$

即每个 $|\xi_i-\xi_i^{(k)}|\le\|\boldsymbol\xi-\boldsymbol\xi_k\|_\infty\to0$。∎

**要点**：**「按坐标收敛」本质上就是「按坐标范数收敛」**，而定理 4.1.2 说有限维空间里所有范数等价——于是两种收敛是同一件事。这条结论把「抽象空间里的极限」翻译成「$n$ 个数列各自的极限」，从此可以用微积分的所有工具（夹逼、比较、求和）。
:::

<a id="sec-4.6.2"></a>

## 4.6.2 矩阵序列：按元素收敛

矩阵是 $\mathbb C^{m\times n}$ 中的向量（拉直即可），所以上面那一套原封不动搬过来；只是「坐标」在这里有了具体的名字：**元素**。

::: def 定义 4.6.3 · 矩阵序列按坐标（按元素）收敛（课件原文） {#def-4.6.3}

设矩阵序列 $\{A_k\}$，其中 $A_k=(a_{ij}^{(k)})\in\mathbb C^{m\times n}$，$k=1,2,\cdots$。如果当 $k\to\infty$ 时，$A_k$ 的**每一个元素**都有极限 $a_{ij}^{(0)}$，即

$$\lim_{k\to\infty}a_{ij}^{(k)}=a_{ij}^{(0)},\qquad 1\le i\le m,\ 1\le j\le n,$$

则称矩阵序列**按元素收敛**或**按坐标收敛**（或简称为矩阵序列 $\{A_k\}$ **收敛**），$A_0=(a_{ij}^{(0)})$ 称为序列的**极限**，记为

$$\lim_{k\to\infty}A_k=A_0 .$$
:::

::: ex 例 4.6.2（课件原文）· 按元素求极限 {#ex-4.6.2}

设

$$A_k=\begin{bmatrix}\dfrac{2k^2+k+1}{k^2}&\dfrac{\sin k}{k}\\[8pt] e^{-k}\sin k&\Big(1+\dfrac{1}{2k}\Big)^{k}\end{bmatrix},$$

求 $\lim\limits_{k\to\infty}A_k$。

::: sol 解答（本编补）

四个元素分别求极限：

- $(1,1)$：$\dfrac{2k^2+k+1}{k^2}=2+\dfrac1k+\dfrac1{k^2}\to2$；
- $(1,2)$：$\Big|\dfrac{\sin k}{k}\Big|\le\dfrac1k\to0$，故极限为 $0$；
- $(2,1)$：$|e^{-k}\sin k|\le e^{-k}\to0$，故极限为 $0$；
- $(2,2)$：$\Big(1+\dfrac{1}{2k}\Big)^{k}=\Big[\Big(1+\dfrac{1}{2k}\Big)^{2k}\Big]^{1/2}\to e^{1/2}=\sqrt e$。

（最后一式用了「$(1+1/t)^t\to e$」取 $t=2k$。）

**答案**：

$$\lim_{k\to\infty}A_k=\begin{bmatrix}2&0\\0&\sqrt e\end{bmatrix}.\qquad\blacksquare$$

**注意**：这里**没有**用任何范数，只用了四个标量极限。这正是 [定理 4.6.2](#thm-4.6.2) 的意义——按元素收敛就是按范数收敛，两套语言可以互译。
:::
:::

::: prop 命题 4.6.1（课件原文）· 极限的四则运算 {#prop-4.6.1}

设矩阵序列 $\{A_k\}$ 和 $\{B_k\}$ 分别收敛于矩阵 $A$ 和 $B$，则对任意 $c_1,c_2\in\mathbb C$，有

1. $\lim\limits_{k\to\infty}(c_1A_k+c_2B_k)=c_1A+c_2B$，其中 $A_k,B_k\in\mathbb C^{m\times n}$；
2. $\lim\limits_{k\to\infty}(A_kB_k)=AB$，其中 $A_k\in\mathbb C^{m\times n}$，$B_k\in\mathbb C^{n\times p}$；
3. 若 $A_k$ 和 $A$ 为**可逆矩阵**，则 $\lim\limits_{k\to\infty}A_k^{-1}=A^{-1}$。
:::

::: proof 证明（课件只述，本编补）

**(1)** 逐元素：$(c_1A_k+c_2B_k)_{ij}=c_1a_{ij}^{(k)}+c_2b_{ij}^{(k)}\to c_1a_{ij}+c_2b_{ij}$，用标量极限的线性性。

**(2)** 逐元素：$(A_kB_k)_{ij}=\sum_{l=1}^{n}a_{il}^{(k)}b_{lj}^{(k)}$，是**有限个**（$n$ 个）收敛数列之积的和，故趋于 $\sum_l a_{il}b_{lj}=(AB)_{ij}$。**「有限个」是关键**——无穷个求和不能这样直接搬。

**(3)** 分两步。

**先证「$A$ 可逆」**。这一步不能只靠「$A_k$ 都可逆」——$A_k=\operatorname{diag}(1,1/k)$ 都可逆，极限却是奇异的 $A=\operatorname{diag}(1,0)$。所以必须**另给假设**：第 3 条的完整陈述应读作「$A_k$ 与 $A$ 都可逆」（课件原句即如此），下文按此理解。

**再证 $A_k^{-1}\to A^{-1}$**。由 $A_k-A\to O$ 与 [定理 4.5.2](sec45.md#thm-4.5.2)（或直接用 [定理 4.3.6](sec43.md#thm-4.3.6)），把 $A_k$ 写成

$$A_k=A\big[I+A^{-1}(A_k-A)\big]=A(I+E_k),\qquad E_k=A^{-1}(A_k-A),$$

则 $\|E_k\|\le\|A^{-1}\|\,\|A_k-A\|\to0$，故存在 $K$ 使 $k\ge K$ 时 $\|E_k\|\lt\tfrac12\lt1$。由 [定理 4.3.6](sec43.md#thm-4.3.6)，$I+E_k$ 可逆且

$$\big\|(I+E_k)^{-1}\big\|\le\frac{\|I\|}{1-\|E_k\|}\le2\|I\| ,$$

故 $\|A_k^{-1}\|=\big\|(I+E_k)^{-1}A^{-1}\big\|\le2\|I\|\,\|A^{-1}\|$（$k\ge K$ 一致有界）。又

$$A_k^{-1}-A^{-1}=A_k^{-1}(A-A_k)A^{-1},$$

取范数：

$$\|A_k^{-1}-A^{-1}\|\le\|A_k^{-1}\|\,\|A_k-A\|\,\|A^{-1}\|\le2\|I\|\,\|A^{-1}\|^2\|A_k-A\|\to0 .\qquad\blacksquare$$

**这一步为什么必须借定理 4.3.6**：$\|A_k^{-1}\|$ 的**一致有界性**不是白来的。没有它，$\|A_k^{-1}-A^{-1}\|\le\|A_k^{-1}\|\|A_k-A\|\|A^{-1}\|$ 的右端就是「$\infty\times0$」，不能断言趋于零。**逆的连续性靠的是「可逆点附近有一致界」**，而这正是 [定理 4.3.6](sec43.md#thm-4.3.6) 的内容。
:::

::: cor 推论 4.6.1（课件原文）· 用范数说收敛 {#cor-4.6.1}

设 $\|\cdot\|$ 是 $\mathbb C^{m\times n}$ 上任一矩阵范数，$\mathbb C^{m\times n}$ 中矩阵序列 $\{A_k\}$ 收敛于矩阵 $A_0$ 的**充分必要条件**是

$$\lim_{k\to\infty}\|A_k-A_0\|=0 .$$
:::

::: proof 证明（课件原文，本编补细节）

**充分性**：**选取 $F$-范数**（课件原话「选取 F 范数即可」）。若 $\|A_k-A_0\|_F\to0$，则 $F$-范数的定义

$$\|A_k-A_0\|_F=\Big(\sum_{i,j}|a_{ij}^{(k)}-a_{ij}^{(0)}|^2\Big)^{1/2}$$

说明每个 $|a_{ij}^{(k)}-a_{ij}^{(0)}|\le\|A_k-A_0\|_F\to0$，即按元素收敛。

**必要性**：**选取 $F$-范数，根据不同范数的等价性即得结论**。若 $A_k\to A_0$（按元素），则 $\|A_k-A_0\|_F\to0$；再由 [定理 4.2.2](sec42.md#thm-4.2.2)（矩阵向量范数等价），任意给定范数 $\|\cdot\|$ 满足 $\|\cdot\|\le C\|\cdot\|_F$，故 $\|A_k-A_0\|\le C\|A_k-A_0\|_F\to0$。∎

**一句话**：**「按元素收敛」与「按任意矩阵范数收敛」是同一件事**——前者好验证（逐元素算），后者好证明（用范数不等式）。
:::

::: note 本编补注 · 一个容易搞混的点：$\|A_k\|\to\|A\|$ 但反之不然 {#note-4.6-normlimit}

由 [推论 4.6.1](#cor-4.6.1) 与三角不等式的等价形式（[注 2](sec41.md#note-4.1-triangle)），$A_k\to A$ 推出 $\|A_k\|\to\|A\|$：

$$\big|\|A_k\|-\|A\|\big|\le\|A_k-A\|\to0 .$$

**但反过来不成立**：$\|A_k\|$ 收敛不意味着 $A_k$ 收敛[^1]。例如 $A_k=\begin{bmatrix}0&1\\(-1)^k&0\end{bmatrix}$，$\|A_k\|_F=\sqrt2$ 恒为常数，但 $A_k$ 在 $\begin{bmatrix}0&1\\1&0\end{bmatrix}$ 与 $\begin{bmatrix}0&1\\-1&0\end{bmatrix}$ 之间来回跳。**范数只是「一个数」，能丢的信息太多。**

[^1]: 这条注是「$\|\cdot\|$ 连续」的正确用法示例，与 [4.1](sec41.md#thm-4.1.1) 的「范数是坐标的连续函数」是同一条结论的两种说法。
:::

::: think 思考（课件）· 若 $\lim A^k=O$，是否必有 $\|A\|\lt1$？ {#think-4.6-normnotboth}

**答案：不一定——但 $\rho(A)\lt1$ 一定成立。** 课件直接给出反例：

$$A=\begin{bmatrix}0.1&0\\1&0.1\end{bmatrix},\qquad A^k=\begin{bmatrix}0.1^k&0\\k\cdot0.1^{k-1}&0.1^k\end{bmatrix}\to O .$$

取 $\|\cdot\|_\infty$：$\|A\|_\infty=\max\{0.1,\ 1.1\}=1.1\gt1$，**但 $A^k\to O$**。所以「$\|A\|\lt1$」是 $A^k\to O$ 的**充分条件，不是必要条件**。

**真正等价的是谱半径**（[定理 4.6.3](#thm-4.6.3)）：

$$A^k\to O\iff\rho(A)\lt1 .$$

**为什么两者不同**：$\|A\|$ 是「一次乘法的最大放大倍数」，$\rho(A)$ 是「长期的平均增长率」。$A$ 可以在**某一步**放大（$\|A\|_\infty=1.1\gt1$），只要相邻两步的放大互相抵消、长期净效果是收缩，幂照样收敛。上面的 $A^k$ 里那个 $k\cdot0.1^{k-1}$ 就是「短期放大」的痕迹：它在 $k=10$ 附近达到峰值约 $0.39$，随后被指数因子压死。

这正是 [定理 4.5.2](sec45.md#thm-4.5.2) 存在的理由：**$\rho(A)\lt1$ 时，总能找到一把（为 $A$ 定制的）范数使 $\|A\|\lt1$**，那时「$\|A\|\lt1\Rightarrow A^k\to O$」就能用上了。
:::

<a id="sec-4.6.3"></a>

## 4.6.3 幂零化判据：什么时候 A 的幂趋于零

::: cor 推论 4.6.2（课件原文）· 范数小于 $1$ 是充分条件 {#cor-4.6.2}

复方阵 $A$ 的某一范数满足 $\|A\|\lt1$，则

$$\lim_{k\to\infty}A^k=O .$$
:::

::: proof 证明（本编补一行）

由乘法相容性（[定义 4.2.2](sec42.md#def-4.2.2) 第 4 条）归纳得 $\|A^k\|\le\|A\|^k$；$\|A\|\lt1$ 时 $\|A\|^k\to0$，故 $\|A^k\|\to0$，由 [推论 4.6.1](#cor-4.6.1) 得 $A^k\to O$。∎
:::

::: thm 定理 4.6.3（课件原文）· $A^k\to O$ $\iff$ $\rho(A)\lt1$ {#thm-4.6.3}

设 $A=(a_{ij})\in\mathbb C^{n\times n}$，则 $\lim\limits_{k\to\infty}A^k=O$ 的**充分必要条件**是 $\rho(A)\lt1$。
:::

::: proof 证明（课件原文用 Jordan 标准形，本编补两半细节）

记 $J=P^{-1}AP=\operatorname{diag}(J_1,\cdots,J_s)$ 为 Jordan 标准形（[定理 3.8.5′](../ch03/sec38b.md#thm-3.8.5j)），其中 $J_i=J_{n_i}(\lambda_i)$ 是 $n_i$ 阶 Jordan 块。则 $A^k=PJ^kP^{-1}$，而 $J^k=\operatorname{diag}(J_1^k,\cdots,J_s^k)$。**所以 $A^k\to O\iff J^k\to O\iff$ 每个 $J_i^k\to O$**（$P,P^{-1}$ 是常矩阵，[命题 4.6.1](#prop-4.6.1)(1)）。

**单个 Jordan 块的幂**（课件给出这个矩阵）：

$$J_i^k=\begin{bmatrix}\lambda_i^k&C_k^1\lambda_i^{k-1}&C_k^2\lambda_i^{k-2}&\cdots&C_k^{n_i-1}\lambda_i^{k-n_i+1}\\ &\lambda_i^k&C_k^1\lambda_i^{k-1}&\cdots&C_k^{n_i-2}\lambda_i^{k-n_i+2}\\ & &\ddots&\ddots&\vdots\\ & & &\lambda_i^k&C_k^1\lambda_i^{k-1}\\ & & & &\lambda_i^k\end{bmatrix}\in\mathbb C^{n_i\times n_i},$$

其中 $k\ge n_i-1$（不足的项按 $0$ 处理）。**推导**：$J_i=\lambda_iI+N_i$，$N_i$ 是超对角全 $1$ 的幂零阵，$N_i^l$ 就是「把 $1$ 挪到第 $l$ 条超对角线」，故

$$J_i^k=\sum_{l=0}^{n_i-1}\binom{k}{l}\lambda_i^{k-l}N_i^l ,$$

逐项对照即得。

**（1）$\rho(A)\lt1\Rightarrow J_i^k\to O$**。设 $\rho=\rho(A)\lt1$。每个 $|\lambda_i|\le\rho$，故对每个固定的 $l$，

$$\Big|\binom{k}{l}\lambda_i^{k-l}\Big|\le\binom{k}{l}\rho^{k-l}=\underbrace{\frac{k(k-1)\cdots(k-l+1)}{l!}}_{\text{关于 }k\text{ 的 }l\text{ 次多项式}}\cdot\rho^{k-l}\longrightarrow0 .$$

（多项式乘指数衰减必趋于零：可用比值判别法验证，或写 $k^l\rho^k=\exp(l\ln k+k\ln\rho)$，而 $l\ln k+k\ln\rho\to-\infty$。）$J_i^k$ 只有有限多个这样的位置，故 $J_i^k\to O$，从而 $A^k\to O$。

**（2）$\rho(A)\ge1\Rightarrow A^k\not\to O$**。取 $|\lambda_i|=\rho\ge1$ 的那个块。$J_i^k$ 的对角元是 $\lambda_i^k$，$|\lambda_i^k|=\rho^k\ge1$ 不趋于零，故 $J_i^k\not\to O$，从而 $A^k\not\to O$。∎

**证明的要点**：**Jordan 块把「幂」拆成「指数 × 多项式」**——$\lambda_i^k$ 决定长期趋势，$\binom{k}{l}$ 只贡献多项式因子。**指数战胜多项式**，所以判据只看 $|\lambda_i|$，而多项式因子（也就是 Jordan 块的长度、也就是不可对角化的程度）完全不影响「收不收敛」，只影响「多快收敛」。

**这也解释了 [思考](#think-4.6-normnotboth) 里 $k\cdot0.1^{k-1}$ 为什么会消失**：它是 $\binom{k}{1}\lambda^{k-1}$，多项式因子 $k$ 被 $0.1^k$ 压死。
:::

::: ex 例 4.6.3（课件原文）· 用 $c$ 参数化 {#ex-4.6.3}

设 $A=\begin{bmatrix}c&2c\\3c&2c\end{bmatrix}$，其中 $c$ 为实数。求 $\lim\limits_{k\to\infty}A^k=O$ 的充分必要条件。

::: sol 解答（本编补完整计算）

**第一步：算特征值**。

$$\det(\lambda I-A)=\begin{vmatrix}\lambda-c&-2c\\-3c&\lambda-2c\end{vmatrix}=(\lambda-c)(\lambda-2c)-6c^2=\lambda^2-3c\lambda+2c^2-6c^2=\lambda^2-3c\lambda-4c^2 .$$

因式分解：$\lambda^2-3c\lambda-4c^2=(\lambda-4c)(\lambda+c)$，故

$$\lambda_1=4c,\qquad \lambda_2=-c .$$

**第二步：用定理 4.6.3**。

$$\rho(A)=\max\{|4c|,\,|c|\}=4|c| .$$

于是

$$A^k\to O\iff\rho(A)\lt1\iff4|c|\lt1\iff|c|\lt\frac14 .$$

**答案**：$-\dfrac14\lt c\lt\dfrac14$。∎

**验算**（本编补）：$c=0.2$ 时 $\rho=0.8\lt1$，$A$ 可对角化（$\lambda_1=0.8$、$\lambda_2=-0.2$ 互异），$A^k\to O$ ✓；$c=0.25$ 时 $\rho=1$，$\lambda_1=1$，$A^k$ 的对角元含 $1^k=1$，不趋于零 ✓；$c=-0.2$ 时 $\rho=0.8\lt1$，同样收敛——**注意 $c$ 是负数时特征值的绝对值仍要小于 $1$，不是「$c\lt\frac14$」这么简单**。
:::
:::

::: cor 推论 4.6.3（课件原文）· 与推论 4.6.2 的关系 {#cor-4.6.3}

若复方阵 $A$ 的某一矩阵范数满足 $\|A\|\lt1$，则矩阵序列 $\{A^k\}$ 收敛于零矩阵。

**本编补一句**：这条与 [推论 4.6.2](#cor-4.6.2) 的**陈述完全相同**——课件在这里重复了一次。它的价值在于位置：放在 [定理 4.6.3](#thm-4.6.3) 之后，读者可以把它看成「定理 4.6.3 的充分条件版」：$\|A\|\lt1\Rightarrow\rho(A)\le\|A\|\lt1\Rightarrow A^k\to O$（用 [定理 4.5.1](sec45.md#thm-4.5.1) 与 [定理 4.6.3](#thm-4.6.3)）。见[勘误 E4.12](errata.md)。
:::

<a id="sec-4.6.4"></a>

## 4.6.4 矩阵级数：收敛、绝对收敛、可重排

::: def 定义 4.6.4 · 矩阵级数（课件原文） {#def-4.6.4}

设矩阵序列 $\{A_k\}\subset\mathbb C^{m\times n}$，称 $\sum\limits_{k=1}^{\infty}A_k$ 为**矩阵级数**。令

$$S_N=\sum_{k=1}^{N}A_k ,$$

称 $S_N$ 为矩阵级数的**部分和**。若矩阵序列 $\{S_N\}$ 收敛且有极限 $S$，即 $\lim\limits_{N\to\infty}S_N=S$，则称矩阵级数 $\sum\limits_{k=1}^{\infty}A_k$ **收敛**且有和 $S$。不收敛的矩阵级数称为**发散级数**。
:::

级数的定义完全照搬微积分：**看部分和序列的极限**。矩阵的特殊之处只在「$S_N$ 是矩阵」，而矩阵序列的收敛已在 4.6.2 说清。

::: ex 例 4.6.4（课件原文）· 对角阵的级数 {#ex-4.6.4}

设

$$A_k=\begin{bmatrix}\dfrac{1}{k(k+1)}&0\\[6pt]0&\dfrac{2k}{3^k}\end{bmatrix},\qquad k=1,2,\cdots,$$

求级数 $\sum\limits_{k=1}^{\infty}A_k$。

::: sol 解答（课件给出三个必备级数，本编补完整过程）

对角阵的级数逐元素求和即可（每个元素是独立的数值级数）。课件列出三个必备公式（$|x|\lt1$）：

$$\sum_{k=1}^{\infty}\frac{1}{k(k+1)}=1,\qquad 1+2x+3x^2+\cdots=\frac{1}{(1-x)^2},\qquad x+2x^2+3x^3+\cdots=\frac{x}{(1-x)^2}.$$

第一式由**裂项**得到：$\dfrac{1}{k(k+1)}=\dfrac1k-\dfrac1{k+1}$，故部分和 $S_N=1-\dfrac{1}{N+1}\to1$。

**（1,1）元**：$\sum\limits_{k=1}^{\infty}\dfrac{1}{k(k+1)}=1$。

**（2,2）元**：$\sum\limits_{k=1}^{\infty}\dfrac{2k}{3^k}=2\sum\limits_{k=1}^{\infty}k\Big(\dfrac13\Big)^k$，套第三式（$x=\tfrac13$）：

$$\sum_{k=1}^{\infty}k\Big(\frac13\Big)^k=\frac{1/3}{(1-1/3)^2}=\frac{1/3}{4/9}=\frac34,\qquad\text{故}\quad 2\cdot\frac34=\frac32 .$$

**答案**：

$$\sum_{k=1}^{\infty}A_k=\begin{bmatrix}1&0\\0&\dfrac32\end{bmatrix}.\qquad\blacksquare$$

**要点**：这一步是「**把矩阵级数拆成若干标量级数，各自套教科书公式**」。三件套（裂项、等比、$kx^k$）覆盖了本节绝大多数例子；$(2,2)$ 元之所以取 $2k$ 而不是 $2^k$，就是为了逼你用第三式而不是第二式——**指数在分子还是多项式在分子，决定用哪一条公式**。
:::
:::

::: prop 命题 4.6.2（课件原文）· 级数收敛 $\iff$ 各元素级数收敛 {#prop-4.6.2}

设 $A_k\in\mathbb C^{m\times n}$，则以下命题成立：

1. $\sum\limits_{k=1}^{\infty}A_k$ 收敛 $\iff$ $mn$ 个数值级数 $\sum\limits_{k=1}^{\infty}a_{ij}^{(k)}$ 都收敛；
2. $\sum\limits_{k=1}^{\infty}A_k$ 发散 $\iff$ $mn$ 个数值级数 $\sum\limits_{k=1}^{\infty}a_{ij}^{(k)}$ 中**至少有一个**发散；
3. $\sum\limits_{k=1}^{\infty}A_k$ 收敛 $\Rightarrow$ $\lim\limits_{k\to\infty}A_k=O$。
:::

::: proof 证明（课件给出第 (3) 的关键式，本编补全）

**(1)(2)** 由定义 4.6.4，$S_N$ 的 $(i,j)$ 元是 $\sum_{k=1}^{N}a_{ij}^{(k)}$，而矩阵序列收敛 $\iff$ 按元素收敛（[定义 4.6.3](#def-4.6.3)）。故级数收敛 $\iff$ 每个 $(i,j)$ 元的部分和都收敛 $\iff$ 每个数值级数收敛。第 (2) 是第 (1) 的逆否命题。

**(3)** 由 $S_N\to S$ 与 $S_{N-1}\to S$，用 [命题 4.6.1](#prop-4.6.1)(1)：

$$A_k=S_k-S_{k-1}\ \longrightarrow\ S-S=O .\qquad\blacksquare$$

**这条的重要性**：**通项必趋于零**是级数收敛的**必要条件**（不是充分条件）。下一小节的 Abel 型定理「$\rho(A)\gt r$ 时发散」，证的就是「通项不趋于零」。
:::

::: def 定义 4.6.5 · 矩阵级数绝对收敛（课件原文） {#def-4.6.5}

设 $A_k\in\mathbb C^{m\times n}$，若矩阵级数 $\sum\limits_{k=1}^{\infty}A_k$ 所对应的 $mn$ 个数值级数 $\sum\limits_{k=1}^{\infty}a_{ij}^{(k)}$（$1\le i\le m$，$1\le j\le n$）**均绝对收敛**，则称 $\sum\limits_{k=1}^{\infty}A_k$ **绝对收敛**。
:::

::: prop 命题 4.6.3（课件原文）· 绝对收敛的三条性质 {#prop-4.6.3}

设 $A_k\in\mathbb C^{m\times n}$，则：

1. 若 $\sum A_k$ 绝对收敛，则 $\sum A_k$ 收敛；但 $\sum A_k$ 收敛**并不蕴含** $\sum A_k$ 绝对收敛；
2. 若 $\sum A_k$ 绝对收敛于 $S$，对 $\sum A_k$ **任意重组重排**得矩阵级数 $\sum B_k$，则 $\sum B_k$ 绝对收敛于 $S$；
3. 对任意常矩阵 $P\in\mathbb C^{p\times m}$ 和 $Q\in\mathbb C^{n\times q}$，若矩阵级数 $\sum A_k$（绝对）收敛，则矩阵级数 $\sum PA_kQ$（绝对）收敛。**反之则不然**。
:::

::: proof 证明（本编补）

**(1)** 「绝对收敛 $\Rightarrow$ 收敛」逐元素用实数列的结论（绝对收敛 $\Rightarrow$ 收敛）。反例：取 $A_k=\begin{bmatrix}(-1)^{k+1}/k&0\\0&0\end{bmatrix}$，则 $(1,1)$ 元是交错调和级数（收敛但非绝对收敛），故 $\sum A_k$ 收敛而不绝对收敛——这正是 [例 4.6.5](#ex-4.6.5)。

**(2)** 逐元素：每个数值级数 $\sum a_{ij}^{(k)}$ 绝对收敛，故其任意重排也绝对收敛于同一和（实数列的重排定理）。$mn$ 个都如此，故矩阵级数重排后收敛于 $S$。**绝对收敛是重排不变性的门票**，条件收敛的级数重排会改变和（黎曼重排定理）。

**(3)** 逐元素：$P$、$Q$ 是常矩阵，故 $(PA_kQ)_{ij}=\sum_{r,s}p_{ir}a_{rs}^{(k)}q_{sj}$ 是**有限个** $a_{rs}^{(k)}$ 的线性组合。若 $\sum|a_{rs}^{(k)}|\lt\infty$，则有限组合的**绝对**和也收敛（三角不等式），故 $\sum PA_kQ$ 绝对收敛。收敛同理。

**「反之不然」**：$\sum PA_kQ$ 收敛推不出 $\sum A_k$ 收敛——$P$ 或 $Q$ 可能把发散的部分「压掉」。最简单的例子：取 $P=Q=O$，则 $\sum PA_kQ=\sum O$ 恒收敛，而 $\sum A_k$ 可以任意发散。∎
:::

::: note 本编补注 · 为什么一定要「绝对收敛」才能重排 {#note-4.6-rearrange}

矩阵级数的重排性质**完全继承自数值级数**：因为「收敛」「绝对收敛」都被 [命题 4.6.2](#prop-4.6.2) 翻译成「$mn$ 个数列各自如何」，而数列的重排定理由实分析保证。

- **绝对收敛**：重排不改变和（也无条件收敛）；
- **条件收敛**：重排可以凑出任意指定的和，甚至发散（黎曼重排定理）。

所以 [命题 4.6.3](#prop-4.6.3)(2) 里那个「绝对」不能去掉。**实践中的判断顺序是：先证绝对收敛（用范数，见 [定理 4.6.4](#thm-4.6.4)），再做任何重排、合并、交换求和次序的操作。**
:::

::: ex 例 4.6.5（课件原文）· 条件收敛的矩阵级数 {#ex-4.6.5}

考查矩阵级数 $\sum\limits_{k=1}^{\infty}A_k$ 的敛散性，其中

$$A_k=\begin{bmatrix}(-1)^{k+1}\dfrac1k&0\\[6pt]0&0\end{bmatrix}.$$

::: sol 解答（本编补）

**收敛**：$(1,1)$ 元是交错调和级数 $\sum(-1)^{k+1}/k=\ln2$（收敛），其余三元恒为 $0$。由 [命题 4.6.2](#prop-4.6.2)(1)，级数收敛，和为

$$\sum_{k=1}^{\infty}A_k=\begin{bmatrix}\ln2&0\\0&0\end{bmatrix}.$$

**不绝对收敛**：$(1,1)$ 元取绝对值后是调和级数 $\sum1/k=+\infty$（发散）。由 [定义 4.6.5](#def-4.6.5)，级数**不绝对收敛**。∎

**这个例子说明什么**：它是 [命题 4.6.3](#prop-4.6.3)(1) 的第二个断言的具体兑现——**收敛 ⇏ 绝对收敛**。因此对它做重排要小心：重排后的和可能不是 $\ln2$。（比如按「一正两负」重排，和会变成 $\tfrac12\ln2$ 之类的值。）
:::
:::

::: thm 定理 4.6.4（课件原文）· 绝对收敛的范数刻画 {#thm-4.6.4}

设 $A_k=(a_{ij}^{(k)})\in\mathbb C^{m\times n}$，矩阵级数 $\sum\limits_{k=1}^{\infty}A_k$ **绝对收敛**当且仅当**对任意矩阵范数**，数值级数 $\sum\limits_{k=1}^{\infty}\|A_k\|$ 收敛。
:::

::: proof 证明（本编补两个方向）

**（$\Rightarrow$）** 设 $\sum A_k$ 绝对收敛。取 $F$-范数：

$$\|A_k\|_F=\Big(\sum_{i,j}|a_{ij}^{(k)}|^2\Big)^{1/2}\le\sum_{i,j}|a_{ij}^{(k)}| .$$

右端是 $mn$ 个绝对收敛级数之和，故收敛；由比较判别法，$\sum\|A_k\|_F\lt\infty$。再由 [定理 4.2.2](sec42.md#thm-4.2.2)，任意矩阵范数 $\|\cdot\|$ 满足 $\|\cdot\|\le C\|\cdot\|_F$（**注意**：这里用的是「矩阵向量范数等价」，$F$-范数与给定的矩阵范数都是矩阵的向量范数），故 $\sum\|A_k\|\le C\sum\|A_k\|_F\lt\infty$。

**（$\Leftarrow$）** 设对某一把范数 $\|\cdot\|$ 有 $\sum\|A_k\|\lt\infty$。取 $F$-范数：由等价性存在 $c\gt0$ 使 $\|A_k\|_F\le c\|A_k\|$，故 $\sum\|A_k\|_F\lt\infty$。而

$$|a_{ij}^{(k)}|\le\|A_k\|_F ,$$

故每个 $\sum_k|a_{ij}^{(k)}|\le\sum_k\|A_k\|_F\lt\infty$，即每个数值级数绝对收敛，故 $\sum A_k$ 绝对收敛。∎

**读法**：**「矩阵级数绝对收敛」被完全翻译成「标量级数 $\sum\|A_k\|$ 收敛」**。这是本节最有用的一个转译——从此判断矩阵级数的敛散性，只需挑一把好算的范数算一列正数。

**一个技术提醒**：定理说「对任意范数」，但因为有限维范数等价，实际上**只需验一把**（哪把好算用哪把）。这与 [推论 4.6.1](#cor-4.6.1) 是同一个逻辑。
:::

::: ex 例 4.6.6（课件原文）· 用 $\|\cdot\|_1$ 判绝对收敛 {#ex-4.6.6}

考查矩阵级数 $\sum\limits_{k=1}^{\infty}A_k$ 的敛散性，其中

$$A_k=\begin{bmatrix}\dfrac{1}{3^k}&0\\[6pt]0&\dfrac{1}{k(k+1)}\end{bmatrix}.$$

::: sol 解答（课件给出第一步，本编补全）

**先看收敛**：两个对角元分别是几何级数（公比 $\tfrac13$，和为 $\tfrac{1/3}{1-1/3}=\tfrac12$）与裂项级数（和为 $1$），都收敛，故 $\sum A_k$ 收敛。

**再看绝对收敛**（课件这一步）：

$$\sum_{k=1}^{\infty}\|A_k\|_1=\sum_{k=1}^{\infty}\max\Big\{\frac1{3^k},\ \frac{1}{k(k+1)}\Big\}=\sum_{k=1}^{\infty}\frac{1}{k(k+1)}=1\lt\infty .$$

中间的等号要验一下：$k=1$ 时 $\max\{1/3,\,1/2\}=1/2=\dfrac{1}{1\cdot2}$；$k=2$ 时 $\max\{1/9,\,1/6\}=1/6=\dfrac{1}{2\cdot3}$；$k\ge3$ 时 $\dfrac{1}{k(k+1)}\ge\dfrac{1}{k^2+k}\gt\dfrac{1}{3^k}$（如 $k=3$：$\tfrac1{12}\gt\tfrac1{27}$）。所以对所有 $k\ge1$ 都是 $\dfrac{1}{k(k+1)}$ 取到最大，课件那行的下标与值都对。

**结论**：$\sum\|A_k\|_1=1\lt\infty$，由 [定理 4.6.4](#thm-4.6.4)，级数**绝对收敛**。

**更省事的做法**（本编补）：直接用 $F$-范数，

$$\|A_k\|_F=\sqrt{\frac1{9^k}+\frac{1}{k^2(k+1)^2}}\le\frac{1}{3^k}+\frac{1}{k(k+1)},$$

两端都收敛，故 $\sum\|A_k\|_F\lt\infty$，绝对收敛。**好处是不用比较哪一列更大**——$F$-范数直接把两列平方相加，天然躲过了 $\max$。∎
:::
:::

::: ex 例 4.6.B（新增）· 用定理 4.6.4 一次判死 {#ex-4.6.B}

判断下列矩阵级数是否绝对收敛：(a) $\sum\limits_{k\ge1}\dfrac{1}{k^2}\begin{bmatrix}1&k\\0&1\end{bmatrix}$；(b) $\sum\limits_{k\ge1}\dfrac{1}{k}\begin{bmatrix}1&0\\0&1\end{bmatrix}$；(c) $\sum\limits_{k\ge1}\dfrac{2^k}{k!}\begin{bmatrix}0&1\\0&0\end{bmatrix}$。

::: sol 解答

**(a)** $\Big\|\dfrac1{k^2}\begin{bmatrix}1&k\\0&1\end{bmatrix}\Big\|_1=\dfrac1{k^2}\max\{1,\ k+1\}=\dfrac{k+1}{k^2}\sim\dfrac1k$，而 $\sum1/k$ 发散，故 $\sum\|A_k\|_1=\infty$，**不绝对收敛**。

**但级数本身收敛**：$(1,2)$ 元是 $\sum k/k^2=\sum 1/k$——**发散**。所以整个级数**发散**。这个例子说明「不绝对收敛」可以是「发散」，也可以是「条件收敛」，要靠元素级数进一步看。

**(b)** $\|A_k\|_F=\sqrt2/k$，$\sum\sqrt2/k=\infty$，**不绝对收敛**；且 $\sum A_k=\Big(\sum\frac1k\Big)I$ 发散。**发散**。

**(c)** $\Big\|\dfrac{2^k}{k!}\begin{bmatrix}0&1\\0&0\end{bmatrix}\Big\|_F=\dfrac{2^k}{k!}$，而 $\sum\dfrac{2^k}{k!}=e^2-1\lt\infty$，故**绝对收敛**，且和为

$$\sum_{k\ge1}\frac{2^k}{k!}\begin{bmatrix}0&1\\0&0\end{bmatrix}=(e^2-1)\begin{bmatrix}0&1\\0&0\end{bmatrix}.$$

（注意 $\sum_{k\ge0}\frac{2^k}{k!}=e^2$，故 $\sum_{k\ge1}=e^2-1$。）∎

**要点**：判断顺序永远是**先算 $\|A_k\|$ 的级数**（[定理 4.6.4](#thm-4.6.4)）。若它收敛，直接得绝对收敛；若它发散，**不能立刻下结论**，要回到元素级数看（(a) 就是这样被判定发散的）。∎
:::
:::

<a id="sec-4.6.5"></a>

## 4.6.5 矩阵幂级数：Abel 型定理与 Neumann 级数

实际用到的矩阵级数几乎都是**幂级数**形式——$\sum c_mA^m$。这一类的敛散性有一个极漂亮的判据：**只看 $\rho(A)$ 与数值幂级数的收敛半径谁大。**

::: def 定义 4.6.6 · 矩阵幂级数（课件原文） {#def-4.6.6}

设 $A\in\mathbb C^{n\times n}$，定义矩阵级数

$$\sum_{m=0}^{\infty}c_mA^m,\qquad\text{其中}\ A^0=I,$$

则称该级数为**矩阵幂级数**。
:::

约定 $A^0=I$（包括 $A=O$ 时）。这个约定不是形式上的方便，而是让 $\sum c_mA^m$ 在 $A=O$ 时退化为 $c_0I$——与「零次幂是恒等」的直觉一致。

::: lem 引理 4.6.1（课件原文）· 数值幂级数的收敛半径 {#lem-4.6.1}

设 $z\in\mathbb C$，若幂级数 $\sum\limits_{m=0}^{\infty}c_mz^m$ 在 $z=z_0$ 点收敛，则对满足不等式 $|z|\lt|z_0|$ 的幂级数都**绝对**收敛。反之，若幂级数 $\sum c_mz^m$ 在 $z=z_0$ 点**发散**，则对于 $|z|\gt|z_0|$ 的幂级数都发散。

若存在非负实数或无穷大数 $r$ 满足：$|z|\lt r$ 时幂级数 $\sum c_mz^m$ 收敛，而 $|z|\gt r$ 时幂级数 $\sum c_mz^m$ 都发散，则称 $r$ 为**收敛半径**。
:::

::: proof 证明（本编补，课件未给）

**第一句**。$\sum c_mz_0^m$ 收敛 $\Rightarrow$ 通项有界：$|c_mz_0^m|\le M$。于是对 $|z|\lt|z_0|$，

$$|c_mz^m|=\Big|c_mz_0^m\cdot\Big(\frac{z}{z_0}\Big)^m\Big|\le M\Big|\frac{z}{z_0}\Big|^m ,$$

而 $\Big|\dfrac{z}{z_0}\Big|\lt1$，故右端是收敛的等比级数，由比较判别法得 $\sum|c_mz^m|\lt\infty$。

**第二句**。反设存在 $|z_1|\gt|z_0|$ 使 $\sum c_mz_1^m$ 收敛。由第一句（取 $z_0\rightsquigarrow z_1$、$z\rightsquigarrow z_0$），$|z_0|\lt|z_1|$ 时 $\sum c_mz_0^m$ 绝对收敛，与题设「在 $z_0$ 发散」矛盾。∎

**收敛半径的存在性**：由上面两句，集合 $\{t\ge0:\sum c_mt^m\ \text{收敛}\}$ 是一个「下段」（若 $t$ 在集合里则更小的都在），故其上确界 $r$ 就是收敛半径。实分析里还给出 $r=1/\limsup\sqrt[m]{|c_m|}$（Cauchy–Hadamard 公式），本节用不到。
:::

::: thm 定理 4.6.5（课件原文）· Abel 型定理 {#thm-4.6.5}

设复变量幂级数 $\sum\limits_{m=0}^{\infty}c_mz^m$ 的收敛半径为 $r$，矩阵 $A\in\mathbb C^{n\times n}$ 的谱半径为 $\rho(A)$，则

1. 当 $\rho(A)\lt r$，$\sum\limits_{m=0}^{\infty}c_mA^m$ **绝对收敛**；
2. 当 $\rho(A)\gt r$，$\sum\limits_{m=0}^{\infty}c_mA^m$ **发散**。
:::

::: proof 证明（课件只给结论，本编补两半）

**(1) $\rho(A)\lt r$ ⇒ 绝对收敛**。

**第一步：取一个夹在中间的 $\rho'$，换一把给 $A$ 定制的范数。**

由 $\rho(A)\lt r$ 与实数稠密性，取 $\rho'$ 使

$$\rho(A)\lt\rho'\lt r .$$

令 $\varepsilon=\dfrac{\rho'-\rho(A)}{2}\gt0$。由 [定理 4.5.2](sec45.md#thm-4.5.2)，存在矩阵范数 $\|\cdot\|_m$ 使

$$\|A\|_m\le\rho(A)+\varepsilon=\frac{\rho(A)+\rho'}{2}\lt\rho' .$$

记 $q=\dfrac{\|A\|_m}{\rho'}$，则 $q\lt1$。**这一步是本节的核心**：$\rho(A)\lt r$ 只保证「特征值在收敛圆内」，而 $\|A\|$ 可能远大于 $r$；只有借助 [定理 4.5.2](sec45.md#thm-4.5.2) 换一把范数，才能把 $\|A\|$ 也压进圆内。

**第二步：用收敛性把 $|c_m|$ 控制住。**

由 $|\rho'|\lt r$ 与 [引理 4.6.1](#lem-4.6.1)，$\sum c_m\rho'^m$ 收敛；收敛级数的通项有界，故存在 $M$ 使

$$|c_m|\rho'^m\le M\qquad(\forall m).$$

**第三步：等比控制。**

$$\|c_mA^m\|_m\le|c_m|\,\|A\|_m^m=|c_m|\rho'^m\Big(\frac{\|A\|_m}{\rho'}\Big)^m\le M q^m .$$

右端是公比 $q\lt1$ 的等比级数，故 $\sum\|c_mA^m\|_m\le\dfrac{M}{1-q}\lt\infty$。由 [定理 4.6.4](#thm-4.6.4)，$\sum c_mA^m$ **绝对收敛**。

**(2) $\rho(A)\gt r$**。取特征值 $\lambda$ 满足 $|\lambda|=\rho(A)\gt r$，对应特征向量 $\boldsymbol x\ne\boldsymbol0$。设 $\sum c_mA^m$ 收敛，则对任意常矩阵左乘、右乘（[命题 4.6.3](#prop-4.6.3)(3)），级数

$$\sum_{m}c_mA^m\boldsymbol x\boldsymbol x^{\mathrm H}$$

也收敛（把 $\boldsymbol x\boldsymbol x^{\mathrm H}$ 当 $Q$、取 $P=I$）。而 $A^m\boldsymbol x=\lambda^m\boldsymbol x$，故

$$\sum_m c_mA^m\boldsymbol x\boldsymbol x^{\mathrm H}=\Big(\sum_m c_m\lambda^m\Big)\boldsymbol x\boldsymbol x^{\mathrm H} .$$

左端收敛意味着右端的标量级数 $\sum c_m\lambda^m$ 收敛（$\boldsymbol x\boldsymbol x^{\mathrm H}\ne O$，见 [命题 4.6.2](#prop-4.6.2)：若标量发散则整个矩阵级数发散）。但 $|\lambda|\gt r$，由 [引理 4.6.1](#lem-4.6.1) 的第二句，$\sum c_m\lambda^m$ **发散**——矛盾。故 $\sum c_mA^m$ 发散。∎

**证明的要点**：
- **(1)** 干了两件事：**用 [定理 4.5.2](sec45.md#thm-4.5.2) 把 $\|A\|$ 换成 $A$ 定制的范数**（这一步是本节的枢纽，也是为什么 4.5.2 必须在前），再用**两次 $\rho$ 逼近**把 $|c_m|\rho(A)^m$ 换成收敛的等比级数；
- **(2)** 用的技巧叫「**降维**」：把矩阵级数乘上 $\boldsymbol x\boldsymbol x^{\mathrm H}$ 压到一个方向上，退化成标量级数。**特征向量是矩阵级数与标量级数之间的桥**。
:::

::: note 注 1（课件原文）· 边界 $\rho(A)=r$ 时定理失效 {#note-4.6-1}

当 $\rho(A)=r$ 时，矩阵幂级数 $\sum\limits_{m=0}^{\infty}c_mA^m$ 的敛散性**无法由 Abel 型定理判断**，只能根据矩阵级数的定义进行判断。

**本编补三个例子把三种结局都摆出来**（都取 $A=I$、$r=1$，故 $\rho(A)=r$ 恒成立）：

| 数值幂级数 | $c_m$ | $\sum c_m1^m$ | 矩阵级数 $\sum c_mI$ |
|:--|:--|:--|:--|
| $\sum z^m/m$ | $1/m$ | 调和级数，**发散** | 发散 |
| $\sum z^m/m^2$ | $1/m^2$ | $\zeta(2)=\pi^2/6$，**收敛** | 收敛于 $\dfrac{\pi^2}{6}I$ |
| $\sum z^m$ | $1$ | 通项为 $1$，**发散** | 发散 |

三行的 $\rho(A)$ 与 $r$ 完全相同（都等于 $1$），结局却一个是发散、一个是收敛。**所以边界必须逐个验。**

**而且边界情形连「标量与矩阵同命运」都不保证**：[例 4.6.7](#ex-4.6.7) 会给出一个 $A$（$\rho(A)=1$）使 $\sum A^k/k$ **发散**——这一点与标量的调和级数一致；但换成 $\sum A^k/k^2$ 就收敛。**矩阵情形在边界上比标量情形更微妙**：标量的 $\sum z^m/m$ 在 $z=-1$ 收敛（交错级数），矩阵的 $\sum A^m/m$ 在 $A=-I$ 却发散（$\sum(-1)^m/m$ 收敛，但 $A$ 若带 Jordan 块，$\sum J^m/m$ 就爆）。
:::

::: ex 例 4.6.7（课件原文）· 边界：$\rho(A)=r$ 时的发散 {#ex-4.6.7}

设 $A=\begin{bmatrix}-1&1\\0&-1\end{bmatrix}$，判断 $\sum\limits_{k=1}^{\infty}\dfrac1kA^k$ 的敛散性。

::: sol 解答（本编补完整推导）

**第一步：特征值与谱半径**。$A$ 是上三角阵，对角元全为 $-1$，故 $\lambda_1=\lambda_2=-1$，$\rho(A)=1$。

**第二步：数值幂级数**。$c_k=1/k$ 的收敛半径 $r=1$（$\sum z^k/k$ 在 $|z|\lt1$ 收敛、在 $z=1$ 发散，正是调和级数）。于是 $\rho(A)=1=r$，**Abel 型定理不适用**，必须直接用定义。

**第三步：算 $A^k$**。写 $A=-I+N$，其中 $N=\begin{bmatrix}0&1\\0&0\end{bmatrix}$，$N^2=O$。则

$$A^k=(-I+N)^k=(-1)^kI+\binom{k}{1}(-1)^{k-1}N=\begin{bmatrix}(-1)^k&k(-1)^{k-1}\\0&(-1)^k\end{bmatrix}.$$

**第四步：部分和**。第 $k$ 项是

$$\frac{1}{k}A^k=\begin{bmatrix}\dfrac{(-1)^k}{k}&\dfrac{k(-1)^{k-1}}{k}\\[6pt]0&\dfrac{(-1)^k}{k}\end{bmatrix}=\begin{bmatrix}\dfrac{(-1)^k}{k}&(-1)^{k-1}\\[6pt]0&\dfrac{(-1)^k}{k}\end{bmatrix}.$$

**角落那个 $(1,2)$ 元是 $(-1)^{k-1}$，通项不趋于零**！由 [命题 4.6.2](#prop-4.6.2)(3)（通项必趋于零），级数**发散**。

**（对照）若把 $c_k$ 换成 $1/k^2$**：第 $k$ 项为 $\begin{bmatrix}(-1)^k/k^2&(-1)^{k-1}/k\\0&(-1)^k/k^2\end{bmatrix}$，三个非零元素分别是 $\sum(-1)^k/k^2$（绝对收敛）与 $\sum(-1)^{k-1}/k$（交错调和级数，条件收敛）。由 [命题 4.6.2](#prop-4.6.2)(1)，级数**收敛**（但不绝对收敛）。

**这个对照说明了什么**：同样的 $A$、同样的 $\rho(A)=r=1$，换一组 $c_k$ 就从发散变收敛。**边界上的结论完全由 $c_k$ 的衰减速度与 $A$ 的 Jordan 块长度共同决定**——Abel 定理在这里一句话也说不出。

**再对照标量情形**：标量的 $\sum z^k/k$ 在 $z=-1$ 收敛（交错级数），而矩阵的 $\sum A^k/k$ 在 $A=-I$ 发散？**取 $A=-I$（一阶 Jordan 块）时其实也收敛**（$\sum(-1)^k/k$ 收敛）。真正出问题的是 $A=-I+N$ 这种**带 Jordan 块**的情形——$(1,2)$ 元里多出一个因子 $k$，把 $1/k$ 抵消成 $1$。**「不可对角化」在边界上是被放大的。**∎

**这个例子教了两件事**：

1. **边界 $\rho(A)=r$ 时，范数工具全部失效**——[定理 4.5.2](sec45.md#thm-4.5.2) 给不出 $\|A\|\lt r$，只能给 $\|A\|\le r+\varepsilon$，而 $\sum c_k(r+\varepsilon)^k$ 在 $r$ 处已经不收敛了，多出来的 $\varepsilon$ 救不了；
2. **必须逐个元素算**：发散的证据是「某个元素的通项不趋于零」（本题 $(-1)^{k-1}$），收敛的证据是「每个元素的级数收敛」（换 $1/k^2$ 后 $(1,2)$ 元是交错级数）。
:::
:::

::: cor 推论 4.6.4（课件原文）· 整函数给出处处收敛的矩阵幂级数 {#cor-4.6.4}

若幂级数 $\sum\limits_{m=0}^{\infty}c_mz^m$ 在整个复平面上都收敛（即 $r=\infty$），则对任意复方阵 $A$，矩阵幂级数 $\sum\limits_{m=0}^{\infty}c_mA^m$ 收敛。
:::

::: proof 证明（本编补两行）

$r=\infty$ 时对任何 $A$ 都有 $\rho(A)\lt r=\infty$，由 [定理 4.6.5](#thm-4.6.5)(1) 得绝对收敛，从而收敛。∎

**这就是「矩阵函数」的定义依据**：$e^A$、$\sin A$、$\cos A$ 的幂级数都有 $r=\infty$，所以对**任意** $A$ 都有意义。而 $1/(1-A)$ 的幂级数 $\sum A^m$ 有 $r=1$，所以只在 $\rho(A)\lt1$ 时可用——这个差别正是下一小节 Neumann 级数的内容。
:::

::: ex 例 4.6.8（课件原文）· $e^A$ 对任意 $A$ 有定义 {#ex-4.6.8}

已知 $e^z=\sum\limits_{k=0}^{\infty}\dfrac{1}{k!}z^k$ 对任意复数 $z$ 都收敛，则对任意复方阵 $A$，矩阵幂级数 $\sum\limits_{k=0}^{\infty}\dfrac{1}{k!}A^k$ 收敛。

::: sol 说明（本编补一句证明）

这是 [推论 4.6.4](#cor-4.6.4) 的直接应用：$c_k=1/k!$ 的收敛半径 $r=\infty$（比值判别法：$\big|c_{k+1}/c_k\big|=1/(k+1)\to0$），故对任意 $A$ 都有 $\rho(A)\lt\infty$，级数绝对收敛。**这就是 $e^A$ 的定义**：

$$e^A=\sum_{k=0}^{\infty}\frac{A^k}{k!}.$$

**一个立刻可得的性质**：$\|e^A\|\le\sum\|A\|^k/k!=e^{\|A\|}$——指数函数的矩阵版被标量版控制。这个估计在 4.7 的矩阵函数与微分方程里反复使用。∎
:::
:::

::: cor 推论 4.6.5（课件原文）· Neumann 级数 {#cor-4.6.5}

矩阵幂级数 $\sum\limits_{m=0}^{\infty}A^m$ 收敛**当且仅当** $\rho(A)\lt1$，此时

$$\sum_{m=0}^{\infty}A^m=(I-A)^{-1}.$$
:::

::: proof 证明（本编补：敛散性用 Abel 定理，求和用部分和恒等式）

**敛散性**。$\sum z^m$ 的收敛半径 $r=1$（$|z|\lt1$ 收敛、$|z|\ge1$ 通项不趋于零）。由 [定理 4.6.5](#thm-4.6.5)：

- $\rho(A)\lt1=r$ $\Rightarrow$ 绝对收敛；
- $\rho(A)\gt1=r$ $\Rightarrow$ 发散。

$\rho(A)=1$ 时由 [注 1](#note-4.6-1)：$A=I$ 给出 $\sum I$ 通项为 $I\ne O$，发散；而 $\rho(A)\lt1$ 的反面是 $\rho(A)\ge1$，取 $|\lambda|=\rho\ge1$ 的特征方向，$\sum A^m\boldsymbol x=\big(\sum\lambda^m\big)\boldsymbol x$ 发散（$\lambda^m$ 不趋于零）。所以「$\iff\rho(A)\lt1$」成立。

**求和**。设 $\rho(A)\lt1$（此时各 $A^m$ 都在，级数收敛）。用恒等式

$$(I-A)\sum_{m=0}^{N}A^m=I-A^{N+1}$$

（望远镜求和：$(I-A)(I+A+\cdots+A^N)=I-A^{N+1}$）。由 $\rho(A)\lt1$ 与 [定理 4.6.3](#thm-4.6.3)，$A^{N+1}\to O$，故右端 $\to I$。两边取极限：

$$(I-A)\sum_{m=0}^{\infty}A^m=I .$$

**$I-A$ 可逆**（$\rho(A)\lt1$ 时 $1\notin Sp(A)$），故左乘 $(I-A)^{-1}$ 得 $\sum A^m=(I-A)^{-1}$。∎

**与 [定理 4.3.6](sec43.md#thm-4.3.6) 的关系**：那里是「$\|A\|\lt1\Rightarrow I-A$ 可逆且 $\|(I-A)^{-1}\|\le\|I\|/(1-\|A\|)$」，这里是「$\rho(A)\lt1\iff\sum A^m$ 收敛且和为 $(I-A)^{-1}$」。后者**更强**：

- 条件从「某把范数 $\lt1$」放宽到「谱半径 $\lt1$」（例如 [思考](#think-4.6-normnotboth) 里的 $A$ 满足 $\rho=0.1\lt1$ 而 $\|A\|_\infty=1.1\gt1$，Neumann 级数依然收敛）；
- 结论从「可逆 + 范数界」升级到「**显式地把逆写成级数**」，从而可以截断近似、可以逐项求导积分。

**代价**：$\rho(A)$ 比 $\|A\|$ 难算。所以实践中常常是「**先用便宜的范数判一次（若 $\|A\|\lt1$ 就用定理 4.3.6），判不了再上谱半径**」。
:::

::: ex 例 4.6.9（课件原文）· 判一个具体的幂级数 {#ex-4.6.9}

判断幂级数 $\sum\limits_{m=1}^{\infty}A^m$ 的敛散性，其中

$$A=\begin{bmatrix}0.2&0.5&0.2\\0.1&0.5&0.3\\0.1&0.4&0.2\end{bmatrix}.$$

::: sol 解答（本编补：三条判据一起用，互相校验）

**先看它的行和**：三行之和分别是 $0.2+0.5+0.2=0.9$、$0.1+0.5+0.3=0.9$、$0.1+0.4+0.2=0.7$。**不是行随机矩阵**（行随机要求每行之和为 $1$），所以不能直接套马氏链那一套；它只是「行和都小于 $1$」。这个观察已经足够——见判据 1。

**判据 1：范数（最便宜）**。行和 $0.9,\ 0.9,\ 0.7$，故

$$\|A\|_\infty=0.9\lt1 .$$

由 [推论 4.6.2](#cor-4.6.2)（或 [定理 4.3.6](sec43.md#thm-4.3.6)），$\sum A^m$ **收敛**，且和为 $(I-A)^{-1}-I$。

**判据 2：圆盘（看位置）**。半径 $\delta_1=0.7,\ \delta_2=0.4,\ \delta_3=0.5$；三个圆盘 $G_1=[-0.5,0.9]$、$G_2=[0.1,0.9]$、$G_3=[-0.3,0.7]$ **连成一片**，且都在 $[-0.5,0.9]$ 内，**不含 $1$**。故 $1\notin Sp(A)$，$I-A$ 可逆，且 $\rho(A)\le0.9\lt1$——与判据 1 一致。

**判据 3：精确算谱半径**。特征多项式

$$\det(\lambda I-A)=\lambda^3-0.9\lambda^2+0.05\lambda+0.001 ,$$

其根约为 $\lambda_1\approx0.8390$、$\lambda_2\approx0.0766$、$\lambda_3\approx-0.0156$（`verify_teaching_examples.py` 精确验证）。故 $\rho(A)\approx0.839\lt1$，**收敛**。

**答案**：级数收敛，$\sum\limits_{m=1}^{\infty}A^m=(I-A)^{-1}-I$，其中

$$(I-A)^{-1}\approx\begin{bmatrix}1.8543&3.1788&1.6556\\0.7285&4.1060&1.7219\\0.5960&2.4503&2.3179\end{bmatrix}.$$

于是 $\sum_{m\ge1}A^m=(I-A)^{-1}-I\approx\begin{bmatrix}0.8543&3.1788&1.6556\\0.7285&3.1060&1.7219\\0.5960&2.4503&1.3179\end{bmatrix}$。∎

**三条判据的分工**（这个例子是完美的示范）：

| 判据 | 代价 | 给出 | 本例结论 |
|:--|:--|:--|:--|
| $\|A\|_\infty\lt1$ | 一眼 | 收敛 | 0.9 ✓ |
| 盖尔圆不含 $1$ | 一行加法 | $I-A$ 可逆、$\rho$ 上界 | $[-0.5,0.9]$ ✓ |
| 特征多项式求根 | 三次方程 | 精确 $\rho$ | 0.839 |

**实践顺序**：先看范数，不行看圆盘，都不行才解多项式。**能用便宜的就不用贵的**——这是本章反复出现的经济学。
:::
:::

<a id="fig-abel-anchor"></a>

{{#include ../assets/figures/matrix-abel.md}}

::: note 注 3（课件原文）· 矩阵与逆可交换 {#note-4.6-3}

可逆矩阵 $(I-A)^{-1}$ 与矩阵 $A$ 的乘积**可交换**：

$$(I-A)^{-1}A=A(I-A)^{-1} .$$

这是基于幂级数的定义推导的。实际上，所有可展开成幂级数的矩阵都具有这一性质。

**本编补证明**：设 $\rho(A)\lt1$，由 [推论 4.6.5](#cor-4.6.5)

$$(I-A)^{-1}=\sum_{m\ge0}A^m .$$

右端每一项都是 $A$ 的多项式（也就是 $A$ 的非负整数幂），而 $A$ 与自己的幂当然可交换，故

$$(I-A)^{-1}A=\Big(\sum_{m\ge0}A^m\Big)A=\sum_{m\ge0}A^{m+1}=A\sum_{m\ge0}A^m=A(I-A)^{-1}.$$

**不用级数也能证**（更短）：由 $A=I-(I-A)$，直接算

$$(I-A)^{-1}A=(I-A)^{-1}\big[I-(I-A)\big]=(I-A)^{-1}-I ,$$

$$A(I-A)^{-1}=\big[I-(I-A)\big](I-A)^{-1}=(I-A)^{-1}-I .$$

两式相等。**这个证明不用级数，只用了逆的定义**，因此它对**所有**使 $I-A$ 可逆的 $A$ 成立，与 $\rho(A)\lt1$ 无关。∎

**课件接着给的例子**：当 $|z|\lt1$ 时 $\sum\limits_{k=0}^{\infty}kz^k=\dfrac{z}{(1-z)^2}$。相应地令 $\rho(A)\lt1$，有

$$\sum_{k=0}^{\infty}kA^k=A(I-A)^{-2}=(I-A)^{-2}A=(I-A)^{-1}A(I-A)^{-1} .$$

**本编补这一步怎么来的**：这是「幂级数逐项求导」的矩阵版。对标量恒等式 $\sum kz^k=\dfrac{z}{(1-z)^2}$ 逐项对照，把 $z\rightsquigarrow A$、$1\rightsquigarrow I$：

$$\sum_{k\ge0}kA^k=A\sum_{k\ge0}kA^{k-1}=A\cdot\frac{d}{dA}\Big[\sum_{m\ge0}A^m\Big]=A\cdot\frac{d}{dA}(I-A)^{-1}=A(I-A)^{-2}.$$

最后的求导用了 $\dfrac{d}{dX}(I-X)^{-1}=(I-X)^{-2}$（对矩阵也成立，见 4.7 矩阵函数）。中间两个等号用 [注 3](#note-4.6-3)：$A$ 与 $(I-A)^{-1}$、$(I-A)^{-2}$ 都可交换。∎
:::

::: ex 例 4.6.A（新增）· 用 Neumann 级数算逆并估误差 {#ex-4.6.A}

设 $A=\begin{bmatrix}0&0.5\\0.5&0\end{bmatrix}$。(a) 验证 $\rho(A)\lt1$；(b) 用前 $4$ 项近似 $(I-A)^{-1}$，给出误差界；(c) 与精确逆比较。

::: sol 解答

**(a)** $A$ 的特征值满足 $\lambda^2-0.25=0$，故 $\lambda=\pm0.5$，$\rho(A)=0.5\lt1$。又 $\|A\|_\infty=0.5\lt1$（[推论 4.6.2](#cor-4.6.2) 也直接适用）。

**(b)** 由 [推论 4.6.5](#cor-4.6.5)，$(I-A)^{-1}=\sum_{m\ge0}A^m$。注意 $A^2=0.25I$，故

$$A^{2l}=0.25^lI,\qquad A^{2l+1}=0.25^lA .$$

前 $4$ 项（$m=0,1,2,3$）之和为

$$S_3=I+A+0.25I+0.25A=1.25I+1.25A=\begin{bmatrix}1.25&0.625\\0.625&1.25\end{bmatrix}.$$

**误差**：由 $\|A^m\|\le\|A\|^m$，截断误差

$$\Big\|(I-A)^{-1}-S_3\Big\|=\Big\|\sum_{m\ge4}A^m\Big\|\le\sum_{m\ge4}\|A\|^m=\frac{\|A\|^4}{1-\|A\|}=\frac{1/16}{1/2}=\frac18 .$$

取 $\|\cdot\|_\infty$：$\|A\|_\infty=0.5$，故误差 $\le\dfrac{0.5^4}{0.5}=0.125$。

**(c)** 精确值：$I-A=\begin{bmatrix}1&-0.5\\-0.5&1\end{bmatrix}$，$\det=0.75$，

$$(I-A)^{-1}=\frac{1}{0.75}\begin{bmatrix}1&0.5\\0.5&1\end{bmatrix}=\begin{bmatrix}\frac43&\frac23\\\frac23&\frac43\end{bmatrix}\approx\begin{bmatrix}1.3333&0.6667\\0.6667&1.3333\end{bmatrix}.$$

实际误差 $=\begin{bmatrix}0.0833&0.0417\\0.0417&0.0833\end{bmatrix}$，**行和为 $0.125$**，故 $\infty$-范数 $=0.125$——**恰好取到上界**！（注意别按「最大元素」读：最大元素只有 $0.0833$，$\infty$-范数是行和。）∎
:::

**为什么取等**：$\|A\|_\infty=0.5$ 是在 $x=(1,1)^{\mathrm T}$ 处取到的，而这个方向恰好也是 $A^m$ 的「全正」方向。**界是保底的，本例恰好是最坏情况。**
:::

::: ex 例 4.6.C（新增）· 同一个 $A$，三种收敛速度 {#ex-4.6.C}

设 $A=\begin{bmatrix}0.6&0.5\\0&0.6\end{bmatrix}$。(a) 算 $\|A\|_1,\|A\|_\infty,\rho(A)$；(b) 判断 $\sum A^m$ 是否收敛；(c) 用 $\|A\|$ 控制的误差界与真实截断误差比较，说明「用谱半径估会差多少」。

::: sol 解答

**(a)** $\|A\|_\infty=\max\{1.1,\ 0.6\}=1.1$；$\|A\|_1=\max\{0.6,\ 1.1\}=1.1$；上三角，特征值即对角元，$\rho(A)=0.6$。

**(b)** $\rho(A)=0.6\lt1$，由 [推论 4.6.5](#cor-4.6.5)，$\sum A^m$ **收敛**，和为 $(I-A)^{-1}$。**注意 $\|A\|_\infty=1.1\gt1$，范数判据在这里失效**——这正是 [思考](#think-4.6-normnotboth) 的情形（$\|A\|\gt1$ 但 $\rho(A)\lt1$）。

**(c)** 取 $N=10$ 项截断：误差 $=\sum_{m\gt N}A^m=A^{N+1}(I-A)^{-1}$。由 $A^m=\begin{bmatrix}0.6^m&0.5m\cdot0.6^{m-1}\\0&0.6^m\end{bmatrix}$，

$$(I-A)^{-1}=\begin{bmatrix}2.5&3.125\\0&2.5\end{bmatrix},\qquad \sum_{m\gt10}A^m=\begin{bmatrix}0.00907&0.09448\\0&0.00907\end{bmatrix},\qquad \Big\|\sum_{m\gt10}A^m\Big\|_\infty\approx0.1035 .$$

- **用 $\|A\|_\infty=1.1$ 估**：公式 $\dfrac{\|A\|^{N+1}}{1-\|A\|}$ 的分母为负——$\|A\|\gt1$ 时这条界**根本不可用**；
- **用 $\rho(A)=0.6$ 看衰减率**：对角元误差是 $\sum\limits_{m\gt10}0.6^m=\dfrac{0.6^{11}}{0.4}\approx0.00907$，正是 $0.6^N$ 的指数衰减——**收敛速度由谱半径决定**。

**结论**：**「收不收敛」看 $\rho(A)$，「误差界怎么算」要看 $\|A\|$ 是否 $\lt1$**。$\|A\|\ge1$ 时想写误差界，必须先按 [定理 4.5.2](sec45.md#thm-4.5.2) 换一把定制范数（如 $D=\operatorname{diag}(1,\varepsilon)$ 把上三角的 $0.5$ 压下去），或直接用 $(I-A)^{-1}$ 的显式表达式算。∎
:::
:::

## 4.6 小结与常见错误

- **一条主线**：**序列**（[定义 4.6.1](#def-4.6.1)–[4.6.3](#def-4.6.3)，[范数 / 坐标 / 元素三等价](#thm-4.6.2)）$\Rightarrow$ **级数**（[定义 4.6.4](#def-4.6.4)、[逐元素判](#prop-4.6.2)、[绝对收敛](#def-4.6.5)–[范数刻画](#thm-4.6.4)）$\Rightarrow$ **幂级数**（[Abel 型定理](#thm-4.6.5)：$\rho$ 与 $r$ 比大小）$\Rightarrow$ **Neumann**（[$\rho\lt1\iff\sum A^m$ 收敛](#cor-4.6.5)）。
- **一条对应**：**「收敛」$\leftrightarrow$「谱半径」，「多快收敛」$\leftrightarrow$「$\|A\|$」**。前者是 0/1 判断（只看最远的特征值），后者是速度（由范数决定）。两者分工，不能互换。

::: think 常见错误清单 · 自查五条

1. **把 $\|A\|\lt1$ 当成必要条件**：$A^k\to O$ 的充要条件是 $\rho(A)\lt1$（[定理 4.6.3](#thm-4.6.3)）；$\|A\|_\infty=1.1$ 的矩阵照样可以收敛（[思考](#think-4.6-normnotboth)）；
2. **在边界 $\rho(A)=r$ 上直接引用 Abel 定理**：定理在边界**失效**（[注 1](#note-4.6-1)）；必须逐元素算，见 [例 4.6.7](#ex-4.6.7)；
3. **把「收敛」当「绝对收敛」**：$\sum A_k$ 收敛 ⇏ 绝对收敛（[例 4.6.5](#ex-4.6.5)）；而重排、交换求和序、逐项求导都需要绝对收敛；
4. **忘记「通项必趋于零」**：判断发散最快的路是看某个元素的通项（[命题 4.6.2](#prop-4.6.2)(3)）；[例 4.6.7](#ex-4.6.7) 就是因为 $(-1)^{k-1}$ 不趋于零而发散；
5. **Neumann 级数写错起点**：$\sum_{m=0}^{\infty}A^m=(I-A)^{-1}$，但 $\sum_{m=1}^{\infty}A^m=(I-A)^{-1}-I$（[例 4.6.9](#ex-4.6.9)）；差一个 $I$ 是常错点。
:::

::: ex 即时自测（不看上文，6 分钟）{#ex-4.6.quiz}

1. 写出向量序列按范数收敛的定义；为什么有限维空间里「按范数收敛」与「按坐标收敛」等价？
2. 写出矩阵级数收敛的充要条件（用元素级数表述），并说明「通项必趋于零」为什么只是必要条件。
3. 叙述 Abel 型定理的两个结论；边界 $\rho(A)=r$ 时怎么办？
4. 说出 Neumann 级数的条件、结论与和；它与 [定理 4.3.6](sec43.md#thm-4.3.6) 相比强在哪里？
5. 判断 $\sum A^m$ 的敛散性，$A=\begin{bmatrix}0.8&1\\0&0.8\end{bmatrix}$，并说明范数判据能否直接用。

::: sol 参考要点

1. $\lim\|\boldsymbol x_k-\boldsymbol x\|_\alpha=0$；用 [定理 4.1.2](sec41.md#thm-4.1.2) 把坐标范数 $\|\cdot\|_\infty$ 夹在任意范数两侧，两边相互推出。
2. $\sum A_k$ 收敛 $\iff$ 每个 $\sum a_{ij}^{(k)}$ 收敛；通项趋于零只是必要条件（调和级数通项趋于零但发散），充分性需要比较 / 比值等判别法。
3. $\rho(A)\lt r\Rightarrow$ 绝对收敛；$\rho(A)\gt r\Rightarrow$ 发散；边界需逐元素按定义判断（[例 4.6.7](#ex-4.6.7)）。
4. $\rho(A)\lt1\iff\sum_{m\ge0}A^m$ 收敛，和为 $(I-A)^{-1}$；比 [定理 4.3.6](sec43.md#thm-4.3.6) 的条件从「某范数 $\lt1$」放宽到「谱半径 $\lt1$」，并把逆写成显式级数。
5. $\rho(A)=0.8\lt1$，故**收敛**；但 $\|A\|_\infty=\max\{1.8,0.8\}=1.8\gt1$、$\|A\|_1=0.8$——**用 $\|\cdot\|_1$ 可以直接判**（$0.8\lt1$），用 $\|\cdot\|_\infty$ 判不了。这正好说明「换一把范数」的价值。
:::
:::
