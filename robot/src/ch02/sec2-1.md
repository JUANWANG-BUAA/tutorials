# 2.1 刚体的姿态

> **本节定位**：`了解·精简` ｜ 建立刚体位姿（$3$ 个位置自由度 $+3$ 个姿态自由度）的几何描述，严格区分有固定起点的位置向量与无量纲自由方向向量，并证明 $9$ 个方向余弦经 $6$ 条正交归一约束留下的 $3$ 个连续独立参数与右手性离散选择。

{{#include ../assets/figures/robot-pose.md}}

<a id="sec-2.1.1"></a>

## 2.1.1 位姿、位置向量与自由方向向量

无约束三维刚体具有 $6$ 个自由度（$3$ 个平动自由度与 $3$ 个转动自由度）。（注意：串联或闭链机械手受关节构型与限位约束，实际末端位姿维数未必能张满全部 $6$ 维。）

::: def 定义 2.1.1 · 刚体位姿、位置向量与方向余弦 {#def-2.1.1}
在刚体上固连右手正交坐标系 $O'\text{-}x'y'z'$。相对于固定右手正交参考系 $O\text{-}xyz$（单位基向量 $\boldsymbol x,\boldsymbol y,\boldsymbol z$），原点 $O'$ 的**位置**与固连坐标系的**姿态**（orientation，三轴指向）共同唯一确定刚体的**位姿**（pose）。

1. **位置向量**（bound vector，有固定起点 $O$ 与终点 $O'$）在参考系下的坐标展开为（原书式 2.1）：
   $$\overrightarrow{OO'} = o'_x\boldsymbol x + o'_y\boldsymbol y + o'_z\boldsymbol z, \qquad \boldsymbol o' = \begin{bmatrix}o'_x\\ o'_y\\ o'_z\end{bmatrix}\in\mathbb R^3,$$
   三个分量带有长度单位（如 $\mathrm m$）。
2. **固连三轴方向余弦**展开为（原书式 2.2）：
   $$\begin{aligned}
   \boldsymbol x' &= x'_x\boldsymbol x + x'_y\boldsymbol y + x'_z\boldsymbol z,\\
   \boldsymbol y' &= y'_x\boldsymbol x + y'_y\boldsymbol y + y'_z\boldsymbol z,\\
   \boldsymbol z' &= z'_x\boldsymbol x + z'_y\boldsymbol y + z'_z\boldsymbol z,
   \end{aligned}$$
   共 $9$ 个无量纲标量，表征固连坐标系相对参考坐标系的朝向。
:::

<a id="sec-2.1.2"></a>

## 2.1.2 方向余弦的几何意义与自由度计数

::: thm 定理 2.1.A · 方向余弦、六条约束与右手性 {#thm-2.1.A}
由于参考三轴与固连三轴均为单位向量，每个分量等于对应两单位轴夹角的余弦：
$$x'_y = \boldsymbol x'\cdot\boldsymbol y = \cos\angle(\boldsymbol x',\boldsymbol y) \in [-1,1].$$
该值为无量纲实数；负值仅表示投影指向对应参考轴负向，不表示夹角为负。这 $9$ 个方向余弦受 $3$ 条单位长度约束与 $3$ 条两两正交约束限制：
$$\|\boldsymbol x'\|^2=\|\boldsymbol y'\|^2=\|\boldsymbol z'\|^2=1, \qquad \boldsymbol x'\cdot\boldsymbol y'=\boldsymbol y'\cdot\boldsymbol z'=\boldsymbol z'\cdot\boldsymbol x'=0.$$
因此连续独立参数数为 $9 - 6 = 3$。在此基础上，刚体转动还须满足离散的**右手性条件** $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$，用于排除左手镜像反射（该离散条件不减少连续自由度）。
:::

仅给定位置 $\boldsymbol o'$ 与单根工具轴方向（如 $\boldsymbol z'$），刚体仍可绕 $\boldsymbol z'$ 连续自转，横向 $\boldsymbol x',\boldsymbol y'$ 轴未定，故**单轴不足以确定完整三维姿态**。同时必须区分两类几何对象：当参考原点 $O$ 平移（轴向不变）时，**点的位置坐标随原点平移而改变**，而仅描述方向的**自由方向向量分量保持不变**（统一算法见 [§2.7 齐次变换](sec2-7.md)）。

<figure>
<svg class="figure-svg" viewBox="0 0 920 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-21-title fig-21-desc">
<title id="fig-21-title">位置分量与单位方向分量的带数对照</title>
<desc id="fig-21-desc">左图：点 P 的 x 坐标零点三零米、y 坐标零点二零米、z 坐标零，虚线连接轴上读数与点。右图：单位方向的 x 分量零点六零、y 分量零点八零、z 分量零，平方和为一。两图都在 xy 平面内，z 轴朝向屏幕外。</desc>
<defs>
<marker id="f21-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="f21-b" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-blue)"/></marker>
</defs>
<text class="diagram-text" x="240" y="32" text-anchor="middle">位置：分量单位为 m</text>
<text class="diagram-text" x="700" y="32" text-anchor="middle">单位方向：分量无量纲</text>
<g stroke="var(--line-strong)" stroke-width="1.5" marker-end="url(#f21-m)">
<line x1="100" y1="245" x2="395" y2="245"/><line x1="100" y1="245" x2="100" y2="65"/>
<line x1="560" y1="245" x2="855" y2="245"/><line x1="560" y1="245" x2="560" y2="65"/>
</g>
<g stroke="var(--line-strong)" stroke-dasharray="5 4" fill="none">
<path d="M280,245 V125 H100"/><path d="M674,245 V93 H560"/>
</g>
<g stroke="var(--fig-blue)" stroke-width="2.5" marker-end="url(#f21-b)">
<line x1="100" y1="245" x2="280" y2="125"/><line x1="560" y1="245" x2="674" y2="93"/>
</g>
<g class="diagram-text">
<text x="82" y="267">O</text><text x="395" y="267">x</text><text x="80" y="68">y</text>
<text x="280" y="270" text-anchor="middle">0.30</text><text x="90" y="130" text-anchor="end">0.20</text><text x="292" y="120">P</text>
<text x="542" y="267">O</text><text x="855" y="267">x</text><text x="540" y="68">y</text>
<text x="674" y="270" text-anchor="middle">0.60</text><text x="550" y="98" text-anchor="end">0.80</text><text x="689" y="88">单位轴 x′</text>
</g>
<text class="diagram-note" x="240" y="306" text-anchor="middle">z = 0；位置向量长度约 0.361 m</text>
<text class="diagram-note" x="700" y="306" text-anchor="middle">z 分量为 0；0.60² + 0.80² = 1</text>
</svg>
<figcaption>位置向量分量（带长度单位 m）与单位方向向量分量（无量纲方向余弦）的数值对照（本教程绘）。</figcaption>
</figure>

::: ex 例 2.1.B · 绕参考 z 轴正转 90° 的完整位姿 {#ex-2.1.pose}
设固连系原点位置为 $\boldsymbol o'=(0.30,-0.20,0.10)^{\mathrm T}\,\mathrm m$，初始与参考系同向，随后保持 $O'$ 不动并绕过 $O'$ 平行参考 $+z$ 的轴按右手定则正转 $+90^\circ$（从 $+z$ 端朝原点看为逆时针）。三轴单位向量变为：
$$\boldsymbol x'=(0,1,0)^{\mathrm T},\qquad
\boldsymbol y'=(-1,0,0)^{\mathrm T},\qquad
\boldsymbol z'=(0,0,1)^{\mathrm T}.$$
按列排布得旋转矩阵（各元素均无量纲，例如 $y'_x=\cos 180^\circ=-1,\ x'_x=\cos 90^\circ=0$）：
$$R=\begin{bmatrix}0&-1&0\\1&0&0\\0&0&1\end{bmatrix}.$$
:::

::: think 练习 1 · 同一位姿下点位置与自由方向的平移检验 {#practice-2.1.point}
沿用上例，设点 $P$ 在固连系中的位置坐标为 $(0.10,0,0)^{\mathrm T}\,\mathrm m$，另有一自由方向向量在固连系中为 $(1,0,0)^{\mathrm T}$。
1. 求点 $P$ 与该方向向量在参考系下的坐标。
2. 若三轴朝向不变，仅将原点 $O'$ 在参考系中的 $x$ 坐标增加 $0.20\,\mathrm m$，两者坐标分别如何变化？

::: sol 练习 1 核对
1. 点 $P$ 在参考系下的位置为 $\boldsymbol p=\boldsymbol o'+0.10\boldsymbol x'=(0.30,-0.10,0.10)^{\mathrm T}\,\mathrm m$；自由方向向量在参考系下即为 $\boldsymbol x'=(0,1,0)^{\mathrm T}$。
2. 原点平移后，点坐标变为 $(0.50,-0.10,0.10)^{\mathrm T}\,\mathrm m$，而自由方向向量保持 $(0,1,0)^{\mathrm T}$ 不变（若误加平移，通常会破坏单位长度约束）。
:::
:::

::: think 练习 2 · 右手性与单轴不唯一性检验 {#practice-2.1.handedness}
给定三轴 $\boldsymbol x'=(1,0,0)^{\mathrm T}$、$\boldsymbol y'=(0,1,0)^{\mathrm T}$、$\boldsymbol z'=(0,0,-1)^{\mathrm T}$。检验其长度、正交性与叉积 $\boldsymbol x'\times\boldsymbol y'$，判定该三轴是否表示合法刚体转动姿态；若仅给定 $\boldsymbol z'=(0,0,1)^{\mathrm T}$，为何仍不能确定唯一姿态？

::: sol 练习 2 核对
该三轴虽满足单位长与两两正交，但 $\boldsymbol x'\times\boldsymbol y'=(0,0,1)^{\mathrm T}=-\boldsymbol z'$，构成左手系（对应矩阵行列式为 $-1$），属于含镜像的反射，不能由右手系经刚体连续转动得到。仅给定 $\boldsymbol z'=(0,0,1)^{\mathrm T}$ 时，$(\boldsymbol x,\boldsymbol y)$ 与 $(\boldsymbol y,-\boldsymbol x)$ 均可补成右手系，绕 $\boldsymbol z'$ 的滚转角仍未确定。
:::
:::

<a id="sec-2.1"></a>

::: think 课后默写与核对 {#sec-2.1-recall}
1. 位姿由哪两部分构成？$9$ 个方向余弦通过哪 $6$ 个等式缩减为 $3$ 个连续自由度？
2. 写出 $x'_y$ 的点积定义、取值范围与量纲；为什么还须补充 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$？

::: sol 课后默写核对
1. 原点位置向量（$3$ 自由度，$\mathrm m$）与固连三轴姿态（$3$ 自由度）；$3$ 条单位长度约束 $\|\boldsymbol x'\|^2=\|\boldsymbol y'\|^2=\|\boldsymbol z'\|^2=1$ 与 $3$ 条正交约束 $\boldsymbol x'\cdot\boldsymbol y'=\boldsymbol y'\cdot\boldsymbol z'=\boldsymbol z'\cdot\boldsymbol x'=0$。
2. $x'_y=\boldsymbol x'\cdot\boldsymbol y=\cos\angle(\boldsymbol x',\boldsymbol y)\in[-1,1]$（无量纲）；$\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$ 用于在满足正交的矩阵中排除左手镜像分支。
:::
:::

## 2.1 小结与常见错误

**主线**：刚体位姿由带长度单位的原点位置 $\boldsymbol o'$ 与无量纲的固连三轴方向余弦共同决定；$9$ 个方向余弦受 $6$ 条正交归一约束仅余 $3$ 个连续自由度，另由右手性条件排除镜像。

| 公式 / 结论 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $\overrightarrow{OO'}=o'_x\boldsymbol x+o'_y\boldsymbol y+o'_z\boldsymbol z$ | 固定右手参考系给定，分量单位为 $\mathrm m$ | 混淆点坐标与自由方向向量，给方向误加平移 |
| $x'_y=\boldsymbol x'\cdot\boldsymbol y=\cos\angle(\boldsymbol x',\boldsymbol y)\in[-1,1]$ | 参考轴与动系轴均为单位向量，无量纲 | 误把方向余弦负值当成负夹角，或将方向余弦当角度 |
| $9-6=3$ 自由度，$\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$ | 单位长与两两正交；右手系约定 | 以为仅给单根工具轴方向即可确定完整姿态 |

::: think 本节的课堂幻灯片（源料对照）
| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| — | [rigid-body-pose.jpg](../assets/ch02/rigid-body-pose.jpg) | 刚体上点 $O'$ 的位置描述 | 正文按原书式 (2.1) 严格定义并配页首位姿自绘图 |
| — | [direction-cosines.jpg](../assets/ch02/direction-cosines.jpg) | 固连系三轴方向余弦分解 | 正文凝练为 [@thm-2.1.A] 并配无量纲投影数值对照图 |
:::
