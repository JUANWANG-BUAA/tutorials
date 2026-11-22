# 6.6 轨迹的动态标度

课件 **§7.7「轨迹的动态标度」**（录播 01:27:15–01:36:48，标题 01:28:15、目标页 01:31:08），本教程编为 6.6。
本节回答：规划好的轨迹如果超出电机转矩，能不能不重画路径、只改时间？改变运动快慢可以调整所需转矩，但能否满足限制还要检查重力、摩擦和各关节的力矩范围。

::: note 来源与边界（本节）
- **教材对应**：教材第 7 章没有把这一节单独编号（或在习题/附注中），本页以课件为准；对应关系见节末待核。
- **课堂 vs 教材**：推导按课件板书整理；口述与公式符号方向不一致处保留原样，一并列入节末待核。文中「课件」指幻灯片、「老师」指口述。
:::

## 6.6.1 为什么需要动态标度

第 4 章规划了关节位置、速度和加速度，但轨迹平滑并不保证驱动力矩在电机能力范围内。老师在 01:27:35–01:28:18 提出的问题是：如果所需关节转矩超过电机能提供的转矩，机器人就不能按规划执行运动。

不改变路径，可以重新安排到达路径各点的时间。放慢运动通常能减小惯性和速度耦合力矩；但重力项不会因此消失，动态项还可能与重力项相互抵消。因此不能只凭「更慢」断定每一时刻的总力矩都更小。

## 6.6.2 时间标度函数与轨迹重参数化

设原轨迹为 $\bar{\boldsymbol q}(r)$，原时间参数 $r\in[0,\bar t_f]$；新轨迹用时间 $t\in[0,t_f]$。定义可两次求导的时间标度函数 $r(t)$，满足

$$r(0)=0,\qquad r(t_f)=\bar t_f,\qquad r(t)\ \text{随时间单调递增},$$

并把原轨迹**重参数化**为

$$\boxed{\ \boldsymbol q(t)=\bar{\boldsymbol q}\bigl(r(t)\bigr)\ }$$

其中 $\bar{\boldsymbol q}$ 保留原轨迹在各个原时间 $r$ 的关节位置；$r(t)$ 指明新轨迹在时刻 $t$ 走到原轨迹的哪个时刻。这样按同一顺序经过相同的关节位置，但快慢可以改变。

时间标度是一种保留原路径的重规划：它改变 $\boldsymbol q(t)$，但按相同顺序经过原来的关节位置。一般轨迹重规划还可以改变经过哪些位置，例如为避障改走另一条路径；只调整 $r(t)$ 不能实现这种绕行。

对时间求导（链式法则）：

$$\dot{\boldsymbol q}=\dot r\,\bar{\boldsymbol q}'(r),$$

$$\ddot{\boldsymbol q}=\dot r^2\,\bar{\boldsymbol q}''(r)+\ddot r\,\bar{\boldsymbol q}'(r),$$

其中 $\bar{\boldsymbol q}'=\mathrm d\bar{\boldsymbol q}/\mathrm d r$、$\bar{\boldsymbol q}''=\mathrm d^2\bar{\boldsymbol q}/\mathrm d r^2$。第一项是「路径二阶导数 × 速度平方」（弯曲/向心效应），第二项是「路径切向 × 切向加速度」；**时间标度的全部信息就藏在 $\dot r,\ddot r$ 里。**

## 6.6.3 代入动力学方程

为看清本质，课件略去阻尼、摩擦和末端力（$F_{\mathrm v}=F_{\mathrm s}=0,\boldsymbol h_c=\boldsymbol 0$），把关节空间方程写成

$$B(\boldsymbol q)\ddot{\boldsymbol q}+\Gamma(\boldsymbol q)[\dot{\boldsymbol q}\dot{\boldsymbol q}]
+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau,$$

