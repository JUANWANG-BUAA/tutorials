# 术语索引 · 中英对照

按主题分组。中文列是你在书里会看到的中文术语，英文列是英文对照（读英文教材、查库文档、看论文时用），「一句话」列给白话解释，出处列是**定义出现的准确位置**——不是页码，是可点击的编号。查概念时先在这里定位，再跳过去读定义。

> 本页逐条索引**第一章 + 补充篇（矩阵工具箱）**；老师主线第 2–7 章的课堂口径与标准术语对照集中在[易混对照卡 §17](contrast-cards.md#17--课堂口径--标准术语统一对照)，各讲页另收口误/同音词。

::: note 这一页只回答「叫什么、在哪」——公式在别处
**这一页不放公式**，只给术语名、英文、一句白话解释和定义位置。要查公式与结论去[公式与结论卡](formula-cards.md)；要辨析易混概念去[易混对照卡](contrast-cards.md)。

分工是刻意的：术语索引解决「我想查的东西叫什么名字、定义在哪」，公式卡解决「这个结论怎么写」。两页放同样的内容，既让人不知道查哪页，也会两处一起过期。

同义说法也收在这一页（如「谱范数 = 2-范数 = 最大奇异值」「舍入误差 = 计算误差」），所以忘了叫法也能找到。
:::

## 一 · 误差与浮点

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 模型误差 | model error | 数学模型与所描述的实际问题之间的差 | [@def-1.2.1] |
| 观测误差 | observation error | 观测数据与真实数据的差 | [@def-1.2.2] |
| 截断误差（方法误差） | truncation error | 也叫方法误差：无穷过程截成有限步造成的差 | [@def-1.2.3] |
| 舍入误差（计算误差） | rounding / roundoff error | 也叫计算误差：有限字长存不下数造成的差 | [@def-1.2.4] |
| 绝对误差 / 误差限 | absolute error / error bound | 近似值与真值之差（绝对误差），以及该差绝对值的上界（误差限） | [@def-1.2.5] |
| 相对误差 / 相对误差限 | relative error / bound | 误差占近似值的比例（相对误差），以及该比例的上界（相对误差限） | [@def-1.2.6] |
| 有效数字 | significant digits | 从首位非零数字数起、敢担保的位数 | [@def-1.2.7] |
| 算法 | algorithm | 从输入算出解的一个有限基本运算序列 | [@def-1.2.8] |
| 数值稳定性 | numerical stability | 算法能控制舍入误差的传播、不把它放大 | [@def-1.2.9] |
| 浮点数集 | floating-point set | 字长有限时可精确表示的数集 | [@def-1.2.10] |
| 机器精度 | machine epsilon | 1 附近相邻浮点数之间「一步能迈多大」的相对刻度 | [@def-1.2.10] |
| 单位舍入误差 | unit roundoff | 每次浮点运算相对误差的上界，双精度约 $10^{-16}$ | [@def-1.2.10] |
| 向前误差 | forward error | 结果离真值多远 | [@def-1.2.11] |
| 向后误差 | backward error | 把计算结果看作精确解所需的最小输入扰动 | [@def-1.2.11] |
| 向后稳定 | backward stable | 算法的向后误差与机器舍入同量级 | [1.2.6](../ch01/sec12.md#sec-1.2.6) |
| 条件数（函数） | condition number | 函数层面的敏感度：输入相对扰动传到输出的放大倍数 | [1.2.6](../ch01/sec12.md#sec-1.2.6) |
| 灾难性抵消 | catastrophic cancellation | 相近数相减导致有效数字大量丢失 | [@ex-1.2.7] |
| 大 $O$ 记号 | big-O notation | 刻画计算量随规模增长的阶，忽略常数因子 | [1.2.4](../ch01/sec12.md#sec-1.2.4) |
| 计算复杂性 | computational complexity | 达到给定精度所需的时间与空间 | [1.2.4](../ch01/sec12.md#sec-1.2.4) |

## 二 · 范数

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 向量范数 | vector norm | 满足正定、齐次、三角不等式的「长度」 | [@def-1.3.1] |
| 1-范数 / 2-范数 / ∞-范数 | 1-, 2-, ∞-norm | 绝对值之和（1-范数）/ 欧氏长度（2-范数）/ 最大分量（∞-范数） | [@thm-1.3.1] |
| 欧几里得范数 | Euclidean norm | 和 2-范数指同一个东西，也叫欧氏范数 | [@thm-1.3.1] |
| $p$-范数 | $p$-norm | 一族范数，1、2、∞ 都是它的特例 | [@thm-1.3.2] |
| 范数等价 | equivalence of norms | 任意两种范数互相双向夹住，收敛结论不变 | [@thm-1.3.3] |
| 矩阵范数 | matrix norm | 满足四公理的矩阵「大小」；比向量范数多一条次可乘性 | [@def-1.3.2] |
| 次可乘性 | submultiplicativity | 矩阵乘积的范数不超过范数之积（只保证 $\le$ 方向） | [@def-1.3.2] |
| 相容性（适配） | compatible | 两种叫法指同一个东西：矩阵范数与向量范数配对时成立的那条不等式 | [@def-1.3.3] |
| 从属范数 / 算子范数 | subordinate / operator norm | 两种叫法指同一个东西：由向量范数诱导出的矩阵范数，即最大拉伸倍数 | [@thm-1.3.4] |
| 列范数 / 行范数 | column-sum / row-sum norm | 矩阵 1-范数按列和算（列范数），∞-范数按行和算（行范数） | [@thm-1.3.5] |
| 谱范数 | spectral norm | 谱范数、2-范数、最大奇异值指同一个东西 | [@thm-1.3.5] |
| Frobenius 范数（Euclid 范数） | Frobenius norm | 和 Euclid 范数指同一个东西：全部元素平方和开方；相容但**不**从属 | [@def-1.3.4] |
| 反三角不等式 | reverse triangle inequality | 两个向量长度之差，不超过它们作差所得向量的长度 | [1.3.1](../ch01/sec13.md#sec-1.3.1) |
| 谱半径 | spectral radius | 矩阵特征值模的最大值；不超过任一相容范数 | [@def-sup-2.5.1] |
| Neumann 级数 | Neumann series | 矩阵版的等比级数：矩阵范数小于 1 时，逆矩阵可按它展开 | [@thm-1.3.7] |

## 三 · 内积与正交

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 内积 / 内积空间 | inner product / inner product space | 内积是满足对称、线性、正定的二元函数；装上内积的向量空间叫内积空间 | [@def-sup-2.1.1] |
| 加权内积 | weighted inner product | 用正定矩阵加权的内积 | [@ex-sup-2.1.1] |
| 诱导范数 | induced norm | 由内积定义的范数 | [@thm-sup-2.1.1] |
| 平行四边形恒等式 | parallelogram identity | 判定一个范数是否来自内积的判据 | [@thm-sup-2.1.2] |
| 极化恒等式 | polarization identity | 由范数反算内积 | [@thm-sup-2.1.2] |
| 正交 | orthogonal | 两个向量正交，指它们的内积为零 | [@def-sup-2.1.2] |
| 标准正交组 / 标准正交基 | orthonormal set / basis | 组内向量两两正交且都是单位向量；若这组向量还构成基，就称标准正交基 | [@def-sup-2.1.2] |
| 正交矩阵 | orthogonal matrix | 列向量标准正交的方阵；保内积、保范数，条件数为 1 | [@def-sup-2.1.3] |
| 正交变换 | orthogonal transformation | 用正交矩阵做的变换，不放大误差 | [@thm-sup-2.1.6] |
| 正交不变性 | orthogonal invariance | 左乘正交阵不改变 2-范数与 F-范数 | [@thm-sup-2.1.6] |
| Parseval 恒等式 | Parseval's identity | 标准正交基下，范数的**平方**等于各坐标平方和 | [@thm-sup-2.1.4] |

## 四 · 子空间与投影

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 列空间（值域） | column space / range | 也叫值域：$A$ 作用于全空间得到的像 | [@def-sup-2.2.1] |
| 零空间（核） | null space / kernel | 也叫核：被 $A$ 映为零向量的全体向量 | [@def-sup-2.2.1] |
| 行空间 | row space | $A^{\mathrm T}$ 的列空间 | [@def-sup-2.2.1] |
| 左零空间 | left null space | $A^{\mathrm T}$ 的零空间 | [@def-sup-2.2.1] |
| 秩定理 | rank–nullity theorem | 矩阵的秩与零空间维数之和等于它的列数 | [@thm-sup-2.2.1] |
| 正交补 | orthogonal complement | 与子空间中每个向量都正交的向量全体 | [@def-sup-2.2.2] |
| 正交分解 | orthogonal decomposition | 全空间写成列空间与左零空间的直和 | [@thm-sup-2.2.3] |
| 投影矩阵 | projection matrix | 把向量投到列空间的矩阵；它既对称又幂等 | [@thm-sup-2.2.5] |
| 斜投影 | oblique projection | 幂等但不对称的投影，残差不再垂直于目标子空间 | [@thm-sup-2.2.5] |
| 最小二乘 | least squares | 让残差 2-范数最小的解 | [@def-sup-2.2.3] |
| 正态方程 | normal equations | 最小二乘解所满足的方程组 | [@thm-sup-2.2.6] |
| 加权最小二乘 | weighted least squares | 换一个内积重新做最小二乘，公式结构不变 | [@thm-sup-2.2.7] |
| 残差 | residual | 右端向量减去算得的像 | [@thm-sup-2.4.4] |

## 五 · 分解与正交化

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 经典 Gram–Schmidt | classical Gram–Schmidt (CGS) | 用**原始**列算系数；正交性损失大 | [@thm-sup-2.3.1] |
| 修正 Gram–Schmidt | modified Gram–Schmidt (MGS) | 用**当前**列算系数；稳定性好一个条件数 | [2.3.3](../supplement/sec23.md#sup-2.3.3) |
| QR 分解 | QR factorization | 拆成一个正交阵乘一个上三角阵 | [@thm-sup-2.3.2] |
| Householder 反射（初等反射矩阵） | Householder reflection | 也叫初等反射矩阵：镜像变换，一次消掉一整列 | [@def-sup-2.3.1] |
| 反射向量 | Householder vector | 确定镜面的法向量；符号的选择是为避免相近数相减 | [@def-sup-2.3.1] |
| Givens 旋转 | Givens rotation | 平面旋转，一次只消一个元素；保定向 | [@def-sup-2.3.2] |
| 列主元 QR | column-pivoted QR | 按列范数选主元的 QR，顺带给出秩的估计 | [@thm-sup-2.3.2] |
| 全 QR | full QR | 把瘦 QR 的 $Q$ 补足成一个正交方阵 | [@thm-sup-2.3.2] |
| 奇异值分解 | singular value decomposition (SVD) | 正交 – 对角 – 正交的分解 | [@thm-sup-2.6.1] |
| 奇异值 | singular value | $A^{\mathrm T}A$ 特征值的非负平方根，降序排列 | [@thm-sup-2.6.1] |
| 瘦 / 满 SVD | economy / full SVD | 只留秩那么多列的叫瘦 SVD，$U,V$ 都是方阵的叫满 SVD | [2.6.1](../supplement/sec26.md#sup-2.6.1) |
| Moore–Penrose 伪逆 | pseudoinverse | 非零奇异值取倒数、零保持零得到的广义逆 | [@def-sup-2.6.1] |
| Penrose 四条件 | Penrose conditions | 唯一刻画伪逆的四条等式 | [@thm-sup-2.6.3] |
| Eckart–Young 定理 | Eckart–Young theorem | 截断 SVD 是 2-范数与 F-范数下的**最优**秩 $k$ 逼近 | [@thm-sup-2.6.4] |
| 低秩逼近 | low-rank approximation | 截断 SVD：前 $k$ 项外积之和 | [@thm-sup-2.6.4] |
| 数值秩 | numerical rank | 按阈值数非零奇异值的个数；该阈值须按噪声水平选取 | [2.6.4](../supplement/sec26.md#sup-2.6.4) |
| 核范数 | nuclear norm | 奇异值之和 | [@ex-sup-2.6.4] |
| 主成分分析 | principal component analysis (PCA) | 用 SVD 找出数据方差最大的方向 | [2.6.6](../supplement/sec26.md#sup-2.6.6) |
| 填充 | fill-in | 稀疏矩阵分解时新产生的非零元 | [2.3.5](../supplement/sec23.md#sup-2.3.5) |

## 六 · 条件数与谱

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 条件数（矩阵） | condition number | 矩阵范数与其逆矩阵范数之积；衡量矩阵问题的固有敏感度 | [@def-sup-2.4.1] |
| 谱条件数 | spectral condition number | 2-范数下的条件数，等于首末奇异值之比 | [@def-sup-2.4.1] |
| 成分条件数 / Skeel 条件数 | componentwise / Skeel condition number | 两种叫法指同一个东西：元素扰动下的正确度量，用绝对值矩阵定义 | [2.4.4](../supplement/sec24.md#sup-2.4.4) |
| 特征值 / 特征向量 | eigenvalue / eigenvector | $A$ 只做伸缩的方向（特征向量），及伸缩的倍数（特征值） | [@def-sup-2.5.1] |
| 谱 | spectrum | 全部特征值的集合 | [@def-sup-2.5.1] |
| Gerschgorin 圆盘 | Gerschgorin disk | 由对角元与同行非对角元之和围出的圆盘，特征值都落在其中 | [@thm-sup-2.5.2] |
| 严格对角占优 | strictly diagonally dominant | 对角元大于同行其余元素绝对值之和，则矩阵**非奇异** | [@thm-sup-2.5.2] |
| Rayleigh 商 | Rayleigh quotient | 二次型与向量范数平方之比；矩阵对称时，它给出特征值的上下界 | [@def-sup-2.5.2] |
| Courant–Fischer 极小极大原理 | Courant–Fischer min-max | 全部特征值的变分刻画 | [@thm-sup-2.5.5] |
| 幂法 | power method | 迭代求按模最大的特征值的方法 | [@thm-sup-2.5.3] |
| 反幂法 | inverse iteration | 求最接近给定 $\mu$ 的特征值 | [2.5.3](../supplement/sec25.md#sup-2.5.3) |
| Weyl 不等式 | Weyl's inequality | 对称矩阵特征值的绝对扰动界 | [@thm-sup-2.5.6] |
| Bauer–Fike 定理 | Bauer–Fike theorem | 一般矩阵的谱扰动界，含特征向量矩阵的条件数 | [@thm-sup-2.5.6] |
| 非正规矩阵 | nonnormal matrix | 特征向量不正交；它的特征值对扰动可开方敏感 | [@ex-sup-2.5.6] |
| 伪谱 | pseudospectrum | 非正规矩阵「近似特征值」构成的集合 | [@ex-sup-2.5.6] |

## 七 · 算法与复杂度（含课堂术语）

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 秦九韶法（Horner 格式） | Horner's method | 也叫 Horner 格式：把多项式求值降到线性复杂度 | [1.2.4](../ch01/sec12.md#sec-1.2.4) |
| 高斯消去法 | Gaussian elimination | 初等行变换化成上三角再回代 | [第 3 讲](../lectures/lec03.md) |
| 列主元高斯消去法 | Gaussian elimination with partial pivoting | 每步选绝对值最大的主元，使乘数不超过 1 | [第 3 讲](../lectures/lec03.md) |
| 回代 / 前代 | backward / forward substitution | 回代解上三角方程组，前代解下三角方程组 | [第 4 讲](../lectures/lec04.md) |
| LU 分解（Doolittle） | LU factorization | 也叫 Doolittle 分解：一次分解，反复用于不同右端 | [第 4 讲](../lectures/lec04.md) |
| 追赶法 | Thomas algorithm | 三对角方程组的线性复杂度解法 | [第 4 讲](../lectures/lec04.md) |
| 矩阵分裂 | matrix splitting | 把矩阵拆成「好求逆的部分」与剩余部分 | [第 4 讲](../lectures/lec04.md) |
| 迭代矩阵 | iteration matrix | 迭代格式的系数矩阵；迭代收敛当且仅当它的谱半径小于 1 | [第 5 讲](../lectures/lec05.md) |
| 谱半径判据 | spectral radius criterion | 迭代收敛的**充要条件**：迭代矩阵的谱半径小于 1 | [第 5 讲](../lectures/lec05.md) |
| 先验 / 后验误差估计 | a priori / a posteriori estimate | 先验估计用初值，后验估计用相邻迭代差 | [第 5 讲](../lectures/lec05.md) |
| Jacobi 迭代 | Jacobi iteration | 按对角 / 非对角分裂 | [第 5 讲](../lectures/lec05.md) |
| Gauss–Seidel 迭代 | Gauss–Seidel iteration | 按上 / 下三角分裂，新分量立刻投入使用 | [第 5 讲](../lectures/lec05.md) |
| 逐次超松弛法 | successive over-relaxation (SOR) | 用松弛因子加权；取 1 退化为 Gauss–Seidel | [第 6 讲](../lectures/lec06.md) |
| 松弛因子 | relaxation parameter | SOR 的参数；落在 $(0,2)$ 之外**必不收敛** | [第 6 讲](../lectures/lec06.md) |
| Ostrowski 定理 | Ostrowski's theorem | 对称正定时 SOR 的收敛范围放宽到 $(0,2)$ | [第 6 讲](../lectures/lec06.md) |
| 幂法 | power method | 每步「先单位化再乘 $A$」，迭代出按模最大的特征值及其特征向量 | [第 7 讲](../lectures/lec07.md) |
| 反幂法 | inverse power method | 对 $A^{-1}$ 用幂法求按模最小的特征值；实际每步解 $Au_{k+1}=y_k$ | [第 7 讲](../lectures/lec07.md) |
| 位移反幂法 | shifted inverse iteration | 对 $A-pI$ 用反幂法，求最接近已知近似 $p$ 的特征值，结果再加回 $p$ | [第 7 讲](../lectures/lec07.md) |
| 二分法 | bisection method | 连续函数两端异号即折半定位；误差随区间长 $(b-a)/2^n$ 下降 | [第 7 讲](../lectures/lec07.md) |
| 不动点迭代 | fixed-point iteration | 把 $f(x)=0$ 改写为 $x=\varphi(x)$ 后迭代，极限即不动点 | [第 7 讲（引入）](../lectures/lec07.md) · [第 8 讲（理论）](../lectures/lec08.md) |
| 压缩映射 | contraction mapping | $\lvert\varphi'\rvert\le L\lt1$；与「自映射」一起保证收敛到唯一不动点 | [第 8 讲](../lectures/lec08.md) |
| Krylov 子空间方法 | Krylov subspace method | GMRES 等大规模迭代解法 | [第 4 讲](../lectures/lec04.md) |

## 八 · 记法速查

只列**纯记法约定**；符号的含义见前七节或[符号表](../preface-notation.md)。

| 记号 | 读法 / 含义 | 出处 |
|:--|:--|:--|
| $\boldsymbol{x}$、$A$ | 向量用粗体小写，矩阵用大写斜体 | [符号表](../preface-notation.md) |
| $C(A)$、$N(A)$ | 列空间、零空间（也可写 $\operatorname{Ran}A$、$\operatorname{Null}A$） | [符号表](../preface-notation.md) |
| $\lVert\cdot\rVert$ | 不指明哪一种范数时的泛指记号 | [符号表](../preface-notation.md) |
| $\sigma_i(A)$、$\rho(A)$ | 奇异值（降序）、谱半径 | [符号表](../preface-notation.md) |
| $u$、$\mathrm{eps}$ | 单位舍入误差、机器精度（前者是后者的一半） | [符号表](../preface-notation.md) |
| $m_{ik}$ | 高斯消去的消元乘数 | [第 3 讲](../lectures/lec03.md) |
| $\omega$ | SOR 的松弛因子 | [第 6 讲](../lectures/lec06.md) |
| $u_k$、$y_k$ | 幂法中的迭代向量、其单位化向量 | [第 7 讲](../lectures/lec07.md) |
| $p$ | 位移反幂法中的位移量（目标特征值的已知近似） | [第 7 讲](../lectures/lec07.md) |

::: note 讲座页的记号差异
课堂精编为忠实还原创课板书，有三处与正文不同：向量写作斜体 $x$、误差限用 $\varepsilon_x$、$P$ 兼作分裂剩余与特征向量矩阵（$D$ 兼作常数与对角块）。完整登记见[课堂精编导览](../lectures/overview.md#notation-diff)。
:::
