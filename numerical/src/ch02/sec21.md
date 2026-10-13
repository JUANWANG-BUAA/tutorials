# 2.1 内积、正交性与正交矩阵

第一章把「向量有多长」公理化为范数，但长度不是几何的全部：要谈角度与「垂直」，还需要一个能同时给出长度与角度的装置——**内积**。有了内积才有正交、标准正交基，把它们按列排成方阵就得到**正交矩阵**：「不改变长度与角度的坐标变换」，也是 QR 分解、SVD 与全部稳定算法的基石。本节三步：内积公理化（2.1.1）；正交与标准正交基（2.1.2）；刻画正交矩阵（2.1.3）。

<aside class="lesson-brief" aria-label="2.1 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>第一章的范数三公理与 Cauchy–Schwarz（1.3.1）；线性相关、基与维数；矩阵乘法与转置。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>内积四条公理与内积诱导的范数；正交、标准正交基、正交矩阵的定义与等价刻画；「正交 ⇔ 保长度保角度」这条核心直觉。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能验证一个候选函数是否为内积；能判断一个方阵是否正交并说出至少六条等价条件；能解释为什么正交变换在数值计算里「不放大误差」。</p></div>
</aside>

<a id="sec-2.1.1"></a>

## 2.1.1 内积的公理化

在 $\mathbb{R}^n$ 里，我们早就会算 $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=\sum_ix_iy_i$，并用它定义长度与夹角。但数值计算中有时需要**别的**内积：加权最小二乘要给不同观测不同的权重，有限元要在函数空间里做同一套几何，统计里要按协方差结构度量距离。这些内积都给不出 $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}$ 这个具体公式，却都服从同一套规则。把规则抽出来，就得到内积空间。

::: intuition 直觉 · 内积是「长度 + 角度」的共同来源
内积要同时管两件事：让 $\langle\boldsymbol{x},\boldsymbol{x}\rangle$ 当**长度的平方**（非负，且只有零向量给零）；让 $\langle\boldsymbol{x},\boldsymbol{y}\rangle$ 当**投影 / 角度**的来源（对称 + 对加法、数乘线性）。满足这几条，「长度、距离、垂直、投影、勾股定理」就自动长出来——**同一套几何，换一把尺子**。
:::

