# 第 2 章习题（教材 1–24）

> 题面数据以颜庆津《数值分析》（第 4 版）第 2 章习题（p.45–47）为准；本表给**题面摘要、答案/提示、正文落点**，保证 24 题不漏。
> 标记：✅ 已给答案/提示；逐题数值可按教材数据复算。

| 题 | 主题 | 题面摘要 | 答案 / 提示 |
|:--:|:--|:--|:--|
| <span id="ex-2-1">1</span> | 三位十进制：顺序 Gauss vs 列主元 | 解一个 3×3 方程组，精确解 $(-2.6,1,2)^{\mathrm T}$ | ✅ 顺序消去在小主元处失稳；列主元结果接近精确解。见 [2.1](sec21.md#sec-2.1-exercises)。 |
| <span id="ex-2-2">2</span> | 消元矩阵 $R$ | 写出 $k=1$ 消元对应的左乘矩阵 | ✅ $R=I-\sum_{i=2}^n m_{i1}e_ie_1^{\mathrm T}$，单位下三角。 |
| <span id="ex-2-3">3</span> | 行交换矩阵 $Q_k$ | 交换第 $k$ 行与第 $i_k$ 行 | ✅ 置换矩阵；$Q_k^{-1}=Q_k^{\mathrm T}=Q_k$。 |
| <span id="ex-2-4">4</span> | Doolittle 运算量 | 统计乘除法次数 | ✅ 约 $n^3/3+n^2$；主导项 $n^3/3$。 |
| <span id="ex-2-5">5</span> | 不选主元 Doolittle | 解教材给出的 3×3 方程组 | ✅ 解 $\approx(0.9314,-0.3885,-1.0244)^{\mathrm T}$；分解可进行，无需换行。 |
| <span id="ex-2-6">6</span> | 选主元 Doolittle | 解教材给出的 4×4 方程组 | ✅ 选主元后 $x=(-18.3875,-5.8125,-15.4625,35.9375)^{\mathrm T}$；置换后 $LU$ 的 $U$ 对角为 $10,7.5,5,-3.84$。 |
| <span id="ex-2-7">7</span> | 带状存储计算 $Ax$ | 带内元素存于 $(r+s+1)\times n$ 矩阵 $C$ | ✅ $u_i=\sum_{j=\max(1,i-r)}^{\min(n,i+s)}C_{r+1+i-j,j}y_j$。 |
| <span id="ex-2-8">8</span> | 追赶法 | 解五元三对角方程组，精确解 $(0.21,-0.52,1.2,0.82,-0.64)^{\mathrm T}$ | ✅ 追/赶公式；$O(n)$。见 [2.2.4](sec22.md#sec-2.2.4)。 |
| <span id="ex-2-9">9</span> | 八位十进制列主元 + 条件数 | 解 2×2 方程组并求行范数条件数 | ✅ $x\approx(2,-2)^{\mathrm T}$，$\mathrm{cond}_\infty(A)\approx3.27\times10^8$；条件数极大，八位十进制下解仍可能严重失真。 |
| <span id="ex-2-10">10</span> | 正交矩阵条件数 | 证明 $\mathrm{cond}_2(A)=1$ | ✅ $\sigma_i=1$，故比值 1。 |
| <span id="ex-2-11">11</span> | 残差与误差界 | 证明 $\frac{\lVert x^*-\tilde x\rVert}{\lVert x^*\rVert}\le\mathrm{cond}(A)\frac{\lVert r\rVert}{\lVert b\rVert}$ | ✅ $x^*-\tilde x=A^{-1}r$，取范数并用 $\lVert b\rVert\le\lVert A\rVert\lVert x^*\rVert$。 |
| <span id="ex-2-12">12</span> | 条件数 / 残差反例 | 两个近似解的残差与误差对比 | ✅ $\mathrm{cond}_\infty(A)\approx3.96\times10^4$；$\tilde x=(1,0)$ 残差 $(0,0.01)$，$\tilde x=(100.5,-99.5)$ 残差 $(-0.995,-0.985)$——前者残差小但误差巨大，后者残差大但更接近真解。 |
| <span id="ex-2-13">13</span> | 迭代序列收敛判断 | 两个迭代公式，初值任取 | ✅ (1) $\rho(G)=5$，发散；(2) $\rho(G)\approx0.8358\lt1$，收敛。 |
| <span id="ex-2-14">14</span> | 迭代公式必收敛 | 证明收敛并指出对应方程组 | ✅ $\rho(G)\approx0.6236\lt1$（虽然 $\lVert G\rVert_\infty=1.55$）；极限满足 $(I-G)x=d$，即对应方程组 $x=Gx+d$。 |
| <span id="ex-2-15">15</span> | Jacobi 解方程组 | 3×3 方程组，相邻差 $\le10^{-4}$ | ✅ $x\approx(-3.0909,1.0946,1.2655)^{\mathrm T}$；$\rho(G_J)\approx0.5877\lt1$，20 次迭代达到 $10^{-4}$。 |
| <span id="ex-2-16">16</span> | Jacobi 收敛性讨论 | 四个 3×3 矩阵 | ✅ (1) $\rho_J\approx1.118$ 发散；(2) $\rho_J\approx1.2\times10^{-5}$ 收敛；(3) $\rho_J\approx1.2\times10^{-5}$ 收敛；(4) $\rho_J\approx1.118$ 发散。 |
| <span id="ex-2-17">17</span> | GS 解第 15 题 | 同上，用 GS | ✅ $x\approx(-3.0909,1.0945,1.2655)^{\mathrm T}$；$\rho(G_{GS})=0.2$，9 次迭代达到 $10^{-4}$（Jacobi 20 次）。 |
| <span id="ex-2-18">18</span> | GS 收敛性讨论 | 第 16 题四个矩阵 | ✅ (1) $\rho_{GS}=0.5$ 收敛；(2) $\rho_{GS}=2$ 发散；(3) $\rho_{GS}\approx4.828$ 发散；(4) $\rho_{GS}\approx1.651$ 发散——(1)(2)(3) 正是“Jacobi 与 GS 一收一散”的例子。 |
| <span id="ex-2-19">19</span> | 构造必收敛迭代 | 为给定方程组设计迭代 | ✅ 把方程重排为 $[10,-2,0;2,10,-1;1,2,-5]$，严格对角占优；用 Jacobi/GS 必收敛，解 $\approx(0.5502,1.2510,-1.3896)^{\mathrm T}$。 |
| <span id="ex-2-20">20</span> | 2×2 的 Jacobi/GS | 证明同时收敛/发散 | ✅ $\rho(G_{GS})=\rho(G_J)^2$。 |
| <span id="ex-2-21">21</span> | 含参数 $a$ 的收敛范围 | $A$ 对角 1、非对角 $a$ | ✅ Jacobi：$\rho(G_J)=2|a|$，故 $|a|\lt1/2$；GS：$\rho(G_{GS})\lt1$ 当且仅当 $-1/2\lt a\lt1$（端点 $\rho=1$，不保证）。 |
| <span id="ex-2-22">22</span> | 直接判定 GS | 给定矩阵，证明 GS 必收敛 | ✅ $A$ 对称，特征值 $\approx0.0885,1.8705,6.0410$ 全正，故对称正定；由定理 2.16，GS 收敛（$\rho(G_{GS})=0.9$）。 |
| <span id="ex-2-23">23</span> | SOR（$\omega=0.9$） | 解方程组，相邻差 $\le10^{-5}$ | ✅ $A$ 严格对角占优，$\omega=0.9\le1$，定理 2.20 保证收敛；10 次迭代得 $(-4,3,2)^{\mathrm T}$。 |
| <span id="ex-2-24">24</span> | SOR（$\omega=1.25$） | 解方程组，相邻差 $\le10^{-5}$ | ✅ $A$ 对称正定（特征值 $1,1,10$），$\omega=1.25\in(0,2)$，Ostrowski 保证收敛；20 次迭代得 $(0.5,1,1)^{\mathrm T}$。 |

## 课堂补充题

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

## 作业组 · 老师布置的 SPOC 自测题（第二章 线性方程组的解法）

::: note 这份作业的来路与交法 {#hw-2-meta}

作业名称「线性方程组的解法」，发布在北航 SPOC《数值分析 I》课程 → 作业测试，附件 `数值分析单元自测题2.pdf`（原件本地归档于 `_sources/homework/`，该目录入库规则为忽略）。
满分 10 分，接收班级 2026-2027-1-GA01011002-学院路 1 班；起止时间 2026-10-04 00:00 至 2026-10-11 00:00（已截止）。
六道题覆盖本章四条主线：**主元素与顺序主子式（题 1）→ 小主元的灾难（题 2）→ 由矩阵范数造向量范数（题 3）→ LU 求解（题 4）→ 迭代格式的收敛半径（题 5）→ Jacobi 与 GS 的充要条件（题 6）**。所有数值已用四位十进制／分数精确算术复算，可逐位核对。

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

**老师在第 3–4 讲强调过的两点，正好是这道题的注解**：

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

**结果 $\boldsymbol x=(-0.4370,\,-0.08186,\,0.3882)^{\mathrm T}$，三位分量都达到 3–4 位有效数字。**

### 三、分析（这一节才是得分点）

| 项目 | 顺序消去 | 列主元 |
|:--|:--|:--|
| 乘数 | $-1000$、$-2000$ | $0.5$、$-0.0005$ |
| 消元后主元 | $2004$、$5.000$ | $3.158$、$1.765$ |
| 解 | $(0.000,-0.0998,0.4000)^{\mathrm T}$ | $(-0.4370,-0.08186,0.3882)^{\mathrm T}$ |
| $x_1$ 相对误差 | $100\%$ | $0.13\%$ |

三条结论：

1. **病根是小主元**。$a_{11}=0.001$ 使 $m_{21}=-1000$：消元时把行 1 放大约 1000 倍再加到行 2 上，行 2 的原始信息（只有 4 位有效数字）被彻底淹没。这一步之后，"行 2 的 $a_{22}$" 其实是 $1000\times2.000$ 舍入后的残余，与原矩阵几乎无关。
2. **问题本身不病态**。$\mathrm{cond}_\infty(A)=21.76$ 意味着「输入 4 位、输出至少 3 位」本是可保证的。顺序消去丢掉的位数**全部是算法自己造的**——这正好呼应第 3 讲老师那句「列主元不改变条件数，只改变算法对误差的放大」。
3. **列主元的机制是「让乘数不超过 1」**。$|m_{ik}|\le1$ 保证消元时不会把某一行放大，误差不被额外放大；这是[2.1.2 列主元](sec21.md#sec-2.1.2) 的结论，本题是它的数值证据。

**思考题（老师课上的追问）**：如果把第一行乘 $1000$ 变成整行放大（即把三个方程都除以 $0.001$），再用顺序消去，结果会好吗？——会。放大行只是等价变换，$a_{11}$ 变成 $1$、乘数变成 $O(1)$，误差不再爆炸。这说明**「小主元」的危害不在数值小，而在于它让乘数大**。

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

**加分的一步（老师通常会给分）**：这个向量范数与 $\lVert\cdot\rVert$ **相容**。因为

$$\lVert A\boldsymbol x\rVert=\lVert A\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert=\lVert A(\boldsymbol x\boldsymbol e_i^{\mathrm T})\rVert\le\lVert A\rVert\,\lVert\boldsymbol x\boldsymbol e_i^{\mathrm T}\rVert=\lVert A\rVert\,\lVert\boldsymbol x\rVert .$$

这条结论正是[1.3.3](../../ch01/sec13.md#sec-1.3.3) 讲的「**任何一个矩阵范数都存在与它相容的向量范数**」的构造性证明，而教材习题 15（[B4](../../ch01/exercises.md#sec-练习-b)）用的是另一个构造 $\lVert\boldsymbol x\rVert_*=N(\boldsymbol x\boldsymbol b^{\mathrm T})$。两个构造思路完全一致：**把向量「做成」矩阵，再用矩阵范数度量**。

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
3. 分解与右端无关：若还有另一组右端 $\boldsymbol b'$，只需再做一次前代+回代，$O(n^2)$ 而不是 $O(n^3)$——这就是老师说的「一次分解、反复使用」。

:::

::: ex 作业 2-5 · Richardson 型迭代的收敛半径 {#hw-2-5}

**（第二章自测题 5）** 设有线性方程组 $A\boldsymbol x=\boldsymbol b$，$A$ 非奇异。证明对任意的 $\omega\in\bigl(0,\,2\rho^{-2}(A)\bigr)$，迭代格式

$$\boldsymbol x^{(k+1)}=\boldsymbol x^{(k)}+\omega\bigl(A^{\mathrm T}\boldsymbol b-A^{\mathrm T}A\boldsymbol x^{(k)}\bigr)$$

收敛，且极限是 $A\boldsymbol x=\boldsymbol b$ 的解。

:::

::: sol 精讲 {#sol-hw-2-5}

**第一步：写成标准迭代形式 $\boldsymbol x^{(k+1)}=G\boldsymbol x^{(k)}+\boldsymbol d$。**

$$\boldsymbol x^{(k+1)}=\underbrace{(I-\omega A^{\mathrm T}A)}_{G}\boldsymbol x^{(k)}+\underbrace{\omega A^{\mathrm T}\boldsymbol b}_{\boldsymbol d}.$$

**第二步：认清 $A^{\mathrm T}A$ 的谱。** $A$ 非奇异 ⟹ 对任意 $\boldsymbol v\neq\boldsymbol 0$，$\boldsymbol v^{\mathrm T}A^{\mathrm T}A\boldsymbol v=\lVert A\boldsymbol v\rVert_2^2\gt0$，故 $A^{\mathrm T}A$ **对称正定**，其特征值 $\mu_1\ge\cdots\ge\mu_n\gt0$，且 $\mu_{\max}=\lVert A\rVert_2^{2}=\rho(A)^{2}$（题目把 $\rho(A)$ 用作 $A$ 的谱范数，即 $\rho(A)=\lVert A\rVert_2=\sqrt{\mu_{\max}}$；这是本题记号的关键，务必看清）。

**第三步：$G$ 的特征值。** $A^{\mathrm T}A$ 对称，存在正交阵 $Q$ 使其对角化：$Q^{\mathrm T}A^{\mathrm T}AQ=\operatorname{diag}(\mu_1,\dots,\mu_n)$。于是

$$Q^{\mathrm T}GQ=Q^{\mathrm T}(I-\omega A^{\mathrm T}A)Q=\operatorname{diag}(1-\omega\mu_1,\dots,1-\omega\mu_n),$$

即 $G$ 的特征值是 $\lambda_i=1-\omega\mu_i$。

**第四步：把「$\rho(G)\lt1$」翻译成对 $\omega$ 的条件。**

$$\lvert 1-\omega\mu_i\rvert\lt1\iff -1\lt1-\omega\mu_i\lt1\iff 0\lt\omega\mu_i\lt2\iff \omega\lt\frac{2}{\mu_i}.$$

要对**所有** $i$ 成立，只需对最大的 $\mu_{\max}$ 成立：

$$\omega\lt\frac{2}{\mu_{\max}}=\frac{2}{\lVert A\rVert_2^{2}}=\frac{2}{\rho^{2}(A)} .$$

又 $\omega\gt0$ 时上式自动给出 $\omega\mu_i\gt0$，故**充要条件**是 $\omega\in\bigl(0,2\rho^{-2}(A)\bigr)$。由[定理 2.9](sec24.md#sec-2.4.1)（$\rho(G)\lt1$ ⟺ 对任意初值收敛），迭代对任意 $\boldsymbol x^{(0)}$ 收敛。

**第五步：极限就是解。** 设 $\boldsymbol x^{(k)}\to\boldsymbol x^{*}$，在迭代式两边取极限：

$$\boldsymbol x^{*}=\boldsymbol x^{*}+\omega\bigl(A^{\mathrm T}\boldsymbol b-A^{\mathrm T}A\boldsymbol x^{*}\bigr)
\ \Longrightarrow\ A^{\mathrm T}A\boldsymbol x^{*}=A^{\mathrm T}\boldsymbol b
\ \Longrightarrow\ A^{\mathrm T}(A\boldsymbol x^{*}-\boldsymbol b)=\boldsymbol 0 .$$

左乘 $(A\boldsymbol x^{*}-\boldsymbol b)^{\mathrm T}$ 得 $\lVert A\boldsymbol x^{*}-\boldsymbol b\rVert_2^2=0$，即 $A\boldsymbol x^{*}=\boldsymbol b$。$\blacksquare$

**补一句为什么它一定收敛到解而不是「最小二乘解」**：上式只给出 $A\boldsymbol x^{*}$ 在 $A$ 的零空间上的投影为零，一般情况下这不足以断言 $A\boldsymbol x^{*}=\boldsymbol b$（那正是最小二乘的正规方程）。本题之所以能推出等号，是因为**第五步用的是左乘 $(A\boldsymbol x^{*}-\boldsymbol b)^{\mathrm T}$ 而非任意左乘**——它把残差自身的 2-范数压成 0。若 $A$ 奇异，$A^{\mathrm T}A$ 只是半正定、$\mu_{\min}=0$，$\omega$ 的条件失效，迭代极限一般只是最小二乘解。

**三个易错点**：
1. 把 $\rho(A)$ 当成「$A$ 的谱半径」——若是谱半径，$2\rho^{-2}(A)$ 与 $\lVert A\rVert_2$ 无关，结论就不成立了。本题记号按谱范数理解（等价地：条件是 $\omega\lt2/\mu_{\max}(A^{\mathrm T}A)$）。
2. 只证「充分」不证「必要」——题目要求 $\omega$ 的**整个区间**，端点 $\omega=2/\mu_{\max}$ 处 $\lambda_{\max}=-1$、$\rho(G)=1$，迭代不收敛（振荡不衰减），必须点出来。
3. 忘记验证 $A^{\mathrm T}A$ 正定就直接说「特征值都正」——非奇异是关键前提。

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

行列式为零 ⟹ $M$ 是**秩 1** 矩阵，两个特征值为 $0$ 与 $\operatorname{tr}M=\dfrac{3ab}{100}$。于是

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

**这道题为什么值得考**：一般情形下 Jacobi 与 GS 没有「谁更好」的定论（[第 5 讲 §七](../../lectures/lec05.md#lec05-S7) 明确讲了「一个收敛一个发散」的例子，如教材习题 16/18 的矩阵 (1)）。而本题的结构（第一列、第一行的位置特殊）使得 $\rho_{GS}=\rho_J^{2}$，于是「同时收敛」成为必然。**会算 $\rho$ 只是及格，看出「$\rho_{GS}$ 与 $\rho_J$ 的关系」才是满分**。

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

## 按正文进度练（作业与教材习题的插入点）

::: method[core] 读完哪一节，就做哪几题 {#hw-2-progress}

| 读完 | 立刻做（10–15 分钟） | 再做（30–60 分钟） | 为什么放在这里 |
|:--|:--|:--|:--|
| [2.1.1 高斯消去](sec21.md#sec-2.1.1) | 教材习题 [1](exercises.md#ex-2-1)、[2](exercises.md#ex-2-2)、[3](exercises.md#ex-2-3) | **作业 2-1**（主元素 = 主子式之比） | 作业 2-1 的证明要用 $A=LU$，而 $LU$ 的合法性正是「主元非零 ⟺ 主子式非零」，学完消元立刻做最顺 |
| [2.1.2 列主元](sec21.md#sec-2.1.2) | **作业 2-2** 的「顺序消去」一半（自己算到 $x_1=0$） | **作业 2-2** 完整（列主元 + 分析）· 教材习题 [9](exercises.md#ex-2-9) | 亲手算出 $x_1=0$ 的震惊感，比读十遍「列主元必要」有用；习题 9 是八位十进制的同型题 |
| [2.2 直接三角分解](sec22.md#sec-2.2.1) | 教材习题 [4](exercises.md#ex-2-4)、[8](exercises.md#ex-2-8)（追赶法） | **作业 2-4**（LU 求解）· 教材习题 [5](exercises.md#ex-2-5)、[6](exercises.md#ex-2-6) | 作业 2-4 是 Doolittle 的最短完整流程，先做它再碰选主元的习题 6 |
| [2.3 条件数与病态](sec23.md#sec-2.3.1) | 教材习题 [10](exercises.md#ex-2-10)、[11](exercises.md#ex-2-11) | 教材习题 [12](exercises.md#ex-2-12)（残差小误差大） | 做完作业 2-2 再看条件数，才能分清「问题病态」与「算法不稳」 |
| [2.4.1 迭代法引论](sec24.md#sec-2.4.1) | 教材习题 [13](exercises.md#ex-2-13)、[14](exercises.md#ex-2-14) | **作业 2-5**（Richardson 的 $\omega$ 区间） | 作业 2-5 是「$\rho(G)\lt1$」的第一次非平凡应用：$G$ 的特征值要自己算出来 |
| [2.4.2–2.4.4 Jacobi/GS/SOR](sec24b.md#sec-2.4.2) | 教材习题 [15](exercises.md#ex-2-15)、[17](exercises.md#ex-2-17) | **作业 2-6**（$\lvert ab\rvert\lt100/3$）· 教材习题 [16](exercises.md#ex-2-16)、[18](exercises.md#ex-2-18) | 习题 16/18 是「一个收敛一个发散」的反例，作业 2-6 是「必然同时收敛」的正例——正反并做才算懂 |

**两条铁律**：

1. **作业 2-2 必须亲手算完，不许看答案**。这道题的全部价值在「$x_1$ 变成 0」那一刻的体感；看了答案就永远学不会。
2. **作业 2-6 与教材习题 16/18 对着做**。前者告诉你「有时两者同时收敛」，后者告诉你「有时一收一散」——只记其中一半，考场上遇到另一半就废。

:::

::: note 覆盖核对
本页覆盖教材习题 1–24（题面摘要 + 答案/提示）、两道课堂补充题，以及**老师布置的 SPOC 自测题六道（完整精讲）**；逐题数值可按教材数据复算。覆盖矩阵见[第 2 章覆盖矩阵](coverage.md)。
:::
