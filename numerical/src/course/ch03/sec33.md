# 3.3 QR 方法

Jacobi 方法通过平面旋转处理实对称矩阵。QR 方法也使用相似变换，但每一步先作 QR 分解，再把两个因子的顺序交换。交换后得到的矩阵与原矩阵有相同的特征值。

本节先说明这种关系，再讨论怎样简化矩阵结构、减少每步代价，以及怎样用位移改善迭代效果。保持特征值只是构造方法的第一步，还需要检查迭代是否收敛。

::: intuition 直觉 · 为什么 QR 迭代能求特征值
QR 迭代的核心恒等式是

$$
A_k=Q_kR_k,\qquad A_{k+1}=R_kQ_k=Q_k^{\mathrm T}A_kQ_k .
$$

右端说明 $A_{k+1}$ 与 $A_k$ **正交相似**，特征值一步不变；左端说明每次都在做 QR 分解。目标是让次对角元逐渐变小，从对角元或已分离的 $2\times2$ 块读出特征值。但相似性本身不保证收敛：本节会用一个二阶矩阵检验这一边界。

这和幂法是一枚硬币的两面：幂法只追**一个**主特征值；QR 迭代同时处理**全部**特征值。代价是每步 $O(n^3)$（先化成拟上三角后 $O(n^2)$），所以要先做拟上三角化，再用双步位移加速。
:::

<a id="sec-3.3.1"></a>
## 3.3.1 矩阵的 QR 分解

