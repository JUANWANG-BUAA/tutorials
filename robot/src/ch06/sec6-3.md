# 6.3 两连杆动力学算例

前两节已经建立动力学一般理论与结构性质，但只有落在具体机构上才能直观看见惯性矩阵 $B(\boldsymbol q)$ 何时随位形改变、离心与科氏项如何产生、转动关节与移动关节的耦合究竟差在哪里。

本节构造两个两自由度对照组：先看双移动关节正交**笛卡儿臂**的彻底解耦特性，再完整手算**平面 2R 转动臂**的 $B(\boldsymbol q)$、Christoffel 矩阵 $C$、重力项 $\boldsymbol g$ 以及 8 参数线性化表达式（对应原书 §7.3）。

本节导航：[两连杆笛卡儿臂](#part-6.3.1) · [两连杆平面臂](#part-6.3.2)。

<a id="part-6.3.1"></a>

## 6.3.1 两连杆笛卡儿臂

### 构型描述与雅可比

考察原书图 7.3 的正交 PR/PP 结构（双移动关节）：关节 1 沿竖直基座 $+z$ 轴平移 $d_1$，关节 2 沿水平正交 $+x$ 轴平移 $d_2$，故广义坐标 $\boldsymbol q=[d_1,\,d_2]^{\mathrm T}$。两连杆质量为 $m_1,m_2$；转子质量为 $m_{m_1},m_{m_2}$，转子轴沿对应运动轴、质心在轴上，转动惯量为 $I_{m_1},I_{m_2}$；若采用丝杠或齿条等旋转–直线传动且 $\dot\vartheta_{m_i}=k_{r_i}\dot d_i$，传动比 $k_{r_i}$ 的单位为 $\mathrm{rad/m}$。

计算各刚体的几何雅可比：
- **连杆平动与转动**：两根杆仅做平动，无转动，故 $J_O^{(1)}=J_O^{(2)}=0$，质心平动雅可比为

$$J_P^{(1)}=\begin{bmatrix}0&0\\0&0\\1&0\end{bmatrix},\qquad J_P^{(2)}=\begin{bmatrix}0&1\\0&0\\1&0\end{bmatrix}.$$

- **电机转子**：转子 1 安装于固定基座（$J_P^{(m_1)}=0$），仅绕 $z$ 轴自转；转子 2 安装于连杆 1 上，随关节 1 竖直平动并绕 $x$ 轴自转：

$$J_P^{(m_2)}=\begin{bmatrix}0&0\\0&0\\1&0\end{bmatrix},\qquad J_O^{(m_1)}=\begin{bmatrix}0&0\\0&0\\k_{r_1}&0\end{bmatrix},\qquad J_O^{(m_2)}=\begin{bmatrix}0&k_{r_2}\\0&0\\0&0\end{bmatrix}.$$

### 惯性矩阵、重力项与完全解耦方程

因为两移动轴正交，连杆 2 质心速度平方满足 $\|\dot{\boldsymbol p}_2\|^2=\dot d_1^2+\dot d_2^2$，交叉项为零。汇总所有动能：

$$T = \frac12\bigl(m_1+m_{m_2}+m_2+k_{r_1}^2I_{m_1}\bigr)\dot d_1^2 + \frac12\bigl(m_2+k_{r_2}^2I_{m_2}\bigr)\dot d_2^2 = \frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q},$$

得到常数对角惯性矩阵：

$$B = \begin{bmatrix}m_1+m_{m_2}+k_{r_1}^2I_{m_1}+m_2&0\\0&m_2+k_{r_2}^2I_{m_2}\end{bmatrix}.$$

因为 $B$ 与 $\boldsymbol q$ 无关，所有位置偏导数为零，故 $\dot B=0$ 且按 Christoffel 选法取 $C=O$（无离心力和科氏力）。再取 $\boldsymbol g_0=[0,0,-g]^{\mathrm T}$，计算势能 $U=(m_1+m_{m_2}+m_2)gd_1$（外加常数），求偏导得

