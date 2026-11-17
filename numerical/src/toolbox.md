# 工程工具箱：误差诊断 · 算法选型 · 停止准则 · 函数地图

正文回答「为什么」，这一页回答「**动手时先看哪一页、用哪个函数**」。它是一张**索引**：拿到一个具体症状，先在本页定位到该算哪个量、该调哪个函数，再回正文读推导。本页不重述正文内容，也不重复复习层的公式卡与对照卡。

第一次把公式写成程序，请先做[算法实作课](training/algorithm-workshop.md)：逐项确认输入、更新顺序、停止证据和失败处理，再回来选择函数。

::: method 三条使用原则（先记住，再看下文）
1. **先诊断，再换算法。** 病态是问题的属性、不稳定是算法的属性（[1.2.6](ch01/sec12.md#sec-1.2.6)）；判错方向，后面的努力全花在错误的地方。
2. **先估量级，再对账。** 任何数值结论都先写一个理论量级——$\mathrm{cond}\cdot u$、$\sigma_{k+1}$、$(\lambda_2/\lambda_1)^k$——再用实测对账；[2.7](supplement/sec27.md) 的「报告要求」就是这个流程。
3. **先验收，再交付。** 算完必须过一遍[第六节](#sec-工具箱-6)的验收清单；没有验收的数值结果，只是打印出来的一堆数。
:::

::: note 七页各管一件事（不要互相替代）

| 页 | 管什么 | 什么时候用 |
|:--|:--|:--|
| [先修与自测](prerequisite.md) | **基础层**：线代 / 微积分 / 编程 / 记号的清单与自测 | 开学前、数学卡壳时 |
| **本页** | **操作层**：诊断 → 选型 → 停止准则 → 函数与后端 | 每一段数值代码落地时 |
| [公式与结论卡](review/formula-cards.md) | **查阅层**：全书必记公式与结论 | 忘了公式 |
| [易混对照卡](review/contrast-cards.md) | **辨析层**：概念比较与课堂术语对照 | 判断题、概念题 |
| [术语索引](review/glossary.md) | **命名层**：中英术语与定义位置 | 查名字 |
| [附录 B](appendix/float.md) | **深挖层**：浮点算术的完整推导 | 想看清 $\mathrm{eps}$、Kahan、求和界是怎么来的 |
| [必考点竞技场](training/arena.md) | **输出层**：限时答题、错题本 | 考前限时训练 |
:::

### 一、误差诊断：四个量、一张判据表 {#sec-工具箱-1}

本节以非奇异方阵 $A\boldsymbol x=\boldsymbol b$ 为例，$\boldsymbol x$ 为真解，$\hat{\boldsymbol x}$ 为计算解，$\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$；公式中的矩阵范数与向量范数须匹配。最小二乘一般有不可消除的残差，不能原样套用这里的方程组误差界。

| 量 | 怎么算 | 它回答什么 | 常见误用 |
|:--|:--|:--|:--|
| **残差** $\boldsymbol r=\boldsymbol b-A\hat{\boldsymbol x}$ | `r = b - A @ xhat` | 方程被满足到什么程度（可算，计算残差本身也有舍入） | 拿它当误差用（[例 2.4.4](supplement/sec24.md#sup-2.4.4)：残差 $2.5\times10^{-12}$、误差 $50\%$） |
| **后向误差**（向后误差） | 范数型指标 $\eta=\dfrac{\lVert\boldsymbol r\rVert}{\lVert A\rVert\lVert\hat{\boldsymbol x}\rVert+\lVert\boldsymbol b\rVert}$，分母非零 | 衡量让计算解成为精确解所需的相对数据扰动 | 把它当解的前向精度报告；误差含义取决于允许怎样扰动输入 |
| **条件数** $\mathrm{cond}(A)$ | `np.linalg.cond(A, 2)`（内部走 SVD） | 问题天生的放大倍数 / 要丢几位 | 不注明范数就互相比较（[2.4.6](supplement/sec24.md#sup-2.4.6)） |
| **误差** $\boldsymbol e=\boldsymbol x-\hat{\boldsymbol x}$ | 真解未知时一般算不出 | 解离真值多远 | 用相邻两次迭代之差冒充它 |

**核心判据：** 当 $\boldsymbol b\ne0$ 时，$\dfrac{\lVert\boldsymbol e\rVert}{\lVert\boldsymbol x\rVert}\le\mathrm{cond}(A)\dfrac{\lVert\boldsymbol r\rVert}{\lVert\boldsymbol b\rVert}$（[@thm-sup-2.4.4]）。向后稳定保证的是某个明确扰动模型下的归一化后向误差小，不是未缩放残差必小，更不是前向误差必小。$k\approx\log_{10}\mathrm{cond}(A)$ 仅是稳定计算与给定输入精度下的最坏情形数字损失量级（[2.4.2](supplement/sec24.md#sup-2.4.2)）。

**小后向误差可与大前向误差并存**（以下为原实验记录：同一批 Hilbert 矩阵，`np.linalg.solve` 求解、合成真解全为 $1$）：

| $n$ | $\mathrm{cond}_2$ | 后向误差 $\eta$ | 相对残差 | 前向误差（最大分量） |
|:--:|:--:|:--:|:--:|:--:|
| 8 | $1.53\times10^{10}$ | $4.6\times10^{-17}$ | $1.0\times10^{-16}$ | $1.2\times10^{-7}$ |
| 12 | $1.66\times10^{16}$ | $1.9\times10^{-17}$ | $4.3\times10^{-17}$ | $5.2\times10^{-1}$ |

读法：两个算例的后向误差都在 $u\approx1.1\times10^{-16}$ 量级或更小，前向误差却相差约 6 个数量级；这说明小后向误差不能消除病态问题的敏感性。两个算例也不能单独证明求解器对所有输入都向后稳定；表中末位及具体误差可随平台改变（[1.2.6](ch01/sec12.md#sec-1.2.6)）。

**症状 → 先算哪个量 → 判据 → 处方：**

| 症状 | 先算 | 判据 | 处方 |
|:--|:--|:--|:--|
| 残差很小，结果仍可疑 | $\mathrm{cond}(A)$ 与 $\mathrm{cond}(A)\lVert\boldsymbol r\rVert/\lVert\boldsymbol b\rVert$ | 上界未达到期望容差，不代表实际误差必大 | 检查后向误差；不稳定时换算法，已稳定但敏感时考虑精化、提高精度或有依据的正则化 |
| 解的系数量级离谱（如预期 $O(1)$ 却得到 $O(10^5)$） | 奇异值谱、尺度与残差 | 曾形成 $A^{\mathrm T}A$ 时检查条件数平方风险 | 先用 QR / SVD 对照，区分数据不支持模型与算法误差，再决定是否正则化（[习题 D1](supplement/exercises.md)） |
| 换一种解法结果差很多 | 条件数、各自的后向误差与残差 | 差异可能来自病态，也可能来自实现、阈值或模型不同 | 先核对同一任务和停止条件；确认算法已稳定后，再处理问题敏感性 |
| 行量级悬殊（如相差 $10^{10}$） | $\mathrm{cond}_\infty$ 前后对比 | 行均衡化后条件数骤降 | 先均衡化再评估（[例 2.4.5](supplement/sec24.md#sup-2.4.5)：$2\times10^{20}\to4\times10^{10}$） |
| 数值秩每次统计都不一样 | 奇异值谱 + 噪声水平 | $\sigma_k$ 与噪声同量级 | 按噪声水平定阈值，不照抄库的默认值 |

**如何复算这些锚点：** 构造 $H_{ij}=1/(i+j+1)$（代码下标 $i,j=0,\dots,n-1$），取 `x_true = np.ones(n)`、`b = H @ x_true`，分别计算 `cond(H, 2)`、`solve(H, b)` 的残差、后向误差及最大分量误差。表中 8 阶误差约 $1.2\times10^{-7}$、12 阶约 $0.52$ 是原平台记录，不是跨平台标准答案；后者说明求解器未报错也可能远未达到所需精度。合成右端本身的舍入也属于实验误差来源。

### 二、算法选择树：解方程组与特征值 {#sec-工具箱-2}

**解 $A\boldsymbol{x}=\boldsymbol{b}$（方阵）**

| 情形 | 首选 | 函数 | 复杂度 | 为什么 |
|:--|:--|:--|:--|:--|
| 稠密、一般 | LU + 列主元 | `np.linalg.solve`；多个右端用 `scipy.linalg.lu_factor` + `lu_solve` | $\frac23n^{3}$ | 列主元把乘数控制在 $1$ 以内（[第 3 讲](lectures/lec03.md)） |
| 稠密、**对称正定** | Cholesky | `scipy.linalg.cholesky` / `cho_factor` + `cho_solve` | $\frac13n^{3}$ | 省一半工作，且不需要选主元 |
| 稠密、对称不定 | 带主元 LDL（Bunch–Kaufman 型） | `scipy.linalg.ldl` | $\frac13n^{3}$ 量级 | 利用对称性；对角因子可能包含 $1\times1$ 与 $2\times2$ 主元块 |
| 三对角 / 固定带宽 | 追赶法 / 带状求解 | `scipy.linalg.solve_banded` | 三对角或固定带宽为 $O(n)$；一般还依赖上下带宽 | 无主元追赶法须确认主元非零；通用带状库不等于无主元追赶法 |
| 稀疏（$n$ 大、非零少） | 稀疏 LU 或迭代法 | `splu` / `spsolve`；`cg`（对称正定）、`gmres`（一般）均在 `scipy.sparse.linalg` | 依赖非零元、填充、迭代次数与预条件 | 不能仅由原始 nnz 判断总成本 |
| 病态，精度风险量 $\mathrm{cond}(A)u$ 偏大 | 先核对算法后向误差，再评估数据与目标精度 | 见上一节处方列 | — | 稳定算法也无法普遍消除输入扰动的放大，固定 $10^8$ 不是所有任务的分界线 |

**判定顺序（照这个顺序问四个问题）：** ① 矩阵对称吗？正定吗？→ 决定能否用 Cholesky / LDL。② 稀疏吗（判据见第四节的经验法则）？→ 决定稠密库还是 `scipy.sparse`。③ 条件数量级多大？→ 决定要不要换路线（QR / SVD / 正则化 / 提高精度）。④ 同一个 $A$ 要解多少个右端？→ 多个右端先分解一次（`lu_factor` / `cho_factor`），再反复 `*_solve`。

**超定最小二乘 $A\boldsymbol{x}\approx\boldsymbol{b}$（$m\gt n$）**

| 情形 | 首选 | 函数 | 关键量级 |
|:--|:--|:--|:--|
| 列满秩、一般稠密拟合 | Householder QR 或 SVD 型库求解 | 显式 `np.linalg.qr` + 回代；`np.linalg.lstsq` 为 SVD 型路线，并不等于 QR 接口 | QR 避免正规方程的条件数平方；前向误差还受残差与敏感性影响 |
| 列满秩但接近数值秩亏 | SVD，结合奇异值谱与容差判断是否截断 | `np.linalg.lstsq(..., rcond=...)` 或显式 `svd` | 不是条件数超过 $10^8$ 就必须截断，截断会改变任务 |
| 秩亏 / 有噪数据需正则化 | 最小范数解或有依据的截断伪逆 | `np.linalg.pinv(A, rcond=...)`、`lstsq(..., rcond=...)` | 阈值按舍入、噪声及目标精度选择并报告 |
| 正规方程 $A^{\mathrm T}A\boldsymbol x=A^{\mathrm T}\boldsymbol b$ | 可用于手算与推导，良态且成本敏感时也须评估舍入风险 | — | 精确算术下等价；2-范数条件数平方，可较便宜但可能损失精度（[2.3.6](supplement/sec23.md#sup-2.3.6)） |

**特征值与奇异值问题**

| 要求 | 首选 | 函数 | 说明 |
|:--|:--|:--|:--|
| 稠密、一般矩阵、全部特征值 | QR 算法（先化 Hessenberg 再迭代） | `scipy.linalg.eig` | 特征值可为复数，注意返回类型 |
| 稠密、**对称**矩阵、全部特征值 | 对称 QR / 分治 | `scipy.linalg.eigh` | 特征值必为实数、特征向量正交，比 `eig` 又快又稳 |
| 只要按模严格最大的特征值、矩阵–向量乘便宜 | 幂法 + Rayleigh 商 | 手写循环（[算法 2.5.1](supplement/sec25.md#sup-2.5.3)） | 可对角化且初值主分量非零时，方向比由 $\lvert\lambda_2/\lambda_1\rvert$ 控制；Rayleigh 商的二阶方向精度限于实对称等适当结构 |
| 大规模稀疏、要最大的几个（对称） | Lanczos | `scipy.sparse.linalg.eigsh` | 只做矩阵–向量乘，$O(\mathrm{nnz})$ 每步 |
| 大规模稀疏、**非对称** | **Arnoldi** | `scipy.sparse.linalg.eigs` | 需要多大的 $k$、`ncv` 取多少，见函数文档 |
| 全部特征值、还想看中间过程 | QR 迭代 | 手写（[2.3 预告](supplement/sec23.md#sup-2.3.7)） | 正交相似保持谱但不保证基本迭代收敛；成功分离后读一阶块及可能的二阶块，不能对一般实矩阵只读对角元 |
| 只想知道特征值被包含在哪里 | Gerschgorin 圆盘 | 扫描矩阵（[2.5.2](supplement/sec25.md#sup-2.5.2)） | 稠密扫描 $O(n^2)$；小半径且隔离的圆盘才给出有用的定位，严格对角占优本身不保证相对精确近似 |
| 稀疏 / 只要前几个最大奇异值 | 迭代 SVD | `scipy.sparse.linalg.svds` | 稠密的完整 SVD 用 `np.linalg.svd` |

### 三、收敛判定与停止准则 {#sec-工具箱-3}

**停止设计包括三部分：** ① 选可计算且与任务相符的指标，例如 $\|r_k\|\le\mathrm{atol}+\mathrm{rtol}\|b\|$，避免零右端导致除零；② 设置迭代预算，并区分达标与预算耗尽；③ 检查非有限值和停滞。增量小不能替代残差或误差界，真解未知时不能用真误差作为实际停止判据。

::: think 一个高频误解：相邻两次迭代值差很小，就认为接近真解
不成立。即使收敛，传播因子接近 $1$ 时，相邻差仍可以很小而离真解很远；须有已知收缩因子等条件，才能把相邻差转成后验误差界，见 [2.4 正文](course/ch02/sec24.md)。[第 5 讲整理稿](lectures/lec05.md)也记录了这一主题，但原录音待核，不据整理措辞作逐字引语。线性定常迭代对所有初值收敛的充要条件是 $\rho(G)<1$；匹配从属范数下 $\|G\|<1$ 是易用的充分条件，且能给逐步收缩保证。
:::

**实测收敛阶怎么估。** 先固定误差度量并取非零误差大小 $e_k>0$。当 $e_{k+1}\sim C e_k^p$ 且进入渐近区时，可用

$$p\approx\frac{\ln(e_{k+1}/e_k)}{\ln(e_k/e_{k-1})}.$$

**可复算的例子**（幂法求主特征值，矩阵与数据取自[例 2.5.3](supplement/sec25.md#sup-2.5.3)：$A=\begin{pmatrix}5&2&0\\2&4&1\\0&1&3\end{pmatrix}$）：$\lvert\lambda_2/\lambda_1\rvert=0.5212$，实测 Rayleigh 商误差每步乘以 $0.2717$。两点读法：

- **比值的读法**：$0.2717\approx0.5212^2$，符合对称矩阵 Rayleigh 商误差按 $|\lambda_2/\lambda_1|^{2k}$ 衰减的理论；它不是一次迭代花费减半，也不是所有特征值估计量都必按另一比值下降（[定理 2.5.3](supplement/sec25.md#thm-sup-2.5.3)）。
- **阶的读法**：几何衰减 $e_{k+1}/e_k\to c\in(0,1)$ 正是一阶（线性）收敛；三点公式在渐近区应给出 $p\approx1$。不能因为 Rayleigh 商误差含平方就称该序列二阶收敛：平方是相对于特征向量方向误差而言。估阶前需排除误差为零、尚未进入渐近区或已受舍入支配的情况。

**残差停止的教学模板。** 预先给出非负容差与正整数预算，且至少一个容差为正；此模板只判断残差是否达标，不宣称给出前向误差界。

```python
threshold = atol + rtol * np.linalg.norm(b)
status = "预算耗尽"
for iteration in range(maxit + 1):
    residual_norm = np.linalg.norm(b - A @ solution)
    if not np.isfinite(residual_norm):
        status = "残差非有限"
        break
    if residual_norm <= threshold:
        status = "残差达标"
        break
    if iteration == maxit:
        break
    candidate = step(solution)
    if not np.all(np.isfinite(candidate)):
        status = "迭代值非有限"
        break
    if np.array_equal(candidate, solution):
        status = "浮点停滞且残差未达标"
        break
    solution = candidate
print(status, iteration, residual_norm)
```

### 四、工具地图：任务 → 函数 → 后端 {#sec-工具箱-4}

| 任务 | NumPy | SciPy | 底层例程（LAPACK） | 复杂度 |
|:--|:--|:--|:--|:--|
| 解方阵方程 | `np.linalg.solve` | `scipy.linalg.solve`（可声明 `assume_a='pos'/'sym'`） | `gesv`（LU + 列主元） | $\frac23n^{3}$ |
| Cholesky / 复用它 | `np.linalg.cholesky` | `cho_factor` + `cho_solve` | `potrf` / `potrs` | $\frac13n^{3}$ |
| LU 分解 + 复用 | — | `lu_factor` + `lu_solve` | `getrf` / `getrs` | $\frac23n^{3}$ |
| QR（Householder） | `np.linalg.qr` | `scipy.linalg.qr(mode='economic')` | `geqrf` | $2mn^{2}-\frac23n^{3}$ |
| 列主元 QR（可判秩） | — | `scipy.linalg.qr(pivoting=True)` | `geqp3` | 同上，略高 |
| 最小二乘 | `np.linalg.lstsq` | `scipy.linalg.lstsq`（`lapack_driver` 可切换） | SVD 型最小二乘例程（本节末注） | $\sim2mn^{2}$ |
| SVD | `np.linalg.svd`（默认 `gesdd`） | `scipy.linalg.svd(lapack_driver=...)` | `gesdd`（分治） / `gesvd` | $\sim2mn^{2}+11n^{3}$（$m\ge n$） |
| 条件数 | `np.linalg.cond(A, 2)`（SVD）；`cond(A, 1/inf)` **显式求逆**再取范数 | `scipy.linalg.lapack.dgecon`（$O(n^{2})$ 估计，需先做 LU） | `gecon` | $O(n^{3})$ / $O(n^{2})$ |
| 对称特征值 / 一般特征值 | `np.linalg.eigh` / `np.linalg.eig` | `scipy.linalg.eigh` / `eig` | `syevd` 族 / `geev` | $O(n^{3})$ |
| 稀疏直接解 | — | `scipy.sparse.linalg.spsolve` / `splu` | SuperLU | 见 nnz 与 fill-in |
| 稀疏迭代解 | — | `cg` / `gmres` / `minres` | — | 每步一次 matvec |
| 稀疏特征值 / SVD | — | `eigsh`（Lanczos）/ `eigs`（Arnoldi）/ `svds` | ARPACK | 每步一次 matvec |
| 伪逆 / 数值秩 | `np.linalg.pinv`、`np.linalg.matrix_rank` | — | `gesdd` + 阈值 | $O(n^{3})$ |

表中稠密分解的运算量列主要项，是否形成全部因子、矩阵形状及所用算法会改变常数；稀疏 Krylov 方法除矩阵–向量乘外，还需向量运算、正交化和预条件求解。`eigsh` / `eigs` 的位移反演模式还要解线性系统，不能概括为每步只有一次廉价 matvec。

**关于 `numpy.linalg` 的 LAPACK 后端。** NumPy 与 SciPy 调的是同一批 LAPACK / BLAS 例程（具体实现由发行版的 OpenBLAS、MKL 一类库提供），所以**同一个矩阵在不同机器上可能出现末位差异**——本教程各表因此都声明「逐位因平台的 BLAS 实现而异」。两处容易踩的差别：

- `np.linalg.cond(A, 2)` 走 SVD；而 `cond(A, 1)` / `cond(A, np.inf)` 按「$\lVert A\rVert\cdot\lVert A^{-1}\rVert$」实现，**会显式求逆**。大矩阵上想省这一步，用 SciPy 暴露的 `gecon`（先 LU 再做 $O(n^{2})$ 范数估计），调用签名随版本略变，用前查当前版本文档。
- `np.linalg.svd` 默认走 `gesdd`（分治），`np.linalg.qr` 走 `geqrf`；要换成别的例程（如 `gesvd`）得用 SciPy 的 `svd(lapack_driver='gesvd')`。
- 最小二乘的底层是 LAPACK 的 SVD 型求解器（`gelsd` 系列）。本机 numpy 2.4.6 的 `lstsq` 文档只承诺「用 SVD」，未点名例程——**具体例程这一项需核实**（要精确核对就查当前版本文档或源码）。

**何时用 `scipy.sparse`：** 非零元占比（如低于约 $10\%$）只能作初筛，还应看规模、结构、矩阵–向量乘代价及分解填充。`spsolve` 接受 CSR / CSC，重复分解或使用 `splu` 时通常准备 CSC。直接法须预估 fill-in；迭代法先检查残差、缩放、矩阵假设与预条件。`spilu` 的不完全 LU 可用于一般 GMRES 预条件，但不能不加判断地配给 CG：CG 需要保持对称正定结构的预条件子。不要只增加迭代次数。

### 五、三条「不要做」的事 {#sec-工具箱-5}

**1. 不要用显式求逆解方程组。**

```python
x = np.linalg.inv(A) @ b        # 不要这样写
x = np.linalg.solve(A, b)       # 正确的写法
```

- **代价账**：`solve` 是「LU（$\frac23n^{3}$）+ 两次三角回代（$2n^{2}$）」；`inv` 还要由 LU 显式构造 $A^{-1}$（再加约 $n^{3}$），总计约 2.5 倍工作量。
- **精度账**（可复算，$n$ 阶 Hilbert 矩阵、真解全为 $1$）：

  | $n$ | $\mathrm{cond}_2$ | `solve` 最大误差 | `inv @ b` 最大误差 |
  |:--:|:--:|:--:|:--:|
  | 8 | $1.53\times10^{10}$ | $1.2\times10^{-7}$ | $7.2\times10^{-7}$ |
  | 12 | $1.66\times10^{16}$ | $5.2\times10^{-1}$ | $1.9\times10^{1}$ |

  这组记录表明显式求逆路线可能更差，但差异不是固定倍数，也不能概括为“条件数必定再乘一次”。直接求解避免不必要的逆矩阵构造，通常更经济，并便于残差与后向误差分析（[1.3.6](ch01/sec13.md#sec-1.3.6)）。
- **同一 $A$ 多个右端**时，正确做法不是 `inv`，而是分解一次、回代多次：`lu_factor(A)` + 循环 `lu_solve`。

**2. 不要把 $A^{\mathrm T}A$ 送给特征值分解。**

数学上 $A^{\mathrm T}A$ 的特征值给出奇异值的平方，但列满秩时 $\mathrm{cond}_2(A^{\mathrm T}A)=\mathrm{cond}_2(A)^2$。显式形成乘积可能使小奇异值的信息被舍入掩盖，并非有效数字固定减半。原实验取 $12\times10$ Vandermonde 矩阵（$x$ 均匀取自 $[0,1]$，`np.vander(x, 10, increasing=True)`），记录为

$$\mathrm{cond}(A)=6.84\times10^{6},\qquad \mathrm{cond}(A^{\mathrm T}A)=4.68\times10^{13},\qquad \text{比值}=6.84\times10^{6}=\mathrm{cond}(A).$$

所以：算 SVD 用 `np.linalg.svd(A)`；解最小二乘用 `lstsq` / QR；算条件数用 `cond(A, 2)`。**`eigh(A.T @ A)` 只适合演示「条件数为什么会平方」**（[2.6.7 常见错误 2](supplement/sec26.md#sup-2.6.7)、[2.8.2 陷阱 5](supplement/sec28.md#sup-2.8.2)）。

**3. 不要把默认阈值当数据的分辨率。**

- `np.linalg.matrix_rank` 的默认阈值是 $\sigma_1\cdot\max(m,n)\cdot\mathrm{eps}$（本机 numpy 2.4.6 文档如此），它只适合「精确矩阵、数值上降秩」的场景。带噪数据的实测：给一个数值秩 3 的矩阵加 $10^{-9}$ 量级噪声后，默认阈值判出 $\operatorname{rank}=20$，按噪声水平截断得 $3$（[实验三 (d)](supplement/sec27.md#sup-2.7.3)）。
- 同一条也适用于伪逆：`np.linalg.pinv` 的默认 `rcond` 在原记录版本为 $10^{-15}$，不是噪声模型；保留很小的奇异值会通过其倒数放大数据扰动（[2.6.4 思考](supplement/sec26.md#sup-2.6.4)）。应报告阈值及保留秩；`pinv` / `lstsq` 的 `rcond` 是相对阈值，`matrix_rank` 的 `tol` 是绝对阈值，不能把同一数字直接互抄。

### 六、验收清单（提交数值结果前过一遍）{#sec-工具箱-6}

::: method 十项检查 · 每项都有一行可执行的核对方式

| # | 检查项 | 做法 | 通过标准 |
|:--:|:--|:--|:--|
| 1 | **残差** | `np.linalg.norm(b - A @ x)` | 不超过 `atol + rtol * np.linalg.norm(b)`，零右端也可用 |
| 2 | **条件数与预期精度** | `np.linalg.cond(A, 2)`，结合输入精度、后向误差与容差 | 报告风险上界，不把 $\mathrm{cond}(A)u$ 当作实际误差等式 |
| 3 | **合成算例的前向误差** | 取 `x_true = np.ones(n)`、`b = A @ x_true`，再解回来 | 对照理论上界与数据舍入；实际误差可能远小于最坏上界（[2.4.2](supplement/sec24.md#sup-2.4.2)、[实验二](supplement/sec27.md#sup-2.7.2)） |
| 4 | **最小二乘的正交条件** | `A.T @ (b - A @ x)` | 按 $\lVert A\rVert(\lVert b\rVert+\lVert A\rVert\lVert x\rVert)$ 缩放并结合维数与 $u$ 检查；不能只用很小的残差作尺度 |
| 5 | **QR / SVD 的回乘** | QR 检查 `Q @ R` 与 `Q.T @ Q`；SVD 检查 `(U[:, :p] * s) @ Vh[:p, :]`，其中 `p = len(s)` | 回乘相对误差及正交性误差通常为带维数常数的 $O(u)$；SVD 同时检查两侧正交性 |
| 6 | **低秩逼近误差** | 对 $0\le k<\min(m,n)$，比较 `norm(A - A_k, 2)` 与 `s[k]` | 在舍入可分辨范围内符合理论；极小奇异值不保证相对机器精度一致（[@thm-sup-2.6.4]） |
| 7 | **对称 / 正定性** | 按尺度指定容差检查 `A` 与 `A.T`，再尝试 Cholesky | Cholesky 通常只读一个三角，成功不能代替先查对称；接近半正定时另评估舍入影响 |
| 8 | **行均衡化** | `scale = np.max(np.abs(A), axis=1)`；先处理零行，再令 `B = A / scale[:, None]`、`c = b / scale` | 右端同步缩放，并比较条件数及原系统残差；缩放改善不表示敏感性全部消失 |
| 9 | **两种算法交叉验证** | `lstsq` 与 QR，或 `pinv(rcond)` 与同阈值截断 SVD 对照 | 先确认解的定义、秩与阈值相同；差异超出预期时排查，不预先认定必是代码错 |
| 10 | **可复现性** | 种子 `default_rng(0)`、`np.__version__`、`scipy.__version__` 与 BLAS 类型 | 同时报告生成数据、尺度、阈值与停止条件，不要求跨平台逐位相同 |

**三条不该出现在报告里的写法：** ① 只报残差、不报条件数（读者无从判断解准不准）；② 只报迭代次数、不报是否达标（触顶与收敛是两回事）；③ 不写种子与版本（别人复现不出你的数字）。
:::

### 七、症状 → 先看哪一页 / 用哪个函数 {#sec-工具箱-7}

| 我遇到的事 | 本页 | 正文 | 先用哪个函数 |
|:--|:--|:--|:--|
| 解出来不准，不知道是问题还是算法 | [第一节](#sec-工具箱-1) | [2.4](supplement/sec24.md) | `np.linalg.cond` |
| 超定系统要不要担心病态 | [第二节](#sec-工具箱-2) | [2.3.6](supplement/sec23.md#sup-2.3.6) | `np.linalg.lstsq` |
| 秩亏 / 有噪声的拟合 | [第五节](#sec-工具箱-5) | [2.6.4](supplement/sec26.md#sup-2.6.4)、[习题 D2](supplement/exercises.md) | `np.linalg.pinv(A, rcond=...)` |
| 要四个基本子空间 | [第二节](#sec-工具箱-2) | [2.2](supplement/sec22.md)、[2.6.3](supplement/sec26.md#sup-2.6.3) | `np.linalg.svd` |
| 矩阵很大、还是稀疏的 | [第四节](#sec-工具箱-4) | [2.3.5](supplement/sec23.md#sup-2.3.5) | `scipy.sparse.linalg.spsolve` / `cg` |
| 只要最大的几个特征值 | [第二节](#sec-工具箱-2) | [2.5.3](supplement/sec25.md#sup-2.5.3) | `scipy.sparse.linalg.eigsh` / `eigs` |
| 迭代该停在哪里、阶是多少 | [第三节](#sec-工具箱-3) | [2.5.3](supplement/sec25.md#thm-sup-2.5.3)、[第 5 讲](lectures/lec05.md) | — |
| 想压缩 / 降维 / 去噪 | [第二节](#sec-工具箱-2) | [2.6.5](supplement/sec26.md#sup-2.6.5)、[2.6.6](supplement/sec26.md#sup-2.6.6) | `np.linalg.svd`（截断 SVD） |
| 浮点误差的来龙去脉 | — | [1.2.5](ch01/sec12.md#sec-1.2.5)、[附录 B](appendix/float.md) | `np.finfo(float).eps` |

---

**依据**第一章 + 补充篇正文的公式、量级与实验整理 · 本页所有函数名与默认值在本机 numpy 2.4.6 / scipy 1.18.0 上核对过；**各版本默认阈值会变，动手前查当前版本文档** · 与[先修与自测](prerequisite.md)的分工：那一页管基础，本页管操作 · 整理日期 2026-10-20。
