# 闭卷回忆卡 · 第三章：微分运动学和静力学

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。全章共 30 张卡（定义 7 / 结论 8 / 公式 8 / 陷阱 7），一轮约 40 分钟。

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起。下一轮只重做 △ 与 ×。本章按老师的考试权重分为两块——**雅可比（3.1–3.2）与静力学（3.8）是必考**，其余各节按「精读 / 浏览」区分投入。

## A. 定义卡

### A1 · 微分运动学方程与几何雅可比

写出六维速度向量的构成与方程，并说明 $\boldsymbol\omega_e$ 的分量相对哪个坐标系。

::: note A1 核对
末端执行器速度取六维堆叠 $\boldsymbol v_e=\begin{bmatrix}\dot{\boldsymbol p}_e\\ \boldsymbol\omega_e\end{bmatrix}$（3 平动 + 3 转动），微分运动学方程为

$$\begin{bmatrix}\dot{\boldsymbol p}_e\\ \boldsymbol\omega_e\end{bmatrix}=J(\boldsymbol q)\dot{\boldsymbol q}=\begin{bmatrix}J_P\\ J_O\end{bmatrix}\dot{\boldsymbol q},\qquad J\in\mathbb R^{6\times n}.$$

$J$ 称**几何雅可比矩阵**，是位形 $\boldsymbol q$ 的函数；$J_P$ 对应线速度、$J_O$ 对应角速度，各 $3\times n$。**$\boldsymbol\omega_e$ 的三个分量是末端角速度在基坐标系三根轴上的投影**——这句话是几何 / 分析雅可比分歧的根源。（[@def-3.1.1]）
:::


### A2 · 运动学奇点

写出方阵情形的判据，并说出它在本章出现两次的两种后果类别。

::: note A2 核对
使雅可比矩阵 $J(\boldsymbol q)$ **不满秩**的位形 $\boldsymbol q$ 称为**运动学奇点**；方阵情形的判据为 $\det J(\boldsymbol q)=0$。**开课引子**（老师原话思路）：「雅可比矩阵其中有两列**线性相关**，那么它就退化了、就奇异了。对机器人来说，两列线性相关就说明**这两个关节轴平行了**。」**按出现位置分类**：**边界奇点**（臂完全伸出 / 缩回，抵达工作空间边界，「不表示真正的缺陷」，避开边界即可）与**内部奇点**（出现在可达工作空间**内部**，产生条件是**两个或以上运动轴线共线**，「比较严重」，轨迹规划时一定要避开）。（[@def-3.3.1]）
:::

### A3 · 冗余（任务相关）

写出冗余的判据，并指出两个子空间各回答什么问题。

::: note A3 核对
当机械手自由度个数 $n$ **大于**描述给定任务所必需的变量个数 $r$ 时，称该机械手对给定任务**冗余**。操作空间维度 $m<n$ 时一定冗余；任务维度恒有 $r\le m\le6$。**冗余是任务相关的概念**：同一台机械手对某任务冗余、对另一任务可能非冗余（[@ex-3.4.A] 的三连杆平面臂即此）。**两个子空间**：**值域空间 $\mathcal R(J)$** 回答「哪些末端速度能做到」（不在其中的速度**不可能**用关节速度线性表出，方程无解）；**零空间 $\mathcal N(J)$** 回答「哪些关节速度不惊动末端」——冗余时 $\mathcal N(J)$ 必非空，存在 $n\times(n-r)$ 的列满秩矩阵 $N$ 使 $JN=0$。（[@def-3.4.1]）
:::

### A4 · 零空间投影与解族

写出 $P$ 的定义、秩与解族，以及证明只差哪一步。

::: note A4 核对
取 $\boldsymbol P=NN^{\mathrm T}$（**秩 $n-r$**）。若 $\dot{\boldsymbol q}^*$ 是 $v_e=J\dot{\boldsymbol q}$ 的一个特解、$\dot{\boldsymbol q}_0$ 是**任意**向量，则 $\dot{\boldsymbol q}^*+\boldsymbol P\dot{\boldsymbol q}_0$ **仍是方程的解**。**证明只有一步**：验证 $J\boldsymbol P\dot{\boldsymbol q}_0=JNN^{\mathrm T}\dot{\boldsymbol q}_0=(JN)N^{\mathrm T}\dot{\boldsymbol q}_0=0$——故 $\boldsymbol P\dot{\boldsymbol q}_0$ 落在 $\mathcal N(J)$ 里，对末端速度的贡献**恒为零**。**用途**：让机械手在执行任务的同时**重新配置**自身（提升灵巧性、避障、回避奇异、远离关节极限）。（[@thm-3.4.B]）
:::

