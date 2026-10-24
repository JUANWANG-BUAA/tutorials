# 习题集

本章按 A（概念判断 4）、B（分析证明 6）、C（计算编程 6）、D（开放研讨 4）分层收录 **20 框**，**全部附解答**（默认折叠）。与[作业六](homework06.md)（教材习题 7-2 / 7-6 / 7-7）不同，本页的 A / B / D 组是围绕本章正文编的**新增题**；C 组的数值均可由 `tools/verify_teaching_examples.py`（`make verify`）复核，两处不重复：作业六练「教材原题」，本页练「换条件迁移」。

::: method A / B 组的自评标准（C / D 组另给验收标准）

- **A 组（概念判断）**：达标要求是「**判对 + 说得出依据**」。本章 A 组的三条判断链是：「**能量法为什么不用画受力图**」「**只有 $C\dot q$ 唯一，$C$ 不唯一**」「**两种力矩不要混名**」。
- **B 组（分析证明）**：按「**思路 → 关键步 → 结论**」三步自评。本章证明题的判分点集中在：交叉项为什么恒为零；$S^{\mathrm T}S$ 怎么积出惯性张量；对称化那一步用在哪里；反对称的两种陈述谁蕴含谁。
- **通用扣分点**：把「重力项 $g$」与「实际重力广义力 $\tau_{\mathrm{grav}}$」混名；漏掉转子动能的 $k_r^2$；把 $\dot q^{\mathrm T}N\dot q=0$ 说成「$N$ 反对称」；把 11 / 13 / 最小参数集混用。

:::

## A 组 · 概念判断

::: ex A1 · 拉格朗日法省掉了什么

(a) 用拉格朗日法列方程时，关节反力与连杆内力为什么**不需要**出现在方程里？(b) 代价是什么——哪些力必须自己补到右端？(c) 势能零点选错了，运动方程会跟着错吗？

::: sol 解答

(a) 拉格朗日方程只用到标量 $L=T-U$；**理想约束力不做虚功**（关节反力沿约束方向、约束方向不允许虚位移），它们既不进 $T$ 也不进 $U$，因此被方程**自动排除**。约束越复杂（闭链、多点接触）这一优势越明显（[@def-6.1.1]、[6.1](sec6-1.md)）。

(b) **非保守力**必须作为广义力 $\xi_i$ 补到右端，共四件套：执行器力矩 $\tau_i$、粘滞摩擦 $F_{\mathrm v}\dot q_i$、库仑摩擦 $F_{\mathrm s}\operatorname{sgn}\dot q_i$、末端接触力 $-(J^{\mathrm T}h_e)_i$（[6.1.2 节](sec6-1.md)）。

(c) **不会**。势能加减一个**常数**只改 $L$ 的常数项，求偏导后为零，运动方程不变；会致命的是**非常数项**写错（例如把 $U=mgl(1-\cos\vartheta)$ 的 $\cos$ 写成 $\sin$）——那不是「零点选错」，是势能函数写错（[6.1.5 节](sec6-1.md)常见错误 2）。

:::

:::

::: ex A2 · 两种「重力矩」与末端力的方向

(a) 方程左端的 $\boldsymbol g(\boldsymbol q)$ 与「重力实际施加的广义力 $\boldsymbol\tau_{\mathrm{grav}}$」是什么关系？静止保持时电机该出多少？(b) $\boldsymbol h_e$ 指哪个力？若环境反推末端，方程右端怎么写？

::: sol 解答

(a) $\boldsymbol\tau_{\mathrm{grav}}=\sum_j\bigl(m_jJ_P^{(j)\mathrm T}\boldsymbol g_0+m_{m_j}J_P^{(m_j)\mathrm T}\boldsymbol g_0\bigr)
=-\dfrac{\partial U}{\partial\boldsymbol q}=-\boldsymbol g(\boldsymbol q)$——**方向相反，是一对不同的量**（[6.1.2.3 节](sec6-1-2.md)、勘误 E6.8）。本教程把重力移到左端，故静止、无摩擦无外力时 $\boldsymbol\tau=\boldsymbol g(\boldsymbol q)$：电机出的力矩与实际重力广义力等值反向（[@ex-6.1.2.A]）。

(b) 教材约定 $\boldsymbol h_e$ 是**末端执行器施加在环境上的力/力矩**。执行器要平衡它，方程写成 $\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e$；若改问「环境反作用在末端的力 $\boldsymbol f=-\boldsymbol h_e$」，则右端为 $+J^{\mathrm T}\boldsymbol f$——**先统一约定再代数，两种写法说的是同一件事**（[6.1.2 节符号约定](sec6-1.md)、[6.1.3 节](sec6-1-3.md)常见错误 4）。

:::

:::

::: ex A3 · $B$ 的性质与 $b_{ii}$ 的物理意义

(a) $B(\boldsymbol q)$ 的三条性质是什么？各自由什么保证？(b) $b_{ii}$ 是「连杆 $i$ 自己的惯量」吗？(c) $b_{ii}$ 里为什么总有 $k_{r_i}^2I_{m_i}$？

::: sol 解答

(a) **对称**（惯性张量与 $J^{\mathrm T}MJ$ 型乘积都对称）；**正定**（$\dot q^{\mathrm T}B\dot q=2T>0$，$\dot q\neq0$）；**一般随位形变**（质心位置与雅可比都是 $q$ 的函数），只有笛卡儿臂这类结构才是常数（[6.1.1.5 节](sec6-1-1.md)）。

(b) **不是**。$b_{ii}$ 是「**锁住其他关节**时关节 $i$ 看到的等效惯量」：取 $\dot{\boldsymbol q}=e_i$，则 $T=\frac12b_{ii}$——而锁住其他关节后，关节 $i$ 之后的**所有**连杆都被带着一起动，所以 $b_{ii}$ 含的是「该轴之后的全部质量」折算到该轴的惯量（[6.1.3.4 节](sec6-1-3.md) note）。$b_{22}$ 是唯一的例外情形（平面臂中关节 2 之后只剩连杆 2）。

