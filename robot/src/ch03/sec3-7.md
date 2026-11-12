# 3.7 逆运动学算法

上一节说明了角速度和姿态坐标导数的区别。这一节把它用到数值逆解：从一个关节初值出发，怎样让正运动学算出的末端位置、姿态逐步接近期望值？

先看一个问题。[§3.5](sec3-5.md)用当前[雅可比](../recall.md#jacobian)反算速度，再积分更新关节：

$$q_{k+1}=q_k+h\dot q_k.$$

但正运动学 $x=k(q)$ 一般是非线性的，有限更新实际给出

$$k(q_k+h\dot q_k)=k(q_k)+hJ_A(q_k)\dot q_k+O(h^2\|\dot q_k\|^2).$$

雅可比匹配的是展开式的一阶项，有限更新留下的高阶差异会逐步积累。此外，即使没有积分误差，仅输入期望速度也不会消除初始位置偏差。因此每步都要重新计算末端误差，并用它修正下一步的求解。

本节依次推导逆方案、转置方案、姿态误差和二阶方案，最后用同一台两连杆臂比较。课程录播对应2:24:15–2:27:34；以下推导可独立阅读。

::: def 定义 3.7.1 · 本节求解的对象 {#def-3.7.1}

选定任务坐标 $x=k(q)\in\mathbb R^r$，关节变量 $q\in\mathbb R^n$，其导数矩阵记为

$$J_A(q)=\frac{\partial k}{\partial q}\in\mathbb R^{r\times n},\qquad \dot x=J_A(q)\dot q.$$

完整位姿若用 $x=[p;\boldsymbol\varphi]$，这里就是[§3.6](sec3-6.md)的分析雅可比；仅做位置任务时，改用相应的 $J_P$。不能在欧拉角误差的导数里直接换成输出角速度的几何 $J$。

以下在任务函数 $k$ 二阶连续可微的邻域内计算。给定可微的期望任务 $x_d(t)$，定义

$$e=x_d-k(q),\qquad \boxed{\dot e=\dot x_d-J_A\dot q}. \tag{3.7-1}$$

姿态坐标须处在同一光滑分支内。本节常用常对称正定增益 $K$，即 $K=K^{\mathrm T}$ 且 $a^{\mathrm T}Ka>0$ 对一切非零 $a$ 成立；对角情形就是各增益均为正。

位置和角度混合做误差代价时，须先约定尺度；否则“减小误差”没有统一度量。以下数值例用1m归一化长度，关节用rad数值，时间以秒计；逆方案与转置方案采用相同的增益数值进行比较。

:::

这里的 $q$ 可以是计算机中的候选解，此时算法只执行数值迭代。若将求出的关节速度用于运动学控制，还需低层伺服近似跟随命令；电机力矩与机械臂动力学尚未纳入本节模型。


<a id="sec-3.7.1"></a>

## 3.7.1 逆雅可比：把误差导数指定出来

### 从希望的误差变化反推输入

先假设 $r=n$，沿所讨论的运动 $J_A$ 可逆。希望偏差越大，修正越快，选取

$$\dot e=-Ke.$$

把它放进式(3.7-1)，先求需要实现的任务速度，再解关节速度：

$$\dot x_d-J_A\dot q=-Ke
\quad\Longrightarrow\quad
J_A\dot q=\dot x_d+Ke
\quad\Longrightarrow\quad
\boxed{\dot q=J_A^{-1}(\dot x_d+Ke)}. \tag{3.7-2}$$

$\dot x_d$ 是**前馈**：即使当前没有误差，目标仍可能在移动；$Ke$ 是**反馈修正**：使当前偏差缩小。回代验证不能省略：

$$\dot e=\dot x_d-J_AJ_A^{-1}(\dot x_d+Ke)
=\dot x_d-\dot x_d-Ke=-Ke.$$

这就是“完全线性化”的含义：在这些连续时间、模型和可逆性条件下，非线性的 $J_A(q)$ 从误差方程中被抵消。

为什么正增益能收敛？对角 $K=\operatorname{diag}(k_1,\ldots,k_r)$ 时，每个分量独立满足

$$\dot e_i=-k_i e_i,\qquad e_i(t)=e_i(0)e^{-k_i t}.$$

例如 $k_i=2\,\mathrm{s}^{-1}$，1秒后该分量剩初值的 $e^{-2}\approx0.1353$。一般常对称正定 $K$ 也有

$$\frac{\mathrm d}{\mathrm dt}\|e\|^2=-2e^{\mathrm T}Ke
\le-2\lambda_{\min}(K)\|e\|^2,$$

于是 $\|e(t)\|\le e^{-\lambda_{\min}(K)t}\|e(0)\|$。这是误差的指数衰减结论；它不能保证任意关节初值都能找到逆解，因为推导还要求轨迹始终留在光滑、可逆的任务区域内。

### 冗余与阻尼分别改变哪一步

若 $r<n$ 且 $J_A$ 行满秩，则 $J_AJ_A^\dagger=I_r$。按[§3.5](sec3-5.md)取

$$\dot q=J_A^\dagger(\dot x_d+Ke)+(I_n-J_A^\dagger J_A)\dot q_0.$$

左乘 $J_A$，第一项成为 $\dot x_d+Ke$，第二项为零，所以仍有 $\dot e=-Ke$。精确抵消依靠的是**行满秩的右逆性质**，不是“任何伪逆都能消去雅可比”。

若改用阻尼算子 $J_A^*$，记要求的任务速度为 $u=\dot x_d+Ke$、实际未实现的部分为 $\delta=(I_r-J_AJ_A^*)u$，则

$$\dot e=\dot x_d-J_AJ_A^*u=-Ke+\delta.$$

阻尼抑制关节速度的同时，也改变了实际实现的任务速度。加入未实现部分后，误差方程已不是原来的精确线性形式，收敛性须由这个新方程判断。

### 先分清迭代时间与真实运动时间

若只想数值求出固定目标的一个关节解，$q$ 是计算机里的候选量，步长用于控制迭代修正。此时中间迭代点不一定满足真实机器人的速度、加速度或碰撞限制。

若把同一式子作为在线关节速度命令，$h$ 才对应实际控制更新时间，还要求底层能近似跟随命令。数学逆解成功不能自动证明这条实际运动过程可执行。

### 真正执行的一步，以及增益与步长

每个时刻按下面的顺序计算：

1. 用当前 $q_k$ 算 $x_k=k(q_k)$ 和 $J_A(q_k)$。
2. 算 $e_k=x_d(t_k)-x_k$，再解 $J_A(q_k)\dot q_k=\dot x_d(t_k)+Ke_k$。
3. 用步长 $h$ 更新 $q_{k+1}=q_k+h\dot q_k$。
4. **重新做正运动学**得到 $x_{k+1}=k(q_{k+1})$，再量误差；不能把线性预测值当作实际新位置。

式中的 $J_A^{-1}u$ 表示线性方程的解。实现时直接求解方程即可，无须先构造整个逆矩阵。

增益也不能只看正负。用最简单的线性任务 $x=q$、固定目标、标量增益 $k>0$，上面的欧拉更新给

$$e_{j+1}=(1-hk)e_j.$$

要让误差幅值趋零，必须 $|1-hk|<1$，即 $0<hk<2$。例如 $k=2$：

| 步长 $h$ | 每步乘数 $1-hk$ | 结果 |
|:--|:--|:--|
| 0.1s | 0.8 | 同号衰减 |
| 0.75s | −0.5 | 交替衰减 |
| 1s | −1 | 交替而不衰减 |
| 1.1s | −1.2 | 幅值增大 |

这是线性任务的精确结果。对非线性机械臂，有限更新还带有本节开头的高阶项，不能把 $0<hk<2$ 当作全局收敛保证。固定目标、取 $hK=I$ 时，逆方案的一步正是Newton迭代：用局部线性模型解下一次修正；初值和邻域仍然重要。

<a id="sec-3.7.2"></a>

## 3.7.2 雅可比转置：沿误差代价的下降方向走

### 从一个可微的代价推导转置

先取**固定目标**，即 $\dot x_d=0$。选误差代价

$$V(q)=\frac12 e(q)^{\mathrm T}K e(q).$$

它对 $q$ 求导时，$e=x_d-k(q)$ 的导数是 $-J_A$。对一个关节小变化 $\mathrm dq$，

$$\mathrm dV=e^{\mathrm T}K\,\mathrm de
=-e^{\mathrm T}KJ_A\,\mathrm dq
=(-J_A^{\mathrm T}Ke)^{\mathrm T}\mathrm dq.$$

所以梯度为 $\nabla_q V=-J_A^{\mathrm T}Ke$。沿负梯度取关节速度，就得到

$$\boxed{\dot q=J_A^{\mathrm T}Ke}. \tag{3.7-3}$$

这里是与 $x$ 配套的 $J_A^{\mathrm T}$；如果任务只有位置，它就是 $J_P^{\mathrm T}$。矩阵本来就可以是 $r\times n$，所以**冗余时也不用把转置换成伪逆**。

### Lyapunov方法在这里究竟算了什么

Lyapunov分析通过一个非负函数及其沿轨迹的变化率研究平衡点附近的运动。这里选用上面的误差代价 $V$，将转置方案代入，检查它能给出怎样的收敛结论。

对时间求导并代入转置方案：

$$\begin{aligned}
\dot V
&=e^{\mathrm T}K\dot e
=-e^{\mathrm T}KJ_A\dot q\\
&=-e^{\mathrm T}KJ_AJ_A^{\mathrm T}Ke
=-(J_A^{\mathrm T}Ke)^{\mathrm T}(J_A^{\mathrm T}Ke)\\
&=-\|J_A^{\mathrm T}Ke\|^2\le0.
\end{aligned}$$

如果 $J_A$ 行满秩，$J_A^{\mathrm T}a=0$ 只能发生在 $a=0$，因此非零误差使 $\dot V<0$。更具体地，若轨迹保持在一个区域内，且其中最小奇异值始终有下界 $\sigma_{\min}(J_A)\ge\sigma_0>0$，则

$$\dot V\le-\sigma_0^2\|Ke\|^2
\le-2\sigma_0^2\lambda_{\min}(K)V.$$

这给出该区域内的指数衰减估计。该结论需要区域和秩条件；不能只从某一点的满秩推出全局逆解一定成功。

转置方案的误差方程本身是

$$\dot e=-J_A(q)J_A(q)^{\mathrm T}Ke.$$

右边仍随 $q$ 变化，没有化成 $-Ke$。这解释了为何不能直接沿用逆方案的衰减速率，也解释了奇异方向上的减速。

### 两个边界：零梯度不一定到达目标，动目标也不同

**零梯度但误差不为零。** 单位杆长2R臂在 $q=(0,0)$ 时完全伸直，$p=(2,0)$，位置雅可比为

$$J_P=\begin{bmatrix}0&0\\2&1\end{bmatrix}.$$

目标取 $(1.5,0)$，则 $e=(-0.5,0)$；在 $K=kI$ 下 $J_P^{\mathrm T}Ke=0$，转置算法停在原地。目标却是可达的：取 $q_1=\arccos0.75$、$q_2=-2q_1$，末端便是 $(1.5,0)$。它缺的是当前位形下一阶径向速度，不是整个目标都不可达。

**目标在动。** 此时代价的导数多出一项：

$$\dot V=e^{\mathrm T}K\dot x_d-\|J_A^{\mathrm T}Ke\|^2.$$

第一项没有固定符号，不能沿用刚才常目标的证明。一个线性例子就能看到差异：$x=q$、$x_d=vt$、$\dot q=k(x_d-q)$，则

$$\dot e=v-ke,\qquad e(t)=\frac vk+\left(e(0)-\frac vk\right)e^{-kt}.$$

目标匀速时一般留下 $v/k$ 的跟踪偏差。逆方案包含的速度前馈正好抵消了这一项。

<figure>
<svg class="figure-svg" viewBox="0 0 780 410" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-37-title fig-37-desc">
<title id="fig-37-title">逆方案与转置方案的两条反馈通路</title>
<desc id="fig-37-desc">上行从期望与当前任务坐标的差得到误差，乘增益并加期望速度后，解分析雅可比方程得到关节速度；积分先得到关节位置，再由正运动学算任务坐标。下行是固定目标的转置方案，误差直接经分析雅可比转置和增益得到关节速度。两行都从当前关节位置重算雅可比，并反馈当前任务坐标。</desc>
<defs><marker id="f37-m" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto"><path d="M0,0 L6,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<g font-size="16" fill="var(--ink)">
<text x="20" y="26">逆方案：速度前馈 + 误差反馈</text>
<text x="20" y="225">转置方案：固定目标的误差代价下降</text>
<g fill="var(--paper-soft)" stroke="var(--line-strong)">
<rect x="20" y="57" width="85" height="54" rx="6"/><rect x="160" y="57" width="54" height="54" rx="6"/>
<rect x="315" y="57" width="116" height="54" rx="6"/><rect x="476" y="57" width="73" height="54" rx="6"/><rect x="597" y="57" width="117" height="54" rx="6"/>
<rect x="20" y="256" width="85" height="54" rx="6"/><rect x="315" y="256" width="116" height="54" rx="6"/><rect x="476" y="256" width="73" height="54" rx="6"/><rect x="597" y="256" width="117" height="54" rx="6"/>
<circle cx="132" cy="84" r="13"/><circle cx="261" cy="84" r="13"/><circle cx="132" cy="283" r="13"/>
</g>
<g text-anchor="middle">
<text x="62" y="81">期望 x<tspan baseline-shift="sub" font-size="12">d</tspan></text><text x="62" y="101" font-size="14">可随时间变</text><text x="187" y="90">K</text>
<text x="373" y="80">解 J<tspan baseline-shift="sub" font-size="12">A</tspan> q̇ = u</text><text x="373" y="101" font-size="14">u = ẋ<tspan baseline-shift="sub" font-size="11">d</tspan> + Ke</text>
<text x="512" y="80">积分 q̇</text><text x="512" y="101" font-size="14">得到 q</text><text x="656" y="80">正运动学</text><text x="656" y="101">x = k(q)</text>
<text x="62" y="279">固定 x<tspan baseline-shift="sub" font-size="12">d</tspan></text><text x="62" y="300" font-size="14">ẋ<tspan baseline-shift="sub" font-size="11">d</tspan> = 0</text>
<text x="373" y="279">q̇ = J<tspan baseline-shift="sub" font-size="12">A</tspan><tspan baseline-shift="super" font-size="12">T</tspan> Ke</text><text x="373" y="300" font-size="14">不解逆方程</text>
<text x="512" y="279">积分 q̇</text><text x="512" y="300" font-size="14">得到 q</text><text x="656" y="279">正运动学</text><text x="656" y="300">x = k(q)</text>
</g>
<g fill="none" stroke="var(--muted)" stroke-width="1.5" marker-end="url(#f37-m)">
<path d="M105 84H119"/><path d="M145 84H160"/><path d="M214 84H248"/><path d="M274 84H315"/><path d="M431 84H476"/><path d="M549 84H597"/><path d="M714 84H748V147H132V97"/><path d="M261 44V71"/>
<path d="M105 283H119"/><path d="M145 283H315"/><path d="M431 283H476"/><path d="M549 283H597"/><path d="M714 283H748V346H132V296"/>
</g>
<g font-size="14"><text x="146" y="69">e</text><text x="238" y="42">ẋ<tspan baseline-shift="sub" font-size="11">d</tspan></text><text x="115" y="68">+</text><text x="115" y="123">−</text><text x="274" y="69">u</text><text x="443" y="72">q̇</text><text x="563" y="72">q</text><text x="146" y="267">e</text><text x="115" y="267">+</text><text x="115" y="323">−</text><text x="443" y="270">q̇</text><text x="563" y="270">q</text>
<text x="322" y="177">每步从当前 q 重新计算 J<tspan baseline-shift="sub" font-size="11">A</tspan>，再反馈 x</text>
<text x="20" y="383">矩阵与任务坐标配套；冗余时逆方案需右逆条件，转置方案本可使用长方矩阵。</text></g>
</g>
</svg>
<figcaption>积分器先从关节速度得到关节位置，正运动学再从关节位置得到任务坐标。这两个步骤不同；下行的转置也不能直接替换上行求解块而保留所有前馈结构。</figcaption>
</figure>

<a id="sec-3.7.3"></a>

## 3.7.3 姿态误差：先定义，再推导变化率

前两种算法用了坐标差 $e=x_d-x$。位置差 $p_d-p_e$ 没有歧义，姿态却必须说明采用什么表示、误差朝哪个方向，以及它的导数与角速度怎样关联。

### 欧拉角：局部坐标差必须连续

在同一光滑分支内，取 $e_O=\boldsymbol\varphi_d-\boldsymbol\varphi_e$，就有 $\dot e_O=\dot{\boldsymbol\varphi}_d-\dot{\boldsymbol\varphi}_e$，所以前面使用分析雅可比的推导适用。

但角度不能不加处理地逐项相减。例如绕同一固定轴，当前179°、目标−179°，物理上可沿正向转2°，数值直接相减却是−358°。在这个局部问题中，应把目标的同一代表写成181°，使坐标沿运动连续。把差值包到某个主值区间仍会在区间边界产生跳变；ZYZ在 $\sin\vartheta=0$ 的表示奇点也没有因此消失。

<details>
<summary>选读：用旋转矩阵或四元数定义姿态误差</summary>

### 列叉积误差：推清方向和适用范围

设 $R_e=[r_{e1},r_{e2},r_{e3}]$ 是当前姿态，$R_d=[r_{d1},r_{d2},r_{d3}]$ 是期望姿态，两者的列都用基系表示。选取

$$E=R_dR_e^{\mathrm T},\qquad
 e_O=\frac12\sum_{i=1}^3 r_{ei}\times r_{di}. \tag{3.7-4}$$

叉积顺序是**当前列叉乘期望列**。为什么这样定义？利用 $S(a\times b)=ba^{\mathrm T}-ab^{\mathrm T}$，逐列相加得到

$$S(e_O)=\frac12(R_dR_e^{\mathrm T}-R_eR_d^{\mathrm T})=\frac12(E-E^{\mathrm T}).$$

如果 $E$ 的轴角为 $(r,\theta)$，由[Rodrigues公式](../ch02/sec2-5.md)知 $E-E^{\mathrm T}=2\sin\theta\,S(r)$，于是 $e_O=r\sin\theta$。它与旋转向量 $r\theta$ 不同，只在小角度时近似相同。

可跟算：当前 $R_e=I$，期望 $R_d=R_z(60^\circ)$。前两列的叉积各为 $(0,0,\sqrt3/2)$，第三列为零，除以2后得到 $e_O=(0,0,\sqrt3/2)$。若顺序反过来，修正方向就会反号。

还要检查退化：60°和120°给相同的正弦值；180°时 $e_O=0$，但姿态并未对齐。因此这里采用近目标的误差区域，不能把这个向量当作全局唯一的姿态差。

它的导数也不是简单的 $\omega_d-\omega_e$。记

$$L=-\frac12\sum_i S(r_{di})S(r_{ei}).$$

由 $\dot r_{ei}=\omega_e\times r_{ei}$ 和期望列的同类关系，对一项求导：

$$\begin{aligned}
\frac{\mathrm d}{\mathrm dt}(r_{ei}\times r_{di})
&=(\omega_e\times r_{ei})\times r_{di}
 +r_{ei}\times(\omega_d\times r_{di})\\
&=S(r_{di})S(r_{ei})\omega_e
 -S(r_{ei})S(r_{di})\omega_d.
\end{aligned}$$

求和并乘 $1/2$，得到

$$\boxed{\dot e_O=L^{\mathrm T}\omega_d-L\omega_e}. \tag{3.7-5}$$

于是完整误差满足

$$\dot e=\begin{bmatrix}\dot p_d\\L^{\mathrm T}\omega_d\end{bmatrix}
-\begin{bmatrix}I_3&0\\0&L\end{bmatrix}J\dot q.$$

这里才能使用输出物理角速度的几何 $J$。例如固定期望姿态且 $L$ 可逆时，要指定 $\dot e_O=-K_Oe_O$，须令 $\omega_e=L^{-1}K_Oe_O$，再与位置速度一起反解关节。

$L$ 的条件不能略去。沿上述 $z$ 轴误差，$L_{33}=\cos\theta$，其余对应块为 $\tfrac12\begin{bmatrix}1+\cos\theta&-\sin\theta\\\sin\theta&1+\cos\theta\end{bmatrix}$；在90°处 $L$ 已奇异。换成这种误差并不意味着可以任意大角度套用逆换算。

### 四元数：无欧拉角表示奇点，也有符号选择

采用[§2.6](../ch02/sec2-6.md)的Hamilton、标量在前约定。设 $Q_d=(\eta_d,\epsilon_d)$、$Q_e=(\eta_e,\epsilon_e)$ 均为单位[四元数](../recall.md#quaternion)，选误差四元数

$$\Delta Q=Q_dQ_e^{-1}=(\Delta\eta,\Delta\epsilon).$$

将 $Q_e^{-1}=(\eta_e,-\epsilon_e)$ 代入乘法规则，得

$$\Delta\eta=\eta_d\eta_e+\epsilon_d^{\mathrm T}\epsilon_e,\qquad
\Delta\epsilon=\eta_e\epsilon_d-\eta_d\epsilon_e-\epsilon_d\times\epsilon_e.$$

取 $e_O=\Delta\epsilon$ 时，它等于 $r\sin(\theta/2)$。同一个60°误差现在给 $(0,0,1/2)$，不是列叉积误差的 $(0,0,\sqrt3/2)$；两者的尺度不同，增益不能只换符号照搬。

$Q$ 与 $-Q$ 表示同一姿态。局部跟踪先对齐符号，常选 $\Delta\eta\ge0$ 的近端代表；在180°处仍有轴方向的二义性。单位四元数避开欧拉角表示奇点，不等于获得全局唯一、处处连续的三个误差坐标。

再看一个固定目标的变化率，说明为什么不能套用线性结论。基系角速度给出 $\dot Q_e=\tfrac12(0,\omega_e)Q_e$，目标固定时

$$\Delta\dot Q=-\frac12\Delta Q(0,\omega_e),$$

展开乘积便有

$$\Delta\dot\eta=\frac12\Delta\epsilon^{\mathrm T}\omega_e,\qquad
\Delta\dot\epsilon=-\frac12\big(\Delta\eta I_3+S(\Delta\epsilon)\big)\omega_e.$$

例如令 $\omega_e=K_O\Delta\epsilon$，取 $V_O=1-\Delta\eta$，则 $\dot V_O=-\tfrac12\Delta\epsilon^{\mathrm T}K_O\Delta\epsilon\le0$。在选定的近目标代表内可研究其收敛，但误差导数仍是上面的**非线性**方程。姿态误差改变后，必须重新检查导数和条件。

</details>

<a id="sec-3.7.4"></a>

## 3.7.4 二阶算法：求的是关节加速度

### 先对速度方程求导

回到光滑任务坐标 $x=k(q)$。对 $\dot x=J_A(q)\dot q$ 使用乘积法则：

$$\ddot x=J_A\ddot q+\dot J_A\dot q,\qquad
\dot J_A=\sum_{i=1}^n\frac{\partial J_A}{\partial q_i}\dot q_i.$$

第一项来自关节加速度；第二项来自关节运动时雅可比自身的变化。即使 $\ddot q=0$，末端也可能有加速度，正如匀速圆周运动仍有向心加速度。

再假设期望任务 $x_d$ 二次可微，误差的二阶导数为

$$\ddot e=\ddot x_d-J_A\ddot q-\dot J_A\dot q.$$

希望它满足 $\ddot e+K_D\dot e+K_Pe=0$。当 $J_A$ 方阵可逆时，逐项移到所需加速度一侧：

$$J_A\ddot q=\ddot x_d+K_D\dot e+K_Pe-\dot J_A\dot q,$$

$$\boxed{\ddot q=J_A^{-1}\big(\ddot x_d+K_D\dot e+K_Pe-\dot J_A\dot q\big)}. \tag{3.7-6}$$

将式(3.7-6)回代，$\ddot x_d$ 和 $\dot J_A\dot q$ 分别相消，才得到指定的误差方程。误差方程描述希望达到的行为，式(3.7-6)则给出实现它所需的关节加速度，两者共同构成算法。

### 为什么稳定，以及它与一阶方案的区别

取常对称正定 $K_P,K_D$。用

$$V=\frac12\dot e^{\mathrm T}\dot e+\frac12e^{\mathrm T}K_Pe$$

观察误差运动，求导并代入二阶方程：

$$\dot V=\dot e^{\mathrm T}\ddot e+\dot e^{\mathrm T}K_Pe
=-\dot e^{\mathrm T}K_D\dot e\le0.$$

若运动始终停在 $\dot V=0$，则 $\dot e=0$；要一直保持它，还须 $\ddot e=-K_Pe=0$，从而 $e=0$。因此这个线性误差系统的平衡点渐近稳定。实际机械臂上的结论仍受前述光滑、可逆及积分条件约束。

对角增益时，每一维满足 $\ddot e_i+k_{Di}\dot e_i+k_{Pi}e_i=0$。令 $k_P=k^2,k_D=2k$，特征式为 $(s+k)^2$，称为**临界阻尼**：没有振荡的重实根。若初始误差速度为零，

$$e(t)=(1+kt)e^{-kt}e(0).$$

它不同于一阶的 $e^{-kt}e(0)$。二阶算法可指定关节速度的变化，并不因此天然收敛更快。

冗余且 $J_A$ 行满秩时，可用 $J_A^\dagger$ 乘式(3.7-6)的括号，再加 $(I-J_A^\dagger J_A)\ddot q_0$；左乘 $J_A$ 后仍抵消。这里加的是零空间**加速度**，不能把它写成一阶的速度项。

### 两次积分怎样执行

二阶算法需要保存当前 $q_k$ 和 $\dot q_k$。算出 $\ddot q_k$ 后，本节实验采用显式欧拉：

$$q_{k+1}=q_k+h\dot q_k,\qquad
\dot q_{k+1}=\dot q_k+h\ddot q_k.$$

两式都使用旧时刻的状态，因此位置更新没有自动包含 $\tfrac12h^2\ddot q_k$；改用其他积分法，数值轨迹也会改变。计算二阶方案前，还须给出 $\dot J_A$、期望加速度和初始关节速度。

<a id="sec-3.7.5"></a>

## 3.7.5 同一台2R臂：手算一步，再比较完整过程

### 逆方案与转置方案的一步

用两个1m杆长的转动关节，只控制平面位置：

$$p(q)=\begin{bmatrix}\cos q_1+\cos(q_1+q_2)\\\sin q_1+\sin(q_1+q_2)\end{bmatrix},\qquad
J_P=\begin{bmatrix}-\sin q_1-\sin(q_1+q_2)&-\sin(q_1+q_2)\\\cos q_1+\cos(q_1+q_2)&\cos(q_1+q_2)\end{bmatrix}.$$

初始 $q=(0,\pi/2)$，所以 $p=(1,1)$、$J_P=\begin{bmatrix}-1&-1\\1&0\end{bmatrix}$。固定目标 $p_d=(1.1,0.9)$，得 $e=(0.1,-0.1)$。取 $K=2I$：

- 逆方案解 $J_P\dot q=(0.2,-0.2)$。第二行给 $\dot q_1=-0.2$，第一行再给 $\dot q_2=0$。
- 转置方案直接乘 $J_P^{\mathrm T}(0.2,-0.2)=(-0.4,-0.2)$。

取 $h=0.1$s，并**重新做三角函数正运动学**：

| 方案 | 新关节角 $q^+$（rad） | 实际新误差 $p_d-p(q^+)$（m） |
|:--|:--|:--|
| 逆 | $(-0.02,\pi/2)$ | $(0.08020133,-0.07980134)$ |
| 转置 | $(-0.04,\pi/2-0.02)$ | $(0.04083589,-0.05821121)$ |

逆方案的线性预测为 $e+h(-2e)=(0.08,-0.08)$，与实际值略有差异，正是有限步高阶项。转置这一步更接近目标，却不能据此推出整段收敛更快。

### 有初速的二阶计算，不能漏掉哪个量

仍在同一初始构形和目标处，改给 $\dot q=(0.2,-0.1)$，取 $K_P=K_D=4I$。计算

$$J_P\dot q=(-0.1,0.2),\qquad \dot e=(0.1,-0.2).$$

对上面的 $J_P$ 逐元素求导，代入此时的角与角速度，得到

$$\dot J_P=\begin{bmatrix}-0.2&0\\-0.1&-0.1\end{bmatrix},\qquad
\dot J_P\dot q=(-0.04,-0.01).$$

固定目标 $\ddot p_d=0$，式(3.7-6)括号中的任务加速度为

$$4\dot e+4e-\dot J_P\dot q=(0.84,-1.19).$$

解 $J_P\ddot q=(0.84,-1.19)$：第二行给 $\ddot q_1=-1.19$，第一行给 $\ddot q_2=0.35$ rad/s²。回代

$$\ddot e=-J_P\ddot q-\dot J_P\dot q=(-0.8,1.2)
=-4\dot e-4e.$$

若漏掉 $\dot J_P\dot q$，这个等式就不成立。

### 实验：比较误差曲线，别只看第一步

下方三个算法使用上面的**同一固定目标和同一初始构形**。一阶增益为 $K=kI$，二阶取 $K_P=k^2I,K_D=2kI$，初始关节速度为零；都是显式欧拉，每步重算当前雅可比和实际位置。显示的是运动学数值模型。

先预测 $h=0.1$s 时逆、转置方案的第一步，再选择相应步长并点“下一步”核对。二阶方案第一步的位置为什么不变？因为本积分法用旧速度更新位置，而初始速度为零；第一步先改变了速度。

<div class="lab" data-lab="ikFeedback"></div>

继续比较4秒时的结果，并改变 $k$ 或减半步长。结合误差、当前关节速度和曲线形状，说明相同数值增益为何产生不同的误差变化。这个实验只覆盖一个目标和一个初值，不能据此给算法作普遍性能排名。

<a id="practice-3.7"></a>

## 3.7.6 独立练习与闭卷重建

先独立计算，再展开答案。

1. 线性任务 $x=q$、固定目标、一阶增益 $k=4\,\mathrm{s}^{-1}$。步长分别取0.1s、0.4s、0.6s，求每步误差乘数并判断衰减还是放大。若改为匀速目标 $x_d=0.8t$，纯转置反馈的稳态误差是多少？
2. 对上述2R初始构形，换目标为 $(0.9,1.2)$，取 $K=2I$，分别求逆方案与转置方案的关节速度，计算各自的瞬时误差导数。这个时刻是否都等于 $-2e$？
3. 固定任务 $x=q^2$，在 $q=2,\dot q=0.5$ 时，目标 $x_d=5$。取 $k_P=4,k_D=3$，求 $J_A,\dot J_A,\dot e,\ddot q$，再回代二阶误差方程。
4. 当前姿态为 $I$，期望绕基系 $z$ 轴转120°。求列叉积误差与选近端代表的四元数向量误差。说明它们为什么不能直接互换，也不能把列叉积误差为零当成全局姿态对齐判据。

::: sol 逐题核对

1. 乘数 $1-4h$ 分别为0.6、−0.6、−1.4：前两者衰减，第二个交替变号，第三个放大。匀速目标下 $\dot e=0.8-4e$，稳态为0.2；逆方案加入速度前馈后，才消去0.8这一项。
2. $e=(-0.1,0.2)$，$Ke=(-0.2,0.4)$。逆方案解两行得 $\dot q=(0.4,-0.2)$，所以 $\dot e=-J_P\dot q=(0.2,-0.4)=-2e$。转置方案得 $\dot q=(0.6,0.2)$，$J_P\dot q=(-0.8,0.6)$，因此 $\dot e=(0.8,-0.6)$，不是 $-2e$。这里使用的是位置任务 $J_P$，不是把两种姿态雅可比混在一起。
3. $J_A=2q=4$、$\dot J_A=2\dot q=1$；$e=5-4=1$，$\dot e=-J_A\dot q=-2$。任务加速度括号是 $3(-2)+4(1)-1(0.5)=-2.5$，所以 $\ddot q=-0.625$。回代 $\ddot e=-4(-0.625)-1(0.5)=2$，而 $\ddot e+3\dot e+4e=2-6+4=0$。
4. 列叉积误差为 $(0,0,\sin120^\circ)=(0,0,\sqrt3/2)$；误差四元数为 $(1/2,0,0,\sqrt3/2)$，向量部分也恰为 $(0,0,\sqrt3/2)$，但这只是这个角度的数值巧合。60°时两者分别是 $\sqrt3/2$ 与 $1/2$；它们的导数公式也不同。180°时列叉积为零而姿态不同，已足以否定全局对齐判据。

:::

<a id="sec-3.7"></a>


## 3.7 小结与下一节

逆方案通过解速度方程抵消任务雅可比；转置方案沿固定目标误差代价的负梯度移动；二阶方案进一步求解关节加速度，并补偿雅可比的时间变化。它们的误差方程、所需输入、矩阵条件和积分状态都不同。

下一节仍会出现转置，但输出改为关节力矩。那里的 $J^{\mathrm T}$ 来自虚功和功率的对偶关系；这里的 $J_A^{\mathrm T}$ 来自误差代价对关节坐标的求导。两处的对象和单位需要分别说明。
