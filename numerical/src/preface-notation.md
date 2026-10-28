# 符号表

本页汇总全书统一的记号；页末三个方框是三条需要特别留意的约定。正文中遇到不熟悉的符号，随时回到这里查。

## 通用与误差

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $x$ | 准确值（真值）exact value | 参与比较的精确量，通常未知 |
| $a$ | 近似值 approximation | $x$ 的近似；原书记号为 $a$ |
| $e(a)=x-a$ | 绝对误差 error | 可正可负；$\lvert e(a)\rvert$ 是误差大小 |
| $\varepsilon(a)$ | 绝对误差限 error bound | $\lvert e(a)\rvert\le\varepsilon(a)$；$\varepsilon(a)$ 恒非负，简称误差限 |
| $e_{\mathrm r}(a)$，$\varepsilon_{\mathrm r}(a)$ | 相对误差 / 相对误差限 | 实用中 $e_{\mathrm r}\approx(x-a)/a$；$\varepsilon_{\mathrm r}=\varepsilon(a)/\lvert a\rvert$ |
| $a=\pm0.a_1a_2\cdots a_k\times10^m$ | 规格化十进制形式 | $m$ 整数，$a_i\in\{0,\dots,9\}$，$a_1\neq0$ |
| $\beta,t$ | 浮点基与尾数位数 | IEEE 双精度 $\beta=2,\ t=53$ |
| $\operatorname{fl}(x)$ | 浮点舍入 float | 把实数 $x$ 舍入到浮点集 $F$ 的结果 |
| $u$，$\mathrm{eps}$ | 单位舍入误差 / 机器精度 | $u=\tfrac12\beta^{1-t}$；$\mathrm{eps}=\beta^{1-t}$；双精度 $u=2^{-53}$，$\mathrm{eps}=2^{-52}$ |
| $O(g(n))$ | 计算量阶 big-O | 计算量与 $g(n)$ 同阶增长 |
| $\mathrm{cond}(f,x)$ | 函数条件数 | $\lvert xf'(x)/f(x)\rvert$，[1.2.6](ch01/sec12.md#sec-1.2.6) |

## 向量与矩阵

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $\boldsymbol{x}=(x_1,\cdots,x_n)^{\mathrm T}$ | 向量 | 粗体小写；$\mathbb{R}^n$ 中列向量 |
| $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}$ | 内积 | $\sum_ix_iy_i$；未特别说明时为 Euclid 内积 |
| $\langle\boldsymbol{x},\boldsymbol{y}\rangle$ | 内积（一般记号） | 泛指某一给定的内积，见 [2.1](supplement/sec21.md) |
| $\boldsymbol{x}\perp\boldsymbol{y}$ | 正交 | $\boldsymbol{x}^{\mathrm T}\boldsymbol{y}=0$ |
| $\lVert\boldsymbol{x}\rVert_p$ | 向量 $p$-范数 | $\bigl(\sum\lvert x_i\rvert^p\bigr)^{1/p}$；$p=1,2,\infty$ 最常用 |
| $\lVert\boldsymbol{x}\rVert$ | 泛指的范数 | 不指明用哪一种范数时的泛指记号 |
| $A=[a_{ij}]$ | 矩阵 | 大写斜体；$A\in\mathbb{R}^{m\times n}$ |
| $A^{\mathrm T}$ | 转置 | $[a_{ji}]$ |
| $\operatorname{rank}A$ | 秩 rank | 极大线性无关列数 |
| $\lVert A\rVert_p$ | 矩阵 $p$-范数（从属范数） | $\max_{\boldsymbol{x}\neq0}\lVert A\boldsymbol{x}\rVert_p/\lVert\boldsymbol{x}\rVert_p$ |
| $\lVert A\rVert_F$ | Frobenius 范数 | $\bigl(\sum_{i,j}a_{ij}^2\bigr)^{1/2}$；不是算子范数 |
| $\mathrm{cond}(A)$ | 条件数 | $\lVert A\rVert\lVert A^{-1}\rVert$；2-范数下 $=\sigma_1/\sigma_r$ |
| $\det A$，$\operatorname{tr}A$ | 行列式 / 迹 | 迹 $=\sum_i a_{ii}=\sum_i\lambda_i$ |
| $I$，$O$ | 单位矩阵 / 零矩阵 | 阶数由上下文确定 |

