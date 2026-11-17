# 一页速览 · 公式与结论卡

这一页把**第一章、补充篇与课堂主线第 2–7 章**的必记公式与结论压成一页，按主题排列，每条都链到正文权威版本（推导与例子在那里）。用途有二：**考前一小时过一遍**、**做题时忘了公式就跳过来**。

::: note 怎么用这一页
- **不是替代正文**：只列公式、必要条件与回查入口，不展开推导。第一次学别从这一页开始。
- **配合「只看核心」**：正文页点「只看核心」，可跳层内容（证明、预告、拓展思考）折叠，留下的即本页展开版。
- **自检法**：遮住右列，只看左列概念，能默写公式就打勾；默不出的点链接回读。
- 正文各节末有完整速查表（`本节公式速查`），本页是它们的**去重汇总 + 跨节合并**。
- **正文是唯一权威版本**：改公式先改正文，再同步本页与[术语索引](glossary.md)。构建会检查语义引用，但不会自动证明复习页与正文的数学表述一致，仍需人工核对。
:::

## 一 · 误差度量（[1.2](../ch01/sec12.md)）

| 概念 | 公式 / 结论 | 出处 |
|:--|:--|:--|
| 绝对误差 / 误差限 | $e=x-a$；$\lvert e\rvert\le\varepsilon$，记作 $x=a\pm\varepsilon$ | [@def-1.2.5] |
| 相对误差 / 相对误差限 | $e_{\mathrm r}=\dfrac{x-a}{x}$（$x\ne0$），误差小时 $\approx\dfrac{x-a}{a}$（$a\ne0$）；本书实用误差限 $\varepsilon_{\mathrm r}(a)=\varepsilon(a)/\lvert a\rvert$ | [@def-1.2.6] |
| 有效数字 | $a=\pm0.a_1a_2\cdots a_k\times10^m$，$a_1\ne0$；若 $\varepsilon(a)\le\tfrac12\times10^{m-n}$（$n\le k$），则至少可保证 $n$ 位 | [@def-1.2.7] |
| 四舍五入的误差限 | 末位半个单位：$\varepsilon=\tfrac12\times10^{-d}$（舍入到小数点后 $d$ 位） | [@ex-1.2.2] |
| 有效数字 → 相对误差 | $\varepsilon_{\mathrm r}\le\dfrac{1}{2a_1}\times10^{1-n}\le\tfrac12\times10^{1-n}$；每多保证一位，相应的误差上界缩小十倍 | [@thm-1.2.1] |
| 四类误差 | 模型 / 观测 / 截断 / 舍入；数值方法重点控制后两类，但也须评估输入与模型误差 | [@def-1.2.1] |

这里 $x$ 为真值、$a$ 为近似值。若要严格控制真值分母的相对误差，且 $\varepsilon<|a|$，应使用 $|e_{\mathrm r}|\le\varepsilon/(|a|-\varepsilon)$，不能直接把 $\varepsilon/|a|$ 当作它的保证界。舍入到新值 $\bar a$ 后，可取新误差限 $\varepsilon(\bar a)\le\varepsilon(a)+|a-\bar a|$，再按新值的规格化指数重新判断有效数字；不能沿用舍入前的位数。

**最常错的一条**：有效数字 ≠ 小数位数。$3.1416$ 对 $\pi$ 是 5 位有效数字、4 位小数（[@ex-1.2.4]）。

## 二 · 误差传播（[1.2.3](../ch01/sec12.md#sec-1.2.3)）

这里 $a_i$ 是输入近似值，$\tilde u=f(a_1,\dots,a_n)$；导数在近似值处取值。带 $\approx$ 的公式是一阶或首个非零项的估计，要求函数足够光滑、输入误差足够小；要作严格保证，应回正文保留余项或使用导数上界。除法还要求真除数不经过零，乘除的相对式要求有关量非零。

| 概念 | 公式 |
|:--|:--|
| 一元函数 | $e(\tilde u)\approx f'(a)\,e(a)$，$\varepsilon(\tilde u)\approx\lvert f'(a)\rvert\varepsilon(a)$（[@thm-1.2.2]） |
| 高阶零点 | 若 $f'(a)=\cdots=f^{(k-1)}(a)=0$：$\varepsilon(\tilde u)\approx\dfrac{\lvert f^{(k)}(a)\rvert}{k!}[\varepsilon(a)]^k$ |
| 多元函数 | $\varepsilon(\tilde u)\approx\sum_i\left\lvert\dfrac{\partial f}{\partial x_i}\right\rvert\varepsilon(a_i)$（式 1.1） |
| 加减法 | $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$；**绝对**误差限相加 |
| 乘除法 | $\varepsilon_{\mathrm r}(ab)\approx\varepsilon_{\mathrm r}(a)+\varepsilon_{\mathrm r}(b)$；**相对**误差限相加 |
| 减法（危险） | $\varepsilon_{\mathrm r}(a-b)=\dfrac{\varepsilon(a)+\varepsilon(b)}{\lvert a-b\rvert}$——分母趋零即爆炸 |
| 除法（危险） | $\varepsilon(a/b)\approx\dfrac{\lvert a\rvert\varepsilon(b)+\lvert b\rvert\varepsilon(a)}{\lvert b\rvert^2}$——小除数二次放大 |

**一句话记法**：加减看绝对、乘除看相对；相近数相减或除数接近零时，应检查输入误差是否已与结果同量级，而不能只凭分母大小判断。

## 三 · 算法设计四原则（[1.2.4](../ch01/sec12.md#sec-1.2.4)）

