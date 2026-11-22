# 3.8 静力学

末端执行器顶住工件时，为保持静力平衡，各关节需要输出多大的力矩？前面用雅可比 $J$ 把关节速度映射到末端速度；这里从虚功出发，会得到末端广义力与关节力矩的关系 $\tau=J^{\mathrm T}F_e$。我们还要留意力的方向、坐标系和力矩参考点。录播 0:03:02–0:19:28（开课即讲）+ 2:27:09–2:27:52（末段）。

<a id="sec-3.8.1"></a>

## 3.8.1 运动静力学对偶与 $\tau=J^{\mathrm T}F_e$

老师在开课导论里就直接给出了结论（0:17:41–0:19:23）：「关节需要输出的力矩，按静态平衡，等于**几何雅可比的转置**再乘以末端执行器所受到的六维力（三个平动的力 + 三个转动的矩）。物理意义就是：末端受力和矩时，为保持机械臂静态平衡，每个关节电机要输出什么样的力矩。」他同时交代，这个结论的推导「基于虚功原理和能量守恒」。

::: def 定义 3.8.1 · 末端广义力与关节力矩 {#def-3.8.1}
$$F_e=\begin{bmatrix}f_e\\ \mu_e\end{bmatrix}\in\mathbb R^6\qquad(3\ \text{平动力}+3\ \text{转动力矩}),\qquad
\tau=[\tau_1,\dots,\tau_n]^{\mathrm T}$$
转动关节的 $\tau_i$ 是驱动力矩（N·m），移动关节的 $\tau_i$ 是驱动力（N）；统称关节广义力。$f_e$ 的单位为 N，$\mu_e$ 为 N·m，后者关于指定工具点取矩。不同类型的 $\tau_i$ 不能不加权直接比较大小。


以下统一约定 $F_e$ 为**机械臂向环境施加**的末端广义力；环境作用在机械臂上的反作用广义力为 $F_{\mathrm{env}}=-F_e$。$F_e$ 与 $J$ 均在基坐标系表示，力矩参考点取末端原点。忽略重力、摩擦等其他负载时，静力平衡关系（**运动静力学对偶**）为：

$$\boxed{\ \tau=J^{\mathrm T}(q)\,F_e\ }$$
:::

::: proof 推导（虚功原理，对照 2:27:09–2:27:52 课件页）
设关节虚位移 $\mathrm dq$，对应末端的虚平移与无穷小虚转角堆叠为 $\mathrm dx_e=J\,\mathrm dq$；后者不是欧拉角增量。

- 关节驱动力矩的虚功：$\mathrm dW_\tau=\tau^{\mathrm T}\mathrm dq$；
- 环境反作用力的虚功：$\mathrm dW_{\mathrm{env}}=F_{\mathrm{env}}^{\mathrm T}J\,\mathrm dq=-F_e^{\mathrm T}J\,\mathrm dq$。

静态平衡时**总虚功为零**：

$$\mathrm dW_\tau+\mathrm dW_{\mathrm{env}}=(\tau^{\mathrm T}-F_e^{\mathrm T}J)\,\mathrm dq=0.$$

对任意 $\mathrm dq$ 成立，故 $\tau^{\mathrm T}=F_e^{\mathrm T}J$，取转置得 $\tau=J^{\mathrm T}F_e$。若把符号用于环境施加的力，则应写成 $\tau=-J^{\mathrm T}F_{\mathrm{env}}$。□
:::

::: intuition 为什么是 $J^{\mathrm T}$ 而不是 $J^{-1}$ / $J^\dagger$
速度关系 $v_e=J\dot q$ 从 $n$ 维关节速度得到6维末端速度。要求对应的关节力矩时，利用两端功率相等：$\dot q^{\mathrm T}\tau=v_e^{\mathrm T}F_e=(J\dot q)^{\mathrm T}F_e=\dot q^{\mathrm T}J^{\mathrm T}F_e$。这对任意 $\dot q$ 成立，因而 $\tau=J^{\mathrm T}F_e$。这里用的是转置，不是逆；$J$ 为长方阵或降秩时，这个关系仍然成立。
:::

下图将两条关系放在一起：上行用 $J$ 从关节速度求末端速度，下行用 $J^{\mathrm T}$ 从末端广义力求关节力矩；中间的功率等式连接了它们。

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-38-title fig-38-desc">
<title id="fig-38-title">速度映射与力映射的转置对偶</title>
<desc id="fig-38-desc">左为关节空间：上行是 n 维关节速度、下行是 n 维关节力矩；右为操作空间：上行是 6 维末端速度、下行是 6 维广义力。上行箭头从左到右标 J，下行箭头从右到左标 J 转置，中间框写明功率守恒把两个矩阵钉成转置关系。</desc>
<defs>
<marker id="f38-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="f38-b" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-blue)"/></marker>
<marker id="f38-g" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-green)"/></marker>
</defs>
<text class="diagram-text" x="460" y="36" text-anchor="middle">速度与力的变换：互为转置的对偶</text>
<rect class="diagram-node" x="60" y="70" width="190" height="196" rx="10"/>
<text class="diagram-text" x="155" y="96" text-anchor="middle">关节空间（n 维）</text>
<rect x="85" y="112" width="140" height="48" rx="8" stroke="var(--fig-blue)" fill="var(--accent)" fill-opacity=".04"/>
<text class="diagram-text" fill="var(--fig-blue)" x="155" y="132" text-anchor="middle">关节速度 q′</text>
<text class="diagram-note" x="155" y="151" text-anchor="middle">n 个关节</text>
<rect x="85" y="196" width="140" height="48" rx="8" stroke="var(--fig-green)" fill="var(--sage)" fill-opacity=".06"/>
<text class="diagram-text" fill="var(--fig-green)" x="155" y="216" text-anchor="middle">关节力矩 τ</text>
<text class="diagram-note" x="155" y="235" text-anchor="middle">每个电机出多大力矩</text>
<rect class="diagram-node" x="670" y="70" width="190" height="196" rx="10"/>
<text class="diagram-text" x="765" y="96" text-anchor="middle">操作空间（6 维）</text>
<rect x="695" y="112" width="140" height="48" rx="8" stroke="var(--fig-blue)" fill="var(--accent)" fill-opacity=".04"/>
<text class="diagram-text" fill="var(--fig-blue)" x="765" y="132" text-anchor="middle">末端速度 v<tspan class="sb">e</tspan></text>
<text class="diagram-note" x="765" y="151" text-anchor="middle">线速度 + 角速度</text>
<rect x="695" y="196" width="140" height="48" rx="8" stroke="var(--fig-green)" fill="var(--sage)" fill-opacity=".06"/>
<text class="diagram-text" fill="var(--fig-green)" x="765" y="216" text-anchor="middle">广义力 F<tspan class="sb">e</tspan> = (f, μ)</text>
<text class="diagram-note" x="765" y="235" text-anchor="middle">力 + 力矩</text>
<line x1="250" y1="136" x2="670" y2="136" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#f38-b)"/>
<text class="diagram-text" fill="var(--fig-blue)" x="460" y="118" text-anchor="middle">J：v<tspan class="sb">e</tspan> = J q′（正问题，一次乘法）</text>
<line x1="670" y1="220" x2="250" y2="220" stroke="var(--fig-green)" stroke-width="2.2" marker-end="url(#f38-g)"/>
<text class="diagram-text" fill="var(--fig-green)" x="460" y="248" text-anchor="middle">J<tspan class="sp">T</tspan>：τ = J<tspan class="sp">T</tspan> F<tspan class="sb">e</tspan>（力反向传递，不求逆）</text>
<rect class="diagram-node" x="330" y="152" width="260" height="48" rx="9" stroke="var(--accent)"/>
<text class="diagram-text" fill="var(--accent-text)" x="460" y="172" text-anchor="middle">功率守恒：q′<tspan class="sp">T</tspan>τ = v<tspan class="sb">e</tspan><tspan class="sp">T</tspan> F<tspan class="sb">e</tspan></text>
<text class="diagram-note" x="460" y="191" text-anchor="middle">对任意 q′ 成立 ⇒ 两矩阵互为转置</text>
<text class="diagram-note" x="460" y="300" text-anchor="middle">无需方阵、无需满秩——对偶比求逆更普适；静力平衡专用，含惯性 / 科氏力时回到动力学方程</text>
<text class="diagram-note" x="460" y="322" text-anchor="middle">同一 J 的两副面孔：正向传速度（第 3 章主线），转置传力（本节）</text>
</svg>
<figcaption>运动静力学对偶（本教程绘）：由 $v_e=J\dot q$ 和功率等式 $\dot q^{\mathrm T}\tau=v_e^{\mathrm T}F_e$，得到 $\tau=J^{\mathrm T}F_e$。推导不要求 $J$ 是方阵或满秩。</figcaption>
</figure>

