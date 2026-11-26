# 6.6 轨迹的动态标度（选学·精简）

[第 4 章](../ch04/sec4-1.md)根据位置、速度和加速度边界规划出参考关节轨迹 $\bar{\boldsymbol q}(r)$，但在带入真实负载后通过 [6.5 节](sec6-5.md) 逆动力学验算，常发现某一瞬间的关节力矩需求超出了电机的额定峰值 $\tau_{i,\max}$。如何在**完全不改变机械臂空间几何路径**的前提下，仅仅通过调整时间节奏来消减动态力矩？这就是**轨迹的动态标度（dynamic scaling of trajectories）**所要解决的问题。

## 6.6.1 重参数化变换与动态力矩分量分离

设原本的参考轨迹定义在原时间变量 $r$ 上，记作 $\bar{\boldsymbol q}(r)$，它对 $r$ 的一阶、二阶导数分别记作 $\bar{\boldsymbol q}'(r)=\frac{\mathrm d\bar{\boldsymbol q}}{\mathrm dr}$ 与 $\bar{\boldsymbol q}''(r)=\frac{\mathrm d^2\bar{\boldsymbol q}}{\mathrm dr^2}$。现在引入光滑、严格单调递增的时间重映射函数 $r = r(t)$（$\dot r>0$，把新物理时刻 $t$ 映射回原时间索引 $r$），构造保持几何形状完全不变的新轨迹：

$$\boldsymbol q(t) = \bar{\boldsymbol q}\bigl(r(t)\bigr).$$

利用链式法则求对物理时间 $t$ 的速度和加速度：

$$\dot{\boldsymbol q}(t) = \dot r(t)\,\bar{\boldsymbol q}'(r),\qquad \ddot{\boldsymbol q}(t) = \dot r^2(t)\,\bar{\boldsymbol q}''(r) + \ddot r(t)\,\bar{\boldsymbol q}'(r).$$

将问题聚焦于忽略摩擦与接触外力的主要动力学部分 $B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau$。为了看得更清晰，将依赖速度平方、呈纯二次齐次结构的 $C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}$ 按分量显式写为双线性缩写 $\Gamma(\boldsymbol q)[\dot{\boldsymbol q},\dot{\boldsymbol q}]$（即第 $i$ 行为 $\sum_{j,k}c_{ijk}(\boldsymbol q)\dot q_j\dot q_k$）。把方程拆分出仅与速度和加速度有关的**纯动态分量** $\boldsymbol\tau_s = \boldsymbol\tau - \boldsymbol g(\boldsymbol q)$，代回时间映射式：

