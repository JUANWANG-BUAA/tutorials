# 习题集 · 第二章（2.1–2.5）

三组分层：A 组概念判断（快速自检）、B 组推理证明（考试大题）、C 组计算实操。**全部附解答**（默认折叠），建议先独立完成再展开对照。所有题目只使用 [2.1](sec21.md)、[2.2](sec22.md)、[2.3](sec23.md)、[2.4](sec24.md)、[2.5](sec25.md) 的概念与第一章先修知识。

本页 A、B、C 三组 51 题：A 组（12 题）、B 组（15 题）、C 组（24 题）。

| 组 | 定位 | 建议时长 | 卡壳时怎么办 |
|:--|:--|:--|:--|
| **A 组**（12 题） | 概念判断，口答即可 | 每题 1–2 分钟 | 直接看解答，回到对应小节的「即时自测」重读 |
| **B 组**（15 题） | 推理证明，需完整写出 | 每题 8–12 分钟 | 先看提示，再用 10 分钟；仍无思路才展开解答 |
| **C 组**（24 题） | 计算实操，注意验算 | 每题 5–8 分钟 | 看提示定位方法，算完**一定代回验证** |

::: note 关于「提示」层

B10–B15、C11、C14、C17、C20、C23、C24 这 12 题提供了折叠的「提示」——它只给**从哪里下手**，不给完整过程。先看提示、自己推完，再对照解答，学习效果远好于直接读解答。
:::

::: note 关于难度分布

A 组先覆盖 2.1–2.2 的两处「考试信号」（「变换」辨析、去年考题的两步法）与 2.3 的矩阵读法，再接 2.4–2.5 的核心辨析：特征向量为何必须非零、矩阵与变换的特征向量之别、相似不变量清单、两种重数的大小关系、「正交矩阵特征值只能是 $\pm1$」的纠错、Householder 是镜像而不是投影。

B 组以**单射判据**、**亏加秩定理**、**2.3 的存在唯一性 / 换基公式**，以及 **2.4–2.5 的六条主干证明**（相似矩阵同特征多项式、不同特征值的特征向量线性无关、几何重数不超过代数重数、保长度等价于保内积、正交矩阵特征值的模为 $1$、Householder 矩阵的对合性与行列式）为重心。

C 组训练「验证线性」的固定套路、具体映射的 $N(T)$、$R(T)$ 计算、2.3 的**写矩阵、算坐标、换基**三件基本功，以及 2.4–2.5 的**求特征对、判对角化、Givens 清零、Householder 造镜像**。2.6–2.7 素材到位后，本页将按同样的三组结构续写。
:::

::: note 题目编号与新增

**A5、A6、B7–B9、C7–C10** 对应 [2.3 矩阵与同构](sec23.md)；**A7–A12、B10–B15、C11–C24** 为本次新增，覆盖 [2.4 特征值与特征向量](sec24.md) 与 [2.5 正交变换与酉变换](sec25.md)（这两节依录播转录整理、盒子自动编号，故一律用小节锚点与交叉引用，不写课件页码）。其余题目沿用原编号，书内引用（如自检表的「习题 B4」）不受影响。
:::

## A 组 · 概念判断

::: ex A1 · 单射、满射、双射的方向

判断下列映射的类型（单 / 满 / 双射），并说明理由：

(a) $f:\mathbb R\to\mathbb R$，$f(x)=x^2$；(b) $f:\mathbb R\to[0,+\infty)$，$f(x)=x^2$；(c) $f:\mathbb N\to\mathbb Z$，$f(n)=\dfrac n2$（$n$ 偶）、$-\dfrac{n+1}2$（$n$ 奇）；(d) $f:\mathbb R\to\mathbb R$，$f(x)=\mathrm e^x$。

::: sol 解答

(a) 都不成立（$x$ 与 $-x$ 同像、$R(f)=[0,\infty)\neq\mathbb R$）；(b) **满射**但不单（仍非单）；(c) **双射**（[@ex-2.1.A]）；(d) **单射**（$\mathrm e^x$ 严格增）但不满（$R(f)=(0,\infty)\neq\mathbb R$）。**要点**：单射看「不同输入不同输出」，满射看「值域 = 到达集合」——同一公式改到达集合，类型就变（(a) 与 (b) 的对比）。

:::

:::

::: ex A2 · 变换、一一变换与置换

(a) 三个词的定义差别是什么？(b) $V=\{1,2,3\}$ 上「$x\mapsto 4-x$」是哪种？(c) $\mathbb R^2$ 上「$x\mapsto x$」是置换吗？(d) 为什么老师强调「（变换）考试考过」？

::: sol 解答

(a) 变换 = $V\to V$ 的映射；一一变换 = $V\to V$ 的双射；置换 = **有限集**上的一一变换（[@def-2.1.6]）。(b) 置换（有限集的 $1\leftrightarrow3,\ 2\leftrightarrow2$，是双射）。(c) **不是**——$\mathbb R^2$ 是无限集，只称一一变换。(d) 因为判题第一步就是看「是不是 $V\to V$」（变换）以及「是否双射 / 集合是否有限」（一一变换 / 置换），三词混用会直接失分。

:::

:::

::: ex A3 · 线性映射的两条性质缺一不可

(a) 举一个满足齐次性但不满足可加性的映射。(b) 举一个满足可加性但不满足齐次性的映射（提示：$\mathbb C$ 视为 $\mathbb R$ 上空间）。(c) 平移为什么不是线性映射？

::: sol 解答

(a) $T:\mathbb R\to\mathbb R$，$T(x)=|x|$：$T(\lambda x)=|\lambda||x|=\lambda|x|$（$\lambda>0$ 时成立；严格说 $T$ 不满足齐次性，改用 $T(x)=\operatorname{sgn}(x)\cdot0$ 型…更标准的例子：$T(x)=x$ 在有理数域上做 $\mathbb C\to\mathbb C$ 的实线性讨论时用 $T(z)=\bar z$——它可加但不齐次，见 (b)）。**推荐例**：$T(x)=\|x\|$ 齐次但对 $x=-y$ 可加性失败。
(b) $T:\mathbb C\to\mathbb C$，$T(z)=\bar z$，视为 $\mathbb R$-线性空间之间的映射：可加性 $\overline{z+w}=\bar z+\bar w$ 成立；齐次性对 $\lambda\in\mathbb R$ 成立、对 $\lambda=i\in\mathbb C$ 失败（$\overline{iz}=-i\bar z\neq i\bar z$）——**说明「线性」必须绑定数域**（[@def-2.2.1] 注记 1）。
(c) 平移把原点搬到别处：$T(\boldsymbol{\theta})\neq\boldsymbol{\theta}'$，违反 [@cor-2.2.1]（1）（线性映射保持原点不动）。

:::

:::

::: ex A4 · 四个等价说法的判断

设 $T\in L(V,W)$，判断对错并说明：

(a)「$T$ 单射 $\iff$ $N(T)=\{\boldsymbol{\theta}\}$」；(b)「$T$ 把无关组映成无关组，则 $T$ 单射」对任意向量组都成立吗；(c)「$T$ 把基映成基」是否总成立；(d)「$\dim V=\dim W$ 且 $T$ 单射 $\Rightarrow T$ 双射」。

::: sol 解答

(a) 对（[@thm-2.2.2] 的等价形式；证明：$T(x)=T(y)\iff T(x-y)=\boldsymbol{\theta}$）。(b) **不一定**——注 2：$p<n$ 时只验了部分向量（[@thm-2.2.2] 注 2）。(c) 不成立——注 1：线性映射不一定把基映成**像空间**的基（零映射映成零向量组）。(d) 对（[@cor-2.2.2]），且此时 $V$ 的基的像是 $W$ 的基。

:::

:::

::: ex A5 · 矩阵的「读法」与形状

判断对错并说明：

(a) 「$A$ 的第 $j$ 列是 $T$ 在第 $j$ 个基向量上的像的坐标」；
(b) 「$A$ 是 $m\times n$ 的，其中 $m=\dim V$、$n=\dim W$」；
(c) 「线性变换 $T:V\to V$ 的矩阵一定是方阵」；
(d) 「若 $A$ 的第 1 列全为 $0$，则 $T(\varepsilon_1)=\boldsymbol{\theta}'$」。

::: sol 解答

(a) 对——这正是 [@def-2.3.1] 的定义方式，是写矩阵的唯一依据。
(b) **错**，写反了：$A\in F^{m\times n}$，行数 $m=\dim W$（到达空间）、列数 $n=\dim V$（出发空间）。记忆：「$A$ 的行数等于像空间的维数」——因为每一列是**像**的坐标，坐标有 $m$ 个分量。
(c) 对——$V\to V$ 时出发基与到达基同为一组，故 $n\times n$。
(d) 对——$T(\varepsilon_1)=\sum_i a_{i1}\eta_i$，系数全为 $0$ 即 $T(\varepsilon_1)=\boldsymbol{\theta}'$（对照 [@cor-2.2.1]（1）的逆向使用：非零向量可以被映成零，见 [@thm-2.2.2] 注 1 与 $N(T)$）。

:::

:::

::: ex A6 · 同构、等势与相抵、相似

(a) 「同构 $=$ 等势」对吗？不是的话差什么？
(b) 判定两个线性空间同构的依据是什么？
(c) $A\cong B$（相抵）与 $B=P^{-1}AP$（相似）是什么关系？
(d) 一个 $2\times3$ 矩阵与一个 $3\times2$ 矩阵可能相抵吗？可能相似吗？

::: sol 解答

(a) **不对**。等势只要求存在双射（[@def-2.1.A]），同构还要求这个双射**保持加法与数乘**（[@def-2.3.2]）——即「等势 $+$ 保运算」。课件旁注「整数集与偶数集同构」说的是等势层面的直觉，不能当作线性空间同构的判据。
(b) **维数相等**（[@thm-2.3.3]）；不是「元素个数相同」——有限维实空间只要维数相同就都同构于 $\mathbb R^n$（[@cor-2.3.1]）。
(c) **相似必相抵，相抵未必相似**：相似是 $B=P^{-1}AP$（两侧同一个 $P$）；相抵是 $B=P^{-1}AQ$（$P,Q$ 可独立）。相抵对应「同一个线性映射 + 两组基各自换」，相似对应「同一个线性变换 + 同一空间的两组基」（[@thm-2.3.5]、[@cor-2.3.4]）。
(d) **都不可能**。相抵要求**同型**（都是 $m\times n$，因为初等变换不改变矩阵的行列数），$2\times3$ 与 $3\times2$ 不同型，谈不上相抵；相似只对**同阶方阵**定义，更谈不上。（能与 $2\times3$ 矩阵相抵的是另一个 $2\times3$ 矩阵，且需秩相同。）

:::

:::

::: ex A7 · 特征向量为什么必须非零

(a) 若把特征值定义中的「非零向量」放宽为「任意向量」，会出什么问题？
(b) 设 $\lambda$ 是 $A$ 的特征值，$V_\lambda=N(A-\lambda I)$。零向量属于 $V_\lambda$ 吗？它是特征向量吗？
(c)「$\boldsymbol{x}$ 是 $A$ 的属于 $\lambda$ 的特征向量」与「$\boldsymbol{x}\in V_\lambda$」有什么区别？
(d) 一个特征值 $\lambda$ 至少对应几个线性无关的特征向量？为什么不可能一个都没有？

::: sol 解答

(a) **定义会失去意义**。线性变换必把零向量映成零向量（[@cor-2.2.1] 第 1 条；矩阵情形 $A\boldsymbol{\theta}=\boldsymbol{\theta}$），于是 $T\boldsymbol{\theta}=\boldsymbol{\theta}=\lambda\boldsymbol{\theta}$ 对**每个**数 $\lambda$ 都成立——「$\lambda$ 是特征值」变成恒真的话，特征值集合成了整个数域。所以 [@def-eig-transform] 与 [@def-eig-matrix] 都要求 $\boldsymbol{\xi}\neq\boldsymbol{\theta}$。
(b) **属于，但不是**。$V_\lambda$ 是 $A-\lambda I$ 的零空间，零空间必含零向量；而特征向量按定义非零（[@def-eigenspace]）。准确说法：$V_\lambda$ 是「$\lambda$ 的全体特征向量**再添上零向量**」。
(c) 只差零向量这一个点：$\boldsymbol{x}\in V_\lambda$ 允许 $\boldsymbol{x}=\boldsymbol{\theta}$，特征向量不允许。**推论**：$V_\lambda$ 是子空间（零空间对加法、数乘封闭），而「特征向量全体」不是子空间——两句话不能互换。
(d) **至少一个**：由 [@thm-mult-ineq] 左端 $\dim V_\lambda\geq1$，即 $V_\lambda$ 中存在非零向量，它就是特征向量（这与「$\lambda$ 是特征值」等价）。但「至少一个」不意味着「很多」：[@ex-jordan-three] 的 $J_3$ 在 $\lambda=1$ 处恰好只有一维特征子空间。

:::

:::

::: ex A8 · 矩阵的特征向量与变换的特征向量

设 $V$ 是实数域上的 2 维线性空间，$\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 是 $V$ 的基，$T\in L(V)$ 在这组基下的矩阵

$$A=\begin{pmatrix}1&1\\0&2\end{pmatrix}.$$

判断并说明理由：

(a) $A$ 的特征值 $1,2$ 是不是 $T$ 的特征值？
(b) $(1,1)^{\mathrm T}$ 是 $A$ 的属于 $2$ 的特征向量，它是不是 $T$ 的属于 $2$ 的特征向量？
(c) $T$ 的属于 $2$ 与属于 $1$ 的特征向量各应怎么写？
(d)「$T$ 的特征向量依赖基的选取」这句话对吗？

::: sol 解答

(a) **是**。[@thm-eig-bridge] 第 1 条：取定基后，$T$ 与它的矩阵 $A$ 的特征值**完全相同**。核对：$\det(\lambda I-A)=(\lambda-1)(\lambda-2)$。
(b) **不是**。$(1,1)^{\mathrm T}$ 是 $\mathbb{R}^2$ 中的**坐标列**，属于 [@def-eig-matrix] 的世界；$T$ 的特征向量住在 $V$ 里。按 [@thm-eig-bridge] 第 2 条必须把它**乘回基**：属于 $2$ 的特征向量是 $\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2$。（$A(1,1)^{\mathrm T}=(2,2)^{\mathrm T}=2(1,1)^{\mathrm T}$ 只验证了坐标这一层。）
(c) 属于 $2$：$k(\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)$（$k\neq0$）；属于 $1$：$k\boldsymbol{\varepsilon}_1$（$k\neq0$）——因为 $A-I=\begin{pmatrix}0&1\\0&1\end{pmatrix}$ 给出 $x_2=0$，坐标是 $(1,0)^{\mathrm T}$，而 $A(1,0)^{\mathrm T}=(1,0)^{\mathrm T}$ ✓。
(d) **不对**。$V_\lambda$ 由 $T$ 本身决定（「被 $T$ 保持的方向」），与基无关；随基改变的只是特征向量的**坐标**。只有把坐标列误当成特征向量时，才会觉得它依赖基（[@method-eig-procedure] 第 4 步）。上三角矩阵最容易出错：坐标看着「很像」答案，但除非基恰好是标准基，它们都不是 $V$ 中的向量。

:::

:::

::: ex A9 · 相似不变量的清单

设 $B=P^{-1}AP$（$P$ 可逆）。判断下列量在 $A$ 与 $B$ 之间是否一定相同，并说明理由：特征多项式、特征值（含代数重数）、迹、行列式、秩、几何重数 $\dim V_\lambda$、矩阵的具体元素、特征向量的坐标。

(a) 哪些一定相同？哪些不一定？
(b)「特征多项式相同 $\Longrightarrow$ 相似」对吗？
(c) 举一个相似而不相等的矩阵对，并指出哪一步必须**算过**才能确认相似。

::: sol 解答

