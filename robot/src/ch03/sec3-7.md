# 3.7 逆运动学算法

把误差当作「要消除的速度」输入，逆微分运动学就变成**反馈控制器**：$\dot q$ 是控制量、$e$ 是偏差，目标让 $e\to0$。本节把三套算法一次讲完——逆雅可比、雅可比转置、二阶算法。**快讲**：老师说考试不考，但实际开发必用。录播 2:24:15–2:27:34。

<aside class="lesson-brief" aria-label="3.7 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>逆微分运动学的三种解（[3.5](sec3-5.md)）；雅可比转置与伪逆；方向误差的三种表示（[2.5](../ch02/sec2-5.md)、[2.6](../ch02/sec2-6.md)、[2.4](../ch02/sec2-4.md)）。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>逆雅可比方案的误差一阶线性化；转置方案的「为什么省计算」；稳定性分析的 Lyapunov 视角；方向误差的三种表示；二阶算法与误差的二阶线性化。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能写出两种方案并比较「能否完全线性化」；能说出冗余情形该用伪逆；能说出二阶算法多考虑了什么。</p></div>
</aside>

::: note 本节的定位（老师原话）
「目的就是建立 $\dot q$ 与误差 $e$ 之间的关系——从控制的角度也就是设计一个控制器」（2:24:22）。数值逆解的细节「考试后面也不会考」（0:10:02），但实际开发要用——本节正是**控制视角的桥**，为后续动力学 / 控制章节铺路。节奏上**快讲**：课件后几页（算法比较、方向误差）「大家下面自己看一下」（2:25:53）。
:::

<a id="sec-3.7.1"></a>

## 3.7.1 逆雅可比方案

逆雅可比方案的做法最直接：正运动学的微分关系是 $\dot x=J_A\dot q$，既然能由 $\dot q$ 算出 $\dot x$，把 $J_A$ 求逆就能反过来由期望的末端速度推出关节速度。

设任务误差 $e=x_d-x$（期望位姿 $-$ 当前位姿），希望 $e$ 指数收敛，于是让末端速度取「期望速度 $\dot x_d$ 加一个正比于误差的修正项 $Ke$」，再映射回关节空间，即

$$\dot q=J_A^{-1}(q)\,\big(\dot x_d+K\,e\big)$$

验证一下：把 $\dot x=J_A\dot q$ 代入误差的导数 $\dot e=\dot x_d-\dot x$（$e=x_d-x$ 两边求导即得）：

$$\dot e=\dot x_d-J_A\dot q=\dot x_d-(\dot x_d+Ke)=-Ke
\qquad\Longrightarrow\qquad \dot e+Ke=0$$

可见误差动态被化成了**一阶线性系统**：只要 $K$ 正定，$e\to0$ 就指数收敛，收敛快慢由 $K$ 的取值决定。