(c) 转子经减速比 $k_{r_i}$ 驱动关节 $i$，其**总**角速度含 $k_{r_i}\dot q_i$，动能 $\frac12I_{m_i}\omega_m^2$ 里出现 $k_{r_i}^2$——**平方来自角速度折算，不是来自力矩折算**（大减速比时这一项常是 $b_{ii}$ 的主导项，见 C1）。

:::

:::

::: ex A4 · $C$ 的唯一性与参数计数

(a) 运动方程对 $C$ 的要求是什么？为什么满足它的 $C$ 有无穷多个？(b) 「每个关节 13 个参数」与「平面臂 8 个参数」矛盾吗？(c) $\tau=Y\pi$ 中 $Y$ 与 $\pi$ 各是什么、依赖什么？

::: sol 解答

(a) 只要求 $\sum_jc_{ij}\dot q_j=\sum_{j,k}h_{ijk}\dot q_k\dot q_j$——这是对**乘积 $C\dot q$** 的要求。往 $C$ 里加任何「乘 $\dot q$ 为零」的矩阵（如反对称阵），方程不变，故 **$C$ 不唯一，只有 $C\dot q$ 唯一**（[6.2.1.1 节](sec6-2-1.md)）。

(b) **不矛盾**，这是三层口径（勘误 E6.6）：**11** = 每连杆刚体惯性参数（质量 1 + 一阶矩 3 + 张量 6 + 转子惯量 1）；**13** = 无接触力时再加两摩擦系数；**最小参数集** ≤ 13n——$Y$ 的零列与相关列让一部分参数无法独立辨识，平面臂把 25 个名义参数压到 8 个、进一步可压到 5 个（[6.2.2.4 节](sec6-2-2.md)）。

(c) $\boldsymbol\pi$ 是 $p\times1$ 的**常参数向量**（不随时间变）；$Y$ 是 $n\times p$ 的**回归矩阵**，元素只含 $q,\dot q,\ddot q$（每次采样都要重算）。线性性 ⇒ 辨识是**线性最小二乘**，这是它最大的用处（[6.2.2.3 节](sec6-2-2.md)）。

:::

:::

## B 组 · 分析证明

::: ex B1 · 交叉项为什么恒为零

从 $T_i=\frac12\int\dot{\boldsymbol p}_i^{*\mathrm T}\dot{\boldsymbol p}_i^*\,\rho\,\mathrm dV$ 与 $\dot{\boldsymbol p}_i^*=\dot{\boldsymbol p}_i+S(\boldsymbol\omega_i)\boldsymbol r_i$ 出发，写出交叉项并证明它为零；说明这一步对「动能分成三块」的意义。

::: sol 解答

**思路**：交叉项是「平动速度 × 转动速度」，先把它写成对体积的积分，再用质心定义。

1. 展开被积函数：$\dot{\boldsymbol p}_i^{*\mathrm T}\dot{\boldsymbol p}_i^*
=\dot{\boldsymbol p}_i^{\mathrm T}\dot{\boldsymbol p}_i
+2\dot{\boldsymbol p}_i^{\mathrm T}S(\boldsymbol\omega_i)\boldsymbol r_i
+\boldsymbol r_i^{\mathrm T}S^{\mathrm T}(\boldsymbol\omega_i)S(\boldsymbol\omega_i)\boldsymbol r_i$。
2. 交叉项积分：$\int_{V_i}\dot{\boldsymbol p}_i^{\mathrm T}S(\boldsymbol\omega_i)\boldsymbol r_i\,\rho\,\mathrm dV
=\dot{\boldsymbol p}_i^{\mathrm T}S(\boldsymbol\omega_i)\underbrace{\int_{V_i}(\boldsymbol p_i^*-\boldsymbol p_i)\rho\,\mathrm dV}_{=\,0}$。
3. 由**质心定义** $\boldsymbol p_i=\frac{1}{m_i}\int\boldsymbol p_i^*\rho\,\mathrm dV$ 知括号内积分为零——注意 $\dot{\boldsymbol p}_i$ 与 $S(\boldsymbol\omega_i)$ 只依赖关节变量、与微元无关，可以提到积分号外，这一步**必须先做**。

**意义**：若不取质心系，动能里会多出「平动 × 转动」的耦合积分，每个微元都要算；质心定义让这一项**恒等于零**，$T_i$ 才干净地分成 $\frac12m_i\dot p_i^{\mathrm T}\dot p_i+\frac12\omega_i^{\mathrm T}I_i\omega_i$ 两块，后面才能逐块写成「雅可比 × 参数 × 雅可比$^{\mathrm T}$」（[6.1.1.2 节](sec6-1-1.md)）。

:::

:::

::: ex B2 · 从叉乘矩阵到惯性张量

证明 $S^{\mathrm T}(\boldsymbol r)S(\boldsymbol r)=(\boldsymbol r^{\mathrm T}\boldsymbol r)I_3-\boldsymbol r\boldsymbol r^{\mathrm T}$，并由此说明惯性张量的对角元是「绕轴转动惯量」、非对角元是「惯性积的负值」、$I_i$ 对称。

::: sol 解答

**思路**：直接展开 $3\times3$ 乘法，认出二次型。

