# 闭卷回忆卡 · 第 5 章：插值与逼近

## A. 定义卡

**A1.** 什么是代数插值？插值多项式的存在唯一性怎么证？
::: sol
代数插值：求次数 $\le n$ 的多项式 $p$，使 $p(x_i)=f(x_i)$（$i=0,\dots,n$）。
**存在唯一性**：存在性用 Lagrange 构造 $p=\sum f(x_i)l_i(x)$，由 $l_i(x_j)=\delta_{ij}$ 直接满足插值条件；唯一性用「两个解之差的次数不超过 $n$，却有 $n+1$ 个互异零点，只能为零」。从矩阵看，范德蒙德行列式在节点互异时非零；换用其他基，则检查基函数在这些节点上的取值矩阵是否非奇异。（✓ / △ / ×）
:::

**A2.** 内积空间的四条公理是什么？
::: sol
实内积的四项可列为：对称性 $\langle x,y\rangle=\langle y,x\rangle$；第一变量的齐次性 $\langle ax,y\rangle=a\langle x,y\rangle$；可加性 $\langle x+z,y\rangle=\langle x,y\rangle+\langle z,y\rangle$；正定性 $\langle x,x\rangle\ge0$ 且等号仅在 $x=0$ 时成立。齐次与可加合称线性。由此得 Cauchy–Schwarz：$|\langle x,y\rangle|\le\|x\|\|y\|$。（✓ / △ / ×）
:::

**A3.** 最佳平方逼近的最优性条件是什么？
::: sol
$p^*$ 是最佳平方逼近元素 $\iff$ $\lVert f-p^*\rVert$ 最小 $\iff$ $f-p^*\perp M$（$M$ 为所张成的子空间），等价地 $(f-p^*,\varphi_i)=0\ (i=0,1,\dots,n)$。写成方程组就是**法方程** $G\boldsymbol a=\boldsymbol b$，$G_{ij}=(\varphi_i,\varphi_j)$、$b_i=(f,\varphi_i)$。（✓ / △ / ×）
:::

## B. 定理卡

**B1.** Lagrange 余项定理怎么写？证明的关键是什么？
::: sol
若 $f\in C^{n+1}[a,b]$，则存在 $\xi\in(a,b)$ 使
$$f(x)-p_n(x)=\dfrac{f^{(n+1)}(\xi)}{(n+1)!}\prod_{i=0}^n(x-x_i).$$
证明用辅助函数 $g(t)=f(t)-p_n(t)-K\prod(t-x_i)$，选 $K$ 使 $g(x)=0$，则 $g$ 有 $n+2$ 个零点，由 Rolle 套 $n+1$ 次得 $g^{(n+1)}(\xi)=0$，解出 $K$。（✓ / △ / ×）
:::

**B2.** 差商与导数的关系是什么？Newton 公式怎么写？
::: sol
节点互异、$k\ge1$，且 $f$ 在包含这些节点的区间上属于 $C^k$ 时，有 $f[x_0,\dots,x_k]=\dfrac{f^{(k)}(\xi)}{k!}$，$\xi$ 介于最小与最大节点之间。差商递推：$f[x_i,\dots,x_{k+1}]=\dfrac{f[x_{i+1},\dots,x_{k+1}]-f[x_i,\dots,x_k]}{x_{k+1}-x_i}$。Newton 插值：
$$p_n(x)=f[x_0]+f[x_0,x_1](x-x_0)+f[x_0,x_1,x_2](x-x_0)(x-x_1)+\cdots$$
「**加节点只添一项**」是它相对 Lagrange 的工程优势。（✓ / △ / ×）
:::

**B3.** Hermite 余项和 Lagrange 余项差在哪？
::: sol
互异节点上 Hermite 插值满足 $p(x_i)=f(x_i)$、$p'(x_i)=f'(x_i)$（$i=0,\dots,n$，共 $2n+2$ 个条件），$p$ 次数至多 $2n+1$。若 $f\in C^{2n+2}$，则余项为
$$R(x)=\dfrac{f^{(2n+2)}(\xi)}{(2n+2)!}\prod_{i=0}^n(x-x_i)^2.$$
同一组 $n+1$ 个节点只给函数值时，余项需 $n+1$ 阶导数；同时给一阶导时需 $2n+2$ 阶导数，不能笼统说“只高一阶”。重节点差商用 $f[x_i,x_i]=f'(x_i)$，余项证明使用带重零点的 Rolle 论证。（✓ / △ / ×）
:::

**B4.** 正交多项式有哪些关键性质？
::: sol
① $k$ 次正交多项式在 $(a,b)$ 内恰有 $k$ 个互异实零点（**零点定理**——Gauss 求积的门票）；② $\varphi_k$ 是 $x^k$ 加低次项，$\deg\varphi_k=k$；③ 正交化不改变张成子空间；④ 四族经典：Legendre / Chebyshev / Laguerre / Hermite，各配自己的区间与权。（✓ / △ / ×）
:::

## C. 方法卡

**C1.** 给一组含噪数据 $(x_i,y_i)$，你怎么做拟合？
::: sol
① 明确目标：**逼近**（整体误差最小）而非插值（穿过每点）；② 选基（多项式 / 基函数 / 正交基）；③ 建法方程 $A^{\mathrm T}A\boldsymbol c=A^{\mathrm T}\boldsymbol y$；④ 实际计算优先用 **QR 分解**（不平方条件数），秩亏时用 **SVD / 伪逆**；⑤ 报告残差范数、条件数与有效位数。（✓ / △ / ×）
:::

**C2.** 正交基给法方程带来什么好处？
::: sol
基两两正交 ⟹ $G_{ij}=(\varphi_i,\varphi_j)$ 是**对角阵** ⟹ 法方程解耦成 $n+1$ 个独立公式 $a_i=\dfrac{(f,\varphi_i)}{(\varphi_i,\varphi_i)}$，无需解方程组，误差公式也简化为 $\lVert f-p\rVert^2=(f,f)-\sum_i\dfrac{(f,\varphi_i)^2}{(\varphi_i,\varphi_i)}$。这正是老师反复说的「我们最希望 $A$ 是对角阵」。（✓ / △ / ×）
:::

**A4.** B 样条为什么适合大数据量插值？DFT 与 FFT 的复杂度差在哪？
::: sol
B 样条系数由插值与边界条件一起求出，并不是节点数据的三阶差商。B 样条基具有局部支撑；改变一个基系数只影响其支撑区间。但改变一个插值数据可能通过求解带状系统改变多个系数，不能保证影响严格局部。固定次数、固定带宽且满足可解条件时，带状求解成本可随节点数线性增长。DFT 直接计算为 $O(N^2)$；FFT 是快速计算 DFT 的算法族，基 2 版本要求 $N=2^m$，其他 FFT 可处理其他长度。（✓ / △ / ×）
:::
