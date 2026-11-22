# 6.2 动力学模型的结构性质

本页导航：[$\dot B-2C$ 的反对称性](#part-6.2.1) · [动力学参数的线性性](#part-6.2.2)。

<a id="part-6.2.1"></a>

## 6.2.1 $\dot B-2C$ 的反对称性

这是动力学模型的**第一条结构性质**。它看起来只是一个矩阵恒等式，
实际上是能量守恒在动力学方程里的代数影子——原书第 8 章的稳定性证明、自适应控制的无源性分析都要用它。

### 6.2.1.1 先解决「$C$ 不唯一」

运动方程只要求 $C$ 满足

$$\sum_{j=1}^{n}c_{ij}\dot q_j=\sum_{j=1}^{n}\sum_{k=1}^{n}h_{ijk}\dot q_k\dot q_j,
\qquad h_{ijk}=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i}.$$

满足这个条件的 $C$ 有无穷多个：往 $C$ 加上满足 $D(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}=0$ 的矩阵 $D$，动力学方程不变。例如在二维中，取非零常数 $a$，令

$$D=a\begin{bmatrix}-\dot q_2&\dot q_1\\0&0\end{bmatrix},\qquad D\dot{\boldsymbol q}=\boldsymbol 0.$$

一般反对称矩阵并不满足 $D\dot{\boldsymbol q}=0$。因此 $C$ 本身不唯一，而给定模型中的 $C\dot{\boldsymbol q}$ 不变。

为了得到一个有良好性质的 $C$，把右端的 $h_{ijk}\dot q_k\dot q_j$ 重新配对。利用 $\dot q_j\dot q_k$ 的对称性，
可以把 $\dfrac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j$ 拆成两半、交换 $j,k$：

$$\sum_{j,k}\frac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j
=\frac12\sum_{j,k}\Bigl(\frac{\partial b_{ij}}{\partial q_k}
+\frac{\partial b_{ik}}{\partial q_j}\Bigr)\dot q_k\dot q_j.$$

于是

$$c_{ij}=\sum_{k=1}^{n}c_{ijk}\dot q_k,\qquad
c_{ijk}=\frac12\Bigl(\frac{\partial b_{ij}}{\partial q_k}
+\frac{\partial b_{ik}}{\partial q_j}
-\frac{\partial b_{jk}}{\partial q_i}\Bigr).$$

$c_{ijk}$ 称为**第一类 Christoffel 符号**（Christoffel symbols of the first type）。由 $B$ 的对称性
$b_{ij}=b_{ji}$ 立刻有

$$c_{ijk}=c_{ikj}.$$

### 6.2.1.2 $N=\dot B-2C$ 反对称

定义

$$N(\boldsymbol q,\dot{\boldsymbol q})=\dot B(\boldsymbol q)-2C(\boldsymbol q,\dot{\boldsymbol q}).$$

先看 $C$ 的元素：

$$c_{ij}=\frac12\sum_k\frac{\partial b_{ij}}{\partial q_k}\dot q_k
+\frac12\sum_k\Bigl(\frac{\partial b_{ik}}{\partial q_j}
-\frac{\partial b_{jk}}{\partial q_i}\Bigr)\dot q_k
=\frac12\dot b_{ij}
+\frac12\sum_k\Bigl(\frac{\partial b_{ik}}{\partial q_j}
-\frac{\partial b_{jk}}{\partial q_i}\Bigr)\dot q_k.$$

因此

$$n_{ij}=\dot b_{ij}-2c_{ij}
=\sum_{k=1}^{n}\Bigl(\frac{\partial b_{jk}}{\partial q_i}
-\frac{\partial b_{ik}}{\partial q_j}\Bigr)\dot q_k.$$

交换 $i,j$：

$$n_{ji}=\sum_{k}\Bigl(\frac{\partial b_{ik}}{\partial q_j}
-\frac{\partial b_{jk}}{\partial q_i}\Bigr)\dot q_k=-n_{ij}.$$

