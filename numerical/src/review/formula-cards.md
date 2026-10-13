# 一页速览 · 公式与结论卡

这一页把两章的**必记**公式与结论压成一页，按主题排列，每条都链到正文权威版本（推导与例子在那里）。用途有二：**考前一小时过一遍**、**做题时忘了公式就跳过来**。

::: note 怎么用这一页
- **不是替代正文**：只有结论，没有推导与适用条件。第一次学别从这一页开始。
- **配合「只看核心」**：正文页点「只看核心」，可跳层内容（证明、预告、拓展思考）折叠，留下的即本页展开版。
- **自检法**：遮住右列，只看左列概念，能默写公式就打勾；默不出的点链接回读。
- 正文各节末有完整速查表（`本节公式速查`），本页是它们的**去重汇总 + 跨节合并**。
- **正文是唯一权威版本**：改公式先改正文，再同步本页——漏同步会被 `make check` 拦下（每条定义 / 定理的锚点都必须在本页或[术语索引](glossary.md)里出现）。
:::

## 一 · 误差度量（[1.2](../ch01/sec12.md)）

| 概念 | 公式 / 结论 | 出处 |
|:--|:--|:--|
| 绝对误差 / 误差限 | $e=x-a$；$\lvert e\rvert\le\varepsilon$，记作 $x=a\pm\varepsilon$ | [@def-1.2.5] |
| 相对误差 / 相对误差限 | $e_{\mathrm r}=\dfrac{x-a}{x}\approx\dfrac{x-a}{a}$；$\varepsilon_{\mathrm r}(a)=\dfrac{\varepsilon(a)}{\lvert a\rvert}$ | [@def-1.2.6] |
| 有效数字 | $a=\pm0.a_1a_2\cdots a_k\times10^m$，若 $\varepsilon(a)=\tfrac12\times10^{m-n}$（$n\le k$）则有 $n$ 位 | [@def-1.2.7] |
| 四舍五入的误差限 | 末位半个单位：$\varepsilon=\tfrac12\times10^{-d}$（舍入到小数点后 $d$ 位） | [@ex-1.2.2] |
| 有效数字 → 相对误差 | $\varepsilon_{\mathrm r}\le\dfrac{1}{2a_1}\times10^{1-n}\le\tfrac12\times10^{1-n}$；**每多一位，相对误差小十倍** | [@thm-1.2.1] |
| 四类误差 | 模型 / 观测（不可控）· 截断 / 舍入（数值分析管这两类） | [@def-1.2.1] |

**最常错的一条**：有效数字 ≠ 小数位数。$3.1416$ 对 $\pi$ 是 5 位有效数字、4 位小数（[@ex-1.2.4]）。

## 二 · 误差传播（[1.2.3](../ch01/sec12.md#sec-1.2.3)）

| 概念 | 公式 |
|:--|:--|
| 一元函数 | $e(\tilde u)\approx f'(a)\,e(a)$，$\varepsilon(\tilde u)\approx\lvert f'(a)\rvert\varepsilon(a)$（[@thm-1.2.2]） |
| 高阶零点 | 若 $f'(a)=\cdots=f^{(k-1)}(a)=0$：$\varepsilon(\tilde u)\approx\dfrac{\lvert f^{(k)}(a)\rvert}{k!}[\varepsilon(a)]^k$ |
| 多元函数 | $\varepsilon(\tilde u)\approx\sum_i\left\lvert\dfrac{\partial f}{\partial x_i}\right\rvert\varepsilon(a_i)$（式 1.1） |
| 加减法 | $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$；**绝对**误差限相加 |
| 乘除法 | $\varepsilon_{\mathrm r}(ab)\approx\varepsilon_{\mathrm r}(a)+\varepsilon_{\mathrm r}(b)$；**相对**误差限相加 |
| 减法（危险） | $\varepsilon_{\mathrm r}(a-b)=\dfrac{\varepsilon(a)+\varepsilon(b)}{\lvert a-b\rvert}$——分母趋零即爆炸 |
| 除法（危险） | $\varepsilon(a/b)\approx\dfrac{\lvert a\rvert\varepsilon(b)+\lvert b\rvert\varepsilon(a)}{\lvert b\rvert^2}$——小除数二次放大 |

