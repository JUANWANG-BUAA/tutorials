# 第 2 章练习与解答

各节末尾已经给出题目与参考解答。下表按顺序列出入口；本页后半部分是综合练习。

| 题号 | 练习 |
|:--|:--|
| <span id="ex-2-1">2.1</span> | [三位十进制的顺序消去与列主元](sec21.md#exercise-2.1) |
| <span id="ex-2-2">2.2</span> | [消元矩阵 R](sec21.md#exercise-2.2) |
| <span id="ex-2-3">2.3</span> | [行交换矩阵 Q_k](sec21.md#exercise-2.3) |
| <span id="ex-2-4">2.4</span> | [Doolittle 运算量](sec22.md#exercise-2.4) |
| <span id="ex-2-5">2.5</span> | [不选主元的 Doolittle](sec22.md#exercise-2.5) |
| <span id="ex-2-6">2.6</span> | [选主元的 Doolittle](sec22.md#exercise-2.6) |
| <span id="ex-2-7">2.7</span> | [带状存储下计算 Ax](sec22.md#exercise-2.7) |
| <span id="ex-2-8">2.8</span> | [追赶法](sec22.md#exercise-2.8) |
| <span id="ex-2-9">2.9</span> | [八位十进制列主元 + 条件数](sec23.md#exercise-2.9) |
| <span id="ex-2-10">2.10</span> | [正交矩阵的条件数](sec23.md#exercise-2.10) |
| <span id="ex-2-11">2.11</span> | [残差与误差界](sec23.md#exercise-2.11) |
| <span id="ex-2-12">2.12</span> | [条件数与残差反例](sec23.md#exercise-2.12) |
| <span id="ex-2-13">2.13</span> | [迭代序列收敛判断](sec24.md#exercise-2.13) |
| <span id="ex-2-14">2.14</span> | [必收敛的迭代](sec24.md#exercise-2.14) |
| <span id="ex-2-15">2.15</span> | [Jacobi 解方程组](sec24b.md#exercise-2.15) |
| <span id="ex-2-16">2.16</span> | [Jacobi 收敛性讨论](sec24b.md#exercise-2.16) |
| <span id="ex-2-17">2.17</span> | [Gauss–Seidel 解第 15 题](sec24b.md#exercise-2.17) |
| <span id="ex-2-18">2.18</span> | [GS 收敛性讨论](sec24b.md#exercise-2.18) |
| <span id="ex-2-19">2.19</span> | [构造必收敛的迭代](sec24b.md#exercise-2.19) |
| <span id="ex-2-20">2.20</span> | [2×2 的 Jacobi 与 GS](sec24b.md#exercise-2.20) |
| <span id="ex-2-21">2.21</span> | [含参数 a 的收敛范围](sec24b.md#exercise-2.21) |
| <span id="ex-2-22">2.22</span> | [直接判定 GS](sec24b.md#exercise-2.22) |
| <span id="ex-2-23">2.23</span> | [SOR（ω=0.9）](sec24b.md#exercise-2.23) |
| <span id="ex-2-24">2.24</span> | [SOR（ω=1.25）](sec24b.md#exercise-2.24) |


## 补充练习

::: ex 2.C1 · 为什么列主元能控制误差？
从乘数 $|m_{ik}|\le1$ 出发，解释列主元为什么能避免“小主元放大舍入误差”。
:::

::: sol 参考答案
消元第 $k$ 步的误差放大与 $|m_{ik}|$ 有关；列主元使 $|m_{ik}|\le1$，不会把小数当分母。它不能改变条件数，但能避免算法额外放大误差。
:::

::: ex 2.C2 · 残差小是否等于解准？
举一个 $\mathrm{cond}(A)$ 很大、残差很小但误差很大的例子，并说明停机判据的局限。
:::

::: sol 参考答案
取 $A=\begin{pmatrix}1&1\\1&1.0001\end{pmatrix}$，两个近似解的残差都可很小，但解可差很远；因为 $e=A^{-1}r$，$\lVert A^{-1}\rVert$ 很大。停机判据只能控制残差，不能控制误差。
:::

## 作业组：综合练习

::: note 练习说明 {#hw-2-meta}
下面的综合练习附有完整推导。建议先独立作答，再展开解答核对关键步骤。
:::

::: ex 作业 2-1 · 主元素就是顺序主子式的比值 {#hw-2-1}

**（第二章自测题 1）** 对线性方程组 $A\boldsymbol x=\boldsymbol b$，如果 $A$ 的顺序主子式记为 $D_k$。设顺序 Gauss 消去法可以正常进行，且消元过程中产生的主元素为 $a_{kk}^{(k)}$，$k=1,\cdots,n$，证明：

$$a_{11}^{(1)}=D_1,\qquad a_{jj}^{(j)}=\frac{D_j}{D_{j-1}},\quad j=2,\cdots,n .$$

:::

::: sol 精讲 {#sol-hw-2-1}

**思路**：把消去过程翻译成 **$A=LU$**，再把 $LU$ 限制到前 $k$ 阶主子阵上，取行列式。

**第一步：顺序消去 ⟺ 存在 Doolittle 分解。** 顺序消去能正常进行（主元全程非零）当且仅当 $A$ 的各阶顺序主子式 $D_k\neq0$（[定理 2.1](sec21.md#thm-2.1)），此时存在唯一的单位下三角 $L$ 与上三角 $U$ 使 $A=LU$，且 $U$ 的对角元正是消元产生的主元素：

$$u_{kk}=a_{kk}^{(k)},\qquad k=1,\cdots,n .$$

**第二步：主子阵也满足同样的分解。** 把 $L,U,A$ 按前 $k$ 行／列分块：

$$A=\begin{pmatrix}A_k&A_{12}\\A_{21}&A_{22}\end{pmatrix},\quad
L=\begin{pmatrix}L_k&O\\L_{21}&L_{22}\end{pmatrix},\quad
U=\begin{pmatrix}U_k&U_{12}\\O&U_{22}\end{pmatrix},$$

其中 $L_k$ 是 $k$ 阶**单位**下三角、$U_k$ 是 $k$ 阶上三角。乘开左上角的块：

$$A_k=L_kU_k .$$

（这一步的合法性：$L$ 的下三角、$U$ 的上三角使左上的块只由左上的块相乘得到，与右下角无关。）

**第三步：取行列式。** $L_k$ 单位下三角 ⟹ $\det L_k=1$；$U_k$ 上三角 ⟹ $\det U_k=\prod_{i=1}^{k}u_{ii}$。于是

$$D_k=\det A_k=\det L_k\cdot\det U_k=\prod_{i=1}^{k}u_{ii}=\prod_{i=1}^{k}a_{ii}^{(i)} .$$

**第四步：做比。** $k=1$：$D_1=a_{11}^{(1)}$。$k\ge2$：

$$\frac{D_k}{D_{k-1}}=\frac{\prod_{i=1}^{k}a_{ii}^{(i)}}{\prod_{i=1}^{k-1}a_{ii}^{(i)}}=a_{kk}^{(k)} .\qquad\blacksquare$$

这里需要区分消元能否进行与方程组是否有唯一解：

1. **主元的乘积 = 行列式**（在无换行时）。所以「消元过程会不会断」等价于「$D_k$ 会不会变号为零」——这就是定理 2.2 里那串顺序主子式条件的来源。
2. **换行之后这个公式就失效**。列主元法里 $P A=LU$，取行列式只能得到 $\pm D_k=\det U_k$，主元不再是 $D_k/D_{k-1}$。作业 2-2 的四位十进制实验会看到：一旦换行，主元的量级与 $D_k$ 的关系就被打乱，而这恰恰是列主元「救回精度」的机制。

**易错点**：直接用「$D_k$ 按第一行展开」硬证——会陷入 $n$ 层代数余子式。本题的正道是**矩阵分解 + 分块 + 行列式乘法**，三步到位。

:::

::: ex 作业 2-2 · 四位十进制：顺序消去 vs 列主元（同一个方程组，两种命运） {#hw-2-2}

**（第二章自测题 2）** 在四位十进制的限制下，分别用顺序 Gauss 消去法和列主元 Gauss 消去法求解

$$\begin{pmatrix}0.001&2.000&3.000\\-1.000&3.716&4.810\\-2.000&1.116&5.712\end{pmatrix}
\begin{pmatrix}x_1\\x_2\\x_3\end{pmatrix}=\begin{pmatrix}1.000\\2.000\\3.000\end{pmatrix},$$

并分析结果。

:::

::: sol 精讲 {#sol-hw-2-2}

**先记精确解（分数精确求解，可用于对照）**：

$$\boldsymbol x^{*}=(-0.43758793,\ -0.08172027,\ 0.38795938)^{\mathrm T},$$

且 $\lVert A\rVert_\infty=9.526$、$\lVert A^{-1}\rVert_\infty=2.284$、$\mathrm{cond}_\infty(A)=21.76$。**条件数只有 21.8——问题本身一点都不病态**。后面的灾难全部由算法造成，这正是本题的教学价值。

### 一、顺序 Gauss 消去（四位十进制，每步四舍五入）

第一步主元 $a_{11}=0.001$（极小），乘数

$$m_{21}=\frac{-1.000}{0.001}=-1000,\qquad m_{31}=\frac{-2.000}{0.001}=-2000 .$$

| 行 | 运算 | $a_{i2}$ | $a_{i3}$ | $b_i$ |
|:--:|:--|:--:|:--:|:--:|
| 2 | 行 2 $+1000\times$ 行 1 | $3.716+2000=2003.716\to\mathbf{2004}$ | $4.810+3000=3004.81\to\mathbf{3005}$ | $2+1000=\mathbf{1002}$ |
| 3 | 行 3 $+2000\times$ 行 1 | $1.116+4000=4001.116\to\mathbf{4001}$ | $5.712+6000=6005.712\to\mathbf{6006}$ | $3+2000=\mathbf{2003}$ |

第二步：$m_{32}=\dfrac{4001}{2004}=1.997$，

$$a_{33}=6006-1.997\times3005=6006-6001=\mathbf{5.000},\qquad b_3=2003-1.997\times1002=2003-2001=\mathbf{2.000}.$$

回代：

$$x_3=\frac{2.000}{5.000}=0.4000,\quad
x_2=\frac{1002-3005\times0.4000}{2004}=\frac{1002-1202}{2004}=-0.09980,$$

$$x_1=\frac{1.000-2.000\times(-0.09980)-3.000\times0.4000}{0.001}=\frac{1.000+0.1996-1.200}{0.001}=\frac{0.000}{0.001}=0.000 .$$

（四位算术里 $1.200-1.200=0$，分子被完全抹平。）**结果 $\boldsymbol x=(0.000,\,-0.0998,\,0.4000)^{\mathrm T}$，与精确解比：$x_1$ 误差 100%，$x_2$ 误差 22%，$x_3$ 误差 3%。**

### 二、列主元 Gauss 消去

第一步先在**第 1 列**选主元：$\lvert-2.000\rvert=2.000$ 最大，交换第 1、3 行：

$$\left(\begin{array}{ccc|c}-2.000&1.116&5.712&3.000\\-1.000&3.716&4.810&2.000\\0.001&2.000&3.000&1.000\end{array}\right).$$

乘数变成 $m_{21}=0.5$、$m_{31}=-0.0005$（都**小于 1**）：

| 行 | 运算 | $a_{i2}$ | $a_{i3}$ | $b_i$ |
|:--:|:--|:--:|:--:|:--:|
| 2 | 行 2 $-0.5\times$ 行 1 | $3.716-0.558=\mathbf{3.158}$ | $4.810-2.856=\mathbf{1.954}$ | $2.000-1.500=\mathbf{0.5000}$ |
| 3 | 行 3 $+0.0005\times$ 行 1 | $2.000+0.000558=\mathbf{2.001}$ | $3.000+0.002856=\mathbf{3.003}$ | $1.000+0.0015=\mathbf{1.002}$ |

第二步选主元：$\lvert3.158\rvert\gt\lvert2.001\rvert$，不换行；$m_{32}=\dfrac{2.001}{3.158}=0.6336$，

$$a_{33}=3.003-0.6336\times1.954=3.003-1.238=\mathbf{1.765},\qquad
b_3=1.002-0.6336\times0.5000=1.002-0.3168=\mathbf{0.6852}.$$

回代：

$$x_3=\frac{0.6852}{1.765}=0.3882,\quad
x_2=\frac{0.5000-1.954\times0.3882}{3.158}=\frac{-0.2585}{3.158}=-0.08186,$$

$$x_1=\frac{3.000-1.116\times(-0.08186)-5.712\times0.3882}{-2.000}=\frac{0.8740}{-2.000}=-0.4370 .$$

**结果 $\boldsymbol x=(-0.4370,\,-0.08186,\,0.3882)^{\mathrm T}$，各分量相对误差约为 $0.13\%$、$0.17\%$、$0.062\%$；改善明显，但不能据打印了四位就称都有四位有效数字。**

### 三、分析（这一节才是得分点）

| 项目 | 顺序消去 | 列主元 |
|:--|:--|:--|
| 乘数 | $-1000$、$-2000$ | $0.5$、$-0.0005$ |
| 消元后主元 | $2004$、$5.000$ | $3.158$、$1.765$ |
| 解 | $(0.000,-0.0998,0.4000)^{\mathrm T}$ | $(-0.4370,-0.08186,0.3882)^{\mathrm T}$ |
| $x_1$ 相对误差 | $100\%$ | $0.13\%$ |

三条结论：

1. **病根是小主元**。$a_{11}=0.001$ 使 $m_{21}=-1000$：消元时把行 1 放大约 1000 倍再加到行 2 上，行 2 的原始信息（只有 4 位有效数字）被彻底淹没。这一步之后，"行 2 的 $a_{22}$" 其实是 $1000\times2.000$ 舍入后的残余，与原矩阵几乎无关。
2. **区分问题敏感性与算法误差。**本例矩阵的条件数不大。顺序消去出现的大误差来自计算过程；改用列主元可以改善结果，而原矩阵的条件数保持不变。
3. **列主元的机制是「让乘数不超过 1」**。列主元使 $|m_{ik}|\le1$，抑制由消元乘数引起的放大，但后续元素仍可能增长，不能据此保证舍入误差绝不放大；这是[2.1.2 列主元](sec21.md#sec-2.1.2) 的结论，本题是它的数值证据。

**编者复核：缩放能否代替选主元？** 将第一行乘 $1000$，乘数虽然从 $-1000,-2000$ 变成 $-1,-2$，但第一行的其他元素也放大了 $1000$ 倍；生成的 $2004,3005,4001,6006$ 等消元数据并未改善。在相同四位算术和运算次序下仍得到原来的劣解。应联合考虑乘数、元素增长与尺度，不能宣称“把小主元放大就解决稳定性”。

:::

::: ex 作业 2-3 · 用矩阵范数造向量范数 {#hw-2-3}

**（第二章自测题 3）** 已知 $A\in\mathbb{R}^{n\times n}$，$\lVert A\rVert$ 为 $A$ 的某一矩阵范数。证明 $\lVert\boldsymbol x\rVert=\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert$ 满足向量范数的定义，其中 $\boldsymbol x\in\mathbb{R}^n$ 为列向量，$\boldsymbol e_i$ 是第 $i$ 个元素为 1、其余元素为 0 的列向量。

:::

::: sol 精讲 {#sol-hw-2-3}

先看清 $\boldsymbol x\boldsymbol e_i^{\mathrm T}$ 是什么：它是 $n\times n$ 矩阵，**第 $i$ 列是 $\boldsymbol x$，其余各列全零**（$\boldsymbol e_i^{\mathrm T}$ 只有第 $i$ 个分量为 1）。

逐条验证向量范数的三条（本书采用[1.3.1](../../ch01/sec13.md#sec-1.3.1) 的三条公理：正定、齐次、三角）：

**(1) 正定。** 由矩阵范数的非负性，$\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert\ge0$。若 $\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert=0$，由**矩阵范数的正定性**得 $\boldsymbol x\boldsymbol e_i^{\mathrm T}=O$。而 $\boldsymbol x\boldsymbol e_i^{\mathrm T}$ 的第 $i$ 列恰是 $\boldsymbol x$，故 $\boldsymbol x=\boldsymbol 0$；反之 $\boldsymbol x=\boldsymbol 0$ 时 $\boldsymbol x\boldsymbol e_i^{\mathrm T}=O$、范数为 0。**这一步是本题唯一的「坑」**：必须借 $\boldsymbol e_i\neq\boldsymbol 0$ 把「矩阵为零」翻译成「向量为零」。

**(2) 齐次。** 对任意 $k\in\mathbb{R}$，$k\boldsymbol x\boldsymbol e_i^{\mathrm T}= (k\boldsymbol x)\boldsymbol e_i^{\mathrm T}$，由矩阵范数的齐次性

$$\lVert k\boldsymbol x\rVert=\lVert (k\boldsymbol x)\boldsymbol e_i^{\mathrm T}\rVert=\lVert k(\boldsymbol x\boldsymbol e_i^{\mathrm T})\rVert=\lvert k\rvert\,\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert=\lvert k\rvert\,\lVert\boldsymbol x\rVert .$$

**(3) 三角不等式。**

$$\lVert\boldsymbol x+\boldsymbol y\rVert=\lVert(\boldsymbol x+\boldsymbol y)\boldsymbol e_i^{\mathrm T}\rVert
=\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}+\boldsymbol y\boldsymbol e_i^{\mathrm T}\rVert
\le\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert+\lVert\boldsymbol y\boldsymbol e_i^{\mathrm T}\rVert=\lVert\boldsymbol x\rVert+\lVert\boldsymbol y\rVert .\qquad\blacksquare$$

**相容性。**这个向量范数与 $\lVert\cdot\rVert$ **相容**。因为

$$\lVert A\boldsymbol x\rVert=\lVert A\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert=\lVert A(\boldsymbol x\boldsymbol e_i^{\mathrm T})\rVert\le\lVert A\rVert\,\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert=\lVert A\rVert\,\lVert\boldsymbol x\rVert .$$

这给出了[1.3.3](../../ch01/sec13.md#sec-1.3.3) 中相容向量范数的一种构造。[第一章练习 B4](../../ch01/exercises.md#sec-练习-b) 使用另一种构造 $\lVert\boldsymbol x\rVert_*=N(\boldsymbol x\boldsymbol b^{\mathrm T})$。两个构造思路完全一致：**把向量「做成」矩阵，再用矩阵范数度量**。

:::

::: ex 作业 2-4 · 用 LU 分解解方程组 {#hw-2-4}

**（第二章自测题 4）** 利用矩阵 $A$ 的三角分解 $A=LU$ 求解

$$\begin{pmatrix}1&2&1\\2&2&3\\-1&-3&0\end{pmatrix}\begin{pmatrix}x_1\\x_2\\x_3\end{pmatrix}=\begin{pmatrix}0\\3\\2\end{pmatrix}.$$

:::

::: sol 精讲 {#sol-hw-2-4}

**第一步：Doolittle 分解（$L$ 单位下三角，$U$ 上三角）。** 按「一行一行往下推」的次序（[2.2.1](sec22.md#sec-2.2.1)）：

$$l_{21}=\frac{a_{21}}{u_{11}}=\frac21=2,\qquad l_{31}=\frac{a_{31}}{u_{11}}=\frac{-1}{1}=-1 .$$

第二行：$u_{22}=a_{22}-l_{21}u_{12}=2-2\times2=-2$，$u_{23}=a_{23}-l_{21}u_{13}=3-2\times1=1$。

第三行：$u_{32}=a_{32}-l_{31}u_{12}=-3-(-1)\times2=-1$，故 $l_{32}=\dfrac{u_{32}}{u_{22}}=\dfrac{-1}{-2}=0.5$；

$$u_{33}=a_{33}-l_{31}u_{13}-l_{32}u_{23}=0-(-1)\times1-0.5\times1=0.5 .$$

于是

$$L=\begin{pmatrix}1&0&0\\2&1&0\\-1&0.5&1\end{pmatrix},\qquad
U=\begin{pmatrix}1&2&1\\0&-2&1\\0&0&0.5\end{pmatrix}.$$

（验算：$LU$ 乘回去应得 $A$，逐元素核对一遍再往下走——这是本题最容易被扣分的地方，$l_{32}$ 的符号错一次全盘皆输。）

**第二步：解 $L\boldsymbol y=\boldsymbol b$（前代）。**

$$y_1=0;\qquad 2y_1+y_2=3\Rightarrow y_2=3;\qquad -y_1+0.5y_2+y_3=2\Rightarrow y_3=2-1.5=0.5 .$$

**第三步：解 $U\boldsymbol x=\boldsymbol y$（回代）。**

$$0.5x_3=0.5\Rightarrow x_3=1;\qquad -2x_2+x_3=3\Rightarrow x_2=-1;\qquad x_1+2x_2+x_3=0\Rightarrow x_1=1 .$$

$$\boxed{\ \boldsymbol x=(1,\,-1,\,1)^{\mathrm T}\ }$$

**验算**：$A\boldsymbol x=(1-2+1,\ 2-2+3,\ -1+3+0)^{\mathrm T}=(0,3,2)^{\mathrm T}=\boldsymbol b$ ✓。

**本题的三个考点**（也是考场上最容易丢分的三处）：
1. Doolittle 与 Crout 别混：Doolittle 是 $L$ 对角全 1、先算 $U$ 的第 $k$ 行；Crout 是 $U$ 对角全 1、先算 $L$ 的第 $k$ 列。本题按 Doolittle 走。
2. 顺序不能反：**先前代后回代**，$LU\boldsymbol x=\boldsymbol b$ 要拆成 $L(U\boldsymbol x)=\boldsymbol b$，令 $\boldsymbol y=U\boldsymbol x$。
3. 分解与右端无关：若还有另一组右端 $\boldsymbol b'$，只需再做一次前代+回代，$O(n^2)$ 而不是 $O(n^3)$，可复用已有的分解。

:::

::: ex 作业 2-5 · Richardson 型迭代的收敛半径 {#hw-2-5}

**（第二章自测题 5）** 设有线性方程组 $A\boldsymbol x=\boldsymbol b$，$A$ 非奇异。证明对任意的 $\omega\in\bigl(0,\,2\rho^{-2}(A)\bigr)$，迭代格式

$$\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\omega\bigl(A^{\mathrm T}\boldsymbol b-A^{\mathrm T}A\boldsymbol x^{(k)}\bigr)$$

收敛，且极限是 $A\boldsymbol x=\boldsymbol b$ 的解。

:::

::: sol 精讲 {#sol-hw-2-5}

**先核对原题的记号。** PDF 写的是 $0<\omega<2\rho^{-2}(A)$，却未在题面把 $\rho$ 定义为谱范数。本书统一用 $\rho(A)$ 表示谱半径；按此含义，原命题对一般非奇异矩阵**不成立**。不能擅自改称“题目用 $\rho$ 表示谱范数”来消除矛盾。

反例取

$$A=\begin{pmatrix}1&2\\0&1\end{pmatrix},\quad \rho(A)=1,\quad
A^{\mathrm T}A=\begin{pmatrix}1&2\\2&5\end{pmatrix}.$$

后者的特征值是 $3\pm2\sqrt2$。取 $\omega=1\in(0,2)$，迭代矩阵 $G=I-A^{\mathrm T}A$ 有特征值 $-2-2\sqrt2$，模大于 1，因此不能对任意初值收敛。

**正确结论与证明。** 对一般非奇异实方阵，迭代对任意初值收敛的充要条件是

$$\boxed{0<\omega<\frac2{\|A\|_2^2}=\frac2{\lambda_{\max}(A^{\mathrm T}A)}.}$$

令 $x^*=A^{-1}b$、$e_k=x^{(k)}-x^*$，有

$$e_{k+1}=(I-\omega A^{\mathrm T}A)e_k.$$

因 $A$ 非奇异，$A^{\mathrm T}A$ 对称正定，可正交对角化，其特征值满足 $0<\mu_{\min}\le\mu_i\le\mu_{\max}=\|A\|_2^2$。因此

$$\rho(G)=\max_i|1-\omega\mu_i|<1
\iff 0<\omega\mu_i<2\quad(\text{所有 }i)
\iff 0<\omega<2/\mu_{\max}.$$

这时 $e_k=G^ke_0\to0$，极限正是 $Ax=b$ 的唯一解。也可在极限处得到 $A^{\mathrm T}(Ax^*-b)=0$，利用 **$A^{\mathrm T}$ 可逆**推出残差为零；不能将其随意左乘残差后写成残差平方。

**什么时候原题的界也对？** 若额外知道 $A$ 为实正规矩阵（实对称是常见特例），则 $\|A\|_2=\rho(A)$，两种界才一致。对于一般矩阵，不能把谱半径直接替代这里的谱范数。

**边界与选参。** $\omega=0$ 时不更新；$\omega=2/\mu_{\max}$ 时出现特征值 -1，某些初值会不衰减地振荡。若已知两个端点，最小化最坏误差因子的选择为 $\omega_*=2/(\mu_{\min}+\mu_{\max})$，对应因子 $(\mu_{\max}-\mu_{\min})/(\mu_{\max}+\mu_{\min})$。这里的充要条件来自[谱半径定理 2.8](sec24.md#thm-2.8)，不是范数充分条件定理 2.9。
:::

::: ex 作业 2-6 · 三对角型矩阵：Jacobi 与 GS 同时收敛的充要条件 {#hw-2-6}

**（第二章自测题 6）** 设矩阵 $A\in\mathbb{R}^{3\times3}$ 非奇异，具有特殊形式

$$A=\begin{pmatrix}10&a&0\\b&10&b\\0&a&5\end{pmatrix},$$

试给出线性方程组 $A\boldsymbol x=\boldsymbol b$ 的 Jacobi 与 Gauss–Seidel 迭代格式**都收敛**的充要条件。

:::

::: sol 精讲 {#sol-hw-2-6}

**结论（先说答案）**：两者的充要条件**完全相同**，

$$\lvert ab\rvert\lt\frac{100}{3}\approx33.33 .$$

即 $A$ 的 Jacobi 与 GS 迭代同时收敛、同时发散，不存在「一个收敛一个发散」的参数区间。下面是完整推导——这道题的价值全在「$G_{GS}$ 长得不像 $G_J$，但谱半径只差一个平方」这个结构上。

### 一、Jacobi：$G_J=I-D^{-1}A$

$D=\operatorname{diag}(10,10,5)$，故

$$G_J=\begin{pmatrix}0&-\frac{a}{10}&0\\[2pt]-\frac{b}{10}&0&-\frac{b}{10}\\[2pt]0&-\frac{a}{5}&0\end{pmatrix}.$$

设 $G_J\boldsymbol v=\lambda\boldsymbol v$，写出三个分量方程：

$$-\frac{a}{10}v_2=\lambda v_1,\qquad -\frac{b}{10}(v_1+v_3)=\lambda v_2,\qquad -\frac{a}{5}v_2=\lambda v_3 .$$

由第 1、3 式得 $v_1=-\dfrac{a}{10\lambda}v_2$、$v_3=-\dfrac{a}{5\lambda}v_2$（$\lambda\neq0$），代入第 2 式：

$$-\frac{b}{10}\left(-\frac{a}{10\lambda}-\frac{a}{5\lambda}\right)v_2=\lambda v_2
\ \Longrightarrow\ \frac{ab}{10}\cdot\frac{3}{10\lambda}=\lambda
\ \Longrightarrow\ \lambda^{2}=\frac{3ab}{100},$$

另有一个 $\lambda=0$（对应 $v_2=0$ 之外的平凡情形）。所以

$$\rho(G_J)=\frac{\sqrt{3\lvert ab\rvert}}{10}\lt1\iff\lvert ab\rvert\lt\frac{100}{3}.$$

### 二、Gauss–Seidel：$G_{GS}=-(D+L)^{-1}U$

先算 $(D+L)^{-1}$（下三角，逐列求逆）：

$$(D+L)^{-1}=\begin{pmatrix}\frac{1}{10}&0&0\\[2pt]-\frac{b}{100}&\frac{1}{10}&0\\[2pt]\frac{ab}{500}&-\frac{a}{50}&\frac{1}{5}\end{pmatrix}.$$

再算 $G_{GS}=-(D+L)^{-1}U$，其中 $U$ 只有 $(1,2)$ 元 $a$ 与 $(2,3)$ 元 $b$：

$$G_{GS}=-\begin{pmatrix}0&\frac{a}{10}&0\\[2pt]0&-\frac{ab}{100}&\frac{b}{10}\\[2pt]0&\frac{a^{2}b}{500}&-\frac{ab}{50}\end{pmatrix}
=\begin{pmatrix}0&-\frac{a}{10}&0\\[2pt]0&\frac{ab}{100}&-\frac{b}{10}\\[2pt]0&-\frac{a^{2}b}{500}&\frac{ab}{50}\end{pmatrix}.$$

**注意第一列全为零**（$U$ 的第一列为零 ⟹ $x_1$ 不影响迭代），故有一个特征值 $0$，剩下 $2\times2$ 块

$$M=\begin{pmatrix}\frac{ab}{100}&-\frac{b}{10}\\[3pt]-\frac{a^{2}b}{500}&\frac{ab}{50}\end{pmatrix},\qquad
\operatorname{tr}M=\frac{3ab}{100},\quad \det M=\frac{a^{2}b^{2}}{5000}-\frac{a^{2}b^{2}}{5000}=0 .$$

行列式为零 ⟹ $M$ 的**秩至多为 1**（$a=b=0$ 时秩为 0），两个特征值为 $0$ 与 $\operatorname{tr}M=\dfrac{3ab}{100}$。于是

$$\rho(G_{GS})=\frac{3\lvert ab\rvert}{100},\qquad
\rho(G_{GS})\lt1\iff\lvert ab\rvert\lt\frac{100}{3}.$$

### 三、结论与检验

| 量 | 表达式 | 收敛条件 |
|:--|:--|:--|
| $\rho(G_J)$ | $\dfrac{\sqrt{3\lvert ab\rvert}}{10}$ | $\lvert ab\rvert\lt\dfrac{100}{3}$ |
| $\rho(G_{GS})$ | $\dfrac{3\lvert ab\rvert}{100}$ | $\lvert ab\rvert\lt\dfrac{100}{3}$ |

**两者都收敛 $\iff\lvert ab\rvert\lt100/3$**，且总有 $\rho(G_{GS})=\rho(G_J)^{2}$（在这道题里恰好是精确的平方关系）。

数值检验（脚本算全谱，六个参数点）：

| $(a,b)$ | $\rho(G_J)$ | $\rho(G_{GS})$ | 判定 |
|:--:|:--:|:--:|:--|
| $(1,1)$ | $0.1732$ | $0.0300$ | 都收敛 |
| $(3,8)$ | $0.8485$ | $0.7200$ | 都收敛（贴边） |
| $(5,5)$ | $0.8660$ | $0.7500$ | 都收敛（贴边） |
| $(-2,-2)$ | $0.3464$ | $0.1200$ | 都收敛 |
| $(-10,-8)$ | $1.5492$ | $2.4000$ | 都发散 |
| $(2,-3)$ | $0.4243$ | $0.1800$ | 都收敛 |

本题的特殊零元结构使 $\rho(G_{GS})=\rho(G_J)^2$，因此两种方法必然同时满足或不满足谱半径收敛条件。一般矩阵没有这个关系，应分别检查。

**易错点**：
1. $G_{GS}$ 的第一列算错（把 $ab/100$ 放到第 1 列的 $(2,1)$ 位置）——记住 $U$ 的第一列全零，$G_{GS}$ 的第一列必然全零，可用来自检；
2. 只写「$\lvert ab\rvert\lt100/3$」不写推导，或对 $\lambda=0$ 不置一词；
3. 忘记 $A$ 非奇异这一前提（$a=b=0$ 时 $A$ 对角，迭代一步收敛，结论仍成立；但若 $A$ 奇异，题目本身无意义）。

:::

::: note 作业组与正文的对应 {#hw-2-cover}

| 题目 | 落在正文哪一节 | 一句话考点 |
|:--|:--|:--|
| 2-1 | [2.1.1 定理 2.1](sec21.md#thm-2.1) | 主元素 = 顺序主子式之比（$A=LU$ + 分块行列式） |
| 2-2 | [2.1.2 列主元](sec21.md#sec-2.1.2) | 小主元 ⟹ 大乘数 ⟹ 灾难；与条件数无关 |
| 2-3 | [1.3.3 矩阵范数](../../ch01/sec13.md#sec-1.3.3) | 矩阵范数 ⟹ 造出相容的向量范数 |
| 2-4 | [2.2.1 Doolittle](sec22.md#sec-2.2.1) | 前代 + 回代，$l_{32}$ 的符号 |
| 2-5 | [2.4.1 定理 2.9](sec24.md#sec-2.4.1) | 迭代矩阵特征值 $1-\omega\mu_i$，$\omega$ 的上界 |
| 2-6 | [2.4.2–2.4.4](sec24b.md#sec-2.4.2) | $\rho(G_{GS})=\rho(G_J)^2$ 的特殊结构 |

:::


## 练习顺序 {#hw-2-progress}

先完成消元和 LU 的计算题，再用条件数解释残差，最后做迭代收敛性练习。