$$g_1 = (m_1+m_{m_2}+m_2)g,\qquad g_2 = 0.$$

无摩擦、无末端接触时的运动方程为两道彼此独立的一维牛顿方程：

$$\bigl(m_1+m_{m_2}+k_{r_1}^2I_{m_1}+m_2\bigr)\ddot d_1 + (m_1+m_{m_2}+m_2)g = \tau_1,$$

$$\bigl(m_2+k_{r_2}^2I_{m_2}\bigr)\ddot d_2 = \tau_2.$$

::: note 为什么正交笛卡儿臂能解耦？——两条条件缺一不可
1. **构型决定常数性（无转动关节）**：只有平动使得惯性矩阵不依赖位形，从而消去 $C\dot{\boldsymbol q}$；
2. **几何决定对角性（关节轴互相正交）**：若两移动轴夹角 $\alpha\neq\pi/2$（如原书习题 7.1 取 $\alpha=\pi/4$），即使全是移动关节仍使 $b_{12}=m_2\cos\alpha\neq 0$，两轴在加速度项上仍存在耦合。
:::

::: intuition 动手实验 · 拖动 $d_1,d_2$，观察常数惯性矩阵（3D）
拖动两移动关节位置 $d_1,d_2$，可观测到 $b_{11},b_{22}$ 始终保持常数且交叉项 $b_{12}\equiv 0$；与下一节平面 2R 臂对比，即可直观看出转动关节如何引入位形耦合。

<div class="lab" data-lab="cart3d"></div>
:::

<a id="part-6.3.2"></a>

## 6.3.2 两连杆平面臂

### 先用均匀细杆数值热身：保持与加速两张力矩账单

取竖直平面内的两连杆 2R 机械臂（$+x$ 向右、$+y$ 向上、重力加速度 $g_0=9.81\ \mathrm{m/s^2}$ 向下），关节角记作 $q_1$（从 $+x$ 逆时针）与 $q_2$（相对第一杆逆时针）。先采用[两连杆训练第七关](../training/two-link.md#mission-load)的简化均匀细杆参数：杆长各 $1\,\mathrm m$、质量各 $1\,\mathrm{kg}$、质心距各自关节 $0.5\,\mathrm m$、绕各自质心转动惯量 $I_1=I_2=\frac{1}{12}mL^2=\frac{1}{12}\ \mathrm{kg\cdot m^2}$，暂忽略摩擦、转子质量与惯量。考察位形 $\boldsymbol q_A=(0,\pi/2)$：

1. **静态重力补偿**：两质心高度为 $y_{c1}=\frac12\sin q_1$ 与 $y_{c2}=\sin q_1+\frac12\sin(q_1+q_2)$，总势能 $U=(1\,\mathrm{kg})g_0\bigl[\frac32\sin q_1+\frac12\sin(q_1+q_2)\bigr]\mathrm m$，求梯度得左端重力项

$$\boldsymbol g(\boldsymbol q) = \frac{\partial U}{\partial\boldsymbol q} = 9.81\begin{bmatrix}\frac32\cos q_1+\frac12\cos(q_1+q_2)\\\frac12\cos(q_1+q_2)\end{bmatrix}\ \mathrm{N\cdot m} \implies \boldsymbol g(\boldsymbol q_A) = \begin{bmatrix}14.715\\0\end{bmatrix}\ \mathrm{N\cdot m}.$$

第 1 关节水平托起两个质心（力臂 $0.5\,\mathrm m$ 与 $1\,\mathrm m$），保持需 $14.715\,\mathrm{N\cdot m}$；第 2 杆质心恰好在关节 2 正上方，力臂为零。若第 1 关节电机上限仅 $12\,\mathrm{N\cdot m}$，则**即使将速度降到零，也无法静止悬停在 $\boldsymbol q_A$**。

2. **从静止起步加速 $\ddot{\boldsymbol q}=(1,0)^{\mathrm T}\ \mathrm{rad/s^2}$**：利用平动与转动动能写出总动能 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}$，整理系数得

