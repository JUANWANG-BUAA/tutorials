# 闭卷回忆卡 · 补充篇：数值线性代数工具箱

> 本页属“补充篇 · 数值线性代数工具箱”，不是课堂第 2 章；课堂第 2 章见[线性方程组的解法](../course/ch02/overview.md)。

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾标记 **✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起，下一轮只重做 △ 与 ×。全页 46 张卡，一轮约 35 分钟。本页负责**检索**；压缩看[公式与结论卡](../review/formula-cards.md)，辨析看[易混对照卡](../review/contrast-cards.md)，考场节奏看[综合自测卷](mock-exam.md)；第一章的对应卡片见[第一章回忆卡](../ch01/recall-cards.md)。

## A. 定义卡

**A1.** 写出内积的三条公理与诱导范数；除 $\boldsymbol x^{\mathrm T}\boldsymbol y$ 外再举一族合法的内积。
::: sol
对称性 $\langle\boldsymbol x,\boldsymbol y\rangle=\langle\boldsymbol y,\boldsymbol x\rangle$；对第一变元线性（对第二变元由对称性同理）；正定性 $\langle\boldsymbol x,\boldsymbol x\rangle\ge0$ 且为零当且仅当 $\boldsymbol x=\boldsymbol 0$。诱导范数 $\lVert\boldsymbol x\rVert=\sqrt{\langle\boldsymbol x,\boldsymbol x\rangle}$、距离 $d(\boldsymbol x,\boldsymbol y)=\lVert\boldsymbol x-\boldsymbol y\rVert$。族：加权内积 $\langle\boldsymbol x,\boldsymbol y\rangle_D=\boldsymbol x^{\mathrm T}D\boldsymbol y$（$D$ 对称正定；对角正权只是特例）（[@def-sup-2.1.1]、[@ex-sup-2.1.1]）。（✓ / △ / ×）
:::

**A2.** 「正交组」「标准正交组」「标准正交基」三者的差别是什么？零向量算不算正交？
::: sol
正交组＝非零向量组且两两内积为零；标准正交组＝正交组中每个向量范数为 $1$；标准正交基＝含 $\dim V$ 个向量的标准正交组。零向量与任何向量**约定为正交**（[@def-sup-2.1.2]）。（✓ / △ / ×）
:::

**A3.** 正交矩阵与「列正交矩阵」怎么定义？二者差在哪？
::: sol
方阵 $Q$ 满足 $Q^{\mathrm T}Q=I$ 称正交矩阵；$Q\in\mathbb R^{m\times n}$（$m>n$）满足 $Q^{\mathrm T}Q=I_n$ 时列标准正交，$QQ^{\mathrm T}\ne I_m$ 且是投影矩阵（[@def-sup-2.1.3]）。（✓ / △ / ×）
:::

**A4.** 写出四个基本子空间的定义，并标明各自住在哪个空间里。
::: sol
列空间 $C(A)=\{A\boldsymbol x\}\subseteq\mathbb R^m$；零空间 $N(A)=\{\boldsymbol x:A\boldsymbol x=\boldsymbol 0\}\subseteq\mathbb R^n$；行空间 $C(A^{\mathrm T})\subseteq\mathbb R^n$；左零空间 $N(A^{\mathrm T})\subseteq\mathbb R^m$（[@def-sup-2.2.1]）。（✓ / △ / ×）
:::

**A5.** 正交补 $\mathcal S^{\perp}$ 的定义是什么？检验 $\boldsymbol x\in\mathcal S^{\perp}$ 时要不要对 $\mathcal S$ 的每个向量都查一遍？
::: sol
$\mathcal S^{\perp}=\{\boldsymbol x:\langle\boldsymbol x,\boldsymbol s\rangle=0\ \forall\boldsymbol s\in\mathcal S\}$——与 $\mathcal S$ 中**每个**向量都正交的向量全体。实际只需查 $\mathcal S$ 的**一组基**：内积对第二变元线性，基上为零则全体为零（[@def-sup-2.2.2]）。（✓ / △ / ×）
:::

**A6.** 什么叫最小二乘解？什么叫残差？二者分别可不可以算出来？
::: sol
$\hat{\boldsymbol x}$ 最小化 $\lVert A\boldsymbol x-\boldsymbol b\rVert_2$ 时称最小二乘解；$\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$ 称残差。**残差可以算**（$\boldsymbol b$ 与 $\hat{\boldsymbol x}$ 都在手上），真解与误差 $\boldsymbol x-\hat{\boldsymbol x}$ 一般**算不出来**（[@def-sup-2.2.3]）。（✓ / △ / ×）
:::

**A7.** Householder 变换的公式与几何意义是什么？反射向量与镜面分别是谁？
::: sol
$\boldsymbol v\ne\boldsymbol0$ 时，$H=I-\dfrac{2}{\boldsymbol v^{\mathrm T}\boldsymbol v}\boldsymbol v\boldsymbol v^{\mathrm T}$：关于超平面 $\boldsymbol v^{\perp}$ 的镜像——$\boldsymbol v$ 方向翻转（$H\boldsymbol v=-\boldsymbol v$），$\boldsymbol v^{\perp}$ 上不动（[@def-sup-2.3.1]、[@thm-sup-2.3.3]）。（✓ / △ / ×）
:::