| # | 原则 | 判据 / 处方 |
|:--:|:--|:--|
| 1 | 数值稳定性 | 对仅含初值扰动的递推 $y_n=\alpha_n+\beta y_{n-1}$，$\delta_n=\beta^n\delta_0$；若 $\lvert\beta\rvert>1$，可考虑反向递推，但须有可估计的远端初值（[@def-1.2.9]） |
| 2 | 防吞噬 | 大小悬殊的两数相加，小数整位丢失——先把小数加在一起再与大数相加 |
| 3 | 防相消 | 相近数相减先改写：有理化 / 因式分解 / 和差化积 / 中值定理 |
| 4 | 防小除数 | 检查 $\varepsilon(b)/\lvert b\rvert$ 与输出容差；小除数可能放大绝对误差，但只换尺度不能消除原问题的相对敏感性 |

**相减本身未必引入舍入**：同一浮点格式中的正数 $x,y$ 若满足 $y/2\le x\le2y$，在通常的无下溢限制或支持渐进下溢的条件下，$\operatorname{fl}(x-y)$ 可精确（Sterbenz 引理，[@lem-1.2.1]）；但输入已有的误差仍可能相对结果被放大。

**秦九韶（Horner）**：$p(x)=a_0+x(a_1+x(a_2+\cdots))$，$n$ 次乘法、$O(n)$；若逐项独立重算各次幂，则为 $O(n^2)$，递推生成各次幂也可做到 $O(n)$。

## 四 · 浮点与条件数（[1.2.5](../ch01/sec12.md#sec-1.2.5) · [1.2.6](../ch01/sec12.md#sec-1.2.6)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 浮点集与精度 | $\mathrm{eps}=\beta^{1-t}$，$u=\tfrac12\beta^{1-t}$；双精度 $u=2^{-53}\approx1.1\times10^{-16}$（[@def-1.2.10]） |
| 浮点公理 | 就近舍入且无溢出、下溢影响时，$\operatorname{fl}(x\ \mathrm{op}\ y)=(x\ \mathrm{op}\ y)(1+\delta)$，$\lvert\delta\rvert\le u$ |
| $n$ 步运算 | 常用累计舍入因子 $\gamma_n=nu/(1-nu)$，需 $nu<1$；具体误差还取决于算法、相消和问题条件数，不能仅凭步数保证可靠 |
| 向前 / 向后误差 | 向前 = 离真值多远；向后 = 是不是某个邻近问题的精确答案（[@def-1.2.11]） |
| 函数条件数 | $\mathrm{cond}(f,x)=\left\lvert\dfrac{xf'(x)}{f(x)}\right\rvert$，用于可微且 $x\ne0,f(x)\ne0$ 处的一阶相对扰动分析 |
| 两条分开谈 | **病态是问题的属性，不稳定是算法的属性**——二者独立，处方不同 |

## 五 · 向量范数（[1.3.1](../ch01/sec13.md#sec-1.3.1)–[1.3.2](../ch01/sec13.md#sec-1.3.2)）

| 概念 | 公式 |
|:--|:--|
| 三公理 | 正定 · 齐次 · 三角不等式（[@def-1.3.1]） |
| 三个常用范数 | $\lVert\boldsymbol{x}\rVert_1=\sum\lvert x_i\rvert$；$\lVert\boldsymbol{x}\rVert_2=\bigl(\sum x_i^2\bigr)^{1/2}$；$\lVert\boldsymbol{x}\rVert_\infty=\max_i\lvert x_i\rvert$（[@thm-1.3.1]） |
| $p$-范数与极限 | $1\le p<\infty$ 时 $\lVert\boldsymbol{x}\rVert_p=\bigl(\sum\lvert x_i\rvert^p\bigr)^{1/p}$；$\lim_{p\to\infty}\lVert\boldsymbol{x}\rVert_p=\lVert\boldsymbol{x}\rVert_\infty$（[@thm-1.3.2]） |
| 等价定理 | 固定有限维空间上，任意两种范数存在 $0<m\le M$ 使 $m\lVert\boldsymbol{x}\rVert_\beta\le\lVert\boldsymbol{x}\rVert_\alpha\le M\lVert\boldsymbol{x}\rVert_\beta$；收敛性不变，常数可依赖维数（[@thm-1.3.3]） |
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
| $\lVert A\rVert_F$ | $\bigl(\sum_{i,j}a_{ij}^2\bigr)^{1/2}$（[@def-1.3.4]） | 相容；$n\ge2$ 时不从属（$\lVert I_n\rVert_F=\sqrt n$） |
| 单位矩阵 | 任何算子范数下 $\lVert I\rVert=1$ | F-范数不是算子范数的判据 |

## 七 · 可逆性与 Neumann（[1.3.5](../ch01/sec13.md#sec-1.3.5)）

| 概念 | 公式 |
|:--|:--|
| Neumann 界 | 匹配从属范数下，$\lVert A\rVert<1\Rightarrow I\pm A$ 非奇异，且 $\bigl\lVert(I\pm A)^{-1}\bigr\rVert\le1/(1-\lVert A\rVert)$（[@thm-1.3.6]） |
| Neumann 级数 | $\lVert A\rVert\lt1\Rightarrow\sum_{k\ge0}A^k=(I-A)^{-1}$，余项 $\le\dfrac{\lVert A\rVert^{N+1}}{1-\lVert A\rVert}$（[@thm-1.3.7]） |
| 条件数（矩阵版） | 非奇异方阵、匹配从属范数下 $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert\ge1$；$\boldsymbol b\ne0$ 且仅右端扰动时，$\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert}$ |

