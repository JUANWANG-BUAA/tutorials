# 6.7 操作空间动力学模型（选学·精简）

许多机器人的作业任务（装配插孔、曲面打磨、柔顺力控制）天然定义在末端执行器的位置与姿态坐标系下，即[第 3 章](../ch03/sec3-6.md)所称的**操作空间（operational space）**。若直接依据操作空间位姿误差设计前馈与反馈控制律（见第 7–8 章），需要把建立在关节角 $\boldsymbol q$ 上的动力学模型直接改写为末端位姿变量 $\boldsymbol x_e$ 的微分方程。本节推导这一转换模型，并厘清**伪动能**、**机械臂奇点**与**冗余零空间**三条关键限制。

## 6.7.1 分析雅可比与二阶运动学联系

采用最小位姿描述 $\boldsymbol x_e = [\boldsymbol p_e^{\mathrm T},\,\boldsymbol\phi_e^{\mathrm T}]^{\mathrm T}\in\mathbb R^m$（其中 $\boldsymbol\phi_e$ 为如 ZYZ 欧拉角之类的最小姿态参数化；当末端位姿完整 6 维时 $m=6$，平面任务等子空间时取对应维数 $m$）。借助[第 3 章 3.6 节](../ch03/sec3-6.md#sec-3.6.1)区分**分析雅可比 $J_A(\boldsymbol q)$** 与**几何雅可比 $J(\boldsymbol q)$**：

$$\dot{\boldsymbol x}_e = J_A(\boldsymbol q)\dot{\boldsymbol q},\qquad \boldsymbol v_e = \begin{bmatrix}\dot{\boldsymbol p}_e\\ \boldsymbol\omega_e\end{bmatrix} = J(\boldsymbol q)\dot{\boldsymbol q} = T_A(\boldsymbol\phi_e)J_A(\boldsymbol q)\dot{\boldsymbol q},$$

其中 $T_A(\boldsymbol\phi_e)=\operatorname{blockdiag}(\boldsymbol E_3, T(\boldsymbol\phi_e))$ 为从分析速度向量 $\dot{\boldsymbol x}_e$ 到空间几何旋量 $\boldsymbol v_e$ 的转换矩阵（在姿态参数化非奇异的光滑域内可逆）。对分析速度再次对时间求导，建立关节加速度与操作空间加速度的关系：

$$\ddot{\boldsymbol x}_e = J_A(\boldsymbol q)\ddot{\boldsymbol q} + \dot J_A(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}.$$

注意 $\dot J_A\dot{\boldsymbol q}$ 项不可省略，它反映了构型随时间变化对末端加速的二阶几何贡献。

## 6.7.2 一般变换推导（$J_A$ 满行秩）

忽略关节摩擦，出发于关节空间主方程（其中接触广义力借虚功转置关系 $\boldsymbol\tau_e = J^{\mathrm T}\boldsymbol h_e = J_A^{\mathrm T}T_A^{\mathrm T}\boldsymbol h_e = J_A^{\mathrm T}\boldsymbol h_A$ 等效至操作空间广义接触力 $\boldsymbol h_A$，同理等效驱动广义力记 $\boldsymbol\gamma_A$，满足功率共轭 $\boldsymbol\tau = J_A^{\mathrm T}(\boldsymbol q)\boldsymbol\gamma_A$）：

$$B(\boldsymbol q)\ddot{\boldsymbol q} + C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q} + \boldsymbol g(\boldsymbol q) = \boldsymbol\tau - J_A^{\mathrm T}\boldsymbol h_A.$$

由于 $B(\boldsymbol q)$ 对称正定，左乘 $J_AB^{-1}$ 解出 $J_A\ddot{\boldsymbol q}$ 并代入加速度表达式 $\ddot{\boldsymbol x}_e - \dot J_A\dot{\boldsymbol q} = J_A\ddot{\boldsymbol q}$：

$$\ddot{\boldsymbol x}_e = J_A B^{-1}\bigl(\boldsymbol\tau - J_A^{\mathrm T}\boldsymbol h_A\bigr) - J_AB^{-1}\bigl(C\dot{\boldsymbol q}+\boldsymbol g\bigr) + \dot J_A\dot{\boldsymbol q}.$$

假设**机械臂处于非奇异构型且 $J_A(\boldsymbol q)\in\mathbb R^{m\times n}$ 满行秩（$n\ge m$）**，则 $m\times m$ 对称矩阵 $J_AB^{-1}J_A^{\mathrm T}$ 正定可逆，定义**操作空间等效惯量矩阵（operational space inertia matrix）**：

$$\boxed{\ B_A = \bigl(J_A B^{-1}J_A^{\mathrm T}\bigr)^{-1}\ }$$

将上式两端同时左乘 $B_A$，注意若令关节控制取操作力偶映射 $\boldsymbol\tau = J_A^{\mathrm T}\boldsymbol\gamma_A$（当存在运动冗余时忽略零空间自运动力矩，仅看任务空间投影部分），恰好满足 $B_A(J_AB^{-1}J_A^{\mathrm T})(\boldsymbol\gamma_A-\boldsymbol h_A) = \boldsymbol\gamma_A-\boldsymbol h_A$。移项并定义任务空间速度与重力耦合项：

$$C_A\dot{\boldsymbol x}_e = B_AJ_AB^{-1}C\dot{\boldsymbol q} - B_A\dot J_A\dot{\boldsymbol q},\qquad \boldsymbol g_A = B_AJ_AB^{-1}\boldsymbol g,$$

由此获得与关节空间结构完全平行的**操作空间动力学模型**：

