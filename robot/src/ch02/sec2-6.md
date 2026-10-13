# 2.6 单位四元数

[2.5](sec2-5.md) 的角和轴表示虽然直观，却留下两个缺陷：一是**不唯一**——$(\vartheta,\boldsymbol r)$ 与 $(-\vartheta,-\boldsymbol r)$ 同姿（[@thm-2.5.A]）；二是 **$\sin\vartheta=0$ 处逆解奇异**（[@thm-2.5.B]）。本节要讲的**单位四元数**（unit quaternion，又称欧拉参数）用 4 个参数就把这两点一并修掉——它至今仍是全姿态机动平台（卫星等）与计算机图形学的标准姿态表示。

::: note 本节定位（教材补充 · 课程未授）
第 2 周录播未展开本节，仅在讲 RPY 奇点时提及「卫星等全姿态机动飞行器改用四元数」（录播 0:21:26）。为使本编完整覆盖原书 §2.1–§2.12，这里按原书 §2.6 收录本节；**考试不作要求**，但理解它与 [2.5](sec2-5.md) 的关系，能解释「为什么工程上会放弃直观的欧拉角」。
:::

<aside class="lesson-brief" aria-label="2.6 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p><a href="sec2-5.md">2.5</a> 角和轴表示（[@def-2.5.1]）、式 2.25 的 Rodrigues 矩阵；单位向量与向量叉积。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>四元数定义 $Q=\{\eta,\boldsymbol\epsilon\}$ 与单位约束；由四元数构造 $R$（式 2.33）、由 $R$ 反解四元数（式 2.34–2.35）；逆与乘积（式 2.36–2.37）——这几组公式都附直接推导，并把半角打包解读为「半角指数」。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能写出 $\eta,\boldsymbol\epsilon$ 与 $(\vartheta,\boldsymbol r)$ 的换算；能说清四元数为何同时解决「不唯一」与「逆解奇点」两个问题。</p></div>
</aside>

<a id="sec-2.6.1"></a>

## 2.6.1 定义与单位约束

