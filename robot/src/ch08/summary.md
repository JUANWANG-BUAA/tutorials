# 第八章总结 · 力控制

当末端执行器进入接触工况后，力控制的设计顺序不再只是“减小位置跟踪误差”，而是依循一条严密的物理链：**先锁定力的作用对象与功率配对坐标系，再依任务要求在静态柔顺、动态阻抗/导纳、直接力闭环或互易混合子空间之间选定目标，最后逐一核验环境承载能力与闭环稳定裕度。**

## 全章核心方程总览

1. **符号约定与含接触动力学（[8.1](sec8-1.md#sec-8.1.2)）**：全章统一记 $\boldsymbol{h}_e = [\boldsymbol{f}_e^{\mathrm T},\,\boldsymbol{\mu}_e^{\mathrm T}]^{\mathrm T}$ 为**机械手对环境施加的广义接触力**，环境反作用为 $-\boldsymbol{h}_e$：

   $$B(\boldsymbol{q})\ddot{\boldsymbol{q}} + C(\boldsymbol{q},\dot{\boldsymbol{q}})\dot{\boldsymbol{q}} + F\dot{\boldsymbol{q}} + \boldsymbol{g}(\boldsymbol{q}) = \boldsymbol{u} - J^{\mathrm T}(\boldsymbol{q})\boldsymbol{h}_e, \qquad \boldsymbol{h}_A = T_A^{\mathrm T}\boldsymbol{h}_e.$$

   始终以瞬时机械功率等式 $\dot{\boldsymbol{q}}^{\mathrm T}J^{\mathrm T}\boldsymbol{h}_e = \boldsymbol{v}_e^{\mathrm T}\boldsymbol{h}_e = \dot{\boldsymbol{x}}_e^{\mathrm T}\boldsymbol{h}_A$ 校验符号和维度；若改用环境作用于手腕的传感器符号 $\boldsymbol{h}_s = -\boldsymbol{h}_e$，动力学方程右端和控制律必须同步变号。

2. **主动柔顺与串联双弹簧（[8.2](sec8-2.md#sec-8.2.balance)）**：操作空间 PD 控制器呈现主动刚度 $K_P$，与环境刚度 $K_e$ 串联分压决定静态平衡（单轴接触分支 $x_e \ge x_r$ 下）：

   $$x_e = \frac{k_P x_d + k_e x_r}{k_P + k_e}, \qquad f_e = \frac{k_P k_e}{k_P + k_e}(x_d - x_r), \qquad K_{\mathrm{eq}}^{-1} = K_P^{-1} + K_e^{-1}.$$

   同一组控制参数面对更硬的表面（$k_e$ 增大）时，压入深度 $x_e - x_r$ 更浅，但静态接触力 $f_e$ 反而上升。大姿态偏差任务须提取无零位奇异的局部 XYZ 相对角重建误差 $\boldsymbol{e}_d$。

3. **阻抗与导纳（[8.3](sec8-3.md)）**：将平衡扩展为二阶动态关系 $M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$。
   - 仅抵消连杆惯性与非线性力而**不测力补偿**时，闭环仍残留构型耦合项 $M_d B_A^{-1}(\boldsymbol{q})\boldsymbol{h}_A$；须同时在外层叠加 $+J^{\mathrm T}\boldsymbol{h}_e$ 并在内层加速度指令引回 $-\boldsymbol{h}_A$ 方能彻底解耦。
   - 接触弹性环境后，自然频率与阻尼比为 $\omega_n = \sqrt{(k_P + k_e)/m_d}$、$\zeta = d_d / \bigl(2\sqrt{m_d(k_P + k_e)}\bigr)$；更硬工件提高 $\omega_n$ 却压低 $\zeta$，同一阻尼参数通常无法通吃不同刚度表面。

4. **直接力控制与内环差异（[8.4](sec8-4.md)）**：
   - **位置内环**：纯比例外环因存在绝对刚度恢复项 $k_P x_e$ 必然存在稳态偏置；升级为 PI 外环可实现常值力无偏跟踪，但系统阶次升至三阶，必须满足 Routh 稳定极限 $d_d(1 + k_e k_F) > m_d k_e k_I$。
   - **速度内环**：没有位置恢复刚度，速度到位置的物理积分使理想比例力控制即可达到 $f_e = f_d$（$x_e = x_r + f_d/k_e$），不过面对未建模常偏置 $b$ 时仍残留稳态误差 $b/k_f$。
   - **并联相容**：同轴同时要求 $x_d$ 与 $f_d$ 必须满足 $f_d = k_e(x_d - x_r)$，否则积分力环会压过位置设定值。

5. **约束互易分解与混合控制（[8.5](sec8-5.md)–[8.7](sec8-7.md)）**：在理想无摩擦约束 $\boldsymbol{\phi}(\boldsymbol{q}) = \boldsymbol{0}\in\mathbb R^m$ 下，可行速度子空间 $S_v\in\mathbb R^{6\times(6-m)}$ 与约束力子空间 $S_f\in\mathbb R^{6\times m}$ 满足功率互易正交补条件 $S_f^{\mathrm T}S_v = O$。在局部约束坐标系 $\{C\}$ 逐方向判定互补的自然约束与人工约束，再借助操作空间逆动力学双通道指令 $\boldsymbol{\alpha} = S_v\boldsymbol{\alpha}_\nu + C_e S_f\boldsymbol{f}_\lambda$ 实现运动环与力环独立闭环。工程实现时须用速度 $\times$ 估计刚度替换含噪力微分，并在沿曲面滑行时保留时变附加项 $\dot S_v\boldsymbol{\nu}$。

## 四类力控制方案横向对比

| 方法 | 核心闭环目标 | 是否必须测力 | 典型稳定性/实现核查重点 |
|:--|:--|:--|:--|
| **主动柔顺** | $\boldsymbol{h}_A = K_P\boldsymbol{e}$（静态平衡） | 否 | 雅可比满行秩、大转角 $\boldsymbol{e}_d$、串联环境刚度分压 |
| **阻抗控制** | $M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$ | 可选（无测力时留 $B_A^{-1}$ 耦合） | 硬表面导致 $\zeta$ 下降；力矩外环与内层 $-\boldsymbol{h}_A$ 必须成对 |
| **导纳控制** | 测力驱动 $M_t\ddot{\boldsymbol{z}} + D_t\dot{\boldsymbol{z}} + K_t\boldsymbol{z} = \boldsymbol{h}_e$ 生成运动参考 | 是 | 需高刚度位置内环“内快外慢”；极硬接触延迟易颤振 |
| **直接力控制** | 消除误差 $\boldsymbol{h}_d - \boldsymbol{h}_e \to \boldsymbol{0}$ | 是 | 区分位置/速度内环；查三阶 Routh 条件与方向支撑能力 |
| **混合力/运动控制** | $\dot{\boldsymbol{\nu}} = \boldsymbol{\alpha}_\nu$，$\ddot{\boldsymbol{\lambda}} = \boldsymbol{f}_\lambda$ | 是 | 约束系 $\{C\}$ 划分、互易性 $S_f^{\mathrm T}S_v=O$、$\dot S_v\boldsymbol{\nu}$ 与刚度估计替代求导 |

## 关键辨析与后续练习

1. **装了传感器不等于在做直接力控制**：判定标准是控制器是否在调节 $\boldsymbol{h}_d - \boldsymbol{h}_e$ 使力达标，还是利用测力实现力–运动动态比值。
2. **位移浅不等于接触力小**：更硬表面令工具压入量减半的同时，可能把串联平衡接触力抬高数倍。
3. **互易性不是同单位下的普通欧氏正交**：力和速度单位不同，唯有乘积给出的瞬时机械功率 $\boldsymbol{h}_e^{\mathrm T}\boldsymbol{v}_e = 0$ 才具有坐标不变性。

复习时建议按序完成[双刚度平衡计算](exercises.md#b-组刚度决定哪一个平衡)、[硬表面阻尼比对比](exercises.md#c-组环境改变了阻尼比)、[两类内环稳态分析](exercises.md#d-组两种内环的稳态差异)、[平面选择矩阵练习](exercises.md#e-组选择矩阵检查)以及[平面打磨综合算例](sec8-8.md) / [F 组参数练习](exercises.md#f-组把平面打磨任务连成闭环)；对应教材第 9 章作业请查阅[作业八](homework08.md)。
