# 5.2 驱动

本页子节：
- [5.2.1 电气驱动](#part-5.2.1)
- [5.2.2 液压驱动](#part-5.2.2)
- [5.2.3 传动装置影响](#part-5.2.3)
- [5.2.4 独立关节位置控制](#part-5.2.4)

知道了执行系统的组成，控制律设计还需要一套定量的输入输出微分方程与拉氏域传递函数模型：电源电压或阀杆位移变化时，电机/液压轴转角如何响应？装上减速比 $k_r$ 的齿轮后，负载惯量与重力非线性以什么因子折回电机侧？本节建立电气与液压驱动传递函数模型，推导齿轮折算定理与刚体摆线性化判据，最后给出独立关节 PI 与双环位置伺服结构。

::: note 考纲定位 · 核心必考 / 重点掌握
**5.2.3 传动装置影响**（$1/k_r^2$ 与 $1/k_r$ 折算、惯量匹配最佳速比、刚体摆线性化边界）为核心必考；**5.2.1 电气驱动**（四方程、两种发电机特性推导、框图化简及死区限流）、**5.2.2 液压驱动**（六式与电液本质差异，空化仅作背景了解）、**5.2.4 独立关节位置控制**（PI 稳定条件 $K_p>T_m K_I$ 与测速内环）为重点掌握。
:::

<a id="sec-5.2.a"></a>
<a id="part-5.2.1"></a>
<a id="sec-5.2.1.1"></a>

## 5.2.1 电气驱动

### 四个基本方程与方框图

::: def 定义 5.2.1 · 电气驱动的四个基本方程（原书式 5.1–5.4） {#def-5.2.1}
在零初始条件下，永磁直流电机（及经矢量换相等效后的无刷直流电机）由电枢回路平衡、反电动势关系、转轴力矩平衡与电磁转矩四式在 $s$ 域完整刻画：
$$\begin{aligned}
V_a(s) &= (R_a + sL_a)I_a(s) + V_g(s), \\
V_g(s) &= k_v\,\Omega_m(s), \\
C_m(s) &= (sI_m + F_m)\Omega_m(s) + C_l(s), \\
C_m(s) &= k_t\,I_a(s).
\end{aligned}$$
其中 $V_a(\mathrm V), I_a(\mathrm A), V_g(\mathrm V)$ 为电枢端电压、电流与反电动势；$R_a(\Omega), L_a(\mathrm H)$ 为电枢电阻与电感；$\Omega_m(\mathrm{rad/s})$ 为转子角速度；$I_m(\mathrm{kg\cdot m^2}), F_m(\mathrm{N\cdot m\cdot s/rad})$ 为转子转动惯量与机械黏滞摩擦系数；$C_m, C_l(\mathrm{N\cdot m})$ 为电磁驱动转矩与折算至电机轴的外负载转矩。
:::

**参数口径核对**：常数 $k_v(\mathrm{V\cdot s/rad})$ 与 $k_t(\mathrm{N\cdot m/A})$ 将「电」与「机」耦合。在一致 SI 单位制的理想直流集总模型下，由机电功率相等 $C_m\omega_m = k_t i_a \omega_m = v_g i_a = k_v\omega_m i_a$，二者在数值上严格相等（$k_v=k_t$）；若工程手册采用 rpm 转速、线电压或峰值电流等混合口径，须先统一为 SI 弧度制后再行代算。

消去中间电流与反电动势，得未作频带降阶的完整电—机输入输出关系：
$$\bigl[(sI_m + F_m)(R_a + sL_a) + k_t k_v\bigr]\Omega_m(s) = k_t V_a(s) - (R_a + sL_a)C_l(s).$$

<a id="sec-5.2.1.2"></a>

### 电流反馈回路与框图结构

将功率放大器一阶惯性 $V_a(s)/V_c(s)=G_v/(1+sT_v)$ 接入电枢端，并构建电枢电流反馈传感器 $k_i(\mathrm{V/A})$、电流调节器 $C_i(s)$ 与电压限幅饱和模块：

```
  V'_c ─▶(+)─▶[ C_i(s) ]─▶[ 限幅 ]─▶[ G_v/(1+sT_v) ]─▶(+)─▶[ 1/(R_a+sL_a) ]─▶[ k_t ]─▶(+)─▶[ 1/(sI_m+F_m) ]─▶ Ω_m
          ▲ -                        │                  ▲ -          │                  ▲ - C_l            │
          │                          └────── k_i ◄──────┴───(I_a)────┘                  │                  │
          └──────────────────────────────────────────────────┴──────────────── k_v ◄───────────────────────┘
```

::: def 定义 5.2.2 · 引入电枢电流反馈的双重工程目的 {#def-5.2.2}
1. **指令基准与动态加速**：参考电压 $V'_c$ 充当期望电流基准；调节器 $C_i(s)$ 加速内部电流响应并减小电流相对输入电压的相位滞后；
2. **过流与堵转限流保护**：在放大器前引入饱和限幅元件限制 $V_c$ 幅值，配合电流负反馈限制最大瞬时电流 $I_a$，在堵转或大冲击下保护功率级晶体管。
:::

<a id="sec-5.2.1.3"></a>

### 两种降阶特性与统一传递函数

在机械臂常规控制频带内，开关功放时间常数 $T_v\sim 10^{-5}\text{–}10^{-4}\,\mathrm s$ 及电气时间常数 $L_a/R_a$ 远小于机械时间常数，因此作降阶假设 $L_a\approx 0,\ T_v\approx 0$，电流环工作在线性非饱和区并取 $C_i(0)=1$（合并直流增益 $K=C_i(0)G_v=G_v$）。在此前提下，同一套硬件因是否采用线性电流反馈，分裂出两种工作模式：

::: thm 定理 5.2.A · 速度控制与力矩控制发电机特性（原书式 5.7–5.13） {#thm-5.2.A}
在 $L_a\approx 0,\ T_v\approx 0,\ C_i(0)=1$ 的线性降阶条件下：
1. **速度控制发电机（$k_i=0$，无电流反馈）**：直接输入 $V_a = G_v V'_c$，由完整方程令 $L_a=0$ 得
   $$\Bigl(sI_m + F_m + \frac{k_v k_t}{R_a}\Bigr)\Omega_m = \frac{k_t}{R_a}G_v V'_c - C_l.$$
   当机械黏滞摩擦远小于电枢回路引入的**电摩擦阻尼** $F_m \ll \dfrac{k_v k_t}{R_a}$ 时，略去分母中的 $F_m$ 并两边除以 $k_v k_t/R_a$ 得（原书式 5.9）：
   $$\Omega_m(s)=\frac{\dfrac{1}{k_v}}{1+s\dfrac{R_a I_m}{k_v k_t}}\,G_v V'_c(s) - \frac{\dfrac{R_a}{k_v k_t}}{1+s\dfrac{R_a I_m}{k_v k_t}}\,C_l(s).$$
   空载稳态下 $\omega_m\approx \frac{G_v}{k_v}v'_c$，参考电压直接设定转速，且电枢回路大阻尼使负载扰动敏感度较小。
2. **力矩控制发电机（$k_i\neq 0$，大增益电流反馈）**：由 $K(V'_c - k_i I_a)=R_a I_a + k_v\Omega_m$ 解得电磁驱动转矩：
   $$C_m = k_t I_a = \frac{k_t K}{R_a + Kk_i}\Bigl(V'_c - \frac{k_v}{K}\Omega_m\Bigr).$$
   代入机械平衡并应用高回路增益 $Kk_i \gg R_a$，若残余电摩擦阻尼满足 $\dfrac{k_t k_v}{R_a+Kk_i}\ll F_m$（且 $F_m>0$），稳态近似 $c_m\approx\frac{k_t}{k_i}(v'_c-\frac{k_v}{G_v}\omega_m)$ 几乎只由参考电压决定，动态传递函数退化为（原书式 5.10）：
   $$\Omega_m(s)=\frac{\dfrac{k_t}{k_i F_m}}{1+s\dfrac{I_m}{F_m}}\,V'_c(s) - \frac{\dfrac{1}{F_m}}{1+s\dfrac{I_m}{F_m}}\,C_l(s).$$
3. **统一角位置传递函数（原书式 5.11–5.13）**：由 $\Theta_m(s)=\Omega_m(s)/s$，从驱动参考端口到角位置均写为
   $$M(s)=\frac{k_m}{s(1+sT_m)},$$
   其中速度控制（将 $G_v$ 视为外部增益前乘在输入端）取 $k_m=\dfrac{1}{k_v},\ T_m=\dfrac{R_a I_m}{k_v k_t}$；力矩控制（$G_v$ 已隐入高增益内环消去）取 $k_m=\dfrac{k_t}{k_i F_m},\ T_m=\dfrac{I_m}{F_m}$。
:::

::: thm 定理 5.2.B · 电流反馈取舍与死区非线性限流 {#thm-5.2.B}
在降阶模型满足 $F_m\ll\dfrac{k_v k_t}{R_a}$ 的前提下，比较两种模式的负载扰动通道可见：
$$\frac{R_a}{k_v k_t}\ll \frac{1}{F_m},\qquad \frac{R_a I_m}{k_v k_t}\ll \frac{I_m}{F_m}.$$
因此在该近似模型下：**无电流反馈的速度控制**具有更低的稳态抗扰降速与更快的机械时间常数，天然适用于抗外扰的独立关节位置控制（[5.2.4](#part-5.2.4)）；而需要直接指令输出转矩的**计算力矩/集中控制**（[第 7 章](../ch07/overview.md)）必须引入高增益电流内环作力矩源。

当选用无电流反馈速度模式却需保护功放不致在堵转时烧毁时，单纯把参考信号 $v'_c$ 限幅无效（因堵转反电动势为零，小电压同样能产生大电流）。此时应引入**带死区的非线性电流反馈**：
$$d(i_a)=\begin{cases}0,& |i_a|\le i_{\mathrm{lim}},\\ g_d\bigl(i_a-\operatorname{sgn}(i_a)\,i_{\mathrm{lim}}\bigr),& |i_a|>i_{\mathrm{lim}}.\end{cases}$$
正常运行小电流 $|i_a|\le i_{\mathrm{lim}}$ 时保持纯粹速度源动态；越过阈值后以有限斜率 $g_d$ 迅速产生负反馈压制过流（并非刚性理想钳位，斜率 $g_d$ 越大越接近理想钳位）。
:::

::: ex 例 5.2.6 · 两模式参数计算与抗扰定量比对 {#ex-5.2.A}
某直流电机 $R_a=1.2\,\Omega,\ k_v=0.11\,\mathrm{V\cdot s/rad},\ k_t=0.11\,\mathrm{N\cdot m/A},\ I_m=2.0\times 10^{-5}\,\mathrm{kg\cdot m^2},\ F_m=5.0\times 10^{-6}\,\mathrm{N\cdot m\cdot s/rad},\ k_i=0.80\,\mathrm{V/A}$。校验模型条件并计算两模式下的 $(k_m, T_m)$ 及负载稳态敏感度。

::: sol 解答
耦合电摩擦 $\frac{k_v k_t}{R_a}=\frac{0.0121}{1.2}\approx 1.008\times 10^{-2}\,\mathrm{N\cdot m\cdot s/rad}\gg F_m$，降阶条件严格满足：
- **速度控制（$k_i=0$）**：$k_m=1/0.11\approx 9.09\,\mathrm{rad/(V\cdot s)}$，$T_m=\frac{1.2\times 2\times 10^{-5}}{0.0121}\approx 1.98\times 10^{-3}\,\mathrm s$，负载扰动稳态增益 $\frac{R_a}{k_v k_t}\approx 99.2\,\mathrm{(rad/s)/(N\cdot m)}$；
- **力矩控制（$k_i=0.80$）**：$k_m=\frac{0.11}{0.8\times 5\times 10^{-6}}=2.75\times 10^4\,\mathrm{rad/(V\cdot s)}$，$T_m=I_m/F_m=4.00\,\mathrm s$，负载扰动稳态增益 $1/F_m=2.0\times 10^5\,\mathrm{(rad/s)/(N\cdot m)}$。

可见在该电机参数下速度控制对恒定外负载干扰的敏感度比力矩模式小三个数量级以上。
:::
:::

<a id="sec-5.2.1"></a>
<a id="part-5.2.2"></a>
<a id="sec-5.2.2.1"></a>

## 5.2.2 液压驱动

液压系统工作压力高达百个大气压量级，流体经阀芯间隙的渗漏与高压体积可压缩弹性无法忽略，这是液压建模与电气建模最显著的分水岭。

::: def 定义 5.2.3 · 液压驱动基础方程组（原书式 5.14–5.19） {#def-5.2.3}
设分布器供给体积流量为 $Q(\mathrm{m^3/s})$，作用于液压发动机两侧的压差为 $p(\mathrm{Pa})$，伺服阀阀杆位移为 $x(\mathrm m)$。在选定工作点线性化且零初始条件下，基础方程组为：
$$\begin{aligned}
Q &= Q_m + Q_l + Q_c \quad(\text{流量连续性平衡}), \\
Q_l &= k_l\,p \quad(\text{高压渗漏流量},\ k_l\text{ 为渗漏系数}), \\
Q_c &= \gamma V s p = k_c\,s p \quad(\text{液体可压缩性等效流量},\ \gamma\text{ 为压缩系数},\ V\text{ 为受压腔体积}), \\
Q_m &= k_q\,\Omega_m \quad(\text{机械排量流量},\ k_q\text{ 为单位转角排量}), \\
C_m &= (sI_m + F_m)\Omega_m + C_l,\qquad C_m = k_p\,p \quad(\text{机械平衡与压差输出转矩}), \\
\frac{X(s)}{V_c(s)} &= \frac{G_c}{1+sT_c},\qquad p = k_x x - k_r^{(v)} Q \quad(\text{伺服阀闭环及分布器工作点线性化}).
\end{aligned}$$
（注：记 $k_r^{(v)}$ 为阀口线性化流阻系数，区别于下一节的机械减速比 $k_r$。）
:::

联立流量方程与分布器特性消去总流量 $Q$，直接给出压差动态方程：
$$\bigl[1 + k_r^{(v)}(k_l + k_c s)\bigr]p = k_x x - k_r^{(v)}k_q\Omega_m.$$

::: method 方法 5.2.C · 电气驱动与液压驱动结构对照 {#method-5.2.A}
| 物理作用 | 电气驱动 | 液压驱动（及根本区别） |
|:--|:--|:--|
| 驱动控制量 / 广义力来源 | 电压 $v_a$ / 电流 $i_a$（$C_m=k_t i_a$） | 阀芯位移 $x$ / 压差 $p$（$C_m=k_p p$） |
| 损耗 / 储能动态项 | 电枢电阻 $R_a$ / 电枢电感 $L_a$ | 渗漏 $k_l p$（高压力下不可略）/ 压缩 $k_c sp=\gamma V sp$ |
| 天然速度负反馈 | 反电动势 $V_g=k_v\Omega_m$ | 排量流阻反流 $Q_m=k_q\Omega_m$ |
| 线性工作点稳态特性 | 集总参数常定 | 旋转马达 $k_c$ 为常数；直线液压缸随活塞位置改变腔容 $V$ 而变化 |
| **结构可拆除性** | 电枢电流反馈为**人为加装可选环** | 上式右端压力—流量固有物理耦合**无法从结构上直接拆去** |
:::

*(背景了解，不考：当油液高速节流导致局部静压低于蒸汽压而析出气泡并在高压区溃灭时产生**液压空化（cavitation）**噪声与气蚀损伤。)*

::: intuition 动手实验 · 液压缸与流量的三条去路（3D）
拖动调节阀口开度与载荷压力，观察泵送流量如何分配给有效推动速度流量 $Q_m$、泄漏流量 $Q_l$ 与压缩蓄流 $Q_c$。

<div class="lab" data-lab="hyd3d"></div>
:::

<a id="sec-5.2.2"></a>
<a id="part-5.2.3"></a>
<a id="sec-5.2.3.1"></a>

## 5.2.3 机械传动与传动比折算

第四章规划出关节运动，第五章建立了电机轴动力学；装上减速器后，必须把关节侧的载荷惯量 $I$、载荷阻尼 $F$ 以及非线性的外负载力矩 $C_l$ 统统换算到同一侧方程上才能评估系统动态。

::: def 定义 5.2.4 · 机械减速比与无滑运动学关系 {#def-5.2.4}
考虑理想刚性、无间隙、无打滑的圆柱齿轮副：电机主动齿轮半径 $r_m$，关节从动齿轮半径 $r$。在两轴选取相容的正向旋转方向后，定义**减速比（传动比）**为
$$k_r=\frac{\omega_m}{\omega}=\frac{r}{r_m}>1,\qquad \vartheta_m=k_r\vartheta,\qquad \dot\omega_m=k_r\dot\omega.$$
工业转动关节典型值在 $k_r\in[50,300]$；对于导程为 $h$ 的滚珠丝杠驱动移动关节，$k_r=2\pi/h$ 带有量纲 $\mathrm{rad/m}$。
:::

::: thm 定理 5.2.D · 负载折算至电机侧与两个核心折算因子（$1/k_r^2$ 与 $1/k_r$） {#thm-5.2.C}
设齿轮副自身质量阻尼分别并入电机端 $(I_m,F_m)$ 与负载端 $(I,F)$，齿面接触力为 $f$ 且传递无损。两轴动力学平衡方程为：
$$C_m = I_m\dot\omega_m + F_m\omega_m + f r_m,\qquad f r = I\dot\omega + F\omega + C_l.$$
消去内力 $f$ 并代入 $\omega=\omega_m/k_r,\ \dot\omega=\dot\omega_m/k_r$，得到**折算至电机轴的单自由度等效模型**：
$$C_m = I_{eq}\dot\omega_m + F_{eq}\omega_m + \frac{C_l}{k_r},$$
其中**等效转动惯量**与**等效黏滞摩擦系数**分别为
$$I_{eq}=I_m + \frac{I}{k_r^2},\qquad F_{eq}=F_m + \frac{F}{k_r^2}.$$
:::

::: proof 证明（消元与动能、虚功两路独立验证）
1. **方程消元**：由第二式解出 $f r_m=\frac{r_m}{r}(I\dot\omega+F\omega+C_l)=\frac{1}{k_r}(I\frac{\dot\omega_m}{k_r}+F\frac{\omega_m}{k_r}+C_l)=\frac{I}{k_r^2}\dot\omega_m+\frac{F}{k_r^2}\omega_m+\frac{C_l}{k_r}$，回代第一式合并同类项即得上式。
2. **能量法检验**：总动能 $T=\frac{1}{2}I_m\omega_m^2+\frac{1}{2}I\omega^2=\frac{1}{2}\bigl(I_m+\frac{I}{k_r^2}\bigr)\omega_m^2$，直接揭示惯量（以及同为速度二次齐次项的黏滞损耗）的 $1/k_r^2$ 缩放因子；若反向折算至关节轴侧，则为 $I_{\mathrm{joint}}=I+k_r^2 I_m$（[第 6 章](../ch06/sec6-1.md)拉格朗日动力学中转子惯量矩阵即按此展开）。
3. **虚功检验**：负载力矩在电机轴做的等效虚功 $C_{m,l}\delta\vartheta_m=C_l\delta\vartheta\implies C_{m,l}=C_l/k_r$，仅出现一次 $1/k_r$ 缩放。$\square$
:::

<a id="sec-5.2.3.2"></a>

**最佳惯量匹配传动比**：当要求最大负载角加速度 $\dot\omega$（忽略阻尼和稳态负载，$C_m=(I_m+I/k_r^2)k_r\dot\omega$）时，极小化分母 $g(k_r)=k_r I_m + I/k_r$ 令导数为零得
$$k_{r,\mathrm{opt}}=\sqrt{\frac{I}{I_m}}\quad\Longleftrightarrow\quad \frac{I}{k_{r,\mathrm{opt}}^2}=I_m,$$
即当**折算至电机侧的负载惯量恰好等于电机自身转子惯量**时，加速度传递效率达到理论极值。

::: ex 例 5.1（原书）· 齿轮驱动的刚体摆与线性化条件辨析 {#ex-5.2.D}
质量 $m$、质心距轴 $l$、绕关节轴转动惯量 $I$ 的刚体摆（摆角 $\vartheta$ 从竖直向下稳定平衡点量起）经减速比 $k_r$ 由电机驱动。折算至电机侧的方程为（原书式 5.25）：
$$C_m=I_{eq}\dot\omega_m+F_{eq}\omega_m+\frac{mgl}{k_r}\sin\frac{\vartheta_m}{k_r}.$$
减速比同时从**幅值（$\div k_r$）**与**角尺度压缩（$\vartheta_m/k_r$）**两个途径衰减重力非线性，但应用线性近似前必须区分：
1. **固定电机小行程**：电机从平衡点仅转过 $\Delta\vartheta_m=2\pi$，当 $k_r=100$ 时摆只动 $\Delta\vartheta=0.06283\,\mathrm{rad}$，$\sin\vartheta\approx\vartheta$ 相对误差仅 $0.0658\%$，高度线性；
2. **固定关节大行程**：若任务必须让关节摆至 $\Delta\vartheta=\pi/2$，无论 $k_r$ 多大，电机总须转过 $k_r\pi/2$，$\vartheta_m/k_r$ 仍扫满 $[0,\pi/2]$，小角线性近似终点误差始终达 $57.08\%$——**大减速比不能自动消除大行程下的几何非线性**。

此外，即使 $k_r$ 很大也不能盲目略去负载惯量：例如 $k_r=80,\ I_m=2\times 10^{-4}\,\mathrm{kg\cdot m^2},\ I=6.0\,\mathrm{kg\cdot m^2}$ 时，折算惯量 $I/k_r^2=9.375\times 10^{-4}$ 是电机惯量 $I_m$ 的 $4.69$ 倍（占 $I_{eq}$ 的 $82.4\%$），负载仍占主导。因此多连杆系统中须核算比值 $I/(k_r^2 I_m)$ 与任务工作区范围后，方能合法采用独立关节线性近似。
:::

::: ex 例 5.2.E · 跨量级折算自检 {#ex-5.2.E}
取电机 $I_m=10^{-4}\,\mathrm{kg\cdot m^2},\ F_m=10^{-3}\,\mathrm{N\cdot m\cdot s/rad}$ 与负载 $I=0.05\,\mathrm{kg\cdot m^2},\ F=0.02\,\mathrm{N\cdot m\cdot s/rad},\ C_l=5.0\,\mathrm{N\cdot m}$。在 $k_r=1,50,100,200$ 时比较电机端负担：
- $k_r=1$（直驱）：$I_{eq}=5.01\times 10^{-2},\ C_l/k_r=5.0\,\mathrm{N\cdot m}$；
- $k_r=100$：$I_{eq}=1.05\times 10^{-4}$（负载折算占比降至 $1/21\approx 4.76\%$），$F_{eq}=1.002\times 10^{-3}$，折算力矩降至 $0.05\,\mathrm{N\cdot m}$。
:::

*(学完本节后请完成[两连杆第六关 · 驱动折算](../training/two-link.md#mission-drive)，检验实际速度、加速度下所需电机端力矩与转速边界。)*

<a id="sec-5.2.3"></a>
<a id="part-5.2.4"></a>
<a id="sec-5.2.4.1"></a>
<a id="sec-5.2.4.2"></a>
<a id="sec-5.2.4.3"></a>

## 5.2.4 独立关节位置控制

::: def 定义 5.2.5 · 独立关节近似 {#def-5.2.5}
当大减速比将连杆间动态耦合与负载变惯量按 $1/k_r^2$ 和 $1/k_r$ 充分削弱后，可将各关节近似看成独立的二阶单输入单输出线性定常对象 $M(s)=\dfrac{k_m}{s(1+sT_m)}$（其中 $I_m,F_m$ 替换为 $I_{eq},F_{eq}$），并将剩余未建模耦合及重力残差视作输入端等效负载扰动 $D(s)$，在单关节层面设计闭环位置控制器。
:::

::: thm 定理 5.2.F · 单位置反馈为什么需要 PI 及稳定充要条件 {#thm-5.2.D}
以单位反馈控制对象 $Y(s)=M(s)[U(s)-D(s)],\ M(s)=\dfrac{k_m}{s(1+sT_m)}\ (k_m,T_m>0)$，被控位置对象自身**仅有一个原点极点** $s=0$：
1. **纯比例控制 $C(s)=K_p>0$**：虽闭环恒稳定，但对阶跃恒定扰动 $D(s)=d_0/s$ 由终值定理给出非零稳态误差 $e_{\mathrm{ss}}=d_0/K_p\neq 0$；
2. **比例积分（PI）控制 $C(s)=K_p+\dfrac{K_I}{s}\ (K_p,K_I>0)$**：开环前向传递函数成为 II 型系统：
   $$C(s)M(s)=\frac{k_m(K_p s+K_I)}{s^2(1+sT_m)},$$
   由对象与控制器积分环节**各自贡献一个原点极点**。闭环特征方程为 $T_m s^3+s^2+k_m K_p s+k_m K_I=0$，列 Routh 阵列要求 $s^1$ 行首元严格为正，故闭环稳定充要条件为：
   $$K_p > T_m K_I.$$
   在闭环稳定前提下，积分器可建立抵消恒定负载扰动的稳态控制偏置，使常值位置指令与恒定外扰下的稳态误差严格消除至 $e_{\mathrm{ss}}=0$。
:::

::: method 方法 5.2.G · 位置比例外环 + 速度 PI 内环（测速反馈） {#method-5.2.E}
工程位置伺服广泛采用串级双闭环（详见[5.3 节位置/速度闭环框图](sec5-3.md#part-5.3.1)）：外环位置传感器反馈经比例环节 $K_r$ 给出速度指令；内环转速计反馈组成速度环并以速度 PI 控制器 $C_v(s)=K_{pv}+K_{iv}/s$ 实现调节：
$$\frac{\Theta_m(s)}{R(s)}=\frac{K_r G(s)C_v(s)}{s\bigl[1+G(s)C_v(s)\bigr]+K_r G(s)C_v(s)},\qquad G(s)=\frac{k_m}{1+sT_m}.$$
在扰动注入点内侧闭合高速测速环，提供了额外的闭环阻尼和极点配置自由度，可加快扰动抑制与展宽带宽；改善程度受测速器件噪声和传动谐振频率制约。
:::

::: note 两条工程推论与等效扰动口径 {#note-5.2.1}
1. 把关节端物理载荷力矩 $C_l/k_r$ 折算到控制器参考电压入口作为输入端等效扰动 $d$ 时：速度控制模式（输入 $G_v V'_c$）对应 $d=\dfrac{R_a}{k_t}\dfrac{C_l}{k_r}$；力矩控制模式（输入 $V'_c$）对应 $d=\dfrac{k_i}{k_t}\dfrac{C_l}{k_r}$。
2. 串联位置控制器中的积分环节不可任意放大 $K_I$，必须留足 $K_p > T_m K_I$ 的相位裕度以防系统发散或大幅超调。
:::

<a id="sec-5.2.4"></a>

::: think 默写点 · 合上书复推本节四项主干
1. 默写直流电机四基本方程，说明为何速度控制抗恒定负载扰动常优于力矩控制，并用式子写出死区限流机制。
2. 说明液压驱动与电气驱动相比不可忽略且无法拆除的两项结构特征。
3. 默写折算到电机轴的 $I_{eq},F_{eq}$ 及刚体摆动力学式，写出单位置 PI 闭环稳定判据。

::: sol 核对
1. $V_a=(R_a+sL_a)I_a+k_v\Omega_m,\ C_m=(sI_m+F_m)\Omega_m+C_l=k_t I_a$；在 $F_m\ll k_v k_t/R_a$ 时速度模式扰动增益 $R_a/(k_v k_t)\ll 1/F_m$ 且时间常数更小；死区反馈在 $|i_a|>i_{\mathrm{lim}}$ 时启动斜率 $g_d$ 强负反馈抑流。
2. 高压渗漏 $k_l p$、可压缩容积项 $k_c sp=\gamma V sp$，以及阀腔固有的压力—流量耦合不可像电路电流反馈一样由外部布线直接拆除。
3. $I_{eq}=I_m+I/k_r^2,\ F_{eq}=F_m+F/k_r^2,\ C_m=I_{eq}\dot\omega_m+F_{eq}\omega_m+\frac{mgl}{k_r}\sin\frac{\vartheta_m}{k_r}$；PI 稳定充要条件为 $K_p > T_m K_I$。
:::
:::

## 5.2 小结与常见错误

| 公式 / 结论 | 条件与假设 | 易错点 |
|:--|:--|:--|
| 电气驱动 $M(s)=\dfrac{k_m}{s(1+sT_m)}$ | 忽略电枢电感 $L_a$ 与功放滞后 $T_v$ | 混用速度模式与力矩模式下的 $k_m, T_m$ 与 $G_v$ 位置 |
| 液压流阻压力方程 | 工作点增量线性化 | 漏算 $Q_l,Q_c$；误把直线缸 $k_c$ 当成不随活塞行程变的常数 |
| 折算定理：$I/k_r^2,\ F/k_r^2,\ C_l/k_r$ | 刚性无隙传动，正向一致约定 | $\sin(\vartheta_m/k_r)$ 内外忘写各自 $k_r$；以为大减速比在全行程都能线性化 |
| 单位置 PI 稳定条件 $K_p>T_m K_I$ | 被控对象 $M(s)$ 有一原点极点 | 误认为积分控制自动保证稳态消除误差而不核对三阶 Routh 条件 |

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 01:03:28 | [drives-intro.jpg](../assets/ch05/drives-intro.jpg) | 驱动建模方法论 | 5.2 节引言体系重写 |
| 01:05:27 | [electric-drive-block.jpg](../assets/ch05/electric-drive-block.jpg) | 电气驱动四个基本方程 | 5.2.1 节完整公式与推导 |
| 01:05:27 | [vel-controlled.jpg](../assets/ch05/vel-controlled.jpg) | 教材图 5.2 含电流反馈完整框图 | 5.2.1 节框图与目的归纳 |
| 01:16:55 | [unified-transfer.jpg](../assets/ch05/unified-transfer.jpg) | 两种驱动动态特征框图 | 5.2.1 节定理 5.2.A 完整推演 |
| 01:19:45 | [current-limit.jpg](../assets/ch05/current-limit.jpg) | 统一传函与死区限流（教材图 5.5） | 5.2.1 节定理 5.2.B 分段数学描述 |
| 01:22:09 | [hydraulic-block.jpg](../assets/ch05/hydraulic-block.jpg) | 液压流量平衡与基础方程组 | 5.2.2 节六式与对照表 |
| 01:24:51 | [gear-schematic.jpg](../assets/ch05/gear-schematic.jpg) | 机械齿轮耦合示意（教材图 5.7） | 5.2.3 节定义与双路线证明 |
| 01:29:52 | [pendulum-gear.jpg](../assets/ch05/pendulum-gear.jpg) | 例 5.1 刚体摆与折算非线性式 | 5.2.3 节例题与行程定量核验 |
| 01:35:22 | [pos-feedback.jpg](../assets/ch05/pos-feedback.jpg) | 单位置反馈框图（教材图 5.10） | 5.2.4 节 Routh 稳定推演 |
| 01:38:49 | [pos-vel-feedback.jpg](../assets/ch05/pos-vel-feedback.jpg) | 位置 + 测速双环框图（教材图 5.11） | 5.2.4 节串级模型及 5.3.1 简化重绘 |
:::
