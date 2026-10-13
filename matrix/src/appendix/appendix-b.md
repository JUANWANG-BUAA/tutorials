# 附录 B · 走向其他学科：线性代数的六个出口

前三章建立的概念——子空间、正交投影、特征值、矩阵分解——不是为考试而生的标本，它们是六七个学科共用的骨架。本附录从「本教程的哪条结论出发」走到「那个学科的哪块基石」：每一节都是**一段完整的推导**加一个能上手的算例，而不是名词罗列。

> **定位说明。**与[附录 A](appendix-a.md) 相同，本附录**超出本课程考核范围**，各节彼此独立。给出的推导只用本教程已学的工具；个别必须引用后续课程结论处（谱定理、奇异值分解），都明确标注。

| 出发点（本教程） | 学科 | 落地结论 |
|:--|:--|:--|
| C–S 不等式（[1.5.2](../ch01/sec15.md#sec-1.5.2)） | 量子力学 | 测量概率天然不超过 $1$ |
| 标准正交基与傅里叶系数（[1.5.7](../ch01/sec15.md#sec-1.5.7)） | 信号处理 | DFT 是酉变换；能量守恒 |
| 正交投影与最近点（[1.6.7](../ch01/sec16.md#sec-1.6.7)） | 统计回归 | 最小二乘 = 投影；法方程 |
| 特征值与对角化（[2.4](../ch02/sec24.md)） | 统计学习 | 主成分分析（PCA） |
| QR 与正交矩阵（[1.6.8](../ch01/sec16.md#sec-1.6.8)、[2.5](../ch02/sec25.md)） | 数值分析 | 稳定的最小二乘算法 |
| 差分方程 + 特征值（[1.2.4](../ch01/sec12.md#sec-1.2.4)、[2.3.5](../ch02/sec23.md#sec-2.3.5)） | 微分方程 | 解空间维数与 $\mathrm e^{At}$ |
| 满秩分解（[3.2](../ch03/sec32.md)） | 数据科学 | 低秩近似与推荐系统 |

<a id="sec-B.1"></a>

## B.1 量子力学：状态装进酉空间

量子力学的数学舞台正是第一章的**酉空间**（有限维复内积空间，[1.4.1](../ch01/sec14.md#def-1.4.1)）：

- **量子态 = 归一化向量**：一个系统的状态由 $\boldsymbol{\psi}\in\mathbb C^n$（$n$ 维情形；真实系统常为无穷维）描述，约定 $\|\boldsymbol{\psi}\|=1$。物理上的 Dirac 记号 $|\psi\rangle$（右矢）就是向量本身，$\langle\varphi|$（左矢）是「先取共轭再配对」的泛函；
- **内积 = 概率幅**：测量「系统处于状态 $\boldsymbol{\varphi}$」得到肯定回答的概率是

$$p=\big|(\boldsymbol{\varphi},\boldsymbol{\psi})\big|^2\qquad(\|\boldsymbol{\varphi}\|=\|\boldsymbol{\psi}\|=1).$$

（记号约定：物理教材的内积通常对第二变元线性，与本教程相反；上式按本教程约定书写，翻译成 Dirac 记号时交换两个变元即可，一切数值结论不变。）

::: prop 命题 B.1 · C–S 不等式就是「概率不越界」{#prop-B.1}

对归一化的 $\boldsymbol{\varphi},\boldsymbol{\psi}\in\mathbb C^n$（标准内积），

$$0\ \le\ \big|(\boldsymbol{\varphi},\boldsymbol{\psi})\big|^2\ \le\ 1,$$

右端取等当且仅当两状态「平行」（相差一个模为 $1$ 的复因子——物理上视为同一个态）。
:::

::: proof 证

由 Cauchy–Schwarz（[@thm-1.5.1]）：$|(\boldsymbol{\varphi},\boldsymbol{\psi})|\leq\|\boldsymbol{\varphi}\|\,\|\boldsymbol{\psi}\|=1$，平方即得。等号 ⟺ 线性相关 ⟺ $\boldsymbol{\varphi}=c\boldsymbol{\psi}$；归一化迫使 $|c|=1$。∎
:::

这条不等式在物理教材里往往被一句「概率显然不超过 $1$」带过——但正是 C–S 保证了 Born 规则（概率 $=$ 概率幅的模平方）**在数学上是自洽的**：没有 C–S，两个单位向量的内积可以任意大，「概率」就会越界。

::: prop 命题 B.2 · 可观测量的实性：Hermite 算子的特征值必为实数 {#prop-B.2}

设 $A=A^{\mathrm H}$（Hermite 矩阵，[1.4.4](../ch01/sec14.md#sec-1.4.4)），$\lambda$ 是其特征值、$\boldsymbol{v}\neq\boldsymbol{0}$ 是相应特征向量，则 $\lambda\in\mathbb R$。
:::

::: proof 证

由 $A\boldsymbol{v}=\lambda\boldsymbol{v}$ 与本教程「第一变元线性、第二变元共轭线性」的约定：

$$(A\boldsymbol{v},\boldsymbol{v})=(\lambda\boldsymbol{v},\boldsymbol{v})=\lambda(\boldsymbol{v},\boldsymbol{v}),\qquad (\boldsymbol{v},A\boldsymbol{v})=(\boldsymbol{v},\lambda\boldsymbol{v})=\overline{\lambda}(\boldsymbol{v},\boldsymbol{v}).$$

另一方面，Hermite 性把两个内积联系在一起：

$$(A\boldsymbol{v},\boldsymbol{v})=\boldsymbol{v}^{\mathrm H}A\boldsymbol{v}=\boldsymbol{v}^{\mathrm H}A^{\mathrm H}\boldsymbol{v}=(\boldsymbol{v},A\boldsymbol{v}).$$

三式合并：$\lambda(\boldsymbol{v},\boldsymbol{v})=\overline{\lambda}(\boldsymbol{v},\boldsymbol{v})$，而 $(\boldsymbol{v},\boldsymbol{v})=\|\boldsymbol{v}\|^2>0$，故 $\lambda=\overline{\lambda}$，$\lambda$ 为实数。∎
:::

量子力学把「可观测量」（位置、动量、能量）编码为 Hermite 算子——**测量值只能是实数**，命题 B.2 就是这条物理要求的代数形态。测到某个值 $\lambda$ 的「确定态」恰是 $A$ 的特征向量（属于 $\lambda$ 的特征方向上概率取到 $1$，即 [@prop-B.1] 的等号情形）；[2.4](../ch02/sec24.md) 的整套「求特征值与特征向量」流程，在物理系学生的课表里叫「解定态薛定谔方程」。最后，状态的演化由酉矩阵驱动：$U^{\mathrm H}U=I$（[2.5](../ch02/sec25.md#def-orth-matrix)）保证演化后仍是单位向量（[2.5](../ch02/sec25.md#thm-orth-equiv) 保长度），一切概率继续合法——**2.5 节就是量子力学的运动学**。

<a id="sec-B.2"></a>

## B.2 信号处理：DFT 是一个酉变换

数字信号就是 $\mathbb C^N$ 里的向量 $\boldsymbol{x}=(x_0,\cdots,x_{N-1})^{\mathrm T}$（下标为采样时刻，[1.1.7](../ch01/sec11.md#sec-1.1.7) 的信号空间取有限长一段）；$\|\boldsymbol{x}\|^2=\sum_j|x_j|^2$ 称为信号的**能量**。两个信号的内积（去掉均值后）度量它们的相似程度——「匹配滤波」=「算内积」，归一化相似度 $\dfrac{(\boldsymbol{x},\boldsymbol{y})}{\|\boldsymbol{x}\|\|\boldsymbol{y}\|}$ 永远落在 $[-1,1]$ 的复单位圆内，依据仍是 C–S。

把信号「翻译到频域」用的是**离散傅里叶变换（DFT）**。记 $\omega=\mathrm e^{-2\pi \mathrm i/N}$（$N$ 次单位根），定义

$$y_k=\frac{1}{\sqrt N}\sum_{j=0}^{N-1}\omega^{jk}x_j,\qquad k=0,\cdots,N-1,$$

即 $\boldsymbol{y}=F\boldsymbol{x}$，其中 $F=(\omega^{jk}/\sqrt N)_{k,j}\in\mathbb C^{N\times N}$（行号 $k$、列号 $j$ 都从 $0$ 起）。

::: prop 命题 B.3 · DFT 矩阵是酉矩阵 {#prop-B.3}

$F^{\mathrm H}F=I$：DFT 把标准正交基（坐标基）换成另一组标准正交基（频率基 $\tfrac{1}{\sqrt N}(1,\omega^{-k},\omega^{-2k},\cdots)^{\mathrm T}$，$k=0,\cdots,N-1$）。
:::

::: proof 证

逐元素验证。$(F^{\mathrm H}F)$ 的 $(j,l)$ 元为

$$\sum_{k=0}^{N-1}\overline{F_{kj}}\,F_{kl}=\frac1N\sum_{k=0}^{N-1}\omega^{-jk}\omega^{lk}=\frac1N\sum_{k=0}^{N-1}\big(\omega^{\,l-j}\big)^{k}.$$

$j=l$ 时每项为 $1$，和为 $N$，该元为 $1$；$j\neq l$ 时是公比为 $\omega^{l-j}\neq1$ 的等比级数（$\omega^N=1$）：

$$\frac1N\cdot\frac{(\omega^{l-j})^N-1}{\omega^{l-j}-1}=\frac1N\cdot\frac{1-1}{\omega^{l-j}-1}=0 .$$

故 $F^{\mathrm H}F=I$。∎
:::

于是一整套已学结论免费到账：**能量守恒（Parseval）**——酉变换保内积（[2.5](../ch02/sec25.md#thm-orth-equiv)），故 $\|F\boldsymbol{x}\|=\|\boldsymbol{x}\|$，时域能量 $=$ 频域能量，这正是[附录 A.7](appendix-a.md#sec-A.7) 的有限维版；**滤波 = 投影**——「保留低频、清零高频」就是把 $\boldsymbol{x}$ 正交投影到「低频频率基张成的子空间」（[1.6.7](../ch01/sec16.md#sec-1.6.7) 的投影公式在标准正交基下逐坐标执行：保留若干坐标、其余置零）；**去噪的依据**——若噪声与信号频段正交，投影在去掉噪声的同时不伤信号。[1.5.7](../ch01/sec15.md#sec-1.5.7) 的三角函数系在无穷维把同一故事讲到极限，傅里叶级数与 DFT 是同一机制的两个尺度。

<a id="sec-B.3"></a>

## B.3 统计与回归：最小二乘就是正交投影

统计与机器学习里最高频的一件事：**用一组「模型值」去逼近一堆「观测值」**。设观测数据 $(t_i,y_i)$（$i=1,\cdots,m$），想用直线 $y=c+\mathrm dt$ 拟合。把它翻译成矩阵语言：

$$A=\begin{bmatrix}1&t_1\\ \vdots&\vdots\\ 1&t_m\end{bmatrix}\in\mathbb R^{m\times2},\qquad \boldsymbol{b}=\begin{bmatrix}y_1\\ \vdots\\ y_m\end{bmatrix},\qquad \text{求}\ \boldsymbol{x}=(c,\mathrm d)^{\mathrm T}\ \text{使}\ A\boldsymbol{x}\approx\boldsymbol{b}.$$

数据点通常不共线（$m\gt2$、$\boldsymbol{b}\notin R(A)$），方程组**无精确解**。「最好」的标准取为残差最小：

$$\|\boldsymbol{b}-A\boldsymbol{x}\|^2=\sum_{i=1}^{m}\big(y_i-(c+\mathrm dt_i)\big)^2\ \longrightarrow\ \min .$$

::: prop 命题 B.4 · 法方程与最优解 {#prop-B.4}

设 $A$ 列满秩。上式的唯一最优解 $\boldsymbol{x}^{*}$ 满足

$$A^{\mathrm T}A\,\boldsymbol{x}^{*}=A^{\mathrm T}\boldsymbol{b}\qquad(\text{法方程 / 正规方程})，$$

即 $\boldsymbol{x}^{*}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}$——恰是 [3.1](../ch03/sec31.md#thm-3.1.1) 的**左逆公式**。几何本质：$A\boldsymbol{x}^{*}$ 是 $\boldsymbol{b}$ 在列空间 $R(A)$ 上的**正交投影**。
:::

::: proof 证

记残差 $\boldsymbol{r}=\boldsymbol{b}-A\boldsymbol{x}$。由正交投影的「最近点」性质（[1.6.7](../ch01/sec16.md#sec-1.6.7)：正交投影是子空间中离该点最近的点）：$\|\boldsymbol{r}\|$ 最小当且仅当 $\boldsymbol{r}\perp R(A)$。而「与 $R(A)$ 中每个向量正交」等价于「与 $A$ 的每一列正交」（[1.6.5](../ch01/sec16.md#sec-1.6.5) 的「查基对基」），即

$$\boldsymbol{0}=A^{\mathrm T}\boldsymbol{r}=A^{\mathrm T}\boldsymbol{b}-A^{\mathrm T}A\boldsymbol{x},$$

此即法方程。$A$ 列满秩 ⟹ $A^{\mathrm T}A$ 可逆（[3.1](../ch03/sec31.md#prop-3.1.1) 的秩等式），解唯一。∎
:::

::: ex 例 B.1 · 三点拟合一条直线（全程数字）{#ex-B.1}

数据 $(0,1),\ (1,2),\ (2,4)$。则

$$A=\begin{bmatrix}1&0\\1&1\\1&2\end{bmatrix},\quad \boldsymbol{b}=\begin{bmatrix}1\\2\\4\end{bmatrix},\qquad A^{\mathrm T}A=\begin{bmatrix}3&3\\3&5\end{bmatrix},\quad A^{\mathrm T}\boldsymbol{b}=\begin{bmatrix}7\\10\end{bmatrix}.$$

法方程 $\begin{cases}3c+3\mathrm d=7\\ 3c+5\mathrm d=10\end{cases}$ 两式相减得 $2\mathrm d=3$，$\mathrm d=\tfrac32$，回代 $c=\tfrac56$。**最优直线**：$y=\tfrac56+\tfrac32t$。

**验算「残差正交」**：拟合值 $\tfrac56,\ \tfrac{14}{6},\ \tfrac{23}{6}$，残差 $\boldsymbol{r}=\big(\tfrac16,-\tfrac13,\tfrac16\big)^{\mathrm T}$；

$$\sum_ir_i=\tfrac16-\tfrac13+\tfrac16=0,\qquad \sum_it_ir_i=0-\tfrac13+2\cdot\tfrac16=0,$$

即 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$ ✓（残差同时垂直于 $A$ 的两列 $1$ 与 $t$）。残差平方和 $\tfrac1{36}+\tfrac19+\tfrac1{36}=\tfrac16$。
:::

这套语言可以无缝替换零件：模型取多项式（列换成 $t_i^2$）就是多项式回归；对不同观测赋不同信任度，相当于把标准内积换成**加权内积**（[1.4.3](../ch01/sec14.md#sec-1.4.3)）——公式里多一个权重矩阵，投影的几何不变；观测方程多于未知数（超定）是常态，「无解」并不可怕——**右端在列空间上的投影永远存在**（[1.6.6](../ch01/sec16.md#sec-1.6.6) 正交分解定理），最小二乘解就是投影的坐标。当 $A$ 不列满秩时，法方程有多解，其中范数最小的那个由伪逆给出（[附录 A.8](appendix-a.md#sec-A.8)）。

<a id="sec-B.4"></a>

## B.4 主成分分析：协方差矩阵的特征分解

数据科学的第一步是「降维」：$m$ 个样本、每样本 $n$ 个特征，组成数据矩阵 $X\in\mathbb R^{m\times n}$。先将每列**中心化**（减去该列均值），记中心化后的矩阵为 $X_c$，定义样本协方差矩阵

$$\Sigma=\frac{1}{m-1}X_c^{\mathrm T}X_c\in\mathbb R^{n\times n}.$$

**降维的数学问题**：找一个方向 $\boldsymbol{w}$（$\|\boldsymbol{w}\|=1$），把每个样本投影到这个方向上，让投影得分**尽量散开**（方差最大）——因为「都挤在一起的方向」不携带信息。

::: prop 命题 B.5 · 投影方差、半正定性与特征值 {#prop-B.5}

1. 沿方向 $\boldsymbol{w}$ 的投影得分为 $X_c\boldsymbol{w}$，其（未归一）方差恰为 $\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}$；
2. $\Sigma$ 是**半正定**的对称矩阵：对一切 $\boldsymbol{w}$ 有 $\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}\geq0$；
3. 若 $\boldsymbol{w}$ 是 $\Sigma$ 的单位特征向量、特征值为 $\lambda$，则投影方差 $=\lambda$。于是「找方差最大的方向」=「找最大特征值的方向」。
:::

::: proof 证

**1.** 得分向量的均值为 $\boldsymbol{0}$（中心化保证），故方差 $\propto\|X_c\boldsymbol{w}\|^2=\boldsymbol{w}^{\mathrm T}X_c^{\mathrm T}X_c\boldsymbol{w}=(m-1)\,\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}$。

**2.** $\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}=\dfrac{1}{m-1}\|X_c\boldsymbol{w}\|^2\geq0$——**得分是实数序列，方差非负**，这就是半正定性的统计含义（半正定的定义见[定义 1.4.3](../ch01/sec14.md#def-1.4.3)；一般地 $M^{\mathrm H}M$ 总是半正定，正定与否取决于 $M$ 是否列满秩——[3.1](../ch03/sec31.md#prop-3.1.1)）。

**3.** $\Sigma\boldsymbol{w}=\lambda\boldsymbol{w}$、$\|\boldsymbol{w}\|=1$ 时，$\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}=\lambda\,\boldsymbol{w}^{\mathrm T}\boldsymbol{w}=\lambda$。∎
:::

严格求解「单位球面上最大化 $\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}$」需要**谱定理**（实对称矩阵有一组标准正交特征向量，且在该组基下对角化——本课程后续章节的内容）；谱定理之下答案就是：按特征值从大到小，**第 $k$ 主成分 = 第 $k$ 大特征值对应的单位特征向量**，其方差即该特征值。

::: ex 例 B.2 · 二维数据的两个主成分 {#ex-B.2}

设某中心化数据集的协方差矩阵为

$$\Sigma=\begin{bmatrix}2&1\\1&2\end{bmatrix}\qquad(\text{两列各自方差为 }2\text{，相关 }1).$$

求特征值：$\det(\lambda I-\Sigma)=(\lambda-2)^2-1$，得 $\lambda_1=3,\ \lambda_2=1$。求特征向量并单位化：

$$\boldsymbol{w}_1=\tfrac{1}{\sqrt2}(1,1)^{\mathrm T}\ (\text{属于 }3),\qquad \boldsymbol{w}_2=\tfrac{1}{\sqrt2}(1,-1)^{\mathrm T}\ (\text{属于 }1).$$

**解读**：数据沿「两特征同增」的对角方向最散（方差 $3$），沿反对角方向最紧（方差 $1$）；只保留 $\boldsymbol{w}_1$ 一个方向，就保存了 $3/(3+1)=75\%$ 的总方差。两个主成分**正交**（[不同特征值的特征向量线性无关](../ch02/sec24.md#thm-eig-independent)的现成应用）且新旧坐标由正交过渡矩阵连接——协方差矩阵在新基下成为 $\operatorname{diag}(3,1)$，这一步在统计里叫「去相关」，在 [1.4.7](../ch01/sec14.md#sec-1.4.7) 里叫**合同变换**：同一个公式（$\Sigma'=P^{\mathrm T}\Sigma P$），几何读法是换尺子，统计读法是换坐标系。
:::

PCA 的每一步都踩在本教程的坐标上：中心化 = 减去均值子空间的投影；「找主成分」= 对 $\Sigma$ 执行 [2.4](../ch02/sec24.md) 的特征值流程；「白化」（把方差全部归一）= 沿用 [附录 A.6](appendix-a.md#sec-A.6) 的开方分解 $\Sigma=R^{\mathrm T}R$。反过来，PCA 也解释了 [2.4](../ch02/sec24.md#ex-jordan-three) 反复强调的「几何重数」的统计含义：若某特征值是重根，主方向不再唯一，数据的「厚薄」在一张平面上均匀——特征子空间恰是这个均匀平面。

<a id="sec-B.5"></a>

## B.5 数值分析：正交的算法

计算机上解 [B.3](#sec-B.3) 的最小二乘，工程师几乎不直接解法方程。原因和替代方案都只用已学工具就能说清。

**事实一：正交（酉）矩阵不放大误差。** 数值计算里每步都有舍入误差 $\boldsymbol{e}$，一个算法把误差传到结果时最好乘的是正交矩阵：$\|Q\boldsymbol{e}\|=\|\boldsymbol{e}\|$（[2.5](../ch02/sec25.md#thm-orth-equiv) 保长度），误差的长度**原样通过**；换成一般矩阵，误差可能被放大。配套的定量工具是反向三角不等式（[附录 A.1](appendix-a.md#prop-A.2)）：$\big|\|Q(\boldsymbol{x}+\boldsymbol{e})\|-\|\boldsymbol{x}\|\big|\leq\|\boldsymbol{e}\|$。这正是数值库用 Givens 旋转与 Householder 反射（[2.5](../ch02/sec25.md#def-givens)）做矩阵分解的原因——**每一步操作都是正交的**，误差全程不被放大；Hadamard 不等式（[附录 A.2](appendix-a.md#cor-A.2)）则从另一端说明正交列在数值上的稳固。

**事实二：QR 路线把法方程「绕开」。** 对列满秩的 $A\in\mathbb C^{m\times n}$ 取 QR 分解 $A=QR$（$Q^{\mathrm H}Q=I$、$R$ 可逆上三角；由 Gram–Schmidt 得到，[1.6.8](../ch01/sec16.md#sec-1.6.8) 的 $X=QA$ 即其雏形）。把它代入法方程并化简：

$$A^{\mathrm H}A\boldsymbol{x}=A^{\mathrm H}\boldsymbol{b}\ \iff\ R^{\mathrm H}\underbrace{Q^{\mathrm H}Q}_{I}R\boldsymbol{x}=R^{\mathrm H}Q^{\mathrm H}\boldsymbol{b}\ \iff\ R\boldsymbol{x}=Q^{\mathrm H}\boldsymbol{b},$$

（两边左乘 $(R^{\mathrm H})^{-1}$，$R$ 可逆）——**上三角方程组，回代即解**，全程无需形成 $A^{\mathrm H}A$。

**为什么怕 $A^{\mathrm H}A$？** 条件数的直觉（严格论证需奇异值分解，后续章节）：$A$ 的「最小伸缩比例」若是 $\sigma$，则 $A^{\mathrm H}A$ 的最小比例约为 $\sigma^2$——$\sigma=0.01$ 时变成 $10^{-4}$，**有效数字凭空丢一半**。法方程把「中等病态」的问题平方成「严重病态」。QR 路线的每步只做正交变换与回代，不经过这个平方。

一句话总结本节：**正交性是数值线性代数的硬通货**——保长度（不放大误差）、保内积（保结构）、上三角化（可回代）。本教程的 [1.5.6](../ch01/sec15.md#sec-1.5.6)、[1.6.8](../ch01/sec16.md#sec-1.6.8)、[2.5](../ch02/sec25.md) 三处铺垫，在数值库里合流成同一套工业代码。

<a id="sec-B.6"></a>

## B.6 微分方程：解空间与矩阵指数

[1.2.4](../ch01/sec12.md#sec-1.2.4) 证明了齐次**差分**方程的解集是子空间；[2.3.5](../ch02/sec23.md#sec-2.3.5) 用同构量出它的维数是 $n$。齐次**微分**方程是同一结构的连续版本：

$$y^{(n)}+a_{n-1}y^{(n-1)}+\cdots+a_1y'+a_0y=0 .$$

**解集是 $n$ 维子空间**：叠加原理（两个解的线性组合仍是解）就是「对线性组合封闭」；维数为 $n$ 的原因是「初值 $(y(0),y'(0),\cdots,y^{(n-1)}(0))$ 唯一确定一个解」（微分方程存在唯一性定理，先修课内容），映射「解 $\mapsto$ 初值」正是一个同构——与 [2.3.5](../ch02/sec23.md#sec-2.3.5) 里「解序列 $\mapsto x_0$」的同构逐字对应。

**特征根法 = 解方程 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 的前辈。** 把试探解 $y=\mathrm e^{\lambda t}$ 代入方程，逐项求导得 $y^{(k)}=\lambda^k\mathrm e^{\lambda t}$，约去 $\mathrm e^{\lambda t}$（恒非零）：

$$\lambda^n+a_{n-1}\lambda^{n-1}+\cdots+a_1\lambda+a_0=0$$

——**微分方程的特征多项式**。它与 [1.2.4](../ch01/sec12.md#sec-1.2.4) 末尾差分方程的特征多项式$(\lambda+1)(\lambda-2)(\lambda-3)$ 完全同型；差分方程的解是等比序列 $\lambda^k$、微分方程的解是指数函数 $\mathrm e^{\lambda t}$，「移位 vs 求导」是两种「离散 / 连续」的同一件事。

**一阶系统与矩阵指数。** 把 $n$ 阶方程降为一阶方程组：令 $\boldsymbol{x}(t)=(y,y',\cdots,y^{(n-1)})^{\mathrm T}$，则 $\boldsymbol{x}'(t)=A\boldsymbol{x}(t)$，$A$ 恰是 [2.1.2](../ch02/sec21.md#sec-2.1.2) 的**友矩阵**。核心工具是矩阵指数

$$\mathrm e^{At}\triangleq I+At+\frac{A^2t^2}{2!}+\cdots=\sum_{k=0}^{\infty}\frac{A^kt^k}{k!},$$

（逐项求导可验证 $\dfrac{\mathrm d}{\mathrm dt}\mathrm e^{At}=A\,\mathrm e^{At}$，于是 $\boldsymbol{x}(t)=\mathrm e^{At}\boldsymbol{x}(0)$ 是解。）

::: prop 命题 B.6 · 可对角化时 $\mathrm e^{At}=P\mathrm e^{\Lambda t}P^{-1}$ {#prop-B.6}

设 $A=P\Lambda P^{-1}$（$A$ 可对角化，$\Lambda=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$），则

$$\mathrm e^{At}=P\,\operatorname{diag}\big(\mathrm e^{\lambda_1t},\cdots,\mathrm e^{\lambda_nt}\big)\,P^{-1},$$

即换到特征向量坐标系后，耦合的系统解耦为 $n$ 个独立的方程 $u_i'=\lambda_iu_i$。
:::

::: proof 证

令 $\boldsymbol{x}=P\boldsymbol{u}$（换基，$P$ 的列是特征向量）。代入 $\boldsymbol{x}'=A\boldsymbol{x}$：

$$P\boldsymbol{u}'=AP\boldsymbol{u}=P\Lambda\boldsymbol{u}\qquad\Longrightarrow\qquad \boldsymbol{u}'=\Lambda\boldsymbol{u}$$

（左乘 $P^{-1}$）。$\Lambda$ 是对角阵，方程组按分量拆开：$u_i'=\lambda_iu_i$，解 $u_i(t)=c_i\mathrm e^{\lambda_it}$。回到原坐标：$\boldsymbol{x}=P\boldsymbol{u}$，即

$$\boldsymbol{x}(t)=\sum_{i=1}^{n}c_i\,\mathrm e^{\lambda_it}\,\boldsymbol{p}_i=P\operatorname{diag}\big(\mathrm e^{\lambda_it}\big)\boldsymbol{c}=P\,\mathrm e^{\Lambda t}\,P^{-1}\boldsymbol{x}(0).$$

这正是「对角化 = 解耦」：[2.4](../ch02/sec24.md#ex-design-diag)「设计一组基使矩阵为对角形」的工程回报。∎
:::

::: ex 例 B.3 · 一个二阶系统的完整求解 {#ex-B.3}

$$\boldsymbol{x}'=\begin{bmatrix}1&1\\0&2\end{bmatrix}\boldsymbol{x},$$

（$A$ 即[例 2.3.B](../ch02/sec23.md#ex-2.3.B) 的老矩阵。）

由[例 2.3.B](../ch02/sec23.md#ex-2.3.B)：特征值 $1,2$，特征向量 $\boldsymbol{e}_1$ 与 $(1,1)^{\mathrm T}$。取 $P=\begin{bmatrix}1&1\\0&1\end{bmatrix}$，则 $\Lambda=\operatorname{diag}(1,2)$，通解

$$\boldsymbol{x}(t)=c_1\mathrm e^{t}\begin{bmatrix}1\\0\end{bmatrix}+c_2\mathrm e^{2t}\begin{bmatrix}1\\1\end{bmatrix}.$$

例如初值 $\boldsymbol{x}(0)=(3,1)^{\mathrm T}$：由 $c_1+c_2=3$、$c_2=1$ 得 $c_1=c_2=1$，解 $\boldsymbol{x}(t)=\mathrm e^{t}(1,0)^{\mathrm T}+\mathrm e^{2t}(1,1)^{\mathrm T}$。**直接验证**：$\boldsymbol{x}'=\mathrm e^{t}(1,0)^{\mathrm T}+2\mathrm e^{2t}(1,1)^{\mathrm T}$，而 $A\boldsymbol{x}=\mathrm e^{t}A(1,0)^{\mathrm T}+\mathrm e^{2t}A(1,1)^{\mathrm T}=\mathrm e^{t}(1,0)^{\mathrm T}+2\mathrm e^{2t}(1,1)^{\mathrm T}$ ✓。
:::

**稳定性一眼可见**：解是若干 $\mathrm e^{\lambda_it}$ 的叠加，衰减 ⟺ 一切 $\operatorname{Re}\lambda_i\lt0$。离散系统 $\boldsymbol{x}_{k+1}=A\boldsymbol{x}_k$（[2.3.5](../ch02/sec23.md#sec-2.3.5) 的状态递推）同理：$\boldsymbol{x}_k=A^k\boldsymbol{x}_0$，衰减 ⟹ 一切 $|\lambda_i|\lt1$（[幂与逆的特征值](../ch02/sec24.md#thm-eig-power)）。控制工程判断「系统是否稳定」、马尔可夫链判断「是否收敛到平稳分布」，用的都是这两个特征值判据——特征值从 [2.4](../ch02/sec24.md) 的一道考题，长成了工程里的体检指标。

<a id="sec-B.7"></a>

## B.7 数据科学：低秩 = 压缩 + 泛化

[3.2](../ch03/sec32.md) 的满秩分解 $A=BC$ 把矩阵拆成「$r$ 列骨架 $\times$ $r$ 行图纸」。数据科学把它读成一个语义模型：

$$\underbrace{A}_{m\times n\ \text{评分矩阵}}=\underbrace{B}_{m\times r\ :\ \text{每个用户的 }r\ \text{维画像}}\ \cdot\ \underbrace{C}_{r\times n\ :\ \text{每个物品的 }r\ \text{维画像}}$$

「秩 $r$」= 假设口味可以被 $r$ 个隐因子解释。**$r=1$ 时矩阵的每个元素都形如 $a_{ij}=u_iv_j$**——一份乘法表。

::: ex 例 B.4 · 秩 $1$ 补全：缺一个评分也能算出来 {#ex-B.4}

$$A=\begin{bmatrix}5&10&?\\ 2&?&6\\ 4&8&?\end{bmatrix},\qquad \text{设}\
A\ \text{的秩为}\ 1\ (a_{ij}=u_iv_j).$$

全部由**已观测入口**读出因子：比较 $a_{12}=10$ 与 $a_{11}=5$ 得 $v_2=2v_1$；比较 $a_{23}=6$ 与 $a_{21}=2$ 得 $v_3=3v_1$；比较 $a_{21}=2$ 与 $a_{11}=5$ 得 $u_2=\tfrac25u_1$；$a_{31}=4$ 再给出 $u_3=4v_1$。取 $v_1=1$，即 $v=(1,2,3)$、$u=(5,2,4)^{\mathrm T}$（等比例因子可整体挪动，正是[定理 3.2.2](../ch03/sec32.md#thm-3.2.2) 里「相差一个可逆因子 $D$」的一维版），于是

$$a_{22}=u_2v_2=2\times2=4,\qquad a_{13}=u_1v_3=15,\qquad a_{33}=4\times3=12 .$$

三个问号全部由**乘法结构**补出——这就是「推荐系统 = 低秩矩阵补全」的一句话原理：观测到的评分决定因子，因子预测没观测到的评分。
:::

**压缩账本**：$m\times n$ 矩阵存 $mn$ 个数；改存 $B$ 与 $C$ 只需 $(m+n)r$ 个。一张 $512\times512$ 的灰度图按秩 $r=32$ 分解：$2\times512\times32=32768$ 个数，约为原始 $262144$ 个的 $\tfrac18$。图像压缩、音频降噪、语义分析共用这一账本——「**秩 = 有效信息量**」，这正是 [3.1](../ch03/sec31.md#sec-3.1.1) 相抵标准形 $\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$ 的数据科学读法。

严格的理论问题「哪个秩 $r$ 矩阵离 $A$ 最近」由**奇异值分解**回答（Eckart–Young 定理，本课程后续章节）：满秩分解还原 $A$ 分毫不差，低秩近似则**有意丢掉**最小的若干奇异方向。两者共享同一句直觉：把「骨架」留下，把「噪声」扔掉。

::: note 更多出口（一段一个，点到为止）

- **编码理论**：线性码 = $\mathbb F_2^n$（二元域上的向量空间）的子空间——本教程的「数域」限定为数集（$\mathbb Q\subset\mathbb R\subset\mathbb C$），但线性空间的八条公理对任意域逐字成立；「检错」=「接收向量是否落在码子空间」，[1.2](../ch01/sec12.md#thm-1.2.1) 的判定思想原样可用。
- **谱图理论**：图的结构编码在邻接矩阵 / 拉普拉斯矩阵的特征值里——「图有几个紧密社区」≈「拉普拉斯矩阵前几个小特征值怎么分布」，是 [2.4](../ch02/sec24.md) 在组合对象上的化身。
- **马尔可夫链**：转移矩阵 $P$（每行和为 $1$）必有特征值 $1$，对应平稳分布；收敛速度由第二大特征值的模决定（对照 [B.6](#sec-B.6) 的稳定性判据）。
- **计算机图形学**：旋转、反射是正交矩阵（[2.3.1](../ch02/sec23.md#ex-2.3.1)、[2.5](../ch02/sec25.md)），相机运动 = 一串正交矩阵的乘积；「齐次坐标」技巧把平移也写成矩阵乘法，把整个渲染管线变成一次矩阵连乘——工程上在用的，正是「线性映射 = 矩阵」（[2.3](../ch02/sec23.md#thm-2.3.2)）。
:::

## 附录 B 自测

::: ex 即时自测（不看上文，8 分钟）{#ex-B.quiz}

1. 量子力学中测量概率为什么天然不超过 $1$？等号何时成立（物理上如何解读）？
2. 验证 DFT 矩阵酉性的关键一步是哪个求和？$j\neq l$ 时它为什么等于零？
3. 最小二乘的法方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ 的几何推导分哪两步（各用哪条已学定理）？
4. 协方差矩阵为什么半正定？主成分方向的方差等于什么？
5. QR 求解最小二乘时，$R\boldsymbol{x}=Q^{\mathrm H}\boldsymbol{b}$ 是怎么从法方程化出来的？为什么数值上偏好这条路？
6. 秩 $1$ 补全用了 $A=BC$ 的哪一条性质？

::: sol 参考要点

1. 概率 $=|(\boldsymbol{\varphi},\boldsymbol{\psi})|^2$，而 $|(\boldsymbol{\varphi},\boldsymbol{\psi})|\leq\|\boldsymbol{\varphi}\|\|\boldsymbol{\psi}\|=1$（C–S，两个态都归一化）。等号 ⟺ 两向量线性相关 ⟺ 同一个物理态（差一个相位因子）。
2. $\tfrac1N\sum_k(\omega^{l-j})^k$：$j=l$ 时为 $1$；否则是公比 $\omega^{l-j}\neq1$、$N$ 项和首尾相除为零的等比级数（$\omega^N=1$）。
3. ① 残差最小 ⟺ 残差正交于 $R(A)$（[1.6.7](../ch01/sec16.md#sec-1.6.7) 最近点）；② 正交于子空间 ⟺ 正交于每个基向量即 $A$ 的各列（[1.6.5](../ch01/sec16.md#sec-1.6.5) 查基对基）⟹ $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$。
4. $\boldsymbol{w}^{\mathrm T}\Sigma\boldsymbol{w}=\tfrac1{m-1}\|X_c\boldsymbol{w}\|^2\geq0$（得分的方差非负；也即 $\Sigma=C^{\mathrm T}C$ 形式）。主成分方差 = 对应特征值 $\lambda$。
5. 代入 $A=QR$：$R^{\mathrm H}Q^{\mathrm H}QR\boldsymbol{x}=R^{\mathrm H}Q^{\mathrm H}\boldsymbol{b}$，$Q^{\mathrm H}Q=I$ 化为 $R^{\mathrm H}R\boldsymbol{x}=R^{\mathrm H}Q^{\mathrm H}\boldsymbol{b}$，左乘 $(R^{\mathrm H})^{-1}$ 即得。偏好原因：法方程形成 $A^{\mathrm H}A$ 会把条件数平方、丢有效数字；QR 路线每步正交变换不放大误差，最后只需回代上三角。
6. $a_{ij}=u_iv_j$（外积结构）：已观测入口确定因子 $u,v$，未观测入口由乘法补出；因子相差一个比例因子对应[定理 3.2.2](../ch03/sec32.md#thm-3.2.2) 的可逆因子 $D$（一维情形）。
:::
:::
