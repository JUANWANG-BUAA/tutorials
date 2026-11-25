# 习题集 · 第十章 移动机器人建模

本页为配套教程的**自编练习**，服务于 2026-11-23 第 12 周课堂内容。本周平台布置的第一次作业（围绕独轮小车撰写 1 份完整 PDF）已另在 [作业十](homework10.md) 给出完整推导与数值验算；**不能把本页练习当作平台作业本身**。先独立推导，再展开答案核对。

## A · 检查理解（概念与坐标系）

1. 移动机器人定义中的「机器人」三个字具体要求包含哪三大子系统？为什么不能把开环遥控车称为完整的自主移动机器人？
2. 为什么 GPS 直接输出的 LLA（经纬高）坐标不适合直接代入轮式机器人的运动学模型计算？
3. 「载体坐标系原点选在后轴中点还是几何中心，会改变小车实际的转弯半径吗？」用一句话说明理由。

::: sol A 组参考要点
1. 必须包含**感知、规划、控制**闭环系统。开环遥控平台缺乏对环境的实时感知定位与轨迹误差反馈修正（[10.1.1](sec10-1.md#sec-10.1.1)–[10.1.2](sec10-1.md#sec-10.1.2)）。
2. LLA 是定义在地球椭球面上的球面地理坐标，经纬度单位在不同纬度对应的米制弧长不同，直接对其求导无法与车体平面直角速度建立常比例关系，必须先投影转换到局部惯性系或 ENU 系（[10.2.2](sec10-2.md#sec-10.2.2)）。
3. **不会**。原点选择只改变位形分量 $(x,y)$ 的数学定义与状态方程外观，不改变物理车体的真实运动与瞬时转动中心（[10.2.2](sec10-2.md#sec-10.2.2)）。
:::

## B · 练习技巧（约束、李括号与运动学推导）

4. 试验证向量场 $g_1 = [1,\ 0,\ 0]^{\mathrm T}$ 与 $g_2 = [0,\ 1,\ 0]^{\mathrm T}$ 的李括号 $[g_1, g_2]$，并判断平面全向移动平台（可任意前移和横移，无朝向耦合）的约束分布是否对合。
5. 检验 [@ex-10.3.2] 中的第一条约束 $a_1^T(q)\dot q = \dot q_2 - q_3\dot q_1 = 0$（位形 $q=(q_1,q_2,q_3)^{\mathrm T}$）单独看是否满足可积性条件 (10.3-3)。
6. 已知差速驱动小车轮半径 $r=0.05\,\mathrm m$、轮距 $d=0.40\,\mathrm m$，若希望小车以 $v=0.5\,\mathrm{m/s}$、角速度 $\omega=1.0\,\mathrm{rad/s}$ 逆时针转弯行进，求左、右轮目标角速度 $\omega_L,\omega_R$。
7. 若把独轮车模型的原点改取在轮心正前方距离为 $L>0$ 的参考点 $P(x_P,y_P)$ 上（即 $x_P = x + L\cos\theta,\ y_P = y + L\sin\theta$），写出 $(\dot x_P, \dot y_P)^{\mathrm T}$ 关于 $(v,\omega)^{\mathrm T}$ 的关系矩阵，并求该矩阵的行列式。

::: sol B 组参考要点
4. $g_1,g_2$ 均为常向量，雅可比全为零，故 $[g_1,g_2]=\mathbf 0\in\Delta$。分布对合；若只考虑 $(x,y)$ 平面位置无其他约束（$m=n=2$），系统自由全向移动且完整。
5. $a_1 = (-q_3,\ 1,\ 0)^{\mathrm T}$。若存在非零积分因子 $\gamma$，对 $(i,j)=(1,3),(2,3)$ 由 (10.3-3) 得 $\frac{\partial(-\gamma q_3)}{\partial q_3} = 0 \implies -\gamma - q_3\frac{\partial\gamma}{\partial q_3} = 0$ 且 $\frac{\partial\gamma}{\partial q_3} = 0$，立刻推出 $\gamma\equiv 0$。故单条 $a_1$ 不可积（非完整）。
6. 由 $\omega_R = \frac{v + (d/2)\omega}{r} = \frac{0.5 + 0.2\times 1.0}{0.05} = 14\,\mathrm{rad/s}$，$\omega_L = \frac{v - (d/2)\omega}{r} = \frac{0.5 - 0.2\times 1.0}{0.05} = 6\,\mathrm{rad/s}$。
7. 求导得 $\dot x_P = v\cos\theta - L\omega\sin\theta$，$\dot y_P = v\sin\theta + L\omega\cos\theta$，写成矩阵：
   $$\begin{bmatrix}\dot x_P\\\dot y_P\end{bmatrix} = \begin{bmatrix}\cos\theta & -L\sin\theta \\ \sin\theta & L\cos\theta\end{bmatrix}\begin{bmatrix}v\\\omega\end{bmatrix},$$
   行列式为 $L(\cos^2\theta+\sin^2\theta)=L\neq 0$。这说明**车头前方偏移点 $P$ 可以直接沿平面任意方向移动**（这是输入-输出反馈线性化轨迹跟踪的常用技巧）。
:::

## C · 拓展延伸（高阶系统与动力学接口）

8. 对前轮驱动两轮车模型 (10.5-7)，当转向角 $\phi = \pi/2$ 时车体会发生什么物理运动？对比后轮驱动模型 (10.5-4) 在 $\phi=\pi/2$ 时的奇异表现有何区别？
9. 试从无漂移独轮车模型出发，写出将其速度输入 $(v,\omega)$ 提升为状态量、加速度 $(\dot v,\dot\omega)$ 作为新输入时的二阶有漂移扩展方程，并说明此时「$u_{\mathrm{new}}=0$ 仍会继续运动」意味着什么。

::: sol C 组参考要点
8. 前驱模型在 $\phi=\pi/2$ 时，$\dot x = 0,\ \dot y = 0,\ \dot\theta = v/l$——前轮完全横着驱动，车体绕静止的后轴中点作纯原地旋转，方程有界无奇异；而后驱模型中 $\tan(\pi/2)\to\infty$，因为后轮试图保持零侧滑而前轮横卡住路面，产生结构锁死奇异（[10.5.3](sec10-5.md#sec-10.5.3)–[10.5.4](sec10-5.md#sec-10.5.4)）。
9. 扩展状态 $\xi=[x,y,\theta,v,\omega]^{\mathrm T}$，输入 $\eta=[a,\alpha]^{\mathrm T}=[\dot v,\dot\omega]^{\mathrm T}$，方程为 $\dot\xi = [v\cos\theta,\ v\sin\theta,\ \omega,\ 0,\ 0]^{\mathrm T} + \begin{bmatrix}0_{3\times 2}\\I_2\end{bmatrix}\eta$。当 $\eta=0$ 时，只要当前速度 $(v,\omega)\neq 0$，位姿 $(x,y,\theta)$ 仍随时间漂移演化，对应物理惯性滑行（[10.6.3](sec10-6.md#sec-10.6.3)）。
:::
