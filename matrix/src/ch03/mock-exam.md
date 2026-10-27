# 综合自测卷 · 第三章（第一分卷 3.1–3.2 · 第二分卷 3.4–3.5 · 3.6–3.7 加练见习题集）

**用途：**在学完对应批次的内容之后，检验自己是否真的掌握了这一阶段。**请计时、闭卷、独立完成**——查书或看解答做出来的分数没有意义。

每份分卷**建议用时 60 分钟 · 满分 100 分**（两卷可分两天做）。做完后对照文末评分标准给自己打分，再用[学习目标自检表](checklist.md)反查到正文薄弱小节。

::: note 使用说明

两份分卷结构相同：概念判断（每题 4 分，共 32 分）$+$ 计算题（每题 12 分，共 48 分）$+$ 证明题（每题 10 分，共 20 分）。题目**绝大多数为新增**，覆盖与[习题集](exercises.md)相同的知识点，并逐条对准[自检表](checklist.md)的关键目标。

**第一分卷**的第 13 题与习题 B1、第 14 题与习题 B5 考的是同一批结论（相抵 $\iff$ 同秩、满秩分解的唯一性），**有意保留**——它们是本阶段的两条主干证明，隔一段时间再完整写一遍，正好检验是不是真的会「用过渡矩阵」和「用亏加秩」。第 9 题的分块矩阵读块与第 8 题的「充分 / 充要」两处，分别对着 [3.1](sec31.md) 勘误 E3.1 与 [3.2](sec32.md) 勘误 E3.4——做错时先回看勘误，再回正文。

**第二分卷**的第 23 题对准 GS 手算流程（[例 3.4.A](sec34.md#ex-3.4.A)）、第 26 题对准候选法（[例 3.5.4](sec35.md#ex-3.5.4) 与 [例 3.5.B](sec35.md#ex-3.5.B)）；第 15(c) 题的正线辨析与第 17(c) 题的「卡死」分别连着 [3.4](sec34.md) 勘误 E3.7 与旋转阵反例；第 28 题与习题 B17 同源（最小多项式同根），有意保留。解答默认折叠，便于自测。
:::

## 第一分卷 · 3.1–3.2

### 第一部分 · 概念判断（每题 4 分，共 32 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**1.** 判断以下三句：**(a)** 任何矩阵都有相抵分解，任何秩 $r>0$ 的矩阵都有满秩分解；**(b)** 相抵分解式不唯一，但只要给定 $A$，任何一种相抵分解式中间的 $\Gamma$ 都相同；**(c)** 两个 $3\times4$ 矩阵相抵 $\iff$ 它们的秩相等。

**2.** 设 $A$ 是 $2\times4$ 矩阵、$\operatorname{rank}A=2$。判断以下三句：**(a)** $A$ 有右逆；**(b)** $A$ 有左逆；**(c)** $A$ 的全部右逆构成一个无穷集合，且其中任意两个之差（作为矩阵）的每一列都属于 $N(A)$。

**3.** 设 $A$ 是 $n$ 阶方阵。判断以下两句：**(a)** 若 $A$ 是行满秩的 $2\times3$ 矩阵，则「$AB=I$ 推出 $B$ 是 $A$ 的逆」；**(b)** 又，「乘积为单位阵的两矩阵必可逆」这句话，只要补上「方阵」二字就正确。

**4.** 判断以下三句：**(a)** $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 对任何 $A\in\mathbb C^{m\times n}$ 成立；**(b)** 上述证明的核心是「$A\boldsymbol{x}=\boldsymbol{0}$ 与 $A^{\mathrm H}A\boldsymbol{x}=\boldsymbol{0}$ 同解」，其中「$\supseteq$」方向用到了内积的正定性；**(c)** 同理可证 $\operatorname{rank}A=\operatorname{rank}(AA^{\mathrm H})$。

**5.** 设 $A=BC$ 是 $3\times4$、秩 $2$ 矩阵 $A$ 的满秩分解。判断以下三句：**(a)** $B$ 是 $3\times2$ 列满秩、$C$ 是 $2\times4$ 行满秩；**(b)** $R(A)=R(B)$，且 $C$ 的列就是 $A$ 的各列在 $B$ 的列这组基下的坐标；**(c)** $B$ 的两列必须是 $A$ 的前两列。

**6.** 判断以下两句：**(a)** 满秩分解「不唯一」的精确含义是：任意两种分解相差一个**可逆**矩阵 $D$（$B_1=B_2D$、$C_1=D^{-1}C_2$）；**(b)** 反过来，任取可逆 $D$，由一种分解就能造出无穷多种满秩分解。

**7.** 设 $A=BC$ 是满秩分解。判断以下两句：**(a)** 矩阵方程 $AXA=A$ 等价于 $CXB=I_r$（不只是「一个充分条件」）；**(b)** 例 3.2.2 构造的 $X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}$ 是方程的唯一解。

**8.** 判断以下三句：**(a)** 相似是相抵的特例，但相抵不必相似；**(b)**「行满秩矩阵有左逆」；**(c)** $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 可以推广为：对任意数域 $F$ 上的矩阵 $A$，$\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm T}A)$。

::: sol 第一部分答案（每题 4 分：判断 1 分 + 理由 3 分）

**1. 对、对、对。****(a)** 相抵分解见 [@lem-3.1.1]（任何矩阵，含零矩阵取 $\Gamma=O$）；满秩分解见 [@thm-3.2.1]（要求 $r>0$——$A=O$ 时不存在列满秩的 $B$）。**(b)** 正是 [@note-3.1-nonunique] 与 [@note-3.1-rank]：分解式因 $P$、$Q$ 的取法无穷而不唯一，但中间的标准形由秩唯一决定（秩在相抵下不变）。**(c)** [@note-3.1-rank]：同型矩阵相抵 $\iff$ 同秩。

