# 6.1 拉格朗日公式

本页导航：[拉格朗日公式](#part-6.1) · [动能计算](#part-6.1.1) · [势能计算](#part-6.1.2) · [运动方程](#part-6.1.3)。

<a id="part-6.1"></a>

## 6.1.0 引入：从力到能量的推导路线

本节回答两个问题：**为什么用能量列方程**，以及
**广义力到底包含哪些东西**。前者决定方法的适用面，后者决定方程右端写不写得对。

<a id="611-从力换到能量"></a>

### 6.1.0.1 从「力」换到「能量」

牛顿–欧拉路线要逐杆画受力图、消内部约束力；拉格朗日路线只做两件事：**写动能 $T$、写势能 $U$**，
然后代一个固定的微分公式。对 $n$ 自由度开链机械手，取关节变量

$$\boldsymbol q=[q_1,\ q_2,\ \dots,\ q_n]^{\mathrm T}$$

为**广义坐标**（generalized coordinates）。它们能完全确定各连杆的位置，因而也确定整个系统的能量。

先用一个质点看公式从哪里来。质点质量为 $m$，受约束沿固定的光滑曲线运动，位置写为 $\boldsymbol r(q)$，$q$ 是独立坐标。假设势能只依赖位置，除保守力外还受力 $\boldsymbol F$；理想约束力 $\boldsymbol N$ 与允许的虚位移垂直。牛顿方程沿曲线切向 $\boldsymbol r_q=\partial\boldsymbol r/\partial q$ 投影：

$$m\ddot{\boldsymbol r}\cdot\boldsymbol r_q=\boldsymbol F\cdot\boldsymbol r_q-\frac{\partial U}{\partial q},\qquad \boldsymbol N\cdot\boldsymbol r_q=0.$$

右端第一项是与 $q$ 对应的广义力 $\xi$：位移 $\delta\boldsymbol r=\boldsymbol r_q\delta q$ 时，$\boldsymbol F\cdot\delta\boldsymbol r=\xi\,\delta q$。现在把左端改写成动能的导数。由 $\dot{\boldsymbol r}=\boldsymbol r_q\dot q$ 和 $T=\tfrac12m\dot{\boldsymbol r}\cdot\dot{\boldsymbol r}$，记 $\boldsymbol r_{qq}=\partial^2\boldsymbol r/\partial q^2$，则

$$\frac{\partial T}{\partial\dot q}=m\dot{\boldsymbol r}\cdot\boldsymbol r_q,\qquad
\frac{\mathrm d}{\mathrm dt}\frac{\partial T}{\partial\dot q}
=m\ddot{\boldsymbol r}\cdot\boldsymbol r_q+m\dot{\boldsymbol r}\cdot\boldsymbol r_{qq}\dot q,\qquad
\frac{\partial T}{\partial q}=m\dot{\boldsymbol r}\cdot\boldsymbol r_{qq}\dot q.$$

后两项相减，正好留下牛顿方程中的切向惯性项 $m\ddot{\boldsymbol r}\cdot\boldsymbol r_q$。把 $\partial U/\partial q$ 移到左端，令 $L=T-U$，就得到下面的方程。对多个质点分别投影并求和，可以推广到多个独立广义坐标；这里使用了理想约束及 $U$ 不依赖速度的假设。关节摩擦等不满足理想约束的力仍须记入广义力。

::: def 定义 6.1.1 · 拉格朗日函数与拉格朗日方程 {#def-6.1.1}
机械系统的**拉格朗日函数**定义为动能与势能之差

$$L(\boldsymbol q,\dot{\boldsymbol q})=T(\boldsymbol q,\dot{\boldsymbol q})-U(\boldsymbol q).$$

**拉格朗日方程**为

$$\frac{\mathrm d}{\mathrm dt}\left(\frac{\partial L}{\partial \dot q_i}\right)-\frac{\partial L}{\partial q_i}=\xi_i,
\qquad i=1,\dots,n,$$

其中 $\xi_i$ 是与广义坐标 $q_i$ 对应的**广义力**。写成向量形式：

$$\frac{\mathrm d}{\mathrm dt}\left(\frac{\partial L}{\partial \dot{\boldsymbol q}}\right)^{\mathrm T}
-\left(\frac{\partial L}{\partial \boldsymbol q}\right)^{\mathrm T}=\boldsymbol\xi.$$
:::

::: intuition 为什么可以「不画受力图」
拉格朗日方程里的 $\dfrac{\mathrm d}{\mathrm dt}\dfrac{\partial L}{\partial \dot q_i}-\dfrac{\partial L}{\partial q_i}$
已经把**所有保守力**（重力、弹簧力）自动装进去了——它们藏在 $U$ 里。理想约束力（关节反力、连杆内力）
不做虚功，因此**根本不需要出现在方程里**。这就是能量法最省事的地方：**约束越复杂，越划算**。
代价是：非保守力（执行器力矩、摩擦、末端接触力）必须自己作为 $\xi_i$ 补到右端。
:::

<a id="612-广义力-ξiξi-的四个来源"></a>
<a id="part-6.1.generalized-force"></a>

### 6.1.0.2 广义力 $\xi_i$ 的四个来源

对开链机械手，右端通常由四部分组成：

$$\xi_i=\tau_i-\bigl(F_{\mathrm v}\dot{\boldsymbol q}\bigr)_i-\bigl(F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}\bigr)_i
-\bigl(J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e\bigr)_i.$$

| 来源 | 符号 | 说明 |
|:--|:--|:--|
| 关节执行器力矩 | $\boldsymbol\tau$ | 电机经减速器作用在关节上的驱动力矩（移动关节则为力） |
| 粘滞摩擦 | $F_{\mathrm v}\dot{\boldsymbol q}$ | $F_{\mathrm v}$ 为 $n\times n$ 对角矩阵，与速度成正比 |
| 库仑摩擦 | $F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}$ | $F_{\mathrm s}$ 为对角矩阵；此项描述滑动时与速度方向相反的摩擦，零速度下的静摩擦需另行建模 |
| 末端接触力 | $J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e$ | $\boldsymbol h_e$ 为末端执行器施加在环境上的力/力矩，经雅可比转置折回关节 |

::: note 符号约定（后面各节统一）
- $\boldsymbol h_e$ 的方向：**末端执行器作用在环境上的力**。环境反作用于末端的力记为 $\boldsymbol f_{\mathrm{env}}=-\boldsymbol h_e$，它贡献 $+J^{\mathrm T}\boldsymbol f_{\mathrm{env}}$；本教程沿用教材约定，右端写成 $\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e$（执行器力矩的一部分用来平衡接触力）。
- 移动关节的 $\tau_i$ 是力不是力矩，$q_i$ 是位移不是角度；公式形式不变。
- 摩擦项在建模阶段常先省略（难以精确建模），但在控制实验里必须补，否则低速爬行与稳态误差会很明显。
:::