$$\boldsymbol\tau_s(t) = B\bigl(\bar{\boldsymbol q}(r)\bigr)\bigl(\dot r^2\bar{\boldsymbol q}''(r) + \ddot r\bar{\boldsymbol q}'(r)\bigr) + \dot r^2\,\Gamma\bigl(\bar{\boldsymbol q}(r)\bigr)\bigl[\bar{\boldsymbol q}'(r),\,\bar{\boldsymbol q}'(r)\bigr].$$

定义原时间规律下的参考动态力矩分量 $\bar{\boldsymbol\tau}_s(r) \triangleq B(\bar{\boldsymbol q}(r))\bar{\boldsymbol q}''(r) + \Gamma(\bar{\boldsymbol q}(r))[\bar{\boldsymbol q}'(r),\bar{\boldsymbol q}'(r)]$，便得到一般时间标度方程：

$$\boxed{\ \boldsymbol\tau_s(t) = \dot r^2(t)\,\bar{\boldsymbol\tau}_s(r) + \ddot r(t)\,B\bigl(\bar{\boldsymbol q}(r)\bigr)\bar{\boldsymbol q}'(r),\qquad \boldsymbol\tau(t) = \boldsymbol\tau_s(t) + \boldsymbol g\bigl(\bar{\boldsymbol q}(r)\bigr)\ }$$

## 6.6.2 线性时间标度律与反直观边界

工程中最简便的选法是**均匀线性时间标度**：设期望将原运动总耗时拉长到原来的 $T$ 倍（记速率倍数为 $c = 1/T$），即

$$r(t) = \frac{t}{T} = ct \quad\Longrightarrow\quad \dot r = \frac{1}{T} = c,\quad \ddot r = 0.$$

代入一般标度式，消除含 $\ddot r$ 的项，得出核心缩放结论：

$$\boxed{\ \boldsymbol\tau_s(t) = \frac{1}{T^2}\,\bar{\boldsymbol\tau}_s\!\left(\frac{t}{T}\right) = c^2\,\bar{\boldsymbol\tau}_s(ct)\ }$$

**关键工程读法**：
- 在 $r(t)=ct$ 的约定下，**$c<1$（对应时间拉长倍数 $T=1/c>1$）才是放慢运动**，此时由速度和加速度造成的动态力矩幅值严格缩小到原来的 **$1/T^2$**（例如总耗时加倍 $T=2$，则动态分量精准降至原值的 $1/4$）。
- **但重力项完全不随时间标度缩放**：$\boldsymbol g(\bar{\boldsymbol q}(r))$ 仅依赖空间位形，无论把运动拖得多慢，经过同一几何位形时重力矩保持原值不变。

::: ex 注记 · 为什么“放慢两倍，所需总力矩反而变大”？
假设机械臂沿某段向下回摆的轨迹运动时，某位置静态重力补偿为 $+10\ \mathrm{N\cdot m}$，而高速加速段产生的惯性及速度动态分量为 $-8\ \mathrm{N\cdot m}$（净电机总需求仅 $\tau=10-8=2\ \mathrm{N\cdot m}$，刚好借动力学惯性抵消了大部分重力）。

现将运动耗时均匀拉长到原来的 $T=2$ 倍，则动态分量缩为原值的 $1/4$ 即 $-2\ \mathrm{N\cdot m}$，重力仍为 $+10\ \mathrm{N\cdot m}$，于是所需总电机力矩反而升至 $10-2=8\ \mathrm{N\cdot m}$！更有甚者，如果某位形本身重力保持就已超越驱动峰值（如 [6.3.2 节](sec6-3.md#part-6.3.2) 中需求 $14.715\ \mathrm{N\cdot m}$ 而限幅仅 $12\ \mathrm{N\cdot m}$），单靠均匀拉长时间永远无法满足约束。
:::

## 6.6.3 工程调节与局部非线性标度展望

实际校验时间拉长倍数 $T$ 时，必须沿整条离散轨迹对每个关节逐点核验：

$$\bigl|\boldsymbol g\bigl(\bar{\boldsymbol q}(t/T)\bigr) + \frac{1}{T^2}\bar{\boldsymbol\tau}_s(t/T)\bigr|_i \le \tau_{i,\max},\qquad \forall\,t,\ i=1,\dots,n.$$

线性标度仅调节一个全局常数 $T$，虽然极易实现，但为了迁移过单个尖峰超限点而牺牲了整条轨迹的工作节拍；若需要兼顾高速效率与力矩约束，则须引入仅在超限时段减慢速度的**非线性时间标度函数 $r(t)$**（求解含 $\dot r,\ddot r$ 约束的最优时间重分配问题）。

## 本节小结

- **轨迹动态标度本质**：保持空间路径 $\bar{\boldsymbol q}(r)$ 不变，通过 $r=r(t)$ 重排时刻律；线性拉长 $T$ 倍时动态部分 $\boldsymbol\tau_s$ 按 $1/T^2$ 缩放，但位置相关的重力矩 $\boldsymbol g(\boldsymbol q)$ 一成不变。
- **使用原则**：带重力场合不可套用简单的比例放慢估算法，须分别叠加 $\boldsymbol g$ 与 $\boldsymbol\tau_s/T^2$ 逐关节检验全部轨迹点。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 91:08 | [dynscale-goal.jpg](../assets/ch06/dynscale-goal.jpg) | 动态标度提出目标 | 6.6 开篇结合第四/五章工程限幅给出问题背景 |
| 92:04 | [dynscale-def.jpg](../assets/ch06/dynscale-def.jpg) | 重参数化 $r(t)$ 及链式导数 | 6.6.1 给出清晰链式求导 |
| 92:51 | [dynscale-subst.jpg](../assets/ch06/dynscale-subst.jpg) | 代入无摩擦运动方程 | 6.6.1 分离双线性项 $\Gamma[\bar{\boldsymbol q}',\bar{\boldsymbol q}']$ |
| 93:37 | [dynscale-tau-s.jpg](../assets/ch06/dynscale-tau-s.jpg) | $\boldsymbol\tau_s$ 换标通用表达式 | 6.6.1 导出通用 $\dot r^2,\ddot r$ 式 |
| 94:30 实况 | [dynscale-board.jpg](../assets/ch06/dynscale-board.jpg) | 板书推导现场 | 推导全已书面展开 |
| 95:27 | [dynscale-linear.jpg](../assets/ch06/dynscale-linear.jpg) | 线性标度 $1/T^2$ 律 | 6.6.2 显式统一 $T$ 与 $c=1/T$ 口径并给出反向增长反例 |
| 96:06 | [dynscale-proscons.jpg](../assets/ch06/dynscale-proscons.jpg) | 线性标度优缺点评价 | 6.6.3 比较全局稳健调节与非线性局部降速 |
:::
