# 闭卷回忆卡 · 第三章：微分运动学和静力学

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。全章共 30 张卡（定义 7 / 结论 8 / 公式 8 / 陷阱 7），一轮约 40 分钟。

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起。下一轮只重做 △ 与 ×。本章按老师的考试权重分为两块——**雅可比（3.1–3.2）与静力学（3.8）是必考**，其余各节按「精读 / 浏览」区分投入。

## A. 定义卡

### A1 · 微分运动学方程与几何雅可比

写出六维速度向量的构成与方程，并说明 $\boldsymbol\omega_e$ 的分量相对哪个坐标系。

::: sol A1 核对
末端执行器速度取六维堆叠 $\boldsymbol v_e=\begin{bmatrix}\dot{\boldsymbol p}_e\\ \boldsymbol\omega_e\end{bmatrix}$（3 平动 + 3 转动），微分运动学方程为

$$\begin{bmatrix}\dot{\boldsymbol p}_e\\ \boldsymbol\omega_e\end{bmatrix}=J(\boldsymbol q)\dot{\boldsymbol q}=\begin{bmatrix}J_P\\ J_O\end{bmatrix}\dot{\boldsymbol q},\qquad J\in\mathbb R^{6\times n}.$$

$J$ 称**几何雅可比矩阵**，是位形 $\boldsymbol q$ 的函数；$J_P$ 对应线速度、$J_O$ 对应角速度，各 $3\times n$。**$\boldsymbol\omega_e$ 的三个分量是末端角速度在基坐标系三根轴上的投影**——这句话是几何 / 分析雅可比分歧的根源。（[@def-3.1.1]）
:::


### A2 · 运动学奇点

先给出适用于长方阵的定义，再写通常可逆方阵的判据；轴平行能否单独判定奇点？

::: sol A2 核对
先固定任务，令 $r_{\max}$ 为该机构在此任务下的最大可达秩；$\operatorname{rank}J(q)<r_{\max}$ 的位形称为运动学奇点。通常可逆的方阵可用 $\det J=0$ 判断。边界奇点与内部奇点按其在所选任务工作空间中的位置区分；轴平行不是一般判据，例如平面两连杆的轴始终平行，却在 $\vartheta_2=90^\circ$ 时位置雅可比满秩。（[@def-3.3.1]）
:::

### A3 · 冗余（任务相关）

写出冗余的判据，并指出两个子空间各回答什么问题。

::: sol A3 核对
$n>r$ 判任务相关冗余，$r$ 是独立任务变量数，不能与当前秩 $s=\operatorname{rank}J$ 混用。$\mathcal R(J)$ 描述当前可实现的任务速度，$\mathcal N(J)$ 描述不产生一阶任务变化的关节速度；核维数一般是 $n-s$，行满秩时才为 $n-r$。核永远含零向量，非平凡瞬时内部运动要求 $\mathcal N(J)\ne\{0\}$。任务雅可比来自 $x=f(q)$ 的求导，不总是选取几何雅可比的行。（[@def-3.4.1]、[@ex-3.4.A]）
:::

### A4 · 零空间投影与解族

写出 $P$ 的定义、秩与解族，并说明通解为什么既无错解也不漏解。

::: sol A4 核对
若 $B$ 是零空间的普通满列秩基，$P=B(B^{\mathrm T}B)^{-1}B^{\mathrm T}$；若 $N^{\mathrm T}N=I$，可写为 $P=NN^{\mathrm T}$。$P^2=P$、$P^{\mathrm T}=P$、$JP=0$，秩为 $n-\operatorname{rank}J$。

存在特解时，全部速度解是 $\dot q=\dot q^*+P\dot q_0$：加核中向量仍为解，任意两解之差又必在核中。只保持所选任务的瞬时速度；位置任务可改变朝向，有限更新一般产生二阶误差。（[@thm-3.4.B]、[独立练习](sec3-4.md#practice-3.4.project)）
:::

### A5 · 右伪逆与最小范数解

写出 $J^\dagger$ 的表达式、它的性质，以及它与 $J^{-1}$ 的分工。

::: sol A5 核对
$J\in\mathbb R^{r\times n}$ 行满秩时，$J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}\in\mathbb R^{n\times r}$、$JJ^\dagger=I_r$。固定当前 $J,v_e$ 后，$J^\dagger v_e$ 是唯一全局最小范数可行解，不代表整条轨迹最优。证明用任意可行扰动 $z\in\mathcal N(J)$：交叉项为零，范数平方增加 $\|z\|^2$。方阵满秩时 $J^\dagger=J^{-1}$；降秩时一般Moore–Penrose伪逆仍存在，须用正奇异值方向构造，不能再套这个行满秩闭式。（[@def-3.5.1]）
:::

