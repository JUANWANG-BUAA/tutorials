# 8.5 约束运动：接触允许哪些速度和力

前几节一直把机械臂压向某根单轴弹簧来建立直觉。但真正拿起毛刺打磨平板或把圆柱销插入孔内时，工具并不是“在所有方向上都受到约束”：法线方向顶着工件表面无法穿透，切向却沿着平面滑动；绕法线可以自转，绕切向却被板面顶住不能倾斜。如何用严格、可扩展到任意六维接触几何的线性代数语言，把“哪里该控力、哪里该控运动”从根源上拆分干净？本节从完整几何约束出发，建立互易对偶子空间的数学框架。

<a id="sec-8.5.1"></a>

## 8.5.1 从几何约束方程导出约束雅可比与虚功互易性

设刚体末端执行器在自由空间共有 6 个独立自由度（广义坐标维度 $n \ge 6$）。当末端与刚性环境建立持续接触时，几何边界限制使关节构型必须时刻落在某组光顺且局部独立的完整代数约束方程上：

$$\boldsymbol{\phi}(\boldsymbol{q}) = \boldsymbol{0} \in \mathbb R^m, \qquad m < 6.$$

假设接触保持不脱离且不计摩擦。将几何约束对时间求一次导，立刻封死了末端绝对不允许越雷池一步的运动方向：

$$J_\phi(\boldsymbol{q})\dot{\boldsymbol{q}} = \boldsymbol{0}, \qquad J_\phi(\boldsymbol{q}) = \frac{\partial\boldsymbol{\phi}}{\partial\boldsymbol{q}} \in \mathbb R^{m\times n}.$$

这里 $J_\phi$ 是关节点处的**约束雅可比矩阵**（若改在任务空间坐标 $\boldsymbol{x}_e$ 上定义几何方程 $\boldsymbol{\phi}_x(\boldsymbol{x}_e) = \boldsymbol{0}$，则两者通过几何/分析雅可比相联系：$J_\phi = (\partial\boldsymbol{\phi}_x/\partial\boldsymbol{x}_e)J_A$，切勿将两者不加换算直接混用）。

约束限制了速度空间，但由静止结构产生的接触反作用力又长什么样？

