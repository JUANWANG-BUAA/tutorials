# 3.3 QR 方法

> 对应教材 3.3.1–3.3.3、引理 3.1、定理 3.2、习题 9–12。**老师课堂未讲**，本节按教材补齐，标「教材有、课堂未讲」。
> 主线：Householder 正交变换 → QR 分解 → 拟上三角化（降复杂度）→ 基本 QR 迭代 → 双步位移 QR（加速 + 实运算）。

::: intuition 直觉 · 为什么 QR 迭代能求特征值
QR 迭代的核心恒等式是

$$
A_k=Q_kR_k,\qquad A_{k+1}=R_kQ_k=Q_k^{\mathrm T}A_kQ_k .
$$

右端说明 $A_{k+1}$ 与 $A_k$ **正交相似**，特征值一步不变；左端说明每次都在做 QR 分解。反复迭代，$A_k$ 的次对角元趋于零，对角元（或 $2\times2$ 块）就把特征值交出来。

这和幂法是一枚硬币的两面：幂法只追**一个**主特征值；QR 迭代同时处理**全部**特征值。代价是每步 $O(n^3)$（先化成拟上三角后 $O(n^2)$），所以要先做拟上三角化，再用双步位移加速。
:::

<a id="sec-3.3.1"></a>
## 3.3.1 矩阵的 QR 分解

::: def 定义 3.3.1（教材式 3.18） · Householder 矩阵 {#def-3.3.1}
设 $\boldsymbol v\in\mathbb R^n$ 是单位向量，$\lVert\boldsymbol v\rVert_2=1$。称

$$
H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}
$$

为 **Householder 矩阵**（镜面映射矩阵）。它满足

$$
H^{\mathrm T}=H,\qquad H^{\mathrm T}H=I,
$$

即 $H$ 对称且正交；几何上它把向量关于以 $\boldsymbol v$ 为法向的超平面作镜面反射。
:::

::: lem 引理 3.1（教材引理 3.1） · Householder 映射把向量打到指定方向 {#lem-3.3.1}
设 $\boldsymbol s\in\mathbb R^n$ 非零，$\boldsymbol e\in\mathbb R^n$ 是单位向量。则存在 Householder 矩阵 $H$，使

$$
H\boldsymbol s=\alpha\boldsymbol e,
$$

其中 $\alpha$ 是实数，且 $|\alpha|=\lVert\boldsymbol s\rVert_2$。
:::

::: proof 证明
取

$$
\boldsymbol v=\frac{\boldsymbol s-\alpha\boldsymbol e}{\lVert\boldsymbol s-\alpha\boldsymbol e\rVert_2},
\qquad \alpha=\pm\lVert\boldsymbol s\rVert_2,
$$

构成 $H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}$。直接计算：

$$
H\boldsymbol s=\boldsymbol s-2\boldsymbol v\left(\boldsymbol v^{\mathrm T}\boldsymbol s\right)
=\boldsymbol s-2\frac{(\boldsymbol s-\alpha\boldsymbol e)\left((\boldsymbol s-\alpha\boldsymbol e)^{\mathrm T}\boldsymbol s\right)}{p^2}.
$$

由 $p^2=\lVert\boldsymbol s-\alpha\boldsymbol e\rVert_2^2=2\left(\lVert\boldsymbol s\rVert_2^2-\alpha\boldsymbol e^{\mathrm T}\boldsymbol s\right)$ 得

$$
(\boldsymbol s-\alpha\boldsymbol e)^{\mathrm T}\boldsymbol s=\frac{p^2}{2},
$$

故第二项等于 $\boldsymbol s-\alpha\boldsymbol e$，从而 $H\boldsymbol s=\alpha\boldsymbol e$。$\blacksquare$
:::

