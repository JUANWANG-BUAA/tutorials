# 6.1 拉格朗日公式

牛顿第二定律要求对每根连杆画出完整的受力图，连杆之间的约束反力和内力矩必须显式列出，再联立消元。自由度升高后，矢量投影和约束消元迅速变得繁琐。

**拉格朗日法（Lagrangian formulation）** 从系统动能和势能这两个标量出发。凡理想约束（理想铰链、刚性连接）在虚位移上所做虚功为零，约束内力从一开始就不会进入方程。本节先建立基本方程并借助单摆核对传动折算，再推导一般开链机器人的动能矩阵 $B(\boldsymbol q)$、势能梯度 $\boldsymbol g(\boldsymbol q)$ 与完整运动方程。

本节要点导航：[拉格朗日方程与广义力](#part-6.1) · [动能与惯性矩阵](#part-6.1.1) · [势能与重力矩](#part-6.1.2) · [关节空间运动方程](#part-6.1.3)。

<a id="part-6.1"></a>
<a id="611-从力换到能量"></a>

## 6.1.1 拉格朗日方程与广义力

对拥有 $n$ 个自由度的机械系统，选取一组彼此独立的**广义坐标** $\boldsymbol q=[q_1,\dots,q_n]^{\mathrm T}\in\mathbb R^n$（对开链串联机械臂，直接取各关节变量 $\vartheta_i$ 或 $d_i$）。系统的机械能由标量动能 $T(\boldsymbol q,\dot{\boldsymbol q})$ 与标量势能 $U(\boldsymbol q)$ 刻画。

::: def 定义 6.1.1 · 拉格朗日函数与拉格朗日方程 {#def-6.1.1}
系统的**拉格朗日函数**定义为动能与势能之差：

$$\mathcal L(\boldsymbol q,\dot{\boldsymbol q}) = T(\boldsymbol q,\dot{\boldsymbol q}) - U(\boldsymbol q).$$

当系统所受约束均为理想完整约束时，第 $i$ 个广义坐标满足**第二类拉格朗日方程**：

$$\frac{\mathrm d}{\mathrm dt}\!\left(\frac{\partial\mathcal L}{\partial\dot q_i}\right) - \frac{\partial\mathcal L}{\partial q_i} = \xi_i,\qquad i=1,\dots,n,$$

写为列向量紧凑形式：

$$\frac{\mathrm d}{\mathrm dt}\!\left(\frac{\partial\mathcal L}{\partial\dot{\boldsymbol q}}\right)^{\mathrm T} - \left(\frac{\partial\mathcal L}{\partial\boldsymbol q}\right)^{\mathrm T} = \boldsymbol\xi.$$

其中 $\boldsymbol\xi\in\mathbb R^n$ 为对应广义坐标 $\boldsymbol q$ 的**非保守广义力**向量（转动关节取力矩 $\mathrm{N\cdot m}$，移动关节取力 $\mathrm N$）。
:::

> **直观检验（单质点回推牛顿方程）**：对一维质量为 $m$、势能仅来自弹簧 $U(x)=\frac12kx^2$ 的质点，$\mathcal L=\frac12m\dot x^2-\frac12kx^2$。代入定义式得 $\frac{\mathrm d}{\mathrm dt}(m\dot x)-(-kx)=m\ddot x+kx=\xi$，其中弹簧弹性力被自动归入 $-\partial\mathcal L/\partial x=+\partial U/\partial x$ 这一侧，右端 $\xi$ 仅留外加驱动力与阻尼力。

<a id="612-广义力-ξiξi-的四个来源"></a>
<a id="part-6.1.generalized-force"></a>

### 非保守广义力的四个来源

广义力 $\xi_i$ 由虚功原理 $\delta W_{\mathrm{nc}}=\sum_{i=1}^n \xi_i\,\delta q_i$ 唯一确定。对于开链机械臂，约束反力和保守重力已被方程左侧自动吸收，右端 $\boldsymbol\xi$ 只包含四类非保守效应：

| 序号 | 来源 | 在右端 $\boldsymbol\xi$ 中的贡献 | 说明与边界 |
|:--|:--|:--|:--|
| 1 | 关节执行器驱动 | $+\boldsymbol\tau$ | 已按[第 5 章](../ch05/sec5-2.md)刚性传动折算到关节侧（转动关节 $\tau_i=k_{r_i}\tau_{m_i}$） |
| 2 | 粘滞摩擦阻力 | $-F_{\mathrm v}\dot{\boldsymbol q}$ | 与速度反向成正比，$F_{\mathrm v}=\operatorname{diag}(F_{v1},\dots,F_{vn})$ 含折算后电机端阻力 |
| 3 | 滑动库仑摩擦 | $-F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})$ | 仅描述 $\dot q_i\neq 0$ 时的恒幅滑动干摩擦；零速静摩擦需另建粘滑模型 |
| 4 | 末端接触反力 | $-J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e$ | **约定**：$\boldsymbol h_e$ 为末端执行器**施加给环境**的广义力，环境反作用为 $-\boldsymbol h_e$ |

