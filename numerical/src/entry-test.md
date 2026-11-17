# 入学诊断自测

这一页帮助判断：**进入第一章或补充篇前，哪些基础需要补读？** 下面 12 道题覆盖先修、第一章核心结论与补充篇预备概念，建议先在 15 分钟内尝试，再逐题对照答案；限时内没做完的题也可继续作答。总分只是阅读建议，不替代七章正文的学习。

::: note 怎么用这份自测
- **闭卷**作答：先写答案，再看解析；看解析时重点核对「我错在哪一步」，而不是「猜对了几个」。
- 得分只决定路线，**不决定能力**：诊断是为了省时间，不是贴标签。
- 若你打算直接读补充篇，请确保 A 组（第 1–4 题）与 B 组（第 5–8 题）全对；错哪一题，就先补对应的小节（对照表见下）。
:::

## A 组 · 先修地基（每题 1 分）

::: ex A1 · 内积与长度

设 $\boldsymbol{x}=(1,2,2)^{\mathrm T},\ \boldsymbol{y}=(2,0,1)^{\mathrm T}$。求内积 $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}$、长度 $\lVert\boldsymbol{x}\rVert_2$ 与 $\lVert\boldsymbol{y}\rVert_2$，以及两者的夹角（用 $\arccos$ 表示即可）。

::: sol 答案
$\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=1\times2+2\times0+2\times1=4$；$\lVert\boldsymbol{x}\rVert_2=\sqrt{1+4+4}=3$；$\lVert\boldsymbol{y}\rVert_2=\sqrt{4+0+1}=\sqrt5$。

$$\cos\theta=\frac{4}{3\sqrt5}\approx0.596285,\qquad\theta\approx53.40^{\circ}.$$

**错因提示：** 若算出 $\cos\theta\gt1$，通常是忘了开根号，或把 $\lVert\boldsymbol{y}\rVert_2$ 写成了 $\lVert\boldsymbol{y}\rVert_1$。补充篇 [2.1](supplement/sec21.md) 就从内积与长度讲起。
:::

:::

::: ex A2 · Cauchy–Schwarz

陈述 Cauchy–Schwarz 不等式，并指出等号成立的条件。这个不等式在证明 $\lVert\boldsymbol{x}\rVert_2$ 满足三角不等式时起什么作用？

::: sol 答案
$\lvert\boldsymbol{x}^{\mathrm T}\boldsymbol{y}\rvert\le\lVert\boldsymbol{x}\rVert_2\lVert\boldsymbol{y}\rVert_2$，等号成立当且仅当 $\boldsymbol{x},\boldsymbol{y}$ **线性相关**。

作用：展开 $\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_2^2=\lVert\boldsymbol{x}\rVert_2^2+2\boldsymbol{x}^{\mathrm T}\boldsymbol{y}+\lVert\boldsymbol{y}\rVert_2^2$ 后，交叉项 $2\boldsymbol{x}^{\mathrm T}\boldsymbol{y}\le2\lVert\boldsymbol{x}\rVert_2\lVert\boldsymbol{y}\rVert_2$ 恰好补成完全平方 $(\lVert\boldsymbol{x}\rVert_2+\lVert\boldsymbol{y}\rVert_2)^2$。两边非负，开方得到三角不等式；这是定理 1.3.1 所采用证明的关键一步。
:::

:::

::: ex A3 · 矩阵运算

设 $A=\begin{pmatrix}1&2\\3&4\end{pmatrix}$。求 $A^{\mathrm T}A$、$\det A$ 与 $A^{-1}$。

::: sol 答案
$A^{\mathrm T}A=\begin{pmatrix}1&3\\2&4\end{pmatrix}\begin{pmatrix}1&2\\3&4\end{pmatrix}=\begin{pmatrix}10&14\\14&20\end{pmatrix}$；$\det A=1\times4-2\times3=-2$；

$$A^{-1}=\frac{1}{-2}\begin{pmatrix}4&-2\\-3&1\end{pmatrix}=\begin{pmatrix}-2&1\\1.5&-0.5\end{pmatrix}.$$