(a) **一定相同**：特征多项式、特征值（含代数重数）、迹、行列式、秩——这正是 [@thm-sim-invariants] 的清单。几何重数也在其中：$B-\lambda I=P^{-1}(A-\lambda I)P$，故 $\operatorname{rank}(B-\lambda I)=\operatorname{rank}(A-\lambda I)$，再由 [@thm-geom-mult] 得 $\dim V_\lambda=n-\operatorname{rank}(A-\lambda I)$ 不变（与 [2.4.3](sec24.md#sec-2.4.3) 的思考题一致）。
**不一定相同**：矩阵的具体元素；特征向量的**坐标**——若 $A\boldsymbol{x}=\lambda\boldsymbol{x}$，则 $B(P^{-1}\boldsymbol{x})=\lambda(P^{-1}\boldsymbol{x})$，$B$ 的属于 $\lambda$ 的特征向量是 $P^{-1}\boldsymbol{x}$，一般与 $\boldsymbol{x}$ 不同。
(b) **不对**。相似必同特征多项式，反之不真。[@ex-jordan-three] 是标准反例：$J_2$ 与 $J_3$ 的特征多项式都是 $(\lambda-1)^3$，但 $\dim V_1$ 分别是 $2$ 与 $1$；而几何重数是相似不变量，故二者不相似。**判相似不能只看特征多项式。**
(c) 例如 $A=\begin{pmatrix}3&1\\0&2\end{pmatrix}$ 与 $B=\begin{pmatrix}3&0\\0&2\end{pmatrix}$（正文 [@ex-design-diag] 的算例）：取 $P=\begin{pmatrix}1&1\\0&-1\end{pmatrix}$，可算得 $P^{-1}AP=B$。$\operatorname{tr}=5$、$\det=6$、特征多项式 $(\lambda-3)(\lambda-2)$ 都能一眼核对，但**「相似」这个结论必须落实到具体的 $P$**（或用完全不变量判断），不能凭元素形状猜。

:::

:::

::: ex A10 · 两种重数的大小关系

(a) 写出几何重数与代数重数的定义。
(b) $1$、几何重数、代数重数三者的不等关系是什么？几何重数可能等于 $0$ 吗？
(c) 设 3 阶矩阵 $A$ 的特征多项式为 $(\lambda-2)^2(\lambda-5)$。两个特征值的几何重数各有哪几种可能？$A$ 能对角化的条件是什么？
(d) 举一对矩阵说明：同一个特征多项式，几何重数可以不同。

::: sol 解答

(a) **几何重数** $=\dim V_\lambda=\dim N(A-\lambda I)=n-\operatorname{rank}(A-\lambda I)$（[@def-eigenspace]、[@thm-geom-mult]）；**代数重数** $=\lambda$ 作为特征多项式 $\det(\lambda I-A)$ 的根的重数。
(b) $1\leq\dim V_\lambda\leq\lambda$ 的代数重数（[@thm-mult-ineq]）。几何重数**不可能为 $0$**：若 $\dim V_\lambda=0$，则 $V_\lambda=\{\boldsymbol{\theta}\}$，即 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{\theta}$ 只有零解，$A-\lambda I$ 可逆、$\det(\lambda I-A)\neq0$，与「$\lambda$ 是特征值」矛盾——「特征值」这个前提本身就保证至少有一个非零特征向量。
(c) $\lambda=5$ 是**单根**，由 (b) 得 $1\leq\dim V_5\leq1$，故 $\dim V_5=1$ 必成立；$\lambda=2$ 的几何重数可以是 $1$ 或 $2$。于是 $\dim V_2=2$ $\iff$ 几何重数之和 $=2+1=3=n$ $\iff$ $A$ 可对角化；$\dim V_2=1$ 时只有 $2$ 个线性无关的特征向量，$A$ 不能对角化（[2.4.4](sec24.md#sec-2.4.4) 的设计基流程）。
(d) 例如 $A_1=\operatorname{diag}(2,2,5)$ 与 $A_2=\begin{pmatrix}2&1&0\\0&2&0\\0&0&5\end{pmatrix}$：特征多项式都是 $(\lambda-2)^2(\lambda-5)$，而 $\operatorname{rank}(A_1-2I)=1$、$\operatorname{rank}(A_2-2I)=2$，故 $\lambda=2$ 处的几何重数分别是 $2$ 与 $1$——这正是 [@ex-jordan-three] 的教训：特征多项式不含特征结构的全部信息。

:::

:::

::: ex A11 · 「正交矩阵的特征值只能是 ±1」错在哪

(a) 这个命题对吗？给出一个 $2\times2$ 实正交矩阵的反例（写出它的特征值）。
(b) 正确的命题是什么？
(c) 若 $\lambda$ 是实正交矩阵的一个**实**特征值，能推出什么？
(d) 常见错误证明：「由 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 取转置得 $\boldsymbol{x}^{\mathrm T}A^{\mathrm T}=\lambda\boldsymbol{x}^{\mathrm T}$，两式相乘得 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\lambda^2\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$，约去 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 得 $\lambda=\pm1$」。这个证明错在哪一步？为什么必须改用共轭转置？

::: sol 解答

(a) **不对**。取平面旋转 $A=\begin{pmatrix}0&-1\\1&0\end{pmatrix}$：$\det(\lambda I-A)=\lambda^2+1$，特征值是 $\pm\mathrm i$——模都是 $1$，但都不是 $\pm1$；而 $A^{\mathrm T}A=I$，$A$ 确实是正交矩阵（[@def-orth-matrix]）。
(b) 对正交（酉）矩阵，能保证的只有 $|\lambda|=1$：特征值全部落在复平面的单位圆上（[@thm-orth-eig]）。复特征值完全可能出现，实矩阵也不例外（[@def-orth-matrix] 之后的注）。
(c) 若 $\lambda\in\mathbb{R}$ 且 $|\lambda|=1$，则 $\lambda=\pm1$。所以「$\pm1$」只覆盖**实特征值**那部分；而 $n$ 阶实矩阵未必有 $n$ 个实特征值——上面的旋转矩阵一个实特征值都没有。
(d) 错在**约去 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$**。对复向量 $\boldsymbol{x}$，$\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 不是正数，可以等于 $0$、甚至为负：课堂的反例是 $\boldsymbol{x}=(1,\mathrm i)^{\mathrm T}$，$\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=1+\mathrm i^2=0$（[@errata-orth-false]），所以这一步除法不合法，$\lambda^2=1$ 根本推不出来。纪律：**未确认特征值为实数之前，长度与模一律用共轭转置** $\boldsymbol{x}^{\mathrm H}\boldsymbol{x}$（[@errata-conj-pitfall]）；正确写法见习题 B14。

:::

:::

::: ex A12 · Householder 是镜像，不是投影

设 $\boldsymbol{\omega}\in\mathbb{R}^n$，$\|\boldsymbol{\omega}\|=1$，$H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$。判断对错并说明：

(a)「$H$ 把 $\boldsymbol{x}$ 投影到超平面 $\boldsymbol{\omega}^{\perp}$ 上」；
(b)「$H^2=I$，而投影矩阵只满足幂等 $P^2=P$」；
(c)「$\det H=1$」；
(d)「$H$ 的特征值是 $1$（$n-1$ 重）与 $-1$（一重），两种重数处处相等」；
(e) 到 $\boldsymbol{\omega}^{\perp}$ 的正交投影矩阵是什么？它与 $H$ 是什么关系？

::: sol 解答

(a) **错**。$H$ 是**镜像**（反射），不是投影：把 $\boldsymbol{x}$ 拆成沿 $\boldsymbol{\omega}$ 的分量与垂直分量，则 $H\boldsymbol{x}=(\boldsymbol{x})_{\perp}-(\boldsymbol{x})_{\parallel}$——沿 $\boldsymbol{\omega}$ 的分量被**保留下来并取反**，而不是丢掉（[@def-householder] 后的几何注：「注意不是投影，是镜像」）。
(b) 对。由 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega}=1$ 得 $H^2=I$（[@thm-householder-props] 第 2 条）；投影的代数特征是幂等 $P^2=P$（第一章 [1.6](../ch01/sec16.md)），而 $H^2=I\neq H$——若 $H$ 是投影，就会丢掉沿 $\boldsymbol{\omega}$ 的分量、也不可能保长度。
(c) **错**。$\det H=-1$（[@thm-householder-props] 第 6 条）——镜像改变定向，这正是它与 Givens 旋转（$\det=+1$）的分水岭。
(d) 对。$H\boldsymbol{\omega}=-\boldsymbol{\omega}$；凡与 $\boldsymbol{\omega}$ 正交的 $\boldsymbol{v}$ 都满足 $H\boldsymbol{v}=\boldsymbol{v}$，而 $\dim\boldsymbol{\omega}^{\perp}=n-1$ 保证能取到 $n-1$ 个线性无关的这类向量（[@thm-householder-props] 第 4、5 条）。于是 $\lambda=1$ 处代数重数与几何重数都是 $n-1$、$\lambda=-1$ 处都是 $1$；两种重数处处相等 $\iff$ 可对角化（[@thm-mult-ineq]），故在基 $\boldsymbol{\omega},\boldsymbol{q}_2,\cdots,\boldsymbol{q}_n$ 下 $H$ 就是 $\operatorname{diag}(-1,1,\cdots,1)$。
(e) 正交投影矩阵是 $P=I-\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$：它把 $\boldsymbol{x}$ 映成 $(\boldsymbol{x})_{\perp}$、把 $\boldsymbol{\omega}$ 映成 $\boldsymbol{\theta}$。而

$$H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=2P-I,$$

即「先投影到 $\boldsymbol{\omega}^{\perp}$、翻倍、再减去原向量」。这也解释了 (d) 的两个特征值：$P$ 的特征值是 $1$（$\boldsymbol{\omega}^{\perp}$ 上，$n-1$ 重）与 $0$（$\boldsymbol{\omega}$ 方向），$2P-I$ 把它们变成 $1$ 与 $-1$。

:::

:::

## B 组 · 推理证明

::: ex B1 · 逆映射的唯一性与逆序公式（定理 2.1.1、定理 2.1.2）

(a) 证明：可逆映射的逆唯一。(b) 证明：$(f_2f_1)^{-1}=f_1^{-1}f_2^{-1}$（在可复合且都可逆时）。

::: sol 解答

(a) 见 [@thm-2.1.1] 证明框（两侧夹 $I$ 的连环等式）。
(b) 直接验证两个恒等式：$(f_1^{-1}f_2^{-1})(f_2f_1)=f_1^{-1}(f_2^{-1}f_2)f_1=f_1^{-1}f_1=I$；同法 $(f_2f_1)(f_1^{-1}f_2^{-1})=I$。由逆的唯一性得证。**记忆**：先穿的后脱。

:::

:::

::: ex B2 · 保持线性组合与相关性的传递（定理 2.2.1、推论 2.2.1）

(a) 用归纳法证明 [@thm-2.2.1]。(b) 证明：相关向量组的像线性相关。(c) 举反例说明 (b) 的逆不真。

::: sol 解答

(a) 见 [@thm-2.2.1] 证明框。
(b) 取不全为零的 $k_i$ 使 $\sum k_i\alpha_i=\boldsymbol{\theta}$；作用 $T$ 并用 $T(\boldsymbol{\theta})=\boldsymbol{\theta}'$ 得 $\sum k_iT(\alpha_i)=\boldsymbol{\theta}'$，系数仍不全为零。
(c) 零映射 $T(x)=\boldsymbol{\theta}'$：若 $V$ 的无关组 $\alpha_1,\alpha_2$，其像 $\boldsymbol{\theta}',\boldsymbol{\theta}'$ 线性相关；或任一「非单射」的线性映射都把某个非零向量映成零（$N(T)\ni x\neq\boldsymbol{\theta}$，取 $\{x\}$ 无关、像 $\{\boldsymbol{\theta}'\}$ 相关）。

:::

:::

::: ex B3 · 单射判据的完整证明（定理 2.2.2）

(a) 证明充分性：$T$ 单射 ⟹ 无关组的像无关。(b) 证明必要性：无关组的像无关 ⟹ $T$ 单射。(c) 说明 (b) 的证明中**哪一步**用到了「$V$ 的基」而不是任意向量组。

::: sol 解答

(a) 见证明框：从 $\sum k_iT(\alpha_i)=\boldsymbol{\theta}'$ 出发，用 $T$ 保持组合倒推 $\sum k_i\alpha_i=\boldsymbol{\theta}$，再取无关性得 $k_i=0$。
(b) 见证明框：反设存在 $x\neq y$ 使 $T(x)=T(y)$，取 $V$ 的一组基 $\alpha_i$、把 $x-y$ 展开成基的组合，用「像的零组合系数为零」导出 $x-y=\boldsymbol{\theta}$，矛盾。
(c) (b) 中用的是 **$V$ 的基 $\alpha_1,\cdots,\alpha_n$**（$n=\dim V$）——必须是「张成整个 $V$ 的无关组」，只验一个真子组的无关性不足以覆盖全部向量（正是注 2 的反例情形）。

:::

:::

::: ex B4 · 亏加秩定理（定理 2.2.5）

完整证明：$\dim N(T)+\dim R(T)=\dim V$。

::: sol 解答

见 [@thm-2.2.5] 证明框的四步（取基 → 扩基 → 像的生成 → 像的无关性）。**关键点**：① $N(T)$ 的基扩充为 $V$ 的基（[基扩充定理](../ch01/sec13.md)）；② 前 $m$ 个基向量被压成零，故 $R(T)$ 由后 $n-m$ 个像张成；③ 后 $n-m$ 个像的零组合必须给出 $N(T)$ 中的向量，用两套基（$N(T)$ 的基 + 扩展部分）的无关性收尾。

:::

:::

::: ex B5 · $L(V,W)$ 是线性空间的「陷阱验算」

(a) 验证：若 $T_1,T_2$ 是线性映射，则 $T_1+T_2$、$\lambda T_1$ 也是线性映射（封闭性）。(b) 说明为什么其余七条公理可以不逐条重证。(c) $L(V,W)$ 的零元素与负元素是什么？

::: sol 解答

(a) $(T_1+T_2)(x+y)=T_1(x+y)+T_2(x+y)=T_1(x)+T_2(x)+T_1(y)+T_2(y)$（**用了 $W$ 的交换律**）$=(T_1+T_2)(x)+(T_1+T_2)(y)$；齐次性同理。$\lambda T_1$ 逐点由 $W$ 的数乘性质传递。
(b) 因为 $L(V,W)$ 的加法与数乘都「逐点借用 $W$ 的运算」，八条公理只需在**每个固定 $x$ 上**验证，而那是 $W$ 已保证的。
(c) 零元素是**零映射** $O:x\mapsto\boldsymbol{\theta}'$；$T$ 的负是**负映射** $-T:x\mapsto-T(x)$。

:::

:::

::: ex B6 · 由基定义的映射两步法（去年考题格式）

仿照 [@ex-book-2.2.7]，完成整题的规范书写：设 $\alpha_1,\alpha_2,\alpha_3$ 是 $V$ 的基，$T(k_1\alpha_1+k_2\alpha_2+k_3\alpha_3)=(k_1+k_2)\alpha_1+k_3\alpha_3$。(1) 证明 $T$ 线性；(2) 求 $T(3\alpha_1-\alpha_2+2\alpha_3)$ 与 $N(T)$。

::: sol 解答

(1) **先证良定义**：坐标唯一 ⟹ 像唯一。**再证线性**：对 $x=\sum x_i\alpha_i$、$y=\sum y_i\alpha_i$，

$$T(x+y)=\big[(x_1+y_1)+(x_2+y_2)\big]\alpha_1+(x_3+y_3)\alpha_3=T(x)+T(y),\quad T(\lambda x)=\lambda T(x).$$
(2) $T(3\alpha_1-\alpha_2+2\alpha_3)=(3-1)\alpha_1+2\alpha_3=2\alpha_1+2\alpha_3$。
$N(T)$：解 $(k_1+k_2)\alpha_1+k_3\alpha_3=\boldsymbol{\theta}$ ⟹ $k_3=0,\ k_2=-k_1$；故

$$N(T)=\operatorname{span}\{\alpha_1-\alpha_2\},\qquad \dim N(T)=1,\qquad \dim R(T)=2\ (=\dim V-1\ \checkmark).$$

（对照 [@thm-2.2.5] 验证。）**注意**：本题 $T$ 非单射（$N(T)\neq\{\boldsymbol{\theta}\}$），与去年考题（$T$ 的像覆盖 $\alpha_1,\alpha_2,\alpha_3$ 方向、可单射）的区别正在于「是否丢掉某个方向」。

:::

:::

::: ex B7 · 矩阵的存在唯一性（定理 2.3.1）

(a) 完整证明：取定两对基后，任给 $A\in F^{m\times n}$，都存在唯一的 $T\in L(V,W)$ 以 $A$ 为矩阵。
(b) 说明证明的哪一半用了「基的表示唯一性」，哪一半用了「线性映射保持线性组合」。

::: sol 解答