**中学类比的矩阵版**：$\lVert A\rVert\lt1$ 即 $\lvert r\rvert\lt1$，$I-A$ 即 $1-r$，$(I-A)^{-1}=\sum A^k$ 即 $\dfrac{1}{1-r}$——迭代法收敛性全靠这一套。

## 八 · 内积与正交（补充篇 [2.1](../supplement/sec21.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 内积公理 | 对称 · 对第一变元线性 · 正定（[@def-sup-2.1.1]） |
| 诱导范数 | $\lVert\boldsymbol{x}\rVert=\sqrt{\langle\boldsymbol{x},\boldsymbol{x}\rangle}$；Cauchy–Schwarz $\lvert\langle\boldsymbol{x},\boldsymbol{y}\rangle\rvert\le\lVert\boldsymbol{x}\rVert\lVert\boldsymbol{y}\rVert$ |
| 是否来自内积 | 当且仅当满足平行四边形恒等式 $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2+\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2=2\lVert\boldsymbol{x}\rVert^2+2\lVert\boldsymbol{y}\rVert^2$（[@thm-sup-2.1.2]）；通常 $p$-范数中，维数至少为 2 时只有 $p=2$ 满足 |
| 正交组 | 两两内积为 $0$ 的非零向量组必线性无关（[@thm-sup-2.1.3]） |
| 标准正交基坐标 | $\boldsymbol{x}=\sum_i\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i$；Parseval $\lVert\boldsymbol{x}\rVert^2=\sum_i\lvert\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\rvert^2$（[@thm-sup-2.1.4]） |
| 正交矩阵 | 实方阵 $Q$：$Q^{\mathrm T}Q=I$、$Q^{-1}=Q^{\mathrm T}$、$\lvert\det Q\rvert=1$、$\mathrm{cond}_2(Q)=1$，保 Euclid 内积与 2-范数（[@def-sup-2.1.3]、[@thm-sup-2.1.5]） |
| 正交不变性 | $\lVert QA\rVert_2=\lVert A\rVert_2$，$\lVert QA\rVert_F=\lVert A\rVert_F$（[@thm-sup-2.1.6]）；精确正交变换不放大 2-范数误差，浮点实现仍会新增舍入 |

## 九 · 四个子空间与投影（补充篇 [2.2](../supplement/sec22.md)）

| 概念 | 公式 |
|:--|:--|
| 四个子空间 | $C(A)\subseteq\mathbb{R}^m$、$N(A)\subseteq\mathbb{R}^n$、$C(A^{\mathrm T})\subseteq\mathbb{R}^n$、$N(A^{\mathrm T})\subseteq\mathbb{R}^m$（[@def-sup-2.2.1]） |
| 维数（秩定理） | $\dim C(A)=\dim C(A^{\mathrm T})=r$；$\dim N(A)=n-r$；$\dim N(A^{\mathrm T})=m-r$（[@thm-sup-2.2.1]） |
| 两对正交补 | $C(A^{\mathrm T})=N(A)^{\perp}$；$C(A)=N(A^{\mathrm T})^{\perp}$（[@thm-sup-2.2.2]） |
| 正交分解 | $\mathbb{R}^m=C(A)\oplus N(A^{\mathrm T})$，$\boldsymbol{b}=\boldsymbol{p}+\boldsymbol{e}$，$\boldsymbol{p}\perp\boldsymbol{e}$（[@thm-sup-2.2.3]） |
| 投影是最近点 | 投影 $\boldsymbol{p}$ 是子空间中离 $\boldsymbol{x}$ 最近的点（[@thm-sup-2.2.4]） |
| 投影矩阵 | $A$ 列满秩时 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$；一般可写 $P=AA^+$。$P^{\mathrm T}=P$、$P^2=P$、$\operatorname{tr}P=r$；$r>0$ 时 $\lVert P\rVert_2=1$，$r=0$ 时为 0（[@thm-sup-2.2.5]） |
| 判投影 | **对称 + 幂等**即可，不必回到定义式；只幂等不对称的是**斜投影** |
| 最小二乘 | 正态方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$；列满秩时 $\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}$（[@thm-sup-2.2.6]） |
| 残差自检 | $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$（残差落在左零空间）——算完顺手验一下 |
| 加权版 | $W$ 对称正定且 $A$ 列满秩时，$\hat{\boldsymbol{x}}=(A^{\mathrm T}WA)^{-1}A^{\mathrm T}W\boldsymbol{b}$（[@thm-sup-2.2.7]） |

## 十 · 正交化与 QR（补充篇 [2.3](../supplement/sec23.md)）

本节默认 $A\in\mathbb R^{m\times n}$、$m\ge n$ 且列满秩；$u$ 为单位舍入误差。正交性损失所列为常规浮点假设下的量级，省略维数常数，不能当成无条件等式。

