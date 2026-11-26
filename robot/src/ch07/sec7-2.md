# 7.2 分散（独立关节）控制

若直接将各个关节拆成互不关联的单输入单输出通道设计 PID 控制器，原本高度非线性的耦合项（惯量变化、离心科氏力、重力）为何往往不会让系统发散？本节先在电机轴坐标系推导减速比对耦合项的衰减规律，随后建立三种单轴线性控制器、位置 PI 闭环的 Routh 稳定性与干扰抑制指标、驱动电压/电流接口以及两级离线前馈补偿（对应原书 §8.2–§8.4）。

<a id="sec-7.2.1"></a>

## 7.2.1 电机侧坐标与 $1/k_r^2, 1/k_r$ 耦合衰减分析

设各关节经刚性减速比对角阵 $K_r=\operatorname{diag}\{k_{r_1},\dots,k_{r_n}\}$ 传动（$k_{r_i}\ge 1$）。电机轴转角与转矩满足 $\boldsymbol q_m=K_r\boldsymbol q,\ \dot{\boldsymbol q}_m=K_r\dot{\boldsymbol q},\ \ddot{\boldsymbol q}_m=K_r\ddot{\boldsymbol q},\ \boldsymbol\tau_m=K_r^{-1}\boldsymbol\tau$。代入无接触关节方程 (7.1)（暂将滑动库仑摩擦并入未知扰动，记电机侧粘性摩擦对角阵 $F_m=K_r^{-1}F_{\mathrm v}K_r^{-1}$）并左乘 $K_r^{-1}$：

$$K_r^{-1}B(\boldsymbol q)K_r^{-1}\ddot{\boldsymbol q}_m + K_r^{-1}C(\boldsymbol q,\dot{\boldsymbol q})K_r^{-1}\dot{\boldsymbol q}_m + F_m\dot{\boldsymbol q}_m + K_r^{-1}\boldsymbol g(\boldsymbol q) = \boldsymbol\tau_m.$$

把惯性矩阵在工作空间内拆分为常数平均对角阵 $\bar B=\operatorname{diag}\{\bar b_1,\dots,\bar b_n\}$（含折算转子惯量 $k_{r_i}^2 I_{m_i}$ 与连杆对角平均惯量 $\bar b_{ii,\mathrm{link}}$）及变化偏差阵 $\Delta B(\boldsymbol q)=B(\boldsymbol q)-\bar B$。定义电机侧等效标称惯量阵 $J_m=K_r^{-1}\bar B K_r^{-1}=\operatorname{diag}\{J_1,\dots,J_n\}$，则每轴标称惯量为

$$J_i = \frac{\bar b_i}{k_{r_i}^2} = I_{m_i} + \frac{\bar b_{ii,\mathrm{link}}}{k_{r_i}^2}.$$

将全部非常数偏差、速度耦合与重力统一并入电机侧干扰项 $\boldsymbol d$，系统化为解耦单轴标称模型：

$$\boxed{\ K_r^{-1}\bar B K_r^{-1}\ddot{\boldsymbol q}_m + F_m\dot{\boldsymbol q}_m + \boldsymbol d = \boldsymbol\tau_m\ } \tag{7.2-3}$$

$$\boldsymbol d = K_r^{-1}\Delta B(\boldsymbol q)K_r^{-1}\ddot{\boldsymbol q}_m + K_r^{-1}C(\boldsymbol q,\dot{\boldsymbol q})K_r^{-1}\dot{\boldsymbol q}_m + K_r^{-1}\boldsymbol g(\boldsymbol q) \quad(+K_r^{-1}F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}). \tag{7.2-4}$$

**两级衰减物理意义**：
- **惯量偏差与速度耦合按 $1/k_r^2$（矩阵元层面）衰减**：电机转子本身惯量 $I_{m_i}$ 不衰减，因此大减速比下电机总惯量近似常值 $J_i\approx I_{m_i}$；跨轴惯量偏差按 $1/(k_{r_i}k_{r_j})$ 缩小（折算以实际连杆状态 $\ddot q,\dot q$ 表达时，力矩层面按 $1/k_{r_i}$ 缩小）；
- **重力与干摩擦按 $1/k_r$ 衰减**：直接经 $K_r^{-1}$ 折回电机轴。

每个关节抽象为独立定常线性对象 $J_i\ddot q_{m_i}+F_{m_i}\dot q_{m_i}+d_i=\tau_{m_i}$。当且仅当指定轨迹下的残余 $d_i$ 处在该单轴闭环抑制能力以内，分散控制才成立（直驱 $k_r=1$ 或超高速运动常导致 $d_i$ 与驱动能力同量级）。