综上，广义力向量写为

$$\boldsymbol\xi = \boldsymbol\tau - F_{\mathrm v}\dot{\boldsymbol q} - F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q}) - J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e.$$

<a id="613-例-71带齿轮的摆老师逐行推的第一道题"></a>
<a id="part-6.1.pendulum"></a>

::: ex 例 6.1.1 · 带齿轮的单摆（原书例 7.1）
一单摆的质量为 $m$，质心距铰点 $O$ 的距离为 $l$，连杆绕 $O$ 的转动惯量为 $I$，转角 $\vartheta$ 自竖直下垂位置逆时针度量。驱动电机通过减速比 $k_r$（刚性无背隙）驱动关节：转子转动惯量为 $I_m$、转子粘滞摩擦系数为 $F_m$、关节自身粘滞摩擦系数为 $F$，电机输出转矩为 $\tau_m$，关节侧等效驱动力矩为 $\tau=k_r\tau_m$。试用拉格朗日方程导出系统运动方程。

::: sol 解
1. **动能**：连杆角速度为 $\dot\vartheta$，刚性传动下转子角速度为 $\omega_m = k_r\dot\vartheta$，故总动能为

$$T = \frac12 I\dot\vartheta^2 + \frac12 I_m(k_r\dot\vartheta)^2 = \frac12(I + k_r^2I_m)\dot\vartheta^2.$$

2. **势能**：以下垂位置 $\vartheta=0$ 为零势能参考面，质心高度升高 $l(1-\cos\vartheta)$，则

$$U = mgl(1-\cos\vartheta).$$

3. **求导代入**：取 $\mathcal L=T-U$，计算偏导与时间导数

$$\frac{\mathrm d}{\mathrm dt}\!\left(\frac{\partial\mathcal L}{\partial\dot\vartheta}\right) = (I+k_r^2I_m)\ddot\vartheta,\qquad -\frac{\partial\mathcal L}{\partial\vartheta} = mgl\sin\vartheta.$$

4. **广义力（按虚功折算）**：微小虚位移 $\delta\vartheta$ 对应转子虚转角 $\delta\vartheta_m=k_r\delta\vartheta$，非保守力虚功为

$$\delta W_{\mathrm{nc}} = \tau_m\,\delta\vartheta_m - F_m\dot\vartheta_m\,\delta\vartheta_m - F\dot\vartheta\,\delta\vartheta = \bigl(\tau - (F+k_r^2F_m)\dot\vartheta\bigr)\delta\vartheta.$$

令左端等于广义力 $\xi$ 并整理阻尼项，得到完整关节侧运动方程：

$$\boxed{\ (I + k_r^2I_m)\ddot\vartheta + (F + k_r^2F_m)\dot\vartheta + mgl\sin\vartheta = \tau\ }$$

这与[第 5 章 5.2 节](../ch05/sec5-2.md)用牛顿力矩平衡直接折算传动比得到的结果完全一致：能量法自动把 $k_r^2$ 倍的惯量与阻尼折算系数带入模型，且揭示了单连杆唯一非线性来源于重力项 $\sin\vartheta$。
:::
:::

::: think 思考与核算 · 减速比翻倍，所需驱动力矩翻四倍吗？
设摆杆惯量 $I=0.4\ \mathrm{kg\cdot m^2}$、转子惯量 $I_m=0.002\ \mathrm{kg\cdot m^2}$，忽略摩擦，在下垂位置 $\vartheta=0,\dot\vartheta=0$ 处产生 $\ddot\vartheta=1\ \mathrm{rad/s^2}$。求 $k_r=10$ 与 $k_r=20$ 时关节侧所需力矩 $\tau$，并计算 $k_r=10$ 时电机转子惯量在总等效惯量中的占比。

::: sol 答案
- $k_r=10$ 时：$I_{\mathrm{eq}} = 0.4 + 0.002\times100 = 0.6\ \mathrm{kg\cdot m^2}$，$\tau = 0.6\ \mathrm{N\cdot m}$；转子惯量占比为 $0.2/0.6 = 1/3$。
- $k_r=20$ 时：$I_{\mathrm{eq}} = 0.4 + 0.002\times400 = 1.2\ \mathrm{kg\cdot m^2}$，$\tau = 1.2\ \mathrm{N\cdot m}$。

仅转子项扩大四倍，连杆本体惯量保持不变，因此总等效惯量与关节侧驱动力矩翻了两倍（但在 $k_r\gg1$ 时，转子项常主导总惯量）。
:::
:::

<a id="614-拉格朗日法与牛顿欧拉法的分工"></a>

