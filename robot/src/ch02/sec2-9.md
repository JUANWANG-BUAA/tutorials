# 2.9 典型机械结构的正运动学

学会标准 DH 建系与连乘定理后，工程上并不对每台新机械手都从头猜测矩阵形式，而是拆解为几类经典运动学骨架。本节依次建立平面三连杆臂、平行四边形臂、球形臂、拟人臂、球形腕，以及串联组合后的斯坦福臂、带腕拟人臂、7 自由度拟人臂与双臂类人系统共九种典型构形的正运动学模型。

::: note 考纲定位 · 重点掌握
**三连杆平面臂、球形臂（RRP）、拟人臂（RRR）、球形腕（ZYZ 欧拉角）** 及其组合结构（特别是**带球形腕拟人臂的接口重建 $a_3\to d_4$**）是考试与[§2.12 逆运动学](sec2-12.md)的直接基础。阅读每个算例时均按「轴线关系 → DH 参数表 → 连乘化简 → 物理零位复核」四步推进。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-29-title fig-29-desc">
<title id="fig-29-title">五种典型构形的关节配置</title>
<desc id="fig-29-desc">五个构形简图。笛卡儿型的三条正交导轨用水平、竖直和斜向投影表示；圆柱型回转、升降、伸缩；球形两转一移；SCARA 仅画定位的 RRP 部分，省略常见的末端回转轴；拟人型只画腰肩肘。圆表示转动关节，双箭头表示移动关节。</desc>
<defs>
<marker id="f29-b" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-blue)"/></marker>
<marker id="f29-bs" markerWidth="8" markerHeight="8" refX="1" refY="2.5" orient="auto"><path d="M6,0 L0,2.5 L6,5 Z" fill="var(--fig-blue)"/></marker>
<marker id="f29-a" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--accent-text)"/></marker>
</defs>
<text class="diagram-text" x="460" y="30" text-anchor="middle">五类定位结构回顾（投影简图，非尺寸图）</text>
<circle cx="652" cy="56" r="5" fill="none" stroke="var(--accent-text)" stroke-width="1.6"/>
<text class="diagram-note" x="664" y="60">转动关节 R（圆）</text>
<line x1="646" y1="76" x2="662" y2="76" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<text class="diagram-note" x="670" y="80">移动关节 P（双箭头）</text>
<g stroke="var(--line)" stroke-width="1.5"><line x1="30" y1="240" x2="165" y2="240"/><line x1="195" y1="240" x2="360" y2="240"/><line x1="380" y1="240" x2="545" y2="240"/><line x1="560" y1="240" x2="730" y2="240"/><line x1="745" y1="240" x2="915" y2="240"/></g>
<!-- 1 笛卡儿 PPP -->
<g>
<rect x="42" y="225" width="100" height="15" class="diagram-node"/>
<rect x="78" y="110" width="16" height="115" class="diagram-node"/>
<rect x="94" y="110" width="70" height="14" class="diagram-node"/>
<path d="M128 124 L140 128 L116 166 L104 162 Z" class="diagram-node"/>
<line x1="64" y1="130" x2="64" y2="210" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<line x1="104" y1="94" x2="152" y2="94" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<line x1="153" y1="133" x2="129" y2="171" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<text class="diagram-text" x="92" y="272" text-anchor="middle">笛卡儿</text>
<text class="diagram-mono" x="92" y="291" text-anchor="middle">P P P</text>
<text class="diagram-note" x="92" y="309" text-anchor="middle">三移 · 箱内作业</text>
</g>
<!-- 2 圆柱 RPP -->
<g>
<ellipse cx="276" cy="196" rx="40" ry="9" class="diagram-node"/>
<line x1="236" y1="196" x2="236" y2="232" stroke="var(--line-strong)"/>
<line x1="316" y1="196" x2="316" y2="232" stroke="var(--line-strong)"/>
<path d="M 232 226 A 44 11 0 1 0 320 226" fill="none" stroke="var(--accent-text)" stroke-width="1.6" marker-end="url(#f29-a)"/>
<rect x="268" y="90" width="16" height="106" class="diagram-node"/>
<rect x="284" y="104" width="62" height="13" class="diagram-node"/>
<line x1="332" y1="196" x2="332" y2="110" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<line x1="296" y1="130" x2="338" y2="130" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<text class="diagram-text" x="276" y="272" text-anchor="middle">圆柱形</text>
<text class="diagram-mono" x="276" y="291" text-anchor="middle">R P P</text>
<text class="diagram-note" x="276" y="309" text-anchor="middle">回转 + 升降 + 伸缩</text>
</g>
<!-- 3 球形 RRP -->
<g>
<ellipse cx="424" cy="216" rx="28" ry="7" class="diagram-node"/>
<line x1="396" y1="216" x2="396" y2="238" stroke="var(--line-strong)"/>
<line x1="452" y1="216" x2="452" y2="238" stroke="var(--line-strong)"/>
<path d="M 390 228 A 36 9 0 1 0 458 228" fill="none" stroke="var(--accent-text)" stroke-width="1.6" marker-end="url(#f29-a)"/>
<circle cx="424" cy="206" r="7" class="diagram-node"/>
<line stroke="var(--accent)" stroke-width="5" x1="424" y1="206" x2="470" y2="124"/>
<line stroke="var(--fig-blue)" stroke-width="2.4" x1="470" y1="124" x2="502" y2="70"/>
<line x1="480" y1="118" x2="506" y2="82" stroke="var(--fig-blue)" stroke-width="1.4" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<text class="diagram-text" x="460" y="272" text-anchor="middle">球形</text>
<text class="diagram-mono" x="460" y="291" text-anchor="middle">R R P</text>
<text class="diagram-note" x="460" y="309" text-anchor="middle">两转 + 径向伸缩</text>
</g>
<!-- 4 SCARA -->
<g>
<rect x="596" y="150" width="14" height="90" class="diagram-node"/>
<rect x="610" y="144" width="64" height="13" class="diagram-node"/>
<rect x="674" y="144" width="52" height="13" class="diagram-node"/>
<circle cx="610" cy="150" r="6" class="diagram-node"/>
<circle cx="674" cy="150" r="6" class="diagram-node"/>
<path d="M 598 150 A 12 12 0 0 1 610 138" fill="none" stroke="var(--accent-text)" stroke-width="1.4" marker-end="url(#f29-a)"/>
<path d="M 662 150 A 12 12 0 0 1 674 138" fill="none" stroke="var(--accent-text)" stroke-width="1.4" marker-end="url(#f29-a)"/>
<rect x="694" y="157" width="12" height="48" class="diagram-node"/>
<line x1="714" y1="162" x2="714" y2="200" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f29-b)" marker-start="url(#f29-bs)"/>
<text class="diagram-text" x="644" y="272" text-anchor="middle">SCARA</text>
<text class="diagram-mono" x="644" y="291" text-anchor="middle">R R P（定位部分）</text>
<text class="diagram-note" x="644" y="309" text-anchor="middle">末端回转轴省略</text>
</g>
<!-- 5 拟人 RRR -->
<g>
<rect x="810" y="205" width="36" height="35" class="diagram-node"/>
<path d="M 802 200 A 26 8 0 1 0 854 200" fill="none" stroke="var(--accent-text)" stroke-width="1.6" marker-end="url(#f29-a)"/>
<circle cx="828" cy="190" r="7" class="diagram-node"/>
<line stroke="var(--accent)" stroke-width="5" x1="828" y1="190" x2="796" y2="120"/>
<circle cx="796" cy="120" r="6" class="diagram-node"/>
<line stroke="var(--accent)" stroke-width="4" x1="796" y1="120" x2="852" y2="78"/>
<circle cx="852" cy="78" r="4" class="diagram-node"/>
<text class="diagram-text" x="828" y="272" text-anchor="middle">拟人</text>
<text class="diagram-mono" x="828" y="291" text-anchor="middle">R R R（未画腕）</text>
<text class="diagram-note" x="828" y="309" text-anchor="middle">肩回转 + 肩俯仰 + 肘</text>
</g>
</svg>
<figcaption>五类定位结构回顾（本教程绘，对照原书图 1.9–1.13）：圆表示 R，双箭头表示 P；完整分类回顾见 [§1.2](../ch01/sec1-2.md)。</figcaption>
</figure>

<a id="sec-2.9.1"></a>

## 2.9.1 三连杆平面臂

三根关节转轴**同向平行**（全部垂直运动平面指向 $+z_0$），故扭角 $\alpha_i=0$；将所有连杆坐标系原点均选在运动平面内且公垂线过前原点，得偏距 $d_i=0$；各 $x_i$ 沿各自连杆方向，得杆长 $a_i$。

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|
| $1$ | $a_1$ | $0$ | $0$ | $\vartheta_1$ |
| $2$ | $a_2$ | $0$ | $0$ | $\vartheta_2$ |
| $3$ | $a_3$ | $0$ | $0$ | $\vartheta_3$ |

将 $\alpha_i=0,\ d_i=0$ 代入 DH 单段公式并沿链相乘，由于同轴旋转矩阵的复合角为关节角之和（令 $c_{12}=\cos(\vartheta_1+\vartheta_2),\ c_{123}=\cos(\vartheta_1+\vartheta_2+\vartheta_3)$ 等）：
$$T_3^0(\boldsymbol q)=A_1^0 A_2^1 A_3^2=
\begin{bmatrix}
c_{123} & -s_{123} & 0 & a_1 c_1+a_2 c_{12}+a_3 c_{123}\\
s_{123} & c_{123} & 0 & a_1 s_1+a_2 s_{12}+a_3 s_{123}\\
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1
\end{bmatrix}.$$
特征十分鲜明：平面臂只能实现平面内位置 $(p_x,p_y)$ 与绕 $z_0$ 轴的单一平面方位角 $\varphi=\vartheta_1+\vartheta_2+\vartheta_3$（3 关节对应 3 个任务自由度）。

::: note 零位核对：物理含义如何一目了然 {#note-2.9.zero}
将 $\vartheta_1=\vartheta_2=\vartheta_3=0$ 代入上式得 $\boldsymbol p=[a_1+a_2+a_3,\ 0,\ 0]^{\mathrm T},\ R=I_3$：三根连杆排成一排沿 $+x_0$ 轴伸直。任意正运动学公式推导完成后，第一件事就应当用零位与 $90^\circ$ 特殊构型检查是否与物理直观吻合。
:::

<div class="lab" data-lab="mech3d" data-mech="planar3r" hidden></div>

<a id="sec-2.9.2"></a>

## 2.9.2 带平行四边形的平面臂（闭链分解）

工业喷涂、码垛等场合常将驱动电机集中固定在基座附近以降低末端惯量，用四杆平行四边形连杆机构将基座第二个电机角传递至肘部。此结构含闭运动环，按[§2.8.3 闭链处理法](sec2-8.md#sec-2.8.3)在远端铰链作虚拟切开后分为两支：

- **分支 1（主臂链 $0\to 1'\to 2'$）**：连杆 $1'$ 相对基座角 $\vartheta_1'$，杆 $2'$ 相对杆 $1'$ 角 $\vartheta_2'$，杆长分别为 $a_1',a_2'$；
- **分支 2（平行传动链 $0\to 1''\to 2''$）**：杆 $1''$ 相对基座角 $\vartheta_1''$，杆 $2''$ 相对杆 $1''$ 角 $\vartheta_2''$，杆长分别为 $a_1'',a_2''$。

记两根驱动角为 $\vartheta_1' 与 \vartheta_1''$，其余为被动角。利用平行四边形几何与两路径闭合条件可得各被动角的等价驱动表达。

::: thm 原理 2.9.2.A · 平行四边形闭链传动正运动学（原书 §2.9.2） {#thm-2.9.2.A}
以 $\vartheta_1',\ \vartheta_1''$ 为驱动角，在平行四边形装配分支下，前臂连杆 $2'$ 与驱动连杆 $1''$ 保持同向平行（相对第一杆夹角 $\vartheta_2'=\vartheta_1''-\vartheta_1'$，而回溯副杆段转角为 $\vartheta_1''-\vartheta_1'+\pi$），化简后末端系 $\{3\}$（由关节 3 相对前臂偏转 $\vartheta_3$）位姿为
$$T_3^0(\boldsymbol q)=
\begin{bmatrix}
c_{1''3} & -s_{1''3} & 0 & a_1'c_{1'}+a_2'c_{1''}+a_3 c_{1''3}\\
s_{1''3} & c_{1''3} & 0 & a_1's_{1'}+a_2's_{1''}+a_3 s_{1''3}\\
0 & 0 & 1 & 0\\
0 & 0 & 0 & 1
\end{bmatrix},$$
其中记号 $c_{1''3}=\cos(\vartheta_1''+\vartheta_3)$。物理上**电机 $\vartheta_1'$ 直接控制第一臂杆方向，电机 $\vartheta_1''$ 直接决定前臂 $a_2'$ 在世界坐标系下的绝对俯仰角**（从而解耦了前臂与大臂之间的角度耦合）。
:::

::: ex 例 2.9.A · 验证切开两分支与闭合路径完全一致 {#ex-2.9.A}
取具体尺寸 $a_1'=1\text{ m},\ a_2'=0.8\text{ m},\ a_1''=0.3\text{ m},\ a_2''=1\text{ m},\ a_3=0.5\text{ m}$，驱动角 $\vartheta_1'=30^\circ,\ \vartheta_1''=75^\circ,\ \vartheta_3=20^\circ$。沿主臂分支与平行链分支核对闭合铰链位姿。

::: sol 计算核对
两臂角度均为绝对方位角表达：
- 大臂外端位置 $\boldsymbol p_1'=a_1'[\cos 30^\circ,\sin 30^\circ]^{\mathrm T}=[0.8660,0.5000]^{\mathrm T}\text{ m}$；
- 平行副杆末端 $\boldsymbol p_1''=a_1''[\cos 75^\circ,\sin 75^\circ]^{\mathrm T}=[0.0776,0.2898]^{\mathrm T}\text{ m}$；
- 主路径经肘部回推前臂尾端或直抵末端：$\boldsymbol p_{\mathrm{end}} = \boldsymbol p_1' + a_2'[\cos 75^\circ,\sin 75^\circ]^{\mathrm T} + a_3[\cos 95^\circ,\sin 95^\circ]^{\mathrm T} = [1.0295,\ 1.7708]^{\mathrm T}\text{ m}$。
验证 $a_2'$ 与 $a_1'$ 的平行链对角点：$\boldsymbol p_1' + a_1''[\cos 75^\circ,\sin 75^\circ]^{\mathrm T} = [0.9437,\ 0.7898]^{\mathrm T} = \boldsymbol p_1'' + a_2''[\cos 30^\circ,\sin 30^\circ]^{\mathrm T}$，两条树路径严丝合缝重合。
:::
:::

<div class="lab" data-lab="mech3d" data-mech="para" hidden></div>

<a id="sec-2.9.3"></a>

## 2.9.3 球形臂（Spherical Arm，RRP）

球形臂由腰回转（$\vartheta_1$，绕竖直轴 $z_0$）、肩俯仰（$\vartheta_2$，绕水平轴 $z_1$）与径向伸缩（$d_3$，沿臂杆轴 $z_2$）组成，可带有结构常偏置（如肩关节侧面偏移 $d_2\ne 0$）。其关节轴空间关系：轴 1 与轴 2 正交（不相交时公垂线即偏置 $d_2$ 沿 $z_1$ 或由交点移出；常见标准建模将肩水平偏距记在 $d_2$ 上，使 $a_1=a_2=0$）；轴 2 与轴 3 垂直正交。按标准 DH 选系得参数表：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|
| 1 | 0 | -\pi/2 | 0 | \vartheta_1 |
| 2 | 0 | \pi/2 | d_2 | \vartheta_2 |
| 3 | 0 | 0 | d_3 | 0 |

将三行分别代入 DH 矩阵通式：
$$A_1^0=\begin{bmatrix}c_1 & 0 & -s_1 & 0\\ s_1 & 0 & c_1 & 0\\ 0 & -1 & 0 & 0\\ 0 & 0 & 0 & 1\end{bmatrix},\quad
A_2^1=\begin{bmatrix}c_2 & 0 & s_2 & 0\\ s_2 & 0 & -c_2 & 0\\ 0 & 1 & 0 & d_2\\ 0 & 0 & 0 & 1\end{bmatrix},\quad
A_3^2=\begin{bmatrix}1 & 0 & 0 & 0\\ 0 & 1 & 0 & 0\\ 0 & 0 & 1 & d_3\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
右乘得到球形臂的 $T_3^0(\boldsymbol q)$（$\boldsymbol q=[\vartheta_1,\vartheta_2,d_3]^{\mathrm T}$）：
$$T_3^0(\boldsymbol q)=A_1^0 A_2^1 A_3^2=
\begin{bmatrix}
c_1 c_2 & -s_1 & c_1 s_2 & c_1 s_2 d_3 - s_1 d_2\\
s_1 c_2 & c_1 & s_1 s_2 & s_1 s_2 d_3 + c_1 d_2\\
-s_2 & 0 & c_2 & c_2 d_3\\
0 & 0 & 0 & 1
\end{bmatrix}.$$
取特殊值复核：当 $\vartheta_1=\vartheta_2=0$ 时，伸缩杆 $z_3=z_2=[0,0,1]^{\mathrm T}$ 竖直向上指，原点落在 $[-0, d_2, d_3]^{\mathrm T}=[0, d_2, d_3]^{\mathrm T}$，清楚呈现出横向肩偏距 $d_2$ 沿 $+y_0$（旋转 $-s_1 d_2, c_1 d_2$）与伸长量 $d_3$ 沿球坐标径向的耦合效应。

<div class="lab" data-lab="mech3d" data-mech="spherical" hidden></div>

<a id="sec-2.9.4"></a>

## 2.9.4 拟人臂（Anthropomorphic Arm，RRR）

拟人臂把球形臂的第 3 个移动关节替换为平行于轴 2 的肘俯仰转动关节 $\vartheta_3$（[§2.8.2 例解](sec2-8.md#method-2.8.anthro)已详述建系过程）。轴 1 与轴 2 正交交于肩点，轴 2 与轴 3 同向平行且间距为上臂长 $a_2$，前臂长为 $a_3$：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|
| $1$ | $0$ | $\pi/2$ | $0$ | $\vartheta_1$ |
| $2$ | $a_2$ | $0$ | $0$ | $\vartheta_2$ |
| $3$ | $a_3$ | $0$ | $0$ | $\vartheta_3$ |

各局部矩阵为
$$A_1^0=\begin{bmatrix}c_1 & 0 & s_1 & 0\\ s_1 & 0 & -c_1 & 0\\ 0 & 1 & 0 & 0\\ 0 & 0 & 0 & 1\end{bmatrix},\quad
A_2^1=\begin{bmatrix}c_2 & -s_2 & 0 & a_2 c_2\\ s_2 & c_2 & 0 & a_2 s_2\\ 0 & 0 & 1 & 0\\ 0 & 0 & 0 & 1\end{bmatrix},\quad
A_3^2=\begin{bmatrix}c_3 & -s_3 & 0 & a_3 c_3\\ s_3 & c_3 & 0 & a_3 s_3\\ 0 & 0 & 1 & 0\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
注意到后两段处于同一垂直面，先算 $A_3^1=A_2^1 A_3^2$ 可合并角度为 $\vartheta_2+\vartheta_3$，再左乘 $A_1^0$ 得
$$T_3^0(\boldsymbol q)=A_1^0 A_2^1 A_3^2=
\begin{bmatrix}
c_1 c_{23} & -c_1 s_{23} & s_1 & c_1(a_2 c_2+a_3 c_{23})\\
s_1 c_{23} & -s_1 s_{23} & -c_1 & s_1(a_2 c_2+a_3 c_{23})\\
s_{23} & c_{23} & 0 & a_2 s_2+a_3 s_{23}\\
0 & 0 & 0 & 1
\end{bmatrix}.$$
令 $r=a_2 c_2+a_3 c_{23}$ 表示末端在水平面内相对肩轴的径向投影，则 $\boldsymbol p_3^0=[c_1 r,\ s_1 r,\ a_2 s_2+a_3 s_{23}]^{\mathrm T}$：直观上看就是先在垂直面内组成一根平面两杆手臂 $(r, z)$，再整体绕竖直肩轴旋转 $\vartheta_1$。

<div class="lab" data-lab="anthro3d" hidden></div>

<a id="sec-2.9.5"></a>

## 2.9.5 球形腕（Spherical Wrist）

要将定位臂与末端朝向控制分开，工业 6R 机械臂末端常配置三根转动轴交于同一点（**腕心 $W$**）且两两正交的**球形腕**（关节 $4,5,6$）。取坐标系 $\{3\}$（腕基）的 $z_3$ 沿轴 4 指向腕心，$o_3=o_4=o_5$ 取在腕心，末杆系 $\{6\}$ 原点沿 $z_5$（即工具接近轴）外移 $d_6$ 至末端执行器表面，则标准 DH 表为：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|
| $4$ | $0$ | $-\pi/2$ | $0$ | $\vartheta_4$ |
| $5$ | $0$ | $\pi/2$ | $0$ | $\vartheta_5$ |
| $6$ | $0$ | $0$ | $d_6$ | $\vartheta_6$ |

逐段写出：
$$A_4^3=\begin{bmatrix}c_4 & 0 & -s_4 & 0\\ s_4 & 0 & c_4 & 0\\ 0 & -1 & 0 & 0\\ 0 & 0 & 0 & 1\end{bmatrix},\quad
A_5^4=\begin{bmatrix}c_5 & 0 & s_5 & 0\\ s_5 & 0 & -c_5 & 0\\ 0 & 1 & 0 & 0\\ 0 & 0 & 0 & 1\end{bmatrix},\quad
A_6^5=\begin{bmatrix}c_6 & -s_6 & 0 & 0\\ s_6 & c_6 & 0 & 0\\ 0 & 0 & 1 & d_6\\ 0 & 0 & 0 & 1\end{bmatrix}.$$
连乘得（原书式 2.71）
$$T_6^3(\boldsymbol q)=A_4^3 A_5^4 A_6^5=
\begin{bmatrix}
c_4 c_5 c_6 - s_4 s_6 & -c_4 c_5 s_6 - s_4 c_6 & c_4 s_5 & c_4 s_5 d_6\\
s_4 c_5 c_6 + c_4 s_6 & -s_4 c_5 s_6 + c_4 c_6 & s_4 s_5 & s_4 s_5 d_6\\
-s_5 c_6 & s_5 s_6 & c_5 & c_5 d_6\\
0 & 0 & 0 & 1
\end{bmatrix}.$$
核心结构一目了然：
1. **旋转块就是标准 ZYZ 欧拉角**：对比[§2.4.2](sec2-4.md#sec-2.4.2)，左上角 $3\times 3$ 矩阵恰为 $R_6^3 = R_z(\vartheta_4)R_y(\vartheta_5)R_z(\vartheta_6)$！这是[§2.12](sec2-12.md)球形腕逆解可以直接套用 ZYZ 反解公式的代数根源；
2. **第 4 列位置仅沿 $\boldsymbol a_6$ 偏移 $d_6$**：$\boldsymbol p_6^3 = d_6\cdot R_6^3\boldsymbol e_z$，意味着从工具末端倒退 $d_6\boldsymbol a_e$ 必定回到腕心位置（该位置完全不随腕关节角度 $\vartheta_4,\vartheta_5,\vartheta_6$ 改变）；
3. **腕奇异点**：当 $\vartheta_5=0$ 或 $\pi$（$s_5=0$）时，轴 4 与轴 6 共线，腕旋转自由度损失 1 个，仅由 $\vartheta_4+\vartheta_6$（或 $\vartheta_4-\vartheta_6$）决定绕共轴总转角，对应[§2.4](sec2-4.md)中的 ZYZ 欧拉角表示奇异。

<div class="lab" data-lab="wrist3d" hidden></div>

<a id="sec-2.9.6"></a>

## 2.9.6 斯坦福机械手（Stanford Manipulator）

将 **2.9.3 球形臂**（定位机构，末端 $z_3$ 本就沿径向伸缩轴）直接串接 **2.9.5 球形腕**（定向机构，输入轴 $z_3$ 沿轴 4），两段接口坐标系 $\{3\}$ 完全一致（$z_3$ 均沿大臂延伸指向腕心），无需任何过渡矩阵！

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|
| 1 | 0 | -\pi/2 | 0 | \vartheta_1 |
| 2 | 0 | \pi/2 | d_2 | \vartheta_2 |
| 3 | 0 | 0 | d_3 | 0 |
| $4$ | $0$ | $-\pi/2$ | $0$ | $\vartheta_4$ |
| $5$ | $0$ | $\pi/2$ | $0$ | $\vartheta_5$ |
| $6$ | $0$ | $0$ | $d_6$ | $\vartheta_6$ |

正运动学只需把 $T_3^0(\vartheta_1,\vartheta_2,d_3)$ 与 $T_6^3(\vartheta_4,\vartheta_5,\vartheta_6)$ 直接相乘：$T_6^0=T_3^0 T_6^3$。因腕部正交点紧跟在第 3 轴终点，其腕心位置仅取决于前 3 个关节：
$$\boldsymbol p_W^0=\boldsymbol p_3^0=\begin{bmatrix}c_1 s_2 d_3-s_1 d_2\\ s_1 s_2 d_3+c_1 d_2\\ c_2 d_3\end{bmatrix},\qquad \boldsymbol p_6^0 = \boldsymbol p_W^0 + d_6 R_6^0\boldsymbol e_z.$$

<div class="lab" data-lab="mech3d" data-mech="stanford" hidden></div>

<a id="sec-2.9.7"></a>

## 2.9.7 带球形腕的拟人机械臂

能否把 **2.9.4 拟人臂**的 $T_3^0$ 与 **2.9.5 球形腕**的 $T_6^3$ 直接相乘？**不能！**
原因在于接口坐标系 $\{3\}$ 的方向约定不匹配：
- 在单独的 2.9.4 拟人臂中，因未配腕，末端 $z_3$ 取为与关节 3 平行（沿肘俯仰方向，$x_3$ 沿前臂），故有 $a_3\ne 0,\ \alpha_3=0$；
- 而 2.9.5 球形腕要求输入轴 $z_3$ **沿轴 4（即沿前臂轴线直接贯穿腕心）**！

因此，为把拟人臂与球形腕按标准 DH 无缝对接，须对第 3 行建系作出关键调整（使 $z_3$ 沿前臂指向腕心，原点 $o_3$ 直接落在腕心，从而 $a_3$ 退为 $0$，而原前臂长度转化为沿新 $z_3$ 的偏距 $d_4$）：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ | 接口对比要点 |
|:--:|:--:|:--:|:--:|:--:|:--|
| $1$ | $0$ | $\pi/2$ | $0$ | $\vartheta_1$ | 同前 |
| $2$ | $a_2$ | $0$ | $0$ | $\vartheta_2$ | 同前 |
| $3$ | $0$ | $\pi/2$ | $0$ | $\vartheta_3$ | **原 $a_3$ 消零，扭角改为 $\pi/2$ 以对准轴 4** |
| $4$ | $0$ | $-\pi/2$ | $d_4$ | $\vartheta_4$ | **前臂长移入 $d_4$（沿 $z_3$）** |
| $5$ | $0$ | $\pi/2$ | $0$ | $\vartheta_5$ | 同球形腕 |
| $6$ | $0$ | $0$ | $d_6$ | $\vartheta_6$ | 同球形腕 |

连乘前 3 关节与后 3 关节，注意第 3 杆扭角 $\alpha_3=\pi/2$ 使旋转块中的轴序置换，且 $x_3$（零位随连杆垂直）经 $\vartheta_3$ 补偿。腕心位置由前 3 个角与上臂长 $a_2$、前臂长 $d_4$ 唯一决定（当用该建系 $\vartheta_3=0$ 时前臂弯折 $90^\circ$）：
$$\boldsymbol p_W^0=\begin{bmatrix}c_1(a_2 c_2+d_4 s_{23})\\ s_1(a_2 c_2+d_4 s_{23})\\ a_2 s_2-d_4 c_{23}\end{bmatrix},\qquad R_3^0=\begin{bmatrix}c_1 c_{23} & s_1 & c_1 s_{23}\\ s_1 c_{23} & -c_1 & s_1 s_{23}\\ s_{23} & 0 & -c_{23}\end{bmatrix}.$$
而 $R_6^0 = R_3^0 R_6^3$，可见仅改换 $\{3\}$ 系接口就改变了 $R_3^0$ 列的排布与正负号，**不可未经接口核对直接拼接模块矩阵**。

<div class="lab" data-lab="mech3d" data-mech="anthroWrist" hidden></div>

<a id="sec-2.9.8"></a>

## 2.9.8 7 自由度拟人机械臂（DLR 构形）

空间任务仅需 6 个自由度（3 位置 + 3 姿态）。如果在拟人肩部（正交两轴）之后在肘前或肩臂段串联第 7 个转动关节，即构成典型的 **7-DOF 冗余拟人机械臂**（如德国宇航中心 DLR 轻型臂，S–R–S 球肩–肘–球腕对称骨架）。七个关节的扭角均在 $\pm\pi/2$ 间交替，且全部 $a_i=0$，连杆距离全落在奇数列 $(d_1,d_3,d_5,d_7)$：

| 连杆 $i$ | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--:|:--:|:--:|:--:|:--:|
| $1$ | $0$ | $\pi/2$ | $d_1$ | $\vartheta_1$ |
| $2$ | $0$ | $-\pi/2$ | $0$ | $\vartheta_2$ |
| $3$ | $0$ | $\pi/2$ | $d_3$ | $\vartheta_3$ |
| $4$ | $0$ | $-\pi/2$ | $0$ | $\vartheta_4$ |
| $5$ | $0$ | $\pi/2$ | $d_5$ | $\vartheta_5$ |
| $6$ | $0$ | $-\pi/2$ | $0$ | $\vartheta_6$ |
| $7$ | $0$ | $0$ | $d_7$ | $\vartheta_7$ |

该机构拥有 1 个运动学冗余度：当腕心位置与末端姿态（共 6 维约束）完全锁定时，肘关节仍可绕「肩心—腕心」连线自由旋转一整圈（称为**臂角自运动流形**），用于工业生产中的实时避障、避开关节限位与远离内部奇异位形。

<div class="lab" data-lab="mech3d" data-mech="dlr" hidden></div>

<a id="sec-2.9.9"></a>

## 2.9.9 双臂类人机械系统（17 DOF）

类人双臂系统由一根共享的 **3-DOF 躯干**（如骨盆腰部仰角–侧倾–回转）在胸肩处**分叉**出左臂与右臂两条各自 **7-DOF** 的拟人臂组成（总自由度 $3+7+7=17$）。此类机构属**树状开链**（branched open chain）：先求躯干顶端相对世界参考系的变换 $T_t^w(\boldsymbol q_{\mathrm{torso}})$，再经两侧固定的常值安装变换 $T_{R,b}^t,\ T_{L,b}^t$ 分别连乘左右两臂各自的 7-DOF 变换链，即可同时得到左右手位姿。

<a id="sec-2.9"></a>

::: ex 例 2.9.B · 横向对照与快速判断 {#ex-2.9.B}
对比下表所述四种常见 3/4 轴骨架的自由度配置与关键 DH 非零项，检查是否能快速定位其类型与特征方程：

| 构形 | 关节序列 | 非零常参数（仅看前 3 轴） | 变量向量 | 腕心或末端特征 |
|:--|:--|:--|:--|:--|
| 平面 3R | R–R–R | $a_1,a_2,a_3$ | $(\vartheta_1,\vartheta_2,\vartheta_3)^{\mathrm T}$ | 在 $xy$ 平面运动，角相加 |
| 圆柱形臂 | R–P–P | $\alpha_2=-\pi/2$ | $(\vartheta_1,d_2,d_3)^{\mathrm T}$ | 柱坐标 $p_x=-d_3 s_1,\ p_y=d_3 c_1,\ p_z=d_2$ |
| 球形臂 | R–R–P | $\alpha_1=-\pi/2,\ \alpha_2=\pi/2,\ d_2$ | $(\vartheta_1,\vartheta_2,d_3)^{\mathrm T}$ | 球坐标式伸缩 + 肩侧偏距 $d_2$ |
| 拟人臂（无腕） | R–R–R | $\alpha_1=\pi/2,\ a_2,\ a_3$ | $(\vartheta_1,\vartheta_2,\vartheta_3)^{\mathrm T}$ | 平面两杆 $r(\vartheta_2,\vartheta_3)$ 绕竖轴 $\vartheta_1$ 回转 |
:::

::: think 默写点 · 合上书自检
1. 球形腕 3 轴交于腕心时，$R_6^3$ 等价于哪种欧拉角表示？其奇异发生在何时？
2. 为什么不能把「无腕拟人臂的 $T_3^0$」与「球形腕的 $T_6^3$」直接相乘？应当修改参数表哪两处？

::: sol 核对
1. $R_6^3 = R_z(\vartheta_4)R_y(\vartheta_5)R_z(\vartheta_6)$，即为标准 ZYZ 欧拉角；奇异在 $s_5=0$（$\vartheta_5=0$ 或 $\pi$），轴 4 与轴 6 共线。
2. 因无腕拟人臂末轴 $z_3$ 沿肘关节轴（垂直前臂），而球形腕要求 $z_3$ 沿前臂轴贯穿腕心；对接须令第 3 杆 $a_3=0,\ \alpha_3=\pi/2$，并将原前臂长度移作第 4 行的偏距 $d_4$。
:::
:::

## 2.9 小结

- 九种典型结构并非九套孤立公式，而是**定位核心**（平面 3R、圆柱、球形、拟人）、**定向核心**（球形腕 = ZYZ 欧拉角）与**连接接口**（检查 $z_3$ 方向与 $a_3\to d_4$ 过渡）的模块化组合。
- 涉及闭环时（2.9.2 平行四边形臂），通过切口转化树链与闭合约束消元，其物理意义等价于将第 2 电机绝对化以解耦俯仰惯量。

::: think 本节常见错误自查
1. 误将带腕拟人臂的 $a_3,d_4$ 套用在无腕拟人臂上，或将两端 $T_3^0$ 与 $T_6^3$ 盲目直接相乘；
2. 在球形臂建模中漏掉横向肩偏移 $d_2$（令 $p_x,p_y$ 中丢失 $-s_1 d_2,+c_1 d_2$）；
3. 忘记零位检查：写完连乘式后应立即代入 $\boldsymbol q=\boldsymbol 0$ 检验连杆指向与几何常识是否一致。
:::

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 约 1:18:18 | [planar3-dh.jpg](../assets/ch02/planar3-dh.jpg) | 三连杆平面臂建系图与参数表 | 2.9.1 节完整给出，配零位验证与 3D 实验室 |
| 约 1:19:53 | [planar3-t3.jpg](../assets/ch02/planar3-t3.jpg) | 三连杆平面臂 $T_3^0$ 矩阵 | 2.9.1 节合并三角角度后完整写出 |
| 约 1:23:18 | [spherical-arm.jpg](../assets/ch02/spherical-arm.jpg) | 球形臂建系与 $T_3^0$ | 2.9.3 节完整推演并突出横向偏移 $d_2$ 的作用 |
| 约 1:34:05 | [spherical-wrist.jpg](../assets/ch02/spherical-wrist.jpg) | 球形腕建系与 ZYZ 矩阵 | 2.9.5 节完整推演并对齐 ZYZ 与奇异点条件 |
| 约 1:39:11 | [stanford.jpg](../assets/ch02/stanford.jpg) | 斯坦福机械手组合表 | 2.9.6 节与 2.9.7 节对照给出接口统一条件 |
:::