::: note 冗余情形
$J_A$ 非方阵（冗余）时，把 $J_A^{-1}$ 换成右伪逆 $J_A^\dagger$（[3.5.1](sec3-5.md#sec-3.5.1)）；再带上零空间项，就能在完成末端任务的同时优化内部姿态。这正是 [3.5](sec3-5.md) 里「直接求逆」与「伪逆 + 零空间」两套解的复用。
:::

<a id="sec-3.7.2"></a>

## 3.7.2 雅可比转置方案

转置方案干脆绕开求逆：不解方程，直接用 $J^{\mathrm T}$ 把误差映回关节空间——

$$\dot q=J^{\mathrm T}K\,e$$

**为什么用转置**（2:24:56，老师特意点出动机）：「因为求逆很花计算量——知道 $J$ 要求 $J^{-1}$ 很花时间；用 $J^{\mathrm T}$ 直接调换一下元素位置就可以了。」省下求逆是有代价的——把两种方案摆在一起，得失才看得清：

- 逆方案能**完全线性化**：误差动态严格是一阶线性（$\dot e=-Ke$）；
- 转置方案**不能完全线性化**：误差动态是**非线性**的，$\dot e$ 不再是干净的 $-Ke$，而是多出含 $J$ 随位形变化的项——稳定性分析只能借助 **Lyapunov 函数**（学控制的同学有了解）。

::: intuition 直觉
$\dot q=J^{\mathrm T}Ke$ 是「沿误差在关节空间的**负梯度**方向走」——这里的「负梯度」是对关节变量 $q$ 而言，$\tfrac12\|e\|^2$ 的负梯度正是 $J^{\mathrm T}e$。$J^{\mathrm T}e$ 把操作空间的误差映射回关节空间（与静力学 $\tau=J^{\mathrm T}F_e$ 是同一个 $J^{\mathrm T}$ 机制——[3.8](sec3-8.md)），步长由 $K$ 控制。转置省去了求逆，但步长随位形变化，因此收敛只是**局部**的。
:::

两种方案看着不同，放进同一张闭环框图（下图）却是同一个结构：$\dot q$ 是控制量、$e$ 是偏差，「机器人 $k(q)$」是被控对象，反馈把当前位姿送回输入端——这正是把逆微分运动学当成**控制器**设计的视角。

<figure>
<svg class="figure-svg" viewBox="0 0 920 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-37-title fig-37-desc">
<title id="fig-37-title">逆微分运动学方案的闭环框图</title>
<desc id="fig-37-desc">期望位姿 xd 与测量反馈的当前位姿 x 相减得误差 e，经增益 K 与前馈 x′d 求和后，由 JA 的逆（冗余时伪逆）映射为关节速度 q′，机器人模型积分得到当前位姿；下方虚线框给出省去求逆的雅可比转置替代方案。</desc>
<defs>
<marker id="f37-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<text class="diagram-text" x="460" y="36" text-anchor="middle">逆微分运动学 = 把误差当速度的反馈控制器</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.8" marker-end="url(#f37-m)">
<line x1="142" y1="100" x2="176" y2="100"/>
<line x1="211" y1="100" x2="240" y2="100"/>
<line x1="320" y1="100" x2="360" y2="100"/>
<line x1="530" y1="100" x2="590" y2="100"/>
<line x1="760" y1="100" x2="800" y2="100"/>
</g>
<rect class="diagram-node" x="24" y="72" width="118" height="56" rx="9"/>
<text class="diagram-text" x="83" y="96" text-anchor="middle">期望位姿</text>
<text class="diagram-mono" x="83" y="116" text-anchor="middle">x_d</text>
<circle cx="196" cy="100" r="15" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.4"/>
<text class="diagram-mono" x="178" y="86">+</text>
<text class="diagram-mono" x="178" y="126">−</text>
<text class="diagram-mono" fill="var(--accent-text)" x="222" y="90">e</text>
<rect class="diagram-node" x="240" y="72" width="80" height="56" rx="9"/>
<text class="diagram-text" x="280" y="96" text-anchor="middle">K</text>
<text class="diagram-note" x="280" y="116" text-anchor="middle">增益</text>
<circle cx="330" cy="100" r="3.5" fill="var(--ink-2)"/>
<rect class="diagram-node" x="240" y="188" width="100" height="44" rx="9"/>
<text class="diagram-mono" x="290" y="216" text-anchor="middle">x′<tspan class="sb">d</tspan>（前馈）</text>
<line x1="330" y1="188" x2="330" y2="108" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f37-m)"/>
<rect class="diagram-node" x="360" y="72" width="170" height="56" rx="9" stroke="var(--accent)"/>
<text class="diagram-text" fill="var(--accent-text)" x="445" y="96" text-anchor="middle">J<tspan class="sb">A</tspan><tspan class="sp">−1</tspan>(q)</text>
<text class="diagram-note" x="445" y="116" text-anchor="middle">冗余 → 伪逆 J†（3.5.1）</text>
<rect x="360" y="196" width="170" height="50" rx="9" fill="none" stroke="var(--muted)" stroke-dasharray="6 4"/>
<text class="diagram-text" fill="var(--muted)" x="445" y="218" text-anchor="middle">J^T K（转置方案）</text>
<text class="diagram-note" fill="var(--muted)" x="445" y="236" text-anchor="middle">直接由 e 得 q′</text>
<line x1="445" y1="136" x2="445" y2="192" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="5 4"/>
<text class="diagram-note" fill="var(--muted)" x="458" y="170">或</text>
<text class="diagram-mono" x="560" y="90" text-anchor="middle">q′</text>
<rect class="diagram-node" x="590" y="72" width="170" height="56" rx="9"/>
<text class="diagram-text" x="675" y="96" text-anchor="middle">机器人 k(q)</text>
<text class="diagram-note" x="675" y="116" text-anchor="middle">内部：数值积分 q ← q′Δt</text>
<rect class="diagram-node" x="800" y="72" width="100" height="56" rx="9"/>
<text class="diagram-text" x="850" y="96" text-anchor="middle">当前位姿</text>
<text class="diagram-mono" x="850" y="116" text-anchor="middle">x</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f37-m)">
<path d="M850 128 V 274 H 196 V 121"/>
</g>
<text class="diagram-note" x="523" y="266" text-anchor="middle">测量反馈：e = x_d − x（方向误差的三种表示见 3.7.3）</text>
<text class="diagram-note" x="460" y="312" text-anchor="middle">逆方案完全线性化（e′ = −K e，指数收敛）；转置方案省求逆但误差非线性——K 取大不一定更好，需 Lyapunov 分析</text>
</svg>
<figcaption>逆运动学算法的统一框图（本教程绘）：实线主通路为逆雅可比方案（<a href="#sec-3.7.1">3.7.1</a>），虚线为雅可比转置方案（<a href="#sec-3.7.2">3.7.2</a>）——两者只是「误差 → 关节速度」那一块的实现不同；冗余时把 $J_A^{-1}$ 换成右伪逆并加零空间项即可。</figcaption>
</figure>