(a) 见 [@thm-2.3.1] 的证明框。**构造**：$T(x)\triangleq(\eta_1,\cdots,\eta_m)A\alpha$（$\alpha$ 是 $x$ 在 $\varepsilon$ 下的坐标）；再逐条验证良定义、线性、矩阵恰为 $A$；**唯一性**：两个这样的 $T$ 在每个 $\varepsilon_j$ 上一致，而对任意 $x=\sum k_j\varepsilon_j$，由保持线性组合得 $T(x)=\sum k_jT(\varepsilon_j)$，故处处一致。
(b) **构造那半**用「坐标 $\alpha$ 由 $x$ 唯一确定」（基的表示唯一性，[@thm-1.3.2]）——这保证 $T$ 是良定义的映射；**唯一性那半**用「线性映射保持线性组合」（[@thm-2.2.1]）——这把「基上一致」放大成「处处一致」。两半缺一不可：少了前者 $T$ 可能定义不出来，少了后者可能存在两个不同的 $T$ 对应同一个 $A$。

:::

:::

::: ex B8 · $L(V,W)\cong F^{m\times n}$（定理 2.3.2、推论 2.3.2）

(a) 证明：取定两对基后，$f(T)=A$ 是 $L(V,W)$ 到 $F^{m\times n}$ 的同构映射。
(b) 由此推出 $\dim L(V,W)=mn$，并说明这个结论与 [@ex-2.2.A] 的「通俗理解」是什么关系。

::: sol 解答

(a) 见 [@thm-2.3.2] 的证明框：$f$ 是双射（存在性 + 唯一性 = [@thm-2.3.1]），且 $f(T_1+T_2)=A_1+A_2$、$f(\lambda T_1)=\lambda A_1$（逐列验证）。按 [@def-2.3.2]，双射 + 保两种运算即同构映射。
(b) 同构的空间维数相等（[@thm-2.3.3]），而 $\dim F^{m\times n}=mn$（自然基 $E_{ij}$），故 $\dim L(V,W)=mn$。
**与 [@ex-2.2.A] 的关系**：[2.2.4](sec22.md#sec-2.2.4) 课堂上说「线性映射其实就是一个矩阵」时只能「通俗地理解」——因为当时还没有同构的语言，也不清楚「取定基之后」这个前提有多重要；[@thm-2.3.2] 把这句话变成了严格命题：**取定基 $\Rightarrow$ $L(V,W)$ 与 $F^{m\times n}$ 是同一个东西的两种写法**（注意：不同的基给出**不同**的同构映射，但同构关系本身与基的选择无关，只取决于维数）。

:::

:::

::: ex B9 · 换基公式的推导与使用（定理 2.3.5、推论 2.3.4）

(a) 推导 $B=P^{-1}AQ$。
(b) 若 $V=W$、两组基取同一组（即 $Q=P$），公式退化成什么？说出它的几何含义。
(c) 判断：若 $A$ 与 $B$ 相似，则它们一定相抵；反之呢？

::: sol 解答

(a) 由过渡矩阵定义 $(\varepsilon')=(\varepsilon)Q$、$(\eta')=(\eta)P$，代入 $T(\varepsilon')=T(\varepsilon)Q=(\eta)AQ=(\eta')P^{-1}AQ$，再与 $T(\varepsilon')=(\eta')B$ 对照即得（详见 [@thm-2.3.5] 证明框）。关键在于 **$Q$ 出现在右边（出发端）、$P^{-1}$ 出现在左边（到达端）**。
(b) 退化为 $B=P^{-1}AP$（[@cor-2.3.4]）——即**相似**。几何含义：$A$ 与 $B$ 是**同一个线性变换**在同一个空间的两组不同基下的矩阵。这也是 [@ex-2.3.B] 把 $\begin{bmatrix}1&1\\0&2\end{bmatrix}$ 化成 $\operatorname{diag}(1,2)$ 的依据。
(c) 相似 $\Rightarrow$ 相抵（取 $Q=P$ 即可）；**反之不真**——相抵不要求同阶方阵，且允许两侧用互不相关的可逆矩阵。典型反例：$A=\begin{bmatrix}1&0\\0&0\end{bmatrix}$ 与 $B=\begin{bmatrix}2&0\\0&0\end{bmatrix}$ 相抵（同型、同秩，可通过初等变换互化），但不相似——相似保持**特征值**（此处 $1$ vs $2$），而相抵只保持**秩**。$\operatorname{rank}$ 是相抵的完全不变量，相似的不变量则复杂得多（这正是后续特征值理论的主题）。

:::

:::

::: ex B10 · 相似矩阵有相同的特征多项式（定理 2.4.4 的补证）

设 $A,B\in\mathbb{C}^{n\times n}$，且存在可逆矩阵 $P$ 使 $B=P^{-1}AP$。证明：

(1) $\det(\lambda I-B)=\det(\lambda I-A)$，从而 $A$ 与 $B$ 有相同的特征值（含代数重数）、相同的迹与行列式；
(2) 由此说明：线性变换 $T$ 的特征多项式与基的选取无关；
(3) 验算：$A=\begin{pmatrix}3&1\\0&2\end{pmatrix}$ 与 $B=\begin{pmatrix}3&0\\0&2\end{pmatrix}$ 相似，两者特征多项式相同，并写出联系二者的 $P$。

::: hint 提示

关键是**把 $\lambda I-B$ 也凑成「中间夹 $P$」的形状**：由 $B=P^{-1}AP$ 得 $\lambda I-B=P^{-1}(\lambda I-A)P$（注意 $\lambda I=P^{-1}(\lambda I)P$ 这一步最容易漏），再用行列式的乘法性质 $\det(XY)=\det X\det Y$。第 (2) 问把 [@cor-2.3.4] 的换基公式与第 (1) 问拼起来即可。
:::

::: sol 解答

(1) 由 $B=P^{-1}AP$，

$$\lambda I-B=\lambda P^{-1}P-P^{-1}AP=P^{-1}(\lambda I-A)P .$$

再用 $\det(XY)=\det X\cdot\det Y$：

$$\det(\lambda I-B)=\det P^{-1}\cdot\det(\lambda I-A)\cdot\det P=\det(\lambda I-A),$$

因为 $\det P^{-1}\cdot\det P=1$。特征多项式相同，则根与重数相同；比较两端 $\lambda^{n-1}$ 的系数与常数项即得 $\operatorname{tr}B=\operatorname{tr}A$、$\det B=\det A$（也可直接引用 [@thm-sim-invariants]）。
(2) 设同一线性变换 $T$ 在两组基下的矩阵分别为 $A$ 与 $B$。由换基公式（[@cor-2.3.4]）存在可逆 $P$ 使 $B=P^{-1}AP$，故由 (1) 两者的特征多项式相同。于是「$T$ 的特征多项式」可以定义为它在**任意**一组基下矩阵的特征多项式——这个定义不依赖基的选取。这正是 [@thm-sim-invariants] 所说「这些量是线性变换自身的量」的证明。
(3) 取 $P=\begin{pmatrix}1&1\\0&-1\end{pmatrix}$（正文 [@ex-design-diag] 用过它），$\det P=-1\neq0$，且

$$P^{-1}AP=\begin{pmatrix}3&0\\0&2\end{pmatrix}=B .$$

两边特征多项式都是 $(\lambda-3)(\lambda-2)$；$\operatorname{tr}=5$、$\det=6$ 也都相同 ✓。注意 $A\neq B$——可见「特征多项式相同」既不意味着矩阵相同，也不意味着相似（[@ex-jordan-three]：$J_2$ 与 $J_3$ 的特征多项式相同却不相似）。

:::

:::

::: ex B11 · 不同特征值的特征向量线性无关（定理 2.4.5）

设 $\lambda_1,\cdots,\lambda_s$ 是 $T\in L(V)$ 的**互不相同**的特征值（$s\geq1$）。证明：

(1) 若 $\boldsymbol{\xi}_i\in V_{\lambda_i}$（$i=1,\cdots,s$）且 $\boldsymbol{\xi}_1+\cdots+\boldsymbol{\xi}_s=\boldsymbol{\theta}$，则每个 $\boldsymbol{\xi}_i=\boldsymbol{\theta}$；由此推出 $V_{\lambda_1}+\cdots+V_{\lambda_s}$ 是直和；
(2) 属于不同特征值的非零特征向量 $\boldsymbol{\xi}_1,\cdots,\boldsymbol{\xi}_s$ 线性无关；
(3) 由此说明：$n$ 维空间上 $T$ 至多有 $n$ 个互不相同的特征值。

> 说明：把 (1) 称作「强形式」，是因为它**不必假设** $\boldsymbol{\xi}_i\neq\boldsymbol{\theta}$——而直和性恰恰需要这一版。

::: hint 提示

对特征值的个数 $s$ 做归纳。把 $\boldsymbol{\xi}_1+\cdots+\boldsymbol{\xi}_s=\boldsymbol{\theta}$ 两端**作用一次 $T$**，得到第二个等式；再用第一个等式消掉最后一项（第二式减去「第一式的 $\lambda_s$ 倍」），就归结为 $s-1$ 个互异特征值的情形。
:::

::: sol 解答

(1) 对 $s$ 归纳。$s=1$ 时 $\boldsymbol{\xi}_1=\boldsymbol{\theta}$ 显然成立。
设结论对 $s-1$ 个互异特征值成立。对

$$\boldsymbol{\xi}_1+\cdots+\boldsymbol{\xi}_s=\boldsymbol{\theta}\tag{$*$}$$

两端作用 $T$，并用 $T\boldsymbol{\xi}_i=\lambda_i\boldsymbol{\xi}_i$：

$$\lambda_1\boldsymbol{\xi}_1+\cdots+\lambda_s\boldsymbol{\xi}_s=\boldsymbol{\theta}.$$

把 $(*)$ 乘 $\lambda_s$ 再与上式相减，**消掉最后一项**：

$$(\lambda_1-\lambda_s)\boldsymbol{\xi}_1+\cdots+(\lambda_{s-1}-\lambda_s)\boldsymbol{\xi}_{s-1}=\boldsymbol{\theta}.$$

注意 $(\lambda_i-\lambda_s)\boldsymbol{\xi}_i\in V_{\lambda_i}$，而 $\lambda_1,\cdots,\lambda_{s-1}$ 仍互不相同，故由归纳假设每个 $(\lambda_i-\lambda_s)\boldsymbol{\xi}_i=\boldsymbol{\theta}$（$i<s$）；又 $\lambda_i-\lambda_s\neq0$，得 $\boldsymbol{\xi}_i=\boldsymbol{\theta}$（$i<s$）。代回 $(*)$ 得 $\boldsymbol{\xi}_s=\boldsymbol{\theta}$。
**直和**：上面的结论正是「零向量的表法唯一」，而它与 $V_{\lambda_1}\cap(V_{\lambda_2}+\cdots+V_{\lambda_s})=\{\boldsymbol{\theta}\}$ 一样都是直和的判据（[@thm-1.6.1]）。
(2) 取 $\boldsymbol{\xi}_i\in V_{\lambda_i}$、$\boldsymbol{\xi}_i\neq\boldsymbol{\theta}$，设 $k_1\boldsymbol{\xi}_1+\cdots+k_s\boldsymbol{\xi}_s=\boldsymbol{\theta}$。由 $k_i\boldsymbol{\xi}_i\in V_{\lambda_i}$ 与 (1) 得 $k_i\boldsymbol{\xi}_i=\boldsymbol{\theta}$；再由 $\boldsymbol{\xi}_i\neq\boldsymbol{\theta}$ 得 $k_i=0$（$i$ 任意），故线性无关。这就是 [@thm-eig-independent]。
(3) 若 $T$ 有 $s$ 个互不相同的特征值，由 (2) 可取到 $s$ 个线性无关的向量；而 $n$ 维空间中线性无关组至多含 $n$ 个向量（[第一章计数引理](../ch01/sec13.md#sec-1.3.6)），故 $s\leq n$。

:::

:::

::: ex B12 · 几何重数不超过代数重数（定理 2.4.7 的补证）

设 $A\in\mathbb{C}^{n\times n}$，$\lambda$ 是 $A$ 的特征值。证明：$\dim V_\lambda\leq\lambda$ 的代数重数（正文 [@thm-mult-ineq] 注明「证明见后续谱理论」，本题把它补上）。并回答：

(a) 证明中哪一步用了基扩充定理？
(b) 举例说明为什么是「$\leq$」而不是「$=$」；
(c) 反过来：若对**每个**特征值都有「几何重数 $=$ 代数重数」，$A$ 能对角化吗？

::: hint 提示

取 $V_\lambda$ 的一组基，再用**基扩充定理**把它补成整个空间的一组基（这一步是全部关键）。在这组基下，$A$ 的矩阵是**分块上三角**：左上角是 $\lambda I_m$、左下角是零块——因为 $V_\lambda$ 的基向量在新坐标下只有前 $m$ 个分量。然后只需用「分块三角阵的行列式 $=$ 对角块行列式之积」，看 $(t-\lambda)^m$ 能否整除特征多项式。
:::

::: sol 解答

设 $m=\dim V_\lambda$，取 $V_\lambda$ 的一组基 $\boldsymbol{\xi}_1,\cdots,\boldsymbol{\xi}_m$。由基扩充定理（[@cor-1.3.1]）把它**扩充**成 $\mathbb{C}^n$ 的一组基

$$\boldsymbol{\xi}_1,\cdots,\boldsymbol{\xi}_m,\ \boldsymbol{\eta}_1,\cdots,\boldsymbol{\eta}_{n-m}.$$

把 $A$ 看成线性变换，在这组新基下它的前 $m$ 列是 $A\boldsymbol{\xi}_i=\lambda\boldsymbol{\xi}_i$ 的坐标，即第 $i$ 列只有第 $i$ 个分量等于 $\lambda$、其余为 $0$；而前 $m$ 列在第 $m+1,\cdots,n$ 个分量上全为 $0$。于是

$$A=\begin{pmatrix}\lambda I_m&C\\O&D\end{pmatrix},\qquad C\in\mathbb{C}^{m\times(n-m)},\ D\in\mathbb{C}^{(n-m)\times(n-m)} .$$

（这一步用到 $A\boldsymbol{\xi}_i=\lambda\boldsymbol{\xi}_i$ 与「新基下坐标唯一」。）于是

$$\det(tI-A)=\det\begin{pmatrix}(t-\lambda)I_m&-C\\O&tI_{n-m}-D\end{pmatrix}=(t-\lambda)^m\det(tI_{n-m}-D),$$

最后一步用的是分块上三角阵的行列式公式 $\det\begin{pmatrix}X&Y\\O&Z\end{pmatrix}=\det X\cdot\det Z$（按前 $m$ 列做 Laplace 展开即可）。
上式说明 $(t-\lambda)^m$ 整除 $A$ 的特征多项式，故 $\lambda$ 作为根的重数（代数重数）至少是 $m$，即 $\dim V_\lambda\leq$ 代数重数。

(a) 第一步「把 $V_\lambda$ 的基扩充为全空间的基」用的就是基扩充定理。少了它，就无法保证 $\boldsymbol{\xi}_1,\cdots,\boldsymbol{\xi}_m$ 能补成**一组基**，分块形状也无从谈起——这与亏加秩定理（[@thm-2.2.5]）的证明是同一个套路。
(b) [@ex-jordan-three] 的 $J_3$：$\det(tI-J_3)=(t-1)^3$，代数重数 $3$；而 $\dim V_1=3-\operatorname{rank}(J_3-I)=3-2=1<3$。上三角分块里的 $C$ 无法消掉，正是 Jordan 块「链式结构」的来源；本题 C14 给出另一个具体例子（几何重数 $2<$ 代数重数 $3$）。
(c) **能**。设互异特征值为 $\lambda_1,\cdots,\lambda_s$，把每个 $V_{\lambda_i}$ 的基拼起来，共 $\sum_i\dim V_{\lambda_i}=\sum_i(\text{代数重数})=n$ 个向量；由 B11 的直和性它们线性无关，故构成 $\mathbb{C}^n$ 的一组基，且全部由特征向量组成——在这组基下 $A$ 的矩阵是对角形（每个 $\lambda_i$ 在对角线上出现「代数重数」次），即 $A$ 可对角化。
反过来也成立：若 $A$ 可对角化，则 $A$ 有 $n$ 个线性无关的特征向量，$n=\sum_i\dim V_{\lambda_i}\leq\sum_i(\text{代数重数})=n$，故每个特征值都取到等号。**这就是「可对角化 $\iff$ 两种重数处处相等」的完整判据。**

:::

:::

::: ex B13 · 保长度与保内积等价（定理 2.5.4 的 ①⟺②）

设 $V$ 是欧氏空间，$T\in L(V)$。证明：

(1) $T$ 保内积 $\Longrightarrow$ $T$ 保长度；
(2) $T$ 保长度 $\Longrightarrow$ $T$ 保内积（实空间用极化恒等式）；
(3) 复内积空间为什么必须再取一次 $t=\mathrm i$？写出复版极化恒等式；
(4) 举一个「保长度但不是线性」的例子，说明 (2) 中「$T$ 线性」不可省。

::: hint 提示

(1) 在保内积的等式里直接取 $\boldsymbol{y}=\boldsymbol{x}$。(2) 把内积写成四个长度的组合：实空间用 $\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2$，关键是 $T$ **线性**给出 $T\boldsymbol{x}\pm T\boldsymbol{y}=T(\boldsymbol{x}\pm\boldsymbol{y})$，于是四条长度等式可以整体搬过去。(3) 只用 $\pm\boldsymbol{y}$ 只能得到内积的**实部**，虚部要靠 $\pm\mathrm i\boldsymbol{y}$ 钉死。
:::

::: sol 解答

(1) 在 $(T\boldsymbol{x},T\boldsymbol{y})=(\boldsymbol{x},\boldsymbol{y})$ 中取 $\boldsymbol{y}=\boldsymbol{x}$，得 $\|T\boldsymbol{x}\|^2=\|\boldsymbol{x}\|^2$，开方即 $\|T\boldsymbol{x}\|=\|\boldsymbol{x}\|$。
(2) 实空间的**极化恒等式**：由内积的双线性，

$$\|\boldsymbol{x}+\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+2(\boldsymbol{x},\boldsymbol{y})+\|\boldsymbol{y}\|^2,\qquad \|\boldsymbol{x}-\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2-2(\boldsymbol{x},\boldsymbol{y})+\|\boldsymbol{y}\|^2,$$

两式相减得 $(\boldsymbol{x},\boldsymbol{y})=\dfrac14\big(\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2\big)$。于是

$$(T\boldsymbol{x},T\boldsymbol{y})=\frac14\big(\|T\boldsymbol{x}+T\boldsymbol{y}\|^2-\|T\boldsymbol{x}-T\boldsymbol{y}\|^2\big)
=\frac14\big(\|T(\boldsymbol{x}+\boldsymbol{y})\|^2-\|T(\boldsymbol{x}-\boldsymbol{y})\|^2\big)$$
$$=\frac14\big(\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2\big)=(\boldsymbol{x},\boldsymbol{y}),$$

其中第二个等号用了 $T$ **线性**（把 $T\boldsymbol{x}\pm T\boldsymbol{y}$ 收成 $T(\boldsymbol{x}\pm\boldsymbol{y})$），第三个等号用了保长度。这就是「保长度 $\Longrightarrow$ 保内积」这条通道（[@method-orth-usage]）。
(3) 复空间里 $\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2=4\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})$ **只能取到实部**，必须再算一个含 $\mathrm i$ 的组合才能钉死虚部：

