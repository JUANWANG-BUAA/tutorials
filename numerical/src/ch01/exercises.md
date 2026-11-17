# 习题集

全章习题按难度分四组：A 组概念判断（快速自检）、B 组推导证明（考试大题）、C 组计算与编程（动手实操）、D 组开放建模（迁移综合）。四组**均附解答或提示**（默认折叠）；C 组每题给验收标准。凡标注「原书习题 n」的题目与颜书第 13 页习题逐条对应，可对照作答。

## A 组 · 概念判断 {#sec-练习-a}

::: ex A1 · 误差来源分类

指出下列各情境中的主导误差属于哪一类（模型 / 观测 / 截断 / 舍入）：
(a) 用单摆公式 $T=2\pi\sqrt{L/g}$ 计算周期时，把地球简化为均匀引力场；
(b) 摆长 $L$ 用米尺量得 $0.98\pm0.0005$ m；
(c) 用 $1-\frac{x^2}{2}$ 代替 $\cos x$（$x=0.1$）；
(d) 用 float64 计算 $0.1+0.2$ 得 $0.30000000000000004$。

::: sol 解答

(a) 模型误差（建模假设偏离实际）。(b) 观测误差（测量仪器精度）。(c) 截断误差（Taylor 展开扔掉 $\frac{x^4}{24}$，数值约 $4\times10^{-6}$）。(d) 舍入误差（$0.1$ 与 $0.2$ 都无法精确存入二进制浮点）。

:::

:::

::: ex A2 · 「减法比加法危险」辨析

加减法都可用 $\varepsilon(a)+\varepsilon(b)$ 作为绝对误差限。为什么相近数相减可能造成较大的相对误差？加法会不会出现类似情况？

::: sol 解答

相对误差还要除以结果的大小：当 $a,b$ 相近时，$|a-b|$ 可能很小，输入误差在差值中所占的比例就可能很大。加法也可能发生相消：例如 $a=1.414$、$b=-1.413$，若两者的误差限都是 $0.0005$，则 $a+b=0.001$，误差限为 $0.001$，以近似结果为分母的相对误差限达到 $100\%$。风险在于结果相对于输入很小，而不是减号本身。

:::

:::

::: ex A3 · 有效数字概念四连（含原书习题 2、3）

逐条判断下列说法或命题：
(a) $2.1400$ 与 $2.14$ 作为同一准确值的近似值，哪个更精确？
(b) 准确值本身有多少位有效数字？
(c) 【原书习题 2】绝对误差限都是 $0.0005$ 的三个近似值 $a=-1.00031$、$b=0.042$、$c=-0.00032$ 各有几位有效数字？
(d) 【原书习题 3】$a$ 是积分 $\displaystyle\int_0^1 e^{-x^2}dx$ 的近似值且有四位有效数字，求 $a$ 的绝对误差限。

::: sol 解答

(a) 两个写法表示同一个数，作为同一真值的近似时，实际误差相同。末尾零可以用来声明测量精度，但仅凭写法不能确定误差限；若另行说明两者分别是四舍五入到所写末位的结果，才可分别取 $0.00005$ 与 $0.005$ 作为误差限。
(b) 准确值自身的有效数字可视为无限多位（误差恒为零）。
(c) $a=-0.100031\times10^{1}$：$\tfrac12\times10^{1-n}=0.0005$ 给出 $n=4$；$b=0.42\times10^{-1}$：$\tfrac12\times10^{-1-n}=0.0005$ 给出 $n=2$。对 $c=-0.32\times10^{-3}$，给定误差限大于首位的半个单位，因而不能保证第一位有效；这不等于断言它的实际误差也一定这么大。
(d) $\displaystyle\int_0^1 e^{-x^2}dx=0.74682413\cdots$，因此满足题设的近似值与积分同量级，可取 $m=0$。四位有效数字要求误差限不超过 $\tfrac12\times10^{0-4}=0.00005$；例如四舍五入可取 $a=0.7468$，但题设本身不要求 $a$ 必须等于这个数。

:::

:::

::: ex A4 · 范数概念四连

判断下列各命题对错，并说明理由：
(a) 存在矩阵 $A,B$ 使 $\lVert AB\rVert_2=\lVert A\rVert_2\lVert B\rVert_2$；
(b) $\lVert A\rVert_F$ 从属于某个向量范数；
(c) 对对称正定矩阵 $A$，$\lVert A\rVert_2=\lambda_{\max}(A)$；
(d) 把向量范数 $\lVert\cdot\rVert_2$ 换成 $\lVert\cdot\rVert_1$，迭代序列「是否收敛到 $\boldsymbol{x}^{*}$」的结论可能改变。

::: sol 解答

(a) **对**。取 $B=A^{\mathrm T}$：$\lVert A A^{\mathrm T}\rVert_2=\lambda_{\max}(AA^{\mathrm T})=\sigma_{\max}(A)^2=\lVert A\rVert_2^2$；或平凡地取 $B=I$。
(b) **一般不对**。当 $n\ge2$ 时，$\lVert I\rVert_F=\sqrt n\neq1$，而任何算子范数必有 $\lVert I\rVert=1$（见 1.3.3 推论）。$n=1$ 时，F-范数退化为绝对值，确实是从属范数。
(c) **对**。$A$ 对称正定时 $A^{\mathrm T}A=A^2$，特征值为 $\lambda_i^2$，$\sqrt{\lambda_{\max}(A^2)}=\lambda_{\max}(A)$。
(d) **错**。这正是范数等价定理（[@thm-1.3.3]）：$m\lVert\boldsymbol{u}_k\rVert_\beta\le\lVert\boldsymbol{u}_k\rVert_\alpha\le M\lVert\boldsymbol{u}_k\rVert_\beta$，一侧趋于零则另一侧必趋于零。会变的是误差界的**大小**与停机**步数**，不是收敛与否。

:::

:::

## B 组 · 推导证明 {#sec-练习-b}

::: ex B1 · 【原书习题 10】加权范数 $\lVert\boldsymbol{x}\rVert_A=\lVert A\boldsymbol{x}\rVert$

设 $A\in\mathbb{R}^{n\times n}$，对任意 $\boldsymbol{x}\in\mathbb{R}^n$ 记 $\lVert\boldsymbol{x}\rVert_A=\lVert A\boldsymbol{x}\rVert$，其中 $\lVert\cdot\rVert$ 为某种向量范数。试证：若 $A$ 非奇异，则 $\lVert\cdot\rVert_A$ 是向量范数；若 $A$ 奇异，则 $\lVert\cdot\rVert_A$ 不是向量范数。

::: sol 解答

设 $A$ 非奇异。(1) 正定：$\lVert\boldsymbol{x}\rVert_A\ge0$；$\lVert\boldsymbol{x}\rVert_A=0\iff A\boldsymbol{x}=\boldsymbol{0}\iff\boldsymbol{x}=\boldsymbol{0}$（$A$ 非奇异，齐次方程组只有零解）。(2) 齐次：$\lVert k\boldsymbol{x}\rVert_A=\lVert A(k\boldsymbol{x})\rVert=\lvert k\rvert\lVert A\boldsymbol{x}\rVert$。(3) 三角不等式：$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_A=\lVert A\boldsymbol{x}+A\boldsymbol{y}\rVert\le\lVert A\boldsymbol{x}\rVert+\lVert A\boldsymbol{y}\rVert=\lVert\boldsymbol{x}\rVert_A+\lVert\boldsymbol{y}\rVert_A$。