::: def 定义 2.6.1 · 单位四元数 {#def-2.6.1}
**单位四元数**（欧拉参数）定义为四元组 $Q=\{\eta,\boldsymbol\epsilon\}$，其中

$$\eta=\cos\frac{\vartheta}{2},\qquad \boldsymbol\epsilon=\sin\frac{\vartheta}{2}\,\boldsymbol r\qquad(\text{原书式 }2.30\text{–}2.31)$$

$\eta$ 称**标量部分**，$\boldsymbol\epsilon=[\epsilon_x\ \epsilon_y\ \epsilon_z]^T$ 称**向量部分**，二者受单位约束

$$\eta^2+\epsilon_x^2+\epsilon_y^2+\epsilon_z^2=1\qquad(\text{原书式 }2.32)$$

故独立参数仍为 3 个（4 参数 − 1 约束），与最简表示的要求不矛盾。
:::

::: thm 原理 2.6.A · 四元数修掉了哪些缺陷 {#thm-2.6.A}
关键差别在**半角打包**：代入 $-\vartheta$ 与 $-\boldsymbol r$，得 $\cos\frac{-\vartheta}{2}=\cos\frac{\vartheta}{2}$、$\sin\frac{-\vartheta}{2}(-\boldsymbol r)=\sin\frac{\vartheta}{2}\boldsymbol r$——**同一结果**。
1. **消除了角和轴的表示不唯一**——$(\vartheta,\boldsymbol r)$ 与 $(-\vartheta,-\boldsymbol r)$ 是同一旋转的两组不同参数（[@thm-2.5.A]）；半角打包后这两组参数映射到**同一个**四元数，歧义坍缩为一个表示（原书：a rotation by $-\vartheta$ about $-\boldsymbol r$ gives the **same** quaternion as a rotation by $\vartheta$ about $\boldsymbol r$; this solves the nonuniqueness problem）；
2. **剩下的双重覆盖 $Q\sim-Q$ 来自 $\vartheta\sim\vartheta+2\pi$**——同一个物理旋转，转角再多加满一整圈（$\vartheta+2\pi$）时 $\eta\to-\eta$、$\boldsymbol\epsilon\to-\boldsymbol\epsilon$，故 $Q$ 与 $-Q$ 表示同一旋转。逆解式 2.34 的 $\eta\ge0$ 约定（$\vartheta\in[-\pi,\pi]$）为每个旋转矩阵**选定唯一**一个四元数（$\eta=0$ 边界处由 $\operatorname{sgn}$ 规则仍给出确定答案）；
3. **消除了逆解奇点**——式 2.34–2.35 对任何旋转矩阵都有效，没有 $\sin\vartheta=0$ 那样的失效点（对照 [@thm-2.5.B]）。
:::

把原理 2.6.A 的前两条结论画成一张「参数 → 旋转 → 四元数」的映射图，关系会立刻清楚：半角打包把角和轴的**两组**参数坍缩成**一个**四元数；而 $\vartheta\sim\vartheta+2\pi$ 留下的 $Q\sim-Q$ 双覆盖，则由 $\eta\ge0$ 约定裁决。

<figure>
<svg class="figure-svg" viewBox="0 0 920 350" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-26-title fig-26-desc">
<title id="fig-26-title">四元数如何修复角和轴的两个缺陷</title>
<desc id="fig-26-desc">左侧映射图：参数组 (ϑ,r) 与 (−ϑ,−r) 对应同一旋转 R，经半角打包映射到同一个四元数 Q；ϑ 与 ϑ+2π 对应同一旋转但映射到 Q 与 −Q 两个对径点。右侧为单位球面示意，Q 与 −Q 为对径两点。</desc>
<defs>
<marker id="f26-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<text class="diagram-text" fill="var(--accent-text)" x="290" y="48" text-anchor="middle">修复 ①：表示不唯一 → 半角打包坍缩为一个 Q</text>
<rect class="diagram-node" x="40" y="66" width="130" height="46" rx="8"/>
<text class="diagram-text" x="105" y="95" text-anchor="middle">(ϑ, r)</text>
<rect class="diagram-node" x="40" y="136" width="130" height="46" rx="8"/>
<text class="diagram-text" x="105" y="165" text-anchor="middle">(−ϑ, −r)</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f26-m)">
<path d="M170 89 H225 V119 H243"/>
<path d="M170 159 H225 V129 H243"/>
<line x1="372" y1="124" x2="433" y2="124"/>
</g>
<rect class="diagram-node" x="245" y="101" width="130" height="46" rx="8"/>
<text class="diagram-text" x="310" y="130" text-anchor="middle">同一旋转 R</text>
<rect class="diagram-node" x="435" y="90" width="185" height="68" rx="8" stroke="var(--accent)"/>
<text class="diagram-text" fill="var(--accent-text)" x="527" y="117" text-anchor="middle">同一个 Q</text>
<text class="diagram-note" x="527" y="140" text-anchor="middle">{cos(ϑ/2), sin(ϑ/2)·r}</text>
<text class="diagram-text" fill="var(--accent-text)" x="290" y="216" text-anchor="middle">仍保留：ϑ ∼ ϑ+2π → Q ∼ −Q（双覆盖）</text>
<rect class="diagram-node" x="40" y="234" width="130" height="46" rx="8"/>
<text class="diagram-text" x="105" y="263" text-anchor="middle">ϑ</text>
<rect class="diagram-node" x="40" y="296" width="130" height="46" rx="8"/>
<text class="diagram-text" x="105" y="325" text-anchor="middle">ϑ + 2π</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f26-m)">
<path d="M170 257 H225 V273 H243"/>
<path d="M170 319 H225 V289 H243"/>
<line x1="372" y1="281" x2="418" y2="262"/>
<line x1="372" y1="281" x2="498" y2="300"/>
</g>
<rect class="diagram-node" x="245" y="258" width="130" height="46" rx="8"/>
<text class="diagram-text" x="310" y="287" text-anchor="middle">同一旋转 R</text>
<rect class="diagram-node" x="420" y="240" width="80" height="44" rx="8" stroke="var(--sage)"/>
<text class="diagram-text" fill="var(--sage)" x="460" y="268" text-anchor="middle">Q</text>
<rect class="diagram-node" x="500" y="282" width="80" height="44" rx="8" stroke="var(--sage)"/>
<text class="diagram-text" fill="var(--sage)" x="540" y="310" text-anchor="middle">−Q</text>
<circle cx="760" cy="190" r="92" fill="none" stroke="var(--line-strong)" stroke-width="1.4"/>
<ellipse cx="760" cy="190" rx="92" ry="24" fill="none" stroke="var(--line)" stroke-dasharray="4 4"/>
<line stroke="var(--line)" stroke-dasharray="4 4" x1="830" y1="131" x2="690" y2="249"/>
<circle class="diagram-fill-accent" cx="830" cy="131" r="6"/>
<circle class="diagram-fill-sage" cx="690" cy="249" r="6"/>
<text class="diagram-text" fill="var(--accent-text)" x="842" y="126">Q</text>
<text class="diagram-text" fill="var(--sage)" x="678" y="266" text-anchor="end">−Q</text>
<path d="M 846 160 A 92 92 0 0 1 838 240" fill="none" stroke="var(--fig-gold)" stroke-width="1.8" marker-end="url(#f26-m)"/>
<text class="diagram-note" x="910" y="204" text-anchor="end">ϑ 增加 2π</text>
<text class="diagram-note" x="760" y="316" text-anchor="middle">单位约束 η² + ‖ε‖² = 1（单位球面示意）</text>
<text class="diagram-note" x="760" y="338" text-anchor="middle">取 η ≥ 0 → 每个旋转矩阵选定唯一一个 Q</text>
</svg>
<figcaption>四元数对角和轴缺陷的修复（本教程绘）：左上——半角打包使 $(\vartheta,\boldsymbol r)$ 与 $(-\vartheta,-\boldsymbol r)$ 映到**同一个** $Q$（[@thm-2.5.A] 的不唯一性消失）；左下——$\vartheta\sim\vartheta+2\pi$ 仍给出 $Q\sim-Q$ 的双覆盖，$\eta\ge0$ 约定把它也裁决掉。</figcaption>
</figure>