<a id="613-例-71带齿轮的摆老师逐行推的第一道题"></a>
<a id="part-6.1.pendulum"></a>

### 6.1.0.3 例 7.1：带齿轮的摆

> 教材例 7.1（对应图 5.8 的摆）。这是老师在课上逐行推的第一道题：单连杆的「动能 + 势能 + 广义力」
> 流程在这里走通，后面所有多连杆推导都是同一流程的重复使用——所以值得把它当作模板学会，
> 再往下看 6.2 的多连杆版本。

**系统**：摆杆质量为 $m$，质心到铰点 $O$ 的距离为 $l$，绕 $O$ 转动，转角 $\vartheta$（下垂位置为 $\vartheta=0$），杆相对 $O$ 的转动惯量为 $I$；
电机转子经减速比 $k_r$ 驱动，转子惯量 $I_m$，转子粘滞摩擦系数 $F_m$，关节粘滞摩擦系数 $F$。假设传动刚性、理想无损，$\tau=k_r\tau_m$ 为关节侧驱动力矩。

**动能**：摆杆与转子都随关节转动。转子的角速度是 $k_r\dot\vartheta$（刚性传动，无打滑），故

$$T=\frac12 I\dot\vartheta^2+\frac12 I_m k_r^2\dot\vartheta^2
=\frac12\bigl(I+I_m k_r^2\bigr)\dot\vartheta^2.$$

**势能**：以垂下位置为零势能点，质心升高 $l(1-\cos\vartheta)$：

$$U=mgl\,(1-\cos\vartheta).$$

**拉格朗日函数**：

$$L=T-U=\frac12\bigl(I+I_m k_r^2\bigr)\dot\vartheta^2-mgl\,(1-\cos\vartheta).$$

**代方程**：

$$\frac{\partial L}{\partial\dot\vartheta}=\bigl(I+I_m k_r^2\bigr)\dot\vartheta,\qquad
\frac{\mathrm d}{\mathrm dt}\frac{\partial L}{\partial\dot\vartheta}=\bigl(I+I_m k_r^2\bigr)\ddot\vartheta,$$

$$\frac{\partial L}{\partial\vartheta}=-mgl\sin\vartheta.$$

因此

$$\bigl(I+I_m k_r^2\bigr)\ddot\vartheta+mgl\sin\vartheta=\xi.$$

**广义力**：执行器力矩 $\tau$，减去关节粘滞摩擦 $F\dot\vartheta$，再减去折算到关节侧的转子摩擦
$F_m k_r^2\dot\vartheta$：

$$\xi=\tau-F\dot\vartheta-F_m k_r^2\dot\vartheta.$$

**完整方程**：

$$\boxed{\ \bigl(I+I_m k_r^2\bigr)\ddot\vartheta+\bigl(F+F_m k_r^2\bigr)\dot\vartheta+mgl\sin\vartheta=\tau\ }$$

这与第 5 章把转子量折算到关节侧得到的方程一致（原书式 (5.29)）——**拉格朗日法自动给出「折算」**，
不需要再单独推一遍减速器的惯量/摩擦折算。

::: think 老师在这道题上强调的三件事
1. **转子的动能也要算**：$T$ 里两项，第二项 $I_m k_r^2\dot\vartheta^2$ 不是可选项。忽略转子惯量，
   高速启停时力矩会明显偏小。
2. **广义力要「折算到关节侧」**：$F_m k_r^2\dot\vartheta$ 的 $k_r^2$ 来自 $\omega_m=k_r\dot\vartheta$，
   与动能里转子项的系数同源；不要漏平方。
3. **非线性只来自重力**：$\sin\vartheta$ 是唯一的非线性项；惯量与摩擦都是线性的。
   多连杆时非线性会多得多（$B(q)$、离心/科氏项），但「先写能量、再代公式」的流程不变。
:::

::: think 试一试 · 减速比翻倍，力矩也翻四倍吗？
忽略摩擦，取摆杆惯量 $I=0.4\ \mathrm{kg\,m^2}$、转子惯量 $I_m=0.002\ \mathrm{kg\,m^2}$。在 $\vartheta=0$、$\dot\vartheta=0$ 时，要产生 $\ddot\vartheta=1\ \mathrm{rad/s^2}$。分别计算 $k_r=10$ 和 $k_r=20$ 时关节侧所需力矩。

::: sol 核对
此时重力矩和摩擦为零，$\tau=(I+I_mk_r^2)\ddot\vartheta$。两种减速比下折算惯量依次为 $0.4+0.002\times100=0.6$ 和 $0.4+0.002\times400=1.2\ \mathrm{kg\,m^2}$，所需力矩分别为 $0.6$ 和 $1.2\ \mathrm{N\,m}$。转子惯量项翻四倍，连同不变的摆杆惯量计算后，总力矩只翻两倍。
:::
:::

<a id="614-拉格朗日法与牛顿欧拉法的分工"></a>

### 6.1.0.4 拉格朗日法与牛顿–欧拉法的分工

| 维度 | 拉格朗日法 | 牛顿–欧拉法 |
|:--|:--|:--|
| 出发点 | 标量能量 $T,U$ | 逐杆受力图 + 牛顿/欧拉方程 |
| 参考系 | 能量是标量；计算质心速度和惯性张量时仍须统一坐标系 | 须选定坐标系，并在各杆坐标系间变换 |
| 中间量 | 只有 $T,U$ | 关节反力、连杆内力（要消去） |
| 适合 | 手工推导、少自由度、教学 | 递推计算、多自由度、实时 $O(n)$ |
| 复杂度 | 展开后项数多，易漏项 | 递推结构清晰，程序化容易 |

> 本章用拉格朗日法推公式（**为了看懂结构**），实际软件多用牛顿–欧拉递推（**为了算得快**）。
> 两者给出同一个 $B,C,g$；原书第 8 章的控制律只关心最终形式，不关心用哪种方法推出来。

<a id="615-小结与常见错误"></a>
<a id="part-6.1.intro-summary"></a>

### 6.1.0.5 小结与常见错误

- **一句话**：拉格朗日法 = 「写两个标量（$T,U$） + 代一个公式」，约束力自动消失，非保守力补右端。
- **三步流程**：选广义坐标 $\to$ 写 $T,U$ $\to$ 代 $\dfrac{\mathrm d}{\mathrm dt}\dfrac{\partial L}{\partial\dot q}-\dfrac{\partial L}{\partial q}=\xi$。
- **右端四件套**：$\tau$、粘滞摩擦、库仑摩擦、$J^{\mathrm T}h_e$。

