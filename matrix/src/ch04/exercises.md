# 习题集 · 第四章（4.1–4.3）

三组分层：A 组概念判断（快速自检）、B 组推理证明（考试大题）、C 组计算实操。**全部附解答**（默认折叠），建议先独立完成再展开对照。所有题目只使用 [4.1](sec41.md)、[4.2](sec42.md)、[4.3](sec43.md) 的概念与第一、二、三章先修知识。

本页 A、B、C 三组 30 题：A 组（12 题）、B 组（9 题）、C 组（9 题）。

| 组 | 定位 | 建议时长 | 卡壳时怎么办 |
|:--|:--|:--|:--|
| **A 组**（12 题） | 概念判断，口答即可 | 每题 1–2 分钟 | 直接看解答，回到对应小节的「即时自测」重读 |
| **B 组**（9 题） | 推理证明，需完整写出 | 每题 8–12 分钟 | 先看提示，再用 10 分钟；仍无思路才展开解答 |
| **C 组**（9 题） | 计算实操，注意验算 | 每题 5–8 分钟 | 看提示定位方法，算完**一定代回验证** |

::: note 关于「提示」层

B2、B5、B7、C2、C6、C8 这 6 题提供了折叠的「提示」——它只给**从哪里下手**，不给完整过程。先看提示、自己推完，再对照解答，学习效果远好于直接读解答。
:::

::: note 关于难度分布

A 组覆盖本章全部「辨析点」：范数三公理与反例（A1）、矩阵范数四公理与反例（A2）、相容与乘法相容的区别（A3、A10）、$\|I\|$ 与诱导范数（A6、A7）、谱半径与相似（A8）、谱范数与其它范数的比较（A9）、Weyl 与逆的估计（A11、A12）。

B 组以**两条主干证明**为重心：范数等价（B3、B4）与诱导范数定理（B8）；B1、B2 补「造范数」与「三角不等式的证明心脏」；B5、B6 补矩阵范数的两个反例 / 正例；B7 补酉不变性；B9 把定理 4.3.6 的反证法写完整。

C 组训练五件基本功：**三范数读数**（C1）、**椭圆范数与 Cholesky**（C2）、**等价常数取等**（C3）、**矩阵四范数**（C4、C6、C7）、**酉不变性验算**（C5）、**Neumann 级数与逆的界**（C8）、**Rayleigh 商**（C9）。4.4 及以后素材到位后，本页按同样的三组结构续写。
:::

## A 组 · 概念判断

::: ex A1 · 哪些是向量范数

判断下列函数在 $\mathbb R^2$ 上是不是范数，并说明理由：

(a) $\|x\|=|x_1|+2|x_2|$；(b) $\|x\|=|x_1-x_2|$；(c) $\|x\|=\max\{|x_1|,2|x_2|\}$；(d) $\|x\|=\big(\sqrt{|x_1|}+\sqrt{|x_2|}\big)^2$。

::: sol 解答