**考点：** $A^{\mathrm T}A$ 对称正定（$\det=200-196=4\gt0$，迹 $30\gt0$），而 $\lVert A\rVert_2$ 正由它的特征值决定——见 [1.3.4](ch01/sec13.md#sec-1.3.4)。
:::

:::

::: ex A4 · 特征值与正定性

$A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$ 的特征值是多少？判断 $A$ 是否正定，并写出 $\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$。

::: sol 答案
$\det(A-\lambda I)=(2-\lambda)^2-1=0\Rightarrow\lambda_1=3,\ \lambda_2=1$，都为正，故**正定**。

$A$ 对称 $\Rightarrow A^{\mathrm T}A=A^2$，特征值为 $9,1$，故 $\sqrt{\lambda_{\max}(A^2)}=3$。顺便得到 $\lVert A\rVert_2=3$、$\lVert A^{-1}\rVert_2=1$、$\mathrm{cond}_2(A)=3$。
:::

:::

## B 组 · 第一章核心结论（每题 1 分）

::: ex B1 · 误差限与有效数字

$a=0.0316$ 是某真值 $x$ 的近似值，绝对误差限 $\varepsilon(a)=0.00005$。问 $a$ 有几位有效数字？

::: sol 答案
写成规格化形式 $a=0.316\times10^{-1}$，故 $m=-1$，写出 $k=3$ 位数字。要求 $\tfrac12\times10^{m-n}=0.00005=\tfrac12\times10^{-4}$，即 $m-n=-4$，得 $n=3\le k=3$。故 $a$ 有 **3 位**有效数字。

**易错：** 小数点后紧跟的那个 $0$ 不算有效数字；有效数字从第一位非零数字 $3$ 数起。判据流程见 [1.2.2](ch01/sec12.md#sec-1.2.2)。
:::

:::

::: ex B2 · 误差传播

已知 $a=2.00\pm0.005$，$b=1.00\pm0.005$。估计 $u=a^2-b^2$ 的绝对误差限与相对误差限，并指出 $u$ 有几位有效数字。

::: sol 答案
$u=4.00-1.00=3.00$。由多元误差公式，$\partial u/\partial a=2a=4$，$\partial u/\partial b=-2b=-2$：

$$\varepsilon(u)\approx4\times0.005+2\times0.005=0.03,\qquad\varepsilon_{\mathrm r}(u)=\frac{0.03}{3.00}=1\%.$$

$u=0.300\times10^1$（$m=1$）：$n=2$ 时 $\tfrac12\times10^{-1}=0.05\ge0.03$ ✓，$n=3$ 时 $0.005\lt0.03$ ✗，故有 **2 位**有效数字。

**关键提醒：** 若 $a,b$ 很接近，$a^2-b^2$ 对输入扰动的相对敏感性会明显增大。改写为 $(a-b)(a+b)$ 可避免“先平方、再相减”造成的额外舍入损失，却不能恢复输入数据已丢失的信息。本例还可直接对区间验证：上端 $2.005^2-0.995^2=3.03$，下端 $1.995^2-1.005^2=2.97$，故 $0.03$ 恰也是严格误差限，两位有效数字的判断成立。见 [1.2.4](ch01/sec12.md#sec-1.2.4)。
:::

:::

::: ex B3 · 范数与条件数

$\lVert A\rVert_1$ 与 $\lVert A\rVert_\infty$ 分别是什么意义上的「和」？对 $A=\begin{pmatrix}1&-2\\3&4\end{pmatrix}$ 算出二者，并判断 $\lVert A\rVert_F$ 是否从属于某个向量范数。

::: sol 答案
$\lVert A\rVert_1$ 是**绝对值最大的列和**，$\lVert A\rVert_\infty$ 是**绝对值最大的行和**。

列和：$|1|+|3|=4$，$|-2|+|4|=6$ $\Rightarrow\lVert A\rVert_1=6$。行和：$1+2=3$，$3+4=7$ $\Rightarrow\lVert A\rVert_\infty=7$。

$\lVert A\rVert_F$ **不**从属于任何向量范数：任何算子范数满足 $\lVert I\rVert=1$，而 $\lVert I_2\rVert_F=\sqrt2\neq1$。见 [1.3.4](ch01/sec13.md#sec-1.3.4)。
:::

:::

::: ex B4 · 稳定性判断

一个计算问题的目标序列满足 $y_n=\dfrac1n-\beta y_{n-1}$，$|\beta|=3$。若要计算 $y_{100}$，为什么不宜直接从近似的 $y_0$ 正向递推？若改作反向递推，还缺少什么信息？

::: sol 答案
若只计初值扰动并忽略后续舍入，误差满足 $\delta_n=-\beta\delta_{n-1}$，即 $\lvert\delta_n\rvert=3^n\lvert\delta_0\rvert$，所以初值误差每步放大 3 倍。除非已有足够严格的初值与舍入误差控制，否则直接正向计算 $y_{100}$ 很难可靠；每步新增的舍入还会继续被后续递推放大。

**可考虑反向**：$y_{n-1}=\dfrac{1}{\beta n}-\dfrac{1}{\beta}y_n$，初值扰动每步缩为 $1/3$。为得到 $y_{100}$，须在更远的 $N>100$ 处建立可证明的近似初值及误差界，再反推至 100。仅有递推式无法确定目标序列，不能凭空指定远端值；正文的积分例能利用积分夹逼提供这项额外信息。见 [1.2.4](ch01/sec12.md#sec-1.2.4) 原则 (1)。
:::

:::

## C 组 · 面向补充篇的预备检查（每题 1 分）

::: ex C1 · 正交性

$\boldsymbol{q}_1=(1,1,0)^{\mathrm T}/\sqrt2$ 与 $\boldsymbol{q}_2=(1,-1,1)^{\mathrm T}/\sqrt3$ 是否正交？$\{\boldsymbol{q}_1,\boldsymbol{q}_2\}$ 能否扩充成 $\mathbb{R}^3$ 的标准正交基？

::: sol 答案
$\boldsymbol{q}_1^{\mathrm T}\boldsymbol{q}_2=\dfrac{1}{\sqrt6}\bigl[(1)(1)+(1)(-1)+(0)(1)\bigr]=0$，故**正交**；又 $\lVert\boldsymbol{q}_1\rVert_2=\lVert\boldsymbol{q}_2\rVert_2=1$，故它们是标准正交组。

两个线性无关的向量总能扩充成基，再用 Gram–Schmidt 正交化——取 $\boldsymbol{q}_3$ 为与二者都正交的单位向量即可。手算：$\boldsymbol{q}_3=(1,-1,-2)^{\mathrm T}/\sqrt6$，验证 $\boldsymbol{q}_1^{\mathrm T}\boldsymbol{q}_3=(1-1+0)/\sqrt{12}=0$、$\boldsymbol{q}_2^{\mathrm T}\boldsymbol{q}_3=(1+1-2)/\sqrt{18}=0$。这正是 [2.3](supplement/sec23.md) 的操作。
:::

:::

::: ex C2 · 投影

把 $\boldsymbol{b}=(2,2,2)^{\mathrm T}$ 正交投影到 $\boldsymbol{a}=(1,1,0)^{\mathrm T}$ 张成的直线上，投影向量与残差向量各是多少？

::: sol 答案
投影系数 $\dfrac{\boldsymbol{a}^{\mathrm T}\boldsymbol{b}}{\boldsymbol{a}^{\mathrm T}\boldsymbol{a}}=\dfrac{4}{2}=2$，故投影 $\boldsymbol{p}=2\boldsymbol{a}=(2,2,0)^{\mathrm T}$，残差 $\boldsymbol{r}=\boldsymbol{b}-\boldsymbol{p}=(0,0,2)^{\mathrm T}$。

核对：$\boldsymbol{a}^{\mathrm T}\boldsymbol{r}=0$ ✓（残差与列空间正交，这是投影的定义性质），$\lVert\boldsymbol{r}\rVert_2=2$。一般公式 $\boldsymbol{p}=\boldsymbol{a}(\boldsymbol{a}^{\mathrm T}\boldsymbol{a})^{-1}\boldsymbol{a}^{\mathrm T}\boldsymbol{b}$ 见 [2.2](supplement/sec22.md)。
:::

:::

::: ex C3 · 秩与线性相关

$A=\begin{pmatrix}1&2&3\\2&4&6\\1&1&1\end{pmatrix}$ 的秩是多少？$\boldsymbol{x}=(2,-1,0)^{\mathrm T}$ 是否属于 $A$ 的零空间？

::: sol 答案
第 2 行 $=2\times$第 1 行，故秩不超过 $2$；而第 1、3 行线性无关（不成比例），故 $\operatorname{rank}A=2$。

$A\boldsymbol{x}=(2-2,\ 4-4,\ 2-1)^{\mathrm T}=(0,0,1)^{\mathrm T}\neq\boldsymbol{0}$，故 $\boldsymbol{x}$ **不属于**零空间。零空间里的向量要满足 $x_1+2x_2+3x_3=0$ 且 $x_1+x_2+x_3=0$，可解出 $\boldsymbol{x}\in\operatorname{span}\{(1,-2,1)^{\mathrm T}\}$。**秩 + 零空间维数 $=n=3$**，与秩定理一致（[2.2](supplement/sec22.md)）。
:::

:::

::: ex C4 · SVD 概念

任何矩阵 $A\in\mathbb{R}^{m\times n}$ 都能做奇异值分解。写出分解式，并说明 $\lVert A\rVert_2$ 与 $\mathrm{cond}_2(A)$ 如何用奇异值表示。

::: sol 答案
$A=U\Sigma V^{\mathrm T}$，其中 $U\in\mathbb{R}^{m\times m}$、$V\in\mathbb{R}^{n\times n}$ 为**正交矩阵**，$\Sigma\in\mathbb{R}^{m\times n}$ 为非负对角阵（对角元 $\sigma_1\ge\cdots\ge\sigma_r\gt0$，$r=\operatorname{rank}A$）。

$$\lVert A\rVert_2=\sigma_1,\qquad \mathrm{cond}_2(A)=\sigma_1/\sigma_n\quad(A\text{ 为非奇异 }n\text{ 阶方阵}).$$

零矩阵的谱范数为零；奇异方阵的条件数记为 $\infty$。一般长方形矩阵的广义条件数须另说明约定。**这题答不出不表示先修不合格**：SVD 是补充篇要学的新工具，可沿 [2.1](supplement/sec21.md)–[2.6](supplement/sec26.md) 建立它，不必在学习前就会。
:::

:::

## 去向建议

| 得分 | 路线 | 说明 |
|:--:|:--|:--|
| **10–12 分** | 快速通道 | 若 A、B 组全对且目标是读补充篇，可先看[概念地图](preface-map.md)与[补充篇导览](supplement/overview.md)，再进 [2.1](supplement/sec21.md)；否则先补对应错题。若首次学习七章主线，仍按目录读正文。 |
| **7–9 分** | 标准路线 | 按目录顺序读：先把第一章的 [1.2](ch01/sec12.md)、[1.3](ch01/sec13.md) 两节速读一遍，并做习题集的 A、B 组，再进补充篇。 |
| **4–6 分** | 夯实路线 | 从 [1.1](ch01/sec11.md) 起逐节通读，每节末的「小结与常见错误」全做一遍，第一章习题集的 A、B 组全刷一遍，再进补充篇。 |
| **0–3 分** | 先补先修 | 先过一遍下面的[先修工具箱](entry-test.md#先修工具箱)，对照《高等代数》《数学分析》复习线性相关、特征值与 Taylor 展开，然后回本教程。 |

::: note 答错题的去向对照
A1–A2 → [1.3.1](ch01/sec13.md#sec-1.3.1)、[2.1.1](supplement/sec21.md#sup-2.1.1)；A3–A4 → [1.3.4](ch01/sec13.md#sec-1.3.4)、[2.5.5](supplement/sec25.md#sup-2.5.5)；
B1–B2 → [1.2.2](ch01/sec12.md#sec-1.2.2)、[1.2.3](ch01/sec12.md#sec-1.2.3)；B3–B4 → [1.3.3](ch01/sec13.md#sec-1.3.3)、[1.2.4](ch01/sec12.md#sec-1.2.4)；
C1–C3 → [2.1](supplement/sec21.md)、[2.2](supplement/sec22.md)；C4 → [2.6](supplement/sec26.md)。
:::

## 先修工具箱

下面六条是**第一章 + 补充篇正文反复引用、却不再重复推导**的预备事实。若不熟，先花 30 分钟扫一遍；每条都标了回查坐标。

::: method 六条先修事实

**① Taylor 公式（带余项）。** 若 $f\in C^{n+1}$ 于包含 $a,x$ 的区间，

$$f(x)=\sum_{k=0}^{n}\frac{f^{(k)}(a)}{k!}(x-a)^k+\frac{f^{(n+1)}(\xi)}{(n+1)!}(x-a)^{n+1},\qquad\xi\ \text{介于}\ a,x\ \text{之间}.$$

这是全部**误差传播公式**的来源（[1.2.3](ch01/sec12.md#sec-1.2.3)），也是 [2.5](supplement/sec25.md) 中特征值一阶扰动（Rayleigh 商）的来源。

**② 极限与 $O$ 记号。** $T(n)=O(g(n))$ 表示存在常数 $C>0$ 使 $|T(n)|\le C|g(n)|$（$n$ 足够大）。它只给量级上界，不表示一定同阶；例如线性函数也属于 $O(n^2)$。误差分析还常取 $h\to0$，此时 $O(h^p)$ 控制小步长下的误差。用法见 [1.2.4](ch01/sec12.md#sec-1.2.4)。

**③ 内积与正交（为补充篇预备）。** $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=\sum_ix_iy_i$，$\lVert\boldsymbol{x}\rVert_2=\sqrt{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}$；$\boldsymbol{x}\perp\boldsymbol{y}\iff\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=0$。两向量均非零时，内积还等于长度之积乘夹角余弦，此时正交对应夹角 $90^\circ$；零向量也与所有向量正交，但不定义夹角。[2.1](supplement/sec21.md) 把内积公理化。

**④ 线性相关、基与秩。** 一组向量线性无关，指 $\sum k_i\boldsymbol{v}_i=\boldsymbol{0}$ 只有零解；$\operatorname{rank}A$ 是 $A$ 的极大线性无关列数，它与 $A\boldsymbol{x}=\boldsymbol{0}$ 的解空间维数互补：$\operatorname{rank}A+\dim N(A)=n$。这条**秩定理**是 [2.2](supplement/sec22.md) 的主角。

**⑤ 特征值与对称矩阵。** 对方阵，$\lambda$ 是特征值当且仅当 $\det(A-\lambda I)=0$，对应特征向量须非零并满足 $A\boldsymbol v=\lambda\boldsymbol v$。实对称矩阵必可正交对角化：存在正交阵 $V$ 使 $V^{\mathrm T}AV=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$，且特征值全为实数。这是 [1.3.4](ch01/sec13.md#sec-1.3.4) 计算谱范数与 [2.5](supplement/sec25.md) 谱理论的基础。

**⑥ 正定矩阵。** 对称矩阵 $A$ 正定 $\iff$ 全部特征值 $\gt0$ $\iff$ 各阶顺序主子式 $\gt0$（Sylvester 判据）。若 $A$ 列满秩，则 $A^{\mathrm T}A$ 正定——这是 [2.2](supplement/sec22.md) 投影公式 $A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ 成立的前提（$A^{\mathrm T}A$ 可逆）。

:::

::: think[skip] 一条贯穿第一章 + 补充篇的提醒
上面六条都是**大一/大二就学过**的内容，本教程不会重讲。但请注意它们在本教程里的**新角色**：Taylor 展开从「近似公式」变成「误差界工具」；内积从「算长度」变成「定义正交、造投影、导出 SVD」；特征值从「解方程」变成「衡量敏感性」。**工具没变，看工具的角度变了**——这就是数值分析。
:::
