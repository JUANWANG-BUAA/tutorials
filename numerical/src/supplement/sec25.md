# 2.5 特征值、谱半径与对称谱理论

> **本节属“补充篇 · 数值线性代数工具箱”**：2.x 是补充篇内部编号，不是课堂第 2 章的节号。课堂第 2 章是[线性方程组的解法](../course/ch02/overview.md)。

前四节把矩阵当作算子、方程组与投影工具，本节转向谱，即特征值集合。条件数描述解对数据的敏感性，迭代矩阵的谱半径描述误差是否最终衰减；二者不能互相替代。路线是谱半径与范数上界、Gerschgorin 圆盘、对称矩阵的 Rayleigh 商与变分原理，最后比较对称与缺陷非正规矩阵的扰动行为。

::: note 符号约定（与第 3 章的差别，务必看清）
**本节 $\lambda_1\le\lambda_2\le\cdots\le\lambda_n$（升序）**——因为 Rayleigh 商、Courant–Fischer、Weyl 不等式的标准写法都从这里出发，$\lambda_1$ 是**最小**、$\lambda_n$ 是**最大**。
**第 3 章与课件用降序** $\lvert\lambda_1\rvert\gt\lvert\lambda_2\rvert\ge\cdots\ge\lvert\lambda_n\rvert$，那里 $\lambda_1$ 是**模最大**（幂法求的那个）。
两处约定不可混用：本节对称谱理论中 $\lambda_1=\min R(\boldsymbol x)$；幂法部分另按模降序编号，$\lambda_1$ 是主特征值。第 3 章的对应内容见 [3.1 幂法](../course/ch03/sec31.md)。
:::

<a id="sup-2.5.1"></a>

## 2.5.1 特征值、谱与谱半径

::: intuition 直觉 · 特征向量 = 「只被拉伸不被转向」的方向
矩阵乘在一个向量上，一般既会把它拉长，也会把它转向。但有些特殊方向上，**矩阵只拉长、不转向**——这些方向就是特征向量，拉长的倍数就是特征值：

$$A\boldsymbol{v}=\lambda\boldsymbol{v},\qquad \boldsymbol{v}\neq\boldsymbol{0}.$$

$\lambda$ 可以为负或零；实矩阵还可有复特征值，此时特征向量在复空间中，“方向不变”应理解为复数倍关系，不能当成实平面内只拉伸。谱给出行列式 $\prod_i\lambda_i$、迹 $\sum_i\lambda_i$、可逆性及定常迭代的渐近收敛判据，但不能单独刻画非正规矩阵的有限步放大。谱中最常用的一个数是谱半径 $\rho(A)=\max_i|\lambda_i|$。
:::

