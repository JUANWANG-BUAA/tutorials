# 符号表

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $F$ | 数域 field | 含 $0,1$ 且对四则运算封闭的数集；常用 $\mathbb{R},\mathbb{C}$ |
| $V,\ (V,+,\cdot)$ | 线性空间 linear space | 数域 $F$ 上的线性空间；元素称为向量 |
| $\boldsymbol{\theta}$ / $\boldsymbol{0}$ | 零向量 zero vector | 满足 $\boldsymbol{\alpha}+\boldsymbol{\theta}=\boldsymbol{\alpha}$ 的唯一元素。**本教程约定**：抽象线性空间中的零元记 $\boldsymbol{\theta}$；矩阵、$\mathbb{C}^n$ 与方程组语境中的零向量记 $\boldsymbol{0}$（如 $A\boldsymbol{x}=\boldsymbol{0}$、坐标列 $\boldsymbol{0}$）。**同一小节内描述同一个对象时只用一种记法**，不要中途换写。 |
| $\mathbb{R}^n,\ \mathbb{C}^n$ | $n$ 维向量空间 | 实 / 复 $n$ 元有序数组全体 |
| $\mathbb{R}^{m\times n},\ \mathbb{C}^{m\times n}$ | 矩阵空间 | $m\times n$ 实 / 复矩阵全体 |
| $P_n(x)$ | 多项式空间 | 次数不超过 $n$ 的多项式与零多项式全体 |
| $S$ | 离散时间信号空间 | 双边序列 $\{x_k\}_{k=0,\pm1,\pm2,\cdots}$ 全体 |
| $W\subseteq V$ / $W\le V$ | 子空间 subspace | 本文用「$W$ 是 $V$ 的子空间」行文，不专用记号 |
| $f:V\to W$、$T:V\to W$ | 映射 / 线性映射 map / linear map | 第二章记号：一般映射记 $f,g$，线性映射记 $T$；$R(f)$ 为值域 |
| $f_2f_1$、$f_2\cdot f_1$ | 复合映射 composition | 先作用 $f_1$、再作用 $f_2$；$f^{-1}$ 为逆映射 |
| $I_V$ | 恒等映射 identity map | $I_V(x)=x$，$x\in V$；不同空间的恒等映射是不同的映射 |
| $\boldsymbol{\theta},\ \boldsymbol{\theta}'$ | 零元素 | $\boldsymbol{\theta}\in V$、$\boldsymbol{\theta}'\in W$ 分属两个空间（第二章起用撇号区分）；**全站一律用粗体** $\boldsymbol{\theta}$ |
| $L(V,W)$、（课件）$\mathcal L(V,W)$ | 线性映射空间 | $V\to W$ 全体线性映射；$L(V)$ 为线性变换空间；$\dim L=\dim V\cdot\dim W$ |
| $N(T)$、$R(T)$ | 核空间（零空间）、值空间（像空间） | $N(T)=\{x\mid T(x)=\boldsymbol{\theta}\}$、$R(T)=T(V)$；$\dim N(T)$ 称零度（亏）、$\dim R(T)$ 称秩 |
| $\alpha_1\cdots\alpha_n$、$\varepsilon,\eta$ | 基向量 | 第二章的「两组基」用 $\varepsilon_1,\cdots,\varepsilon_n$ 与 $\eta_1,\cdots,\eta_n$ |
| $W_1+W_2,\ W_1\cap W_2$ | 和空间 / 交空间 | 和：$\{\boldsymbol{\alpha}_1+\boldsymbol{\alpha}_2\}$；交：公共向量全体 |
| $\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$ | 张成（生成）子空间 | $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 的全体线性组合 |
| $N(A)$ | 零空间（核空间） | $\{\boldsymbol{x}\mid A\boldsymbol{x}=\boldsymbol{0}\}\subseteq\mathbb{C}^n$ |
| $R(A)$ | 列空间（值空间） | $\{A\boldsymbol{x}\mid \boldsymbol{x}\in\mathbb{C}^n\}\subseteq\mathbb{C}^m$，即 range |
| $\operatorname{rank}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$ | 秩 rank | 向量组的极大线性无关组所含向量个数；矩阵的秩记 $\operatorname{rank}A$ |
| $(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)$ | 基 basis | 有序向量组；作行向量记号时表示「按序排列」 |
| $A$ | 过渡矩阵 / 映射的矩阵 | 第一章：过渡矩阵，满足 $(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n)=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)A$ 的可逆矩阵；第二章 2.3 起：线性映射 $T$ 在给定两对基下的矩阵，$A$ 的第 $j$ 列是 $T(\varepsilon_j)$ 的坐标 |
| $\dim V$ | 维数 dimension | 基所含向量个数；零子空间 $\{\boldsymbol{\theta}\}$ 的维数为 $0$，无限维记 $\infty$ |
| $(\boldsymbol{x},\boldsymbol{y})$ | 内积 inner product | 本文约定对第一变元线性、对第二变元共轭线性 |
| $A^{\mathrm H}$ | 共轭转置 conjugate transpose | 先逐项取共轭再转置；$A=A^{\mathrm H}$ 称为 Hermite 矩阵 |
| $A\succ0$, $A\succeq0$ | 正定 / 半正定 | 对所有非零 $\boldsymbol{x}$，$\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}>0$；半正定改为 $\geq0$ |
| $G_{\mathcal E}$ | 度量（Gram）矩阵 | 固定基 $\mathcal E$ 后记录基向量两两内积，本文取 $(G_{\mathcal E})_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$ |
| $V\cong W$ | 同构 isomorphic | 存在**双射且保持线性运算**的映射（同构映射）；判别依据是 $\dim V=\dim W$。记 $L(V,W)\cong F^{m\times n}$ |
| $A\cong B$ | 相抵（等价）equivalent | $A$ 经有限次初等变换化为 $B$，等价于 $B=P^{-1}AQ$（$P,Q$ 可逆、同型矩阵）。**注意与上一行的 $V\cong W$ 同名不同义**，靠左右两侧是空间还是矩阵区分 |
| $B=P^{-1}AP$ | 相似 similar | 同一个线性变换在同一个空间的两组基下的矩阵；相似必相抵，反之不真 |

::: note

**向量记号。**向量用粗体希腊字母 $\boldsymbol{\alpha},\boldsymbol{\beta}$ 或粗斜拉丁字母 $\boldsymbol{x},\boldsymbol{y}$ 表示；基向量组 $(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)$ 是**有序**组——交换顺序视为另一组基（过渡矩阵随之改变）。

:::