1. 任取向量 $\boldsymbol a$：$\boldsymbol a^{\mathrm T}S^{\mathrm T}(\boldsymbol r)S(\boldsymbol r)\boldsymbol a=\|S(\boldsymbol r)\boldsymbol a\|^2=\|\boldsymbol r\times\boldsymbol a\|^2$。由拉格朗日恒等式 $\|\boldsymbol r\times\boldsymbol a\|^2=\|\boldsymbol r\|^2\|\boldsymbol a\|^2-(\boldsymbol r^{\mathrm T}\boldsymbol a)^2=\boldsymbol a^{\mathrm T}\bigl[(\boldsymbol r^{\mathrm T}\boldsymbol r)I_3-\boldsymbol r\boldsymbol r^{\mathrm T}\bigr]\boldsymbol a$；由 $\boldsymbol a$ 任意，矩阵恒等式得证。
2. 展开对角元：$I_{xx}=\int(r_y^2+r_z^2)\rho\,\mathrm dV$——正是「点到 $x$ 轴距离平方」的积分，即**绕 $x$ 轴的转动惯量**；$I_{xy}=-\int r_xr_y\rho\,\mathrm dV$ 是**惯性积的负值**。
3. **对称性**：由恒等式右端 $(\boldsymbol r^{\mathrm T}\boldsymbol r)I_3$（对角）$-\boldsymbol r\boldsymbol r^{\mathrm T}$（对称），积分后仍对称——所以 9 个元素只有 **6 个独立分量**，这正是参数表里惯性张量占 6 个参数的原因（[6.1.1.2 节](sec6-1-1.md)、[6.2.2.2 节](sec6-2-2.md)）。

:::

:::

::: ex B3 · 平行轴定理

证明：若惯性张量 $\boldsymbol I_C$ 相对质心 $C$，则相对平移后的参考点 $O$（$\boldsymbol p_C$ 为 $C$ 相对 $O$ 的矢径）有
$\boldsymbol I_O=\boldsymbol I_C+m\,S^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C)$。并用「质量为 $m$ 的质点挂在距轴 $d$ 处」检验公式。

::: sol 解答

**思路**：换参考点后每个微元的矢径平移 $\boldsymbol p_C$，代入定义再拆项。

1. 微元相对 $O$ 的矢径 $\boldsymbol r'=\boldsymbol r+\boldsymbol p_C$（$\boldsymbol r$ 相对质心）。代入 B2 的恒等式：
   $$\boldsymbol I_O=\int\bigl[(\boldsymbol r'^{\mathrm T}\boldsymbol r')I_3-\boldsymbol r'\boldsymbol r'^{\mathrm T}\bigr]\rho\,\mathrm dV.$$
2. 展开三类项：$\int\boldsymbol r\rho\,\mathrm dV=\boldsymbol 0$（质心定义）使全部「质心 × 平移」交叉项消失；剩下
   $$\boldsymbol I_O=\underbrace{\int\bigl[(\boldsymbol r^{\mathrm T}\boldsymbol r)I_3-\boldsymbol r\boldsymbol r^{\mathrm T}\bigr]\rho\,\mathrm dV}_{=\,\boldsymbol I_C}
   +\underbrace{\int\bigl[(\boldsymbol p_C^{\mathrm T}\boldsymbol p_C)I_3-\boldsymbol p_C\boldsymbol p_C^{\mathrm T}\bigr]\rho\,\mathrm dV}_{=\,m\left[(\boldsymbol p_C^{\mathrm T}\boldsymbol p_C)I_3-\boldsymbol p_C\boldsymbol p_C^{\mathrm T}\right]}.$$
3. 由 B2 的恒等式，第二个括号正是 $m\,S^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C)$。$\blacksquare$
4. **质点检验**：质点情形 $\boldsymbol I_C=0$，取轴过 $O$ 垂直于 $\boldsymbol p_C$，则 $S^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C)$ 在该轴上的分量是 $\|\boldsymbol p_C\|^2=d^2$，得 $I_O=md^2$——与初等结果一致，且**垂直于 $\boldsymbol p_C$ 的另一条轴同样得 $md^2$、沿 $\boldsymbol p_C$ 的轴得 $0$**（质点在轴上不抵抗绕轴转动），三条都对上才算证对。

**用途**：把 CAD 给出的「绕连杆质心」的张量搬到「绕关节轴」，或把连杆与装在同杆上的转子合并成扩展连杆（[6.1.1.2 节](sec6-1-1.md) note、[6.2.2.1 节](sec6-2-2.md)）。

:::

:::

::: ex B4 · 从 $h_{ijk}$ 到 Christoffel 符号

由 $h_{ijk}=\dfrac{\partial b_{ij}}{\partial q_k}-\dfrac12\dfrac{\partial b_{jk}}{\partial q_i}$ 与「$C\dot q$ 唯一」的要求，导出
$c_{ijk}=\dfrac12\Bigl(\dfrac{\partial b_{ij}}{\partial q_k}+\dfrac{\partial b_{ik}}{\partial q_j}-\dfrac{\partial b_{jk}}{\partial q_i}\Bigr)$，并证明 $c_{ijk}=c_{ikj}$。

::: sol 解答

**思路**：$h_{ijk}\dot q_k\dot q_j$ 对 $j,k$ 求和时 $\dot q_j\dot q_k$ 对称，把不对称的第一项「对半拆开再交换指标」。

1. 求和项 $\sum_{j,k}\frac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j$ 中把 $(j,k)$ 换名（哑指标）得 $\sum_{j,k}\frac{\partial b_{ik}}{\partial q_j}\dot q_j\dot q_k$，两者相等，故
   $$\sum_{j,k}\frac{\partial b_{ij}}{\partial q_k}\dot q_k\dot q_j
   =\frac12\sum_{j,k}\Bigl(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}\Bigr)\dot q_k\dot q_j.$$
