# 2.7 齐次变换与特殊欧几里得群 $SE(3)$

> **本节定位**：`核心必考` ｜ 将一般位姿下的原点偏移与姿态旋转统一打包为 $4\times 4$ 齐次变换矩阵 $SE(3)$；阐明点（末分量 $1$）与自由方向（末分量 $0$）的矩阵分块机制；证明逆变换公式 $A_0^1=(A_1^0)^{-1}$ 与整体正交充要条件（$\boldsymbol o=\boldsymbol 0$）；建立多坐标系链式连乘与李代数 $se(3)$ 空间速度矩阵基础。原书对应 §2.7。

<a id="sec-2.7.1"></a>

## 2.7.1 原点不重合时的坐标变换

设物理点 $P$ 在坐标系 $0$ 与坐标系 $1$ 中的位置坐标列分别为 $\boldsymbol p^0,\boldsymbol p^1\in\mathbb R^3$，坐标系 $1$ 原点在坐标系 $0$ 中的位置为 $\boldsymbol o_1^0\in\mathbb R^3$（原书图 2.11、式 2.38–2.40）。由向量加法 $\overrightarrow{O_0P}=\overrightarrow{O_0O_1}+\overrightarrow{O_1P}$ 并将向量统一投影至系 $0$，得坐标换算与逆换算：
$$\boldsymbol p^0 = \boldsymbol o_1^0 + R_1^0\boldsymbol p^1, \qquad
\boldsymbol p^1 = (R_1^0)^{\mathrm T}(\boldsymbol p^0-\boldsymbol o_1^0) = R_0^1\boldsymbol p^0 - R_0^1\boldsymbol o_1^0.$$
若再经坐标系 $2$（$\boldsymbol p^1=\boldsymbol o_2^1+R_2^1\boldsymbol p^2$）级联，代入得：
$$\boldsymbol p^0 = \boldsymbol o_1^0 + R_1^0\boldsymbol o_2^1 + R_1^0 R_2^1\boldsymbol p^2.$$
第二段原点偏移 $\boldsymbol o_2^1$ 必须先左乘 $R_1^0$ 换算至系 $0$ 才可与 $\boldsymbol o_1^0$ 相加。通过扩充第 $4$ 齐次分量，可将嵌套的旋转和平移统一为矩阵连乘。

<a id="sec-2.7.2"></a>

## 2.7.2 齐次坐标、$SE(3)$ 群与底行作用

::: def 定义 2.7.1 · 齐次坐标与特殊欧几里得群 $SE(3)$ {#def-2.7.1}
在三维坐标后补充第 $4$ 分量：点的位置向量取末分量 $1$，自由方向向量取末分量 $0$：
$$\tilde{\boldsymbol p}=\begin{bmatrix}\boldsymbol p\\ 1\end{bmatrix},\qquad
\tilde{\boldsymbol d}=\begin{bmatrix}\boldsymbol d\\ 0\end{bmatrix}.$$
定义 $4\times 4$ **齐次变换矩阵**（homogeneous transformation matrix）及**特殊欧几里得群** $SE(3)$（原书式 2.41–2.43）：
$$A_1^0 = \begin{bmatrix}R_1^0 & \boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix},\qquad
\tilde{\boldsymbol p}^0 = A_1^0\tilde{\boldsymbol p}^1,\qquad
SE(3)=\left\{\begin{bmatrix}R & \boldsymbol o\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix} : R\in SO(3),\ \boldsymbol o\in\mathbb R^3\right\}.$$
:::

对任意列向量 $\begin{bmatrix}\boldsymbol x\\ w\end{bmatrix}$ 分块相乘：
$$\begin{bmatrix}R & \boldsymbol o\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix}\begin{bmatrix}\boldsymbol x\\ w\end{bmatrix}=\begin{bmatrix}R\boldsymbol x + w\boldsymbol o\\ w\end{bmatrix}.$$
底行 $[0,0,0,1]$ 保持第 $4$ 分量 $w$ 不变：点取 $w=1$ 计入原点偏移 $\boldsymbol o$，自由方向取 $w=0$ 屏蔽平移而仅受旋转 $R$ 作用（自由方向不可作末分量归一化）。从群乘法可见，$SE(3)$ 并非直积，而具有半直积乘法结构：$(R,\boldsymbol o)(S,\boldsymbol t)=(RS,\ \boldsymbol o+R\boldsymbol t)$。

<a id="sec-2.7.3"></a>

