# 符号表

本页汇总全书常用记号；页末三个方框说明误差限、向量排版与矩阵范数的约定。同一字母在不同问题中可能另有局部定义，例如 $a$ 也可表示区间端点，$u$ 也可表示迭代向量；先看所在公式定义，再用本页回查。默认讨论实数、实向量与实矩阵；涉及复数时须将内积和正交条件中的转置改为共轭转置。

## 通用与误差

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $x$ | 准确值（真值）exact value | 参与比较的精确量，通常未知 |
| $a$ | 近似值 approximation | $x$ 的近似；原书记号为 $a$ |
| $e(a)=x-a$ | 绝对误差 error | 可正可负；$\lvert e(a)\rvert$ 是误差大小 |
| $\varepsilon(a)$ | 绝对误差限 error bound | $\lvert e(a)\rvert\le\varepsilon(a)$；$\varepsilon(a)$ 恒非负，简称误差限 |
| $e_{\mathrm r}(a)$，$\varepsilon_{\mathrm r}(a)$ | 相对误差 / 相对误差限 | $e_{\mathrm r}=(x-a)/x$（$x\ne0$）；误差小时可近似为 $(x-a)/a$（$a\ne0$），本书实用记法 $\varepsilon_{\mathrm r}=\varepsilon(a)/\lvert a\rvert$ 并非对真值分母的无条件严格上界 |
| $a=\pm0.a_1a_2\cdots a_k\times10^m$ | 规格化十进制形式 | $m$ 整数，$a_i\in\{0,\dots,9\}$，$a_1\neq0$ |
| $\beta,t$ | 浮点基与尾数位数 | IEEE 双精度 $\beta=2,\ t=53$ |
| $\operatorname{fl}(x)$ | 浮点舍入 float | 把实数 $x$ 舍入到浮点集 $F$ 的结果 |
| $u$，$\mathrm{eps}$ | 单位舍入误差 / 机器精度 | 就近舍入时 $u=\tfrac12\beta^{1-t}$；$\mathrm{eps}=\beta^{1-t}$；双精度 $u=2^{-53}$，$\mathrm{eps}=2^{-52}$，相对误差模型排除溢出与下溢影响 |
| $O(g(n))$ | 量级上界 big-O | 在指定极限下，绝对值不超过常数倍 $\lvert g(n)\rvert$；不表示必与 $g(n)$ 同阶。也用于 $h\to0$ 的误差估计 |
| $\mathrm{cond}(f,x)$ | 函数条件数 | $\lvert xf'(x)/f(x)\rvert$，用于可微且 $x\ne0,f(x)\ne0$ 处的局部相对扰动分析，[1.2.6](ch01/sec12.md#sec-1.2.6) |