所以

$$\boxed{\ N^{\mathrm T}=-N\ }$$

即 $N$ 是**反对称矩阵**。等价地，对任意 $n$ 维向量 $\boldsymbol w$，

$$\boxed{\ \boldsymbol w^{\mathrm T}N(\boldsymbol q,\dot{\boldsymbol q})\boldsymbol w=0\ }$$

（因为标量的转置等于自身：$\boldsymbol w^{\mathrm T}N\boldsymbol w=(\boldsymbol w^{\mathrm T}N\boldsymbol w)^{\mathrm T}
=\boldsymbol w^{\mathrm T}N^{\mathrm T}\boldsymbol w=-\boldsymbol w^{\mathrm T}N\boldsymbol w$，故为零。）

### 6.2.1.3 两个命题要分清

教材特别区分了两件事（这是考试最爱设陷阱的地方）：

::: thm[core] 定理 6.2.1 · 反对称性的两种陈述 {#thm-6.2.1}
**(A) 对 Christoffel 选法的 $C$**：$N=\dot B-2C$ 是反对称矩阵，即对**任意** $\boldsymbol w$ 有
$\boldsymbol w^{\mathrm T}N\boldsymbol w=0$。

**(B) 对任意选法的 $C$**：取 $\boldsymbol w=\dot{\boldsymbol q}$，仍有
$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$。

**(B) 不蕴含 (A)**：因为 $N$ 还依赖 $\dot{\boldsymbol q}$，$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$
只是「沿着系统自己的速度方向」成立，不能推出对所有 $\boldsymbol w$ 成立。
:::

**(B) 的证明（能量守恒）**：动能的变化率等于所有力做的功率：

$$\frac12\frac{\mathrm d}{\mathrm dt}\bigl(\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}\bigr)
=\dot{\boldsymbol q}^{\mathrm T}\bigl(\boldsymbol\tau-F_{\mathrm v}\dot{\boldsymbol q}
-F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}-\boldsymbol g-J^{\mathrm T}\boldsymbol h_e\bigr).$$

左边展开：

$$\frac12\frac{\mathrm d}{\mathrm dt}\bigl(\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}\bigr)
=\frac12\dot{\boldsymbol q}^{\mathrm T}\dot B\dot{\boldsymbol q}+\dot{\boldsymbol q}^{\mathrm T}B\ddot{\boldsymbol q}.$$

把 $B\ddot{\boldsymbol q}=\boldsymbol\tau-C\dot{\boldsymbol q}-F_{\mathrm v}\dot{\boldsymbol q}
-F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}-\boldsymbol g-J^{\mathrm T}\boldsymbol h_e$ 代入，得

$$\frac12\frac{\mathrm d}{\mathrm dt}\bigl(\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}\bigr)
=\frac12\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B-2C\bigr)\dot{\boldsymbol q}
+\dot{\boldsymbol q}^{\mathrm T}\bigl(\boldsymbol\tau-F_{\mathrm v}\dot{\boldsymbol q}
-F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}-\boldsymbol g-J^{\mathrm T}\boldsymbol h_e\bigr).$$

与上面的功率平衡式对照，得到 $\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q}=0$。这个结论对产生同一速度耦合项 $C\dot{\boldsymbol q}$ 的不同选法都成立。Christoffel 选法进一步保证整个矩阵 $\dot B-2C$ 反对称；其他选法也可能具有这个性质，但不能不加证明地假定都有。

::: intuition 为什么「反对称」等于「不做功」
反对称矩阵的二次型恒为零，所以动能求导时，$\tfrac12\dot q^{\mathrm T}\dot B\dot q$ 与 $\dot q^{\mathrm T}C\dot q$ 恰好抵消。这并不意味着 $C\dot q$ 单独不做功：惯量 $B$ 随位形变化时，这两项可以分别非零。
:::