2. 减去 $\frac12\sum_{j,k}\frac{\partial b_{jk}}{\partial q_i}\dot q_k\dot q_j$ 并比较系数，得 $c_{ijk}$ 的表达式——**注意第 2、3 项的指标位置**：$\partial_j b_{ik}$ 与 $\partial_i b_{jk}$，写反了 $C$ 就不满足 (7.43)。
3. 交换 $j\leftrightarrow k$：$c_{ikj}=\frac12\bigl(\frac{\partial b_{ik}}{\partial q_j}+\frac{\partial b_{ij}}{\partial q_k}-\frac{\partial b_{kj}}{\partial q_i}\bigr)$；由 $B$ 对称 $b_{jk}=b_{kj}$，第三项与原式相同，前两项求和可交换，故 $c_{ijk}=c_{ikj}$。

**为什么必须对称化**：$h_{ijk}$ 本身**不**满足这个对称性（$h_{ijk}$ 只保证 $C\dot q$ 正确）；正是把 $\dot q_j\dot q_k$ 的对称性「用足」，才选出使 $\dot B-2C$ 反对称的那一组 $C$（[6.2.1.1 节](sec6-2-1.md)、作业六 7-2 的「另一种 $C$」就是不做这一步的反例）。

:::

:::

::: ex B5 · 两种反对称陈述：谁蕴含谁

设 $N=\dot B-2C$（$C$ 为满足 (7.43) 的**任意**选法）。(a) 证明：若 $N$ 反对称，则 $\boldsymbol w^{\mathrm T}N\boldsymbol w=0$ 对**任意** $\boldsymbol w$ 成立。(b) 用作业六 7-2 的 $C_{\text{alt}}$（平面臂，例 7.2 数据，$\vartheta_2=\pi/6$，$\dot{\boldsymbol q}=(0.3,0.4)^{\mathrm T}$）验证：$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$ 但 $\boldsymbol w=(1,0)^{\mathrm T}$ 时 $\boldsymbol w^{\mathrm T}N\boldsymbol w\neq0$——即 (B) 不蕴含 (A)。

::: sol 解答

(a) 标量的转置等于自身：$\boldsymbol w^{\mathrm T}N\boldsymbol w=(\boldsymbol w^{\mathrm T}N\boldsymbol w)^{\mathrm T}
=\boldsymbol w^{\mathrm T}N^{\mathrm T}\boldsymbol w=-\boldsymbol w^{\mathrm T}N\boldsymbol w$，故为零。这只用到「反对称」，与 $C$ 怎么选无关。

(b) 取 $h=-m_2a_1\ell_2s_2=-25\times0.5=-12.5$（例 7.2 数据 $m_2a_1\ell_2=25$、$s_2=\frac12$）。由作业六 7-2，

$$N=\begin{bmatrix}-2h\dot\vartheta_2&-h\dot\vartheta_2\\2h\dot\vartheta_1&h\dot\vartheta_1\end{bmatrix}
=\begin{bmatrix}10&5\\-7.5&-3.75\end{bmatrix}.$$

- **(B) 成立**：$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}
=0.09\times10+0.12\times(5-7.5)+0.16\times(-3.75)
=0.9-0.3-0.6=0$。
- **(A) 失败**：$\boldsymbol w^{\mathrm T}N\boldsymbol w=N_{11}=10\neq0$；且 $N_{12}=5\neq-N_{21}=7.5$，$N$ 连反对称都不是。

**结论**：(A) $\Rightarrow$ (B) 平凡成立；(B) $\nRightarrow$ (A)，因为 $N$ 还依赖 $\dot{\boldsymbol q}$，「沿系统自己的速度方向不做功」推不出「对所有方向不做功」。前者是能量守恒的物理事实，后者是 Christoffel 选法的代数构造（[@thm-6.2.1]、勘误 E6.7）。本题数值由 `tools/verify_teaching_examples.py` 复核。

:::

:::

::: ex B6 · $B$ 正定与「锁住」解读

(a) 证明 $B(\boldsymbol q)$ 正定（$\dot{\boldsymbol q}\neq0$）。(b) 由此说明 $b_{ii}$ 的「锁住其他关节」解读，并解释为什么 $b_{ii}$ 含关节 $i$ 之后**所有**连杆的贡献。

::: sol 解答

(a) 动能对任何非零速度都为正：$T=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}>0$（刚性系统不储存负能量；各连杆与转子的动能项 $\frac12m\|\dot p\|^2,\frac12\omega^{\mathrm T}I\omega$ 均非负，且 $\dot{\boldsymbol q}\neq0$ 时至少有一个连杆在动）。这正是对称矩阵正定的定义。

(b) 取 $\dot{\boldsymbol q}=e_i$（只让关节 $i$ 以单位速度运动）：$T=\frac12e_i^{\mathrm T}Be_i=\frac12b_{ii}$。此时**其他关节锁死**，关节 $i$ 之后的连杆通过运动链被**刚性带动**——它们的质量、质心速度与角速度全部由 $\dot q_i$ 决定，因此它们的动能全部计入 $\frac12b_{ii}$。这就是「$b_{ii}$ = 关节 $i$ 看到的、其下游全部惯量」的根据；也解释了为什么平面臂的 $b_{22}=I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}$ **与 $\vartheta_1$ 无关**——关节 2 之后没有别的连杆了（[6.1.3.4 节](sec6-1-3.md) note、[6.3.2.3 节](sec6-3-2.md)）。

:::

:::

## C 组 · 计算编程

::: ex C1 · 带齿轮的摆：完整逆动力学（例 7.1 模板）

某摆：连杆绕 $O$ 的转动惯量 $I=0.6\ \mathrm{kg\cdot m^2}$，转子 $I_m=2\times10^{-3}\ \mathrm{kg\cdot m^2}$、减速比 $k_r=100$；关节摩擦 $F=0.1$、转子摩擦 $F_m=1\times10^{-3}\ \mathrm{N\cdot m\cdot s/rad}$；质量 $m=1.2\ \mathrm{kg}$、质心距 $l=0.35\ \mathrm m$。(a) 写出 $B_{\mathrm{eq}}$ 与 $F_{\mathrm{eq}}$，并算转子项在 $B_{\mathrm{eq}}$ 中的占比；(b) 求 $\vartheta=\pi/3$ 处静止保持的力矩；(c) 同位形要求 $\ddot\vartheta=1\ \mathrm{rad/s^2}$、$\dot\vartheta=0.5\ \mathrm{rad/s}$ 的力矩。

