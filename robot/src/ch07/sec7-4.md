# 7.4 操作空间控制（选学·精简）

前三节均将任务经逆运动学翻译到关节坐标 $\boldsymbol q$ 上实现反馈镇定。对于直接在末端位姿空间（装配、曲线轮廓跟踪）下定义的任务，**操作空间控制（Operational Space Control）** 省去前置位姿逆解环节，直接针对末端误差 $\tilde{\boldsymbol x}=\boldsymbol x_d-\boldsymbol x_e$ 构造反馈，再通过雅可比把动作映回关节侧驱动力矩（对应原书 §8.6）。本节精炼核心控制律、平衡点几何与工程代价。

<a id="sec-7.4.1"></a>
<a id="sec-7.4.2"></a>
<a id="sec-7.4.3"></a>

## 7.4.1 分析雅可比映射与两类运动学实现方案

设末端最小位姿坐标为 $\boldsymbol x=[\boldsymbol p^{\mathrm T},\,\boldsymbol\phi^{\mathrm T}]^{\mathrm T}\in\mathbb R^r$（同一无表示奇点的光滑局部坐标分支内，$\tilde{\boldsymbol x}=\boldsymbol x_d-\boldsymbol x$）。结合[3.6 节](../ch03/sec3-6.md#sec-3.6.1)与[6.7 节](../ch06/sec6-7.md)推导，速度、加速度及无接触操作空间动力学分别为：

$$\dot{\boldsymbol x} = J_A(\boldsymbol q)\dot{\boldsymbol q},\qquad
\ddot{\boldsymbol x} = J_A(\boldsymbol q)\ddot{\boldsymbol q} + \dot J_A(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q},\qquad
B_x\ddot{\boldsymbol x} + C_x\dot{\boldsymbol x} + \boldsymbol g_x = \boldsymbol\tau_x - \boldsymbol h_A, \tag{7.4-1, 7.4-3}$$

其中 $J=T_A(\boldsymbol\phi)J_A$、$B_x=(J_AB^{-1}J_A^{\mathrm T})^{-1}$（需 $J_A$ 满行秩），与分析速度共轭的接触力为 $\boldsymbol h_A=T_A^{\mathrm T}\boldsymbol h_e$（本章自由空间取零），且 $\dot J_A\dot{\boldsymbol q}$ 为几何雅可比时变加速度项，不可混作科氏项 $C\dot{\boldsymbol q}$。直接由末端误差产生关节控制的两类经典运动学路线为：

1. **逆雅可比方案**：$\dot{\boldsymbol q}_{\mathrm{cmd}} = J_A^{-1}(\boldsymbol q)(\dot{\boldsymbol x}_d + K\tilde{\boldsymbol x})\ (K\succ 0)$。理想速度伺服下 $\dot{\tilde{\boldsymbol x}}=-K\tilde{\boldsymbol x}$，但在奇点邻域 $J_A^{-1}$ 病态，冗余时须改伪逆加零空间投影。
2. **转置雅可比方案（虚拟弹簧映射）**：由虚功对偶构造

$$\boldsymbol F = K_P(\boldsymbol x_d - \boldsymbol x),\qquad \boldsymbol\tau = J_A^{\mathrm T}(\boldsymbol q)\boldsymbol F. \tag{7.4-5}$$

   该律免求 $J_A^{-1}$，奇点数值稳健，但仅反映静态弹簧拉力（须叠加重力与阻尼才能构成动态控制器，且位置/姿态混合增益量纲不同）。

<a id="sec-7.4.4"></a>
<a id="sec-7.4.5"></a>

## 7.4.2 操作空间重力补偿 PD 与逆动力学控制律

### 1. 操作空间重力补偿 PD（定点控制）

对常值期望位姿 $\boldsymbol x_d$（$\dot{\boldsymbol x}_d=\boldsymbol 0 \implies \dot{\tilde{\boldsymbol x}}=-J_A\dot{\boldsymbol q}$），选取对称正定增益 $K_P,K_D\succ 0$，操作空间重力补偿 PD 控制律为：

$$\boxed{\ \boldsymbol u = \boldsymbol g(\boldsymbol q) + J_A^{\mathrm T}(\boldsymbol q)K_P\tilde{\boldsymbol x} - J_A^{\mathrm T}(\boldsymbol q)K_D J_A(\boldsymbol q)\dot{\boldsymbol q}\ } \tag{7.4-7}$$

::: thm 定理 7.4.A · 操作空间重力补偿 PD 平衡点与零空间耗散结构
取能量型 Lyapunov 函数 $V=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}+\frac12\tilde{\boldsymbol x}^{\mathrm T}K_P\tilde{\boldsymbol x}$。利用 $\dot B-2C$ 反对称性消去速度交叉项，得：

$$\dot V = -\dot{\boldsymbol q}^{\mathrm T}F\dot{\boldsymbol q} - \dot{\boldsymbol q}^{\ T}J_A^{\mathrm T}K_D J_A\dot{\boldsymbol q} \le 0, \qquad\text{稳态平衡条件：}\ J_A^{\mathrm T}(\boldsymbol q)K_P\tilde{\boldsymbol x} = \boldsymbol 0. \tag{7.4-9}$$

