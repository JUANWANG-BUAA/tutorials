# 习题集

全章习题按难度分四组：A 组概念判断（快速自检）、B 组推导证明（考试大题）、C 组计算与编程（动手实操）、D 组开放建模（迁移综合）。四组**均附解答或提示**（默认折叠）；C 组每题给验收标准。凡标注「原书习题 n」的题目与颜书第 13 页习题逐条对应，可对照作答。

## A 组 · 概念判断

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

由 $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$ 可见，加与减的**绝对**误差限算法完全相同。为什么实践中只说「减法危险」？危险在什么条件下出现？

::: sol 解答

危险的是**相对**误差限：$\varepsilon_{\mathrm r}(a-b)=\dfrac{\varepsilon(a)+\varepsilon(b)}{\lvert a-b\rvert}$。当 $a,b$ 相近（$\lvert a-b\rvert$ 远小于 $\lvert a\rvert,\lvert b\rvert$）时分母极小，相对误差爆炸、有效数字大量丢失（极端例子见[@ex-1.2.7]：两个 4 位有效数字的数相减后连 1 位都不剩）。加法的分母 $\lvert a+b\rvert$ 通常不小于较大的操作数，故无此问题。**危险条件：两数近似相等。**绝对误差限公式对加减一视同仁，危险来自相对化。

:::

:::

::: ex A3 · 有效数字概念四连（含原书习题 2、3）

逐条判断下列说法或命题：
(a) $2.1400$ 与 $2.14$ 作为同一准确值的近似值，哪个更精确？
(b) 准确值本身有多少位有效数字？
(c) 【原书习题 2】绝对误差限都是 $0.0005$ 的三个近似值 $a=-1.00031$、$b=0.042$、$c=-0.00032$ 各有几位有效数字？
(d) 【原书习题 3】$a$ 是积分 $\displaystyle\int_0^1 e^{-x^2}dx$ 的近似值且有四位有效数字，求 $a$ 的绝对误差限。

::: sol 解答

(a) $2.1400$：5 位有效数字，$\varepsilon=\tfrac12\times10^{-4}$；$2.14$：3 位，$\varepsilon=\tfrac12\times10^{-2}$。前者更精确。**写出的尾零是有效数字声明，不能随意省略。**
(b) 准确值自身的有效数字可视为无限多位（误差恒为零）。
(c) $a=-0.100031\times10^{1}$：$\tfrac12\times10^{1-n}=0.0005=\tfrac12\times10^{-3}\Rightarrow n=4\ (\le6$ 位写出$)$，4 位；$b=0.42\times10^{-1}$：$\tfrac12\times10^{-1-n}=\tfrac12\times10^{-3}\Rightarrow n=2$，2 位（$4,2$）；$c=-0.32\times10^{-3}$：需 $\tfrac12\times10^{-3-n}=\tfrac12\times10^{-3}\Rightarrow n=0$，**没有**有效数字（误差限 $0.0005$ 已是首位有效数字 $10^{-4}$ 位半单位的 10 倍，连第一位都保不住，写法与误差限不匹配）。
(d) $\displaystyle\int_0^1 e^{-x^2}dx=0.74682413\cdots$，4 位有效数字意味着 $a=0.7468=0.7468\times10^0$，$\varepsilon(a)=\tfrac12\times10^{0-4}=0.00005$。

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
(b) **错**。$\lVert I\rVert_F=\sqrt n\neq1$，而任何算子范数必有 $\lVert I\rVert=1$（见 1.3.3 推论）。
(c) **对**。$A$ 对称正定时 $A^{\mathrm T}A=A^2$，特征值为 $\lambda_i^2$，$\sqrt{\lambda_{\max}(A^2)}=\lambda_{\max}(A)$。
(d) **错**。这正是范数等价定理（[@thm-1.3.3]）：$m\lVert\boldsymbol{u}_k\rVert_\beta\le\lVert\boldsymbol{u}_k\rVert_\alpha\le M\lVert\boldsymbol{u}_k\rVert_\beta$，一侧趋于零则另一侧必趋于零。会变的是误差界的**大小**与停机**步数**，不是收敛与否。

:::

:::

## B 组 · 推导证明

::: ex B1 · 【原书习题 10】加权范数 $\lVert\boldsymbol{x}\rVert_A=\lVert A\boldsymbol{x}\rVert$

设 $A\in\mathbb{R}^{n\times n}$，对任意 $\boldsymbol{x}\in\mathbb{R}^n$ 记 $\lVert\boldsymbol{x}\rVert_A=\lVert A\boldsymbol{x}\rVert$，其中 $\lVert\cdot\rVert$ 为某种向量范数。试证：若 $A$ 非奇异，则 $\lVert\cdot\rVert_A$ 是向量范数；若 $A$ 奇异，则 $\lVert\cdot\rVert_A$ 不是向量范数。

