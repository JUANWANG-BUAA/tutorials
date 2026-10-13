# 1.2 误差知识与算法知识

本节是全书的地基，只讲一件事：**误差是怎么走路的**。具体分四步：误差从哪里来（1.2.1）；怎么度量一个近似值好不好（1.2.2）；它如何跟着运算一步步传下去、被放大（1.2.3–1.2.4）；以及怎么设计算法把它管住（1.2.4–1.2.6）。原书例 1–例 5 与全部经典论证完整保留，证明与推导全部展开。

<aside class="lesson-brief" aria-label="1.2 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>Taylor 公式（一元与多元一阶展开）；极限与 $O$ 记号的直觉。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>误差四分类；$\varepsilon$ / $\varepsilon_{\mathrm r}$ / 有效数字三件套；误差传播公式；稳定性与复杂性两大算法标准；浮点算术的基本公理。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>拿到任意一个计算公式，能估计结果的误差限、指出可靠的有效数字位数，并识别「相近数相减、小除数、大数吃小数」三类危险结构后改写。</p></div>
</aside>

<a id="sec-1.2.1"></a>

## 1.2.1 误差的来源与分类

工程计算中，估计结果的精确度十分重要，而精确度受各种误差的影响。按来源划分，误差有四类。

::: intuition 直觉 · 四类误差按「谁造成的」分
- **写公式的人**造成模型误差（公式本身只是近似）；
- **量数据的人**造成观测误差（参数测不准）；
- **选算法的人**造成截断误差（无穷过程截成有限步）；
- **机器**造成舍入误差（数存不进有限字长）。

前两类在计算开始**之前**就已注定，各有专门的学科（建模、测量）去管；数值分析主要管后两类——只有它们能靠**算法设计**控制。不过四类误差一旦进入计算，走的都是同一条传播路径（1.2.3），所以本节的工具对它们一视同仁。
:::


