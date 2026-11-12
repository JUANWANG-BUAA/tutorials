# 3.1 幂法与反幂法

如果只需要一个特征值，不一定要先计算特征多项式。反复用矩阵乘同一个向量时，各特征方向上的分量会按不同速度变化。幂法利用这个差别，使目标方向逐渐占优势。

先用二维例子观察变化，再补充特征值、谱界与 Rayleigh 商的必要知识，最后推导幂法、反幂法和位移反幂法。每种方法都需要检查初始向量是否含有目标方向的分量。

## 引导算例：幂法保留下来的究竟是什么？

取 $A=\operatorname{diag}(2,1)$，$u_0=(1,1)^{\mathrm T}$。不急着记算法，先直接算

$$
A^ku_0=(2^k,1)^{\mathrm T}
=2^k(1,2^{-k})^{\mathrm T}.
$$

第二个分量的绝对值始终是 $1$，但它相对第一个分量的比例为 $2^{-k}$。因此变化的核心是**方向**，公共尺度 $2^k$ 没有必要一直保留。归一化负责去掉尺度，谱间隙负责压低其他方向，两者作用不同。

用 $v_k=(1,2^{-k})^{\mathrm T}$ 计算完整 Rayleigh 商：

$$
R(v_k)=\frac{v_k^{\mathrm T}Av_k}{v_k^{\mathrm T}v_k}
=\frac{2+4^{-k}}{1+4^{-k}},\qquad
2-R(v_k)=\frac{4^{-k}}{1+4^{-k}}.
$$

方向偏差按 $2^{-k}$ 下降，而本例的特征值误差按 $4^{-k}$ 下降。这里 $A$ 是对称矩阵，Rayleigh 商在特征向量附近的二阶精度有其结构前提，不能推广成所有非对称矩阵的结论。因为 $R(cv)=R(v)$，更换归一化范数并不会改变完整商的数值；只有省略分母时才必须保证 $\|v\|_2=1$。

**怎样验收？** 对当前向量计算 $\widehat\lambda=R(v)$，再看 $r=Av-\widehat\lambda v$。残差小表示这对数值近似满足特征方程；它是否属于所要的模最大特征值，仍要结合初值与谱条件判断。

::: ex 三个变化，先猜后验证
① 取 $u_0=(0,1)^{\mathrm T}$；② 把 $2$ 换成 $-2$；③ 把 $A$ 换成 $\operatorname{diag}(2,-2)$。分别会发生什么？
:::

::: sol 参考解答
① 初值没有主特征方向分量，精确算术下永远留在第二个方向；残差为零也不说明找到了模最大的特征值。② 主方向仍占优，但归一化向量通常交替变号，应谈方向收敛。③ 两个分量按模同样快，初始两分量均非零时方向一般交替，不能套用严格模最大情形的收敛定理。
:::

下面先补齐理解这些结论所需的谱知识，再给出规范化算法与证明。首次学习可先读本例和“规范化幂法”，遇到不熟悉的性质再回查基础部分。

<a id="sec-3.0"></a>
<a id="class-07-power"></a>
::: note 课堂提示 · 幂法的前提与归一化（据整理稿）

第 7 次课的整理稿着重说明：幂法需要严格按模占优的目标特征值，初始向量也要含有相应的特征分量。每步归一化是为了控制数值大小；若用 $y^{\mathrm T}Ay$ 提取特征值，须先令 $\lVert y\rVert_2=1$。一般情况下保留 Rayleigh 商的分母即可。

来源：[第 7 次课整理稿](../../lectures/lec07.md)。
:::

## 特征值基础

先从特征方程定义特征值与特征向量，再用迹、行列式和矩阵范数估计特征值的位置。这些性质将用于选择迭代目标和判断计算结果。

::: intuition 直觉 · 特征值在工程里到底是什么
特征值问题出现在多种计算任务中。例如：

- **求系统的固有振动频率**——桥梁、机翼、建筑的自振频率，避开驱动频率才不会共振；
- **求机械系统的振动频谱（模态）**——每个特征向量是一个振型；
- **系统的稳定性分析**——动力系统 $\dot{\boldsymbol x}=A\boldsymbol x$ 的稳定性由 $\operatorname{Re}\lambda_i$ 的符号决定；
- **物理学中某些临界值的确定**——临界载荷、临界温度本质上是某个矩阵的最小特征值。
:::