**A8.** Givens 旋转怎么定义？它与 Householder 的关键区别（消元粒度、行列式）是什么？
::: sol
单位阵基础上把 $(i,i),(i,j),(j,i),(j,j)$ 四个位置换成 $c,s,-s,c$（$c^2+s^2=1$）。它只作用在两个坐标上、**一次消一个元素**、$\det G=+1$（保定向）；Householder 一次改动整个子块、$\det H=-1$（反定向）（[@def-sup-2.3.2]、[2.3.5](sec23.md#sup-2.3.5)）。（✓ / △ / ×）
:::

**A9.** 矩阵条件数怎么定义？谱条件数等于什么？它衡量的是「元素多大」还是别的？
::: sol
对非奇异方阵，$\mathrm{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert$（依赖所选范数，报告必须注明），$\mathrm{cond}_2(A)=\sigma_1/\sigma_n$。矩形满秩矩阵通常定义为最大与最小奇异值之比；秩亏时普通 2-条件数为无穷，$\sigma_1/\sigma_r$（$r$ 为秩）只是限制到非零奇异子空间后的有效条件数。2-条件数衡量相对扰动下接近秩亏的程度，不是元素绝对大小；对 $c\ne0$，$\mathrm{cond}(cA)=\mathrm{cond}(A)$（[@def-sup-2.4.1]、[@thm-sup-2.4.1]）。（✓ / △ / ×）
:::

**A10.** 特征值、谱、谱半径分别怎么定义？实矩阵的特征值一定是实数吗？
::: sol
$A\boldsymbol v=\lambda\boldsymbol v$（$\boldsymbol v\neq\boldsymbol 0$）时 $\lambda$ 为特征值，等价于 $\det(A-\lambda I)=0$；全部特征值构成谱 $\sigma(A)$（列出时可注明代数重数）；$\rho(A)=\max\lvert\lambda_i\rvert$。实矩阵也可以有复特征值（旋转矩阵即例）；实对称性是保证全实谱的充分条件，并非必要条件，例如实三角矩阵也有全实谱（[@def-sup-2.5.1]、[@thm-sup-2.5.1]）。（✓ / △ / ×）
:::

::: think A 组的适用条件{#rc2-a-conditions}
- 内积公理只保证「对称 + 线性 + 正定」，**任何**满足它们的二元函数都是内积；换内积就换正交、换投影、换最优解。
- 「正交」永远相对**某个**内积而言：写 $\boldsymbol x^{\mathrm T}\boldsymbol y=0$ 时默认 Euclid 内积，切换内积后这句话不再是判据。
- 长方阵的 $Q$ 只有列正交，「逆等于转置」只对方阵成立。
- 条件数依赖范数；范数等价给出的比较常数随维数变化，不能据此断言不同范数下预测的可靠位数完全一致。报告必须固定范数与扰动模型。
- 谱半径 $\rho$ 与范数 $\lVert A\rVert$ 不同；正规矩阵满足 $\rho(A)=\lVert A\rVert_2$，这里特指 2-范数。非正规矩阵有时也可取等，故不是充要判据。
:::

## B. 结论卡

**B1.** 内积诱导的范数自动满足哪些性质？怎么判断一个范数**不**来自内积？
::: sol
自动满足 Cauchy–Schwarz、三角不等式、正定与齐次——即确实是范数。判据是**平行四边形恒等式** $\lVert\boldsymbol x+\boldsymbol y\rVert^2+\lVert\boldsymbol x-\boldsymbol y\rVert^2=2\lVert\boldsymbol x\rVert^2+2\lVert\boldsymbol y\rVert^2$：满足它才来自内积（内积由极化恒等式反算回来）。$\lVert\cdot\rVert_1$ 与 $\lVert\cdot\rVert_\infty$ 在 $\boldsymbol x=(1,0),\boldsymbol y=(0,1)$ 上立刻失败（[@thm-sup-2.1.1]、[@thm-sup-2.1.2]、[@ex-sup-2.1.2]）。（✓ / △ / ×）
:::

**B2.** 正交组为什么必线性无关？标准正交基下「求坐标」与「求长度」各退化成什么？
::: sol
设 $\sum_ic_i\boldsymbol v_i=\boldsymbol 0$，两边与 $\boldsymbol v_j$ 作内积，其余项因正交消失，得 $c_j\lVert\boldsymbol v_j\rVert^2=0$，故 $c_j=0$。标准正交基下坐标就是内积 $\alpha_i=\langle\boldsymbol x,\boldsymbol q_i\rangle$，长度按 Parseval $\lVert\boldsymbol x\rVert^2=\sum_i\lvert\langle\boldsymbol x,\boldsymbol q_i\rangle\rvert^2$，正交向量之和满足勾股定理（[@thm-sup-2.1.3]、[@thm-sup-2.1.4]）。（✓ / △ / ×）
:::

**B3.** 正交矩阵有哪些等价刻画（至少写六条）？正交变换为什么「不放大误差」？
::: sol
$Q^{\mathrm T}Q=I$、$QQ^{\mathrm T}=I$、$Q^{-1}=Q^{\mathrm T}$、行列均标准正交、保内积、保长度、保距离和奇异值全为 1 均为等价刻画。$|\det Q|=1$ 或特征值模全为 1 只是必要条件。精确正交变换保持已有误差的范数，但浮点运算会引入新的舍入误差（[@thm-sup-2.1.5]、[@thm-sup-2.1.6]）。（✓ / △ / ×）
:::

**B4.** 写出行秩＝列秩、两个维数公式与两对正交补，并说出它们是哪种分解。
::: sol
$\operatorname{rank}A=\dim C(A)=\dim C(A^{\mathrm T})=r$；$\dim N(A)=n-r$、$\dim N(A^{\mathrm T})=m-r$；$C(A^{\mathrm T})=N(A)^{\perp}$、$C(A)=N(A^{\mathrm T})^{\perp}$，即 $\mathbb R^n=C(A^{\mathrm T})\oplus N(A)$、$\mathbb R^m=C(A)\oplus N(A^{\mathrm T})$ 两个**正交直和**。由此任何 $\boldsymbol b$ 唯一分解为 $\boldsymbol b=\boldsymbol p+\boldsymbol e$（$\boldsymbol p\in C(A)$、$\boldsymbol e\in N(A^{\mathrm T})$），且 $\boldsymbol e\perp\boldsymbol p$（[@thm-sup-2.2.1]、[@thm-sup-2.2.2]）。（✓ / △ / ×）
:::

**B5.** 正交分解定理说了几件事？「投影」与「最近点」是什么关系？
::: sol
① 每个 $\boldsymbol x$ 唯一写成 $\boldsymbol x=\boldsymbol p+\boldsymbol e$（$\boldsymbol p\in\mathcal S$、$\boldsymbol e\in\mathcal S^{\perp}$）；② 勾股 $\lVert\boldsymbol x\rVert^2=\lVert\boldsymbol p\rVert^2+\lVert\boldsymbol e\rVert^2$；③ 有标准正交基时 $\boldsymbol p=\sum_i\langle\boldsymbol x,\boldsymbol q_i\rangle\boldsymbol q_i$。最近性：$\lVert\boldsymbol x-\boldsymbol s\rVert\gt\lVert\boldsymbol x-\boldsymbol p\rVert$ 对任何 $\boldsymbol s\neq\boldsymbol p$ 成立——**投影就是最近点，最近 ⟺ 余项垂直**（[@thm-sup-2.2.3]、[@thm-sup-2.2.4]）。（✓ / △ / ×）
:::

**B6.** 投影矩阵 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ 的三条性质是什么？反过来如何判定一个矩阵是正交投影？
::: sol
在 $A$ 列满秩时，该公式给出对称、幂等的矩阵，特征值只取 $0/1$ 且 $\operatorname{tr}P=\operatorname{rank}P=\operatorname{rank}A$（$P\neq O$ 时 $\lVert P\rVert_2=1$）。反之「对称 + 幂等」就是某个子空间上的正交投影；幂等但不对称的是斜投影，余项一般不垂直于子空间。秩亏时改写为 $P=AA^+$（[@thm-sup-2.2.5]、[2.2.3](sec22.md#sup-2.2.3) 指纹框）。（✓ / △ / ×）
:::

**B7.** 最小二乘解的存在性与唯一性各靠什么？正态方程的三件套是什么？
::: sol
**总存在**（$A^{\mathrm T}\boldsymbol b\in C(A^{\mathrm T})=C(A^{\mathrm T}A)$）；**唯一 ⟺ $A$ 列满秩**（此时 $A^{\mathrm T}A$ 非奇异）。三件套：① $A^{\mathrm T}A\hat{\boldsymbol x}=A^{\mathrm T}\boldsymbol b\iff A^{\mathrm T}\boldsymbol r=\boldsymbol 0\iff$ 最小二乘解；② $\hat{\boldsymbol x}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol b$、$A\hat{\boldsymbol x}=P\boldsymbol b$、$\boldsymbol r\in N(A^{\mathrm T})$；③ $\lVert\boldsymbol r\rVert^2=\lVert\boldsymbol b\rVert^2-\lVert A\hat{\boldsymbol x}\rVert^2$（勾股）（[@thm-sup-2.2.6]）。（✓ / △ / ×）
其中第②项的逆矩阵表达式仅用于列满秩，其他投影与残差结论在秩亏时仍成立。
:::

**B8.** 加权最小二乘的解是什么？它与「换内积」是什么关系？与普通最小二乘有什么关系？
::: sol
设 $W$ 对称正定、$A$ 列满秩，则 $\hat{\boldsymbol x}=(A^{\mathrm T}WA)^{-1}A^{\mathrm T}W\boldsymbol b$，满足加权正态方程 $A^{\mathrm T}W(A\boldsymbol x-\boldsymbol b)=\boldsymbol0$。投影是 $A\hat{\boldsymbol x}$，不是系数向量 $\hat{\boldsymbol x}$；它是 $\boldsymbol b$ 在 $C(A)$ 上按加权内积 $\langle\cdot,\cdot\rangle_W$ 的正交投影。若 $W=L^{\mathrm T}L$，则等价于对 $LA\boldsymbol x\approx L\boldsymbol b$ 做普通最小二乘；秩亏时正态方程仍成立，但不可写上述逆矩阵公式（[@thm-sup-2.2.7]）。（✓ / △ / ×）
:::

**B9.** Gram–Schmidt 给出什么？QR 分解什么时候唯一？「分层张成」为什么重要？
::: sol
给出 $A=QR$：$Q=[\boldsymbol q_1,\dots,\boldsymbol q_n]$ 列正交、$R$ 上三角且 $r_{jj}=\lVert\boldsymbol v\rVert_2\gt0$；在「$R$ 对角元全为正」的规范化下分解**唯一**（否则可按列成对变号）。分层张成 $\operatorname{span}\{\boldsymbol q_1..\boldsymbol q_k\}=\operatorname{span}\{\boldsymbol a_1..\boldsymbol a_k\}$ 是 QR 区别于 SVD 的关键性质，也是 QR 迭代求特征值的基础；秩亏时改用列主元 QR（$AP=QR$，$|r_{11}|\ge\cdots$）（[@thm-sup-2.3.1]、[@thm-sup-2.3.2]）。（✓ / △ / ×）
上述唯一性指 $m\ge n$、$A$ 列满秩的薄 QR（$Q\in\mathbb R^{m\times n}$、$R\in\mathbb R^{n\times n}$）；全 QR 中补出的正交列并不唯一。
:::

**B10.** 四种正交化方法（CGS / MGS / Householder / Givens）的正交性损失各是什么量级？怎么选？
::: sol
在相应满秩、小误差与浮点假设下，CGS 与 MGS 的典型正交性损失分别为 $O(\mathrm{cond}^2u)$、$O(\mathrm{cond}\,u)$；Householder 与 Givens 通常为带维数因子的 $O(u)$。这些是条件性估计，不能按一个固定条件数断言所有输入都失效。选法：稠密用 Householder（LAPACK `geqrf`、NumPy 默认），稀疏 / 带状 / 局部修改用 Givens（一次只动两行），需要显式 $Q$ 且条件数温和时可用 MGS，CGS 只用于教学（[2.3.3](sec23.md#sup-2.3.3) 对比表、[@thm-sup-2.3.3]、[@thm-sup-2.3.4]）。（✓ / △ / ×）
:::

**B11.** 用 QR 解最小二乘要解什么方程？为什么它比正态方程好，好在哪个量级？
::: sol
把 $A$ 的全 QR 代入：$\lVert A\boldsymbol x-\boldsymbol b\rVert^2=\lVert R\boldsymbol x-\boldsymbol c\rVert^2+\lVert\boldsymbol d\rVert^2$（$\boldsymbol c$ 为 $Q^{\mathrm T}\boldsymbol b$ 前 $n$ 行），故解上三角方程 $R\hat{\boldsymbol x}=\boldsymbol c$（回代 $O(n^2)$），最小残差范数 $=\lVert\boldsymbol d\rVert_2$。**不形成 $A^{\mathrm T}A$**，避免显式法方程的额外误差。相容或小残差情形下，常比较 $\mathrm{cond}^2u$ 与 $\mathrm{cond}\,u$；一般不相容问题还要考虑残差相关的敏感性，不能承诺 QR 的前向误差总为后一个量级（[@thm-sup-2.3.5]、[2.3.6](sec23.md#sup-2.3.6)）。（✓ / △ / ×）
:::

**B12.** 条件数的五条基本性质 + 两条扰动界 + 「丢几位」的估计。
::: sol
$\mathrm{cond}(A)\ge1$（算子范数下）；$\mathrm{cond}(A^{-1})=\mathrm{cond}(A)$；$\mathrm{cond}(cA)=\mathrm{cond}(A)$；$\mathrm{cond}_2(Q)=1$；$\mathrm{cond}(AB)\le\mathrm{cond}(A)\mathrm{cond}(B)$（一般不是等式）。右端扰动 $\dfrac{\lVert\delta\boldsymbol x\rVert}{\lVert\boldsymbol x\rVert}\le\mathrm{cond}\dfrac{\lVert\delta\boldsymbol b\rVert}{\lVert\boldsymbol b\rVert}$（紧界）；系数扰动 $\le\dfrac{\mathrm{cond}}{1-\mathrm{cond}\rho_A}(\rho_A+\rho_b)$，要求 $\mathrm{cond}\cdot\rho_A\lt1$。丢失位数 $k\approx\log_{10}\mathrm{cond}$；$\mathrm{cond}\,u$ 接近 1 时，最坏情形估计通常已不能保证可靠数字，但不表示每个具体右端都无法准确求解（[@thm-sup-2.4.1]–[@thm-sup-2.4.3]、[2.4.2](sec24.md#sup-2.4.2)）。（✓ / △ / ×）
上述逆矩阵扰动界要求 $A$ 非奇异、$\boldsymbol b\ne0$，并使用同一向量范数及其诱导矩阵范数；$\rho_A=\lVert\delta A\rVert/\lVert A\rVert$、$\rho_b=\lVert\delta\boldsymbol b\rVert/\lVert\boldsymbol b\rVert$，缩放常数须非零，$Q$ 为正交方阵。
:::

**B13.** 「残差小」为什么推不出「误差小」？正确的判据是什么？
::: sol
设 $A$ 非奇异且 $\boldsymbol b\ne0$，$\boldsymbol e=\hat{\boldsymbol x}-\boldsymbol x=-A^{-1}\boldsymbol r$，所以 $\lVert\boldsymbol e\rVert/\lVert\boldsymbol x\rVert\le\mathrm{cond}(A)\lVert\boldsymbol r\rVert/\lVert\boldsymbol b\rVert$。应将此上界与目标容差比较，而不能只看残差；上界大不等于实际误差必然大。记录中的例子相对残差为 $2.5\times10^{-12}$，相对误差可达 $50\%$。小残差只描述该次计算的后向扰动，不能自动证明求解器对所有输入后向稳定（[@thm-sup-2.4.4]）。（✓ / △ / ×）
:::

**B14.** 谱半径与范数是什么关系？Gerschgorin 圆盘定理说了什么、怎么用？
::: sol
$\rho(A)\le\lVert A\rVert$ 对任何相容范数成立，但可**远小于**范数（Jordan 块：$\rho=1$、$\lVert\cdot\rVert_2\approx1000$）。Gerschgorin：$\lvert\lambda-a_{ii}\rvert\le r_i=\sum_{j\neq i}\lvert a_{ij}\rvert$（行版本，列版本对 $A^{\mathrm T}$ 用），全部特征值落在圆盘并集内；若 $k$ 个圆盘构成与其他圆盘不相交的连通区域，则其中恰含 $k$ 个特征值；行、列两版本取**交集**可收紧围栏（注意：逐盘配对取交只是启发式）。严格对角占优 $\lvert a_{ii}\rvert\gt r_i\ \forall i$ ⟹ $0\notin\cup D_i$ ⟹ 非奇异（[@thm-sup-2.5.2]、[2.5.2](sec25.md#sup-2.5.2)）。（✓ / △ / ×）
:::

**B15.** Rayleigh 商的两个极值性质是什么？Courant–Fischer 说了什么？幂法的收敛速度由谁决定？
::: sol
设 $A$ 实对称，特征值按 $\lambda_1\le\cdots\le\lambda_n$ 排列。$R(\boldsymbol x)=\boldsymbol x^{\mathrm T}A\boldsymbol x/\boldsymbol x^{\mathrm T}\boldsymbol x$（$\boldsymbol x\ne0$）是特征值的加权平均，故 $\lambda_{\min}=\min R$、$\lambda_{\max}=\max R$，极值点是对应特征空间中的非零向量。Courant–Fischer：$\lambda_k=\min_{\dim\mathcal S=k}\max_{0\ne\boldsymbol x\in\mathcal S}R(\boldsymbol x)$；对 $-A$ 使用该式得另一等式。幂法收敛率另按模排序：若 $|\mu_1|>|\mu_2|$、初向量的主特征分量非零，则方向误差为 $O(|\mu_2/\mu_1|^j)$，本对称情形的 Rayleigh 商误差为 $O(|\mu_2/\mu_1|^{2j})$。后者对方向误差二次敏感，不表示任意两种算法的步数必然恰差一倍（[@thm-sup-2.5.3]–[@thm-sup-2.5.5]）。（✓ / △ / ×）
:::

**B16.** 特征值对扰动有多敏感？对称情形、一般情形、重特征值情形各是什么结论？
::: sol
对称矩阵 $A$ 与对称扰动 $E$ 满足 Weyl 界：按相同次序排列的特征值有 $|\lambda_i(A+E)-\lambda_i(A)|\le\lVert E\rVert_2$。若 $A=V\Lambda V^{-1}$ 可对角化，Bauer–Fike 给出每个 $\mu\in\sigma(A+E)$ 到 $\sigma(A)$ 的距离不超过 $\mathrm{cond}_2(V)\lVert E\rVert_2$，不自动给出逐个编号的配对。缺陷特征值的最大 Jordan 块大小为 $k$ 时可能出现 $O(\lVert E\rVert^{1/k})$ 分裂；例 $\begin{pmatrix}0&1\\t&0\end{pmatrix}$ 的特征值为 $\pm\sqrt t$。不能仅凭“非正规”或“重特征值”就断言该分数次敏感性，半单重特征值也可保持线性量级（[@thm-sup-2.5.6]）。（✓ / △ / ×）
:::

**B17.** SVD 一次性交出哪些东西？（四个子空间的基 / 三个量 / 最优低秩逼近）
::: sol
$A=U\Sigma V^{\mathrm T}$，$\sigma_1\ge\cdots\ge\sigma_r\gt0$：$C(A)=\operatorname{span}\{\boldsymbol u_1..\boldsymbol u_r\}$、$N(A^{\mathrm T})=\operatorname{span}\{\boldsymbol u_{r+1}..\boldsymbol u_m\}$、$C(A^{\mathrm T})=\operatorname{span}\{\boldsymbol v_1..\boldsymbol v_r\}$、$N(A)=\operatorname{span}\{\boldsymbol v_{r+1}..\boldsymbol v_n\}$（都是**标准正交**基，不必再补 Gram–Schmidt）；$\lVert A\rVert_2=\sigma_1$、$\lVert A\rVert_F=\sqrt{\sum\sigma_i^2}$、$\mathrm{cond}_2=\sigma_1/\sigma_r$、$\operatorname{rank}A=\#\{\sigma_i\gt0\}$；Eckart–Young：$A_k=\sum_{i\le k}\sigma_i\boldsymbol u_i\boldsymbol v_i^{\mathrm T}$ 是**最优**秩 $k$ 逼近，$\lVert A-A_k\rVert_2=\sigma_{k+1}$ 精确成立（[@thm-sup-2.6.1]–[@thm-sup-2.6.4]）。（✓ / △ / ×）
这里 $\sigma_1/\sigma_r$ 在秩亏情形表示有效条件数，普通 2-条件数为无穷；$k$ 应满足 $0\le k<r$（$k\ge r$ 时可精确恢复，误差为零）。
:::

**B18.** 伪逆怎么定义、有哪些关键性质？为什么「不截断的伪逆」很危险？数值秩怎么定？
::: sol
$A^+=V\Sigma^+U^{\mathrm T}$（非零 $\sigma_i$ 取倒数、零仍记零）满足 Penrose 四条件且唯一。$AA^+$、$A^+A$ 分别投影到 $C(A)$、$C(A^{\mathrm T})$；$A^+\boldsymbol b$ 是唯一最小范数最小二乘解，其他解构成 $A^+\boldsymbol b+N(A)$，未必只是一条直线。列满秩时 $A^+=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$。绝对扰动放大由 $\lVert A^+\rVert_2=1/\sigma_r$ 控制，$\sigma_1/\sigma_r$ 是相应有效相对条件数；是否截断应按噪声与目标决定，不是所有问题都必须截断。数值秩可按 $\#\{i:\sigma_i>t\sigma_1\}$ 定义，$t$ 结合数据噪声；`matrix_rank` 默认相对阈值约为 $\max(m,n)u$，主要反映舍入尺度（[@thm-sup-2.6.3]、[2.6.4](sec26.md#sup-2.6.4)）。（✓ / △ / ×）
:::

::: think B 组的适用条件与常见越界{#rc2-b-conditions}
- 平行四边形恒等式是「范数来自内积」的**充要**判据（有限维版 Jordan–von Neumann），不能只查一半。
- $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ 的前提是 **$A$ 列满秩**；秩亏时只能用伪逆或列主元 QR。
- 「QR 唯一」只在 $R$ 对角元全为正的规范形式下成立；比较两套 $Q,R$ 前先统一符号。
- $\rho\lt1$ 只保证**渐近**收敛（$\rho=\lim_k\lVert A^k\rVert^{1/k}$），非正规矩阵可能先「瞬态增长」；稳妥判据是 $\lVert A\rVert\lt1$。
- Eckart–Young 保证**误差**最小，不保证最优矩阵唯一（$\sigma_k=\sigma_{k+1}$ 时最优子空间可旋转）。
:::

## C. 公式卡

**C1.** 诱导范数、平行四边形恒等式、极化恒等式。
::: sol
$\lVert\boldsymbol x\rVert=\sqrt{\langle\boldsymbol x,\boldsymbol x\rangle}$；$\lVert\boldsymbol x+\boldsymbol y\rVert^2+\lVert\boldsymbol x-\boldsymbol y\rVert^2=2\lVert\boldsymbol x\rVert^2+2\lVert\boldsymbol y\rVert^2$；$\langle\boldsymbol x,\boldsymbol y\rangle=\tfrac14(\lVert\boldsymbol x+\boldsymbol y\rVert^2-\lVert\boldsymbol x-\boldsymbol y\rVert^2)$（[@def-sup-2.1.1]、[@thm-sup-2.1.2]）。（✓ / △ / ×）
:::

**C2.** 标准正交基下：坐标、Parseval、投影公式。
::: sol
$\alpha_i=\langle\boldsymbol x,\boldsymbol q_i\rangle$；$\lVert\boldsymbol x\rVert^2=\sum_i\lvert\alpha_i\rvert^2$；$\boldsymbol p=\sum_i\langle\boldsymbol x,\boldsymbol q_i\rangle\boldsymbol q_i$（[@thm-sup-2.1.4]、[@thm-sup-2.2.3]）。（✓ / △ / ×）
:::

**C3.** 四个子空间的维数与两个正交直和。
::: sol
$\dim C(A)=\dim C(A^{\mathrm T})=r$，$\dim N(A)=n-r$，$\dim N(A^{\mathrm T})=m-r$；$\mathbb R^n=C(A^{\mathrm T})\oplus N(A)$、$\mathbb R^m=C(A)\oplus N(A^{\mathrm T})$（[@thm-sup-2.2.1]、[@thm-sup-2.2.2]）。（✓ / △ / ×）
:::

**C4.** 投影、投影矩阵、正态方程、加权版——四式一行收口。
::: sol
$\boldsymbol p=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol b$（记 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$）；$A^{\mathrm T}A\boldsymbol x=A^{\mathrm T}\boldsymbol b$；$\hat{\boldsymbol x}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol b$；加权 $\hat{\boldsymbol x}=(A^{\mathrm T}WA)^{-1}A^{\mathrm T}W\boldsymbol b$（[@thm-sup-2.2.5]–[@thm-sup-2.2.7]）。（✓ / △ / ×）
这些逆矩阵公式要求 $A$ 列满秩，加权式还要求 $W$ 对称正定；正态方程本身在秩亏时仍是最优性条件。
:::

**C5.** 三种正交化的**算法式**要点（CGS / MGS 系数、Householder 消元向量、Givens 的 $c,s,r$）。
::: sol
CGS：$r_{ij}=\boldsymbol q_i^{\mathrm T}\boldsymbol a_j$（原始列）；MGS：$r_{ij}=\boldsymbol q_i^{\mathrm T}\boldsymbol v$（当前列，就地更新）；Householder：$\alpha=-\operatorname{sgn}(x_1)\lVert\boldsymbol x\rVert_2$、$\boldsymbol v=\boldsymbol x-\alpha\boldsymbol e_1$、$H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}/\boldsymbol v^{\mathrm T}\boldsymbol v$（**首分量取相加，避免相消**）；Givens：$r=\texttt{hypot}(x_1,x_2)$、$c=x_1/r$、$s=x_2/r$（别手写 $\sqrt{x_1^2+x_2^2}$）（[@thm-sup-2.3.1]、[@thm-sup-2.3.3]、[@thm-sup-2.3.4]）。（✓ / △ / ×）
Householder 对非零 $\boldsymbol x$ 约定 $\operatorname{sgn}(0)=1$；零向量直接不作反射。Givens 在 $r=0$ 时取 $c=1,s=0$，不能除以零。
:::

**C6.** QR 解最小二乘的两式 + 四种方法的正交性损失与复杂度。
::: sol
$R\hat{\boldsymbol x}=(Q^{\mathrm T}\boldsymbol b)_{1:n}$、$\lVert\boldsymbol r\rVert_2=\lVert\boldsymbol d\rVert_2$。损失：CGS $\mathrm{cond}^2u$、MGS $\mathrm{cond}\,u$、Householder $\approx u$、Givens $\approx u$；复杂度：GS $2mn^2$、Householder $2mn^2-\tfrac23n^3$、Givens $3mn^2-n^3$（后二者仅计形成 $R$ 的主要项）（[@thm-sup-2.3.5]、[2.3.5](sec23.md#sup-2.3.5) 对比表）。（✓ / △ / ×）
:::

**C7.** 条件数全量速记（定义 + 两界 + 位数 + 残差关系）。
::: sol
$\mathrm{cond}=\lVert A\rVert\lVert A^{-1}\rVert$；非奇异方阵 $\mathrm{cond}_2=\sigma_1/\sigma_n$。右端扰动界为 $\lVert\delta\boldsymbol x\rVert/\lVert\boldsymbol x\rVert\le\mathrm{cond}\,\lVert\delta\boldsymbol b\rVert/\lVert\boldsymbol b\rVert$；系数和右端同时扰动时界为 $\mathrm{cond}(\rho_A+\rho_b)/(1-\mathrm{cond}\rho_A)$，要求 $\mathrm{cond}\rho_A<1$。$\boldsymbol e=\hat{\boldsymbol x}-\boldsymbol x$、$\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$ 时 $\boldsymbol e=-A^{-1}\boldsymbol r$（[@thm-sup-2.4.1]–[@thm-sup-2.4.4]）。（✓ / △ / ×）
:::

**C8.** 谱侧四式：$\rho\le\lVert A\rVert$、Gerschgorin、幂法/Rayleigh 收敛率、扰动界。
::: sol
$\rho(A)\le\lVert A\rVert$（相容范数）；$|\lambda-a_{ii}|\le\sum_{j\ne i}|a_{ij}|$。实对称矩阵有按模唯一主特征值且初向量含主分量时，幂法方向误差为 $O(|\lambda_2/\lambda_1|^j)$、Rayleigh 商误差为 $O(|\lambda_2/\lambda_1|^{2j})$。对称扰动满足 Weyl 界；可对角化矩阵满足 Bauer–Fike 距离界；最大 Jordan 块大小为 $k$ 的缺陷特征值可能有 $O(\lVert E\rVert^{1/k})$ 分裂，详见 B15–B16（[@thm-sup-2.5.2]、[@thm-sup-2.5.3]、[@thm-sup-2.5.6]）。（✓ / △ / ×）
:::

**C9.** $R(\boldsymbol x)$ 的定义、Courant–Fischer 两个等式、反幂法要点。
::: sol
$R(\boldsymbol x)=\boldsymbol x^{\mathrm T}A\boldsymbol x/\boldsymbol x^{\mathrm T}\boldsymbol x$；$\lambda_k=\min_{\dim\mathcal S=k}\max_{\boldsymbol x\in\mathcal S}R=\max_{\dim\mathcal T=n-k+1}\min_{\boldsymbol x\in\mathcal T}R$；反幂法把 $A$ 换成 $(A-\mu I)^{-1}$，收敛到**最接近 $\mu$** 的特征值，每步解一个方程组而不显式求逆（[@def-sup-2.5.2]、[@thm-sup-2.5.5]、[2.5.3](sec25.md#sup-2.5.3)）。（✓ / △ / ×）
极小极大公式要求 $A$ 实对称、$\lambda_1\le\cdots\le\lambda_n$，内层极值均排除零向量。反幂法要求 $A-\mu I$ 非奇异，并有按距离唯一的目标特征值及非零初始分量等收敛条件。
:::

**C10.** SVD 全量：分解、外积、范数、伪逆、Eckart–Young、与 PCA 的关系。
::: sol
$A=U\Sigma V^{\mathrm T}$；$A=\sum_{i\le r}\sigma_i\boldsymbol u_i\boldsymbol v_i^{\mathrm T}$；$\lVert A\rVert_2=\sigma_1$、$\lVert A\rVert_F=\sqrt{\sum_i\sigma_i^2}$、$\mathrm{cond}_2=\sigma_1/\sigma_r$；$A^{+}=V\Sigma^{+}U^{\mathrm T}$；$\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_2=\sigma_{k+1}$、F 版 $=\sqrt{\sum_{i\gt k}\sigma_i^2}$；PCA：主方向 $=V$ 的列、主成分方差 $=\sigma_i^2/(n-1)$、$\sigma_i(X_c)=\sqrt{(n-1)\lambda_i(C)}$（中心化后）（[@thm-sup-2.6.1]–[@thm-sup-2.6.4]、[2.6.6](sec26.md#sup-2.6.6)）。（✓ / △ / ×）
条件数的秩亏约定同 A9；PCA 式中样本按行排列，样本数为 $N>1$ 时分母是 $N-1$，不是特征数减一。
:::

::: method C 组的适用条件{#rc2-c-conditions}
- 所有「$A^{\mathrm T}A$ 型」公式（正态方程、$\mathrm{cond}_2=\sigma_1/\sigma_r$ 的 $A^{\mathrm T}A$ 算法）都受 $\mathrm{cond}^2$ 影响：能用 SVD / QR 就别显式形成 $A^{\mathrm T}A$。
- Householder 的符号选择用于防相消，Givens 的 `hypot` 用于降低中间上溢/下溢风险，MGS 的就地更新用于减轻正交性损失；三者作用不同，不能统一称为防相消。
- Eckart–Young 的等式 $\lVert A-A_k\rVert_2=\sigma_{k+1}$ 对任何 $k<r$ 都成立；用于压缩时还要看能量占比 $\sum_{i\le k}\sigma_i^2/\sum_i\sigma_i^2$。
- PCA 的方差解释须对数据按列中心化；低秩压缩不一定要求中心化，去噪阈值则要结合噪声模型。
:::

## D. 陷阱卡（每题先指出错在哪，再给正确说法）

**D1.** 「一组向量范数全为 $1$，就是标准正交基。」
::: sol
错。范数为 $1$ 只保证「标准」；「正交」必须**逐个验证两两内积**。教材 [@ex-sup-2.1.3] 的 $\boldsymbol r$ 组范数全对、$\boldsymbol r_1^{\mathrm T}\boldsymbol r_2=0$ 也对，但 $\boldsymbol r_2^{\mathrm T}\boldsymbol r_3=-2/\sqrt{18}\neq0$——套用坐标公式与 Parseval 会**同时静默失效**（拼回去 $=(20/3,10/3,-1/3)\neq\boldsymbol x$）。（✓ / △ / ×）
:::

**D2.** 「把 $\lVert\cdot\rVert_1$ 换成内积范数来定义正交，就能对 1-范数做投影与 SVD。」
::: sol
错。$\lVert\cdot\rVert_1$ 与 $\lVert\cdot\rVert_\infty$ 不满足平行四边形恒等式（取 $\boldsymbol x=(1,0),\boldsymbol y=(0,1)$：左端 $8$ 或 $2$，右端都是 $4$），**不来自任何内积**，因此没有正交、投影、SVD 这套结构。见到「正交」二字，默认内积是 Euclid 内积（[@ex-sup-2.1.2]、[2.1.4](sec21.md#sup-2.1.4) 错误 2）。（✓ / △ / ×）
:::

**D3.** 「$P^2=P$ 说明 $P$ 是正交投影矩阵」；「长方阵满足 $Q^{\mathrm T}Q=I_n$，所以 $QQ^{\mathrm T}=I_m$。」
::: sol
两处都错。① 正交投影要求**对称 + 幂等**；只幂等的是**斜投影**（例 $S=\begin{pmatrix}1&1\\0&0\end{pmatrix}$），其余项不垂直于子空间。② $QQ^{\mathrm T}$ 是到 $C(Q)$ 的投影矩阵，$\operatorname{tr}(QQ^{\mathrm T})=n\lt m$，故 $QQ^{\mathrm T}\neq I_m$——「逆等于转置」只对方阵成立（[2.2.6](sec22.md#sup-2.2.6) 错误 5、[2.1.4](sec21.md#sup-2.1.4) 错误 4）。（✓ / △ / ×）
:::

**D4.** 「Gram–Schmidt 就用经典版（CGS），它与修正版数学上等价」；「用 QR 解最小二乘，先算 $A^{\mathrm T}A$ 更省事。」
::: sol
两处都错。① CGS 与 MGS 精确算术下等价，浮点下典型正交误差界分别为带维数因子的 $O(\mathrm{cond}_2(A)^2u)$、$O(\mathrm{cond}_2(A)u)$，须满足相应满秩及小误差假设，不能以 $10^8$ 作为统一失效线。记录中 $n=16$ 的例子，CGS 正交误差为 $6.55$，MGS 为 $4.7\times10^{-4}$，Householder 为 $3.0\times10^{-15}$。② 列满秩时 $\mathrm{cond}_2(A^{\mathrm T}A)=\mathrm{cond}_2(A)^2$；对相容或小残差问题，常比较法方程的 $\mathrm{cond}^2u$ 与 QR 的 $\mathrm{cond}\,u$，一般不相容问题还须考虑残差相关敏感性。记录中的 $\mathrm{cond}\approx6\times10^{10}$ 例子，法方程误差为 $28$（真值 $1$）、QR 为 $2.2\times10^{-6}$，不是所有输入的固定误差（[2.3.6](sec23.md#sup-2.3.6) 实测表）。（✓ / △ / ×）
:::

**D5.** 「最小二乘解总是存在且唯一，直接解正态方程就行。」
::: sol
错两处。① 最小二乘解总存在，但唯一性要求 $A$ 列满秩；秩亏时解构成仿射集，可用伪逆选最小范数解。② 在 2-范数下显式正态方程会平方条件数。计算后应检查尺度化的 $A^{\mathrm T}\boldsymbol r$ 是否足够小，不能在浮点下要求精确为零。残差分量和为零只检验了常数列；例如拟合基为 $1,x$ 时还须检查 $\sum_i x_ir_i$，一般基则逐列检查（[2.2.6](sec22.md#sup-2.2.6) 错误 1、4）。（✓ / △ / ×）
:::

**D6.** 「求解器报的残差是 $10^{-15}$，所以解准到 15 位」；「同一个病态矩阵，换 Cholesky / QR / SVD 就能算准。」
::: sol
两处都错。① 相对残差须结合条件数才能给出前向误差上界；例中相对残差 $2.5\times10^{-12}$ 而误差为 $50\%$。② 病态是问题对输入扰动的敏感性，稳定算法不能消除它，但算法的实际误差并不一定相同。可结合输入精度、残差计算精度与扰动模型评估迭代精化、缩放、正则化或提高精度（[@thm-sup-2.4.4]、[2.4.6](sec24.md#sup-2.4.6)）。（✓ / △ / ×）
:::

**D7.** 「用 $\rho(A)$ 代替 $\lVert A\rVert$ 估收敛；$\rho\lt1$ 就每步收缩」；「重特征值也能算准」；「Gerschgorin 圆盘给的是特征值近似值。」
::: sol
三处都错。① $N=\begin{pmatrix}1&1000\\0&1\end{pmatrix}$ 有 $\rho=1$、$\lVert N\rVert_2\approx1000$，且 $\lVert N^j\rVert$ 可线性增长；换成 $aN$、$0<a<1$，可同时有 $\rho<1$ 与先增长后衰减。$\lVert A\rVert<1$ 是每步收缩的充分条件，不是渐近收敛的必要条件。② 大小为 $k$ 的缺陷 Jordan 块可能将 $O(\varepsilon)$ 扰动放大为 $O(\varepsilon^{1/k})$ 位移；$k=2$ 的构造在双精度扰动尺度上可能只剩约 8 位，但并非所有重特征值都如此。③ Gerschgorin 给复平面中的圆盘并集围栏；行、列两个并集可取交，圆心不是自动可靠的近似值，即使严格对角占优仍须看半径大小（[@thm-sup-2.5.2]、[2.5.6](sec25.md#sup-2.5.6) 错误 1–4）。（✓ / △ / ×）
:::

**D8.** 「$\sigma_i(A)=\lvert\lambda_i(A)\rvert$」；「先算 $A^{\mathrm T}A$ 的特征值再开方就是 SVD」；「伪逆不用截断、数值秩用库函数默认阈值即可」；「PCA 不中心化也一样」。
::: sol
四处说法均不成立。① 奇异值与特征值只在正规矩阵上有按适当次序排列的 $\sigma_i=|\lambda_i|$；反例 $A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$ 的特征值全零而 $\sigma_1=1$。② 2-范数下形成 $A^{\mathrm T}A$ 会平方条件数，较小奇异值可能受严重相对误差影响，但不能说每个奇异值都固定丢一半位数；实际可用直接 SVD 算法（如 `np.linalg.svd`）。③ 伪逆的绝对放大因子是 $1/\sigma_r$，是否截断、如何选 `rcond` 要结合噪声和目标；默认数值秩阈值主要反映舍入尺度，不替代噪声模型（记录中的例子默认判秩 $20$、按噪声阈值为 $3$）。④ 不中心化时 SVD 描述二阶矩而非中心化方差；均值可能主导首方向，但首方向并不必然等于均值方向（[2.6.7](sec26.md#sup-2.6.7) 错误 1–7、[@ex-sup-2.6.5]）。（✓ / △ / ×）
:::

::: think D 组的典型误用清单（考前扫一眼）{#rc2-d-misuse}
① 单位范数不等于标准正交；② 不能把 1-/∞-范数直接当内积诱导范数；③ 正交投影须对称且幂等，长方阵不可套 $Q^{-1}=Q^{\mathrm T}$；④ 区分 CGS 与 MGS 的浮点实现；⑤ 病态最小二乘慎用显式法方程，按尺度检查 $A^{\mathrm T}\boldsymbol r$；⑥ 残差不是误差，缩放和换算法不能消除输入敏感性；⑦ 谱半径不保证每步收缩，重特征值的敏感性要看结构，Gerschgorin 给围栏而非精确值；⑧ 小奇异值计算须注意 Gram 矩阵路线的误差，截断依赖噪声，PCA 方差解释须中心化。
:::

## 导出到 Anki / CSV

1. **建卡组**：打开 Anki → 新建卡组「数值分析-补充篇」（与「数值分析-第 1 章」并列，不要混在默认卡组里）。
2. **逐条录入**：正面放「编号 + 题干」，背面放「答案 + 依据」（带 [@编号] 与节号）；纯文本批量导入用 `Tab` 分隔「正面 / 背面」，一行一张卡——本页 46 张按 **A1–A10 / B1–B18 / C1–C10 / D1–D8** 的顺序录。
3. **复习节点（1 / 3 / 7 天）**：当天 → 隔天 → 第 3 天 → 第 7 天共四轮；每轮只重做标 **△** 与 **×** 的卡。本页的错误几乎全部发生在**条件**上（列满秩、$R$ 对角元为正、$\mathrm{cond}\cdot\rho_A\lt1$、噪声水平定阈值），凡「能背出结论但说不出条件」一律按 △ 处理。
4. **加一道保险**：C 组（公式卡）背面附一张手写照片；四轮后仍为 × 的卡抄进[第二章的小结与陷阱](sec28.md#sup-2.8.2)对应的那一条，作为个人薄弱点单独跟踪。全章公式的两页压缩见[公式与结论卡](../review/formula-cards.md)与[易混对照卡](../review/contrast-cards.md)。