$$(\boldsymbol{x},\boldsymbol{y})=\frac14\Big(\|\boldsymbol{x}+\boldsymbol{y}\|^2-\|\boldsymbol{x}-\boldsymbol{y}\|^2\Big)+\frac{\mathrm i}4\Big(\|\boldsymbol{x}+\mathrm i\boldsymbol{y}\|^2-\|\boldsymbol{x}-\mathrm i\boldsymbol{y}\|^2\Big).$$

右端四项的长度在 $T$ 下同样不变（仍用 $T(\boldsymbol{x}\pm\mathrm i\boldsymbol{y})=T\boldsymbol{x}\pm\mathrm i\,T\boldsymbol{y}$），故复空间也成立。这正是正文在 ②⟹③ 里必须取 $t=1$ 与 $t=\mathrm i$ 两次的原因；展开 $\|\boldsymbol{x}+\mathrm i\boldsymbol{y}\|^2$ 时从**第二变元**提出 $\mathrm i$ 要取共轭（[@errata-conj-pitfall]）。
(4) 例如 $T:\mathbb{R}^2\to\mathbb{R}^2$，$T(x_1,x_2)^{\mathrm T}=(|x_1|,\,x_2)^{\mathrm T}$：$\|T\boldsymbol{x}\|=\|\boldsymbol{x}\|$ 处处成立，但

$$T\big((1,0)^{\mathrm T}+(-1,0)^{\mathrm T}\big)=T(0,0)^{\mathrm T}=(0,0)^{\mathrm T},\qquad T(1,0)^{\mathrm T}+T(-1,0)^{\mathrm T}=(2,0)^{\mathrm T},$$

不可加，故不是线性映射；它也不保内积：取 $\boldsymbol{x}=(1,0)^{\mathrm T}$、$\boldsymbol{y}=(-1,0)^{\mathrm T}$，则 $(\boldsymbol{x},\boldsymbol{y})=-1$ 而 $(T\boldsymbol{x},T\boldsymbol{y})=1$。

:::

:::

::: ex B14 · 正交（酉）矩阵特征值的模为 1（定理 2.5.3）

(1) 设 $U\in\mathbb{C}^{n\times n}$ 是酉矩阵，$\lambda$ 是 $U$ 的特征值。证明 $|\lambda|=1$；
(2) 设 $A$ 是 $n$ 阶**实正交**矩阵，$\lambda$ 是它的特征值。证明 $\bar\lambda$ 也是 $A$ 的特征值，并说明为什么实正交矩阵可以没有实特征值；
(3) 举反例说明 (1) 的逆命题不真：特征值全满足 $|\lambda|=1$ 的矩阵不一定正交；
(4) 用 (1) 复核 [@errata-orth-false] 中错误证明的失效点。

::: hint 提示

(1) 从 $U\boldsymbol{x}=\lambda\boldsymbol{x}$ 出发算 $\|\boldsymbol{x}\|^2=\boldsymbol{x}^{\mathrm H}\boldsymbol{x}$，在中间插入 $U^{\mathrm H}U=I$，把 $\boldsymbol{x}^{\mathrm H}\boldsymbol{x}$ 逼成 $|\lambda|^2\boldsymbol{x}^{\mathrm H}\boldsymbol{x}$，最后除以正的 $\|\boldsymbol{x}\|^2$。(2) 用「实系数多项式的复根共轭成对」。(3) 找一个特征值全是 $1$、但 $B^{\mathrm T}B\neq I$ 的矩阵。
:::

::: sol 解答

(1) 设 $U\boldsymbol{x}=\lambda\boldsymbol{x}$，$\boldsymbol{x}\neq\boldsymbol{\theta}$（$\boldsymbol{x}\in\mathbb{C}^n$）。在中间插入 $U^{\mathrm H}U=I$：

$$\|\boldsymbol{x}\|^2=\boldsymbol{x}^{\mathrm H}\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}U^{\mathrm H}U\boldsymbol{x}=(U\boldsymbol{x})^{\mathrm H}(U\boldsymbol{x})=\|\lambda\boldsymbol{x}\|^2=|\lambda|^2\|\boldsymbol{x}\|^2 .$$

由 $\|\boldsymbol{x}\|^2>0$ 得 $|\lambda|^2=1$，即 $|\lambda|=1$。（实正交矩阵满足 $A^{\mathrm T}A=I$，把 $\mathrm H$ 换成 $\mathrm T$ 逐字相同，即 [@thm-orth-eig]。）
(2) $A$ 是实矩阵，故 $\det(\lambda I-A)$ 是**实系数**多项式；实系数多项式的复根共轭成对出现（重数也相同），故 $\bar\lambda$ 也是 $A$ 的特征值。结合 (1) 得 $|\lambda|=|\bar\lambda|=1$，但两者可以都不是实数：平面旋转矩阵

$$\begin{pmatrix}\cos\varphi&-\sin\varphi\\ \sin\varphi&\cos\varphi\end{pmatrix}\qquad(0<\varphi<\pi)$$

的特征值是 $\mathrm e^{\pm\mathrm i\varphi}$，一个实特征值也没有——所以「实正交矩阵一定有实特征值」不成立（[@def-orth-matrix] 之后的注：实方阵不一定有 $n$ 个实特征值）。
(3) 取 $B=\begin{pmatrix}1&1\\0&1\end{pmatrix}$：$\det(\lambda I-B)=(\lambda-1)^2$，两个特征值都是 $1$，$|\lambda|=1$ 成立；但

$$B^{\mathrm T}B=\begin{pmatrix}1&0\\1&1\end{pmatrix}\begin{pmatrix}1&1\\0&1\end{pmatrix}=\begin{pmatrix}1&1\\1&2\end{pmatrix}\neq I,$$

故 $B$ 不是正交矩阵。**「模为 $1$」是必要条件，不是充分条件。**
(4) 错误证明里约去的 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 可以在 $\boldsymbol{x}=(1,\mathrm i)^{\mathrm T}$ 处取 $0$（[@errata-orth-false]）；正确的做法是用 $\boldsymbol{x}^{\mathrm H}$ 即 (1)，此时 $\boldsymbol{x}^{\mathrm H}\boldsymbol{x}=|x_1|^2+\cdots+|x_n|^2>0$，除法才合法。

:::

:::

::: ex B15 · Householder 矩阵的性质（定理 2.5.7）

设 $\boldsymbol{\omega}\in\mathbb{R}^n$，$\|\boldsymbol{\omega}\|=1$，$H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$。证明：

(1) $H^{\mathrm T}=H$；
(2) $H^2=I$，从而 $H^{-1}=H$；
(3) $H$ 是正交矩阵；
(4) $H\boldsymbol{\omega}=-\boldsymbol{\omega}$，且凡满足 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{v}=0$ 的 $\boldsymbol{v}$ 都有 $H\boldsymbol{v}=\boldsymbol{v}$；
(5) $\det H=-1$；写出 $H$ 的两个特征值及各自的两种重数，并判断 $H$ 能否对角化；
(6) 记 $P=I-\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$ 为到 $\boldsymbol{\omega}^{\perp}$ 的正交投影，验证 $H=2P-I$，并用它解释 (5) 的特征值。

::: hint 提示

每一步都只用到一个事实：$\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega}=1$。算 $H^2$ 时把 $(\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})(\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})$ 按结合律写成 $\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega})\boldsymbol{\omega}^{\mathrm T}$，中间的「数 $1$」就可以提出来。求行列式**不要**硬展开：先在合适的基下看出 $H$ 是对角阵，再用「相似矩阵行列式相同」。
:::

::: sol 解答

(1) $(\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})^{\mathrm T}=\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$，故 $H^{\mathrm T}=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=H$。
(2) 按结合律把 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega}=1$ 从中间挤出来：

$$H^2=(I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})^2=I-4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}+4\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega})\boldsymbol{\omega}^{\mathrm T}=I-4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}+4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=I .$$

由 $H^2=I$ 与逆的定义得 $H^{-1}=H$（**对合**，与投影的幂等 $P^2=P$ 相对照）。
(3) 由 (1)(2)：$H^{\mathrm T}H=HH=I$，按定义 $H$ 是正交矩阵（[@def-orth-matrix]）；它也就保长度（[@thm-orth-equiv] ②）。
(4) $H\boldsymbol{\omega}=\boldsymbol{\omega}-2\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega})=\boldsymbol{\omega}-2\boldsymbol{\omega}=-\boldsymbol{\omega}$。若 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{v}=0$，则 $H\boldsymbol{v}=\boldsymbol{v}-2\boldsymbol{\omega}\cdot0=\boldsymbol{v}$。（几何含义：沿 $\boldsymbol{\omega}$ 的分量取反、垂直分量不动，即关于超平面 $\boldsymbol{\omega}^{\perp}$ 的镜像。）
(5) 取 $\boldsymbol{\omega}^{\perp}$ 的一组基 $\boldsymbol{q}_2,\cdots,\boldsymbol{q}_n$（$\dim\boldsymbol{\omega}^{\perp}=n-1$，[@def-1.6.6]），它与 $\boldsymbol{\omega}$ 一起构成 $\mathbb{R}^n$ 的基。由 (4)，$H$ 在这组基下的矩阵是 $\operatorname{diag}(-1,1,\cdots,1)$，而**相似矩阵有相同的行列式**（B10 的结论），故

$$\det H=(-1)\cdot1^{n-1}=-1 .$$

特征值：$\lambda=-1$，其 $V_{-1}=\operatorname{span}(\boldsymbol{\omega})$（若 $H\boldsymbol{v}=-\boldsymbol{v}$，则 $\boldsymbol{v}=\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{v})$），几何重数 $1$；又 $H$ 已对角化，代数重数也是 $1$。$\lambda=1$：$V_1=\boldsymbol{\omega}^{\perp}$，几何重数 $n-1$，代数重数同为 $n-1$。两种重数处处相等 $\iff$ $H$ 可对角化（B12(c) 的判据）。
(6) $2P-I=2(I-\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})-I=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=H$。几何解释：把 $\boldsymbol{x}$ 写成 $(\boldsymbol{x})_{\parallel}+(\boldsymbol{x})_{\perp}$（沿 $\boldsymbol{\omega}$ 的分量与垂直分量），则 $P\boldsymbol{x}=(\boldsymbol{x})_{\perp}$，于是

$$H\boldsymbol{x}=2(\boldsymbol{x})_{\perp}-\boldsymbol{x}=(\boldsymbol{x})_{\perp}-(\boldsymbol{x})_{\parallel},$$

正是镜像。对特征值：$P$ 的特征值是 $1$（$\boldsymbol{\omega}^{\perp}$ 上，$n-1$ 重）与 $0$（$\boldsymbol{\omega}$ 方向），$2P-I$ 把它们变成 $2\cdot1-1=1$ 与 $2\cdot0-1=-1$ ✓。

:::

:::

## C 组 · 计算实操

::: ex C1 · 具体映射的 $N(T)$、$R(T)$

$T:\mathbb R^3\to\mathbb R^3$，$T(x)=[x_1+x_2,\ x_1+x_2,\ 0]^{\mathrm T}$。(a) 验证线性；(b) 求 $N(T)$、$R(T)$ 的基；(c) 验证亏加秩定理；(d) $T$ 是否单射？

::: sol 解答

(a) 逐点验证：$T(x+y)=[(x_1+y_1)+(x_2+y_2),\ \cdots]$，与 $T(x)+T(y)$ 一致；齐次性同理。
(b) $N(T)$：$x_1+x_2=0,\ x_3$ 任意 ⟹ 基 $\{[1,-1,0]^{\mathrm T},[0,0,1]^{\mathrm T}\}$；$R(T)$：像总形如 $[t,t,0]^{\mathrm T}$ ⟹ 基 $\{[1,1,0]^{\mathrm T}\}$。
(c) $2+1=3=\dim\mathbb R^3$ ✓。(d) 非单（零度 1）。

:::

:::

::: ex C2 · 两组基的变换（例 2.2.6 具体化）

$V=\mathbb R^2$，$\varepsilon$ 为标准基，$\eta_1=[1,1]^{\mathrm T}$、$\eta_2=[1,-1]^{\mathrm T}$。(a) 写出 $T(x)=[\eta_1,\eta_2][x_1,x_2]^{\mathrm T}$ 的矩阵形式；(b) 求 $T([2,3]^{\mathrm T})$ 在标准基下的坐标；(c) 说明同一个坐标数组 $[2,3]^{\mathrm T}$ 配不同基得到不同向量。

::: sol 解答

(a) $[\eta_1,\eta_2]=\begin{bmatrix}1&1\\1&-1\end{bmatrix}=:P$，$T(x)=Px$。(b) $P[2,3]^{\mathrm T}=[2+3,\ 2-3]^{\mathrm T}=[5,-1]^{\mathrm T}$。(c) $[2,3]$ 在标准基下是 $[2,3]^{\mathrm T}$，在 $\eta$ 基下是 $2\eta_1+3\eta_2=[5,-1]^{\mathrm T}$——**同一数组、不同向量**（板书 45:09 打叉的含义）。$P$ 可逆（$\det=-2$），故 $T$ 是双射型的一一变换。

:::

:::

::: ex C3 · 用亏加秩定理反推维数

设 $T\in L(V,W)$，$\dim V=5$、$\dim W=3$。(a) $\dim N(T)$ 的最小可能值与此时 $\dim R(T)$；(b) $\dim R(T)$ 的最大可能值；(c) 若 $T$ 满射，求 $\dim N(T)$。

::: sol 解答

(a) $\dim N(T)\ge5-3=2$（因 $R(T)\subseteq W$，$\dim R(T)\le3$），此时 $\dim R(T)=3$；(b) $\dim R(T)\le\min(5,3)=3$；(c) 满射 ⟹ $\dim R(T)=3$ ⟹ $\dim N(T)=5-3=2$。**要点**：亏加秩定理给出「零度与秩的守恒」，可用来**反推**不能直接算的量。

:::

:::

::: ex C4 · 投影变换的具体计算（例 2.2.5）

