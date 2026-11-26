# 第十章总结 · 移动机器人建模

移动机器人不再固定于单一基座，它必须在一套自由坐标系下同时处理「自身在哪」和「这一刻哪些速度被轮子锁死」。本章把轮式平台从几何建系一路推到李代数可控性与动力学扩展。

## 一条主线

$$\text{坐标系与 }SE(2)\text{（}\S10.2\text{）}\ \xrightarrow{v_y^B=0}\ \text{Pfaffian 约束 }A^{\mathrm T}\dot q=0\text{（}\S10.3\text{）}\ \xrightarrow{\text{零空间基}}\ \dot q=G(q)u\ \xrightarrow{[g_i,g_j]\text{ 与 Chow}}\ \text{可控性（}\S10.4\text{–}10.5\text{）}$$

外加一条进阶接口：$(2,n)$-链式系统用于理论上构造可行轨迹，二阶扩展与带约束 Euler-Lagrange 方程把速度输入推进到加速度与电机力矩（[§10.6](sec10-6.md)）。

## 三大核心对照

| 主题 | 关键对象 | 核心判据／公式 | 易错点 |
|:--|:--|:--|:--|
| 约束分类 | 完整 $h(q)=0$ vs 非完整 $A^{\mathrm T}(q)\dot q=0$ | 单约束看积分因子 $\gamma(q)$；一般看 $\Delta(q)$ 是否对合 | 多条单独不可积的约束，线性组合仍可能可积 |
| 可控性 | 分布 $\Delta$、李括号 $[g_i,g_j]$、对合闭包 $\bar\Delta$ | $\operatorname{rank}(\bar\Delta(q))=n \iff$ 无漂移系统可控（Chow 定理） | 误以为「非完整 = 不可控」或漏算高阶括号 |
| 轮式模型 | 独轮车／差速小车／后驱与前驱两轮车 | 独轮车 $\kappa=2, n=3$；两轮车 $\kappa=3, n=4,\ \det\neq 0$ | 前驱两轮车须乘投影因子 $\cos\phi$ |

## 常用核心公式

**速度坐标变换与无侧滑约束**（[§10.2](sec10-2.md)、[§10.3](sec10-3.md)）：

$$\begin{bmatrix}\dot x\\\dot y\end{bmatrix}=\begin{bmatrix}\cos\theta&-\sin\theta\\\sin\theta&\cos\theta\end{bmatrix}\begin{bmatrix}v_x^B\\v_y^B\end{bmatrix},\qquad \dot x\sin\theta-\dot y\cos\theta=0$$

**李括号、独轮车与差速等效**（[§10.4](sec10-4.md)、[§10.5](sec10-5.md)）：

$$[g_1,g_2]=\frac{\partial g_2}{\partial q}g_1-\frac{\partial g_1}{\partial q}g_2,\qquad v=\frac{r(\omega_R+\omega_L)}{2},\qquad \omega=\frac{r(\omega_R-\omega_L)}{d}$$

**后驱两轮车与含非完整约束动力学**（[§10.5](sec10-5.md)、[§10.6](sec10-6.md)）：

$$\dot q=\begin{bmatrix}\cos\theta&0\\\sin\theta&0\\\frac{1}{l}\tan\phi&0\\0&1\end{bmatrix}\begin{bmatrix}v\\\dot\phi\end{bmatrix},\qquad M(q)\ddot q+C(q,\dot q)\dot q+g(q)=A^{\mathrm T}(q)\lambda+B(q)\tau,\quad A(q)\dot q=0$$

符号口径对照、两轮车链式输入公式核正与编号重排说明见[勘误与符号说明](errata.md)。
