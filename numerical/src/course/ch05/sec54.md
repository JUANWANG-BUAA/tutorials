# 5.5–5.6 正交多项式与最佳平方逼近

> 对应教材 5.5.1–5.5.2、5.6.1–5.6.3、定理 5.6–5.7。**老师课堂未讲**，按教材补齐，标“教材有、课堂未讲”。
> 主线：用正交多项式作基，把“解正规方程”变成“算内积”；再讨论最佳一致/平方逼近。

<a id="sec-5.5.1"></a>
## 5.5.1 正交多项式

设权函数 $\rho(x)\ge0$，若
$$
(\varphi_i,\varphi_j)=\int_a^b\rho(x)\varphi_i(x)\varphi_j(x)\,dx=0\quad(i\ne j),
$$
称 $\{\varphi_k\}$ 在 $[a,b]$ 上带权 $\rho$ 正交。

由幂函数系 $1,x,x^2,\dots$ 经 Gram–Schmidt 正交化，可得正交多项式系。常用：

- Legendre 多项式：$[-1,1]$，$\rho=1$；
- Chebyshev 多项式：$[-1,1]$，$\rho=1/\sqrt{1-x^2}$；
- Laguerre 多项式：$[0,\infty)$，$\rho=e^{-x}$；
- Hermite 多项式：$(-\infty,\infty)$，$\rho=e^{-x^2}$。

**定理 5.6（正交多项式基本性质）**：$n$ 次正交多项式 $p_n$ 在 $(a,b)$ 内有 $n$ 个互异实根；正交多项式系线性无关；任意次数不超过 $n$ 的多项式可用 $p_0,\dots,p_n$ 线性表示。

**三项递推**：正交多项式满足
$$
p_{k+1}(x)=(x-\alpha_k)p_k(x)-\beta_kp_{k-1}(x),
$$
这是数值生成正交多项式、构造 Gauss 求积节点的基础。

<a id="sec-5.6"></a>
## 5.6 函数的最佳平方逼近

### 5.6.1 最佳一致逼近（补充）

在 $C[a,b]$ 中，用 $n$ 次多项式 $p_n$ 逼近 $f$，使
$$
\lVert f-p_n\rVert_\infty=\max_{a\le x\le b}|f(x)-p_n(x)|
$$
最小。Chebyshev 交替定理给出最佳一致逼近多项式的特征：误差在 $n+2$ 个点交替取 $\pm\lVert f-p_n\rVert_\infty$。实际计算常用 Chebyshev 展开/Remez 算法。

### 5.6.2 最佳平方逼近

在 $L^2_\rho(a,b)$ 中，使
$$
\lVert f-p\rVert_2^2=\int_a^b\rho(x)|f(x)-p(x)|^2\,dx
$$
最小。若 $\{\varphi_k\}$ 正交，则
$$
p(x)=\sum_{k=0}^n c_k\varphi_k(x),\qquad
c_k=\frac{(f,\varphi_k)}{(\varphi_k,\varphi_k)}.
$$
系数直接由内积给出，不用解线性方程组；这就是“换到正交基”的最大好处。Legendre/Chebyshev 展开是最常用的两种。

**定理 5.7（最佳平方逼近的刻画）**：设 $H=operatorname{Span}{arphi_0,dots,arphi_n}$，$p^*in H$。则 $p^*$ 是 $f$ 在 $H$ 中的最佳平方逼近元，当且仅当
$$
(f-p^*,arphi_k)=0,qquad k=0,dots,n.
$$
等价地，系数 $c_k$ 满足法方程
$$
sum_{j=0}^n(arphi_j,arphi_k)c_j=(f,arphi_k),qquad k=0,dots,n.
$$
若 ${arphi_k}$ 线性无关，则解唯一。

**证明要点**：对任意 $qin H$，展开
$$
lVert f-p^*-q
Vert_2^2=lVert f-p^*
Vert_2^2-2(f-p^*,q)+lVert q
Vert_2^2.
$$
若 $(f-p^*,arphi_k)=0$，则 $(f-p^*,q)=0$，故 $p^*$ 最小；反之若某个内积不为零，取 $q$ 沿该方向扰动可使误差更小。$\blacksquare$

::: note 覆盖核对
本节覆盖教材 5.5.1–5.5.2、5.6.1–5.6.3、定理 5.6–5.7；**老师课堂未讲**。下一节：[第 5 章习题](exercises.md)。
:::