::: think 常见错误清单
1. **漏掉转子动能**：尤其是大减速比时 $I_m k_r^2$ 可能比连杆惯量还大。
2. **势能零点选错导致符号反**：$U=mgl(1-\cos\vartheta)$ 的零点在垂下位置；若选水平位置为零，
   表达式会多一个常数，但**不影响运动方程**（常数求导为零）——符号错在 $\partial U/\partial q$ 上才致命。
3. **把 $\xi$ 写成 $\tau$**：摩擦与末端力都算广义力，不能只写电机力矩。
4. **对 $\dot q$ 与 $q$ 的偏导混淆**：$\partial L/\partial\dot q$ 是先对速度求偏导、再对时间求全导；
   $\partial L/\partial q$ 只对位置求偏导。
:::

::: think 默写点 · 合上书再写
1. 写出拉格朗日函数与拉格朗日方程（标量形式与向量形式）。
2. 写出带齿轮的摆的 $T,U,L$ 与最终运动方程。
3. 广义力的四个来源各是什么？末端力为什么要乘 $J^{\mathrm T}$？
4. 拉格朗日法与牛顿–欧拉法各适合什么场合？
:::

<a id="part-6.1.1"></a>

## 6.1.1 动能计算

本节的任务只有一个：把 $n$ 连杆 + $n$ 个转子的总动能，写成
关节速度的二次型 $\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}$，
并认出 $B$ 就是**惯性矩阵**。所有结构性质（对称、正定、随位形变）都从这一步来。

### 6.1.1.1 总动能 = 连杆 + 转子

对 $n$ 个刚性连杆的机械手，总动能是各连杆动能与各关节电机转子动能之和：

$$T=\sum_{i=1}^{n}\bigl(T_i+T_{m_i}\bigr),$$

其中 $T_i$ 是连杆 $i$ 的动能，$T_{m_i}$ 是驱动关节 $i$ 的转子动能（连杆 0 固定，不贡献）。

### 6.1.1.2 连杆动能：平动 + 转动

连杆 $i$ 上体积微元 $\mathrm dV$ 的质量为 $\rho\,\mathrm dV$（$\rho$ 为密度），其位置记为 $\boldsymbol p_i^*$。
连杆动能是

$$T_i=\frac12\int_{V_i}\dot{\boldsymbol p}_i^{*\mathrm T}\dot{\boldsymbol p}_i^*\,\rho\,\mathrm dV.$$

把微元位置写成「质心位置 + 相对质心的矢径」：

$$\boldsymbol r_i=[r_{ix},r_{iy},r_{iz}]^{\mathrm T}=\boldsymbol p_i^*-\boldsymbol p_i,\qquad
\boldsymbol p_i=\frac{1}{m_i}\int_{V_i}\boldsymbol p_i^*\rho\,\mathrm dV,$$

其中 $m_i$ 是连杆质量，$\boldsymbol p_i$ 是质心位置。对时间求导，并用角速度 $\boldsymbol\omega_i$ 表示
刚体上一点的线速度：

$$\dot{\boldsymbol p}_i^*=\dot{\boldsymbol p}_i+\boldsymbol\omega_i\times\boldsymbol r_i
=\dot{\boldsymbol p}_i+S(\boldsymbol\omega_i)\boldsymbol r_i,$$

这里 $S(\cdot)$ 是**叉乘的反对称矩阵**：

$$S(\boldsymbol a)=\begin{bmatrix}0&-a_z&a_y\\ a_z&0&-a_x\\ -a_y&a_x&0\end{bmatrix},
\qquad S(\boldsymbol a)\boldsymbol b=\boldsymbol a\times\boldsymbol b.$$

把速度代回积分，动能自然分成三块：

**① 平动项**

$$\frac12\int_{V_i}\dot{\boldsymbol p}_i^{\mathrm T}\dot{\boldsymbol p}_i\,\rho\,\mathrm dV
=\frac12 m_i\dot{\boldsymbol p}_i^{\mathrm T}\dot{\boldsymbol p}_i.$$

**② 交叉项（平动 × 转动）**

$$\int_{V_i}\dot{\boldsymbol p}_i^{\mathrm T}S(\boldsymbol\omega_i)\boldsymbol r_i\,\rho\,\mathrm dV
=\dot{\boldsymbol p}_i^{\mathrm T}S(\boldsymbol\omega_i)\int_{V_i}(\boldsymbol p_i^*-\boldsymbol p_i)\rho\,\mathrm dV=0,$$

因为按质心定义 $\int\boldsymbol p_i^*\rho\,\mathrm dV=\boldsymbol p_i\int\rho\,\mathrm dV$，括号里的积分为零。
**质心系的最大好处就是这一项自动消失。**

**③ 转动项**

$$\frac12\int_{V_i}\boldsymbol r_i^{\mathrm T}S^{\mathrm T}(\boldsymbol\omega_i)S(\boldsymbol\omega_i)\boldsymbol r_i\,\rho\,\mathrm dV
=\frac12\boldsymbol\omega_i^{\mathrm T}\boldsymbol I_i\boldsymbol\omega_i,$$

其中用到 $S(\boldsymbol\omega)\boldsymbol r=-S(\boldsymbol r)\boldsymbol\omega$（叉乘反交换），以及**惯性张量**

$$\boldsymbol I_i=\int_{V_i}S^{\mathrm T}(\boldsymbol r_i)S(\boldsymbol r_i)\rho\,\mathrm dV
=\begin{bmatrix}
\displaystyle\int(r_{iy}^2+r_{iz}^2)\rho\,\mathrm dV&-\displaystyle\int r_{ix}r_{iy}\rho\,\mathrm dV&-\displaystyle\int r_{ix}r_{iz}\rho\,\mathrm dV\\[2mm]
*&\displaystyle\int(r_{ix}^2+r_{iz}^2)\rho\,\mathrm dV&-\displaystyle\int r_{iy}r_{iz}\rho\,\mathrm dV\\[2mm]
*&*&\displaystyle\int(r_{ix}^2+r_{iy}^2)\rho\,\mathrm dV
\end{bmatrix}.$$

它是一个**对称矩阵**，对角元是绕三个坐标轴的转动惯量，非对角元是惯性积的负值。
因此

$$T_i=\frac12 m_i\dot{\boldsymbol p}_i^{\mathrm T}\dot{\boldsymbol p}_i
+\frac12\boldsymbol\omega_i^{\mathrm T}\boldsymbol I_i\boldsymbol\omega_i.$$