$V=\mathbb R^3$，$W=\operatorname{span}\{[1,1,0]^{\mathrm T}\}$。(a) 用投影公式算 $T([2,1,5]^{\mathrm T})$；(b) 求 $N(T)$、$R(T)$；(c) 验证 $T^2=T$。

::: sol 解答

(a) 取单位基 $\alpha=\frac1{\sqrt2}[1,1,0]^{\mathrm T}$。$(x,\alpha)=\frac1{\sqrt2}(2+1)=\frac3{\sqrt2}$，

$$T(x)=(x,\alpha)\alpha=\frac3{\sqrt2}\cdot\frac1{\sqrt2}[1,1,0]^{\mathrm T}=\tfrac32[1,1,0]^{\mathrm T}=[1.5,1.5,0]^{\mathrm T}.$$
(b) $N(T)=\{x\mid x_1+x_2=0\}=\operatorname{span}\{[1,-1,0]^{\mathrm T},[0,0,1]^{\mathrm T}\}$（零度 2）；$R(T)=W$（秩 1）；$2+1=3$ ✓。
(c) $T(T(x))=(T(x),\alpha)\alpha=(x,\alpha)(\alpha,\alpha)\alpha=(x,\alpha)\alpha=T(x)$（$\alpha$ 单位）——**幂等**，与第一章 [1.6](../ch01/sec16.md) 的投影讨论一致。

:::

:::

::: ex C5 · 矩阵诱导的映射（例 2.2.B 的具体化）

$T(X)=AXB$，$A=\begin{bmatrix}1&0&0\\0&1&0\end{bmatrix}$、$B=\begin{bmatrix}1&1\\0&1\end{bmatrix}$。(a) 验证 $T$ 线性（用转置 / 分配律）；(b) $T$ 把 $2\times2$ 映到几乘几？(c) 算 $T\left(\begin{bmatrix}1&0\\0&1\end{bmatrix}\right)$。

::: sol 解答

(a) $T(X+Y)=A(X+Y)B=AXB+AYB$；$T(\lambda X)=\lambda AXB$。(b) $X$ 是 $2\times2$（$B$ 为 $2\times2$），$A$ 为 $2\times3$——$AX$ 无定义；**正确取法**应让 $A$ 左乘 $2\times2$、$B$ 右乘 $2\times2$：如 $A=I_2$、$B$ 同，则 $T:I_2\mapsto\begin{bmatrix}1&1\\0&1\end{bmatrix}$。(c) 承 (b)，$T(I_2)=B=\begin{bmatrix}1&1\\0&1\end{bmatrix}$。
**要点**：写矩阵乘法先查形状（这正是老师提醒「只能通俗地理解 $L(V,W)$」的实操理由）。

:::

:::

::: ex C6 · 复合与逆的次序

设 $f:\mathbb R^2\to\mathbb R^2$，$f(x)=[x_1+2x_2,\ x_2]^{\mathrm T}$；$g(x)=[x_1,\ x_1-x_2]^{\mathrm T}$。(a) 求 $g\circ f$ 的矩阵；(b) 验证 $(g\circ f)^{-1}=f^{-1}\circ g^{-1}$；(c) 说明为什么「先穿的后脱」。

::: sol 解答

(a) $M_f=\begin{bmatrix}1&2\\0&1\end{bmatrix}$、$M_g=\begin{bmatrix}1&0\\1&-1\end{bmatrix}$，$M_{g\circ f}=M_gM_f=\begin{bmatrix}1&2\\1&1\end{bmatrix}$。
(b) $M_f^{-1}=\begin{bmatrix}1&-2\\0&1\end{bmatrix}$、$M_g^{-1}=\begin{bmatrix}1&0\\1&-1\end{bmatrix}$（验算 $M_gM_g^{-1}=I$），$M_f^{-1}M_g^{-1}=\begin{bmatrix}1&-2\\0&1\end{bmatrix}\begin{bmatrix}1&0\\1&-1\end{bmatrix}=\begin{bmatrix}-1&2\\1&-1\end{bmatrix}$，与 $(M_gM_f)^{-1}=M_{g\circ f}^{-1}$ 逐元吻合。
(c) 先作用 $f$ 再作用 $g$，撤销时要**先撤 $g$、再撤 $f$**——与 [@thm-2.1.2] 的逆序公式一致。

:::

:::

::: ex C7 · 写矩阵、算坐标（2.3 基本功）

(1) $T:\mathbb R^3\to\mathbb R^2$，$T(x)=[x_1+2x_3,\ x_2-x_3]^{\mathrm T}$，取两空间标准基。(a) 写出 $A$；(b) 用 $\beta=A\alpha$ 算 $T(1,1,1)^{\mathrm T}$。(2) $T:P_2(x)\to P_2(x)$，$T(p)=p'(x)$，取基 $1,x,x^2$。(c) 写出矩阵；(d) 说出这个矩阵乘法的效果。

::: sol 解答

(1)(a) 逐列读：$T(e_1)=\begin{bmatrix}1\\0\end{bmatrix}$、$T(e_2)=\begin{bmatrix}0\\1\end{bmatrix}$、$T(e_3)=\begin{bmatrix}2\\-1\end{bmatrix}$，故 $A=\begin{bmatrix}1&0&2\\ 0&1&-1\end{bmatrix}$。
(b) $\beta=\begin{bmatrix}1&0&2\\ 0&1&-1\end{bmatrix}\begin{bmatrix}1\\1\\1\end{bmatrix}=\begin{bmatrix}3\\0\end{bmatrix}$，即 $T(1,1,1)^{\mathrm T}=(3,0)^{\mathrm T}$；直接代入 $x_1+2x_3=3$、$x_2-x_3=0$ ✓。
(2)(c) $T(1)=0$、$T(x)=1$、$T(x^2)=2x$，故 $A=\begin{bmatrix}0&1&0\\ 0&0&2\\ 0&0&0\end{bmatrix}$。
(d) 每一列把系数「上移一格」并乘上位置编号：$(a_0,a_1,a_2)^{\mathrm T}\mapsto(a_1,2a_2,0)^{\mathrm T}$——正是求导。$A^3=O$（求导三次为零）。

:::

:::

::: ex C8 · 换基公式的算例（推论 2.3.4）

设 $T:\mathbb R^2\to\mathbb R^2$ 在标准基 $e_1,e_2$ 下的矩阵为 $A=\begin{bmatrix}2&0\\ 1&3\end{bmatrix}$。考察两组新基：**（甲）**$\eta_1=(1,0)^{\mathrm T}$、$\eta_2=(0,1)^{\mathrm T}$；**（乙）**$\zeta_1=(1,-1)^{\mathrm T}$、$\zeta_2=(0,1)^{\mathrm T}$。(a) 分别求 $T$ 在这两组基下的矩阵；(b) 比较结果并说明原因。

::: sol 解答

(a) **甲组**：$\eta_1=e_1,\eta_2=e_2$ 就是标准基，$P=I$，故 $B=P^{-1}AP=A=\begin{bmatrix}2&0\\ 1&3\end{bmatrix}$。
**乙组**：$(\zeta_1,\zeta_2)=(e_1,e_2)\begin{bmatrix}1&0\\ -1&1\end{bmatrix}$，即 $P=\begin{bmatrix}1&0\\ -1&1\end{bmatrix}$，$P^{-1}=\begin{bmatrix}1&0\\ 1&1\end{bmatrix}$。于是

$$B=P^{-1}AP=\begin{bmatrix}1&0\\ 1&1\end{bmatrix}\begin{bmatrix}2&0\\ 1&3\end{bmatrix}\begin{bmatrix}1&0\\ -1&1\end{bmatrix}
=\begin{bmatrix}2&0\\ 3&3\end{bmatrix}\begin{bmatrix}1&0\\ -1&1\end{bmatrix}=\begin{bmatrix}2&0\\ 0&3\end{bmatrix}.$$

**逐列验算**：$T(\zeta_1)=T(1,-1)^{\mathrm T}=(2,\,1\cdot1+3\cdot(-1))^{\mathrm T}=(2,-2)^{\mathrm T}=2\zeta_1$；$T(\zeta_2)=T(0,1)^{\mathrm T}=(0,3)^{\mathrm T}=3\zeta_2$。两列分别读出 $(2,0)^{\mathrm T}$、$(0,3)^{\mathrm T}$，与上式一致 ✓。