其中 $\Gamma(\boldsymbol q)[\dot{\boldsymbol q}\dot{\boldsymbol q}]$ 就是 [6.1.3](sec6-1.md#part-6.1.3) 的 $C\dot{\boldsymbol q}$（课件用 $\Gamma$ 记）代入 $\dot{\boldsymbol q}=\dot r\bar{\boldsymbol q}'$、$\ddot{\boldsymbol q}=\dot r^2\bar{\boldsymbol q}''+\ddot r\bar{\boldsymbol q}'$：

$$\boxed{\ \dot r^2\Bigl(B(\bar{\boldsymbol q})\bar{\boldsymbol q}''(r)
+\Gamma(\bar{\boldsymbol q})[\bar{\boldsymbol q}'(r)\bar{\boldsymbol q}'(r)]\Bigr)
+\ddot r\,B(\bar{\boldsymbol q})\bar{\boldsymbol q}'(r)
+\boldsymbol g(\bar{\boldsymbol q})=\boldsymbol\tau\ }$$

同一条路径采用不同的 $r(t)$，一般得到不同的力矩曲线。式中惯性与速度耦合项分别受 $\ddot r$ 和 $\dot r^2$ 影响，重力项则不随运动快慢改变；各项相加后的总力矩不一定随速度降低而减小。

## 6.6.4 重力项与「速度/加速度转矩分量」

关键观察：**重力只依赖位置，不依赖时间标度**——同一点不管快慢经过，$\boldsymbol g(\bar{\boldsymbol q})$ 都一样。于是转矩分成两部分：

$$\boldsymbol\tau(t)=\underbrace{B\ddot{\boldsymbol q}+\Gamma[\dot{\boldsymbol q}\dot{\boldsymbol q}]}_{\boldsymbol\tau_s(t)}
+\underbrace{\boldsymbol g(\boldsymbol q)}_{\text{不随标度变}}.$$

去掉重力项，得到**速度/加速度引起的转矩分量**的换标关系：

$$\boldsymbol\tau_s(t)=\dot r^2\Bigl(B(\bar{\boldsymbol q})\bar{\boldsymbol q}''(r)
+\Gamma(\bar{\boldsymbol q})[\bar{\boldsymbol q}'(r)\bar{\boldsymbol q}'(r)]\Bigr)
+\ddot r\,B(\bar{\boldsymbol q})\bar{\boldsymbol q}'(r).$$

再定义**单位路径速度下的转矩分量**

$$\boxed{\ \bar{\boldsymbol\tau}_s(r)=B(\bar{\boldsymbol q}(r))\bar{\boldsymbol q}''(r)
+\Gamma(\bar{\boldsymbol q}(r))[\bar{\boldsymbol q}'(r)\bar{\boldsymbol q}'(r)]\ }$$

就有紧凑的换标式

$$\boxed{\ \boldsymbol\tau_s(t)=\dot r^2\,\bar{\boldsymbol\tau}_s(r)+\ddot r\,B(\bar{\boldsymbol q}(r))\bar{\boldsymbol q}'(r)\ }$$

它把参考轨迹与新时间律分开：固定以原时间 $r$ 参数化的参考轨迹后，$\bar{\boldsymbol\tau}_s(r)$ 已确定，$\dot r,\ddot r$ 决定如何重新执行。它并非只由不带参数的几何路径决定：改变参考轨迹沿路径的原速度分配，也会改变 $\bar{\boldsymbol q}',\bar{\boldsymbol q}''$。

## 6.6.5 简单线性标度：$r(t)=ct$

最简单的时间律是**线性标度**

$$r(t)=ct.$$

此时 $\dot r=c$、$\ddot r=0$，换标式退化为

$$\boxed{\ \boldsymbol\tau_s(t)=c^2\,\bar{\boldsymbol\tau}_s(ct)\ }$$

**方向要小心。** 按 $r=ct$，$c>1$ 是推进更快、$\boldsymbol\tau_s$ 放大 $c^2$ 倍，$c<1$ 才是放慢。工程上更习惯用**时间拉长倍数 $T$**（新时长 $=T\times$ 原时长，$T>1$ 表示放慢）：

$$r(t)=\frac{t}{T}\quad\Longleftrightarrow\quad c=\frac{1}{T},
\qquad
\boldsymbol\tau_s(t)=\frac{1}{T^2}\,\bar{\boldsymbol\tau}_s\!\left(\frac{t}{T}\right).$$

在本节忽略摩擦和末端力的模型中，时间拉长 $T$ 倍，速度和加速度引起的力矩分量**严格**变为对应原时刻的 $1/T^2$。例如 $T=2$ 时，该分量变为原来的 $1/4$（01:33:03–01:33:21）。

总力矩还要加回重力。假设某关节某位置的重力矩为 $10\ \mathrm{N\cdot m}$，原动态分量为 $-8\ \mathrm{N\cdot m}$，原总力矩是 $2\ \mathrm{N\cdot m}$；时间拉长两倍后，动态分量变成 $-2\ \mathrm{N\cdot m}$，总力矩反而增至 $8\ \mathrm{N\cdot m}$。这是因为原来的动态项抵消了部分重力。

**怎么选 $T$（或 $c$）**（01:33:48–01:34:01）：先用逆动力学沿原轨迹计算每个关节的动态分量与重力分量，再选择候选 $T$，逐点检查 $\boldsymbol\tau(t)=\boldsymbol g(\bar{\boldsymbol q}(t/T))+\bar{\boldsymbol\tau}_s(t/T)/T^2$ 是否满足各关节的力矩限制。忽略重力时，$T=\sqrt{|\bar\tau_s|_{\max}/\tau_{\max}}$ 可给出单个关节的估计；有重力时不能直接套用。若某处静态保持力矩已超限，单靠无限放慢也不能保证该处可行。

## 6.6.6 优缺点与适用场合

线性标度的优劣（01:34:01–01:34:20）：

| | 线性标度 $r=ct$ |
|:--|:--|
| **优点** | 极易实现，只需要调一个常数（$T$ 或 $c$）；不改变几何路径 |
| **缺点** | 不够灵活：整条轨迹统一拉长/缩短，可能为了一个超限点牺牲其他关节的性能，只是全局折中 |
| **适用** | 离线轨迹快速修正、教学演示、实时性要求不高的场合 |

更精细的做法是选**非线性** $r(t)$：超限时段慢、其余保持原速（「局部降速」），但要解带约束的时间律优化问题，实现复杂得多；课件只提了一句「你可以取其他形式来满足你的要求」（01:33:40–01:33:48）。

## 6.6.7 小结与常见错误

- **一句话**：动态标度 = **路径不变，重排时间**；$r(t)$ 重参数化原轨迹，$\dot r,\ddot r$ 决定新的速度/加速度与转矩，换标后 $\boldsymbol\tau_s=\dot r^2\bar{\boldsymbol\tau}_s(r)+\ddot r B\bar{\boldsymbol q}'$。
- **一个特例**：$r=ct$ 时 $\boldsymbol\tau_s=c^2\bar{\boldsymbol\tau}_s(ct)$；用 $T=1/c$ 说，时间拉长 $T$ 倍时动态分量精确缩为 $1/T^2$。
- **一个限制**：重力项不随标度变，总转矩不是严格 $c^2$ 缩放。
- **下一节**：[6.7 操作空间动力学模型](sec6-7.md) 把这套方程从关节空间搬到任务所在的操作空间，为第七章的操作空间控制备好模型。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| $\boldsymbol q(t)=\bar{\boldsymbol q}(r(t))$；$\dot q=\dot r\bar q'$，$\ddot q=\dot r^2\bar q''+\ddot r\bar q'$ | $r(t)$ 单调、两次可微 | — | $r$ 是「新时刻对应的原时刻」，不必等于 $t$；一般时间律 $\ddot r$ 项不能省 |
| $\boldsymbol\tau_s(t)=\dot r^2\bar{\boldsymbol\tau}_s(r)+\ddot r\,B\bar{\boldsymbol q}'$，$\bar{\boldsymbol\tau}_s=B\bar q''+\Gamma[\bar q'\bar q']$ | 忽略摩擦与末端力 | N·m | $\bar{\boldsymbol\tau}_s$ 还依赖参考轨迹的原速度分配，不是纯几何量 |
| 线性标度：$r(t)=ct$，$\boldsymbol\tau_s=c^2\bar{\boldsymbol\tau}_s(ct)$；拉长 $T$ 倍时 $=1/T^2$ | 同上 | N·m | 只对动态分量成立；总转矩要加回不变的重力项，可能反而变大 |
| 选 $T$：逐点检查 $\boldsymbol g+\bar{\boldsymbol\tau}_s/T^2$ 是否越限 | 逆动力学逐点算 | — | 忽略重力才有 $T=\sqrt{|\bar\tau_s|_{\max}/\tau_{\max}}$ 的估计；静态已超限则无限放慢也无解 |

::: think 常见错误清单

1. **混淆新时间和原时间参数**：本节 $r(t)$ 表示新时刻 $t$ 对应的原轨迹时刻；它也可作为路径参数使用，但不必等于 $t$。
2. **漏掉 $\ddot r$ 项**：只有 $r=ct$（$\ddot r=0$）时可省，一般时间律下 $\ddot r B\bar{\boldsymbol q}'$ 必须保留。
3. **以为重力也按 $c^2$ 缩放**：重力只依赖位置，同一点标度前后相同。
4. **把「转矩降到 $1/T^2$」当精确结论**：只对 $\boldsymbol\tau_s$ 成立，总转矩要加回重力。
5. **只检查一个关节**：应沿轨迹逐点逆解、取所有关节的最大值。
6. **线性标度万能论**：它简单但保守；局部超限时宜用非线性时间律或局部降速。
:::

::: think 默写点 · 合上书再写

1. 写出 $r(t)$ 的定义与重参数化 $\boldsymbol q(t)=\bar{\boldsymbol q}(r(t))$。
2. 写出 $\dot{\boldsymbol q},\ddot{\boldsymbol q}$ 关于 $\dot r,\ddot r,\bar{\boldsymbol q}',\bar{\boldsymbol q}''$ 的表达式。
3. 写出换标后的动力学方程与 $\bar{\boldsymbol\tau}_s(r)$ 的定义。
4. $r=ct$ 时 $\boldsymbol\tau_s$ 与 $c$ 的关系？时间拉长 2 倍时降到多少？
5. 为什么重力项不随标度变化？这对「拉长时间降转矩」有什么限制？
:::

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导与数值例；下列课件页保留以备核对，**不构成正文的替代**（对应录播 01:27:15–01:36:48）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 91:08 | [dynscale-goal.jpg](../assets/ch06/dynscale-goal.jpg) | 动态标度的目标与核心思想 | 6.6.1 完整重写，含「更慢不一定更小」的边界 |
| 92:04 | [dynscale-def.jpg](../assets/ch06/dynscale-def.jpg) | $r(t)$ 与重参数化 | 定义 + 链式求导 + 「保留路径的重规划」辨析 |
| 92:51 | [dynscale-subst.jpg](../assets/ch06/dynscale-subst.jpg) | 代入动力学方程 | 换标方程完整给出（课件 $\Gamma$ 记号保留） |
| 93:37 | [dynscale-tau-s.jpg](../assets/ch06/dynscale-tau-s.jpg) | $\tau_s$ 换标关系 | 两步定义 + 参考轨迹依赖性说明 |
| 95:27 | [dynscale-linear.jpg](../assets/ch06/dynscale-linear.jpg) | 线性标度 | $c$ 与 $T$ 两种记法并给；方向坑讲清 |
| 96:06 | [dynscale-proscons.jpg](../assets/ch06/dynscale-proscons.jpg) | 优缺点 | 三行对照表 + 非线性展望 |
| 94:30 实况 | [dynscale-board.jpg](../assets/ch06/dynscale-board.jpg) | 老师投影前讲解实况 | 内容已入正文，图不再单独承载信息 |
:::

::: note 待核（本节）
1. **课件公式里的一个上标**：投影上 $\bar{\boldsymbol\tau}_s$ 定义式括号内的第二个因子有时像 $\bar{\boldsymbol q}^{-1}(r)$；按上下文应取 $\bar{\boldsymbol q}'(r)$（速度耦合项换标后为 $\Gamma[\bar{\boldsymbol q}'\bar{\boldsymbol q}']$）。本页按 $\bar{\boldsymbol q}'$ 处理，建议对照原稿确认。
2. **课件口述的 $c$ 与公式的 $c$ 方向相反**：课件 §7.7 写「一般令 $c>1$，表示执行时间拉长，所需转矩的幅值约降低到原来的 $1/c^2$」；但按同页 $r(t)=ct$，$c>1$ 会让 $\dot r$ 更大、运动更快、转矩更大。最合理的解释是口述的 $c$ 为**时间拉长倍数**（本页 $T$），公式里 $c=1/T$，两者只差倒数。**待核**课件原稿/教材。
3. **与教材的对应**：教材第 7 章是否单列本节**待核**（可能在习题/附注中）。
:::
