# 2.8 正运动学与 Denavit–Hartenberg 法

旋转、合成、角度表示、齐次变换——这些积木已经备齐，本节就来回答运动学的第一个主问题：**给定关节变量，求末端位姿**。两连杆的情形靠几何直觉就能算出来（原书例 2.4）；可一旦面对真实机械手，我们需要的是一套系统化、参数最少的算法，这就是 **Denavit–Hartenberg（DH）法**。本节对应录播 0:39:43–1:13:00（其中 0:47:16–0:52:47 为课间）。

<aside class="lesson-brief" aria-label="2.8 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>齐次变换及其连乘（[@thm-2.7.A]）；开链 / 关节自由度语言（[@def-1.2.1]、[@def-1.2.2]）。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>连杆 / 关节编号约定；正运动学方程 $T_e^b(q)$（式 2.48）与末端执行器坐标系 $(\boldsymbol n_e,\boldsymbol s_e,\boldsymbol a_e)$；看守模型（系挂在哪根杆、看哪个关节）；DH 建系四规则、不唯一情形与拟人臂四步例解；四参数 $(a_i,\alpha_i,d_i,\vartheta_i)$「3 常 1 变」；$A_i^{i-1}$ 的两步分解与逐列验算（式 2.52）；DH 十步操作流程。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>拿到任意开链结构图能独立建出 DH 坐标系、填出 4n 参数表并写出 $T_n^0(q)$；能背出看守模型（$z_{i-1}$ = 关节 $i$ 的轴）；能说出每条建系规则「为哪个参数服务」（[@method-2.8.map]）。</p></div>
</aside>

<a id="sec-2.8.1"></a>

## 2.8.1 开链：编号约定、正运动学方程与递归

### 连杆—关节编号