::: def 定义 3.3.1 · Householder 矩阵 {#def-3.3.1}
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

::: lem 引理 3.1 · Householder 映射把向量打到指定方向 {#lem-3.3.1}
设 $\boldsymbol s\in\mathbb R^n$ 非零，$\boldsymbol e\in\mathbb R^n$ 是单位向量。则存在 Householder 矩阵 $H$，使

$$
H\boldsymbol s=\alpha\boldsymbol e,
$$

其中 $\alpha$ 是实数，且 $|\alpha|=\lVert\boldsymbol s\rVert_2$。
:::

::: proof 证明
选择使 $\boldsymbol s-\alpha\boldsymbol e\ne0$ 的符号，取

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
QR 中目标方向取 $\boldsymbol e_1$，选 $\alpha=-\operatorname{sgn}(s_1)\|\boldsymbol s\|_2$；$s_1=0$ 时任一符号都可，但应固定约定。这样首分量 $s_1-\alpha$ 不发生相近数相减。对一般目标单位向量 $\boldsymbol e$，可取 $\alpha$ 与 $\boldsymbol e^{\mathrm T}\boldsymbol s$ 异号，使 $\|\boldsymbol s-\alpha\boldsymbol e\|_2^2$ 不因抵消而过小。
:::

::: def 定义 3.3.2 · QR 分解 {#def-3.3.2}
把实矩阵 $A$ 分解为

$$
A=QR,
$$

其中 $Q$ 是正交矩阵、$R$ 是上三角矩阵，称为 $A$ 的 **QR 分解**（正交三角分解）。
:::

::: thm 定理 3.2 · QR 分解的存在性 {#thm-3.3.1}
任何 $n\times n$ 实矩阵 $A$ 总可以分解为一个正交矩阵 $Q$ 与一个上三角矩阵 $R$ 的乘积。
:::

::: proof 证明（构造法）
记 $A_1=A$。对 $r=1,2,\dots,n-1$：

1. 取 $A_r$ 的第 $r$ 列从第 $r$ 行到第 $n$ 行的片段 $\boldsymbol s_r$；
2. 若片段为零，取该步变换为恒等；否则由引理 3.3.1 构造嵌入的 Householder 矩阵 $H_r$，把第 $r$ 列第 $r+1$ 行以下全部消为零；
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
Q_{r+1}=Q_r-\frac{1}{h_r}Q_r\boldsymbol u_r\boldsymbol u_r^{\mathrm T},\qquad
A_{r+1}=A_r-\frac{1}{h_r}\boldsymbol u_r\boldsymbol u_r^{\mathrm T}A_r .
$$

这里 $\boldsymbol u_r^{\mathrm T}\boldsymbol u_r=2(c_r^2-c_ra_{rr}^{(r)})=2h_r$，所以 $H_r=I-2uu^{\mathrm T}/(u^{\mathrm T}u)=I-uu^{\mathrm T}/h_r$。若把更新系数写成 $2/h_r$，就不再是正交反射。

算完后 $Q=Q_n$，$R=A_n$。通过向量乘法和秩一更新实现，整体成本为 $O(n^3)$；只保存反射向量求 $R$ 与显式形成完整 $Q$ 的常数不同。做最小二乘时常只需依次把反射作用于右端，无需形成完整 $Q$。
:::

::: ex 引导算例：用两次验算抓住系数错误
取 $\boldsymbol s=(3,4)^{\mathrm T}$，选择 $c=-5$，则 $u=(8,4)^{\mathrm T}$、$h=25+15=40$，故
$$
H=I-\frac{uu^{\mathrm T}}{40}
=\begin{pmatrix}-3/5&-4/5\\-4/5&3/5\end{pmatrix}.
$$
先算 $H\boldsymbol s=(-5,0)^{\mathrm T}$，确认目标分量消为零；再算 $H^{\mathrm T}H=I$，确认不是靠错误缩放实现消元。这两个检查分别验证“做到了什么”和“保留了什么”。

**迁移练习。** 若误用 $2/h$，得到的矩阵作用在 $\boldsymbol s$ 上是什么？是否保持长度？
:::

::: sol 核对
误用后矩阵为 $\begin{pmatrix}-11/5&-8/5\\-8/5&1/5\end{pmatrix}$，乘积为 $(-13,-4)^{\mathrm T}$，长度平方为 $185$，原长度平方只有 $25$。所以消元与正交性同时失败。另一项必须检查的边界是零向量：直接跳过该步，不应归一化一个零向量。
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

**核对**：$QR$ 乘回去应得 $A$；$Q^{\mathrm T}Q=I$；所列 $R$ 的对角元符号为负、正、正。若将 $Q$ 的第三列与 $R$ 的第三行同时取反，仍是同一个矩阵的 QR 分解。非奇异方阵在约定 $R$ 对角为正后分解唯一；奇异矩阵不能直接套用这一唯一性结论。

**读法**：第一步把第一列 $(1,2,1)^{\mathrm T}$ 打到 $(-2.44949,0,0)^{\mathrm T}$；第二步消去更新后的第二列的第三分量。每步以一列的下方元素为消元目标，但反射必须作用于整个剩余子矩阵；只更新目标列会破坏 $A=QR$。
:::

<a id="sec-3.3.2"></a>
## 3.3.2 矩阵的拟上三角化

::: def 定义 3.3.3 · 拟上三角矩阵 {#def-3.3.3}
若矩阵 $A=(a_{ij})$ 满足

$$
a_{ij}=0\qquad(i>j+1),
$$

即次对角线以下全为零，则称 $A$ 为**拟上三角矩阵**（上 Hessenberg 矩阵）。
:::

::: method[core] 用 Householder 相似变换化拟上三角 {#method-3.3-hessenberg}
对 $r=1,2,\dots,n-2$：

1. 取第 $r$ 列从第 $r+1$ 行到第 $n$ 行的完整尾向量 $\boldsymbol s_r=(a_{r+1,r},a_{r+2,r},\dots,a_{nr})^{\mathrm T}$；若待消元素已全为零，则跳过该步；
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

::: ex 例 3.3.2 · 对称矩阵三对角化 {#ex-3.3.2}
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

每个 $A_k$ 都与 $A$ 正交相似，特征值不变。这是不变量，不是无条件收敛定理。若迭代成功分离了块，实对称情形可从对角元读取特征值；一般实矩阵的目标为实 Schur 形式，一阶块给实特征值，二阶块可给复共轭特征值。基本无位移 QR 可能停滞，需要另行分析谱结构与初始子空间。
:::

::: ex 反例：对称、正交，却不被基本 QR 对角化
令 $A=\begin{pmatrix}0&1\\1&0\end{pmatrix}$，特征值为 $1,-1$。按 $R$ 对角为正的约定，$Q=A,R=I$，于是 $RQ=A$，每一步都原地不动。相似性保持、QR 分解正确，但非对角元并未变小。两个特征值的模相等，使“实对称就必然对角收敛”的说法失效。

**自检。** 只检查迭代前后对角元差是否为零，会把该矩阵误判为已对角化；检查非对角残量能识别这一问题。
:::

::: note 基本 QR 的两个问题
1. **收敛慢**：收敛速度取决于特征值模的比值；相邻特征值模接近时很慢。
2. **复数特征值**：实矩阵的复共轭特征值会以 $2\times2$ 块出现，基本 QR 用实运算可以处理块，但收敛判据和位移要专门设计。

双步位移同时解决这两个问题：用右下 $2\times2$ 块的特征值作位移加速；把两个位移合成一个实矩阵 $M_k$，避免复数运算。
:::

::: method[core] 双步位移 QR {#method-3.3-double-shift}
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

这是双步位移的代数表达，$s,t$ 都是实数，即使位移为复共轭也无需复数运算。实用的隐式双步算法通过局部变换追赶凸起，保留 Hessenberg 结构；不应每轮显式形成 $A_k^2$ 并做一次稠密 QR，否则无法获得前述每步 $O(n^2)$ 的成本。
:::

::: method[core] 降阶（deflation）与停止准则 {#method-3.3-deflation}
从 $m=n$ 开始：

1. 若 $m=1$，读取剩下的对角元；若 $m=2$，直接处理最后的二阶块，避免访问不存在的下标；
2. 对 $m\ge3$，检查末尾次对角元是否小于与局部尺度相配的容差，例如 $\mathrm{atol}+\mathrm{rtol}(|a_{m-1,m-1}|+|a_{mm}|)$。满足时将其置零，把 $a_{mm}$ 作为近似特征值并令 $m\leftarrow m-1$；
3. 否则对 $a_{m-1,m-2}$ 做对应尺度的检查。满足时将右下二阶块分离，求该块特征值并令 $m\leftarrow m-2$；
4. 尚未分离时继续位移迭代；预算耗尽或停滞必须报告，不能强读对角元。

次对角元恰为零时分离在精确算术中成立；小而非零时，置零是一个可度量的矩阵扰动，其特征值影响还取决于谱的敏感性。降阶减少后续活动块规模，但总复杂度仍取决于迭代次数，不能仅凭“有降阶”推出固定的阶数下降。
:::

::: ex 例 3.3.3 · 一般矩阵拟上三角化 {#ex-3.3.3}
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

::: ex 例 3.3.4 · 基本 QR 迭代求特征值 {#ex-3.3.4}
用基本 QR 方法计算

$$
A=\begin{pmatrix}3&1&0\\1&2&1\\0&1&1\end{pmatrix}
$$

的特征值。

**解** 从 $A_1=A$ 出发，反复做 $A_k=Q_kR_k,\ A_{k+1}=R_kQ_k$。下表 $k$ 指已经完成的更新次数，列出的是 $A_{k+1}$ 的元素：

| 更新次数 $k$ | $a_{11}^{(k+1)}$ | $a_{22}^{(k+1)}$ | $a_{33}^{(k+1)}$ | $\max_{i\ne j}\lvert a_{ij}^{(k+1)}\rvert$ |
|:--:|:--:|:--:|:--:|:--:|
| 1 | 3.500000 | 2.214286 | 0.285714 | $5.92\times10^{-1}$ |
| 4 | 3.725760 | 2.006291 | 0.267949 | $1.04\times10^{-1}$ |
| 8 | 3.732008 | 2.000043 | 0.267949 | $8.62\times10^{-3}$ |

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
## 习题

::: ex 3.9 · Householder 映射 {#ex-3.3.9}
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

::: ex 3.10 · 对称矩阵三对角化 {#ex-3.3.10}
独立重做[例 3.3.2](#ex-3.3.2)：使用题面给出的矩阵，将实对称矩阵化为三对角矩阵。遮住例题中的解答，完成后再比较。
:::

::: sol 参考答案
矩阵与结果见[例 3.3.2](#ex-3.3.2)。关键步骤：第一次用 $H_1$ 消去第 1 列第 3、4 行，第二次用 $H_2$ 消去第 2 列第 4 行；每次左右各乘一次，保持对称。最终三对角矩阵的次对角线元素为 $(-3,\ 2.759943,\ -1.016207)$。
:::

::: ex 3.11 · 一般矩阵拟上三角化 {#ex-3.3.11}
独立重做[例 3.3.3](#ex-3.3.3)：使用题面给出的矩阵，将矩阵化为上 Hessenberg 矩阵。遮住例题中的解答，完成后再比较。
:::

::: sol 参考答案
矩阵与结果见[例 3.3.3](#ex-3.3.3)。与习题 10 的差别：只做相似变换 $H_rA^{(r)}H_r$，不追求三对角；最终第 1 列第 3、4 行与第 2 列第 4 行为零，其余次对角线以下也零。
:::

::: ex 3.12 · 基本 QR 方法 {#ex-3.3.12}
独立重做[例 3.3.4](#ex-3.3.4)：使用题面给出的矩阵，计算矩阵的全部特征值。遮住例题中的解答，完成后再比较。
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
2. **忽略唯一性的条件。** 非奇异方阵约定 $R$ 对角为正时分解唯一；翻转 $Q$ 的列符号时必须同步翻转 $R$ 的行符号。
3. **Householder 的 $\alpha$ 符号取错。** 取 $\alpha=-\operatorname{sgn}(s_1)\lVert\boldsymbol s\rVert$ 是为了避免 $\boldsymbol s-\alpha\boldsymbol e$ 相消；符号取反会损失精度甚至消不掉元素。
4. **拟上三角化只乘左边。** 相似变换必须左右各乘一次 $H_r$；只乘左边得到的是 QR 分解的一步，不是相似变换，特征值会变。
5. **以为拟上三角化后就是三对角。** 只有实对称矩阵才如此；一般矩阵仍是上 Hessenberg，次对角线以下为零但次对角线本身可以非零。
6. **QR 迭代停止准则看对角元。** 应看次对角元 $\lvert a_{m,m-1}\rvert$ 是否足够小；对角元本身在迭代中一直在变。
7. **忽略降阶与预算。** 已分离的块不必继续参与迭代；未分离的块也不能无限计算，应报告活动块残量与停止原因。
8. **对复特征值硬用实位移。** 双步位移用 $s,t$ 合成实矩阵 $M_k$，正是为了在实运算下处理复共轭特征值；单步实位移无法分离复共轭对。
:::
