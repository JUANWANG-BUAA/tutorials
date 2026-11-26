# 6.2 动力学模型的结构性质

关节空间运动方程 $B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau$ 对坐标 $\boldsymbol q$ 高度非线性且各关节强耦合，但这并不意味着控制器设计和模型辨识无从下手。该方程严格继承了刚体物理的两条代数结构：

1. **能量守恒对应的反对称性（$\dot B-2C$）**——直接支撑[第七章](../ch07/sec7-4.md)非线性控制的 Lyapunov 稳定性证明；
2. **未知惯性参数的线性结构（$\boldsymbol\tau = Y\boldsymbol\pi$）**——使机器人可以在线或离线用最小二乘法辨识动力学参数，并支撑自适应控制。

本节导航：[矩阵 $C$ 与反对称性](#part-6.2.1) · [动力学参数线性化](#part-6.2.2)。

<a id="part-6.2.1"></a>

## 6.2.1 $\dot B-2C$ 的反对称性与第一类 Christoffel 符号

### 为什么矩阵 $C$ 的分解不唯一

运动方程中速度二次项要求 $\sum_{j=1}^n c_{ij}\dot q_j = \sum_{j,k=1}^n h_{ijk}\dot q_k\dot q_j$。由于交叉乘积项满足 $\dot q_j\dot q_k = \dot q_k\dot q_j$，把多少分配给 $c_{ij}$（乘以 $\dot q_j$）或分配给 $c_{ik}$（乘以 $\dot q_k$）具有自由度。事实上，任取在 $\dot{\boldsymbol q}$ 方向上贡献为零的矩阵 $D(\boldsymbol q,\dot{\boldsymbol q})$（即 $D\dot{\boldsymbol q}=\boldsymbol 0$），令 $\tilde C = C+D$ 均有 $\tilde C\dot{\boldsymbol q}=C\dot{\boldsymbol q}$。

为消除任意性并构造出有利于控制分析的矩阵形式，将交叉项关于 $(j,k)$ 做**对称平分**：注意到 $\sum_{j,k}\frac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j = \frac12\sum_{j,k}\bigl(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}\bigr)\dot q_k\dot q_j$，将系数写入括号并提取 $\dot q_k$，得到标准元素构造公式：

$$c_{ij}(\boldsymbol q,\dot{\boldsymbol q}) = \sum_{k=1}^{n} c_{ijk}(\boldsymbol q)\dot q_k,$$

其中**第一类 Christoffel 符号（Christoffel symbols of the first kind）** 定义为

$$\boxed{\ c_{ijk}(\boldsymbol q) = \frac12\left(\frac{\partial b_{ij}}{\partial q_k} + \frac{\partial b_{ik}}{\partial q_j} - \frac{\partial b_{jk}}{\partial q_i}\right)\ }$$

**记忆规律与指标核对**：前两项是保留输出行号 $i$ 的惯量偏导（$(i,j)$ 对 $k$ 与 $(i,k)$ 对 $j$ 对称互换）；最后减去 $\frac{\partial b_{jk}}{\partial q_i}$（$(j,k)$ 对 $i$）。由定义显见 $c_{ijk}=c_{ikj}$；且代入求和立即验证它精确还原了 $\sum_j c_{ij}\dot q_j = \sum_{j,k}h_{ijk}\dot q_k\dot q_j$。

### 反对称性的两种陈述与严格区分

定义矩阵 $N(\boldsymbol q,\dot{\boldsymbol q}) = \dot B(\boldsymbol q) - 2C(\boldsymbol q,\dot{\boldsymbol q})$。下面这一定理区分了“矩阵本身反对称”与“动能守恒二次型为零”两条极易混淆的结论：

::: thm[core] 定理 6.2.1 · $\dot B-2C$ 反对称性的两类陈述 {#thm-6.2.1}
1. **陈述 (A)（Christoffel 选法下的矩阵反对称性，原书式 (7.48)）**：若采用上述第一类 Christoffel 符号定义 $C(\boldsymbol q,\dot{\boldsymbol q})$，则矩阵 $N(\boldsymbol q,\dot{\boldsymbol q}) = \dot B(\boldsymbol q) - 2C(\boldsymbol q,\dot{\boldsymbol q})$ 在一切位形和速度下均为**反对称矩阵**，即 $N^{\mathrm T}=-N$，等价于

$$\boldsymbol w^{\mathrm T}\bigl(\dot B(\boldsymbol q)-2C(\boldsymbol q,\dot{\boldsymbol q})\bigr)\boldsymbol w = 0,\qquad \forall\,\boldsymbol w\in\mathbb R^n.$$

2. **陈述 (B)（任意合法 $C$ 下的能量守恒恒等式，原书式 (7.49)）**：对**任意**满足 $C\dot{\boldsymbol q}=\text{速度二次项}$ 的矩阵选取，沿系统速度方向均有

$$\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B(\boldsymbol q)-2C(\boldsymbol q,\dot{\boldsymbol q})\bigr)\dot{\boldsymbol q} = 0.$$