::: sol 解答

(a) $B_{\mathrm{eq}}=I+I_mk_r^2=0.6+0.002\times10^4=20.6\ \mathrm{kg\cdot m^2}$；
$F_{\mathrm{eq}}=F+F_mk_r^2=0.1+0.001\times10^4=10.1\ \mathrm{N\cdot m\cdot s/rad}$。
**占比** $=\dfrac{20}{20.6}=97.1\%$——大减速比下**转子惯量主导**，这正是第 5 章「折算」视角的动力学版本。

(b) $g(\vartheta)=mgl\sin\vartheta=1.2\times9.81\times0.35\times\sin\frac\pi3=3.568\ \mathrm{N\cdot m}$；
保持（$\ddot\vartheta=\dot\vartheta=0$）：$\tau=g=3.568\ \mathrm{N\cdot m}$。

(c) $\tau=B_{\mathrm{eq}}\ddot\vartheta+F_{\mathrm{eq}}\dot\vartheta+g(\vartheta)
=20.6\times1+10.1\times0.5+3.568=29.218\ \mathrm{N\cdot m}$。
其中 3.568 平衡重力、20.6 用于加速、5.05 克服摩擦——**三项各有名字，别合并成「一个系数」**。

```python
I, Im, kr, F, Fm, m, l = 0.6, 2e-3, 100, 0.1, 1e-3, 1.2, 0.35
B, Feq = I + Im*kr**2, F + Fm*kr**2
g = m*9.81*l*math.sin(math.pi/3)      # 3.5682
print(B, Feq, 20/B, g, B*1 + Feq*0.5 + g)   # 20.6 10.1 0.9709 3.5682 29.2182
```

:::

:::

::: ex C2 · 平面臂：$B,C,\boldsymbol g$ 数值代入并验证反对称

取例 7.2 数据（$a_1=a_2=1$、$\ell_1=\ell_2=0.5$、$m_1=m_2=50$、$I_1=I_2=10$、$k_{r_1}=k_{r_2}=100$、$m_{m_1}=m_{m_2}=5$、$I_{m_1}=I_{m_2}=0.01$），位形 $\vartheta_1=\pi/4$、$\vartheta_2=-\pi/6$，速度 $\dot\vartheta_1=0.5$、$\dot\vartheta_2=-0.25\ \mathrm{rad/s}$，$\ddot{\boldsymbol q}=\boldsymbol0$。(a) 算 $h$、$B$、$C$、$C\dot{\boldsymbol q}$、$\boldsymbol g$；(b) 写出 $N=\dot B-2C$ 并验证反对称；(c) 求此时的 $\boldsymbol\tau$。

::: sol 解答

(a) $h=-m_2a_1\ell_2s_2=-25\times\sin(-\pi/6)=12.5$。

$$B=\begin{bmatrix}243.311&45.151\\45.151&122.5\end{bmatrix}\ \mathrm{kg\cdot m^2},\qquad
C=\begin{bmatrix}-3.125&3.125\\-6.25&0\end{bmatrix},\qquad
C\dot{\boldsymbol q}=\begin{bmatrix}-2.344\\-3.125\end{bmatrix}\ \mathrm{N\cdot m}.$$

（$C\dot q_1=h(2\dot\vartheta_1\dot\vartheta_2+\dot\vartheta_2^2)=12.5\times(-0.1875)=-2.344$。）

$$g_1=(m_1\ell_1+m_{m_2}a_1+m_2a_1)g\,c_1+m_2\ell_2g\,c_{12}
=784.8\times0.7071+245.25\times0.9659=791.831,$$
$$g_2=245.25\times0.9659=236.893\ \mathrm{N\cdot m}.$$

(b) 先算 $\dot B$（$h\dot\vartheta_2=-3.125$）：

$$\dot B=\begin{bmatrix}2h\dot\vartheta_2&h\dot\vartheta_2\\h\dot\vartheta_2&0\end{bmatrix}
=\begin{bmatrix}-6.25&-3.125\\-3.125&0\end{bmatrix},$$

故

$$N=\dot B-2C=\begin{bmatrix}0&-9.375\\9.375&0\end{bmatrix}\quad\checkmark\ \text{反对称}.$$

(c) $\boldsymbol\tau=C\dot{\boldsymbol q}+\boldsymbol g=(789.487,\ 233.768)^{\mathrm T}\ \mathrm{N\cdot m}$。

**回读一句**：$b_{11}$ 里 $k_{r_1}^2I_{m_1}=100$ 只占四成——本题减速比虽大，但连杆质量项更大；换小臂数据结论会反（见 C1 的 97%）。数值由 `tools/verify_teaching_examples.py` 复核。

:::

:::

::: ex C3 · 笛卡儿臂的轴不正交：耦合从哪来（习题 7.1 的思想）

两移动关节：关节 1 沿 $z_0$（竖直），关节 2 沿与 $z_0$ 成 $\alpha$ 角的方向（在 $x$–$z$ 平面内）。$m_1=3$、$m_2=2$、$m_{m_2}=0.5\ \mathrm{kg}$，$k_{r_1}^2I_{m_1}=0.8$、$k_{r_2}^2I_{m_2}=0.4\ \mathrm{kg\cdot m^2}$；转子 2 质心随关节 1 移动（标准简化）。(a) 写出 $B(\alpha)$；(b) 取 $\alpha=\pi/4$，求 $\ddot d_1=0.5$、$\ddot d_2=1\ \mathrm{m/s^2}$（启动，$\dot d=0$）时的 $\tau_1$，并与 $\alpha=\pi/2$（解耦）比较；(c) 验证 $B$ 正定。

