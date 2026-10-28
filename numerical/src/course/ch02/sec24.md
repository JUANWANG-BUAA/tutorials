# 2.4.1 迭代法引论

> 对应教材 2.4.1、定理 2.7–2.9、习题 13–14；对应老师第 4 讲 §五、第 5 讲 §一–§三。
> 主线：把 $A\boldsymbol x=\boldsymbol b$ 拆成 $A=N-P$，得到 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$；收敛性只看 $G$ 的谱半径。

::: note 为什么走迭代（老师第 4 讲 §五）
矩阵**求逆困难**，矩阵**相乘**却容易（可并行、可分块，MATLAB 内置优化）——迭代法每一步只做“矩阵 × 向量”这样的便宜操作。主流的大规模求解器是 **Krylov 子空间方法**（GMRES）；本节的分裂迭代是理解这一切的入口，也是 [2.4.2–2.4.4](sec24b.md) 三个经典格式的共同底座。
:::

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

::: note 板书把 $A^{-1}$ 划掉了（老师第 5 讲 §一）
第 5 讲重推这段时刻意不走直接求逆：板书上 $A^{-1}$ 被整段划掉，只保留“乘”与“解三角/对角方程组”。若极限存在，对迭代式取极限即得不动点方程 $\boldsymbol x^{*}=G\boldsymbol x^{*}+\boldsymbol d$——它正对应原方程组 $(I-G)\boldsymbol x=\boldsymbol d$。
:::

**误差方程**：令 $\boldsymbol e_k=\boldsymbol x^{(k)}-\boldsymbol x^*$，则
$$
\boldsymbol e_{k+1}=G\boldsymbol e_k
\quad\Longrightarrow\quad
\boldsymbol e_k=G^k\boldsymbol e_0.
$$
所以迭代收敛 $\iff$ 对任意初值 $G^k\boldsymbol e_0\to0$ $\iff$ $G$ 的谱半径 $\rho(G)\lt1$。

::: note 选法的艺术（老师第 4 讲 §五）
核心是选好分裂 $A=N-P$，让迭代矩阵 $G$ 满足 $\lVert G\rVert\lt1$ 且收敛快——“**找到一个矩阵范数使 $\lVert G\rVert\lt1$**”是收敛判定的钥匙。[2.4.2–2.4.4](sec24b.md) 的 Jacobi、Gauss–Seidel、SOR，就是三种不同的拆法。
:::

<a id="sec-2.4-theorems"></a>
## 三个基本定理（教材 2.4.1 续）

::: thm 定理 2.7 · 范数收敛与分量收敛 {#thm-2.7}
若对某种范数 $\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\to0$，则按分量也有 $\boldsymbol x^{(k)}\to\boldsymbol x^*$。这是有限维范数等价性的直接推论，用来把“范数收敛”与“分量收敛”互换。
:::

::: thm 定理 2.8 · 收敛的充要条件 {#thm-2.8}
对任意初值 $\boldsymbol x^{(0)}$，迭代格式收敛的充要条件是
$$
\rho(G)\lt1.
$$
:::

::: proof 证明（老师第 5 讲 §二的对角化解耦，板书完整）

$$
\boldsymbol y^{(k+1)}=\Lambda \boldsymbol y^{(k)}+\tilde{\boldsymbol d}
\qquad\Longleftrightarrow\qquad
y_i^{(k+1)}=\lambda_i\,y_i^{(k)}+\tilde d_i,\quad i=1,\dots,n .
$$

$T$ 可逆，新旧两个系统“要么一块收敛、要么一块发散”，故只需研究其中一条标量递推 $z_{k+1}=\lambda z_k+E$。把它反复代入（板书有完整演算）：

$$
z_{k+1}=\lambda z_k+E=\lambda^2z_{k-1}+(\lambda+1)E=\cdots
=\lambda^{k+1}z_0+(\lambda^{k}+\cdots+1)\,E
=\lambda^{k+1}z_0+\frac{1-\lambda^{k+1}}{1-\lambda}\,E .
$$

（$\lambda=1$ 时右端退化为 $z_0+(k+1)E$，显然发散。）当且仅当 $|\lambda|\lt1$ 时 $\lambda^{k+1}\to0$，极限为 $E/(1-\lambda)$，**与初值 $z_0$ 无关**——逐分量收敛，故 $\boldsymbol x^{(k)}$ 收敛。若 $G$ 不可对角化，用 Jordan 标准形：Jordan 块 $J=\lambda I+N$ 的 $k$ 次幂含 $\binom{k}{s}\lambda^{k-s}$，当 $|\lambda|\lt1$ 时仍趋于 0；反之若某个 $|\lambda|\ge1$，取对应特征向量作初值误差，$\boldsymbol e_k$ 不趋于 0。$\blacksquare$
:::

::: note 课堂推导的价值（老师第 5 讲 §二）
原书对定理 2.8 的态度是“证明从略，读者可参阅文献”；本讲用对角化 + 标量递推把证明完整走了一遍——这正是本节收录这段推导的原因。$G$ 不可对角化时改用 Jordan 形，每块多出 $k$ 的多项式因子（$k^m\lambda^k$ 型），$|\lambda|\lt1$ 时仍趋零，**结论不变、计算变繁**（老师明确交代，未展开）。
:::

::: note 现实困难（老师第 5 讲 §二）
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

::: proof 证明
**(1) 存在唯一。**$\lVert G\rVert\lt1$ $\Rightarrow$ $I-G$ 可逆（[1.3.5](../../ch01/sec13.md#sec-1.3.5) 的可逆性判据取 $B=-G$；等价地，Neumann 级数 $\sum_{j\ge0}G^j$ 收敛且 $(I-G)^{-1}=\sum_{j\ge0}G^j$）。由 $(I-G)\boldsymbol x=\boldsymbol d$ 知解存在唯一。这一半在[第 4 讲](../../lectures/lec04.md)已完成。

**(2) 收敛与先验估计（误差递推）。**不动点方程与迭代式相减，常向量 $\boldsymbol d$ 被消去：$\boldsymbol x^{(k+1)}-\boldsymbol x^{*}=G(\boldsymbol x^{(k)}-\boldsymbol x^{*})$。取与该矩阵范数**相容**的向量范数（$\lVert A\boldsymbol x\rVert\le\lVert A\rVert\lVert\boldsymbol x\rVert$；任一矩阵范数都存在与之相容的向量范数），逐次递推：

$$
\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{*}\rVert\le\lVert G\rVert\,\lVert\boldsymbol x^{(k)}-\boldsymbol x^{*}\rVert\le\cdots\le\lVert G\rVert^{k+1}\,\lVert\boldsymbol x^{(0)}-\boldsymbol x^{*}\rVert\xrightarrow{\ k\to\infty\ }0 .
$$

裂项 $\boldsymbol x^{(k)}-\boldsymbol x^{*}=\sum_{j=k}^{\infty}(\boldsymbol x^{(j)}-\boldsymbol x^{(j+1)})$，而相邻差满足 $\boldsymbol x^{(j)}-\boldsymbol x^{(j+1)}=G^{j}(\boldsymbol x^{(0)}-\boldsymbol x^{(1)})$，取范数并用几何级数 $\sum_{j\ge k}\lVert G\rVert^j=\lVert G\rVert^k/(1-\lVert G\rVert)$ 即得先验估计。

**(3) 后验估计（“差小即停”的道理，老师第 5 讲 §三分四步板书）。**

1. **裂项**：对 $m\gt k$，$\boldsymbol x^{(m)}-\boldsymbol x^{(k)}=(\boldsymbol x^{(m)}-\boldsymbol x^{(m-1)})+\cdots+(\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)})$；
2. **相邻差被 $G$ 压缩**：相邻两个迭代式相减（$\boldsymbol d$ 消去）得 $\boldsymbol x^{(m)}-\boldsymbol x^{(m-1)}=G^{\,m-k-1}(\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)})$；
3. **次乘性 + 三角不等式 + 几何级数**：$\lVert\boldsymbol x^{(m)}-\boldsymbol x^{(k)}\rVert\le\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)}\rVert\cdot\dfrac{1-\lVert G\rVert^{\,m-k}}{1-\lVert G\rVert}$；
4. **令 $m\to\infty$**（$\boldsymbol x^{(m)}\to\boldsymbol x^*$，$\lVert G\rVert^{m-k}\to0$），再用一次相邻差压缩 $\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)}\rVert\le\lVert G\rVert\,\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert$，得后验估计。$\blacksquare$
:::

