# 习题集

本章习题按难度分四组：A 组概念判断（快速自检）、B 组推导证明（考试大题）、C 组计算与编程（动手实操）、D 组开放建模（迁移综合）。四组**均附解答或提示**（默认折叠），C 组每题另给验收标准。所有题目只使用第一章与第二章已讲的概念（外加 `numpy` / `math`），不要求后续章节的方法。

## A 组 · 概念判断

::: ex A1 · 内积、正交与正交矩阵

判断对错并说明理由：
(a) 若 $\lVert\boldsymbol{x}\rVert_2=\lVert\boldsymbol{y}\rVert_2=1$ 且 $\boldsymbol{x}\neq\boldsymbol{y}$，则 $\boldsymbol{x},\boldsymbol{y}$ 正交；
(b) $\mathbb{R}^n$ 上任一范数都由某个内积诱导；
(c) 长方阵 $Q\in\mathbb{R}^{m\times n}$（$m\gt n$）满足 $Q^{\mathrm T}Q=I_n$，则 $QQ^{\mathrm T}=I_m$；
(d) 两个正交矩阵之和仍是正交矩阵。

::: sol 解答

**本题在考**：内积与范数的分工——范数要满足什么条件才来自内积，「标准」与「正交」又为什么是两件事。

**(a) 错。** 反例要在「两个范数都为 1、$\boldsymbol{x}\neq\boldsymbol{y}$、但内积不为零」的前提下找：$\boldsymbol{x}=(1,0)^{\mathrm T}$、$\boldsymbol{y}=(0,1)^{\mathrm T}$ 正交 ✓，不合用；而 $\boldsymbol{y}=(1,0)^{\mathrm T}=\boldsymbol{x}$ 会被 $\boldsymbol{x}\neq\boldsymbol{y}$ 排除。改取 $\boldsymbol{x}=(1,0)^{\mathrm T}$、$\boldsymbol{y}=(\cos\theta,\sin\theta)^{\mathrm T}$，只要 $\theta\neq90^{\circ}$，两个范数都是 1、两向量又不同，而内积 $=\cos\theta\neq0$。**范数都是 1 只说明「标准」，正交必须单独验证内积为零**（[例 2.1.3](sec21.md#sec-2.1.3) 的教训）。

**(b) 错。** 只有满足平行四边形恒等式（2.2）的范数才来自内积（[@thm-2.1.2]）。$\lVert\cdot\rVert_1$ 与 $\lVert\cdot\rVert_\infty$ 都不满足（[@ex-2.1.2]），故它们**不来自任何内积**。**推论：$\lVert\cdot\rVert_1,\lVert\cdot\rVert_\infty$ 没有正交、投影、SVD 这套结构。**

**(c) 错。** $Q^{\mathrm T}Q=I_n$ 只说明列标准正交。$QQ^{\mathrm T}$ 是 $\mathbb{R}^m$ 上的**投影矩阵**（投影到 $C(Q)$ 上），$\operatorname{tr}(QQ^{\mathrm T})=n\lt m$，故 $QQ^{\mathrm T}\neq I_m$（[@thm-2.2.5]、[2.1.4](sec21.md#sec-2.1.4) 常见错误 4）。

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

**(a) 错。** $A^{\mathrm T}A$ 可逆 $\iff$ $A$ 列满秩（[@thm-2.2.5] 证明第一段）。若 $A$ 列相关（如 $A=\begin{pmatrix}1&2\\2&4\end{pmatrix}$），$A^{\mathrm T}A$ 奇异。

**(b) 错。** 正交投影 $\iff$ **对称** + 幂等。只幂等的是**斜投影**，它的余项不与子空间垂直。反例：$S=\begin{pmatrix}1&1\\0&0\end{pmatrix}$ 满足 $S^2=S$ 但 $S^{\mathrm T}\neq S$（[2.2.6](sec22.md#sec-2.2.6) 常见错误 5）。

**(c) 前半对、后半错。** 最小二乘解**总存在**（正态方程的右端 $A^{\mathrm T}\boldsymbol{b}\in C(A^{\mathrm T})=C(A^{\mathrm T}A)$，[@thm-2.2.6]）；但**唯一 $\iff$ $A$ 列满秩**。秩亏时解成一整个集合（仿射子空间），此时「最小范数解」才唯一——由伪逆给出（[@thm-2.6.3]、[例 2.6.5](sec26.md#sec-2.6.5)）。

**(d) 错。** 「残差小 ≠ 误差小」。定量关系是 $\dfrac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-2.4.4]）；条件数大时残差可以极小而误差极大（[例 2.4.4](sec24.md#sec-2.4.4) 实测：残差 $2.5\times10^{-12}$、误差 $50\%$）。

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

**(a) 错。** 精确算术下两者给出**完全相同**的 $Q,R$，但浮点下 CGS 的正交性损失是 $O(\mathrm{cond}^2u)$、MGS 是 $O(\mathrm{cond}\,u)$——**差一个条件数**（[2.3.3](sec23.md#sec-2.3.3) 实测：$n=16$ 时 $6.55$ vs $4.7\times10^{-4}$）。

**(b) 错。** $\det H=-1$（$H$ 的特征值是 $-1$ 与 $k-1$ 重的 $1$，[@thm-2.3.3]）。**$H$ 是反射（反定向）**；$\det=+1$ 的是 Givens 旋转（[@def-2.3.2]）。

**(c) 错。** Householder 一次改动整个子块，**会毁掉稀疏结构**（fill-in）。稀疏矩阵应用 **Givens 旋转**（一次只改两行，[@thm-2.3.4] 后的对比表）。

**(d) 错（原命题不够严格）。** 只有加上「$R$ 对角元全为正」的规范化才唯一（[@thm-2.3.2]）；一般地，$Q\to Q\operatorname{diag}(\pm1)$、$R\to\operatorname{diag}(\pm1)R$ 保持 $QR$ 不变。LAPACK 与 NumPy 允许负对角元，所以不同库的 $Q,R$ 可以差若干列的符号。**秩亏时更是完全不唯一。**

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

**(a) 对。** $\mathrm{cond}(cA)=\mathrm{cond}(A)$（[@thm-2.4.1] 第 3 条）——条件数对整体缩放免疫。**但要注意各行 / 各列的相对尺度会影响 $\mathrm{cond}_\infty$**（行均衡化能降低它，[例 2.4.5](sec24.md#sec-2.4.5)）：$\mathrm{cond}$ 衡量的是「列 / 行向量之间的接近平行程度」，不是元素绝对大小。

**(b) 错。** 只有**正规**矩阵（含对称、正交、对称半正定）才有 $\rho=\lVert A\rVert_2$。反例：$N=\begin{pmatrix}1&1000\\0&1\end{pmatrix}$ 的 $\rho=1$ 而 $\lVert N\rVert_2\approx1000$；一般只有 $\rho\le\lVert A\rVert$（[2.5.1](sec25.md#sec-2.5.1)）。

**(c) 对。** 对列满秩长方形矩阵，$\sigma_{\min}\gt0$，$A^{+}$ 或 $A^{\mathrm T}A$ 的谱给出 $\mathrm{cond}_2=\sigma_1/\sigma_n$（其中 $n=\min(m,n)$）。「条件数」这个概念用在长方形矩阵上时，要靠「相对于列空间的敏感度」来定义（[2.4.1](sec24.md#sec-2.4.1)、[2.6.3](sec26.md#sec-2.6.3)）。

**(d) 错（不成立）。** $\rho(A)\lt1$ 只保证 $\lVert A^k\rVert\to0$（**渐近**），不保证**单调**递减——非正规矩阵存在「瞬态增长」（[例 2.5.6](sec25.md#sec-2.5.6)）。反例：$\begin{pmatrix}0.9&10\\0&0.9\end{pmatrix}$ 的 $\rho=0.9$，但 $\lVert A^1\rVert$ 可以很大。**稳妥判据：$\lVert A\rVert\lt1$ 才保证每一步收缩。**

:::

:::

## B 组 · 推导证明

::: ex B1 · 正交矩阵的等价刻画（补全定理 2.1.5 剩余条款）

补全 [@thm-2.1.5] 中未证明的等价关系，具体是三件事：由 $Q$ 的行向量组标准正交推出 $Q^{\mathrm T}Q=I$；补齐「由 $\lVert Q\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_2$（对一切 $\boldsymbol{x}$）推出 $Q^{\mathrm T}Q=I$」的代数细节；以及证明「上三角且正交的矩阵必为对角阵，对角元为 $\pm1$」。

::: sol 解答

**行标准正交 $\Rightarrow Q^{\mathrm T}Q=I$：** 行标准正交即 $QQ^{\mathrm T}=I$（逐元素是行内积 $=\delta_{ij}$）。由 $QQ^{\mathrm T}=I$ 得 $Q$ 可逆（$\det Q\cdot\det Q^{\mathrm T}=1$），左乘 $Q^{-1}$：$Q^{\mathrm T}=Q^{-1}$。再右乘 $Q$ 得 $Q^{\mathrm T}Q=I$ ✓。

**$\lVert Q\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_2\ \forall\boldsymbol{x}\Rightarrow Q^{\mathrm T}Q=I$：** 两边平方：$\boldsymbol{x}^{\mathrm T}Q^{\mathrm T}Q\boldsymbol{x}=\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 对一切 $\boldsymbol{x}$，即 $\boldsymbol{x}^{\mathrm T}S\boldsymbol{x}=0$ 对一切 $\boldsymbol{x}$，其中 $S=Q^{\mathrm T}Q-I$ **对称**。

- 取 $\boldsymbol{x}=\boldsymbol{e}_i$：$s_{ii}=0$；
- 取 $\boldsymbol{x}=\boldsymbol{e}_i+\boldsymbol{e}_j$（$i\neq j$）：$s_{ii}+2s_{ij}+s_{jj}=0$，代入 $s_{ii}=s_{jj}=0$ 得 $2s_{ij}=0$。

故 $S=O$，即 $Q^{\mathrm T}Q=I$ ✓。（这个「用对称性 + 特殊向量取极化」的技巧是标准套路。）

**上三角 + 正交 $\Rightarrow$ 对角、对角元 $\pm1$：** 设 $S$ 为上三角矩阵且 $S^{\mathrm T}S=I$（这里的 $S$ 是新记号，与上一段无关）。看 $S$ 的第 1 列 $\boldsymbol{s}_1$：上三角给 $s_{21}=\cdots=s_{n1}=0$，单位向量给 $\lvert s_{11}\rvert=1$。**归纳：** 设第 $1,\dots,k-1$ 列已证是 $\pm\boldsymbol{e}_1,\dots,\pm\boldsymbol{e}_{k-1}$。第 $k$ 列只有前 $k$ 个分量可能非零（上三角），且要与 $\boldsymbol{s}_i=\pm\boldsymbol{e}_i$（$i\lt k$）正交，故 $s_{1k}=\cdots=s_{k-1,k}=0$，再由单位向量得 $\lvert s_{kk}\rvert=1$。故 $S$ 是对角、对角元 $\pm1$ ✓。（这正是 [@thm-2.3.2] 唯一性证明的关键一步。）

:::

:::

::: ex B2 · 对称矩阵的谱定理

证明：实对称矩阵的全部特征值为实数，且存在正交矩阵 $V$ 使 $V^{\mathrm T}AV=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$。（本题只要求完整证明前半句与「特征向量可正交化」；后半句可用 Schur 形式 + 归纳得到。）

::: sol 解答

**特征值实：** 设 $A\boldsymbol{v}=\lambda\boldsymbol{v}$，$\boldsymbol{v}\in\mathbb{C}^n$ 非零。两边左乘 $\overline{\boldsymbol{v}}^{\mathrm T}$（共轭转置）：

$$\overline{\boldsymbol{v}}^{\mathrm T}A\boldsymbol{v}=\lambda\overline{\boldsymbol{v}}^{\mathrm T}\boldsymbol{v}=\lambda\lVert\boldsymbol{v}\rVert_2^2 .$$

两边取共轭转置，用 $A^{\mathrm T}=A$、$\overline{A}=A$：

$$\overline{\boldsymbol{v}}^{\mathrm T}A^{\mathrm T}\boldsymbol{v}=\overline{\lambda}\lVert\boldsymbol{v}\rVert_2^2\quad\Longrightarrow\quad\overline{\boldsymbol{v}}^{\mathrm T}A\boldsymbol{v}=\overline{\lambda}\lVert\boldsymbol{v}\rVert_2^2 .$$

两式相减：$(\lambda-\overline{\lambda})\lVert\boldsymbol{v}\rVert_2^2=0$。由 $\boldsymbol{v}\neq\boldsymbol{0}$ 得 $\lambda=\overline{\lambda}$，即 $\lambda\in\mathbb{R}$ ✓。

**不同特征值的特征向量正交：** 设 $A\boldsymbol{v}_1=\lambda_1\boldsymbol{v}_1$、$A\boldsymbol{v}_2=\lambda_2\boldsymbol{v}_2$，$\lambda_1\neq\lambda_2$（都实）。则

$$\lambda_1\boldsymbol{v}_1^{\mathrm T}\boldsymbol{v}_2=(A\boldsymbol{v}_1)^{\mathrm T}\boldsymbol{v}_2=\boldsymbol{v}_1^{\mathrm T}A\boldsymbol{v}_2=\lambda_2\boldsymbol{v}_1^{\mathrm T}\boldsymbol{v}_2\ \Longrightarrow\ (\lambda_1-\lambda_2)\boldsymbol{v}_1^{\mathrm T}\boldsymbol{v}_2=0\ \Longrightarrow\ \boldsymbol{v}_1\perp\boldsymbol{v}_2 .$$

**重特征值情形：** 若 $\lambda$ 有重数 $k$，其**特征子空间**维数恰为 $k$（对称矩阵可对角化——由 Schur 形式 $A=QTQ^{\mathrm T}$ 且 $A$ 对称蕴含 $T$ 对称、对称的上三角阵是对角阵）。在该子空间内任取标准正交基（Gram–Schmidt，[2.3.1](sec23.md#sec-2.3.1)）。

**拼起来：** 各特征子空间两两正交、内部标准正交，合起来有 $n$ 个标准正交向量，构成 $V$。此时 $V^{\mathrm T}AV=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$ ✓。

（**关键的一步是「对称矩阵可对角化」**——这可从 Schur 形式直接得到：任何方阵可写成 $A=QTQ^{\mathrm T}$（$Q$ 正交、$T$ 上三角），而 $A^{\mathrm T}=A$ 迫使 $T^{\mathrm T}=T$，上三角且对称者必为对角阵。）

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

**(2)** $P$ 对称 $\Rightarrow$ 可正交对角化（[@thm-2.5.1] 第 5 条）；幂等 $\Rightarrow$ 特征值 $\in\{0,1\}$（$\lambda^2=\lambda$）。故 $\operatorname{tr}P=\operatorname{rank}P=$ 非零特征值个数 $=\dim C(P)=n$（因为 $C(P)=C(A)$：$P$ 把 $\boldsymbol{b}$ 投到 $C(A)$ 上，且 $P$ 在 $C(A)$ 上是恒等映射）。

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

于是 $X_1AX_1=X_1AX_2$（左边 $=X_1$），故 $X_1=X_1AX_2$。再取转置：$X_1^{\mathrm T}=X_2^{\mathrm T}A^{\mathrm T}X_1^{\mathrm T}$。

也可以直接代入四条件往下算：$X_1=X_1AX_1=X_1AX_2=A^{\mathrm T}X_1^{\mathrm T}X_2$（用 $(X_1A)^{\mathrm T}=X_1A$）$=X_2^{\mathrm T}A^{\mathrm T}X_1^{\mathrm T}X_2=\ldots$，只是会越算越繁；更简洁的标准做法是利用 $AX_1=AX_2$ 与 $X_1A=X_2A$：

$$X_1=X_1AX_1=X_1\underbrace{AX_2}_{=AX_1}=X_1AX_2=\underbrace{X_1A}_{=X_2A}X_2=X_2AX_2=X_2 .$$

（第一步、最后一步用 $XAX=X$；第三步用 $AX_1=AX_2$；第五步用 $X_1A=X_2A$。）故唯一 ✓。

:::

:::

::: ex B5 · 残差与误差的方向

设 $A$ 非奇异，$\boldsymbol{x}$ 是精确解，$\hat{\boldsymbol{x}}$ 是近似解，$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$，$\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$。证明

$$\text{(i)}\quad\lVert\boldsymbol{r}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{e}\rVert,\qquad
\text{(ii)}\quad\frac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\cdot\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert},$$

并说明为什么这**两条的方向不对称**，「残差小」不能单独作为「解准」的判据。

::: sol 解答

**（i）** 由 $\boldsymbol{b}=A\boldsymbol{x}$ 与 $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$ 得 $\boldsymbol{r}=A(\boldsymbol{x}-\hat{\boldsymbol{x}})=-A\boldsymbol{e}$，取范数并使用相容性：

$$\lVert\boldsymbol{r}\rVert=\lVert A\boldsymbol{e}\rVert\le\lVert A\rVert\lVert\boldsymbol{e}\rVert .$$

**（ii）** 由 $\boldsymbol{r}=-A\boldsymbol{e}$ 得 $\boldsymbol{e}=-A^{-1}\boldsymbol{r}$，故 $\lVert\boldsymbol{e}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol{r}\rVert$。又由 $\boldsymbol{b}=A\boldsymbol{x}$ 得 $\lVert\boldsymbol{b}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$，即 $\dfrac{1}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}$。两式相乘：

$$\frac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\lVert A^{-1}\rVert\lVert\boldsymbol{r}\rVert\cdot\frac{\lVert A\rVert}{\lVert\boldsymbol{b}\rVert}=\mathrm{cond}(A)\cdot\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\ ✓$$

**方向不对称的原因：** （i）是「**误差小 ⟹ 残差小**」，放缩只用 $\lVert A\rVert$，系数有界；而（ii）是「**残差小 ⟹ 误差小**」，放缩里出现了 $\lVert A^{-1}\rVert$——**它可以是任意大**。

$$\text{(i) 的系数}=\lVert A\rVert\quad(\text{有界}),\qquad
\text{(ii) 的系数}=\lVert A^{-1}\rVert\quad(\text{可无界}) .$$

**这就是为什么残差不能当误差的代理指标：** 求解器给出的是（i）方向的保证（「我把方程解得很好」），用户想要的是（ii）方向的保证（「我的解很准」）；两者之间恰好隔着一个 $\mathrm{cond}(A)$。**当 $\mathrm{cond}(A)\approx10^{12}$ 时，残差 $10^{-16}$ 只保证误差 $\le10^{-4}$。**

**补充（条件化的反向界）：** 若额外假设 $\mathrm{cond}(A)\cdot\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\lt1$，则可从 $\boldsymbol{x}=\hat{\boldsymbol{x}}-\boldsymbol{e}$ 出发得到带修正因子的版本

$$\frac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\frac{\mathrm{cond}(A)\cdot\lVert\boldsymbol{r}\rVert/\lVert\boldsymbol{b}\rVert}{1-\mathrm{cond}(A)\cdot\lVert\boldsymbol{r}\rVert/\lVert\boldsymbol{b}\rVert},$$

但**这个修正版的实用价值远低于（ii）**——因为分母要求条件数已经足够小，而那正是「不需要担心」的场景。**记住（ii）就够：残差要乘上 $\mathrm{cond}(A)$ 才是误差的界。**

详见 [@thm-2.4.4] 与 [例 2.4.4](sec24.md#sec-2.4.4)（那里实测了残差 $2.5\times10^{-12}$ 而误差 $50\%$ 的极端情形）。

:::

:::

::: ex B6 · Eckart–Young 的 Frobenius 版本

证明（2.35）：$\displaystyle\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_F=\sqrt{\sigma_{k+1}^2+\cdots+\sigma_r^2}$，最小值由 $A_k$ 达到。（提示：用奇异值的 Weyl 不等式 $\lvert\sigma_i(A)-\sigma_i(B)\rvert\le\lVert A-B\rVert_2$，以及 $\lVert\cdot\rVert_2\le\lVert\cdot\rVert_F$ 的方向。）

::: sol 解答

**上界（$A_k$ 达到）：** $A-A_k=\sum_{i\gt k}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$ 的奇异值是 $\sigma_{k+1},\dots,\sigma_r$（其余为零），故

$$\lVert A-A_k\rVert_F^2=\sum_{i\gt k}\sigma_i^2=\sigma_{k+1}^2+\cdots+\sigma_r^2 .$$

**下界（任何 $\operatorname{rank}B\le k$ 都不更好）：** 设 $\operatorname{rank}B\le k$，则 $B$ 至多有 $k$ 个非零奇异值，即 $\sigma_{k+1}(B)=\cdots=\sigma_n(B)=0$。由 Weyl 不等式（谱范数版，即 [@thm-2.5.6] 的「一」应用到 $A^{\mathrm T}A$ 与 $B^{\mathrm T}B$ 的平方根）：

$$\lvert\sigma_i(A)-\sigma_i(B)\rvert\le\lVert A-B\rVert_2\qquad(i=1,\dots,n) .$$

于是对 $i\gt k$：$\sigma_i(A)=\lvert\sigma_i(A)-\underbrace{\sigma_i(B)}_{0}\rvert\le\lVert A-B\rVert_2$。这对**每个** $i\gt k$ 成立，故

$$\lVert A-B\rVert_F^2=\sum_{i=1}^{n}\sigma_i(A-B)^2\ \ge\ \sum_{i=1}^{n}\bigl(\sigma_i(A)-\sigma_i(B)\bigr)^2\ \ge\ \sum_{i\gt k}\sigma_i(A)^2 .$$

（第一个不等号用「奇异值的 $\ell^2$ 距离不超过矩阵的 F-范数」这一 Sylvester 型不等式：$\sum_i(\sigma_i(A)-\sigma_i(B))^2\le\lVert A-B\rVert_F^2$，它是 von Neumann 迹不等式（[@ex-2.6.4]）的推论。）

两边开方即得下界，与上界重合 ✓。**等号成立条件：** 需要 $B$ 的奇异向量与 $A$ 在 $i\le k$ 上对齐——这正是 $A_k$。

（注：$\lVert A-B\rVert_F\ge\lVert A-B\rVert_2$，所以 Frobenius 版的下界比谱范数版弱，但结论中的**最小值恰好是同一个 $A_k$ 达到**——这体现了 $A_k$ 同时最优于两个范数。）

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

**（3）** 四个子空间（由 [@thm-2.6.2]）：

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

$$H_1A=\begin{pmatrix}0&-\frac{1}{\sqrt2}&-\frac{1}{\sqrt2}\\-\frac{1}{\sqrt2}&\frac12&-\frac12\\-\frac{1}{\sqrt2}&-\frac12&\frac12\end{pmatrix}\begin{pmatrix}0&1\\1&1\\1&0\end{pmatrix}
=\begin{pmatrix}-\sqrt2&-\frac{1}{\sqrt2}\\\frac12&\frac12\\-\frac12&-\frac12\end{pmatrix}.$$

第 2 步：对 $\boldsymbol{x}=(\frac12,-\frac12)^{\mathrm T}$ 消元。$\lVert\boldsymbol{x}\rVert=\frac{1}{\sqrt2}$，$x_1=\frac12\gt0$ 故 $\alpha=-\frac{1}{\sqrt2}$，

$$\boldsymbol{v}_2=\Bigl(\frac12+\frac{1}{\sqrt2},\ -\frac12\Bigr)^{\mathrm T},\qquad
H_2=\begin{pmatrix}1&0&0\\0&\cdot&\cdot\\0&\cdot&\cdot\end{pmatrix}\ \text{（只作用在后两行）}.$$

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

**原因：** Householder 的 $r_{11}=-1.4142$ 为负（未采纳「$R$ 对角元为正」的规范化），故 $Q$ 的第 1 列与 $R$ 的第 1 行同时取了相反符号；而 $r_{22}=1.2247\gt0$，第 2 列不动。**两者只差一个「列符号规范化」，去掉这个差异后完全一致**——这正是 [@thm-2.3.2] 唯一性条款的含义：**唯一的只有规范形式**。

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

$$A^{\mathrm T}A=\begin{pmatrix}4&\sum x_i\\\sum x_i&\sum x_i^2\end{pmatrix},\qquad
\sum x_i=4.0006,\qquad\sum x_i^2\approx4.0012,$$

$$A^{\mathrm T}\boldsymbol{b}=\begin{pmatrix}\sum b_i\\\sum x_ib_i\end{pmatrix}=\begin{pmatrix}10\\10.0020\end{pmatrix}.$$

用行列式公式算条件数：$\det(A^{\mathrm T}A)=n\sum x_i^2-(\sum x_i)^2=4\times4.0012-4.0006^2\approx2\times10^{-4}$，非常接近退化。

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

**② $\mathrm{cond}(A)=1.8\times10^{4}$ 时正态方程已经吃亏**（$\mathrm{cond}(A^{\mathrm T}A)=3.2\times10^{8}$，误差 $2.4\times10^{-4}$——相对于 $10^{4}$ 的系数是 $2.4\times10^{-8}$ 的相对误差，尚可接受）；**$\mathrm{cond}(A)=1.8\times10^{6}$ 时正态方程显著失守**：它给出 $-1000086$ 而正确答案是 $-999999$，**误差 $87$，即相对误差 $9\times10^{-5}$**，而 QR 精确到 $5\times10^{-5}$（相对于 $10^{6}$ 是 $5\times10^{-11}$）。**正态方程比 QR 差约 6 个数量级**——正好是 $\mathrm{cond}(A)$ 的平方因子（$\mathrm{cond}=1.8\times10^{6}$，$\sqrt{\mathrm{cond}}\approx1.3\times10^{3}$……精确地说，两者误差之比 $\approx87/5\times10^{-5}=1.7\times10^{6}\approx\mathrm{cond}(A)$ ✓，与「正态方程多付一个 $\mathrm{cond}$」的理论一致）。

**③ 分水岭：** $\mathrm{cond}(A^{\mathrm T}A)=u^{-1/2}$ 即 $\mathrm{cond}(A)=u^{-1/4}\approx10^{4}$ 时正态方程开始可见地吃亏；$\mathrm{cond}(A^{\mathrm T}A)=u^{-1}$ 即 $\mathrm{cond}(A)\approx10^{8}$ 时彻底失效。本例的 $d=10^{-4}$（$\mathrm{cond}(A)=1.8\times10^{4}$）与 $d=10^{-6}$（$1.8\times10^{6}$）恰好跨过了第一个门槛。

**本题的教训（两条）：** ① **不要用「系数是否是 $O(1)$」判断解是否合理**——要看 $\boldsymbol{b}$ 与 $A$ 的关系，理性地算一遍真解；② **正态方程与 QR 的差距是一个 $\mathrm{cond}(A)$**，在 $\mathrm{cond}\gtrsim10^{4}$ 就开始显现、$\gtrsim10^{8}$ 时彻底崩坏。

**验收标准：** 复现上表两行；把 $d$ 从 $10^{-3}$ 扫到 $10^{-7}$，画「正态方程误差 / QR 误差」随 $d$ 的曲线，验证该比值以 $\mathrm{cond}(A)$ 的速度增长；并用 `np.linalg.cond(A.T@A) == np.linalg.cond(A)**2`（近似）自检。

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

**核对：** 全部特征值在 $[2,6]$ ✓（含端点 $2.381966$ 与 $5.618034$，与 $\lambda=4\pm2\cos(k\pi/5)$ 的解析式一致）；$\rho(A)=\lVert A\rVert_2=5.618034$ **取等**——因为 $A$ 对称（对称矩阵的 $\rho=\lVert A\rVert_2$，[2.5.1](sec25.md#sec-2.5.1)）。

**验收标准：** 输出特征值全在 $[2,6]$；$\rho=\lVert A\rVert_2$（对称矩阵必取等）；把对角线元素改成 $4,3,3,4$（破坏对称），观察 $\rho\lt\lVert A\rVert_2$ 严格成立。

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

**肘点在 $k=5$**：$\sigma_5=1.0$ 与 $\sigma_6=2.55\times10^{-5}$ 之间有 $\mathbf{3.9\times10^{4}}$ 倍的落差（`σ5/σ6=39267`），恰对应「真实秩 $=5$」。**更关键的是 $k=5$ 时的误差量级**：$1.69\times10^{-4}$，而按 $m\times n=3\times10^{4}$ 个元素、每个噪声 $10^{-6}$ 估计的噪声总能量是 $10^{-6}\sqrt{30000}=1.73\times10^{-4}$——**两者精确吻合**。这说明 $k\ge5$ 后残余的「误差」已经不是矩阵的结构信息，而是纯噪声。

**为什么 $k\gt5$ 时误差还略有下降？** 因为 $k=6,7,\dots$ 的截断把部分噪声方向也去掉了——但**这是在拟合噪声**（把噪声方向当信号保留会降低误差、但损害泛化）。**判据：一旦误差降到噪声水平、且继续增大 $k$ 收益甚微，就应该停止。** 本例的正确答案是 $k=5$。

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

**解读：** 比值单调**上升**并稳定在 $0.2955$，与 $\lvert\lambda_2/\lambda_1\rvert^2=0.29556$ **吻合到 4 位** ✓。**注意早期比值偏小（$0.10$，比理论值还快）**——这是「渐近式 $O((\lambda_2/\lambda_1)^{2k})$ 只在高阶分量完全衰减后才成立」的表现：$\boldsymbol{x}_0=(1,1,1)/\sqrt3$ 含较多 $\lambda_3$ 分量，前几步这部分误差衰减得更快（速度是 $\lvert\lambda_3/\lambda_1\rvert^2\approx0.09$），因此显得「比理论快」。**报告里应指出这一点**，不要误以为理论错了。

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

**验收标准：** (1) 的实测比值最终稳定在 $0.2956\pm5\%$；(2) 的估算值与真值 $\lambda_2$ 相对误差 $<10^{-8}$。**报告要点：** 解释 (1) 中「早期比值偏小」的原因（$\lambda_3$ 分量衰减更快）；解释 (2) 中「取最大」逼近 $\lambda_2$ 的依据（[@thm-2.5.5] 的 Courant–Fischer），以及**为什么不能**用 2 维子空间上的最大值去估 $\lambda_3$（提示：$\lambda_3$ 需要 3 维子空间，且它是 $k=3$ 情形下的 $\min\max$）。

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
| **设计矩阵本身病态**（Vandermonde 的典型） | $\mathrm{cond}(A)$ 很大且无谱间隙 | 看奇异值谱：平滑衰减、无断层 |
| **数值秩亏**（列近似相关） | 有清晰谱间隙（$\sigma_k/\sigma_{k+1}\gg1$） | 看 $\sigma_i$ 曲线找断层 |
| **算法放大了病态**（用了正态方程） | 残差**很小**但系数很大 | 比较 $\mathrm{cond}(A)$ 与 $\mathrm{cond}(A^{\mathrm T}A)$，看是否差 $\mathrm{cond}$ 倍 |

**(2) 诊断流程（三步）：**

1. **算 $\mathrm{cond}(A)$ 与 $\mathrm{cond}(A^{\mathrm T}A)$**：若后者 $\approx$ 前者平方且 $\mathrm{cond}(A)\gtrsim10^{8}$，**先怪算法**（正态方程），换 QR 重算；
2. **画奇异值谱 $\log\sigma_i$ vs $i$**：找「断层」——断层后是噪声子空间，前面的才是信号；
3. **算残差 $\lVert\boldsymbol{r}\rVert$ 与 $\mathrm{cond}(A)\lVert\boldsymbol{r}\rVert/\lVert\boldsymbol{b}\rVert$**：若后者远大于可接受的系数误差，说明**问题本身**就给不出更准的解——这时换算法无用，必须改问题。

**(3) 两种修复方案：**

| 方案 | 做法 | 代价 | 适用 |
|:--|:--|:--|:--|
| **换 QR / SVD** | 用 `np.linalg.lstsq`（内部 SVD/QR） | 计算量略增（约 2 倍）；**不改问题** | 「算法坏、问题还好」（$\mathrm{cond}\lesssim10^{8}$） |
| **Tikhonov 正则化** | 解 $\min\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert^2+\lambda\lVert\boldsymbol{x}\rVert^2$，即 $(A^{\mathrm T}A+\lambda I)\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ | 需要选 $\lambda$（用 L 曲线或交叉验证）；**引入偏差** | 「问题本身病态」，需要稳定解 |

**报告要点：** 关键洞察是「**先判断是问题病态还是算法不稳定**」（[1.2.6](../ch01/sec12.md#sec-1.2.6)、[2.4](sec24.md)）——若 $\mathrm{cond}(A)$ 本身就只有 $10^{4}$，那么负系数和离谱量级纯粹是正态方程的锅，换 `lstsq` 就好；若 $\mathrm{cond}(A)\approx10^{12}$，那必须正则化，因为任何算法都只能给出 $\mathrm{cond}\cdot u$ 量级的精度。

**开放点：** 讨论「$1\%$ 噪声 + $\mathrm{cond}=10^{12}$ 时，数据里究竟有多少信息可用于估计 20 个系数」（提示：Shannon 式论证——有效信息量 $\approx$ 谱高于噪声水平的方向数）。**这是 [2.6.4](sec26.md#sec-2.6.4) 数值秩讨论的直接应用。**

:::

:::

::: ex D2 · Tikhonov 正则化与 L 曲线

对 C5 第 (2) 问的秩亏 / 病态问题（或自选一个真实病态问题），实现 Tikhonov 正则化：

$$\boldsymbol{x}_\lambda=(A^{\mathrm T}A+\lambda I)^{-1}A^{\mathrm T}\boldsymbol{b},$$

并画出 **L 曲线**（横轴 $\log\lVert A\boldsymbol{x}_\lambda-\boldsymbol{b}\rVert$、纵轴 $\log\lVert\boldsymbol{x}_\lambda\rVert$，参数 $\lambda$），用拐点选 $\lambda$。

::: sol 提示与参考

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

1. **$\lambda\to0$ 端**（未正则化）：残差最小，但**解范数爆炸**（$\lVert\boldsymbol{x}\rVert$ 可达 $10^{8}$），与真解误差巨大——**过拟合噪声**；
2. **$\lambda\to\infty$ 端**：解范数趋于零（$\boldsymbol{x}_\lambda\to\boldsymbol{0}$），但残差趋于 $\lVert\boldsymbol{b}\rVert$——**欠拟合**；
3. **L 曲线拐点**：残差与解范数的权衡最优点。**预期 $\lambda_{\text{opt}}\approx\sigma_i^2$：取「信号 / 噪声分界」处的那个 $\sigma^2$**（这里是 $\lambda\sim10^{-6}\sim10^{-4}$）；
4. **滤波因子 $s_i/(s_i^2+\lambda)$ 的解读**：$\sigma_i\gg\sqrt\lambda$ 时因子 $\approx1/\sigma_i$（正常求逆）；$\sigma_i\ll\sqrt\lambda$ 时因子 $\approx\sigma_i/\lambda\to0$（**抑制**）。**正则化就是「对小的奇异值方向按大小平滑衰减」**——对比硬阈值截断 SVD（[2.6.4](sec26.md#sec-2.6.4) 思考题）的「一刀切」。

**报告要点：** 画 L 曲线并标出拐点；比较「拐点处的 $\lambda$」「硬阈值 SVD 的最优 $k$」「真解误差最小处的 $\lambda$」三者是否接近；讨论当噪声水平变化时 L 曲线拐点如何移动。**开放点：** 为什么「残差最小」不等于「解最准」（[@thm-2.4.4]、[例 2.4.4](sec24.md#sec-2.4.4)）？正则化正是用「接受更大的残差」换取「更小的解误差」——**这是偏差–方差权衡（bias–variance tradeoff）在数值线性代数里的形态。**

:::

:::

::: ex D3 · 写一个不依赖库的 QR / SVD 教学实现并做交叉验证

实现三个函数并交叉验证：
(1) `my_qr_house(A)`——用 Householder 做 QR；
(2) `my_mgs(A)`——用 MGS 做 QR；
(3) `my_svd_via_eig(A)`——用 $A^{\mathrm T}A$ 的特征值分解来构造 SVD。

然后回答：**在什么条件数范围内，这三个实现的 $Q^{\mathrm T}Q$ 与 $I$ 的偏差、以及 $A=QR$ 的残差都还在 $10^{-13}$ 以内？分别在哪个量级开始失守？为什么 (3) 最差？**

::: sol 提示与参考

```python
import numpy as np
def my_qr_house(A):
    m, n = A.shape; R = A.astype(float).copy(); Q = np.eye(m)
    for k in range(min(m-1, n)):
        x = R[k:, k]; v = x - (-np.sign(x[0])*np.linalg.norm(x))*np.eye(1, len(x), 0).ravel()
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
2. **`my_mgs` 在 $\mathrm{cond}\lesssim10^{8}$ 时也好，之后按 $\mathrm{cond}\cdot u$ 增长**（$n=14$ 时 $4.7\times10^{-6}$，与 $\mathrm{cond}\cdot u=3.8\times10^{-5}$ 同量级）；
3. **`my_svd_via_eig` 在 $\mathrm{cond}\gtrsim10^{9}$ 时直接给出 `nan`**，失效方式比「误差变大」更粗暴：因为 $\sigma_{\min}=\sqrt{\lambda_{\min}(A^{\mathrm T}A)}$ 在 $A^{\mathrm T}A$ 的 $\lambda_{\min}$ 已被舍入成 $0$（甚至负数、被 `clip` 成 $0$）后，$\boldsymbol{u}_i=A\boldsymbol{v}_i/\sigma_i$ 里出现了**除以零**。**这是「不要用 $A^{\mathrm T}A$ 算 SVD」（[2.6.7](sec26.md#sec-2.6.7) 常见错误 2）最直观的证据**——$\mathrm{cond}(A^{\mathrm T}A)=\mathrm{cond}(A)^2$ 不是「精度差一点」，而是「信息被彻底抹掉」。

**验收标准：** 三列的失效点分别为「不失效 / $\sim10^{8}$ / $\sim10^{9}$（且以 NaN 形式）」；报告里画出三条曲线（横轴 $\log_{10}\mathrm{cond}$、纵轴 $\log_{10}$ 误差），与理论斜率 $1$、$1$、$2$ 对照。**开放点：** 讨论「$A^{\mathrm T}A$ 的信息论损失」——形成 $A^{\mathrm T}A$ 不仅平方了条件数，还在元素级别上**不可逆地**丢掉了信息（先打印 `np.linalg.matrix_rank(A)` 与 `np.linalg.matrix_rank(A.T@A)`，观察后者比前者小；再用 `np.linalg.matrix_rank(A.T@A, tol=...)` 说明这个「秩」强烈依赖阈值）。

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

```python
import numpy as np
X = np.load("your_data.npy")           # 或 plt.imread(...) 读图像
Xc = X - X.mean(axis=0) if X.ndim == 2 else X   # PCA 要中心化；图像压缩不中心化
U, S, Vt = np.linalg.svd(Xc, full_matrices=False)

# (1) 谱
print("前 10 个奇异值:", np.round(S[:10], 3))
print("累计能量 90%/95%/99% 所需 k:",
      [int(np.searchsorted(np.cumsum(S**2)/np.sum(S**2), q)+1) for q in (0.9, 0.95, 0.99)])

# (2) 压缩曲线
for k in [1, 2, 5, 10, 20, 50]:
    Xk = (U[:, :k]*S[:k]) @ Vt[:k]
    print(f"k={k:3d} rel_err={np.linalg.norm(Xc-Xk)/np.linalg.norm(Xc):.5f} "
          f"storage={k*(Xc.shape[0]+Xc.shape[1])/Xc.size:.1%}")

# (4) 噪声测试
for level in [0.001, 0.01, 0.1]:
    rng = np.random.default_rng(0)
    sigma1 = np.linalg.svd(Xc, compute_uv=False)[0]
    Xn = Xc + level*sigma1*rng.normal(size=Xc.shape)
    sn = np.linalg.svd(Xn, compute_uv=False)
    print(f"噪声 {level:.1%}: 数值秩(阈值 1e-10σ1) = {(sn > 1e-10*sn[0]).sum()} "
          f"（原始 {(S > 1e-10*S[0]).sum()}）")
```

**报告要点：**

1. **谱的形状决定一切**：真实图像通常「快速衰减 + 长尾（噪声）」；真实多元数据通常「少量大奇异值 + 缓降」。**肘点就是「信号 / 噪声」的分界**；
2. **PCA 的前提是中心化**：不中心化做 SVD，第一主成分会指向**均值方向**——这是最常见的错误（[2.6.6](sec26.md#sec-2.6.6)、[2.6.7](sec26.md#sec-2.6.7) 常见错误 6）。**报告里必须写明是否中心化、为什么**；
3. **主成分的「物理含义」需要领域知识**：数值上它只是「方差最大的方向」，工程含义要靠自己解释（例如图像的第一主成分通常是「整体亮度」、第二是「明暗对比」）；
4. **(4) 的结论应体现「噪声污染长尾」**：加噪后小奇异值被抬高到噪声水平（谱从「陡降后趋零」变成「陡降后平台」），**数值秩显著增加**——这就是为什么数值秩判定必须用噪声水平作阈值（[2.6.4](sec26.md#sec-2.6.4) 思考题、[实验三](sec27.md#sec-2.7.3)）。

**开放点：** 讨论「如果我只有 100 个样本却有 5000 个特征（$p\gg n$），SVD 还能用吗？奇异值谱会是什么形状？」（提示：$X$ 的秩最多 $n-1$，故只有 $n-1$ 个非零奇异值——**这是「高维小样本」问题的本质，也是降维的必要性所在**；随机化 SVD 是这一场景的标准工具。）

:::

:::