若 $\varepsilon(a)<|a|$，真值分母的相对误差可严格界为 $|e_{\mathrm r}(a)|\le\varepsilon(a)/(|a|-\varepsilon(a))$。再次舍入为 $\bar a$ 时，先把 $|a-\bar a|$ 计入新误差限，再按 $\bar a$ 的规格化形式判定有效数字，见 [1.2.2](ch01/sec12.md#sec-1.2.2)。

## 向量与矩阵

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $\boldsymbol{x}=(x_1,\cdots,x_n)^{\mathrm T}$ | 向量 | 粗体小写；$\mathbb{R}^n$ 中列向量 |
| $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}$ | 内积 | $\sum_ix_iy_i$；未特别说明时为 Euclid 内积 |
| $\langle\boldsymbol{x},\boldsymbol{y}\rangle$ | 内积（一般记号） | 泛指某一给定的内积，见 [2.1](supplement/sec21.md) |
| $\boldsymbol{x}\perp\boldsymbol{y}$ | 正交 | Euclid 内积下为 $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=0$；一般内积下为 $\langle\boldsymbol{x},\boldsymbol{y}\rangle=0$ |
| $\lVert\boldsymbol{x}\rVert_p$ | 向量 $p$-范数 | $1\le p<\infty$ 时为 $\bigl(\sum\lvert x_i\rvert^p\bigr)^{1/p}$；$p=\infty$ 时为 $\max_i\lvert x_i\rvert$ |
| $\lVert\boldsymbol{x}\rVert$ | 泛指的范数 | 不指明用哪一种范数时的泛指记号 |
| $A=[a_{ij}]$ | 矩阵 | 大写斜体；$A\in\mathbb{R}^{m\times n}$ |
| $A^{\mathrm T}$ | 转置 | $[a_{ji}]$ |
| $\operatorname{rank}A$ | 秩 rank | 极大线性无关列数 |
| $\lVert A\rVert_p$ | 矩阵 $p$-范数（从属范数） | $\max_{\boldsymbol{x}\neq0}\lVert A\boldsymbol{x}\rVert_p/\lVert\boldsymbol{x}\rVert_p$ |
| $\lVert A\rVert_F$ | Frobenius 范数 | $\bigl(\sum_{i,j}a_{ij}^2\bigr)^{1/2}$；不是算子范数 |
| $\mathrm{cond}(A)$ | 条件数 | 非奇异方阵为 $\lVert A\rVert\lVert A^{-1}\rVert$；2-范数下为 $\sigma_1/\sigma_n$，奇异方阵记为 $\infty$；长方形矩阵须说明所用的广义条件数约定 |
| $\det A$，$\operatorname{tr}A$ | 行列式 / 迹 | 迹 $=\sum_i a_{ii}=\sum_i\lambda_i$ |
| $I$，$O$ | 单位矩阵 / 零矩阵 | 阶数由上下文确定 |

## 子空间、投影与正交分解（补充篇）

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $C(A)$，$\operatorname{Ran}A$ | 列空间 | $\{A\boldsymbol{x}:\boldsymbol{x}\in\mathbb{R}^n\}$ |
| $N(A)$，$\operatorname{Null}A$ | 零空间 | $\{\boldsymbol{x}\in\mathbb R^n:A\boldsymbol{x}=\boldsymbol 0\}$ |
| $C(A^{\mathrm T})$，$R(A)$ | 行空间 | 与零空间互为正交补 |
| $N(A^{\mathrm T})$ | 左零空间 | 与列空间互为正交补 |
| $\mathcal{S}^{\perp}$ | 正交补 | 与 $\mathcal{S}$ 中每个向量都正交的向量全体 |
| $P$ | 正交投影矩阵 | $A$ 列满秩时 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$，一般为 $AA^+$；对称、幂等 |
| $Q$ | 正交矩阵 / 正交基矩阵 | $Q^{\mathrm T}Q=I$（方阵时 $Q^{-1}=Q^{\mathrm T}$） |
| $A=QR$ | QR 分解 | 瘦 QR 中 $Q$ 的列标准正交，$R$ 上三角；全 QR 中 $Q$ 为正交方阵，$R$ 为上梯形 |
| $H$，$G$ | Householder 反射 / Givens 旋转 | $H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}/(\boldsymbol v^{\mathrm T}\boldsymbol v)$，要求 $\boldsymbol v\ne0$ |
| $r$，$\boldsymbol r$ | 秩 / 残差向量 | $\boldsymbol r=\boldsymbol b-A\boldsymbol x$ |