## 2.7.3 分块逆变换与整体正交边界

由 $\boldsymbol p^1=(R_1^0)^{\mathrm T}(\boldsymbol p^0-\boldsymbol o_1^0)$ 直接写出齐次变换矩阵的逆（原书式 2.44–2.45）：
$$A_0^1 = (A_1^0)^{-1} = \begin{bmatrix}(R_1^0)^{\mathrm T} & -(R_1^0)^{\mathrm T}\boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix}.$$
逆矩阵的平移块为 $-R^{\mathrm T}\boldsymbol o$（在系 $1$ 中表达），一般不等于 $-\boldsymbol o$。

::: proof 证明 · 分块逆校验与整体正交充要条件
令 $B=\begin{bmatrix}R^{\mathrm T}&-R^{\mathrm T}\boldsymbol o\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$，分块乘得 $BA=\begin{bmatrix}R^{\mathrm T}R & R^{\mathrm T}\boldsymbol o-R^{\mathrm T}\boldsymbol o\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}=I_4$，同理 $AB=I_4$，故 $B=A^{-1}$。再计算 Gram 矩阵：
$$A^{\mathrm T}A = \begin{bmatrix}R^{\mathrm T} & \boldsymbol 0\\ \boldsymbol o^{\mathrm T} & 1\end{bmatrix}\begin{bmatrix}R & \boldsymbol o\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix} = \begin{bmatrix}I_3 & R^{\mathrm T}\boldsymbol o\\ \boldsymbol o^{\mathrm T}R & 1+\boldsymbol o^{\mathrm T}\boldsymbol o\end{bmatrix}.$$
上式等于 $I_4$ 当且仅当 $R^{\mathrm T}\boldsymbol o=\boldsymbol 0$ 且 $\|\boldsymbol o\|^2=0$，即**$A^{-1}=A^{\mathrm T}\iff \boldsymbol o=\boldsymbol 0$**（非零平移时齐次矩阵整体不正交，尽管 $\det A=\det R=+1$ 恒成立）。□
:::

<a id="sec-2.7.4"></a>

## 2.7.4 链式连乘与算例

::: thm 定理 2.7.A · 齐次变换链式连乘（原书式 2.47） {#thm-2.7.A}
对依次相连的坐标系 $0,1,\dots,n$，同一点的坐标逐级换算由右侧先作用、相邻上下标对齐的连乘给出：
$$\tilde{\boldsymbol p}^0 = A_1^0 A_2^1 \cdots A_n^{n-1} \tilde{\boldsymbol p}^n, \qquad
A_2^0 = A_1^0 A_2^1 = \begin{bmatrix}R_1^0 R_2^1 & \boldsymbol o_1^0 + R_1^0\boldsymbol o_2^1\\ \boldsymbol 0^{\mathrm T} & 1\end{bmatrix}.$$
交换矩阵顺序（如误写 $A_2^1 A_1^0$）不仅破坏坐标系接口匹配，亦给出错误位姿。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 310" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-27-title fig-27-desc">
<title id="fig-27-title">同一点逐系换坐标与齐次矩阵分块</title>
<desc id="fig-27-desc">左侧三个框依次是同一物理点的系2、系1、系0坐标，箭头先乘系2到系1的矩阵，再乘系1到系0的矩阵。右侧旋转块、平移列与底行展示矩阵结构。点的位置不因换坐标而移动。</desc>
<defs><marker id="f27-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<text class="diagram-text" x="280" y="35" text-anchor="middle">同一个物理点 P，三组坐标</text>
<g class="diagram-node"><rect x="30" y="105" width="110" height="60" rx="8"/><rect x="220" y="105" width="110" height="60" rx="8"/><rect x="410" y="105" width="110" height="60" rx="8"/></g>
<g class="diagram-text" text-anchor="middle"><text x="85" y="141">p̃²</text><text x="275" y="141">p̃¹</text><text x="465" y="141">p̃⁰</text><text x="180" y="90">A₂¹</text><text x="370" y="90">A₁⁰</text></g>
<g stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f27-m)"><line x1="140" y1="135" x2="216" y2="135"/><line x1="330" y1="135" x2="406" y2="135"/></g>
<text class="diagram-note" x="275" y="208" text-anchor="middle">先 2→1，再 1→0；点没有移动</text>
<text class="diagram-text" x="275" y="251" text-anchor="middle">p̃⁰ = A₁⁰ A₂¹ p̃²</text>
<text class="diagram-text" x="735" y="35" text-anchor="middle">A 的分块结构</text>
<rect class="diagram-fill-accent" x="595" y="65" width="210" height="140"/><rect class="diagram-fill-sage" x="805" y="65" width="70" height="140"/>
<rect class="diagram-node" x="595" y="205" width="280" height="40"/>
<g class="diagram-text" text-anchor="middle"><text x="700" y="143">R</text><text x="840" y="143">o</text><text x="630" y="232">0</text><text x="700" y="232">0</text><text x="770" y="232">0</text><text x="840" y="232">1</text></g>
<text class="diagram-note" x="735" y="280" text-anchor="middle">末分量保持：点 1，方向 0</text>
</svg>
<figcaption>齐次变换的链式坐标换算及矩阵分块语义（本教程绘）。</figcaption>
</figure>

