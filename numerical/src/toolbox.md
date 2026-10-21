# 工程工具箱：误差诊断 · 算法选型 · 停止准则 · 函数地图

正文回答「为什么」，这一页回答「**动手时先看哪一页、用哪个函数**」。它是一张**索引**：拿到一个具体症状，先在本页定位到该算哪个量、该调哪个函数，再回正文读推导。本页不重述正文内容，也不重复复习层的公式卡与对照卡。

::: method 三条使用原则（先记住，再看下文）
1. **先诊断，再换算法。** 病态是问题的属性、不稳定是算法的属性（[1.2.6](ch01/sec12.md#sec-1.2.6)）；判错方向，后面的努力全花在错误的地方。
2. **先估量级，再对账。** 任何数值结论都先写一个理论量级——$\mathrm{cond}\cdot u$、$\sigma_{k+1}$、$(\lambda_2/\lambda_1)^k$——再用实测对账；[2.7](ch02/sec27.md) 的「报告要求」就是这个流程。
3. **先验收，再交付。** 算完必须过一遍[第六节](#sec-工具箱-6)的验收清单；没有验收的数值结果，只是打印出来的一堆数。
:::

::: note 七页各管一件事（不要互相替代）

| 页 | 管什么 | 什么时候用 |
|:--|:--|:--|
| [先修与自测](prerequisite.md) | **基础层**：线代 / 微积分 / 编程 / 记号的清单与自测 | 开学前、数学卡壳时 |
| **本页** | **操作层**：诊断 → 选型 → 停止准则 → 函数与后端 | 每一段数值代码落地时 |
| [公式与结论卡](review/formula-cards.md) | **查阅层**：第一章 + 补充篇必记公式 | 忘了公式 |
| [易混对照卡](review/contrast-cards.md) | **辨析层**：16 对易混概念 | 判断题、概念题 |
| [术语索引](review/glossary.md) | **命名层**：中英术语与定义位置 | 查名字 |
| [附录 B](appendix/float.md) | **深挖层**：浮点算术的完整推导 | 想看清 $\mathrm{eps}$、Kahan、求和界是怎么来的 |
| [必考点竞技场](training/arena.md) | **输出层**：限时答题、错题本 | 考前限时训练 |
:::

### 一、误差诊断：四个量、一张判据表 {#sec-工具箱-1}

| 量 | 怎么算 | 它回答什么 | 常见误用 |
|:--|:--|:--|:--|
| **残差** $\boldsymbol{r}=\boldsymbol{b}-A\boldsymbol{x}$ | `r = b - A @ x` | 方程被满足到什么程度（**可以算**） | 拿它当误差用（[例 2.4.4](ch02/sec24.md#sec-2.4.4)：残差 $2.5\times10^{-12}$、误差 $50\%$） |
| **后向误差**（向后误差） | 范数型：$\eta=\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert A\rVert\lVert\boldsymbol{x}\rVert+\lVert\boldsymbol{b}\rVert}$ | 算得的解是「哪个邻近问题的精确解」——求解器**实际保证**的量 | 把后向误差当精度报告（它是算法指标，不是解的准确度） |
| **条件数** $\mathrm{cond}(A)$ | `np.linalg.cond(A, 2)`（内部走 SVD） | 问题天生的放大倍数 / 要丢几位 | 不注明范数就互相比较（[2.4.6](ch02/sec24.md#sec-2.4.6)） |
| **误差** $\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$ | 一般算不出（真解未知） | 解离真值多远 | 用「相邻两次迭代之差」冒充它 |

**核心判据（把残差换算成误差）：** $\dfrac{\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert}\lesssim\mathrm{cond}(A)\cdot\dfrac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}$（[@thm-2.4.4]）。求解器向后稳定只保证**残差**小；要谈解准不准，必须乘上条件数。**丢掉几位有效数字**用 $k\approx\log_{10}\mathrm{cond}(A)$ 估（[2.4.2 换算表](ch02/sec24.md#sec-2.4.2)）。

**「后向误差与条件数无关」的实测证据**（同一批 Hilbert 矩阵，`np.linalg.solve` 求解、真解全为 $1$）：

| $n$ | $\mathrm{cond}_2$ | 后向误差 $\eta$ | 相对残差 | 前向误差（最大分量） |
|:--:|:--:|:--:|:--:|:--:|
| 8 | $1.53\times10^{10}$ | $4.6\times10^{-17}$ | $1.0\times10^{-16}$ | $1.2\times10^{-7}$ |
| 12 | $1.66\times10^{16}$ | $1.9\times10^{-17}$ | $4.3\times10^{-17}$ | $5.2\times10^{-1}$ |

读法：两行的后向误差都停在 $u\approx1.1\times10^{-16}$ 甚至更小——**算法一直是向后稳定的**；而前向误差从 $10^{-7}$ 涨到 $10^{-1}$，差了 6 个数量级。**病态吃掉的是前向误差，与算法的稳定性无关**（[1.2.6](ch01/sec12.md#sec-1.2.6) 的 conditioning / stability 之分在这里落地）。

**症状 → 先算哪个量 → 判据 → 处方：**

| 症状 | 先算 | 判据 | 处方 |
|:--|:--|:--|:--|
| 残差很小，结果仍可疑 | $\mathrm{cond}(A)$ 与 $\mathrm{cond}\cdot\lVert\boldsymbol{r}\rVert/\lVert\boldsymbol{b}\rVert$ | 后者远大于期望精度 | 换 QR / SVD、迭代精化、提高工作精度、正则化 |
| 解的系数量级离谱（如 $O(10^{5})$ 而真值 $O(1)$） | 奇异值谱、行量级 | 有条件数平方迹象（曾算 $A^{\mathrm T}A$） | 先用 QR / SVD 复算，再决定是否正则化（[习题 D1](ch02/exercises.md) 的诊断报告就是这套流程） |
| 换一种解法结果差很多 | $\mathrm{cond}(A)$ | 各算法误差都 $\sim\mathrm{cond}\cdot u$ | 确认病态属于问题本身，改算法没有用 |
| 行量级悬殊（如相差 $10^{10}$） | $\mathrm{cond}_\infty$ 前后对比 | 行均衡化后条件数骤降 | 先均衡化再评估（[例 2.4.5](ch02/sec24.md#sec-2.4.5)：$2\times10^{20}\to4\times10^{10}$） |
| 数值秩每次统计都不一样 | 奇异值谱 + 噪声水平 | $\sigma_k$ 与噪声同量级 | 按噪声水平定阈值，不照抄库的默认值 |

**可复算的两个锚点**（本机 numpy 2.4.6，命令可直接跑）：8 阶 Hilbert 矩阵 $\mathrm{cond}_2=1.53\times10^{10}$，`solve` 最大误差 $1.2\times10^{-7}$；12 阶 $\mathrm{cond}_2=1.66\times10^{16}$，`solve` 最大误差 $0.52$（真值全为 $1$）——第二行说明**解已经失去意义，而求解器并不报错**。

### 二、算法选择树：解方程组与特征值 {#sec-工具箱-2}

**解 $A\boldsymbol{x}=\boldsymbol{b}$（方阵）**

| 情形 | 首选 | 函数 | 复杂度 | 为什么 |
|:--|:--|:--|:--|:--|
| 稠密、一般 | LU + 列主元 | `np.linalg.solve`；多个右端用 `scipy.linalg.lu_factor` + `lu_solve` | $\frac23n^{3}$ | 列主元把乘数控制在 $1$ 以内（[第 3 讲](lectures/lec03.md)） |
| 稠密、**对称正定** | Cholesky | `scipy.linalg.cholesky` / `cho_factor` + `cho_solve` | $\frac13n^{3}$ | 省一半工作，且不需要选主元 |
| 稠密、对称不定 | LDL（Bunch–Kaufman 型） | `scipy.linalg.ldl` | $\frac13n^{3}$ 量级 | 对称性可用，但主元要 $2\times2$ 块 |
| 三对角 / 带状 | 追赶法 / 带状求解 | `scipy.linalg.solve_banded` | $O(n)$ | 带状结构不该被当成稠密处理 |
| 稀疏（$n$ 大、非零少） | 稀疏 LU（SuperLU）或迭代法 | `scipy.sparse.linalg.splu` / `spsolve`；迭代用 `cg`（对称正定）、`gmres`（一般） | 见 nnz | 直接法有 **fill-in**，内存可能爆；迭代法需要预条件子 |
| **病态**（$\mathrm{cond}\gtrsim10^{8}$） | 先问「问题要不要重述」，再选算法 | 见上一节处方列 | — | 任何算法都只给 $\mathrm{cond}\cdot u$ 量级 |

**判定顺序（照这个顺序问四个问题）：** ① 矩阵对称吗？正定吗？→ 决定能否用 Cholesky / LDL。② 稀疏吗（判据见第四节的经验法则）？→ 决定稠密库还是 `scipy.sparse`。③ 条件数量级多大？→ 决定要不要换路线（QR / SVD / 正则化 / 提高精度）。④ 同一个 $A$ 要解多少个右端？→ 多个右端先分解一次（`lu_factor` / `cho_factor`），再反复 `*_solve`。

**超定最小二乘 $A\boldsymbol{x}\approx\boldsymbol{b}$（$m\gt n$）**

| 情形 | 首选 | 函数 | 关键量级 |
|:--|:--|:--|:--|
| 列满秩、$\mathrm{cond}\lesssim10^{8}$ | QR（Householder） | `np.linalg.lstsq`；显式用 `np.linalg.qr` + 回代亦可 | 误差 $\sim\mathrm{cond}(A)u$ |
| 列满秩、$\mathrm{cond}\gtrsim10^{8}$ | SVD + 阈值 | `np.linalg.lstsq`（内部走 SVD）或显式 `svd` | 同上，且能同时给出数值秩 |
| 秩亏 / 近似秩亏 | 截断伪逆 | `np.linalg.pinv(A, rcond=...)`、`lstsq(..., rcond=...)` | 阈值按噪声水平 |
| **正态方程**（$A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$） | 只用于教学与手算 | — | 误差 $\sim\mathrm{cond}(A)^{2}u$，唯一优点是公式短（[2.3.6](ch02/sec23.md#sec-2.3.6)） |

**特征值与奇异值问题**

| 要求 | 首选 | 函数 | 说明 |
|:--|:--|:--|:--|
| 稠密、一般矩阵、全部特征值 | QR 算法（先化 Hessenberg 再迭代） | `scipy.linalg.eig` | 特征值可为复数，注意返回类型 |
| 稠密、**对称**矩阵、全部特征值 | 对称 QR / 分治 | `scipy.linalg.eigh` | 特征值必为实数、特征向量正交，比 `eig` 又快又稳 |
| 只要**主特征值**、矩阵–向量乘足够便宜 | 幂法 + Rayleigh 商 | 手写循环（[算法 2.5.1](ch02/sec25.md#sec-2.5.3)） | 速度由 $\lvert\lambda_2/\lambda_1\rvert$ 决定，估计值用 Rayleigh 商（二阶精度） |
| 大规模稀疏、要最大的几个（对称） | Lanczos | `scipy.sparse.linalg.eigsh` | 只做矩阵–向量乘，$O(\mathrm{nnz})$ 每步 |
| 大规模稀疏、**非对称** | **Arnoldi** | `scipy.sparse.linalg.eigs` | 需要多大的 $k$、`ncv` 取多少，见函数文档 |
| 全部特征值、还想看中间过程 | QR 迭代 | 手写（[2.3 预告](ch02/sec23.md#sec-2.3.7)） | $A'=RQ=Q^{\mathrm T}AQ$ 相似，对角元趋于特征值；收敛还须核对结构、初始分量与相位；模互异本身不足以保证整个矩阵收敛 |
| 只想知道特征值「被困在哪」 | Gerschgorin 圆盘 | 读一遍矩阵即可（[2.5.2](ch02/sec25.md#sec-2.5.2)） | $O(n^{2})$ 的围栏；对角占优时圆心就是良好近似 |
| 稀疏 / 只要前几个最大奇异值 | 迭代 SVD | `scipy.sparse.linalg.svds` | 稠密的完整 SVD 用 `np.linalg.svd` |

### 三、收敛判定与停止准则 {#sec-工具箱-3}

**三条停止准则，缺一不可：** ① **相对**残差（或相对增量）阈值 $\lVert\boldsymbol{r}_k\rVert/\lVert\boldsymbol{b}\rVert\le\varepsilon_{\mathrm{tol}}$；② 迭代次数上限（阈值没到也要停下来并报告）；③ 判据必须能算——用真解做判据等于没有判据。

::: think 一个高频误解：相邻两次迭代值差很小，就认为接近真解
不成立。迭代矩阵的范数接近 $1$ 时，相邻差可以很小而离真解很远——这是[必考点总表](training/arena.md#必考点总表老师课堂反复强调)里的一条，也是[第 5 讲](lectures/lec05.md)专门强调的。**收敛判据分清两层：充要条件是 $\rho(G)\lt1$，工程上实用的充分条件是 $\lVert G\rVert\lt1$**（[2.5.6](ch02/sec25.md#sec-2.5.6) 还提醒：用 $\rho$ 判断在非正规矩阵上会遇到瞬态增长）。
:::

**实测收敛阶怎么估。** 若误差满足 $e_{k+1}\approx C e_k^{p}$，则连续两个误差比给出

$$p\approx\frac{\ln\!\left(e_{k+1}/e_k\right)}{\ln\!\left(e_k/e_{k-1}\right)} .$$

**可复算的例子**（幂法求主特征值，矩阵与数据取自[例 2.5.3](ch02/sec25.md#sec-2.5.3)：$A=\begin{pmatrix}5&2&0\\2&4&1\\0&1&3\end{pmatrix}$）：$\lvert\lambda_2/\lambda_1\rvert=0.5212$，实测 Rayleigh 商误差每步乘以 $0.2717$。两点读法：

- **比值的读法**：$0.2717=0.5212^{2}$ 恰好说明「Rayleigh 商的误差按 $(\lambda_2/\lambda_1)^{2k}$ 衰减」——比只用 $\lVert A\boldsymbol{x}\rVert$ 估计（每步 $0.5212$）快一倍（[定理 2.5.3](ch02/sec25.md#thm-2.5.3)）。
- **阶的读法**：把实测误差代进上面的公式，得到 $p\approx0.98$——它告诉你的信息是「这个序列是**几何**衰减、比值 $0.27$」，而不是「一阶收敛」。**报「阶」之前先确认序列真的落在 $e_{k+1}\approx Ce_k^{p}$（$p\gt1$）的形态里**：割线法这类 $p\approx1.618$ 的序列（[第 9 讲](lectures/lec09.md)）才适合直接用三点公式估阶。

**一份可以照抄的停止准则模板：**

```python
for k in range(maxit):                     # ② 上限永远写进循环
    x = step(x)                            # 迭代一步
    res = np.linalg.norm(b - A @ x) / bnorm # ① 相对残差
    if res < tol: break                    # 达标即停
else:
    print(f"未达标即触顶：k={maxit} 残差={res:.3e} "
          f"cond 估计={np.linalg.cond(A, 2):.2e}")  # ③ 触顶时报告诊断量
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

**关于 `numpy.linalg` 的 LAPACK 后端。** NumPy 与 SciPy 调的是同一批 LAPACK / BLAS 例程（具体实现由发行版的 OpenBLAS、MKL 一类库提供），所以**同一个矩阵在不同机器上可能出现末位差异**——本教程各表因此都声明「逐位因平台的 BLAS 实现而异」。两处容易踩的差别：

- `np.linalg.cond(A, 2)` 走 SVD；而 `cond(A, 1)` / `cond(A, np.inf)` 按「$\lVert A\rVert\cdot\lVert A^{-1}\rVert$」实现，**会显式求逆**。大矩阵上想省这一步，用 SciPy 暴露的 `gecon`（先 LU 再做 $O(n^{2})$ 范数估计），调用签名随版本略变，用前查当前版本文档。
- `np.linalg.svd` 默认走 `gesdd`（分治），`np.linalg.qr` 走 `geqrf`；要换成别的例程（如 `gesvd`）得用 SciPy 的 `svd(lapack_driver='gesvd')`。
- 最小二乘的底层是 LAPACK 的 SVD 型求解器（`gelsd` 系列）。本机 numpy 2.4.6 的 `lstsq` 文档只承诺「用 SVD」，未点名例程——**具体例程这一项需核实**（要精确核对就查当前版本文档或源码）。

**何时该用 `scipy.sparse`：** 判据是「非零元占比」与「能不能只做矩阵–向量乘」两条。经验法则（社区惯例，不是定理）：$\mathrm{nnz}/n^{2}$ 低于约 $10\%$、且矩阵来自网格、图或文本这类天然稀疏结构时，换稀疏表示通常值得。三条实测提醒：① 稀疏格式要转对——`spsolve` 用 CSC（`A.tocsc()`）；② 直接法（`splu`）有 fill-in，分解后非零元可能比原矩阵多几个量级，内存是第一个瓶颈；③ 迭代法（`cg` / `gmres`）不收敛时先加预条件子（`spilu` 做不完全 LU），而不是一味加迭代次数。

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

  显式求逆多引入一层舍入，误差被条件数再放大一次（[1.3.6](ch01/sec13.md#sec-1.3.6) 的矩阵条件数是这件事的定量依据）。
- **同一 $A$ 多个右端**时，正确做法不是 `inv`，而是分解一次、回代多次：`lu_factor(A)` + 循环 `lu_solve`。

**2. 不要把 $A^{\mathrm T}A$ 送给特征值分解。**

数学上 $A^{\mathrm T}A$ 的特征值确实给出奇异值的平方，但 $\mathrm{cond}(A^{\mathrm T}A)=\mathrm{cond}(A)^{2}$——**有效数字直接掉一半**。可复算的账：取 $12\times10$ 的 Vandermonde 设计矩阵（$x$ 均匀取自 $[0,1]$，`np.vander(x, 10, increasing=True)`），实测

$$\mathrm{cond}(A)=6.84\times10^{6},\qquad \mathrm{cond}(A^{\mathrm T}A)=4.68\times10^{13},\qquad \text{比值}=6.84\times10^{6}=\mathrm{cond}(A).$$

所以：算 SVD 用 `np.linalg.svd(A)`；解最小二乘用 `lstsq` / QR；算条件数用 `cond(A, 2)`。**`eigh(A.T @ A)` 只适合演示「条件数为什么会平方」**（[2.6.7 常见错误 2](ch02/sec26.md#sec-2.6.7)、[2.8.2 陷阱 5](ch02/sec28.md#sec-2.8.2)）。

**3. 不要把默认阈值当数据的分辨率。**

- `np.linalg.matrix_rank` 的默认阈值是 $\sigma_1\cdot\max(m,n)\cdot\mathrm{eps}$（本机 numpy 2.4.6 文档如此），它只适合「精确矩阵、数值上降秩」的场景。带噪数据的实测：给一个数值秩 3 的矩阵加 $10^{-9}$ 量级噪声后，默认阈值判出 $\operatorname{rank}=20$，按噪声水平截断得 $3$（[实验三 (d)](ch02/sec27.md#sec-2.7.3)）。
- 同一条也适用于伪逆：`np.linalg.pinv` 的默认 `rcond` 是 $10^{-15}$，不截断的伪逆会把 $1/\sigma_{\min}$ 放大 $\mathrm{cond}(A)$ 倍，与直接求逆同样危险（[2.6.4 思考](ch02/sec26.md#sec-2.6.4)）。**正确做法**：按数据噪声水平给 `rcond`（或 `tol`），并报告所选阈值。

### 六、验收清单（提交数值结果前过一遍）{#sec-工具箱-6}

::: method 十项检查 · 每项都有一行可执行的核对方式

| # | 检查项 | 做法 | 通过标准 |
|:--:|:--|:--|:--|
| 1 | **残差** | `r = b - A @ x; np.linalg.norm(r)/np.linalg.norm(b)` | 小于设定的相对阈值 |
| 2 | **条件数与预期精度** | `np.linalg.cond(A, 2)`；算 $\mathrm{cond}\cdot u$ | 报告的位数与 $k\approx\log_{10}\mathrm{cond}$ 一致 |
| 3 | **合成算例的前向误差** | 取真解 `x_true = ones(n)`、`b = A @ x_true`，再解回来比最大分量误差 | 与 $\mathrm{cond}\cdot u$ 同量级（[2.4.2](ch02/sec24.md#sec-2.4.2)、[实验二](ch02/sec27.md#sec-2.7.2)） |
| 4 | **最小二乘的正交条件** | `A.T @ (b - A @ x)` | 各分量 $\sim u\lVert A\rVert\lVert\boldsymbol{r}\rVert$（免费自检） |
| 5 | **QR / SVD 的回乘** | `np.linalg.norm(Q @ R - A)`、`np.linalg.norm(Q.T @ Q - I)` | 分别 $\sim u\lVert A\rVert$ 与 $\sim u$（Householder / Givens） |
| 6 | **低秩逼近的误差** | `np.linalg.norm(A - A_k, 2)` 与 `S[k]` 对照 | 两者相等至机器精度（[@thm-2.6.4]） |
| 7 | **对称 / 正定性** | `np.allclose(A, A.T)`；Cholesky 是否成功 | 声明了对称就必须核对 |
| 8 | **行均衡化后的条件数** | `B = A / A.max(axis=1, keepdims=True)`，再算 $\mathrm{cond}_\infty$ | 判断「真病态」还是「单位没选好」 |
| 9 | **两种算法的交叉验证** | `lstsq` 与 QR 各算一次；`pinv(rcond)` 与截断 SVD 对照 | 差异落在预期量级内，否则说明某一步写错了 |
| 10 | **可复现性** | 随机种子（`default_rng(0)`）、函数版本（`np.__version__`、`scipy.__version__`）、BLAS 类型 | 报告里能写出这三项 |

**三条不该出现在报告里的写法：** ① 只报残差、不报条件数（读者无从判断解准不准）；② 只报迭代次数、不报是否达标（触顶与收敛是两回事）；③ 不写种子与版本（别人复现不出你的数字）。
:::

### 七、症状 → 先看哪一页 / 用哪个函数 {#sec-工具箱-7}

| 我遇到的事 | 本页 | 正文 | 先用哪个函数 |
|:--|:--|:--|:--|
| 解出来不准，不知道是问题还是算法 | [第一节](#sec-工具箱-1) | [2.4](ch02/sec24.md) | `np.linalg.cond` |
| 超定系统要不要担心病态 | [第二节](#sec-工具箱-2) | [2.3.6](ch02/sec23.md#sec-2.3.6) | `np.linalg.lstsq` |
| 秩亏 / 有噪声的拟合 | [第五节](#sec-工具箱-5) | [2.6.4](ch02/sec26.md#sec-2.6.4)、[习题 D2](ch02/exercises.md) | `np.linalg.pinv(A, rcond=...)` |
| 要四个基本子空间 | [第二节](#sec-工具箱-2) | [2.2](ch02/sec22.md)、[2.6.3](ch02/sec26.md#sec-2.6.3) | `np.linalg.svd` |
| 矩阵很大、还是稀疏的 | [第四节](#sec-工具箱-4) | [2.3.5](ch02/sec23.md#sec-2.3.5) | `scipy.sparse.linalg.spsolve` / `cg` |
| 只要最大的几个特征值 | [第二节](#sec-工具箱-2) | [2.5.3](ch02/sec25.md#sec-2.5.3) | `scipy.sparse.linalg.eigsh` / `eigs` |
| 迭代该停在哪里、阶是多少 | [第三节](#sec-工具箱-3) | [2.5.3](ch02/sec25.md#thm-2.5.3)、[第 5 讲](lectures/lec05.md) | — |
| 想压缩 / 降维 / 去噪 | [第二节](#sec-工具箱-2) | [2.6.5](ch02/sec26.md#sec-2.6.5)、[2.6.6](ch02/sec26.md#sec-2.6.6) | `np.linalg.svd`（截断 SVD） |
| 浮点误差的来龙去脉 | — | [1.2.5](ch01/sec12.md#sec-1.2.5)、[附录 B](appendix/float.md) | `np.finfo(float).eps` |

---

**依据**第一章 + 补充篇正文的公式、量级与实验整理 · 本页所有函数名与默认值在本机 numpy 2.4.6 / scipy 1.18.0 上核对过；**各版本默认阈值会变，动手前查当前版本文档** · 与[先修与自测](prerequisite.md)的分工：那一页管基础，本页管操作 · 整理日期 2026-10-20。
