# 1.3 向量范数与矩阵范数

上一节用 $|x-a|$ 衡量一个近似值的误差。现在假设一次计算给出两个量，误差分别为 $0.03$ 和 $-0.04$。可以逐项列出，也可以说“最大分量误差为 $0.04$”，或用欧几里得长度得到 $\sqrt{0.03^2+(-0.04)^2}=0.05$。后两种做法都把误差向量归结为一个非负数，但它们回答的问题不同。

这种衡量向量大小的函数称为**范数**。本节先介绍它应满足的性质，再计算常用的向量范数和矩阵范数。矩阵范数的用途是估计线性变换怎样影响向量的大小；有了这个工具，下一章就能分析方程组求解中的误差。

<a id="sec-1.3.1"></a>

## 1.3.1 向量范数

向量范数是刻画向量「大小」的量，又称向量的模。三维空间里 $\lVert\boldsymbol{x}\rVert_2=\sqrt{x_1^2+x_2^2+x_3^2}$ 是天然的「长度」，但在误差向量、残差向量这类场合，其他度量「大小」的办法（如各分量误差的最大值）反而更贴合需求。哪些函数有资格当「长度」？三条公理：

::: def 定义 1.3.1 · 向量范数 {#def-1.3.1}
定义在 $\mathbb{R}^n$ 上的实值函数 $\lVert\cdot\rVert$ 称为**向量范数**（vector norm），如果对任意向量 $\boldsymbol{x},\boldsymbol{y}\in\mathbb{R}^n$：

1. **正定性**：$\lVert\boldsymbol{x}\rVert\ge0$，当且仅当 $\boldsymbol{x}=\boldsymbol{0}$ 时 $\lVert\boldsymbol{x}\rVert=0$；
2. **齐次性**：对任一数 $k\in\mathbb{R}$，$\lVert k\boldsymbol{x}\rVert=\lvert k\rvert\,\lVert\boldsymbol{x}\rVert$；
3. **三角不等式**：$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert\le\lVert\boldsymbol{x}\rVert+\lVert\boldsymbol{y}\rVert$。
:::

这三条性质分别保证：只有零向量的范数为零；向量乘以常数后，范数按常数的绝对值缩放；两个向量相加后的范数，不超过各自范数之和。最后一条常用于估计总误差。

由公理还能直接得到**反三角不等式**（后文多次使用）：$\lVert\boldsymbol{x}\rVert-\lVert\boldsymbol{y}\rVert\le\lVert\boldsymbol{x}-\boldsymbol{y}\rVert$。推导：$\lVert\boldsymbol{x}\rVert=\lVert(\boldsymbol{x}-\boldsymbol{y})+\boldsymbol{y}\rVert\le\lVert\boldsymbol{x}-\boldsymbol{y}\rVert+\lVert\boldsymbol{y}\rVert$，移项即得。

::: ex 例 1.3.1 · 范数公理的必要性 {#ex-1.3.1}
设 $n\ge2$，判断下列 $\mathbb{R}^n$ 上的函数是否为向量范数：(1) $N_1(\boldsymbol{x})=\max_i\lvert x_i\rvert$ 的**平方**；(2) $N_2(\boldsymbol{x})=\lvert x_1\rvert$；(3) $N_3(\boldsymbol{x})=\sum_{i=1}^n \lvert x_i\rvert$。

::: proof 解
**(1) 不是**：正定性满足，但一次齐次性不成立：$N_1(2\boldsymbol x)=4N_1(\boldsymbol x)\ne2N_1(\boldsymbol x)$（$\boldsymbol x\ne0$）。三角不等式也失效——$\boldsymbol{x}=\boldsymbol{y}=(1,0)^{\mathrm T}$：$N_1(\boldsymbol{x}+\boldsymbol{y})=N_1(2,0)=4\gt1+1=2$。因此平方后的函数不满足范数公理。
**(2) 不是**：正定性失效——$\boldsymbol{x}=(0,5)$ 非零但 $N_2(\boldsymbol{x})=0$。只看一个分量就丢掉了其他方向的信息。
**(3) 是**：正是下文的 $\lVert\cdot\rVert_1$，见[@thm-1.3.1] 的证明。
:::

:::

### 三个具体范数与 Cauchy–Schwarz

::: lem 引理 1.3.1 · Cauchy–Schwarz 不等式 {#lem-1.3.1}
对任意 $\boldsymbol{x},\boldsymbol{y}\in\mathbb{R}^n$，$(\boldsymbol{x}^{\mathrm T}\boldsymbol{y})^2\le(\boldsymbol{x}^{\mathrm T}\boldsymbol{x})(\boldsymbol{y}^{\mathrm T}\boldsymbol{y})$，即 $\lvert\boldsymbol{x}^{\mathrm T}\boldsymbol{y}\rvert\le\lVert\boldsymbol{x}\rVert_2\lVert\boldsymbol{y}\rVert_2$，等号成立当且仅当 $\boldsymbol{x},\boldsymbol{y}$ 线性相关。

::: proof 证明
$\boldsymbol{y}=\boldsymbol{0}$ 时两端皆为零，显然。设 $\boldsymbol{y}\neq\boldsymbol{0}$，对任意 $t\in\mathbb{R}$，

$$0\le\lVert\boldsymbol{x}-t\boldsymbol{y}\rVert_2^2=\lVert\boldsymbol{x}\rVert_2^2-2t\,\boldsymbol{x}^{\mathrm T}\boldsymbol{y}+t^2\lVert\boldsymbol{y}\rVert_2^2$$

是关于 $t$ 的二次三项式，恒非负。取二次函数的极小点 $t=\boldsymbol{x}^{\mathrm T}\boldsymbol{y}/\lVert\boldsymbol{y}\rVert_2^2$ 代入，得

$$0\le\lVert\boldsymbol{x}\rVert_2^2-\frac{(\boldsymbol{x}^{\mathrm T}\boldsymbol{y})^2}{\lVert\boldsymbol{y}\rVert_2^2},$$

移项即得。等号成立当且仅当 $\boldsymbol{x}-t\boldsymbol{y}=\boldsymbol{0}$，即二者线性相关。
:::

:::

::: thm 定理 1.3.1 · 三种常用范数 {#thm-1.3.1}
对 $\mathbb{R}^n$ 中任一向量 $\boldsymbol{x}=(x_1,x_2,\cdots,x_n)^{\mathrm T}$，记

$$\lVert\boldsymbol{x}\rVert_1=\sum_{i=1}^{n}\lvert x_i\rvert,\qquad
\lVert\boldsymbol{x}\rVert_2=\left(\sum_{i=1}^{n}x_i^2\right)^{1/2},\qquad
\lVert\boldsymbol{x}\rVert_\infty=\max_{1\le i\le n}\lvert x_i\rvert,$$

则 $\lVert\cdot\rVert_1,\ \lVert\cdot\rVert_2$ 和 $\lVert\cdot\rVert_\infty$ 都是向量范数。

::: proof 证明

**$\lVert\cdot\rVert_1$。**正定：逐项 $\lvert x_i\rvert\ge0$，全零当且仅当和为零；齐次：$\sum_i\lvert kx_i\rvert=\lvert k\rvert\sum_i\lvert x_i\rvert$；三角不等式：

$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_1=\sum_i\lvert x_i+y_i\rvert\le\sum_i\bigl(\lvert x_i\rvert+\lvert y_i\rvert\bigr)=\lVert\boldsymbol{x}\rVert_1+\lVert\boldsymbol{y}\rVert_1 .$$

**$\lVert\cdot\rVert_\infty$。**正定：最大值 $\ge0$，且为零当且仅当每个 $\lvert x_i\rvert=0$；齐次：$\max_i\lvert kx_i\rvert=\lvert k\rvert\max_i\lvert x_i\rvert$；三角不等式：对每个分量 $\lvert x_i+y_i\rvert\le\lvert x_i\rvert+\lvert y_i\rvert\le\lVert\boldsymbol{x}\rVert_\infty+\lVert\boldsymbol{y}\rVert_\infty$，对左边取最大即得。

**$\lVert\cdot\rVert_2$。**正定与齐次显然（$\lVert k\boldsymbol{x}\rVert_2=\sqrt{k^2\sum x_i^2}=\lvert k\rvert\lVert\boldsymbol{x}\rVert_2$）。三角不等式：用内积记号 $\lVert\boldsymbol{x}\rVert_2=\sqrt{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}$，任取 $\boldsymbol{y}$，

$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_2^2=(\boldsymbol{x}+\boldsymbol{y})^{\mathrm T}(\boldsymbol{x}+\boldsymbol{y})=\lVert\boldsymbol{x}\rVert_2^2+2\,\boldsymbol{x}^{\mathrm T}\boldsymbol{y}+\lVert\boldsymbol{y}\rVert_2^2 .$$

由 Cauchy–Schwarz（[@lem-1.3.1]）$\boldsymbol{x}^{\mathrm T}\boldsymbol{y}\le\lvert\boldsymbol{x}^{\mathrm T}\boldsymbol{y}\rvert\le\lVert\boldsymbol{x}\rVert_2\lVert\boldsymbol{y}\rVert_2$，故

$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_2^2\le\lVert\boldsymbol{x}\rVert_2^2+2\lVert\boldsymbol{x}\rVert_2\lVert\boldsymbol{y}\rVert_2+\lVert\boldsymbol{y}\rVert_2^2=\bigl(\lVert\boldsymbol{x}\rVert_2+\lVert\boldsymbol{y}\rVert_2\bigr)^2 .$$

开方即得。
:::

:::

$\lVert\cdot\rVert_1$ 称为 **1-范数**；$\lVert\cdot\rVert_2$ 称为 **2-范数**或 Euclid（欧几里得）范数——$\lVert\boldsymbol{x}\rVert_2$ 就是 $n$ 维空间中向量的欧氏长度；$\lVert\cdot\rVert_\infty$ 称为 **∞-范数**（矩阵情形「列和/行和」的别名见 1.3.4，向量情形不用这些叫法）。

三种范数强调的方面不同：$\|\boldsymbol e\|_\infty$ 给出误差分量绝对值的最大值；$\|\boldsymbol e\|_1$ 把各分量的绝对值相加；$\|\boldsymbol e\|_2$ 则是误差向量的欧几里得长度。下图画出二维空间中范数等于 $1$ 的点集，分别得到正方形、菱形和圆。

<figure class="fig-sm">
<svg font-size="12" height="310" viewBox="0 0 360 320" width="350" xmlns="http://www.w3.org/2000/svg">
<defs><marker id="ax" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="2.6"><path d="M0,0 L6.5,2.6 L0,5.2 Z" fill="var(--fig-neutral)"></path></marker></defs>
<line marker-end="url(#ax)" stroke="var(--fig-neutral)" stroke-width="1.2" x1="20" x2="340" y1="160" y2="160"></line>
<line marker-end="url(#ax)" stroke="var(--fig-neutral)" stroke-width="1.2" x1="180" x2="180" y1="300" y2="20"></line>
<text fill="var(--fig-neutral)" x="344" y="164">x₁</text><text fill="var(--fig-neutral)" x="175" y="16">x₂</text>
<!-- ∞-norm: square -->
<rect fill="none" height="176" stroke="var(--fig-green)" stroke-width="2" width="176" x="92" y="72"></rect>
<!-- 2-norm: circle -->
<circle cx="180" cy="160" fill="none" r="88" stroke="var(--fig-blue)" stroke-width="2"></circle>
<!-- 1-norm: diamond -->
<polygon fill="none" points="180,72 268,160 180,248 92,160" stroke="var(--fig-red)" stroke-width="2"></polygon>
<circle cx="238" cy="112" fill="var(--fig-gold)" r="3.2"></circle>
<line stroke="var(--line-strong)" stroke-dasharray="4 3" stroke-width="1" x1="180" x2="238" y1="160" y2="112"></line>
<text fill="var(--fig-green)" x="276" y="78">‖x‖∞=1</text>
<text fill="var(--fig-blue)" x="250" y="230">‖x‖₂=1</text>
<text fill="var(--fig-red)" x="30" y="252">‖x‖₁=1</text>
<text fill="var(--fig-gold)" x="276" y="107">同一个 x</text>
<text fill="var(--muted)" x="196" y="150">θ</text>
</svg>
<figcaption>图 1-1 · 三种范数的单位球 $\{\boldsymbol{x}:\lVert\boldsymbol{x}\rVert_p=1\}$：正方形（∞）、圆（2）、菱形（1）。同一个 $\boldsymbol{x}$，三种「长度」读数不同（$\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_1$），在固定的有限维空间中，这些范数给出相同的收敛概念；不同向量之间的大小排序则可能随范数改变。</figcaption>
</figure>

这三种范数其实是同一个 $p$-范数家族的特例——$p$-范数的一般形式是

$$\lVert\boldsymbol{x}\rVert_p=\left(\sum_{i=1}^{n}\lvert x_i\rvert^p\right)^{1/p}\qquad(p\ge1\ \text{的实数})$$

并且有 $\displaystyle\lim_{p\to\infty}\lVert\boldsymbol{x}\rVert_p=\max_i\lvert x_i\rvert$。

::: thm 定理 1.3.2 · p-范数的极限 {#thm-1.3.2}
对固定的 $\boldsymbol{x}\neq\boldsymbol{0}$，$\displaystyle\lim_{p\to\infty}\lVert\boldsymbol{x}\rVert_p=\lVert\boldsymbol{x}\rVert_\infty$。

::: proof 证明
记 $M=\lVert\boldsymbol{x}\rVert_\infty=\max_i\lvert x_i\rvert\gt0$。一方面 $\lVert\boldsymbol{x}\rVert_p\ge(M^p)^{1/p}=M$（丢掉其余项只减不增）。另一方面

$$\lVert\boldsymbol{x}\rVert_p=\left(\sum_i\lvert x_i\rvert^p\right)^{1/p}\le\left(n\,M^p\right)^{1/p}=n^{1/p}M .$$

由夹逼与 $n^{1/p}\to1\ (p\to\infty)$ 得证。
:::

:::

::: think 思考 · 一般 $p$ 的三角不等式（Minkowski 不等式）
定理 1.3.1 的 $p=1,2,\infty$ 各有初等证明；一般 $p\ge1$ 的三角不等式叫 **Minkowski 不等式**：

$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_p\le\lVert\boldsymbol{x}\rVert_p+\lVert\boldsymbol{y}\rVert_p .$$

证明分两步。**第一步（Hölder 不等式）**：设 $p\gt1$，$q$ 满足 $\frac1p+\frac1q=1$，则 $\sum_i\lvert a_i b_i\rvert\le\bigl(\sum_i\lvert a_i\rvert^p\bigr)^{1/p}\bigl(\sum_i\lvert b_i\rvert^q\bigr)^{1/q}$。它来自 Young 不等式 $st\le\frac{s^p}{p}+\frac{t^q}{q}$（由 $\ln$ 的凹性或对 $s^p/p+t^q/q-st$ 求极小值得到）：把 $\lvert a_i\rvert/\lVert\boldsymbol{a}\rVert_p$、$\lvert b_i\rvert/\lVert\boldsymbol{b}\rVert_q$ 代入 Young 并对 $i$ 求和即得。**第二步**：

$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_p^p=\sum_i\lvert x_i+y_i\rvert^{p-1}\lvert x_i+y_i\rvert\le\sum_i\lvert x_i+y_i\rvert^{p-1}\lvert x_i\rvert+\sum_i\lvert x_i+y_i\rvert^{p-1}\lvert y_i\rvert,$$

对右边两个和分别用 Hölder（$q=p/(p-1)$），提出公因子 $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_p^{p-1}$ 后移项。$p=1$ 即定理 1.3.1 的证明。∎
:::

同一个向量可以用不同范数度量。换用范数后，数值一般会改变；一个向量序列是否趋于零，会不会也随之改变？下面的定理说明，在固定的有限维空间中，这种收敛性不变。

<a id="sec-1.3.2"></a>

## 1.3.2 范数等价定理

范数等价指两种范数可以用固定常数互相估计，并不表示它们之间始终只差同一个倍数，也不表示它们对任意两个向量给出相同的大小排序。

例如，$\boldsymbol u=(1,0)^{\mathrm T}$、$\boldsymbol v=(0.6,0.6)^{\mathrm T}$ 满足 $\|\boldsymbol u\|_1=1<1.2=\|\boldsymbol v\|_1$，但 $\|\boldsymbol u\|_\infty=1>0.6=\|\boldsymbol v\|_\infty$。等价定理要保证的是：某个序列在一种范数下趋于零，当且仅当它在另一种范数下也趋于零。

::: thm 定理 1.3.3 · 向量范数等价 {#thm-1.3.3}
设 $\lVert\cdot\rVert_\alpha,\ \lVert\cdot\rVert_\beta$ 是 $\mathbb{R}^n$ 上的任意两种向量范数，则存在与 $\boldsymbol{x}$ 无关的常数 $m$ 和 $M\ (0\lt m\lt M)$，使

$$m\lVert\boldsymbol{x}\rVert_\beta\le\lVert\boldsymbol{x}\rVert_\alpha\le M\lVert\boldsymbol{x}\rVert_\beta\qquad\forall\ \boldsymbol{x}\in\mathbb{R}^n .$$
:::

**意义**：向量 $\boldsymbol{x}$ 的某一种范数任意小（大）时，其他任何一种范数也任意小（大）。因此「$\lVert\boldsymbol{x}_k\rVert\to0$」这类收敛性结论与范数的选取无关；$m,M$ 则依赖于 $n$ 与范数对。

::: proof 证明

**第一步：三个常用范数之间的显式不等式。**

| 不等式 | 证明 |
|:--|:--|
| $\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_1\le n\lVert\boldsymbol{x}\rVert_\infty$ | 左：和 $\sum_i\lvert x_i\rvert$ 不小于其中任何一项；右：$n$ 项每项 $\le\max_j\lvert x_j\rvert$，求和即得 |
| $\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_2\le\sqrt n\,\lVert\boldsymbol{x}\rVert_\infty$ | 左：$\max_i x_i^2\le\sum_i x_i^2$ 后开方；右：$\sum_i x_i^2\le n\max_i x_i^2$ 后开方 |
| $\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_1\le\sqrt n\,\lVert\boldsymbol{x}\rVert_2$ | 左：$\bigl(\sum_i\lvert x_i\rvert\bigr)^2=\sum_i x_i^2+2\sum_{i\lt j}\lvert x_i x_j\rvert\ge\sum_i x_i^2$；右：取 $\boldsymbol{y}=(1,\cdots,1)^{\mathrm T}$ 用 Cauchy–Schwarz，$\sum_i\lvert x_i\rvert=\lvert\boldsymbol{x}\rvert^{\mathrm T}\boldsymbol{y}\le\lVert\boldsymbol{x}\rVert_2\sqrt n$，其中 $\lvert\boldsymbol{x}\rvert$ 表示逐分量取绝对值 |

三条右端的常数（$n$、$\sqrt n$）都不可再改进——取 $\boldsymbol{x}=(1,\cdots,1)^{\mathrm T}$ 或单分量向量即取等，无穷维情形的对照见[附录 A.1.4](../appendix/derivations.md#app-a-1-4)；应用的演练见[习题 B4](exercises.md)。

**第二步：一般情形——任何范数都与 $\lVert\cdot\rVert_2$ 双向控制。**

先证**任何**向量范数 $N$ 对 $\lVert\cdot\rVert_2$ 连续。反三角不等式给出 $\lvert N(\boldsymbol{u})-N(\boldsymbol{v})\rvert\le N(\boldsymbol{u}-\boldsymbol{v})$；记 $\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n$ 为标准单位向量，则对任意 $\boldsymbol{h}$，

$$N(\boldsymbol{h})=N\Bigl(\sum_i h_i\boldsymbol{e}_i\Bigr)\le\sum_i\lvert h_i\rvert N(\boldsymbol{e}_i)\le\Bigl(\sum_i N(\boldsymbol{e}_i)^2\Bigr)^{1/2}\lVert\boldsymbol{h}\rVert_2=:C\,\lVert\boldsymbol{h}\rVert_2,$$

最后一步是 Cauchy–Schwarz（把 $\lvert h_i\rvert$ 与 $N(\boldsymbol{e}_i)$ 分别看成两个 $n$ 维向量的分量）。故 $N$ 关于 $\lVert\cdot\rVert_2$ 是 Lipschitz 连续的。

再看单位球面 $S=\{\boldsymbol{x}:\lVert\boldsymbol{x}\rVert_2=1\}$：它是有界闭集，从而是紧集。连续函数 $N$ 在 $S$ 上取到最小值 $m_2$ 与最大值 $M_2$；且 $m_2\gt0$（若 $N(\boldsymbol{u})=0$ 而 $\boldsymbol{u}\in S$，由正定性得 $\boldsymbol{u}=\boldsymbol{0}$，与 $\boldsymbol{u}\in S$ 矛盾）。于是对任意 $\boldsymbol{x}\neq\boldsymbol{0}$，$\boldsymbol{x}/\lVert\boldsymbol{x}\rVert_2\in S$，代入并乘回 $\lVert\boldsymbol{x}\rVert_2$：

$$m_2\lVert\boldsymbol{x}\rVert_2\le N(\boldsymbol{x})\le M_2\lVert\boldsymbol{x}\rVert_2 .$$

**第三步：拼接。**对两种范数分别写出上式，$\ m_\alpha\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_\alpha\le M_\alpha\lVert\boldsymbol{x}\rVert_2$ 与 $m_\beta\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_\beta\le M_\beta\lVert\boldsymbol{x}\rVert_2$，消去 $\lVert\boldsymbol{x}\rVert_2$：

$$\frac{m_\alpha}{M_\beta}\lVert\boldsymbol{x}\rVert_\beta\le\lVert\boldsymbol{x}\rVert_\alpha\le\frac{M_\alpha}{m_\beta}\lVert\boldsymbol{x}\rVert_\beta,\qquad m=\frac{m_\alpha}{M_\beta}\gt0,\ M=\frac{M_\alpha}{m_\beta}\ \text{只依赖}\ n\ \text{与范数对}.∎$$

:::

::: ex 例 1.3.2 · 等价不等式的数值核对 {#ex-1.3.2}
取 $\boldsymbol{x}=(3,-5,1)^{\mathrm T}$，$n=3$。计算三种范数并逐条核对显式不等式。

::: proof 解
$\lVert\boldsymbol{x}\rVert_1=3+5+1=9$，$\lVert\boldsymbol{x}\rVert_2=\sqrt{9+25+1}=\sqrt{35}\approx5.916$，$\lVert\boldsymbol{x}\rVert_\infty=\max(3,5,1)=5$。

逐条核对：$\lVert\boldsymbol{x}\rVert_\infty=5\le\lVert\boldsymbol{x}\rVert_2=5.916\le\sqrt3\times5=8.660$ ✓；$\lVert\boldsymbol{x}\rVert_2=5.916\le\lVert\boldsymbol{x}\rVert_1=9\le\sqrt3\times5.916=10.247$ ✓；$\lVert\boldsymbol{x}\rVert_\infty=5\le\lVert\boldsymbol{x}\rVert_1=9\le3\times5=15$ ✓。三个范数读数不同，但若把 $\boldsymbol{x}$ 缩小 1000 倍，三个范数同时缩小 1000 倍——「趋于零」的行为一致。
:::

:::

不需要指明用哪一种向量范数时，记号 $\lVert\cdot\rVert$ 就泛指任意一种向量范数（本教程后续章节遵循此约定）。向量的大小有了规矩，矩阵的大小同样需要——下一小节把同一套公理化搬到矩阵上。

<a id="sec-1.3.3"></a>

## 1.3.3 矩阵范数与从属（算子）范数

矩阵范数是刻画矩阵「大小」的量，又称矩阵的模。它的定义与向量范数平行：

::: def 定义 1.3.2 · 矩阵范数 {#def-1.3.2}
定义在 $\mathbb{R}^{n\times n}$ 上的实值函数 $\lVert\cdot\rVert$ 称为**矩阵范数**（matrix norm），如果对任意 $A,B\in\mathbb{R}^{n\times n}$：

1. **正定性**：$\lVert A\rVert\ge0$，当且仅当 $A=O$ 时 $\lVert A\rVert=0$；
2. **齐次性**：对任一数 $k\in\mathbb{R}$，$\lVert kA\rVert=\lvert k\rvert\,\lVert A\rVert$；
3. **三角不等式**：$\lVert A+B\rVert\le\lVert A\rVert+\lVert B\rVert$；
4. **乘法次可乘性**：$\lVert AB\rVert\le\lVert A\rVert\,\lVert B\rVert$。
:::

条件 (4) 使我们能够用两个矩阵各自的范数估计其乘积。分析误差向量时，还需要 $\lVert A\boldsymbol e\rVert\le\lVert A\rVert\lVert\boldsymbol e\rVert$。这个不等式涉及矩阵范数与向量范数之间的关系，需要下面的相容性条件，不能只由条件 (4) 得到。

矩阵计算里到处出现矩阵与向量的乘积，所以矩阵范数与向量范数最好**配对**使用：

::: def 定义 1.3.3 · 相容性 {#def-1.3.3}
对于给定的向量范数 $\lVert\cdot\rVert$ 和矩阵范数 $\lVert\cdot\rVert$，如果对任一 $\boldsymbol{x}\in\mathbb{R}^n$ 和任一 $A\in\mathbb{R}^{n\times n}$ 满足

$$\lVert A\boldsymbol{x}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{x}\rVert,$$

则称所给的矩阵范数与向量范数是**相容的**（compatible）。
:::

定义一种矩阵范数时，最好让它与某个向量范数相容；同一问题里两种范数并用，则必须相容。下述定理给出由向量范数**制造**相容矩阵范数的标准方法。

::: intuition 直觉 · 算子范数 = 「矩阵最多能把向量拉长几倍」
怎么由一个向量范数造出一个矩阵范数？问一个最自然的问题就够了：**把 $\boldsymbol{x}$ 限制在单位球面上走一圈，$A\boldsymbol{x}$ 的长度最大是多少？**这个最大值就是 $\lVert A\rVert$——矩阵 $A$ 的**最大拉伸倍数**。把 $A$ 作用在整个单位球上，得到一个椭球，$\lVert A\rVert$ 就是椭球的最长半轴。

这样一来相容性 $\lVert A\boldsymbol{x}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{x}\rVert$ 几乎是同义反复：任何向量的拉伸倍数，当然不超过「最大拉伸倍数」。而 $\lVert A\rVert$ 小，意味着 $A$ 把一切向量都往短里压——这正是 1.3.5「扰动不放大」判据的几何来源。
:::

::: thm 定理 1.3.4 · 从属范数（算子范数） {#thm-1.3.4}
设在 $\mathbb{R}^n$ 中给定了一种向量范数 $\lVert\cdot\rVert$，对任一矩阵 $A\in\mathbb{R}^{n\times n}$，令

$$\lVert A\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\boldsymbol{x}\rVert. \tag{1.2}$$

则由式 (1.2) 定义的 $\lVert\cdot\rVert$ 是一种矩阵范数，并且它与所给定的向量范数相容。（极大值存在：单位球面 $\{\boldsymbol{x}:\lVert\boldsymbol{x}\rVert=1\}$ 是有界闭集，而 $\boldsymbol{x}\mapsto\lVert A\boldsymbol{x}\rVert$ 连续——理由同定理 1.3.3 的证明第二步。）

::: proof 证明
**先证相容性。**对任意非零向量 $\boldsymbol{y}$，$\boldsymbol{y}/\lVert\boldsymbol{y}\rVert$ 落在单位球面上，故

$$\frac{\lVert A\boldsymbol{y}\rVert}{\lVert\boldsymbol{y}\rVert}=\left\lVert A\frac{\boldsymbol{y}}{\lVert\boldsymbol{y}\rVert}\right\rVert\le\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\boldsymbol{x}\rVert=\lVert A\rVert\ \Longrightarrow\ \lVert A\boldsymbol{y}\rVert\le\lVert A\rVert\lVert\boldsymbol{y}\rVert,$$

$\boldsymbol{y}=\boldsymbol{0}$ 时两边皆零，也成立。

**再证式 (1.2) 满足矩阵范数四条件。**

(1) $A=O$ 时 $\lVert A\boldsymbol{x}\rVert=0$ 对一切 $\boldsymbol{x}$，故 $\lVert A\rVert=0$；$A\neq O$ 时存在 $\boldsymbol{x}_0$ 使 $A\boldsymbol{x}_0\neq\boldsymbol{0}$，取 $\boldsymbol{x}=\boldsymbol{x}_0/\lVert\boldsymbol{x}_0\rVert$ 得 $\lVert A\rVert\ge\lVert A\boldsymbol{x}\rVert\gt0$。

(2) $\displaystyle\lVert kA\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert kA\boldsymbol{x}\rVert=\lvert k\rvert\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\boldsymbol{x}\rVert=\lvert k\rvert\,\lVert A\rVert$。

(3) 对任意 $A,B$，

$$\lVert A+B\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert(A+B)\boldsymbol{x}\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\boldsymbol{x}+B\boldsymbol{x}\rVert\le\max_{\lVert\boldsymbol{x}\rVert=1}\bigl(\lVert A\boldsymbol{x}\rVert+\lVert B\boldsymbol{x}\rVert\bigr)\le\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\boldsymbol{x}\rVert+\max_{\lVert\boldsymbol{x}\rVert=1}\lVert B\boldsymbol{x}\rVert=\lVert A\rVert+\lVert B\rVert .$$

(4) 用相容性（对矩阵 $A$ 与向量 $B\boldsymbol{x}$）：

$$\lVert AB\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A(B\boldsymbol{x})\rVert\le\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\rVert\,\lVert B\boldsymbol{x}\rVert=\lVert A\rVert\max_{\lVert\boldsymbol{x}\rVert=1}\lVert B\boldsymbol{x}\rVert=\lVert A\rVert\,\lVert B\rVert .$$


:::

:::

称式 (1.2) 定义的矩阵范数为**从属于**所给定向量范数的矩阵范数，又称矩阵的**算子范数**（operator norm）。设给定的向量范数为 $\lVert\cdot\rVert_p$，则从属于它的矩阵范数仍记为 $\lVert\cdot\rVert_p$，即 $\lVert A\rVert_p=\max_{\lVert\boldsymbol{x}\rVert_p=1}\lVert A\boldsymbol{x}\rVert_p$，称 $\lVert A\rVert_p$ 为矩阵 $A$ 的 $p$-范数。由定理 1.3.4，矩阵 $p$-范数与向量 $p$-范数相容：

$$\lVert A\boldsymbol{x}\rVert_p\le\lVert A\rVert_p\,\lVert\boldsymbol{x}\rVert_p,\qquad A\in\mathbb{R}^{n\times n},\ \boldsymbol{x}\in\mathbb{R}^n .$$

::: note 推论 · 单位矩阵的任何算子范数都等于 1
$\lVert I\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert I\boldsymbol{x}\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert\boldsymbol{x}\rVert=1$。这条一行小推论在 1.3.4 是「F-范数不是算子范数」的关键依据，在定理 1.3.6 的证明里也要用到。
:::

<a id="sec-1.3.4"></a>

## 1.3.4 三个从属范数的计算公式与 F-范数

从属范数的定义式 (1.2) 要对单位球面上的一切 $\boldsymbol{x}$ 求最大，直接按定义算并不现实。好在三个 $p$-范数都有闭式公式。

::: intuition 怎样找到最大的放大倍数
「最大拉伸倍数」什么时候取到？此时输入向量长什么样？

- **1-范数**：输入的预算是「各 $\lvert x_j\rvert$ 之和为 1」。最坏情形是把全部预算**押在一个分量**上——而押在第 $j$ 个分量上，输出就被第 $j$ **列**撑大，所以答案是**绝对值和最大的列**。
- **∞-范数**：每个分量都被允许取到 $\pm1$（反正只看最大者）。最坏情形是**每个分量都拉满**、符号与某一行对齐——于是答案是**绝对值和最大的行**。
- **2-范数**：没有这么整齐的最坏输入，最大拉伸方向由 $A^{\mathrm T}A$ 的特征向量决定——所以它必须开方、必须问特征值（椭球最长半轴）。
:::

::: thm 定理 1.3.5 · 矩阵 1-范数、2-范数与 ∞-范数 {#thm-1.3.5}
设 $A=[a_{ij}]\in\mathbb{R}^{n\times n}$，则

$$\lVert A\rVert_1=\max_{1\le j\le n}\sum_{i=1}^{n}\lvert a_{ij}\rvert\quad(\text{列范数：绝对值最大的列和})，$$

$$\lVert A\rVert_2=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}\quad(\text{谱范数 spectral norm})，$$

$$\lVert A\rVert_\infty=\max_{1\le i\le n}\sum_{j=1}^{n}\lvert a_{ij}\rvert\quad(\text{行范数：绝对值最大的行和})，$$

其中 $\lambda_{\max}(A^{\mathrm T}A)$ 表示矩阵 $A^{\mathrm T}A$ 的最大特征值。

::: proof 证明

**1-范数（列和）。**设 $\lVert\boldsymbol{x}\rVert_1=1$。记 $W=\max_{1\le j\le n}\sum_i\lvert a_{ij}\rvert$，则

$$\lVert A\boldsymbol{x}\rVert_1=\sum_{i=1}^{n}\left\lvert\sum_{j=1}^{n}a_{ij}x_j\right\rvert\le\sum_{i=1}^{n}\sum_{j=1}^{n}\lvert a_{ij}\rvert\,\lvert x_j\rvert=\sum_{j=1}^{n}\lvert x_j\rvert\sum_{i=1}^{n}\lvert a_{ij}\rvert\le\sum_{j=1}^{n}\lvert x_j\rvert\,W=W\,\lVert\boldsymbol{x}\rVert_1=W .$$

故 $\lVert A\rVert_1\le W$。反过来取 $\boldsymbol{x}=\boldsymbol{e}_r$（第 $r$ 个分量为 1，$r$ 是取到列和最大值的列），$\lVert\boldsymbol{e}_r\rVert_1=1$ 且 $\lVert A\boldsymbol{e}_r\rVert_1=\sum_i\lvert a_{ir}\rvert=W$，故 $\lVert A\rVert_1\ge W$。综合得 $\lVert A\rVert_1=W$。

**2-范数（谱范数）。**对 $\lVert\boldsymbol{x}\rVert_2=1$，注意到

$$\lVert A\boldsymbol{x}\rVert_2^2=(A\boldsymbol{x})^{\mathrm T}(A\boldsymbol{x})=\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x} .$$

$A^{\mathrm T}A$ 是对称半正定矩阵（$\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x}=\lVert A\boldsymbol{x}\rVert_2^2\ge0$），故它的全部特征值非负；设

$$\lambda_1\ge\lambda_2\ge\cdots\ge\lambda_n\ge0,$$

并设相应的**标准正交**特征向量为 $\boldsymbol{u}_1,\boldsymbol{u}_2,\cdots,\boldsymbol{u}_n$（对称矩阵必可正交对角化）。任何 $\boldsymbol{x}$ 可展开为 $\boldsymbol{x}=\sum_{i=1}^{n}k_i\boldsymbol{u}_i$（实数 $k_i$），由正交性

$$\lVert\boldsymbol{x}\rVert_2^2=\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\sum_{i=1}^{n}k_i^2,\qquad
\lVert A\boldsymbol{x}\rVert_2^2=\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x}=\sum_{i=1}^{n}\lambda_i k_i^2\le\lambda_1\sum_{i=1}^{n}k_i^2=\lambda_1\lVert\boldsymbol{x}\rVert_2^2 .$$

故 $\lVert A\rVert_2\le\sqrt{\lambda_1}$。取 $\boldsymbol{x}=\boldsymbol{u}_1$（单位向量）：$\lVert A\boldsymbol{u}_1\rVert_2^2=\lambda_1$，等号达到。所以 $\lVert A\rVert_2=\sqrt{\lambda_1}=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$。

**∞-范数（行和）。**设 $w=\max_{1\le i\le n}\sum_j\lvert a_{ij}\rvert$。对任意 $\boldsymbol{x}$，

$$\lVert A\boldsymbol{x}\rVert_\infty=\max_{1\le i\le n}\left\lvert\sum_{j=1}^{n}a_{ij}x_j\right\rvert\le\max_{1\le i\le n}\sum_{j=1}^{n}\lvert a_{ij}\rvert\,\lvert x_j\rvert\le\max_{1\le i\le n}\Bigl(\sum_{j=1}^{n}\lvert a_{ij}\rvert\Bigr)\lVert\boldsymbol{x}\rVert_\infty=w\,\lVert\boldsymbol{x}\rVert_\infty .$$

当 $A=O$ 时结论显然成立。若 $A\ne O$，设第 $r$ 行取到 $w>0$，取 $\boldsymbol{x}=(\operatorname{sgn} a_{r1},\operatorname{sgn} a_{r2},\cdots,\operatorname{sgn} a_{rn})^{\mathrm T}$（sgn 为符号函数），则 $\lVert\boldsymbol{x}\rVert_\infty=1$ 且

$$\lVert A\boldsymbol{x}\rVert_\infty\ge\left\lvert\sum_{j=1}^{n}a_{rj}\operatorname{sgn}(a_{rj})\right\rvert=\sum_{j=1}^{n}\lvert a_{rj}\rvert=w .$$


:::

:::

**记忆法**：矩阵 1-范数是**列**和的最大值，∞-范数是**行**和的最大值——「1 竖着像一根列」。二者一般不相等（转置恰好交换它们：$\lVert A\rVert_1=\lVert A^{\mathrm T}\rVert_\infty$）。谱范数没有手算捷径，流程固定：算 $A^{\mathrm T}A$ → 求最大特征值 → 开方，完整算例见 [@ex-1.3.3]。

::: note 与奇异值的联系
$\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$ 也是 $A$ 的最大奇异值，记为 $\sigma_{\max}(A)$。奇异值分解及其用途见[补充篇](../supplement/sec26.md)。
:::

### Frobenius 范数

还有一种常用的矩阵范数：

::: def 定义 1.3.4 · Frobenius 范数 {#def-1.3.4}
$$\lVert A\rVert_F=\left(\sum_{i=1}^{n}\sum_{j=1}^{n}a_{ij}^2\right)^{1/2},\qquad A=[a_{ij}]\in\mathbb{R}^{n\times n}.$$

又称为 Frobenius（佛罗贝尼乌斯）范数或 Euclid 范数，也可记为 $\lVert\cdot\rVert_E$——它就是把 $A$ 的全部元素摊平当向量算的 2-范数。
:::

下面分别证明 Frobenius 范数的次可乘性、相容性，以及它与从属范数的区别。

::: proof 证明

**(a) $\lVert\cdot\rVert_F$ 满足矩阵范数四条件。**(1)(2)(3)：把 $A$ 摊平为 $n^2$ 维向量后，$\lVert\cdot\rVert_F$ 就是该向量上的 $\lVert\cdot\rVert_2$，而正定、齐次、三角不等式是 2-范数的性质（[@thm-1.3.1]）。(4) 次可乘性：把 $B$ 按列分块 $B=[\boldsymbol{b}_1,\cdots,\boldsymbol{b}_n]$，则 $AB$ 的第 $j$ 列是 $A\boldsymbol{b}_j$，用下面 (b) 的相容性与 $\lVert A\rVert_2\le\lVert A\rVert_F$（对最大奇异向量 $\boldsymbol{v}$ 用 (b)：$\lVert A\rVert_2=\lVert A\boldsymbol{v}\rVert_2\le\lVert A\rVert_F\lVert\boldsymbol{v}\rVert_2=\lVert A\rVert_F$）：

$$\lVert AB\rVert_F^2=\sum_{j=1}^{n}\lVert A\boldsymbol{b}_j\rVert_2^2\le\lVert A\rVert_2^2\sum_{j=1}^{n}\lVert\boldsymbol{b}_j\rVert_2^2\le\lVert A\rVert_F^2\,\lVert B\rVert_F^2 .$$

**(b) $\lVert\cdot\rVert_F$ 与向量范数 $\lVert\cdot\rVert_2$ 相容**：对 $A$ 的每一行用 Cauchy–Schwarz，

$$\lVert A\boldsymbol{x}\rVert_2^2=\sum_{i=1}^{n}\left(\sum_{j=1}^{n}a_{ij}x_j\right)^2\le\sum_{i=1}^{n}\left(\sum_{j=1}^{n}a_{ij}^2\right)\left(\sum_{j=1}^{n}x_j^2\right)=\lVert A\rVert_F^2\,\lVert\boldsymbol{x}\rVert_2^2 .$$

**(c) $\lVert\cdot\rVert_F$ 不从属于任何向量范数（不是算子范数）**：任何算子范数都满足 $\lVert I\rVert=1$（见 1.3.3 的推论），而对 $n\ge2$，$\lVert I\rVert_F=\sqrt{n}\neq1$。

:::

::: ex 例 1.3.3 · 五种范数全算一遍 {#ex-1.3.3}
设 $\boldsymbol{x}=(3,-5,1)^{\mathrm T}$，

$$A=\begin{pmatrix}1&5&-2\\-2&1&0\\3&-8&2\end{pmatrix},$$

试求 $\lVert\boldsymbol{x}\rVert_p,\ \lVert A\rVert_p\ (p=1,2,\infty)$ 以及 $\lVert A\rVert_F$。

::: proof 解
**向量的三种范数：**

$$\lVert\boldsymbol{x}\rVert_1=3+5+1=9,\qquad\lVert\boldsymbol{x}\rVert_2=\sqrt{9+25+1}=\sqrt{35},\qquad\lVert\boldsymbol{x}\rVert_\infty=\max(3,5,1)=5 .$$

**1-范数（列和）与 ∞-范数（行和）：**

$$\lVert A\rVert_1=\max\bigl(1+2+3,\ 5+1+8,\ 2+0+2\bigr)=\max(6,14,4)=14,$$

$$\lVert A\rVert_\infty=\max\bigl(1+5+2,\ 2+1+0,\ 3+8+2\bigr)=\max(8,3,13)=13,$$

$$\lVert A\rVert_F=\sqrt{1+25+4+4+1+0+9+64+4}=\sqrt{112}\approx10.583 .$$

**2-范数（谱范数）——完整流程。**先算 $A^{\mathrm T}A$（$A$ 的三列是 $(1,-2,3)^{\mathrm T},(5,1,-8)^{\mathrm T},(-2,0,2)^{\mathrm T}$，各元素为对应两列的内积）：

$$A^{\mathrm T}A=\begin{pmatrix}14&-21&4\\-21&90&-26\\4&-26&8\end{pmatrix}.$$

其特征方程

$$\det(A^{\mathrm T}A-\lambda I)=-\lambda^3+112\lambda^2-959\lambda+16=0$$

的最大根为 $\lambda_1\approx102.66$，所以

$$\lVert A\rVert_2=\sqrt{\lambda_1}\approx10.132 .$$

**验算的捷径（本教程补注）：**特征多项式的三个系数不必硬展开——$\lambda$ 的一次项系数是全部二阶主子式之和 $44+96+819=959$，常数项是 $\det(A^{\mathrm T}A)=(\det A)^2=(-4)^2=16$，二次项系数是迹 $14+90+8=112$。数值复核（NumPy）：$\lambda_1=102.66000272\cdots$，$\lVert A\rVert_2=10.13212726\cdots$，与原书一致。
:::

:::

<a id="sec-1.3.5"></a>

## 1.3.5 范数的第一个应用：可逆性判据与 Neumann 级数

矩阵范数可以用来判断某些矩阵是否可逆。例如，若 $\|A\|<1$，就能证明 $I-A$ 可逆；使用从属范数时，还能估计其逆的范数。

::: intuition 直觉 · 中学等比数列的矩阵版
你在中学就知道：$|r|\lt1$ 时 $1+r+r^2+\cdots=\dfrac{1}{1-r}$。定理 1.3.6 与 Neumann 级数就是这句话把「绝对值」换成「范数」后的矩阵版：

- $\lVert A\rVert\lt1$ 相当于 $|r|\lt1$：$A$ 是个「**压缩**」，反复乘只会越乘越小；
- $I-A$ 不会把任何非零向量压成零（所以可逆）——就像 $1-r$ 离 $0$ 有明确的距离；
- $(I-A)^{-1}=I+A+A^2+\cdots$，且「总放大率」不超过 $\dfrac{1}{1-\lVert A\rVert}$。

[第 2 章](../course/ch02/overview.md)迭代法的收敛性证明，用的正是这一套。
:::

::: thm 定理 1.3.6 · Neumann 界 {#thm-1.3.6}
设矩阵 $A\in\mathbb{R}^{n\times n}$ 的某种矩阵范数满足 $\lVert A\rVert\lt1$，则 $I\pm A$ 为非奇异矩阵，并且当该种范数为算子范数时，还有

$$\bigl\lVert(I\pm A)^{-1}\bigr\rVert\le\frac{1}{1-\lVert A\rVert} .$$
:::

::: proof 证明
**非奇异性。**反证：假定 $I\pm A$ 奇异，则齐次线性方程组 $(I\pm A)\boldsymbol{x}=\boldsymbol{0}$ 有非零解，即存在 $\boldsymbol{v}\neq\boldsymbol{0}$ 使

$$\boldsymbol{v}=\mp A\boldsymbol{v} .$$

两边取范数——这里的向量范数取与所用矩阵范数相容的那一个（存在性见[习题 B4](exercises.md)；若矩阵范数本身就是算子范数，直接用它从属的向量范数）：

$$\lVert\boldsymbol{v}\rVert=\lVert A\boldsymbol{v}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{v}\rVert .$$

因 $\lVert\boldsymbol{v}\rVert\gt0$，约去后得 $\lVert A\rVert\ge1$，与 $\lVert A\rVert\lt1$ 矛盾。故 $I\pm A$ 必非奇异。

**逆的界。**由 $(I-A)(I-A)^{-1}=I$ 移项得

$$(I-A)^{-1}=I+A(I-A)^{-1} .$$

两边取（相容的）矩阵范数，用次可乘性：

$$\bigl\lVert(I-A)^{-1}\bigr\rVert\le\lVert I\rVert+\lVert A\rVert\,\bigl\lVert(I-A)^{-1}\bigr\rVert .$$

移项得 $\bigl(1-\lVert A\rVert\bigr)\bigl\lVert(I-A)^{-1}\bigr\rVert\le\lVert I\rVert$。算子范数下 $\lVert I\rVert=1$ 且 $1-\lVert A\rVert\gt0$，故

$$\bigl\lVert(I-A)^{-1}\bigr\rVert\le\frac{1}{1-\lVert A\rVert} .$$

同理可证 $\bigl\lVert(I+A)^{-1}\bigr\rVert\le\dfrac{1}{1-\lVert A\rVert}$。
:::

定理 1.3.6 给出了逆的界，还有一个更强的「无穷版」——把 $(I-A)^{-1}$ 本身写成级数：

::: thm 定理 1.3.7 · Neumann 级数 {#thm-1.3.7}
设 $\lVert A\rVert\lt1$（任一矩阵范数），则矩阵几何级数 $\displaystyle\sum_{k=0}^{\infty}A^k=I+A+A^2+\cdots$ 收敛，且

$$\sum_{k=0}^{\infty}A^k=(I-A)^{-1}.$$

::: proof 证明
记部分和 $S_N=\sum_{k=0}^{N}A^k$。直接验证下面这个逐项相消的恒等式

$$(I-A)S_N=(I-A)(I+A+\cdots+A^N)=I-A^{N+1} .$$

由 $\lVert A\rVert\lt1$ 与定理 1.3.6，$I-A$ 非奇异，故 $S_N=(I-A)^{-1}(I-A^{N+1})=(I-A)^{-1}-(I-A)^{-1}A^{N+1}$。由次可乘性归纳得 $\lVert A^{N+1}\rVert\le\lVert A\rVert^{N+1}\to0$，故

$$\lim_{N\to\infty}S_N=(I-A)^{-1},\qquad\text{且有余项估计}\quad\left\lVert(I-A)^{-1}-S_N\right\rVert\le\frac{\lVert A\rVert^{N+1}}{1-\lVert A\rVert}$$

（余项估计中用到 $\lVert I\rVert=1$，故该估计要求该范数为**算子范数**；级数收敛与求和公式本身对任一矩阵范数都成立。）


:::

:::

::: ex 例 1.3.4 · 界是紧的 {#ex-1.3.4}
取

$$A=\begin{pmatrix}0.10&0.05&0\\0&0.10&0.05\\0.05&0&0.10\end{pmatrix},$$

验证定理 1.3.6 的界。

::: proof 解
$\lVert A\rVert_\infty=\max(0.15,\,0.15,\,0.15)=0.15\lt1$，定理给出

$$\bigl\lVert(I-A)^{-1}\bigr\rVert_\infty\le\frac{1}{1-0.15}=\frac{1}{0.85}\approx1.17647 .$$

实际计算得到 $\|(I-A)^{-1}\|_\infty=1.176470588\cdots$，恰好达到上界。也可以直接验证：$A$ 的每行元素之和为 $0.15$，所以 $A\boldsymbol1=0.15\boldsymbol1$，进而 $(I-A)^{-1}\boldsymbol1=(1/0.85)\boldsymbol1$。因为 $\|\boldsymbol1\|_\infty=1$，从属范数的定义给出下界 $\|(I-A)^{-1}\|_\infty\ge1/0.85$，与定理给出的上界相同。因此这个常数不能统一改小。

:::

:::

::: note 与迭代法的联系
第二章将把方程组改写成 $\boldsymbol x=H\boldsymbol x+\boldsymbol d$，并计算 $\boldsymbol x_{k+1}=H\boldsymbol x_k+\boldsymbol d$。若 $\boldsymbol x^*$ 为不动点，则两式相减得到误差递推

$$\boldsymbol e_{k+1}=H\boldsymbol e_k,\qquad\boldsymbol e_k=H^k\boldsymbol e_0.$$

在相应的从属范数下，$\|H\|<1$ 便能保证误差趋于零。这与上一节常系数递推中 $|\beta|<1$ 的分析相对应。第二章会进一步讨论完整的收敛判据和误差估计。
:::

<a id="sec-1.3.6"></a>

## 1.3.6 范数与线性方程组的误差

### 三种日常用法

::: method 范数怎样用于误差分析
1. 近似解 $\boldsymbol a$ 与真解 $\boldsymbol x$ 的误差大小，可以用 $\|\boldsymbol x-\boldsymbol a\|$ 衡量。
2. 迭代中的相邻差和残差都可用范数计算。要把它们转化为解的误差界，还需要收敛或敏感性条件；相邻差小本身不足以保证解误差小。
3. 不等式 $\|A\boldsymbol e\|\le\|A\|\|\boldsymbol e\|$ 可以估计线性变换对误差的影响。
:::

四种常用范数怎么选：

| 范数 | 读数的含义 | 优点 | 典型场合 |
|:--|:--|:--|:--|
| $\lVert\cdot\rVert_\infty$ | 最大的那个分量误差 | 手算最快；「最坏分量」语义 | 误差上界、逐分量保证 |
| $\lVert\cdot\rVert_1$ | 各分量误差之和 | 与稀疏性、列结构配合好 | 稀疏误差、稀疏解诱导（[补充篇 2.4](../supplement/sec24.md)、[2.6](../supplement/sec26.md)） |
| $\lVert\cdot\rVert_2$ | 欧氏长度 | 几何直观；旋转不变；与内积 / 正交理论配套 | 最小二乘（[补充篇 2.2](../supplement/sec22.md)）、谱分析（[补充篇 2.5](../supplement/sec25.md)） |
| $\lVert\cdot\rVert_F$ | 全部元素平方和的平方根 | 不依赖特征值，手算即得 | 差分近似、正交迭代的分析 |

由等价定理，**收敛性结论与选择无关**；但**界的大小**与选择有关——报误差时注明范数，是数值报告的基本礼仪。

### 线性方程组的条件数

设矩阵 $A$ 不变，只有右端项发生扰动。由 $A\delta\boldsymbol x=\delta\boldsymbol b$，可以先估计解的绝对变化；再利用 $\boldsymbol b=A\boldsymbol x$，把它改写成相对变化的上界。下面固定使用同一种向量范数及其从属矩阵范数。

设 $A\boldsymbol{x}=\boldsymbol{b}$（$A$ 非奇异，$\boldsymbol b\ne\boldsymbol0$），右端受扰 $\boldsymbol{b}\to\boldsymbol{b}+\delta\boldsymbol{b}$，解随之 $\boldsymbol{x}\to\boldsymbol{x}+\delta\boldsymbol{x}$：$A(\boldsymbol{x}+\delta\boldsymbol{x})=\boldsymbol{b}+\delta\boldsymbol{b}$，与原式相减得 $A\,\delta\boldsymbol{x}=\delta\boldsymbol{b}$。**完整推导相对误差界：**

$$\lVert\delta\boldsymbol{x}\rVert=\lVert A^{-1}\delta\boldsymbol{b}\rVert\le\lVert A^{-1}\rVert\,\lVert\delta\boldsymbol{b}\rVert;$$

另一方面 $\boldsymbol{b}=A\boldsymbol{x}$ 给出 $\lVert\boldsymbol{b}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{x}\rVert$，即 $\dfrac{1}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}$。两式相乘：

$$\boxed{\ \frac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\lVert A\rVert\,\lVert A^{-1}\rVert\cdot\frac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert}\ }$$

这个放大倍数 $\mathrm{cond}(A)=\|A\|\|A^{-1}\|$ 称为矩阵条件数。对所用从属范数，由 $1=\|I\|\le\|A\|\|A^{-1}\|$，可知条件数至少为 $1$。条件数大，表示存在可能被明显放大的相对扰动；它给出上界，并不表示每个右端项和每个扰动方向都会达到最坏情况。第二章将继续分析矩阵数据也发生扰动时的情形。

### 实验四 · 用 NumPy 检验本节公式

```python
import numpy as np
rng = np.random.default_rng(42)
B = rng.normal(size=(5, 5))

print(np.linalg.norm(B, 2), np.linalg.svd(B, compute_uv=False)[0])  # 谱范数 = 最大奇异值
print(np.linalg.norm(B, 1), np.linalg.norm(B, np.inf), np.linalg.norm(B, 'fro'))
x = np.array([3., -5, 1.])
ninf, n2 = np.linalg.norm(x, np.inf), np.linalg.norm(x, 2)
print(ninf <= n2 <= 3**0.5 * ninf)     # 等价不等式 ‖x‖∞ ≤ ‖x‖₂ ≤ √n‖x‖∞ (n=3)
print(np.linalg.cond(B, np.inf))   # cond = ||B||inf * ||B^{-1}||inf
```

```text
2.8039574397739977 2.8039574397739964
3.7498421916288223 4.986752286846435 4.075347890702065
True
18.735127456931128
```

**核对点：**① $\lVert B\rVert_2$ 与 $\sigma_{\max}(B)$ 在机器精度内一致（$2.8039574\cdots$）；② 显式等价不等式成立；③ 手工乘出 $\lVert B\rVert_\infty\lVert B^{-1}\rVert_\infty$ 与 `np.linalg.cond` 一致。**报告要求：**把随机种子换掉重跑，确认三条结论对一切矩阵成立；再构造一个 $\mathrm{cond}\approx10^{10}$ 的矩阵（例如 $B = \mathrm{diag}(1,10^{-1},\cdots,10^{-9})$ 的正交相似阵），预测并验证解 $B\boldsymbol{x}=\boldsymbol{b}$ 时丢几位有效数字。

<a id="sec-1.3.7"></a>

## 1.3.7 小结与常见错误

::: method[core] 公式速查 · 范数五件套

| 记号 | 公式 | 从属于 | 速算 |
|:--|:--|:--|:--|
| $\lVert\boldsymbol{x}\rVert_1$ | $\sum_i\lvert x_i\rvert$ | — | 加绝对值 |
| $\lVert\boldsymbol{x}\rVert_2$ | $\bigl(\sum_i x_i^2\bigr)^{1/2}$ | — | 欧氏长度 |
| $\lVert\boldsymbol{x}\rVert_\infty$ | $\max_i\lvert x_i\rvert$ | — | 挑最大 |
| $\lVert A\rVert_1$ | $\max_j\sum_i\lvert a_{ij}\rvert$ | $\lVert\cdot\rVert_1$ | **列**和取大 |
| $\lVert A\rVert_2$ | $\sqrt{\lambda_{\max}(A^{\mathrm T}A)}=\sigma_{\max}(A)$ | $\lVert\cdot\rVert_2$ | 算 $A^{\mathrm T}A$ 开方 |
| $\lVert A\rVert_\infty$ | $\max_i\sum_j\lvert a_{ij}\rvert$ | $\lVert\cdot\rVert_\infty$ | **行**和取大 |
| $\lVert A\rVert_F$ | $\bigl(\sum_{i,j}a_{ij}^2\bigr)^{1/2}$ | **不**从属任何范数 | 平方和开方 |

相容性：$\lVert A\boldsymbol{x}\rVert_p\le\lVert A\rVert_p\lVert\boldsymbol{x}\rVert_p$；等价性：$\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_1\le n\lVert\boldsymbol{x}\rVert_\infty$；定理 1.3.6（下述逆范数界限于算子范数）：$\lVert A\rVert\lt1\Rightarrow I\pm A$ 非奇异、$\lVert(I\pm A)^{-1}\rVert\le(1-\lVert A\rVert)^{-1}$；Neumann：$\sum A^k=(I-A)^{-1}$。
:::

::: think[core] 常见错误清单 · 自查六条
1. **把 $\lVert AB\rVert=\lVert A\rVert\lVert B\rVert$ 当等式。**公理只保证 $\le$（次可乘性），一般会严格小于。
2. **把 $\lVert A\rVert_F$ 当算子范数。**$\lVert I\rVert_F=\sqrt n\neq1$ 立刻露馅；F-范数相容但**不从属**。
3. **把 $\lVert A\rVert_2$ 写成 $\lambda_{\max}(A)$。**正确公式是 $\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$；只有对称半正定矩阵才有 $\lVert A\rVert_2=\lambda_{\max}(A)$。反例：$A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$，$\lambda_{\max}(A)=0$ 但 $\lVert A\rVert_2=1$。
4. **行列混淆。**矩阵 1-范数是列和、∞-范数是行和；与向量 1-范数、∞-范数同名不同物，靠「从属」关系记才不会翻车。
5. **以为换范数会改变收敛结论。**等价定理保证「收敛 / 发散」与范数无关；会被改变的是误差**界的大小**与停机的**步数**——报结果必须注明范数。
6. **对非方阵套用 $\lVert A\rVert_1$「列和」公式而不检查定义。**从属范数定义对 $A\in\mathbb{R}^{m\times n}$ 同样成立（$\lVert A\rVert:\mathbb{R}^{m\times n}\to\mathbb{R}$），定理 1.3.5 的三条公式对长方形矩阵逐字成立；而矩阵范数四公理中的乘法结构（条件 4）只在两个矩阵可乘时才会用到。
:::

到这里，已经有了描述单个误差和误差向量的工具。第二章从线性方程组开始，把矩阵范数用于分析消去、分解和迭代计算。