$$B(\boldsymbol q) = \begin{bmatrix}\frac53+\cos q_2 & \frac13+\frac12\cos q_2\\ \frac13+\frac12\cos q_2 & \frac13\end{bmatrix}\ \mathrm{kg\cdot m^2} \implies B(\boldsymbol q_A)=\begin{bmatrix}5/3&1/3\\1/3&1/3\end{bmatrix}\ \mathrm{kg\cdot m^2}.$$

此时初速度 $\dot{\boldsymbol q}=\boldsymbol 0$ 使 $C\dot{\boldsymbol q}=\boldsymbol 0$，代入方程得所需关节侧力矩：

$$\boldsymbol\tau = B(\boldsymbol q_A)\begin{bmatrix}1\\0\end{bmatrix} + \boldsymbol g(\boldsymbol q_A) = \begin{bmatrix}5/3+14.715\\1/3\end{bmatrix}\approx\begin{bmatrix}16.382\\0.333\end{bmatrix}\ \mathrm{N\cdot m}.$$

尽管第 2 关节被要求 $\ddot q_2=0$，仍必须主动输出 $b_{21}\ddot q_1 = \frac13\ \mathrm{N\cdot m}$ 来平衡第一杆加速度引发的惯性耦合。

下面保留完整连杆与电机转子（教材 §7.3.2 记号 $\vartheta_i=q_i$），系统推导一般两连杆平面臂动力学（将下文参数令 $a_i=1,\,\ell_i=0.5,\,m_i=1,\,I_i=1/12$ 及 $m_{m_i}=I_{m_i}=0$ 即可完全还原上述算例）。

### 完整结构参数与雅可比矩阵

考察在垂直平面内运动的两转动关节臂（原书图 7.4）：广义坐标 $\boldsymbol q=[\vartheta_1,\vartheta_2]^{\mathrm T}$，采用简写 $s_1=\sin\vartheta_1,\,c_1=\cos\vartheta_1,\,s_{12}=\sin(\vartheta_1+\vartheta_2),\,c_{12}=\cos(\vartheta_1+\vartheta_2)$。两杆长度 $a_1,a_2$，质心距各自轴 $\ell_1,\ell_2$，质量 $m_1,m_2$，绕各自质心轴转动惯量 $I_1,I_2$；两电机转子质心分别位于轴 1、轴 2 上（$\boldsymbol p_{m_i}=\boldsymbol p_{i-1}$），质量 $m_{m_1},m_{m_2}$，轴向惯量 $I_{m_1},I_{m_2}$，减速比 $k_{r_1},k_{r_2}$。

两连杆及两转子的几何雅可比依次为：

$$J_P^{(1)}=\begin{bmatrix}-\ell_1s_1&0\\ \ell_1c_1&0\\0&0\end{bmatrix},\qquad J_P^{(2)}=\begin{bmatrix}-a_1s_1-\ell_2s_{12}&-\ell_2s_{12}\\ a_1c_1+\ell_2c_{12}&\ell_2c_{12}\\0&0\end{bmatrix},$$

$$J_O^{(1)}=\begin{bmatrix}0&0\\0&0\\1&0\end{bmatrix},\qquad J_O^{(2)}=\begin{bmatrix}0&0\\0&0\\1&1\end{bmatrix},$$

$$J_P^{(m_1)}=0,\qquad J_P^{(m_2)}=\begin{bmatrix}-a_1s_1&0\\ a_1c_1&0\\0&0\end{bmatrix},\qquad J_O^{(m_1)}=\begin{bmatrix}0&0\\0&0\\k_{r_1}&0\end{bmatrix},\qquad J_O^{(m_2)}=\begin{bmatrix}0&0\\0&0\\1&k_{r_2}\end{bmatrix}.$$

