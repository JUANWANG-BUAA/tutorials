# 附录 A · 延伸证明与推导

正文出于课程进度与篇幅的考虑，有几处结论「先当事实用」（重数不等式、迹与行列式、Cayley–Hamilton），有几处推广「只埋伏笔」（高维体积、极化、伪逆）。本附录把这些欠账一次还清：每一条都给出**只用本教程已学工具**的完整推导，并注明它兑现的是正文哪一处预告。各节彼此独立，可按需取读。

> **定位说明。**附录内容**超出本课程考核范围**：考试仍以正文为界。读它的目的有二——看清正文里「先当事实用」的话都是有证明的；以及为后续课程（谱理论、数值代数、广义逆）提前搭好骨架。编号规则：附录内的盒子按 A.1、A.2……独立编排。

| 本附录 | 兑现正文的哪一处 | 需要的预备 |
|:--|:--|:--|
| [A.1 极化恒等式](#sec-A.1) | [2.5](../ch02/sec25.md#sec-2.5.2) ②⟹③ 里的「极化」技巧 | [1.5](../ch01/sec15.md) 长度与内积 |
| [A.2 Gram 行列式 = 体积²](#sec-A.2) | [1.5.4](../ch01/sec15.md#sec-1.5.4) 的「高维体积」思考框 | [1.4](../ch01/sec14.md) Gram 矩阵、[1.6.7](../ch01/sec16.md#sec-1.6.7) 正交投影 |
| [A.3 迹、行列式与特征值](#sec-A.3) | [2.4.2](../ch02/sec24.md#sec-2.4.2) 的盘点清单 | 行列式展开、根与系数 |
| [A.4 几何重数 ≤ 代数重数](#sec-A.4) | [2.4.3](../ch02/sec24.md#sec-2.4.3) 的重数不等式 | [1.3](../ch01/sec13.md) 基扩充、[2.4](../ch02/sec24.md) 相似不变量 |
| [A.5 Cayley–Hamilton 定理](#sec-A.5) | [1.1.6](../ch01/sec11.md#sec-1.1.6) 的课程预告 | 伴随矩阵、矩阵多项式 |
| [A.6 正定矩阵的开方 A=CᴴC](#sec-A.6) | [1.4.3](../ch01/sec14.md#sec-1.4.3) 加权内积与 [1.6.8](../ch01/sec16.md#sec-1.6.8) 正线上三角 | [1.5.6](../ch01/sec15.md#sec-1.5.6) Gram–Schmidt |
| [A.7 Bessel 不等式与 Parseval 等式](#sec-A.7) | [1.5.7](../ch01/sec15.md#sec-1.5.7) 三角函数系与傅里叶系数 | [1.6](../ch01/sec16.md) 正交投影、[1.5.2](../ch01/sec15.md#sec-1.5.2) C–S |
| [A.8 Moore–Penrose 伪逆](#sec-A.8) | [3.2.4](../ch03/sec32.md#sec-3.2.4) 的课程预告 | [3.1](../ch03/sec31.md)、[3.2](../ch03/sec32.md) 单侧逆与满秩分解 |

<a id="sec-A.1"></a>

## A.1 极化恒等式：范数记住了内积的全部信息

[2.5](../ch02/sec25.md#sec-2.5.2) 证明「保长度 ⟹ 保内积」时，技巧是把两个向量打包成 $\boldsymbol{q}_i+t\boldsymbol{q}_j$ 再比较长度。这个技巧的终极形式是一个恒等式：**内积可以由长度完全恢复**。

::: thm 命题 A.1 · 极化恒等式 {#thm-A.1}

设 $V$ 是内积空间（本教程约定：第一变元线性、第二变元共轭线性），则对任意 $\boldsymbol{x},\boldsymbol{y}\in V$：

$$\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})=\frac14\Big(\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2\Big),$$

$$\operatorname{Im}(\boldsymbol{x},\boldsymbol{y})=\frac14\Big(\|\boldsymbol{x}+i\boldsymbol{y}\|^2-\|\boldsymbol{x}-i\boldsymbol{y}\|^2\Big),$$

实内积空间中 $(\boldsymbol{x},\boldsymbol{y})$ 本身是实数，只需第一式。
:::

::: proof 证

按「第一变元线性、第二变元共轭线性」展开（$i$ 出现在第二变元时要带走一个共轭）：

$$\|\boldsymbol{x}+\boldsymbol{y}\|^2=(\boldsymbol{x},\boldsymbol{x})+(\boldsymbol{x},\boldsymbol{y})+(\boldsymbol{y},\boldsymbol{x})+(\boldsymbol{y},\boldsymbol{y})=\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2+(\boldsymbol{x},\boldsymbol{y})+\overline{(\boldsymbol{x},\boldsymbol{y})},$$

$$\|\boldsymbol{x}-\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2-(\boldsymbol{x},\boldsymbol{y})-\overline{(\boldsymbol{x},\boldsymbol{y})}.$$

两式相减，得 $4\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})$。再把 $\boldsymbol{y}$ 换成 $i\boldsymbol{y}$（注意 $(\boldsymbol{x},i\boldsymbol{y})=\overline{i}\,(\boldsymbol{x},\boldsymbol{y})=-i(\boldsymbol{x},\boldsymbol{y})$，$(i\boldsymbol{y},\boldsymbol{x})=i(\boldsymbol{y},\boldsymbol{x})=i\,\overline{(\boldsymbol{x},\boldsymbol{y})}$）：

$$\|\boldsymbol{x}+i\boldsymbol{y}\|^2-\|\boldsymbol{x}-i\boldsymbol{y}\|^2=-2i(\boldsymbol{x},\boldsymbol{y})+2i\,\overline{(\boldsymbol{x},\boldsymbol{y})}=4\,\operatorname{Im}(\boldsymbol{x},\boldsymbol{y})$$

（设 $(\boldsymbol{x},\boldsymbol{y})=a+b\,i$：$-2i(a+bi)+2i(a-bi)=(-2ia+2b)+(2ia+2b)=4b$。）两式合并即得

$$(\boldsymbol{x},\boldsymbol{y})=\frac14\Big(\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2+i\|\boldsymbol{x}+i\boldsymbol{y}\|^2-i\|\boldsymbol{x}-i\boldsymbol{y}\|^2\Big).\qquad\blacksquare$$

:::

::: cor 推论 A.1 · 三个直接应用 {#cor-A.1}

1. **保长度的线性变换自动保内积**：若 $T$ 线性且 $\|T\boldsymbol{x}\|=\|\boldsymbol{x}\|$ 对一切 $\boldsymbol{x}$，则对右边的每个范数有 $\|\boldsymbol{x}\pm\boldsymbol{y}\|=\|T\boldsymbol{x}\pm T\boldsymbol{y}\|$、$\|\boldsymbol{x}\pm i\boldsymbol{y}\|=\|T\boldsymbol{x}\pm iT\boldsymbol{y}\|$（线性把 $T$ 移进括号），代入 [@thm-A.1] 右端得 $(T\boldsymbol{x},T\boldsymbol{y})=(\boldsymbol{x},\boldsymbol{y})$——这正是 [2.5](../ch02/sec25.md#thm-orth-equiv) 的②⟹③，极化把那段逐个放缩的论证压缩成一次代入。
2. **范数决定内积**：同一实（复）线性空间上两个内积若给出**同一个**范数，则由 [@thm-A.1] 它们给出同样的内积，故是同一个内积。反过来，[1.5.1](../ch01/sec15.md#sec-1.5.1) 末的注已指出：并非每条范数都来自某个内积——判据正是**平行四边形法则**（不满足它的范数无父可寻，因为 [@thm-A.1] 的右端将无法与任何双线性型相容）。
3. **酉变换的全部信息也在「保长度」里**：[2.5](../ch02/sec25.md#thm-orth-equiv) 的四条等价刻画中，①保内积与②保长度等价，本推论第 1 条就是缺失的那个方向的一般化证明。
:::

::: note C–S 不等式的第二种证法（判别式法）

[1.5.2](../ch01/sec15.md#sec-1.5.2) 用「减掉投影、留正交残差」证明了 Cauchy–Schwarz。换一条路——考察关于实变量 $t$ 的二次函数（$V$ 取**实**内积空间；复情形先取实部，见下）：

$$\varphi(t)=\|\boldsymbol{x}+t\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+2t(\boldsymbol{x},\boldsymbol{y})+t^2\|\boldsymbol{y}\|^2\ \geq0\qquad(\forall t\in\mathbb R).$$

若 $\boldsymbol{y}\neq\boldsymbol{\theta}$，则 $\varphi$ 是开口向上的二次多项式且恒非负，故判别式非正：

$$4(\boldsymbol{x},\boldsymbol{y})^2-4\|\boldsymbol{x}\|^2\|\boldsymbol{y}\|^2\leq0\qquad\Longrightarrow\qquad|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|.$$

复空间中先对 $\boldsymbol{y}$ 旋转一个辐角（乘以模为 $1$ 的复数不改变任何一边），使 $(\boldsymbol{x},\boldsymbol{y})$ 变为实数，再用上式。等号条件 $\varphi(t_0)=0$ 意即 $\boldsymbol{x}+t_0\boldsymbol{y}=\boldsymbol{\theta}$，即线性相关——与正文的结论一致。两种证法各有分工：判别式法一行出不等式，投影法给出「成分 ≤ 全长」的几何图景。
:::

::: prop 命题 A.2 · 反向三角不等式 {#prop-A.2}

对任意 $\boldsymbol{x},\boldsymbol{y}\in V$，有

$$\big|\|\boldsymbol{x}\|-\|\boldsymbol{y}\|\big|\leq\|\boldsymbol{x}-\boldsymbol{y}\|.$$

它把三角不等式「反过来用」：两条边长之差不超过第三边。数值分析里估计「输入扰动引起的长度变化」（[附录 B.5](appendix-b.md#sec-B.5)）时反复引用。
:::

::: proof 证

对 $\boldsymbol{x}=\boldsymbol{y}+(\boldsymbol{x}-\boldsymbol{y})$ 与 $\boldsymbol{y}=\boldsymbol{x}+(\boldsymbol{y}-\boldsymbol{x})$ 各用一次三角不等式（[1.5.1](../ch01/sec15.md#prop-1.5.1) (4)）：

$$\|\boldsymbol{x}\|\le\|\boldsymbol{y}\|+\|\boldsymbol{x}-\boldsymbol{y}\|,\qquad \|\boldsymbol{y}\|\le\|\boldsymbol{x}\|+\|\boldsymbol{x}-\boldsymbol{y}\|,$$

移项得 $\|\boldsymbol{x}\|-\|\boldsymbol{y}\|\leq\|\boldsymbol{x}-\boldsymbol{y}\|$ 与 $\|\boldsymbol{y}\|-\|\boldsymbol{x}\|\leq\|\boldsymbol{x}-\boldsymbol{y}\|$，即绝对值形式。∎
:::

<a id="sec-A.2"></a>

## A.2 Gram 行列式 = 平行多面体体积的平方

[1.5.4](../ch01/sec15.md#sec-1.5.4) 在 $\mathbb R^2$ 中证明了 $\det G(\boldsymbol{x}_1,\boldsymbol{x}_2)$ 是平行四边形面积的平方。本节把结论推广到任意维数，并顺带得到著名的 **Hadamard 不等式**。为避开下标约定的缠绕，本节在**实**内积空间中讨论（此时 $G$ 对称）；复空间的结论逐字成立，只需把「平方」换成「模平方」。

对 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n\in\mathbb R^n$，记平行多面体

$$P(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)=\Big\{t_1\boldsymbol{x}_1+\cdots+t_n\boldsymbol{x}_n\ \Big|\ 0\leq t_i\leq1\Big\}.$$

::: thm 命题 A.3 · 体积公式 {#thm-A.3}

$$\operatorname{Vol}_n\big(P(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)\big)^2=\det G(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n),$$

且体积可按「底面积 × 高」逐层递推：每层的高是下一个向量到前面向量所张成子空间的距离。
:::

::: proof 证（对 $n$ 归纳）

$n=1$：$P(\boldsymbol{x}_1)$ 是线段，$\operatorname{Vol}_1=\|\boldsymbol{x}_1\|=\sqrt{(\boldsymbol{x}_1,\boldsymbol{x}_1)}=\sqrt{\det G}$ ✓。

设结论对 $n-1$ 成立。记 $W=\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_{n-1})$，维数 $n-1$（设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 线性无关；相关时两侧同为零，归纳论证同样关闭）。由正交分解定理（[1.6.6](../ch01/sec16.md#sec-1.6.6)）：

$$\boldsymbol{x}_n=\boldsymbol{w}+\boldsymbol{r},\qquad \boldsymbol{w}\in W,\ \boldsymbol{r}\in W^{\perp},\qquad \boldsymbol{w}\perp\boldsymbol{r},$$

且「底面积 × 高」：$\operatorname{Vol}_n=\operatorname{Vol}_{n-1}\cdot\|\boldsymbol{r}\|$（$\boldsymbol{r}$ 就是高）。

**把 $\boldsymbol{w}$ 用坐标写出。**设 $\boldsymbol{w}=\sum_{i=1}^{n-1}k_i\boldsymbol{x}_i$。由 $(\boldsymbol{x}_n-\boldsymbol{w},\boldsymbol{x}_j)=0$（$j\leq n-1$）展开：

$$\sum_{i=1}^{n-1}(\boldsymbol{x}_i,\boldsymbol{x}_j)\,k_i=(\boldsymbol{x}_n,\boldsymbol{x}_j),\qquad j=1,\cdots,n-1,$$

即 $G_{n-1}\boldsymbol{k}=\boldsymbol{b}$，其中 $G_{n-1}=G(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_{n-1})$、$b_j=(\boldsymbol{x}_n,\boldsymbol{x}_j)$（实空间中 $G$ 对称，方程组形状无需辨析转置）。于是

$$\|\boldsymbol{w}\|^2=\boldsymbol{k}^{\mathrm T}G_{n-1}\boldsymbol{k}=\boldsymbol{b}^{\mathrm T}G_{n-1}^{-1}\boldsymbol{b}.$$

**分块行列式。**把 $n$ 阶 Gram 矩阵按「前 $n-1$ 行 / 列」分块：

$$G=\begin{bmatrix}G_{n-1}&\boldsymbol{b}\\ \boldsymbol{b}^{\mathrm T}&\|\boldsymbol{x}_n\|^2\end{bmatrix}.$$

对**分块高斯消元**（左乘 $\begin{bmatrix}I&\boldsymbol{0}\\ -\boldsymbol{b}^{\mathrm T}G_{n-1}^{-1}&1\end{bmatrix}$，行列式为 $1$）：

$$\det G=\det\begin{bmatrix}G_{n-1}&\boldsymbol{b}\\ \boldsymbol{0}&\|\boldsymbol{x}_n\|^2-\boldsymbol{b}^{\mathrm T}G_{n-1}^{-1}\boldsymbol{b}\end{bmatrix}=\det G_{n-1}\cdot\big(\|\boldsymbol{x}_n\|^2-\|\boldsymbol{w}\|^2\big).$$

由正交分解，括号内恰是 $\|\boldsymbol{r}\|^2$。于是

$$\det G=\det G_{n-1}\cdot\|\boldsymbol{r}\|^2\ \overset{\text{归纳}}{=}\ \operatorname{Vol}_{n-1}^2\cdot\|\boldsymbol{r}\|^2=\operatorname{Vol}_n^2.\qquad\blacksquare$$

:::

::: cor 推论 A.2 · Hadamard 不等式 {#cor-A.2}

设 $A\in\mathbb C^{n\times n}$ 按列分块 $A=(\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n)$，则

$$|\det A|\leq\prod_{i=1}^{n}\|\boldsymbol{a}_i\|,\qquad\text{等号成立}\iff\ \boldsymbol{a}_1,\cdots,\boldsymbol{a}_n\ \text{两两正交}.$$

对行同样成立。数值上它常用来**估计行列式的上界**；几何读法即「棱长的乘乘是体积的天花板」。
:::

::: proof 证

$A$ 可逆时列向量线性无关，$G=(\boldsymbol{a}_i,\boldsymbol{a}_j)$ 恰为「$\boldsymbol{a}_i$ 的坐标矩阵」的 Gram 矩阵，且 $G=A^{\mathrm H}A$，故

$$|\det A|^2=\det(A^{\mathrm H}A)=\det G=\operatorname{Vol}_n^2\leq\prod_i\|\boldsymbol{a}_i\|^2,$$

其中不等号是因为每层的高不超过该棱长：$\|\boldsymbol{r}\|\leq\|\boldsymbol{x}_n\|$（正交分解 $\|\boldsymbol{x}_n\|^2=\|\boldsymbol{w}\|^2+\|\boldsymbol{r}\|^2$ 立刻给出）。逐层取等当且仅当每层 $\boldsymbol{w}=\boldsymbol{0}$，即每个向量与前面全部向量正交——两两正交。$A$ 奇异时两边一端为零，$\det A=0\leq\prod\|\boldsymbol{a}_i\|$ 平凡成立。∎
:::

::: note 与正文的两个接口

① 「$\det G>0\iff$ 线性无关」在高维同样成立：体积非零 ⟺ 平行多面体不塌扁 ⟺ 无关（$G$ 正定，[1.4.7](../ch01/sec14.md#sec-1.4.7)）。② Hadamard 不等式给出「正交基是最稳的基」的定量版本：同样长度的棱，互相垂直时撑起的体积最大——这是数值分析中偏好正交基（[1.6.8](../ch01/sec16.md#sec-1.6.8) 的 QR、[2.5](../ch02/sec25.md) 的 Givens / Householder）的几何根源之一，见[附录 B.5](appendix-b.md#sec-B.5)。
:::

<a id="sec-A.3"></a>

## A.3 特征多项式的系数：迹与行列式

[2.4.2](../ch02/sec24.md#thm-eig-trace) 把「迹 = 特征值之和、行列式 = 特征值之积」列为考场清单；本节补全它的证明。证明分两半：先算出特征多项式**首两项与常数项**的系数，再用根与系数的关系把它们翻译成特征值。

::: thm 命题 A.4 · 特征多项式的三个系数 {#thm-A.4}

设 $A\in\mathbb C^{n\times n}$，$f(\lambda)=\det(\lambda I-A)$，则

$$f(\lambda)=\lambda^n-(\operatorname{tr}A)\lambda^{n-1}+\cdots+(-1)^n\det A.$$
:::

::: proof 证（行列式的完全展开式）

按 Leibniz 展开式（先修知识）：

$$f(\lambda)=\sum_{\sigma}\operatorname{sgn}(\sigma)\prod_{i=1}^{n}\big(\lambda\,\delta_{i,\sigma(i)}-a_{i\sigma(i)}\big).$$

每一项的 $\lambda$ 次数 = 满足 $\sigma(i)=i$ 的下标个数（不动点个数）。**恒等置换** $\sigma=\mathrm{id}$ 的不动点有 $n$ 个，贡献

$$\prod_{i=1}^n(\lambda-a_{ii})=\lambda^n-\Big(\sum_ia_{ii}\Big)\lambda^{n-1}+\cdots,$$

这是唯一能贡献 $\lambda^n$ 与 $\lambda^{n-1}$ 的项：**任何其他置换至少动掉两个下标**（置换不能只动一个），至多有 $n-2$ 个不动点，次数 $\leq n-2$。故 $f$ 的 $\lambda^{n-1}$ 系数是 $-\operatorname{tr}A$。常数项：令 $\lambda=0$，$f(0)=\det(-A)=(-1)^n\det A$。∎
:::

::: thm 命题 A.5 · 迹与行列式 = 特征值的对称函数 {#thm-A.5}

设 $A\in\mathbb C^{n\times n}$ 的全部特征值为 $\lambda_1,\cdots,\lambda_n$（按代数重数重复计入；由代数基本定理，$n$ 次多项式 $f$ 在 $\mathbb C$ 上恰有 $n$ 个根计重数），则

$$\operatorname{tr}A=\lambda_1+\cdots+\lambda_n,\qquad \det A=\lambda_1\lambda_2\cdots\lambda_n .$$
:::

::: proof 证

$f$ 是首项系数为 $1$ 的 $n$ 次多项式、根为 $\lambda_1,\cdots,\lambda_n$，故 $f(\lambda)=\prod_i(\lambda-\lambda_i)$。与 [@thm-A.4] 逐系数对照：$\lambda^{n-1}$ 的系数既是 $-\operatorname{tr}A$ 又是 $-\sum_i\lambda_i$，常数项既是 $(-1)^n\det A$ 又是 $(-1)^n\prod_i\lambda_i$。∎
:::

::: note 一行的应用：可逆性的特征值判据

由 $\det A=\prod\lambda_i$：**$A$ 可逆 $\iff$ 所有特征值非零**。结合 [2.4](../ch02/sec24.md#thm-eig-power)，可逆时 $A^{-1}$ 的特征值恰为 $\lambda_i^{-1}$，特征向量不变——「求逆」在特征方向上就是「取倒数」。这与 [3.1](../ch03/sec31.md#prop-3.1.1) 的 $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 一起，构成后续谱分析的两块基石。
:::

<a id="sec-A.4"></a>

## A.4 几何重数不超过代数重数

[2.4.3](../ch02/sec24.md#thm-mult-ineq) 把 $\dim V_\lambda\leq$ 代数重数「先当事实用」。它的证明只需要一招：**取特征子空间的基，扩充成全空间的基**——在这组基下矩阵呈分块三角，特征多项式立刻分解。

::: thm 命题 A.6 · 重数不等式 {#thm-A.6}

设 $\lambda$ 是 $A\in\mathbb C^{n\times n}$ 的特征值，$V_\lambda=N(A-\lambda I)$ 是特征子空间，则

$$\dim V_\lambda\ \leq\ \lambda\ \text{作为特征多项式根的重数}.$$
:::

::: proof 证

记 $k=\dim V_\lambda\geq1$，取 $V_\lambda$ 的一组基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k$，由基扩充定理（[@cor-1.3.1]）扩成 $\mathbb C^n$ 的基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$。记 $P=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)$（可逆）。按矩阵的读法（[@def-2.3.1]），$B=P^{-1}AP$ 的第 $j$ 列是 $A\boldsymbol{x}_j$ 在这组基下的坐标；对 $j\leq k$ 有 $A\boldsymbol{x}_j=\lambda\boldsymbol{x}_j$，坐标为 $\lambda\boldsymbol{e}_j$。于是 $B$ 呈分块形式

$$B=P^{-1}AP=\begin{bmatrix}\lambda I_k&M\\O&C\end{bmatrix},\qquad M\in\mathbb C^{k\times(n-k)},\ C\in\mathbb C^{(n-k)\times(n-k)},$$

左下角为零块。**分块三角矩阵的特征多项式按对角块分解**（$\lambda I-B$ 仍是分块三角，其行列式等于对角块行列式之积——先修的分块行列式性质）：

$$f_B(t)=\det(tI-B)=\det\big((t-\lambda)I_k\big)\cdot\det(tI_{n-k}-C)=(t-\lambda)^k\,g(t),$$

其中 $g(t)=\det(tI_{n-k}-C)$ 是 $n-k$ 次多项式。最后用相似不变量（[@thm-sim-invariants]）：$B\sim A$ ⟹ $f_B=f_A$，故 $(t-\lambda)^k$ 整除 $f_A(t)$，即 $\lambda$ 的重数至少为 $k$。∎
:::

::: note 读两遍的价值

① 证明同时给出了**等号的语言**：代数重数 $-k$（差值）等于「$\lambda$ 在 $C$ 的部分再出现的重数」——Jordan 链的长度就藏在这个差里（[2.4.3](../ch02/sec24.md#ex-jordan-three) 的三矩阵例中，差分别为 $0,1,2$，恰是链的结构）。② 与 [@thm-eig-independent] 合并，立得一个重要预告：**$A$ 可对角化 $\iff$ 对每个特征值都有 $\dim V_\lambda=$ 代数重数**（这是 [2.4](../ch02/sec24.md#ex-2.4.quiz) 自测第 4 题的反向陈述，完整证明属后续课程的相似标准形理论）。
:::

<a id="sec-A.5"></a>

## A.5 Cayley–Hamilton 定理

[1.1.6](../ch01/sec11.md#sec-1.1.6) 曾借例题预告：任意方阵满足**自己的**特征方程。这个结论把「矩阵」与「多项式」两个世界缝合在一起，证明用的是**伴随矩阵**（先修知识：$B\cdot\operatorname{adj}B=(\det B)I$）。

::: thm 定理 A.7 · Cayley–Hamilton {#thm-A.7}

设 $A\in\mathbb C^{n\times n}$，$f(\lambda)=\det(\lambda I-A)=\lambda^n+c_{n-1}\lambda^{n-1}+\cdots+c_1\lambda+c_0$，则

$$f(A)=A^n+c_{n-1}A^{n-1}+\cdots+c_1A+c_0I=O.$$
:::

::: proof 证（伴随矩阵法）

记 $B(\lambda)=\operatorname{adj}(\lambda I-A)$。$B(\lambda)$ 的每个元素是 $\lambda I-A$ 的某个 $n-1$ 阶子式（划去一行一列后的行列式），因而都是次数 $\leq n-1$ 的 $\lambda$ 多项式。于是 $B(\lambda)$ 可按 $\lambda$ 的幂整理为**矩阵系数的多项式**：

$$B(\lambda)=B_0+B_1\lambda+\cdots+B_{n-1}\lambda^{n-1},\qquad B_i\in\mathbb C^{n\times n}.$$

伴随矩阵的基本恒等式给出

$$(\lambda I-A)\,B(\lambda)=f(\lambda)\,I .$$

（两边都是 $n\times n$ 矩阵；注意 $\lambda I-A$ 与 $B(\lambda)$ 的乘法不可随意「约去」，我们不做约除，只做**系数比较**。）把两边都展开成 $\lambda$ 的幂：

$$\text{左边}=-AB_0+\sum_{j=1}^{n-1}\big(B_{j-1}-AB_j\big)\lambda^{j}+B_{n-1}\lambda^{n},\qquad\text{右边}=\sum_{j=0}^{n}c_jI\,\lambda^{j}\ (c_n=1).$$

多项式恒相等 ⟹ 每个系数（矩阵）相等：

$$-AB_0=c_0I,\qquad B_{j-1}-AB_j=c_jI\ (j=1,\cdots,n-1),\qquad B_{n-1}=I.$$

**关键一步（左乘求和、逐项伸缩相消）**：把第 $j$ 个恒等式 $c_jI=B_{j-1}-AB_j$ 的两边**左乘** $A^j$，得

$$c_jA^j=A^jB_{j-1}-A^{j+1}B_j .$$

把 $j=0,\cdots,n$ 的全部恒等式（$c_0I=-AB_0=-A^1B_0$ 与 $c_nA^n=A^n=A^nB_{n-1}$ 计入两端）相加：左边是 $f(A)$；右边每一项都形如 $\pm A^kB_l$，且按 $k$ 错开一层**成对相消**——$-A^1B_0$（$j=0$）与 $+A^1B_0$（$j=1$ 的正部）抵消；中间每个 $-A^{j+1}B_j$（第 $j$ 式负部，$1\leq j\leq n-2$）与第 $j+1$ 式的正部 $+A^{j+1}B_j$ 抵消；末尾 $-A^{n}B_{n-1}$（$j=n-1$ 负部）与 $+A^{n}B_{n-1}$ 抵消。故

$$f(A)=O .$$

（矩阵乘法不可交换，因此恒等式两边必须**同侧**左乘 $A^j$——若右乘，$B_{j-1}$ 与 $A$ 的相对位置无法对齐，成对项不再出现。）∎
:::

::: ex 例 A.1 · 在 1.1 节的老朋友上验证 {#ex-A.1}

取 $A=\begin{pmatrix}1&1\\0&1\end{pmatrix}$（[1.1.6](../ch01/sec11.md#sec-1.1.6) 的矩阵）。特征多项式 $f(\lambda)=(\lambda-1)^2=\lambda^2-2\lambda+1$，于是 Cayley–Hamilton 断言 $A^2-2A+I=O$。逐项验算：

$$A^2-2A+I=\begin{pmatrix}1&2\\0&1\end{pmatrix}-\begin{pmatrix}2&2\\0&2\end{pmatrix}+\begin{pmatrix}1&0\\0&1\end{pmatrix}=\begin{pmatrix}0&0\\0&0\end{pmatrix}\ \checkmark$$

**立即的回报**：由 $A^2=2A-I$，一切高次幂都留在 $\operatorname{span}\{A,I\}$ 中，且递推

$$A^{k+1}=A\cdot A^k=A\big(kA-(k-1)I\big)=kA^2-(k-1)A=(k+1)A-kI,$$

归纳即得 [1.1.6](../ch01/sec11.md#sec-1.1.6) 用归纳法证过的公式 $A^k=kA-(k-1)I$——当时手推的结论，现在成了定理的免费赠品。
:::

::: note 它为什么重要

① **降幂**：任何 $A^m$（$m\geq n$）都能写成 $A^{n-1},\cdots,A,I$ 的线性组合——「矩阵多项式」永远只有 $n$ 层楼。② **求逆**：$A$ 可逆时，$f(A)=O$ 移项并乘 $A^{-1}$ 得 $A^{-1}=-\tfrac1{c_0}\big(A^{n-1}+c_{n-1}A^{n-2}+\cdots+c_1I\big)$——逆矩阵是 $A$ 的多项式。③ **解析函数的推广**：把「矩阵代入多项式」推广到收敛幂级数（如 $\mathrm e^{At}$），就得到 [附录 B.6](appendix-b.md#sec-B.6) 里解线性微分方程组的核心工具。
:::

<a id="sec-A.6"></a>

## A.6 正定矩阵的「开方」：$A=C^{\mathrm H}C$

[1.4.3](../ch01/sec14.md#sec-1.4.3) 证明了「$\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 是内积 $\iff$ $A$ 正定 Hermite」；[1.4.5](../ch01/sec14.md#sec-1.4.5) 又展示了「换一个正定 $A$ 就是换一把尺子」。本节回答一个自然的问题：**这些尺子有没有统一的来历？** 答案：每把尺子都是「把空间拉伸后按标准尺子量」。

::: thm 命题 A.8 · 正定的刻画 {#thm-A.8}

设 $A\in\mathbb C^{n\times n}$ 是 Hermite 矩阵，则以下等价：

1. $A$ 正定；
2. 存在可逆矩阵 $C$ 使 $A=C^{\mathrm H}C$；
3. 存在**正线上三角**矩阵 $R$ 使 $A=R^{\mathrm H}R$（$R$ 即 Cholesky 因子）。
:::

::: proof 证

**(2)⟹(1)**：$\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}C^{\mathrm H}C\boldsymbol{x}=(C\boldsymbol{x},C\boldsymbol{x})=\|C\boldsymbol{x}\|^2\gt0$（$\boldsymbol{x}\neq\boldsymbol{0}$ 时 $C\boldsymbol{x}\neq\boldsymbol{0}$，因 $C$ 可逆）。

**(1)⟹(3)**：正定 Hermite 的 $A$ 按 [@ex-1.4.4] 定义内积 $(\boldsymbol{x},\boldsymbol{y})_A=\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$。对**标准基** $\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n$ 执行 Gram–Schmidt（[1.5.6](../ch01/sec15.md#sec-1.5.6)）并单位化，得到**关于 $(\cdot,\cdot)_A$ 的标准正交基** $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$；由 [1.6.8](../ch01/sec16.md#sec-1.6.8)，换基关系为

$$(\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n)=(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)\,R,\qquad R\ \text{正线上三角（可逆）}.$$

记 $Q=(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)$。「$\boldsymbol{q}$ 组关于 $(\cdot,\cdot)_A$ 标准正交」翻译成矩阵即 $Q^{\mathrm H}AQ=I$（$A$-Gram 矩阵是单位阵，[@def-1.4.4]）。于是（注意 $(\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n)=I$）：

$$A=I^{\mathrm H}AI=(QR)^{\mathrm H}A(QR)=R^{\mathrm H}\big(Q^{\mathrm H}AQ\big)R=R^{\mathrm H}R .$$

**(3)⟹(2)**：正线上三角矩阵可逆（对角元全正，[1.6.8](../ch01/sec16.md#sec-1.6.8)）。∎
:::

::: note 三个立刻的读法

1. **加权内积 = 拉伸后的标准内积**：$(\boldsymbol{x},\boldsymbol{y})_A=\boldsymbol{y}^{\mathrm H}R^{\mathrm H}R\boldsymbol{x}=(R\boldsymbol{x},R\boldsymbol{y})$。换尺子量出的全部几何（长度、正交、投影），等于先用 $R$ 拉伸空间再用标准尺子量。[1.4.5](../ch01/sec14.md#sec-1.4.5) 中 $A=\operatorname{diag}(4,1)$ 的椭圆单位圆，正是 $R=\operatorname{diag}(2,1)$ 把单位圆沿 $x$ 轴拉伸 2 倍的结果。
2. **正定 ⟺ 合同于 $I$**：$A=R^{\mathrm H}IR$ 说明 $A$ 与 $I$ 合同（[1.4.7](../ch01/sec14.md#sec-1.4.7)）；逆命题即本命题。这是「合同变换保持正定性」（同处）的构造性证明。
3. **$A^{\mathrm H}A$ 家族**：对任意 $A\in\mathbb C^{m\times n}$，$A^{\mathrm H}A=C^{\mathrm H}C$ 形式自动 Hermite 半正定；[3.1](../ch03/sec31.md#prop-3.1.1) 证明了它与 $A$ 同秩。把它与 (3) 结合：列满秩的 $A$ 恰好是某个正定矩阵的「Cholesky 因子」（至多差一个酉因子）——这是奇异值分解（后续章节）的先声。
:::

<a id="sec-A.7"></a>

## A.7 Bessel 不等式与 Parseval 等式

[1.5.7](../ch01/sec15.md#sec-1.5.7) 用三角函数系展示了「正交系 + 内积 = 广义坐标」。本节在有限维里把这套机制算到底：投影已经「解释掉」多少能量，剩余还有多少。

设 $V$ 是内积空间，$\boldsymbol{q}_1,\cdots,\boldsymbol{q}_m$ 是标准正交向量组，$W=\operatorname{span}(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_m)$。

::: thm 命题 A.9 · Bessel 不等式 {#thm-A.9}

对任意 $\boldsymbol{x}\in V$，

$$\sum_{i=1}^{m}\big|(\boldsymbol{x},\boldsymbol{q}_i)\big|^2\ \leq\ \|\boldsymbol{x}\|^2,$$

等号成立当且仅当 $\boldsymbol{x}\in W$。
:::

::: proof 证

令 $\boldsymbol{w}=\sum_{i=1}^m(\boldsymbol{x},\boldsymbol{q}_i)\boldsymbol{q}_i$（即 $\operatorname{Proj}_{W}\boldsymbol{x}$，[@prop-1.6.1] 的标准正交基版本），$\boldsymbol{r}=\boldsymbol{x}-\boldsymbol{w}$。对每个 $j$，

$$(\boldsymbol{r},\boldsymbol{q}_j)=(\boldsymbol{x},\boldsymbol{q}_j)-\sum_{i=1}^m(\boldsymbol{x},\boldsymbol{q}_i)\underbrace{(\boldsymbol{q}_i,\boldsymbol{q}_j)}_{=\delta_{ij}}=0,$$

故 $\boldsymbol{r}\perp W$，特别地 $\boldsymbol{r}\perp\boldsymbol{w}$。由正交分解（展开交叉项为零）：

$$\|\boldsymbol{x}\|^2=\|\boldsymbol{w}\|^2+\|\boldsymbol{r}\|^2,\qquad \|\boldsymbol{w}\|^2=\sum_{i=1}^m\big|(\boldsymbol{x},\boldsymbol{q}_i)\big|^2\ (\text{交叉项同样逐个消去}).$$

两式合并即得不等式；等号 $\iff\|\boldsymbol{r}\|=0\iff\boldsymbol{x}\in W$。∎
:::

::: cor 推论 A.3 · Parseval 等式 {#cor-A.3}

若 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 是**全空间**的标准正交基，则对一切 $\boldsymbol{x},\boldsymbol{y}\in V$：

$$\|\boldsymbol{x}\|^2=\sum_{i=1}^n\big|(\boldsymbol{x},\boldsymbol{q}_i)\big|^2,\qquad (\boldsymbol{x},\boldsymbol{y})=\sum_{i=1}^n(\boldsymbol{x},\boldsymbol{q}_i)\,\overline{(\boldsymbol{y},\boldsymbol{q}_i)}.$$

前者是 Bessel 取等（$W=V$，$\boldsymbol{r}=\boldsymbol{0}$）；后者由前者对 $\boldsymbol{x}+\boldsymbol{y}$、$\boldsymbol{x}-\boldsymbol{y}$、$\boldsymbol{x}\pm i\boldsymbol{y}$ 使用并线性组合得到——正是极化恒等式（[@thm-A.1]）的坐标版。
:::

::: note 无穷的接口：傅里叶级数

在 $L^2[-\pi,\pi]$ 中取三角函数系（[1.5.7](../ch01/sec15.md#sec-1.5.7)），Bessel 不等式变成：**傅里叶系数的平方和不超过函数的能量** $\int_{-\pi}^{\pi}|f|^2$——这保证了系数平方级数收敛，傅里叶级数「不越界」。当三角函数系取满（完备）时，不等式升格为 Parseval 等式：

$$\frac{a_0^2}{2}+\sum_{n\geq1}\big(a_n^2+b_n^2\big)=\frac1\pi\int_{-\pi}^{\pi}f(t)^2\,\mathrm dt,$$

「时域能量 = 频域能量」。[附录 B.2](appendix-b.md#sec-B.2) 将在有限维信号空间里用 DFT 矩阵的酉性给出同一等式的离散版——同一个定理，换个舞台。
:::

<a id="sec-A.8"></a>

## A.8 Moore–Penrose 伪逆：四条条件、良定义与唯一性

[3.2.4](../ch03/sec32.md#sec-3.2.4) 从满秩分解造出 $X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}$ 并验证了 $AXA=A$。本节补全剩下的三件事：$X$ 满足**全部四条** Penrose 条件、$X$ 与满秩分解的选法无关、满足四条的 $X$ 唯一。

::: thm 定理 A.10 · Penrose 四条件 {#thm-A.10}

设 $A\in\mathbb C^{m\times n}_r$（$r\gt0$）有满秩分解 $A=BC$（$B$ 列满秩、$C$ 行满秩），令

$$A^{+}\triangleq C^{\mathrm H}\big(CC^{\mathrm H}\big)^{-1}\big(B^{\mathrm H}B\big)^{-1}B^{\mathrm H},$$

则 $A^{+}$ 满足：

1. $AA^{+}A=A$；
2. $A^{+}AA^{+}=A^{+}$；
3. $(AA^{+})^{\mathrm H}=AA^{+}$；
4. $(A^{+}A)^{\mathrm H}=A^{+}A$。

且 $A^{+}$ 只依赖 $A$、不依赖满秩分解的选法。满足全部四条的矩阵唯一（[@thm-A.11]），称为 $A$ 的 **Moore–Penrose 伪逆**。
:::

::: proof 证

先记 $B^{\mathrm L}=(B^{\mathrm H}B)^{-1}B^{\mathrm H}$（$B$ 的左逆）、$C^{\mathrm R}=C^{\mathrm H}(CC^{\mathrm H})^{-1}$（$C$ 的右逆，[3.1](../ch03/sec31.md#thm-3.1.1) 法 2 的两个公式），则 $A^{+}=C^{\mathrm R}B^{\mathrm L}$。

**(1)** $AA^{+}A=B(CC^{\mathrm R})B^{\mathrm L}(B^{\mathrm L}B)C=BC=A$ ✓。

**(3)(4)** 先算出两个乘积的「约简形」：

$$AA^{+}=B\,C\,C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}=B\,(B^{\mathrm H}B)^{-1}B^{\mathrm H},$$

$$A^{+}A=C^{\mathrm H}(CC^{\mathrm H})^{-1}\,(B^{\mathrm H}B)^{-1}(B^{\mathrm H}B)\,C=C^{\mathrm H}(CC^{\mathrm H})^{-1}C,$$

两者都形如「$MM^{\mathrm H}(\cdot)^{-1}M^{\mathrm H}$ 类的对称表达式」，直接取共轭转置验证：$\big(B(B^{\mathrm H}B)^{-1}B^{\mathrm H}\big)^{\mathrm H}=B(B^{\mathrm H}B)^{-1}B^{\mathrm H}$（中间因子 $(B^{\mathrm H}B)^{-1}$ 自身 Hermite：$(B^{\mathrm H}B)^{\mathrm H}=B^{\mathrm H}B$）；另一式同理 ✓。

**(2)** $A^{+}AA^{+}=A^{+}(AA^{+})=C^{\mathrm R}B^{\mathrm L}\,B(B^{\mathrm H}B)^{-1}B^{\mathrm H}=C^{\mathrm R}\,B^{\mathrm L}=A^{+}$ ✓。

**与分解无关**：设 $A=B_1C_1=B_2C_2$ 是两个满秩分解，由 [@thm-3.2.2] 存在可逆 $D$ 使 $B_1=B_2D$、$C_1=D^{-1}C_2$。代入 $A^{+}$ 的公式并记 $M=C_2C_2^{\mathrm H}$、$N=B_2^{\mathrm H}B_2$：

$$C_1C_1^{\mathrm H}=D^{-1}MD^{-\mathrm H},\qquad\big(D^{-1}MD^{-\mathrm H}\big)^{-1}=D^{\mathrm H}M^{-1}D,\qquad \big(B_1^{\mathrm H}B_1\big)^{-1}=D^{-1}N^{-1}D^{-\mathrm H},$$

于是四个因子里的 $D,D^{-1},D^{\mathrm H},D^{-\mathrm H}$ 两两相消：

$$A_1^{+}=\underbrace{C_2^{\mathrm H}D^{-\mathrm H}}_{C_1^{\mathrm H}}\cdot D^{\mathrm H}M^{-1}\underbrace{D\,D^{-1}}_{\text{消}}N^{-1}D^{-\mathrm H}\cdot\underbrace{D^{\mathrm H}}_{B_1^{\mathrm H}=D^{\mathrm H}B_2^{\mathrm H}}B_2^{\mathrm H}=C_2^{\mathrm H}M^{-1}N^{-1}B_2^{\mathrm H}=A_2^{+}.\qquad\blacksquare$$

:::

::: thm 定理 A.11 · 四条件确定唯一解 {#thm-A.11}

至多存在一个矩阵 $X$ 同时满足 [四条件](#thm-A.10) (1)–(4)。
:::

::: proof 证

设 $X,Y$ 都满足 (1)–(4)。分四步把 $X$ 换成 $Y$。

**第一步（消去右边）**：由 (2) 与 (3)（$AX$ Hermite），

$$X=XAX=X\,(AX)=X\,(AX)^{\mathrm H}=X\,X^{\mathrm H}A^{\mathrm H} .$$

再用 (1) 的转置 $A^{\mathrm H}=A^{\mathrm H}Y^{\mathrm H}A^{\mathrm H}$ 代入右端最末的 $A^{\mathrm H}$：

$$X=XX^{\mathrm H}\big(A^{\mathrm H}Y^{\mathrm H}A^{\mathrm H}\big)=\big(XX^{\mathrm H}A^{\mathrm H}\big)\,Y^{\mathrm H}A^{\mathrm H}=X\cdot Y^{\mathrm H}A^{\mathrm H}=X\,(AY)^{\mathrm H}=X\,(AY)=XAY .$$

**第二步（左乘 $A$）**：$AX=A(XAY)=(AXA)Y=AY$。

**第三步（转置得右乘版本）**：对 $AX=AY$ 取共轭转置并用 (4)：$X^{\mathrm H}A^{\mathrm H}=Y^{\mathrm H}A^{\mathrm H}$，即 $(XA)^{\mathrm H}=(YA)^{\mathrm H}$，再转置回来得 $XA=YA$。

**第四步（拼装）**：用 (2) 把 $X$ 夹住，再把刚得到的两个等式各用一次：

$$X=XAX=(XA)X=(YA)X=Y(AX)=Y(AY)=YAY=Y .\qquad\blacksquare$$

:::

::: note 伪逆是「最优解的机器」

四条件各自的含义（都可以从 [3.1](../ch03/sec31.md)–[3.2](../ch03/sec32.md) 的结构读出）：(1) 说 $AA^{+}$ 把 $R(A)$ 的每个向量原样送回——它是**到值域的投影**；(4) 说这个投影正交；(2)(3) 对偶地说 $A^{+}A$ 是到 $R(A^{\mathrm H})$ 的正交投影。于是

$$A^{+}\boldsymbol{b}=\text{方程组 }A\boldsymbol{x}=\boldsymbol{b}\text{ 的最小二乘解中范数最小者}$$

（存在性：$\boldsymbol{x}^{+}=A^{+}\boldsymbol{b}$ 满足法方程 $A^{\mathrm H}A\boldsymbol{x}=A^{\mathrm H}\boldsymbol{b}$，见[附录 B.3](appendix-b.md#sec-B.3)；最小范数性由 $A^{+}\boldsymbol{b}\in R(A^{\mathrm H})=N(A)^{\perp}$ 与 [1.6.7](../ch01/sec16.md#sec-1.6.7) 的勾股结构给出——完整论证留作练习，或见后续广义逆章节）。三个特例与 [3.1](../ch03/sec31.md#thm-3.1.1) 完全接轨：$A$ 可逆时 $A^{+}=A^{-1}$；列满秩时 $A^{+}=(A^{\mathrm H}A)^{-1}A^{\mathrm H}$（左逆）；行满秩时 $A^{+}=A^{\mathrm H}(AA^{\mathrm H})^{-1}$（右逆）。
:::

## 附录 A 自测

::: ex 即时自测（不看上文，8 分钟）{#ex-A.quiz}

1. 写出复空间的极化恒等式，并说明它为什么给出「保长度的线性变换保内积」。
2. Hadamard 不等式 $|\det A|\leq\prod_i\|\boldsymbol{a}_i\|$ 的等号条件是什么？用体积语言一句话说明理由。
3. 证明 $\dim V_\lambda\leq$ 代数重数时，矩阵 $B=P^{-1}AP$ 为什么呈 $\begin{bmatrix}\lambda I_k&M\\O&C\end{bmatrix}$ 形？
4. Cayley–Hamilton 定理证明中，为什么 $B(\lambda)=\operatorname{adj}(\lambda I-A)$ 的每个元素都是次数 $\leq n-1$ 的多项式？
5. 正定 Hermite 矩阵的 Cholesky 分解 $A=R^{\mathrm H}R$ 用什么工具构造？$R$ 的哪两条性质来自 [1.6.8]？
6. 伪逆唯一性证明的第二步 $AX=AY$ 是怎么得到的？

::: sol 参考要点

1. $(\boldsymbol{x},\boldsymbol{y})=\tfrac14\big(\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2+i\|\boldsymbol{x}+i\boldsymbol{y}\|^2-i\|\boldsymbol{x}-i\boldsymbol{y}\|^2\big)$。右端只含范数；$T$ 线性把 $T$ 移进括号（如 $\|T(\boldsymbol{x}+\boldsymbol{y})\|=\|T\boldsymbol{x}+T\boldsymbol{y}\|$），保长度使右端逐项相等。
2. 各列两两正交。每层「高 = 棱长」必须逐层取等，即每个向量与前面全部向量正交。
3. 基扩充后，前 $k$ 个基向量满足 $A\boldsymbol{x}_j=\lambda\boldsymbol{x}_j$，其坐标列是 $\lambda\boldsymbol{e}_j$——前 $k$ 列就是 $\lambda I_k$ 与零块的竖排；按分块读出即得。
4. $\operatorname{adj}$ 的元素是 $\lambda I-A$ 的 $n-1$ 阶子式；每个子式的每行至多含一个 $\lambda$，故次数 $\leq n-1$。
5. 对 $(\boldsymbol{x},\boldsymbol{y})_A=\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 用 Gram–Schmidt；$R$ 是由 $\boldsymbol{q}$ 组（$A$-标准正交基）到标准基的过渡矩阵，上三角、对角元全正（可逆）。
6. 第一步得 $X=XAY$，两边左乘 $A$：$AX=A(XAY)=(AXA)Y=AY$（用了条件 (1)）。
:::
:::