$$\boxed{\ B_A\ddot{\boldsymbol x}_e + C_A\dot{\boldsymbol x}_e + \boldsymbol g_A = \boldsymbol\gamma_A - \boldsymbol h_A\ }$$

（若把最小姿态角导数换成几何角速度 $\boldsymbol v_e$ 与 $J$，只需把各处 $J_A$ 换作几何雅可比 $J$、$\boldsymbol h_A$ 换作 $\boldsymbol h_e$，同样得到 $B_x\dot{\boldsymbol v}_e+C_x\boldsymbol v_e+\boldsymbol g_x=\boldsymbol\gamma_e-\boldsymbol h_e$。）

## 6.7.3 非冗余特例、伪动能与冗余陷阱

1. **非冗余方阵特例（$n=m$ 且 $J_A$ 可逆）**：此时矩阵求逆展开为合同变换形式：

$$B_A = J_A^{-\mathrm T}BJ_A^{-1},\qquad C_A = J_A^{-\mathrm T}CJ_A^{-1} - B_A\dot J_AJ_A^{-1},\qquad \boldsymbol g_A = J_A^{-\mathrm T}\boldsymbol g.$$

在此条件下代入动能二次型有 $\frac12\dot{\boldsymbol x}_e^{\mathrm T}B_A\dot{\boldsymbol x}_e = \frac12\dot{\boldsymbol q}^{\mathrm T}J_A^{\mathrm T}(J_A^{-\mathrm T}BJ_A^{-1})J_A\dot{\boldsymbol q} = \frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}=T$，与物理总动能严格相等（参见[作业六·补 7-10](homework06b.md)验证非冗余下 $\dot B_A-2C_A$ 同样严格反对称）。

2. **冗余情况（$n>m$）下的“伪动能”与构造反例**：当自由度存在冗余时，允许存在不引发任何末端运动（$\dot{\boldsymbol x}_e=\boldsymbol 0$）但关节在零空间内部摆动的速度分量 $\dot{\boldsymbol q}_{\mathrm{null}}\neq\boldsymbol 0$。此时任务二次型 $\frac12\dot{\boldsymbol x}_e^{\mathrm T}B_A\dot{\boldsymbol x}_e$ **仅表示任务投影能（常称“伪动能”，kinetic pseudo-energy）**，漏掉了内部零空间运动的真实动能，且 $B_A,C_A,\boldsymbol g_A$ 通常无法脱离当前关节构型 $\boldsymbol q$ 单独写成 $\boldsymbol x_e$ 的函数。

::: ex 注记 · 为什么 $B_A$ 未必只是末端位姿 $\boldsymbol x_e$ 的函数？
考虑两自由度双移动机械臂，仅取末端横坐标 $x=q_1$ 作为一维操作任务，则 $J_A=[1\ \ 0]$ 恒满行秩。设质量矩阵 $B(\boldsymbol q)=\operatorname{diag}\bigl(1+(q_2/L)^2,\ 1\bigr)\ \mathrm{kg}$（$L=1\ \mathrm m$）。按公式计算操作空间惯量得

$$B_A = (J_AB^{-1}J_A^{\mathrm T})^{-1} = 1 + \left(\frac{q_2}{L}\right)^2\ \mathrm{kg}.$$

虽然 $J_A$ 到处满行秩、$B_A$ 明确存在且与工作空间坐标 $x$ 毫无关系，但只要第二个冗余关节 $q_2$ 在零空间中改变位置，末端沿 $x$ 方向体现出的有效质量就随 $q_2$ 改变。同理，如果施加在 $\boldsymbol\tau$ 中的控制包含零空间力矩成分，在构造操作空间模型时也必须保留零空间自运动耦合，不能直接假设系数仅由 $(\boldsymbol x_e,\dot{\boldsymbol x}_e)$ 封闭决定。
:::

## 本节小结

- **公式结构对称，依赖雅可比性态**：操作空间有效惯量为 $B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$（而非直接投影 $J_ABJ_A^{\mathrm T}$），且仅在非奇异（$J_A$ 满行秩）与姿态表示非奇异区间成立。
- **转置耦合规律不要反写**：$\boldsymbol\tau = J_A^{\mathrm T}(\boldsymbol q)\boldsymbol\gamma_A$（末端广义力经雅可比转置映射到关节侧力矩）。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 102:53 | [opspace-background.jpg](../assets/ch06/opspace-background.jpg) | 操作空间建模提出背景 | 6.7 开篇说明控制动机 |
| 107:00 实况 | [opspace-board.jpg](../assets/ch06/opspace-board.jpg) | 课堂板书讲解 | 全部推导已写入 6.7.1–6.7.2 |
| 110:28 | [opspace-jacobians.jpg](../assets/ch06/opspace-jacobians.jpg) | 几何与分析雅可比转换关系 | 6.7.1 引入 $T_A$ 及二阶加速度展开 |
| 110:55 | [opspace-BA.jpg](../assets/ch06/opspace-BA.jpg) | 操作空间矩阵 $B_A,C_A,\boldsymbol g_A$ 定义 | 6.7.2–6.7.3 一般推导 + 非冗余合同变换化简 |
| 111:55 | [opspace-summary.jpg](../assets/ch06/opspace-summary.jpg) | 关节与操作空间量对应关系 | 已并入符号转换说明与反例 |
| 112:43 | [opspace-redundant.jpg](../assets/ch06/opspace-redundant.jpg) | 奇点与冗余限制 | 6.7.3 用显式移动臂反例澄清冗余与伪动能边界 |
:::