老师对它的定位很清楚：「主要是记住这个公式就可以」（0:25:53）；在导论里说：「其实我们可以不讲 PPT，大家就记住这些内容就可以了」（0:19:21）。使用公式时，如果速度和力分别用不同坐标系表示，还要先处理坐标变换。

::: ex 跟算 · 顶住工件时两个关节各出多少力矩？
沿用 §3.1.D 的两杆各 1 m、$q=(0,\pi/2)$，只保留平面速度的 $v_x,v_y,\omega_z$ 三行：

$$\bar J=\begin{bmatrix}-1&-1\\1&0\\1&1\end{bmatrix}.$$

希望机械臂在工具点向环境施加 $f=(0,10)$ N 和逆时针力矩 $\mu_z=2$ N·m，忽略其他负载。求平衡所需驱动力矩：

$$\tau=\bar J^{\mathrm T}\begin{bmatrix}0\\10\\2\end{bmatrix}
=\begin{bmatrix}12\\2\end{bmatrix}\ \mathrm{N\cdot m}.$$

第一关节有 1 m 的水平力臂，向上的力贡献 10 N·m；第二关节到工具点的矢径竖直，该力不贡献力矩。末端力矩则对两个关节各贡献 2 N·m。环境实际作用在机械臂上的力和矩与这里的输入反号。