**逻辑关系**：$(\mathrm A)\Longrightarrow(\mathrm B)$（取 $\boldsymbol w=\dot{\boldsymbol q}$ 即得），但反之 $(\mathrm B)\not\Longrightarrow(\mathrm A)$。
:::

::: sol 严格证明（分两步验证）
**证明陈述 (A)**：需证 $N$ 的任意 $(i,j)$ 元满足 $n_{ij}+n_{ji}=0$。对 $\dot b_{ij} = \sum_{k=1}^n \frac{\partial b_{ij}}{\partial q_k}\dot q_k$ 代入 Christoffel 选法下的 $2c_{ij}$：

$$n_{ij} = \dot b_{ij}-2c_{ij} = \sum_{k=1}^n\left[\frac{\partial b_{ij}}{\partial q_k}-\left(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}-\frac{\partial b_{jk}}{\partial q_i}\right)\right]\dot q_k = \sum_{k=1}^n\left(\frac{\partial b_{jk}}{\partial q_i}-\frac{\partial b_{ik}}{\partial q_j}\right)\dot q_k.$$

交换下标 $i\leftrightarrow j$ 并利用惯性矩阵对称性 $b_{ik}=b_{ki},\,b_{jk}=b_{kj}$：

$$n_{ji} = \sum_{k=1}^n\left(\frac{\partial b_{ik}}{\partial q_j}-\frac{\partial b_{jk}}{\partial q_i}\right)\dot q_k = -n_{ij}.$$

故 $n_{ij}+n_{ji}=0$ 且主对角元 $n_{ii}=0$，$N^{\mathrm T}=-N$，从而对任意向量 $\boldsymbol w$ 必有 $\boldsymbol w^{\mathrm T}N\boldsymbol w = (\boldsymbol w^{\mathrm T}N\boldsymbol w)^{\mathrm T} = -\boldsymbol w^{\mathrm T}N\boldsymbol w \implies \boldsymbol w^{\mathrm T}N\boldsymbol w=0$。

**证明陈述 (B)（物理功–能定理视角）**：忽略摩擦、保守势能由广义力 $\boldsymbol\tau_{\mathrm{total}}=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e-\boldsymbol g$ 统计时，对系统机械能（此处取动能 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}$）求时间导数：

$$\frac{\mathrm dT}{\mathrm dt} = \dot{\boldsymbol q}^{\mathrm T}B\ddot{\boldsymbol q} + \frac12\dot{\boldsymbol q}^{\mathrm T}\dot B\dot{\boldsymbol q}.$$

从任意合法运动方程代入 $B\ddot{\boldsymbol q}=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e-\boldsymbol g-C\dot{\boldsymbol q}$：

$$\frac{\mathrm dT}{\mathrm dt} = \dot{\boldsymbol q}^{\mathrm T}\bigl(\boldsymbol\tau - J^{\mathrm T}\boldsymbol h_e - \boldsymbol g\bigr) + \frac12\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B - 2C\bigr)\dot{\boldsymbol q}.$$

另一方面，物理上总外广义力在真实运动上做的功率必须精确等于动能变化率（机械臂所受一切约束内力不做虚功、因此也不做实功），故上式前项已等于 $\dot T$，余项必为零：

$$\frac12\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B - 2C\bigr)\dot{\boldsymbol q} = 0.$$
:::

::: ex 例 6.2.2 · 反例：$C$ 不按 Christoffel 选法时，陈述 (B) 成立而陈述 (A) 失效
对两连杆平面臂，速度耦合部分取 $h=-m_2a_1\ell_2s_2=-12.5\ \mathrm{kg\cdot m^2}$，则 $\dot B = \begin{bmatrix}2h\dot q_2&h\dot q_2\\h\dot q_2&0\end{bmatrix}$。若不采用对称平分，而强行把所有交叉项系数全塞进 $c_{11}$ 和 $c_{21}$ 中，取另一组合法矩阵：

