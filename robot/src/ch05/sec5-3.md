# 5.3 本体传感器

本页子节：
- [5.3.1 本体量界定与伺服反馈量](#sec-5.3.0)
- [5.3.2 位置传感器](#part-5.3.1)
- [5.3.3 速度传感器与速度重建](#part-5.3.2)

前两节完成了驱动链正向动力学与传递函数建模；为了使控制器闭合工作，必须把机械手关节自身的实际状态准确地读回控制回路。机器人传感体系按**被测量对象的物理属性**一分为二：**本体传感器（proprioceptive）**在线获取机械手内部状态，**外部传感器（exteroceptive）**提取周围环境及交互信息（[§5.4](sec5-4.md)）。本节明确分类判据，并定量推导编码器、旋转变压器与测速机的原理、分辨率与误差特性。

::: note 考纲定位 · 核心必考
**本体/外部传感器划分判据**、**绝对式与增量式光学编码器原理**、**单/关节侧量化分辨率计算与 4 倍频（$N=4P$）**、**格雷码消除多比特同时翻转误读**、以及**测速 M 法/T 法适用速域与直/交流转速计对比**为本章核心必考知识点。
:::

<a id="sec-5.3.0"></a>
<a id="sec-5.3"></a>

## 5.3.1 本体量界定与伺服反馈量

::: def 定义 5.3.1 · 本体传感器（proprioceptive sensors） {#def-5.3.1}
**本体传感器**是在机器人运动过程中**在线测量**表征机械手自身内部状态变量的传感器件，为参数辨识与伺服控制算法提供基础反馈信号。核心本体状态包含三项：
1. **关节位置**（joint position）；
2. **关节速度**（joint velocity）；
3. **关节力矩**（joint torque）。

注意分类遵循**「测量何种物理状态」而非「传感器安装在何处」**：尽管常用六维腕力传感器机械固定在机器人腕部，但由于其测的是末端执行器与外部环境之间的接触广义力，故归入**外部传感器**；只有轴转矩传感器测得的内部驱动力矩属于本体量（静力学中仅在忽略惯性与摩擦时满足 $\boldsymbol\tau=J^{\mathrm T}\boldsymbol F_e$，[§3.8](../ch03/sec3-8.md)）。
:::

::: intuition 动手实验 · 比较本体与外部传感器在机械臂上的分布（3D）
切换显示关节轴端编码器、转速计与腕端力觉、测距及视觉传感器，观察物理装卡位置与信号回路分工；并查看码盘槽栅产生正交脉冲的三维机理。

<div class="lab" data-lab="sensor3d"></div>
:::

<a id="sec-5.3.0.2"></a>

::: thm 定理 5.3.A · 位置与速度是关节伺服的基本反馈量 {#thm-5.3.A}
在实际工业关节伺服系统中，**关节位置**与**关节速度**构成位置外环与速度内环的两个基本反馈量（见下方框图）：位置环保障稳态定位准确度，测速内环提供阻尼并加速抗扰响应。并不是所有控制器都需要为三个本体量独立配装传感器：速度量可由位置信号重建，驱动转矩亦可在一定精度下由电机电枢电流推算。

<figure>
<svg class="figure-svg" viewBox="0 0 920 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-53-loop-t fig-53-loop-d">
<title id="fig-53-loop-t">关节伺服的「位置环 + 速度环」与它们各自所需的传感器</title>
<desc id="fig-53-loop-d">电机侧位置参考依次经过位置比例控制器、速度比较点、速度 PI、输入端等效扰动比较点、功率放大器、速度对象与积分环节。速度和位置反馈分别闭合内外环；扰动 D 已折算成放大器输入端的等效量，不是直接注入的物理负载力矩。</desc>
<defs>
<marker id="f53-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<circle class="diagram-node" cx="86" cy="130" r="15"/>
<text class="diagram-note" x="79" y="124">+</text>
<text class="diagram-note" x="79" y="148">−</text>
<text class="diagram-text" x="14" y="136">θ<tspan class="sb">r</tspan></text>
<line class="diagram-axis" x1="38" y1="130" x2="68" y2="130" marker-end="url(#f53-m)"/>
<rect class="diagram-node" x="112" y="106" width="100" height="48" rx="8"/>
<text class="diagram-text" x="162" y="126" text-anchor="middle">位置控制器</text>
<text class="diagram-note" x="162" y="145" text-anchor="middle">（比例，K<tspan class="sb">r</tspan>）</text>
<line class="diagram-axis" x1="104" y1="130" x2="230" y2="130" marker-end="url(#f53-m)"/>
<circle class="diagram-node" cx="248" cy="130" r="14"/>
<text class="diagram-note" x="242" y="124">+</text>
<text class="diagram-note" x="242" y="148">−</text>
<rect class="diagram-node" x="274" y="106" width="130" height="48" rx="8"/>
<text class="diagram-text" x="339" y="126" text-anchor="middle">速度控制器（PI）</text>
<text class="diagram-note" x="339" y="145" text-anchor="middle">K<tspan class="sb">v</tspan>, T<tspan class="sb">v</tspan></text>
<line class="diagram-axis" x1="264" y1="130" x2="414" y2="130" marker-end="url(#f53-m)"/>
<circle class="diagram-node" cx="432" cy="130" r="14"/>
<text class="diagram-note" x="426" y="124">+</text>
<text class="diagram-note" x="426" y="148">−</text>
<line class="diagram-muted" x1="432" y1="56" x2="432" y2="112" marker-end="url(#f53-m)"/>
<text class="diagram-note" x="432" y="46" text-anchor="middle">D：输入端等效负载扰动</text>
<line class="diagram-axis" x1="448" y1="130" x2="474" y2="130" marker-end="url(#f53-m)"/>
<rect class="diagram-node" x="476" y="108" width="88" height="44" rx="8"/>
<text class="diagram-text" x="520" y="127" text-anchor="middle">功率放大器</text>
<text class="diagram-note" x="520" y="145" text-anchor="middle">G<tspan class="sb">v</tspan></text>
<line class="diagram-axis" x1="566" y1="130" x2="596" y2="130" marker-end="url(#f53-m)"/>
<rect class="diagram-node" x="598" y="96" width="140" height="68" rx="8"/>
<text class="diagram-text" x="668" y="120" text-anchor="middle">伺服发动机</text>
<text class="diagram-note" x="668" y="142" text-anchor="middle">k<tspan class="sb">m</tspan>/(1+sT<tspan class="sb">m</tspan>)</text>
<line class="diagram-axis" x1="740" y1="130" x2="768" y2="130" marker-end="url(#f53-m)"/>
<text class="diagram-note" x="758" y="118" text-anchor="middle">Ω<tspan class="sb">m</tspan></text>
<rect class="diagram-node" x="772" y="108" width="66" height="44" rx="8"/>
<text class="diagram-text" x="805" y="136" text-anchor="middle">1/s</text>
<line class="diagram-axis" x1="840" y1="130" x2="868" y2="130" marker-end="url(#f53-m)"/>
<text class="diagram-text" x="856" y="118" text-anchor="middle">θ<tspan class="sb">m</tspan></text>
<line class="diagram-muted" x1="752" y1="130" x2="752" y2="214"/>
<line class="diagram-muted" x1="752" y1="214" x2="654" y2="214"/>
<rect class="diagram-fill-sage" x="438" y="192" width="216" height="44" rx="8"/>
<text class="diagram-text" x="546" y="211" text-anchor="middle">转速计（速度传感器）</text>
<text class="diagram-note" x="546" y="229" text-anchor="middle">k<tspan class="sb">TV</tspan> · §5.3.3</text>
<line class="diagram-muted" x1="438" y1="214" x2="248" y2="214" marker-end="url(#f53-m)"/>
<line class="diagram-muted" x1="248" y1="214" x2="248" y2="146"/>
<line class="diagram-muted" x1="856" y1="130" x2="856" y2="330"/>
<line class="diagram-muted" x1="856" y1="330" x2="714" y2="330"/>
<rect class="diagram-fill-accent" x="420" y="308" width="294" height="44" rx="8"/>
<text class="diagram-text" x="567" y="327" text-anchor="middle">位置传感器（编码器 / 旋转变压器）</text>
<text class="diagram-note" x="567" y="345" text-anchor="middle">§5.3.2</text>
<line class="diagram-muted" x1="420" y1="330" x2="86" y2="330" marker-end="url(#f53-m)"/>
<line class="diagram-muted" x1="86" y1="330" x2="86" y2="146"/>
<text class="diagram-note" x="150" y="204">内环 · 速度（阻尼与带宽）</text>
<text class="diagram-note" x="150" y="300">外环 · 位置（精度）</text>
<text class="diagram-text" x="30" y="388">本体传感器（本节）：关节位置 · 关节速度 · 关节力矩</text>
<text class="diagram-note" x="30" y="412">外部传感器（§5.4）：力 · 触觉 · 接近 · 距离 · 视觉</text>
<text class="diagram-note" x="560" y="388">电机电磁力矩可由电流估计：Cₘ = kₜiₐ；关节输出还需考虑传动与损耗</text>
<text class="diagram-note" x="560" y="412">教材图 5.11「带位置和速度反馈的驱动控制方框图」的简化重绘（本教程绘）</text>
</svg>
<figcaption>电机侧位置环与速度环结构（本教程绘）：位置与速度传感器分别闭合外环与内环；图中 $D$ 为折算到放大器参考端的等效扰动。</figcaption>
</figure>
:::

<a id="part-5.3.1"></a>
<a id="sec-5.3.1.1"></a>

## 5.3.2 位置传感器

::: def 定义 5.3.2 · 位置传感器分类与电位计局限 {#def-5.3.2}
位置传感器将机械角位移或线位移转化为比例电信号，常见传感器清单如下：
- **角位移传感器**（工业主力，通常装于驱动电机轴）：电位计、光学编码器、旋转变压器（resolver）、同步器（synchro）；
- **线位移传感器**（用于精密直线定位）：电位计、线性差动变压器（LVDT，基于铁芯移动改变差动互感）、感应同步器（inductosyn）。

其中接触式**电位计**通过滑动触点电阻分压测角，虽成本低廉，但存在机械磨损、碳膜电阻非均匀非线性、接触电噪声与寿命受限等短板，因此高性能机器人几乎全部选用非接触式的**光学编码器**或**旋转变压器**。
:::

<a id="sec-5.3.1.2"></a>

### 绝对式光学编码器与格雷码

::: def 定义 5.3.3 · 绝对式编码器与分辨率 {#def-5.3.3}
**绝对式光学编码器（absolute encoder）**内部为一块刻有 $n$ 条同心圆码道的玻璃码盘，每条码道交替镀有透光与遮光扇区，两侧分别配发光二极管与光电接收器，直接并行输出 $n$ 位二进制绝对角度编码。其单圈离散角位置数与电机侧量化分辨率分别为：
$$N_{\mathrm{pos}}=2^n,\qquad \Delta\theta_m=\frac{2\pi}{2^n}\text{ rad}=\frac{360^\circ}{2^n}.$$
若编码器安装于电机轴，且通过减速比 $k_r$ 驱动关节，则关节侧等效角分辨率细化为
$$\Delta\theta_l=\frac{\Delta\theta_m}{k_r}=\frac{2\pi}{2^n k_r}.$$
须区分**量化分辨率**与**实际定位精度**：$\Delta\theta_l$ 仅给出理论最小可读步距，真实定位精度还受码盘刻线误差、偏心装配、齿轮齿隙及结构弹性影响。此外，单圈绝对编码器断电重启后仅记得电机当圈角度，无法独自辨别经过减速器后关节处在哪一圈；只有配有备用电池电子记圈或机械减速齿轮组的**多圈绝对式编码器**，方能在断电移动后保留关节绝对位置。
:::

::: ex 例 5.3.B · 编码器分辨率、倍频与关节侧换算 {#ex-5.3.A}
1. **12 轨标准伺服配置**：$n=12 \implies 2^{12}=4096$ 个位置，电机侧分辨率 $360^\circ/4096\approx 0.0879^\circ\ (1.534\times 10^{-3}\text{ rad})$；经 $k_r=50$ 与 $k_r=100$ 减速后，关节侧分别达 $3.068\times 10^{-5}\text{ rad}$ 与 $1.534\times 10^{-5}\text{ rad}$（欲优于 $10^{-5}\text{ rad}$ 需 $k_r > 153.4$）。
2. **14 轨 vs 2500 线四倍频**：若某关节采用 $n=14$ 轨绝对式（$2^{14}=16384$）并配 $k_r=50$ 谐波减速器，电机侧 $\Delta\theta_m=360^\circ/16384\approx 0.02197^\circ$，关节侧 $\Delta\theta_l\approx 4.395\times 10^{-4\,\circ}$；若改用 $P=2500$ 线（PPR）增量式四倍频（$N=4P=10000$），电机侧为 $0.036^\circ$、关节侧为 $7.2\times 10^{-4\,\circ}$。
:::

::: thm 定理 5.3.C · 格雷码为什么能消除多位同时翻转尖峰误差 {#thm-5.3.B}
若码盘使用自然二进制码，在扇区边界切换时会发生多个比特同时翻转（例如 $0001\to 0010$ 最低两位同时变，或者 $0111\to 1000$ 全四位同时变）。受光电对准微差与电路响应延时影响，不同轨道的跳变瞬间不完全同步，导致在过渡沿处短暂吐出既非前码又非后码的巨额跳变尖峰（如 $7\to 8$ 过渡瞬间可能错读成 $15$ 或 $0$）。

采用**格雷码（Gray code）**编码则可根除该缺陷：格雷码序列中**任意两个相邻扇区（包括末码回零跨界）有且仅有一位二进制数翻转**。即使光电读头正好停在边界上抖动，输出也只会在两个真实相邻扇区之间相差 $1\text{ LSB}$，绝不会跳变到无关扇区。

| 十进制位置 | $0$ | $1$ | $2$ | $3$ | $4$ | $5$ | $6$ | $7$ | $8$ | $9$ | $10$ | $11$ | $12$ | $13$ | $14$ | $15$ |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **4 轨格雷码** | `0000` | `0001` | `0011` | `0010` | `0110` | `0111` | `0101` | `0100` | `1100` | `1101` | `1111` | `1110` | `1010` | `1011` | `1001` | `1000` |
:::

<a id="sec-5.3.1.3"></a>

### 增量式光学编码器、A/B 正交四倍频与 Z 相

增量式编码器结构简单、成本显著低于高位数绝对码盘，是机器人工程中应用最广泛的角位置传感器。它一般配备三条轨道：
- **A 相与 B 相正交脉冲轨**：两条具有相同扇区线数 $P$（PPR，每转脉冲数）的轨道在空间圆周上彼此错开 $1/4$ 周期，输出相位相差 $90^\circ$ 电角度的方波脉冲。根据哪一相脉冲上升沿超前即可判定正反转（转向逻辑取决于安装朝向与 A/B 接线顺序，装机后须实测校验）。
- **四倍频细分计数**：在一对正交方波的单个周期内共有 4 个唯一跳变沿（$A\uparrow,\ B\uparrow,\ A\downarrow,\ B\downarrow$）。数字鉴相计数器在每个边沿均输出一次脉冲，使每转等效总计数提升 4 倍为 $N=4P$，角分辨率细化为 $360^\circ/(4P)$。
- **Z 相（索引零脉冲轨）**：每转仅一个窄缝，输出单圈机械零位脉冲。增量式编码器**掉电即丢失当前位置**，每次上电均须执行**回零（homing）**——结合关节限位开关确定粗零位区间，再捕获特定脉冲沿的 Z 脉冲精确标定关节零点；运行中漏计脉冲还会造成不可自愈的累计漂移。

<a id="sec-5.3.1.4"></a>

### 旋转变压器（Resolver）与跟踪型 RDC

::: note 注 5.3.4 · 旋转变压器与 LVDT/感应同步器 {#note-5.3.1}
在高温、高振、强油污或电磁干扰苛刻环境下，常采用电磁感应式的**旋转变压器（resolver）**：转子通入高频恒幅正弦激磁电压 $V\sin(\omega t)$（$0.4\text{–}10\text{ kHz}$），定子布置两个电空间正交（$90^\circ$）的感应绕组，输出被转角 $\theta$ 调制的两路正交包络：
$$v_s=V\sin(\omega t)\sin\theta,\qquad v_c=V\sin(\omega t)\cos\theta.$$
后端**跟踪型轴角—数字转换器（RDC）**将信号分别乘以内部寄存器角 $\alpha$ 的 $\cos\alpha$ 与 $-\sin\alpha$ 后求和，得到误差信号 $V\sin(\omega t)\sin(\theta-\alpha)$，经同步解调与含双积分的II型闭环控制 VCO 驱动计数，迫使 $\alpha$ 实时锁定 $\theta$（在稳态恒速旋转下跟踪误差趋于零，可达 16 位高精度数字分辨率）。直线高精度测量另采用结构相似的**感应同步器**或 **LVDT**。
:::

<a id="recall-5.3.1"></a>
<a id="sec-5.3.1"></a>
<a id="part-5.3.2"></a>
<a id="sec-5.3.2.1"></a>

## 5.3.3 速度传感器与速度重建

角速度既可由位置编码器脉冲数字重建，也可由专用模拟转速计直接测得。

::: method 方法 5.3.D · 从位置脉冲重建速度的三条途径 {#method-5.3.A}
设编码器每转等效总脉冲数为 $N$（含 4 倍频因子）：
1. **频率—电压转换（F/V）**：通过硬件模拟电路将脉冲频率线性转化为直流模拟电压。
2. **测频法（M 法，固定采样窗计数）**：在固定采样周期 $\Delta t$ 内统计带符号净脉冲数 $n$，估计角速度大小为
   $$|\hat\omega|=\frac{2\pi n}{N\Delta t}.$$
   因窗口边缘存在 $\pm 1$ 个脉冲量化截断误差，转速越低 $n$ 越小，相对误差 $\pm 1/n$ 急剧放大；强行增大 $\Delta t$ 虽增加脉冲数却会严重恶化闭环采样相位滞后。故 **M 法仅适用于中高速测量**。
3. **测周法（T 法，相邻脉冲测时长）**：用高频参考时钟测量相邻两个脉冲边沿之间的周期时间间隔 $\Delta t_p$，得
   $$|\hat\omega|=\frac{2\pi}{N\Delta t_p}.$$
   低速时 $\Delta t_p$ 很长，时钟计数极其精细；高速时 $\Delta t_p$ 过短，时钟量化分辨率下降，且零速卡死无脉冲时须配合超时判零。故 **T 法适用于低速测量**（工程上常组合形成 M/T 法以覆盖全速域）。

**为什么不能直接对离散编码器读数作位置差分？** 因为编码器位置输出本质是一系列台阶（阶梯函数），直接差分 $[\theta(k)-\theta(k-1)]/\Delta t$ 在未越过扇区边缘的采样周期全部输出 0，而在跨越瞬间炸出幅值 $\Delta\theta/\Delta t$ 的窄尖峰：采样时间 $\Delta t$ 越小，量化噪声被因子 $1/\Delta t$ 放大得越剧烈，绝对不能直接充当高速瞬时反馈（须经低通滤波、M/T 平均或状态观测器估计）。

<figure>
<svg class="figure-svg" viewBox="0 0 920 390" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-532-diff-t fig-532-diff-d">
<title id="fig-532-diff-t">位置量化台阶与差分出的速度：瞬时值不可用，平均值才对</title>
<desc id="fig-532-diff-d">左图：编码器给出的位置是阶梯状的量化曲线，与真实的匀速直线（斜坡）之间最多差一级台阶；右图：对阶梯做差分，得到的速度信号在大部分时间为零、在每个台阶跳变处出现尖峰，虚线表示其平均值等于真实转速。</desc>
<marker id="f532-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<line class="diagram-axis" x1="70" y1="250" x2="436" y2="250"/>
<line class="diagram-axis" x1="70" y1="250" x2="70" y2="56"/>
<line class="diagram-muted" x1="70" y1="238" x2="420" y2="96"/>
<path class="diagram-accent" d="M 70,230 L 112,230 L 112,212 L 154,212 L 154,195 L 196,195 L 196,178 L 238,178 L 238,161 L 280,161 L 280,144 L 322,144 L 322,127 L 364,127 L 364,110 L 406,110 L 406,97 L 430,97"/>
<text class="diagram-text" x="76" y="48">位置 θ</text>
<text class="diagram-text" x="440" y="256">时间 t</text>
<text class="diagram-note" x="250" y="212">真实位置（匀速上坡）</text>
<text class="diagram-note" x="96" y="286">① 编码器读数：量化台阶（每格一份）</text>
<line class="diagram-axis" x1="500" y1="250" x2="884" y2="250"/>
<line class="diagram-axis" x1="500" y1="250" x2="500" y2="56"/>
<line class="diagram-muted" x1="500" y1="170" x2="884" y2="170"/>
<path class="diagram-accent" d="M 500,240 L 538,240 L 542,90 L 546,240 L 580,240 L 584,90 L 588,240 L 622,240 L 626,90 L 630,240 L 664,240 L 668,90 L 672,240 L 706,240 L 710,90 L 714,240 L 748,240 L 752,90 L 756,240 L 790,240 L 794,90 L 798,240 L 832,240 L 836,90 L 840,240 L 884,240"/>
<text class="diagram-text" x="506" y="48">速度 ω</text>
<text class="diagram-note" x="726" y="162">平均 = 真实转速</text>
<text class="diagram-note" x="546" y="286">② 对位置差分：平段为 0，跳变处出尖峰</text>
<line class="diagram-muted" x1="70" y1="304" x2="884" y2="304"/>
<text class="diagram-note" x="70" y="332">平滑段来自「台阶没变」⇒ 差分输出 0；尖峰来自「台阶跳了一格」⇒ 差分输出一个大数。</text>
<text class="diagram-note" x="70" y="358">把采样间隔 Δt 取得越小，尖峰越高：噪声被 1/Δt 放大；真实速度越低（斜坡越平缓），相对误差越大。</text>
<text class="diagram-note" x="70" y="382">「从位置重建速度」的两难（本教程绘）</text>
</svg>
<figcaption>位置量化台阶与直接差分的尖峰畸变（本教程绘）：瞬时差分噪声被 $1/\Delta t$ 放大，M/T 法本质上是沿频率域或时间域取平均估值。</figcaption>
</figure>
:::

<a id="sec-5.3.2.2"></a>
<a id="sec-5.3.2.3"></a>

### 直流转速计与交流转速计（直接测速器件）

当要求高带宽、零延迟模拟速度反馈时，直接装在电机轴上的**测速发电机（tachometer）**根据电磁感应输出比例电压：

| 对比维度 | 直流转速计（DC tachometer） | 交流转速计（AC tachometer） |
|:--|:--|:--|
| **结构与激磁** | 小型永磁直流发电机（定子永磁 + 绕组转子 + 电刷换向器） | 定子含两个正交（$90^\circ$）绕组（一相通恒幅 $400\,\mathrm{Hz}$ 正弦激磁）+ 低惯量杯形无绕组转子 |
| **输出与判向** | 直流电压幅值正比于转速，$\pm$ **极性**直接给出正反转向 | 另一相定子绕组感应同频正弦电压，幅值正比于转速；相对激磁**同相/反相**经同步检波判别转向 |
| **核心误差源与瓶颈** | 换向器换片引起 **2%–5% 电压纹波**，且**纹波频率正比于角速度**——低速调速时纹波频带跌入控制带宽内，固定滤波器无法在保动态前提下完全滤除 | 同步检波把纹波推至固定二倍频（$800\,\mathrm{Hz}$）极易滤波，但静止状态下定子间寄生电磁耦合会产生非零**剩余电压（zero-speed residual voltage）** |
| **综合评价** | 线性误差 $0.1\%\text{–}1\%$，工业应用最广泛 | 线性度相近；**无电刷摩擦**且杯形转子**转动惯量极小** |

<a id="recall-5.3.2"></a>
<a id="sec-5.3.2"></a>

::: think 默写点 · 合上书自检核心公式
1. 按什么划分本体传感器与外部传感器？腕力传感器测力为什么归于外部传感器？
2. 写出 14 位绝对式编码器经 $k_r=50$ 减速后关节侧角分辨率（度与弧度），并简述格雷码核心优点。
3. 比较 M 法与 T 法的公式与适用速域，并对比直流与交流转速计的主要固有噪声误差。

::: sol 核对
1. 按被测物理属性（内部状态 vs 环境交互）划分；腕力传感器虽在腕部，但测量的是末端执行器与环境交互的接触外力/力矩，故属外部传感器。
2. $\Delta\theta_l = 360^\circ/(2^{14}\times 50)\approx 4.395\times 10^{-4\,\circ}\ (7.670\times 10^{-6}\text{ rad})$；格雷码任意相邻位置码字仅变 1 位，防止多轨异步切换导致的巨额跳变误读。
3. 测频 M 法 $|\hat\omega|=2\pi n/(N\Delta t)$ 适于高速；测周 T 法 $|\hat\omega|=2\pi/(N\Delta t_p)$ 适于低速。直流转速计主要缺点是换向片纹波（频率随转速下降落入控制带宽）；交流转速计主要缺点是零速存在定子寄生耦合剩余电压。
:::
:::

## 5.3 小结与常见错误

| 知识点 | 核心公式 / 结论 | 易错点 |
|:--|:--|:--|
| 本体传感器定义 | 测内部状态：位置、速度、关节力矩 | 按“装在机器人身上还是墙上”去分本体与外部 |
| 编码器分辨率 | $\Delta\theta_m=2\pi/2^n,\ \Delta\theta_l=\Delta\theta_m/k_r$；4 倍频 $N=4P$ | 把分辨率当成定位精度；认为单圈绝对码盘配合易失计数可在断电移动后保留关节位置 |
| 速度重建 M / T 法 | M 法（高速）$2\pi n/(N\Delta t)$；T 法（低速）$2\pi/(N\Delta t_p)$ | 直接把高频率离散位置差分用来做高速闭环 |
| 转速计误差 | 直流有转速相关纹波；交流有静止剩余电压 | 误认为交流转速计零速输出严格为零 |

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 01:44:57 | [proprioceptive-title.jpg](../assets/ch05/proprioceptive-title.jpg) | 三个内部状态量与编码器实物 | 5.3.1 节定义与三量归宿 |
| 01:46:58 | [pos-transducers-overview.jpg](../assets/ch05/pos-transducers-overview.jpg) | 位置传感器器件清单与原理图 | 5.3.2 节器件清单与结构特性 |
| 01:48:35 | [pos-encoder-absolute.jpg](../assets/ch05/pos-encoder-absolute.jpg) | 绝对式编码器码盘与格雷码 | 5.3.2 节分辨率公式、例题与格雷码定理 |
| 01:53:40 | [pos-encoder-incremental.jpg](../assets/ch05/pos-encoder-incremental.jpg) | 增量式 A/B/Z 轨正交脉冲 | 5.3.2 节四倍频与上电回零推演 |
| 01:56:23 | [pos-resolver.jpg](../assets/ch05/pos-resolver.jpg) | 旋转变压器与跟踪型 RDC 框图 | 5.3.2 节调制信号与同步检波分析 |
| 01:57:59 | [vel-tachometer-dc.jpg](../assets/ch05/vel-tachometer-dc.jpg) | 直流转速计与 M/T 重建 | 5.3.3 节 M/T 公式与直/交流对照表 |
:::
