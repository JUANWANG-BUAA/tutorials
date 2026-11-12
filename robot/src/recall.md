# 公式与符号：随用随查

正文中带虚线的回忆链接，可悬停片刻、用键盘聚焦或点击打开。每条只恢复本次推导需要的前置知识；“回到推导”指向完整正文。无脚本时链接仍可直接打开本页。新符号仍在各节正文解释。

同一个字母可能代表不同对象。先看当前条目的名称、单位与坐标系，不要把路径弧长 $s$ 与拉普拉斯变量 $s$、单位矩阵 $I$ 与转动惯量 $I$ 混用。

<div class="recall-entry" id="joint">

## 关节变量、点号与上下标

$q=(q_1,\ldots,q_n)^{\mathrm T}$ 是构形；R 关节的分量为转角（rad），P 关节为位移（m）。$\dot q$、$\ddot q$ 分别对时间求一、二阶导。$p_i^0$ 表示第 $i$ 原点的位置用系 0 表达；下标标对象，上标标表达系。

[回到推导：编号与变量](ch02/sec2-8.md#def-2.8.1)

</div>

<div class="recall-entry" id="rotation">

## 旋转矩阵与换坐标

$R_i^0\in\mathbb R^{3\times3}$ 的三列，是系 $i$ 的三根单位轴在系 0 中的坐标。$p^0=R_i^0p^i$ 用于同一向量的换基；$R^{\mathrm T}R=I$、$\det R=1$，故逆为转置。这里只换方向分量；点的原点偏移还须加平移。

[回到推导：旋转矩阵](ch02/sec2-2.md)

</div>

<div class="recall-entry" id="homogeneous">

## 齐次变换与坐标链

$T_i^0=[R_i^0,p_i^0;0,1]$ 是 $4\times4$ 位姿矩阵。点用 $[p;1]$，方向用 $[d;0]$。连乘 $T_2^0=T_1^0T_2^1$ 的接口依次相接；平移块为 $p_1^0+R_1^0p_2^1$。整个 $T$ 有平移时，逆一般不等于转置。

[回到推导：两段合成](ch02/sec2-7.md#sec-2.7.3)

</div>

<div class="recall-entry" id="dh">

## 标准 DH：轴、四参数与一行变换

关节 $i$ 绕或沿 $z_{i-1}$ 运动。$a_i$ 沿新 $x_i$ 量公垂线长度，$d_i$ 沿旧 $z_{i-1}$ 量偏距；$\vartheta_i$ 绕旧 $z$ 转，$\alpha_i$ 绕新 $x$ 扭。固定几何的 R 行只有 $\vartheta_i$ 变，P 行只有 $d_i$ 变。

$$A_i^{i-1}=\operatorname{Rot}_z(\vartheta_i)\operatorname{Trans}_z(d_i)\operatorname{Trans}_x(a_i)\operatorname{Rot}_x(\alpha_i).$$

[回到推导：四动作与矩阵](ch02/sec2-8.md#method-2.8.A)

</div>

<div class="recall-entry" id="chain-rule">

## 链式法则与矩阵乘积求导

$p=f(q(t))$ 时，$\dot p=\sum_i(\partial p/\partial q_i)\dot q_i$；偏导固定其他输入。对矩阵乘积，$\frac{d}{dt}(AB)=\dot AB+A\dot B$，顺序不能交换。对路径 $p=p(s(t))$ 再求一次导：

$$\ddot p=p''(s)\dot s^2+p'(s)\ddot s.$$

[回到推导：位置与角速度](ch03/sec3-1.md)

</div>

<div class="recall-entry" id="skew">

## 叉乘矩阵 $S(a)$

$S(a)b=a\times b$，是把叉乘写成线性映射；$S(a)^{\mathrm T}=-S(a)$。换基时 $RS(a)R^{\mathrm T}=S(Ra)$。例如 $S(e_z)(x,y,z)^{\mathrm T}=(-y,x,0)^{\mathrm T}$。交换叉乘次序会反号。

$$S(a)=\begin{bmatrix}0&-a_z&a_y\\a_z&0&-a_x\\-a_y&a_x&0\end{bmatrix}.$$

[回到推导：反对称算子](ch03/sec3-1.md#def-3.1.2)

</div>

<div class="recall-entry" id="angular">

## 角速度与旋转矩阵导数

$R$ 将刚体系分量变到基系。基系角速度满足 $S(\omega^0)=\dot RR^{\mathrm T}$，故 $\dot R=S(\omega^0)R$；刚体系分量为 $\omega^e=R^{\mathrm T}\omega^0$。$\dot R$ 本身一般不反对称，也不是三维角速度。

[回到推导：从正交性求导](ch03/sec3-1.md#thm-3.1.A)

</div>

<div class="recall-entry" id="jacobian">

## 几何雅可比 $J$：输入与输出

在当前构形，$[\dot p_e;\omega_e]=J(q)\dot q$。$J$ 为 $6\times n$，上三行 $J_P$ 给指定工具点的线速度，下三行 $J_O$ 给角速度；本书两者默认同用基系。只做平面位置任务时用相应两行，不能机械地把所有六行都求逆。

[回到推导：几何雅可比](ch03/sec3-1.md#def-3.1.1)

</div>

<div class="recall-entry" id="jacobian-column">

## 雅可比每一列从哪里来

锁住其他关节，第 $i$ 列就是只动关节 $i$ 的速度贡献。所有轴、位置须先用同一系表达：

$$J_i=\begin{cases}\begin{bmatrix}z_{i-1}\times(p_e-p_{i-1})\\z_{i-1}\end{bmatrix},&R,\\\begin{bmatrix}z_{i-1}\\0\end{bmatrix},&P.\end{cases}$$

$p_{i-1}$ 是轴上一点；$p_e$ 换成另一工具点时，转动列的线速度部分也可能改变。

[回到推导：逐列构造](ch03/sec3-1.md#sec-3.1.3)

</div>

<div class="recall-entry" id="rank">

## 秩、值域与运动学奇点

$J$ 的秩是能独立产生的任务速度方向数，值域 $\mathcal R(J)=\{J\dot q\}$。指令在值域外就无精确速度解。固定任务后，秩低于该机构通常能达到的最大秩才称奇点；方阵通常满秩时才可直接用 $\det J=0$ 判断。

[回到推导：两杆奇点](ch03/sec3-3.md#sec-3.3.2)

</div>

<div class="recall-entry" id="nullspace">

## 零空间与投影

$\mathcal N(J)=\{z:Jz=0\}$ 中的关节速度不改变当前任务的一阶速度，维数为 $n-\operatorname{rank}J$。若 $J\dot q^*=v$，全部解是特解加零空间向量。欧氏正交投影 $P=I-J^\dagger J$ 满足 $JP=0,P^2=P,P^{\mathrm T}=P$。

[回到推导：投影与通解](ch03/sec3-4.md#sec-3.4)

</div>

<div class="recall-entry" id="svd">

## 奇异值：方向与速度倍率

将 $J$ 分解为正交输入方向 $v_i$、输出方向 $u_i$，使 $Jv_i=\sigma_i u_i$。$\sigma_i\ge0$ 是该对方向的倍率；实现输出 $b_i u_i$ 需要输入 $(b_i/\sigma_i)v_i$。小的正奇异值导致放大，零奇异值表示方向缺失。比较倍率前先统一任务与关节尺度。

[回到推导：速度椭圆的半轴](ch03/sec3-3.md#sec-3.3.2)

</div>

<div class="recall-entry" id="pseudoinverse">

## 伪逆与阻尼：不能混用的两种解

$J^\dagger v$ 先使速度残差最小，再取最小范数。行满秩时 $J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$ 且 $JJ^\dagger=I$。一般秩下伪逆仍存在。阻尼解为 $J^{\mathrm T}(JJ^{\mathrm T}+k^2I)^{-1}v$，$k>0$；它压低速度，同时可能保留任务误差。

[回到推导：两种优化目标](ch03/sec3-5.md)

</div>

<div class="recall-entry" id="euler">

## 欧拉角导数与物理角速度

ZYZ 约定 $R=R_z(\varphi)R_y(\vartheta)R_z(\psi)$。记 $\Phi=(\varphi,\vartheta,\psi)^{\mathrm T}$，则 $\omega=T(\Phi)\dot\Phi$；$T$ 的三列是三次瞬时转轴在基系中的方向。$\dot\Phi$ 一般不等于 $\omega$。$\sin\vartheta=0$ 时逆换算失效，须与机构降秩区分。

[回到推导：分析雅可比](ch03/sec3-6.md#sec-3.6.2)

</div>

<div class="recall-entry" id="axis-angle">

## 角轴与相对姿态

单位轴 $r$、角度 $\theta$ 给出 $R=I+\sin\theta S(r)+(1-\cos\theta)S(r)^2$。从初始姿态到目标，先算 $R_i^{\mathrm T}R_f$，其轴用初始系表达，再构造 $R(t)=R_i\exp(\theta(t)S(r))$。零角轴任意；半圈不能除以 $\sin\theta$，须单独求轴。

[回到推导：角轴](ch02/sec2-5.md)

</div>

<div class="recall-entry" id="quaternion">

## 单位四元数

本书采用 Hamilton、标量在前：$Q=(\eta,\epsilon)=(\cos(\theta/2),r\sin(\theta/2))$，$\eta^2+\epsilon^{\mathrm T}\epsilon=1$。$Q$ 与 $-Q$ 是同一姿态，单位四元数的逆为 $(\eta,-\epsilon)$。姿态误差 $Q_dQ_e^{-1}$ 的向量部是半角正弦，不等于欧拉角差或完整旋转向量。

[回到推导：单位四元数](ch02/sec2-6.md)

</div>

<div class="recall-entry" id="positive">

## 正定二次型与增益

对称矩阵 $W\succ0$ 表示所有非零 $z$ 都满足 $z^{\mathrm T}Wz>0$。它可用于惯性、速度代价或误差权重；用途由当前公式决定。对角阵正定等价于各对角元均正。$\tfrac12z^{\mathrm T}Wz$ 是标量，其对 $z$ 的梯度为 $Wz$。

[回到推导：加权速度最优解](ch03/sec3-5.md#sec-3.5.1)

</div>

<div class="recall-entry" id="gradient">

## 梯度与转置的来源

$\nabla_q V$ 的第 $i$ 项是 $\partial V/\partial q_i$，满足 $\mathrm dV=(\nabla_q V)^{\mathrm T}\mathrm dq$。例如 $e=x_d-f(q)$、$V=\tfrac12e^{\mathrm T}Ke$，对称 $K$ 下有 $\nabla_qV=-J_A^{\mathrm T}Ke$。转置来自链式法则，不表示求逆。

[回到推导：转置算法](ch03/sec3-7.md#sec-3.7.2)

</div>

<div class="recall-entry" id="wrench">

## 广义力、参考点与功率

本书 $F=[f;\mu]$，先力（N）后力矩（N·m），配对速度为 $v=[\dot p;\omega]$；功率 $F^{\mathrm T}v$。力矩必须注明关于哪一点。若 $v_b=Mv_a$，功率不变给 $F_a=M^{\mathrm T}F_b$；同方向换算则 $F_b=M^{-\mathrm T}F_a$。

[回到推导：静力学与参考点](ch03/sec3-8.md#sec-3.8.2)

</div>

<div class="recall-entry" id="time-law">

## 路径、时间律与归一化时间

路径给几何形状 $q=q(s)$，时间律 $s=s(t)$ 才决定走多快。$s$ 可为弧长（m），也可为 $[0,1]$ 上无量纲进度，须看本节定义。对固定形状令 $u=t/T$，有 $\dot q\propto T^{-1}$、$\ddot q\propto T^{-2}$；延时不会自动消除重力负载。

[回到推导：时间律](ch04/sec4-2-1.md)

</div>

<div class="recall-entry" id="spline">

## 分段三次与样条

每段三次有四个系数，两端位置、两端速度可确定它。相邻段采用相同节点速度就有 $C^1$ 连续；再令左右加速度相同才达到 $C^2$。经典三次样条还需两条端点条件（如首末速度或首末加速度），不能任意把所有端点条件同时加上。

[回到推导：样条的具体方程](ch04/sec4-2-2.md#sec-4.2.2.3)

</div>

<div class="recall-entry" id="laplace">

## 拉普拉斯变量、传递函数与极点

这里的 $s$ 是复频率变量，不是路径弧长。零初值下 $\mathcal L\{\dot x\}=sX(s)$，微分方程可化为代数方程；传递函数 $G(s)=Y(s)/U(s)$ 描述选定输入输出的线性零状态关系。分母根是候选极点，负实部极点对应衰减模态；模型简化与消去须另查。

[回到推导：电气驱动模型](ch05/sec5-2-1.md)

</div>

<div class="recall-entry" id="motor">

## 电机的电气与机械两条方程

电枢 $v_a=R_ai_a+L_a\dot i_a+k_v\dot\theta_m$，转矩 $\tau_m=k_ti_a$。$R_a,L_a$ 是电阻、电感；$k_v$ 为反电动势常数，$k_t$ 为转矩常数。机械侧再写惯性、摩擦与负载平衡，不能只由电气式决定转速。

[回到推导：电气驱动](ch05/sec5-2-1.md)

</div>

<div class="recall-entry" id="gear">

## 减速比与平方折算

先核对本节约定；若减速比 $k_r=\dot\theta_m/\dot q>1$，理想传动给 $\theta_m=k_rq$、$\tau_q=k_r\tau_m$。由动能 $\tfrac12J_m\dot\theta_m^2=\tfrac12(k_r^2J_m)\dot q^2$，电机惯量折到关节侧乘 $k_r^2$；负载折到电机侧除 $k_r^2$。

[回到推导：传动装置影响](ch05/sec5-2-3.md)

</div>

<div class="recall-entry" id="sensor">

## 传感器：分辨率、误差与标定

分辨率是可分辨的最小变化；精度涉及读数与真值偏差，两者不同。增量编码器计数须配参考位置；绝对编码器也有零位和安装误差。传感器输出需经比例、零偏或矩阵标定，才能作为有单位的物理量参与计算。

[回到推导：本体测量](ch05/sec5-3.md)

</div>

<div class="recall-entry" id="camera">

## 针孔投影与像素坐标

相机系中 $Z>0$ 的点满足 $u=f_xX/Z+c_x$、$v=f_yY/Z+c_y$。$f_x,f_y$ 用像素计，$c_x,c_y$ 为主点；相机外参先把世界点变到相机系。单个像素确定一条视线，不能单独恢复深度；理想模型尚未计镜头畸变。

[回到推导：视觉传感器](ch05/sec5-4-3.md)

</div>

<div class="recall-entry" id="kinetic">

## 刚体动能与惯性张量

质心线速度 $v_C$、角速度 $\omega$ 给动能 $\mathcal T=\tfrac12m v_C^{\mathrm T}v_C+\tfrac12\omega^{\mathrm T}I_C\omega$。惯性张量 $I_C$ 关于质心、单位 kg·m²，必须与 $\omega$ 同系。将两种速度写为质心雅可比乘 $\dot q$，就能把能量收成 $\tfrac12\dot q^{\mathrm T}B(q)\dot q$。

[回到推导：动能计算](ch06/sec6-1-1.md)

</div>

<div class="recall-entry" id="lagrange">

## 拉格朗日方程与偏导

$\mathcal L(q,\dot q)=\mathcal T-\mathcal U$。把 $q$、$\dot q$ 暂作独立变量求偏导，随后再沿实际运动对时间求导：

$$\frac{d}{dt}\frac{\partial\mathcal L}{\partial\dot q_i}-\frac{\partial\mathcal L}{\partial q_i}=\xi_i.$$

$\xi_i$ 是与关节虚位移配对的非保守广义力，转动关节为力矩、移动关节为力。

[回到推导：拉格朗日公式](ch06/sec6-1.md)

</div>

<div class="recall-entry" id="dynamics">

## 机械臂动力学各项

本书刚体模型写为 $B(q)\ddot q+C(q,\dot q)\dot q+g(q)$，再按本节约定加入摩擦、驱动力与外载。$B$ 为惯性矩阵，$C\dot q$ 为速度二次项，$g=\partial\mathcal U/\partial q$ 为重力项。$B$ 与雅可比不同；常用记号 $h=C\dot q+g+\cdots$ 必须看本节是否包含外载。

[回到推导：运动方程](ch06/sec6-1-3.md)

</div>

<div class="recall-entry" id="christoffel">

## Christoffel 系数与能量恒等式

对称 $B$ 的一个标准选法是 $c_{ijk}=\tfrac12(\partial_k b_{ij}+\partial_j b_{ik}-\partial_i b_{jk})$、$C_{ij}=\sum_kc_{ijk}\dot q_k$。此时 $\dot B-2C$ 反对称，因此 $z^{\mathrm T}(\dot B-2C)z=0$。这会消去动能求导中的速度二次项；并非任意同效的 $C$ 写法都自动满足该矩阵恒等式。

[回到推导：反对称性质](ch06/sec6-2-1.md)

</div>

<div class="recall-entry" id="error">

## 期望量、误差与反馈符号

下标 $d$ 表期望，未加 $d$ 表实际。本书常取 $e=q_d-q$，故 $\dot e=\dot q_d-\dot q$。用 $+K_Pe$ 给驱动修正时，若实际低于期望，就往增大实际量的方向推。若改用 $\tilde q=q-q_d$，控制律相应改号，不能只换误差名。

[回到推导：误差方程](ch07/sec7-1.md)

</div>

<div class="recall-entry" id="lyapunov">

## Lyapunov 函数怎样用于稳定性

选非负的标量 $V$ 衡量偏差，例如 $V=\tfrac12\dot q^{\mathrm T}B(q)\dot q+\tfrac12e^{\mathrm T}K_Pe$。沿闭环运动求 $\dot V$，代入控制律后看是否下降。$\dot V\le0$ 本身只给不增；要证明误差趋零，还须分析 $\dot V=0$ 的不变运动和适用区域。

[回到推导：重力补偿 PD](ch07/sec7-3.md)

</div>

<div class="recall-entry" id="second-order">

## 二阶误差模型与阻尼

标量模型 $\ddot e+2\zeta\omega_n\dot e+\omega_n^2e=0$ 中，$\omega_n$ 是自然频率，$\zeta$ 是阻尼比。$0<\zeta<1$ 有衰减振荡，$\zeta=1$ 为重根，$\zeta>1$ 为两负实根；这些判断适用于本模型。关节惯量未被补偿时，须先除以惯量再对照系数。

[回到推导：独立关节控制](ch07/sec7-2.md)

</div>