::: note 数值上怎么选 $\alpha$ 的符号
取 $\alpha=-\operatorname{sgn}(s_1)\lVert\boldsymbol s\rVert_2$（$s_1$ 是 $\boldsymbol s$ 的第一个分量；若 $s_1=0$ 取正号）。这样 $\boldsymbol s-\alpha\boldsymbol e$ 的两个主分量同号，避免相近数相减；否则 $\lVert\boldsymbol s-\alpha\boldsymbol e\rVert$ 可能因抵消而损失精度。这是 Householder QR 数值稳定的关键细节。
:::

::: def 定义 3.3.2（教材 3.3.1） · QR 分解 {#def-3.3.2}
把实矩阵 $A$ 分解为

$$
A=QR,
$$

其中 $Q$ 是正交矩阵、$R$ 是上三角矩阵，称为 $A$ 的 **QR 分解**（正交三角分解）。
:::

::: thm 定理 3.2（教材定理 3.2） · QR 分解的存在性 {#thm-3.3.1}
任何 $n\times n$ 实矩阵 $A$ 总可以分解为一个正交矩阵 $Q$ 与一个上三角矩阵 $R$ 的乘积。
:::

::: proof 证明（构造法）
记 $A_1=A$。对 $r=1,2,\dots,n-1$：

1. 取 $A_r$ 的第 $r$ 列从第 $r$ 行到第 $n$ 行的片段 $\boldsymbol s_r$；
2. 由引理 3.3.1，构造 Householder 矩阵 $H_r$，使 $H_r\boldsymbol s_r=\alpha_r\boldsymbol e_r$，即把第 $r$ 列第 $r+1$ 行以下全部消为零；
3. 令 $A_{r+1}=H_rA_r$。

$n-1$ 步后

$$
A_n=H_{n-1}\cdots H_2H_1A
$$

是上三角矩阵。令

$$
R=A_n,\qquad Q=H_1H_2\cdots H_{n-1},
$$

则 $Q$ 是正交矩阵（正交矩阵乘积），且

$$
A=H_1\cdots H_{n-1}A_n=QR.
$$

$\blacksquare$
:::

::: method[core] Householder QR 的实用算法（不显式形成 $H_r$） {#method-3.3-qr}
记 $A_1=A$，$Q_1=I$。对 $r=1,\dots,n-1$：

1. 若第 $r$ 列第 $r+1$ 行以下全为零，令 $A_{r+1}=A_r,\ Q_{r+1}=Q_r$，转下一步；否则：
2. 计算 $d_r=\lVert\boldsymbol s_r\rVert_2$，$c_r=-\operatorname{sgn}(a_{rr}^{(r)})d_r$（$a_{rr}^{(r)}=0$ 时取 $c_r=d_r$），$h_r=c_r^2-c_ra_{rr}^{(r)}$；
3. 令 $\boldsymbol u_r=(0,\dots,0,a_{rr}^{(r)}-c_r,a_{r+1,r}^{(r)},\dots,a_{nr}^{(r)})^{\mathrm T}$；
4. 更新

$$
Q_{r+1}=Q_r-\frac{2}{h_r}Q_r\boldsymbol u_r\boldsymbol u_r^{\mathrm T},\qquad
A_{r+1}=A_r-\frac{2}{h_r}\boldsymbol u_r\boldsymbol u_r^{\mathrm T}A_r .
$$

算完后 $Q=Q_n$，$R=A_n$。**只做向量-矩阵乘法，不形成 $n\times n$ 的 $H_r$**，计算量约 $2n^3/3$ 次乘法。
:::

::: ex 例 3.3.1（新增演算） · 三阶矩阵的 Householder QR {#ex-3.3.1}
求

$$
A=\begin{pmatrix}1&2&1\\2&1&2\\1&2&0\end{pmatrix}
$$

的 QR 分解。

**解** 按上述算法（保留六位小数）：

$$
Q\approx\begin{pmatrix}
-0.408248&0.577350&0.707107\\
-0.816497&-0.577350&0\\
-0.408248&0.577350&-0.707107
\end{pmatrix},
\qquad
R\approx\begin{pmatrix}
-2.449490&-2.449490&-2.041241\\
0&1.732051&-0.577350\\
0&0&0.707107
\end{pmatrix}.
$$

**核对**：$QR$ 乘回去应得 $A$；$Q^{\mathrm T}Q=I$；$R$ 的对角元一正一负一正——QR 分解不要求 $R$ 对角为正，若要求唯一则约定 $R$ 对角为正（必要时把相应行乘 $-1$，同时把 $Q$ 的列乘 $-1$）。

**读法**：第一步把第一列 $(1,2,1)^{\mathrm T}$ 打到 $(-2.44949,0,0)^{\mathrm T}$；第二步把第二列剩余部分 $(1.73205,0)^{\mathrm T}$ 处理掉。**每步只动一列的对角线以下部分**，这就是 Householder QR 的全部结构。
:::

<a id="sec-3.3.2"></a>
## 3.3.2 矩阵的拟上三角化

::: def 定义 3.3.3（教材 3.3.2） · 拟上三角矩阵 {#def-3.3.3}
若矩阵 $A=(a_{ij})$ 满足

$$
a_{ij}=0\qquad(i>j+1),
$$

即次对角线以下全为零，则称 $A$ 为**拟上三角矩阵**（上 Hessenberg 矩阵）。
:::

::: method[core] 用 Householder 相似变换化拟上三角 {#method-3.3-hessenberg}
对 $r=1,2,\dots,n-2$：

1. 取第 $r$ 列从第 $r+2$ 行到第 $n$ 行的片段 $\boldsymbol s_r=(0,\dots,0,a_{r+2,r},\dots,a_{nr})^{\mathrm T}$；
2. 构造 Householder 矩阵 $H_r$，使 $H_r\boldsymbol s_r=c_r\boldsymbol e_{r+1}$，即消去第 $r$ 列第 $r+2$ 行以下的元素；
3. 作**相似变换**

$$
A^{(r+1)}=H_rA^{(r)}H_r
$$

（左右各乘一次；只动第 $r+1,\dots,n$ 行/列）。

$n-2$ 步后得

$$
A^{(n-1)}=P^{\mathrm T}AP,\qquad P=H_1H_2\cdots H_{n-2},
$$

$P$ 正交，$A^{(n-1)}$ 与 $A$ 相似且为拟上三角。**若 $A$ 实对称，则 $A^{(n-1)}$ 是三对角矩阵**。
:::

::: note 为什么要先化拟上三角
基本 QR 迭代每步要对 $n\times n$ 矩阵做 QR 分解，约 $O(n^3)$。化成拟上三角后，每步 QR 只需处理带宽为 1 的结构，计算量降到 $O(n^2)$；而且拟上三角在 QR 迭代下保持。**一次 $O(n^3)$ 的预处理，换后面每步 $O(n^2)$**，这是 QR 方法能实用的关键。
:::

::: ex 例 3.3.2（教材习题 10） · 对称矩阵三对角化 {#ex-3.3.2}
用 Householder 相似变换把

$$
A=\begin{pmatrix}
1&2&1&2\\
2&1&2&-1\\
1&2&0&3\\
2&-1&3&1
\end{pmatrix}
$$

化为三对角矩阵。

**解** 这是实对称矩阵，按上述算法两次 Householder 相似变换，得（保留六位小数）

$$
A^{(3)}\approx\begin{pmatrix}
1&-3&0&0\\
-3&2.222222&2.759943&0\\
0&2.759943&-2.077976&-1.016207\\
0&0&-1.016207&1.855754
\end{pmatrix}.
$$

**核对**：矩阵仍对称；次对角线以外（$|i-j|>1$）全为零；迹 $1+1+0+1=3$ 与变换后迹 $1+2.222222-2.077976+1.855754\approx3$ 一致；特征值不变（相似变换）。
:::

<a id="sec-3.3.3"></a>
## 3.3.3 带双步位移的 QR 方法

::: method[core] 基本 QR 迭代 {#method-3.3-basic-qr}
从 $A_1=A^{(n-1)}$ 出发：

$$
A_k=Q_kR_k,\qquad A_{k+1}=R_kQ_k=Q_k^{\mathrm T}A_kQ_k\qquad(k=1,2,\dots).
$$

每个 $A_k$ 都与 $A$ 正交相似，特征值不变。收敛结论：

- $A$ 实对称：$A_k\to$ 对角矩阵，对角元即全部特征值；
- $A$ 一般实矩阵：$A_k$ **本质收敛**于分块上三角矩阵；一阶块给实特征值，二阶块给一对复共轭特征值。
:::

::: note 基本 QR 的两个问题
1. **收敛慢**：收敛速度取决于特征值模的比值；相邻特征值模接近时很慢。
2. **复数特征值**：实矩阵的复共轭特征值会以 $2\times2$ 块出现，基本 QR 用实运算可以处理块，但收敛判据和位移要专门设计。

双步位移同时解决这两个问题：用右下 $2\times2$ 块的特征值作位移加速；把两个位移合成一个实矩阵 $M_k$，避免复数运算。
:::

::: method[core] 双步位移 QR（教材式 3.30） {#method-3.3-double-shift}
设当前矩阵 $A_k$ 的右下 $2\times2$ 块为

$$
D_k=\begin{pmatrix}a_{m-1,m-1}^{(k)}&a_{m-1,m}^{(k)}\\a_{m,m-1}^{(k)}&a_{mm}^{(k)}\end{pmatrix}.
$$

取 $D_k$ 的两个特征值 $s_1^{(k)},s_2^{(k)}$ 作位移，令

$$
s=s_1^{(k)}+s_2^{(k)}=a_{m-1,m-1}^{(k)}+a_{mm}^{(k)},\qquad
t=s_1^{(k)}s_2^{(k)}=\det D_k .
$$

构造实矩阵

$$
M_k=A_k^2-sA_k+tI,
$$

作 QR 分解 $M_k=Q_kR_k$，再令

$$
A_{k+2}=Q_k^{\mathrm T}A_kQ_k .
$$

这样一次推进两步，且 $s,t$ 都是实数，**即使位移是复共轭也不出现复数运算**。
:::

::: method[core] 降阶（deflation）与停止准则 {#method-3.3-deflation}
从 $m=n$ 开始：

1. 若 $|a_{m,m-1}|\le\varepsilon$，则 $a_{mm}$ 是一个特征值，置 $m\leftarrow m-1$，继续；
2. 若 $|a_{m-1,m-2}|\le\varepsilon$，则右下 $2\times2$ 块的两个特征值已分离，解二次方程得一对特征值，置 $m\leftarrow m-2$，继续；
3. 若 $m=1$，剩下的 $a_{11}$ 就是最后一个特征值；若 $m=2$，解 $2\times2$ 块；
4. 若未降阶，做一次双步位移 QR，再回到 1。

**降阶是 QR 方法实用化的另一半**：已收敛的特征值被“切掉”，后续迭代只作用在更小的块上，总计算量从 $O(n^4)$ 降到 $O(n^3)$。
:::

::: ex 例 3.3.3（教材习题 11） · 一般矩阵拟上三角化 {#ex-3.3.3}
用 Householder 相似变换把

$$
A=\begin{pmatrix}
2&1&3&4\\
1&-1&2&1\\
-1&2&1&2\\
1&0&-1&3
\end{pmatrix}
$$

化为拟上三角矩阵。

**解** 按 3.3.2 的算法（两次相似变换），得（保留六位小数）

$$
A^{(3)}\approx\begin{pmatrix}
2&-1.154701&-4.420267&-2.264488\\
-1.732051&-0.333333&1.473715&-1.431917\\
0&3.091206&1.647287&0.046994\\
0&0&2.356395&1.686047
\end{pmatrix}.
$$

**核对**：第 1 列第 3、4 行与第 2 列第 4 行均为零（$i>j+1$ 处为零）；矩阵一般不再对称——这是与例 3.3.2 的实对称情形最大的区别。
:::

::: ex 例 3.3.4（教材习题 12） · 基本 QR 迭代求特征值 {#ex-3.3.4}
用基本 QR 方法计算

$$
A=\begin{pmatrix}3&1&0\\1&2&1\\0&1&1\end{pmatrix}
$$

的特征值。

**解** 从 $A_1=A$ 出发，反复做 $A_k=Q_kR_k,\ A_{k+1}=R_kQ_k$。对角元与最大非对角元的变化：

| $k$ | $a_{11}^{(k)}$ | $a_{22}^{(k)}$ | $a_{33}^{(k)}$ | $\max_{i\ne j}\lvert a_{ij}^{(k)}\rvert$ |
|:--:|:--:|:--:|:--:|:--:|
| 1 | 3.500000 | 2.214286 | 0.285714 | $5.92\times10^{-1}$ |
| 4 | 3.725760 | 2.006291 | 0.267949 | $1.04\times10^{-1}$ |
| 8 | 3.732008 | 2.000043 | 0.267949 | $8.63\times10^{-3}$ |

极限为

$$
\lambda_1=2+\sqrt3\approx3.732051,\qquad
\lambda_2=2,\qquad
\lambda_3=2-\sqrt3\approx0.267949.
$$

**核对**：特征多项式

$$
\det(\lambda I-A)=\lambda^3-6\lambda^2+10\lambda-4=(\lambda-2)(\lambda^2-4\lambda+1),
$$

根正是 $2$ 与 $2\pm\sqrt3$。**注意收敛速度**：$k=1$ 到 $k=8$ 非对角元只降了两个数量级——基本 QR 收敛较慢，这正是要用双步位移加速的原因。
:::

<a id="sec-3.3-exercises"></a>
## 习题（教材习题 9–12）

::: ex 3.9 · Householder 映射（教材习题 9） {#ex-3.3.9}
设 $\boldsymbol s=(-2,1,2)^{\mathrm T}$，$\boldsymbol r=(4,3,0)^{\mathrm T}$，求 Householder 矩阵 $H$，使 $H\boldsymbol s$ 与 $\boldsymbol r$ 同向、长度等于 $\lVert\boldsymbol s\rVert_2$。
:::

::: sol 参考答案
目标 $\boldsymbol v=\lVert\boldsymbol s\rVert_2\,\boldsymbol r/\lVert\boldsymbol r\rVert_2=(2.4,1.8,0)^{\mathrm T}$。取 $\boldsymbol u=\boldsymbol s-\boldsymbol v=(-4.4,-0.8,2)^{\mathrm T}$，$H=I-2\boldsymbol u\boldsymbol u^{\mathrm T}/(\boldsymbol u^{\mathrm T}\boldsymbol u)$：

$$
H\approx\begin{pmatrix}
-0.613333&-0.293333&0.733333\\
-0.293333&0.946667&0.133333\\
0.733333&0.133333&0.666667
\end{pmatrix},
\qquad H\boldsymbol s=(2.4,1.8,0)^{\mathrm T}.
$$

核对：$H^{\mathrm T}H=I$、$\det H=-1$（镜面反射）、$\lVert H\boldsymbol s\rVert_2=3=\lVert\boldsymbol s\rVert_2$。
:::

::: ex 3.10 · 对称矩阵三对角化（教材习题 10） {#ex-3.3.10}
用 Householder 相似变换把教材习题 10 的实对称矩阵化为三对角矩阵。
:::

::: sol 参考答案
矩阵与结果见[例 3.3.2](#ex-3.3.2)。关键步骤：第一次用 $H_1$ 消去第 1 列第 3、4 行，第二次用 $H_2$ 消去第 2 列第 4 行；每次左右各乘一次，保持对称。最终三对角矩阵的次对角线元素为 $(-3,\ 2.759943,\ -1.016207)$。
:::

::: ex 3.11 · 一般矩阵拟上三角化（教材习题 11） {#ex-3.3.11}
用 Householder 相似变换把教材习题 11 的矩阵化为拟上三角矩阵。
:::

::: sol 参考答案
矩阵与结果见[例 3.3.3](#ex-3.3.3)。与习题 10 的差别：只做相似变换 $H_rA^{(r)}H_r$，不追求三对角；最终第 1 列第 3、4 行与第 2 列第 4 行为零，其余次对角线以下也零。
:::

::: ex 3.12 · 基本 QR 方法（教材习题 12） {#ex-3.3.12}
用基本 QR 方法计算教材习题 12 的矩阵的特征值。
:::

::: sol 参考答案
矩阵与迭代过程见[例 3.3.4](#ex-3.3.4)。特征值为 $2$、$2+\sqrt3$、$2-\sqrt3$。若要加速，可先用 Householder 化三对角，再用双步位移 QR；本题规模小，基本 QR 已足够说明原理。
:::

::: method[core] 本节概念速查
| 概念 | 一句话 | 本节出现位置 | 将在何处深入 |
|:--|:--|:--|:--|
| Householder 矩阵 | $H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}$，对称正交，镜面反射 | [@def-3.3.1] | 3.3.1 的 QR 构造 |
| QR 分解 | $A=QR$，$Q$ 正交、$R$ 上三角 | [@def-3.3.2]、[@thm-3.3.1] | 基本 QR 迭代 |
| 拟上三角 | $i>j+1$ 处为零（上 Hessenberg） | [@def-3.3.3] | 3.3.2 降复杂度 |
| 三对角化 | 实对称矩阵拟上三角化后即三对角 | [@ex-3.3.2] | 对称特征值问题 |
| 基本 QR 迭代 | $A_{k+1}=Q_k^{\mathrm T}A_kQ_k$ | 3.3.3 方法盒 | 双步位移 |
| 双步位移 | $M_k=A_k^2-sA_k+tI$，$s,t$ 为右下块特征值之和/积 | 3.3.3 方法盒 | 实矩阵全部特征值 |
| 降阶 | 次对角元足够小就切掉已收敛块 | 3.3.3 方法盒 | 实用 QR 程序 |
:::

::: think[core] 本节常见错误
1. **把 QR 分解与 QR 迭代混为一谈。** QR 分解是「一个矩阵分解成 $Q,R$」；QR 迭代是「反复分解、交换次序」，两者不是一回事，但后者完全建立在前者上。
2. **以为 $R$ 的对角元必须为正。** 不约定符号时 QR 分解不唯一；要求唯一才约定 $R$ 对角为正，并同步调整 $Q$ 的列符号。
3. **Householder 的 $\alpha$ 符号取错。** 取 $\alpha=-\operatorname{sgn}(s_1)\lVert\boldsymbol s\rVert$ 是为了避免 $\boldsymbol s-\alpha\boldsymbol e$ 相消；符号取反会损失精度甚至消不掉元素。
4. **拟上三角化只乘左边。** 相似变换必须左右各乘一次 $H_r$；只乘左边得到的是 QR 分解的一步，不是相似变换，特征值会变。
5. **以为拟上三角化后就是三对角。** 只有实对称矩阵才如此；一般矩阵仍是上 Hessenberg，次对角线以下为零但次对角线本身可以非零。
6. **QR 迭代停止准则看对角元。** 应看次对角元 $\lvert a_{m,m-1}\rvert$ 是否足够小；对角元本身在迭代中一直在变。
7. **忽略降阶。** 不降阶的 QR 迭代对全部 $n$ 阶矩阵反复做，计算量会高一个数量级；实用程序必须 deflation。
8. **对复特征值硬用实位移。** 双步位移用 $s,t$ 合成实矩阵 $M_k$，正是为了在实运算下处理复共轭特征值；单步实位移无法分离复共轭对。
:::

::: note 覆盖核对
本节覆盖教材 3.3.1–3.3.3、引理 3.1、定理 3.2、习题 9–12（例 3.3.1–3.3.4 为按教材算法的新增演算）；**老师课堂未讲**。第 3 章正文到此完整，下一节：[第 3 章习题](exercises.md)。
:::
