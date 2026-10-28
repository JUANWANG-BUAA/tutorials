# 5.5–5.6 正交多项式与最佳平方逼近

> 对应教材 5.5.1–5.5.2、5.6.1–5.6.3、定理 5.6–5.8（原书 p.119–133）。
> **第 11 讲（10-21）已系统讲授内积空间、正交投影、法方程、Gram–Schmidt 与 Legendre 多项式**，
> **第 12 讲（10-26）继续讲四族正交多项式、零点定理、离散内积与最小二乘拟合**，
> 课堂实录见[第 11 讲](../../lectures/lec11.md)、[第 12 讲](../../lectures/lec12.md)；本页按教材补齐课堂未展开的细节
> （正交多项式性质、Chebyshev / Laguerre / Hermite 的细节、Legendre 级数、样条应用、5.6.4 曲线拟合）。
> 课堂例题是 $f(x)=\sqrt{x}$ 在 $[0,1]$ 上的一次最佳平方逼近，正是教材例 8。

<a id="sec-5.5.1"></a>
## 5.5.1 正交多项式概念与性质

### 权函数与内积

设 $\rho(x)$ 是区间 $(a,b)$ 上的非负函数，满足

1. 对一切非负整数 $k$，$\displaystyle\int_a^b x^k\rho(x)\,dx$ 存在；
2. 若 $f$ 非负连续且 $\displaystyle\int_a^b\rho(x)f(x)\,dx=0$，则在 $(a,b)$ 上 $f\equiv0$。

