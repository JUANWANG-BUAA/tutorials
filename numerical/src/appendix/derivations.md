# 附录 A · 补充推导

本附录按章收录正文中需要较长篇幅的补充推导。每条标题括注正文出处，正文对应位置也有反向链接；附录编号 A.1、A.2……自成一体，不与正文的节级编号混用。本附录只用到两个外部结果：**Birkhoff 定理**（A.2.3 给出证明）与**矩阵的 Jordan 标准形**（A.2.7 引用）。

<a id="app-a-1"></a>

## A.1 第一章

<a id="app-a-1-1"></a>

### A.1.1 六个等价公式的误差放大因子（[1.1.3](../ch01/sec11.md#sec-1.1.3) 的定量复现）

设 $t=\sqrt2$，$a=1.4$，则输入误差 $e=t-a\approx0.0142136$，相对误差 $\varepsilon=e/t\approx1.005\%$。六个公式只在指定输入 $t=\sqrt2$ 处取相同值，并非关于任意 $t$ 的恒等式。相等的依据是三条代数事实：

$$(\sqrt2+1)(\sqrt2-1)=1,\qquad(\sqrt2-1)^2=3-2\sqrt2,\qquad(\sqrt2-1)^6=99-70\sqrt2 .$$

由 [1.2.3](../ch01/sec12.md#sec-1.2.3) 的传播公式：输出绝对误差 $\approx\lvert f'(t)\rvert e$，输出相对误差 $\approx\kappa\cdot\varepsilon$，其中相对条件数（[1.2.6](../ch01/sec12.md#sec-1.2.6)）

$$\kappa=\left\lvert\frac{t\,f'(t)}{f(t)}\right\rvert .$$

逐个公式算出 $f'(t)$ 与 $\kappa$（$f(t)=(\sqrt2-1)^6=0.0050506$）：

| 公式 | $\lvert f'(t)\rvert$ | $\kappa$ | 预测绝对误差 $\lvert f'\rvert e$ | 实测（[1.1.3](../ch01/sec11.md#sec-1.1.3) 表） | 预测相对误差 |
|:--|:--:|:--:|:--:|:--:|:--:|
| $(t-1)^6$ | $6(t-1)^5=0.07316$ | $\dfrac{6t}{t-1}\approx20.5$ | $1.04\times10^{-3}$ | $9.5\times10^{-4}$ | $20.6\%$ |
| $(3-2t)^3$ | $6(3-2t)^2=0.17662$ | $\dfrac{6t}{3-2t}\approx49.5$ | $2.51\times10^{-3}$ | $2.9\times10^{-3}$ | $49.7\%$ |
| $99-70t$ | $70$ | $\dfrac{70t}{99-70t}\approx1.96\times10^{4}$ | $9.95\times10^{-1}$ | $9.9\times10^{-1}$ | $197$ |
| $1/(t+1)^6$ | $\dfrac{6}{(t+1)^7}=0.012553$ | $\dfrac{6t}{t+1}\approx3.51$ | $1.78\times10^{-4}$ | $1.8\times10^{-4}$ | $3.53\%$ |
| $1/(3+2t)^3$ | $\dfrac{6}{(3+2t)^4}=0.0051993$ | $\dfrac{6t}{3+2t}\approx1.46$ | $7.39\times10^{-5}$ | $7.5\times10^{-5}$ | $1.46\%$ |
| $1/(99+70t)$ | $\dfrac{70}{(99+70t)^2}=0.0017856$ | $\dfrac{70t}{99+70t}\approx0.500$ | $2.54\times10^{-5}$ | $2.6\times10^{-5}$ | $0.50\%$ |

表中预测值来自一阶展开，实际误差则由代入结果与准确值直接相减得到。两者在扰动较小时接近，但不应逐位相同。例如，第二式的一阶预测约为 $2.51\times10^{-3}$，实际误差约为 $2.95\times10^{-3}$，差别来自高阶项。

第三式 $99-70t$ 的导数为 $-70$，所以输入误差会线性地放大 $70$ 倍。准确输出又很小，导致相对条件数很大。这里暂时使用精确算术计算各表达式；并没有通过这张表单独测量浮点减法的舍入误差。

第六式的相对条件数约为 $0.5$，表示在 $t=\sqrt2$ 附近，小的相对输入误差对它的相对输出影响较小。六个函数在这个指定点取相同值，但对邻近输入的响应不同。这个区别正是正文比较不同表达式时需要说明的前提。

<a id="app-a-1-2"></a>

### A.1.2 有效数字与相对误差的换算界都不可再改进（[定理 1.2.1](../ch01/sec12.md#thm-1.2.1) 的补全）

本节沿用所引定理的约定：有效数字由绝对误差 $|x-a|\le\tfrac12 10^{m-n}$ 判断，且 $\varepsilon_{\mathrm r}(a)=|x-a|/|a|$ **以近似值为分母**，其中 $|a|=0.a_1a_2\cdots\times10^m$。它不同于 A.1.1 以真值为分母的相对误差；下面的常数不能不加转换就用于 $|x-a|/|x|$。例如 $a=5.00$、$x=5.005$ 时，两个相对误差分别为 $0.005/5$ 与 $0.005/5.005$，只有前者在下面的正向界取等。

**正向界 $\dfrac{1}{2a_1}\times10^{1-n}$ 取得等号。**取 $a=5.00$（规格化 $0.500\times10^1$，$a_1=5$，$m=1$，$k=3$），$x=5.005$。则 $\varepsilon(a)=0.005=\tfrac12\times10^{1-3}$（$a$ 恰有 3 位有效数字），而

$$\varepsilon_{\mathrm r}(a)=\frac{0.005}{5.00}=0.001=\frac{1}{2a_1}\times10^{1-3}=\frac{1}{10}\times10^{-2},$$

等号成立。故常数 $\dfrac{1}{2a_1}$ 不可放宽。

**逆向界 $\dfrac{1}{2(a_1+1)}\times10^{1-n}$ 同样不能普遍放宽。**固定首位 $a_1$ 和位数 $n$，令

$$a_\delta=(a_1+1-\delta)10^{m-1},\qquad |x-a_\delta|=\tfrac12\times10^{m-n}+\eta,$$

其中 $0<\delta<1$、$\eta>0$。实际误差已超过 $n$ 位有效数字的要求，但让 $\delta,\eta\to0$ 时，以近似值为分母的相对误差趋近 $\dfrac{1}{2(a_1+1)}\times10^{1-n}$。因此，只要把这个充分条件的常数放宽，就能找到不满足 $n$ 位要求的例子。

**组合起来读：**固定同一个首位 $a_1$，正向界与逆向充分界之比为 $(a_1+1)/a_1$，最多为 $2$。由有效数字推相对误差，与由相对误差倒推有效数字，使用的是不同的界。

<a id="app-a-1-3"></a>

### A.1.3 递推积分 $y_n$ 的完整分析：最坏误差界与交错级数（[1.2.4](../ch01/sec12.md#sec-1.2.4) 原则 (1) 的补全）

$$y_n=\int_0^1\frac{x^n}{x+5}\,dx,\qquad y_n=\frac1n-5y_{n-1}\ (n\ge1),\qquad y_0=\ln\frac65 .$$

**（一）正向递推的最坏误差界。**设第 $n$ 步的误差为 $\delta_n=y_n^{(计算)}-y_n^{(真)}$。每步执行 $y_n=\mathrm{fl}(1/n-5y_{n-1})$，除真实递推外多出两项误差：旧误差被乘 $-5$ 放大，加上本步新的舍入 $\rho_n$（$\lvert\rho_n\rvert\le\rho$，$\rho$ 为每步舍入的绝对值上界）：

$$\delta_n=-5\,\delta_{n-1}+\rho_n .$$

对 $n$ 展开此式（$\delta_n=-5\delta_{n-1}+\rho_n$ 逐层代入）：

$$\lvert\delta_n\rvert\ \le\ 5^n\lvert\delta_0\rvert+\rho\,(1+5+\cdots+5^{n-1})=5^n\lvert\delta_0\rvert+\rho\,\frac{5^n-1}{4}\ \approx\ 5^n\Bigl(\lvert\delta_0\rvert+\frac{\rho}{4}\Bigr).$$

取 $\lvert\delta_0\rvert=\lvert\ln(6/5)-0.1823\rvert=2.16\times10^{-5}$、$n=100$、$5^{100}\approx7.9\times10^{69}$：界约 $10^{65}$。反向递推的系数 $1/5$ 把同一公式变成**压缩**，起点误差 $1.6\times10^{-4}$ 传到 $y_0$ 只剩 $1.6\times10^{-4}/5^{100}$——机器精度之下。

这里衰减到机器精度以下的只是**起点误差的贡献**，不是反向递推的总误差。若反向每步另有绝对误差 $\tilde\rho_n$，且 $|\tilde\rho_n|\le\tilde\rho$，则 $\delta_{n-1}=-\delta_n/5+\tilde\rho_n$；从 $N$ 递推到 $0$ 后有 $|\delta_0|\le5^{-N}|\delta_N|+\frac54\tilde\rho(1-5^{-N})$。压缩递推抑制旧误差，但仍有新舍入积累形成的误差底限。

**（二）$y_n$ 的交错级数（反向递推起点的精确化）。**在 $[0,1]$ 上 $\lvert x/5\rvert\le\tfrac15\lt1$，几何级数一致收敛，可逐项积分：

$$\frac{1}{x+5}=\frac15\cdot\frac{1}{1+x/5}=\sum_{j=0}^{\infty}\frac{(-1)^jx^j}{5^{j+1}}\qquad\Longrightarrow\qquad
y_n=\sum_{j=0}^{\infty}\frac{(-1)^j}{5^{j+1}(n+j+1)} .$$

级数各项单调递减趋于零，故**截断误差不超过首个舍去项**。两个检验：

- $n=0$：级数为 $\sum_j(-1)^j\frac{(1/5)^{j+1}}{j+1}$，正是 $\ln(1+z)$ 在 $z=1/5$ 处的 Taylor 级数，和为 $\ln(6/5)=0.182322$ ✓；
- $n=100$：逐项求和 $y_{100}=\frac{1}{505}-\frac{1}{2550}+\frac{1}{12875}-\frac{1}{65000}+\cdots\approx0.0016528$。

对照正文用的区间估计 $\frac{1}{6(n+1)}\lt y_n\lt\frac{1}{5(n+1)}$：$n=100$ 时区间为 $[0.0016502,\ 0.0019802]$，中点 $0.0018152$，真值 $0.0016528$ **紧贴区间左端**——中点估计的误差 $1.62\times10^{-4}$ 几乎用尽了「半宽度 $1.65\times10^{-4}$」的预算。这个粗糙的界已经做到了它能做到的极限；想要更准的起点，交错级数本身就可以：第 $j+1$ 项约为 $5^{-(j+1)}/(n+1)$，**想要起点误差多小就取多少项**——取 $7$ 项达绝对误差 $10^{-7}$，取 $12$ 项（手算量）达 $10^{-10}$，比「区间中点」细六个数量级。

**（三）渐近行为。**固定 $j$ 时，交错级数的每一项都约为 $(-1)^j/(5^{j+1}n)$，不能只保留首项就断言 $y_n\sim1/(5n)$：后续各项虽按几何比例变小，却与首项同为 $1/n$ 量级。分部积分更直接：

$$y_n=\frac{1}{6(n+1)}+\frac{1}{n+1}\int_0^1\frac{x^{n+1}}{(5+x)^2}\,dx.$$

剩余积分位于 $0$ 与 $1/[25(n+2)]$ 之间，因此 $y_n=\dfrac{1}{6(n+1)}+O(n^{-2})\sim\dfrac1{6n}$。

<a id="app-a-1-4"></a>

### A.1.4 范数等价常数的可达性，与无穷维的失效（[定理 1.3.3](../ch01/sec13.md#thm-1.3.3) 的补全）

**（一）显式不等式的每个常数都有向量取等：**

| 不等式 | 取等的向量 |
|:--|:--|
| $\lVert\boldsymbol{x}\rVert_\infty=\lVert\boldsymbol{x}\rVert_2$ | $\boldsymbol{x}$ 只有一个非零分量 |
| $\lVert\boldsymbol{x}\rVert_2=\sqrt n\,\lVert\boldsymbol{x}\rVert_\infty$ | $\lvert x_1\rvert=\cdots=\lvert x_n\rvert$（如 $\boldsymbol{1}$） |
| $\lVert\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_1$ | 单个非零分量 |
| $\lVert\boldsymbol{x}\rVert_1=\sqrt n\,\lVert\boldsymbol{x}\rVert_2$ | $\lvert x_1\rvert=\cdots=\lvert x_n\rvert$ |

所以 $\sqrt n$、$n$ 这些因子不是估计的粗糙，而是**这组范数的真实距离**。

**（二）无穷维时范数不一定等价。**为了在同一个空间比较，取所有只有有限个非零分量的序列，定义通常的 $1$-范数与 $2$-范数。令

$$\boldsymbol{x}^{(n)}=(\underbrace{1/n,\ldots,1/n}_{n\text{ 项}},0,0,\ldots),\qquad
\lVert\boldsymbol{x}^{(n)}\rVert_1=1,\qquad\lVert\boldsymbol{x}^{(n)}\rVert_2=\frac1{\sqrt n}\to0.$$

同一列向量按 $2$-范数收敛到零，按 $1$-范数却不收敛到零，所以不能在这个无穷维空间找到统一的范数等价常数。另一个相关现象是 $(1,1/2,1/3,\ldots)$ 属于 $\ell^2$ 而不属于 $\ell^1$；这里不应把无穷大称为一个范数值。数值 PDE 的离散维数 $n$ 增长时，也要留意有限维范数等价常数（如 $\sqrt n$）是否随 $n$ 增长。

<a id="app-a-2"></a>

## A.2 补充篇

<a id="app-a-2-1"></a>

### A.2.1 Jordan–von Neumann 定理：平行四边形恒等式 ⟹ 内积（[定理 2.1.2](../supplement/sec21.md#thm-sup-2.1.2) 逆方向的完整证明）

设 $\lVert\cdot\rVert$ 是 $\mathbb{R}^n$ 上的范数且满足平行四边形恒等式（2.2）。定义

$$\langle\boldsymbol{x},\boldsymbol{y}\rangle:=\frac14\Bigl(\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2-\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2\Bigr),$$

以下验证它满足内积三公理（对称、线性、正定），且诱导范数恰为 $\lVert\cdot\rVert$。

**第一步：符号与倍乘的基本事实。**

- $\langle\boldsymbol{x},\boldsymbol{x}\rangle=\frac14\lVert2\boldsymbol{x}\rVert^2=\lVert\boldsymbol{x}\rVert^2$（正定性与「诱导范数还原」一次到位：这里 $\lVert2\boldsymbol{x}\rVert^2=4\lVert\boldsymbol{x}\rVert^2$ 用了范数齐次性）；
- $\langle\boldsymbol{y},\boldsymbol{x}\rangle=\langle\boldsymbol{x},\boldsymbol{y}\rangle$（和项不变，差项由 $\|\boldsymbol y-\boldsymbol x\|=\|\boldsymbol x-\boldsymbol y\|$ 保持不变）；$\langle\boldsymbol{0},\boldsymbol{y}\rangle=0$；$\langle-\boldsymbol{x},\boldsymbol{y}\rangle=-\langle\boldsymbol{x},\boldsymbol{y}\rangle$。

**第二步（关键恒等式）：**对任意 $\boldsymbol{x},\boldsymbol{z},\boldsymbol{y}$，

$$\langle\boldsymbol{x}+\boldsymbol{z},\boldsymbol{y}\rangle+\langle\boldsymbol{x}-\boldsymbol{z},\boldsymbol{y}\rangle
=\frac14\Bigl[\lVert(\boldsymbol{x}+\boldsymbol{y})+\boldsymbol{z}\rVert^2+\lVert(\boldsymbol{x}+\boldsymbol{y})-\boldsymbol{z}\rVert^2-\lVert(\boldsymbol{x}-\boldsymbol{y})+\boldsymbol{z}\rVert^2-\lVert(\boldsymbol{x}-\boldsymbol{y})-\boldsymbol{z}\rVert^2\Bigr].$$

对前后两组分别用平行四边形恒等式（$\lVert\boldsymbol{a}+\boldsymbol{z}\rVert^2+\lVert\boldsymbol{a}-\boldsymbol{z}\rVert^2=2\lVert\boldsymbol{a}\rVert^2+2\lVert\boldsymbol{z}\rVert^2$），$\lVert\boldsymbol{z}\rVert$ 项相消：

$$=\frac14\Bigl[2\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2-2\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2\Bigr]=2\langle\boldsymbol{x},\boldsymbol{y}\rangle. \tag{$*$}$$

**第三步（倍 2）。**在 $(*)$ 中取 $\boldsymbol{z}=\boldsymbol{x}$：$\langle2\boldsymbol{x},\boldsymbol{y}\rangle+\langle\boldsymbol{0},\boldsymbol{y}\rangle=2\langle\boldsymbol{x},\boldsymbol{y}\rangle$，故 $\langle2\boldsymbol{x},\boldsymbol{y}\rangle=2\langle\boldsymbol{x},\boldsymbol{y}\rangle$。

**第四步（加法）。**任取 $\boldsymbol{u},\boldsymbol{v}$，令 $\boldsymbol{x}=\frac{\boldsymbol{u}+\boldsymbol{v}}2$、$\boldsymbol{z}=\frac{\boldsymbol{u}-\boldsymbol{v}}2$（于是 $\boldsymbol{x}+\boldsymbol{z}=\boldsymbol{u}$，$\boldsymbol{x}-\boldsymbol{z}=\boldsymbol{v}$）。由 $(*)$ 与第三步（把 $\frac{\boldsymbol{u}+\boldsymbol{v}}2$ 看成 $\frac12\cdot(\boldsymbol{u}+\boldsymbol{v})$，第三步反过来用）：

$$\langle\boldsymbol{u},\boldsymbol{y}\rangle+\langle\boldsymbol{v},\boldsymbol{y}\rangle=2\Bigl\langle\frac{\boldsymbol{u}+\boldsymbol{v}}2,\ \boldsymbol{y}\Bigr\rangle=\langle\boldsymbol{u}+\boldsymbol{v},\boldsymbol{y}\rangle .$$

**第五步（齐次性）。**加法已得，$\langle k\boldsymbol{x},\boldsymbol{y}\rangle=k\langle\boldsymbol{x},\boldsymbol{y}\rangle$ 对正整数 $k$ 归纳成立；负号由第一步；对有理数 $\frac pq$：$q\,\langle\frac pq\boldsymbol{x},\boldsymbol{y}\rangle=\langle p\boldsymbol{x},\boldsymbol{y}\rangle=p\langle\boldsymbol{x},\boldsymbol{y}\rangle$，两边除以 $q$。对实数 $t$：取有理数 $r_m\to t$，只需证 $\boldsymbol{w}\to\boldsymbol{0}$ 时 $\langle\boldsymbol{w},\boldsymbol{y}\rangle\to0$。由定义与三角不等式，

$$\lvert\langle\boldsymbol{w},\boldsymbol{y}\rangle\rvert\le\frac14\bigl(\lVert\boldsymbol{w}+\boldsymbol{y}\rVert+\lVert\boldsymbol{w}-\boldsymbol{y}\rVert\bigr)\cdot\bigl\lvert\lVert\boldsymbol{w}+\boldsymbol{y}\rVert-\lVert\boldsymbol{w}-\boldsymbol{y}\rVert\bigr\rvert\le\frac14\cdot2(\lVert\boldsymbol{w}\rVert+\lVert\boldsymbol{y}\rVert)\cdot2\lVert\boldsymbol{w}\rVert=\lVert\boldsymbol{w}\rVert(\lVert\boldsymbol{w}\rVert+\lVert\boldsymbol{y}\rVert)\to0 ,$$

而 $\lVert(t-r_m)\boldsymbol{x}\rVert=|t-r_m|\,\lVert\boldsymbol{x}\rVert\to0$。故 $\langle t\boldsymbol{x},\boldsymbol{y}\rangle=\lim_m r_m\langle\boldsymbol{x},\boldsymbol{y}\rangle=t\langle\boldsymbol{x},\boldsymbol{y}\rangle$。∎

**评注：**第二步的 $(*)$ 是全证明的心脏——平行四边形恒等式在这里恰好提供了「把 $\pm\boldsymbol{z}$ 的四个平方项两两配对」的结构；$1$-范数与 $\infty$-范数（[例 2.1.2](../supplement/sec21.md#ex-sup-2.1.2)）正是在这一步失效。

<a id="app-a-2-2"></a>

### A.2.2 残差与误差的向下界（[定理 2.4.4](../supplement/sec24.md#thm-sup-2.4.4) 的补充证明）

::: thm 命题 A.2 · 残差与误差的向下界
设 $A$ 非奇异，$\boldsymbol b\ne\boldsymbol0$，向量范数与所用从属矩阵范数配套。设 $\hat{\boldsymbol{x}}$ 为近似解，$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$，$\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$。若 $\lVert\boldsymbol{e}\rVert\lt\lVert\hat{\boldsymbol{x}}\rVert$，记 $\alpha=\lVert\boldsymbol{e}\rVert/\lVert\hat{\boldsymbol{x}}\rVert$，则

$$\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\ \le\ \mathrm{cond}(A)\cdot\frac{\alpha}{1-\alpha} .$$

::: proof 证明
由 $\boldsymbol{r}=-A\boldsymbol{e}$（两边取范数）得 $\lVert\boldsymbol{r}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{e}\rVert$。另一方面，反三角不等式给出 $\lVert\boldsymbol{x}\rVert\ge\lVert\hat{\boldsymbol{x}}\rVert-\lVert\boldsymbol{e}\rVert=\lVert\hat{\boldsymbol{x}}\rVert(1-\alpha)$，而 $\boldsymbol{b}=A\boldsymbol{x}$ 给出下界（这是标准的「右端 = 解经 $A$ 的像」估计：$\lVert\boldsymbol{b}\rVert\ge\lVert\boldsymbol{x}\rVert/\lVert A^{-1}\rVert$，由 $\lVert\boldsymbol{x}\rVert=\lVert A^{-1}\boldsymbol{b}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol{b}\rVert$ 移项即得）。两式相除：

$$\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\le\frac{\lVert A\rVert\,\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert/\lVert A^{-1}\rVert}\le\lVert A\rVert\lVert A^{-1}\rVert\cdot\frac{\alpha\lVert\hat{\boldsymbol{x}}\rVert}{(1-\alpha)\lVert\hat{\boldsymbol{x}}\rVert}=\mathrm{cond}(A)\cdot\frac{\alpha}{1-\alpha}.$$
:::
:::

**两个附注。**

1. **可计算性。** 虽然分母使用近似解，但分子 $\|\boldsymbol e\|$ 仍依赖未知真解，所以 $\alpha$ 不能直接由近似解算出。条件 $\alpha<1$ 是此界的前提；例如已另行证明 $\|\boldsymbol e\|<\|\boldsymbol x\|/2$ 时，可以由反三角不等式推出它。
2. **与上界合起来读。**记 $\beta=\|\boldsymbol r\|/\|\boldsymbol b\|$、$K=\mathrm{cond}(A)$，本命题等价于 $\alpha\ge\beta/(K+\beta)$，因此给出了误差的下界。若改用真解作分母，标准双边界为 $\beta/K\le\|\boldsymbol e\|/\|\boldsymbol x\|\le K\beta$。条件数小时，相对残差与相对误差能互相给出较紧的界；条件数大时也可能碰巧得到小误差，不能把条件数小当作解准确的必要条件。

<a id="app-a-2-3"></a>

### A.2.3 工具箱：重排不等式、Birkhoff 定理与对称迹不等式

A.2.4 与 A.2.5 的两条主定理共用下面三件工具。本节把它们一次备齐。

::: lem 引理 A.3.1 · 标量重排不等式
设 $a_1\ge\cdots\ge a_n$，$b_1\ge\cdots\ge b_n$，$\pi$ 为任一置换，则 $\sum_i a_ib_{\pi(i)}\le\sum_i a_ib_i$。

::: proof 证明（对换法）
若 $\pi$ 不是恒等置换，存在 $i\lt j$ 使 $\pi(i)\gt\pi(j)$。交换 $\pi(i)$ 与 $\pi(j)$ 两项，和的改变量为

$$(a_ib_{\pi(j)}+a_jb_{\pi(i)})-(a_ib_{\pi(i)}+a_jb_{\pi(j)})=(a_i-a_j)\,\bigl(b_{\pi(j)}-b_{\pi(i)}\bigr)\ge0 ,$$

即「逆序对换成顺序，和不减」。逆序对个数有限，逐个消除后 $\pi$ 化为恒等置换，和单调不减到 $\sum a_ib_i$。
:::
:::

::: lem 引理 A.3.2 · Birkhoff 定理
$n\times n$ **双随机矩阵**（每行、每列元素之和都为 $1$ 的非负矩阵）都是置换矩阵的凸组合：$P=\sum_{\pi}w_\pi\Pi_\pi$，$w_\pi\ge0$，$\sum w_\pi=1$。

::: proof 证明（先找正元匹配，再归纳剥离）
把 $p_{ij}>0$ 看成第 $i$ 行与第 $j$ 列之间有一条边。对任意 $k$ 个行指标的集合 $R$，记与它们相连的列集合为 $N(R)$。这些行的元素之和为 $k$，而每一列的总和为 $1$，因此 $|N(R)|\ge|R|$。

先证明这一性质保证存在覆盖所有行、列的正元匹配，对矩阵阶数归纳。若每个非空真子集 $R$ 都满足 $|N(R)|\ge|R|+1$，任选一条正元边，删去它所在的行与列；剩余任意行集合删列后仍至少有同样多的相邻列，归纳可得其余匹配。否则存在非空真子集 $R$ 满足 $|N(R)|=|R|$。$R$ 与 $N(R)$ 构成的子图保持同一性质；对其余行的任意子集 $S$，由 $|N(R\cup S)|\ge|R|+|S|$ 可知，$S$ 在 $N(R)$ 以外至少还有 $|S|$ 个相邻列。两边分别用归纳假设匹配，再合并。$1$ 阶情形直接成立。

设所得匹配对应置换矩阵 $\Pi$，取其匹配位置中的最小值 $\theta>0$。若 $\theta=1$，所有匹配元均为 $1$，由行列和可知 $P=\Pi$。若 $\theta<1$，令

$$Q=\frac{P-\theta\Pi}{1-\theta},\qquad P=\theta\Pi+(1-\theta)Q.$$

$\Pi$ 的每个 $1$ 都位于 $P$ 中不小于 $\theta$ 的位置，故 $Q\ge0$；每行每列各减去一个 $\theta$，再除以 $1-\theta$，故 $Q$ 仍为双随机矩阵。至少一个正元变为零，所以按正元个数归纳，对 $Q$ 重复这一过程最终得到置换矩阵，再回代即得 $P$ 的凸组合。
:::
:::

::: lem 引理 A.3.3 · 对称迹不等式
设 $S,T\in\mathbb{R}^{n\times n}$ 对称，特征值降序排列 $\lambda_1\ge\cdots\ge\lambda_n$、$\mu_1\ge\cdots\ge\mu_n$，则

$$\operatorname{tr}(ST)\ \le\ \sum_{i=1}^n\lambda_i\mu_i .$$

::: proof 证明
取标准正交特征基 $S=\sum_i\lambda_i\boldsymbol{u}_i\boldsymbol{u}_i^{\mathrm T}$、$T=\sum_j\mu_j\boldsymbol{v}_j\boldsymbol{v}_j^{\mathrm T}$，则

$$\operatorname{tr}(ST)=\sum_{i,j}\lambda_i\mu_j\,(\boldsymbol{u}_i^{\mathrm T}\boldsymbol{v}_j)^2 .$$

矩阵 $C=(c_{ij})$，$c_{ij}=(\boldsymbol{u}_i^{\mathrm T}\boldsymbol{v}_j)^2$，行和 $\sum_jc_{ij}=\lVert\boldsymbol{u}_i\rVert^2=1$（$\{\boldsymbol{v}_j\}$ 是标准正交基，Parseval 恒等式 [定理 2.1.4](../supplement/sec21.md#thm-sup-2.1.4)），列和同理为 $1$——$C$ 双随机。由引理 A.3.2，$C=\sum_\pi w_\pi\Pi_\pi$，于是

$$\operatorname{tr}(ST)=\sum_\pi w_\pi\sum_i\lambda_i\mu_{\pi(i)}\ \overset{\text{A.3.1}}{\le}\ \sum_\pi w_\pi\sum_i\lambda_i\mu_i=\sum_i\lambda_i\mu_i. $$

（取等条件：$S,T$ 有共同特征基且降序对齐——正是「同向对角」的情形。）
:::
:::

::: cor 推论 A.3.4 · Hoffman–Wielandt 不等式（对称阵）
在引理 A.3.3 的记号下，

$$\lVert S-T\rVert_F^2\ \ge\ \min_{\pi}\ \sum_{i=1}^n\bigl(\lambda_i-\mu_{\pi(i)}\bigr)^2 ,$$

且右端最优配对就是「降序对降序」。

::: proof 证明
$\lVert S-T\rVert_F^2=\operatorname{tr}(S-T)^2=\sum_i\lambda_i^2+\sum_i\mu_i^2-2\operatorname{tr}(ST)$。用引理 A.3.3 控制交叉项，再用引理 A.3.1：同序配对使 $\sum\lambda_i\mu_{\pi(i)}$ 最大，因此

$$\lVert S-T\rVert_F^2\ \ge\ \sum_i\lambda_i^2+\sum_i\mu_i^2-2\sum_i\lambda_i\mu_i=\sum_i(\lambda_i-\mu_i)^2,$$

而 $(\lambda_i-\mu_{\pi(i)})^2$ 展开后交叉项 $-2\lambda_i\mu_{\pi(i)}$ 由重排不等式知降序配对最小。
:::
:::

<a id="app-a-2-4"></a>

### A.2.4 von Neumann 迹不等式：完整证明（[例 2.6.4](../supplement/sec26.md#ex-sup-2.6.4) 的补全）

::: thm 定理 A.4 · von Neumann 迹不等式
对任意 $A,B\in\mathbb{R}^{m\times n}$，$\lvert\operatorname{tr}(A^{\mathrm T}B)\rvert\le\sum_{i=1}^{\min(m,n)}\sigma_i(A)\sigma_i(B)$（奇异值均降序）。

::: proof 证明
一步「对称化膨胀」（symmetric dilation）把矩形问题化为 A.2.3 的对称情形。设 $m\ge n$（否则转置），令

$$S=\begin{pmatrix}O&A\\A^{\mathrm T}&O\end{pmatrix},\qquad T=\begin{pmatrix}O&B\\B^{\mathrm T}&O\end{pmatrix}\in\mathbb{R}^{(m+n)\times(m+n)} .$$

**（一）$S$ 对称，且特征值包含 $\pm\sigma_i(A)$。**取奇异向量对 $A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i$、$A^{\mathrm T}\boldsymbol{u}_i=\sigma_i\boldsymbol{v}_i$（[定理 2.6.1](../supplement/sec26.md#thm-sup-2.6.1)），则

$$S\frac1{\sqrt2}\begin{pmatrix}\boldsymbol{u}_i\\ \boldsymbol{v}_i\end{pmatrix}=\sigma_i\frac1{\sqrt2}\begin{pmatrix}\boldsymbol{u}_i\\ \boldsymbol{v}_i\end{pmatrix},\qquad
S\frac1{\sqrt2}\begin{pmatrix}\boldsymbol{u}_i\\ -\boldsymbol{v}_i\end{pmatrix}=-\sigma_i\frac1{\sqrt2}\begin{pmatrix}\boldsymbol{u}_i\\ -\boldsymbol{v}_i\end{pmatrix}.$$

这 $2n$ 个向量标准正交；把左奇异向量组补成 $\mathbb R^m$ 的标准正交基，再取补入的 $\boldsymbol{u}_{n+1},\dots,\boldsymbol{u}_m$，它们满足 $A^{\mathrm T}\boldsymbol{u}_j=0$。对应的 $\binom{\boldsymbol{u}_j}{\boldsymbol0}$ 是零特征向量，与前面的向量正交。因此特征值为 $\sigma_1,\dots,\sigma_n,-\sigma_n,\dots,-\sigma_1$，再补 $m-n$ 个 $0$；其中 $\sigma_i=0$ 时零特征值按重数保留。

**（二）套用对称迹不等式。**$\operatorname{tr}(ST)=2\operatorname{tr}(A^{\mathrm T}B)$（分块直接展开），$S,T$ 的特征值降序逐项相乘：

$$\operatorname{tr}(ST)\ \overset{\text{A.3.3}}{\le}\ \sum_{i\le n}\sigma_i(A)\sigma_i(B)+\sum_{i\le n}\bigl(-\sigma_{n-i+1}(A)\bigr)\bigl(-\sigma_{n-i+1}(B)\bigr)=2\sum_{i=1}^{n}\sigma_i(A)\sigma_i(B),$$

两边除以 $2$ 即得 $\operatorname{tr}(A^{\mathrm T}B)\le\sum\sigma_i(A)\sigma_i(B)$。对 $-B$ 再用一次得绝对值版本。
:::
:::

**取等的一个充分条件**：$A,B$ 可用相同的左右奇异向量且奇异值按相同顺序配对。特例 $B=A$ 时，$\operatorname{tr}(A^{\mathrm T}A)=\lVert A\rVert_F^2=\sum\sigma_i^2$，确实取等。

<a id="app-a-2-5"></a>

### A.2.5 Eckart–Young–Mirsky：Frobenius 情形完整证明（[定理 2.6.4](../supplement/sec26.md#thm-sup-2.6.4) 的补全）

::: thm 定理 A.5 · Eckart–Young–Mirsky（Frobenius 情形）
设 $A\in\mathbb R^{m\times n}$ 的秩为 $r$，非零奇异值为 $\sigma_1\ge\cdots\ge\sigma_r>0$，$0\le k\le r$ 为整数。则 $\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_F=\sqrt{\sigma_{k+1}^2+\cdots+\sigma_r^2}$，由截断 SVD（2.33）取到；$k=r$ 时空和为零。

::: proof 证明
上界方向（$B=A_k$ 达到）正文已算：$A-A_k$ 的奇异值恰为 $\sigma_{k+1},\dots,\sigma_r$，Frobenius 范数平方 $=\sum_{i\gt k}\sigma_i^2$。只证**下界**：任何 $\operatorname{rank}B\le k$ 都不更优。

不妨设 $m\ge n$（否则同时转置 $A,B$，秩与 Frobenius 范数均不变），并把 $\sigma_{r+1},\ldots,\sigma_n$ 补为零。取 A.2.4 的膨胀 $S,T$（$A\mapsto S$，$B\mapsto T$）。记 $B$ 的奇异值为 $\tau_1\ge\cdots\ge\tau_n\ge0$；由于 $\operatorname{rank}B\le k$，$j>k$ 时 $\tau_j=0$。$T$ 的降序谱由 $\tau_1,\dots,\tau_n$、$m-n$ 个零及 $-\tau_n,\dots,-\tau_1$ 组成。由推论 A.3.4 与「降序配降序」：

$$2\lVert A-B\rVert_F^2=\lVert S-T\rVert_F^2\ \ge\ \min_{\pi}\sum_i\bigl(\lambda_i(S)-\lambda_{\pi(i)}(T)\bigr)^2=\sum_i\bigl(\lambda_i(S)-\lambda_i(T)\bigr)^2 .$$

（右端等号处用了与 A.3.4 相同的重排论证：$\sum(\lambda_i(S)-\mu_{\pi(i)}(T))^2$ 在同序配对时最小。）把两个降序谱逐项相减：

$$\sum_i\bigl(\lambda_i(S)-\lambda_i(T)\bigr)^2=\sum_{j\le n}\bigl(\sigma_j-\tau_j\bigr)^2+\sum_{j\le n}\bigl(\sigma_{n-j+1}-\tau_{n-j+1}\bigr)^2=2\sum_{j=1}^{n}\bigl(\sigma_j-\tau_j\bigr)^2\ \ge\ 2\sum_{j\gt k}\sigma_j^2,$$

最后一步因 $j\gt k$ 时 $\tau_j=0$，$(\sigma_j-\tau_j)^2=\sigma_j^2$。合并：

$$\lVert A-B\rVert_F^2\ \ge\ \sum_{j\gt k}\sigma_j^2 .$$
:::
:::

**评注。**同一套「Birkhoff + 重排 + 膨胀」顺带产出了 von Neumann 迹不等式（A.2.4）与 Hoffman–Wielandt（A.3.4）——三个「最优配对」型定理是一家人。2-范数情形（正文）用的是 Courant–Fischer 维数计数，走的是另一条路，但结论同样精确。

<a id="app-a-2-6"></a>

### A.2.6 Weyl 不等式的严格证明（[定理 2.5.6](../supplement/sec25.md#thm-sup-2.5.6)（一）的补全）

::: thm 命题 A.6 · Weyl 扰动界
$A,E$ 对称，特征值升序 $\lambda_1\le\cdots\le\lambda_n$，$\mu_1\le\cdots\le\mu_n$（$\mu$ 为 $A+E$ 的），则 $\lvert\lambda_i-\mu_i\rvert\le\lVert E\rVert_2$。

::: proof 证明
只证 $\mu_i\le\lambda_i+\lVert E\rVert_2$（另一半对 $-E$ 同理）。对升序特征值，Courant–Fischer 的 min-max 形式（[定理 2.5.5](../supplement/sec25.md#thm-sup-2.5.5)）是

$$\mu_i=\min_{\dim\mathcal{S}=i}\ \max_{\boldsymbol{0}\neq\boldsymbol{x}\in\mathcal{S}}\frac{\boldsymbol{x}^{\mathrm T}(A+E)\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}} .$$

**关键是把 $\min$ 换成一个允许的子空间的值：**取 $\mathcal{S}_0=\operatorname{span}\{\boldsymbol{u}_1,\dots,\boldsymbol{u}_i\}$（$A$ 的前 $i$ 个特征向量，$\dim\mathcal{S}_0=i$），则

$$\mu_i\ \le\ \max_{\boldsymbol{0}\ne\boldsymbol{x}\in\mathcal{S}_0}R_{A+E}(\boldsymbol{x})\ =\ \max_{\boldsymbol{0}\ne\boldsymbol{x}\in\mathcal{S}_0}\Bigl(R_A(\boldsymbol{x})+\frac{\boldsymbol{x}^{\mathrm T}E\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}\Bigr)\ \le\ \max_{\boldsymbol{0}\ne\boldsymbol{x}\in\mathcal{S}_0}R_A(\boldsymbol{x})+\lVert E\rVert_2=\lambda_i+\lVert E\rVert_2 ,$$

最后一步：$\mathcal{S}_0$ 上 $R_A$ 的最大值是 $\lambda_i$（权只落在 $\lambda_1,\dots,\lambda_i$ 上，且 $\boldsymbol{x}=\boldsymbol{u}_i$ 达到）；扰动项由 $\lvert\boldsymbol{x}^{\mathrm T}E\boldsymbol{x}\rvert\le\lVert E\rVert_2\lVert\boldsymbol{x}\rVert_2^2$ 控制。反向：$\lambda_i=\lambda_i((A+E)+(-E))\le\mu_i+\lVert E\rVert_2$。
:::
:::

**两个附注。**① 对升序特征值，更一般的 Weyl 不等式是 $\lambda_{i+j-1}(A+B)\ge\lambda_i(A)+\lambda_j(B)$（$i+j-1\le n$）。证明时取 $A$ 中对应 $\lambda_i,\ldots,\lambda_n$ 的特征子空间和 $B$ 中对应 $\lambda_j,\ldots,\lambda_n$ 的特征子空间：它们的交集维数至少为 $n-i-j+2$。交集中每个非零向量的 Rayleigh 商分别不小于 $\lambda_i(A)$ 和 $\lambda_j(B)$；再用升序特征值的 max-min 形式即可。② 在上面的证明中，最小值不大于任何一个允许子空间上的最大值，因此代入 $\mathcal{S}_0$ 后不等号方向是 $\le$。

<a id="app-a-2-7"></a>

### A.2.7 Gelfand 公式与瞬态增长（[例 2.5.6](../supplement/sec25.md#ex-sup-2.5.6) 的定量补全）

::: thm 定理 A.7 · Gelfand 公式
对任意相容矩阵范数，$\displaystyle\lim_{k\to\infty}\lVert A^k\rVert^{1/k}=\rho(A)$。

::: proof 证明
「$\ge$」：$\rho(A)^k=\rho(A^k)\le\lVert A^k\rVert$（[2.5.1](../supplement/sec25.md#sup-2.5.1) 后的注），故 $\rho(A)\le\liminf_k\lVert A^k\rVert^{1/k}$。

「$\le$」：在复数域取 $A$ 的 Jordan 标准形 $A=PJP^{-1}$；实矩阵也可在复数域完成估计，再用有限维范数等价回到原范数。任给 $s>\rho(A)$，选 $\rho(A)<\tilde s<s$。每个 Jordan 块写成 $J_\lambda=\lambda I+N$，其中 $N$ 的超对角元为 $1$，且对块大小 $d$ 有 $N^d=0$。由于 $\lambda I$ 与 $N$ 可交换，

$$J_\lambda^k=\sum_{q=0}^{\min(k,d-1)}\binom{k}{q}\lambda^{k-q}N^q.$$

这里 $q\le n-1$，$\binom{k}{q}\le k^q$，且 $|\lambda|^{k-q}\le\tilde s^{k-q}$。将有限个 $\tilde s^{-q}$ 与块范数并入常数，可得（$k\ge1$）

$$\lVert J^k\rVert\le Ck^{n-1}\tilde s^k.$$

故

$$\lVert A^k\rVert\le C'k^{n-1}\tilde s^k\le C'k^{n-1}s^k,\qquad
\lVert A^k\rVert^{1/k}\le C'^{1/k}k^{(n-1)/k}s\ \xrightarrow{k\to\infty}\ s .$$

令 $s\downarrow\rho(A)$ 即得。
:::
:::

**（二）对角化情形的瞬态增长界。**以下使用 $2$-范数及其条件数。若 $B=V\Lambda V^{-1}$，则对一切 $k$：

$$\frac{\rho(B)^k}{\operatorname{cond}(V)}\ \le\ \lVert B^k\rVert\ \le\ \operatorname{cond}(V)\,\rho(B)^k$$

（右端：$\lVert V\Lambda^kV^{-1}\rVert_2\le\lVert V\rVert_2\lVert\Lambda^k\rVert_2\lVert V^{-1}\rVert_2$；左端：由 $\rho(B)^k=\lVert\Lambda^k\rVert_2=\lVert V^{-1}B^kV\rVert_2$ 反向放缩。）$\operatorname{cond}_2(V)$ 大时，这个上界允许较大的瞬态增长；但特征向量可以重新缩放，不能仅凭某个 $V$ 的条件数判断矩阵是否非正规。

**（三）$2\times2$ 的精确算例。**设 $B=\begin{pmatrix}\lambda&M\\0&\lambda\end{pmatrix}$，其中 $0<\lvert\lambda\rvert<1$，$M$ 为实数。则对正整数 $k$，

$$B^k=\begin{pmatrix}\lambda^k&Mk\lambda^{k-1}\\0&\lambda^k\end{pmatrix},\qquad
\lVert B^k\rVert_2\ \ge\ \lvert M\rvert k\lvert\lambda\rvert^{k-1}.$$

把右端暂看成 $k$ 的连续函数，其峰值出现在 $k^*=-1/\ln\lvert\lambda\rvert$，大小为 $\lvert M\rvert/(e\lvert\lambda\rvert\,\lvert\ln\lvert\lambda\rvert\rvert)$；实际整数步取其附近即可。令 $\lambda=0.99$、$M=1000$，在约第 $99$ 步，这个下界约为 $3.7\times10^4$。虽然 $\rho(B)<1$ 保证 $B^k\to0$，初始扰动仍可能先被大幅放大。若 $\lambda=0$，则 $B^2=0$，不适用上面的对数计算。[例 2.5.6](../supplement/sec25.md#ex-sup-2.5.6) 用从属范数小于 $1$ 给出更容易检查的充分条件。

<a id="app-a-2-8"></a>

### A.2.8 Kantorovich 不等式与最速下降的收敛率（[2.4](../supplement/sec24.md) 的延伸）

::: thm 定理 A.8 · Kantorovich 不等式
$A$ 对称正定，特征值 $0\lt m\le\cdots\le M$，则对任意 $\boldsymbol{x}\neq\boldsymbol{0}$：

$$\frac{(\boldsymbol{x}^{\mathrm T}A\boldsymbol{x})^2}{(\boldsymbol{x}^{\mathrm T}\boldsymbol{x})(\boldsymbol{x}^{\mathrm T}A^2\boldsymbol{x})}\ \ge\ \frac{4mM}{(m+M)^2} .$$

::: proof 证明
在特征基下对角化 $A=\operatorname{diag}(\lambda_i)$，写 $\boldsymbol{x}=\sum k_i\boldsymbol{u}_i$，取权 $w_i=k_i^2/\sum_jk_j^2$，则命题变为 $\dfrac{(\sum w_i\lambda_i)^2}{\sum w_i\lambda_i^2}\ge\dfrac{4mM}{(m+M)^2}$（两边同除 $(\sum k_j^2)^2$）。由 $m\le\lambda_i\le M$：$(\lambda_i-m)(\lambda_i-M)\le0$，即

$$\lambda_i^2\ \le\ (m+M)\lambda_i-mM .$$

乘以 $w_i$ 求和（记 $u=\sum w_i\lambda_i\in[m,M]$，$v=\sum w_i\lambda_i^2$）：$v\le(m+M)u-mM$。于是

$$\frac{u^2}{v}\ \ge\ \frac{u^2}{(m+M)u-mM}\ \ge\ \min_{u\in[m,M]}\frac{u^2}{(m+M)u-mM} .$$

对 $u$ 求导，极小点 $u^*=\dfrac{2mM}{m+M}\in[m,M]$，代入得 $\dfrac{u^{*2}}{2mM-mM}=\dfrac{4mM}{(m+M)^2}$。
:::
:::

**应用：最速下降解 $A\boldsymbol{x}=\boldsymbol{b}$ 的收敛率。**迭代 $\boldsymbol{x}_{k+1}=\boldsymbol{x}_k+\alpha_k\boldsymbol{r}_k$（$\boldsymbol{r}_k=\boldsymbol{b}-A\boldsymbol{x}_k=-A\boldsymbol{e}_k$），精确线搜索 $\alpha_k=\dfrac{\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k}{\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k}$；若残差已为零，迭代就已到达精确解。令 $\tilde{\boldsymbol{e}}_k=A^{1/2}\boldsymbol{e}_k$（$\lVert\boldsymbol{e}_k\rVert_A=\lVert\tilde{\boldsymbol{e}}_k\rVert_2$，$\boldsymbol{r}_k=-A^{1/2}\tilde{\boldsymbol{e}}_k$），展开：

$$\lVert\boldsymbol{e}_{k+1}\rVert_A^2=\lVert\boldsymbol{e}_k\rVert_A^2-2\alpha_k\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k+\alpha_k^2\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k\ \Big|_{\alpha=\alpha_k}=\lVert\boldsymbol{e}_k\rVert_A^2-\frac{(\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k)^2}{\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k},$$

$$\frac{\lVert\boldsymbol{e}_{k+1}\rVert_A^2}{\lVert\boldsymbol{e}_k\rVert_A^2}=1-\frac{(\tilde{\boldsymbol{e}}_k^{\mathrm T}A\tilde{\boldsymbol{e}}_k)^2}{(\tilde{\boldsymbol{e}}_k^{\mathrm T}\tilde{\boldsymbol{e}}_k)(\tilde{\boldsymbol{e}}_k^{\mathrm T}A^2\tilde{\boldsymbol{e}}_k)}\ \overset{\text{A.8}}{\le}\ 1-\frac{4mM}{(m+M)^2}=\Bigl(\frac{M-m}{M+m}\Bigr)^2=\Bigl(\frac{\kappa-1}{\kappa+1}\Bigr)^2 .$$

（中间一步用了 $\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k=\tilde{\boldsymbol{e}}_k^{\mathrm T}A\tilde{\boldsymbol{e}}_k$、$\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k=\tilde{\boldsymbol{e}}_k^{\mathrm T}A^2\tilde{\boldsymbol{e}}_k$、$\lVert\boldsymbol{e}_k\rVert_A^2=\tilde{\boldsymbol{e}}_k^{\mathrm T}\tilde{\boldsymbol{e}}_k$。）这里控制的是**平方误差范数之比**：$\kappa=10$ 时上界约 $0.67$，$\kappa=10^4$ 时约 $0.9996$。对范数本身开方后，每步上界为 $(\kappa-1)/(\kappa+1)$，不能将两种指标混用。这是最坏情形的上界，实际步数还受初值和谱分布影响。与定步长梯度下降及共轭梯度的统一比较见[附录 C.2.1](connections.md#app-c-2-1)和[附录 C.6.1](connections.md#app-c-6-1)。

::: note 本附录引用的外部结果
除 Birkhoff 定理（A.2.3 自证）与 Jordan 标准形（A.2.7 引用，见任何高等代数教材）外，全部推导自含。进一步的系统展开见延伸阅读里的 Horn & Johnson《Matrix Analysis》（迹不等式与特征值扰动）、Higham《Accuracy and Stability of Numerical Algorithms》（Chapter 4：求和与浮点）与 Golub & Van Loan《Matrix Computations》（2.3–2.6 节：正交化与 SVD）。
:::