$$\tilde C = \begin{bmatrix}2h\dot q_2&0\\0&-h\dot q_1\end{bmatrix} \quad\Longrightarrow\quad \tilde C\dot{\boldsymbol q} = \begin{bmatrix}2h\dot q_1\dot q_2\\-h\dot q_1^2\end{bmatrix} \quad\text{（注：需保留 }h\dot q_2^2\text{，改取 }\tilde C=\begin{bmatrix}2h\dot q_2&h\dot q_2\\-h\dot q_1&0\end{bmatrix}\text{ 仅能改变交叉分配）}$$

准确地构造一组不漏项的反例：将 $2h\dot q_1\dot q_2+h\dot q_2^2$ 全配给第二列、或第一行第一列加减 $D$ 满足 $D\dot{\boldsymbol q}=0$，例如取

$$\tilde C = C_{\mathrm{Christoffel}} + \begin{bmatrix}h\dot q_2&-h\dot q_1\\h\dot q_2&-h\dot q_1\end{bmatrix} = \begin{bmatrix}2h\dot q_2&h\dot q_2\\h\dot q_2-h\dot q_1&-h\dot q_1\end{bmatrix}.$$

在状态 $h=-12.5$、$(\dot q_1,\dot q_2)=(0.3,0.4)$ 下直接算出 $N=\dot B-2\tilde C=\begin{bmatrix}10.0&5.0\\-7.5&-3.75\end{bmatrix}$。可见：
- **对任意 $\boldsymbol w=(1,0)^{\mathrm T}$**：$\boldsymbol w^{\mathrm T}N\boldsymbol w = 10.0 \neq 0$，且 $N$ 对角元非零、并不反对称，**陈述 (A) 失效**；
- **对 $\dot{\boldsymbol q}=(0.3,0.4)^{\mathrm T}$**：$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q} = 0.09(10) + 0.12(5-7.5) + 0.16(-3.75) = 0$，**陈述 (B) 依然严格成立**。
:::

<a id="part-6.2.2"></a>

## 6.2.2 动力学参数对惯性参数的线性性

控制器若要前馈补偿 $B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)$，前提是知道连杆质量、质心坐标和惯性张量——但这些值常因加工公差、内部线束、末端工具载荷而难以直接测量。关键在于：尽管运动方程对状态 $\boldsymbol q,\dot{\boldsymbol q}$ 是高度非线性的，它对恰当选取的**动力学参数向量 $\boldsymbol\pi$** 却严格保持**线性**。

### 为什么动能看似对质心位置是非线性的？

若单独拿质量 $m_i$ 和质心位置矢量 $\boldsymbol r_{i,C_i}^i$ 当参数，质心惯性矩的平行轴项含 $m_i\|\boldsymbol r_{i,C_i}^i\|^2$，表现为乘积非线性。解决这一问题的标准代数重参数化是**改取相对关节系原点 $O_i$ 的锁转惯量与一阶矩**：

$$\begin{aligned}
\boldsymbol h_i &= m_i^{\mathrm{aug}}\,\boldsymbol r_{i,C_i}^i\qquad\text{（一阶质量矩，}\mathrm{kg\cdot m}\text{）},\\
\widehat{\boldsymbol I}_i^i &= \bar{\boldsymbol I}_i^i + m_i^{\mathrm{aug}}\,S^{\mathrm T}(\boldsymbol r_{i,C_i}^i)S(\boldsymbol r_{i,C_i}^i)\qquad\text{（相对坐标系原点的锁转惯性张量，}\mathrm{kg\cdot m^2}\text{）}.
\end{aligned}$$

为此需注意转子归属的边界分组，引入**扩展连杆（augmented link）**概念：将连杆 $i$ 本体与装在它上面、驱动下一关节 $i+1$ 的电机锁转质量与惯量合称为扩展连杆 $i$；但电机 $i+1$ 相对安装座的自转部分不依附连杆 $i$，而是随关节 $i+1$ 运动。

### 扩展连杆的 11 个惯性参数与块上三角回归方程

对于第 $i$ 个关节–连杆分组，将扩展连杆 $i$ 的锁转量与电机 $i$ 的自转轴惯量配成一组 $\boldsymbol\pi_i\in\mathbb R^{11}$：

