# 2.4.1 迭代法引论

直接法通过消元或分解求解方程组。还可以从一个近似解出发，用它计算下一个近似解，反复进行。这就是迭代法。

本节先把方程组改写成便于更新的形式，再分析近似解是否趋于真解。即使相邻两步已经很接近，也还要有误差估计，才能判断是否达到所需精度。

## 引导算例：相邻两步很接近，可以停了吗？

先看最小的反例：$x_{k+1}=0.99x_k+0.01$，$x_0=0$，不动点为 $1$。第一步只移动 $0.01$，但到真解仍差 $0.99$。**移动小只说明这一步走得小，是否接近终点还取决于收缩速度。**

把这个问题搬到方程组：

$$
A=\begin{pmatrix}4&-1\\-1&3\end{pmatrix},\qquad
b=\begin{pmatrix}3\\2\end{pmatrix},\qquad
x^{(0)}=\begin{pmatrix}0\\0\end{pmatrix}.
$$

逐行把对角项留在左边，得到 Jacobi 迭代

$$
x_1^{(k+1)}=\frac{3+x_2^{(k)}}4,\qquad
x_2^{(k+1)}=\frac{2+x_1^{(k)}}3.
$$

两行都用旧值，故 $x^{(1)}=(3/4,2/3)^{\mathrm T}$，
$x^{(2)}=(11/12,11/12)^{\mathrm T}$。代回原方程，真解是 $(1,1)^{\mathrm T}$；第二步的无穷范数误差为 $1/12$。

**怎样在不知道真解时估计这个误差？** 迭代矩阵的最大绝对行和是 $q=1/3$。记相邻差为 $d_k=x^{(k)}-x^{(k-1)}$，则 $\|d_{k+j}\|_\infty\le q^j\|d_k\|_\infty$。把以后所有移动相加：

$$
\|x^*-x^{(k)}\|_\infty
\le\sum_{j=1}^{\infty}q^j\|d_k\|_\infty
=\frac{q}{1-q}\|d_k\|_\infty.
$$

第二步 $\|d_2\|_\infty=1/4$，故可保证误差不超过 $1/8$；实际 $1/12$ 确实在界内。这里的 $1/8$ 是保证，不是对实际误差的精确预测。

::: ex 补关键一步，再迁移
遮住上面的求和式，独立说明为何第一项是 $q\|d_k\|$ 而非 $\|d_k\|$。再对标量反例求 $q/(1-q)$，判断“相邻差小于 $10^{-4}$”能保证多大的误差。
:::

::: sol 参考解答
从当前 $x^{(k)}$ 到真解，尚未发生的第一步是 $d_{k+1}$，因此多一个 $q$。标量例的常数为 $99$，相邻差小于 $10^{-4}$ 只给出误差小于 $0.0099$ 的保证。若某个所选范数给出 $\|G\|\ge1$，不能使用此几何级数界，也不能据此断言发散；须另查谱半径或寻找其他估计。
:::

下面用统一的矩阵分裂推导这一过程，并分开回答“迭代收敛吗”与“达到精度了吗”。

<a id="sec-2.4.1"></a>
## 2.4.1 分裂与迭代格式

