# 6.4 牛顿–欧拉递推

[6.1 节](sec6-1.md)通过拉格朗日标量能量导出了关节空间的封闭矩阵形式 $B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau$（已含约束内力消元），但表达式展开极其冗长，高自由度机械臂难以每次实时计算全矩阵元素。**牛顿–欧拉递推算法（Recursive Newton–Euler, RNE）** 直接在每根连杆上列写平动与转动动力学平衡：尽管引入了杆间关节反力，但因为运动量只向末端传递、受力只向基座传递，计算复杂度降至随自由度线性增长的 $O(n)$，成为机器人实时逆动力学控制与仿真的标准核心算法（对应原书 §7.4，式号 (7.107)–(7.114)）。

## 6.4.1 单刚体动量定理与动量矩定理预备式

对质量分布密度为 $\rho(\boldsymbol p)$ 的刚体微元 $\mathrm dm=\rho\,\mathrm dV$，定义系统的总动量、关于空间参考点 $\Omega$ 的角动量以及外力系简化主矢与主矩：

$$\boldsymbol l = \int_{V_B}\dot{\boldsymbol p}\rho\,\mathrm dV = m\dot{\boldsymbol p}_C,\qquad \boldsymbol k_\Omega = \int_{V_B}\dot{\boldsymbol p}\times(\boldsymbol p_\Omega-\boldsymbol p)\rho\,\mathrm dV = \boldsymbol I_C\boldsymbol\omega + m\dot{\boldsymbol p}_C\times(\boldsymbol p_\Omega-\boldsymbol p_C),$$

$$\boldsymbol f = m\boldsymbol g_0+\sum_j\boldsymbol f_j,\qquad \boldsymbol\mu_\Omega = m\boldsymbol g_0\times(\boldsymbol p_\Omega-\boldsymbol p_C)+\sum_j\boldsymbol f_j\times(\boldsymbol p_\Omega-\boldsymbol p_j).$$

两条一般机械系统动力学定理（适用于恒质量及变质量刚体）表明：

$$\boldsymbol f = \frac{\mathrm d\boldsymbol l}{\mathrm dt},\qquad \boldsymbol\mu_\Omega = \frac{\mathrm d\boldsymbol k_\Omega}{\mathrm dt}+\dot{\boldsymbol p}_\Omega\times\boldsymbol l.$$

参考点取在**质心 $C$**（此时 $\dot{\boldsymbol p}_C\times m\dot{\boldsymbol p}_C=\boldsymbol 0$）并利用质量恒定刚体的惯性张量坐标变换 $\boldsymbol I_C=\boldsymbol R\boldsymbol I_C^b\boldsymbol R^{\mathrm T}$ 及 $\dot{\boldsymbol R}=S(\boldsymbol\omega)\boldsymbol R$、$\dot{\boldsymbol R}^{\mathrm T}=-\boldsymbol R^{\mathrm T}S(\boldsymbol\omega)$ 求导：

$$\frac{\mathrm d}{\mathrm dt}\bigl(\boldsymbol I_C\boldsymbol\omega\bigr) = S(\boldsymbol\omega)\boldsymbol I_C\boldsymbol\omega + \boldsymbol I_C S^{\mathrm T}(\boldsymbol\omega)\boldsymbol\omega + \boldsymbol I_C\dot{\boldsymbol\omega} = \boldsymbol I_C\dot{\boldsymbol\omega} + \boldsymbol\omega\times(\boldsymbol I_C\boldsymbol\omega).$$

其中中间项 $S^{\mathrm T}(\boldsymbol\omega)\boldsymbol\omega=-\boldsymbol\omega\times\boldsymbol\omega=\boldsymbol 0$。于是获得单刚体质心处的**牛顿方程**与**欧拉方程**：

$$\boldsymbol f = m\ddot{\boldsymbol p}_C,\qquad \boldsymbol\mu_C = \boldsymbol I_C\dot{\boldsymbol\omega} + \boldsymbol\omega\times(\boldsymbol I_C\boldsymbol\omega).$$

## 6.4.2 扩展连杆约定与单连杆平衡方程

