# 3.1 幂法与反幂法

> 对应教材 3.1.1–3.1.2、例 1–2、习题 1–6；对应老师第 6 讲末、第 7 讲 §一–§八。
> 主线：幂法求**模最大**特征值，反幂法求**模最小**特征值，位移反幂法求**最接近 $p$** 的特征值。

::: note 本节多出一节「特征值基础」，来源要说清
下面的「特征值基础」**教材第 3 章没有**（教材从 3.1 幂法直接开始），它是**课件 6 的前 10 页**（p3–p11）的内容。
因为幂法要反复用「模最大」「谱的界」「Rayleigh 商」，不讲这块直接进幂法会断链，所以放在这里作前置。
这部分用于补足幂法先修；课件来自其他班级，不能单凭其出现判定本班考试范围。更完整的谱理论（Courant–Fischer、非正规敏感性）在[补充篇 2.5](../../supplement/sec25.md)。
:::

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
## 特征值基础（课件 6 p3–p11）

这一节把「特征值是什么、有哪些可以直接用的性质、不算特征值能把它圈到哪」一次讲完。**八条定理里有五条在幂法、反幂法、Gerschgorin 估界中会直接用到**，不是背景知识。

::: intuition 直觉 · 特征值在工程里到底是什么
课件的应用清单只有四条，但每一条都是实打实的工程问题：

- **求系统的固有振动频率**——桥梁、机翼、建筑的自振频率，避开驱动频率才不会共振；
- **求机械系统的振动频谱（模态）**——每个特征向量是一个振型；
- **系统的稳定性分析**——动力系统 $\dot{\boldsymbol x}=A\boldsymbol x$ 的稳定性由 $\operatorname{Re}\lambda_i$ 的符号决定；
- **物理学中某些临界值的确定**——临界载荷、临界温度本质上是某个矩阵的最小特征值。
:::

