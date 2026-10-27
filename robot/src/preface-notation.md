# 符号与缩略语表

原书第一章为叙述性绪论、第二章起数学符号密集。本表为**全书符号表**：先收录缩略语，再按「第一章 / 第二章 / 后续章节」列出记号。正文首次出现时给全称，此后直接用符号。

## 缩略语

| 缩略语 | 全称 | 中文 | 首见 |
|:--|:--|:--|:--|
| DOF | degrees of freedom | 自由度 | 1.2.1 |
| SCARA | selective compliance assembly robot arm | 选择性柔性装配机器人臂 | 1.2.2 |
| IFR | International Federation of Robotics | 国际机器人联合会 | 1.2.2 |
| RIA | Robotics Institute of America | 美国机器人学会 | 1.4.1 |
| FMS | flexible manufacturing system | 柔性制造系统 | 1.4.1 |
| AGV | automated guided vehicle | 自动导引车辆 | 1.4.1 |
| ITS | intelligent transportation systems | 智能交通系统 | 1.4.3 |
| LWR | light weight robot | 轻质机器人 | 1.4.2 |
| NASA / DARPA | — | 美国国家航空航天局 / 国防先进研究项目局 | 1.4.3 |
| ZYZ / RPY | — | 兹氏欧拉角序列（绕当前轴）/ 滚转—俯仰—偏航（绕固定轴） | 2.4 |
| DH | Denavit–Hartenberg | DH 建系法 / DH 参数 | 2.8 |
| IK | inverse kinematics | 逆运动学 | 2.12 |

## 第一章记号

| 符号 | 含义 |
|:--|:--|
| $\boldsymbol q=[x\ y\ \theta]^T$ | 平面移动底盘的位形（位置 + 朝向，1.3.3） |
| $\boldsymbol e(t)=\boldsymbol q_d(t)-\boldsymbol q(t)$ | 轨迹误差（反馈控制的修正信号，1.5.3） |

## 第二章记号

| 符号 | 含义 | 首见 |
|:--|:--|:--|
| $\boldsymbol p^i$ | 向量在坐标系 $i$ 中的表示 | 2.1 |
| $R_j^i\in SO(3)$ | 坐标系 $j$ 相对坐标系 $i$ 的旋转矩阵（**列** = $j$ 系轴在 $i$ 系中的方向余弦） | 2.2 |
| $SO(3)$ / $SE(3)$ | 特殊正交群（旋转）/ 特殊欧几里得群（旋转 + 平移）——都是**李群** | 2.2 / 2.7 |
| $S(\omega)=[\omega]_\times=\hat\omega$ | 叉乘算子 / 反对称矩阵：$S(\omega)p\equiv\omega\times p$ | 2.5 |
| $so(3)$ / $se(3)$ | $SO(3)$ / $SE(3)$ 的**李代数**（单位元处的切空间：全体 3×3 反对称阵 / 旋量六参数） | 2.5 / 2.7 |
| $\hat\omega$ / $S^\vee$ | 装帽（向量 → 反对称阵）/ 摘帽（反对称阵 → 向量），一一对应 | 2.5 |
| $\exp(\vartheta S(\boldsymbol r))$ / $\log R$ | 指数映射（= Rodrigues 公式）/ 对数映射（= 角和轴逆解） | 2.5 |
| $R_x,R_y,R_z$ | 绕坐标轴的基本旋转矩阵 | 2.2 |
| $\boldsymbol\phi=[\varphi\ \vartheta\ \psi]^T$ | 欧拉角 / RPY 角集合（**非向量**，不可加） | 2.4 |
| $\operatorname{Atan2}(y,x)$ | 双变量反正切（分子在前，象限由 $x,y$ 符号定） | 2.4 |
| $(\vartheta,\boldsymbol r)$ | 角和轴表示（4 参数 − 1 约束） | 2.5 |
| $Q=\{\eta,\boldsymbol\epsilon\}$ | 单位四元数（标量部分 + 向量部分，4 参数 − 1 约束） | 2.6 |
| $\tilde{\boldsymbol p}=[\boldsymbol p;1]$ | 齐次坐标（位置打包进 4 维） | 2.7 |
| $A_i^{i-1}$ | 相邻连杆坐标系的 DH 变换（4 参数） | 2.8 |
| $a_i,\alpha_i,d_i,\vartheta_i$ | DH 四参数：杆件长度 / 扭角 / 关节距离 / 关节转角（3 常 1 变） | 2.8 |
| $\boldsymbol q\in\mathbb{R}^n$ | 关节变量向量（转动 $q_i=\vartheta_i$、移动 $q_i=d_i$） | 2.8 |
| $T_e^b(\boldsymbol q)$ | 正运动学：末端执行器坐标系相对基坐标系的位姿 | 2.8 |
| $\boldsymbol n_e,\boldsymbol s_e,\boldsymbol a_e,\boldsymbol p_e$ | 末端执行器坐标系：法向 / 滑动 / **接近**向量与位置（$\boldsymbol n_e=\boldsymbol s_e\times\boldsymbol a_e$） | 2.8 |
| $\boldsymbol x_e=k(\boldsymbol q)$ | 操作空间位姿（正运动学映射；$m$ 维） | 2.10 |
| $(n,m,r)$ | 关节空间维数 / 操作空间维数 / 任务实际用到的维数（冗余判定） | 2.10 |
| $\boldsymbol\xi$ | DH 参数偏差向量（标定；原书记 $\boldsymbol\zeta$） | 2.11 |
| $\Phi$ | 运动学标定矩阵（$m\times4n$） | 2.11 |
| $\boldsymbol p_w$ | 腕心位置（球腕三轴交点，解耦逆解的抓手） | 2.12 |

