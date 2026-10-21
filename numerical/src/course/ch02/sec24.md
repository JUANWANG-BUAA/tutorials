# 2.4.1 迭代法引论

> 对应教材 2.4.1、定理 2.7–2.9、习题 13–14；对应老师第 4 讲 §五、第 5 讲 §一–§三。
> 主线：把 $A\boldsymbol x=\boldsymbol b$ 拆成 $A=N-P$，得到 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$；收敛性只看 $G$ 的谱半径。

<a id="sec-2.4.1"></a>
## 2.4.1 分裂与迭代格式

设 $A$ 非奇异，且 $A=N-P$，其中 $N$ 可逆。原方程等价于
$$
N\boldsymbol x=P\boldsymbol x+\boldsymbol b
\quad\Longrightarrow\quad
\boldsymbol x=N^{-1}P\boldsymbol x+N^{-1}\boldsymbol b.
$$
于是迭代格式
$$
\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d,
\qquad G=N^{-1}P,\quad \boldsymbol d=N^{-1}\boldsymbol b.
$$
实际计算**不显式求 $N^{-1}$**，而是每步解 $N\boldsymbol x^{(k+1)}=P\boldsymbol x^{(k)}+\boldsymbol b$。

**误差方程**：令 $\boldsymbol e_k=\boldsymbol x^{(k)}-\boldsymbol x^*$，则
$$
\boldsymbol e_{k+1}=G\boldsymbol e_k
\quad\Longrightarrow\quad
\boldsymbol e_k=G^k\boldsymbol e_0.
$$
所以迭代收敛 $\iff$ 对任意初值 $G^k\boldsymbol e_0\to0$ $\iff$ $G$ 的谱半径 $\rho(G)\lt1$。

<a id="sec-2.4.2"></a>
## 2.4.2 三个基本定理

**定理 2.7（范数收敛等价）**：若对某种范数 $\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert\to0$，则按分量也有 $\boldsymbol x^{(k)}\to\boldsymbol x^*$。这是有限维范数等价性的直接推论，用来把“范数收敛”与“分量收敛”互换。

**定理 2.8（充要条件）**：对任意初值 $\boldsymbol x^{(0)}$，迭代格式收敛的充要条件是
$$
\rho(G)\lt1.
$$

**证明（老师第 5 讲的对角化解耦）**：若 $G$ 可对角化，$G=T\Lambda T^{-1}$，则
$$
\boldsymbol e_k=T\Lambda^kT^{-1}\boldsymbol e_0.
$$
$\Lambda^k\to0$ $\iff$ 每个 $|\lambda_i|\lt1$。若 $G$ 不可对角化，用 Jordan 标准形：Jordan 块 $J=\lambda I+N$ 的 $k$ 次幂含 $\binom{k}{s}\lambda^{k-s}$，当 $|\lambda|\lt1$ 时仍趋于 0；反之若某个 $|\lambda|\ge1$，取对应特征向量作初值误差，$\boldsymbol e_k$ 不趋于 0。$\blacksquare$

**定理 2.9（充分条件与误差估计）**：若存在某种矩阵范数使 $\lVert G\rVert\lt1$，则

1. 方程组 $(I-G)\boldsymbol x=\boldsymbol d$ 的解存在且唯一；
2. 对任意初值，迭代收敛；
3. 有先验估计
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert
\le \frac{\lVert G\rVert^k}{1-\lVert G\rVert}\lVert\boldsymbol x^{(1)}-\boldsymbol x^{(0)}\rVert,
$$
和后验估计
$$
\lVert\boldsymbol x^{(k)}-\boldsymbol x^*\rVert
\le \frac{\lVert G\rVert}{1-\lVert G\rVert}\lVert\boldsymbol x^{(k)}-\boldsymbol x^{(k-1)}\rVert.
$$

**证明要点**：$\lVert G\rVert\lt1$ $\Rightarrow$ $I-G$ 可逆（Neumann 级数 $\sum G^k$ 收敛），且
$$
\boldsymbol x^{(k)}-\boldsymbol x^*=\sum_{j=k}^{\infty}(\boldsymbol x^{(j)}-\boldsymbol x^{(j+1)})
=\sum_{j=k}^{\infty}G^j(\boldsymbol x^{(0)}-\boldsymbol x^{(1)}),
$$
取范数即得先验估计；后验估计同理，把 $\boldsymbol x^{(k)}-\boldsymbol x^*$ 写成 $\sum_{j\ge k}G^{j-k}(\boldsymbol x^{(k)}-\boldsymbol x^{(k+1)})$。$\blacksquare$

**两条判据的分工**：

- $\rho(G)\lt1$ 是**充要**条件，但大规模问题算不出特征值；
- $\lVert G\rVert\lt1$ 是**充分**条件，容易手算（$\lVert G\rVert_1$、$\lVert G\rVert_\infty$）；
- $\rho(G)\le\lVert G\rVert$，所以范数判据更保守；$\lVert G\rVert\ge1$ 时迭代仍可能收敛。

<a id="sec-2.4.3"></a>
## 2.4.3 习题（教材习题 13–14）

::: ex 2.13 · 迭代序列收敛判断（教材习题 13）
对教材习题 13 的三个迭代公式，判断其产生的向量序列是否收敛（初值任取）。
:::

::: sol 参考答案
写出各自的迭代矩阵 $G$，算 $\rho(G)$：$\rho(G)\lt1$ 则对任意初值收敛；$\rho(G)\ge1$ 则不保证（若 $=1$，须区分“收敛到指定解”与“序列本身有极限”：$G=I$ 的误差保持常数，序列可收敛却不到指定解；$G=-I$ 的非零误差则振荡）。不要只看某个范数 $\ge1$ 就判发散——范数只是充分条件。
:::

::: ex 2.14 · 必收敛的迭代（教材习题 14）
证明教材习题 14 的迭代公式产生的序列必收敛，并指出它收敛到哪个线性方程组的解。
:::

::: sol 参考答案
把迭代写成 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$，先算 $\rho(G)$；本题已算得 $\rho(G)\approx0.6236\lt1$，由定理 2.8 得对任意初值收敛。这里 $\lVert G\rVert_\infty=1.55\gt1$，不能声称用这个范数通过定理 2.9；极限满足 $\boldsymbol x^*=G\boldsymbol x^*+\boldsymbol d$，即 $(I-G)\boldsymbol x^*=\boldsymbol d$，对应方程组 $(I-G)\boldsymbol x=\boldsymbol d$。
:::

::: note 覆盖核对
本节覆盖教材 2.4.1、定理 2.7–2.9、习题 13–14；老师第 4 讲 §五、第 5 讲 §一–§三。下一节：[2.4.2–2.4.4 Jacobi、Gauss–Seidel 与 SOR](sec25.md)。
:::
