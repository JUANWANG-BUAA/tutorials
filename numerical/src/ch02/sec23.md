# 2.3 正交化与 QR 分解

2.1 说「标准正交基下求解退化成做内积」，2.2 说「投影与最小二乘的关键是列空间的正交结构」——两句话指向同一个技术需求：**把一组线性无关的向量造成标准正交基**。最有用的产物是 **QR 分解** $A=QR$（$m\gt n$ 时 $Q$ 为列正交的长方阵，见 [@def-2.1.3]）：最小二乘、特征值、SVD 共用一个稳定内核。本节给出四种正交化方法（经典与修正 Gram–Schmidt、Householder 反射、Givens 旋转），并用实测数据说明取舍标准。

<a id="sec-2.3.1"></a>

## 2.3.1 Gram–Schmidt 正交化

::: intuition 直觉 · 一步一步「减去投影」
想造一组互相垂直的向量，手上却只有一组歪斜的 $\boldsymbol{a}_1,\dots,\boldsymbol{a}_n$。做法极其朴素：

1. 拿第一个向量，拉成单位长，作为第一个坐标轴方向 $\boldsymbol{q}_1$；
2. 拿第二个向量，**减去它在 $\boldsymbol{q}_1$ 上的投影**（投影公式见 [2.2.3](sec22.md#sec-2.2.3)），剩下的部分自然垂直于 $\boldsymbol{q}_1$；单位化，得 $\boldsymbol{q}_2$；
3. 拿第三个向量，减去它在 $\boldsymbol{q}_1$ **和** $\boldsymbol{q}_2$ 上的投影，剩下的部分垂直于前两个；单位化，得 $\boldsymbol{q}_3$；
4. 依此类推，直到第 $n$ 个向量。

**每加一个新轴，就把新向量里「已经用过的方向」全部扣掉**，剩下的必然是全新的垂直方向。这就是 Gram–Schmidt。
:::

::: method 算法 2.3.1 · 经典 Gram–Schmidt（CGS）

**输入** 线性无关向量组 $\boldsymbol{a}_1,\dots,\boldsymbol{a}_n$（即 $A$ 的列，$A$ 列满秩）。
**输出** 标准正交组 $\boldsymbol{q}_1,\dots,\boldsymbol{q}_n$ 与上三角矩阵 $R$，使 $A=QR$。

```
for j = 1, ..., n:
    v = a_j                                  # 从原始向量出发
    for i = 1, ..., j-1:
        r_ij = q_i^T a_j                      # 注意：用 q_i 内积【原始】a_j
        v = v - r_ij * q_i
    r_jj = ||v||_2
    q_j  = v / r_jj
```

**复杂度：** 每个 $(i,j)$ 组合要做一次内积（$2m$ flops）和一次向量修正（$2m$ flops），共约 $2mn^2$ flops（$m\ge n$），与 QR 分解同量级。
:::

::: thm 定理 2.3.1（新增） · Gram–Schmidt 的正确性与 QR 分解 {#thm-2.3.1}
设 $\boldsymbol{a}_1,\dots,\boldsymbol{a}_n$ 线性无关（$A=[\boldsymbol{a}_1,\dots,\boldsymbol{a}_n]\in\mathbb{R}^{m\times n}$，$m\ge n$），则由算法 2.3.1 得到的 $\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_n\}$ 是标准正交组，且

$$A=QR,\qquad Q=[\boldsymbol{q}_1,\dots,\boldsymbol{q}_n]\in\mathbb{R}^{m\times n}\ (Q^{\mathrm T}Q=I_n),\qquad R=[r_{ij}]\in\mathbb{R}^{n\times n}\ \text{上三角且对角元}\gt0 . \tag{2.14}$$

::: proof 证明
**归纳证明正交性。** 假设 $\boldsymbol{q}_1,\dots,\boldsymbol{q}_{j-1}$ 已标准正交。算法中 $\boldsymbol{v}=\boldsymbol{a}_j-\sum_{i\lt j}r_{ij}\boldsymbol{q}_i$。对任意 $k\lt j$，

$$\boldsymbol{q}_k^{\mathrm T}\boldsymbol{v}=\boldsymbol{q}_k^{\mathrm T}\boldsymbol{a}_j-\sum_{i\lt j}r_{ij}\underbrace{\boldsymbol{q}_k^{\mathrm T}\boldsymbol{q}_i}_{\delta_{ki}}=\boldsymbol{q}_k^{\mathrm T}\boldsymbol{a}_j-r_{kj}=\boldsymbol{q}_k^{\mathrm T}\boldsymbol{a}_j-\boldsymbol{q}_k^{\mathrm T}\boldsymbol{a}_j=0 .$$

（CGS 里 $r_{kj}=\boldsymbol{q}_k^{\mathrm T}\boldsymbol{a}_j$ 恰好就是 $\boldsymbol{q}_k$ 在原向量上的系数，所以 $\boldsymbol{q}_k^{\mathrm T}\boldsymbol{v}=0$ 在精确算术下**精确**成立。）所以新向量与所有旧轴都正交；且 $\boldsymbol{v}\neq\boldsymbol{0}$（否则 $\boldsymbol{a}_j\in\operatorname{span}\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_{j-1}\}=\operatorname{span}\{\boldsymbol{a}_1,\dots,\boldsymbol{a}_{j-1}\}$，与线性无关矛盾），因此可以单位化。

**$A=QR$：** 由 $\boldsymbol{v}=r_{jj}\boldsymbol{q}_j$ 与 $\boldsymbol{v}$ 的定义反解，

$$\boldsymbol{a}_j=r_{jj}\boldsymbol{q}_j+r_{ij}\boldsymbol{q}_i+\cdots+r_{j-1,j}\boldsymbol{q}_{j-1},$$

即 $A$ 的第 $j$ 列是 $Q$ 前 $j$ 列的线性组合，系数正好是 $R$ 的第 $j$ 列——这正是 $A=QR$。又 $r_{jj}=\lVert\boldsymbol{v}\rVert_2\gt0$。

**几何含义：** $Q$ 与 $A$ 逐列张成同一个子空间，即 $C(Q)=C(A)$，但 $Q$ 的列标准正交；$R$ 记录的是「正交坐标 → 原坐标」的换算。由上面的证明还能看出更强的结构：

$$\operatorname{span}\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_k\}=\operatorname{span}\{\boldsymbol{a}_1,\dots,\boldsymbol{a}_k\}\qquad(k=1,\dots,n) . \tag{2.15}$$

**（2.15）是 QR 分解区别于 SVD 的关键性质**，也是 QR 迭代求特征值（原书第 3 章 3.3 节）的基础。
:::

:::