### 6.2.1.4 小结与常见错误

- **一句话**：选 Christoffel 符号构造 $C$，则 $\dot B-2C$ 反对称；对任意 $C$，沿 $\dot q$ 方向仍有
  $\dot q^{\mathrm T}(\dot B-2C)\dot q=0$。
- **两条陈述**：(A) 对所有 $w$；(B) 只对 $w=\dot q$。(B) 是物理的，(A) 是选法的。
- **用途**：稳定性证明、自适应控制、无源性分析。

::: think 常见错误清单
1. **把 (A) 与 (B) 混为一谈**：以为「$\dot q^{\mathrm T}N\dot q=0$」就说明 $N$ 反对称——不，$N$ 依赖 $\dot q$，
   换一个 $w$ 就不为零。
2. **Christoffel 符号的系数写错**：是 $\frac12(\partial_k b_{ij}+\partial_j b_{ik}-\partial_i b_{jk})$，
   三项的指标位置别弄反。
3. **以为 $C$ 唯一**：$C$ 不唯一，只有 $C\dot q$ 唯一；讨论「$C$ 的对称性」本身没有意义。
4. **忘记 $N$ 还依赖 $\dot q$**：$N=N(q,\dot q)$，不是只依赖 $q$。
:::

::: think 默写点 · 合上书再写
1. 写出 Christoffel 符号 $c_{ijk}$ 与 $c_{ij}$。
2. 证明 $N=\dot B-2C$ 反对称。
3. 写出并证明 $\dot q^{\mathrm T}N\dot q=0$（能量守恒路线）。
4. 说明 (A) 与 (B) 的区别，并各举一个用途。
:::

<a id="part-6.2.2"></a>

## 6.2.2 动力学参数的线性性

这是动力学模型的**第二条结构性质**，也是参数辨识与
自适应控制的入口：**力矩对一组「动力学参数」是线性的**，于是可以把辨识写成线性最小二乘。

### 6.2.2.1 为什么要「扩展连杆」

一个关节的电机转子通常装在**前一个连杆**上（图 7.2），所以转子 $i+1$ 的动能与连杆 $i$ 的动能
共享同一组运动学量。把「连杆 $i$ + 转子 $i+1$」合并成**扩展连杆 $i$**（augmented Link $i$），
动能可以写成

$$T_i=T_{\text{link }i}+T_{m_{i+1}}.$$

设扩展连杆的质心为 $C_i$，其质量为 $m_i=m_{\text{link }i}+m_{m_{i+1}}$，则连杆与转子的质心速度都可以
用**同一个质心速度** $\dot{\boldsymbol p}_{C_i}$ 加相对矢径表示：

$$\dot{\boldsymbol p}_i=\dot{\boldsymbol p}_{C_i}+\boldsymbol\omega_i\times\boldsymbol r_{C_i,i},\qquad
\dot{\boldsymbol p}_{m_{i+1}}=\dot{\boldsymbol p}_{C_i}+\boldsymbol\omega_i\times\boldsymbol r_{C_i,m_{i+1}}.$$

代入各自的动能、用平行轴定理合并，得到扩展连杆的动能：

$$T_i=\frac12 m_i\dot{\boldsymbol p}_{C_i}^{\mathrm T}\dot{\boldsymbol p}_{C_i}
+\frac12\boldsymbol\omega_i^{\mathrm T}\bar{\boldsymbol I}_i\boldsymbol\omega_i
+k_{r,i+1}\dot q_{i+1}\boldsymbol z_{m_{i+1}}^{\mathrm T}\boldsymbol I_{m_{i+1}}\boldsymbol\omega_i
+\frac12k_{r,i+1}^2\dot q_{i+1}^2\boldsymbol z_{m_{i+1}}^{\mathrm T}\boldsymbol I_{m_{i+1}}\boldsymbol z_{m_{i+1}},$$

