# 8.1 接触任务与力的约定

第七章的自由空间运动控制只关心末端跟踪位置，但只要机械臂执行打磨、切削、装配或推拉开关等接触任务，定位误差哪怕只有一毫米，面对刚性工件时也会被环境刚度放大为几十甚至上百牛的接触力。要让控制器学会“收手”或“按指定力压紧”，第一步是写出含接触力的动力学方程，并把接触力的作用对象与方向符号钉死。

<a id="sec-8.1.1"></a>

## 8.1.1 局部线性弹性接触与位置控制的失效

设末端执行器沿 $+x$ 方向接近静止表面原位 $x_r$，实际末端位置为 $x_e$，接触面刚度为 $k_e > 0$（单轴算例亦简记为 $k$，单位 $\mathrm{N/m}$）。在持续推压接触且形变较小的局部线性弹性近似下，**机械手施加给环境的法向力**满足单边分段关系：

$$f_e = \begin{cases} k_e(x_e - x_r), & x_e \ge x_r \text{（接触分支）}, \\ 0, & x_e < x_r \text{（脱离分支）}. \end{cases}$$

这个简单模型立刻解释了为什么纯位置控制无法胜任接触任务：取典型金属表面刚度 $k_e = 10^5\,\mathrm{N/m}$，仅仅 $\Delta x = 1\,\mathrm{mm} = 10^{-3}\,\mathrm m$ 的标定偏差，就会造成 $\Delta f_e = k_e\Delta x = 100\,\mathrm N$ 的接触力波动。参考位置 $x_d$ 一旦落进工件内部，位置控制器就会持续增大驱动力矩以企图消除位置误差，导致过载或损坏工件。

上式仅描述单边推压接触的弹性分支：一旦 $x_e < x_r$ 离开表面，接触力即归零（$f_e = 0$），切不可用公式里带负号的值误解为“表面把末端拉了回来”。当涉及碰撞、库仑摩擦或频繁脱开-再接触切换时，必须引入额外的接触物理模型。

<a id="sec-8.1.2"></a>

## 8.1.2 含接触力的动力学符号约定与功率配对

在书写含接触力的机械臂方程前，必须先说清一个极易出错的问题：式中的外力究竟是“手对环境”，还是“环境对手”？

