# 易混对照卡

本页把**第一章 + 补充篇（矩阵工具箱）**里最容易张冠李戴的十几对概念逐对摆在一起；老师主线第 2–5 章的易混点另见[课堂精编复习页](../lectures/review.md)。**每张卡的结构是固定的**：一句分辨口诀 → 对照表 → 一个反例或实测数字。复习时只看「口诀」那一行就够；做错题时再回来看表格。

::: note 为什么单独做这一页
这些概念在正文里都讲过，但**分散在不同小节**，学到后面就混了。数值分析考试的失分点几乎全在这里：不是不会算，而是用混了概念（把残差当误差、把 $\lVert A\rVert_2$ 当 $\lambda_{\max}(A)$、把 CGS 当 MGS）。把这些概念集中摆在一起，混淆的代价才看得见。
:::

## 1 · 有效数字 ⟷ 小数位数

**口诀：有效数字从第一个非零数字数起，与小数点无关；小数位数只看小数点后面。**

| | 有效数字 | 小数位数 |
|:--|:--|:--|
| 数法 | 从**第一位非零数字**到末位 | 从小数点到末位 |
| $3.1416$（对 $\pi$） | **5 位**（$3,1,4,1,6$） | 4 位 |
| $0.0316$（$\varepsilon=0.00005$） | **3 位**（$3,1,6$） | 4 位 |
| $2.1400$ | **5 位**（尾零有意义） | 4 位 |

反直觉实例：$\pi$ 的近似值 $3.1416$ 是「四舍五入到小数点后 4 位」，小数位数只有 4 位，有效数字却有 **5 位**——数法起点不同：有效数字的首位是 $3$，规格化后 $m=1$，有效数字的位数从十进制的高一位数起（[@ex-1.2.4]）。

## 2 · 绝对误差 ⟷ 相对误差

**口诀：绝对误差是「差多少」，相对误差是「差的比例」；测小量时看相对。**

| | 绝对误差 $\varepsilon$ | 相对误差 $\varepsilon_{\mathrm r}$ |
|:--|:--|:--|
| 定义 | $\lvert x-a\rvert$ 的上界 | $\varepsilon/\lvert a\rvert$ |
| 何时用 | 量具精度、单点误差保证 | 比较不同量级的近似质量 |
| 加法 | 相加（没法避免） | 分母 $\lvert a\pm b\rvert$ |
| $x=0$ 附近 | 可用 | **无定义** |

实测对照（[@ex-1.2.1]）：同一把卡尺量 $312$ mm 与 $24$ mm 的杆，绝对误差限同为 $0.5$ mm，相对误差限却分别是 $0.16\%$ 与 $2.08\%$——**同一把尺子，短杆的相对误差是长杆的 13 倍**。

## 3 · 病态问题 ⟷ 不稳定算法

**口诀：病态是问题的属性，换算法救不了；不稳定是算法的属性，换提法救不了。**

| | 病态（ill-conditioned） | 不稳定（unstable） |
|:--|:--|:--|
| 属于谁 | **问题**本身 | **算法** |
| 度量 | 条件数 $\mathrm{cond}$ 大 | 向后误差 $\gg u$ |
| 处方 | 重述问题 / 正则化 / 提高精度 | **换算法** |
| 例子 | 求二重根、Hilbert 矩阵 | 正向递推 $y_n=\frac1n-5y_{n-1}$、经典 Gram–Schmidt |

