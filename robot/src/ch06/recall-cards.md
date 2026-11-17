# 闭卷回忆卡 · 第六章：动力学

这页是一组检索练习。先只看问题，开口说或落笔写；每张卡答完再展开核对。原 24 张卡覆盖能量建模与结构性质，另加 E1–E4 四张卡覆盖 6.4–6.7，共 28 张。

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起。下一轮只重做 △ 与 ×。本章是「先推结构、再背公式」——公式卡的每一项都要能**说出它从哪一步来**（动能哪一块、求导哪一步），说不出来就回正文把推导走一遍。

## A. 定义卡

### A1 · 拉格朗日函数与拉格朗日方程

写出 $L$ 的定义、方程的标量形式与向量形式，并说出右端 $\xi_i$ 的四个来源。

::: sol A1 核对
**定义**：$L(\boldsymbol q,\dot{\boldsymbol q})=T(\boldsymbol q,\dot{\boldsymbol q})-U(\boldsymbol q)$——**动能减势能**（不是相加！）。**标量形式**：$\dfrac{\mathrm d}{\mathrm dt}\Bigl(\dfrac{\partial L}{\partial\dot q_i}\Bigr)-\dfrac{\partial L}{\partial q_i}=\xi_i,\ i=1,\dots,n$；**向量形式**：$\dfrac{\mathrm d}{\mathrm dt}\Bigl(\dfrac{\partial L}{\partial\dot{\boldsymbol q}}\Bigr)^{\mathrm T}-\Bigl(\dfrac{\partial L}{\partial\boldsymbol q}\Bigr)^{\mathrm T}=\boldsymbol\xi$。**广义力四件套**：执行器力矩 $\tau_i$、粘滞摩擦 $-(F_{\mathrm v}\dot q)_i$、库仑摩擦 $-(F_{\mathrm s}\operatorname{sgn}\dot q)_i$、末端接触力 $-(J^{\mathrm T}\boldsymbol h_e)_i$。（[@def-6.1.1]）
:::

### A2 · 惯性张量

写出定义式，说明它的对称性、独立分量个数、两种参考系的关系与平行轴定理。

