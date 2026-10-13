# 闭卷回忆卡：定义、定理与第一行

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

> **背不下来？先看[速查背记卡](../memory-sheet.md)。** 那一页把每个定义、定理压成一句「最小可背诵单元」；这一页负责检验你有没有真的记住。两页配合使用：先在速查卡把钩子记住，再来这里从空白纸上叫出来。

::: note 想做成间隔复习
本页每张卡可以导出成 Anki 卡组——命令与导入步骤见[速查背记卡](../memory-sheet.md)文末「导出到 Anki」。
:::

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记录三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 定义卡

### D1 · 数域

不看书写出：数集要具备哪些封闭性才是本章所说的数域？为什么必须排除除数为零？

::: sol D1 核对

非空数集 $F$ 含 $0,1$，并对任意两个元素的加、减、乘、除封闭，其中除法的除数必须非零。触发反例：$\mathbb Z$ 对除法不封闭。易漏条件：$0,1\in F$。
:::

### D2 · 线性空间

不逐字背诵，先写结构：线性空间由什么集合、什么数域、哪两种运算组成？八条公理分成哪两组？

::: sol D2 核对

$V$ 是非空集合，$F$ 是数域；$V$ 上有加法，$F\times V$ 上有数乘。加法四条：交换、结合、零元、负元；数乘四条：对向量加法分配、对标量加法分配、数乘结合、单位律 $1\boldsymbol x=\boldsymbol x$。第一行抓手：**加法成交换群，数乘与两种加法相容。**
:::

### D3 · 子空间

$W$ 成为 $V$ 的子空间，定义中最容易漏掉的两个前提是什么？

::: sol D3 核对

先有 $W\subseteq V$ 且 $W$ 非空；运算必须继承自 $V$，不能另行定义。随后 $W$ 在这些运算下也构成同一数域 $F$ 上的线性空间。
:::

### D4 · 线性相关与无关

写出零组合，并分别说明「无关」和「相关」对系数解有什么要求。

::: sol D4 核对

对 $\sum_{i=1}^n k_i\boldsymbol\alpha_i=\boldsymbol{\theta}$：只有 $k_1=\cdots=k_n=0$ 这一平凡解时无关；存在一组不全为零的系数时相关。易错点：不是看和是否为零，而是看使它为零的系数是否只有零解。
:::

### D5 · 基、坐标与维数

用三个短句分别说清这三个概念，并说明它们的依赖顺序。

::: sol D5 核对

基是**线性无关且张成全空间**的有序向量组；坐标是向量在指定基下的唯一表示系数；维数是任一基所含向量的个数。依赖链：无关 + 张成 → 基 → 唯一系数 → 坐标；基的个数不变 → 维数良定义。
:::

### D6 · 过渡矩阵

若「新基 = 旧基 × $P$」，$P$ 的第 $j$ 列是什么？新旧坐标满足什么关系？

::: sol D6 核对

$P$ 的第 $j$ 列是第 $j$ 个新基向量在旧基下的坐标。若旧坐标为 $\boldsymbol\alpha$、新坐标为 $\boldsymbol\beta$，则 $\boldsymbol\alpha=P\boldsymbol\beta$，所以 $\boldsymbol\beta=P^{-1}\boldsymbol\alpha$。口诀：**新基贴旧基，旧坐标等于 $P$ 乘新坐标。**
:::

### D7 · 内积

在本教程「第一变元线性」的约定下，写出四条公理，并说出第二变元数乘时系数怎样出来。

::: sol D7 核对

共轭对称、第一变元可加、第一变元齐次、正定。由前两类性质可推出第二变元共轭线性：$(\boldsymbol x,k\boldsymbol y)=\overline{k}(\boldsymbol x,\boldsymbol y)$。易错点：复空间不能把 $\mathrm H$ 写成 $\mathrm T$。
:::

### D8 · 长度、正交与标准正交基

写出长度和正交的定义；「正交基」与「标准正交基」差在哪里？

::: sol D8 核对

$\|\boldsymbol x\|=\sqrt{(\boldsymbol x,\boldsymbol x)}$；$(\boldsymbol x,\boldsymbol y)=0$ 时正交。正交基由两两正交的非零基向量组成；标准正交基还要求每个基向量长度为 $1$，等价于 Gram 矩阵为 $I$。
:::

### D9 · 直和与投影

普通和与直和差在哪一个词？投影为什么必须说明补空间？

::: sol D9 核对