### 两种建模路线的工程分工

| 比较维度 | 拉格朗日法（6.1–6.3） | 牛顿–欧拉法（6.4） |
|:--|:--|:--|
| 出发量 | 标量能量 $T(\boldsymbol q,\dot{\boldsymbol q})$、$U(\boldsymbol q)$ | 逐杆牛顿–欧拉矢量方程 |
| 约束内力 | 虚功自动消去，不显式出现 | 显式传递并最终投影消元 |
| 输出形态 | 闭合矩阵方程（显式给出 $B,C,\boldsymbol g$） | 数值递推结果 $\boldsymbol\tau$（不直接暴露 $B,C$） |
| 适用场景 | 理论推导、结构性质分析、控制律设计、低自由度手算 | 编程仿真与 $O(n)$ 实时逆动力学计算 |

两类方法针对同一刚体机械臂必定给出完全一致的输入-运动关系，控制律所需的是方程本身的结构与数值。

<a id="615-小结与常见错误"></a>
<a id="part-6.1.intro-summary"></a>
<a id="part-6.1.1"></a>

## 6.1.2 动能与关节空间惯性矩阵

将单连杆方法推广到 $n$ 自由度机械臂时，总动能等于全部连杆（记作下标 $i$）与各驱动电机转子（记作下标 $m_i$）动能之和：

$$T = \sum_{i=1}^{n}\bigl(T_{\ell_i} + T_{m_i}\bigr).$$

### 连杆 $i$ 的柯尼希分解与惯性张量

考察刚体连杆 $i$ 的微元 $\mathrm dm=\rho\,\mathrm dV$。设在基坐标系下质心位置为 $\boldsymbol p_{\ell_i}$、角速度为 $\boldsymbol\omega_i$，微元相对质心的位置矢量为 $\boldsymbol r=\boldsymbol p-\boldsymbol p_{\ell_i}$，则微元速度为 $\dot{\boldsymbol p}=\dot{\boldsymbol p}_{\ell_i}+\boldsymbol\omega_i\times\boldsymbol r$。对整根连杆积分动能：

$$\begin{aligned}
T_{\ell_i}
&= \frac12\int_{V_{\ell_i}} \|\dot{\boldsymbol p}_{\ell_i}+\boldsymbol\omega_i\times\boldsymbol r\|^2 \rho\,\mathrm dV \\
&= \frac12\left(\int_{V_{\ell_i}}\rho\,\mathrm dV\right)\dot{\boldsymbol p}_{\ell_i}^{\mathrm T}\dot{\boldsymbol p}_{\ell_i}
   + \dot{\boldsymbol p}_{\ell_i}^{\mathrm T}\!\left(\boldsymbol\omega_i\times\int_{V_{\ell_i}}\boldsymbol r\rho\,\mathrm dV\right)
   + \frac12\int_{V_{\ell_i}} (\boldsymbol\omega_i\times\boldsymbol r)^{\mathrm T}(\boldsymbol\omega_i\times\boldsymbol r)\rho\,\mathrm dV.
\end{aligned}$$

由质心定义，$\int_{V_{\ell_i}}\boldsymbol r\,\rho\,\mathrm dV=\boldsymbol 0$，**中间交叉项严格为零**（前提是参考点恰好取在质心；若改取关节原点等非质心点，交叉项将保留一阶矩）。利用叉乘矩阵 $S(\boldsymbol r)\boldsymbol\omega_i = -\boldsymbol\omega_i\times\boldsymbol r$ 整理第三项，得到平动加转动的经典结构：

$$T_{\ell_i} = \frac12 m_{\ell_i}\dot{\boldsymbol p}_{\ell_i}^{\mathrm T}\dot{\boldsymbol p}_{\ell_i} + \frac12\boldsymbol\omega_i^{\mathrm T}\boldsymbol I_{\ell_i}\boldsymbol\omega_i,$$

其中惯性张量定义为对称半正定矩阵（非退化刚体为正定）：

$$\boldsymbol I_{\ell_i} = \int_{V_{\ell_i}} S^{\mathrm T}(\boldsymbol r)S(\boldsymbol r)\rho\,\mathrm dV = \begin{bmatrix}I_{xx}&-I_{xy}&-I_{xz}\\-I_{xy}&I_{yy}&-I_{yz}\\-I_{xz}&-I_{yz}&I_{zz}\end{bmatrix}.$$

::: note 坐标变换与平行轴定理
1. **惯性张量随连杆旋转**：若基座系直接积分 $\boldsymbol I_{\ell_i}$，它会随关节角 $\boldsymbol q$ 改变。在固连于连杆 $i$、原点位于质心 $\ell_i$ 的局部系中，惯性张量 $\boldsymbol I_{\ell_i}^i$ 为**常对称矩阵**；借助旋转矩阵 $\boldsymbol R_i(\boldsymbol q)$ 转换至基座系：