::: def 定义 3.0.1（课件定义 1） · 特征多项式、特征值、特征向量 {#def-3.0.1}
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

$n\ge 5$ 时 $\varphi(\lambda)$ 一般没有根式解（Abel–Ruffini），所以**求特征值只能靠数值方法**——这就是第 3 章存在的理由。
:::

::: ex 例 3.0.1（课件例 1） · 手算一个 $3\times3$ 的特征值与特征向量 {#ex-3.0.1}
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

::: thm 定理 3.0.1（课件定理 1） · 四则运算后特征值怎么变 {#thm-3.0.1}
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

::: thm 定理 3.0.2（课件定理 2） · 特征值与迹、行列式的关系 {#thm-3.0.2}
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

::: thm 定理 3.0.3（课件定理 3） · 转置不改变谱 {#thm-3.0.3}
设 $A\in\mathbb R^{n\times n}$，则 $\lambda(A)=\lambda(A^{\mathrm T})$。
:::

::: proof 证明
$\det(\lambda I-A^{\mathrm T})=\det((\lambda I-A)^{\mathrm T})=\det(\lambda I-A)$——转置不改变行列式，故特征多项式相同，特征值相同。$\blacksquare$

**但特征向量会变**：$A$ 与 $A^{\mathrm T}$ 的特征向量一般不同。这一点在幂法里很要紧——课件提取特征值时用 $\beta_k=\boldsymbol y_{k-1}^{\mathrm T}A\boldsymbol y_{k-1}$，正是利用了「左、右特征向量」的关系。
:::

::: thm 定理 3.0.4（课件定理 4） · 分块上三角的谱是各块谱之并 {#thm-3.0.4}
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
它是 **QR 方法「先拟上三角化」的理论依据**：拟上三角（Hessenberg）矩阵的次对角块非零但上三角块之外的块为零，其特征值可逐块收缩求解。课件把它单列为定理 4，就是要说明「能把矩阵化成上三角，特征值就一眼看出来」。QR 方法的完整内容见[3.3](sec33.md)（课件未覆盖）。
:::

::: thm 定理 3.0.5（课件定理 5） · 相似矩阵同谱，特征向量随之变换 {#thm-3.0.5}
若 $A$ 与 $B$ 为相似矩阵，即存在非奇异 $P$ 使 $P^{-1}AP=B$，则

1. $A$ 与 $B$ 有相同的特征值；
2. 若 $\boldsymbol y$ 是 $B$ 的特征向量，则 $P\boldsymbol y$ 是 $A$ 的特征向量。
:::

::: proof 证明
1. $\det(\lambda I-B)=\det(\lambda I-P^{-1}AP)=\det\bigl(P^{-1}(\lambda I-A)P\bigr)=\det(P^{-1})\det(\lambda I-A)\det(P)=\det(\lambda I-A)$。
2. $B\boldsymbol y=\lambda\boldsymbol y$ 即 $P^{-1}AP\boldsymbol y=\lambda\boldsymbol y$，两边左乘 $P$ 得 $A(P\boldsymbol y)=\lambda(P\boldsymbol y)$。$\blacksquare$
:::

::: note 第 2 条常被漏掉
课件把它写出来了，而补充篇只写了第 1 条。**求特征向量时这一条不可少**：Jacobi 方法和 QR 方法都是「把 $A$ 逐步相似变换到对角/三角」，特征值直接在对角线上读，但**特征向量必须把累积的变换矩阵乘回去**——就是这一条。见 [3.2 Jacobi](sec32.md)。
:::

::: thm 定理 3.0.6（课件定理 6） · 实对称矩阵的正交约化 {#thm-3.0.6}
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

::: def 定义 3.0.2（课件定义 2） · Gerschgorin 圆盘 {#def-3.0.2}
设 $A=(a_{ij})_{n\times n}$，令

$$
r_i=\sum_{j\ne i}\lvert a_{ij}\rvert,\qquad
D_i=\{z:\ \lvert z-a_{ii}\rvert\le r_i,\ z\in\mathbb C\},\quad (i=1,\dots,n),
$$

称 $D_i$ 为复平面上以 $a_{ii}$ 为圆心、以 $r_i$ 为半径的 **Gerschgorin 圆盘**。
:::

::: thm 定理 3.0.7（课件定理 7） · Gerschgorin 圆盘定理 {#thm-3.0.7}
1. 设 $A=(a_{ij})_{n\times n}$，则 $A$ 的每一个特征值必属于下列某个圆盘之中：

$$
\lvert\lambda-a_{ii}\rvert\le\sum_{j\ne i}\lvert a_{ij}\rvert,\qquad (i=1,\dots,n).
$$

2. 如果上述 $n$ 个圆盘中有 $m$ 个圆盘构成一个连通域 $S$，且 $S$ 与其余 $n-m$ 个圆盘**分离**，则 $S$ 中**恰有** $A$ 的 $m$ 个特征值。
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
3. **给特征值近似**：对角占优时圆盘很小，$a_{ii}$ 就是 $\lambda_i$ 的良好近似，误差 $\le r_i$。
:::

::: note 课件多一个技巧：用 $D^{-1}AD$ 缩放圆盘（补充篇没有）
课件 p10 给了一个补充篇没写的关键手法：取非奇异对角阵 $D=\operatorname{diag}(\alpha_1,\dots,\alpha_n)$，则

$$
D^{-1}AD=\Bigl(\frac{a_{ij}\alpha_j}{\alpha_i}\Bigr)_{n\times n}.
$$

由定理 3.0.5，$D^{-1}AD$ 与 $A$ **相似、特征值相同**，但**圆盘的半径与连通性都变了**。适当选 $\alpha_i$ 可以让圆盘收缩、从重叠变成分离，从而把第 2 条（连通域计数）真正用起来。

这是「不做特征值计算就收紧估计」的标准手段，考试常考。
:::

::: ex 例 3.0.2（课件例 2） · 用对角缩放把 Gerschgorin 围栏收紧 {#ex-3.0.2}
估计 $A=\begin{pmatrix}4&1&0\\1&0&-1\\1&1&-4\end{pmatrix}$ 的特征值范围。

**第一步：直接看三个圆盘**（按行）：

$$
\lvert\lambda-4\rvert\le1,\qquad \lvert\lambda-0\rvert\le2,\qquad \lvert\lambda+4\rvert\le2 .
$$

即 $\lambda$ 落在 $[3,5]$、$[-2,2]$、$[-6,-2]$ 三个区间之并。第一个与后两个分离，但后两个在 $[-2,2]$ 与 $[-6,-2]$ 处仅交于一点，判断不够清楚。

**第二步：取 $D=\operatorname{diag}(1,1,\tfrac{10}{9})$ 缩放**。$D^{-1}AD$ 的元素为 $a_{ij}\alpha_j/\alpha_i$：

$$
D^{-1}AD=\begin{pmatrix}
4 & 1 & 0\\
1 & 0 & -\tfrac{10}{9}\\
0.9 & 0.9 & -4
\end{pmatrix}.
$$

**第三步：重看圆盘**：

| 圆盘 | 范围 |
|:--|:--|
| $\lvert\lambda-4\rvert\le1$ | $3\le\lambda_1\le5$ |
| $\lvert\lambda\rvert\le1+\tfrac{10}{9}=\tfrac{19}{9}$ | $-\tfrac{19}{9}\le\lambda_2\le\tfrac{19}{9}$ |
| $\lvert\lambda+4\rvert\le1.8$ | $-5.8\le\lambda_3\le-2.2$ |

现在三个区间两两分离，由定理 3.0.7 第 2 条，**各区间内恰有一个特征值**——这比第一步的结论强得多。

（验算：$A$ 的实际特征值约为 $4.2030,\ -0.4429,\ -3.7601$，确实分别落在三个区间内。）
:::

::: def 定义 3.0.3（课件定义 3） · Rayleigh 商 {#def-3.0.3}
设 $A$ 是 $n$ 阶**实对称**阵，对于任一非零向量 $\boldsymbol x\in\mathbb R^n$，称

$$
R(\boldsymbol x)=\frac{(A\boldsymbol x,\boldsymbol x)}{(\boldsymbol x,\boldsymbol x)}
$$

为关于向量 $\boldsymbol x$ 的**瑞雷（Rayleigh）商**。
:::

::: thm 定理 3.0.8（课件定理 8） · Rayleigh 商的变分性质 {#thm-3.0.8}
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

::: note Rayleigh 商与幂法的接口
幂法在第 $k$ 步用 $\beta_k=\boldsymbol y_{k-1}^{\mathrm T}A\boldsymbol y_{k-1}$ 提取特征值。若 $\lVert\boldsymbol y_{k-1}\rVert_2=1$，这个式子**就是 Rayleigh 商**——所以它必然落在 $[\lambda_n,\lambda_1]$ 内，并且当 $\boldsymbol y_{k-1}$ 接近主特征向量时逼近 $\lambda_1$。这解释了为什么 2-范数归一化下可以省略分母，而用其他范数归一化时不能省（见 [3.1.1](#sec-3.1.1)）。

**符号提醒**：本节用降序（$\lambda_1$ 最大），与课件、第 3 章其余各节一致。[补充篇 2.5.4](../../supplement/sec25.md#thm-sup-2.5.4) 用升序（$\lambda_1$ 最小），读那节时注意换算。
:::

::: think 这一节的常见错误
1. **把 $\lambda_1$ 永远当最大**。第 3 章全章按**模**排序（$\lvert\lambda_1\rvert\gt\lvert\lambda_2\rvert\ge\cdots$），只有实对称情形才有「$\lambda_1$ 是代数最大」的结论。非对称矩阵里模最大的可能是负数，见 [3.1.1](#sec-3.1.1) 的习题反例 $(-40,-20,1)$。
2. **以为 $\lambda(A)=\lambda(A^{\mathrm T})$ 就可以拿 $A^{\mathrm T}$ 的特征向量当 $A$ 的**。特征值相同，特征向量不同。
3. **分了块却忘了分块上三角的前提**。定理 3.0.4 要求**对角块是方阵、且下三角块为零**。一般分块矩阵没有这个结论。
4. **Gerschgorin 只算一半**。只看行圆盘往往不够；课件例 2 的做法是**同时用对角缩放**把圆盘拉开。列圆盘（按列求和）也是同理，两种取交更紧。
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

::: intuition 直觉 · 特征值问题从哪来：能级就是特征值（老师第 6 讲 §九）
求矩阵特征值的算法源头是**定态薛定谔方程**的能级计算：哈密顿算子 = 动能项（$-\frac{\hbar^2}{2m}\nabla^2$，拉普拉斯算子）+ 势能项 $V$。薛定谔自己算出了氢原子；复杂（多粒子）系统必须离散化数值求解：

$$\text{微分算子}\ \xrightarrow{\ \text{离散}\ }\ \text{矩阵},\qquad \text{能级}= \text{特征值},\qquad \text{本征态（波函数）}= \text{特征向量}.$$

多粒子系统维度极高，至今**没有一般性的方法**能高效算出全部特征对；本课程与原书第 3 章只攻一件事：求**按模最大**的特征值及其特征向量——这就是幂法。
:::

::: def 定义 3.1.1 · 主特征值与幂法的前提 {#def-3.1.1}
设 $A$ 有 $n$ 个线性无关的特征向量 $x_1,\dots,x_n$，对应特征值满足

$$|\lambda_1|\gt|\lambda_2|\ge\cdots\ge|\lambda_n|.$$

$\lambda_1$ 称为 $A$ 的**主特征值**（按模最大的特征值），$x_1$ 称为对应的**主特征向量**。幂法还要求初值 $u_0$ 在 $x_1$ 方向的分量 $\alpha_1\ne0$。
:::

课堂用“特征向量互异”提示特征展开。**编者订正**：互异向量不一定线性无关；不同特征值的特征向量才必然线性无关。本节严格采用定义 3.1.1 的完整特征向量基假设，并要求初始展开系数 $\alpha_1\ne0$：

$$u_0=\alpha_1x_1+\alpha_2x_2+\cdots+\alpha_nx_n .$$

由 $Ax_i=\lambda_ix_i$ 得 $A^kx_i=\lambda_i^kx_i$（板书把 $Ax_i=\lambda_ix_i$、$A^kx_i=\lambda_i^kx_i$、$A^nx_i=\lambda_i^nx_i$ 三条并列写出），于是

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

::: proof 证明（老师第 7 讲 §二）
设 $f(\lambda)=\det(\lambda I-A)$ 为特征多项式。$A$ 是实矩阵 $\Rightarrow$ 各系数为实数：$f(\lambda)=a_n\lambda^n+a_{n-1}\lambda^{n-1}+\cdots+a_0$，$a_n,\dots,a_0\in\mathbb R$。反设 $\lambda_1$ 不是实数，即 $\operatorname{Im}\lambda_1\ne0$，则其共轭 $\overline{\lambda_1}\ne\lambda_1$。对 $f(\lambda_1)=0$ 两边取共轭，用两条性质——**乘积的共轭 = 共轭的乘积**、**实数的共轭是自身**——得 $f(\overline{\lambda_1})=0$，即 $\overline{\lambda_1}$ **也是** $A$ 的特征值。而 $|\overline{\lambda_1}|=|\lambda_1|$ 且 $\overline{\lambda_1}\ne\lambda_1$，出现**两个**模相等的最大特征值，与「严格最大」矛盾。故 $\lambda_1\in\mathbb R$。$\blacksquare$
:::

::: note 课上的一处停顿（老师第 7 讲 §二）
共轭的乘积性质（$\overline{z_1z_2}=\overline{z_1}\,\overline{z_2}$）老师原本以为人人都知道：「我跟上个班讲，他们好像不知道这个性质啊——我记得这个性质应该是高中就学的。」这条结论的实际意义：$\lambda_1$ 是实数，故 $\lambda_1^k$ 只会单调增长或正负交替，不会出现复数旋转；后面的极限分析只需分 $\lambda_1\gt0$ 与 $\lambda_1\lt0$ 两种情形。
:::

::: intuition 直觉 · 两个障碍与「单位化」的动机（老师第 7 讲 §一、§三）
展开式里其他特征分量只是**占比**在缩小，「并没有起到把其他那些组分消除掉的作用」，其绝对数值仍然不小；而且整个括号还被 $\lambda_1^k$ 乘着——$|\lambda_1|$ 大时会**溢出**，$|\lambda_1|\lt1$ 时反方向**下溢**。「现在我们要设计一种算法……把其他这些组分真正滤掉，把前面的 $\alpha_1$ 也算出来，**并且不出现增长很快的情况**。」最直观的办法：每算一步就把迭代向量拉回单位长度——范数取哪一种都行（齐次性 $\lVert u/\lVert u\rVert\rVert=1$；所有向量范数等价，长度归一后量级永远受控）。
:::

::: method[core] 算法 · 规范化幂法（教材式 3.4/3.7）
$$
y_{k-1}=\frac{u_{k-1}}{\lVert u_{k-1}\rVert_2},\qquad
u_k=A y_{k-1},\qquad
\beta_k=y_{k-1}^{\mathrm T}u_k.
$$

$\beta_k\to\lambda_1$，$y_{k-1}$ 趋于主特征向量的**方向**；主特征值为负时归一化向量通常正负交替，不能声称向量本身有固定极限。注意 $u_k=Ay_{k-1}$，故 $\beta_k=y_{k-1}^{\mathrm T}Ay_{k-1}$——在 2-范数归一化（$\lVert y_{k-1}\rVert_2=1$）下，$\beta_k$ 正是 $y_{k-1}$ 处的 Rayleigh 商（[@def-3.1.2]）。
:::

::: note 老师强调的顺序：先单位化，再乘 $A$（老师第 7 讲 §四）
「你要记住是**先单位化**，单位化之后的那个东西我再给它乘 $A$，而不是直接就往上乘 $A$。」直接累乘 $A$ 就是会溢出的版本；本算法每乘一次 $A$ 就立刻把结果拉回单位长度，「它就不会长得太快」。板书写法 $y_k=u_k/\lVert u_k\rVert$、$u_k=Ay_{k-1}$ 与算法框是同一个递推，只是下标起点不同。每一步「先乘再归一化」也能控制尺度；两种写法只是在索引和特征值估计的配对上不同，应保持公式一致。
:::

::: note 归一化的副产品（老师第 7 讲 §四）
每步单位化使归一化向量 $y_k$ 留在单位球面上；未归一化量 $u_{k+1}=Ay_k$ 的量级还受 $A$ 的范数影响，仍须注意乘法的有限范围——这是幂法能在有限精度下长期迭代的前提。
:::

::: thm 定理 · 幂法的收敛性 {#thm-3.1.1}
设 $A$ 为实矩阵，特征值满足 $|\lambda_1|\gt|\lambda_2|\ge\cdots\ge|\lambda_n|$（由 [@lem-3.1.1]，$\lambda_1$ 为实数），$x_1,\dots,x_n$ 线性无关。任取非零 $u_0=\sum_{i=1}^n\alpha_ix_i$ 且 $\alpha_1\ne0$，按规范化幂法迭代，则

$$\text{(i)}\quad y_{k-1}\to\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ (\lambda_1\gt0),\qquad
(-1)^{k-1}y_{k-1}\to\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ (\lambda_1\lt0);$$

$$\text{(ii)}\quad \text{取 2-范数归一化时}\quad \beta_k=y_{k-1}^{\mathrm T}u_k\to\lambda_1 .$$

$\lambda_1\lt0$ 时迭代值不断变号，「但说白了，它还是你的特征向量，只不过在迭代过程中符号一直在变来变去」——只保证**方向**收敛。
:::

::: proof 证明（老师第 7 讲 §四–§六 板书推导）
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

::: note 为什么算特征值必须取 2-范数（老师第 7 讲 §五）
计算**特征向量**时范数任取；一旦要算**特征值**，范数就进了公式。取 2-范数时 $y_k^{\mathrm T}y_k=\lVert y_k\rVert_2^2=1$，比值化简得干净——内积就是欧氏长度的平方：三维例子最直观，$f_1=(x,y,z)$ 有 $f_1\cdot f_1=x^2+y^2+z^2=\lVert f_1\rVert_2^2$，一般地 $x_1^{\mathrm T}x_1=\lVert x_1\rVert_2^2$，于是 [@thm-3.1.1] (ii) 的证明里分子分母完全相同。若取 $\infty$-范数，「你算出来的东西就稍微有一点变化」——省略分母的估计式要另作调整（见下方留白作业）。老师把黑板分成两区来写：最上面那一片是「只求特征向量」，下面那一片才是「求特征值」。
:::

::: note 核验补注 · Rayleigh 商的适用条件（老师口径 vs 标准术语）
课堂中的「算特征值必须取 2-范数」专指**省略分母**的 $y^{\mathrm T}Ay$ 写法。一般的 Rayleigh 商是 $y^{\mathrm T}Ay/(y^{\mathrm T}y)$，对任意非零 $y$ 都可用，与采用哪种范数归一化无关；仅当 $\lVert y\rVert_2=1$ 才可省略分母。不能把课堂简写当成对其他提取方式的否定。主特征值为负时，归一化向量还可能正负交替，应说方向收敛。
:::

::: think 收敛速度与边界
在严格主特征值和非零主分量假设下，方向误差受 $|\lambda_2/\lambda_1|^k$ 控制。若若干特征值仅仅**模相同**，不能保证幂法方向或 Rayleigh 商收敛到其中一个特征值。例如 $A=\operatorname{diag}(1,-1)$、$u_0=(1,1)^{\mathrm T}$ 使方向在两点间交替，而 Rayleigh 商恒为 $0$，不是 $A$ 的特征值。若主特征值为同一个重复值、其余特征值严格较小，才可在初值主子空间分量非零时讨论趋于该特征子空间的方向。
:::

::: ex 例 1（教材 3.1.1） · 幂法求主特征值与特征向量 {#ex-3.1-textbook1}
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

::: think 留白作业 · $\infty$-范数下怎么提取特征值（老师第 7 讲 §五、§六）
老师把 $\infty$-范数的特征值提取留给同学自行验算（板书第三行）。两条思路：

1. **保留分母**：$R(y)=y^{\mathrm T}Ay/(y^{\mathrm T}y)$ 对任意非零 $y$ 都成立，与归一化用的范数无关——这正是上面「核验补注」的标准口径；
2. **坚持省略分母**：取 $|(y_k)_i|=1$ 的分量 $i$，用比值 $(Ay_k)_i/(y_k)_i$ 估计 $\lambda_1$（$y_k$ 与 $Ay_k$ 的 $(-1)^k$ 在比值中相消）。但该分量若与另一分量接近并列，比值不如 Rayleigh 商稳健——这正是 2-范数 Rayleigh 商成为标准做法的原因。
:::

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

::: note 实际计算：不构造 $A^{-1}$（老师第 7 讲 §七）
「我们并不知道 $A$ 逆，我们只知道 $A$。」把 $u_k=A^{-1}y_{k-1}$ 改写成**解线性方程组** $A u_k=y_{k-1}$，每步解一次——板书在算法大括号下面又单独框出了这个方程，是这一节最要紧的一行。求解「采用我们以前讲的各种方法：不管是迭代法、LU 分解法还是高斯消去法」（第 3、4 讲的直接法在此汇合）。工程上先对 $A$（或 $A-pI$）做**一次** LU 分解，之后每步只做前代/回代，$O(n^2)$（稀疏时更低）。
:::

::: cor 推论 3.1.1 · 反幂法的收敛性 {#cor-3.1.1}
设 $A$ 非奇异，$|\lambda_n|$ 严格小于其余特征值的模，初值在 $x_n$ 方向分量非零，则反幂法迭代收敛：$y_{k-1}$ 趋于 $x_n$ 的方向，$\beta_k\to1/\lambda_n$，从而 $\lambda_n\approx1/\beta_k$——**最后必须再取一次倒数逆回去**。
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

::: note 位移的动机：能级与「足够近」的近似 $p$（老师第 7 讲 §八）
物理背景：$A$ 是对称正定（自伴算子离散化）的实矩阵时，特征值就是可观测的能级，按大小排开 $\lambda_1\le\lambda_2\le\cdots\le\lambda_n$。想知道第 $k$ 个能级 $\lambda_k$，但解析/半解析方法（如渐近展开）只能得到**近似值** $p$，满足 $|\lambda_k-p|\lt|\lambda_i-p|\ (\forall i\neq k)$。「我虽然没办法把 $\lambda_k$ 真实地算出来，但是我可以算出一个和它足够接近的特征根。」把 $A$ 换成 $\tilde A=A-pI$ 后，其特征值为 $\lambda_i-p$，其中 $|\lambda_k-p|$ **最小**——「是不是就转化为我来求一个最小的特征值？把最小的特征值求出来，我再给它加个 $p$，就是我要的那个 $\lambda_k$」。老师把这一步称为**位移法**（标准术语：原点位移 / 位移反幂法，shifted inverse iteration）：

$$\lambda_k=(\lambda_k-p)+p.$$

$p$ 越接近目标特征值，$A-pI$ 越接近奇异、收敛越快，但解的线性方程组也越病态——速度与稳定性是一对矛盾，实用中取「足够近但不必相等」（参见习题 3.5 的提示）。
:::

::: method[core] 三个问题，一个算法（老师第 7 讲 §八 板书收束）
| 目标 | 手段 | 关键变换 |
|:--|:--|:--|
| 模最大的特征值 | **幂法** | 直接用 $A$ |
| 模最小的特征值 | **反幂法** | $A\mapsto A^{-1}$（实际每步解 $Au_{k+1}=y_k$） |
| 最接近已知 $p$ 的特征值 | **位移反幂法** | $A\mapsto A-pI$，再用反幂法，最后 $+p$ |

「说白了就是：第一种你学会之后，后边这个东西你可以转化成第一种就 OK 了——想办法给它转变成第一种。」
:::

::: ex 例 2（教材 3.1.2） · 反幂法求模最小特征值 {#ex-3.1-textbook2}
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

::: note 课堂口述与标准术语对照（老师第 7 讲 §十三，节选）
| 课堂口述/转写 | 标准术语 |
|:--|:--|
| 秘法 / 密法 / 迷法 | 幂法（power method） |
| 反秘法 | 反幂法（inverse power method） |
| 贵宜法 / 被激动 | 位移法（原点位移，shift） |
| 幽灵 / $u_0$ | 初始向量 $u_0$ |
| 外退 / 外配 / YP | $y_k$ |
| 蓝白衣 / 郎大一 / 拉姆达 | $\lambda_1$ / $\lambda_k$ |
| 特征项链 / 特征效量 | 特征向量 |
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
2. **用其他范数归一化后，把 $y^{\mathrm T}Ay$ 直接当特征值。** 省略分母只在 2-范数归一化时成立；保留分母的 Rayleigh 商与范数无关（见「核验补注」）。
3. **忽视「严格模最大」前提。** 若干特征值模相同时幂法不保证收敛（$\operatorname{diag}(1,-1)$ 反例：方向在两点间交替、Rayleigh 商恒为 $0$）。
4. **反幂法显式构造 $A^{-1}$。** 每步解 $Au_k=y_{k-1}$；先做一次 LU 分解复用。位移 $p$ 恰好命中特征值时 $A-pI$ 奇异，需特殊处理。
5. **把「模最大」当成「代数最大」。** 习题 3.6：$-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots$ 中模最大的是 $\lambda_1$ 而非 $\lambda_n$；反例 $(-40,-20,1)$ 满足题设，但幂法趋向 $-40$、反幂法趋向 $1$。
:::

<a id="sec-3.1-exercises"></a>
## 习题（教材习题 1–6）

::: ex 3.1 · 幂法乘法次数（教材习题 1）
用 $u_k=A^ku_0$ 与逐步 $u_i=Au_{i-1}$ 两种形式产生 $u_k$，各需多少次乘法？
:::

::: sol 参考答案
逐步乘：$k$ 次矩阵-向量乘，每次 $n^2$ 次乘法，共 $kn^2$。先算 $A^k$ 再乘 $u_0$：$A^k$ 需约 $(k-1)n^3$ 次，再加 $n^2$，远贵。实际永远用逐步乘。
:::

::: ex 3.2 · 幂法求主特征值（教材习题 2）
用幂法求教材习题 2 中两个矩阵的按模最大特征值与特征向量，要求 $|\beta_k-\beta_{k-1}|/|\beta_k|\le10^{-4}$。
:::

::: sol 参考答案
按规范化幂法迭代，直到相邻 $\beta$ 的相对差小于 $10^{-4}$；$\beta_k$ 收敛到 $\lambda_1$，$y_{k-1}$ 收敛到特征向量方向。具体数值用 NumPy/Python 复算，保留四位。
:::

::: ex 3.3 · 商序列收敛（教材习题 3）
设 $u_0$ 在 $x_1$ 方向分量非零，$v^{\mathrm T}x_1\ne0$，证明 $\beta_k=\frac{v^{\mathrm T}A^k u_0}{v^{\mathrm T}A^{k-1}u_0}\to\lambda_1$。
:::

::: sol 参考答案
把 $A^k u_0$ 展开为 $\sum a_j\lambda_j^kx_j$，分子分母同除 $\lambda_1^{k-1}$；由 $|\lambda_j/\lambda_1|\lt1$（$j\ge2$）得极限 $\lambda_1\frac{v^{\mathrm T}x_1}{v^{\mathrm T}x_1}=\lambda_1$。
:::

::: ex 3.4 · 反幂法（教材习题 4）
用反幂法求第 2 题 (1) 的矩阵按模最小的特征值与特征向量，要求相对差 $\le10^{-4}$。
:::

::: sol 参考答案
对 $A$ 做 LU 分解；每步解 $Au_k=y_{k-1}$，$\beta_k=y_{k-1}^{\mathrm T}u_k$，$\lambda_n\approx1/\beta_k$。不要构造 $A^{-1}$。
:::

::: ex 3.5 · 已知近似特征值（教材习题 5）
已知 $A$ 的一个特征值 $\lambda\approx9$，用反幂法精修 $\lambda$ 与特征向量。
:::

::: sol 参考答案
取位移 $p=9$，对 $A-pI$ 做反幂法；$\lambda\approx p+1/\beta_k$。若 $A-pI$ 近似奇异，迭代会很快收敛，但要注意分解的数值稳定性。
:::

::: ex 3.6 · 实特征值的算法选择（教材习题 6）
设 $-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots\le\lambda_n$，分别写出求 $\lambda_1,\lambda_2,\lambda_n$ 的迭代格式。
:::

::: sol 参考答案
这些是**按代数大小**排定的特征值，不能直接把 $\lambda_n$ 当作模最大、把 $\lambda_1$ 当作模最小。反例 $(-40,-20,1)$ 满足题设，但幂法趋向 $-40$，反幂法趋向 $1$。

- 求 $\lambda_1$：对 $A+50I$ 作反幂法。其特征值全正，$\lambda_1+50$ 唯一最小，最后减去 $50$。
- 求 $\lambda_n$：对 $A+50I$ 作幂法；若最大特征值重复，按其主特征子空间解释方向，最后减去 $50$。
- 求 $\lambda_2$：先得到 $\lambda_1$ 并消去其特征方向，在不含该方向的剩余不变子空间上，对 $A+50I$ 作反幂法；或给出能证明离 $\lambda_2$ 唯一最近的位移后作位移反幂法。仅取 $p=-10$ 不够：上例离它最近的是 $1$，不是 $-20$。

上述构造沿用本节可对角化与初值目标分量非零的假设；消去时应使用正确的谱投影（非对称矩阵不能随意用普通正交投影代替）。
:::

::: note 覆盖核对
本节覆盖教材 3.1.1–3.1.2、例 1–2、习题 1–6；老师第 6 讲末（特征值问题开篇）、第 7 讲 §一–§八（含主特征值为实数的证明、回推推导、2-范数提取特征值、Rayleigh 商适用条件核验、反幂法不构造逆、位移动机、三个问题一个算法、口述术语对照与 $\infty$-范数留白作业）。下一节：[3.2 Jacobi 方法](sec32.md)。
:::