::: def 定义 2.1.1 · 内积与内积空间 {#def-2.1.1}
设 $V$ 是实数域 $\mathbb{R}$ 上的线性空间。若对任意 $\boldsymbol{x},\boldsymbol{y}\in V$ 都指定一个实数，记作 $\langle\boldsymbol{x},\boldsymbol{y}\rangle$，满足：

1. **对称性**：$\langle\boldsymbol{x},\boldsymbol{y}\rangle=\langle\boldsymbol{y},\boldsymbol{x}\rangle$；
2. **对第一变元的线性**（对第二变元由对称性同理）：$\langle k\boldsymbol{x},\boldsymbol{y}\rangle=k\langle\boldsymbol{x},\boldsymbol{y}\rangle$；$\langle\boldsymbol{x}+\boldsymbol{z},\boldsymbol{y}\rangle=\langle\boldsymbol{x},\boldsymbol{y}\rangle+\langle\boldsymbol{z},\boldsymbol{y}\rangle$；
3. **正定性**：$\langle\boldsymbol{x},\boldsymbol{x}\rangle\ge0$，且 $\langle\boldsymbol{x},\boldsymbol{x}\rangle=0\iff\boldsymbol{x}=\boldsymbol{0}$；

则称 $\langle\cdot,\cdot\rangle$ 为 $V$ 上的**内积**（inner product），$(V,\langle\cdot,\cdot\rangle)$ 称为**内积空间**（inner product space）。由内积可诱导出**长度**

$$\lVert\boldsymbol{x}\rVert=\sqrt{\langle\boldsymbol{x},\boldsymbol{x}\rangle}, \tag{2.1}$$

以及**距离** $d(\boldsymbol{x},\boldsymbol{y})=\lVert\boldsymbol{x}-\boldsymbol{y}\rVert$。
:::

**在 $\mathbb{R}^n$ 中最常用的内积**是 $\langle\boldsymbol{x},\boldsymbol{y}\rangle=\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=\sum_ix_iy_i$，称为 **Euclid 内积**，它诱导的范数就是 $\lVert\cdot\rVert_2$。但满足内积公理的远不止它一个：

::: ex 例 2.1.1（新增） · 加权内积是一族合法的内积 {#ex-2.1.1}
设 $D=\operatorname{diag}(d_1,\dots,d_n)$，其中所有 $d_i\gt0$。定义

$$\langle\boldsymbol{x},\boldsymbol{y}\rangle_D=\boldsymbol{x}^{\mathrm T}D\boldsymbol{y}=\sum_{i=1}^n d_ix_iy_i .$$

验证它是 $\mathbb{R}^n$ 上的内积，并写出诱导范数。

::: proof 解
**对称性：** $\boldsymbol{x}^{\mathrm T}D\boldsymbol{y}=\sum_id_ix_iy_i=\boldsymbol{y}^{\mathrm T}D\boldsymbol{x}$（$D$ 是对角阵，故 $D^{\mathrm T}=D$；求和号内只是纯量相乘，次序可以交换）。**线性：** 内积是 $\boldsymbol{x}$ 的线性函数（$\boldsymbol{x}$ 的每个分量都是齐次线性组合）。**正定性：** $\boldsymbol{x}^{\mathrm T}D\boldsymbol{x}=\sum_id_ix_i^2\ge0$；等于 $0$ 当且仅当每个 $d_ix_i^2=0$，由 $d_i\gt0$ 得 $x_i=0$（$i=1,\dots,n$）。

诱导范数 $\lVert\boldsymbol{x}\rVert_D=\sqrt{\sum_id_ix_i^2}$——**给每个坐标轴不同的「刻度」**：一旦某个 $d_i\gt1$，对应的坐标方向就更「贵」。更一般地，只要 $D$ 对称正定，$\boldsymbol{x}^{\mathrm T}D\boldsymbol{y}$ 就是内积（证明：令 $D=LD_0L^{\mathrm T}$，则 $\boldsymbol{x}^{\mathrm T}D\boldsymbol{y}=(L^{\mathrm T}\boldsymbol{x})^{\mathrm T}D_0(L^{\mathrm T}\boldsymbol{y})$，化归对角情形）。

**用途：** [2.2.5](sec22.md#sec-2.2.5) 的加权最小二乘、加权内积下的 Rayleigh 商（[2.5.4](sec25.md#sec-2.5.4)）、[第五章](../ch01/sec11.md#roadmap)的预条件都建立在它上面。
:::

:::

内积诱导的范数**自动**满足第一章的三条范数公理——前提是 Cauchy–Schwarz 成立，而它在这里是可以**证明**的结论（第一章只是把它作为引理引入）：

::: thm 定理 2.1.1（新增） · 内积诱导范数的三个基本性质 {#thm-2.1.1}
设 $\langle\cdot,\cdot\rangle$ 是 $V$ 上的内积，$\lVert\boldsymbol{x}\rVert=\sqrt{\langle\boldsymbol{x},\boldsymbol{x}\rangle}$，则对任意 $\boldsymbol{x},\boldsymbol{y}\in V$：

$$\text{(i) Cauchy–Schwarz：}\quad\lvert\langle\boldsymbol{x},\boldsymbol{y}\rangle\rvert\le\lVert\boldsymbol{x}\rVert\,\lVert\boldsymbol{y}\rVert,\qquad
\text{(ii) 三角不等式：}\quad\lVert\boldsymbol{x}+\boldsymbol{y}\rVert\le\lVert\boldsymbol{x}\rVert+\lVert\boldsymbol{y}\rVert,$$

且 $\lVert\cdot\rVert$ 的正定性、齐次性成立——**即内积诱导的范数确实是范数**。

::: proof 证明
**（i）** $\boldsymbol{y}=\boldsymbol{0}$ 时两端为零。设 $\boldsymbol{y}\neq\boldsymbol{0}$，对任意实数 $t$，
$$0\le\langle\boldsymbol{x}-t\boldsymbol{y},\boldsymbol{x}-t\boldsymbol{y}\rangle=\lVert\boldsymbol{x}\rVert^2-2t\langle\boldsymbol{x},\boldsymbol{y}\rangle+t^2\lVert\boldsymbol{y}\rVert^2 .$$
这是关于 $t$ 的首项系数 $\lVert\boldsymbol{y}\rVert^2\gt0$ 的二次式，恒非负，故判别式 $\le0$：
$$4\langle\boldsymbol{x},\boldsymbol{y}\rangle^2-4\lVert\boldsymbol{x}\rVert^2\lVert\boldsymbol{y}\rVert^2\le0\ \Longrightarrow\ \lvert\langle\boldsymbol{x},\boldsymbol{y}\rangle\rvert\le\lVert\boldsymbol{x}\rVert\lVert\boldsymbol{y}\rVert .$$
（也可以直接取极小点 $t=\langle\boldsymbol{x},\boldsymbol{y}\rangle/\lVert\boldsymbol{y}\rVert^2$ 代入——与 [@lem-1.3.1] 的证法相同，只是这里对**一般**内积也成立。）

**（ii）** 展开后放缩：
$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2=\lVert\boldsymbol{x}\rVert^2+2\langle\boldsymbol{x},\boldsymbol{y}\rangle+\lVert\boldsymbol{y}\rVert^2\le\lVert\boldsymbol{x}\rVert^2+2\lVert\boldsymbol{x}\rVert\lVert\boldsymbol{y}\rVert+\lVert\boldsymbol{y}\rVert^2=\bigl(\lVert\boldsymbol{x}\rVert+\lVert\boldsymbol{y}\rVert\bigr)^2 .$$
开方即得。**正定性**与**齐次性**直接来自内积公理：$\lVert k\boldsymbol{x}\rVert^2=\langle k\boldsymbol{x},k\boldsymbol{x}\rangle=k^2\lVert\boldsymbol{x}\rVert^2$（先对第一变元、再对第二变元用线性）。
:::

:::

### 哪些范数来自内积？——一个判别法

不是每个范数都能由内积诱导：$\lVert\cdot\rVert_1,\lVert\cdot\rVert_\infty$ 就不行。判别工具是下面两条**恒等式**——一个范数究竟来自内积还是另有出处，会在它身上留下可检验的痕迹。

::: intuition 直觉 · 平行四边形恒等式在说什么
内积空间里的范数满足初中就学过的**平行四边形法则**：两条对角线的平方和 $=$ 四条边的平方和。这条性质之所以关键，是因为内积可以用范数**反算**回来（极化恒等式）——所以「范数来自内积」和「范数满足平行四边形恒等式」是同一件事。$\lVert\cdot\rVert_1$、$\lVert\cdot\rVert_\infty$ 在 $\boldsymbol{x}=(1,0),\boldsymbol{y}=(0,1)$ 上立刻露馅：它们的「单位球」有棱角，不是椭圆。
:::

::: thm 定理 2.1.2（新增） · 平行四边形恒等式与极化恒等式 {#thm-2.1.2}
在内积空间中，对任意 $\boldsymbol{x},\boldsymbol{y}$：

$$\text{平行四边形恒等式：}\quad\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2+\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2=2\lVert\boldsymbol{x}\rVert^2+2\lVert\boldsymbol{y}\rVert^2 ; \tag{2.2}$$

$$\text{极化恒等式：}\quad\langle\boldsymbol{x},\boldsymbol{y}\rangle=\frac{1}{4}\Bigl(\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2-\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2\Bigr). \tag{2.3}$$

反之，若 $\lVert\cdot\rVert$ 是 $\mathbb{R}^n$ 上的范数且满足（2.2），则由（2.3）定义的函数是一个内积，而它诱导出的范数恰好就是原来的 $\lVert\cdot\rVert$。

::: proof 证明
**（2.2）** 把两个平方都展开：
$$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2=\lVert\boldsymbol{x}\rVert^2+2\langle\boldsymbol{x},\boldsymbol{y}\rangle+\lVert\boldsymbol{y}\rVert^2,\qquad
\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2=\lVert\boldsymbol{x}\rVert^2-2\langle\boldsymbol{x},\boldsymbol{y}\rangle+\lVert\boldsymbol{y}\rVert^2 .$$
两式相加即得（2.2）；相减即得（2.3）。

**逆方向**（Jordan–von Neumann 定理的有限维版）：由（2.3）定义 $\langle\cdot,\cdot\rangle$，对称性显然（交换 $\boldsymbol{x},\boldsymbol{y}$ 只对调两个平方项），正定性来自范数的正定性（$\boldsymbol{y}=\boldsymbol{x}$ 代入（2.3）即得诱导范数还原：$\langle\boldsymbol{x},\boldsymbol{x}\rangle=\lVert\boldsymbol{x}\rVert^2$）。

线性性是真正的难关：加法要靠一条关键恒等式 $\langle\boldsymbol{x}+\boldsymbol{z},\boldsymbol{y}\rangle+\langle\boldsymbol{x}-\boldsymbol{z},\boldsymbol{y}\rangle=2\langle\boldsymbol{x},\boldsymbol{y}\rangle$（把（2.3）代入、四个平方和用（2.2）两两配对）；齐次性则按「整数归纳 → 有理数 → 实数（用范数连续性）」三段推进。完整证明见[附录 A.2.1](../appendix/derivations.md#app-a-2-1)。
:::

:::

::: ex 例 2.1.2（新增） · 1-范数与 ∞-范数不来自任何内积 {#ex-2.1.2}
取 $\boldsymbol{x}=(1,0)^{\mathrm T},\boldsymbol{y}=(0,1)^{\mathrm T}$，验证 $\lVert\cdot\rVert_1$ 与 $\lVert\cdot\rVert_\infty$ 都不满足平行四边形恒等式（2.2）。

::: proof 解
$\boldsymbol{x}+\boldsymbol{y}=(1,1)^{\mathrm T}$，$\boldsymbol{x}-\boldsymbol{y}=(1,-1)^{\mathrm T}$。

**∞-范数：** $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_\infty^2=1$，$\lVert\boldsymbol{x}-\boldsymbol{y}\rVert_\infty^2=1$，左端 $=2$；右端 $=2\times1+2\times1=4$。$2\neq4$，失败。

**1-范数：** $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_1^2=4$，$\lVert\boldsymbol{x}-\boldsymbol{y}\rVert_1^2=4$，左端 $=8$；右端 $=2\times1+2\times1=4$。$8\neq4$，失败。

**几何读法：** 内积空间里，任意两个向量张成的「平面切片」上的单位球必是椭圆（没有棱角）。$\lVert\cdot\rVert_1$ 的单位球是菱形、$\lVert\cdot\rVert_\infty$ 是正方形——**有棱角，就不是内积空间**。这也解释了为什么最小二乘、投影、SVD 这些工具天然属于 2-范数：只有 2-范数来自内积。
:::

:::

::: note 课堂对照（2026 秋·庞刚）
例 2.1.2 的「单位球有棱角就不是内积空间」，在[第 2 讲精编](../lectures/lec02.md)里有对应的板书几何直观：$\lVert\boldsymbol{x}\rVert_2=1$ 是球面、$\lVert\boldsymbol{x}\rVert_1$（三维）是正八面体、$\lVert\boldsymbol{x}\rVert_\infty$ 是立方体（盒子）——有没有棱角，一画便知。
:::

::: think 思考 · 2-范数为什么在数值分析里「特权」这么大
（2.1）与（2.2）划出一条明确的分界：**只有 2-范数拥有内积结构**，因此正交、投影、正交变换、奇异值这一整套几何工具也只对 2-范数开放。1-范数与 ∞-范数在**误差界**与**稀疏性**（[1.3.6](../ch01/sec13.md#sec-1.3.6)、[第 12 章](../ch01/sec11.md#roadmap)）上有独特价值，但「正交化」「投影」「SVD」这些词只对 2-范数有意义。这不是偏好，而是数学结构决定的。
:::

<a id="sec-2.1.2"></a>

## 2.1.2 正交与标准正交基

::: intuition 直觉 · 正交基 = 坐标轴互相垂直，且长度都是 1
在一组「互相垂直的坐标轴」上写坐标是最舒服的：求坐标只要**投影**，也就是做一次内积；各坐标之间互不干扰；勾股定理照样成立。本节就把这些直觉逐条证明成定理。先记住一句话：**在标准正交基下，「求解」退化成「做内积」**——而内积是 $O(n)$ 的廉价操作，所有快速算法都从这里起步。
:::

::: def 定义 2.1.2 · 正交、标准正交组与标准正交基 {#def-2.1.2}
设 $\langle\cdot,\cdot\rangle$ 是内积空间 $V$ 上的内积。

- 若 $\langle\boldsymbol{x},\boldsymbol{y}\rangle=0$，称 $\boldsymbol{x}$ 与 $\boldsymbol{y}$ **正交**（orthogonal），记 $\boldsymbol{x}\perp\boldsymbol{y}$；约定零向量与任何向量正交；
- 若非零向量组 $\boldsymbol{v}_1,\dots,\boldsymbol{v}_k$ 两两正交（$i\neq j\Rightarrow\boldsymbol{v}_i\perp\boldsymbol{v}_j$），称为**正交组**（orthogonal set）；
- 若正交组中每个向量的范数都是 $1$，称为**标准正交组**（orthonormal set）；
- 若 $V$ 的标准正交组含 $\dim V$ 个向量，则它是 $V$ 的**标准正交基**（orthonormal basis）。
:::

::: thm 定理 2.1.3（新增） · 正交组必线性无关 {#thm-2.1.3}
内积空间中任一不含零向量的正交组 $\{\boldsymbol{v}_1,\dots,\boldsymbol{v}_k\}$ 线性无关。

::: proof 证明
设 $\sum_{i=1}^{k}c_i\boldsymbol{v}_i=\boldsymbol{0}$。对任意固定的 $j$，两边与 $\boldsymbol{v}_j$ 作内积：

$$0=\Bigl\langle\sum_ic_i\boldsymbol{v}_i,\ \boldsymbol{v}_j\Bigr\rangle=\sum_ic_i\langle\boldsymbol{v}_i,\boldsymbol{v}_j\rangle=c_j\langle\boldsymbol{v}_j,\boldsymbol{v}_j\rangle=c_j\lVert\boldsymbol{v}_j\rVert^2 .$$

由 $\boldsymbol{v}_j\neq\boldsymbol{0}$ 得 $\lVert\boldsymbol{v}_j\rVert^2\gt0$，故 $c_j=0$。$j$ 任意，故所有系数为零，线性无关。

**证明里透出的「正交投影」味道：** 用内积把第 $j$ 个系数单独「筛」出来，其余各项一概不受影响——这正是正交基下「坐标 = 内积」的雏形。
:::

:::

::: thm 定理 2.1.4（新增） · 勾股定理与标准正交基下的坐标 {#thm-2.1.4}
设 $\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_k\}$ 是标准正交组。

1. **勾股定理：** 若 $\boldsymbol{x}=\sum_i\alpha_i\boldsymbol{q}_i$，$\boldsymbol{y}=\sum_i\beta_i\boldsymbol{q}_i$ 且 $\boldsymbol{x}\perp\boldsymbol{y}$，则 $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2=\lVert\boldsymbol{x}\rVert^2+\lVert\boldsymbol{y}\rVert^2$；
2. **坐标公式：** $\alpha_i=\langle\boldsymbol{x},\boldsymbol{q}_i\rangle$，即 $\boldsymbol{x}=\sum_{i=1}^{k}\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i$；
3. **Parseval 恒等式：** $\lVert\boldsymbol{x}\rVert^2=\sum_{i=1}^{k}\lvert\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\rvert^2$。

::: proof 证明
**（1）** 展开：$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2=\lVert\boldsymbol{x}\rVert^2+2\langle\boldsymbol{x},\boldsymbol{y}\rangle+\lVert\boldsymbol{y}\rVert^2=\lVert\boldsymbol{x}\rVert^2+\lVert\boldsymbol{y}\rVert^2$（用 $\langle\boldsymbol{x},\boldsymbol{y}\rangle=0$）。一般地，对**任意**标准正交组，若把 $\boldsymbol{x}$ 分解为「在张成方向上的部分」加上「剩下的部分」，两部分必正交——见 [@thm-2.2.3]。

**（2）** 设 $\boldsymbol{x}=\sum_i\alpha_i\boldsymbol{q}_i$，两边与 $\boldsymbol{q}_j$ 作内积并用标准正交性 $\langle\boldsymbol{q}_i,\boldsymbol{q}_j\rangle=\delta_{ij}$：

$$\langle\boldsymbol{x},\boldsymbol{q}_j\rangle=\sum_i\alpha_i\langle\boldsymbol{q}_i,\boldsymbol{q}_j\rangle=\alpha_j .$$

**（3）** 用（2）的展开直接算：
$$\lVert\boldsymbol{x}\rVert^2=\Bigl\langle\sum_i\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i,\ \sum_j\langle\boldsymbol{x},\boldsymbol{q}_j\rangle\boldsymbol{q}_j\Bigr\rangle=\sum_i\lvert\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\rvert^2 .$$


:::

:::

**（2）是最值钱的公式**：标准正交基下求坐标不需要解方程组，每个坐标就是一次内积（$O(n^3)$ 的求解退化为 $O(n^2)$ 的内积）。2.3 节的 QR 分解，本质就是**制造**这样一组基，把求解变廉价。把标准正交基按列排成方阵会得到什么？答案是**正交矩阵**——2.1.3 的主题。

::: ex 例 2.1.3（新增） · 标准正交基下的坐标与 Parseval 核对 {#ex-2.1.3}
（1）验证

$$\boldsymbol{q}_1=\frac{1}{\sqrt2}\begin{pmatrix}1\\1\\0\end{pmatrix},\qquad
\boldsymbol{q}_2=\frac{1}{\sqrt2}\begin{pmatrix}1\\-1\\0\end{pmatrix},\qquad
\boldsymbol{q}_3=\begin{pmatrix}0\\0\\1\end{pmatrix}$$

是 $\mathbb{R}^3$ 的标准正交基，并把 $\boldsymbol{x}=(6,2,1)^{\mathrm T}$ 用它们表示、核对 Parseval 恒等式。

（2）下面这组向量**看起来**也像标准正交基，请检验它是否真的成立：

$$\boldsymbol{r}_1=\frac{1}{\sqrt2}\begin{pmatrix}1\\1\\0\end{pmatrix},\qquad
\boldsymbol{r}_2=\frac{1}{\sqrt3}\begin{pmatrix}1\\-1\\1\end{pmatrix},\qquad
\boldsymbol{r}_3=\frac{1}{\sqrt6}\begin{pmatrix}1\\1\\-2\end{pmatrix}.$$

::: proof 解
**（1）验证正交性。** 逐个算两两内积（分母暂时抛开，只看分子）：

| 对 | 分子 $\boldsymbol{q}_i^{\mathrm T}\boldsymbol{q}_j$ | 结论 |
|:--|:--:|:--|
| $\boldsymbol{q}_1,\boldsymbol{q}_2$ | $(1)(1)+(1)(-1)+(0)(0)=0$ | 正交 ✓ |
| $\boldsymbol{q}_1,\boldsymbol{q}_3$ | $(1)(0)+(1)(0)+(0)(1)=0$ | 正交 ✓ |
| $\boldsymbol{q}_2,\boldsymbol{q}_3$ | $(1)(0)+(-1)(0)+(0)(1)=0$ | 正交 ✓ |

范数：$\lVert\boldsymbol{q}_1\rVert_2^2=\frac{1+1}{2}=1$，$\lVert\boldsymbol{q}_2\rVert_2^2=\frac{1+1}{2}=1$，$\lVert\boldsymbol{q}_3\rVert_2^2=1$。由 [@thm-2.1.3]，三个两两正交的非零向量线性无关，故是 $\mathbb{R}^3$ 的标准正交基。

**求坐标（用 [@thm-2.1.4] 的坐标公式，只做内积）：**

$$\alpha_1=\boldsymbol{q}_1^{\mathrm T}\boldsymbol{x}=\frac{6+2}{\sqrt2}=4\sqrt2,\qquad
\alpha_2=\boldsymbol{q}_2^{\mathrm T}\boldsymbol{x}=\frac{6-2}{\sqrt2}=2\sqrt2,\qquad
\alpha_3=\boldsymbol{q}_3^{\mathrm T}\boldsymbol{x}=1 .$$

$$\boldsymbol{x}=4\sqrt2\,\boldsymbol{q}_1+2\sqrt2\,\boldsymbol{q}_2+1\cdot\boldsymbol{q}_3 .$$

**重建核对：** $4\sqrt2\,\boldsymbol{q}_1=(4,4,0)^{\mathrm T}$，$2\sqrt2\,\boldsymbol{q}_2=(2,-2,0)^{\mathrm T}$，$1\cdot\boldsymbol{q}_3=(0,0,1)^{\mathrm T}$，三者相加 $=(6,2,1)^{\mathrm T}=\boldsymbol{x}$ ✓。

**Parseval 核对：** $\alpha_1^2+\alpha_2^2+\alpha_3^2=32+8+1=41$，而 $\lVert\boldsymbol{x}\rVert_2^2=36+4+1=41$ ✓。**Parseval 恒等式在本例中精确成立**——这也从另一个角度印证了这组基确实是标准正交的。

**（2）$\boldsymbol{r}$ 组不成立。** 范数都对（$\frac{1+1}{2}=1$、$\frac{1+1+1}{3}=1$、$\frac{1+1+4}{6}=1$），三对两两内积里 $\boldsymbol{r}_1^{\mathrm T}\boldsymbol{r}_2=0$ 也确实成立，可是

$$\boldsymbol{r}_1^{\mathrm T}\boldsymbol{r}_3=\frac{1\cdot1+1\cdot1+0\cdot(-2)}{\sqrt{12}}=\frac{2}{\sqrt{12}}\approx0.577\neq0,\qquad
\boldsymbol{r}_2^{\mathrm T}\boldsymbol{r}_3=\frac{1-1-2}{\sqrt{18}}=-\frac{2}{\sqrt{18}}\approx-0.471\neq0 .$$

两对不正交，故 $\{\boldsymbol{r}_1,\boldsymbol{r}_2,\boldsymbol{r}_3\}$ **不是**标准正交基。若把它误当标准正交基套用坐标公式，拼回去得到

$$(\boldsymbol{x}^{\mathrm T}\boldsymbol{r}_1)\boldsymbol{r}_1+(\boldsymbol{x}^{\mathrm T}\boldsymbol{r}_2)\boldsymbol{r}_2+(\boldsymbol{x}^{\mathrm T}\boldsymbol{r}_3)\boldsymbol{r}_3
=4\sqrt2\,\boldsymbol{r}_1+\frac{5}{\sqrt3}\,\boldsymbol{r}_2+\sqrt6\,\boldsymbol{r}_3
=\Bigl(\frac{20}{3},\ \frac{10}{3},\ -\frac13\Bigr)\neq\boldsymbol{x},$$

且「Parseval」给出 $32+\frac{25}{3}+6\approx46.3\neq41$——**两处同时失败**，因为正交性正是这两个公式的**唯一**依据。

**（2）的修复：** 正确的第三个方向应满足 $\boldsymbol{v}\perp\boldsymbol{r}_1,\boldsymbol{v}\perp\boldsymbol{r}_2$。解 $\boldsymbol{v}^{\mathrm T}\boldsymbol{r}_1=0,\ \boldsymbol{v}^{\mathrm T}\boldsymbol{r}_2=0$ 得 $\boldsymbol{v}\propto(1,-1,-2)^{\mathrm T}$（复核：$(1-1+0)/\sqrt2=0$，$(1+1-2)/\sqrt3=0$ ✓），单位化后

$$\boldsymbol{q}_3'=\frac{1}{\sqrt6}\begin{pmatrix}1\\-1\\-2\end{pmatrix},\qquad
\{\boldsymbol{r}_1,\boldsymbol{r}_2,\boldsymbol{q}_3'\}\ \text{才是标准正交基}.$$

此时坐标变为 $\alpha_1=4\sqrt2,\ \alpha_2=\frac{5}{\sqrt3},\ \alpha_3'=\frac{6-2-2}{\sqrt6}=\sqrt{\frac23}$，Parseval 给出 $32+\frac{25}{3}+\frac{2}{3}=41=\lVert\boldsymbol{x}\rVert_2^2$ ✓。

**本题的收获：** 判定一组向量是否标准正交，**必须逐个验证全部两两内积**——只看范数、或只看一部分内积，都会漏掉那对不正交的向量，后果是坐标公式与 Parseval **同时静默失效**（见 2.1.4 常见错误 1）。上面「修一个方向」的做法，正是 [2.3.1](sec23.md#sec-2.3.1) 的 Gram–Schmidt 正交化。
:::

:::

<a id="sec-2.1.3"></a>

## 2.1.3 正交矩阵

::: intuition 直觉 · 正交矩阵 = 不改变长度和角度的变换
**正交矩阵，就是把标准正交基按列排成的方阵**——它的列就是一组互相垂直、长度归一的新坐标轴。换个角度看：把矩阵 $Q$ 看成对空间的一次**变换**（$\boldsymbol{x}\mapsto Q\boldsymbol{x}$）。$Q$ 一旦是正交矩阵，这次变换就只做两件事：**旋转**或**镜像**（也可能两者复合）——刚体被搬来搬去，但**不拉伸、不压缩、不歪斜**。因此：

- 长度不变（$\lVert Q\boldsymbol{x}\rVert=\lVert\boldsymbol{x}\rVert$），距离与夹角也不变；
- 逆变换极其便宜：$Q^{-1}=Q^{\mathrm T}$（转置不用真的算，只是换个存储顺序）；
- **误差不被放大**：$\lVert Q\boldsymbol{x}\rVert=\lVert\boldsymbol{x}\rVert$ 意味着浮点误差经过正交变换后仍然只受机器精度支配。

前两条让正交矩阵成为**最理想的坐标系**（QR 分解、SVD、特征值算法的全部中间步骤都在反复使用正交变换），第三条则是数值稳定性理论的核心（[2.3.5](sec23.md#sec-2.3.5) 会用到）。
:::

::: def 定义 2.1.3 · 正交矩阵 {#def-2.1.3}
设 $Q\in\mathbb{R}^{n\times n}$。若

$$Q^{\mathrm T}Q=I, \tag{2.4}$$

则称 $Q$ 为**正交矩阵**（orthogonal matrix）。对长方阵 $Q\in\mathbb{R}^{m\times n}$（$m\ge n$），若满足 $Q^{\mathrm T}Q=I_n$，则称其列向量组标准正交，$Q$ 为**列正交矩阵**——QR 分解里的 $Q$ 正是这一类。
:::

::: thm 定理 2.1.5（新增） · 正交矩阵的等价刻画 {#thm-2.1.5}
对 $Q\in\mathbb{R}^{n\times n}$，下列命题互相等价：

| # | 命题 | 一句话含义 |
|:--:|:--|:--|
| 1 | $Q^{\mathrm T}Q=I$ | 定义 |
| 2 | $QQ^{\mathrm T}=I$ | 左逆即右逆 |
| 3 | $Q^{-1}=Q^{\mathrm T}$ | 逆就是转置 |
| 4 | $Q$ 的列向量组是 $\mathbb{R}^n$ 的标准正交基 | 列正交且范数 1 |
| 5 | $Q$ 的行向量组是 $\mathbb{R}^n$ 的标准正交基 | 行同样正交 |
| 6 | $\langle Q\boldsymbol{x},Q\boldsymbol{y}\rangle=\langle\boldsymbol{x},\boldsymbol{y}\rangle$ 对一切 $\boldsymbol{x},\boldsymbol{y}$ | 保内积 |
| 7 | $\lVert Q\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_2$ 对一切 $\boldsymbol{x}$ | 保长度 |
| 8 | $\lVert Q\boldsymbol{x}-Q\boldsymbol{y}\rVert_2=\lVert\boldsymbol{x}-\boldsymbol{y}\rVert_2$ | 保距离 |
| 9 | $\lvert\det Q\rvert=1$ | 体积不变（方向可翻） |
| 10 | $Q$ 的奇异值全为 $1$；$\lVert Q\rVert_2=\mathrm{cond}_2(Q)=1$ | 奇异值视角 |
| 11 | $Q$ 的（复）特征值模全为 $1$ | 特征值视角 |

::: proof 证明（挑六个关键的，其余留作[习题 B1](exercises.md)）
**1 ⟹ 3 ⟹ 2：** 由 $Q^{\mathrm T}Q=I$ 知 $Q$ 可逆（$\det(Q^{\mathrm T}Q)=(\det Q)^2=1\neq0$），于是 $Q^{-1}=Q^{-1}I=Q^{-1}(Q^{\mathrm T}Q)=(Q^{-1}Q)Q^{\mathrm T}=Q^{\mathrm T}$，这就是 3；再由 $QQ^{\mathrm T}=Q Q^{-1}=I$ 得 2。

**1 ⟺ 4：** 记 $Q=[\boldsymbol{q}_1,\dots,\boldsymbol{q}_n]$，则 $(Q^{\mathrm T}Q)_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{q}_j=\delta_{ij}$，正是「两两正交且范数为 1」。

**3 ⟹ 6：** $\langle Q\boldsymbol{x},Q\boldsymbol{y}\rangle=(Q\boldsymbol{x})^{\mathrm T}(Q\boldsymbol{y})=\boldsymbol{x}^{\mathrm T}Q^{\mathrm T}Q\boldsymbol{y}=\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=\langle\boldsymbol{x},\boldsymbol{y}\rangle$。

**6 ⟹ 7：** 取 $\boldsymbol{y}=\boldsymbol{x}$：$\lVert Q\boldsymbol{x}\rVert_2^2=\langle Q\boldsymbol{x},Q\boldsymbol{x}\rangle=\langle\boldsymbol{x},\boldsymbol{x}\rangle=\lVert\boldsymbol{x}\rVert_2^2$。

**7 ⟹ 1：** 由 7，$\boldsymbol{x}^{\mathrm T}Q^{\mathrm T}Q\boldsymbol{x}=\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 对一切 $\boldsymbol{x}$，即 $\boldsymbol{x}^{\mathrm T}(Q^{\mathrm T}Q-I)\boldsymbol{x}=0$。记 $S=Q^{\mathrm T}Q-I$，它是对称阵。取 $\boldsymbol{x}$ 为 $\boldsymbol{e}_i$ 得 $s_{ii}=0$；取 $\boldsymbol{x}=\boldsymbol{e}_i+\boldsymbol{e}_j$ 得 $2s_{ij}=0$。故 $S=O$，即 $Q^{\mathrm T}Q=I$。

**9：** $1=\det I=\det(Q^{\mathrm T}Q)=\det(Q^{\mathrm T})\cdot\det Q=(\det Q)^2$，故 $\lvert\det Q\rvert=1$。

**10：** $Q^{\mathrm T}Q=I$ 的特征值全是 $1$，故奇异值全为 $1$，$\lVert Q\rVert_2=\sigma_{\max}=1$、$\mathrm{cond}_2(Q)=\sigma_1/\sigma_n=1$。（用 [@thm-1.3.5] 与 [2.6.2](sec26.md#sec-2.6.2) 的奇异值刻画。）

**11：** 设 $Q\boldsymbol{v}=\lambda\boldsymbol{v}$（$\boldsymbol{v}\neq\boldsymbol{0}$），取 2-范数并用 7：$\lVert\boldsymbol{v}\rVert_2=\lVert Q\boldsymbol{v}\rVert_2=\lvert\lambda\rvert\lVert\boldsymbol{v}\rVert_2$，故 $\lvert\lambda\rvert=1$。
:::

:::

**关于第 9 条的几何含义：** $\lvert\det Q\rvert=1$ 说明正交变换**保持体积**（第一章的 Jacobi 行列式出现在换元积分里，而正交变换的 Jacobi 行列式恰好是 $\pm1$）。再看符号：$\det Q=+1$ 对应**旋转**（保定向），$\det Q=-1$ 对应**镜像 / 反射**（反定向）——这正是两类正交变换的本质区别，也是 [2.3.3](sec23.md#sec-2.3.3) 的 Householder 反射（$\det=-1$）与 [2.3.4](sec23.md#sec-2.3.4) 的 Givens 旋转（$\det=+1$）的分界线。

::: ex 例 2.1.4（新增） · 二维的旋转与反射 {#ex-2.1.4}
验证平面旋转矩阵与反射矩阵都是正交矩阵，并计算各自的行列式：

$$R_\theta=\begin{pmatrix}\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta\end{pmatrix},\qquad
F=\begin{pmatrix}\cos2\theta&\sin2\theta\\ \sin2\theta&-\cos2\theta\end{pmatrix}.$$

::: proof 解
**旋转：** $R_\theta^{\mathrm T}R_\theta=\begin{pmatrix}\cos\theta&\sin\theta\\-\sin\theta&\cos\theta\end{pmatrix}\begin{pmatrix}\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta\end{pmatrix}=\begin{pmatrix}\cos^2\theta+\sin^2\theta&0\\0&\cos^2\theta+\sin^2\theta\end{pmatrix}=I$。故正交。$\det R_\theta=\cos^2\theta+\sin^2\theta=1\gt0$：**旋转保定向**。

**反射：** 记 $c=\cos2\theta,s=\sin2\theta$。$F^{\mathrm T}F=\begin{pmatrix}c&s\\s&-c\end{pmatrix}^2=\begin{pmatrix}c^2+s^2&cs-sc\\cs-sc&s^2+c^2\end{pmatrix}=I$。$\det F=-c^2-s^2=-1\lt0$：**反射反定向**。

**几何验证（数值）：** 取 $\theta=30^{\circ}$，$\boldsymbol{x}=(1,0)^{\mathrm T}$。
- $R_{30^{\circ}}\boldsymbol{x}=(\cos30^{\circ},\sin30^{\circ})^{\mathrm T}\approx(0.8660,0.5)^{\mathrm T}$，长度 $1$ 不变，方向转了 $30^{\circ}$；
- $F\boldsymbol{x}=(\cos60^{\circ},\sin60^{\circ})^{\mathrm T}\approx(0.5,0.8660)^{\mathrm T}$，长度不变，方向关于 $30^{\circ}$ 方向镜像（入射角 = 反射角）。

**任何正交矩阵都是「若干旋转 × 若干反射」的复合**（这是正交群的几何分类）；此外 $Q$ 的复特征值成对出现在单位圆上（$e^{\pm i\theta}$，对应旋转角 $\theta$），实特征值只能是 $\pm1$。
:::

:::

### 正交不变性：为什么数值算法偏爱正交变换

下面这条定理的证明只有两行，却是**整个数值线性代数的支柱之一**——它说明，正交变换不改变矩阵的「大小」。

::: thm 定理 2.1.6（新增） · 正交变换保持 2-范数与 Frobenius 范数 {#thm-2.1.6}
设 $Q\in\mathbb{R}^{m\times m}$、$P\in\mathbb{R}^{n\times n}$ 为正交矩阵，$A\in\mathbb{R}^{m\times n}$，则

$$\lVert QA\rVert_2=\lVert A\rVert_2,\qquad \lVert QA\rVert_F=\lVert A\rVert_F,\qquad \lVert AP\rVert_F=\lVert A\rVert_F .$$

::: proof 证明
**Frobenius：**
$$\lVert QA\rVert_F^2=\operatorname{tr}\bigl((QA)^{\mathrm T}QA\bigr)=\operatorname{tr}(A^{\mathrm T}Q^{\mathrm T}QA)=\operatorname{tr}(A^{\mathrm T}A)=\lVert A\rVert_F^2 .$$
（用了 $\operatorname{tr}(XY)=\operatorname{tr}(YX)$ 与 $Q^{\mathrm T}Q=I$。）同理 $\lVert AP\rVert_F^2=\operatorname{tr}(P^{\mathrm T}A^{\mathrm T}AP)$——注意 $\operatorname{tr}(PY)=\operatorname{tr}(YP)$ 且这里 $P^{\mathrm T}=P^{-1}$，故 $\operatorname{tr}(P^{\mathrm T}A^{\mathrm T}AP)=\operatorname{tr}(A^{\mathrm T}AP P^{\mathrm T})=\operatorname{tr}(A^{\mathrm T}A)$。

**谱范数：** 用 [@thm-1.3.5] 的 $\lVert A\rVert_2=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$。令 $B=A^{\mathrm T}A$ 与 $B'=(QA)^{\mathrm T}(QA)=A^{\mathrm T}Q^{\mathrm T}QA=A^{\mathrm T}A=B$——**完全相同**，故特征值相同、$\lVert QA\rVert_2=\lVert A\rVert_2$。

**注意：** 上文只直接验证了 $\lVert\cdot\rVert_2$ 在**左乘**正交矩阵时不变；**右乘同样成立**（$\lVert AP\rVert_2=\lVert A\rVert_2$，因为 $(AP)^{\mathrm T}(AP)=P^{\mathrm T}A^{\mathrm T}AP$ 与 $A^{\mathrm T}A$ 相似）；而 $\lVert\cdot\rVert_F$ 左右乘都不变。**这就是「正交变换不改变矩阵的大小」的精确含义**——它是 QR 分解与 SVD 中「用正交变换把矩阵化简、又不失真」的依据。
:::

:::

::: think 思考 · 正交变换为什么能「不放大误差」
用浮点数执行一次正交变换，误差来自两处：变换本身的舍入（相对误差 $\sim u$，见 [1.2.5](../ch01/sec12.md#sec-1.2.5)）与**放大因子**（由 [@thm-2.1.6]，放大因子 $=1$）。因此

$$\lVert \widetilde{Q A}-QA\rVert_F\approx\lVert QA\rVert_F\cdot c\,u=\lVert A\rVert_F\cdot c\,u$$

——**误差与矩阵大小同比例，不随变换次数累积**。对比一下：若换成非正交的变换矩阵 $S$（如一般的消元算子），放大因子是 $\mathrm{cond}(S)$，$\mathrm{cond}\gg1$ 时误差就会被放大。**这正是 2.3 节的正交化（Householder / Givens）与 2.6 节的 SVD 都坚持用正交变换的原因**，也是 QR 方法解最小二乘比正态方程稳定的原因（[2.3.5](sec23.md#sec-2.3.5)）。
:::

<a id="sec-2.1.4"></a>

## 2.1.4 小结与常见错误

::: method[core] 本节公式速查

| 概念 | 公式 / 结论 |
|:--|:--|
| 内积公理 | 对称、线性、正定（[@def-2.1.1]） |
| 诱导范数 | $\lVert\boldsymbol{x}\rVert=\sqrt{\langle\boldsymbol{x},\boldsymbol{x}\rangle}$ |
| Cauchy–Schwarz | $\lvert\langle\boldsymbol{x},\boldsymbol{y}\rangle\rvert\le\lVert\boldsymbol{x}\rVert\lVert\boldsymbol{y}\rVert$ |
| 平行四边形 | $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2+\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2=2\lVert\boldsymbol{x}\rVert^2+2\lVert\boldsymbol{y}\rVert^2$ |
| 极化恒等式 | $\langle\boldsymbol{x},\boldsymbol{y}\rangle=\frac14\bigl(\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2-\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2\bigr)$ |
| 正交组 | 两两内积为 $0$ 的非零向量组 ⟹ 线性无关 |
| 正交基坐标 | $\boldsymbol{x}=\sum_i\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i$ |
| Parseval | $\lVert\boldsymbol{x}\rVert^2=\sum_i\lvert\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\rvert^2$ |
| 正交矩阵 | $Q^{\mathrm T}Q=I$；$Q^{-1}=Q^{\mathrm T}$；$\lvert\det Q\rvert=1$；$\mathrm{cond}_2(Q)=1$ |
| 正交不变性 | $\lVert QA\rVert_F=\lVert A\rVert_F$，$\lVert QA\rVert_2=\lVert A\rVert_2$ |

:::

::: think[core] 常见错误清单 · 自查五条
1. **「范数都是 $1$」就当作标准正交。** 范数为 $1$ 只保证「标准」，「正交」必须**逐个验证内积为零**——例 2.1.3 的三个向量范数全对，但 $\boldsymbol{r}_2^{\mathrm T}\boldsymbol{r}_3=-2/\sqrt{18}\neq0$，于是坐标公式与 Parseval **同时静默失效**。判定流程：先算全部两两内积，再算范数。
2. **把 $\lVert\cdot\rVert_1$ 或 $\lVert\cdot\rVert_\infty$ 当成内积范数。** 它们不满足平行四边形恒等式（[@ex-2.1.2]），因此**没有**正交、投影、SVD 这套工具。见到「正交」二字，默认内积是 Euclid 内积。
3. **以为「正交矩阵的逆要算」**。$Q^{-1}=Q^{\mathrm T}$，转置是 $O(n^2)$ 的数据搬移，不需要 $O(n^3)$ 的求逆。代码里出现 `np.linalg.inv(Q)`，基本可以断定是错的。
4. **混淆「列正交」与「正交矩阵」。** 长方阵 $Q\in\mathbb{R}^{m\times n}$（$m\gt n$）满足 $Q^{\mathrm T}Q=I_n$，但 $QQ^{\mathrm T}\neq I_m$——它是一个 $m$ 阶投影矩阵（[2.2.4](sec22.md#sec-2.2.4)）。只有方阵才有 $Q^{-1}=Q^{\mathrm T}$。
5. **以为内积只有 $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}$ 一种。** 加权内积 $\boldsymbol{x}^{\mathrm T}D\boldsymbol{y}$（$D$ 对称正定）同样合法且常用；不同的内积给出**不同的**正交性与投影——「投影」必须说明是在哪个内积下。切换内积时，$\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=0$ 不再是正交的判据。
:::

::: preview 课程预告 · 本节之后
- 有了正交，就能定义**投影**（把向量「垂直地」拍到一个子空间上），进而得到最小二乘与四个基本子空间的正交补结构——[2.2](sec22.md)；
- 有了正交矩阵，就能用**正交变换**把矩阵化为三角形（QR 分解），并证明它的误差不放大——[2.3](sec23.md)；
- 有了内积，就可以定义**奇异值**（2.6）与 **Rayleigh 商**（2.5.4），把「矩阵有多大」「多敏感」讲成几何。
:::
