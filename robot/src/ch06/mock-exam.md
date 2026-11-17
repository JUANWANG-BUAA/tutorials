# 综合自测卷 · 第六章

**用途**：检验本章 6.1–6.3 的能量建模、结构性质与两连杆计算（对应原书 §7.1–§7.3）；6.4–6.7 的补充检索见卷末。**请计时、闭卷、独立完成**，先作答再展开答案。

**建议用时：90 分钟 · 满分 100 分。**本章「推导长、结构深」，所以推导与计算题占比大；概念判断集中在**三条结构性质**与**两种力矩的口径**上——它们是原书第 8 章控制设计的地基。做完后对照文末评分标准给自己打分，再用[学习目标自检表](checklist.md)反查到正文薄弱小节。

::: note 使用说明

本卷题目**绝大多数为新增**。**第 16 题与正文例 7.1 同族（带齿轮的摆，换成均匀杆）、第 17 题与习题 C2 同族（平面臂数值代入，换成小参数直驱）、第 18 题与作业六 7-7 同族（末端力折算，换成静力+功率验证）**——这三处有意保留：它们分别对应本章的三个高频计算点，隔一段时间再做一次正好检验是否真的会用。数值全部重新设计，解答默认折叠；若某题完全无从下手，先做后面的题。

:::

## 第一部分 · 概念判断（10 题 × 3 分 = 30 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**1.** 用拉格朗日法列方程前，必须先画受力图、消去各关节的约束反力，才能得到正确的运动方程。

**2.** 只要最后求偏导时小心一些，把势能写成 $U(\boldsymbol q,\dot{\boldsymbol q})$ 也是允许的。

**3.** $b_{ii}$ 就是连杆 $i$ 绕关节 $i$ 轴的转动惯量。

**4.** 满足式 (7.43)（$\sum_jc_{ij}\dot q_j=\sum_{j,k}h_{ijk}\dot q_k\dot q_j$）的矩阵 $C$ 是唯一的。

**5.** 对**任意**满足式 (7.43) 的 $C$，沿系统轨迹总有 $\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q}=0$。

**6.** 由 $\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$（$N=\dot B-2C$）可以推出 $N$ 是反对称矩阵。

**7.** $\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi$ 中，换一个负载（例如末端加装夹具）改变的是 $\boldsymbol\pi$，$Y$ 的形式与依赖不变。

**8.** 平面臂有 $2\times11=22$ 个名义参数，用足够多的采样数据就能把 22 个参数全部独立辨识出来。

**9.** 两移动关节正交的笛卡儿臂没有离心项与科氏项。

**10.** 平面臂的 $b_{22}$ 随 $\vartheta_2$ 变化，所以例 7.2 中关节 2 的惯性力矩是随位形连续变化的。

::: note 第一部分答案（每题 3 分：判断 1 分 + 理由 2 分）

**（1）** **错。** 拉格朗日法只用标量 $L=T-U$；理想约束力**不做虚功**，自动不出现在方程里——「不画受力图」正是能量法的核心优势。要补的是**非保守力**（执行器力矩、摩擦、末端接触力），它们走广义力 $\xi_i$ 进右端。（[@def-6.1.1]）