::: note 惯性张量的两件事（老师专门停在这里讲）
1. **参考系**：$\boldsymbol I_i$ 是相对**质心**、在**基坐标系**中表达的惯性张量，随机械手位形变化；
   若改到固连在连杆 $i$ 的坐标系（DH 系）中表达，它是**常数矩阵** $\boldsymbol I_i^i$，两者关系为
   $$\boldsymbol I_i=\boldsymbol R_i\,\boldsymbol I_i^i\,\boldsymbol R_i^{\mathrm T}.$$
   这就是为什么建模时总把惯性张量写在连杆系里——**常数**，不用每步重算。
2. **平行轴定理**：若参考点从质心 $C$ 平移到 $O$，则
   $$\boldsymbol I_O=\boldsymbol I_C+m\,S^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C).$$
   板书的写法是 $\boldsymbol I_O=\boldsymbol I_C+mS^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C)$，
   其中 $\boldsymbol p_C$ 是质心相对新原点的位置。
:::

### 6.1.1.3 用雅可比把质心速度写成 $\dot{\boldsymbol q}$

质心线速度与连杆角速度都是关节速度的线性组合：

$$\dot{\boldsymbol p}_i=J_P^{(i)}(\boldsymbol q)\dot{\boldsymbol q},\qquad
\boldsymbol\omega_i=J_O^{(i)}(\boldsymbol q)\dot{\boldsymbol q}.$$

其中 $J_P^{(i)}$、$J_O^{(i)}$ 是**只取到连杆 $i$** 的雅可比矩阵（第 $i$ 列之后全为零）：

$$J_P^{(i)}=\bigl[j_{P1}^{(i)}\ \cdots\ j_{Pi}^{(i)}\ 0\ \cdots\ 0\bigr],\qquad
J_O^{(i)}=\bigl[j_{O1}^{(i)}\ \cdots\ j_{Oi}^{(i)}\ 0\ \cdots\ 0\bigr],$$

其列按第 3 章的几何法给出：

$$j_{Pj}^{(i)}=\begin{cases}
\boldsymbol z_{j-1},&\text{移动关节}\\[1mm]
\boldsymbol z_{j-1}\times(\boldsymbol p_i-\boldsymbol p_{j-1}),&\text{转动关节}
\end{cases}
\qquad
j_{Oj}^{(i)}=\begin{cases}
\boldsymbol 0,&\text{移动关节}\\[1mm]
\boldsymbol z_{j-1},&\text{转动关节}
\end{cases}$$

（$\boldsymbol p_{j-1}$ 是坐标系 $j-1$ 原点的位置，$\boldsymbol z_{j-1}$ 是 $z_{j-1}$ 轴单位向量。）

代入 $T_i$ 得

$$T_i=\frac12 m_i\dot{\boldsymbol q}^{\mathrm T}J_P^{(i)\mathrm T}J_P^{(i)}\dot{\boldsymbol q}
+\frac12\dot{\boldsymbol q}^{\mathrm T}J_O^{(i)\mathrm T}\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}J_O^{(i)}\dot{\boldsymbol q}.$$

### 6.1.1.4 转子动能与减速比

转子 $i$ 的动能与连杆同构：

$$T_{m_i}=\frac12 m_{m_i}\dot{\boldsymbol p}_{m_i}^{\mathrm T}\dot{\boldsymbol p}_{m_i}
+\frac12\boldsymbol\omega_{m_i}^{\mathrm T}\boldsymbol I_{m_i}\boldsymbol\omega_{m_i}.$$

先看**转动关节**：刚性传动下，转子相对其安装座的转角 $\vartheta_{m_i}$ 与关节角 $q_i$ 满足

$$k_{r_i}\dot q_i=\dot\vartheta_{m_i}\qquad\Longrightarrow\qquad
\boldsymbol\omega_{m_i}=\boldsymbol\omega_{i-1}+k_{r_i}\dot q_i\,\boldsymbol z_{m_i},$$

其中 $k_{r_i}$ 是有符号的电机转角与关节转角之比，$\boldsymbol z_{m_i}$ 是转子轴单位向量。前一项是安装座随上游连杆一起转动的角速度，后一项是转子相对安装座的转动，两项都在同一坐标系中表达。对于丝杠驱动的移动关节，$q_i$ 是长度，转角与位移的比例系数具有 $\mathrm{rad/m}$ 的量纲，不能直接把它当作无量纲齿轮减速比。
转子的线速度同样写成雅可比形式
$\dot{\boldsymbol p}_{m_i}=J_P^{(m_i)}\dot{\boldsymbol q}$，角速度写成
$\boldsymbol\omega_{m_i}=J_O^{(m_i)}\dot{\boldsymbol q}$，其列在 $j=i$ 处多出 $k_{r_i}\boldsymbol z_{m_i}$。

于是

$$T_{m_i}=\frac12 m_{m_i}\dot{\boldsymbol q}^{\mathrm T}J_P^{(m_i)\mathrm T}J_P^{(m_i)}\dot{\boldsymbol q}
+\frac12\dot{\boldsymbol q}^{\mathrm T}J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\dot{\boldsymbol q}.$$

### 6.1.1.5 总动能与惯性矩阵

把连杆与转子的贡献相加，利用 $T=\frac12\sum_i\sum_j b_{ij}(\boldsymbol q)\dot q_i\dot q_j$：

$$\boxed{\ T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}\ }$$

$$B(\boldsymbol q)=\sum_{i=1}^{n}\Bigl[
m_iJ_P^{(i)\mathrm T}J_P^{(i)}+J_O^{(i)\mathrm T}\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}J_O^{(i)}
+m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)}+J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}
\Bigr].$$

**$B(\boldsymbol q)$ 的三条性质**（板书在公式下方逐条标注）：

1. **对称**：$B=B^{\mathrm T}$；
2. **正定**：通常假设各独立关节速度非零时总动能严格为正，即 $\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}=2T>0$（$\dot{\boldsymbol q}\neq0$）；若理想化模型存在无质量、无转动惯量的运动方向，则只能保证半正定；
3. **一般随位形变化**：$B=B(\boldsymbol q)$，某些特殊结构中可以是常数。

::: think 老师强调的三个「技巧点」
1. **叉乘写成矩阵**：$\boldsymbol\omega\times\boldsymbol r=S(\boldsymbol\omega)\boldsymbol r=-S(\boldsymbol r)\boldsymbol\omega$。
   后者把 $\boldsymbol\omega$ 提到积分外，是得到 $\boldsymbol I_i$ 的关键一步——**没有这个反交换，
   转动项就积不出惯性张量**。
