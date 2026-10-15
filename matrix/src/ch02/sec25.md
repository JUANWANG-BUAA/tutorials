# 2.5 正交变换与酉变换

第一章给内积空间装上了「长度与角度」；本节研究**把它们完整保下来**的线性变换。判据出乎意料地简单：只要保住**内积**这一个量，长度、角度、标准正交基便全部自动保住——这就是「四条等价刻画」定理，本节的主干（课堂用了整整半小时逐条证明，并两次停下来纠正展开过程中的共轭错误）。理论之后是两个「造正交矩阵的工厂」：**Givens 旋转**每次只动两个坐标分量，把向量的分量一个个清零；**Householder 反射**让整个向量照一次镜子，一步到位。它们都是后续 QR 分解与数值线性代数的地基。

<aside class="lesson-brief" aria-label="2.5 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>内积空间、共轭转置与 Gram（度量）矩阵（[@def-1.4.1]、[@def-1.4.4]、[@prop-1.4.2]）；长度与正交、标准正交基（[@def-1.5.1]、[@def-1.5.3]、[@def-1.5.4]）；正交补（[@def-1.6.6]）；平面旋转的矩阵（[@ex-2.3.1]）。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>正交矩阵与酉矩阵；正交 / 酉变换（保内积）与四条等价刻画及其完整证明；正交矩阵特征值的模必为 $1$（及「$\pm1$」的错误证明警示）；Givens 旋转矩阵 $T_{ij}(\varphi)$ 的构造与逐分量清零；Householder 矩阵 $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$ 的定义、几何含义与特征结构。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能把四条等价刻画当作闭环推导（而背诵）：保内积 → 保长度 → 标准正交基映为标准正交基 → 矩阵正交 → 保内积；能指出「正交矩阵特征值必为 $\pm1$」错在哪一步；能用 Givens 把 $(0,1,1)^{\mathrm T}$ 化为 $\sqrt2\,\boldsymbol{e}_1$ 并写对总变换的乘法顺序；能证明 $\det H=-1$。</p></div>
</aside>

::: note 素材与说明

本页依据**第 5 周星期 4 第 6,7 节录播**（2026-10-08，王振乾，1:39:09，第 5 周转录稿 00:32:33–01:36:01）整理。该讲官方课件尚未入库，本页**不沿用课件编号**，盒子自动编号；课堂口述标注时间戳。老师在本节多次给出**考试信号**：正交矩阵特征值问题（01:09:19 起）、Givens 矩阵「过去三四年没考过、但更早年份考过且容易变形」（01:14:16–01:14:54）、Householder 性质「在之前的考试中考过」（01:31:37）。
:::

<a id="sec-2.5.1"></a>

## 2.5.1 正交矩阵与酉矩阵

在讨论变换之前，先把矩阵这一侧的名字定下来：能完整保住内积的实方阵与复方阵，各有一个专门的称呼。