::: def 定义 8.5.1 · 理想无摩擦约束与互易对偶子空间 {#def-8.5.1}
在无摩擦刚性持续接触下，机械系统一切可行虚位移 $\delta\boldsymbol{q}$ 必须满足 $J_\phi(\boldsymbol{q})\delta\boldsymbol{q} = \boldsymbol{0}$（对应可行末端虚位移 $\delta\boldsymbol{x}_e$ 与可行速度 $\boldsymbol{v}_e$ 空间 $\mathcal V$）。由达朗贝尔虚功原理，理想约束反力不对任何可行虚位移做功：

$$\delta\boldsymbol{q}^{\mathrm T}\boldsymbol{\tau}_c = 0 \quad \text{与末端等效形式} \quad \delta\boldsymbol{x}_e^{\mathrm T}\boldsymbol{h}_e = 0.$$

令线性独立的基矩阵 $S_f \in \mathbb R^{6\times m}$ 张成广义接触反作用力子空间 $\mathcal F = \operatorname{Range}(S_f)$，$S_v \in \mathbb R^{6\times(6-m)}$ 张成可行末端速度子空间 $\mathcal V = \operatorname{Range}(S_v)$：

$$\boldsymbol{h}_e = S_f\boldsymbol{\lambda}, \qquad \boldsymbol{v}_e = S_v\boldsymbol{\nu},$$

其中 $\boldsymbol{\lambda}\in\mathbb R^m$ 为独立力坐标，$\boldsymbol{\nu}\in\mathbb R^{6-m}$ 为独立速度坐标。由瞬时功率对任意 $\boldsymbol{\lambda}, \boldsymbol{\nu}$ 恒为零（$\boldsymbol{h}_e^{\mathrm T}\boldsymbol{v}_e = 0$），力空间与运动空间严格构成**互易对偶关系（Reciprocity）**：

$$S_f^{\mathrm T} S_v = O_{m\times(6-m)}.$$
:::

根据线性代数正交补的基本关系，关节约束力矩 $\boldsymbol{\tau}_c = J^{\mathrm T}\boldsymbol{h}_e$ 对一切满足 $J_\phi\delta\boldsymbol{q} = \boldsymbol{0}$ 的 $\delta\boldsymbol{q}$ 均做功为零，当且仅当 $\boldsymbol{\tau}_c$ 落入 $J_\phi^{\mathrm T}$ 的列空间，即存在 $\boldsymbol{\lambda}\in\mathbb R^m$ 使得 $\boldsymbol{\tau}_c = J_\phi^{\mathrm T}(\boldsymbol{q})\boldsymbol{\lambda}$。将其投影到六维末端，便得出：约束越多的接触，力子空间维数 $m$ 越大，留给机器人自由运动的速度子空间维数 $6 - m$ 就越小，二者维数之和恒为 $6$。

需要格外小心一个概念边界：**$S_f^{\mathrm T}S_v = O$ 表达的是力空间与速度空间之间的功率互易性（内积为零即虚功率为零），而不是欧几里得几何意义下的“空间垂直”**。原因很简单：$\boldsymbol{h}_e$ 的前三项单位是 $\mathrm N$、后三项是 $\mathrm{N\cdot m}$，而 $\boldsymbol{v}_e$ 的前三项是 $\mathrm{m/s}$、后三项是 $\mathrm{rad/s}$；在未经加权或无量纲化统一长度尺度之前，对力向量与速度向量直接算普通欧氏夹角没有物理意义——但两个矩阵转置相乘对应的是**真实机械功率（单位 $\mathrm W$）**，在任何坐标系旋转下均严格为零且物理不变量。

<a id="sec-8.5.2"></a>

## 8.5.2 选择矩阵与投影构造

矩阵 $S_f$ 与 $S_v$ 分别称为**力选择矩阵**与**速度选择矩阵**。它们的列向量基底并不唯一：将某个方向的基向量乘以正标量或作线性组合，只要不改变各自张成的子空间 $\mathcal F$ 和 $\mathcal V$，依然满足 $S_f^{\mathrm T}S_v = O$。

在实际控制律中，为了把从六维传感器测出的广义力提取成降维力坐标 $\boldsymbol{\lambda}$，或把实际几何速度拆解成降维运动坐标 $\boldsymbol{\nu}$，常利用与所选度量一致的左广义逆（伪逆）：

$$\boldsymbol{\lambda} = S_f^+\boldsymbol{h}_e, \qquad \boldsymbol{\nu} = S_v^+\boldsymbol{v}_e, \qquad P_f = S_f S_f^+, \quad P_v = S_v S_v^+.$$

当选择的基底带有不同量纲（平动与转动混杂）或存在测量噪声时，求广义逆 $S_f^+, S_v^+$ 必须显式指定合理的正定加权度量矩阵（以统一米与弧度的尺度），不能脱离单位盲目套用无权伪逆。此外，如果机械臂沿着弯曲曲面打磨导致表面法向不断旋转，选择矩阵 $S_f(t), S_v(t)$ 便不再是常阵，必须在运行过程中随局部接触坐标系实时刷新。

## 8.5.3 建模边界：理想约束与实际接触的区别

严格区分两类容易混为一谈的物理情形：
- **理想刚性几何约束 $\boldsymbol{\phi}(\boldsymbol{q}) = \boldsymbol{0}$**：把表面当成完全不可压入的刚体壁，法线方向运动被彻底锁死（只能出现在力空间 $S_f$ 中），而切向允许运动（出现在速度空间 $S_v$ 中）。
- **含局部弹性变形的接触**：若进一步把工具/表面接触层的有限刚度 $K_e$ 写入模型，沿受约束法向实际上仍允许伴随接触力变化产生微小的弹性压入速率（下一节建立混合力/运动控制正需借助这个柔度映射 $C_e$ 将“力加速度”翻译为“末端运动加速度”）。切忌把法向弹性压入当成违反几何约束来否定互易子空间分解。

还应明确，上述完美互易分解依托“刚性、无摩擦、持续接触”三大理想假设。实际工况中的干摩擦会在运动子空间切向产生额外的阻力（必须作为已知摩擦模型前馈补偿或视为有界扰动），装夹脱离瞬间更会令维数 $m$ 发生跳变；接近运动学奇异位形时，$J^{\mathrm T}\boldsymbol{h}_e$ 到关节力矩的映射病态，即便子空间数学投影有解，物理关节电机也可能因为力臂为零而无法输出期望约束力。

## 8.5 小结与常见错误

- **一条主线**：几何约束 $\boldsymbol{\phi}(\boldsymbol{q}) = \boldsymbol{0} \in \mathbb R^m$ 限定了 $J_\phi\dot{\boldsymbol{q}} = \boldsymbol{0}$，进而借助无摩擦虚功为零的互易性，将六维末端空间对偶拆分成 $m$ 维力子空间 $\mathcal F = \operatorname{Range}(S_f)$ 与 $(6-m)$ 维速度子空间 $\mathcal V = \operatorname{Range}(S_v)$，满足 $S_f^{\mathrm T}S_v = O$。
- **度量界限**：互易性代表功率配对为零，并非同度量下的欧氏几何正交；平动/转动混合求伪逆时须声明加权尺度。
- **下一节**：[8.6 控制方向的选择](sec8-6.md) 把这对抽象子空间落到具体的物理坐标轴上，给出判定任意接触任务的通用四步法。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 速度约束：$J_\phi(\boldsymbol{q})\dot{\boldsymbol{q}} = \boldsymbol{0}$，$J_\phi = \partial\boldsymbol{\phi}/\partial\boldsymbol{q}$ | 约束局部独立、接触持续 | 混合（依约束） | 不要混淆关节空间约束雅可比与任务空间雅可比 |
| 互易约束力：$\delta\boldsymbol{q}^{\mathrm T}\boldsymbol{\tau}_c = 0 \implies \boldsymbol{\tau}_c = J_\phi^{\mathrm T}\boldsymbol{\lambda}$ | 理想无摩擦接触 | $\mathrm{N\cdot m}$ | 有切向摩擦时，反力不再严格位于 $J_\phi^{\mathrm T}$ 列空间内 |
| 互易选择分解：$\boldsymbol{h}_e = S_f\boldsymbol{\lambda}$，$\boldsymbol{v}_e = S_v\boldsymbol{\nu}$，$S_f^{\mathrm T}S_v = O$ | 同坐标统一功率配对 | $\mathrm W$（乘积） | 两矩阵基底不唯一，含平动转动耦合求广义逆时需定加权阵 |

::: think 常见错误清单 · 自查三条
1. 把 $S_f^{\mathrm T}S_v = O$ 理解成三维立体几何中的“力向量与速度向量空间垂直”：力和速度物理单位不同，实质是瞬间功率内积恒为零。
2. 遇到允许微小弹性压入的平面时直接否定 $J_\phi\dot{\boldsymbol{q}} = \boldsymbol{0}$ 的约束框架：压入来自表面微弹性，宏观法向仍归入人工控力子空间。
3. 在接近奇异构型处盲目信奉广义逆投影公式：投影在数学上总能算出来，不等于执行器有能力输出该方向所需的物理力或速度。
:::