**一句话记法**：加减看绝对、乘除看相对；事故全出在两个分母——$\lvert a-b\rvert$（减法）与 $\lvert b\rvert^2$（除法）。

## 三 · 算法设计四原则（[1.2.4](../ch01/sec12.md#sec-1.2.4)）

| # | 原则 | 判据 / 处方 |
|:--:|:--|:--|
| 1 | 数值稳定性 | 递推 $y_n=\alpha_n+\beta y_{n-1}$ 的误差 $\delta_n=\beta^n\delta_0$：$\lvert\beta\rvert\gt1$ 的方向**倒过来走**，用估计式定住远端初值（[@def-1.2.9]） |
| 2 | 防吞噬 | 大小悬殊的两数相加，小数整位丢失——先把小数加在一起再与大数相加 |
| 3 | 防相消 | 相近数相减先改写：有理化 / 因式分解 / 和差化积 / 中值定理 |
| 4 | 防小除数 | $\lvert b\rvert\ll\lvert a\rvert$ 时 $\varepsilon(a/b)$ 被 $\lvert b\rvert^2$ 放大——换尺度或并式化简 |

**相减本身没错**（Sterbenz 引理：$y/2\le x\le2y$ 时 $\operatorname{fl}(x-y)$ 精确，[@lem-1.2.1]）；错在把有效数字已不多的中间结果送去相减。

**秦九韶（Horner）**：$p(x)=a_0+x(a_1+x(a_2+\cdots))$，乘法 $n$ 次，$O(n)$（逐项求和则为 $O(n^2)$）。

