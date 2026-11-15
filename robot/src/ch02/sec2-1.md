# 2.1 刚体的姿态

夹爪到达了工件上方，却横着对准工件，仍然不能完成抓取。上一章把任务分成建模、规划与控制；开始建模时，首先要说清楚工具**在哪里、朝哪里**。这两个问题分别由位置和姿态回答，合起来叫**位姿**。

“在哪里”用一个点的三个坐标回答；“朝哪里”要借助固连在刚体上的[坐标系](../recall.md#joint)：原点给出位置，三根轴的指向给出朝向。三根轴各有 3 个分量，共 9 个无量纲的方向余弦，和以米计的位置坐标不是一类量。本节弄清这 9 个数受什么约束、独立的有几个，以及怎样检查一组三轴能否表示刚体的朝向。原书对应 §2.1，印刷页 39–40。

<aside class="margin-note"><span class="mn-label">NOTE / 6 DOF</span>无额外约束的空间刚体有 6 个自由度：位置 3 个、姿态 3 个。姿态为什么只要 3 个数，§2.1.2 会数出来。</aside>

{{#include ../assets/figures/robot-pose.md}}



<a id="sec-2.1.1"></a>

## 2.1.1 位姿与位置的描述

::: def 定义 2.1.1 · 位姿（pose） {#def-2.1.1}
把一个坐标系固定在刚体上：原点 $O'$ 随刚体移动，三根轴随刚体转动。相对于已选定的参考系，$O'$ 的**位置**与固连系的**姿态**（orientation，即三根轴的指向）共同确定刚体的位姿（pose）。这里假定刚体形状以及固连系在刚体上的安装方式已经确定。

位置要 3 个数，姿态要 3 个数（[@thm-2.1.A]），所以无额外约束的空间刚体有 3 个平移自由度和 3 个转动自由度。机械手末端是被关节牵着的刚体，它能实现哪些位姿由关节的数目、布置和限位决定；关节少于 6 个时，末端只能实现其中一部分位姿。[§2.10](sec2-10.md#sec-2.10.1) 会比较关节空间与操作空间的维数。
:::

令 $O\text{-}xyz$ 为右手正交参考系，$\boldsymbol x,\boldsymbol y,\boldsymbol z$ 为三轴单位向量。位置向量 $\overrightarrow{OO'}$ 可沿三轴分解：

$$\overrightarrow{OO'}=o'_x\boldsymbol x+o'_y\boldsymbol y+o'_z\boldsymbol z,\qquad
\boldsymbol o'=\begin{bmatrix}o'_x\\o'_y\\o'_z\end{bmatrix}\in\mathbb R^3
\qquad(\text{原书式 }2.1)$$

左边的箭头是几何向量，右边的列是它在参考系中的**坐标表示**。原书将二者都简记为 $\boldsymbol o'$；下文沿用这一习惯，但换坐标系时要说明分量在哪个系中。若采用米，三个位置分量都以米计。

![课堂幻灯片：刚体上点 O′ 的位置描述，对应原书 §2.1](../assets/ch02/rigid-body-pose.jpg)

::: note 原书的 bound vector 与“点和自由向量”
原书称 $\boldsymbol o'$ 为 bound vector：除了方向和大小，它的作用点（起点 $O$）和作用线也已指定。这里译作**有固定起点的位置向量**；旧译“有界向量”容易让人误以为长度有上界。

起点固定，正是位置向量和自由向量的区别。保持坐标轴方向不变、只挪动参考原点时，点 $O'$ 的位置坐标会变；自由向量只有大小和方向，它的分量不随原点平移而变。§2.1.2 的练习 1 会用到这一差别，[§2.7](sec2-7.md) 再把它写进统一的变换公式。
:::

给出 $O'$ 的位置，姿态仍未确定。即使再给出工具轴 $\boldsymbol z'$ 的方向，夹爪仍可绕这根轴滚转，横向的 $\boldsymbol x'$、$\boldsymbol y'$ 会随之改变。所以**一根轴的方向不等于完整姿态**，要描述整个固连系的三根轴。

<a id="sec-2.1.2"></a>

## 2.1.2 姿态与方向余弦

在刚体上固连右手正交坐标系 $O'\text{-}x'y'z'$。把三根轴的单位向量分别沿参考系分解：

$$\begin{aligned}
\boldsymbol x'&=x'_x\boldsymbol x+x'_y\boldsymbol y+x'_z\boldsymbol z,\\
\boldsymbol y'&=y'_x\boldsymbol x+y'_y\boldsymbol y+y'_z\boldsymbol z,\\
\boldsymbol z'&=z'_x\boldsymbol x+z'_y\boldsymbol y+z'_z\boldsymbol z.
\end{aligned}\qquad(\text{原书式 }2.2)$$

下标表示沿哪根**参考轴**的分量，例如 $x'_y$ 是本体系 $x'$ 轴沿参考系 $y$ 轴的分量。这 9 个分量叫固连系各轴相对参考系的**方向余弦**，名字的来历见下面的推导。

![课堂幻灯片：固连系三轴在参考系中的分量，幻灯片标题为“2.2 旋转矩阵”](../assets/ch02/direction-cosines.jpg)

::: thm 原理 2.1.A · 方向余弦与三个独立参数 {#thm-2.1.A}
把式 2.2 第一行与参考轴 $\boldsymbol y$ 点乘。参考系三轴两两垂直且长度为 1，所以 $\boldsymbol x\cdot\boldsymbol y=\boldsymbol z\cdot\boldsymbol y=0$、$\boldsymbol y\cdot\boldsymbol y=1$，右边只剩一项；$\boldsymbol x'$ 也是单位向量，点积就是夹角的余弦：

$$x'_y=\boldsymbol x'\cdot\boldsymbol y=\cos\angle(\boldsymbol x',\boldsymbol y).$$

其余 8 个分量同理。方向余弦是无量纲的数，范围为 $[-1,1]$。夹角在 $0^\circ$ 到 $180^\circ$ 之间，余弦为负说明夹角大于 $90^\circ$，该轴偏向参考轴的负方向。

9 个方向余弦不能随意填写。三根轴必须是单位长度，并且两两垂直：

$$\|\boldsymbol x'\|^2=\|\boldsymbol y'\|^2=\|\boldsymbol z'\|^2=1,\qquad
\boldsymbol x'\cdot\boldsymbol y'=\boldsymbol y'\cdot\boldsymbol z'=\boldsymbol z'\cdot\boldsymbol x'=0.$$

这是 6 个独立约束，留下 $9-6=3$ 个连续独立参数。也可以直接数：定 $\boldsymbol z'$ 的方向要 2 个角（它与参考 $z$ 轴的夹角，以及绕 $z$ 轴的方位角）；$\boldsymbol x'$ 必须落在与 $\boldsymbol z'$ 垂直的平面内，再要 1 个角；$\boldsymbol y'$ 由叉积 $\boldsymbol z'\times\boldsymbol x'$ 确定，不再有自由。两种数法都得到 3。

最后一步取 $\boldsymbol z'\times\boldsymbol x'$，就选定了右手系，等价于 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$。取 $-\boldsymbol z'\times\boldsymbol x'$ 同样单位、正交，得到的却是镜像的左手系。两种取法只是二选一，所以右手条件排除镜像，但不减少连续参数的个数。矩阵写法见 [§2.2 的参数计数](sec2-2.md#note-2.2.2)。

“3”是在某个姿态附近数出来的，它说明姿态要 3 个数，没有说哪 3 个数在所有姿态下都管用。上面的数法本身就有失效处：$\boldsymbol z'$ 恰好沿参考 $\pm z$ 时，像地球的南北极，方位角没有意义，它和绕 $\boldsymbol z'$ 的转角只剩一个组合能确定。§2.4 的 ZYZ 欧拉角正是这样取角的，同一处就是它的表示奇点（[@thm-2.4.B]）。随手挑三个矩阵元素作参数也不行，反例见 [@note-2.2.2]。
:::

### 从读数理解“投影”

先看一个 $xy$ 平面内的例子。左图的位置点为 $P=(0.30,0.20,0)\,\mathrm m$；右图的单位方向为 $(0.60,0.80,0)^{\mathrm T}$，图中标为一根本体轴 $x'$。两图都沿参考轴读分量，但**左图读长度，右图读无量纲的方向余弦**：$0.60$ 是这根轴与参考 $x$ 轴夹角（约 $53.1^\circ$）的余弦，$0.80$ 是它与参考 $y$ 轴夹角（约 $36.9^\circ$）的余弦。两图各用自己的比例尺，屏幕上的箭头长度不能跨图比较。

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
<figcaption>分量读取示例（本教程绘）。两图的 z 轴均指向屏幕外。右图只给出一根轴；按上面原理中的数法，还要在与它垂直的平面内选定横向轴，再由叉积确定第三轴，三轴才组成右手正交系。</figcaption>
</figure>

### 一组完整位姿：位置与朝向分别填写

::: ex 带数示范 · 绕参考 z 轴正转 90° {#ex-2.1.pose}
设固连系原点的位置为 $\boldsymbol o'=(0.30,-0.20,0.10)^{\mathrm T}\,\mathrm m$。固连系最初与参考系同向，随后绕与参考 $z$ 轴平行、经过 $O'$ 的轴按右手定则转 $+90^\circ$，保持 $O'$ 不动。从 $+z$ 一侧朝原点看，这个转动为逆时针。于是

$$\boldsymbol x'=(0,1,0)^{\mathrm T},\qquad
\boldsymbol y'=(-1,0,0)^{\mathrm T},\qquad
\boldsymbol z'=(0,0,1)^{\mathrm T}.$$

逆时针转四分之一圈把 $+x$ 带到 $+y$、把 $+y$ 带到 $-x$，转轴方向不变，所以 $x'$ 指向参考 $+y$，$y'$ 指向参考 $-x$，$z'$ 保持不变。按 [@thm-2.1.A] 核对：三列都是单位长度，两两点积为 0，$\boldsymbol x'\times\boldsymbol y'$ 等于 $\boldsymbol z'$。把这三列并排写出，就得到顶部图中的

$$R=\begin{bmatrix}0&-1&0\\1&0&0\\0&0&1\end{bmatrix}.$$

矩阵的每个元素都是方向余弦：$y'_x=-1=\cos180^\circ$，因为 $\boldsymbol y'$ 与参考 $\boldsymbol x$ 反向；$x'_x=0=\cos90^\circ$，因为二者垂直。这 9 个数没有米或角度单位，位置 $\boldsymbol o'$ 的三个分量仍以米计。
:::

::: think 练习 1 · 同一位姿下，点与方向怎样读？ {#practice-2.1.point}
沿用上例。工具上的点 $P$ 在固连系中的坐标为 $(0.10,0,0)^{\mathrm T}\,\mathrm m$，某单位方向在固连系中为 $(1,0,0)^{\mathrm T}$。

1. 先按 $x'$ 的朝向判断：点 $P$ 在参考系中的坐标是什么？该单位方向在参考系中又是什么？
2. 若保持三轴朝向不变，只把 $O'$ 的参考系 $x$ 坐标增加 $0.20\,\mathrm m$，上述两项各怎样变化？

::: sol 练习 1 核对
从 $O'$ 沿 $x'$ 走 $0.10\,\mathrm m$，就是沿参考 $+y$ 走 $0.10\,\mathrm m$，所以

$$\boldsymbol p=\boldsymbol o'+0.10\boldsymbol x'
=(0.30,-0.10,0.10)^{\mathrm T}\,\mathrm m.$$

单位方向只是 $\boldsymbol x'=(0,1,0)^{\mathrm T}$，不加 $\boldsymbol o'$。平移后，点坐标变为 $(0.50,-0.10,0.10)^{\mathrm T}\,\mathrm m$，方向仍为 $(0,1,0)^{\mathrm T}$。如果给方向也加上位置，它通常连单位长度都不再保持。
:::
:::

::: think 练习 2 · 三根轴都垂直，就够了吗？ {#practice-2.1.handedness}
另一组候选轴为 $\boldsymbol x'=(1,0,0)^{\mathrm T}$、$\boldsymbol y'=(0,1,0)^{\mathrm T}$、$\boldsymbol z'=(0,0,-1)^{\mathrm T}$。

检查三根轴的长度、两两点积和 $\boldsymbol x'\times\boldsymbol y'$。它们能否表示参考右手系经过刚体转动后的朝向？如果只指定 $\boldsymbol z'=(0,0,1)^{\mathrm T}$，又是否能唯一确定姿态？

::: sol 练习 2 核对
三根轴长度均为 1，两两点积均为 0，但 $\boldsymbol x'\times\boldsymbol y'=(0,0,1)^{\mathrm T}=-\boldsymbol z'$。这是左手系，对应矩阵 $\operatorname{diag}(1,1,-1)$ 的行列式为 $-1$。连续转动时行列式不能从 $+1$ 跳到 $-1$（理由见 [§2.2.1](sec2-2.md#sec-2.2.1)），所以它不能由右手系仅作刚体转动得到。下一节将把“正交且行列式为 $+1$”写成[旋转矩阵](../recall.md#rotation)的判据。

只给定 $z'$ 也不够。例如 $(\boldsymbol x',\boldsymbol y')=(\boldsymbol x,\boldsymbol y)$ 和 $(\boldsymbol y,-\boldsymbol x)$ 都与 $\boldsymbol z'=\boldsymbol z$ 组成右手系，却相差绕 $z'$ 的 $90^\circ$ 转动。这个滚转角就是原理 2.1.A 数法中的第 3 个参数。
:::
:::

<a id="sec-2.1"></a>

::: think 默写点 · 合上书再写
1. 位姿由什么组成？“6 个自由度”适用于什么对象？
2. 写出方向余弦 $x'_y$ 的点积表达式、单位和取值范围。
3. 9 个方向余弦有哪些连续约束？还要检查什么手性条件？
4. 为什么只给位置和一根工具轴的方向仍不够？

::: sol 核对
1. 位置与姿态。“6 个自由度”指无额外约束的空间刚体：3 个平移、3 个转动。机械手末端能实现哪些位姿，由关节的数目、布置和限位决定。
2. $x'_y=\boldsymbol x'\cdot\boldsymbol y$，无量纲，取值 $[-1,1]$。
3. 三条单位长度、三条两两垂直约束，留下 3 个连续独立参数，这是局部计数（[@note-2.2.2]）；还须 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$，排除左手镜像。
4. 位置只确定 $O'$；指定一根工具轴后，绕该轴的滚转仍可改变另外两根轴。
:::
:::

## 2.1 小结与常见错误

位姿需要同时说明原点的位置与固连系三轴的朝向。位置分量有长度单位；三轴的 9 个方向余弦无量纲，受单位长度与两两垂直共 6 个约束，只留下 3 个连续独立参数，另须右手性排除镜像。检查一组三轴时，这三项要一起查。

- 把位置当位姿：固定 $O'$ 后，刚体仍可绕它转动。
- 把一根轴当完整姿态：绕该轴的滚转尚未确定。
- 把方向余弦当角度：它是夹角的余弦，负值表示夹角大于 $90^\circ$。
- 给方向叠加平移：同向平移坐标系时，改变的是点的位置坐标。

接下来，[§2.2](sec2-2.md) 把这 9 个方向余弦按列排成旋转矩阵，统一处理三根轴，并区分姿态描述、坐标变换与旋转操作。