::: sol 解答

设 $A$ 非奇异。(1) 正定：$\lVert\boldsymbol{x}\rVert_A\ge0$；$\lVert\boldsymbol{x}\rVert_A=0\iff A\boldsymbol{x}=\boldsymbol{0}\iff\boldsymbol{x}=\boldsymbol{0}$（$A$ 非奇异，齐次方程组只有零解）。(2) 齐次：$\lVert k\boldsymbol{x}\rVert_A=\lVert A(k\boldsymbol{x})\rVert=\lvert k\rvert\lVert A\boldsymbol{x}\rVert$。(3) 三角不等式：$\lVert\boldsymbol{x}+\boldsymbol{y}\rVert_A=\lVert A\boldsymbol{x}+A\boldsymbol{y}\rVert\le\lVert A\boldsymbol{x}\rVert+\lVert A\boldsymbol{y}\rVert=\lVert\boldsymbol{x}\rVert_A+\lVert\boldsymbol{y}\rVert_A$。

设 $A$ 奇异，则存在 $\boldsymbol{v}\neq\boldsymbol{0}$ 使 $A\boldsymbol{v}=\boldsymbol{0}$，于是 $\lVert\boldsymbol{v}\rVert_A=\lVert\boldsymbol{0}\rVert=0$，正定性被破坏，不是范数。∎

（应用：加权残差 $\lVert\boldsymbol{r}\rVert_{D^{-1/2}}$、椭圆范数 $\lVert\boldsymbol{x}\rVert_{A^{1/2}}$ 都是本题特例，[第五章](sec11.md#roadmap)迭代法用它们度量误差。）

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

（$\boldsymbol{x}\boldsymbol{b}^{\mathrm T}$ 是把 $\boldsymbol{x}$ 复制到列方向的秩 1 矩阵，$\boldsymbol{x}=\boldsymbol{0}\iff$ 该矩阵为零矩阵。）验证三条向量范数公理：

(1) $\lVert\boldsymbol{x}\rVert_*\ge0$；$\lVert\boldsymbol{x}\rVert_*=0\iff\boldsymbol{x}\boldsymbol{b}^{\mathrm T}=O\iff\boldsymbol{x}=\boldsymbol{0}$（因 $\boldsymbol{b}\neq\boldsymbol{0}$）。
(2) $N(k\boldsymbol{x}\boldsymbol{b}^{\mathrm T})=N\bigl(k(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})\bigr)=\lvert k\rvert N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})$。
(3) $N\bigl((\boldsymbol{x}+\boldsymbol{y})\boldsymbol{b}^{\mathrm T}\bigr)=N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T}+\boldsymbol{y}\boldsymbol{b}^{\mathrm T})\le N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})+N(\boldsymbol{y}\boldsymbol{b}^{\mathrm T})$。

相容性：对任意 $A,\boldsymbol{x}$，用矩阵范数的次可乘性，

$$\lVert A\boldsymbol{x}\rVert_*=N\bigl(A\boldsymbol{x}\boldsymbol{b}^{\mathrm T}\bigr)=N\bigl(A\,(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})\bigr)\le N(A)\,N(\boldsymbol{x}\boldsymbol{b}^{\mathrm T})=N(A)\,\lVert\boldsymbol{x}\rVert_* .$$

∎

:::

:::

::: ex B5 · 新增 · 相对误差的精确公式

推导带符号相对误差的精确恒等式：$e_{\mathrm r}(ab)=e_{\mathrm r}(a)+e_{\mathrm r}(b)+e_{\mathrm r}(a)\,e_{\mathrm r}(b)$ 与 $e_{\mathrm r}\!\left(\dfrac ab\right)=\dfrac{e_{\mathrm r}(a)-e_{\mathrm r}(b)}{1+e_{\mathrm r}(b)}$，并据此说明教材中「乘除法相对误差限相加」在什么条件下近似成立。

::: sol 解答

先约定带符号相对误差的记法：$e_{\mathrm r}(a)=\dfrac{x-a}{a}$（即 $x=a(1+e_{\mathrm r}(a))$）。则

$$xy=a(1+e_{\mathrm r}(a))\,b(1+e_{\mathrm r}(b))=ab\bigl(1+e_{\mathrm r}(a)+e_{\mathrm r}(b)+e_{\mathrm r}(a)e_{\mathrm r}(b)\bigr),$$

对照 $xy=ab\,(1+e_{\mathrm r}(ab))$ 即得第一式。除法：