## 四 · 浮点与条件数（[1.2.5](../ch01/sec12.md#sec-1.2.5) · [1.2.6](../ch01/sec12.md#sec-1.2.6)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 浮点集与精度 | $\mathrm{eps}=\beta^{1-t}$，$u=\tfrac12\beta^{1-t}$；双精度 $u=2^{-53}\approx1.1\times10^{-16}$（[@def-1.2.10]） |
| 浮点公理 | $\operatorname{fl}(x\ \mathrm{op}\ y)=(x\ \mathrm{op}\ y)(1+\delta)$，$\lvert\delta\rvert\le u$——**全部现代误差分析的出发点** |
| $n$ 步运算 | 相对误差 $\lesssim nu$：双精度算一万步仍可靠，算一亿步要留神 |
| 向前 / 向后误差 | 向前 = 离真值多远；向后 = 是不是某个邻近问题的精确答案（[@def-1.2.11]） |
| 函数条件数 | $\mathrm{cond}(f,x)=\left\lvert\dfrac{xf'(x)}{f(x)}\right\rvert$ |
| 两条分开谈 | **病态是问题的属性，不稳定是算法的属性**——二者独立，处方不同 |

## 五 · 向量范数（[1.3.1](../ch01/sec13.md#sec-1.3.1)–[1.3.2](../ch01/sec13.md#sec-1.3.2)）

| 概念 | 公式 |
|:--|:--|
| 三公理 | 正定 · 齐次 · 三角不等式（[@def-1.3.1]） |
| 三个常用范数 | $\lVert\boldsymbol{x}\rVert_1=\sum\lvert x_i\rvert$；$\lVert\boldsymbol{x}\rVert_2=\bigl(\sum x_i^2\bigr)^{1/2}$；$\lVert\boldsymbol{x}\rVert_\infty=\max_i\lvert x_i\rvert$（[@thm-1.3.1]） |
| $p$-范数与极限 | $\lVert\boldsymbol{x}\rVert_p=\bigl(\sum\lvert x_i\rvert^p\bigr)^{1/p}$；$\lim_{p\to\infty}\lVert\boldsymbol{x}\rVert_p=\lVert\boldsymbol{x}\rVert_\infty$（[@thm-1.3.2]） |
| 等价定理 | 任意两种范数存在 $0\lt m\lt M$ 使 $m\lVert\boldsymbol{x}\rVert_\beta\le\lVert\boldsymbol{x}\rVert_\alpha\le M\lVert\boldsymbol{x}\rVert_\beta$——**收敛结论与范数选择无关**（[@thm-1.3.3]） |
| 显式不等式 | $\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_1\le n\lVert\boldsymbol{x}\rVert_\infty$；$\lVert\boldsymbol{x}\rVert_2\le\sqrt n\lVert\boldsymbol{x}\rVert_\infty$ |
| Cauchy–Schwarz | $\lvert\boldsymbol{x}^{\mathrm T}\boldsymbol{y}\rvert\le\lVert\boldsymbol{x}\rVert_2\lVert\boldsymbol{y}\rVert_2$，等号当且仅当两向量线性相关——**2-范数三角不等式的全部依据**（[@lem-1.3.1]） |
| 反三角不等式 | $\bigl\lvert\lVert\boldsymbol{x}\rVert-\lVert\boldsymbol{y}\rVert\bigr\rvert\le\lVert\boldsymbol{x}-\boldsymbol{y}\rVert$ |

## 六 · 矩阵范数（[1.3.3](../ch01/sec13.md#sec-1.3.3)–[1.3.4](../ch01/sec13.md#sec-1.3.4)）

| 概念 | 公式 / 结论 | 记忆法 |
|:--|:--|:--|
| 四公理 | 正定 · 齐次 · 三角不等式 · **次可乘** $\lVert AB\rVert\le\lVert A\rVert\lVert B\rVert$（[@def-1.3.2]） | 第 4 条是矩阵特有 |
| 从属（算子）范数 | $\lVert A\rVert=\max_{\lVert\boldsymbol{x}\rVert=1}\lVert A\boldsymbol{x}\rVert$——**最大拉伸倍数**（[@thm-1.3.4]） | 相容性近乎同义反复 |
| 相容性 | $\lVert A\boldsymbol{x}\rVert\le\lVert A\rVert\lVert\boldsymbol{x}\rVert$（[@def-1.3.3]） | 放缩链条的通行证 |
| $\lVert A\rVert_1$ | $\max_j\sum_i\lvert a_{ij}\rvert$ | **列**和取大（「1 竖着像一根列」） |
| $\lVert A\rVert_\infty$ | $\max_i\sum_j\lvert a_{ij}\rvert$ | **行**和取大 |
| $\lVert A\rVert_2$ | $\sqrt{\lambda_{\max}(A^{\mathrm T}A)}=\sigma_{\max}(A)$（[@thm-1.3.5]） | 算 $A^{\mathrm T}A$ → 最大特征值 → 开方 |
| $\lVert A\rVert_F$ | $\bigl(\sum_{i,j}a_{ij}^2\bigr)^{1/2}$（[@def-1.3.4]） | 相容但**不**从属（$\lVert I\rVert_F=\sqrt n$） |
| 单位矩阵 | 任何算子范数下 $\lVert I\rVert=1$ | F-范数不是算子范数的判据 |

## 七 · 可逆性与 Neumann（[1.3.5](../ch01/sec13.md#sec-1.3.5)）

| 概念 | 公式 |
|:--|:--|
| Neumann 界 | $\lVert A\rVert\lt1\Rightarrow I\pm A$ 非奇异，且 $\bigl\lVert(I\pm A)^{-1}\bigr\rVert\le\dfrac{1}{1-\lVert A\rVert}$（[@thm-1.3.6]） |
| Neumann 级数 | $\lVert A\rVert\lt1\Rightarrow\sum_{k\ge0}A^k=(I-A)^{-1}$，余项 $\le\dfrac{\lVert A\rVert^{N+1}}{1-\lVert A\rVert}$（[@thm-1.3.7]） |
| 条件数（矩阵版） | $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert\ge1$；$\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert}$ |

**中学类比的矩阵版**：$\lVert A\rVert\lt1$ 即 $\lvert r\rvert\lt1$，$I-A$ 即 $1-r$，$(I-A)^{-1}=\sum A^k$ 即 $\dfrac{1}{1-r}$——迭代法收敛性全靠这一套。