<a id="sec-7.2.2"></a>

## 7.2.2 三种单轴控制器结构与稳态误差对比

对单个线性通道（输出位置 $\theta_m$，含电机一阶环节 $\frac{k_m}{1+sT_m}$ 与积分 $\frac{1}{s}$），依据传感配置从以下三种反馈架构中**任选一套**（不可将三套控制器盲目串联叠加）：

| 控制架构 | 所需状态传感器 | 典型控制器配置 | 工程特点 |
|:--|:--|:--|:--|
| 位置反馈 | $\theta_m$ | $C_p(s)=K_P\frac{1+sT_p}{s}$ (PI) 或 PD | 结构最简；点位控制常用 |
| 位置 + 速度反馈 | $\theta_m,\ \dot\theta_m$ | $C_p=K_P,\quad C_v(s)=K_v\frac{1+sT_v}{s}$ | 速度内环主动调节阻尼比与超调 |
| 位置 + 速度 + 加速度反馈 | $\theta_m,\ \dot\theta_m,\ \hat{\ddot\theta}_m$ | $C_p=K_P,\ C_v(s),\ C_A=1$（配 $K_A$） | 多出一阶自由度，可独立配置 $(\omega_n,\zeta)$ 与 $X_R$ |

实际系统常无高精度加速度计，而通过一阶高通滤除直流、抑制高频噪声的伪微分器重构加速度（低频近似微分，高频幅频增益有界收敛至 $1/T_a$）：

$$\hat{\ddot\theta}_m(s) = \frac{s}{1+sT_a}\dot\theta_m(s). \tag{7.2-7}$$

**PD vs PI/PID 抵抗常值扰动的稳态差别**：对定常期望及常值重力扰动 $d_0$（对象 $J\ddot q+F\dot q+d_0=u$）：
- 纯 PD（$u=K_Pe-K_D\dot q$）在稳态 $\dot q=\ddot q=0$ 时必遗留非零静差 $e_\infty=d_0/K_P$；
- 引入积分项（$K_I\int e\,\mathrm dt$）后，若闭环稳定且不饱和，积分器自动积累至等于 $d_0$ 从而消除静差 $e_\infty=0$，但代价是减小相位裕度并易触发积分饱和（需抗积分饱和 clamping）。

<a id="sec-7.2.3"></a>

## 7.2.3 位置 PI 闭环 Routh 判据、根轨迹与极点配置

考虑采用位置传感器增益 $k_{tp}$ 的位置 PI 单轴闭环，开环传递函数为 II 型三阶系统：

$$L(s) = \frac{k_m K_P k_{tp}(1+sT_p)}{s^2(1+sT_m)}. \tag{7.2-8}$$

