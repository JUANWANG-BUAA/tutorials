# 第 3 章习题（教材 1–12）

> 题面数据以颜庆津《数值分析》（第 4 版）第 3 章习题（p.65–66）为准；本表给题面摘要、答案/提示与正文落点。
> 证明题给证明骨架，计算题给方法/数值；具体数值按教材矩阵复算。

| 题 | 主题 | 题面摘要 | 答案 / 提示 |
|:--:|:--|:--|:--|
| <span id="ex-3-1">1</span> | 幂法乘法次数 | 比较 $A^ku_0$ 与逐步乘 | ✅ 逐步乘 $kn^2$；先算 $A^k$ 约 $(k-1)n^3$。 |
| <span id="ex-3-2">2</span> | 幂法求主特征值 | 两个矩阵，相对差 $\le10^{-4}$ | ✅ 规范化幂法；$\beta_k\to\lambda_1$，$y_{k-1}$ 为特征向量。 |
| <span id="ex-3-3">3</span> | 商序列收敛 | 证明 $\frac{v^{\mathrm T}A^ku_0}{v^{\mathrm T}A^{k-1}u_0}\to\lambda_1$ | ✅ 展开 $A^ku_0$，同除 $\lambda_1^{k-1}$，其余项含 $(\lambda_j/\lambda_1)^k\to0$。 |
| <span id="ex-3-4">4</span> | 反幂法 | 第 2 题 (1) 的模最小特征值 | ✅ 每步解 $Au_k=y_{k-1}$，$\lambda_n\approx1/\beta_k$。 |
| <span id="ex-3-5">5</span> | 反幂法精修 | 已知 $\lambda\approx9$ | ✅ 对 $A-9I$ 反幂法，$\lambda\approx9+1/\beta_k$。 |
| <span id="ex-3-6">6</span> | 实特征值算法选择 | $-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots$ | ✅ 幂法求 $\lambda_n$；反幂法求 $\lambda_1$；位移反幂法（$p\approx-10$）求 $\lambda_2$。 |
| <span id="ex-3-7">7</span> | Jacobi 方法 | $A=\begin{pmatrix}1&1&0.5\\1&1&0.25\\0.5&0.25&2\end{pmatrix}$，$\varepsilon=10^{-5}$ | ✅ Jacobi 迭代得特征值 $2.536526,\ 1.480121,\ -0.016647$（和 $=4=$ 迹）；特征向量由累积旋转矩阵的列给出。 |
| <span id="ex-3-8">8</span> | 分块三角矩阵 | 证明 $P,Q$ 的特征值可延拓 | ✅ 若 $Px=\lambda x$，则 $T(x,0)^{\mathrm T}=\lambda(x,0)^{\mathrm T}$；$Q$ 同理。 |
| <span id="ex-3-9">9</span> | Householder 映射 | $s=(-2,1,2)^{\mathrm T}$，$r=(4,3,0)^{\mathrm T}$ | ✅ $u=s-v=(-4.4,-0.8,2)^{\mathrm T}$，$v=(2.4,1.8,0)^{\mathrm T}$；$H=I-2uu^{\mathrm T}/(u^{\mathrm T}u)$。 |
| <span id="ex-3-10">10</span> | Householder 化三对角 | $A=\begin{pmatrix}1&2&1&2\\2&1&2&-1\\1&2&0&3\\2&-1&3&1\end{pmatrix}$ | ✅ 两次 Householder 相似变换得三对角矩阵，见[例 3.3.2](sec33.md#ex-3.3.2)；次对角线为 $(-3,\ 2.759943,\ -1.016207)$。 |
| <span id="ex-3-11">11</span> | Householder 化拟上三角 | $A=\begin{pmatrix}2&1&3&4\\1&-1&2&1\\-1&2&1&2\\1&0&-1&3\end{pmatrix}$ | ✅ 两次相似变换得拟上三角，见[例 3.3.3](sec33.md#ex-3.3.3)；第 1 列第 3、4 行与第 2 列第 4 行为零。 |
| <span id="ex-3-12">12</span> | 基本 QR 方法 | $A=\begin{pmatrix}3&1&0\\1&2&1\\0&1&1\end{pmatrix}$ | ✅ 基本 QR 迭代收敛到特征值 $2+\sqrt3,\ 2,\ 2-\sqrt3$（即 $3.732051,\ 2,\ 0.267949$），迭代表见[例 3.3.4](sec33.md#ex-3.3.4)。 |

## 作业组 · 老师布置的 SPOC 自测题（第三章 矩阵特征值与特征向量的计算）

::: note 这份作业的来路与交法 {#hw-3-meta}

作业名称「矩阵特征值与特征向量的计算」，发布在北航 SPOC《数值分析 I》课程 → 作业测试，附件 `数值分析单元自测题3.pdf`（原件本地归档于 `_sources/homework/`，该目录入库规则为忽略）。
满分 10 分，接收班级 2026-2027-1-GA01011002-学院路 1 班；起止时间 2026-10-11 00:00 至 2026-10-18 00:00（已截止）。
四道题都是「**先看谱、再选算法**」型：题 1、2 考移位与商的收敛对象，题 3 考拟上三角阵的谱（分块三角 = 分块对角化），题 4 考「幂法/反幂法/移位反幂法」三件套的分工。**本章的题目几乎不需要大量计算，考的是判断**。

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

**答案：B（$\lambda_2$）。**

**第一步：看出这是「对 $A+6I$ 做反幂法」。** 迭代式 $\boldsymbol u_k=(A+6I)^{-1}\boldsymbol y_{k-1}$ 就是「解方程组 $(A+6I)\boldsymbol u_k=\boldsymbol y_{k-1}$ 再归一化」——即对矩阵

$$M=(A+6I)^{-1}$$

做**幂法**。所以 $\boldsymbol u_k$ 收敛到 $M$ 的**模最大**特征值对应的特征向量。

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
1. **符号**：$A+6I$ 对应移位 $\sigma=-6$（不是 $+6$）。写成 $\sigma=6$ 就会误选 C（$\lambda_3$ 离 6 最近）。
2. **模，不是大小**：反幂法比的是 $\lvert\lambda_i-\sigma\rvert$，不是 $\lambda_i-\sigma$。若只看代数大小会误判 $\lambda_1$（最负）。
3. **互异实数**这个前提不能丢：若 $\lambda_i$ 有重根或复根，$M$ 的模最大特征值可能不唯一，$\boldsymbol u_k$ 不收敛到单个特征向量。

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

**与正文的联系**：这就是[3.1.1 幂法](sec31.md#sec-3.1.1) 的「规范化技巧」的理论依据。实际计算不能直接用 $A^k\boldsymbol u_0$（会溢出），要对每步归一化；归一化只改变数乘因子、不改变方向，所以商仍收敛到 $\lambda_1$。教材习题 3 就是本题的原型。

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

所以**特征值 = $B$ 的特征值 ∪ $D$ 的特征值**，与 $C$ 无关（$C$ 只影响特征向量，不影响特征值）。这正是教材习题 8 的结论（分块三角阵的谱可延拓）。

**$B$ 的特征值**：$\operatorname{tr}B=9$、$\det B=2\times7-(-1)\times3=14+3=17$，故

$$\lambda^2-9\lambda+17=0\ \Longrightarrow\ \lambda=\frac{9\pm\sqrt{81-68}}{2}=\frac{9\pm\sqrt{13}}{2}=6.3028,\ 2.6972 .$$

**$D$ 的特征值**：$D$ 本身还是分块上三角（左上 $6$ 是一块，右下 $\begin{pmatrix}1&-4\\2&3\end{pmatrix}$ 是一块），

$$\det(\lambda I-D)=(\lambda-6)\left[(\lambda-1)(\lambda-3)-(-4)\times2\right]=(\lambda-6)(\lambda^2-4\lambda+11).$$

所以 $\lambda=6$，以及

$$\lambda^2-4\lambda+11=0\ \Longrightarrow\ \lambda=2\pm\mathrm i\sqrt{7}\quad(\lvert\lambda\rvert=\sqrt{4+7}=\sqrt{11}\approx3.317).$$

**全部特征值**：

$$\boxed{\ \lambda=\frac{9+\sqrt{13}}{2},\ \frac{9-\sqrt{13}}{2},\ 6,\ 2+\mathrm i\sqrt{7},\ 2-\mathrm i\sqrt{7}\ }$$

即约 $6.3028,\ 2.6972,\ 6,\ 2\pm3.3166\mathrm i$。

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

**先把「谁给谁」说清楚**（这是本题最容易写错的地方）：

- **幂法**（对 $A$ 直接迭代）给的是**模最大**的特征值 $\lambda_1$（需要 $\lvert\lambda_1\rvert\gt\lvert\lambda_n\rvert$）；
- **反幂法**（对 $A^{-1}$ 迭代，等价于每步解 $A\boldsymbol u=\boldsymbol y$）给的是**模最小**的特征值 $\lambda_n$（需要 $\lvert\lambda_n\rvert\lt\lvert\lambda_i\rvert$，$i\neq n$）；
- **移位反幂法**（对 $(A-\sigma I)^{-1}$ 迭代）给的是**离 $\sigma$ 最近**的特征值。

所以：求 $\lambda_n$ 用反幂法；求 $\lambda_{n-1}$ 用**以 $\lambda_n$ 为移位量**的反幂法。下面写出可直接编程的方案。

### 方案一：求 $\lambda_n$（反幂法）

前提：$\lvert\lambda_n\rvert$ 严格小于其余特征值的模（题目只给了大小顺序，实际做题时应加一句「若 $\lvert\lambda_n\rvert$ 不是最小模，改用移位」）。

1. 任取初值 $\boldsymbol u_0\neq\boldsymbol 0$；
2. 对 $k=1,2,\dots$：
   1. 归一化 $\boldsymbol y_{k-1}=\dfrac{\boldsymbol u_{k-1}}{\lVert\boldsymbol u_{k-1}\rVert_\infty}$；
   2. **解方程组** $A\boldsymbol u_k=\boldsymbol y_{k-1}$（用 LU 分解，一次分解反复使用）；
   3. 取商 $\beta_k=\bigl(\boldsymbol y_{k-1}\bigr)_{j}\big/\bigl(\boldsymbol u_k\bigr)_{j}$，其中 $j$ 是 $\lvert\boldsymbol u_k\rvert$ 最大的分量下标（用最大分量比避免小分母）；
   4. 若 $\lvert\beta_k-\beta_{k-1}\rvert\lt\varepsilon$，停止；
3. 输出 $\lambda_n\approx\dfrac{1}{\beta_k}$，特征向量 $\approx\boldsymbol y_k$。

**为什么**：$A^{-1}$ 的特征值是 $1/\lambda_i$，模最大者是 $1/\lambda_n$（因为 $\lvert\lambda_n\rvert$ 最小），幂法给出它；商的倒数即 $\lambda_n$。

### 方案二：求 $\lambda_{n-1}$（以 $\lambda_n$ 为移位的反幂法）

1. 用方案一先算出 $\lambda_n$ 的近似值 $\tilde\lambda_n$；
2. 取移位量 $\sigma=\tilde\lambda_n$，构造 $A-\sigma I$ 并作 LU 分解（注意 $A-\sigma I$ 可能接近奇异，这正是我们要的）；
3. 对 $k=1,2,\dots$：
   1. 归一化 $\boldsymbol y_{k-1}=\dfrac{\boldsymbol u_{k-1}}{\lVert\boldsymbol u_{k-1}\rVert_\infty}$；
   2. 解 $(A-\sigma I)\boldsymbol u_k=\boldsymbol y_{k-1}$；
   3. 取商 $\beta_k=\bigl(\boldsymbol y_{k-1}\bigr)_j\big/\bigl(\boldsymbol u_k\bigr)_j$；
4. 输出

$$\lambda_{n-1}\approx\sigma+\frac{1}{\beta_k},\qquad\text{特征向量}\approx\boldsymbol y_k .$$

**为什么**：$A-\sigma I$ 的特征值是 $\lambda_i-\sigma$，其中 $\lvert\lambda_{n}-\sigma\rvert$ 最小（$\sigma$ 就在 $\lambda_n$ 旁边），故 $(A-\sigma I)^{-1}$ 的模最大特征值是 $\dfrac{1}{\lambda_n-\sigma}$，反幂法收敛到 $\boldsymbol x_n$ 方向——**等等，这样得到的是 $\lambda_n$ 而不是 $\lambda_{n-1}$！**

### 修正：移位量必须偏向 $\lambda_{n-1}$

上面的写法是错的（很多答案就错在这里）。正确的取法是让 $\sigma$ **更靠近 $\lambda_{n-1}$ 而不是 $\lambda_n$**。两种可操作的做法：

**(a) 用两个已知近似做中点**：若已求得 $\lambda_n$ 的近似 $\tilde\lambda_n$，再取一个 $\lambda_{n-1}$ 的粗近似 $\tilde\lambda_{n-1}$（例如用幂法对 $A$ 求 $\lambda_1$ 后配合迹：$\sum\lambda_i=\operatorname{tr}A$，逐步回推），取

$$\sigma=\tfrac12\bigl(\tilde\lambda_{n-1}+\tilde\lambda_n\bigr),$$

则 $\lvert\lambda_{n-1}-\sigma\rvert\approx\lvert\lambda_n-\sigma\rvert$，仍不保险。

**(b) 标准做法——把 $\lambda_n$ 先「移走」**：取 $\sigma=\tilde\lambda_n$ 对 $(A-\sigma I)^{-1}$ 迭代，收敛到 $\boldsymbol x_n$（这正是方案一，说明移位量落在哪个特征值上就收敛到哪个）。要拿 $\lambda_{n-1}$，必须让 $\sigma$ 落在 $\lambda_{n-1}$ 的**吸引域**内：

$$\sigma\ \text{取在}\ \lambda_n\ \text{与}\ \lambda_{n-1}\ \text{之间、且更靠近}\ \lambda_{n-1},\ \text{例如}\ \sigma=\tilde\lambda_n+\delta,\quad 0\lt\delta\lt\tfrac12\lvert\tilde\lambda_{n-1}-\tilde\lambda_n\rvert .$$

此时 $\lvert\lambda_{n-1}-\sigma\rvert\lt\lvert\lambda_n-\sigma\rvert$ 且对其它 $i$ 也有 $\lvert\lambda_{n-1}-\sigma\rvert\lt\lvert\lambda_i-\sigma\rvert$，反幂法收敛到 $\boldsymbol x_{n-1}$，输出 $\lambda_{n-1}\approx\sigma+\dfrac{1}{\beta_k}$。

### 答题模板（考场上照这个写）

> **(1) 求 $\lambda_n$：** 对 $A$ 作 LU 分解；取 $\boldsymbol u_0\neq\boldsymbol 0$，迭代 $\boldsymbol y_{k-1}=\boldsymbol u_{k-1}/\lVert\boldsymbol u_{k-1}\rVert_\infty$，解 $A\boldsymbol u_k=\boldsymbol y_{k-1}$，$\beta_k=(\boldsymbol y_{k-1})_j/(\boldsymbol u_k)_j$；则 $\lambda_n\approx1/\beta_k$，$\boldsymbol x_n\approx\boldsymbol y_k$。收敛速度由 $\lvert\lambda_n\rvert/\lvert\lambda_{n-1}\rvert$ 决定。
>
> **(2) 求 $\lambda_{n-1}$：** 取移位量 $\sigma$ 使 $\lvert\lambda_{n-1}-\sigma\rvert\lt\lvert\lambda_i-\sigma\rvert\ (i\neq n-1)$（实用取法：$\sigma$ 落在 $\lambda_n$ 与 $\lambda_{n-1}$ 之间且偏向 $\lambda_{n-1}$）；对 $(A-\sigma I)$ 作 LU 分解，迭代解 $(A-\sigma I)\boldsymbol u_k=\boldsymbol y_{k-1}$，$\beta_k=(\boldsymbol y_{k-1})_j/(\boldsymbol u_k)_j$；则 $\lambda_{n-1}\approx\sigma+1/\beta_k$。

**评分要点**：
1. 说清「幂法给模最大、反幂法给模最小」这一对偶关系；
2. 反幂法**每步解方程组**（不是乘逆矩阵）——这是它与幂法的唯一实现差别，也是 $O(n^3)$ 与 $O(n^2)$ 的分水岭；
3. 求 $\lambda_{n-1}$ **必须用移位**，且要说清移位量偏向谁；
4. 收敛速度：反幂法的比值是 $\left\lvert\dfrac{\lambda_n}{\lambda_{n-1}}\right\rvert$，两个特征值越接近收敛越慢——这正是「已知近似值时反幂法极快」的原因（移位后比值可任意小）。

:::

::: note 作业组与正文的对应 {#hw-3-cover}

| 题目 | 落在正文哪一节 | 一句话考点 |
|:--|:--|:--|
| 3-1 | [3.1.2 反幂法与位移反幂法](sec31.md#sec-3.1.2) | 移位反幂法收敛到离 $\sigma$ 最近的特征值 |
| 3-2 | [3.1.1 幂法](sec31.md#sec-3.1.1) | 商的极限 = 主特征值（展开 + 比值消去） |
| 3-3 | [3.3.2 拟上三角化](sec33.md#sec-3.3.2) | 分块上三角 ⟹ 谱 = 各块谱之并 |
| 3-4 | [3.1.2 反幂法](sec31.md#sec-3.1.2) | 幂法 ↔ 反幂法 ↔ 移位反幂法的分工 |

:::

## 按正文进度练（作业与教材习题的插入点）

::: method[core] 读完哪一节，就做哪几题 {#hw-3-progress}

| 读完 | 立刻做（10–15 分钟） | 再做（30 分钟） | 为什么放在这里 |
|:--|:--|:--|:--|
| [3.1.1 幂法](sec31.md#sec-3.1.1) | 教材习题 [1](exercises.md#ex-3-1)、[2](exercises.md#ex-3-2) | **作业 3-2**（商的极限）· 教材习题 [3](exercises.md#ex-3-3) | 作业 3-2 与习题 3 同源，但作业版给了 $\boldsymbol v$ 探测方向，要求说清「为什么 $\boldsymbol v^{\mathrm T}\boldsymbol x_1\neq0$」 |
| [3.1.2 反幂法与位移反幂法](sec31.md#sec-3.1.2) | **作业 3-1**（选择题，5 分钟） | **作业 3-4**（三件套分工）· 教材习题 [4](exercises.md#ex-3-4)、[5](exercises.md#ex-3-5)、[6](exercises.md#ex-3-6) | 作业 3-1 练「区间到原点距离」的眼力；3-4 是它的完整版（要写出可编程方案） |
| [3.2 Jacobi 方法](sec32.md#sec-3.2) | 教材习题 [7](exercises.md#ex-3-7) | 教材习题 [8](exercises.md#ex-3-8)（分块三角） | 习题 8 的结论正是作业 3-3 的第一把钥匙 |
| [3.3 QR 方法](sec33.md#sec-3.3.1) | **作业 3-3**（拟上三角求谱，10 分钟） | 教材习题 [9](exercises.md#ex-3-9)–[12](exercises.md#ex-3-12) | 作业 3-3 只用「分块上三角」这一条性质，是 3.3.2 拟上三角化的最低门槛题 |

**一条铁律**：作业 3-1 与作业 3-4 连着做。前者是「给定移位量，判断收敛到谁」，后者是「给定目标，设计移位量」——**正着会做、反着不会做，是本章最典型的失分模式**。

:::

::: note 覆盖核对
本页覆盖教材习题 1–12（题面摘要 + 答案/提示）与**老师布置的 SPOC 自测题四道（完整精讲）**，与 [3.1](sec31.md)、[3.2](sec32.md)、[3.3](sec33.md) 的例题/证明互补。覆盖矩阵见[第 3 章覆盖矩阵](coverage.md)。
:::