## 第三章记号

| 符号 | 含义 | 首见 |
|:--|:--|:--|
| $J(\boldsymbol q)$ | 几何雅可比（关节速度 → 末端速度，$6\times n$） | 3.1 |
| $J_P,J_O$ | 雅可比的线速度块 / 角速度块（各 $3\times n$） | 3.1 |
| $S(\boldsymbol\omega)=[\boldsymbol\omega]_\times$ | 叉乘算子 / 反对称矩阵（$so(3)$ 元素；角速度的矩阵形式，首见 2.5） | 2.5 / 3.1 |
| $J^\dagger$ | 右伪逆（最小范数解，冗余情形） | 3.5 |
| $J^*$ | 阻尼广义逆（奇异邻域） | 3.5 |
| $N,P$ | 零空间矩阵与投影 $P=NN^{\mathrm T}$ | 3.4 |
| $J_A$、$T(\boldsymbol\varphi)$ | 分析雅可比与换基矩阵（$\boldsymbol\omega_e=T\dot{\boldsymbol\varphi}_e$） | 3.6 |
| $F_e=[\boldsymbol f_e;\boldsymbol\mu_e]$ | 末端广义力（3 力 + 3 矩） | 3.8 |
| $\boldsymbol\tau$ | 关节力矩向量（$\boldsymbol\tau=J^{\mathrm T}F_e$） | 3.8 |

## 第四章记号

| 符号 | 含义 | 首见 |
|:--|:--|:--|
| $q(t),\dot q(t),\ddot q(t)$ | 关节位置 / 速度 / 加速度时间律（单关节记 $q$，多关节为向量） | 4.1 |
| $t_f,t_i$ | 轨迹的最终 / 初始时刻 | 4.2.1 |
| $q_i,q_f,\dot q_i,\dot q_f$ | 关节初终位置与速度 | 4.2.1 |
| $\ddot q_c,t_c$ | 梯形速度曲线的常加速度与其持续时间 | 4.2.1 |
| $\dot q_c$ | 巡航速度 | 4.2.1 |
| $q_m,t_m$ | 平均值点 $q_m=(q_f+q_i)/2$ 与 $t_m=t_f/2$ | 4.2.1 |
| $\Pi_k(t)$ | 第 $k$ 段插值多项式（三次） | 4.2.2 |
| $q_k,t_k$ | 第 $k$ 个路径点的位置与时刻 | 4.2.2 |
| $\Delta t_k,\Delta t'_k$ | 分段时长 / 抛物线混合时长 | 4.2.2 |
| $A,b$ | 样条降维后的三对角系数矩阵与右端向量（$A\boldsymbol\Pi=b$） | 4.2.2 |
| $p=f(\sigma)$、$p=f(s)$ | 路径的参数表示 / 弧长参数化 | 4.3.1 |
| $s,\rho,c$ | 弧长 / 圆弧半径 / 圆心位置向量 | 4.3.1 |
| $t,n,b$ | Frenet 标架：切线 / 法线 / 副法线单位向量 | 4.3.1 |
| $r,d,\delta$ | 圆轴单位向量 / 轴上点位置 / $\delta=p_l-d$ | 4.3.1 |
| $s(t)$ | 弧长时间律（位置规划归结到的一维标量） | 4.3.2 |
| $\Delta t_j$ | 多段路径的时间超前量 | 4.3.2 |
| $\boldsymbol\varphi_e=(\varphi,\vartheta,\psi)$ | 欧拉角三元组（姿态规划） | 4.3.3 |
| $\theta_f,r'$ | 等效转角与等效轴单位向量（角和轴法） | 4.3.3 |