::: def 定义 8.1.1 · 含接触力的关节空间动力学与符号约定 {#def-8.1.1}
设机械臂广义坐标为 $\boldsymbol{q}\in\mathbb R^n$，关节驱动广义力为 $\boldsymbol{u}\in\mathbb R^n$。统一定义 $\boldsymbol{h}_e = [\boldsymbol{f}_e^{\mathrm T},\,\boldsymbol{\mu}_e^{\mathrm T}]^{\mathrm T}\in\mathbb R^6$ 为**机械手末端执行器施加给环境**的六维广义接触力（$\boldsymbol{f}_e\in\mathbb R^3$ 单位 $\mathrm N$，$\boldsymbol{\mu}_e\in\mathbb R^3$ 单位 $\mathrm{N\cdot m}$，在基座系表达）；由牛顿第三定律，环境施加给机械手的反作用力为 $-\boldsymbol{h}_e$。在此约定下，含接触的关节空间动力学方程为

$$B(\boldsymbol{q})\ddot{\boldsymbol{q}} + C(\boldsymbol{q},\dot{\boldsymbol{q}})\dot{\boldsymbol{q}} + F\dot{\boldsymbol{q}} + \boldsymbol{g}(\boldsymbol{q}) = \boldsymbol{u} - J^{\mathrm T}(\boldsymbol{q})\boldsymbol{h}_e,$$

其中 $B(\boldsymbol{q})\in\mathbb R^{n\times n}$ 为正定对称惯性矩阵，$C(\boldsymbol{q},\dot{\boldsymbol{q}})\dot{\boldsymbol{q}}$ 为哥氏与离心力项，$F\dot{\boldsymbol{q}}$ 为黏性摩擦项，$\boldsymbol{g}(\boldsymbol{q})$ 为重力项，$J(\boldsymbol{q})\in\mathbb R^{6\times n}$ 为末端几何雅可比矩阵。
:::

右端的负号来自受力对象约定：动力学方程左边刻画机械臂本体加速度，右边必须填入**环境对机械手的作用** $-J^{\mathrm T}\boldsymbol{h}_e$。若采用力传感器的常见读数习惯（记录环境作用于末端手的力 $\boldsymbol{h}_s = -\boldsymbol{h}_e$），动力学右端便应改写为 $\boldsymbol{u} + J^{\mathrm T}\boldsymbol{h}_s$，且控制律中的力反馈号也必须同步调整——只改动力学不改控制律（或反之）会把负反馈颠倒成正反馈。

要避免坐标与符号写错，可以在推导每一步之前执行“功率配对”检查：

1. **检验几何速度功率**：令末端几何速度为 $\boldsymbol{v}_e = [\dot{\boldsymbol{p}}_e^{\mathrm T},\,\boldsymbol{\omega}_e^{\mathrm T}]^{\mathrm T} = J(\boldsymbol{q})\dot{\boldsymbol{q}}$，关节端克服环境反力向环境输出的瞬时功率（单位 $\mathrm W$）与末端侧完全一致：

   $$P_e = \dot{\boldsymbol{q}}^{\mathrm T}\bigl(J^{\mathrm T}(\boldsymbol{q})\boldsymbol{h}_e\bigr) = \bigl(J(\boldsymbol{q})\dot{\boldsymbol{q}}\bigr)^{\mathrm T}\boldsymbol{h}_e = \boldsymbol{v}_e^{\mathrm T}\boldsymbol{h}_e = \dot{\boldsymbol{p}}_e^{\mathrm T}\boldsymbol{f}_e + \boldsymbol{\omega}_e^{\mathrm T}\boldsymbol{\mu}_e.$$

2. **推导分析坐标广义力 $\boldsymbol{h}_A$**：若操作空间使用最小姿态坐标 $\boldsymbol{x}_e = [\boldsymbol{p}_e^{\mathrm T},\,\boldsymbol{\phi}_e^{\mathrm T}]^{\mathrm T}$，对应的分析雅可比为 $\dot{\boldsymbol{x}}_e = J_A(\boldsymbol{q})\dot{\boldsymbol{q}}$，且几何速度与解析速率满足 $\boldsymbol{v}_e = T_A(\boldsymbol{\phi}_e)\dot{\boldsymbol{x}}_e$（$J = T_A J_A$）。要求分析坐标同样保持瞬时功率不变 $\dot{\boldsymbol{x}}_e^{\mathrm T}\boldsymbol{h}_A = \boldsymbol{v}_e^{\mathrm T}\boldsymbol{h}_e = \dot{\boldsymbol{x}}_e^{\mathrm T}T_A^{\mathrm T}\boldsymbol{h}_e$，对任意可行 $\dot{\boldsymbol{x}}_e$ 成立，从而唯一确定：

   $$\boldsymbol{h}_A = T_A^{\mathrm T}(\boldsymbol{\phi}_e)\boldsymbol{h}_e, \qquad J^{\mathrm T}\boldsymbol{h}_e = J_A^{\mathrm T}\boldsymbol{h}_A.$$

切记：$\boldsymbol{h}_A$ 是**与所选姿态参数速率 $\dot{\boldsymbol{\phi}}_e$ 功率配对**的广义力，其后三维一般**不等于**力传感器直接测出的物理力矩 $\boldsymbol{\mu}_e$；只有当任务仅含三维平动（无姿态改变，$T_A = I_3$）时，$J_A = J$ 且 $\boldsymbol{h}_A = \boldsymbol{h}_e$，两者差别才消失。

<a id="sec-8.1.3"></a>

## 8.1.3 按闭环期望关系分类的四类力控制方法

确定了动力学模型与坐标口径后，接下来的问题是：接触到底应当控制成什么样？根据任务对力与运动的不同侧重，后续几节将逐一展开四类方案：

| 任务需求 | 控制器真正建立的闭环关系 | 对应方法 |
|:--|:--|:--|
| 接触后允许末端适当退让，只需确定停在哪里 | 静态力–位移关系 $\boldsymbol{h}_A = K_P\boldsymbol{e}$ | [柔顺控制（8.2）](sec8-2.md) |
| 不仅关心平衡点，还要抑制撞击冲击与过渡振荡 | 二阶力–运动动态关系 $M_d\ddot{\tilde{\boldsymbol{x}}} + D_d\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$ | [阻抗与导纳（8.3）](sec8-3.md) |
| 要求接触力精确收敛到给定设定值 $\boldsymbol{h}_d$ | 调节力误差 $\boldsymbol{h}_d - \boldsymbol{h}_e \to \boldsymbol{0}$ | [直接力控制（8.4）](sec8-4.md) |
| 沿工件表面滑行的同时保持特定法向力 | 在互补子空间内分别跟踪速度 $\boldsymbol{v}_d$ 与接触力 $\boldsymbol{h}_d$ | [混合力/运动控制（8.5–8.7）](sec8-7.md) |

应当按**闭环要实现的关系**来辨别控制策略，而不要按“有没有力传感器”下结论：前面提到的阻抗控制与导纳控制也经常接入六维力传感器，以消除惯量耦合或生成柔顺位置参考，但只要系统没有显式调节力误差 $\boldsymbol{h}_d - \boldsymbol{h}_e$ 去追随独立设定的期望力 $\boldsymbol{h}_d$，它们仍属于**间接力控制**。

<details>
<summary>检查理解：机械手装上六维力传感器并闭环使用测力，为什么不一定是在做直接力控？</summary>

若传感器测得的力只是用来形成或补偿 $M_d\ddot{\tilde{\boldsymbol{x}}} + D_d\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$ 这类力–运动关系，控制器的本质目标仍是阻抗/导纳（间接力控制）。只有当系统独立指定期望接触力 $\boldsymbol{h}_d$ 并以力误差 $\boldsymbol{h}_d - \boldsymbol{h}_e$ 驱动调节规律，使可控接触方向的力趋于 $\boldsymbol{h}_d$ 时，才属于直接力控制。实际检查时还应确认传感器坐标系、符号约定，以及是否已扣除工具自重与加速惯性力。

</details>

## 8.1 小结与常见错误

- **一条主线**：接触把 $-J^{\mathrm T}\boldsymbol{h}_e$ 带入动力学方程右端；只有先固定“手对环境为正”与功率配对公式 $\boldsymbol{h}_A = T_A^{\mathrm T}\boldsymbol{h}_e$，后续各节控制器推导才不会出正负号和坐标系错误。
- **一个量级感**：对刚度 $k_e = 10^5\,\mathrm{N/m}$ 的金属面，$1\,\mathrm{mm}$ 的位置误差即可产生 $100\,\mathrm N$ 力波动——位置控得好不等于力可控。
- **一个分界**：分类依据是闭环要建立什么物理关系（静态柔顺 / 动态阻抗 / 力误差归零 / 子空间解耦），而不是是否接了力传感器。
- **下一节**：[8.2 柔顺控制](sec8-2.md) 先解决最简单的静态问题——当机械臂与弹性表面相碰时，两个刚度共同决定了最终停在哪里。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 弹性接触：$f_e = k_e(x_e - x_r)$，$x_e \ge x_r$ | 单边推压、保持接触、局部线性弹性 | $\mathrm N$、$\mathrm{N/m}$ | 脱离后 $f_e = 0$，不能用负值弹簧力充当拉力 |
| 接触动力学：$B\ddot{\boldsymbol{q}} + C\dot{\boldsymbol{q}} + F\dot{\boldsymbol{q}} + \boldsymbol{g} = \boldsymbol{u} - J^{\mathrm T}\boldsymbol{h}_e$ | $\boldsymbol{h}_e$ 为机械手对环境的广义力 | $\mathrm{N\cdot m}$ / $\mathrm N$ | 传感器读反力时方程与控制律须同步换号 |
| 功率转换：$\boldsymbol{h}_A = T_A^{\mathrm T}\boldsymbol{h}_e$ | 最小坐标 $\dot{\boldsymbol{x}}_e = J_A\dot{\boldsymbol{q}}$ 与几何速度并用 | 广义力/矩 | $\boldsymbol{h}_A$ 后三维一般不是物理力矩 |

::: think 常见错误清单 · 自查三条
1. 把 $-J^{\mathrm T}\boldsymbol{h}_e$ 误写成 $+J^{\mathrm T}\boldsymbol{h}_e$ 却不按功率等式核对：一旦对象与符号约定混淆，闭环容易变成正反馈发散。
2. 看到用了六维力传感器就称为直接力控制：需先看反馈是在调节 $\boldsymbol{h}_d - \boldsymbol{h}_e$ 还是在实现阻抗/导纳关系。
3. 拿单边弹簧式在脱离区（$x_e < x_r$）强行算负力：无粘附单边接触脱离时接触力恒为零。
:::