诊断矩阵（[1.2.6](../ch01/sec12.md#sec-1.2.6)）：

| | 问题良态 | 问题病态 |
|:--|:--|:--|
| **算法稳定** | 万事大吉 | 换提法（重述问题） |
| **算法不稳定** | 换算法 | 无药可救：重述 + 换算法 |

经典实例：求 $x^2-10^8x+1=0$ 的小根。**问题本身良态**（小根对系数的相对条件数 $\approx1$），但直接求根公式算出 $7.45\times10^{-9}$（相对误差 $25.5\%$）——误差全部来自算法的相近数相减：换成韦达公式后误差归零，问题不变、只换算法就能修好，账在算法不在问题（[@ex-1.2.7] 与 [1.2.6](../ch01/sec12.md#sec-1.2.6)）。

## 4 · 残差 ⟷ 误差

**口诀：残差能算（$b-Ax$ 只用已知量），误差不能算（$x^*-x$ 含未知量）；残差小绝不等于误差小。**

| | 残差 $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$ | 误差 $\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$ |
|:--|:--|:--|
| 可算吗 | **可算**（只用到已知量） | 不可算（$\boldsymbol{x}$ 未知） |
| 关系 | $\boldsymbol{e}=A^{-1}\boldsymbol{r}$ | — |
| 界 | $\dfrac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-2.4.4]） | — |

实测：条件数 $\sim10^{10}$ 的方程组，残差只有 $2.5\times10^{-12}$，误差却高达 $50\%$（[@ex-2.4.4]）。**报误差时不能拿残差顶替误差。**

## 5 · 特征值 ⟷ 奇异值

**口诀：特征值可负可复，个数 $=n$；奇异值恒非负，个数 $=\min(m,n)$（长方形矩阵也有）。**

| | 特征值 $\lambda_i(A)$ | 奇异值 $\sigma_i(A)$ |
|:--|:--|:--|
| 定义 | $\det(A-\lambda I)=0$ | $\sqrt{\lambda_i(A^{\mathrm T}A)}$ |
| 符号 | 可负、可复 | **恒 $\ge0$** |
| 个数 | $n$（方阵） | $\min(m,n)$（长方形也有） |
| 何时相等 | 对称 / 正规矩阵：$\sigma_i=\lvert\lambda_i\rvert$ | — |

反例：$A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$ 的 $\lambda_1=\lambda_2=0$，而 $\sigma_1=1$——特征值全为零，奇异值却不为零；非对称矩阵上两者对不上号，不能互相代入（[@ex-2.6.1] 的常见错误 1）。

## 6 · 谱半径 ⟷ 范数

**口诀：$\rho(A)\le\lVert A\rVert$ 是不等式，反向不成立；$\rho$ 管最终、范数管每一步。**

| | $\rho(A)$ | $\lVert A\rVert$ |
|:--|:--|:--|
| 与特征值 | 由全部特征值决定 | 由最大奇异值决定 |
| 关系 | $\rho(A)\le\lVert A\rVert$，**反向不成立** | — |
| 迭代判据 | $\rho(H)\lt1$ 是**充要**（但大规模算不出特征值） | $\lVert H\rVert\lt1$ 是**充分**（好算） |
| 非正规矩阵 | 只保证最终衰减，**有限步可能先涨** | 保证每一步都收缩 |

反例：$N=\begin{pmatrix}1&1000\\0&1\end{pmatrix}$ 的谱半径 $\rho=1$，而范数 $\lVert N\rVert_2\approx1000$——同一个矩阵，两个量差三个数量级（[2.8](../ch02/sec28.md) 陷阱 2）。实践结论：**稳妥判据用 $\lVert H\rVert\lt1$**（[@thm-1.3.6]）。

## 7 · 矩阵 1-范数 ⟷ 矩阵 ∞-范数

**口诀：1 竖着像一列（1-范数 = 列和）；∞ 横着像两行（∞-范数 = 行和）。**

| | $\lVert A\rVert_1$ | $\lVert A\rVert_\infty$ |
|:--|:--|:--|
| 公式 | $\max_j\sum_i\lvert a_{ij}\rvert$ | $\max_i\sum_j\lvert a_{ij}\rvert$ |
| 别名 | 列范数 | 行范数 |
| 转置关系 | $\lVert A\rVert_1=\lVert A^{\mathrm T}\rVert_\infty$ | 同左 |
| 与向量同名范数 | 从属于 $\lVert\boldsymbol{x}\rVert_1$ | 从属于 $\lVert\boldsymbol{x}\rVert_\infty$ |

**注意同名不同物**：向量 1-范数是「各分量绝对值之和」，矩阵 1-范数是「最大的列和」——名字一样、对象不同，靠「从属」关系记才不会认错（[@thm-1.3.5]）。

## 8 · 谱范数 ⟷ Frobenius 范数

**口诀：$\lVert A\rVert_2$ 只认最大的那个奇异值，$\lVert A\rVert_F$ 把每个奇异值都算上。**

| | $\lVert A\rVert_2=\sigma_1$ | $\lVert A\rVert_F=\sqrt{\sum\sigma_i^2}$ |
|:--|:--|:--|
| 从属于向量范数 | **是**（从属于 $\lVert\cdot\rVert_2$） | **否** |
| 判据 | $\lVert I\rVert_2=1$ | $\lVert I\rVert_F=\sqrt n\neq1$ |
| 手算 | 要算 $A^{\mathrm T}A$ 的特征值 | 平方和开方，直接算 |
| 关系 | $\lVert A\rVert_2\le\lVert A\rVert_F\le\sqrt n\lVert A\rVert_2$ | — |

反例（[@def-1.3.4] 的补全证明）：$n\ge2$ 时 $\lVert I_n\rVert_F=\sqrt n\ne1$，而任何算子范数都必须满足 $\lVert I\rVert=1$——这条单位阵条件正是两者的分界：Frobenius 范数不从属于任何向量范数。

## 9 · $\lVert A\rVert_2$ ⟷ $\lambda_{\max}(A)$

**口诀：谱范数要开方，开的不是矩阵自己的特征值，而是 $A^{\mathrm T}A$ 的特征值。**

| 情形 | 公式 |
|:--|:--|
| 一般矩阵 | $\lVert A\rVert_2=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}=\sigma_{\max}(A)$ |
| 对称半正定 | 才有 $\lVert A\rVert_2=\lambda_{\max}(A)$ |