| 概念 | 公式 / 结论 |
|:--|:--|
| CGS 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{a}_j$（**原始**列）——正交性损失 $\mathrm{cond}^2u$，**勿用于生产** |
| MGS 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{v}$（**当前**列）——损失 $\mathrm{cond}\,u$，一行之差 |
| QR 分解 | $A=QR$，$Q^{\mathrm T}Q=I$，$R$ 上三角；$R$ 对角元为正时唯一（[@thm-sup-2.3.1]、[@thm-sup-2.3.2]） |
| 分层张成 | $\operatorname{span}\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_k\}=\operatorname{span}\{\boldsymbol{a}_1,\dots,\boldsymbol{a}_k\}$——QR 区别于 SVD 的关键 |
| Householder | $H=I-2\dfrac{\boldsymbol{v}\boldsymbol{v}^{\mathrm T}}{\boldsymbol{v}^{\mathrm T}\boldsymbol{v}}$：对称、正交、$H^2=I$、$\det H=-1$（[@def-sup-2.3.1]、[@thm-sup-2.3.3]） |
| 消元向量 | 非零 $\boldsymbol{x}$ 取 $\boldsymbol{v}=\boldsymbol{x}+\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2\boldsymbol{e}_1$，$\alpha=-\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2$，约定 $\operatorname{sgn}(0)=1$；零向量无需消元 |
| Givens | $r=\texttt{hypot}(x_1,x_2)>0$ 时 $c=x_1/r$，$s=x_2/r$；$r=0$ 时可取 $c=1,s=0$。$\det G=+1$（[@def-sup-2.3.2]、[@thm-sup-2.3.4]） |
| 正交性损失 | CGS $\mathrm{cond}^2u$ ／ MGS $\mathrm{cond}\,u$ ／ Householder & Givens $u$ |
| 复杂度 | GS $2mn^2$；只求 $R$ 的主要项：Householder $2mn^2-\frac23n^3$，Givens $3mn^2-n^3$；显式形成 $Q$ 另计 |
| 选型提示 | 稠密通常用 Householder；Givens 适合局部消元、带状或增量更新，稀疏问题还须比较填充；MGS 需检查正交性 |
| QR 解最小二乘 | 全 QR 下 $Q^{\mathrm T}\boldsymbol b=(\boldsymbol c^{\mathrm T},\boldsymbol d^{\mathrm T})^{\mathrm T}$，$R_{1:n,1:n}\hat{\boldsymbol{x}}=\boldsymbol c$，$\lVert\boldsymbol r\rVert_2=\lVert\boldsymbol d\rVert_2$；QR 避免正规方程的条件数平方，但解误差还依赖残差与问题敏感性（[@thm-sup-2.3.5]） |

## 十一 · 条件数与扰动（补充篇 [2.4](../supplement/sec24.md)）

以下逆矩阵条件数针对非奇异方阵，采用匹配的从属范数；相对界要求 $\boldsymbol b\ne0$。记 $\rho_A=\lVert\delta A\rVert/\lVert A\rVert$、$\rho_b=\lVert\delta\boldsymbol b\rVert/\lVert\boldsymbol b\rVert$。

| 概念 | 公式 / 结论 |
|:--|:--|
| 条件数 | $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$；$\mathrm{cond}_2=\sigma_{\max}/\sigma_{\min}$（[@def-sup-2.4.1]） |
| 基本性质 | $\ge1$；$\mathrm{cond}(A^{-1})=\mathrm{cond}(A)$；$c\ne0$ 时 $\mathrm{cond}(cA)=\mathrm{cond}(A)$；正交方阵 $Q$ 有 $\mathrm{cond}_2(Q)=1$（[@thm-sup-2.4.1]） |
| 右端扰动 | $\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\delta\boldsymbol{b}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-sup-2.4.2]） |
| 系数扰动 | $\dfrac{\lVert\delta\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\le\dfrac{\mathrm{cond}(A)}{1-\mathrm{cond}(A)\rho_A}(\rho_A+\rho_b)$，需 $\mathrm{cond}\cdot\rho_A\lt1$（[@thm-sup-2.4.3]） |
| 有效数字损失 | $k\approx\log_{10}\mathrm{cond}(A)$ 是稳定求解、给定相对输入精度下的最坏情形量级估计，不是实际损失的保证 |
| 残差 ≠ 误差 | $\boldsymbol{e}=A^{-1}\boldsymbol{r}$，$\dfrac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-sup-2.4.4]） |
| 两个风险量级 | 双精度下 $\mathrm{cond}_2(A)^2u\gtrsim1$ 时，显式正规方程风险很高；$\mathrm{cond}_2(A)u\gtrsim1$ 时，一般前向精度保证失效，并非所有右端都必定算错 |

## 十二 · 谱理论（补充篇 [2.5](../supplement/sec25.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| 特征值与不变量 | $A\boldsymbol{v}=\lambda\boldsymbol{v}$；$\operatorname{tr}A=\sum\lambda_i$，$\det A=\prod\lambda_i$（[@def-sup-2.5.1]） |
| 谱半径 | $\rho(A)=\max_i\lvert\lambda_i\rvert$；**$\rho(A)\le\lVert A\rVert$（任一相容范数）**，反向一般不成立（[@thm-sup-2.5.1]） |
| Gerschgorin | 每个特征值至少落入一个圆盘 $\lvert\lambda-a_{ii}\rvert\le\sum_{j\ne i}\lvert a_{ij}\rvert$；若 $k$ 个圆盘的并与其余圆盘分离，则其中恰含 $k$ 个特征值，按代数重数计（[@thm-sup-2.5.2]） |
| 对角占优 | $\lvert a_{ii}\rvert\gt\sum_{j\ne i}\lvert a_{ij}\rvert\ \forall i\Rightarrow A$ 非奇异 |
| Rayleigh 商 | $R(\boldsymbol{x})=\dfrac{\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}$，$\boldsymbol{x}\ne0$；实对称 $A$ 有 $\lambda_{\min}\le R(\boldsymbol{x})\le\lambda_{\max}$（[@def-sup-2.5.2]、[@thm-sup-2.5.4]） |
| Courant–Fischer | 实对称矩阵按 $\lambda_1\ge\cdots\ge\lambda_n$ 排列时，$\lambda_k=\max_{\dim S=k}\min_{\boldsymbol{0}\ne\boldsymbol{x}\in S}R(\boldsymbol{x})$（[@thm-sup-2.5.5]） |
| 幂法收敛 | 可对角化、$\lvert\lambda_1\rvert>\lvert\lambda_2\rvert$ 且初值主分量非零时，方向误差 $O(\lvert\lambda_2/\lambda_1\rvert^k)$；实对称情形 Rayleigh 商误差 $O(\lvert\lambda_2/\lambda_1\rvert^{2k})$（[@thm-sup-2.5.3]） |
| 对称扰动 | $A,E$ 实对称且特征值同序排列时，$\lvert\lambda_i(A+E)-\lambda_i(A)\rvert\le\lVert E\rVert_2$（Weyl，[@thm-sup-2.5.6]） |
| 一般扰动 | 若 $A=V\Lambda V^{-1}$，则 $A+E$ 的每个特征值到 $A$ 的谱的距离不超过 $\mathrm{cond}_2(V)\lVert E\rVert_2$（Bauer–Fike），不保证逐一配对 |
| 重特征值 | 大小为 $k$ 的缺陷 Jordan 块可产生 $O(\lVert E\rVert^{1/k})$ 的位移；非正规或重根本身不必然产生此量级，换算法不能消除固有敏感性 |

