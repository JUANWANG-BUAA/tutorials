# 4.2 非线性方程组的迭代解法

一元方程只有一个未知量。多个未知量同时满足非线性关系时，需要求解 $F(\boldsymbol x)=\boldsymbol0$。

一元方法中的许多想法仍然适用：把方程改写成不动点形式，或用局部线性关系修正近似解。变化在于，导数要换成由偏导数组成的 Jacobian 矩阵；Newton 法的每一步则要求解一个线性方程组。

例如本节将计算 $x=\tfrac12\cos y$、$y=\tfrac12\sin x$。第一条方程中的 $x$ 依赖 $y$，第二条中的 $y$ 又依赖 $x$，不能先独立求完一个再求另一个。可把两条方程的未满足量一起记为 $F(x,y)=(x-\tfrac12\cos y,\ y-\tfrac12\sin x)^{\mathrm T}$。求解就是同时使这两个残差为零；用向量范数衡量误差，则是为了把“两个分量都足够小”写成一个可检查的条件。

<a id="sec-4.2.1"></a>
## 4.2.1 非线性方程组与可微性

::: def 定义 4.2.1 · 非线性方程组 {#def-4.2.1}
设
$$
F(\boldsymbol x)=\begin{pmatrix}f_1(x_1,\dots,x_n)\\\vdots\\f_n(x_1,\dots,x_n)\end{pmatrix}=\boldsymbol0.
$$
称为 $n$ 元**非线性方程组**；$F:\mathbb R^n\to\mathbb R^n$ 称为**向量值函数**，$f_i$ 是它的第 $i$ 个分量。
:::

::: def 定义 4.2.2 · Jacobian 矩阵 {#def-4.2.2}
$F$ 在 $\boldsymbol x$ 处的**Jacobian 矩阵**（导数矩阵）为一阶偏导数排成的矩阵
$$
F'(\boldsymbol x)=\begin{pmatrix}
\frac{\partial f_1}{\partial x_1}&\cdots&\frac{\partial f_1}{\partial x_n}\\
\vdots&&\vdots\\
\frac{\partial f_n}{\partial x_1}&\cdots&\frac{\partial f_n}{\partial x_n}
\end{pmatrix}.
$$
它是一元导数 $f'$ 的矩阵版；$n=1$ 时退化为 $\begin{pmatrix}f'(x)\end{pmatrix}$。

行下标表示“哪条方程”，列下标表示“改变哪个未知量”。例如 $F(x,y)=(x^2+y-2,\ x+y^2-2)^{\mathrm T}$ 在 $(1,1)$ 处的 Jacobian 为 $\begin{pmatrix}2&1\\1&2\end{pmatrix}$，所以增量 $(h_1,h_2)$ 使两条方程的值分别近似改变 $2h_1+h_2$ 和 $h_1+2h_2$。这就是矩阵乘法在局部线性化中的含义。
:::

可微的含义是：当增量 $\boldsymbol h\to\boldsymbol0$ 时，
$$F(\boldsymbol x+\boldsymbol h)=F(\boldsymbol x)+F'(\boldsymbol x)\boldsymbol h+o(\lVert\boldsymbol h\rVert).$$
因此 Jacobian 不只是偏导数的表格，它把输入的小变化近似转换成各方程值的变化。仅有各偏导数存在并不足以保证可微；例如各偏导数在邻域内连续则足以保证可微。

::: thm 定理 4.10 · 可微的充要条件 {#thm-4.10}
$F(\boldsymbol x)$ 在 $\boldsymbol x_0$ 处可微的充要条件是：各分量 $f_1,\dots,f_n$ 都在 $\boldsymbol x_0$ 处可微。可微时 $F'(\boldsymbol x_0)$ 的各行即 $\nabla f_i(\boldsymbol x_0)$。
:::

事实上，把每个分量的可微展开叠起来，就得到向量余项 $\boldsymbol r(\boldsymbol h)$。取无穷范数时，$\|\boldsymbol r(\boldsymbol h)\|_\infty=\max_i|r_i(\boldsymbol h)|=o(\|\boldsymbol h\|)$，因为分量只有有限个；反过来，每个分量余项都被向量余项范数控制。这就证明了定理 4.10，换用其他范数则由有限维范数等价性得到同一结论。

::: thm 定理 4.11 · 向量值函数的中值定理 {#thm-4.11}
设 $F$ 在包含线段 $\overline{\boldsymbol x\boldsymbol y}$ 的区域内连续可微，则
$$
F(\boldsymbol x)-F(\boldsymbol y)=\int_0^1F'(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))(\boldsymbol x-\boldsymbol y)\,dt
$$
（牛顿–莱布尼茨型公式；$\boldsymbol x-\boldsymbol y$ 是常向量，可移出积分号）。
:::

::: proof 证明
对一元函数 $g(t)=F(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))$ 用牛顿–莱布尼茨公式，$g'(t)=F'(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))(\boldsymbol x-\boldsymbol y)$（链式法则）：
$$
F(\boldsymbol x)-F(\boldsymbol y)=g(1)-g(0)=\int_0^1g'(t)\,dt
=\int_0^1F'(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))(\boldsymbol x-\boldsymbol y)\,dt.\ \blacksquare
$$
:::

不能把一元中值定理直接写成“存在同一个 $\xi$ 使 $F(\boldsymbol x)-F(\boldsymbol y)=F'(\xi)(\boldsymbol x-\boldsymbol y)$”。各分量可能需要不同的中间点。例如令 $H(t)=(t^2,t^3)^{\mathrm T}$，在 $[0,1]$ 上要同时有 $(1,1)^{\mathrm T}=H'(\xi)=(2\xi,3\xi^2)^{\mathrm T}$，第一分量要求 $\xi=1/2$，第二分量却不成立。积分形式保留了整条线段上的导数，因此能对所有分量同时成立。

::: thm 定理 4.12 · 压缩条件的矩阵版本 {#thm-4.12}
设 $D\subset\mathbb R^n$ 是凸区域，$G:D\to\mathbb R^n$ 在 $D$ 上连续可微，且存在 $L\lt1$ 使
$$
\lVert G'(\boldsymbol z)\rVert\le L,\qquad \forall \boldsymbol z\in D.
$$
则 $G$ 在 $D$ 上满足 Lipschitz 条件（即两点像的距离有统一比例上界；这里的矩阵范数取与向量范数相容的诱导范数）
$$
\lVert G(\boldsymbol x)-G(\boldsymbol y)\rVert\le L\lVert\boldsymbol x-\boldsymbol y\rVert,\qquad \forall \boldsymbol x,\boldsymbol y\in D.
$$

:::

::: proof 证明
由 [@thm-4.11]（$D$ 凸保证线段在 $D$ 内）取范数：
$$
\lVert G(\boldsymbol x)-G(\boldsymbol y)\rVert
=\left\lVert\int_0^1G'(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))(\boldsymbol x-\boldsymbol y)\,dt\right\rVert
\le\int_0^1L\lVert\boldsymbol x-\boldsymbol y\rVert\,dt
=L\lVert\boldsymbol x-\boldsymbol y\rVert.\ \blacksquare
$$
:::

<a id="sec-4.2.2"></a>
## 4.2.2 不动点迭代

把 $F(\boldsymbol x)=0$ 改写成 $\boldsymbol x=G(\boldsymbol x)$，迭代
$$
\boldsymbol x^{(k+1)}=G(\boldsymbol x^{(k)}).
$$

::: thm[core] 定理 4.13 · 压缩映像原理 {#thm-4.13}
设 $D\subset\mathbb R^n$ 非空且闭，$G:D\to D$，且存在 $L\lt1$，使
$$
\lVert G(\boldsymbol x)-G(\boldsymbol y)\rVert\le L\lVert\boldsymbol x-\boldsymbol y\rVert,\qquad \forall \boldsymbol x,\boldsymbol y\in D.
$$
则 $G$ 在 $D$ 内有唯一不动点 $\boldsymbol x^*$，且对任意 $\boldsymbol x^{(0)}\in D$，迭代收敛到 $\boldsymbol x^*$，并有
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\frac{L^k}{1-L}\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert.
$$
:::

::: proof 证明
**第 1 步 · Cauchy 列。**由 Lipschitz 条件递推，
$$
\lVert\boldsymbol x^{(k+1)}-\boldsymbol x^{(k)}\rVert
\le L\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert
\le\cdots\le L^k\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert.
$$
对 $m\gt k$ 用三角不等式与几何级数，
$$
\lVert\boldsymbol x^{(m)}-\boldsymbol x^{(k)}\rVert
\le\sum_{j=k}^{m-1}\lVert\boldsymbol x^{(j+1)}-\boldsymbol x^{(j)}\rVert
\le\sum_{j=k}^{m-1}L^j\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert
\le\frac{L^k}{1-L}\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert\to0 .
$$
故 $\{\boldsymbol x^{(k)}\}$ 是 Cauchy 列；$D$ 闭，故 $\boldsymbol x^{(k)}\to\boldsymbol x^*\in D$。

**第 2 步 · 极限是不动点。**$G$ 连续（Lipschitz），对 $\boldsymbol x^{(k+1)}=G(\boldsymbol x^{(k)})$ 取极限得 $\boldsymbol x^*=G(\boldsymbol x^*)$。

**第 3 步 · 唯一性。**若 $\boldsymbol y^*$ 也是不动点，则
$$
\lVert\boldsymbol x^*-\boldsymbol y^*\rVert=\lVert G(\boldsymbol x^*)-G(\boldsymbol y^*)\rVert\le L\lVert\boldsymbol x^*-\boldsymbol y^*\rVert,
$$
$L\lt1$ 迫使 $\lVert\boldsymbol x^*-\boldsymbol y^*\rVert=0$。

**第 4 步 · 误差界。**在第 1 步的不等式中令 $m\to\infty$ 即得先验界；同理从最后一步差出发有后验界
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\frac{L}{1-L}\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert\quad(k\ge1),
$$
与一元版 [@thm-4.1] 完全平行。$\blacksquare$
:::

::: thm 定理 4.14 · 线性迭代的收敛判据 {#thm-4.14}
若 $G(\boldsymbol x)=B\boldsymbol x+\boldsymbol d$，则迭代 $\boldsymbol x^{(k+1)}=B\boldsymbol x^{(k)}+\boldsymbol d$ 对任意初值收敛到同一个不动点的充要条件是 $\rho(B)\lt1$；$\lVert B\rVert\lt1$ 是充分条件。
:::

::: proof 证明
误差满足 $\boldsymbol x^{(k)}-\boldsymbol x^*=B^k(\boldsymbol x^{(0)}-\boldsymbol x^*)$，其中 $\boldsymbol x^*=(I-B)^{-1}\boldsymbol d$（$\rho(B)\lt1$ 时 Neumann 级数 $\sum B^j$ 收敛，逆存在）。

**充分性。**由谱半径公式 $\rho(B)=\lim\limits_{k\to\infty}\lVert B^k\rVert^{1/k}$，任取 $\varepsilon\gt0$ 使 $\rho(B)+\varepsilon\lt1$，存在 $K$ 使 $k\ge K$ 时 $\lVert B^k\rVert\le(\rho(B)+\varepsilon)^k$，于是
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le(\rho(B)+\varepsilon)^k\lVert\boldsymbol x^{(0)}-\boldsymbol x^*\rVert\to0 .
$$

**必要性。**假设所有实初值都收敛到同一个不动点 $\boldsymbol x^*$。取初值 $\boldsymbol x^*+\boldsymbol w$，便知 $B^k\boldsymbol w\to\boldsymbol0$ 对每个实向量 $\boldsymbol w$ 都成立。设 $\lambda$ 是 $B$ 的任一特征值，$\boldsymbol v\ne\boldsymbol0$ 是对应的特征向量。即使 $\boldsymbol v$ 是复向量，把它写成 $\boldsymbol u+i\boldsymbol w$ 后，也有
$$
B^k\boldsymbol v=B^k\boldsymbol u+iB^k\boldsymbol w\to\boldsymbol0.
$$
另一方面，$B^k\boldsymbol v=\lambda^k\boldsymbol v$，所以 $|\lambda|^k\lVert\boldsymbol v\rVert_2\to0$。由于 $\boldsymbol v\ne\boldsymbol0$，必有 $|\lambda|\lt1$。这对所有特征值都成立，故 $\rho(B)\lt1$。

**范数条件是充分的。**$\rho(B)\le\lVert B\rVert\lt1$ 时直接由
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\lVert B\rVert^k\lVert\boldsymbol x^{(0)}-\boldsymbol x^*\rVert\to0
$$
得收敛——它用起来方便，却不是必要的（依赖范数的选取）。$\blacksquare$
:::

::: ex 例 6 · 方程组不动点迭代 {#ex-4.2.1}
求解
$$x=\frac12\cos y,\qquad y=\frac12\sin x.$$
令 $G(x,y)=(\frac12\cos y,\frac12\sin x)^{\mathrm T}$，取 $D=[-1/2,1/2]^2$，从 $(0,0)^{\mathrm T}$ 开始迭代。

$G$ 将 $D$ 映入 $D$。导数矩阵为
$$G'(x,y)=\begin{pmatrix}0&-\frac12\sin y\\\frac12\cos x&0\end{pmatrix},$$
所以 $\lVert G'(x,y)\rVert_\infty\le1/2$。由压缩映像原理，$D$ 内有唯一解，且从任意 $D$ 内初值出发都收敛。

下表每一行同时使用上一行的两个分量更新：

| $k$ | $x_k$ | $y_k$ |
|--:|--:|--:|
| 0 | 0.00000000 | 0.00000000 |
| 1 | 0.50000000 | 0.00000000 |
| 2 | 0.50000000 | 0.23971277 |
| 3 | 0.48570311 | 0.23971277 |
| 4 | 0.48570311 | 0.23341513 |
逐步迭代可得解约为 $(0.48640515,0.23372550)$。后验因子 $L/(1-L)=1$，所以相邻两步之差的无穷范数不超过 $\varepsilon$ 时，当前解误差也不超过 $\varepsilon$。
:::

<a id="sec-4.2.3"></a>
## 4.2.3 Newton 法（方程组）

在 $\boldsymbol x^{(k)}$ 处线性化：
$$
F(\boldsymbol x)\approx F(\boldsymbol x^{(k)})+F'(\boldsymbol x^{(k)})(\boldsymbol x-\boldsymbol x^{(k)}),
$$
令其为零：
$$
\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}-F'(\boldsymbol x^{(k)})^{-1}F(\boldsymbol x^{(k)}).
$$
实际计算不显式求逆，而是解线性方程组
$$
F'(\boldsymbol x^{(k)})\Delta\boldsymbol x^{(k)}=-F(\boldsymbol x^{(k)}),\qquad
\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta\boldsymbol x^{(k)}.
$$

对例 7 的第一步，线性方程组逐行是 $\Delta x=1/2$、$-\Delta x/2+\Delta y=0$，所以 $\Delta y=1/4$。这里两个修正量一起由耦合的方程求出，与简单迭代把旧坐标分别代入两条式子不同。计算大规模问题时，Jacobian 的结构也会影响这一线性求解的成本。

::: thm 定理 4.15 · 方程组 Newton 的局部平方收敛 {#thm-4.15}
设 $F$ 在解 $\boldsymbol x^*$ 的邻域内二阶连续可微，$F(\boldsymbol x^*)=0$，$F'(\boldsymbol x^*)$ 非奇异。则存在 $\delta\gt0$，当 $\boldsymbol x^{(0)}$ 充分接近 $\boldsymbol x^*$ 时，Newton 迭代收敛，且至少平方收敛。
:::

::: proof 证明
记 $\boldsymbol e_k=\boldsymbol x^{(k)}-\boldsymbol x^*$。在 $\boldsymbol x^*$ 处作二阶 Taylor 展开（余项用积分形式，即 [@thm-4.11] 用于余项）：
$$
F(\boldsymbol x^{(k)})=F(\boldsymbol x^*)+F'(\boldsymbol x^*)\boldsymbol e_k+O(\lVert\boldsymbol e_k\rVert^2)
=F'(\boldsymbol x^*)\boldsymbol e_k+O(\lVert\boldsymbol e_k\rVert^2),
$$
且 $F'(\boldsymbol x^{(k)})=F'(\boldsymbol x^*)+O(\lVert\boldsymbol e_k\rVert)$。对步 $\Delta_k$ 满足的方程
$$
F'(\boldsymbol x^{(k)})\Delta_k=-F(\boldsymbol x^{(k)})
$$
两边左乘 $[F'(\boldsymbol x^{(k)})]^{-1}$。因 $F'(\boldsymbol x^*)$ 非奇异，逆在邻域内连续：
$$
[F'(\boldsymbol x^{(k)})]^{-1}=[F'(\boldsymbol x^*)]^{-1}+O(\lVert\boldsymbol e_k\rVert),
$$
代入得
$$
\Delta_k=-\bigl([F'(\boldsymbol x^*)]^{-1}+O(\lVert\boldsymbol e_k\rVert)\bigr)
\bigl(F'(\boldsymbol x^*)\boldsymbol e_k+O(\lVert\boldsymbol e_k\rVert^2)\bigr)
=-\boldsymbol e_k+O(\lVert\boldsymbol e_k\rVert^2).
$$
于是
$$
\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta_k
=\boldsymbol x^*+\boldsymbol e_k-\boldsymbol e_k+O(\lVert\boldsymbol e_k\rVert^2)
=\boldsymbol x^*+O(\lVert\boldsymbol e_k\rVert^2),
$$
即 $\lVert\boldsymbol e_{k+1}\rVert\le C\lVert\boldsymbol e_k\rVert^2$。取 $\delta$ 使 $C\delta\lt1$，邻域内不越界且误差平方衰减——与一元版 [@thm-4.6] 的 $\frac{M}{2m}\lvert e_k\rvert^2$ 估计逐字平行。$\blacksquare$
:::

::: ex 例 7 · 方程组 Newton 法 {#ex-4.2.2}
仍解上例的方程组，取
$$F(x,y)=\begin{pmatrix}x-\frac12\cos y\\y-\frac12\sin x\end{pmatrix},\qquad F'(x,y)=\begin{pmatrix}1&\frac12\sin y\\-\frac12\cos x&1\end{pmatrix}.$$
从 $(0,0)^{\mathrm T}$ 出发，第一步解
$$\begin{pmatrix}1&0\\-1/2&1\end{pmatrix}\begin{pmatrix}\Delta x\\\Delta y\end{pmatrix}=\begin{pmatrix}1/2\\0\end{pmatrix},$$
得到 $(x_1,y_1)=(1/2,1/4)$。后续每步在新点重新计算 Jacobian 并求解修正量。表中的残差由尚未截短的计算值求得，坐标只显示八位小数。解附近 Jacobian 非奇异，因而充分接近解后至少平方收敛。

| $k$ | $x_k$ | $y_k$ | $\lVert F(x_k,y_k)\rVert_\infty$ |
|--:|--:|--:|--:|
| 0 | 0.00000000 | 0.00000000 | $5.00e-01$ |
| 1 | 0.50000000 | 0.25000000 | $1.55e-02$ |
| 2 | 0.48646351 | 0.23377308 | $6.39e-05$ |
| 3 | 0.48640516 | 0.23372550 | $5.50e-10$ |
| 4 | 0.48640515 | 0.23372550 | $\lt10^{-14}$ |
与前例相比，Newton 法用较少的轮数达到同样精度，但每轮多出 Jacobian 和线性方程组的计算。不能只比较迭代轮数来判断总用时。
:::

<a id="sec-4.2.4"></a>
## 4.2.4 离散 Newton 与 Newton–Steffensen

若 Jacobian 难算，可以沿坐标方向扰动输入，用函数值之差近似各列偏导数。

第 9 讲引出用差商代替导数时，老师说：“你对它进行求导的很费劲”（34:52；[据转写，未经听校](../../lectures/lec09.md#lec09-S8)）。这里把同一想法用于方程组：难算的不再是一个导数，而是整个偏导矩阵。以下离散 Newton 公式是本节对该想法的多元展开，不表示第 9 讲已经讲过这一算法。

具体地，取
$$
J(\boldsymbol x^{(k)},h^{(k)})_{ij}=\frac{f_i(\boldsymbol x^{(k)}+h_j^{(k)}\boldsymbol e_j)-f_i(\boldsymbol x^{(k)})}{h_j^{(k)}},
$$
其中 $\boldsymbol e_j$ 是第 $j$ 个分量为 1、其余为 0 的标准基向量，$h_j^{(k)}\ne0$。每一列只改变一个输入分量，故差商近似该分量对应的偏导数。再解
$$
J(\boldsymbol x^{(k)},h^{(k)})\Delta\boldsymbol x^{(k)}=-F(\boldsymbol x^{(k)}).
$$
这就是离散 Newton 法。取 $h_j^{(k)}=c\lVert F(\boldsymbol x^{(k)})\rVert$（固定 $c\ne0$）时，称为 Newton–Steffensen 方法。在定理 4.15 的条件下，充分接近解时，差商误差为 $O(\lVert F\rVert)=O(\lVert\boldsymbol x-\boldsymbol x^*\rVert)$，因此线性化误差仍为二阶，局部至少平方收敛。若残差为零则停止，不计算零步长差商；有限精度下步长过小时还会发生相消，理论阶数不保证能一直观察到。

::: method 算法 · 离散 Newton 与 Newton–Steffensen
1. **离散 Newton**：每步用 $n$ 个前向差商凑出近似 Jacobian $J(\boldsymbol x^{(k)},h^{(k)})$（第 $j$ 列只扰动第 $j$ 个分量），解 $J\Delta=-F$ 并更新——把「算偏导」换成「多算 $n$ 次函数值」，与一元割线法同思路（[@thm-4.8]）。
2. **Newton–Steffensen**：取 $h_j^{(k)}=c\lVert F(\boldsymbol x^{(k)})\rVert$，扰动步长随残差自适应：远离根时步长大胆，靠近根时步子收细。在 [@thm-4.15] 的条件下适当选 $c$ 仍至少平方收敛。
3. **注意**：这里的 Steffensen 与 [4.1.4](sec41.md#sec-4.1.4) 的 Steffensen 加速（Aitken 外推）同名不同物，别混。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| Jacobian 矩阵 | 一元 $f'$ 的矩阵版，$F'(\boldsymbol x)_{ij}=\partial f_i/\partial x_j$ | [@def-4.2.2] | Newton 步每步解 $F'\Delta=-F$（[4.2.3](#sec-4.2.3)） |
| 可微充要条件 | $F$ 可微 ⟺ 各分量可微 | [@thm-4.10] | — |
| 向量中值定理 | $F(\boldsymbol x)-F(\boldsymbol y)=\int_0^1F'(\boldsymbol y+t(\boldsymbol x-\boldsymbol y))(\boldsymbol x-\boldsymbol y)\,dt$ | [@thm-4.11] | 压缩矩阵版 [@thm-4.12] |
| 压缩映像原理 | Lipschitz $L\lt1$ + 自映射 ⟹ 唯一不动点、任意初值收敛 | [@thm-4.13] | 标量版 [@thm-4.1]（[4.1.2](sec41.md#sec-4.1.2)） |
| 线性迭代判据 | $\rho(B)\lt1$ 充要；$\lVert B\rVert\lt1$ 充分 | [@thm-4.14] | [2.4.1](../ch02/sec24.md#sec-2.4.1) 谱半径与迭代法收敛性 |
| 方程组 Newton | 线性化 + 解线性方程组，局部至少平方收敛 | [@thm-4.15] | 离散 Newton（[4.2.4](#sec-4.2.4)） |
:::

::: think 本节常见错误
1. **把 $\lVert B\rVert\lt1$ 当必要条件。**$\rho(B)\lt1$ 才是「任意初值收敛」的充要条件；$\lVert B\rVert\lt1$ 只是充分条件，且依赖范数的选取（换成另一种范数结论可能不同）。
2. **验压缩忘了自映射。**[@thm-4.13] 要求 $G:D\to D$ 且 $D$ 闭；只验 Lipschitz 条件，迭代可能跑出 $D$，Cauchy 列的极限也不保证落在 $D$ 内。
3. **Newton 步显式求逆。**$F'(\boldsymbol x^{(k)})^{-1}F(\boldsymbol x^{(k)})$ 只是记号；实现应解线性方程组 $F'\Delta=-F$（$F'$ 多变时用 [2.2](../ch02/sec22.md) 的三角分解复用更经济）。
4. **离散 Newton 的 $h$ 乱取。**$h$ 太小，差商分子相近数相减被舍入吞掉（[1.2.4](../../ch01/sec12.md#sec-1.2.4) 原则 (3)）；$h$ 太大，近似失真。Newton–Steffensen 用 $h_j=c\lVert F\rVert$ 让步长自适应。
5. **把「存在唯一」当「能算出来」。**压缩映像原理保证收敛到唯一不动点，但每步成本、收敛快慢、问题的条件数另说（[1.2.6](../../ch01/sec12.md#sec-1.2.6)）；解线性方程组同样有向后误差与条件数的问题。
:::

<a id="sec-4.2-exercises"></a>
## 习题

::: ex 4.10 · 方程组简单迭代{#ex-4.10}
对[例 6](#ex-4.2.1) 中给出的方程组，从 $(0,0)^{\mathrm T}$ 出发作不动点迭代，保证解的无穷范数误差不超过 $10^{-6}$。记录迭代次数。
:::

::: sol 参考答案
采用例中的 $G$ 和 $D$，可取 $L=1/2$。以 $\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert_\infty\le10^{-6}$ 为停止条件，后验界保证当前解误差满足要求。从初值开始更新 10 次后首次满足此条件。解约为 $(0.48640515,0.23372550)$。
:::

::: ex 4.11 · 方程组 Newton 法{#ex-4.11}
对[例 7](#ex-4.2.2) 中的同一方程组作 Newton 迭代，从 $(0,0)^{\mathrm T}$ 出发，以 $\lVert F(\boldsymbol x^{(k)})\rVert_\infty\le10^{-10}$ 为停止条件。对比每轮所需的运算与第 4.10 题。
:::

::: sol 参考答案
使用例中给出的 Jacobian，每步求解 $F'(\boldsymbol x^{(k)})\Delta\boldsymbol x=-F(\boldsymbol x^{(k)})$。不能把第一步的 Jacobian 固定用于所有后续步骤，否则得到的是另一种方法。核对最终两条方程的残差；本题的残差阈值与第 4.10 题的误差阈值不同，比较轮数时应先统一精度要求。
:::
