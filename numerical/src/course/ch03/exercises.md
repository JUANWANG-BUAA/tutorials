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
| <span id="ex-3-6">6</span> | 实特征值算法选择 | $-50\lt\lambda_1\lt\lambda_2\lt-10\le\lambda_3\le\cdots$ | ✅ 对 $A+50I$ 幂法求 $\lambda_n$、反幂法求 $\lambda_1$；求 $\lambda_2$ 前先消去第一特征方向或验证合适的位移，见[3.6](sec31.md)。 |
| <span id="ex-3-7">7</span> | Jacobi 方法 | $A=\begin{pmatrix}1&1&0.5\\1&1&0.25\\0.5&0.25&2\end{pmatrix}$，$\varepsilon=10^{-5}$ | ✅ Jacobi 迭代得特征值 $2.536526,\ 1.480121,\ -0.016647$（和 $=4=$ 迹）；特征向量由累积旋转矩阵的列给出。 |
| <span id="ex-3-8">8</span> | 分块三角矩阵 | 证明 $P,Q$ 的特征值可延拓 | ✅ 用 $\det(\lambda I-T)=\det(\lambda I-P)\det(\lambda I-Q)$ 证明谱的并集；右下块的向量一般不能直接补零。 |
| <span id="ex-3-9">9</span> | Householder 映射 | $s=(-2,1,2)^{\mathrm T}$，$r=(4,3,0)^{\mathrm T}$ | ✅ $u=s-v=(-4.4,-0.8,2)^{\mathrm T}$，$v=(2.4,1.8,0)^{\mathrm T}$；$H=I-2uu^{\mathrm T}/(u^{\mathrm T}u)$。 |
| <span id="ex-3-10">10</span> | Householder 化三对角 | $A=\begin{pmatrix}1&2&1&2\\2&1&2&-1\\1&2&0&3\\2&-1&3&1\end{pmatrix}$ | ✅ 两次 Householder 相似变换得三对角矩阵，见[例 3.3.2](sec33.md#ex-3.3.2)；次对角线为 $(-3,\ 2.759943,\ -1.016207)$。 |
| <span id="ex-3-11">11</span> | Householder 化拟上三角 | $A=\begin{pmatrix}2&1&3&4\\1&-1&2&1\\-1&2&1&2\\1&0&-1&3\end{pmatrix}$ | ✅ 两次相似变换得拟上三角，见[例 3.3.3](sec33.md#ex-3.3.3)；第 1 列第 3、4 行与第 2 列第 4 行为零。 |
| <span id="ex-3-12">12</span> | 基本 QR 方法 | $A=\begin{pmatrix}3&1&0\\1&2&1\\0&1&1\end{pmatrix}$ | ✅ 基本 QR 迭代收敛到特征值 $2+\sqrt3,\ 2,\ 2-\sqrt3$（即 $3.732051,\ 2,\ 0.267949$），迭代表见[例 3.3.4](sec33.md#ex-3.3.4)。 |

## 作业组 · 老师布置的 SPOC 自测题（第三章 矩阵特征值与特征向量的计算）

::: note 这份作业的来路与交法 {#hw-3-meta}

作业名称「矩阵特征值与特征向量的计算」，发布在北航 SPOC《数值分析 I》课程 → 作业测试，附件 `数值分析单元自测题3.pdf`（原件本地归档于 `_sources/homework/`，该目录入库规则为忽略）。
满分 10 分，接收班级 2026-2027-1-GA01011002-学院路 1 班；起止时间 2026-10-11 00:00 至 2026-10-18 00:00（已截止）。
四道题都是「**先看谱、再选算法**」型：题 1、2 考移位与商的收敛对象，题 3 考拟上三角阵的谱（分块三角的谱等于对角块谱的并集），题 4 考「幂法/反幂法/移位反幂法」三件套的分工。**本章的题目几乎不需要大量计算，考的是判断**。

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

**与正文的联系**：这就是[3.1.1 幂法](sec31.md#sec-3.1.1) 的「规范化技巧」的理论依据。实际计算不能直接用 $A^k\boldsymbol u_0$（会溢出），要对每步归一化；归一化只改变方向的尺度，但若把商中的两个向量各自归一化，就必须补回尺度因子；不能直接对两个单位向量取商后仍断言极限是 $\lambda_1$。例如用单位向量 $y_{k-1}$，比值 $v^{\mathrm T}Ay_{k-1}/(v^{\mathrm T}y_{k-1})$ 才保留原商。教材习题 3 就是本题的原型。

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

::: note 覆盖核对
本页覆盖教材习题 1–12（题面摘要 + 答案/提示）与**老师布置的 SPOC 自测题四道（完整精讲）**，与 [3.1](sec31.md)、[3.2](sec32.md)、[3.3](sec33.md) 的例题/证明互补。覆盖矩阵见[第 3 章覆盖矩阵](coverage.md)。
:::