## 第五章记号

| 符号 | 含义 | 首见 |
|:--|:--|:--|
| $P_c,P_e,P_a,P_m,P_u$ | 控制信号 / 一次能源 / 供给发动机 / 发动机输出 / 关节所需的功率 | 5.1 |
| $P_{da},P_{dm},P_{dt}$ | 放大器 / 发动机 / 传动装置的功率损失 | 5.1 |
| $V_c,v_c$ | 功率放大器的控制电压（$v_c$ 为参考电流输入） | 5.2.1 |
| $V_a,I_a,R_a,L_a$ | 电枢电压 / 电流 / 电阻 / 电感 | 5.2.1 |
| $V_g,k_v$ | 反电动势与其电压常数（$V_g=k_v\Omega_m$） | 5.2.1 |
| $k_t,I_m,F_m$ | 转矩常数（$k_t=k_v$）/ 转动惯量 / 粘滞摩擦系数 | 5.2.1 |
| $C_m,C_l$ | 驱动力矩 / 负载转矩 | 5.2.1 |
| $G_v,T_v$ | 功率放大器的电压增益与时间常数 | 5.2.1 |
| $k_i,C_i(s)$ | 电枢电流反馈的传感常数与电流调节器 | 5.2.1 |
| $M(s),k_m,T_m$ | 驱动「位置输出 / 控制输入」传递函数及其增益与时间常数 | 5.2.1 |
| $Q,Q_m,Q_l,Q_c$ | 分布器流速 / 传送给发动机 / 渗漏 / 可压缩性流速 | 5.2.2 |
| $p,k_l,\gamma,V$ | 伺服发动机压差 / 渗漏系数 / 可压缩性系数 / 流体体积 | 5.2.2 |
| $k_q,k_p,k_c$ | 流速–转速系数 / 力矩–压差系数 / $k_c=\gamma V$ | 5.2.2 |
| $G_c,T_c,k_x$ | 伺服阀的等价增益 / 时间常数 / 分布器线性化系数 | 5.2.2 |
| $k_r$ | 减速比（$\omega_m/\omega=r/r_m$） | 5.2.3 |
| $r_m,r$ | 发动机侧 / 载荷侧齿轮半径 | 5.2.3 |
| $I_{eq},F_{eq}$ | 折算到发动机轴的等效转动惯量与等效粘滞摩擦 | 5.2.3 |
| $k_{TP},k_{TV}$ | 位置传感器常数 / 速度传感器常数 | 5.2.4 |
| $K_r,K_v,T_p$ | 位置环比例增益 / 速度环增益 / 控制器参数 | 5.2.4 |
| $k_i^{enc}$ 等 | （见各节）传感器敏感元件常数 | 5.3 |
| $w_1,\dots,w_8$ | 腕力传感器八个电桥的输出信号 | 5.4.1 |
| $c_{ij}$ | 传感器校准矩阵的元素 | 5.4.1 |
| $R^c_s,r^c_{cs},S(\cdot)$ | 传感器系→约束系的旋转 / 位置 / 反对称算子 | 5.4.1 |
| $\alpha_x,\alpha_y,X_0,Y_0,f$ | 相机的比例因子、主点与焦距（内参数） | 5.4.3 |
| $\Omega,\Pi,T_b^c,\Xi$ | 内参矩阵 / 透视变换 / 外参数 / 相机校准矩阵 | 5.4.3 |

## 第六章、第七章记号（动力学与控制）