若保持同一向上作用力、撤去末端力矩，即 $\mu_z=0$，则 $\tau=(10,0)^{\mathrm T}\,\mathrm{N\cdot m}$。第五章会把这组关节侧力矩折算到电机侧；那里仍先忽略杆的重量、惯量和摩擦。

再回到原例的 $\mu_z=2\,\mathrm{N\cdot m}$，只把力改为 $f=(10,0)$ N，先预测关节力矩的正负，再相乘。结果为 $\tau=(-8,-8)^{\mathrm T}$ N·m：向右的力对两关节都贡献 $-10$ N·m，再各加 2 N·m。若用虚速度 $\dot q=(1,-1)$ rad/s 核对，原例与这一组负载的两端功率分别为 10 W 和 0 W；这只是检验映射的虚速度，并非说静止时实际有这些功率。
:::

<a id="sec-3.8.2"></a>

## 3.8.2 两坐标系间的速度与力变换

上面用 $J$ 和 $J^{\mathrm T}$ 联系了关节与末端。现在还要同时处理表达基和力矩参考点。为明确符号，设刚体上两点为 $A,B$，$\tilde p$ 为从 $A$ 指向 $B$ 的位移、用坐标系 1 表示，$R_1^0$ 将系 1 分量变到基系 0。右侧 $v_1,\omega_1$ 是以 $A$ 为参考点的速度，$f_1,\mu_1$ 是以 $A$ 为力矩参考点的同一广义力；左侧改用点 $B$ 和基系分量，分别记为 $\dot p_1^0,\omega_1^0,f_1^0,\mu_1^0$。这是教材式 (3.112)–(3.116) 在本节两点记号下的改写：