$$\boldsymbol I_{\ell_i} = \boldsymbol R_i\boldsymbol I_{\ell_i}^i\boldsymbol R_i^{\mathrm T}.$$

2. **平行轴定理（Steiner 定理）**：当转动参考点从质心 $C$ 平移到与质心相距 $\boldsymbol r$ 的任意点 $O$ 时，相对 $O$ 点的惯性张量为

$$\boldsymbol I_O = \boldsymbol I_C + m\bigl(\|\boldsymbol r\|^2\boldsymbol E_3 - \boldsymbol r\boldsymbol r^{\mathrm T}\bigr),$$

标量一维形式即为 $I_O = I_C + md^2$。对长度为 $l$、质量为 $m$ 的均匀细杆，$I_C=\frac{1}{12}ml^2$，绕端点的转动惯量为 $\frac{1}{12}ml^2+m(l/2)^2=\frac13ml^2$。
:::

### 引入几何雅可比

借用[第 3 章](../ch03/sec3-1.md)连杆 $i$ 质心的平动雅可比 $J_P^{(\ell_i)}$ 与连杆角速度雅可比 $J_O^{(\ell_i)}$（各仅对第 $1\dots i$ 个关节有非零列）：

$$\dot{\boldsymbol p}_{\ell_i} = J_P^{(\ell_i)}(\boldsymbol q)\dot{\boldsymbol q},\qquad \boldsymbol\omega_i = J_O^{(\ell_i)}(\boldsymbol q)\dot{\boldsymbol q}.$$

连杆 $i$ 的动能完全写为关于 $\dot{\boldsymbol q}$ 的二次型：

$$T_{\ell_i} = \frac12\dot{\boldsymbol q}^{\mathrm T}\Bigl(m_{\ell_i}J_P^{(\ell_i)\mathrm T}J_P^{(\ell_i)} + J_O^{(\ell_i)\mathrm T}\boldsymbol R_i\boldsymbol I_{\ell_i}^i\boldsymbol R_i^{\mathrm T}J_O^{(\ell_i)}\Bigr)\dot{\boldsymbol q}.$$

### 电机转子动能的建模约定

驱动第 $i$ 个关节的电机定子通常安装在上一根连杆 $i-1$ 上。记转子质心线速度为 $\dot{\boldsymbol p}_{m_i}=J_P^{(m_i)}\dot{\boldsymbol q}$，设转子自转轴单位向量为 $\boldsymbol z_{m_i}$、传动比为 $k_{r_i}$，则转子总角速度等于安装座（连杆 $i-1$）角速度与自身相对转速叠加：

$$\boldsymbol\omega_{m_i} = \boldsymbol\omega_{i-1} + k_{r_i}\dot q_i\boldsymbol z_{m_i} = J_O^{(m_i)}(\boldsymbol q)\dot{\boldsymbol q}.$$

相应矩阵 $J_O^{(m_i)}$ 前 $i-1$ 列与 $J_O^{(\ell_{i-1})}$ 相同，第 $i$ 列等于 $k_{r_i}\boldsymbol z_{m_i}$，第 $i+1\dots n$ 列全为零。

::: note 移动关节中的 $k_{r_i}$ 量纲陷阱
转动关节下，减速比 $k_{r_i}=\dot\vartheta_{m_i}/\dot\vartheta_i$ **无量纲**。若第 $i$ 关节由丝杠等旋转–直线机构驱动的移动关节（$\dot\vartheta_{m_i}=k_{r_i}\dot d_i$），$k_{r_i}$ 的单位为 $\mathrm{rad/m}$。此时公式形式 $I_{m_i}k_{r_i}^2\dot d_i^2$ 保持不变，量纲为 $(\mathrm{kg\cdot m^2})(\mathrm{rad/m})^2(\mathrm{m/s})^2=\mathrm{J}$，代表线性等效质量，切勿当成无量纲比值。
:::

### 关节空间惯性矩阵 $B(\boldsymbol q)$ 及其三条性质

把所有连杆与转子的动能相加，得到整个机械臂的总动能：

$$\boxed{\ T(\boldsymbol q,\dot{\boldsymbol q}) = \frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}\ }$$

其中 $n\times n$ **关节空间惯性矩阵（manipulator inertia matrix）**为

$$B(\boldsymbol q) = \sum_{i=1}^{n}\Bigl(m_{\ell_i}J_P^{(\ell_i)\mathrm T}J_P^{(\ell_i)} + J_O^{(\ell_i)\mathrm T}\boldsymbol R_i\boldsymbol I_{\ell_i}^i\boldsymbol R_i^{\mathrm T}J_O^{(\ell_i)} + m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)} + J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\Bigr).$$

对非退化刚体模型（任意非零独立关节速度均激发至少一个刚体部件的非零平动或转动速度），$B(\boldsymbol q)$ 恒满足三条关键性质：