直和要求每个向量的分解**唯一**。若 $V=W_1\dotplus W_2$ 且 $\boldsymbol x=\boldsymbol y+\boldsymbol z$，其中 $\boldsymbol y\in W_1$、$\boldsymbol z\in W_2$，则 $\boldsymbol y$ 是沿 $W_2$ 到 $W_1$ 的投影。换补空间会改变分解，所以只说「投到 $W_1$」信息不足。
:::

### D10 · 正交补

不看书写出 $W^{\perp}$ 的定义。它一定是子空间吗？$V$、$W$、$W^{\perp}$ 三者的维数关系是什么？

::: sol D10 核对

$W^{\perp}=\{\boldsymbol x\in V\mid\boldsymbol x\perp W\}$，即与 $W$ 中**每个**向量都正交的向量全体。它是 $V$ 的子空间（零向量在内；对第一变元线性封闭）。由正交分解定理 $V=W\oplus W^{\perp}$，故 $\dim W+\dim W^{\perp}=\dim V$；顺带 $(W^{\perp})^{\perp}=W$。检验 $W\perp W_2$ 只需查**基对基**。
:::

### D11 · 正交投影

正交投影与一般投影差在哪？为什么谈正交投影时**不必**再说补空间？

::: sol D11 核对

正交投影 = 沿**正交补** $W^{\perp}$ 落下的投影。有限维中，正交直和分解 $V=W\oplus W_2$ 里的 $W_2$ 必等于 $W^{\perp}$（包含 + 等维），所以「在 $W$ 上的正交投影」由 $W$ 与内积唯一确定。它还是 $W$ 中离原向量**最近**的点（最佳逼近）。
:::

## B. 定理卡

### T1 · 子空间判定定理

写出最常用的一行版本。证明「是子空间」的第一行怎么写？

::: sol T1 核对

对非空子集 $W\subseteq V$，若任意 $\boldsymbol x,\boldsymbol y\in W$、$a,b\in F$ 都有 $a\boldsymbol x+b\boldsymbol y\in W$，则且仅则 $W$ 是子空间。第一行：「先确认 $W\subseteq V$ 且 $\boldsymbol{\theta}\in W$；任取……」
:::

### T2 · 唯一表示定理

「一组无关向量加入 $\boldsymbol\beta$ 后相关」说明什么？存在性与唯一性各靠哪个条件？

::: sol T2 核对

$\boldsymbol\beta$ 可由原无关组唯一表示。存在性靠加入后相关，且相关式中 $\boldsymbol\beta$ 的系数不能为零；唯一性靠原向量组无关。证明唯一的第一行：「假设 $\boldsymbol\beta$ 有两种表示并相减。」
:::

### T3 · 基的个数不变与计数引理

$n$ 个基向量能容纳多少个线性无关向量？两组基的个数为何相同？

::: sol T3 核对

由 $n$ 个向量组成的基所在空间中，任意多于 $n$ 个的向量组必相关。若两组基分别含 $m,n$ 个向量，先把 $m$ 个向量用另一组 $n$ 个基向量表示，得 $m\le n$；交换角色得 $n\le m$，所以 $m=n$。
:::

### T4 · 维数公式

完整写出公式，并说明为什么要减去交空间的维数。

::: sol T4 核对

$$\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2).$$
分别数 $W_1,W_2$ 时，公共方向被数了两次，因此减去一次。证明入口：先取交空间的基，再分别扩充为 $W_1,W_2$ 的基。
:::

### T5 · Gram 矩阵换基

由旧基到新基的过渡矩阵为 $P$ 时，新 Gram 矩阵是什么？为什么左右各有一个矩阵？

::: sol T5 核对

$G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P$。内积有两个输入；坐标变换 $\boldsymbol\xi=P\boldsymbol\alpha$ 在第一、第二变元各出现一次，第二侧因共轭线性产生 $P^{\mathrm H}$。
:::

### T6 · Cauchy–Schwarz

写出带模的不等式、等号条件和证明构造。

::: sol T6 核对

$$|(\boldsymbol x,\boldsymbol y)|\le\|\boldsymbol x\|\,\|\boldsymbol y\|,$$
等号当且仅当 $\boldsymbol x,\boldsymbol y$ 线性相关，实、复空间都成立。证明构造：$0\le\|\boldsymbol x-\lambda\boldsymbol y\|^2$，取 $\lambda=(\boldsymbol x,\boldsymbol y)/(\boldsymbol y,\boldsymbol y)$ 使残差与 $\boldsymbol y$ 正交。
:::

### T7 · 正交组线性无关

证明的第一行和消去某个系数的动作分别是什么？

