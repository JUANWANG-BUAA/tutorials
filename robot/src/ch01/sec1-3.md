# 1.3 移动机器人：轮系与机动性

车位就在汽车侧面，为什么不能直接横着开进去？差动小车能原地转，汽车通常却要走一段弧线。这些差别来自轮子允许的运动。本节先辨认三类常规车轮，再比较底盘布局，最后用速度约束解释“最终能到达”和“此刻能往哪里动”的区别，为第 11 章建模与控制做准备。

<a id="sec-1.3.1"></a>

## 1.3.1 两类移动与三类车轮

移动机器人由一个或多个配置了**运动系统（locomotion system）**的刚体构成。本段比较两种地面移动方式：

- **轮式移动机器人**：刚体（基座 / 底盘）+ 轮系，其他刚体（拖车）可经转动关节连接——占实际应用的绝大多数；
- **步行移动机器人**：多个刚体经移动 / 转动关节连接，部分形成下肢，末端（足）**周期性接触地面**实现移动；结构设计常源于生物体研究（**仿生机器人学**），从双足仿人到六足昆虫型。

::: note 范围脚注（原书注 ①）
原书还提到适于不平地形的**履带移动**、受蛇步态启发的**波动移动**，以及飞行、航行等方式，但不在本段展开。下文只讨论在地面运动的轮式小车。
:::

轮式机器人的基本机械要素是**车轮**。常规车轮分三类（原书图 1.12）：