<a id="sec-2.6.2"></a>

## 2.6.2 正解、逆解与乘法

给定四元数，旋转矩阵为（原书式 2.33）

$$R(\eta,\boldsymbol\epsilon)=\begin{bmatrix}
2(\eta^2+\epsilon_x^2)-1 & 2(\epsilon_x\epsilon_y-\eta\epsilon_z) & 2(\epsilon_x\epsilon_z+\eta\epsilon_y)\\
2(\epsilon_x\epsilon_y+\eta\epsilon_z) & 2(\eta^2+\epsilon_y^2)-1 & 2(\epsilon_y\epsilon_z-\eta\epsilon_x)\\
2(\epsilon_x\epsilon_z-\eta\epsilon_y) & 2(\epsilon_y\epsilon_z+\eta\epsilon_x) & 2(\eta^2+\epsilon_z^2)-1
\end{bmatrix}$$

::: proof 证明 · 式 2.33 是 Rodrigues 紧凑形式的半角改写（本编补充）
把 $\eta=\cos\frac\vartheta2$、$\boldsymbol\epsilon=\sin\frac\vartheta2\,\boldsymbol r$ 代入 [2.5.1](sec2-5.md#sec-2.5.1) 的紧凑形式 $R=c_\vartheta I+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$。用倍角公式 $c_\vartheta=2\eta^2-1=1-2\sin^2\frac\vartheta2$、$s_\vartheta=2\sin\frac\vartheta2\cos\frac\vartheta2$，三项逐个改写：

$$c_\vartheta I=(2\eta^2-1)I,\qquad
(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}=2\sin^2\tfrac\vartheta2\ \boldsymbol r\boldsymbol r^{\mathrm T}=2\,\boldsymbol\epsilon\,\boldsymbol\epsilon^{\mathrm T},\qquad
s_\vartheta S(\boldsymbol r)=2\sin\tfrac\vartheta2\cos\tfrac\vartheta2\ S(\boldsymbol r)=2\eta\,S(\boldsymbol\epsilon).$$

（$S(\boldsymbol\epsilon)=\sin\frac\vartheta2\,S(\boldsymbol r)$——$S(\cdot)$ 对参数线性。）合并得**四元数紧凑形式**

$$R=(2\eta^2-1)I+2\,\boldsymbol\epsilon\,\boldsymbol\epsilon^{\mathrm T}+2\eta\,S(\boldsymbol\epsilon),$$

逐元素展开：对角线 $=2\eta^2-1+2\epsilon_i^2=2(\eta^2+\epsilon_i^2)-1$；非对角 $(i,j)=2\epsilon_i\epsilon_j+2\eta\,S(\boldsymbol\epsilon)_{ij}$，而 $S(\boldsymbol\epsilon)_{xy}=-\epsilon_z$ 等——即式 2.33 的九个元素。□
:::

逆问题（由 $R=[r_{ij}]$ 提取四元数，原书式 2.34–2.35）——取 $\eta\ge0$（对应 $\vartheta\in[-\pi,\pi]$，可覆盖所有旋转）：

$$\eta=\tfrac12\sqrt{r_{11}+r_{22}+r_{33}+1},\qquad
\boldsymbol\epsilon=\tfrac12\begin{bmatrix}\operatorname{sgn}(r_{32}-r_{23})\sqrt{r_{11}-r_{22}-r_{33}+1}\\
\operatorname{sgn}(r_{13}-r_{31})\sqrt{r_{22}-r_{33}-r_{11}+1}\\
\operatorname{sgn}(r_{21}-r_{12})\sqrt{r_{33}-r_{11}-r_{22}+1}\end{bmatrix}$$

（$\operatorname{sgn}(x)=1\ (x\ge0)$、$-1\ (x<0)$）

::: proof 证明 · 式 2.34–2.35 的三条线索（本编补充）
**求 $\eta$——取迹。** 对四元数紧凑形式取迹（$S(\boldsymbol\epsilon)$ 对角为零、$\operatorname{tr}(\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T})=|\boldsymbol\epsilon|^2=1-\eta^2$）：