**2. (a) 对、(b) 错、(c) 对。****(a)** $\operatorname{rank}A=2=m$，行满秩 $\Rightarrow$ 有右逆（[@thm-3.1.1]）。**(b)** 列不满秩（$2<4$），无左逆。**(c)** 若 $B_1$、$B_2$ 是右逆，则 $A(B_1-B_2)=I-I=O$，故 $B_1-B_2$ 的每一列 $\in N(A)$；而 $N(A)$ 维数 $=n-r=2>0$，可取任意参数，故右逆无穷多。**（本题即 [@thm-3.1.1] 注 1 与 [@ex-3.1.C] 的抽象版。）**

**3. (a) 假、(b) 真。****(a)** $2\times3$ 矩阵不是方阵，$AB=I_2$ 只说明 $A$ 行满秩、$B$ 是**右逆**：既不能推出 $BA=I_3$，也不能称 $B$ 为「逆」。反例一眼可见：$A=\begin{bmatrix}1&0&0\\0&1&0\end{bmatrix}$、$B=\begin{bmatrix}1&0\\0&1\\0&0\end{bmatrix}$，有 $AB=I_2$ 而 $BA=\begin{bmatrix}1&0&0\\0&1&0\\0&0&0\end{bmatrix}\neq I_3$。**(b)** 正确说法见 [3.1.3](sec31.md#sec-3.1.3)：两**方阵**乘积为单位阵 $\Rightarrow$ 二者可逆且互逆；长方阵情形只能谈单侧逆（[@thm-3.1.1]）。

**4. (a) 对、(b) 对、(c) 对。**三句都是 [@prop-3.1.1] 的内容。**(b)** 的「$\supseteq$」方向：由 $A^{\mathrm H}A\boldsymbol{z}=\boldsymbol{0}$ 左乘 $\boldsymbol{z}^{\mathrm H}$ 得 $(A\boldsymbol{z},A\boldsymbol{z})=0$，靠 [@def-1.4.1]（4）的**正定性**推出 $A\boldsymbol{z}=\boldsymbol{0}$。**(c)** 对 $A^{\mathrm H}$ 重做一遍即得，再结合 $\operatorname{rank}A=\operatorname{rank}A^{\mathrm H}$ 得到四项等式链。

**5. (a) 对、(b) 对、(c) 错。****(a)** [@thm-3.2.1]：$B\in\mathbb C^{m\times r}_r$（这里 $3\times2$）、$C\in\mathbb C^{r\times n}_r$（这里 $2\times4$）。**(b)** $R(A)=R(B)$ 见 [@thm-3.2.2] 证明第一步或 [@ex-B7]；$C$ 的列是坐标——这正是「读法」。**(c)** 错：[@note-3.2-columns]（注 2）的反例 $A=I_2A$ 说明 $B$ 不必取自 $A$ 的列；一般地 $R(A)$ 的任何一组基都可以。

**6. (a) 对、(b) 对。**两句都是 [@thm-3.2.2] 与 [@note-3.2.unique]：定理给出「任意两种分解相差可逆 $D$」（必要性），注 3 的补证给出「任取可逆 $D$ 都能造新分解」（充分性）——合起来是「一个分解即生成全部」。**失分点**：忘掉「$D$ 可逆」，或把 $D$ 写成不可逆的矩阵族。

**7. (a) 对、(b) 错。****(a)** 见 [@note-3.2-axa-iff]：课件写「充分条件」，反方向也可证（左乘 $B$ 的左逆、右乘 $C$ 的右逆），故是**充要**条件。**(b)** 错：$X$ 只是**一个**解（伪逆 $A^+$）——方程 $AXA=A$ 的解集是仿射子空间，通常有无穷多解（例：[@ex-3.2.2] 型矩阵上，任意「满足 $CXB=I_r$」的 $X$ 都是解）。$A$ 可逆时解才唯一，为 $X=A^{-1}$。

**8. (a) 对、(b) 假、(c) 假。****(a)** $B=P^{-1}AP$ 是取 $Q=P$ 的相抵（[@thm-2.3.5]、[@cor-2.3.4]）；反向不真（相抵允许两侧独立、且对长方阵也有定义）。**(b)** 应说「**行满秩矩阵有右逆；列满秩矩阵有左逆**」（[@thm-3.1.1]）——方向与 $AB=I$、$BA=I$ 的写法绑定。**(c)** 错：证明依赖**共轭转置**与内积**正定性**，只在实 / 复内积空间成立；一般数域上没有共轭转置，$A^{\mathrm T}A$ 与 $A$ 的秩关系需要另行讨论。
:::

### 第二部分 · 计算题（每题 12 分，共 48 分）

**9.** 设 $A=\begin{bmatrix}1&2&1\\ 2&5&3\\ 1&3&2\end{bmatrix}$。

**(a)** 求 $A$ 的相抵分解式：写出 $E$、$F$（满足 $EAF=\Gamma$），再写出 $A=P^{-1}\Gamma Q$ 中的 $P^{-1}$、$Q$；
**(b)** 回代验证你的分解式。

::: sol 第九题解答

**(a)** 先定秩：第三行 $=$ 第二行 $-$ 第一行（$(2,5,3)-(1,2,1)=(1,3,2)$），故 $r=2$。

**消元**（若用分块矩阵法，[@method-3.1-augmented]；只动前 3 行 / 前 3 列）：

- 行变换：$r_2\leftarrow r_2-2r_1$、$r_3\leftarrow r_3-r_1$、$r_3\leftarrow r_3-r_2$、$r_1\leftarrow r_1-2r_2$，总积

$$E=\begin{bmatrix}5&-2&0\\ -2&1&0\\ 1&-1&1\end{bmatrix};$$

- 列变换：$c_3\leftarrow c_3+c_1$、$c_3\leftarrow c_3-c_2$，总积

$$F=\begin{bmatrix}1&0&1\\ 0&1&-1\\ 0&0&1\end{bmatrix}.$$

**验算 $EAF=\Gamma$**：

$$EAF=\begin{bmatrix}5&-2&0\\-2&1&0\\1&-1&1\end{bmatrix}\begin{bmatrix}1&2&1\\2&5&3\\1&3&2\end{bmatrix}\begin{bmatrix}1&0&1\\0&1&-1\\0&0&1\end{bmatrix}
=\begin{bmatrix}1&0&-1\\0&1&1\\0&0&0\end{bmatrix}\begin{bmatrix}1&0&1\\0&1&-1\\0&0&1\end{bmatrix}=\begin{bmatrix}1&0&0\\0&1&0\\0&0&0\end{bmatrix}=\Gamma\ \checkmark$$

**写分解式**：由 $EAF=\Gamma$ 得 $A=E^{-1}\Gamma F^{-1}$（[@method-3.1-augmented]），故

$$P^{-1}=E^{-1}=\begin{bmatrix}1&2&0\\ 2&5&0\\ 1&3&1\end{bmatrix},\qquad Q=F^{-1}=\begin{bmatrix}1&0&-1\\ 0&1&1\\ 0&0&1\end{bmatrix}.$$

**(b) 验证**：$P^{-1}\Gamma Q=\begin{bmatrix}1&2&0\\2&5&0\\1&3&0\end{bmatrix}\begin{bmatrix}1&0&-1\\0&1&1\\0&0&1\end{bmatrix}=\begin{bmatrix}1&2&1\\2&5&3\\1&3&2\end{bmatrix}=A$ ✓。

**评分**：定秩 1 分；两组变换各 2 分；读块（$E=P$、$F=Q^{-1}$）1 分；写出 $P^{-1}$、$Q$ 各 2 分；回代验证 2 分。**常见失分**：把 $E$ 当成 $P^{-1}$ 直接代入（勘误 E3.1）。
:::

**10.** 继续上题的 $A$ 与 $E$、$F$。

**(a)** 用相抵标准形解方程组 $A\boldsymbol{x}=\boldsymbol{b}_1$，$\boldsymbol{b}_1=(1,2,1)^{\mathrm T}$，写出通解；
**(b)** 判断 $A\boldsymbol{x}=\boldsymbol{b}_2$（$\boldsymbol{b}_2=(1,2,3)^{\mathrm T}$）是否有解，并说明理由。

::: sol 第十题解答

记 $\boldsymbol{y}=F^{-1}\boldsymbol{x}$（即 $\boldsymbol{x}=F\boldsymbol{y}$），方程变为 $\Gamma\boldsymbol{y}=E\boldsymbol{b}$。

**(a)** $E\boldsymbol{b}_1=\begin{bmatrix}5&-2&0\\-2&1&0\\1&-1&1\end{bmatrix}\begin{bmatrix}1\\2\\1\end{bmatrix}=\begin{bmatrix}1\\0\\0\end{bmatrix}$，后 $m-r=1$ 个分量为 $0$ ✓ 有解。由 $\Gamma\boldsymbol{y}=(y_1,y_2,0)^{\mathrm T}$ 读得 $y_1=1$、$y_2=0$、$y_3$ 任意（记 $y_3=s$）：

$$\boldsymbol{x}=F\boldsymbol{y}=\begin{bmatrix}1&0&1\\ 0&1&-1\\ 0&0&1\end{bmatrix}\begin{bmatrix}1\\0\\s\end{bmatrix}=\begin{bmatrix}1+s\\ -s\\ s\end{bmatrix}.$$

**验算**：$A\boldsymbol{x}=\big((1+s)-2s+s,\ 2(1+s)-5s+3s,\ (1+s)-3s+2s\big)^{\mathrm T}=(1,2,1)^{\mathrm T}=\boldsymbol{b}_1$ ✓；自由参数 $1=n-r$ ✓。

**(b)** $E\boldsymbol{b}_2=\begin{bmatrix}5-4\\-2+2\\1-2+3\end{bmatrix}=\begin{bmatrix}1\\0\\2\end{bmatrix}$，**第三个分量 $\neq0$**，故**无解**。对照经典判据：$\boldsymbol{b}_2$ 不满足行关系「第三分量 $=$ 第二分量 $-$ 第一分量」（$3\neq2-1=1$），即 $\operatorname{rank}(A|\boldsymbol{b}_2)=3>\operatorname{rank}A=2$。

**评分**：(a) 求出 $E\boldsymbol{b}_1$ 2 分、判可解 1 分、通解 5 分（含乘回 $F$ 与自由参数）；(b) 计算 2 分、判断与理由 2 分。
:::

**11.** 设 $A=\begin{bmatrix}1&0&1\\ 0&1&1\end{bmatrix}$。

**(a)** 判断 $A$ 是否有右逆、左逆；
**(b)** 用公式构造一个右逆并验算；
**(c)** 写出 $A$ 的**全部**右逆。

::: sol 第十一题解答

**(a)** $2\times3$、两行不成比例 $\Rightarrow$ $\operatorname{rank}A=2=m$：**行满秩，有右逆**；列满秩不成立（$2<3$），**无左逆**。

**(b)** $AA^{\mathrm H}=\begin{bmatrix}2&1\\1&2\end{bmatrix}$，$\det=3$，$(AA^{\mathrm H})^{-1}=\dfrac13\begin{bmatrix}2&-1\\-1&2\end{bmatrix}$，

$$B_0=A^{\mathrm H}(AA^{\mathrm H})^{-1}=\frac13\begin{bmatrix}1&0\\0&1\\1&1\end{bmatrix}\begin{bmatrix}2&-1\\-1&2\end{bmatrix}=\frac13\begin{bmatrix}2&-1\\ -1&2\\ 1&1\end{bmatrix}.$$

**验算**：$AB_0=\dfrac13\begin{bmatrix}1&0&1\\0&1&1\end{bmatrix}\begin{bmatrix}2&-1\\-1&2\\1&1\end{bmatrix}=\dfrac13\begin{bmatrix}3&0\\0&3\end{bmatrix}=I_2$ ✓。

**(c)** 设 $B=B_0+Z$，则 $AB=I_2\iff AZ=O\iff Z$ 的每列 $\in N(A)$。解 $A\boldsymbol{x}=\boldsymbol{0}$：$x_1+x_3=0$、$x_2+x_3=0$，取 $x_3=1$ 得 $\boldsymbol{n}=(-1,-1,1)^{\mathrm T}$。故

$$B=\frac13\begin{bmatrix}2&-1\\ -1&2\\ 1&1\end{bmatrix}+\begin{bmatrix}-s&-t\\ -s&-t\\ s&t\end{bmatrix},\qquad s,t\in\mathbb C.$$

**评分**：(a) 4 分（判断 $+$ 理由各 2）；(b) 构造 4 分、验算 2 分；(c) 通式 2 分（写出「每列属于 $N(A)$」即可给满分）。
:::

**12.** 设 $A=\begin{bmatrix}1&0&1&2\\ 0&1&1&1\\ 1&1&2&3\end{bmatrix}$。

**(a)** 用 RREF 法求 $A$ 的满秩分解 $A=B_1C_1$；
**(b)** 再写出一种**不同的**满秩分解 $A=B_2C_2$（$B_2$ 取 $A$ 的第 1、3 列），并验证 $B_1=B_2D$、$C_1=D^{-1}C_2$ 中的 $D$ 确实可逆；
**(c)** 由此写出 $R(A)$ 的一组基与 $N(A)$ 的一组基。

::: sol 第十二题解答

**(a)** 化 RREF：$r_3-r_1-r_2=(0,0,0,0)$，故

$$R=\begin{bmatrix}1&0&1&2\\ 0&1&1&1\\ 0&0&0&0\end{bmatrix},\qquad r=2,\ \text{主元列}=1,2 .$$

$B_1=A$ 的第 1、2 列 $=\begin{bmatrix}1&0\\0&1\\1&1\end{bmatrix}$，$C_1=R$ 的前两行 $=\begin{bmatrix}1&0&1&2\\ 0&1&1&1\end{bmatrix}$。验算：$B_1C_1=\begin{bmatrix}1&0&1&2\\0&1&1&1\\1&1&2&3\end{bmatrix}=A$ ✓。

**(b)** $B_2=A$ 的第 1、3 列 $=\begin{bmatrix}1&1\\0&1\\1&2\end{bmatrix}$，由 $C_2=(B_2^{\mathrm H}B_2)^{-1}B_2^{\mathrm H}A$（[@ex-3.2.A] 后的本编补注：给定 $B$ 则 $C$ 唯一）算得

$$C_2=\begin{bmatrix}1&-1&0&1\\ 0&1&1&1\end{bmatrix},\qquad\text{验算}\ B_2C_2=\begin{bmatrix}1&-1+1&1&1+1\\ 0&1&1&1\\ 1&-1+2&2&1+2\end{bmatrix}=\begin{bmatrix}1&0&1&2\\0&1&1&1\\1&1&2&3\end{bmatrix}=A\ \checkmark$$

（列方向核对：$\boldsymbol{a}_2=\boldsymbol{b}_1-\boldsymbol{b}_2$、$\boldsymbol{a}_3=\boldsymbol{b}_2$、$\boldsymbol{a}_4=\boldsymbol{b}_1+\boldsymbol{b}_2$。）**求 $D$**：由 $B_1=B_2D$、$D$ 可逆且 $D=B_2^{\mathrm L}B_1=(B_2^{\mathrm H}B_2)^{-1}B_2^{\mathrm H}B_1$，

$$D=\begin{bmatrix}1&-1\\ 0&1\end{bmatrix},\qquad \det D=1\neq0\ \checkmark$$

**验证**：$B_2D=\begin{bmatrix}1&1\\0&1\\1&2\end{bmatrix}\begin{bmatrix}1&-1\\0&1\end{bmatrix}=\begin{bmatrix}1&0\\0&1\\1&1\end{bmatrix}=B_1$ ✓；$D^{-1}C_2=\begin{bmatrix}1&1\\0&1\end{bmatrix}\begin{bmatrix}1&-1&0&1\\0&1&1&1\end{bmatrix}=\begin{bmatrix}1&0&1&2\\0&1&1&1\end{bmatrix}=C_1$ ✓。

**(c)** $R(A)=R(B_1)=\operatorname{span}\{(1,0,1)^{\mathrm T},(0,1,1)^{\mathrm T}\}$（[@ex-B7] 或 [@thm-3.2.2] 证明第一步）。$N(A)$：由 $C_1$ 的后两列（自由列）或直接解方程：$x_1+x_3+2x_4=0$、$x_2+x_3+x_4=0$，取 $(x_3,x_4)=(1,0)$ 与 $(0,1)$：

$$\boldsymbol{n}_1=(-1,-1,1,0)^{\mathrm T},\qquad \boldsymbol{n}_2=(-2,-1,0,1)^{\mathrm T},\qquad N(A)=\operatorname{span}\{\boldsymbol{n}_1,\boldsymbol{n}_2\}\ (\dim=2=n-r\ \checkmark)$$

**评分**：(a) RREF 2 分、$B_1C_1$ 3 分；(b) $C_2$ 3 分、$D$ 与验证 2 分；(c) 2 分。
:::

### 第三部分 · 证明题（每题 10 分，共 20 分）

**13.** 证明：两个同型矩阵 $A,B$ 相抵 $\iff$ $\operatorname{rank}A=\operatorname{rank}B$。

::: sol 第十三题解答

**必要性**：设 $B=P^{-1}AQ$（$P,Q$ 可逆）。用两步「乘可逆矩阵不改变秩」：

$$\operatorname{rank}(P^{-1}AQ)=\operatorname{rank}(AQ)=\operatorname{rank}A,$$

其中 $\operatorname{rank}(AQ)=\operatorname{rank}A$ 的理由是 $R(AQ)=A(R(Q))$ 且 $Q$ 满射（或：$N(Q)=N(AQ)$ 加亏加秩）。故相抵的矩阵同秩。

**充分性**：设 $\operatorname{rank}A=\operatorname{rank}B=r$。由 [@lem-3.1.1]，存在可逆矩阵使

$$A=P_1^{-1}\Gamma P_2,\qquad B=Q_1^{-1}\Gamma Q_2$$

（同一个 $\Gamma$，因为两者秩同为 $r$）。于是

$$B=Q_1^{-1}\Gamma Q_2=Q_1^{-1}\big(P_1AP_2^{-1}\big)Q_2=\underbrace{(Q_1^{-1}P_1)}_{\text{可逆}}A\underbrace{(P_2^{-1}Q_2)}_{\text{可逆}},$$

即 $A$ 与 $B$ 相抵。∎

**评分**：必要性 4 分（两个方向各 2 分）、充分性 6 分（同一个 $\Gamma$ 的论证 3 分、拼出可逆矩阵 3 分）。**要点**：充分性的关键是「同秩 $\Rightarrow$ 相抵于**同一个** $\Gamma$」，这正是标准形由秩唯一决定（[@note-3.1-rank]）的用处。
:::

**14.** 设 $A\in\mathbb C^{m\times n}_r$（$r>0$），$A=B_1C_1$ 与 $A=B_2C_2$ 是两种满秩分解。证明：存在可逆矩阵 $D$ 使 $B_1=B_2D$、$C_1=D^{-1}C_2$。

::: sol 第十四题解答

**第一步（两个列空间相同）**：因为 $C_1$ 行满秩，由 [@thm-3.1.1] 它有右逆，即 $C_1$ 作为映射是满射。于是

$$R(B_1)=R(B_1C_1)=R(A),$$

理由：$R(A)\subseteq R(B_1)$ 显然（$B_1C_1\boldsymbol{x}=B_1(C_1\boldsymbol{x})$）；反向任取 $\boldsymbol{y}=B_1\boldsymbol{u}$，由 $C_1$ 满射取 $\boldsymbol{x}$ 使 $C_1\boldsymbol{x}=\boldsymbol{u}$，则 $\boldsymbol{y}=B_1C_1\boldsymbol{x}\in R(A)$。同理 $R(B_2)=R(A)$，故 $R(B_1)=R(B_2)$。

**第二步（过渡矩阵）**：$B_1$、$B_2$ 的列分别是 $r$ 维子空间 $R(A)$ 的两组基（列满秩 $\Rightarrow$ 列无关，且各含 $r$ 列）。由过渡矩阵的存在唯一性（[@def-1.3.5]、[@prop-1.3.1]），存在**可逆**矩阵 $D$ 使

$$B_1=B_2D .$$

**第三步（$C$ 随之确定）**：由 $B_2C_2=A=B_1C_1=B_2DC_1$ 得 $B_2(C_2-DC_1)=O$。$B_2$ 的列线性无关，写 $C_2-DC_1$ 的每一列为 $\boldsymbol{v}_j$，则 $B_2\boldsymbol{v}_j=\boldsymbol{0}$ 迫使 $\boldsymbol{v}_j=\boldsymbol{0}$（[@thm-1.3.2] 表示唯一性），即 $C_2=DC_1$，故

$$C_1=D^{-1}C_2 .\qquad\blacksquare$$

**评分**：第一步 4 分（必须用「$C_1$ 满射」；只说「显然」不给分）、第二步 3 分（指出 $D$ 可逆）、第三步 3 分（指出用 $B_2$ 列无关）。
:::

## 第二分卷 · 3.4–3.5

### 第一部分 · 概念判断（每题 4 分，共 32 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**15.** 判断以下三句：**(a)** 满秩复方阵的 QR 分解总存在，且在「$R$ 正线」约定下唯一；**(b)** 例 3.4.2（$A=\begin{bmatrix}1&1\\0&0\end{bmatrix}$）说明不满秩方阵不存在 QR 分解；**(c)** 满足 $Q^{\mathrm H}Q=I_n$ 的 $m\times n$（$m>n$）矩阵 $Q$ 是酉矩阵。

**16.** 关于满秩实方阵 QR 分解的「不唯一」，判断：**(a)** 任意两种分解（$R$ 可逆上三角）恰好相差一个对角正交阵；**(b)** 二阶实满秩方阵恰有 $4$ 种这样的分解；**(c)** 把「正线」要求加回去，这 $4$ 种里恰剩 $1$ 种。

**17.** 关于 QR 算法，判断：**(a)** 每个 $A_k$ 都与 $A$ 相似，特征值全程不变；**(b)**「各特征值模值互不相同」是收敛的必要条件；**(c)** 旋转阵 $A=\begin{bmatrix}0&-1\\1&0\end{bmatrix}$ 的迭代序列恒等于 $A$，是「等模可能卡死」的实例。

**18.** 关于 Schur 引理，判断：**(a)** 任意复方阵酉相似于上三角阵；**(b)** 任意实方阵正交相似于上三角阵；**(c)** 特征值全为实数的实方阵正交相似于上三角阵。

**19.** 设 $A$ 的特征值为 $\lambda_1,\cdots,\lambda_n$，$\varphi$ 为任一多项式。判断：**(a)** $\varphi(A)$ 的特征值为 $\varphi(\lambda_1),\cdots,\varphi(\lambda_n)$；**(b)** $\varphi(A)$ 的特征向量都是 $A$ 的特征向量；**(c)** 取 $\varphi(\lambda)=\lambda^m$ 即得 $A^m$ 的特征值为 $\lambda_1^m,\cdots,\lambda_n^m$。

**20.** 关于 Hamilton–Cayley 定理，判断：**(a)** $f_A(A)=O$ 对任何复方阵成立；**(b)** 它的证明只需验证「$f_A(\Lambda)$ 的对角元全为零」；**(c)** 证明中因子 $(\Lambda-\lambda_kI)$ 必须按 $\lambda_1,\lambda_2,\cdots$ 的次序从右往左乘、逐列清零。

**21.** 关于最小多项式，判断：**(a)** $m_A(\lambda)$ 整除 $A$ 的任何零化多项式，特别地 $m_A\mid f_A$；**(b)** $f_A$ 与 $m_A$ 根相同（不计重数）；**(c)** $m_A=f_A$ 对一切方阵成立。

**22.** 关于推论 3.5.2，判断：**(a)** $a_0=f_A(0)\neq0\iff A$ 可逆；**(b)** $A$ 可逆时 $A^{-1}$ 可写成 $A$ 的多项式；**(c)** 例 3.5.3 课件的三处错误（特征多项式符号、公式行、答案 $(1,3)$ 元）是同源连锁的。

::: sol 第二分卷第一部分答案（每题 4 分：判断 1 分 + 理由 3 分）

**15. (a) 对、(b) 错、(c) 错。****(a)** [@thm-3.4.1]。**(b)** 该例恰恰**有**分解 $A=I_2\begin{bmatrix}1&1\\0&0\end{bmatrix}$（[@ex-3.4.2]）；丢掉的是唯一性（$R$ 不可逆，$r_{22}=0$ 非正线）。**(c)** 酉矩阵必须**方阵**（[@def-orth-matrix]）；这样的 $Q$ 只是列正交规范矩阵（[@def-3.4.2]），且 $QQ^{\mathrm H}\neq I_m$。

**16. (a) 对、(b) 对、(c) 对。**三条合起来就是 [3.4.1](sec34.md#sec-3.4.1) 的本编补注：$W=R_2R_1^{-1}$ 既酉又上三角 $\Rightarrow$ 对角、$|w_{ii}|=1$（习题 B11/B12）；实数情形 $w_i=\pm1$（$2^2=4$ 种）；正线把 $\overline{w_i}r_{ii}>0$ 逼成 $w_i=1$。

**17. (a) 对、(b) 错、(c) 对。****(a)** $A_{k+1}=Q_k^{\mathrm H}A_kQ_k$ 链起来（[@method-qr-algo]）。**(b)** 是**充分**条件（习题 A16：已正线的上三角阵迭代不动，模不必互异）。**(c)** $A$ 正交 $\Rightarrow$ 其正线 QR 分解为 $A=A\cdot I\Rightarrow A_2=A$，永不动（习题 B13）。

**18. (a) 对、(b) 错、(c) 对。****(a)** [@thm-3.5.2]。**(b)** 旋转阵特征值 $\pm\mathrm i$：正交相似保持实性，实上三角阵特征值全实，矛盾。**(c)** [@thm-3.5.3]，前提「特征值均为实数」。

**19. (a) 对、(b) 错、(c) 对。****(a)** [@cor-3.5.1]。**(b)** 单向：$A=\operatorname{diag}(1,-1)$、$\varphi=\lambda^2$ 时 $\varphi(A)=2I$ 的一切向量都是特征向量。**(c)** 特款。

**20. (a) 对、(b) 错、(c) 对。****(b)** 是最典型的糊弄：对角全零的上三角阵可以非零（$\begin{bmatrix}0&1\\0&0\end{bmatrix}$）；必须按次序乘因子、归纳清列（[@thm-3.5.4] 证明）。**(c)** 同前。

**21. (a) 对、(b) 对、(c) 错。****(a)(b)** [@thm-3.5.5]。**(c)** 反例 $A=I_2$：$f_A=(\lambda-1)^2$，$m_A=\lambda-1$。

**22. (a) 对、(b) 对、(c) 对。****(a)** $a_0=(-1)^n\det A$（[@cor-3.5.2] 证明）。**(b)** 公式本身就是多项式。**(c)** 见 E3.5：符号错 $\Rightarrow$ 公式行错 $\Rightarrow$ 答案错，一环扣一环。
:::

### 第二部分 · 计算题（每题 12 分，共 48 分）

**23.** 求 $A=\begin{bmatrix}1&2\\ 2&2\end{bmatrix}$ 的 QR 分解（$Q$ 正交、$R$ 正线上三角），**写出 GS 的每一步**并回代验证。

::: sol 第二十三题解答

$\det A=-2\neq0$，满秩 ✓。$\boldsymbol{a}_1=(1,2)^{\mathrm T}$：$\|\boldsymbol{y}_1\|=\sqrt5$，$\boldsymbol{z}_1=\tfrac{1}{\sqrt5}(1,2)^{\mathrm T}$。$\boldsymbol{a}_2=(2,2)^{\mathrm T}$：$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{6}{\sqrt5}$，

$$\boldsymbol{y}_2=(2,2)^{\mathrm T}-\tfrac65(1,2)^{\mathrm T}=\left(\tfrac45,-\tfrac25\right)^{\mathrm T},\qquad \|\boldsymbol{y}_2\|=\frac{2}{\sqrt5},\quad \boldsymbol{z}_2=\frac{1}{\sqrt5}(2,-1)^{\mathrm T}.$$

$$Q=\frac{1}{\sqrt5}\begin{bmatrix}1&2\\ 2&-1\end{bmatrix},\qquad R=\begin{bmatrix}\sqrt5&\tfrac{6}{\sqrt5}\\ 0&\tfrac{2}{\sqrt5}\end{bmatrix}.$$

验算：$QR=\begin{bmatrix}1&\tfrac65-\tfrac25\\ 2&\tfrac45+\tfrac25\end{bmatrix}=\begin{bmatrix}1&2\\ 2&2\end{bmatrix}=A$ ✓（$Q$ 正交：$Q^{\mathrm T}Q=I$，$\det Q=-1$——反射型）。

**评分**：GS 两步各 3 分（残差非对角系数 $(\boldsymbol{a}_2,\boldsymbol{z}_1)$ 与 $\|\boldsymbol{y}_2\|$ 是得分点）、拼装 3 分、验算 3 分。**常见失分**：$r_{22}$ 写成 $\|\boldsymbol{a}_2\|$。
:::

**24.** 设 $B=\begin{bmatrix}2&0\\ 0&1\\ 0&2\end{bmatrix}$。

**(a)** 求 $B$ 的完全 QR 分解 $B=Q\begin{bmatrix}R_1\\O\end{bmatrix}$（$Q$ 酉）；
**(b)** 从分解中读出 $R(B)$ 的一组标准正交基，并写出 $B$ 相应的满秩分解。

::: sol 第二十四题解答

**(a)** $\boldsymbol{a}_1=(2,0,0)^{\mathrm T}$：$\boldsymbol{z}_1=\boldsymbol{e}_1$，$r_{11}=2$；$\boldsymbol{a}_2=(0,1,2)^{\mathrm T}$ 已与 $\boldsymbol{z}_1$ 正交：$r_{12}=(\boldsymbol{a}_2,\boldsymbol{e}_1)=0$，$\|\boldsymbol{y}_2\|=\sqrt5$，$\boldsymbol{z}_2=\tfrac{1}{\sqrt5}(0,1,2)^{\mathrm T}$。补 $\boldsymbol{z}_3=\tfrac{1}{\sqrt5}(0,-2,1)^{\mathrm T}$（与 $\boldsymbol{z}_1,\boldsymbol{z}_2$ 正交、单位 ✓）。于是

$$B=\begin{bmatrix}1&0&0\\ 0&\tfrac{1}{\sqrt5}&-\tfrac{2}{\sqrt5}\\ 0&\tfrac{2}{\sqrt5}&\tfrac{1}{\sqrt5}\end{bmatrix}\begin{bmatrix}2&0\\ 0&\sqrt5\\ 0&0\end{bmatrix}\ \checkmark$$

（$Q^{\mathrm H}Q=I_3$ ✓；$R_1=\operatorname{diag}(2,\sqrt5)$ 正线上三角——本题两列天然正交，GS「零减步」。）

**(b)** $R(B)$ 的标准正交基：$\boldsymbol{z}_1=\boldsymbol{e}_1$、$\boldsymbol{z}_2=\tfrac{1}{\sqrt5}(0,1,2)^{\mathrm T}$（即 $Q$ 的前两列）。满秩分解（[3.4.2](sec34.md#sec-3.4.2) 的读法：$B=Q_1R_1$，$Q_1$ 列满秩 $=$ 基、$R_1$ 行满秩 $=$ 坐标）：

$$B=\begin{bmatrix}1&0\\ 0&\tfrac{1}{\sqrt5}\\ 0&\tfrac{2}{\sqrt5}\end{bmatrix}\begin{bmatrix}2&0\\ 0&\sqrt5\end{bmatrix}.$$

**评分**：(a) GS 与补齐 6 分、验证 2 分；(b) 基 2 分、满秩分解 2 分。**要点**：QR 是满秩分解的「正交升级」——本题两者一步同时到手。
:::

**25.** 设 $A=\begin{bmatrix}2&1&0\\ 0&2&0\\ 0&0&3\end{bmatrix}$。用推论 3.5.2 求 $A^{-1}$，并回代验证。

::: sol 第二十五题解答

$f_A(\lambda)=(\lambda-2)^2(\lambda-3)=\lambda^3-7\lambda^2+16\lambda-12$（上三角，对角 $2,2,3$）。$a_2=-7$、$a_1=16$、$a_0=-12$（$=(-1)^3\det A$，$\det A=12$ ✓）：

$$A^{-1}=-\frac{1}{-12}\big(A^2-7A+16I\big)=\frac{1}{12}\big(A^2-7A+16I\big).$$

$A^2=\begin{bmatrix}4&4&0\\0&4&0\\0&0&9\end{bmatrix}$，$A^2-7A+16I=\begin{bmatrix}6&-3&0\\0&6&0\\0&0&4\end{bmatrix}$，故

$$A^{-1}=\begin{bmatrix}\tfrac12&-\tfrac14&0\\ 0&\tfrac12&0\\ 0&0&\tfrac13\end{bmatrix}.$$

验算：$AA^{-1}=\begin{bmatrix}1&-1+\tfrac12+\tfrac12&0\\0&1&0\\0&0&1\end{bmatrix}=I$ ✓（$2\cdot(-\tfrac14)+1\cdot\tfrac12=0$ ✓）。

**评分**：$f_A$ 与系数 4 分、公式（含符号与 $-\frac{1}{a_0}$）4 分、计算与验算 4 分。**常见失分**：$-\frac{1}{a_0}$ 的符号、$a_i$ 与 $A$ 的幂错位配对（对照例 3.5.3 的课件连环错）。
:::

**26.** 设 $A=\begin{bmatrix}2&1&1\\ 0&2&1\\ 0&0&2\end{bmatrix}$。

**(a)** 求 $f_A$ 与最小多项式 $m_A$（写出候选与试算过程）；
**(b)** 用 $m_A$（或 H–C）把 $A^3$ 写成 $A$ 的二次多项式并算出显式结果；
**(c)** 用「$A=2I+M$ 的二项式展开」核对 (b)。

::: sol 第二十六题解答

**(a)** $f_A(\lambda)=(\lambda-2)^3$。候选 $\lambda-2$、$(\lambda-2)^2$、$(\lambda-2)^3$。$A-2I=M=\begin{bmatrix}0&1&1\\0&0&1\\0&0&0\end{bmatrix}\neq O$（排除第一个）；$M^2=\begin{bmatrix}0&0&1\\0&0&0\\0&0&0\end{bmatrix}\neq O$（排除第二个）；$M^3=O$ ✓。故 $m_A(\lambda)=(\lambda-2)^3=f_A$。

**(b)** $(\lambda-2)^3=\lambda^3-6\lambda^2+12\lambda-8$，H–C 给 $A^3=6A^2-12A+8I$。$A^2=\begin{bmatrix}4&4&5\\0&4&4\\0&0&4\end{bmatrix}$，故

$$A^3=6A^2-12A+8I=\begin{bmatrix}8&12&18\\ 0&8&12\\ 0&0&8\end{bmatrix}.$$

**(c)** $A=2I+M$ 且 $I,M$ 可交换，二项式（到 $M^2$ 截断，$M^3=O$）：

$$A^3=8I+12M+6M^2=\begin{bmatrix}8&12&12\\0&8&12\\0&0&8\end{bmatrix}+6\begin{bmatrix}0&0&1\\0&0&0\\0&0&0\end{bmatrix}=\begin{bmatrix}8&12&18\\ 0&8&12\\ 0&0&8\end{bmatrix}\ \checkmark$$

**评分**：(a) 候选与试算 5 分（漏试 $(\lambda-2)^2$ 扣 2 分）；(b) 公式 3 分、结果 2 分；(c) 2 分。**要点**：几何重数不足（$N(A-2I)$ 一维）$\Rightarrow$ $m_A$ 必须带满重数（同 [例 3.5.B](sec35.md#ex-3.5.B)）。
:::

### 第三部分 · 证明题（每题 10 分，共 20 分）

**27.** 证明定理 3.4.1 的唯一性部分：满秩复方阵的 QR 分解（$Q$ 酉、$R$ 正线上三角）唯一。

::: sol 第二十七题解答

设 $A=Q_1R_1=Q_2R_2$，$Q_i$ 酉、$R_i$ 正线上三角。$A$ 满秩 $\Rightarrow R_i$ 可逆（$\operatorname{rank}R_i=\operatorname{rank}A=n$）。由 $Q_1R_1=Q_2R_2$：

$$W:=Q_2^{\mathrm H}Q_1=R_2R_1^{-1}.$$

$W$ 是酉阵之积故酉（[@thm-orth-algebra]）；是上三角阵之积之逆故上三角，对角元 $=$ 正 $/$ 正 $>0$。**断言 $W=I$**：对列归纳——第 $1$ 列只有 $w_{11}$ 可能非零，范数 $1$ 给 $|w_{11}|=1$，正 $\Rightarrow w_{11}=1$；设前 $j-1$ 列为 $\boldsymbol{e}_1,\cdots,\boldsymbol{e}_{j-1}$，第 $j$ 列与第 $i$ 列（$i<j$）正交给 $\overline{w_{ii}}w_{ij}=w_{ij}=0$，范数给 $|w_{jj}|=1$、正 $\Rightarrow w_{jj}=1$。故 $W=I$，于是 $Q_1=Q_2$、$R_2R_1^{-1}=I\Rightarrow R_1=R_2$。∎

**评分**：$W$ 的「双重身份」3 分；「上三角酉 $\Rightarrow$ 对角」归纳 4 分；正对角逼出 $1$ 并收尾 3 分。**要点**：满秩用在 $R_1$ 可逆；正线用在最后一逼。
:::

**28.** 证明定理 3.5.5（2）：特征多项式 $f_A$ 与最小多项式 $m_A$ 具有相同的根（不计重数）。

::: sol 第二十八题解答

「$m_A$ 的根都是 $f_A$ 的根」：由 H–C 定理 $f_A(A)=O$，故 $f_A$ 是零化多项式；由定理 3.5.5（1），$m_A$ 整除 $f_A$（若（1）未证，现场补：带余除法 $f_A=qm_A+r$、$\deg r<\deg m_A$，代值得 $r(A)=O$，最小性逼 $r=0$）。整除 $\Rightarrow$ $m_A$ 的根必是 $f_A$ 的根。

「$f_A$ 的根都是 $m_A$ 的根」：设 $\lambda_0$ 是 $f_A$ 的根，取特征向量 $\boldsymbol{\alpha}\neq\boldsymbol{0}$（$A\boldsymbol{\alpha}=\lambda_0\boldsymbol{\alpha}$）。归纳有 $A^k\boldsymbol{\alpha}=\lambda_0^k\boldsymbol{\alpha}$，线性组合得 $g(A)\boldsymbol{\alpha}=g(\lambda_0)\boldsymbol{\alpha}$ 对一切多项式 $g$。取 $g=m_A$：

$$\boldsymbol{0}=m_A(A)\boldsymbol{\alpha}=m_A(\lambda_0)\boldsymbol{\alpha}\ \Longrightarrow\ m_A(\lambda_0)=0.\qquad\blacksquare$$

**评分**：正方向（整除）4 分（若引（1）需现场补带余除法，否则扣 2 分）；反方向 6 分（必须显式用特征向量继承，只说「显然」不给分）。
:::

## 评分标准与后续

下表对**任意一份分卷**单独适用（卷一、卷二分别打分）：

| 分数段 | 判断 | 建议动作 |
|:--|:--|:--|
| 85–100 | 本阶段过关 | 进入下一批素材；隔一周重做卷一第 14 题、卷二第 27 题与习题 B5、B11 保持手感 |
| 70–84 | 基本掌握，有薄弱点 | 按[自检表](checklist.md)定位失分目标，重读对应小节并做该条「依据与习题」 |
| 55–69 | 半掌握 | 先重做[习题集](exercises.md) C 组全部计算题，再回来重做该分卷的计算题 |
| 55 以下 | 需要重学 | 卷一从 [3.1](sec31.md)、卷二从 [3.4](sec34.md) 开头重读，把每个「即时自测」做到全对再往下 |

**复盘方法**：把每道错题标注成三类之一——**概念错**（回读定义 / 定理原文）、**方向错**（左右、前后、逆的位置）、**算错**（重算并写出验算）。第三类最容易改；第二类要靠[勘误与补注](errata.md)（E3.1、E3.3 是「位置」问题，E3.5–E3.7 是「符号与数字」问题）；第一类必须回正文。

**3.6–3.8 的加练**不另设分卷：判断与正交化用[习题 C25–C31](exercises.md#ex-C25) 配[回忆卡 T17–T26](recall-cards.md)，限时用[竞技场](arena.md)的 S6–S10 加练（10 / 10 / 8 / 8 / 5 分钟）。这两节的计算题与 3.4–3.5 共用同一套评分口径：**判定 2 分、特征向量 4 分、列序与 $\Lambda$ 配对 2 分、回代验算 2 分**；谱分解再加 **$\sum E_j=I$ 与 $E_iE_j=0$ 各 1 分**；投影 / 最小二乘按「$A^{\mathrm H}A$ 可逆说明 1 分、投影矩阵或法方程 3 分、解与验算 2 分」给分；$\lambda$ 矩阵按「秩的判断 2 分、可逆性判断与理由 3 分」给分。

**待素材到位后**，3.3 三角分解与 3.9 及以后（奇异值分解、广义逆）将按同样的三段结构增补为第三分卷，与本卷合并为覆盖全第三章的完整自测。3.8 下半（Smith 标准形与 Jordan 标准形）的练习见[习题 A26–A27、C32–C34](exercises.md#ex-A26)。