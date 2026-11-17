# 闭卷回忆卡 · 第一章：误差、算法与范数

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾标记 **✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起，下一轮只重做 △ 与 ×。全页 40 张卡，一轮约 30 分钟。本页负责**检索**（从空白纸里把知识叫出来）；压缩在[公式与结论卡](../review/formula-cards.md)，辨析在[易混对照卡](../review/contrast-cards.md)，考场节奏在[综合自测卷](mock-exam.md)；补充篇的对应卡片见[补充篇回忆卡](../supplement/recall-cards.md)。

## A. 定义卡

**A1.** 四类误差各由谁造成？逐条写出定义（模型误差 / 观测误差 / 截断误差 / 舍入误差）。
::: sol
模型误差＝数学模型与实际问题的差别（写公式的人）；观测误差＝观测数据与实际数据之差（测数据的人）；截断误差（方法误差）＝用近似方法代替精确求解所得的近似解与模型精确解之差（选算法的人）；舍入误差（计算误差）＝字长有限导致数据与运算结果存放产生的误差（机器）。只有后两类能由算法设计控制（[@def-1.2.1]–[@def-1.2.4]、[1.2.1](sec12.md#sec-1.2.1)）。（✓ / △ / ×）
:::

**A2.** 写出绝对误差 $e$、绝对误差限 $\varepsilon$ 的定义，以及 $x,a,\varepsilon$ 三者的关系式。
::: sol
$e=x-a$；若 $\lvert e\rvert\le\varepsilon$ 则称 $\varepsilon$ 为误差限；关系写作 $a-\varepsilon\le x\le a+\varepsilon$，即 $x=a\pm\varepsilon$（[@def-1.2.5]）。（✓ / △ / ×）
:::

**A3.** 相对误差的真定义式与实用公式分别是什么？$x=0$ 时怎么办？
::: sol
真定义 $e_{\mathrm r}=\dfrac{x-a}{x}$；当误差很小时可用 $\dfrac{x-a}{a}$ 近似，二者相差 $O(e_{\mathrm r}^2)$。实用相对误差限为 $\varepsilon(a)/|a|$（$a\ne0$）；若 $|a|>\varepsilon(a)$，真值分母的严格相对误差界可取 $\varepsilon(a)/(|a|-\varepsilon(a))$。$x=0$ 时真相对误差无定义；区间包含零或近似值为零时，宜报告绝对误差（[@def-1.2.6]、[errata N1](errata.md)）。（✓ / △ / ×）
:::

**A4.** 「$a$ 有 $n$ 位有效数字」的判据是什么？尾零为什么不能省？
::: sol
把非零 $a$ 写成 $a=\pm0.a_1a_2\cdots a_k\times10^m$（$a_1\ne0$）：若 $\varepsilon(a)\le\tfrac12\times10^{m-n}$，则该误差限保证至少 $n$ 位有效数字。尾零可以表达精度，但显示位数不能代替误差限（[@def-1.2.7]）。（✓ / △ / ×）
:::

**A5.** 什么叫「算法」？衡量算法优劣的两个标准是什么？计算复杂性衡量哪两样东西？
::: sol
算法＝从输入数据算出数值问题解的**有限的基本运算序列**（四则、逻辑、基本函数）。两个标准：① 有可靠的理论基础（正确性、收敛性、数值稳定性、可做误差分析）；② 有良好的计算复杂性。复杂性＝达到给定精度所需的时间（计算量）与空间（内存）（[@def-1.2.8]）。（✓ / △ / ×）
:::

**A6.** 「数值稳定」的算法怎么定义？它与「问题良态 / 病态」是一回事吗？
::: sol
数值稳定描述算法是否在问题本身的敏感性之外额外严重放大扰动；病态描述的是问题对输入扰动的敏感性。改变算法可以改善计算过程，却不改变给定问题的条件数（[@def-1.2.9]、[1.2.6](sec12.md#sec-1.2.6)）。（✓ / △ / ×）
:::

**A7.** 写出浮点数集 $F(\beta,t,L,U)$ 中数的形式，以及机器精度 $\mathrm{eps}$ 与单位舍入误差 $u$。
::: sol
$x=\pm m\times\beta^e$，$m=(0.b_1b_2\cdots b_t)_\beta$，$b_1\ne0$，$L\le e\le U$；另包括零。最近舍入时 $\mathrm{eps}=\beta^{1-t}$、$u=\tfrac12\beta^{1-t}$；对非零数，在无溢出且不进入下溢区的条件下有 $|\operatorname{fl}(x)-x|/|x|\le u$。双精度（$\beta=2,t=53$）给出 $\mathrm{eps}=2^{-52}\approx2.22\times10^{-16}$、$u\approx1.11\times10^{-16}$（[@def-1.2.10]）。（✓ / △ / ×）
:::

**A8.** 向前误差与向后误差各问什么问题？什么叫向后稳定？
::: sol
向前误差是「结果离真值多远」（$f(x)-\tilde y$）；向后误差是「使**精确**模型恰好算出 $\tilde y$ 的最小输入扰动」——结果是谁家的精确答案。向后误差与机器舍入同量级时称算法**向后稳定**，此时向前误差≈条件数 × 向后误差（[@def-1.2.11]、[1.2.6](sec12.md#sec-1.2.6)）。（✓ / △ / ×）
:::

**A9.** 向量范数的三条公理、矩阵范数的四条公理各是什么？「相容」又指什么？
::: sol
向量：正定、齐次、三角不等式。矩阵：前三条 ＋ **次可乘性** $\lVert AB\rVert\le\lVert A\rVert\lVert B\rVert$。相容指 $\lVert A\boldsymbol x\rVert\le\lVert A\rVert\lVert\boldsymbol x\rVert$ 对一切 $A$ 与 $\boldsymbol x$ 成立——矩阵范数与向量范数要**配对**使用（[@def-1.3.1]、[@def-1.3.2]、[@def-1.3.3]）。（✓ / △ / ×）
:::

**A10.** 什么叫从属范数（算子范数）？为什么 Frobenius 范数不是算子范数？
::: sol
从属范数＝最大拉伸倍数 $\lVert A\rVert=\max_{\lVert\boldsymbol x\rVert=1}\lVert A\boldsymbol x\rVert$。任何算子范数都满足 $\lVert I\rVert=1$，而 $n\ge2$ 时 $\lVert I\rVert_F=\sqrt n\neq1$，故 $\lVert\cdot\rVert_F$ **不从属于任何向量范数**——它与 $\lVert\cdot\rVert_2$ 相容，但相容不等于从属（[@thm-1.3.4]、[@def-1.3.4]）。（✓ / △ / ×）
:::

::: think A 组的适用条件（背定义时要一起带走的东西）{#rc-a-conditions}
- 误差限 $\varepsilon$ 是**上界**不是误差本身；$x=a\pm\varepsilon$ 里只有 $a$ 是已知的。
- 相对误差两种写法只在 $\lvert e_{\mathrm r}\rvert\ll1$ 时等价；$\lvert e_{\mathrm r}\rvert$ 到 $0.1$ 量级时近似值已接近失效。
- 有效数字由误差保证判定，显示长度另行说明：$c=0.86\times10^5$ 若明确给出误差限 $0.005$，可写成 $86000.00\pm0.005$，不能因尾零未写就否定可靠精度（[@ex-1.2.3]）。
- 将 $a$ 重舍入为 $b$ 后，可取 $\varepsilon(b)=\varepsilon(a)+|a-b|$；必须以 $b$ 的量级和新误差界重新判定位数，不能把 $a$ 的位数直接移给 $b$。
- $\mathrm{eps}$ 与 $u$ 差一个 $2$：$\mathrm{eps}$ 是相邻浮点数的相对间距，$u$ 是一次舍入的相对误差上界，写公式时不要互换。
- 从属范数只对**配对**的向量范数有意义：$\lVert A\rVert_p$ 里的 $p$ 说的是**向量**的 $p$-范数。
:::

## B. 结论卡

**B1.** 四类误差里哪两类是数值分析的研究对象？另外两类混进计算后还服从本章规律吗？
::: sol
研究对象是**截断误差与舍入误差**（唯一能靠算法设计控制的两类）；模型误差与观测误差分别归建模、测量学科，但**一旦进入计算，仍按 1.2.3 的传播规律起作用**，所以本章工具对它们一视同仁（[1.2.1](sec12.md#sec-1.2.1) 鸟瞰表）。（✓ / △ / ×）
:::

**B2.** 为什么由四舍五入得到的近似值，误差限恰是末位的半个单位？
::: sol
四舍五入到小数点后 $d$ 位时，被舍掉的部分 $\delta\in[-\tfrac12\times10^{-d},\ \tfrac12\times10^{-d}]$，故 $\lvert x-a\rvert\le\tfrac12\times10^{-d}$；而 $a$ 的末位正落在 $10^{-d}$ 位上——于是「从末位一路数到第一位非零数字」全是有效数字（[@ex-1.2.2] 后的推导）。（✓ / △ / ×）
:::

**B3.** 有效数字与相对误差限怎么互相换算？「每多一位有效数字」意味着什么？
::: sol
$n$ 位有效数字 ⟹ $\varepsilon_{\mathrm r}(a)\le\dfrac{1}{2a_1}\times10^{1-n}\le\tfrac12\times10^{1-n}$；反之若 $\varepsilon_{\mathrm r}(a)\le\dfrac{1}{2(a_1+1)}\times10^{1-n}$，则至少有 $n$ 位。在数值量级固定时，保证位数增加一位，要求的绝对误差界缩小为十分之一；实际误差不一定恰好缩小十倍（[@thm-1.2.1]）。（✓ / △ / ×）
:::

**B4.** 函数求值的误差为什么乘一阶导数？一元、多元各写成什么？
::: sol
由 Taylor 一阶展开：$e(\tilde u)\approx f'(a)\,e(a)$、$\varepsilon(\tilde u)\approx\lvert f'(a)\rvert\,\varepsilon(a)$；多元情形的一阶项逐项求和（式 1.1）。这些是近似式：需要二阶余项相对一阶项足够小；若一阶导数为零，需考察高阶项或另作估计（[@thm-1.2.2]）。（✓ / △ / ×）
:::

**B5.** 四则运算的误差限公式有哪四条？最危险的一步是什么、危险来自哪里？
::: sol
加减法可取 $\varepsilon(a)+\varepsilon(b)$ 为绝对误差限；乘除法的相对误差限相加是一阶估计。加减所得结果相对于输入很小时可能出现严重相消；除法应检查分母的不确定区间是否接近或包含零，不能只看分母的绝对值（[1.2.3](sec12.md#sec-1.2.3)）。（✓ / △ / ×）
:::

**B6.** 递推 $y_n=\alpha_n+\beta y_{n-1}$ 的误差如何随步数变化？怎样据此选方向？
::: sol
只考虑初值误差时，$\delta_n=\beta^n\delta_0$：$|\beta|<1$ 时它衰减，$|\beta|>1$ 时它放大。若每步引入舍入误差，还要将新误差逐项计入；改用反向递推之前，也要能估计远端初值（[1.2.4](sec12.md#sec-1.2.4)）。（✓ / △ / ×）
:::

**B7.** Sterbenz 引理说什么？由此看，「避免相近数相减」到底在避免什么？
::: sol
在采用渐进下溢的二进制浮点系统中，若 $x,y$ 是正的有限浮点数且 $y/2\le x\le2y$，则 $\operatorname{fl}(x-y)=x-y$。但操作数可能已带有输入或中间计算误差；相减得到小结果后，这些已有误差所占的相对比例可能很大（[@lem-1.2.1]）。（✓ / △ / ×）
:::

**B8.** 浮点算术基本公理是什么？它给出「$n$ 次运算」的什么定量结论？
::: sol
一次正确舍入的基本运算可写为 $\operatorname{fl}(x\,\mathrm{op}\,y)=(x\,\mathrm{op}\,y)(1+\delta)$，$|\delta|\le u$，但需满足除数非零、无溢出或下溢等条件。多步误差还取决于后续运算怎样传播局部误差，不能对任意算法直接断言相对误差不超过 $nu$（[1.2.5](sec12.md#sec-1.2.5)）。（✓ / △ / ×）
:::

**B9.** 病态问题与不稳定算法交叉起来有四种情形，各该怎么办？
::: sol
良态＋稳定 → 输入足够准确时通常能得到准确结果；病态＋稳定 → 向前误差仍可能较大，应检查数据精度，必要时提高工作精度或重述问题；良态＋不稳定 → 换算法；两者都有问题 → 同时处理敏感性与算法。病态描述问题，不稳定描述算法（[1.2.6](sec12.md#sec-1.2.6)）。（✓ / △ / ×）
:::

**B10.** 三种常用向量范数之间有哪些显式不等式？为什么说「换范数不改变收敛结论」？
::: sol
$\lVert\boldsymbol x\rVert_\infty\le\lVert\boldsymbol x\rVert_2\le\lVert\boldsymbol x\rVert_1\le n\lVert\boldsymbol x\rVert_\infty$，细写成 $\lVert\boldsymbol x\rVert_\infty\le\lVert\boldsymbol x\rVert_2\le\sqrt n\lVert\boldsymbol x\rVert_\infty$、$\lVert\boldsymbol x\rVert_2\le\lVert\boldsymbol x\rVert_1\le\sqrt n\lVert\boldsymbol x\rVert_2$；常数 $n,\sqrt n$ 不可再改进（取等例：全 1 向量或单分量向量）。等价定理保证「是否趋于零」与范数无关，会变的是**误差界大小与停机步数**（[@thm-1.3.3]）。（✓ / △ / ×）
:::

**B11.** $\lVert A\rVert\lt1$ 能换来哪三件东西？
::: sol
① $I\pm A$ 非奇异；② $\lVert(I\pm A)^{-1}\rVert\le(1-\lVert A\rVert)^{-1}$（该式要求算子范数，因为用了 $\lVert I\rVert=1$）；③ Neumann 级数 $\sum_{k\ge0}A^k=(I-A)^{-1}$ 收敛，且部分和有余项估计（[@thm-1.3.6]、[@thm-1.3.7]）。（✓ / △ / ×）
:::

::: think B 组的适用条件与常见越界{#rc-b-conditions}
- 「相减危险」说的是**相对**误差限；绝对误差限对加减一视同仁，不要写成「减法比加法误差大」。
- 传播公式是**一阶近似**：判断能否忽略余项时，要同时考虑导数大小和输入误差的大小。
- 递推方向判别法只对**常系数**线性递推成立（$\beta$ 为常数）；变系数时按每步乘积逐段估计。
- 等价定理里的 $m,M$ **依赖 $n$ 与范数对**，不是万能常数；报误差必须注明范数。
- $\lVert A\rVert\lt1$ 只是**充分**条件：$I-A$ 可逆时 $\lVert A\rVert$ 完全可以大于 $1$（如 $A=10I$）。
:::

## C. 公式卡

**C1.** 误差三件套与有效数字判据。
::: sol
$e=x-a$；$\lvert e\rvert\le\varepsilon$；$x=a\pm\varepsilon$；实用相对误差限 $\varepsilon_{\mathrm r}=\varepsilon(a)/\lvert a\rvert$。若 $a=\pm0.a_1\cdots a_k\times10^m$ 且 $\varepsilon(a)\le\tfrac12\times10^{m-n}$，则该界保证至少 $n$ 位有效数字（[@def-1.2.5]–[@def-1.2.7]）。（✓ / △ / ×）
:::

**C2.** 由误差限**反求**有效数字位数的操作式（含「没有有效数字」的情形）。
::: sol
对非零近似值和正误差限，取满足 $\varepsilon(a)\le\tfrac12\times10^{m-n}$ 的最大整数 $n$；可用 $\lfloor m-\log_{10}(2\varepsilon)\rfloor$，并直接核对边界。若 $n<1$，该界不能保证第一位；若 $n$ 超过显示长度，应明确补写尾零或误差限，不是“没有有效数字”（[1.2.2](sec12.md#sec-1.2.2)）。（✓ / △ / ×）
:::

**C3.** 有效数字 ⟹ 相对误差限（两个档次）。
::: sol
$\varepsilon_{\mathrm r}(a)\le\dfrac{1}{2a_1}\times10^{1-n}\le\dfrac12\times10^{1-n}$（[@thm-1.2.1]）。（✓ / △ / ×）
:::

**C4.** 式 (1.1)：多元函数求值的误差估计。
::: sol
$\varepsilon(\tilde u)\approx\sum_{i=1}^{n}\left\lvert\dfrac{\partial f(a_1,\dots,a_n)}{\partial x_i}\right\rvert\varepsilon(a_i)$；带符号版 $e(\tilde u)\approx\sum_i\dfrac{\partial f}{\partial x_i}e(a_i)$（[1.2.3](sec12.md#sec-1.2.3)）。（✓ / △ / ×）
:::

**C5.** 四则运算误差限表（绝对 + 相对）。
::: sol
$\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$；$\varepsilon(ab)\approx\lvert a\rvert\varepsilon(b)+\lvert b\rvert\varepsilon(a)$；$\varepsilon(a/b)\approx\dfrac{\lvert a\rvert\varepsilon(b)+\lvert b\rvert\varepsilon(a)}{\lvert b\rvert^2}$；乘除的相对误差限相加；$\varepsilon_{\mathrm r}(a\pm b)=\dfrac{\varepsilon(a)+\varepsilon(b)}{\lvert a\pm b\rvert}$。（✓ / △ / ×）
:::

**C6.** 递推误差与放大因子。
::: sol
$\delta_n=\beta^n\delta_0$；同一个递推正反两方向的稳定性可以完全相反（$\beta=5$：前推放大 $5^n$、反推缩小 $5^{-n}$）（[1.2.4](sec12.md#sec-1.2.4)）。（✓ / △ / ×）
:::

**C7.** 浮点的两组数字：$\mathrm{eps}$ / $u$ / 间距。
::: sol
$\mathrm{eps}=\beta^{1-t}$、$u=\tfrac12\beta^{1-t}$；double：$t=53$，$\mathrm{eps}\approx2.22\times10^{-16}$、$u\approx1.11\times10^{-16}$；float32：$t=24$，$\mathrm{eps}\approx1.19\times10^{-7}$。区间 $[2^k,2^{k+1})$ 内相邻正规浮点数间距为 $2^{k+1-t}$（[@def-1.2.10]、[1.2.5](sec12.md#sec-1.2.5)）。（✓ / △ / ×）
:::

**C8.** 浮点公理与 $n$ 步运算的误差量级。
::: sol
$\operatorname{fl}(x\,\mathrm{op}\,y)=(x\,\mathrm{op}\,y)(1+\delta)$，$|\delta|\le u$；这是单步模型。$n$ 步的误差还要根据算法分析，不能对任意计算直接套用 $nu$（[1.2.5](sec12.md#sec-1.2.5)）。（✓ / △ / ×）
:::

**C9.** 函数条件数与「丢几位」的估计式。
::: sol
对可微函数及 $x\ne0$、$f(x)\ne0$，相对条件数为 $\mathrm{cond}(f,x)=|xf'(x)/f(x)|$。输入扰动足够小时，输出相对误差的一阶估计为条件数乘输入相对误差；输入相对误差约为单位舍入误差 $u$、且条件数大于 1 时，损失的十进制位数可粗估为 $\log_{10}\mathrm{cond}$，并非严格位数结论（[@def-1.2.11]、[1.3.6](sec13.md#sec-1.3.6)）。（✓ / △ / ×）
:::

**C10.** 五个矩阵范数公式与两条收口关系。
::: sol
$\lVert A\rVert_1=\max_j\sum_i\lvert a_{ij}\rvert$；$\lVert A\rVert_\infty=\max_i\sum_j\lvert a_{ij}\rvert$；$\lVert A\rVert_2=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$；$\lVert A\rVert_F=(\sum_{i,j}a_{ij}^2)^{1/2}$。相容性 $\lVert A\boldsymbol x\rVert_p\le\lVert A\rVert_p\lVert\boldsymbol x\rVert_p$；等价性 $\lVert\boldsymbol x\rVert_\infty\le\lVert\boldsymbol x\rVert_2\le\lVert\boldsymbol x\rVert_1\le n\lVert\boldsymbol x\rVert_\infty$。（✓ / △ / ×）
:::

**C11.** Neumann 界与级数（含余项）。
::: sol
$\lVert A\rVert<1$ 时，$I\pm A$ 非奇异且 $\sum_{k=0}^{\infty}A^k=(I-A)^{-1}$。若使用从属范数，还可取逆范数界 $(1-\lVert A\rVert)^{-1}$，并有余项估计 $\left\lVert (I-A)^{-1}-\sum_{k=0}^{N}A^k\right\rVert\le\lVert A\rVert^{N+1}/(1-\lVert A\rVert)$（[@thm-1.3.6]、[@thm-1.3.7]）。（✓ / △ / ×）
:::

::: method C 组的适用条件{#rc-c-conditions}
- 误差限公式都是**最坏情形**：给的是界，不是期望值。
- $\lvert f'(a)\rvert$ 是放大因子、不是误差；$\lvert f'\rvert\le1$ 时函数反而**吸收**误差。
- 除法公式要求分母不为零；判断输入误差能否被控制，应看分母的不确定性相对于分母有多大。
- $\lVert A\rVert_2=\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$ 的流程是**先转置相乘、再取最大特征值、最后开方**；$\lVert A\rVert_2=\lambda_{\max}(A)$ 只对对称半正定矩阵成立。
- $k\approx\log_{10}\mathrm{cond}$ 是**量级估计**，实测误差常比它小几倍；设计系统时按界取，评估结果时按实测报。
:::

## D. 陷阱卡（每题先指出错在哪，再给正确说法）

**D1.** 「$a=3.1416$ 是 $\pi$ 的 4 位有效数字近似——它保留了 4 位小数。」
::: sol
有效数字位数与小数位数不同：$a=0.31416\times10^1$，实际误差约 $7.3\times10^{-6}$，满足五位但不满足六位的误差要求，故有 **5 位有效数字**。题中“保留了 4 位小数”是对的（[@ex-1.2.4]）。（✓ / △ / ×）
:::

**D2.** 「相对误差限应当用 $\varepsilon(a)/\lvert x\rvert$ 计算，因为相对误差的定义分母是准确值 $x$。」
::: sol
若以真值 $x$ 为分母，$\varepsilon(a)/|x|$ 确实界住定义中的相对误差，但 $x$ 通常未知。正文定义可计算的实用误差限 $\varepsilon(a)/|a|$；需要严格界住真值分母的相对误差时，还要用分母修正（[@def-1.2.6]）。（✓ / △ / ×）
:::

**D3.** 「$\varepsilon(ab)\approx\lvert a\rvert\varepsilon(b)+\lvert b\rvert\varepsilon(a)$ 是恒等式，可以拿来做严格证明。」
::: sol
错。它是 Taylor 一阶近似；精确的带符号绝对误差为 $e(ab)=b\,e(a)+a\,e(b)+e(a)e(b)$。相对误差的精确形式还取决于使用真值还是近似值作分母；两种写法见 [1.2.3](sec12.md#sec-1.2.3) 思考框。（✓ / △ / ×）
:::

**D4.** 「相近数相减之所以丢有效数字，是因为浮点减法本身的舍入误差很大。」
::: sol
错。Sterbenz 引理保证满足其条件的两个浮点操作数相减不再引入舍入误差，但这不消除操作数已有的误差。$1.870-1.865=0.005$ 在四位十进制算术中也可精确完成；若两输入各只保证四位有效数字，其已有误差仍可能占差值的很大比例（[@lem-1.2.1]、[1.2.4](sec12.md#sec-1.2.4)）。（✓ / △ / ×）
:::

**D5.** 「递推一律正向计算；稳定性只与步长和精度有关，与递推方向无关。」
::: sol
错。稳定性由**递推系数与方向**绑定：$\delta_n=\beta^n\delta_0$，$\lvert\beta\rvert\gt1$ 的方向必然爆炸（$5^{100}\approx7.9\times10^{69}$），提高精度只推迟灾难、不消除它。应**反向递推**并用估计式（如 $\frac{1}{6(n+1)}\lt y_n\lt\frac{1}{5(n+1)}$）定住远端初值（[1.2.4](sec12.md#sec-1.2.4) 原则 (1)）。（✓ / △ / ×）
:::

**D6.** 「原始矩公式 $\frac1n\sum x_i^2-\bar x^2$ 与先求均值、再求离差平方和的两遍中心化算法只是写法不同，精度一样。」
::: sol
错。数据共同偏移大时 $\sum x_i^2$ 与 $n\bar x^2$ 是相近数相减，实测可输出 $0.0$（真值 $5.25$）：$\sum x_i^2\approx8\times10^{18}$ 的绝对舍入误差已达个位数量级。应先平移或改用 Welford 单遍法（[1.2.7](sec12.md#sec-1.2.7) 实验二、[1.2.8](sec12.md#sec-1.2.8) 错误 6）。（✓ / △ / ×）
:::

**D7.** 「打印出 17 位数字说明这 17 位都可信；判断两个浮点数相等直接写 `==` 即可。」
::: sol
错。可靠位数由误差限决定，与打印位数无关；例如常用二进制双精度下 $0.1+0.2$ 显示为 $0.30000000000000004$。近似判等可用 $|x-y|\le\max(\tau_{\rm abs},\tau_{\rm rel}\max(|x|,|y|))$，容差按问题精度选择；接近零时不能只用相对容差。确需判断浮点表示是否完全一致时，`==` 仍有用途（[1.2.5](sec12.md#sec-1.2.5)、[1.2.8](sec12.md#sec-1.2.8)）。（✓ / △ / ×）
:::

**D8.** 「$\lVert AB\rVert=\lVert A\rVert\lVert B\rVert$；F-范数是从属范数；$\lVert A\rVert_2$ 就是 $\lambda_{\max}(A)$。」
::: sol
三处都错。① 公理只给**次可乘** $\lVert AB\rVert\le\lVert A\rVert\lVert B\rVert$，一般严格小于；② $\lVert I\rVert_F=\sqrt n\neq1$，故 F-范数不从属（相容但非算子范数）；③ 正确式是 $\sqrt{\lambda_{\max}(A^{\mathrm T}A)}$，只有对称半正定矩阵才有 $\lVert A\rVert_2=\lambda_{\max}(A)$——反例 $A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$：$\lambda_{\max}(A)=0$ 而 $\lVert A\rVert_2=1$（[1.3.7](sec13.md#sec-1.3.7) 错误 1–3）。（✓ / △ / ×）
:::

::: think D 组的典型误用清单（考前扫一眼）{#rc-d-misuse}
① 把有效数字当小数位数；② 混淆真值分母的相对误差与近似值分母的实用误差限；③ 把一阶传播公式当恒等式；④ 忽略相消对已有误差的放大；⑤ 递推不看系数与方向；⑥ 混淆原始矩方差公式与两遍中心化算法；⑦ 近似判等不设合适容差、相信打印位数；⑧ 以为升级精度就能消除方法误差；⑨ 把次可乘当等式、把 F-范数当算子范数、把 $\lVert A\rVert_2$ 写成 $\lambda_{\max}(A)$；⑩ 以为有限维空间中换范数会改变收敛结论。
:::

## 导出到 Anki / CSV

1. **建卡组**：打开 Anki → 新建卡组「数值分析-第 1 章」（与「数值分析-全书」并列，不要混进默认卡组）。
2. **逐条录入**：正面放「编号 + 题干」，背面放「答案 + 依据」（带上 [@编号] 与节号，便于回正文核对）；纯文本批量导入用 `Tab` 分隔「正面 / 背面」，一行一张卡——本页 40 张按 **A1–A10 / B1–B11 / C1–C11 / D1–D8** 的顺序录。
3. **复习节点（1 / 3 / 7 天）**：当天 → 隔天（第 1 天）→ 第 3 天 → 第 7 天共四轮；每轮只重做标 **△** 与 **×** 的卡；出现「能背出但说不出适用条件」的情况一律按 △ 处理。
4. **加一道保险**：C 组（公式卡）背面附一张**手写照片**；四轮后仍为 × 的卡，抄进[勘误与补注](errata.md)第四节的待核实条目单独跟踪。分工记住一句话：[公式与结论卡](../review/formula-cards.md)负责**压缩**、[易混对照卡](../review/contrast-cards.md)负责**辨析**、[综合自测卷](mock-exam.md)负责**考场节奏**，本页负责**检索**。