$$\begin{bmatrix}\dot p_1^0\\ \omega_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&-R_1^0S(\tilde p)\\ 0&R_1^0\end{bmatrix}\begin{bmatrix}v_1\\ \omega_1\end{bmatrix},
\qquad
\begin{bmatrix}f_1^0\\ \mu_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&0\\ -R_1^0S(\tilde p)&R_1^0\end{bmatrix}\begin{bmatrix}f_1\\ \mu_1\end{bmatrix}$$

记左侧速度变换矩阵为 $A$，则右侧力变换矩阵是 $A^{-\mathrm T}$，不是 $A^{\mathrm T}$。这是因为两式都从坐标系 1 的表示变到坐标系 0：要保持功率不变，力必须按速度变换的逆转置变换。反过来，若将力从坐标系 0 变回坐标系 1，使用的才是 $A^{\mathrm T}$。平移项在速度和力矩的变换中分别产生耦合；可与 [3.1.3](sec3-1.md#sec-3.1.3) 的 $J^u$ 对照，那里只改变表达坐标系的旋转块。

速度来自 $v_B^0=R_1^0v_A^1+\omega^0\times(R_1^0\tilde p)$；力矩来自 $\mu_B^0=R_1^0\mu_A^1-(R_1^0\tilde p)\times f^0$。两式都在改参考点，不能只旋转分量而漏掉耦合项。特别是上式力变换的左下块为负号：它由同方向的逆转置关系确定。

::: ex 跟算 · 挪动参考点，功率能否保持不变？
先不旋转表达基，取 $R_1^0=I$、$\tilde p=(0.1,0,0)^{\mathrm T}$ m，点 $A$ 的速度为零，$\omega_1=(0,0,2)^{\mathrm T}$ rad/s，$f_1=(0,10,0)^{\mathrm T}$ N、$\mu_1=(0,0,1)^{\mathrm T}$ N·m。点 $B$ 的线速度为 $(0,0.2,0)^{\mathrm T}$ m/s，关于 $B$ 的力矩为 $\mu_1^0=(0,0,0)^{\mathrm T}$ N·m。两端功率均为 2 W：在 $A$ 是 $0+2\times1$，在 $B$ 是 $0.2\times10+0$。

把位移长度改为 0.2 m，其余输入保持不变，先猜力矩是否仍为零。核对：$v_B^0=(0,0.4,0)^{\mathrm T}$ m/s，$\mu_B^0=(0,0,-1)^{\mathrm T}$ N·m，功率为 $0.4\times10+2\times(-1)=2$ W。力矩可以反号，但功率不因参考点改变而改变。若误用正号，第一组会算出 2 N·m 的力矩和 6 W 的功率，立即与输入的 2 W 冲突。
:::

老师应用提示（2:27:34）：「最后还有一个任务：在（不同）姿态坐标系与基坐标系之间做表示的转换，后面大家应用的时候要考虑一下。」传感器、工件和工具可能使用不同坐标系；计算平衡时，要让力与速度使用相互配套的坐标表示和参考点。

<a id="sec-3.8.3"></a>

## 3.8.3 闭链与可操作椭球（了解）

本节最后两块内容只作了解，知道「有这一块」即可：

- **闭链静力学**（课件图示，2:27:25）：多机器人 / 闭链结构里，力的分配需要额外约束（内力不可任意指定）。本节只点明「有这一块」，细节留到后续章节；
- **可操作椭球**（了解，2:26:01 老师明确「不讲」）：「跟手术机器人手臂的**灵巧性**设计相关」——它由 $w(q)=\sqrt{\det(JJ^{\mathrm T})}$ 与速度 / 力椭球刻画末端在各方向上的运动 / 施力能力，也可在 [3.5.1](sec3-5.md#sec-3.5.1) 的可操作度 $\dot q_0$ 里作为优化目标。教材上有对应内容，自学。

### 3.8.3.1 用二维例子分清速度椭圆与力集合

这里不增加闭链的求解要求，只把“速度 / 力椭球”的条件说清楚。选定纯平移二维任务，所有力均采用前面的“机械臂向环境施加”约定。若 $J$ 行满秩，约束总关节力矩 $\|\tau\|_2\le T$，由 $\tau=J^{\mathrm T}f$ 得

$$f^{\mathrm T}JJ^{\mathrm T}f\le T^2.$$

它与速度集合不同：在 $\|\dot q\|_2\le Q$ 下，速度椭圆的半轴为 $Q\sigma_i$；力集合在同一任务方向上的半轴为 $T/\sigma_i$。需要行满秩，才能把力集合称为有界椭球；混合平动 / 转动任务或混合关节单位时，还须先规定特征长度、关节尺度或权重，不能把牛顿与牛顿米直接放进同一个未加权范数比较。

::: ex 跟算 · 速度容易产生的方向，施力也容易吗？
给定当前局部位置雅可比 $J=\operatorname{diag}(2,0.5)$ m/rad，两个关节都是转动关节。取 $Q=1$ rad/s、$T=1$ N·m，约束分别是总速度范数与总力矩范数，而不是每个关节单独限幅。

速度椭圆半轴为 2 和 0.5 m/s。力集合则满足

$$4f_x^2+0.25f_y^2\le1,$$

其中 $f_x,f_y$ 按 N 代入，两个半轴为 0.5 和 2 N。若分别施加 $(1,0)$ N 与 $(0,1)$ N，所需力矩为 $(2,0)$ N·m 与 $(0,0.5)$ N·m，前者超过总力矩上限，后者未超过。这是在同一参考点、同一位形和同一尺度下比较：较大的速度半轴对应较小的力半轴。

现在把第二个系数从 0.5 降为 0，先预测两个集合各怎样退化，再核对：速度只能沿 $x$ 方向，$v_y=0$；力集合成为条带 $|f_x|\le0.5$ N，$f_y$ 在这个理想模型中不受关节力矩范数约束。因为 $J^{\mathrm T}(0,f_y)^{\mathrm T}=0$，该方向不能沿用有限的倒数半轴，力集合也不再是有界椭圆。“无界”不意味着真实机构能承受无限力；结构强度、接触和其他负载均不在此模型中。
:::

<a id="sec-3.8"></a>

::: think 默写点 · 合上书再写（主动回忆）

先独立写出下面三条，再展开核对。

1. 用虚功原理推出 $\boldsymbol\tau=J^{\mathrm T}F_e$。
2. 为什么力变换是 $J^{\mathrm T}$ 而不是 $J^{-1}$ 或 $J^\dagger$？
3. 两坐标系间的速度变换与力变换是什么关系？

::: sol 核对

取 $F_e$ 为机械臂向环境施加的力，环境反作用力为 $-F_e$。由 $\mathrm dx_e=J\mathrm dq$，总虚功为 $(\tau^{\mathrm T}-F_e^{\mathrm T}J)\mathrm dq=0$，对任意虚位移成立，故 $\tau^{\mathrm T}=F_e^{\mathrm T}J$，即 $\boldsymbol\tau=J^{\mathrm T}F_e$。

因为能量必须守恒：$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau=\boldsymbol v_e^{\mathrm T}F_e=(J\dot{\boldsymbol q})^{\mathrm T}F_e=\dot{\boldsymbol q}^{\mathrm T}J^{\mathrm T}F_e$，对任意 $\dot{\boldsymbol q}$ 成立。**无需方阵、无需满秩**——这正是对偶比求逆更普适之处。

若速度由坐标系 1 变到坐标系 0 的矩阵为 $A$，同方向的力变换为 $A^{-\mathrm T}$；反方向的力变换才是 $A^{\mathrm T}$。两者保证功率在变换前后相同。

:::

:::

## 3.8 小结与常见错误

- 由虚功原理得到 $\tau=J^{\mathrm T}F_e$：给定机械臂向环境施加的末端广义力，可求静力平衡所需的关节力矩。
- 变换坐标表示时，同方向的速度和力分别使用 $A$ 与 $A^{-\mathrm T}$；闭链静力学与可操作椭球在本节只作了解。
- **下一章**：[第四章 轨迹规划](../ch04/sec4-1.md) 回到运动侧，给关节与末端的运动安排时间——本节算出的关节力矩，正是检验那些轨迹是否「出得起」的依据（第五、六章补齐驱动与动力学后闭环）。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| $\tau=J^{\mathrm T}(q)F_e$ | 静力平衡（虚功原理）；$F_e$ 为机械臂向环境施加、参考点=末端原点、与 $J$ 同在基系 | N·m（R）/ N（P） | 无需方阵满秩；环境反作用力 $F_{\mathrm{env}}=-F_e$ 别代错号 |
| 功率恒等 $\dot q^{\mathrm T}\tau=v_e^{\mathrm T}F_e$ | 同一坐标系、同一参考点 | W | 虚速度检验两端功率是查符号的工具，不是实际功率 |
| $\begin{bmatrix}f^0\\\mu^0\end{bmatrix}=\begin{bmatrix}R&0\\-RS(\tilde p)&R\end{bmatrix}\begin{bmatrix}f\\\mu\end{bmatrix}$ | 同一刚体换参考点/表达基 | N、N·m | 力变换是速度变换的**逆转置** $A^{-\mathrm T}$，不是 $A^{\mathrm T}$；左下块负号 |
| 力集合半轴 $T/\sigma_i$（速度椭圆 $Q\sigma_i$） | $J$ 行满秩、统一的加权尺度 | N | 混合平动/转动任务须先定特征长度，不能把 N 与 N·m 放进同一范数 |

::: note 主线 · 两连杆（第四关 · 力与功率）
第二关的 $J_p$ 在本关换了用途：对 $q_A=(0,\pi/2)$ 施加末端力 $F=(0,10)\,\mathrm N$，由 $\tau=J_p^{\mathrm T}F$ 得两关节力矩 $(10,0)\,\mathrm{N\cdot m}$，并用虚速度核对两端功率——[两连杆第四关](../training/two-link.md#mission-force)，本节跟算已完整算了一遍；下一关（[§4.2.1](../ch04/sec4-2-1.md) 三次时间律）回到运动侧，为换肘姿安排时间。
:::

::: think 常见错误清单 · 自查三条
1. 用 $J^{-1}$ 或 $J^\dagger$ 传力——力变换是 $J^{\mathrm T}$（对偶），不是求逆；$J$ 是长方阵时同样成立；
2. 忘记力的坐标系或力矩参考点——$F_e$ 与 $J$ 必须使用配套的表示；传感器测得的力，要按 [3.8.2](#sec-3.8.2) 的关系变换到合适的坐标系和参考点；
3. 把 $\tau=J^{\mathrm T}F_e$ 用在动态 / 高速情形——它只是**静力**平衡式；一旦含惯性、科氏力，就必须回到动力学方程（见后续动力学章节）。
:::

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导、跟算与自绘对偶图；下列课件页保留以备核对，**不构成正文的替代**（对应录播 0:03:02–0:19:28 与 2:27:09–2:27:52）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 02:27:31 | [virtual-work.jpg](../assets/ch03/virtual-work.jpg) | 虚功原理 ⇒ 关节力矩与末端力的对偶 | 虚功推导、功率恒等式与符号约定完整给出；自绘对偶图替代 |
| — | [velocity-force-frames.png](../assets/ch03/velocity-force-frames.png) | 同一刚体两个固连坐标系的换算 | 3.8.2 两点记号改写（教材式 3.112–3.116）+ 功率不变跟算完整给出 |
:::