### A5 · 右伪逆与最小范数解

写出 $J^\dagger$ 的表达式、它的性质，以及它与 $J^{-1}$ 的分工。

::: note A5 核对
$$\dot{\boldsymbol q}=J^{\mathrm T}(JJ^{\mathrm T})^{-1}\boldsymbol v_e=J^\dagger\boldsymbol v_e,\qquad J^\dagger\triangleq J^{\mathrm T}(JJ^{\mathrm T})^{-1}\ (r\times n).$$

它就是**右广义逆 / 伪逆**。验证 $JJ^\dagger\boldsymbol v_e=(JJ^{\mathrm T})(JJ^{\mathrm T})^{-1}\boldsymbol v_e=\boldsymbol v_e$——**确实满足约束**；而单权情形下的解又使关节速度范数**局部最小**，因此称为**最小范数解**。**三种处境的药**：方阵满秩 → $J^{-1}$（配数值积分）；长方冗余 → $J^\dagger$（+ 零空间项）；退化奇异 → $J^*$（阻尼）。口诀：**方阵求逆、矮胖求伪逆、退化加阻尼**。（[@def-3.5.1]）
:::

### A6 · 奇异情形的广义逆 $J^*$（DLS）

写出 $J^*$ 的表达式与经典阻尼形式，并说明 $K$ 的取法。

::: note A6 核对
$$\dot{\boldsymbol q}=J^{*}\boldsymbol v_e,\qquad J^{*}=W^{-1}J^{\mathrm T}\big(JW^{-1}J^{\mathrm T}+K^{-1}\big)^{-1}.$$

$W=I$、$K=k^2I$ 加权时即经典的**阻尼形式** $J^{*}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I)^{-1}$。**$K$ 的取法**：**奇点邻域内取足够大**——$K^{-1}$ 项占主导，把 $\det J\to0$ 引起的发散压住，奇异就变得可以容忍；**远离奇点则取小、甚至趋于 $0$**——此时公式退回 $J^{\mathrm T}(JJ^{\mathrm T})^{-1}$，而远离奇点处 $JJ^{\mathrm T}$ 可逆。**思路**：不再要求微分运动方程严格成立，而是容许 $\boldsymbol v_e$ 带一个小的误差 $\delta$（$\boldsymbol v_e-J\dot{\boldsymbol q}=\delta$），用**增广变量法**化为同型问题。（[@def-3.5.2]）
:::

### A7 · 分析雅可比

写出定义与它和几何雅可比的关系，并说明 $T$ 的三列是什么。

::: note A7 核对
**几何雅可比**（$J$）：逐列给出每个关节速度对末端**线速度与角速度**的贡献，角速度部分 $\boldsymbol\omega_e$ 是末端角速度在**基坐标系**三根轴上的分量。**分析雅可比** $J_A$：把正运动学对关节变量直接微分，姿态部分改用欧拉角 $\boldsymbol\varphi_e=[\varphi\ \vartheta\ \psi]^{\mathrm T}$（ZYZ）的时间导数 $\dot{\boldsymbol\varphi}_e$——**绕欧拉角所定义转轴的旋转速度**。关系：$J_A=T_A^{-1}(\boldsymbol\varphi_e)J$，$T_A=\begin{bmatrix}I_3&0\\0&T(\boldsymbol\varphi_e)\end{bmatrix}$，其中 $T$ 的三列就是**三根瞬时转轴在基系中的方向**（$z$、转 $\varphi$ 后的 $y'$、再转 $\vartheta$ 后的 $z''$），**未必正交**。（[@def-3.6.1]、[@thm-3.6.A]）
:::

## B. 结论卡

### B1 · 雅可比的行与列各代表什么

分别说明行、列的含义，并由此解释「为什么平面臂可以只取有效行」。

