# 2.1 刚体的姿态

夹爪已经到了工件上方，却依然因为姿态不对而横着对准工件，导致无法完成抓取。我们在上一章将机器人任务拆解为建模、规划与控制；而谈到建模，第一步就是要说清楚工具**在哪里、朝向哪里**。这两个关键要素分别由位置和姿态回答，合起来称作**位姿**。

本节我们通过固连在刚体上的坐标系来描述位姿，并详细解释三轴方向上的 9 个方向余弦。学完本节，你应当能根据轴的指向写出分量，准确分辨位置与方向参数的不同，并检查一组三轴能否构成合法的刚体姿态。

<aside class="margin-note"><span class="mn-label">NOTE / 6 DOF</span>在三维空间中，一个无约束的刚体拥有 6 个自由度：3 个平移自由度和 3 个转动自由度。姿态的 3 个参数属于局部描述，在不同的朝向下可能存在奇异或表示不唯一的问题。</aside>

{{#include ../assets/figures/robot-pose.md}}

<a id="sec-2.1.1"></a>

## 2.1.1 位姿与位置的描述

::: def 定义 2.1.1 · 位姿（pose） {#def-2.1.1}
在刚体上固定一个坐标系：原点 $O'$ 随刚体移动，三根坐标轴随刚体转动。相对于参考系，$O'$ 的**位置**与固连坐标系的**姿态**（orientation，即三根轴的指向）共同定义了刚体的位姿（pose）。此处假定刚体的几何形状以及固连系相对于刚体的安装方式已确定。

特别提示：无约束的空间刚体固然有 6 个自由度，但机械手的关节约束会限制其可达到的位姿，不能直接断言所有机器人都能实现任意的 6 自由度运动。
:::

令 $O\text{-}xyz$ 为右手正交参考系，$\boldsymbol x,\boldsymbol y,\boldsymbol z$ 为参考系的三轴单位向量。位置向量 $\overrightarrow{OO'}$ 在参考系下的分解式为：

$$\overrightarrow{OO'}=o'_x\boldsymbol x+o'_y\boldsymbol y+o'_z\boldsymbol z,\qquad
\boldsymbol o'=\begin{bmatrix}o'_x\\o'_y\\o'_z\end{bmatrix}\in\mathbb R^3
\qquad(\text{原书式 }2.1)$$

上式左侧为几何向量，右侧为该向量在参考系下的**坐标表示**。原书将二者简记为 $\boldsymbol o'$，后续内容遵循这一惯例，但在切换坐标系时会明确指明分量所在的参考系。若单位为米，则三个位置分量均以米计。

::: note 原书中的 bound vector 是什么？
原书称位置向量为 bound vector，意在强调起点 $O$ 和终点 $O'$ 是特定的。这里将其理解为**有固定起点的位置向量**；旧译“有界向量”容易使人误以为长度存在某个上界。

点 $O'$ 与向量 $\overrightarrow{OO'}$ 是性质不同的对象。参考原点改变时，点的位置坐标会变；而自由向量仅描述大小与方向，只要坐标轴方向不变，其分量就不会因原点平移而改变。[§2.7](sec2-7.md) 将引入统一的变换公式来处理这种细微差别。
:::

仅确定 $O'$ 的位置并不足以描述刚体的姿态。即使进一步给出了工具轴 $\boldsymbol z'$ 的方向，夹爪依然可以绕该轴随意滚转，横向的 $\boldsymbol x'$ 和 $\boldsymbol y'$ 轴也会随之改变。因此，**仅知道一根轴的方向，不足以完全描述姿态**；我们需要描述整个固连坐标系。

<a id="sec-2.1.2"></a>

## 2.1.2 姿态与方向余弦

我们在刚体上建立固连右手正交坐标系 $O'\text{-}x'y'z'$。将三根轴的单位向量分别沿参考系分解：

$$\begin{aligned}
\boldsymbol x'&=x'_x\boldsymbol x+x'_y\boldsymbol y+x'_z\boldsymbol z,\\
\boldsymbol y'&=y'_x\boldsymbol x+y'_y\boldsymbol y+y'_z\boldsymbol z,\\
\boldsymbol z'&=z'_x\boldsymbol x+z'_y\boldsymbol y+z'_z\boldsymbol z.
\end{aligned}\qquad(\text{原书式 }2.2)$$

下标指明了沿参考轴的分量。例如，$x'_y$ 即为本体系 $x'$ 轴在参考系 $y$ 轴上的投影。

::: thm 原理 2.1.A · 方向余弦的几何意义 {#thm-2.1.A}
由于三轴均为单位向量，每个分量恰好是两根轴夹角的余弦：

$$x'_y=\boldsymbol x'\cdot\boldsymbol y=\cos\angle(\boldsymbol x',\boldsymbol y).$$

旧教程的课堂记录用「它就是两个单位向量做点积」解释方向余弦；上式把参与点积的两根轴和所得分量都写了出来。

该值为无量纲的数值，取值范围在 $[-1,1]$ 之间。负值仅代表在参考轴的负方向上有分量，并非夹角为负。

这 9 个方向余弦并非完全独立。考虑到三轴皆为单位向量且相互垂直，必须满足：

$$\|\boldsymbol x'\|^2=\|\boldsymbol y'\|^2=\|\boldsymbol z'\|^2=1,\qquad
\boldsymbol x'\cdot\boldsymbol y'=\boldsymbol y'\cdot\boldsymbol z'=\boldsymbol z'\cdot\boldsymbol x'=0.$$

3 条长度约束加 3 条垂直约束，共 6 个独立约束，使 9 个参数中仅有 $9-6=3$ 个连续独立参数。此外，由于我们约定均为右手系，还需满足 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$，以排除镜像。右手条件选择手性，不再减少一个连续自由度；也不能据此认为任意三个方向余弦就能唯一决定姿态。矩阵写法见 [§2.2 的参数计数](sec2-2.md#note-2.2.2)。
:::

### 2.1.2.1 从读数理解投影

看一个 $xy$ 平面内的例子。左图的点 $P=(0.30,0.20,0)\,\mathrm m$；右图的单位方向为 $(0.60,0.80,0)^{\mathrm T}$。尽管两图都沿参考轴读取分量，但**左图读取的是实际长度，右图读取的是无量纲的方向余弦**。两图有各自的比例尺，不可简单进行横向比较。

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
<figcaption>分量读取示例（本教程绘）。两图的 z 轴均朝向屏幕外。右图只描述了轴 x′，仍须选定一根与它垂直的横向轴，再由叉积确定第三轴；三轴须共同满足单位长度、正交和右手条件。仅给定 x′ 并不能确定另外两轴的朝向。</figcaption>
</figure>

### 2.1.2.2 一组完整位姿：位置与朝向的分开表示

::: ex 带数示范 · 绕参考 z 轴正转 90° {#ex-2.1.pose}
假设固连系原点位置为 $\boldsymbol o'=(0.30,-0.20,0.10)^{\mathrm T}\,\mathrm m$。固连系初始与参考系同向，随后绕平行于参考 $z$ 轴并经过 $O'$ 的轴按右手定则转动 $+90^\circ$，保持 $O'$ 不动。从 $+z$ 一侧朝原点看，此转动为逆时针。此时三轴朝向变为：

$$\boldsymbol x'=(0,1,0)^{\mathrm T},\qquad
\boldsymbol y'=(-1,0,0)^{\mathrm T},\qquad
\boldsymbol z'=(0,0,1)^{\mathrm T}.$$

逐轴检查：$x'$ 指向参考 $+y$，$y'$ 指向参考 $-x$，$z'$ 不变。将这三列排布，即得到顶部图中的旋转矩阵：

$$R=\begin{bmatrix}0&-1&0\\1&0&0\\0&0&1\end{bmatrix}.$$

例如 $y'_x=-1=\cos180^\circ$，$x'_x=0=\cos90^\circ$。矩阵元素均为无量纲的数，仅有位置列带有长度单位。
:::

::: think 练习 1 · 同一位姿下，点与方向怎样读？ {#practice-2.1.point}
沿用上例，若工具上的点 $P$ 在固连系中为 $(0.10,0,0)^{\mathrm T}\,\mathrm m$，某单位方向向量在固连系中为 $(1,0,0)^{\mathrm T}$。

1. 根据 $x'$ 的朝向，试求 $P$ 和该单位方向在参考系下的坐标。
2. 若三轴朝向不变，仅将 $O'$ 在参考系中的 $x$ 坐标增加 $0.20\,\mathrm m$，两项坐标会有何变化？

::: sol 练习 1 核对
1. 从 $O'$ 沿 $x'$ 走 $0.10\,\mathrm m$，即沿参考 $+y$ 走 $0.10\,\mathrm m$。因此，点 $P$ 在参考系中为：

$$\boldsymbol p=\boldsymbol o'+0.10\boldsymbol x'
=(0.30,-0.10,0.10)^{\mathrm T}\,\mathrm m.$$
而单位方向仅描述朝向，不涉及原点偏移，故其在参考系下即为 $\boldsymbol x'=(0,1,0)^{\mathrm T}$。
2. 平移后，点坐标变为 $(0.50,-0.10,0.10)^{\mathrm T}\,\mathrm m$，而方向向量保持不变，仍为 $(0,1,0)^{\mathrm T}$。
若误将位置加到方向上，它通常连单位长度都不再保持；点与自由方向必须分开处理。
:::
:::

::: think 练习 2 · 仅靠三轴垂直就够了吗？ {#practice-2.1.handedness}
考虑另一组轴：$\boldsymbol x'=(1,0,0)^{\mathrm T}$、$\boldsymbol y'=(0,1,0)^{\mathrm T}$、$\boldsymbol z'=(0,0,-1)^{\mathrm T}$。

检查三轴长度、两两点积以及 $\boldsymbol x'\times\boldsymbol y'$。它们能否表示参考右手系转动后的朝向？若只指定 $\boldsymbol z'=(0,0,1)^{\mathrm T}$，姿态能否唯一确定？

::: sol 练习 2 核对
这组轴虽然满足单位长度且两两正交，但 $\boldsymbol x'\times\boldsymbol y'=(0,0,1)^{\mathrm T}=-\boldsymbol z'$，构成的是左手系。对应矩阵 $\operatorname{diag}(1,1,-1)$ 的行列式为 $-1$，无法由右手系仅通过刚体转动获得。下一节将用“正交且行列式为 $+1$”作为旋转矩阵的判据。

仅给定 $z'$ 也不够。例如 $(\boldsymbol x',\boldsymbol y')=(\boldsymbol x,\boldsymbol y)$ 和 $(\boldsymbol y,-\boldsymbol x)$ 都与 $\boldsymbol z'=\boldsymbol z$ 组成右手系，却相差绕 $z'$ 的 $90^\circ$ 转动。横向轴仍有连续滚转的选择，不能唯一确定姿态。
:::
:::

<a id="sec-2.1"></a>

::: think 课后默写 {#sec-2.1-recall}
1. 位姿由哪两部分组成？“6 自由度”适用于什么情况？
2. 请写出方向余弦 $x'_y$ 的表达式，并说明其物理意义、单位与取值范围。
3. 描述刚体姿态时，9 个方向余弦满足哪些约束？
4. 仅给定位置和一根工具轴方向，为什么无法确定完整姿态？

::: sol 课后默写核对
1. 位姿由位置和姿态组成。6 自由度适用于无额外约束的空间刚体，但机器人可能受到运动学约束限制；姿态有 3 个连续自由度，也不保证一套角度参数能在所有朝向下唯一、无奇异地表示姿态。
2. $x'_y=\boldsymbol x'\cdot\boldsymbol y$，表示固连系 $x'$ 轴在参考 $y$ 轴上的投影；无量纲，取值范围为 $[-1,1]$。
3. 三条单位长度、三条两两正交约束留下 3 个连续独立参数；还须检查 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$（矩阵行列式为 $+1$），以排除左手镜像。
4. 因为在该轴方向确定后，绕该轴仍存在滚转的自由度，未完全限定固连坐标系的方向。
:::
:::

## 2.1 小结与常见错误

- **一条主线**：描述位姿必须同时给原点位置与固连系三轴朝向；位置分量带单位，方向余弦无量纲。
- **要点**：固定原点后刚体仍可绕其转动，仅给位置不代表位姿；一根轴只能定出部分方向；方向余弦的负号表示投影朝参考轴负向，不是夹角为负；平移原点改变位置点坐标，不改变方向向量的分量。
- **下一节**：[§2.2](sec2-2.md) 用矩阵统一处理三根轴，并区分姿态描述、坐标变换与旋转操作。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| $\boldsymbol o'=(o'_x,o'_y,o'_z)^{\mathrm T}$，$\overrightarrow{OO'}=o'_x\boldsymbol x+o'_y\boldsymbol y+o'_z\boldsymbol z$ | 参考系 $O\text{-}xyz$ 给定 | m | 坐标随参考系改变，几何向量本身不变 |
| $x'_y=\boldsymbol x'\cdot\boldsymbol y$ | 三轴均为单位向量 | 无量纲 | 是投影（夹角余弦），不是角度本身 |
| $9-6=3$ 个连续独立参数 | 三条单位长约束 + 三条两两正交约束 | — | 右手条件 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$ 排除镜像，不再减少连续自由度 |

::: think 常见错误清单 · 自查三条
1. 把「知道一根工具轴方向」当成完整姿态：绕该轴仍有滚转自由度，横向两轴未定。
2. 把方向余弦当角度：它是两单位向量夹角的余弦，取值 $[-1,1]$、无量纲。
3. 把平移后的点坐标当成方向坐标：点要加平移量，方向不动；误加会连单位长度都保不住。
:::

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部定义与自绘图；下列课堂图片保留以备核对，**不构成正文的替代**。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| — | [rigid-body-pose.jpg](../assets/ch02/rigid-body-pose.jpg) | 刚体上点 O′ 的位置描述 | 正文给出分解式（原书式 2.1）与坐标表示辨析；位姿总览见页首自绘图 |
| — | [direction-cosines.jpg](../assets/ch02/direction-cosines.jpg) | 固连系三轴在参考系中的分量（幻灯片标题为“2.2 旋转矩阵”） | 正文给出九个方向余弦及其几何意义（原理 2.1.A）；带数投影对照见自绘「位置分量与单位方向分量」图 |
:::