### A6 · 阻尼广义逆 $J^*$（DLS）

写出 $J^*$ 的表达式与经典阻尼形式，并说明 $K$ 的取法。

::: sol A6 核对
$$\dot{\boldsymbol q}=J^{*}\boldsymbol v_e,\qquad J^{*}=W^{-1}J^{\mathrm T}\big(JW^{-1}J^{\mathrm T}+K^{-1}\big)^{-1}.$$

$W=I$、$K=k^{-2}I$、$k>0$ 时得到经典**阻尼形式** $J^{*}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I)^{-1}$。奇点邻域可增大阻尼 $k$（减小误差权重 $K$），用任务误差换取较小的关节速度；行满秩且远离奇点时可减小 $k$，$k\to0^+$ 时趋于右伪逆。误差为 $\delta=\boldsymbol v_e-J\dot{\boldsymbol q}$。（[@def-3.5.2]）
:::

### A7 · 分析雅可比

分别写出两种雅可比的输出、维度及可逆换算条件。$T$ 的三列是什么？

::: sol A7 核对

$J,J_A\in\mathbb R^{6\times n}$ 分别满足 $[\dot p_e;\omega_e]=J\dot q$ 与 $[\dot p_e;\dot{\boldsymbol\varphi}_e]=J_A\dot q$。在同一参考点和表达系中，前三行相同；后三行分别是物理角速度和姿态坐标导数。

ZYZ的 $T$ 三列为基系表示的 $z,R_z(\varphi)y,R_z(\varphi)R_y(\vartheta)z$，它们按系数合成角速度。光滑坐标分支内 $J=T_AJ_A$，$T_A=\operatorname{diag}(I_3,T)$；$\det T=-\sin\vartheta\ne0$ 时 $J_A=T_A^{-1}J$。这些系数一般不是向三根轴的点积投影。（[@def-3.6.1]、[@thm-3.6.A]）

:::

## B. 结论卡

### B1 · 雅可比的行与列各代表什么

分别说明行、列的含义，并由此解释「为什么平面臂可以只取有效行」。