::: ex 例 2.3.1（新增） · 三向量的 Gram–Schmidt 手算 {#ex-2.3.1}
对

$$A=\begin{pmatrix}1&1&0\\1&0&1\\0&1&1\end{pmatrix}$$

做 Gram–Schmidt，求出 $Q$ 与 $R$（保留根号形式）。

::: proof 解
**第 1 列。** $\boldsymbol{a}_1=(1,1,0)^{\mathrm T}$，$\lVert\boldsymbol{a}_1\rVert=\sqrt2$，故

$$r_{11}=\sqrt2,\qquad \boldsymbol{q}_1=\frac{1}{\sqrt2}\begin{pmatrix}1\\1\\0\end{pmatrix}.$$

**第 2 列。** $r_{12}=\boldsymbol{q}_1^{\mathrm T}\boldsymbol{a}_2=\dfrac{1\cdot1+1\cdot0+0\cdot1}{\sqrt2}=\dfrac{1}{\sqrt2}$。

$$\boldsymbol{v}=\boldsymbol{a}_2-r_{12}\boldsymbol{q}_1=\begin{pmatrix}1\\0\\1\end{pmatrix}-\frac12\begin{pmatrix}1\\1\\0\end{pmatrix}=\begin{pmatrix}\frac12\\-\frac12\\1\end{pmatrix}.$$

$$\lVert\boldsymbol{v}\rVert=\sqrt{\tfrac14+\tfrac14+1}=\frac{\sqrt6}{2},\qquad
r_{22}=\frac{\sqrt6}{2},\qquad
\boldsymbol{q}_2=\frac{1}{\sqrt6}\begin{pmatrix}1\\-1\\2\end{pmatrix}.$$

**第 3 列。** $r_{13}=\boldsymbol{q}_1^{\mathrm T}\boldsymbol{a}_3=\dfrac{0+1+0}{\sqrt2}=\dfrac{1}{\sqrt2}$；$r_{23}=\boldsymbol{q}_2^{\mathrm T}\boldsymbol{a}_3=\dfrac{1}{\sqrt6}(0-1+2)=\dfrac{1}{\sqrt6}$。

$$\boldsymbol{v}=\boldsymbol{a}_3-r_{13}\boldsymbol{q}_1-r_{23}\boldsymbol{q}_2
=\begin{pmatrix}0\\1\\1\end{pmatrix}-\frac12\begin{pmatrix}1\\1\\0\end{pmatrix}-\frac16\begin{pmatrix}1\\-1\\2\end{pmatrix}
=\begin{pmatrix}-\frac23\\\frac23\\\frac23\end{pmatrix}.$$

$$\lVert\boldsymbol{v}\rVert=\frac{2}{\sqrt3},\qquad r_{33}=\frac{2}{\sqrt3},\qquad
\boldsymbol{q}_3=\frac{\sqrt3}{2}\cdot\frac23\begin{pmatrix}-1\\1\\1\end{pmatrix}=\frac{1}{\sqrt3}\begin{pmatrix}-1\\1\\1\end{pmatrix}.$$

**结果：**

$$Q=\begin{pmatrix}\frac{1}{\sqrt2}&\frac{1}{\sqrt6}&-\frac{1}{\sqrt3}\\[2pt]\frac{1}{\sqrt2}&-\frac{1}{\sqrt6}&\frac{1}{\sqrt3}\\[2pt]0&\frac{2}{\sqrt6}&\frac{1}{\sqrt3}\end{pmatrix},\qquad
R=\begin{pmatrix}\sqrt2&\frac{1}{\sqrt2}&\frac{1}{\sqrt2}\\[2pt]0&\frac{\sqrt6}{2}&\frac{1}{\sqrt6}\\[2pt]0&0&\frac{2}{\sqrt3}\end{pmatrix}.$$

**核对：** $\boldsymbol{q}_1^{\mathrm T}\boldsymbol{q}_2=\frac{1-1+0}{\sqrt{12}}=0$ ✓；$\boldsymbol{q}_1^{\mathrm T}\boldsymbol{q}_3=\frac{-1+1+0}{\sqrt6}=0$ ✓；$\boldsymbol{q}_2^{\mathrm T}\boldsymbol{q}_3=\frac{-1-1+2}{\sqrt{18}}=0$ ✓；三个范数均为 $1$ ✓；$QR$ 能复原 $A$ ✓。

**注意 $R$ 的对角元都为正**——这是 [@thm-2.3.2] 唯一性条款的来源。

**手算口诀：** 每一列先算它与已有各轴的内积（即 $r_{ij}$），逐个扣掉；剩余向量的长度就是 $r_{jj}$。**全程只需要「内积」和「减法」。**
:::

:::

<a id="sec-2.3.2"></a>

## 2.3.2 QR 分解的存在唯一性

::: thm 定理 2.3.2（新增） · QR 分解的存在与唯一性 {#thm-2.3.2}
**存在性：** 设 $A\in\mathbb{R}^{m\times n}$（$m\ge n$）列满秩，则存在 $Q\in\mathbb{R}^{m\times n}$ 列正交（$Q^{\mathrm T}Q=I_n$）与对角元为正的上三角 $R\in\mathbb{R}^{n\times n}$，使 $A=QR$。（由 [@thm-2.3.1] 直接得到。）

**唯一性：** 在「$R$ 的对角元全为正」的规范化下，这样的分解**唯一**。

**全 QR（full QR）：** 若把 $Q$ 补全为 $m$ 阶正交方阵 $\bar Q=[Q,\ Q_\perp]$（$Q_\perp$ 的列是 $C(A)^{\perp}=N(A^{\mathrm T})$ 的标准正交基，见 [2.2.1](sec22.md#sec-2.2.1)），则

$$A=\bar Q\bar R,\qquad \bar R=\begin{pmatrix}R\\O\end{pmatrix}\in\mathbb{R}^{m\times n},$$

其中 $Q_\perp$ 的列在乘积中不起作用，对应的系数是零块。

::: proof 证明（唯一性）
设有两种分解 $A=Q_1R_1=Q_2R_2$，$Q_1^{\mathrm T}Q_1=Q_2^{\mathrm T}Q_2=I$，$R_1,R_2$ 上三角且对角元为正。由 $Q_1$ 列满秩，$Q_2^{\mathrm T}Q_1$ 是 $n\times n$ 可逆阵，且

$$Q_2^{\mathrm T}Q_1=R_2R_1^{-1}=:S .$$

**等号左边列正交、右边上三角**（上三角阵的逆仍是上三角，乘积也是上三角），所以 $S$ 是上三角阵。又由 $Q_1=Q_2S$ 得

$$I=Q_1^{\mathrm T}Q_1=S^{\mathrm T}Q_2^{\mathrm T}Q_2S=S^{\mathrm T}S,$$

故 $S$ **也是正交矩阵**。**上三角且正交的矩阵必为对角阵，对角元为 $\pm1$**：正交性要求 $S$ 的各列是单位向量且两两正交；看 $S$ 的第 1 列，它的第 $2,\dots,n$ 个分量为零，于是只剩 $s_{11}=\pm1$；归纳地看第 $k$ 列，它的第 $k+1,\dots,n$ 个分量为零，又要与前 $k-1$ 列正交（那些列都只有第 $i$ 个分量非零），于是也只剩 $s_{kk}=\pm1$。

最后由 $S=R_2R_1^{-1}$ 得 $s_{ii}=r_{ii}^{(2)}/r_{ii}^{(1)}\gt0$（对角元都为正），结合 $\lvert s_{ii}\rvert=1$ 得 $s_{ii}=1$。故 $S=I$，于是 $Q_1=Q_2$、$R_1=R_2$。
:::

:::

::: note 秩亏时怎么办
若 $A$ 不满秩，Gram–Schmidt 会在某一步得到 $\boldsymbol{v}=\boldsymbol{0}$（$r_{jj}=0$）：分解仍然存在，但**不再唯一**（唯一性证明中断在「$R_1$ 可逆」处）。实用做法是**列主元 QR**（column-pivoted QR）：每一步把剩余部分范数最大的列换到前面，得到

$$AP=QR,\qquad \lvert r_{11}\rvert\ge\lvert r_{22}\rvert\ge\cdots\ge\lvert r_{nn}\rvert ,$$

这样得到的 $\lvert r_{kk}\rvert$ 还能给出**秩的估计**：它相对 $\lvert r_{11}\rvert$ 骤降的位置，就是数值秩的候选。这正是 LAPACK 的 `geqp3` 与 MATLAB `qr(A,0)` 走的路径。与 SVD 的对比见 [2.6.5](sec26.md#sec-2.6.5)。
:::

<a id="sec-2.3.3"></a>

## 2.3.3 经典 Gram–Schmidt 的致命缺陷：修正版

算法 2.3.1（CGS）在**精确算术**下完美无缺，在**浮点**下却有一个严重缺陷：**它看起来很好，实际很差**——正是 2.1 提到的「静默失效」的第二个实例。

::: intuition 直觉 · 差别只有一个「时态」
CGS 与修正 Gram–Schmidt（MGS）的代码只差一行：算 $r_{ij}$ 时，CGS 用**原始的** $\boldsymbol{a}_j$，MGS 用**被前几轮修正过的** $\boldsymbol{q}_j$ 当前值。

$$\text{CGS:}\quad r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{a}_j\qquad\qquad
\text{MGS:}\quad r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{v}\ \ (\boldsymbol{v}\ \text{是当前值})$$

精确算术下两者**数学等价**（内积值逐次相同）。但在浮点下，MGS 的每次内积都作用在「已经扣掉旧分量」的向量上，**误差不会被后续步骤反复引用**；CGS 恰好相反：每个 $\boldsymbol{q}_j$ 携带的舍入误差都会被后面所有列的修正一遍遍引用，并在那些列上累积出一个 $\mathrm{cond}(A)$ 的额外因子。**一行之差，稳定性量级相差一个 $\mathrm{cond}$。**
:::

::: method 算法 2.3.2 · 修正 Gram–Schmidt（MGS）

```
for j = 1, ..., n:
    v = a_j                                  # 从原始向量出发
    for i = 1, ..., j-1:
        r_ij = q_i^T v                        # 注意：用 q_i 内积【当前】v
        v = v - r_ij * q_i                    # v 被就地更新
    r_jj = ||v||_2
    q_j  = v / r_jj
```

**与 CGS 的唯一差别**是：$r_{ij}$ 用当前的 $\boldsymbol{v}$（即 $\boldsymbol{q}_j$ 的当前值），而不是原始的 $\boldsymbol{a}_j$。精确算术下两者给出的 $Q,R$ **完全相同**；浮点下 MGS 的正交误差小得多。

**代价：** 两者 flops 几乎相同（MGS 略多），但 MGS 的**访存模式**不如 CGS 适合向量化（CGS 的内积可以一次性对所有列批量做）。历史上因此出现过「CGS + 再正交化」方案：做两遍 CGS 就能达到 MGS 的量级。现代库则直接用 Householder。
:::

::: method 实测对照 · 正交性损失（本章运行数据）

对 $n\times n$ Vandermonde 矩阵 $A=[x_i^{\,j-1}]$（$x_i$ 均匀取自 $[0.1,1]$，$\mathrm{cond}_2$ 随 $n$ 快速增大）分别用三种方法做 QR 分解，报告正交性损失 $\lVert Q^{\mathrm T}Q-I\rVert_2$：

| $n$ | $\mathrm{cond}_2(A)$ | CGS | MGS | Householder |
|:--:|:--:|:--:|:--:|:--:|
| 6 | $1.02\times10^{4}$ | $8.8\times10^{-10}$ | $1.5\times10^{-13}$ | $1.2\times10^{-15}$ |
| 8 | $7.40\times10^{5}$ | $2.5\times10^{-5}$ | $2.3\times10^{-11}$ | $1.3\times10^{-15}$ |
| 10 | $5.60\times10^{7}$ | $\mathbf{1.19}$ | $8.1\times10^{-10}$ | $2.5\times10^{-15}$ |
| 12 | $4.34\times10^{9}$ | $\mathbf{2.46}$ | $1.2\times10^{-7}$ | $2.1\times10^{-15}$ |
| 14 | $3.42\times10^{11}$ | $\mathbf{4.48}$ | $4.7\times10^{-6}$ | $2.2\times10^{-15}$ |
| 16 | $2.73\times10^{13}$ | $\mathbf{6.55}$ | $4.7\times10^{-4}$ | $3.0\times10^{-15}$ |

三点结论：

1. **Householder 永远 $\sim u$**（$10^{-15}$）：与 $\mathrm{cond}(A)$ **完全无关**。这是「每一步都用正交变换」的回报。
2. **MGS 按 $\mathrm{cond}(A)\cdot u$ 增长**：$n=14$ 时 $\mathrm{cond}\cdot u=3.8\times10^{-5}$，实测 $4.7\times10^{-6}$；$n=16$ 时 $3.0\times10^{-3}$ 对 $4.7\times10^{-4}$——同量级 ✓。
3. **CGS 按 $\mathrm{cond}^2(A)\cdot u$ 增长，随后饱和**：$n=10$ 时 $\mathrm{cond}^2u=3.5\times10^{-1}$、实测已到 $1.2$；$n\ge12$ 时 $\mathrm{cond}^2u\gg1$，实测停在 $O(1)\sim O(10)$——**正交性完全丧失**（$\lVert Q^{\mathrm T}Q-I\rVert_2$ 的平凡上界是 $n+1$，$n=16$ 时为 $17$）。

**分界线：** $\mathrm{cond}(A)^2u\gtrsim1$，即 $\mathrm{cond}(A)\gtrsim u^{-1/2}\approx10^{8}$（双精度）。超过它，CGS 彻底失效；MGS 还能撑到 $\mathrm{cond}\approx u^{-1}\approx10^{16}$。**结论：要用 Gram–Schmidt 就必须用 MGS；要最好的正交性，用 Householder。**
:::

::: ex 例 2.3.2（新增） · 亲手看见 CGS 失效（数值实验） {#ex-2.3.2}
用 Python 复现上面这张表，并回答：为什么 CGS 的 $\lVert Q^{\mathrm T}Q-I\rVert$ 会「饱和」在 $O(1)$，而 MGS 不会？

::: proof 解
```python
import numpy as np
u = np.finfo(float).eps / 2      # 单位舍入误差 ≈ 1.11e-16

def cgs(A):                      # 经典：r_ij 用【原始】列
    m, n = A.shape; Q = A.astype(float).copy(); R = np.zeros((n, n))
    for j in range(n):
        for i in range(j):
            R[i, j] = Q[:, i] @ A[:, j]
            Q[:, j] -= R[i, j] * Q[:, i]
        R[j, j] = np.linalg.norm(Q[:, j]); Q[:, j] /= R[j, j]
    return Q, R

def mgs(A):                      # 修正：r_ij 用【当前】列
    m, n = A.shape; Q = A.astype(float).copy(); R = np.zeros((n, n))
    for j in range(n):
        for i in range(j):
            R[i, j] = Q[:, i] @ Q[:, j]
            Q[:, j] -= R[i, j] * Q[:, i]
        R[j, j] = np.linalg.norm(Q[:, j]); Q[:, j] /= R[j, j]
    return Q, R

print(f"{'n':>3} {'cond':>10} {'CGS':>11} {'MGS':>11} {'cond*u':>10} {'cond^2*u':>10}")
for n in [6, 8, 10, 12, 14, 16]:
    x = np.linspace(0.1, 1.0, n); A = np.vander(x, n, increasing=True)
    c = np.linalg.cond(A)
    f = lambda Q: np.linalg.norm(Q.T @ Q - np.eye(n))
    print(f"{n:3d} {c:10.2e} {f(cgs(A)[0]):11.2e} {f(mgs(A)[0]):11.2e} {c*u:10.2e} {c*c*u:10.2e}")
```

```text
  n       cond         CGS         MGS     cond*u   cond^2*u
  6   1.02e+04    8.78e-10    1.47e-13    1.1e-12    1.2e-08
  8   7.40e+05    2.51e-05    2.28e-11    8.2e-11    6.1e-05
 10   5.60e+07    1.19e+00    8.11e-10    6.2e-09    3.5e-01
 12   4.35e+09    2.47e+00    1.24e-07    4.8e-07    2.1e+03
 14   3.42e+11    4.48e+00    4.70e-06    3.8e-05    1.3e+07
 16   2.73e+13    6.55e+00    4.70e-04    3.0e-03    8.3e+10
```

**为什么 CGS 饱和而 MGS 不饱和？**

**（i）误差的「引用结构」不同。** CGS 的系数 $r_{ij}$ 用**原始** $\boldsymbol{a}_j$ 计算，而 $\boldsymbol{a}_j$ 在第 $j$ 步之前从未被修正过；于是 $\boldsymbol{q}_j$ 一旦带上舍入误差，这个误差就会被后来**所有更大下标** $j'$ 的系数计算反复引用，按 $\mathrm{cond}$ 逐层累积。而 MGS 每一步用的都是已经扣掉旧分量的当前向量，误差只被引用一次。

**（ii）「饱和」只是平凡的几何效应，不代表安全。** $\lVert Q^{\mathrm T}Q-I\rVert_2$ 的最大可能值是 $\lVert Q^{\mathrm T}Q\rVert_2+1\le\lVert Q\rVert_2^2+1$。当 CGS 算出的 $\hat Q$ 已经几乎不正交（各列趋于平行）时，$\lVert\hat Q\rVert_2$ 增长到 $\sqrt n$ 量级，这个指标就只能停在 $O(n)$——**错到顶了，再坏也坏不下去**。

$n=10$ 时理论值 $\mathrm{cond}^2u=0.35$ 尚小于 $1$，实测 $1.19$ 已饱和；$n\ge12$ 时理论值远大于 $1$，实测停在 $2.5\sim6.6$。所以**「不再增长」恰恰是最坏的情形**。

**验收标准：** 输出应与上表同量级（逐位因平台的 BLAS 实现而异）；把 $x$ 换成更病态的分布（如几何分布 $x_i=0.5^{\,i-1}$），观察 $\mathrm{cond}$ 与表中 CGS、MGS 两列误差是否同步增大。
:::

:::

<a id="sec-2.3.4"></a>

## 2.3.4 Householder 反射

MGS 补上了 CGS 的漏洞，误差却仍按 $\mathrm{cond}\cdot u$ 增长。要彻底摆脱条件数，就得让**每一步都是正交变换**——正交变换不放大误差（[@thm-2.1.6]）。Householder 反射是这种做法最简洁的实现。

::: intuition 直觉 · 用一面镜子把向量「拍」到坐标轴上
给你 $\boldsymbol{x}\in\mathbb{R}^k$，想把它变成 $\pm\lVert\boldsymbol{x}\rVert_2\boldsymbol{e}_1$（除第一个分量外全部清零）。怎么办？

**找一面镜子。** 镜像保长度，所以 $\boldsymbol{x}$ 只能映成同样长度的 $\pm\lVert\boldsymbol{x}\rVert\boldsymbol{e}_1$。镜面的法线应沿着「$\boldsymbol{x}$ 与它的像的中点方向」——因为**入射向量与出射向量关于镜面对称**。Householder 反射就是这面镜子：

$$H=I-2\frac{\boldsymbol{v}\boldsymbol{v}^{\mathrm T}}{\boldsymbol{v}^{\mathrm T}\boldsymbol{v}}.$$

$H$ 对称、正交（$H^{\mathrm T}H=I$）、且 $H^2=I$（照两次镜子回到原处），$\det H=-1$。**一次矩阵乘法，就能消掉一整列的对角线以下元素。**
:::

::: def 定义 2.3.1 · Householder 变换 {#def-2.3.1}
设 $\boldsymbol{v}\in\mathbb{R}^k$、$\boldsymbol{v}\neq\boldsymbol{0}$，称

$$H=I-\frac{2}{\boldsymbol{v}^{\mathrm T}\boldsymbol{v}}\boldsymbol{v}\boldsymbol{v}^{\mathrm T}\in\mathbb{R}^{k\times k} \tag{2.16}$$

为 **Householder 变换**（或初等反射矩阵），$\boldsymbol{v}$ 为**反射向量**。
:::

::: thm 定理 2.3.3（新增） · Householder 变换的性质 {#thm-2.3.3}
$H$ 由（2.16）定义，则

1. **对称：** $H^{\mathrm T}=H$；
2. **正交：** $H^{\mathrm T}H=I$，故 $H^{-1}=H$、$H^2=I$；
3. **反射几何：** 对任意 $\boldsymbol{x}$，$H\boldsymbol{x}$ 是 $\boldsymbol{x}$ 关于超平面 $\boldsymbol{v}^{\perp}=\{\boldsymbol{y}:\boldsymbol{v}^{\mathrm T}\boldsymbol{y}=0\}$ 的镜像；特别地 $H\boldsymbol{v}=-\boldsymbol{v}$，而 $\boldsymbol{v}^{\perp}$ 上的向量不动；
4. **行列式：** $\det H=-1$；
5. **特征值：** $-1$（一重，特征向量 $\boldsymbol{v}$）与 $1$（$k-1$ 重，特征空间 $\boldsymbol{v}^{\perp}$）。

::: proof 证明
记 $\beta=2/(\boldsymbol{v}^{\mathrm T}\boldsymbol{v})$，$H=I-\beta\boldsymbol{v}\boldsymbol{v}^{\mathrm T}$。

**1：** $(\boldsymbol{v}\boldsymbol{v}^{\mathrm T})^{\mathrm T}=\boldsymbol{v}\boldsymbol{v}^{\mathrm T}$，故 $H^{\mathrm T}=H$。

**2：** 用 $H^{\mathrm T}=H$，
$$H^{\mathrm T}H=H^2=I-2\beta\boldsymbol{v}\boldsymbol{v}^{\mathrm T}+\beta^2\boldsymbol{v}(\boldsymbol{v}^{\mathrm T}\boldsymbol{v})\boldsymbol{v}^{\mathrm T}
=I-2\beta\boldsymbol{v}\boldsymbol{v}^{\mathrm T}+\beta^2\cdot\frac{2}{\beta}\boldsymbol{v}\boldsymbol{v}^{\mathrm T}=I .$$

**3：** 对任意 $\boldsymbol{x}$，分解 $\boldsymbol{x}=\boldsymbol{x}_{\parallel}+\boldsymbol{x}_{\perp}$，其中 $\boldsymbol{x}_{\parallel}=\frac{\boldsymbol{v}^{\mathrm T}\boldsymbol{x}}{\boldsymbol{v}^{\mathrm T}\boldsymbol{v}}\boldsymbol{v}$、$\boldsymbol{x}_{\perp}\perp\boldsymbol{v}$。则
$$H\boldsymbol{x}=\boldsymbol{x}-\frac{2\boldsymbol{v}^{\mathrm T}\boldsymbol{x}}{\boldsymbol{v}^{\mathrm T}\boldsymbol{v}}\boldsymbol{v}=\boldsymbol{x}-2\boldsymbol{x}_{\parallel}=-\boldsymbol{x}_{\parallel}+\boldsymbol{x}_{\perp},$$
即 $\boldsymbol{v}$ 方向翻转、$\boldsymbol{v}^{\perp}$ 方向不动——正是镜像。

**4、5：** 由 3，$H\boldsymbol{v}=-\boldsymbol{v}$；$\boldsymbol{u}\perp\boldsymbol{v}\Rightarrow H\boldsymbol{u}=\boldsymbol{u}$，而 $\dim\boldsymbol{v}^{\perp}=k-1$。故特征值为 $-1$（一重）与 $1$（$k-1$ 重），$\det H=(-1)\cdot1^{k-1}=-1$。
:::

:::

::: method 算法 2.3.3 · 用一个 Householder 变换消去一列的对角线以下元素

给定 $\boldsymbol{x}\in\mathbb{R}^k$（$k\ge2$，$\boldsymbol{x}\neq\boldsymbol{0}$），构造 $H$ 使 $H\boldsymbol{x}=\alpha\boldsymbol{e}_1$。

**目标只能取** $\alpha=\pm\lVert\boldsymbol{x}\rVert_2$（保长度）。取

$$\alpha=-\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2\qquad(\text{规定}\ x_1=0\ \text{时}\ \operatorname{sgn}(x_1)=1),$$

$$\boldsymbol{v}=\boldsymbol{x}-\alpha\boldsymbol{e}_1=\boldsymbol{x}+\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2\boldsymbol{e}_1 ,$$

则 $H=I-2\boldsymbol{v}\boldsymbol{v}^{\mathrm T}/(\boldsymbol{v}^{\mathrm T}\boldsymbol{v})$ 满足 $H\boldsymbol{x}=\alpha\boldsymbol{e}_1$。

**为什么这样取符号？** 若取 $\alpha=+\lVert\boldsymbol{x}\rVert$，当 $x_1\gt0$ 时 $\boldsymbol{v}$ 的首分量就是 $x_1-\lVert\boldsymbol{x}\rVert$，这是**两个相近数相减**（[1.2.4](../ch01/sec12.md#sec-1.2.4) 原则 (3)）。反过来取符号后，首分量变成 $x_1+\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert$，是**相加**，永远不损失有效数字。**这是数值分析里反复出现的符号选择技巧：能用加就不用减。**
:::

::: ex 例 2.3.3（新增） · 手算一个 Householder 反射 {#ex-2.3.3}
对 $\boldsymbol{x}=(3,4)^{\mathrm T}$ 构造 Householder 矩阵使 $H\boldsymbol{x}=\alpha\boldsymbol{e}_1$。

::: proof 解
$\lVert\boldsymbol{x}\rVert_2=\sqrt{9+16}=5$，$x_1=3\gt0$，故 $\alpha=-5$。

$$\boldsymbol{v}=\boldsymbol{x}-\alpha\boldsymbol{e}_1=\begin{pmatrix}3\\4\end{pmatrix}-\begin{pmatrix}-5\\0\end{pmatrix}=\begin{pmatrix}8\\4\end{pmatrix}.$$

$$\boldsymbol{v}^{\mathrm T}\boldsymbol{v}=64+16=80,\qquad
H=I-\frac{2}{80}\begin{pmatrix}64&32\\32&16\end{pmatrix}=\begin{pmatrix}1&0\\0&1\end{pmatrix}-\begin{pmatrix}1.6&0.8\\0.8&0.4\end{pmatrix}=\begin{pmatrix}-0.6&-0.8\\-0.8&0.6\end{pmatrix}.$$

**验证：** $H\boldsymbol{x}=\begin{pmatrix}-1.8-3.2\\-2.4+2.4\end{pmatrix}=\begin{pmatrix}-5\\0\end{pmatrix}=-5\boldsymbol{e}_1$ ✓。

**验证性质：** $H^{\mathrm T}=H$ ✓；$H^2=\begin{pmatrix}0.36+0.64&0.48-0.48\\0.48-0.48&0.64+0.36\end{pmatrix}=I$ ✓；$\det H=(-0.6)(0.6)-(-0.8)(-0.8)=-0.36-0.64=-1$ ✓。

**几何：** $H$ 是以 $\boldsymbol{v}=(8,4)^{\mathrm T}$（斜率 $1/2$）为法线的镜面反射，把 $(3,4)^{\mathrm T}$ 映成 $(-5,0)^{\mathrm T}$——长度不变，方向关于镜面对称。

**规范化形式：** 令 $\boldsymbol{u}=\boldsymbol{v}/\lVert\boldsymbol{v}\rVert=(2/\sqrt5,\ 1/\sqrt5)^{\mathrm T}$，则 $H=I-2\boldsymbol{u}\boldsymbol{u}^{\mathrm T}=\begin{pmatrix}1-8/5&-4/5\\-4/5&1-2/5\end{pmatrix}$，与上面的结果相同 ✓。**代码里用规范化形式更稳**（避免 $\boldsymbol{v}^{\mathrm T}\boldsymbol{v}$ 上溢 / 下溢）。
:::

:::

::: method 算法 2.3.4 · 用 Householder 做 QR 分解

对 $A\in\mathbb{R}^{m\times n}$（$m\ge n$），逐列消元：

```
R = copy(A);  Q = I_m
for k = 1, ..., n:
    x = R[k:m, k]                       # 当前列从对角线开始的片段
    if ||x|| == 0: continue
    alpha = -sign(x_1) * ||x||_2
    v = x - alpha * e_1
    v = v / ||v||_2                     # 规范化，避免溢出
    R[k:m, k:n] = R[k:m, k:n] - 2*v*(v' * R[k:m, k:n])   # 左乘 H_k
    Q[:, k:m]   = Q[:, k:m]   - 2*(Q[:, k:m]*v)*v'       # 累积 Q = H_1 H_2 ... H_n
```

第 $k$ 步把第 $k$ 列中第 $k+1,\dots,m$ 个元素全部化为零，同时不破坏已经产生的零。最终 $R$ 上三角，$Q$ 是 $m$ 阶正交阵（只保留前 $n$ 列，就得到「瘦」QR）。

**复杂度：** 约 $2mn^2-\frac23n^3$ flops，与 Gram–Schmidt 同量级，**但正交性总是 $\sim u$**，与 $\mathrm{cond}(A)$ 无关。
:::

::: ex 例 2.3.4（新增） · 用 Householder 做一次 QR {#ex-2.3.4}
对 $A=\begin{pmatrix}3&1\\4&2\end{pmatrix}$ 做 Householder QR。

::: proof 解
**第 1 步。** $\boldsymbol{x}=(3,4)^{\mathrm T}$，由例 2.3.3 已得

$$H_1=\begin{pmatrix}-0.6&-0.8\\-0.8&0.6\end{pmatrix},\qquad
H_1A=\begin{pmatrix}-1.8-3.2&-0.6-1.6\\-2.4+2.4&-0.8+1.2\end{pmatrix}=\begin{pmatrix}-5&-2.2\\0&0.4\end{pmatrix}.$$

$2\times2$ 情形第 1 步即完成：$R=\begin{pmatrix}-5&-2.2\\0&0.4\end{pmatrix}$，$Q=H_1^{\mathrm T}=H_1$。

**验证 $A=QR$：** $H_1R=\begin{pmatrix}3&-0.6(-2.2)-0.8(0.4)\\4&-0.8(-2.2)+0.6(0.4)\end{pmatrix}=\begin{pmatrix}3&1.32-0.32\\4&1.76+0.24\end{pmatrix}=\begin{pmatrix}3&1\\4&2\end{pmatrix}$ ✓。

**注意 $R$ 的对角元是负的**（$r_{11}=-5$）。要化成「对角元为正」的规范形式，把 $Q$ 的第 1 列与 $R$ 的第 1 行同时变号（$R\to\operatorname{diag}(-1,1)R$、$Q\to Q\operatorname{diag}(-1,1)$，$QR$ 不变）。**工程上常直接允许负对角元**（LAPACK 不保证正号），因为唯一性只在规范形式下成立。
:::

:::

<a id="sec-2.3.5"></a>

## 2.3.5 Givens 旋转

Householder 一次消掉一整列，效率高，但**不局部**：它要改动整个子块 $R_{k:m,k:n}$。矩阵**稀疏**，或者只需消掉**少数几个**元素时，Householder 会把零结构破坏掉——这时该改用 Givens 旋转。

::: intuition 直觉 · 用一次平面旋转「点掉」一个元素
想把 $(x_1,x_2)^{\mathrm T}$ 变成 $(r,0)^{\mathrm T}$？这正是 2.1 的平面旋转矩阵 $R_\theta$：取合适的 $\theta$ 就能把它「转」到 $x_1$ 轴上：

$$\begin{pmatrix}c&s\\-s&c\end{pmatrix}\begin{pmatrix}x_1\\x_2\end{pmatrix}=\begin{pmatrix}r\\0\end{pmatrix},\qquad c=\frac{x_1}{r},\ s=\frac{x_2}{r},\ r=\sqrt{x_1^2+x_2^2}\ (c^2+s^2=1).$$

**一次只消一个元素**，而且**想消哪个就消哪个**——这正是稀疏矩阵需要的。Givens 是「外科手术」，Householder 是「大扫除」。
:::

::: def 定义 2.3.2 · Givens 旋转 {#def-2.3.2}
设 $c^2+s^2=1$。在 $\mathbb{R}^k$ 中只作用在第 $i,j$ 两个坐标上的矩阵 $G(i,j,c,s)$（单位阵基础上把 $(i,i),(i,j),(j,i),(j,j)$ 位置改为 $c,s,-s,c$）称为 **Givens 旋转**（或 Givens 变换）。它是正交矩阵，且 $\det G=1$（保定向，与 Householder 相反）。
:::

::: thm 定理 2.3.4（新增） · Givens 旋转消元 {#thm-2.3.4}
给定 $\boldsymbol{x}=(x_1,x_2)^{\mathrm T}\neq\boldsymbol{0}$，取

$$r=\sqrt{x_1^2+x_2^2}\ (\text{实际用}\ \texttt{hypot}),\qquad c=\frac{x_1}{r},\qquad s=\frac{x_2}{r},$$

则 $\begin{pmatrix}c&s\\-s&c\end{pmatrix}\begin{pmatrix}x_1\\x_2\end{pmatrix}=\begin{pmatrix}r\\0\end{pmatrix}$。若 $x_2=0$，取 $c=1,\ s=0$。

::: proof 证明
直接代入：$cx_1+sx_2=\dfrac{x_1^2+x_2^2}{r}=r$，$-sx_1+cx_2=\dfrac{-x_2x_1+x_1x_2}{r}=0$。正交性：$c^2+s^2=(x_1^2+x_2^2)/r^2=1$。
:::

:::

::: note 算 $r$ 时不要写成 $\sqrt{x_1^2+x_2^2}$
直接算 $x_1^2+x_2^2$，当 $\boldsymbol{x}$ 的分量接近 $10^{154}$ 时会**上溢**（超出 double 范围），接近 $10^{-160}$ 时会**下溢**成零。正确做法是用 `hypot`：

$$r=\sqrt{x_1^2+x_2^2}\ \longrightarrow\ r=\texttt{hypot}(x_1,x_2)\quad(\text{先按量级缩放再开方}) .$$

Python 用 `math.hypot` / `np.hypot`，C 用 `hypot`（C99 标准）。**同理：$\lVert\boldsymbol{x}\rVert_2$ 在代码里用 `np.linalg.norm`（内部做缩放），不要手写 `np.sqrt(x @ x)`。** 这是「浮点可表示范围有限」（[1.2.5](../ch01/sec12.md#sec-1.2.5)）带来的工程细节。
:::

::: ex 例 2.3.5（新增） · 手算一个 Givens 旋转 {#ex-2.3.5}
用 Givens 旋转把 $A=\begin{pmatrix}3&4\\4&3\end{pmatrix}$ 化为上三角。

::: proof 解
对第 1 列 $(3,4)^{\mathrm T}$ 消元：$r=5$，$c=3/5=0.6$，$s=4/5=0.8$。

$$G=\begin{pmatrix}0.6&0.8\\-0.8&0.6\end{pmatrix},\qquad
GA=\begin{pmatrix}1.8+3.2&2.4+2.4\\-2.4+2.4&-3.2+1.8\end{pmatrix}=\begin{pmatrix}5&4.8\\0&-1.4\end{pmatrix}.$$

$2\times2$ 已上三角：$R=\begin{pmatrix}5&4.8\\0&-1.4\end{pmatrix}$，$Q=G^{\mathrm T}=\begin{pmatrix}0.6&-0.8\\0.8&0.6\end{pmatrix}$。

**验证 $A=QR$：** $QR=\begin{pmatrix}0.6&-0.8\\0.8&0.6\end{pmatrix}\begin{pmatrix}5&4.8\\0&-1.4\end{pmatrix}=\begin{pmatrix}3&2.88+1.12\\4&3.84-0.84\end{pmatrix}=\begin{pmatrix}3&4\\4&3\end{pmatrix}$ ✓。

**与 Householder 对比：** 同一个矩阵，Householder 给出的 $Q$ 满足 $\det Q=-1$（含反射），Givens 给出 $\det Q=+1$（纯旋转）。两者都能完成 QR，选哪个取决于**要消多少元素**：本例 $2\times2$ 只需一次旋转，成本相同；但若是 $1000\times1000$ 的三对角矩阵，**「只动两行」的局部性**才是 Givens 的杀手锏。
:::

:::

::: method 四种正交化方法的对比（本节结论）

| 方法 | 一次消多少 | flops（$m\times n$，$m\ge n$） | $\lVert Q^{\mathrm T}Q-I\rVert_2$ | 适用场合 |
|:--|:--|:--:|:--|:--|
| CGS | 一列（逐步投影） | $2mn^2$ | $\mathrm{cond}^2u$（**勿用于生产**） | 教学、理论推导 |
| **MGS** | 一列（逐步投影） | $2mn^2$ | $\mathrm{cond}\,u$ | 需要显式 $Q$、条件数温和 |
| **Householder** | **一整列**（$>1$ 个元素） | $2mn^2-\frac23n^3$ | $\boldsymbol{u}$（与 cond 无关） | **稠密矩阵的默认选择** |
| **Givens** | **一个元素** | 约 $6mn^2$（3 倍） | $u$（与 cond 无关） | **稀疏 / 带状 / 局部修改 / 并行** |

**口诀：稠密用 Householder，稀疏用 Givens；MGS 在条件数温和且需要 $Q$ 的显式列时可用；CGS 只用于教学。** LAPACK 的 `geqrf`（Householder）是 NumPy `np.linalg.qr`、MATLAB `qr`、SciPy 的共同默认路径。
:::

::: preview 课程预告 · QR 的另一个大用途
本节把 QR 当作「解最小二乘的稳定工具」。QR 还有一个更深刻的应用：**QR 迭代求全部特征值**（原书第 3 章 3.3 节）。核心思路正是（2.15）后面的观察——$A=QR\Rightarrow A'=RQ=Q^{\mathrm T}AQ$ 与 $A$ 相似（特征值不变），反复迭代后 $R$ 的对角元趋于特征值。**「QR 分解」与「QR 方法」是两件事，但后者完全建立在前者之上。**
:::

<a id="sec-2.3.6"></a>

## 2.3.6 用 QR 解最小二乘：为什么比正态方程好

::: intuition 直觉 · 把「平方」消掉
正态方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ 的毛病出在 $\mathrm{cond}(A^{\mathrm T}A)=\mathrm{cond}(A)^2$（$A^{\mathrm T}A$ 的奇异值是 $A$ 的奇异值的**平方**，见 [2.6.3](sec26.md#sec-2.6.3)）：条件数一平方，有效数字就掉一半。

QR 的做法是代入 $A=QR$，利用正交不变性（[@thm-2.1.6]）：

$$\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2^2=\lVert QR\boldsymbol{x}-\boldsymbol{b}\rVert_2^2=\lVert R\boldsymbol{x}-Q^{\mathrm T}\boldsymbol{b}\rVert_2^2,$$

于是问题变成解一个**上三角方程组**，**从头到尾都不形成 $A^{\mathrm T}A$**：条件数保持 $\mathrm{cond}(A)$，没有被平方。
:::

::: thm 定理 2.3.5（新增） · QR 解最小二乘与误差量级 {#thm-2.3.5}
设 $A\in\mathbb{R}^{m\times n}$（$m\ge n$）列满秩，取其**全 QR** 分解 $A=\bar Q\begin{pmatrix}R\\O\end{pmatrix}$（$\bar Q$ 为 $m$ 阶正交，$R$ 为 $n$ 阶非奇异上三角）。把 $\bar Q^{\mathrm T}\boldsymbol{b}$ 分块为 $\begin{pmatrix}\boldsymbol{c}\\ \boldsymbol{d}\end{pmatrix}$（$\boldsymbol{c}\in\mathbb{R}^n$、$\boldsymbol{d}\in\mathbb{R}^{m-n}$），则

$$\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2^2=\lVert R\boldsymbol{x}-\boldsymbol{c}\rVert_2^2+\lVert\boldsymbol{d}\rVert_2^2 .$$

因此最小二乘解由**上三角方程组** $R\hat{\boldsymbol{x}}=\boldsymbol{c}$ 给出（回代，$O(n^2)$），最小残差范数为 $\lVert\boldsymbol{d}\rVert_2$。**误差量级：**

$$\text{正态方程：}\quad\frac{\lVert\hat{\boldsymbol{x}}-\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\sim\mathrm{cond}(A)^2\,u;\qquad
\text{QR：}\quad\frac{\lVert\hat{\boldsymbol{x}}-\boldsymbol{x}\rVert}{\lVert\boldsymbol{x}\rVert}\sim\mathrm{cond}(A)\,u .$$

::: proof 证明
**分解最小化问题：** 由 [@thm-2.1.6]（正交矩阵保 2-范数），

$$\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2=\lVert\bar Q^{\mathrm T}(A\boldsymbol{x}-\boldsymbol{b})\rVert_2=\left\lVert\begin{pmatrix}R\\O\end{pmatrix}\boldsymbol{x}-\begin{pmatrix}\boldsymbol{c}\\\boldsymbol{d}\end{pmatrix}\right\rVert_2=\left\lVert\begin{pmatrix}R\boldsymbol{x}-\boldsymbol{c}\\-\boldsymbol{d}\end{pmatrix}\right\rVert_2 .$$

取平方即得。第二项与 $\boldsymbol{x}$ 无关，故只能令第一项为零；$R$ 非奇异（$A$ 列满秩）故解唯一，最小值 $\lVert\boldsymbol{d}\rVert_2^2$。

**误差量级（要点）：** 正态方程显式形成并求解一个条件数为 $\mathrm{cond}(A)^2$ 的问题，任何后向稳定的解法（如 Cholesky）只能保证相对误差 $\sim\mathrm{cond}(A)^2u$；QR 路径中所有变换都是正交的（[@thm-2.1.6]：不放大误差），误差只经过 $\mathrm{cond}(R)=\mathrm{cond}(A)$ 一次。严格的后向误差分析见 Higham《Accuracy and Stability of Numerical Algorithms》§20.3–20.5。
:::

:::

::: method 实测对照 · QR vs 正态方程（本章运行数据）

取 Vandermonde 设计矩阵与真解 $\boldsymbol{c}=\boldsymbol{1}$，构造相容右端 $\boldsymbol{b}=A\boldsymbol{c}$（残差理论上为零），比较两种方法恢复 $\boldsymbol{c}$ 的最大分量误差：

| $m$ | $n$ | $\mathrm{cond}(A)$ | 正态方程误差 | **QR 误差** |
|:--:|:--:|:--:|:--:|:--:|
| 12 | 10 | $6.84\times10^{6}$ | $1.3\times10^{-4}$ | $\mathbf{5.4\times10^{-11}}$ |
| 20 | 15 | $6.03\times10^{10}$ | $\mathbf{2.8\times10^{1}}$（完全失效） | $\mathbf{2.2\times10^{-6}}$ |

**第二行是最重要的一格：** 条件数 $6\times10^{10}$ 时，正态方程解出的系数误差达到 $28$——相比真值 $1$ 毫无意义；QR 仍给出 $10^{-6}$ 量级。**理论预测：** 正态方程 $\mathrm{cond}^2u\approx(6.03\times10^{10})^2\times1.1\times10^{-16}\approx4\times10^{5}$（实测 $28$，误差被部分抵消但仍不可用）；QR 为 $\mathrm{cond}\cdot u\approx6\times10^{-6}$，实测 $2.2\times10^{-6}$ ✓。

**结论：条件数超过约 $10^{8}\approx u^{-1/2}$ 时，必须放弃正态方程，改用 QR 或 SVD。** 这是「公式最简的写法未必是最稳定的算法」（[1.1.3](../ch01/sec11.md#sec-1.1.3)）在矩阵层面的重演。
:::

::: ex 例 2.3.6（新增） · 用 QR 解一个最小二乘问题 {#ex-2.3.6}
用 QR 分解求下面方程组的最小二乘解：

$$\begin{pmatrix}1&1\\1&0\\0&1\end{pmatrix}\begin{pmatrix}x_1\\x_2\end{pmatrix}=\begin{pmatrix}2\\1\\1\end{pmatrix}.$$

::: proof 解
记 $A=\begin{pmatrix}1&1\\1&0\\0&1\end{pmatrix}$、$\boldsymbol{b}=(2,1,1)^{\mathrm T}$。用 Householder 化 $A$（数值结果，符号可能因实现而异）：

$$Q=\begin{pmatrix}-0.7071&0.4082\\-0.7071&-0.4082\\0&0.8165\end{pmatrix},\qquad
R=\begin{pmatrix}-1.4142&-0.7071\\0&1.2247\end{pmatrix},\qquad
Q^{\mathrm T}\boldsymbol{b}=\begin{pmatrix}-2.1213\\1.2247\end{pmatrix}.$$

**回代解 $R\hat{\boldsymbol{x}}=Q^{\mathrm T}\boldsymbol{b}$：** 由第二行 $1.2247x_2=1.2247\Rightarrow x_2=1$；由第一行 $-1.4142x_1-0.7071x_2=-2.1213\Rightarrow x_1=\dfrac{-2.1213+0.7071}{-1.4142}=1$。

$$\hat{\boldsymbol{x}}=(1,1)^{\mathrm T}.$$

**核对：** $A\hat{\boldsymbol{x}}=(1,1,0)^{\mathrm T}+(1,0,1)^{\mathrm T}=(2,1,1)^{\mathrm T}=\boldsymbol{b}$——**残差为零**，这说明 $\boldsymbol{b}\in C(A)$，最小二乘解恰好就是精确解。

**换一个右端：** 取 $\boldsymbol{b}=(1,1,1)^{\mathrm T}$，此时 $\boldsymbol{b}\notin C(A)$。$Q^{\mathrm T}\boldsymbol{b}=(-1.4142,\ 0.8165)^{\mathrm T}$，解得 $x_2=0.6667$、$x_1=0.6667$，即 $\hat{\boldsymbol{x}}=(0.6667,0.6667)^{\mathrm T}=\bigl(\tfrac23,\tfrac23\bigr)^{\mathrm T}$（正态方程 $\begin{pmatrix}2&1\\1&2\end{pmatrix}\boldsymbol{x}=(2,2)^{\mathrm T}$ 的解），残差 $\lVert A\hat{\boldsymbol{x}}-\boldsymbol{b}\rVert_2=0.5774=1/\sqrt3$ ✓，且 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$ 成立。
:::

:::

<a id="sec-2.3.7"></a>

## 2.3.7 小结与常见错误

::: method[core] 本节公式速查

| 概念 | 公式 / 结论 |
|:--|:--|
| CGS 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{a}_j$（原始列） |
| MGS 系数 | $r_{ij}=\boldsymbol{q}_i^{\mathrm T}\boldsymbol{v}$（当前列）← **数值上必须用它** |
| QR 分解 | $A=QR$，$Q^{\mathrm T}Q=I$，$R$ 上三角；对角元为正时唯一 |
| 分层张成 | $\operatorname{span}\{\boldsymbol{q}_1..\boldsymbol{q}_k\}=\operatorname{span}\{\boldsymbol{a}_1..\boldsymbol{a}_k\}$ |
| Householder | $H=I-2\boldsymbol{v}\boldsymbol{v}^{\mathrm T}/\boldsymbol{v}^{\mathrm T}\boldsymbol{v}$；$H^{\mathrm T}=H$，$H^2=I$，$\det H=-1$ |
| 消元向量 | $\boldsymbol{v}=\boldsymbol{x}+\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2\boldsymbol{e}_1$，$\alpha=-\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert_2$ |
| Givens | $c=x_1/r$，$s=x_2/r$，$r=\texttt{hypot}(x_1,x_2)$；$\det G=+1$ |
| 正交性损失 | CGS：$\mathrm{cond}^2u$；MGS：$\mathrm{cond}\,u$；Householder / Givens：$u$ |
| 复杂度 | GS：$2mn^2$；Householder：$2mn^2-\frac23n^3$；Givens：约 $6mn^2$ |
| QR 最小二乘 | $R\hat{\boldsymbol{x}}=(Q^{\mathrm T}\boldsymbol{b})_{1:n}$；$\lVert\boldsymbol{r}\rVert_2=\lVert\boldsymbol{d}\rVert_2$ |

:::

::: think[core] 常见错误清单 · 自查七条
1. **把经典 Gram–Schmidt 当生产代码。** 条件数超过 $10^{8}$ 时，CGS 给出的 $Q$ **完全不正交**（见 2.3.3 的表格），后续所有基于 $Q$ 的结论同时失效。代码里请用 Householder（`np.linalg.qr`），至少也要用 MGS。
2. **MGS 写成 CGS。** 两者只差「内积用原始列还是当前列」，数学上等价，数值上差别巨大。写代码时必须**逐列就地更新**，不能先留一份原始备份再用备份算系数。
3. **Householder 消元向量取错符号。** 若取 $\alpha=+\lVert\boldsymbol{x}\rVert$ 且 $x_1\gt0$，$\boldsymbol{v}$ 的首分量 $x_1-\lVert\boldsymbol{x}\rVert$ 是相近数相减，损失有效数字（[1.2.4](../ch01/sec12.md#sec-1.2.4)）。正确取 $\alpha=-\operatorname{sgn}(x_1)\lVert\boldsymbol{x}\rVert$，让首分量变成**相加**。
4. **手写 $\sqrt{x_1^2+x_2^2}$ 算 Givens 的 $r$。** 会溢出 / 下溢；用 `hypot`。同理 $\lVert\boldsymbol{x}\rVert_2$ 用 `np.linalg.norm`，别手写 `sqrt(x@x)`。
5. **以为 QR 分解唯一。** 只有「$R$ 对角元为正」的规范形式才唯一；LAPACK 与 NumPy 允许负对角元，所以不同库给出的 $Q,R$ 可以差若干列的符号。**比较 $Q,R$ 前先统一符号**，或改为比较 $QR$ 与 $A$、$Q^{\mathrm T}Q$ 与 $I$。
6. **用 QR 解最小二乘时把整个 $\bar Q$ 都算出来。** 如果只要解，可以只存 Householder 向量（$O(mn)$ 内存）并直接作用在 $\boldsymbol{b}$ 上，不必形成 $m\times m$ 的 $\bar Q$（$O(m^2)$ 内存）——这是大规模最小二乘的标准优化。
7. **秩亏时仍用普通 QR 判断秩。** $A$ 秩亏或接近秩亏时，$R$ 的对角元只会出现「很小但不为零」的值，靠它判断秩并不可靠——请用**列主元 QR**（[@thm-2.3.2] 后的注）或 SVD（[2.6.5](sec26.md#sec-2.6.5)）。
:::

::: preview 课程预告 · 本节之后
- 「$\mathrm{cond}$ 平方」这个坑有多深？下节 [2.4](sec24.md) 把条件数讲成「能保住几位有效数字」的定量工具；
- $R$ 的对角元为什么能判秩？[2.6](sec26.md) 用 SVD 给出更可靠、更几何的判据；
- **QR 迭代求特征值**：原书第 3 章 3.3 节；**列主元 QR**：原书第 2 章 2.2.2 与 [2.6.5](sec26.md#sec-2.6.5)。
:::