::: def 定义 1.2.1 · 模型误差 {#def-1.2.1}
反映实际问题有关量之间关系的计算公式（即**数学模型**）通常只是近似的。数学模型的解与实际问题的解之间的误差称为**模型误差**（model error）。
:::

::: def 定义 1.2.2 · 观测误差 {#def-1.2.2}
数学模型中包含的某些参数（如时间、长度、电压）往往通过观测获得，观测数据与实际数据之间的误差称为**观测误差**（observation error）。
:::

::: def 定义 1.2.3 · 截断误差 {#def-1.2.3}
求解数学模型所用的数值方法若是一种近似方法，则只能得到数学模型的近似解，由此产生的误差称为**截断误差**（truncation error），又称**方法误差**。
:::

**典型例子：Taylor 展开的截断。**由 Taylor 公式，函数 $f(x)$ 在 $x=0$ 处可表示为

$$f(x)=f(0)+f'(0)x+\frac{f''(0)}{2!}x^2+\cdots+\frac{f^{(n)}(0)}{n!}x^n+\frac{f^{(n+1)}(\theta x)}{(n+1)!}x^{n+1},\qquad 0\lt\theta\lt1 .$$

当 $\lvert x\rvert$ 不大时，去掉右端最后一项（余项），得近似公式

$$f(x)\approx f(0)+f'(0)x+\frac{f''(0)}{2!}x^2+\cdots+\frac{f^{(n)}(0)}{n!}x^n .$$

此近似公式的误差就是截断误差——它来自「方法」对无穷级数尾部的舍弃，与机器无关。例如 $\sin x \approx x - x^3/6$ 在 $x=0.5$ 处的截断误差约为 $0.5^5/120 \approx 2.6\times10^{-4}$。

::: def 定义 1.2.4 · 舍入误差 {#def-1.2.4}
计算机的字长有限，参加运算的数据及其运算结果在计算机上存放会产生误差，这种误差称为**舍入误差**（rounding error），又称**计算误差**。
:::

原书给出两个十位十进制下的例子。第一个是 $1\div3 = 0.3333333333$：无穷循环小数被截断。

第二个是 $(1.000002)^2-1.000004 = 0$，而精确值是 $4\times10^{-12}$：$(1.000002)^2 = 1.000004000004$，减去 $1.000004$ 应剩 $0.000000000004$；但在十位字长下，两个操作数都只保留到第 10 位数字，相减结果被舍成 $0$。这里产生的误差就是舍入误差。

::: method 四类误差鸟瞰
把四类误差并排放在一起，差别一目了然：

| 误差 | 产生环节 | 例子 | 能否由算法消除 |
|:--|:--|:--|:--|
| 模型误差 | 建模 | Newton 力学代替相对论力学 | 否（建模问题） |
| 观测误差 | 参数测量 | $g = 9.8\ \mathrm{m/s^2}$ | 否（测量问题） |
| 截断误差 | 数值方法 | $\sin x\approx x-x^3/6$ | 只能控制（取更高阶） |
| 舍入误差 | 机器执行 | $0.1$ 存不进二进制 | 只能控制（见 [1.2.4](#sec-1.2.4) 设计原则） |

**数值分析主要研究截断误差和舍入误差对计算结果的影响，一般不考虑模型误差和观测误差**——后两者分别由建模学科与测量学科负责。但要记住：这两种误差一旦混进计算，依旧按本节的传播规律起作用，所以下面的分析对它们同样适用。

:::

<a id="sec-1.2.2"></a>

## 1.2.2 绝对误差、相对误差与有效数字

### 绝对误差与误差限

::: def 定义 1.2.5 · 绝对误差与误差限 {#def-1.2.5}
设 $a$ 是准确值 $x$ 的一个近似值，记

$$e = x-a ,$$

称 $e$ 为近似值 $a$ 的**绝对误差**（absolute error），简称误差。如果 $\lvert e\rvert$ 的一个上界已知，记为 $\varepsilon$，即 $\lvert e\rvert\le\varepsilon$，则称 $\varepsilon$ 为近似值 $a$ 的**绝对误差限**（absolute error bound），简称误差限或误差界。
:::

准确值 $x$、近似值 $a$ 和误差限 $\varepsilon$ 三者的关系是

$$a-\varepsilon\lt x\lt a+\varepsilon ,$$

常记为 $x = a\pm\varepsilon$。例如，$a=3.14$ 作为圆周率 $\pi$ 的一个近似值，绝对误差为 $e=\pi-3.14$。由 $\pi=3.14159265\cdots$ 易知 $\lvert e\rvert\lt0.002$，故可取误差限 $\varepsilon = 0.002$，写作 $\pi = 3.14\pm0.002$。

用绝对误差刻画精确程度有局限：它没有反映误差在数本身中所占的比例。用最小刻度为毫米的卡尺量一根火柴（$\approx20$ mm）和量一根竹竿（$\approx2$ m），绝对误差限同样是 $0.5$ mm，但两者的可信程度天差地别——这就需要相对误差。

### 相对误差与相对误差限

::: def 定义 1.2.6 · 相对误差与相对误差限 {#def-1.2.6}
记

$$e_{\mathrm r} = \frac{e}{x} = \frac{x-a}{x} ,$$

称 $e_{\mathrm r}$ 为近似值 $a$ 的**相对误差**（relative error）。由于 $x$ 未知，实际上总把

$$e_{\mathrm r} \approx \frac{x-a}{a}$$

作为 $a$ 的相对误差。相对误差限为

$$\varepsilon_{\mathrm r} = \frac{\varepsilon(a)}{\lvert a\rvert} ,$$

即 $\lvert e_{\mathrm r}\rvert\le\varepsilon_{\mathrm r}$。相对误差一般用百分比表示。
:::

**两种相对误差差多远？**（推导）真实值 $(x-a)/x$ 与实用值 $(x-a)/a$ 之间只差一个因子：

$$\frac{x-a}{a}=\frac{x-a}{x}\cdot\frac{x}{a}=e_{\mathrm r}\cdot\frac{1}{1-e_{\mathrm r}} = e_{\mathrm r}\,(1+e_{\mathrm r}+e_{\mathrm r}^2+\cdots),$$

可见二者之差是 $e_{\mathrm r}$ 的高阶小量 $e_{\mathrm r}^2+e_{\mathrm r}^3+\cdots$。数值计算里 $\lvert e_{\mathrm r}\rvert$ 通常远小于 $1$（否则近似值毫无意义），替换是安全的；只有 $\lvert e_{\mathrm r}\rvert\ge0.1$ 量级时才需要警惕，此时近似值本身已接近失效。另外，$x=0$ 处相对误差无定义——近似 $0$ 只能靠绝对误差谈论。

::: ex 例 1.2.1（原书例 1） · 卡尺测量 {#ex-1.2.1}
用最小刻度为毫米的卡尺测量直杆甲和直杆乙，分别读出长度 $a=312$ mm 和 $b=24$ mm。问 $\varepsilon(a),\varepsilon(b),\varepsilon_{\mathrm r}(a),\varepsilon_{\mathrm r}(b)$ 各是多少？两直杆实际长度 $x$ 和 $y$ 在什么范围内？

::: proof 解
读数最小刻度为 1 mm，估读到半格，故

$$\varepsilon(a)=\varepsilon(b)=0.5\ \text{mm},\qquad
\varepsilon_{\mathrm r}(a)=\frac{0.5}{312}\approx0.16\%,\qquad
\varepsilon_{\mathrm r}(b)=\frac{0.5}{24}\approx2.08\% .$$

$$311.5\ \text{mm}\lt x\lt312.5\ \text{mm},\qquad 23.5\ \text{mm}\lt y\lt24.5\ \text{mm}.$$

两次测量的**绝对**误差限相同，**相对**误差限却相差 13 倍——量短杆时读数的相对「质量」更差。这正是相对误差所刻画的「误差在原数中所占的比例」。
:::

:::

::: ex 例 1.2.2（原书例 2） · 四舍五入近似值的误差限 {#ex-1.2.2}
设 $a=-2.18$ 和 $b=2.1200$ 是分别由准确值 $x$ 和 $y$ 经过四舍五入而得到的近似值。问 $\varepsilon(a),\varepsilon(b),\varepsilon_{\mathrm r}(a),\varepsilon_{\mathrm r}(b)$ 各是多少？

::: proof 解
四舍五入到末位，则

$$\varepsilon(a)=0.005,\qquad \varepsilon(b)=0.00005,$$

$$\varepsilon_{\mathrm r}(a)=\frac{0.005}{2.18}\approx0.23\%,\qquad
\varepsilon_{\mathrm r}(b)=\frac{0.00005}{2.1200}\approx0.0024\%.$$

**为什么四舍五入的误差限恰是末位的半个单位？**（推导）把 $x$ 四舍五入到小数点后 $d$ 位得 $a$：$a$ 与 $x$ 的小数点后 $d$ 位对齐，舍去的部分 $\delta\in[-\tfrac12\times10^{-d},\ \tfrac12\times10^{-d}]$（进位时 $\delta$ 为负），故 $\lvert x-a\rvert\le\tfrac12\times10^{-d}$，而 $a$ 的末位正是 $10^{-d}$——误差限恰为末位的半个单位。这也正是下一小节有效数字定义的依据。∎
:::

:::

### 有效数字

::: intuition 直觉 · 有效数字就是「你敢担保的位数」
从**第一个非零数字**开始往后数，数到「敢担保没问题」的那一位为止，共几位就是几位有效数字。$3.14$ 担保 3 位（$3,1,4$）；$3.1400$ 担保 5 位——末尾那两个 $0$ 不是摆设，它们是「这两位我也查过了」的书面承诺，所以**尾零有意义**。

凭什么敢担保？因为误差不超过**末位的半个单位**——四舍五入天然保证这一点。下面的定义只是把这句话写严：先把数写成规格化形式（小数点前只留一个 $0$，小数点后第一位非零），再把「第 $n$ 位有效」翻译成不等式 $\varepsilon(a)\le\tfrac12\times10^{m-n}$。
:::

::: def 定义 1.2.7 · 有效数字 {#def-1.2.7}
设数 $a$ 是数 $x$ 的近似值。如果 $a$ 的绝对误差限是它的某一位的半个单位，并且从该位到它的**第一位非零数字**共有 $n$ 位，则称用 $a$ 近似 $x$ 时具有 $n$ 位**有效数字**（significant digits）。

非零小数 $a$ 总可以写成规格化形式

$$a=\pm0.a_1a_2\cdots a_k\times10^m ,$$

其中 $m$ 是整数，$a_i\ (i=1,2,\cdots,k)$ 是 $0$ 到 $9$ 中的一个数字，$a_1\neq0$。如果 $a$ 作为数 $x$ 的近似值，且

$$\varepsilon(a)=\tfrac12\times10^{m-n},\qquad n\le k ,$$

则由定义知 $a$ 有 $n$ 位有效数字 $a_1,a_2,\cdots,a_n$。
:::

三条直接推论（原书所述，逐条解释）：

1. **由准确值经四舍五入得到的近似值，从它的末位数字到第一位非零数字都是有效数字**（例 2 的结论换一种说法）。
2. **同一个准确值的不同近似值，有效数字越多，绝对误差与相对误差都越小。**绝对误差限 $\tfrac12\times10^{m-n}$ 随 $n$ 增大而按十倍速缩小；相对误差限见下面的 [@thm-1.2.1]，也随 $n$ 缩小。
3. **尾零有意义：**$2.140012$ 的两个近似值 $2.14$ 与 $2.1400$ 写法有区别——前者 3 位有效数字，后者 5 位。**准确值的有效数字可视为有无限多位。**

::: intuition 直觉 · 有效数字与相对误差的「汇率」
下面的定理给两种「好不好」的度量定了一个汇率：**每多一位有效数字，相对误差就缩小十倍**。3 位有效数字 ⟹ 相对误差不超过约 $0.5\%$；6 位 ⟹ 不超过约 $0.0005\%$。反过来，已知相对误差限也能倒推出至少有几位有效数字。记住这个十倍关系，比背不等式本身有用。
:::

::: thm 定理 1.2.1（新增） · 有效数字与相对误差的换算 {#thm-1.2.1}
设 $a=\pm0.a_1a_2\cdots a_k\times10^m\ (a_1\neq0)$ 是 $x$ 的具有 $n$ 位有效数字的近似值，则

$$\varepsilon_{\mathrm r}(a)=\frac{\varepsilon(a)}{\lvert a\rvert}\le\frac{1}{2a_1}\times10^{1-n}\le\frac{1}{2}\times10^{1-n} .$$

反之，若 $\varepsilon_{\mathrm r}(a)\le\dfrac{1}{2(a_1+1)}\times10^{1-n}$，则 $a$ 至少有 $n$ 位有效数字。

::: proof 证明
**正方向。**由 $a_1\ge1$ 得 $\lvert a\rvert = 0.a_1a_2\cdots\times10^m\ \ge\ 0.1\times10^m = 10^{m-1}$，于是

$$\varepsilon_{\mathrm r}(a)=\frac{\tfrac12\times10^{m-n}}{\lvert a\rvert}\le\frac{\tfrac12\times10^{m-n}}{10^{m-1}}=\frac12\times10^{1-n} .$$

**更强的版本：**由 $\lvert a\rvert \ge a_1\times10^{m-1}$ 得 $\varepsilon_{\mathrm r}\le\tfrac{1}{2a_1}\times10^{1-n}$。

**逆方向。**若 $\varepsilon_{\mathrm r}(a)\le\dfrac{1}{2(a_1+1)}\times10^{1-n}$，则由 $a=0.a_1a_2\cdots\times10^m\lt(a_1+1)\times10^{m-1}$ 得

$$\varepsilon(a)=\lvert a\rvert\,\varepsilon_{\mathrm r}(a)\lt(a_1+1)\times10^{m-1}\cdot\frac{1}{2(a_1+1)}\times10^{1-n}=\tfrac12\times10^{m-n},$$

即 $a$ 的绝对误差限不超过第 $n$ 位数字所在位的半个单位，故 $a$ 至少有 $n$ 位有效数字。∎
:::

:::

::: ex 例 1.2.3（原书例 3） · 位数不匹配就没有有效数字 {#ex-1.2.3}
下列近似值的绝对误差限都是 $0.005$：$a=1.38,\ b=-0.0312,\ c=0.86\times10^5$。问各个近似值有几位有效数字？

::: proof 解
**$a=1.38=0.138\times10^1$**（$m=1$）：$\varepsilon(a)=0.005=\tfrac12\times10^{1-3}$，$n=3\le k=3$，故 $a$ 有**三位**有效数字 $1,3,8$。

**$b=-0.0312=-0.312\times10^{-1}$**（$m=-1$）：$\varepsilon(b)=0.005=\tfrac12\times10^{-1-1}$，$n=1\le k=3$，故 $b$ 有**一位**有效数字 $3$。注意小数点后的 $0$ 不算有效数字——有效数字从第一位非零数字数起。

**$c=0.86\times10^5$**（$m=5$，只写出 $k=2$ 位）：若要有 $n$ 位有效数字需 $\varepsilon(c)=\tfrac12\times10^{5-n}=0.005=\tfrac12\times10^{-2}$，即 $n=7\gt k=2$——误差限要求第 7 位数字都准确，而写出的数只有 2 位数字。故 $c$ **没有**有效数字。这个例子说明：**给近似值标误差限时，误差限必须与写出的位数相称**；$\varepsilon(c)=0.005$ 与「只写两位数字」的写法互相矛盾。∎
:::

:::

::: ex 例 1.2.4（新增） · 圆周率的「四位写法」其实有五位 {#ex-1.2.4}
$\pi = 3.14159265\cdots$ 的近似值 $a = 3.1416$ 有几位有效数字？

::: proof 解
$a=0.31416\times10^1$（$m=1$）。实际误差 $\lvert\pi-3.1416\rvert \approx 7.3\times10^{-6}$。要判断位数，找满足 $\tfrac12\times10^{1-n}\ \ge\ 7.3\times10^{-6}$ 的最大 $n$：$n=5$ 时 $\tfrac12\times10^{-4}=5\times10^{-5}\ge7.3\times10^{-6}$ ✓；$n=6$ 时 $5\times10^{-6}\lt7.3\times10^{-6}$ ✗。故 $a$ 有**五位**有效数字 $3,1,4,1,6$。

反直觉之处：四舍五入到小数点后 4 位（「四位小数」），得到的却是 5 位有效数字。因为首位数字是 3，规格化后 $m=1$，末位 $6$ 落在 $10^{-4}$ 位上，而有效位数要从首位数字一路数到末位，共 5 位。**有效数字位数 ≠ 小数位数。**∎
:::

:::

::: method 判定流程 · 「这个近似值有几位有效数字」
1. 写成规格化形式 $\pm0.a_1a_2\cdots a_k\times10^m$，确定 $m$ 与写出的位数 $k$；
2. 由误差限解方程 $\tfrac12\times10^{m-n}=\varepsilon(a)$ 得 $n = m-\log_{10}(2\varepsilon)$；
3. 若 $n\le k$ 且实际误差确实不超过 $\tfrac12\times10^{m-n}$，则有 $n$ 位有效数字；若解出的 $n\gt k$，则没有（写法与误差限不匹配）；
4. 快捷核对：误差限恰是**某一位**的半个单位，数一数从那一位到首位非零数字共几位。
:::

<a id="sec-1.2.3"></a>

## 1.2.3 函数求值的误差估计

设 $u=f(x)$ 存在足够高阶的导数，$a$ 是自变量 $x$ 的近似值，则 $\tilde u=f(a)$ 是函数值 $u=f(x)$ 的近似值。本小节回答：**自变量的误差 $e(a)$ 如何决定函数值的误差 $e(\tilde u)$？**

::: intuition 直觉 · 一句话版本：误差 × 放大倍数
把 $f$ 想成一台机器，输入端进来一点抖动 $e(a)$，输出端的抖动大约是

$$\text{输出的误差} \approx \underbrace{f'(a)}_{\text{放大倍数}}\times \text{输入的误差}.$$

导数 $f'(a)$ 就是这台机器的**误差放大倍率**：倍率小于 1，输入的抖动被吸收；倍率远大于 1，小抖动被放大成大错误。整个 1.2.3 只在做一件事：把这句白话变成公式；整个 1.2.4 的「设计原则」，也只是在挑放大倍率小的写法。
:::


### 一元情形

::: thm 定理 1.2.2 · 函数求值的误差估计（原书结论，此处推导） {#thm-1.2.2}
若 $f'(a)\neq0$ 且比值 $\lvert f''(a)\rvert/\lvert f'(a)\rvert$ 不很大，则

$$e(\tilde u)=f(x)-f(a)\approx f'(a)(x-a)=f'(a)\,e(a),$$

$$\varepsilon(\tilde u)\approx\lvert f'(a)\rvert\,\varepsilon(a).$$

若 $f'(a)=f''(a)=\cdots=f^{(k-1)}(a)=0$，$f^{(k)}(a)\neq0$，且比值 $\lvert f^{(k+1)}(a)\rvert/\lvert f^{(k)}(a)\rvert$ 不很大，则

$$e(\tilde u)\approx\frac{f^{(k)}(a)}{k!}\,[e(a)]^k,\qquad
\varepsilon(\tilde u)\approx\frac{\lvert f^{(k)}(a)\rvert}{k!}\,[\varepsilon(a)]^k .$$

::: proof 推导
由 Taylor 公式，把 $f(x)$ 在 $a$ 处展开到一阶带 Lagrange 余项：

$$f(x)=f(a)+f'(a)(x-a)+\frac{f''(\xi)}{2!}(x-a)^2,\qquad \xi\ \text{介于}\ a\ \text{与}\ x\ \text{之间}.$$

移项：

$$e(\tilde u)=f(x)-f(a)=f'(a)\,(x-a)+\frac{f''(\xi)}{2}(x-a)^2=f'(a)\,e(a)+O\!\left([e(a)]^2\right).$$

当 $\lvert e(a)\rvert$ 小且 $\lvert f''\rvert/\lvert f'\rvert$ 不很大时，二阶项相对一阶项是 $O(e(a))$ 的小量，可以略去，得 $e(\tilde u)\approx f'(a)e(a)$。取绝对值并用 $\lvert e(a)\rvert\le\varepsilon(a)$ 放缩即得误差限公式。

高阶情形：若前 $k-1$ 阶导数在 $a$ 处全为零，Taylor 展开的首个非零项是 $k$ 阶项：

$$e(\tilde u)=\frac{f^{(k)}(a)}{k!}(x-a)^k+\frac{f^{(k+1)}(\xi)}{(k+1)!}(x-a)^{k+1}
\approx\frac{f^{(k)}(a)}{k!}\,[e(a)]^k ,$$

其中用到 $x-a=e(a)$。∎
:::

:::

**放大因子怎么读。**$\lvert f'(a)\rvert$ 衡量误差从输入传到输出被放大多少倍：$\lvert f'(a)\rvert\le1$ 时，函数反而「吸收」误差；$\lvert f'(a)\rvert\gg1$ 时，输入的小误差被放大成输出的大误差。这正是「问题的条件数」概念的雏形，[1.2.6](#sec-1.2.6) 会把它精确化。

### 多元情形

设 $n$ 元函数 $u=f(x_1,x_2,\cdots,x_n)$ 充分可微，$a_i$ 是 $x_i$ 的近似值，则 $\tilde u=f(a_1,a_2,\cdots,a_n)$ 是 $u$ 的近似值。由多元函数 Taylor 公式（一阶展开）得

$$e(\tilde u)\approx\sum_{i=1}^{n}\frac{\partial f(a_1,a_2,\cdots,a_n)}{\partial x_i}\,e(a_i),\qquad
\varepsilon(\tilde u)\approx\sum_{i=1}^{n}\left\lvert\frac{\partial f(a_1,a_2,\cdots,a_n)}{\partial x_i}\right\rvert\varepsilon(a_i). \tag{1.1}$$

**推导要点：**把其余变量视为常数、对每个变量分别用一元 Taylor 展开（一阶），相加后二阶交叉项 $O([e(a_i)]^2)$ 与 $O(e(a_i)e(a_j))$ 在 $\lvert e(a_i)\rvert$ 都很小时可略。

如果所有 $\left\lvert\partial f/\partial x_i\right\rvert$ 全为零或全都很小（一阶项消失），则要使用 Taylor 公式中的高阶项——典型场景正是下面四则运算中的「相近数相减」。

### 四则运算的误差估计

设 $a$ 和 $b$ 分别是准确值 $x$ 和 $y$ 的近似值，则 $a+b,\ a-b,\ ab,\ a/b\ (b\neq0)$ 分别是 $x+y,\ x-y,\ xy,\ x/y$ 的近似值。对四则运算逐个使用式 (1.1)：

::: intuition 直觉 · 四条公式，三句白话
- **加减法看绝对误差**：绝对误差限直接相加，从来只增不减——没法避免，也通常不致命。
- **乘除法看相对误差**：相对误差限简单相加——乘除是「友好」运算。
- **两处致命点**：减法的相对误差限分母是 $\lvert a-b\rvert$，**相近数相减时分母趋零，相对误差爆炸**；除法的绝对误差限带 $\lvert b\rvert^2$，**小除数二次放大**。后面 1.2.4 的原则 (3)(4) 专门对付这两处。

下面的表格只是把这三句话写成分式，用时查表即可。
:::

::: method 四则运算误差限公式（原书 p.4 · 附推导）

| 运算 | 绝对误差限 | 相对误差限 |
|:--|:--|:--|
| $a\pm b$ | $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$ | $\varepsilon_{\mathrm r}(a+b)=\dfrac{\varepsilon(a)+\varepsilon(b)}{\lvert a+b\rvert}$，$\ \varepsilon_{\mathrm r}(a-b)=\dfrac{\varepsilon(a)+\varepsilon(b)}{\lvert a-b\rvert}$ |
| $a\,b$ | $\varepsilon(ab)\approx\lvert a\rvert\,\varepsilon(b)+\lvert b\rvert\,\varepsilon(a)$ | $\varepsilon_{\mathrm r}(ab)\approx\varepsilon_{\mathrm r}(a)+\varepsilon_{\mathrm r}(b)$ |
| $a/b$ | $\varepsilon\!\left(\dfrac ab\right)\approx\dfrac{\lvert a\rvert\,\varepsilon(b)+\lvert b\rvert\,\varepsilon(a)}{\lvert b\rvert^2}$ | $\varepsilon_{\mathrm r}\!\left(\dfrac ab\right)\approx\varepsilon_{\mathrm r}(a)+\varepsilon_{\mathrm r}(b)$ |

**推导（以 $a-b$ 与 $a/b$ 为例，其余同法）。**记 $f(x,y)=x-y$，则 $\partial f/\partial x=1,\ \partial f/\partial y=-1$，代入 (1.1)：$\lvert e(a-b)\rvert\approx\lvert e(a)-e(b)\rvert\le\varepsilon(a)+\varepsilon(b)$，取误差限即第一行。$f(x,y)=x/y$：$\partial f/\partial x=1/y$，$\partial f/\partial y=-x/y^2$，代入 (1.1) 并在导数中用 $a,b$ 代替 $x,y$：

$$\varepsilon\!\left(\frac ab\right)\approx\frac{\varepsilon(a)}{\lvert b\rvert}+\frac{\lvert a\rvert\,\varepsilon(b)}{\lvert b\rvert^2}=\frac{\lvert b\rvert\,\varepsilon(a)+\lvert a\rvert\,\varepsilon(b)}{\lvert b\rvert^2}.$$

除法的相对误差限：$\varepsilon(a/b)/\lvert a/b\rvert\approx\dfrac{\lvert b\rvert\varepsilon(a)+\lvert a\rvert\varepsilon(b)}{\lvert b\rvert^2}\cdot\dfrac{\lvert b\rvert}{\lvert a\rvert}=\dfrac{\varepsilon(a)}{\lvert a\rvert}+\dfrac{\varepsilon(b)}{\lvert b\rvert}=\varepsilon_{\mathrm r}(a)+\varepsilon_{\mathrm r}(b)$。

**三条使用要点：**
① 加减法：**绝对**误差限只能相加，无从避免；**相对**误差限则要看分母 $\lvert a-b\rvert$——两数相近时 $\lvert a-b\rvert$ 趋近于零，**相对误差随之爆炸**。
② 乘除法：两条公式都只用相对误差限，相加即可——这正是乘除比加减「友好」的地方。
③ 除法：若 $\lvert b\rvert\ll\lvert a\rvert$，绝对误差限被 $\lvert b\rvert^2$ 放大——**小除数危险**。
:::

::: ex 例 1.2.5（原书例 4） · 混合运算的误差限 {#ex-1.2.5}
设有三个近似数 $a=2.31,\ b=1.93,\ c=2.24$，它们都有三位有效数字。试计算 $p=a+bc$、$\varepsilon(p)$ 和 $\varepsilon_{\mathrm r}(p)$，并问：$p$ 的计算结果能有几位有效数字？

::: proof 解
三位有效数字给出各自的误差限：$\varepsilon(a)=\varepsilon(b)=\varepsilon(c)=0.005$。

$$p=2.31+1.93\times2.24=6.6332 .$$

先用乘法公式再用加法公式（误差限一律相加）：

$$\varepsilon(bc)\approx\lvert b\rvert\,\varepsilon(c)+\lvert c\rvert\,\varepsilon(b)=0.005\times(1.93+2.24)=0.02085,$$

$$\varepsilon(p)=\varepsilon(a)+\varepsilon(bc)=0.005+0.02085=0.02585 .$$

$$\varepsilon_{\mathrm r}(p)=\frac{0.02585}{6.6332}\approx0.39\% .$$

判断有效数字：$p=0.66332\times10^1$（$m=1$），检验 $n=2$：$\tfrac12\times10^{1-2}=0.05\ge0.02585$ ✓；$n=3$：$0.005\lt0.02585$ ✗。故 $p=6.6332$ **能有两位有效数字**（即只有 $6.6$ 两位可靠，应写 $p\approx6.6$）。

**注：**三个三位有效数字的输入，运算后只剩两位——乘法与加法各吃掉约一位。这不是「算错」，而是误差传播的必然。∎
:::

:::

::: ex 例 1.2.6（原书例 5） · 二元函数的误差限 {#ex-1.2.6}
设 $f(x,y)=\dfrac{\cos y}{x}$，$x=1.30\pm0.005$，$y=0.871\pm0.0005$。如果用 $\tilde u=f(1.30,\,0.871)$ 作为 $f(x,y)$ 的近似值，则 $\tilde u$ 能有几位有效数字？

::: proof 解

$$\tilde u=\frac{\cos 0.871}{1.30}\approx0.49543 .$$

由 (1.1)，$\partial f/\partial x=-\cos y/x^2$，$\partial f/\partial y=-\sin y/x$，代入近似值：

$$\varepsilon(\tilde u)\approx\frac{\cos 0.871}{1.30^2}\times0.005+\frac{\sin 0.871}{1.30}\times0.0005
\approx0.0019+0.0003=0.0022\lt0.005 .$$

$\tilde u=0.49543=0.49543\times10^0$（$m=0$）：$n=2$ 时 $\tfrac12\times10^{-2}=0.005\ge0.0022$ ✓，$n=3$ 时 $0.0005\lt0.0022$ ✗。故 $\tilde u$ 能有**两位**有效数字（应写 $\tilde u\approx0.50$）。∎
:::

:::

::: ex 例 1.2.7（新增） · 相近数相减：一步吃光全部有效数字 {#ex-1.2.7}
已知 $a=1.414$ 与 $b=1.413$ 分别是 $\sqrt2$ 和某个准确值 $y$ 的近似值，误差限均为 $0.0005$。计算 $w=a-b$，求 $\varepsilon(w)$ 与 $\varepsilon_{\mathrm r}(w)$。

::: proof 解
$w=a-b=0.001$。由减法公式：

$$\varepsilon(w)=\varepsilon(a)+\varepsilon(b)=0.001,\qquad
\varepsilon_{\mathrm r}(w)=\frac{\varepsilon(a)+\varepsilon(b)}{\lvert a-b\rvert}=\frac{0.001}{0.001}=100\% .$$

结果的绝对误差限与结果本身同数量级——$w=0.001$ 连**一位**有效数字都保不住（真值可以是 $0$ 与 $0.002$ 之间的任何数）。两个输入各有 4 位有效数字，一步减法之后全部蒸发。这就是「相近数相减」的危害，改写方案见 [1.2.4](#sec-1.2.4) 设计原则 (3)。∎
:::

:::

::: think 思考 · 带符号的误差公式长什么样？
表中公式全部用误差限 $\varepsilon\ge0$ 书写。若改用**带符号**的误差 $e$，则乘法的精确关系是（推导）：

$$e(ab)=xy-ab=(a+e(a))(b+e(b))-ab=b\,e(a)+a\,e(b)+e(a)\,e(b),$$

除以 $ab$ 得精确的相对误差关系：

$$e_{\mathrm r}(ab)=e_{\mathrm r}(a)+e_{\mathrm r}(b)+e_{\mathrm r}(a)\,e_{\mathrm r}(b).$$

当误差限很小时，略去乘积项即回到表中公式。加减法的带符号版本则是**精确**的：$e(a\pm b)=e(a)\pm e(b)$；误差限公式里的「+」来自放缩 $\lvert e(a)-e(b)\rvert\le\lvert e(a)\rvert+\lvert e(b)\rvert$，是个最坏情形估计。
:::

<a id="sec-1.2.4"></a>

## 1.2.4 算法及其计算复杂性

先把「算法」这个词说准，再谈用什么标准衡量算法的优劣。

::: def 定义 1.2.8 · 算法 {#def-1.2.8}
**算法**（algorithm）是规定了怎样从输入数据计算出数值问题解的一个**有限的基本运算序列**，其中基本运算指四则运算、逻辑运算和一些基本函数运算。
:::

衡量算法优劣有两个标准：**一是要有可靠的理论基础**，包括正确性、收敛性、数值稳定性，并可作误差分析；**二是要有良好的计算复杂性**。所谓**计算复杂性**，是指达到给定精度时该算法所需的计算量（时间复杂性）与所占的内存空间（空间复杂性）。

::: note 大 $O$ 记号（补充）
称计算量 $T(n)=O(g(n))$，若存在常数 $C\gt0$ 与 $n_0$，使 $n\ge n_0$ 时 $T(n)\le C\,g(n)$。它刻画计算量随问题规模增长的**阶**，忽略常数因子。例如 $T(n)=\frac{n(n+1)}2$ 次乘法记为 $O(n^2)$，$T(n)=n$ 次记为 $O(n)$。注意 $O$ 记号描述渐近行为：$n$ 不大时，$O(n^2)$ 的算法可能更快——常数因子与实现质量同样重要。
:::

### 例行公事：多项式求值的两种算法

计算 $p(x)=\displaystyle\sum_{j=0}^{n}a_jx^j$ 的值，输入 $a_j\ (j=0,1,\cdots,n)$ 和 $x$，输出 $p(x)$。

::: method 算法一 · 逐项求和（先算幂再乘系数）

$$\begin{cases}S_0=a_0,\\ S_k=a_k\,x^k & (k=1,2,\cdots,n),\\ p(x)=S_0+S_1+\cdots+S_n.\end{cases}$$

若幂 $x^k$ 每次从 $x$ 自乘得到，第 $k$ 项需 $k$ 次乘法，总乘法次数 $1+2+\cdots+n=\dfrac{n(n+1)}2$，加法 $n$ 次。复杂度 $O(n^2)$。

**算法二 · 秦九韶法（Horner 格式）**——把多项式改写为

$$p(x)=a_0+x\bigl(a_1+x(a_2+\cdots+x(a_n)\cdots)\bigr),$$

$$\begin{cases}T=a_n,\\ T=xT+a_k & (k=n-1,\ n-2,\ \cdots,\ 1,\ 0),\\ p(x)=T.\end{cases}$$

乘法、加法各 $n$ 次，复杂度 $O(n)$。两种算法内存占用基本相同，算法二的计算复杂性却明显占优。算法二由我国古代数学家**秦九韶**于公元 1247 年在《数书九章》中首次提出（西方 1819 年由 Horner 重新发现，所以英文里叫 Horner 格式）。
:::

实测对照（$n=5000$，随机系数，$x=0.9999$，本教材真实运行数据）：

```python
import time, numpy as np
rng = np.random.default_rng(0)
a = rng.uniform(-1, 1, 5001)          # a[k] 是 x^k 的系数
x = 0.9999

t0 = time.perf_counter()              # 算法一：幂每次从 1 重乘
s = 0.0
for k in range(5001):
    xk = 1.0
    for _ in range(k):
        xk = xk * x
    s += a[k] * xk
t1 = time.perf_counter()

T = 0.0                               # 算法二：秦九韶
for k in range(5000, -1, -1):
    T = T * x + a[k]
t2 = time.perf_counter()

print(f"算法一: {(t1-t0)*1000:.0f} ms   算法二: {(t2-t1)*1000:.2f} ms")
```

```text
算法一: 279 ms   算法二: 0.39 ms
```

约 **700 倍**。理论乘法次数之比 $n(n+1)/2 : n = (n+1)/2 : 1 \approx 2500:1$，实测的 700 倍与它同数量级（常数因子来自 Python 解释器开销）。规模越大差距越大：$O(n^2)$ 与 $O(n)$ 的差别是**结构性**的。

### 设计算法的四条原则

算法通常在计算机上执行，而计算机的字长有限，舍入误差因而不可避免。为了减少舍入误差的影响，设计算法时应遵循以下原则。

#### 原则 (1) 要有数值稳定性，即能控制舍入误差的传播

::: def 定义 1.2.9 · 数值稳定性 {#def-1.2.9}
一个算法称为**数值稳定**（numerically stable）的，如果它能控制舍入误差的传播——误差在算法的逐步执行中不放大（或放大因子有界）。
:::

**原书经典反例：一个递推的正反两个方向。**要在四位十进制的限制下计算积分

$$y_n=\int_0^1\frac{x^n}{x+5}\,dx\qquad(n=0,1,\cdots,100).$$

**建立递推关系（推导）。**由 $x^n+5x^{n-1}=x^{n-1}(x+5)$，分子恰好被分母整除：

$$y_n+5y_{n-1}=\int_0^1\frac{x^n+5x^{n-1}}{x+5}\,dx=\int_0^1 x^{n-1}\,dx=\frac1n\quad(n\ge1),$$

$$y_0=\int_0^1\frac{dx}{x+5}=\ln 6-\ln 5\approx0.1823 .$$

**正向递推（不稳定）：**$y_n=\dfrac1n-5y_{n-1}$。误差分析：设 $y_{n-1}$ 带误差 $\delta_{n-1}$，则算出的 $y_n$ 带误差 $\delta_n=-5\delta_{n-1}$——**每步放大 5 倍**。初值 $y_0=0.1823$ 的舍入误差约 $-2.2\times10^{-5}$（真值 $0.18232156\cdots$），传到 $y_{100}$ 时放大 $5^{100}\approx7.9\times10^{69}$ 倍。数值实验（双精度执行，递推系数是元凶，与字长无关）：

```text
 n        前推值                真值             误差
 0   1.823000e-01      1.823216e-01     -2.2e-05     ← 初值只差 5 位
 4   2.083333e-02      3.430633e-02     -1.3e-02
 6  -3.125000e-01      2.432491e-02     -3.4e-01     ← 已失真
10  -2.105002e+02      1.536755e-02     -2.1e+02
30  -2.007633e+16      5.404633e-03     -2.0e+16     ← 荒谬
```

**先给反向递推找一个起点。**反向递推要从 $y_{100}$ 出发，可它的真值并不知道——好在真值的范围可以估出来。在 $[0,1]$ 上 $5\le x+5\le6$，故 $x^n/6\le x^n/(x+5)\le x^n/5$，积分得

$$\frac{1}{6(n+1)}\lt y_n\lt\frac{1}{5(n+1)} .$$

取 $y_{100}\approx\dfrac12\left(\dfrac{1}{606}+\dfrac{1}{505}\right)\approx0.001815$（两端中点，误差不超过区间宽度之半 $\approx1.7\times10^{-4}$）。

**反向递推（稳定）：**把递推关系反过来，$y_{n-1}=\dfrac{1}{5n}-\dfrac{1}{5}y_n$：

$$\begin{cases}y_{100}\approx0.001815,\\ y_{n-1}=\dfrac{1}{5n}-\dfrac15 y_n\quad(n=100,\ 99,\ \cdots,\ 1).\end{cases}$$

每步误差**缩小为 1/5**：$\lvert\delta_{n-1}\rvert=\lvert\delta_n\rvert/5$。起点误差 $1.7\times10^{-4}$ 传到 $y_0$ 时只剩 $1.7\times10^{-4}/5^{100}$，加上途中新产生的舍入误差（同样每步被 5 压制），实测 $y_0$ 的误差为 $-2.8\times10^{-17}$——机器精度级别。

::: method 为什么系数 $\pm5$ 决定一切
线性递推 $y_n=\alpha_n+\beta y_{n-1}$（$\beta$ 为常数）的误差满足同样的齐次关系 $\delta_n=\beta\,\delta_{n-1}$，故 $\delta_n=\beta^n\delta_0$：$\lvert\beta\rvert\lt1$ 收缩（稳定），$\lvert\beta\rvert\gt1$ 爆炸（不稳定），与递推方向绑定——**一个递推关系，正反两个方向，稳定性可以完全相反**。遇到 $\lvert\beta\rvert\gt1$ 的方向，就倒过来走，用估计式把「远端」的值先定住。[习题 C6](exercises.md) 会让你在 $\displaystyle y_n=\int_0^1\frac{x^n}{1+4x}dx$ 上独立完成一次这个分析（那里的稳定方向恰好是正向）。
:::

#### 原则 (2) 两数相加时，防止较小的数加不到较大的数中

较小数加不到较大数中有时是允许的，但有时会产生严重后果。原书例：在**十位十进制**的限制下求解一元二次方程

$$x^2+10^4x-0.01=0 ,$$

使用求根公式 $x=\dfrac{-b\pm\sqrt{b^2-4ac}}{2a}$。按加法的对阶（alignment）规则：

$$b^2-4ac=10^8+0.04=0.1\times10^9+0.00000000004\times10^9 ,$$

十位字长下 $0.00000000004\times10^9$ 被当做 $0$，故 $b^2-4ac=10^8$，于是解得

$$x_1=0,\qquad x_2=-10^4 .$$

$x_2=-10^4$ 是合理的、可接受的；但 $x_1=0$ 不可接受（真值 $10^{-6}$，误差 100%），后果还很严重：**下游计算只要拿 $x_1$ 作除数就会崩溃**。补救的办法是利用根与系数的关系 $x_1x_2=c/a=-0.01$：

$$x_1=-\frac{0.01}{x_2}=\frac{0.01}{10^4}=10^{-6} .$$

**现代版本：**同样的灾难在 IEEE 双精度里照样发生。方程 $x^2-10^8x+1=0$（两根 $10^{\pm8}$）用 float64 直接套求根公式，小根算得 $x_2=7.45\times10^{-9}$，相对误差 $25.5\%$——病根是判别式开方时 $10^8-\sqrt{10^{16}-4}$ 发生相近数相减；float32 下小根干脆得 $0.0$。改用韦达公式 $x_2=c/(a\,x_1)$ 重算小根，float64 与 float32 都精确得到 $10^{-8}$（相对误差 $0$）。完整实验见 [1.2.7](#sec-1.2.7) 实验二。

#### 原则 (3) 尽量避免两个相近的近似值相减，以免严重损失有效数字

原书例：$x=1.232,\ y=1.231$ 是两个准确值，在四位十进制限制下计算 $z=x^3-y^3$。

**直接算法：**$z=1.232^3-1.231^3\approx1.870-1.865=0.005$。真值 $z=0.004550$，误差 $4.5\times10^{-4}$ 达到结果本身的 $10\%$——最多一位有效数字。原因：$1.870$ 与 $1.865$ 是相近数相减（各自带 $\pm0.0005$ 的舍入，相减后 $0.005$ 中混入了最多 $0.001$ 的误差）。

**稳定算法：**因式分解 $x^3-y^3=(x-y)(x^2+xy+y^2)$，其中 $x-y=0.001$ 是**准确值**：

$$z\approx0.001\times(1.518+1.517+1.515)=0.004550 .$$

新误差只来自三个平方 / 乘积项的舍入（各 $\pm0.0005$）：

$$\varepsilon(z)=0.001\times(0.0005+0.0005+0.0005)=0.0000015\lt0.000005 ,$$

故 $z=0.004550$ 至少有**三位**有效数字——从 1 位到 3 位，代价只是一次代数变形。

::: method 相近数相减的常用改写处方
遇到相近数相减，先照下表把式子换成等价的稳定写法：

| 危险形式 | 稳定改写 | 依据 |
|:--|:--|:--|
| $\sqrt{x}-\sqrt{y}$ | $\dfrac{x-y}{\sqrt{x}+\sqrt{y}}$ | 有理化分子 |
| $1-\cos x$（$x\approx0$） | $\dfrac{x^2}{2}$ 或 $2\sin^2\dfrac x2$ | Taylor / 半角公式 |
| $\tan x-\tan y$ | $\dfrac{\sin(x-y)}{\cos x\cos y}$ | 和差化积 |
| $\ln x-\ln y$ | $\ln\dfrac xy$ | 对数性质 |
| $x^k-y^k$ | $(x-y)(x^{k-1}+\cdots+y^{k-1})$ | 因式分解 |
| $f(x)-f(y)$（一般） | 中值定理：$=f'(\xi)(x-y)$ | 化为导数求值 |

通用思路：**把「大数减小数得小量」改写成「小量直接由小量算出」。**[习题 C3](exercises.md) 用前两个处方处理原书习题 5。
:::

**一个重要的现代澄清（Sterbenz 引理）：**

::: lem 引理 1.2.1（Sterbenz） · 浮点减法本身是精确的 {#lem-1.2.1}
IEEE 浮点算术中，若 $y/2\le x\le2y$（且不溢出），则 $\operatorname{fl}(x-y)=x-y$ **精确成立**——相近数相减在浮点内不产生任何新的舍入误差。

::: proof 证明思路
$x,y$ 都已是浮点数且指数相邻或相同；记 $x=my\cdot2^{e}$ 形式后，$x-y$ 可写成 $x$（或 $y$）的尾数位数的**整数倍**（减法只涉及公共低位之上的有效位），而该倍数所需的位数不超过原尾数长度，故 $x-y$ 恰好落在同一 binade 的浮点网格上，舍入不改变它。完整证明见 Muller 等《Handbook of Floating-Point Arithmetic》[第 4 章](sec11.md#roadmap)。
:::

:::

这条引理带来一个耐人寻味的推论：**相减这一步没有错，丢掉的数字是输入带来的。**$1.870-1.865$ 算出 $0.005$ 完全精确，错在 $1.870$ 本身只剩 4 位有效数字、它第 4 位之后的真值（$1.869959\cdots$）早已被舍掉。所以「避免相近数相减」的实质是：**别把有效数字已经所剩无几的中间结果送去相减**——改写处方的作用，正是让每一步的输入都保留足够的有效数字。

#### 原则 (4) 除法运算中，避免除数的绝对值远小于被除数的绝对值

由

$$\varepsilon\!\left(\frac ab\right)\approx\frac{\lvert a\rvert\,\varepsilon(b)+\lvert b\rvert\,\varepsilon(a)}{\lvert b\rvert^2}\qquad(b\neq0)$$

可知：若 $\lvert b\rvert\ll\lvert a\rvert$，则 $\varepsilon(a/b)$ 可能很大——分母的 $\lvert b\rvert^2$ 是二次放大。而当 $a,b$ 都是准确值时，商本身就很大，其他较小的数又加不进这个商（正是原则 (2) 的场景）。处方有三条：检查量纲与单位（是否该换算）、给分子分母同乘一个尺度因子、或把 $a/b$ 并入后续公式一起化简。

::: method[core] 四条原则速查
1. **稳定性**：递推系数 $\lvert\beta\rvert\gt1$？换个方向走，用估计式定住远端初值。
2. **防大数吃小数**：大小悬殊的两数相加，小数可能整位丢失——先把小数们加在一起，再与大数相加（[习题 C5](exercises.md)：$1340\times10^2+40+50+60+90$）。
3. **防相消**：相近数相减先用处方改写（有理化 / 因式分解 / 和差化积）。
4. **防小除数**：$\lvert b\rvert\ll\lvert a\rvert$ 时 $\varepsilon(a/b)$ 被 $\lvert b\rvert^2$ 放大——换尺度或并式化简。
:::

<a id="sec-1.2.5"></a>

## 1.2.5 机器数与 IEEE 754 浮点（新增）

原则 (1)–(4) 反复提到「字长有限」。现代计算机的字长规则由 **IEEE 754 浮点标准**（1985 年制定，2019 年修订）统一规定。原书成书时，这部分内容还属于「计算机组成原理」；今天，每一个使用 NumPy / MATLAB / C 的计算者都必须直接面对它——本小节把最必要的部分补齐。

::: intuition 直觉 · 浮点数 = 二进制的科学计数法，铺在一张不均匀的网格上
每个浮点数都写成 $\pm m\times2^e$（尾数 $m$ 只有固定 $t$ 位）——就是把「$3.14\times10^2$」那套科学计数法搬进二进制。后果有两条：

1. **大多数实数存不准**：$0.1$ 在二进制里是循环小数，就像 $1/3$ 在十进制里一样，只能存最近的一个网格点。
2. **网格间距不均匀**：$1$ 附近密、$10^{16}$ 附近相邻两数差 2（见下面的实验）。所以「大数吃小数」不是 bug，是网格太稀的必然。

机器精度 $\mathrm{eps}$ 就是「$1$ 附近一步能迈多大」的相对刻度：双精度约 $2.2\times10^{-16}$，即大约 16 位十进制精度。
:::

### 浮点数集与机器精度

把上面这幅图像写严谨，就是浮点数集与机器精度的定义：

::: def 定义 1.2.10 · 浮点数集与机器精度 {#def-1.2.10}
记 $F=F(\beta,t,L,U)$ 为**浮点数集**：形如

$$x=\pm\,m\times\beta^{e},\qquad m=\left(0.b_1b_2\cdots b_t\right)_\beta\ \ (b_1\neq0\ \text{时规格化}),\quad L\le e\le U$$

的数的全体，其中 $\beta$ 为**基**（计算机取 $\beta=2$），$t$ 为尾数位数，$e$ 为指数。$\operatorname{fl}(x)$ 表示把实数 $x$ 舍入到 $F$ 中的结果。**机器精度**定义为

$$\mathrm{eps}=\beta^{1-t},\qquad \text{单位舍入误差}\ u=\tfrac12\beta^{1-t},$$

即：对任何（未溢出的）实数 $x$ 与其最近的浮点数 $\operatorname{fl}(x)$，有

$$\left\lvert\frac{\operatorname{fl}(x)-x}{x}\right\rvert\le u .$$
:::

IEEE 双精度（double，NumPy 的 `float64`）取 $\beta=2,\ t=53$，于是 $\mathrm{eps}=2^{-52}\approx2.22\times10^{-16}$，$u=2^{-53}\approx1.11\times10^{-16}$；11 位指数给出正常数范围约 $[\pm2.2\times10^{-308},\ \pm1.8\times10^{308}]$（次正规数可延伸到约 $10^{-324}$）。IEEE 单精度（`float32`）取 $t=24$，$\mathrm{eps}=2^{-23}\approx1.19\times10^{-7}$——大约 7~8 位十进制有效数字，而双精度对应约 15~16 位（换算：$2^{-52}\approx10^{-15.65}$）。

::: method 浮点算术基本公理
IEEE 754 的每次基本运算都满足

$$\operatorname{fl}(x\ \mathrm{op}\ y)=(x\ \mathrm{op}\ y)(1+\delta),\qquad \lvert\delta\rvert\le u,\quad \mathrm{op}\in\{+,-,\times,\div\}.$$

即：**每一步运算的结果都是「精确结果乘以一个微小因子」**，相对误差不超过 $u$。这条公理是全部现代误差分析的出发点：结合 [1.2.3](#sec-1.2.3) 的相对误差公式，$n$ 次运算的相对误差不超过约 $nu$——这就是「双精度算一万步仍可靠、算一亿步要留神」的定量依据。
:::

### 浮点数在数轴上是怎么分布的

浮点数**不是**均匀铺满数轴的：在 $[2^{k},2^{k+1})$ 这个 binade（相邻二的幂之间的区间）里，相邻浮点数的间距恒为 $2^{k-t}$——**间距随数值变大而成倍变宽**。以 $\beta=2$ 为例：

```python
import numpy as np
print(np.spacing(1.0))      # 1.0 附近的间距 = 2^-52
print(np.spacing(1e16))     # 1e16 附近的间距 = 2.0
print(np.finfo(float).eps)  # 2.220446049250313e-16
print(float(np.float32(0.1)))  # 0.1 存成 float32 再读回
```

```text
2.220446049250313e-16
2.0
2.220446049250313e-16
0.10000000149011612
```

三条直接后果（每条都是一个经典事故来源）：

1. **大数吃小数。**在 $10^{16}$ 附近间距是 $2$：$10^{16}+1$ 会被舍回 $10^{16}$（实测 `1e16 + 1 - 1e16 == 0.0` 为 `True`），而 $10^{16}+2$ 能存活。这正是原则 (2) 的浮点版本。
2. **舍入有极限。**$1.0+2^{-53}$ 舍回 $1.0$（半个 ulp 之下必被吞），$1.0+2^{-52}$ 能分辨。想验证机器精度，一行代码：找最小的 $\delta\gt0$ 使 `1.0 + delta > 1.0`——得到的就是 `eps` 的量级。
3. **十进制的「整」不是二进制的「整」。**$0.1$ 的二进制展开是循环小数 $0.000\overline{1100}\,{}_2$，永远存不准；$0.1+0.2=0.30000000000000004$。而二进制「整」的数（如 $0.5, 0.625$）完全精确。比较浮点数不要用 `==`，用 $\lvert x-y\rvert\le\varepsilon\max(\lvert x\rvert,\lvert y\rvert)$ 或 `math.isclose`。

::: think 思考 · Python 3.12 起 `sum()` 变「聪明」了
在 Python 3.12+ 中内置 `sum` 已内建 Neumaier 补偿，`sum([0.1]*10)` 直接给出 `1.0`；但手写累加循环仍是裸舍入：

```python
s = 0.0
for _ in range(1000):
    s += 0.1
print(repr(s))                       # 99.9999999999986
import math
print(repr(math.fsum([0.1]*1000)))   # 100.0  ← 精确补偿求和
```

千次累加丢掉 $1.4\times10^{-12}$：约 13 位有效数字后开始失守，与 $u\approx10^{-16}$、放大 $\sqrt{n}$~$n$ 倍的理论一致。**读代码时要分清「库的求和」与「裸的求和」**；NumPy 的 `np.sum` 用成对求和（pairwise），精度介于两者之间。完整实验见 [1.2.7](#sec-1.2.7) 实验三。
:::

<a id="sec-1.2.6"></a>

## 1.2.6 向前误差、向后误差与条件数（新增）

原书用「误差限」度量算法的好坏，这叫**向前误差**观点。20 世纪 60 年代 Wilkinson 在处理浮点误差时引入了第二个视角，如今是数值软件界评估算法的标准语言。

::: intuition 直觉 · 两种问法：箭离靶心多远 vs 这箭中了谁家的靶心
想象算法射出一支箭（算出 $\tilde y$），可以问两个完全不同的问题：

- **向前误差**问「箭离**自家**靶心（真值 $y$）多远」——结果准不准；
- **向后误差**问「是否存在一个稍微挪动过的靶子（扰动输入 $\tilde x$），使这支箭恰好正中**它**的靶心」——如果有，箭挪了多远。

向后误差小 = 算法尽职了（它把某个「隔壁问题」解得无比精确）。至于结果离真值还远不远，则要看**问题本身**对这些扰动敏不敏感——这个敏感度就是条件数。「算法好不好」与「问题难不难」由此被干净地分开：这是本小节最重要的思想。
:::

::: def 定义 1.2.11 · 向前误差与向后误差 {#def-1.2.11}
设精确模型为 $y=f(x)$，算法对输入 $x$ 算出 $\tilde y$。

- **向前误差**（forward error）：$f(x)-\tilde y$（或其范数 / 相对形式）——「结果离真值多远」；
- **向后误差**（backward error）：使**精确**模型恰好算出 $\tilde y$ 的最小输入扰动，即满足 $f(\tilde x)=\tilde y$ 的最小的 $\tilde x-x$——「结果是谁家的精确答案」。
:::

向后误差的观点把问题一分为二：**算法只负责「给出某个邻近问题的精确（或近精确）答案」**。若向后误差与机器舍入同量级，称算法**向后稳定**（backward stable）。此时向前误差有多大？答案是：由**问题本身**决定——

$$\frac{\lvert f(x)-\tilde y\rvert}{\lvert f(x)\rvert}\ \lesssim\ \mathrm{cond}(f,x)\cdot\frac{\lvert\tilde x-x\rvert}{\lvert x\rvert},\qquad
\mathrm{cond}(f,x)=\left\lvert\frac{x\,f'(x)}{f(x)}\right\rvert ,$$

其中 $\mathrm{cond}(f,x)$ 称为问题在 $x$ 处的**条件数**（condition number）——[1.2.3](#sec-1.2.3) 的放大因子 $\lvert f'(a)\rvert$ 换成相对误差语言后的版本（推导：$\varepsilon_{\mathrm r}(u)\approx\lvert f'(a)\rvert\,\varepsilon(a)/\lvert f(a)\rvert=\dfrac{\lvert a f'(a)\rvert}{\lvert f(a)\rvert}\cdot\varepsilon_{\mathrm r}(a)$）。

::: method conditioning 与 stability 必须分开谈
把两个属性交叉起来，四种情形该怎么办一目了然：

| | 问题良态（cond 小） | 问题病态（cond 大） |
|:--|:--|:--|
| **算法稳定**（向后误差小） | 向前误差小：万事大吉 | 向前误差仍大：**换提法（重述问题）** |
| **算法不稳定** | 向前误差可能变大：**换算法** | 无药可救：重述问题 + 换算法 |

**病态是问题的属性，不稳定是算法的属性**，二者独立。一个病态问题（如求二重根，一阶条件数无界）用任何算法都难以得到远好于 $O(\sqrt{u})$ 的相对精度；一个良态问题（如 $\sqrt x$，cond $=1/2$ 恒成立）配不上稳定算法才是工程师的失职。
:::

**例（求根公式：良态问题遇上不稳定算法）。**原则 (2) 中 float64 直接公式算出的小根 $x_2=7.45\times10^{-9}$，按上表诊断：**问题本身是良态的**——小根 $x_2\approx c/b$，它对系数 $b,c$ 的相对条件数都 $\approx1$；可实测向前误差高达 25.5%，远超 $\mathrm{cond}\times u\approx10^{-16}$，说明误差全部来自**算法**——判别式开方中的相近数相减把 $O(u)$ 的舍入误差放大成了 $O(1)$。再向后看一步：要让 $7.45\times10^{-9}$ 成为某个邻方程的精确根，得把 $c$ 从 1 扰动到约 0.745（相对 25%）——直接公式对这个任务**不是**向后稳定的（向后误差同样被减法放大）。

韦达公式 $x_2=c/(a\,x_1)$ 治好它的方式是**换算法**：先算相对良态的大根，再用乘除法（相对误差限相加、不放大）得到小根，每一步向后误差都回到 $O(u)$ 量级。矩阵版本的条件数 $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$ 与线性方程组 $\lVert\delta\boldsymbol x\rVert/\lVert\boldsymbol x\rVert\le\mathrm{cond}(A)\,\lVert\delta\boldsymbol b\rVert/\lVert\boldsymbol b\rVert$ 的完整推导见 [1.3.6](sec13.md#sec-1.3.6) 与第二、三章。

<a id="sec-1.2.7"></a>

## 1.2.7 数值实验：亲手看见误差（新增）

三个实验对应原书三大主题，代码可直接复制运行（Python 3；实验一的真值对照用 `scipy.integrate.quad`，未装 scipy 时可删去 `exact()`，改用实验自身的反向递推值作对照；其余只需 `numpy` / `math` / `decimal`）。教材中展示的输出都是真实运行结果。

### 实验一 · 递推误差的传播与方向

**目的：**复现 1.2.4 原则 (1) 的正反递推，实测误差放大 / 缩小因子。

```python
import math
from scipy import integrate

def exact(n):  # 真值（自适应求积）
    return integrate.quad(lambda x: x**n / (x + 5), 0, 1)[0]

# 正向：初值取 4 位有效数字 0.1823（真值 0.18232155679...）
y, fwd = 0.1823, {0: 0.1823}
for n in range(1, 31):
    y = 1.0/n - 5.0*y
    fwd[n] = y

# 反向：从 y100 的估计区间中点出发
y = 0.5*(1/(6*101) + 1/(5*101))
bwd = {100: y}
for n in range(100, 0, -1):
    y = 1.0/(5*n) - y/5.0
    bwd[n-1] = y

for n in [0, 5, 10, 30, 100]:
    print(n, f"fwd 误差 {fwd.get(n, float('nan')) - exact(n):+.3e}"
             f"  bwd 误差 {bwd.get(n, float('nan')) - exact(n):+.3e}")
```

**预期结果（本教材实测）：**$n=10$ 时正向误差 $-2.1\times10^{2}$、反向误差 $\approx-1.7\times10^{-18}$；$n=30$ 正向误差 $-2.0\times10^{16}$，反向在整个 $[0,100]$ 保持 $\le10^{-17}$。**报告要求：**打印相邻两步误差之比 $\delta_n/\delta_{n-1}$，验证正向恒为 $-5$、反向恒为 $-1/5$；把系数 5 换成 2 再观察。

### 实验二 · 灾难性抵消：求根公式与方差

**目的：**量化原则 (2)(3) 的危害，验证「换提法」的疗效。

```python
import math, numpy as np

# (a) 求根公式：x^2 - 1e8 x + 1 = 0（真根 1e8 与 1e-8）
a, b, c = 1.0, -1e8, 1.0
disc = b*b - 4*a*c
x1 = (-b + math.sqrt(disc)) / (2*a)
x2 = (-b - math.sqrt(disc)) / (2*a)
x2v = c / (a*x1)                      # 韦达：用良态的大根算小根
print(repr(disc), repr(x2), abs(x2-1e-8)/1e-8, x2v)

# (b) 方差：数据 1e9+1 .. 1e9+8（真值 5.25）
data = np.array([1e9 + i for i in range(1, 9)])
n = len(data)
m = data.mean()
print((data**2).sum()/n - m*m)        # 两遍法：Σx²/n − x̄²
print(((data - m)**2).mean())         # 中心化
shifted = data - 1e9                  # 平移：先减掉共同的大数
print(((shifted - shifted.mean())**2).mean())
```

**预期结果（实测）：**(a) 判别式 $10^{16}-4$ 存成 $9999999999999996.0$，直接小根 $7.450580596923828\times10^{-9}$（相对误差 $0.255$），韦达小根 $1\times10^{-8}$（误差 $0$）。(b) 两遍法输出 **0.0**（$8.000000072\times10^{18}$ 与 $n\bar x^2$ 相减完全抵消），中心化与平移法都得 $5.25$。**报告要求：**改用 float32 重复 (a)，确认小根变 $0.0$；对 (b) 解释为什么两遍法里「两遍」本身没有错，错在 $\Sigma x^2$ 那一步（提示：$\Sigma x^2\approx8\times10^{18}$ 的绝对舍入误差已达个位数量级）。

### 实验三 · 求和次序、补偿求和与秦九韶

**目的：**用一台「四位十进制截断机」（`decimal` 模拟）复现原则 (2) 的课堂演示；实测裸累加 vs 补偿求和；复现秦九韶计时。

```python
from decimal import Decimal, localcontext, ROUND_DOWN
import math, time

# (a) 四位十进制截断机：1340*10^2 + 40 + 50 + 60 + 90（真值 134240）
with localcontext() as ctx:
    ctx.prec, ctx.rounding = 4, ROUND_DOWN
    D = Decimal
    u = D(1340) * D(10)**2
    for v in (40, 50, 60, 90):
        u = u + D(v)
    print("原序   ", u)                              # 1.340E+5  误差 -240
    print("先小后大", D(1340)*D(10)**2 + (D(40)+D(50)+D(60)+D(90)))  # 1.342E+5 误差 -40

# (b) 裸累加 vs fsum
s = 0.0
for _ in range(1000):
    s += 0.1
print(repr(s), repr(math.fsum([0.1]*1000)))   # 99.9999999999986 100.0

# (c) 秦九韶计时（n=5000）
import numpy as np
a = np.random.default_rng(0).uniform(-1, 1, 5001); x = 0.9999
t0 = time.perf_counter()
s = 0.0
for k in range(5001):
    xk = 1.0
    for _ in range(k): xk = xk*x
    s += a[k]*xk
t1 = time.perf_counter()
T = 0.0
for k in range(5000, -1, -1): T = T*x + a[k]
t2 = time.perf_counter()
print(f"{(t1-t0)*1e3:.0f} ms vs {(t2-t1)*1e3:.2f} ms")
```

**预期结果（实测）：**(a) 原序四个加数全部丢失（累加器纹丝不动地停在 $1.340\times10^5$，误差 $-240$），先小后大误差 $-40$；(b) 裸累加 $99.9999999999986$，`fsum` 精确 $100.0$；(c) 算法一 $279$ ms vs 算法二 $0.39$ ms（约 700 倍；你的机器上倍数会不同，量级不会）。**报告要求：**把 (a) 的 `ROUND_DOWN` 改为 `ROUND_HALF_EVEN`（四舍五入）重跑，观察哪些加数「部分存活」，解释差异（提示：60、90 超过累加器末位半单位）。

<a id="sec-1.2.8"></a>

## 1.2.8 小结与常见错误

::: method[core] 本节公式速查
把前面用到的公式收在一处，方便查阅：

| 概念 | 公式 |
|:--|:--|
| 误差 / 误差限 | $e=x-a$；$\lvert e\rvert\le\varepsilon$；$x=a\pm\varepsilon$ |
| 相对误差限 | $\varepsilon_{\mathrm r}=\varepsilon(a)/\lvert a\rvert$ |
| 有效数字 | $a=\pm0.a_1\cdots a_k\times10^m$，$\varepsilon(a)=\tfrac12\times10^{m-n}$（$n\le k$）⟹ $n$ 位 |
| 有效数字 → 相对误差 | $\varepsilon_{\mathrm r}\le\frac{1}{2a_1}\times10^{1-n}\le\frac12\times10^{1-n}$ |
| 函数求值 | $\varepsilon(u)\approx\lvert f'(a)\rvert\varepsilon(a)$；多元逐项求和（式 1.1） |
| 四则运算 | $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$；乘除相对误差限相加；减法分母 $\lvert a-b\rvert$ |
| 递推误差 | $\delta_n=\beta\,\delta_{n-1}$：$\lvert\beta\rvert\gt1$ 不稳定，$\lvert\beta\rvert\lt1$ 稳定 |
| 浮点公理 | $\operatorname{fl}(x\ \mathrm{op}\ y)=(x\ \mathrm{op}\ y)(1+\delta)$，$\lvert\delta\rvert\le u$ |
| 条件数（函数版） | $\mathrm{cond}(f,x)=\lvert xf'(x)/f(x)\rvert$：病态是问题的属性 |

:::

::: think[core] 常见错误清单 · 自查八条
1. **把有效数字当小数位数。**$3.1416$ 对 $\pi$ 是 5 位有效数字、4 位小数（见[@ex-1.2.4]）。
2. **相对误差限分母用 $x$。**$x$ 未知，实用公式分母是 $\lvert a\rvert$；只在误差分析的理论推导中才允许用 $x$（二者差 $O(e_{\mathrm r}^2)$）。
3. **把 $\varepsilon(ab)\approx\lvert a\rvert\varepsilon(b)+\lvert b\rvert\varepsilon(a)$ 当恒等式。**它是 Taylor 一阶近似，误差 $O(\varepsilon^2)$；精确的带符号关系见 1.2.3 思考题。
4. **相近数相减后还想保住有效数字。**先改写（有理化 / 因式分解 / 和差化积），再计算；记住 Sterbenz 引理——丢的数字在减法之前就没了。
5. **用递推不查系数。**递推系数 $\lvert\beta\rvert\gt1$ 的方向必须倒过来走，并用估计式定住远端初值。
6. **两遍法方差公式直接上机。**数据有大共同偏移时先平移（或用 Welford 单遍法）。
7. **浮点数用 `==` 比较、相信打印出的每一位。**打印 17 位不等于 17 位都可靠；可靠位数由误差限决定（[目标 A1.2](../preface-objectives.md)）。
8. **以为换 float64 万事大吉。**六公式算 $(\sqrt2-1)^6$ 的五个数量级差距与字长无关——先选对公式，再谈精度。
:::

::: note 课堂对照（2026 秋·庞刚）
本节内容在课堂上的讲法见[第 1 讲精编](../lectures/lec01.md)（误差四分类、误差限运算 + $\int_0^1 e^{-x^2}dx$ 级数积分、$\int_5^{\infty}e^{-x^2}dx$ 渐近展开、递推 $I_n=\frac1n-5I_{n-1}$ 稳定性、大数吃小数四个板书例题）与[第 2 讲精编](../lectures/lec02.md)（有效数字判定与相加例题、$x^2+10^4x-0.01=0$ 用韦达定理保小根——即本节原则 (2)(3) 的课堂版）。老师课后布置的实验与 1.2.7 的实验一、实验三一致。
:::