## 十三 · SVD 与低秩逼近（补充篇 [2.6](../supplement/sec26.md)）

| 概念 | 公式 / 结论 |
|:--|:--|
| SVD | $A=U\Sigma V^{\mathrm T}$，$\sigma_1\ge\cdots\ge\sigma_r\gt0$；$A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i$，$A^{\mathrm T}\boldsymbol{u}_i=\sigma_i\boldsymbol{v}_i$（[@thm-sup-2.6.1]） |
| 与特征值 | $A^{\mathrm T}A\boldsymbol{v}_i=\sigma_i^2\boldsymbol{v}_i$；$AA^{\mathrm T}\boldsymbol{u}_i=\sigma_i^2\boldsymbol{u}_i$ |
| 四个子空间 | $C(A)=\operatorname{span}\{\boldsymbol{u}_1..\boldsymbol{u}_r\}$；$N(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{u}_{r+1}..\boldsymbol{u}_m\}$；$C(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{v}_1..\boldsymbol{v}_r\}$；$N(A)=\operatorname{span}\{\boldsymbol{v}_{r+1}..\boldsymbol{v}_n\}$（[@thm-sup-2.6.2]） |
| 范数与条件数 | $\lVert A\rVert_2=\sigma_1$；$\lVert A\rVert_F=\sqrt{\sum\sigma_i^2}$；非奇异方阵 $\mathrm{cond}_2=\sigma_1/\sigma_n$，奇异方阵为 $\infty$；方阵 $\lvert\det A\rvert=\prod\sigma_i$ |
| 外积形式 | $A=\sum_{i\le r}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$——**秩 1 矩阵按重要性叠加** |
| 伪逆 | $A^{+}=V\Sigma^{+}U^{\mathrm T}$；Penrose 四条件；列满秩 $A^{+}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$（[@def-sup-2.6.1]、[@thm-sup-2.6.3]） |
| 秩亏最小二乘 | $\hat{\boldsymbol{x}}=A^{+}\boldsymbol{b}$ 是**最小范数**最小二乘解（唯一） |
| Eckart–Young | $\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_2=\lVert A-A_k\rVert_2=\sigma_{k+1}$；F-范数版 $=\sqrt{\sum_{i\gt k}\sigma_i^2}$（[@thm-sup-2.6.4]） |
| 数值秩 | $\#\{i:\sigma_i\gt t\sigma_1\}$，$t$ 按**数据噪声水平**选，不能照抄库的默认值 |
| 迹不等式 | $\lvert\operatorname{tr}(A^{\mathrm T}B)\rvert\le\sum_i\sigma_i(A)\sigma_i(B)$（[@ex-sup-2.6.4]） |


## 十四 · 线性方程组（第 2 章）

### 直接法

**Doolittle 分解** $A=LU$（$L$ 单位下三角）：

$$
u_{kj}=a_{kj}-\sum_{r=1}^{k-1}l_{kr}u_{rj}\ (j\ge k),\qquad
l_{ik}=\frac{a_{ik}-\sum_{r=1}^{k-1}l_{ir}u_{rk}}{u_{kk}}\ (i>k).
$$

无主元递推要求所用主元 $u_{kk}\ne0$。解 $Ly=b$ 前代、$Ux=y$ 回代；列主元法在当前列的未消元部分选绝对值最大元，并交换整行，得到 $QA=LU$，前代右端改为 $Qb$。追赶法同样要求各 $b_i'\ne0$，最后一行无上对角项，可记 $c_n=0$。详见 [2.1](../course/ch02/sec21.md)、[2.2](../course/ch02/sec22.md)。