**关键细节**：转子 2 装在连杆 1 上，其绝对角速度等于连杆 1 角速度叠加相对转子自转，即 $\omega_{m_2}=\dot\vartheta_1+k_{r_2}\dot\vartheta_2$，所以 $J_O^{(m_2)}$ 的 $(3,1)$ 分量为 $1$ 而非 $0$。

### 惯性矩阵 $B(\boldsymbol q)$ 逐项推导

代入 6.1.2 节 $B(\boldsymbol q)$ 求和公式得对称正定阵 $B(\boldsymbol q)=\begin{bmatrix}b_{11}(\vartheta_2)&b_{12}(\vartheta_2)\\b_{12}(\vartheta_2)&b_{22}\end{bmatrix}$：

$$\begin{aligned}
b_{11}(\vartheta_2) &= I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1} + I_2+m_2(a_1^2+\ell_2^2+2a_1\ell_2c_2) + I_{m_2}+m_{m_2}a_1^2, \\
b_{12}(\vartheta_2) &= I_2+m_2(\ell_2^2+a_1\ell_2c_2)+k_{r_2}I_{m_2}, \\
b_{22} &= I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}.
\end{aligned}$$

::: note $b_{11}$ 的七项来源与 $b_{22}$ 常数的物理含义 {#note-6.3.2.3.b11}
- **$b_{11}$ 锁住 $\vartheta_2$ 时关节 1 的等效惯量**：
  1. $I_1+m_1\ell_1^2$：连杆 1 绕关节 1 的转动惯量（平行轴定理）；
  2. $k_{r_1}^2I_{m_1}$：转子 1 经减速比平方折算后的惯量；
  3. $m_{m_2}a_1^2$：转子 2 随杆 1 末端圆周平动的贡献；
  4. $I_{m_2}$：转子 2 因 $\vartheta_2$ 锁死被迫以 $\dot\vartheta_1$ 同步转动的自转惯量；
  5. $I_2+m_2(a_1^2+\ell_2^2+2a_1\ell_2c_2)$：连杆 2 绕质心转动加其质心绕关节 1 转动（余弦定理 $\|\boldsymbol p_{\ell_2}\|^2=a_1^2+\ell_2^2+2a_1\ell_2c_2$）的总惯量。
- **$b_{12}$ 中的 $k_{r_2}I_{m_2}$**：来自转子 2 角速度平方 $(\dot\vartheta_1+k_{r_2}\dot\vartheta_2)^2$ 的交叉项，绝非笔误。
- **$b_{22}$ 为何是常数**：锁住 $\vartheta_1$ 时，只有连杆 2 和转子 2 绕关节 2 旋转，两者到关节 2 的几何分布恒定，故 $b_{22}$ 不随位形变。
:::

### Christoffel 符号与速度耦合矩阵 $C$

观察 $B$ 仅依赖 $\vartheta_2$（全部对 $\vartheta_1$ 偏导均为零）：

$$\frac{\partial b_{11}}{\partial\vartheta_2} = -2m_2a_1\ell_2s_2 = 2h,\qquad \frac{\partial b_{12}}{\partial\vartheta_2} = -m_2a_1\ell_2s_2 = h,\qquad \text{其中 } h \triangleq -m_2a_1\ell_2s_2.$$

利用 $c_{ijk}=\frac12(\partial_k b_{ij}+\partial_j b_{ik}-\partial_i b_{jk})$ 逐个计算 8 个三指标系数，非零项仅剩三组（包含一对对称指标）：

$$c_{112} = c_{121} = \frac12\frac{\partial b_{11}}{\partial\vartheta_2} = h,\qquad c_{122} = \frac{\partial b_{12}}{\partial\vartheta_2}-\frac12\frac{\partial b_{22}}{\partial\vartheta_1} = h,\qquad c_{211} = -\frac12\frac{\partial b_{11}}{\partial\vartheta_2} = -h.$$

将 $c_{ij}=\sum_{k=1}^2 c_{ijk}\dot\vartheta_k$ 写成矩阵，并左乘 $\dot{\boldsymbol q}$ 验证各项含义：

$$C(\boldsymbol q,\dot{\boldsymbol q}) = \begin{bmatrix}h\dot\vartheta_2 & h(\dot\vartheta_1+\dot\vartheta_2)\\ -h\dot\vartheta_1 & 0\end{bmatrix} \implies C\dot{\boldsymbol q} = \begin{bmatrix}2h\dot\vartheta_1\dot\vartheta_2 + h\dot\vartheta_2^2\\ -h\dot\vartheta_1^2\end{bmatrix}.$$

::: note 离心项与科氏项辨认 {#note-6.3.2.4.C}
- **关节 1 方程中的 $h\dot\vartheta_2^2$** 与 **关节 2 方程中的 $-h\dot\vartheta_1^2$**：均为单关节速度平方引起的**离心项**（注意第 1 关节存在对 $\vartheta_2$ 的离心耦合，而 $\dot\vartheta_1^2$ 在关节 1 上系数为零）；
- **关节 1 方程中的 $2h\dot\vartheta_1\dot\vartheta_2$**：两关节同时转动时产生的交叉**科氏项**（直接用反对称阵验证：$\dot B-2C=\begin{bmatrix}0&-2h\dot\vartheta_1-h\dot\vartheta_2\\2h\dot\vartheta_1+h\dot\vartheta_2&0\end{bmatrix}$ 严格反对称）。
:::

### 重力项与完整运动方程

取重力 $\boldsymbol g_0=[0,-g,0]^{\mathrm T}$，对高度求导得左端重力项：

$$g_1(\boldsymbol q) = (m_1\ell_1+m_{m_2}a_1+m_2a_1)gc_1 + m_2\ell_2gc_{12},\qquad g_2(\boldsymbol q) = m_2\ell_2gc_{12}.$$

略去摩擦与末端接触力时，平面 2R 机械臂的封闭运动方程（原书式 (7.82)）为：

$$\begin{aligned}
\bigl(I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1}+I_2+m_2(a_1^2+\ell_2^2+2a_1\ell_2c_2)+I_{m_2}+m_{m_2}a_1^2\bigr)\ddot\vartheta_1 & \\
+\bigl(I_2+m_2(\ell_2^2+a_1\ell_2c_2)+k_{r_2}I_{m_2}\bigr)\ddot\vartheta_2 - 2m_2a_1\ell_2s_2\dot\vartheta_1\dot\vartheta_2 - m_2a_1\ell_2s_2\dot\vartheta_2^2 & \\
+(m_1\ell_1+m_{m_2}a_1+m_2a_1)gc_1 + m_2\ell_2gc_{12} &= \tau_1, \\[4pt]
\bigl(I_2+m_2(\ell_2^2+a_1\ell_2c_2)+k_{r_2}I_{m_2}\bigr)\ddot\vartheta_1 + \bigl(I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}\bigr)\ddot\vartheta_2 & \\
+m_2a_1\ell_2s_2\dot\vartheta_1^2 + m_2\ell_2gc_{12} &= \tau_2.
\end{aligned}$$

