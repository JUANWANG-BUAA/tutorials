# 1.3 移动机器人：轮系与机动性

本节围绕三个问题展开：**移动机器人靠什么移动？三类常规车轮怎样组合成五种底盘布局？为什么轮式机器人的「自由度」可能比位形变量少？** 之所以要先从车轮讲起，是因为移动机器人大多承担服务性工作，需要广泛而自主的移动能力；本节梳理的轮系与布局分类，正是第 11 章（移动机器人建模与控制）的物理预备。

<aside class="lesson-brief" aria-label="1.3 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p><a href="sec1-2.html#sec-1.2.1">1.2.1</a> 的自由度概念；刚体平面运动的直觉（平移 + 旋转）。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>三类车轮的机构差异；五种底盘布局与「能否原地转 / 能否即时横移」的对应；支撑三角形平衡条件；机动性与位形之辨。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>对任一轮式底盘（实物或照片）能识别轮型与布局，指出其不能即时移动的方向；能解释为什么三轮机器人最终仍能到达任意位形。</p></div>
</aside>

<a id="sec-1.3.1"></a>

## 1.3.1 两类移动与三类车轮

移动机器人由一个或多个配置了**运动系统（locomotion system）**的刚体构成，按移动方式分为两大类：

- **轮式移动机器人**：刚体（基座 / 底盘）+ 轮系，其他刚体（拖车）可经转动关节连接——占实际应用的绝大多数；
- **步行移动机器人**：多个刚体经移动 / 转动关节连接，部分形成下肢，末端（足）**周期性接触地面**实现移动；结构设计常源于生物体研究（**仿生机器人学**），从双足仿人到六足昆虫型。

::: note 范围脚注（原书注 ①）
原书不展开其他运动系统：**蛇形移动**（受蛇步态启发，适于不平坦与起伏地形，无需特殊装置）及**飞行、航行**等非地面方式。本课程沿用这一约定：下文只考虑轮式小车。
:::

轮式机器人的基本机械要素是**车轮**。常规车轮分三类（原书图 1.12）：

