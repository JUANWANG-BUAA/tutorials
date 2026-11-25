# 闭卷回忆卡 · 第十章：移动机器人建模

本页不是摘要，而是一组**检索练习**。先只看问题，在草稿纸上写出答案再展开核对。全章共 **20 张卡**（定义 5 / 结论 5 / 公式 6 / 陷阱 4），一轮约 30 分钟。

> **用法**：遮住答案落笔写；标记：**✓** 完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起。下一轮只重做 △ 与 ×。

## A. 定义卡（5 张）

### A1 · 移动机器人三要素

说出移动机器人定义的三个核心关键词及各自含义。

::: sol A1 核对
1. **在环境中**：在室内、仓库、室外、太空或水下等大尺度环境运行，不固定于底座；
2. **自主改变位置／姿态**：整体位置与朝向均可变，合称位姿；
3. **机器人**：包含完整的感知、规划与控制系统，非单纯遥控底盘。（[10.1.1](sec10-1.md#def-10.1.1)）
:::

### A2 · 完整约束与非完整约束

写出完整约束与 Pfaffian 运动学约束的数学形式，并说明两者差在哪。

::: sol A2 核对
完整约束：$h_i(q)=0$（直接限制位形，将位形流形降维至 $n-k$ 维）。Pfaffian 约束：$A^T(q)\dot q=0$（限制切空间瞬时速度）。任意完整约束求导必得 Pfaffian 约束；反之若 Pfaffian 约束无法积分出 $h(q)=0$，即为非完整约束——限速度不限最终可达位置。（[10.3.2](sec10-3.md#def-10.3.1)）
:::

### A3 · 无漂移系统

什么叫无漂移系统（driftless system）？写出其标准形式并举一个「有漂移」的反例。

::: sol A3 核对
形如 $\dot q = G(q)u$ 的系统，当输入 $u=0$ 时必有 $\dot q=0$（不给速度输入就静止），称为无漂移系统。反例：漂移赛车、导弹，以及把速度提升为状态的二阶动力学系统——输入（力/加速度）为零时，惯性仍使状态继续变化。（[10.3.4](sec10-3.md#sec-10.3.4)、[10.6.3](sec10-6.md#sec-10.6.3)）
:::

### A4 · 分布与对合闭包

什么是分布 $\Delta(q)$、对合性（involutive）与非完整度 $\kappa$？

::: sol A4 核对
$\Delta(q)=\operatorname{span}\{g_1(q),\dots,g_m(q)\}\subset T_q(\mathcal Q)$ 是当前容许瞬时速度张成的切子空间。若其中任意两个向量场的李括号仍在 $\Delta$ 内，称 $\Delta$ 对合。否则逐层并入 $[\Delta_1,\Delta_{i-1}]$ 直到秩不再增加，达到稳定所需的最小层数 $\kappa$ 叫非完整度，稳定的最小对合分布 $\Delta_\kappa=\bar\Delta$ 叫对合闭包。（[10.4.2](sec10-4.md#def-10.4.2)）
:::

### A5 · 可控性 vs 可达性

无漂移系统可控性的定义是什么？它与可达性有何区别？

::: sol A5 核对
可控性：对状态空间中**任意** $q_0,q_1\in\mathbb R^n$，均存在有限时间 $T>0$ 与可调输入 $u(t)$ 将系统从 $q_0$ 送到 $q_1$。可达性只关心从某个给定初态 $q_0$ 出发能到达哪些目标状态集合；可控性是全局性质。（[10.4.3](sec10-4.md#def-10.4.4)）
:::

## B. 结论卡（5 张）

### B1 · 为什么 LLA 不能直接用于运动学建模

::: sol B1 核对
LLA（经纬高）是球面地理坐标，不同纬度下经度与纬度的米/度尺度不同且非局部正交直角系。工程中须先将其转换为局部惯性系或 ENU 东北天坐标系，再建立平面运动学方程。（[10.2.2](sec10-2.md#sec-10.2.2)）
:::

### B2 · Frobenius 定理结论

::: sol B2 核对
光滑等维分布 $\Delta$ 是对合的 $\iff$ $\Delta$ 是可积的（存在完整约束 $h(q)=0$）。因此判断多条 Pfaffian 约束是否完整，不必硬凑积分，只需检查 $\Delta$ 在李括号运算下是否封闭。（[10.4.3](sec10-4.md#thm-10.4.1)）
:::

### B3 · Chow 定理结论

::: sol B3 核对
无漂移系统 $\dot q = G(q)u$ 全局可控 $\iff$ 对所有 $q\in\mathbb R^n$，控制李代数的秩等于位形空间维数：$\operatorname{rank}(\bar\Delta(q))=n$（可控性秩条件），即系统是**完全非完整**的。（[10.4.3](sec10-4.md#thm-10.4.2)）
:::

### B4 · 为什么独轮车模型适用范围最广

::: sol B4 核对
独轮车抽象掉了具体轮系和执行机构，只保留前向线速度 $v$ 与转向角速度 $\omega$ 两个基本控制量。在地面平坦、低速、无侧滑假设下，差速驱动小车、履带式机器人与对称双轮 AGV 都可严格或近似等效为独轮车。（[10.5.2](sec10-5.md#sec-10.5.2)）
:::

### B5 · 链式系统的定位与工程替代

::: sol B5 核对
$(2,n)$-链式系统通过坐标与输入变换把耦合三角函数化成级联形式，再用「先调基变量、再周期振荡调纤维变量」证明可控性与构造可行轨迹；但变换繁琐且真实车辆有速度/转角限幅，工程轨迹规划更常用**微分平坦、曲线拼接或 MPC**。（[10.6.2](sec10-6.md#sec-10.6.2)）
:::

## C. 公式卡（6 张）

### C1 · 速度旋转变换与无侧滑 Pfaffian 约束

默写世界系 $(\dot x,\dot y)^{\mathrm T}$ 与载体系 $(v_x^B,v_y^B)^{\mathrm T}$ 关系，并令 $v_y^B=0$ 导出 Pfaffian 约束。

::: sol C1 核对
$\begin{bmatrix}\dot x\\\dot y\end{bmatrix}=\begin{bmatrix}\cos\theta&-\sin\theta\\\sin\theta&\cos\theta\end{bmatrix}\begin{bmatrix}v_x^B\\v_y^B\end{bmatrix}$；求逆得 $v_y^B=-\dot x\sin\theta+\dot y\cos\theta=0 \implies \dot x\sin\theta-\dot y\cos\theta=0$。（(10.2-3)、(10.3-1)）
:::

### C2 · 李括号计算式

写出 $[g_1, g_2](q)$ 的定义式，并默写独轮车的 $[g_1, g_2]$ 结果。

::: sol C2 核对
$[g_1,g_2](q)=\frac{\partial g_2}{\partial q}g_1-\frac{\partial g_1}{\partial q}g_2$。对独轮车 $g_1=[\cos\theta,\sin\theta,0]^{\mathrm T},\ g_2=[0,0,1]^{\mathrm T}$，算出 $g_3=[g_1,g_2]=[\sin\theta,\ -\cos\theta,\ 0]^{\mathrm T}$。（(10.4-2)、(10.5-2)）
:::

### C3 · 差速驱动等效公式

写出轮半径 $r$、轮距 $d$、左右轮角速度 $\omega_L,\omega_R$ 到独轮车 $(v,\omega)$ 的映射。

::: sol C3 核对
$v=\dfrac{r(\omega_R+\omega_L)}{2}$，$\omega=\dfrac{r(\omega_R-\omega_L)}{d}$。（(10.5-3)）
:::

### C4 · 后驱与前驱两轮车运动学方程

分别写出后轮驱动与前轮驱动两轮车的 $\dot x,\dot y,\dot\theta,\dot\phi$。

::: sol C4 核对
后驱：$\dot x=v\cos\theta,\ \dot y=v\sin\theta,\ \dot\theta=\frac{v}{l}\tan\phi,\ \dot\phi=\dot\phi$；前驱：$\dot x=v\cos\phi\cos\theta,\ \dot y=v\cos\phi\sin\theta,\ \dot\theta=\frac{v}{l}\sin\phi,\ \dot\phi=\dot\phi$。（(10.5-4)、(10.5-7)）
:::

### C5 · 独轮车 $(2,3)$-链式变换

写出独轮车化为 $\dot z_1=v_1,\ \dot z_2=v_2,\ \dot z_3=z_2 v_1$ 的坐标与输入变换。

::: sol C5 核对
$z_1=\theta,\ z_2=x\cos\theta+y\sin\theta,\ z_3=x\sin\theta-y\cos\theta$；$\omega=v_1,\ v=v_2+z_3 v_1$。（(10.6-2)）
:::

### C6 · 含非完整约束的 Euler-Lagrange 方程

写出以 $A(q)\dot q=0\ (A\in\mathbb R^{k\times n})$ 为约束、执行器力矩 $\tau$ 的完整动力学方程。

::: sol C6 核对
$M(q)\ddot q+C(q,\dot q)\dot q+g(q)=A^T(q)\lambda+B(q)\tau,\quad A(q)\dot q=0$。（(10.6-6)）
:::

## D. 陷阱卡（4 张）

### D1 · 单 constraint 不可积 $\implies$ 系统一定非完整？

::: sol D1 核对
**错**。多条 Pfaffian 约束即使每条单独看均不可积，它们的线性组合仍可能消去交叉项从而积分为完整约束 $h(q)=0$（[@ex-10.3.2]：$q_1 a_1+a_2$）。必须用分布的对合性统一判定。（[10.3.3](sec10-3.md#ex-10.3.2)）
:::

### D2 · 检验两轮车 $\{g_1,g_2,g_3,g_4\}$ 满秩时算内积？

::: sol D2 核对
**错**。$g_1$ 与 $g_3$ 的 $\theta$ 分量均非零，并不正交。判断 4 个向量是否张满 $\mathbb R^4$ 必须拼成 $4\times 4$ 矩阵计算行列式 $\det([g_1,g_2,g_3,g_4])=\frac{1}{l^2\cos^4\phi}\neq 0$，无需正交。（[10.5.3](sec10-5.md#sec-10.5.3)）
:::

### D3 · 写可积性条件时直接检查 $\partial a_i/\partial q_j = \partial a_j/\partial q_i$？

::: sol D3 核对
**错**。同一速度零空间允许协向量差一个标量函数，必须先乘非零光滑积分因子 $\gamma(q)$，检验 $\frac{\partial(\gamma a_i)}{\partial q_j}=\frac{\partial(\gamma a_j)}{\partial q_i}$ 是否存在非零解 $\gamma(q)$。（[10.3.3](sec10-3.md#thm-10.3.1)）
:::

### D4 · 用机械臂无约束动力学直接仿真轮式机器人？

::: sol D4 核对
**错**。漏掉了阻止侧滑的静摩擦广义约束反力 $A^T(q)\lambda$ 与速度约束 $A(q)\dot q=0$，或者把动力学中的 $A(q)\dot q=0$ 与前文 $A^T(q)\dot q=0$ 的转置记号混用。（[10.6.3](sec10-6.md#sec-10.6.3)）
:::