其中 $\bar{\boldsymbol I}_i$ 是扩展连杆相对质心的锁转惯性张量。这里假定转子质心位于转轴上，转子绕该轴轴对称；第一关节转子装在固定基座上，末端连杆后面没有下一个转子，这两个边界项须分别计入或省去。

### 6.2.2.2 参数向量：11 个

先把锁转部分的动能改写到连杆系原点 $O_i$，才能看清参数为什么线性。设 $\boldsymbol v_i$、$\boldsymbol\omega_i$ 是原点速度与角速度，$\boldsymbol\ell_{C_i}$ 是从原点指向质心的向量，三者都在连杆系中表达。记一阶矩 $\boldsymbol h_i=m_i\boldsymbol\ell_{C_i}$，并将上面的质心惯量换到连杆系：$\bar{\boldsymbol I}_i^i=R_i^{\mathrm T}\bar{\boldsymbol I}_iR_i$。根据平行轴定理，相对 $O_i$ 的锁转惯性张量为

$$\widehat{\boldsymbol I}_i=\bar{\boldsymbol I}_i^i+m_iS(\boldsymbol\ell_{C_i})^{\mathrm T}S(\boldsymbol\ell_{C_i}).$$

将质心的物理速度也在连杆系表达，记作 $\boldsymbol v_{C_i}$，则 $\boldsymbol v_{C_i}=\boldsymbol v_i+\boldsymbol\omega_i\times\boldsymbol\ell_{C_i}$。展开质心平动动能，再加上绕质心的转动动能，得到

$$T_{i,\mathrm{lock}}=\tfrac12m_i\boldsymbol v_i^{\mathrm T}\boldsymbol v_i
+\boldsymbol v_i^{\mathrm T}(\boldsymbol\omega_i\times\boldsymbol h_i)
+\tfrac12\boldsymbol\omega_i^{\mathrm T}\widehat{\boldsymbol I}_i\boldsymbol\omega_i.$$

三项依次对质量、一阶矩和原点惯量线性。势能也可写成 $U_i=-\boldsymbol g_0^{\mathrm T}(m_i\boldsymbol p_{O_i}+R_i\boldsymbol h_i)$，因此对质量和一阶矩线性。这里 $\boldsymbol p_{O_i}$、$R_i$ 分别是连杆系原点的位置和姿态，重力 $\boldsymbol g_0$ 在基系表达。

把锁转参数归给扩展连杆 $i$，把转子 $i$ 的自转附加项另归入第 $i$ 组。对轴对称转子，$\boldsymbol I_{m_i}\boldsymbol z_{m_i}=I_{m_i}\boldsymbol z_{m_i}$，故自转附加项对轴向惯量 $I_{m_i}$ 线性。第 $i$ 组参数写为

$$\boldsymbol\pi_i=\bigl[
m_i,\quad h_{ix},\quad h_{iy},\quad h_{iz},\quad
\widehat I_{i,xx},\quad \widehat I_{i,xy},\quad \widehat I_{i,xz},\quad
\widehat I_{i,yy},\quad \widehat I_{i,yz},\quad \widehat I_{i,zz},\quad I_{m_i}
\bigr]^{\mathrm T}.$$

逐项读：

| 参数 | 含义 |
|:--|:--|
| $m_i$ | 扩展连杆质量 |
| $h_{ix},h_{iy},h_{iz}$ | **一阶质量矩**，即 $m_i\boldsymbol\ell_{C_i}$ 的三个分量 |
| $\widehat I_{i,xx},\dots,\widehat I_{i,zz}$ | 相对连杆系原点的锁转惯性张量的 6 个独立分量 |
| $I_{m_i}$ | 转子 $i$ 绕自身轴的转动惯量；其自转附加项归入第 $i$ 组 |

固定几何尺寸、传动关系和重力后，每项都是“常参数 × 运动学系数”。这里的 $\widehat{\boldsymbol I}_i$ 和 $\boldsymbol h_i$ 是选作回归变量的惯性参数；不能再把 $\widehat{\boldsymbol I}_i$ 展开成含未知质心的乘积后，仍声称对 $m_i,\boldsymbol\ell_{C_i}$ 分别线性。