| 参数符号 | 数量 | 物理意义 | 单位 |
|:--|:--|:--|:--|
| $m_i^{\mathrm{aug}}$ | 1 | 扩展连杆总质量（连杆 $i$ + 电机 $i+1$ 定/转子质心锁转质量） | $\mathrm{kg}$ |
| $\boldsymbol h_i=[m_i^{\mathrm{aug}}\ell_{C_i,x},\,m_i^{\mathrm{aug}}\ell_{C_i,y},\,m_i^{\mathrm{aug}}\ell_{C_i,z}]^{\mathrm T}$ | 3 | 相对坐标系 $i$ 原点的一阶质量矩 | $\mathrm{kg\cdot m}$ |
| $\widehat{\boldsymbol I}_i^i$ 独立元（$xx,xy,xz,yy,yz,zz$） | 6 | 相对坐标系 $i$ 原点的对称锁转惯性张量 | $\mathrm{kg\cdot m^2}$ |
| $I_{m_i}$ | 1 | 第 $i$ 个轴对称电机转子的轴向转动惯量（纯自转及交叉贡献） | $\mathrm{kg\cdot m^2}$ |

将动能 $T_{\ell_i^{\mathrm{aug}}} + T_{m_i^{\mathrm{spin}}}$ 与势能 $U_i$ 按以上参数展开，可得每个分组的标量能量均呈线性乘积：

$$T = \sum_{j=1}^n \boldsymbol\beta_{T_j}^{\mathrm T}(\boldsymbol q,\dot{\boldsymbol q})\boldsymbol\pi_j,\qquad U = \sum_{j=1}^n \boldsymbol\beta_{U_j}^{\mathrm T}(\boldsymbol q)\boldsymbol\pi_j.$$

由于连杆 $j$ 和转子 $j$ 的姿态、位置和角速度**至多依赖关节 $1,\dots,j$**，故仅对 $q_1,\dots,q_j$ 存在非零偏导（$j<i$ 时 $\boldsymbol\beta_{T_j},\boldsymbol\beta_{U_j}$ 与 $q_i$ 无关）。代入拉格朗日算子 $\mathcal D_i = \frac{\mathrm d}{\mathrm dt}\frac{\partial}{\partial\dot q_i}-\frac{\partial}{\partial q_i}$，即得无接触无摩擦时的线性回归方程：