::: thm 定理 7.2.1 · 位置 PI 闭环稳定性条件（Routh 判据） {#thm-7.2.1}
设电机增益 $k_m>0$、控制器参数 $K_P>0, T_p>0$、电机时间常数 $T_m>0$、传感器增益 $k_{tp}>0$。单位负反馈闭环系统稳定的充要条件为控制器零点时间常数大于电机极点时间常数：

$$T_p > T_m.$$

若 $T_p < T_m$，不论比例增益 $K_P$ 如何调节，闭环总有右半平面极点，系统结构不稳定。
:::

::: sol 证明
记 $a=k_mK_Pk_{tp}>0$，特征方程为 $T_ms^3+s^2+aT_ps+a=0$。构造 Routh 阵列：

$$\begin{array}{c|cc}
s^3 & T_m & aT_p \\
s^2 & 1 & a \\
s^1 & a(T_p-T_m) & 0 \\
s^0 & a & 0
\end{array}$$

首列严格全正要求 $a(T_p-T_m)>0 \iff T_p>T_m$。进一步由根轨迹渐近线质心公式（$n_p=3,\ n_z=1$，渐近线角度 $\pm 90^\circ$）：

$$\sigma_a = \frac{1/T_p - 1/T_m}{2}.$$

可见：(a) 若 $T_p<T_m$，则 $\sigma_a>0$，自原点重极点出发的两支轨迹必然直接弯曲进入右半平面；(b) 若 $T_p>T_m$，则 $\sigma_a<0$，原点分支稳定弯入左半平面形成复共轭主导极点；(c) 若 $T_p\gg T_m$，质心更靠左，两主导支路迅速进入左半平面（精确闭环极点仍由特征方程求根并校核离散周期）。
:::

### 两套单轴极点配置口径（切勿混用单位）

1. **口径一（位置 P + 速度 PI，或附加加速度环）**：令速度环零点抵消电机极点（$T_v=T_m$），对理想二阶分母 $1+\frac{2\zeta}{\omega_n}s+\frac{1}{\omega_n^2}s^2$ 得：
   - 位置+速度双环：$K_v k_{tv} = \frac{2\zeta\omega_n}{k_m},\quad K_P k_{tp} K_v = \frac{\omega_n^2}{k_m}$（此时 $X_R$ 被 $(\omega_n,\zeta)$ 锁定）。
   - 增加加速度环（$K_A,k_{ta}$）：可将 $X_R=K_Pk_{tp}K_vK_A$ 与 $(\omega_n,\zeta)$ 解耦指定，只要 $\frac{k_m X_R}{\omega_n^2}>1$，满足 $\frac{2K_Pk_{tp}}{k_{tv}}=\frac{\omega_n}{\zeta},\quad k_mK_Ak_{ta}=\frac{k_m X_R}{\omega_n^2}-1$。
2. **口径二（单轴力矩 PD 极点配置）**：直接对机械轴 $J_i\ddot q_i+F_i\dot q_i+d_i=\tau_i$ 施加 $\tau_i=K_{P_i}(q_{d,i}-q_i)+K_{D_i}(\dot q_{d,i}-\dot q_i)$，令 $e_i=q_{d,i}-q_i$ 得精确线性误差方程：

$$J_i\ddot e_i + (F_i+K_{D_i})\dot e_i + K_{P_i}e_i = J_i\ddot q_{d,i}+F_i\dot q_{d,i}+d_i,$$

对应匹配二阶自然频率与阻尼比给出（单位 $\mathrm{N\cdot m/rad}$ 与 $\mathrm{N\cdot m\cdot s/rad}$，**包含惯量 $J_i$**）：

$$K_{P_i} = J_i\omega_{n_i}^2,\qquad K_{D_i} = 2\zeta_i J_i\omega_{n_i} - F_i.$$

<a id="sec-7.2.4"></a>

## 7.2.4 稳态误差与干扰抑制因子

由负载转矩扰动 $D(s)$ 到电机转角的闭环传递函数为

$$\frac{\Theta_m(s)}{D(s)} = -\frac{\frac{s R_a}{k_t K_P k_{tp}(1+sT_p)}}{1+\frac{s^2(1+sT_m)}{k_m K_P k_{tp}(1+sT_p)}}. \tag{7.2-11}$$

在 $T_p>T_m$ 闭环稳定时，终值定理给出常值负载扰动 $D_0/s$ 下稳态位置误差为零。动态/中频段干扰衰减程度由**干扰抑制因子 $X_R$** 决定，闭环响应衰减尺度估计为**收敛时间 $T_R$**：

$$X_R = K_P k_{tp},\qquad T_R = \max\!\left\{T_p,\ \frac{1}{\zeta\omega_n}\right\}. \tag{7.2-12, 7.2-13}$$

提高比例增益 $K_P$ 虽可扩大 $X_R$ 以更强压制干扰，但同时降低复共轭极点阻尼比 $\zeta$（加剧高频振荡）、放大传感噪声，并更易触发功放饱和。

<a id="sec-7.2.5"></a>

## 7.2.5 执行器驱动接口推导与分散控制成立定理

设减速比阵 $K_r$、力矩常数阵 $K_t$、电枢电阻阵 $R_a$、反电动势常数阵 $K_v$ 及功放电压增益阵 $G_v$ 均为正定对角阵。串联电枢电流 $\boldsymbol i_a$、电压 $\boldsymbol v_a$ 与控制电压 $\boldsymbol v_c$ 服从**驱动系统基本五式**：

$$\boldsymbol q_m=K_r\boldsymbol q,\quad \boldsymbol\tau_m=K_r^{-1}\boldsymbol\tau=K_t\boldsymbol i_a,\quad \boldsymbol v_a=R_a\boldsymbol i_a+K_v\dot{\boldsymbol q}_m,\quad \boldsymbol v_a=G_v\boldsymbol v_c. \tag{7.2-14}$$

三步消元：由 $\dot{\boldsymbol q}_m=K_r\dot{\boldsymbol q}$ 及 $\boldsymbol i_a=R_a^{-1}(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q})$ 代回 $\boldsymbol\tau=K_rK_t\boldsymbol i_a$，即得关节输出广义力与控制电压精确映射：

$$\boxed{\ \boldsymbol\tau = K_r K_t R_a^{-1}\bigl(G_v\boldsymbol v_c - K_v K_r\dot{\boldsymbol q}\bigr)\ } \tag{7.2-15}$$

