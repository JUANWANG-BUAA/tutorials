# 术语索引

按**主题**归组的术语表：每个词给出一句话定义 + 首次出现的锚点。全文搜索能告诉你「哪些页面提到了这个词」，本页告诉你「这个词是哪一节的哪一个概念」——两者互补。

::: note 怎么用这一页
- **读正文遇到生词**：搜不到或搜出一堆无关命中时，来这里定位「它是谁定义的」。
- **复习时**：遮住「一句话含义」一列，只看术语自述；说不清的去对应锚点。
- 符号与缩略语的对照表在[符号表](preface-notation.md)；公式在[公式速查卡](preface-formulas.md)。
:::

---

## 一、机器人学基本概念（第一章）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 机器人 | robot | 能影响其工作环境的机器，**无关外表**；判据是「感知—决策—作用」闭环 | [@def-1.1.1] |
| robota | — | 捷克语「强迫劳动」，1920 年 Čapek 戏剧《R.U.R.》杜撰 robot 一词的词源 | [1.1.1](ch01/sec1-1.md#sec-1.1.1) |
| 阿西莫夫三定律 | Asimov's laws | 1940s 的**科幻设定**，非工程标准；其精神被 ISO 10218 / ISO/TS 15066 继承 | [1.1.1](ch01/sec1-1.md#sec-1.1.1) |
| 机械系统 | mechanical system | 「身体」：运动装置（轮系、履带、腿）+ 操作装置（机械手、末端执行器） | [1.1.3](ch01/sec1-1.md#sec-1.1.3) |
| 执行系统 | actuation system | 「肌肉」：伺服电机、驱动器、传动装置 | [1.1.3](ch01/sec1-1.md#sec-1.1.3) |
| 传感系统 | sensory system | 「感官」：本体传感器（位置）+ 外部传感器（力、相机） | [1.1.3](ch01/sec1-1.md#sec-1.1.3) |
| 控制系统 | control system | 「大脑」：在约束下实现感知到行为的智能联系，服从反馈原理 | [1.1.3](ch01/sec1-1.md#sec-1.1.3) |
| 控制论 | cybernetics | 更广的学科名，还涵盖运动监测、人工智能、算法结构与编程环境 | [1.1.3](ch01/sec1-1.md#sec-1.1.3) |
| 开式运动链 | open kinematic chain | 连杆链两端之间只有一个连接序列 | [@def-1.2.1] |
| 闭式运动链 | closed kinematic chain | 存在连杆序列形成回路；自由度须扣独立约束 | [@def-1.2.1] |
| 移动关节 | prismatic joint | 实现相对**平移**；此时 $q_i=d_i$ | [@def-1.2.2] |
| 转动关节 | revolute joint | 实现相对**转动**；此时 $q_i=\vartheta_i$ | [@def-1.2.2] |
| 自由度 | degrees of freedom, DOF | 关节允许的独立运动数；开链可直接计数 | [@def-1.2.2] |
| 工作空间 | workspace | 末端执行器能到达的区域；形状与容积取决于结构及关节限位 | [@def-1.2.2] |
| 冗余 | redundant | 系统自由度多于任务变量数——可用来避障、优化姿态 | [@thm-1.2.A] |
| 笛卡儿型 | Cartesian | 三移动关节，工作空间为长方体；刚性好、精度处处一致 | [1.2.2](ch01/sec1-2.md#sec-1.2.2) |
| 圆柱型 | cylindrical | 转 + 移 + 移，工作空间为空心圆柱的一部分 | [1.2.2](ch01/sec1-2.md#sec-1.2.2) |
| 球型 | spherical | 转 + 转 + 移，工作空间为中空球体的一部分 | [1.2.2](ch01/sec1-2.md#sec-1.2.2) |
| SCARA | selective compliance assembly robot arm | 三轴**平行**，竖直刚、水平顺从，适合插装 | [1.2.2](ch01/sec1-2.md#sec-1.2.2) |
| 拟人型 | anthropomorphic | 全转动关节，最灵活；应用范围最广的工业构形 | [1.2.2](ch01/sec1-2.md#sec-1.2.2) |
| 平行四边形臂 | parallelogram arm | 肩肘间引入平行四边形几何（闭链）以提高刚度 | [1.2.3](ch01/sec1-2.md#sec-1.2.3) |
| 并联构形 | parallel manipulator | 多条运动链同时连接基座与末端；高刚性、工作空间缩减 | [1.2.3](ch01/sec1-2.md#sec-1.2.3) |
| 球形腕 | spherical wrist | 三个转动关节且**三轴交于一点**——实现定位与定向解耦 | [@def-1.2.3] |
| 解耦 | decoupling | 把一个问题拆成可独立求解的两个子问题（球形腕 / 导向轮转向与牵引分离） | [@thm-1.2.C] |
| 末端执行器 | end-effector | 按任务指定的工具：钳子、喷枪、铣刀、多触点手等 | [1.2.4](ch01/sec1-2.md#sec-1.2.4) |
| 定轮 | fixed wheel | 只能沿轮面直「走」 | [@def-1.3.1] |
| 导向轮 | steerable wheel | 电机控制转向，两轴均过轮心——能「转」 | [@def-1.3.1] |
| 自位轮 | castor wheel | 垂直轴不过轮心（有偏移量），**被动**对齐——会「飘」 | [@def-1.3.1] |
| 麦克纳姆轮 | Mecanum wheel | 轮缘 $45°$ 滚筒，实现全向移动 | [1.3.2](ch01/sec1-3.md#sec-1.3.2) |
| 即时机动性 | instantaneous mobility | 容许瞬时运动的方向数，**可能小于**位形变量数 | [@def-1.3.2] |
| 无侧滑约束 | no-side-slip constraint | 速度层面的约束，解释「不能即时横移」——但**不等于**不能横移 | [@def-1.3.2] |
| 支撑三角形 | support triangle | 三轮布局中三接地点构成的三角形，稳定性判据 | [@thm-1.3.B] |
| 工业机器人学 | industrial robotics | 结构化环境、先验已知、有限自治 | [@def-1.4.1] |
| 先进机器人学 | advanced robotics | 弱结构 / 开放环境，要求强自治 | [@def-1.4.2] |
| 运动学 | kinematics | 只描述运动，**不含力** | [@def-1.5.1] |
| 微分运动学 | differential kinematics | 速度层面的映射（第 3 章） | [@def-1.5.1] |
| 动力学 | dynamics | 力与运动的关系（第 7 章） | [@def-1.5.1] |
| 轨迹规划 | trajectory planning | 生成**时间律**：何时在何处 | [@def-1.5.2] |
| 运动规划 | motion planning | 解决**避障**：走哪条路 | [@def-1.5.2] |
| 反馈不可替代 | — | 模型永远不能完全描述真实结构，故反馈不可省略 | [@thm-1.5.B] |

## 二、姿态表示（2.1–2.7）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 位姿 | pose | 位置 + 姿态；$T=(\boldsymbol p,R)$，共 6 个独立变量 | [@def-2.1.1] |
| 方向余弦 | direction cosines | 两坐标系各轴夹角的余弦；9 个即旋转矩阵的元素 | [@thm-2.1.A] |
| 旋转矩阵 | rotation matrix | 描述姿态的 $3\times3$ 正交矩阵，$R^{\mathrm T}R=I$、$\det R=+1$ | [@def-2.2.1] |
| 特殊正交群 | $SO(3)$ | 所有旋转矩阵构成的群 | [@def-2.2.2] |
| 三重身份 | — | 同一矩阵的三种读法：姿态**描述** / 坐标**变换** / 旋转**算子** | [@thm-2.2.B] |
| 坐标变换 | coordinate transformation | 用 $R_j^i$ 把系 $j$ 的坐标搬到系 $i$ | [@thm-2.2.A] |
| 右乘 / 左乘 | — | 绕**当前**轴连续转用右乘，绕**固定**轴用左乘 | [@thm-2.3.A]、[@thm-2.3.B] |
| 欧拉角 | Euler angles | 3 参数姿态表示；27 种轴序只有 12 种可行 | [2.4](ch02/sec2-4.md) |
| ZYZ 角 | — | 绕**当前**轴（$z,y',z''$）的欧拉角序列，右乘 | [2.4.2](ch02/sec2-4.md#sec-2.4.2) |
| RPY 角 | roll-pitch-yaw | 航空航海惯用：绕**固定**轴 $z,y,x$，左乘；又称 ZYX 角 | [2.4.5](ch02/sec2-4.md#sec-2.4.5) |
| Atan2 | $\operatorname{Atan2}(y,x)$ | 双变量反正切：用 $x,y$ 符号定象限，在 $(-\pi,\pi]$ 内唯一 | [@thm-2.4.A] |
| 表示奇点 | representation singularity | 欧拉角在 $s_\vartheta=0$（ZYZ）或 $c_\vartheta=0$（RPY）处退化 | [@thm-2.4.B] |
| 角和轴 | angle and axis | 4 参数表示 $(\vartheta,\boldsymbol r)$；$\boldsymbol r$ 为单位轴 | [@def-2.5.1] |
| 叉乘算子 | skew-symmetric operator $S(\omega)$ | 把叉积装进矩阵：$S(\omega)p=\omega\times p$；反对称 | [@def-2.5.2] |
| 共轭恒等式 | conjugation identity | $RS(\omega)R^{\mathrm T}=S(R\omega)$——「先叉乘再旋转 = 先旋转再叉乘」 | [@pf-2.5.rodrigues] |
| 李群 | Lie group | 元素可连续光滑变化的群；$SO(3)$、$SE(3)$ 都是 | [@note-2.2.group] |
| 李代数 | Lie algebra $so(3)$ | 李群在单位元处的切空间；$so(3)$ = 全体 3×3 反对称矩阵（3 维） | [@def-2.5.3] |
| 装帽 / 摘帽 | hat / vee | $\hat\omega=S(\omega)$、$S^\vee=\omega$：$\mathbb R^3$ 与 $so(3)$ 的一一对应 | [@def-2.5.3] |
| 指数映射 | exponential map | $\exp(\vartheta S(\boldsymbol r))=I+\sin\vartheta\,S+(1-\cos\vartheta)S^2$ = Rodrigues | [@thm-2.5.D] |
| 对数映射 | logarithm map | $\log R=\vartheta S(\boldsymbol r)=\frac{\vartheta}{2\sin\vartheta}(R-R^{\mathrm T})$——逆解的打包写法 | [@thm-2.5.E] |
| 李括号 | Lie bracket | $[A,B]=AB-BA$；在 $so(3)$ 上就是叉积 $[S(a),S(b)]=S(a\times b)$ | [@note-2.5.payoff] |
| 旋量 / 空间速度 | twist $se(3)$ | $SE(3)$ 的李代数元素 $\begin{bmatrix}S(\omega)&\boldsymbol v\\\boldsymbol 0^{\mathrm T}&0\end{bmatrix}$（6 参数）；exp 给螺旋运动 | [@note-2.7.se3] |
| Rodrigues 公式 | Rodrigues formula | 由 $(\vartheta,\boldsymbol r)$ 显式构造 $R$ 的矩阵 | [@def-2.5.1] |
| 单位四元数 | unit quaternion / Euler parameters | $Q=\{\eta,\boldsymbol\epsilon\}$，半角打包，4 参数 − 1 约束 | [@def-2.6.1] |
| 半角打包 | half-angle packing | $\eta=\cos\frac{\vartheta}{2}$、$\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\boldsymbol r$——消除角和轴的不唯一 | [@thm-2.6.A] |
| 齐次坐标 | homogeneous coordinates | $\tilde{\boldsymbol p}=[\boldsymbol p;1]$，把平移与旋转打包 | [@def-2.7.1] |
| 齐次变换矩阵 | homogeneous transformation | $A=\begin{bmatrix}R&\boldsymbol o\\\boldsymbol 0^{\mathrm T}&1\end{bmatrix}\in SE(3)$；$A^{-1}\neq A^{\mathrm T}$ | [@def-2.7.1] |
| 特殊欧几里得群 | $SE(3)$ | $\mathbb R^3\times SO(3)$ | [@def-2.7.1] |

## 三、正运动学与 DH 法（2.8–2.11）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 正运动学 | direct / forward kinematics | 由关节变量 $\boldsymbol q$ 求末端位姿 | [@def-2.8.2] |
| 接近向量 | approach vector $\boldsymbol a_e$ | 末端坐标系第三列，指向抓取 / 工作方向 | [@def-2.8.2] |
| 滑动向量 | sliding vector $\boldsymbol s_e$ | 钳口滑动平面内、垂直于 $\boldsymbol a_e$ | [@def-2.8.2] |
| 法向向量 | normal vector $\boldsymbol n_e$ | $=\boldsymbol s_e\times\boldsymbol a_e$，使三者成右手系 | [@def-2.8.2] |
| DH 法 | Denavit–Hartenberg | 用 4 个参数描述相邻连杆坐标系关系 | [@def-2.8.3] |
| DH 四参数 | $a_i,\alpha_i,d_i,\vartheta_i$ | 杆件长度 / 扭角 / 关节距离 / 关节转角；**3 常 1 变** | [@def-2.8.3] |
| 建系四规则 | — | $z_i$ 沿关节 $i+1$ 轴、原点在公垂线交点、$x_i$ 沿公垂线、右手系补 $y_i$ | [@method-2.8.dh] |
| 能零则零 | — | 自由选取处选「让参数尽量为零」的方案 | [@method-2.8.zero] |
| 关节空间 | joint space | 关节变量 $\boldsymbol q$ 张成的空间 | [@def-2.10.1] |
| 操作空间 | operational space | 末端位姿 $\boldsymbol x_e$ 张成的空间 | [@def-2.10.1] |
| 可达工作空间 | reachable workspace | 至少能从**一个**方向到达的点集 | [@def-2.10.2] |
| 灵活工作空间 | dexterous workspace | 能从**任意**方向到达的点集；⊆ 可达 | [@def-2.10.2] |
| 精度 | accuracy | 指令位姿与真实位姿之差；可标定改善 | [@def-2.10.2] |
| 重复定位精度 | repeatability | 多次回同一点的散布；示教再现的命根 | [@def-2.10.2] |
| 本质冗余 / 功能冗余 | intrinsic / functional redundancy | 结构上 $n>m$ / 任务上 $n>r$ | [@def-2.10.3] |
| 运动学标定 | kinematic calibration | 由位姿量测反推真实 DH 参数；线性化 + 最小二乘 + 迭代 | [@method-2.11.steps] |
| 标定矩阵 | $\Phi$ | $m\times4n$，参数空间到操作空间的雅可比 | [@method-2.11.steps] |

## 四、逆运动学（2.12）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 逆运动学 | inverse kinematics | 由末端位姿求关节变量；非线性、多解、可能无解 | [@thm-2.12.A] |
| 闭合解 | closed-form solution | 存在解析表达式的解；门槛是解耦条件 | [@thm-2.12.B] |
| 腕心 | wrist centre $\boldsymbol p_w$ | 球腕三轴交点；$\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$ | [@method-2.12.decouple] |
| 肘上 / 肘下 | elbow-up / elbow-down | 平面臂逆解的两支，来自 $s_2$ 的符号 | [2.12.2](ch02/sec2-12.md#sec-2.12.2) |
| 外移长度 | $d_6$ | 腕心到末端原点的距离，沿接近向量 | [@method-2.12.decouple] |

## 五、微分运动学（3.1–3.7）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 微分运动学方程 | differential kinematics equation | $\boldsymbol v_e=J(\boldsymbol q)\dot{\boldsymbol q}$ | [@def-3.1.1] |
| 几何雅可比 | geometric Jacobian | $6\times n$，由 DH + 正运动学逐列构造 | [@def-3.1.1] |
| 反对称矩阵 / 叉乘算子 | skew-symmetric operator $S(\boldsymbol\omega)$ | $S(\boldsymbol\omega)\boldsymbol p\equiv\boldsymbol\omega\times\boldsymbol p$；$\dot R=S(\boldsymbol\omega)R$ | [@def-3.1.2] |
| 逐列构造 | — | $J_i$ = 单关节对末端速度的贡献（绿框公式） | [@thm-3.1.C] |
| 雅可比计算五步 | — | 建系 → 填表 → 连乘 → 读 $z,\boldsymbol p$ → 组装 | [@method-3.2.A] |
| 运动学奇点 | kinematic singularity | $\det J(\boldsymbol q)=0$ 的位形 | [@def-3.3.1] |
| 边界奇点 / 内部奇点 | boundary / interior singularity | 位于工作空间边界 / 工作空间内部 | [3.3](ch03/sec3-3.md) |
| 腕奇点 | wrist singularity | $\vartheta_5=0,\pi$（$s_5=0$），两腕轴共线 | [@thm-3.3.A] |
| 肘奇点 | elbow singularity | $s_3=0$，臂完全伸直或折回 | [@thm-3.3.A] |
| 肩奇点 | shoulder singularity | $a_2c_2+a_3c_{23}=0$，腕点落在第一关节轴上 | [@thm-3.3.A] |
| 零空间 | null space $\mathcal N(J)$ | 不产生末端运动的关节速度集合 | [@thm-3.4.B] |
| 零空间投影 | $P=NN^{\mathrm T}$ | 秩 $n-r$；$P\dot{\boldsymbol q}_0$ 不惊动末端 | [@thm-3.4.B] |
| 内部运动 / 自运动 | internal motion / self-motion | 只改内部姿态、不改末端的运动 | [@thm-3.4.B] |
| 右伪逆 | right pseudo-inverse $J^\dagger$ | $J^{\mathrm T}(JJ^{\mathrm T})^{-1}$；给出最小范数解 | [@def-3.5.1] |
| 最小范数解 | minimum-norm solution | 满足任务且 $\|\dot{\boldsymbol q}\|$ 最小 | [@def-3.5.1] |
| 阻尼最小二乘 | damped least squares, DLS | 容许末端误差 $\delta$ 换可解性 | [@def-3.5.2] |
| 奇异情形广义逆 | $J^*$ | $W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T}+K^{-1})^{-1}$ | [@def-3.5.2] |
| 可操作度 | manipulability $w(q)$ | $\sqrt{\det(JJ^{\mathrm T})}$；离零越远离奇点越远 | [3.5.1](ch03/sec3-5.md#sec-3.5.1) |
| 分析雅可比 | analytic Jacobian $J_A$ | 用欧拉角速率 $\dot{\boldsymbol\varphi}$ 而非角速度 $\boldsymbol\omega$ | [@def-3.6.1] |
| 换基矩阵 | $T(\boldsymbol\varphi)$ | $\boldsymbol\omega_e=T\dot{\boldsymbol\varphi}_e$；三列 = 欧拉角三根转轴 | [@thm-3.6.A] |
| 逆雅可比方案 | — | $\dot{\boldsymbol q}=J_A^{-1}(\dot{\boldsymbol x}_d+Ke)$，完全线性化 | [3.7.1](ch03/sec3-7.md#sec-3.7.1) |
| 转置方案 | — | $\dot{\boldsymbol q}=J^{\mathrm T}Ke$，省计算、非线性 | [3.7.2](ch03/sec3-7.md#sec-3.7.2) |

## 六、静力学（3.8）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 末端广义力 | $F_e=[\boldsymbol f_e;\boldsymbol\mu_e]$ | 3 平动力 + 3 转动力矩 | [@def-3.8.1] |
| 运动静力学对偶 | kinematic-static duality | $\boldsymbol\tau=J^{\mathrm T}F_e$；速度变换的转置即力变换 | [@def-3.8.1] |
| 虚功原理 | principle of virtual work | 静态平衡时系统总虚功为零——$\boldsymbol\tau=J^{\mathrm T}F_e$ 的推导依据 | [@def-3.8.1] |
| 可操作椭球 | manipulability ellipsoid | 由 $w(q)$ 刻画末端各方向的运动 / 施力能力；**课程不讲** | [3.8.3](ch03/sec3-8.md#sec-3.8.3) |

## 七、轨迹规划（4.1–4.3）

| 术语 | 英文 | 一句话含义 | 出处 |
|:--|:--|:--|:--|
| 路径 | path | 纯几何描述：经过哪些点、连成什么形状 | [@def-4.1.1] |
| 轨迹 | trajectory | 指定了**时间律**的路径（每点的速度 / 加速度） | [@def-4.1.2] |
| 运动规划 | motion planning | 轨迹规划 + 避障 + 优化（动态过程，含动力学） | [@def-4.1.3] |
| 运动律 | motion law | 表征从初始位姿到最终位姿过渡过程的函数 | [@thm-4.1.A] |
| 三次多项式 | cubic polynomial | 4 系数 / 4 约束；最小能量解的形式 | [@def-4.2.1] |
| 五次多项式 | quintic polynomial | 6 系数 / 6 约束；可指定初终加速度 | [@def-4.2.2] |
| 梯形速度曲线 | trapezoidal velocity profile | 匀加速—巡航—匀减速；工业最常用 | [@def-4.2.3] |
| 抛物线混合 | parabolic blend / LSPB | 梯形速度积分后的位置形态（直线 + 两端抛物线） | [@def-4.2.3] |
| 巡航速度 | cruise velocity $\dot q_c$ | 梯形中段的常值速度 | [@def-4.2.4] |
| 路径点 | path point | 轨迹必须到达的指定点 | [@def-4.2.5] |
| 样条 | spline | 保证函数及其导数连续的分段多项式；三次样条保证**加速度连续** | [@def-4.2.6] |
| 虚拟点 | virtual point | 只施加连续性约束、不指定位置的两个辅助点 | [@thm-4.2.G] |
| 三对角系统 | tridiagonal system | $A\boldsymbol\Pi=b$；$A$ 与关节无关、可用 $O(N)$ 代入求解 | [@thm-4.2.H] |
| 经由点 | via point | 抛物线混合下轨迹**只从附近经过**的点 | [@def-4.2.7] |
| 时间超前 | time advance $\Delta t_j$ | 前一分段未完成就启动下一段，避免停顿 | [@thm-4.3.D] |
| 路径基元 | path primitive | 解析表达路径几何的基本单元（直线、圆弧） | [@def-4.3.1] |
| 弧长参数化 | arc-length parameterization | 用弧长 $s$ 作路径参数，使 $t=\mathrm dp/\mathrm ds$ 自动归一 | [@def-4.3.1] |
| 切线 / 法线 / 副法线 | tangent / normal / binormal | Frenet 标架 $(t,n,b)$；$n$ 指向凹侧（向心加速度方向） | [@thm-4.3.A] |
| 向心加速度 | centripetal acceleration | 圆弧上 $\dot s^2/\rho$，只改速度方向 | [@ex-4.3.C] |
| 旋转矩阵插值 | — | **不可**逐元素插值（破坏正交性） | [@thm-4.3.E] |
| 角和轴 | angle-axis | 用一根固定轴 $r'$ + 转角 $\theta$ 表示姿态变化 | [@thm-4.3.F] |

---

## 八、执行器与传感器（5.1–5.4）

| 术语 | 一句话含义 | 首次出现 |
|:--|:--|:--|
| 执行系统 actuating system | 能源 + 功放 + 伺服发动机 + 传动装置四部分串成的功率链 | [@def-5.1.1] |
| 功率放大器 power amplifier | 受控制信号调制、向发动机供给功率的环节；放大的是**功率**不是信号 | [@def-5.1.11] |
| 能源 power supply | 向放大器提供一级功率 $P_e$（电源 / 液压源） | [@def-5.1.13] |
| 传动装置 transmission | 把发动机工况匹配到关节工况的部件；三重作用：定量 / 定性 / 减重 | [@def-5.1.3] |
| 圆柱齿轮 spur gears | 改变旋转轴与作用点，旋转 → 旋转 | [@method-5.1.C] |
| 丝杠 lead screws | 旋转 → 平移，用于移动关节；常预装滚珠丝杠减小摩擦 | [@method-5.1.C] |
| 同步带 / 正时链 timing belts and chains | 把发动机远置的传动；带快（轻）、链重（耐大力矩） | [@method-5.1.C] |
| 直接驱动 direct drive | 不加减速器直连关节；无间隙弹性但控制复杂 | [@def-5.1.4] |
| 伺服发动机 servomotor | 能起伺服作用的发动机（电动 / 液压 / 气动） | [@def-5.1.5] |
| 伺服电机 electric servomotor | 机器人上用得最多的发动机；分永磁直流与无刷直流 | [@def-5.1.7] |
| 无刷直流伺服电机 brushless DC servomotor | 永磁转子 + 多相定子 + 静态整流器；靠位置传感器换相 | [@def-5.1.8] |
| 静态整流器 static rectifier | 无刷电机里按转子位置生成各相馈入序列的电子部件 | [@def-5.1.8] |
| 步进电动机 stepper motor | 由激磁序列控制、**不需要转角测量**的电机；动态性能受载荷影响 | [@def-5.1.9] |
| 液压伺服发动机 hydraulic servomotor | 基于压缩流体容积变化；低速大转矩 | [@def-5.1.10] |
| 电液伺服系统 electrohydraulic servo system | 用电控信号驱动分布器、调制流速的接口 | [@def-5.1.12] |
| 分布器 distributor | 改变从能源传到发动机的流体流速的元件 | [@def-5.1.12] |
| 储液器 accumulator | 储存液压能、抑制压力振荡；作用同滤波电容 | [@note-5.1.4] |
| 斩波器 chopper | DC-DC 变换器，控制永磁直流电机 | [@thm-5.1.D] |
| 逆变器 inverter | DC-AC 变换器，控制无刷直流电机 | [@thm-5.1.D] |
| 反电动势 back emf $V_g$ | 与角速度成正比的电枢电压降落，$V_g=k_v\Omega_m$ | [@def-5.2.1] |
| 电流反馈 current feedback | 由 $k_i$ 测量电枢电流、经 $C_i(s)$ 调节的局部回路 | [@def-5.2.2] |
| 速度控制发电机 velocity-controlled generator | 不加电流反馈时的驱动特性；抗扰好 | [@thm-5.2.A] |
| 力矩控制发电机 torque-controlled generator | 加电流反馈时的驱动特性；力矩独立于转速 | [@thm-5.2.A] |
| 减速比 $k_r$ | $\omega_m/\omega=r/r_m$；机器人上典型值几十到几百 | [@def-5.2.4] |
| 等效惯量 / 等效摩擦 $I_{eq},F_{eq}$ | 负载惯量与摩擦按 $1/k_r^2$ 折算到电机轴的结果 | [@thm-5.2.C] |
| 独立关节近似 | 把关节间耦合当干扰、逐轴独立设计的假设 | [@def-5.2.5] |
| 测速反馈 tachometric feedback | 用速度传感器构成内环，改善瞬态与带宽 | [@method-5.2.E] |
| 本体传感器 proprioceptive sensor | 测量机械手**自身内部状态量**（关节位置、速度、关节力矩） | [@def-5.3.1] |
| 外部传感器 exteroceptive sensor | 测量机械手与**环境交互**的量（力、距离、视觉） | [@def-5.4.1] |
| 电位计 potentiometer | 滑动电阻分压测角；便宜但有线性度与磨损问题 | [@def-5.3.2] |
| 编码器 encoder | 光电式角位置→数字量传感器；绝对式 / 增量式 | [@def-5.3.3] |
| 格雷码 Gray code | 相邻码字只差一位，避免多轨翻转的过渡误差 | [@thm-5.3.B] |
| 旋转变压器 / 感应同步器 resolver / inductosyn | 电磁式角位置传感器，耐恶劣环境 | [@note-5.3.1] |
| 测速发电机 tachometer | 输出电压正比于转速的速度传感器 | [@method-5.3.A] |
| 张力计 / 应变片 strain gauge | 贴于受力元件上、把应变转为电阻变化的敏感元件 | [@def-5.4.2] |
| 腕力传感器 wrist force sensor | 装于腕部、测 3 力 + 3 力矩分量的六维力传感器 | [@def-5.4.3] |
| 传感器校准矩阵 | 把 8 个张力桥输出重构成 6 个力/力矩分量的标定矩阵 | [@thm-5.4.A] |
| 约束坐标系 constraint frame | 力/运动控制所参照的接触点坐标系 | [@method-5.4.B] |
| 接近传感器 / 敏感距离 | 判断「有无」的传感器与其有效作用距离 | [@def-5.4.4] |
| 声纳测距 sonar | $d=vt/2$；音速随温度修正 | [@thm-5.4.B] |
| 激光三角测量 / 激光雷达 | 两种激光测距原理：几何三角与飞行时间 | [@method-5.4.C] |
| 视觉传感器 vision sensor | 相机 + 图像处理；可见光/红外/超声三类 | [@def-5.4.5] |
| 相机校准矩阵 $\Xi$ | 内参数 × 透视 × 外参数的合成 | [@def-5.4.5] |

## 附 · 易混术语对照

| 这两者常被混淆 | 区别 |
|:--|:--|
| 精度 / 重复定位精度 | 精度 = 与标称值的偏差（可标定改善）；重复精度 = 回访一致性 | 
| 可达工作空间 / 灵活工作空间 | 前者只需一个方向能到，后者要任意方向都能到 |
| 本质冗余 / 功能冗余 | 结构上 $n>m$ / 任务上 $n>r$ |
| 轨迹规划 / 运动规划 | 生成时间律 / 解决避障 |
| 几何雅可比 / 分析雅可比 | 用 $\boldsymbol\omega$（正交基）/ 用 $\dot{\boldsymbol\varphi}$（非正交的欧拉角轴） |
| $J^{-1}$ / $J^\dagger$ / $J^*$ | 方阵满秩 / 冗余（行满秩）/ 奇异邻域（阻尼） |
| 右乘 / 左乘 | 绕当前轴（动系）/ 绕固定轴（定系） |
| 移动关节 / 转动关节 | 平动（$q_i=d_i$）/ 转动（$q_i=\vartheta_i$） |
| 开式链 / 闭式链 | 无回路（可直接数自由度）/ 有回路（须扣约束） |
| 精度 / 分辨率 | 本课程只讲前者；后者是编码器等硬件指标 |
| 奇点 / 病态 | 前者 $\det J=0$（结构性）；后者 $\det J$ 很小（邻域，同样危险） |
| 表示奇点 / 运动学奇点 | 前者属姿态**表示**（欧拉角歧义）；后者属机械**结构**（轴共线）——两者在 $J_A$ 处汇合 |
| 路径点 / 经由点 | 前者必须**到达**；后者只从**附近经过**（抛物线混合的削角） |
| 路径 / 轨迹 | 纯几何 / 几何 + 时间律 |
| 三次 / 五次多项式 | 4 约束（可指定位置 + 速度）/ 6 约束（再加初终加速度） |
| 梯形速度 / 三角形速度 | 有巡航段 / 无巡航段（加速度下界取等） |
| 指定加速度 / 指定巡航速度 | LSPB 的两种等价入口，二选一 |
| 虚拟点 / 路径点 | 虚拟点**不指定位置**，只为连续性而设 |
| 弧长 / 一般参数 | 弧长使 $\|dp/ds\|=1$；一般参数 $\sigma$ 需再归一化 |
| 向心加速度 / 切向加速度 | 改**方向**（$\dot s^2/\rho$，平行 $n$）/ 改**大小**（$\ddot s$，平行 $t$） |
| 位置规划 / 姿态规划 | 归结到 $s(t)$ / 归结到 $\theta(t)$（角和轴）或三欧拉角 |
| 李群 / 李代数 | 旋转本身（群：不可交换、带约束）/ 无穷小旋转（切空间：线性 + 叉积）；$\exp$ 与 $\log$ 在两者间往返 |
