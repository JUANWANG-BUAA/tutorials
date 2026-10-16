# 综合自测卷 · 第二章（100 分 · 建议 100 分钟）

> **闭卷、计时、独立完成**——查书或看解答做出来的分数没有意义。做完先按文末[评分标准](#rubric)自评，再按[漏点定位表](#map)回查。范围：第二章 [2.1](sec21.md)–[2.8](sec28.md) 与[数值实验](sec27.md)。本卷题目**全部为新增**（与[习题集](exercises.md)、[考场模拟卷](../training/exam-sprint.md)不重叠），覆盖同样的知识点。

<div id="exam-timer" data-minutes="100"></div>

**时间分配建议**：第一部分 $22$ 分钟（每题约 $2$ 分钟，写「判断 + 一句话理由」）→ 第二部分 $18$ 分钟 → 第三部分 $42$ 分钟（每题约 $14$ 分钟，手算题宁慢勿跳步）→ 第四部分 $16$ 分钟（每题约 $8$ 分钟，写清四件套）→ 留最后 $2$ 分钟检查第一部分有没有**只写对错**的题。

::: note 阅卷口径（先读，能省不少分）
- **判断必须带机制词**：写「错」不给分，写「错，因为范数为 $1$ 只保证『标准』，正交要逐个验证内积」才拿满。常用机制词：平行四边形恒等式、列满秩、`cond` 平方、正交性损失量级、对称 + 幂等、截断阈值。
- **公式要说前提**：正态方程要写「$A$ 列满秩」；QR 唯一要写「$R$ 对角元全为正」；系数扰动界要写「$\mathrm{cond}\cdot\rho_A\lt1$」。
- **手算题先摆中间量、报误差要注明范数**：$A^{\mathrm T}A$、$Q^{\mathrm T}\boldsymbol b$、残差、$\lVert\cdot\rVert$ 都要落在卷面上（只给最终答案最多得 $3$ 分）；「能信几位」要说清是 $u$ 还是 $\mathrm{cond}\cdot u$ 量级。
- **开放题四件套**：方案 / 理由 / 失败判据 / 验证计划，缺一项扣 $2$ 分（第四部分每题 $10$ 分）。
:::

## 第一部分 · 概念判断（10 题 × 3 分 = 30 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**1.** 若 $\mathbb R^3$ 中三个向量两两不同、范数都为 $1$，则它们构成 $\mathbb R^3$ 的一组标准正交基。
::: sol
**1. 错。** 范数为 $1$ 只保证「标准」，「正交」必须**逐个验证两两内积为零**。教材 [@ex-2.1.3] 的 $\boldsymbol r$ 组三个向量范数全对，但 $\boldsymbol r_2^{\mathrm T}\boldsymbol r_3=-2/\sqrt{18}\neq0$——此时坐标公式与 Parseval **同时静默失效**（[2.1.4](sec21.md#sec-2.1.4) 错误 1）。
:::

**2.** 向量 $\lVert\cdot\rVert_1$ 满足平行四边形恒等式，因此可以用它定义正交、投影与 SVD。
::: sol
**2. 错。** 平行四边形恒等式恰好**不成立**：取 $\boldsymbol x=(1,0)^{\mathrm T}$、$\boldsymbol y=(0,1)^{\mathrm T}$，$\lVert\boldsymbol x+\boldsymbol y\rVert_1^2+\lVert\boldsymbol x-\boldsymbol y\rVert_1^2=8\neq4=2\lVert\boldsymbol x\rVert_1^2+2\lVert\boldsymbol y\rVert_1^2$，故 $\lVert\cdot\rVert_1$ **不来自任何内积**，没有正交 / 投影 / SVD 这套结构（[@ex-2.1.2]、[@thm-2.1.2]）。
:::

**3.** 设 $A\in\mathbb R^{m\times n}$、$\operatorname{rank}A=r$，则 $\dim C(A)=\dim C(A^{\mathrm T})=r$，且 $\dim N(A)=n-r$、$\dim N(A^{\mathrm T})=m-r$。
::: sol
**3. 对。** 这就是秩定理（行秩＝列秩）与两个维数公式：$\dim C(A)=\dim C(A^{\mathrm T})=r$、$\dim N(A)=n-r$、$\dim N(A^{\mathrm T})=m-r$（[@thm-2.2.1]）。**给分**：判断 $1$ 分，写出 $r$ 与两个 $n-r,m-r$ 得 $2$ 分。
:::

**4.** 设长方阵 $Q\in\mathbb R^{m\times n}$（$m\gt n$）满足 $Q^{\mathrm T}Q=I_n$，则必有 $QQ^{\mathrm T}=I_m$。
::: sol
**4. 错。** $Q^{\mathrm T}Q=I_n$ 只说明**列**标准正交；$QQ^{\mathrm T}$ 是 $\mathbb R^m$ 上到 $C(Q)$ 的**投影矩阵**，$\operatorname{tr}(QQ^{\mathrm T})=n\lt m$，故 $QQ^{\mathrm T}\neq I_m$。「逆等于转置」只对方阵成立（[@thm-2.2.5]、[2.1.4](sec21.md#sec-2.1.4) 错误 4）。
:::

**5.** 实矩阵 $P$ 满足 $P^2=P$，则 $P$ 是某个子空间上的正交投影矩阵。
::: sol
**5. 错。** 正交投影要求**对称 + 幂等**；只幂等的是**斜投影**，其余项不垂直于子空间。反例 $S=\begin{pmatrix}1&1\\0&0\end{pmatrix}$：$S^2=S$ 但 $S^{\mathrm T}\neq S$（[2.2.6](sec22.md#sec-2.2.6) 错误 5）。
:::

**6.** 最小二乘解**总是存在**；当 $A$ 列满秩时它**唯一**，并可由正态方程 $A^{\mathrm T}A\boldsymbol x=A^{\mathrm T}\boldsymbol b$ 解出。
::: sol
**6. 对。** 存在性：$\boldsymbol{b}$ 总可正交分解为 $\boldsymbol p\in C(A)$ 与 $\boldsymbol e\in N(A^{\mathrm T})$，$\boldsymbol p$ 的原像即最小二乘解；唯一性等价于 $A$ 列满秩（此时 $A^{\mathrm T}A$ 非奇异）；正态方程正是 $A^{\mathrm T}\boldsymbol r=\boldsymbol 0$ 的代数写法（[@thm-2.2.6]）。
:::

**7.** 经典 Gram–Schmidt（CGS）与修正 Gram–Schmidt（MGS）数学上等价，因此浮点下算出的 $Q,R$ 也相同。
::: sol
**7. 错。** 精确算术下两者结果相同，浮点下差一个 $\mathrm{cond}$：CGS 的正交性损失是 $\mathrm{cond}^2u$、MGS 是 $\mathrm{cond}\,u$。实测 $n=16$ 时 CGS 的 $\lVert Q^{\mathrm T}Q-I\rVert_2=6.55$（完全不正交），MGS 为 $4.7\times10^{-4}$，Householder 为 $3.0\times10^{-15}$（[2.3.3](sec23.md#sec-2.3.3) 实测表）。
:::

**8.** 对任意非奇异方阵 $A,B$ 与任意矩阵范数，都有 $\mathrm{cond}(AB)=\mathrm{cond}(A)\mathrm{cond}(B)$，且 $\mathrm{cond}(A)\ge1$。
::: sol
**8. 错（两处都不严谨）。** ① 次可乘性只给出 $\mathrm{cond}(AB)\le\mathrm{cond}(A)\mathrm{cond}(B)$，一般不是等式（$A=\mathrm{diag}(1,10)$、$B=\mathrm{diag}(10,1)$ 时 $AB=I$、左端 $=1$、右端 $=100$）。② $\mathrm{cond}(A)\ge1$ 需要 $\lVert I\rVert=1$，即算子范数；F-范数下只有 $\mathrm{cond}_F\ge\sqrt n$（[@thm-2.4.1]）。
:::

**9.** 求解器报告的残差很小（例如 $\lVert\boldsymbol r\rVert_2/\lVert\boldsymbol b\rVert_2\approx10^{-14}$）就说明解的前向误差也很小。
::: sol
**9. 错。** 残差与误差之间隔着条件数：$\boldsymbol e=A^{-1}\boldsymbol r$，故 $\dfrac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}$。教材实测：残差相对量 $2.5\times10^{-12}$、相对误差 $50\%$。求解器能保证的是残差（后向误差），用户要的是误差（前向误差）（[@thm-2.4.4]、[@ex-2.4.4]）。
:::

**10.** (a) 对任何实方阵都有 $\sigma_i(A)=\lvert\lambda_i(A)\rvert$；(b) 对任何矩阵都有 $\rho(A)\le\lVert A\rVert_2$。
::: sol
**10.** **(a) 错、(b) 对。** (a) 奇异值总非负、共 $\min(m,n)$ 个，特征值可负可复；反例 $A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$：$\lambda_i=0$ 而 $\sigma_1=1$。(b) 对：取特征向量 $\boldsymbol v$ 得 $\lvert\lambda\rvert\lVert\boldsymbol v\rVert=\lVert A\boldsymbol v\rVert\le\lVert A\rVert_2\lVert\boldsymbol v\rVert$，取最大即得 $\rho\le\lVert A\rVert_2$（[2.5.1](sec25.md#sec-2.5.1) 三者关系框）。**给分**：(a)(b) 各 $1.5$ 分。

:::

## 第二部分 · 填空与简答（5 题 × 4 分 = 20 分）

**11.** 判断
$$\boldsymbol r_1=\frac{1}{\sqrt3}\begin{pmatrix}1\\1\\1\end{pmatrix},\quad \boldsymbol r_2=\frac{1}{\sqrt2}\begin{pmatrix}1\\-1\\0\end{pmatrix},\quad \boldsymbol r_3=\frac{1}{\sqrt6}\begin{pmatrix}1\\1\\-2\end{pmatrix}$$
是否为 $\mathbb R^3$ 的标准正交基；若是，写出 $\boldsymbol x=(1,2,3)^{\mathrm T}$ 在这组基下的坐标，并核对 Parseval 恒等式。
::: sol
**11. 是标准正交基。** 逐个验证（这是唯一正确的流程）：
$$\boldsymbol r_1^{\mathrm T}\boldsymbol r_2=\frac{1-1+0}{\sqrt6}=0,\quad \boldsymbol r_1^{\mathrm T}\boldsymbol r_3=\frac{1+1-2}{\sqrt{18}}=0,\quad \boldsymbol r_2^{\mathrm T}\boldsymbol r_3=\frac{1-1+0}{\sqrt{12}}=0,$$
范数：$\lVert\boldsymbol r_1\rVert^2=\frac{1+1+1}{3}=1$、$\lVert\boldsymbol r_2\rVert^2=\frac{1+1}{2}=1$、$\lVert\boldsymbol r_3\rVert^2=\frac{1+1+4}{6}=1$；三个两两正交的非零向量线性无关（[@thm-2.1.3]），故是标准正交基。
坐标（内积即可）：$\alpha_1=\boldsymbol r_1^{\mathrm T}\boldsymbol x=\frac{1+2+3}{\sqrt3}=2\sqrt3$、$\alpha_2=\boldsymbol r_2^{\mathrm T}\boldsymbol x=\frac{1-2+0}{\sqrt2}=-\frac{1}{\sqrt2}$、$\alpha_3=\boldsymbol r_3^{\mathrm T}\boldsymbol x=\frac{1+2-6}{\sqrt6}=-\frac{\sqrt6}{2}$。
Parseval 核对：$12+\frac12+\frac32=14=\lVert\boldsymbol x\rVert_2^2=1+4+9$ ✓。**给分**：正交性核实 $2$ 分（漏查任一对扣 $1$）、坐标 $1$ 分、Parseval $1$ 分。
:::

**12.** 用 Givens 旋转把 $\boldsymbol x=(5,-12)^{\mathrm T}$ 化为 $(r,0)^{\mathrm T}$：写出 $r$、$c$、$s$ 与旋转矩阵 $G$，验证 $G\boldsymbol x=(r,0)^{\mathrm T}$，并说明计算 $r$ 时为什么必须用 `hypot`。
::: sol
**12.** $r=\sqrt{5^2+(-12)^2}=13$，$c=\dfrac{x_1}{r}=\dfrac{5}{13}$，$s=\dfrac{x_2}{r}=-\dfrac{12}{13}$，
$$G=\begin{pmatrix}c&s\\-s&c\end{pmatrix}=\begin{pmatrix}5/13&-12/13\\12/13&5/13\end{pmatrix}.$$
验证：$G\boldsymbol x=\Bigl(\frac{25+144}{13},\ \frac{60-60}{13}\Bigr)^{\mathrm T}=(13,0)^{\mathrm T}$ ✓；$c^2+s^2=\frac{25+144}{169}=1$ 故 $G$ 正交、$\det G=1$（保定向，与 Householder 的 $-1$ 相反）。
**为什么用 `hypot`**：直接算 $x_1^2+x_2^2$ 在分量接近 $10^{154}$ 时**上溢**、接近 $10^{-160}$ 时**下溢**成零；`hypot` 先按量级缩放再开方（[@thm-2.3.4] 后的注、[2.3.5](sec23.md#sec-2.3.5)）。**给分**：$r,c,s,G$ 各 $0.5$ 分、验证 $1$ 分、`hypot` 理由 $1$ 分。
:::

**13.** 对 $A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$、初值 $\boldsymbol x_0=(1,0)^{\mathrm T}$：做**一步**幂法（先乘 $A$、再单位化），写出 $\boldsymbol x_1$，并用 Rayleigh 商给出 $\lambda_1$ 的估计；与真主特征值比较，指出理论误差量级 $\lvert\lambda_2/\lambda_1\rvert^2$ 是多少。
::: sol
**13.** $\boldsymbol y=A\boldsymbol x_0=(2,1)^{\mathrm T}$，$\lVert\boldsymbol y\rVert_2=\sqrt5$，故 $\boldsymbol x_1=\dfrac{1}{\sqrt5}(2,1)^{\mathrm T}$。
$A\boldsymbol x_1=\dfrac{1}{\sqrt5}(5,4)^{\mathrm T}$，
$$R(\boldsymbol x_1)=\boldsymbol x_1^{\mathrm T}A\boldsymbol x_1=\frac{2\times5+1\times4}{5}=\frac{14}{5}=2.8 .$$
真特征值 $\lambda=1,3$，故 $\lambda_1=3$，估计误差 $0.2$。理论量级：$\lvert\lambda_2/\lambda_1\rvert=1/3$，**Rayleigh 商**误差 $O((1/3)^2)\approx0.11$——与实测 $0.2$ 同量级（若改用 $\lVert A\boldsymbol x\rVert/\lVert\boldsymbol x\rVert$ 一阶估计，误差量级是 $1/3\approx0.33$，同样精度要多花一倍步数）（[@thm-2.5.3]）。**给分**：$\boldsymbol x_1$ $1.5$ 分、Rayleigh 商 $1.5$ 分、量级说明 $1$ 分。
:::

**14.** 对
$$A=\begin{pmatrix}9&1&2\\0&4&1\\1&0&3\end{pmatrix}$$
写出全部 Gerschgorin **行**圆盘与**列**圆盘，给出由两个并集取交集得到的最紧围栏，并说明为什么 $A$ 非奇异。
::: sol
**14. 行圆盘**（第 $i$ 行非对角绝对值和为半径）：
| $i$ | 中心 $a_{ii}$ | 半径 $r_i$ | 区间 |
|:--:|:--:|:--:|:--|
| 1 | $9$ | $\lvert1\rvert+\lvert2\rvert=3$ | $[6,12]$ |
| 2 | $4$ | $0+1=1$ | $[3,5]$ |
| 3 | $3$ | $1+0=1$ | $[2,4]$ |

**列圆盘**（半径换成该列非对角绝对值和）：第 $1$ 列 $0+1=1\Rightarrow[8,10]$；第 $2$ 列 $1+0=1\Rightarrow[3,5]$；第 $3$ 列 $2+1=3\Rightarrow[0,6]$。
**最紧围栏**：行并集 $=[2,12]$，列并集 $=[0,10]$，取交集得
$$\sigma(A)\subseteq[2,12]\cap[0,10]=[2,10].$$
**结构信息**：行圆盘里 $[6,12]$ 与其余两个不相交，故其中恰含 $1$ 个特征值；$[3,5]$ 与 $[2,4]$ 连通，该连通区恰含 $2$ 个特征值（[@thm-2.5.2] 包含性与连通性条款）。
**非奇异**：$A$ 严格对角占优（$9\gt3$、$4\gt1$、$3\gt1$），故 $0$ 不属于任何圆盘、$A$ 可逆（数值核对：特征值 $\approx9.3447,\ 3.8424,\ 2.8129$，全部落在 $[2,10]$ 内 ✓）。**给分**：行圆盘 $1.5$ 分、列圆盘 $1$ 分、交集 $0.5$ 分、非奇异依据 $1$ 分。
:::

**15.** 某对称正定矩阵在 2-范数下 $\mathrm{cond}_2(A)=4\times10^9$，双精度下 $u\approx1.1\times10^{-16}$：
(1) 解 $A\boldsymbol x=\boldsymbol b$ 时大约丢几位有效数字、还剩几位（按双精度约有 $16$ 位计）？
(2) 若把同一问题改写成最小二乘并用**正态方程**求解，等效问题的条件数变成多少、还剩几位？（提示：$\mathrm{cond}(A^{\mathrm T}A)=\mathrm{cond}(A)^2$。）
(3) 条件数大到什么量级时，双精度任何算法都救不了？
::: sol
**15.** **(1)** 丢失位数 $k\approx\log_{10}\mathrm{cond}=9.6\approx10$ 位，双精度下**只剩约 6 位**（$\mathrm{cond}\cdot u\approx4\times10^{-7}$）。
**(2)** 正态方程显式形成 $A^{\mathrm T}A$，条件数被**平方**：$\mathrm{cond}(A^{\mathrm T}A)=1.6\times10^{19}$，$k\approx19.2\gt16$——**有效数字全部丢光**，结果不可用（实证：$\mathrm{cond}=6\times10^{10}$ 时正态方程误差 $28$，真值 $1$）。
**(3)** $\mathrm{cond}\gtrsim10^{16}=u^{-1}$ 时，任何双精度算法都救不了（只能重述问题、正则化或提高精度）。**顺带记住分水岭**：$\mathrm{cond}\gtrsim10^{8}=u^{-1/2}$ 时就必须弃用正态方程改用 QR / SVD（[@thm-2.3.5]、[2.4.2](sec24.md#sec-2.4.2) 判据表）。**给分**：(1) $1.5$ 分；(2) $1.5$ 分；(3) $1$ 分。

:::

## 第三部分 · 推导计算（3 题 × 10 分 = 30 分）

**16.（10 分）** 设
$$A=\begin{pmatrix}1&1&2&1\\1&2&3&0\\1&3&4&-1\end{pmatrix},\qquad \boldsymbol b=\begin{pmatrix}1\\1\\0\end{pmatrix}.$$

(1) 求 $r$ 与四个基本子空间的一组基（列空间的基必须取 $A$ 的**原始列**），并核对两对正交补（基对基核对即可）；
(2) 记 $A_2$ 为 $A$ 的前两列，求到 $C(A_2)=C(A)$ 上的正交投影矩阵 $P$，并验证 $P^{\mathrm T}=P$、$P^2=P$、$\operatorname{tr}P=\operatorname{rank}A$；
(3) 求 $\boldsymbol b$ 在 $C(A)$ 上的正交投影、相应的最小二乘解 $\hat{\boldsymbol x}$、残差 $\boldsymbol r$ 与 $\lVert\boldsymbol r\rVert_2$，并核对 $A^{\mathrm T}\boldsymbol r=\boldsymbol 0$。

::: sol 第 16 题答案与评分要点

**(1)** 行关系：$r_3=2r_2-r_1$（核对：$2(1,2,3,0)-(1,1,2,1)=(1,3,4,-1)$ ✓），故 $\operatorname{rank}A=r=2$。

| 子空间 | 维数 | 一组基 | 取法 |
|:--|:--:|:--|:--|
| $C(A)\subseteq\mathbb R^3$ | $2$ | $(1,1,1)^{\mathrm T},\ (1,2,3)^{\mathrm T}$ | 主元列（第 $1,2$ 列）的**原始**列 |
| $N(A^{\mathrm T})\subseteq\mathbb R^3$ | $1$ | $(1,-2,1)^{\mathrm T}$ | 行关系 $r_1-2r_2+r_3=\boldsymbol 0$ |
| $C(A^{\mathrm T})\subseteq\mathbb R^4$ | $2$ | $(1,1,2,1)^{\mathrm T},\ (1,2,3,0)^{\mathrm T}$ | 原始前两行（化简后的非零行亦可） |
| $N(A)\subseteq\mathbb R^4$ | $2$ | $(-1,-1,1,0)^{\mathrm T},\ (-2,1,0,1)^{\mathrm T}$ | 解 $x_1+x_3+2x_4=0$、$x_2+x_3-x_4=0$ |

**正交性核对（$C(A^{\mathrm T})=N(A)^{\perp}$）：**
$(-1,-1,1,0)\cdot(1,1,2,1)=-1-1+2=0$ ✓；$(-1,-1,1,0)\cdot(1,2,3,0)=-1-2+3=0$ ✓；
$(-2,1,0,1)\cdot(1,1,2,1)=-2+1+1=0$ ✓；$(-2,1,0,1)\cdot(1,2,3,0)=-2+2=0$ ✓。
**（$C(A)=N(A^{\mathrm T})^{\perp}$）：** $(1,-2,1)\cdot(1,1,1)=0$ ✓；$(1,-2,1)\cdot(1,2,3)=1-4+3=0$ ✓。

**(2)** $A_2=\begin{pmatrix}1&1\\1&2\\1&3\end{pmatrix}$，
$$A_2^{\mathrm T}A_2=\begin{pmatrix}3&6\\6&14\end{pmatrix},\qquad (A_2^{\mathrm T}A_2)^{-1}=\frac16\begin{pmatrix}14&-6\\-6&3\end{pmatrix},$$
$$P=A_2(A_2^{\mathrm T}A_2)^{-1}A_2^{\mathrm T}=\frac16\begin{pmatrix}5&2&-1\\2&2&2\\-1&2&5\end{pmatrix}.$$
验证：$P^{\mathrm T}=P$ ✓（矩阵对称）；$P^2=\frac1{36}\begin{pmatrix}30&12&-6\\12&12&12\\-6&12&30\end{pmatrix}=\frac16\begin{pmatrix}5&2&-1\\2&2&2\\-1&2&5\end{pmatrix}=P$ ✓；$\operatorname{tr}P=\frac{5+2+5}{6}=2=\operatorname{rank}A$ ✓（另外 $\lVert P\rVert_2=1$，特征值为 $1,1,0$）。

**(3)** 
$$\boldsymbol p=P\boldsymbol b=\frac16\begin{pmatrix}5+2\\2+2\\-1+2\end{pmatrix}=\Bigl(\frac76,\ \frac23,\ \frac16\Bigr)^{\mathrm T}.$$
最小二乘解由 $(A_2^{\mathrm T}A_2)\hat{\boldsymbol x}=A_2^{\mathrm T}\boldsymbol b$ 给出，$A_2^{\mathrm T}\boldsymbol b=(2,3)^{\mathrm T}$：
$$\hat{\boldsymbol x}=\frac16\begin{pmatrix}14&-6\\-6&3\end{pmatrix}\begin{pmatrix}2\\3\end{pmatrix}=\frac16\begin{pmatrix}10\\-3\end{pmatrix}=\Bigl(\frac53,\ -\frac12\Bigr)^{\mathrm T},\qquad A_2\hat{\boldsymbol x}=\Bigl(\frac76,\frac23,\frac16\Bigr)^{\mathrm T}=\boldsymbol p\ \checkmark$$
$$\boldsymbol r=\boldsymbol b-\boldsymbol p=\Bigl(-\frac16,\ \frac13,\ -\frac16\Bigr)^{\mathrm T},\qquad \lVert\boldsymbol r\rVert_2=\sqrt{\frac1{36}+\frac19+\frac1{36}}=\frac{1}{\sqrt6}\approx0.4082 .$$
核对 $A^{\mathrm T}\boldsymbol r=\boldsymbol 0$：$A_2^{\mathrm T}\boldsymbol r=\Bigl(-\frac16+\frac13-\frac16,\ -\frac16+\frac23-\frac12\Bigr)^{\mathrm T}=(0,0)^{\mathrm T}$ ✓（另外两列由前两列线性组合而来，故同样为零）。**勾股核对**：$\lVert\boldsymbol p\rVert^2=\frac{11}{6}$、$\lVert\boldsymbol r\rVert^2=\frac16$、和 $=2=\lVert\boldsymbol b\rVert^2$ ✓。

**评分**：(1) $4$ 分（$r$ $0.5$；四个基各 $0.5$；两对正交性核对 $1.5$）；(2) $3$ 分（$A_2^{\mathrm T}A_2$ 与逆 $1$、$P$ $1.5$、三条性质 $0.5$）；(3) $3$ 分（$\boldsymbol p$ $0.75$、$\hat{\boldsymbol x}$ $0.75$、$\boldsymbol r,\lVert\boldsymbol r\rVert$ $0.75$、$A^{\mathrm T}\boldsymbol r=\boldsymbol 0$ 核对 $0.75$）。**用行变换后的列当列空间基，(1) 该基不得分**（行变换不保持列空间）。

:::

**17.（10 分）** 设
$$A=\begin{pmatrix}1&1\\1&1\\1&0\end{pmatrix},\qquad \boldsymbol b=\begin{pmatrix}1\\0\\0\end{pmatrix}.$$

(1) 手算 Gram–Schmidt 正交化，写出 $Q$（列标准正交）与 $R$（上三角、对角元为正，保留根号形式）；
(2) 用 QR 解最小二乘：写出 $Q^{\mathrm T}\boldsymbol b$，回代 $R\hat{\boldsymbol x}=Q^{\mathrm T}\boldsymbol b$ 求出 $\hat{\boldsymbol x}$，再给出投影 $\boldsymbol p=A\hat{\boldsymbol x}$、残差 $\boldsymbol r$、$\lVert\boldsymbol r\rVert_2$，并核对 $A^{\mathrm T}\boldsymbol r=\boldsymbol 0$；
(3) 用正态方程 $A^{\mathrm T}A\boldsymbol x=A^{\mathrm T}\boldsymbol b$ 重算 $\hat{\boldsymbol x}$，与 (2) 对照；
(4) 若 $A$ 换成条件数 $\mathrm{cond}(A)\approx6.03\times10^{10}$ 的病态 Vandermonde 设计矩阵（$m=20,n=15$，相容右端），说明两条路线的误差量级与数字，并指出「何时必须弃用正态方程」。

::: sol 第 17 题答案与评分要点

**(1)** 第一列 $\boldsymbol a_1=(1,1,1)^{\mathrm T}$：$\lVert\boldsymbol a_1\rVert=\sqrt3$，故
$$r_{11}=\sqrt3,\qquad \boldsymbol q_1=\frac{1}{\sqrt3}(1,1,1)^{\mathrm T}.$$
第二列 $\boldsymbol a_2=(1,1,0)^{\mathrm T}$：$r_{12}=\boldsymbol q_1^{\mathrm T}\boldsymbol a_2=\dfrac{1+1+0}{\sqrt3}=\dfrac{2}{\sqrt3}$，
$$\boldsymbol v=\boldsymbol a_2-r_{12}\boldsymbol q_1=(1,1,0)^{\mathrm T}-\frac23(1,1,1)^{\mathrm T}=\Bigl(\frac13,\frac13,-\frac23\Bigr)^{\mathrm T},$$
$$\lVert\boldsymbol v\rVert=\sqrt{\tfrac19+\tfrac19+\tfrac49}=\frac{\sqrt6}{3}=:r_{22},\qquad \boldsymbol q_2=\frac{1}{\sqrt6}(1,1,-2)^{\mathrm T}.$$
$$Q=\begin{pmatrix}\frac{1}{\sqrt3}&\frac{1}{\sqrt6}\\[2pt]\frac{1}{\sqrt3}&\frac{1}{\sqrt6}\\[2pt]\frac{1}{\sqrt3}&-\frac{2}{\sqrt6}\end{pmatrix},\qquad R=\begin{pmatrix}\sqrt3&\frac{2}{\sqrt3}\\[4pt]0&\frac{\sqrt6}{3}\end{pmatrix}.$$

**(2)** $Q^{\mathrm T}\boldsymbol b=\Bigl(\dfrac{1}{\sqrt3},\ \dfrac{1}{\sqrt6}\Bigr)^{\mathrm T}$。回代：
$$\frac{\sqrt6}{3}x_2=\frac{1}{\sqrt6}\ \Longrightarrow\ x_2=\frac{1}{\sqrt6}\cdot\frac{3}{\sqrt6}=\frac12;\qquad \sqrt3x_1+\frac{2}{\sqrt3}\cdot\frac12=\frac{1}{\sqrt3}\ \Longrightarrow\ x_1=0 .$$
$$\hat{\boldsymbol x}=\Bigl(0,\ \frac12\Bigr)^{\mathrm T},\qquad \boldsymbol p=A\hat{\boldsymbol x}=\frac12(1,1,0)^{\mathrm T},\qquad \boldsymbol r=\Bigl(\frac12,-\frac12,0\Bigr)^{\mathrm T},\qquad \lVert\boldsymbol r\rVert_2=\frac{1}{\sqrt2}\approx0.7071 .$$
核对：$A^{\mathrm T}\boldsymbol r=\bigl(\frac12-\frac12+0,\ \frac12-\frac12+0\bigr)^{\mathrm T}=(0,0)^{\mathrm T}$ ✓（且 $\boldsymbol r\perp C(A)$、$\boldsymbol r\in N(A^{\mathrm T})=\operatorname{span}\{(1,-1,0)^{\mathrm T}\}$ ✓）。

**(3)** $A^{\mathrm T}A=\begin{pmatrix}3&2\\2&2\end{pmatrix}$（$\det=2$），$(A^{\mathrm T}A)^{-1}=\dfrac12\begin{pmatrix}2&-2\\-2&3\end{pmatrix}$，$A^{\mathrm T}\boldsymbol b=(1,1)^{\mathrm T}$：
$$\hat{\boldsymbol x}=\frac12\begin{pmatrix}2&-2\\-2&3\end{pmatrix}\begin{pmatrix}1\\1\end{pmatrix}=\frac12\begin{pmatrix}0\\1\end{pmatrix}=\Bigl(0,\frac12\Bigr)^{\mathrm T}\ \checkmark$$
两条路线**结果完全一致**——本例条件数很小（$\mathrm{cond}_2(A)\approx3.23$），差异被舍入掩盖。

**(4)** 两条路线的误差量级相差一个条件数：

| 路线 | 误差量级 | 代入 $\mathrm{cond}=6.03\times10^{10}$、$u=1.11\times10^{-16}$ | 教材实测（$m=20,n=15$） |
|:--|:--|:--|:--|
| 正态方程 | $\mathrm{cond}^2u$ | $\approx4.0\times10^{5}$ | $28$（真值 $1$，**完全失效**） |
| QR | $\mathrm{cond}\,u$ | $\approx6.7\times10^{-6}$ | $2.2\times10^{-6}$ ✓ |

**分水岭**：$\mathrm{cond}(A)\gtrsim u^{-1/2}\approx10^{8}$ 时必须弃用正态方程，改用 QR；秩亏或需要判断数值秩时用 SVD（[@thm-2.3.5]、[2.3.6](sec23.md#sec-2.3.6) 实测表）。

**评分**：(1) $\boldsymbol q_1,r_{11}$ $1$ 分、$r_{12}$ 与 $\boldsymbol v$ $1.5$ 分、$r_{22},\boldsymbol q_2,Q,R$ $1.5$ 分；(2) $Q^{\mathrm T}\boldsymbol b$ $1$ 分、回代求 $\hat{\boldsymbol x}$ $1.5$ 分、$\boldsymbol p,\boldsymbol r,\lVert\boldsymbol r\rVert$ 与核对 $1.5$ 分；(3) $0.5$ 分（含「两路线一致」的判断）；(4) $1.5$ 分（两个量级 + 分水岭）。**忘记 $A^{\mathrm T}\boldsymbol r=\boldsymbol 0$ 自检，从 (2) 扣 $0.5$ 分。**

:::

**18.（10 分）** 设
$$A=\begin{pmatrix}4&0\\3&5\end{pmatrix}.$$

(1) 求 $A^{\mathrm T}A$ 的特征值与 $A$ 的奇异值 $\sigma_1\ge\sigma_2$，写出 $V$ 的两列；
(2) 由 $\boldsymbol u_i=A\boldsymbol v_i/\sigma_i$ 求出 $U$，并用**外积形式**核算 $\sigma_1\boldsymbol u_1\boldsymbol v_1^{\mathrm T}+\sigma_2\boldsymbol u_2\boldsymbol v_2^{\mathrm T}=A$（写出两项各自的结果）；
(3) 写出秩 $1$ 截断 $A_1$，验证 $\lVert A-A_1\rVert_2=\sigma_2$ 与 $\lVert A-A_1\rVert_F=\sqrt{\sigma_2^2}$（Eckart–Young）；
(4) 由此读出 $\lVert A\rVert_2$、$\lVert A\rVert_F$、$\mathrm{cond}_2(A)$、$\lvert\det A\rvert$，并按 $k\approx\log_{10}\mathrm{cond}$ 预测「用双精度解 $A\boldsymbol x=\boldsymbol b$ 会丢几位有效数字」。

::: sol 第 18 题答案与评分要点

**(1)** 
$$A^{\mathrm T}A=\begin{pmatrix}4&3\\0&5\end{pmatrix}\begin{pmatrix}4&0\\3&5\end{pmatrix}=\begin{pmatrix}25&15\\15&25\end{pmatrix}.$$
特征方程 $(25-\lambda)^2-225=0\Rightarrow 25-\lambda=\pm15$，故 $\lambda_1=40,\ \lambda_2=10$：
$$\sigma_1=\sqrt{40}=2\sqrt{10}\approx6.3246,\qquad \sigma_2=\sqrt{10}\approx3.1623 .$$
特征向量：$\lambda_1=40$ 时 $-15v_1+15v_2=0\Rightarrow v_1=v_2$，取 $\boldsymbol v_1=\frac{1}{\sqrt2}(1,1)^{\mathrm T}$；$\lambda_2=10$ 时 $15v_1+15v_2=0\Rightarrow v_2=-v_1$，取 $\boldsymbol v_2=\frac{1}{\sqrt2}(1,-1)^{\mathrm T}$，
$$V=\frac{1}{\sqrt2}\begin{pmatrix}1&1\\1&-1\end{pmatrix}.$$
（核对：$V$ 正交、$\operatorname{tr}(A^{\mathrm T}A)=50=\lambda_1+\lambda_2$、$\det(A^{\mathrm T}A)=400=\lambda_1\lambda_2$ ✓。）

**(2)** 
$$\boldsymbol u_1=\frac{A\boldsymbol v_1}{\sigma_1}=\frac{1}{2\sqrt{10}}\cdot\frac{1}{\sqrt2}\begin{pmatrix}4\\8\end{pmatrix}=\frac{1}{\sqrt5}\begin{pmatrix}1\\2\end{pmatrix},\qquad
\boldsymbol u_2=\frac{A\boldsymbol v_2}{\sigma_2}=\frac{1}{\sqrt{10}}\cdot\frac{1}{\sqrt2}\begin{pmatrix}4\\-2\end{pmatrix}=\frac{1}{\sqrt5}\begin{pmatrix}2\\-1\end{pmatrix},$$
$U=\frac{1}{\sqrt5}\begin{pmatrix}1&2\\2&-1\end{pmatrix}$（两列正交、范数 $1$，故是正交阵；注意不同库可能给出整体差一个符号的解）。
**外积核算：**
$$\sigma_1\boldsymbol u_1\boldsymbol v_1^{\mathrm T}=2\sqrt{10}\cdot\frac{1}{\sqrt{10}}\begin{pmatrix}1\\2\end{pmatrix}\begin{pmatrix}1&1\end{pmatrix}=\begin{pmatrix}2&2\\4&4\end{pmatrix},$$
$$\sigma_2\boldsymbol u_2\boldsymbol v_2^{\mathrm T}=\sqrt{10}\cdot\frac{1}{\sqrt{10}}\begin{pmatrix}2\\-1\end{pmatrix}\begin{pmatrix}1&-1\end{pmatrix}=\begin{pmatrix}2&-2\\-1&1\end{pmatrix},$$
两者相加 $=\begin{pmatrix}4&0\\3&5\end{pmatrix}=A$ ✓。

**(3)** $A_1=\sigma_1\boldsymbol u_1\boldsymbol v_1^{\mathrm T}=\begin{pmatrix}2&2\\4&4\end{pmatrix}$，于是
$$A-A_1=\begin{pmatrix}2&-2\\-1&1\end{pmatrix}.$$
**两条算法都该写出来：** ① 由 Eckart–Young 直接读出 $\lVert A-A_1\rVert_2=\sigma_2=\sqrt{10}\approx3.1623$；② 独立核对：$A-A_1=\begin{pmatrix}2\\-1\end{pmatrix}\begin{pmatrix}1&-1\end{pmatrix}$ 是秩 $1$ 矩阵，秩 $1$ 矩阵 $\boldsymbol a\boldsymbol b^{\mathrm T}$ 的 2-范数 $=\lVert\boldsymbol a\rVert_2\lVert\boldsymbol b\rVert_2$，故 $\lVert A-A_1\rVert_2=\sqrt5\cdot\sqrt2=\sqrt{10}$ ✓ —— 两者一致。Frobenius 版：$\lVert A-A_1\rVert_F=\sqrt{4+4+1+1}=\sqrt{10}=\sqrt{\sigma_2^2}$ ✓（只残留一个非零奇异值）。

**(4)** 
$$\lVert A\rVert_2=\sigma_1=2\sqrt{10}\approx6.3246,\qquad \lVert A\rVert_F=\sqrt{16+9+25}=\sqrt{50}\approx7.0711=\sqrt{\sigma_1^2+\sigma_2^2}\ \checkmark$$
$$\mathrm{cond}_2(A)=\frac{\sigma_1}{\sigma_2}=2,\qquad \lvert\det A\rvert=20=\sigma_1\sigma_2=2\sqrt{10}\cdot\sqrt{10}\ \checkmark$$
丢失位数 $k\approx\log_{10}2\approx0.3$，即**几乎不丢位数**（剩约 $15\sim16$ 位）——$\mathrm{cond}=2$ 是良态。

**评分**：(1) $A^{\mathrm T}A$ 与特征值 $1.5$ 分、奇异值 $1$ 分、$V$ $1$ 分；(2) $U$ $2$ 分（两列各 $1$）、外积核算 $1.5$ 分；(3) $A_1$ 与外积 $1$ 分、两条 Eckart–Young 等式 $1$ 分；(4) 四个量与位数预测 $2$ 分。**把 $\sigma_i$ 写成 $\lambda_i$（本题 $\lambda_i$ 指 $A^{\mathrm T}A$ 的 $40,10$，或 $A$ 的 $4,5$）该小题不得分。**

:::

## 第四部分 · 开放论述（2 题 × 10 分 = 20 分）

**19.（10 分）** 你拿到一个实测矩阵 $X\in\mathbb R^{2000\times1500}$（每列一个特征、每行一个样本，含测量噪声），下游任务同时需要**压缩存储、去噪、降维**三件事。请给出：
(1) 技术方案：用哪个工具、给出核心公式与复杂度，并说明为什么不用另外两个候选（列主元 QR、正态方程）；
(2) 截断点 $k$ 的确定流程：给出至少三条**可操作**判据（含阈值怎么取）；
(3) 至少三条**失败判据**（必须可测量）；
(4) 验证计划（含与理论对账的项）。

::: sol 第 19 题参考答案与评分要点

**(1) 方案：SVD 截断（`np.linalg.svd` / 随机化 SVD）**，核心公式
$$X\approx X_k=\sum_{i\le k}\sigma_i\boldsymbol u_i\boldsymbol v_i^{\mathrm T},\qquad \lVert X-X_k\rVert_2=\sigma_{k+1},\qquad \text{存储 }k(m+n)\ \text{个数 vs } mn .$$
复杂度约 $O(mn\min(m,n))$（$2000\times1500$ 规模完全可承受；再大就用随机化 SVD）。
**为什么不用另外两个**：① 列主元 QR 能给出秩估计与一组正交基，但**基不按「能量」排序**，无法直接给出「最优 $k$ 项截断」——Eckart–Young 保证最优的是截断 SVD；② 正态方程面对的是**最小二乘求解**问题，而这里要做的是低秩分解，且形成 $X^{\mathrm T}X$ 会把条件数**平方**、还要额外算 $1500\times1500$ 的特征值分解。
**关键前提**：做「降维 / 方差解释」之前**必须先中心化**（$X_c=X-\bar{\boldsymbol x}^{\mathrm T}$），否则第一主方向会指向均值方向，所谓的「解释方差」根本不是方差。

**(2) $k$ 的确定流程（三条判据，取交集/先到先得）**
① **噪声水平判据**：$k=\#\{i:\sigma_i\gt t\sigma_1\}$，$t\approx$ 噪声幅度 $/\sigma_1$——这是实践中最常用的（低噪场景等价于「谱的断层」判据）。**不要**用 `matrix_rank` 的默认阈值 $\max(m,n)u$：它只适合「精确矩阵数值降秩」（实测同一矩阵默认判秩 $20$、按噪声水平只有 $3$）。
② **能量判据**：取最小的 $k$ 使 $\sum_{i\le k}\sigma_i^2/\sum_i\sigma_i^2\ge99\%$（工程常用；图像压缩里对应 PSNR 目标）。
③ **拐点判据**：画 $\log\sigma_i$ 对 $i$ 的曲线，取曲线**陡降段之后的平台起始处**为 $k$——谱断层说明「断层后是噪声子空间」。
④ 交叉验证（下游任务）作为兜底：$k$ 变化 $10\%$ 而下游指标不变，说明选得稳。

**(3) 失败判据（≥3，可测量）**
① 用未截断的伪逆 / 求逆得到下游结果时，输出范数比输入大 $\mathrm{cond}(X)$ 量级（$\ge10^{10}$）→ 说明噪声被放大，必须截断（未截断伪逆会放大 $1/\sigma_{\min}$）。
② 截断后**残差能量比** $\lVert X-X_k\rVert_F/\lVert X\rVert_F$ 明显大于噪声水平（例如噪声 $1\%$ 而残差 $8\%$）→ $k$ 取得太小，把信号也砍了。
③ $k$ 增大到某处后验证损失（或下游指标）**先变好再变坏**，且坏的那段对应 $\sigma_{k+1}$ 已低于噪声水平 → 把噪声方向当成了信号方向。
④ `svd` 返回值里出现 $\sigma_i/\sigma_1\lt10^{-15}$ 的非零「奇异值」却把它当真 ⇒ 数值秩判断被机器精度污染；或 $\mathrm{cond}(X)\ge10^{16}$ 时任何双精度结论都不可用。

**(4) 验证计划**
① **理论对账**：直接核对 $\lVert X-X_k\rVert_2=\sigma_{k+1}$ 与 $\lVert X-X_k\rVert_F=\sqrt{\sum_{i\gt k}\sigma_i^2}$（应当精确到机器精度）；
② **构造对照**：用指定谱（如指数衰减）合成矩阵，检查实测误差曲线与理论曲线重合，并随机生成若干秩 $k$ 矩阵证明它们的误差都 $\ge\sigma_{k+1}$（Eckart–Young 的下界）；
③ **中心化核账**：验证 $\sigma_i(X_c)=\sqrt{(n-1)\lambda_i(C)}$（$C$ 为样本协方差）与方差解释比之和为 $1$；
④ **技术路线对照**：`svd` 与 `eigh(X_cᵀX_c)` 的结果比对——数值上应当一致，但在病态情形 $A^{\mathrm T}A$ 路线会明显更差（这是「不要在 $A^{\mathrm T}A$ 上做特征值分解」的活证据）；
⑤ 固定随机种子，报告 $\sigma_i$ 谱、$k$、能量占比、残差与下游指标四组数字，便于复现。

**评分**：(1) $4$ 分（工具 + 公式 $2$、两条排除理由各 $0.5$、中心化前提 $1$）；(2) $3$ 分（三条判据各 $1$，须含阈值取法）；(3) $2$ 分（三条可测量判据）；(4) $1$ 分（至少两条对账项）。**中心化没提，(1) 上限 $2$ 分。**

:::

**20.（10 分）** 某团队求解 $A\boldsymbol x=\boldsymbol b$（$A$ 为 $3000$ 阶稀疏非对称矩阵），求解器返回「相对残差 $\lVert\boldsymbol r\rVert_2/\lVert\boldsymbol b\rVert_2=3\times10^{-15}$」，于是在报告里写下结论「解精确到 15 位有效数字」。请：
(1) 判断这句话是否成立，写出正确的误差估计式，并逐项说明每个因子**怎么得到**；
(2) 给出可执行的三步诊断流程（不许显式求逆）；
(3) 至少三条**可测量的失败判据**；
(4) 验证计划（含「构造已知真解」的做法与多算法对照）。

::: sol 第 20 题参考答案与评分要点

**(1) 结论不成立。** 正确的关系是
$$\boldsymbol e=\hat{\boldsymbol x}-\boldsymbol x=-A^{-1}\boldsymbol r\ \Longrightarrow\ \frac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}\le\mathrm{cond}(A)\,\frac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}\quad(\text{或}\ \lVert\boldsymbol e\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol r\rVert),$$
即「能信几位」由 $\mathrm{cond}(A)\cdot\lVert\boldsymbol r\rVert/\lVert\boldsymbol b\rVert$ 决定，而不是由残差本身决定。各项来源：
- $\lVert\boldsymbol r\rVert/\lVert\boldsymbol b\rVert$：求解器直接给出（后向误差，算法稳定的证据）；
- $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$：**不需求逆**也能估——用 `cond(A,1)` / `cond(A,inf)`（基于 LU 的逆估计，$O(n^2)$，LAPACK `gecon`）或 $1/\lVert A^{-1}\rVert$ 的估计；**报告时必须注明用的哪个范数**（$\mathrm{cond}_1,\mathrm{cond}_2,\mathrm{cond}_\infty$ 数值可差 $n$ 倍量级，但「丢几位」的结论一致）；
- 丢失位数 $k\approx\log_{10}\mathrm{cond}$，本例若 $\mathrm{cond}\approx10^{10}$，则 $k\approx10$：解只剩约 $6$ 位，与「精确到 15 位」相差甚远。
**一句话**：求解器保证的是「某个邻近问题的精确解」（后向稳定），用户要的是「自家问题的近似解」（前向误差），两者之间隔着条件数（[1.2.6](../ch01/sec12.md#sec-1.2.6)、[@thm-2.4.4]）。

**(2) 三步诊断（不求逆）**
① **估条件数**：`np.linalg.cond(A, np.inf)`（或 1-范数版、或让 LAPACK 返回逆范数估计），得到 $\mathrm{cond}$ 的量级；同时做**行均衡化**（各行除以该行绝对值和或最大元）后再估一次——若两次数值差 $10^{10}$ 倍以上，原报告里的「病态」有一半是单位没选好。
② **算判据**：比较 $\mathrm{cond}\cdot\lVert\boldsymbol r\rVert/\lVert\boldsymbol b\rVert$ 与目标精度（例如要求相对误差 $\le10^{-6}$）：若该乘积远大于目标，则**问题本身**就给不出这么准的解，换算法无效（病态是问题的属性）；若乘积达标，则可放心使用残差结论。
③ **可选加固**：把参数、矩阵按需做**迭代精化**（用双精度算残差 $\boldsymbol r=\boldsymbol b-A\boldsymbol x$，再解 $A\delta\boldsymbol x=\boldsymbol r$、令 $\boldsymbol x\leftarrow\boldsymbol x+\delta\boldsymbol x$），或提高工作精度（`float128` / double-double / MPFR）；若 $\mathrm{cond}\gtrsim10^{16}$，只能**重述问题**（正则化 / 换配方 / 换模型）。

**(3) 失败判据（≥3，可测量）**
① $\mathrm{cond}(A)\cdot\lVert\boldsymbol r\rVert/\lVert\boldsymbol b\rVert$ 超过目标精度 $10$ 倍以上 → 「15 位」的结论作废（本判据直接推翻原报告）。
② 构造已知真解 $\boldsymbol x^{*}$（取 $\boldsymbol x^{*}=\boldsymbol 1$，令 $\boldsymbol b=A\boldsymbol x^{*}$）后用同一求解器求解，实测相对误差 $\gg\mathrm{cond}\cdot u$（例如预测 $10^{-6}$ 而实测 $10^{-2}$）→ 说明还有别的问题：算法不稳定、矩阵输入有误或残差计算方式不一致。
③ 换三种算法（直接法 / 迭代法 / 高精度参考）得到的解**相互差异**大于预测误差 $10$ 倍 → 至少两种实现中有一种不可靠，先查残差与主元。
④ 行均衡化前后 $\mathrm{cond}$ 相差 $10^{10}$ 倍以上 → 报告里的病态判断建立在缩放不良之上，先修单位再谈精度。
⑤ 停机判据用「相邻迭代差」时，若 $\lVert\Delta\boldsymbol x_{k+1}\rVert/\lVert\Delta\boldsymbol x_k\rVert$ 长期 $\gt0.9$ → 迭代矩阵谱半径过于接近 $1$，步数不可预测，报告里的精度不可信（呼应第一章 [1.3.5](../ch01/sec13.md#sec-1.3.5) 的收敛判据）。

**(4) 验证计划**
① **构造已知真解**：取 $\boldsymbol x^{*}=\boldsymbol 1$，算 $\boldsymbol b=A\boldsymbol x^{*}$，再用待测求解器求解，报「实测相对误差 / $\mathrm{cond}\cdot u$」的比值（稳定在这个比值的常数倍内，说明界是紧的）；
② **多算法对照**：直接法（LU + 主元）、迭代法（预条件 GMRES）、高精度参考（`float128` 或迭代精化到收敛）三条路线互相验证；差异超预期就回到 ① 找原因；
③ **条件数敏感性扫描**：把 $\mathrm{cond}$ 从 $10^{4}$ 扫到 $10^{16}$（例如用 Hilbert 或 Vandermonde 族），画「实测误差 vs $\mathrm{cond}\cdot u$」曲线，验证两者同量级、并标出误差超过 $100\%$ 的临界点；
④ **报告规范核对**：结果一行必须含「值 + 残差 + $\mathrm{cond}$ 的量级与所用范数 + 预计可靠位数」；缺范数注明的报告按不合格处理（范数影响误差界的常数，见 [1.3.6](../ch01/sec13.md#sec-1.3.6)）。

**评分**：(1) $4$ 分（判断 $1$、估计式 $1.5$、两个因子的来源 $1.5$）；(2) $3$ 分（三步各 $1$，须可执行）；(3) $2$ 分（三条可测量）；(4) $1$ 分（构造真解 + 多算法对照）。**不注明范数、或把残差直接当误差，(1) 得 $0$ 分。**

:::

<a id="rubric"></a>

## 评分标准

| 部分 | 题量 | 分值 | 给分要点 |
|:--|:--:|:--:|:--|
| 一 · 概念判断 | 10 | 30 | 判断 $1$ 分 + 理由 / 反例 $2$ 分；只写对错得 $1$ 分 |
| 二 · 填空与简答 | 5 | 20 | 结果正确 $2$ 分 + 关键说明 $2$ 分；中间量缺失扣 $1$ 分 |
| 三 · 推导计算 | 3 | 30 | 中间量 / 公式 $3$ 分 + 链条完整 $4$ 分 + 核对与收口 $3$ 分；只写结论最多 $3$ 分 |
| 四 · 开放论述 | 2 | 20 | 方案具体 $4$ 分 + 判据可测量 $4$ 分 + 验证计划 $2$ 分 |

**段位换算**：$\ge90$ 优秀（能讲清「哪个工具、为什么、代价多少」）；$75\!-\!89$ 良好（能独立走完 QR / SVD 全流程）；$60\!-\!74$ 及格（公式会算、条件记不牢）；$<60$ 回到 [2.8](sec28.md#sec-2.8.2) 的八个陷阱逐条对照，再重做[习题集](exercises.md)同型题。**自评纪律**：① 判断理由必须包含**机制词**（平行四边形恒等式、列满秩、对称 + 幂等、$\mathrm{cond}$ 平方、正交性损失量级、截断阈值），否则按半对给 $1$ 分；② 手算题凡是**跳过 $A^{\mathrm T}\boldsymbol r=\boldsymbol 0$ 自检**或**不写中间量**的，从收口里扣 $1$ 分；③ 概念题把「$\mathrm{cond}(A)$ 很小的良态问题」与「算法要不要换」混为一谈的，按概念性错误处理（该题理由不得分）。

<a id="map"></a>

## 漏点定位表

| 错题 | 回去读 | 立刻补做 |
|:--|:--|:--|
| 1、2、11 | [2.1.2](sec21.md#sec-2.1.2)、[@ex-2.1.2]、[@thm-2.1.4] | [习题 A1](exercises.md)、[回忆卡 A2/B2](recall-cards.md#rc2-b-conditions) |
| 3、4、5、16 | [2.2.1](sec22.md#sec-2.2.1)、[2.2.3](sec22.md#sec-2.2.3) 指纹框、[@thm-2.2.5] | [习题 A2](exercises.md)、[习题 B3](exercises.md) |
| 6、7、8、9、15、17、20 | [2.3.3](sec23.md#sec-2.3.3) 实测表、[@thm-2.3.5]、[2.4.2](sec24.md#sec-2.4.2) 判据表、[2.4.4](sec24.md#sec-2.4.4)、[2.4.6](sec24.md#sec-2.4.6) 错误 1–4 | [习题 A3](exercises.md)、[习题 C2](exercises.md)、[习题 B5](exercises.md)、[习题 D1](exercises.md) |
| 10、13、14 | [2.5.1](sec25.md#sec-2.5.1) 三者关系框、[@thm-2.5.2]、[@thm-2.5.3] | [习题 C4](exercises.md)、[习题 C6](exercises.md) |
| 12、18、19 | [2.3.5](sec23.md#sec-2.3.5)、[2.6.1](sec26.md#sec-2.6.1)、[@thm-2.6.4]、[2.6.4](sec26.md#sec-2.6.4) 思考（数值秩）、[2.7.3](sec27.md#sec-2.7.3) 实验三 | [习题 C1](exercises.md)、[习题 C5](exercises.md)、[习题 D4](exercises.md) | **最后一句**：本卷的目的不是打分，而是**分清「公式会算」与「知道什么时候能算」**。凡错在「条件」上的题（列满秩、$R$ 对角元为正、$\mathrm{cond}\cdot\rho_A\lt1$、噪声水平定阈值、中心化），回到 [2.8.2](sec28.md#sec-2.8.2) 的八个陷阱逐条对照；同一类错误出现两次以上，那不是粗心，而是概念缺口。