::: def 定义 5.5.1 · 权函数 {#def-5.5.1}
则称 $\rho$ 为**权函数**。常见的权函数：

| 区间 | 权 $\rho(x)$ |
|:--|:--|
| $[a,b]$ | $1$ |
| $[-1,1]$ | $1/\sqrt{1-x^2}$（Chebyshev） |
| $[0,\infty)$ | $e^{-x}$（Laguerre） |
| $(-\infty,\infty)$ | $e^{-x^2}$（Hermite） |
:::

对 $f,g\in C[a,b]$，定义内积
$$
(f,g)=\int_a^b\rho(x)f(x)g(x)\,dx .
$$

::: def 定义 5.5.2 · 带权内积 {#def-5.5.2}
上式称为 $[a,b]$ 上**带权 $\rho$ 的内积**。它满足四条公理（第 11 讲 §二.1 先在 $\mathbb R^n$ 上写 $(x,y)=x_1y_1+\cdots+x_ny_n$，再照搬到函数空间）：
$$
\begin{aligned}
(1)&\quad (f,g)=(g,f),\\
(2)&\quad (kf,g)=(f,kg)=k(f,g),\\
(3)&\quad (f_1+f_2,g)=(f_1,g)+(f_2,g),\\
(4)&\quad f\not\equiv0\ \text{在}\ [a,b]\ \text{上}\ \Rightarrow\ (f,f)>0 .
\end{aligned}
$$
函数空间的第 (4) 条写成 $(f,f)=\int_a^b\rho(x)f^2(x)\,dx\ge0$，且 $(f,f)=0\iff f=0$（在连续意义下）。由内积定义范数 $\lVert f\rVert=\sqrt{(f,f)}$ 与距离 $d(f,g)=\lVert f-g\rVert$，并满足 Cauchy–Schwarz 不等式 $\lvert(f,g)\rvert\le\lVert f\rVert\lVert g\rVert$ 与三角不等式 $\lVert f+g\rVert\le\lVert f\rVert+\lVert g\rVert$。
:::

::: note 老师强调 · 函数空间里的「1」是常值函数，不是数 1（第 11 讲 §二.1）
$a$ 是数，$f,g,1,x$ 是向量（函数）。把「$a\cdot1$」里的 $1$ 当成数，是这一节最常见的符号错误——老师在这一处停了很久，专门纠正符号混淆。
:::

::: def 定义 5.5.3 · 正交函数系与正交多项式系 {#def-5.5.3}
若 $(f,g)=0$，称 $f$ 与 $g$ 在 $[a,b]$ 上**带权 $\rho$ 正交**。若函数系 $\{\varphi_k\}$ 满足
$$
(\varphi_i,\varphi_j)=\int_a^b\rho(x)\varphi_i(x)\varphi_j(x)\,dx
=
\begin{cases}
0,&i\ne j,\\
>0,&i=j,
\end{cases}
$$
则称 $\{\varphi_k\}$ 是 $[a,b]$ 上带权 $\rho$ 的**正交函数系**。若每个 $\varphi_k$ 是 $k$ 次多项式，则称为**正交多项式系**。
:::

正交函数系一定线性无关：若 $\sum c_k\varphi_k=0$，与 $\varphi_j$ 作内积得 $c_j(\varphi_j,\varphi_j)=0$，故 $c_j=0$。

### 定理 5.6（正交多项式系的刻画）

::: thm 定理 5.6 · 正交多项式系的刻画 {#thm-5.6}
设 $\deg\varphi_k=k$。则 $\{\varphi_k\}$ 是 $[a,b]$ 上带权 $\rho$ 的正交多项式系，当且仅当对任意次数 $\le k-1$ 的多项式 $q$，
$$
\int_a^b\rho(x)q(x)\varphi_k(x)\,dx=0,\qquad k=1,2,\dots
$$
:::

::: proof 证明要点
必要性——$q$ 可写成 $\varphi_0,\dots,\varphi_{k-1}$ 的线性组合（同空间、次数匹配），逐项正交；充分性——取 $q=\varphi_j$（$j<k$）即得 $(\varphi_j,\varphi_k)=0$。
:::

### 正交多项式的四条性质

1. **常数倍**：若 $\{\varphi_k\}$ 正交，$c_k\ne0$，则 $\{c_k\varphi_k\}$ 仍正交。
2. **首一唯一**：在首项系数为 $1$ 的正交多项式系中，每个 $\varphi_k$ 唯一。
3. **零点**：$k\ge1$ 时，$\varphi_k$ 在 $(a,b)$ 内有 $k$ 个互异实零点（完整表述与证明见下面的零点定理）。
4. **三项递推（首一情形）**：
$$
p_{k+1}(x)=(x-\alpha_k)p_k(x)-\beta_kp_{k-1}(x),
$$
其中
$$
\alpha_k=\frac{(xp_k,p_k)}{(p_k,p_k)},\qquad
\beta_k=\frac{(p_k,p_k)}{(p_{k-1},p_{k-1})}.
$$

性质 3 的证明思路：若奇重零点少于 $k$ 个，令 $q$ 为这些零点之积，则 $q\varphi_k$ 在 $(a,b)$ 内不变号且不恒为零，故 $\int\rho q\varphi_k\ne0$，与定理 5.6 矛盾。

::: thm 定理 · 正交多项式的零点定理（第 12 讲 §三） {#thm-op-zeros}
设 $(f,g)=\displaystyle\int_a^b\rho(x)f(x)g(x)\,dx$，$\varphi_0,\varphi_1,\dots,\varphi_n$ 是 $[a,b]$ 上带权 $\rho$ 的正交多项式系，则 $\varphi_k(x)$ 在 $(a,b)$ 内恰有 $k$ 个**互异实**零点。「互异」与「实」不能漏，否则定理不成立（复根、重根都不允许）。
:::

::: proof[skip] 零点定理的证明思路（第 12 讲 §三.2，课堂只讲思路）
反证。设 $\varphi_k$ 在 $(a,b)$ 内**变号**的零点（奇重零点）只有 $r<k$ 个，记为 $t_1,\dots,t_r$。令
$$
q(x)=\prod_{j=1}^{r}(x-t_j),
$$
则 $q$ 是 $r<k$ 次多项式，且 $q(x)\varphi_k(x)$ 在 $(a,b)$ 内**不变号**（每穿过一个奇重零点，$q\varphi_k$ 的符号恰好被 $q$ 翻回来），又不恒为零，于是
$$
\int_a^b\rho(x)q(x)\varphi_k(x)\,dx\ne0 .
$$
但 $\deg q=r<k$，由定理 5.6（$\varphi_k$ 与一切次数 $<k$ 的多项式正交），上式必须为 $0$，矛盾。故奇重零点至少有 $k$ 个；而 $\deg\varphi_k=k$，零点总数不超过 $k$，所以恰有 $k$ 个互异实零点。
:::

::: note 零点定理为什么重要（第 12 讲 §三.3）
下一章 Gauss 求积要选 $n+1$ 个节点使代数精度达到 $2n+1$，取的正是 $n+1$ 次正交多项式的 $n+1$ 个零点。零点定理保证了「$n+1$ 个节点互异且落在区间内部」——这是 Gauss 公式成立的前提。
:::

### Gram–Schmidt 构造

幂函数系 $\{1,x,x^2,\dots\}$ 在任何区间上线性无关，可用 Gram–Schmidt 正交化：

::: def 定义 5.5.4 · Gram–Schmidt 正交化 {#def-5.5.4}
$$
\psi_0=1,\qquad
\psi_k=x^k-\sum_{j=0}^{k-1}
\frac{(x^k,\psi_j)}{(\psi_j,\psi_j)}\,\psi_j,
\qquad k=1,2,\dots
$$
得到的 $\psi_k$ 是首项系数为 $1$ 的 $k$ 次正交多项式。若改用其他权或区间，只需换内积。
:::

::: thm 定理 · 正交化后次数不降（第 11 讲 §五.4） {#thm-orth-degree}
$1,x,\dots,x^n$ 经过 $(f,g)=\int_a^b\rho fg\,dx$ 正交化得到的 $\psi_0,\psi_1,\dots,\psi_n$ 中，$\psi_k$ 仍然是 $k$ 次多项式。
:::

::: proof 证明
$\psi_k$ 是 $\varphi_0,\dots,\varphi_k$ 的线性组合，且 $\varphi_k$（即 $x^k$）的系数为 $1$，减去的是次数 $<k$ 的项，所以
$$
\psi_k(x)=x^k+\text{低次项},
$$
仍是 $k$ 次多项式。这正是「正交多项式」一词的来历：正交化后仍是一串次数递增的多项式。
:::

::: proof 正交性的归纳验证（第 11 讲 §五.3）
设 $\psi_0,\dots,\psi_{k-1}$ 已两两正交。对 $m<k$，
$$
(\psi_k,\psi_m)=(x^k,\psi_m)-\frac{(x^k,\psi_m)}{(\psi_m,\psi_m)}(\psi_m,\psi_m)=0,
$$
其余 $j\ne m$ 的项由 $(\psi_j,\psi_m)=0$ 消去。所以 $\psi_k$ 与所有前面的 $\psi_m$ 正交。且正交化不改变张成的子空间：$\operatorname{span}\{\psi_0,\dots,\psi_k\}=\operatorname{span}\{1,x,\dots,x^k\}$。
:::

<a id="sec-5.5.2"></a>
## 5.5.2 几种常用的正交多项式

### Legendre 多项式

::: def 定义 5.5.5 · Legendre 多项式 {#def-5.5.5}
$$
L_n(x)=\frac{1}{2^nn!}\frac{d^n}{dx^n}\bigl(x^2-1\bigr)^n,
\qquad -1\le x\le1 .
$$
区间 $[-1,1]$、权 $\rho=1$。
:::

**正交性**：
$$
\int_{-1}^{1}L_n(x)L_m(x)\,dx
=\frac{2}{2n+1}\delta_{nm}.
$$

**性质**：

- 首项系数 $a_n=\dfrac{(2n)!}{2^n(n!)^2}$；
- 奇偶性 $L_n(-x)=(-1)^nL_n(x)$；
- 递推 $(n+1)L_{n+1}=(2n+1)xL_n-nL_{n-1}$；
- 前几个：
$$
L_0=1,\quad L_1=x,\quad
L_2=\frac12(3x^2-1),\quad
L_3=\frac12(5x^3-3x),\quad
L_4=\frac18(35x^4-30x^2+3).
$$

::: note 归一化提醒（第 11 讲 §五.5）
Gram–Schmidt 若保持首项系数为 $1$，得到的是「首一正交多项式」；Legendre 多项式 $L_n$ 的首项系数是 $\dfrac{(2n)!}{2^n(n!)^2}$，与首一形式相差一个常数倍。正交性不受非零常数倍影响（性质 1），所以两者是同一组正交方向的不同刻度；写公式时要说明用的是哪一种。
:::

### Chebyshev 多项式

::: def 定义 5.5.6 · Chebyshev 多项式 {#def-5.5.6}
$$
T_n(x)=\cos(n\arccos x),\qquad -1\le x\le1,
$$
带权 $\rho(x)=1/\sqrt{1-x^2}$ 正交：
$$
\int_{-1}^{1}\frac{T_n(x)T_m(x)}{\sqrt{1-x^2}}\,dx
=
\begin{cases}
0,&n\ne m,\\
\pi/2,&n=m\ne0,\\
\pi,&n=m=0.
\end{cases}
$$
:::

::: proof 板书现场推导（第 12 讲 §2.2，本页最完整的一段换元）
令 $x=\cos\theta$，则 $\theta=\arccos x$，$dx=-\sin\theta\,d\theta$，且 $\sqrt{1-x^2}=\sin\theta$：
$$
(T_m,T_n)=\int_{-1}^{1}\frac{\cos(m\arccos x)\cos(n\arccos x)}{\sqrt{1-x^2}}\,dx
=\int_{0}^{\pi}\cos m\theta\,\cos n\theta\,d\theta .
$$
用积化和差 $\cos m\theta\cos n\theta=\dfrac12\bigl[\cos(m+n)\theta+\cos(m-n)\theta\bigr]$：
$$
(T_m,T_n)=\frac12\int_{0}^{\pi}\bigl[\cos(m+n)\theta+\cos(m-n)\theta\bigr]\,d\theta
=\begin{cases}
0,&m\ne n,\\[2pt]
\dfrac{\pi}{2},&m=n\ne0,\\[2pt]
\pi,&m=n=0.
\end{cases}
$$
**权为什么是 $1/\sqrt{1-x^2}$**：换元带来的 $dx=-\sin\theta\,d\theta$ 里有 $\sin\theta$，权取 $1/\sqrt{1-x^2}$ 正好抵消它，化成 $\int_0^\pi\cos m\theta\cos n\theta\,d\theta$。权不是「配着好看」，是被区间与换元逼出来的。
:::

同一个换元写出前几个 $T_n$：
$$
\begin{aligned}
T_0(\cos\theta)&=\cos 0=1 &&\Rightarrow T_0(x)=1,\\
T_1(\cos\theta)&=\cos\theta &&\Rightarrow T_1(x)=x,\\
T_2(\cos\theta)&=\cos 2\theta=2\cos^2\theta-1 &&\Rightarrow T_2(x)=2x^2-1,\\
T_3(\cos\theta)&=\cos 3\theta=4\cos^3\theta-3\cos\theta &&\Rightarrow T_3(x)=4x^3-3x .
\end{aligned}
$$

**性质**：

- $n\ge1$ 时首项系数 $2^{n-1}$；
- 递推 $T_{n+1}=2xT_n-T_{n-1}$（由 $\cos(n+1)\theta+\cos(n-1)\theta=2\cos\theta\cos n\theta$ 得到）；
- 零点 $x_i=\cos\dfrac{(2i-1)\pi}{2n}$，$i=1,\dots,n$——正是 [5.1](sec51.md) Runge 现象里「端点附近加密」的那类节点。

::: note Chebyshev 换元只对 $[-1,1]$ 成立（第 12 讲 §七）
$x=\cos\theta$ 把 $[-1,1]$ 映到 $[0,\pi]$，$\sqrt{1-x^2}=\sin\theta$；换区间要先线性变换到 $[-1,1]$。
:::

### Laguerre 与 Hermite 多项式

| 名称 | 区间 | 权 | 定义 | 正交性 |
|:--|:--|:--|:--|:--|
| Laguerre | $[0,\infty)$ | $e^{-x}$ | $U_n(x)=e^x\dfrac{d^n}{dx^n}(x^ne^{-x})$ | $\displaystyle\int_0^\infty e^{-x}U_nU_m\,dx=(n!)^2\delta_{nm}$ |
| Hermite | $(-\infty,\infty)$ | $e^{-x^2}$ | $H_n(x)=(-1)^ne^{x^2}\dfrac{d^n}{dx^n}e^{-x^2}$ | $\displaystyle\int_{-\infty}^{\infty}e^{-x^2}H_nH_m\,dx=2^nn!\sqrt{\pi}\,\delta_{nm}$ |

### 四族一览

::: method[core] 四族经典正交多项式（第 12 讲 §2.4 板书汇总）

| 名称 | 区间 | 权 $\rho(x)$ | 生成公式 | 正交性常数 |
|:--|:--|:--|:--|:--|
| Legendre | $[-1,1]$ | $1$ | $L_n=\dfrac{1}{2^nn!}\dfrac{d^n}{dx^n}(x^2-1)^n$ | $\dfrac{2}{2n+1}$ |
| Chebyshev | $[-1,1]$ | $\dfrac{1}{\sqrt{1-x^2}}$ | $T_n=\cos(n\arccos x)$ | $\dfrac{\pi}{2}$（$n\ne0$）、$\pi$（$n=0$） |
| Laguerre | $[0,\infty)$ | $e^{-x}$ | $U_n=e^x\dfrac{d^n}{dx^n}(x^ne^{-x})$ | $(n!)^2$ |
| Hermite | $(-\infty,\infty)$ | $e^{-x^2}$ | $H_n=(-1)^ne^{x^2}\dfrac{d^n}{dx^n}e^{-x^2}$ | $2^nn!\sqrt{\pi}$ |

**老师强调**：四族的「区间 + 权」是一套的，写公式必须连区间与权一起写。
:::

<a id="sec-5.6"></a>
## 5.6 函数的最佳平方逼近

### 5.6.1 概念与解法

设 $\varphi_0,\dots,\varphi_n\in C[a,b]$ 线性无关，
$$
H_n=\operatorname{span}\{\varphi_0,\dots,\varphi_n\},
\qquad
p(x)=\sum_{j=0}^{n}c_j\varphi_j(x).
$$

对 $f\in C[a,b]$，若 $p^*\in H_n$ 满足
$$
(f-p^*,f-p^*)=\min_{p\in H_n}(f-p,f-p),
$$

::: def 定义 5.6.1 · 最佳平方逼近元素 {#def-5.6.1}
则称 $p^*$ 为 $f$ 在 $H_n$ 中的**最佳平方逼近元素**。若 $\varphi_j=x^j$，则称为 $n$ 次最佳平方逼近多项式。
:::

::: intuition 直觉 · 最佳逼近就是投影（第 11 讲 §二.3）
板书在 $\mathbb R^n$ 里画投影图：$P$ 是空间中的向量，$\bar P$ 是它在平面 $V$ 上的投影，则
$$
\lVert P-\bar P\rVert=\min_{Q\in V}\lVert P-Q\rVert,
\qquad
P-\bar P\perp V .
$$
「垂直于整个子空间」等价于「垂直于每个基向量」。把 $P$ 换成 $f$、$\bar P$ 换成 $p$、$V_i$ 换成 $\varphi_i$，就得到函数空间的最佳逼近条件：
$$
\boxed{\;f-p\perp M
\iff (f-p,\varphi_i)=0,\quad i=0,\dots,n\;}
$$
**最佳逼近的几何图像是投影**：$f-p$ 垂直于整个子空间，不只是垂直于某一个基函数。
:::

::: thm 定理 5.7 · 最佳平方逼近的刻画 {#thm-5.7}
$p^*$ 是最佳平方逼近元素，当且仅当
$$
(f-p^*,\varphi_j)=0,\qquad j=0,\dots,n .
$$
等价地，对任意 $p\in H_n$，$(f-p^*,p)=0$。
:::

::: proof 证明要点
必要性用反证——若某个 $(f-p^*,\varphi_k)=\delta_k\ne0$，取 $q=p^*+\dfrac{\delta_k}{(\varphi_k,\varphi_k)}\varphi_k$，则
$$
(f-q,f-q)=(f-p^*,f-p^*)-\frac{\delta_k^2}{(\varphi_k,\varphi_k)}
<(f-p^*,f-p^*),
$$
矛盾。充分性——对任意 $p\in H_n$，
$$
(f-p,f-p)=(f-p^*,f-p^*)+(p^*-p,p^*-p)\ge(f-p^*,f-p^*).
$$
:::

**法方程**：令 $p^*=\sum c_k\varphi_k$，投影条件化为
$$
\sum_{k=0}^{n}(\varphi_k,\varphi_j)c_k=(f,\varphi_j),
\qquad j=0,\dots,n .
$$

::: def 定义 5.6.2 · 法方程与 Gram 矩阵 {#def-5.6.2}
写成矩阵
$$
G\boldsymbol c=\boldsymbol b,\qquad
G_{ij}=(\varphi_i,\varphi_j),\quad b_i=(f,\varphi_i).
$$
$G$ 是 Gram 矩阵（第 11 讲板书写作 $A$，并注明 $A_{ij}=(\varphi_i,\varphi_j)$），对称正定；$\{\varphi_i\}$ 线性无关保证 $G$ 非奇异，故解存在唯一。
:::

::: proof 证明 · Gram 矩阵非奇异（第 11 讲 §三.2 课堂反证法）
假设 $G\boldsymbol c=0$ 且 $\boldsymbol c=(c_0,\dots,c_n)^{\mathrm T}\ne0$。则对每个 $i$，
$$
\sum_{j=0}^{n}(\varphi_i,\varphi_j)c_j=0
\iff
\Big(\varphi_i,\sum_{j=0}^{n}c_j\varphi_j\Big)=0 .
$$
第 $i$ 个方程乘以 $c_i$，再对 $i$ 求和：
$$
0=\sum_{i=0}^{n}c_i\Big(\varphi_i,\sum_{j=0}^{n}c_j\varphi_j\Big)
=\Big(\sum_{i=0}^{n}c_i\varphi_i,\sum_{j=0}^{n}c_j\varphi_j\Big)
=\Big\lVert\sum_{i=0}^{n}c_i\varphi_i\Big\rVert^2 .
$$
所以 $\sum_i c_i\varphi_i=0$。但 $\{\varphi_i\}$ 线性无关，故 $c_0=\cdots=c_n=0$，与 $\boldsymbol c\ne0$ 矛盾。因此 $G$ 非奇异。$\blacksquare$
:::

::: note 一句话版本：$G$ 正定
对任意 $\boldsymbol c\ne0$，$\boldsymbol c^{\mathrm T}G\boldsymbol c=\lVert\sum c_i\varphi_i\rVert^2>0$。这是教材 5.6 的写法，和板书的「乘 $c_i$ 求和」是同一件事。**Gram 矩阵非奇异不是显然的**：要用内积正定性 + 基函数线性无关，不能因为「看起来像内积表」就默认可逆。
:::

::: thm 定理 5.8 · 最佳平方逼近元素的唯一性 {#thm-5.8}
最佳平方逼近元素唯一。
:::

::: proof 证明（第 11 讲 §三.3）
若 $p,q$ 都是最佳逼近，则 $f-p\perp M$ 且 $f-q\perp M$，所以
$$
(p-q,p-q)=(p-f+f-q,p-q)=0+0=0,
$$
故 $p=q$。$\blacksquare$
:::

**误差公式**：
$$
\lVert f-p^*\rVert^2=(f,f)-\sum_{k=0}^{n}c_k(f,\varphi_k).
$$

若基还是正交的，则进一步化为
$$
\lVert f-p^*\rVert^2=(f,f)-\sum_{k=0}^{n}\frac{(f,\varphi_k)^2}{(\varphi_k,\varphi_k)} .
$$

### 5.6.2 正交函数系的应用

若 $\{\varphi_k\}$ 两两正交，法方程解耦：
$$
c_k=\frac{(f,\varphi_k)}{(\varphi_k,\varphi_k)} .
$$

::: note 老师反复说 · 「我们最希望 $A$ 是对角阵」（第 11 讲 §三.4、§五.1；第 12 讲 §一.1）
若 $G$ 对角，$a_i=(f,\varphi_i)/(\varphi_i,\varphi_i)$，不用解耦合方程——每个系数单独算，误差公式也随之简化。Gram–Schmidt 就是把任意基变成这样的正交基的标准算法；第 12 讲把它落成两行：
$$
a_i=\frac{(f,\varphi_i)}{(\varphi_i,\varphi_i)},\qquad
\lVert f-p\rVert^2=(f,f)-\sum_{i=0}^{n}\frac{(f,\varphi_i)^2}{(\varphi_i,\varphi_i)},\qquad i=0,\dots,n .
$$
:::

::: note 两种「换基让矩阵变简单」的对照（第 12 讲 §1.3）
插值的 Lagrange 基在**节点上**是单位阵（$l_i(x_j)=\delta_{ij}$，且 $\sum_i l_i(x)=1$）；正交基在**内积下**是对角阵——都是「换基让矩阵变简单」，只是标准不同。
:::

**Legendre 展开**：在 $[-1,1]$、权 $1$ 下，
$$
c_k=\frac{2k+1}{2}\int_{-1}^{1}f(x)L_k(x)\,dx,
\qquad
p_n(x)=\sum_{k=0}^{n}c_kL_k(x).
$$

若区间为 $[a,b]$，先作变量替换
$$
x=\frac{a+b}{2}+\frac{b-a}{2}t,
\qquad -1\le t\le1 .
$$

::: ex 例 8（教材 5.6.2） · $\sqrt{x}$ 的一次最佳平方逼近（课堂例题） {#ex-5.6.8}
求 $f(x)=\sqrt{x}$ 在 $[0,1]$ 上的一次最佳平方逼近多项式。

**课堂路线（第 11 讲 §四：直接在 $[0,1]$ 上列法方程）**：设 $p=a+bx$，投影条件为 $(f-p,1)=0$、$(f-p,x)=0$。内积计算：
$$
(1,1)=1,\quad (1,x)=\frac12,\quad (x,x)=\frac13,\quad
(f,1)=\int_0^1x^{1/2}\,dx=\frac23,\quad (f,x)=\int_0^1x^{3/2}\,dx=\frac25 .
$$
法方程
$$
\begin{pmatrix}1&\frac12\\[2pt]\frac12&\frac13\end{pmatrix}
\begin{pmatrix}a\\b\end{pmatrix}
=
\begin{pmatrix}\frac23\\[2pt]\frac25\end{pmatrix},
\qquad
\det G=\frac1{12}.
$$
解得
$$
a=\frac{\frac23\cdot\frac13-\frac12\cdot\frac25}{1/12}
=\frac{\frac29-\frac15}{1/12}=\frac{4}{15},\qquad
b=\frac{1\cdot\frac25-\frac12\cdot\frac23}{1/12}
=\frac{\frac25-\frac13}{1/12}=\frac45.
$$
验证与误差：
$$
(f-p,1)=0,\qquad (f-p,x)=0,
$$
$$
\lVert f-p\rVert^2=(f,f)-2(f,p)+(p,p)
=\frac12-2\cdot\frac{112}{225}+\frac{112}{225}
=\frac12-\frac{112}{225}=\frac1{450},
\qquad
\lVert f-p\rVert=\frac{1}{\sqrt{450}}\approx0.04714 .
$$
注意 $p(0)=4/15\approx0.267$、$p(1)=16/15\approx1.067$：**最佳平方逼近在端点可以明显偏离，它不是插值，不要求过点**——这是「逼近」与「插值」的第一区别。

**用正交基再算一遍（第 11 讲 §四.5）**：在 $[0,1]$ 上把 $\{1,x\}$ 正交化，$\psi_0=1$，$\psi_1=x-\frac12$，则
$$
(f,\psi_0)=\frac23,\ (\psi_0,\psi_0)=1\Rightarrow c_0=\frac23;\qquad
(f,\psi_1)=\frac25-\frac12\cdot\frac23=\frac1{15},\
(\psi_1,\psi_1)=\frac1{12}\Rightarrow c_1=\frac45 .
$$
于是 $p=c_0\psi_0+c_1\psi_1=\frac23+\frac45\bigl(x-\frac12\bigr)=\frac{4}{15}+\frac45x$。同一个结果，**不用解 $2\times2$ 方程组**，两个系数各算各的。维数越高，这个优势越大。

**教材路线（先换到 $[-1,1]$，再用 Legendre 基）**：令 $x=\dfrac{1+t}{2}$，则 $f(x)=\sqrt{\dfrac{1+t}{2}}=\varphi(t)$。在 $[-1,1]$ 上，
$$
c_0=\frac12\int_{-1}^{1}\sqrt{\frac{1+t}{2}}\,dt=\frac23,
$$
$$
c_1=\frac32\int_{-1}^{1}t\sqrt{\frac{1+t}{2}}\,dt
=\frac32\cdot\frac{4}{15}=\frac25 .
$$
（第二式令 $u=\dfrac{1+t}{2}$，则 $t=2u-1$，$dt=2du$，积分为
$2\displaystyle\int_0^1(2u-1)u^{1/2}du
=2\Bigl(\frac45-\frac23\Bigr)=\frac{4}{15}$。）

因此
$$
q_1(t)=\frac23L_0(t)+\frac25L_1(t)=\frac23+\frac25t .
$$
代回 $t=2x-1$：
$$
p(x)=\frac23+\frac25(2x-1)
=\frac{4}{15}+\frac45x
=\frac{4}{15}+\frac{12}{15}x .
$$
**课堂与教材的差别只在路线**：课堂直接在 $[0,1]$ 上列法方程；教材先换到 $[-1,1]$，再用 Legendre 基。两条路算的是同一个多项式。
:::

::: ex 例 7（教材 5.6.2） · $\mathrm e^x$ 的三次 Legendre 最佳平方逼近 {#ex-5.6.7}
在 $[-1,1]$、权 $1$ 下把 $f(x)=\mathrm e^x$ 按 Legendre 基展开到三次。由
$$
c_k=\frac{2k+1}{2}\int_{-1}^{1}f(x)L_k(x)\,dx
$$
逐项计算（$\int_{-1}^1\mathrm e^x\,dx=\mathrm e-\mathrm e^{-1}$，$\int_{-1}^1x\mathrm e^x\,dx=\frac2{\mathrm e}$，$\int_{-1}^1x^2\mathrm e^x\,dx=\mathrm e-\frac5{\mathrm e}$，$\int_{-1}^1x^3\mathrm e^x\,dx=-2\mathrm e+\frac{16}{\mathrm e}$）：
$$
c_0=\frac12\Bigl(\mathrm e-\frac1{\mathrm e}\Bigr),\qquad
c_1=\frac3{\mathrm e},\qquad
c_2=\frac52\Bigl(\mathrm e-\frac7{\mathrm e}\Bigr),\qquad
c_3=\frac72\Bigl(-5\mathrm e+\frac{37}{\mathrm e}\Bigr).
$$
于是
$$
p_3(x)=c_0L_0+c_1L_1+c_2L_2+c_3L_3
\approx0.996294+0.997970x+0.536721x^2+0.176113x^3 .
$$
**读法**：偶函数信息进偶次项、奇函数信息进奇次项；$c_3$ 虽小但非零——$\mathrm e^x$ 不是多项式，Legendre 级数要无穷项才精确，最佳平方逼近给的是「$L^2$ 意义下最优的截断」。
:::

::: ex 例 9（教材 5.6.2） · $\arcsin x$ 的 Chebyshev 展开 {#ex-5.6.9}
把 $f(x)=\arcsin x$ 按 Chebyshev 基展开。用 $x=\cos\theta$ 换元（$\arcsin x=\frac\pi2-\theta$，$\frac{dx}{\sqrt{1-x^2}}=-d\theta$）：
$$
c_k=\frac{2}{\pi}\int_{-1}^{1}\frac{\arcsin x\,T_k(x)}{\sqrt{1-x^2}}\,dx
=\frac{2}{\pi}\int_0^{\pi}\Bigl(\frac\pi2-\theta\Bigr)\cos k\theta\,d\theta .
$$
$k=0$ 时 $c_0=\frac\pi2$；$k\ge1$ 时 $\int_0^\pi\cos k\theta\,d\theta=0$，而
$$
\int_0^{\pi}\theta\cos k\theta\,d\theta
=\Bigl[\frac{\theta\sin k\theta}{k}+\frac{\cos k\theta}{k^2}\Bigr]_0^\pi
=\frac{(-1)^k-1}{k^2}
=\begin{cases}0,&k\ \text{偶},\\-2/k^2,&k\ \text{奇}.\end{cases}
$$
所以
$$
\arcsin x=\frac\pi2-\frac4\pi\sum_{\substack{k\ge1\\ k\ \text{奇}}}\frac{T_k(x)}{k^2}
=\frac4\pi\Bigl(T_1(x)+\frac{T_3(x)}9+\frac{T_5(x)}{25}+\frac{T_7(x)}{49}+\cdots\Bigr).
$$
截到 $n=7$：
$$
\arcsin x\approx\frac4\pi\Bigl(x+\frac{4x^3-3x}{9}+\frac{16x^5-20x^3+5x}{25}
+\frac{64x^7-112x^5+56x^3-7x}{49}\Bigr).
$$
**读法**：系数按 $1/k^2$ 衰减——Chebyshev 展开对光滑函数收敛很快；这与 [5.1](sec51.md) 的 Chebyshev 节点（零点 $x_i=\cos\frac{(2i-1)\pi}{2n}$）是同一族多项式的两种用法。
:::

::: note 最佳一致逼近（本编补充，教材 5.6 不展开；第 11 讲 §六.5）
在 $C[a,b]$ 中使 $\lVert f-p_n\rVert_\infty=\max_{a\le x\le b}\lvert f(x)-p_n(x)\rvert$ 最小，称为最佳一致逼近。Chebyshev 交替定理给出特征：误差在 $n+2$ 个点交替取 $\pm\lVert f-p_n\rVert_\infty$。这与本节的 $L^2$ 逼近是两套不同的度量，不要混用。
:::

### 5.6.3 样条函数在最佳平方逼近中的应用

教材 5.6.3 把基函数换成 B 样条，得到分片光滑的最佳平方逼近。它的法方程仍是 $G\boldsymbol c=\boldsymbol b$，只是 $G$ 变成带状稀疏矩阵；正交化不再适用，但稀疏性使大规模求解可行。三次样条的构造见[5.3 三次样条插值](sec53.md)。

<a id="sec-5.6.4"></a>
## 5.6.4 曲线拟合与曲面拟合

给定数据 $(x_i,y_i)$，$i=1,\dots,m$，选一组基函数 $\varphi_0,\dots,\varphi_n$，令
$$
p(x)=\sum_{k=0}^n c_k\varphi_k(x),
$$
使残差平方和
$$
Q(c_0,\dots,c_n)=\sum_{i=1}^m\left(y_i-\sum_{k=0}^n c_k\varphi_k(x_i)\right)^2
$$
最小。写成矩阵形式：$A_{ik}=\varphi_k(x_i)$，$\boldsymbol y=(y_1,\dots,y_m)^{\mathrm T}$，则
$$
Q=\lVert A\boldsymbol c-\boldsymbol y\rVert_2^2.
$$

::: note 最小二乘就是离散内积下的最佳平方逼近（第 12 讲 §四）
把内积换成**求和**：$(f,g)=\sum_i f(x_i)g(x_i)$（带权则是 $\sum_i\omega_i f(x_i)g(x_i)$，$\omega_i>0$）。四条公理照搬：对称、齐次、加法都是求和的性质；正定性要求「若 $\sum_i f^2(x_i)=0$ 则 $f$ 在所有节点上为 $0$」——这只是「在节点上为零」，不是「恒为零」。在离散内积下把「函数」看成向量 $\boldsymbol f=(f(x_0),\dots,f(x_m))^{\mathrm T}$，内积就是 $\boldsymbol f^{\mathrm T}\boldsymbol g$，第 11 讲的投影图与法方程**原封不动**：
$$
G\boldsymbol a=\boldsymbol b,\qquad
G_{ij}=(\varphi_i,\varphi_j)=\sum_{k=0}^{m}\varphi_i(x_k)\varphi_j(x_k),\quad
b_i=(f,\varphi_i)=\sum_{k=0}^{m}f(x_k)\varphi_i(x_k).
$$
**最小二乘拟合**就是「取 $\varphi_j=x^j$、用离散内积」的最佳平方逼近——名字变了，数学没变。
:::

::: def 定义 5.6.3 · 离散内积 {#def-5.6.3}
$$
(f,g)=\sum_{i=0}^{m}f(x_i)g(x_i)
$$
称为**离散内积**。为说明求和确实是内积，可把 $f,g$ 在节点上用 Lagrange 基展开后按节点合并同类项：
$$
(f+g,h)=\bigl[f(x_0)+g(x_0)\bigr]h(x_0)+\bigl[f(x_1)+g(x_1)\bigr]h(x_1)+\cdots=(f,h)+(g,h),
$$
对称性与齐次性同理。连续内积与离散内积的对照：

| | 连续内积 | 离散内积 |
|:--|:--|:--|
| 定义 | $(f,g)=\int_a^b\rho fg\,dx$ | $(f,g)=\sum_i f(x_i)g(x_i)$ |
| 「向量」 | 函数本身 | $(f(x_0),\dots,f(x_m))$ |
| 正定性的「零」 | $f\equiv0$ | $f$ 在所有节点为 $0$ |
| 典型问题 | 最佳平方逼近 | 最小二乘曲线拟合 |
| 法方程 | $G\boldsymbol a=\boldsymbol b$ | $G\boldsymbol a=\boldsymbol b$（同一个） |
:::

::: thm 定理（5.6.4 法方程） · 最小二乘解的充要条件 {#thm-ls-normal}
$\boldsymbol c$ 是最小二乘解的充要条件是
$$
A^{\mathrm T}A\boldsymbol c=A^{\mathrm T}\boldsymbol y.
$$
若 $A$ 列满秩，则 $A^{\mathrm T}A$ 对称正定，最小二乘解唯一：
$$
\boldsymbol c=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol y.
$$
:::

::: proof 证明
必要性由对每个系数求导，得到 $A^{\mathrm T}(A\boldsymbol c-\boldsymbol y)=0$。充分性无需假设满秩：若 $\boldsymbol r=\boldsymbol y-A\boldsymbol c$ 与 $A$ 每列正交，则对任意改变量 $\boldsymbol d$，
$$\|\boldsymbol y-A(\boldsymbol c+\boldsymbol d)\|_2^2=\|\boldsymbol r-A\boldsymbol d\|_2^2=\|\boldsymbol r\|_2^2+\|A\boldsymbol d\|_2^2\ge\|\boldsymbol r\|_2^2.$$
故 $\boldsymbol c$ 为全局最小二乘解。列满秩时 $A\boldsymbol d=0$ 只可能 $\boldsymbol d=0$，所以解唯一；秩亏时系数可能不唯一，但最优拟合值 $A\boldsymbol c$ 仍唯一。$\blacksquare$
:::

### 多项式拟合

取 $\varphi_k(x)=x^k$，则 $A$ 是范德蒙德型矩阵。实际计算通常优先用 QR 分解，秩亏时用 SVD；直接形成 $A^{\mathrm T}A$ 会平方 2-范数条件数，正则化则需要另行说明所改变的目标函数；对低次多项式（$n=1,2,3$）法方程仍常用。

**例 3（教材 5.6.4）**：教材给一组数据，分别作一次/二次多项式拟合。步骤：

1. 设 $p(x)=c_0+c_1x$（或 $c_0+c_1x+c_2x^2$）；
2. 算 $A^{\mathrm T}A$ 与 $A^{\mathrm T}\boldsymbol y$；
3. 解法方程得 $c$；
4. 比较不同次数的残差平方和，次数不是越高越好（过拟合）。

具体数值按教材数据复算；核心是“法方程 + 残差检验”，不是背公式。

::: ex 例 3（教材 5.6.4） · 一次拟合的完整小例：残差不必为零，但必须正交 {#ex-5.6.3}

给定 $(0,1),(1,2),(2,2)$，拟合直线 $p(x)=c_0+c_1x$。设计矩阵与法方程为

$$A=\begin{pmatrix}1&0\\1&1\\1&2\end{pmatrix},\quad A^{\mathrm T}A=\begin{pmatrix}3&3\\3&5\end{pmatrix},\quad A^{\mathrm T}\boldsymbol y=\begin{pmatrix}5\\6\end{pmatrix}.$$

两式相减得 $2c_1=1$，再得 $c_0=7/6$。于是预测值为 $(7/6,5/3,13/6)^{\mathrm T}$，残差 $\boldsymbol r=\boldsymbol y-A\boldsymbol c=(-1/6,1/3,-1/6)^{\mathrm T}$，平方和为 $1/6$。逐项检验

$$\sum_i r_i=0,\qquad \sum_i x_ir_i=0$$

正是 $A^{\mathrm T}\boldsymbol r=0$ 的两个分量。拟合无需穿过任何一个点，但残差不能再通过调整常数或斜率而整体减小。

**迁移练习。**若三个横坐标都改为 $1$、纵坐标为 $1,2,3$，拟合直线的两个系数还能唯一确定吗？最优预测值与平方和是多少？

::: sol 核对与回查

两列设计矩阵完全相同，只能确定 $c_0+c_1=2$；系数有无穷多组，预测值却都是 $(2,2,2)^{\mathrm T}$，残差为 $(-1,0,1)^{\mathrm T}$，平方和为 $2$。若误把“法方程有解”当作“系数唯一”，回查定理中的列满秩条件。能分清后，可用原三点的二次插值 $1+\tfrac32x-\tfrac12x^2$ 作对照：训练残差降到零，但仅凭这三点无法判断未知点上是否更准确。
:::
:::

### 非线性拟合的线性化

若模型是 $y=ae^{bx}$，取对数：
$$
\ln y=\ln a+bx,
$$
对 $(\ln y_i,x_i)$ 作线性最小二乘，再指数回代。类似地，$y=ax^b$ 取 $\ln y=\ln a+b\ln x$。注意：线性化后的最小二乘不等价于原问题的非线性最小二乘，数据误差结构会变；精度要求高时用 Gauss–Newton/Levenberg–Marquardt。

::: ex 例题 · 5 点数据表上的二次拟合（第 12 讲 §五板书） {#ex-5.6-ls5}
板书给出的数据表（这组 $y_i$ 恰为 $0.1(x+2)^2$）：
$$
\begin{array}{c|ccccc}
x_i & -2 & -1 & 0 & 1 & 2\\ \hline
y_i & 0 & 0.1 & 0.4 & 0.9 & 1.6
\end{array}
$$
要求拟合二次多项式 $m(x)=a_0+a_1x+a_2x^2$，使 $\min\lVert a_0+a_1x+a_2x^2-f\rVert_2$ 最小。

把 $\{1,x,x^2\}$ 当作基、$(f,g)=\sum_i f(x_i)g(x_i)$ 当作内积，法方程即
$$
\begin{pmatrix}
(1,1)&(1,x)&(1,x^2)\\
(x,1)&(x,x)&(x,x^2)\\
(x^2,1)&(x^2,x)&(x^2,x^2)
\end{pmatrix}
\begin{pmatrix}a_0\\a_1\\a_2\end{pmatrix}
=
\begin{pmatrix}(f,1)\\(f,x)\\(f,x^2)\end{pmatrix}.
$$
五个节点对称，故 $\sum x_i=0,\ \sum x_i^2=10,\ \sum x_i^3=0,\ \sum x_i^4=34,\ n=5$；右端
$$
(f,1)=\sum y_i=3.0,\qquad
(f,x)=\sum x_iy_i=4.0,\qquad
(f,x^2)=\sum x_i^2y_i=7.4 .
$$
法方程具体化为
$$
\begin{pmatrix}5&0&10\\0&10&0\\10&0&34\end{pmatrix}
\begin{pmatrix}a_0\\a_1\\a_2\end{pmatrix}
=
\begin{pmatrix}3.0\\4.0\\7.4\end{pmatrix}.
$$
第二行立刻给出 $10a_1=4.0\Rightarrow a_1=0.4$。第一、三行联立：
$$
\begin{cases}
5a_0+10a_2=3.0,\\
10a_0+34a_2=7.4,
\end{cases}
\Rightarrow
\begin{cases}
a_0+2a_2=0.6,\\
10a_0+34a_2=7.4.
\end{cases}
$$
消元：$a_0=0.6-2a_2$ 代入第二式得 $6+14a_2=7.4$，故 $a_2=0.1$，$a_0=0.6-0.2=0.4$。所以
$$
\boxed{\;m(x)=0.4+0.4x+0.1x^2\;}
$$
逐点代入：$m(-2)=0,\ m(-1)=0.1,\ m(0)=0.4,\ m(1)=0.9,\ m(2)=1.6$，与 $y_i$ 完全一致，残差全为 $0$；平方和 $0$ 是最小可能值（非负），故确为最小二乘解。

**解读**：数据恰好落在二次多项式上时，最小二乘**精确复原**该多项式，残差为零——「拟合」与「插值」并不对立：前者要求总平方误差最小，后者要求过点；数据光滑时两者可以重合。板书数字特意配成 $\sum x_i=\sum x_i^3=0$，法方程立刻解耦成 $10a_1=4$。随后把同一套法方程换成正交多项式基 $P_0,P_1,P_2$ 重写，$i\ne j$ 时 $(P_i,P_j)=0$，矩阵成为对角阵，三个系数各算各的——第 11 讲「正交基让法方程解耦」的落地。
:::

::: note 课堂口述与标准术语对照（第 11–12 讲，节选）
平台 ASR 与 whisper 在这两讲有大量同音错字：内肌 / 内心 / 那一期 / 内息 → **内积**；正教授 / 正交较大 → **正交化**；顺庞 / 十分之正交八里 → **Gram–Schmidt**；领域绕路 / 尼斯多德 → **Legendre（勒让德）**；切皮区 → **Chebyshev（切比雪夫）**；屁股 → **投影**；「对的」（“我们希望 $A$ 是对的”）→ **对角阵**；塞 1 / 塞 2 / 败 → $\varphi_1,\varphi_2,\varphi_0$ 一类基函数；约然的内积 / 离散离心 → **离散内积**。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| 权函数 | 非负、使各阶矩存在，决定内积 | [@def-5.5.1] | [6.7](../ch06/sec67.md) Gauss 求积的权 |
| 带权内积 | $(f,g)=\int_a^b\rho fg\,dx$，四公理 | [@def-5.5.2] | [5.6.4](#sec-5.6.4) 离散内积 |
| 正交多项式系 | $(\varphi_i,\varphi_j)=0\ (i\ne j)$ 且 $\deg\varphi_k=k$ | [@def-5.5.3] | [5.5.2](#sec-5.5.2) 四族经典 |
| 零点定理 | $k$ 次正交多项式在 $(a,b)$ 内恰有 $k$ 个互异实零点 | [@thm-op-zeros] | [6.7](../ch06/sec67.md) Gauss 节点 |
| Gram–Schmidt | 逐项减去在已有正交基上的投影 | [@def-5.5.4] | [补充篇 2.3](../../supplement/sec23.md) 矩阵语言 |
| 最佳平方逼近 | $p$ 最优 $\iff$ $f-p\perp M$ | [@thm-5.7] | [5.6.4](#sec-5.6.4) 最小二乘 |
| 法方程 | $G\boldsymbol c=\boldsymbol b$，$G_{ij}=(\varphi_i,\varphi_j)$ | [@def-5.6.2] | [5.6.4](#sec-5.6.4) $A^{\mathrm T}A$ 版 |
| 正交基系数 | $c_k=(f,\varphi_k)/(\varphi_k,\varphi_k)$，法方程对角化 | 5.6.2 笔记盒 | — |
| 离散内积 | $(f,g)=\sum_i f(x_i)g(x_i)$ | [@def-5.6.3] | [5.6.4](#sec-5.6.4) 曲线拟合 |
| 最小二乘法方程 | $A^{\mathrm T}A\boldsymbol c=A^{\mathrm T}\boldsymbol y$ | [@thm-ls-normal] | [6.1](../ch06/sec61.md) 插值型求积 |
:::

::: think 本节常见错误
1. **把「1」当数而不是常值函数。** 函数空间里 $f,g,1,x$ 都是向量；$a$ 才是数（老师在第 11 讲专门纠正）。
2. **系数分母写 1。** 正交基下 $c_i=(f,\varphi_i)/(\varphi_i,\varphi_i)$，只有**标准**正交基分母才是 $1$——这是最常见的丢分点。
3. **以为最佳平方逼近过点。** 它只要求 $L^2$ 误差最小；$\sqrt{x}$ 的最佳一次逼近在 $x=0$ 处等于 $4/15\ne0$。
4. **Gram 矩阵非奇异不证明。** 要用 $\boldsymbol c^{\mathrm T}G\boldsymbol c=\lVert\sum c_i\varphi_i\rVert^2>0$（内积正定 + 线性无关）。
5. **四族正交多项式只背公式、不写区间与权。** Legendre 只在 $[-1,1]$、权 $1$ 下是这个形式；换区间要作线性变换，换权则是另一族。
6. **离散内积的正定性被夸大。** $\sum_i f^2(x_i)=0$ 只能推出 $f$ 在节点为零，推不出 $f\equiv0$——最小二乘只关心采样点的残差平方和。
7. **零点定理漏「互异」「实」。** 准确结论是 $(a,b)$ 内 $k$ 个互异实零点，证明按「奇重零点」计数。
8. **正交化公式的分母用错。** 是 $(\psi_j,\psi_j)$（已正交化的向量），不是 $(\varphi_j,\varphi_j)$。
:::

::: note 覆盖核对
本节覆盖教材 5.5.1–5.5.2、5.6.1–5.6.4、定理 5.6–5.8。**第 11 讲已讲**：内积空间、正交投影、法方程、Gram 矩阵非奇异、Gram–Schmidt、Legendre 多项式、例题 $\sqrt{x}$；**第 12 讲已讲**：四族正交多项式、Chebyshev 换元推导、零点定理、离散内积、5 点数据最小二乘。**课堂未展开**：Legendre 级数收敛性、样条逼近、5.6.4 曲线拟合的曲面版本。第 11、12 讲末均**未布置作业**。下一节：[第 5 章习题](exercises.md)。
:::
