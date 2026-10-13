# 附录 B · 浮点算术的进一步推导

[1.2.5](../ch01/sec12.md#sec-1.2.5) 给出了浮点数集、机器精度与「每步运算 $= $ 精确结果 $\times(1+\delta)$」的基本公理。本附录把公理**推导**出来（它不是假设，而是 IEEE 舍入规则的推论），再给出四组常用工具的完整分析：Sterbenz 引理、求和误差界、Kahan 补偿求和、以及两个经典现象（$0.1+0.2\neq0.3$、两遍法方差失效）的逐位复算。

<a id="app-b-1"></a>

## B.1 舍入公理的推导：为什么 $\operatorname{fl}(x\ \mathrm{op}\ y)=(x\ \mathrm{op}\ y)(1+\delta)$

**（一）数的舍入。**设 $\beta=2$、尾数 $t$ 位（双精度 $t=53$）。规格化浮点数在 binade $[2^e,\ 2^{e+1})$ 内等距分布，间距

$$\operatorname{ulp}(x)=2^{\,e+1-t}\qquad(x\in[2^e,2^{e+1})) .$$

设实数 $x$（不溢出）落在该 binade 内。IEEE 754 规定**舍入到最近**（round to nearest, ties to even）：$\operatorname{fl}(x)$ 取距 $x$ 最近的浮点数，故

$$\lvert\operatorname{fl}(x)-x\rvert\ \le\ \tfrac12\operatorname{ulp}(x)=2^{\,e-t},\qquad
\left\lvert\frac{\operatorname{fl}(x)-x}{x}\right\rvert\ \le\ \frac{2^{\,e-t}}{x}\ \le\ \frac{2^{\,e-t}}{2^{\,e}}=2^{-t}=u .$$

（次正规区间内间距只会更细，同一结论保持。）

**（二）运算的舍入。**IEEE 754 对 $+,-,\times,\div,\sqrt{\ }$ 的规定是：**先把运算按实数精确算出，再把结果舍入一次**（correct rounding——「先算准、再存近」）。设 $z=x\ \mathrm{op}\ y$ 为精确结果（不溢出），则由（一）：

$$\operatorname{fl}(x\ \mathrm{op}\ y)=z(1+\delta),\qquad\lvert\delta\rvert\le u .$$

这就是 [1.2.5](../ch01/sec12.md#sec-1.2.5) 的基本公理——**每一步运算的相对误差不超过 $u$，且只有一次舍入**。「只有一次」是关键：它排除了老式硬件「先舍入操作数、再算、又舍入」的双重误差（历史上的 x87 80 位扩展寄存器造成的跨平台不可复现，正是因为不同平台「何时舍入到 64 位」不一致）。

**（三）哪些运算享受这待遇。**$+,-,\times,\div,\sqrt{\ }$ 由标准强制；$\sin,\exp,\ln$ 等**超越函数不强制**正确舍入（正确舍入超越函数至今是研究课题），所以不同数学库的 `sin(x)` 可以在最后一位上合法地不同。比较浮点相等时容差 $\sim u$ 而非 $0$，理由就在这里。

<a id="app-b-2"></a>

## B.2 $\mathrm{eps}$ 与 $u$：一对容易混淆的常数

[定义 1.2.10](../ch01/sec12.md#def-1.2.10) 同时给了 $\mathrm{eps}=\beta^{1-t}$ 与 $u=\tfrac12\beta^{1-t}$，关系与来历如下：

| 量 | 值（$\beta=2,t=53$） | 含义 |
|:--|:--:|:--|
| $\mathrm{eps}$ | $2^{-52}\approx2.22\times10^{-16}$ | $1.0$ 与下一个浮点数的**间距**（`np.spacing(1.0)`、`np.finfo(float).eps`） |
| $u$ | $2^{-53}\approx1.11\times10^{-16}$ | 舍入的最大**相对误差**（单位舍入误差） |

一句话：**间距是 $\mathrm{eps}=2u$，误差是 $u$**——「网格上相邻两点的距离」是「落点误差」的两倍。正文「$1.0+2^{-53}$ 舍回 $1.0$、$1.0+2^{-52}$ 能分辨」的实验正是这两个常数的对照：$2^{-53}$ 恰是 $1$ 与间距中点的**平局位置**，平局判偶（mantissa 为偶者胜）落回 $1.0$；要「明确跨过一格」就得给满 $\mathrm{eps}=2u$。

顺带一个常用公式（`ulp` 的显式版本）：对 $x\neq0$，

$$\operatorname{ulp}(x)=2^{\,\lfloor\log_2\lvert x\rvert\rfloor+1-t}\qquad(\text{次正规区间内取最小间距}\ 2^{\,e_{\min}-t+1}).$$

<a id="app-b-3"></a>

## B.3 Sterbenz 引理：完整证明（[引理 1.2.1](../ch01/sec12.md#lem-1.2.1)）

::: lem 引理 B.3 · Sterbenz：浮点减法的精确性
$x,y$ 为同号规格化浮点数，$y/2\le x\le 2y$，且不溢出，则 $\operatorname{fl}(x-y)=x-y$ **精确成立**。

::: proof 证明
同号不妨设 $x\ge y\gt0$（另一情形交换即可；下界 $y/2$ 保证 $x$ 不会比 $y$ 大到离谱——本题设 $y\le x\le2y$）。把浮点数写成「整数尾数 × 二的幂」：$y=m\,2^{E}$、$x=n\,2^{F}$，整数 $m,n\in[2^{t-1},\ 2^{t})$。由 $y\le x\le2y$：

$$2^{E+t-1}\le m\,2^E\le n\,2^F\le 2m\,2^E\lt2^{E+t+1}\ \Longrightarrow\ x\in[2^{E+t-1},\ 2^{E+t+1})\ \Longrightarrow\ F\in\{E,\ E+1\}.$$

于是 **$x$ 与 $y$ 都是 $2^{E}$ 的整数倍**（$F\ge E$ 时 $2^E\mid2^F\mid x$）。记 $d=x-y\ge0$：它是 $2^E$ 的整数倍，且

$$0\ \le\ d\ \le\ 2y-y=y\ \lt\ 2^{t}\,2^{E}\ \Longrightarrow\ d=k\,2^{E},\qquad 0\le k\le2^{t}-1 .$$

$k$ 不超过 $t$ 个二进制位，故 $d$ 可被 $t$ 位尾数精确表示：若 $k\ge2^{t-1}$，$d$ 本身就是规格化数；若 $1\le k\lt2^{t-1}$，把 $k$ 的前导零剥掉、指数相应下移（每下移一位，要求的尾数位减一位，$k\lt2^{t-1}$ 保证剥得动）；$k=0$ 即 $d=0$。次正规区间（渐进下溢）内网格只会更细（间距固定为 $2^{e_{\min}-t+1}$），同一论证依然成立。舍入一个**本来就在网格上**的数当然不变：$\operatorname{fl}(x-y)=x-y$。
:::
:::

::: cor 推论 B.3.1 · 相消的完整账目
相近数相减时，减法本身零误差（本引理），结果的误差**全部来自两个操作数在减法之前携带的误差**：设 $x,y$ 各带相对误差 $\le u$，则 $x-y$ 的相对误差可达 $\dfrac{(\lvert x\rvert+\lvert y\rvert)u}{\lvert x-y\rvert}\approx\dfrac{2\lvert x\rvert}{\lvert x-y\rvert}u$——分母越小放大越多。「避免相近数相减」原则的定量形式就是这一条。
:::

<a id="app-b-4"></a>

## B.4 递归求和的误差界：$\lvert$误差$\rvert\le\gamma_{n-1}\sum\lvert x_i\rvert$

**记号。**$\gamma_k:=\dfrac{ku}{1-ku}$（$ku\lt1$；近似为 $ku$）。

::: lem 引理 B.4.1 · 乘积引理
若 $\lvert\delta_j\rvert\le u$，则 $\prod_{j=1}^{k}(1+\delta_j)=1+\theta$，$\lvert\theta\rvert\le\gamma_k$。

::: proof 证明（归纳）
$k=1$：$\lvert\theta\rvert=\lvert\delta_1\rvert\le u\le\gamma_1$。设对 $k-1$ 成立：$\prod_{j=1}^{k}(1+\delta_j)=(1+\theta')(1+\delta_k)$，$\lvert\theta'\rvert\le\gamma_{k-1}$，则 $1+\theta=1+\theta'+\delta_k+\theta'\delta_k$，

$$\lvert\theta\rvert\le\gamma_{k-1}+u+u\gamma_{k-1}=\gamma_{k-1}+u(1+\gamma_{k-1}).$$

而直接展开 $\gamma_k-\gamma_{k-1}=\dfrac{u}{(1-ku)(1-(k-1)u)}=u(1+\gamma_k)(1+\gamma_{k-1})\ge u(1+\gamma_{k-1})$，故 $\lvert\theta\rvert\le\gamma_k$。
:::
:::

::: thm 定理 B.4.2 · 递归求和的误差界
$\hat S_n=\operatorname{fl}(\cdots\operatorname{fl}(\operatorname{fl}(x_1+x_2)+x_3)\cdots+x_n)$ 满足

$$\hat S_n=\sum_{i=1}^{n}x_i(1+\theta_i),\qquad\lvert\theta_i\rvert\le\gamma_{n-1}\qquad\Longrightarrow\qquad
\Bigl\lvert\hat S_n-\sum_ix_i\Bigr\rvert\le\gamma_{n-1}\sum_i\lvert x_i\rvert .$$

::: proof 证明
$\hat S_k=(\hat S_{k-1}+x_k)(1+\delta_k)$（$\lvert\delta_k\rvert\le u$）。对 $k$ 归纳断言 $\hat S_k=\sum_{i\le k}x_i\prod_{j=\max(i,2)}^{k}(1+\delta_j)$：代入递推式即得（新的 $x_k$ 从第 $k$ 步起、旧的 $x_i$ 各多乘一个 $(1+\delta_k)$）。每个 $x_i$ 至多被 $n-1$ 个 $(1+\delta_j)$ 因子修饰，用引理 B.4.1 得 $\lvert\theta_i\rvert\le\gamma_{n-1}$。
:::
:::

**三点读法。**

1. **界由 $\sum\lvert x_i\rvert$ 控制，不是 $\lvert\sum x_i\rvert$**：同号数据两者接近，界好用；正负相消（和远小于各项之和）时界可以远大于结果本身——这是「先小后大」「成对求和」之外，**改写公式**（如 Welford）的动机。
2. **成对求和**把求和树深度降为 $\lceil\log_2n\rceil$，每个 $x_i$ 只经过 $\lceil\log_2n\rceil$ 次舍入，同样的论证给出 $\lvert$误差$\rvert\le\gamma_{\lceil\log_2n\rvert}\sum\lvert x_i\rvert$——$n=10^8$ 时从 $\gamma_n\approx10^{-8}$ 降到 $\gamma_{27}\approx3\times10^{-15}$。`np.sum` 内置此策略，NumPy 手写循环之差由此而来。
3. **随机符号**下误差的**典型**大小是 $O(u\sqrt n\,)$（舍入项近似随机行走），$\gamma_n$ 是最坏情形。设计系统按最坏情形，解释实验按典型情形。

<a id="app-b-5"></a>

## B.5 Kahan 补偿求和：机制推导与逐位实例

**算法。**

```text
s = x[0];  c = 0
for i = 1..n-1:
    y  = x[i] - c          # 把上一轮丢失的低位补回来
    t  = s + y             # 高位累加（可能丢失低位）
    c  = (t - s) - y       # 记录本轮真正丢失的部分（Sterbenz：这步减法精确）
    s  = t
返回 s
```

**机制。**$t=s+y$ 舍入时，丢失的恰是 $y$ 中「低于当前累加器网格」的部分；由 Sterbenz 引理（B.3），$c=(t-s)-y$ **精确地**等于这个丢失量（注意 $t-s$ 与 $y$ 是相近数，减法零误差）。下一轮的 $y'=x_{i+1}-c$ 先把补偿还回去——**误差不许累积，当场记账、下轮还清**。严格误差界为 $\lvert$总误差$\rvert\le2u\sum\lvert x_i\rvert+O(nu^2)$（Goldberg 1991，证明较长，从略；要点是 $c$ 的记账残余以 $u^2$ 速度二阶累积）。

**逐位实例（四位十进制，加十个 $1.000$ 到 $1.000\times10^{4}$）。**真值 $10010$；四位十进制在 $[10000,10000)$ 邻域的网格是 $\{10000,10010,10020,\dots\}$——**间距是 $10$**。

- **裸累加**：$10000+1$ 舍回 $10000$，加十次，结果 $10000$（误差 $-10$，零头全军覆没）。
- **Kahan**（逐步跟踪 $s,c$）：

| 步 | $y=x-c$ | $t=s+y$（舍入后） | $c=(t-s)-y$ | $s$ |
|:--:|:--:|:--:|:--:|:--:|
| 1 | $1-0=1$ | $10001\to10000$ | $0-1=-1$ | $10000$ |
| 2 | $1-(-1)=2$ | $10002\to10000$ | $-2$ | $10000$ |
| 5 | $1-(-4)=5$ | $10005\to10000$（平局判偶） | $-5$ | $10000$ |
| 6 | $1-(-5)=6$ | $10006\to10010$（跨格！） | $10-6=+4$ | $10010$ |
| 7 | $1-4=-3$ | $10007\to10010$ | $0-(-3)=3$ | $10010$ |
| 9 | $1-2=-1$ | $10009\to10010$ | $1$ | $10010$ |
| 10 | $1-1=0$ | $10010$ | $0$ | $10010$ |

前五步零头被「记账欠着」，第六步攒够一格一次跨过（$c$ 转为 $+4$ 表示**多进了**，随后逐步还账），第十步账面清零——**返回 $10010$，精确**。注意第 6 步的「先过头、再还账」：补偿求和允许中途反向修正，这正是它比「先小后大」这类纯排序技巧更强的地方（后者只是降低概率，前者给出保证）。

**变体与现状。**Neumaier 变体（用 $\lvert s\rvert$ 与 $\lvert y\rvert$ 择大补偿）在累加器量级突变时更稳；Python 3.12+ 的内置 `sum` 内建 Neumaier 补偿、`math.fsum` 给出精确舍入的和——正文 [1.2.5](../ch01/sec12.md#sec-1.2.5) 思考题的实验差异全部由此解释。

<a id="app-b-6"></a>

## B.6 $0.1+0.2=0.30000000000000004$：完整逐位复算（含平局判决）

**（一）$0.1$ 的二进制展开是循环小数。**$(0.\overline{0011})_2=\dfrac{3}{2^4-1}=\dfrac15$，故

$$0.1=(0.0\overline{0011})_2=0.000110011001100110011\cdots$$

——正如 $1/3$ 在十进制里写不完，$1/10$ 在二进制里也写不完；**存进去的那一刻就已失真**。

**（二）双精度里到底存了什么。**尾数 $53$ 位。$0.1\times2^{55}=3602879701896396.8$，舍入到最近整数：

$$\operatorname{fl}(0.1)=3602879701896397\times2^{-55}=0.1000000000000000055511151231257827\cdots$$

$0.2$ 是它精确的两倍（乘 $2$ 只动指数）：$\operatorname{fl}(0.2)=7205759403792794\times2^{-55}$。

**（三）相加恰好处在正中央。**精确和为

$$3602879701896397\times2^{-55}+7205759403792794\times2^{-55}=10808639105689191\times2^{-55}=\mathbf{5404319552844595.5}\times2^{-54},$$

而 $[0.25,0.5)$ binade 的网格间距是 $2^{-54}$——**精确和恰好在两个相邻浮点数的正中央**：

$$\underbrace{5404319552844595\times2^{-54}}_{=0.2999999999999999888\cdots}\quad\lt\ 0.3000000000000000166533\cdots\ \lt\quad\underbrace{5404319552844596\times2^{-54}}_{=0.3000000000000000444\cdots}$$

到两端的距离相等（都是 $2^{-55}$）。**平局，触发 round-half-to-even**：两个候选的尾数整数分别为 $5404319552844595$（奇）与 $5404319552844596$（偶），判偶规则选择后者：

$$0.1+0.2=0.30000000000000004440892098500626\cdots\ \Longrightarrow\ \texttt{0.1 + 0.2 == 0.3}\ \text{为 False}.$$

顺带：$\operatorname{fl}(0.3)=5404319552844595\times2^{-54}=0.29999999999999998889\cdots$——即使用户写 `0.3`，存的也不是「数学的 $0.3$」。「浮点数没有十进制与二进制的整数解，只有网格」这一事实，是比较浮点数必须用容差的根本原因（[1.2.5](../ch01/sec12.md#sec-1.2.5) 三条后果之第三条的逐位版）。

<a id="app-b-7"></a>

## B.7 两遍法方差的失效阈值，与 Welford 单遍法（[1.2.7](../ch01/sec12.md#sec-1.2.7) 实验二 (b) 的定量解释）

**（一）失效何时发生。**两遍法 $s^2=\dfrac1n\sum x_i^2-\bar x^2$ 在浮点下的问题结构是「两个大数相减得小量」（[1.2.4](../ch01/sec12.md#sec-1.2.4) 原则 (3) 的完美标本）：$\sum x_i^2\approx n(\bar x^2+s^2)$ 的绝对舍入误差约 $u\cdot n\bar x^2$（B.4 的界乘上主项量级），减法本身精确（Sterbenz），误差原样进入 $s^2$：

$$\frac{\lvert\text{误差}\rvert}{s^2}\ \approx\ \frac{u\,n\,\bar x^{2}}{n\,s^{2}}=u\,\frac{\bar x^{2}}{s^{2}}\qquad\Longrightarrow\qquad
\textbf{失效阈值：}\ \frac{\lvert\bar x\rvert}{s}\ \gtrsim\ \frac{1}{\sqrt{u}}\approx10^{8}.$$

正文实验的数据 $10^9+1,\dots,10^9+8$：$\bar x\approx10^9$、$s\approx\sqrt{5.25}\approx2.29$，比值 $\approx4.4\times10^{8}\gtrsim10^{8}$——阈值已过，实测输出恰为 $0.0$（$8\times10^{18}$ 量级的平方和，其舍入误差 $\sim10^{2}$，把 $5.25\times8=42$ 的真实散布完全淹没）。「数据加一个大偏移」与「数据乘一个大数」不同：**后者是良性的**（相对误差不变），**前者是致命的**（绝对误差不变而真实信号被平移压小）。

**（二）Welford 单遍法的递推及其推导。**维护 $(\mu_k,\ M_k)$（前 $k$ 个数的均值与离差平方和）：

$$\mu_k=\mu_{k-1}+\frac{x_k-\mu_{k-1}}{k},\qquad
M_k=M_{k-1}+(x_k-\mu_{k-1})(x_k-\mu_k),\qquad s_k^2=\frac{M_k}{k-1}.$$

**推导。**离差的平移不变性（$\mu_k=\mu_{k-1}+(x_k-\mu_{k-1})/k$）：$x_i-\mu_k=(x_i-\mu_{k-1})-\frac{x_k-\mu_{k-1}}{k}$，于是

$$M_k=\sum_{i\le k}(x_i-\mu_k)^2=\sum_{i\le k}(x_i-\mu_{k-1})^2-k(\mu_k-\mu_{k-1})^2=M_{k-1}+(x_k-\mu_{k-1})^2-\frac{(x_k-\mu_{k-1})^2}{k},$$

最后一步对 $i=k$ 单独拆出、其余项的和即 $M_{k-1}$（前 $k-1$ 个数对旧均值的离差平方和）。合并系数并注意 $x_k-\mu_k=(x_k-\mu_{k-1})\frac{k-1}{k}$，得 $M_k=M_{k-1}+(x_k-\mu_{k-1})(x_k-\mu_k)$。∎

**为什么稳。**每步相减的两个量 $(x_k-\mu_{k-1})$ 与增量本身同量级——**大偏移 $\bar x$ 从未进入运算**，$10^9$ 的共同部分在第 $k$ 步就被减掉了。这与「平移后再算方差」的先见之明等价，但不需要预先知道偏移，也不需要两遍扫数据（流式数据、单遍 $O(1)$ 内存）。

::: note 本附录与正文的对应
B.1–B.2 对应 [1.2.5 浮点数集与机器精度](../ch01/sec12.md#sec-1.2.5)；B.3 对应 [引理 1.2.1](../ch01/sec12.md#lem-1.2.1)（正文为证明思路）；B.4–B.5 对应 [1.2.5 思考题](../ch01/sec12.md#sec-1.2.5)（`sum` vs `fsum`）；B.6 对应 1.2.5 三条后果之第三条；B.7 对应 [实验二](../ch01/sec12.md#sec-1.2.7) (b) 的「报告要求」。系统论述见 Goldberg《What Every Computer Scientist Should Know about Floating-Point Arithmetic》与 Higham《Accuracy and Stability of Numerical Algorithms》Chapter 4。
:::