::: note B1 核对
**行对应操作空间的速度分量，列对应关节**。所以 $J$ 的每一列可以单独理解（其余关节锁死、只驱动第 $i$ 个关节时末端的贡献），秩最多等于列数（自由度个数）。**推论**：只有 3 个自由度的拟人臂在 6 维操作空间里至多张出 3 维子空间，因此丢掉相关的行**不损失信息**——保留下来的三行（$v_x,v_y,v_z$）恰好构成「臂部」的有效映射。这一「**按任务取行**」的思想在 [3.4](sec3-4.md) 的冗余分析里就是正式工具（$r$ 就是取的行数）。（[3.2.2](sec3-2.md#sec-3.2.2)、[3.3.1](sec3-3.md#sec-3.3.1)）
:::

### B2 · 奇点的三类后果

写出三类后果，并按危险程度排序说明理由。

::: note B2 核对
① **运动退化**：处于奇点时无法让末端朝任意方向运动——两关节轴平行（两列线性相关）时，垂直于该平面的方向的速度分量「造不出来」；② **解不唯一**：逆解可能存在**无穷多组**（拟人臂的腕点落在肩轴线上时，无论肩关节角怎么转该点都不动）；③ **邻域放大**（**三类中最危险**）：奇点**邻域内**，操作空间里很小的速度可能要求关节空间给出**极高的速度**。定量说法：$J^{-1}=\operatorname{adj}J/\det J$，$\det J\to0$ 时逆矩阵元素整体趋于无穷。（[3.3.1](sec3-3.md#sec-3.3.1)）
:::

### B3 · 六轴臂的奇点解耦（能做什么、不能做什么）

写出行列式拆解式与三个具体条件，并说清适用边界。

::: note B3 核对
对「臂（关节 $1\dots n-3$）+ 球形腕（$n-2\dots n$）」构型，把参考点从末端挪到**腕心** $\boldsymbol p_w$，雅可比分块为下三角：

$$\begin{bmatrix}\dot{\boldsymbol p}_w\\ \boldsymbol\omega_e\end{bmatrix}=\begin{bmatrix}J_{11}&0\\ J_{21}&J_{22}\end{bmatrix}\begin{bmatrix}\dot{\boldsymbol q}_a\\ \dot{\boldsymbol q}_w\end{bmatrix},\qquad \det J=\det J_{11}\cdot\det J_{22}.$$

**三个条件**：**腕奇点** $\det J_{22}=(z_{n-2}\times z_{n-1})\cdot z_n\propto s_5$ ⇒ $s_5=0$（$\vartheta_5=0,\pi$，腕 4、6 轴共线，属**内部奇点**）；**肘奇点** $s_3=0$（$\vartheta_3=0$ 伸直 / $\pi$ 折回，属**边界奇点**）；**肩奇点** $a_2c_2+a_3c_{23}=0$（腕中心落在 $z_0$ 轴上，$J$ 第一列 $z_0\times\boldsymbol p_w=\boldsymbol 0$ 整列为零、逆解无穷多解）。**适用边界**：下三角矩阵**只保行列式**，用于奇点分析——**不能**拿去做逆解或速度控制（不保「末端」语义）。（[@thm-3.3.A]）
:::

### B4 · 三种「不方 / 退化」各配什么工具

按 $J$ 的形状列出三套答案，并各说一句适用理由。

::: note B4 核对
| $J$ 的形状 | 工具 | 适用理由 |
|:--|:--|:--|
| 方阵满秩（$r=n$） | $J^{-1}$ + 数值积分 $\boldsymbol q(t_{k+1})\approx\boldsymbol q(t_k)+J^{-1}\boldsymbol v_e\Delta t$ | 「不受方程结构是否可解的影响，没有解析解也能解」 |
| 长方矮胖（$r<n$，冗余） | $J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$ + 零空间项 $\boldsymbol P\dot{\boldsymbol q}_0$ | 一次给出**最小范数**解；第二项管内部姿态 |
| 退化（奇异） | $J^{*}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I)^{-1}$（DLS） | 容许小误差换回**可解性**，把 $\det J\to0$ 的发散压住 |

**一个共同前提**：$JW^{-1}J^{\mathrm T}$ 可逆 ⇔ $J$ **行满秩**（无奇异）；到奇点情形老配方失效，必须换 DLS——而 DLS 的 $JW^{-1}J^{\mathrm T}+K^{-1}$ 因 $K^{-1}$ 项**在奇异时仍可逆**，这正是它治奇点的机制。（[3.5.0](sec3-5.md#sec-3.5.0)–[3.5.2](sec3-5.md#sec-3.5.2)）
:::

### B5 · 同一个角速度、两种读数

写出换基矩阵与两句口诀，并说明 $J$ 与 $J_A$ 在哪几行必然相同。

::: note B5 核对
$$\boldsymbol\omega_e=T(\boldsymbol\varphi)\dot{\boldsymbol\varphi}_e,\qquad
T(\boldsymbol\varphi)=\begin{bmatrix}0&-s_\varphi&s_\vartheta c_\varphi\\ 0&c_\varphi&s_\vartheta s_\varphi\\ 1&0&c_\vartheta\end{bmatrix}\ (\text{ZYZ}),\qquad J_A=T_A^{-1}J .$$

**诀窍**：把 $T$ 读作「**三根瞬时转轴在基系中的方向排成的矩阵**」——一个向量（角速度）、两组「坐标」：在正交基里读数得几何雅可比的后三行，在非正交基（$z,y',z''$）里读数得 $\dot{\boldsymbol\varphi}$。**口诀**：**位置部分同、姿态部分异；几何看得见（$\boldsymbol\omega$ 有分量）、分析可积分（$\dot{\boldsymbol\varphi}$ 可积分）**。**必然相同的部分**：前三行（线速度）——$\dot{\boldsymbol p}_e$ 对 $\boldsymbol q$ 直接求偏导的结果与逐列构造的结果一致。**一致的特例**：平面臂（欧拉角轴与固定轴重合，不存在换基问题）。（[@thm-3.6.A]、[3.6.3](sec3-6.md#sec-3.6.3)）
:::

### B6 · 逆方案 vs 转置方案

写出两式，并说明为什么转置方案不能按"完全线性化"设计增益。

::: note B6 核对
**逆雅可比方案**：$\dot{\boldsymbol q}=J_A^{-1}(\boldsymbol q)\big(\dot{\boldsymbol x}_d+K\boldsymbol e\big)$，代入得 $\dot{\boldsymbol e}=\dot{\boldsymbol x}_d-J_A\dot{\boldsymbol q}=-K\boldsymbol e$ ⇒ 误差动态被化成**一阶线性系统**，$K$ 正定即指数收敛（**完全线性化**，代价是每次要求逆、计算贵）。
**雅可比转置方案**：$\dot{\boldsymbol q}=J^{\mathrm T}K\boldsymbol e$，省去求逆（「$J^{-1}$ 很花时间；用 $J^{\mathrm T}$ 直接调换一下元素位置就可以了」），但误差动态是**非线性**的——多出含 $J$ 随位形变化的项，稳定性只能借助 **Lyapunov 函数**分析，收敛只是**局部**的。**二阶算法**：$\ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e=0$，把加速度也纳入，误差方程里出现 $\dot J(\boldsymbol q)$ 项。（[3.7.1](sec3-7.md#sec-3.7.1)–[3.7.3](sec3-7.md#sec-3.7.3)）
:::

### B7 · 奇点为什么必须在**规划**层回避（而不是调算法）

给出两条机制说明，并列出工程上已有的两类规避手段。

::: note B7 核对
**两条机制**：① $\det J\to0$ 时 $J^{-1}=\operatorname{adj}J/\det J$ 的元素整体趋于无穷——**反解出来的关节速度也趋近无穷大**；② 奇点邻域同样危险——$\det J\neq0$ 但很小时，逆矩阵元素已经巨大，**「离奇点多远」要按 $\det J$ 的大小判断，不是按是否等于零**。**两类工程手段**（课堂视频）：**变速度**（在奇点附近自动降速）与**自动规避**（不严格遵循设定轨迹，在奇点附近容忍较大的轨迹跟踪误差）；算法层面还可用 DLS 换回可解性。**根本原因**：奇点是**结构的几何属性**（轴共线 / 腕点落轴），换算法、换精度都躲不掉，只有规划绕开或结构上避免。（[3.3.1](sec3-3.md#sec-3.3.1)）
:::

### B8 · 可操作度与 $\dot{\boldsymbol q}_0$ 的三种取法

写出可操作度的定义、它与奇点的关系，以及 $\dot{\boldsymbol q}_0$ 的三种取法。

::: note B8 核对
先定义标量函数 $g(\boldsymbol q)$，再取 $\dot{\boldsymbol q}_0=k_0\left(\dfrac{\partial g(\boldsymbol q)}{\partial\boldsymbol q}\right)^{\mathrm T}$（沿梯度方向）。**三种取法即三个 $g$**：① **可操作度**（最大化）$g=w(\boldsymbol q)=\sqrt{\det(JJ^{\mathrm T})}$——$w$ 在奇点位形处为零，方阵情形直接算 $\det J$、长方阵则算 $\det(JJ^{\mathrm T})$ 再开方，「离零越远离奇点越远」，最大化 $w$ 就是**远离奇异**；② **与关节极限的距离**（最大化，让各关节角靠近行程中点）；③ **与障碍物的距离**（最大化，取机械臂上所有点与障碍物距离的**最小值**）。**这套做法成立的根据**：「为什么能优化？因为冗余——不是一个解，有很多个解，可以把目标转化成优化问题」。（[3.5.1](sec3-5.md#sec-3.5.1)）
:::

## C. 公式卡

### C1 · 旋转矩阵求导与共轭恒等式

写出 $\dot R$ 的推导两步、$S$ 的识别过程与共轭恒等式。

::: note C1 核对
**推导**：由 $RR^{\mathrm T}=I$ 两边求导 ⇒ $\dot RR^{\mathrm T}+R\dot R^{\mathrm T}=0$；记 $S\triangleq\dot RR^{\mathrm T}$ 则 $S+S^{\mathrm T}=0$（反对称）；两边**右乘 $R$** 得 $\dot R=S\,R$。**识别 $S$**：对常模向量取 $\boldsymbol p(t)=R(t)\boldsymbol p'$，一方面 $\dot{\boldsymbol p}=S R\boldsymbol p'$，另一方面力学给 $\dot{\boldsymbol p}=\boldsymbol\omega\times\boldsymbol p=\boldsymbol\omega\times R\boldsymbol p'$；两式对任意 $\boldsymbol p'$ 成立 ⇒ $S=S(\boldsymbol\omega)$。**共轭恒等式**：$R\,S(\boldsymbol\omega)\,R^{\mathrm T}=S(R\boldsymbol\omega)$——「先叉乘再旋转 = 先旋转再叉乘」（[3.1.2](sec3-1.md#sec-3.1.2) 的角速度递推立刻用到它）。**两个摘帽结果**：$\boldsymbol\omega=(\dot RR^{\mathrm T})^\vee$（基系读数）、$\boldsymbol\omega'=R^{\mathrm T}\boldsymbol\omega=(R^{\mathrm T}\dot R)^\vee$（刚体系读数）。（[@thm-3.1.A]、[@thm-3.1.B]）
:::

### C2 · 几何雅可比的逐列构造（绿框，必须默写）

写出转动关节列与移动关节列，并说明 $z_{i-1},p_{i-1}$ 从哪里读。

::: note C2 核对
$$J=\begin{bmatrix}J_1&\cdots&J_n\end{bmatrix},\qquad J_i=\begin{bmatrix}J_{P_i}\\ J_{O_i}\end{bmatrix},\qquad
\begin{cases}\text{关节 } i \text{ 转动：}& J_{P_i}=z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1}),\quad J_{O_i}=z_{i-1}\\[1mm] \text{关节 } i \text{ 移动：}& J_{P_i}=z_{i-1},\quad J_{O_i}=\boldsymbol 0\end{cases}$$

**物理解读**（写这条公式时脑子里要有的画面）：**其余关节全部锁死、只以单位速度驱动第 $i$ 个关节**，末端产生的速度就是第 $i$ 列。**所需量的出处全部在正运动学**：$z_{i-1}=R_{i-1}$（即 $T_{i-1}^0$ 左上 $3\times3$ 块）的**第三列**；$p_{i-1}$ = $T_{i-1}^0$ 第四列前三行；$\boldsymbol p_e$ = $T_n^0$ 第四列前三行。**坐标变换**：$J^u=\begin{bmatrix}R^u&0\\0&R^u\end{bmatrix}J$。（[@thm-3.1.C]）
:::

### C3 · 平面两连杆臂的雅可比与行列式

写出 $\bar J$ 与 $\det\bar J$，并写出拟人臂的三行版本。

::: note C3 核对
**平面两连杆**：

$$\bar J=\begin{bmatrix}-a_1s_1-a_2s_{12}&-a_2s_{12}\\ a_1c_1+a_2c_{12}&a_2c_{12}\end{bmatrix},\qquad
\det\bar J=a_1a_2\sin\vartheta_2 .$$

**三连杆平面臂**（$3\times3$ 有效块）：前三行的形式逐列递推，第三行为 $[1\ 1\ 1]$。**拟人臂**（$3\times3$，力矩有效块）：

$$\bar J=\begin{bmatrix}-s_1(a_2c_2+a_3c_{23})&-c_1(a_2s_2+a_3s_{23})&-c_1a_3s_{23}\\
c_1(a_2c_2+a_3c_{23})&-s_1(a_2s_2+a_3s_{23})&-s_1a_3s_{23}\\
0&a_2c_2+a_3c_{23}&a_3c_{23}\end{bmatrix},\qquad
\det\bar J=-a_2a_3\,s_3\,(a_2c_2+a_3c_{23}).$$

**两个因子各自为零，正对应拟人臂的两类奇点**：$s_3=0$（肘伸直 / 折回，边界奇点）与 $a_2c_2+a_3c_{23}=0$（腕点落到 $z_0$ 轴上，肩奇点）。**第三行是余弦组合**——这一处的正余弦在转写中一度被读错，本编按课件绿框、教材式 (3.37)–(3.38) 与数值差分三源核对后采用余弦。（[勘误 E3.1](errata.md#errata-3.1)）
:::

### C4 · 静力学对偶 $\boldsymbol\tau=J^{\mathrm T}F_e$

写出定义、用虚功原理推一遍，并说明为什么是转置而不是逆。

::: note C4 核对
$$F_e=\begin{bmatrix}\boldsymbol f_e\\ \boldsymbol\mu_e\end{bmatrix}\in\mathbb R^6,\qquad \boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\,F_e .$$

**虚功推导**：设关节虚位移 $\mathrm d\boldsymbol q$，末端虚位移 $\mathrm d\boldsymbol x_e=J\,\mathrm d\boldsymbol q$。关节端做功 $\mathrm dW_\tau=\boldsymbol\tau^{\mathrm T}\mathrm d\boldsymbol q$，末端处外力做功 $-\boldsymbol F_e^{\mathrm T}J\,\mathrm d\boldsymbol q$；**静态平衡时系统总虚功为零** ⇒ $\boldsymbol\tau^{\mathrm T}=-\boldsymbol F_e^{\mathrm T}J$，取转置即得。**为什么是转置**：能量必须守恒——$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau=\boldsymbol v_e^{\mathrm T}F_e=(J\dot{\boldsymbol q})^{\mathrm T}F_e=\dot{\boldsymbol q}^{\mathrm T}J^{\mathrm T}F_e$，对任意 $\dot{\boldsymbol q}$ 成立。**这就是「速度与力的变换互为转置（对偶）」**；$J$ 是长方阵时也照样成立（**无需方阵、无需满秩**）。（[@def-3.8.1]）
:::

### C5 · 两坐标系间的速度 / 力变换对偶

写出速度变换与力变换两式，并指出对偶体现在哪里。

::: note C5 核对
$$\begin{bmatrix}\dot{\boldsymbol p}_1^0\\ \boldsymbol\omega_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&-R_1^0S(\tilde{\boldsymbol p})\\ 0&R_1^0\end{bmatrix}\begin{bmatrix}\boldsymbol v_1\\ \boldsymbol\omega_1\end{bmatrix},\qquad
\begin{bmatrix}\boldsymbol f_1^0\\ \boldsymbol\mu_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&0\\ R_1^0S(\tilde{\boldsymbol p})&R_1^0\end{bmatrix}\begin{bmatrix}\boldsymbol f_1\\ \boldsymbol\mu_1\end{bmatrix}.$$

**力的变换矩阵恰是速度变换矩阵的转置**。**对偶的具体体现**：平移耦合项 $S(\tilde{\boldsymbol p})$ 在**速度**块里带**负号**、在**力**块里**不带负号并移位**。**与 $J^u$ 的分工**：$J^u$ 只改旋转块；这里还含**平移的耦合**。**使用纪律**：传感器、工件、工具各自的坐标系都不一样，**要先把力 / 速度统一到同一个坐标系，再谈平衡**。（[3.8.2](sec3-8.md#sec-3.8.2)）
:::

### C6 · 球腕奇点判据与两式

写出腕奇点的行列式判据与两个典型式。

::: note C6 核对
$$\det J_{22}=(z_{n-2}\times z_{n-1})\cdot z_n\propto s_5\qquad\Longrightarrow\qquad s_5=0\iff\vartheta_5=0\ \text{或}\ \pi .$$

**几何含义**：$\vartheta_5=0$ 时腕关节 4 与 6 的**轴共线**——转 $\vartheta_4$ 与转 $\vartheta_6$ 效果相同，**绕垂直于该轴方向的角速度自由度丢失**（典型的**内部奇点**）。**配套的臂侧判据**：$\det J_{11}=\det J_P=-a_2a_3s_3(a_2c_2+a_3c_{23})$（**与 $\vartheta_1$ 无关**）。（[3.3.3](sec3-3.md#sec-3.3.3)）
:::

### C7 · 冗余解族与 DLS 的极限行为

写出 $\dot{\boldsymbol q}=J^\dagger\boldsymbol v_e+(I-J^\dagger J)\dot{\boldsymbol q}_0$ 里两项的角色，以及 DLS 增益。

::: note C7 核对
**两项各是什么**：第一项 $J^\dagger\boldsymbol v_e$ 是满足任务的最小范数特解（「**干活用的**」）；第二项 $(I-J^\dagger J)\dot{\boldsymbol q}_0$ 是**齐次解**——$P=I-J^\dagger J$ 是零空间投影矩阵，$JP\dot{\boldsymbol q}_0=(J-J)\dot{\boldsymbol q}_0=0$，故**不惊动末端**，**内部运动**正是由它描述（与 [@thm-3.4.B] 的 $P=NN^{\mathrm T}$ 同一角色、两种写法）。**DLS 增益**：横轴为奇异值 $\sigma$，伪逆的增益 $1/\sigma$ 在奇点处**发散**；DLS 的增益 $\dfrac{\sigma}{\sigma^2+k^2}$ **处处有界**，峰值只有 $1/(2k)$。（[3.5.1](sec3-5.md#sec-3.5.1)、[3.5.2](sec3-5.md#sec-3.5.2)）
:::

### C8 · 微分运动学与静力学的"两个接口"

用一条链写出本章与前后章的两个接口。

::: note C8 核对
$$\underbrace{\boldsymbol v_e=J(\boldsymbol q)\dot{\boldsymbol q}}_{\text{微分运动学}=J}\ \longleftrightarrow\ \underbrace{\boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)F_e}_{\text{静力学}=J^{\mathrm T}}\qquad\text{（同一个 }J\text{，一个正用、一个转置用）}.$$

**与第 2 章的接口**：$J$ 的每一列所需的 $z_{i-1},p_{i-1}$ **全部来自第 2 章正运动学的 $T$ 矩阵连乘**——「只要正运动学得到（对每个关节的），几何雅可比矩阵就都得到了」。**与第 4 章的接口**：$\dot{\boldsymbol q}$ 的两种用法——逆方案 / 转置方案分别对应后面对轨迹跟踪（要求线性化）与对力控制（$J^{\mathrm T}$ 传力）的需求。**与第 7、8 章的接口**：$\tau=J^{\mathrm T}F_e$ 是**静力**平衡式，一旦含惯性、科氏力就必须回到动力学方程。（[3.1.3](sec3-1.md#sec-3.1.3)、[3.8](sec3-8.md)）
:::

## D. 陷阱卡（先指出错在哪，再给正确说法）

### D1 · 「$z_{i-1}$ 就是 $[0,0,1]^{\mathrm T}$」

::: note D1 核对
**错。** $z_{i-1}$ 表示在**基坐标系**下，只有 $z_0$ 才是 $[0,0,1]^{\mathrm T}$；表示在它自己的坐标系下才是 $[0,0,1]$，表示在基坐标系下要乘很复杂的旋转矩阵。**正确做法**：$z_{i-1}=R_{i-1}$（$T_{i-1}^0$ 左上 $3\times3$ 块）的**第三列**，随位形变化。（[3.1.3](sec3-1.md#sec-3.1.3)）
:::

### D2 · 「转动关节里 $z_{i-1}$ 乘的矢径可以随便写」

::: note D2 核对
**错，方向写反差一个负号。** 转动关节列是 $J_{P_i}=z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1})$——矢径必须**从关节轴上的点 $p_{i-1}$ 指向末端 $p_e$**。物理图像：锁死其余关节、只驱动第 $i$ 个，则 $i\sim n$ 段连成一个刚体绕轴 $z_{i-1}$ 定轴转动，末端速度方向**垂直于矢径**、由右手准则定符号。**顺手的自由自查**：$J$ 的每一列要么形如 $\begin{bmatrix}z_{i-1}\times(\cdot)\\ z_{i-1}\end{bmatrix}$（转动）、要么形如 $\begin{bmatrix}z_{i-1}\\ \boldsymbol 0\end{bmatrix}$（移动），形状不对就说明组装错了；数值上可用中心差分 $\dot{\boldsymbol p}_e\approx(\boldsymbol p_e(\boldsymbol q+\delta\boldsymbol q)-\boldsymbol p_e(\boldsymbol q-\delta\boldsymbol q))/2\delta$ 抽查任一列。（[3.1.3](sec3-1.md#sec-3.1.3)）
:::


### D3 · 「奇点是个数值 bug，换算法就好了」

::: note D3 核对
**错。** 奇点是**结构的几何属性**——由「两列线性相关 ⇔ 两个关节轴平行 / 共线」或「腕点落在第一关节轴上」这类几何事实决定，**换算法、换精度都躲不掉**；只有规划绕开（变速度 / 自动规避）或结构上避免。**还要注意「邻域」二字**：$\det J\neq0$ 但很小时 $J^{-1}$ 元素已经巨大，**边界奇点附近的关节速度放大同样要规划规避**。（[3.3](sec3-3.md) 常见错误 1、3）
:::

### D4 · 「解耦矩阵可以直接拿去做逆解」

::: note D4 核对
**错。** 把参考点从末端挪到腕心后得到的下三角矩阵**只保行列式**，用于奇点分析；它**不再是「关节速度 → 末端执行器速度」的映射**，所以**不能**用来表示末端的位姿与速度、也不能拿去做逆解或速度控制。**合法性来源**：运动学奇点是机械结构固有特性、**与坐标系建在哪里无关**，故可为简化计算而重选参考系；但做完判断**必须换回末端参考**再谈速度传递。（[@thm-3.3.A] 的适用边界）
:::

### D5 · 「$J^{-1}$、$J^\dagger$、$J^*$ 随便用一个都行」

::: note D5 核对
**错，三者对应三种处境。** $J^{-1}$ 只对**方阵满秩**有意义（$r\times n$ 的长方阵**根本没有逆**——「不存在逆，就要用广义逆，这是线代 / 矩阵论的基础」）；$J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$ 要求 $J$ **行满秩**（无奇异）；$J^{*}$（DLS）才是奇点邻域的工具。**最容易犯的一条**：对冗余臂硬求 $J^{-1}$，或忘了 $JW^{-1}J^{\mathrm T}$ 可逆的前提是 $J$ 行满秩——一到奇点情形老配方就失效。（[3.5](sec3-5.md) 常见错误 1、2）
:::

### D6 · 「末端受力时，用 $J^{-1}$ 或 $J^\dagger$ 传到关节去」

::: note D6 核对
**错。** 力变换是 $J^{\mathrm T}$（**对偶**），不是求逆：$\boldsymbol\tau=J^{\mathrm T}F_e$，来自虚功原理 / 功率守恒，**$J$ 是长方阵时同样成立**。**连带的两条纪律**：① $F_e$ 与 $J$ 必须在**同一坐标系**下——传感器测得的力要先用 [3.8.2](sec3-8.md#sec-3.8.2) 的转置对偶关系变换到基系；② 它只是**静力**平衡式——一旦含惯性、科氏力，就必须回到动力学方程。（[3.8](sec3-8.md) 常见错误 1、2、3）
:::

### D7 · 「转置方案按完全线性化设计增益也没问题」

::: note D7 核对
**错。** 转置方案 $\dot{\boldsymbol q}=J^{\mathrm T}K\boldsymbol e$ 的误差动态是**非线性**的（多出含 $J$ 随位形变化的项），$K$ 取大不一定更好；稳定性只能借助 **Lyapunov 函数**分析，收敛只是**局部**的。只有**逆方案** $\dot{\boldsymbol q}=J_A^{-1}(\dot{\boldsymbol x}_d+K\boldsymbol e)$ 才把误差动态化成 $\dot{\boldsymbol e}=-K\boldsymbol e$ 那样的一阶线性系统（代价是每次求逆更贵）。**怎么记**：**逆方案能完全线性化，转置方案省计算但只局部收敛**。（[3.7.2](sec3-7.md#sec-3.7.2)）
:::

## 导出到 Anki / CSV

1. **建卡组与录入**：Anki → 新建卡组「ROBOT-第 3 章」（与「ROBOT-全书」并列，勿混入默认卡组）；正面放「编号 + 题干」、背面放「核对答案 + 依据（[@def-…] / 章节链接）」，纯文本导入用 `Tab` 分隔正反面、一行一张（本页 30 张按 A1–A7 / B1–B8 / C1–C8 / D1–D7 顺序录入）。
2. **复习节点（1 / 3 / 7 天）**：**当天 → 第 1 天（隔天）→ 第 3 天 → 第 7 天**，共四轮，每轮只重做标 **△** 与 **×** 的卡；四轮后仍未「✓」的卡，抄进 [errata.md](errata.md) 的待核实条目或自己的薄弱点清单单独跟踪。
3. **加一道保险**：**C2（逐列构造）与 C4（静力对偶）必须能默写**——老师明说这两处「肯定是要考的」（1:05:52）与「主要是记住这个公式就可以」（0:25:53）。默写完请**配一个两自由度的实例**（随手写一组 $a_i,\vartheta_i$）把 $J$ 组装一遍，并代入 $\tau=J^{\mathrm T}F_e$ 算一遍量纲。