::: thm 定理 7.2.A · 分散电压—速度近似的两条核心结论 {#thm-7.2.A}
对第 $i$ 个关节电枢方程 $G_{v,i}v_{c,i}=R_{a_i}i_{a_i}+k_{v_i}k_{r_i}\dot q_i$，当且仅当该轴电阻压降远小于反电动势：

$$|R_{a_i}i_{a_i}| \ll |k_{v_i}k_{r_i}\dot q_i|, \tag{7.2-16}$$

可忽略电枢压降项，得 $\boldsymbol v_c \approx G_v^{-1}K_vK_r\dot{\boldsymbol q}$。当此条件成立且参数阵为对角阵时：
1. 关节速度 $\dot{\boldsymbol q}$ 与控制指令 $\boldsymbol v_c$ 呈解耦比例关系，显式表达式中不含机械臂惯量与质量耦合参数（但机械臂负载仍决定实际所需电枢电流及近似偏差大小）；
2. 电机呈现“速度源”特性，为单轴独立解耦控制提供物理基础。
:::

**适用边界与两条工程出路**：静止（$\dot q_i=0$）或极低速重载悬停时反电动势趋零，抵抗重力所需电流与压降非零，条件 (7.2-16) 必失效，不得仅因“大减速比、低电阻”盲目套用速度源近似。当压降不可忽略时：
- **加高频宽电流内环**：迫使 $\boldsymbol i_a\approx G_i\boldsymbol v_c$ 从而直接获得受控力矩接口 $\boldsymbol\tau\approx K_rK_tG_i\boldsymbol v_c$（供集中力矩律或分散控制使用）；
- **加前馈或集中控制**：当耦合与压降超过单轴反馈带宽时转入计算前馈或整机非线性补偿。

<a id="sec-7.2.6"></a>
<a id="sec-7.2.7"></a>

## 7.2.6 分散名义前馈与计算转矩前馈

为消除高速运动下的纯反馈滞后，可利用已知期望轨迹 $(\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d)$（电机侧 $\boldsymbol q_{md}=K_r\boldsymbol q_d$）预先构造两级离线前馈电压补偿：

1. **分散名义前馈**：提前抵消单轴标称对象 $J_m\ddot{\boldsymbol q}_{md}+F_m\dot{\boldsymbol q}_{md}$ 及反电动势所需电压（亦可在框图中拆分至速度环与电流环端）：

$$\boldsymbol v_{c,\mathrm{nom}} = G_v^{-1}\Bigl[R_a K_t^{-1}(J_m\ddot{\boldsymbol q}_{md}+F_m\dot{\boldsymbol q}_{md}) + K_v\dot{\boldsymbol q}_{md}\Bigr]. \tag{7.2-17}$$

2. **计算转矩前馈（Computed Torque Feedforward）**：利用整机动力学模型在**期望状态**计算并前馈抵消残余耦合项 $\boldsymbol d_d$（仅补 $\Delta B(\boldsymbol q_d)$ 以避免与上式常对角阵 $\bar B$ 重复）：

$$\boldsymbol v_{c,\mathrm{ff}} = G_v^{-1}R_aK_t^{-1}\Bigl[K_r^{-1}\Delta B(\boldsymbol q_d)K_r^{-1}\ddot{\boldsymbol q}_{md} + K_r^{-1}C(\boldsymbol q_d,\dot{\boldsymbol q}_d)K_r^{-1}\dot{\boldsymbol q}_{md} + K_r^{-1}\boldsymbol g(\boldsymbol q_d)\Bigr]. \tag{7.2-18}$$

> **务必辨析术语**：这里的**计算转矩前馈**自变量是期望轨迹 $(\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d)$，可完全**离线预计算**；而 [7.3.4 节](sec7-3.md#sec-7.3.4)的**逆动力学（计算力矩）控制**使用**实时实测状态** $(\boldsymbol q,\dot{\boldsymbol q})$ 逐周期在线计算，属于闭环反馈线性化。

<a id="sec-7.2.8"></a>

## 本节小结

::: method 方法 7.2.B · 分散与集中控制工程选型流程 {#method-7.2.A}
1. **算折算**：计算电机侧等效惯量 $J_i=I_{m_i}+\bar b_{ii,\mathrm{link}}/k_{r_i}^2$ 与残余耦合尺度；
2. **查压降**：在目标轨迹下逐轴检验 $|R_{a_i}i_{a_i}|\ll|k_{v_i}k_{r_i}\dot q_i|$（静止工况失效）与驱动饱和；
3. **估误差**：核算 $\Delta B\ddot{\boldsymbol q},C\dot{\boldsymbol q},\boldsymbol g$ 对误差预算的冲击及单轴 PI 稳定裕度；
4. **定架构**：单轴反馈可压住选分散（优先加前馈减滞后）；低减速比、高速重载选[集中控制](sec7-3.md)；
5. **检实现**：核对离散采样延迟、噪声过滤与力矩限幅保护。
:::

| 公式 | 前提与条件 | 易错点 |
|:--|:--|:--|
| $K_r^{-1}\bar BK_r^{-1}\ddot{\boldsymbol q}_m+F_m\dot{\boldsymbol q}_m+\boldsymbol d=\boldsymbol\tau_m$ | $\bar B$ 取平均对角惯量 | $\boldsymbol d$ 并非无条件微小，低减速比与高速下可与 $\boldsymbol\tau_m$ 同阶 |
| $L(s)=\frac{k_mK_Pk_{tp}(1+sT_p)}{s^2(1+sT_m)}$，$X_R=K_Pk_{tp}$ | 正参数单轴 PI 位置环 | Routh 要求 $T_p>T_m$；$T_p\le T_m$ 结构不稳定，调增益无效 |
| $\boldsymbol\tau=K_rK_tR_a^{-1}(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q})$ | 对角五式驱动模型 | 速度源近似要求逐轴压降 $\ll$ 反电动势；有计算转矩前馈需保留 $G_v^{-1}$ 与 $\Delta B$ |

**下一节**：当耦合过于剧烈或精度要求严苛时，进入[7.3 集中控制](sec7-3.md)设计整机非线性补偿控制律并建立严格的 Lyapunov/LaSalle/Barbalat 稳定性证明。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 12:10 | [decentral-model.jpg](../assets/ch07/decentral-model.jpg) | 分散近似与电机轴动力学 | 7.2.1 完整推导两级衰减律与 (7.2-3)–(7.2-4) |
| 23:50 | [pos-rootlocus.jpg](../assets/ch07/pos-rootlocus.jpg) | 位置 PI 根轨迹三情形 | 定理 7.2.1 Routh 证明 + 质心与三形态分析 |
| 31:10 | [pos-disturbance.jpg](../assets/ch07/pos-disturbance.jpg) | 干扰传递函数与 $X_R,T_R$ | 7.2.4 导出稳态零误差与干扰衰减折中 |
| 32:00 | [pos-vel-loop.jpg](../assets/ch07/pos-vel-loop.jpg) | 位置 + 速度控制回路 | 7.2.2–7.2.3 三选一结构与极点配置对照 |
| 39:10 | [pos-vel-acc.jpg](../assets/ch07/pos-vel-acc.jpg) | 加速度高通重构滤波器 | 7.2.2 给出式 (7.2-7) 与噪声增益边界 |
| 40:30 | [decentral-feedforward.jpg](../assets/ch07/decentral-feedforward.jpg) | 分散名义前馈结构 | 7.2.6 给出式 (7.2-17) |
| 55:20 | [computed-torque-ff.jpg](../assets/ch07/computed-torque-ff.jpg) | 计算转矩前馈 | 7.2.6 式 (7.2-18) 并与 7.3.4 在线逆动力学严格区分 |
| 02:09:04 | [joint-eom.jpg](../assets/ch07/joint-eom.jpg) | 关节动力学接口导入 | 7.2.5 完整导出电枢与机械联立五式 |
| 02:09:21 | [drive-model.jpg](../assets/ch07/drive-model.jpg) | 直流驱动系统框图 | 7.2.5 五式方程给出 |
| 02:11:59 | [tau-vc.jpg](../assets/ch07/tau-vc.jpg) | $\boldsymbol\tau$ 与 $\boldsymbol v_c$ 精确式 | 7.2.5 式 (7.2-15) |
| 02:13:29 | [decentral-assume.jpg](../assets/ch07/decentral-assume.jpg) | 电压—速度近似假设与两条结论 | 定理 7.2.A 完整表述及静止边界说明 |
| 02:13:30 实拍 | [board-tau-vc.jpg](../assets/ch07/board-tau-vc.jpg) | 讲台推导板书 | 推导已全部书面化 |
| 02:14:22 | [centralized-reason.jpg](../assets/ch07/centralized-reason.jpg) | 压降不可忽略时的局限 | 7.2.5 与方法 7.2.A 汇总工程判据 |
| 02:16:01 | [current-loop.jpg](../assets/ch07/current-loop.jpg) | 电流内环力矩控制接口 | 7.2.5 给出 $\boldsymbol\tau\approx K_rK_tG_i\boldsymbol v_c$ 工程出路 |
:::
