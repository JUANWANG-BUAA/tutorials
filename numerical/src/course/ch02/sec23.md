# 2.3 条件数与病态线性方程组

消元和分解给出了计算解的方法。现在考虑另一个问题：如果右端项或矩阵中的数据只知道近似值，算出的解会改变多少？

误差的大小不只取决于输入改动了多少，还取决于矩阵本身。有些方程组对微小改动很敏感。条件数用来量化这种敏感性，也帮助我们判断小残差能够说明什么。

先看一个小例子：
$$x_1+x_2=2,\qquad x_1+1.0001x_2=2.0001.$$
它的解是 $(1,1)^{\mathrm T}$。若只把第二个右端改为 $2.0002$，解就变成 $(0,2)^{\mathrm T}$。两条方程的系数接近，消去 $x_1$ 后需要除以很小的数，右端的小变化因此造成了解的明显变化。

下面用范数描述这种现象。本节固定使用同一向量范数及其从属矩阵范数。

<a id="sec-2.3.1"></a>
## 2.3.1 条件数与扰动界

::: def 定义 2.3.1 · 矩阵条件数 {#def-2.3.1}
对非奇异矩阵 $A$，称
$$
\mathrm{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert
$$
为 $A$ 在所选范数下的条件数。常用 $\mathrm{cond}_1,\mathrm{cond}_\infty,\mathrm{cond}_2$；其中
$$
\mathrm{cond}_2(A)=\frac{\sigma_{\max}(A)}{\sigma_{\min}(A)}
=\sqrt{\frac{\lambda_{\max}(A^{\mathrm T}A)}{\lambda_{\min}(A^{\mathrm T}A)}}.
$$
其中 $\sigma_{\max},\sigma_{\min}$ 是最大、最小奇异值；不熟悉奇异值时，可以先通过 $A^{\mathrm T}A$ 的最大、最小特征值计算。
:::

::: method 条件数的五条性质
| # | 性质 | 说明 |
|:--:|:--|:--|
| 1 | $\mathrm{cond}(A)\ge1$ | 由 $1=\lVert I\rVert=\lVert AA^{-1}\rVert\le\lVert A\rVert\lVert A^{-1}\rVert$ |
| 2 | $\mathrm{cond}(kA)=\mathrm{cond}(A)\ (k\ne0)$ | 整体缩放不改变病态程度 |
| 3 | $A$ 非奇异**对称**时 $\mathrm{cond}_2(A)=\left\lvert\dfrac{\lambda_1}{\lambda_n}\right\rvert$ | 按模取极值。**只有正定时**才能不取绝对值 |
| 4 | $A$ **正交**时 $\mathrm{cond}_2(A)=1$ | 正交变换不改变长度，最坏放大倍数就是 1 |
| 5 | $A$ 可逆、$R$ 正交时 $\mathrm{cond}_2(RA)=\mathrm{cond}_2(AR)=\mathrm{cond}_2(A)$ | 左乘或右乘正交阵不改变 2-条件数 |

**第 3 条要注意「先取绝对值」**：只有正定时才能直接写成代数最大、最小特征值之比。例如 $\operatorname{diag}(-10,1)$ 的条件数为 $10$，不是 $\lvert1\rvert/\lvert-10\rvert=0.1$。

**第 5 条的证明**（一行）：$\lVert RA\rVert_2=\lVert A\rVert_2$ 且 $\lVert (RA)^{-1}\rVert_2=\lVert A^{-1}R^{\mathrm T}\rVert_2=\lVert A^{-1}\rVert_2$，因为正交阵的 2-范数为 1、且 $R^{-1}=R^{\mathrm T}$ 也是正交阵；两个因子各自不变，乘积不变。右乘同理（用 $\lVert AR\rVert_2=\lVert A\rVert_2$）。

**第 5 条的作用。**精确的正交变换保持向量的 $2$-范数，因此不会额外改变矩阵的 $2$-条件数。QR、Jacobi 和 Householder 方法利用这一性质组织计算；它们在浮点运算下的稳定性还需要进一步分析各步舍入误差。
:::

::: note 行列式大小与条件数
行列式的绝对大小不能单独判断病态性。$A=10^{-10}I$ 的行列式可以很小，但条件数为 $1$。相反，$A=\begin{pmatrix}1&M\\0&1\end{pmatrix}$ 的行列式恒为 $1$，两个特征值也恒为 $1$，而 $\mathrm{cond}_\infty(A)=(1+|M|)^2$ 可以很大。

主元很小也可能只是方程次序或尺度造成的。判断数据敏感性时，应计算或估计所选范数下的条件数；评价消元过程时，再检查主元、乘数和元素增长。
:::

::: note 算 $\mathrm{cond}_1$、$\mathrm{cond}_\infty$ 的快捷路径
条件数的定义只用范数与逆，手算的瓶颈在范数。第一章已经推得两条公式（推导见 [1.3.4](../../ch01/sec13.md#sec-1.3.4)）：

- $\lVert A\rVert_1=\max_j\sum_i\lvert a_{ij}\rvert$——**最大列和**；
- $\lVert A\rVert_\infty=\max_i\sum_j\lvert a_{ij}\rvert$——**最大行和**。

于是 $\mathrm{cond}_1(A)=\lVert A\rVert_1\lVert A^{-1}\rVert_1$ 就是“$A$ 的最大列和 × $A^{-1}$ 的最大列和”，$\mathrm{cond}_\infty$ 同理换成最大行和——会算两个行和/列和，就会算这两个条件数，不必碰奇异值。
:::

::: thm 定理 2.6 · 扰动界 {#thm-2.6}
设 $A$ 非奇异，$\boldsymbol x$ 是 $A\boldsymbol x=\boldsymbol b$ 的解，$\boldsymbol b\ne0$。若 $\mathrm{cond}(A)\rho_A=\lVert A^{-1}\rVert\lVert\Delta A\rVert\lt1$，则 $A+\Delta A$ 非奇异，且
$$
\frac{\lVert\Delta\boldsymbol x\rVert}{\lVert\boldsymbol x\rVert}
\le
\frac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}
\left(\rho_A+\rho_b\right),
\qquad
\rho_A=\frac{\lVert\Delta A\rVert}{\lVert A\rVert},\quad
\rho_b=\frac{\lVert\Delta\boldsymbol b\rVert}{\lVert\boldsymbol b\rVert}.
$$
:::

::: proof 证明
由 $(A+\Delta A)(\boldsymbol x+\Delta\boldsymbol x)=\boldsymbol b+\Delta\boldsymbol b$ 减去 $A\boldsymbol x=\boldsymbol b$，得
$$
\Delta\boldsymbol x=A^{-1}\Delta\boldsymbol b-A^{-1}\Delta A\,\boldsymbol x-A^{-1}\Delta A\,\Delta\boldsymbol x.
$$
取范数，把最后一项移到左边，用 $\lVert\boldsymbol b\rVert\le\lVert A\rVert\lVert\boldsymbol x\rVert$ 放缩，即得。$\blacksquare$
:::

::: note 读法 · 条件数把「输入扰动」放大成「输出扰动」的上界
条件数大说明某些相对输入扰动可能产生较大的相对解变化，并不表示每个输入都必然达到最坏情况。改进算法可以减少额外的计算误差；若要降低原始数据误差的影响，则需要更准确的数据或重新考虑模型。提高运算精度可以减少舍入，正则化则会改变求解目标，二者不能混为一谈。
:::

::: ex 例 4 · 右端微小扰动引起解的巨大变化 {#ex-2.3-textbook4}
考虑
$$
A=\begin{pmatrix}1&1\\1&1.0001\end{pmatrix}
$$
展示右端微小扰动引起解的巨大变化；其 $\mathrm{cond}_\infty(A)\approx4.0\times10^4$，右端 $0.005\%$ 的扰动可带来约 $50\%$ 的解误差。

条件数验算（编者按定义核算）：$\det A=10^{-4}$，$A^{-1}=10^4\begin{pmatrix}1.0001&-1\\-1&1\end{pmatrix}$；$\lVert A\rVert_\infty=2.0001$、$\lVert A^{-1}\rVert_\infty=2.0001\times10^4$（最大行和），故 $\mathrm{cond}_\infty(A)=(2.0001)^2\times10^4\approx4.0\times10^4$。两行几乎成比例，正是条件数爆表的几何原因。
:::

::: ex 例 5 · 先均衡化，再谈病态 {#ex-2.3-textbook5}
系数矩阵元素数量级悬殊时，先做**行均衡化**（每行除以该行最大元素）再算条件数/求解；否则“病态”可能只是量纲造成的假象。
:::

<a id="sec-2.3.2"></a>
## 2.3.2 病态方程组的处置

::: method 病态方程组的四条处置办法
1. **提高精度**：双精度/多精度能减轻舍入，但不能改变条件数；条件数很大并不意味着方程无解；例如 $A=\operatorname{diag}(1,10^{-20})$、$\boldsymbol b=(1,10^{-20})^{\mathrm T}$ 仍有唯一解 $(1,1)^{\mathrm T}$。是否能算准取决于输入误差、工作精度与算法，不能只按条件数断言“无解”。
2. **行（列）均衡化**：把每行/列缩放到同一量级，降低人为病态。
3. **残差校正（迭代精化）**：用当前解算残差 $\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$，解 $A\Delta\boldsymbol x=\boldsymbol r$，令 $\hat{\boldsymbol x}\leftarrow\hat{\boldsymbol x}+\Delta\boldsymbol x$；在条件数不太大且残差计算足够精确时有效。
4. **换提法**：正则化（Tikhonov）、换基（如插值从范德蒙德基换到拉格朗日基）、增广方程等。
:::

::: method 残差校正的完整八步
| 步 | 动作 |
|:--:|:--|
| 1 | 求解 $A\boldsymbol x=\boldsymbol b$，得到近似解 $\boldsymbol x_1$ |
| 2 | 校正：令 $\boldsymbol r_1=\boldsymbol b-A\boldsymbol x_1$，解 $A\Delta\boldsymbol x_1=\boldsymbol r_1$ |
| 3 | $\boldsymbol x_2=\boldsymbol x_1+\Delta\boldsymbol x_1$ |
| 4 | 令 $\boldsymbol r_2=\boldsymbol b-A\boldsymbol x_2$，解 $A\Delta\boldsymbol x_2=\boldsymbol r_2$ |
| 5 | $\boldsymbol x_3=\boldsymbol x_2+\Delta\boldsymbol x_2$ |
| 6 | …（继续） |
| 7 | 令 $\boldsymbol r_k=\boldsymbol b-A\boldsymbol x_k$，解 $A\Delta\boldsymbol x_k=\boldsymbol r_k$ |
| 8 | $\boldsymbol x_{k+1}=\boldsymbol x_k+\Delta\boldsymbol x_k$，… |

**为什么有效**：若 $A$ 已作 LU 分解，每步只多算一次残差（$O(n^2)$）与两次三角回代（$O(n^2)$），**不重新分解**（$O(n^3)$），代价很低。

**为什么有限**：残差 $\boldsymbol r_k$ 本身要用有限精度算，若 $\mathrm{cond}(A)$ 过大，$\boldsymbol r_k$ 的相对误差已经和 $\Delta\boldsymbol x_k$ 一样大，迭代就不再改善。**它能把误差压到 $\mathrm{cond}(A)\cdot u$ 的量级，压不到 $u$**。

（这正是[补充篇 2.4](../../supplement/sec24.md) 讲的「残差小 ≠ 误差小」的工程用法：我们**故意**用残差作校正量，但每轮都要用高精度算残差。）
:::

<a id="sec-2.3-precond"></a>
## 预条件技术

::: intuition 直觉 · 预条件就是「给方程换一套好算的坐标」
迭代速度取决于矩阵和所用方法。预条件的想法是选择一个便于求解的矩阵 $M$，把方程改写成

$$
M^{-1}A\boldsymbol x=M^{-1}\boldsymbol b .
$$

希望变换后的矩阵更适合所选迭代法。例如对称正定问题中，改善相应条件数可改善共轭梯度法的收敛界。每步还要解一次 $M\boldsymbol y=\boldsymbol c$，因此应比较总求解时间，不能只比较迭代次数。一般非对称问题中，特征值的位置和特征向量之间的关系也会影响收敛。

预条件的目的，是让等价方程组更适合所用的求解算法。预条件矩阵还必须便于求解，否则节省的迭代工作可能被每步的额外计算抵消。
:::

::: def 定义 2.3.2 · 左预条件、右预条件 {#def-2.3.2}
设 $M$ 是 $A$ 的近似且 $M$ 易解（$M\boldsymbol y=\boldsymbol c$ 便宜），称

$$
\underbrace{M^{-1}A\boldsymbol x=M^{-1}\boldsymbol b}_{\text{左预条件}},
\qquad
\underbrace{AM^{-1}\boldsymbol y=\boldsymbol b,\ \boldsymbol x=M^{-1}\boldsymbol y}_{\text{右预条件}} .
$$

**左预条件**改变残差（对上原始残差），**右预条件**保持残差不变但改变未知量。实际求解器一般用**分裂预条件** $M=M_1M_2$（$M_1,M_2$ 各为一侧），兼顾两者。$M=I$ 时退化为原方程。
:::

::: method 预条件的五类
| 类别 | 构造依据 | 典型做法 |
|:--|:--|:--|
| **代数预条件** | 只用 $A$ 的**元素代数信息** | 不完全 LU 分解（ILU）、稀疏近似逆（SPAI）、SSOR、多项式预条件 |
| **几何预条件** | 利用**网格/区域的几何结构** | 定向粗化、网格均匀化、规则区域近似 |
| **分析预条件** | 利用**偏微分方程的解析结构** | 变系数常数化、Green 函数稀疏近似、强化椭圆型算子 |
| **物理预条件** | 按**物理量纲与参数** | 物理量纲平衡、物理参数逼近、状态方程近似、物理项简化与算子分裂 |
| **高级预条件** | 多层级/多区域的现代技术 | 多重网格（MG）、区域分解（DDM）、快速变换（FFT）、基底变换 |

**分类的逻辑**：从「只看矩阵元素」（代数）→「看矩阵从哪来」（几何/分析/物理）→「借更高级的数学结构」（多重网格、区域分解）。这些类别按构造信息划分，没有普遍的效果排名；具体选择取决于问题结构、构造成本和每步开销。
:::

::: note 为什么这一节要放在「病态」里讲
条件数衡量数据扰动对解的影响；迭代速度还要结合具体算法分析。例如 $A=\operatorname{diag}(1,10^6)$ 的 2-条件数为 $10^6$，Jacobi 迭代矩阵却为零，一步即可得到精确解。条件数大不能单独推出迭代慢。

预条件后的残差与原方程残差一般不同。得到近似解后，应回到原方程检查 $\boldsymbol b-A\hat{\boldsymbol x}$。预条件的矩阵形式还可参看[补充篇 2.4](../../supplement/sec24.md)。
:::

**关键区分**：残差小 $\ne$ 误差小。$\boldsymbol e=A^{-1}\boldsymbol r$，所以
$$
\frac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}
\le \mathrm{cond}(A)\frac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}.
$$
条件数大时，残差可以很小而误差仍然很大。停机判据只能保证“残差小”，不能保证“解准”。

::: ex 例 2.3.1 · 同一残差，误差可以相差一万倍 {#ex-2.3.1}

先把误差界里的每个量落到可计算的数上。取

$$A=\begin{pmatrix}1&0\\0&10^{-4}\end{pmatrix},\qquad \boldsymbol b=\begin{pmatrix}1\\10^{-4}\end{pmatrix},\qquad \boldsymbol x^*=\begin{pmatrix}1\\1\end{pmatrix}.$$

在 $\infty$-范数下，$\|A\|_\infty=1$、$\|A^{-1}\|_\infty=10^4$，所以 $\mathrm{cond}_\infty(A)=10^4$。比较两个候选解：

| 候选解 | $\boldsymbol r=\boldsymbol b-A\widetilde{\boldsymbol x}$ | 相对残差 | 相对解误差 |
|:--|:--|:--|:--|
| $(1,0)^{\mathrm T}$ | $(0,10^{-4})^{\mathrm T}$ | $10^{-4}$ | $1$ |
| $(1-10^{-4},1)^{\mathrm T}$ | $(10^{-4},0)^{\mathrm T}$ | $10^{-4}$ | $10^{-4}$ |

两者残差范数相同，但第一个残差落在 $A^{-1}$ 会放大 $10^4$ 倍的第二方向，第二个落在只放大 $1$ 倍的第一方向。条件数控制**最坏方向**，不是说每次误差都会放大这么多。上界对第一个候选解恰取等号，对第二个则很保守。

这也解释了“残差小”能作什么保证：候选解恰好满足 $A\widetilde{\boldsymbol x}=\boldsymbol b-\boldsymbol r$，因此相对残差衡量了只改变右端时的相对向后误差；要把它转为原问题的解误差保证，仍需乘条件数。若目标相对解误差至多 $10^{-3}$，本例用这条界要求相对残差至多 $10^{-7}$。
:::

::: ex 例 2.3.2 · 把“误差大”追到具体方向 {#ex-2.3.2}

仍用上述 $A,\boldsymbol b$。只把右端改为 $\boldsymbol b+\delta\boldsymbol b$，分别取 $\delta\boldsymbol b=(10^{-6},0)^{\mathrm T}$ 与 $(0,10^{-6})^{\mathrm T}$。求两个新解的相对变化。若想仅靠相对残差保证解的相对误差至多 $10^{-2}$，阈值应设为多少？
:::

::: sol 核对与回查

由 $\delta\boldsymbol x=A^{-1}\delta\boldsymbol b$ 得变化分别为 $(10^{-6},0)^{\mathrm T}$ 与 $(0,10^{-2})^{\mathrm T}$；因 $\|\boldsymbol x^*\|_\infty=1$，相对变化为 $10^{-6}$ 与 $10^{-2}$。残差阈值为 $10^{-2}/10^4=10^{-6}$，这是充分条件，并非必要条件。若不会算矩阵范数，先回到 [1.3 的矩阵范数](../../ch01/sec13.md)；若量都算对却仍混淆两种误差，回看本节 $\boldsymbol e=A^{-1}\boldsymbol r$ 的方向。能解释阈值为何只是保证后，再读 [2.4 迭代法](sec24.md)，把它用于停止准则。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| 条件数 | $\lVert A\rVert\lVert A^{-1}\rVert\ge1$，把输入相对扰动放大成输出相对扰动的上界 | [@def-2.3.1] | [1.2.6](../../ch01/sec12.md#sec-1.2.6) 函数版条件数；[1.3.6](../../ch01/sec13.md#sec-1.3.6) 矩阵版推导 |
| $\mathrm{cond}_2$ | $\sigma_{\max}/\sigma_{\min}$；SPD 时才等于 $\max\lvert\lambda_i\rvert/\min\lvert\lambda_i\rvert$ | [@def-2.3.1] | [补充篇 2.4](../../supplement/sec24.md) Skeel 与成分条件数 |
| 扰动界 | $\dfrac{\lVert\Delta\boldsymbol x\rVert}{\lVert\boldsymbol x\rVert}\le\dfrac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}(\rho_A+\rho_b)$ | [@thm-2.6] | [2.4.1](sec24.md#sec-2.4.1) 迭代法停机判据的误差语言 |
| 残差 $\ne$ 误差 | $\boldsymbol e=A^{-1}\boldsymbol r$，$\dfrac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}$ | [2.3.2](#sec-2.3.2) | [例 2.3.1](#ex-2.3.1) 同残差误差差一万倍 |
| 行均衡化 | 每行除以行内最大元，拆穿量纲造成的假病态 | [例 5](#ex-2.3-textbook5) | [补充篇 2.4](../../supplement/sec24.md) 行缩放反例 |
:::

::: think 本节常见错误
1. **把条件数当特征值之比。**只有实对称（一般地，正规）矩阵才有 $\mathrm{cond}_2=\max\lvert\lambda_i\rvert/\min\lvert\lambda_i\rvert$；一般矩阵必须先取绝对值再取极值——$\operatorname{diag}(-10,1)$ 的条件数是 $10$，不是 $0.1$。
2. **残差小就当误差小。**$\boldsymbol e=A^{-1}\boldsymbol r$，条件数大时两者可以差几个数量级（[例 2.3.1](#ex-2.3.1)）。
3. **条件数大就断言“无解”。**$\operatorname{diag}(1,10^{-20})$ 的条件数 $10^{20}$，仍有唯一解 $(1,1)^{\mathrm T}$；能否算准取决于输入误差、工作精度与算法。
4. **量纲悬殊不均衡化就判病态。**先做行（列）均衡化再算条件数（[例 5](#ex-2.3-textbook5)），否则治的是假象。
5. **以为换算法能治百态。**病态是问题的属性：$\mathrm{cond}$ 不变，稳定算法也只能把误差控制在 $\mathrm{cond}\times u$ 量级。
:::

<a id="sec-2.3-exercises"></a>
## 习题

::: ex 2.9 · 条件数与右端扰动 {#exercise-2.9}
设
$$A=\begin{pmatrix}1&1\\1&1.0001\end{pmatrix},\qquad\boldsymbol b=(2,2.0001)^{\mathrm T}.$$
计算 $\mathrm{cond}_\infty(A)$。将第二个右端分量增加 $10^{-4}$，比较新旧精确解及相对变化。解释选主元能否消除这种敏感性。
:::

::: sol 参考答案
$A^{-1}=\begin{pmatrix}10001&-10000\\-10000&10000\end{pmatrix}$，所以
$$\mathrm{cond}_\infty(A)=2.0001\times20001=40004.0001.$$
原解为 $(1,1)^{\mathrm T}$，扰动后的解为 $(0,2)^{\mathrm T}$。右端的相对变化为 $10^{-4}/2.0001$，约 $5.0\times10^{-5}$；解的相对变化却为 $1$。这是方程组本身对数据敏感，选主元只能减少求解过程额外引入的误差。
:::

::: ex 2.10 · 正交矩阵的条件数 {#exercise-2.10}
设 $A$ 是正交矩阵，证明 $\mathrm{cond}_2(A)=1$。
:::

::: sol 参考答案
正交矩阵满足 $A^{\mathrm T}A=I$，故 $\sigma_i(A)=1$，于是 $\mathrm{cond}_2(A)=\sigma_{\max}/\sigma_{\min}=1$。几何上，正交变换不改变长度，最坏放大倍数就是 1。
:::

::: ex 2.11 · 残差与误差界 {#exercise-2.11}
设 $A$ 非奇异、$\boldsymbol b\ne0$，$\tilde{\boldsymbol x}$ 是 $A\boldsymbol x=\boldsymbol b$ 的近似解，$\boldsymbol r=\boldsymbol b-A\tilde{\boldsymbol x}$。证明
$$
\frac{\lVert\boldsymbol x^{*}-\tilde{\boldsymbol x}\rVert}{\lVert\boldsymbol x^{*}\rVert}
\le \mathrm{cond}(A)\frac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}.
$$
:::

::: sol 参考答案
$\boldsymbol x^{*}-\tilde{\boldsymbol x}=A^{-1}\boldsymbol r$，取范数得 $\lVert\boldsymbol x^{*}-\tilde{\boldsymbol x}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol r\rVert$；又 $\lVert\boldsymbol b\rVert\le\lVert A\rVert\lVert\boldsymbol x^{*}\rVert$，相除即得。
:::

::: ex 2.12 · 条件数与残差反例 {#exercise-2.12}
使用第 2.9 题的 $A,\boldsymbol b$，比较 $\hat{\boldsymbol x}=(0,2)^{\mathrm T}$ 与 $\tilde{\boldsymbol x}=(1.0001,1)^{\mathrm T}$ 的无穷范数残差和误差。
:::

::: sol 参考答案
真解为 $(1,1)^{\mathrm T}$。两个残差分别为 $(0,-10^{-4})^{\mathrm T}$、$(-10^{-4},-10^{-4})^{\mathrm T}$，无穷范数都为 $10^{-4}$；两个解误差的无穷范数却分别为 $1$ 与 $10^{-4}$。因此，在病态问题中，相同大小的残差可以对应差异很大的解误差。
:::