## 子空间、投影与正交分解（补充篇）

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $C(A)$，$\operatorname{Ran}A$ | 列空间 | $\{A\boldsymbol{x}:\boldsymbol{x}\in\mathbb{R}^n\}$ |
| $N(A)$，$\operatorname{Null}A$ | 零空间 | $\{A\boldsymbol{x}=\boldsymbol{0}\}$ |
| $C(A^{\mathrm T})$，$R(A)$ | 行空间 | 与零空间互为正交补 |
| $N(A^{\mathrm T})$ | 左零空间 | 与列空间互为正交补 |
| $\mathcal{S}^{\perp}$ | 正交补 | 与 $\mathcal{S}$ 中每个向量都正交的向量全体 |
| $P$ | 正交投影矩阵 | $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$；对称、幂等 |
| $Q$ | 正交矩阵 / 正交基矩阵 | $Q^{\mathrm T}Q=I$（方阵时 $Q^{-1}=Q^{\mathrm T}$） |
| $A=QR$ | QR 分解 | $Q$ 列正交，$R$ 上三角 |
| $H$，$G$ | Householder 反射 / Givens 旋转 | $H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}/\boldsymbol{v}^{\mathrm T}\boldsymbol v$ |
| $r$，$\boldsymbol r$ | 秩 / 残差向量 | $\boldsymbol r=\boldsymbol b-A\boldsymbol x$ |

## 谱与奇异值（补充篇）

| 符号 | 名称 | 含义 |
|:--|:--|:--|
| $\lambda_i(A)$ | 特征值 | $\det(A-\lambda I)=0$ 的根 |
| $\rho(A)$ | 谱半径 | $\max_i\lvert\lambda_i\rvert$ |
| $\sigma_i(A)$ | 奇异值 | $\sqrt{\lambda_i(A^{\mathrm T}A)}$，降序记为 $\sigma_1\ge\cdots\ge\sigma_r\gt0$ |
| $\lambda_{\max}(A^{\mathrm T}A)$ | 最大特征值 | $A^{\mathrm T}A$ 对称半正定 |
| $A=U\Sigma V^{\mathrm T}$ | 奇异值分解 SVD | $U,V$ 正交，$\Sigma$ 非负对角 |
| $A^{+}$ | Moore–Penrose 伪逆 | $V\Sigma^{+}U^{\mathrm T}$ |
| $\boldsymbol q(\boldsymbol{x})$，$R(\boldsymbol{x})$ | Rayleigh 商 | $\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}/\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$（对称阵） |
| $\kappa(A)$，$\mathrm{cond}_2(A)$ | 谱条件数 | $\sigma_1/\sigma_r$ |
| $\rho\le\lVert A\rVert$ | 谱半径与范数 | 任一相容矩阵范数下成立，见 [2.5](supplement/sec25.md) |

::: note

**记号约定一（误差限 $\varepsilon$）：**与原书一致：四则运算的误差公式一律写成**误差限** $\varepsilon\ge0$ 的形式（如 $\varepsilon(a\pm b)=\varepsilon(a)+\varepsilon(b)$），不使用带符号的误差 $e$。带符号的版本只在 [1.2.3 的思考题](ch01/sec12.md#sec-1.2.3) 与 [习题 B5](ch01/exercises.md) 里讨论。

:::

::: note

**记号约定二（向量加粗）：**向量一律用粗体（本教程排为粗斜体）$\boldsymbol{x}$，分量用小写 $x_i$；矩阵用大写斜体 $A$。原书有些地方把向量排成粗斜体、有些排成正体，本教程统一取粗斜体。

:::

::: note

**记号约定三（谱与从属）：**小写下标 $p$ 既用于向量范数，也用于矩阵范数；用在矩阵范数上时，默认它是**从属于**同名向量范数的算子范数（[1.3.3](ch01/sec13.md#sec-1.3.3)）。$\lVert A\rVert$ 不带下标时，泛指任一满足四公理的相容矩阵范数。此外，2-范数也叫**谱范数**，它的条件数 $\mathrm{cond}_2$ 也叫**谱条件数**。

:::