**(a) 是**。它是 $p=1$ 的加权版：正定显然；齐次显然；三角不等式逐项用 $|a+b|\le|a|+|b|$ 并乘权重。 （也可看作 $\|x\|=\|Dx\|_1$，$D=\operatorname{diag}(1,2)$，用 [4.1.3](sec41.md#sec-4.1.3) 的造法。）

**(b) 不是**。正定性失效：$x=(1,1)\ne\boldsymbol0$ 但 $\|x\|=0$。

**(c) 是**。它是 $\|Dx\|_\infty$，$D=\operatorname{diag}(1,2)$；三公理逐条验证（三角不等式：$\max\{|a_1+b_1|,2|a_2+b_2|\}\le\max\{|a_1|,2|a_2|\}+\max\{|b_1|,2|b_2|\}$）。

**(d) 不是**。齐次性失效：$\|2x\|=4\|x\|\ne2\|x\|$（取 $x=(1,0)$：$\|x\|=1$，$\|2x\|=(2\sqrt2)^2=8$，而 $2\|x\|=2$）。∎
:::
:::

::: ex A2 · 哪些是矩阵范数 {#ex-A2}

判断下列函数在 $2\times2$ 复矩阵上是不是矩阵范数：

(a) $\|A\|=\max\limits_{i,j}|a_{ij}|$；(b) $\|A\|=\sum\limits_{i,j}|a_{ij}|$；(c) $\|A\|_F$；(d) $\|A\|=|a_{11}|+|a_{22}|$。

::: sol 解答

**(a) 不是**：满足三条但不满足乘法相容（[反例](sec42.md#think-4.2-maxentry)：$A=\begin{bmatrix}1&0\\1&1\end{bmatrix}$、$B=\begin{bmatrix}-1&0\\-1&1\end{bmatrix}$，$\|AB\|_\infty=2\gt1$）。它是矩阵的向量范数。

**(b) 是**：见 [思考](sec42.md#think-4.2-sum) 的证明（交叉项非负）。

**(c) 是**：Frobenius 范数（[例 4.2.2](sec42.md#ex-4.2.2)）。

**(d) 不是**：正定性失效——$A=\begin{bmatrix}0&1\\0&0\end{bmatrix}\ne O$ 但 $\|A\|=0$。∎
:::
:::

::: ex A3 · 相容性判断 {#ex-A3}

判断下列「向量范数 $+$ 矩阵范数」是否相容：

(a) $\|\cdot\|_1$ 与 $\|\cdot\|_1$；(b) $\|\cdot\|_2$ 与 $\|\cdot\|_F$；(c) $\|\cdot\|_\infty$ 与 $\|\cdot\|_1$；(d) $\|\cdot\|_\infty$ 与 $\|\cdot\|_F$。

::: sol 解答

**(a) 相容**：$\|Ax\|_1\le\|A\|_1\|x\|_1$ 是 [定理 4.3.2](sec43.md#thm-4.3.2)（$\|\cdot\|_1$ 是诱导范数）的直接结论。

**(b) 相容**：正是 [例 4.3.1](sec43.md#ex-4.3.1)（[定理 4.2.3](sec42.md#thm-4.2.3)(3)）。

**(c) 不相容**。反例：$A=\begin{bmatrix}1&1\\0&0\\0&0\end{bmatrix}$，$\|A\|_1=\max\{1,1\}=1$；取 $x=(1,1)^{\mathrm T}$，$\|x\|_\infty=1$，$Ax=(2,0,0)^{\mathrm T}$，$\|Ax\|_\infty=2\gt1\cdot1$。

**(d) 不相容**。反例：$A=\begin{bmatrix}1&1\\0&0\end{bmatrix}$，$\|A\|_F=\sqrt2$；取 $x=(1,1)^{\mathrm T}$，$\|x\|_\infty=1$，$\|Ax\|_\infty=2\gt\sqrt2$。∎

**要点**：诱导范数与「同名的」向量范数一定相容；换名之后不一定——(c)(d) 的失败都来自「行和 / F-范数」与 $\|\cdot\|_\infty$ 不匹配。
:::
:::

::: ex A4 · 矩阵范数与向量相容 {#ex-A4}

判断：(a) 若 $\|\cdot\|_m$ 是矩阵范数，则对**任意**向量范数 $\|\cdot\|_v$ 都有 $\|Ax\|_v\le\|A\|_m\|x\|_v$；(b) 若 $\|\cdot\|_m$ 是矩阵范数，则**存在**向量范数与之相容。

::: sol 解答

**(a) 错**。[A3](exercises.md#ex-A3)(d) 就是反例：$\|\cdot\|_F$ 是矩阵范数，但与 $\|\cdot\|_\infty$ 不相容。

**(b) 对**：[定理 4.3.1](sec43.md#thm-4.3.1) 的构造 $\|x\|_v=\|x\alpha^{\mathrm T}\|_m$。**注意**：「存在」不等于「任意」——(a)(b) 的区别就是存在量词与全称量词的区别。∎
:::
:::

::: ex A5 · 幂零矩阵的范数

设 $A\ne O$ 是幂零矩阵（$A^k=O$）。证明：对任何矩阵范数，$\|A\|\gt0$；并说明如果允许 $\|AB\|\ge\|A\|\|B\|$，会推出什么矛盾。

::: sol 解答

$\|A\|\gt0$ 就是正定性（$A\ne O$）。若反向不等式成立，则

$$\|A\|^k\le\|A^k\|=\|O\|=0\ \Longrightarrow\ \|A\|=0 ,$$

与正定性矛盾（[注 1](sec42.md#note-4.2-nilpotent)）。∎

**要点**：这条矛盾链正是「乘法相容性不能反向」的原因。
:::
:::

::: ex A6 · $\|I\|$ 等于几 {#ex-A6}

判断：(a) 任何矩阵范数都满足 $\|I_n\|=1$；(b) 任何诱导范数都满足 $\|I_n\|=1$；(c) 一般矩阵范数满足 $\|I_n\|\ge1$。

::: sol 解答

**(a) 错**：$\|I_n\|_F=\sqrt n$；$n\ge2$ 时 $\ne1$。

**(b) 对**：$\|I\|=\max_{\|x\|=1}\|x\|=1$。

**(c) 对**：$\|I\|=\|I\cdot I\|\le\|I\|^2$，且 $\|I\|\gt0$，故 $\|I\|\ge1$（[注](sec43.md#note-4.3-identity)）。∎
:::
:::

::: ex A7 · 诱导范数的判别

判断：(a) $\|\cdot\|_F$ 是诱导范数；(b) 若 $\|\cdot\|$ 是诱导范数，则 $\|I\|=1$；(c) 由 (b) 能否反过来判断「$\|I\|\ne1$ $\Rightarrow$ 不是诱导范数」？

::: sol 解答

**(a) 错**：$A=I_n$ 时 $\|I_n\|_F=\sqrt n\ne1$，而诱导范数必须 $\|I_n\|=1$（[注 3′](sec43.md#note-4.3-hierarchy)）。

**(b) 对**（同 [A6](exercises.md#ex-A6)(b)）。

**(c) 能**。这是 (b) 的逆否命题：$\|I\|\ne1$ $\Rightarrow$ 不是诱导范数。**但只能用来否定**：$\|I\|=1$ 不能推出「是诱导范数」。∎
:::
:::

::: ex A8 · 相似与谱

判断：(a) 相似变换可以改变矩阵的谱半径；(b) 相似变换可以改变矩阵的范数；(c) 若 $\|A\|_m=\|P^{-1}AP\|$，则 $\|A\|_m$ 与 $\|A\|$ 可能相差很多。

::: sol 解答

**(a) 错**：相似矩阵特征值相同，谱半径不变。

**(b) 对**：范数依赖坐标；[例 4.2.C](sec42.md#ex-4.2.C) 中 $\|A\|_\infty=11$ 而 $\|P^{-1}AP\|_\infty=2$。

**(c) 对**：同上例，比值 $11/2$；相似只保谱，不保范数。∎
:::
:::

::: ex A9 · 谱范数与列和范数

判断：对任意 $m\times n$ 矩阵，(a) $\|A\|_2\le\|A\|_1$；(b) $\|A\|_2\le\sqrt n\|A\|_1$；(c) $\|A\|_2\le\|A\|_\infty$。

::: sol 解答

**(a) 错、(b) 对、(c) 错**。

**(a) 的反例**：取 $A$ 为 $2\times3$ 全 $1$ 矩阵，则 $\|A\|_1=\max\{2,2,2\}=2$；而 $A^{\mathrm T}A=2J_3$（每个元素等于行数 $2$），$\lambda_{\max}=2\cdot3=6$，故 $\|A\|_2=\sqrt6\approx2.449\gt2$。

**(c) 的反例**：取 $A$ 为 $3\times2$ 全 $1$ 矩阵，则 $\|A\|_\infty=\max\{2,2,2\}=2$；而 $A^{\mathrm T}A=3J_2$，$\lambda_{\max}=6$，故 $\|A\|_2=\sqrt6\approx2.449\gt2$。

**(b) 的证明**（本编补，两行）：

$$\|A\|_2^2=\rho(A^{\mathrm H}A)\le\|A^{\mathrm H}A\|_1\le\|A^{\mathrm H}\|_1\|A\|_1=\|A\|_\infty\|A\|_1\le n\|A\|_1^2 ,$$

其中 $\|A^{\mathrm H}\|_1=\|A\|_\infty$（共轭转置把列和换成行和），$\|A\|_\infty\le n\|A\|_1$（行和不超过总和，总和不超过「列数 $n$」乘最大列和）。开方即得。

**要点**：只有 $\|A\|_2\le\|A\|_F$ 是无条件成立的（[注 2](sec43.md#note-4.3-multi)）；与 $\|A\|_1$、$\|A\|_\infty$ 比较都要带维数常数。
:::
:::

::: ex A10 · 「配套」是否唯一

判断：(a) 与 $\|\cdot\|_2$ 相容的矩阵范数唯一；(b) 与给定矩阵范数相容的向量范数唯一；(c) 诱导范数是「与给定向量范数相容的矩阵范数」中最紧的一个。

::: sol 解答

**(a) 错**：$\|\cdot\|_2$ 与 $\|\cdot\|_F$ 都相容（[注 2](sec43.md#note-4.3-multi)）。

**(b) 错**：[定理 4.3.1](sec43.md#thm-4.3.1) 的 $\alpha$ 任取非零，给出无穷多个。

**(c) 对**：诱导范数的定义就是「所有 $\|x\|_v=1$ 上 $\|Ax\|_v$ 的最大值」，它是满足 $\|Ax\|_v\le C\|x\|_v$ 的最小常数 $C$。∎
:::
:::

::: ex A11 · Weyl 不等式的读法

判断：(a) Weyl 不等式给出 $\lambda_i(A+E)$ 的精确值；(b) 若 $\|E\|_2\le\varepsilon$，则 $|\lambda_i(A+E)-\lambda_i(A)|\le\varepsilon$；(c) 若 $E$ 半正定，则 $\lambda_i(A+E)\ge\lambda_i(A)$。

::: sol 解答

**(a) 错**：给的是区间（[例 4.3.C](sec43.md#ex-4.3.C) 实际位移 $0.118$，上界 $0.5$）。

**(b) 对**：Hermite 矩阵的 $\lambda_1(E)\le\|E\|_2$、$\lambda_n(E)\ge-\|E\|_2$，代入 [定理 4.3.5](sec43.md#thm-4.3.5) 即得。

**(c) 对**：半正定 $\Rightarrow\lambda_n(E)\ge0$，下界给出 $\lambda_i(A+E)\ge\lambda_i(A)$。∎
:::
:::

::: ex A12 · 逆的估计

判断：(a) $\|A\|\lt1$ 时 $I-A$ 一定可逆；(b) 此时 $\|(I-A)^{-1}\|\le\dfrac{1}{1-\|A\|}$ 对任何矩阵范数成立；(c) $\|A\|\lt1$ 时 $I+A$ 也可逆。

::: sol 解答

**(a) 对**（[定理 4.3.6](sec43.md#thm-4.3.6)）。

**(b) 错**：一般要写成 $\|I\|/(1-\|A\|)$；只有诱导范数才能取 $\|I\|=1$（[注](sec43.md#note-4.3-identity)）。

**(c) 对**：$\|-A\|=\|A\|\lt1$，对 $-A$ 用 (a)。∎
:::
:::

## B 组 · 推理证明

::: ex B1 · 证明加权 1-范数

证明 $\|x\|=|x_1|+2|x_2|$（$x\in\mathbb R^2$）是范数，并画出它的单位球。

::: sol 解答

**正定**：显然 $\ge0$；若 $|x_1|+2|x_2|=0$，则 $x_1=x_2=0$。

**齐次**：$|kx_1|+2|kx_2|=|k|(|x_1|+2|x_2|)$。

**三角**：

$$\|x+y\|=|x_1+y_1|+2|x_2+y_2|\le|x_1|+|y_1|+2|x_2|+2|y_2|=\|x\|+\|y\| .$$

**单位球**：$|x_1|+2|x_2|\le1$ 是菱形，四个顶点 $(\pm1,0)$、$(0,\pm\frac12)$——**在 $x_2$ 方向被压扁了一半**，这正是权重 $2$ 的几何表现。∎
:::
:::

::: ex B2 · 用 Cauchy–Schwarz 证 2-范数的三角不等式

不引用 Minkowski 不等式，直接用 Cauchy–Schwarz 证明 $\|x+y\|_2\le\|x\|_2+\|y\|_2$（复向量情形），并指出 Cauchy–Schwarz 用在哪一步。

::: hint 提示

先平方，把 $\|x+y\|_2^2$ 展开成三项；中间项取**实部**，再用 $\operatorname{Re}(x,y)\le|(x,y)|\le\|x\|_2\|y\|_2$。

::: sol 解答

$$\|x+y\|_2^2=(x+y,x+y)=\|x\|_2^2+2\operatorname{Re}(x,y)+\|y\|_2^2 .$$

由 Cauchy–Schwarz（[1.5](../ch01/sec15.md)），$\operatorname{Re}(x,y)\le|(x,y)|\le\|x\|_2\|y\|_2$，故

$$\|x+y\|_2^2\le\|x\|_2^2+2\|x\|_2\|y\|_2+\|y\|_2^2=(\|x\|_2+\|y\|_2)^2 .$$

两边开方即得。**Cauchy–Schwarz 用在中间项**；复向量必须先取实部，不能直接写 $(x,y)\le\|x\|\|y\|$（内积可能是复数）。∎
:::
:::

:::
::: ex B3 · 具体范数的等价常数

证明对任意 $x\in\mathbb C^n$：$\|x\|_\infty\le\|x\|_2\le\sqrt n\|x\|_\infty$，并说明两个常数都不能再小。

::: sol 解答

**左**：设 $|x_{i_0}|=\|x\|_\infty$，则 $\|x\|_2^2=\sum_i|x_i|^2\ge|x_{i_0}|^2=\|x\|_\infty^2$。

**右**：$\|x\|_2^2=\sum_i|x_i|^2\le n\|x\|_\infty^2$。

**不能更小**：取 $x=(1,0,\cdots,0)$，左式取等；取 $x=(1,\cdots,1)$，右式取等（$\sqrt n\cdot1=\sqrt n=\|x\|_2$）。∎
:::
:::

::: ex B4 · 左乘可逆矩阵造范数

设 $\|\cdot\|$ 是 $\mathbb C^n$ 上的范数，$P\in\mathbb C^{n\times n}$ 可逆。证明 $\|x\|'=\|Px\|$ 是范数；并说明例 4.1.4 是它的特例。

::: sol 解答

**正定**：$\|Px\|=0\iff Px=0\iff x=0$（$P$ 可逆）。
**齐次**：$\|P(kx)\|=|k|\|Px\|$。
**三角**：$\|P(x+y)\|=\|Px+Py\|\le\|Px\|+\|Py\|$。

**例 4.1.4 是特例**：$A$ 正定 Hermite $\Rightarrow A=B^{\mathrm H}B$，取 $P=B$、$\|\cdot\|=\|\cdot\|_2$，则 $\|x\|'=\|Bx\|_2=\sqrt{x^{\mathrm H}Ax}=\|x\|_A$。∎
:::
:::

::: ex B5 · 元素和范数是矩阵范数

证明 $\|A\|_{v1}=\sum_{i,j}|a_{ij}|$ 满足四条公理（重点是乘法相容性）。

::: hint 提示

把 $AB$ 的元素写成 $\sum_k a_{ik}b_{kj}$，先用三角不等式，再把求和改写成「按 $k$ 分组」。

::: sol 解答

前三条显然。相容性：

$$\|AB\|_{v1}=\sum_{i,j}\Big|\sum_k a_{ik}b_{kj}\Big|\le\sum_{i,j,k}|a_{ik}||b_{kj}|=\sum_k\Big(\sum_i|a_{ik}|\Big)\Big(\sum_j|b_{kj}|\Big) .$$

记 $c_k=\sum_i|a_{ik}|$、$d_k=\sum_j|b_{kj}|$，则右端 $=\sum_k c_kd_k\le\big(\sum_kc_k\big)\big(\sum_kd_k\big)=\|A\|_{v1}\|B\|_{v1}$，其中不等号因为展开后多出的 $c_kd_{k'}$（$k\ne k'$）都非负。∎

**对比**：把「和」换成「最大」就不成立（[A2](exercises.md#ex-A2)(a)）。∎
:::
:::

:::
::: ex B6 · Frobenius 范数的相容性

完整证明 $\|AB\|_F\le\|A\|_F\|B\|_F$（$A,B$ 为 $n$ 阶），并指出哪一步是 Cauchy–Schwarz。

::: sol 解答

记 $c_{ij}=\sum_k a_{ik}b_{kj}$。对每个 $(i,j)$：

$$|c_{ij}|^2=\Big|\sum_k a_{ik}b_{kj}\Big|^2\le\Big(\sum_k|a_{ik}|^2\Big)\Big(\sum_k|b_{kj}|^2\Big)\qquad(\text{Cauchy–Schwarz}) .$$

求和：

$$\|AB\|_F^2=\sum_{i,j}|c_{ij}|^2\le\sum_{i,j}\Big(\sum_k|a_{ik}|^2\Big)\Big(\sum_k|b_{kj}|^2\Big)=\Big(\sum_{i,k}|a_{ik}|^2\Big)\Big(\sum_{k,j}|b_{kj}|^2\Big)=\|A\|_F^2\|B\|_F^2 .$$

开方即得。**Cauchy–Schwarz 用在每个元素的估计上**；最后一步靠「可分离」把二重和拆成两个独立和的乘积。∎
:::
:::

::: ex B7 · 酉不变性

设 $U,V$ 是酉矩阵（同阶），证明 $\|UAV\|_F=\|A\|_F$。

::: hint 提示

用 $\|X\|_F^2=\operatorname{tr}(X^{\mathrm H}X)$，再把 $U^{\mathrm H}U=I$、$VV^{\mathrm H}=I$ 代进去，最后用迹的循环性 $\operatorname{tr}(XY)=\operatorname{tr}(YX)$。

::: sol 解答

$$\|UAV\|_F^2=\operatorname{tr}\big((UAV)^{\mathrm H}(UAV)\big)=\operatorname{tr}(V^{\mathrm H}A^{\mathrm H}U^{\mathrm H}UAV)=\operatorname{tr}(V^{\mathrm H}A^{\mathrm H}AV) .$$

由循环性 $\operatorname{tr}(V^{\mathrm H}A^{\mathrm H}AV)=\operatorname{tr}(A^{\mathrm H}AVV^{\mathrm H})=\operatorname{tr}(A^{\mathrm H}A)=\|A\|_F^2$。开方即得。∎

**推论**：$\|A\|_F^2=\sum_i\sigma_i^2$（取 $U,V$ 为奇异值分解的两侧）。
:::
:::

:::
::: ex B8 · 诱导范数定理

设 $\|\cdot\|_v$ 是 $\mathbb C^n$ 上的向量范数，$\|A\|=\max_{\|x\|_v=1}\|Ax\|_v$。证明 $\|\cdot\|$ 是矩阵范数且与 $\|\cdot\|_v$ 相容。

::: sol 解答

**最大值存在**：$\|Ax\|_v$ 是 $x$ 分量的连续函数，单位球面 $\{\|x\|_v=1\}$ 有界闭，故取到最大值（[注 1](sec43.md#note-4.3-existence)）。

**正定**：$\|A\|=0$ $\Rightarrow$ 单位球面上 $Ax=0$ $\Rightarrow$ 任意 $x\ne0$ 有 $A(x/\|x\|_v)=0$ $\Rightarrow A=O$。

**齐次**：$\|kA\|=\max\|kAx\|=|k|\max\|Ax\|$。

**三角**：取 $y$（$\|y\|=1$）使 $\|A+B\|=\|(A+B)y\|$，则 $\|A+B\|\le\|Ay\|+\|By\|\le\|A\|+\|B\|$。

**乘法**：取 $y$（$\|y\|=1$）使 $\|AB\|=\|ABy\|$；若 $By=0$ 显然，否则

$$\|AB\|=\Big\|A\frac{By}{\|By\|_v}\Big\|_v\|By\|_v\le\|A\|\,\|B\| .$$

**相容**：$x\ne0$ 时 $\|Ax\|_v=\|A(x/\|x\|_v)\|_v\|x\|_v\le\|A\|\|x\|_v$。∎
:::
:::

::: ex B9 · 逆矩阵定理的完整反证

证明：若 $\|A\|\lt1$（$\|\cdot\|$ 是任一矩阵范数），则 $I-A$ 可逆，且 $\|(I-A)^{-1}\|\le\dfrac{\|I\|}{1-\|A\|}$。指出哪一步必须用「相容的向量范数」。

::: sol 解答

**可逆**：反设不可逆，则存在 $x\ne0$ 使 $(I-A)x=0$，即 $x=Ax$。取与 $\|\cdot\|$ 相容的向量范数（[定理 4.3.1](sec43.md#thm-4.3.1)），则

$$\|x\|=\|Ax\|\le\|A\|\|x\|\lt\|x\| ,$$

矛盾。

**估计**：由 $(I-A)(I-A)^{-1}=I$ 得 $(I-A)^{-1}=I+A(I-A)^{-1}$，取范数：

$$\|(I-A)^{-1}\|\le\|I\|+\|A\|\|(I-A)^{-1}\|\ \Longrightarrow\ \|(I-A)^{-1}\|\le\frac{\|I\|}{1-\|A\|} .$$

**关键一步**：$\|x\|=\|Ax\|\le\|A\|\|x\|$ 必须有一个**与矩阵范数相容的向量范数**才能成立；这正是 [定理 4.3.1](sec43.md#thm-4.3.1) 的用处。∎
:::
:::

## C 组 · 计算实操

::: ex C1 · 一个向量的三种读数

设 $x=(3,-4,0)^{\mathrm T}$。计算 $\|x\|_1,\|x\|_2,\|x\|_\infty$，并验证 $\|x\|_\infty\le\|x\|_2\le\|x\|_1$。

::: sol 解答

$\|x\|_1=3+4+0=7$，$\|x\|_2=\sqrt{9+16+0}=5$，$\|x\|_\infty=\max\{3,4,0\}=4$。$4\le5\le7$ ✓。∎
:::
:::

::: ex C2 · 椭圆范数的 Cholesky 与半轴

设 $A=\begin{bmatrix}3&1\\1&3\end{bmatrix}$。(a) 求上三角 $B$ 使 $A=B^{\mathrm T}B$；(b) 写出 $\|x\|_A$ 的表达式；(c) 计算 $x=(1,-1)^{\mathrm T}$ 的 $\|x\|_A$ 与 $\|x\|_2$；(d) 写出单位球的主轴方向与半轴长。

::: hint 提示

Cholesky：$B=\begin{bmatrix}\sqrt{a_{11}}&a_{12}/\sqrt{a_{11}}\\0&\sqrt{a_{22}-a_{12}^2/a_{11}}\end{bmatrix}$；椭球半轴长是 $A$ 的特征值开方的倒数。

::: sol 解答

**(a)** $B=\begin{bmatrix}\sqrt3&1/\sqrt3\\0&\sqrt{3-1/3}\end{bmatrix}=\begin{bmatrix}\sqrt3&\frac{1}{\sqrt3}\\0&\sqrt{\frac83}\end{bmatrix}$，验证 $B^{\mathrm T}B=\begin{bmatrix}3&1\\1&3\end{bmatrix}$ ✓。

**(b)** $\|x\|_A=\sqrt{3x_1^2+2x_1x_2+3x_2^2}$。

**(c)** $\|(1,-1)\|_A=\sqrt{3-2+3}=2$；$\|(1,-1)\|_2=\sqrt2$。

**(d)** $A$ 的特征值为 $4$（方向 $(1,1)$）与 $2$（方向 $(1,-1)$）；故单位球主轴沿 $(1,1)$ 与 $(1,-1)$，半轴长分别为 $1/2$ 与 $1/\sqrt2$。∎
:::
:::

:::
::: ex C3 · 等价常数取等

在 $\mathbb R^2$ 中取 $x=(1,1)^{\mathrm T}$，验证 $\|x\|_\infty\le\|x\|_2\le\sqrt2\|x\|_\infty$ 与 $\|x\|_2\le\|x\|_1\le\sqrt2\|x\|_2$ 哪些取等。

::: sol 解答

$\|x\|_\infty=1$、$\|x\|_2=\sqrt2$、$\|x\|_1=2$。

- $\|x\|_2=\sqrt2=\sqrt2\|x\|_\infty$：**右端取等**；
- $\|x\|_1=2=\sqrt2\cdot\sqrt2=\sqrt2\|x\|_2$：**右端取等**；
- 左端 $\|x\|_\infty\le\|x\|_2$ 与 $\|x\|_2\le\|x\|_1$ 都严格（$1\lt\sqrt2\lt2$）。

**要点**：同一向量不可能让所有不等号同时取等；「常数是最坏情况」指每个常数都有某个向量使它取等（$x=(1,0)$ 让左端取等）。∎
:::
:::

::: ex C4 · 矩阵的元素型范数

设 $A=\begin{bmatrix}2&-1\\0&3\end{bmatrix}$。计算 $\|A\|_{v1},\|A\|_{v\infty},\|A\|_F$，并说明它们与 [例 4.3.2](sec43.md#ex-4.3.2) 的 $\|\cdot\|_1,\|\cdot\|_\infty$ 有何不同。

::: sol 解答

$\|A\|_{v1}=2+1+0+3=6$；$\|A\|_{v\infty}=3$；$\|A\|_F=\sqrt{4+1+0+9}=\sqrt{14}\approx3.742$。

**区别**：带下标 $v$ 的是「把矩阵拉直」的元素范数（[定义 4.2.1](sec42.md#def-4.2.1)）；不带下标的是**诱导范数**（[定理 4.3.3](sec43.md#thm-4.3.3)）——本例 $\|A\|_1=\max\{2+0,1+3\}=4$、$\|A\|_\infty=\max\{3,3\}=3$，与元素型读数不同。∎
:::
:::

::: ex C5 · 酉不变性的数值核对

设 $A=\begin{bmatrix}1&2\\3&4\end{bmatrix}$，$Q=\begin{bmatrix}0&-1\\1&0\end{bmatrix}$。验证 $Q$ 是正交阵，并计算 $\|QAQ^{\mathrm T}\|_F$。

::: sol 解答

$Q^{\mathrm T}Q=\begin{bmatrix}0&1\\-1&0\end{bmatrix}\begin{bmatrix}0&-1\\1&0\end{bmatrix}=I$ ✓。

$QA=\begin{bmatrix}0&-1\\1&0\end{bmatrix}\begin{bmatrix}1&2\\3&4\end{bmatrix}=\begin{bmatrix}-3&-4\\1&2\end{bmatrix}$，$QAQ^{\mathrm T}=\begin{bmatrix}-3&-4\\1&2\end{bmatrix}\begin{bmatrix}0&1\\-1&0\end{bmatrix}=\begin{bmatrix}4&-3\\-2&1\end{bmatrix}$。

$\|QAQ^{\mathrm T}\|_F^2=16+9+4+1=30=\|A\|_F^2$ ✓（$\|A\|_F^2=1+4+9+16=30$）。∎
:::
:::

::: ex C6 · 四个矩阵范数

设 $A=\begin{bmatrix}1&2\\3&4\end{bmatrix}$。计算 $\|A\|_1,\|A\|_\infty,\|A\|_F,\|A\|_2$，并验证 $\|A\|_2\le\|A\|_F$。

::: hint 提示

谱范数要算 $A^{\mathrm T}A$ 的特征值；$2\times2$ 用 $\lambda=\frac{\operatorname{tr}\pm\sqrt{\operatorname{tr}^2-4\det}}{2}$。

::: sol 解答

列和：$1+3=4$、$2+4=6$，故 $\|A\|_1=6$。行和：$1+2=3$、$3+4=7$，故 $\|A\|_\infty=7$。$\|A\|_F=\sqrt{30}\approx5.477$。

$A^{\mathrm T}A=\begin{bmatrix}10&14\\14&20\end{bmatrix}$，$\operatorname{tr}=30$、$\det=200-196=4$，故

$$\lambda_{\max}=\frac{30+\sqrt{900-16}}{2}=\frac{30+\sqrt{884}}{2}=15+\sqrt{221}\approx29.866,$$

$\|A\|_2=\sqrt{15+\sqrt{221}}\approx5.465$。

验证：$5.465\le5.477$ ✓，且严格不等（$\operatorname{rank}A=2$，[注 2](sec43.md#note-4.3-multi)）。∎
:::
:::

:::
::: ex C7 · 正规矩阵的谱范数

设 $A=\operatorname{diag}(2,-3)$。计算四个范数，并说明为什么 $\|A\|_2=\rho(A)$。

::: sol 解答

$\|A\|_1=\max\{2,3\}=3$，$\|A\|_\infty=\max\{2,3\}=3$，$\|A\|_2=3$，$\|A\|_F=\sqrt{4+9}=\sqrt{13}\approx3.606$。

**为什么**：$A$ 正规（实对称），$A^{\mathrm H}A=\operatorname{diag}(4,9)$，$\lambda_{\max}=9$，故 $\|A\|_2=3=\rho(A)$。**一般矩阵没有这个等号**（$\rho(A)\le\|A\|_2$，见 [例 4.3.A](sec43.md#ex-4.3.A) 的 $1.618\gt\rho=1$——那里 $\rho\lt\|A\|_2$）。∎
:::
:::

::: ex C8 · Neumann 级数与逆的界

设 $A=\begin{bmatrix}0&\frac13\\\frac13&0\end{bmatrix}$。(a) 用 $\|\cdot\|_\infty$ 验证 $\|A\|\lt1$；(b) 求 $(I-A)^{-1}$ 并算其 $\infty$-范数；(c) 与 [定理 4.3.6](sec43.md#thm-4.3.6) 的界比较；(d) 用 $I+A$ 近似，算误差。

::: hint 提示

$\|A\|_\infty$ 是行和的最大值；$(I-A)^{-1}$ 用 $2\times2$ 求逆公式，注意 $\det=\frac89$。

::: sol 解答

**(a)** 行和都是 $\frac13$，故 $\|A\|_\infty=\frac13\lt1$。

**(b)** $I-A=\begin{bmatrix}1&-\frac13\\-\frac13&1\end{bmatrix}$，$\det=\frac89$，

$$(I-A)^{-1}=\frac98\begin{bmatrix}1&\frac13\\\frac13&1\end{bmatrix}=\begin{bmatrix}\frac98&\frac38\\\frac38&\frac98\end{bmatrix},\qquad \|(I-A)^{-1}\|_\infty=\frac{12}{8}=\frac32 .$$

**(c)** 界 $\dfrac{\|I\|_\infty}{1-\|A\|_\infty}=\dfrac{1}{2/3}=\dfrac32$，**恰好取等**（因为 $\infty$-范数是算子范数，且最大行和同时达到）。

**(d)** 误差 $=(I-A)^{-1}-(I+A)=\begin{bmatrix}\frac18&\frac1{24}\\\frac1{24}&\frac18\end{bmatrix}$，$\infty$-范数 $=\frac18+\frac1{24}=\frac16\approx0.167$；级数界 $\dfrac{\|A\|^2}{1-\|A\|}=\dfrac{1/9}{2/3}=\dfrac16$，也恰好取等。∎

**要点**：本题是少见的「界取等」的例子——因为 $A$ 的两行同号、且 $\|A\|_\infty$ 的最大行在整个级数中保持一致。
:::
:::

:::
::: ex C9 · Rayleigh 商的三个读数

设 $A=\begin{bmatrix}4&1\\1&4\end{bmatrix}$。(a) 求特征值；(b) 计算 $R(1,0)$、$R(1,1)$、$R(1,-1)$；(c) 验证 $\lambda_2\le R\le\lambda_1$。

::: sol 解答

**(a)** $\det(\lambda I-A)=(\lambda-4)^2-1=(\lambda-3)(\lambda-5)$，故 $\lambda_1=5$、$\lambda_2=3$。

**(b)** $R(1,0)=\frac41=4$；$R(1,1)=\frac{4+1+1+4}{2}=5$；$R(1,-1)=\frac{4-1-1+4}{2}=3$。

**(c)** $3\le4,5,3\le5$ ✓；$(1,1)$、$(1,-1)$ 分别是 $\lambda_1,\lambda_2$ 的特征向量，取等（[推论 4.3.1](sec43.md#cor-4.3.1)）。∎
:::
:::