::: sol A2 核对
**定义**：$\boldsymbol I_i=\int_{V_i}S^{\mathrm T}(\boldsymbol r_i)S(\boldsymbol r_i)\rho\,\mathrm dV$，其中 $\boldsymbol r_i$ 是微元相对**质心**的矢径、$S(\cdot)$ 是叉乘反对称阵。**性质**：对称（由 $S^{\mathrm T}S=(\boldsymbol r^{\mathrm T}\boldsymbol r)I_3-\boldsymbol r\boldsymbol r^{\mathrm T}$ 直接读出）⇒ **6 个独立分量**；对角元是绕轴转动惯量、非对角元是惯性积的负值。**参考系**：写在连杆系里是**常数** $\boldsymbol I_i^i$，基座系里 $\boldsymbol I_i=\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}$ 随位形变——所以建模总写在连杆系。**平行轴**：$\boldsymbol I_O=\boldsymbol I_C+m\,S^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C)$。（[6.1.1.2 节](sec6-1.md#part-6.1.1)；习题 B2、B3）
:::

### A3 · 惯性矩阵 $B(\boldsymbol q)$ 的四块来源

写出 $T=\frac12\dot q^{\mathrm T}B\dot q$ 中 $B$ 的完整表达式，并按「连杆 / 转子 × 平动 / 转动」报出四块。

::: sol A3 核对
$$B(\boldsymbol q)=\sum_{i=1}^{n}\Bigl[m_iJ_P^{(i)\mathrm T}J_P^{(i)}
+J_O^{(i)\mathrm T}\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}J_O^{(i)}
+m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)}
+J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\Bigr].$$
**四块**：连杆平动（$m_iJ_P^{\mathrm T}J_P$）、连杆转动（$J_O^{\mathrm T}I J_O$）、转子平动、转子转动；每块均为 $J^{\mathrm T}MJ$ 型。连杆雅可比在第 $i$ 列之后为零；转子 $i$ 的角速度雅可比第 $i$ 列含 $k_{r_i}\boldsymbol z_{m_i}$，上游列还须计入安装座角速度。（[6.1.1](sec6-1.md#part-6.1.1)）
:::

### A4 · 第一类 Christoffel 符号

写出 $c_{ijk}$ 的表达式、$c_{ij}$ 与它的关系，以及这一组 $C$ 买到什么性质。

::: sol A4 核对
$$c_{ijk}=\frac12\Bigl(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}-\frac{\partial b_{jk}}{\partial q_i}\Bigr),\qquad
c_{ij}=\sum_{k=1}^{n}c_{ijk}\dot q_k.$$
**对称性**：$c_{ijk}=c_{ikj}$（由 $B$ 对称 + 求和哑指标交换）。**买到什么**：这一组 $C$ 使 $N=\dot B-2C$ **反对称**，即对任意 $\boldsymbol w$ 有 $\boldsymbol w^{\mathrm T}N\boldsymbol w=0$——式 (7.48)。**别忘了**：满足「$C\dot q$ 正确」的 $C$ 有无穷多个，Christoffel 只是其中**性质最好的一个**；$h_{ijk}$ 本身不对称，对称化那一步（拆半 + 交换指标）是关键。（[6.2.1.1 节](sec6-2.md#part-6.2.1)；习题 B4）
:::

### A5 · 动力学参数与回归矩阵

列出 11 个刚体参数，说明 13 与最小参数集的口径差，并写出 $\tau=Y\pi$ 中两者的维度与依赖。

::: sol A5 核对
**11 个**：质量 1、一阶矩 3、相对连杆系原点的锁转惯性张量 6、转子轴向惯量 1。**13**：再加粘滞与滑动库仑摩擦系数。**参数约简**：两组 22 个名义惯性参数可缩为平面臂的 8 参数表达，进一步合并为 5 个独立惯性组合；摩擦另计。**回归式**：$\tau=Y(q,\dot q,\ddot q)\pi$，$\pi$ 为 $p\times1$ 常参数，$Y$ 为 $n\times p$；几何、重力及传动系数视为已知。用原点惯量和一阶矩作参数，才能保证线性，不能把未知质量和未知质心坐标分别当线性参数。（[6.2.2](sec6-2.md#part-6.2.2)）
:::

## B. 结论卡

### B1 · 能量法为什么不用画受力图

说清「约束力去哪了」与「代价是什么」。

::: sol B1 核对
**约束力去哪了**：理想约束力（关节反力、连杆内力）**不做虚功**——约束方向不允许虚位移，它们既不进 $T$ 也不进 $U$，于是被拉格朗日方程**自动排除**。**代价**：非保守力必须自己补到右端（广义力四件套）；漏补摩擦或末端力，方程就是错的。**一句话**：约束越复杂，能量法越划算；外力越多，右端越要细心。（[6.1 节](sec6-1.md)）
:::

### B2 · $B$ 的三条性质与 $b_{ii}$ 的读法

三条性质各由什么保证？$b_{ii}$ 是「连杆 $i$ 自己的惯量」吗？

::: sol B2 核对
**① 对称**：惯性张量与 $J^{\mathrm T}MJ$ 型乘积都对称。**② 正定**：$\dot q^{\mathrm T}B\dot q=2T>0$（$\dot q\neq0$）——动能恒正。**③ 一般随位形变**：质心位置与雅可比都是 $q$ 的函数；笛卡儿臂等特殊结构才是常数。**$b_{ii}$ 的读法**：取 $\dot{\boldsymbol q}=e_i$ 得 $T=\frac12b_{ii}$——它是「**锁住其他关节**时关节 $i$ 看到的惯量」，包含关节 $i$ 之后**所有**连杆折算到该轴的惯量（锁死其他关节后它们被刚性带动），**不是**连杆 $i$ 自己的惯量。$b_{ii}$ 里还有 $k_{r_i}^2I_{m_i}$，大减速比时常占主导。（[6.1.1.5 节](sec6-1.md#part-6.1.1)、[6.1.3.4 节](sec6-1.md#part-6.1.3)）
:::

### B3 · $C$ 的唯一性问题

运动方程对 $C$ 的要求是什么？「$C$ 不唯一」的构造性反例怎么给？

::: sol B3 核对
**要求**：$\sum_jc_{ij}\dot q_j=\sum_{j,k}h_{ijk}\dot q_k\dot q_j$，只约束乘积。**构造**：任取 $D$ 满足 $D\dot q=0$，则 $C'=C+D$ 合法。例如二维的 $D=a\begin{bmatrix}-\dot q_2&\dot q_1\\0&0\end{bmatrix}$。一般反对称矩阵只有 $\dot q^{\mathrm T}D\dot q=0$，不一定满足 $D\dot q=0$，不能直接拿来相加。（[6.2.1](sec6-2.md#part-6.2.1)）
:::

### B4 · 反对称性的两种陈述（考试最爱）

写出 (A) 与 (B)，说明各自成立的条件、证明路线与逻辑关系。

::: sol B4 核对
**(A)**：对 Christoffel 选法，$N=\dot B-2C$ **反对称**，故 $w^{\mathrm T}Nw=0$ 对**任意** $w$——代数构造（指标搬运），式 (7.48)。**(B)**：对**任意**满足 (7.43) 的 $C$，$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$——能量守恒（动能变化率 = 外力功率，对照后多余项只剩 $\frac12\dot q^{\mathrm T}N\dot q$），式 (7.49)。**逻辑**：(A)⇒(B)（取 $w=\dot q$ 即可）；**(B)⇏(A)**——$N$ 还依赖 $\dot q$，「沿自己速度方向不做功」推不出「对所有方向不做功」；作业六 7-2 的 $C_{\text{alt}}$ 给了显式反例。**用途**：(A) 用于无源性/稳定性分析（控制器任意，不只沿轨迹）；(B) 是物理事实、保证能量记账不出错。（[@thm-6.2.1]、勘误 E6.7）
:::

### B5 · 线性性的三个用途与三层口径

$\tau=Y\pi$ 的线性性有什么用？11 / 13 / 最小参数集分别指什么？

::: sol B5 核对
**用途**：辨识时堆叠采样回归矩阵做最小二乘；自适应控制以 $Y\hat\pi$ 作模型前馈；零列与相关列用于参数约简。**计数**：每组 11 个名义惯性参数，加摩擦共 13 个；平面臂 22 个名义惯性参数可缩为 8 参数表达，进一步合并为 5 个独立惯性组合。结构约简后仍需足够激励、堆叠矩阵满列秩，不能只靠采样数多保证辨识。（[6.2.2](sec6-2.md#part-6.2.2)）
:::

### B6 · 两个算例对照：复杂性从哪来

笛卡儿臂和平面臂各给出什么结论？全部差别来自哪里？

::: sol B6 核对
**笛卡儿臂**（6.3.1）：两关节都平动 ⇒ $J_O=0$、$B$ **常数对角**、$C=O$、$g_2=0$、**两轴完全解耦**——但解耦需要「笛卡儿结构 + **轴正交**」两个条件（轴成 $\pi/4$ 时 $B_{12}=m_2\cos\alpha\neq0$，习题 7.1）。**平面臂**（6.3.2）：$B$ 随 $\vartheta_2$ 变、$b_{12}\neq0$、$b_{22}$ **常数**（关节 2 之后无连杆）；$C$ 由 $h=-m_2a_1\ell_2s_2$ 生成、含离心与科氏项；$g$ 两项。**三个「第一次」**：第一次位形相关惯量、第一次离心/科氏、第一次重力耦合。**全部差别来自「转动关节 + 位形变化」**——结构决定 $B$ 是否随位形变，几何决定 $B$ 是否对角。（[6.3.1 节](sec6-3.md#part-6.3.1)、[6.3.2 节](sec6-3.md#part-6.3.2)）
:::

## C. 公式卡

### C1 · 动能与惯性矩阵

写出 $T$ 的二次型与 $B$ 的四块表达式（连杆 + 转子）。

::: sol C1 核对
$$T=\sum_{i=1}^{n}(T_i+T_{m_i})=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q},\qquad
B=\sum_{i=1}^{n}\Bigl[m_iJ_P^{(i)\mathrm T}J_P^{(i)}+J_O^{(i)\mathrm T}\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}J_O^{(i)}
+m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)}+J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\Bigr].$$
**连杆动能的来源**：$T_i=\frac12m_i\dot p_i^{\mathrm T}\dot p_i+\frac12\omega_i^{\mathrm T}I_i\omega_i$（交叉项因质心定义为零）；代入 $\dot p_i=J_P^{(i)}\dot q,\ \omega_i=J_O^{(i)}\dot q$ 即得。（[6.1.1 节](sec6-1.md#part-6.1.1)）
:::

### C2 · 势能与重力项

写出 $U$、$\boldsymbol g(\boldsymbol q)$ 与 $\boldsymbol\tau_{\mathrm{grav}}$ 三者的关系。

::: sol C2 核对
$$U=-\sum_{i=1}^{n}\bigl(m_i\boldsymbol g_0^{\mathrm T}\boldsymbol p_i+m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i}\bigr),\qquad
\boldsymbol g(\boldsymbol q)=\frac{\partial U}{\partial\boldsymbol q}
=-\sum_{i=1}^{n}\bigl(m_iJ_P^{(i)\mathrm T}\boldsymbol g_0+m_{m_i}J_P^{(m_i)\mathrm T}\boldsymbol g_0\bigr),$$
$$\boldsymbol\tau_{\mathrm{grav}}=\sum_i\bigl(m_iJ_P^{(i)\mathrm T}\boldsymbol g_0+m_{m_i}J_P^{(m_i)\mathrm T}\boldsymbol g_0\bigr)=-\boldsymbol g(\boldsymbol q).$$
**读法**：$g$ 是方程**左端**的重力项；实际重力广义力是它的相反数。静止无摩擦时 $\tau=g$。**链式法则那一步**：$\partial p_j/\partial q_i=j_{Pi}^{(j)}$（雅可比列）。$U$ 只依赖 $q$（质心位置由正运动学给出），$\partial U/\partial\dot q=0$。（[6.1.2 节](sec6-1.md#part-6.1.2)、[@ex-6.1.2.A]）
:::

### C3 · $h_{ijk}$ 与分量方程

写出 $h_{ijk}$ 的定义与分量形式的运动方程。

::: sol C3 核对
$$h_{ijk}(\boldsymbol q)=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i},\qquad
\sum_{j=1}^{n}b_{ij}\ddot q_j+\sum_{j,k}h_{ijk}\dot q_k\dot q_j+g_i=\xi_i.$$
**读法**：$h_{ijj}\dot q_j^2$ 是速度平方项，$h_{ijk}\dot q_j\dot q_k\ (j\neq k)$ 是速度交叉项。一般 $h_{iii}=\tfrac12\partial b_{ii}/\partial q_i$，不必为零；只有这一偏导为零时它才消失，不能由两连杆特例推广到任意广义坐标。（[6.1.3](sec6-1.md#part-6.1.3)）
:::

### C4 · 完整运动方程（那一行）

写出含摩擦与末端接触力的完整模型。

::: sol C4 核对
$$B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})
+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau-J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e.$$
**五左一右**：惯性、科氏/离心、粘滞摩擦、库仑摩擦、重力在左；执行器力矩减末端力在右。**约定**：$h_e$ 是末端**施加在环境上**的力；$\operatorname{sgn}\dot q$ 在 $\dot q=0$ 不连续（低速爬行的根源）。原书第 8 章的控制律就是**逐项补偿左边**。（[6.1.3.3 节](sec6-1.md#part-6.1.3)）
:::

### C5 · Christoffel 与 $C$ 矩阵

写出 $c_{ijk}$、$c_{ij}$ 与平面臂的 $C$ 矩阵。

::: sol C5 核对
$$c_{ijk}=\frac12\Bigl(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}-\frac{\partial b_{jk}}{\partial q_i}\Bigr),\qquad
c_{ij}=\sum_kc_{ijk}\dot q_k.$$
**平面臂**（记 $h=-m_2a_1\ell_2s_2$，非零符号 $c_{112}=c_{121}=c_{122}=h$、$c_{211}=-h$）：
$$C=\begin{bmatrix}h\dot\vartheta_2&h(\dot\vartheta_1+\dot\vartheta_2)\\-h\dot\vartheta_1&0\end{bmatrix},\qquad
C\dot{\boldsymbol q}=\begin{bmatrix}h(2\dot\vartheta_1\dot\vartheta_2+\dot\vartheta_2^2)\\-h\dot\vartheta_1^2\end{bmatrix}.$$
（[6.2.1 节](sec6-2.md#part-6.2.1)、[6.3.2.4 节](sec6-3.md#part-6.3.2)）
:::

### C6 · 反对称性的两条公式

写出 (7.48) 与 (7.49) 及各自的成立条件。

::: sol C6 核对
**(7.48)**：Christoffel 选法保证 $N=\dot B-2C$ 反对称，等价于任意 $w$ 的二次型为零；并非只有该选法才可能反对称。**(7.49)**：任意满足同一动力学速度项的合法 $C$ 都有 $\dot q^{\mathrm T}N\dot q=0$。前者蕴含后者，反向不成立。（[@thm-6.2.1]）
:::

### C7 · 线性性与回归矩阵

写出 $\tau=Y\pi$ 与参数计数的三个数。

::: sol C7 核对
$$\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\,\boldsymbol\pi,\qquad
\boldsymbol\pi\in\mathbb R^{p}\ \text{常参数}.$$
**计数**：每组 11 个名义惯性参数、加摩擦共 13 个；平面臂惯性部分有 8 参数表达，可再约简为 5 个独立组合。**线性来源**：能量对质量、一阶矩、原点惯量和转子轴向惯量线性，拉格朗日运算保持线性。**$Y$ 的结构**：按正文重新分组的惯性参数，$j<i$ 的块为零，故为**块上三角**；不要把附加摩擦列也当作同一分块。（[6.2.2](sec6-2.md#part-6.2.2)）
:::

### C8 · 两个「秒写」模型

(a) 带齿轮的摆；(b) 单摆质点模型。合上书各写一遍。

::: sol C8 核对
**(a) 带齿轮的摆**（例 7.1）：
$$\bigl(I+I_mk_r^2\bigr)\ddot\vartheta+\bigl(F+F_mk_r^2\bigr)\dot\vartheta+mgl\sin\vartheta=\tau.$$
**来源**：转子角速度 $k_r\dot\vartheta$ ⇒ 动能与摩擦都带 $k_r^2$；拉格朗日法**自动给出折算**，与第 5 章式 (5.29) 一致。**(b) 质点单摆**（$m=2,l=0.5$，正文例）：$B=ml^2=0.5$、$C=0$、$g=mgl\sin q$，故 $0.5\ddot q+4.905=\tau$；保持 $\tau=4.905$、释放 $\ddot q=-9.81$、加速 $\ddot q=2$ 需 $\tau=5.905$（[@ex-6.1.2.A]、[@ex-6.1.3.A]）。
:::

## D. 陷阱卡

### D1 · 两种「重力矩」混名

$\boldsymbol g(\boldsymbol q)$ 与 $\boldsymbol\tau_{\mathrm{grav}}$ 是同一个东西吗？

::: sol D1 核对
**不是，差一个符号**：$\boldsymbol g=\partial U/\partial q$ 是方程**左端**的重力项；$\boldsymbol\tau_{\mathrm{grav}}=-\boldsymbol g$ 是重力**实际施加**的广义力。静止保持时电机出 $\tau=g$，与 $\tau_{\mathrm{grav}}$ 等值反向、恰好相抵（$\boldsymbol g+\boldsymbol\tau_{\mathrm{grav}}=\boldsymbol0$，两条路径必须对上）。若只说「重力产生的力矩」而不指明哪个，前馈补偿会整体反号（[@ex-6.1.2.A]、勘误 E6.8/E6.9）。
:::

### D2 · 转子项的两个平方/一次混淆

$k_r^2I_m$ 与 $k_rI_m$ 各出现在哪？漏了会怎样？

::: sol D2 核对
**$k_{r_i}^2I_{m_i}$**（平方）进 $B$ 的**对角元** $b_{ii}$——来自转子角速度 $k_r\dot q$ 的平方（动能）；**$k_{r_i}I_{m_i}$**（一次）进平面臂的**非对角元** $b_{12}$——来自转子 2 的**总**角速度 $\dot\vartheta_1+k_{r_2}\dot\vartheta_2$ 展开的交叉项。**漏掉后果**：$b_{ii}$ 偏小 ⇒ 高速启动力矩估计不足；$b_{12}$ 漏项 ⇒ 关节 1 的耦合补偿缺一块。高减速比时 $k_r^2I_m$ 常是对角元主导项（C1 里占 97%），**不是小量**。（[6.3.2.3 节](sec6-3.md#part-6.3.2) note）
:::

### D3 · 把 (7.49) 当成 (7.48)

「我验证了 $\dot q^{\mathrm T}N\dot q=0$，所以 $N$ 反对称」——错在哪？

::: sol D3 核对
**两步错**：① (7.49) 对**任意** $C$ 成立，是能量守恒的物理事实，不是 $C$ 选法的检验；② $N$ 依赖 $\dot q$，沿**自己速度方向**的二次型为零推不出对所有 $w$ 为零。反例：作业六 7-2 的 $C_{\text{alt}}$——$\dot q^{\mathrm T}N\dot q=0$ 成立而 $w=(1,0)^{\mathrm T}$ 时 $w^{\mathrm T}Nw=-2h\dot\vartheta_2\neq0$。要断言反对称，必须对**任意** $w$ 验证或直接算 $N^{\mathrm T}=-N$。（[@thm-6.2.1]、勘误 E6.7）
:::

### D4 · 势能与重力向量的两个低级错

$U$ 能写成 $\dot q$ 的函数吗？$\boldsymbol g_0$ 的符号由什么决定？

::: sol D4 核对
**$U=U(q)$，与速度无关**——写出 $\dot q$ 说明把动能项混进来了。**$\boldsymbol g_0$ 跟坐标轴走**：$z$ 竖直向上取 $[0,0,-g]^{\mathrm T}$；平面臂 $y$ 竖直向上取 $[0,-g,0]^{\mathrm T}$——照抄 $[0,0,-g]^{\mathrm T}$ 会把整个重力项写错轴。**势能零点**加减常数不影响方程（求导为零），但「非常数项」写错才是致命的。（[6.1.2.4 节](sec6-1.md#part-6.1.2)）
:::

### D5 · 参数计数的三个数与 $Y$ 的性质

11、13、最小参数集怎么区分？$Y$ 是常数矩阵吗？

::: sol D5 核对
**11**：每组名义惯性参数；**13**：再加两摩擦系数。平面臂的 22 个名义惯性参数可写成 8 参数表达，但不代表 8 个都独立可辨识，进一步可合并为 5 个独立组合。$Y$ 随 $q,\dot q,\ddot q$ 变化，常的是 $\pi$；唯一辨识要求约简后的采样回归矩阵满列秩。（[6.2.2](sec6-2.md#part-6.2.2)）
:::

---

**复盘规则**：× 的卡片回正文对应小节重读后，当天重写；△ 的卡片隔天再测。28 张卡连续两轮全 ✓ 后，做[综合自测卷](mock-exam.md)及其补充检索题。

## E. 递推与应用卡

### E1 · 牛顿–欧拉递推的输入、方向和重力

不看公式，说出两遍递推各已知什么、计算什么；为何 $\ddot p_0=-g_0$ 后不能再加一次重力？转子 2 继承的是连杆 1 还是转子 1 的角速度？

::: sol E1 核对
输入是 $q,\dot q,\ddot q$ 及末端接触力/力矩；前向从基座到末端算运动量，后向从末端到基座算界面力/主矩，再投影到关节轴。以 $-g_0$ 初始化后，各有效加速度已含重力补偿，再在牛顿方程加重力会重复记账。转子 2 的安装座在连杆 1 上，应继承 $\omega_1$，不是 $\omega_{m1}$。移动副最终输出力 N，转动副输出力矩 N·m。（[6.4](sec6-4.md)、[作业 7-8](homework06b.md)）
:::

### E2 · 正动力学不是矩阵求逆后就结束

正、逆动力学分别给什么、求什么？如何不显式求逆得到加速度，接下来还要做什么？

::: sol E2 核对
逆解给定 $q,\dot q,\ddot q$ 和外力求 $\tau$；正解给定初始状态和输入力求加速度，并随时间积分得到速度、位置。正解每步解 $B\ddot q=\tau-C\dot q-g-\text{摩擦}-J^{\mathrm T}h_e$，随后用合适积分器更新状态。$B$ 正定保证唯一加速度，不保证任意步长或积分方法都可靠。（[6.5](sec6-5.md)）
:::

### E3 · 把时间拉长两倍，总力矩也除以四吗

写出 $q=\bar q(r(t))$ 的两次导数，再回答 $r=t/2$ 时动态分量、重力、总力矩分别怎样变化。

::: sol E3 核对
$\dot q=\dot r\bar q'$，$\ddot q=\dot r^2\bar q''+\ddot r\bar q'$。忽略摩擦和接触时，$r=t/2$ 使同一参考位置的惯性与速度二次项合计变为原来的 $1/4$；重力不变，总力矩是 $g+\bar\tau_s/4$。若原动态项与重力抵消，放慢反而可能增加总力矩幅值。（[6.6](sec6-6.md)）
:::

### E4 · 操作空间惯量的存在与模型闭合

$B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$ 何时存在？它存在是否就代表末端状态足以确定动力学？分析广义力为何不是直接的物理力矩向量？

::: sol E4 核对
$B$ 正定、$J_A$ 满行秩时逆存在。若冗余，同一末端状态可对应不同关节位形和零空间速度，系数及速度残量仍可能不同，不能只用末端状态闭合模型。几何速度与分析速度满足 $v_e=T_A\dot x_e$，功率对偶给 $\gamma_A=T_A^{\mathrm T}\gamma_e$；姿态坐标的广义力一般不是原物理力矩分量。还需避开欧拉角参数化奇点。（[6.7](sec6-7.md)、[作业 7-10](homework06b.md)）
:::