::: think 原书例 7.2 仿真要点 · 各分量如何消长
在教材例 7.2 参数（$a_1=a_2=1\ \mathrm m$，$\ell_1=\ell_2=0.5\ \mathrm m$，$m_1=m_2=50\ \mathrm{kg}$，$I_1=I_2=10\ \mathrm{kg\cdot m^2}$，$k_{r_1}=k_{r_2}=100$，$m_{m_1}=m_{m_2}=5\ \mathrm{kg}$，$I_{m_1}=I_{m_2}=0.01\ \mathrm{kg\cdot m^2}$）下，沿梯形速度曲线由肘下垂 $(0.2,0)\ \mathrm m$ 位形令两轴同转 $\pi/2$（耗时 $0.5\ \mathrm s$）：
1. **高减速比下转子主惯量凸显**：$k_{r_1}^2I_{m_1}=100\ \mathrm{kg\cdot m^2}$，远大于连杆 1 自身惯量，且由于 $b_{11}$ 随 $\vartheta_2$ 变，关节 1 自惯性力矩在匀加减速段仍连续波动；
2. **关节 2 自惯性分段常值**：$b_{22}$ 为常数使得 $b_{22}\ddot\vartheta_2$ 在三段梯形加速度上分段恒定（但完整的 $(B\ddot q)_2$ 还需叠加上非常数的 $b_{21}(\vartheta_2)\ddot\vartheta_1$）；
3. **高速段速度耦合显著，低速段重力托底**：高速中段离心/科氏项明显，低速起止端由重力矩决定保持下限。
:::

