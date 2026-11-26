# 5.4 外部传感器与测量变换

本页子节：
- [5.4.1 力传感器与六维腕力变换](#part-5.4.1)
- [5.4.2 接近觉、触觉、距离传感器与融合基础](#part-5.4.2)
- [5.4.3 视觉传感器与相机模型](#part-5.4.3)

本体传感器仅闭合了机械手「自身关节姿态与速度」的内环控制；机械手要在非结构化环境里抓取零件、顺应装配、躲避障碍或视觉对准，必须借助**外部传感器（exteroceptive sensors）**测量周围环境特征及机器人—环境交互状态。本节重点建立力学变换、距离几何测量与针孔视觉投影的定量数学模型。

::: note 考纲定位 · 重点掌握（硬件工艺细节作了解·精简）
**惠斯通电桥线性化与温补/半桥**、**六维腕力传感器校准矩阵与向约束系的等价力/力矩变换**（对应[作业五 5.6](homework05.md)）、**声纳测距与温度补偿**、**激光 ToF 与三角测距模型**、以及**理想针孔相机四步投影矩阵 $\Xi=\Omega\Pi(T^b_c)^{-1}$**（对应[作业五 5.7](homework05.md)）均为本章核心可算内容；声纳/CCD 器件内部制造工艺作了解。
:::

<a id="sec-5.4.0"></a>
<a id="sec-5.4"></a>

::: def 定义 5.4.1 · 外部传感器与环境感知使命 {#def-5.4.1}
**外部传感器**负责提取周围环境的状态信息以及机械手与目标交互时产生的物理特征（**力、触觉、接近觉、距离、视觉**以及温度、湿度、压力、烟尘等特殊应用传感器），为机器人实现自主决策（第 9 章力控制与第 10 章视觉伺服）及多传感器融合高层规划提供物理输入。
:::

::: intuition 动手实验 · 外部传感器在机械臂上的装卡与视场范围（3D）
切换观察末端腕力圆盘、超声/激光探测视场锥及手眼相机坐标系朝向，直观理解为何腕力必须经坐标搬移才能用于接触点控制。

<div class="lab" data-lab="sensor3d"></div>
:::

::: note 外部传感器使命：从底层测量到自主规划 {#note-5.4.1}
将外部传感器测得的环境特征与本体里程/运动学状态经**数据融合（如卡尔曼滤波）**结合，构成机器人自主系统中「**由感知到执行**」的闭环入口。
:::

<a id="part-5.4.1"></a>
<a id="sec-5.4.1.1"></a>

## 5.4.1 力传感器与六维腕力变换

### 张力计（应变片）与惠斯通电桥

::: def 定义 5.4.2 · 电阻应变片与惠斯通电桥线性输出（原书式 5.30） {#def-5.4.2}
工业力与转矩传感器通过测量高刚度可扩张弹性体受力产生的微应变来间接读力。**张力计（应变片，strain gauge）**粘贴于弹性体表面，在小变形线性弹性区内，其相对电阻变化正比于正应变 $\varepsilon=\Delta l/l$：
$$\frac{\Delta R_s}{R_s}\approx K_g\,\varepsilon,$$
其中 $K_g$ 为应变灵敏系数。将电阻 $R_s$ 接入激励电压为 $V_i$、另三臂为 $R_1,R_2,R_3$ 的**惠斯通电桥**：
$$V_o=\left(\frac{R_2}{R_1+R_2}-\frac{R_s}{R_3+R_s}\right)V_i.$$
取静态平衡 $R_1=R_2=R_3=R_s=R$，在微小变化 $|\Delta R_s|\ll R$ 处作一阶泰勒展开得线性比例关系：
$$V_o\approx -\frac{V_i}{4}\,\frac{\Delta R_s}{R}\approx -\frac{V_i}{4}\,K_g\varepsilon.$$
工程上将第二个同规格应变片接在电桥相邻臂上可实现两项关键优化：(1) **温度补偿**——将第二片贴于同温但**不受机械应力**部位，因同号电阻热漂在差动减法中自动消去；(2) **半桥差动增敏**——将两片分别贴于弯曲梁受拉与受压对称两侧（$\pm\Delta R_s$），桥路输出幅值直接**翻倍**为 $-\frac{V_i}{2}K_g\varepsilon$。
:::

<a id="sec-5.4.1.2"></a>

### 轴转矩传感器（注意测量口径差别）

**轴转矩传感器**串联在伺服电机与关节之间，采用一段特殊设计的**中空弹性转轴**（低抗扭刚度以放大扭转应变，高抗弯刚度以抗弯矩串扰），应变片呈 $45^\circ$ 扭转主应力方向粘贴并通过集电环—石墨电刷引出信号。**关键测量口径辨析**：它测得的是「传递至下游关节轴的轴端转矩」，**不包含**传感器上游转子转动惯量、摩擦损耗及上游齿轮传动效应，因此**不等于**执行系统框图中的电机电磁转矩 $C_m$。

<figure>
<svg class="figure-svg" viewBox="0 0 900 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-5412-t fig-5412-d">
<title id="fig-5412-t">轴转矩传感器：夹在马达与关节之间的中空转轴</title>
<desc id="fig-5412-d">左侧为伺服马达，右侧为关节，中间一段中空转轴，转轴表面按 45 度粘贴应变片（惠斯通电桥）；转轴下方用集电环与石墨电刷把电桥信号引出，输出与作用转矩成比例的不平衡信号。标注：低抗扭刚度使扭转产生可测的张力，高抗弯刚度避免弯曲干扰。</desc>
<defs>
<marker id="f5412-a" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<rect x="30" y="60" width="110" height="80" rx="8" fill="none" stroke="var(--line-strong)" stroke-width="1.4"/>
<text class="diagram-note" x="85" y="105" text-anchor="middle">伺服马达</text>
<line x1="140" y1="100" x2="162" y2="100" stroke="var(--muted)" stroke-width="1.6" marker-end="url(#f5412-a)"/>
<rect x="165" y="75" width="260" height="50" fill="none" stroke="var(--fig-blue)" stroke-width="1.8"/>
<rect x="165" y="93" width="260" height="14" fill="none" stroke="var(--line-strong)" stroke-width="1.2" stroke-dasharray="5 4"/>
<line x1="200" y1="75" x2="238" y2="125" stroke="var(--fig-gold)" stroke-width="2"/>
<line x1="300" y1="75" x2="338" y2="125" stroke="var(--fig-gold)" stroke-width="2"/>
<text class="diagram-note" x="295" y="66" text-anchor="middle">中空转轴：应变片按 45° 粘贴（惠斯通电桥）</text>
<line x1="425" y1="100" x2="447" y2="100" stroke="var(--muted)" stroke-width="1.6" marker-end="url(#f5412-a)"/>
<rect x="450" y="60" width="110" height="80" rx="8" fill="none" stroke="var(--line-strong)" stroke-width="1.4"/>
<text class="diagram-note" x="505" y="105" text-anchor="middle">关节</text>
<text class="diagram-note" x="600" y="80">低抗扭刚度：扭转有可测张力</text>
<text class="diagram-note" x="600" y="106">高抗弯刚度：弯曲不干扰</text>
<text class="diagram-note" x="600" y="132">测得转矩 ≠ C_m</text>
<text class="diagram-note" x="600" y="156">（缺惯性、摩擦与上游传动）</text>
<rect x="345" y="150" width="42" height="28" rx="4" fill="none" stroke="var(--line-strong)"/>
<rect x="352" y="157" width="28" height="14" rx="3" fill="none" stroke="var(--fig-gold)"/>
<text class="diagram-note" x="366" y="200" text-anchor="middle">集电环 + 石墨电刷</text>
<line x1="400" y1="164" x2="556" y2="200" stroke="var(--muted)" stroke-width="1.4" marker-end="url(#f5412-a)"/>
<rect x="560" y="176" width="300" height="62" rx="8" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="710" y="202" text-anchor="middle">输出：与作用转矩成比例的不平衡信号</text>
<text class="diagram-note" x="710" y="224" text-anchor="middle">（电刷—集电环同时给电桥供激励）</text>
</svg>
<figcaption>轴转矩传感器结构与信号口径辨析（本教程绘）：所测转矩不等于电机侧电磁驱动力矩 $C_m$。</figcaption>
</figure>

<a id="sec-5.4.1.3"></a>

### 六维腕力传感器与校准矩阵

::: def 定义 5.4.3 · 腕力传感器与马耳他十字结构 {#def-5.4.3}
**腕力传感器（wrist force sensor）**安装在机器人前臂末端与夹爪之间，同步测量作用在传感器坐标系 $\{s\}$ 原点上的三维正交力 $\boldsymbol f^s_s=[f^s_x,f^s_y,f^s_z]^{\mathrm T}$ 与三维力矩 $\boldsymbol\mu^s_s=[\mu^s_x,\mu^s_y,\mu^s_z]^{\mathrm T}$。典型构型采用**马耳他十字**弹性体：由 4 根正交平行六面体弹性棒连接内外圈，每棒相对两侧粘贴张力计组成惠斯通电桥，输出 8 路电压信号 $\boldsymbol w=[w_1,\dots,w_8]^{\mathrm T}$（典型量程：力 $50\text{–}500\,\mathrm N$、力矩 $5\text{–}70\,\mathrm{N\cdot m}$，采样频率约 $1\,\mathrm{kHz}$）。
:::

::: thm 定理 5.4.A · 六维力校准解耦矩阵（原书式 5.31） {#thm-5.4.A}
因弹性体存在机械交叉耦合敏感度，厂商出厂标定给出 $6\times 8$ **校准矩阵** $\Phi$，将 8 路电桥电压线性解耦为相对传感器系 $\{s\}$ 的六维广义力：
$$\begin{bmatrix} f^s_x \\ f^s_y \\ f^s_z \\ \mu^s_x \\ \mu^s_y \\ \mu^s_z \end{bmatrix}
=
\begin{bmatrix}
0 & 0 & c_{13} & 0 & 0 & 0 & c_{17} & 0 \\
c_{21} & 0 & 0 & 0 & c_{25} & 0 & 0 & 0 \\
0 & c_{32} & 0 & c_{34} & 0 & c_{36} & 0 & c_{38} \\
0 & 0 & 0 & c_{44} & 0 & 0 & 0 & c_{48} \\
0 & c_{52} & 0 & 0 & 0 & c_{56} & 0 & 0 \\
c_{61} & 0 & c_{63} & 0 & c_{65} & 0 & c_{67} & 0
\end{bmatrix}
\begin{bmatrix} w_1 \\ w_2 \\ w_3 \\ w_4 \\ w_5 \\ w_6 \\ w_7 \\ w_8 \end{bmatrix}.$$
采用 8 路而非 6 路输出是为了增加测量冗余度、提升各向通道信噪比。
:::

<a id="sec-5.4.1.4"></a>

### 传感器系 $\{s\}$ 到约束/接触系 $\{c\}$ 的力/力矩变换

传感器读数作用在自身原点 $O_s$，力控制则需要在接触点处的**约束坐标系 $\{c\}$（或末端系 $\{e\}$）**里计算，必须做三维方向旋转与参考点力矩搬移。

::: method 方法 5.4.B · 传感器坐标系到约束坐标系的等价变换 {#method-5.4.B}
设 $R^c_s\in SO(3)$ 为将 $\{s\}$ 系矢量坐标旋转表达至 $\{c\}$ 系的旋转矩阵，**$\boldsymbol r^c_{cs}\in\mathbb R^3$ 为传感器原点 $O_s$ 在约束坐标系 $\{c\}$ 中的位置矢量**（矢量箭头由 $O_c$ 指向 $O_s$）。则约束系 $\{c\}$ 中的等价力与等价力矩为：
$$\begin{bmatrix}\boldsymbol f^c_c\\\boldsymbol\mu^c_c\end{bmatrix}
=\begin{bmatrix}R^c_s & O\\ S(\boldsymbol r^c_{cs})R^c_s & R^c_s\end{bmatrix}
\begin{bmatrix}\boldsymbol f^s_s\\\boldsymbol\mu^s_s\end{bmatrix}.$$
若末端安装了夹具且做大加速度运动，求真实接触外力前还须扣除工具自身重力与运动惯性力；两系固连时 $R^c_s$ 与 $\boldsymbol r^c_{cs}$ 为常值。
:::

::: proof 证明（参考点迁移方向符号检查）
合力向量自由平移不变，旋转后即得 $\boldsymbol f^c_c=R^c_s\boldsymbol f^s_s$。按刚体静力学对点矩平移定理，从传感器原点 $O_s$ 搬移到约束点 $O_c$ 应取 $\boldsymbol\mu^c_c = R^c_s\boldsymbol\mu^s_s + \boldsymbol r_{O_c\to O_s}^c \times \boldsymbol f^c_c$；因已知矢量 $\boldsymbol r^c_{cs}$ 恰好由 $O_c$ 指向 $O_s$，直接有
$$\boldsymbol\mu^c_c = R^c_s\boldsymbol\mu^s_s + \boldsymbol r^c_{cs}\times(R^c_s\boldsymbol f^s_s) = R^c_s\boldsymbol\mu^s_s + S(\boldsymbol r^c_{cs})R^c_s\boldsymbol f^s_s.$$
（若题面改给由 $O_s$ 指向 $O_c$ 的矢量 $\boldsymbol r_{sc}$，则搬移项符号必须取负。）$\square$
:::

::: ex 例题 5.4.C · 六维腕力参考点迁移数值验算（对应作业五 5.6） {#ex-5.4.C}
已知 $\boldsymbol r^c_{cs}=[-0.3,\ 0,\ 0.2]^{\mathrm T}\text{ m}$，$R^c_s=\begin{bmatrix}0&0&1\\0&-1&0\\1&0&0\end{bmatrix}$，传感器读数 $\boldsymbol f^s_s=[20,0,0]^{\mathrm T}\text{ N},\ \boldsymbol\mu^s_s=[0,6,0]^{\mathrm T}\text{ N}\cdot\text{m}$。求约束系中的等价力与力矩。

::: sol 解答
计算旋转与迁移力臂叉乘项：
$$\boldsymbol f^c_c=R^c_s\boldsymbol f^s_s=\begin{bmatrix}0\\0\\20\end{bmatrix}\text{ N},\qquad R^c_s\boldsymbol\mu^s_s=\begin{bmatrix}0\\-6\\0\end{bmatrix}\text{ N}\cdot\text{m},$$
$$\boldsymbol r^c_{cs}\times\boldsymbol f^c_c=\begin{bmatrix}-0.3\\0\\0.2\end{bmatrix}\times\begin{bmatrix}0\\0\\20\end{bmatrix}=\begin{bmatrix}0\\+6\\0\end{bmatrix}\text{ N}\cdot\text{m}.$$
两者相加得 $\boldsymbol\mu^c_c=[0,-6,0]^{\mathrm T}+[0,+6,0]^{\mathrm T}=\boldsymbol 0$：传感器处测得的 $6\,\mathrm{N\cdot m}$ 力矩，完全来自于沿 $+z_c$ 方向的 $20\text{ N}$ 纯接触力以 $0.3\text{ m}$ 偏心垂直力臂（矢径总长 $0.3606\text{ m}$、夹角 $56.31^\circ$）对腕心形成的搬移力偶。
:::
:::

<a id="recall-5.4.1"></a>
<a id="part-5.4.2"></a>
<a id="sec-5.4.2.1"></a>
<a id="sec-5.4.2.2"></a>
<a id="sec-5.4.2.3"></a>

## 5.4.2 接近觉、触觉、距离传感器与融合基础

::: def 定义 5.4.4 · 接近觉与距离传感器（含敏感距离） {#def-5.4.4}
- **触觉传感器**：阵列式压力/弹性体感知抓持接触分布与微小滑移；
- **接近传感器（proximity）**：无需接触即可判断预设**敏感距离**（threshold distance）内有无目标（电感式感金属、电容式感多种介质、光电漫反射开关）；
- **距离传感器（range）**：定量测量并输出与目标间的连续距离值。
:::

::: thm 定理 5.4.D · 声纳测距方程与音速温度修正（原书式 5.33–5.34） {#thm-5.4.B}
声纳脉冲经空气传播往返总用时为 $t_v$，传感器至目标单程距离为
$$d_o=\frac{c_s t_v}{2}.$$
低湿度空气中的声速受摄氏温度 $T(^\circ\mathrm C)$ 显著影响：
$$c_s\approx 20.05\sqrt{T+273.16}\ \mathrm{m/s}\qquad(\text{室温附近线性近似 } c_s\approx 331.4+0.6\,T\ \mathrm{m/s}).$$
例如目标实际置于 $0^\circ\mathrm C$（$c_s=331.4\,\mathrm{m/s}$）真距 $2\,\mathrm m$ 处，若系统误套 $20^\circ\mathrm C$ 音速（$343.4\,\mathrm{m/s}$）计算，将读出 $2\times 343.4/331.4\approx 2.0724\,\mathrm m$（**高估约 $7.2\text{ cm}$**，$+3.6\%$），因此高精度声纳测距必须做温度补偿。
:::

::: method 方法 5.4.E · 两种激光测距：ToF 与三角测量 {#method-5.4.C}
1. **传播时间法（ToF）**：测量激光脉冲往返时间 $t$ 得 $d=c t/2$（$1\text{ mm}$ 距离分辨对应仅 $6.7\text{ ps}$ 的极高计时精度）。周期性等间隔脉冲发射（重复周期 $T_r$）时，若远距回波跨过下一脉冲周期，出现**距离模糊间隔** $d_{\mathrm{amb}}=cT_r/2$。
2. **三角测量法（Triangulation）**：激光垂直打在目标点 $P(0,d)$，散射光由横向基线间距 $b$ 处的接收透镜（焦距 $f$）汇聚于 CCD 光斑偏移量 $u$，由相似直角三角形直接得出非线性反比测距式：
   $$\tan\theta=\frac{b}{d}=\frac{|u|}{f}\;\Longrightarrow\; d=\frac{bf}{|u|}.$$
   近距时灵敏度极高，且红光波段窄带滤波配合光束扫描控制可抗背景杂光。

<figure>
<svg class="figure-svg" viewBox="0 0 900 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-5423-t fig-5423-d">
<title id="fig-5423-t">三种测距原理：声纳回波计时、激光传播时间、激光三角测量</title>
<desc id="fig-5423-d">三个并列的小图。左：声纳发出脉冲 I，经锥形波束击中目标 O 后回波 E 返回，距离由 d_o = c_s t_v / 2 给出；中：激光脉冲经目标反射回光电二极管，距离等于光速乘往返时间的一半；右：激光器与接收器之间有基线，接收光斑位置随目标距离变化，须通过几何关系或标定求距离。</desc>
<defs>
<marker id="f5423-a" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<text class="diagram-text" x="150" y="26" text-anchor="middle">① 声纳：回波计时</text>
<text class="diagram-text" x="460" y="26" text-anchor="middle">② 激光传播时间：光脉冲计时</text>
<text class="diagram-text" x="760" y="26" text-anchor="middle">③ 激光三角测量：光斑位置</text>
<line x1="130" y1="48" x2="130" y2="112" stroke="var(--line-strong)" stroke-width="3"/>
<path d="M130,56 L272,30 L272,130 L130,104" fill="none" stroke="var(--line)" stroke-dasharray="5 4"/>
<circle cx="250" cy="80" r="18" fill="none" stroke="var(--muted)" stroke-width="1.4"/>
<text class="diagram-note" x="250" y="85" text-anchor="middle">O</text>
<line x1="238" y1="100" x2="150" y2="100" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f5423-a)"/>
<text class="diagram-note" x="140" y="150">d_o = c_s·t_v/2</text>
<text class="diagram-note" x="60" y="174">c_s ≈ 20.05·√(T+273.16) m/s</text>
<rect x="330" y="50" width="76" height="26" rx="4" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="368" y="68" text-anchor="middle">半导体激光器</text>
<rect x="330" y="98" width="76" height="26" rx="4" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="368" y="116" text-anchor="middle">光电二极管</text>
<line x1="406" y1="63" x2="556" y2="63" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f5423-a)"/>
<line x1="556" y1="80" x2="410" y2="110" stroke="var(--fig-gold)" stroke-width="1.6" marker-end="url(#f5423-a)"/>
<line x1="560" y1="40" x2="560" y2="122" stroke="var(--muted)" stroke-width="2"/>
<text class="diagram-note" x="572" y="60">目标</text>
<text class="diagram-note" x="330" y="156">距离 = c·t/2（单点）</text>
<text class="diagram-note" x="330" y="180">1 mm 距离对应约 6.7 ps 往返时间</text>
<rect x="630" y="50" width="60" height="26" rx="4" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="660" y="68" text-anchor="middle">激光器</text>
<rect x="822" y="50" width="60" height="26" rx="4" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="852" y="68" text-anchor="middle">CCD</text>
<line x1="662" y1="80" x2="850" y2="80" stroke="var(--line-strong)" stroke-width="1.2" stroke-dasharray="4 3"/>
<text class="diagram-note" x="756" y="96" text-anchor="middle">基线 b：一条边 + 两个角</text>
<line x1="668" y1="78" x2="702" y2="196" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#f5423-a)"/>
<line x1="704" y1="196" x2="846" y2="80" stroke="var(--fig-gold)" stroke-width="1.6" marker-end="url(#f5423-a)"/>
<line x1="626" y1="200" x2="880" y2="200" stroke="var(--muted)" stroke-width="2"/>
<text class="diagram-note" x="712" y="222">反射光需到达接收器</text>
<text class="diagram-note" x="630" y="252">CCD 光斑位置随距离变化</text>
<text class="diagram-note" x="630" y="274">几何关系通常非线性</text>
<text class="diagram-note" x="450" y="316" text-anchor="middle">三种原理都只给出「一个方向上的一个距离」——要成图，必须扫描或多波束</text>
</svg>
<figcaption>声纳、激光 ToF 与激光三角测距几何原理对照（本教程绘）。</figcaption>
</figure>
:::

*(工程与工艺背景精简：压电/静电超声探头共用发射与接收时因脉冲余振形成**近距离盲区**，且光滑平面存在临界入射角以外的**镜面反射丢失与虚反射**；激光传感器须防范不可见红外辐射伤眼及抛光金属反射失效。)*

### 三点交会定位与卡尔曼滤波多传感器融合

已知三个不共线固定信标 $\boldsymbol p_i=(x_i,y_i)^{\mathrm T}\ (i=1,2,3)$ 及其测距 $d_i$，两两相减 $(x-x_i)^2+(y-y_i)^2=d_i^2$ 消去二次项即可用线性方程组直接求得平面位置 $(x,y)$（空间三维定位至少需四个不共面信标）。

对动态融合问题（离散线性模型 $\boldsymbol x_k=A\boldsymbol x_{k-1}+B\boldsymbol u_{k-1}+\boldsymbol w_{k-1}$，观测 $\boldsymbol z_k=H\boldsymbol x_k+\boldsymbol v_k$，噪声协方差 $Q_k, R_k$），**卡尔曼滤波**通过「时间预测 → 量测更新」五步方程把本体里程计与外部测距融合：
$$\hat{\boldsymbol x}_{k|k-1}=A\hat{\boldsymbol x}_{k-1|k-1}+B\boldsymbol u_{k-1},\qquad P_{k|k-1}=A P_{k-1|k-1}A^{\mathrm T}+Q_{k-1},$$
$$K_k=P_{k|k-1}H^{\mathrm T}(H P_{k|k-1}H^{\mathrm T}+R_k)^{-1},\qquad \hat{\boldsymbol x}_{k|k}=\hat{\boldsymbol x}_{k|k-1}+K_k(\boldsymbol z_k-H\hat{\boldsymbol x}_{k|k-1}),\qquad P_{k|k}=(I-K_k H)P_{k|k-1}.$$

<a id="recall-5.4.2"></a>
<a id="part-5.4.3"></a>
<a id="sec-5.4.3.1"></a>
<a id="sec-5.4.3.2"></a>
<a id="sec-5.4.3.3"></a>

## 5.4.3 视觉传感器与相机模型

::: def 定义 5.4.5 · 视觉传感器与 CCD/CMOS 感光成像（了解·精简） {#def-5.4.5}
**视觉传感器**采集二维亮度矩阵（像素图像，pixel）以识别三维物体特征：
- **CCD 相机**：光敏电荷经耦合移位寄存器串行送往共用放大器输出；强光易溢出拖尾（经典模拟视频 CCIR 625 行/25 Hz 与 RS170 525 行/30 Hz 再经帧捕捉器 A/D 量化）；
- **CMOS 相机**：每个像素集成有源放大管并列并行直接数字读出，支持局部感兴趣区（ROI）高速开窗；
- **低水平 vs 高水平视觉**：像素获取、坐标投影、边缘/质心提取属**低水平视觉**；结合模型库识别与场景理解属**高水平视觉**。
:::

::: thm 定理 5.4.F · 理想针孔相机模型与校准矩阵 $\Xi=\Omega\Pi(T^b_c)^{-1}$（作业五 5.7） {#thm-5.4.F}
设目标在机器人基坐标系 $\{b\}$ 的齐次坐标为 $\tilde{\boldsymbol p}^b=[(\boldsymbol p^b)^{\mathrm T},1]^{\mathrm T}$，相机系 $\{c\}$ 原点在光心、$+z_c$ 沿光轴朝前。由三维坐标映射到图像像素坐标 $(X_I,Y_I)$ 的完整代数链为：
1. **外参数坐标变换（务必取位姿逆）**：已知相机在基系下的位姿为 $T^b_c$，则目标点换至相机系须用其逆矩阵 $T^c_b=(T^b_c)^{-1}$（切勿直接误乘 $T^b_c$）：
   $$\tilde{\boldsymbol p}^c=T^c_b\,\tilde{\boldsymbol p}^b=(T^b_c)^{-1}\tilde{\boldsymbol p}^b,\qquad \boldsymbol p^c=\begin{bmatrix}p^c_x\\ p^c_y\\ p^c_z\end{bmatrix}=\big(R^b_c\big)^{\mathrm T}(\boldsymbol p^b-\boldsymbol o^b_c).$$
2. **正面透视投影（$p^c_z\neq 0$）**：取光心前方 $z_c=+f$ 处的虚拟像平面避开倒像负号，由相似三角形得像平面长度坐标（单位 mm）：
   $$X_f=\frac{f\,p^c_x}{p^c_z},\qquad Y_f=\frac{f\,p^c_y}{p^c_z}.$$
3. **像素缩放与主点偏移**：设水平/竖直像素密度 $\alpha_x,\alpha_y\ (\mathrm{pixel/mm})$、主点偏移 $(X_0,Y_0)$（pixel），得像素坐标（原书式 5.38–5.40）：
   $$X_I=\alpha_x X_f+X_0=\frac{\alpha_x f\,p^c_x}{p^c_z}+X_0,\qquad Y_I=\alpha_y Y_f+Y_0=\frac{\alpha_y f\,p^c_y}{p^c_z}+Y_0.$$
4. **齐次校准矩阵表达**：令深度标量 $\lambda=p^c_z>0$，定义内参阵 $\Omega\in\mathbb R^{3\times 3}$ 与规范投影阵 $\Pi\in\mathbb R^{3\times 4}$：
   $$\lambda\begin{bmatrix}X_I\\ Y_I\\ 1\end{bmatrix}=\Omega\Pi\tilde{\boldsymbol p}^c=\Xi\,\tilde{\boldsymbol p}^b,\qquad
   \Omega=\begin{bmatrix}f\alpha_x&0&X_0\\0&f\alpha_y&Y_0\\0&0&1\end{bmatrix},\quad
   \Pi=\begin{bmatrix}1&0&0&0\\0&1&0&0\\0&0&1&0\end{bmatrix},\quad \Xi=\Omega\Pi(T^b_c)^{-1}.$$

*(另常定义无量纲归一化图像坐标 $(X,Y)=(p^c_x/p^c_z,\ p^c_y/p^c_z)$，满足 $[X_I,Y_I,1]^{\mathrm T}=\Omega[X,Y,1]^{\mathrm T}$。注意透视投影丢失了深度信息：单帧图像上一点仅唯一对应空间一条射线，$p^c_z=0$ 处奇异。)*

<figure>
<svg class="figure-svg" viewBox="0 0 900 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-5433-t fig-5433-d">
<title id="fig-5433-t">相机模型：针孔几何（正面透视）与从三维点到像素的变换链</title>
<desc id="fig-5433-d">上半部分是侧视的针孔模型：目标在光心前方，光心前方是虚拟像平面，后方是真实像平面；目标上的光线穿过光心，与两平面分别相交。下半部分依次示出从基础坐标系换到相机坐标系、透视投影到像平面、按像素比例和主点偏移得到像素坐标；齐次形式的合成矩阵为 Ξ = Ω Π T_b^c。</desc>
<defs>
<marker id="f5433-a" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<text class="diagram-text" x="40" y="30">① 针孔几何：透视变换 = 相似三角形（侧视）</text>
<line x1="120" y1="180" x2="700" y2="180" stroke="var(--line-strong)" stroke-width="1.2" stroke-dasharray="6 5"/>
<text class="diagram-note" x="702" y="172">光学轴</text>
<ellipse cx="520" cy="180" rx="9" ry="44" fill="none" stroke="var(--fig-blue)" stroke-width="1.8"/>
<text class="diagram-note" x="520" y="248" text-anchor="middle">透镜中心</text>
<line x1="392" y1="92" x2="392" y2="268" stroke="var(--line-strong)" stroke-width="1.2" stroke-dasharray="5 4"/>
<text class="diagram-note" x="330" y="86">虚拟像平面 z_c = f</text>
<line x1="650" y1="80" x2="650" y2="282" stroke="var(--muted)" stroke-width="2"/>
<text class="diagram-note" x="662" y="76">真实像平面（像上下颠倒）</text>
<line x1="150" y1="120" x2="150" y2="240" stroke="var(--fig-gold)" stroke-width="2.4"/>
<text class="diagram-note" x="52" y="112">目标 p：相机系坐标 p^c = (p^c_x, p^c_y, p^c_z)</text>
<line x1="150" y1="120" x2="650" y2="201" stroke="var(--fig-blue)" stroke-width="1.2"/>
<line x1="150" y1="240" x2="650" y2="159" stroke="var(--fig-blue)" stroke-width="1.2"/>
<circle cx="392" cy="159" r="3.5" fill="var(--fig-gold)"/>
<circle cx="392" cy="201" r="3.5" fill="var(--fig-gold)"/>
<text class="diagram-note" x="404" y="212">Y_f = f·p^c_y/p^c_z（正面透视，不变号）</text>
<line x1="522" y1="300" x2="648" y2="300" stroke="var(--muted)" stroke-width="1.4"/>
<line x1="522" y1="294" x2="522" y2="306" stroke="var(--muted)" stroke-width="1.4"/>
<line x1="648" y1="294" x2="648" y2="306" stroke="var(--muted)" stroke-width="1.4"/>
<text class="diagram-note" x="585" y="320" text-anchor="middle">焦距 f</text>
<text class="diagram-text" x="40" y="352">② 变换链</text>
<rect x="40" y="362" width="140" height="30" rx="6" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="110" y="382" text-anchor="middle">p：基础坐标系</text>
<line x1="180" y1="377" x2="212" y2="377" stroke="var(--muted)" stroke-width="1.4" marker-end="url(#f5433-a)"/>
<rect x="214" y="362" width="176" height="30" rx="6" fill="none" stroke="var(--fig-blue)" stroke-width="1.6"/>
<text class="diagram-note" x="302" y="382" text-anchor="middle">p^c = T_b^c·p（外参数）</text>
<line x1="390" y1="377" x2="422" y2="377" stroke="var(--muted)" stroke-width="1.4" marker-end="url(#f5433-a)"/>
<rect x="424" y="362" width="176" height="30" rx="6" fill="none" stroke="var(--line-strong)"/>
<text class="diagram-note" x="512" y="382" text-anchor="middle">X_f, Y_f（透视变换）</text>
<line x1="600" y1="377" x2="632" y2="377" stroke="var(--muted)" stroke-width="1.4" marker-end="url(#f5433-a)"/>
<rect x="634" y="362" width="236" height="30" rx="6" fill="none" stroke="var(--fig-gold)" stroke-width="1.6"/>
<text class="diagram-note" x="752" y="382" text-anchor="middle">像素：αₓX_f+X₀，αᵧY_f+Y₀</text>
<text class="diagram-note" x="450" y="418" text-anchor="middle">合成：Ξ = Ω·Π·T_b^c —— 照相机校准矩阵（内参数 × 透视 × 外参数）</text>
</svg>
<figcaption>理想针孔相机模型与四步投影变换链（本教程绘，外参矩阵 $T^c_b=(T^b_c)^{-1}$）。</figcaption>
</figure>
:::

<a id="sec-5.4.3.4"></a>
<a id="recall-5.4.3"></a>

::: think 默写点 · 合上书核对核心公式
1. 默写六维腕力传感器坐标系 $\{s\}$ 到约束坐标系 $\{c\}$ 的 $6\times 6$ 等价变换矩阵，说明 $\boldsymbol r^c_{cs}$ 的指向。
2. 写出声纳测距与室温音速修正公式、激光三角测距公式，并说明声纳用错 $20^\circ\mathrm C$ 音速在 $0^\circ\mathrm C$、$2\,\mathrm m$ 处造成多大的偏差。
3. 默写针孔相机校准矩阵分解 $\Xi=\Omega\Pi(T^b_c)^{-1}$ 的各块矩阵维数，以及为何不可忘记透视除以深度 $\lambda=p^c_z$。

::: sol 核对
1. $\begin{bmatrix}R^c_s & O\\ S(\boldsymbol r^c_{cs})R^c_s & R^c_s\end{bmatrix}$，其中 $\boldsymbol r^c_{cs}$ 在 $\{c\}$ 系下表示且箭头由 $O_c$ 指向 $O_s$。
2. $d_o=c_s t_v/2,\ c_s\approx 331.4+0.6\,T$（或 $20.05\sqrt{T+273.16}$）；激光三角 $d=bf/|u|$；误套高温音速将高估约 $+7.2\text{ cm}$。
3. $\Omega\in\mathbb R^{3\times 3},\ \Pi\in\mathbb R^{3\times 4},\ (T^b_c)^{-1}\in\mathbb R^{4\times 4}$；透视本质是相似三角形投影除法，齐次形式把 $p^c_z$ 存在第三分量 $\lambda$ 中，最终求取像素必须执行 $X_I=x_I/\lambda,\ Y_I=y_I/\lambda$。
:::
:::

## 5.4 小结与常见错误

| 传感器类别 | 核心变换 / 公式 | 典型陷阱 |
|:--|:--|:--|
| 应变片与腕力传感器 | $V_o\approx -\frac{V_i}{4}K_g\varepsilon$；$\boldsymbol h^c_c=\begin{bmatrix}R^c_s&O\\S(\boldsymbol r^c_{cs})R^c_s&R^c_s\end{bmatrix}\boldsymbol h^s_s$ | 混淆轴转矩与 $C_m$；把 $\boldsymbol r_{cs}$ 方向写反使搬移力矩变号；忘扣夹具重力和惯性力 |
| 声纳与激光测距 | $d_o=c_s t_v/2$；$d=bf/|u|$；$d_{\mathrm{amb}}=cT_r/2$ | 声纳忘除以 2 或忽视音速温度漂移；把盲区当激光分辨率局限 |
| 理想针孔视觉相机 | $\lambda[X_I,Y_I,1]^{\mathrm T}=\Omega\Pi(T^b_c)^{-1}\tilde{\boldsymbol p}^b$ | 直接代正运动学相机位姿 $T^b_c$ 而不取逆 $(T^b_c)^{-1}$；齐次乘完忘记除以 $\lambda=p^c_z$ |

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 02:00:17 | [exteroceptive-force-title.jpg](../assets/ch05/exteroceptive-force-title.jpg) | 力测量归结为应变测量 | 5.4.1 节引言与定义 |
| 02:01:58 | [force-strain-gauge.jpg](../assets/ch05/force-strain-gauge.jpg) | 应变片与惠斯通电桥 | 5.4.1 节公式与温补/半桥推导 |
| 02:06:58 | [force-wrist-malta.jpg](../assets/ch05/force-wrist-malta.jpg) | 马耳他十字与 $6\times 8$ 校准阵 | 5.4.1 节矩阵与例 5.4.C 完整验算 |
| 02:15:04 | [dist-sonar.jpg](../assets/ch05/dist-sonar.jpg) | 声纳测距方程与温度修正 | 5.4.2 节公式与偏差示例 |
| 02:20:11 | [dist-laser-triangulation.jpg](../assets/ch05/dist-laser-triangulation.jpg) | 激光三角测量原理 | 5.4.2 节几何推导与图 5.4.2.3 |
| 02:22:21 | [vision-ccd-cmos.jpg](../assets/ch05/vision-ccd-cmos.jpg) | CCD/CMOS 成像机理 | 5.4.3 节定义 5.4.5 精简对比 |
| 02:27:28 | [vision-pixel-coords.jpg](../assets/ch05/vision-pixel-coords.jpg) | 像素坐标换算链 | 5.4.3 节四步矩阵推导（对接作业 5.7） |
:::