::: def 定义 2.5.1 · 特征值、谱与谱半径 {#def-sup-2.5.1}
设 $A\in\mathbb{R}^{n\times n}$。若存在 $\lambda\in\mathbb{C}$ 与非零向量 $\boldsymbol{v}\in\mathbb{C}^n$ 使

$$A\boldsymbol{v}=\lambda\boldsymbol{v} \tag{2.25}$$

则称 $\lambda$ 为 $A$ 的**特征值**（eigenvalue），$\boldsymbol{v}$ 为对应的**特征向量**（eigenvector）。$A$ 的全部特征值（含代数重数）构成 $A$ 的**谱**（spectrum），记 $\sigma(A)$（注意与奇异值 $\sigma_i$ 区分）。**谱半径**（spectral radius）定义为

$$\rho(A)=\max_{\lambda\in\sigma(A)}\lvert\lambda\rvert . \tag{2.26}$$

$\lambda$ 是特征值 $\iff$ $\det(A-\lambda I)=0$（**特征多项式**为 0）。
:::

本节称实方阵 $A$ 为**正规矩阵**（normal matrix），若 $A^{\mathrm T}A=AA^{\mathrm T}$；对复矩阵须把转置换成共轭转置。对称阵与正交阵都是正规阵，但一般非对称阵未必非正规。下面的 Jordan 块既非正规又不可对角化；不能把它的开方敏感性推广到所有非对称矩阵。

::: thm 定理 2.5.1（新增） · 基本性质 {#thm-sup-2.5.1}
设 $A\in\mathbb{R}^{n\times n}$，$\lambda_1,\dots,\lambda_n$（含重数）为它的特征值，则

1. $\operatorname{tr}A=\sum_{i=1}^n\lambda_i$，$\det A=\prod_{i=1}^n\lambda_i$；
2. $\sigma(A^{\mathrm T})=\sigma(A)$（转置不改变特征值；但特征向量一般不同）；
3. 若 $A$ 可逆，则 $\sigma(A^{-1})=\{1/\lambda:\lambda\in\sigma(A)\}$；
4. $\sigma(A^m)=\{\lambda^m:\lambda\in\sigma(A)\}$；
5. 若 $A$ 对称，则全部特征值为**实数**，且存在**正交**矩阵 $V$ 使 $V^{\mathrm T}AV=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$；
6. 若 $A$ 相似于 $B$（$B=P^{-1}AP$），则 $\sigma(B)=\sigma(A)$。

::: proof 证明
**1：** $A$ 的特征多项式 $p(\lambda)=\det(A-\lambda I)=(-1)^n(\lambda-\lambda_1)\cdots(\lambda-\lambda_n)$。比较两边 $\lambda^{n-1}$ 的系数得 $\operatorname{tr}A=\sum\lambda_i$（因为 $\det(A-\lambda I)$ 展开中 $\lambda^{n-1}$ 项来自「取对角元 $a_{ii}-\lambda$、其余取常数项」），取 $\lambda=0$ 得 $\det A=\prod\lambda_i$。

**2、3、4：** $\det(A^{\mathrm T}-\lambda I)=\det(A-\lambda I)$，故转置不改变特征值；可逆时 $A\boldsymbol v=\lambda\boldsymbol v$ 蕴含 $A^{-1}\boldsymbol v=\lambda^{-1}\boldsymbol v$。矩阵幂的结论对三角化后的对角元取幂即得，也计入重数。

**5：** 见 [1.3.4](../ch01/sec13.md#sec-1.3.4) 已用到的谱定理；完整证明见[习题 B2](exercises.md)（要点：实对称矩阵的任一特征值必为实数——在 $A\boldsymbol{v}=\lambda\boldsymbol{v}$ 两边左乘 $\overline{\boldsymbol{v}}^{\mathrm T}$ 得 $\lambda\lVert\boldsymbol{v}\rVert^2=\overline{\boldsymbol{v}}^{\mathrm T}A\boldsymbol{v}$，其共轭转置给出 $\overline{\lambda}\lVert\boldsymbol{v}\rVert^2=\boldsymbol{v}^{\mathrm T}A^{\mathrm T}\overline{\boldsymbol{v}}$，由 $A=A^{\mathrm T}$ 得 $\lambda=\overline{\lambda}$）。

**6：** $\det(B-\lambda I)=\det(P^{-1}AP-\lambda I)=\det(P^{-1}(A-\lambda I)P)=\det(A-\lambda I)$。
:::

:::

::: note 三者关系：$\rho(A)\le\lVert A\rVert$
由定义立刻可得：$\rho(A)\le\lVert A\rVert$ 对**任何**相容矩阵范数都成立。严格说明如下：取任意特征值 $\lambda$ 与它对应的特征向量 $\boldsymbol{v}$，
$$\lvert\lambda\rvert\lVert\boldsymbol{v}\rVert=\lVert\lambda\boldsymbol{v}\rVert=\lVert A\boldsymbol{v}\rVert\le\lVert A\rVert\lVert\boldsymbol{v}\rVert\ \Longrightarrow\ \lvert\lambda\rvert\le\lVert A\rVert,$$
两边同除以 $\lVert\boldsymbol{v}\rVert\gt0$、再对 $\lambda$ 取最大即得。**这条不等式是「用范数估算收敛速度」的理论基础**（[第五章](../ch01/sec11.md#roadmap)的迭代法分析就从它起步）。反过来一般不成立：Jordan 块 $A=\begin{pmatrix}1&1000\\0&1\end{pmatrix}$ 的 $\rho(A)=1$，而 $\lVert A\rVert_2\approx1000$——**谱半径可以远小于范数**，这正是非正规矩阵「谱与范数对不上账」的根源。
:::

::: ex 例 2.5.1（新增） · $\rho\le\lVert A\rVert$ 的数值核对 {#ex-sup-2.5.1}
取三个随机 $4\times4$ 矩阵，把 $\rho(A)$ 与各个范数逐一比较。

::: proof 解
```python
import numpy as np
rng = np.random.default_rng(1)
for _ in range(3):
    M = rng.normal(size=(4, 4))
    print(f"rho={max(abs(np.linalg.eigvals(M))):.4f}  "
          f"||A||2={np.linalg.norm(M,2):.4f}  ||A||inf={np.linalg.norm(M,np.inf):.4f}  "
          f"||A||1={np.linalg.norm(M,1):.4f}  ||A||F={np.linalg.norm(M,'fro'):.4f}")
```

```text
rho=1.6564  ||A||2=1.8582  ||A||inf=2.8008  ||A||1=3.0298  ||A||F=2.4343
rho=1.8239  ||A||2=3.3748  ||A||inf=5.1971  ||A||1=4.3686  ||A||F=4.5245
rho=1.3385  ||A||2=2.8698  ||A||inf=3.7301  ||A||1=4.4696  ||A||F=3.3676
```

三行里 $\rho(A)$ 都严格小于每一个范数，而且 $\rho(A)\le\lVert A\rVert_2\le\lVert A\rVert_F$ 与 $\lVert A\rVert_2\le\sqrt{\lVert A\rVert_1\lVert A\rVert_\infty}$ 也都成立（[习题 B6](../ch01/exercises.md) 已证）✓。

**怎样便宜地判断收敛？** 若只需充分条件，可先计算最大行和或最大列和：任一个小于 1，就有 $\rho(A)<1$。2-范数也能提供这样的判据，但精确计算通常需 SVD，并不总比求特征值便宜；幂法也可用于估计主特征值，不能说谱半径必须先求出全部特征值。
:::

:::

**谱半径为什么出现在迭代里？** 对定常迭代 $x^{(k+1)}=Hx^{(k)}+c$，若 $x^*$ 为不动点，则 $e^{(k+1)}=He^{(k)}$，所以 $e^{(k)}=H^ke^{(0)}$。对任意初值收敛等价于 $H^k\to0$，又等价于 $\rho(H)<1$。必要性来自特征方向：若 $|\lambda|\ge1$，该方向不衰减。充分性可看每个 Jordan 块：$(\lambda I+N)^k=\sum_{j=0}^{s-1}\binom{k}{j}\lambda^{k-j}N^j$；当 $|\lambda|<1$，指数衰减最终压过有限次多项式因子，$\lambda=0$ 的块则在有限步后为零。因此谱半径控制渐近行为，却不保证每步范数下降。

<a id="sup-2.5.2"></a>

## 2.5.2 Gerschgorin 圆盘定理：不算特征值也能定位它们

::: intuition 直觉 · 每个特征值被「困在一个圆盘里」
特征值满足 $\det(A-\lambda I)=0$。能不能把这个条件翻译成一句更直观的话——「$\lambda$ 不会离对角元 $a_{ii}$ 太远」？能。把方程 $A\boldsymbol{v}=\lambda\boldsymbol{v}$ 改写成 $(A-\lambda I)\boldsymbol{v}=\boldsymbol{0}$，挑出 $\boldsymbol{v}$ 中**绝对值最大的那个分量** $v_k$，只看第 $k$ 个方程，两边再同除以 $v_k$，就得到

$$(\lambda-a_{kk})v_k=\sum_{j\neq k}a_{kj}v_j .$$

由于 $\lvert v_j/v_k\rvert\le1$，右端的绝对值不超过 $\sum_{j\neq k}\lvert a_{kj}\rvert$。于是

$$\lvert\lambda-a_{kk}\rvert\le\sum_{j\neq k}\lvert a_{kj}\rvert=:\text{第 }k\text{ 行的「非对角绝对值和」}.$$

**于是每个特征值都被某个这样的圆盘困住。** 这条定理的妙处在于：几乎不花计算量——只要把矩阵读一遍——就能得到特征值的**可靠围栏**。工程上常用它快速判断「有没有零特征值」「是不是全在左半平面」。
:::

::: thm 定理 2.5.2（原书结论，此处给出证明） · Gerschgorin 圆盘定理 {#thm-sup-2.5.2}
设 $A=[a_{ij}]\in\mathbb{R}^{n\times n}$，定义 $n$ 个**Gerschgorin 圆盘**

$$D_i=\Bigl\{z\in\mathbb{C}:\lvert z-a_{ii}\rvert\le r_i\Bigr\},\qquad
r_i=\sum_{j\neq i}\lvert a_{ij}\rvert\qquad(i=1,\dots,n),$$

（$r_i$ 是**第 $i$ 行的非对角绝对值和**），则

1. **（包含性）** $A$ 的全部特征值都包含在 $\bigcup_{i=1}^nD_i$ 中；
2. **（连通性）** 若这 $n$ 个圆盘中有 $k$ 个构成一个与其他圆盘不相交的**连通区域**，则该区域中恰好含有 $A$ 的 $k$ 个特征值（重数计）。
3. **（列版本）** 把 $r_i$ 换成**列**的非对角绝对值和 $\sum_{j\neq i}\lvert a_{ji}\rvert$（即对 $A^{\mathrm T}$ 用上述结论），结论同样成立；两个版本的**交集**可用来收紧围栏。

::: proof 证明
**（1）** 设 $\lambda$ 是 $A$ 的特征值，$\boldsymbol{v}\neq\boldsymbol{0}$ 满足 $A\boldsymbol{v}=\lambda\boldsymbol{v}$，即对每个 $i$，

$$\sum_{j=1}^{n}a_{ij}v_j=\lambda v_i\qquad\Longrightarrow\qquad
(\lambda-a_{ii})v_i=\sum_{j\neq i}a_{ij}v_j . \tag{2.27}$$

取 $k$ 使 $\lvert v_k\rvert=\max_j\lvert v_j\rvert\gt0$。看（2.27）在 $i=k$ 的情形，两边取绝对值：

$$\lvert\lambda-a_{kk}\rvert\,\lvert v_k\rvert=\Bigl\lvert\sum_{j\neq k}a_{kj}v_j\Bigr\rvert\le\sum_{j\neq k}\lvert a_{kj}\rvert\,\lvert v_j\rvert\le\Bigl(\sum_{j\neq k}\lvert a_{kj}\rvert\Bigr)\lvert v_k\rvert .$$

约去 $\lvert v_k\rvert\gt0$，得 $\lvert\lambda-a_{kk}\rvert\le r_k$，即 $\lambda\in D_k$。

**（2）** 这是圆盘定理的「加强版」，标准证法用连续性。考虑 $A_t=D+t(A-D)$（$D=\operatorname{diag}(a_{ii})$ 是对角部分）。$A_0=D$ 的特征值就是各个 $a_{ii}$，即第 $i$ 个圆盘的**圆心**；$A_1=A$ 的特征值按（1）落在各圆盘内。$t$ 从 $0$ 连续增加到 $1$ 时，特征值也随 $t$ 连续变化（特征值是特征多项式系数的连续函数，而多项式的根对系数连续）。既然某个连通区域与其他圆盘不相交，特征值在连续移动中就没有办法跳过中间的空白地带，因此进入该区域的特征值个数始终不变——而 $t=0$ 时该区域恰好含 $k$ 个圆心，也就是 $k$ 个特征值。所以 $t=1$ 时它仍含 $k$ 个。

**（3）** 对 $A^{\mathrm T}$ 应用（1）。$A^{\mathrm T}$ 与 $A$ 有相同的特征值（[@thm-sup-2.5.1] 第 2 条），故结论对「列和」也成立。两个版本同时成立时，取交集即可。
:::

:::

::: method Gerschgorin 的三种用法

1. **判断可逆性 / 是否有零特征值。** 若所有圆盘都不含原点（$0\notin\bigcup D_i$），则 $A$ 没有零特征值，因而非奇异。判断「不含原点」最常用的充分条件是**严格对角占优**（strictly diagonally dominant）：若 $\lvert a_{ii}\rvert\gt r_i$ 对每一行都成立，每个圆盘就都以对角元为中心、半径小于到原点的距离，于是 $0\notin\bigcup D_i$——**[第五章](../ch01/sec11.md#roadmap)迭代法（Jacobi、Gauss–Seidel）的收敛性判据就建立在这条之上**。
2. **判断特征值是否全在左半平面。** 若所有圆盘都落在左半平面（$\operatorname{Re}a_{ii}+r_i\lt0$），则全部特征值的实部为负——这是**动力系统 / 控制理论的稳定性判据**。
3. **给出特征值的近似。** 对角元占优时圆盘很小，$a_{ii}$ 就是 $\lambda_i$ 的良好近似（误差 $\le r_i$）。这是「对角元是特征值的粗糙近似」的定量版本。
:::

::: ex 例 2.5.2（新增） · 用 Gerschgorin 圆盘围出特征值 {#ex-sup-2.5.2}
对

$$A=\begin{pmatrix}10&-1&2\\0&4&1\\-2&1&5\end{pmatrix}$$

写出全部 Gerschgorin 圆盘，用行列两个版本收紧围栏，并判断 $A$ 是否非奇异。

::: proof 解
**行圆盘：**

| $i$ | 中心 $a_{ii}$ | 半径 $r_i$（该行非对角绝对值和） | 区间（实轴上） |
|:--:|:--:|:--:|:--|
| 1 | $10$ | $\lvert-1\rvert+\lvert2\rvert=3$ | $[7,\ 13]$ |
| 2 | $4$ | $0+\lvert1\rvert=1$ | $[3,\ 5]$ |
| 3 | $5$ | $\lvert-2\rvert+\lvert1\rvert=3$ | $[2,\ 8]$ |

**列圆盘：** 半径换成「该列非对角绝对值和」——以第 3 列为例，整列绝对值和 $\lvert2\rvert+\lvert1\rvert+\lvert5\rvert$ 中属于对角元的那一项不计入：

| $j$ | 半径 $c_j$（该列非对角绝对值和） | 区间 |
|:--:|:--:|:--|
| 1 | $\lvert0\rvert+\lvert-2\rvert=2$ | $[8,\ 12]$ |
| 2 | $\lvert-1\rvert+\lvert1\rvert=2$ | $[2,\ 6]$ |
| 3 | $\lvert2\rvert+\lvert1\rvert=3$ | $[2,\ 8]$ |

**收紧后的围栏：** 定理给出复平面中行圆盘并集与列圆盘并集的交集，而不是各同编号圆盘逐一配对取交。两组圆盘的实轴截面分别为 $[2,13]$ 和 $[2,12]$；仅对实特征值，才可进一步说其落在 $[2,12]$。两组圆盘各自均连通，不能从孤立圆盘计数断言某盘单独含一个特征值。

**非奇异性：** 原点 $0$ 不在任何行圆盘内（最靠左的区间是 $[2,8]$），故 $A$ 非奇异。

**数值近似（NumPy）：** $\sigma(A)\approx\{3.6535,\ 6.2778,\ 9.0687\}$；这些近似值均落在行、列圆盘并集中，但不能反过来把圆盘截面当作特征值必为实数的证明。

**顺带一提：** $A$ 其实还是**严格对角占优**的——第 1 行 $\lvert10\rvert\gt3$ ✓，第 2 行 $\lvert4\rvert\gt1$ ✓，第 3 行 $\lvert5\rvert\gt3$ ✓，三行都满足 $\lvert a_{ii}\rvert\gt r_i$，所以「$A$ 非奇异」这个结论直接由此也能得到。
:::

:::

<a id="sup-2.5.3"></a>

## 2.5.3 幂法与 Rayleigh 商（预告路线图第三章）

::: intuition 直觉 · 反复乘，最大的特征值会「浮出水面」
先假设 $A$ 可对角化，且初始向量在主特征向量方向的系数非零。把向量按特征向量展开：$\boldsymbol{x}=\sum_i c_i\boldsymbol{v}_i$。然后反复乘 $A$：

$$A^k\boldsymbol{x}=\sum_ic_i\lambda_i^k\boldsymbol{v}_i=\lambda_1^k\Bigl[c_1\boldsymbol{v}_1+\sum_{i\gt1}c_i\Bigl(\frac{\lambda_i}{\lambda_1}\Bigr)^k\boldsymbol{v}_i\Bigr].$$

提取公因子 $\lambda_1^k$ 后，括号里**除了第一项，其余各项都带着因子 $(\lambda_i/\lambda_1)^k\to0$**（只要 $\lvert\lambda_1\rvert\gt\lvert\lambda_i\rvert$）。于是这个向量的方向趋于 $\boldsymbol{v}_1$，而模长每乘一次就放大 $\lvert\lambda_1\rvert$。**这就是幂法**：不需要任何矩阵分解，只有反复的「乘一次、归一化一次」——只要矩阵–向量乘法足够便宜（稀疏矩阵！），它就能求出**主特征值**。

**收敛速度取决于 $\lvert\lambda_2/\lambda_1\rvert$**（这个比值越小，收敛越快）。它也叫做**分离度**，是衡量「主特征值问题好不好算」的一把尺子。
:::

::: method 算法 2.5.1 · 幂法（power method）+ Rayleigh 商

**输入**：实对称 $A$，初始单位向量 $\boldsymbol{x}_0$ 满足 $\boldsymbol{u}_1^{\mathrm T}\boldsymbol{x}_0\ne0$；**假设**：$|\lambda_1|>|\lambda_2|$；**输出**：主特征值及特征向量方向的近似。每步稠密矩阵–向量乘法需 $O(n^2)$，稀疏时可用 $O(\mathrm{nnz})$。

```text
x = 任意非零向量，规范化：x = x / ||x||
repeat:
    y = A @ x                     # 一次矩阵-向量乘法
    x_new = y / ||y||             # 规范化（防止溢出/下溢）
    lambda = x_new' @ A @ x_new   # Rayleigh 商 ← 更准的特征值估计
    if ||A @ x_new - lambda * x_new|| < tol: return lambda, x_new
    x = x_new
return lambda, x
```

对称矩阵的 Rayleigh 商在特征向量处具有二阶精度（见下方定理），还能保留负特征值的符号。范数比只给特征值的模；在对称情形它也可能具有二阶精度，不能笼统断言需要两倍步数。
:::

::: thm 定理 2.5.3（新增） · 幂法收敛速度与 Rayleigh 商精度 {#thm-sup-2.5.3}
设 $A$ 对称，特征值满足 $\lvert\lambda_1\rvert\gt\lvert\lambda_2\rvert\ge\cdots\ge\lvert\lambda_n\rvert$，对应的标准正交特征向量为 $\boldsymbol{u}_1,\dots,\boldsymbol{u}_n$。设初值 $\boldsymbol{x}_0$ 满足 $\boldsymbol{u}_1^{\mathrm T}\boldsymbol{x}_0\neq0$，$\boldsymbol{x}_k=A^k\boldsymbol{x}_0/\lVert A^k\boldsymbol{x}_0\rVert$。则

$$\min_{s\in\{-1,1\}}\lVert\boldsymbol{x}_k-s\boldsymbol{u}_1\rVert_2=O\!\left(\left\lvert\frac{\lambda_2}{\lambda_1}\right\rvert^{k}\right),\qquad
\lvert R(\boldsymbol{x}_k)-\lambda_1\rvert=O\!\left(\left\lvert\frac{\lambda_2}{\lambda_1}\right\rvert^{2k}\right),$$

其中 $R(\boldsymbol{x})=\dfrac{\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}$ 为 **Rayleigh 商**。

::: proof 证明（要点）
记 $\boldsymbol{x}_0=\sum_ic_i\boldsymbol{u}_i$，$c_1\neq0$。则

$$A^k\boldsymbol{x}_0=\sum_ic_i\lambda_i^k\boldsymbol{u}_i=\lambda_1^k\Bigl[c_1\boldsymbol{u}_1+\sum_{i\ge2}c_i\Bigl(\frac{\lambda_i}{\lambda_1}\Bigr)^k\boldsymbol{u}_i\Bigr]
=\lambda_1^k\bigl(c_1\boldsymbol{u}_1+\boldsymbol{\eta}_k\bigr),$$

其中 $\lVert\boldsymbol\eta_k\rVert=O(|\lambda_2/\lambda_1|^k)$。规范化后方向趋于 $\operatorname{sgn}(\lambda_1^kc_1)\boldsymbol u_1$；若主特征值为负，符号会交替，因此向量误差应取两种符号中的较小者。

**Rayleigh 商的部分**：设 $\boldsymbol{x}=\boldsymbol{u}_1+\boldsymbol{\delta}$、$\boldsymbol{\delta}\perp\boldsymbol{u}_1$。则

$$\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}=(\boldsymbol{u}_1+\boldsymbol{\delta})^{\mathrm T}A(\boldsymbol{u}_1+\boldsymbol{\delta})=\lambda_1+2\lambda_1\boldsymbol{u}_1^{\mathrm T}\boldsymbol{\delta}+\boldsymbol{\delta}^{\mathrm T}A\boldsymbol{\delta}
=\lambda_1+\boldsymbol{\delta}^{\mathrm T}A\boldsymbol{\delta}$$

（交叉项因 $\boldsymbol{u}_1^{\mathrm T}A\boldsymbol{\delta}=\lambda_1\boldsymbol{u}_1^{\mathrm T}\boldsymbol{\delta}=0$ 消失）。又 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=1+2\boldsymbol{u}_1^{\mathrm T}\boldsymbol{\delta}+\lVert\boldsymbol{\delta}\rVert^2=1+O(\lVert\boldsymbol{\delta}\rVert^2)$。于是

$$R(\boldsymbol{x})=\frac{\lambda_1+\boldsymbol{\delta}^{\mathrm T}A\boldsymbol{\delta}}{1+O(\lVert\boldsymbol{\delta}\rVert^2)}=\lambda_1+O(\lVert\boldsymbol{\delta}\rVert^2).$$

**关键就在这一点：特征向量的误差是一阶量，Rayleigh 商的误差是它的平方**——因为 $\lambda_1$ 正是 Rayleigh 商在 $\boldsymbol{u}_1$ 处取到的**驻点**，一阶项自动消失（这也是 [@thm-sup-2.5.5] 的 Courant–Fischer 定理所刻画的极值性质）。
:::

:::

::: ex 例 2.5.3（新增） · 幂法的实测收敛速度 {#ex-sup-2.5.3}
对

$$A=\begin{pmatrix}5&2&0\\2&4&1\\0&1&3\end{pmatrix}$$

用幂法算主特征值，报告每一步的 Rayleigh 商误差，验证速度约为 $\lvert\lambda_2/\lambda_1\rvert^2$。

::: proof 解
$\sigma(A)=\{6.6691,\ 3.4760,\ 1.8549\}$（NumPy），故 $\lvert\lambda_2/\lambda_1\rvert\approx0.52122$，Rayleigh 商误差每步应乘约 $0.52122^2\approx0.2717$。

```python
import numpy as np
A = np.array([[5.,2,0],[2,4,1],[0,1,3]])
w = np.sort(np.abs(np.linalg.eigvals(A)))[::-1]
x = np.ones(3)/np.sqrt(3)
prev = None
for k in range(1, 13):
    y = A @ x; x = y/np.linalg.norm(y); r = x @ A @ x
    ratio = "" if prev is None else f"  误差比={abs(r-w[0])/prev:.4f}"
    prev = abs(r - w[0])
    if k in (1,2,3,5,8,12):
        print(f"k={k:2d} Rayleigh={r:.10f} 误差={abs(r-w[0]):.3e}{ratio}")
```

```text
k= 1 Rayleigh=6.5000000000 误差=1.691e-01
k= 2 Rayleigh=6.6248462485 误差=4.423e-02
k= 3 Rayleigh=6.6572150909 误差=1.186e-02
k= 5 Rayleigh=6.6682079209 误差=8.712e-04
k= 8 Rayleigh=6.6690616301 误差=1.746e-05
k=12 Rayleigh=6.6690789932 误差=9.509e-08
```

**逐段核对比值：** $4.423\times10^{-2}/1.691\times10^{-1}=0.2616$；$1.186\times10^{-2}/4.423\times10^{-2}=0.2682$；$8.712\times10^{-4}/\ldots\approx0.269$；$9.509\times10^{-8}/1.746\times10^{-5}=0.00545$（这一段恰好是理论比值的四步复合 $0.2717^4$，仍走在理论轨道上）。

**结论：** 实测比值 $0.26\sim0.27$，与理论值 $0.2717$ **吻合** ✓。**这就是「收敛速度 $=(\lambda_2/\lambda_1)^2$」的直接证据。**

**对比一下：** 本例对称正定，$\lVert A\boldsymbol{x}_k\rVert_2$ 作为特征值模的估计也具有二阶方向误差；$0.5212$ 对应向量方向误差的渐近比，而不是此估计的误差比。

**反幂法（预告）：** 把 $A$ 换成 $(A-\mu I)^{-1}$，主特征值就变成 $1/(\lambda^{*}-\mu)$——**迭代会收敛到最接近 $\mu$ 的那个特征值**，速度由 $\lvert(\lambda_i-\mu)/(\lambda_j-\mu)\rvert$ 决定。这既是「已知近似值、反过来求精确特征值」的标准技巧（$\mu$ 取 Rayleigh 商时，精度还能再升到三阶），也是[第三章](../ch01/sec11.md#roadmap) 3.1.2 的内容。
:::

:::

<a id="sup-2.5.4"></a>

## 2.5.4 对称谱理论：Rayleigh 商与 Courant–Fischer

对称矩阵能正交对角化，特征值全实，并有适用于对称扰动的 Weyl 绝对误差界。这里的“温和”指特征值的绝对敏感性，不保证近零特征值的相对误差小，也不保证重特征值对应的某一根特征向量稳定。下面用 Rayleigh 商与 Courant–Fischer 定理刻画特征值，再据此证明扰动界。

::: def 定义 2.5.2 · Rayleigh 商 {#def-sup-2.5.2}
设 $A\in\mathbb{R}^{n\times n}$ 对称、$\boldsymbol{x}\neq\boldsymbol{0}$，称

$$R(\boldsymbol{x})=\frac{\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}} \tag{2.28}$$

为 $A$ 在 $\boldsymbol{x}$ 处的 **Rayleigh 商**。若 $\boldsymbol{x}$ 是单位向量，则 $R(\boldsymbol{x})=\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}$。
:::

::: intuition 直觉 · Rayleigh 商是「在某个方向上测出的特征值」
把 $\boldsymbol x$ 归一化后，$R(\boldsymbol x)$ 是特征值按方向分量平方加权的平均值。它落在 $\lambda_{\min}$ 与 $\lambda_{\max}$ 之间，特征向量处等于对应特征值。Courant–Fischer 还刻画中间特征值：升序编号时，先在 $k$ 维子空间取最大值，再对所有这样的子空间取最小值，得到 $\lambda_k$；等价地可在 $n-k+1$ 维子空间先取最小、再取最大。这是将特征值问题与优化联系起来的桥梁。
:::

::: thm 定理 2.5.4（新增） · 对称矩阵 Rayleigh 商的变分性质 {#thm-sup-2.5.4}
设 $A\in\mathbb{R}^{n\times n}$ 对称，特征值（从小到大）$\lambda_1\le\lambda_2\le\cdots\le\lambda_n$，对应的标准正交特征向量 $\boldsymbol{u}_1,\dots,\boldsymbol{u}_n$，则

$$\lambda_1=\min_{\boldsymbol{x}\neq\boldsymbol{0}}R(\boldsymbol{x}),\qquad
\lambda_n=\max_{\boldsymbol{x}\neq\boldsymbol{0}}R(\boldsymbol{x}).$$

且 $\boldsymbol{x}$ 是极值点 $\iff$ $\boldsymbol{x}$ 是对应 $\lambda_1$（或 $\lambda_n$）的特征向量。

::: proof 证明
任何 $\boldsymbol{x}\neq\boldsymbol{0}$ 可展开为 $\boldsymbol{x}=\sum_ik_i\boldsymbol{u}_i$，由正交性 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\sum_ik_i^2$，且

$$\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}=\sum_{i,j}k_ik_j\boldsymbol{u}_i^{\mathrm T}A\boldsymbol{u}_j=\sum_{i,j}k_ik_j\lambda_j\delta_{ij}=\sum_i\lambda_ik_i^2 .$$

于是

$$R(\boldsymbol{x})=\frac{\sum_i\lambda_ik_i^2}{\sum_ik_i^2} .$$

**加权平均：** $R(\boldsymbol x)$ 以 $k_i^2/\sum_jk_j^2$ 为权，故落在 $[\lambda_1,\lambda_n]$。取下界当且仅当非零权重只对应最小特征值，即 $\boldsymbol x$ 属于最小特征值的整个特征子空间；上界同理，包括重特征值的情形。
:::

:::

::: thm 定理 2.5.5（新增） · Courant–Fischer 极小极大原理 {#thm-sup-2.5.5}
设 $A$ 对称，特征值从小到大为 $\lambda_1\le\cdots\le\lambda_n$，则对 $k=1,\dots,n$，

$$\lambda_k=\min_{\dim\mathcal{S}=k}\ \max_{\boldsymbol{0}\neq\boldsymbol{x}\in\mathcal{S}}R(\boldsymbol{x})
=\max_{\dim\mathcal{T}=n-k+1}\ \min_{\boldsymbol{0}\neq\boldsymbol{x}\in\mathcal{T}}R(\boldsymbol{x}) ,$$

其中 $\mathcal{S},\mathcal{T}$ 取遍 $\mathbb{R}^n$ 的相应维数子空间。

::: proof 证明（第一等式）
**先证 $\le$（取特定的 $k$ 维子空间）。** 令 $\mathcal S_0=\operatorname{span}\{\boldsymbol u_1,\dots,\boldsymbol u_k\}$。对任意非零 $\boldsymbol x\in\mathcal S_0$，有 $R(\boldsymbol x)\le\lambda_k$。

$$\max_{\boldsymbol{x}\in\mathcal{S}_0}R(\boldsymbol{x})=\lambda_k\qquad(\text{取}\ \boldsymbol{x}=\boldsymbol{u}_k\ \text{达到})\quad\Longrightarrow\quad
\min_{\dim\mathcal{S}=k}\max_{\boldsymbol{x}\in\mathcal{S}}R(\boldsymbol{x})\le\lambda_k .$$

**再证 $\ge$（维数计数）。** 设 $\mathcal S$ 是任意 $k$ 维子空间，令 $\mathcal T=\operatorname{span}\{\boldsymbol u_k,\dots,\boldsymbol u_n\}$，$\dim\mathcal T=n-k+1$。由维数公式

$$\dim(\mathcal{S}\cap\mathcal{T})\ge\dim\mathcal{S}+\dim\mathcal{T}-n=k+(n-k+1)-n=1,$$

故存在 $\boldsymbol{0}\neq\boldsymbol{x}\in\mathcal{S}\cap\mathcal{T}$。写 $\boldsymbol{x}=\sum_{i\ge k}k_i\boldsymbol{u}_i$，则 $R(\boldsymbol{x})\ge\lambda_k$（权只落在 $\lambda_k,\dots,\lambda_n$ 上）。于是在这个 $\mathcal{S}$ 上 $\max R\ge\lambda_k$；$\mathcal{S}$ 是任意的，对 $\mathcal{S}$ 取下确界后仍 $\ge\lambda_k$。

两个方向合起来就是第一等式。至于第二等式，对 $-A$ 套用第一等式即可（$(-A)$ 的特征值是 $-\lambda_n\le\cdots\le-\lambda_1$，其中第 $k$ 大 $=-\lambda_{n-k+1}$，再用 $\min\max$ 与 $\max\min$ 的互换）。
:::

:::

::: ex 例 2.5.4（新增） · 数值验证 Courant–Fischer {#ex-sup-2.5.4}
对

$$A=\begin{pmatrix}4&1&0\\1&3&1\\0&1&2\end{pmatrix}$$

数值验证：随机方向上的 Rayleigh 商极值趋于 $\lambda_{\min},\lambda_{\max}$；$k$ 维子空间上的极小值最大化后趋于 $\lambda_2$。

::: proof 解
$\sigma(A)=\{1.2679,\ 3.0000,\ 4.7321\}$（从小到大）。

```python
import numpy as np
A = np.array([[4.,1,0],[1,3,1],[0,1,2]])
w = np.linalg.eigvalsh(A)                     # 升序
rng = np.random.default_rng(0)

# (a) 随机单位方向上的 Rayleigh 商极值
vals = []
for _ in range(200000):
    x = rng.normal(size=3); x /= np.linalg.norm(x); vals.append(x @ A @ x)
print(f"随机方向: min R={min(vals):.8f}  max R={max(vals):.8f}")
print(f"理论:     λmin={w[0]:.8f}  λmax={w[-1]:.8f}")

# (b) 2 维子空间上的极小值，再在所有 2 维子空间上取最大
best = -np.inf
for _ in range(200000):
    Q, _ = np.linalg.qr(rng.normal(size=(3, 2)))      # 随机 2 维子空间的正交基
    best = max(best, np.linalg.eigvalsh(Q.T @ A @ Q)[0])   # 该子空间上的 min R
print(f"max over 2-dim subspaces of min R = {best:.8f}  (理论 λ2={w[1]:.8f})")
```

```text
随机方向: min R=1.26795245  max R=4.73203903
理论:     λmin=1.26794919  λmax=4.73205081
max over 2-dim subspaces of min R = 3.00000000  (理论 λ2=3.00000000)
```

**从结果里读出三件事：**

1. 随机方向上的极值只是**逼近** $\lambda_{\min},\lambda_{\max}$（差 $\sim10^{-5}$）：20 万次随机采样并没有命中精确的特征方向——变分原理的本质是**优化**，随机撒点只不过是一种近似的优化方式。
2. 第二项在显示位数内等于 $\lambda_2=3$，不代表有限次随机采样精确命中最优子空间。理论取等构造是 $\mathcal S=\operatorname{span}\{u_2,u_3\}$，其上 $\min R=\lambda_2$；任意二维子空间都与 $\operatorname{span}\{u_1,u_2\}$ 有非零交，故其 $\min R\le\lambda_2$。随机搜索提供下侧近似，证明则来自这个维数论证。
3. **实用含义：** 求 $\lambda_2$ 可以「在 2 维子空间上做 Rayleigh 商最小化」——这就是 **Lanczos 算法 / 子空间迭代**的基本思想，也是 [习题 C6](exercises.md) 的动手内容。
:::

:::

<a id="sup-2.5.5"></a>

## 2.5.5 特征值的敏感性：对称 vs 非正规

这是本节最重要、也最反直觉的一节。前面反复出现的「对称矩阵很温和」这句话，到这里要兑现成定量的结论，同时也把「非正规矩阵有多难缠」摆到台面上。

::: intuition 直觉 · 重特征值会被扰动「撕开」成 $\sqrt{\varepsilon}$ 或更糟
设想 $A$ 有一个**重特征值**（例如 $\lambda=1$，二重）。如果往矩阵上加一个大小为 $\varepsilon$ 的扰动，特征值会跑多远？

- **对称（或正规）情形：** 移动量是 $O(\varepsilon)$——温和。
- **非正规情形（如 Jordan 块）：** 移动量是 $O(\sqrt{\varepsilon})$——**开方敏感**！$\varepsilon=10^{-16}$ 时移动 $10^{-8}$：**丢了 8 位有效数字**。

**为什么会开方？** 把 $A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$ 扰动成 $\begin{pmatrix}1&1\\t&1\end{pmatrix}$，特征方程是 $(1-\lambda)^2=t$，于是 $\lambda=1\pm\sqrt{t}$。**重根处的特征多项式是「平方」形态，解出来自然带根号。** 重数越高越糟：$k$ 重特征值遇上 $O(\varepsilon)$ 量级的扰动，可以移动 $O(\varepsilon^{1/k})$。

**工程含义：** 这个缺陷 Jordan 块的重特征值对某些扰动高度敏感，稳定算法也无法消除输入问题本身的敏感性。反过来，对称矩阵即使有重特征值，特征值仍满足 Weyl 的线性扰动界；特征向量或重特征值附近的子空间则需另外分析（[@thm-sup-2.5.4]）。
:::

::: thm 定理 2.5.6（新增） · 特征值扰动界（两个极端情形） {#thm-sup-2.5.6}
**（一）对称情形（Weyl 不等式）：** 设 $A,E\in\mathbb R^{n\times n}$ 对称，$\lambda_1\le\cdots\le\lambda_n$ 是 $A$ 的特征值，$\mu_1\le\cdots\le\mu_n$ 是 $A+E$ 的特征值，则对每个 $i$，

$$\lvert\lambda_i-\mu_i\rvert\le\lVert E\rVert_2 .$$

即**对称矩阵的特征值对扰动是 $1$-Lipschitz 的**——误差与扰动同阶，一点都不放大。

**（二）一般情形（Bauer–Fike 定理）：** 设 $A$ 可对角化，$A=V\Lambda V^{-1}$，$E$ 为扰动，则 $\sigma(A+E)$ 中的每个特征值 $\mu$ 都满足

$$\min_{\lambda\in\sigma(A)}\lvert\lambda-\mu\rvert\le\lVert V\rVert_2\,\lVert V^{-1}\rVert_2\,\lVert E\rVert_2=\mathrm{cond}_2(V)\,\lVert E\rVert_2 .$$

**放大因子是所选特征向量矩阵 $V$ 的条件数。** 正规矩阵可以选酉特征向量矩阵，使该数为 1。Bauer–Fike 只保证扰动谱中的每一点靠近原谱的某一点，不直接给出按编号的一一匹配；对称扰动下的有序匹配由（一）的变分证明保证。

**（三）缺陷 Jordan 块（一般不能有统一线性界）。** 一个大小为 $k>1$ 的 Jordan 块可在 $\|E\|_2=\varepsilon$ 的特定扰动下产生 $\varepsilon^{1/k}$ 量级的移动。因此线性放大率可随 $\varepsilon\to0$ 无界；这仍是一个非线性扰动尺度，不是“没有任何界”，也不适用于所有非正规重特征值。

::: proof 证明
**（一）Weyl 不等式。** 用 Courant–Fischer（[@thm-sup-2.5.5]）：

$$\lambda_i=\min_{\dim\mathcal{S}=i}\max_{\boldsymbol{x}\in\mathcal{S}}R_A(\boldsymbol{x}),\qquad
\mu_i=\min_{\dim\mathcal{S}=i}\max_{\boldsymbol{x}\in\mathcal{S}}R_{A+E}(\boldsymbol{x}) .$$

对任意固定的 $\mathcal{S}$ 与单位向量 $\boldsymbol{x}\in\mathcal{S}$，$\lvert R_{A}(\boldsymbol{x})-R_{A+E}(\boldsymbol{x})\rvert=\lvert\boldsymbol{x}^{\mathrm T}E\boldsymbol{x}\rvert\le\lVert E\rVert_2$。因此对每个固定的 $\mathcal{S}$，两个「$\max$」之差都不超过 $\lVert E\rVert_2$；再对 $\mathcal{S}$ 取 $\min$，同样得到 $\lvert\lambda_i-\mu_i\rvert\le\lVert E\rVert_2$。

**（二）Bauer–Fike。** 设 $(A+E)\boldsymbol{w}=\mu\boldsymbol{w}$、$\lVert\boldsymbol{w}\rVert_2=1$。则

$$(A-\mu I)\boldsymbol{w}=-E\boldsymbol{w},\qquad
\boldsymbol{w}=-(A-\mu I)^{-1}E\boldsymbol{w}\ \ (\mu\notin\sigma(A)\ \text{时}) .$$

设 $\mu$ 使 $\mu I-A$ 可逆（否则 $\mu$ 已是 $A$ 的特征值，结论显然）。取范数：

$$1=\lVert\boldsymbol{w}\rVert\le\lVert(A-\mu I)^{-1}\rVert_2\lVert E\rVert_2 .$$

**关键一步：估计 $\lVert(A-\mu I)^{-1}\rVert_2$。** 用 $A=V\Lambda V^{-1}$：

$$\lVert(A-\mu I)^{-1}\rVert_2=\lVert V(\Lambda-\mu I)^{-1}V^{-1}\rVert_2\le\lVert V\rVert_2\lVert V^{-1}\rVert_2\max_i\frac{1}{\lvert\lambda_i-\mu\rvert}
=\frac{\mathrm{cond}_2(V)}{\min_i\lvert\lambda_i-\mu\rvert} .$$

代入上式得 $1\le\dfrac{\mathrm{cond}_2(V)\lVert E\rVert_2}{\min_i\lvert\lambda_i-\mu\rvert}$，整理后就是待证的结论。

**（三）** 用一个 Jordan 块把现象显式摆出来：$A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$（$k=2$ 重特征值 $1$），$E=\begin{pmatrix}0&0\\t&0\end{pmatrix}$，则 $A+E$ 的特征方程 $(1-\lambda)^2=t$ 给出 $\lambda=1\pm\sqrt{t}$，移动量就是 $\sqrt{t}=\varepsilon^{1/2}$（取 $\varepsilon=t$）。
:::

:::

::: ex 例 2.5.5（新增） · 开方敏感 vs 温和：数值对照 {#ex-sup-2.5.5}
（1）对 Jordan 块 $A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$ 加扰动 $E=\begin{pmatrix}0&0\\t&0\end{pmatrix}$，看特征值的移动怎样随 $t$ 变化。
（2）对对称矩阵 $A=\begin{pmatrix}1&0\\0&2\end{pmatrix}$ 加扰动 $E=\begin{pmatrix}0&t\\t&0\end{pmatrix}$，同样观察一遍。

::: proof 解
```python
import numpy as np
print("== (1) Jordan 块（非正规）==")
J = np.array([[1.,1],[0,1.]])
for t in [1e-2,1e-4,1e-8,1e-12,1e-16]:
    B = J + np.array([[0.,0],[t,0]])
    print(f"  t={t:.0e}  特征值={np.round(np.linalg.eigvals(B),10)}  "
          f"1±sqrt(t)={1-np.sqrt(t):.10f},{1+np.sqrt(t):.10f}")

print("== (2) 对称矩阵 ==")
S = np.array([[1.,0],[0,2.]])
for t in [1e-2,1e-8,1e-16]:
    B = S + np.array([[0.,t],[t,0]])
    print(f"  t={t:.0e}  特征值={np.round(np.linalg.eigvalsh(B),14)}  (移动量 ~t)")
```

```text
== (1) Jordan 块（非正规）==
  t=1e-02  特征值=[1.1 0.9]  1±sqrt(t)=0.9000000000,1.1000000000
  t=1e-04  特征值=[1.01 0.99]  1±sqrt(t)=0.9900000000,1.0100000000
  t=1e-08  特征值=[1.0001 0.9999]  1±sqrt(t)=0.9999000000,1.0001000000
  t=1e-12  特征值=[1.000001 0.999999]  1±sqrt(t)=0.9999990000,1.0000010000
  t=1e-16  特征值=[1. 1.]  1±sqrt(t)=0.9999999900,1.0000000100
== (2) 对称矩阵 ==
  t=1e-02  特征值=[0.99990001 2.00009999]  (移动量 ≈t²)
  t=1e-08  特征值=[1. 2.]
  t=1e-16  特征值=[1. 2.]
```

**（1）的读法：** 精确数学问题中移动量为 $\sqrt t$：$t=10^{-2}$ 时为 $10^{-1}$，$t=10^{-12}$ 时为 $10^{-6}$。表中 $t=10^{-16}$ 的数值输出没有分辨出理论上的 $1\pm10^{-8}$；可表示这两个数不代表该特征值算法必定能算出它们。对扰动规模约为机器精度的此 Jordan 块，最坏方向的敏感性约为 $\sqrt u$，并非所有重特征值或所有扰动都有相同表现。

**（2）的读法：** 特征值精确为 $1.5\pm\sqrt{0.25+t^2}$，移动量约 $t^2$——**比 $t$ 还小一个数量级**（$t=10^{-2}$ 时只移动 $10^{-4}$，见表中 $0.99990001$）。$t=10^{-8}$ 与 $10^{-16}$ 时，移动量（$\sim10^{-16}$ 与 $\sim10^{-32}$）已经低于机器精度，**完全测不出来**——**对称矩阵的特征值对扰动极其稳健**。

**工程结论：** 对称结构有利于控制特征值的绝对误差，但小特征值的相对精度、特征向量的谱间隙仍须单独考察。缺陷非正规问题则可能对输入高度敏感。Schur 形式有助于稳定表示和计算原特征值问题，却不会消除其敏感性；改求奇异值回答的是另一个问题，不能替代特征值。计算奇异值通常直接对 $A$ 做 SVD，而不显式形成 $A^{\mathrm T}A$。
:::

:::

::: ex 例 2.5.6（新增） · 非正规矩阵的「伪谱」直觉（可选） {#ex-sup-2.5.6}
取 $N=\begin{pmatrix}1&1000\\0&1\end{pmatrix}$，它的 $\rho(N)=1$、$\lVert N\rVert_2\approx1000$。请解释：为什么「$\rho(N)\lt1$ 就意味着迭代收敛」这句话，在非正规矩阵上**不能**按直觉来用。

::: proof 解
$\rho(N)=1$（特征值 $1,1$），$\lVert N\rVert_2\approx1000$。**谱半径远小于范数**。

**问题出在「迭代 $N^k$ 到底衰不衰减」上。** 对正规矩阵，$\lVert A^k\rVert_2=\rho(A)^k=\lvert\lambda_{\max}\rvert^k$，所以 $\rho\lt1$ 立刻给出几何衰减。对非正规矩阵，只能保证 $\rho(A)=\lim_k\lVert A^k\rVert^{1/k}$（Gelfand 公式，证明与瞬态增长的定量分析见[附录 A.2.7](../appendix/derivations.md#app-a-2-7)）——**这个极限式子固然成立，但有限步内的 $\lVert N^k\rVert$ 可以要多大有多大**。本例：

$$N^k=\begin{pmatrix}1&k\cdot1000\\0&1\end{pmatrix},\qquad \lVert N^k\rVert_2\approx1000k\ (\text{线性增长！})$$

**即使 $\rho(N)=1$（注意还不是 $\lt1$），$\lVert N^k\rVert$ 也能增长到任意大**；哪怕取 $\rho(N)=0.9\lt1$（例如 $\begin{pmatrix}0.9&M\\0&0.9\end{pmatrix}$），在 $k\lesssim1/\log(1/0.9)$ 的步数内，$\lVert N^k\rVert$ 仍可能先上升——这就是**「瞬态增长」（transient growth）**。

**工程含义：** [第五章](../ch01/sec11.md#roadmap)的迭代法收敛性判据如果只写「$\rho(H)\lt1$」，在非正规情形下就是**理论上成立、实践中可能失效**（有限步内误差先涨后落，甚至溢出）。更稳妥的判据是 $\lVert H\rVert\lt1$（[1.3.5](../ch01/sec13.md#sec-1.3.5) 定理 1.3.6），它给出**每一步都在收缩**的保证。**这就是「用范数，不用谱半径」的实用理由。**

（这类现象在流体力学与数值天气预报里尤其常见，有专门的工具对付它——**伪谱（pseudospectrum）**，见 [延伸阅读](../reading.md)。）
:::

:::

<a id="sup-2.5.6"></a>

## 2.5.6 小结与常见错误

::: method[core] 本节公式速查

| 概念 | 公式 / 结论 |
|:--|:--|
| 特征值 | $A\boldsymbol{v}=\lambda\boldsymbol{v}$；$\det(A-\lambda I)=0$ |
| 迹 / 行列式 | $\operatorname{tr}A=\sum\lambda_i$；$\det A=\prod\lambda_i$ |
| 谱半径 | $\rho(A)=\max\lvert\lambda_i\rvert$ |
| 谱半径与范数 | $\rho(A)\le\lVert A\rVert$（任一相容范数） |
| Gerschgorin | $\lvert\lambda-a_{ii}\rvert\le\sum_{j\neq i}\lvert a_{ij}\rvert$；连通区域含对应个数特征值 |
| 对角占优 | $\lvert a_{ii}\rvert\gt\sum_{j\neq i}\lvert a_{ij}\rvert\ \forall i\Rightarrow A$ 非奇异 |
| Rayleigh 商 | $R(\boldsymbol{x})=\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}/\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$（$A$ 对称） |
| 变分刻画 | $\lambda_1=\min R$，$\lambda_n=\max R$；Courant–Fischer 给全部中间特征值 |
| 幂法收敛 | 向量误差 $O(\lvert\lambda_2/\lambda_1\rvert^k)$；Rayleigh 商误差 $O(\lvert\lambda_2/\lambda_1\rvert^{2k})$ |
| 对称扰动 | $|\lambda_i(A+E)-\lambda_i(A)|\le\|E\|_2$（$A,E$ 对称，Weyl） |
| 一般扰动 | $\min_{\lambda\in\sigma(A)}|\mu-\lambda|\le\mathrm{cond}_2(V)\|E\|_2$（$A=V\Lambda V^{-1}$ 可对角化） |
| 缺陷重特征值 | 大小为 $k$ 的 Jordan 块可有 $O(\|E\|^{1/k})$ 的移动 |

:::

::: think[core] 常见错误清单 · 自查六条
1. **拿 $\lVert A\rVert$ 当 $\rho(A)$。** $\rho\le\|A\|$ 是不等式；$\rho(H)<1$ 保证定常线性迭代对任意初值渐近收敛，$\|H\|<1$ 则是所选范数下每步收缩的充分条件。相关范数判据可查[第 3 讲整理稿](../lectures/lec03.md#lec03-S3)和[第 4 讲](../lectures/lec04.md)；两讲原录音待核，不能把本节的瞬态增长分析归为课堂原话。
2. **以为所有重特征值都同样敏感或同样稳定。** 特定缺陷 Jordan 块可在 $O(\varepsilon)$ 扰动下移动 $O(\varepsilon^{1/k})$；对称矩阵的重特征值则满足 Weyl 的线性扰动界。
3. **把 Gerschgorin 圆盘当精确值。** 它给出的是**包含区间**；只有对角占优时圆心才接近特征值。若圆盘相交，只能断定「这个连通区里有多少个特征值」，无法把它们一一配到具体位置上。
4. **忘记 Gerschgorin 的列版本。** 行圆盘并集与列圆盘并集取交可以收紧围栏；例 2.5.2 对实特征值的整体围栏是 $[2,12]$，不是只取第一列圆盘的 $[8,12]$。
5. **幂法不归一化，或把估计量的收敛阶混淆。** 归一化防止溢出和下溢；对称情形 Rayleigh 商保留符号且具有二阶方向误差，范数比只给模，但也可能具有二阶精度。
6. **以为实矩阵的特征值全实。** 对称性是保证谱全实的充分条件，不是必要条件。非对称矩阵应使用 `np.linalg.eigvals`，不能因输出看似实数而调用假定对称的 `eigvalsh`。
:::

::: preview 课程预告 · 本节之后
- **SVD 与对称谱定理的联系**：$\sigma_i(A)=\sqrt{\lambda_i(A^{\mathrm T}A)}$；但显式形成 $A^{\mathrm T}A$ 会放大小奇异值的相对计算困难，实践通常直接对 $A$ 做 SVD——[2.6](sec26.md)；
- **幂法 / 反幂法 / QR 方法 / Jacobi 方法求特征值**：原书第 3 章 3.1–3.3 节（课堂已于[第 6 讲](../lectures/lec06.md)开篇，并在[第 7 讲](../lectures/lec07.md)展开规范化幂法、反幂法与位移反幂法；本节的 Rayleigh 商正是幂法提取特征值的工具）；
- **谱半径决定迭代收敛速度**：原书第 2 章 2.4 节与[第 2 章](../course/ch02/overview.md)（$\rho(H)\lt1$ 是 Jacobi / Gauss–Seidel / SOR 收敛的判据，课堂实录见[第 5 讲](../lectures/lec05.md)、[第 6 讲](../lectures/lec06.md)）；
以上课堂链接只用于定位既有记录：第 5、7 讲目前仅有整理稿，原录音待核；第 6 讲原始 ASR 尚未经听校，不把其转写措辞视为已核实原话。
- **条件数与谱的关系**：$\mathrm{cond}_2(A)=\sigma_1/\sigma_r$（[2.4](sec24.md)），而 $\sigma$ 来自对称矩阵的谱——两节在这里汇合。
:::