1. **对称性（Symmetric）**：由转置累加形式直接得 $B^{\mathrm T}(\boldsymbol q)=B(\boldsymbol q)$。
2. **正定性（Positive Definite）**：任意 $\dot{\boldsymbol q}\neq\boldsymbol 0$ 均有 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}>0$，因此 $B(\boldsymbol q)\succ 0$，且逆矩阵 $B^{-1}(\boldsymbol q)$ 在全工作空间存在（注：若教学理想模型忽略某个独立关节驱动部件的质量与惯量，则可能退化为半正定）。
3. **位形相关性（Configuration-dependent）**：对于含转动关节的串联机械臂，雅可比与旋转矩阵依赖 $\boldsymbol q$，使 $B=B(\boldsymbol q)$ 一般非常数矩阵。

<a id="part-6.1.2"></a>

## 6.1.3 势能、重力项与符号约定

对刚体系统（忽略连杆与传动柔性变形时），势能仅来自重力。沿基坐标系重力加速度矢量 $\boldsymbol g_0$ 累加全部连杆和电机转子的重力势能：

$$U(\boldsymbol q) = -\sum_{i=1}^{n}\bigl(m_{\ell_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{\ell_i}(\boldsymbol q) + m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i}(\boldsymbol q)\bigr).$$

注意两条根本性质：
- $U(\boldsymbol q)$ **只依赖广义坐标 $\boldsymbol q$**，与广义速度 $\dot{\boldsymbol q}$ 无关（$\partial U/\partial\dot{\boldsymbol q}=\boldsymbol 0$）。
- $U$ 添加任意常参考零点不影响梯度 $\partial U/\partial\boldsymbol q$。

用链式法则对 $q_i$ 求偏导并引入平动雅可比 $\partial\boldsymbol p/\partial q_i = \boldsymbol J_{P,i}$（雅可比第 $i$ 列），定义动力学方程**左端**的**重力补偿项**：

$$\boxed{\ g_i(\boldsymbol q) = \frac{\partial U(\boldsymbol q)}{\partial q_i} = -\sum_{j=1}^{n}\Bigl(m_{\ell_j}\boldsymbol g_0^{\mathrm T}\boldsymbol j_{P,i}^{(\ell_j)}(\boldsymbol q) + m_{m_j}\boldsymbol g_0^{\mathrm T}\boldsymbol j_{P,i}^{(m_j)}(\boldsymbol q)\Bigr)\ }$$

写成列向量即 $\boldsymbol g(\boldsymbol q) = \bigl(\partial U/\partial\boldsymbol q\bigr)^{\mathrm T}$。

::: note 必分清的符号：左端重力项 $\boldsymbol g(\boldsymbol q)$ vs 实际重力广义力 $\boldsymbol\tau_{\mathrm{grav}}$
从物理虚功上看，重力本身是 $\boldsymbol F_{g}=m\boldsymbol g_0$，它施加到各关节上的**实际重力广义力**是

$$\boldsymbol\tau_{\mathrm{grav}} = \sum_{j=1}^n\bigl(m_{\ell_j}J_P^{(\ell_j)\mathrm T}\boldsymbol g_0 + m_{m_j}J_P^{(m_j)\mathrm T}\boldsymbol g_0\bigr) = -\boldsymbol g(\boldsymbol q).$$

两者恰好互为相反数：
- 若把重力放在动力学方程**左端**与惯性项并列：$B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau$，静止保持（$\ddot{\boldsymbol q}=\dot{\boldsymbol q}=\boldsymbol 0$）时执行器输出为 $\boldsymbol\tau = \boldsymbol g(\boldsymbol q)$；
- 若把实际重力看作作用在系统上的外广义力放回右端，则等价写作 $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}=\boldsymbol\tau+\boldsymbol\tau_{\mathrm{grav}}$。

工程中常在控制律里写“前馈 $+\hat{\boldsymbol g}(\boldsymbol q)$”，正是因为执行器需要出正力矩去**抵消**实际重力，因此必须对齐符号：$\boldsymbol g(\boldsymbol q)+\boldsymbol\tau_{\mathrm{grav}}=\boldsymbol 0$。
:::

