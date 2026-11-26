# 8.7 混合力/运动控制

通过前两节，我们已经拿到了一对功率互易的选择矩阵 $S_f$ 和 $S_v$，它们清晰地划定了在约束坐标系 $\{C\}$ 里哪些自由度归力环管、哪些归速度环管。剩下的问题落在执行层：机械臂是一整台多自由度耦合的动力学装置，关节驱动力矩 $\boldsymbol{u}$ 同时推动着六个末端维度——**怎样写出具体的关节力矩控制律，让降维后的运动坐标 $\boldsymbol{\nu}$ 与力坐标 $\boldsymbol{\lambda}$ 真正分道扬镳、各自按各自的时间常数互不串扰地闭环？**

本节先在假设几何雅可比与接触刚度理想已知的框架下推导**操作空间混合力/运动控制（Hybrid Force/Motion Control）**的解耦结构，随后立刻说明工程中替代“力求导”和应对“时变斜面”的两项必要修正。

<a id="sec-8.7.1"></a>

## 8.7.1 操作空间逆动力学下的双子空间完全解耦

沿用[含接触动力学方程](sec8-1.md#def-8.1.1)，在几何雅可比 $J(\boldsymbol{q})$ 可逆的 6 自由度非奇异构型处（冗余臂需引入动力学一致广义逆与零空间投影，此不赘述），左乘 $J^{-\mathrm T}$ 将动力学映射至末端操作空间，记操作空间惯性阵 $B_e(\boldsymbol{q}) = J^{-\mathrm T}B J^{-1}$、末端力等效驱动 $\boldsymbol{\gamma}_e = J^{-\mathrm T}\boldsymbol{u}$ 及末端非线性补偿合项 $\boldsymbol{n}_e(\boldsymbol{q},\dot{\boldsymbol{q}}) = J^{-\mathrm T}(C\dot{\boldsymbol{q}} + F\dot{\boldsymbol{q}} + \boldsymbol{g}) - B_e\dot J\dot{\boldsymbol{q}}$：

$$B_e(\boldsymbol{q})\dot{\boldsymbol{v}}_e + \boldsymbol{n}_e(\boldsymbol{q},\dot{\boldsymbol{q}}) = \boldsymbol{\gamma}_e - \boldsymbol{h}_e.$$

这里全部向量均先旋转并表达在一致的约束坐标系 $\{C\}$（功率配对口径）下。按第 7 章逆动力学线性化思想，取外环力补偿与惯量前馈：

$$\boldsymbol{\gamma}_e = B_e(\boldsymbol{q})\boldsymbol{\alpha} + \boldsymbol{n}_e(\boldsymbol{q},\dot{\boldsymbol{q}}) + \boldsymbol{h}_e \iff \boldsymbol{u} = J^{\mathrm T}(\boldsymbol{q})\bigl(B_e\boldsymbol{\alpha} + \boldsymbol{n}_e + \boldsymbol{h}_e\bigr),$$

则无论是否接触，末端真实几何加速度都严格化为虚拟加速度指令 $\dot{\boldsymbol{v}}_e = \boldsymbol{\alpha}$。现在面临核心设计：**该如何构造六维指令 $\boldsymbol{\alpha}$，既能在速度子空间推动 $\dot{\boldsymbol{\nu}} = \boldsymbol{\alpha}_\nu$，又能沿受约束方向去压出期望的力二阶动态 $\ddot{\boldsymbol{\lambda}} = \boldsymbol{f}_\lambda$？**

注意到如果法向接触面不是绝对刚体而是带有局部弹性（受限力子空间上的等效柔度矩阵 $C_e$ 可逆；注意只能对受限力子空间 $S_f$ 张成的有限维刚度/柔度求逆，绝不能对切向零刚度的六维退化刚度阵直接求逆），则在接触几何与选择矩阵常值的局部假设下，末端几何速度可按子空间拆分并求二阶导联系起力加速度与平动/转动加速度。

::: thm 定理 8.7.1 · 混合力/运动控制的逆动力学解耦律 {#thm-8.7.1}
设接触几何与选择矩阵 $S_v, S_f$ 在局部保持常值且满足互易关系 $S_f^{\mathrm T}S_v = O$，受约束力方向具有对称正定局部柔度 $C_e$（即沿 $S_f$ 方向由局部弹性产生的小位移满足 $\dot{\boldsymbol{x}}_{c,f} \implies \ddot{\boldsymbol{x}}_{c,f} = C_e S_f \ddot{\boldsymbol{\lambda}}$，其中总末端速度可记作运动与微压入变形速率合成，且在刚度很高时受限柔度仅作用于力子空间加速映射）。在逆动力学线性化后的模型 $\dot{\boldsymbol{v}}_e = \boldsymbol{\alpha}$ 中，构造双通道指令：

$$\boldsymbol{\alpha} = S_v\boldsymbol{\alpha}_\nu + C_e S_f\boldsymbol{f}_\lambda,$$

其中 $\boldsymbol{\alpha}_\nu \in \mathbb R^{6-m}$ 为自由子空间加速度控制输入，$\boldsymbol{f}_\lambda \in \mathbb R^m$ 为约束子空间二阶力调节输入（如对 $\boldsymbol{\lambda}$ 的 PD 或 PI 律）。若令 $S_v, S_f$ 满足对应功率度量的加权互易分解（或在典型正交单位基 $S_v^{\mathrm T}S_v = I,\,S_f^{\mathrm T}S_f = I$ 下满足 $S_v^{\mathrm T}C_e S_f = O$），则运动闭环与力闭环彻底分离为两条独立的多变量线性积分链：

$$\dot{\boldsymbol{\nu}} = \boldsymbol{\alpha}_\nu, \qquad \ddot{\boldsymbol{\lambda}} = \boldsymbol{f}_\lambda.$$
:::

**推导思路**：利用局部弹性接触坐标关系 $\boldsymbol{v}_e = S_v\boldsymbol{\nu} + C_e S_f\dot{\boldsymbol{\lambda}}$ 对时间求导（因 $S_v, S_f, C_e$ 为常值）：

$$\dot{\boldsymbol{v}}_e = S_v\dot{\boldsymbol{\nu}} + C_e S_f\ddot{\boldsymbol{\lambda}}.$$

将控制指令 $\boldsymbol{\alpha} = S_v\boldsymbol{\alpha}_\nu + C_e S_f\boldsymbol{f}_\lambda$ 代入 $\dot{\boldsymbol{v}}_e = \boldsymbol{\alpha}$ 即得：

$$S_v(\dot{\boldsymbol{\nu}} - \boldsymbol{\alpha}_\nu) + C_e S_f(\ddot{\boldsymbol{\lambda}} - \boldsymbol{f}_\lambda) = \boldsymbol{0}.$$

由于 $S_v$ 张成无反力自由运动空间而 $C_e S_f$（通常选取主轴对齐时与 $S_f$ 同方向）张成线性无关的弹性压入约束空间，两者列空间直和分解整个 $\mathbb R^6$（特别地，左乘 $S_f^{\mathrm T}$ 时 $S_f^{\mathrm T}S_v = O$，仅剩 $S_f^{\mathrm T}C_e S_f(\ddot{\boldsymbol{\lambda}} - \boldsymbol{f}_\lambda) = \boldsymbol{0}$，因 $C_e$ 正定立得 $\ddot{\boldsymbol{\lambda}} = \boldsymbol{f}_\lambda$，再代回即得 $\dot{\boldsymbol{\nu}} = \boldsymbol{\alpha}_\nu$）。$\square$

由此，在**运动子空间**可直接为 $\boldsymbol{\alpha}_\nu$ 设计常规速度 PI 跟踪（或位置+前馈加速度闭环）：

$$\boldsymbol{\alpha}_\nu = \dot{\boldsymbol{\nu}}_d + K_P(\boldsymbol{\nu}_d - \boldsymbol{\nu}) + K_I\int_0^t (\boldsymbol{\nu}_d - \boldsymbol{\nu})\,d\tau,$$

而在**力子空间**可独立为 $\boldsymbol{f}_\lambda$ 设计二阶调节（例如包含期望力加速度前馈或对力误差设阻尼/比例）：

$$\boldsymbol{f}_\lambda = \ddot{\boldsymbol{\lambda}}_d + K_{D\lambda}(\dot{\boldsymbol{\lambda}}_d - \dot{\boldsymbol{\lambda}}) + K_{P\lambda}(\boldsymbol{\lambda}_d - \boldsymbol{\lambda}),$$

工程实现中切忌漏掉口径一致性检验：把从力传感器测到的原始力向量 $\boldsymbol{h}_e$ 乘以 $S_f^+$ 提取 $\boldsymbol{\lambda}$，把实测速度乘以 $S_v^+$ 提取 $\boldsymbol{\nu}$，两路增益矩阵的量纲和带宽都必须按各自子空间独立整定。

<a id="sec-8.7.2"></a>

## 8.7.2 工程落地必须绕开的两个陷阱：力求导噪声与时变斜面

上述理想框图看似完美，一旦直接搬进真实机器人代码里立刻会碰上两大实际难题：

1. **不能直接对力传感器信号微分来求 $\dot{\boldsymbol{\lambda}}$**
   力反馈闭环 $\boldsymbol{f}_\lambda$ 里需要力变化率 $\dot{\boldsymbol{\lambda}}$ 提供阻尼；如果直接对高频含噪的力传感器读数作差分数值求导，传感器毛刺会被成十上百倍放大成关节抖振。替代方案是**利用关节测速算出的接触方向速度乘以估计接触刚度**来代替实测力导数：

   $$\widehat{\dot{\boldsymbol{\lambda}}} = \widehat K_{e,f}\, S_f^{\mathrm T}\boldsymbol{v}_e \quad \text{（单轴即 } \widehat{\dot\lambda} = \hat k_y \dot y_c\text{）}.$$

   采用估计刚度 $\widehat K_{e,f} = \widehat C_e^{-1}$ 会让闭环极点随“估计刚度与真实表面刚度的比值”产生轻微漂移，因此须保留适度阻尼裕度，不可假装模型估计永远分毫不差。

2. **沿着曲面或斜面运动时，$\dot S_v\boldsymbol{\nu}$ 不能漏**
   对于倾角固定的一块平坦斜板（如[作业八习题 9-10](homework08.md) 中的 $\pi/4$ 斜平面），只需要在任务开头把操作空间动力学通过一个固定的常值旋转矩阵转到约束坐标系 $\{C\}$ 下即可照常使用常值 $S_f, S_v$，**绝不能在世界系里直接硬套全局 $x/y$**。如果末端是在**三维连续弯曲的曲面上滑行**，随着接触点局部法线不断转动，选择矩阵本身成了时间函数 $S_v(t)$，此时对 $\boldsymbol{v}_e = S_v(t)\boldsymbol{\nu}$ 求导必然冒出额外科氏似项：

   $$\dot{\boldsymbol{v}}_e = S_v(t)\dot{\boldsymbol{\nu}} + \dot S_v(t)\boldsymbol{\nu}.$$

   省略 $\dot S_v\boldsymbol{\nu}$ 只在平直工作表面或固定几何导轨上成立；若沿大曲率曲面高速抛光而不补偿 $\dot S_v\boldsymbol{\nu}$，运动指令会顺着法线往工件里“扎”或往外脱开。

<a id="sec-8.7.3"></a>

## 8.7.3 部署前五步核查清单

混合架构只解决了“各个方向如何分配控制率”，它本身**既不自动防止脱离接触，也不能无视执行器物理极限**。代码下发真机或运行闭环仿真前，必须按序核对以下五项：

1. **几何条件**：实际表面物理结构能否支撑自然约束（是否有局部凹陷、拐角导致脱开或卡死）？
2. **指令相容**：送入控制器的 $\boldsymbol{h}_d \in \mathcal F$ 与 $\boldsymbol{v}_d \in \mathcal V$ 是否完全正交互易，各自无越界分量？
3. **传感器口径**：传感器是否与控制系对齐在 $\{C\}$ 中、是否扣除工具重力与惯性力、“手对环境 vs 环境对手”正负号是否全链路统一？
4. **驱动与补偿边界**：逆动力学补偿是否接近真实动力学，关节力矩指令是否超出电机峰值或采样带宽？
5. **切换策略**：一旦从自由逼近转入接触、或者跨过倒角边线导致维数 $m$ 改变，是否有清晰的约束坐标重构与状态机平滑过渡？

## 8.7.4 回到实际平面打磨任务

回到本章开头引出的桌面打磨实例：在局部平展且固连于桌面的约束系 $\{C\}$ 中，切向 $x_C, y_C$ 规划期望滑动轨迹与速度，法向 $z_C$ 指定稳定压紧力 $\lambda_d$（若允许平面内绕法线自由旋转则控 $\omega_z$，对倾覆方向给定 $\mu_{x,d} = \mu_{y,d} = 0$）。在理想无摩擦建模下切向抗力设为零；面对真实砂纸摩擦时，切向滑行速度环积分项与动力学摩擦前馈会顶住切削阻力，而不至于让法向压紧环因为切向阻力的存在产生误差耦合。下一节我们就用这套框架给出一个所有数字都能一步一步手算出来的完整平面打磨算例。

## 8.7 小结与常见错误

- **一条主线**：借助操作空间逆动力学抵消非线性和接触力，把系统变成 $\dot{\boldsymbol{v}}_e = \boldsymbol{\alpha}$；随后用 $\boldsymbol{\alpha} = S_v\boldsymbol{\alpha}_\nu + C_e S_f\boldsymbol{f}_\lambda$ 在互易互补子空间里拆成互不干涉的速度环 $\dot{\boldsymbol{\nu}} = \boldsymbol{\alpha}_\nu$ 与力环 $\ddot{\boldsymbol{\lambda}} = \boldsymbol{f}_\lambda$。
- **工程必改两处**：用“关节/末端速度 $\times$ 估计接触刚度”替代力传感器直接微分；曲面运动时在加速指令中补齐 $\dot S_v\boldsymbol{\nu}$。
- **下一节**：[8.8 综合算例](sec8-8.md) 把坐标变换、选择矩阵与一阶速度型力环串联为一整套从头算到底的平面打磨闭环示例。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 逆动力学混合输入：$\boldsymbol{\gamma}_e = B_e\boldsymbol{\alpha} + \boldsymbol{n}_e + \boldsymbol{h}_e$，$\boldsymbol{\alpha} = S_v\boldsymbol{\alpha}_\nu + C_e S_f\boldsymbol{f}_\lambda$ | 非奇异、常值接触几何 | $\mathrm{N},\mathrm{N\cdot m}$ | $C_e$ 仅指受限力子空间柔度，不可对退化 6 维刚度全阵求逆 |
| 解耦双闭环：$\dot{\boldsymbol{\nu}} = \boldsymbol{\alpha}_\nu$（PI 跟踪），$\ddot{\boldsymbol{\lambda}} = \boldsymbol{f}_\lambda$（PD 调节） | 互补互易 $S_f^{\mathrm T}S_v = O$ | 各自子空间 | $\boldsymbol{h}_e$ 投影为 $\boldsymbol{\lambda}$ 与 $\boldsymbol{v}_e$ 投影为 $\boldsymbol{\nu}$ 口径须一致 |
| 速度估计力导数：$\widehat{\dot{\boldsymbol{\lambda}}} = \widehat K_{e,f}\,S_f^{\mathrm T}\boldsymbol{v}_e$ | 估计刚度 $\widehat K_{e,f}$、不脱离 | $\mathrm{N/s}$ | 刚度估计偏差会影响等效阻尼；切忌直接微分传感器原始噪声 |
| 时变几何求导：$\dot{\boldsymbol{v}}_e = S_v\dot{\boldsymbol{\nu}} + \dot S_v\boldsymbol{\nu}$ | 曲面滑动、法向转动 | $\mathrm{m/s^2},\mathrm{rad/s^2}$ | 曲率较大时漏掉 $\dot S_v\boldsymbol{\nu}$ 会引入法向撞击误差 |

::: think 常见错误清单 · 自查三条
1. 对着含切向零刚度的 $6\times 6$ 环境刚度阵直接求逆矩阵来拿 $C_e$：$C_e$ 只能在有支撑的受约束力子空间上定义。
2. 直接把 `diff(force_sensor)/dt` 送进混合力控制器 PD 环节：传感器高频噪声会打坏电机电流环。
3. 碰到斜平面（如 $45^\circ$ 斜板）没先把控制系旋转到接触法向与切向，继续按全球 $x,y$ 坐标套 $S_f,S_v$。
:::