::: def 正交矩阵与酉矩阵 {#def-orth-matrix}

设 $A$ 是 $n$ 阶**实**方阵。若

$$A^{\mathrm T}A=I,$$

则称 $A$ 为**正交矩阵**。设 $A$ 是 $n$ 阶**复**方阵。若

$$A^{\mathrm H}A=I,$$

则称 $A$ 为**酉矩阵**（实矩阵的 $A^{\mathrm H}=A^{\mathrm T}$，故正交矩阵是酉矩阵的实特例）。
:::

$A^{\mathrm T}$ 是转置、$A^{\mathrm H}$ 是共轭转置（见符号表）。两类矩阵「有非常多的相似性」（00:15:25），差别只在实与复——往下凡是两类都有的性质，都并列写出这一对版本，实矩阵那一版把 $\mathrm H$ 换成 $\mathrm T$ 即可。

定义 $A^{\mathrm T}A=I$ 是个矩阵等式，看不出列向量受什么约束。第一个刻画就从这里下手——把乘积的 $(i,j)$ 元读出来，答案立刻显形：

::: thm 列向量刻画 {#thm-orth-columns}

设 $A\in\mathbb{R}^{n\times n}$，其列向量为 $\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n$。则

$$A\ \text{是正交矩阵}\iff \boldsymbol{a}_1,\cdots,\boldsymbol{a}_n\ \text{是}\ \mathbb{R}^n\ \text{的一组标准正交基}$$

（对行向量组同样成立；酉矩阵的刻画把「标准正交基」换成 $\mathbb{C}^n$ 中按 $A^{\mathrm H}A=I$ 的版本）。
:::

::: proof

$A^{\mathrm T}A$ 的 $(i,j)$ 元恰是 $(\boldsymbol{a}_i,\boldsymbol{a}_j)=\boldsymbol{a}_j^{\mathrm T}\boldsymbol{a}_i$。于是 $A^{\mathrm T}A=I$ 说的正是：各列长度为 $1$、两两正交。$n$ 个两两正交的非零向量自动线性无关（[@thm-1.5.2]），故是 $\mathbb{R}^n$ 的基。反过来，若各列已构成标准正交基，上面每个内积都取 $\delta_{ij}$，逐元读回去就得到 $A^{\mathrm T}A=I$。
:::

> 课堂原话（01:13:12–01:14:04）：「$A$ 的 $n$ 个列向量就构成了 $\mathbb{R}^n$ 的一组标准正交基……这是一个**当且仅当**的关系。」

把正交矩阵放在一起看，还要追问它们作为集合的整体结构：能不能相乘、能不能求逆、转置之后还是不是正交矩阵——这三问的答案就是下面的运算性质，也是后面比较两个「工厂」行列式的依据。

::: thm 正交 / 酉矩阵的运算性质 {#thm-orth-algebra}

设 $A,B$ 同为 $n$ 阶正交（酉）矩阵，则：

1. $A$ 可逆，且 $A^{-1}=A^{\mathrm T}$（酉：$A^{-1}=A^{\mathrm H}$）；
2. $AB$ 仍是正交（酉）矩阵；$A^{\mathrm T}$（酉：$A^{\mathrm H}$）与 $A^{-1}$ 亦然；
3. $\det A=\pm1$（酉：$|\det A|=1$）。
:::

::: proof

1. $A^{\mathrm T}A=I$ 直接给出可逆性与逆的形状；
2. $(AB)^{\mathrm T}(AB)=B^{\mathrm T}A^{\mathrm T}AB=B^{\mathrm T}B=I$，其余同理；
3. 取行列式：$\det(A^{\mathrm T}A)=(\det A)^2=1$，故 $\det A=\pm1$；酉情形 $|\det A|^2=1$，故模为 $1$。
:::

> 课堂逐条列出（01:10:04–01:10:29）：「行列式必为 $\pm1$」「特征值的模值为 $1$」「转置仍为正交」「乘积仍为正交」。

清单里「特征值的模值为 $1$」一条离「特征值一定是 $\pm1$」只有一步之遥，而后一句是**错的**——这正是本讲明确的考点（01:09:19 起）。正确命题与需要提防的错误证明如下：

::: thm 正交矩阵特征值的模 {#thm-orth-eig}

设 $A$ 是 $n$ 阶正交矩阵（酉矩阵同），$\lambda$ 是其任一特征值，则 $|\lambda|=1$。但 $\lambda$ 未必是实数，更未必是 $\pm1$；即使 $A$ 是实矩阵，也可能取到复特征值。
:::

::: proof

设 $A\boldsymbol{x}=\lambda\boldsymbol{x}$，$\boldsymbol{x}\neq\boldsymbol{0}$（列向量属于 $\mathbb{C}^n$）。用**共轭转置**计算长度：

$$\|A\boldsymbol{x}\|^2=(A\boldsymbol{x})^{\mathrm H}(A\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}A\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}\boldsymbol{x}=\|\boldsymbol{x}\|^2,$$

又 $\|A\boldsymbol{x}\|^2=\|\lambda\boldsymbol{x}\|^2=|\lambda|^2\|\boldsymbol{x}\|^2$。除以 $\|\boldsymbol{x}\|^2>0$ 得 $|\lambda|=1$。
:::

::: errata 错误证明警示（课堂原样演示）{#errata-orth-false}

**错误论证**：由 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 两边取转置得 $\boldsymbol{x}^{\mathrm T}A^{\mathrm T}=\lambda\boldsymbol{x}^{\mathrm T}$，两式相乘

$$\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x}=\lambda^2\boldsymbol{x}^{\mathrm T}\boldsymbol{x}\implies \boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\lambda^2\boldsymbol{x}^{\mathrm T}\boldsymbol{x}\implies \lambda^2=1\implies\lambda=\pm1 .$$

**错在哪**：$\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 对**复**向量不是正数——课堂上举的反例是 $\boldsymbol{x}=(1,i)^{\mathrm T}$，$\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=1+i^2=0$（01:12:00–01:12:18）——所以「两边约去 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$」不合法；而且 $\lambda^2=1$ 只在 $\lambda$ 为实数时才给出 $\lambda=\pm1$。**纪律**：在未确认特征值为实数之前，长度计算一律用共轭转置 $\boldsymbol{x}^{\mathrm H}\boldsymbol{x}$，不用转置（01:12:21–01:12:44）。实矩阵完全可以有复特征值，例如平面旋转 $\left[\begin{smallmatrix}0&-1\\1&0\end{smallmatrix}\right]$ 的特征值是 $\pm i$。
:::

::: note 实方阵不一定有 $n$ 个实特征值

老师在引入处特意打了问号（00:34:03–00:35:16）：「$n$ 阶实方阵，它不一定有 $n$ 个**实**特征值……即使是正交矩阵也不一定。」这也解释了实矩阵为什么能取到复特征值。这条事实在后续谱理论中会反复用到：在 $\mathbb{C}$ 里数特征值（计重数）永远是 $n$ 个，在 $\mathbb{R}$ 里则可能「缺货」。
:::

<a id="sec-2.5.2"></a>

## 2.5.2 正交变换与酉变换：四条等价刻画

上一小节的名字是给矩阵起的；回到抽象的线性变换，同样的性质需要一个「变换版」的定义。定义方式有得选——可以要求它保长度，也可以要求它在标准正交基下的矩阵正交——本节把定义押在「保内积」上，另外两条留作等价刻画，这正是下面主定理的形状：

::: def 正交变换与酉变换 {#def-orth-transform}

设 $V$ 是欧氏空间（实内积空间），$T\in L(V)$。若 $T$ **保持内积不变**：

$$(T\boldsymbol{x},T\boldsymbol{y})=(\boldsymbol{x},\boldsymbol{y}),\qquad\forall\,\boldsymbol{x},\boldsymbol{y}\in V,$$

则称 $T$ 为**正交变换**。酉空间（复内积空间）上保持内积的线性变换称为**酉变换**。
:::

老师强调这个定义「是以内积不变来定义的」（00:33:50），而**不是**用「保长度」或「矩阵正交」——那两条要留到等价刻画里去证明。还要先固定本教程的内积约定：对第一变元线性、对第二变元共轭线性（符号表）。下面从第二变元提出复数要取共轭，根子就在这一条。

::: thm 四条等价刻画 {#thm-orth-equiv}

设 $V$ 是 $n$ 维欧氏空间（酉空间同样，将 $\mathrm T$ 换成 $\mathrm H$），$T\in L(V)$。以下四条等价：

1. $T$ 是正交（酉）变换：$(T\boldsymbol{x},T\boldsymbol{y})=(\boldsymbol{x},\boldsymbol{y})$ 对一切 $\boldsymbol{x},\boldsymbol{y}$；
2. $T$ 保长度：$\|T\boldsymbol{x}\|=\|\boldsymbol{x}\|$ 对一切 $\boldsymbol{x}$；
3. $T$ 把任一组标准正交基映为标准正交基：若 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 是标准正交基，则 $T\boldsymbol{q}_1,\cdots,T\boldsymbol{q}_n$ 也是；
4. $T$ 在（任一组）标准正交基下的矩阵是正交（酉）矩阵。
:::

下面按 **1 → 2 → 3 → 4 → 3 → 1** 的环把四条全部证明（00:35:58–01:09:08）：最后一段先把 ④ 补回 ③，再由「④+③」一起回到 ①。老师强调「同学们一定要自己推一遍」（01:04:11）——这条链本身，就是本节最值得动笔的练习。

::: proof ①⟹②（00:36:04–00:37:00）

取 $\boldsymbol{y}=\boldsymbol{x}$：$\|T\boldsymbol{x}\|^2=(T\boldsymbol{x},T\boldsymbol{x})=(\boldsymbol{x},\boldsymbol{x})=\|\boldsymbol{x}\|^2$，开方即得。
:::

::: proof ②⟹③（00:37:04–00:56:19，极化技巧）

这一步要把「保长度」挤回「保内积」，难点在于长度只描述单个向量：单个向量的长度只给出「自己与自己」的信息，展开式里根本没有交叉项。技巧就是把两个基向量打包成 $\boldsymbol{q}_i+t\boldsymbol{q}_j$ 再比较长度，让交叉项露头。已知 $T$ 线性且保长度，对标准正交基中的两个向量 $\boldsymbol{q}_i,\boldsymbol{q}_j$ 与任意复数 $t$（$|t|=1$），考察 $T(\boldsymbol{q}_i+t\boldsymbol{q}_j)$ 的长度，按本教程约定展开（第一变元线性、第二变元共轭线性）：

$$\|T\boldsymbol{q}_i+tT\boldsymbol{q}_j\|^2=(T\boldsymbol{q}_i,T\boldsymbol{q}_i)+\bar t\,(T\boldsymbol{q}_i,T\boldsymbol{q}_j)+t\,\overline{(T\boldsymbol{q}_i,T\boldsymbol{q}_j)}+(T\boldsymbol{q}_j,T\boldsymbol{q}_j),$$

对 $\|\boldsymbol{q}_i+t\boldsymbol{q}_j\|^2$ 有完全相同的展开式。由②两端相等且 $|t|^2=t\bar t=1$，交叉项相等：

$$\bar t\,a+t\,\bar a=\bar t\,b+t\,\bar b,\qquad a\triangleq(T\boldsymbol{q}_i,T\boldsymbol{q}_j),\ b\triangleq(\boldsymbol{q}_i,\boldsymbol{q}_j).$$

取 $t=1$ 得 $a+\bar a=b+\bar b$（实部相等）；取 $t=i$ 得 $-ia+i\bar a=-ib+i\bar b$（虚部相等）。二者合成 $a=b$，即

$$(T\boldsymbol{q}_i,T\boldsymbol{q}_j)=(\boldsymbol{q}_i,\boldsymbol{q}_j)=\delta_{ij}.$$

（欧氏空间取 $t=\pm1$ 就够；酉空间必须再取 $t=i$，才能把虚部也定下来，这正是复内积的「极化」。它的一般形式——由范数反解出内积的**极化恒等式**——见[附录 A.1](../appendix/appendix-a.md#sec-A.1)。）于是 $T\boldsymbol{q}_1,\cdots,T\boldsymbol{q}_n$ 两两正交、长度为 $1$；由 [@thm-1.5.2] 它们线性无关，故是标准正交基。
:::

::: errata 展开时的共轭陷阱（课堂两度停下强调）{#errata-conj-pitfall}

- 从**第二变元**提出复数必须取**共轭**：$(T\boldsymbol{q}_1,\,i\,T\boldsymbol{q}_2)=-i\,(T\boldsymbol{q}_1,T\boldsymbol{q}_2)$，**不是** $i\,(T\boldsymbol{q}_1,T\boldsymbol{q}_2)$。课堂演示了「绝对错误的简写」（00:42:47–00:44:08）：若把 $i$ 直接提出去，会得出 $(i\,T\boldsymbol{q}_2,\,i\,T\boldsymbol{q}_2)=i^2\|T\boldsymbol{q}_2\|^2=-\|T\boldsymbol{q}_2\|^2$ 的荒谬结论；正确的是 $(i\,\boldsymbol{x},i\,\boldsymbol{x})=i\bar i\,(\boldsymbol{x},\boldsymbol{x})=(\boldsymbol{x},\boldsymbol{x})$。
- 从线性变换或线性组合中提出复数则**不**取共轭：$T(i\boldsymbol{x})=i\,T(\boldsymbol{x})$。老师用一句话总结：「共轭只在过内积的时候发生」（00:52:53–00:53:43）。
:::

::: proof ③⟹④（00:56:43–01:01:00）

③ 说的是基像的性质，要把它翻译成关于矩阵 $A$ 的陈述，得先把内积用坐标写出来。设 $T$ 在标准正交基 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 下的矩阵为 $A$：$(T\boldsymbol{q}_1,\cdots,T\boldsymbol{q}_n)=(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)A$，$A$ 的第 $i$ 列 $\boldsymbol{a}_i$ 是 $T\boldsymbol{q}_i$ 的坐标。由坐标计算内积的 Gram 公式（[@def-1.4.4]、[@prop-1.4.2]）：

$$(T\boldsymbol{q}_i,T\boldsymbol{q}_j)=\boldsymbol{a}_j^{\mathrm T}G(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)\,\boldsymbol{a}_i .$$

标准正交基的 Gram 矩阵是单位阵（[@def-1.5.4] 注 6），故 $(T\boldsymbol{q}_i,T\boldsymbol{q}_j)=\boldsymbol{a}_j^{\mathrm T}\boldsymbol{a}_i$。由③，左边 $=\delta_{ij}$，于是 $A$ 的各列标准正交，$A^{\mathrm T}A=I$（[@thm-orth-columns]）。
:::

::: proof ④⟹③，再（④+③）⟹①（01:01:16–01:09:08）

**④⟹③**：设标准正交基 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 下 $T$ 的矩阵 $A$ 正交。同上，$(T\boldsymbol{q}_i,T\boldsymbol{q}_j)=\boldsymbol{a}_j^{\mathrm T}\boldsymbol{a}_i=\delta_{ij}$（正交矩阵的列标准正交），故 $T\boldsymbol{q}_1,\cdots,T\boldsymbol{q}_n$ 是标准正交基——③成立。

**（④+③）⟹①**：任取 $\boldsymbol{x}=\sum_i\alpha_i\boldsymbol{q}_i$，$\boldsymbol{y}=\sum_j\beta_j\boldsymbol{q}_j$。由 $T$ 线性，

$$T\boldsymbol{x}=\sum_i\alpha_i\,T\boldsymbol{q}_i,\qquad T\boldsymbol{y}=\sum_j\beta_j\,T\boldsymbol{q}_j .$$

以标准正交基 $T\boldsymbol{q}_1,\cdots,T\boldsymbol{q}_n$ 展开内积——正交性使交叉项全部消失（课堂把这一步称作「看上去很复杂，但其实非常简单」，01:06:03）：

$$(T\boldsymbol{x},T\boldsymbol{y})=\sum_{i,j}\alpha_i\bar\beta_j\,(T\boldsymbol{q}_i,T\boldsymbol{q}_j)=\sum_i\alpha_i\bar\beta_i .$$

同样 $(\boldsymbol{x},\boldsymbol{y})=\sum_i\alpha_i\bar\beta_i$。二者相等，①成立。
:::

::: method 怎么用这四条 {#method-orth-usage}

四条等价意味着题目可以从任一入口切进去，选对入口才省力：

- **验证某变换正交**：通常验「把一组标准正交基映为标准正交基」（③）最快；
- **由矩阵反推性质**：写出标准正交基下的矩阵，查 $A^{\mathrm T}A$（④）；
- **保长度 / 保内积**的题目（①②）：记住「保长度 + 线性 ⟹ 保内积」这条通道，不必直接硬算内积；
- 四条里**任何一条**都可以当定义用，考题常在等价链上「抽一段」让你补证明（00:36:02「几条命题等价」）。
:::

<a id="sec-2.5.3"></a>

## 2.5.3 Givens 旋转矩阵：每次只转一个平面

[例 2.3.1]（[@ex-2.3.1]）的平面旋转 $T(\boldsymbol{x})=\left[\begin{smallmatrix}\cos\varphi&-\sin\varphi\\ \sin\varphi&\cos\varphi\end{smallmatrix}\right]\boldsymbol{x}$ 是正交变换的「最小样本」——两个坐标，一个平面。把它**嵌入** $n$ 维空间：只在一个坐标平面里转动，其余坐标原样不动，就得到 Givens 矩阵（课堂正是从例 2.3.1 出发「把这个表达式进行扩充」，01:14:56–01:15:48）。

::: def Givens 旋转矩阵 {#def-givens}

设 $1\le i<j\le n$，$\varphi\in\mathbb{R}$。称 $n$ 阶矩阵

$$T_{ij}(\varphi)=\begin{bmatrix}
1&&&&&\\
&\ddots&&&&\\
&&\cos\varphi&&-\sin\varphi&\\
&&&\ddots&&\\
&&\sin\varphi&&\cos\varphi&\\
&&&&&\ddots\\
&&&&&&1
\end{bmatrix}\begin{matrix}\\\\\leftarrow i\\\\\leftarrow j\\\\\\\end{matrix}$$

为 **Givens（旋转）矩阵**：它等于单位阵，仅在 $(i,i),(j,j)$ 位置为 $\cos\varphi$，$(i,j)$ 位置为 $-\sin\varphi$、$(j,i)$ 位置为 $\sin\varphi$。
:::

要把 Givens 矩阵当「砖」垒进算法，先得确认它确实是正交矩阵，再看它对一个向量做了什么：

::: thm Givens 矩阵的性质 {#thm-givens-props}

1. $T_{ij}(\varphi)$ 是正交矩阵；
2. $T_{ij}(\varphi)^{\mathrm T}=T_{ij}(\varphi)^{-1}=T_{ij}(-\varphi)$；
3. 左乘列向量时**只改变第 $i$、$j$ 个分量**，其余分量不动：

$$(T_{ij}\boldsymbol{x})_i=\cos\varphi\,x_i-\sin\varphi\,x_j,\qquad (T_{ij}\boldsymbol{x})_j=\sin\varphi\,x_i+\cos\varphi\,x_j .$$
:::

::: proof

1. 二阶主块 $\left[\begin{smallmatrix}c&-s\\s&c\end{smallmatrix}\right]$（$c^2+s^2=1$）的两列标准正交，其余列是单位坐标向量，由 [@thm-orth-columns] 得正交（课堂：「很容易进行乘法验证」01:17:39–01:18:11）；
2. 转置把两个 $\sin$ 变号，即 $T_{ij}(-\varphi)$；结合 1 得逆；
3. 逐行乘开即得（「它改变的只是第 $i$ 行和第 $j$ 行的元素，其他元素一点都没有变化」01:17:18–01:17:32）。
:::

**用途只有一条：选好角度，把第 $j$ 个分量转到零。**

::: thm 分量清零 {#thm-givens-zero}

设 $\boldsymbol{x}\in\mathbb{R}^n$，$(x_i,x_j)\neq(0,0)$，记 $r=\sqrt{x_i^2+x_j^2}$。取

$$\cos\varphi=\frac{x_i}{r},\qquad \sin\varphi=-\frac{x_j}{r},$$

则 $(T_{ij}(\varphi)\boldsymbol{x})_i=r=\sqrt{x_i^2+x_j^2}$，$(T_{ij}(\varphi)\boldsymbol{x})_j=0$，其余分量不变。
:::

::: proof

代入性质 3：$(T_{ij}\boldsymbol{x})_j=\dfrac{-x_j}{r}x_i+\dfrac{x_i}{r}x_j=0$；$(T_{ij}\boldsymbol{x})_i=\dfrac{x_i^2+x_j^2}{r}=r$。
:::

> 课堂给的取法（01:18:47–01:19:16）就是 $\cos\varphi=\dfrac{x_i}{\sqrt{x_i^2+x_j^2}}$，$\sin$ 的符号按「清零第 $j$ 个分量」配出来。老师提醒这个 $\varphi$ 的取法**可以换**：目的只有一个——把 $j$ 分量清零、把能量合并到 $i$ 分量。

::: ex 例 · 两步把 $(0,1,1)^{\mathrm T}$ 化为 $\sqrt2\,\boldsymbol{e}_1$（课堂原例）{#ex-givens-demo}

课堂演算见 01:22:03–01:24:16。设 $\boldsymbol{x}=(0,1,1)^{\mathrm T}$。

**第一步清 $x_2$**（$i=1,j=2$）：$r=\sqrt{0^2+1^2}=1$，$\cos\varphi=0$，$\sin\varphi=-1$，

$$T_{12}=\begin{bmatrix}0&1&0\\-1&0&0\\0&0&1\end{bmatrix},\qquad T_{12}\boldsymbol{x}=(1,0,1)^{\mathrm T}.$$

**第二步清 $x_3$**（$i=1,j=3$，**用更新后的向量** $(1,0,1)$）：$r=\sqrt{1+1}=\sqrt2$，$\cos\varphi=\dfrac{1}{\sqrt2}$，$\sin\varphi=-\dfrac{1}{\sqrt2}$，

$$T_{13}=\begin{bmatrix}\tfrac{1}{\sqrt2}&0&\tfrac{1}{\sqrt2}\\0&1&0\\-\tfrac{1}{\sqrt2}&0&\tfrac{1}{\sqrt2}\end{bmatrix},\qquad T_{13}(T_{12}\boldsymbol{x})=(\sqrt2,0,0)^{\mathrm T}=\sqrt2\,\boldsymbol{e}_1=\|\boldsymbol{x}\|\,\boldsymbol{e}_1 .$$
:::

::: method 用 Givens 把任意向量对准 $\boldsymbol{e}_1$ {#method-givens-align}

对任意 $\boldsymbol{x}\in\mathbb{R}^n$，依次用 $n-1$ 个 Givens 矩阵（每次以**最新**的向量为原料，01:25:39–01:26:27 的易错点）：

$$T_{1n}\cdots T_{13}T_{12}\,\boldsymbol{x}=\|\boldsymbol{x}\|\,\boldsymbol{e}_1,$$

效果等价于「把每个分量的平方依次合并进第 1 分量」。**写总变换时按作用顺序反写**：先作用的 $T_{12}$ 排最右，「先写最后变换，再写最初变换」（01:26:35–01:26:55）——顺序写反是本题最容易犯的错误。
:::

::: note 考情（课堂原话，01:14:16–01:14:54）

Givens 矩阵「在过去三四年从来没考过」，但更早的年份（四五年前、五六年前）是难题里的重要考点；成为公共课后老师判断「今年不会考」，仍建议「复习的时候好好复习一下——它不难，但很容易把题目变形」。变形点通常落在三处：清零分量的次序、$\sin$ 的符号、总变换的乘法顺序。
:::

<a id="sec-2.5.4"></a>

## 2.5.4 Householder 矩阵：一次镜像

Givens 每次只动两个分量，要把向量对准 $\boldsymbol{e}_1$ 得走 $n-1$ 步；Householder 换了一条更快的路——让整个向量关于一张超平面照一次镜子，一步完成。

::: def Householder 矩阵 {#def-householder}

设 $\boldsymbol{\omega}\in\mathbb{R}^n$ 是单位列向量（$\|\boldsymbol{\omega}\|=1$）。称

$$H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$$

为 **Householder 矩阵**（初等反射矩阵）。酉空间版本取 $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm H}$。
:::

::: note 几何含义：关于超平面的镜像（课堂图示，01:27:56–01:31:31）

把 $\boldsymbol{x}$ 分解为「沿 $\boldsymbol{\omega}$ 的分量 + 垂直分量」（正交补记号见 [@def-1.6.6]）：$\boldsymbol{x}=\underbrace{(\boldsymbol{x})_{\parallel}}_{\in\operatorname{span}(\boldsymbol{\omega})}+\underbrace{(\boldsymbol{x})_{\perp}}_{\in\boldsymbol{\omega}^{\perp}}$。则

$$H\boldsymbol{x}=(\boldsymbol{x})_{\perp}-(\boldsymbol{x})_{\parallel},$$

即 $\boldsymbol{x}$ 关于超平面 $\boldsymbol{\omega}^{\perp}$ 的**镜像**（反射）——「注意不是投影，是镜像」（01:29:00）。像与原像长度相同、与镜面夹角相同，分居镜面两侧。课堂给出的图算思路（01:30:37–01:31:31）：把 $\boldsymbol{x}$ 沿 $\boldsymbol{\omega}$ 方向的投影取反记为 $\boldsymbol{p}$，则 $\boldsymbol{x}+2\boldsymbol{p}$ 正是镜像。
:::

::: thm Householder 矩阵的性质 {#thm-householder-props}

老师特别提醒：这一组性质「就在咱们之前的考试中考过」（01:31:34–01:31:50）。设 $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$，$\|\boldsymbol{\omega}\|=1$。则：

1. $H^{\mathrm T}=H$（对称）；
2. $H^2=I$，从而 $H^{-1}=H$（自逆）；
3. $H$ 是正交矩阵：$H^{\mathrm T}H=I$；
4. $H\boldsymbol{\omega}=-\boldsymbol{\omega}$：$\boldsymbol{\omega}$ 是属于特征值 $-1$ 的特征向量；
5. 凡与 $\boldsymbol{\omega}$ 正交的向量都是属于特征值 $1$ 的特征向量，且 $\boldsymbol{\omega}^{\perp}$ 中能取到 $n-1$ 个这样的线性无关向量；
6. $\det H=-1$。
:::

::: proof

1. 由定义直接读出；
2. $H^2=(I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})^2=I-4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}+4\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega})\boldsymbol{\omega}^{\mathrm T}=I$，用到 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega}=\|\boldsymbol{\omega}\|^2=1$；
3. 由 1、2 立得；
4. $H\boldsymbol{\omega}=\boldsymbol{\omega}-2\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega})=-\boldsymbol{\omega}$（课堂 01:32:42–01:33:25 的核心计算：「$\boldsymbol{\omega}$ 是单位向量，后面这项就是一个数 $1$，直接删掉」）；
5. 若 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{v}=0$，则 $H\boldsymbol{v}=\boldsymbol{v}-2\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{v})=\boldsymbol{v}$。$\dim\boldsymbol{\omega}^{\perp}=n-1$，取它的一组基即为 $n-1$ 个线性无关的特征向量（课堂 01:33:36–01:34:39：「必然能找到 $n-1$ 个和它垂直的线性无关向量」）；
6. 特征值之积：$(-1)\cdot\underbrace{1\cdots1}_{n-1}=-1$（课堂 01:35:30–01:35:44：「所以它的行列式是 $-1$」）。
:::

::: think 与 Givens 对比（通往 QR 的两块砖）

1. Givens 是「转」，$\det=+1$；Householder 是「照镜子」，$\det=-1$。两者都是正交矩阵，行列式为何必然差一个符号？（用 [@thm-orth-algebra] 与本定理 6。）
2. 想用**一个** Householder 把 $\boldsymbol{x}$ 映成 $\|\boldsymbol{x}\|\boldsymbol{e}_1$，镜面应取「$\boldsymbol{x}$ 与目标方向的角平分面」：取 $\boldsymbol{\omega}$ 为 $\boldsymbol{x}-\|\boldsymbol{x}\|\boldsymbol{e}_1$ 方向的单位向量即可。写出验证过程——这正是数值代数 QR 分解的标准一步（本讲到此收尾，未及展开）。
3. $-1$ 是 $H$ 的几重特征值？几何重数与代数重数在此相等吗？（对照 [2.4.3](sec24.md#sec-2.4.3) 的两种重数。）
:::

## 2.5 小结与常见错误

::: note 一句话收束

**保内积的线性变换就是正交（酉）变换**；它等价于保长度、等价于「把标准正交基映为标准正交基」、等价于「标准正交基下矩阵正交（酉）」。造正交矩阵的两个工厂：**Givens** $T_{ij}$ 在一个坐标平面里转、清零一个分量；**Householder** $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$ 关于一个超平面照镜子，$\det H=-1$。
:::

下面这张表把本节最容易失分的地方集中起来，每一条都能在前文找到出处：第一行是老师点名的考点，第二、三行关乎复内积的展开纪律，后三行则是两个「工厂」的使用要点。

| 常见错误 | 正确做法 |
|:--|:--|
| 「正交矩阵特征值必为 $\pm1$」 | 只有 $\|\lambda\|=1$ 可保证；复特征值可出现（[警示](#errata-orth-false)），根子在 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 可为 $0$ |
| 复内积展开时从第二变元裸提 $i$ | 第二变元提复数取**共轭**（[陷阱](#errata-conj-pitfall)）；从线性变换里提则不共轭 |
| 证明②⟹③只用 $\boldsymbol{q}_i+\boldsymbol{q}_j$ | 酉空间还须用 $\boldsymbol{q}_i+i\boldsymbol{q}_j$ 才能把虚部钉死（极化） |
| Givens 连乘时顺序写正 | 总变换按作用顺序**反**写：先作用的在右侧（[方法](#method-givens-align)） |
| 第二个 Givens 仍用原始向量取角 | 每步用**更新后**的向量取 $\cos\varphi,\sin\varphi$ |
| 认为 Householder 是投影 | 它是**镜像**（反射）：$\det=-1$、$H^2=I$；投影则 $\det$ 无此约束且幂等不对称不保长度 |

::: ex 即时自测（不看上文，5 分钟）{#ex-2.5.quiz}

1. 写出「$T$ 是正交变换」的定义，并说出它等价的三条刻画。
2. $U$ 是酉矩阵。$|\lambda|=1$ 对 $U$ 的**每个**特征值都成立吗？$U$ 的特征值一定是实数吗？
3. **判断：**实正交矩阵的特征值只能是 $\pm1$。
4. Givens 旋转 $T_{ij}$ 与 Householder 反射 $H$：哪个的行列式是 $+1$？两者各把什么向量映到什么方向？

::: sol 参考要点

1. 对一切 $\boldsymbol{x},\boldsymbol{y}$ 有 $(T\boldsymbol{x},T\boldsymbol{y})=(\boldsymbol{x},\boldsymbol{y})$（[定义](#def-orth-transform)）。等价刻画：① 保长度 $\|T\boldsymbol{x}\|=\|\boldsymbol{x}\|$；② 把标准正交基映为标准正交基；③ 在标准正交基下的矩阵是正交（酉）矩阵 $A^{\mathrm H}A=I$（[@thm-orth-equiv]）。
2. 成立：由 $U\boldsymbol{x}=\lambda\boldsymbol{x}$（$\boldsymbol{x}\neq\boldsymbol{\theta}$）得 $\|\boldsymbol{x}\|=\|U\boldsymbol{x}\|=\|\lambda\boldsymbol{x}\|=|\lambda|\,\|\boldsymbol{x}\|$，故 $|\lambda|=1$。但**不一定**是实数——复特征值完全可能（如旋转矩阵在 $\mathbb R$ 上无实特征值，在 $\mathbb C$ 上特征值为 $e^{\pm i\varphi}$）。
3. **错。**只有实特征值才必为 $\pm1$；复特征值只保证模为 $1$，例如平面旋转 $\begin{pmatrix}\cos\varphi&-\sin\varphi\\ \sin\varphi&\cos\varphi\end{pmatrix}$ 的特征值是 $e^{\pm i\varphi}$。这正是[常见错误表](#errata-orth-false)里那条警示。
4. $\det T_{ij}=+1$（旋转），$\det H=-1$（镜像）。Givens 在坐标平面 $(i,j)$ 内旋转，用来**清零一个分量**；Householder 关于超平面 $\boldsymbol{\omega}^{\perp}$ 作镜像，把 $\boldsymbol{x}$ 映成 $\|\boldsymbol{x}\|\boldsymbol{e}_1$（取 $\boldsymbol{\omega}$ 为 $\boldsymbol{x}-\|\boldsymbol{x}\|\boldsymbol{e}_1$ 方向的单位向量）。
:::
:::