2. **质心系消交叉项**：交叉项为零不是「忽略」，而是质心定义直接给出来的恒等式。
3. **惯性张量写在连杆系里是常数**：$\boldsymbol I_i=\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}$，
   建模时只需存 6 个独立分量（对称矩阵），运行时用 $R$ 变换。
:::

### 6.1.1.6 小结与常见错误

- **一句话**：连杆动能 = 平动 $\frac12m\dot p^{\mathrm T}\dot p$ + 转动 $\frac12\omega^{\mathrm T}I\omega$；
  用雅可比把 $\dot p,\omega$ 换成 $\dot q$，再对 $i$ 求和，就得到 $T=\frac12\dot q^{\mathrm T}B\dot q$。
- **$B$ 的组成**：四块——连杆平动、连杆转动、转子平动、转子转动；每块都是 $J^{\mathrm T}MJ$ 型，其中 $M$ 为质量或惯性张量。
- **$B$ 的三性质**：对称、正定、随位形变。

::: think 常见错误清单
1. **把 $J_P^{(i)}$ 写成整机雅可比**：只能取到连杆 $i$，第 $i$ 列之后必须为零，否则会把后面关节的速度算进来。
2. **忘记 $\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}$ 的变换**：直接把连杆系的惯量当基座系用。
3. **转子项漏掉 $k_r^2$**：$\omega_m=k_r\dot q$，平方后进动能，系数是 $k_r^2$。
4. **把 $B$ 当常数**：除笛卡儿结构等特例外，$B$ 随 $q$ 变；后面 $\dot B$ 项就是由此而来。
:::

::: think 默写点 · 合上书再写
1. 写出 $T_i$ 的平动项、交叉项、转动项，并说明交叉项为什么为零。
2. 写出惯性张量 $\boldsymbol I_i$ 的定义与平行轴定理。
3. 写出 $B(\boldsymbol q)$ 的四块贡献与三条性质。
4. 转子的角速度如何用关节速度表示？减速比出现在哪几处？
:::

<a id="part-6.1.2"></a>

## 6.1.2 势能计算

这一节很短，但有一个关键结论：**势能只依赖位形 $\boldsymbol q$，不依赖速度 $\dot{\boldsymbol q}$**。
后面拉格朗日方程里「$\partial U/\partial\dot q=0$」、重力项只出现在 $\partial U/\partial q$ 中，都靠这一条。

### 6.1.2.1 只算重力

对刚性连杆，势能来自重力（弹性、磁力等暂不考虑）：

$$U=\sum_{i=1}^{n}\bigl(U_i+U_{m_i}\bigr),$$

$$U_i=-\int_{V_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_i^*\,\rho\,\mathrm dV
=-m_i\boldsymbol g_0^{\mathrm T}\boldsymbol p_i,\qquad
U_{m_i}=-m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i},$$

其中 $\boldsymbol g_0$ 是基坐标系中的重力加速度向量。若 $z$ 轴竖直向上，则

$$\boldsymbol g_0=[0,\ 0,\ -g]^{\mathrm T},\qquad g=9.81\ \mathrm{m/s^2}.$$

于是

$$\boxed{\ U(\boldsymbol q)=-\sum_{i=1}^{n}\bigl(m_i\boldsymbol g_0^{\mathrm T}\boldsymbol p_i(\boldsymbol q)
+m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i}(\boldsymbol q)\bigr)\ }$$

### 6.1.2.2 为什么只依赖 $\boldsymbol q$

质心位置 $\boldsymbol p_i$ 与转子质心位置 $\boldsymbol p_{m_i}$ 都是**位形**的函数（由正运动学给出），
与速度无关。因此

$$U=U(\boldsymbol q),\qquad \frac{\partial U}{\partial\dot{\boldsymbol q}}=\boldsymbol 0.$$

这一条会直接简化拉格朗日方程：$\dfrac{\partial L}{\partial\dot q_i}=\dfrac{\partial T}{\partial\dot q_i}$；
对位置求偏导时仍要保留动能的位形依赖：

$$\frac{\partial L}{\partial q_i}=\frac{\partial T}{\partial q_i}-\frac{\partial U}{\partial q_i}.$$

因此势能从第二项进入方程；一般机械手的 $T$ 也随位形变化，不能把第一项省掉。

### 6.1.2.3 势能的梯度就是重力矩

把 $U$ 对 $q_i$ 求偏导，用链式法则：

$$\frac{\partial U}{\partial q_i}
=-\sum_{j=1}^{n}\Bigl(m_j\boldsymbol g_0^{\mathrm T}\frac{\partial\boldsymbol p_j}{\partial q_i}
+m_{m_j}\boldsymbol g_0^{\mathrm T}\frac{\partial\boldsymbol p_{m_j}}{\partial q_i}\Bigr).$$

而 $\dfrac{\partial\boldsymbol p_j}{\partial q_i}=j_{Pi}^{(j)}$（质心位置雅可比第 $i$ 列），所以

$$\frac{\partial U}{\partial q_i}
=-\sum_{j=1}^{n}\Bigl(m_j\boldsymbol g_0^{\mathrm T}j_{Pi}^{(j)}
+m_{m_j}\boldsymbol g_0^{\mathrm T}j_{Pi}^{(m_j)}\Bigr)
\triangleq g_i(\boldsymbol q).$$

写成列向量：

$$\boxed{\ \boldsymbol g(\boldsymbol q)=\frac{\partial U}{\partial\boldsymbol q}
=-\sum_{j=1}^{n}\Bigl(m_jJ_P^{(j)\mathrm T}\boldsymbol g_0
+m_{m_j}J_P^{(m_j)\mathrm T}\boldsymbol g_0\Bigr)\ }$$

::: intuition 先说清「谁在施力」，再判断正负号
重力实际施加的广义力为
$\boldsymbol\tau_{\mathrm{grav}}=\sum_j(m_jJ_P^{(j)\mathrm T}\boldsymbol g_0+m_{m_j}J_P^{(m_j)\mathrm T}\boldsymbol g_0)$。
它与势能梯度方向相反：$\boldsymbol\tau_{\mathrm{grav}}=-\partial U/\partial\boldsymbol q$。
本教程动力学方程把重力移到左端，故采用
$B\ddot q+C\dot q+\boldsymbol g=\tau$、$\boldsymbol g=-\boldsymbol\tau_{\mathrm{grav}}$。