::: def 定义 1.3.1 · 定轮、导向轮与自位轮 {#def-1.3.1}
**定轮（fixed wheel）**：只有一个旋转轴——穿过车轮中心且垂直于轮面的轴；车轮牢固固定在底盘上，指向相对底盘不变。
**导向轮（steerable wheel）**：有两个旋转轴——第一个与定轮的轴相同，第二个**垂直且穿过车轮中心**，使车轮可相对底盘调整方向（转向 + 滚动）。
**自位轮（caster wheel）**：也有两个旋转轴，但**垂直轴不穿过车轮中心**、与中心有固定偏移量；车轮可自由转动并快速与底盘运动方向对齐——用于提供静态平衡支撑点而不影响基座运动性能（典型：购物车与轮椅的前轮）。
:::

::: intuition 一句话区分
**定轮只能沿轮面直走**；**导向轮靠电机转向**（方向可控）；**自位轮被动跟随**（方向自适应）。三个字概括：走、转、飘。
:::

<a id="sec-1.3.2"></a>

## 1.3.2 五种底盘布局

把这三种轮以不同方式组合，就得到五种常用布局（原书图 1.13–1.18）：

| 布局 | 轮配置 | 驱动 | 机动性要点 |
|:--|:--|:--|:--|
| **差动式**（differential drive） | 两个同轴**定轮** + 若干小**自位轮** | 两定轮**独立控制**角速度 | 两轮等速反向 → **原地旋转**；自位轮仅保平衡（从动）。原书注：两轮速度一般不同，牵引力矩须经**差速器**均分 |
| **同步驱动**（synchro-drive） | 三个**导向轮** | 两电机经同步链 / 传送带机械耦合：一控滚转（牵引）、一控转向 | 运动中**底座指向保持不变**（得到与差动式**相似的机动性**，原书）；常加第三电机旋转上部转台，用于相机等定向 |
| **三轮式**（tricycle） | 后轴两**定轮**（一电机驱动牵引）+ 前部一**导向轮**（舵机） | 牵引与转向分离 | 转弯半径受导向轮限制；也可后轮从动、前轮转向兼牵引 |
| **汽车式**（car-like） | 后轴两**定轮** + 前轴两**导向轮** | 一电机牵引 + 一电机转向 | 沿曲线运动时两前轮方向**必须不一致**（内侧轮转角更大），由**阿克曼转向几何（Ackermann steering）**保证不滑动 |
| **三主动自位轮式** | 三个按约 $120^\circ$ 对称布置的**自位轮**（caster，原书图 1.17） | 三个轮的**牵引速度独立驱动**（转向仍被动自适应） | **全向（omnidirectional）**：在理想无滑动模型下，能即时向任意平面方向平移并原地调整自身方向 |

这里有一个易混点须辨析：定义 1.3.1 中的自位轮**转向永远是被动自适应的**，但**牵引（滚动）既可以不装电机（被动），也可以独立驱动（主动）**。按牵引方式，自位轮可分为两类（见图 1.4）：

<figure>
<svg class="figure-svg" viewBox="0 0 920 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-13b-title fig-13b-desc">
<title id="fig-13b-title">五种底盘布局俯视示意</title>
<desc id="fig-13b-desc">五个并排小图依次为差动式、同步驱动、三轮式、汽车式与三主动自位轮式底盘的俯视示意图，标注各布局的驱动轮、从动轮与可实现的运动。</desc>
<defs>
<marker id="c13-ok" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--accent-text)"/></marker>
<marker id="c13-no" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<!-- 1 差动式 -->
<g transform="translate(92 140)">
<rect class="diagram-node" x="-34" y="-58" width="68" height="116" rx="16"/>
<circle class="diagram-fill-sage" cx="-30" cy="-30" r="15"/><circle class="diagram-fill-sage" cx="-30" cy="30" r="15"/>
<circle class="diagram-muted" cx="30" cy="-46" r="5" fill="none"/><circle class="diagram-muted" cx="30" cy="46" r="5" fill="none"/>
<path class="diagram-accent" d="M0 -78 V-104" marker-end="url(#c13-ok)"/>
<path class="diagram-muted" d="M0 -92 H-24" marker-end="url(#c13-no)" stroke-dasharray="4 3"/>
<text class="diagram-mono" x="6" y="-108">v</text><text class="diagram-note" x="-16" y="-72">× 侧向</text>
<text class="diagram-note" y="92" text-anchor="middle">差动：两定轮独立驱动</text>
<text class="diagram-note" y="110" text-anchor="middle">原地旋转 √ 横移 ×</text>
</g>
<!-- 2 同步驱动 -->
<g transform="translate(276 140)">
<circle class="diagram-node" cx="0" cy="0" r="56"/>
<g transform="translate(0 -34)"><circle class="diagram-fill-sage" r="13"/><line class="diagram-accent" x1="-20" y1="0" x2="20" y2="0"/></g>
<g transform="translate(-38 28)"><circle class="diagram-fill-sage" r="13"/><line class="diagram-accent" x1="-20" y1="0" x2="20" y2="0"/></g>
<g transform="translate(38 28)"><circle class="diagram-fill-sage" r="13"/><line class="diagram-accent" x1="-20" y1="0" x2="20" y2="0"/></g>
<path class="diagram-accent" d="M0 -72 V-98" marker-end="url(#c13-ok)"/>
<text class="diagram-note" y="92" text-anchor="middle">同步：三导向轮转向一致</text>
<text class="diagram-note" y="110" text-anchor="middle">车身指向保持不变</text>
</g>
<!-- 3 三轮式 -->
<g transform="translate(460 140)">
<rect class="diagram-node" x="-40" y="-40" width="80" height="80" rx="14"/>
<rect class="diagram-fill-sage" x="-52" y="-16" width="12" height="32" rx="3"/><rect class="diagram-fill-sage" x="40" y="-16" width="12" height="32" rx="3"/>
<g transform="translate(0 -50) rotate(24)"><circle class="diagram-fill-sage" r="13"/><line class="diagram-accent" x1="-18" y1="0" x2="18" y2="0"/></g>
<path class="diagram-muted" d="M0 8 H-30" marker-end="url(#c13-no)" stroke-dasharray="4 3"/>
<path class="diagram-accent" d="M14 26 A38 38 0 0 1 46 4" marker-end="url(#c13-ok)"/>
<text class="diagram-note" y="92" text-anchor="middle">三轮：前舵 + 后两定轮</text>
<text class="diagram-note" y="110" text-anchor="middle">转弯半径受舵轮限制</text>
</g>
<!-- 4 汽车式 -->
<g transform="translate(644 140)">
<rect class="diagram-node" x="-40" y="-42" width="80" height="84" rx="12"/>
<rect class="diagram-fill-sage" x="-52" y="-14" width="12" height="28" rx="3"/><rect class="diagram-fill-sage" x="40" y="-14" width="12" height="28" rx="3"/>
<g transform="translate(-24 -48) rotate(-30)"><rect class="diagram-fill-sage" x="-6" y="-14" width="12" height="28" rx="3"/></g>
<g transform="translate(24 -48) rotate(-18)"><rect class="diagram-fill-sage" x="-6" y="-14" width="12" height="28" rx="3"/></g>
<path class="diagram-accent" d="M-8 34 A44 44 0 0 1 -38 10" marker-end="url(#c13-ok)"/>
<text class="diagram-note" y="92" text-anchor="middle">汽车式：阿克曼转向</text>
<text class="diagram-note" y="110" text-anchor="middle">两前轮转角不同（防滑）</text>
</g>
<!-- 5 三主动自位轮 -->
<g transform="translate(828 140)">
<circle class="diagram-node" cx="0" cy="0" r="56"/>
<g transform="rotate(0) translate(0 -36)"><circle class="diagram-fill-sage" r="12"/><rect class="diagram-accent" x="-2.5" y="-24" width="5" height="14" rx="2"/></g>
<g transform="rotate(120) translate(0 -36)"><circle class="diagram-fill-sage" r="12"/><rect class="diagram-accent" x="-2.5" y="-24" width="5" height="14" rx="2"/></g>
<g transform="rotate(240) translate(0 -36)"><circle class="diagram-fill-sage" r="12"/><rect class="diagram-accent" x="-2.5" y="-24" width="5" height="14" rx="2"/></g>
<path class="diagram-accent" d="M-20 -84 V-100" marker-end="url(#c13-ok)"/>
<path class="diagram-accent" d="M-36 -76 L-48 -88" marker-end="url(#c13-ok)"/>
<path class="diagram-accent" d="M4 -76 L14 -90" marker-end="url(#c13-ok)"/>
<text class="diagram-note" y="92" text-anchor="middle">三主动自位轮（原书图 1.17）</text>
<text class="diagram-note" y="110" text-anchor="middle">牵引独立驱动 → 全向</text>
</g>
</svg>
<figcaption>图 1.4　五种底盘布局俯视示意（绿实线 = 驱动 / 允许的运动，灰虚线 = 禁止的瞬时运动，带柄圆 = 自位轮）。注意第 5 种与第 1 种的本质差异：差动式的自位轮纯被动（只保平衡），全向式的三个自位轮**牵引独立驱动**——同为「自位轮」，角色完全不同。</figcaption>
</figure>