::: ex 例 2.7.B · 同矩阵对点、方向与逆变换的数值对照 {#ex-2.7.B}
设 $R_1^0=R_z(90^\circ),\ \boldsymbol o_1^0=(2,1,0)^{\mathrm T}\,\mathrm m$。系 $1$ 中有点 $\boldsymbol p^1=(1,0,0)^{\mathrm T}\,\mathrm m$ 与自由方向 $\boldsymbol d^1=(1,0,0)^{\mathrm T}$。

::: sol 解与逆变换校验
$$A_1^0=\begin{bmatrix}0&-1&0&2\\1&0&0&1\\0&0&1&0\\0&0&0&1\end{bmatrix},\qquad
A_0^1=\begin{bmatrix}0&1&0&-1\\-1&0&0&2\\0&0&1&0\\0&0&0&1\end{bmatrix}.$$
点取末分量 $1$ 得 $\boldsymbol p^0=R_1^0\boldsymbol p^1+\boldsymbol o_1^0=(2,2,0)^{\mathrm T}\,\mathrm m$；自由方向取末分量 $0$ 得 $\boldsymbol d^0=R_1^0\boldsymbol d^1=(0,1,0)^{\mathrm T}$。逆平移块为 $-R_1^{0\mathrm T}\boldsymbol o_1^0=(-1,2,0)^{\mathrm T}\,\mathrm m$，将 $[2,2,0,1]^{\mathrm T}$ 映回 $[1,0,0,1]^{\mathrm T}$（误用 $-\boldsymbol o_1^0$ 则错得 $(0,-3,0)^{\mathrm T}$）。
:::
:::

::: think 练习 1 · 纯平移齐次变换与正交性边界 {#practice-2.7.inverse}
取 $R=I_3,\ \boldsymbol o=(2,-1,3)^{\mathrm T}\,\mathrm m$，点 $\boldsymbol p=(1,2,0)^{\mathrm T}\,\mathrm m$ 与方向 $\boldsymbol d=(1,2,0)^{\mathrm T}$。求正逆变换结果，并判断 $A$ 是否正交。

::: sol 核对
点映至 $(3,1,3)^{\mathrm T}\,\mathrm m$，方向仍为 $(1,2,0)^{\mathrm T}$；逆平移为 $(-2,1,-3)^{\mathrm T}\,\mathrm m$。因 $\boldsymbol o\neq\boldsymbol 0$，虽然 $\det A=+1$，但 $A^{\mathrm T}A\neq I_4$；仅当平移 $\boldsymbol o=\boldsymbol 0$ 时 $A=I_4$ 才正交。
:::
:::

::: ex 例 2.7.C · 两段旋转平移合成与错序对照 {#ex-2.7.C}
接例 2.7.B，再取 $R_2^1=R_x(90^\circ),\ \boldsymbol o_2^1=(1,0,0)^{\mathrm T}\,\mathrm m$ 与点 $\boldsymbol p^2=(0,1,0)^{\mathrm T}\,\mathrm m$。求 $A_2^0$ 与 $\boldsymbol p^0$，并对比错序乘积 $A_2^1 A_1^0$：
$$A_2^1=\begin{bmatrix}1&0&0&1\\0&0&-1&0\\0&1&0&0\\0&0&0&1\end{bmatrix},\qquad
A_2^0=A_1^0 A_2^1=\begin{bmatrix}0&0&1&2\\1&0&0&2\\0&1&0&0\\0&0&0&1\end{bmatrix}.$$
第二段原点偏移 $\boldsymbol o_2^1$ 在系 $0$ 中沿 $+y_0$，得 $\boldsymbol o_2^0=(2,2,0)^{\mathrm T}\,\mathrm m$、$\boldsymbol p^0=(2,2,1)^{\mathrm T}\,\mathrm m$（与逐级换得 $\boldsymbol p^1=(1,0,1)^{\mathrm T}$ 后再换至系 $0$ 一致）。错序 $(A_2^1 A_1^0)[\boldsymbol p^2;1]$ 不止坐标系下标不接，结果亦错为 $(2,0,1)^{\mathrm T}\,\mathrm m$。
:::

<a id="lab-2.7"></a>

<div class="lab" data-lab="homogeneous3d" hidden></div>

::: think 练习 2 · 两段链式口算检验 {#practice-2.7.chain}
沿用例 2.7.B 的 $A_1^0$，令 $R_2^1=I_3,\ \boldsymbol o_2^1=(1,0,0)^{\mathrm T}\,\mathrm m$。不展开 $4\times 4$ 矩阵，直接求 $\boldsymbol o_2^0$、点 $\boldsymbol p^2=(0,1,0)^{\mathrm T}\,\mathrm m$ 与方向 $\boldsymbol d^2=(0,1,0)^{\mathrm T}$ 在系 $0$ 中的坐标。

::: sol 核对
$\boldsymbol o_2^0=(2,2,0)^{\mathrm T}\,\mathrm m$，$R_2^0=R_z(90^\circ)$；故点为 $(1,2,0)^{\mathrm T}\,\mathrm m$，方向为 $(-1,0,0)^{\mathrm T}$。
:::
:::

::: think 练习 3 · 刚体保距离与点模长变化 {#practice-2.7.distance}
在练习 2 中再取点 $\boldsymbol q^2=(1,1,0)^{\mathrm T}\,\mathrm m$，求 $\boldsymbol q^0$ 并比较 $\|\boldsymbol q^0-\boldsymbol p^0\|$ 与 $\|\boldsymbol q^2-\boldsymbol p^2\|$、以及 $\|\boldsymbol p^0\|$ 与 $\|\boldsymbol p^2\|$。

::: sol 核对
$\boldsymbol q^0=(1,3,0)^{\mathrm T}\,\mathrm m$，两点之差 $[\boldsymbol q^2-\boldsymbol p^2;0]$ 末分量为 $0$，平移相消，故距离在两系中均保持 $1\,\mathrm m$；但原点不同使点到各自原点的模长从 $\|\boldsymbol p^2\|=1\,\mathrm m$ 变为 $\|\boldsymbol p^0\|=\sqrt{5}\,\mathrm m$。
:::
:::

::: note 李代数 $se(3)$ 与空间速度矩阵 {#note-2.7.se3}
$SE(3)$ 在单位元 $I_4$ 处的切空间为 $6$ 维李代数（底行全零，矩阵恒不可逆）：
$$se(3)=\left\{\begin{bmatrix}S(\boldsymbol\omega) & \boldsymbol v\\ \boldsymbol 0^{\mathrm T} & 0\end{bmatrix} : \boldsymbol\omega,\boldsymbol v\in\mathbb R^3\right\}.$$
沿光滑轨迹 $A(t)=\begin{bmatrix}R(t)&\boldsymbol o(t)\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$，**空间速度矩阵**（spatial twist）定义为：
$$\hat\xi_s = \dot A A^{-1} = \begin{bmatrix}\dot R R^{\mathrm T} & \dot{\boldsymbol o}-\dot R R^{\mathrm T}\boldsymbol o\\ \boldsymbol 0^{\mathrm T} & 0\end{bmatrix}
= \begin{bmatrix}S(\boldsymbol\omega_s) & \boldsymbol v_s\\ \boldsymbol 0^{\mathrm T} & 0\end{bmatrix}, \qquad
\boldsymbol v_s = \dot{\boldsymbol o} - \boldsymbol\omega_s\times\boldsymbol o \neq \dot{\boldsymbol o}.$$
注意 $\boldsymbol v_s$ 是流经固定系原点处的瞬时重合点线速度，一般不等于动系原点速度 $\dot{\boldsymbol o}$（物体坐标系体速度则由 $A^{-1}\dot A$ 给出）。例如以恒角速度 $\omega$ 绕过 $(1,0,0)^{\mathrm T}\,\mathrm m$ 平行 $+z$ 的固定轴纯转（取 $A(0)=I_4$），当 $\omega=1\,\mathrm{rad/s}$ 时 $\boldsymbol\omega_s=(0,0,1)^{\mathrm T}\,\mathrm{rad/s},\ \boldsymbol v_s=(0,-1,0)^{\mathrm T}\,\mathrm m/s$，轨迹为：
$$A(t)=\begin{bmatrix}\cos t&-\sin t&0&1-\cos t\\ \sin t&\cos t&0&-\sin t\\ 0&0&1&0\\ 0&0&0&1\end{bmatrix},$$
在 $t=\pi/2\,\mathrm s$ 处原点位置 $(1,-1,0)^{\mathrm T}\,\mathrm m$、原点速度 $\dot{\boldsymbol o}=(1,0,0)^{\mathrm T}\,\mathrm m/s$；若角速度增至 $\omega=2\,\mathrm{rad/s}$，到达同一点时刻为 $t=\pi/4\,\mathrm s$，此时 $\dot{\boldsymbol o}=(2,0,0)^{\mathrm T}\,\mathrm m/s$ 而 $\boldsymbol v_s=(0,-2,0)^{\mathrm T}\,\mathrm m/s$。当旋转恒定时有 $A(t)=\exp(t\hat\xi_s)A(0)$。
:::

<a id="sec-2.7"></a>

::: think 默写点 · 合上书再写 {#sec-2.7-recall}
1. 写出点与自由方向的齐次坐标及矩阵 $A_1^0$ 对二者的统一作用。
2. 写出 $A_0^1=(A_1^0)^{-1}$ 分块表达式及整体正交充要条件。
3. 写出两段变换 $A_2^0=A_1^0 A_2^1$ 的分块结果及空间速度 $\boldsymbol v_s$ 与 $\dot{\boldsymbol o}$ 的关系。

::: sol 核对
1. 点 $[\boldsymbol p;1]$、方向 $[\boldsymbol d;0]$；分块乘得 $[R\boldsymbol x+w\boldsymbol o;\ w]$。
2. $A_0^1=\begin{bmatrix}R^{\mathrm T}&-R^{\mathrm T}\boldsymbol o\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$；$A^{-1}=A^{\mathrm T}\iff \boldsymbol o=\boldsymbol 0$。
3. $A_2^0=\begin{bmatrix}R_1^0 R_2^1&\boldsymbol o_1^0+R_1^0\boldsymbol o_2^1\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$；$\boldsymbol v_s=\dot{\boldsymbol o}-\boldsymbol\omega_s\times\boldsymbol o\neq\dot{\boldsymbol o}$。
:::
:::

## 2.7 小结与常见错误

**主线**：齐次变换将旋转与平移统一为 $4\times 4$ 群矩阵乘法，利用底行 $[0,0,0,1]$ 自动区分点（含平移）与自由方向（无平移）；多级串联遵循右侧先作用与上下标相邻对消。

| 公式 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $\tilde{\boldsymbol p}^0=A_1^0\tilde{\boldsymbol p}^1,\ A_1^0=\begin{bmatrix}R_1^0&\boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$ | 点末分量 $1$，自由方向 $0$ | 给自由方向误取末分量 $1$ 或对其作归一化 |
| $A_0^1=\begin{bmatrix}R_1^{0\mathrm T}&-R_1^{0\mathrm T}\boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$ | $A_1^0\in SE(3)$ | 逆平移误写 $-\boldsymbol o_1^0$；认为 $\det A=1$ 即整体正交 |
| $A_2^0=A_1^0 A_2^1$（平移块 $\boldsymbol o_1^0+R_1^0\boldsymbol o_2^1$） | 相邻坐标系接口 $1\leftrightarrow 1$ | 第二段平移漏乘 $R_1^0$；错序成 $A_2^1 A_1^0$ |
| $\hat\xi_s=\dot A A^{-1},\ \boldsymbol v_s=\dot{\boldsymbol o}-\boldsymbol\omega_s\times\boldsymbol o$ | $se(3)$ 底行全零（恒不可逆） | 将空间线速度 $\boldsymbol v_s$ 当作动系原点速度 $\dot{\boldsymbol o}$ |

::: think 本节的课堂幻灯片（源料对照）
| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 约 0:32:27 | [homogeneous-setup.jpg](../assets/ch02/homogeneous-setup.jpg) | 原点偏移与三角几何关系 | §2.7.1 写出原书式 (2.38)-(2.40) 与嵌套展开 |
| — | [homogeneous-matrix.jpg](../assets/ch02/homogeneous-matrix.jpg) | 齐次变换矩阵结构 | §2.7.2–§2.7.3 完整证明分块作用与正交边界 |
:::