::: def 定义 2.8.1 · 开链机械手的编号 {#def-2.8.1}
开链机械手由 $n+1$ 个连杆（刚体）经 $n$ 个关节串联而成：**连杆 0 固定在基座上**，末端连杆上装有末端执行器；**关节 $i$ 则把连杆 $i-1$ 与连杆 $i$ 连接起来**。关节只有两类（原书图 2.12）：**转动型**（revolute，符号 →圆柱铰）和**移动型**（prismatic，符号 →方块滑轨）。
:::

![课堂幻灯片 · 约37:43：连杆编号与两类关节的常规表示](../assets/ch02/joints-classes.jpg)

录播 0:40:51 老师用讲台打比方：杆 0 就是基座（「讲台就是固定的」），从它开始依次长出关节 1、杆 1……直到关节 $n$、杆 $n$。换句话说，关节 $i$ 的前一根是杆 $i-1$，后一根是杆 $i$；于是 $n$ 自由度开链 = $n$ 个关节 + $n+1$ 根杆。

### 正运动学问题与末端执行器坐标系

::: def 定义 2.8.2 · 正运动学方程 {#def-2.8.2}
**正运动学**（direct kinematics）回答的是：已知关节变量向量 $\boldsymbol q=[q_1\ \cdots\ q_n]^T$（转动关节 $q_i=\vartheta_i$，移动关节 $q_i=d_i$），求末端执行器的位姿。取基坐标系 $O_b\text{-}x_by_bz_b$ 与末端执行器坐标系，这一位姿可以写成齐次变换（原书式 2.48）

$$T_e^b(\boldsymbol q)=\begin{bmatrix}\boldsymbol n_e(\boldsymbol q) & \boldsymbol s_e(\boldsymbol q) & \boldsymbol a_e(\boldsymbol q) & \boldsymbol p_e(\boldsymbol q)\\ 0&0&0&1\end{bmatrix},$$

式中 $\boldsymbol p_e$ 是末端坐标系原点的位置；$\boldsymbol a_e$ 为**接近向量**（approach，指向抓取 / 工作方向），$\boldsymbol s_e$ 落在钳口滑动平面内、且与 $\boldsymbol a_e$ 垂直；$\boldsymbol n_e=\boldsymbol s_e\times\boldsymbol a_e$ 则保证 $(\boldsymbol n_e,\boldsymbol s_e,\boldsymbol a_e)$ 构成右手系。
:::

![课堂幻灯片 · 约42:29：正运动学方程与末端执行器坐标系](../assets/ch02/ex24-two-link.jpg)

（图中同时给出了原书例 2.4：两连杆平面臂用三角法直接写出 $T_e^b$，其中 $s_{12}=\sin(\vartheta_1+\vartheta_2)$，其余依此类推。）

::: ex 例 2.4（原书）· 几何法与它的天花板 {#ex-book-2.4}
对两连杆平面臂（关节角 $\vartheta_1,\vartheta_2$，杆长 $a_1,a_2$），末端位置可以看成两段投影之和：先是 $a_1$ 的投影，再加上 $a_2$ 在「已抬起 $\vartheta_1$ 的方向」上的投影（录播 0:44:00–0:44:57，老师逐项指认「$\boldsymbol n_e$ 垂直于臂平面所以是 $[0,0,1]$、$\boldsymbol p_e$ 就是 $[a_1c_1+a_2c_{12},\ a_1s_1+a_2s_{12},\ 0]^T$」），于是得

$$T_e^b=\begin{bmatrix}0 & s_{12} & c_{12} & a_1c_1+a_2c_{12}\\ 0 & -c_{12} & s_{12} & a_1s_1+a_2s_{12}\\ 1&0&0&0\\ 0&0&0&1\end{bmatrix}.$$

**几何法的天花板**（原书 + 录播 0:45:03：「如果多了之后……那就不好算了」）：这类算法依赖变量的选取和几何直觉，结构一复杂、关节一多就不再直观。
:::

### 开链的递归结构

::: thm 原理 2.8.A · 正运动学的连乘（原书式 2.50–2.51） {#thm-2.8.A}
从连杆 0 到连杆 $n$，给每一根杆都固连一个坐标系，则坐标系 $n$ 相对坐标系 $0$ 的位姿为

$$T_n^0(\boldsymbol q)=A_1^0(q_1)\,A_2^1(q_2)\cdots A_n^{n-1}(q_n),$$

其中每个 $A_i^{i-1}(q_i)$ 都只是**单个关节变量**的函数。至于末端执行器的位姿，只需再串接两个（典型情况下的）常值变换：

$$T_e^b(\boldsymbol q)=T_b^0\,T_n^0(\boldsymbol q)\,T_e^n .$$
:::

![课堂幻灯片 · 约46:11：开链递归与 T_n^0 连乘](../assets/ch02/open-chain-recursive.jpg)

结构决定算法：先描述相邻两杆的相对关系，再沿链递归合成（原书）。于是问题只剩一个——**相邻坐标系究竟怎么建才算规范**？

<a id="sec-2.8.2"></a>

## 2.8.2 Denavit–Hartenberg 法：动机与建系规则

::: intuition 为什么需要 DH：6 → 4 的账（录播 0:46:41–0:47:16、0:53:22–0:53:59）
随意建两个坐标系、再去描述它们的相对位姿，需要 $3+3=6$ 个量（原点 3 个 + 姿态 3 个）。但相邻两坐标系**被同一根刚性杆钉死**，彼此并不独立——「你可能直观想象可能有 5 个参数」；DH 建系法则证明，只要 **4 个参数**就足以完整描述任意相邻关系，「参数是最少，而且最方便、很直观」。省下来的那部分自由度，全部来自建系规则对坐标系的「对齐」。
:::

::: method 先把「系到底挂在哪」说透：看守模型（本编补充） {#method-2.8.watch}
四条规则里最容易卡住读者的，是「$z_i$ 沿**关节 $i+1$** 的轴」这个**编号错位**——下标 $i$ 配不上关节 $i$，对着图找半天才发觉配错了对。这里把挂靠关系一次说透，之后再看四条规则就只是操作细节。

DH 约定只有一句话：**杆 $i$ 上固连坐标系 $i$，其 $z$ 轴放在关节 $i+1$ 的轴线上**。把下标换个方向读，更顺口——

**坐标系 $i-1$ 是「看守关节 $i$」的坐标系：它的 $z$ 轴 $z_{i-1}$ 与关节 $i$ 的轴线重合。**

| 要找的东西 | 去哪里找 |
|:--|:--|
| 关节 $i$ 的轴线 | 就是 $z_{i-1}$（看守它的那根轴） |
| 杆 $i$ 的固连系 | 系 $i$（原点 $o_i$ 落在关节 $i+1$ 的轴线上） |
| 关节 $i$ 的运动 | 绕 / 沿 $z_{i-1}$：转 $\vartheta_i$ 或移 $d_i$ |
| $A_i^{i-1}$ 里的变量 | 只有关节 $i$ 的那一个（「3 常 1 变」的出处） |

**为什么这样挂**：$z_{i-1}$ 与关节 $i$ 的轴对齐后，关节 $i$ 转动或伸缩时，杆 $i$（连同系 $i$）相对杆 $i-1$（连同系 $i-1$）的运动就**纯粹是绕 / 沿 $z_{i-1}$**，一个参数即可装进矩阵；若 $z$ 轴随手乱放，描述同一段运动就要好几个参数——「6 压到 4」的第一笔节省正来自这里。

**一句话防混**：本教程与原书用**标准 DH**（$z_i$ 沿关节 $i+1$）；Craig《机器人学导论》用**改进 DH**（$z_i$ 沿关节 $i$）。两套各自自洽，混用必错（[勘误 E2.4](errata.md#errata-2.4)）。
:::

::: method DH 建系四规则（原书 §2.8.2，录播 0:54:05–0:58:00） {#method-2.8.dh}
约定：**轴 $i$** 指关节 $i$ 的轴线。操作永远从「定轴」开始——先把所有轴线画成贯穿直线，看清它们**两两之间的关系**（相交？平行？还是异面？），再逐系落位。给系 $i$ 落位时依次回答三问（$z$ 放哪、原点放哪、$x$ 指哪），$y$ 自动补齐：

1. **$z_i$ 放哪**：沿**轴 $i+1$**（看守模型：系 $i-1$ 才是看守关节 $i$ 的那个系）；
2. **原点 $o_i$ 放哪**：取 $z_{i-1}$ 与 $z_i$ 的**公垂线**和 $z_i$ 的交点（垂足 $o_i'$ 则是公垂线与 $z_{i-1}$ 的交点）；
3. **$x_i$ 指哪**：沿公垂线，**由关节 $i$ 指向关节 $i+1$**；
4. **$y_i$**：右手系补齐（不引入参数）。

两类特殊轴对的处理（建系时最常遇到，动作先背下来）：

- **平行轴对**（下文例解④的轴2、轴3）：公垂线有无穷多条，**取穿过前一原点 $o_{i-1}$ 的那一条** $\Rightarrow d_i=0$；
- **相交轴对**（例解③的轴1、轴2）：公垂线退化为交点本身 $\Rightarrow a_i=0$，$x_i$ 取同时垂直于两轴的任一方向（选定后 $\alpha_i$ 的正负也就定了）。
:::

![课堂幻灯片 · 约54:40：DH 建系规则与连杆坐标系](../assets/ch02/dh-rules.jpg)

规则是抽象的，必须在一台真实结构上走一遍才能落地。下面选一台**三维**的三转动拟人臂（肩回转 + 肩俯仰 + 肘俯仰）做例解——平面两连杆太退化（$\alpha_i$、$d_i$ 全为 0，公垂线从头到尾没真正「干过活」），而拟人臂同时含有「相交轴对」与「平行轴对」，四条规则全部用得上。

::: method 例解 · 在拟人臂上四步建系（本编补充，逐格对照下图） {#method-2.8.anthro}
**结构**：关节1轴线**竖直**（过肩点），关节2轴线**水平**（过肩点），关节3轴线**与关节2平行**（过肘点）。记住这三句话，参数表其实已经定了一半。

**① 定轴线（格一）。** 先不建任何坐标系，把三根轴线画成贯穿直线，然后问：它们两两什么关系？——轴1 与轴2 **相交**于肩点；轴2 与轴3 **平行**。后面每个参数都从这两句话里读出来。

**② 放系 0（格二）。** $z_0$ 沿关节1轴线（竖直；沿轴的正方向任选，定下不再变）；$o_0$ 本可取在轴线上任一点，按「能零则零」取在轴1与轴2的**交点**（肩心），垂足 $o_1'=o_0$，下一行 $d_1$ 直接为 0；$x_0$ 水平任选（习惯取零位时上臂的指向）。系 0 从此固连在基座上。

**③ 放系 1（格三）。** $z_1$ 沿关节2轴线。轴1、轴2 相交 $\Rightarrow a_1=0$；$x_1$ 必须同时垂直于两条轴 $\Rightarrow$ 沿水平（臂平面内垂直于两轴的那个方向），指向零位上臂。**判 $\alpha_1$ 的动作**：把 $x_1$ 当螺丝柄，看从 $z_0$ 拧向 $z_1$ 是不是右手旋进方向——是，转角 $+\pi/2$，故 $\alpha_1=\pi/2$（符号错误大多栽在这里，务必动手比划）。$y_1$ 右手补齐后**恰好竖直向上、与 $z_0$ 同向**——这正是「两轴扭了 90°」的直接可视化。

**④ 放系 2、3（格四）。** $z_2$ 沿关节3轴线，与 $z_1$ **平行** $\Rightarrow\alpha_2=0$；这对平行轴的公垂线**就是上臂本身** $\Rightarrow a_2=$ 上臂长，$x_2$ 沿上臂指向肘部，$o_2$ 取垂足（肘点，穿过 $o_1$ 的那条公垂线）$\Rightarrow d_2=0$。系 3 同理：$z_3$ 取与 $z_2$ 平行（末端系约定），公垂线 $=$ 前臂 $\Rightarrow a_3=$ 前臂长，$d_3=0$。剩下的 $\vartheta_1,\vartheta_2,\vartheta_3$ 就是三个关节变量——分别是 $x_0$ 到 $x_1$ 绕 $z_0$、$x_1$ 到 $x_2$ 绕 $z_1$、$x_2$ 到 $x_3$ 绕 $z_2$ 的转角。

填表时逐格「问一句」，每个数都有来历：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ | 填这格时问自己 |
|:--:|:--:|:--:|:--:|:--:|:--|
| 1 | 0 | $\pi/2$ | 0 | $\vartheta_1$ | 轴1、轴2 相交 $\Rightarrow a_1=0$；从 $z_0$ 绕 $x_1$ 转到 $z_1$ 是 $+\pi/2$ |
| 2 | $a_2$ | 0 | 0 | $\vartheta_2$ | 轴2、轴3 平行 $\Rightarrow\alpha_2=0$；公垂线 $=$ 上臂 $\Rightarrow a_2$ |
| 3 | $a_3$ | 0 | 0 | $\vartheta_3$ | $z_2\parallel z_3\Rightarrow\alpha_3=0$；公垂线 $=$ 前臂 $\Rightarrow a_3$ |

这张表与 [2.9.4](sec2-9.md#sec-2.9.4) 逐字相同——[2.9](sec2-9.md) 的九张参数表，都是这条四步流水线在不同骨架上的重复。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 692" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-dhsteps-t fig-dhsteps-d">
<title id="fig-dhsteps-t">拟人臂 DH 建系四步分镜</title>
<desc id="fig-dhsteps-d">四个等轴测分镜展示拟人机械臂的 DH 建系过程：格一只画机械臂与三根关节轴线；格二在肩点加坐标系0，z0 沿竖直的关节1轴；格三加坐标系1，标出两轴相交故 a1=0、z0 绕 x1 转到 z1 为 90 度；格四在肘与腕加坐标系2、3，红色标出公垂线即上臂与前臂，长度即 a2、a3。</desc>
<defs>
<marker id="fdh3-m" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--muted)"/></marker>
<marker id="fdh3-b" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-blue)"/></marker>
<marker id="fdh3-g" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-green)"/></marker>
<marker id="fdh3-y" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-gold)"/></marker>
<marker id="fdh3-p" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-purple)"/></marker>
</defs>
<!-- 格一 · 定轴线 -->
<text class="diagram-text" x="236" y="38" text-anchor="middle">① 定轴线：关节1 竖直，关节2、3 平行</text>
<line x1="131" y1="248" x2="131" y2="235" stroke="var(--line-strong)" stroke-width="7" stroke-linecap="round"/>
<line x1="131" y1="252" x2="131" y2="110" stroke="var(--muted)" stroke-width="1.4" stroke-dasharray="5 4" marker-end="url(#fdh3-m)"/>
<line x1="107" y1="223" x2="154" y2="134" stroke="var(--muted)" stroke-width="1.4" stroke-dasharray="5 4" marker-end="url(#fdh3-m)"/>
<line x1="251" y1="177" x2="298" y2="89" stroke="var(--muted)" stroke-width="1.4" stroke-dasharray="5 4" marker-end="url(#fdh3-m)"/>
<text class="diagram-note" x="139" y="114">关节1轴（竖直）</text>
<text class="diagram-note" x="162" y="132">关节2轴</text>
<text class="diagram-note" x="302" y="80">关节3轴</text>
<line x1="131" y1="179" x2="275" y2="133" stroke="var(--accent)" stroke-width="6" stroke-linecap="round"/>
<line x1="275" y1="133" x2="299" y2="256" stroke="var(--accent)" stroke-width="5" stroke-linecap="round"/>
<circle cx="131" cy="179" r="8" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<circle cx="275" cy="133" r="7" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<circle cx="299" cy="256" r="4.5" fill="var(--accent)"/>
<text class="diagram-note" x="118" y="170" text-anchor="end">肩</text>
<text class="diagram-note" x="284" y="128">肘</text>
<text class="diagram-note" x="308" y="264">腕</text>
<!-- 格二 · 放系0 -->
<text class="diagram-text" x="688" y="38" text-anchor="middle">② 放系 0：z<tspan class="sb">0</tspan> 沿关节1轴，原点取在两轴交点</text>
<line x1="583" y1="248" x2="583" y2="235" stroke="var(--line-strong)" stroke-width="7" stroke-linecap="round"/>
<line x1="583" y1="252" x2="583" y2="130" stroke="var(--muted)" stroke-width="1.4" stroke-dasharray="5 4" marker-end="url(#fdh3-m)"/>
<line x1="559" y1="223" x2="606" y2="134" stroke="var(--muted)" stroke-width="1.4" stroke-dasharray="5 4" marker-end="url(#fdh3-m)"/>
<line x1="703" y1="177" x2="750" y2="89" stroke="var(--muted)" stroke-width="1.4" stroke-dasharray="5 4" marker-end="url(#fdh3-m)"/>
<line x1="583" y1="179" x2="727" y2="133" stroke="var(--accent)" stroke-width="6" stroke-linecap="round"/>
<line x1="727" y1="133" x2="751" y2="256" stroke="var(--accent)" stroke-width="5" stroke-linecap="round"/>
<circle cx="583" cy="179" r="8" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<circle cx="727" cy="133" r="7" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<line x1="583" y1="179" x2="649" y2="190" stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#fdh3-b)"/>
<line x1="583" y1="179" x2="562" y2="217" stroke="var(--fig-green)" stroke-width="2.2" marker-end="url(#fdh3-g)"/>
<line x1="583" y1="179" x2="583" y2="122" stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#fdh3-y)"/>
<text class="diagram-text" fill="var(--fig-blue)" x="657" y="198">x<tspan class="sb">0</tspan></text>
<text class="diagram-text" fill="var(--fig-green)" x="552" y="228" text-anchor="end">y<tspan class="sb">0</tspan></text>
<text class="diagram-text" fill="var(--fig-gold)" x="571" y="112" text-anchor="middle">z<tspan class="sb">0</tspan></text>
<text class="diagram-note" x="571" y="174" text-anchor="end">o<tspan class="sb">0</tspan></text>
<!-- 格三 · 放系1（轴1与轴2相交） -->
<text class="diagram-text" x="236" y="368" text-anchor="middle">③ 放系 1：z<tspan class="sb">1</tspan> 沿关节2轴；两轴相交，a<tspan class="sb">1</tspan> = 0</text>
<line x1="131" y1="568" x2="131" y2="555" stroke="var(--line-strong)" stroke-width="7" stroke-linecap="round"/>
<line x1="131" y1="572" x2="131" y2="430" stroke="var(--ink-2)" stroke-width="1.9" stroke-dasharray="7 5" marker-end="url(#fdh3-m)"/>
<line x1="107" y1="543" x2="154" y2="454" stroke="var(--ink-2)" stroke-width="1.9" stroke-dasharray="7 5" marker-end="url(#fdh3-m)"/>
<line x1="251" y1="497" x2="298" y2="409" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="4 4"/>
<line x1="131" y1="499" x2="275" y2="453" stroke="var(--accent)" stroke-width="6" stroke-linecap="round"/>
<line x1="275" y1="453" x2="299" y2="576" stroke="var(--accent)" stroke-width="5" stroke-linecap="round"/>
<circle cx="131" cy="499" r="8" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<circle cx="275" cy="453" r="7" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<line x1="131" y1="499" x2="197" y2="510" stroke="var(--muted)" stroke-width="1.1" marker-end="url(#fdh3-m)"/>
<line x1="131" y1="499" x2="110" y2="537" stroke="var(--muted)" stroke-width="1.1" marker-end="url(#fdh3-m)"/>
<line x1="131" y1="499" x2="197" y2="510" stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#fdh3-b)"/>
<line x1="131" y1="499" x2="131" y2="435" stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#fdh3-g)"/>
<line x1="131" y1="499" x2="151" y2="460" stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#fdh3-y)"/>
<text class="diagram-text" fill="var(--fig-blue)" x="203" y="520">x<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--fig-green)" x="139" y="434">y<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--fig-gold)" x="158" y="452">z<tspan class="sb">1</tspan></text>
<text class="diagram-note" x="119" y="493" text-anchor="end">o<tspan class="sb">1</tspan></text>
<text class="diagram-note" x="119" y="422" text-anchor="end">z<tspan class="sb">0</tspan></text>
<text class="diagram-text" fill="var(--fig-red)" x="140" y="494">a<tspan class="sb">1</tspan> = 0</text>
<path d="M 131 462 L 133 458 L 135 456 L 137 454 L 139 454 L 140 455 L 141 457 L 143 460 L 143 463 L 144 468 L 144 472" fill="none" stroke="var(--fig-purple)" stroke-width="1.8" marker-end="url(#fdh3-p)"/>
<text class="diagram-text" fill="var(--fig-purple)" x="152" y="478">α<tspan class="sb">1</tspan> = 90°</text>
<!-- 格四 · 放系2、3（平行轴对） -->
<text class="diagram-text" x="688" y="368" text-anchor="middle">④ 放系 2、3：平行轴对的公垂线 = 连杆本身</text>
<line x1="583" y1="568" x2="583" y2="555" stroke="var(--line-strong)" stroke-width="7" stroke-linecap="round"/>
<line x1="583" y1="572" x2="583" y2="438" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="4 4"/>
<line x1="559" y1="543" x2="606" y2="454" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="4 4"/>
<line x1="703" y1="497" x2="750" y2="409" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="4 4"/>
<line x1="583" y1="499" x2="727" y2="453" stroke="var(--accent)" stroke-width="6" stroke-linecap="round"/>
<line x1="727" y1="453" x2="751" y2="576" stroke="var(--accent)" stroke-width="5" stroke-linecap="round"/>
<circle cx="583" cy="499" r="8" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<circle cx="727" cy="453" r="7" fill="var(--paper)" stroke="var(--line-strong)" stroke-width="1.6"/>
<line x1="583" y1="499" x2="649" y2="510" stroke="var(--muted)" stroke-width="1.1" marker-end="url(#fdh3-m)"/>
<line x1="583" y1="499" x2="562" y2="537" stroke="var(--muted)" stroke-width="1.1" marker-end="url(#fdh3-m)"/>
<line x1="583" y1="499" x2="603" y2="460" stroke="var(--muted)" stroke-width="1.1" marker-end="url(#fdh3-m)"/>
<text class="diagram-note" x="610" y="447">z<tspan class="sb">1</tspan></text>
<line x1="727" y1="453" x2="784" y2="435" stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#fdh3-b)"/>
<line x1="727" y1="453" x2="693" y2="398" stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#fdh3-g)"/>
<line x1="727" y1="453" x2="747" y2="415" stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#fdh3-y)"/>
<text class="diagram-text" fill="var(--fig-blue)" x="790" y="441">x<tspan class="sb">2</tspan></text>
<text class="diagram-text" fill="var(--fig-green)" x="685" y="396" text-anchor="end">y<tspan class="sb">2</tspan></text>
<text class="diagram-text" fill="var(--fig-gold)" x="753" y="412">z<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="715" y="472" text-anchor="end">o<tspan class="sb">2</tspan></text>
<line x1="751" y1="576" x2="763" y2="634" stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#fdh3-b)"/>
<line x1="751" y1="576" x2="817" y2="578" stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#fdh3-g)"/>
<line x1="751" y1="576" x2="771" y2="538" stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#fdh3-y)"/>
<text class="diagram-text" fill="var(--fig-blue)" x="769" y="644">x<tspan class="sb">3</tspan></text>
<text class="diagram-text" fill="var(--fig-green)" x="825" y="586">y<tspan class="sb">3</tspan></text>
<text class="diagram-text" fill="var(--fig-gold)" x="777" y="534">z<tspan class="sb">3</tspan></text>
<text class="diagram-note" x="741" y="570" text-anchor="end">o<tspan class="sb">3</tspan></text>
<line x1="583" y1="527" x2="727" y2="481" stroke="var(--fig-red)" stroke-width="1.8"/>
<line x1="756" y1="454" x2="781" y2="577" stroke="var(--fig-red)" stroke-width="1.8"/>
<text class="diagram-text" fill="var(--fig-red)" x="655" y="544" text-anchor="middle">公垂线，长 = a<tspan class="sb">2</tspan></text>
<text class="diagram-text" fill="var(--fig-red)" x="789" y="523">a<tspan class="sb">3</tspan></text>
</svg>
<figcaption>拟人臂的 DH 建系全过程（本教程绘，等轴测投影）。格一**先画轴线**：轴线的两两关系（相交 / 平行）已决定参数表的全部取值；格二放系 0（$z_0$ = 关节1轴，原点取在两轴交点，$d_1=0$）；格三放系 1（相交轴对：$a_1=0$，从 $z_0$ 绕 $x_1$ 转到 $z_1$ 为 $+90^\circ$，故 $\alpha_1=\pi/2$；注意 $y_1$ 恰与 $z_0$ 同向）；格四放系 2、3（平行轴对：公垂线就是连杆本身，$a_2$、$a_3$ 即杆长）。拖动下方实验的角度滑杆，可以看到这套坐标系如何随关节运动。</figcaption>
</figure>

::: intuition 动手实验 · 把四个坐标系亲手拖出来
上面四格是快照，这个实验让它动起来。拖动 $\vartheta_1,\vartheta_2,\vartheta_3$ 与视角方位角，重点观察三件事：其一，关节1转动时**整条臂平面带着系 1、2、3 一起绕 $z_0$ 转**，而系 0 纹丝不动——每个关节只「指挥」自己下游的坐标系；其二，无论姿态怎么变，$\alpha_1=\pi/2$、$a_2$ 等几何量**始终不变**——「3 常 1 变」一眼可见；其三，转到侧面视角时，$z_1$、$z_2$ 两根平行轴与公垂线（上臂）的立体关系一目了然——这正是静态图最难画清的部分。

<div class="lab" data-lab="dhframes"></div>
:::

::: note 不唯一的五种情形（原书；录播 0:58:06–0:59:21 老师逐条点名） {#note-2.8.dh-cases}
① 系 0：$o_0$、$x_0$ 均可任选（前面没有公垂线），工程上尽量与基坐标系重合；② 系 $n$：后面没有关节 $n+1$，$z_n$ 不唯一，典型做法是取与 $z_{n-1}$ 同向；③ 相邻两轴**平行**：公垂线不唯一（例解④已给出标准动作：取穿过 $o_{i-1}$ 的那条）；④ 相邻两轴**相交**：无公垂线，$x_i$ 方向任意（例解③）；⑤ 关节 $i$ 为**移动型**：$z_{i-1}$ 方向任意。**不唯一 ≠ 随便**：所有自由度都按「能零则零」（[@method-2.8.zero]）去用，同一结构的不同合法选系给出的 $T_n^0$ 完全相同。
:::

同一套流程再拿**平面两连杆**做一遍快检（见下图）：三个 $z$ 轴全部指出纸面、互相平行。正是「平行」这一个几何事实，一次性解释了参数表里成片的 $0$ 与仅有的两个变量——建议先遮住右表，照着 [@method-2.8.anthro] 的四步自己走一遍，再对答案。

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-dhw-t fig-dhw-d">
<title id="fig-dhw-t">两连杆平面臂的 DH 建系实例</title>
<desc id="fig-dhw-d">左图俯视：基座与肘部两个关节加末端共三个坐标系，z 轴全部垂直纸面向外（圆点符号），x 轴沿连杆方向，相邻 x 的夹角即关节变量 ϑ。右图给出两行 DH 参数表：a 列为杆长常数，ϑ 列为变量，α 与 d 全为零。</desc>
<defs>
<marker id="fdh-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="fdh-b" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-blue)"/></marker>
<marker id="fdh-n" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-green)"/></marker>
<marker id="fdh-g" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-gold)"/></marker>
</defs>
<text class="diagram-text" x="240" y="30" text-anchor="middle">建系结果（俯视，z 全部指出纸面 ⊙）</text>
<text class="diagram-text" x="710" y="30" text-anchor="middle">DH 参数表：每个 0 都有来历</text>
<g stroke="var(--line-strong)" stroke-width="1.2" marker-end="url(#fdh-m)">
<line x1="240" y1="262" x2="330" y2="262"/>
<line x1="240" y1="262" x2="240" y2="192"/>
</g>
<text class="diagram-note" x="336" y="266">x</text>
<text class="diagram-note" x="234" y="186" text-anchor="end">y</text>
<line stroke="var(--accent)" stroke-width="5" x1="240" y1="262" x2="317.1" y2="170.1"/>
<line stroke="var(--accent)" stroke-width="5" x1="317.1" y1="170.1" x2="279.1" y2="88.5"/>
<line x1="317.1" y1="170.1" x2="342.8" y2="139.5" stroke="var(--line-strong)" stroke-width="1" stroke-dasharray="4 4"/>
<path d="M 280 262 A 40 40 0 0 0 265.7 231.4" fill="none" stroke="var(--fig-gold)" stroke-width="1.8" marker-end="url(#fdh-g)"/>
<text class="diagram-text" fill="var(--fig-gold)" x="292" y="252">ϑ<tspan class="sb">1</tspan></text>
<path d="M 339 144 A 34 34 0 0 0 302.7 139.3" fill="none" stroke="var(--fig-gold)" stroke-width="1.8" marker-end="url(#fdh-g)"/>
<text class="diagram-text" fill="var(--fig-gold)" x="346" y="140">ϑ<tspan class="sb">2</tspan></text>
<g stroke-width="2.2">
<line stroke="var(--fig-blue)" marker-end="url(#fdh-b)" x1="240" y1="262" x2="275.4" y2="219.9"/>
<line stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#fdh-n)" x1="240" y1="262" x2="197.9" y2="226.6"/>
<line stroke="var(--fig-blue)" marker-end="url(#fdh-b)" x1="317.1" y1="170.1" x2="293.8" y2="120.3"/>
<line stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#fdh-n)" x1="317.1" y1="170.1" x2="267.3" y2="193.4"/>
<line stroke="var(--fig-blue)" marker-end="url(#fdh-b)" x1="279.1" y1="88.5" x2="257.9" y2="51.3"/>
<line stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#fdh-n)" x1="279.1" y1="88.5" x2="240.7" y2="106.4"/>
</g>
<g>
<circle cx="240" cy="262" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="240" cy="262" r="2.2" fill="var(--ink-2)"/>
<circle cx="317.1" cy="170.1" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="317.1" cy="170.1" r="2.2" fill="var(--ink-2)"/>
<circle cx="279.1" cy="88.5" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="279.1" cy="88.5" r="2.2" fill="var(--ink-2)"/>
</g>
<text class="diagram-text" fill="var(--fig-blue)" x="282" y="216">x<tspan class="sb">0</tspan></text>
<text class="diagram-text" fill="var(--fig-blue)" x="288" y="116">x<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--fig-blue)" x="250" y="48" text-anchor="end">x<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="224" y="280" text-anchor="end">o<tspan class="sb">0</tspan></text>
<text class="diagram-note" x="330" y="180">o<tspan class="sb">1</tspan></text>
<text class="diagram-note" x="292" y="84">o<tspan class="sb">2</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="300" y="234">a<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="262" y="142" text-anchor="end">a<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="300" y="322" text-anchor="middle">z 全平行 → α = 0；原点同面 → d = 0；x 沿连杆方向 → a 恰为杆长</text>
<g fill="none" stroke="var(--line)">
<rect x="540" y="60" width="330" height="135"/>
<line x1="540" y1="105" x2="870" y2="105"/><line x1="540" y1="150" x2="870" y2="150"/><line x1="615" y1="60" x2="615" y2="210"/><line x1="690" y1="60" x2="690" y2="210"/><line x1="765" y1="60" x2="765" y2="210"/><line x1="840" y1="60" x2="840" y2="210"/>
</g>
<text class="diagram-text" x="577" y="89" text-anchor="middle">连杆 i</text>
<text class="diagram-text" x="652" y="89" text-anchor="middle">a</text>
<text class="diagram-text" x="727" y="89" text-anchor="middle">α</text>
<text class="diagram-text" x="802" y="89" text-anchor="middle">d</text>
<text class="diagram-text" x="855" y="89" text-anchor="middle">ϑ</text>
<text class="diagram-text" x="577" y="134" text-anchor="middle">1</text>
<text class="diagram-text" fill="var(--fig-blue)" x="652" y="134" text-anchor="middle">a<tspan class="sb">1</tspan></text>
<text class="diagram-note" x="727" y="134" text-anchor="middle">0</text>
<text class="diagram-note" x="802" y="134" text-anchor="middle">0</text>
<text class="diagram-text" fill="var(--fig-gold)" x="855" y="134" text-anchor="middle">ϑ<tspan class="sb">1</tspan></text>
<text class="diagram-text" x="577" y="179" text-anchor="middle">2</text>
<text class="diagram-text" fill="var(--fig-blue)" x="652" y="179" text-anchor="middle">a<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="727" y="179" text-anchor="middle">0</text>
<text class="diagram-note" x="802" y="179" text-anchor="middle">0</text>
<text class="diagram-text" fill="var(--fig-gold)" x="855" y="179" text-anchor="middle">ϑ<tspan class="sb">2</tspan></text>
<circle fill="var(--fig-gold)" cx="556" cy="238" r="4"/><text class="diagram-note" x="566" y="243">变量（每行恰一个：z 规则决定）</text>
<circle fill="var(--fig-blue)" cx="556" cy="262" r="4"/><text class="diagram-note" x="566" y="267">常数（杆长 / 扭角：公垂线与两轴夹角）</text>
<circle fill="var(--muted)" cx="556" cy="286" r="4"/><text class="diagram-note" x="566" y="291">0（z 平行 → α=0；原点共面 → d=0）</text>
<text class="diagram-note" x="710" y="322" text-anchor="middle">参数选得好 = 让 0 尽量多；2.9 节全部算例照此办理</text>
</svg>
<figcaption>DH 建系的第一个完整实例（本教程绘）：俯视下三个 $z$ 轴全部指出纸面且互相平行，于是 $\alpha_i=0$；原点取在同一平面，$d_i=0$；$x_i$ 沿连杆方向，$a_i$ 恰为杆长；相邻 $x$ 轴的夹角就是仅有的两个变量 $\vartheta_1,\vartheta_2$。把左图的几何逐条「翻译」成右表——这就是 DH 法的全部动作；「让 0 尽量多」的选系原则见下文（[@method-2.8.zero]）。</figcaption>
</figure>

::: method 总原则：让参数尽量为零（录播 0:59:31–1:00:04，课堂提炼） {#method-2.8.zero}
凡是可自由选取之处，都「选择让参数尽量为零的方案」。道理很简单：参数本身是常数，选得好就能让一大批参数为 0，代入 $A$ 矩阵时「都是零的乘来乘去」，计算量骤减。2.9 节每个算例的参数表里成片的 0，正是这条原则的兑现。
:::

### DH 四参数与 $A_i^{i-1}$

![课堂幻灯片 · 约1:00:16：四参数定义（红字助记为课堂标注）](../assets/ch02/dh-params.jpg)

上面两例的轴线两两「相交 / 平行」，是教学里的乖巧情形；一般情形下相邻两轴**异面**（既不相交也不平行，工业臂的肩部偏置很常见），此时公垂线唯一。四个参数在这种一般位置下的几何定义如下图——例解里的每一步，都是这张图在特殊轴对上的退化版本：

<figure>
<svg class="figure-svg" viewBox="0 0 920 486" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-dh-t fig-dh-d">
<title id="fig-dh-t">DH 建系四规则与四参数的几何来源</title>
<desc id="fig-dh-d">左图画出相邻两根关节轴、公垂线、两个坐标系原点与 x 轴，并标出杆件长度 a 与关节距离 d；右图沿 x 轴方向看，说明扭角 α 是两轴的夹角。</desc>
<defs>
<marker id="ar-x" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="context-stroke"/></marker>
<marker id="ar-xs" markerHeight="8" markerWidth="8" orient="auto-start-reverse" refX="6" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="context-stroke"/></marker>
</defs>
<g font-family="var(--sans)">
<line class="diagram-axis" x1="170" x2="170" y1="80" y2="380"/>
<line class="diagram-axis" x1="450" x2="450" y1="115" y2="390"/>
<text class="diagram-text" text-anchor="middle" x="170" y="70">z<tspan class="sb">i−1</tspan></text>
<text class="diagram-text" text-anchor="middle" x="450" y="105">z<tspan class="sb">i</tspan></text>
<line stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#ar-x)" x1="170.0" x2="496.0" y1="175.0" y2="175.0"/>
<text class="diagram-text" fill="var(--fig-blue)" x="506" y="180">x<tspan class="sb">i</tspan></text>
<circle class="diagram-node" cx="170" cy="175" r="5"/>
<circle class="diagram-fill-accent" cx="450" cy="175" r="6"/>
<circle class="diagram-fill-accent" cx="170" cy="310" r="6"/>
<text class="diagram-note" text-anchor="end" x="158" y="172">o<tspan class="sb">i</tspan>′</text>
<text class="diagram-note" x="464" y="172">o<tspan class="sb">i</tspan></text>
<text class="diagram-note" text-anchor="end" x="158" y="316">o<tspan class="sb">i−1</tspan></text>
<line stroke="var(--fig-blue)" stroke-width="1.1" marker-end="url(#ar-x)" marker-start="url(#ar-xs)" x1="176.0" x2="444.0" y1="212.0" y2="212.0"/>
<text class="diagram-text" fill="var(--fig-blue)" text-anchor="middle" x="310" y="234">a<tspan class="sb">i</tspan> 杆件长度</text>
<line stroke="var(--fig-gold)" stroke-width="1.1" marker-end="url(#ar-x)" marker-start="url(#ar-xs)" x1="118.0" x2="118.0" y1="181.0" y2="304.0"/>
<text class="diagram-text" fill="var(--fig-gold)" text-anchor="end" x="108" y="246">d<tspan class="sb">i</tspan></text>
<text class="diagram-note" text-anchor="end" x="108" y="264">关节距离</text>
<text class="diagram-note" text-anchor="middle" x="310" y="404">z<tspan class="sb">i−1</tspan> 沿关节 i 的轴；z<tspan class="sb">i</tspan> 沿关节 i+1 的轴</text>
<text class="diagram-note" text-anchor="middle" x="310" y="426">x<tspan class="sb">i</tspan> 沿公垂线（由关节 i 指向关节 i+1）</text>
<line stroke="var(--line)" stroke-dasharray="3 5" x1="580" x2="580" y1="60" y2="440"/>
<line class="diagram-axis" x1="760.0" x2="760.0" y1="210.0" y2="102.0"/>
<line class="diagram-axis" x1="760.0" x2="826.5" y1="210.0" y2="124.9"/>
<circle class="diagram-fill-accent" cx="760" cy="210" r="6"/>
<path d="M 760 153.8 A 56.2 56.2 0 0 1 794.6 165.7" fill="none" stroke="var(--fig-green)" stroke-width="2"/>
<text class="diagram-text" fill="var(--fig-green)" x="790" y="143">α<tspan class="sb">i</tspan></text>
<text class="diagram-note" text-anchor="end" x="750" y="94">z<tspan class="sb">i−1</tspan></text>
<text class="diagram-note" x="836" y="121">z<tspan class="sb">i</tspan></text>
<text class="diagram-note" text-anchor="middle" x="760" y="254">沿 x<tspan class="sb">i</tspan> 方向看：两轴夹角即扭角 α<tspan class="sb">i</tspan></text>
<text class="diagram-note" text-anchor="middle" x="760" y="276">（绕 x<tspan class="sb">i</tspan> 逆时针为正）</text>
<text class="diagram-note" text-anchor="middle" x="760" y="404">转动关节：ϑ<tspan class="sb">i</tspan> 是变量</text>
<text class="diagram-note" text-anchor="middle" x="760" y="426">移动关节：d<tspan class="sb">i</tspan> 是变量；a<tspan class="sb">i</tspan>、α<tspan class="sb">i</tspan> 恒为常数</text>
</g></svg>
<figcaption>DH 建系四规则不是并列的口诀（本教程绘）：**每条规则各管一个参数**——$z$ 轴规则管变量（$\vartheta_i$ 或 $d_i$），公垂线规则管常数（$a_i$），两轴的方向关系管 $\alpha_i$，右手系补 $y_i$ 不引入参数。左图中 $o_i$ 取在公垂线与 $z_i$ 的交点、$x_i$ 沿公垂线——这两条决定了 $A_i^{i-1}$ 第 4 列的 $(a_ic_{\vartheta_i},\ a_is_{\vartheta_i},\ d_i)$。</figcaption>
</figure>

::: def 定义 2.8.3 · DH 参数 {#def-2.8.3}
建立连杆坐标系后，系 $i$ 相对系 $i-1$ 的位姿就由 4 个参数完全确定：

| 参数 | 名称（课堂助记） | 几何含义 | 属性 |
|:--|:--|:--|:--|
| $a_i$ | **杆件长度** | $o_i'$ 与 $o_i$ 间距离（公垂线长度，沿 $x_i$） | 恒为常数 |
| $d_i$ | **关节距离** | $o_i'$ 沿 $z_{i-1}$ 的坐标 | 移动关节时为变量 |
| $\alpha_i$ | **杆件扭角** | 轴 $z_{i-1}$ 与 $z_i$ 的夹角（绕 $x_i$ 逆时针为正） | 恒为常数 |
| $\vartheta_i$ | **关节转角** | 轴 $x_{i-1}$ 与 $x_i$ 的夹角（绕 $z_{i-1}$ 逆时针为正） | 转动关节时为变量 |

**3 常 1 变**：$a_i,\alpha_i$ 永远是常数（由杆的几何决定）；$d_i,\vartheta_i$ 中恰有一个是关节变量，统一记作 $q_i$（录播 1:04:31–1:05:04：「后面用的最多的是叫 Q……转动关节就是 $\vartheta$，移动关节就是 $d$」）。换言之，相邻两坐标系之间只需要一个量就能描述。
:::

::: method 规则 → 参数：每条建系规则「为谁服务」 {#method-2.8.map}
四条规则不是并列的口诀，而是**每条各管一个参数**——这既是「建系为什么这样建」的答案，也是填表时自查的依据：

| 规则 | 服务的参数 | 为什么恰好是它 |
|:--|:--|:--|
| $z_{i-1}$ 沿**关节 $i$** 的轴 | $\vartheta_i$、$d_i$（**变量**） | 关节 $i$ 的运动物理上就是「绕 / 沿自己的轴」；$z_{i-1}$ 与该轴重合后，这场运动在 $A_i^{i-1}$ 里恰好表现为绕 $z_{i-1}$ 的转角 $\vartheta_i$（旋转块）或沿 $z_{i-1}$ 的位移 $d_i$（第 4 列）——这就是「转动 $\vartheta$ 当变量、移动 $d$ 当变量」的全部出处 |
| 原点 $o_i$ 取在**公垂线**上、$x_i$ 沿公垂线 | $a_i$（**常数**） | 两根 $z$ 轴的**相对位置**被这段公垂线一锤定音：$a_i$ = 公垂线长，沿 $x_i$ 度量——第 4 列的 $(a_ic_{\vartheta_i},\ a_is_{\vartheta_i})$ 由此而来 |
| 同一对 $z$ 轴的方向关系 | $\alpha_i$（**常数**） | 两轴的**方向差**只剩绕公垂线 $x_i$ 的一个转角：$\alpha_i$ = 从 $z_{i-1}$ 绕 $x_i$ 转到 $z_i$——旋转块里「绕 $x$ 转 $\alpha$」那一块由此而来 |
| $y_i$ 右手系补齐 | 无 | 只保证 $R\in SO(3)$ 且唯一，不引入参数 |

一句话总结：**$z$ 轴规则管变量（$\vartheta,d$），公垂线规则管常数（$a,\alpha$）**。[2.9](sec2-9.md) 各参数表里成片的 $0$ 与 $\pm\pi/2$，全部来自这两条规则对齐之后的「自然归零 / 自然成直角」——不是巧合，而是设计。
:::

::: method $A_i^{i-1}$：从建系几何直接读出两步分解（原书式 2.52；录播 1:05:42–1:09:01） {#method-2.8.A}
建系规则不仅告诉我们坐标系放在哪，还把「从系 $i-1$ 走到系 $i$」的路线规定成了**四段各含一个参数的路程**。站在 $o_{i-1}$、以系 $i-1$ 的姿态起步，依次做四个动作（每个都绕 / 沿**当前**轴）：

1. **绕 $z_{i-1}$ 转 $\vartheta_i$**——把 $x$ 轴从 $x_{i-1}$ 方向转到公垂线方向 $x_i$（$\vartheta_i$ 的定义）；
2. **沿 $z_{i-1}$ 移 $d_i$**——原点落到垂足 $o_i'$（$d_i$ 的定义；与动作 1 都在 $z_{i-1}$ 上、互不干扰，可并成一步）；
3. **沿新 $x$（已对准 $x_i$）移 $a_i$**——原点从 $o_i'$ 走到新轴线上的 $o_i$（$a_i$ 的定义）；
4. **绕 $x_i$ 转 $\alpha_i$**——把 $z$ 轴从 $z_{i-1}$ 方向拧到 $z_i$ 方向（$\alpha_i$ 的定义）。

四段走完，恰好到达系 $i$；不多不少，每段恰好消费一个参数。按「当前轴右乘」（[@thm-2.3.A]）把这段路线记成矩阵，就得到原书的两步分解：

1. 动作 1+2 合并为**绕 $z_{i-1}$ 转 $\vartheta_i$、沿 $z_{i-1}$ 移 $d_i$** → 中间系 $i'$（原点 $o_i'$，$z$ 轴仍沿 $z_{i-1}$，$x$ 轴已对准 $x_i$）：

$$A_{i'}^{i-1}=\begin{bmatrix}c_{\vartheta_i} & -s_{\vartheta_i} & 0 & 0\\ s_{\vartheta_i} & c_{\vartheta_i} & 0 & 0\\ 0&0&1&d_i\\ 0&0&0&1\end{bmatrix}$$

2. 动作 3+4 合并为**沿 $x_{i'}$ 移 $a_i$、绕 $x_{i'}$ 转 $\alpha_i$** → 系 $i$：

$$A_i^{i'}=\begin{bmatrix}1&0&0&a_i\\ 0&c_{\alpha_i} & -s_{\alpha_i} & 0\\ 0&s_{\alpha_i} & c_{\alpha_i} & 0\\ 0&0&0&1\end{bmatrix}$$

**右乘**合成（先发生的在左边——[@thm-2.3.A]）：

$$A_i^{i-1}(q_i)=A_{i'}^{i-1}A_i^{i'}=\begin{bmatrix}
c_{\vartheta_i} & -s_{\vartheta_i}c_{\alpha_i} & s_{\vartheta_i}s_{\alpha_i} & a_ic_{\vartheta_i}\\
s_{\vartheta_i} & c_{\vartheta_i}c_{\alpha_i} & -c_{\vartheta_i}s_{\alpha_i} & a_is_{\vartheta_i}\\
0 & s_{\alpha_i} & c_{\alpha_i} & d_i\\
0&0&0&1
\end{bmatrix}$$
:::

::: proof 验算 · 逐列读回几何 + 两个退化自检（本编补充）
**第 4 列（位置）**：追踪原点的齐次坐标 $[0,0,0,1]^{\mathrm T}$ 在乘积下的像（矩阵作用在列向量上时**从最右因子往左读**，与上面建系时序互为镜像，正是 [@thm-2.3.A]/[@thm-2.3.B] 的左 / 右乘对偶）。绕 $x$ 转 $\alpha_i$ 不动原点 → 沿 $x$ 移 $a_i$ 得 $[a_i,0,0,1]^{\mathrm T}$ → 沿 $z$ 移 $d_i$ 得 $[a_i,0,d_i,1]^{\mathrm T}$ → 绕 $z$ 转 $\vartheta_i$ 只旋转前两个分量：

$$\boldsymbol p=\big[\,a_ic_{\vartheta_i}\ \ \ a_is_{\vartheta_i}\ \ \ d_i\,\big]^{\mathrm T}$$

$d_i$ 躺在转轴上原样保留；$a_i$ 的方向被 $\vartheta_i$ 旋转——第 4 列三个元素各自的来历，一目了然。

**第 3 行（姿态）**：$A_{i'}^{i-1}$ 的旋转块是 $xy$ 平面内的事，第 3 行为 $[0,0,1]$，作用在 $A_i^{i'}$ 上不动它的第 3 行；而 $A_i^{i'}$ 的第 3 行是 $[0,s_{\alpha_i},c_{\alpha_i}]$——故乘积第 3 行就是 $[0\ \ s_{\alpha_i}\ \ c_{\alpha_i}]$。其余两行由平面旋转 $R_z(\vartheta_i)$ 作用到 $R_x(\alpha_i)$ 的前两行得出，逐项乘开即得完整矩阵。

**自检一（退化为纯转动关节）**：令 $a_i=\alpha_i=d_i=0$（两轴相交且共原点，如例解③），$A_i^{i-1}$ 只剩 $\mathrm{Rot}_z(\vartheta_i)$——纯粹的「绕关节轴转 $\vartheta_i$」。
**自检二（退化为纯移动关节）**：令 $\vartheta_i=\alpha_i=a_i=0$，$A_i^{i-1}=\mathrm{Trans}_z(d_i)$（变量换成 $d_i$ 沿 $z_{i-1}$ 伸缩，如球形臂的第三关节）。
两个退化情形都对得上物理直觉，说明四个参数各就各位、没有放错地方。□
:::

![课堂幻灯片 · 约1:09:28：A_i^{i-1} 完整矩阵](../assets/ch02/dh-matrix.jpg)

这个矩阵值得默写：**第 4 列的 $a_ic_{\vartheta_i},\ a_is_{\vartheta_i},\ d_i$ 就是三个参数的「肉身」**（上一框已逐列验算），旋转块则是「绕 $z$ 转 $\vartheta$ $\oplus$ 绕 $x$ 转 $\alpha$」的复合。整条链的正运动学，无非是把各 $A_i^{i-1}$ 依次连乘（[@thm-2.8.A]）。

::: method DH 十步操作流程（原书） {#method-2.8.steps}
1. 给关节轴编号，定出 $z_0,\dots,z_{n-1}$ 的方向；
2. 选取系 0（$o_0$ 在轴 $z_0$ 上；可行时与基坐标系重合）；
3. 对 $i=1,\dots,n-1$ 逐个处理：把 $o_i$ 放到 $z_i$ 与公垂线的交点（平行轴 + 转动关节取 $d_i=0$；移动关节取机械参考点）；
4. 沿公垂线取 $x_i$（方向由关节 $i$ 指向关节 $i+1$）；
5. 右手系补 $y_i$；
6. 选取系 $n$（转动关节取 $z_n\parallel z_{n-1}$；移动关节 $z_n$ 任意；$x_n$ 按步骤 4）；
7. 列出 $4n$ 个参数的参数表；
8. 逐个算出 $A_i^{i-1}(q_i)$；
9. 连乘得到 $T_n^0(q)$；
10. 串接常值变换 $T_b^0,T_e^n$，得到 $T_e^b(q)$。
录播 1:11:13 的口诀：「编号、建系（能零则零）、列参数表、代入、连乘」——参数表写对，剩下的就是机械代入。
:::

::: note 计算方面（原书 §2.8 末）
正运动学的主要计算开销，来自 $A_i^{i-1}$ 连乘中**超越函数**（sin / cos）的求值；做因式化处理可以减少乘加次数（flops）。另外，末端坐标系的三个单位向量不必都从矩阵里读——第三个用叉积导出即可（$\boldsymbol n_e=\boldsymbol s_e\times\boldsymbol a_e$，见 [定义 2.8.2](#def-2.8.2)）。
:::

<a id="lab-2.8"></a>

::: intuition 动手实验 · 把 DH 表连乘成一条手臂
平面 3R 是 DH 法的最小实例：三个 $z$ 轴都指出纸面且互相平行（$\alpha_i=0$），原点共面（$d_i=0$），$x_i$ 沿连杆（$a_i=l_i$），于是 DH 表里只剩下三个变量 $\vartheta_1,\vartheta_2,\vartheta_3$。拖动它们，观察末端轨迹与闭式 $x=l_1c_1+l_2c_{12}+l_3c_{123}$ 如何同步变化——这就是 [@method-2.8.zero]「让 0 尽量多」带来的收益。

<div class="lab" data-lab="arm"></div>
:::

<a id="sec-2.8.3"></a>

## 2.8.3 闭链（教材补充 · 课程未授）

::: note 本节定位
录播 0:41:58 老师明确讲过「闭链我们不讲」，所以这一节属于教材补充（原书 §2.8.3），考试不作要求；但它是 [2.9.2](sec2-9.md#sec-2.9.2) 平行四边形臂与并联机构的建模基础，故存此备查。
:::

上面这套 DH 法利用的是**开链**的递归特性。面对含闭运动链的机械手，思路是把它**化归为开链**：

::: method 闭链的 DH 处理（原书 §2.8.3） {#method-2.8.closed}
设闭链有 $n+1$ 个连杆、关节数 $l>n$（于是闭环数 = $l-n$）。
1. **虚拟断开**：在某个非驱动关节处把闭环「剪开」（设为连接连杆 $j$ 与 $k$ 的关节 $j+1$），得到一个**树状开链**；连杆 $0\cdots i$ 位于两分支之前（公共段），连杆 $j+1\cdots n$ 则被排除；
2. **按 DH 建系**：对树上各分支分别建连杆坐标系（开链流程照用）；
3. **写约束**：断点两侧坐标系 $j$ 与 $k$ 必须满足原闭环的几何一致条件。当关节 $j+1$ 为**转动型**时约束为

$$\boldsymbol z_j^i(\boldsymbol q')=\boldsymbol z_k^i(\boldsymbol q''),\qquad
R_i^j(\boldsymbol q')\big(\boldsymbol p_j^i(\boldsymbol q')-\boldsymbol p_k^i(\boldsymbol q'')\big)=\begin{bmatrix}0&0&d_{jk}\end{bmatrix}^T$$

（$R_i^j=(R_j^i)^T$，把系 $i$ 中表达的向量投到系 $j$；原书式 2.55–2.57）——它说的就是「两 $z$ 轴共线 + 相对位置只剩沿轴向的固定偏移」。若关节 $j+1$ 为**移动型**，则 $d_{jk}$ 变为变量，位置约束只保留前两个分量，并追加方向约束 $\boldsymbol x_j^{iT}\boldsymbol x_k^i=\cos\vartheta_{jk}$（原书式 2.58–2.60）；两种情形下都**恰有 6 个约束方程**；
4. **求独立变量**：由这 6 个方程解出数目较少的独立关节变量——它们就是驱动关节的自然候选，链中其余关节（含断开关节）通常不作为驱动关节；
5. **连乘出正运动学**：$T_e^b(\boldsymbol q)=A_1^0A_2^1\cdots A_n^{n-1}$，链路闭合后，变换序列通常从坐标系 $j$ 重新开始（原书式 2.61）。
:::

::: note 何时能解出闭式约束
除结构简单的情形（如平面机构）外，约束方程**不保证**有闭合解；不过若机械手具有特殊几何构形，部分方程会变得不独立、独立方程数少于 6，求解反而更容易（原书）。
:::

<a id="sec-2.8"></a>

::: think 默写点 · 合上书再写（主动回忆）

不要翻正文与速查卡，先独立写出下面几条，再展开核对。写不出来，就说明这一节还没真正「拿走」。

1. 默写 $A_i^{i-1}(q_i)$ 的完整矩阵，并指出第 4 列各元素对应哪个参数。
2. 看守模型怎么说？——「关节 $i$ 的轴线」是哪根 $z$？杆 $i$ 固连哪个系？
3. DH 四规则各是什么？每条规则「为哪个参数服务」？平行轴对、相交轴对分别怎么处理？
4. 四个参数中哪两个永远是常数？变量怎么定？

::: sol 核对

$A_i^{i-1}$ 见[公式速查卡](../preface-formulas.md) B1。第 4 列 = $(a_ic_{\vartheta_i},\ a_is_{\vartheta_i},\ d_i,\ 1)^{\mathrm T}$——三个参数的「肉身」。

系 $i-1$ 看守关节 $i$：关节 $i$ 的轴线就是 $z_{i-1}$；杆 $i$ 固连系 $i$（原点在关节 $i+1$ 的轴上）。

$z_i$ 沿关节 $i+1$ 的轴（服务变量 $\vartheta_i,d_i$）；原点取公垂线交点、$x_i$ 沿公垂线（服务 $a_i$）；两 $z$ 轴的方向关系给 $\alpha_i$；$y_i$ 右手系补齐（不引入参数）。平行轴对取穿过 $o_{i-1}$ 的公垂线（$d_i=0$）；相交轴对公垂线退化（$a_i=0$）。

$a_i$（杆件长度）与 $\alpha_i$（杆件扭角）恒为常数；$d_i$ 与 $\vartheta_i$ 中恰有一个是变量，由**关节类型**决定（转动 $q_i=\vartheta_i$、移动 $q_i=d_i$）——这就是「3 常 1 变」。

:::

:::

## 2.8 小结与常见错误

- **一条流水线**：编号 → 建系（四规则 + 能零则零）→ 填 4n 参数表（3 常 1 变）→ 逐个写 $A_i^{i-1}$ → 连乘 $T_n^0$ → 串常值变换。相邻坐标系的 6 个自由度，被杆约束压缩到 4 个参数。
- **一个验证器**：填完表先扫一遍——转动关节那一行的 $d_i$ 应当是常数，移动关节那一行的 $\vartheta_i$ 应当是常数；谁在变量位置上摇摆，谁的关节类型就读错了。

::: think 常见错误清单 · 自查四条
1. 把 $z_i$ 配错了关节——记住 $z_{i-1}$ 沿**关节 $i$** 的轴（看守模型见 [@method-2.8.watch]；「坐标系 $i$ 挂在关节 $i+1$ 上」最容易和「改进 DH」记法混淆，见[勘误 E2.4](errata.md#errata-2.4)）；
2. 丢掉 $\alpha_i$ 的符号——绕 $x_i$ 逆时针为正，2.9 节球形臂的 $-\pi/2$ 就是在这里翻的车（录播 1:19:38 老师：「正负号容易错」）；
3. 移动关节却让 $\vartheta_i$ 当变量——变量只能有一个，判定关节类型的唯一依据是关节本身，而不是杆的形状；
4. 把 $T_e^n,T_b^0$ 忘在门外——$T_n^0$ 给出的只是「杆 $n$ 坐标系」的位姿，末端执行器坐标系的常值串接（原书式 2.51）不可省。
:::