因此，本节所谓「重力矩」$\boldsymbol g$ 是方程左端的**重力项**；静止、无其他外力时，电机必须施加
$\tau=\boldsymbol g$ 才能平衡实际重力。不要把两个方向相反的量都不加区分地叫作「重力产生的力矩」。
:::

::: ex 例 6.1.2.A · 一个单摆，两条路径核对符号 {#ex-6.1.2.A}
质点质量 $m=2\ \mathrm{kg}$，到铰点距离 $l=0.5\ \mathrm m$，忽略杆与转子质量。
取 $z$ 向上、摆角 $q$ 从竖直垂下方向向 $+x$ 增大，则
$\boldsymbol p=(l\sin q,0,-l\cos q)^{\mathrm T}$。求 $q=\pi/6$ 时的重力项和保持力矩。

::: sol 解
**势能路径**：以垂下位置为零点，$U=mgl(1-\cos q)$，
故 $g(q)=mgl\sin q=4.905\ \mathrm{N\cdot m}$。

**力与雅可比路径**：$J_P=(l\cos q,0,l\sin q)^{\mathrm T}$，
重力 $m\boldsymbol g_0=(0,0,-mg)^{\mathrm T}$，故
$\tau_{\mathrm{grav}}=J_P^{\mathrm T}m\boldsymbol g_0=-mgl\sin q=-4.905\ \mathrm{N\cdot m}$。
电机保持力矩为 $\tau=+4.905\ \mathrm{N\cdot m}$，与实际重力相抵。

两条路径必须满足 $g+\tau_{\mathrm{grav}}=0$。若不相抵，先查重力向量和角度正向；
势能加减常数不影响梯度，不能靠改势能零点修复符号。
:::
:::

::: think 迁移练习 · 换一个角度定义
若改用 $\alpha=q-\pi/2$（从水平向右方向向上量角），同一质心写成
$\boldsymbol p=(l\cos\alpha,0,l\sin\alpha)^{\mathrm T}$。
求左端重力项 $g_\alpha$，并在 $\alpha=-\pi/3$ 核对上例。

::: sol 核对与回读
$U=mgl\sin\alpha+\text{常数}$，所以 $g_\alpha=mgl\cos\alpha$。
$\alpha=-\pi/3$ 时仍得 $4.905\ \mathrm{N\cdot m}$，实际重力广义力仍为其相反数。
若写成正弦，回到质心高度表达式再求导；若两路径同号，回读上面的「谁在施力」。
能独立完成两种角度定义后，再到 [运动方程](sec6-1.md#part-6.1.3) 把重力项放回完整模型。
:::
:::

### 6.1.2.4 小结与常见错误

- **一句话**：$U=-\sum(m_i\boldsymbol g_0^{\mathrm T}\boldsymbol p_i+m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i})$，
  只依赖 $\boldsymbol q$；它的梯度就是重力矩。
- **两条推论**：$\partial U/\partial\dot q=0$；运动方程中的重力项 $\boldsymbol g(\boldsymbol q)=\partial U/\partial q$。

::: think 常见错误清单
1. **把势能写成速度的函数**：$U$ 与 $\dot q$ 无关；若写了，说明把动能项混进来了。
2. **重力方向与坐标轴不一致**：$\boldsymbol g_0$ 的符号取决于 $z$ 轴朝向；平面臂若取 $y$ 竖直，
   $\boldsymbol g_0=[0,-g,0]^{\mathrm T}$，不是 $[0,0,-g]^{\mathrm T}$。
3. **重力矩符号反**：先用手算单摆检验——摆角增大时左端重力项应为正还是负，
   取决于角度定义；符号错了，后面的控制前馈会整体反向。
:::

<a id="part-6.1.3"></a>

## 6.1.3 运动方程

把 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}$ 与 $U=U(\boldsymbol q)$
代进拉格朗日方程，就得到**关节空间动力学模型**。这一节要把方程的每一项「叫出名字」，
因为原书第 8 章的控制律就是逐项补偿这些名字。

### 6.1.3.1 代入拉格朗日方程

$$L(\boldsymbol q,\dot{\boldsymbol q})=T(\boldsymbol q,\dot{\boldsymbol q})-U(\boldsymbol q)
=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}-U(\boldsymbol q).$$

先算速度项：

$$\frac{\partial L}{\partial\dot q_i}=\frac{\partial T}{\partial\dot q_i}
=\sum_{j=1}^{n}b_{ij}(\boldsymbol q)\dot q_j
\qquad\Longrightarrow\qquad
\frac{\mathrm d}{\mathrm dt}\frac{\partial L}{\partial\dot q_i}
=\sum_{j=1}^{n}b_{ij}\ddot q_j+\sum_{j=1}^{n}\sum_{k=1}^{n}\frac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j.$$

再算位置项（$U$ 不含 $\dot q$）：

$$\frac{\partial L}{\partial q_i}=\frac{\partial T}{\partial q_i}-\frac{\partial U}{\partial q_i}
=\frac12\sum_{j=1}^{n}\sum_{k=1}^{n}\frac{\partial b_{jk}}{\partial q_i}\dot q_k\dot q_j
-\frac{\partial U}{\partial q_i}.$$

两式相减：

$$\sum_{j=1}^{n}b_{ij}\ddot q_j
+\sum_{j=1}^{n}\sum_{k=1}^{n}\Bigl(\frac{\partial b_{ij}}{\partial q_k}
-\frac12\frac{\partial b_{jk}}{\partial q_i}\Bigr)\dot q_k\dot q_j
+\frac{\partial U}{\partial q_i}=\xi_i.$$

### 6.1.3.2 分量形式与 $h_{ijk}$

定义

$$h_{ijk}(\boldsymbol q)=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i},$$

则

$$\boxed{\ \sum_{j=1}^{n}b_{ij}(\boldsymbol q)\ddot q_j
+\sum_{j=1}^{n}\sum_{k=1}^{n}h_{ijk}(\boldsymbol q)\dot q_k\dot q_j
+g_i(\boldsymbol q)=\xi_i,\qquad i=1,\dots,n\ }$$

