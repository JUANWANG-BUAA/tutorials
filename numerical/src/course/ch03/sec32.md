# 3.2 Jacobi 方法

> 对应教材 3.2、定理 3.1、习题 7–8。**老师课堂未讲**，本节按教材补齐，标“教材有、课堂未讲”。
> 用途：求**实对称矩阵的全部特征值与特征向量**；用平面旋转把非对角元逐个消成零。

<a id="sec-3.2"></a>
## 3.2.1 平面旋转

设 $A$ 实对称，$a_{pq}=a_{qp}\ne0$。取平面旋转矩阵 $U_{pq}$：在 $(p,q)$ 平面内旋转 $\varphi$，
$$
U_{pp}=U_{qq}=\cos\varphi,\qquad
U_{pq}=-\sin\varphi,\qquad
U_{qp}=\sin\varphi,
$$
其余对角元为 1、非对角元为 0。令 $A_1=U_{pq}^{\mathrm T}AU_{pq}$，则 $A_1$ 仍实对称，且只有第 $p,q$ 行/列变化。直接计算得
$$
a_{pq}^{(1)}=\frac{a_{qq}-a_{pp}}{2}\sin2\varphi+a_{pq}\cos2\varphi.
$$
要消去 $a_{pq}^{(1)}$，取 $\varphi$ 满足
$$
\cot2\varphi=\frac{a_{qq}-a_{pp}}{2a_{pq}}.
$$
于是 $a_{pq}^{(1)}=a_{qp}^{(1)}=0$。

## 3.2.2 迭代算法

1. 在非对角元中找 $|a_{pq}|$ 最大者；
2. 由 $\cot2\varphi$ 求 $\sin\varphi,\cos\varphi$，构造 $U_{pq}$；
3. 按旋转公式更新 $A$（只改第 $p,q$ 行/列）；
4. 若 $\max_{i\lt j}|a_{ij}|\lt\varepsilon$，停止；否则重复。

停止时对角元就是特征值；累积的旋转矩阵 $V=U_{p_1q_1}\cdots U_{p_Nq_N}$ 的列就是特征向量。

**定理 3.1（收敛性）**：设 $A$ 实对称，$A_k$ 是第 $k$ 次迭代后的矩阵，$\tau_k=\sum_{i\ne j}(a_{ij}^{(k)})^2$。则
$$
\lim_{k\to\infty}\tau_k=0.
$$

**证明要点**：一次旋转把选中的 $a_{pq}$ 消为零，非对角平方和满足
$$
\tau_{k+1}=\tau_k-2(a_{pq}^{(k)})^2.
$$
又 $|a_{pq}^{(k)}|=\max_{i\ne j}|a_{ij}^{(k)}|$，故 $\tau_k\le n(n-1)(a_{pq}^{(k)})^2$，于是
$$
\tau_{k+1}\le\left(1-\frac{2}{n(n-1)}\right)\tau_k.
$$
几何衰减，$\tau_k\to0$。$\blacksquare$

**计算量**：一次旋转约 $8n$ 次乘法；一轮 $n(n-1)/2$ 次旋转，约 $O(n^3)$。优点是特征向量正交性好、数值稳定；缺点是不能利用稀疏/带状结构，且每次找最大元较费时。

<a id="sec-3.2.3"></a>
## 3.2.3 习题（教材习题 7–8）

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

::: note 覆盖核对
本节覆盖教材 3.2、定理 3.1、习题 7–8；**老师课堂未讲**。下一节：[3.3 QR 方法](sec33.md)。
:::