::: def 定义 2.4.1 · 矩阵分裂与迭代格式 {#def-2.4.1}
设 $A$ 非奇异，且 $A=N-P$，其中 $N$ 可逆（“好求逆”的矩阵：对角阵、三角阵等）。原方程等价于
$$
N\boldsymbol x=P\boldsymbol x+\boldsymbol b
\quad\Longrightarrow\quad
\boldsymbol x=N^{-1}P\boldsymbol x+N^{-1}\boldsymbol b.
$$
于是迭代格式
$$
\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d,
\qquad G=N^{-1}P,\quad \boldsymbol d=N^{-1}\boldsymbol b.
$$
:::

实际计算**不显式求 $N^{-1}$**，而是每步解 $N\boldsymbol x^{(k+1)}=P\boldsymbol x^{(k)}+\boldsymbol b$——只要 $N$ 取得“好解”即可。

::: note 公式中的逆与实际求解
迭代公式里的 $N^{-1}$ 用来表示“解以 $N$ 为系数矩阵的方程组”，实现时通常不需要形成逆矩阵。若迭代收敛到 $\boldsymbol x^*$，对递推式取极限，便有 $\boldsymbol x^*=G\boldsymbol x^*+\boldsymbol d$，也就是 $(I-G)\boldsymbol x^*=\boldsymbol d$。
:::

**误差方程**：令 $\boldsymbol e_k=\boldsymbol x^{(k)}-\boldsymbol x^*$，则
$$
\boldsymbol e_{k+1}=G\boldsymbol e_k
\quad\Longrightarrow\quad
\boldsymbol e_k=G^k\boldsymbol e_0.
$$
所以迭代收敛 $\iff$ 对任意初值 $G^k\boldsymbol e_0\to0$ $\iff$ $G$ 的谱半径 $\rho(G)\lt1$。

::: note 选法的艺术
核心是选好分裂 $A=N-P$，让迭代矩阵 $G$ 满足 $\lVert G\rVert\lt1$ 且收敛快——“**找到一个矩阵范数使 $\lVert G\rVert\lt1$**”是收敛判定的钥匙。[2.4.2–2.4.4](sec24b.md) 的 Jacobi、Gauss–Seidel、SOR，就是三种不同的拆法。
:::

<a id="sec-2.4-theorems"></a>
## 三个基本定理

::: thm 定理 2.7 · 范数收敛与分量收敛 {#thm-2.7}
若对某种范数 $\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\to0$，则按分量也有 $\boldsymbol x^{(k)}\to\boldsymbol x^*$。这是有限维范数等价性的直接推论，用来把“范数收敛”与“分量收敛”互换。
:::

::: thm 定理 2.8 · 收敛的充要条件 {#thm-2.8}
对任意初值 $\boldsymbol x^{(0)}$，迭代格式收敛的充要条件是
$$
\rho(G)\lt1.
$$
:::

::: proof 证明

先讨论 $G$ 可对角化的情形。取可逆矩阵 $T$ 使
$$G=T^{-1}\Lambda T,\qquad\Lambda=\operatorname{diag}(\lambda_1,\ldots,\lambda_n).$$
对原迭代式左乘 $T$，令 $\boldsymbol y^{(k)}=T\boldsymbol x^{(k)}$、$\tilde{\boldsymbol d}=T\boldsymbol d$，才得到下面的解耦系统；复特征值时可在复数空间完成变换。若 $G$ 不可对角化，不能硬套这一步，须用本证明末尾的 Jordan 块论证。

$$
\boldsymbol y^{(k+1)}=\Lambda \boldsymbol y^{(k)}+\tilde{\boldsymbol d}
\qquad\Longleftrightarrow\qquad
y_i^{(k+1)}=\lambda_i\,y_i^{(k)}+\tilde d_i,\quad i=1,\dots,n .
$$

由于 $T$ 可逆，原向量序列收敛当且仅当变换后的序列收敛。对角化后，每个分量都满足形如 $z_{k+1}=\lambda z_k+E$ 的标量递推。反复代入可得：

$$
z_{k+1}=\lambda z_k+E=\lambda^2z_{k-1}+(\lambda+1)E=\cdots
=\lambda^{k+1}z_0+(\lambda^{k}+\cdots+1)\,E
=\lambda^{k+1}z_0+\frac{1-\lambda^{k+1}}{1-\lambda}\,E .
$$

（$\lambda=1$ 时右端为 $z_0+(k+1)E$：$E\ne0$ 时发散；$E=0$ 时虽为常数，却依赖初值，不能使任意初值都趋于同一个方程解。）当且仅当 $|\lambda|\lt1$ 时 $\lambda^{k+1}\to0$，极限为 $E/(1-\lambda)$，**与初值 $z_0$ 无关**——逐分量收敛，故 $\boldsymbol x^{(k)}$ 收敛。若 $G$ 不可对角化，用 Jordan 标准形：Jordan 块 $J=\lambda I+N$ 的 $k$ 次幂含 $\binom{k}{s}\lambda^{k-s}$，当 $|\lambda|\lt1$ 时仍趋于 0；反之若某个 $|\lambda|\ge1$，取对应特征向量作初值误差，$\boldsymbol e_k$ 不趋于 0。$\blacksquare$
:::

::: note 不可对角化时怎么办
上面的证明假设 $G$ 可以对角化，以便把向量递推化成若干个标量递推。若 $G$ 不可对角化，可以改用 Jordan 形：各块的幂包含 $k^m\lambda^k$ 一类项。只要 $|\lambda|<1$，指数衰减仍快于多项式增长，所以结论不变。
:::

::: note 现实困难
实际要求解的方程组，规模“成百上千万、甚至上亿”，而把 $G$ 的特征根全部算出来比高斯消去还贵——充要条件**没法直接用**，于是需要一条可操作的充分条件（定理 2.9）。
:::

::: thm 定理 2.9 · 充分条件与误差估计 {#thm-2.9}
若存在某种矩阵范数使 $\lVert G\rVert\lt1$，则

1. 方程组 $(I-G)\boldsymbol x=\boldsymbol d$ 的解存在且唯一；
2. 对任意初值，迭代收敛；
3. 有先验估计
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert
\le \frac{\lVert G\rVert^k}{1-\lVert G\rVert}\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert,
$$
和后验估计
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert
\le \frac{\lVert G\rVert}{1-\lVert G\rVert}\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert.
$$
:::

::: proof[core] 证明
**(1) 存在唯一。**$\lVert G\rVert\lt1$ $\Rightarrow$ $I-G$ 可逆（[1.3.5](../../ch01/sec13.md#sec-1.3.5) 的可逆性判据取 $B=-G$；等价地，Neumann 级数 $\sum_{j\ge0}G^j$ 收敛且 $(I-G)^{-1}=\sum_{j\ge0}G^j$）。由 $(I-G)\boldsymbol x=\boldsymbol d$ 知解存在唯一。因此，不动点就是原线性方程组的唯一解。

**(2) 收敛与先验估计（误差递推）。**不动点方程与迭代式相减，常向量 $\boldsymbol d$ 被消去：$\boldsymbol x^{(k+1)}-\boldsymbol x^{*}=G(\boldsymbol x^{(k)}-\boldsymbol x^{*})$。取与该矩阵范数**相容**的向量范数（$\lVert A\boldsymbol x\rVert\le\lVert A\rVert\lVert\boldsymbol x\rVert$；任一矩阵范数都存在与之相容的向量范数），逐次递推：

$$
\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{*}\rVert\le\lVert G\rVert\,\lVert\boldsymbol x^{(k)}-\boldsymbol x^{*}\rVert\le\cdots\le\lVert G\rVert^{k+1}\,\lVert\boldsymbol x^{(0)}-\boldsymbol x^{*}\rVert\xrightarrow{\ k\to\infty\ }0 .
$$

裂项 $\boldsymbol x^{(k)}-\boldsymbol x^{*}=\sum_{j=k}^{\infty}(\boldsymbol x^{(j)}-\boldsymbol x^{(j+1)})$，而相邻差满足 $\boldsymbol x^{(j)}-\boldsymbol x^{(j+1)}=G^{j}(\boldsymbol x^{(0)}-\boldsymbol x^{(1)})$，取范数并用几何级数 $\sum_{j\ge k}\lVert G\rVert^j=\lVert G\rVert^k/(1-\lVert G\rVert)$ 即得先验估计。

**(3) 后验估计：由相邻两步的差估计误差。**

1. **裂项**：对 $m\gt k$，$\boldsymbol x^{(m)}-\boldsymbol x^{(k)}=(\boldsymbol x^{(m)}-\boldsymbol x^{(m-1)})+\cdots+(\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)})$；
2. **相邻差被 $G$ 压缩**：相邻两个迭代式相减（$\boldsymbol d$ 消去）得 $\boldsymbol x^{(m)}-\boldsymbol x^{(m-1)}=G^{\,m-k-1}(\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)})$；
3. **次乘性 + 三角不等式 + 几何级数**：$\lVert\boldsymbol x^{(m)}-\boldsymbol x^{(k)}\rVert\le\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)}\rVert\cdot\dfrac{1-\lVert G\rVert^{\,m-k}}{1-\lVert G\rVert}$；
4. **令 $m\to\infty$**（$\boldsymbol x^{(m)}\to\boldsymbol x^*$，$\lVert G\rVert^{m-k}\to0$），再用一次相邻差压缩 $\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)}\rVert\le\lVert G\rVert\,\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert$，得后验估计。$\blacksquare$
:::