基于线性代数正交分解 $\mathbb R^r=\mathcal R(J_A)\oplus\mathcal N(J_A^{\mathrm T})$ 与 $\mathbb R^n=\mathcal R(J_A^{\mathrm T})\oplus\mathcal N(J_A)$ 可读出三条核心边界：
- **非奇异满行秩**：$\mathcal N(J_A^{\mathrm T})=\{\boldsymbol 0\}$，$J_A^{\mathrm T}$ 列满秩保证平衡点唯一满足 $\tilde{\boldsymbol x}=\boldsymbol 0$；
- **奇异卡死风险**：若机械臂陷入奇异（左零空间 $\mathcal N(J_A^{\mathrm T})\neq\{\boldsymbol 0\}$）且 $K_P\tilde{\boldsymbol x}$ 落入奇异法向（如机械臂完全伸直时沿径向的残余误差），则 $J_A^{\mathrm T}K_P\tilde{\boldsymbol x}=\boldsymbol 0$ 导致系统在**非零误差位置停滞平衡**；
- **冗余零空间耗散缺失**：冗余下存在 $\dot{\boldsymbol q}_{\mathrm{null}}\in\mathcal N(J_A)\setminus\{\boldsymbol 0\}$ 使 $J_A\dot{\boldsymbol q}_{\mathrm{null}}=\boldsymbol 0$，操作空间阻尼项对其做功恒为零，必须依靠物理关节摩擦 $-F\dot{\boldsymbol q}$ 或另加关节空间零空间阻尼抑制内部摆动。
:::

### 2. 操作空间逆动力学控制（轨迹跟踪）

为在末端空间实现时变轨迹 $\boldsymbol x_d(t)$ 的线性解耦跟踪，免去显式组阵 $B_x,C_x,\boldsymbol g_x$，直接将二阶运动学反解 $\ddot{\boldsymbol q}=J_A^{-1}(\ddot{\boldsymbol x}-\dot J_A\dot{\boldsymbol q})$ 并入内环反馈线性化：

$$\boxed{\ \boldsymbol y = J_A^{-1}(\boldsymbol q)\bigl(\ddot{\boldsymbol x}_d + K_D\dot{\tilde{\boldsymbol x}} + K_P\tilde{\boldsymbol x} - \dot J_A(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}\bigr),\qquad \boldsymbol u = B(\boldsymbol q)\boldsymbol y + \boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})\ } \tag{7.4-11}$$

在 $J_A$ 可逆且模型精确条件下代入系统，得线性解耦末端误差动态 $\ddot{\tilde{\boldsymbol x}}+K_D\dot{\tilde{\boldsymbol x}}+K_P\tilde{\boldsymbol x}=\boldsymbol 0$。

<a id="sec-7.4.6"></a>
<a id="sec-7.4.7"></a>

## 7.4.3 五项工程代价与应对策略

| 序号 | 难点与代价 | 物理与数学影响 | 常用工程应对 |
|:--|:--|:--|:--|
| 1 | 末端状态 $\boldsymbol x$ 估计依赖 | 多靠关节编码器经正运动学推算，带入连杆标定偏差 | 高精标定，或加装视觉/激光外部直测 |
| 2 | 雅可比运动学奇异 | $J_A^{-1}$ 奇异、力矩飙升、转置 PD 出现零梯度卡死点 | 阻尼最小二乘 $J_A^*$ 或奇异回避规划 |
| 3 | 运动冗余（$n>r$） | $J_A$ 非方阵不可逆，零空间内部自运动无末端阻尼 | 伪逆配零空间子任务与关节内阻尼项 |
| 4 | 实时计算负担大 | 需逐周期重算 $J_A,\dot J_A\dot{\boldsymbol q}$ 与整机动力学项 | 牛顿–欧拉递推计算或用转置方案近似 |
| 5 | 欧拉角表示奇异 | 万向锁（$\sin\vartheta=0$）与局部坐标跳变限制大范围姿态跟踪 | 局部无奇异分支或改用单位四元数/旋转矩阵 |

## 本节小结

- **两套坐标对应**：采用分析坐标 $\boldsymbol x=[\boldsymbol p^{\mathrm T},\boldsymbol\phi^{\mathrm T}]^{\mathrm T}$ 必须配套分析雅可比 $J_A$ 与共轭力 $\boldsymbol h_A=T_A^{\mathrm T}\boldsymbol h_e$；转置法免逆阵但易在奇异与冗余零空间留残余风险，逆动力学法可实现解耦跟踪但依赖 $J_A$ 可逆并须算 $\dot J_A\dot{\boldsymbol q}$。

**下一节**：[7.5 九种方案的仿真比较与选型](sec7-5.md)将前几节所有关节空间与操作空间控制律置于同一台 2R 机械臂下对比误差并梳理选型流。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 122:30 | [op-transpose.jpg](../assets/ch07/op-transpose.jpg) | 转置雅可比控制律结构 | 7.4.1 给出式 (7.4-5) 与弹簧直观对照 |
| 125:40 | [op-gravity-pd.jpg](../assets/ch07/op-gravity-pd.jpg) | 操作空间重力补偿 PD 与平衡条件 | 定理 7.4.A 展开奇异卡死与零空间缺失阻尼分析 |
| 126:50 | [op-inverse-dynamics.jpg](../assets/ch07/op-inverse-dynamics.jpg) | 操作空间逆动力学 | 7.4.2 式 (7.4-11) 并汇总五项工程代价表 |
:::
