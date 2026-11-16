# 1.2 机器人机械手：构形与自由度

把零件送到装配孔上方，还要让它以正确方向插入：前者要求机械手能到达目标位置，后者要求它能调整工具朝向。本节先学会数独立运动变量，再比较五种经典构形，最后用球形腕说明位置与朝向怎样分步求解。这些几何直觉将用于[第二章运动学](../ch02/overview.md)。

<a id="sec-1.2.1"></a>

## 1.2.1 运动链、关节与自由度

::: def 定义 1.2.1 · 机械手的组成与运动链 {#def-1.2.1}
**机器人机械手**由一系列**刚性构件（连杆）**通过**关节**联结而成，其典型结构是三段式：**臂（arm）**保证可移动性（定位），**腕（wrist）**提供灵活性（定向），**末端执行器（end-effector）**负责执行任务。从拓扑上看：若连杆链两端之间只有一个连接序列，称为**开式运动链**；若存在连杆序列构成回路，则称为**闭式运动链**。
:::

::: def 定义 1.2.2 · 两类关节与自由度 {#def-1.2.2}
本节用两类单自由度关节构造机械手：**移动关节 P**（prismatic，沿一条轴相对平移）和**转动关节 R**（revolute，绕一条轴相对转动）。**自由度**是描述机构构形所需的独立变量数。对无额外约束的开式链，每个单自由度关节贡献一个变量；闭式链有回路约束，须先判断哪些变量仍独立，不能直接数关节或电机个数。

本节所说的**位置工作空间**是选定的末端参考点能到达的位置集合。它取决于连杆尺寸、关节轴布局、关节限位和工具偏置；某点能到达，也不代表在该点能实现所需朝向。[2.10.2](../ch02/sec2-10.md#sec-2.10.2) 将进一步区分不同工作空间。
:::

::: thm 原理 1.2.A · 完整位姿的六变量（新增整理） {#thm-1.2.A}
三维刚体的完整位姿局部有 **6 个独立变量**：3 个位置坐标和 3 个定向变量。要在一个位形附近独立调节这六个量，机械手至少需要 6 个独立关节变量。**这是必要条件**：六轴臂仍会受到可达范围、关节限位和奇异位形的限制。

任务可以只要求部分位置或朝向变量。例如平面绘图只需控制平面内位置，竖直插装常需控制三维位置和绕竖直轴的一个转角，少于六轴也可能够用。若机构自由度多于所选任务的独立变量数，就具有相对于该任务的**运动学冗余**，可用于避障、避开奇点或调整构形（见 [1.4.2](sec1-4.md#sec-1.4.2) 的七轴 LWR）。
:::

完整位姿可以写为

$$T=(\boldsymbol p,R),\qquad \boldsymbol p\in\mathbb R^3,\quad R\in SO(3).$$

这里 $\boldsymbol p$ 表示位置，$R$ 表示工具坐标轴相对参考坐标系的方向；$SO(3)$ 是所有三维旋转矩阵组成的集合。$R$ 虽写成 9 个数，但正交条件 $R^TR=I$ 给出 6 个独立约束，$\det R=1$ 再排除镜像，因此局部只需 3 个独立量描述旋转。[2.2.1](../ch02/sec2-2.md#sec-2.2.1) 将推导这些条件；此处先把握位置与定向各有三个变量。

<figure>
<svg class="figure-svg" viewBox="0 0 920 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-12-title fig-12-desc">
<title id="fig-12-title">刚体完整位姿的六个独立变量</title>
<desc id="fig-12-desc">左侧用世界坐标系定位工具中心点，右侧在工具中心点展示三个姿态轴，说明完整位姿由三维位置和三维姿态组成。</desc>
<defs>
<marker id="arr-12" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<line class="diagram-axis" x1="80" y1="240" x2="330" y2="240" marker-end="url(#arr-12)"/><line class="diagram-axis" x1="80" y1="240" x2="80" y2="54" marker-end="url(#arr-12)"/>
<line class="diagram-axis" x1="80" y1="240" x2="27" y2="286" marker-end="url(#arr-12)"/><text class="diagram-note" x="11" y="283">y</text>
<line class="diagram-muted" x1="80" y1="240" x2="254" y2="116"/>
<circle class="diagram-fill-accent" cx="254" cy="116" r="8"/><line class="diagram-accent" x1="80" y1="240" x2="247" y2="121" marker-end="url(#arr-12)"/>
<text class="diagram-text" x="168" y="70" text-anchor="middle">定位：位置向量 p</text><text class="diagram-note" x="168" y="93" text-anchor="middle">三个独立坐标 x, y, z</text>
<text class="diagram-note" x="339" y="255">x</text><text class="diagram-note" x="67" y="50">z</text><text class="diagram-mono" x="194" y="173">p</text>
<rect class="diagram-node" x="523" y="83" width="150" height="122" rx="5" transform="rotate(-18 598 144)"/>
<circle class="diagram-fill-sage" cx="598" cy="144" r="7"/>
<line class="diagram-accent" x1="598" y1="144" x2="728" y2="106" marker-end="url(#arr-12)"/><line class="diagram-sage" x1="598" y1="144" x2="553" y2="54" marker-end="url(#arr-12)"/><line class="diagram-muted" x1="598" y1="144" x2="504" y2="228" marker-end="url(#arr-12)"/>
<text class="diagram-text" x="675" y="44" text-anchor="middle">定向：工具坐标系 R</text><text class="diagram-note" x="675" y="67" text-anchor="middle">三个独立转角</text>
<text class="diagram-note" x="737" y="103">x′</text><text class="diagram-note" x="542" y="48">y′</text><text class="diagram-note" x="485" y="246">z′</text>
<path class="diagram-muted" d="M398 145H490" marker-end="url(#arr-12)"/>
<text class="diagram-mono" x="446" y="131" text-anchor="middle">T=(p,R)</text>
</svg>
<figcaption>位姿图解（本教程绘）：左图的三根参考轴描述位置，右图的工具坐标架描述定向。三维正交轴在纸面的投影不必垂直。</figcaption>
</figure>

::: intuition 为什么是 3 + 3
想象放置一个**带把手的杯子**：杯口圆心在哪里，由三个坐标确定；杯口朝向确定后，杯把仍可绕杯口轴旋转。只描述杯口法向会漏掉这最后一个角度。若要求杯口始终朝上，而杯把朝向可调，任务就剩三个位置变量和一个转角，四轴 SCARA 可能满足要求；还须检查目标位姿是否可达。
:::

<a id="sec-1.2.2"></a>

## 1.2.2 五种构形：从关节序列到工作空间

下面比较臂的前三个关节。先看 **R/P 类型与顺序，再看关节轴的几何关系**，由此推想位置工作空间。类型序列不能单独决定构形：球型和 SCARA 都可写成 RRP，区别在轴是否相交、平行。常见四轴 SCARA 的整体序列是 **RRPR**，最后一轴用于工具回转。

| 构形 | 臂的关节序列 | 工作空间 | 特点 | 典型应用（驱动） |
|:--|:--|:--|:--|:--|
| **笛卡儿** | PPP，三条移动轴互相垂直 | 长方体 | 理想模型中每个关节直接改变一个坐标，等量关节误差不会被构形放大；实际精度仍受导轨误差、标定和载荷影响。龙门架可从上方作业 | 材料抓取、装配（电机，偶尔气动） |
| **圆柱型** | RPP，回转轴竖直，两移动轴分别沿径向与竖直方向 | 空心圆柱体的一部分 | 用回转、径向伸缩与升降定位；同一角度误差在较大半径处通常造成更大的横向位置误差 | 搬运、向水平孔接近 |
| **球型** | RRP，两转轴相交且垂直，移动轴沿伸缩杆方向 | 中空球体的一部分 | 两转角改变伸缩方向，移动量改变径向距离；角度误差的末端影响随伸出长度变化 | 径向接近、机械加工 |
| **SCARA** | RRP，前三条轴平行 | 扁形回转体 | Selective Compliance Assembly Robot Arm，选择性顺从装配机械臂：常设计为竖直方向较刚、水平面内较顺从，适合竖直插装 | 小零件搬运、装配、包装 |
| **拟人型** | RRR，腰轴与肩轴垂直，肩肘轴平行 | 近似球形的一部分 | 类似人的腰、肩、肘；相对占地可覆盖较大空间。关节误差对末端的影响随构形变化，不能由全转动关节直接断言所有任务都更灵活 | 搬运、焊接等（电机） |

表中的工作空间是典型几何轮廓，刚度与精度描述也是结构趋势，不能代替具体机型在给定载荷、速度和构形下的性能。关节限位、连杆偏置和碰撞会裁去部分区域；工具伸出后，其参考点的可达集合也会改变。

原书引用的 IFR **截至 2005 年**数据为：拟人型 59%、笛卡儿型 20%、圆柱型 12%、SCARA 型 8%。这组历史数据不代表当前市场；四项取整后合计 99%，不能据此推断球型恰好占 1%。学习重点是轴几何与运动能力，无需把比例当成构形判据。

<figure>
<svg class="figure-svg" viewBox="0 0 920 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-12w-title fig-12w-desc">
<title id="fig-12w-title">五种构形的工作空间形状轮廓</title>
<desc id="fig-12w-desc">五个并排小图依次画出笛卡儿型、圆柱型、球型、SCARA、拟人型的工作空间轮廓：长方体、空心圆柱体、中空球体、扁形回转体与近似球形的一部分。</desc>
<defs>
<marker id="w12-none" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<!-- 1 笛卡儿：长方体 -->
<g transform="translate(92 150)">
<rect class="diagram-node" x="-48" y="-34" width="96" height="68" rx="4"/>
<path class="diagram-muted" d="M-48 -34 L-28 -54 H70 L72 -52 V14 L48 36" fill="none"/>
<path class="diagram-muted" d="M70 -54 L48 -34" fill="none"/>
<text class="diagram-note" y="86" text-anchor="middle">长方体</text>
<text class="diagram-note" y="104" text-anchor="middle">三移动关节</text>
</g>
<!-- 2 圆柱型：空心圆柱 -->
<g transform="translate(276 150)">
<path class="diagram-node" d="M-42 -32 V28 A42 14 0 0 0 42 28 V-32" fill="none" stroke-width="2"/>
<ellipse class="diagram-node" cx="0" cy="-32" rx="42" ry="14"/>
<ellipse class="diagram-muted" cx="0" cy="-32" rx="22" ry="8" fill="none" stroke-dasharray="4 3"/>
<text class="diagram-note" y="86" text-anchor="middle">空心圆柱体的一部分</text>
<text class="diagram-note" y="104" text-anchor="middle">转 + 伸缩</text>
</g>
<!-- 3 球型：中空球 -->
<g transform="translate(460 150)">
<circle class="diagram-node" cx="0" cy="0" r="46"/>
<ellipse class="diagram-muted" cx="0" cy="0" rx="46" ry="13" fill="none" stroke-dasharray="4 3"/>
<circle class="diagram-muted" cx="0" cy="0" r="24" fill="none" stroke-dasharray="4 3"/>
<text class="diagram-note" y="86" text-anchor="middle">中空球体的一部分</text>
<text class="diagram-note" y="104" text-anchor="middle">两转 + 径向伸缩</text>
</g>
<!-- 4 SCARA：扁形回转体 -->
<g transform="translate(644 150)">
<path class="diagram-node" d="M-56 -4 A56 20 0 0 0 56 -4 A46 15 0 0 1 38 8 A44 16 0 0 1 -38 8 A46 15 0 0 1 -56 -4 Z"/>
<ellipse class="diagram-muted" cx="0" cy="10" rx="38" ry="12" fill="none" stroke-dasharray="4 3"/>
<text class="diagram-note" y="66" text-anchor="middle">扁形回转体</text>
<text class="diagram-note" y="84" text-anchor="middle">三轴平行</text>
</g>
<!-- 5 拟人：近似球（缺角） -->
<g transform="translate(828 150)">
<path class="diagram-node" d="M46 0 A46 46 0 1 1 23 -40 L12 -20 A46 46 0 0 0 46 0 Z"/>
<path class="diagram-muted" d="M23 -40 L12 -20" fill="none" stroke-dasharray="4 3"/>
<text class="diagram-note" y="86" text-anchor="middle">近似球形的一部分</text>
<text class="diagram-note" y="104" text-anchor="middle">全转动关节</text>
</g>
</svg>
<figcaption>工作空间图解（本教程绘）：五种典型位置工作空间的理想轮廓；虚线表示内侧或隐藏轮廓。读图时须配合表中的轴几何，图形不是具体机械手的精确可达边界。</figcaption>
</figure>

::: ex 例 1.2.B · 从关节序列识别构形（新增） {#ex-1.2.B}
逐个辨认：(a) RRR，腰轴与肩轴垂直、肩肘轴平行 → **拟人型**；(b) PPP，三条移动轴互相垂直 → **笛卡儿型**；(c) RRP，前两条转轴相交且垂直、末轴沿杆伸缩 → **球型**；(d) RPP，回转轴竖直，两条移动轴分别沿径向和竖直方向 → **圆柱型**；(e) RRP，三条轴全平行 → **SCARA 的臂**。识别时先写类型，再说明轴几何，最后推想工作空间。
:::

<a id="sec-1.2.3"></a>

## 1.2.3 闭链、并联与球形腕

载荷会使结构发生弹性变形；满足任务精度需要足够的刚度。闭链是改善承载与刚度的一条设计途径，是否采用还取决于连杆尺寸、材料、传动和任务：

- **平行四边形臂**：在拟人型的肩、肘关节之间引入平行四边形几何（原书图 1.8），闭链显著提高刚度——[1.4.2](sec1-4.md#sec-1.4.2) 的 ABB IRB 4400 即此结构；
- **并联构形**：多条支链同时连接基座与末端平台（原书图 1.9），支链通过基座与平台共同形成回路；每条支链本身可以是开链。此类设计常以较受限的工作空间换取较高刚度或加速度，但性能仍须按具体机构判断；原书的 ABB IRB 340 FlexPicker 是四轴实例；
- **混联**：并联臂 + 串联链的组合（原书图 1.10），适合竖直方向需要很大力量的操纵任务。

若臂已经选定，而腕需独立调整三维朝向，它通常需要三个独立转动变量。常见实现之一是三轴共点的**球形腕**，它为逆运动学提供了方便的分步求解结构：

::: def 定义 1.2.3 · 球形腕（spherical wrist） {#def-1.2.3}
**球形腕**由三个转动关节构成，三条转动轴交于同一点 **W（腕心）**。固定臂后，转动腕关节不改变 W 的位置。注意：安装在腕外的工具点 P 通常有偏置，转腕时 P 可以移动。
:::

::: thm 原理 1.2.C · 球形腕解耦原理（新增整理） {#thm-1.2.C}
给定工具点的目标位置 $\boldsymbol p_P$ 与目标朝向 $R$，若工具点沿末端 $z$ 轴距腕心 $d$，先算

$$\boldsymbol p_W=\boldsymbol p_P-dR\boldsymbol e_z,\qquad \boldsymbol e_z=(0,0,1)^{\mathrm T}.$$

$R\boldsymbol e_z$ 是工具 $z$ 轴在基坐标系中的单位方向。先用臂关节把 W 送到 $\boldsymbol p_W$；选定一组臂解后，记臂端坐标系 A 在基坐标系 0 中的朝向为 $R_{0A}$，再求腕相对臂端的旋转 $R_{AW}=R_{0A}^{\mathrm T}R$。**末端绝对朝向同时受臂与腕影响**，第二步补足的是相对朝向。[2.12.3](../ch02/sec2-12.md#sec-2.12.3) 将推导具体逆解。

分步法仍须检查臂的可达性、关节限位和腕的奇异位形。三轴不共点时，通常不能直接使用这套腕心分解，但某些机构仍有解析逆解。
:::

::: ex 例 1.2.D · 同一工具点，不同腕心 {#ex-1.2.D}
设工具偏置 $d=0.10\ \mathrm m$，目标点 $\boldsymbol p_P=(0.60,0.20,0.40)\ \mathrm m$。工具轴朝上时，$R\boldsymbol e_z=(0,0,1)$，得到 $\boldsymbol p_W=(0.60,0.20,0.30)\ \mathrm m$。若改为朝 $+x$ 方向，则腕心应改到 $(0.50,0.20,0.40)\ \mathrm m$。即使工具点位置不变，目标朝向改变也会改变应求的腕心目标。
:::

::: intuition 动手实验 · 先预测，再用读数核对
十一种模型可供比较，先完成下面三项。读数中的红点 P 是末端参考点，蓝点 W 是腕心；末端三根坐标轴显示朝向。演示只计算几何运动，不验证刚度、速度或真实工作空间边界。

1. **笛卡儿型**：重置后每次只将一个移动关节增加 $0.10\ \mathrm m$。预测哪个坐标改变，再核对 P 的读数。三个关节分别改变 $z,y,x$；其他两个坐标应保持不变。
2. **球型与 SCARA**：两者的臂都是 RRP。观察两条转轴是否相交或平行；在 SCARA 中只转第四轴，P 是否移动、工具坐标轴是否转动？用这两个观察区分关节类型、轴几何和工具朝向。
3. **拟人臂 + 球形腕**：重置后分别改变第 4、5、6 轴，记录 W、P 与工具 $x$ 轴方向。预测哪个点始终不动；不要只看红点猜答案。

<div class="lab" data-lab="zoo3d"></div>

<details id="sec12-lab-answers"><summary>完成后展开：核对观察与解释</summary>

笛卡儿模型默认 P 为 $(-0.250,0.220,0.180)\ \mathrm m$。将 $d_1$ 改为 $0.28$，仅 $z$ 增加 $0.10$；重置后把 $d_2$ 改为 $0.32$，仅 $y$ 增加 $0.10$；再重置，把 $d_3$ 改为 $-0.15$，仅 $x$ 增加 $0.10$。

SCARA 的前三根轴平行，第四轴沿工具中心轴回转；本模型没有横向工具偏置，因此只转第四轴时 P 不动，工具坐标轴会转。球型的前两根转轴不平行，第二轴能改变伸缩方向。

球形腕的 W 始终不变，且本模型 $|P-W|=0.140\ \mathrm m$。第 4、5 轴一般会使偏置工具点 P 绕 W 运动；第 6 轴沿本模型的工具轴自转，所以 P 可不动而工具 $x$ 轴改变方向。点不动并不代表完整位姿不变。

没有脚本时，可用上面的坐标例与例 1.2.D 完成纸笔核对。

</details>
:::

<a id="sec-1.2.4"></a>

## 1.2.4 末端执行器与选型约束

末端执行器按任务来选定：**抓取物料**用与对象形状、尺寸相匹配的钳子（gripper）；**加工与装配**则用专门工具——喷灯、喷枪、铣刀、钻头、螺丝刀等。当需要更强的操作性与灵活性时，还可采用**多触点机器人手**（Barrett Hand、SCHUNK 仿人手 Anthropomorphic Hand，见 [1.4.2](sec1-4.md#sec-1.4.2)）。

::: method 选型五约束（新增整理）
机械手的多功能性与灵活性，**并不意味着其结构足以完成给定任务**。机器人选型实际受限于应用条件，约束清单如下：
1. **工作空间**：每个工位的位置和工具朝向能否同时实现？还要考虑运动路径与碰撞；
2. **有效负载**：对象与工具的总质量、重心位置、力矩和惯量是否满足要求？不能只加重量；
3. **定位精度 / 重复精度**：前者关心实际到达位姿相对指令的偏差，后者关心重复执行同一指令的散布；两者都须对照任务公差；
4. **动态性能**：在所需载荷与轨迹下能否满足节拍、速度和加速度？静态能承受不等于动态也能满足；
5. **安装方式**：地面、龙门、天花板或滑轨是否适合工位？这是在原书四类性能约束上增加的布置检查项，见 [1.4.2](sec1-4.md#sec-1.4.2)。
:::

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先写出下面几条，再展开核对。写不出来，就说明这一节还没真正「拿走」。

1. 完整位姿需要几个独立变量？拆成「定位」与「定向」各几个。
2. 旋转矩阵有 9 个数，为什么只剩 3 个独立量？写出约束。
3. 五种构形的「臂的关节序列」与工作空间形状，各说一句。
4. 球形腕转动时哪个点不动？工具有偏置时，怎样由目标位姿计算腕心？

::: sol 核对

定位 3（$x,y,z$）+ 定向 3 = 6；一般位姿任务至少需要 6 个独立关节变量。

正交条件 $R^{\mathrm T}R=I$ 给 6 个约束、$\det R=1$ 再排掉镜像，故 $9-6=3$。

笛卡儿（移移移 → 长方体）、圆柱型（转移移 → 空心圆柱）、球型（转转移 → 中空球）、SCARA（转转移、三轴平行 → 扁形回转体）、拟人型（转转转 → 近似球的一部分）。

球腕转动不改变腕心 W。若工具沿自身 $z$ 轴偏置 $d$，先算 $\boldsymbol p_W=\boldsymbol p_P-dR\boldsymbol e_z$，求臂解后再求相对腕姿态。P 可以随腕转动而移动；三轴共点也不保证目标一定可达或不存在奇点。

:::

:::

## 1.2 小结与常见错误

- **自由度**数独立变量；任务要求决定需要控制几个量，六轴只是一般完整位姿控制的必要条件。
- **构形**须同时看关节类型与轴几何，工作空间轮廓只提供初步判断。
- **球形腕**固定的是腕心 W；从目标工具位姿先算 W，再求臂解和相对腕姿态。

::: think 常见错误清单 · 自查四条
1. 数自由度时把关节数直接相加——开链可直接计数，闭链必须先列出独立约束（定义 1.2.2）；
2. 把 SCARA 当「三轴拟人」——SCARA 三轴**平行**，拟人型后两轴平行、首轴垂直，工作空间与柔性完全不同；
3. 以为自由度越多越好——冗余带来灵活性，也带来更高的控制与标定成本（原理 1.2.A 推论二）；
4. 认为笛卡儿型实际精度处处一致——理想模型中关节误差直接对应坐标误差，实际性能仍受结构、标定、载荷和温度等因素影响。
:::

下一节转向[移动机器人](sec1-3.md)：它的位形可以有三个变量，但轮子约束可能让它不能立即沿三个方向运动，届时要区分位形自由度与瞬时运动能力。