## 八 · 内积与正交（[2.1](../ch02/sec21.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 内积公理 | 对称 · 对第一变元线性 · 正定（[@def-2.1.1]） |
| 诱导范数 | $\lVert\boldsymbol{x}\rVert=\sqrt{\langle\boldsymbol{x},\boldsymbol{x}\rangle}$；Cauchy–Schwarz $\lvert\langle\boldsymbol{x},\boldsymbol{y}\rangle\rvert\le\lVert\boldsymbol{x}\rVert\lVert\boldsymbol{y}\rVert$ |
| 是否来自内积 | 平行四边形恒等式 $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2+\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2=2\lVert\boldsymbol{x}\rVert^2+2\lVert\boldsymbol{y}\rVert^2$（[@thm-2.1.2]）——**只有 2-范数满足** |
| 正交组 | 两两内积为 $0$ 的非零向量组必线性无关（[@thm-2.1.3]） |
| 标准正交基坐标 | $\boldsymbol{x}=\sum_i\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i$；Parseval $\lVert\boldsymbol{x}\rVert^2=\sum_i\lvert\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\rvert^2$（[@thm-2.1.4]） |
| 正交矩阵 | $Q^{\mathrm T}Q=I$、$Q^{-1}=Q^{\mathrm T}$、$\lvert\det Q\rvert=1$、$\mathrm{cond}_2(Q)=1$、保内积保范数（[@def-2.1.3]、[@thm-2.1.5]） |
| 正交不变性 | $\lVert QA\rVert_2=\lVert A\rVert_2$，$\lVert QA\rVert_F=\lVert A\rVert_F$（[@thm-2.1.6]）——**数值算法偏爱正交变换的全部理由** |

## 九 · 四个子空间与投影（[2.2](../ch02/sec22.md)）

| 概念 | 公式 |
|:--|:--|
| 四个子空间 | $C(A)\subseteq\mathbb{R}^m$、$N(A)\subseteq\mathbb{R}^n$、$C(A^{\mathrm T})\subseteq\mathbb{R}^n$、$N(A^{\mathrm T})\subseteq\mathbb{R}^m$（[@def-2.2.1]） |
| 维数（秩定理） | $\dim C(A)=\dim C(A^{\mathrm T})=r$；$\dim N(A)=n-r$；$\dim N(A^{\mathrm T})=m-r$（[@thm-2.2.1]） |
| 两对正交补 | $C(A^{\mathrm T})=N(A)^{\perp}$；$C(A)=N(A^{\mathrm T})^{\perp}$（[@thm-2.2.2]） |
| 正交分解 | $\mathbb{R}^m=C(A)\oplus N(A^{\mathrm T})$，$\boldsymbol{b}=\boldsymbol{p}+\boldsymbol{e}$，$\boldsymbol{p}\perp\boldsymbol{e}$（[@thm-2.2.3]） |
| 投影是最近点 | 投影 $\boldsymbol{p}$ 是子空间中离 $\boldsymbol{x}$ 最近的点（[@thm-2.2.4]） |
| 投影矩阵 | $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$；$P^{\mathrm T}=P$、$P^2=P$、$\operatorname{tr}P=r$、$\lVert P\rVert_2=1$（[@thm-2.2.5]） |
| 判投影 | **对称 + 幂等**即可，不必回到定义式；只幂等不对称的是**斜投影** |
| 最小二乘 | 正态方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$；列满秩时 $\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}$（[@thm-2.2.6]） |
| 残差自检 | $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$（残差落在左零空间）——算完顺手验一下 |
| 加权版 | $\hat{\boldsymbol{x}}=(A^{\mathrm T}WA)^{-1}A^{\mathrm T}W\boldsymbol{b}$（[@thm-2.2.7]） |

## 十 · 正交化与 QR（[2.3](../ch02/sec23.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| CGS 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{a}_j$（**原始**列）——正交性损失 $\mathrm{cond}^2u$，**勿用于生产** |
| MGS 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{v}$（**当前**列）——损失 $\mathrm{cond}\,u$，一行之差 |
| QR 分解 | $A=QR$，$Q^{\mathrm T}Q=I$，$R$ 上三角；$R$ 对角元为正时唯一（[@thm-2.3.1]、[@thm-2.3.2]） |
| 分层张成 | $\operatorname{span}\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_k\}=\operatorname{span}\{\boldsymbol{a}_1,\dots,\boldsymbol{a}_k\}$——QR 区别于 SVD 的关键 |
| Householder | $H=I-2\dfrac{\boldsymbol{v}\boldsymbol{v}^{\mathrm T}}{\boldsymbol{v}^{\mathrm T}\boldsymbol{v}}$：对称、正交、$H^2=I$、$\det H=-1$（[@def-2.3.1]、[@thm-2.3.3]） |
| 消元向量 | $\boldsymbol{v}=\boldsymbol{x}+\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2\boldsymbol{e}_1$，$\alpha=-\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2$——**取反号是为了避免相近数相减** |
| Givens | $c=x_1/r$，$s=x_2/r$，$r=\texttt{hypot}(x_1,x_2)$；$\det G=+1$（[@def-2.3.2]、[@thm-2.3.4]） |
| 正交性损失 | CGS $\mathrm{cond}^2u$ ／ MGS $\mathrm{cond}\,u$ ／ Householder & Givens $u$ |
| 复杂度 | GS $2mn^2$；Householder $2mn^2-\frac23n^3$；Givens $\approx6mn^2$ |
| 选型口诀 | **稠密用 Householder，稀疏用 Givens**；MGS 在条件数温和且需要显式 $Q$ 时可用 |
| QR 解最小二乘 | $R\hat{\boldsymbol{x}}=(Q^{\mathrm T}\boldsymbol{b})_{1:n}$，$\lVert\boldsymbol{r}\rVert_2=\lVert\boldsymbol{d}\rVert_2$；误差 $\sim\mathrm{cond}(A)u$ vs 正态方程 $\sim\mathrm{cond}(A)^2u$（[@thm-2.3.5]） |