设 $A$ 奇异，则存在 $\boldsymbol{v}\neq\boldsymbol{0}$ 使 $A\boldsymbol{v}=\boldsymbol{0}$，于是 $\lVert\boldsymbol{v}\rVert_A=\lVert\boldsymbol{0}\rVert=0$，正定性被破坏，不是范数。∎

（应用：加权残差 $\lVert\boldsymbol{r}\rVert_{D^{-1/2}}$、椭圆范数 $\lVert\boldsymbol{x}\rVert_{A^{1/2}}$ 都是本题特例，[第 2 章](../course/ch02/overview.md)迭代法用它们度量误差。）

:::

:::

::: ex B2 · 【原书习题 14(1)】三个显式等价不等式

证明：$\lVert\boldsymbol{x}\rVert_2\le\lVert\boldsymbol{x}\rVert_1\le\sqrt n\,\lVert\boldsymbol{x}\rVert_2$，并补出 1.3.2 节表格中另外两行的证明。

::: sol 解答

**左半**：$\lVert\boldsymbol{x}\rVert_2^2=\sum_i x_i^2\le\sum_i x_i^2+\sum_{i\neq j}\lvert x_ix_j\rvert=\Bigl(\sum_i\lvert x_i\rvert\Bigr)^2=\lVert\boldsymbol{x}\rVert_1^2$（交叉项 $\ge0$）。
**右半**：$\lVert\boldsymbol{x}\rVert_1=\sum_i\lvert x_i\rvert\cdot1\le\Bigl(\sum_i x_i^2\Bigr)^{1/2}\Bigl(\sum_i1^2\Bigr)^{1/2}=\sqrt n\,\lVert\boldsymbol{x}\rVert_2$（Cauchy–Schwarz，取 $\boldsymbol{y}=(1,\cdots,1)^{\mathrm T}$）。

另两行：$\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_1$（最大不超过总和）；$\lVert\boldsymbol{x}\rVert_1\le n\lVert\boldsymbol{x}\rVert_\infty$（每项不超过最大值，共 $n$ 项）；$\lVert\boldsymbol{x}\rVert_\infty\le\lVert\boldsymbol{x}\rVert_2\le\sqrt n\,\lVert\boldsymbol{x}\rVert_\infty$（$\max^2\le\sum x_i^2$ 与 $\sum x_i^2\le n\max^2$）。∎

:::

:::

::: ex B3 · 【原书习题 13】$\lVert I\rVert\ge1$ 与 $\lVert A^{-1}\rVert\lVert A\rVert\ge1$

证明：对任何非奇异矩阵 $A$ 与任何矩阵范数，$\lVert I\rVert\ge1$ 且 $\lVert A^{-1}\rVert\,\lVert A\rVert\ge1$。

::: sol 解答

由 $\lVert I\rVert=\lVert I\cdot I\rVert\le\lVert I\rVert^2$ 得 $\lVert I\rVert(\lVert I\rVert-1)\ge0$；又 $\lVert I\rVert=\lVert I\cdot I\rVert\ge0$ 且 $I\neq O$ 给出 $\lVert I\rVert\gt0$，故 $\lVert I\rVert\ge1$。再由次可乘性：

$$1=\text{(数 1)}\le\lVert I\rVert=\lVert A\,A^{-1}\rVert\le\lVert A\rVert\,\lVert A^{-1}\rVert,$$

（利用 $A$ 非奇异）即 $\lVert A^{-1}\rVert\lVert A\rVert\ge1$。∎

（对照：当 $\lVert A\rVert\lt1$ 时，定理 1.3.6 的界 $\lVert(I-A)^{-1}\rVert\le(1-\lVert A\rVert)^{-1}$ 可以任意接近 1；而本题表明 $\lVert A\rVert\lVert A^{-1}\rVert$ 永远不小于 1——这正是条件数（[1.3.6](sec13.md#sec-1.3.6)）的下界。）

:::

:::

::: ex B4 · 【原书习题 15】任何矩阵范数都有相容的向量范数

对任意一种矩阵范数 $N(\cdot)$，总存在一种与它相容的向量范数。试证明之。

::: sol 解答

取定任一非零向量 $\boldsymbol{b}$（例如 $\boldsymbol{b}=\boldsymbol{e}_1$），定义

$$\lVert\boldsymbol{x}\rVert_*:=N\bigl(\boldsymbol{x}\,\boldsymbol{b}^{\mathrm T}\bigr),\qquad\boldsymbol{x}\in\mathbb{R}^n .$$

（$\boldsymbol{x}\boldsymbol{b}^{\mathrm T}$ 的第 $j$ 列是 $b_j\boldsymbol{x}$，故它的秩至多为 1；因 $\boldsymbol b\ne\boldsymbol0$，$\boldsymbol{x}=\boldsymbol{0}\iff$ 该矩阵为零矩阵。）验证三条向量范数公理：

(1) $\lVert\boldsymbol{x}\rVert_*\ge0$；$\lVert\boldsymbol{x}\rVert_*=0\iff\boldsymbol{x}\boldsymbol{b}^{\mathrm T}=O\iff\boldsymbol{x}=\boldsymbol{0}$（因 $\boldsymbol{b}\neq\boldsymbol{0}$）。
(2) $N(k\boldsymbol{x}\boldsymbol{b}^{\mathrm T})=N\bigl(k(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})\bigr)=\lvert k\rvert N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})$。
(3) $N\bigl((\boldsymbol{x}+\boldsymbol{y})\boldsymbol{b}^{\mathrm T}\bigr)=N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T}+\boldsymbol{y}\boldsymbol{b}^{\mathrm T})\le N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})+N(\boldsymbol{y}\boldsymbol{b}^{\mathrm T})$。

相容性：对任意 $A,\boldsymbol{x}$，用矩阵范数的次可乘性，

$$\lVert A\boldsymbol{x}\rVert_*=N\bigl(A\boldsymbol{x}\boldsymbol{b}^{\mathrm T}\bigr)=N\bigl(A\,(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})\bigr)\le N(A)\,N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})=N(A)\,\lVert\boldsymbol{x}\rVert_* .$$

∎

:::

:::

::: ex B5 · 新增 · 相对误差的精确公式

本题用近似值作分母，记 $r_a=(x-a)/a$、$r_b=(y-b)/b$，其中 $a,b,x,y\ne0$。推导乘积与商的相对变化

$$r_{ab}=\frac{xy-ab}{ab},\qquad r_{a/b}=\frac{x/y-a/b}{a/b},$$

并据此说明「乘除法相对误差限相加」在什么条件下近似成立。

::: sol 解答

由 $x=a(1+r_a)$、$y=b(1+r_b)$，展开乘积并约去 $ab$：

$$r_{ab}=\frac{xy-ab}{ab}=r_a+r_b+r_ar_b.$$

对商，$\dfrac{x/y}{a/b}=\dfrac{1+r_a}{1+r_b}$，所以