::: ex 例 6.1.2.A · 单摆双路径符号核对 {#ex-6.1.2.A}
设单点质量 $m=2\ \mathrm{kg}$ 摆球挂于距铰点 $l=0.5\ \mathrm m$ 处（忽略杆与转子）。取基坐标系 $+z$ 竖直向上，$\boldsymbol g_0=[0,0,-g]^{\mathrm T}$（$g=9.81\ \mathrm{m/s^2}$），摆角 $q$ 自竖直向下方向朝 $+x$ 逆时针增大，质心位置 $\boldsymbol p(q)=[l\sin q,\,0,\,-l\cos q]^{\mathrm T}$。求 $q=\pi/6$ 处的左端重力项 $g(q)$、实际重力广义力 $\tau_{\mathrm{grav}}$ 以及静止保持力矩 $\tau$。

::: sol 解
- **路径 A（势能求导）**：取 $\boldsymbol p=[l\sin q,0,-l\cos q]^{\mathrm T}$，加常数使 $q=0$ 处势能为零得 $U(q)=mgl(1-\cos q)$。求偏导：

$$g(q)=\frac{\partial U}{\partial q}=mgl\sin q\implies g(\pi/6)=2\times 9.81\times 0.5\times\frac12 = +4.905\ \mathrm{N\cdot m}.$$

静止保持所需电机输出 $\tau = g(\pi/6) = +4.905\ \mathrm{N\cdot m}$。
- **路径 B（力与雅可比）**：质心平动雅可比 $J_P=\frac{\partial\boldsymbol p}{\partial q}=[l\cos q,\,0,\,l\sin q]^{\mathrm T}$，重力矢量 $m\boldsymbol g_0=[0,\,0,\,-mg]^{\mathrm T}$，则实际重力广义力：

$$\tau_{\mathrm{grav}} = J_P^{\mathrm T}(m\boldsymbol g_0) = -mgl\sin q = -4.905\ \mathrm{N\cdot m}.$$

两条路径恒满足 $g+\tau_{\mathrm{grav}}=0$。势能加减常数不会改变梯度；若出现两者同号，必定是坐标系或角度正向定义不一致。
:::
:::

::: think 迁移自检 · 改用水平基准定义角度
若改从 $+x$ 轴（水平向右）向上量取角度 $\alpha = q-\pi/2$，质心坐标写为 $\boldsymbol p(\alpha)=[l\cos\alpha,\,0,\,l\sin\alpha]^{\mathrm T}$。写出势能梯度重力项 $g_\alpha(\alpha)$，并在同一物理位置 $\alpha=-\pi/3$ 处核对保持力矩数值。

::: sol 答案
$U(\alpha)=mgl\sin\alpha+\text{常数}$，故 $g_\alpha(\alpha)=\partial U/\partial\alpha = mgl\cos\alpha$。在 $\alpha=-\pi/3$ 处得 $g_\alpha(-\pi/3)=2\times9.81\times0.5\times\cos(-\pi/3)=+4.905\ \mathrm{N\cdot m}$，实际重力广义力仍为 $-4.905\ \mathrm{N\cdot m}$——换坐标定义只改变函数解析形式，不改变物理力矩大小与方向。
:::
:::

<a id="part-6.1.3"></a>

## 6.1.4 关节空间运动方程

将 $T(\boldsymbol q,\dot{\boldsymbol q})=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}$ 与 $U(\boldsymbol q)$ 写入拉格朗日函数 $\mathcal L = \frac12\sum_{j,k}b_{jk}(\boldsymbol q)\dot q_j\dot q_k - U(\boldsymbol q)$，逐项求导计算左端第 $i$ 分量。

1. **先求速度偏导及时间全导数**（利用 $B$ 对称，$b_{ij}=b_{ji}$）：

$$\frac{\partial\mathcal L}{\partial\dot q_i} = \sum_{j=1}^{n}b_{ij}(\boldsymbol q)\dot q_j \implies \frac{\mathrm d}{\mathrm dt}\!\left(\frac{\partial\mathcal L}{\partial\dot q_i}\right) = \sum_{j=1}^{n}b_{ij}(\boldsymbol q)\ddot q_j + \sum_{j=1}^{n}\sum_{k=1}^{n}\frac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j.$$

2. **再求位置偏导**（$U$ 与速度无关，只对 $B(\boldsymbol q)$ 与 $U(\boldsymbol q)$ 求导）：

$$\frac{\partial\mathcal L}{\partial q_i} = \frac12\sum_{j=1}^{n}\sum_{k=1}^{n}\frac{\partial b_{jk}}{\partial q_i}\dot q_k\dot q_j - \frac{\partial U}{\partial q_i}.$$

两式相减，记三指标系数

$$h_{ijk}(\boldsymbol q) = \frac{\partial b_{ij}}{\partial q_k} - \frac12\frac{\partial b_{jk}}{\partial q_i},$$

并将 $g_i(\boldsymbol q)=\partial U/\partial q_i$ 记为左端重力项，即得各关节分量的动力学方程：

$$\boxed{\ \sum_{j=1}^{n}b_{ij}(\boldsymbol q)\ddot q_j + \sum_{j=1}^{n}\sum_{k=1}^{n}h_{ijk}(\boldsymbol q)\dot q_k\dot q_j + g_i(\boldsymbol q) = \xi_i,\qquad i=1,\dots,n\ }$$

### 紧凑矩阵形式与各项命名