$$\xi_i = \sum_{j=i}^{n}\boldsymbol y_{ij}^{\mathrm T}(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi_j,\qquad \boldsymbol y_{ij} = \frac{\mathrm d}{\mathrm dt}\frac{\partial\boldsymbol\beta_{T_j}}{\partial\dot q_i}-\frac{\partial\boldsymbol\beta_{T_j}}{\partial q_i}+\frac{\partial\boldsymbol\beta_{U_j}}{\partial q_i}.$$

汇集为全机械臂的**块上三角回归形式**（若进一步把各关节粘滞摩擦系数 $F_{v_i}$ 和滑动库仑摩擦系数 $F_{s_i}$ 并入参数向量，则每组至多共 **13 个**名义参数）：

$$\begin{bmatrix}\tau_1\\ \tau_2\\ \vdots\\ \tau_n\end{bmatrix} = \begin{bmatrix} \boldsymbol y_{11}^{\mathrm T}&\boldsymbol y_{12}^{\mathrm T}&\cdots&\boldsymbol y_{1n}^{\mathrm T}\\ \boldsymbol 0^{\mathrm T}&\boldsymbol y_{22}^{\mathrm T}&\cdots&\boldsymbol y_{2n}^{\mathrm T}\\ \vdots&&\ddots&\vdots\\ \boldsymbol 0^{\mathrm T}&\boldsymbol 0^{\mathrm T}&\cdots&\boldsymbol y_{nn}^{\mathrm T} \end{bmatrix} \begin{bmatrix}\boldsymbol\pi_1\\ \boldsymbol\pi_2\\ \vdots\\ \boldsymbol\pi_n\end{bmatrix} \quad\Longrightarrow\quad \boxed{\ \boldsymbol\tau = Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\,\boldsymbol\pi\ }\qquad(\boldsymbol h_e=\boldsymbol 0).$$

::: note 实际辨识的三层核心事实（原书 §7.4）
1. **三层参数计数不要混用**：每组 **11 个**为纯惯性名义参数，**13 个**为包含两类关节摩擦的名义参数；具体机构下因几何对称或转动轴受限，某些列恒为零或彼此线性相关，合并同类列后才能得到真正可独立辨识的**最小参数集**（如两连杆平面臂共 22 个名义惯性参数可约简为 8 个结构参数，进而合并成 5 个独立组合）。
2. **数据采集与线性最小二乘求解**：沿激励轨迹在 $N$ 个时刻采样并按行堆叠：
   $$\bar{\boldsymbol\tau} = \begin{bmatrix}Y(t_1)\\\vdots\\Y(t_N)\end{bmatrix}\boldsymbol\pi = \bar Y\boldsymbol\pi \implies \hat{\boldsymbol\pi} = (\bar Y^{\mathrm T}\bar Y)^{-1}\bar Y^{\mathrm T}\bar{\boldsymbol\tau}.$$
   唯一解要求**持续激励（persistent excitation）**，即 $\bar Y$ 对所选最小参数集列满秩；复杂机构用奇异值分解剔除零列与相关组合列。若出现有接触力的工况（已知 $\boldsymbol h_e$），需从实测力矩中预先扣除 $J^{\mathrm T}\boldsymbol h_e$。
3. **末关节逐组消去与有效负载辨识**：块上三角结构允许从第 $n$ 关节向基座逐组辨识，前提是末关节唯一确定的组合足以算出该组对前序关节的交叉项（若只可辨识部分跨杆组合，仍需联立多关节堆叠求解）。若末端刚性加装未知负载，只需把负载并入末连杆 $n$ 视为该扩展连杆参数修正，重新辨识末组即可。轨迹宜采用有限阶谐波或光滑多项式，以兼顾持续激励并避免激起未建模的关节与连杆柔性振动。
:::

## 本节小结

- **两条结构性质分工明确**：反对称性管闭环稳定（控制律设计），参数线性性管参数获取（模型辨识与自适应控制）。
- **本节核心速查**：

| 性质 | 公式与条件 | 易错点 |
|:--|:--|:--|
| Christoffel 符号 | $c_{ijk}=\frac12(\partial_k b_{ij}+\partial_j b_{ik}-\partial_i b_{jk})$ | 前两项 $(i,j),(i,k)$ 保留行号，最后减 $(j,k)$ 对 $i$ 的偏导；$c_{ijk}=c_{ikj}$ |
| $\dot B-2C$ 反对称 | Christoffel 选法下 $N^{\mathrm T}=-N$，即 $\forall\boldsymbol w,\ \boldsymbol w^{\mathrm T}N\boldsymbol w=0$ | 能量守恒式 $\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$ 对一切合法 $C$ 成立，不蕴含矩阵 $N$ 反对称 |
| 参数线性性 | $\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi$（无接触时） | $\boldsymbol\pi$ 为相对关节系原点的 11 维锁转/自转分组（含摩擦 13 维）；$Y$ 依赖状态与加速度，采样须检查 $\bar Y$ 列满秩 |

**下一节**：[6.3 两连杆动力学算例](sec6-3.md) 把 6.1 和 6.2 的全部公式落到正交笛卡儿臂与平面 2R 臂两个典型构型中，完整手算 $B,C,\boldsymbol g$ 与 8 参数线性化形式。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 82:36 | [skew.jpg](../assets/ch06/skew.jpg) | $C$ 的非唯一性与第一类 Christoffel 符号 | 6.2.1 完整推导 + 例 6.2.2 构造反例区分重配对 |
| 86:30 | [christoffel.jpg](../assets/ch06/christoffel.jpg) | $\dot B-2C$ 反对称与两种陈述 | 定理 6.2.1 分离陈述 (A) 与 (B) 并给出两步证明 |
| 95:15 | [linearity.jpg](../assets/ch06/linearity.jpg) | 扩展连杆动能与 11 个惯性参数 | 6.2.2 解释原点锁转惯量重参数化与 11 参数表 |
| 110:07 | [linearity-tau.jpg](../assets/ch06/linearity-tau.jpg) | 广义力对惯性参数线性 | 给出块上三角推导与转子归属边界 |
| 114:27 | [regressor.jpg](../assets/ch06/regressor.jpg) | $\boldsymbol\tau=Y\boldsymbol\pi$ 与回归辨识 | 给出正规方程、最小参数集、末关节消去及激励边界 |
:::