**（2）** **错。** 质心位置由正运动学给出，只依赖位形：$U=U(\boldsymbol q)$。若写出 $\dot q$，说明把动能项混进了势能——这不是「小心求偏导」能救的，$\partial U/\partial\dot q\equiv0$ 这条结构性结论会全部失效（[6.1.2.2 节](sec6-1.md#part-6.1.2)）。

**（3）** **错。** $b_{ii}$ 是「**锁住其他关节**时关节 $i$ 看到的等效惯量」：取 $\dot{\boldsymbol q}=e_i$ 得 $T=\frac12b_{ii}$，而锁死其他关节后关节 $i$ **之后的所有连杆**都被刚性带动，其惯量全部折入 $b_{ii}$。对关节 1 这通常是「整条臂」的惯量，远大于连杆 1 自己。（[6.1.3.4 节](sec6-1.md#part-6.1.3) note）

**（4）** **错。** (7.43) 只约束**乘积 $C\dot q$**；往 $C$ 上加任何满足 $\Omega\dot{\boldsymbol q}=\boldsymbol0$ 的矩阵（作业六 7-2 的 $C_{\text{alt}}$ 是显式例子），方程不变。**只有 $C\dot q$ 唯一**。（[6.2.1.1 节](sec6-2.md#part-6.2.1)）

**（5）** **对。** 这就是式 (7.49)：由动能变化率 = 外力功率（能量守恒）导出，与 $C$ 的选法**无关**——它是物理事实，不是某组 $C$ 的代数性质。（[@thm-6.2.1]）

**（6）** **错。** (7.49) 沿**系统自己的速度方向**成立，而 $N$ 还依赖 $\dot{\boldsymbol q}$；换一个 $\boldsymbol w$ 二次型一般非零。作业六 7-2 给了显式反例：$C_{\text{alt}}$ 下 $\dot q^{\mathrm T}N\dot q=0$ 成立，但 $N_{12}=-h\dot\vartheta_2\neq-N_{21}$。**(A)⇒(B) 成立，(B)⇏(A)**——逻辑方向不能倒。（勘误 E6.7）

**（7）** **对。** $\boldsymbol\pi$ 是**常参数**向量，由结构与负载决定——换负载等于换了一组 $\pi$，模型形式不变；$Y$ 的元素只含 $q,\dot q,\ddot q$。这正是「辨识」有意义的前提：模型结构不变、只有参数待定。（[6.2.2.3 节](sec6-2.md#part-6.2.2)）

**（8）** **错。** 结构性零列与相关列不会因为多采样而消失。22 个名义惯性参数可缩为正文的 8 参数表达，后者仍非最小集；进一步可合并为 5 个独立惯性组合。只有约简后的回归矩阵获得足够激励且满列秩时，才可唯一辨识这些组合。摩擦另计。（[6.2.2.4 节](sec6-2.md#part-6.2.2)）

**（9）** **对。** 两关节都平动 ⇒ $J_O^{(1)}=J_O^{(2)}=0$、$B$ 为**常数**矩阵 ⇒ $\dot B=0$ ⇒ $h_{ijk}\equiv0$ ⇒ $C=O$——没有离心项也没有科氏项。**补一句**：解耦还需要**轴正交**；轴成 $\alpha\neq90^\circ$ 时 $B_{12}=m_2\cos\alpha\neq0$（习题 7.1、[6.3.1 节](sec6-3.md#part-6.3.1)）。

**（10）** **错。** $b_{22}=I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}$ 是常数；梯形或三角形速度轨迹下，自惯性项 $b_{22}\ddot\vartheta_2$ 分段恒定。但完整的关节 2 惯性力矩为 $b_{21}(\vartheta_2)\ddot\vartheta_1+b_{22}\ddot\vartheta_2$，仍可随位形变化，不能把自惯性项当成全部惯性项。（[6.3.2.6](sec6-3.md#part-6.3.2)）

:::

## 第二部分 · 填空简答（5 题 × 4 分 = 20 分）

**11.（4 分）** 写出拉格朗日方程（标量形式），解释「理想约束力为什么不需要出现在方程里」，并列出广义力 $\xi_i$ 的四个来源。

**12.（4 分）** 写出 $B(\boldsymbol q)$ 的三条性质及各自的保证；写出 $b_{ii}$ 的「锁住」解读，并说明它为什么包含关节 $i$ 之后所有连杆的贡献。

**13.（4 分）** 写出反对称性的两种陈述 (7.48) 与 (7.49)、各自的成立条件与证明路线，并说明哪一条是物理事实、哪一条是选法的产物。

**14.（4 分）** 列出扩展连杆参数分组中的 11 个名义惯性参数；说明 $\tau=Y\pi$ 为什么把辨识变成线性最小二乘；解释平面臂从 22 个名义惯性参数到 8 参数表达、再到 5 个独立组合的区别。

**15.（4 分）** 写出平面臂的 $h$、非零 Christoffel 符号、$C$ 矩阵与 $C\dot{\boldsymbol q}$ 的两个分量；说明 $b_{12}$ 里 $k_{r_2}I_{m_2}$ 一项的来源。

::: note 第二部分答案（每题 4 分）

**11.** $\dfrac{\mathrm d}{\mathrm dt}\Bigl(\dfrac{\partial L}{\partial\dot q_i}\Bigr)-\dfrac{\partial L}{\partial q_i}=\xi_i$，$L=T-U$。**约束力**：理想约束（关节反力、连杆内力）不做虚功，既不进 $T$ 也不进 $U$，被方程自动排除——约束越复杂越划算。**四件套**：执行器力矩 $\tau_i$、粘滞摩擦 $F_{\mathrm v}\dot q_i$、库仑摩擦 $F_{\mathrm s}\operatorname{sgn}\dot q_i$、末端接触力 $J^{\mathrm T}\boldsymbol h_e$（右端取减号）。**评分**：方程 1.5 分；约束力解释 1.5 分；四件套 1 分。（[@def-6.1.1]）

**12.** **对称**（$J^{\mathrm T}MJ$ 型乘积与惯性张量都对称）；**正定**（$\dot q^{\mathrm T}B\dot q=2T>0$，动能恒正）；**一般随位形变**（质心位置与雅可比都是 $q$ 的函数；笛卡儿臂例外）。**$b_{ii}$**：$\dot{\boldsymbol q}=e_i$ 时 $T=\frac12b_{ii}$ ⇒「锁住其他关节时关节 $i$ 看到的惯量」；锁死其他关节后下游连杆被**刚性带动**，其动能全部计入 $b_{ii}$，故含其后所有连杆 + 转子的 $k_{r_i}^2I_{m_i}$。**评分**：三条性质 2 分（各 0.5 + 保证 0.5 二选一即可）；$b_{ii}$ 解读与「下游全含」2 分。（[6.1.1.5 节](sec6-1.md#part-6.1.1)）

**13.** **(7.48)**：Christoffel 选法下 $N=\dot B-2C$ 反对称，$\forall\boldsymbol w,\ \boldsymbol w^{\mathrm T}N\boldsymbol w=0$——由 $n_{ij}=\sum_k(\partial_i b_{jk}-\partial_j b_{ik})\dot q_k$ 可见交换 $i,j$ 变号。**(7.49)**：对任意合法选法，$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$——动能变化率与外力功率比较所得的功率平衡恒等式。**方向**：(7.48)⇒(7.49)（取 $w=\dot q$），反向不成立。前者是特定矩阵选法保证的性质，后者与合法选法无关。**评分**：两条陈述各 1.5 分；逻辑方向与条件 1 分。（[@thm-6.2.1]）

**14.** **11 个**：质量 $m_i$、一阶矩 $h_{ix},h_{iy},h_{iz}$、相对连杆系原点的锁转惯性张量 $\widehat I_{i,xx},\widehat I_{i,xy},\widehat I_{i,xz},\widehat I_{i,yy},\widehat I_{i,yz},\widehat I_{i,zz}$、转子轴向惯量 $I_{m_i}$。**线性最小二乘**：动能、势能对这组常参数线性，拉格朗日运算保持线性，故将采样回归矩阵按行堆叠后可解 $\min\|Y\pi-\tau\|^2$；数值实现可用 QR 或 SVD。**压缩原因**：平面结构产生零列与相关列，22 个名义惯性参数可写成 8 参数表达；8 个还不是全都独立可辨识，进一步约简为 5 个独立惯性组合。唯一辨识仍要求足够激励。**评分**：参数 2 分；线性最小二乘 1 分；压缩区别 1 分。（[6.2.2](sec6-2.md#part-6.2.2)）

**15.** $h=-m_2a_1\ell_2s_2$；非零符号 $c_{112}=c_{121}=c_{122}=h$、$c_{211}=-h$（其余为零）；
$$C=\begin{bmatrix}h\dot\vartheta_2&h(\dot\vartheta_1+\dot\vartheta_2)\\-h\dot\vartheta_1&0\end{bmatrix},\qquad
C\dot{\boldsymbol q}=\begin{bmatrix}h(2\dot\vartheta_1\dot\vartheta_2+\dot\vartheta_2^2)\\-h\dot\vartheta_1^2\end{bmatrix}.$$
**$k_{r_2}I_{m_2}$ 的来源**：转子 2 的**总**角速度是 $\omega_{m_2}=\dot\vartheta_1+k_{r_2}\dot\vartheta_2$（连杆 1 带着转子 2 的轴一起转）；展开 $\frac12I_{m_2}\omega_{m_2}^2$ 得交叉项 $I_{m_2}\dot\vartheta_1\dot\vartheta_2\cdot k_{r_2}$，进 $b_{12}$。**评分**：$h$ 与符号 1.5 分；$C$ 与 $C\dot q$ 1.5 分；来源 1 分。（[6.3.2.4 节](sec6-3.md#part-6.3.2)）

:::

## 第三部分 · 推导计算（3 题 × 10 分 = 30 分）

**16.（10 分）均匀杆摆 + 转子（例 7.1 的进阶版）。**
长 $l=0.6\ \mathrm m$、质量 $m=1.5\ \mathrm{kg}$ 的**均匀细杆**绕端点 $O$ 摆动（转角 $\vartheta$，下垂为零）；转子 $I_m=2\times10^{-4}\ \mathrm{kg\cdot m^2}$、减速比 $k_r=50$，忽略摩擦与末端力。
**(a)** 写出 $T$、$U$ 与 $L$（均匀杆绕端点的转动惯量与质心位置自己推）。(4 分)
**(b)** 求 $\vartheta=\pi/2$ 处静止保持所需的力矩。(3 分)
**(c)** 同位形要求 $\ddot\vartheta=3\ \mathrm{rad/s^2}$，求力矩，并按「加速 / 平衡重力」拆账。(2 分)
**(d)** 验证你用的 $I_O$ 满足平行轴定理 $I_O=I_C+m(l/2)^2$（取细杆 $I_C=ml^2/12$）。(1 分)

**17.（10 分）小参数直驱平面臂。**
两连杆平面臂：$a_1=a_2=1\ \mathrm m$、$\ell_1=\ell_2=0.5\ \mathrm m$、$m_1=m_2=1\ \mathrm{kg}$、$I_1=I_2=0.1\ \mathrm{kg\cdot m^2}$；**直驱** $k_{r_1}=k_{r_2}=1$、$I_{m_1}=I_{m_2}=0.02$、$m_{m_1}=m_{m_2}=0.2\ \mathrm{kg}$。当前 $\vartheta_1=0$、$\vartheta_2=\pi/2$、$\dot\vartheta_1=0.2$、$\dot\vartheta_2=0\ \mathrm{rad/s}$，要求 $\ddot\vartheta_1=0$、$\ddot\vartheta_2=0.5\ \mathrm{rad/s^2}$。
**(a)** 求 $h$ 与 $B$（三位小数）。(3 分)
**(b)** 求 $C$、$C\dot{\boldsymbol q}$ 与 $\boldsymbol g$。(3 分)
**(c)** 求 $\boldsymbol\tau$，并回答：$\dot\vartheta_2=0$ 且 $g_2=0$，关节 2 为什么仍需要非零力矩？(4 分)

**18.（10 分）末端力的静力折算与功率验证。**
两连杆平面臂 $a_1=a_2=0.5\ \mathrm m$，位形 $\vartheta_1=30^{\circ}$、$\vartheta_2=60^{\circ}$（$\vartheta_1+\vartheta_2=90^{\circ}$）。末端施加在环境上的力 $\boldsymbol f=(10,\,-5)^{\mathrm T}\ \mathrm N$（末端力矩为零）。
**(a)** 写出定位用的 $2\times2$ 雅可比 $J$，并求执行器为施加 $\boldsymbol f$ 需要额外输出的关节力矩 $\boldsymbol\tau_f=J^{\mathrm T}\boldsymbol f$。(4 分)
**(b)** 取 $\dot{\boldsymbol q}=(1,0)^{\mathrm T}\ \mathrm{rad/s}$，分别算 $\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau_f$ 与 $\boldsymbol v_e^{\mathrm T}\boldsymbol f$（$\boldsymbol v_e=J\dot{\boldsymbol q}$），验证功率守恒。(3 分)
**(c)** 说明为什么 $\boldsymbol\tau_f$ 必须用**当前位形**的 $J$ 重算，而不能用上一个时刻的。(3 分)

::: note 第三部分答案与评分要点

**16.（a）**（4 分）均匀细杆绕端点：$I_O=\dfrac{ml^2}{3}=\dfrac{1.5\times0.36}{3}=0.18\ \mathrm{kg\cdot m^2}$；质心在 $l/2$ 处，升高 $\frac l2(1-\cos\vartheta)$：
$$T=\frac12\Bigl(\frac{ml^2}{3}+I_mk_r^2\Bigr)\dot\vartheta^2=\frac12\times0.68\,\dot\vartheta^2,\qquad
U=mg\frac l2(1-\cos\vartheta),$$
$$L=\frac12\Bigl(\frac{ml^2}{3}+I_mk_r^2\Bigr)\dot\vartheta^2-mg\frac l2(1-\cos\vartheta),\qquad
\frac{ml^2}{3}+I_mk_r^2=0.18+0.5=0.68\ \mathrm{kg\cdot m^2}.$$
**失分点**：质心势能写成 $mgl(1-\cos\vartheta)$（差一半）；漏转子项 $I_mk_r^2=0.5$（它比杆的 $0.18$ 还大——大减速比下转子主导）。

**（b）**（3 分）$g(\vartheta)=\dfrac{mgl}{2}\sin\vartheta$，$\vartheta=\pi/2$：$\tau=\dfrac{1.5\times9.81\times0.6}{2}\times1=4.4145\ \mathrm{N\cdot m}$（静止时 $\ddot\vartheta=\dot\vartheta=0$，只需平衡重力）。

**（c）**（2 分）$\tau=0.68\times3+4.4145=2.04+4.4145=6.455\ \mathrm{N\cdot m}$：**2.04 用于加速、4.4145 平衡重力**。

**（d）**（1 分）$I_C=\dfrac{ml^2}{12}=0.045$，$m(l/2)^2=1.5\times0.09=0.135$，和 $=0.18=I_O$ ✓。**这一小题就是在考「质心系 + 平行轴」的搭配使用**。

**17.（a）**（3 分）$h=-m_2a_1\ell_2s_2=-0.5\times1=-0.5$；
$$b_{11}=0.1+0.25+0.02+0.1+1\times(1+0.25+0)+0.02+0.2=1.94,\qquad
b_{12}=0.1+0.25+0.02=0.37,\qquad
b_{22}=0.1+0.25+0.02=0.37.$$
即 $B=\begin{bmatrix}1.94&0.37\\0.37&0.37\end{bmatrix}$。**注意**：$s_2=\sin\frac\pi2=1$，$c_2=0$。

**（b）**（3 分）$C=\begin{bmatrix}h\dot\vartheta_2&h(\dot\vartheta_1+\dot\vartheta_2)\\-h\dot\vartheta_1&0\end{bmatrix}=\begin{bmatrix}0&-0.1\\0.1&0\end{bmatrix}$，
$C\dot{\boldsymbol q}=(0,\ 0.02)^{\mathrm T}\ \mathrm{N\cdot m}$（即 $-h\dot\vartheta_1^2=0.5\times0.04$）。
$g_1=(m_1\ell_1+m_{m_2}a_1+m_2a_1)g\,c_1+m_2\ell_2g\,c_{12}=1.7\times9.81\times1+0.5\times9.81\times0=16.677$；
$g_2=0.5\times9.81\times0=0\ \mathrm{N\cdot m}$（第二杆竖直，质心在关节 2 正上方，重力力臂为零）。

**（c）**（4 分）
$$\tau_1=b_{12}\ddot\vartheta_2+g_1=0.37\times0.5+16.677=16.862,\qquad
\tau_2=b_{22}\ddot\vartheta_2+(C\dot q)_2=0.185+0.02=0.205\ \mathrm{N\cdot m}.$$
**关节 2 的非零力矩有两部分**：虽然当前 $\dot\vartheta_2=0$，要求的 $\ddot\vartheta_2=0.5$ 不为零，因此自惯性力矩为 $0.185\ \mathrm{N\cdot m}$；关节 1 的运动还带来**离心项** $-h\dot\vartheta_1^2=0.02\ \mathrm{N\cdot m}$，合计 $0.205\ \mathrm{N\cdot m}$。这里不是两个速度乘积的科氏项。直驱下关节侧力矩直接落在电机轴上，不再有减速器的力矩放大。**评分**：(a) 3 分；(b) 3 分；(c) 数值 2 分 + 两项解释 2 分。

**18.（a）**（4 分）$s_1=0.5,c_1=\frac{\sqrt3}2,s_{12}=1,c_{12}=0$：
$$J=\begin{bmatrix}-a_1s_1-a_2s_{12}&-a_2s_{12}\\ a_1c_1+a_2c_{12}&a_2c_{12}\end{bmatrix}
=\begin{bmatrix}-0.75&-0.5\\ \frac{\sqrt3}{4}\approx0.433&0\end{bmatrix},\qquad
\boldsymbol\tau_f=J^{\mathrm T}\boldsymbol f=\begin{bmatrix}-7.5-2.165\\ -5\end{bmatrix}
=\begin{bmatrix}-9.665\\ -5.000\end{bmatrix}\ \mathrm{N\cdot m}.$$
（符号为负表示：要把 $\boldsymbol f$ 施加到环境上，执行器需输出**负方向**的关节力矩——即「顺着力」的方向还要再推。）

**（b）**（3 分）$\boldsymbol v_e=J\dot{\boldsymbol q}=(-0.75,\ 0.433)^{\mathrm T}\ \mathrm{m/s}$；
$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau_f=1\times(-9.665)=-9.665\ \mathrm W$；
$\boldsymbol v_e^{\mathrm T}\boldsymbol f=(-0.75)\times10+0.433\times(-5)=-7.5-2.165=-9.665\ \mathrm W$。**相等 ✓**——这就是静力学对偶的功率内容：$J^{\mathrm T}$ 之所以是力的映射，因为虚功（功率）必须守恒。

**（c）**（3 分）$J$ 随位形改变，本质上是在更新各关节轴到末端的有向力臂。本题若只把 $\vartheta_1$ 增大 $90^\circ$，雅可比四个元素均改变，$J^{\mathrm T}f$ 也必须重算。作业 7-7 中固定基系力 $[500,500]^{\mathrm T}$ 的第二关节接触分量从约 $-447.5$ 变为 $+447.5\ \mathrm{N\cdot m}$，说明连符号都可能改变。**评分**：本题 (a) 4 分，(b) 3 分，(c) 理由 2 分、具体证据 1 分。

:::

## 第四部分 · 综合应用（2 题 × 10 分 = 20 分）

**19.（10 分）拉格朗日法与第 5 章折算的一致性。**
带齿轮的摆：连杆绕 $O$ 的转动惯量 $I=0.4\ \mathrm{kg\cdot m^2}$、摩擦 $F=0.06$；转子 $I_m=0.002\ \mathrm{kg\cdot m^2}$、摩擦 $F_m=5\times10^{-4}\ \mathrm{N\cdot m\cdot s/rad}$、减速比 $k_r=80$；$m=1\ \mathrm{kg}$、$l=0.5\ \mathrm m$。
**(a)** 用拉格朗日法推导完整方程（含摩擦），代入数值。(4 分)
**(b)** 写出第 5 章的电机侧折算模型（$I_{eq},F_{eq}$ 与 $C_l/k_r$，其中 $\vartheta_m=k_r\vartheta$），并证明它与 (a) 的关节侧方程**严格等价**（给出两式之间的乘子关系）。(4 分)
**(c)** 一句话总结「拉格朗日法自动折算」的含义。(2 分)

**20.（10 分）能量恒等式与其控制含义。**
**(a)** 证明：无摩擦、无末端接触力时，沿任意运动有
$\dfrac12\dfrac{\mathrm d}{\mathrm dt}\bigl(\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}\bigr)=\dot{\boldsymbol q}^{\mathrm T}(\boldsymbol\tau-\boldsymbol g)$。(5 分)
**(b)** 由 (a) 说明 $\tfrac12\dot q^{\mathrm T}\dot B\dot q$ 与 $\dot q^{\mathrm T}C\dot q$ 的抵消关系，是否意味着惯性力矩本身不做功？重力补偿后的无源性对控制设计有什么帮助？(3 分)
**(c)** 若把 $C$ 换成作业六 7-2 的 $C_{\text{alt}}$，(a) 的结论还成立吗？为什么？(2 分)

::: note 第四部分参考答案

**19.（a）**（4 分）$T=\frac12(I+I_mk_r^2)\dot\vartheta^2$、$U=mgl(1-\cos\vartheta)$、广义力 $\xi=\tau-F\dot\vartheta-F_mk_r^2\dot\vartheta$：
$$\bigl(I+I_mk_r^2\bigr)\ddot\vartheta+\bigl(F+F_mk_r^2\bigr)\dot\vartheta+mgl\sin\vartheta=\tau,$$
数值：$I+I_mk_r^2=0.4+0.002\times6400=13.2$；$F+F_mk_r^2=0.06+3.2=3.26$；$mgl=4.905$：
$$13.2\,\ddot\vartheta+3.26\,\dot\vartheta+4.905\sin\vartheta=\tau.$$

**（b）**（4 分）电机侧：$\vartheta_m=k_r\vartheta$、$\omega_m=k_r\dot\vartheta$，
$$I_{eq}\dot\omega_m+F_{eq}\omega_m+\frac{mgl}{k_r}\sin\frac{\vartheta_m}{k_r}=\tau_m,\qquad
I_{eq}=I_m+\frac{I}{k_r^2}=0.002+6.25\times10^{-5}=0.0020625,$$
$$F_{eq}=F_m+\frac{F}{k_r^2}=5\times10^{-4}+9.375\times10^{-6}=5.094\times10^{-4}.$$
**等价性**：把电机侧方程两边乘 $k_r$（功率平衡：$\tau_m\omega_m=\tau\dot\vartheta$ ⇒ $\tau=k_r\tau_m$… 注意方向，取 $\tau_m=\tau/k_r$）并用 $\dot\omega_m=k_r\ddot\vartheta$：
$k_r^2I_{eq}=6400\times0.0020625=13.2=I+I_mk_r^2$ ✓；
$k_r^2F_{eq}=6400\times5.094\times10^{-4}=3.26=F+F_mk_r^2$ ✓；
$k_r\cdot\dfrac{mgl}{k_r}\sin\dfrac{k_r\vartheta}{k_r}=mgl\sin\vartheta$ ✓。三条逐项吻合——**两式是同一方程的两侧写法**。

**（c）**（2 分）拉格朗日法把转子动能与转子摩擦写进 $T$ 与广义力，「$k_r^2$ 惯量折算、$k_r$ 力矩折算」是**推导的自然结果**，不需要再按第 5 章单独折算一遍——两条路线互为校核。

**20.（a）**（5 分）动能变化率：
$$\frac12\frac{\mathrm d}{\mathrm dt}(\dot q^{\mathrm T}B\dot q)=\frac12\dot q^{\mathrm T}\dot B\dot q+\dot q^{\mathrm T}B\ddot q.$$
代入 $B\ddot q=\tau-C\dot q-g$：
$$=\dot q^{\mathrm T}(\tau-g)+\frac12\dot q^{\mathrm T}(\dot B-2C)\dot q.$$
由式 (7.49)（对任意 $C$ 成立）末项为零，得 $\frac12\frac{\mathrm d}{\mathrm dt}(\dot q^{\mathrm T}B\dot q)=\dot q^{\mathrm T}(\tau-g)$。$\blacksquare$

**（b）**（3 分）$\tfrac12\dot q^{\mathrm T}\dot B\dot q=\dot q^{\mathrm T}C\dot q$；这是求动能导数时的结构抵消，不是说 $B\ddot q$ 或 $C\dot q$ 各自不做功。重力补偿后令输入 $u=\tau-g$，储能 $T=\tfrac12\dot q^{\mathrm T}B\dot q$ 满足 $\dot T=\dot q^{\mathrm T}u$，给出从 $u$ 到 $\dot q$ 的无源关系。可据此设计耗散反馈并构造 Lyapunov 证明；但无源性本身不自动保证任意负反馈都渐近稳定，还须检查储能、反馈符号及不变集等条件。

**（c）**（2 分）**成立**。(a) 用的是 (7.49)（对任意满足 (7.43) 的 $C$ 都成立，能量守恒路线），与选法无关；换 $C_{\text{alt}}$ 改变的只是 $\dot q^{\mathrm T}(\dot B-2C)\dot q$ 的**中间代数形式**，其值仍为零。**反例要找的是 (7.48)**：$C_{\text{alt}}$ 使 $N$ 不再反对称，任意 $w$ 的二次型不为零——别把两件事记混。

**评分建议**：19 (a) 4 分（$T,U,\xi$ 2 分 + 数值 2 分）；(b) 4 分（折算模型 2 分 + 三个乘子验证 2 分）；(c) 2 分。20 (a) 5 分（微分展开 2 分 + 代入方程 2 分 + 引用 (7.49) 收尾 1 分）；(b) 3 分；(c) 2 分。**只写结论不写推导，每题最多 4 分。**

:::

<a id="exam6-rubric"></a>

## 评分标准

| 部分 | 题量 | 分值 | 给分要点 |
|:--|:--:|:--:|:--|
| 一 · 概念判断（1–10） | 10 | 30 | 判断 1 分 + 理由 2 分；**只写对错不给分**。高频陷阱：受力图（1）、$b_{ii}$（3）、(B)⇏(A)（6）、参数全可辨识（8）、$b_{22}$（10） |
| 二 · 填空简答（11–15） | 5 | 20 | 公式与条目写全得一半以上；**两种重力矩、两种反对称陈述、三层参数口径**必须分开写，混名扣半 |
| 三 · 推导计算（16–18） | 3 | 30 | 列式 3–4 分、代数 3 分、数值 2 分（带单位与有效数字）、结论句 1–2 分；质心势能差一半、漏 $I_mk_r^2$、漏 $k_{r_2}I_{m_2}$ 是三大失分点 |
| 四 · 综合应用（19–20） | 2 | 20 | 按小分点给分；**只写结论不写推导，每题最多 4 分** |

| 分数段 | 含义 | 下一步 |
|:--:|:--|:--|
| **90–100** | 三条结构性质与两个算例都扎实 | 可直接进入运动控制：重读[章总结](summary.md)的「与前后章的接口」，把 $B$ 正定、$\dot B-2C$ 反对称、$g$ 显式三条带给原书第 8 章 |
| **75–89** | 主干掌握，个别口径（两种力矩 / 两种陈述 / 三层参数）不稳 | 用[学习目标自检表](checklist.md)定位失分条目，重做对应小节的「默写点」 |
| **60–74** | 会背公式，一落到数值与推导就断 | 重做[习题集](exercises.md) B 组与 C 组；把平面臂的 $B,C,\boldsymbol g$ **完整手推一遍**（这是本章唯一必须会的手算） |
| **< 60** | 需要系统重学 | 回[章导览](overview.md)按「6.1 → 6.1.1 → 6.1.3 → 6.2.1 → 6.2.2 → 6.3.2」重读；先走通[单摆双路径](sec6-1.md#part-6.1.2)与[保持/加速例题](sec6-1.md#part-6.1.3) |

## 漏点定位表

| 错题 | 回去读 | 立刻补做 |
|:--|:--|:--|
| 1、11 | [@def-6.1.1]、[6.1](sec6-1.md) | 习题 A1；回忆卡 B1、A1 |
| 2、15 | [6.1.2](sec6-1.md#part-6.1.2) | [@ex-6.1.2.A]；习题 A2；回忆卡 C2、D4 |
| 3、12 | [6.1.3.4](sec6-1.md#part-6.1.3) note | 习题 B6；回忆卡 B2 |
| 4、15 | [6.2.1.1](sec6-2.md#part-6.2.1)、作业六 7-2 | 习题 B4；回忆卡 B3、C5 |
| 5、6、13、20 | [@thm-6.2.1]、[6.2.1](sec6-2.md#part-6.2.1) | 习题 B5、C6；回忆卡 B4、D3 |
| 7、8、14 | [6.2.2](sec6-2.md#part-6.2.2)、[勘误 E6.6](errata.md) | 习题 C5、D2；回忆卡 A5、D5 |
| 9、17(a) | [6.3.1](sec6-3.md#part-6.3.1) | 习题 C3；回忆卡 B6 |
| 10、17 | [6.3.2](sec6-3.md#part-6.3.2) | 习题 C2、C4；回忆卡 C8、D2 |
| 16 | [例 7.1：带齿轮的摆](sec6-1.md#part-6.1.pendulum) | 习题 C1；回忆卡 C8 |
| 18 | 作业六 7-7 | 习题 C4；回忆卡 S6.4 对应[自检表](checklist.md) |

::: method 复盘比分数重要

无论得多少分，做完后请**为每道错题写一行复盘**，格式固定为一句话：

> 「我在 `____` 这一步错了，原因是 `____`，正确做法是 `____`。」

如果同一类错误出现两次以上——尤其是「两种重力矩混名」「漏转子项」「把 (7.49) 当 (7.48)」「势能写成速度的函数」「三种参数口径混用」这五类——那不是粗心，而是概念缺口：回对应小节重读，并把该节的**默写点**合书重写一遍。

:::

## 6.4–6.7 补充闭卷检索（不计入原 100 分）

以下四题各用两三行回答；错一题便回对应正文与习题 E 组重做，再答一次。

**补 1（6.4）** 牛顿–欧拉两遍递推各向哪个方向？静止时采用 $\ddot p_0=-g_0$，质心有效加速度是否为零？转子 2 继承哪个部件的角速度？

**补 2（6.5）** 已知当前 $B=0.5\ \mathrm{kg\cdot m^2}$、$g=4.905\ \mathrm{N\cdot m}$，其余阻力为零，输入 $\tau=3.905\ \mathrm{N\cdot m}$ 时求加速度；指出要得到后续位置还缺什么步骤。

**补 3（6.6）** 同一位置处原动态力矩为 $-8\ \mathrm{N\cdot m}$、重力项为 $10\ \mathrm{N\cdot m}$。忽略摩擦接触，把时长加倍后总力矩为多少？是否必然更小？

**补 4（6.7）** 写出 $B_A$ 的定义和存在条件，说明「满行秩」为什么不等于「冗余机器人的末端状态可闭合动力学」。

::: sol 补充题核对
1. 前向从基座到末端求运动量，后向反方向求力与主矩，再投影。有效加速度包含 $-g_0$，静止不为零；转子 2 继承安装座连杆 1 的角速度，不是转子 1 的自转。
2. $\ddot q=(3.905-4.905)/0.5=-2\ \mathrm{rad/s^2}$。还须以初始位置、速度作数值积分，并在推进中更新模型；不能只用当前加速度一次算出整条非线性运动。
3. 动态项变为 $-2$，总力矩为 $10-2=8\ \mathrm{N\cdot m}$，比原来的 $2$ 更大；动态项原先抵消了部分重力。全轨迹可行性仍需逐时刻、逐关节检查。
4. $B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$；$B$ 正定且 $J_A$ 满行秩保证逆存在。冗余时同一末端状态仍对应不同关节位形与零空间速度，系数及速度残量可能不同，必须保留这些状态或指定冗余消解规则。
:::