::: sol 解答

(a) $J_P^{(1)}=\hat z$、$J_P^{(2)}=\hat u(\alpha)=[\sin\alpha,0,\cos\alpha]^{\mathrm T}$，转子 2 的平动雅可比为 $\hat z$、转动雅可比 $k_{r_2}\hat u$，故

$$B(\alpha)=\begin{bmatrix}m_1+m_{m_2}+m_2+k_{r_1}^2I_{m_1} & m_2\cos\alpha\\ m_2\cos\alpha & m_2+k_{r_2}^2I_{m_2}\end{bmatrix}
=\begin{bmatrix}6.3 & 2\cos\alpha\\ 2\cos\alpha & 2.4\end{bmatrix}.$$

$\alpha=90^\circ$ 时非对角元为零，退回 [6.3.1](sec6-3-1.md) 的常数对角 $B$——**「解耦」= 笛卡儿结构 + 轴正交，缺一不可**。

(b) $\alpha=\pi/4$：$\tau_1=6.3\times0.5+2\cos45^\circ\times1+g_1
=3.15+1.414+53.955=58.519\ \mathrm N$；
$\alpha=\pi/2$：$\tau_1=3.15+53.955=57.105\ \mathrm N$。**差值 $1.414\ \mathrm N$ 全部来自耦合项** $m_2\cos\alpha\,\ddot d_2$——关节 2 加速时把连杆 2 沿 $\hat z$ 方向「拽」了一下。

(c) $\det B=6.3\times2.4-2\cos^2\alpha=13.12>0$ 且对角元为正 ⇒ 正定（也可算特征值 $0.202$ 与 $8.498$）。物理上：两个方向都能自由加速，动能恒正。

:::

:::

::: ex C4 · 平面臂逆动力学：加速项怎么进来

在 C2 的状态上（$\vartheta_1=\pi/4$、$\vartheta_2=-\pi/6$、$\dot\vartheta_1=0.5$、$\dot\vartheta_2=-0.25$），要求 $\ddot\vartheta_1=0.2$、$\ddot\vartheta_2=0.4\ \mathrm{rad/s^2}$。求 $\boldsymbol\tau$，并把三项（惯性、速度耦合、重力）各自对 $\tau_1$ 的贡献分开列出。

::: sol 解答

$$\boldsymbol\tau=B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g.$$

$\tau_1$ 的三项拆账：

| 来源 | 计算 | 数值 (N·m) |
|:--|:--|--:|
| 惯性 $B\ddot q$ | $243.311\times0.2+45.151\times0.4$ | $66.723$ |
| 速度耦合 $C\dot q$ | $h(2\dot\vartheta_1\dot\vartheta_2+\dot\vartheta_2^2)$ | $-2.344$ |
| 重力 $g_1$ | — | $791.831$ |
| **合计** | | **$856.209$** |

$\tau_2=45.151\times0.2+122.5\times0.4-3.125+236.893=291.798\ \mathrm{N\cdot m}$
（惯性 $58.030$、耦合 $-3.125$、重力 $236.893$）。

**注意两点**：速度耦合项在当前位形为**负**（它「帮」关节 1 出力）；重力项仍是 $\tau_1$ 的主导——
平面臂在这个位形接近「托举」姿态。若把 $\ddot{\boldsymbol q}$ 置零，得 C2 的静态答案，两条结果相差
$(66.723-2.344,\ 58.030-3.125)$——**静止解与加速解之间没有「比例关系」**，必须重算。

:::

:::

::: ex C5 · 用 $\tau=Y\pi$ 做一次最小二乘辨识

单摆模型 $\tau=\pi_1\ddot q+\pi_2\sin q$（回归矩阵 $Y$ 每行为 $[\ddot q,\ \sin q]$）。取三组采样：

| 组 | $\ddot q$ | $\sin q$ | $\tau$ (N·m) |
|:--|--:|--:|--:|
| 1 | $1.0$ | $0.5$ | $2.762$ |
| 2 | $2.0$ | $1.0$ | $5.524$ |
| 3 | $0.5$ | $\sqrt2/2$ | $3.1747$ |

(a) 写出超定方程 $Y\boldsymbol\pi=\boldsymbol\tau$ 并用正规方程解最小二乘；(b) 验证解出的 $\boldsymbol\pi$ 恰为真值 $\boldsymbol\pi=(I+I_mk_r^2,\ mgl)^{\mathrm T}$ 的哪一组（取 $I+I_mk_r^2=0.8\ \mathrm{kg\cdot m^2}$、$m=1\ \mathrm{kg}$、$l=0.4\ \mathrm m$）；(c) 若激励只取 $\sin q\equiv0$（水平面内摆动），还能辨识出两个参数吗？

::: sol 解答

(a) $Y=\begin{bmatrix}1&0.5\\2&1\\0.5&0.7071\end{bmatrix}$，$\boldsymbol\tau=(2.762,\ 5.524,\ 3.1747)^{\mathrm T}$。正规方程 $(Y^{\mathrm T}Y)\hat{\boldsymbol\pi}=Y^{\mathrm T}\boldsymbol\tau$：

$$Y^{\mathrm T}Y=\begin{bmatrix}5.25&2.8536\\2.8536&1.75\end{bmatrix},\qquad
Y^{\mathrm T}\boldsymbol\tau=\begin{bmatrix}15.3973\\9.1498\end{bmatrix}
\ \Longrightarrow\ \hat{\boldsymbol\pi}=(0.8000,\ 3.9240)^{\mathrm T}.$$