其中 $g_i=\partial U/\partial q_i$ 是方程左端的重力项，其相反数才是重力实际施加的广义力（见 [6.1.2](sec6-1.md#part-6.1.2)）。

### 6.1.3.3 矩阵形式

把速度二次项收进矩阵 $C(\boldsymbol q,\dot{\boldsymbol q})$，要求其元素满足

$$\sum_{j=1}^{n}c_{ij}(\boldsymbol q,\dot{\boldsymbol q})\dot q_j
=\sum_{j=1}^{n}\sum_{k=1}^{n}h_{ijk}(\boldsymbol q)\dot q_k\dot q_j.$$

于是

$$\boxed{\ B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+\boldsymbol g(\boldsymbol q)=\boldsymbol\xi\ }$$

再把驱动、摩擦与末端接触对应的广义力写出来。令 $\boldsymbol\tau\in\mathbb R^n$ 为驱动广义力，$F_{\mathrm v}$、$F_{\mathrm s}$ 为各关节的粘滞与库仑摩擦系数矩阵；$J$ 为末端几何雅可比，$\boldsymbol h_e$ 为末端施加给环境的力与力矩。环境对机器人的作用方向相反，因此其关节广义力为 $-J^{\mathrm T}\boldsymbol h_e$。将摩擦阻力移到左侧，得到

$$\boxed{\ B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})
+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau-J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e\ }$$

对于转动关节，广义力的单位是 $\mathrm{N\cdot m}$；对于移动关节，单位是 $\mathrm N$。式中的 $F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})$ 是滑动时的简化库仑摩擦模型，零速度下的静摩擦需要另行建模，不能只靠取 $\operatorname{sgn}(0)=0$ 描述。

这就是全章要推的「那一行公式」。后面 6.2 的两条性质、6.3 的两个算例，都是在补全或检验它。

### 6.1.3.4 每一项的物理意义

| 项 | 名称 | 物理意义 |
|:--|:--|:--|
| $b_{ii}\ddot q_i$ | 自惯量项 | 其他关节加速度为零时，关节 $i$ 的加速度产生的惯性广义力；锁住其他关节时 $b_{ii}$ 为该自由度的等效惯量 |
| $b_{ij}\ddot q_j\ (i\neq j)$ | 耦合惯量项 | 关节 $j$ 的加速度在关节 $i$ 上引起的惯性广义力 |
| $h_{ijj}\dot q_j^2$ | 离心项 | 与关节 $j$ 速度平方有关的广义力；$h_{iii}=\tfrac12\partial b_{ii}/\partial q_i$，仅在该偏导为零时消失 |
| $h_{ijk}\dot q_j\dot q_k\ (j\neq k)$ | 科氏项 | 与两个关节速度乘积有关的广义力 |
| $g_i(\boldsymbol q)$ | 重力项 | 当前位形下平衡重力所需的广义力；实际重力广义力为 $-g_i$ |
| $(F_{\mathrm v}\dot{\boldsymbol q})_i$ | 粘滞摩擦 | 阻力大小与速度成正比，速度为零时该项为零 |
| $(F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q})_i$ | 库仑摩擦 | 滑动时阻力方向与速度相反，零速度处需要另行描述静摩擦 | 
| $J^{\mathrm T}\boldsymbol h_e$ | 末端接触力 | 末端力/力矩经雅可比转置折回关节 |

::: note 「锁住其他关节」是什么意思
$b_{ii}$ 的含义来自 $T=\frac12\dot q^{\mathrm T}B\dot q$：若只有转动关节 $i$ 以 $1\ \mathrm{rad/s}$ 转动，其余关节锁死，动能为 $\frac12b_{ii}(1\ \mathrm{rad/s})^2$。因此 $b_{ii}$ 是这一运动方式对应的等效转动惯量，而不是连杆 $i$ 自己的惯量。后续连杆和转子的运动也可能贡献动能；若关节 $i$ 是移动关节，$b_{ii}$ 对应等效质量。
:::

::: intuition 为什么会有离心项和科氏项
想象一个人握着哑铃转圈：手臂伸得越长，绕身体转动的惯量越大。即使转速不变，维持圆周运动也需要径向力，这有助于理解速度平方项；如果手臂同时伸缩和转动，还会出现与伸缩速度、转动速度乘积有关的科氏项。严格计算时，速度二次项既来自对 $B\dot q$ 求时间导数中的 $\dot B\dot q$，也来自位置偏导数 $-\partial T/\partial q_i$；两者合并才得到上面的 $h_{ijk}$。
:::