::: method 「下标 + 幂次 = 常数」规律
递推误差估计时，盯着这个规律推：$\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^*\rVert\le\lVert G\rVert\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert$ 一路放缩下去，**下标与 $\lVert G\rVert$ 的幂次之和恒为 $k+1$**——先验估计全靠它；后验估计则全靠裂项加几何级数。
:::

::: note 停机判据的术语辨析
相邻迭代差与残差是两个不同的量。前者是 $\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert$；后者是 $\boldsymbol r^{(k)}=\boldsymbol b-A\boldsymbol x^{(k)}$。相邻差要结合本节的后验界使用；残差与解误差的关系则见 [2.3](sec23.md#sec-2.3.2)。
:::

::: note 使用误差界的两个前提
$\lVert G\rVert$ 很接近 1 时，相邻差小**不能**断定接近真解（后验估计的常数 $\lVert G\rVert/(1-\lVert G\rVert)$ 会爆）；$I-G$ 病态时迭代再多也未必得到好结果。
:::

::: method 两条判据的分工
- $\rho(G)\lt1$ 是**充要**条件，但大规模问题算不出特征值；
- $\lVert G\rVert\lt1$ 是**充分**条件，容易手算（$\lVert G\rVert_1$、$\lVert G\rVert_\infty$）；
- $\rho(G)\le\lVert G\rVert$，所以范数判据更保守；$\lVert G\rVert\ge1$ 时迭代仍可能收敛。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| 矩阵分裂 | $A=N-P$，$N$ 取好求逆的矩阵 | [@def-2.4.1] | [2.4.2](sec24b.md#sec-2.4.2) Jacobi/GS/SOR 都是它的特例 |
| 迭代矩阵 | $G=N^{-1}P$；误差 $\boldsymbol e_k=G^k\boldsymbol e_0$ | [@def-2.4.1] | [2.4.4](sec24b.md#sec-2.4.4) SOR 的 $G_S$ 与 $\omega$ |
| 充要条件 | $\rho(G)\lt1$（对任意初值收敛） | [@thm-2.8] | [2.4.4](sec24b.md#sec-2.4.4) 逐条核 $\rho(G_S)$ |
| 充分条件 | 存在范数 $\lVert G\rVert\lt1$ $\Rightarrow$ 收敛 | [@thm-2.9] | [1.3.5](../../ch01/sec13.md#sec-1.3.5) 可逆性判据 |
| 先验估计 | $\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\frac{\lVert G\rVert^k}{1-\lVert G\rVert}\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert$ | [@thm-2.9] | — |
| 后验估计 | $\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\frac{\lVert G\rVert}{1-\lVert G\rVert}\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert$ | [@thm-2.9] | 停机判据；配合 [2.3](sec23.md#sec-2.3.2) 残差 $\ne$ 误差 |
:::

::: think 本节常见错误
1. **把范数判据当充要条件。**$\rho(G)\le\lVert G\rVert$，范数判据是**充分不必要**的：$\lVert G\rVert\ge1$ 时迭代仍可能收敛（习题 2.14 正是这种情形）。
2. **停机只盯相邻差，不看 $\lVert G\rVert$。**$\lVert G\rVert$ 很接近 1 时，后验估计的常数 $\lVert G\rVert/(1-\lVert G\rVert)$ 爆表，“差小”推不出“解准”。
3. **把相邻迭代差叫“残差”。**残差的标准定义是 $\boldsymbol r^{(k)}=\boldsymbol b-A\boldsymbol x^{(k)}$；停机用的相邻差只是它的便宜替身。
4. **大规模问题想先算 $\rho(G)$。**算 $G$ 的全部特征根比高斯消去还贵——实际用范数判据或结构判据（对角占优、对称正定，见 [2.4.2–2.4.4](sec24b.md)）。
5. **每步显式构造 $N^{-1}$。**实际每步解的是 $N\boldsymbol x^{(k+1)}=P\boldsymbol x^{(k)}+\boldsymbol b$；$N$ 取得“好解”（对角/三角）即可。
:::

<a id="sec-2.4-exercises"></a>
## 习题

::: ex 2.13 · 迭代序列收敛判断 {#exercise-2.13}
对迭代 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+(1,1)^{\mathrm T}$，分别取
$$G_1=\operatorname{diag}(1/2,1/3),\qquad G_2=\operatorname{diag}(1,1/2),\qquad G_3=\operatorname{diag}(-1,1/2).$$
判断是否对任意初值收敛到同一个不动点，并说明可能出现的特殊初值。
:::

::: sol 参考答案
$G_1$ 的谱半径为 $1/2$，对任意初值收敛到 $(2,3/2)^{\mathrm T}$。$G_2$ 的第一分量每步增加 $1$，不收敛。$G_3$ 的第一分量满足 $x_1^{(k+1)}=1-x_1^{(k)}$，通常在两个值间交替；只有初始第一分量为 $1/2$ 时，这个分量保持不变，此时向量收敛到 $(1/2,2)^{\mathrm T}$。
:::

::: ex 2.14 · 必收敛的迭代 {#exercise-2.14}
设
$$G=\begin{pmatrix}0.2&1.2\\0.1&0.2\end{pmatrix},\qquad\boldsymbol d=(1,0)^{\mathrm T}.$$
证明 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$ 对任意初值收敛，求其极限，并说明为何 $\lVert G\rVert_\infty$ 不能直接给出收敛保证。
:::

::: sol 参考答案
两个特征值为 $0.2\pm\sqrt{0.12}$，所以 $\rho(G)\approx0.546410<1$。但 $\lVert G\rVert_\infty=1.4>1$，这个范数条件没有通过，不能据此判断发散。极限满足 $(I-G)\boldsymbol x^*=\boldsymbol d$，解得 $\boldsymbol x^*=(20/13,5/26)^{\mathrm T}$。
:::