### 8 参数线性回归形式

依据 [6.2.2](sec6-2.md#part-6.2.2) 扩展连杆与原点锁转惯量规则，将平面臂每杆系原点取在各杆远端（则扩展连杆 1 质心距末端 $O_1$ 为 $\ell_{C_1}=m_1(\ell_1-a_1)/(m_1+m_{m_2})$，扩展连杆 2 质心距末端 $O_2$ 为 $\ell_{C_2}=\ell_2-a_2$），可将平面运动方程压缩为 $\boldsymbol\tau=Y\boldsymbol\pi$（共 8 个结构参数，较 22 个名义参数大幅缩减；进一步合并线性相关列后最小独立惯性组合仅 5 个）：

$$\boldsymbol\pi = \begin{bmatrix}m_1+m_{m_2} & m_1(\ell_1-a_1) & \widehat I_{1,zz} & I_{m_1} & m_2 & m_2(\ell_2-a_2) & \widehat I_{2,zz} & I_{m_2}\end{bmatrix}^{\mathrm T},$$

其中 $\widehat I_{i,zz}=\bar I_i+m_i^{\mathrm{aug}}\ell_{C_i}^2$。注意线性化要求用一阶矩和原点锁转惯量，不能把质心坐标、未知质量、质心惯量拆成独立未知参数去套线性回归。

::: intuition 动手实验 · 观测平面臂 $B,C,\boldsymbol g$ 的动态变化（3D）
拖动关节角与速度观察惯性矩阵各元、速度耦合项和重力项的实时曲线；点击「自由摆动」以零输入对 $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g=\boldsymbol 0$ 做四阶 Runge–Kutta 积分，观察两杆之间的能量交换与重力摆动。

<div class="lab" data-lab="dyn3d"></div>
:::

## 本节小结

- **两算例对照本质**：笛卡儿正交臂给出常数对角 $B$ 与 $C=0$（完全解耦）；平面 2R 臂则全面展示位形相关的 $B(\vartheta_2)$、交叉自转项 $k_{r_2}I_{m_2}$、对称平分 Christoffel 矩阵 $C$ 以及双角关联重力矩 $\boldsymbol g$。
- **主线任务**：完成[两连杆训练第七关](../training/two-link.md#mission-load)静止与加速账单后，即可带入模型不确定性问题，进入[第七章 7.3 节](../ch07/sec7-3.md)设计集中式补偿与反馈控制。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 123:20 | [cartesian.jpg](../assets/ch06/cartesian.jpg) | 笛卡儿臂惯性矩阵与解耦方程 | 6.3.1 完整推导 + 解耦两条件说明 |
| 123:41 | [planar.jpg](../assets/ch06/planar.jpg) | 两连杆平面臂（图 7.4） | 6.3.2 几何与转子雅可比完整列出 |
| 132:24 | [planar-B.jpg](../assets/ch06/planar-B.jpg) | 平面臂 $B(\boldsymbol q)$ 与 Christoffel 符号 | 逐项来源注记 + 离心/科氏辨认 |
| 136:55 | [planar-torque.jpg](../assets/ch06/planar-torque.jpg) | 例 7.2 仿真分量时程 | 总结四段力学规律并区分自惯性/耦合惯性 |
:::
