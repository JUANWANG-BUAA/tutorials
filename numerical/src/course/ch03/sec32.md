# 3.2 Jacobi 方法

> 对应教材 3.2、定理 3.1、习题 7–8。**老师课堂未讲**，本节按教材补齐，标“教材有、课堂未讲”。
> 用途：求**实对称矩阵的全部特征值与特征向量**；用平面旋转把非对角元逐个消成零。

<a id="sec-3.2"></a>
## 3.2.1 平面旋转

设 $A$ 实对称，$a_{pq}=a_{qp}\ne0$。

::: def 定义 3.2.1 · 平面旋转矩阵 {#def-3.2.1}
在 $(p,q)$ 平面内旋转 $\varphi$ 的矩阵 $U_{pq}$：

$$
U_{pp}=U_{qq}=\cos\varphi,\qquad
U_{pq}=-\sin\varphi,\qquad
U_{qp}=\sin\varphi,
$$

其余对角元为 1、非对角元为 0。$U_{pq}$ 是正交矩阵（$U_{pq}^{\mathrm T}U_{pq}=I$），且左乘或右乘只改变第 $p,q$ 两行/两列。
:::

令 $A_1=U_{pq}^{\mathrm T}AU_{pq}$，则 $A_1$ 仍实对称，且只有第 $p,q$ 行/列变化。直接计算得

$$
a_{pq}^{(1)}=\frac{a_{qq}-a_{pp}}{2}\sin2\varphi+a_{pq}\cos2\varphi.
$$

::: proof 推导
只含 $p,q$ 的 $2\times2$ 块参与运算；在该块上 $U=\begin{pmatrix}c&-s\\s&c\end{pmatrix}$（$c=\cos\varphi,\ s=\sin\varphi$），其余行列单元不变：

$$
(A_1)_{pq}=(U^{\mathrm T}AU)_{pq}
=c\,(-s\,a_{pp}+c\,a_{pq})+s\,(-s\,a_{qp}+c\,a_{qq})
=(c^2-s^2)a_{pq}+cs\,(a_{qq}-a_{pp}),
$$

即 $a_{pq}^{(1)}=a_{pq}\cos2\varphi+\dfrac{a_{qq}-a_{pp}}{2}\sin2\varphi$。同法得 $(A_1)_{pp}=c^2a_{pp}+2cs\,a_{pq}+s^2a_{qq}$、$(A_1)_{qq}=s^2a_{pp}-2cs\,a_{pq}+c^2a_{qq}$，且 $a_{pq}^{(1)}=a_{qp}^{(1)}$；$A$ 对称 ⟹ $A_1$ 对称。$\blacksquare$
:::

要消去 $a_{pq}^{(1)}$，取 $\varphi$ 满足

$$
\cot2\varphi=\frac{a_{pp}-a_{qq}}{2a_{pq}}.
$$

于是 $a_{pq}^{(1)}=a_{qp}^{(1)}=0$。

::: note 旋转矩阵的符号约定
不同教材对 $U_{pq}$ 非对角元的符号约定不同：若定义 $U_{pq}=+\sin\varphi$，则同一公式写成 $\cot2\varphi=\dfrac{a_{qq}-a_{pp}}{2a_{pq}}$——分子差一个符号。照抄公式而不核对约定，旋转变换就消不掉非对角元。本节一律以 [@def-3.2.1] 的 $U_{pq}=-\sin\varphi$ 为准。
:::

::: method 由 $\cot2\varphi$ 稳定地求 $\sin\varphi,\cos\varphi$
记 $\tau=\dfrac{a_{pp}-a_{qq}}{2a_{pq}}$（即 $\cot2\varphi=\tau$）。取

$$
t=\tan\varphi=\frac{\operatorname{sgn}\tau}{|\tau|+\sqrt{1+\tau^2}},\qquad
c=\cos\varphi=\frac{1}{\sqrt{1+t^2}},\qquad
s=\sin\varphi=t\,c .
$$

这支解满足 $|\varphi|\le45^\circ$，且分母 $|\tau|+\sqrt{1+\tau^2}\ge1$ 无相消。$a_{pp}=a_{qq}$（即 $\tau=0$）时直接取 $\varphi=45^\circ$（$t=1$）；此时 $a_{pq}^{(1)}=a_{pq}\cos2\varphi=0$ 要求 $\cos2\varphi=0$。
:::

## 3.2.2 迭代算法

::: method[core] 算法 · Jacobi 迭代
1. 在非对角元中找 $|a_{pq}|$ 最大者；
2. 由 $\cot2\varphi$ 求 $\sin\varphi,\cos\varphi$，构造 $U_{pq}$；
3. 按旋转公式更新 $A$（只改第 $p,q$ 行/列）；
4. 若 $\max_{i\lt j}|a_{ij}|\lt\varepsilon$，停止；否则重复。
:::

停止时对角元就是特征值；累积的旋转矩阵 $V=U_{p_1q_1}\cdots U_{p_Nq_N}$ 的列就是特征向量。

::: note 为什么 $V$ 的列是特征向量
记 $V_k=U_1U_2\cdots U_k$，则每步**精确**有 $A_k=V_k^{\mathrm T}AV_k$——$A_k$ 与 $A$ 正交相似，特征值一步不变。停机时有 $A_k\approx\Lambda$（对角），于是 $AV_k=V_kA_k\approx V_k\Lambda$：对角线给出特征值，$V_k$ 的列给出对应的特征向量；$V_k$ 正交，故这些特征向量自动正交。严格说「列是特征向量」是极限意义下的结论，每步成立的是相似关系。
:::

::: thm 定理 3.1 · Jacobi 方法的收敛性 {#thm-3.1}
设 $A$ 实对称，$A_k$ 是第 $k$ 次迭代后的矩阵，

$$\tau_k=\sum_{i\ne j}\left(a_{ij}^{(k)}\right)^2$$

（**有序对**求和：$(i,j)$ 与 $(j,i)$ 各计一次）。则

$$
\lim_{k\to\infty}\tau_k=0,
$$

从而 $A_k\to$ 对角矩阵，对角元趋于 $A$ 的特征值，$V$ 的列趋于对应的正交特征向量。
:::

::: proof 证明
**第一步：一次旋转让 $\tau$ 减少多少。** 一次旋转只改第 $p,q$ 行/列。只看 $2\times2$ 块：旋转后 $a_{pq}^{(k+1)}=0$，块的迹不变（$a_{pp}'+a_{qq}'=a_{pp}+a_{qq}$），块的行列式不变（$a_{pp}'a_{qq}'=a_{pp}a_{qq}-a_{pq}^2$），于是

$$
(a_{pp}')^2+(a_{qq}')^2=(a_{pp}+a_{qq})^2-2(a_{pp}a_{qq}-a_{pq}^2)=a_{pp}^2+a_{qq}^2+2a_{pq}^2,
$$

即**对角**平方和增加 $2(a_{pq}^{(k)})^2$。又 $A_{k+1}=U^{\mathrm T}A_kU$ 为正交相似，Frobenius 范数 $\sum_{i,j}(a_{ij})^2$ 不变，故**非对角**平方和恰好减少同样多：

$$
\tau_{k+1}=\tau_k-2\left(a_{pq}^{(k)}\right)^2.
$$

**第二步：衰减率。** 算法取 $|a_{pq}^{(k)}|=\max_{i\ne j}|a_{ij}^{(k)}|$，而 $\tau_k$ 是 $n(n-1)$ 个非负项之和，故

$$
\tau_k\le n(n-1)\left(a_{pq}^{(k)}\right)^2
\quad\Longrightarrow\quad
\tau_{k+1}\le\left(1-\frac{2}{n(n-1)}\right)\tau_k.
$$

$n=2$ 时因子为 $0$（一次旋转即精确对角化，见[例 3.2.1](#ex-3.2.1)）；$n\ge3$ 时因子属于 $[0,1)$，$\tau_k$ 几何衰减，$\tau_k\to0$。于是 $\max_{i\lt j}|a_{ij}^{(k)}|\to0$，$A_k\to\Lambda$（对角），由 $A_k=V_k^{\mathrm T}AV_k$ 取极限即得特征值与特征向量。$\blacksquare$
:::

::: method[core] 计算量与特点
一次旋转约 $8n$ 次乘法；一轮 $n(n-1)/2$ 次旋转，约 $O(n^3)$。优点是特征向量正交性好、数值稳定；缺点是不能利用稀疏/带状结构，且每次找最大元较费时。改进：改用**循环 Jacobi**（按固定次序轮转，免去每步全盘扫描）或**阈值 Jacobi**（只旋转模超过当前阈值的元），可显著降低每轮成本。Jacobi 只适用于**实对称**矩阵。
:::

::: ex 例 3.2.1（新增演算） · 一次旋转对角化 $2\times2$ {#ex-3.2.1}
取

$$
A=\begin{pmatrix}1&1\\1&2\end{pmatrix},\qquad (p,q)=(1,2):\ a_{pp}=1,\ a_{qq}=2,\ a_{pq}=1.
$$

$\tau=\dfrac{a_{pp}-a_{qq}}{2a_{pq}}=-\dfrac12$，于是

$$
t=\frac{\operatorname{sgn}\tau}{|\tau|+\sqrt{1+\tau^2}}=-\frac{1}{\tfrac12+\tfrac{\sqrt5}{2}}=-\frac{\sqrt5-1}{2}\approx-0.618034,
$$

$$
c=\frac{1}{\sqrt{1+t^2}}\approx0.850651,\qquad s=tc\approx-0.525731,
$$

$$
U=\begin{pmatrix}c&-s\\s&c\end{pmatrix}
=\begin{pmatrix}0.850651&0.525731\\-0.525731&0.850651\end{pmatrix},
$$

$$
U^{\mathrm T}AU=\begin{pmatrix}0.381966&0\\0&2.618034\end{pmatrix}
=\begin{pmatrix}\frac{3-\sqrt5}{2}&0\\[4pt]0&\frac{3+\sqrt5}{2}\end{pmatrix}.
$$

核对：迹 $1+2=3=0.381966+2.618034$ ✓；行列式 $2-1=1=0.381966\times2.618034$ ✓；非对角平方和 $\tau_0=2\to\tau_1=0=\tau_0-2a_{pq}^2$ ✓（$n=2$ 时定理 3.1 的衰减因子 $1-\frac{2}{n(n-1)}=0$，一步到位）。特征向量即 $U$ 的列：$\lambda=\frac{3-\sqrt5}{2}\leftrightarrow(0.850651,-0.525731)^{\mathrm T}$（第一列），$\lambda=\frac{3+\sqrt5}{2}\leftrightarrow(0.525731,0.850651)^{\mathrm T}$（第二列）——直接验证 $A(0.525731,0.850651)^{\mathrm T}=2.618034\,(0.525731,0.850651)^{\mathrm T}$ ✓。
:::

<a id="sec-3.2-exercises"></a>
## 习题（教材习题 7–8）

::: ex 3.7 · Jacobi 方法求全部特征值（教材习题 7）
用 Jacobi 方法求教材习题 7 中 $3\times3$ 实对称矩阵的全部特征值与特征向量，取 $\varepsilon=10^{-5}$。
:::

::: sol 参考答案
按 3.2.2 迭代：每次选模最大非对角元，算 $\cot2\varphi$、旋转、更新；直到非对角元最大值小于 $10^{-5}$。对角元即特征值，累积旋转矩阵的列为特征向量。具体数值按教材矩阵复算。
:::

::: ex 3.8 · 分块三角矩阵（教材习题 8）
设 $T=\begin{pmatrix}P_{3\times3}&0\\0&Q_{2\times2}\end{pmatrix}$，证明 $P$ 的特征值/特征向量与 $Q$ 的特征值/特征向量都可延拓为 $T$ 的特征值/特征向量。
:::

::: sol 参考答案
若 $Px=\lambda x$，则 $T\begin{pmatrix}x\\0\end{pmatrix}=\begin{pmatrix}Px\\0\end{pmatrix}=\lambda\begin{pmatrix}x\\0\end{pmatrix}$；同理 $Qy=\mu y$ 给出 $T\begin{pmatrix}0\\y\end{pmatrix}=\mu\begin{pmatrix}0\\y\end{pmatrix}$。分块对角矩阵的谱是两块谱的并集。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| 平面旋转 | 正交相似变换，只动 $p,q$ 两行两列 | [@def-3.2.1] | [3.3.1](sec33.md#sec-3.3.1) Householder 是「多列版」反射 |
| 消元条件 | $\cot2\varphi=(a_{pp}-a_{qq})/(2a_{pq})$（随 $U$ 的符号约定而变） | 3.2.1 | — |
| 收敛性 | $\tau_k$ 每步减 $2a_{pq}^2$，几何衰减到 0 | [@thm-3.1] | [补充篇 2.5](../../supplement/sec25.md) 对称谱理论 |
| 特征向量 | 累积旋转矩阵 $V=U_1\cdots U_k$ 的列，自动正交 | 3.2.2 | [补充篇 2.5](../../supplement/sec25.md) |
| 计算量 | 一次旋转约 $8n$，一轮 $O(n^3)$；破坏稀疏结构 | 3.2.2 方法盒 | [3.3](sec33.md) QR 方法更适合一般矩阵 |
:::

::: think 本节常见错误
1. **$\cot2\varphi$ 的符号随旋转矩阵约定而变。** 本节 $U_{pq}=-\sin\varphi$ 对应 $\cot2\varphi=(a_{pp}-a_{qq})/(2a_{pq})$；照抄 $U_{pq}=+\sin\varphi$ 的教材会差一个符号，消不掉非对角元。
2. **$\tau$ 的求和口径不一致。** 定理 3.1 的 $\tau=\sum_{i\ne j}$ 是有序对求和；按无序对算，恒等式 $\tau_{k+1}=\tau_k-2a_{pq}^2$ 会差一个因子 2。
3. **只更新 $p,q$ 两行，忘了对称的两列。** $A$ 必须保持实对称，$(p,q)$ 与 $(q,p)$ 要同时写。
4. **停机准则看对角元。** 对角元逼近特征值时非对角元仍可能有贡献；应看 $\max_{i\lt j}\lvert a_{ij}\rvert\lt\varepsilon$。
5. **对非对称矩阵用 Jacobi。** 收敛性定理只对实对称矩阵成立；一般矩阵用 [3.3](sec33.md) 的 QR 方法。
:::

::: note 覆盖核对
本节覆盖教材 3.2、定理 3.1、习题 7–8（另新增 $2\times2$ 演算例 3.2.1 与 $\cot2\varphi$ 稳定求法）；**老师课堂未讲**。下一节：[3.3 QR 方法](sec33.md)。
:::