$$\operatorname{tr}R=3(2\eta^2-1)+2|\boldsymbol\epsilon|^2=6\eta^2-3+2(1-\eta^2)=4\eta^2-1
\ \Longrightarrow\ \eta=\tfrac12\sqrt{\operatorname{tr}R+1}$$

（开方取正根，即 $\eta\ge0$ 约定。）

**求 $|\epsilon_i|$——用对角线。** 对角元素 $r_{ii}=2\eta^2-1+2\epsilon_i^2$ 解出 $\epsilon_i^2=\dfrac{r_{ii}+1}{2}-\eta^2=\dfrac{r_{ii}-r_{jj}-r_{kk}+1}{4}$（$i,j,k$ 互异）——即式 2.35 根号内的三个组合。

**定符号——用反对称部分。** 紧凑形式中前两项对称、末项反对称，故 $R-R^{\mathrm T}=4\eta\,S(\boldsymbol\epsilon)$：$\epsilon_x$ 的符号 $=\operatorname{sgn}(r_{32}-r_{23})$（$\eta>0$ 时直接读出；$\eta=0$ 即 $\vartheta=\pi$ 的边界由 $\operatorname{sgn}$ 规则约定）。□
:::

逆四元数由转置关系给出（原书式 2.36）：

$$Q^{-1}=\{\eta,-\boldsymbol\epsilon\}\quad\Longleftrightarrow\quad R^{-1}=R^T .$$

（把 $\{\eta,-\boldsymbol\epsilon\}$ 代入式 2.33：$\boldsymbol\epsilon\to-\boldsymbol\epsilon$ 使反对称件反号、对称件不变，恰好逐元素转置。）

两个旋转依次施加（$R_1$ 后 $R_2$）对应四元数乘积（原书式 2.37，$\otimes$ 为四元数乘算子）：

$$Q_1\otimes Q_2=\{\eta_1\eta_2-\boldsymbol\epsilon_1^T\boldsymbol\epsilon_2,\ \ \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\}.$$

::: note 乘法公式从哪来——「标量 + 向量」的数（本编补充）
四元数是形如 $\eta+\epsilon_x i+\epsilon_y j+\epsilon_z k$ 的数（Hamilton 1843）：**标量 + 向量**，虚单位满足 $i^2=j^2=k^2=ijk=-1$（等价地 $ij=k,\ jk=i,\ ki=j$，反序差一负号）。按分配律逐项相乘，再把标量部分与向量部分分别收集，乘法规则就浓缩成一条：

$$(a,\boldsymbol u)\otimes(b,\boldsymbol v)=\big(ab-\boldsymbol u\cdot\boldsymbol v,\ \ a\boldsymbol v+b\boldsymbol u+\boldsymbol u\times\boldsymbol v\big).$$

式 2.37 就是它在 $(\eta_1,\boldsymbol\epsilon_1)$、$(\eta_2,\boldsymbol\epsilon_2)$ 上的展开。两个直接推论：**乘法含叉积项 → 不可交换**（$Q_1\otimes Q_2\neq Q_2\otimes Q_1$，与旋转合成不可交换同源，[2.3](sec2-3.md)）；「共轭」$\bar Q=\{\eta,-\boldsymbol\epsilon\}$ 满足 $Q\otimes\bar Q=\{\eta^2+|\boldsymbol\epsilon|^2,\boldsymbol 0\}=\{1,\boldsymbol 0\}$——**单位四元数的共轭就是逆**，即式 2.36。
:::