构造 $n\times n$ 矩阵 $C(\boldsymbol q,\dot{\boldsymbol q})$，使其满足速度二次项映射

$$\sum_{j=1}^{n}c_{ij}(\boldsymbol q,\dot{\boldsymbol q})\dot q_j = \sum_{j=1}^{n}\sum_{k=1}^{n}h_{ijk}(\boldsymbol q)\dot q_k\dot q_j.$$

再将右端广义力中的摩擦阻力移至方程左端，得到全章最核心的**关节空间封闭运动方程**：

$$\boxed{\ B(\boldsymbol q)\ddot{\boldsymbol q} + C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q} + F_{\mathrm v}\dot{\boldsymbol q} + F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q}) + \boldsymbol g(\boldsymbol q) = \boldsymbol\tau - J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e\ }$$

| 数学项 | 物理名称 | 意义与读法 |
|:--|:--|:--|
| $b_{ii}\ddot q_i$ | 自惯量项 | 其余关节加速度为零时，使关节 $i$ 产生单位加速度所需的等效惯量（物理上是锁死其余关节后驱动轴感受到的惯量，含下游连杆及转子） |
| $b_{ij}\ddot q_j\ (i\neq j)$ | 耦合惯量项 | 关节 $j$ 的加速度通过连杆结构传递到关节 $i$ 的惯性耦合效应 |
| $h_{ijj}\dot q_j^2$ | 离心项 | 仅由单关节速度平方引起的径向/等效离心力矩；对角元 $h_{iii}=\frac12\frac{\partial b_{ii}}{\partial q_i}$ 只在 $b_{ii}$ 不依赖 $q_i$ 时才为零 |
| $h_{ijk}\dot q_j\dot q_k\ (j\neq k)$ | 科氏项 | 不同关节同时运动引起的速度乘积耦合效应（来自运动过程中惯量随位形变化的时间导数与能量位置偏导之合） |
| $g_i(\boldsymbol q)$ | 左端重力项 | 静止平衡重力所需给出的广义力；实际重力作用力为 $-g_i(\boldsymbol q)$ |
| $F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})$ | 摩擦损耗项 | 粘滞摩擦与滑动库仑摩擦；阻碍运动故在左端取正号 |
| $-J^{\mathrm T}\boldsymbol h_e$ | 接触外力折算项 | 末端输出到环境的力/力矩 $\boldsymbol h_e$ 在关节侧的反作用需求，即执行器必须额外补偿 $+J^{\mathrm T}\boldsymbol h_e$ |

