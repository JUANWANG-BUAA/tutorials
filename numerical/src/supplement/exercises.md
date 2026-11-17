# 补充篇 · 习题集

> 本页属“补充篇 · 数值线性代数工具箱”，不是课堂第 2 章；课堂第 2 章见[线性方程组的解法](../course/ch02/overview.md)。

本篇习题按难度分四组：A 组概念判断、B 组推导证明、C 组计算与编程、D 组开放建模，均附解答或提示，C 组另给验收标准。使用第一章与本补充篇的概念；带图的报告还需自行选择绘图工具。编程题的旧输出保留作比较，不是逐位验收基准；应记录随机种子、浮点类型、范数、平台和库版本。

## A 组 · 概念判断

::: ex A1 · 内积、正交与正交矩阵

判断对错并说明理由：
(a) 若 $\lVert\boldsymbol{x}\rVert_2=\lVert\boldsymbol{y}\rVert_2=1$ 且 $\boldsymbol{x}\neq\boldsymbol{y}$，则 $\boldsymbol{x},\boldsymbol{y}$ 正交；
(b) $\mathbb{R}^n$ 上任一范数都由某个内积诱导；
(c) 长方阵 $Q\in\mathbb{R}^{m\times n}$（$m\gt n$）满足 $Q^{\mathrm T}Q=I_n$，则 $QQ^{\mathrm T}=I_m$；
(d) 两个正交矩阵之和仍是正交矩阵。

::: sol 解答

**本题在考**：内积与范数的分工——范数要满足什么条件才来自内积，「标准」与「正交」又为什么是两件事。