**追赶法**（三对角 $a_ix_{i-1}+b_ix_i+c_ix_{i+1}=d_i$）：$b_1'=b_1,\ c_1'=c_1/b_1',\ d_1'=d_1/b_1'$；对 $i=2,\dots,n$，$b_i'=b_i-a_ic_{i-1}'$，$c_i'=c_i/b_i'$，$d_i'=(d_i-a_id_{i-1}')/b_i'$；回代 $x_n=d_n'$，$x_i=d_i'-c_i'x_{i+1}$，$O(n)$。

### 条件数与误差

$$
\operatorname{cond}(A)=\lVert A\rVert\,\lVert A^{-1}\rVert,\qquad
\frac{\lVert\delta x\rVert}{\lVert x\rVert}\le\operatorname{cond}(A)\frac{\lVert\delta b\rVert}{\lVert b\rVert}.
$$

残差 $r=b-A\tilde x$ 小 **不等于** 误差小；误差界是 $\lVert x-\tilde x\rVert\le\lVert A^{-1}\rVert\lVert r\rVert$。

### 迭代法
以下采用 $A=D+L+U$，$L,U$ 分别为严格下、上三角部分（不是 LU 分解中的因子），且 $a_{ii}\ne0$；实现时解三角方程，不显式求逆。详见 [2.4 续](../course/ch02/sec24b.md)。


- Jacobi：$x^{(k+1)}=D^{-1}\big(b-(L+U)x^{(k)}\big)$，$G_J=-D^{-1}(L+U)$；
- Gauss–Seidel：$x^{(k+1)}=(D+L)^{-1}(b-Ux^{(k)})$，$G_{GS}=-(D+L)^{-1}U$；
- SOR：$x^{(k+1)}=(D+\omega L)^{-1}\big[(1-\omega)D-\omega U\big]x^{(k)}+\omega(D+\omega L)^{-1}b$。

收敛充要条件：$\rho(G)<1$。SOR 收敛的必要条件：$0<\omega<2$；严格对角占优时 Jacobi / GS 收敛，$0<\omega\le1$ 时 SOR 收敛。

## 十五 · 特征值（第 3 章）

**幂法**（求按模严格最大的特征值）：以下采用可对角化矩阵、$|\lambda_1|>|\lambda_2|$ 与初值主分量非零的假设。实矩阵在此条件下的主特征值必为实数。每步选绝对值最大的分量，但保留其符号：

$$
j_k\in\arg\max_i|(y_k)_i|,\qquad \mu_k=(y_k)_{j_k},\qquad u_k=y_k/\mu_k,\qquad y_{k+1}=Au_k.
$$

在上述收敛条件下，$\mu_k\to\lambda_1$，方向收敛比为 $|\lambda_2/\lambda_1|$；不能将带符号的主分量改成普通最大值。详见 [3.1](../course/ch03/sec31.md)。

**Rayleigh 商**：$R(x)=\dfrac{x^{\mathrm T}Ax}{x^{\mathrm T}x}$，$x\ne0$，在特征向量处等于特征值；实对称矩阵下，其特征值误差是方向误差的二阶。

**反幂法**：每步解 $(A-pI)y_{k+1}=y_k$ 再单位化，要求 $A-pI$ 非奇异；目标是离 $p$ 最近且严格分离的特征值，初值须有相应分量。$p=0$ 时求按模最小特征值。

**QR 方法**：$A_k=Q_kR_k$，$A_{k+1}=R_kQ_k=Q_k^{\mathrm T}A_kQ_k$ 保持特征值，但相似性不保证基本无位移迭代收敛。实对称情形收敛后读对角元；一般实矩阵读实 Schur 形式的一阶、二阶块。见 [3.3](../course/ch03/sec33.md)。

## 十六 · 非线性方程（第 4 章）

**二分法**：连续 $f$ 在 $[a,b]$ 两端异号。折半 $k$ 次后区间长 $(b-a)/2^k$，取该区间中点 $x_k$，有 $|s-x_k|\le(b-a)/2^{k+1}$；这是几何缩小的误差保证。见 [4.1](../course/ch04/sec41.md)。

**不动点迭代** $x_{k+1}=\varphi(x_k)$：需闭区间自映射 $\varphi([a,b])\subseteq[a,b]$、$x_0\in[a,b]$，并有统一压缩常数 $0\le L<1$（可由 $\max|\varphi'|\le L$ 验证）。此时存在唯一不动点 $s$，先验 / 后验误差估计为：

$$
|x_k-s|\le\frac{L^k}{1-L}|x_1-x_0|,\qquad
|x_k-s|\le\frac{L}{1-L}|x_k-x_{k-1}|.
$$

**Newton 法**（$f\in C^2$、$s$ 为单根且初值充分近时，局部至少二阶；这里 $e_k=x_k-s$，$\xi$ 介于 $x_k,s$ 之间）：

$$
x_{k+1}=x_k-\frac{f(x_k)}{f'(x_k)},\qquad
e_{k+1}=\frac{f''(\xi)}{2f'(x_k)}e_k^2\quad(\text{至少二阶}).
$$

$m$ 重根时收敛降为一阶，$\varphi'(s)=1-\frac1m$；修正 Newton：$x_{k+1}=x_k-m\dfrac{f(x_k)}{f'(x_k)}$。

**割线法**：$x_{k+1}=x_k-\dfrac{f(x_k)(x_k-x_{k-1})}{f(x_k)-f(x_{k-1})}$；分母须非零。光滑单根、两初值充分近且非退化时，阶 $p=\frac{1+\sqrt5}{2}\approx1.618$。

**Newton 大范围收敛的区间条件**：$f\in C^2[a,b]$、$f(a)f(b)<0$、$f''$ 不变号、$f'\ne0$，从满足 $f(x_0)f''(x_0)>0$ 的端点出发。这里“全局”不是指任意实初值；细节及退化情形见 [4.1 续](../course/ch04/sec41b.md)。

## 十七 · 插值与逼近（第 5 章）
下式节点 $x_0,\dots,x_n$ 两两不同；余项要求相应阶导数在包含节点与评价点的区间上连续，$\xi$ 在该区间内。详见 [5.1](../course/ch05/sec51.md)、[5.2](../course/ch05/sec52.md)。


**Lagrange 插值**：

$$
L_n(x)=\sum_{i=0}^nf(x_i)\ell_i(x),\qquad
\ell_i(x)=\prod_{\substack{j=0\\j\ne i}}^n\frac{x-x_j}{x_i-x_j},
$$

$$
R_n(x)=\frac{f^{(n+1)}(\xi)}{(n+1)!}\prod_{i=0}^n(x-x_i).
$$

**Newton 插值**：$N_n(x)=f[x_0]+\sum_{k=1}^nf[x_0,\dots,x_k]\prod_{i=0}^{k-1}(x-x_i)$，差商 $f[x_0,\dots,x_k]=\dfrac{f[x_1,\dots,x_k]-f[x_0,\dots,x_{k-1}]}{x_k-x_0}$；加节点只添一项。

**Hermite 插值**：在 $n+1$ 个节点各给函数值与一阶导数，共 $2n+2$ 个条件，唯一确定次数不超过 $2n+1$ 的多项式，余项

$$
R(x)=\frac{f^{(2n+2)}(\xi)}{(2n+2)!}\prod_{i=0}^n(x-x_i)^2.
$$

**三次样条**：分段三次 $S_i(x)=a_i+b_i(x-x_i)+c_i(x-x_i)^2+d_i(x-x_i)^3$，节点处函数、一阶和二阶导数连续；还须指定两端边界条件。用二阶导 $M_i$ 建立三弯矩方程求解，通常为三对角系统、$O(n)$；周期边界为循环结构。见 [5.3](../course/ch05/sec53.md)。

**最佳平方逼近**：在指定内积下，线性无关基 $\{\varphi_i\}$ 给出正定 Gram 矩阵；法方程 $G\boldsymbol a=\boldsymbol b$，$G_{ij}=(\varphi_i,\varphi_j)$，$b_i=(f,\varphi_i)$；正交基下解耦 $a_i=\dfrac{(f,\varphi_i)}{(\varphi_i,\varphi_i)}$。见 [5.5–5.6](../course/ch05/sec55.md)。

**最小二乘**：$A^{\mathrm T}A\boldsymbol c=A^{\mathrm T}\boldsymbol y$ 是最小化 $\|A\boldsymbol c-\boldsymbol y\|_2$ 的充要条件，列满秩时系数解唯一；采样求和 $(f,g)=\sum_i f(x_i)g(x_i)$ 只在采样映射无核的函数空间上才是内积，对任意函数一般只是半内积。

**四族正交多项式**：

| 族 | 区间 | 权 $\rho$ | 递推 / 生成 |
|:--|:--|:--|:--|
| Legendre $P_n$ | $[-1,1]$ | $1$ | $(n+1)P_{n+1}=(2n+1)xP_n-nP_{n-1}$ |
| Chebyshev $T_n$ | $[-1,1]$ | $1/\sqrt{1-x^2}$ | $T_n=\cos(n\arccos x)$ |
| Laguerre $U_n$ | $[0,\infty)$ | $e^{-x}$ | $U_n=e^x\frac{d^n}{dx^n}(x^ne^{-x})$ |
| Hermite $H_n$ | $(-\infty,\infty)$ | $e^{-x^2}$ | $H_n=(-1)^ne^{x^2}\frac{d^n}{dx^n}(e^{-x^2})$ |

## 十八 · 数值积分（第 6 章）

**求积公式**：$\int_a^bf\,dx\approx\sum_k\lambda_kf(x_k)$；$m$ 次代数精度 = 对 $1,x,\dots,x^m$ 精确、对 $x^{m+1}$ 不精确。
以下 $R=\int_a^bf(x)\,dx-Q$；梯形余项要求 $f\in C^2$，Simpson 要求 $f\in C^4$。复化公式取均匀节点 $x_i=a+ih$，$h=(b-a)/n$；Simpson 的子区间数 $n=2m$，奇、偶求和只遍历内部节点。详见 [6.5](../course/ch06/sec65.md)。


**梯形 / Simpson**：

$$
T=\frac{b-a}{2}[f(a)+f(b)],\qquad R_T=-\frac{(b-a)^3}{12}f''(\xi);
$$

$$
S=\frac{b-a}{6}\left[f(a)+4f\left(\frac{a+b}{2}\right)+f(b)\right],\qquad R_S=-\frac{(b-a)^5}{2880}f^{(4)}(\xi).
$$

**复化**：

$$
T_n=\frac h2\left[f(a)+2\sum_{i=1}^{n-1}f(x_i)+f(b)\right],\qquad R_T=-\frac{(b-a)h^2}{12}f''(\xi);
$$

$$
S_{2m}=\frac h3\left[f(a)+4\sum_{i\ \text{奇}}f(x_i)+2\sum_{i\ \text{偶}}f(x_i)+f(b)\right],\qquad R_S=-\frac{(b-a)h^4}{180}f^{(4)}(\xi).
$$

**逐次分半的梯形误差估计**：记 $\mathcal T_m=T_{2^m}$、$h_m=(b-a)/2^m$，避免把加密层数 $m$ 与子区间数混淆。若 $\mathcal T_m=I+Ch_m^2+o(h_m^2)$、$C\ne0$ 且主项占优，则细网格 $I-\mathcal T_{m+1}\approx(\mathcal T_{m+1}-\mathcal T_m)/3$，粗网格 $I-\mathcal T_m\approx4(\mathcal T_{m+1}-\mathcal T_m)/3$。这是带方向的渐近估计，不是严格误差界；详见 [6.5](../course/ch06/sec65.md)。

**Romberg**：$R_{k,0}=T_{2^k}$，$R_{k,j}=\dfrac{4^jR_{k,j-1}-R_{k-1,j-1}}{4^j-1}$。

**Gauss–Legendre**：节点为 $P_n$ 的根，权 $A_i=\dfrac{2}{(1-x_i^2)[P_n'(x_i)]^2}$，精度 $2n-1$；$n=2$：$x=\pm1/\sqrt3,A=1$；$n=3$：$x=0,\pm\sqrt{3/5}$，$A=8/9,5/9$。

**Gauss–Chebyshev**：用于 $\int_{-1}^1f(x)/\sqrt{1-x^2}\,dx$，$x_i=\cos\dfrac{(2i-1)\pi}{2n}$，$A_i=\dfrac\pi n$；权函数不能省略。Gauss–Legendre 对应 $[-1,1]$ 上权 1，一般区间须作仿射变换。见 [6.7](../course/ch06/sec67.md)。

## 十九 · 常微分方程（第 7 章）
这里求 $y'=f(t,y)$ 的初值问题，$t_{n+1}=t_n+h$，$f_n=f(t_n,y_n)$；后退 Euler 与梯形中的 $f_{n+1}=f(t_{n+1},y_{n+1})$ 含未知量，须解隐式方程。见 [7.1–7.2](../course/ch07/sec71.md)。


**Euler / 后退 Euler / 梯形 / 改进 Euler**：

$$
y_{n+1}=y_n+hf_n;\qquad y_{n+1}=y_n+hf_{n+1};
$$

$$
y_{n+1}=y_n+\frac h2(f_n+f_{n+1});\qquad
\bar y_{n+1}=y_n+hf_n,\quad y_{n+1}=y_n+\frac h2(f_n+f(t_{n+1},\bar y_{n+1})).
$$

**RK4**：

$$
y_{n+1}=y_n+\frac h6(k_1+2k_2+2k_3+k_4),
$$

$k_1=f(t_n,y_n)$，$k_2=f(t_n+\frac h2,y_n+\frac h2k_1)$，$k_3=f(t_n+\frac h2,y_n+\frac h2k_2)$，$k_4=f(t_n+h,y_n+hk_3)$。

**稳定性**：测试方程 $y'=\lambda y$，$z=h\lambda$，$R(z)$ 为放大因子，衰减域为 $|R(z)|<1$。Euler $R=1+z$，负实轴区间 $-2<z<0$；RK4 $R=1+z+\frac{z^2}2+\frac{z^3}6+\frac{z^4}{24}$，负实轴约 $-2.785<z<0$，不是复平面的完整稳定域。

**线性多步法**：$\sum\alpha_jy_{n+j}=h\sum\beta_jf_{n+j}$，$\rho(\zeta)=\sum\alpha_j\zeta^j$、$\sigma(\zeta)=\sum\beta_j\zeta^j$。相容：$\rho(1)=0,\rho'(1)=\sigma(1)$；零稳定：$\rho$ 的根模不大于 1，圆上根均为单根。绝对稳定考察 $\rho(\zeta)-z\sigma(\zeta)$，严格衰减域要求其根全在单位圆内；边界的有界性还须检查圆上根是否简单。见 [7.3](../course/ch07/sec73.md)。

**三步隐式 Adams**：$y_{n+3}=y_{n+2}+\frac h{24}(9f_{n+3}+19f_{n+2}-5f_{n+1}+f_n)$，四阶。将精确解代入，取“左端减右端”的未除步长缺陷，有 $-\frac{19}{720}h^5y^{(5)}(t_n)+O(h^6)$（需足够光滑）；若把残差方向反过来，符号也反转。这里的缺陷不是累积后的全局误差，见 [7.3](../course/ch07/sec73.md)。

**刚性**：稳定性要求的步长远小于准确跟踪解所需的步长；在线性衰减系统中，非零负实部特征值的比值 $r=\max|\operatorname{Re}\lambda_i|/\min|\operatorname{Re}\lambda_i|\gg1$ 是提示而非完整定义。可考虑 A-稳定的后退 Euler、梯形，或适当阶数的 Gear/BDF（1–2 阶 A-稳定、3–6 阶仅扇形稳定）；仍须检查精度与快速模态的衰减。见 [7.4–7.5](../course/ch07/sec74.md)。

## 四种记忆框架

上面的公式按以下四组回忆；每组都要连同条件使用：

| 框架 | 内容 | 对应本页 |
|:--|:--|:--|
| **误差三件套** | $\varepsilon$（差多少）· $\varepsilon_{\mathrm r}$（差的比例）· $k\approx\log_{10}\mathrm{cond}$（能信几位） | 一、四、十一 |
| **四原则** | 稳定性看方向 · 防吞噬（先小后大）· 防相消（先改写）· 防小除数（换尺度） | 三 |
| **正交化解** | 稠密通常 Householder · 局部消元 Givens · 最小二乘用 QR · 低秩与秩亏用 SVD | 十、十三 |
| **两把尺** | $\lVert A\rVert<1$ 给出充分的收缩条件；$\mathrm{cond}^2u$ 与 $\mathrm{cond}\,u$ 分别提示正规方程和一般求解的精度风险 | 七、十一 |

## 三句话带走全部

1. **分清问题与算法。** 条件数描述输入扰动的影响，稳定性描述算法新增的误差；两者要分别诊断（[1.2.6](../ch01/sec12.md#sec-1.2.6)）。
2. **显示位数不等于可靠位数。** 相消、小除数、求和次序都值得检查，但损失多少位须结合输入误差、尺度与具体算法判断。
3. **$\lVert G\rVert<1$ 是充分条件，不是唯一入口。** 它同时给出 $I-G$ 可逆、Neumann 展开与定常迭代误差的几何界；判定所有初值的迭代收敛，充要条件仍是 $\rho(G)<1$（[第 2 章](../course/ch02/overview.md)）。