::: ex 例 6.1.3.A · 同一位形下保持、释放与加速的力矩对比 {#ex-6.1.3.A}
沿用 [例 6.1.2.A](sec6-1.md#ex-6.1.2.A) 中的单自由度摆（$m=2\ \mathrm{kg}$，$l=0.5\ \mathrm m$，忽略杆与转子质量及摩擦）。当摆恰好处于 $q=\pi/6$ 且瞬时速度 $\dot q=0$ 时，分别计算：(a) 静止悬停所需输入力矩 $\tau$；(b) 关闭电机 ($\tau=0$) 瞬间的角加速度 $\ddot q$；(c) 施加主动加速 $\ddot q=2\ \mathrm{rad/s^2}$ 所需力矩 $\tau$。

::: sol 解
此时 $B=ml^2=0.5\ \mathrm{kg\cdot m^2}$ 为常数，$C=0$，重力项 $g(\pi/6)=+4.905\ \mathrm{N\cdot m}$，于是瞬间方程为

$$0.5\,\ddot q + 4.905 = \tau.$$

- (a) 静止保持要求 $\ddot q=0$，故 $\tau = 4.905\ \mathrm{N\cdot m}$。
- (b) 关闭电机即 $\tau=0$，得 $\ddot q = -4.905/0.5 = -9.81\ \mathrm{rad/s^2}$（向下垂方向回摆加速）。
- (c) 主动加速 $\ddot q=2\ \mathrm{rad/s^2}$ 时，$\tau = 0.5\times2 + 4.905 = 5.905\ \mathrm{N\cdot m}$（$4.905$ 平衡重力，$1.0$ 产生角加速度）。

**核心教训**：瞬时速度 $\dot q=0$ 只消去速度耦合项与粘滞摩擦，**不能自动消去惯量加速项 $B\ddot q$**。保持静止与自由释放瞬间处于同一相点 $(q,\dot q)=(\pi/6,0)$，但控制输入不同导致加速度截然不同。
:::
:::

::: think 延伸核对 · 若要求负向加速度 $\ddot q=-2\ \mathrm{rad/s^2}$，电机输出力矩一定是负的吗？
::: sol 答案
代入同一瞬时方程得 $\tau = 0.5\times(-2) + 4.905 = +3.905\ \mathrm{N\cdot m} > 0$。此时电机仍在向 $+q$ 方向托举，只是托举力矩小于平衡重力所需的 $4.905\ \mathrm{N\cdot m}$，净力矩指向下垂方向，从而控制受控减速/可控回摆。
:::
:::

::: note 本节留下的一个悬念：$C(\boldsymbol q,\dot{\boldsymbol q})$ 并不唯一
由分量式进入矩阵形式时，只要求乘积向量 $C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}$ 的结果等于 $\sum_{j,k}h_{ijk}\dot q_k\dot q_j$。当自由度 $n\ge 2$ 时，有无数个矩阵 $C$ 在右乘 $\dot{\boldsymbol q}$ 后给出同一力矩向量。不同选法是否都满足能量守恒与稳定性所需的性质？这正是下一节 [6.2.1](sec6-2.md#part-6.2.1) 的核心问题。
:::

## 本节小结

- **拉格朗日建模三步法**：选取广义坐标 $\boldsymbol q$ $\to$ 计算总动能 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}$ 与势能 $U(\boldsymbol q)$ $\to$ 代入方程得左端惯性/速度耦合/重力项，右端填入非保守虚功广义力。
- **主方程与核心速查**：

| 名称 | 公式 | 注意事项 |
|:--|:--|:--|
| 关节空间主方程 | $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}+\boldsymbol g=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e$ | $\boldsymbol h_e$ 为末端施于环境的力；转动关节 $\tau_i$ 单位 $\mathrm{N\cdot m}$，移动关节为 $\mathrm N$ |
| 惯性矩阵 $B(\boldsymbol q)$ | 对称正定（非退化下）且随位形变化 | 包含连杆平动/转动与转子平动/转动共四块贡献，转动关节 $k_r$ 无量纲，移动关节 $k_r$ 单位 $\mathrm{rad/m}$ |
| 左端重力项 $\boldsymbol g(\boldsymbol q)$ | $\boldsymbol g=(\partial U/\partial\boldsymbol q)^{\mathrm T}=-\boldsymbol\tau_{\mathrm{grav}}$ | 与实际重力广义力差一负号；静止悬停时电机出 $\boldsymbol\tau=\boldsymbol g$ |
| 速度系数 $h_{ijk}$ | $h_{ijk}=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i}$ | 第二项含 $1/2$ 系数；$h_{ijj}$ 为离心系数，$h_{ijk}(j\neq k)$ 为科氏系数 |

**下一节**：[6.2 动力学模型的结构性质](sec6-2.md)揭示控制稳定性依赖的 $\dot B-2C$ 反对称性，以及参数辨识依赖的 $\boldsymbol\tau=Y\boldsymbol\pi$ 线性回归结构。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 25:57 | [inertia-def.jpg](../assets/ch06/inertia-def.jpg) | 惯性张量矩阵与积分定义 | 已整合入 6.1.2 惯性张量定义式 |
| 27:37 | [inertia-tensor.jpg](../assets/ch06/inertia-tensor.jpg) | 坐标变换与平行轴定理 | 已整合入 6.1.2 坐标变换与平行轴注记 |
| 32:33 | [energy-intro.jpg](../assets/ch06/energy-intro.jpg) | 动能与势能引入 | 已按 6.1.2–6.1.3 能量定义展开 |
| 36:20 | [kinetic-link.jpg](../assets/ch06/kinetic-link.jpg) | 连杆动能三块分解 | 完整推导柯尼希分解与交叉项归零证明 |
| 42:11 | [lagrange-eq.jpg](../assets/ch06/lagrange-eq.jpg) | 拉格朗日方程与紧凑形式 | 由定义 6.1.1 完整给出 |
| 42:11 | [example-pendulum.jpg](../assets/ch06/example-pendulum.jpg) | 例 7.1 带齿轮的摆 | 例 6.1.1 完整推导 + 减速比占比检验 |
| 66:20 | [kinetic-rotor.jpg](../assets/ch06/kinetic-rotor.jpg) | 转子动能与减速比 | 整合入 6.1.2 转子建模与 $k_r$ 量纲陷阱 |
| 68:23 | [inertia-matrix.jpg](../assets/ch06/inertia-matrix.jpg) | 总动能与 $B(\boldsymbol q)$ 求和式 | 完整给出四块求和式及对称正定三条性质 |
| 69:13 | [potential.jpg](../assets/ch06/potential.jpg) | 势能梯度与重力项 | 例 6.1.2.A 双路径核对正负号 |
| 75:27 | [eom-forces.jpg](../assets/ch06/eom-forces.jpg) | 非保守广义力进入方式 | 四来源表格完整展开 |
| 76:25 | [eom-compact.jpg](../assets/ch06/eom-compact.jpg) | 紧凑运动方程与物理命名 | 6.1.4 逐项命名 + 例 6.1.3.A 工况对比 |
:::