$$\frac{x}{y}=\frac{a}{b}\cdot\frac{1+e_{\mathrm r}(a)}{1+e_{\mathrm r}(b)}=\frac ab\left(1+\frac{e_{\mathrm r}(a)-e_{\mathrm r}(b)}{1+e_{\mathrm r}(b)}\right),$$

得第二式。当 $\lvert e_{\mathrm r}(a)\rvert,\lvert e_{\mathrm r}(b)\rvert\ll1$ 时，乘积项与 $\dfrac{e_{\mathrm r}(b)}{1+e_{\mathrm r}(b)}\approx e_{\mathrm r}(b)$ 的修正都是高阶小量，故近似为 $\varepsilon_{\mathrm r}$ 相加。∎

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

（第二个界的一行来历：$\lVert A\rVert_2^2=\lambda_{\max}(A^{\mathrm T}A)\le\lVert A^{\mathrm T}A\rVert_\infty\le\lVert A^{\mathrm T}\rVert_\infty\lVert A\rVert_\infty=\lVert A\rVert_1\lVert A\rVert_\infty$，其中 $\lVert A^{\mathrm T}\rVert_\infty=\lVert A\rVert_1$，且 $\lambda_{\max}\le$ 谱半径（spectral radius）$\le$ 任一算子范数——后者[第三章](sec11.md#roadmap)证明，此处可当引理用。）这两个界与 $\lVert A\rVert_F$ 互不控制，本题中 $9.950\gt8.888$。所有实测值与理论一致。

:::

:::

## C 组 · 计算与编程

::: ex C1 · 【原书习题 1、2】误差限与有效数字互推

(1)【原书习题 1】下列各近似值均有四位有效数字：$a=0.01347$，$b=-12.341$，$c=-1.200$。求它们的绝对误差限和相对误差限。
(2) 编程验证：把 $0.01347$ 视为某个未知真值 $x\in[0.013465,0.013475]$ 的近似，用 Python 检查区间两端点下 $a$ 是否都保持 4 位有效数字。

::: sol 解答

(1) 四位有效数字意味着误差限恰是末位的半个单位：

$$\varepsilon(a)=\tfrac12\times10^{-5}=0.000005,\quad \varepsilon_{\mathrm r}(a)=\frac{0.000005}{0.01347}\approx0.037\%;$$

$$\varepsilon(b)=\tfrac12\times10^{-3}=0.0005,\quad \varepsilon_{\mathrm r}(b)=\frac{0.0005}{12.341}\approx0.0041\%;$$

$$\varepsilon(c)=\tfrac12\times10^{-3}=0.0005,\quad \varepsilon_{\mathrm r}(c)=\frac{0.0005}{1.200}\approx0.042\%.$$

注意 $c=-1.200$ 的两个尾零使其误差限比 $-1.2$ 写法小 10 倍。
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

$\tilde u_1=1.46287\cdots=0.146\times10^1$（$m=1$）：$n=3$ 时 $\tfrac12\times10^{-2}=0.005\ge0.00171$ ✓，$n=4$ 时 $0.0005\lt0.00171$ ✗，故 $\tilde u_1$ 能有 **3 位**有效数字（$\tilde u_1\approx1.46$）。

(2) $u_2=xy-\dfrac xy$，$\tilde u_2=2.14\times(-1.231)+\dfrac{2.14}{1.231}=-2.63434+1.73842=-0.89592$。由 (1.1)，

$$\frac{\partial u_2}{\partial x}=y-\frac1y=-1.231+\frac{1}{1.231}=-0.41865,\qquad
\frac{\partial u_2}{\partial y}=x+\frac{x}{y^2}=2.14+\frac{2.14}{1.231^2}=3.55220 .$$

（注意此处的 $y$ 为负；两个偏导数已按链式法则合并：$\dfrac{\partial}{\partial y}\bigl(xy-\dfrac xy\bigr)=x+\dfrac{x}{y^2}$。）误差限按绝对值求和：

$$\varepsilon(\tilde u_2)\approx\lvert-0.41865\rvert\times0.005+\lvert3.55220\rvert\times0.0005\approx0.00209+0.00178=0.00387,$$

$$\varepsilon_{\mathrm r}(\tilde u_2)=\frac{0.00387}{0.89592}\approx0.43\% .$$

$\tilde u_2=-0.89592\times10^0$（$m=0$）：$n=2$ 时 $0.005\ge0.00387$ ✓，$n=3$ 时 $0.0005\lt$ ✗，故 $\tilde u_2$ 能有 **2 位**有效数字（$\tilde u_2\approx-0.90$）。验收标准：程序复算全部 8 个中间值，与教材数字逐位一致（误差 $\lt10^{-6}$）。

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

| 公式 | $\lvert g'\rvert$ | 误差估计 $G\delta$ | 实测结果 | 实测误差 |
|:--|:--:|:--:|:--:|:--:|
| $(\sqrt2-1)^6$ | $0.0614$ | $8.7\times10^{-4}$ | $0.004096$ | $9.6\times10^{-4}$ |
| $(3-2\sqrt2)^3$ | $0.240$ | $3.4\times10^{-3}$ | $0.008$ | $3.0\times10^{-3}$ |
| $99-70\sqrt2$ | $70$ | $1.0$ | $1.000$ | $9.9\times10^{-1}$ |
| $1/(\sqrt2+1)^6$ | $0.0131$ | $1.9\times10^{-4}$ | $0.0052328$ | $1.8\times10^{-4}$ |
| $1/(3+2\sqrt2)^3$ | $0.0053$ | $7.5\times10^{-5}$ | $0.0051253$ | $7.5\times10^{-5}$ |
| $1/(99+70\sqrt2)$ | $0.0018$ | $2.6\times10^{-5}$ | $0.0050761$ | $\mathbf{2.6\times10^{-5}}$ |

**结论：第 6 式 $1/(99+70\sqrt2)$ 的误差最小**（比第 3 式好近 5 个数量级）。道理在于：第 3 式是两个相近的大数 $99$ 与 $70\sqrt2\approx98$ 相减（放大因子 70）；第 6 式把同样两个数放进**分母**相加再取倒数——相近数由相减改为相加，除法又把误差进一步压低。验收标准：复现表中的实测列，并画出六个误差随 $\delta$ 变化的对数图（斜率应都为 1，截距差即放大因子之差）。

:::

:::

::: ex C5 · 【原书习题 7】求和次序 + 秦九韶实测

(1) 在四位十进制的限制下，选择精确度最高的算法计算 $u=1340\times10^2+40+50+60+90$。
(2) 用 Python 实测：$n=5000$ 时逐项幂算法与秦九韶算法的耗时比，验证 $O(n^2)$ 与 $O(n)$。

::: sol 解答

(1) 真值 $134000+240=134240$。原序（累加器先取 $0.1340\times10^6$）：按对阶规则，$40,50$ 小于累加器末位的半单位 $50$，$60,90$ 也过不了对阶，故在截断模型下全部丢失，结果停在 $0.1340\times10^6$，误差 $-240$；四舍五入模型下 60、90 会部分存活，见[实验三](sec12.md#sec-1.2.7)。**精确度最高的算法：先把小数加在一起**——$40+50+60+90=240$（精确），再 $134000+240=134240$，最后舍入得 $0.1342\times10^6$，误差仅 $-40$。
(2) 实测（教材运行环境，n=5000）：逐项幂 279 ms，秦九韶 0.39 ms，比值约 700。验收标准：你的实测比值应在数百量级；若接近 1，检查是否把「幂每次从 1 重乘」写成了「复用上一轮的 $x^k$」（那也是 $O(n)$，见[1.2.4](sec12.md#sec-1.2.4) 的代码注释）。

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
| 0 | 0.4024 | 0.4023595 | $+4.0\times10^{-5}$ |
| 1 | 0.1494 | 0.1494101 | $-1.0\times10^{-5}$ |
| 2 | 0.08765 | 0.0876475 | $+2.5\times10^{-6}$ |
| 3 | 0.06142 | 0.0614215 | $-1.5\times10^{-6}$ |
| 4 | 0.04714 | 0.0471446 | $-4.6\times10^{-6}$ |
| 5 | 0.03821 | 0.0382138 | $-3.8\times10^{-6}$ |
| 6 | 0.03212 | 0.0321132 | $+6.8\times10^{-6}$ |
| 7 | 0.02768 | 0.0276860 | $-6.0\times10^{-6}$ |
| 8 | 0.02433 | 0.0243285 | $+1.5\times10^{-6}$ |

初始误差按每步约 $\tfrac14$ 衰减（$4\times10^{-5}\to10^{-6}$ 量级），总量被新舍入噪声压在 $10^{-5}$ 附近、不再增长。验收标准：程序以 `y = 1/(4*n) - y/4` 迭代并打印误差列，误差总体呈 $\tfrac14$ 衰减趋势且不随 $n$ 累积增长；再把递推倒过来跑一遍，观察 $n$ 回退 8 步时误差放大 $4^8\approx6.5\times10^4$ 倍。

:::

:::

## D 组 · 开放建模

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

内存：float32 减半（$10^5$ 阶三对角存 3 条带约 $3\times10^5$ 个数 → 1.2 MB vs 2.4 MB）；速度：纯算术下 float32 可快 1~2 倍，但带宽受限时收益缩小（用 NumPy 实测 `np.dot` / `np.linalg.solvebanded`）；精度：float32 的 $u\approx6\times10^{-8}$ 对应约 7 位有效数字，而追赶法的舍入误差按 $O(n)$ 放大（$10^5$ 步 → 最坏丢掉 4~5 位，只剩 2~3 位有效数字），float64 放大后仍剩 11 位以上。**判据：保留位数 $\approx15.9-\log_{10}(\text{cond}\times n)$；小于任务要求位数就不能降精度。**（完整的条件数分析在[第三章](sec11.md#roadmap)，此处先按 $n$ 的量级估计。）

:::

:::

::: ex D3 · 数值代码体检器

写一个函数 `audit(expr_pairs, eps)`：输入一组「数学表达式 → 计算它的可调用函数」对，自动检测三类隐患：(a) 结果量级远小于操作数量级（疑似相近数相减：$\lvert u\rvert\lt10^{-6}\max(\lvert a\rvert,\lvert b\rvert)$）；(b) 除法的分母远小于分子（$\lvert b\rvert\lt10^{-6}\lvert a\rvert$）；(c) 大小悬殊的加法（$\lvert a\rvert\gt10^{9}\lvert b\rvert$ 且 $b\neq0$）。再用它体检求根公式、方差两遍法与 $(\sqrt2-1)^6$ 的六公式，输出「危险 / 安全」清单。

::: sol 提示与参考

参考骨架：

```python
def audit(name, f, args, eps=1e-6):
    a, b = args
    u = f(*args)
    risks = []
    if abs(u) < eps * max(abs(a), abs(b)) and u != 0:
        risks.append("疑似相近数相减")
    if b != 0 and abs(b) < eps * abs(a):
        risks.append("疑似小除数")
    if a != 0 and abs(a) > 1e9 * abs(b) and b != 0:
        risks.append("疑似大数吞噬小数")
    print(f"{name:24s} u={u:+.3e}  {'; '.join(risks) or '安全'}")
```

验收标准：对 $(\sqrt2-1)^6$ 的公式 3（$99-70\times1.4$）应报「疑似相近数相减」，对公式 6 报「安全」；报告里解释阈值 $10^{-6}$ 的选取依据（对应损失约 6 位有效数字的临界点）。

:::

:::

::: ex D4 · 真实数据的方差：三条路线的对比

找一组带真实偏移的数据（如某城市连续 30 天的气温、某股票连续收益率加常数、或你自己课程的分数），用三种方法算方差并对比：(a) 两遍法 $\dfrac1n\sum x_i^2-\bar x^2$；(b) 平移法（先减去肉眼可见的共同偏移）；(c) Welford 单遍算法。以 `statistics.variance` 或高精度 `math.fsum` 版本为基准，报告三种方法各自的相对误差，并解释结果差异。

::: sol 提示与参考

Welford 递推：$\bar x_1=x_1$，$s_1=0$；$\bar x_k=\bar x_{k-1}+\dfrac{x_k-\bar x_{k-1}}{k}$，$s_k=s_{k-1}+\bigl(x_k-\bar x_{k-1}\bigr)\bigl(x_k-\bar x_k\bigr)$；方差 $=\dfrac{s_n}{n-1}$（样本方差）。预期现象：数据共同偏移 $\mu\gg$ 波动幅度时 (a) 失效（可复现教材实验二的 $0$ 输出，把偏移加大到 $10^{10}$），(b)(c) 稳定；Welford 的优点是**单遍数据流**即可用，且每一步都不构造大数。报告要点：列出偏移/波动比从 $10^0$ 扫到 $10^{10}$ 的误差曲线，标出 (a) 开始失守的临界比值并解释（$\Sigma x_i^2$ 的绝对舍入误差 $\sim n\cdot u\cdot\mu^2$ 追上方差本身）。

:::

:::

::: note 原书习题对照表

原书 15 道习题的归宿：习题 1、2 → [C1]；习题 3 → [A3(c)(d)]；习题 4 → [C2]；习题 5 → [C3]；习题 6 → [C4]；习题 7 → [C5]；习题 8 → [C6]；习题 9 → 正文[@thm-1.3.1] 已证；习题 10 → [B1]；习题 11 → 正文 1.3.4 已证；习题 12 → [B6] 的数值检验部分；习题 13 → [B3]；习题 14 → [B2][B6]；习题 15 → [B4]。新增的 A、D 组题只使用第一章概念。

:::
