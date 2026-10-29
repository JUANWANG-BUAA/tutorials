# 4.3 相容范数

4.1 给向量配了尺子，4.2 给矩阵配了尺子。但真正做题时，两把尺子要一起用：用 $\|x\|$ 量输入，用 $\|A\|$ 量矩阵，用 $\|Ax\|$ 量输出。如果三者之间没有关系，估计就无从下手。

需要的正是下面这条不等式：

$$\|Ax\|_v\le\|A\|_m\|x\|_v .$$

它说「输出的长度不超过『矩阵的大小』乘『输入的长度』」——这是所有误差估计、收敛性证明、扰动分析的**第一块砖**。满足它的向量范数与矩阵范数，称为**相容**的。

本节分四步：先定义相容并证明「两个方向都能配出配套的尺子」（4.3.1）；再给出三个可以手算的诱导范数公式（4.3.2）；然后用 Rayleigh 商把谱范数与特征值连起来，得到 Courant–Fischer 与 Weyl 扰动不等式（4.3.3）；最后用它估计 $I-A$ 的逆（4.3.4）。

::: note 素材与说明（本节无录播）

本页依据课程第四章课件 4.3 节（`_sources/matrix/4.1-4.3 矩阵范数.pdf` 第 42–68 页）整理。**本节无对应录播**：课件的定义、定理、注记、例题**照录并保留原编号**（定义 4.3.1、定理 4.3.1–4.3.6、推论 4.3.1、注 1–注 4、例 4.3.1–4.3.2）；课件省略的证明与未给答案的提问由本编补出。4.3 有两处编号问题（算子范数公式被编成「定理 4.2.3」、两个「注 4」），正文按出现次序记为[定理 4.3.3](#thm-4.3.3) 与[注 3′](#note-4.3-hierarchy)，详见[勘误](errata.md)。
:::

<a id="sec-4.3.1"></a>

## 4.3.1 相容：两把尺子必须配套

::: def 定义 4.3.1 · 向量范数与矩阵范数相容 {#def-4.3.1}

若对 $A\in\mathbb C^{m\times n}$ 和 $x\in\mathbb C^n$，向量范数 $\|x\|_v$ 与矩阵范数 $\|A\|_m$ 满足

$$\|Ax\|_v\le\|A\|_m\|x\|_v ,$$

则称向量范数 $\|x\|_v$ 与矩阵范数 $\|A\|_m$ **相容**。
:::

**隐含在范数对矩阵乘法的相容性中，但又有所区别**（课件原话）：矩阵范数的第四条公理是 $\|AB\|\le\|A\|\|B\|$，管的是**矩阵乘矩阵**；这里的相容管的是**矩阵乘向量**。前者不能自动推出后者——这正是本节要单独讨论的原因。

::: ex 例 4.3.1（课件原文）· 2-范数与 $F$-范数相容 {#ex-4.3.1}

由 [定理 4.2.3](../ch04/sec42.md#thm-4.2.3) 可知，对任意矩阵 $A\in\mathbb C^{m\times n}$ 和 $x\in\mathbb C^n$，$\|Ax\|_2\le\|A\|_F\|x\|_2$。由此，**向量 2-范数和矩阵 $F$-范数是相容的**。
:::

::: think 思考 · 给定一把尺子，能配出另一把吗？（课件） {#think-4.3-existence}

课件提出两个方向的问题：

1. **给定矩阵范数，是否存在与之相容的向量范数？**
2. **反之，给定向量范数，是否存在与之相容的矩阵范数？**

**答案：两个方向都是「存在」，但构造方式完全不同。**

- 方向 1 的答案叫[定理 4.3.1](#thm-4.3.1)：用 $\|x\|_v=\|x\alpha^{\mathrm T}\|_m$ 造一个向量范数；
- 方向 2 的答案叫[定理 4.3.2](#thm-4.3.2)：用 $\|A\|=\max_{\|x\|_v=1}\|Ax\|_v$ 造一个矩阵范数，而且造出来的是**最紧**的一把——诱导范数。

两个构造合起来说明：**「相容」不是碰巧，而是可以按需定制。**
:::

::: thm 定理 4.3.1 · 矩阵范数必有相容的向量范数（课件原文） {#thm-4.3.1}

设 $\|A\|_m$ 是 $\mathbb C^{n\times n}$ 的一个矩阵范数，则必存在 $\mathbb C^n$ 上与之相容的向量范数。
:::

::: proof 证明（课件原文，本编补细节）

取定任意非零向量 $\alpha\in\mathbb C^n$，定义

$$\|x\|_v=\|x\alpha^{\mathrm T}\|_m .$$

（$x\alpha^{\mathrm T}$ 是 $n\times n$ 矩阵，其第 $i$ 行是 $x_i\alpha^{\mathrm T}$。）

**(1) 正定性**：$\|x\|_v\ge0$；等号成立当且仅当 $x\alpha^{\mathrm T}=O$。由于 $\alpha\ne\boldsymbol0$，$x\alpha^{\mathrm T}=O\iff x=\boldsymbol0$。

**(2) 齐次性**：显然（$kx\alpha^{\mathrm T}=k(x\alpha^{\mathrm T})$，用矩阵范数的齐次性）。

**(3) 三角不等式**：$x\alpha^{\mathrm T}+y\alpha^{\mathrm T}=(x+y)\alpha^{\mathrm T}$，用矩阵范数的三角不等式。

**(4) 相容性**：

$$\|Ax\|_v=\|Ax\alpha^{\mathrm T}\|_m=\|A\,(x\alpha^{\mathrm T})\|_m\le\|A\|_m\|x\alpha^{\mathrm T}\|_m=\|A\|_m\|x\|_v .\qquad\blacksquare$$

**证明的要点**：把「向量 $x$」升级成「秩不超过 $1$ 的矩阵 $x\alpha^{\mathrm T}$」，于是**矩阵乘法 $A(x\alpha^{\mathrm T})$ 就模拟了矩阵乘向量 $Ax$**；矩阵范数的相容性随即变成向量层面的相容性。$\alpha$ 可以任取非零，说明这样的向量范数有无穷多个。
:::

::: thm 定理 4.3.2 · 诱导范数（算子范数）（课件原文） {#thm-4.3.2}

设 $\|x\|_v$ 是 $\mathbb C^n$ 上的一个向量范数，对任意 $A\in\mathbb C^{m\times n}$，定义

$$\|A\|=\max_{\|x\|_v=1}\|Ax\|_v ,$$

则 $\|A\|$ 是一个与 $\|x\|_v$ 相容的矩阵范数，称其是**从属于向量范数 $\|\cdot\|_v$ 的算子范数**或**由向量范数 $\|\cdot\|_v$ 诱导的矩阵范数**（或简称**诱导范数**）。
:::

::: note 注 1 · 最大值为什么取得到（课件原文） {#note-4.3-existence}

因为 $\|Ax\|_v$ 是 $x$ 各分量的连续函数，故在**有界闭集** $\|x\|_v=1$ 可取到最大值。因此，上述定义有意义的。
:::

::: proof 证明（课件原文四步，本编补「正定性」的完整推理）

**正定性**：$\|A\|\ge0$。若 $A=O$，则 $\|A\|=0$。反之设 $\|A\|=0$，则对任意 $\|x\|_v=1$ 有 $Ax=\boldsymbol0$；由齐次性，对任意 $x\ne\boldsymbol0$ 有 $A\big(x/\|x\|_v\big)=\boldsymbol0$，故 $Ax=\boldsymbol0$ 对一切 $x$ 成立，于是 $A=O$。

（课件此处写「$Ax=\boldsymbol0$ 的解空间维数为 $n$，$A=O$」——本编把它展开成上面两步：**单位球面上处处为零 $\Rightarrow$ 全空间为零 $\Rightarrow$ 矩阵为零**。）

**齐次性**：显然（$\max$ 中的被取函数整体乘 $|k|$）。

**三角不等式**：存在 $y$（$\|y\|_v=1$）使 $\|A+B\|=\|(A+B)y\|_v$，于是

$$\|A+B\|=\|(A+B)y\|_v\le\|Ay\|_v+\|By\|_v\le\|A\|+\|B\| .$$

**矩阵乘法相容性**：存在 $y$（$\|y\|_v=1$）使 $\|AB\|=\|ABy\|_v$。记 $z=By$，若 $\|z\|_v=0$ 则命题显然成立；否则

$$\|AB\|=\Big\|A\frac{z}{\|z\|_v}\Big\|_v\|z\|_v\le\|A\|\,\|B\| ,$$

其中用了 $\|z\|_v=\|By\|_v\le\|B\|$ 与 $\big\|z/\|z\|_v\big\|_v=1$。

**矩阵范数和向量范数相容**：若 $x=\boldsymbol0$，相容性显然成立；若 $x\ne\boldsymbol0$，令 $y=\dfrac{x}{\|x\|_v}$，则 $\|y\|_v=1$，于是

$$\|Ax\|_v=\|Ay\|_v\|x\|_v\le\|A\|\,\|x\|_v .\qquad\blacksquare$$
:::

::: note 注 1′ · 算子范数的等价定义与三个名字（课件原文） {#note-4.3-opdef}

我们常用到算子范数有如下等价定义式：

$$\|A\|=\max_{\|x\|_v\ne0}\frac{\|Ax\|_v}{\|x\|_v} .$$

常见的向量范数有 $\|x\|_1,\|x\|_\infty,\|x\|_2$，则从属于它们的算子范数分别记为 $\|A\|_1,\|A\|_\infty,\|A\|_2$，并分别称为**列和范数**、**行和范数**和**谱范数**。

**本编补一句**：等价性来自齐次性——任何 $x\ne\boldsymbol0$ 都可写成 $x=\|x\|_v\cdot y$（$\|y\|_v=1$），比值 $\|Ax\|_v/\|x\|_v=\|Ay\|_v$，所以「所有非零 $x$ 的上确界」就是「单位球面上的最大值」。
:::

<a id="sec-4.3.2"></a>

## 4.3.2 三个显式公式：列和、行和、谱

定义里的 $\max$ 是在单位球面上取的，不能直接手算。幸运的是，三个最常用的向量范数诱导出的矩阵范数都有**闭式**。

::: thm 定理 4.3.3 · 三个诱导范数的显式公式（课件原文，原编号误作「定理 4.2.3」） {#thm-4.3.3}

设 $A=(a_{ij})\in\mathbb C^{m\times n}$，$\sigma_{\max}(A)$ 是矩阵 $A$ 的最大奇异值，则从属于向量范数 $\|x\|_1$、$\|x\|_\infty$、$\|x\|_2$ 的算子范数分别为

$$\|A\|_1=\max_{1\le j\le n}\sum_{i=1}^{m}|a_{ij}|\quad(\text{列和范数}),$$

$$\|A\|_\infty=\max_{1\le i\le m}\sum_{j=1}^{n}|a_{ij}|\quad(\text{行和范数}),$$

$$\|A\|_2=\sqrt{\lambda_{\max}(A^{\mathrm H}A)}=\sigma_{\max}(A)\quad(\text{谱范数}).$$

**注**：$\|A\|$ 不一定等于 $\|A^{\mathrm T}\|$。
:::

::: proof 证明 · $\|A\|_1$ 是列和范数（课件原文）

对于 $\|x\|_1=1$，先证 $\|Ax\|_1\le\max\limits_{1\le j\le n}\sum\limits_{i=1}^{m}|a_{ij}|$：

$$\|Ax\|_1=\sum_{i=1}^{m}\Big|\sum_{j=1}^{n}a_{ij}x_j\Big|\le\sum_{i=1}^{m}\sum_{j=1}^{n}|a_{ij}x_j|=\sum_{j=1}^{n}|x_j|\sum_{i=1}^{m}|a_{ij}|\le\max_{1\le j\le n}\sum_{i=1}^{m}|a_{ij}| .$$

再取到上界：假设当 $j=j_0$ 时 $\sum_{i=1}^{m}|a_{ij_0}|=\max\limits_{1\le j\le n}\sum_{i=1}^{m}|a_{ij}|$，取 $x=e_{j_0}$（第 $j_0$ 个标准基向量，$\|e_{j_0}\|_1=1$），则

$$\|Ax\|_1=\sum_{i=1}^{m}|a_{ij_0}|=\max_{1\le j\le n}\sum_{i=1}^{m}|a_{ij}| .$$

上下界相等，命题成立。∎

**读法**：$\|A\|_1$ 是「**最胖的那一列**」的元素绝对值之和。取到它的 $x$ 就是该列对应的标准基向量。
:::

::: proof 证明 · $\|A\|_\infty$ 是行和范数（课件原文）

对于 $\|x\|_\infty=1$，先证 $\|Ax\|_\infty\le\max\limits_{1\le i\le m}\sum\limits_{j=1}^{n}|a_{ij}|$：

$$\|Ax\|_\infty=\max_{1\le i\le m}\Big|\sum_{j=1}^{n}a_{ij}x_j\Big|\le\max_{1\le i\le m}\sum_{j=1}^{n}|a_{ij}|\,\|x\|_\infty .$$

再取到上界：假设当 $i=i_0$ 时 $\sum_{j=1}^{n}|a_{i_0j}|=\max\limits_{1\le i\le m}\sum_{j=1}^{n}|a_{ij}|$，取 $x_0=[\mu_1,\mu_2,\cdots,\mu_n]^{\mathrm T}$，其中

$$\mu_j=\begin{cases}\dfrac{|a_{i_0j}|}{a_{i_0j}},&a_{i_0j}\ne0,\\[6pt] 1,&a_{i_0j}=0 .\end{cases}$$

则 $\|x_0\|_\infty=1$，且 $a_{i_0j}\mu_j=|a_{i_0j}|$，故

$$\|Ax_0\|_\infty=\sum_{j=1}^{n}|a_{i_0j}|=\max_{1\le i\le m}\sum_{j=1}^{n}|a_{ij}| .\qquad\blacksquare$$

**读法**：$\|A\|_\infty$ 是「**最胖的那一行**」的元素绝对值之和。取到它的 $x$ 是「该行元素的相位」——把每个 $a_{i_0j}$ 都转成正实数再相加。
:::

::: proof 证明 · 谱范数（课件只给结论，本编补：用谱定理把 $A^{\mathrm H}A$ 对角化）

$A^{\mathrm H}A$ 是 Hermite 半正定矩阵（[3.1](../ch03/sec31.md#prop-3.1.1)），由谱定理（[3.6](../ch03/sec36.md)）存在酉矩阵 $U$ 使

$$A^{\mathrm H}A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H},\qquad \lambda_1\ge\cdots\ge\lambda_n\ge0 .$$

对任意 $x\ne\boldsymbol0$，令 $y=U^{\mathrm H}x$，则 $\|y\|_2=\|x\|_2$，且

$$\|Ax\|_2^2=x^{\mathrm H}A^{\mathrm H}Ax=y^{\mathrm H}\operatorname{diag}(\lambda_1,\cdots,\lambda_n)y=\sum_{i=1}^{n}\lambda_i|y_i|^2\le\lambda_1\sum_{i=1}^{n}|y_i|^2=\lambda_1\|x\|_2^2 .$$

故 $\|A\|_2\le\sqrt{\lambda_1}$。取 $x=Ue_1$（$A^{\mathrm H}A$ 的属于 $\lambda_1$ 的单位特征向量），则 $\|Ax\|_2^2=\lambda_1$，等号成立。于是

$$\|A\|_2=\sqrt{\lambda_{\max}(A^{\mathrm H}A)}=\sigma_{\max}(A).\qquad\blacksquare$$

**读法**：谱范数是「**最大的奇异值**」，也就是「$A$ 把单位球拉成椭球后，最长的那根半轴」。
:::

::: note 注 2 · 相容于同一向量范数的矩阵范数有多个（课件原文 + 本编补等号情形） {#note-4.3-multi}

由 [定理 4.2.3](../ch04/sec42.md#thm-4.2.3) 知，$\|A\|_F$ 与 $\|x\|_2$ 是相容的，而 $\|A\|_2$ 作为从属于 $\|x\|_2$ 的算子范数，自然也是相容的，所以**相容于同一向量范数的矩阵范数有多个**。事实上，我们总有

$$\|A\|_2\le\|A\|_F .$$

**若相等，是什么情况呢？**（课件提问，本编补）

设 $A$ 的奇异值为 $\sigma_1\ge\cdots\ge\sigma_r\gt0$，则 $\|A\|_2^2=\sigma_1^2$，$\|A\|_F^2=\sum_{i=1}^{r}\sigma_i^2$。两者相等 $\iff$ 除 $\sigma_1$ 外其余全为零 $\iff$ $\operatorname{rank}A\le1$。

- **秩 $1$ 时取等**：$A=\boldsymbol u\boldsymbol v^{\mathrm H}$，$\|A\|_2=\|\boldsymbol u\|_2\|\boldsymbol v\|_2=\|A\|_F$；
- **秩 $\ge2$ 时严格小于**：多出来的奇异值都在给 $F$-范数「加码」。

[例 4.3.2](#ex-4.3.2) 的 $\sqrt{15}\lt\sqrt{23}$ 就是秩 $3$ 的例子；[例 4.3.A](#ex-4.3.A) 的 $\|A\|_F\approx1.732$ 与 $\|A\|_2\approx1.618$ 也严格不等。
:::

::: note 注 3′ · 向量范数、矩阵范数、算子范数的层级（课件原文，原编号为「注 4」） {#note-4.3-hierarchy}

**矩阵的向量范数不一定是矩阵范数；矩阵的算子范数（诱导范数）一定是矩阵范数，反之未必。**

本编补两个例子把三层分开：

- **是向量范数、不是矩阵范数**：$\max|a_{ij}|$（[4.2 反例](../ch04/sec42.md#think-4.2-maxentry)）；
- **是矩阵范数、不是算子范数**：$\|\cdot\|_F$。因为对任意诱导范数，$\|I_n\|=\max_{\|x\|=1}\|I_nx\|=\max\|x\|=1$；而 $\|I_n\|_F=\sqrt n$。当 $n\ge2$ 时 $\sqrt n\ne1$，所以 $\|\cdot\|_F$ **不可能**由任何向量范数诱导。

于是三层的包含关系是

$$\{\text{诱导范数}\}\subsetneq\{\text{矩阵范数}\}\subsetneq\{\text{矩阵的向量范数}\}.$$
:::

::: ex 例 4.3.2（课件原文）· 四个范数的计算 {#ex-4.3.2}

设 $A=\begin{bmatrix}2&-1&0\\0&2&3\\1&2&0\end{bmatrix}$，分别计算 $\|A\|_1,\|A\|_\infty,\|A\|_2$ 和 $\|A\|_F$。
:::

::: sol 解答（课件给出答案，本编补中间步骤）

**列和**：第 $1,2,3$ 列分别为 $2+0+1=3$、$1+2+2=5$、$0+3+0=3$，故 $\|A\|_1=\max\{3,5,3\}=5$。

**行和**：第 $1,2,3$ 行分别为 $2+1+0=3$、$0+2+3=5$、$1+2+0=3$，故 $\|A\|_\infty=5$。

**Frobenius**：$\|A\|_F=\sqrt{4+1+0+0+4+9+1+4+0}=\sqrt{23}$。

**谱范数**：

$$A^{\mathrm H}A=\begin{bmatrix}2&0&1\\-1&2&2\\0&3&0\end{bmatrix}\begin{bmatrix}2&-1&0\\0&2&3\\1&2&0\end{bmatrix}=\begin{bmatrix}5&0&0\\0&9&6\\0&6&9\end{bmatrix},$$

$$\det(\lambda I-A^{\mathrm H}A)=(\lambda-5)\big[(\lambda-9)^2-36\big]=(\lambda-5)(\lambda-3)(\lambda-15),$$

故 $\lambda_{\max}=15$，$\|A\|_2=\sqrt{15}$。

**答案**：$\|A\|_1=5$，$\|A\|_\infty=5$，$\|A\|_F=\sqrt{23}$，$\|A\|_2=\sqrt{15}$。∎

**注**（课件原文）：$\|A\|_1,\|A\|_\infty$ 容易计算；$\|A\|_2$ 计算复杂，对矩阵元素变化比较敏感。**本编补**：本例 $\|A\|_1=\|A\|_\infty=5$ 只是巧合（列和与行和恰好同最大），一般不等；而 $\sqrt{15}\lt\sqrt{23}$ 验证了 [注 2](#note-4.3-multi) 的 $\|A\|_2\le\|A\|_F$。
:::

<a id="widget-norm-operator"></a>

<div class="widget" data-widget="norm-operator">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">单位球的像：定义、几何与公式必须给出同一个数</strong></p>
<p class="widget-hint">虚线是向量范数的单位球 $B=\{\|x\|_p\le1\}$，填充区是它的像 $A(B)$。蓝色箭头是取到最大值的 $x^{*}$，红色箭头是 $Ax^{*}$；拖动画布可以换一个 $x$，看它的比值怎么变。右边读数同时给出<b>几何最大值</b>与<b>公式值</b>：$p=1$ 是列和 $\max_j\sum_i|a_{ij}|$，$p=\infty$ 是行和 $\max_i\sum_j|a_{ij}|$，$p=2$ 是 $\sqrt{\lambda_{\max}(A^{\mathrm H}A)}$——三者必须相等，这就是<a href="#thm-4.3.3">定理 4.3.3</a>。</p>
</div>

::: ex 例 4.3.A（新增）· 三把尺子读数不同：$A=\begin{bmatrix}1&1\\0&1\end{bmatrix}$ {#ex-4.3.A}

设 $A=\begin{bmatrix}1&1\\0&1\end{bmatrix}$。(a) 计算 $\|A\|_1,\|A\|_\infty,\|A\|_F,\|A\|_2$；(b) 与 [例 4.3.2](#ex-4.3.2) 比较，说明「哪个范数大」没有统一答案；(c) 验证 $\|A\|_2\le\|A\|_F$。

::: sol 解答

**(a)** 列和：$1+0=1$、$1+1=2$，故 $\|A\|_1=2$；行和：$1+1=2$、$0+1=1$，故 $\|A\|_\infty=2$；$\|A\|_F=\sqrt{1+1+0+1}=\sqrt3\approx1.732$。

谱范数：$A^{\mathrm T}A=\begin{bmatrix}1&1\\1&2\end{bmatrix}$，特征值 $\dfrac{3\pm\sqrt5}{2}$，故

$$\|A\|_2=\sqrt{\frac{3+\sqrt5}{2}}=\frac{1+\sqrt5}{2}\approx1.618 .$$

**(b)** 本例 $\|A\|_2\approx1.618\lt\|A\|_1=\|A\|_\infty=2$；而 [例 4.3.2](#ex-4.3.2) 中 $\|A\|_2=\sqrt{15}\approx3.873\lt5=\|A\|_1=\|A\|_\infty$——两例都是谱范数最小，但这只是巧合，**不能当成一般规律**。能保证的只有 $\|A\|_2\le\|A\|_F$（[注 2](#note-4.3-multi)），以及 $\|A\|_2\le\sqrt n\|A\|_1$、$\|A\|_2\le\sqrt m\|A\|_\infty$ 这类常数控制。

**(c)** $\|A\|_2\approx1.618\le1.732\approx\|A\|_F$ ✓。∎
:::
:::

<a id="sec-4.3.3"></a>

## 4.3.3 Rayleigh 商与特征值的极值刻画

谱范数的证明里用了一件事：$A^{\mathrm H}A$ 的 Rayleigh 商不超过最大特征值。把这个想法单独拿出来，就得到 Hermite 矩阵特征值的一套**变分刻画**。

::: note 注 4 · Rayleigh 商（课件原文） {#note-4.3-rayleigh}

设 $\lambda_1\ge\lambda_2\ge\cdots\ge\lambda_n$ 是 Hermite 矩阵 $A$ 的 $n$ 个特征值，则由谱范数证明过程知

$$\lambda_n\le R(x)\le\lambda_1 ,$$

其中 $R(x)$ 的定义为

$$R(x)=\frac{x^{\mathrm H}Ax}{x^{\mathrm H}x},\qquad \forall x\ne\boldsymbol0 ,$$

称 $R(x)$ 为 Hermite 矩阵 $A$ 的 **Rayleigh 商**。
:::

::: proof 证明（本编补：谱分解 + 加权平均）

由谱定理（[3.6](../ch03/sec36.md)），$A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}$，$U$ 酉。令 $y=U^{\mathrm H}x\ne\boldsymbol0$，则

$$R(x)=\frac{y^{\mathrm H}\operatorname{diag}(\lambda_1,\cdots,\lambda_n)y}{y^{\mathrm H}y}=\frac{\sum_i\lambda_i|y_i|^2}{\sum_i|y_i|^2} .$$

这是 $\lambda_1,\cdots,\lambda_n$ 的**加权平均**（权重 $|y_i|^2\ge0$ 不全为零），故介于最小值与最大值之间：

$$\lambda_n\le R(x)\le\lambda_1 .$$

取 $x$ 为 $\lambda_1$（或 $\lambda_n$）的单位特征向量，则 $R(x)=\lambda_1$（或 $\lambda_n$），等号可达。∎
:::

::: cor 推论 4.3.1（课件原文） {#cor-4.3.1}

设 $\lambda_1\ge\lambda_2\ge\cdots\ge\lambda_n$ 是 Hermite 矩阵 $A$ 的 $n$ 个特征值，则

$$\lambda_1=\max_{\forall x\ne0}R(x),\qquad \lambda_n=\min_{\forall x\ne0}R(x) .$$
:::

Rayleigh 商只给出「最大」与「最小」。**中间那些特征值怎么用变分刻画？** 答案是 Courant–Fischer 极大极小定理：让子空间先「选」，再在子空间内取极值。

::: thm 定理 4.3.4 · 极大极小定理（Courant–Fischer）（课件原文） {#thm-4.3.4}

设 $\lambda_1\ge\lambda_2\ge\cdots\ge\lambda_n$ 是 Hermite 矩阵 $A$ 的 $n$ 个特征值，$V_i$ 是 $\mathbb C^n$ 中 $i$ 维子空间，则 $\forall i=1,\cdots,n$

$$\lambda_i=\max_{V_i}\ \min_{x\in V_i,\ x\ne0}R(x),$$

$$\lambda_i=\min_{V_{n-i+1}}\ \max_{x\in V_{n-i+1},\ x\ne0}R(x) .$$
:::

::: proof 证明（课件只述，本编补：两个方向各用一次「维数相交」）

设 $u_1,\cdots,u_n$ 是 $A$ 的标准正交特征向量组，$Au_j=\lambda_ju_j$。记 $U_i=\operatorname{span}\{u_1,\cdots,u_i\}$、$W_i=\operatorname{span}\{u_i,\cdots,u_n\}$，则 $\dim U_i=i$、$\dim W_i=n-i+1$，且

$$x\in U_i,\ x\ne0\ \Longrightarrow\ R(x)\ge\lambda_i;\qquad x\in W_i,\ x\ne0\ \Longrightarrow\ R(x)\le\lambda_i .$$

**第一式**。

- **$\ge$**：取 $V_i=U_i$，则 $\min_{x\in U_i}R(x)\ge\lambda_i$，故 $\max_{V_i}\min\ge\lambda_i$。
- **$\le$**：任取 $i$ 维子空间 $V_i$，与 $W_i$ 的维数之和为 $i+(n-i+1)=n+1\gt n$，故 $V_i\cap W_i\ne\{\boldsymbol0\}$。取 $x\in V_i\cap W_i$、$x\ne\boldsymbol0$，则 $R(x)\le\lambda_i$，故 $\min_{x\in V_i}R(x)\le\lambda_i$。对 $V_i$ 取 $\max$ 仍 $\le\lambda_i$。

两半合起来即 $\lambda_i=\max_{V_i}\min R$。

**第二式**。

- **$\le$**：取 $V_{n-i+1}=W_i$，则 $\max_{x\in W_i}R(x)\le\lambda_i$，故 $\min_{V_{n-i+1}}\max\le\lambda_i$。
- **$\ge$**：任取 $n-i+1$ 维子空间 $V$，与 $U_i$ 的维数之和为 $(n-i+1)+i=n+1\gt n$，故 $V\cap U_i\ne\{\boldsymbol0\}$。取 $x\in V\cap U_i$、$x\ne\boldsymbol0$，则 $R(x)\ge\lambda_i$，故 $\max_{x\in V}R(x)\ge\lambda_i$。对 $V$ 取 $\min$ 仍 $\ge\lambda_i$。

两半合起来即 $\lambda_i=\min_{V_{n-i+1}}\max R$。∎

**证明的要点**：**「维数之和超过 $n$，两个子空间必相交」**。这一句话同时给出了两个方向的夹逼：想压住 $\min$，就找一个「全是高特征值方向」的子空间；想压住 $\max$，就找一个「全是低特征值方向」的子空间，再用相交性逼出对面。
:::

<a id="app-4.3-weyl"></a>

## 应用 · Hermite 矩阵特征值的扰动

利用极大极小定理可**研究 Hermite 矩阵特征值的扰动问题**（讨论 Hermite 矩阵元素发生变化时相应矩阵特征值的变化范围）。

::: thm 定理 4.3.5 · Weyl 扰动不等式（课件原文） {#thm-4.3.5}

设 $A$ 和 $E$ 均为 $n$ 阶 Hermite 复方阵，则对 $i=1,\cdots,n$，有

$$\lambda_i(A)+\lambda_n(E)\le\lambda_i(A+E)\le\lambda_i(A)+\lambda_1(E),$$

式中，$\lambda_i(A)$ 是矩阵 $A$ 的第 $i$ 大特征值。
:::

::: proof 证明（本编补：对 $A+E$ 用 Courant–Fischer，再把 $R_E$ 夹住）

注意 Rayleigh 商对 $A+E$ 是**可加的**：$R_{A+E}(x)=R_A(x)+R_E(x)$，且由 [注 4](#note-4.3-rayleigh)，$\lambda_n(E)\le R_E(x)\le\lambda_1(E)$。

**上界**：由 [定理 4.3.4](#thm-4.3.4) 的第一式，

$$
\lambda_i(A+E)=\max_{V_i}\min_{x\in V_i}R_{A+E}(x)
\le\max_{V_i}\Big[\min_{x\in V_i}R_A(x)+\lambda_1(E)\Big]
=\lambda_i(A)+\lambda_1(E) .
$$

**下界**：由 [定理 4.3.4](#thm-4.3.4) 的第二式，

$$
\lambda_i(A+E)=\min_{V_{n-i+1}}\max_{x\in V}R_{A+E}(x)
\ge\min_{V}\Big[\max_{x\in V}R_A(x)+\lambda_n(E)\Big]
=\lambda_i(A)+\lambda_n(E) .\qquad\blacksquare$$
:::

**读法**：$\lambda_i(A+E)$ 被夹在「$\lambda_i(A)$ 加减 $E$ 的谱宽」之间。**扰动矩阵的最大 / 最小特征值，就是特征值移动的上下界**；特别地，若 $\|E\|_2\le\varepsilon$，则 $|\lambda_i(A+E)-\lambda_i(A)|\le\varepsilon$——这是谱范数作为「特征值敏感度」的定量版本。

::: ex 例 4.3.B（新增）· Rayleigh 商的读数 {#ex-4.3.B}

设 $A=\begin{bmatrix}2&1\\1&2\end{bmatrix}$。(a) 求特征值；(b) 计算 $x=(1,0)^{\mathrm T}$、$(1,1)^{\mathrm T}$、$(1,-1)^{\mathrm T}$ 三点的 Rayleigh 商；(c) 验证 $\lambda_2\le R(x)\le\lambda_1$。

::: sol 解答

**(a)** $\det(\lambda I-A)=(\lambda-2)^2-1=(\lambda-1)(\lambda-3)$，故 $\lambda_1=3$、$\lambda_2=1$。

**(b)** $R(x)=\dfrac{x^{\mathrm T}Ax}{x^{\mathrm T}x}$：

$$R(1,0)=\frac{2}{1}=2,\qquad R(1,1)=\frac{2+1+1+2}{2}=3,\qquad R(1,-1)=\frac{2-1-1+2}{2}=1 .$$

**(c)** $1\le2,3,1\le3$ ✓；且 $(1,1)$ 与 $(1,-1)$ 分别是 $\lambda_1,\lambda_2$ 的特征向量，取到等号——与 [推论 4.3.1](#cor-4.3.1) 一致。∎
:::
:::

::: ex 例 4.3.C（新增）· 用 Weyl 不等式夹住扰动后的特征值 {#ex-4.3.C}

设 $A=\begin{bmatrix}3&0\\0&1\end{bmatrix}$，$E=\begin{bmatrix}0&0.5\\0.5&0\end{bmatrix}$。(a) 求 $E$ 与 $A+E$ 的特征值；(b) 用 [定理 4.3.5](#thm-4.3.5) 夹住 $\lambda_1(A+E)$ 与 $\lambda_2(A+E)$，并核对。

::: sol 解答

**(a)** $E$ 的特征值为 $\pm0.5$（$\lambda_1(E)=0.5$、$\lambda_2(E)=-0.5$）。$A+E=\begin{bmatrix}3&0.5\\0.5&1\end{bmatrix}$，特征多项式 $\lambda^2-4\lambda+2.75=0$，故

$$\lambda_{1,2}(A+E)=\frac{4\pm\sqrt{16-11}}{2}=\frac{4\pm\sqrt5}{2}\approx3.118,\ 0.882 .$$

**(b)** Weyl：

- $i=1$：$3+(-0.5)=2.5\le3.118\le3+0.5=3.5$ ✓；
- $i=2$：$1+(-0.5)=0.5\le0.882\le1+0.5=1.5$ ✓。

两个特征值都被夹住，且实际移动量 $0.118$ 远小于上界 $0.5$——**Weyl 给的是最坏情况的界，不是精确位移**。∎
:::
:::

<a id="sec-4.3.4"></a>

## 4.3.4 逆矩阵的扰动：$\|A\|\lt1$ 时 $I-A$ 一定可逆

::: thm 定理 4.3.6 · 逆矩阵的范数估计（课件原文） {#thm-4.3.6}

设 $A\in\mathbb C^{n\times n}$，$\|A\|$ 是某一矩阵范数。若 $\|A\|\lt1$，则 $I-A$ 非奇异，且

$$\|(I-A)^{-1}\|\le\frac{\|I\|}{1-\|A\|} .$$
:::

::: proof 证明（课件原文，本编补「相容向量范数」这一步为什么必须交代）

**先证可逆**。若 $I-A$ 不可逆，则存在非零向量 $x$ 使得 $(I-A)x=\boldsymbol0$，即 $x=Ax$。**对于给定的矩阵范数，一定存在与之相容的向量范数**（[定理 4.3.1](#thm-4.3.1)），在该向量范数下

$$\|x\|=\|Ax\|\le\|A\|\,\|x\|\lt\|x\| ,$$

又 $x\ne\boldsymbol0$ 故 $\|x\|\gt0$，上式不可能成立。所以 $I-A$ 可逆。

**再估计逆的范数**。由 $(I-A)(I-A)^{-1}=I$ 得

$$(I-A)^{-1}=I+A(I-A)^{-1} .$$

两边取矩阵范数，用三角不等式与乘法相容性：

$$\|(I-A)^{-1}\|\le\|I\|+\|A\|\,\|(I-A)^{-1}\| ,$$

移项即得 $(1-\|A\|)\|(I-A)^{-1}\|\le\|I\|$，除以正数 $1-\|A\|$ 得结论。∎

**证明的要点**：**「矩阵可逆」这一步必须借向量范数**——反证法要在向量层面制造 $\|x\|\lt\|x\|$ 的矛盾，而矩阵范数本身量不了 $x$。这就是 [定理 4.3.1](#thm-4.3.1) 存在的意义。
:::

::: note 注 · $\|I\|$ 不一定是 $1$（课件原文） {#note-4.3-identity}

$\|I\|$ 不一定是 $1$。实际上，$\|I\|\ge1$（因为 $\|I\|=\|I\cdot I\|\le\|I\|^2$ 且 $\|I\|\gt0$）。

$\|I\|$ 的**算子范数**为 $1$。

**本编补一句**：所以 [定理 4.3.6](#thm-4.3.6) 的界写成 $\|I\|/(1-\|A\|)$ 而不是 $1/(1-\|A\|)$；只有当所用范数是诱导范数时，才能把 $\|I\|$ 换成 $1$。课件的这一页把 $\|I\|/(1-\|A\|)$ 直接写成 $1/(1-\|A\|)$ 并打了一个问号，正是提醒这一点（见[勘误 E4.5](errata.md)）。
:::

::: preview 课程预告 · Neumann 级数：把逆写成矩阵级数

[定理 4.3.6](#thm-4.3.6) 的证明只用了「$I-A$ 可逆」，其实还藏着一个更强的结论：

$$(I-A)^{-1}=I+A+A^2+\cdots=\sum_{k=0}^{\infty}A^k\qquad(\|A\|\lt1).$$

**本编补证明（三行）**：由 $(I-A)\sum_{k=0}^{N}A^k=I-A^{N+1}$ 与 $\|A^{N+1}\|\le\|A\|^{N+1}\to0$，两边令 $N\to\infty$ 即得；截断误差满足

$$\Big\|(I-A)^{-1}-\sum_{k=0}^{N}A^k\Big\|\le\frac{\|A\|^{N+1}}{1-\|A\|} .$$

这正是 [4.4 矩阵级数](../ch04/overview.md) 的第一个例子，也是矩阵函数 $e^{A}=\sum A^k/k!$ 的入口。本节只把它作为「相容性保证收敛」的兑现，详细理论留待 4.4。
:::

::: ex 例 4.3.D（新增）· 逆的界与级数截断 {#ex-4.3.D}

设 $A=\begin{bmatrix}0&\frac12\\\frac14&0\end{bmatrix}$。(a) 用 $\|\cdot\|_\infty$ 验证 $\|A\|\lt1$；(b) 直接求 $(I-A)^{-1}$ 并计算其 $\infty$-范数；(c) 与 [定理 4.3.6](#thm-4.3.6) 的界比较；(d) 用 Neumann 级数前两项近似，估计误差。

::: sol 解答

**(a)** 行和：$0+\frac12=\frac12$，$\frac14+0=\frac14$，故 $\|A\|_\infty=\frac12\lt1$ ✓。

**(b)** $I-A=\begin{bmatrix}1&-\frac12\\-\frac14&1\end{bmatrix}$，$\det=\frac78$，

$$(I-A)^{-1}=\frac{8}{7}\begin{bmatrix}1&\frac12\\\frac14&1\end{bmatrix}=\begin{bmatrix}\frac87&\frac47\\\frac27&\frac87\end{bmatrix},\qquad \|(I-A)^{-1}\|_\infty=\frac{12}{7}\approx1.714 .$$

**(c)** 界为 $\dfrac{\|I\|_\infty}{1-\|A\|_\infty}=\dfrac{1}{1/2}=2$，而实际 $1.714\le2$ ✓。（这里 $\|\cdot\|_\infty$ 是算子范数，故 $\|I\|_\infty=1$。）

**(d)** $I+A=\begin{bmatrix}1&\frac12\\\frac14&1\end{bmatrix}$，误差矩阵为 $(I-A)^{-1}-(I+A)=\begin{bmatrix}\frac17&\frac1{14}\\\frac1{14}&\frac17\end{bmatrix}$，$\infty$-范数 $=\frac{3}{14}\approx0.214$；级数界 $\dfrac{\|A\|_\infty^{2}}{1-\|A\|_\infty}=\dfrac{1/4}{1/2}=\dfrac12$，实际误差更小 ✓。∎

**要点**：$\|A\|_\infty=\frac12$ 时逆的范数约为 $1.7$，远小于最坏界 $2$——**界是保底的，不是精确值**。
:::
:::

## 4.3 小结与常见错误

- **一条主线**：**配套**（[定义 4.3.1](#def-4.3.1)：$\|Ax\|_v\le\|A\|_m\|x\|_v$）$\Rightarrow$ **两个存在性**（[矩阵 $\to$ 向量](#thm-4.3.1)：$\|x\alpha^{\mathrm T}\|_m$；[向量 $\to$ 矩阵](#thm-4.3.2)：$\max_{\|x\|=1}\|Ax\|$）$\Rightarrow$ **三个公式**（[定理 4.3.3](#thm-4.3.3)：列和、行和、谱）$\Rightarrow$ **谱的变分刻画**（[Rayleigh](#note-4.3-rayleigh)、[Courant–Fischer](#thm-4.3.4)、[Weyl](#thm-4.3.5)）$\Rightarrow$ **逆的扰动**（[定理 4.3.6](#thm-4.3.6)）。
- **一条对应**：**诱导范数 $\leftrightarrow$ 单位球的像**。$\|A\|$ 就是 $A(B)$ 中最远的点到原点的距离；三个公式只是三种形状的单位球（菱形 / 正方形 / 圆）对应的「最远点」公式。

::: think 常见错误清单 · 自查五条

1. **把 $\|A\|_1$ 当行和、$\|A\|_\infty$ 当列和**：口诀是「**1 列 $\infty$ 行**」——下标 $1$ 对应列和，$\infty$ 对应行和（[定理 4.3.3](#thm-4.3.3)）；
2. **忘记诱导范数要求「同一把向量范数」**：$\|A\|_1$ 配 $\|x\|_1$，$\|A\|_\infty$ 配 $\|x\|_\infty$，$\|A\|_2$ 配 $\|x\|_2$；交叉使用会破坏相容性；
3. **把 $\|I\|$ 一律当 $1$**：只有诱导范数才有 $\|I\|=1$；一般矩阵范数（如 $F$-范数）$\|I_n\|_F=\sqrt n$；
4. **用 $\|A\|_F$ 当算子范数**：$F$-范数不是诱导范数（[注 3′](#note-4.3-hierarchy)），$\|Ax\|_2\le\|A\|_F\|x\|_2$ 虽然成立，但 $\|A\|_F$ 不是「最紧」的界；
5. **把 Weyl 不等式当等式**：它给的是区间，不是精确位移（[例 4.3.C](#ex-4.3.C) 的实际位移 $0.118$ 远小于上界 $0.5$）。
:::

::: ex 即时自测（不看上文，5 分钟）{#ex-4.3.quiz}

1. 写出相容的定义，并说明它与「矩阵范数的乘法相容性」有什么区别。
2. 叙述两个存在性定理，并各写出一行构造。
3. 默写三个诱导范数公式；对 $A=\begin{bmatrix}1&2\\3&4\end{bmatrix}$ 算出 $\|A\|_1,\|A\|_\infty$。
4. 写出 Rayleigh 商的定义与上下界；Courant–Fischer 定理的证明用了哪一句「维数」事实？
5. 证明 $\|A\|\lt1$ 时 $I-A$ 可逆，并指出哪一步必须用「相容的向量范数」。

::: sol 参考要点

1. $\|Ax\|_v\le\|A\|_m\|x\|_v$；它管矩阵乘向量，乘法相容性 $\|AB\|\le\|A\|\|B\|$ 管矩阵乘矩阵，两者独立。
2. 矩阵 $\to$ 向量：$\|x\|_v=\|x\alpha^{\mathrm T}\|_m$（$\alpha\ne0$）；向量 $\to$ 矩阵：$\|A\|=\max_{\|x\|_v=1}\|Ax\|_v$。
3. $\|A\|_1=\max\{1+3,2+4\}=6$；$\|A\|_\infty=\max\{1+2,3+4\}=7$。
4. $R(x)=x^{\mathrm H}Ax/x^{\mathrm H}x$，$\lambda_n\le R\le\lambda_1$；Courant–Fischer 的证明用「两个子空间维数之和 $\gt n$ 则必相交」。
5. 反设 $(I-A)x=0$，$x\ne0$，则 $\|x\|=\|Ax\|\le\|A\|\|x\|\lt\|x\|$ 矛盾；这里必须有一个与 $\|A\|$ 相容的向量范数才能把 $\|Ax\|$ 与 $\|x\|$ 比较（[定理 4.3.1](#thm-4.3.1)）。
:::
:::
