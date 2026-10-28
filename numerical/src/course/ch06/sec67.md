# 6.7 Gauss 型求积公式

> 对应教材 6.7.1–6.7.2、定理 6.5–6.8、例 7–11。**课堂未讲**，按教材补齐；但第 12 讲已用「正交多项式零点定理」为本节发了门票（[第 12 讲 §三](../../lectures/lec12.md#lec12-S11)）。
> 主线：Gauss 求积用「节点也自由」换到最高代数精度——$n$ 个节点、$n$ 个权，共 $2n$ 个自由度，最高可到 $2n-1$ 次。

::: intuition 直觉 · 让节点也变成未知数
前面的公式都是「节点先定死，权由插值算出来」：$n+1$ 个节点只能保证 $n$ 次精度。Gauss 的想法是：**节点本身也是未知数**。$n$ 个节点加 $n$ 个权，一共 $2n$ 个自由度；用它们去满足 $2n$ 个矩条件（对 $1,x,\dots,x^{2n-1}$ 精确），理论上可以做到 $2n-1$ 次精度。

问题是节点不能乱选：要让 $2n$ 个方程有解，节点必须取成**正交多项式的根**。这正是第 12 讲零点定理的用处——它保证这些根互异、落在区间内部，可以作求积节点。
:::

<a id="sec-6.7.1"></a>
## 6.7.1 一般理论

::: def 定义 6.7.1（教材 6.7.1） · 带权求积与 Gauss 型公式 {#def-6.7.1}
设 $\rho(x)$ 是 $(a,b)$ 上的权函数。取 $n$ 个互异节点 $x_1,\dots,x_n$，形成

$$
\int_a^b\rho(x)f(x)\,dx\approx\sum_{i=1}^nA_if(x_i),
$$

其中 $A_i$ 与 $f$ 无关。若公式的代数精度达到 $2n-1$，则称它为 **Gauss 型求积公式**。
:::

$n$ 点公式有 $2n$ 个自由参数。下面的定理说明：Gauss 型公式不仅存在，而且节点被正交多项式的根唯一确定。

::: thm 定理 6.5（教材定理 6.5） · Gauss 节点 = 正交多项式的根 {#thm-6.7.1}
设 $\{g_k(x)\}$ 是 $[a,b]$ 上带权 $\rho(x)$ 的正交多项式系。则求积公式是 Gauss 型的**充分必要条件**是：它的节点 $x_1,\dots,x_n$ 是 $n$ 次正交多项式 $g_n(x)$ 的 $n$ 个零点。
:::

::: proof 证明
**必要性**。设公式为 Gauss 型，则对任何次数不超过 $2n-1$ 的多项式精确。任取次数不超过 $n-1$ 的多项式 $q(x)$，$q(x)g_n(x)$ 的次数不超过 $2n-1$，故

$$
\int_a^b\rho(x)q(x)g_n(x)\,dx=\sum_{i=1}^nA_iq(x_i)g_n(x_i)=0 .
$$

这说明 $g_n$ 与一切次数不超过 $n-1$ 的多项式正交。而 $n$ 次正交多项式在与低次多项式正交的意义下是唯一的（相差常数倍），故 $g_n$ 就是由节点多项式 $\prod_{i=1}^n(x-x_i)$ 所张成的那个正交多项式；它的零点正是 $x_1,\dots,x_n$。

**充分性**。设节点是 $g_n$ 的 $n$ 个零点。任取次数不超过 $2n-1$ 的多项式 $p(x)$，作带余除法

$$
p(x)=q(x)g_n(x)+r(x),
$$

其中 $q,r$ 的次数都不超过 $n-1$。因 $g_n(x_i)=0$，故 $p(x_i)=r(x_i)$。于是

$$
\int_a^b\rho p\,dx=\int_a^b\rho q g_n\,dx+\int_a^b\rho r\,dx=0+\sum_iA_ir(x_i)=\sum_iA_ip(x_i),
$$

即公式对 $p$ 精确。$\blacksquare$
:::

::: thm 定理 6.6（教材定理 6.6） · Gauss 公式的截断误差 {#thm-6.7.2}
设 $f\in C^{2n}[a,b]$，$a_n$ 是 $g_n(x)$ 的最高次项系数，则

$$
R(f)=\frac{f^{(2n)}(\eta)}{a_n^2(2n)!}\int_a^b\rho(x)g_n^2(x)\,dx,\qquad \eta\in(a,b).
$$
:::

::: proof 证明
以 Gauss 节点为插值节点，作满足

$$
H_{2n-1}(x_i)=f(x_i),\qquad H_{2n-1}'(x_i)=f'(x_i)\quad(i=1,\dots,n)
$$

的 $2n-1$ 次 Hermite 插值多项式。由 Hermite 余项（[定理 5.3](../ch05/sec52.md#thm-5.3)），

$$
f(x)=H_{2n-1}(x)+\frac{f^{(2n)}(\xi(x))}{(2n)!}\prod_{i=1}^n(x-x_i)^2 .
$$

两边乘 $\rho$ 积分。因 $H_{2n-1}$ 的次数不超过 $2n-1$，Gauss 公式对它精确：

$$
\int_a^b\rho H_{2n-1}\,dx=\sum_iA_iH_{2n-1}(x_i)=\sum_iA_if(x_i).
$$

余项部分用积分中值定理（$\rho\prod(x-x_i)^2$ 不变号），并把 $\prod(x-x_i)$ 写成 $g_n(x)/a_n$，即得结论。$\blacksquare$
:::

::: note 误差公式怎么读
$g_n$ 的零点就是节点，所以 $\prod_{i=1}^n(x-x_i)=g_n(x)/a_n$。误差主项里出现 $\int\rho g_n^2$——**正交多项式的「能量」**。这也解释了为什么 Gauss 公式对光滑函数收敛极快：$g_n^2$ 的积分有界，而 $(2n)!$ 增长极快，误差随 $n$ 迅速变小。
:::

::: thm 定理 6.7（教材定理 6.7） · Gauss 权为正且和为区间质量 {#thm-6.7.3}
Gauss 型公式的权满足

$$
A_i>0\quad(i=1,\dots,n),\qquad \sum_{i=1}^nA_i=\int_a^b\rho(x)\,dx .
$$
:::

::: proof 证明
（1）设 $\ell_k(x)$ 是以 $x_1,\dots,x_n$ 为节点的 Lagrange 基函数，则 $\ell_k(x_i)=\delta_{ki}$，且 $\ell_k^2$ 是 $2n-2$ 次多项式。Gauss 公式对 $\ell_k^2$ 精确：

$$
\int_a^b\rho(x)\ell_k^2(x)\,dx=\sum_iA_i\ell_k^2(x_i)=A_k.
$$

因 $\rho\ell_k^2\ge0$ 且不恒为零，左端 $>0$，故 $A_k>0$。

（2）取 $f\equiv1$，Gauss 公式精确，即得 $\sum A_i=\int_a^b\rho\,dx$。$\blacksquare$
:::

::: cor[core] 推论 · Gauss 公式数值稳定
由 $A_i>0$ 与 $\sum A_i=\int\rho\,dx$，得

$$
\sum_{i=1}^n|A_i|=\sum_{i=1}^nA_i=\int_a^b\rho(x)\,dx,
$$

与 $n$ 无关。故 Gauss 公式**具有数值稳定性**，函数值误差不会被放大。这是它优于高次 Newton–Cotes 的关键之一。
:::

::: thm 定理 6.8（教材定理 6.8） · Gauss 公式的收敛性 {#thm-6.7.4}
设 $f\in C[a,b]$，则 Gauss 型求积公式满足

$$
\lim_{n\to\infty}\sum_{i=1}^nA_if(x_i)=\int_a^b\rho(x)f(x)\,dx .
$$
:::

::: proof 证明要点
由 Weierstrass 定理，$[a,b]$ 上的连续函数 $f$ 可被多项式 $p$ 一致逼近。取 $p$ 的次数 $m\le2n-1$，则 Gauss 公式对 $p$ 精确；再用 $\sum|A_i|=\int\rho$ 控制 $f-p$ 的误差，即可让总误差任意小。完整 $\varepsilon$-$N$ 论证见教材定理 6.8 的证明。$\blacksquare$
:::

::: method[core] 构造 Gauss 公式的两条路 {#method-6.7-construct}
1. **正交多项式路线**：求 $n$ 次正交多项式 $g_n$ → 解 $g_n(x)=0$ 得节点 → 用

$$
A_i=\int_a^b\rho(x)\prod_{\substack{j=1\\j\ne i}}^n\frac{x-x_j}{x_i-x_j}\,dx
$$

算权。
2. **矩方程路线**：把 $A_1,\dots,A_n$ 当未知数，令公式对 $1,x,\dots,x^{n-1}$ 精确，解 $n$ 元线性方程组；节点仍需先由正交多项式定出（或与权联立解非线性方程组）。
:::

::: ex 例 6.7.1（教材例 7） · 带权 $x^2$ 的三点 Gauss 公式 {#ex-6.7.1}
构造形如

$$
\int_{-1}^1x^2f(x)\,dx\approx\sum_{i=1}^3A_if(x_i)
$$

的 Gauss 型求积公式。

**解** 在 $[-1,1]$ 上带权 $\rho(x)=x^2$ 的正交多项式组为

$$
g_0=1,\quad g_1=x,\quad g_2=x^2-\frac35,\quad g_3=x^3-\frac57x .
$$

由 $g_3(x)=0$ 得节点

$$
x_1=-\sqrt{\frac57},\qquad x_2=0,\qquad x_3=\sqrt{\frac57}.
$$

算权：

$$
A_1=\int_{-1}^1x^2\frac{(x-x_2)(x-x_3)}{(x_1-x_2)(x_1-x_3)}\,dx=\frac7{25},
\qquad
A_2=\int_{-1}^1x^2\frac{(x-x_1)(x-x_3)}{(x_2-x_1)(x_2-x_3)}\,dx=\frac8{75}.
$$

由 $A_1+A_2+A_3=\int_{-1}^1x^2dx=\frac23$ 得 $A_3=\frac7{25}$。故

$$
\int_{-1}^1x^2f(x)\,dx\approx\frac1{25}\left[7f\left(-\sqrt{\frac57}\right)+\frac83f(0)+7f\left(\sqrt{\frac57}\right)\right].
$$

**自检**：$\sum A_i=\frac7{25}+\frac8{75}+\frac7{25}=\frac{21+8+21}{75}=\frac23$ ✓；权全正 ✓；精度 $2\times3-1=5$ 次。
:::

<a id="sec-6.7.2"></a>
## 6.7.2 几种 Gauss 型求积公式

### 6.7.2.1 Gauss–Legendre 求积公式

取权 $\rho\equiv1$、区间 $[-1,1]$，正交多项式为 Legendre 多项式

$$
L_n(x)=\frac1{2^nn!}\frac{d^n}{dx^n}\left[(x^2-1)^n\right].
$$

以 $L_n$ 的零点为节点，得 **Gauss–Legendre 公式**：

$$
\int_{-1}^1f(x)\,dx\approx\sum_{i=1}^nA_if(x_i),\qquad
A_i=\frac{2}{(1-x_i^2)\left[L_n'(x_i)\right]^2}.
$$

常用节点与权：

| $n$ | 节点 $x_i$ | 权 $A_i$ |
|:--:|:--|:--|
| 1 | $0$ | $2$ |
| 2 | $\pm1/\sqrt3\approx\pm0.5773502692$ | $1$ |
| 3 | $0,\ \pm\sqrt{3/5}\approx\pm0.7745966692$ | $8/9,\ 5/9$ |
| 4 | $\pm0.8611363116,\ \pm0.3399810436$ | $0.3478548451,\ 0.6521451549$ |
| 5 | $0,\ \pm0.9061798459,\ \pm0.5384693101$ | $0.5688888889,\ 0.2369268851,\ 0.4786286705$ |

误差为

$$
R=\frac{2^{2n+1}(n!)^4}{(2n+1)\left[(2n)!\right]^3}f^{(2n)}(\eta),\qquad \eta\in(-1,1).
$$

::: method[core] 任意区间 $[a,b]$ 的变换 {#method-6.7-affine}
令

$$
x=\frac{a+b}{2}+\frac{b-a}{2}t,\qquad
\int_a^bf(x)\,dx=\frac{b-a}{2}\int_{-1}^1f\left(\frac{a+b}{2}+\frac{b-a}{2}t\right)dt .
$$

先对 $t\in[-1,1]$ 用 Gauss–Legendre，再乘 $\frac{b-a}{2}$。
:::

::: ex 例 6.7.2（教材例 8） · 三点 Simpson vs 三点 Gauss {#ex-6.7.2}
分别用三点 Simpson 公式和三点 Gauss–Legendre 公式计算

$$
I=\int_{-1}^1\sqrt{1+x}\,dx,
$$

并与精确值比较。

**解** 三点 Simpson（节点 $-1,0,1$）：

$$
S_3=\frac13\left[\sqrt0+4\sqrt1+\sqrt2\right]\approx1.804737854 .
$$

三点 Gauss–Legendre（节点 $\pm\sqrt{3/5},0$，权 $5/9,8/9,5/9$）：

$$
G_3=\frac59\sqrt{1-\sqrt{\frac35}}+\frac89\sqrt1+\frac59\sqrt{1+\sqrt{\frac35}}\approx1.892725829 .
$$

精确值 $I=\frac23\cdot2^{3/2}\approx1.885618083$。Gauss 误差约 $7.1\times10^{-3}$，Simpson 误差约 $8.1\times10^{-2}$——**同样 3 个节点，Gauss 准一个数量级**。
:::

::: note 前提：被积函数要光滑
例 6.7.2 的被积函数 $\sqrt{1+x}$ 在 $x=-1$ 处导数无穷，严格说不满足 Gauss 公式的高阶光滑前提；它仍比 Simpson 好，是因为奇点恰在端点、影响被节点避开。若奇点落在区间内部，Gauss 公式也会明显退化——**Gauss 不是万能的，它擅长光滑函数**。
:::

::: ex 例 6.7.3（教材例 9） · 四点 Gauss–Legendre 算 $\int_1^2e^{1/x}dx$ {#ex-6.7.3}
用四点 Gauss–Legendre 公式计算 $I=\int_1^2e^{1/x}dx$。

**解** 令 $x=\frac12(t+3)$，则

$$
I=\frac12\int_{-1}^1e^{2/(t+3)}\,dt .
$$

记 $\varphi(t)=e^{2/(t+3)}$。四点节点与函数值：

| $t_i$ | $\varphi(t_i)$ |
|:--:|:--:|
| $-0.8611363116$ | $2.547406932$ |
| $-0.3399810436$ | $2.120971718$ |
| $0.3399810436$ | $1.819944113$ |
| $0.8611363116$ | $1.678637128$ |

于是

$$
I\approx\frac12\Big[0.3478548451\big(\varphi(t_1)+\varphi(t_4)\big)
+0.6521451549\big(\varphi(t_2)+\varphi(t_3)\big)\Big]\approx2.020049534 .
$$

与真值 $2.020058624$ 相差约 $9.1\times10^{-6}$。**四个节点**就达到复化 Simpson 用 11 个节点（误差 $1.8\times10^{-5}$）的水平。
:::

### 6.7.2.2 Gauss–Laguerre 求积公式

取权 $\rho(x)=e^{-x}$、区间 $[0,\infty)$，正交多项式为 Laguerre 多项式

$$
U_n(x)=e^x\frac{d^n}{dx^n}\left(x^ne^{-x}\right).
$$

以 $U_n$ 的零点为节点：

$$
\int_0^\infty e^{-x}f(x)\,dx\approx\sum_{i=1}^nA_if(x_i),\qquad
A_i=\frac{(n!)^2}{x_i\left[U_n'(x_i)\right]^2}.
$$

误差为

$$
R=\frac{(n!)^2}{(2n)!}f^{(2n)}(\eta),\qquad \eta\in(0,\infty).
$$

常用 $n=1$：$x_1=1,A_1=1$；$n=2$：$x_{1,2}=2\mp\sqrt2$，$A_{1,2}=\frac14(2\pm\sqrt2)$。

### 6.7.2.3 Gauss–Hermite 求积公式

取权 $\rho(x)=e^{-x^2}$、区间 $(-\infty,\infty)$，正交多项式为 Hermite 多项式

$$
H_n(x)=(-1)^ne^{x^2}\frac{d^n}{dx^n}\left(e^{-x^2}\right).
$$

以 $H_n$ 的零点为节点：

$$
\int_{-\infty}^\infty e^{-x^2}f(x)\,dx\approx\sum_{i=1}^nA_if(x_i),\qquad
A_i=\frac{2^{n+1}n!\sqrt\pi}{\left[H_n'(x_i)\right]^2}.
$$

误差为

$$
R=\frac{n!\sqrt\pi}{2^n(2n)!}f^{(2n)}(\eta),\qquad \eta\in(-\infty,\infty).
$$

常用 $n=1$：$x_1=0,A_1=\sqrt\pi$；$n=2$：$x_{1,2}=\pm1/\sqrt2$，$A_{1,2}=\frac{\sqrt\pi}{2}$。

### 6.7.2.4 Gauss–Chebyshev 求积公式

取权 $\rho(x)=1/\sqrt{1-x^2}$、区间 $[-1,1]$，正交多项式为 Chebyshev 多项式 $T_n(x)=\cos(n\arccos x)$。节点与权有显式公式：

$$
x_i=\cos\frac{(2i-1)\pi}{2n},\qquad A_i=\frac\pi n\quad(i=1,\dots,n).
$$

误差为

$$
R=\frac{2\pi}{2^{2n}(2n)!}f^{(2n)}(\eta),\qquad \eta\in(-1,1).
$$

::: ex 例 6.7.4（教材例 10） · 多项式积分被 Gauss–Chebyshev 精确算出 {#ex-6.7.4}
计算

$$
\int_{-1}^1\frac{f(x)}{\sqrt{1-x^2}}\,dx,
$$

其中 $f(x)$ 是 $m$ 次多项式。

**解** 因 $f$ 的 $m+1$ 阶导数恒为零，取 $n=\lfloor\frac{m+1}{2}\rfloor$ 左右即可使误差为零。具体地：

- $m$ 为奇数时取 $n=\frac{m+1}{2}$，得

$$
\int_{-1}^1\frac{f(x)}{\sqrt{1-x^2}}\,dx
=\frac{2\pi}{m+1}\sum_{i=1}^{\frac{m+1}{2}}f\left(\cos\frac{m+2-2i}{m+1}\pi\right);
$$

- $m$ 为偶数时取 $n=\frac{m+2}{2}$，得

$$
\int_{-1}^1\frac{f(x)}{\sqrt{1-x^2}}\,dx
=\frac{2\pi}{m+2}\sum_{i=1}^{\frac{m+2}{2}}f\left(\cos\frac{m+3-2i}{m+2}\pi\right).
$$

**要点**：只要 $2n>m$，Gauss–Chebyshev 就把 $m$ 次多项式**精确**积出，没有截断误差。
:::

::: ex 例 6.7.5（教材例 11） · 三点 Gauss–Chebyshev 算积分 {#ex-6.7.5}
计算

$$
I=\int_{-1}^1\sqrt{\frac{2+x}{1-x^2}}\,dx .
$$

**解** 取 $n=3$ 的 Gauss–Chebyshev。节点

$$
x_1=\cos\frac{5\pi}{6}=-0.866025403,\quad
x_2=\cos\frac{3\pi}{6}=0,\quad
x_3=\cos\frac{\pi}{6}=0.866025403,
$$

权均为 $\pi/3$。于是

$$
I\approx\frac\pi3\left(\sqrt{2+x_1}+\sqrt{2+x_2}+\sqrt{2+x_3}\right)
=\frac\pi3\left(\sqrt{1.133974597}+2\sqrt2+\sqrt{2.866025403}\right)
\approx4.368939556 .
$$

**读法**：被积函数在 $x=\pm1$ 有奇点，但奇性恰好被权 $1/\sqrt{1-x^2}$ 吸收，所以 Gauss–Chebyshev 仍然高效。这是「选对权」比「选对节点」更重要的例子。
:::

::: note 教材的对比数据：10 个 Gauss 节点 vs 129 个 Simpson 节点
教材对 $I=\int_0^1\frac{dx}{1+x}=0.69314718$ 给出：

- 129 个节点的复化 Simpson：$0.69314670$；
- 10 个节点的 Gauss–Legendre：$0.69314710$。

后者用的节点少一个数量级，结果反而更准。**Gauss 的代价**是节点与权要查表，$n$ 增加时旧节点几乎不能复用；但对光滑函数，这个代价通常值得。
:::

::: method[core] 四族 Gauss 公式速查
| 公式 | 区间 | 权 $\rho(x)$ | 节点 | 权 $A_i$ | 误差主项 |
|:--|:--|:--|:--|:--|:--|
| Legendre | $[-1,1]$ | $1$ | $L_n$ 的零点 | $\frac{2}{(1-x_i^2)[L_n'(x_i)]^2}$ | $\frac{2^{2n+1}(n!)^4}{(2n+1)[(2n)!]^3}f^{(2n)}$ |
| Laguerre | $[0,\infty)$ | $e^{-x}$ | $U_n$ 的零点 | $\frac{(n!)^2}{x_i[U_n'(x_i)]^2}$ | $\frac{(n!)^2}{(2n)!}f^{(2n)}$ |
| Hermite | $(-\infty,\infty)$ | $e^{-x^2}$ | $H_n$ 的零点 | $\frac{2^{n+1}n!\sqrt\pi}{[H_n'(x_i)]^2}$ | $\frac{n!\sqrt\pi}{2^n(2n)!}f^{(2n)}$ |
| Chebyshev | $[-1,1]$ | $\frac1{\sqrt{1-x^2}}$ | $\cos\frac{(2i-1)\pi}{2n}$ | $\frac\pi n$ | $\frac{2\pi}{2^{2n}(2n)!}f^{(2n)}$ |

使用前先问三件事：区间对不对？权对不对？被积函数是否光滑（奇点会不会落在内部）？
:::

::: think[core] 本节常见错误
1. **节点不取正交多项式的根。** 随便取 $n$ 个节点，最高只能到 $n-1$ 次；Gauss 的全部优势来自「节点 = 根」。
2. **权公式的分母漏掉 $g_n'(x_i)$。** 不同族的权公式分母不同，套错族会得到完全错误的权。
3. **忘记区间变换。** Gauss–Legendre 只对 $[-1,1]$ 成立；$[a,b]$ 上要乘 $\frac{b-a}{2}$ 并平移节点。
4. **把权函数当成被积函数的一部分。** Gauss–Laguerre 算的是 $\int e^{-x}f$，不是 $\int f$；如果原积分没有 $e^{-x}$，要先乘除凑出权。
5. **对奇异函数硬套 Gauss。** 奇点在区间内部时，Gauss 的高阶收敛前提被破坏；应拆区间或换带权公式。
6. **以为 $n$ 越大越好。** 节点不能复用，且高阶公式对光滑性要求更高；工程上常用 $n=2\sim10$ 的分段 Gauss。
7. **把 Chebyshev 的权记成 1。** 它的权是 $1/\sqrt{1-x^2}$，节点和权都有显式公式，但只能算带该权的积分。
8. **忘记验证 $\sum A_i=\int\rho$。** 这是最快的自检；不成立说明节点、权或区间变换至少错了一处。
:::

::: note 覆盖核对
本节覆盖教材 6.7.1–6.7.2、定理 6.5–6.8、例 7–11。下一节：[6.8 二重积分的数值求积法](sec68.md)。
:::
