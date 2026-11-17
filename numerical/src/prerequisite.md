# 先修与自测：线性代数 · 微积分 · 编程 · 记号

这一页与[入学诊断自测](entry-test.md)分工明确：诊断页用 12 道题**决定你从哪里开始读**，本页是**随时回查的手册**——把第一章 + 补充篇正文反复引用、却不再重证的先修内容分成四块，每块给「必须会 / 可以边查边学」两级清单，并配 3–5 道自测题（答案折叠）。**不需要通读**，卡在哪里补哪里。

::: note 三条使用建议
1. **先做诊断，再用本页**：[去向建议](entry-test.md#去向建议)按得分给出路线，本页负责把那条路线上暴露出的漏洞补掉。
2. **清单分两级**：「必须会」是要能动手写出来的；「可以边查边学」是知道去哪里查就够。两级都不必背——用的时候回来查。
3. **自测题要真的写一遍**：每块末尾的题目都给了可核对的答案（含数值与复核命令）；先写再看折叠部分，做完才算读完这一页。
:::

::: method 本页在教程里的位置（六页各管一件事）

| 页 | 管什么 | 什么时候用 |
|:--|:--|:--|
| [入学诊断自测](entry-test.md) | **定位**：12 道题判断该从哪一节开始 | 开学第一次 |
| **本页** | **补漏**：四块先修的两级清单 + 自测题 | 卡壳时、读补充篇之前 |
| [工程工具箱](toolbox.md) | **操作**：误差诊断、算法选型、停止准则、函数地图 | 每一段数值代码落地时 |
| [公式与结论卡](review/formula-cards.md) | **查阅**：全书必记公式与结论（第一章、补充篇、主线第 2–7 章） | 忘了公式 |
| [易混对照卡](review/contrast-cards.md) | **辨析**：概念逐对比较与课堂术语对照 | 判断题、概念题 |
| [术语索引](review/glossary.md) | **命名**：中英术语与定义位置 | 查名字、读英文材料 |
:::

### 一、线性代数：矩阵的语言 {#sec-先修-1}

**必须会**

- **矩阵乘法的两种读法**：行观点（$A\boldsymbol{x}$ 的第 $i$ 个分量 = $A$ 的第 $i$ 行与 $\boldsymbol{x}$ 的内积）；列观点（$A\boldsymbol{x}$ 是 $A$ 的列向量以 $\boldsymbol{x}$ 的分量为系数的线性组合）。[2.2 四个基本子空间](supplement/sec22.md#sup-2.2.1) 全靠列观点。
- **转置与乘积反转**：$A\in\mathbb R^{m\times n}$、$B\in\mathbb R^{n\times p}$ 时，$(AB)^{\mathrm T}=B^{\mathrm T}A^{\mathrm T}$；$X\in\mathbb R^{m\times n}$、$Y\in\mathbb R^{n\times m}$ 时，$\operatorname{tr}(XY)=\operatorname{tr}(YX)$，两边方阵阶数可以不同。
- **秩与可逆的等价链**：对方阵 $A\in\mathbb R^{n\times n}$，$\det A\neq0$、列（行）满秩、$N(A)=\{\boldsymbol{0}\}$、对任意右端有唯一解，四条等价；长方形矩阵不能套整条链（[2.2.1](supplement/sec22.md#sup-2.2.1)）。
- **特征值与特征向量**：$A\boldsymbol{v}=\lambda\boldsymbol{v}$（$\boldsymbol{v}\neq\boldsymbol{0}$）；$\operatorname{tr}A=\sum_i\lambda_i$、$\det A=\prod_i\lambda_i$ 是最省事的验算式（[2.5.1](supplement/sec25.md#sup-2.5.1)）。
- **实对称矩阵可正交对角化**：存在正交阵 $V$ 使 $V^{\mathrm T}AV=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$，且特征值全为实数——[2.5.4 对称谱理论](supplement/sec25.md#sup-2.5.4) 的出发点。
- **内积、长度、正交**：$\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=\sum_ix_iy_i$、$\lVert\boldsymbol{x}\rVert_2=\sqrt{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}$、$\boldsymbol{x}\perp\boldsymbol{y}\iff\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=0$（[2.1.1](supplement/sec21.md#sup-2.1.1) 把这套语言公理化）。
- **初等行变换保持什么**：对增广矩阵 $[A\mid\boldsymbol b]$ 同步变换时方程组解集不变；对 $A$ 作可逆行变换，行空间与零空间不变，列空间一般会变，但秩不变——[2.2.6 常见错误 3](supplement/sec22.md#sup-2.2.6) 说明了这一区别。

**可以边查边学**

- $A^{\mathrm T}A$ 的对称正定性（$A$ 列满秩时）与正定判定：[2.2.3 投影矩阵](supplement/sec22.md#sup-2.2.3)、[入学诊断 A4](entry-test.md)。
- **维数公式** $\dim(\mathcal{S}\cap\mathcal{T})\ge\dim\mathcal{S}+\dim\mathcal{T}-n$：它是 [Eckart–Young 定理](supplement/sec26.md#sup-2.6.5) 证明里唯一的计数工具，值得单独记一条。
- 几何重数 / 代数重数与可对角化的判据：[2.5.5](supplement/sec25.md#sup-2.5.5) 用它解释「重特征值为什么开方敏感」。
- **QR 分解、SVD、伪逆的结构**（各部分长什么样、各扮演什么角色）：本教程 [2.3](supplement/sec23.md)、[2.6](supplement/sec26.md) 会完整讲；读之前见过一次即可。

::: ex 自测组 1（线性代数）{#ex-prereq-1}
1. 形状推演：$A\in\mathbb{R}^{3\times4}$、$B\in\mathbb{R}^{4\times2}$、$\boldsymbol{x}\in\mathbb{R}^4$，判断 $AB$、$BA$、$A\boldsymbol{x}$、$\boldsymbol{x}^{\mathrm T}B$ 哪些能算，并写出结果的形状。
2. 对 $A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$，求特征值、$\lVert A\rVert_2$ 与 $\mathrm{cond}_2(A)$。
3. 对 $\boldsymbol{x}=(1,2,2)^{\mathrm T}$、$\boldsymbol{y}=(2,-2,1)^{\mathrm T}$，求内积与两个长度，并判断是否正交。
4. 对 $A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$：特征值是什么？它可否对角化？由此说明「特征值全为零」为什么推不出「$A=O$」。

::: sol 答案
1. $AB$（$3\times2$）、$A\boldsymbol{x}$（$3$ 维列向量）、$\boldsymbol{x}^{\mathrm T}B$（$1\times2$，即 2 维行向量）都能算；$BA$ 无定义——$4\times2$ 乘 $3\times4$，内维 $2\neq3$。**判形状先对齐内维。**
2. $\det(A-\lambda I)=(2-\lambda)^2-1=0\Rightarrow\lambda_1=3,\ \lambda_2=1$。对称阵的奇异值就是特征值的绝对值，故 $\sigma_1=3$、$\sigma_2=1$：$\lVert A\rVert_2=3$，$\mathrm{cond}_2(A)=3$（复核：`np.linalg.cond(A, 2)` 给 $2.9999999999999996$，末位是浮点误差）。
3. $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=1\cdot2+2\cdot(-2)+2\cdot1=0$，故**正交**；$\lVert\boldsymbol{x}\rVert_2=\lVert\boldsymbol{y}\rVert_2=3$。注意「长度都是 1」与「正交」是两件独立的事：前者叫**标准**，后者要逐个验证内积为零（[2.1.4 常见错误 1](supplement/sec21.md#sup-2.1.4) 就是这条的翻车现场）。
4. $\lambda=0$（代数重数 2）；但它**不可对角化**：$A-\lambda I=A$ 的零空间只有 $\operatorname{span}\{(1,0)^{\mathrm T}\}$，几何重数 $1$ 小于代数重数 $2$。可见特征值只记录「伸缩倍数」，不含非正规部分的信息——这正是 [2.5.5](supplement/sec25.md#sup-2.5.5) 里「重特征值遇上扰动会移动 $O(\varepsilon^{1/k})$」的根源。
:::

:::

### 二、微积分：误差从哪来 {#sec-先修-2}

**必须会**

- **Taylor 公式（带 Lagrange 余项）**：若 $f\in C^{n+1}$ 于包含 $a,x$ 的区间，则 $f(x)=\sum_{k=0}^{n}\dfrac{f^{(k)}(a)}{k!}(x-a)^k+\dfrac{f^{(n+1)}(\xi)}{(n+1)!}(x-a)^{n+1}$，$\xi$ 介于 $a,x$ 之间。用导数上界控制余项，才能从近似式得到误差保证（[1.2.3](ch01/sec12.md#sec-1.2.3)）。
- **中值定理**：$f(x)-f(a)=f'(\xi)(x-a)$，由此立刻得到 $\lvert f'\rvert\le M\Rightarrow\varepsilon(f(a))\le M\varepsilon(a)$。
- **多元一阶展开**：$\varepsilon(\tilde u)\approx\sum_i\left\lvert\dfrac{\partial f}{\partial x_i}\right\rvert\varepsilon(a_i)$，导数在输入近似值处取值，要求函数足够光滑、扰动足够小；严格误差界须控制余项或用整个误差区域的导数上界（[1.2.3 式 1.1](ch01/sec12.md#sec-1.2.3)）。
- **极限与 $O$ 记号**：$O$ 给出指定极限下的常数倍上界，例如 $T(n)=O(n^2)$ 并不表示一定达到二次增长；$h\to0$ 时 $O(h^2)$ 则描述误差如何缩小（[1.2.4](ch01/sec12.md#sec-1.2.4)）。
- **收敛阶**：若非终止序列满足 $\lvert e_{k+1}\rvert/\lvert e_k\rvert^p\to C\in(0,\infty)$，称其 $p$ 阶收敛；$p=1$ 还须 $C<1$ 才为线性收敛，$p=2$ 为平方收敛。实测估阶见[工程工具箱第三节](toolbox.md#sec-工具箱-3)；割线法见[第 9 讲](lectures/lec09.md)。

**可以边查边学**

- 不动点迭代的两个条件（自映射管不越界、统一压缩管收敛）：读[第四章不动点迭代](course/ch04/sec41.md#sec-4.1.2)之前可先回查。
- **Lipschitz 连续性**：[2.5.5](supplement/sec25.md#sup-2.5.5) 里「对称矩阵的特征值对扰动是 $1$-Lipschitz 的」用的就是它。
- 凸性与「梯度为零即最小」：[2.2.4 正态方程的充分性](supplement/sec22.md#sup-2.2.4) 用了一次。
- 函数条件数 $\mathrm{cond}(f,x)=\left\lvert\dfrac{xf'(x)}{f(x)}\right\rvert$（[1.2.6](ch01/sec12.md#sec-1.2.6)），它是矩阵条件数的先声。

::: ex 自测组 2（微积分）{#ex-prereq-2}
1. 写出 $\sqrt{1+x}$ 在 $x=0$ 处的三阶 Taylor 展开，并用它估算 $\sqrt{1.02}$ 的绝对误差量级。
2. 用中值定理证明：若 $\lvert f'\rvert\le M$，则近似值 $a$ 满足 $\varepsilon(f(a))\le M\varepsilon(a)$。
3. 「平方收敛」意味着误差怎样变化？若 $e_0=10^{-2}$ 且常数 $C=1$，写出 $e_1$、$e_2$。
4. 求 $\lim_{h\to0}\dfrac{e^{h}-1-h}{h^{2}}$，并说明它在误差分析里代表什么。

::: sol 答案
1. $\sqrt{1+x}=1+\dfrac{x}{2}-\dfrac{x^{2}}8+\dfrac{x^{3}}{16}+O(x^4)$。取 $x=0.02$，三阶近似为 $1.0099505$，真值 $1.0099504938\ldots$，误差约 $6.2\times10^{-9}$，与首个舍去项 $5x^4/128$ 同量级。若只用二阶式，则为 $1.00995$，误差约 $4.9\times10^{-7}$，对应舍去的 $x^3/16$。
2. $f(x)-f(a)=f'(\xi)(x-a)$，两边取绝对值：$\lvert f(x)-f(a)\rvert\le M\lvert x-a\rvert\le M\varepsilon(a)$，即得 $\varepsilon(f(a))\le M\varepsilon(a)$。
3. 误差满足 $|e_{k+1}|\approx C|e_k|^2$，所以本题 $e_1\approx10^{-4}$、$e_2\approx10^{-8}$。当目标值非零、尺度基本固定且尚未受舍入支配时，可粗略说可靠数字约翻倍；零根附近应直接讨论绝对误差，不能无条件谈相对有效数字。
4. 极限为 $\dfrac12$。它是 $e^h=1+h+\dfrac{h^2}2+O(h^3)$ 中二次项的系数：以 $1+h$ 近似 $e^h$，误差首项为 $h^2/2$；若再除以 $h$ 作前向差商，导数近似的截断误差首项为 $h/2$，不要把函数余项和差商误差混为一谈（[1.2.3](ch01/sec12.md#sec-1.2.3)）。
:::

:::

### 三、编程：Python + NumPy {#sec-先修-3}

**必须会**

- Python 基本语法：函数、循环、列表与字典，`import numpy as np`。
- **NumPy 数组的形状与运算**：`A.shape`、`A.T`、`A @ x`（矩阵乘）、`A * B`（逐元素乘）、切片与 `np.arange` / `np.linspace`。
- **向量化**：例如把逐行点积的双循环改写为 `A @ x`，通常可减少 Python 解释器开销，并利用 BLAS；是否更快还取决于规模、存储布局与后端。
- **浮点常识**：`float64` 的单位舍入误差 $u\approx1.1\times10^{-16}$；近似比较可用 `np.isclose`，但要按量纲、尺度和误差目标显式设置 `atol`、`rtol`，默认容差不是数学精度保证（[附录 B.2](appendix/float.md#app-b-2)、[附录 B.6](appendix/float.md#app-b-6)）。
- **`np.linalg` 六个常用函数**：`solve`（解方程）、`qr`、`svd`、`lstsq`（最小二乘）、`cond`（条件数）、`norm`（范数）。选型细节见[工程工具箱第四节](toolbox.md#sec-工具箱-4)。

**可以边查边学**

- 随机数：`rng = np.random.default_rng(0)`，之后所有随机量都从 `rng` 取（[2.7](supplement/sec27.md) 的实验报告要求写清种子）。
- 稀疏矩阵与迭代解法：`scipy.sparse`（[工具箱第四节](toolbox.md#sec-工具箱-4)）。
- 计时：`%timeit`（IPython）或 `time.perf_counter()`。
- 画图：`matplotlib`——画奇异值谱、残差下降曲线，是[2.7 实验报告](supplement/sec27.md)的基本要求。

::: ex 自测组 3（编程）{#ex-prereq-3}
1. 判断并解释：`1.0 + 2**-53 == 1.0`、`1.0 + 2**-52 == 1.0` 分别是 `True` 还是 `False`。
2. 已知 $A\in\mathbb R^{n\times n}$、$\boldsymbol x\in\mathbb R^n$，把“对每一行令 `s[i] = 0`，再执行 `for j in range(n): s[i] += A[i, j] * x[j]`”改写成一行，并说明它为什么通常更快。
3. 各用一行代码求 $A$ 的 $\lVert A\rVert_2$、$\lVert A\rVert_F$、$\mathrm{cond}_2(A)$ 与数值秩。
4. 说明 `np.linalg.solve(A, b)` 与 `np.linalg.inv(A) @ b` 的区别（代价、精度各一条）。

::: sol 答案
1. 依次是 `True`、`False`。$2^{-53}$ 恰是 $1.0$ 与上方相邻浮点数间距 $2^{-52}$ 的一半，按「平局判偶」（round-half-to-even）舍回 $1.0$；稍大于 $2^{-53}$ 的可表示增量也可能使结果舍到上一格，并非必须加满 $2^{-52}$。两个常数的来历见[附录 B.2](appendix/float.md#app-b-2)。
2. `s = A @ x`。NumPy 通常把乘加交给编译好的 BLAS，减少解释器逐元素开销；具体累加顺序由后端决定，不能保证一定使用成对求和（[附录 B.4](appendix/float.md#app-b-4)）。若原程序只有单一标量 `s` 且跨两层循环累加，得到的是所有行结果之和，不是向量 $A\boldsymbol x$。
3. `np.linalg.norm(A, 2)`、`np.linalg.norm(A, 'fro')`、`np.linalg.cond(A, 2)`、`np.linalg.matrix_rank(A)`。最后一条的默认阈值有陷阱，见[工具箱第五节](toolbox.md#sec-工具箱-5)。
4. **代价**：`inv` 要先做 LU 再显式构造逆（约 $n^{3}$ 的额外工作），比「LU + 两次回代」（约 $\frac23n^{3}+2n^{2}$）贵约 2.5 倍。**精度**：显式求逆多引入一层舍入——8 阶 Hilbert 矩阵上实测，`solve` 的最大误差 $1.2\times10^{-7}$，`inv @ b` 为 $7.2\times10^{-7}$，约差 6 倍（[工具箱第五节](toolbox.md#sec-工具箱-5) 给完整复算）。
:::

:::

### 四、记号与约定 {#sec-先修-4}

**必须会**（[符号表](preface-notation.md) 的三条约定 + 补充篇新增符号）

- **误差限写成 $\varepsilon\ge0$**：如选取 $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$ 作安全上界；带符号误差 $e=x-a$ 则用于推导与方向分析。
- **向量粗体 $\boldsymbol{x}$、矩阵大写斜体 $A$**；$\lVert A\rVert_p$ 不带说明时默认指**从属（算子）范数**，而 $\lVert A\rVert_F$ **不从属**（$\lVert I\rVert_F=\sqrt n$）。
- **$\mathrm{cond}(A)$ 必须注明范数**：$\mathrm{cond}_1$、$\mathrm{cond}_2$、$\mathrm{cond}_\infty$ 的数值可以差 $n$ 倍量级；只有谈「丢几位」的量级结论时才可以省。
- **$\sigma(A)$ 与 $\sigma_i(A)$ 不是一回事**：前者是**谱**（特征值集合），后者是**奇异值**（降序排列）；另有 $\rho(A)=\max_i\lvert\lambda_i\rvert\le\lVert A\rVert$。
- **补充篇专有记号**：$C(A)$、$N(A)$、$C(A^{\mathrm T})$、$N(A^{\mathrm T})$（四个基本子空间）、$P$（正交投影矩阵）、$H$（Householder 反射）、$G$（Givens 旋转）、$A^{+}$（伪逆）、$R(\boldsymbol{x})$（Rayleigh 商）。

**可以边查边学**

- 讲座页的三处记号差异（向量写斜体 $x$、误差限记 $\varepsilon_x$、$P$ 与 $D$ 撞名）：[课堂精编导览](lectures/overview.md#notation-diff)。
- 原书编号 ↔ 本教程编号的对照：[1.3 节编号对照](ch01/sec13.md#sec-1.3.1)、[第一章勘误与补注](ch01/errata.md)。

::: ex 自测组 4（记号）{#ex-prereq-4}
1. $u$ 与 $\mathrm{eps}$ 哪个大？差几倍？
2. 有人说「这个矩阵的条件数是 $10^{10}$，所以解只能信 6 位」。这句话缺了什么？
3. $\lVert A\rVert_2$ 与 $\lambda_{\max}(A)$ 是一回事吗？什么情况下是？

::: sol 答案
1. $\mathrm{eps}=2u$。就近舍入、无溢出或下溢影响时，$\mathrm{eps}=2^{-52}\approx2.22\times10^{-16}$ 是 $1.0$ 与上方相邻浮点数的间距；$u=2^{-53}\approx1.11\times10^{-16}$ 是相对舍入误差的通用上界（[附录 B.2](appendix/float.md#app-b-2)）。
2. 缺少范数、输入数据精度、算法后向误差及目标容差。即使已知 $\mathrm{cond}_2(A)=10^{10}$ 且双精度稳定计算，$\mathrm{cond}_2(A)u\approx10^{-6}$ 也只是最坏情形风险量级，不能断定实际恰好只剩 6 位；误差可能远小于该界（[2.4.6 常见错误 5、6](supplement/sec24.md#sup-2.4.6)）。
3. 一般不是：$\lVert A\rVert_2=\sigma_1=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$。实对称（更一般为正规）矩阵满足 $\lVert A\rVert_2=\rho(A)=\max_i\lvert\lambda_i\rvert$；不能只取代数上最大的特征值。对称半正定时才保证 $\lVert A\rVert_2=\lambda_{\max}(A)$（[1.3.4](ch01/sec13.md#sec-1.3.4)、[2.5.1](supplement/sec25.md#sup-2.5.1)）。
:::

:::

### 五、五分钟自测（做完即可开始补充篇）{#sec-先修-5}

下面 6 题把四块先修与第一章 + 补充篇的入口串起来；闭卷作答，写完再看答案。

::: ex 五分钟自测 {#ex-prereq-5min}
1. $\mathrm{cond}_2(A)=10^{12}$，仅右端相对扰动为 $10^{-16}$，解的相对扰动最坏可放大到什么量级？这能否确定实际有效数字位数？
2. $A=\begin{pmatrix}1&1\\1&1+\varepsilon\end{pmatrix}$（$\varepsilon=10^{-11}$），取 $b=A(1,1)^{\mathrm T}$：为什么残差可在 $10^{-12}$ 量级，而解的相对误差仍能到 $50\%$？
3. 用一句话说明「正交变换不放大误差」为什么对数值算法重要。
4. 对列满秩最小二乘问题 $\min\lVert A\boldsymbol x-\boldsymbol b\rVert_2$，若 $\mathrm{cond}_2(A)=10^6$，用正规方程还是 QR？若为 $10^{10}$ 呢？采用双精度 $u\approx10^{-16}$，先比较风险量 $\mathrm{cond}_2(A)^2u$。
5. 写出 SVD，并用奇异值表示 $\lVert A\rVert_2$、非奇异方阵的 $\mathrm{cond}_2(A)$ 与一般矩阵的 $\operatorname{rank}A$。
6. $\rho(A)\lt1$ 是否保证每一步都在收缩？更稳妥的判据是什么？

::: sol 答案
1. 右端扰动界给出相对解扰动不超过 $10^{12}\times10^{-16}=10^{-4}$。可粗略说精度风险在“四位左右”的量级，但不能据此断定实际恰有 4 位有效数字；精确位数还须结合近似值首位和实际误差限判断。该界只计右端扰动，不包括系数误差及额外计算误差（[2.4.2](supplement/sec24.md#sup-2.4.2)）。
2. 两行几乎成比例，$\mathrm{cond}_\infty(A)\approx4\times10^{11}$。近似解 $\hat x=(1.5,0.5)^{\mathrm T}$ 给出 $r=b-A\hat x=(0,\varepsilon/2)^{\mathrm T}$，故 $\|r\|_\infty=5\times10^{-12}$，而 $\|x-\hat x\|_\infty/\|x\|_\infty=0.5$。两个方程近乎同一约束，近似解可沿 $x_1+x_2\approx2$ 移动很远（[例 2.4.4](supplement/sec24.md#sup-2.4.4)）。
3. 精确正交变换满足 $\lVert Q\boldsymbol e\rVert_2=\lVert\boldsymbol e\rVert_2$，不会放大已有误差；但每次浮点实现仍会新增舍入，连续变换的误差也可能累积。非正交的坐标变换可能通过 $\mathrm{cond}_2(S)$ 放大相对误差（[2.1.3 思考](supplement/sec21.md#sup-2.1.3)）。
4. $10^6$ 时，正规方程的风险量约 $10^{-4}$，QR 的典型一阶量约 $10^{-10}$，通常优先 QR；$10^{10}$ 时，前者约 $10^4$，不宜依赖正规方程，可用 QR / SVD。以上不是实际误差保证，最小二乘敏感性还取决于残差与数据；换算法不能消除问题病态（[2.3.6](supplement/sec23.md#sup-2.3.6)）。
5. $A=U\Sigma V^{\mathrm T}$，$U,V$ 正交、$\Sigma$ 非负对角且降序；$\lVert A\rVert_2=\sigma_1$，非奇异 $n$ 阶方阵 $\mathrm{cond}_2(A)=\sigma_1/\sigma_n$，奇异方阵为 $\infty$；精确秩为正奇异值的个数，数值秩还需阈值（[2.6.3](supplement/sec26.md#sup-2.6.3)）。
6. 不保证。$\rho\lt1$ 只保证**渐近**衰减，非正规矩阵在有限步内可能先涨（瞬态增长）；稳妥判据是 $\lVert A\rVert\lt1$，它给出「每一步都在收缩」的保证（[例 2.5.6](supplement/sec25.md#sup-2.5.6)）。
:::

:::

::: method 得分与去向

- **6 题全对**：直接进 [2.1 内积、正交性与正交矩阵](supplement/sec21.md)。
- **错 1–2 题**：按错题回到[第一节](#sec-先修-1)〜[第四节](#sec-先修-4)的对应块，补完自测题再进正文。
- **错 3 题以上**：先通读[第一章 1.2](ch01/sec12.md) 与 [1.3](ch01/sec13.md)（误差、有效数字、范数），对照[公式与结论卡](review/formula-cards.md)第一至七节默一遍，再回来做一次本自测。
:::

### 六、卡住时回读哪里 {#sec-先修-6}

| 你的症状 | 先看这一页 | 再回正文 |
|:--|:--|:--|
| 内积公理、正交、正交矩阵的等价条件读不顺 | [本页第一节](#sec-先修-1) | [2.1](supplement/sec21.md)、[入学诊断 C1](entry-test.md) |
| 投影公式、四个子空间写不出来 | [本页第一节](#sec-先修-1) | [2.2](supplement/sec22.md)、[入学诊断 C2、C3](entry-test.md) |
| Gram–Schmidt / Householder 手算卡住 | [本页第一节](#sec-先修-1) 自测第 2 题 | [2.3](supplement/sec23.md)、[习题 C2](supplement/exercises.md) |
| 「能信几位」估不清、残差与误差分不开 | — | [2.4](supplement/sec24.md)、[工具箱第一节](toolbox.md#sec-工具箱-1)、[易混对照卡 4](review/contrast-cards.md) |
| 特征值、谱半径、Gerschgorin 一团乱 | [本页第一、四节](#sec-先修-4) | [2.5](supplement/sec25.md)、[例题 2.5.2](supplement/sec25.md#ex-sup-2.5.2) |
| SVD 的几何意义想不明白 | — | [2.6.2 两种几何读法](supplement/sec26.md#sup-2.6.2)、[入学诊断 C4](entry-test.md) |
| 浮点、有效数字、误差界的推导跟不上 | [本页第二节](#sec-先修-2) | [1.2](ch01/sec12.md)、[附录 B](appendix/float.md) |
| 代码跑不出书里的数字、不知道该用哪个函数 | [本页第三节](#sec-先修-3) | [工程工具箱](toolbox.md)、[2.7 实验](supplement/sec27.md) |
| 与课堂对不上（记号不同、定理编号不同） | — | [课堂精编导览的记号说明](lectures/overview.md#notation-diff) |

---

**依据**第一章 + 补充篇正文的先修约定（[范围与使用方法](preface.md)、[符号表](preface-notation.md)）整理 · 原实验环境记录为 NumPy 2.4.6，平台不同末位可能不同；数值记录不替代题解中的数学条件 · 与[入学诊断自测](entry-test.md)的分工：诊断页做题定路线，本页查漏补缺 · 初次整理日期 2026-10-20。
