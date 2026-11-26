# 3.8 静力学

前七节用几何雅可比 $J(\boldsymbol q)$ 将关节速度映向末端执行器六维广义速度。当机械臂末端顶住工件表面或承受外部接触载荷并处于静态平衡时，各关节电机必须输出多大的力或力矩才能抵抗外部作用？本节依据虚功原理与瞬时功率守恒，证明驱动关节力矩完全由**同一几何雅可比的转置 $J^{\mathrm T}(\boldsymbol q)$** 确定，而不涉及矩阵求逆，也不要求机械臂非奇异或方阵（对应原书 §3.8）。

<a id="sec-3.8.1"></a>

## 3.8.1 运动静力学对偶：虚功原理与 $\boldsymbol\tau=J^{\mathrm T}\boldsymbol F_e$

::: def 定义 3.8.1 · 末端广义力与关节广义力 {#def-3.8.1}
将末端执行器**施加给环境**的三维力 $\boldsymbol f_e\in\mathbb R^3$（单位 $\mathrm N$）与关于末端参考点的三维力矩 $\boldsymbol\mu_e\in\mathbb R^3$（单位 $\mathrm{N\cdot m}$）堆叠为六维末端广义力：

$$\boldsymbol F_e = \begin{bmatrix}\boldsymbol f_e\\ \boldsymbol\mu_e\end{bmatrix}\in\mathbb R^6\qquad\text{（或记作 }\boldsymbol\gamma\text{、}\boldsymbol h_e\text{）},$$

环境反作用于机械臂末端执行器的广义力则为 $\boldsymbol F_{\mathrm{env}}=-\boldsymbol F_e$。相应关节广义力向量 $\boldsymbol\tau=[\tau_1,\dots,\tau_n]^{\mathrm T}\in\mathbb R^n$（转动关节取力矩 $\mathrm{N\cdot m}$，移动关节取推力 $\mathrm N$）。$\boldsymbol F_e$ 必须与几何雅可比 $J(\boldsymbol q)$ 在**同一基坐标系与同一末端参考点**下表达。

忽略重力、摩擦及加速度惯性项时，静态平衡状态下的**运动静力学对偶关系**为

$$\boxed{\ \boldsymbol\tau = J^{\mathrm T}(\boldsymbol q)\,\boldsymbol F_e\ }$$

若改记 $\boldsymbol F_{\mathrm{env}}$ 为环境加在末端上的力，则平衡输出反号为 $\boldsymbol\tau = -J^{\mathrm T}(\boldsymbol q)\boldsymbol F_{\mathrm{env}}$。
:::

::: proof 证明（虚功原理与功率守恒两条等价途径）
1. **虚功原理推导**：令关节产生任意无穷小虚位移 $\delta\boldsymbol q\in\mathbb R^n$，引起末端平动微元与无穷小虚转角向量 $\delta\boldsymbol x_e = J(\boldsymbol q)\delta\boldsymbol q$（其中转动微元对应物理刚体转角向量，而非有限欧拉角增量）。静态平衡要求一切理想约束反力不做虚功、外加主动力总虚功恒为零：
   - 关节执行器做虚功：$\delta W_\tau = \boldsymbol\tau^{\mathrm T}\delta\boldsymbol q$；
   - 环境反力做虚功：$\delta W_{\mathrm{env}} = \boldsymbol F_{\mathrm{env}}^{\mathrm T}\delta\boldsymbol x_e = -\boldsymbol F_e^{\mathrm T}J(\boldsymbol q)\delta\boldsymbol q$。
   由 $\delta W_\tau + \delta W_{\mathrm{env}} = (\boldsymbol\tau^{\mathrm T} - \boldsymbol F_e^{\mathrm T}J(\boldsymbol q))\delta\boldsymbol q = 0$ 对一切 $\delta\boldsymbol q\in\mathbb R^n$ 成立，必然有系数为零 $\boldsymbol\tau^{\mathrm T}=\boldsymbol F_e^{\mathrm T}J(\boldsymbol q)$，转置即得 $\boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\boldsymbol F_e$。

2. **瞬时功率守恒解释**：静平衡的无损刚体链在任意测试虚速度 $\dot{\boldsymbol q}$ 下两端功率必须精确相等：

$$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau = \boldsymbol v_e^{\mathrm T}\boldsymbol F_e = (J\dot{\boldsymbol q})^{\mathrm T}\boldsymbol F_e = \dot{\boldsymbol q}^{\mathrm T}J^{\mathrm T}\boldsymbol F_e \implies \boldsymbol\tau = J^{\mathrm T}\boldsymbol F_e.$$
:::

::: intuition 为什么传力用转置 $J^{\mathrm T}$ 而不是逆阵 $J^{-1}$ 或伪逆 $J^\dagger$？
$J$ 把关节速度映成末端速度，是向前（关节 $\to$ 任务）的映射；借助功率内积的伴随对偶关系，末端广义力向关节侧的平衡折算必然沿着反向对偶算子 $J^{\mathrm T}$ 传递。正因只做转置而无需逆矩阵，**该公式对任何冗余臂（$n>r$）乃至降秩奇点（$\operatorname{rank}J<r$）均严格有效**。但须铭记它是纯静力学关系；一旦存在连杆重力或高速运动，必须进入[第 6 章动力学方程](../ch06/sec6-1.md#part-6.1.3)计入 $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g$。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-38-title fig-38-desc">
<title id="fig-38-title">速度映射与力映射的转置对偶</title>
<desc id="fig-38-desc">左为关节空间：上行是 n 维关节速度、下行是 n 维关节力矩；右为操作空间：上行是 6 维末端速度、下行是 6 维广义力。上行箭头从左到右标 J，下行箭头从右到左标 J 转置，中间框写明功率守恒把两个矩阵钉成转置关系。</desc>
<defs>
<marker id="f38-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="f38-b" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-blue)"/></marker>
<marker id="f38-g" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-green)"/></marker>
</defs>
<text class="diagram-text" x="460" y="36" text-anchor="middle">速度与力的变换：互为转置的对偶</text>
<rect class="diagram-node" x="60" y="70" width="190" height="196" rx="10"/>
<text class="diagram-text" x="155" y="96" text-anchor="middle">关节空间（n 维）</text>
<rect x="85" y="112" width="140" height="48" rx="8" stroke="var(--fig-blue)" fill="var(--accent)" fill-opacity=".04"/>
<text class="diagram-text" fill="var(--fig-blue)" x="155" y="132" text-anchor="middle">关节速度 q′</text>
<text class="diagram-note" x="155" y="151" text-anchor="middle">n 个关节</text>
<rect x="85" y="196" width="140" height="48" rx="8" stroke="var(--fig-green)" fill="var(--sage)" fill-opacity=".06"/>
<text class="diagram-text" fill="var(--fig-green)" x="155" y="216" text-anchor="middle">关节力矩 τ</text>
<text class="diagram-note" x="155" y="235" text-anchor="middle">每个电机出多大力矩</text>
<rect class="diagram-node" x="670" y="70" width="190" height="196" rx="10"/>
<text class="diagram-text" x="765" y="96" text-anchor="middle">操作空间（6 维）</text>
<rect x="695" y="112" width="140" height="48" rx="8" stroke="var(--fig-blue)" fill="var(--accent)" fill-opacity=".04"/>
<text class="diagram-text" fill="var(--fig-blue)" x="765" y="132" text-anchor="middle">末端速度 v<tspan class="sb">e</tspan></text>
<text class="diagram-note" x="765" y="151" text-anchor="middle">线速度 + 角速度</text>
<rect x="695" y="196" width="140" height="48" rx="8" stroke="var(--fig-green)" fill="var(--sage)" fill-opacity=".06"/>
<text class="diagram-text" fill="var(--fig-green)" x="765" y="216" text-anchor="middle">广义力 F<tspan class="sb">e</tspan> = (f, μ)</text>
<text class="diagram-note" x="765" y="235" text-anchor="middle">力 + 力矩</text>
<line x1="250" y1="136" x2="670" y2="136" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#f38-b)"/>
<text class="diagram-text" fill="var(--fig-blue)" x="460" y="118" text-anchor="middle">J：v<tspan class="sb">e</tspan> = J q′（正问题，一次乘法）</text>
<line x1="670" y1="220" x2="250" y2="220" stroke="var(--fig-green)" stroke-width="2.2" marker-end="url(#f38-g)"/>
<text class="diagram-text" fill="var(--fig-green)" x="460" y="248" text-anchor="middle">J<tspan class="sp">T</tspan>：τ = J<tspan class="sp">T</tspan> F<tspan class="sb">e</tspan>（力反向传递，不求逆）</text>
<rect class="diagram-node" x="330" y="152" width="260" height="48" rx="9" stroke="var(--accent)"/>
<text class="diagram-text" fill="var(--accent-text)" x="460" y="172" text-anchor="middle">功率守恒：q′<tspan class="sp">T</tspan>τ = v<tspan class="sb">e</tspan><tspan class="sp">T</tspan> F<tspan class="sb">e</tspan></text>
<text class="diagram-note" x="460" y="191" text-anchor="middle">对任意 q′ 成立 ⇒ 两矩阵互为转置</text>
<text class="diagram-note" x="460" y="300" text-anchor="middle">无需方阵、无需满秩——对偶比求逆更普适；静力平衡专用，含惯性 / 科氏力时回到动力学方程</text>
<text class="diagram-note" x="460" y="322" text-anchor="middle">同一 J 的两副面孔：正向传速度（第 3 章主线），转置传力（本节）</text>
</svg>
<figcaption>运动静力学对偶（本教程绘）：由 $v_e=J\dot q$ 和功率等式 $\dot q^{\mathrm T}\tau=v_e^{\mathrm T}F_e$，得到 $\tau=J^{\mathrm T}F_e$。推导不要求 $J$ 是方阵或满秩。</figcaption>
</figure>

::: ex 例 3.8.A · 两连杆平面臂顶住工件时的关节平衡力矩
沿用 [例 3.1.D](sec3-1.md#ex-3.1.D) 杆长各 $1\,\mathrm m$ 的 2R 臂在 $\boldsymbol q=[0,\pi/2]^{\mathrm T}$（第一杆沿 $+x$ 轴、第二杆竖直向上），仅截取 $v_x,v_y,\omega_z$ 有效三行：

$$\bar J = \begin{bmatrix}-1&-1\\1&0\\1&1\end{bmatrix}.$$

若机械臂在工具点向环境施加平动力 $\boldsymbol f=(0,10)^{\mathrm T}\,\mathrm N$ 及逆时针纯力矩 $\mu_z=2\,\mathrm{N\cdot m}$，平衡所需关节输出为

$$\boldsymbol\tau = \bar J^{\mathrm T}\begin{bmatrix}0\\10\\2\end{bmatrix} = \begin{bmatrix}12\\2\end{bmatrix}\,\mathrm{N\cdot m}.$$

物理核对：关节 1 水平力臂 $1\,\mathrm m$，竖直力贡献 $10\,\mathrm{N\cdot m}$；关节 2 矢径竖直，该力力臂为零，仅分担末端纯力矩 $2\,\mathrm{N\cdot m}$。若撤去纯力矩（$\mu_z=0$），则直接得 $\boldsymbol\tau=(10,0)^{\mathrm T}\,\mathrm{N\cdot m}$。若保持 $\mu_z=2\,\mathrm{N\cdot m}$ 而将推力改为水平向右 $\boldsymbol f=(10,0)^{\mathrm T}\,\mathrm N$，则得 $\boldsymbol\tau=(-8,-8)^{\mathrm T}\,\mathrm{N\cdot m}$（向右推力同时在两关节造成 $-10\,\mathrm{N\cdot m}$ 负担）。以测试虚速度 $\dot{\boldsymbol q}=(1,-1)^{\mathrm T}\,\mathrm{rad/s}$ 检验两组载荷的两端功率，分别恒为 $10\,\mathrm W$ 与 $0\,\mathrm W$。
:::

<a id="sec-3.8.2"></a>

## 3.8.2 两坐标系间的速度与力变换（$A_v$ 与 $A_v^{-\mathrm T}$ 对偶）

实际工程中，腕部力/力矩传感器读数常定义在传感器随动系 $\{1\}$（参考点 $A$）上，而规划或控制需要在基坐标系 $\{0\}$（参考点 $B$）表达。设 $\tilde{\boldsymbol p}$ 为由 $A$ 指向 $B$ 的位移矢量在 $\{1\}$ 系下的坐标，$\boldsymbol R_1^0$ 将 $\{1\}$ 系分量旋转到 $\{0\}$ 系。由刚体两点速度公式 $\dot{\boldsymbol p}_1^0 = \boldsymbol R_1^0\boldsymbol v_1 - \boldsymbol R_1^0 S(\tilde{\boldsymbol p})\boldsymbol\omega_1$ 及功率不变条件 $(A_v\boldsymbol\xi^1)^{\mathrm T}\boldsymbol F^0 = (\boldsymbol\xi^1)^{\mathrm T}\boldsymbol F^1 \implies A_F = A_v^{-\mathrm T}$，导出同方向（$\{1\}\to\{0\}$）的变换对（原书式 (3.112)–(3.116)）：

$$\begin{bmatrix}\dot{\boldsymbol p}_1^0\\ \boldsymbol\omega_1^0\end{bmatrix} = \underbrace{\begin{bmatrix}\boldsymbol R_1^0 & -\boldsymbol R_1^0 S(\tilde{\boldsymbol p})\\ O & \boldsymbol R_1^0\end{bmatrix}}_{A_v}\begin{bmatrix}\boldsymbol v_1\\ \boldsymbol\omega_1\end{bmatrix},\qquad
\begin{bmatrix}\boldsymbol f_1^0\\ \boldsymbol\mu_1^0\end{bmatrix} = \underbrace{\begin{bmatrix}\boldsymbol R_1^0 & O\\ -\boldsymbol R_1^0 S(\tilde{\boldsymbol p}) & \boldsymbol R_1^0\end{bmatrix}}_{A_F = A_v^{-\mathrm T}}\begin{bmatrix}\boldsymbol f_1\\ \boldsymbol\mu_1\end{bmatrix}.$$

- **记号与方向铁律**：同从 $\{1\}$ 变至 $\{0\}$ 时，力矩阵是速度矩阵的**逆转置 $A_v^{-\mathrm T}$**（左下角保留负号 $-\boldsymbol R_1^0 S(\tilde{\boldsymbol p})\boldsymbol f_1$）；若是把基系力反变回局部系 $\{1\}$，才使用 $A_v^{\mathrm T}$。只做表达基旋转而不变参考点（$\tilde{\boldsymbol p}=\boldsymbol 0$）时退化为 3.1.3 节块对角旋转变换。

::: ex 例 3.8.B · 改变力矩参考点时的功率不变性检验
设 $\boldsymbol R_1^0=I_3$、参考点平移 $\tilde{\boldsymbol p}=[0.1,0,0]^{\mathrm T}\,\mathrm m$，点 $A$ 线速度为零、角速度 $\boldsymbol\omega_1=[0,0,2]^{\mathrm T}\,\mathrm{rad/s}$，广义力 $\boldsymbol f_1=[0,10,0]^{\mathrm T}\,\mathrm N$、$\boldsymbol\mu_1=[0,0,1]^{\mathrm T}\,\mathrm{N\cdot m}$。算得点 $B$ 线速度为 $\boldsymbol\omega_1\times\tilde{\boldsymbol p}=[0,0.2,0]^{\mathrm T}\,\mathrm{m/s}$，关于 $B$ 的力矩 $\boldsymbol\mu_1^0 = \boldsymbol\mu_1 - \tilde{\boldsymbol p}\times\boldsymbol f_1 = [0,0,1]^{\mathrm T} - [0,0,1]^{\mathrm T}=\boldsymbol 0$，两端功率均为 $2\,\mathrm W$（在 $A$ 为 $2\times 1$，在 $B$ 为 $0.2\times 10$）。若将平移改为 $\tilde{\boldsymbol p}=[0.2,0,0]^{\mathrm T}\,\mathrm m$，则线速度倍增至 $0.4\,\mathrm{m/s}$ 且 $\boldsymbol\mu_1^0=[0,0,-1]^{\mathrm T}\,\mathrm{N\cdot m}$，两端功率仍为 $0.4\times 10 + 2\times(-1) = 2\,\mathrm W$。
:::

<a id="sec-3.8.3"></a>

## 3.8.3 四大子空间对偶、力椭球与闭链（了解·精简）

1. **子空间对偶**：速度与静力映射构成线性代数四大基本子空间的正交补关系：

$$\mathcal N(J^{\mathrm T}) = \mathcal R(J)^\perp,\qquad \mathcal R(J^{\mathrm T}) = \mathcal N(J)^\perp.$$

   处于奇点时，落在不可实现速度方向 $\mathcal N(J^{\mathrm T})$ 的末端接触力直接被刚体连杆与轴承约束反力承担（$\boldsymbol\tau=J^{\mathrm T}\boldsymbol F_e=\boldsymbol 0$）；存在冗余时，零空间自运动力矩正交于平衡所需力矩 $\mathcal R(J^{\mathrm T})$，不做虚功。

2. **速度椭球与力椭球的主轴反比律**：在行满秩纯平移/统一尺度任务下，约束关节力矩范数 $\|\boldsymbol\tau\|_2\le T$ 导出**力椭球（force manipulability ellipsoid）** $\boldsymbol f^{\mathrm T}(JJ^{\mathrm T})\boldsymbol f\le T^2$，其主半轴长为 **$T/\sigma_i$**——与速度椭球半轴 $Q\sigma_i$ 主轴方向重合但大小严格成反比（越容易快速运动的方向，静态出力臂越长从而承受力上限越低）。

::: ex 例 3.8.C · 速度半轴与力半轴的倒数关系检验
设平面平移局部雅可比 $J=\operatorname{diag}(2,0.5)\,\mathrm{m/rad}$，欧氏总限幅 $Q=1\,\mathrm{rad/s}$、$T=1\,\mathrm{N\cdot m}$。速度椭圆半轴分别为 $2$ 与 $0.5\,\mathrm{m/s}$；力集合由 $4f_x^2+0.25f_y^2\le 1$ 界定，对应半轴倒数为 $0.5\,\mathrm N$ 与 $2\,\mathrm N$。沿易于快动的 $+x$ 方向施加 $1\,\mathrm N$ 力需 $2\,\mathrm{N\cdot m}$ 超出总限幅，而沿不易快动的 $+y$ 方向施加 $1\,\mathrm N$ 力仅需 $0.5\,\mathrm{N\cdot m}$。当第二分量退化至 $0$ 时，力集合退化为条带 $|f_x|\le 0.5\,\mathrm N$（仅理想刚体承载 $f_y$ 方向负荷，有限半轴公式不再适用）。
:::

3. **闭链静力学**：含有闭环运动链或多臂协同抓取同一物体时，存在不改变物体合力矩的内力张紧自由度，需额外结合闭链几何约束和内力分配模型（第 8 章力控制进一步展开）。

<a id="sec-3.8"></a>

## 本节小结

- **核心必考一条式**：$\boldsymbol\tau = J^{\mathrm T}(\boldsymbol q)\boldsymbol F_e$，由虚功原理和功率守恒保证，不要求 $J$ 为方阵或满秩；注意 $\boldsymbol F_e$ 表示机械臂向环境施加的力，与 $J$ 同坐标同参考点。

| 公式 | 适用条件 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| $\boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\boldsymbol F_e$ | 静态平衡、理想刚体（忽略重力与惯性） | $\mathrm{N\cdot m}$（R）/ $\mathrm N$（P） | 切勿误用 $J^{-1}$ 传力；环境反作用力 $\boldsymbol F_{\mathrm{env}}=-\boldsymbol F_e$ 符号勿反 |
| $\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau = \boldsymbol v_e^{\mathrm T}\boldsymbol F_e$ | 同一坐标系、同一末端参考点 | $\mathrm W$ | 功率检验只用于核对方向与符号，并非静态真耗功 |
| $A_F = A_v^{-\mathrm T} = \begin{bmatrix}\boldsymbol R_1^0&O\\-\boldsymbol R_1^0S(\tilde{\boldsymbol p})&\boldsymbol R_1^0\end{bmatrix}$ | $\{1\}\to\{0\}$ 同时换基并平移参考点 | $\mathrm N,\ \mathrm{N\cdot m}$ | 力变换取速度变换的逆转置（左下块负号），不可与 $A_v^{\mathrm T}$ 混淆 |

::: note 主线 · 两连杆（第四关 · 力与功率）
沿用例 3.8.A 在 $\boldsymbol q_A=(0,\pi/2)$ 对末端施加 $\boldsymbol F=(0,10)^{\mathrm T}\,\mathrm N$（无末端力矩），算得关节力矩 $\boldsymbol\tau=(10,0)^{\mathrm T}\,\mathrm{N\cdot m}$ 并利用虚速度核对两端功率一致（见[两连杆训练第四关](../training/two-link.md#mission-force)）；[第四章 4.2.1 节](../ch04/sec4-2-1.md)将回到运动学轨迹层安排起停与三次时间律，第五、六章再补全电机折算与完整动力学。
:::

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 02:27:31 | [virtual-work.jpg](../assets/ch03/virtual-work.jpg) | 虚功原理与静力学对偶 | 定义 3.8.1、双途径证明及对偶图完整覆盖 |
| — | [velocity-force-frames.png](../assets/ch03/velocity-force-frames.png) | 刚体双坐标系力与速度变换 | 3.8.2 严格推导 $A_v$ 与 $A_v^{-\mathrm T}$ 及功率不变跟算 |
:::