::: sol T7 核对

先设 $\sum_i c_i\boldsymbol x_i=\boldsymbol{\theta}$。两边与 $\boldsymbol x_j$ 作内积，其他项因正交全部为零，得到 $c_j(\boldsymbol x_j,\boldsymbol x_j)=0$；因 $\boldsymbol x_j\ne\boldsymbol{\theta}$，其长度平方为正，所以 $c_j=0$。
:::

### T8 · 直和判定定理

写出四个等价说法，并指出具体子空间题优先用哪个。

::: sol T8 核对

直和；零向量表法唯一；$W_1\cap W_2=\{\boldsymbol{\theta}\}$；$\dim(W_1+W_2)=\dim W_1+\dim W_2$。给出具体子空间时优先求交；只给维数或秩时用维数式；证明唯一时把两种表示相减。
:::

### T9 · 幂等矩阵的分解

$A^2=A$ 会自动给出哪一个直和？任意向量怎样拆？

::: sol T9 核对

$$\mathbb C^n=R(A)\dotplus N(A)=R(A)\dotplus R(I-A).$$
任意 $\boldsymbol x$ 按 $\boldsymbol x=A\boldsymbol x+(I-A)\boldsymbol x$ 拆分；第一项在 $R(A)$，第二项被 $A$ 映为零，故在 $N(A)$。第一行抓手就是恒等式 $I=A+(I-A)$。
:::

### T10 · 正交 ⟹ 直和

证明的第一行是什么？为什么只有一行？

::: sol T10 核对

设 $\boldsymbol u\in W_1\cap W_2$，把 $\boldsymbol u$ 同时当作两边的向量，则 $(\boldsymbol u,\boldsymbol u)=0$，正定性逼出 $\boldsymbol u=\boldsymbol{\theta}$——交为零，判据 (3) 收尾。正交性把「查交」整个免掉；代价是必须先有内积（子空间正交离开内积无定义）。
:::

### T11 · 正交基投影公式

写出一般正交基与标准正交基两个版本。公式什么时候**失效**？

::: sol T11 核对

$$\operatorname{Proj}_{W}\boldsymbol y=\sum_i\frac{(\boldsymbol y,\boldsymbol x_i)}{(\boldsymbol x_i,\boldsymbol x_i)}\boldsymbol x_i;\qquad\text{标准正交基： }\operatorname{Proj}_{W}\boldsymbol y=\sum_i(\boldsymbol y,\boldsymbol x_i)\boldsymbol x_i.$$
证明入口：构造 $\boldsymbol w$，验证残差与**每个基向量**正交（正交性消掉交叉项），再用拆解唯一性认定。**只对正交基成立**——基不正交时须先 Gram–Schmidt 或解 Gram 方程组（勘误 E12）。矩阵形式：$P=ZZ^{\mathrm H}$（$Z$ 的列是标准正交基），幂等 + Hermite。
:::

### T12 · $\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$

三步证明骨架是什么？哪一步用了「包含 + 等维」？

::: sol T12 核对

① $R(A^{\mathrm H})\perp N(A)$：$\boldsymbol x^{\mathrm H}A^{\mathrm H}\boldsymbol u=(A\boldsymbol x)^{\mathrm H}\boldsymbol u=0$；② $\operatorname{rank}A^{\mathrm H}=\operatorname{rank}A$（转置换行列表、共轭保相关性）；③ $\dim N(A)+\dim R(A^{\mathrm H})=n$，判据 (4) 得直和。「包含 + 等维」用在升级为 $R(A^{\mathrm H})=(N(A))^{\perp}$：已有 $R(A^{\mathrm H})\subseteq(N(A))^{\perp}$，两边维数都是 $\operatorname{rank}A$，相等。对偶版本 $\mathbb C^n=N(A^{\mathrm H})\oplus R(A)$ 合称四个基本子空间。
:::

## C. 一张白纸的最终测试

在白纸中央写「线性空间」，不看书画出下面这条链，并在每条箭头上写出连接理由：

$$
\text{线性空间}
\longrightarrow \text{子空间}
\longrightarrow \text{基与坐标}
\longrightarrow \text{内积}
\longrightarrow \text{正交化}
\longrightarrow \text{直和与投影}
\longrightarrow \text{正交补与正交投影}.
$$

然后默写 T1、T4、T6、T8、T11 五条定理。它们分别负责本章最常见的五类动作：**判定、计数、估计、分解、投影**。若能写出条件、结论和证明第一行，本章知识已经从「看过」变成「可以调用」。