::: note 用 2.5.3 的语言读四元数（本编补充）
四元数把指数映射「搬到一半角上」：对纯向量四元数 $(0,\boldsymbol u)$ 定义指数（泰勒级数，与 [@thm-2.5.D] 同法，用 $\boldsymbol u\times(\boldsymbol u\times\cdot)$ 的三循环可证）

$$\exp\big((0,\boldsymbol u)\big)=\Big(\cos|\boldsymbol u|,\ \ \sin|\boldsymbol u|\,\frac{\boldsymbol u}{|\boldsymbol u|}\Big),$$

则角和轴表示正好是 $Q=\exp\big((0,\tfrac\vartheta2\boldsymbol r)\big)=\big(\cos\frac\vartheta2,\sin\frac\vartheta2\boldsymbol r\big)$。**取了一半的角**，所以 $\vartheta\to\vartheta+2\pi$（$SO(3)$ 上仍是同一旋转）时 $Q\to-Q$——这正是双覆盖 $Q\sim-Q$ 的代数根源，也是式 2.33 里处处「半角」的来历。
:::

::: intuition 为什么控制领域偏爱四元数
单位四元数满足的单位约束把参数限制在**一个光滑曲面上**（$\mathbb{R}^4$ 中的单位球面），姿态随时间的演化因而是球面上的一条连续轨迹——既不撞奇点、也没有「同一姿态两套参数」的跳变，插值与数值积分都稳定。代价：4 个参数不再能直观读成角度，且乘法含叉积项（[@thm-2.2.B] 的「三重身份」在四元数里退化为纯粹的代数运算）。**欧拉角给人看，四元数给机器算**——这是姿态表示选型最实用的一句总结。
:::

<a id="sec-2.6"></a>

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先写出下面几条，再展开核对。写不出来就说明这一节还没「拿走」。

1. 写出 $(\vartheta,\boldsymbol r)\to(\eta,\boldsymbol\epsilon)$ 的换算与单位约束。
2. 四元数的独立参数是几个？为什么？
3. 四元数修掉了角和轴的哪两个缺陷？

::: sol 核对

$\eta=\cos\frac{\vartheta}{2}$、$\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\boldsymbol r$；约束 $\eta^2+\epsilon_x^2+\epsilon_y^2+\epsilon_z^2=1$。

3 个（4 参数 − 1 约束），与最简表示的要求不矛盾。

① **表示不唯一**：半角打包使 $(\vartheta,\boldsymbol r)$ 与 $(-\vartheta,-\boldsymbol r)$ 映到同一四元数；② **逆解奇点**：式 2.34–2.35 对任何 $R$ 都有效，没有 $\sin\vartheta=0$ 那样的失效点。

:::

:::

## 2.6 小结与常见错误

- **一条主线**：半角打包 $(\vartheta,\boldsymbol r)\mapsto\{\cos\frac{\vartheta}{2},\sin\frac{\vartheta}{2}\boldsymbol r\}$ → 单位约束（4 参数 − 1 = 3）→ 正解式 2.33 / 逆解式 2.34–2.35 → 逆 $Q^{-1}=\{\eta,-\boldsymbol\epsilon\}$、乘 $Q_1\otimes Q_2$。
- **三个修复**：表示不唯一（[@thm-2.5.A]，半角打包使 $(\vartheta,\boldsymbol r)$ 与 $(-\vartheta,-\boldsymbol r)$ 映到同一四元数）、$Q\sim-Q$ 双重覆盖（源自 $\vartheta\sim\vartheta+2\pi$，由 $\eta\ge0$ 约定消除）、逆解奇点（[@thm-2.5.B]）。
- **一个取舍**：4 参数非最简 × 无奇点 × 乘法含叉积 = 控制 / 图形学首选，人机交互界面仍常用欧拉角。

::: think 常见错误清单 · 自查两条
1. 忘记单位约束——四元数必须归一化才能当旋转用，长期数值迭代后需重新归一化；
2. 把「$Q$ 与 $-Q$ 同旋转」当成角和轴式的不唯一。前者源自 $\vartheta$ 与 $\vartheta+2\pi$ 等价（同一旋转、两个四元数），但逆解的 $\eta\ge0$ 约定已为每个 $R$ **选定唯一一个** $Q$——锁定符号是人为却合法的约定；角和轴的不唯一则不同，它是两组**参数**都留在表示里、无人裁决。
:::