::: ex 例 6.1.3.A · 同一位置，保持、自由下落、主动加速需要多少力矩 {#ex-6.1.3.A}
沿用 [势能节的质点单摆](sec6-1.md#ex-6.1.2.A)：$m=2\ \mathrm{kg}$、$l=0.5\ \mathrm m$，
$q=\pi/6$、当前 $\dot q=0$。忽略摩擦与末端接触，求 (a) 静止保持；(b) 关闭电机；(c) 要求 $\ddot q=2\ \mathrm{rad/s^2}$ 时的结果。

::: sol 解
先把模型压缩为一个标量：$B=ml^2=0.5\ \mathrm{kg\cdot m^2}$ 为常数，$C=0$，
$g=mgl\sin q=4.905\ \mathrm{N\cdot m}$，所以

$$0.5\ddot q+4.905=\tau.$$

(a) 保持要求 $\ddot q=0$，故 $\tau=4.905\ \mathrm{N\cdot m}$。
(b) 关闭电机是 $\tau=0$，故 $\ddot q=-9.81\ \mathrm{rad/s^2}$，负号表示朝垂下位置加速。
(c) 所需力矩 $\tau=0.5\times2+4.905=5.905\ \mathrm{N\cdot m}$，其中 $4.905$ 用于抵消重力，$1$ 用于加速。

**现在速度为零只会消掉速度项，不能自动消掉加速度项。** 静止保持与自由释放在这一瞬间可以有相同的 $q,\dot q$，但因输入不同，加速度不同。
:::
:::

::: think 迁移练习 · 加速方向改了，力矩必须反向吗
若同一位形要求 $\ddot q=-2\ \mathrm{rad/s^2}$，力矩是多少？为什么它仍可为正？

::: sol 核对
$\tau=0.5\times(-2)+4.905=3.905\ \mathrm{N\cdot m}$。
电机向正方向拉，但它的力矩小于保持所需值，重力合力矩仍为负，所以摆向负方向加速。
若认为「负加速度必配负电机力矩」，回读本节矩阵方程，把 $-g$ 放到右侧看净力矩；
若把 $\dot q=0$ 误作 $\ddot q=0$，重做例题 (a)、(b) 的对比。
:::
:::

### 6.1.3.5 两个「伏笔」

::: think 本节埋下的两个问题（6.2 回答）
老师在课上把这两点作为「伏笔」专门强调：本节的结论看似完整，但这两处结构只有到 6.2 才能解释清楚。
1. **$C$ 不唯一**：只要满足 $\sum_j c_{ij}\dot q_j=\sum_{j,k}h_{ijk}\dot q_k\dot q_j$，$C$ 可以有无数组。
   不同的 $C$ 会改变 $\dot B-2C$ 的对称性——这正是 [6.2.1](sec6-2.md#part-6.2.1) 要讲的。
2. **$h_{ijk}$ 的结构**：它由 $B$ 的偏导数得到；重力项 $\boldsymbol g$ 则由势能 $U$ 求偏导得到。给定 $B$ 与 $U$ 后，可以分别求导并组合出速度项和重力项。
:::

### 6.1.3.6 小结与常见错误

- **一句话**：$B\ddot q+C\dot q+\boldsymbol g=\boldsymbol\tau-J^{\mathrm T}h_e$，外加摩擦项。
- **三块**：惯性（$B\ddot q$）、速度耦合（$C\dot q$）、重力（$g$）；摩擦与末端力是外延。
- **一个关键结构**：$C$ 的元素来自 $B$ 的偏导，因此 $C$ 不唯一。

::: think 常见错误清单
1. **把 $C\dot q$ 写成 $C$ 乘 $\dot q$ 但 $C$ 里漏了 $\dot q$**：$C$ 本身是 $q,\dot q$ 的函数，$C\dot q$ 才是力矩。
2. **$h_{ijk}$ 的系数 $1/2$ 漏掉**：第二项是 $-\frac12\partial b_{jk}/\partial q_i$，不是 $-\partial b_{jk}/\partial q_i$。
3. **摩擦项符号**：摩擦总是**阻碍**运动，故在左端取正、移到右端取负；$\operatorname{sgn}\dot q$ 在 $\dot q=0$ 处不连续。
4. **末端力方向**：$h_e$ 是末端作用在环境上的力；环境反力则符号相反。写控制律时先统一约定。
:::

::: think 默写点 · 合上书再写
1. 从 $L=T-U$ 推到 $B\ddot q+C\dot q+g=\xi$ 的完整步骤。
2. 写出 $h_{ijk}$ 的定义，并解释 $b_{ii}$、$b_{ij}$、$h_{ijj}$、$h_{ijk}$、$g_i$ 的物理意义。
3. 写出含摩擦与末端力的完整方程。
4. 为什么 $C$ 不唯一？这会带来什么后果？
:::

**下一节**：[6.2 动力学模型的结构性质](sec6-2.md) 给「那一行公式」补上两条结构定理——反对称性与参数线性性；6.3 再用两连杆把每一项实际算出来。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| $L=T-U$；$\frac{\mathrm d}{\mathrm dt}\frac{\partial L}{\partial\dot q_i}-\frac{\partial L}{\partial q_i}=\xi_i$ | 理想约束、$U=U(q)$ | 视 $q_i$ | 约束力自动消失靠理想约束假设；非保守力必须进 $\xi_i$ |
| $\xi_i=\tau_i-(F_{\mathrm v}\dot q)_i-(F_{\mathrm s}\operatorname{sgn}\dot q)_i-(J^{\mathrm T}h_e)_i$ | 开链、$h_e$=末端向环境施加 | N·m / N | 末端力方向约定先统一；静摩擦另建 |
| $T=\frac12\dot q^{\mathrm T}B(q)\dot q$，$B=\sum_i(m_iJ_P^{\mathrm T}J_P+J_O^{\mathrm T}RI^iR^{\mathrm T}J_O+\text{转子两块})$ | 刚性传动 | kg·m² / kg | $J_P^{(i)}$ 只取到连杆 $i$；转子项系数 $k_r^2$ |
| $U=-\sum_i(m_i g_0^{\mathrm T}p_i+m_{m_i} g_0^{\mathrm T}p_{m_i})$；$\boldsymbol g(q)=\partial U/\partial q$ | $g_0$ 依坐标轴向 | J、N·m | $\boldsymbol g$ 是方程左端项，实际重力广义力为 $-\boldsymbol g$ |
| $B\ddot q+C\dot q+g=\tau-J^{\mathrm T}h_e$（+ 摩擦项） | 全章主方程 | — | $h_{ijk}=\partial b_{ij}/\partial q_k-\frac12\partial b_{jk}/\partial q_i$ 的 $1/2$；$C$ 不唯一 |

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导与自算例；下列课件页保留以备核对，**不构成正文的替代**（对应录播 00:33:00–01:22:30；子节起播：6.1.1 起 00:49:30、6.1.2 起 01:09:10、6.1.3 起 01:15:30）。

| 时间点 | 幻灯片 | 提供了什么 | 本书如何处理 |
|:--|:--|:--|:--|
| 42:11 | [lagrange-eq.jpg](../assets/ch06/lagrange-eq.jpg) | 拉格朗日公式与紧凑形式 | 定义 6.1.1 完整给出，含质点投影推导 |
| 42:11 | [example-pendulum.jpg](../assets/ch06/example-pendulum.jpg) | 例 7.1（带齿轮的摆） | 完整推导 + 课堂强调三件事 + 减速比数值练习 |
| 27:37 | [inertia-tensor.jpg](../assets/ch06/inertia-tensor.jpg) | 惯性张量矩阵形式与平行轴定理 | 定义完整给出；参考系与平行轴两件事在 note 盒展开 |
| 25:57 | [inertia-def.jpg](../assets/ch06/inertia-def.jpg) | 惯性张量定义（绕任意直线） | 正文按积分定义给出，符号约定与板书一致 |
| 66:20 | [kinetic-rotor.jpg](../assets/ch06/kinetic-rotor.jpg) | 转子动能、雅可比与减速比 | 完整推导；移动关节 $k_r$ 量纲坑已注明 |
| 36:20 | [kinetic-link.jpg](../assets/ch06/kinetic-link.jpg) | 连杆动能三块分解 | 平动/交叉/转动三块逐步推导，交叉项归零由质心定义给出 |
| 32:33 | [energy-intro.jpg](../assets/ch06/energy-intro.jpg) | 预备知识——动能与势能的引入 | 6.1.1/6.1.2 的定义完整覆盖 |
| 68:23 | [inertia-matrix.jpg](../assets/ch06/inertia-matrix.jpg) | 总动能与 $B(q)$ 完整表达式 | 四块求和式 + 三条性质完整给出 |
| 69:13 | [potential.jpg](../assets/ch06/potential.jpg) | 势能只依赖 q | 推导 + 符号双路径核对例题 |
| 75:27 | [eom-forces.jpg](../assets/ch06/eom-forces.jpg) | 非保守力如何进入方程 | 四来源表 + 符号约定 note 完整给出 |
| 76:25 | [eom-compact.jpg](../assets/ch06/eom-compact.jpg) | 紧凑矩阵形式 | 主方程完整给出；「那一行公式」的每一项在 6.1.3.4 逐项命名 |
:::