(b) 真值：$\pi_1=0.8$；$\pi_2=mgl=1\times9.81\times0.4=3.924$。**精确复原**——因为数据本身由该模型生成（相容超定方程）；实测数据有噪声时，$\hat{\boldsymbol\pi}$ 是最小方差意义下的最优线性无偏估计（高斯–马尔可夫，课程不展开）。

(c) **不能**。$\sin q\equiv0$ 时 $Y$ 的第二列恒为零，$\pi_2$ 根本不进入方程——对应正文说的「$Y$ 的零列直接告诉你哪些参数不可辨识」。所以激励轨迹必须让**每一列**都被「激活」（[6.2.2.4 节](sec6-2-2.md)、D2）。

```python
import numpy as np
Y = np.array([[1.0, 0.5], [2.0, 1.0], [0.5, math.sqrt(2)/2]])
tau = np.array([0.8*1 + 3.924*0.5, 0.8*2 + 3.924*1, 0.8*0.5 + 3.924*math.sqrt(2)/2])
print(np.linalg.solve(Y.T @ Y, Y.T @ tau))   # [0.8 3.924]
```

:::

:::

::: ex C6 · 能量核对：两条路径算动能变化率

仍用 C2 的状态与例 7.2 数据（$\ddot{\boldsymbol q}=\boldsymbol0$，$\boldsymbol\tau=C\dot{\boldsymbol q}+\boldsymbol g$）。用**两条独立路径**计算 $\frac12\dfrac{\mathrm d}{\mathrm dt}\bigl(\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}\bigr)$ 并核对相等。

::: sol 解答

**路径一（直接微分）**：$\dot{\boldsymbol q}$ 为常向量、$\ddot{\boldsymbol q}=0$ 时
$\frac12\dfrac{\mathrm d}{\mathrm dt}(\dot q^{\mathrm T}B\dot q)=\frac12\dot{\boldsymbol q}^{\mathrm T}\dot B\,\dot{\boldsymbol q}$。
由 C2，$\dot B=\begin{bmatrix}-6.25&-3.125\\-3.125&0\end{bmatrix}$：

$$\frac12\dot q^{\mathrm T}\dot B\dot q=\frac12\bigl[0.25\times(-6.25)+2\times0.5\times(-0.25)\times(-3.125)\bigr]
=\frac12(-1.5625+0.78125)=-0.3906\ \mathrm W.$$

**路径二（功率平衡）**：无摩擦无末端力时 $\frac12\dfrac{\mathrm d}{\mathrm dt}(\dot q^{\mathrm T}B\dot q)=\dot{\boldsymbol q}^{\mathrm T}(\boldsymbol\tau-\boldsymbol g)=\dot{\boldsymbol q}^{\mathrm T}C\dot{\boldsymbol q}$：

$$\dot q^{\mathrm T}(C\dot q)=0.5\times(-2.34375)+(-0.25)\times(-3.125)=-0.3906\ \mathrm W.\quad\checkmark$$

两条路径差一项 $\frac12\dot q^{\mathrm T}(\dot B-2C)\dot q$，它恒为零——**这正是 (7.49) 的数值显形**：惯性/科氏项在系统自己的速度方向上不做净功，能量只在关节之间搬运（[6.2.1.3 节](sec6-2-1.md)、B5）。数值由 `tools/verify_teaching_examples.py` 复核。

:::

:::

## D 组 · 开放研讨

::: ex D1 · 混合动力学模型：物理先验和学习项怎么分工

老师在开场的「AI 困境」幻灯片里给了 $\dot x=f_{\text{physics}}(x,u)+f_{\text{learned}}(x,u)$（[章导览](overview.md)）。写 500 字以内：$f_{\text{physics}}$ 与 $f_{\text{learned}}$ 各擅长什么？本章的拉格朗日模型在混合框架里能扮演哪三种角色？什么情形下「纯学习」会失败而「先验 + 残差」能成功？

::: sol 解答要点（开放题，按判据给分）

- **分工**：$f_{\text{physics}}$ 擅长**有明确守恒律与几何结构**的部分（惯性耦合、重力、能量守恒——外推到没见过的状态也符合物理）；$f_{\text{learned}}$ 擅长**难以显式建模**的部分（摩擦的真实形状、间隙、柔性、电机死区）。
- **拉格朗日模型的三种角色**：① **先验**——给学习器一个已满足 $\dot B-2C$ 反对称、对参数线性的底座，学习只需补残差；② **约束**——用能量平衡给预测加硬约束，防止外推时输出违反物理；③ **可解释基线**——残差的大小直接指认「模型没覆盖的物理」，比端到端黑箱多一层诊断。
- **纯学习失败 / 先验成功**的典型情形：**数据没覆盖的位形**（学习器在训练分布外乱猜，而 $B\ddot q+C\dot q+g$ 处处成立）；**需要外推的参数变化**（负载变了，$Y\pi$ 只需更新 $\pi$，网络要重训）。**判据**：能否写出守恒律、参数是否线性——这两条正是本章两条结构性质的价值。要求引用正文的「显式模型 vs 隐式模型」对照与 $N$ 反对称、$Y\pi$ 线性两条性质。

:::

:::

::: ex D2 · 激励轨迹设计：哪些参数辨识不到

对两连杆平面臂做参数辨识（8 参数模型）。有同学设计的激励轨迹是「锁住 $\vartheta_1$，只让 $\vartheta_2$ 摆动」。(a) 用 $B,\boldsymbol g$ 的结构说明哪些参数进不了方程；(b) 设计一条能激活全部 8 个参数的轨迹应满足什么条件；(c) 为什么工程上还要限制速度/加速度（既然越激烈列越满）？

::: sol 解答要点（开放题，按判据给分）

