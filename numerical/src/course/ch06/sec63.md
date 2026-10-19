# 6.7–6.8 Gauss 求积与数值微分

> 对应教材 6.7.1–6.7.2、6.8.1、定理 6.5–6.8、例 7–11。老师本章尚未开讲，先按教材铺。
> 主线：Gauss 求积用“节点也自由”换到最高代数精度；数值微分用差商/外推。

<a id="sec-6.7.1"></a>
## 6.7.1 Gauss 求积

\(n\) 点求积公式
$$
\int_a^b\rho(x)f(x)\,dx\approx\sum_{k=1}^nA_kf(x_k)
$$
有 \(2n\) 个自由参数（\(n\) 个节点 + \(n\) 个权重）。若代数精度达到 \(2n-1\)，称 **Gauss 型求积公式**。

**定理 6.5**：\(n\) 点 Gauss 求积的节点是 \([a,b]\) 上带权 \(\rho\) 的 \(n\) 次正交多项式的根；权重为正，且公式代数精度恰为 \(2n-1\)。

**定理 6.6–6.8**：Gauss 节点存在唯一；权重
$$
A_k=\int_a^b\rho(x)\ell_k(x)\,dx>0;
$$
Gauss 求积收敛，且对 \(f\in C[a,b]\) 有
$$
\lim_{n\to\infty}\sum_{k=1}^nA_kf(x_k)=\int_a^b\rho(x)f(x)\,dx.
$$

**$[-1,1]$ 上的 Gauss–Legendre**：节点是 Legendre 多项式 \(P_n\) 的根，权重
$$
A_k=\frac{2}{(1-x_k^2)[P_n'(x_k)]^2}.
$$
常用：
- \(n=1\)：\(x=0,A=2\)，即中点公式；
- \(n=2\)：\(x=\pm1/\sqrt3,A=1\)；
- \(n=3\)：\(x=0,\pm\sqrt{3/5}\)，\(A=8/9,5/9,5/9\)。

**区间变换**：对 \([a,b]\)，令
$$
x=\frac{a+b}{2}+\frac{b-a}{2}t,\qquad
\int_a^bf(x)dx=\frac{b-a}{2}\int_{-1}^1f\left(\frac{a+b}{2}+\frac{b-a}{2}t\right)dt.
$$

<a id="sec-6.7.2"></a>
## 6.7.2 Gauss–Chebyshev 等

- Gauss–Chebyshev：权 \(1/\sqrt{1-x^2}\)，节点 \(x_k=\cos\frac{(2k-1)\pi}{2n}\)，权重 \(\pi/n\)；
- Gauss–Laguerre：权 \(e^{-x}\)，区间 \([0,\infty)\)；
- Gauss–Hermite：权 \(e^{-x^2}\)，区间 \((-\infty,\infty)\)。

**例 7–11（教材 6.7）**：教材分别用 Gauss–Legendre/Chebyshev 计算积分，并与梯形/Simpson 对比。要点：同样节点数，Gauss 精度最高；但节点不固定、权重需预计算，适合光滑函数，不适合带奇异/间断的函数。

<a id="sec-6.8"></a>
## 6.8 数值微分

**差商公式**：

- 向前：
$$
f'(x)\approx\frac{f(x+h)-f(x)}{h},
$$
误差 \(O(h)\)；
- 中心：
$$
f'(x)\approx\frac{f(x+h)-f(x-h)}{2h},
$$
误差 \(O(h^2)\)；
- 二阶中心：
$$
f''(x)\approx\frac{f(x+h)-2f(x)+f(x-h)}{h^2},
$$
误差 \(O(h^2)\)。

**误差与舍入的平衡**：中心差分的截断误差 \(O(h^2)\)，舍入误差约 \(\varepsilon/h\)；最优 \(h\sim\varepsilon^{1/3}\)。步长太小反而更差。

**Richardson 外推**：用两种步长 \(h,2h\) 的中心差分
$$
D(h)=\frac{f(x+h)-f(x-h)}{2h},
$$
则
$$
f'(x)\approx\frac{4D(h)-D(2h)}{3}+O(h^4).
$$
这就是数值微分的外推法，和 Romberg 是同一思想。

::: note 覆盖核对
本节覆盖教材 6.7.1–6.7.2、6.8.1、定理 6.5–6.8、例 7–11；老师本章尚未开讲。下一节：[第 6 章习题](exercises.md)。
:::