### 6.2.2.3 从拉格朗日函数到回归矩阵

按上述方式分组：第 $j$ 组包含扩展连杆 $j$ 的锁转能量，以及转子 $j$ 的自转附加动能。把各组相加后，拉格朗日函数写成

$$L=\sum_{j=1}^{n}\bigl(\boldsymbol\beta_{T_j}^{\mathrm T}-\boldsymbol\beta_{U_j}^{\mathrm T}\bigr)\boldsymbol\pi_j.$$

系数 $\boldsymbol\beta_{T_j},\boldsymbol\beta_{U_j}$ 由运动学、已知几何和重力确定，不依赖待辨识的动力学参数。拉格朗日方程对这些常参数作线性运算，因此广义力可写成

$$\xi_i=\sum_{j=1}^{n}\boldsymbol y_{ij}^{\mathrm T}\boldsymbol\pi_j,$$

其中

$$\boldsymbol y_{ij}=\frac{\mathrm d}{\mathrm dt}\frac{\partial\boldsymbol\beta_{T_j}}{\partial\dot q_i}
-\frac{\partial\boldsymbol\beta_{T_j}}{\partial q_i}
+\frac{\partial\boldsymbol\beta_{U_j}}{\partial q_i}.$$

上面的分组使第 $j$ 组的锁转能量只涉及关节 $1,\ldots,j$；转子 $j$ 的自转项也只涉及这些关节。因此 $j<i$ 时，$\boldsymbol y_{ij}=0$，下面是**块上三角**矩阵。注意：单个扩展连杆总动能含转子 $j+1$ 的自转，不能不经重新分组就声称它只依赖前 $j$ 个关节。

$$\begin{bmatrix}\xi_1\\ \xi_2\\ \vdots\\ \xi_n\end{bmatrix}
=\begin{bmatrix}
\boldsymbol y_{11}^{\mathrm T}&\boldsymbol y_{12}^{\mathrm T}&\cdots&\boldsymbol y_{1n}^{\mathrm T}\\
\boldsymbol 0^{\mathrm T}&\boldsymbol y_{22}^{\mathrm T}&\cdots&\boldsymbol y_{2n}^{\mathrm T}\\
\vdots&&\ddots&\vdots\\
\boldsymbol 0^{\mathrm T}&\boldsymbol 0^{\mathrm T}&\cdots&\boldsymbol y_{nn}^{\mathrm T}
\end{bmatrix}
\begin{bmatrix}\boldsymbol\pi_1\\ \boldsymbol\pi_2\\ \vdots\\ \boldsymbol\pi_n\end{bmatrix}.$$

紧凑写成 $\boldsymbol\xi=Y_0(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi_0$。其中 $\boldsymbol\pi_0$ 汇集惯性参数；$Y_0$ 是由已知几何、重力和 $q,\dot q,\ddot q$ 构成的回归矩阵。

按 [6.1](sec6-1.md) 的约定，$\boldsymbol\xi=\boldsymbol\tau-F_{\mathrm v}\dot{\boldsymbol q}-F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}-J^{\mathrm T}\boldsymbol h_e$。在无接触、忽略摩擦时，$\boldsymbol\tau=Y_0\boldsymbol\pi_0$；若将各关节的黏滞与滑动库仑摩擦系数也加入参数向量，便可写成

$$\boxed{\ \boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi\ }\qquad(\boldsymbol h_e=0).$$

例如第 $i$ 行增加 $\dot q_i$ 和 $\operatorname{sgn}\dot q_i$ 两列，分别乘 $F_{v_i},F_{s_i}$；零速度静摩擦仍需另建模型。有接触且 $\boldsymbol h_e$ 已知时，先从 $\boldsymbol\tau$ 减去 $J^{\mathrm T}\boldsymbol h_e$。$\boldsymbol\pi$ 为 $p\times1$ 常参数向量，$Y$ 为 $n\times p$ 回归矩阵。