**(a) 错。** 取 $x=(1,0)^{\mathrm T}$、$y=(\cos\theta,\sin\theta)^{\mathrm T}$，例如 $\theta=60^{\circ}$，两者不同且范数均为 1，而内积为 $1/2\ne0$。“标准”只要求单位长度，“正交”还须内积为零（[例 2.1.3](sec21.md#sup-2.1.3)）。

**(b) 错。** 只有满足平行四边形恒等式（2.2）的范数才来自内积（[@thm-sup-2.1.2]）。维数至少为 2 时 $\|\cdot\|_1$ 与 $\|\cdot\|_\infty$ 不满足它（[@ex-sup-2.1.2]）；仍可另选 Euclid 内积来定义正交和 SVD，但不能把它们说成由这两个范数诱导。

**(c) 错。** $Q^{\mathrm T}Q=I_n$ 只说明列标准正交。$QQ^{\mathrm T}$ 是 $\mathbb{R}^m$ 上的**投影矩阵**（投影到 $C(Q)$ 上），$\operatorname{tr}(QQ^{\mathrm T})=n\lt m$，故 $QQ^{\mathrm T}\neq I_m$（[@thm-sup-2.2.5]、[2.1.4](sec21.md#sup-2.1.4) 常见错误 4）。

**(d) 错。** 反例：$I+(-I)=O$，零矩阵不正交（$\lVert O\rVert_2=0$，且 $OO^{\mathrm T}\neq I$）。更一般地，正交矩阵对加法不封闭（对乘法才封闭：$(Q_1Q_2)^{\mathrm T}(Q_1Q_2)=I$）。

:::

:::

::: ex A2 · 投影与最小二乘

判断对错并说明理由：
(a) 若 $A\in\mathbb{R}^{m\times n}$，则 $A^{\mathrm T}A$ 一定可逆；
(b) $P$ 是正交投影矩阵 $\iff$ $P^2=P$；
(c) 最小二乘解总是存在且唯一；
(d) $\lVert\boldsymbol{r}\rVert_2$ 很小意味着 $\hat{\boldsymbol{x}}$ 很接近真解。

::: sol 解答

**本题在考**：最小二乘解的**存在性**与**唯一性**各需要什么条件，以及「残差小」为什么推不出「解准」。

**(a) 错。** $A^{\mathrm T}A$ 可逆 $\iff$ $A$ 列满秩（[@thm-sup-2.2.5] 证明第一段）。若 $A$ 列相关（如 $A=\begin{pmatrix}1&2\\2&4\end{pmatrix}$），$A^{\mathrm T}A$ 奇异。

**(b) 错。** 正交投影 $\iff$ **对称** + 幂等。只幂等的是**斜投影**，它的余项不与子空间垂直。反例：$S=\begin{pmatrix}1&1\\0&0\end{pmatrix}$ 满足 $S^2=S$ 但 $S^{\mathrm T}\neq S$（[2.2.6](sec22.md#sup-2.2.6) 常见错误 5）。

**(c) 前半对、后半错。** 最小二乘解**总存在**（正态方程的右端 $A^{\mathrm T}\boldsymbol{b}\in C(A^{\mathrm T})=C(A^{\mathrm T}A)$，[@thm-sup-2.2.6]）；但**唯一 $\iff$ $A$ 列满秩**。秩亏时解成一整个集合（仿射子空间），此时「最小范数解」才唯一——由伪逆给出（[@thm-sup-2.6.3]、[例 2.6.5](sec26.md#sup-2.6.5)）。

**(d) 错。** 对非奇异方阵且 $b\ne0$，有 $\|e\|/\|x\|\le\mathrm{cond}(A)\|r\|/\|b\|$（[@thm-sup-2.4.4]）；病态时小残差可与大误差共存。一般不相容最小二乘问题的最优残差本来可以非零，不能不加条件地套用方程组的这条界。

:::

:::

::: ex A3 · 正交化方法

判断对错并说明理由：
(a) 经典 Gram–Schmidt 与修正 Gram–Schmidt 在浮点下结果相同；
(b) Householder 反射的行列式是 $1$；
(c) 稀疏矩阵适合用 Householder 做 QR；
(d) QR 分解唯一。

::: sol 解答

**本题在考**：三种正交化方法各自的适用场景与浮点行为——精确算术下相同，不代表浮点下也相同，分解的唯一性也只在规范形式下成立。

**(a) 错。** 精确算术下两者给出**完全相同**的 $Q,R$，但浮点下 CGS 的正交性损失是 $O(\mathrm{cond}^2u)$、MGS 是 $O(\mathrm{cond}\,u)$——**差一个条件数**（[2.3.3](sec23.md#sup-2.3.3) 实测：$n=16$ 时 $6.55$ vs $4.7\times10^{-4}$）。

**(b) 错。** $\det H=-1$（$H$ 的特征值是 $-1$ 与 $k-1$ 重的 $1$，[@thm-sup-2.3.3]）。**$H$ 是反射（反定向）**；$\det=+1$ 的是 Givens 旋转（[@def-sup-2.3.2]）。

**(c) 不能一概而论。** Householder 可能引起填充；Givens 只作用于两行，适合某些结构或逐行更新，但也可能引起填充。实际稀疏 QR 也广泛使用带排序的 Householder，选择取决于结构与实现，不能只凭“稀疏”二字排除它。

**(d) 错。** 对列满秩矩阵的经济型 QR，规定 $R$ 对角元为正才唯一；否则可同时改变 $Q$ 列与 $R$ 行的符号。满 QR 中正交补的基仍可变化，秩亏时也不能照用该唯一性结论。

:::

:::

::: ex A4 · 条件数、谱半径与 SVD

判断对错并说明理由：
(a) $\mathrm{cond}(A)$ 只依赖 $A$ 是否接近奇异，与行列向量的整体尺度无关；
(b) $\rho(A)=\lVert A\rVert_2$ 对任何矩阵成立；
(c) $\mathrm{cond}_2(A)=\sigma_1/\sigma_{\min}$ 对**长方形**矩阵也成立（$A\in\mathbb{R}^{m\times n}$ 列满秩）；
(d) 若 $\rho(A)\lt1$，则 $\lVert A^k\rVert_2$ 单调递减到零。

::: sol 解答

**本题在考**：条件数、谱半径与奇异值三者的适用范围——涉及它们的关系式，大都是「在特定假设下」才成立的等式。

**(a) 需限定范数和比较方式。** $\mathrm{cond}(cA)=\mathrm{cond}(A)$（$c\ne0$），但各方向的相对尺度也会影响条件数。例如 $\operatorname{diag}(1,M)$ 的两列正交，条件数仍可随 $M$ 增大。2-范数条件数是到奇异矩阵相对距离的倒数。

**(b) 错。** 正规矩阵保证 $\rho(A)=\|A\|_2$，但这不是取等的必要条件。反例 $N=\begin{pmatrix}1&1000\\0&1\end{pmatrix}$ 的 $\rho=1$ 而 $\|N\|_2\approx1000$；一般只有 $\rho\le\|A\|$（[2.5.1](sec25.md#sup-2.5.1)）。

**(c) 对，但须定义。** 列满秩矩阵可定义 $\mathrm{cond}_2(A)=\|A\|_2\|A^+\|_2=\sigma_1/\sigma_n$，此时 $m\ge n$。它度量 $A$ 在输入空间到列空间之间的伸缩比；不能因此声称一般不相容最小二乘对 $A,b$ 的全部相对敏感性都仅由这个数给出，后者还依赖残差与数据方向。

**(d) 错（不成立）。** $\rho(A)\lt1$ 只保证 $\lVert A^k\rVert\to0$（**渐近**），不保证**单调**递减——非正规矩阵存在「瞬态增长」（[例 2.5.6](sec25.md#sup-2.5.6)）。反例：$\begin{pmatrix}0.9&10\\0&0.9\end{pmatrix}$ 的 $\rho=0.9$，但 $\lVert A^1\rVert$ 可以很大。**稳妥判据：$\lVert A\rVert\lt1$ 才保证每一步收缩。**

:::

:::

## B 组 · 推导证明

::: ex B1 · 正交矩阵的等价刻画（补全定理 2.1.5 剩余条款）

补全 [@thm-sup-2.1.5] 中未证明的等价关系，具体是三件事：由 $Q$ 的行向量组标准正交推出 $Q^{\mathrm T}Q=I$；补齐「由 $\lVert Q\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_2$（对一切 $\boldsymbol{x}$）推出 $Q^{\mathrm T}Q=I$」的代数细节；以及证明「上三角且正交的矩阵必为对角阵，对角元为 $\pm1$」。

::: sol 解答

**行标准正交 $\Rightarrow Q^{\mathrm T}Q=I$：** 行标准正交即 $QQ^{\mathrm T}=I$（逐元素是行内积 $=\delta_{ij}$）。由 $QQ^{\mathrm T}=I$ 得 $Q$ 可逆（$\det Q\cdot\det Q^{\mathrm T}=1$），左乘 $Q^{-1}$：$Q^{\mathrm T}=Q^{-1}$。再右乘 $Q$ 得 $Q^{\mathrm T}Q=I$ ✓。

**$\lVert Q\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_2\ \forall\boldsymbol{x}\Rightarrow Q^{\mathrm T}Q=I$：** 两边平方：$\boldsymbol{x}^{\mathrm T}Q^{\mathrm T}Q\boldsymbol{x}=\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 对一切 $\boldsymbol{x}$，即 $\boldsymbol{x}^{\mathrm T}S\boldsymbol{x}=0$ 对一切 $\boldsymbol{x}$，其中 $S=Q^{\mathrm T}Q-I$ **对称**。

- 取 $\boldsymbol{x}=\boldsymbol{e}_i$：$s_{ii}=0$；
- 取 $\boldsymbol{x}=\boldsymbol{e}_i+\boldsymbol{e}_j$（$i\neq j$）：$s_{ii}+2s_{ij}+s_{jj}=0$，代入 $s_{ii}=s_{jj}=0$ 得 $2s_{ij}=0$。

故 $S=O$，即 $Q^{\mathrm T}Q=I$ ✓。（这个「用对称性 + 特殊向量取极化」的技巧是标准套路。）

**上三角 + 正交 $\Rightarrow$ 对角、对角元 $\pm1$：** 设 $S$ 为上三角矩阵且 $S^{\mathrm T}S=I$（这里的 $S$ 是新记号，与上一段无关）。看 $S$ 的第 1 列 $\boldsymbol{s}_1$：上三角给 $s_{21}=\cdots=s_{n1}=0$，单位向量给 $\lvert s_{11}\rvert=1$。**归纳：** 设第 $1,\dots,k-1$ 列已证是 $\pm\boldsymbol{e}_1,\dots,\pm\boldsymbol{e}_{k-1}$。第 $k$ 列只有前 $k$ 个分量可能非零（上三角），且要与 $\boldsymbol{s}_i=\pm\boldsymbol{e}_i$（$i\lt k$）正交，故 $s_{1k}=\cdots=s_{k-1,k}=0$，再由单位向量得 $\lvert s_{kk}\rvert=1$。故 $S$ 是对角、对角元 $\pm1$ ✓。（这正是 [@thm-sup-2.3.2] 唯一性证明的关键一步。）

:::

:::

::: ex B2 · 对称矩阵的谱定理

证明：实对称矩阵的全部特征值为实数，且存在正交矩阵 $V$ 使 $V^{\mathrm T}AV=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$。要求补齐“存在足够多特征向量”这一步；可用正交补不变性作归纳，不必预先使用 Schur 定理。

::: sol 解答

**特征值实：** 设 $A\boldsymbol{v}=\lambda\boldsymbol{v}$，$\boldsymbol{v}\in\mathbb{C}^n$ 非零。两边左乘 $\overline{\boldsymbol{v}}^{\mathrm T}$（共轭转置）：

$$\overline{\boldsymbol{v}}^{\mathrm T}A\boldsymbol{v}=\lambda\overline{\boldsymbol{v}}^{\mathrm T}\boldsymbol{v}=\lambda\lVert\boldsymbol{v}\rVert_2^2 .$$

两边取共轭转置，用 $A^{\mathrm T}=A$、$\overline{A}=A$：

$$\overline{\boldsymbol{v}}^{\mathrm T}A^{\mathrm T}\boldsymbol{v}=\overline{\lambda}\lVert\boldsymbol{v}\rVert_2^2\quad\Longrightarrow\quad\overline{\boldsymbol{v}}^{\mathrm T}A\boldsymbol{v}=\overline{\lambda}\lVert\boldsymbol{v}\rVert_2^2 .$$

两式相减：$(\lambda-\overline{\lambda})\lVert\boldsymbol{v}\rVert_2^2=0$。由 $\boldsymbol{v}\neq\boldsymbol{0}$ 得 $\lambda=\overline{\lambda}$，即 $\lambda\in\mathbb{R}$ ✓。

**不同特征值的特征向量正交：** 设 $A\boldsymbol{v}_1=\lambda_1\boldsymbol{v}_1$、$A\boldsymbol{v}_2=\lambda_2\boldsymbol{v}_2$，$\lambda_1\neq\lambda_2$（都实）。则

$$\lambda_1\boldsymbol{v}_1^{\mathrm T}\boldsymbol{v}_2=(A\boldsymbol{v}_1)^{\mathrm T}\boldsymbol{v}_2=\boldsymbol{v}_1^{\mathrm T}A\boldsymbol{v}_2=\lambda_2\boldsymbol{v}_1^{\mathrm T}\boldsymbol{v}_2\ \Longrightarrow\ (\lambda_1-\lambda_2)\boldsymbol{v}_1^{\mathrm T}\boldsymbol{v}_2=0\ \Longrightarrow\ \boldsymbol{v}_1\perp\boldsymbol{v}_2 .$$

**正交补不变，补齐存在性。** 已证某个特征值 $\lambda$ 为实数。由于 $A-\lambda I$ 为实矩阵，复特征向量的实部、虚部至少有一个是非零实特征向量；将其单位化为 $u$。若 $z\perp u$，则 $u^{\mathrm T}Az=(Au)^{\mathrm T}z=\lambda u^{\mathrm T}z=0$，所以 $u^\perp$ 在 $A$ 下不变。在 $u^\perp$ 的任意标准正交基下，限制算子仍由实对称的 $(n-1)\times(n-1)$ 矩阵表示；对维数归纳，得到该空间的一组标准正交特征基，加上 $u$ 即得到所需的 $V$。

**重特征值也包括在内。** 上述归纳得到 $n$ 个标准正交特征向量，故每个重特征值的特征子空间维数等于其代数重数；可在该空间内任选标准正交基。

**与 Schur 形式的关系：** 对本题谱全实的矩阵，也可用实上三角 Schur 形式。但一般实方阵只保证实的块上三角 Schur 形式，可能含 $2\times2$ 块；不能说所有实方阵都能由实正交变换化成上三角阵。

:::

:::

::: ex B3 · 投影矩阵的性质与秩

设 $A\in\mathbb{R}^{m\times n}$ 列满秩，$P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$。证明：
(1) $P^{\mathrm T}=P$、$P^2=P$；
(2) $\operatorname{tr}P=\operatorname{rank}P=n$；
(3) 对任意 $\boldsymbol{b}$，$\lVert P\boldsymbol{b}\rVert_2\le\lVert\boldsymbol{b}\rVert_2$，且 $\lVert P\rVert_2=1$；
(4) $I-P$ 是到 $N(A^{\mathrm T})$ 上的正交投影。

::: sol 解答

**(1)** $(A(A^{\mathrm T}A)^{-1}A^{\mathrm T})^{\mathrm T}=A((A^{\mathrm T}A)^{-1})^{\mathrm T}A^{\mathrm T}=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$（$A^{\mathrm T}A$ 对称 $\Rightarrow$ 其逆对称）✓。$P^2=A(A^{\mathrm T}A)^{-1}(A^{\mathrm T}A)(A^{\mathrm T}A)^{-1}A^{\mathrm T}=P$ ✓。

**(2)** $P$ 对称 $\Rightarrow$ 可正交对角化（[@thm-sup-2.5.1] 第 5 条）；幂等 $\Rightarrow$ 特征值 $\in\{0,1\}$（$\lambda^2=\lambda$）。故 $\operatorname{tr}P=\operatorname{rank}P=$ 非零特征值个数 $=\dim C(P)=n$（因为 $C(P)=C(A)$：$P$ 把 $\boldsymbol{b}$ 投到 $C(A)$ 上，且 $P$ 在 $C(A)$ 上是恒等映射）。

**(3)** 由 $\boldsymbol{b}=P\boldsymbol{b}+(I-P)\boldsymbol{b}$ 与 $P\boldsymbol{b}\perp(I-P)\boldsymbol{b}$（验证：$(P\boldsymbol{b})^{\mathrm T}(I-P)\boldsymbol{b}=\boldsymbol{b}^{\mathrm T}P(I-P)\boldsymbol{b}=\boldsymbol{b}^{\mathrm T}(P-P^2)\boldsymbol{b}=0$）得勾股：

$$\lVert\boldsymbol{b}\rVert_2^2=\lVert P\boldsymbol{b}\rVert_2^2+\lVert(I-P)\boldsymbol{b}\rVert_2^2\ \Longrightarrow\ \lVert P\boldsymbol{b}\rVert_2\le\lVert\boldsymbol{b}\rVert_2 .$$

取 $\boldsymbol{b}\in C(A)$ 时 $P\boldsymbol{b}=\boldsymbol{b}$，故 $\lVert P\rVert_2\ge1$；结合上式得 $\lVert P\rVert_2=1$ ✓。

**(4)** $I-P$ 对称（(1)）、幂等（$(I-P)^2=I-2P+P^2=I-P$），故是正交投影。其列空间：$(I-P)\boldsymbol{b}=\boldsymbol{b}-P\boldsymbol{b}\in N(A^{\mathrm T})$ ✓（因为 $A^{\mathrm T}(I-P)=A^{\mathrm T}-A^{\mathrm T}A(A^{\mathrm T}A)^{-1}A^{\mathrm T}=A^{\mathrm T}-A^{\mathrm T}=O$）；反过来任意 $\boldsymbol{y}\in N(A^{\mathrm T})$ 满足 $(I-P)\boldsymbol{y}=\boldsymbol{y}$。故 $C(I-P)=N(A^{\mathrm T})$ ✓。

:::

:::

::: ex B4 · 伪逆的 Penrose 四条件的唯一性

证明：满足 $AXA=A$、$XAX=X$、$(AX)^{\mathrm T}=AX$、$(XA)^{\mathrm T}=XA$ 的矩阵 $X$ 唯一（即 $A^{+}=V\Sigma^{+}U^{\mathrm T}$ 是唯一解）。然后验证 $V\Sigma^{+}U^{\mathrm T}$ 确实满足四条件。

::: sol 解答

**存在性（验证 $X=V\Sigma^{+}U^{\mathrm T}$）：** 关键恒等式：$\Sigma\Sigma^{+}\Sigma=\Sigma$、$\Sigma^{+}\Sigma\Sigma^{+}=\Sigma^{+}$、$\Sigma\Sigma^{+}$ 与 $\Sigma^{+}\Sigma$ 都是（对称的）对角 $\{0,1\}$ 阵。于是

$$AXA=U\Sigma V^{\mathrm T}\cdot V\Sigma^{+}U^{\mathrm T}\cdot U\Sigma V^{\mathrm T}=U\Sigma\Sigma^{+}\Sigma V^{\mathrm T}=U\Sigma V^{\mathrm T}=A\ ✓$$

（用了 $V^{\mathrm T}V=I$、$U^{\mathrm T}U=I$）；同法 $XAX=X$ ✓。

$$AX=U\Sigma\Sigma^{+}U^{\mathrm T}\ \text{对称（对角 $\{0,1\}$、$U$ 正交）}\ ✓,\qquad XA=V\Sigma^{+}\Sigma V^{\mathrm T}\ \text{对称}\ ✓ .$$

**唯一性：** 设 $X_1,X_2$ 都满足四条件。记 $P=AX_1$、$Q=AX_2$（都对称且幂等，是到 $C(A)$ 上的投影）：

$$AX_1=AX_2\quad\text{（因为二者都是到 }C(A)\text{ 的正交投影，投影到同一子空间的幂等对称矩阵唯一）}.$$

同理，$X_iA$ 对称幂等，其零空间为 $N(A)$：一方面 $Az=0$ 蕴含 $X_iAz=0$，另一方面 $X_iAz=0$ 蕴含 $Az=AX_iAz=0$。因此 $X_iA$ 是到 $N(A)^\perp=C(A^{\mathrm T})$ 的正交投影，得到 $X_1A=X_2A$。

现在同时使用两个投影的唯一性：

$$X_1=X_1AX_1=X_1AX_2=X_2AX_2=X_2.$$

第一、最后一步用 $X_iAX_i=X_i$，中间依次用 $AX_1=AX_2$ 与 $X_1A=X_2A$。这样不需要未完成的连乘或转置猜测，唯一性得证。

:::

:::

::: ex B5 · 残差与误差的方向

设 $A$ 非奇异，$b\ne0$，$x$ 是精确解，$\hat x$ 是近似解，$r=b-A\hat x$，$e=\hat x-x$。统一使用同一向量范数及其诱导矩阵范数，证明

$$\text{(i)}\quad\lVert\boldsymbol{r}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{e}\rVert,\qquad
\text{(ii)}\quad\frac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\cdot\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert},$$

并说明为什么这**两条的方向不对称**，「残差小」不能单独作为「解准」的判据。

::: sol 解答

**（i）** 由 $\boldsymbol{b}=A\boldsymbol{x}$ 与 $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$ 得 $\boldsymbol{r}=A(\boldsymbol{x}-\hat{\boldsymbol{x}})=-A\boldsymbol{e}$，取范数并使用相容性：

$$\lVert\boldsymbol{r}\rVert=\lVert A\boldsymbol{e}\rVert\le\lVert A\rVert\lVert\boldsymbol{e}\rVert .$$

**（ii）** 由 $\boldsymbol{r}=-A\boldsymbol{e}$ 得 $\boldsymbol{e}=-A^{-1}\boldsymbol{r}$，故 $\lVert\boldsymbol{e}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol{r}\rVert$。又由 $\boldsymbol{b}=A\boldsymbol{x}$ 得 $\lVert\boldsymbol{b}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$，即 $\dfrac{1}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}$。两式相乘：

$$\frac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\lVert A^{-1}\rVert\lVert\boldsymbol{r}\rVert\cdot\frac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}=\mathrm{cond}(A)\cdot\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\ ✓$$

**方向与尺度。** 固定 $A$ 时，两条不等式的系数都是有限的；在不同矩阵之间，$\|A\|$ 与 $\|A^{-1}\|$ 都可能很大，不能把前者一概称为“有界”、后者称为“无界”。真正尺度不变的比较是相对残差乘条件数。求解器报告小残差只说明近似满足方程；若相对残差为 $10^{-16}$、条件数为 $10^{12}$，上述精确残差界给出相对解误差不超过 $10^{-4}$，并不说误差恰等于这个数。

**补充（换成近似解作分母）。** 记 $\beta=\mathrm{cond}(A)\|r\|/\|b\|$。由（ii）已有 $\|e\|/\|x\|\le\beta$，无需修正。若 $\beta<1$，则 $\|\hat x\|\ge\|x\|-\|e\|\ge(1-\beta)\|x\|$，所以

$$\frac{\|e\|}{\|\hat x\|}\le\frac{\beta}{1-\beta}.$$

分母修正来自参考向量由真解换为近似解，不是原界失效；条件 $\beta<1$ 也不等价于条件数本身小。

详见 [@thm-sup-2.4.4] 与 [例 2.4.4](sec24.md#sup-2.4.4)（那里实测了残差 $2.5\times10^{-12}$ 而误差 $50\%$ 的极端情形）。

:::

:::

::: ex B6 · Eckart–Young 的 Frobenius 版本

证明（2.35）：$\displaystyle\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_F=\sqrt{\sigma_{k+1}^2+\cdots+\sigma_r^2}$，最小值由 $A_k$ 达到。提示：展开 $\|A-B\|_F^2$，使用 von Neumann 迹不等式；逐个奇异值的谱范数误差界不足以直接得到平方和界。

::: sol 解答

**上界（$A_k$ 达到）：** $A-A_k=\sum_{i\gt k}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$ 的奇异值是 $\sigma_{k+1},\dots,\sigma_r$（其余为零），故

$$\lVert A-A_k\rVert_F^2=\sum_{i\gt k}\sigma_i^2=\sigma_{k+1}^2+\cdots+\sigma_r^2 .$$

**下界。** 记 $p=\min(m,n)$，$a_i=\sigma_i(A)$、$b_i=\sigma_i(B)$，均降序排列。迹不等式（[@ex-sup-2.6.4]）给出

$$\begin{aligned}
\|A-B\|_F^2
&=\sum_{i=1}^p a_i^2+\sum_{i=1}^p b_i^2-2\operatorname{tr}(A^{\mathrm T}B)\\
&\ge\sum_{i=1}^p(a_i-b_i)^2
\ge\sum_{i>k}a_i^2,
\end{aligned}$$

最后一步用 $\operatorname{rank}B\le k$，故 $b_i=0$（$i>k$）。与上界合起来即得结论。这个平方和不等式由迹不等式推出，不是把 $|a_i-b_i|\le\|A-B\|_2$ 对 $i$ 相加；对 $A^{\mathrm T}A$、$B^{\mathrm T}B$ 使用 Weyl 再开方也不能直接得到所需形式。

两种范数的最优误差值不同，但同一个 $A_k$ 都能达到最小值。F-范数的尾部平方和界通常强于仅保留 $\sigma_{k+1}$ 的下界；最优矩阵的唯一性须按范数与边界谱间隙分别讨论（见 [2.6.7](sec26.md#sup-2.6.7)）。

:::

:::

## C 组 · 计算与编程

::: ex C1 · 手算 SVD 与四个子空间

对

$$A=\begin{pmatrix}2&2\\-1&1\\1&1\end{pmatrix}.$$

(1) 手算 $A^{\mathrm T}A$ 与其特征值，写出全部奇异值与 $\lVert A\rVert_2,\lVert A\rVert_F,\mathrm{cond}_2(A)$；
(2) 写出 $V$、$U$（用 $\boldsymbol{u}_i=A\boldsymbol{v}_i/\sigma_i$）并验证 $A=U\Sigma V^{\mathrm T}$；
(3) 写出 $C(A)$、$N(A)$、$C(A^{\mathrm T})$、$N(A^{\mathrm T})$ 的标准正交基。

::: sol 解答

**(1)**

$$A^{\mathrm T}A=\begin{pmatrix}2&-1&1\\2&1&1\end{pmatrix}\begin{pmatrix}2&2\\-1&1\\1&1\end{pmatrix}=\begin{pmatrix}4+1+1&4-1+1\\4-1+1&4+1+1\end{pmatrix}=\begin{pmatrix}6&4\\4&6\end{pmatrix}.$$

特征值：$(6-\lambda)^2-16=0\Rightarrow\lambda=6\pm4$，即 $\lambda_1=10,\ \lambda_2=2$。故

$$\sigma_1=\sqrt{10}\approx3.1623,\qquad\sigma_2=\sqrt2\approx1.4142 .$$

$$\lVert A\rVert_2=\sqrt{10}\approx3.1623,\qquad\lVert A\rVert_F=\sqrt{10+2}=\sqrt{12}\approx3.4641,$$

$$\mathrm{cond}_2(A)=\frac{\sqrt{10}}{\sqrt2}=\sqrt5\approx2.2361 .$$

（核对 $\lVert A\rVert_F$：$4+4+1+1+1+1=12$ ✓。）

**(2)** $\lambda_1=10$ 的特征向量：$(6-10)v_1+4v_2=0\Rightarrow v_1=v_2$，$\boldsymbol{v}_1=\frac{1}{\sqrt2}(1,1)^{\mathrm T}$。$\lambda_2=2$：$(6-2)v_1+4v_2=0\Rightarrow v_1=-v_2$，$\boldsymbol{v}_2=\frac{1}{\sqrt2}(1,-1)^{\mathrm T}$。

$$\boldsymbol{u}_1=\frac{A\boldsymbol{v}_1}{\sigma_1}=\frac{1}{\sqrt{10}}\cdot\frac{1}{\sqrt2}\begin{pmatrix}2+2\\-1+1\\1+1\end{pmatrix}=\frac{1}{\sqrt{20}}\begin{pmatrix}4\\0\\2\end{pmatrix}=\frac{1}{\sqrt5}\begin{pmatrix}2\\0\\1\end{pmatrix},$$

$$\boldsymbol{u}_2=\frac{A\boldsymbol{v}_2}{\sigma_2}=\frac{1}{\sqrt2}\cdot\frac{1}{\sqrt2}\begin{pmatrix}2-2\\-1-1\\1-1\end{pmatrix}=\frac12\begin{pmatrix}0\\-2\\0\end{pmatrix}=\begin{pmatrix}0\\-1\\0\end{pmatrix}.$$

**验证正交（必查）：** $\boldsymbol{u}_1^{\mathrm T}\boldsymbol{u}_2=\frac{1}{\sqrt5}(0+0+0)=0$ ✓；$\lVert\boldsymbol{u}_1\rVert=1$、$\lVert\boldsymbol{u}_2\rVert=1$ ✓。

**验证 $U\Sigma V^{\mathrm T}=A$（用外积形式）：**

$$U\Sigma V^{\mathrm T}=\sigma_1\boldsymbol{u}_1\boldsymbol{v}_1^{\mathrm T}+\sigma_2\boldsymbol{u}_2\boldsymbol{v}_2^{\mathrm T}
=\sqrt{10}\cdot\frac{1}{\sqrt5}\begin{pmatrix}2\\0\\1\end{pmatrix}\cdot\frac{1}{\sqrt2}\begin{pmatrix}1&1\end{pmatrix}
+\sqrt2\begin{pmatrix}0\\-1\\0\end{pmatrix}\cdot\frac{1}{\sqrt2}\begin{pmatrix}1&-1\end{pmatrix}.$$

第一项系数 $\dfrac{\sqrt{10}}{\sqrt5\sqrt2}=\dfrac{\sqrt{10}}{\sqrt{10}}=1$，故

$$=\begin{pmatrix}2&2\\0&0\\1&1\end{pmatrix}+\begin{pmatrix}0&0\\-1&1\\0&0\end{pmatrix}=\begin{pmatrix}2&2\\-1&1\\1&1\end{pmatrix}\ ✓$$

**（3）** 四个子空间（由 [@thm-sup-2.6.2]）：

- $C(A)=\operatorname{span}\{\boldsymbol{u}_1,\boldsymbol{u}_2\}=\operatorname{span}\{(2,0,1)^{\mathrm T}/\sqrt5,\ (0,-1,0)^{\mathrm T}\}$（维数 $2$）；
- $N(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{u}_3\}$，$\boldsymbol{u}_3$ 是与 $\boldsymbol{u}_1,\boldsymbol{u}_2$ 都正交的单位向量：由 $\boldsymbol{u}_3^{\mathrm T}\boldsymbol{u}_1=0$ 得 $2u_{31}+u_{33}=0$，由 $\boldsymbol{u}_3^{\mathrm T}\boldsymbol{u}_2=0$ 得 $u_{32}=0$，故 $\boldsymbol{u}_3\propto(1,0,-2)^{\mathrm T}$，即 $\boldsymbol{u}_3=\frac{1}{\sqrt5}(1,0,-2)^{\mathrm T}$（维数 $1$）；
- $C(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{v}_1,\boldsymbol{v}_2\}=\mathbb{R}^2$（维数 $2=n$）；
- $N(A)=\{\boldsymbol{0}\}$（维数 $0$，因为 $A$ 列满秩）。

**核对：** $C(A)\perp N(A^{\mathrm T})$ ✓（$(2,0,1)\cdot(1,0,-2)=2-2=0$）；$\dim C(A)+\dim N(A^{\mathrm T})=2+1=3=m$ ✓；$\dim C(A^{\mathrm T})+\dim N(A)=2+0=2=n$ ✓。

**验收标准：** NumPy 复核——`np.linalg.svd(A)` 给出 $\sigma=(3.16227766,1.41421356)$；`A.T@A` 的特征值为 $(2,10)$；`np.linalg.cond(A)` $=2.2360679\cdots$；四个子空间的维数与上述一致。

:::

:::

::: ex C2 · Gram–Schmidt 与 Householder 手算

对

$$A=\begin{pmatrix}0&1\\1&1\\1&0\end{pmatrix}.$$

(1) 用 Gram–Schmidt 求 $Q,R$（保留根号）；
(2) 用 Householder 反射求 $Q,R$（写出 $\boldsymbol{v}$，允许 $R$ 对角元为负），并说明两次结果是否一致。

::: sol 解答

**(1) Gram–Schmidt。** $\boldsymbol{a}_1=(0,1,1)^{\mathrm T}$，$\lVert\boldsymbol{a}_1\rVert=\sqrt2$，

$$r_{11}=\sqrt2,\qquad \boldsymbol{q}_1=\frac{1}{\sqrt2}\begin{pmatrix}0\\1\\1\end{pmatrix}.$$

$r_{12}=\boldsymbol{q}_1^{\mathrm T}\boldsymbol{a}_2=\frac{0+1+0}{\sqrt2}=\frac{1}{\sqrt2}$，

$$\boldsymbol{v}=\boldsymbol{a}_2-r_{12}\boldsymbol{q}_1=\begin{pmatrix}1\\1\\0\end{pmatrix}-\frac12\begin{pmatrix}0\\1\\1\end{pmatrix}=\begin{pmatrix}1\\\frac12\\-\frac12\end{pmatrix},\qquad
\lVert\boldsymbol{v}\rVert=\sqrt{1+\frac14+\frac14}=\sqrt{\frac32}=\frac{\sqrt6}{2}.$$

$$r_{22}=\frac{\sqrt6}{2},\qquad\boldsymbol{q}_2=\frac{2}{\sqrt6}\begin{pmatrix}1\\\frac12\\-\frac12\end{pmatrix}=\frac{1}{\sqrt6}\begin{pmatrix}2\\1\\-1\end{pmatrix}.$$

$$Q=\begin{pmatrix}0&\frac{2}{\sqrt6}\\[3pt]\frac{1}{\sqrt2}&\frac{1}{\sqrt6}\\[3pt]\frac{1}{\sqrt2}&-\frac{1}{\sqrt6}\end{pmatrix},\qquad
R=\begin{pmatrix}\sqrt2&\frac{1}{\sqrt2}\\[3pt]0&\frac{\sqrt6}{2}\end{pmatrix}.$$

**核对：** $\boldsymbol{q}_1^{\mathrm T}\boldsymbol{q}_2=\frac{0+1-1}{\sqrt2\cdot\sqrt6}=0$ ✓；$QR$ 复原 $A$ ✓。

**(2) Householder。** 第 1 列 $\boldsymbol{x}=(0,1,1)^{\mathrm T}$，$\lVert\boldsymbol{x}\rVert=\sqrt2$，$x_1=0$ 故取 $\alpha=-\sqrt2$（规定 $x_1=0$ 时 $\operatorname{sgn}=1$）：

$$\boldsymbol{v}=\boldsymbol{x}-\alpha\boldsymbol{e}_1=(0,1,1)^{\mathrm T}+\sqrt2(1,0,0)=( \sqrt2,1,1)^{\mathrm T}.$$

$\boldsymbol{v}^{\mathrm T}\boldsymbol{v}=2+1+1=4$，故 $H_1=I-\frac12\boldsymbol{v}\boldsymbol{v}^{\mathrm T}$：

$$H_1=I-\frac12\begin{pmatrix}2&\sqrt2&\sqrt2\\\sqrt2&1&1\\\sqrt2&1&1\end{pmatrix}
=\begin{pmatrix}0&-\frac{1}{\sqrt2}&-\frac{1}{\sqrt2}\\-\frac{1}{\sqrt2}&\frac12&-\frac12\\-\frac{1}{\sqrt2}&-\frac12&\frac12\end{pmatrix}.$$

$$H_1A=\begin{pmatrix}-\sqrt2&-1/\sqrt2\\0&(1-\sqrt2)/2\\0&-(1+\sqrt2)/2\end{pmatrix}.$$

第二列从第二行起为 $\boldsymbol z=((1-\sqrt2)/2,-(1+\sqrt2)/2)^{\mathrm T}$，其长度为 $\sqrt6/2$。按 [2.3.4](sec23.md#sup-2.3.4) 取 $\alpha=\sqrt6/2$、$\boldsymbol v_2=\boldsymbol z-\alpha(1,0)^{\mathrm T}$，令 $H_2=\operatorname{diag}(1,I_2-2\boldsymbol v_2\boldsymbol v_2^{\mathrm T}/(\boldsymbol v_2^{\mathrm T}\boldsymbol v_2))$，则 $H_2H_1A$ 的第二列下方元素为零。取 $Q=H_1H_2$ 的前两列及 $R$ 的前两行，得到下面的结果。

数值结果（NumPy `np.linalg.qr` 内部同样用 Householder，与手算同一算法）：

$$Q\approx\begin{pmatrix}0&0.8165\\-0.7071&0.4082\\-0.7071&-0.4082\end{pmatrix},\qquad
R\approx\begin{pmatrix}-1.4142&-0.7071\\0&1.2247\end{pmatrix}.$$

**(3) 两次结果比较。** 把 Gram–Schmidt 的结果（第 1 问）写成数值：

$$Q_{\mathrm{GS}}=\begin{pmatrix}0&\frac{2}{\sqrt6}\\[2pt]\frac{1}{\sqrt2}&\frac{1}{\sqrt6}\\[2pt]\frac{1}{\sqrt2}&-\frac{1}{\sqrt6}\end{pmatrix}
=\begin{pmatrix}0&0.8165\\0.7071&0.4082\\0.7071&-0.4082\end{pmatrix},\qquad
R_{\mathrm{GS}}=\begin{pmatrix}\sqrt2&\frac{1}{\sqrt2}\\[2pt]0&\frac{\sqrt6}{2}\end{pmatrix}.$$

**逐列对照：**
- **第 1 列：** $Q_{\mathrm{HH}}$ 的第 1 列 $=(0,-0.7071,-0.7071)^{\mathrm T}=-Q_{\mathrm{GS}}$ 的第 1 列；
- **第 2 列：** $Q_{\mathrm{HH}}$ 的第 2 列 $=(0.8165,0.4082,-0.4082)^{\mathrm T}=Q_{\mathrm{GS}}$ 的第 2 列（**完全相同**）。

**原因：** Householder 的 $r_{11}=-1.4142$ 为负（未采纳「$R$ 对角元为正」的规范化），故 $Q$ 的第 1 列与 $R$ 的第 1 行同时取了相反符号；而 $r_{22}=1.2247\gt0$，第 2 列不动。**两者只差一个「列符号规范化」，去掉这个差异后完全一致**——这正是 [@thm-sup-2.3.2] 唯一性条款的含义：**唯一的只有规范形式**。

**验收标准：** 用 NumPy 验证两种方法的 $Q$ 都满足 $Q^{\mathrm T}Q=I$、$QR=A$；把 $Q_{\mathrm{HH}}$ 的第 1 列取反后应与 $Q_{\mathrm{GS}}$ 逐元素一致（到机器精度）。

:::

:::

::: ex C3 · 用 QR 解最小二乘（含与正态方程对比）

对下面这个「问题不好」的最小二乘问题：

$$A=\begin{pmatrix}1&1\\1&1.0001\\1&1.0002\\1&1.0003\end{pmatrix},\qquad\boldsymbol{b}=\begin{pmatrix}1\\2\\3\\4\end{pmatrix}.$$

(1) 手算正态方程并说明 $A^{\mathrm T}A$ 的条件数；
(2) 用 QR 与正态方程分别求 $\hat{\boldsymbol{x}}$（数值）；
(3) 解释为什么这个问题病态，并给出「把间距缩小到 $10^{-6}$ 后谁先失守」的实测结论。

::: sol 解答

**(1) 正态方程。** 记设计点 $x_i=1+10^{-4}(i-1)$（$i=1,\dots,4$）。

$$A^{\mathrm T}A=\begin{pmatrix}4&4.0006\\4.0006&4.00120014\end{pmatrix},\qquad A^{\mathrm T}\boldsymbol b=\begin{pmatrix}10\\10.002\end{pmatrix}.$$

这里必须保留平方和中的小项：$\det(A^{\mathrm T}A)=4(4.00120014)-(4.0006)^2=2\times10^{-7}$。过早把 $4.00120014$ 舍入为 $4.0012$ 会严重扭曲行列式；$\mathrm{cond}_2(A^{\mathrm T}A)=\mathrm{cond}_2(A)^2$，其数值估计见下表。

**（2）数值结果（本节运行环境）——结果出人意料：**

```python
import numpy as np
for d in [1e-4, 1e-6]:
    x = np.array([1., 1+d, 1+2*d, 1+3*d])
    A = np.vstack([np.ones(4), x]).T
    b = np.array([1., 2, 3, 4])
    Q, R = np.linalg.qr(A)
    print(f"d={d:.0e}  cond(A)={np.linalg.cond(A):.3e}  cond(A^T A)={np.linalg.cond(A.T@A):.3e}")
    print(f"    QR      : {np.linalg.solve(R, Q.T@b)}")
    print(f"    正态方程: {np.linalg.solve(A.T@A, A.T@b)}")
    print(f"    lstsq   : {np.linalg.lstsq(A, b, rcond=None)[0]}")
```

```text
d=1e-04  cond(A)=1.789e+04  cond(A^T A)=3.201e+08
    QR      : [-9999.  10000.]
    正态方程: [-9999.00024151  10000.00024148]
    lstsq   : [-9999.  10000.]
d=1e-06  cond(A)=1.789e+06  cond(A^T A)=3.199e+12
    QR      : [-999998.99994904  999999.99994904]
    正态方程: [-1000086.24298039  1000087.24284953]
    lstsq   : [-999998.99994904  999999.99994904]
```

**（3）解读——这是本节最重要的一个反直觉结果：**

**① 「正确答案」本身就是 $(-9999,10000)$ 这样的大数，不是 $(1,1)$。** 原因在于：这四个设计点几乎在同一条直线上，而 $\boldsymbol{b}=(1,2,3,4)$ **本身就精确落在这条直线上**：$x_i=1+10^{-4}(i-1)$ 而 $b_i=i$，故 $b_i=10^4(x_i-1)+1$，即真解是 $c_0=1-10^4$、$c_1=10^4$，也就是 $(-9999,10000)$ ✓。**这个系数之所以量级巨大，是因为「截距」这个参数在这个问题上极度敏感**——设计点的 $x$ 只跨 $3\times10^{-4}$，要表示 $b$ 跨 $3$ 的变化，斜率必须是 $10^4$ 量级。**系数大 ≠ 算错了。**

**② 与真解比较。** $d=10^{-4}$ 时旧表中法方程系数误差约 $2.4\times10^{-4}$，相对误差约 $2.4\times10^{-8}$；$d=10^{-6}$ 时约为 $87$，相对误差约 $9\times10^{-5}$。后一行 QR 的绝对误差约 $5\times10^{-5}$，相对误差约 $5\times10^{-11}$。两种误差之比约 $87/(5\times10^{-5})=1.7\times10^6$，本例接近 $\mathrm{cond}(A)$，但不能由误差界推断每次实验的比值必然如此。

**③ 风险判断：** 本例缩小设计点间距后，正态方程的误差明显增大；但 $\mathrm{cond}^2u$ 只是误差分析的风险量级，不是所有矩阵开始吃亏或彻底失效的固定门槛。报告应比较实际误差、残差与目标容差。

**验收标准：** 复现两行结果，扫描不同间距，比较两种方法的误差与条件数量级；病态时不同平台的结果可能不同，不能要求误差比必然等于条件数。

:::

:::

::: ex C4 · Gerschgorin 圆盘与谱半径上界

对

$$A=\begin{pmatrix}4&1&0&0\\1&4&1&0\\0&1&4&1\\0&0&1&4\end{pmatrix}.$$

(1) 写出全部 Gerschgorin 圆盘（行与列版本），给出特征值的围栏；
(2) 判断 $A$ 是否非奇异、是否可能全部特征值为正；
(3) 数值验证：算全部特征值、$\rho(A)$、$\lVert A\rVert_2$，核对 $\rho\le\lVert A\rVert_2$ 与圆盘围栏。

::: sol 解答

**(1)** 行半径：$r_1=1$、$r_2=2$、$r_3=2$、$r_4=1$。行圆盘（区间）：

$$[3,5],\ [2,6],\ [2,6],\ [3,5] .$$

**列半径与行半径相同**（$A$ 对称），故列版本给出同样结果。

**围栏：** 全部特征值 $\in[2,6]$。

**(2)** $0\notin[2,6]$，故 $A$ **非奇异**。又全部圆盘都落在右半平面（它们与实轴的交集是 $[2,6]$，$0$ 不在其中），**不能**直接推出「特征值为正」（圆盘是**复平面**上的圆，中心 $4$、半径 $2$ 的圆盘包含实部为 $2$ 的点，故实部可以为正；而对称情形可以证明得更强：特征值全落在 $[2,6]$ 的**实区间**内，因此都是正数）。对对称矩阵，Gerschgorin 的**行圆盘与实轴的交集**给出实特征值的围栏，该交集正是 $[2,6]$，所以**全部特征值为正** ✓（$A$ 也是严格对角占优的：$4\gt1$ 或 $4\gt2$ ✓，故正定）。

**(3) 数值验证：**

```python
import numpy as np
A = np.diag([4.]*4) + np.diag([1.]*3, 1) + np.diag([1.]*3, -1)
w = np.linalg.eigvalsh(A)
print("特征值 =", np.round(w, 6))
print("rho =", max(abs(w)), " ||A||2 =", np.linalg.norm(A, 2))
print("全部在 [2,6] 内?", bool(((w >= 2) & (w <= 6)).all()))
```

```text
特征值 = [2.381966 3.381966 4.618034 5.618034]
rho = 5.618034  ||A||2 = 5.618034
全部在 [2,6] 内? True
```

**核对：** 全部特征值在 $[2,6]$ ✓（含端点 $2.381966$ 与 $5.618034$，与 $\lambda=4\pm2\cos(k\pi/5)$ 的解析式一致）；$\rho(A)=\lVert A\rVert_2=5.618034$ **取等**——因为 $A$ 对称（对称矩阵的 $\rho=\lVert A\rVert_2$，[2.5.1](sec25.md#sup-2.5.1)）。

**验收标准：** 输出特征值全在 $[2,6]$；对称矩阵满足 $\rho=\lVert A\rVert_2$。若要观察不等式严格成立，需改变某个非对角元而不对称地改变其对应位置，仅改变对角元不会破坏对称性。

:::

:::

::: ex C5 · 用 SVD 做秩亏最小二乘与低秩压缩

(1) 对

$$A=\begin{pmatrix}1&2&3\\2&4&6\\3&6&9\end{pmatrix},\qquad\boldsymbol{b}=\begin{pmatrix}1\\0\\1\end{pmatrix}$$

求最小范数最小二乘解（用伪逆），并指出最小二乘解的**自由度**（解集合的维数）；
(2) 编程：对 $200\times150$ 的随机低秩矩阵（数值秩 $5$，加 $10^{-6}$ 噪声）做截断 SVD，画出「$k$ vs $\lVert A-A_k\rVert_F$」曲线，指出「肘点」位置。

::: sol 解答

**(1)** $A$ 的每行成比例（第 2 行 $=2\times$第 1 行、第 3 行 $=3\times$第 1 行），故 $\operatorname{rank}A=1$，且 $\lVert A\rVert_F=\sqrt{1+4+9+4+16+36+9+36+81}=\sqrt{196}=14=\sigma_1$（**秩 1 矩阵唯一的奇异值就是它的 F-范数**）。

$A=\sigma_1\boldsymbol{u}_1\boldsymbol{v}_1^{\mathrm T}$。列方向与行方向都是 $(1,2,3)$ 方向，故

$$\boldsymbol{u}_1=\boldsymbol{v}_1=\frac{1}{\sqrt{14}}\begin{pmatrix}1\\2\\3\end{pmatrix},\qquad
A^{+}=\frac{1}{\sigma_1}\boldsymbol{v}_1\boldsymbol{u}_1^{\mathrm T}
=\frac{1}{14}\cdot\frac{1}{14}\begin{pmatrix}1\\2\\3\end{pmatrix}\begin{pmatrix}1&2&3\end{pmatrix}
=\frac{1}{196}\begin{pmatrix}1&2&3\\2&4&6\\3&6&9\end{pmatrix}=\frac{1}{196}A^{\mathrm T}.$$

$$\hat{\boldsymbol{x}}=A^{+}\boldsymbol{b}=\frac{1}{196}\begin{pmatrix}1&2&3\\2&4&6\\3&6&9\end{pmatrix}\begin{pmatrix}1\\0\\1\end{pmatrix}=\frac{1}{196}\begin{pmatrix}4\\8\\12\end{pmatrix}=\frac{1}{49}\begin{pmatrix}1\\2\\3\end{pmatrix}\approx(0.0204,\ 0.0408,\ 0.0612)^{\mathrm T}.$$

**核对（三件事）：**

- **投影：** $A\hat{\boldsymbol{x}}=\frac{1}{49}A(1,2,3)^{\mathrm T}$。而 $A(1,2,3)^{\mathrm T}=(1\cdot1+2\cdot2+3\cdot3)(1,2,3)^{\mathrm T}=14(1,2,3)^{\mathrm T}$（$A$ 的每行都是 $(1,2,3)$ 的倍数，秩 1），故 $A\hat{\boldsymbol{x}}=\frac{14}{49}(1,2,3)^{\mathrm T}=\frac27(1,2,3)^{\mathrm T}\approx(0.2857,0.5714,0.8571)^{\mathrm T}$；
- **正交条件：** $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}=(1-\frac27,\ 0-\frac47,\ 1-\frac67)^{\mathrm T}=\frac17(5,-4,1)^{\mathrm T}$，且

$$A^{\mathrm T}\boldsymbol{r}=\frac17\begin{pmatrix}1&2&3\\2&4&6\\3&6&9\end{pmatrix}\begin{pmatrix}5\\-4\\1\end{pmatrix}=\frac17\begin{pmatrix}5-8+3\\10-16+6\\15-24+9\end{pmatrix}=\begin{pmatrix}0\\0\\0\end{pmatrix}\ \checkmark$$

- **最小范数性：** $\lVert\hat{\boldsymbol{x}}\rVert_2=\frac{1}{49}\sqrt{14}\approx0.0764$。最小二乘解集合为 $\hat{\boldsymbol{x}}+N(A)$，**自由度** $\dim N(A)=3-1=2$（一个平面）；伪逆给出的正是这个平面上离原点最近的点（沿 $\boldsymbol{v}_1$ 方向，与 $N(A)$ 正交）✓。

**(2)** 代码与预期：

```python
import numpy as np
rng = np.random.default_rng(0)
m, n, r0 = 200, 150, 5
U_, _, Vt_ = np.linalg.svd(rng.normal(size=(m, n)), full_matrices=False)
dec = np.zeros(n); dec[:r0] = np.array([50., 30, 10, 5, 1.0])   # 5 个显著奇异值
A = (U_ * dec) @ Vt_ + 1e-6 * rng.normal(size=(m, n))          # 加噪声
U, S, Vt = np.linalg.svd(A)
print("前 8 个奇异值:", np.round(S[:8], 7))
for k in [1, 3, 5, 6, 8, 10, 20]:
    Ak = (U[:, :k]*S[:k]) @ Vt[:k]
    print(f"k={k:2d}  ||A-Ak||_F={np.linalg.norm(A-Ak,'fro'):.4e}")
```

**预期输出与解读：**

```text
前 8 个奇异值: [5.00000005e+01 3.00000016e+01 1.00000005e+01 5.00000090e+00
                9.99999800e-01 2.55000000e-05 2.48000000e-05 2.44000000e-05]
k= 1  ||A-Ak||_F=3.2031e+01
k= 3  ||A-Ak||_F=5.0990e+00
k= 5  ||A-Ak||_F=1.6866e-04    ← 肘点：跨过 k=5 后误差骤降到噪声水平
k= 6  ||A-Ak||_F=1.6673e-04
k= 8  ||A-Ak||_F=1.6304e-04
k=10  ||A-Ak||_F=1.5947e-04
k=20  ||A-Ak||_F=1.4262e-04
```

**肘点在 $k=5$ 附近。** 旧表中 $\sigma_5/\sigma_6$ 约为 $3.9\times10^4$，有清晰间隙。独立零均值、标准差为 $10^{-6}$ 的 $mn$ 个噪声元素，其 F-范数平方的期望为 $mn\times10^{-12}$，因此 $10^{-6}\sqrt{mn}\approx1.73\times10^{-4}$ 是均方根尺度，不是每次噪声范数的精确值。表中残差 $1.69\times10^{-4}$ 与它接近，但不能因此宣称残差完全是纯噪声；信号子空间也会受到扰动。

**为什么 $k>5$ 时误差还下降？** $A_k$ 在拟合带噪矩阵，增大 $k$ 会保留更多噪声方向，因而重建带噪数据的残差继续减小。它不自动意味着对干净信号更准确。合成实验可额外比较与干净矩阵的误差；对真实数据，$k=5$ 是由本例谱间隙与噪声尺度支持的选择，不是普适最优秩。

**验收标准：** 输出显示 $\sigma_5/\sigma_6\gtrsim10^{4}$（清晰的谱间隙）；$k=5$ 处的 $\lVert A-A_k\rVert_F$ 与理论噪声水平 $10^{-6}\sqrt{mn}$ 相对误差 $<20\%$；画出的曲线在 $k=5$ 处有明显拐点；把噪声去掉（`+ 1e-6*...` 整项删去）后 $\sigma_6$ 应立即降到机器精度量级（$\sim10^{-14}$）。

:::

:::

::: ex C6 · 幂法、反幂法与 Courant–Fischer

(1) 用幂法求

$$A=\begin{pmatrix}4&1&1\\1&3&0\\1&0&2\end{pmatrix}$$

的主特征值（对称，真值 $\lambda_1\approx4.879385$），报告每步的 Rayleigh 商误差与收敛比，与 $\lvert\lambda_2/\lambda_1\rvert^2$ 对照；
(2) 用 Rayleigh 商最小化（在 2 维子空间上）估算 $\lambda_2$，与真值对照。

::: sol 解答

**(1)** 代码：

```python
import numpy as np
A = np.array([[4.,1,1],[1,3,0],[1,0,2]])
w = np.linalg.eigvalsh(A)[::-1]
print("真值 λ =", np.round(w, 8), " |λ2/λ1| =", f"{abs(w[1]/w[0]):.6f}",
      " 收敛比 =", f"{(w[1]/w[0])**2:.6f}")
x = np.ones(3)/np.sqrt(3); prev = None
for k in range(1, 16):
    y = A@x; x = y/np.linalg.norm(y); r = x@A@x
    ratio = "" if prev is None else f" 实测比值={abs(r-w[0])/prev:.4f}"
    prev = abs(r-w[0])
    print(f"k={k:2d} Rayleigh={r:.10f} 误差={abs(r-w[0]):.3e}{ratio}")
```

**实测输出：**

```text
真值 λ = [4.87938524 2.65270364 1.46791111]  |λ2/λ1| = 0.543655  收敛比 = 0.295561
k= 1 Rayleigh=4.8196721311 误差=5.971e-02
k= 2 Rayleigh=4.8733379986 误差=6.047e-03 实测比值=0.1013
k= 3 Rayleigh=4.8786727904 误差=7.125e-04 实测比值=0.1178
k= 4 Rayleigh=4.8792721948 误差=1.130e-04 实测比值=0.1587
k= 5 Rayleigh=4.8793606589 误差=2.458e-05 实测比值=0.2175
k= 6 Rayleigh=4.8793787750 误差=6.467e-06 实测比值=0.2631
k= 7 Rayleigh=4.8793834026 误差=1.839e-06 实测比值=0.2844
k= 8 Rayleigh=4.8793847046 误差=5.370e-07 实测比值=0.2920
k= 9 Rayleigh=4.8793850835 误差=1.581e-07 实测比值=0.2945
k=10 Rayleigh=4.8793851949 误差=4.668e-08 实测比值=0.2952
k=11 Rayleigh=4.8793852278 误差=1.379e-08 实测比值=0.2955
k=12 Rayleigh=4.8793852375 误差=4.076e-09 实测比值=0.2955
```

**解读：** 旧表的比值趋近 $0.29556$。早期较小的比值可由第三特征分量衰减更快解释；大 $O$ 界并不是早期失效，而是仅给上界，不能要求每一步误差比相等。要使渐近比恰为 $|\lambda_2/\lambda_1|^2$，初值还须含非零的第二特征方向分量；若该分量为零，实际收敛可能更快。

**(2) Courant–Fischer 估算 $\lambda_2$：**

```python
rng = np.random.default_rng(0)
best = -np.inf
for _ in range(100000):
    Q, _ = np.linalg.qr(rng.normal(size=(3, 2)))          # 随机 2 维子空间
    best = max(best, np.linalg.eigvalsh(Q.T @ A @ Q)[0])  # 该子空间上的 min Rayleigh
print(f"max over 2-subspaces of min R = {best:.10f}  (真值 λ2={w[1]:.10f})")
```

**实测输出：** `max over 2-subspaces of min R = 2.6527036442`，而 $\lambda_2=2.6527036447$——**吻合到 10 位** ✓（理论保证 $\le\lambda_2$，实测略小的差 $\sim5\times10^{-10}$ 来自随机采样未命中最优子空间）。

**验收标准：** (1) 在误差尚未降到舍入水平时，比值应趋近 $0.2956$，并解释早期其他特征分量的影响；(2) 随机子空间给出 $\lambda_2$ 的下侧近似，报告随采样次数变化的差距，不将固定 $10^{-8}$ 精度当作随机搜索的必然保证。本题代码按降序编号；$\lambda_3$ 是最小特征值，不能在使用升序 Courant–Fischer 公式时仍把它当作“第 3 大”。

:::

:::

## D 组 · 开放建模

::: ex D1 · 为病态最小二乘写一份诊断报告

你拿到一个最小二乘问题：$A\in\mathbb{R}^{500\times 20}$ 是「多项式的 Vandermonde 设计矩阵」，数据来自某实验（含 $1\%$ 的观测噪声），右端 $\boldsymbol{b}$ 由真实模型加噪声生成。用朴素正态方程求解时得到的系数**有些是负的、量级也离谱**（例如本该是 $O(1)$ 的系数变成 $O(10^{5})$）。

写一份诊断报告，要求：
(1) 给出三种可能的病因假设（并说明如何区分）；
(2) 用条件数、奇异值谱、残差三个量给出诊断流程；
(3) 给出至少两种修复方案并比较代价。

::: sol 提示与参考

**(1) 三种病因假设：**

| 假设 | 特征症状 | 区分方法 |
|:--|:--|:--|
| **设计矩阵本身病态** | 小奇异值使某些系数组合敏感 | 看完整奇异值谱、单位与参数化，不要求必有或必无谱间隙 |
| **阈值下的数值秩亏** | 小奇异值低于可分辨尺度 | 根据噪声模型与阈值比较，有清晰间隙时判定更可靠 |
| **算法引入较大后向误差** | 与更稳定方法出现超出容差的差异 | 比较 QR/SVD、尺度化残差及精度对照；小残差与大系数本身不足以归因 |

**(2) 诊断流程（三步）：**

1. **先用 QR/SVD 求解并估计条件数。** 列满秩时，精确算术下 $\mathrm{cond}_2(A^{\mathrm T}A)=\mathrm{cond}_2(A)^2$，这一恒等式对所有这样的矩阵都成立，不是识别算法故障的实验特征；也不必为诊断额外形成法方程。
2. **把奇异值谱与噪声模型对照。** 有间隙可作为选秩线索，但不能仅由“断层”证明其后全为噪声；观测噪声在 $b$ 中的方向也很重要。
3. **检查最小二乘的最优性与预测效果。** 记录 $r=b-A\hat x$、$A^{\mathrm T}r$、解范数及数据拟合。含噪不相容最小二乘不能直接套用非奇异方阵的 $\mathrm{cond}(A)\|r\|/\|b\|$ 解误差界，更不能把一个偏大的上界当作误差必大的下界。已知合成真解时另测系数误差；真实数据可用留出数据、噪声扰动或高精度对照来分辨来源。

**(3) 两种修复方案：**

| 方案 | 做法 | 代价 | 适用 |
|:--|:--|:--|:--|
| **换 QR / SVD** | 用 `np.linalg.lstsq` 等稳定求解器 | 代价依矩阵尺寸、结构与实现而定；不改变未正则化问题 | 避免显式法方程造成的额外误差，仍须评估数据敏感性 |
| **Tikhonov 正则化** | 解 $\min\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert^2+\lambda\lVert\boldsymbol{x}\rVert^2$，即 $(A^{\mathrm T}A+\lambda I)\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ | 需要选 $\lambda$（用 L 曲线或交叉验证）；**引入偏差** | 「问题本身病态」，需要稳定解 |

**报告要点：** 负系数或大系数本身不能证明算法错了，也可能来自模型、坐标、数据噪声或真实趋势（见 C3）。条件数是最坏放大尺度，不规定实际误差必须达到 $\mathrm{cond}\,u$，也不给出普适的正则化门槛。应先确定哪些参数或预测量需要准确，再比较输入噪声、计算误差与允许偏差。

**开放点：** 讨论「$1\%$ 噪声 + $\mathrm{cond}=10^{12}$ 时，数据里究竟有多少信息可用于估计 20 个系数」（提示：Shannon 式论证——有效信息量 $\approx$ 谱高于噪声水平的方向数）。**这是 [2.6.4](sec26.md#sup-2.6.4) 数值秩讨论的直接应用。**

:::

:::

::: ex D2 · Tikhonov 正则化与 L 曲线

对 C5 第 (2) 问的矩阵，另取 $x_{\mathrm{true}}=\boldsymbol1$，构造 $b=Ax_{\mathrm{true}}+10^{-4}\xi$（$\xi$ 的各分量为标准正态随机数并记录种子）；也可使用下面给出的 Vandermonde 完整示例，或自选真实病态问题。实现 $\lambda>0$ 时的 Tikhonov 正则化：

$$\boldsymbol{x}_\lambda=(A^{\mathrm T}A+\lambda I)^{-1}A^{\mathrm T}\boldsymbol{b},$$

并画出 **L 曲线**（横轴 $\log\lVert A\boldsymbol{x}_\lambda-\boldsymbol{b}\rVert$、纵轴 $\log\lVert\boldsymbol{x}_\lambda\rVert$，参数 $\lambda$），用拐点选 $\lambda$。

::: sol 提示与参考

**滤波公式从何而来？** 最小化 $\|Ax-b\|_2^2+\lambda\|x\|_2^2$，梯度为零给出 $(A^{\mathrm T}A+\lambda I)x=A^{\mathrm T}b$；$\lambda>0$ 使系数矩阵正定。换到 SVD 坐标后每个分量解 $(\sigma_i^2+\lambda)y_i=\sigma_i u_i^{\mathrm T}b$，因此 $x_\lambda=\sum_i[\sigma_i/(\sigma_i^2+\lambda)](u_i^{\mathrm T}b)v_i$。题面中的逆是数学表示，程序用该滤波式或增广最小二乘，不需显式求逆。

```python
import numpy as np
# 用一个病态问题：Hilbert 或 Vandermonde
n = 15
x_grid = np.linspace(0, 1, 25)
A = np.vander(x_grid, n, increasing=True)
c_true = np.exp(-3*x_grid[:n])                 # 指数型真解
b = A @ c_true + 1e-4 * np.random.default_rng(0).normal(size=25)

U, s, Vt = np.linalg.svd(A, full_matrices=False)
def tikhonov(lam):
    filt = s / (s**2 + lam)                     # 奇异值滤波因子
    return Vt.T @ (filt * (U.T @ b))
def resid_norm(x): return np.linalg.norm(A @ x - b)

print("λ          残差范数        解范数          与真解误差")
for lam in np.logspace(-14, 2, 17):
    x = tikhonov(lam)
    print(f"{lam:8.1e}  {resid_norm(x):12.4e}  {np.linalg.norm(x):12.4e}  "
          f"{np.linalg.norm(x-c_true):12.4e}")
```

**预期现象与分析要点：**

1. **$\lambda\to0^+$ 端：** 对固定矩阵，解趋于 $A^+b$，未必无界；若存在很小的非零奇异值且噪声在对应方向有分量，其极限范数可很大。不要把示例中的某个大范数当作所有问题的必然现象。
2. **$\lambda\to\infty$ 端**：解范数趋于零（$\boldsymbol{x}_\lambda\to\boldsymbol{0}$），但残差趋于 $\lVert\boldsymbol{b}\rVert$——**欠拟合**；
3. **L 曲线拐点：** 是平衡残差与解范数的一种启发式选择，可能不明显或不唯一，不能保证与真解误差最小处相同。滤波转折在 $\sigma_i^2\approx\lambda$，但真正的信号与噪声分界还依赖 $u_i^{\mathrm T}b$，不预设本例最优参数区间。
4. **滤波因子 $s_i/(s_i^2+\lambda)$ 的解读**：$\sigma_i\gg\sqrt\lambda$ 时因子 $\approx1/\sigma_i$（正常求逆）；$\sigma_i\ll\sqrt\lambda$ 时因子 $\approx\sigma_i/\lambda\to0$（**抑制**）。**正则化就是「对小的奇异值方向按大小平滑衰减」**——对比硬阈值截断 SVD（[2.6.4](sec26.md#sup-2.6.4) 思考题）的「一刀切」。

**报告要点：** 画 L 曲线并标出拐点；比较「拐点处的 $\lambda$」「硬阈值 SVD 的最优 $k$」「真解误差最小处的 $\lambda$」三者是否接近；讨论当噪声水平变化时 L 曲线拐点如何移动。**开放点：** 为什么「残差最小」不等于「解最准」（[@thm-sup-2.4.4]、[例 2.4.4](sec24.md#sup-2.4.4)）？正则化正是用「接受更大的残差」换取「更小的解误差」——**这是偏差–方差权衡（bias–variance tradeoff）在数值线性代数里的形态。**

:::

:::

::: ex D3 · 写一个不依赖库的 QR / SVD 教学实现并做交叉验证

实现三个函数并交叉验证：
(1) `my_qr_house(A)`——用 Householder 做 QR；
(2) `my_mgs(A)`——用 MGS 做 QR；
(3) `my_svd_via_eig(A)`——用 $A^{\mathrm T}A$ 的特征值分解来构造 SVD。

对 $m\ge n$ 的列满秩输入，分别测量 QR 的重建相对残差与列正交性；对 SVD 教学构造，分别测量重建相对残差、$U^{\mathrm T}U-I$、$V^{\mathrm T}V-I$ 和奇异值相对误差。记录哪些指标超过 $10^{-13}$，不要把这些指标混成一条曲线，也不预设普适的条件数失效阈值。

::: sol 提示与参考

```python
import numpy as np
def my_qr_house(A):
    m, n = A.shape; R = A.astype(float).copy(); Q = np.eye(m)
    for k in range(min(m-1, n)):
        x = R[k:, k]; v = x - (-(1.0 if x[0] >= 0 else -1.0)*np.linalg.norm(x))*np.eye(1, len(x), 0).ravel()
        nv = np.linalg.norm(v)
        if nv < 1e-300: continue
        v /= nv
        R[k:, :] -= 2*np.outer(v, v @ R[k:, :]); Q[:, k:] -= 2*np.outer(Q[:, k:] @ v, v)
    return Q[:, :n], R[:n, :]

def my_mgs(A):
    m, n = A.shape; Q = A.astype(float).copy(); R = np.zeros((n, n))
    for j in range(n):
        for i in range(j):
            R[i, j] = Q[:, i] @ Q[:, j]; Q[:, j] -= R[i, j]*Q[:, i]
        R[j, j] = np.linalg.norm(Q[:, j]); Q[:, j] /= R[j, j]
    return Q, R

def my_svd_via_eig(A):
    # 只处理 m>=n、列满秩的情形（教学用）
    w, V = np.linalg.eigh(A.T @ A)                    # 升序
    idx = np.argsort(w)[::-1]; w = w[idx]; V = V[:, idx]
    s = np.sqrt(np.clip(w, 0, None))
    U = A @ V / s                                     # u_i = A v_i / sigma_i
    return U, s, V

# 交叉验证
u = np.finfo(float).eps/2
print(f"{'cond':>10} {'QR(Q^TQ-I)':>12} {'MGS(Q^TQ-I)':>12} {'SVDviaEig resid':>16}")
for n in [6, 8, 10, 12, 14]:
    x = np.linspace(0.1, 1, n); A = np.vander(x, n, increasing=True); c = np.linalg.cond(A)
    Q1, R1 = my_qr_house(A); Q2, R2 = my_mgs(A)
    U3, s3, V3 = my_svd_via_eig(A)
    print(f"{c:10.2e} {np.linalg.norm(Q1.T@Q1-np.eye(n)):12.2e} "
          f"{np.linalg.norm(Q2.T@Q2-np.eye(n)):12.2e} "
          f"{np.linalg.norm(A - U3@np.diag(s3)@V3.T):16.2e}")
```

**实测输出（本教材运行结果）：**

```text
      cond          HH         MGS    SVDviaEig
  1.02e+04    1.23e-15    1.47e-13     2.95e-15
  7.40e+05    1.29e-15    2.28e-11     3.34e-15
  5.60e+07    2.45e-15    8.11e-10     4.45e-15
  4.34e+09    2.12e-15    1.24e-07          nan
  3.42e+11    2.17e-15    4.70e-06          nan
```

（`RuntimeWarning: divide by zero encountered in divide`——正是第 3 列失效的原因。）

**预期结论：**

1. **`my_qr_house` 在全部测试范围内偏差 $\sim10^{-15}$**，与 `np.linalg.qr` 同级——因为它的每一步都是正交变换；
2. **MGS 的正交性须看实际容差。** 旧表在条件数约 $10^4$ 时已约为 $1.47\times10^{-13}$，不能再称“$10^8$ 以下都满足 $10^{-13}$”。$\mathrm{cond}\,u$ 只是带条件与常数的参考尺度。
3. **通过 $A^{\mathrm T}A$ 构造的失败首先可能出现在小奇异值与左向量正交性上。** 只要所有 $s_i$ 非零，令 $U=AV\operatorname{diag}(1/s_i)$ 会使重建乘积近似抵消这些倒数，故即使 $s_i$ 不准确，重建残差仍可很小。当 $s_i$ 被舍入为零，除法才出现非有限值；脚本保留这一失败机制用于观察，不把 `clip` 后的零当作可靠数值秩判定。

**验收标准：** 报告各指标、范数及非有限值出现的位置，以 `np.linalg.svd` 为对照，不要求在固定条件数上出现 NaN，也不要求三条不同指标具有指定斜率。Householder 的零首分量按正号处理，不能用 `sign(0)=0` 直接套反射公式；本代码已采用这一约定。改变 `matrix_rank` 阈值时，还需说明比较的是哪个分辨尺度。

:::

:::

::: ex D4 · 真实数据的低秩结构与 PCA

找一份真实数据（建议：一张灰度图像、某个 $UCI$ 多变量数据集、或你所在领域的时序数据矩阵），完成一次完整的「低秩结构探查」：

(1) 做 SVD，画奇异值谱（$\log\sigma_i$ vs $i$），判断是否有清晰的「肘点」；
(2) 用截断 SVD 做压缩 / 降维，给出「$k$ vs 误差」曲线并选出合适的 $k$；
(3) 若数据是多元的，做 PCA（**中心化后再 SVD**），报告前几个主成分的方差解释比，并解释每个主成分的物理含义；
(4) 做一次「破坏性测试」：把数据加 $0.1\%$、$1\%$、$10\%$ 的噪声，观察奇异值谱的哪个部分被污染、数值秩如何变化。

::: sol 提示与参考

**流程骨架：**

先准备二维实数组，且处理后的 $X_c$ 非零：PCA 时每行是样本，每列是特征；灰度图像压缩则保留像素矩阵。下面的 `do_pca` 明确选择任务，不能用“是否二维”来区分二者。PCA 若保存压缩结果，还须保存特征均值，重建时把均值加回。

```python
import numpy as np
X = np.load("your_data.npy")           # 或 plt.imread(...) 读图像
do_pca = True                       # 灰度图像压缩时设为 False
Xc = X - X.mean(axis=0) if do_pca else X
U, S, Vt = np.linalg.svd(Xc, full_matrices=False)

# (1) 谱
print("前 10 个奇异值:", np.round(S[:10], 3))
print("累计能量 90%/95%/99% 所需 k:",
      [int(np.searchsorted(np.cumsum(S**2)/np.sum(S**2), q)+1) for q in (0.9, 0.95, 0.99)])

# (2) 压缩曲线
for k in sorted({min(j, len(S)) for j in [1, 2, 5, 10, 20, 50]}):
    Xk = (U[:, :k]*S[:k]) @ Vt[:k]
    print(f"k={k:3d} rel_err={np.linalg.norm(Xc-Xk)/np.linalg.norm(Xc):.5f} "
          f"storage={k*(Xc.shape[0]+Xc.shape[1])/Xc.size:.1%}")

# (4) 噪声测试
for level in [0.001, 0.01, 0.1]:
    rng = np.random.default_rng(0)
    Xn = Xc + level*np.linalg.norm(Xc, 'fro')*rng.normal(size=Xc.shape)/np.sqrt(Xc.size)
    if do_pca:
        Xn -= Xn.mean(axis=0)        # 带噪数据也按同一 PCA 约定中心化
    sn = np.linalg.svd(Xn, compute_uv=False)
    print(f"噪声 {level:.1%}: 数值秩(阈值 1e-10σ1) = {(sn > 1e-10*sn[0]).sum()} "
          f"（原始 {(S > 1e-10*S[0]).sum()}）")
```

**报告要点：**

1. **谱形状是线索，不是噪声标签。** 肘点可以提示候选秩，但长尾也可能包含真实弱信号，需结合领域知识、噪声模型和验收目标。
2. **PCA 先中心化。** 未中心化的 SVD 最大化二阶矩而非方差，均值可能影响首方向，但首方向不必恰好指向均值。报告须说明是否中心化以及是否标准化各列。
3. **物理解释不能只靠大小排序。** 结合载荷向量、数据单位与样本投影解释主方向，不能预设“第一项必为亮度、第二项必为对比度”。
4. **把噪声百分比定义清楚。** 上面代码令逐元素噪声标准差为 `level * norm(Xc, 'fro') / sqrt(Xc.size)`，因此中心化前 $\mathbb E\|E\|_F^2=\mathrm{level}^2\|X_c\|_F^2$。它是 F-范数均方根的相对水平，不是 $\|E\|_2/\|X_c\|_2$。加噪往往抬高小奇异值，但具体秩变化仍依赖原谱与阈值，不预设每次一定显著增加。

**开放点：** 100 个样本、5000 个特征时，中心化矩阵秩至多为 $n-1=99$，故非零奇异值至多有 99 个，不保证恰好 99 个。经济型 SVD 仍可用，是否改用随机化方法取决于所需秩、精度和成本，不能仅由 $p\gg n$ 决定。

:::

:::