$$r_{a/b}=\frac{r_a-r_b}{1+r_b}.$$

当 $|r_a|,|r_b|\ll1$ 时，乘积项与分母修正是高阶小量；取绝对值并用三角不等式，得到乘除法相对误差限相加的一阶估计。这里的分母与正文定义的真值分母不同；两种精确表达式的对照见 [1.2.3](sec12.md#sec-1.2.3) 的思考框。∎

:::

:::

::: ex B6 · 【原书习题 14(2)】$\lVert A\boldsymbol{x}\rVert_2\le\sqrt n\,\lVert A\rVert_1\,\lVert\boldsymbol{x}\rVert_2$（附原书习题 12 的数值检验）

证明 $\lVert A\boldsymbol{x}\rVert_2\le\sqrt n\,\lVert A\rVert_1\,\lVert\boldsymbol{x}\rVert_2$；再对原书习题 12 的矩阵 $A=\begin{pmatrix}2&-5&4\\-1&0&3\\4&2&-2\end{pmatrix}$、$\boldsymbol{x}=(4,-8,2)^{\mathrm T}$ 用五种范数数值检验本节全部不等式。

::: sol 解答

**证明。**分三步。

第一步：$\lVert A\rVert_F\le\sqrt n\,\lVert A\rVert_1$。把 $A$ 按列分块，第 $j$ 列记 $\boldsymbol{c}_j$，则 $\lVert A\rVert_F^2=\sum_j\lVert\boldsymbol{c}_j\rVert_2^2\le\sum_j\lVert\boldsymbol{c}_j\rVert_1^2\le n\max_j\lVert\boldsymbol{c}_j\rVert_1^2=n\,\lVert A\rVert_1^2$（每列的 2-范数不超过其 1-范数——B2 的向量不等式用于列向量；再 $n$ 项相加不超过最大值的 $n$ 倍）。

第二步：$\lVert\cdot\rVert_F$ 与 $\lVert\cdot\rVert_2$ 相容（正文 1.3.4 的结论 (b)）：$\lVert A\boldsymbol{x}\rVert_2\le\lVert A\rVert_F\lVert\boldsymbol{x}\rVert_2$。

串联：$\lVert A\boldsymbol{x}\rVert_2\le\lVert A\rVert_F\,\lVert\boldsymbol{x}\rVert_2\le\sqrt n\,\lVert A\rVert_1\,\lVert\boldsymbol{x}\rVert_2$。∎

**数值检验（原书习题 12）。**$\boldsymbol{x}=(4,-8,2)^{\mathrm T}$：$\lVert\boldsymbol{x}\rVert_1=14$，$\lVert\boldsymbol{x}\rVert_2=2\sqrt{21}\approx9.165$，$\lVert\boldsymbol{x}\rVert_\infty=8$。矩阵 $A$：列和 $(7,7,9)\Rightarrow\lVert A\rVert_1=9$；行和 $(11,4,8)\Rightarrow\lVert A\rVert_\infty=11$；$\lVert A\rVert_F=\sqrt{79}\approx8.888$；$A^{\mathrm T}A=\begin{pmatrix}21&-2&-3\\-2&29&-24\\-3&-24&29\end{pmatrix}$ 的最大特征值 $\approx53.016\Rightarrow\lVert A\rVert_2\approx7.281$。逐条核对：

$$\lVert A\boldsymbol{x}\rVert_2=56.18\ \le\ \sqrt3\times9\times9.165=142.87\ \checkmark,$$

$$\lVert A\rVert_2=7.281\le\sqrt{\lVert A\rVert_1\lVert A\rVert_\infty}=\sqrt{99}\approx9.950,\qquad \lVert A\rVert_2=7.281\le\lVert A\rVert_F=8.888\ \checkmark .$$

（第二个界的一行来历：$\lVert A\rVert_2^2=\lambda_{\max}(A^{\mathrm T}A)\le\lVert A^{\mathrm T}A\rVert_\infty\le\lVert A^{\mathrm T}\rVert_\infty\lVert A\rVert_\infty=\lVert A\rVert_1\lVert A\rVert_\infty$，其中 $\lVert A^{\mathrm T}\rVert_\infty=\lVert A\rVert_1$，且 $\lambda_{\max}\le$ 谱半径（spectral radius）$\le$ 任一算子范数——后者见[补充篇 2.5](../supplement/sec25.md)，此处可当引理用。）这两个界与 $\lVert A\rVert_F$ 互不控制，本题中 $9.950\gt8.888$。所有实测值与理论一致。

:::

:::

## C 组 · 计算与编程 {#sec-练习-c}

::: ex C1 · 【原书习题 1、2】误差限与有效数字互推

(1)【原书习题 1】下列各近似值均有四位有效数字：$a=0.01347$，$b=-12.341$，$c=-1.200$。求它们的绝对误差限和相对误差限。
(2) 编程验证：把 $0.01347$ 视为某个未知真值 $x\in[0.013465,0.013475]$ 的近似，用 Python 检查区间两端点下 $a$ 是否都保持 4 位有效数字。

::: sol 解答

(1) 四位有效数字给出各数的允许误差限：

$$\varepsilon(a)=\tfrac12\times10^{-5}=0.000005,\quad \varepsilon_{\mathrm r}(a)=\frac{0.000005}{0.01347}\approx0.037\%;$$

$$\varepsilon(b)=\tfrac12\times10^{-2}=0.005,\quad \varepsilon_{\mathrm r}(b)=\frac{0.005}{12.341}\approx0.041\%;$$

$$\varepsilon(c)=\tfrac12\times10^{-3}=0.0005,\quad \varepsilon_{\mathrm r}(c)=\frac{0.0005}{1.200}\approx0.042\%.$$

对 $b$，所写的第五位不改变题目只保证四位有效数字这一条件。对 $c$，尾零可以表达精度，但误差保证仍来自题目给定的条件。
(2) 验收标准：程序对区间内任意真值输出 $\lvert x-a\rvert\le5\times10^{-6}$，并按规格化形式自动判定有效位数为 4；参考判据：$a=0.01347=0.1347\times10^{-1}$ 即 $m=-1$，直接检验 $\lvert x-a\rvert\le\tfrac12\times10^{m-4}=\tfrac12\times10^{-5}=5\times10^{-6}$。

:::

:::

::: ex C2 · 【原书习题 4】函数求值的误差估计

已知 $x=2.14\pm0.005$，$y=-1.231\pm0.0005$。
(1) 用 $\tilde u_1=\sqrt{2.14}$ 作为 $u_1=\sqrt x$ 的近似值；
(2) 用 $\tilde u_2=2.14\times(-1.231)+\dfrac{2.14}{1.231}$ 作为 $u_2=xy-\dfrac xy$ 的近似值。
分别求 $\tilde u$ 的绝对误差限和相对误差限，并指出 $\tilde u$ 能有几位有效数字。

::: sol 解答

(1) 记 $f(x)=\sqrt x$，$f'(x)=\dfrac{1}{2\sqrt x}$。由[@thm-1.2.2]：

$$\varepsilon(\tilde u_1)\approx\frac{\varepsilon(x)}{2\sqrt{2.14}}=\frac{0.005}{2\times1.46287}\approx0.00171,\qquad
\varepsilon_{\mathrm r}=\frac{0.00171}{1.46287}\approx0.12\% .$$

$\tilde u_1=1.46287\cdots=0.146\cdots\times10^1$（$m=1$）。严格地说，由 $2.135\le x\le2.145$ 和平方根的单调性，$\sqrt{2.135}\le\sqrt x\le\sqrt{2.145}$；两端与 $\sqrt{2.14}$ 的距离都小于 $0.00171$。因此这个误差界小于三位要求的 $0.005$，但不保证四位要求的 $0.0005$。若把近似值改写成 $1.46$，区间端点与 $1.46$ 的距离仍小于 $0.005$，所以该写法也保证三位有效数字。

(2) $u_2=xy-\dfrac xy$，$\tilde u_2=2.14\times(-1.231)+\dfrac{2.14}{1.231}=-2.63434+1.73842=-0.89592$。由 (1.1)，

$$\frac{\partial u_2}{\partial x}=y-\frac1y=-1.231+\frac{1}{1.231}=-0.41865,\qquad
\frac{\partial u_2}{\partial y}=x+\frac{x}{y^2}=2.14+\frac{2.14}{1.231^2}=3.55220 .$$

（注意此处的 $y$ 为负；两个偏导数已按链式法则合并：$\dfrac{\partial}{\partial y}\bigl(xy-\dfrac xy\bigr)=x+\dfrac{x}{y^2}$。）误差限按绝对值求和：

$$\varepsilon(\tilde u_2)\approx\lvert-0.41865\rvert\times0.005+\lvert3.55220\rvert\times0.0005\approx0.00209+0.00178=0.00387,$$

$$\varepsilon_{\mathrm r}(\tilde u_2)=\frac{0.00387}{0.89592}\approx0.43\% .$$

$\tilde u_2=-0.89592\cdots\times10^0$（$m=0$）。上面的 $0.00387$ 是一阶估计。为保证有效数字，注意题设区间内 $f(x,y)=xy-x/y$ 对 $x$ 递减、对 $y$ 递增；代入两个相应端点可得 $-0.89980<f(x,y)<-0.89205$。因此与 $\tilde u_2$ 的误差小于 $0.00390$，满足两位要求的 $0.005$，但不能保证第三位。若把结果改写为 $-0.90$，区间上端离它约 $0.00795$，超过两位所要求的 $0.005$，不能把原近似值的误差保证直接搬过去。验收时应分别复算近似偏导数、一阶估计与端点界。

:::

:::

::: ex C3 · 【原书习题 5】相近数相减选算法

设 $x=3.214$ 和 $y=3.213$ 都是准确值。在四位十进制限制下，欲计算 $u=\sqrt x-\sqrt y$ 与 $u=\tan x-\tan y$。试选择精确度较高的算法，计算出 $u$ 的近似值。

::: sol 解答

**$u_1=\sqrt x-\sqrt y$。**直接算：$\sqrt{3.214}\approx1.793$，$\sqrt{3.213}\approx1.792$（四位），相减得 $0.001$，而真值 $u_1=0.00027892\cdots$——**结果是真值的 3.6 倍（误差达到真值的 2.6 倍），一位有效数字都没有**。改写（有理化）：

$$u_1=\frac{x-y}{\sqrt x+\sqrt y}=\frac{0.001}{\sqrt{3.214}+\sqrt{3.213}} .$$

四位算术：分母 $1.793+1.792=3.585$，$u_1=0.001/3.585=0.0002789$，与真值 $0.000278921$ 相对误差 $\approx10^{-4}$——4 位有效数字。

**$u_2=\tan x-\tan y$。**直接算：$\tan 3.214=0.07253$，$\tan 3.213=0.07153$，相减 $0.0010$（真值 $0.00100519$，2 位）。改写（和差化积）：

$$u_2=\frac{\sin(x-y)}{\cos x\cos y}=\frac{\sin 0.001}{\cos 3.214\cdot\cos 3.213}=\frac{0.001000}{0.9974\times0.9975}=\frac{0.001000}{0.9949}=0.001005,$$

与真值 $0.00100519$ 相对误差 $\approx2\times10^{-4}$——4 位。验收标准：用 `decimal`（prec=4）模拟四位机复现两个结果；打印直接法与改写法的实测相对误差表。

:::

:::

::: ex C4 · 【原书习题 6】六个公式算 $(\sqrt2-1)^6$

取 $\sqrt2\approx1.4$，欲计算 $(\sqrt2-1)^6$ 的近似值，又已知

$$(\sqrt2-1)^6=(3-2\sqrt2)^3=99-70\sqrt2=\frac{1}{(\sqrt2+1)^6}=\frac{1}{(3+2\sqrt2)^3}=\frac{1}{99+70\sqrt2}.$$

试分析这六个公式中使用哪一个进行计算使得误差最小。

::: sol 解答

真值 $(\sqrt2-1)^6=0.00505063388\cdots$，输入误差 $\delta=1.4-\sqrt2=-0.01421356$。六个公式都可视为 $\sqrt2$ 的函数 $g$；按其导数在近似值处取值（[@thm-1.2.2]），放大因子 $G=\lvert g'(1.4)\rvert$。各式的 $G$ 与实测误差如下：

| 公式 | $\lvert g'\rvert$ | 一阶估计 $G|\delta|$ | 实测结果 | 实测误差 |
|:--|:--:|:--:|:--:|:--:|
| $(\sqrt2-1)^6$ | $0.0614$ | $8.7\times10^{-4}$ | $0.004096$ | $9.5\times10^{-4}$ |
| $(3-2\sqrt2)^3$ | $0.240$ | $3.4\times10^{-3}$ | $0.008$ | $2.9\times10^{-3}$ |
| $99-70\sqrt2$ | $70$ | $1.0$ | $1.000$ | $9.9\times10^{-1}$ |
| $1/(\sqrt2+1)^6$ | $0.0131$ | $1.9\times10^{-4}$ | $0.0052328$ | $1.8\times10^{-4}$ |
| $1/(3+2\sqrt2)^3$ | $0.0053$ | $7.5\times10^{-5}$ | $0.0051253$ | $7.5\times10^{-5}$ |
| $1/(99+70\sqrt2)$ | $0.0018$ | $2.6\times10^{-5}$ | $0.0050761$ | $2.6\times10^{-5}$ |

**结论：第 6 式 $1/(99+70\sqrt2)$ 的误差最小**（比第 3 式好近 5 个数量级）。道理在于：第 3 式是两个相近的大数 $99$ 与 $70\sqrt2\approx98$ 相减（放大因子 70）；第 6 式把同样两个数放进**分母**相加再取倒数——相近数由相减改为相加，除法又把误差进一步压低。验收标准：复现表中的实测列，并画出六个误差随 $\delta$ 变化的对数图（在足够小的非零扰动下，误差曲线的斜率应接近 1；扰动较大时还会受高阶项影响）。

:::

:::

::: ex C5 · 【原书习题 7】求和次序 + 秦九韶实测

(1) 在四位十进制的限制下，选择精确度最高的算法计算 $u=1340\times10^2+40+50+60+90$。
(2) 用 Python 实测：$n=5000$ 时逐项幂算法与秦九韶算法的耗时比，验证 $O(n^2)$ 与 $O(n)$。

::: sol 解答

(1) 真值 $134000+240=134240$。原序（累加器先取 $0.1340\times10^6$）：按对阶规则，$40,50$ 小于累加器末位的半单位 $50$，$60,90$ 也过不了对阶，故在截断模型下全部丢失，结果停在 $0.1340\times10^6$，误差 $-240$；四舍五入模型下 60、90 会部分存活，见[实验三](sec12.md#sec-1.2.7)。**精确度最高的算法：先把小数加在一起**——$40+50+60+90=240$（精确），再 $134000+240=134240$，最后舍入得 $0.1342\times10^6$，误差仅 $-40$。
(2) 一次教材运行记录为逐项幂 279 ms、秦九韶 0.39 ms。运行时间和倍数取决于实现与环境，不应要求每台机器达到固定比值。验收时先核对逐项算法是否每次从 1 重算幂，再比较多种 $n$ 下的运算次数及实测时间；复用上一轮的 $x^k$ 也是 $O(n)$，不属于这里被比较的逐项算法。

:::

:::

::: ex C6 · 【原书习题 8】积分递推的稳定方向

设 $y_n=\displaystyle\int_0^1\frac{x^n}{1+4x}\,dx$。在四位十进制的限制下，使用一个具有数值稳定性的算法，计算 $y_n\ (n=0,1,\cdots,8)$ 的近似值。

::: sol 解答

**建立递推：**$y_n+\dfrac14y_{n-1}=\displaystyle\int_0^1\frac{x^n+\frac14x^{n-1}}{1+4x}dx=\int_0^1\frac{x^{n-1}(x+\frac14)}{1+4x}dx=\frac14\int_0^1x^{n-1}dx=\frac{1}{4n}\ (n\ge1)$，且

$$y_0=\int_0^1\frac{dx}{1+4x}=\frac{\ln 5}{4}\approx0.4024 .$$

**判断方向：**两式中，正向 $y_n=\dfrac{1}{4n}-\dfrac14y_{n-1}$ 的系数是 $-\dfrac14$——误差每步**缩小** 4 倍，正向稳定（与[1.2.4](sec12.md#sec-1.2.4) 原则 (1) 的 $-5$ 恰好相反！）；反向 $y_{n-1}=\dfrac1n-4y_n$ 的系数是 $-4$，误差被放大，不可用。**所以直接正向递推即可**（关键是把方向判断做对）。

四位十进制下的计算结果（「真值」列为 scipy 求积结果，供对照）：

| $n$ | 四位递推值 | 真值 | 误差 |
|:--:|:--:|:--:|:--:|
| $0$ | 0.4024 | 0.4023595 | $+4.0\times10^{-5}$ |
| $1$ | 0.1494 | 0.1494101 | $-1.0\times10^{-5}$ |
| $2$ | 0.08765 | 0.0876475 | $+2.5\times10^{-6}$ |
| $3$ | 0.06142 | 0.0614215 | $-1.5\times10^{-6}$ |
| $4$ | 0.04714 | 0.0471446 | $-4.6\times10^{-6}$ |
| $5$ | 0.03821 | 0.0382138 | $-3.8\times10^{-6}$ |
| $6$ | 0.03212 | 0.0321132 | $+6.8\times10^{-6}$ |
| $7$ | 0.02768 | 0.0276860 | $-6.0\times10^{-6}$ |
| $8$ | 0.02433 | 0.0243285 | $+1.5\times10^{-6}$ |

初始误差的影响按每步 $\tfrac14$ 衰减，但每一步还会产生新的舍入误差，因此表中的**总误差**不必每步都缩小 $\tfrac14$，而是在该实验中保持在约 $10^{-5}$ 的量级。验收时分别比较精确算术下的初值误差传播和四位运算的总误差；再把递推倒过来，观察已有误差回退 8 步时会放大 $4^8\approx6.5\times10^4$ 倍。

:::

:::

## D 组 · 开放建模 {#sec-练习-d}

::: ex D1 · 量具与有效数字的逆向设计

你为车间设计长度检验规程。目标：对长度在 $[1\,\text{mm},\,1\,\text{m}]$ 内的工件，测量**相对**误差不超过 $0.5\%$。参照原书例 1（卡尺的绝对误差限为 $0.5$ mm，量程内相对误差随物长变化）回答：
(1) 一把最小刻度为 1 mm 的卡尺能覆盖多长的工件区间？
(2) 对 $[1\,\text{mm},\,10\,\text{mm}]$ 的小件，应选什么刻度的量具？
(3) 写一份 3 行的检验规程，说明「量具选择由被测物量级决定」。

::: sol 提示与参考

(1) 需 $\dfrac{0.5}{L}\le0.5\%\Rightarrow L\ge100$ mm：只覆盖 $[100,1000]$ mm。(2) 需刻度 $\tfrac12\,\text{gridscale}\le0.005L$：$L=1$ mm 时刻度须 $\le0.01$ mm：0.01 mm 刻度的千分尺（=螺旋测微器）勉强够用，0.001 mm 刻度的高精度测微器则稳妥。(3) 规程要点：量具刻度 $\le0.01\times$ 被测长度下限；同一批工件按量级分三档选具；读数记录到刻度的 $\tfrac12$ 单位（与有效数字声明一致）。**开放要点：**讨论「估读到 1/10 格」是否合理——人的读数分辨约 1/5~1/10 格，可就此做敏感性分析。

:::

:::

::: ex D2 · float32 还是 float64？写一份选型报告

对「求解 $10^5$ 阶三对角方程组（追赶法，约 $10^5\times$ 常数次乘加）」这一任务，从内存、速度、精度三个维度比较 float32 与 float64，写出带数据的选型结论。要求：实测（`np.dtype`、`time.perf_counter`）、引用本章概念（$u$、有效数字位数、误差放大）、给出「何时可以降精度」的判据。

::: sol 提示与参考

存储同样三条带时，float32 的元素空间是 float64 的一半：$3\times10^5$ 个数约为 1.2 MB 与 2.4 MB。运行速度取决于实现、访存、向量化和硬件，须以本机计时报告，不能预设固定倍数。带状求解可使用 `scipy.linalg.solve_banded`，它不在 NumPy 的 `linalg` 命名空间。

精度不能只按“追赶法有 $n$ 步”推断固定丢位数。应检查主元、系数增长、条件数、尺度及后向误差。若已得到后向误差上界 $\eta$ 且 $\kappa(A)\eta<1$，再用相应扰动界估计前向误差；$\eta$ 的计算和常数取决于实际算法。比较两种精度的残差、误差预算与必要时的高精度参考解后，才决定能否降精度。
:::

:::

::: ex D3 · 数值代码体检器

写一个函数 `audit(expr_pairs, eps)`，检查一组加、减、除的**单步运算记录**。每条记录给出名称、运算符及两个操作数；对一个多步表达式，先把需要检查的中间运算分别列出来。提示三类风险：(a) 减法结果远小于操作数（$|a-b|<\mathit{eps}\max(|a|,|b|)$）；(b) 除数远小于被除数（$|b|<\mathit{eps}|a|$，只提示尺度，不据此断定病态）；(c) 加法的两个非零操作数大小相差超过 $10^9$。用它检查求根公式、方差公式与 $(\sqrt2-1)^6$ 的有关中间步骤，并说明阈值漏报和误报的可能。

::: sol 提示与参考

参考实现把每次检查的对象写明；一个黑箱可调用函数不会自动暴露其内部运算：

```python
def audit(expr_pairs, eps=1e-6):
    for name, op, a, b in expr_pairs:
        risks = []
        if op == "-":
            u = a - b
            scale = max(abs(a), abs(b))
            if scale > 0 and abs(u) < eps * scale:
                risks.append("疑似相消")
        elif op == "/":
            if b == 0:
                print(f"{name}: 除数为零")
                continue
            u = a / b
            if abs(b) < eps * abs(a):
                risks.append("分子分母尺度悬殊，须检查误差及范围")
        elif op == "+":
            u = a + b
            small, large = sorted((abs(a), abs(b)))
            if small > 0 and large > 1e9 * small:
                risks.append("小数可能被吞")
        else:
            raise ValueError(f"不支持的运算: {op}")
        print(f"{name}: {u:+.3e}  {'; '.join(risks) or '未触发阈值'}")
```

验收时，可把 $10^8-\sqrt{10^{16}-4}$ 的减法及 $10^{18}-10^{18}$ 分别作为记录：前者相消明显，后者结果为零，也应提示。对公式 3 的 $99-70\times1.4=1$，比例为 $1/99\approx0.0101$，**不会**触发 $10^{-6}$ 阈值；这说明阈值只筛出极端情况，未触发不等于安全。公式 6 的分母相加也应作为独立一步检查。比较不同阈值，并结合输入误差讨论是否真的失去精度。

:::

:::

::: ex D4 · 真实数据的方差：三条路线的对比

找一组带真实偏移的数据（如某城市连续 30 天的气温、某股票连续收益率加常数、或你自己课程的分数），用三种方法计算同一个**样本方差**并对比：(a) $\dfrac{n}{n-1}(\dfrac1n\sum x_i^2-\bar x^2)$；(b) 平移后计算；(c) Welford 单遍算法。以 `statistics.variance` 或用 `math.fsum` 计算的中心化结果为参考，报告三种方法的误差，并解释结果差异。假设数据个数 $n\ge2$。

::: sol 提示与参考

Welford 递推：$\bar x_1=x_1$，$s_1=0$；$\bar x_k=\bar x_{k-1}+\dfrac{x_k-\bar x_{k-1}}{k}$，$s_k=s_{k-1}+\bigl(x_k-\bar x_{k-1}\bigr)\bigl(x_k-\bar x_k\bigr)$；样本方差为 $s_n/(n-1)$，与方法 (a) 使用同一个分母。数据的共同偏移远大于波动时，方法 (a) 可能因相近数相减而失准；平移法和 Welford 法避免直接相减两个大平方和，但精度仍应通过实验比较。可以改变共同偏移的大小，观察误差如何变化。

:::

:::

## 作业组 · 老师布置的 SPOC 自测题（第一章 误差）

::: note 这份作业的来路与交法 {#hw-1-meta}

作业名称「误差」，发布在北航 SPOC《数值分析 I》课程 → 作业测试，附件 `数值分析单元自测题1.pdf`（原件本地归档于 `_sources/homework/`，该目录入库规则为忽略）。
提交方式**文件上传**，满分 10 分，接收班级 2026-2027-1-GA01011002-学院路 1 班；起止时间 2026-09-22 00:00 至 2026-10-29 00:00（已截止，作答仍可作复习用）。
本页给出**四题的完整精讲**：思路 → 步骤 → 数值复算 → 易错点。数字均用四位／高精度脚本复算过，可逐位核对。

:::

::: ex 作业 1-1 · $\sqrt{x}$ 的相对误差是 $x$ 的一半 {#hw-1-1}

**（第一章自测题 1）** 证明：$\sqrt{x}$ 的相对误差约等于 $x$ 的相对误差的 $\dfrac12$。

:::

::: sol 精讲 {#sol-hw-1-1}

设 $x$ 的近似值为 $\tilde x$，记绝对误差 $e=\tilde x-x$、相对误差 $e_{\mathrm r}=\dfrac{e}{x}$。取 $f(x)=\sqrt x$，则 $f'(x)=\dfrac{1}{2\sqrt x}$。由一元函数误差传播（[1.2.3 定理 1.2.2](sec12.md#sec-1.2.3)）：

$$\varepsilon\bigl(\sqrt{\tilde x}\bigr)\approx\bigl\lvert f'(x)\bigr\rvert\,\varepsilon(\tilde x)=\frac{1}{2\sqrt x}\,\varepsilon(\tilde x).$$

两边同除 $\sqrt x$ 得相对误差

$$\frac{|\sqrt{\tilde x}-\sqrt x|}{\sqrt x}\approx\frac12\frac{|\tilde x-x|}{x},\qquad x>0,\quad |\tilde x-x|\ll x.\qquad\blacksquare$$

**一句话记住**：开平方把相对误差**减半**，平方把它**加倍**（$\sqrt{x}$ 是 $x$ 的 $1/2$ 次幂，幂次就是相对误差的放大因子）。这条结论直接解释了为什么 $\sqrt{\cdot}$ 是「安全函数」，而平方的相对条件数为 2，倒数的相对条件数为 1；它们的绝对误差放大因子还依赖输入。

**易错点**：写成 $\varepsilon(\sqrt{\tilde x})=\tfrac12\varepsilon(\tilde x)$ 是把**绝对**误差和**相对**误差混了——绝对误差的放大因子是 $\dfrac{1}{2\sqrt x}$，与 $x$ 的取值有关；只有相对误差的放大因子才是常数 $\tfrac12$。

:::

::: ex 作业 1-2 · 三个「相近数相减」的改写 {#hw-1-2}

**（第一章自测题 2）** 改变下列表达式，使计算结果比较精确：

(1) $\dfrac{1}{1+2x}-\dfrac{1-x}{1+x}$，对 $\lvert x\rvert\ll1$；
(2) $\sqrt{x+\dfrac1x}-\sqrt{x-\dfrac1x}$，对 $x\gg1$；
(3) $\dfrac{1-\cos x}{x}$，对 $x\neq0$、$\lvert x\rvert\ll1$。

（2026-11-12 逐项复核原 PDF：第 (3) 小题的分母为 $x$，旧稿误录为 $x^2$，现据原件订正。）

:::

::: sol 精讲 {#sol-hw-1-2}

三小题都涉及**相近数相减**：第 (1)、(3) 题中的两项接近 1，第 (2) 题中的两项接近 $\sqrt{x}$。直接相减会放大已有舍入误差相对于结果的比例，下面分别改写。

**(1) 通分，把差变成积。** 公分母 $(1+2x)(1+x)$：

$$\frac{1}{1+2x}-\frac{1-x}{1+x}
=\frac{(1+x)-(1-x)(1+2x)}{(1+2x)(1+x)}
=\frac{(1+x)-(1+2x-x-2x^2)}{(1+2x)(1+x)}
=\frac{2x^2}{(1+2x)(1+x)} .$$

分子 $2x^2$ 避免了相近数相减；乘除法仍会舍入，但在无溢出、下溢且输入可用时通常能保留相对精度。分母两项都接近 1，远离零。$x=10^{-3}$ 时原式直接算得 $0.998004-0.998002=2\times10^{-6}$，只剩 1 位有效数字；改写后 $2\times10^{-6}/1.003=1.994\times10^{-6}$，满精度。

**(2) 有理化，把差变成和。** 分子有理化：

$$\sqrt{x+\tfrac1x}-\sqrt{x-\tfrac1x}
=\frac{\bigl(x+\tfrac1x\bigr)-\bigl(x-\tfrac1x\bigr)}{\sqrt{x+\tfrac1x}+\sqrt{x-\tfrac1x}}
=\frac{2/x}{\sqrt{x+\tfrac1x}+\sqrt{x-\tfrac1x}} .$$

$x\gg1$ 时分子 $2/x$ 很小，但它是**除出来的**不是**减出来的**；分母是两个同号大数相加，绝对误差不放大。原式的问题正是两个接近的根号相减。

**(3) 用半角公式把 $\cos$ 换成 $\sin^2$。**

$$\frac{1-\cos x}{x}=\frac{2\sin^2\frac x2}{x}=\frac{x}{2}\left(\frac{\sin(x/2)}{x/2}\right)^2 .$$

$x\to0$ 时 $1-\cos x\approx\dfrac{x^2}{2}\to0$，直接算就是两个接近 1 的数相减；改写后 $\dfrac{\sin(x/2)}{x}\to\dfrac12$，**没有相近数相减**，改写后的整体极限为 0，而不是分母为 $x^2$ 时的 $1/2$。计算时可用归一化 sinc 的稳定实现，注意不同库的 sinc 是否含 $\pi$。

**三题的共同口诀**：能通分就通分、能有理化就有理化、能用倍角换成平方就换——把「相减」换成「相乘／相加／相除」。

:::

::: ex 作业 1-3 · 有效数字推相对误差，再传播到 $\sqrt{1-x}$ {#hw-1-3}

**（第一章自测题 3）** 设 $a=0.937$ 关于精确数 $x$ 有 3 位有效数字，估计 $a$ 的相对误差；对于 $f(x)=\sqrt{1-x}$，估计 $f(a)$ 对于 $f(x)$ 的误差和相对误差。

:::

::: sol 精讲 {#sol-hw-1-3}

**第一步：由有效数字得绝对误差限。** $a=0.937=0.937\times10^{0}$，即 $m=0$、$n=3$，末位是千分位，故

$$\varepsilon(a)=\tfrac12\times10^{0-3}=0.0005=5\times10^{-4},\qquad
\varepsilon_{\mathrm r}(a)=\frac{0.0005}{0.937}=5.336\times10^{-4}\approx0.053\%.$$

（也可用反向公式校核：$\varepsilon_{\mathrm r}\le\dfrac{1}{2a_1}\times10^{1-n}=\dfrac{1}{18}\times10^{-2}=5.56\times10^{-4}$，与实测值一致。）

**第二步：求 $f$ 的导数在 $a$ 处的值。** $f(x)=\sqrt{1-x}$，$f'(x)=-\dfrac{1}{2\sqrt{1-x}}$。在 $a=0.937$ 处，$1-a=0.063$，$\sqrt{0.063}=0.250999\cdots$，于是

$$f(a)=\sqrt{0.063}=0.250999\cdots,\qquad f'(a)=-\frac{1}{2\times0.250999}=-1.99204 .$$

**第三步：误差传播。**

$$\varepsilon(f(a))\approx\lvert f'(a)\rvert\,\varepsilon(a)=1.99204\times0.0005=9.96\times10^{-4}\approx1.0\times10^{-3},$$

$$\varepsilon_{\mathrm r}(f(a))=\frac{\varepsilon(f(a))}{f(a)}=\frac{9.96\times10^{-4}}{0.250999}=3.968\times10^{-3}\approx0.40\%.$$

**第四步：换个算法验算（这是老师最想看到的检查习惯）。** 相对误差满足 $f=\sqrt{u}$（$u=1-x$ 正数）时 $\varepsilon_{\mathrm r}(f)=\tfrac12\varepsilon_{\mathrm r}(u)$：

$$\varepsilon_{\mathrm r}(u)=\frac{\varepsilon(a)}{u}=\frac{0.0005}{0.063}=7.937\times10^{-3}\ \Longrightarrow\ \varepsilon_{\mathrm r}(f)=\tfrac12\times7.937\times10^{-3}=3.97\times10^{-3}.$$

与第三步完全一致 ✓。

**结论与解读**：$a$ 自身有 3 位有效数字、相对误差 $5\times10^{-4}$，但 $\sqrt{1-x}$ 在 $x=0.937$ 附近**导数绝对值接近 2**（$1-x$ 只剩 $0.063$，分母小），绝对误差约放大 2 倍，相对误差约放大 7.44 倍到 $4\times10^{-3}$——只剩 **2 位**有效数字。**有效数字不是「输入定、输出不变」的**，这正是[1.2.3](sec12.md#sec-1.2.3) 讲的函数条件数：$\left\lvert\dfrac{xf'(x)}{f(x)}\right\rvert=\dfrac{x}{2(1-x)}=\dfrac{0.937}{0.126}=7.44$。

:::

::: ex 作业 1-4 · $I_n=\frac1e\int_0^1x^ne^x\,dx$ 的递推与稳定性 {#hw-1-4}

**（第一章自测题 4）** 设 $I_n=\dfrac1e\displaystyle\int_0^1x^ne^x\,dx$，求证：
(1) $I_n=1-nI_{n-1}$（$n=0,1,2,\cdots$）；
(2) 利用 (1) 中的公式正向递推时误差逐步增大，反向递推时误差逐步减小。

:::

::: sol 精讲 {#sol-hw-1-4}

**(1) 分部积分。** 原 PDF 把递推下标写成 $n=0,1,2,\ldots$，应更正为 $n\ge1$；$n=0$ 要单独计算初值，不能把 $0\cdot I_{-1}$ 当作合法推导。

$$I_n=\frac1e\int_0^1x^ne^x\,dx
=\frac1e\left\{\Bigl[x^ne^x\Bigr]_0^1-n\int_0^1x^{n-1}e^x\,dx\right\}
=\frac1e\left\{e-0\right\}-n\cdot\frac1e\int_0^1x^{n-1}e^x\,dx
=1-nI_{n-1}.$$

初值 $I_0=\dfrac1e\displaystyle\int_0^1e^x\,dx=\dfrac{e-1}{e}=1-\dfrac1e=0.6321205588\cdots$。

**(2) 稳定性：先看已有误差被乘了什么数。** 题面“$n=0,1,\ldots$”的递推范围有误：$I_{n-1}$ 要求 $n\ge1$；$n=0$ 时只能用积分定义得 $I_0=1-1/e$。先暂不计后续运算中新产生的舍入误差。设 $I_{n-1}$ 的计算值带误差 $\delta_{n-1}$，即 $\hat I_{n-1}=I_{n-1}+\delta_{n-1}$，代入递推式：

$$\hat I_n=1-n\hat I_{n-1}=(1-nI_{n-1})-n\delta_{n-1}=I_n-n\delta_{n-1}
\ \Longrightarrow\ \delta_n=-n\,\delta_{n-1},\qquad\lvert\delta_n\rvert=n!\,\lvert\delta_0\rvert .$$

放大因子是 $n$（每步乘一次 $n$），$n$ 步后初值误差累计放大 $n!$。若每一步还产生舍入误差 $r_n$，则总误差满足 $\delta_n=-n\delta_{n-1}+r_n$；不能把只含初值误差的公式当成全部误差的精确表达式。

反向递推把公式解成 $I_{n-1}=\dfrac{1-I_n}{n}$，同样的推导给出 $\delta_{n-1}=-\dfrac{\delta_n}{n}$，即 $\lvert\delta_{n-1}\rvert=\dfrac{\lvert\delta_n\rvert}{n}$：**误差每步缩小 $n$ 倍，反向递推是稳定的**。起点取 $I_N\approx0$（因为 $0\le I_n\le\dfrac1e\displaystyle\int_0^1x^n e\,dx=\dfrac{1}{n+1}\to0$），$N$ 取得足够大（如 $N=20$）时起点误差的影响传到 $I_0$ 已被压成 $\dfrac{1}{N!}\approx\dfrac{1}{2.4\times10^{18}}$。

**四位十进制的实测（脚本复算，真值用高精度递推）**：

| $n$ | 正向递推（$I_0=0.6321$ 起） | 真值 | 反向递推（$I_{20}=0$ 起） |
|:--:|:--:|:--:|:--:|
| $0$ | $0.6321$ | $0.63212056$ | $0.6321$ |
| $1$ | $0.3679$ | $0.36787944$ | $0.3679$ |
| $2$ | $0.2642$ | $0.26424112$ | $0.2642$ |
| $3$ | $0.2074$ | $0.20727665$ | $0.2073$ |
| $5$ | $0.1480$ | $0.14553294$ | $0.1455$ |
| $7$ | $0.2160$ | $0.11238350$ | $0.1124$ |
| $8$ | $-0.7280$ | $0.10093197$ | $0.1009$ |
| $10$ | $-74.52$ | $0.08387707$ | $0.08388$ |
| $12$ | $-9.847\times10^{3}$ | $0.07177325$ | $0.07178$ |
| $15$ | $2.688\times10^{7}$ | $0.05901754$ | $0.05902$ |

正向从 $n=7$ 开始符号乱跳、量级爆炸（表中真值始终为正且随 $n$ 递减）；反向一路到 $I_0$ 都有 4 位有效数字。**这就是「递推方向决定算法的生死」**（对照[1.2.4](sec12.md#sec-1.2.4) 的判据：乘数绝对值 $>1$ 不可正向用）。

**易错点三条**：
1. 只证出 $I_n=1-nI_{n-1}$ 就停手——本题的分量在 (2)，必须写出 $\delta_n=-n\delta_{n-1}$ 这一步**误差方程**；
2. 把「正向／反向」与「$n$ 增大／减小」搞混：本题正向 = $n$ 从小到大（不稳定），反向 = $n$ 从大到小（稳定）；
3. 反向起点随便取 $I_{20}=0$ 却不说明理由——要补一句 $0\le I_n\le\dfrac{1}{n+1}$ 保证「起点误差足够小」。

:::

::: note 作业组的覆盖与关联 {#hw-1-cover}

四道题分别落在：相对误差的传播（[1.2.3](sec12.md#sec-1.2.3)，作业 1-1、1-3）、相近数相减的改写（[1.2.4](sec12.md#sec-1.2.4) 算法设计原则，作业 1-2）、递推的数值稳定性（[1.2.4](sec12.md#sec-1.2.4)，作业 1-4）。
与教材习题的关系：作业 1-2 是教材习题 5（$\sqrt x-\sqrt y$、$\tan x-\tan y$）的**同型升级版**；作业 1-4 与教材习题 8（$y_n=\int_0^1\frac{x^n}{1+4x}dx$，见 [C6](exercises.md#sec-练习-c)）方向相反——**教材那道题正向稳定、这道题正向发散**，两题并排做，才算真正掌握「先看乘数再定方向」。

:::

## 按正文进度练（作业与教材习题的插入点）

::: method[core] 读完哪一节，就做哪几题 {#hw-1-progress}

| 读完 | 立刻做（10–15 分钟） | 再做（30 分钟） | 为什么放在这里 |
|:--|:--|:--|:--|
| [1.2.1–1.2.2 误差来源与有效数字](sec12.md#sec-1.2.2) | [A2 减法为什么危险](exercises.md#sec-练习-a) · [A3 有效数字四连](exercises.md#sec-练习-a) | **作业 1-3**（有效数字推相对误差） | 作业 1-3 的第一步就是把「3 位有效数字」翻译成 $\varepsilon=0.0005$，学完立刻用 |
| [1.2.3 函数求值的误差估计](sec12.md#sec-1.2.3) | **作业 1-1**（$\sqrt x$ 的相对误差） | **作业 1-3** 第三、四步 · [C2 教材习题 4](exercises.md#sec-练习-c) | 作业 1-1 是定理 1.2.2 的最短应用；作业 1-3 是同一定理的「两遍算、互相验」 |
| [1.2.4 算法与计算复杂性](sec12.md#sec-1.2.4) | **作业 1-2**（三个改写） | **作业 1-4**（递推稳定性）· [C4 六个公式](exercises.md#sec-练习-c) | 改写题练「避相减」，递推题练「看乘数定方向」，两者是 1.2.4 的两条主原则 |
| [1.2.5–1.2.7 浮点、条件数、数值实验](sec12.md#sec-1.2.6) | [D2 float32/float64 选型](exercises.md#sec-练习-d) | [C5 求和次序](exercises.md#sec-练习-c) · [C6 积分递推](exercises.md#sec-练习-c) | C6 与作业 1-4 是同族题但**稳定方向相反**，必须并做 |
| [1.3 范数](sec13.md#sec-1.3.1) | [A4 范数概念四连](exercises.md#sec-练习-a) | [B1 加权范数](exercises.md#sec-练习-b) · [B3 $\lVert I\rVert\ge1$](exercises.md#sec-练习-b) | 范数是第 2 章条件数、迭代法收敛性的语言，先在此打底 |

**一条铁律**：作业 1-4 与教材习题 8（[C6](exercises.md#sec-练习-c)）**必须并排做**。两道题的递推式长得像、结论完全相反（一个正向发散、一个正向稳定），只会背结论的人在考场上必错，会看「乘数绝对值」的人才不会错。

:::

::: note 原书习题对照表

原书 15 道习题的归宿：习题 1、2 → [C1]；习题 3 → [A3(c)(d)]；习题 4 → [C2]；习题 5 → [C3]；习题 6 → [C4]；习题 7 → [C5]；习题 8 → [C6]；习题 9 → 正文[@thm-1.3.1] 已证；习题 10 → [B1]；习题 11 → 正文 1.3.4 已证；习题 12 → [B6] 的数值检验部分；习题 13 → [B3]；习题 14 → [B2][B6]；习题 15 → [B4]。新增的 A、D 组题只使用第一章概念。

:::