::: sol B1 核对
**行对应操作空间的速度分量，列对应关节**。所以 $J$ 的每一列可以单独理解（其余关节锁死、只驱动第 $i$ 个关节时末端的贡献），秩最多等于列数（自由度个数）。**按任务取行**：只关心位置时取 $J_P$，角速度另由 $J_O$ 给出。不能仅凭自由度为 3 就断言保留前三行不损失信息；在肩奇点，转腰的线速度为零而角速度不为零。只有 $J_P$ 可逆且位形已知时，才可由线速度恢复关节速度。（[3.2.2](sec3-2.md#sec-3.2.2)）
:::

### B2 · 奇点的三类后果

用列空间、零空间和最小奇异值说明三类后果；哪些结论只描述瞬时速度？

::: sol B2 核对
① **可达速度方向减少**：期望速度不在 $\mathcal R(J)$ 内时，速度方程无解。② **瞬时速度解不唯一**：若存在特解且 $\mathcal N(J)\ne\{0\}$，加上任意零空间速度仍是解；这本身不能证明固定末端位姿有连续无穷多个位置逆解。③ **邻域放大**：最小奇异值很小时，沿其输出方向的速度指令需要很大的关节速度；零指令不必放大。三者都要结合任务判断，不能给出脱离指令与限速的统一危险排序。（[3.3.1](sec3-3.md#sec-3.3.1)）
:::

### B3 · 六轴臂的奇点解耦（能做什么、不能做什么）

写出行列式拆解式与三个具体条件，并说清适用边界。

::: sol B3 核对
对本节六轴「臂（关节 $1,2,3$）+ 球形腕（关节 $4,5,6$）」构型，把参考点从末端挪到**腕心** $\boldsymbol p_w$，雅可比分块为下三角：

$$\begin{bmatrix}\dot{\boldsymbol p}_w\\ \boldsymbol\omega_e\end{bmatrix}=\begin{bmatrix}J_{11}&0\\ J_{21}&J_{22}\end{bmatrix}\begin{bmatrix}\dot{\boldsymbol q}_a\\ \dot{\boldsymbol q}_w\end{bmatrix},\qquad \det J=\det J_{11}\cdot\det J_{22}.$$

**三个条件**：**腕奇点** $\det J_{22}=(z_3\times z_4)\cdot z_5\propto s_5$ ⇒ $s_5=0$（$\vartheta_5=0,\pi$，腕 4、6 轴共线，属**内部奇点**）；**肘奇点** $s_3=0$（$\vartheta_3=0$ 伸直 / $\pi$ 折回，属**边界奇点**）；**肩奇点** $a_2c_2+a_3c_{23}=0$（腕中心落在 $z_0$ 轴上，$J_P$ 第一列 $z_0\times\boldsymbol p_w=\boldsymbol 0$，完整几何雅可比的角速度部分并不为零；只定位腕心时，腰角可任取）。**适用边界**：六轴球腕，以腕心为参考点的完整六维映射与工具点映射通过可逆矩阵相连，保留秩和行列式。控制腕心可直接用它；控制工具点须先转换速度。（[@thm-3.3.A]）
:::

### B4 · 任务条件与逆速度工具

列出直接逆、右伪逆闭式与DLS的条件和求解目标。为什么不能把它们理解成三个互斥分支？

::: sol B4 核对
| 条件与目标 | 工具 | 解的性质 |
|:--|:--|:--|
| 方阵满秩（$r=n$），精确求当前速度 | $J^{-1}$，再数值积分 | 唯一精确速度；有限步积分仍可能产生位姿误差 |
| 冗余且行满秩（$r<n$），选最小范数速度 | $J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$，可加 $P\dot q_0$ | 伪逆项唯一最小范数；零空间项不改变当前任务速度 |
| 任意秩，权衡速度与残差 | $J^{*}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I_r)^{-1}$，$k>0$ | 增益不超过 $1/(2k)$；实际任务残差须计算 |

$W\succ0$ 时，$JW^{-1}J^{\mathrm T}$ 可逆当且仅当 $J$ 行满秩；再有 $K\succ0$，$JW^{-1}J^{\mathrm T}+K^{-1}$ 始终正定。一般Moore–Penrose伪逆在降秩时仍存在，提供最小范数的最小二乘解；DLS在满秩时也可用，二者都不能恢复缺失的方向。（[3.5.0](sec3-5.md#sec-3.5.0)–[3.5.2](sec3-5.md#sec-3.5.2)）
:::

### B5 · 角速率换算与表示奇点

从三根转轴写出 $T$；取 $\varphi=0$、固定 $\omega_e=(1,0,0)^{\mathrm T}$ 时，$\vartheta$ 趋近0会发生什么？这能说明机构奇异吗？

::: sol B5 核对

$$\omega_e=T\dot{\boldsymbol\varphi}_e,\qquad
T=\begin{bmatrix}0&-s_\varphi&c_\varphi s_\vartheta\\0&c_\varphi&s_\varphi s_\vartheta\\1&0&c_\vartheta\end{bmatrix}.$$

当 $\sin\vartheta\ne0$ 时，题设给出 $\dot{\boldsymbol\varphi}_e=(-\cot\vartheta,0,1/\sin\vartheta)^{\mathrm T}$。物理角速度保持1rad/s，参数速率却可很大；端点处 $T$ 第1、3列共线，固定这个代表不能提供唯一逆换算。是否机构奇异还须检查几何任务的秩，不能从坐标表示直接断定。

平面臂选 $(p_x,p_y,\alpha)$，$\alpha=\sum q_i$ 时 $\dot\alpha=\omega_z$，降维后的两种雅可比才相同；这不意味着一般三维ZYZ的三轴重合。$\omega$ 各分量可以积分，但仅保留三个积分值不足以恢复旋转顺序及最终姿态。（[§3.6](sec3-6.md)）

:::

### B6 · 逆方案 vs 转置方案

写出两式，并说明为什么转置方案不能按"完全线性化"设计增益。

::: sol B6 核对

设 $e=x_d-k(q)$、$J_A=\partial k/\partial q$，所以 $\dot e=\dot x_d-J_A\dot q$。

- 逆方案：解 $J_A\dot q=\dot x_d+Ke$。方阵可逆时为 $\dot q=J_A^{-1}(\dot x_d+Ke)$，回代得 $\dot e=-Ke$；常对称正定 $K$ 给连续误差的指数衰减。轨迹须保持光滑可逆；行满秩冗余时可用右伪逆加零空间速度。
- 转置方案：固定目标取 $V=\tfrac12e^{\mathrm T}Ke$，$\nabla_qV=-J_A^{\mathrm T}Ke$，故令 $\dot q=J_A^{\mathrm T}Ke$。回代为 $\dot e=-J_AJ_A^{\mathrm T}Ke$，并有 $\dot V=-\|J_A^{\mathrm T}Ke\|^2$。区域内行满秩且最小奇异值有正下界才得到统一衰减估计；降秩可有非零误差驻点。转置本来就能用于长方矩阵。

二阶方案对速度式求导得到 $\ddot x=J_A\ddot q+\dot J_A\dot q$，再解 $J_A\ddot q=\ddot x_d+K_D\dot e+K_Pe-\dot J_A\dot q$。回代后才有 $\ddot e+K_D\dot e+K_Pe=0$；$\dot J_A$ 补偿在关节算法中被抵消。有限步积分另需检查步长。（[§3.7.1](sec3-7.md#sec-3.7.1)、[§3.7.2](sec3-7.md#sec-3.7.2)、[§3.7.4](sec3-7.md#sec-3.7.4)）

:::

### B7 · 奇点为什么必须在**规划**层回避（而不是调算法）

给出两条机制说明，并列出工程上已有的两类规避手段。

::: sol B7 核对
困难方向的速度指令可能在近奇点要求很大的关节速度，放大取决于最小奇异值；零指令或避开困难方向的指令不必发散。规划绕行、适当减速和容许受控误差是不同处理方式，算法不改变机构在固定任务下的实际秩。

:::

### B8 · 可操作度与 $\dot{\boldsymbol q}_0$ 的三种取法

写出可操作度的定义、它与奇点的关系，以及 $\dot{\boldsymbol q}_0$ 的三种取法。

::: sol B8 核对
先定义标量函数 $g(q)$，再取 $\dot q_0=k_0\nabla g$，投影后用作次任务速度。常见目标有可操作度、远离关节极限、远离障碍。$w=\sqrt{\det(JJ^{\mathrm T})}$ 表示选定单位与度量下速度椭球的体积比例；方阵时为 $|\det J|$，不能漏掉绝对值。体积大不保证最短半轴大，因此 $w$ 不是到奇异集合的通用距离，也不能保证避开奇点；最困难方向应结合 $\sigma_{\min}$ 检查。（[3.5.1](sec3-5.md#sec-3.5.1)）
:::

## C. 公式卡

### C1 · 旋转矩阵求导与共轭恒等式

写出 $\dot R$ 的推导两步、$S$ 的识别过程与共轭恒等式。

::: sol C1 核对
**推导**：由 $RR^{\mathrm T}=I$ 两边求导 ⇒ $\dot RR^{\mathrm T}+R\dot R^{\mathrm T}=0$；记 $S\triangleq\dot RR^{\mathrm T}$ 则 $S+S^{\mathrm T}=0$（反对称）；两边**右乘 $R$** 得 $\dot R=S\,R$。**识别 $S$**：对常模向量取 $\boldsymbol p(t)=R(t)\boldsymbol p'$，一方面 $\dot{\boldsymbol p}=S R\boldsymbol p'$，另一方面力学给 $\dot{\boldsymbol p}=\boldsymbol\omega\times\boldsymbol p=\boldsymbol\omega\times R\boldsymbol p'$；两式对任意 $\boldsymbol p'$ 成立 ⇒ $S=S(\boldsymbol\omega)$。例如 $R_z(\alpha)$ 要先逐元素求 $\dot R_z$，再算 $\dot R_zR_z^{\mathrm T}$；$\dot R_z$ 本身一般不是反对称。**李代数口径**：$SO(3)$ 是有限旋转的群，$so(3)$ 是反对称矩阵的三维向量空间，$S$ 与 $\vee$ 只是线性对应；李括号为 $[A,B]=AB-BA$，满足 $[S(a),S(b)]=S(a\times b)$。**共轭恒等式**：$R\,S(\boldsymbol\omega)\,R^{\mathrm T}=S(R\boldsymbol\omega)$——「先叉乘再旋转 = 先旋转再叉乘」（[3.1.2](sec3-1.md#sec-3.1.2) 的角速度递推立刻用到它）。**两个摘帽结果**：$\boldsymbol\omega=(\dot RR^{\mathrm T})^\vee$（基系读数）、$\boldsymbol\omega'=R^{\mathrm T}\boldsymbol\omega=(R^{\mathrm T}\dot R)^\vee$（刚体系读数）。这里相对角速度先在局部系写成 $\boldsymbol\omega_{i-1,i}^{i-1}$，变到基系要乘 $R_{i-1}$。（[@thm-3.1.A]、[@thm-3.1.B]、[@note-3.1.lie]）
:::

### C2 · 几何雅可比的逐列构造（绿框，必须默写）

写出转动关节列与移动关节列，并说明 $z_{i-1},p_{i-1}$ 从哪里读。

::: sol C2 核对
$$J=\begin{bmatrix}J_1&\cdots&J_n\end{bmatrix},\qquad J_i=\begin{bmatrix}J_{P_i}\\ J_{O_i}\end{bmatrix},\qquad
\begin{cases}\text{关节 } i \text{ 转动：}& J_{P_i}=z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1}),\quad J_{O_i}=z_{i-1}\\[1mm] \text{关节 } i \text{ 移动：}& J_{P_i}=z_{i-1},\quad J_{O_i}=\boldsymbol 0\end{cases}$$

**物理解读**：其余关节全部锁死、只以单位速度驱动第 $i$ 个关节，末端产生的速度就是第 $i$ 列。**量的出处**：$z_{i-1}=R_{i-1}$（$T_{i-1}^0$ 左上 $3\times3$ 块）的第三列；$p_{i-1}$ 取 $T_{i-1}^0$ 第四列前三行；$\boldsymbol p_e$ 取 $T_e^0=T_n^0T_e^n$ 第四列前三行，只有末端点与第 $n$ 系原点重合时才可直接取 $T_n^0$。**坐标变换**：若 $R^u$ 把基系分量变成 $u$ 系分量（$v^u=R^u v^0$），则 $J^u=\begin{bmatrix}R^u&0\\0&R^u\end{bmatrix}J$，此式只变换同一末端点速度向量的表达基。（[@thm-3.1.C]）
:::

### C3 · 平面两连杆臂的雅可比与行列式

写出 $\bar J$ 与 $\det\bar J$，并写出拟人臂的三行版本。

::: sol C3 核对
**平面两连杆**：

$$\bar J=\begin{bmatrix}-a_1s_1-a_2s_{12}&-a_2s_{12}\\ a_1c_1+a_2c_{12}&a_2c_{12}\end{bmatrix},\qquad
\det\bar J=a_1a_2\sin\vartheta_2 .$$

**三连杆平面臂**：从完整 $6\times3$ 几何雅可比取第 1、2、6 行，得到平面位姿任务的 $3\times3$ 矩阵；前两行为位置偏导，第三行为 $[1\ 1\ 1]$。若只要求位置，则只取前两行。**拟人臂**（$3\times3$ 位置任务块）：

$$\bar J=\begin{bmatrix}-s_1(a_2c_2+a_3c_{23})&-c_1(a_2s_2+a_3s_{23})&-c_1a_3s_{23}\\
c_1(a_2c_2+a_3c_{23})&-s_1(a_2s_2+a_3s_{23})&-s_1a_3s_{23}\\
0&a_2c_2+a_3c_{23}&a_3c_{23}\end{bmatrix},\qquad
\det\bar J=-a_2a_3\,s_3\,(a_2c_2+a_3c_{23}).$$

两个因子分别对应肘伸直 / 折回（$s_3=0$）与腕点落到腰轴（$a_2c_2+a_3c_{23}=0$）。这是位置任务的奇异条件；完全等长折回到原点时，不能按通常的内边界归类，见 [3.3](sec3-3.md)。第三行是余弦组合，见[勘误 E3.1](errata.md#errata-3.1)。
:::

### C4 · 静力学对偶 $\boldsymbol\tau=J^{\mathrm T}F_e$

写出定义、用虚功原理推一遍，并说明为什么是转置而不是逆。

::: sol C4 核对
$$F_e=\begin{bmatrix}\boldsymbol f_e\\ \boldsymbol\mu_e\end{bmatrix}\in\mathbb R^6,\qquad \boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\,F_e .$$

**虚功推导**：$F_e$ 取机械臂向环境施加的广义力，环境反作用力为 $-F_e$，且与 $J$ 同系、同末端参考点。由 $\mathrm d\boldsymbol x_e=J\,\mathrm d\boldsymbol q$，静力平衡时总虚功为 $(\boldsymbol\tau^{\mathrm T}-F_e^{\mathrm T}J)\mathrm d\boldsymbol q=0$。对任意虚位移成立，故 $\boldsymbol\tau^{\mathrm T}=F_e^{\mathrm T}J$，取转置即得。忽略其他负载；若使用环境施力，驱动力矩前应带负号。**为什么是转置**：能量必须守恒——$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau=\boldsymbol v_e^{\mathrm T}F_e=(J\dot{\boldsymbol q})^{\mathrm T}F_e=\dot{\boldsymbol q}^{\mathrm T}J^{\mathrm T}F_e$，对任意 $\dot{\boldsymbol q}$ 成立。**这就是「速度与力的变换互为转置（对偶）」**；$J$ 是长方阵时也照样成立（**无需方阵、无需满秩**）。（[@def-3.8.1]）
:::

### C5 · 两坐标系间的速度 / 力变换对偶

写出速度变换与力变换两式，并指出对偶体现在哪里。

::: sol C5 核对
$$\begin{bmatrix}\dot{\boldsymbol p}_1^0\\ \boldsymbol\omega_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&-R_1^0S(\tilde{\boldsymbol p})\\ 0&R_1^0\end{bmatrix}\begin{bmatrix}\boldsymbol v_1\\ \boldsymbol\omega_1\end{bmatrix},\qquad
\begin{bmatrix}\boldsymbol f_1^0\\ \boldsymbol\mu_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&0\\ R_1^0S(\tilde{\boldsymbol p})&R_1^0\end{bmatrix}\begin{bmatrix}\boldsymbol f_1\\ \boldsymbol\mu_1\end{bmatrix}.$$

**力的变换矩阵恰是速度变换矩阵的转置**。**对偶的具体体现**：平移耦合项 $S(\tilde{\boldsymbol p})$ 在**速度**块里带**负号**、在**力**块里**不带负号并移位**。**与 $J^u$ 的分工**：$J^u$ 只改旋转块；这里还含**平移的耦合**。**使用纪律**：传感器、工件、工具各自的坐标系都不一样，**要先把力 / 速度统一到同一个坐标系，再谈平衡**。（[3.8.2](sec3-8.md#sec-3.8.2)）
:::

### C6 · 球腕奇点判据与两式

写出腕奇点的行列式判据与两个典型式。

::: sol C6 核对
$$\det J_{22}=(z_3\times z_4)\cdot z_5\propto s_5\qquad\Longrightarrow\qquad s_5=0\iff\vartheta_5=0\ \text{或}\ \pi .$$

**几何含义**：$\vartheta_5=0$ 时腕关节 4 与 6 的**轴共线**——转 $\vartheta_4$ 与转 $\vartheta_6$ 效果相同，**绕 z₃、z₄ 所张平面法向的角速度分量丢失**（典型的**内部奇点**）。**配套的臂侧判据**：$\det J_{11}=\det J_P=-a_2a_3s_3(a_2c_2+a_3c_{23})$（**与 $\vartheta_1$ 无关**）。（[3.3.3](sec3-3.md#sec-3.3.3)）
:::

### C7 · 冗余解族与 DLS 的极限行为

写出 $\dot{\boldsymbol q}=J^\dagger\boldsymbol v_e+(I-J^\dagger J)\dot{\boldsymbol q}_0$ 里两项的角色，以及 DLS 增益。

::: sol C7 核对
可行任务中，$J^\dagger v_e$ 是最小范数特解，$P\dot q_0$ 是零空间速度，$P=I-J^\dagger J=NN^{\mathrm T}$（$N$ 列标准正交）。加入后不增加所选任务的瞬时速度，不保证完整位姿或有限更新不变。

正奇异值的伪逆增益为 $1/\sigma$，$\sigma\to0^+$ 时可无界；在恰好为零的方向，Moore–Penrose增益取0。DLS增益是 $\sigma/(\sigma^2+k^2)$，$k>0$ 时峰值 $1/(2k)$；任务残差分量为 $k^2b_i/(\sigma_i^2+k^2)$，缺失方向仍留下完整指令残差。（[3.5.1](sec3-5.md#sec-3.5.1)、[3.5.2](sec3-5.md#sec-3.5.2)）
:::

### C8 · 微分运动学与静力学的"两个接口"

用一条链写出本章与前后章的两个接口。

::: sol C8 核对
$$\underbrace{\boldsymbol v_e=J(\boldsymbol q)\dot{\boldsymbol q}}_{\text{微分运动学}=J}\ \longleftrightarrow\ \underbrace{\boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)F_e}_{\text{静力学}=J^{\mathrm T}}\qquad\text{（同一个 }J\text{，一个正用、一个转置用）}.$$

**与第 2 章的接口**：$J$ 的每一列所需的 $z_{i-1},p_{i-1}$ **全部来自第 2 章正运动学的 $T$ 矩阵连乘**——「只要正运动学得到（对每个关节的），几何雅可比矩阵就都得到了」。**与第 4 章的接口**：$\dot{\boldsymbol q}$ 的两种用法——逆方案 / 转置方案分别对应后面对轨迹跟踪（要求线性化）与对力控制（$J^{\mathrm T}$ 传力）的需求。**与第 7、8 章的接口**：$\tau=J^{\mathrm T}F_e$ 是**静力**平衡式，一旦含惯性、科氏力就必须回到动力学方程。（[3.1.3](sec3-1.md#sec-3.1.3)、[3.8](sec3-8.md)）
:::

## D. 陷阱卡（先指出错在哪，再给正确说法）

### D1 · 「$z_{i-1}$ 就是 $[0,0,1]^{\mathrm T}$」

::: sol D1 核对
**错在预设数值。** $z_{i-1}$ 是基系表示，应取 $R_{i-1}$（$T_{i-1}^0$ 左上 $3\times3$ 块）的第三列。它在局部系中才按建系约定为 $[0,0,1]^{\mathrm T}$；平面臂各轴平行时，基系读数也可以恰好都等于这个向量。一般情况下要实际读取旋转矩阵。（[3.1.3](sec3-1.md#sec-3.1.3)）
:::

### D2 · 「转动关节里 $z_{i-1}$ 乘的矢径可以随便写」

::: sol D2 核对
**错，方向写反差一个负号。** 转动关节列是 $J_{P_i}=z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1})$，矢径必须从关节轴上的点指向末端。锁死其余关节、只驱动第 $i$ 个，末端速度垂直于矢径，由右手准则定符号。**数值自查**：第 $i$ 列用 $[p_e(q+\varepsilon e_i)-p_e(q-\varepsilon e_i)]/(2\varepsilon)$；整组速度则用 $[p_e(q+h\dot q)-p_e(q-h\dot q)]/(2h)$ 对拍 $J_P\dot q$，不能混淆列偏导与方向导数。（[3.1.3](sec3-1.md#sec-3.1.3)）
:::


### D3 · 「奇点是个数值 bug，换算法就好了」

::: sol D3 核对
奇点是所选任务的雅可比在特定位形下降秩。平行轴不必导致列相关，冗余列相关也不必降秩。数值方法可以平衡误差与速度，但不能恢复机构缺失的瞬时方向。

:::

### D4 · 「解耦矩阵可以直接拿去做逆解」

::: sol D4 核对
不能把工具点期望速度原样代入腕心雅可比；但可以用它控制腕心任务。若 r=pₑ−p_w，需用 v_w=vₑ+S(r)ω 转换。完整六维变换可逆，保留秩与行列式。

:::

### D5 · 「$J^{-1}$、$J^\dagger$、$J^*$ 随便用一个都行」

::: sol D5 核对
**错，条件和目标须分别判断。** $J^{-1}$ 要求方阵满秩；$J^{\mathrm T}(JJ^{\mathrm T})^{-1}$ 这个右伪逆闭式要求行满秩，一般Moore–Penrose伪逆并没有此限制。DLS以正阻尼限制增益，同时允许任务残差；它在满秩时也能使用。既不能对长方阵求普通逆，也不能将“闭式失效”说成“只能用DLS”。（[3.5](sec3-5.md)）
:::

### D6 · 「末端受力时，用 $J^{-1}$ 或 $J^\dagger$ 传到关节去」

::: sol D6 核对
**错。** 力变换是 $J^{\mathrm T}$（**对偶**），不是求逆：$\boldsymbol\tau=J^{\mathrm T}F_e$，来自虚功原理 / 功率守恒，**$J$ 是长方阵时同样成立**。**连带的两条纪律**：① $F_e$ 与 $J$ 必须在**同一坐标系**下——传感器测得的力要先用 [3.8.2](sec3-8.md#sec-3.8.2) 的转置对偶关系变换到基系；② 它只是**静力**平衡式——一旦含惯性、科氏力，就必须回到动力学方程。（[3.8](sec3-8.md) 常见错误 1、2、3）
:::

### D7 · 「转置方案按完全线性化设计增益也没问题」

::: sol D7 核对

错。固定目标下 $\dot q=J_A^{\mathrm T}Ke$ 给 $\dot e=-J_A(q)J_A(q)^{\mathrm T}Ke$，衰减速率随位形变化。由 $V=\tfrac12e^{\mathrm T}Ke$ 得 $\dot V=-\|J_A^{\mathrm T}Ke\|^2$；不能把它当成 $\dot e=-Ke$。

例如 $x=q$、移动目标 $x_d=vt$ 时，纯转置反馈给 $\dot e=v-ke$，一般留下 $v/k$ 偏差。固定目标的下降证明不能原样用于移动目标。即使逆方案连续时间精确抵消，显式欧拉在线性任务中也要满足 $0<hk<2$；正增益不代表任意步长都稳定。（[§3.7.1](sec3-7.md#sec-3.7.1)、[§3.7.2](sec3-7.md#sec-3.7.2)）

:::

## 导出到 Anki / CSV

1. **建卡组与录入**：Anki → 新建卡组「ROBOT-第 3 章」（与「ROBOT-全书」并列，勿混入默认卡组）；正面放「编号 + 题干」、背面放「核对答案 + 依据（[@def-…] / 章节链接）」，纯文本导入用 `Tab` 分隔正反面、一行一张（本页 30 张按 A1–A7 / B1–B8 / C1–C8 / D1–D7 顺序录入）。
2. **复习节点（1 / 3 / 7 天）**：**当天 → 第 1 天（隔天）→ 第 3 天 → 第 7 天**，共四轮，每轮只重做标 **△** 与 **×** 的卡；四轮后仍未「✓」的卡，抄进 [errata.md](errata.md) 的待核实条目或自己的薄弱点清单单独跟踪。
3. **加一道保险**：**C2（逐列构造）与 C4（静力对偶）必须能默写**——老师明说这两处「肯定是要考的」（1:05:52）与「主要是记住这个公式就可以」（0:25:53）。默写完请**配一个两自由度的实例**（随手写一组 $a_i,\vartheta_i$）把 $J$ 组装一遍，并代入 $\tau=J^{\mathrm T}F_e$ 算一遍量纲。
