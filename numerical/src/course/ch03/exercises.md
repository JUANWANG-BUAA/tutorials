# 第 3 章练习与解答

各节末尾已经给出题目与参考解答。下表按顺序列出入口；本页后半部分是综合练习。

| 题号 | 练习 |
|:--|:--|
| <span id="ex-3-1">3.1</span> | [幂法乘法次数](sec31.md#exercise-3.1) |
| <span id="ex-3-2">3.2</span> | [幂法求主特征值](sec31.md#exercise-3.2) |
| <span id="ex-3-3">3.3</span> | [商序列收敛](sec31.md#exercise-3.3) |
| <span id="ex-3-4">3.4</span> | [反幂法](sec31.md#exercise-3.4) |
| <span id="ex-3-5">3.5</span> | [已知近似特征值](sec31.md#exercise-3.5) |
| <span id="ex-3-6">3.6</span> | [实特征值的算法选择](sec31.md#exercise-3.6) |
| <span id="ex-3-7">3.7</span> | [Jacobi 方法求全部特征值](sec32.md#exercise-3.7) |
| <span id="ex-3-8">3.8</span> | [分块三角矩阵](sec32.md#exercise-3.8) |
| <span id="ex-3-9">3.9</span> | [Householder 映射](sec33.md#ex-3.3.9) |
| <span id="ex-3-10">3.10</span> | [对称矩阵三对角化](sec33.md#ex-3.3.10) |
| <span id="ex-3-11">3.11</span> | [一般矩阵拟上三角化](sec33.md#ex-3.3.11) |
| <span id="ex-3-12">3.12</span> | [基本 QR 方法](sec33.md#ex-3.3.12) |


## 作业组：综合练习

::: note 练习说明 {#hw-3-meta}
下面的综合练习附有完整推导。建议先独立作答，再展开解答核对关键步骤。
:::

::: ex 作业 3-1 · 平移 $-6$ 的反幂法收敛到哪个特征向量 {#hw-3-1}

**（第三章自测题 1，选择）** 已知 $A\in\mathbb{R}^{n\times n}$ 的特征值 $\lambda_i$（$i=1,2,\dots,n$）皆为互异实数，且满足

$$\lambda_1\lt-12\lt\lambda_2\lt0\lt\lambda_3\lt6\lt\lambda_4\lt\cdots\lt\lambda_n\lt12 .$$

考虑迭代（$I$ 为单位阵）

$$\boldsymbol u_0\in\mathbb{R}^n,\qquad
\boldsymbol y_{k-1}=\frac{\boldsymbol u_{k-1}}{\lVert\boldsymbol u_{k-1}\rVert_2},\qquad
\boldsymbol u_k=(A+6I)^{-1}\boldsymbol y_{k-1},\qquad
\beta_k=\boldsymbol y_{k-1}^{\mathrm T}\boldsymbol u_k .$$

当 $k$ 充分大时，$\{\boldsymbol u_k\}$ 近似等于 $A$ 的哪个特征值对应的特征向量？
A. $\lambda_1$　　B. $\lambda_2$　　C. $\lambda_3$　　D. $\lambda_n$

:::

::: sol 精讲 {#sol-hw-3-1}

**按题目默认的可逆性与初值条件，答案：B（$\lambda_2$）。** 原题没有排除 $\lambda_2=-6$，也没有明确初值的目标方向分量；若前者成立，所写逆不存在，若后者为零，则不能保证得到该方向。下面先给出标准解题思路，再指出边界。

**第一步：看出这是「对 $A+6I$ 做反幂法」。** 迭代式 $\boldsymbol u_k=(A+6I)^{-1}\boldsymbol y_{k-1}$ 就是「解方程组 $(A+6I)\boldsymbol u_k=\boldsymbol y_{k-1}$ 再归一化」——即对矩阵

$$M=(A+6I)^{-1}$$

做**幂法**。在移位矩阵可逆、初值含目标特征分量时，$\boldsymbol u_k$ 的方向趋向 $M$ 的**模最大**特征值对应方向；负特征值可引起符号交替。

**第二步：把 $M$ 的特征值算出来。** $A$ 的特征值是 $\lambda_i$，则 $A+6I$ 的特征值是 $\lambda_i+6$，$M=(A+6I)^{-1}$ 的特征值是

$$\mu_i=\frac{1}{\lambda_i+6},\qquad i=1,\dots,n .$$

**第三步：比较 $\lvert\mu_i\rvert$，即比较 $\lvert\lambda_i+6\rvert$ 的大小**（$\lvert\mu_i\rvert$ 最大 ⟺ $\lvert\lambda_i+6\rvert$ 最小）：

| 特征值 | 所在区间 | $\lambda_i+6$ 的范围 | $\lvert\lambda_i+6\rvert$ |
|:--:|:--|:--|:--|
| $\lambda_1$ | $\lambda_1\lt-12$ | $\lt-6$ | $\gt6$ |
| $\lambda_2$ | $-12\lt\lambda_2\lt0$ | $(-6,\,6)$ | $\mathbf{\lt6}$ |
| $\lambda_3$ | $0\lt\lambda_3\lt6$ | $(6,\,12)$ | $\gt6$ |
| $\lambda_n$ | $6\lt\lambda_n\lt12$ | $(12,\,18)$ | $\gt12$ |

**唯一的「小于 6」是 $\lvert\lambda_2+6\rvert$**，其余全大于 6。故 $\lvert\mu_2\rvert=\dfrac{1}{\lvert\lambda_2+6\rvert}$ 最大，幂法收敛到 $\lambda_2$ 对应的特征向量。$\blacksquare$

**这道题的训练目标**：把「移位」翻译成「区间到原点的距离」。

> **移位 $\sigma$ 的反幂法，收敛到离 $\sigma$ 最近的特征值。**

本题 $\sigma=-6$，而 $-12\lt\lambda_2\lt0$ 是**唯一把 $-6$ 夹在内部的区间**（$\lambda_2$ 到 $-6$ 的距离 $<6$，其余特征值到 $-6$ 的距离都 $>6$）——所以答案是 $\lambda_2$。

**三个易错点**：
1. **符号**：$A+6I$ 对应移位 $\sigma=-6$（不是 $+6$）。若误写成 $\sigma=6$，就改变了目标；题给区间甚至不足以断定哪个特征值离 $+6$ 最近。
2. **模，不是大小**：反幂法比的是 $\lvert\lambda_i-\sigma\rvert$，不是 $\lambda_i-\sigma$。若只看代数大小会误判 $\lambda_1$（最负）。
3. **可执行性与初值**：须有 $\lambda_2\ne-6$、初值在 $\boldsymbol x_2$ 上的展开系数非零。互异实特征值保证可对角化，但不能代替这两项条件；原题的遗漏应明确补注。

:::

::: ex 作业 3-2 · 商 $\beta_k=\frac{\boldsymbol v^{\mathrm T}\boldsymbol u_k}{\boldsymbol v^{\mathrm T}\boldsymbol u_{k-1}}$ 收敛到什么 {#hw-3-2}

**（第三章自测题 2，填空）** 设 $n$ 阶实方阵 $A$ 具有 $n$ 个线性无关的特征向量 $\boldsymbol x_1,\dots,\boldsymbol x_n$，相应特征值满足 $\lvert\lambda_1\rvert\gt\lvert\lambda_2\rvert\ge\lvert\lambda_3\rvert\ge\cdots\ge\lvert\lambda_n\rvert$。任取 $n$ 维非零向量 $\boldsymbol v$ 和 $\boldsymbol u_0$，且 $\boldsymbol u_0$ 在 $\boldsymbol x_1$ 方向的分量不为零、$\boldsymbol v^{\mathrm T}\boldsymbol x_1\neq0$，那么由

$$\boldsymbol u_k=A\boldsymbol u_{k-1},\qquad
\beta_k=\frac{\boldsymbol v^{\mathrm T}\boldsymbol u_k}{\boldsymbol v^{\mathrm T}\boldsymbol u_{k-1}},\qquad k=1,2,\cdots$$

产生的序列 $\{\beta_k\}$ 收敛于 ________。

:::

::: sol 精讲 {#sol-hw-3-2}

**答案：$\lambda_1$。**

**第一步：把 $\boldsymbol u_0$ 按特征向量展开。** $\{\boldsymbol x_i\}$ 线性无关、构成 $\mathbb{R}^n$ 的基，故

$$\boldsymbol u_0=\sum_{i=1}^{n}c_i\boldsymbol x_i,\qquad c_1\neq0\ (\text{题设：}\boldsymbol u_0\ \text{在}\ \boldsymbol x_1\ \text{方向分量非零}).$$

**第二步：迭代 $k$ 次。** 由 $A\boldsymbol x_i=\lambda_i\boldsymbol x_i$，

$$\boldsymbol u_k=A^k\boldsymbol u_0=\sum_{i=1}^{n}c_i\lambda_i^{k}\boldsymbol x_i .$$

**第三步：算商。** 分子分母各是数：

$$\boldsymbol v^{\mathrm T}\boldsymbol u_k=\sum_{i=1}^{n}c_i(\boldsymbol v^{\mathrm T}\boldsymbol x_i)\lambda_i^{k} .$$

上下同除 $\lambda_1^{k-1}$：

$$\beta_k=\frac{\sum_i c_i(\boldsymbol v^{\mathrm T}\boldsymbol x_i)\lambda_i^{k}}{\sum_i c_i(\boldsymbol v^{\mathrm T}\boldsymbol x_i)\lambda_i^{k-1}}
=\lambda_1\cdot\frac{c_1(\boldsymbol v^{\mathrm T}\boldsymbol x_1)+\sum_{i\ge2}c_i(\boldsymbol v^{\mathrm T}\boldsymbol x_i)\left(\frac{\lambda_i}{\lambda_1}\right)^{k}}{c_1(\boldsymbol v^{\mathrm T}\boldsymbol x_1)+\sum_{i\ge2}c_i(\boldsymbol v^{\mathrm T}\boldsymbol x_i)\left(\frac{\lambda_i}{\lambda_1}\right)^{k-1}} .$$

**第四步：取极限。** 因 $\lvert\lambda_i/\lambda_1\rvert\lt1\ (i\ge2)$，所有 $\left(\frac{\lambda_i}{\lambda_1}\right)^{k}\to0$。又 $c_1\neq0$、$\boldsymbol v^{\mathrm T}\boldsymbol x_1\neq0$，分子分母的常数项都非零，故

$$\beta_k\longrightarrow\lambda_1\cdot\frac{c_1\boldsymbol v^{\mathrm T}\boldsymbol x_1}{c_1\boldsymbol v^{\mathrm T}\boldsymbol x_1}=\lambda_1 .\qquad\blacksquare$$

**这题的三个「为什么」**（每一个都是题设条件的用途，答题时要写出来）：
1. **为什么要 $n$ 个线性无关特征向量**：保证 $\boldsymbol u_0$ 能按 $\{\boldsymbol x_i\}$ 展开、且 $\boldsymbol u_k$ 有闭式表达；
2. **为什么要 $c_1\neq0$**：否则分子分母的常数项同时为 0，$\beta_k$ 收敛到 $\lambda_2$（甚至更后面的特征值）；
3. **为什么要 $\boldsymbol v^{\mathrm T}\boldsymbol x_1\neq0$**：$\boldsymbol v$ 是「探测方向」，若它与 $\boldsymbol x_1$ 正交，则 $\boldsymbol v^{\mathrm T}\boldsymbol u_k$ 里 $\lambda_1$ 的成分被消掉，商收敛到下一个特征值。

**与正文的联系**：这就是[3.1.1 幂法](sec31.md#sec-3.1.1) 的「规范化技巧」的理论依据。直接形成 $A^k\boldsymbol u_0$ 可能溢出或下溢，因而通常逐步相乘并归一化；归一化只改变方向的尺度，但若把商中的两个向量各自归一化，就必须补回尺度因子；不能直接对两个单位向量取商后仍断言极限是 $\lambda_1$。例如用单位向量 $y_{k-1}$，比值 $v^{\mathrm T}Ay_{k-1}/(v^{\mathrm T}y_{k-1})$ 才保留原商。

:::

::: ex 作业 3-3 · 拟上三角矩阵的谱 {#hw-3-3}

**（第三章自测题 3，填空）** 设 $A$ 为 $5\times5$ 的拟上三角矩阵

$$A=\begin{pmatrix}
2&-1&7&11&-1\\
3&7&3&4&1\\
0&0&6&8&0\\
0&0&0&1&-4\\
0&0&0&2&3
\end{pmatrix},$$

求 $A$ 的特征值。

:::

::: sol 精讲 {#sol-hw-3-3}

**关键观察：$A$ 是分块上三角矩阵。**

$$A=\begin{pmatrix}B&C\\O&D\end{pmatrix},\qquad
B=\begin{pmatrix}2&-1\\3&7\end{pmatrix},\quad
D=\begin{pmatrix}6&8&0\\0&1&-4\\0&2&3\end{pmatrix},$$

其中 $C$ 是右上角的 $2\times3$ 块，左下角是零块。分块上三角阵的行列式满足

$$\det(\lambda I-A)=\det(\lambda I_2-B)\cdot\det(\lambda I_3-D),$$

所以**特征值 = $B$ 的特征值 ∪ $D$ 的特征值**，与 $C$ 无关（$C$ 只影响特征向量，不影响特征值）。这利用的是分块三角矩阵特征多项式的分解。

**$B$ 的特征值**：$\operatorname{tr}B=9$、$\det B=2\times7-(-1)\times3=14+3=17$，故

$$\lambda^2-9\lambda+17=0\ \Longrightarrow\ \lambda=\frac{9\pm\sqrt{81-68}}{2}=\frac{9\pm\sqrt{13}}{2}=6.3028,\ 2.6972 .$$

**$D$ 的特征值**：$D$ 本身还是分块上三角（左上 $6$ 是一块，右下 $\begin{pmatrix}1&-4\\2&3\end{pmatrix}$ 是一块），

$$\det(\lambda I-D)=(\lambda-6)\left[(\lambda-1)(\lambda-3)-(-4)\times2\right]=(\lambda-6)(\lambda^2-4\lambda+11).$$

所以 $\lambda=6$，以及

$$\lambda^2-4\lambda+11=0\ \Longrightarrow\ \lambda=2\pm\mathrm i\sqrt{7}\quad(\lvert\lambda\rvert=\sqrt{4+7}=\sqrt{11}\approx3.317).$$

**全部特征值**：

$$\boxed{\ \lambda=\frac{9+\sqrt{13}}{2},\ \frac{9-\sqrt{13}}{2},\ 6,\ 2+\mathrm i\sqrt{7},\ 2-\mathrm i\sqrt{7}\ }$$

即约 $6.3028,\ 2.6972,\ 6,\ 2\pm2.6458\mathrm i$。

**验算（必做，10 秒）**：特征值之和应等于迹

$$\frac{9+\sqrt{13}}{2}+\frac{9-\sqrt{13}}{2}+6+(2+\mathrm i\sqrt7)+(2-\mathrm i\sqrt7)=9+6+4=19 .$$

而 $\operatorname{tr}A=2+7+6+1+3=19$ ✓。**复特征值成对出现**（$2\pm\mathrm i\sqrt7$）也符合实矩阵的性质，可用来自检。

**这道题的三个考点**：
1. **认出分块上三角**（左下角一大片零），立刻把 $5\times5$ 降成 $2\times2$ 与 $3\times3$；
2. **降完还要再降一次**（$D$ 仍是分块上三角）——考试里最常见的是停在第一步；
3. **出现复特征值不慌**：$\lambda^2-4\lambda+11$ 的判别式 $-28\lt0$，写 $2\pm\mathrm i\sqrt7$ 即可；这也解释了为什么要做 QR 而不是幂法（幂法对付不了复共轭对）。

:::

::: ex 作业 3-4 · 求 $\lambda_n$ 与 $\lambda_{n-1}$ 的计算方案 {#hw-3-4}

**（第三章自测题 4）** 设矩阵 $A\in\mathbb{R}^{n\times n}$ 的特征值 $\lambda_i\ (i=1,\dots,n)$ 都是实数且满足 $\lambda_1\gt\lambda_2\gt\cdots\gt\lambda_{n-1}\gt\lambda_n$。试分别给出使用幂法和反幂法求 $A$ 的特征值 $\lambda_n$ 和 $\lambda_{n-1}$ 的计算方案。

:::

::: sol 精讲 {#sol-hw-3-4}

题设按**代数大小**排序，不能把最小值直接当成最小模。以下给出不要求特征值为正的两套方案。互异实特征值保证 $A$ 可对角化；每次幂迭代还须选取含目标方向分量的初值。

### 方案一：平移后用幂法，再消去已求方向

先用 Gerschgorin 圆盘得到实谱的上下界

$$\ell=\min_i\left(a_{ii}-\sum_{j\ne i}|a_{ij}|\right),\qquad
u=\max_i\left(a_{ii}+\sum_{j\ne i}|a_{ij}|\right).$$

取 $c>u$，令 $B=cI-A$。其特征值满足

$$c-\lambda_n>c-\lambda_{n-1}>\cdots>c-\lambda_1>0.$$

因此对 $B$ 用幂法得到 $\theta_n=c-\lambda_n$ 与右特征向量 $v_n$，还原 $\lambda_n=c-\theta_n$。

要继续求 $\lambda_{n-1}$，再对 $B^{\mathrm T}$ 求相应左特征向量 $w_n$，归一化使 $w_n^{\mathrm T}v_n=1$，定义谱投影 $P_n=v_nw_n^{\mathrm T}$。于是

$$B_1=B-\theta_nP_n$$

把已求特征值变成零，其余特征值保持 $c-\lambda_i$。对 $B_1$ 用幂法得到 $\theta_{n-1}$，还原 $\lambda_{n-1}=c-\theta_{n-1}$。实际只需计算 $Bz-\theta_n v_n(w_n^{\mathrm T}z)$，无需形成稠密投影矩阵。非对称矩阵的左、右特征向量通常不同，不能擅自把 $w_n$ 换成 $v_n$。

### 方案二：在谱的左侧选位移，反幂法后消去已求方向

取 $\sigma<\ell$，则 $A-\sigma I$ 可逆，且

$$0<\lambda_n-\sigma<\lambda_{n-1}-\sigma<\cdots<\lambda_1-\sigma.$$

对 $C=(A-\sigma I)^{-1}$ 用幂法，即每步先归一化、再解

$$(A-\sigma I)u_k=y_{k-1}.$$

若 $\|y_{k-1}\|_2=1$，取 $\mu_k=y_{k-1}^{\mathrm T}u_k$，则 $\mu_k\to1/(\lambda_n-\sigma)$，故

$$\lambda_n\approx\sigma+\frac1{\mu_k}.$$

求次小值时，用同一个谱投影消去已求分量：

$$C_1=C-\frac1{\lambda_n-\sigma}P_n.$$

每次作用 $C_1$ 时，先解一次 $(A-\sigma I)z=y$，再减去 $v_n(w_n^{\mathrm T}y)/(\lambda_n-\sigma)$。对该算子用幂法，主特征值变成 $1/(\lambda_{n-1}-\sigma)$，再按同样公式还原。转置求解可复用相应分解求左特征向量。

### 一个可手算的验收例

取 $A=\operatorname{diag}(-4,1,3)$。方案一选 $c=5$，$B=\operatorname{diag}(9,4,2)$，先得到 $\lambda_n=5-9=-4$；消去第一方向后 $B_1=\operatorname{diag}(0,4,2)$，得到 $\lambda_{n-1}=5-4=1$。

方案二选 $\sigma=-5$，$C=\operatorname{diag}(1,1/6,1/8)$，先得到 $-5+1/1=-4$；消去第一方向后得到 $1/6$，还原为 $-5+6=1$。

**三条实现边界**：① 反幂法每步解方程，不显式求逆；② 移位若恰等于已求特征值，矩阵奇异，且邻近它的位移仍优先吸引原特征值，不会自动给出“下一个”；③ 数值消去使用近似特征对，会有误差污染，应检查原方程残差，必要时用子空间迭代或稳定的降阶方法。给出严格最近条件的目标位移也是可行方案，但仅凭本题排序不能凭空假设已经知道次小特征值的位置。
:::

::: note 作业组与正文的对应 {#hw-3-cover}

| 题目 | 落在正文哪一节 | 一句话考点 |
|:--|:--|:--|
| 3-1 | [3.1.2 反幂法与位移反幂法](sec31.md#sec-3.1.2) | 移位反幂法收敛到离 $\sigma$ 最近的特征值 |
| 3-2 | [3.1.1 幂法](sec31.md#sec-3.1.1) | 商的极限 = 主特征值（展开 + 比值消去） |
| 3-3 | [3.3.2 拟上三角化](sec33.md#sec-3.3.2) | 分块上三角 ⟹ 谱 = 各块谱之并 |
| 3-4 | [3.1.2 反幂法](sec31.md#sec-3.1.2) | 幂法 ↔ 反幂法 ↔ 移位反幂法的分工 |

:::


## 编者补充训练 · 保留并订正的新增题

以下练习由旧改稿的三对角矩阵题订正而来，**不属于 SPOC 原始作业**。

::: ex 编者练习 3.E1 · 三对角矩阵的特征方向与合法位移 {#editor-eigen-shift}
设 $T=\begin{pmatrix}2&-1&0\\-1&2&-1\\0&-1&2\end{pmatrix}$。

1. 写出按模最大的特征值与单位特征向量，解释为什么全正向量不能作为它的答案。
2. 用位移反幂法求中间特征值：能否取 $\sigma=2$？改成 $\sigma=2.1$ 后，初值 $(1,1,1)^{\mathrm T}$ 与 $(1,0,0)^{\mathrm T}$ 哪个可用？

::: sol 解答
特征值为 $2-\sqrt2,2,2+\sqrt2$。最大特征值的单位向量可取 $\boldsymbol v_+=(1/2,-\sqrt2/2,1/2)^{\mathrm T}$；全正的 $(1/2,\sqrt2/2,1/2)^{\mathrm T}$ 属于最小特征值。

$T-2I$ 奇异，不能执行该位移下的线性求解。取 $\sigma=2.1$ 时可逆，且 2 是离位移最近的特征值。对应中间特征向量 $\boldsymbol v_0=(1,0,-1)^{\mathrm T}/\sqrt2$。初值 $(1,1,1)^{\mathrm T}$ 与它正交，精确算术下始终缺失目标分量；$(1,0,0)^{\mathrm T}$ 的目标分量非零，可用于反幂法。每步解 $(T-2.1I)\boldsymbol u_k=\boldsymbol y_{k-1}$ 后归一化，并检查 $\|T\boldsymbol y_k-\lambda_k\boldsymbol y_k\|$。
:::
:::

## 补充练习：目标特征值与初值

::: ex 方法、初值与验收
对 $A=\operatorname{diag}(-5,2,3)$：① 幂法通常找哪个特征值？② 若初值为 $(0,1,1)^{\mathrm T}$ 会怎样？③ 想找靠近 $2.1$ 的特征值，每步解什么系统？
:::

::: sol 参考解答
① 若目标分量非零，找模最大的 $-5$，方向可能交替变号。② 精确算术下第一分量始终为零，迭代通常趋向特征值 $3$ 的方向。③ 每步解 $(A-2.1I)u=v$ 并归一化，随后用原矩阵的 Rayleigh 商估计原特征值。若使用逆变换的特征值估计 $\mu$，则恢复 $\lambda=2.1+1/\mu$；两套估计不能混用。
:::

## 入门练习

::: ex 3.A · 幂法一步
设 $A=\operatorname{diag}(2,1)$，$u_0=(1,1)^{\mathrm T}$。按先 2-范数单位化、再乘 $A$ 算 $y_0,u_1$。分量比怎样变化？谱间隙对应的收敛比是多少？
:::
::: sol 参考解答
$y_0=(1,1)^{\mathrm T}/\sqrt2$，$u_1=(2,1)^{\mathrm T}/\sqrt2$。第一与第二分量之比从 1 变为 2，正在趋向第一特征方向。次方向的相对衰减因子为 $q=1/2$。
:::

::: ex 3.B · 何时能省略 Rayleigh 商的分母
特征向量可用任意范数单位化，为什么不能一律用 $y^{\mathrm T}Ay$ 当作特征值估计？
:::
::: sol 参考解答
完整商为 $y^{\mathrm T}Ay/(y^{\mathrm T}y)$，只有 $\|y\|_2=1$ 时分母为 1。实对称矩阵中完整商对特征方向误差通常有二阶精度；它来自商的结构，与单位化范数无关。对一般非对称矩阵不能直接推广该二阶结论。
:::

::: ex 3.C · 反幂法一步
对 $A=\begin{pmatrix}4&1\\1&3\end{pmatrix}$、位移 $p=2.9$，每步解什么系统？为什么不显式求逆？
:::
::: sol 参考解答
解 $\begin{pmatrix}1.1&1\\1&0.1\end{pmatrix}u_{k+1}=y_k$ 后单位化，系数矩阵行列式为 $-0.89\ne0$。固定分解可复用于每一步，避免显式逆的额外开销与稀疏性损失；收敛还需目标严格最近及初值分量条件。
:::

::: ex 3.D · 判断
判断并解释：① 幂法只能先单位化再乘矩阵；② 归一化可以改变矩阵的特征值；③ 反幂法要求显式构造逆矩阵。
:::
::: sol 参考解答
① 错；先乘后单位化也可，须使下标与估计公式匹配。② 错；归一化只改变向量的尺度，不改变矩阵及其特征值。③ 错；每步解线性方程组并复用分解。
:::

## 练习顺序 {#hw-3-progress}

先比较幂法与反幂法的目标，再计算 Jacobi 与 QR 的例子；每次都核对特征对残差。
