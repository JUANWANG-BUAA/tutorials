# 闭卷回忆卡 · 第 5 章：插值与逼近

## A. 定义卡

**A1.** 什么是代数插值？插值多项式的存在唯一性怎么证？
::: sol
代数插值：求次数 $\le n$ 的多项式 $p$，使 $p(x_i)=f(x_i)$（$i=0,\dots,n$）。
**存在唯一性**：存在性用 Lagrange 构造 $p=\sum f(x_i)l_i(x)$，由 $l_i(x_j)=\delta_{ij}$ 直接满足插值条件；唯一性用「两个解之差是 $n+1$ 个互异零点的 $n$ 次多项式，只能为零」。课堂用**范德蒙德矩阵**讲存在唯一并指出病态，教材用基函数线性无关证唯一——两条路线结论一致。（✓ / △ / ×）
:::

**A2.** 内积空间的四条公理是什么？
::: sol
① 非负性 $\langle x,x\rangle\ge0$，且 $\langle x,x\rangle=0\iff x=0$（正定）；② 线性（第一变量的线性）；③ 对称 $\langle x,y\rangle=\langle y,x\rangle$；④ $\langle ax+by,z\rangle=a\langle x,z\rangle+b\langle y,z\rangle$。由此得 Cauchy–Schwarz：$|\langle x,y\rangle|\le\lVert x\rVert\lVert y\rVert$。（✓ / △ / ×）
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
$f[x_0,\dots,x_k]=\dfrac{f^{(k)}(\xi)}{k!}$，$\xi$ 介于最小与最大节点之间。差商递推：$f[x_i,\dots,x_{k+1}]=\dfrac{f[x_{i+1},\dots,x_{k+1}]-f[x_i,\dots,x_k]}{x_{k+1}-x_i}$。Newton 插值：
$$p_n(x)=f[x_0]+f[x_0,x_1](x-x_0)+f[x_0,x_1,x_2](x-x_0)(x-x_1)+\cdots$$
「**加节点只添一项**」是它相对 Lagrange 的工程优势。（✓ / △ / ×）
:::

**B3.** Hermite 余项和 Lagrange 余项差在哪？
::: sol
Hermite 插值满足 $p(x_i)=f(x_i)$、$p'(x_i)=f'(x_i)$（$i=0,\dots,n$，共 $2n+2$ 个条件），$p$ 是 $2n+1$ 次多项式，余项为
$$R(x)=\dfrac{f^{(2n+2)}(\xi)}{(2n+2)!}\prod_{i=0}^n(x-x_i)^2.$$
比 Lagrange 多一个平方因子，阶也高一阶。课堂用**重节点差商**（$f[x_i,x_i]=f'(x_i)$）推出同一结论，教材用辅助函数 + Rolle。（✓ / △ / ×）
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
B 样条基 $N_{i,k}$ 有**局部支撑**：只影响相邻若干段，插值方程组因此带状，可用 $O(n)$ 追赶法；改一个数据点只影响局部。DFT 直接算是 $O(N^2)$；FFT 利用 $W=e^{-2\pi i/N}$ 的周期性把下标按二进制拆分，蝶形递推降到 $O(N\log N)$，标准算法要求 $N=2^m$。（✓ / △ / ×）
:::
