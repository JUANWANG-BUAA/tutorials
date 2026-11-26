# 2.8 正运动学与 Denavit–Hartenberg 法

两根长为 $a_1,a_2$ 的连杆在平面内串联：第一杆与固定 $x$ 轴夹角为 $\vartheta_1$，第二杆相对第一杆再转 $\vartheta_2$。仅看几何投影，末端位置为
$$\boldsymbol p=\begin{bmatrix}a_1\cos\vartheta_1+a_2\cos(\vartheta_1+\vartheta_2)\\a_1\sin\vartheta_1+a_2\sin(\vartheta_1+\vartheta_2)\\0\end{bmatrix}.$$
当连杆数增加到 6 根或更多、关节轴在三维空间中斜交或带有偏置时，靠画平面投影逐项凑表达式极易漏项。需要一套标准化的连杆坐标系建立规则，使每一段变换都可以用同一个通用矩阵写出，并按矩阵乘法自动合成末端位姿——这就是 **Denavit–Hartenberg（DH）法**。

::: note 考纲定位 · 核心必考
标准 DH 建系四规则、四参数定义（$a_i,\alpha_i,d_i,\vartheta_i$）、齐次变换矩阵 $A_i^{i-1}$ 的推导与结构、以及开链连乘 $T_e^b = T_0^b A_1^0\cdots A_n^{n-1} T_e^n$ 为本章核心必考内容；闭链（2.8.3 节）作了解。学完本节可完成[两连杆第一关 · 到达目标](../training/two-link.md#mission-reach)；课程与考试范围参见[范围声明](../preface-scope.md)。
:::

<a id="sec-2.8.1"></a>

{{#include ../assets/figures/robot-dh.md}}

## 2.8.1 开链：编号约定、正运动学方程与递归

### 2.8.1.1 连杆—关节编号

::: def 定义 2.8.1 · 开链机械手的编号 {#def-2.8.1}
考虑无额外闭合约束的理想**开运动链**（open kinematic chain）：由 $n+1$ 个刚性连杆通过 $n$ 个单自由度关节依次串联组成。约定：
1. **连杆 0** 固定在基座上；
2. **关节 $i$**（$i=1,\dots,n$）连接**连杆 $i-1$** 与**连杆 $i$**。

每个关节为**转动关节 R**（revolute，绕固定轴转动，变量 $q_i=\vartheta_i$，单位 rad）或**移动关节 P**（prismatic，沿固定轴平移，变量 $q_i=d_i$，单位 m）。若输入来自电机编码器读数 $q_i^{\mathrm{enc}}$，必须按零位偏置与方向系数换算后再代入运动学方程，不可默认机械零位等于 DH 零位。
:::

编号顺序列成一串就是：
$$\text{连杆 }0 \;\xrightarrow{\text{关节 }1}\; \text{连杆 }1 \;\xrightarrow{\text{关节 }2}\; \cdots \;\xrightarrow{\text{关节 }n}\; \text{连杆 }n.$$
基座计作一根连杆，因此连杆数为 $n+1$、关节数为 $n$。给每根连杆 $i$ 固连坐标系 $\{i\}$，于是关节 $i$ 的运动恰好发生在 $\{i-1\}$ 与 $\{i\}$ 之间。

### 2.8.1.2 正运动学方程与末端执行器坐标系

::: def 定义 2.8.2 · 正运动学方程 {#def-2.8.2}
**正运动学**（direct/forward kinematics）指：给定关节变量向量 $\boldsymbol q=[q_1\ \cdots\ q_n]^{\mathrm T}$，计算末端执行器坐标系 $\{e\}$ 相对物理基坐标系 $\{b\}$ 的齐次变换矩阵：
$$T_e^b(\boldsymbol q)=\begin{bmatrix}\boldsymbol n_e(\boldsymbol q) & \boldsymbol s_e(\boldsymbol q) & \boldsymbol a_e(\boldsymbol q) & \boldsymbol p_e(\boldsymbol q)\\ 0 & 0 & 0 & 1\end{bmatrix}\in SE(3).$$
其中 $\boldsymbol p_e\in\mathbb R^3$ 为末端原点在 $\{b\}$ 中的位置向量（m），前三列构成旋转矩阵 $R_e^b\in SO(3)$。对常见夹爪末端，通常取：
- **接近向量 $\boldsymbol a_e$**（approach）：沿工作接近方向指离手腕；
- **滑动向量 $\boldsymbol s_e$**（sliding）：位于钳口开合平面内且垂直于 $\boldsymbol a_e$；
- **法向向量 $\boldsymbol n_e$**（normal）：由右手定则 $\boldsymbol n_e = \boldsymbol s_e \times \boldsymbol a_e$ 补齐。

其他工具（焊枪、相机等）可按工艺约定选取三轴，只需满足正交右手系。
:::

::: ex 例 2.4（原书）· 从两段投影求平面 2R 臂位姿 {#ex-book-2.4}
在平面 2R 机械臂中，$q_1=\vartheta_1$ 从固定 $x$ 轴逆时针量至杆 1，$q_2=\vartheta_2$ 从杆 1 逆时针量至杆 2。取工具轴约定：$\boldsymbol n_e$ 垂直臂平面指出纸面，$\boldsymbol a_e$ 沿杆 2 指向末端，$\boldsymbol s_e=\boldsymbol a_e\times\boldsymbol n_e$ 满足右手系 $\boldsymbol n_e=\boldsymbol s_e\times\boldsymbol a_e$，则齐次变换矩阵为（原书式 2.49）
$$T_e^b(\boldsymbol q)=\begin{bmatrix}0 & s_{12} & c_{12} & a_1 c_1+a_2 c_{12}\\ 0 & -c_{12} & s_{12} & a_1 s_1+a_2 s_{12}\\ 1 & 0 & 0 & 0\\ 0 & 0 & 0 & 1\end{bmatrix}.$$

取杆长 $a_1=a_2=1\text{ m}$ 并比较三组典型关节角：
1. 构型 $\boldsymbol q_A=(0,\pi/2)^{\mathrm T}$：
   $$\boldsymbol p_e(\boldsymbol q_A)=\begin{bmatrix}\cos 0+\cos(\pi/2)\\\sin 0+\sin(\pi/2)\\0\end{bmatrix}=\begin{bmatrix}1\\1\\0\end{bmatrix}\text{ m},\quad \boldsymbol n_e=\begin{bmatrix}0\\0\\1\end{bmatrix},\quad \boldsymbol s_e=\begin{bmatrix}1\\0\\0\end{bmatrix},\quad \boldsymbol a_e=\begin{bmatrix}0\\1\\0\end{bmatrix}.$$
2. 构型 $\boldsymbol q_B=(\pi/2,-\pi/2)^{\mathrm T}$：此时 $q_1+q_2=0$，位置仍为 $\boldsymbol p_e(\boldsymbol q_B)=[1,1,0]^{\mathrm T}\text{ m}$，但末端朝向已变为 $\boldsymbol s_e=[0,-1,0]^{\mathrm T}$、$\boldsymbol a_e=[1,0,0]^{\mathrm T}$。两者仅对**不限制末端方向的位置任务**等价，属于不同的 $SE(3)$ 位姿。
3. 构型 $\boldsymbol q_C=(0,-\pi/2)^{\mathrm T}$：$\boldsymbol p_e=[1,-1,0]^{\mathrm T}\text{ m}$ 关于 $x$ 轴镜像，$\boldsymbol s_e=[-1,0,0]^{\mathrm T}$、$\boldsymbol a_e=[0,-1,0]^{\mathrm T}$ 也随之镜像翻转。
:::

### 2.8.1.3 开链的递归合成

::: thm 定理 2.8.A · 开链正运动学连乘定理（原书式 2.50–2.51） {#thm-2.8.A}
若为每一根连杆 $i\in\{0,1,\dots,n\}$ 固连坐标系 $\{i\}$，则连杆 $n$ 相对连杆 $0$ 的位姿等于各相邻连杆变换矩阵的右乘链：
$$T_n^0(\boldsymbol q)=A_1^0(q_1)\,A_2^1(q_2)\cdots A_n^{n-1}(q_n),$$
其中每个局部变换 $A_i^{i-1}(q_i)$ **至多只依赖单个关节变量 $q_i$**。若物理基坐标系 $\{b\}$ 与末端工具系 $\{e\}$ 分别与 $\{0\}$、$\{n\}$ 存在常值安装变换 $T_0^b$ 与 $T_e^n$，则最终末端位姿为
$$T_e^b(\boldsymbol q)=T_0^b\,T_n^0(\boldsymbol q)\,T_e^n.$$
:::

从右向左校验下标抵消链（「右下在右上」传递法则）：$e \to n \to n-1 \to \cdots \to 1 \to 0 \to b$。切勿将 $T_0^b$ 误写为其逆 $T_b^0$；在一般三维变换中，左右位置互换会导致完全错误的物理基座与工具语义。

<a id="sec-2.8.2"></a>

## 2.8.2 Denavit–Hartenberg 法：动机与建系规则

::: intuition 为什么 4 个参数就足以描述 6 维刚体变换？
空间中任意两个坐标系之间的相对位姿一般需要 6 个独立自由度（3 平移 + 3 旋转）。DH 法并没有减少机构的自由度，而是通过**刻意挑选坐标系 $\{i\}$ 的原点位置与坐标轴朝向**，强行消灭其中 2 个自由度（要求 $x_i$ 既垂直 $z_{i-1}$ 又与 $z_{i-1}$ 共面正交），从而把 $A_i^{i-1}$ 限制在仅由 **4 个参数**刻画的标准形式内。由于坐标系固连于对应连杆，四个参数里三个描述连杆与关节轴的固定几何，恰有一个参数随关节 $i$ 运动。
:::

::: method 建系定位核心：看守模型（本编补充） {#method-2.8.watch}
初学者最常卡在「坐标系 $\{i\}$ 的 $z_i$ 轴到底沿第几号关节」这一步。采用**看守模型**即可彻底消除编号错位：
- 对于 $i<n$，连杆 $i$ 上固连的坐标系 $\{i\}$，其 **$z_i$ 轴沿关节 $i+1$ 的运动轴线**；
- 倒过来读就是：**坐标系 $\{i-1\}$ 是「看守关节 $i$」的坐标系——关节 $i$ 的转轴或滑轨就是 $z_{i-1}$**。

| 待查找物理量 | 对应坐标系要素 | 数学后果 |
|:--|:--|:--|
| 关节 $i$ 的轴线 | $z_{i-1}$ 轴 | 关节 $i$ 绕或沿 $z_{i-1}$ 运动 |
| 连杆 $i$ 的固连系 | 坐标系 $\{i\}$ | $i<n$ 时 $o_i$ 在关节 $i+1$ 轴线上 |
| $A_i^{i-1}$ 中唯一变量 | 绕 $z_{i-1}$ 转 $\vartheta_i$ 或沿 $z_{i-1}$ 移 $d_i$ | 实现「3 常 1 变」 |

上述约定属于**标准 DH（Standard DH，简称 SDH）**；教材或仿真软件有时也采用改进 DH（Modified DH / Craig 记法），将 $\{i\}$ 的 $z_i$ 放在关节 $i$ 上，两者在下标与乘法次序上完全不同，对照辨析见[勘误与补注 E2.4](errata.md#errata-2.4)。
:::

::: method 标准 DH 建系四规则（原书 §2.8.2） {#method-2.8.dh}
记**轴 $i$** 为关节 $i$ 的运动轴线。动手前先画出全机构的所有贯穿轴线，判清相邻轴 $i$ 与轴 $i+1$ 的空间关系（平行、相交还是异面），然后按顺序建立 $\{0\},\{1\},\dots,\{n\}$：

1. **定 $z_i$ 轴**：当 $0\le i < n$ 时，令 $z_i$ 沿**关节 $i+1$ 的轴线**（正向按需要选定后固定）；末杆没有关节 $n+1$，其 $z_n$ 方向由末端或工艺要求选定（对于转动末端通常取 $z_n \parallel z_{n-1}$）。
2. **定原点 $o_i$**：作 $z_{i-1}$ 与 $z_i$ 的公垂线，取**公垂线与 $z_i$ 的交点**作为 $o_i$；该公垂线与 $z_{i-1}$ 的交点记为垂足 $o_i'$。
3. **定 $x_i$ 轴**：令 $x_i$ 沿公垂线方向，**由 $z_{i-1}$（关节 $i$）指向 $z_i$（关节 $i+1$）**。
4. **定 $y_i$ 轴**：按右手定则 $\boldsymbol y_i = \boldsymbol z_i \times \boldsymbol x_i$ 补齐，不产生新参数。

遇到**特异轴对**（公垂线不唯一或退化）时，在保持坐标系固连于相应连杆的前提下作如下规范化选系：
- **相邻两轴相交但不平行**：$o_i$ 必取在两轴交点上（公垂线长 $a_i=0$）；$x_i$ 须同时垂直于 $z_{i-1}$ 与 $z_i$，仅余 $\pm(\boldsymbol z_{i-1}\times \boldsymbol z_i)$ 两个合法方向。
- **相邻两轴平行（$\boldsymbol z_{i-1}\parallel \boldsymbol z_i$）**：存在无穷多条公垂线。若关节 $i$ 为 **R 关节**，通常取穿过 $o_{i-1}$ 的公垂线，直接使偏距 $d_i=0$；若关节 $i$ 为 **P 关节**，须在某一参考零位下选定固连于杆 $i$ 的原点，随滑块移动时 $d_i$ 线性变化（切不可每帧重设原点试图消掉 $d_i$）。两轴同向则 $\alpha_i=0$，反向则 $\alpha_i=\pi$。
- **相邻两轴重合**：$a_i=0$；沿共轴选定原点，并在垂直共轴的平面内选定 $x_i$ 方向后固连各杆。
:::

::: method 例解 · 拟人臂前 3 轴的 DH 建系四步推演 {#method-2.8.anthro}
以空间 3R 拟人臂（肩回转轴 1 竖直、肩俯仰轴 2 水平、肘俯仰轴 3 与轴 2 平行）为例：约定参考系 $\{0\}$ 的 $+z_0$ 竖直向上，零位时两臂杆均沿 $+x_0$ 伸展，关节 2、3 的正方向取为零位下的 $-y_0$。

1. **定轴线（图格 ①）**：画出贯穿的轴 1、轴 2 与轴 3。轴 1 与轴 2 在肩中心垂直相交；轴 2 与轴 3 平行且间距分别为上臂长 $a_2$、前臂长 $a_3$。
2. **放 $\{0\}$（图格 ②）**：$z_0$ 沿关节 1 轴向上；将 $o_0$ 取在轴 1 与轴 2 交点（使随后 $d_1=0$）；$x_0$ 沿零位上臂伸展方向；$y_0$ 右手补齐。
3. **放 $\{1\}$（图格 ③）**：$z_1$ 沿关节 2 正轴（零位时指向 $-y_0$）。因轴 1、2 相交，$o_1$ 与 $o_0$ 重合，故 $a_1=0, d_1=0$。取零位 $x_1$ 与 $x_0$ 同向且随关节 1 旋转。沿 $+x_1$ 端朝原点看，从 $+z_0$ 转到 $+z_1(-y_0)$ 为逆时针 $+90^\circ$，即扭角 $\alpha_1=+\pi/2$；右手系给出零位 $y_1=+z_0$。
4. **放 $\{2\},\{3\}$（图格 ④）**：$z_2$ 沿关节 3 正轴且与 $z_1$ 同向平行，故 $\alpha_2=0$。穿过 $o_1$ 的公垂线沿上臂指向肘部，给 $d_2=0$ 与连杆长 $a_2$。末端 $\{3\}$ 取 $z_3\parallel z_2$，公垂线沿前臂指向腕部，给 $\alpha_3=0, d_3=0$ 与杆长 $a_3$。

所得 DH 参数表（每格均有唯一几何依据）：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ | 几何依据 |
|:--:|:--:|:--:|:--:|:--:|:--|
| 1 | 0 | $\pi/2$ | 0 | $\vartheta_1$ | 轴 1、2 正交且交于 $o_0$ |
| 2 | $a_2$ | 0 | 0 | $\vartheta_2$ | 轴 2、3 同向平行，公垂线即上臂 |
| 3 | $a_3$ | 0 | 0 | $\vartheta_3$ | 选 $z_3\parallel z_2$，公垂线即前臂 |

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
<text class="diagram-text" fill="var(--fig-red)" x="215" y="551">a<tspan class="sb">1</tspan> = 0</text>
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
<figcaption>拟人臂的 DH 建系全过程（本教程绘，等轴测投影）。格一先画轴线；格二放系 0（原点取在两轴交点，使 $d_1=0$）；格三放系 1（相交轴对 $a_1=0,\ \alpha_1=\pi/2$）；格四放系 2、3（平行轴对公垂线即两连杆，给出 $a_2,a_3$）。</figcaption>
</figure>
:::

::: intuition 动手实验 · 拖动关节角观察四个 DH 坐标系（3D）
拖动下列滑杆实时观察 $\{0\},\{1\},\{2\},\{3\}$ 如何随各连杆固连运动。

<div class="lab" data-lab="dh3d" hidden></div>
:::

::: note 选系不唯一时的规范化原则 {#note-2.8.dh-cases}
同一台机械臂的 DH 建系不唯一（如末杆系、平行轴公垂线及对称轴的正方向）。不同合法建系会得到不同的中间参数表与中间矩阵，但只须相应调整基座常数变换 $T_0^b$ 与工具变换 $T_e^n$，最终物理末端位姿 $T_e^b$ 完全相同。在满足四规则与连杆固连前提下，按以下原则让尽量多参数取零：
- 将 $o_0$ 取在轴 1 与轴 2 交点（若相交），消去 $d_1$；
- 相邻轴平行且为转动关节时，取过上一原点的公垂线，消去 $d_i$；
- 相邻轴反向时取 $\alpha_i=\pi$（而非随意略去）；
- 末杆为转动关节时取 $z_n\parallel z_{n-1}$，尽量使原点沿前段连杆或腕心。

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-dhw-t fig-dhw-d">
<title id="fig-dhw-t">两连杆平面臂的 DH 建系实例</title>
<desc id="fig-dhw-d">左图俯视：三个坐标系的 z 轴全部指出纸面，x0 沿基座水平参考，x1、x2 分别沿第一、第二杆，相邻 x 的有向角是关节变量。右图两行参数表中 a 为杆长，ϑ 为变量，α 与 d 为零。</desc>
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
<text class="diagram-note" x="234" y="186" text-anchor="end">y</text>
<line stroke="var(--accent)" stroke-width="5" x1="240" y1="262" x2="317.1" y2="170.1"/>
<line stroke="var(--accent)" stroke-width="5" x1="317.1" y1="170.1" x2="279.1" y2="88.5"/>
<line x1="317.1" y1="170.1" x2="342.8" y2="139.5" stroke="var(--line-strong)" stroke-width="1" stroke-dasharray="4 4"/>
<path d="M 280 262 A 40 40 0 0 0 265.7 231.4" fill="none" stroke="var(--fig-gold)" stroke-width="1.8" marker-end="url(#fdh-g)"/>
<text class="diagram-text" fill="var(--fig-gold)" x="292" y="252">ϑ<tspan class="sb">1</tspan></text>
<path d="M 339 144 A 34 34 0 0 0 302.7 139.3" fill="none" stroke="var(--fig-gold)" stroke-width="1.8" marker-end="url(#fdh-g)"/>
<text class="diagram-text" fill="var(--fig-gold)" x="346" y="140">ϑ<tspan class="sb">2</tspan></text>
<g stroke-width="2.2">
<line stroke="var(--fig-blue)" marker-end="url(#fdh-b)" x1="240" y1="262" x2="330" y2="262"/>
<line stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#fdh-n)" x1="240" y1="262" x2="240" y2="207"/>
<line stroke="var(--fig-blue)" marker-end="url(#fdh-b)" x1="317.1" y1="170.1" x2="352.5" y2="128"/>
<line stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#fdh-n)" x1="317.1" y1="170.1" x2="275" y2="134.7"/>
<line stroke="var(--fig-blue)" marker-end="url(#fdh-b)" x1="279.1" y1="88.5" x2="261.2" y2="50.1"/>
<line stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#fdh-n)" x1="279.1" y1="88.5" x2="240.7" y2="106.4"/>
</g>
<g>
<circle cx="240" cy="262" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="240" cy="262" r="2.2" fill="var(--ink-2)"/>
<circle cx="317.1" cy="170.1" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="317.1" cy="170.1" r="2.2" fill="var(--ink-2)"/>
<circle cx="279.1" cy="88.5" r="9" fill="var(--paper)" stroke="var(--ink-2)" stroke-width="1.4"/><circle cx="279.1" cy="88.5" r="2.2" fill="var(--ink-2)"/>
</g>
<text class="diagram-text" fill="var(--fig-blue)" x="336" y="278">x<tspan class="sb">0</tspan></text>
<text class="diagram-text" fill="var(--fig-blue)" x="352" y="120">x<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--fig-blue)" x="250" y="48" text-anchor="end">x<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="224" y="280" text-anchor="end">o<tspan class="sb">0</tspan></text>
<text class="diagram-note" x="330" y="180">o<tspan class="sb">1</tspan></text>
<text class="diagram-note" x="292" y="84">o<tspan class="sb">2</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="300" y="234">a<tspan class="sb">1</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="262" y="142" text-anchor="end">a<tspan class="sb">2</tspan></text>
<text class="diagram-note" x="300" y="322" text-anchor="middle">z 全平行 → α = 0；原点同面 → d = 0；x 沿连杆方向 → a 恰为杆长</text>
<g fill="none" stroke="var(--line)">
<rect x="540" y="60" width="330" height="135"/>
<line x1="540" y1="105" x2="870" y2="105"/><line x1="540" y1="150" x2="870" y2="150"/><line x1="615" y1="60" x2="615" y2="195"/><line x1="690" y1="60" x2="690" y2="195"/><line x1="765" y1="60" x2="765" y2="195"/><line x1="840" y1="60" x2="840" y2="195"/>
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
<figcaption>两连杆平面臂的 DH 建系对照（本教程绘）：所有 $z$ 轴同向平行给 $\alpha_i=0$，原点共面给 $d_i=0$，$x_i$ 沿连杆给 $a_i$ 为杆长，关节变量为两相邻 $x$ 轴夹角 $\vartheta_1,\vartheta_2$。</figcaption>
</figure>
:::

### 2.8.2.1 四个 DH 参数及其几何映射

::: method 规范化选系原则：在合法选系中让 0 尽量多 {#method-2.8.zero}
不同合法建系会得到不同的中间参数表与中间矩阵，只须相应调整基座常数变换 $T_0^b$ 与工具变换 $T_e^n$，最终物理末端位姿 $T_e^b$ 完全相同。在满足四规则与连杆固连前提下，按以下原则让尽量多参数取零：
- 将 $o_0$ 取在轴 1 与轴 2 交点（若相交），消去 $d_1$；
- 相邻轴平行且为转动关节时，取过上一原点的公垂线，消去 $d_i$；
- 相邻轴反向时取 $\alpha_i=\pi$（而非随意略去）；
- 末杆为转动关节时取 $z_n\parallel z_{n-1}$，尽量使原点沿前段连杆或腕心。
:::

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
<line class="diagram-axis" x1="420" x2="520" y1="85" y2="385"/>
<text class="diagram-text" text-anchor="middle" x="170" y="70">z<tspan class="sb">i−1</tspan></text>
<text class="diagram-text" text-anchor="middle" x="414" y="73">z<tspan class="sb">i</tspan></text>
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
<text class="diagram-note" text-anchor="middle" x="760" y="254">从 +x<tspan class="sb">i</tspan> 端朝原点看</text>
<text class="diagram-note" text-anchor="middle" x="760" y="276">图示顺时针：α<tspan class="sb">i</tspan> 为负</text>
<text class="diagram-note" text-anchor="middle" x="760" y="404">转动关节：ϑ<tspan class="sb">i</tspan> 是变量</text>
<text class="diagram-note" text-anchor="middle" x="760" y="426">移动关节：d<tspan class="sb">i</tspan> 是变量；a<tspan class="sb">i</tspan>、α<tspan class="sb">i</tspan> 恒为常数</text>
</g></svg>
<figcaption>标准 DH 四参数几何定义（本教程绘）：左图为两相邻 $z$ 轴及公垂线定义 $a_i,d_i$；右图为沿 $+x_i$ 端朝原点看定出有向扭角 $\alpha_i$ 符号。</figcaption>
</figure>

::: def 定义 2.8.3 · 标准 DH 四参数 {#def-2.8.3}
按上述规则建立坐标系 $\{i-1\}$ 与 $\{i\}$ 后，两者相对位姿由以下 4 个参数唯一刻画：

| 参数 | 名称 | 几何定义 | 属性（单自由度 R/P） |
|:--|:--|:--|:--|
| $a_i$ | **杆件长度** | 从 $o_i'$ 到 $o_i$ 沿 $x_i$ 轴的有向距离（一般取非负公垂线长，m） | **恒为常数** |
| $\alpha_i$ | **杆件扭角** | 绕 $x_i$ 从 $z_{i-1}$ 转到 $z_i$ 的右手有向角（rad） | **恒为常数** |
| $d_i$ | **关节偏距 / 距离** | 从 $o_{i-1}$ 到垂足 $o_i'$ 沿 $z_{i-1}$ 轴的有向距离（m） | **P 关节为变量**，R 关节为常数 |
| $\vartheta_i$ | **关节转角** | 绕 $z_{i-1}$ 从 $x_{i-1}$ 转到 $x_i$ 的右手有向角（rad） | **R 关节为变量**，P 关节为常数 |

即每条连杆满足「**3 常 1 变**」：$a_i,\alpha_i$ 仅取决于连杆几何而恒为常数，$d_i$ 与 $\vartheta_i$ 中恰有一个为关节变量，由**关节类型**决定（不取决于连杆外形）。
:::

::: method 建系规则到四参数的映射（为谁服务） {#method-2.8.map}
建系四规则与四个 DH 参数的职责分工明确：

| 建系规则 | 所定几何对象 | 直接控制的 DH 参数 |
|:--|:--|:--|
| $z_{i-1}$ 沿关节 $i$ 轴线 | 关节运动轴与参考方向 | 决定唯一变量是 $\vartheta_i$（R）还是 $d_i$（P） |
| $o_i$ 取公垂线与 $z_i$ 交点、$x_i$ 沿公垂线 | 两轴最近公共垂线段与方向 | 决定杆件长度 $a_i$ 与偏距 $d_i$（垂足 $o_i'$ 位置） |
| $z_{i-1}$ 到 $z_i$ 空间夹角（绕 $x_i$） | 两邻近关节轴相对倾角 | 决定恒定扭角 $\alpha_i$ |
| $y_i=\boldsymbol z_i\times\boldsymbol x_i$ | 右手正交补全 | 保证 $R\in SO(3)$ 唯一，不引入额外参数 |
:::

### 2.8.2.2 相邻连杆变换矩阵 $A_i^{i-1}$ 的推导

::: method 相邻变换 $A_i^{i-1}$ 的两步右乘分解（原书式 2.52） {#method-2.8.A}
站在坐标系 $\{i-1\}$ 出发，通过先对齐公垂线、再沿公垂线到达 $\{i\}$ 的两步运动（每步内部可交换顺序），即可精确把 $\{i-1\}$ 变换到 $\{i\}$。引进过渡坐标系 $\{i'\}$（原点在垂足 $o_i'$，$z_{i'}=z_{i-1}$，$x_{i'}=x_i$）：

1. **从 $\{i-1\}$ 到 $\{i'\}$**：绕当前 $z_{i-1}$ 转 $\vartheta_i$ 并沿当前 $z_{i-1}$ 平移 $d_i$（同轴旋转与平移可交换）：
   $$A_{i'}^{i-1}=\operatorname{Trans}_z(d_i)\operatorname{Rot}_z(\vartheta_i)=\begin{bmatrix}c_{\vartheta_i} & -s_{\vartheta_i} & 0 & 0\\ s_{\vartheta_i} & c_{\vartheta_i} & 0 & 0\\ 0 & 0 & 1 & d_i\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
2. **从 $\{i'\}$ 到 $\{i\}$**：沿当前 $x_{i'}$（即 $x_i$）平移 $a_i$ 并绕当前 $x_{i'}$ 旋转 $\alpha_i$（同轴操作可交换）：
   $$A_i^{i'}=\operatorname{Trans}_x(a_i)\operatorname{Rot}_x(\alpha_i)=\begin{bmatrix}1 & 0 & 0 & a_i\\ 0 & c_{\alpha_i} & -s_{\alpha_i} & 0\\ 0 & s_{\alpha_i} & c_{\alpha_i} & 0\\ 0 & 0 & 0 & 1\end{bmatrix}.$$

按[§2.3](sec2-3.md)「绕当前轴运动右乘」定理（[@thm-2.3.A]），将两步复合即得标准 DH 变换矩阵：
$$A_i^{i-1}(q_i)=A_{i'}^{i-1}A_i^{i'}=\begin{bmatrix}
c_{\vartheta_i} & -s_{\vartheta_i}c_{\alpha_i} & s_{\vartheta_i}s_{\alpha_i} & a_ic_{\vartheta_i}\\
s_{\vartheta_i} & c_{\vartheta_i}c_{\alpha_i} & -c_{\vartheta_i}s_{\alpha_i} & a_is_{\vartheta_i}\\
0 & s_{\alpha_i} & c_{\alpha_i} & d_i\\
0 & 0 & 0 & 1
\end{bmatrix}.$$
:::

::: note 旋转块各列与第四列的几何读法 {#note-2.8.A.cols}
完整变换可拆为四个基本因子：$A_i^{i-1}=\operatorname{Rot}_z(\vartheta_i)\operatorname{Trans}_z(d_i)\operatorname{Trans}_x(a_i)\operatorname{Rot}_x(\alpha_i)$。因此：
- **第 1 列**为 $\boldsymbol x_i^{i-1}=R_z(\vartheta_i)R_x(\alpha_i)\boldsymbol e_x=[c_{\vartheta_i},s_{\vartheta_i},0]^{\mathrm T}$，与 $\alpha_i$ 无关，因为 $x_i$ 恰好在 $x_{i-1}y_{i-1}$ 平面内；
- **第 2、3 列**是先经 $R_x(\alpha_i)$ 将 $y,z$ 混合为 $[0,c_{\alpha_i},s_{\alpha_i}]^{\mathrm T}$ 和 $[0,-s_{\alpha_i},c_{\alpha_i}]^{\mathrm T}$，再经 $R_z(\vartheta_i)$ 在 $xy$ 分量上旋转（第 3 行保持不变）；
- **第 4 列**为新原点 $o_i$ 在 $\{i-1\}$ 中的坐标：先沿 $x_i$ 移 $a_i$ 再绕 $z_{i-1}$ 转 $\vartheta_i$ 给出 $(a_ic_{\vartheta_i},a_is_{\vartheta_i})$，连同沿 $z_{i-1}$ 偏移 $d_i$ 得 $\boldsymbol p_i^{i-1}=[a_ic_{\vartheta_i},a_is_{\vartheta_i},d_i]^{\mathrm T}$。
:::

::: proof 两个极端退化检验
1. **纯转动退化**：取 $a_i=\alpha_i=d_i=0$，两系原点重合、$z$ 轴同向，$A_i^{i-1}$ 退化为纯 $z$ 轴旋转 $\operatorname{Rot}_z(\vartheta_i)$。
2. **纯移动退化**：取 $\vartheta_i=\alpha_i=a_i=0$，$A_i^{i-1}$ 退化为纯沿 $z_{i-1}$ 轴平移 $\operatorname{Trans}_z(d_i)$（例如球形臂第三关节）。
两类退化与几何定义完全吻合，校验了公式各项的符号与位置。$\square$
:::

::: method DH 正运动学十步完整流程（原书） {#method-2.8.steps}
1. 标定所有关节轴线 $z_0,\dots,z_{n-1}$ 的直线与选定正方向；
2. 建立基杆系 $\{0\}$（$o_0$ 在 $z_0$ 上，尽可能与物理基坐标系重合或取在轴交点处以消去 $d_1$）；
3. 对 $i=1,\dots,n-1$ 逐杆建系：取 $o_i$ 为公垂线与 $z_i$ 的交点；
4. 取 $x_i$ 沿公垂线由轴 $i$ 指向轴 $i+1$；
5. 按右手系补全 $y_i$；
6. 选取末杆坐标系 $\{n\}$，使之满足公垂线条件且固连于连杆 $n$；
7. 列出含 $4n$ 个数值与变量的 DH 参数表；
8. 逐行代入矩阵通式写出 $A_1^0(q_1),\dots,A_n^{n-1}(q_n)$；
9. 连乘得到 $T_n^0(\boldsymbol q)=A_1^0\cdots A_n^{n-1}$；
10. 串接常值安装变换 $T_e^b(\boldsymbol q)=T_0^b T_n^0(\boldsymbol q)T_e^n$，并用零位和垂直构型核对三列位置和轴向。
:::

::: note 实际计算中的三角函数求值优化
在实时控制中直接暴力连乘含大量 0、1 的 $A_i^{i-1}$ 矩阵会浪费算力。常用做法包括：提前合并常值变换因子、缓存并复用 $\cos q_i,\sin q_i,\cos(q_1+q_2)$ 等公共三角项、展开求得解析闭式表达式；若仅需工具旋转矩阵的两根准确正交轴向量，第三根可由叉积补全（注意不能用叉积修复带测噪的非正交向量）。
:::

::: ex 例 2.8.B · 含扭角单行 DH 参数对原点与姿态的不同影响 {#ex-2.8.B}
设某连杆 DH 参数为 $a=2\text{ m},\ d=1\text{ m},\ \vartheta=90^\circ,\ \alpha=90^\circ$。求 $A_i^{i-1}$，并求 $\{i\}$ 中一点 $\boldsymbol p^i=[0,1,0]^{\mathrm T}\text{ m}$ 在 $\{i-1\}$ 中的坐标；随后仅把扭角改为 $\alpha=0$，比较原点与该点像的变化。

::: sol 解答
代入 $c_\vartheta=c_\alpha=0,\ s_\vartheta=s_\alpha=1$：
$$A_i^{i-1}=\begin{bmatrix}0 & 0 & 1 & 0\\ 1 & 0 & 0 & 2\\ 0 & 1 & 0 & 1\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
第 4 列为原点 $o_i$ 在 $\{i-1\}$ 中坐标 $[0,2,1]^{\mathrm T}\text{ m}$（$a$ 经 $\vartheta=90^\circ$ 旋转后沿 $+y_{i-1}$，$d$ 沿 $+z_{i-1}$）。第 2 列为 $\boldsymbol y_i^{i-1}=[0,0,1]^{\mathrm T}$，于是
$$\tilde{\boldsymbol p}^{i-1}=A_i^{i-1}\begin{bmatrix}0\\1\\0\\1\end{bmatrix}=\begin{bmatrix}0\\2\\1\end{bmatrix}+\begin{bmatrix}0\\0\\1\end{bmatrix}=\begin{bmatrix}0\\2\\2\end{bmatrix}\text{ m}\quad(\text{齐次坐标 }[0,2,2,1]^{\mathrm T}).$$
当只将扭角改为 $\alpha=0$ 时：由于第 4 列不含 $\alpha$，$o_i$ 位置仍为 $[0,2,1]^{\mathrm T}\text{ m}$ 不变；但新 $y$ 轴转回 $[-1,0,0]^{\mathrm T}$，因此该点的像变为 $[-1,2,1]^{\mathrm T}\text{ m}$。扭角 $\alpha$ 仅调控 $\{i\}$ 自身的相对朝向（影响杆内向量与下游变换），不移动当前原点 $o_i$。
:::
:::

::: think 练习 1 · R/P 混合链串接基座与工具变换 {#practice-2.8.chain}
2 自由度 RP 机械臂按 $(a_i,\alpha_i,d_i,\vartheta_i)$ 排列如下（长度 m、角度 rad）：

| $i$ | 关节类型 | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|:--:|
| 1 | R | $1$ | $0$ | $0.2$ | $q_1$ |
| 2 | P | $0.5$ | $0$ | $q_2$ | $-\pi/2$ |

给定 $q_1=\pi/2,\ q_2=0.3\text{ m}$，并已知安装变换
$$T_0^b=\begin{bmatrix}R_z(\pi/2) & [2,0,0]^{\mathrm T}\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix},\qquad
T_e^2=\begin{bmatrix}R_x(\pi/2) & [0.2,0,0.1]^{\mathrm T}\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix}.$$
求 $T_2^0$ 与 $T_e^b$，说明 $q_2$ 增加 $0.1\text{ m}$ 时工具在 $\{b\}$ 中沿何方向平移，以及为什么左侧错写成 $T_b^0$ 会引发根本错误。

::: sol 核对与辨析
代入各自 DH 参数得
$$A_1^0=\begin{bmatrix}0 & -1 & 0 & 0\\ 1 & 0 & 0 & 1\\ 0 & 0 & 1 & 0.2\\ 0 & 0 & 0 & 1\end{bmatrix},\qquad
A_2^1=\begin{bmatrix}0 & 1 & 0 & 0\\ -1 & 0 & 0 & -0.5\\ 0 & 0 & 1 & 0.3\\ 0 & 0 & 0 & 1\end{bmatrix},$$
连乘得
$$T_2^0=A_1^0A_2^1=\begin{bmatrix}1 & 0 & 0 & 0.5\\ 0 & 1 & 0 & 1\\ 0 & 0 & 1 & 0.5\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
进而算得 $T_e^2$ 在 $\{0\}$ 中的末端位置为 $[0.7,1,0.6]^{\mathrm T}$，再左乘 $T_0^b$（先绕 $z$ 转 $\pi/2$ 成 $[-1,0.7,0.6]^{\mathrm T}$ 再加 $[2,0,0]^{\mathrm T}$）：
$$T_e^b=T_0^b T_2^0 T_e^2=\begin{bmatrix}0 & 0 & 1 & 1\\ 1 & 0 & 0 & 0.7\\ 0 & 1 & 0 & 0.6\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
当 $q_2$ 增加 $0.1\text{ m}$ 时，$A_2^1$ 仅在第 3 行平移 $+0.1$，经 $T_0^b$（其旋转块保持 $z$ 轴）映射后工具朝向不变，位置沿 $\{b\}$ 的 $+z_b$ 轴增加 $0.1\text{ m}$。若将 $T_0^b$ 错代为 $T_b^0$，坐标系衔接从 $\{e\}\to\{2\}\to\{0\}$ 被强行接上 $\{b\}\to\{0\}$，输入与输出接口完全失配。
:::
:::

::: think 练习 2 · 常见选系规则判断 {#practice-2.8.axes}
判断下列五条陈述的正误并给出反例或理由：① 平行移动关节可在每次运动到新位置后重设原点使 $d_i\equiv 0$；② 相交而不平行的两关节轴，其 $x_i$ 可任选空间方向；③ 两 $z$ 轴反向平行时仍有 $\alpha_i=0$；④ 对同一物理机构更换合法的 DH 建系，各个中间矩阵 $T_n^0$ 必定不变；⑤ 具有固定扭角 $\alpha_i=\pi/2$ 且 $a_i=d_i=0$ 的 R 关节矩阵就是纯转动 $\operatorname{Rot}_z(\vartheta_i)$。

::: sol 核对
五句皆错。① 重设原点违背坐标系与连杆固连的前提，会抹去移动关节的真实行程；② $x_i$ 必须同时垂直两轴，只剩正负两个方向；③ 两轴反向平行应取 $\alpha_i=\pi$（或 $-\pi$）；④ 中间系改变后各 $A_i^{i-1}$ 和 $T_n^0$ 通常随之改变，需通过相应修改 $T_0^b$ 与 $T_e^n$ 使整体 $T_e^b$ 保持不变；⑤ 当 $\alpha_i=\pi/2$ 时还带有固定的 $\operatorname{Rot}_x(\pi/2)$ 因子。
:::
:::

<a id="lab-2.8"></a>

::: intuition 动手实验 · 平面 3R 的 DH 连乘验证（互动）
下例取平面 3R 连杆长度 $(0.5,0.4,0.3)\text{ m}$。调节关节角并对照解析式 $x=l_1c_1+l_2c_{12}+l_3c_{123},\ y=l_1s_1+l_2s_{12}+l_3s_{123}$ 检验（零位为 $(1.2,0)\text{ m}$，当第二角调至 $90^\circ$ 时为 $(0.5,0.7)\text{ m}$、朝向 $90^\circ$；默认角 $(40^\circ,-35^\circ,25^\circ)$）。

<div class="lab" data-lab="arm" hidden></div>
:::

<a id="sec-2.8.3"></a>

## 2.8.3 闭链机构的 DH 处理（补充·精简）

当机械手内部含有一个或多个封闭运动环（如[§2.9.2](sec2-9.md#sec-2.9.2)中的平行四边形臂）时，可通过**虚拟切开闭环**把有环图化归为树状开链，再利用环路闭合条件消去被动关节变量。

::: method 闭链正运动学的五步处理流程（原书 §2.8.3） {#method-2.8.closed}
设闭环机构有 $n+1$ 根连杆、$l>n$ 个单自由度关节（独立闭环数为 $l-n$）：
1. **虚拟切口**：在每个闭环的一处（通常选非驱动关节 $j+1$ 所在铰链）作虚拟切断，将机构剖成具有共同上游参考系 $\{i\}$ 的两条开链分支，分别终结于切口两侧连杆系 $\{j\}$ 与 $\{k\}$；
2. **分支 DH 建系**：对树上每一分支分别按标准 DH 规则建立坐标系与变换链；
3. **写闭合约束方程**：切口复原要求两侧坐标系 $\{j\}$ 与 $\{k\}$ 满足物理铰接条件（原书式 2.55–2.60）。当切口关节为**转动关节 R** 时，两 $z$ 轴须重合且原点仅差固定偏置 $d_{jk}$：
   $$\boldsymbol z_j^i(\boldsymbol q')=\boldsymbol z_k^i(\boldsymbol q''),\qquad R_i^j(\boldsymbol q')\big(\boldsymbol p_j^i(\boldsymbol q')-\boldsymbol p_k^i(\boldsymbol q'')\big)=\begin{bmatrix}0\\0\\d_{jk}\end{bmatrix}$$
   （此处 $R_i^j=(R_j^i)^{\mathrm T}$；正负号须与向量 $\boldsymbol p_j^i-\boldsymbol p_k^i$ 一致）；当切口为 **P 关节**时，保留上述位置差的前两个水平分量（第 3 分量为自由行程）并附加扭角约束 $\boldsymbol x_j^{i\,\mathrm T}\boldsymbol x_k^i=\cos\vartheta_{jk}$（若角度余弦引发正负支模糊，须用完整相对旋转矩阵核对）。需要注意：上述六个标量等式**并不线性无关**（单位方向向量相等只有 2 个独立方程，R/P 连接在一般空间构型下限制 5 个相对自由度）。
4. **选独立驱动量与解被动变量**：选定独立驱动坐标 $\boldsymbol q$，从闭合方程解出被动关节角度并按装配分支筛选，不可凭公式个数直接断定唯一解或闭式可解。
5. **沿真实树路径连乘**：把解出的被动变量代入选定路径（如原书式 2.61 $T_n^0=A_i^0 A_j^i A_n^j$），再串接 $T_e^b=T_0^b T_n^0 T_e^n$，并用另一条树路径校验结果完全重合。
:::

::: think 练习 3 · 平面四杆机构两条路径闭合检验 {#practice-2.8.closed}
固定铰接点 $A=(0,0),\ D=(2,0)\text{ m}$，杆长 $AB=DC=1\text{ m},\ BC=AD=2\text{ m}$。在平行四边形装配分支下，$AB$ 与 $DC$ 均与 $+x$ 轴成角 $q$。写出路径 $A\to B\to C$ 与 $A\to D\to C$ 的位置公式，在 $q=30^\circ$ 时检验闭合，并说明为何不能因看见 4 个 R 关节就断言有 4 个自由度。

::: sol 核对
设单位方向 $\boldsymbol u(q)=[\cos q,\sin q]^{\mathrm T}$。路径 $A\to B\to C$ 给出 $B=\boldsymbol u(q),\ C=\boldsymbol u(q)+[2,0]^{\mathrm T}$；路径 $A\to D\to C$ 给出 $C=[2,0]^{\mathrm T}+\boldsymbol u(q)$。取 $q=30^\circ$：
$$B=\begin{bmatrix}\sqrt{3}/2\\ 1/2\end{bmatrix}\text{ m},\qquad C=\begin{bmatrix}2+\sqrt{3}/2\\ 1/2\end{bmatrix}\text{ m},$$
两条路径结果完全重合且满足杆长闭合约束 $\|C-B\|=2\text{ m},\ \|C-D\|=1\text{ m}$。该分支通常仅有 1 个独立自由度 $q$，其余关节角受闭环约束锁定；一般机构自由度必须用闭合方程在具体构型下的雅可比秩与装配分支分析决定，不能简单按关节数目相加。
:::
:::

<a id="sec-2.8"></a>

::: think 默写点 · 合上书核对核心知识
1. 默写标准 DH 变换矩阵 $A_i^{i-1}(q_i)$（尤其是第 3 行与第 4 列）。
2. 说明看守模型：关节 $i$ 沿哪个 $z$ 轴？坐标系 $\{i\}$ 固连在哪根连杆？
3. 简述建系四规则，并说明相邻轴相交与相邻轴平行（分别对 R 与 P 关节）如何取舍。

::: sol 核对
1. $A_i^{i-1}$ 的第 3 行为 $[0,s_{\alpha_i},c_{\alpha_i},d_i]$，第 4 列为 $[a_ic_{\vartheta_i},a_is_{\vartheta_i},d_i,1]^{\mathrm T}$，完整公式见本节表格与[公式速查卡](../preface-formulas.md) B1。
2. 关节 $i$ 沿/绕 $z_{i-1}$ 运动；坐标系 $\{i\}$ 固连在连杆 $i$ 上，$i<n$ 时 $z_i$ 沿关节 $i+1$ 的轴线。
3. 四规则：定 $z_i$ 沿关节 $i+1$ 轴；$o_i$ 取在公垂线与 $z_i$ 交点；$x_i$ 沿公垂线由 $i$ 指 $i+1$；$y_i$ 右手补齐。相交时 $a_i=0$ 且 $x_i$ 垂直两轴平面；平行时两轴同向取 $\alpha_i=0$（反向取 $\pi$），R 关节选过 $o_{i-1}$ 公垂线消去 $d_i$，P 关节须在参考位固连原点使 $d_i$ 记录行程变化。
:::
:::

## 2.8 小结与常见错误

| 公式 / 规则 | 适用条件 | 关键细节与易错点 |
|:--|:--|:--|
| $T_n^0=A_1^0 A_2^1\cdots A_n^{n-1}$ | 理想单自由度开链 | 右乘传递顺序；每因子只含 1 个关节变量 $q_i$ |
| $T_e^b=T_0^b T_n^0 T_e^n$ | 固定物理基座与工具 | 接口按 $e\to n\to 0\to b$ 抵消；不可误写 $T_b^0$ |
| $A_i^{i-1}=\operatorname{Rot}_z(\vartheta_i)\operatorname{Trans}_z(d_i)\operatorname{Trans}_x(a_i)\operatorname{Rot}_x(\alpha_i)$ | 标准 DH 建系 | 旋转块 $=R_z(\vartheta_i)R_x(\alpha_i)$；第 4 列 $=(a_ic_{\vartheta_i},a_is_{\vartheta_i},d_i)$ |
| 3 常 1 变 | 固定选系的理想 R/P 连杆 | $a_i,\alpha_i$ 恒为常数；变量严格由关节类型 R/P 决定 |

::: note 主线 · 两连杆（第一关 · 到达目标）
学完本节后请进入[两连杆第一关](../training/two-link.md#mission-reach)，用矩阵连乘与几何法核对末端到达 $(1,1)\text{ m}$ 的两组构型；随后的 [§2.12](sec2-12.md) 将由位置反解这两支构型，[§3.1](../ch03/sec3-1.md) 再分析两者在奇异边界附近的速度差异。
:::

::: think 本节常见错误自查
1. 将 $z_i$ 误置在关节 $i$ 轴线上（混淆了标准 DH 与改进 DH）；
2. 忘记用右手定则判定扭角 $\alpha_i$ 符号（须从 $+x_i$ 端看从 $z_{i-1}$ 转到 $z_i$ 是否逆时针）；
3. 移动关节 P 错误令 $\vartheta_i$ 作变量，或为消除偏距而在每一步运动中移动连杆坐标系；
4. 写反或漏乘物理安装矩阵 $T_0^b, T_e^n$。
:::

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 约 42:29 | [ex24-two-link.jpg](../assets/ch02/ex24-two-link.jpg) | 原书例 2.4 两连杆臂与工具选系 | 例 2.4 完整写出，含两支构型的三列核对与位置回代 |
| 约 46:11 | [open-chain-recursive.jpg](../assets/ch02/open-chain-recursive.jpg) | 开链递归与 $T_n^0$ 连乘 | 定理 2.8.A 完整给出，含接口核对与 $T_0^b$／$T_b^0$ 辨析 |
| 约 54:40 | [dh-rules.jpg](../assets/ch02/dh-rules.jpg) | DH 建系规则与连杆坐标系 | 建系四规则完整重写；自绘拟人臂四步分镜与平面两杆实例替代 |
| 约 1:00:16 | [dh-params.jpg](../assets/ch02/dh-params.jpg) | 四参数定义（红字助记为课堂标注） | 定义 2.8.3 参数表完整给出，助记名称保留 |
| 约 1:09:28 | [dh-matrix.jpg](../assets/ch02/dh-matrix.jpg) | $A_i^{i-1}$ 完整矩阵 | 两步分解推导、逐列验算与两个退化自检完整给出 |
:::