::: method 「下标 + 幂次 = 常数」规律（老师第 5 讲 §三，三次强调）
递推误差估计时，盯着这个规律推：$\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^*\rVert\le\lVert G\rVert\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert$ 一路放缩下去，**下标与 $\lVert G\rVert$ 的幂次之和恒为 $k+1$**——先验估计全靠它；后验估计则全靠裂项加几何级数。
:::

::: note 停机判据的术语辨析（老师第 5 讲 §六）
课堂上把停机用的**相邻迭代差** $\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert$ 口称为“残差”；标准术语里**残差**指 $\boldsymbol r^{(k)}=\boldsymbol b-A\boldsymbol x^{(k)}$，两者不是一回事（残差与误差的关系见 [2.3](sec23.md#sec-2.3.2)）。读题时先问一句：题目说的“残差”是哪一个。
:::

::: note 两条使用警告（原书 §2.4.1，课上未提、摘录备用）
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
## 习题（教材习题 13–14）

::: ex 2.13 · 迭代序列收敛判断（教材习题 13）
对教材习题 13 的三个迭代公式，判断其产生的向量序列是否收敛（初值任取）。
:::

::: sol 参考答案
写出各自的迭代矩阵 $G$，算 $\rho(G)$：$\rho(G)\lt1$ 则对任意初值收敛；$\rho(G)\ge1$ 则不保证（若 $=1$，须区分“收敛到指定解”与“序列本身有极限”：$G=I$ 的误差保持常数，序列可收敛却不到指定解；$G=-I$ 的非零误差则振荡）。不要只看某个范数 $\ge1$ 就判发散——范数只是充分条件。
:::

::: ex 2.14 · 必收敛的迭代（教材习题 14）
证明教材习题 14 的迭代公式产生的序列必收敛，并指出它收敛到哪个线性方程组的解。
:::

::: sol 参考答案
把迭代写成 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$，先算 $\rho(G)$；本题已算得 $\rho(G)\approx0.6236\lt1$，由 [@thm-2.8] 得对任意初值收敛。这里 $\lVert G\rVert_\infty=1.55\gt1$，不能声称用这个范数通过 [@thm-2.9]；极限满足 $\boldsymbol x^*=G\boldsymbol x^*+\boldsymbol d$，即 $(I-G)\boldsymbol x^*=\boldsymbol d$，对应方程组 $(I-G)\boldsymbol x=\boldsymbol d$。
:::

::: note 覆盖核对
本节覆盖教材 2.4.1、定理 2.7–2.9、习题 13–14；老师第 4 讲 §五（动机、选法艺术、唯一性半场证明）与第 5 讲 §一–§三（对角化解耦自证充要条件、先验/后验估计、“下标+幂次”规律、残差术语辨析、两条使用警告）。下一节：[2.4.2–2.4.4 Jacobi、Gauss–Seidel 与 SOR](sec24b.md)。
:::