::: def 定义 3.0.1 · 特征多项式、特征值、特征向量 {#def-3.0.1}
已知 $A=(a_{ij})_{n\times n}$，称

$$
\varphi(\lambda)=\det(\lambda I-A)=
\begin{vmatrix}
\lambda-a_{11} & -a_{12} & \cdots & -a_{1n}\\
-a_{21} & \lambda-a_{22} & \cdots & -a_{2n}\\
\vdots & \vdots & \ddots & \vdots\\
-a_{n1} & -a_{n2} & \cdots & \lambda-a_{nn}
\end{vmatrix}
=\lambda^n-(a_{11}+a_{22}+\cdots+a_{nn})\lambda^{n-1}+\cdots+(-1)^n\lvert A\rvert
$$

为 $A$ 的**特征多项式**。方程 $\varphi(\lambda)=\det(\lambda I-A)=0$ 的根称为 $A$ 的**特征值**，$\lambda(A)$ 表示 $A$ 的所有特征值的集合。

设 $\lambda$ 为 $A$ 的特征值，相应齐次方程组 $(\lambda I-A)\boldsymbol x=\boldsymbol 0$ 的非零解 $\boldsymbol x$ 称为 $A$ 对应于 $\lambda$ 的**特征向量**。
:::

::: note 为什么展开式只写出首末两项
$\lambda^n$ 的系数必为 $1$、$\lambda^{n-1}$ 的系数必为 $-\operatorname{tr}A$、常数项为 $(-1)^n\det A$——这三处**不需要真正展开行列式**就能读出来，中间项则不能。这三条正是下面定理 2 的直接来源。

一般五次及以上多项式不存在通用的根式求解公式。即使阶数较低，先展开特征多项式再求根也未必适合数值计算；本章将直接利用矩阵运算构造求解方法。
:::

::: ex 例 3.0.1 · 手算一个 $3\times3$ 的特征值与特征向量 {#ex-3.0.1}
求 $A=\begin{pmatrix}2&1&0\\1&3&1\\0&1&2\end{pmatrix}$ 的特征值及其特征向量。

**解。** 由特征多项式直接读出前两个系数：

$$
\varphi(\lambda)=\det(\lambda I-A)=\lambda^3-\operatorname{tr}(A)\lambda^2+\cdots+(-1)^3\det A .
$$

$\operatorname{tr}A=2+3+2=7$，$\det A=2(6-1)-1(2-0)=10-2=8$，故

$$
\varphi(\lambda)=\lambda^3-7\lambda^2+14\lambda-8=(\lambda-1)(\lambda-2)(\lambda-4).
$$

特征值为 $\lambda_1=4,\ \lambda_2=2,\ \lambda_3=1$。

验算两条恒等式：$\sum\lambda_i=4+2+1=7=\operatorname{tr}A$ ✓；$\prod\lambda_i=4\cdot2\cdot1=8=\det A$ ✓。

对应特征向量（解 $(\lambda I-A)\boldsymbol x=\boldsymbol 0$）：

| $\lambda$ | 特征向量（取整） |
|:--:|:--|
| $1$ | $(1,-1,1)^{\mathrm T}$ |
| $2$ | $(1,0,-1)^{\mathrm T}$ |
| $4$ | $(1,2,1)^{\mathrm T}$ |

三个特征值互异，故三个特征向量线性无关。
:::

::: thm 定理 3.0.1 · 四则运算后特征值怎么变 {#thm-3.0.1}
设 $\lambda$ 是 $A\in\mathbb R^{n\times n}$ 的特征值，$\boldsymbol x$ 是对应的非零特征向量，则

1. $c\lambda$ 是 $cA$ 的特征值（常数 $c\ne0$）；
2. $\lambda-p$ 是 $A-pI$ 的特征值，即 $(A-pI)\boldsymbol x=(\lambda-p)\boldsymbol x$；
3. $\lambda^k$ 是 $A^k$ 的特征值，即 $A^k\boldsymbol x=\lambda^k\boldsymbol x$；
4. 设 $A$ 非奇异，则 $\lambda\ne0$ 且 $\lambda^{-1}$ 是 $A^{-1}$ 的特征值，即 $A^{-1}\boldsymbol x=\lambda^{-1}\boldsymbol x$。
:::

::: proof 证明
四条都是「同一个特征向量保持不变」的直接验证。

1. $(cA)\boldsymbol x=c(A\boldsymbol x)=c(\lambda\boldsymbol x)=(c\lambda)\boldsymbol x$。
2. $(A-pI)\boldsymbol x=A\boldsymbol x-p\boldsymbol x=(\lambda-p)\boldsymbol x$。
3. 对 $k$ 归纳：$A^2\boldsymbol x=A(A\boldsymbol x)=A(\lambda\boldsymbol x)=\lambda A\boldsymbol x=\lambda^2\boldsymbol x$，余同。
4. 由 $\det A=\prod\lambda_i\ne0$ 知所有 $\lambda\ne0$。$A\boldsymbol x=\lambda\boldsymbol x$ 两边左乘 $A^{-1}$ 得 $\boldsymbol x=\lambda A^{-1}\boldsymbol x$，即 $A^{-1}\boldsymbol x=\lambda^{-1}\boldsymbol x$。$\blacksquare$
:::

::: note 定理 3.0.1 的用处：位移反幂法全靠第 2 条
第 2 条是整个第 3 章最有用的一条：求 $A-pI$ 的**模最小**特征值，等价于求 $A$ 的**最接近 $p$** 的特征值。位移反幂法（[3.1.2](#sec-3.1.2)）正是这样把「求最接近已知近似值的特征值」化成「求模最小」，再交给反幂法。第 3 条则解释了幂法为什么用 $A^k\boldsymbol u_0$ 迭代——$A^k$ 的特征值是 $\lambda_i^k$，模大的压倒模小的。
:::

::: thm 定理 3.0.2 · 特征值与迹、行列式的关系 {#thm-3.0.2}
若 $\lambda_i\ (i=1,\dots,n)$ 是矩阵 $A$ 的特征值，则

$$
(1)\ \sum_{i=1}^n\lambda_i=\sum_{i=1}^n a_{ii}=\operatorname{tr}(A);\qquad
(2)\ \det(A)=\lambda_1\lambda_2\cdots\lambda_n .
$$
:::

::: proof 证明
由定义 3.0.1 的展开式，比较 $\lambda^{n-1}$ 系数与常数项即可。

$\varphi(\lambda)=\prod_{i=1}^n(\lambda-\lambda_i)$，展开后 $\lambda^{n-1}$ 的系数是 $-\sum_i\lambda_i$，常数项是 $(-1)^n\prod_i\lambda_i$。而按行列式定义直接展开 $\det(\lambda I-A)$ 时，$\lambda^{n-1}$ 只来自主对角线乘积 $\prod_i(\lambda-a_{ii})$ 一项，其系数为 $-\sum_ia_{ii}$；常数项（即 $\lambda=0$）为 $\det(-A)=(-1)^n\det A$。两两对照即得。$\blacksquare$
:::

::: note 这两条是免费的验算工具
算完一组特征值，**先花十秒验算** $\sum\lambda_i=\operatorname{tr}A$、$\prod\lambda_i=\det A$。浮点计算下允许 $10^{-10}$ 量级误差；差得多就是算错了。第 3 章各节的例题与习题解答都得用这两条自查。
:::

::: thm 定理 3.0.3 · 转置不改变谱 {#thm-3.0.3}
设 $A\in\mathbb R^{n\times n}$，则 $\lambda(A)=\lambda(A^{\mathrm T})$。
:::

::: proof 证明
$\det(\lambda I-A^{\mathrm T})=\det((\lambda I-A)^{\mathrm T})=\det(\lambda I-A)$——转置不改变行列式，故特征多项式相同，特征值相同。$\blacksquare$

$A$ 与 $A^{\mathrm T}$ 的特征值相同，特征向量一般不同。若 $A\boldsymbol x=\lambda\boldsymbol x$，则 $\boldsymbol x$ 是右特征向量；若 $\boldsymbol y^{\mathrm T}A=\lambda\boldsymbol y^{\mathrm T}$，则 $\boldsymbol y$ 是左特征向量。对实对称矩阵，这两种关系可以使用同一组向量。
:::

::: thm 定理 3.0.4 · 分块上三角的谱是各块谱之并 {#thm-3.0.4}
设 $A$ 为分块上三角阵

$$
A=\begin{pmatrix}
A_{11} & A_{12} & \cdots & A_{1m}\\
& A_{22} & \cdots & A_{2m}\\
& & \ddots & \vdots\\
& & & A_{mm}
\end{pmatrix},
$$

其中每个对角块 $A_{ii}$ 均为方阵，则 $\lambda(A)=\bigcup_{i=1}^m\lambda(A_{ii})$。
:::

::: proof 证明
对 $m$ 归纳。$m=1$ 平凡。设 $m-1$ 块时成立，把 $A$ 按最后一块分块为 $\begin{pmatrix}\tilde A&c\\0&A_{mm}\end{pmatrix}$，则

$$
\det(\lambda I-A)=\det(\lambda I-\tilde A)\cdot\det(\lambda I-A_{mm})
$$

（分块上三角的行列式等于对角块行列式之积）。右边两个因子的根分别是 $\lambda(\tilde A)$ 与 $\lambda(A_{mm})$，再由归纳假设得结论。$\blacksquare$
:::

::: note 定理 3.0.4 为什么考
分块三角矩阵的特征多项式等于各对角块特征多项式的乘积，因此可以分别求各块的特征值。QR 迭代会逐步产生这种可分解的结构；实际计算先化为 Hessenberg 形以减少每步的运算，见 [3.3](sec33.md)。Hessenberg 形本身还不是三角形，不能直接从主对角线上读出特征值。
:::

::: thm 定理 3.0.5 · 相似矩阵同谱，特征向量随之变换 {#thm-3.0.5}
若 $A$ 与 $B$ 为相似矩阵，即存在非奇异 $P$ 使 $P^{-1}AP=B$，则

1. $A$ 与 $B$ 有相同的特征值；
2. 若 $\boldsymbol y$ 是 $B$ 的特征向量，则 $P\boldsymbol y$ 是 $A$ 的特征向量。
:::

::: proof 证明
1. $\det(\lambda I-B)=\det(\lambda I-P^{-1}AP)=\det\bigl(P^{-1}(\lambda I-A)P\bigr)=\det(P^{-1})\det(\lambda I-A)\det(P)=\det(\lambda I-A)$。
2. $B\boldsymbol y=\lambda\boldsymbol y$ 即 $P^{-1}AP\boldsymbol y=\lambda\boldsymbol y$，两边左乘 $P$ 得 $A(P\boldsymbol y)=\lambda(P\boldsymbol y)$。$\blacksquare$
:::

::: note 第 2 条常被漏掉
相似变换还给出了特征向量的对应关系。若 $B=P^{-1}AP$，且 $B\boldsymbol z=\lambda\boldsymbol z$，则 $A(P\boldsymbol z)=\lambda(P\boldsymbol z)$。因此用 Jacobi 或 QR 变换后，除了读取特征值，还要利用累积变换恢复原矩阵的特征向量。
:::

::: thm 定理 3.0.6 · 实对称矩阵的正交约化 {#thm-3.0.6}
设 $A\in\mathbb R^{n\times n}$ 为对称矩阵，则

1. $A$ 的特征值**均为实数**；
2. $A$ 有 $n$ 个**线性无关**的特征向量；
3. 存在**正交矩阵** $P$ 使得

$$
P^{-1}AP=\operatorname{diag}(\lambda_1,\lambda_2,\dots,\lambda_n),
$$

且 $\lambda_i\ (i=1,2,\dots,n)$ 为 $A$ 的特征值，而 $P=(\boldsymbol u_1,\boldsymbol u_2,\dots,\boldsymbol u_n)$ 的列向量 $\boldsymbol u_j$ 为对应于 $\lambda_j$ 的特征向量。
:::

::: note 这三条为什么放在一起
三个结论是递进的：**实特征值**（才能排序、才能谈「最大最小」）→ **$n$ 个线性无关特征向量**（才能对角化）→ **正交**（不只是相似，还是正交相似，$P^{-1}=P^{\mathrm T}$）。

第三条最强：它保证 $A=Q\Lambda Q^{\mathrm T}$，于是 $A$ 的任意多项式 $f(A)=Qf(\Lambda)Q^{\mathrm T}$，所有谱理论（Rayleigh 商、Courant–Fischer、奇异值 = 特征值绝对值）都从这里出发。

对称矩阵因此是「最友好」的一类：特征值实、特征向量正交、扰动敏感度温和（见[补充篇 2.5](../../supplement/sec25.md)）。
:::

::: def 定义 3.0.2 · Gerschgorin 圆盘 {#def-3.0.2}
设 $A=(a_{ij})_{n\times n}$，令

$$
r_i=\sum_{j\ne i}\lvert a_{ij}\rvert,\qquad
D_i=\{z:\ \lvert z-a_{ii}\rvert\le r_i,\ z\in\mathbb C\},\quad (i=1,\dots,n),
$$

称 $D_i$ 为复平面上以 $a_{ii}$ 为圆心、以 $r_i$ 为半径的 **Gerschgorin 圆盘**。
:::

::: thm 定理 3.0.7 · Gerschgorin 圆盘定理 {#thm-3.0.7}
1. 设 $A=(a_{ij})_{n\times n}$，则 $A$ 的每一个特征值必属于下列某个圆盘之中：

$$
\lvert\lambda-a_{ii}\rvert\le\sum_{j\ne i}\lvert a_{ij}\rvert,\qquad (i=1,\dots,n).
$$

2. 如果上述 $n$ 个圆盘中有 $m$ 个圆盘构成一个连通域 $S$，且 $S$ 与其余 $n-m$ 个圆盘**分离**，则 $S$ 中**恰有** $A$ 的 $m$ 个特征值，按代数重数计数。
:::

::: proof 证明（第 1 条）
设 $\lambda$ 是特征值、$\boldsymbol x\ne\boldsymbol 0$ 是对应特征向量，$A\boldsymbol x=\lambda\boldsymbol x$。取 $\lvert x_k\rvert=\max_i\lvert x_i\rvert\gt0$，看第 $k$ 个方程：

$$
(\lambda-a_{kk})x_k=\sum_{j\ne k}a_{kj}x_j
\ \Longrightarrow\ 
\lvert\lambda-a_{kk}\rvert\lvert x_k\rvert\le\sum_{j\ne k}\lvert a_{kj}\rvert\lvert x_j\rvert\le\Bigl(\sum_{j\ne k}\lvert a_{kj}\rvert\Bigr)\lvert x_k\rvert .
$$

两边约去 $\lvert x_k\rvert\gt0$ 即得 $\lvert\lambda-a_{kk}\rvert\le r_k$，故 $\lambda\in D_k$。$\blacksquare$

（第 2 条用连续性论证：令 $A_t=D+t(A-D)$，$D=\operatorname{diag}(a_{ii})$。$t=0$ 时特征值恰是各圆心，$t=1$ 时按第 1 条落在各圆盘内；特征值随 $t$ 连续变化，无法跳过 $S$ 与其余圆盘之间的空隙，故 $S$ 内的个数守恒。完整证明见[补充篇 2.5.2](../../supplement/sec25.md#thm-sup-2.5.2)。）
:::

::: method 圆盘定理的三种用法
1. **判断可逆 / 有没有零特征值**：若所有圆盘都不含原点，则 $0\notin\lambda(A)$，$A$ 可逆。最常用的充分条件是**严格对角占优**（$\lvert a_{ii}\rvert\gt r_i$ 对每行成立）。
2. **围出特征值的范围**：直接读矩阵的对角元与行和，$O(n^2)$ 就能给出可靠围栏——不需要任何特征值计算。
3. **估计特征值位置**：小半径给出较窄的范围。若某个圆盘与其余圆盘分离，其中恰有一个特征值，它到圆心的距离不超过该圆盘的半径。严格对角占优只保证圆盘不含原点，并不保证半径很小。
:::

::: note 用对角相似变换改进圆盘界
还可以先作对角相似变换，再使用圆盘定理。取非奇异对角矩阵 $D=\operatorname{diag}(\alpha_1,\dots,\alpha_n)$，则

$$
D^{-1}AD=\Bigl(\frac{a_{ij}\alpha_j}{\alpha_i}\Bigr)_{n\times n}.
$$

由定理 3.0.5，$D^{-1}AD$ 与 $A$ 的特征值相同，但圆盘半径可能改变。某些圆盘缩小的同时，另一些可能增大；选择缩放系数的目的是让需要区分的圆盘分离，再利用定理中的特征值计数结论。
:::

::: ex 例 3.0.2 · 用对角缩放改进特征值范围 {#ex-3.0.2}
估计 $A=\begin{pmatrix}4&1&0\\1&0&-1\\1&1&-4\end{pmatrix}$ 的特征值范围。

**第一步：直接看三个圆盘**（按行）：

$$
\lvert\lambda-4\rvert\le1,\qquad \lvert\lambda-0\rvert\le2,\qquad \lvert\lambda+4\rvert\le2 .
$$

这三个集合首先是复平面上的圆盘。第一个与其余两个分离，恰含一个特征值；后两个在 $-2$ 处相接，只能合起来计数，其中共有两个特征值。由于 $A$ 并不对称，此时还不能把全部特征值写成实区间中的点。

**第二步：取 $D=\operatorname{diag}(1,1,\tfrac{10}{9})$ 缩放**。$D^{-1}AD$ 的元素为 $a_{ij}\alpha_j/\alpha_i$：

$$
D^{-1}AD=\begin{pmatrix}
4 & 1 & 0\\
1 & 0 & -\tfrac{10}{9}\\
0.9 & 0.9 & -4
\end{pmatrix}.
$$

**第三步：先数特征值，再判断是否为实数。** 缩放后的三个圆盘半径分别为 $1,19/9,9/5$。它们的圆心仍为 $4,0,-4$，圆心间距均大于对应的半径之和，因此两两分离。每个圆盘各含一个特征值，按代数重数计数。

$A$ 是实矩阵，非实特征值必成共轭对出现。而每个圆盘的圆心都在实轴上，若包含一个非实根，也必包含它的共轭根，就会与“恰有一个”矛盾。因此本例三个特征值全为实数，现可把各圆盘与实轴相交，得到：

| 圆盘 | 范围 |
|:--|:--|
| $\lvert\lambda-4\rvert\le1$ | $3\le\lambda_1\le5$ |
| $\lvert\lambda\rvert\le1+\tfrac{10}{9}=\tfrac{19}{9}$ | $-\tfrac{19}{9}\le\lambda_2\le\tfrac{19}{9}$ |
| $\lvert\lambda+4\rvert\le1.8$ | $-5.8\le\lambda_3\le-2.2$ |

这里的 $\lambda_1,\lambda_2,\lambda_3$ 按所在圆盘编号；此处没有按模排序。缩放不仅给出范围，还把原来无法分开的两个特征值分别定位了。

（验算：$A$ 的实际特征值约为 $4.2030,\ -0.4429,\ -3.7601$，确实分别落在三个区间内。）
:::

::: def 定义 3.0.3 · Rayleigh 商 {#def-3.0.3}
设 $A$ 是 $n$ 阶**实对称**阵，对于任一非零向量 $\boldsymbol x\in\mathbb R^n$，称

$$
R(\boldsymbol x)=\frac{(A\boldsymbol x,\boldsymbol x)}{(\boldsymbol x,\boldsymbol x)}
$$

为关于向量 $\boldsymbol x$ 的**瑞雷（Rayleigh）商**。
:::

::: thm 定理 3.0.8 · Rayleigh 商的变分性质 {#thm-3.0.8}
设 $A$ 为 $n$ 阶实对称阵，$\lambda_1\ge\lambda_2\ge\cdots\ge\lambda_n$ 为 $A$ 的特征值（**降序**，与第 3 章其余各节一致），则

$$
(1)\ \lambda_1\ge\frac{(A\boldsymbol x,\boldsymbol x)}{(\boldsymbol x,\boldsymbol x)}\ge\lambda_n
\quad\text{对任何非零}\ \boldsymbol x\in\mathbb R^n;
$$
$$
(2)\ \lambda_1=\max_{\boldsymbol x\ne\boldsymbol 0}\frac{(A\boldsymbol x,\boldsymbol x)}{(\boldsymbol x,\boldsymbol x)};\qquad
(3)\ \lambda_n=\min_{\boldsymbol x\ne\boldsymbol 0}\frac{(A\boldsymbol x,\boldsymbol x)}{(\boldsymbol x,\boldsymbol x)} .
$$
:::

::: proof 证明
由定理 3.0.6，实对称阵有标准正交特征向量组 $\boldsymbol u_1,\dots,\boldsymbol u_n$，$A\boldsymbol u_i=\lambda_i\boldsymbol u_i$。任取 $\boldsymbol x=\sum_ic_i\boldsymbol u_i\ne\boldsymbol 0$，则

$$
(A\boldsymbol x,\boldsymbol x)=\Bigl(\sum_ic_i\lambda_i\boldsymbol u_i,\sum_jc_j\boldsymbol u_j\Bigr)=\sum_i\lambda_ic_i^2,\qquad
(\boldsymbol x,\boldsymbol x)=\sum_ic_i^2 .
$$

于是 $R(\boldsymbol x)=\frac{\sum_i\lambda_ic_i^2}{\sum_ic_i^2}$，是 $\lambda_i$ 以 $c_i^2\ge0$ 为权的**加权平均**，故必落在 $[\lambda_n,\lambda_1]$ 内——第 (1) 条成立。

取 $\boldsymbol x=\boldsymbol u_1$（即 $c_1\ne0$、其余 $c_i=0$）得 $R=\lambda_1$，故上界可达，第 (2) 条成立；取 $\boldsymbol x=\boldsymbol u_n$ 同理得第 (3) 条。$\blacksquare$
:::

::: note 用 Rayleigh 商估计特征值
对实对称矩阵，$2$-范数单位向量的 $\beta=y^{\mathrm T}Ay$ 就是 Rayleigh 商，因而落在最小与最大特征值之间。若 $y$ 接近某个特征方向，商就接近该方向对应的特征值；这个值可以为负，也未必是代数最大的特征值。下面的幂法利用它估计按模最大的目标值。

本节按降序排列实对称矩阵的特征值，即 $\lambda_1$ 最大。[补充篇 2.5.4](../../supplement/sec25.md#thm-sup-2.5.4) 采用升序，使用相应结论时需调整下标。
:::

::: think 这一节的常见错误
1. **混淆两种排序。** Rayleigh 变分定理按代数大小排序，幂法按模排序，须分别看清假设。实对称矩阵的模最大特征值同样可能为负，例如 $\operatorname{diag}(-5,2,3)$ 的模最大值为 $-5$，代数最大值为 $3$。
2. **以为 $\lambda(A)=\lambda(A^{\mathrm T})$ 就可以拿 $A^{\mathrm T}$ 的特征向量当 $A$ 的**。特征值相同，特征向量不同。
3. **分了块却忘了分块上三角的前提**。定理 3.0.4 要求**对角块是方阵、且下三角块为零**。一般分块矩阵没有这个结论。
4. **忽略可以改进的圆盘界。**行圆盘与列圆盘都包含全部特征值，所以可取二者的交集。适当的对角相似变换还可能使圆盘分离，帮助判断各区域内的特征值个数。
5. **Rayleigh 商用在非对称矩阵上**。定理 3.0.8 全部依赖实对称 + 标准正交特征基。非对称时 Rayleigh 商可能落在谱外。
:::

::: method[core] 特征值基础 · 必记六条
| 结论 | 式子 | 用处 |
|:--|:--|:--|
| 迹与行列式 | $\sum\lambda_i=\operatorname{tr}A$，$\prod\lambda_i=\det A$ | 十秒验算 |
| 四则运算 | $c\lambda$、$\lambda-p$、$\lambda^k$、$\lambda^{-1}$ | 位移反幂法的根据 |
| 分块上三角 | $\lambda(A)=\bigcup\lambda(A_{ii})$ | QR 拟上三角化 |
| 相似不变 | 特征值同、特征向量乘 $P$ | Jacobi/QR 求特征向量 |
| 实对称 | 实特征值 + 正交特征基 + $Q\Lambda Q^{\mathrm T}$ | 谱理论的总入口 |
| Gerschgorin | $\lvert\lambda-a_{ii}\rvert\le r_i$，连通域计数 | 不计算就估界 |
:::

<a id="sec-3.1.1"></a>
## 3.1.1 幂法

::: intuition 直觉 · 特征值问题从哪来：能级就是特征值
求矩阵特征值的算法源头是**定态薛定谔方程**的能级计算：哈密顿算子 = 动能项（$-\frac{\hbar^2}{2m}\nabla^2$，拉普拉斯算子）+ 势能项 $V$。薛定谔自己算出了氢原子；复杂（多粒子）系统必须离散化数值求解：

$$\text{微分算子}\ \xrightarrow{\ \text{离散}\ }\ \text{矩阵},\qquad \text{能级}= \text{特征值},\qquad \text{本征态（波函数）}= \text{特征向量}.$$

有时只需要少数几个特征值，而不需要全部特征对。本节先研究按模严格最大的特征值及相应方向；幂法每步只需要一次矩阵与向量相乘，适合从这个目标开始。
:::

::: def 定义 3.1.1 · 主特征值与幂法的前提 {#def-3.1.1}
设 $A$ 有 $n$ 个线性无关的特征向量 $x_1,\dots,x_n$，对应特征值满足

$$|\lambda_1|\gt|\lambda_2|\ge\cdots\ge|\lambda_n|.$$

$\lambda_1$ 称为 $A$ 的**主特征值**（按模最大的特征值），$x_1$ 称为对应的**主特征向量**。幂法还要求初值 $u_0$ 在 $x_1$ 方向的分量 $\alpha_1\ne0$。
:::

下面假设 $A$ 有一组线性无关的特征向量。这个条件不能用“向量互不相同”代替；不同特征值对应的特征向量则必然线性无关。把初始向量在这组基下展开，并要求主特征向量的系数 $\alpha_1\ne0$：

$$u_0=\alpha_1x_1+\alpha_2x_2+\cdots+\alpha_nx_n .$$

由 $Ax_i=\lambda_ix_i$ 反复作用可得 $A^kx_i=\lambda_i^kx_i$，于是

$$
u_k=A^k u_0=a_1\lambda_1^kx_1+a_2\lambda_2^kx_2+\cdots+a_n\lambda_n^kx_n
=\lambda_1^k\left(a_1x_1+\sum_{j=2}^n a_j\left(\frac{\lambda_j}{\lambda_1}\right)^kx_j\right).
$$

当 $k$ 充分大时，$u_k$ 的方向趋于 $x_1$；比值 $|\lambda_2/\lambda_1|$ 越小，收敛越快。


::: note 非对称矩阵：展开系数不是普通正交投影 {#note-power-initial}
设特征向量基矩阵为 $V=(x_1,\ldots,x_n)$，则系数向量是 $V^{-1}u_0$。若 $w_1^{\mathrm T}$ 为 $V^{-1}$ 的第一行，$w_1$ 是相应左特征向量，$\alpha_1=w_1^{\mathrm T}u_0$。一般不能把它换成 $x_1^{\mathrm T}u_0$。

例如 $A=\begin{pmatrix}2&1\\0&1\end{pmatrix}$ 的主右特征向量为 $(1,0)^{\mathrm T}$，但 $u_0=(1,-1)^{\mathrm T}$ 与它不正交、却满足 $Au_0=u_0$，永远找不到主值 2。实对称矩阵可取正交特征基时，“主展开系数非零”才等价于“与主特征向量不正交”。
:::

::: lem 引理 3.1.1 · 实矩阵的主特征值是实数 {#lem-3.1.1}
设 $A$ 为实矩阵，$\lambda_1$ 是按模**严格最大**的特征值，则 $\lambda_1\in\mathbb R$。
:::

::: proof 证明
设 $f(\lambda)=\det(\lambda I-A)$ 为特征多项式。$A$ 是实矩阵 $\Rightarrow$ 各系数为实数：$f(\lambda)=a_n\lambda^n+a_{n-1}\lambda^{n-1}+\cdots+a_0$，$a_n,\dots,a_0\in\mathbb R$。反设 $\lambda_1$ 不是实数，即 $\operatorname{Im}\lambda_1\ne0$，则其共轭 $\overline{\lambda_1}\ne\lambda_1$。对 $f(\lambda_1)=0$ 两边取共轭，用两条性质——**乘积的共轭 = 共轭的乘积**、**实数的共轭是自身**——得 $f(\overline{\lambda_1})=0$，即 $\overline{\lambda_1}$ **也是** $A$ 的特征值。而 $|\overline{\lambda_1}|=|\lambda_1|$ 且 $\overline{\lambda_1}\ne\lambda_1$，出现**两个**模相等的最大特征值，与「严格最大」矛盾。故 $\lambda_1\in\mathbb R$。$\blacksquare$
:::

::: note 主特征值为什么是实数
实矩阵的非实特征值成共轭对出现，二者的模相同。因此，若某个特征值的模严格大于其余所有特征值，它一定是实数。幂法的主项可能保持符号，也可能随迭代交替变号；分析收敛时要区分向量本身与它所代表的方向。
:::

::: intuition 为什么每步都要归一化
直接计算 $A^ku_0$ 时，公共因子 $\lambda_1^k$ 可能使向量过大或过小。我们只想知道方向，因此每乘一次 $A$，就把向量除以一个非零尺度。这样保留各分量的比例，也避免不断积累没有必要的大小变化。其他特征分量是否相对衰减，仍由特征值的模比决定。
:::

::: method[core] 算法 · 规范化幂法
$$
y_{k-1}=\frac{u_{k-1}}{\lVert u_{k-1}\rVert_2},\qquad
u_k=A y_{k-1},\qquad
\beta_k=y_{k-1}^{\mathrm T}u_k.
$$

$\beta_k\to\lambda_1$，$y_{k-1}$ 趋于主特征向量的**方向**；主特征值为负时归一化向量通常正负交替，不能声称向量本身有固定极限。注意 $u_k=Ay_{k-1}$，故 $\beta_k=y_{k-1}^{\mathrm T}Ay_{k-1}$——在 2-范数归一化（$\lVert y_{k-1}\rVert_2=1$）下，$\beta_k$ 正是 $y_{k-1}$ 处的 Rayleigh 商（[@def-3.1.2]）。
:::

::: note 归一化与矩阵相乘的顺序
归一化是为了控制中间向量的大小，减少溢出或下溢的风险。写成“先归一化，再乘 $A$”或“先乘 $A$，再归一化”都可以；两种写法只是在索引上不同，提取特征值时必须与所用的递推配对。
:::

::: note 归一化的副产品
每步单位化使归一化向量 $y_k$ 留在单位球面上；未归一化量 $u_{k+1}=Ay_k$ 的量级还受 $A$ 的范数影响，仍须注意乘法的有限范围——这是幂法能在有限精度下长期迭代的前提。
:::

::: thm 定理 · 幂法的收敛性 {#thm-3.1.1}
设 $A$ 为实矩阵，特征值满足 $|\lambda_1|\gt|\lambda_2|\ge\cdots\ge|\lambda_n|$（由 [@lem-3.1.1]，$\lambda_1$ 为实数），$x_1,\dots,x_n$ 线性无关。任取非零 $u_0=\sum_{i=1}^n\alpha_ix_i$ 且 $\alpha_1\ne0$，按规范化幂法迭代，则

$$\text{(i)}\quad y_{k-1}\to\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ (\lambda_1\gt0),\qquad
(-1)^{k-1}y_{k-1}\to\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ (\lambda_1\lt0);$$

$$\text{(ii)}\quad \text{取 2-范数归一化时}\quad \beta_k=y_{k-1}^{\mathrm T}u_k\to\lambda_1 .$$

$\lambda_1\lt0$ 时，应比较向量所代表的直线方向，而非要求单位向量趋于固定符号。
:::

::: proof 证明
**(i) 回推。** 要看清 $y_{k-1}$ 的极限，先问它从哪来：$y_{k-1}$ 是 $u_{k-1}$ 的单位化，$u_{k-1}=Ay_{k-2}$，而 $y_{k-2}$ 又是 $u_{k-2}$ 的单位化……一路回推到 $u_0$，中间那些范数都是**常数**，按齐次性提到范数号外后逐次相消：

$$
y_{k-1}=\frac{u_{k-1}}{\lVert u_{k-1}\rVert}=\frac{A^{k-1}u_0}{\lVert A^{k-1}u_0\rVert}
=\left(\frac{\lambda_1}{|\lambda_1|}\right)^{k-1}
\frac{\alpha_1x_1+\sum_{i\ge2}\alpha_i\left(\lambda_i/\lambda_1\right)^{k-1}x_i}
{\bigl\lVert\alpha_1x_1+\sum_{i\ge2}\alpha_i\left(\lambda_i/\lambda_1\right)^{k-1}x_i\bigr\rVert}.
$$

因 $|\lambda_i/\lambda_1|\lt1\ (i\ge2)$，分式除首项外全部趋于零；$(\lambda_1/|\lambda_1|)^{k-1}$ 在 $\lambda_1\gt0$ 时为 $1$，在 $\lambda_1\lt0$ 时为 $(-1)^{k-1}$。得 (i)。

**(ii) 特征值。** 2-范数归一化给出 $\lVert y_{k-1}\rVert_2=1$，即 $y_{k-1}^{\mathrm T}y_{k-1}=1$，故 $\beta_k=y_{k-1}^{\mathrm T}u_k=y_{k-1}^{\mathrm T}Ay_{k-1}$ 正是 $y_{k-1}$ 处的 Rayleigh 商。代入 (i) 的极限（以 $\lambda_1\gt0$ 为例）：

$$
\beta_k\longrightarrow
\frac{(\alpha_1x_1)^{\mathrm T}(\lambda_1\alpha_1x_1)}{\lVert\alpha_1x_1\rVert_2^2}
=\lambda_1\,\frac{\alpha_1^2\,x_1^{\mathrm T}x_1}{\alpha_1^2\,x_1^{\mathrm T}x_1}=\lambda_1,
$$

其中 $x_1^{\mathrm T}x_1=\lVert x_1\rVert_2^2$（内积就是欧氏长度的平方，见 [@def-3.1.2] 后的说明）。$\lambda_1\lt0$ 时 $y_{k-1}$ 与 $u_k=Ay_{k-1}$ 各带一个 $(-1)^{k-1}$，点乘时**两次相消**，结果同样是 $\lambda_1$。$\blacksquare$
:::

::: def 定义 3.1.2 · Rayleigh 商 {#def-3.1.2}
对任意非零向量 $y$，

$$R(y)=\frac{y^{\mathrm T}Ay}{y^{\mathrm T}y}$$

称为 $y$ 处的 **Rayleigh 商**。只有 $\lVert y\rVert_2=1$ 时，才能省略分母写成 $y^{\mathrm T}Ay$。用其他范数归一化仍可求特征值，只须保留分母；例如 $A=\operatorname{diag}(2,1)$、$y=(1,1/2)^{\mathrm T}$ 时，$y^{\mathrm T}Ay=9/4$，而 $R(y)=9/5$。对实对称矩阵，Rayleigh 商在单位特征向量附近的误差为方向误差的二阶；一般非对称矩阵不能直接套用这一二阶结论。
:::

::: think 收敛速度与边界
在严格主特征值和非零主分量假设下，方向误差受 $|\lambda_2/\lambda_1|^k$ 控制。若若干特征值仅仅**模相同**，不能保证幂法方向或 Rayleigh 商收敛到其中一个特征值。例如 $A=\operatorname{diag}(1,-1)$、$u_0=(1,1)^{\mathrm T}$ 使方向在两点间交替，而 Rayleigh 商恒为 $0$，不是 $A$ 的特征值。若主特征值为同一个重复值、其余特征值严格较小，才可在初值主子空间分量非零时讨论趋于该特征子空间的方向。
:::

::: ex 例 1 · 幂法求主特征值与特征向量 {#ex-3.1-textbook1}
矩阵

$$
A=\begin{pmatrix}
6&-12&6\\
-21&-3&24\\
-12&-12&51
\end{pmatrix}.
$$

精确特征值为 $45,18,-9$。取 $u_0=(1,0,0)^{\mathrm T}$，按规范化幂法迭代，$\beta_k$ 迅速趋向 $45$：

| $k$ | $u_k^{\mathrm T}$ | $y_k^{\mathrm T}$ | $\beta_k$ |
|:--:|:--|:--|:--:|
| 0 | 1.000000, 0.000000, 0.000000 | 1.000000, 0.000000, 0.000000 | — |
| 1 | 6.000000, -21.000000, -12.000000 | 0.240772, -0.842701, -0.481543 | 6.000000 |
| 2 | 8.667781, -14.085145, -17.335563 | 0.361773, -0.587880, -0.723545 | 22.304348 |
| 3 | 4.883929, -23.198662, -34.187502 | 0.117393, -0.557619, -0.821754 | 40.141104 |
| 4 | 2.465263, -20.514506, -36.626758 | 0.058623, -0.487827, -0.870970 | 41.826873 |
| 5 | 0.979841, -20.670876, -39.269012 | 0.022074, -0.465685, -0.884675 | 44.343372 |
| 15 | 0.000108, -20.124666, -40.249116 | 0.000002, -0.447216, -0.894426 | 44.999928 |

本表按上面的 **2-范数归一化与 Rayleigh 商** 重算，保留六位小数。第 15 步 $\beta_{15}\approx44.999928$；方向趋于 $(0,-1/\sqrt5,-2/\sqrt5)^{\mathrm T}$，与精确特征向量 $(0,1,2)^{\mathrm T}$ 同一条直线。
:::

::: method 无穷范数归一化：保留特征值的符号 {#power-infinity-normalization}
也可以每步选择 $r_k$，使 $|(u_{k-1})_{r_k}|=\lVert u_{k-1}\rVert_\infty$，再作

$$
y_{k-1}=\frac{u_{k-1}}{(u_{k-1})_{r_k}},\qquad
u_k=Ay_{k-1},\qquad
\beta_k=\frac{(u_k)_{r_k}}{(y_{k-1})_{r_k}}=(u_k)_{r_k}.
$$

分母用的是带符号的分量，因此 $(y_{k-1})_{r_k}=1$。在前述主特征值与初值条件下，这个分量比趋于 $\lambda_1$。也可除以正数 $\lVert u_{k-1}\rVert_\infty$，此时选中分量为 $\pm1$，提取特征值时须保留比值的分母。

例如 $A=\operatorname{diag}(-2,1)$、$u_0=(1,1)^{\mathrm T}$，前两轮带符号归一化给出

$$
y_0=(1,1)^{\mathrm T},\quad u_1=(-2,1)^{\mathrm T};\qquad
y_1=(1,-1/2)^{\mathrm T},\quad u_2=(-2,-1/2)^{\mathrm T}.
$$

所选第一分量给出的 $\beta_1=\beta_2=-2$，保留了主特征值的负号；而 $\lVert u_k\rVert_\infty$ 总为非负，不能直接用它代替有符号的特征值。完整 Rayleigh 商仍可使用，省略其分母则要求 $2$-范数单位化。
:::

### 同一个主特征值重复出现 {#power-repeated-dominant}

前面先讨论了一个严格占优的特征方向。若 $A$ 可对角化，且

$$
\lambda_1=\cdots=\lambda_m=\lambda_*,\qquad
|\lambda_*|>\max_{j>m}|\lambda_j|,
$$

就把初值在主特征空间中的分量合并为 $v=\sum_{j=1}^m\alpha_jx_j$。只要 $v\ne0$，仍有

$$
\frac{A^ku_0}{\lVert A^ku_0\rVert}
-\bigl[\operatorname{sign}(\lambda_*)\bigr]^k\frac{v}{\lVert v\rVert}
\longrightarrow0.
$$

所得方向依赖初值，但 $Av=\lambda_*v$，所以它确实是目标特征向量。例如 $A=\operatorname{diag}(3,3,1)$、$u_0=(1,2,1)^{\mathrm T}$，单位化方向趋于 $(1,2,0)^{\mathrm T}/\sqrt5$。这与 $\operatorname{diag}(3,-3,1)$ 不同：后者有两个不同的等模主值，通常不能收敛到一条固定方向。这里沿用可对角化假设，不能只凭“重数大于一”就套用展开式。

### 主特征值等模时：用两步递推保留一对根 {#power-dominant-pair}

普通幂法试图留下一个方向。若模最大的是实矩阵的一对复共轭特征值，迭代向量会在对应的实二维子空间中旋转；这时应保留两个方向的信息。lecture6 pp.24–25 给出从连续幂向量恢复特征值对的思路。

先设 $A$ 可对角化，$\lambda,\bar\lambda$ 是模严格大于其余特征值的一对非实共轭根，初值在这对特征方向上有非零分量。令未逐步归一化的 $u_k=A^ku_0$，并记

$$
p=-(\lambda+\bar\lambda),\qquad q=\lambda\bar\lambda.
$$

在主二维子空间中，$A^2+pA+qI=0$。其他分量相对衰减后便有

$$
u_{k+2}+pu_{k+1}+qu_k\approx0.
$$

选两个能给出独立方程的分量解 $p,q$；若使用全部分量，可以最小二乘求解

$$
\begin{pmatrix}u_{k+1}&u_k\end{pmatrix}
\begin{pmatrix}p\\q\end{pmatrix}\approx-u_{k+2}.
$$

再解 $\mu^2+p\mu+q=0$，即得共轭根估计 $-p/2\pm i\sqrt{q-p^2/4}$。三向量必须保留相对尺度：可整组同乘一个缩放因子，不能把每个向量独立单位化后直接代入这个递推。

::: ex 用实向量恢复复特征值 {#ex-power-conjugate-pair}
取 $A=\begin{pmatrix}1&-2\\2&1\end{pmatrix}$、$u_0=(1,0)^{\mathrm T}$。有

$$
u_1=(1,2)^{\mathrm T},\qquad u_2=(-3,4)^{\mathrm T}.
$$

两个分量给出 $-3+p+q=0$、$4+2p=0$，所以 $p=-2,q=5$，根为 $1\pm2i$。连续幂向量保留了对应实二维子空间的信息。求出特征值后，还可恢复特征向量：

$$
z_\lambda=u_{k+1}-\bar\lambda u_k,\qquad
z_{\bar\lambda}=u_{k+1}-\lambda u_k.
$$

在主二维子空间内，前一式消去了 $\bar\lambda$ 的分量，故对应 $\lambda$；后一式反之。本例取 $k=0$、$\lambda=1+2i$，得 $z_\lambda=(2i,2)^{\mathrm T}$，直接代入可验证 $Az_\lambda=(1+2i)z_\lambda$。
:::

若模最大的是实根 $r,-r$，递推变为 $u_{k+2}\approx r^2u_k$，对 $r>0$，可从非零分量的隔步比值估计 $r^2$，再用 $u_{k+1}+ru_k$ 提取 $+r$ 的方向，用 $u_{k+1}-ru_k$ 提取 $-r$ 的方向。若还有更多等模主根、缺陷 Jordan 块，或两个列向量近线性相关，这个二阶模型就不足，可转向子空间或 QR 方法。

<a id="sec-3.1.2"></a>
## 3.1.2 反幂法与位移反幂法

::: lem 引理 3.1.2 · 逆矩阵的特征值 {#lem-3.1.2}
设 $A$ 非奇异，$\lambda_i$ 为 $A$ 的特征值，则 $1/\lambda_i$ 是 $A^{-1}$ 的特征值，且特征向量不变；$|\lambda_1|$ 严格最小 $\iff$ $|1/\lambda_1|$ 严格最大。
:::

::: proof 证明
由 $Ax_i=\lambda_ix_i$ 两边左乘 $\lambda_i^{-1}A^{-1}$，得 $\lambda_i^{-1}x_i=A^{-1}x_i$，即 $x_i$ 是 $A^{-1}$ 关于 $1/\lambda_i$ 的特征向量。若 $|\lambda_1|$ 严格最小，则 $\lambda_1\ne0$（$A$ 可逆），且 $|\lambda_1|\lt|\lambda_i|\ (i\ge2)\iff|1/\lambda_1|\gt|1/\lambda_i|$。$\blacksquare$
:::

若 $A$ 非奇异，$A^{-1}$ 的特征值是 $1/\lambda_i$，特征向量不变。因此对 $A^{-1}$ 用幂法，就得到 $A$ 的**模最小**特征值：

$$
A u_k=y_{k-1},\qquad
\beta_k=y_{k-1}^{\mathrm T}u_k\approx\frac{1}{\lambda_n}.
$$

::: note 实际计算：不构造 $A^{-1}$
计算 $u_k=A^{-1}y_{k-1}$ 时，不必先求出 $A^{-1}$，而应解 $Au_k=y_{k-1}$。因为每步的系数矩阵不变，可以只作一次 LU 分解，之后反复前代和回代。对稠密矩阵，每轮三角求解的计算量为 $O(n^2)$；稀疏情形还取决于分解后的非零元分布。
:::

::: cor 推论 3.1.1 · 反幂法的收敛性 {#cor-3.1.1}
沿用本节 $A$ 可对角化的假设，设 $A$ 非奇异，$|\lambda_n|$ 严格小于其余特征值的模，初值在 $x_n$ 方向的展开系数非零。每步令 $\lVert y_{k-1}\rVert_2=1$，解 $Au_k=y_{k-1}$ 并取 $\beta_k=y_{k-1}^{\mathrm T}u_k$，则 $y_{k-1}$ 趋于 $x_n$ 的方向，$\beta_k\to1/\lambda_n$，从而 $\lambda_n\approx1/\beta_k$——**最后必须再取一次倒数逆回去**。
:::

::: proof 证明
对 $A^{-1}$ 应用 [@thm-3.1.1]：$A^{-1}$ 的特征值为 $1/\lambda_i$（[@lem-3.1.2]），模最大者为 $1/\lambda_n$，得方向收敛与 $\beta_k\to1/\lambda_n$。$\blacksquare$
:::

**位移反幂法**：对 $A-pI$ 用反幂法，得到最接近 $p$ 的特征值：

$$
(A-pI)u_k=y_{k-1},\qquad
\lambda\approx p+\frac{1}{\beta_k}.
$$

$p$ 越接近目标特征值，收敛越快；$p$ 恰好等于特征值时，$A-pI$ 奇异，需要特殊处理（或取邻近值）。

::: note 用位移选择邻近特征值
若希望求出靠近某个已知估计值 $p$ 的特征值 $\lambda_k$，可考察 $A-pI$。它的特征值是 $\lambda_i-p$。如果 $p$ 不等于任何特征值，且 $|\lambda_k-p|<|\lambda_i-p|$ 对所有 $i\ne k$ 成立，那么 $\lambda_k-p$ 是移位后模最小的特征值；对 $A-pI$ 使用反幂法，再加回 $p$，就能得到目标特征值的近似值：

$$\lambda_k=(\lambda_k-p)+p.$$

在目标唯一最近且初始分量非零时，方向误差的渐近比率由

$$q(p)=\max_{i\ne k}\frac{|\lambda_k-p|}{|\lambda_i-p|}$$

控制。位移趋近一个孤立目标值时，这个比率趋于零。移位矩阵此时也接近奇异，线性求解要采用可靠的分解并检查原特征对残差；不能仅凭它的条件数大就断言所得特征方向不准。
:::

::: method[core] 三个问题，一个算法
| 目标 | 手段 | 关键变换 |
|:--|:--|:--|
| 模最大的特征值 | **幂法** | 直接用 $A$ |
| 模最小的特征值 | **反幂法** | $A\mapsto A^{-1}$（实际每步解 $Au_{k+1}=y_k$） |
| 最接近已知 $p$ 的特征值 | **位移反幂法** | $A\mapsto A-pI$，再用反幂法，最后 $+p$ |

三种方法都利用幂迭代放大目标方向，只是作用的矩阵不同。
:::

::: ex 例 2 · 反幂法求模最小特征值 {#ex-3.1-textbook2}
仍取例 1 的 $A$，求模最小特征值。反幂法迭代表（节选）：

| $k$ | $u_k^{\mathrm T}$ | $y_k^{\mathrm T}$ | $\beta_k$ |
|:--:|:--|:--|:--:|
| 0 | 1.000000, 1.000000, 1.000000 | 0.577350, 0.577350, 0.577350 | — |
| 1 | -0.032075, -0.070565, -0.012830 | -0.408248, -0.898146, -0.163299 | -0.066667 |
| 2 | 0.068041, 0.084371, 0.032660 | 0.601059, 0.745313, 0.288508 | -0.108889 |
| 3 | -0.055654, -0.092519, -0.029207 | -0.497581, -0.827178, -0.261130 | -0.110833 |
| 4 | 0.060815, 0.086663, 0.029581 | 0.553233, 0.788367, 0.269093 | -0.109671 |
| 7 | -0.059223, -0.089415, -0.029727 | -0.532138, -0.803420, -0.267105 | -0.111289 |
| 20 | 0.059391, 0.089087, 0.029696 | 0.534523, 0.801784, 0.267261 | -0.111111 |

第 20 步 $1/\beta_{20}\approx-9.000002$，趋向 $-9$；对应方向趋于 $(2,3,1)^{\mathrm T}/\sqrt{14}$ 所在直线。负主特征值使符号交替，因此只比较方向，不声称归一化向量逐项收敛到固定符号。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| 主特征值 | 按模严格最大的特征值；实矩阵的主特征值必为实数 | [@def-3.1.1]、[@lem-3.1.1] | [补充篇 2.5](../../supplement/sec25.md) 谱半径 |
| 规范化幂法 | 先单位化 $y_{k-1}=u_{k-1}/\lVert u_{k-1}\rVert$，再乘 $A$ | 3.1.1 [@thm-3.1.1] | — |
| Rayleigh 商 | $R(y)=y^{\mathrm T}Ay/(y^{\mathrm T}y)$；$\lVert y\rVert_2=1$ 时才可省分母 | [@def-3.1.2] | [补充篇 2.5](../../supplement/sec25.md) |
| 收敛速度 | 方向误差受 $(\lvert\lambda_2/\lambda_1\rvert)^k$ 控制 | 3.1.1 思考盒 | — |
| 反幂法 | 对 $A^{-1}$ 用幂法；每步解 $Au_k=y_{k-1}$，不构造逆 | 3.1.2 [@lem-3.1.2]、[@cor-3.1.1] | — |
| 位移反幂法 | 对 $A-pI$ 用反幂法，求最接近 $p$ 的特征值，最后 $+p$ | 3.1.2 | — |
:::

::: think 本节常见错误
1. **混用迭代下标与估计式。** 先乘再单位化、先单位化再乘都可使用；必须确认 Rayleigh 商或分量比所用的是哪一步向量。
2. **用其他范数归一化后，把 $y^{\mathrm T}Ay$ 直接当特征值。** 省略分母只在 2-范数归一化时成立；保留分母的 Rayleigh 商与范数无关（见[无穷范数归一化](#power-infinity-normalization)）。
3. **忽视「严格模最大」前提。** 若干特征值模相同时幂法不保证收敛（$\operatorname{diag}(1,-1)$ 反例：方向在两点间交替、Rayleigh 商恒为 $0$）。
4. **反幂法显式构造 $A^{-1}$。** 每步解 $Au_k=y_{k-1}$；先做一次 LU 分解复用。位移 $p$ 恰好命中特征值时 $A-pI$ 奇异，需特殊处理。
5. **把「模最大」当成「代数最大」。** 习题 3.6：$-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots$ 中模最大的是 $\lambda_1$ 而非 $\lambda_n$；反例 $(-40,-20,1)$ 满足题设，但幂法趋向 $-40$、反幂法趋向 $1$。
:::

<a id="sec-3.1-exercises"></a>
## 习题

::: ex 3.1 · 幂法乘法次数 {#exercise-3.1}
用 $u_k=A^ku_0$ 与逐步 $u_i=Au_{i-1}$ 两种形式产生 $u_k$，各需多少次乘法？
:::

::: sol 参考答案
逐步乘：$k$ 次矩阵-向量乘，每次 $n^2$ 次乘法，共 $kn^2$。先算 $A^k$ 再乘 $u_0$：$A^k$ 需约 $(k-1)n^3$ 次，再加 $n^2$，远贵。实际永远用逐步乘。
:::

::: ex 3.2 · 幂法求主特征值 {#exercise-3.2}
分别对
$$A_1=\begin{pmatrix}2&1\\1&2\end{pmatrix},\qquad A_2=\begin{pmatrix}-2&1\\1&-2\end{pmatrix}$$
作规范化幂法，初始向量取 $(1,0)^{\mathrm T}$。每步按 $2$-范数归一化，用 Rayleigh 商估计特征值；计算到 $\lVert A_i\boldsymbol y-\beta\boldsymbol y\rVert_2\le10^{-4}$。
:::

::: sol 参考答案
$A_1$ 的主特征值为 $3$，方向为 $(1,1)^{\mathrm T}$；$A_2$ 的主特征值为 $-3$，方向为 $(1,-1)^{\mathrm T}$。两例次主特征值与主特征值的模比均为 $1/3$。第二例归一化向量可能正负交替，应以方向和特征对残差判断。
:::

::: ex 3.3 · 商序列收敛 {#exercise-3.3}
设 $u_0$ 在 $x_1$ 方向分量非零，$v^{\mathrm T}x_1\ne0$，证明 $\beta_k=\frac{v^{\mathrm T}A^k u_0}{v^{\mathrm T}A^{k-1}u_0}\to\lambda_1$。
:::

::: sol 参考答案
把 $A^k u_0$ 展开为 $\sum a_j\lambda_j^kx_j$，分子分母同除 $\lambda_1^{k-1}$；由 $|\lambda_j/\lambda_1|\lt1$（$j\ge2$）得极限 $\lambda_1\frac{v^{\mathrm T}x_1}{v^{\mathrm T}x_1}=\lambda_1$。
:::

::: ex 3.4 · 反幂法 {#exercise-3.4}
对第 3.2 题的 $A_1$ 作反幂法，初始向量取 $(1,0)^{\mathrm T}$，每步使用 $2$-范数归一化。求模最小的特征值，并使特征对残差不超过 $10^{-4}$。
:::

::: sol 参考答案
每步解 $A_1\boldsymbol u_k=\boldsymbol y_{k-1}$，再归一化。若用 $\beta_k=\boldsymbol y_{k-1}^{\mathrm T}\boldsymbol u_k$，则 $1/\beta_k$ 趋于 $1$；特征向量方向为 $(1,-1)^{\mathrm T}$。也可将归一化向量代回原矩阵计算 Rayleigh 商，并检查残差。
:::

::: ex 3.5 · 已知近似特征值 {#exercise-3.5}
设 $A=\begin{pmatrix}8&1\\1&9\end{pmatrix}$，已知目标特征值靠近 $9$。取位移 $p=9$，从 $(1,1)^{\mathrm T}$ 开始作位移反幂法。用精确特征值检查计算。
:::

::: sol 参考答案
特征值为 $(17\pm\sqrt5)/2$，其中离 $9$ 最近的是 $(17+\sqrt5)/2\approx9.618034$。每步解 $(A-9I)\boldsymbol u_k=\boldsymbol y_{k-1}$，归一化后估计目标值。对应特征向量可取 $(1,(1+\sqrt5)/2)^{\mathrm T}$。位移矩阵非奇异，且初始向量在目标方向上的分量非零。
:::

::: ex 3.6 · 实特征值的算法选择 {#exercise-3.6}
设 $-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots\le\lambda_n$，分别写出求 $\lambda_1,\lambda_2,\lambda_n$ 的迭代格式。
:::

::: sol 参考答案
这些是**按代数大小**排定的特征值，不能直接把 $\lambda_n$ 当作模最大、把 $\lambda_1$ 当作模最小。反例 $(-40,-20,1)$ 满足题设，但幂法趋向 $-40$，反幂法趋向 $1$。

- 求 $\lambda_1$：对 $A+50I$ 作反幂法。其特征值全正，$\lambda_1+50$ 唯一最小，最后减去 $50$。
- 求 $\lambda_n$：对 $A+50I$ 作幂法；若最大特征值重复，按其主特征子空间解释方向，最后减去 $50$。
- 求 $\lambda_2$：先得到 $\lambda_1$ 并消去其特征方向，在不含该方向的剩余不变子空间上，对 $A+50I$ 作反幂法；或给出能证明离 $\lambda_2$ 唯一最近的位移后作位移反幂法。仅取 $p=-10$ 不够：上例离它最近的是 $1$，不是 $-20$。

上述构造沿用本节可对角化与初值目标分量非零的假设；消去时应使用正确的谱投影（非对称矩阵不能随意用普通正交投影代替）。
:::