<a id="sec-3.7.3"></a>

## 3.7.3 方向误差与二阶算法

以上两种方案都假定误差 $e$ 已经算好。剩下两件事要交代：姿态那部分误差用什么表示，以及要不要把加速度也纳入算法。

**方向（姿态）误差的表示**（2:25:45）：「误差表示方式不同，求逆方法也不同。」同一个姿态误差有好几种写法，常用的有三种：

- **欧拉角**：$e_O=\varphi_d-\varphi$ 直接相减，写法最省事，却受 [@thm-2.4.B] 的奇点与多值困扰；
- **轴 / 角（angle-axis）**：用转轴加转角的写法，比欧拉角更通用，姿态控制 / 求逆算法常用（[2.5](../ch02/sec2-5.md)）；
- **四元数**（上一章 [2.6](../ch02/sec2-6.md)）：「姿态误差也可以用四元数」——无奇点，适合插值与误差度量。

（课件上的误差公式基于姿态列向量叉积，该处 OCR 受遮挡、不能逐字保证，本编按标准形式给出 $e_O\propto\sum_i r_i^d\times r_i^e$；读者以课件 / 教材为准。）

**二阶算法**（2:26:28）：上面两种一阶算法都只用速度；二阶算法把加速度也纳入进来，**同时考虑速度与加速度**：

$$\ddot e+K_D\,\dot e+K_P\,e=0$$

误差满足的是一个**二阶线性微分方程**——$K_D$（阻尼）与 $K_P$（刚度）的取值共同影响收敛的快慢与平稳程度。「后面讲控制（动力学）时可能会涉及。」

::: note 算法对比（课件页，自己看）
逆方案误差动态完全线性化，但每次都要算 $J^{-1}$（计算贵），无奇点处收敛快；转置方案省去了求逆，代价是只保证局部收敛、稳定性要 Lyapunov 分析；二阶算法把加速度也带进来，运动更平滑，但结构复杂（含 $\dot J$）。冗余情形三者统一换成伪逆。
:::

<a id="sec-3.7"></a>

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先写出下面几条，再展开核对。写不出来就说明这一节还没「拿走」。

1. 写出逆方案与转置方案各自的 $\dot{\boldsymbol q}$ 表达式，并各说一句特点。
2. 为什么转置方案不能按「完全线性化」设计增益？
3. 二阶算法比一阶多考虑了什么？

::: sol 核对

逆方案：$\dot{\boldsymbol q}=J_A^{-1}(\dot{\boldsymbol x}_d+Ke)$——**完全线性化**，误差方程严格线性；转置方案：$\dot{\boldsymbol q}=J^{\mathrm T}Ke$——省去求逆，但误差方程**非线性**。

因为它的误差方程没有化成 $\dot e=-Ke$ 那样的线性形式：$K$ 取大不一定更好，稳定性要用 Lyapunov 方法分析。

多考虑了 $\dot J(\boldsymbol q)$ 项——「考虑加速度」意味着误差方程里出现 $J$ 的时间导数，二阶算法让误差满足 $\ddot e+K_D\dot e+K_Pe=0$。

:::

:::

## 3.7 小结与常见错误

- **一条主线**：误差当输入 → 逆方案（完全线性化，代价是贵）/ 转置方案（省计算，只局部收敛）/ 二阶算法（含加速度）→ 方向误差的三种表示 → 冗余换伪逆。
- **考试口径**：本节**不考细节**；但「$J^{\mathrm T}$ 为什么省计算」「为何要 Lyapunov」这两问，正是理解 $J^{\mathrm T}$ 双重身份（控制 + 静力学）的好线索。

::: think 常见错误清单 · 自查三条
1. 用转置方案却按「完全线性化」设计增益——它的误差方程是非线性的，$K$ 取大不一定更好；
2. 方向误差用欧拉角直接相减却不处理奇点 / 多值——大姿态偏差时应改用轴角 / 四元数；
3. 二阶算法忽略 $\dot J(q)$ 项——「考虑加速度」意味着误差方程里出现 $J$ 的时间导数，实现时要补上这一块。
:::