反例：$A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$，$\lambda_{\max}(A)=0$ 但 $\lVert A\rVert_2=1$——把最大特征值当谱范数，在这个矩阵上会错成零（[1.3.7](../ch01/sec13.md#sec-1.3.7) 常见错误 3）。

## 10 · 经典 GS ⟷ 修正 GS

**口诀：只差一个「时态」——CGS 拿原始列算系数，MGS 拿更新后的当前列算。**

| | CGS | MGS |
|:--|:--|:--|
| 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{a}_j$（原始） | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{v}$（当前） |
| 精确算术 | 二者**完全相同** | 同左 |
| 浮点正交性损失 | $\mathrm{cond}^2u$ | $\mathrm{cond}\,u$ |
| 分界线 | $\mathrm{cond}\gtrsim10^{8}$ 时**完全失效** | 能撑到 $\mathrm{cond}\approx10^{16}$ |
| 用途 | 只用于教学 | 条件数温和且需显式 $Q$ 时可用 |

实测（$n=16$ 的 Vandermonde，[@ex-2.3.2]）：同一个矩阵上，CGS 的 $\lVert Q^{\mathrm T}Q-I\rVert_2=6.55$（**彻底失效**），MGS 同一指标为 $4.7\times10^{-4}$，Householder 更是低到 $3.0\times10^{-15}$。

## 11 · Householder ⟷ Givens

**口诀：Householder 是「大扫除」，一次扫掉一整列；Givens 是「外科手术」，一次只动一个元素。**

| | Householder | Givens |
|:--|:--|:--|
| 一次消掉 | **一整列**（对角以下全部） | **一个**元素 |
| 改动范围 | 整个子块 | 只动两行 |
| $\det$ | $-1$（反射） | $+1$（旋转） |
| 复杂度 | $2mn^2-\frac23n^3$ | $\approx6mn^2$（约 3 倍） |
| 适用 | **稠密矩阵默认选择** | **稀疏 / 带状 / 局部修改 / 并行** |
| 实现 | LAPACK `geqrf`（NumPy / MATLAB / SciPy 默认） | — |

对稀疏矩阵用 Householder 会**毁掉零结构**（fill-in）——这正是稀疏情形改选 Givens 的决定性理由（[@thm-2.3.3]、[@thm-2.3.4]）。

## 12 · 正态方程 ⟷ QR

**口诀：正态方程把条件数平方，QR 不碰 $A^{\mathrm T}A$。**

| | 正态方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ | QR：$R\hat{\boldsymbol{x}}=(Q^{\mathrm T}\boldsymbol{b})_{1:n}$ |
|:--|:--|:--|
| 误差量级 | $\mathrm{cond}(A)^2u$ | $\mathrm{cond}(A)u$ |
| 有效数字 | 掉一半 | 不掉 |
| 分界 | $\mathrm{cond}\gtrsim10^{8}\approx u^{-1/2}$ 时**必须弃用** | 可用到 $\mathrm{cond}\approx10^{16}$ |

实测（[@thm-2.3.5] 后的对照表）：同一个问题在 $\mathrm{cond}=6.0\times10^{10}$ 时，正态方程误差高达 $28$（**完全失效**），QR 的误差只有 $2.2\times10^{-6}$。

## 13 · 正交投影 ⟷ 斜投影

**口诀：正交投影 = 对称 + 幂等（缺一不可）；只幂等的是斜投影。**

| | 正交投影 $P$ | 斜投影 $S$ |
|:--|:--|:--|
| 条件 | $P^2=P$ **且** $P^{\mathrm T}=P$ | $S^2=S$，$S^{\mathrm T}\ne S$ |
| 残差 | 与子空间**垂直** | 不垂直 |
| 例子 | $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ | $S=\begin{pmatrix}1&1\\0&0\end{pmatrix}$ |

最小二乘的「残差与列空间垂直」这条性质**只对正交投影成立**：换成斜投影，残差便不再与列空间垂直（[@thm-2.2.5]）。

## 14 · 满 SVD ⟷ 瘦 SVD

**口诀：理论推导用满的（$U,V$ 都是方阵），工程存储用瘦的（只留和秩一样多的列）。**

| | 满 SVD | 瘦（经济型）SVD |
|:--|:--|:--|
| 尺寸 | $U\in\mathbb{R}^{m\times m}$、$V\in\mathbb{R}^{n\times n}$ | $U_r\in\mathbb{R}^{m\times r}$、$V_r\in\mathbb{R}^{n\times r}$ |
| $\Sigma$ | $m\times n$，含零块 | $r\times r$ 对角 |
| 存储 | 大 | **最省**（工程用） |
| 用途 | 理论推导、四个子空间的完整基 | 低秩逼近、压缩、PCA |

**注意记号陷阱**：瘦 SVD 里的下标 $r$ 指**秩**；满 SVD 结构式里「前 $n$ 列」用的却是下标 $1$——两套记号，别当成一回事（[2.6.1](../ch02/sec26.md#sec-2.6.1) 的注）。

## 15 · 列空间 ⟷ 行空间 ⟷ 零空间 ⟷ 左零空间

**口诀：$A$ 的列空间配 $A^{\mathrm T}$ 的零空间（都在 $\mathbb{R}^m$）；$A^{\mathrm T}$ 的列空间配 $A$ 的零空间（都在 $\mathbb{R}^n$）。**

| 子空间 | 所在空间 | 维数 | SVD 给出的标准正交基 |
|:--|:--|:--|:--|
| $C(A)$ 列空间 | $\mathbb{R}^m$ | $r$ | $U$ 前 $r$ 列 |
| $N(A^{\mathrm T})$ 左零空间 | $\mathbb{R}^m$ | $m-r$ | $U$ 后 $m-r$ 列 |
| $C(A^{\mathrm T})$ 行空间 | $\mathbb{R}^n$ | $r$ | $V$ 前 $r$ 列 |
| $N(A)$ 零空间 | $\mathbb{R}^n$ | $n-r$ | $V$ 后 $n-r$ 列 |

**先看维度（$\mathbb{R}^m$ 还是 $\mathbb{R}^n$），再谈正交补**——一半的错误是维度张冠李戴（[@thm-2.6.2]）。

## 16 · 高斯消去（含主元）⟷ LU 分解

**口诀：消去是「过程」，分解是「把过程存下来复用」。**

| | 高斯消去 | LU 分解 $A=LU$ |
|:--|:--|:--|
| 本质 | 对 $[A\mid\boldsymbol{b}]$ 做初等行变换 | 把消元过程存成 $L$，$A$ 与 $\boldsymbol{b}$ 解耦 |
| 解一次方程组 | $O(n^3)$ | 分解 $O(n^3)$ + 前代回代 $O(n^2)$ |
| 多组右端 | 每组重来一次 $O(n^3)$ | **分解一次反复用** |
| 存在条件 | 前 $n-1$ 个顺序主子式非零（充要：能消成上三角） | 同一条件（板书用 $\Rightarrow$） |

工程要点：**一次分解，反复使用**；三对角等稀疏结构用追赶法把 $O(n^3)$ 降到 $O(n)$（[第 4 讲](../lectures/lec04.md)）。