## 十一 · 条件数与扰动（[2.4](../ch02/sec24.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 条件数 | $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$；$\mathrm{cond}_2=\sigma_{\max}/\sigma_{\min}$（[@def-2.4.1]） |
| 基本性质 | $\ge1$；$\mathrm{cond}(A^{-1})=\mathrm{cond}(A)$；$\mathrm{cond}(cA)=\mathrm{cond}(A)$；$\mathrm{cond}_2(Q)=1$（[@thm-2.4.1]） |
| 右端扰动 | $\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-2.4.2]） |
| 系数扰动 | $\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}(\rho_A+\rho_b)$，需 $\mathrm{cond}\cdot\rho_A\lt1$（[@thm-2.4.3]） |
| 有效数字损失 | $k\approx\log_{10}\mathrm{cond}(A)$——**能保住几位**的定量答案 |
| 残差 ≠ 误差 | $\boldsymbol{e}=A^{-1}\boldsymbol{r}$，$\dfrac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-2.4.4]） |
| 两个阈值 | $\mathrm{cond}\gtrsim10^{8}\approx u^{-1/2}$：弃正态方程；$\mathrm{cond}\gtrsim10^{16}\approx u^{-1}$：双精度无解 |

## 十二 · 谱理论（[2.5](../ch02/sec25.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 特征值与不变量 | $A\boldsymbol{v}=\lambda\boldsymbol{v}$；$\operatorname{tr}A=\sum\lambda_i$，$\det A=\prod\lambda_i$（[@def-2.5.1]） |
| 谱半径 | $\rho(A)=\max_i\lvert\lambda_i\rvert$；**$\rho(A)\le\lVert A\rVert$（任一相容范数）**，反向一般不成立（[@thm-2.5.1]） |
| Gerschgorin | $\lvert\lambda-a_{ii}\rvert\le\sum_{j\neq i}\lvert a_{ij}\rvert$；连通并集含同样多个特征值（[@thm-2.5.2]） |
| 对角占优 | $\lvert a_{ii}\rvert\gt\sum_{j\ne i}\lvert a_{ij}\rvert\ \forall i\Rightarrow A$ 非奇异 |
| Rayleigh 商 | $R(\boldsymbol{x})=\dfrac{\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}$；$\lambda_{\min}=\min R\le R(\boldsymbol{x})\le\max R=\lambda_{\max}$（[@def-2.5.2]、[@thm-2.5.4]） |
| Courant–Fischer | $\lambda_k=\max_{\dim S=k}\min_{\boldsymbol{0}\ne\boldsymbol{x}\in S}R(\boldsymbol{x})$——全部中间特征值的变分刻画（[@thm-2.5.5]） |
| 幂法收敛 | 向量 $O(\lvert\lambda_2/\lambda_1\rvert^k)$；**Rayleigh 商 $O(\lvert\lambda_2/\lambda_1\rvert^{2k})$**（[@thm-2.5.3]） |
| 对称扰动 | $\lvert\lambda_i(A+E)-\lambda_i(A)\rvert\le\lVert E\rVert_2$（Weyl，[@thm-2.5.6]） |
| 一般扰动 | $\le\mathrm{cond}_2(V)\lVert E\rVert_2$（Bauer–Fike） |
| 重特征值 | 非正规 $k$ 重根：移动 $O(\lVert E\rVert^{1/k})$——**固有病态，换算法无效** |