(a) $\vartheta_1\equiv\vartheta_0$（常数）时：$b_{11},b_{12}$ 仍随 $\vartheta_2$ 变（好），但 $\boldsymbol g_1$ 的 $(m_1\ell_1+m_{m_2}a_1+m_2a_1)g\cos\vartheta_0$ 变成**常数偏置**——$\pi_2=m_1(\ell_1-a_1)$ 与重力相关的组合无法与其他常数项分离；$\cos(\vartheta_0+\vartheta_2)$ 项虽在，但 $\vartheta_0$ 固定让「$\vartheta_1$ 单独驱动的系数」整列消失（$Y$ 的对应列与常数列线性相关）。结论：**$\pi_2$（以及与它共线的组合）辨识不到**。
(b) 条件：激励轨迹应使回归矩阵 $Y$ 满秩（**持续激励**条件）——$\vartheta_1$ 与 $\vartheta_2$ 都要运动、相位要错开、要经过重力力臂最大/最小的位形（让 $\cos$ 项变化）。
(c) 实机限制：速度/加速度上限（执行器饱和、安全）、采样率与量化（太快的瞬态采不满）、摩擦模型在高速段的失真。**工程折中**：在可达的激励谱内做优化（如条件数最小化），而不是「越猛越好」。
**判据**：(a) 要引用 $b_{11},b_{12},g_1$ 的具体表达式；(c) 要给出至少两条非「想当然」的物理限制。

:::

:::

::: ex D3 · 直驱（$k_r=1$）时平面臂的耦合项还剩多少

取 $k_{r_1}=k_{r_2}=1$、$I_{m_1}=I_{m_2}=0.01$（其余同例 7.2）。(a) 写出此时 $b_{11},b_{12},b_{22}$；(b) 与 $k_r=100$ 相比，非对角耦合项 $k_{r_2}I_{m_2}$ 与对角转子项 $k_{r_2}^2I_{m_2}$ 各怎么变？(c) 结合第 5 章直驱的结论，说明「直驱的代价」在动力学方程里具体是哪几项。

::: sol 解答要点

(a) $b_{11}=I_1+m_1\ell_1^2+I_{m_1}+I_2+m_2(a_1^2+\ell_2^2+2a_1\ell_2c_2)+I_{m_2}+m_{m_2}a_1^2$（$k_{r_1}^2I_{m_1}\to I_{m_1}$）；
$b_{12}=I_2+m_2(\ell_2^2+a_1\ell_2c_2)+I_{m_2}$（$k_{r_2}I_{m_2}\to I_{m_2}$）；
$b_{22}=I_2+m_2\ell_2^2+I_{m_2}$。
(b) 对角转子项从 $k_r^2I_m=100$ **掉到** $I_m=0.01$（缩小 $10^4$ 倍）；非对角的 $k_{r_2}I_{m_2}$ 从 $1$ **掉到** $0.01$（缩小 $10^2$ 倍）——但**相对占比反而变大**：$b_{12}$ 里转子项的权重从 $1/45.15\approx2.2\%$ 升到 $0.01/35.15\approx0.03\%$？注意 $b_{12}$ 的主项也变了——请实际算一遍再下结论（这正是本题想训练的「先算再判断」）。
(c) 直驱时**没有** $1/k_r$、$1/k_r^2$ 的折算保护：关节间耦合项（$b_{12}\ddot\vartheta_2$、$C\dot q$、重力）以**全幅值**出现在电机轴上，「无法忽略非线性耦合项」——第 5 章那句话在这里落成具体的方程项。**判据**：能指出折算因子消失 + 耦合项全幅值 + 由此控制必须逐项补偿。

:::

:::

::: ex D4 · 闭链会给这一章的哪两条性质出难题（§7.4 预告）

平行四边形连杆的闭链机械手（如 SCARA 的无杆传动）与本章的开链有两点不同：广义坐标不再独立、传动把「一个电机」 mapped 到「多个关节」。讨论：(a) 拉格朗日法还能用吗？约束力去哪了？(b) $\tau=Y\pi$ 的线性性还成立吗？(c) 这一问为什么被排在 §7.4（牛顿–欧拉之后）讲？

::: sol 解答要点（开放题；学完 §7.4 后回看）

(a) **还能用**，但要区分两类坐标：取**独立**广义坐标（少于关节数）则拉格朗日方程形式不变（约束力不做虚功，自动消失）；若取**非独立**坐标，则要带拉格朗日乘子，约束力以 $A^{\mathrm T}\lambda$ 的形式回到方程——「省掉受力图」的优惠只在独立坐标下兑现。
(b) **有条件成立**：闭链的约束是**运动学**的（与动力学参数无关）时，把约束流形上的动力学投影回独立坐标，仍对参数线性；但回归矩阵的写法变复杂（雅可比出现约束矩阵的伪逆）。参数**个数**也可能因结构对称而进一步减少。
(c) 因为闭链的工业动机（刚度、无杆传动）与牛顿–欧拉的**递推效率**绑定：§7.4 会给出 $O(n)$ 的正/逆动力学算法，闭链讨论需要它做数值仿真；拉格朗日法擅长「看结构」，闭链的结构要看「约束怎么投影」——两条线索在 §7.4 汇合。**本题为预习导引，答案以 §7.4 讲授为准。**

:::

:::

::: method C / D 组的验收标准

- **C 组**：数值结果必须能复现。C1、C2、C3、C4、C5、C6 与 B5 的数值都收录在 `tools/verify_teaching_examples.py`（`make verify`）里，改完公式先跑它。
- **D 组**：不追求唯一答案，看**是否用到了正文的判据**：D1 要用「显式模型 vs 隐式模型」与两条结构性质；D2 要落到 $Y$ 的列；D3 要给出折算因子消失的量化对比；D4 要区分「独立坐标」与「乘子」两种处理。
- **通用**：任何「结论先行、依据不明」的答案都要扣分——本章每道开放题都能在正文里找到一条量化依据（结构性质、算例结构或参数计数）。

:::