(b) 甲组（恒等换基）矩阵不变；乙组把矩阵化成了**对角阵** $\operatorname{diag}(2,3)$。原因：$\zeta_1,\zeta_2$ 恰好取在 $T$ 的两个「不变方向」上——$T$ 只把它们分别拉伸 $2$ 倍与 $3$ 倍，不旋转。**要点**：换基能否把矩阵变简单，取决于基是否选在「不变方向」上——这正是[例 2.3.B](sec23.md#ex-2.3.B) 与后续特征值理论的主题。

:::

:::

::: ex C9 · 矩阵的秩与映射的秩（定理 2.3.6）

$T:\mathbb R^3\to\mathbb R^3$，$T(x)=[x_1+x_2+x_3,\ 2x_1+2x_2+2x_3,\ 0]^{\mathrm T}$。(a) 写出标准基下的矩阵 $A$；(b) 求 $\operatorname{rank}A$、$\dim R(T)$、$\dim R(A)$；(c) 求 $N(T)$、$N(A)$，验证 $\dim N(T)=\dim N(A)$；(d) 验证 (3)。

::: sol 解答

(a) $T(e_1)=(1,2,0)^{\mathrm T}$、$T(e_2)=(1,2,0)^{\mathrm T}$、$T(e_3)=(1,2,0)^{\mathrm T}$，故

$$A=\begin{bmatrix}1&1&1\\ 2&2&2\\ 0&0&0\end{bmatrix}.$$

(b) 三列全同且非零，故列空间维数为 $1$：$\operatorname{rank}A=1$。像总形如 $(t,2t,0)^{\mathrm T}$，故 $R(T)=\operatorname{span}\{(1,2,0)^{\mathrm T}\}$，$\dim R(T)=1$；$R(A)=\operatorname{span}\{(1,2,0)^{\mathrm T}\}$，$\dim R(A)=1$ ✓ 三者一致。
(c) $N(T)$：$x_1+x_2+x_3=0$，即 $x_3=-x_1-x_2$，取自由参数得基 $\{(1,0,-1)^{\mathrm T},(0,1,-1)^{\mathrm T}\}$，$\dim N(T)=2$；$N(A)$：解 $x_1+x_2+x_3=0$（第二行是第一行的 $2$ 倍），同一组解，$\dim N(A)=2$ ✓。
(d) $\dim N(A)+\dim R(A)=2+1=3=n$ ✓；对照 [@thm-2.2.5]：$2+1=3=\dim\mathbb R^3$ ✓。

:::

:::

::: ex C10 · 差分方程与友矩阵（例 2.3.5）

取 $n=2$：$u_{k+2}+a_1u_{k+1}+a_0u_k=0$（$k=0,\pm1,\cdots$，设 $a_0\neq0$）。(a) 写出状态向量 $x_k$ 与友矩阵 $A$；(b) 验证 $x_{k+1}=Ax_k$；(c) 说明解空间维数为 $2$；(d) 若 $a_0=0$ 会出现什么问题？

::: sol 解答

(a) $x_k=\begin{bmatrix}u_k\\ u_{k+1}\end{bmatrix}$，$A=\begin{bmatrix}0&1\\ -a_0&-a_1\end{bmatrix}$。
(b) $Ax_k=\begin{bmatrix}u_{k+1}\\ -a_0u_k-a_1u_{k+1}\end{bmatrix}$，第二分量由方程得 $-a_0u_k-a_1u_{k+1}=u_{k+2}$，故 $Ax_k=\begin{bmatrix}u_{k+1}\\ u_{k+2}\end{bmatrix}=x_{k+1}$ ✓。
(c) 映射 $T(\{u_k\})=x_0=(u_0,u_1)^{\mathrm T}$ 是解空间到 $\mathbb R^2$ 的同构（[@ex-2.3.5] 的三步论证），故解空间维数 $=\dim\mathbb R^2=2$。直观：$u_0,u_1$ 任取，往后由递推唯一确定（且因 $a_0\neq0$ 可逆，往前也唯一）。
(d) $a_0=0$ 时 $A$ 奇异（$\det A=a_0$），$x_k=A^kx_0$ 无法对 $k<0$ 反推；此时 $u_k$（$k\le0$）可任取，解空间维数不再是 $2$。这就是[勘误 E2.2](errata.md#errata-2.5) 所指的前提。

:::

:::

::: ex C11 · 2×2 对称矩阵：两种重数与对角化

$A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$。

(a) 求特征多项式与特征值（用迹、行列式各核对一次）；
(b) 求每个特征值的特征子空间、几何重数与代数重数；
(c) 判断 $A$ 能否对角化；能的话写出可逆 $P$ 使 $P^{-1}AP$ 为对角形；
(d) 代回验证 $A\boldsymbol{x}=\lambda\boldsymbol{x}$，并逐列验算 $AP=P\operatorname{diag}(3,1)$。

::: hint 提示

特征多项式先展开再因式分解；算完立刻用「$\operatorname{tr}A=\sum\lambda_i$、$\det A=\prod\lambda_i$」各验一次。求特征向量就是把 $\lambda$ 代回 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{\theta}$ 解齐次方程——两个特征值互异，各取一个非零解即可。组装 $P$ 时记住「**$P$ 的列就是特征向量**」，对角元的顺序跟着列的顺序走。
:::

::: sol 解答

(a) $\det(\lambda I-A)=\begin{vmatrix}\lambda-2&-1\\-1&\lambda-2\end{vmatrix}=(\lambda-2)^2-1=\lambda^2-4\lambda+3=(\lambda-1)(\lambda-3)$，故特征值为 $1$ 与 $3$。
核对：$\operatorname{tr}A=4=1+3$ ✓；$\det A=4-1=3=1\cdot3$ ✓（[@thm-eig-trace]）。
(b) $\lambda=3$：$A-3I=\begin{pmatrix}-1&1\\1&-1\end{pmatrix}$，方程 $-x_1+x_2=0$，基础解系 $\boldsymbol{\alpha}_1=(1,1)^{\mathrm T}$；$V_3=\operatorname{span}\{(1,1)^{\mathrm T}\}$，几何重数 $=2-\operatorname{rank}(A-3I)=2-1=1$，代数重数也是 $1$。
$\lambda=1$：$A-I=\begin{pmatrix}1&1\\1&1\end{pmatrix}$，方程 $x_1+x_2=0$，基础解系 $\boldsymbol{\alpha}_2=(1,-1)^{\mathrm T}$；$V_1=\operatorname{span}\{(1,-1)^{\mathrm T}\}$，几何重数 $=2-1=1=$ 代数重数。
两种重数处处相等，故 $A$ 可对角化（[@thm-mult-ineq]）。
(c) 取 $P=(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2)=\begin{pmatrix}1&1\\1&-1\end{pmatrix}$，$\det P=-2\neq0$，

$$P^{-1}=\begin{pmatrix}\tfrac12&\tfrac12\\[2pt]\tfrac12&-\tfrac12\end{pmatrix},\qquad P^{-1}AP=\begin{pmatrix}3&0\\0&1\end{pmatrix}.$$
(d) 代回：$A(1,1)^{\mathrm T}=(2+1,\ 1+2)^{\mathrm T}=(3,3)^{\mathrm T}=3(1,1)^{\mathrm T}$ ✓；$A(1,-1)^{\mathrm T}=(2-1,\ 1-2)^{\mathrm T}=(1,-1)^{\mathrm T}=1\cdot(1,-1)^{\mathrm T}$ ✓。
逐列验算：

$$AP=\begin{pmatrix}2&1\\1&2\end{pmatrix}\begin{pmatrix}1&1\\1&-1\end{pmatrix}=\begin{pmatrix}3&1\\3&-1\end{pmatrix}=P\begin{pmatrix}3&0\\0&1\end{pmatrix}\ \checkmark .$$

（**要点**：$AP=P\Lambda$ 逐列验算比直接求 $P^{-1}$ 更省力，也更不容易错。）

:::

:::

::: ex C12 · 二重根与「能不能对角化」

$A=\begin{pmatrix}1&1&0\\0&1&0\\0&0&2\end{pmatrix}$（上三角）。

(a) 求特征多项式、特征值及各自的代数重数；
(b) 对每个特征值求 $\operatorname{rank}(A-\lambda I)$、几何重数与特征子空间的基；
(c) 判断 $A$ 能否对角化，并用「线性无关特征向量的个数」解释；
(d) 与 [@ex-jordan-three] 的 $J_2$ 对照：两者的特征多项式与几何重数分别是什么？

::: sol 解答

(a) 上三角矩阵的行列式等于对角元之积，故 $\det(\lambda I-A)=(\lambda-1)^2(\lambda-2)$：$\lambda=1$ 的代数重数为 $2$，$\lambda=2$ 的为 $1$。
核对：$\operatorname{tr}A=1+1+2=4=1+1+2$ ✓；$\det A=1\cdot1\cdot2=2=1\cdot1\cdot2$ ✓。
(b) $\lambda=1$：$A-I=\begin{pmatrix}0&1&0\\0&0&0\\0&0&1\end{pmatrix}$，秩为 $2$，故几何重数 $=3-2=1$；方程 $x_2=0$、$x_3=0$，$x_1$ 自由，$V_1=\operatorname{span}\{(1,0,0)^{\mathrm T}\}$。
$\lambda=2$：$A-2I=\begin{pmatrix}-1&1&0\\0&-1&0\\0&0&0\end{pmatrix}$，秩为 $2$，几何重数 $=3-2=1$；方程 $-x_2=0$ 与 $-x_1+x_2=0$ 给出 $x_1=x_2=0$，$x_3$ 自由，$V_2=\operatorname{span}\{(0,0,1)^{\mathrm T}\}$。
代回：$A(1,0,0)^{\mathrm T}=(1,0,0)^{\mathrm T}=1\cdot(1,0,0)^{\mathrm T}$ ✓；$A(0,0,1)^{\mathrm T}=(0,0,2)^{\mathrm T}=2(0,0,1)^{\mathrm T}$ ✓。
(c) **不能对角化**。$\lambda=1$ 处几何重数 $1<$ 代数重数 $2$（[@thm-mult-ineq]）；全部特征子空间维数之和 $1+1=2<3$，即 $A$ 只有 $2$ 个线性无关的特征向量，凑不成 $\mathbb{R}^3$ 的基，故不存在可逆 $P$ 使 $P^{-1}AP$ 为对角形（[@method-design-basis]）。
(d) $J_2=\begin{pmatrix}1&1&\\&1&\\&&1\end{pmatrix}$ 的特征多项式是 $(\lambda-1)^3$（与 $A$ 的 $(\lambda-1)^2(\lambda-2)$ **不同**），它在 $\lambda=1$ 处的几何重数是 $3-\operatorname{rank}(J_2-I)=3-1=2$（与 $A$ 的 $1$ 也不同）。两者的**共同点**是：「几何重数 $<$ 代数重数」$\Longrightarrow$ 不可对角化。**结论**：判可对角化必须把特征多项式与几何重数一起看。

:::

:::

::: ex C13 · 三个互异特征值：组装 P 并验算

$A=\begin{pmatrix}1&1&1\\0&2&1\\0&0&3\end{pmatrix}$。

(a) 求特征值与特征向量；
(b) 写出可逆 $P$ 使 $P^{-1}AP=\operatorname{diag}(1,2,3)$；
(c) 逐列验算 $AP=P\operatorname{diag}(1,2,3)$；
(d) 写出 $P^{-1}$ 并完成验算。

::: sol 解答

(a) 上三角 $\Rightarrow$ $\det(\lambda I-A)=(\lambda-1)(\lambda-2)(\lambda-3)$，特征值为 $1,2,3$（代数重数都是 $1$，故几何重数也都只能是 $1$）。核对：$\operatorname{tr}A=6=1+2+3$ ✓，$\det A=6=1\cdot2\cdot3$ ✓。
$\lambda=1$：$A-I=\begin{pmatrix}0&1&1\\0&1&1\\0&0&2\end{pmatrix}$，方程 $x_2+x_3=0$ 与 $2x_3=0$ 给出 $x_2=x_3=0$，$\boldsymbol{\alpha}_1=(1,0,0)^{\mathrm T}$。
$\lambda=2$：$A-2I=\begin{pmatrix}-1&1&1\\0&0&1\\0&0&1\end{pmatrix}$，由 $x_3=0$ 与 $-x_1+x_2=0$ 得 $\boldsymbol{\alpha}_2=(1,1,0)^{\mathrm T}$。
$\lambda=3$：$A-3I=\begin{pmatrix}-2&1&1\\0&-1&1\\0&0&0\end{pmatrix}$，由 $-x_2+x_3=0$ 与 $-2x_1+x_2+x_3=0$ 取 $x_2=x_3=1$ 得 $\boldsymbol{\alpha}_3=(1,1,1)^{\mathrm T}$。
(b) $P=(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3)=\begin{pmatrix}1&1&1\\0&1&1\\0&0&1\end{pmatrix}$，$\det P=1\neq0$。
(c) $A$ 作用在三列上分别是 $1\boldsymbol{\alpha}_1,\ 2\boldsymbol{\alpha}_2,\ 3\boldsymbol{\alpha}_3$，即

$$AP=\begin{pmatrix}1&2&3\\0&2&3\\0&0&3\end{pmatrix}=P\begin{pmatrix}1&0&0\\0&2&0\\0&0&3\end{pmatrix}\ \checkmark .$$
(d) $P$ 是上三角、对角元全为 $1$，直接试乘得 $P^{-1}=\begin{pmatrix}1&-1&0\\0&1&-1\\0&0&1\end{pmatrix}$，于是 $P^{-1}AP=\operatorname{diag}(1,2,3)$。
代回验证特征向量：$A\boldsymbol{\alpha}_2=(1+1,\ 2,\ 0)^{\mathrm T}=(2,2,0)^{\mathrm T}=2\boldsymbol{\alpha}_2$ ✓；$A\boldsymbol{\alpha}_3=(1+1+1,\ 2+1,\ 3)^{\mathrm T}=(3,3,3)^{\mathrm T}=3\boldsymbol{\alpha}_3$ ✓。

:::

:::

::: ex C14 · 三重根、几何重数 2：仍不可对角化

$A=\begin{pmatrix}2&1&1\\0&2&0\\0&0&2\end{pmatrix}$。

(a) 求特征多项式、特征值及其代数重数；
(b) 求 $\operatorname{rank}(A-2I)$、$\dim V_2$ 与 $V_2$ 的一组基；
(c) 判断 $A$ 能否对角化；
(d) 与 [@ex-jordan-three] 中的 $J_2$ 对照：两者「不可对角化」的原因有何共同点？

::: hint 提示

先算 $A-2I$ 的**秩**就能得到几何重数，不必把特征向量全解出来。注意：$A$ 与 $J_2$ 的特征多项式不同（一个是 $(\lambda-2)^3$、一个是 $(\lambda-1)^3$），要**各自**算几何重数——同一个特征多项式可以有不同几何重数，正是 [@ex-jordan-three] 的教训。
:::

::: sol 解答

(a) $A$ 是上三角，$\det(\lambda I-A)=(\lambda-2)^3$：特征值只有 $\lambda=2$，代数重数为 $3$。核对：$\operatorname{tr}A=6=2+2+2$ ✓，$\det A=8=2^3$ ✓。
(b) $A-2I=\begin{pmatrix}0&1&1\\0&0&0\\0&0&0\end{pmatrix}$，秩为 $1$，故几何重数 $=3-1=2$。方程只有 $x_2+x_3=0$，即

$$V_2=\{(x_1,\ x_2,\ -x_2)^{\mathrm T}\}=\operatorname{span}\{(1,0,0)^{\mathrm T},(0,1,-1)^{\mathrm T}\}.$$

代回：$A(0,1,-1)^{\mathrm T}=(1-1,\ 2,\ -2)^{\mathrm T}=(0,2,-2)^{\mathrm T}=2(0,1,-1)^{\mathrm T}$ ✓；$A(1,0,0)^{\mathrm T}=(2,0,0)^{\mathrm T}=2(1,0,0)^{\mathrm T}$ ✓。
(c) **不能对角化**：几何重数 $2<$ 代数重数 $3$（[@thm-mult-ineq]），只有 $2$ 个线性无关的特征向量，而 $\mathbb{R}^3$ 的基需要 $3$ 个。
(d) 共同点：都存在某个特征值使「几何重数 $<$ 代数重数」——$J_2$ 在 $\lambda=1$ 处是 $2<3$，本题在 $\lambda=2$ 处是 $2<3$，因而都无法凑出 $3$ 个线性无关的特征向量。（补充：把 $J_2$ 中的 $1$ 全部换成 $2$ 得到的矩阵与本题的 $A$ 特征多项式相同、两种重数也相同，事实上二者相似——但「相似类由什么完全决定」属于后续谱理论；本题只需按两种重数判断。）

:::

:::

::: ex C15 · 抽象空间里求 T 的特征向量（必须乘回基）

设 $V$ 是实数域上的 2 维线性空间，$\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 是 $V$ 的一组基，$T\in L(V)$ 满足

$$T(\boldsymbol{\varepsilon}_1)=\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2,\qquad T(\boldsymbol{\varepsilon}_2)=2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2 .$$

(a) 写出 $T$ 在 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 下的矩阵 $A$；
(b) 求 $A$ 的特征值与特征向量（坐标），并写出 $T$ 的特征值；
(c) 用 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 写出 $T$ 的**全部**特征向量；
(d) 不经过矩阵，直接用 $T$ 的线性性质验证 $T(\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=3(\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)$ 与 $T(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)=-(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)$；
(e) 为什么 (b) 里的 $(1,1)^{\mathrm T}$ 不能直接当答案交卷？

::: sol 解答

(a) 逐列读（[@def-2.3.1]）：$A=\begin{pmatrix}1&2\\2&1\end{pmatrix}$。
(b) $\det(\lambda I-A)=\begin{vmatrix}\lambda-1&-2\\-2&\lambda-1\end{vmatrix}=(\lambda-1)^2-4=\lambda^2-2\lambda-3=(\lambda-3)(\lambda+1)$，特征值为 $3$ 与 $-1$。核对：$\operatorname{tr}A=2=3+(-1)$ ✓，$\det A=1-4=-3=3\cdot(-1)$ ✓。
$\lambda=3$：$A-3I=\begin{pmatrix}-2&2\\2&-2\end{pmatrix}$，$-x_1+x_2=0$，坐标 $\boldsymbol{\alpha}_1=(1,1)^{\mathrm T}$；$\lambda=-1$：$A+I=\begin{pmatrix}2&2\\2&2\end{pmatrix}$，$x_1+x_2=0$，坐标 $\boldsymbol{\alpha}_2=(1,-1)^{\mathrm T}$。由 [@thm-eig-bridge]，$A$ 的特征值 $3,-1$ 就是 $T$ 的特征值。
(c) **乘回基**（[@method-eig-procedure] 第 4 步）：

$$\boldsymbol{\xi}_1=k_1(\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)\ (k_1\neq0),\qquad \boldsymbol{\xi}_2=k_2(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)\ (k_2\neq0).$$
(d) $T(\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=T(\boldsymbol{\varepsilon}_1)+T(\boldsymbol{\varepsilon}_2)=(\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2)+(2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=3\boldsymbol{\varepsilon}_1+3\boldsymbol{\varepsilon}_2=3(\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)$ ✓；
$T(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)=(\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2)-(2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=-\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2=-(\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2)$ ✓。这也直接验证了 (c) 的两族向量确实是特征向量。
(e) 因为 $(1,1)^{\mathrm T}$ 住在 $\mathbb{R}^2$ 里，是**坐标**；$V$ 是抽象空间，「$(1,1)^{\mathrm T}$ 这个向量」根本不存在。凡是「给基与矩阵求 $T$ 的特征向量」的题，最后一步都必须把坐标写成基的组合——漏掉这一步是本节最高频的错误（[@method-eig-procedure]）。另外：两个特征值互异，几何重数 $=$ 代数重数 $=1$，故 $T$ 可对角化，新基可取 $\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2$ 与 $\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2$。

:::

:::

::: ex C16 · 求可逆 P 使 P⁻¹AP 为对角形

$A=\begin{pmatrix}1&2\\3&2\end{pmatrix}$。

(a) 求特征多项式与特征值；
(b) 求特征向量并组装 $P$；
(c) 用 $2\times2$ 的伴随公式求 $P^{-1}$，再算出 $P^{-1}AP$；
(d) 代回验证两个特征向量。

::: sol 解答

(a) $\det(\lambda I-A)=\begin{vmatrix}\lambda-1&-2\\-3&\lambda-2\end{vmatrix}=(\lambda-1)(\lambda-2)-6=\lambda^2-3\lambda-4=(\lambda-4)(\lambda+1)$，特征值为 $4$ 与 $-1$。核对：$\operatorname{tr}A=3=4+(-1)$ ✓，$\det A=2-6=-4=4\cdot(-1)$ ✓。
(b) $\lambda=4$：$A-4I=\begin{pmatrix}-3&2\\3&-2\end{pmatrix}$，$-3x_1+2x_2=0$，取 $\boldsymbol{\alpha}_1=(2,3)^{\mathrm T}$；$\lambda=-1$：$A+I=\begin{pmatrix}2&2\\3&3\end{pmatrix}$，$x_1+x_2=0$，取 $\boldsymbol{\alpha}_2=(1,-1)^{\mathrm T}$。两者不成比例，故 $P=(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2)=\begin{pmatrix}2&1\\3&-1\end{pmatrix}$，$\det P=-2-3=-5\neq0$。
(c) 伴随公式 $P^{-1}=\dfrac1{\det P}\begin{pmatrix}d&-b\\-c&a\end{pmatrix}=\dfrac1{-5}\begin{pmatrix}-1&-1\\-3&2\end{pmatrix}=\begin{pmatrix}\tfrac15&\tfrac15\\[2pt]\tfrac35&-\tfrac25\end{pmatrix}$。于是

$$P^{-1}A=\begin{pmatrix}\tfrac45&\tfrac45\\[2pt]-\tfrac35&\tfrac25\end{pmatrix},\qquad
P^{-1}AP=\begin{pmatrix}\tfrac45&\tfrac45\\[2pt]-\tfrac35&\tfrac25\end{pmatrix}\begin{pmatrix}2&1\\3&-1\end{pmatrix}=\begin{pmatrix}4&0\\0&-1\end{pmatrix}.$$
(d) $A(2,3)^{\mathrm T}=(2+6,\ 6+6)^{\mathrm T}=(8,12)^{\mathrm T}=4(2,3)^{\mathrm T}$ ✓；$A(1,-1)^{\mathrm T}=(1-2,\ 3-2)^{\mathrm T}=(-1,1)^{\mathrm T}=-(1,-1)^{\mathrm T}$ ✓。
**要点**：$P$ 的列必须是**特征向量**；把两个特征向量的顺序写反，对角阵的两个对角元也跟着换位（这正是 C23 的变形问法）。

:::

:::

::: ex C17 · 二重特征值取满几何重数：可对角化

$A=\begin{pmatrix}2&0&0\\0&2&1\\0&0&5\end{pmatrix}$。

(a) 求特征多项式与两种重数（$\lambda=2$ 用 $n-\operatorname{rank}(A-2I)$ 算）；
(b) 求 $V_2$、$V_5$ 的基；
(c) 判断能否对角化；能的话写出 $P$ 与 $P^{-1}AP$；
(d) 与 C14 对照：同样是「有一个二重特征值」，本题为什么能对角化？

::: hint 提示

判对角化只看一件事：**每个特征值的几何重数是否都取满代数重数**。先算 $\operatorname{rank}(A-2I)$：若它等于 $1$，则 $V_2$ 是二维的，二重根处就取到等号。把两组特征向量按列拼成 $P$ 时，注意**对角元的顺序**要与列的来源一致，最后用 $AP=P\Lambda$ 逐列验算。
:::

::: sol 解答

(a) 上三角：$\det(\lambda I-A)=(\lambda-2)^2(\lambda-5)$，$\lambda=2$ 的代数重数为 $2$、$\lambda=5$ 的为 $1$。核对：$\operatorname{tr}A=9=2+2+5$ ✓，$\det A=20=2\cdot2\cdot5$ ✓。
$A-2I=\begin{pmatrix}0&0&0\\0&0&1\\0&0&3\end{pmatrix}$，秩为 $1$，故几何重数 $=3-1=2$，与代数重数相等；$A-5I=\begin{pmatrix}-3&0&0\\0&-3&1\\0&0&0\end{pmatrix}$，秩为 $2$，故 $\dim V_5=3-2=1$，也与代数重数相等。
(b) $V_2$：方程只有 $x_3=0$，$V_2=\operatorname{span}\{(1,0,0)^{\mathrm T},(0,1,0)^{\mathrm T}\}$。
$V_5$：$-3x_1=0$ 给出 $x_1=0$，$-3x_2+x_3=0$ 给出 $x_3=3x_2$，取 $x_2=1$ 得 $\boldsymbol{\alpha}_3=(0,1,3)^{\mathrm T}$。
代回：$A(0,1,3)^{\mathrm T}=(0,\ 2+3,\ 15)^{\mathrm T}=(0,5,15)^{\mathrm T}=5(0,1,3)^{\mathrm T}$ ✓；$A(0,1,0)^{\mathrm T}=(0,2,0)^{\mathrm T}=2(0,1,0)^{\mathrm T}$ ✓。
(c) **能对角化**：几何重数之和 $2+1=3=n$（两种重数处处相等）。取

$$P=\begin{pmatrix}1&0&0\\0&1&1\\0&0&3\end{pmatrix},\qquad P^{-1}=\begin{pmatrix}1&0&0\\0&1&-\tfrac13\\[2pt]0&0&\tfrac13\end{pmatrix},\qquad P^{-1}AP=\operatorname{diag}(2,2,5).$$

逐列验算：$AP$ 的三列分别是 $2(1,0,0)^{\mathrm T}$、$2(0,1,0)^{\mathrm T}$、$5(0,1,3)^{\mathrm T}$，即

$$AP=\begin{pmatrix}2&0&0\\0&2&5\\0&0&15\end{pmatrix}=P\begin{pmatrix}2&0&0\\0&2&0\\0&0&5\end{pmatrix}\ \checkmark .$$
(d) C14 的 $A$ 只有一个（三重）特征值，且在那里几何重数 $2<3$，障碍出现在**唯一**的特征值上；本题的二重特征值处几何重数取满 $2$、单重特征值处必然取满 $1$，故处处相等、可对角化。**判据只认两种重数是否处处相等，与特征值是几重根无关。**

:::

:::

::: ex C18 · Givens 两步把 (3,4,5)ᵀ 化为 ‖x‖e₁

设 $\boldsymbol{x}=(3,4,5)^{\mathrm T}$。

(a) 用 $T_{12}$ 清零第 2 个分量：求 $r$、$\cos\varphi$、$\sin\varphi$，写出 $T_{12}$ 并算出 $T_{12}\boldsymbol{x}$；
(b) 用**更新后**的向量选 $T_{13}$ 清零第 3 个分量，算出最终结果；
(c) 写出总变换（注意乘法顺序），并验证它等于 $\|\boldsymbol{x}\|\boldsymbol{e}_1$；
(d) 验证 $T_{12}$ 是正交矩阵、$\det T_{12}=1$、$T_{12}^{\mathrm T}=T_{12}(-\varphi)$；
(e) 检查每一步是否保长度。

::: sol 解答

(a) 取 $i=1,j=2$：$r=\sqrt{3^2+4^2}=5$，$\cos\varphi=\dfrac{x_1}{r}=\dfrac35$，$\sin\varphi=-\dfrac{x_2}{r}=-\dfrac45$（[@thm-givens-zero]），

$$T_{12}=\begin{pmatrix}\tfrac35&\tfrac45&0\\[2pt]-\tfrac45&\tfrac35&0\\[2pt]0&0&1\end{pmatrix},\qquad T_{12}\boldsymbol{x}=\begin{pmatrix}\tfrac35\cdot3+\tfrac45\cdot4\\[2pt]-\tfrac45\cdot3+\tfrac35\cdot4\\[2pt]5\end{pmatrix}=\begin{pmatrix}5\\0\\5\end{pmatrix}.$$

（新的第 2 个分量 $-\tfrac45\cdot3+\tfrac35\cdot4=-\tfrac{12}5+\tfrac{12}5=0$ ✓，第 1 个分量合并成 $r=5$ ✓。）
(b) 必须以 $(5,0,5)^{\mathrm T}$ 为原料（用原始向量取角是常见错误，[@method-givens-align]）：$r=\sqrt{5^2+5^2}=5\sqrt2$，$\cos\varphi=\dfrac{5}{5\sqrt2}=\dfrac1{\sqrt2}$，$\sin\varphi=-\dfrac{5}{5\sqrt2}=-\dfrac1{\sqrt2}$，

$$T_{13}=\begin{pmatrix}\tfrac1{\sqrt2}&0&\tfrac1{\sqrt2}\\[2pt]0&1&0\\[2pt]-\tfrac1{\sqrt2}&0&\tfrac1{\sqrt2}\end{pmatrix},\qquad T_{13}(T_{12}\boldsymbol{x})=\begin{pmatrix}5\sqrt2\\0\\0\end{pmatrix}=5\sqrt2\,\boldsymbol{e}_1 .$$
(c) **按作用顺序反写**：先作用的 $T_{12}$ 在最右，

$$T_{13}T_{12}\boldsymbol{x}=5\sqrt2\,\boldsymbol{e}_1,\qquad \|\boldsymbol{x}\|=\sqrt{9+16+25}=\sqrt{50}=5\sqrt2 ,$$

故 $T_{13}T_{12}\boldsymbol{x}=\|\boldsymbol{x}\|\boldsymbol{e}_1$ ✓（[@method-givens-align]）。顺序写反（$T_{12}T_{13}\boldsymbol{x}$）一般不再等于 $\|\boldsymbol{x}\|\boldsymbol{e}_1$：$T_{13}$ 先把第 1、3 分量混合，随后的 $T_{12}$ 又会搅动第 2 个分量。
(d) 直接乘：

$$T_{12}^{\mathrm T}T_{12}=\begin{pmatrix}\tfrac35&-\tfrac45&0\\[2pt]\tfrac45&\tfrac35&0\\[2pt]0&0&1\end{pmatrix}\begin{pmatrix}\tfrac35&\tfrac45&0\\[2pt]-\tfrac45&\tfrac35&0\\[2pt]0&0&1\end{pmatrix}=\begin{pmatrix}1&0&0\\0&1&0\\0&0&1\end{pmatrix}$$

（用 $\cos^2\varphi+\sin^2\varphi=1$、交叉项相消）✓；$\det T_{12}=\cos^2\varphi+\sin^2\varphi=1$ ✓；$T_{12}^{\mathrm T}=\begin{pmatrix}\tfrac35&-\tfrac45&0\\[2pt]\tfrac45&\tfrac35&0\\[2pt]0&0&1\end{pmatrix}=T_{12}(-\varphi)$ ✓（[@thm-givens-props] 第 1、2 条）。
(e) $\|T_{12}\boldsymbol{x}\|=\sqrt{25+0+25}=5\sqrt2=\|\boldsymbol{x}\|$ ✓，$\|T_{13}(T_{12}\boldsymbol{x})\|=\|(5\sqrt2,0,0)^{\mathrm T}\|=5\sqrt2$ ✓——正交矩阵保长度（[@thm-orth-equiv] ②），与 (c) 的结果互相印证。

:::

:::

::: ex C19 · Givens 换一对坐标清零：先清第 3 个分量

$\boldsymbol{x}=(1,2,3)^{\mathrm T}$。

(a) 用 $T_{23}$ 清零第 3 个分量（$i=2,j=3$），写出矩阵并算出结果；
(b) 再用 $T_{12}$ 清零（更新后的）第 2 个分量，得到 $\|\boldsymbol{x}\|\boldsymbol{e}_1$；
(c) 写出总变换，并解释为什么本题先清第 3 个分量而不是第 2 个；
(d) 用 $\|\boldsymbol{x}\|=\sqrt{14}$ 核对 (b) 的结果。

::: sol 解答

(a) 取 $i=2,j=3$：$r=\sqrt{2^2+3^2}=\sqrt{13}$，$\cos\varphi=\dfrac{x_2}{r}=\dfrac2{\sqrt{13}}$，$\sin\varphi=-\dfrac{x_3}{r}=-\dfrac3{\sqrt{13}}$，

$$T_{23}=\begin{pmatrix}1&0&0\\[2pt]0&\tfrac2{\sqrt{13}}&\tfrac3{\sqrt{13}}\\[2pt]0&-\tfrac3{\sqrt{13}}&\tfrac2{\sqrt{13}}\end{pmatrix},\qquad T_{23}\boldsymbol{x}=\begin{pmatrix}1\\[2pt]\tfrac{2\cdot2+3\cdot3}{\sqrt{13}}\\[2pt]\tfrac{-3\cdot2+2\cdot3}{\sqrt{13}}\end{pmatrix}=\begin{pmatrix}1\\\sqrt{13}\\0\end{pmatrix}.$$
(b) 对 $(1,\sqrt{13},0)^{\mathrm T}$ 用 $T_{12}$：$r=\sqrt{1+13}=\sqrt{14}$，$\cos\varphi=\dfrac1{\sqrt{14}}$，$\sin\varphi=-\dfrac{\sqrt{13}}{\sqrt{14}}$，

$$T_{12}=\begin{pmatrix}\tfrac1{\sqrt{14}}&\tfrac{\sqrt{13}}{\sqrt{14}}&0\\[2pt]-\tfrac{\sqrt{13}}{\sqrt{14}}&\tfrac1{\sqrt{14}}&0\\[2pt]0&0&1\end{pmatrix},\qquad T_{12}(T_{23}\boldsymbol{x})=\begin{pmatrix}\sqrt{14}\\0\\0\end{pmatrix}=\|\boldsymbol{x}\|\boldsymbol{e}_1 .$$
(c) 总变换 $T_{12}T_{23}\boldsymbol{x}=\sqrt{14}\,\boldsymbol{e}_1$——先作用的 $T_{23}$ 写在最右（[@method-givens-align]）。本题先用 $T_{23}$ 只是一个**选择**：[@thm-givens-zero] 允许任取一对 $(i,j)$，只要「每次清零尚未处理的分量」且「用最新的向量取角」。若先清第 2 个分量（$T_{12}$）再清第 3 个（$T_{13}$），同样能到达 $\sqrt{14}\boldsymbol{e}_1$，只是中间向量的形状不同——**两种顺序都对，写总变换时不能写反**。
(d) $\|\boldsymbol{x}\|=\sqrt{1^2+2^2+3^2}=\sqrt{14}$ ✓，与 (b) 末式一致。

:::

:::

::: ex C20 · Householder 把 (0,3,4)ᵀ 映成 ‖x‖e₁

设 $\boldsymbol{x}=(0,3,4)^{\mathrm T}$。

(a) 取 $\tilde{\boldsymbol{\omega}}=\boldsymbol{x}-\|\boldsymbol{x}\|\boldsymbol{e}_1$，求 $\|\boldsymbol{x}\|$ 与单位向量 $\boldsymbol{\omega}=\tilde{\boldsymbol{\omega}}/\|\tilde{\boldsymbol{\omega}}\|$；
(b) 写出 $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$ 的显式矩阵；
(c) 验算 $H\boldsymbol{x}=\|\boldsymbol{x}\|\boldsymbol{e}_1$（先算 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{x}$ 这个数，可以少算很多）；
(d) 验证 $H^{\mathrm T}=H$、$H^2=I$、$\det H=-1$；
(e) 说明 $H$ 的镜面是哪个超平面，并指出它与「投影」的区别。

::: hint 提示

镜面取在「$\boldsymbol{x}$ 与目标方向 $\|\boldsymbol{x}\|\boldsymbol{e}_1$ 的角平分面」上，等价于取 $\boldsymbol{\omega}$ 为 $\boldsymbol{x}-\|\boldsymbol{x}\|\boldsymbol{e}_1$ 方向的单位向量（[@def-householder] 之后的思考框）。$H\boldsymbol{x}=\boldsymbol{x}-2\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{x})$——先把**数** $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{x}$ 算出来，再整体做一次减法，比先展开 $H$ 再乘向量省力得多。求 $\det H$ 也不要硬展开：找一个包含 $\boldsymbol{\omega}$ 的基，看出 $H$ 是对角阵。
:::

::: sol 解答

(a) $\|\boldsymbol{x}\|=\sqrt{0+9+16}=5$，$\tilde{\boldsymbol{\omega}}=(-5,3,4)^{\mathrm T}$，$\|\tilde{\boldsymbol{\omega}}\|=\sqrt{25+9+16}=\sqrt{50}=5\sqrt2$，

$$\boldsymbol{\omega}=\frac1{5\sqrt2}\begin{pmatrix}-5\\3\\4\end{pmatrix}=\begin{pmatrix}-\tfrac1{\sqrt2}\\[2pt]\tfrac3{5\sqrt2}\\[2pt]\tfrac4{5\sqrt2}\end{pmatrix},\qquad\|\boldsymbol{\omega}\|=1 .$$
(b) $\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=\dfrac1{50}\begin{pmatrix}25&-15&-20\\-15&9&12\\-20&12&16\end{pmatrix}$，两端乘 $2$ 得 $2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=\dfrac1{25}\begin{pmatrix}25&-15&-20\\-15&9&12\\-20&12&16\end{pmatrix}$，故

$$H=\begin{pmatrix}0&\tfrac35&\tfrac45\\[2pt]\tfrac35&\tfrac{16}{25}&-\tfrac{12}{25}\\[2pt]\tfrac45&-\tfrac{12}{25}&\tfrac9{25}\end{pmatrix}.$$
(c) $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{x}=\dfrac{-5\cdot0+3\cdot3+4\cdot4}{5\sqrt2}=\dfrac{25}{5\sqrt2}=\dfrac5{\sqrt2}$，于是

$$H\boldsymbol{x}=\boldsymbol{x}-2\cdot\frac5{\sqrt2}\,\boldsymbol{\omega}=\begin{pmatrix}0\\3\\4\end{pmatrix}-5\sqrt2\begin{pmatrix}-\tfrac1{\sqrt2}\\[2pt]\tfrac3{5\sqrt2}\\[2pt]\tfrac4{5\sqrt2}\end{pmatrix}=\begin{pmatrix}0\\3\\4\end{pmatrix}-\begin{pmatrix}-5\\3\\4\end{pmatrix}=\begin{pmatrix}5\\0\\0\end{pmatrix}=5\boldsymbol{e}_1=\|\boldsymbol{x}\|\boldsymbol{e}_1\ \checkmark .$$
(d) $H^{\mathrm T}=H$ 逐元可见（$H$ 对称）。再取两个与 $\boldsymbol{\omega}$ 正交的向量 $\boldsymbol{v}_1=(0,4,-3)^{\mathrm T}$、$\boldsymbol{v}_2=(1,3,-1)^{\mathrm T}$（$3\cdot4+4\cdot(-3)=0$，$-5+9-4=0$），直接验算

$$H\boldsymbol{v}_1=\boldsymbol{v}_1,\qquad H\boldsymbol{v}_2=\boldsymbol{v}_2,\qquad H\boldsymbol{\omega}=-\boldsymbol{\omega}.$$

于是 $H$ 在基 $\boldsymbol{\omega},\boldsymbol{v}_1,\boldsymbol{v}_2$ 下的矩阵是 $\operatorname{diag}(-1,1,1)$，与 $H$ 相似，故 $\det H=(-1)\cdot1\cdot1=-1$、$H^2=I$（对角阵的平方是 $I$）。两种重数：$\lambda=-1$ 的代数重数与几何重数都是 $1$，$\lambda=1$ 的都是 $2$，故 $H$ 可对角化（[@thm-householder-props] 第 1、2、6 条）。
(e) 镜面是超平面 $\boldsymbol{\omega}^{\perp}=\{\boldsymbol{v}\mid\boldsymbol{\omega}^{\mathrm T}\boldsymbol{v}=0\}$，$H$ 是**关于它的镜像**：$H\boldsymbol{x}=(\boldsymbol{x})_{\perp}-(\boldsymbol{x})_{\parallel}$（[@def-householder] 的几何注）。与投影 $P=I-\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$ 的区别：$P\boldsymbol{x}=(\boldsymbol{x})_{\perp}$ **丢掉**了沿 $\boldsymbol{\omega}$ 的分量，$H\boldsymbol{x}$ 则把它保留下来并**取反**；因此 $P$ 幂等（$P^2=P$）、$\|P\boldsymbol{x}\|\leq\|\boldsymbol{x}\|$、$\det P=0$，而 $H$ 对合（$H^2=I$）、$\|H\boldsymbol{x}\|=\|\boldsymbol{x}\|$、$\det H=-1$。

:::

:::

::: ex C21 · 具体 ω 的 Householder 矩阵：性质与保长度验算

取 $\boldsymbol{\omega}=\dfrac1{\sqrt2}(1,1,0)^{\mathrm T}$，$H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$。

(a) 写出 $H$；
(b) 验证 $H^{\mathrm T}=H$、$H^2=I$、$\det H=-1$；
(c) 求 $H$ 的特征值与全部特征子空间，判断能否对角化；
(d) 取 $\boldsymbol{x}=(3,1,2)^{\mathrm T}$，算 $H\boldsymbol{x}$ 并验证 $\|H\boldsymbol{x}\|=\|\boldsymbol{x}\|$；
(e) 与 Givens 矩阵 $T_{12}$ 比较：共同点与不同点各是什么？

::: sol 解答

(a) $\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=\dfrac12\begin{pmatrix}1&1&0\\1&1&0\\0&0&0\end{pmatrix}$，$2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=\begin{pmatrix}1&1&0\\1&1&0\\0&0&0\end{pmatrix}$，故

$$H=\begin{pmatrix}0&-1&0\\-1&0&0\\0&0&1\end{pmatrix}.$$
(b) 对称逐元可见。$H^2=\begin{pmatrix}0&-1&0\\-1&0&0\\0&0&1\end{pmatrix}^2=\begin{pmatrix}1&0&0\\0&1&0\\0&0&1\end{pmatrix}=I$ ✓（故 $H^{-1}=H$）。按第一行展开行列式：$\det H=0\cdot(0\cdot1-0)-(-1)\cdot\big((-1)\cdot1-0\big)+0=-(1)=-1$ ✓。
(c) $H\boldsymbol{\omega}=\dfrac1{\sqrt2}(-1,-1,0)^{\mathrm T}=-\boldsymbol{\omega}$：$\lambda=-1$，$V_{-1}=\operatorname{span}\{(1,1,0)^{\mathrm T}\}$，两种重数都是 $1$。
$H\boldsymbol{x}=\boldsymbol{x}\iff(-x_2,-x_1,x_3)^{\mathrm T}=(x_1,x_2,x_3)^{\mathrm T}\iff x_1+x_2=0$，故 $V_1=\operatorname{span}\{(1,-1,0)^{\mathrm T},(0,0,1)^{\mathrm T}\}$，两种重数都是 $2$。验算：$H(1,-1,0)^{\mathrm T}=(1,-1,0)^{\mathrm T}$ ✓，$H(0,0,1)^{\mathrm T}=(0,0,1)^{\mathrm T}$ ✓。
两种重数处处相等，故 $H$ 可对角化（[@thm-mult-ineq]）：在基 $(1,1,0)^{\mathrm T},(1,-1,0)^{\mathrm T},(0,0,1)^{\mathrm T}$ 下它就是 $\operatorname{diag}(-1,1,1)$。
(d) $H\boldsymbol{x}=(-x_2,-x_1,x_3)^{\mathrm T}=(-1,-3,2)^{\mathrm T}$；$\|H\boldsymbol{x}\|=\sqrt{1+9+4}=\sqrt{14}$，而 $\|\boldsymbol{x}\|=\sqrt{9+1+4}=\sqrt{14}$ ✓——保长度（[@thm-orth-equiv] ②），这与 $\det H=-1$（镜像）并不矛盾：镜像也是正交变换。
(e) **共同点**：两者都是正交矩阵（$A^{\mathrm T}A=I$、保长度）。**不同点**：$T_{12}$ 是**旋转**，$\det T_{12}=+1$，在 $x_1Ox_2$ 坐标面内转动 $\varphi$，可用来清零一个分量；本题的 $H$ 是**镜像**，$\det H=-1$，关于超平面 $\boldsymbol{\omega}^{\perp}=\{x_1+x_2=0\}$ 作对称（沿 $\boldsymbol{\omega}$ 的分量取反）——[@thm-orth-algebra] 第 3 条与 [@thm-householder-props] 第 6 条正给出这两个行列式。

:::

:::

::: ex C22 · 旋转 60° 的正交性与复特征值

设 $A=\begin{pmatrix}\cos\frac\pi3&-\sin\frac\pi3\\[2pt]\sin\frac\pi3&\cos\frac\pi3\end{pmatrix}=\begin{pmatrix}\frac12&-\frac{\sqrt3}2\\[2pt]\frac{\sqrt3}2&\frac12\end{pmatrix}$（逆时针旋转 $60^\circ$）。

(a) 验证 $A^{\mathrm T}A=I$，并求 $\det A$；
(b) 求 $A$ 的特征值，验证它们的模都是 $1$；
(c) 说明它们为什么不是 $\pm1$，并指出「实正交矩阵的特征值只能是 $\pm1$」错在哪里；
(d) 对一般的 $\varphi\in\mathbb{R}$，写出 $\begin{pmatrix}\cos\varphi&-\sin\varphi\\ \sin\varphi&\cos\varphi\end{pmatrix}$ 的特征值。

::: sol 解答

(a) $A^{\mathrm T}A=\begin{pmatrix}\frac12&\frac{\sqrt3}2\\[2pt]-\frac{\sqrt3}2&\frac12\end{pmatrix}\begin{pmatrix}\frac12&-\frac{\sqrt3}2\\[2pt]\frac{\sqrt3}2&\frac12\end{pmatrix}=\begin{pmatrix}\frac14+\frac34&-\frac{\sqrt3}4+\frac{\sqrt3}4\\[2pt]-\frac{\sqrt3}4+\frac{\sqrt3}4&\frac34+\frac14\end{pmatrix}=\begin{pmatrix}1&0\\0&1\end{pmatrix}$ ✓，故 $A$ 是正交矩阵（[@def-orth-matrix]）；$\det A=\frac14+\frac34=1$（旋转，[@thm-orth-algebra] 第 3 条）。
(b) $\operatorname{tr}A=1$、$\det A=1$，故 $\det(\lambda I-A)=\lambda^2-\lambda+1$，特征值为

$$\lambda=\frac{1\pm\sqrt{1-4}}2=\frac{1\pm\mathrm i\sqrt3}2=\mathrm e^{\pm\mathrm i\pi/3}.$$

$|\lambda|^2=\left(\frac12\right)^2+\left(\frac{\sqrt3}2\right)^2=\frac14+\frac34=1$，即 $|\lambda|=1$ ✓（[@thm-orth-eig]）。
(c) $\mathrm e^{\pm\mathrm i\pi/3}$ 不是实数，当然不是 $\pm1$：$A$ 在 $\mathbb{R}$ 上没有实特征值，也就没有实特征向量。「实正交矩阵的特征值只能是 $\pm1$」错在把「模为 $1$」读成了「等于 $\pm1$」；能保证的只有 $|\lambda|=1$，实特征值才必为 $\pm1$（[@errata-orth-false]、习题 A11、习题 B14）。
(d) $\operatorname{tr}=2\cos\varphi$、$\det=1$，故特征多项式为 $\lambda^2-2\lambda\cos\varphi+1$，特征值为

$$\lambda=\cos\varphi\pm\mathrm i\sin\varphi=\mathrm e^{\pm\mathrm i\varphi},\qquad|\lambda|=1 .$$

当 $\sin\varphi=0$（即 $\varphi=0$ 或 $\pi$）时特征值退化为实数 $\pm1$——这正是「$\pm1$」这个错误印象的来源。

:::

:::

::: ex C23 · 反向考题：设计一组基使矩阵为对角形

设 $V$ 是实数域上的 2 维线性空间，$\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 是基，$T\in L(V)$ 满足

$$T(\boldsymbol{\varepsilon}_1)=4\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2,\qquad T(\boldsymbol{\varepsilon}_2)=-2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2 .$$

(a) 写出 $T$ 在 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 下的矩阵 $A$；
(b) 求 $A$ 的特征值与特征向量；
(c) 求过渡矩阵 $P$ 与新基 $\boldsymbol{\varepsilon}'_1,\boldsymbol{\varepsilon}'_2$，使 $T$ 在新基下的矩阵为对角形，并写出该对角形；
(d) 不经过 $P^{-1}AP$，直接用 $T$ 的作用验证 $T(\boldsymbol{\varepsilon}'_j)=\lambda_j\boldsymbol{\varepsilon}'_j$；
(e) 变形：若要求新矩阵为 $\operatorname{diag}(3,2)$（对角元顺序相反），过渡矩阵应怎样改？

::: hint 提示

这就是 [2.4.4 的反向考题](sec24.md#sec-2.4.4)：先解特征方程拿到特征值与特征向量——它们是**新基在旧基下的坐标**；再把它们按列拼成 $P$，$P$ 的第 $j$ 列对应新矩阵的第 $j$ 个对角元。写新基时别忘了把坐标乘回 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$（[@method-eig-procedure] 第 4 步）。
:::

::: sol 解答

(a) 逐列读：$A=\begin{pmatrix}4&-2\\1&1\end{pmatrix}$。
(b) $\det(\lambda I-A)=\begin{vmatrix}\lambda-4&2\\-1&\lambda-1\end{vmatrix}=(\lambda-4)(\lambda-1)+2=\lambda^2-5\lambda+6=(\lambda-2)(\lambda-3)$，特征值为 $2$ 与 $3$。核对：$\operatorname{tr}A=5=2+3$ ✓，$\det A=4+2=6=2\cdot3$ ✓。
$\lambda=2$：$A-2I=\begin{pmatrix}2&-2\\1&-1\end{pmatrix}$，$x_1-x_2=0$，$\boldsymbol{\alpha}_1=(1,1)^{\mathrm T}$；$\lambda=3$：$A-3I=\begin{pmatrix}1&-2\\1&-2\end{pmatrix}$，$x_1-2x_2=0$，$\boldsymbol{\alpha}_2=(2,1)^{\mathrm T}$。
(c) 取 $P=(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2)=\begin{pmatrix}1&2\\1&1\end{pmatrix}$，$\det P=1-2=-1\neq0$，$P^{-1}=\begin{pmatrix}-1&2\\1&-1\end{pmatrix}$，于是

$$P^{-1}AP=\begin{pmatrix}2&0\\0&3\end{pmatrix}.$$

由 $(\boldsymbol{\varepsilon}'_1,\boldsymbol{\varepsilon}'_2)=(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2)P$ 得**新基**（过渡矩阵的列就是新基在旧基下的坐标）

$$\boldsymbol{\varepsilon}'_1=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2,\qquad \boldsymbol{\varepsilon}'_2=2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2 .$$
(d) $T(\boldsymbol{\varepsilon}'_1)=T(\boldsymbol{\varepsilon}_1)+T(\boldsymbol{\varepsilon}_2)=(4\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)+(-2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=2\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2=2\boldsymbol{\varepsilon}'_1$ ✓；
$T(\boldsymbol{\varepsilon}'_2)=2T(\boldsymbol{\varepsilon}_1)+T(\boldsymbol{\varepsilon}_2)=(8\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2)+(-2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=6\boldsymbol{\varepsilon}_1+3\boldsymbol{\varepsilon}_2=3(2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2)=3\boldsymbol{\varepsilon}'_2$ ✓。逐列读到 $(2,0)^{\mathrm T}$ 与 $(0,3)^{\mathrm T}$，与 (c) 一致。
(e) 只要把 $P$ 的两列**交换**（对角元的顺序跟着列的来源走）：取 $P'=\begin{pmatrix}2&1\\1&1\end{pmatrix}$，则 $(P')^{-1}AP'=\operatorname{diag}(3,2)$，对应的新基是 $\boldsymbol{\zeta}_1=2\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2$（属于 $3$）与 $\boldsymbol{\zeta}_2=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2$（属于 $2$）。**结论**：使矩阵为指定对角形的过渡矩阵不唯一，对角元的排列顺序由新基的排列顺序决定（[@method-design-basis] 的「考场变形」）。

:::

:::

::: ex C24 · 综合：三阶矩阵的完整对角化流程

$A=\begin{pmatrix}2&-1&0\\-1&2&0\\0&0&3\end{pmatrix}$。

(a) 求特征多项式与特征值，并用迹、行列式各核对一次；
(b) 对每个特征值求 $\operatorname{rank}(A-\lambda I)$、几何重数与 $V_\lambda$ 的基；
(c) 判断 $A$ 能否对角化；
(d) 求可逆矩阵 $P$ 使 $P^{-1}AP=\operatorname{diag}(3,3,1)$；
(e) 逐列验算 $AP=P\operatorname{diag}(3,3,1)$；
(f) 列出在这个换基过程中**不变**的量，并各给一个数值核对。

::: hint 提示

特征多项式按第一行展开（或先看出右下角的 $3$ 与左上 $2\times2$ 块解耦）最省力。两种重数都用 $n-\operatorname{rank}(A-\lambda I)$ 复核，别只凭「二重根」猜。$P$ 的列必须**依次**是 $\lambda=3,3,1$ 的特征向量——对角元的顺序由列的顺序决定；写完后用 $AP=P\Lambda$ 逐列验算，比求 $P^{-1}$ 更省力。
:::

::: sol 解答

(a) 按第一行展开（第一行只有前两个元素非零）：

$$\det(\lambda I-A)=\begin{vmatrix}\lambda-2&1&0\\1&\lambda-2&0\\0&0&\lambda-3\end{vmatrix}=(\lambda-3)\big[(\lambda-2)^2-1\big]=(\lambda-3)(\lambda-1)(\lambda-3)=(\lambda-3)^2(\lambda-1).$$

特征值：$\lambda=3$（代数重数 $2$）与 $\lambda=1$（代数重数 $1$）。
核对：$\operatorname{tr}A=2+2+3=7=3+3+1$ ✓；$\det A=3\cdot(4-1)=9=3\cdot3\cdot1$ ✓（[@thm-eig-trace]）。
(b) $\lambda=3$：$A-3I=\begin{pmatrix}-1&-1&0\\-1&-1&0\\0&0&0\end{pmatrix}$，秩为 $1$，几何重数 $=3-1=2$；方程 $x_1+x_2=0$，

$$V_3=\operatorname{span}\{(1,-1,0)^{\mathrm T},(0,0,1)^{\mathrm T}\}.$$

$\lambda=1$：$A-I=\begin{pmatrix}1&-1&0\\-1&1&0\\0&0&2\end{pmatrix}$，秩为 $2$，几何重数 $=3-2=1$（等于代数重数）；方程 $x_1=x_2$ 与 $x_3=0$，

$$V_1=\operatorname{span}\{(1,1,0)^{\mathrm T}\}.$$

代回：$A(1,-1,0)^{\mathrm T}=(2+1,\ -1-2,\ 0)^{\mathrm T}=(3,-3,0)^{\mathrm T}=3(1,-1,0)^{\mathrm T}$ ✓；$A(0,0,1)^{\mathrm T}=(0,0,3)^{\mathrm T}=3(0,0,1)^{\mathrm T}$ ✓；$A(1,1,0)^{\mathrm T}=(2-1,\ -1+2,\ 0)^{\mathrm T}=(1,1,0)^{\mathrm T}=1\cdot(1,1,0)^{\mathrm T}$ ✓。
(c) **能对角化**：几何重数之和 $2+1=3=n$，两种重数处处相等（[@thm-mult-ineq]；与 [@ex-jordan-three] 的反面情形对照）。
(d) 取

$$P=\begin{pmatrix}1&0&1\\-1&0&1\\0&1&0\end{pmatrix}\qquad(\text{三列依次为 }(1,-1,0)^{\mathrm T},\ (0,0,1)^{\mathrm T},\ (1,1,0)^{\mathrm T}),$$

$\det P=-2\neq0$，则 $P^{-1}AP=\operatorname{diag}(3,3,1)$。
(e) $A$ 作用在三列上分别是 $3(1,-1,0)^{\mathrm T}$、$3(0,0,1)^{\mathrm T}$、$1\cdot(1,1,0)^{\mathrm T}$，即

$$AP=\begin{pmatrix}3&0&1\\-3&0&1\\0&3&0\end{pmatrix}=P\begin{pmatrix}3&0&0\\0&3&0\\0&0&1\end{pmatrix}\ \checkmark .$$
(f) 换基（相似）不改变：特征多项式 $(\lambda-3)^2(\lambda-1)$、特征值 $3,3,1$（含代数重数）、$\operatorname{tr}=7$、$\det=9$、$\operatorname{rank}A=3$、几何重数 $(2,1)$（[@thm-sim-invariants]）。例如新矩阵 $\operatorname{diag}(3,3,1)$ 的迹也是 $7$ ✓、行列式也是 $9$ ✓、秩也是 $3$ ✓。**会变**的是矩阵的元素与特征向量的坐标——这正是「相似不变量是线性变换自身的量」的含义。

:::

:::

::: note 下一步

2.1–2.5 的正文与练习已全部补齐（本页 51 题，其中 2.4 / 2.5 新增 26 题）；后续「图的矩阵表示」（2.6）待素材到位后按同样结构续写。届时 2.3 的**相似**（$B=P^{-1}AP$）、**$\operatorname{rank}A$ 的映射含义**（[@thm-2.3.6]）与 2.4 的**几何重数 / 代数重数**（[@thm-mult-ineq]）将是主要入口。
:::
