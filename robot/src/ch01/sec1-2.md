# 1.2 机器人机械手：构形与自由度

本节回答三个问题：**机械手由什么构成、自由度怎么数？五种经典构形各有什么脾气？腕和末端执行器解决什么问题？**机械结构是机器人的关键特征，而本节梳理的「构形谱系」正是[第二章运动学](../ch02/overview.md)（五种构形的正逆运动学将逐一推导）的物理预备。

<aside class="lesson-brief" aria-label="1.2 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p><a href="sec1-1.html#sec-1.1.3">1.1.3</a> 的机械系统概念；空间直角坐标 / 圆柱坐标 / 球坐标三种描述方式（高中数学）。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>连杆—关节—自由度—工作空间的概念链；开链与闭链的拓扑区分；五种构形的对比表；球形腕的解耦原理。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>给定任一构形（或实物照片）能说出关节序列、自由度数、工作空间形状与两三项典型应用；能解释为什么 3D 任意定位定向任务需要 6 个自由度。</p></div>
</aside>

<a id="sec-1.2.1"></a>

## 1.2.1 运动链、关节与自由度

::: def 定义 1.2.1 · 机械手的组成与运动链 {#def-1.2.1}
**机器人机械手**由一系列**刚性构件（连杆）**通过**关节**联结而成，其典型结构是三段式：**臂（arm）**保证可移动性（定位），**腕（wrist）**提供灵活性（定向），**末端执行器（end-effector）**负责执行任务。从拓扑上看：若连杆链两端之间只有一个连接序列，称为**开式运动链**；若存在连杆序列构成回路，则称为**闭式运动链**。
:::

::: def 定义 1.2.2 · 两类关节与自由度 {#def-1.2.2}
相邻连杆之间的连接，通过**移动关节**（prismatic，棱柱关节——实现相对平移）或**转动关节**（revolute，旋转关节——实现相对转动）实现；其中转动关节结构紧凑、可靠，工程上最为常见。对无额外约束的**开式链**，每个单自由度关节贡献一个独立变量；而**闭式链**存在回路约束，不能直接把关节数当作自由度，必须先扣除独立约束的数目。末端执行器能到达的区域称为**工作空间（workspace）**，其形状与容积取决于结构形式及关节限位。
:::

::: thm 原理 1.2.A · 完整位姿的六变量（新增整理） {#thm-1.2.A}
在三维空间中完成**一般的**「任意定位 + 任意定向」任务，任务空间有 **6 个独立变量**：3 个用于目标点的**定位**（$x,y,z$），另 3 个用于目标坐标系的**定向**。因此，机械手要在一般位形附近独立调节完整位姿，至少需要 6 个独立关节变量。推论一：自由度少于 6 时，只有当任务本身降低了姿态要求，才可能「够用」；推论二：**若系统自由度多于任务变量数，则机械手是冗余（redundant）的**——冗余可用来避障、优化姿态（对照 [1.4.2](sec1-4.md#sec-1.4.2) 的七轴 LWR）。
:::

完整位姿可以写为

$$T=(\boldsymbol p,R),\qquad \boldsymbol p\in\mathbb R^3,\quad R\in SO(3).$$

其中位置向量 $\boldsymbol p$ 有 3 个独立分量；旋转矩阵 $R$ 虽然写成 9 个数，却受正交条件 $R^TR=I$ 和 $\det R=1$ 约束，实际只剩 3 个独立量（[2.2.1](../ch02/sec2-2.md#sec-2.2.1) 将推导）。于是 $\dim T=3+3=6$——这正是「3 + 3」的数学来源，而不是需要死记的轴数。

<figure>
<svg class="figure-svg" viewBox="0 0 920 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-12-title fig-12-desc">
<title id="fig-12-title">刚体完整位姿的六个独立变量</title>
<desc id="fig-12-desc">左侧用世界坐标系定位工具中心点，右侧在工具中心点展示三个姿态轴，说明完整位姿由三维位置和三维姿态组成。</desc>
<defs>
<marker id="arr-12" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<line class="diagram-axis" x1="80" y1="240" x2="330" y2="240" marker-end="url(#arr-12)"/><line class="diagram-axis" x1="80" y1="240" x2="80" y2="54" marker-end="url(#arr-12)"/>
<line class="diagram-muted" x1="80" y1="240" x2="254" y2="116"/>
<circle class="diagram-fill-accent" cx="254" cy="116" r="8"/><line class="diagram-accent" x1="80" y1="240" x2="247" y2="121" marker-end="url(#arr-12)"/>
<text class="diagram-text" x="168" y="70" text-anchor="middle">定位：位置向量 p</text><text class="diagram-note" x="168" y="93" text-anchor="middle">三个独立坐标 x, y, z</text>
<text class="diagram-note" x="339" y="255">x</text><text class="diagram-note" x="67" y="50">z</text><text class="diagram-mono" x="194" y="173">p</text>
<rect class="diagram-node" x="523" y="83" width="150" height="122" rx="5" transform="rotate(-18 598 144)"/>
<circle class="diagram-fill-sage" cx="598" cy="144" r="7"/>
<line class="diagram-accent" x1="598" y1="144" x2="728" y2="106" marker-end="url(#arr-12)"/><line class="diagram-sage" x1="598" y1="144" x2="553" y2="54" marker-end="url(#arr-12)"/><line class="diagram-muted" x1="598" y1="144" x2="642" y2="232" marker-end="url(#arr-12)"/>
<text class="diagram-text" x="675" y="44" text-anchor="middle">定向：工具坐标系 R</text><text class="diagram-note" x="675" y="67" text-anchor="middle">三个独立转角</text>
<text class="diagram-note" x="737" y="103">x′</text><text class="diagram-note" x="542" y="48">y′</text><text class="diagram-note" x="648" y="247">z′</text>
<path class="diagram-muted" d="M398 145H490" marker-end="url(#arr-12)"/>
<text class="diagram-mono" x="446" y="131" text-anchor="middle">T=(p,R)</text>
</svg>
<figcaption>图 1.2　完整位姿不是“六根轴”的口号：工具中心的位置 p 有 3 个变量，工具坐标系的定向 R 有 3 个独立变量。</figcaption>
</figure>

::: intuition 为什么是 3 + 3
把「放一个茶杯」拆开：杯口圆心放在哪里是**定位**（三个数），杯口朝哪个方向是**定向**（三个数）。若任务要求杯口始终竖直，定向只剩绕竖直轴的转角；此时 4 轴 SCARA 就可能足够。反过来，若要任意抓取、焊接或加工，通常需要完整的 6 变量位姿。这就是工业机械手常见「3 关节臂 + 3 关节腕」的原因（原书 IFR 统计中拟人型占 59%）。
:::

<a id="sec-1.2.2"></a>

## 1.2.2 五种构形：从关节序列到工作空间

按**从基关节开始的臂的类型与关节顺序**，机械手分为五种经典构形。判别时只需看两点：**前三个关节（臂）的类型序列 + 工作空间的几何形状**：

| 构形 | 臂的关节序列 | 工作空间 | 特点 | 典型应用（驱动） |
|:--|:--|:--|:--|:--|
| **笛卡儿** | 移动 + 移动 + 移动（三轴垂直） | 长方体 | 每个自由度对应一个笛卡儿变量；刚性好、精度处处一致；灵活性差，需侧面接近目标；龙门架（gantry）变体可自顶向下操作大体积大重量对象 | 材料抓取、装配（电机，偶尔气动） |
| **圆柱型** | 转动 + 移动 + 移动 | 空心圆柱体的一部分 | 良好机械刚度；水平动作能力提高、腕定位精度有所降低；水平移动关节适合向水平孔接近 | 平稳运送大型目标（液压驱动更合适） |
| **球型** | 转动 + 转动 + 移动 | 中空球体的一部分 | 机械刚性比前两种差、结构更复杂；径向操作能力强、腕定位精度降低；可加底座操作地面目标 | 机械加工（电机） |
| **SCARA** | 转动 + 转动 + 移动（三轴平行） | 扁形回转体 | Selective Compliance Assembly Robot Arm：竖直方向刚、水平面内顺从，适合插装等竖直装配；腕与首关节距离增大使精度略降 | 小零件搬运、装配、包装（电机） |
| **拟人型** | 转动 + 转动 + 转动（首轴垂直，肩肘轴平行） | 近似球形的一部分 | 结构与人类胳膊相似（肩关节、肘关节）；**最灵活**（全转动关节），但自由度与笛卡儿变量失去对应、腕定位精度随位置变化；相对于自身占地（encumbrance），工作空间容积较大 | 应用范围最广的工业构形（电机） |

按 IFR 报告（截至 2005 年）：全世界已安装机械手中**拟人型 59%、笛卡儿型 20%、圆柱型 12%、SCARA 型 8%**（合计 99%，其余为球型等构形）。从这组占比可以看出，拟人型在工业界占据绝对主导。

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
<figcaption>图 1.3　五种构形的工作空间轮廓（示意，虚线为内边界）。「由关节序列想象工作空间形状」是构形识别的核心技能：三移动 → 长方体；一转两移 → 空心圆柱；两转一移 → 中空球；三轴平行 → 扁形回转体；全转动 → 近似球。</figcaption>
</figure>

::: ex 例 1.2.B · 从关节序列识别构形（新增） {#ex-1.2.B}
逐个辨认下面的关节序列：(a) 某机械手前三关节依次为「转动—转动—转动」，第一关节轴与其余两轴垂直、后两轴平行 → **拟人型**（联想：腰—肩—肘）；(b) 「移动—移动—移动」三轴互相垂直 → **笛卡儿型**（每个关节管一个坐标，像三维打印机）；(b′) 「转动—转动—移动」且两条转轴相交于一角 → **球型**（腰—肩两转定方向、伸缩杆沿径向探出）；(c) 「转动—移动—移动」→ **圆柱型**（先转一个角度，再沿半径与竖直方向伸缩）；(d) 三轴全平行的「转动—转动—移动」→ **SCARA**（像按图钉：水平定位靠两个转轴，竖直下压靠移动关节）。识别口诀：**看臂的关节序列与工作空间形状，腕先放一边**。
:::

<a id="sec-1.2.3"></a>

## 1.2.3 闭链、并联与球形腕

当任务需要**较大有效负载**时，机械结构必须具有更高的刚度才能保证定位精度，此时就要借助**闭式运动链**：

- **平行四边形臂**：在拟人型的肩、肘关节之间引入平行四边形几何（原书图 1.8），闭链显著提高刚度——[1.4.2](sec1-4.md#sec-1.4.2) 的 ABB IRB 4400 即此结构；
- **并联构形**：多条运动链同时连接基座与末端执行器（原书图 1.9），基本优势是**很高的结构刚性**、可达较高操作速度，代价是**工作空间被缩减**——ABB IRB 340 FlexPicker 四轴并联即属此类；
- **混联**：并联臂 + 串联链的组合（原书图 1.10），适合竖直方向需要很大力量的操纵任务。

腕的黄金标准是**球形腕**。先要弄清一个「为什么恰好是三个」：要在三维空间中**任意定向**末端执行器，姿态本身就有 3 个自由度（[2.2.1](../ch02/sec2-2.md#sec-2.2.1) 的账本：$SO(3)$ 只剩 3 个独立参数），所以腕**至少需要 3 个转动自由度**；而工业上最常用的实现，正是三轴交于一点：

::: def 定义 1.2.3 · 球形腕（spherical wrist） {#def-1.2.3}
**球形腕**由三个转动关节构成，且**三条转动轴交于一点**（原书图 1.11）。它的关键特征是实现了末端执行器**定位与定向之间的解耦**：臂负责把交点（腕心）送到指定位置，腕负责确定末端执行器的方向。若不采用球形腕，定位与定向相互**耦合**，协调臂与腕动作的复杂度随之增加；另一方面，机械上不用球形腕（三轴不共点）的腕结构实现更简单——这正是「解耦收益 vs 结构复杂度」的一处工程权衡。
:::

::: thm 原理 1.2.C · 球形腕解耦原理（新增整理） {#thm-1.2.C}
腕心是三条腕轴的交点，**腕的任何转动都不改变腕心位置**——因此「把腕心送到哪里」完全由臂决定，「末端朝向哪里」完全由腕决定，两个子问题可**分别设计 / 求解**。工程推论：这使得带球形腕的六轴拟人臂（如 COMAU Smart NS、Fanuc M-16iB，见 [1.4.2](sec1-4.md#sec-1.4.2)）的逆运动学可以分两步求解（[2.12.3](../ch02/sec2-12.md#sec-2.12.3) 将严格推导）；代价是腕结构必须紧凑，机械设计复杂度上升。
:::

<a id="sec-1.2.4"></a>

## 1.2.4 末端执行器与选型约束

末端执行器按任务来选定：**抓取物料**用与对象形状、尺寸相匹配的钳子（gripper）；**加工与装配**则用专门工具——喷灯、喷枪、铣刀、钻头、螺丝刀等。当需要更强的操作性与灵活性时，还可采用**多触点机器人手**（Barrett Hand、SCHUNK 仿人手 Anthropomorphic Hand，见 [1.4.2](sec1-4.md#sec-1.4.2)）。

::: method 选型五约束（新增整理）
机械手的多功能性与灵活性，**并不意味着其结构足以完成给定任务**。机器人选型实际受限于应用条件，约束清单如下：
1. **工作空间**的维数与形状（能否覆盖所有工位？）；
2. **最大有效负载**（对象 + 末端执行器重量）；
3. **定位精度 / 重复精度**（对照任务公差）；
4. **动态性能**（节拍与速度要求）；
5. 安装方式（地面 / 龙门 / 天花板 / 滑轨——对照 [1.4.2](sec1-4.md#sec-1.4.2) 各实例）。
:::

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先写出下面几条，再展开核对。写不出来，就说明这一节还没真正「拿走」。

1. 完整位姿需要几个独立变量？拆成「定位」与「定向」各几个。
2. 旋转矩阵有 9 个数，为什么只剩 3 个独立量？写出约束。
3. 五种构形的「臂的关节序列」与工作空间形状，各说一句。
4. 球形腕凭什么能让逆运动学解耦？代价是什么？

::: sol 核对

定位 3（$x,y,z$）+ 定向 3 = 6；一般位姿任务至少需要 6 个独立关节变量。

正交条件 $R^{\mathrm T}R=I$ 给 6 个约束、$\det R=1$ 再排掉镜像，故 $9-6=3$。

笛卡儿（移移移 → 长方体）、圆柱型（转移移 → 空心圆柱）、球型（转转移 → 中空球）、SCARA（转转移、三轴平行 → 扁形回转体）、拟人型（转转转 → 近似球的一部分）。

球腕三轴交于腕心，腕的转动**不改变腕心位置**，于是「臂定位、腕定向」可分别求解；代价是腕结构必须紧凑、机械设计复杂度上升。

:::

:::

## 1.2 小结与常见错误

- **一条主线**：连杆 + 关节 → 自由度（开链可直接计数，闭链须扣约束）→ 完整位姿 3 定位 + 3 定向 → 五种构形按「臂的关节序列」分家 → 球形腕把定位与定向解耦 → 选型五约束落地。
- **两个数字**：6（一般完整位姿的变量数，不是每项任务的硬门槛）；59 / 20 / 12 / 8（IFR 2005 拟人 / 笛卡儿 / 圆柱 / SCARA 占比）。
- **一个原理**：解耦（原理 1.2.C）——把一个问题拆成可独立求解的两个子问题，[2.12.3](../ch02/sec2-12.md#sec-2.12.3) 的解耦逆解将再次用到。

::: think 常见错误清单 · 自查四条
1. 数自由度时把关节数直接相加——开链可直接计数，闭链必须先列出独立约束（定义 1.2.2）；
2. 把 SCARA 当「三轴拟人」——SCARA 三轴**平行**，拟人型后两轴平行、首轴垂直，工作空间与柔性完全不同；
3. 以为自由度越多越好——冗余带来灵活性，也带来更高的控制与标定成本（原理 1.2.A 推论二）；
4. 认为精度只取决于控制器——构形决定精度分布（拟人型精度随位置变化、笛卡儿型处处一致），**结构先于算法**。
:::
