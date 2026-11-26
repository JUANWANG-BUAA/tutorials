# 8.9 符号口径与教材对照说明

本页汇总第八章全章采用的数学记号、物理约定与教材对照口径，供阅读正文公式或对照参考书推导时快速核对。

## 一、力与坐标系口径约定

1. **广义接触力作用对象与符号**：全章统一记 $\boldsymbol{h}_e = [\boldsymbol{f}_e^{\mathrm T},\,\boldsymbol{\mu}_e^{\mathrm T}]^{\mathrm T} \in \mathbb R^6$ 为**机械手末端执行器施加给环境**的广义力与力矩，环境对机械手的反作用力为 $-\boldsymbol{h}_e$。因此在关节空间动力学右端写作 $\boldsymbol{u} - J^{\mathrm T}(\boldsymbol{q})\boldsymbol{h}_e$。若实验平台所配力传感器直接输出“环境对机械手施加的力” $\boldsymbol{h}_s = -\boldsymbol{h}_e$，动力学方程右端需同步改为 $\boldsymbol{u} + J^{\mathrm T}(\boldsymbol{q})\boldsymbol{h}_s$，且阻抗解耦及力闭环中的力反馈项必须全部成对变号。
2. **操作空间分析广义力 $\boldsymbol{h}_A$ 与物理力矩**：当操作空间姿态以最小欧拉角描述（$\dot{\boldsymbol{x}}_e = J_A\dot{\boldsymbol{q}}$ 且 $\boldsymbol{v}_e = T_A(\boldsymbol{\phi}_e)\dot{\boldsymbol{x}}_e$）时，依据瞬时机械功率不变原则定义 $\boldsymbol{h}_A = T_A^{\mathrm T}(\boldsymbol{\phi}_e)\boldsymbol{h}_e$，以保障 $J^{\mathrm T}\boldsymbol{h}_e = J_A^{\mathrm T}\boldsymbol{h}_A$。唯有当任务仅限三维平动、姿态保持不变（$T_A = I_3$）时，$\boldsymbol{h}_A$ 与物理力向量一致；一般六维情形下 $\boldsymbol{h}_A$ 的后三维不是传感器测得的物理空间力矩。
3. **单边线性弹性接触分支**：局部刚度模型 $f_e = k_e(x_e - x_r)$（标量算例在部分参考书中简写为 $k$）仅在保持压向接触的分支 $x_e \ge x_r$ 内成立；末端脱离表面进入自由区间 $x_e < x_r$ 时无粘附力，必须令 $f_e = 0$。

## 二、常用符号对应表（与教材第 9 章一致）

| 本教程记号 | 原书（Siciliano《Robotics》第 9 章）对应记号 | 说明 |
|:--|:--|:--|
| $K_e$、$k_e$（标量亦作 $k$） | $K$、$k$ | 环境接触刚度矩阵与单轴刚度 |
| $M_d,\,K_D,\,K_P$ | $M_d,\,K_D,\,K_P$ | 目标阻抗惯量、阻尼（部分章节记 $D_d$）与刚度 |
| $M_t,\,D_t,\,K_t$ | $M_t,\,K_{D,t},\,K_{P,t}$ | 导纳外环虚拟动态参数 |
| $x_F,\,k_F$ vs $k_f$ | $x_F,\,k_F$ vs $k_f = k_P k_F$ | 位置内环柔度力增益（$\mathrm{m/N}$）与速度内环合并力增益 |
| $S_f,\,S_v$ | $S_f,\,S_v$ | 力选择矩阵与速度选择矩阵（均在约束坐标系 $\{C\}$ 表达） |
| $C_e,\,\widehat C_e$ | $C_e,\,\widehat C_e$ | 受约束力子空间等效柔度矩阵及其估计值 |

## 三、章节对应与算例边界

- **章节映射关系**：本教程第八章全面覆盖 Siciliano《Robotics》第 9 章（Force Control）§9.1–§9.7 核心内容：
  - [8.1 接触任务与力的约定](sec8-1.md) $\leftrightarrow$ §9.1、§9.2 节首；
  - [8.2 柔顺控制](sec8-2.md) $\leftrightarrow$ §9.2；
  - [8.3 阻抗与导纳](sec8-3.md) $\leftrightarrow$ §9.3；
  - [8.4 直接力控制](sec8-4.md) $\leftrightarrow$ §9.4；
  - [8.5 约束运动](sec8-5.md) $\leftrightarrow$ §9.5；
  - [8.6 控制方向的选择](sec8-6.md) $\leftrightarrow$ §9.6；
  - [8.7 混合力/运动控制](sec8-7.md) $\leftrightarrow$ §9.7。
- **综合算例说明**：[8.8 综合算例](sec8-8.md) 及章末[习题 F 组](exercises.md#f-组把平面打磨任务连成闭环) 为将局部约束坐标系、选择矩阵与一阶速度型力控串联成完整闭环计算流程而设计，所选参数为教学示例数值；教材课后作业（9-7 必做，9-3 与 9-10 任选）及其高精度复算曲线请查阅[作业八](homework08.md) 与复算脚本 `tools/verify_homework08.py`、`tools/verify_ch08_force.py`。
- **理想模型边界**：本章混合力/运动控制推导基于刚性（或局部小弹性）、无摩擦与持续接触三大基准假设；插孔装配的多点碰触切换、库仑摩擦前馈与实际数字控制延时稳定性验证需在真实仿真或样机整定中独立检验。
