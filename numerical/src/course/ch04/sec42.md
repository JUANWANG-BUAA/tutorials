# 4.2 非线性方程组的迭代解法

> 对应教材 4.2.1–4.2.4、定理 4.10–4.15、例 6–7、习题 10–11。**老师课堂未讲**，按教材补齐，标"教材有、课堂未讲"。
> 主线：一元方法搬到方程组，关键是 Jacobian 与压缩/谱半径。

::: note 本节定位（教材有、课堂未讲）
老师这一轮没有展开非线性方程组（原书 4.2）。需要时按教材补读，考试按老师范围复习（课堂范围见[第 4 章导览](overview.md)）。本节的定理 4.12–4.15 给出了完整表述与证明——它们与一元版 [@thm-4.1]、[@thm-4.6] 逐条平行，读者可对照阅读。
:::

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
:::

::: thm 定理 4.10 · 可微的充要条件 {#thm-4.10}
$F(\boldsymbol x)$ 在 $\boldsymbol x_0$ 处可微的充要条件是：各分量 $f_1,\dots,f_n$ 都在 $\boldsymbol x_0$ 处可微。可微时 $F'(\boldsymbol x_0)$ 的各行即 $\nabla f_i(\boldsymbol x_0)$。
:::

::: thm 定理 4.11 · 向量值函数的中值定理 {#thm-4.11}
设 $F$ 在包含线段 $\overline{\boldsymbol x\boldsymbol y}$ 的区域内可微，则
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

::: thm 定理 4.12 · 压缩条件的矩阵版本 {#thm-4.12}
设 $D\subset\mathbb R^n$ 是凸区域，$G:D\to\mathbb R^n$ 在 $D$ 上可微，且存在 $L\lt1$ 使
$$
\lVert G'(\boldsymbol z)\rVert\le L,\qquad \forall \boldsymbol z\in D.
$$
则 $G$ 在 $D$ 上满足 Lipschitz 条件
$$
\lVert G(\boldsymbol x)-G(\boldsymbol y)\rVert\le L\lVert\boldsymbol x-\boldsymbol y\rVert,\qquad \forall \boldsymbol x,\boldsymbol y\in D.
$$
（教材把这一条表述为「压缩条件的矩阵版本」：标量条件 $\lvert\varphi'(x)\rvert\le L$ 的矩阵对应物；配合自映射 $G:D\to D$ 即 [@thm-4.13] 的全部条件。）
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
设 $D\subset\mathbb R^n$ 闭，$G:D\to D$，且存在 $L\lt1$，使
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
若 $G(\boldsymbol x)=B\boldsymbol x+\boldsymbol d$，则迭代 $\boldsymbol x^{(k+1)}=B\boldsymbol x^{(k)}+\boldsymbol d$ 对任意初值收敛的充要条件是 $\rho(B)\lt1$；$\lVert B\rVert\lt1$ 是充分条件。
:::

::: proof 证明
误差满足 $\boldsymbol x^{(k)}-\boldsymbol x^*=B^k(\boldsymbol x^{(0)}-\boldsymbol x^*)$，其中 $\boldsymbol x^*=(I-B)^{-1}\boldsymbol d$（$\rho(B)\lt1$ 时 Neumann 级数 $\sum B^j$ 收敛，逆存在）。

**充分性。**由谱半径公式 $\rho(B)=\lim\limits_{k\to\infty}\lVert B^k\rVert^{1/k}$，任取 $\varepsilon\gt0$ 使 $\rho(B)+\varepsilon\lt1$，存在 $K$ 使 $k\ge K$ 时 $\lVert B^k\rVert\le(\rho(B)+\varepsilon)^k$，于是
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le(\rho(B)+\varepsilon)^k\lVert\boldsymbol x^{(0)}-\boldsymbol x^*\rVert\to0 .
$$

**必要性。**若迭代对任意初值收敛，则 $B^k\boldsymbol v\to\boldsymbol0$ 对一切 $\boldsymbol v$ 成立（取 $\boldsymbol x^{(0)}=\boldsymbol x^*+\boldsymbol v$）。设 $\lambda$ 是 $B$ 的模最大特征值（$|\lambda|=\rho(B)$），$\boldsymbol v$ 为对应特征向量；若 $\boldsymbol v$ 为复向量，取实部与虚部中非零者为实初值。于是 $B^k\operatorname{Re}\boldsymbol v=\operatorname{Re}(\lambda^k\boldsymbol v)$ 应收敛到零，但 $|\lambda|\ge1$ 时它按 $|\lambda|^k$ 增长（$|\lambda|\gt1$）或旋转振荡（$|\lambda|=1$），矛盾。故 $\rho(B)\lt1$。

**范数条件是充分的。**$\rho(B)\le\lVert B\rVert\lt1$ 时直接由
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\le\lVert B\rVert^k\lVert\boldsymbol x^{(0)}-\boldsymbol x^*\rVert\to0
$$
得收敛——它用起来方便，却不是必要的（依赖范数的选取）。$\blacksquare$
:::

::: ex 例 6（教材 4.2.2） · 方程组不动点迭代 {#ex-4.2.1}
教材用一个 $2\times2$ 非线性方程组，把它写成 $\boldsymbol x=G(\boldsymbol x)$，验证 $G$ 在某个区域上压缩（或 $\rho(G')\lt1$），再用迭代求解；数值表展示线性收敛。
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

::: ex 例 7（教材 4.2.3） · 方程组 Newton 法 {#ex-4.2.2}
教材对例 6 的方程组用 Newton 法，每步解一个 $2\times2$ 线性方程组；与不动点迭代相比，Newton 步数少，但每步要算 Jacobian 并解线性系统。
:::

<a id="sec-4.2.4"></a>
## 4.2.4 离散 Newton 与 Newton–Steffensen

若 Jacobian 难算，用差商近似：
$$
J(\boldsymbol x^{(k)},h^{(k)})_{ij}=\frac{f_i(\boldsymbol x^{(k)}+h_j^{(k)}e_j)-f_i(\boldsymbol x^{(k)})}{h_j^{(k)}},
$$
再解
$$
J(\boldsymbol x^{(k)},h^{(k)})\Delta\boldsymbol x^{(k)}=-F(\boldsymbol x^{(k)}).
$$
这就是离散 Newton 法。取 $h_j^{(k)}=c\lVert F(\boldsymbol x^{(k)})\rVert$ 时，称为 Newton–Steffensen 方法；在定理 4.15 的条件下，适当选 $c$ 仍至少平方收敛。

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
## 习题（教材习题 10–11）

::: ex 4.10 · 方程组简单迭代（教材习题 10）{#ex-4.10}
用简单迭代法求教材习题 10 的非线性方程组。
:::

::: sol 参考答案
先把方程组写成 $\boldsymbol x=G(\boldsymbol x)$，在根附近验证 $\lVert G'(\boldsymbol x)\rVert\lt1$ 或 $\rho(G')\lt1$，再迭代；停机用相邻差。若范数不满足，换等价形式或改用 Newton。
:::

::: ex 4.11 · 方程组 Newton 法（教材习题 11）{#ex-4.11}
用 Newton 法求教材习题 11 的非线性方程组。
:::

::: sol 参考答案
写 Jacobian $F'$，每步解 $F'(\boldsymbol x^{(k)})\Delta\boldsymbol x=-F(\boldsymbol x^{(k)})$，更新 $\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\Delta\boldsymbol x$；初值要靠近根，验证 $F'(\boldsymbol x^*)$ 非奇异。
:::

::: note 覆盖核对
本节覆盖教材 4.2.1–4.2.4、定理 4.10–4.15、例 6–7、习题 10–11；**老师课堂未讲**，按教材补齐。体例转换之外做了数学补全：定理 4.11–4.15 的证明、定理 4.12 的可用形式（由 [@thm-4.11] 推出）与后验误差估计，均与一元版 [@thm-4.1]、[@thm-4.6] 平行，未引入教材之外的结论。下一节：[第 4 章习题](exercises.md)。
:::