### 6.2.2.4 参数的个数与「最小参数集」

- 在本节轴对称转子、已知传动比且无接触的模型中，每组名义上有 **13 个**参数：11 个惯性参数加黏滞、库仑摩擦系数。
- 不是所有参数都独立出现：部分列恒为零，另一些只能以线性组合出现。名义参数个数至多为 $13n$，可辨识参数组合通常更少。
- 对具体结构可以进一步合并，得到**最小参数集**（minimal parameterization）。例如两连杆平面臂的
  22 个「名义参数」可以压到 8 个（教材式 (7.83)），甚至 5 个（习题 7.4）。

::: note 这条性质有什么用
1. **参数辨识**：无接触时沿轨迹采样，将各时刻的 $Y$ 和 $\tau$ 按行堆叠，得到线性方程组，可用最小二乘估计参数。线性并不保证唯一辨识：还需检查堆叠后的回归矩阵是否对所选参数集满列秩，轨迹必须提供足够激励。
   若模型对参数非线性，就得用非线性优化，代价大得多。
2. **自适应控制**：把 $\hat{\boldsymbol\pi}$ 作为在线估计，控制律里用 $Y\hat{\boldsymbol\pi}$ 做前馈补偿，
   再用跟踪误差驱动 $\dot{\hat{\boldsymbol\pi}}$ 更新——这就是自适应机器人的标准结构。
3. **参数筛选**：$Y$ 的零列/相关列直接告诉你「哪些参数根本不可辨识」，避免白费力气去测。
:::

### 6.2.2.5 怎样实际辨识参数

第 8 周开头的课件 §7.4（`s00344`–`s00835`）接着讲了辨识流程。上面的块上三角结构允许先考察末关节：沿轨迹采集末关节数据，用 $\tau_n=\boldsymbol y_{nn}^{\mathrm T}\boldsymbol\pi_n$ 估计可辨识的末端参数组合，再向基座方向处理。每个 $\boldsymbol\pi_i$ 都是参数向量，单个时刻的一条标量方程不够，仍须堆叠多个时刻并检查秩。

逐组消去还需要一个条件：末关节数据确定的参数组合，必须足以算出该组对上一关节方程的贡献。若某个参数组合在末关节方程中无法区分，却会影响上一关节，就不能先给它任取数值再相减；应将有关关节的数据合并，联合辨识可区分的组合。块上三角结构本身不保证这些条件成立。

课件还区分了两类“求不出”：某参数对任意轨迹都不影响运动方程，对应零列；另一些参数会影响方程，但只以固定线性组合出现，对应相关列。后一种应合并成可辨识的组合，不能把各个物理参数都报告为已辨识。自由度较少时可以直接检查方程；复杂机构则可用堆叠回归矩阵的奇异值分解，判断独立列和可辨识参数组合。

**轨迹不是越猛越好。** `s00835` 建议采用多项式型轨迹，同时提醒不要激起模型没有包含的关节弹性或连杆挠性变形。前者是轨迹形式的建议，不是满秩保证；后者意味着即使增加激励，若激起未建模效应，估计值也可能偏离所用刚体模型的参数。辨识需要兼顾充分激励与模型适用范围。

同页还给出未知末端有效负载的处理：将刚性安装的负载看成最后一根连杆的结构修正，重新辨识修正后连杆的等效惯性参数。这不等于把负载重力误算成一个无关的常接触力，也不意味着能单独区分所有负载参数与原末杆参数。

### 6.2.2.6 小结与常见错误