第六章的 $B,C,\boldsymbol g$、$h_{ijk}$、$Y,\boldsymbol\pi$ 见 [6.1.3](ch06/sec6-1-3.md)、[6.2.2](ch06/sec6-2-2.md)；操作空间那一套（$B_A,C_A,\boldsymbol g_A,\boldsymbol\gamma_A$）见 [6.7](ch06/sec6-7.md)。下表只列**第七章新引入**的符号（首见节号为本书编号；矩阵记号均为逐轴对角阵，标量版首见第五章对应节）。

| 符号 | 含义 | 首见 |
|:--|:--|:--|
| $K_P,K_D,K_I$ | 关节控制器的比例 / 微分 / 积分增益（取对角阵，逐轴整定） | 7.2.2 / 7.2.3 |
| $\omega_n,\zeta$ | 单轴闭环的自然频率与阻尼比；$K_P=J\omega_n^2$、$K_D=2\zeta J\omega_n$ | 7.2.2 / 7.2.7 |
| $e_i$、$e_{\mathrm{ss}}$ | 第 $i$ 轴误差 $q_{d_i}-q_i$；常值扰动下的稳态误差 $=d/K_P$ | 7.2.2 / 7.2.3 |
| $J_i$、$d_i$ | 第 $i$ 轴等效惯量；并入扰动的耦合/摩擦/未建模项 | 7.2.1 / 7.2.2 |
| $K_r$ | **减速比矩阵**（对角；$q_m=K_r q$）；标量 $k_r$ 见 5.2.3 | 7.2.5 |
| $K_t$ | 转矩常数矩阵（$\tau_m=K_t i_a$）；标量 $k_t$ 见 5.2.1 | 7.2.5 |
| $R_a$ | 电枢电阻矩阵；标量 $R_a$ 见 5.2.1 | 7.2.5 |
| $K_v$ | 反电动势常数矩阵（$v_a$ 中含 $K_v\dot q_m$）；标量 $k_v$ 见 5.2.1 | 7.2.5 |
| $G_v$ | 功率放大器电压增益矩阵（$v_a=G_v v_c$）；标量 $G_v$ 见 5.2.1 | 7.2.5 |
| $G_i$ | 电流环增益矩阵（$i_a=G_i v_c$，加了电流环才有） | 7.2.5 |
| $i_a$、$v_a$、$v_c$ | 电枢电流、电枢电压、功率放大器**控制电压**（矩阵形式，逐轴） | 7.2.5 |
| $\boldsymbol\tau_x$（= 课件 $\boldsymbol\gamma_A$，文献 $\boldsymbol\gamma_e$） | 操作空间**等效力**；与关节力矩互折 $\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol\tau_x$ | 7.4.2 |
| $B_x,C_x,\boldsymbol g_x$（= 课件 $B_A,C_A,\boldsymbol g_A$） | 操作空间有效惯量 / 速度耦合 / 重力项；$B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$ | 7.4.2（来源 [6.7](ch06/sec6-7.md)） |
| $\boldsymbol F$ | 操作空间控制力（教材写法，等价于 $\boldsymbol\tau_x$） | 7.4.3 |
| $\boldsymbol e_x$ | 操作空间误差 $\boldsymbol x_d-\boldsymbol x$（姿态部分另有取法，见 7.4.3 的注） | 7.4.3 |
| $\boldsymbol h_e$ | 末端与环境的作用力（第九章的主角，本章按零处理） | 7.1.2 |

## 后续章节预注册的记号（预告）

| 符号 | 含义 | 启用章节 |
|:--|:--|:--|
| $\boldsymbol{\gamma}(t)$ | 移动机器人控制输入 | 第 11 章 |
| $\boldsymbol\xi$ | 移动机器人位形 | 第 11 章 |

::: note 三处约定
1. 本教程向量与矩阵一律粗体（$\boldsymbol{q}$、$\mathbf{R}$），标量斜体（$n$、$t$），与原书一致；
2. 「自由度」一词有两个相关而不同的用法——机械手的 DOF 指关节数允许的独立运动数，移动机器人的「即时机动自由度」指容许瞬时运动的方向数（可能小于位形变量数），见 [1.3.3](ch01/sec1-3.md#sec-1.3.3)；
3. 上下标读法全书统一：$R_j^i$、$T_j^i$、$A_i^{i-1}$ 的**上标是参考系（在哪套坐标里表达）、下标是被描述的对象**——上下标读反是第二章最常见的错误（[2.3](ch02/sec2-3.md#sec-2.3.1)）。
:::