为与 [6.1–6.2 节](sec6-2.md#part-6.2.2) 保持完全统一的电机转子模型，将“**连杆 $i$ 本体 + 安装于其上的关节 $i+1$ 驱动电机锁转部分**”合并称为**扩展连杆 $i$**（质量 $m_i$，相对其自身质心 $C_i$ 的锁转惯性张量 $\bar{\boldsymbol I}_i$；假定转子轴对称且质心位于转轴上；末杆 $n$ 无下一关节电机故附加转子项为零）。各常用向量定义如下：

| 符号 | 物理含义 | 符号 | 物理含义 |
|:--|:--|:--|:--|
| $m_i,\ \bar{\boldsymbol I}_i$ | 扩展连杆 $i$ 总质量、质心锁转惯性张量 | $\boldsymbol\omega_i,\ \dot{\boldsymbol\omega}_i$ | 连杆 $i$ 绝对角速度、角加速度 |
| $\boldsymbol r_{i-1,i},\ \boldsymbol r_{i,C_i}$ | 原点 $O_{i-1}\to O_i$、$O_i\to C_i$ 的矢径 | $\boldsymbol\omega_{m_i},\ \dot{\boldsymbol\omega}_{m_i}$ | 关节 $i$ 电机转子绝对角速度、角加速度 |
| $\boldsymbol r_{i-1,C_i}$ | 原点 $O_{i-1}\to C_i$（等于 $\boldsymbol r_{i-1,i}+\boldsymbol r_{i,C_i}$） | $\boldsymbol f_i,\ \boldsymbol\mu_i$ | 连杆 $i-1$ 对连杆 $i$ 施加的力与关于 $O_{i-1}$ 的力矩 |
| $\dot{\boldsymbol p}_i,\ \ddot{\boldsymbol p}_i$ | 连杆系原点 $O_i$ 的绝对线速度、线加速度 | $-\boldsymbol f_{i+1},\ -\boldsymbol\mu_{i+1}$ | 连杆 $i+1$ 对连杆 $i$ 施加的反力与关于 $O_i$ 的反力矩 |
| $\dot{\boldsymbol p}_{C_i},\ \ddot{\boldsymbol p}_{C_i}$ | 质心 $C_i$ 的绝对线速度、线加速度 | $\boldsymbol g_0$ | 基坐标系中的重力加速度矢量 |

::: note 必防的参考点陷阱：$\boldsymbol\mu_i$ 关于 $O_{i-1}$，$\boldsymbol\mu_{i+1}$ 关于 $O_i$
两界面主矩不在同一点定义，把它们共同归并到质心 $C_i$ 上取矩时，必须分别加上界面力 $\boldsymbol f_i$ 对 $C_i$ 的力臂矩 $\boldsymbol f_i\times\boldsymbol r_{i-1,C_i}$ 以及 $-\boldsymbol f_{i+1}$ 对 $C_i$ 的力臂矩 $-\boldsymbol f_{i+1}\times\boldsymbol r_{i,C_i}$；同时重力通过质心 $C_i$，力臂为零，因此**重力只出现在牛顿方程，绝不出现在质心欧拉方程中**。
:::

对扩展连杆 $i$ 列写牛顿方程和含电机 $i+1$ 相对自转角动量 $k_{r,i+1}\dot q_{i+1}I_{m_{i+1}}\boldsymbol z_{m_{i+1}}$（注意 $\dot{\boldsymbol z}_{m_{i+1}}=\boldsymbol\omega_i\times\boldsymbol z_{m_{i+1}}$）的欧拉方程：

$$\boldsymbol f_i - \boldsymbol f_{i+1} + m_i\boldsymbol g_0 = m_i\ddot{\boldsymbol p}_{C_i},$$

$$\begin{aligned}
\boldsymbol\mu_i + \boldsymbol f_i\times\boldsymbol r_{i-1,C_i} - \boldsymbol\mu_{i+1} - \boldsymbol f_{i+1}\times\boldsymbol r_{i,C_i}
&= \bar{\boldsymbol I}_i\dot{\boldsymbol\omega}_i + \boldsymbol\omega_i\times(\bar{\boldsymbol I}_i\boldsymbol\omega_i) \\
&\quad + k_{r,i+1}\ddot q_{i+1}I_{m_{i+1}}\boldsymbol z_{m_{i+1}} + k_{r,i+1}\dot q_{i+1}I_{m_{i+1}}\,\boldsymbol\omega_i\times\boldsymbol z_{m_{i+1}}.
\end{aligned}$$

其中对转动关节 $q_i=\vartheta_i$（$k_{r_i}$ 无量纲），对由旋转驱动的移动关节用 $q_i=d_i$（$k_{r_i}$ 单位 $\mathrm{rad/m}$），$I_{m_i}$ 均为转子侧轴向转动惯量。随后将界面力矩投影到驱动关节轴 $\boldsymbol z_{i-1}$ 上，并补充驱动关节 $i$ 自身转子的加减速反作用（含粘滞摩擦项可随后在关节侧叠加），得到**关节驱动广义力（原书式 (7.114)）**：

$$\boxed{\ \tau_i = \begin{cases}
\boldsymbol f_i^{\mathrm T}\boldsymbol z_{i-1} + k_{r_i}I_{m_i}\dot{\boldsymbol\omega}_{m_i}^{\mathrm T}\boldsymbol z_{m_i}, & \text{移动关节}\\[4pt]
\boldsymbol\mu_i^{\mathrm T}\boldsymbol z_{i-1} + k_{r_i}I_{m_i}\dot{\boldsymbol\omega}_{m_i}^{\mathrm T}\boldsymbol z_{m_i}, & \text{旋转关节}
\end{cases}\ }$$

注意下标分工：欧拉方程右侧出现的是装在当前连杆上的**下一个转子 $i+1$**，而关节 $i$ 的投影式补偿的是**本关节转子 $i$**（由 $k_{r_i}\dot{\boldsymbol\omega}_{m_i}^{\mathrm T}\boldsymbol z_{m_i}$ 中自带的 $k_{r_i}\ddot q_i$ 共同构成完整的 $k_{r_i}^2I_{m_i}\ddot q_i$）。

## 6.4.3 两遍递推算法流程（式 (7.107)–(7.114)）

### 第一遍：向外（前向）递推运动量（$i=1\to n$）

在基座固定条件下初始化运动初值，并采用**虚拟基座加速法吸收重力**：

$$\boldsymbol\omega_0 = \boldsymbol 0,\qquad \dot{\boldsymbol\omega}_0 = \boldsymbol 0,\qquad \dot{\boldsymbol p}_0 = \boldsymbol 0,\qquad \ddot{\boldsymbol p}_0 = -\boldsymbol g_0.$$

这一代数替换相当于把整个惯性系下所有物理线加速度统一平移 $-\boldsymbol g_0$，此后所有 $\ddot{\boldsymbol p}_{C_i}$ 均代表“实际质心加速度减重力加速度”，从而消去牛顿方程里显式的 $+m_i\boldsymbol g_0$（切勿混用两种做法导致重力算两遍）。

按从基座到末端的顺序递推每杆运动量（前 5 式对应 (7.107)–(7.111)）：

1. **连杆角速度 (7.107)**：

$$\boldsymbol\omega_i = \begin{cases}\boldsymbol\omega_{i-1}, & \text{移动}\\ \boldsymbol\omega_{i-1}+\dot q_i\boldsymbol z_{i-1}, & \text{旋转}\end{cases}$$

2. **连杆角加速度 (7.108)**（旋转关节因关节轴 $\boldsymbol z_{i-1}$ 随杆 $i-1$ 转动产生进动耦合 $\dot q_i\,\boldsymbol\omega_{i-1}\times\boldsymbol z_{i-1}$）：

$$\dot{\boldsymbol\omega}_i = \begin{cases}\dot{\boldsymbol\omega}_{i-1}, & \text{移动}\\ \dot{\boldsymbol\omega}_{i-1}+\ddot q_i\boldsymbol z_{i-1}+\dot q_i\,\boldsymbol\omega_{i-1}\times\boldsymbol z_{i-1}, & \text{旋转}\end{cases}$$

3. **坐标系原点线加速度 (7.109)**（移动关节因沿旋转连杆滑动多出**科氏加速度** $2\dot d_i\,\boldsymbol\omega_i\times\boldsymbol z_{i-1}$）：

$$\ddot{\boldsymbol p}_i = \begin{cases}
\ddot{\boldsymbol p}_{i-1}+\ddot d_i\boldsymbol z_{i-1}+2\dot d_i\,\boldsymbol\omega_i\times\boldsymbol z_{i-1}+\dot{\boldsymbol\omega}_i\times\boldsymbol r_{i-1,i}+\boldsymbol\omega_i\times(\boldsymbol\omega_i\times\boldsymbol r_{i-1,i}), & \text{移动}\\[2pt]
\ddot{\boldsymbol p}_{i-1}+\dot{\boldsymbol\omega}_i\times\boldsymbol r_{i-1,i}+\boldsymbol\omega_i\times(\boldsymbol\omega_i\times\boldsymbol r_{i-1,i}), & \text{旋转}
\end{cases}$$

4. **连杆质心线加速度 (7.110)**：

$$\ddot{\boldsymbol p}_{C_i} = \ddot{\boldsymbol p}_i + \dot{\boldsymbol\omega}_i\times\boldsymbol r_{i,C_i} + \boldsymbol\omega_i\times(\boldsymbol\omega_i\times\boldsymbol r_{i,C_i}).$$

5. **转子角加速度 (7.111)**（转子轴随安装座 $i-1$ 旋转）：

$$\dot{\boldsymbol\omega}_{m_i} = \dot{\boldsymbol\omega}_{i-1} + k_{r_i}\ddot q_i\boldsymbol z_{m_i} + k_{r_i}\dot q_i\,\boldsymbol\omega_{i-1}\times\boldsymbol z_{m_i}.$$

### 第二遍：向内（后向）递推力、力矩与驱动输入（$i=n\to 1$）

已知末端施于环境的广义力 $\boldsymbol h_e = [\boldsymbol f_{n+1}^{\mathrm T},\,\boldsymbol\mu_{n+1}^{\mathrm T}]^{\mathrm T}$（在基座系表达、力矩参考点取末端 $O_n$；自由运动取 $\boldsymbol h_e=\boldsymbol 0$），自末端向基座反向计算（对应 (7.112)–(7.114)）：

6. **界面约束力递推 (7.112)**（已用虚拟初值 $\ddot{\boldsymbol p}_0=-\boldsymbol g_0$ 吸收重力）：

$$\boldsymbol f_i = \boldsymbol f_{i+1} + m_i\ddot{\boldsymbol p}_{C_i}.$$

7. **界面力矩递推 (7.113)**（由上节主方程整理得到，且 $\boldsymbol r_{i-1,C_i}=\boldsymbol r_{i-1,i}+\boldsymbol r_{i,C_i}$）：

$$\begin{aligned}
\boldsymbol\mu_i &= -\boldsymbol f_i\times(\boldsymbol r_{i-1,i}+\boldsymbol r_{i,C_i}) + \boldsymbol\mu_{i+1} + \boldsymbol f_{i+1}\times\boldsymbol r_{i,C_i} + \bar{\boldsymbol I}_i\dot{\boldsymbol\omega}_i + \boldsymbol\omega_i\times(\bar{\boldsymbol I}_i\boldsymbol\omega_i) \\
&\quad + k_{r,i+1}\ddot q_{i+1}I_{m_{i+1}}\boldsymbol z_{m_{i+1}} + k_{r,i+1}\dot q_{i+1}I_{m_{i+1}}\,\boldsymbol\omega_i\times\boldsymbol z_{m_{i+1}}.
\end{aligned}$$

8. **关节驱动广义力 (7.114)**：代回前文投影式算得 $\tau_i$（若包含关节阻尼，附加 $F_{v_i}\dot q_i + F_{s_i}\operatorname{sgn}\dot q_i$）。

::: note 实际编程实现：为何将向量全部投影到当前连杆坐标系 $i$？
上述公式写在共同基坐标系下便于理解物理意义，但 $\bar{\boldsymbol I}_i$ 和 $\boldsymbol r_{i,C_i}$ 随关节转动不断变化。工程代码（如原书严格形式 (7.107)–(7.114)）通常左乘 $\boldsymbol R_i^{\mathrm T}$ 将第 $i$ 杆的运动量、受力及平衡式全投影至**连杆局部坐标系 $i$** 中表达：代价是每次跨关节乘一次固定形式的 $3\times 3$ 旋转矩阵 $\boldsymbol R_i^{i-1\mathrm T}$（后向递推乘 $\boldsymbol R_{i+1}^i$），回报是 $\bar{\boldsymbol I}_i^i,\boldsymbol r_{i,C_i}^i,\boldsymbol r_{i-1,i}^i$ 全成为预存常量，彻底免去矩阵求逆与符号化简，每根杆仅做固定次数的 $3\times3$ 乘加运算，总复杂度严格保持 **$O(n)$**。
:::

## 6.4.4 算例检验：用两遍递推核对两连杆平面臂

为直观验证递推流程与拉格朗日公式完全等价，考察 [6.3.2 节](sec6-3.md#part-6.3.2) 无转子特例（$m_{m_i}=I_{m_i}=0$，连杆系均在局部平面 $x_i$-$y_i$ 内，$z_i$ 垂直纸面，重力 $\boldsymbol g_0=[0,-g]^{\mathrm T}$）。在各自**连杆坐标系 $i$** 下列写二维平面分量的两遍递推：

1. **前向递推**（取虚拟加速度基值 $\boldsymbol A_{O_0} = \begin{bmatrix}g\sin q_1\\g\cos q_1\end{bmatrix}$（投影到连杆 1 轴向和法向），$R(q_2)=\begin{bmatrix}\cos q_2&-\sin q_2\\\sin q_2&\cos q_2\end{bmatrix}$）：
   - 连杆 1 质心有效加速度：$\boldsymbol A_{C_1} = \begin{bmatrix}g\sin q_1 - \ell_1\dot q_1^2\\ g\cos q_1 + \ell_1\ddot q_1\end{bmatrix}$；杆 1 末端原点加速度 $\boldsymbol A_{O_1} = \begin{bmatrix}g\sin q_1 - a_1\dot q_1^2\\ g\cos q_1 + a_1\ddot q_1\end{bmatrix}$。
   - 经 $R^{\mathrm T}(q_2)$ 旋转到连杆 2 局部系后叠加速度导数：

$$\boldsymbol A_{C_2} = R^{\mathrm T}(q_2)\boldsymbol A_{O_1} + \begin{bmatrix}-\ell_2(\dot q_1+\dot q_2)^2\\ \ell_2(\ddot q_1+\ddot q_2)\end{bmatrix}.$$

2. **后向递推**（无末端负载 $\boldsymbol F_3=\boldsymbol 0$）：
   - 由杆 2 出发：$\boldsymbol F_2 = m_2\boldsymbol A_{C_2}$，对关节 2 取矩 $\tau_2 = I_2(\ddot q_1+\ddot q_2) + \ell_2 F_{2y}$。展开 $F_{2y}$ 得

$$\tau_2 = (I_2+m_2\ell_2^2)(\ddot q_1+\ddot q_2) + m_2a_1\ell_2\cos q_2\,\ddot q_1 + m_2a_1\ell_2\sin q_2\,\dot q_1^2 + m_2g\ell_2\cos(q_1+q_2),$$

   与 6.3.2 拉格朗日第二方程在无转子条件下的每一项（包括 $\dot q_1^2$ 离心力符号和重力臂）完全吻合！
   - 再回推关节 1 支承力与力矩：$\boldsymbol F_1 = m_1\boldsymbol A_{C_1} + R(q_2)\boldsymbol F_2$，$\tau_1 = I_1\ddot q_1 + \ell_1 m_1 A_{C_1,y} + \tau_2 + a_1\bigl(R(q_2)\boldsymbol F_2\bigr)_y$，展开后同样精确还原第一关节全部惯量、科氏/离心和重力耦合项（当恢复电机转子时，按通用主方程补入 $\dot{\boldsymbol\omega}_{m_i}$ 与第 $i+1$ 转子欧拉陀螺项即可，见[作业六·补 7-8](homework06b.md)三路线互校）。

## 本节小结

- **算法本质**：牛顿–欧拉递推用约束反力“一进一出”的两遍传递替代拉格朗日法的高维偏导展开，实现 $O(n)$ 逆动力学数值计算。
- **易错检查表**：

| 检查项 | 正确口径 |
|:--|:--|
| 重力处理 | $\ddot{\boldsymbol p}_0=-\boldsymbol g_0$（法 A，推荐）与牛顿方程显式 $+m_i\boldsymbol g_0$（法 B）**二选一**；欧拉方程始终无重力矩 |
| 力矩参考点 | $\boldsymbol\mu_i$ 关于 $O_{i-1}$，$\boldsymbol\mu_{i+1}$ 关于 $O_i$，向质心 $C_i$ 简化不可漏掉两端力臂叉乘 |
| 移动关节与转子 | 移动关节线加速度须含科氏项 $2\dot d_i\boldsymbol\omega_i\times\boldsymbol z_{i-1}$；欧拉方程计入转子 $i+1$，轴投影 $\tau_i$ 计入转子 $i$ |

**下一节**：[6.5 动力学正解与逆解](sec6-5.md)把闭合方程与递推算法装进仿真与控制两种工程接口。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 36:00 板书 | [ne-board-momentum.jpg](../assets/ch06/ne-board-momentum.jpg) | 动量与角动量预备式推导 | 6.4.1 严格推导并补充适用边界 |
| 37:21 | [ne-variables.jpg](../assets/ch06/ne-variables.jpg) | 单连杆 18 个变量约定 | 6.4.2 完整变量定义表 |
| 42:23 | [ne-link-equations.jpg](../assets/ch06/ne-link-equations.jpg) | 单连杆牛顿与欧拉方程 | 6.4.2 给出并标注重力不进欧拉方程 |
| 43:30 板书 | [ne-board-balance.jpg](../assets/ch06/ne-board-balance.jpg) | 欧拉方程含陀螺与转子项展开 | 6.4.1–6.4.2 推导 $\dot{\boldsymbol R}=S(\boldsymbol\omega)\boldsymbol R$ 项 |
| 54:03 | [ne-joint-tau.jpg](../assets/ch06/ne-joint-tau.jpg) | 关节驱动力矩轴投影 (7.114) | 6.4.2 区分移动/旋转与转子下标 |
| 55:43 | [ne-velocities.jpg](../assets/ch06/ne-velocities.jpg) | 速度与角速度前向递推 | 6.4.3 前向递推体系整合 |
| 57:58 | [ne-accelerations.jpg](../assets/ch06/ne-accelerations.jpg) | 角加速度与线加速度递推 (7.108)–(7.109) | 6.4.3 保留进动项与 $2\dot d\boldsymbol\omega\times\boldsymbol z$ 科氏项 |
| 59:01 | [ne-centroid-acc.jpg](../assets/ch06/ne-centroid-acc.jpg) | 质心与转子角加速度 (7.110)–(7.111) | 6.4.3 完整列出 |
| 65:48 | [ne-forward.jpg](../assets/ch06/ne-forward.jpg) | 前向递推五式总览 | 6.4.3 归纳统一模式 |
| 68:38 | [ne-backward.jpg](../assets/ch06/ne-backward.jpg) | 后向递推与虚拟重力吸收 | 6.4.3 并比较两种重力吸收写法 |
| 72:10 | [ne-structure.jpg](../assets/ch06/ne-structure.jpg) | 算法结构与局部连杆系实现 | 6.4.3 说明局部坐标系优势与 $O(n)$ 复杂度 |
| 83:25 | [ne-compare.jpg](../assets/ch06/ne-compare.jpg) | 牛顿–欧拉与拉格朗日对照及算例验证 | 6.4.4 平面 2R 手算互校 + 6.1 表格对照 |
:::