::: def 定义 1.3.1 · 定轮、导向轮与自位轮 {#def-1.3.1}
在水平地面的理想模型中：

- **定轮（fixed wheel）**：轮轴穿过轮心并垂直轮面，轮子可绕此轴滚动，但轮面方向相对底盘固定。“定”指轮向固定，不是轮子不转。
- **导向轮（steerable wheel）**：除滚动轴外，还有穿过轮心的竖直转向轴，可以改变轮面方向。方向是否主动控制，要另看驱动配置。
- **自位轮（caster wheel）**：竖直转向轴与轮心有固定水平偏移。本节常见方案让它自由回转，在运动中被动调整轮向；购物车的小脚轮即为例子。被动对齐需要过程，实际可能有阻力、摆振或短时滑动，不能保证对运动性能毫无影响。
:::

::: intuition 一句话区分
观察车轮时依次问：轮向相对底盘能不能变？竖直转向轴是否偏离轮心？滚动和转向各由什么驱动？前两问判轮型，最后一问判驱动方式。定轮可以主动驱动，也可以从动；自位轮也不等于纯被动支撑轮。
:::

<a id="sec-1.3.2"></a>

## 1.3.2 五种底盘布局

把这三种轮以不同方式组合，就得到五种常用布局（原书图 1.13–1.18）：

| 布局 | 轮配置 | 驱动 | 机动性要点 |
|:--|:--|:--|:--|
| **差动式**（differential drive） | 两个同轴**定轮** + 若干小**自位轮** | 两定轮**独立控制**速度 | 两驱动轮轮缘等速反向 → 绕轮轴中点**原地旋转**；支撑自位轮从动。双电机差动驱动不要求机械差速器 |
| **同步驱动**（synchro-drive） | 三个**导向轮** | 两电机经同步链 / 传送带机械耦合：一控滚动、一控共同轮向 | 三轮方向和轮缘速度相同，底盘可沿共同轮向平移，车身指向保持不变；轮向改变后可以改道。上部转台的独立回转不等于底盘回转 |
| **三轮式**（tricycle） | 后轴两**定轮**（一电机驱动牵引）+ 前部一**导向轮**（舵机） | 牵引与转向分离 | 转弯半径受导向轮限制；也可后轮从动、前轮转向兼牵引 |
| **汽车式**（car-like） | 后轴两**定轮** + 前轴两**导向轮** | 一电机牵引 + 一电机转向 | 沿曲线运动时两前轮方向**必须不一致**（内侧轮转角更大），由**阿克曼转向几何（Ackermann steering）**保证不滑动 |
| **三主动自位轮式** | 三个带偏置的**自位轮**（原书图 1.17） | 三个轮的**牵引速度独立驱动**，转向自由回转 | 原书的理想全向方案；理解时须考虑支点偏置、当前轮向与速度映射，不能把三个任意布置的驱动轮都当成全向底盘 |

这里要把轮型与驱动分开：原书这些自位轮的**转向被动调整**，而牵引既可以从动，也可以独立驱动；“caster”这一几何名称本身不禁止其他驱动设计。另外，原书关于**机械差速器**的脚注针对三轮式单电机驱动的后轮轴：弯道中左右轮走的路程不同，差速器允许轮速不同，同时传递牵引力矩；不要与双电机的差动驱动混为一谈。

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
<rect class="diagram-fill-sage" x="-43" y="12" width="12" height="30" rx="3"/><rect class="diagram-fill-sage" x="31" y="12" width="12" height="30" rx="3"/>
<line class="diagram-muted" x1="-37" y1="27" x2="37" y2="27" stroke-dasharray="4 3"/><circle class="diagram-muted" cx="0" cy="-40" r="6" fill="none"/>
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
<rect class="diagram-fill-sage" x="-52" y="12" width="12" height="32" rx="3"/><rect class="diagram-fill-sage" x="40" y="12" width="12" height="32" rx="3"/>
<g transform="translate(0 -50) rotate(24)"><circle class="diagram-fill-sage" r="13"/><line class="diagram-accent" x1="-18" y1="0" x2="18" y2="0"/></g>
<path class="diagram-muted" d="M0 8 H-30" marker-end="url(#c13-no)" stroke-dasharray="4 3"/>
<path class="diagram-accent" d="M-8 26 A38 38 0 0 1 -34 4" marker-end="url(#c13-ok)"/>
<text class="diagram-note" y="92" text-anchor="middle">三轮：前舵 + 后两定轮</text>
<text class="diagram-note" y="110" text-anchor="middle">转弯半径受舵轮限制</text>
</g>
<!-- 4 汽车式 -->
<g transform="translate(644 140)">
<rect class="diagram-node" x="-40" y="-42" width="80" height="84" rx="12"/>
<rect class="diagram-fill-sage" x="-46" y="18" width="12" height="28" rx="3"/><rect class="diagram-fill-sage" x="34" y="18" width="12" height="28" rx="3"/>
<g transform="translate(-24 -48) rotate(30)"><rect class="diagram-fill-sage" x="-6" y="-14" width="12" height="28" rx="3"/></g>
<g transform="translate(24 -48) rotate(18)"><rect class="diagram-fill-sage" x="-6" y="-14" width="12" height="28" rx="3"/></g>
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
<figcaption>布局图解（本教程绘，车头均朝上）：差动式的两个驱动轮在同一轮轴上；三轮与汽车式的两个后轮在同一后轴上。带柄圆表示自位轮。第 1 种的自位轮从动，第 5 种的自位轮牵引独立驱动；轮型相同，驱动角色不同。</figcaption>
</figure>

- **被动自位轮**（购物车前轮、差动式布局的支撑轮）：不提供任何驱动，只保平衡；
- **主动牵引自位轮**（powered caster）：原书图 1.17 让三个轮子的牵引速度独立驱动，转向自由调整；分析运动时仍须保留自位轮偏置和轮向，不能把它画成无偏置的普通定轮。

实现全向的另一条路线是特殊轮型：**麦克纳姆轮（Mecanum）**（原书图 1.18）。轮体的轮向相对底盘固定，外缘带有从动滚子，常见滚子轴相对轮面倾斜 $45^\circ$。接触处允许的被动运动方向改变了普通定轮的约束。四轮采用合适的滚子朝向、布局和独立驱动，并满足理想接触条件时，可合成前进、横移与旋转；仅安装四个这种轮子还不足以保证整车全向。

::: intuition 动手实验 · 对照输入、轮向与速度读数
演示显示的是**瞬时速度和轮向**，不播放行驶轨迹。车体 $x$ 向前、$y$ 向左，$\omega>0$ 表示左转。每种底盘有不同的有效输入。

1. **差动式**：轮距 $b=0.56\ \mathrm m$。设左轮 $0.20\ \mathrm{m/s}$、右轮 $0.60\ \mathrm{m/s}$，先算 $v=(v_{\mathrm L}+v_{\mathrm R})/2$ 与 $\omega=(v_{\mathrm R}-v_{\mathrm L})/b$；再改成左 $-0.50$、右 $0.50$，判断是否原地转。
2. **同步式**：保持共同轮速 $0.50\ \mathrm{m/s}$，把共同轮向由 $0^\circ$ 改成 $30^\circ$。看三轮是否同时转向、速度方向是否改变、车身角速度是否仍为零。
3. **汽车式**：设参考点速度 $0.50\ \mathrm{m/s}$、等效前轮转角 $20^\circ$，比较左右前轮角度；改成 $-20^\circ$ 再比较。最后把转角设为零，检查两前轮是否回正。
4. **主动自位轮速度分配**：设前向速度为零、左向速度 $0.50\ \mathrm{m/s}$、角速度零，观察目标横移对应的各轮滚动速度与被动转向速率。这里由目标底盘速度反算轮运动，未模拟转向的时间过程。

<div class="lab" data-lab="chassis3d"></div>

<details id="sec13-lab-answers"><summary>操作后核对：数值与解释</summary>

差动式第一组得到 $v=0.40\ \mathrm{m/s}$、$\omega\approx0.714\ \mathrm{rad/s}$，向前并左转；第二组 $v=0$、$\omega\approx1.786\ \mathrm{rad/s}$，绕轮轴中点原地转。

同步式在 $30^\circ$ 时，车体速度为 $(v_x,v_y)\approx(0.433,0.250)\ \mathrm{m/s}$，但 $\omega=0$；改变轮向与转动车身是两件事。

汽车式轴距 $L=0.68\ \mathrm m$、前轮距 $t=0.60\ \mathrm m$。在 $20^\circ$ 时，后轴中点转弯半径 $R=L/\tan20^\circ\approx1.868\ \mathrm m$，左前轮约 $23.44^\circ$、右前轮约 $17.41^\circ$，左轮为内轮；右转时两轮角色交换且角度为负。零转角时两轮都为零，沿直线运动。

自位轮示意当前轮向取 $0^\circ,120^\circ,240^\circ$、偏置 $e=0.06\ \mathrm m$。纯左移时三轮滚动速度约为 $0,0.433,-0.433\ \mathrm{m/s}$，相对底盘的被动转向速率约为 $8.333,-4.167,-4.167\ \mathrm{rad/s}$；偏置让支点的横向运动可以通过轮向变化适应。高转向速率也说明不能把瞬时几何关系当作实机无限快对齐的保证。

无脚本时可根据以上参数与公式完成纸笔计算。

</details>
:::

::: ex 例 1.3.A · 布局识别三连（新增） {#ex-1.3.A}
(a) 两个同轴主轮独立驱动、另有从动支撑轮 → **差动式**；(b) 后轴两个定轮、前方一个舵轮 → **三轮式**；(c) 后两定轮、前两导向轮 → **汽车式**，弯道中应满足阿克曼关系。若只观察到即时横移，能判断它具有该方向运动能力，却不能唯一确定轮型；除本节两种例子外，还有其他全向轮与驱动布局。
:::

<a id="sec-1.3.3"></a>

## 1.3.3 平衡与机动性：位形 ≠ 自由度

轮型与布局定了，接下来要问：这样的底盘究竟能往哪些方向走？这要先看平衡，再看机动性。

**静平衡**：先检查哪些轮子实际接地，再看重心的位置。

::: thm 原理 1.3.B · 支撑三角形条件（新增整理） {#thm-1.3.B}
在水平地面、机器人静止、仅受重力及地面支持力且接触不滑动时，**重心的竖直投影**应严格位于有效接触点构成的支撑多边形内部，才有抗倾覆余量。三个不共线接触点构成支撑三角形；投影落在边界时抗倾覆余量为零，落在外部则无法仅靠这些支持点平衡。

增加轮数不自动增加支撑区域；悬空轮也不能计入有效接触点。不平地面可采用悬挂、柔顺或其他接地设计。坡地、加速、急转和机械臂伸出时还须重新分析受力及重心，不能只套平地静态条件。
:::

**机动性**：在理想无界平面上，移动底盘的可达区域可以无界；实机仍受障碍、地形、续航和通信范围限制。可达区域有多大，与此刻允许的速度方向有几个，是两个不同问题：

::: def 定义 1.3.2 · 即时机动性与约束（新增整理） {#def-1.3.2}
本节用**即时运动能力**表示：在当前构形与轮向下，满足无侧滑约束的底盘速度有多少个独立方向。它与描述位置、朝向的位形变量数不同。

差动底盘的平面位形有三个变量，但只能独立选择前进速度和角速度，不能立即侧移。三轮或汽车式在**固定前轮转角时**，前进与角速度还受曲率关系约束；转向速度可以改变后续的允许方向，却不会立刻增加一个横向底盘速度。不要把“有牵引和转向两个输入”直接读成“固定轮向下有两个独立底盘速度”。
:::

下面把这个看似反直觉的结论写成式子。设平面底盘的位形为

$$\boldsymbol q=\begin{bmatrix}x&y&\theta\end{bmatrix}^{T},$$

这里明确选择**差动底盘驱动轮轴的中点**，或三轮/汽车式的**后轴中点**作为参考点，$(x,y)$ 是该点的世界坐标，$\theta$ 是车头朝向。无侧滑时，这个点沿车体横向 $\boldsymbol n=(-\sin\theta,\cos\theta)$ 的速度分量为零：

$$\boldsymbol n^T\begin{bmatrix}\dot x\\\dot y\end{bmatrix}=0
\quad\Longrightarrow\quad
-\sin\theta\,\dot x+\cos\theta\,\dot y=0.
\tag{1.1}$$

所以 $\dot x=v\cos\theta,\ \dot y=v\sin\theta$。差动式还能独立调节 $\dot\theta=\omega$；汽车式则须同时满足 $\omega=v\tan\delta/L$。若把参考点移到车头，车身旋转会让该点产生侧向速度，不能直接对它照抄式 (1.1)。

式 (1.1) 限制瞬时速度，不能化成只含 $x,y,\theta$ 的固定位置等式；这是“非完整约束”的入口。在无障碍、空间足够且允许相应前进/倒车操作的理想场景中，改变朝向后再行驶，可以取得侧向净位移；障碍或最小转弯半径仍可能使具体路线不可行。

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
<rect class="diagram-fill-sage" x="-13" y="-71" width="26" height="24" rx="3"/><rect class="diagram-fill-sage" x="-13" y="47" width="26" height="24" rx="3"/>
<line class="diagram-muted" x1="0" y1="-59" x2="0" y2="59" stroke-dasharray="4 3"/><circle class="diagram-fill-accent" cx="0" cy="0" r="5"/>
<circle class="diagram-muted" cx="87" cy="0" r="8" fill="none"/>
<path class="diagram-accent" d="M0 0H151" marker-end="url(#arr-13a)"/><text class="diagram-mono" x="157" y="-8">允许：v</text>
<path class="diagram-muted" d="M0 -105V105"/><path class="diagram-muted" d="M0 -88V88"/>
<text class="diagram-note" x="8" y="-114">禁止侧向速度 n<tspan class="sp">T</tspan>v = 0</text>
</g>
<line class="diagram-axis" x1="574" y1="248" x2="824" y2="248" marker-end="url(#arr-13)"/><line class="diagram-axis" x1="574" y1="248" x2="574" y2="64" marker-end="url(#arr-13)"/>
<path class="diagram-accent" d="M610 218C663 169 707 149 779 117" marker-end="url(#arr-13a)"/><path class="diagram-accent" d="M643 235A44 44 0 0 1 678 199" marker-end="url(#arr-13a)"/>
<text class="diagram-text" x="700" y="43" text-anchor="middle">“先转向，再前进”</text><text class="diagram-note" x="700" y="66" text-anchor="middle">改变允许方向，取得侧向净位移</text>
<text class="diagram-note" x="827" y="265">x</text><text class="diagram-note" x="561" y="59">y</text><text class="diagram-mono" x="630" y="193">Δθ</text>
</svg>
<figcaption>速度约束图解（本教程绘）：左图参考点是两驱动轮轴中点，车头朝右；允许沿车头方向前进，禁止该点瞬时横移。右图表示改变朝向后再前进可取得侧向净位移，未表示所有有障碍环境中都存在可行路径。</figcaption>
</figure>

::: intuition 「能到达」与「能即时到达」
想象开车入库：车位在侧方，此刻不能横着滑进去，但空间足够时，可通过前进、倒车和转向停入。若通道太窄，机动也可能失败。“速度受约束”与“能否完成一条具体路径”要分别判断。
:::

<a id="sec-1.3.4"></a>

## 1.3.4 移动机械手：两种身体的融合

将机械手安装在移动底盘上，就得到**移动机械手**（mobile manipulator，原书图 1.19）。底盘扩大作业区域，机械臂在局部调整工具位姿；伸臂会改变整机重心和受力，底盘与机械臂也须协调驱动。不能把机械臂的固定基座模型直接搬到正在行驶的底盘上。

::: think 默写点 · 合上书再写（主动回忆）



1. 三类车轮的轮向和竖直转向轴分别有什么特点？轮型能否直接说明驱动方式？
2. 差动底盘为什么能原地转，却不能即时横移？
3. 「不能即时横移」与「不能横移」有什么不同？
4. 固定当前轮向时，差动式与汽车式各有几个独立底盘速度？重心投影在支撑三角形边界上时，还有抗倾覆余量吗？

::: sol 核对

定轮的轮向相对底盘固定；导向轮的竖直转向轴过轮心；自位轮的竖直转向轴与轮心有水平偏置。轮型按几何区分，牵引和转向的驱动方式要另行判断。

两轮同速反向即可原地转；但车轮只能沿轮面方向运动，无侧滑约束禁止垂直于轮面的速度分量，所以瞬时速度里没有横向分量。

式 (1.1) 是参考轮轴中点的速度约束；改变朝向后再行驶可取得侧向净位移。具体能否到达仍取决于障碍、空间、转向限制及可用操作。

差动式可独立选择 $v,\omega$，有两个；汽车式固定舵角 $\delta$ 后满足 $\omega=v\tan\delta/L$，只有一个独立底盘速度。平地静态模型中，重心投影落在支撑三角形边界时，抗倾覆余量为零。

:::

:::

## 1.3 小结与常见错误

- **一条主线**：轮式与步行 → 按轴几何辨认三类常规轮 → 比较五种底盘布局 → 平衡看支撑多边形、机动性看无侧滑约束式 (1.1) → 移动机械手协调底盘与机械臂。
- **比较运动**：差动式能原地转、不能即时侧移；同步式能改变平移方向但车身不转；汽车式的角速度与速度、舵角相互约束。
- **区分三个量**：位形变量数、当前轮向下的独立底盘速度数、驱动输入数不能直接互换。

::: think 常见错误清单 · 自查五条
1. 只按有没有转向电机判断轮型——定轮、导向轮和自位轮先按轴几何区分，驱动配置另记；
2. 把「自位轮」一概当成纯被动支撑轮——本节方案的转向被动，但**牵引可以独立驱动**；原书图 1.17 的三个主动牵引自位轮须结合偏置与速度映射理解；
3. 以为“不能即时横移”就是侧方位置永远不可达，或反过来断言任意障碍中都可绕到——速度约束与具体路径可行性是两层判断；
4. 忽略阿克曼几何——汽车式前两轮方向不一致是**避免滑动**的机构要求，不是工艺误差；
5. 直接用轮数或电机数代替即时运动能力——先固定参考点与当前轮向，列约束再判断独立底盘速度（定义 1.3.2）。
:::

下一节讨论[工业与先进机器人学](sec1-4.md)：在理解机械结构的运动边界后，再看任务环境、性能参数与自治要求如何影响应用。