## 谱与奇异值（补充篇）

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $\lambda_i(A)$ | 特征值 | $\det(A-\lambda I)=0$ 的根 |
| $\rho(A)$ | 谱半径 | $\max_i\lvert\lambda_i\rvert$ |
| $\sigma_i(A)$ | 奇异值 | 非负，通常共列 $\min(m,n)$ 个并降序排列；$r=\operatorname{rank}A$ 时前 $r$ 个为正，其余为零。平方为 $A^{\mathrm T}A$ 相应的非零或零特征值 |
| $\lambda_{\max}(A^{\mathrm T}A)$ | 最大特征值 | $A^{\mathrm T}A$ 对称半正定 |
| $A=U\Sigma V^{\mathrm T}$ | 奇异值分解 SVD | $U,V$ 正交，$\Sigma$ 非负对角 |
| $A^{+}$ | Moore–Penrose 伪逆 | $V\Sigma^{+}U^{\mathrm T}$ |
| $\boldsymbol q(\boldsymbol{x})$，$R(\boldsymbol{x})$ | Rayleigh 商 | $\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}/(\boldsymbol{x}^{\mathrm T}\boldsymbol{x})$，$\boldsymbol{x}\ne0$；实对称矩阵下有极值刻画与二阶方向误差性质 |
| $\kappa(A)$，$\mathrm{cond}_2(A)$ | 谱条件数 | 非奇异方阵为 $\sigma_1/\sigma_n$；不能将秩亏矩阵的最小非零奇异值代入而仍称其逆矩阵条件数 |
| $\rho\le\lVert A\rVert$ | 谱半径与范数 | 任一相容矩阵范数下成立，见 [2.5](supplement/sec25.md) |

## 插值、积分与时间推进

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $x_i$，$f[x_0,\dots,x_k]$ | 插值节点 / 差商 | 普通差商要求节点互异；重复节点用导数延拓，见 [5.1](course/ch05/sec51.md) |
| $I$，$Q$，$R=I-Q$ | 真积分 / 求积值 / 求积余项 | 此处 $I$ 不是单位矩阵；$R$ 带符号，与非负误差限不同 |
| $T_n$，$\mathcal T_m=T_{2^m}$ | 复化梯形值 / 第 $m$ 层加密值 | $n$ 为子区间数，$m$ 为分半层数；[6.5](course/ch06/sec65.md) 局部简记第 $m$ 层为 $T_m$，须按所在页定义解读 |
| $h$，$t_n$，$y_n$，$f_n$ | 时间步长 / 网格点 / 数值解 / 节点斜率 | 等步长时 $t_{n+1}=t_n+h$，$f_n=f(t_n,y_n)$；精确解写 $y(t_n)$ |
| $R_{n+1}$ | ODE 局部误差或格式缺陷 | 单步法通常取精确值减一步数值值；多步格式取代入精确解后的左端减右端，均不除以 $h$，见 [7.1](course/ch07/sec71.md)、[7.3](course/ch07/sec73.md) |
| $R(z)$，$z=h\lambda$ | 稳定函数 / 缩放特征值 | 测试方程 $y'=\lambda y$ 中的放大因子；不是上行的局部误差 |


::: note

**记号约定一（误差限 $\varepsilon$）：**四则运算通常用非负误差限写保证界或近似估计，如选取 $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$ 作为一个安全上界；这不表示实际误差的绝对值总等于两者之和，也不表示该界最紧。带符号误差 $e=x-a$ 用于说明传播方向与推导，见 [1.2.3](ch01/sec12.md#sec-1.2.3) 与 [习题 B5](ch01/exercises.md)。

:::

::: note

**记号约定二（向量加粗）：**向量一律用粗体（本教程排为粗斜体）$\boldsymbol{x}$，分量用小写 $x_i$；矩阵用大写斜体 $A$。原书有些地方把向量排成粗斜体、有些排成正体，本教程统一取粗斜体。

:::

::: note

**记号约定三（谱与从属）：**小写下标 $p$ 既用于向量范数，也用于矩阵范数；用在矩阵范数上时，默认它是**从属于**同名向量范数的算子范数（[1.3.3](ch01/sec13.md#sec-1.3.3)）。$\lVert A\rVert$ 不带下标时，泛指任一满足四公理的相容矩阵范数。此外，2-范数也叫**谱范数**，它的条件数 $\mathrm{cond}_2$ 也叫**谱条件数**。

:::