## 十三 · SVD 与低秩逼近（[2.6](../ch02/sec26.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| SVD | $A=U\Sigma V^{\mathrm T}$，$\sigma_1\ge\cdots\ge\sigma_r\gt0$；$A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i$，$A^{\mathrm T}\boldsymbol{u}_i=\sigma_i\boldsymbol{v}_i$（[@thm-2.6.1]） |
| 与特征值 | $A^{\mathrm T}A\boldsymbol{v}_i=\sigma_i^2\boldsymbol{v}_i$；$AA^{\mathrm T}\boldsymbol{u}_i=\sigma_i^2\boldsymbol{u}_i$ |
| 四个子空间 | $C(A)=\operatorname{span}\{\boldsymbol{u}_1..\boldsymbol{u}_r\}$；$N(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{u}_{r+1}..\boldsymbol{u}_m\}$；$C(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{v}_1..\boldsymbol{v}_r\}$；$N(A)=\operatorname{span}\{\boldsymbol{v}_{r+1}..\boldsymbol{v}_n\}$（[@thm-2.6.2]） |
| 范数与条件数 | $\lVert A\rVert_2=\sigma_1$；$\lVert A\rVert_F=\sqrt{\sum\sigma_i^2}$；$\mathrm{cond}_2=\sigma_1/\sigma_r$；$\lvert\det A\rvert=\prod\sigma_i$ |
| 外积形式 | $A=\sum_{i\le r}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$——**秩 1 矩阵按重要性叠加** |
| 伪逆 | $A^{+}=V\Sigma^{+}U^{\mathrm T}$；Penrose 四条件；列满秩 $A^{+}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$（[@def-2.6.1]、[@thm-2.6.3]） |
| 秩亏最小二乘 | $\hat{\boldsymbol{x}}=A^{+}\boldsymbol{b}$ 是**最小范数**最小二乘解（唯一） |
| Eckart–Young | $\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_2=\lVert A-A_k\rVert_2=\sigma_{k+1}$；F-范数版 $=\sqrt{\sum_{i\gt k}\sigma_i^2}$（[@thm-2.6.4]） |
| 数值秩 | $\#\{i:\sigma_i\gt t\sigma_1\}$，$t$ 按**数据噪声水平**选，不能照抄库的默认值 |
| 迹不等式 | $\lvert\operatorname{tr}(A^{\mathrm T}B)\rvert\le\sum_i\sigma_i(A)\sigma_i(B)$（[@ex-2.6.4]） |

## 四种记忆框架

上面 13 张表不好整块背；按这四组记，每组一个动作，够了：

| 框架 | 内容 | 对应本页 |
|:--|:--|:--|
| **误差三件套** | $\varepsilon$（差多少）· $\varepsilon_{\mathrm r}$（差的比例）· $k\approx\log_{10}\mathrm{cond}$（能信几位） | 一、四、十一 |
| **四原则** | 稳定性看方向 · 防吞噬（先小后大）· 防相消（先改写）· 防小除数（换尺度） | 三 |
| **正交化解** | 稠密 Householder · 稀疏 Givens · 最小二乘用 QR · 低秩与秩亏用 SVD | 十 |
| **两把尺** | $\lVert A\rVert\lt1\Rightarrow$ 可逆 + Neumann 收敛；$\mathrm{cond}\gtrsim10^{8}$ 换 QR、$\gtrsim10^{16}$ 换问题 | 七、十一 |

## 三句话带走全部

1. **先问病态，再问算法。** 条件数是问题的属性，稳定性是算法的属性；诊断顺序一错，努力全白费（[1.2.6](../ch01/sec12.md#sec-1.2.6) 的表）。
2. **有效数字是最诚实的货币。** 一次相近数相减、一个小除数、一次大小悬殊的求和，都能让打印出的 17 位只剩 1~2 位真话。
3. **$\lVert A\rVert\lt1$ 是一张万能保票。** 同时给出 $I\pm A$ 可逆、逆有界、Neumann 级数收敛、迭代误差几何衰减——[第五章](../ch01/sec11.md#roadmap)的迭代法全靠它起步。
