# 2.4 条件数与扰动分析

> **本节属“补充篇 · 数值线性代数工具箱”**：2.x 是补充篇内部编号，不是课堂第 2 章的节号。课堂第 2 章是[线性方程组的解法](../course/ch02/overview.md)。

第一章的 [1.2.6](../ch01/sec12.md#sec-1.2.6) 引入了条件数的**函数版** $\mathrm{cond}(f,x)=\lvert xf'(x)/f(x)\rvert$，并在 [1.3.6](../ch01/sec13.md#sec-1.3.6) 预告了**矩阵版**。这一节把它兑现：条件数为什么这样定义，右端与系数扰动各被放大多少，以及**为什么「残差小」不等于「解准」**——走完这几步，「这个方程组还能保住几位有效数字」就能用一个数预测出来。

<a id="sec-2.4.1"></a>


{{#include ../assets/figures/numerical-condition.md}}

## 2.4.1 条件数的定义与它量的东西

::: intuition 直觉 · 条件数 = 问题本身最大的「误差放大倍数」
[1.2.6](../ch01/sec12.md#sec-1.2.6) 已经把 conditioning 与 stability 分开讲了：**敏感是问题天生的，做法是我们选的**。矩阵版的条件数回答的是同一个问题，只是输入、输出从标量换成了向量：

$$\text{输入端扰动}\ \delta\boldsymbol{b}\quad\longrightarrow\quad\text{输出端扰动}\ \delta\boldsymbol{x}.$$

放大倍数由**两条链条相乘**得到（推导见 2.4.2）：第一条，扰动经过 $A^{-1}$ 被放大，因子是 $\lVert A^{-1}\rVert$；第二条，把解的分母换成右端的分母，代价是因子 $\lVert A\rVert$。两条相乘，正好是 $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$。

**三条推论立刻可用：** $\mathrm{cond}(A)\ge1$（因为 $I=AA^{-1}$）；$\mathrm{cond}(A)=\infty$ 当且仅当 $A$ 奇异；$\mathrm{cond}$ 的数值依赖所选范数，但各范数之间最多差一个与 $n$ 有关的常数（范数等价性）。
:::

::: def 定义 2.4.1 · 条件数 {#def-2.4.1}
设 $A\in\mathbb{R}^{n\times n}$ 非奇异，$\lVert\cdot\rVert$ 是某种矩阵范数。称

$$\mathrm{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert \tag{2.17}$$

为矩阵 $A$（在范数 $\lVert\cdot\rVert$ 下）的**条件数**（condition number）。若 $\lVert\cdot\rVert$ 是从属于向量 $\lVert\cdot\rVert_p$ 的算子范数，记 $\mathrm{cond}_p(A)$；$p=2$ 时称**谱条件数**（spectral condition number）。
:::

::: thm 定理 2.4.1（新增） · 条件数的基本性质 {#thm-2.4.1}
设 $A,B\in\mathbb{R}^{n\times n}$ 非奇异，则

1. $\mathrm{cond}(A)\ge1$（$1=\lVert I\rVert=\lVert AA^{-1}\rVert\le\lVert A\rVert\lVert A^{-1}\rVert$，此步要求 $\lVert I\rVert=1$，如算子范数；F-范数下只能得 $\mathrm{cond}_F\ge\sqrt n$）。等号可以取到：$\mathrm{cond}_2$ 下取等 $\iff$ 所有奇异值相等 $\iff$ $A=c\cdot$（正交阵）（$c\neq0$）——标量阵只是其中最简单的例子；
2. $\mathrm{cond}(A^{-1})=\mathrm{cond}(A)$；
3. $\mathrm{cond}(cA)=\mathrm{cond}(A)$（$c\neq0$）——**条件数与整体尺度无关**；
4. $\mathrm{cond}_2(A)=\dfrac{\sigma_{\max}(A)}{\sigma_{\min}(A)}$（$=\sqrt{\lambda_{\max}(A^{\mathrm T}A)/\lambda_{\min}(A^{\mathrm T}A)}$）；
5. 对正交矩阵 $Q$：$\mathrm{cond}_2(Q)=1$；
6. 对任意 $\boldsymbol{x}\neq\boldsymbol{0}$：$\dfrac{1}{\mathrm{cond}(A)}\le\dfrac{\lVert A\boldsymbol{x}\rVert}{\lVert A\rVert\lVert\boldsymbol{x}\rVert}\le1$，且 $\dfrac{\lVert\boldsymbol{x}\rVert}{\lVert A\rVert\lVert A^{-1}\boldsymbol{x}\rVert}\le\dfrac{\lVert A^{-1}\boldsymbol{x}\rVert}{\lVert A^{-1}\rVert\lVert\boldsymbol{x}\rVert}\le1$——放大与缩小因子都被 $\mathrm{cond}$ 夹住；
7. **不可乘性：** $\mathrm{cond}(AB)\le\mathrm{cond}(A)\mathrm{cond}(B)$，但**不是等式**。

::: proof 证明
**1、2、3** 直接验证：$1=\lVert I\rVert=\lVert AA^{-1}\rVert\le\lVert A\rVert\lVert A^{-1}\rVert$（次可乘，[1.3.3](../ch01/sec13.md#sec-1.3.3)）；$\mathrm{cond}(A^{-1})=\lVert A^{-1}\rVert\lVert A\rVert$；$\mathrm{cond}(cA)=\lvert c\rvert\lVert A\rVert\cdot\lvert c\rvert^{-1}\lVert A^{-1}\rVert=\mathrm{cond}(A)$。

**4：** $\lVert A\rVert_2=\sigma_{\max}(A)$（[1.3.4](../ch01/sec13.md#sec-1.3.4)），且 $A^{-1}$ 的奇异值是 $A$ 的奇异值之倒数（对 $A=U\Sigma V^{\mathrm T}$ 求逆得 $A^{-1}=V\Sigma^{-1}U^{\mathrm T}$），故 $\lVert A^{-1}\rVert_2=1/\sigma_{\min}(A)$。

**5：** 由 [@thm-2.1.5] 第 10 条，正交阵奇异值全为 $1$。

**7：** $(AB)^{-1}=B^{-1}A^{-1}$，故 $\mathrm{cond}(AB)=\lVert AB\rVert\lVert B^{-1}A^{-1}\rVert\le\lVert A\rVert\lVert B\rVert\lVert B^{-1}\rVert\lVert A^{-1}\rVert=\mathrm{cond}(A)\mathrm{cond}(B)$。取 $A=\operatorname{diag}(1,10)$、$B=\operatorname{diag}(10,1)$ 时 $\mathrm{cond}_2(A)=\mathrm{cond}_2(B)=10$、$AB=I$、$\mathrm{cond}_2(AB)=1\lt100$，故一般不是等式。

**性质 4 是工程上最常用的识别手段：$\mathrm{cond}_2$ 就是「最大奇异值 / 最小奇异值」**，因此第 2.6 节用 SVD 算条件数是标准做法（`np.linalg.cond(A, 2)` 内部就用 SVD）。
:::

:::

::: ex 例 2.4.1（新增） · 条件数与尺度的关系 {#ex-2.4.1}
（1）$A=\begin{pmatrix}2&0\\0&4\end{pmatrix}$ 与 $B=\begin{pmatrix}2&2\\2&4\end{pmatrix}$：分别算 $\mathrm{cond}_2$ 与 $\mathrm{cond}_\infty$，并说明为什么两个「看起来差不多」的矩阵，条件数可以差这么多。
（2）验证 $\mathrm{cond}(cA)=\mathrm{cond}(A)$。

::: proof 解
**（1）$A$（对角）。** $\lVert A\rVert_2=4$，$\lVert A^{-1}\rVert_2=\lVert\operatorname{diag}(1/2,1/4)\rVert_2=1/2$，故 $\mathrm{cond}_2(A)=4\times\tfrac12=2$。$\lVert A\rVert_\infty=4$，$\lVert A^{-1}\rVert_\infty=1/2$，故 $\mathrm{cond}_\infty(A)=2$。

**$B$。** $\det B=8-4=4$，$B^{-1}=\frac14\begin{pmatrix}4&-2\\-2&2\end{pmatrix}=\begin{pmatrix}1&-0.5\\-0.5&0.5\end{pmatrix}$。行和：$B$ 为 $4,6$，故 $\lVert B\rVert_\infty=6$；$B^{-1}$ 为 $1.5,1.0$，故 $\lVert B^{-1}\rVert_\infty=1.5$。$\mathrm{cond}_\infty(B)=9$。谱条件数（NumPy）：$\mathrm{cond}_2(B)\approx6.85$（奇异值 $5.236/0.764$）。

**为什么差这么多？** 条件数**不是**在量「矩阵元素有多大」，而是在量**行（列）向量之间的接近程度**。$B$ 的两列 $(2,2)^{\mathrm T}$ 与 $(2,4)^{\mathrm T}$ 夹角约 $18^{\circ}$，比 $A$ 的两列（相互正交）更「接近平行」，于是 $B$ 更接近奇异——**条件数度量的是「离奇异有多远」**。这一点在 [2.6.5](sec26.md#sec-2.6.5) 用最小奇异值讲会更清楚：$\mathrm{cond}_2(A)=1/(\text{相对距离})$。

**（2）** 取 $c=-3$、$A=B$：$cA$ 的行和是原来 $3$ 倍，$(cA)^{-1}$ 的行和是原来 $1/3$ 倍，乘积不变，故 $\mathrm{cond}_\infty(cA)=\mathrm{cond}_\infty(B)=9$ ✓。**条件数对整体缩放免疫**——把方程组每行都乘以 $10^{6}$ 不会改变病态程度。
:::

:::

<a id="sec-2.4.2"></a>

## 2.4.2 右端扰动：推导与「丢掉几位」的定量答案

::: intuition 直觉 · 两条不等式相乘
想知道「$\delta\boldsymbol{b}$ 会造成多大的 $\delta\boldsymbol{x}$」，做两次放缩就够了：

1. 从扰动到解：$\delta\boldsymbol{x}=A^{-1}\delta\boldsymbol{b}$，故 $\lVert\delta\boldsymbol{x}\rVert\le\lVert A^{-1}\rVert\lVert\delta\boldsymbol{b}\rVert$（放大因子 $\lVert A^{-1}\rVert$）；
2. 从解到右端：$\boldsymbol{b}=A\boldsymbol{x}$，故 $\lVert\boldsymbol{b}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$，即 $\dfrac{1}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}$（把解的分母换成右端的分母，代价是「放大」因子 $\lVert A\rVert$）。

两式相乘，$\mathrm{cond}(A)$ 自己就冒出来了。**这算不上什么技巧，条件数本来就是这么长出来的**——它就是这两条链条的乘积。
:::

::: thm 定理 2.4.2（新增） · 右端扰动下的相对误差界 {#thm-2.4.2}
设 $A$ 非奇异，$\boldsymbol{b}\neq\boldsymbol{0}$，$\boldsymbol{x}=A^{-1}\boldsymbol{b}$。若右端受扰为 $\boldsymbol{b}+\delta\boldsymbol{b}$，解相应变为 $\boldsymbol{x}+\delta\boldsymbol{x}$，则

$$\frac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\cdot\frac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert} . \tag{2.18}$$

**而且这个界是紧的：** 对每个矩阵 $A$，都能找到右端扰动使上述比值任意接近 $\mathrm{cond}(A)$（在具体某对向量上未必取等，但这个界本身不能再改进）。

::: proof 证明
两式相减：$A\,\delta\boldsymbol{x}=\delta\boldsymbol{b}$，故 $\delta\boldsymbol{x}=A^{-1}\delta\boldsymbol{b}$，取范数并用相容性：

$$\lVert\delta\boldsymbol{x}\rVert\le\lVert A^{-1}\rVert\lVert\delta\boldsymbol{b}\rVert .$$

又由 $\boldsymbol{b}=A\boldsymbol{x}$ 得 $\lVert\boldsymbol{b}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$，即 $\dfrac{1}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}$。两式相乘即得（2.18）。

**紧性：** 关键在于 $\boldsymbol{x}$ 与 $\delta\boldsymbol{b}$ 可以独立选取。把 $\boldsymbol{x}$ 取成使 $\lVert A\boldsymbol{x}\rVert/\lVert\boldsymbol{x}\rVert=\lVert A\rVert$ 的向量、把 $\delta\boldsymbol{b}$ 取成使 $\lVert A^{-1}\delta\boldsymbol{b}\rVert/\lVert\delta\boldsymbol{b}\rVert=\lVert A^{-1}\rVert$ 的向量，两条链就各自取到等号。

但这两个方向一般不重合，所以**界在具体某对向量上未必达到**。不过总能构造出使比值趋于 $\mathrm{cond}$ 的实例（例如 $A$ 对称时，$\boldsymbol{x}$ 取最小特征值方向、$\delta\boldsymbol{b}$ 取最大特征值方向）。因此（2.18）是**最优的一般界**，没法再改进；具体问题的实际放大倍数则可能小于它。
:::

:::

::: method 从条件数直接读出「丢掉几位有效数字」

把（2.18）翻译成实用说法：若右端的相对误差是机器精度 $u\approx10^{-16}$，解的相对误差就可能大到 $\mathrm{cond}(A)\cdot u$。再用第一章的「有效数字 ↔ 相对误差」换算（[1.2.2](../ch01/sec12.md#sec-1.2.2)），**解丢失的有效数字位数约为**

$$k\approx\log_{10}\mathrm{cond}(A) . \tag{2.19}$$

| $\mathrm{cond}(A)$ | 预计丢失位数 $k$ | 双精度下剩下的有效数字 | 工程含义 |
|:--:|:--:|:--:|:--|
| $10^{0}\sim10^{2}$ | $0\sim2$ | $14\sim16$ | 良态，随便算 |
| $10^{6}$ | $6$ | $\approx10$ | 仍安全（$\mathrm{cond}\cdot u\approx10^{-10}$） |
| $10^{10}$ | $10$ | $\approx6$ | 需留意：只剩 6 位 |
| $10^{13}$ | $13$ | $\approx3$ | 危险：Hilbert 10 阶即在此 |
| $10^{16}$ | $16$ | $\approx0$ | 与单精度同水平，双精度也救不了 |
| $\gt10^{16}$ | $\gt16$ | $0$ | 数值上等同奇异 |

**判据（记住这两个阈值）：** $\mathrm{cond}\gtrsim10^{8}=u^{-1/2}$ 时，**正态方程（[2.2.4](sec22.md#sec-2.2.4)）必须换成 QR**；$\mathrm{cond}\gtrsim10^{16}=u^{-1}$ 时，**任何双精度算法都救不了**，只能重述问题（正则化 / 提高精度 / 换模型）。
:::

::: ex 例 2.4.2（新增） · Hilbert 矩阵：条件数预测的数值验证 {#ex-2.4.2}
**目的：** 验证（2.19）——条件数是不是真能预测丢掉几位。取 $n$ 阶 Hilbert 矩阵 $H_n=[1/(i+j-1)]$，真解取 $\boldsymbol{x}=\boldsymbol{1}$，构造 $\boldsymbol{b}=H_n\boldsymbol{x}$，再用双精度求解，看实际误差有多大。

::: proof 解
```python
import numpy as np
u = np.finfo(float).eps / 2            # ≈1.11e-16
for n in [4, 6, 8, 10, 12]:
    H = np.array([[1/(i+j+1.0) for j in range(n)] for i in range(n)])
    x = np.ones(n); b = H @ x
    xh = np.linalg.solve(H, b)          # 双精度求解
    cond = np.linalg.cond(H, 2)
    err = np.max(np.abs(xh - x))
    print(f"n={n:2d} cond={cond:9.3e} log10(cond)={np.log10(cond):5.1f} "
          f"实测最大误差={err:9.3e} cond*u={cond*u:9.3e}")
```

```text
n= 4 cond=1.551e+04 log10(cond)=  4.2 实测最大误差=5.0e-14 cond*u=1.7e-12
n= 6 cond=1.495e+07 log10(cond)=  7.2 实测最大误差=2.3e-10 cond*u=1.7e-09
n= 8 cond=1.526e+10 log10(cond)= 10.2 实测最大误差=1.6e-07 cond*u=1.7e-06
n=10 cond=1.603e+13 log10(cond)= 13.2 实测最大误差=7.4e-04 cond*u=1.8e-03
n=12 cond=1.719e+16 log10(cond)= 16.2 实测最大误差=2.2e-01 cond*u=1.9e+00
```

**读这张表，看三件事：**

1. **实测误差与 $\mathrm{cond}\cdot u$ 同量级**（$n=6$ 时 $2.3\times10^{-10}$ 对 $1.7\times10^{-9}$；$n=10$ 时 $7.4\times10^{-4}$ 对 $1.8\times10^{-3}$；$n=12$ 时 $0.22$ 对 $1.9$）——**条件数确实能预测精度**。要注意实测值通常**比界小几倍**，因为（2.19）给的是最坏情形估计；$n=4$ 那一行（$5.0\times10^{-14}$ 对 $1.7\times10^{-12}$）界尤其保守，说明条件数小的时候实际误差远小于界。
2. **$n=12$ 时解已完全失效**（误差 $0.22$，而真值全是 $1$）：$\mathrm{cond}\cdot u=1.9\gt1$，相对误差可以超过 $100\%$。**用双精度解 12 阶 Hilbert 系统，在这个意义上是没有意义的**——尽管 `np.linalg.solve` 返回了一堆看起来很正常的数。
3. **Hilbert 矩阵的条件数大致按 $10^{1.5n}$ 增长**：每增加一阶，就多丢约 $1.5$ 位。$n=14$ 时 $\mathrm{cond}\approx4\times10^{17}\gt1/u$，双精度彻底失效。

**验收标准：** 你机器上算出的 $\mathrm{cond}$ 应与上表一致（相对差别在 $10^{-3}$ 量级内），误差随 BLAS 实现略有不同但同量级；把 `np.linalg.solve` 换成手写 Cholesky，误差量级不变——**因为病态是问题的属性，不是算法的**（[1.2.6](../ch01/sec12.md#sec-1.2.6) 的核心区分）。
:::

:::

<a id="sec-2.4.3"></a>

## 2.4.3 系数扰动

右端扰动只是故事的一半。工程中更常见的情形是**矩阵本身来自测量或建模，也带着误差**。这时的界更复杂，但结论极其重要。

::: intuition 直觉 · 系数扰动为什么更可怕
如果 $A$ 的每个元素只错 $u$ 量级（相对），按直觉解也该只错 $u$ 量级。可是界里偏偏冒出一项 $\mathrm{cond}(A)/(1-\mathrm{cond}(A)\varepsilon)$——**分母里带着条件数**。这就意味着，一旦 $\mathrm{cond}(A)\cdot\varepsilon$ 接近 $1$，界自己就先「炸掉」了。不是解真的错到无穷，而是**$A$ 已经被扰动到可能奇异**。一句话：**$\mathrm{cond}(A)\varepsilon\ge1$ 时，扰动后的矩阵可能与原矩阵分属「可逆」与「奇异」两侧，连解的存在性都保不住。**
:::

::: thm 定理 2.4.3（新增） · 系数扰动下的相对误差界 {#thm-2.4.3}
设 $A$ 非奇异，$\boldsymbol{b}\neq\boldsymbol{0}$，$\boldsymbol{x}=A^{-1}\boldsymbol{b}$。若系数受扰 $A\to A+\delta A$，且

$$\varepsilon:=\lVert A^{-1}\rVert\,\lVert\delta A\rVert=\mathrm{cond}(A)\cdot\frac{\lVert\delta A\rVert}{\lVert A\rVert}\lt1 , \tag{2.20}$$

则 $A+\delta A$ 仍非奇异，且扰动解 $\boldsymbol{x}+\delta\boldsymbol{x}=(A+\delta A)^{-1}\boldsymbol{b}$ 满足

$$\frac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\frac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\lVert\delta A\rVert/\lVert A\rVert}\cdot\frac{\lVert\delta A\rVert}{\lVert A\rVert} . \tag{2.21}$$

**若同时扰动 $A$ 与 $\boldsymbol{b}$**（相对扰动分别为 $\rho_A=\lVert\delta A\rVert/\lVert A\rVert$、$\rho_b=\lVert\delta\boldsymbol{b}\rVert/\lVert\boldsymbol{b}\rVert$），则

$$\frac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\frac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}\bigl(\rho_A+\rho_b\bigr) . \tag{2.22}$$

::: proof 证明
**（一）非奇异性（$\varepsilon\lt1$ 时的第一步）。** 由 $\lVert A^{-1}\delta A\rVert\le\lVert A^{-1}\rVert\lVert\delta A\rVert=\varepsilon\lt1$ 与定理 1.3.6（$\lVert\cdot\rVert\lt1\Rightarrow I\pm\cdot$ 可逆，[@thm-1.3.6]），$I+A^{-1}\delta A$ 可逆，故

$$A+\delta A=A(I+A^{-1}\delta A)$$

作为可逆矩阵之积可逆，且

$$(A+\delta A)^{-1}=(I+A^{-1}\delta A)^{-1}A^{-1},\qquad
\bigl\lVert(I+A^{-1}\delta A)^{-1}\bigr\rVert\le\frac{1}{1-\lVert A^{-1}\delta A\rVert}\le\frac{1}{1-\varepsilon} .$$

**（二）误差估计。** 记 $\boldsymbol{x}+\delta\boldsymbol{x}=(A+\delta A)^{-1}\boldsymbol{b}$。则

$$\delta\boldsymbol{x}=(A+\delta A)^{-1}\boldsymbol{b}-A^{-1}\boldsymbol{b}
=\bigl[(I+A^{-1}\delta A)^{-1}-I\bigr]A^{-1}\boldsymbol{b}
=\bigl[(I+A^{-1}\delta A)^{-1}-I\bigr]\boldsymbol{x} .$$

用恒等式 $(I+S)^{-1}-I=-(I+S)^{-1}S$（令 $S=A^{-1}\delta A$）：

$$\delta\boldsymbol{x}=-(I+A^{-1}\delta A)^{-1}A^{-1}\delta A\,\boldsymbol{x},\qquad
\lVert\delta\boldsymbol{x}\rVert\le\frac{\lVert A^{-1}\rVert\lVert\delta A\rVert\lVert\boldsymbol{x}\rVert}{1-\varepsilon}=\frac{\varepsilon\lVert\boldsymbol{x}\rVert}{1-\varepsilon} .$$

两边除以 $\lVert\boldsymbol{x}\rVert$、把 $\varepsilon$ 展开即得（2.21）。同时扰动时把 $\delta\boldsymbol{b}$ 的贡献加上（与右端扰动同法）即得（2.22）。

**这里有两点值得注意。** ① 上面用到了第一章的定理 1.3.6（Neumann 界），**这是它在第二章的第一次实战**：课堂上老师用反证法证过这条定理，还演示了 $\lVert A\rVert_1=0.7<1$ 判 $I+A$ 可逆的数值例（见[第 3 讲精编](../lectures/lec03.md)）；本节反复使用的「∞-范数 = 行和」也出自那一讲。② 条件（2.20）并非可有可无的技术性假设——它恰好刻画了「$\delta A$ 还没把 $A$ 推过奇异点」这件事。
:::

:::

::: ex 例 2.4.3（新增） · 系数扰动界的验证 {#ex-2.4.3}
取 $A=\begin{pmatrix}1&2\\2&4.0001\end{pmatrix}$（$\mathrm{cond}_2\approx2.5\times10^{5}$），$\boldsymbol{x}=(1,1)^{\mathrm T}$，$\boldsymbol{b}=A\boldsymbol{x}$。取只有右下角受扰的 $\delta A=\begin{pmatrix}0&0\\0&t\end{pmatrix}$，$t=10^{-4}$ 与 $10^{-6}$，比较实测误差与（2.21）的界。

::: proof 解
$$\mathrm{cond}_\infty(A)=\lVert A\rVert_\infty\lVert A^{-1}\rVert_\infty .$$

$A^{-1}=\dfrac{1}{4.0001-4}\begin{pmatrix}4.0001&-2\\-2&1\end{pmatrix}=10^{4}\begin{pmatrix}4.0001&-2\\-2&1\end{pmatrix}$，行和 $(6.0001,\ 3)$，故 $\lVert A^{-1}\rVert_\infty\approx6.0\times10^{4}$；$\lVert A\rVert_\infty=6.0001$。$\mathrm{cond}_\infty\approx3.6\times10^{5}$。

**$t=10^{-4}$：** $\lVert\delta A\rVert_\infty=10^{-4}$，$\rho_A=10^{-4}/6.0001\approx1.67\times10^{-5}$，$\varepsilon=\mathrm{cond}\cdot\rho_A\approx6.0\gt1$——**条件（2.20）不满足，定理不适用**：

$$\text{界的分母 }1-\varepsilon=1-6.0=-5.0\lt0\ \longrightarrow\ \text{负数！}$$

**这说明什么？** 分母变负不是推导出了差错，而是定理在**报警**：$\varepsilon\gt1$ 说明 $\delta A$ 的量级已经足够把 $A$ 推过奇异点（$\mathrm{cond}\cdot\rho_A\ge1$ 正是「$A+\delta A$ 可能奇异」的定量刻画）。而此时扰动方程组确实失控了：精确解为 $x_2=\dfrac{10^{-4}}{10^{-4}+t}=\dfrac12$、$x_1=3-2x_2=2$，相对误差达 $100\%$。教训：**系数扰动的界只在 $\mathrm{cond}\cdot\rho_A\ll1$ 时可用，一旦越过 $1$，就完全是另一回事。**

**改用更小的扰动。** 取 $t=10^{-6}$ 重算：$\rho_A\approx1.67\times10^{-7}$，$\varepsilon=\mathrm{cond}\cdot\rho_A\approx0.060\lt1$（条件满足），

$$\text{界}=\frac{3.6\times10^{5}}{1-0.060}\times1.67\times10^{-7}\approx0.064 .$$

**实测：** 消元得 $(10^{-4}+t)x_2=10^{-4}$，即 $x_2=\dfrac{10^{-4}}{10^{-4}+t}\approx0.9901$、$x_1=3-2x_2\approx1.0198$，相对误差 $\approx2\%$。**界 $0.064$ 只比实测大 $3$ 倍**，对「只扰动一个元素」这种良性扰动已经相当紧；当然界仍是**最坏情形**（最坏扰动方向能让 $\lVert A^{-1}\delta A\rVert$ 达到 $\mathrm{cond}\cdot\rho_A$，本例远没有达到）。**界的方向和量级都对。**

**真正的结论：** 两个尺度必须拼起来看。$\varepsilon=\mathrm{cond}\cdot\rho_A\lt1$ 时，界可用且方向正确（本例实测只是它的若干分之一）；$\varepsilon\gt1$ 时定理失效，解可以完全失控（$t=10^{-4}$ 那段就是）。当 $\rho_A=u\approx10^{-16}$、$\mathrm{cond}=10^{5}$ 时，$\mathrm{cond}\cdot u\approx10^{-11}$，即**最多丢 11 位**。这与（2.19）完全一致。
:::

:::

<a id="sec-2.4.4"></a>

## 2.4.4 残差与误差：最容易误解的一对概念

::: intuition 直觉 · 残差是「方程被满足多少」，误差是「解离真值多远」
这是本章**最需要理解准确**的一对概念。看一个病态方程组：

- $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$ 是**可以算的**（$\boldsymbol{b}$ 和 $\hat{\boldsymbol{x}}$ 都在手上）。它衡量 $\hat{\boldsymbol{x}}$ 把方程解得有多好。
- $\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$ 一般**算不出来**（真解 $\boldsymbol{x}$ 并不知道）。它衡量 $\hat{\boldsymbol{x}}$ 离真值有多远。

**残差小 ⟹ 误差大**是完全可能的：病态矩阵能把「很小的残差」放大成「很大的误差」。许多工程事故就栽在把这两个量混为一谈——**求解器报告残差 $\sim10^{-15}$，用户以为解准到 15 位，实际上第 3 位就是错的。**
:::

::: thm 定理 2.4.4（新增） · 残差与误差的定量关系 {#thm-2.4.4}
设 $\hat{\boldsymbol{x}}$ 是 $A\boldsymbol{x}=\boldsymbol{b}$ 的近似解，$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$，$\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$。则

$$\boldsymbol{e}=A^{-1}\boldsymbol{r},\qquad\text{故}\qquad
\lVert\boldsymbol{e}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol{r}\rVert,\qquad
\frac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\cdot\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert} . \tag{2.23}$$

**配套的「向下界」（它说明上界不是空的，而且误差反过来也控制着残差）：**

$$\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\ \le\ \mathrm{cond}(A)\cdot\frac{\lVert\boldsymbol{e}\rVert/\lVert\hat{\boldsymbol{x}}\rVert}{1-\lVert\boldsymbol{e}\rVert/\lVert\hat{\boldsymbol{x}}\rVert}$$

（右端分母里用的是近似解而不是真解，只要 $\lVert\hat{\boldsymbol{x}}\rVert\gt\lVert\boldsymbol{x}\rVert/2$，这个量就是**可以算出来的**；此式说明误差大时残差必大——与 (2.23) 合起来，同一件事被 $\mathrm{cond}$ 从上下两头夹住。）一句话：**残差小推不出误差小，但残差小再加上条件数小，就能推出误差小。**

::: proof 证明
由 $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}=A\boldsymbol{x}-A\hat{\boldsymbol{x}}=-A\boldsymbol{e}$ 得 $\boldsymbol{e}=-A^{-1}\boldsymbol{r}$，取范数并用相容性得第一式。再用 $\lVert\boldsymbol{b}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$ 得 $\dfrac{1}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}$，相乘即得（2.23）。

**向下界的证明**留作[习题 B5](exercises.md) 的补充（提示：$\boldsymbol{b}=\boldsymbol{r}+A\hat{\boldsymbol{x}}-A\boldsymbol{e}$ 与 $\lVert\hat{\boldsymbol{x}}\rVert\le\lVert\boldsymbol{x}\rVert+\lVert\boldsymbol{e}\rVert$ 双向放缩）；完整推导见[附录 A.2.2](../appendix/derivations.md#app-a-2-2)。

**（2.23）回答了「求解器到底报告了什么」：** 求解器能保证的是**残差**（后向误差，[1.2.6](../ch01/sec12.md#sec-1.2.6)），用户想要的却是**误差**（前向误差）——两者之间恰好隔着一个 $\mathrm{cond}(A)$。**这正是 [1.2.6](../ch01/sec12.md#sec-1.2.6) 那张 conditioning/stability 表格的矩阵版。**
:::

:::

::: ex 例 2.4.4（新增） · 残差 $10^{-12}$，误差 $50\%$——亲手构造 {#ex-2.4.4}
构造一个方程组，使某近似解的残差范数只有 $\lVert\boldsymbol{b}\rVert$ 的 $10^{-12}$，但解的相对误差高达 $50\%$。

::: proof 解
取

$$A=\begin{pmatrix}1&1\\1&1+\varepsilon\end{pmatrix},\qquad \varepsilon=10^{-11},\qquad
\boldsymbol{x}=\begin{pmatrix}1\\1\end{pmatrix},\qquad \boldsymbol{b}=A\boldsymbol{x}=\begin{pmatrix}2\\2+\varepsilon\end{pmatrix}.$$

$\mathrm{cond}_\infty(A)\approx4\times10^{11}$（第 1、2 行几乎成比例）。

**取近似解 $\hat{\boldsymbol{x}}=(1.5,\ 0.5)^{\mathrm T}$**（与真解 $(1,1)^{\mathrm T}$ 差得很远）：

$$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}=\begin{pmatrix}2-(1.5+0.5)\\2+\varepsilon-(1.5+0.5(1+\varepsilon))\end{pmatrix}=\begin{pmatrix}0\\\varepsilon-0.5\varepsilon\end{pmatrix}=\begin{pmatrix}0\\0.5\varepsilon\end{pmatrix}.$$

$$\frac{\lVert\boldsymbol{r}\rVert_\infty}{\lVert\boldsymbol{b}\rVert_\infty}=\frac{5\times10^{-12}}{2+\varepsilon}\approx2.5\times10^{-12}\quad(\text{残差小极了！})$$

$$\frac{\lVert\boldsymbol{e}\rVert_\infty}{\lVert\boldsymbol{x}\rVert_\infty}=\frac{0.5}{1}=50\%\quad(\text{误差大得离谱！})$$

**核对界（2.23）：** $\mathrm{cond}_\infty\cdot\dfrac{\lVert\boldsymbol{r}\rVert_\infty}{\lVert\boldsymbol{b}\rVert_\infty}\approx4\times10^{11}\times2.5\times10^{-12}=1.0$，界给出「相对误差 $\le100\%$」——实测 $50\%$，**在界内** ✓。

```python
import numpy as np
eps = 1e-11
A = np.array([[1.0, 1.0], [1.0, 1.0 + eps]])
x = np.array([1.0, 1.0]); b = A @ x
xh = np.array([1.5, 0.5])                      # 一个「相距很远」的近似解
r = b - A @ xh; e = xh - x
print(f"cond_inf(A) = {np.linalg.cond(A, np.inf):.3e}")
print(f"||r||∞/||b||∞ = {np.linalg.norm(r,np.inf)/np.linalg.norm(b,np.inf):.3e}   ← 残差极小")
print(f"||e||∞/||x||∞ = {np.linalg.norm(e,np.inf)/np.linalg.norm(x,np.inf):.3e}   ← 误差巨大")
```

```text
cond_inf(A) = 4.000e+11
||r||∞/||b||∞ = 2.500e-12   ← 残差极小
||e||∞/||x||∞ = 5.000e-01   ← 误差巨大
```

**这个例子为什么能成立？** 因为 $A$ 的两行几乎一样，两个方程
$$x_1+x_2\approx2,\qquad x_1+x_2\approx2$$
实际上是**同一个方程**：两个未知数只有一个有效约束，解可以沿着直线 $x_1+x_2=2$ 滑动。$(1.5,0.5)$ 与 $(1,1)$ 都近似落在这条线上，所以**残差都很小**；但两点相距 $0.5$，所以**误差很大**。

**工程含义：** 不要把残差当作误差的代理指标。**判据是 $\mathrm{cond}(A)\cdot\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$，不是 $\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$。**
:::

:::

<a id="sec-2.4.5"></a>

## 2.4.5 条件数的估计与改进

::: method 工程上怎么用（五条）

**① 先估 $\mathrm{cond}$，再定精度要求。** $\mathrm{cond}$ 一旦算出，要丢的位数 $k\approx\log_{10}\mathrm{cond}$ 立刻可得。NumPy 一行搞定：`np.linalg.cond(A)`（默认 2-范数，内部用 SVD，成本约 $O(n^3)$）。矩阵很大时可以改用 $\mathrm{cond}_1$ 或 $\mathrm{cond}_\infty$（`np.linalg.cond(A, np.inf)`）——它先显式求逆再取范数（`inv` + `norm`），对大矩阵往往比 SVD 便宜。

**② 别自己硬算 $\lVert A^{-1}\rVert$。** `np.linalg.cond` 内部已经处理好，你不需要真的去求逆（2-范数版直接看奇异值）。手写 `np.linalg.norm(np.linalg.inv(A))` 既引入额外误差，又更慢。

**③ 元素量级悬殊时，用成分条件数或 Skeel 条件数。** 若 $A$ 各元素的量级相差极大（如 $a_{11}\sim1$、$a_{22}\sim10^{10}$），全局 $\mathrm{cond}$ 会给出**过于悲观**的结论，因为它假定每个元素都受到相对扰动。更合适的是**成分条件数**（componentwise condition number）与 **Skeel 条件数**

$$\mathrm{cond}_{\mathrm{Skeel}}(A)=\lVert\,\lvert A^{-1}\rvert\,\lvert A\rvert\,\rVert_\infty , \tag{2.24}$$

（$\lvert A\rvert$ 表示逐元素取绝对值。）这个数恰好是「元素相对扰动」下的放大因子，且总有 $\mathrm{cond}_{\mathrm{Skeel}}(A)\le\mathrm{cond}_\infty(A)\le n\,\mathrm{cond}_{\mathrm{Skeel}}(A)$。LAPACK 的 `gecon` 估计**范数版**条件数（基于 `getrf` 的 LU 分解做 $O(n^2)$ 逆估计，不求逆）；**成分条件数**则出现在残差迭代精化 `gerfs` 的误差界里。

**④ 提高精度的三种正规手段**（按代价从低到高）：
- **迭代精化**（iterative refinement）：先用双精度算残差 $\boldsymbol{r}=\boldsymbol{b}-A\boldsymbol{x}$（病态时这一项反而算得准，因为残差本身就是小量），再解修正方程 $A\delta\boldsymbol{x}=\boldsymbol{r}$，令 $\boldsymbol{x}\leftarrow\boldsymbol{x}+\delta\boldsymbol{x}$。代价低，能把精度恢复到接近机器精度。
- **提高工作精度**：用 `float128`、双-双精度（double-double）或 MPFR。代价高，但治本。
- **重述问题**：正则化（Tikhonov，[习题 D2](exercises.md)）、换配方（如求根公式用韦达改述，[1.2.4](../ch01/sec12.md#sec-1.2.4) 原则 (2)）、换坐标系（去中心化、归一化）。

**⑤ 区分「病态」与「缩放不良」。** 若各行量级相差 $10^{15}$，方程组看起来病态；但**给每行乘上适当的常数**（行缩放 / 均衡化）之后，条件数可能大幅下降——这不是问题固有的病态，只是单位没选好。**先做行均衡化，再看条件数**，这是实践中的标准第一步。
:::

::: ex 例 2.4.5（新增） · 行缩放救回一个「假病态」矩阵 {#ex-2.4.5}
取

$$A=\begin{pmatrix}1&1\\10^{10}&10^{10}+1\end{pmatrix},$$

计算 $\mathrm{cond}_\infty$ 与行均衡化后的 $\mathrm{cond}_\infty$。

::: proof 解
**原始 $\mathrm{cond}_\infty$：** $\lVert A\rVert_\infty$ 是**行和**——第 2 行 $=10^{10}+(10^{10}+1)=2\times10^{10}+1$。$\det A=(10^{10}+1)-10^{10}=1$，故

$$A^{-1}=\begin{pmatrix}10^{10}+1&-1\\-10^{10}&1\end{pmatrix},\qquad \lVert A^{-1}\rVert_\infty=\max(10^{10}+2,\ 10^{10}+1)=10^{10}+2 .$$

$$\mathrm{cond}_\infty(A)=(2\times10^{10}+1)(10^{10}+2)\approx2\times10^{20}\ \ (\text{看起来完全不可解!})$$

**行均衡化：** 把每一行都除以该行绝对值最大的元素（第 2 行除以 $10^{10}+1$，与下面代码一致；说「除以 $10^{10}$」只影响 $B_{21}$ 是否恰好为 $1$，不影响量级），得 $B\approx\begin{pmatrix}1&1\\1&1+10^{-10}\end{pmatrix}$。

$$\lVert B\rVert_\infty\approx2,\qquad B^{-1}=\frac{1}{10^{-10}}\begin{pmatrix}1+10^{-10}&-1\\-1&1\end{pmatrix},\qquad
\lVert B^{-1}\rVert_\infty\approx(2+10^{-10})\times10^{10}\approx2\times10^{10},$$

$$\mathrm{cond}_\infty(B)\approx4\times10^{10}\ .$$

**结论：** 条件数从 $10^{20}$ 降到 $4\times10^{10}$——**降了 $10^{10}$ 倍**。原来的 $10^{20}$ 里有一半要记在「第 2 行比第 1 行大 $10^{10}$ 倍」这个**单位问题**上，与矩阵真实的敏感度无关。

**但要注意：** $\mathrm{cond}\approx4\times10^{10}$ 仍不算小（$B$ 的两行确实几乎成比例），**行缩放不能把一个真病态的矩阵变成良态**——它只能剥掉「单位不一致」这一层。$\mathrm{cond}_\infty(B)\approx4\times10^{10}$ 与例 2.4.4 的 $\mathrm{cond}_\infty\approx4\times10^{11}$ 同量级，而后者才是**真病态**（两行近乎平行），只能靠重述问题或提高精度来对付。

**验算代码：**
```python
import numpy as np
A = np.array([[1.0, 1.0], [1e10, 1e10 + 1]])
print(np.linalg.cond(A, np.inf))          # ≈2.0e20
B = A / A.max(axis=1, keepdims=True)      # 行均衡化
print(np.linalg.cond(B, np.inf))          # ≈4.0e10
```

:::

:::

<a id="sec-2.4.6"></a>

## 2.4.6 小结与常见错误

::: method[core] 本节公式速查

| 概念 | 公式 / 结论 |
|:--|:--|
| 条件数 | $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$；$\mathrm{cond}_2(A)=\sigma_{\max}/\sigma_{\min}$ |
| 基本性质 | $\ge1$；$\mathrm{cond}(A^{-1})=\mathrm{cond}(A)$；$\mathrm{cond}(cA)=\mathrm{cond}(A)$；$\mathrm{cond}_2(Q)=1$ |
| 右端扰动 | $\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert}$（**紧界**） |
| 系数扰动 | $\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}(\rho_A+\rho_b)$，需 $\mathrm{cond}\cdot\rho_A\lt1$ |
| 有效数字损失 | $k\approx\log_{10}\mathrm{cond}(A)$ |
| 残差 vs 误差 | $\boldsymbol{e}=A^{-1}\boldsymbol{r}$，$\dfrac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$ |
| Skeel 条件数 | $\lVert\,\lvert A^{-1}\rvert\,\lvert A\rvert\,\rVert_\infty$（元素扰动下的正确度量） |
| 两个阈值 | $\mathrm{cond}\gtrsim10^{8}$：弃正态方程；$\mathrm{cond}\gtrsim10^{16}$：双精度无解 |

:::

::: think[core] 常见错误清单 · 自查七条
1. **拿残差当误差的代理。** 例 2.4.4 中残差只有 $2.5\times10^{-12}$，误差却高达 $50\%$。**该看的判据是 $\mathrm{cond}\cdot\lVert\boldsymbol{r}\rVert/\lVert\boldsymbol{b}\rVert$。** 求解器返回的残差只说明「算法向后稳定」，并不说明「结果准」。
2. **把「病态」当成「算法不好」。** 病态是 $A$ 的属性（[1.2.6](../ch01/sec12.md#sec-1.2.6)）。同一个病态矩阵，换 Cholesky、换 QR、换 SVD，误差量级**都一样**——都是 $\mathrm{cond}\cdot u$。要改进只能**重述问题**或**提高精度**。
3. **忘了行均衡化。** 各行量级相差 $10^{10}$ 时，$\mathrm{cond}_\infty$ 会被「单位不一致」污染（例 2.4.5 从 $10^{20}$ 降到 $4\times10^{10}$）。**先均衡化再评估**是标准流程。
4. **手写 `inv(A)` 算条件数。** 用 `np.linalg.cond(A)`；它更快（2-范数用 SVD、1/∞-范数用 LU 估计），也更准。手写求逆还会引入额外误差。
5. **以为 $\mathrm{cond}$ 与范数无关。** $\mathrm{cond}_1,\mathrm{cond}_2,\mathrm{cond}_\infty$ 的数值可以差 $n$ 倍量级，但「丢失位数」的**结论**一致（范数等价）。**报告时必须注明范数**（[1.3.6](../ch01/sec13.md#sec-1.3.6) 的礼仪）。
6. **把 $\mathrm{cond}\cdot u$ 当成精确预测。** 它是**最坏情形的上界**（例 2.4.3 的界比实测大 $3$ 倍）。实际误差通常更小，但设计系统时必须以界为准。
7. **在 $\mathrm{cond}\cdot\rho_A\ge1$ 时还硬套系数扰动界。** 此时界会给出荒谬结果（例 2.4.3 的负数），因为 $A$ 可能已被推到奇异附近——**正确的做法是先判断问题是否还适定**。
:::

::: preview 课程预告 · 本节之后
- **怎么不算逆就估出 $\mathrm{cond}$？** [2.6](sec26.md) 用 SVD 的 $\sigma_1/\sigma_r$；LAPACK 的 `gecon` 用 LU 的对角元做估计（原书第 2 章 2.3.2「关于病态线性方程组的求解问题」）；
- **$\mathrm{cond}\gtrsim10^{16}$ 时怎么办？** 正则化（Tikhonov，见原书第 2 章 2.3.2）、迭代精化、混合精度——[习题 D2](exercises.md)；
- **近似解的迭代精化**：原书第 2 章 2.1 节末尾与[第 2 章](../course/ch02/overview.md)习题；
- **$\mathrm{cond}$ 与收敛速度**：[2.5](sec25.md) 的谱半径与[第 2 章](../course/ch02/overview.md)迭代法，$\rho(A)$ 决定迭代快慢，$\mathrm{cond}$ 决定结果好坏——两个数各管一头。
:::