- **被动自位轮**（购物车前轮、差动式布局的支撑轮）：不提供任何驱动，只保平衡；
- **主动牵引自位轮**（powered caster，原书图 1.17 的全向方案）：牵引速度独立驱动 + 偏移轴使方向被动对齐——三个即可全向。原书原文：*three caster wheels … The traction velocities of the three wheels are independently driven … this vehicle is omnidirectional*。

实现全向的另一条路线是特殊轮型：**麦克纳姆轮（Mecanum）**（又称瑞典轮，原书图 1.18）——本质是定轮，外缘安装从动滚筒，滚筒轴相对轮面倾斜 $45^\circ$，侧向分量经滚筒「泄放」；四轮成对装在两条平行轴上，小车同样能实现全向运动。

::: ex 例 1.3.A · 布局识别三连（新增） {#ex-1.3.A}
(a) 家用扫地机器人：底部两主轮独立驱动 + 边缘小从动轮 → **差动式**（可原地旋转掉头）；(b) 三轮 courier 机器人前方一个舵轮、后方两驱动轮 → **三轮式**；(c) 汽车 → **汽车式 + 阿克曼转向**。反向推断亦可：见到底盘能**即时横移**的，必为全向布局——要么是三个主动牵引自位轮（powered caster），要么是麦克纳姆轮系。
:::

<a id="sec-1.3.3"></a>

## 1.3.3 平衡与机动性：位形 ≠ 自由度

轮型与布局定了，接下来要问：这样的底盘究竟能往哪些方向走？这要先看平衡，再看机动性。

**静平衡**：在轮式设计中，力学平衡通常不是难题。

::: thm 原理 1.3.B · 支撑三角形条件（新增整理） {#thm-1.3.B}
三轮机器人的**重心落在三个轮地接触点构成的支撑三角形（support triangle）以内**时，机器人静态平衡；多于三轮则形成支撑多边形，平衡条件更易满足。推论：机器人在**不平整地面**上移动时，需要**悬挂系统**保证每个车轮与地面的接触。
:::

**机动性**：移动机器人的工作空间（能到达的环境区域）可以是**无限的**——这是它与机械手（工作空间有界）的根本差异。但可达范围的大小，并不等于机动性的高低：

::: def 定义 1.3.2 · 即时机动性与约束（新增整理） {#def-1.3.2}
**非全向**移动机器人的**局部机动性总是被缩减的**。例如三轮机器人不能即时向**平行于后轮轴**的方向移动。但它仍可通过机动操纵（先转向再前进）在运动的**最后**得到该方向上的净位移。形式化表述：**机器人的（即时运动）自由度数——容许瞬时运动的方向数——比位形变量的数目少**。全向机器人（主动牵引自位轮 / 麦克纳姆轮）是例外：即时自由度与位形变量数相等。
:::

下面把这个看似反直觉的结论写成式子。设平面底盘的位形为

$$\boldsymbol q=\begin{bmatrix}x&y&\theta\end{bmatrix}^{T},$$

其中 $(x,y)$ 是底盘参考点在世界坐标系的位置，$\theta$ 是车头朝向。对不允许横向打滑的定轮，横向单位向量为 $\boldsymbol n=(-\sin\theta,\cos\theta)$；速度 $(\dot x,\dot y)$ 在该方向的投影必须为零：

$$\boldsymbol n^T\begin{bmatrix}\dot x\\\dot y\end{bmatrix}=0
\quad\Longrightarrow\quad
-\sin\theta\,\dot x+\cos\theta\,\dot y=0.
\tag{1.1}$$

式 (1.1) 只限制**瞬时速度**，不能积分成只含 $x,y,\theta$ 的位置等式；这就是「非完整约束」的入口。它删掉了侧向的一条瞬时运动方向，却没有把某一个地点从可达集合中删掉：改变 $\theta$ 后，允许的前进方向也随之改变。

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-13-title fig-13-desc">
<title id="fig-13-title">差动或三轮底盘的无侧滑约束</title>
<desc id="fig-13-desc">平面底盘沿车头方向允许前进，沿车轴方向的侧向速度被无侧滑约束禁止；转向再前进可取得侧向净位移。</desc>
<defs>
<marker id="arr-13" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="arr-13a" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--accent-text)"/></marker>
</defs>
<g transform="translate(290 176) rotate(-24)">
<rect class="diagram-node" x="-115" y="-55" width="230" height="110" rx="32"/>
<circle class="diagram-fill-sage" cx="-69" cy="-62" r="24"/><circle class="diagram-fill-sage" cx="69" cy="-62" r="24"/>
<circle class="diagram-fill-sage" cx="-69" cy="62" r="24"/><circle class="diagram-fill-sage" cx="69" cy="62" r="24"/>
<path class="diagram-accent" d="M0 0H151" marker-end="url(#arr-13a)"/><text class="diagram-mono" x="157" y="-8">允许：v</text>
<path class="diagram-muted" d="M0 -105V105"/><path class="diagram-muted" d="M0 -88V88"/>
<text class="diagram-note" x="8" y="-114">禁止侧向速度 n<tspan class="sp">T</tspan>v = 0</text>
</g>
<line class="diagram-axis" x1="574" y1="248" x2="824" y2="248" marker-end="url(#arr-13)"/><line class="diagram-axis" x1="574" y1="248" x2="574" y2="64" marker-end="url(#arr-13)"/>
<path class="diagram-accent" d="M610 218C663 169 707 149 779 117" marker-end="url(#arr-13a)"/><path class="diagram-accent" d="M643 235A44 44 0 0 1 678 199" marker-end="url(#arr-13a)"/>
<text class="diagram-text" x="700" y="43" text-anchor="middle">“先转向，再前进”</text><text class="diagram-note" x="700" y="66" text-anchor="middle">改变允许方向，取得侧向净位移</text>
<text class="diagram-note" x="827" y="265">x</text><text class="diagram-note" x="561" y="59">y</text><text class="diagram-mono" x="630" y="193">Δθ</text>
</svg>
<figcaption>图 1.5　无侧滑约束禁止的是车体横向的瞬时速度，不是最终位置。图右的“转向—前进”序列说明为何非全向底盘依然可到达侧方位置。</figcaption>
</figure>

::: intuition 「能到达」与「能即时到达」
想象开车入库：车位在车的正侧方，你**此刻**不能横着滑进去（非全向），但通过「前—后—打轮」的一串操作**最终**能停进去。轮式小车的世界没有「此路不通」，只有「此向需绕行」——这句话的数学化（非完整约束）正是第 11 章的主题。
:::

<a id="sec-1.3.4"></a>

## 1.3.4 移动机械手：两种身体的融合

最后，把前面两类身体合到一起：将机械手安装在移动小车上，机械结构融合为**移动机械手（mobile manipulator）**（原书图 1.19：拟人臂 + 差动小车），它结合了**关节臂的灵活性与底座的无限移动性**。代价是设计面临额外困难：静态与动态力学平衡问题、**两套系统的驱动问题**等——这是「结构融合 1 + 1 > 2 但难度也 > 2」的典型例子。

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先写出下面几条，再展开核对。写不出来就说明这一节还没「拿走」。

1. 三类车轮各叫什么？「走 / 转 / 飘」分别对应哪一类？
2. 差动底盘为什么能原地转，却不能即时横移？
3. 「不能即时横移」与「不能横移」有什么不同？

::: sol 核对

定轮（走）、导向轮（转）、自位轮（飘——垂直轴不过轮心，被动对齐）。

两轮同速反向即可原地转；但车轮只能沿轮面方向运动，无侧滑约束禁止垂直于轮面的速度分量，所以瞬时速度里没有横向分量。

式 (1.1) 是**速度约束**而非位置约束：非全向机器人仍可通过「前进—转向—再前进」的机动操纵到达任意位置，只是不能**瞬时**横移。

:::

:::

## 1.3 小结与常见错误

- **一条主线**：两类移动（轮式 / 步行）→ 三类车轮（走 / 转 / 飘）→ 五种布局（差动、同步、三轮、汽车式、全向）→ 平衡看支撑多边形、机动性看无侧滑约束式 (1.1) → 移动机械手融合两种身体。
- **两个极端**：差动式（结构最简、可原地旋转、不能横移）与全向式（可即时任意平移 + 旋转、结构 / 驱动最复杂）。
- **一个辨析**：工作空间无限 ≠ 局部机动性无限（定义 1.3.2）——「能到达」与「能即时到达」是两个命题。

::: think 常见错误清单 · 自查五条
1. 把自位轮当导向轮——自位轮**被动**对齐方向，无电机控制转向（定义 1.3.1 的偏移量是机构关键）；
2. 把「自位轮」一概当成纯被动支撑轮——转向确实被动，但**牵引可以独立驱动**：三个主动牵引自位轮正是原书图 1.17 的全向方案；纯被动的自位轮才只提供支撑；
3. 以为「不能即时横移 = 不能横移」——式 (1.1) 是速度约束，非全向机器人仍可通过机动操纵获得任意净位移；
4. 忽略阿克曼几何——汽车式前两轮方向不一致是**避免滑动**的机构要求，不是工艺误差；
5. 数移动机器人自由度时直接数轮子——应数**容许瞬时运动的方向数**，它与位形变量数（平面刚体是 3：$x,y,\theta$）未必相等（定义 1.3.2）。
:::