- **一句话**：将扩展连杆锁转参数与转子自转参数分组，能量和广义力对参数线性；无接触时，把摩擦参数并入可写成 $\boldsymbol\tau=Y\boldsymbol\pi$。
- **三个数**：本节模型每组名义上 11 个惯性参数、加摩擦共 13 个；具体机构的独立参数组合可能更少。
- **一个用途**：线性最小二乘辨识 + 自适应控制。

::: think 常见错误清单
1. **把 $Y$ 当成常数矩阵**：$Y$ 依赖 $q,\dot q,\ddot q$，每次采样都要重算。
2. **以为 11 个参数都独立可辨识**：$Y$ 的列可能相关，实际最小参数集更小。
3. **混淆转子参数的分组**：转子 $i+1$ 的锁转质量和惯量并入扩展连杆 $i$；其自转附加项按本节约定归入第 $i+1$ 组。
4. **忘记摩擦与接触力的区别**：摩擦系数可并入参数向量；接触力须另行测量或建模，不能自动当成常惯性参数。
:::

::: think 默写点 · 合上书再写
1. 写出扩展连杆的 11 个参数，并说明每个的物理含义。
2. 说明为什么动能对参数是线性的（举两项为例）。
3. 写出 $\tau=Y\pi$ 的维度与 $Y$ 的依赖变量。
4. 参数辨识为什么能化成线性最小二乘？
:::

**下一节**：[6.3 两连杆动力学算例](sec6-3.md) 把本节与 6.1 的全部公式落到一台具体的两连杆臂上——位形相关的 $B$、非零的 $C$、重力项与回归矩阵都在那里第一次手算成型。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| $c_{ijk}=\frac12(\partial_k b_{ij}+\partial_j b_{ik}-\partial_i b_{jk})$ | Christoffel 选法 | — | 三项指标位置；$c_{ijk}=c_{ikj}$ |
| $N=\dot B-2C$，$N^{\mathrm T}=-N$，$\boldsymbol w^{\mathrm T}N\boldsymbol w=0$ | Christoffel 选法的 $C$ | — | (A) 对任意 $w$；(B) 只对 $w=\dot q$；(B) 不蕴含 (A) |
| $\boldsymbol\pi_i=[m_i,\ h_i^{\mathrm T},\ \widehat I_i\text{ 的 6 分量},\ I_{m_i}]^{\mathrm T}$（11 个） | 扩展连杆分组、轴对称转子 | kg、kg·m、kg·m² | 转子 $i+1$ 的锁转量归扩展连杆 $i$，自转项归第 $i$ 组 |
| $\boldsymbol\tau=Y(q,\dot q,\ddot q)\boldsymbol\pi$ | 无接触、摩擦并入参数 | N·m / N | $Y$ 每次采样重算；辨识须查满列秩与激励 |

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导与证明；下列课件页保留以备核对，**不构成正文的替代**（对应录播 01:22:30–01:54:30）。

| 时间点 | 幻灯片 | 提供了什么 | 本书如何处理 |
|:--|:--|:--|:--|
| 82:36 | [skew.jpg](../assets/ch06/skew.jpg) | $C$ 的一般元素与第一类 Christoffel 符号 | 完整推导给出，含 $C$ 不唯一的反例与重配对 |
| 86:30 | [christoffel.jpg](../assets/ch06/christoffel.jpg) | $N=\dot B-2C$ 反对称与 $w^{\mathrm T}Nw=0$ | 两种陈述 (A)/(B) 分清并分别证明 |
| 110:07 | [linearity-tau.jpg](../assets/ch06/linearity-tau.jpg) | 参数线性性——质量、一阶矩、惯性张量 | 扩展连杆推导完整给出，含边界项说明 |
| 95:15 | [linearity.jpg](../assets/ch06/linearity.jpg) | 扩展连杆动能与 11 个参数 | 参数表逐项读法完整给出 |
| 114:27 | [regressor.jpg](../assets/ch06/regressor.jpg) | $\tau=Y\pi$ 与回归矩阵 | 块上三角结构 + 实际辨识流程（6.2.2.5）完整给出 |
:::
