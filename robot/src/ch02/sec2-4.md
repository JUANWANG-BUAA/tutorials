# 2.4 欧拉角：ZYZ 与 RPY

> **本节定位**：`核心必考` ｜ 说明 $SO(3)$ 局部三参数表示（$27\to 12$ 种可行序列）；推导当前轴右乘 ZYZ 与固定轴左乘 RPY 正解矩阵；确立 $\operatorname{Atan2}(y,x)$ 实参约定与输入半径敏感度边界；求解 ZYZ 与 RPY 两支逆解并系统对比四个万向锁（gimbal lock）奇点。原书对应 §2.4。

{{#include ../assets/figures/robot-euler.md}}

<a id="sec-2.4.1"></a>

## 2.4.1 最小三参数表示与 12 种可行序列

$SO(3)$ 具有 $3$ 个连续自由度，故可用三个独立角度构造姿态的**局部最小表示**（minimal representation）。在三个基本轴的 $3^3=27$ 种连续组合中，相邻同轴旋转（如 $ZXX$ 或 $XXX$）会合并而退化，仅余 $3\times 2\times 2=12$ 种能张满三维空间旋转的可行序列：
- **真欧拉角**（首末轴相同，共 $6$ 种）：$XYX,\ XZX,\ YXY,\ YZY,\ ZXZ,\ ZYZ$；
- **Tait–Bryan / Cardan 角**（三轴互异，共 $6$ 种）：$XYZ,\ XZY,\ YXZ,\ YZX,\ ZXY,\ ZYX$。

序列名称本身不指定旋转轴究竟固定还是随动。使用任何欧拉角时**必须一并声明轴约定、角名称与旋转顺序**。本节将 ZYZ 约定为绕当前轴右乘，将 RPY 约定为绕固定轴左乘。

<a id="sec-2.4.2"></a>

## 2.4.2 ZYZ 欧拉角：当前轴右乘正解

设 $\boldsymbol\phi=[\varphi,\vartheta,\psi]^{\mathrm T}$。从 $I_3$ 出发逐次绕**当前轴**转动（原书图 2.8）：(1) 绕 $z_0$ 转 $\varphi$ 得系 $O\text{-}x'y'z'$（$z'=z_0$）；(2) 绕新 $y'$ 转 $\vartheta$ 得系 $O\text{-}x''y''z''$（$y''=y'$）；(3) 绕新 $z''$ 转 $\psi$ 得末系。由 [@thm-2.3.A] 逐次右乘（原书式 2.18）：
$$R_{\rm ZYZ}(\boldsymbol\phi)=R_z(\varphi)\,R_{y'}(\vartheta)\,R_{z''}(\psi)
=\begin{bmatrix}
c_\varphi c_\vartheta c_\psi-s_\varphi s_\psi & -c_\varphi c_\vartheta s_\psi-s_\varphi c_\psi & c_\varphi s_\vartheta\\
s_\varphi c_\vartheta c_\psi+c_\varphi s_\psi & -s_\varphi c_\vartheta s_\psi+c_\varphi c_\psi & s_\varphi s_\vartheta\\
-s_\vartheta c_\psi & s_\vartheta s_\psi & c_\vartheta
\end{bmatrix}.$$
注意其第 $3$ 列 $[c_\varphi s_\vartheta,\ s_\varphi s_\vartheta,\ c_\vartheta]^{\mathrm T}$ 即末端 $z''$ 轴的方向余弦，恰好不含自转角 $\psi$，且第 $3$ 行结构最简。

<figure>
<svg class="figure-svg" viewBox="0 0 920 350" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-zyzs-t fig-zyzs-d">
<title id="fig-zyzs-t">ZYZ 三步旋转的坐标架演化</title>
<desc id="fig-zyzs-d">三个面板依次为：绕 z 转 φ 后、绕新 y′ 转 ϑ 后、绕新 z″ 转 ψ 后的坐标架；灰色虚线为上一步旧架，粗线与圆环标出本次转轴。三步全绕当前轴，依次右乘。</desc>
<defs>
<marker id="fzs-m" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--muted)"/></marker>
<marker id="fzs-b" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-blue)"/></marker>
<marker id="fzs-n" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-green)"/></marker>
<marker id="fzs-g" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--fig-gold)"/></marker>
<marker id="fzs-a" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--accent-text)"/></marker>
</defs>
<text class="diagram-text" x="155" y="34" text-anchor="middle">① Rz(φ)：绕 z 转 φ（方位）</text>
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#fzs-m)" opacity=".75">
<line x1="155" y1="215" x2="221.2" y2="233"/>
<line x1="155" y1="215" x2="123.9" y2="197.1"/>
<line x1="155" y1="215" x2="155" y2="146"/>
</g>
<line stroke="var(--accent-text)" stroke-width="3" x1="155" y1="215" x2="155" y2="130"/>
<text class="diagram-note" fill="var(--accent-text)" x="163" y="136">轴 z</text>
<path d="M 191 182 A 36 10 0 1 1 119 182 A 36 10 0 1 1 191 182" fill="none" stroke="var(--accent-text)" stroke-width="1.7" marker-end="url(#fzs-a)"/>
<g stroke-width="2.4">
<line stroke="var(--fig-blue)" marker-end="url(#fzs-b)" x1="155" y1="215" x2="185.8" y2="217.2"/>
<line stroke="var(--fig-green)" marker-end="url(#fzs-n)" x1="155" y1="215" x2="88.6" y2="189.7"/>
<line stroke="var(--fig-gold)" marker-end="url(#fzs-g)" x1="155" y1="215" x2="155" y2="146"/>
</g>
<text class="diagram-text" fill="var(--fig-blue)" x="192" y="226">x′</text>
<text class="diagram-text" fill="var(--fig-green)" x="82" y="188" text-anchor="end">y′</text>
<text class="diagram-text" fill="var(--fig-gold)" x="150" y="140" text-anchor="end">z′</text>
<text class="diagram-text" x="465" y="34" text-anchor="middle">② Ry′(ϑ)：绕新 y′ 转 ϑ（俯仰）</text>
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#fzs-m)" opacity=".75">
<line x1="465" y1="215" x2="495.8" y2="217.2"/>
<line x1="465" y1="215" x2="398.6" y2="189.7"/>
<line x1="465" y1="215" x2="465" y2="146"/>
</g>
<line stroke="var(--accent-text)" stroke-width="3" x1="465" y1="215" x2="407.3" y2="193"/>
<text class="diagram-note" fill="var(--accent-text)" x="400" y="162" text-anchor="end">轴 y′</text>
<path d="M 448.3 172.4 A 34 10 -69.1 1 1 424.1 236 A 34 10 -69.1 1 1 448.3 172.4" fill="none" stroke="var(--accent-text)" stroke-width="1.7" marker-end="url(#fzs-a)"/>
<g stroke-width="2.4">
<line stroke="var(--fig-blue)" marker-end="url(#fzs-b)" x1="465" y1="215" x2="482.7" y2="272.8"/>
<line stroke="var(--fig-green)" marker-end="url(#fzs-n)" x1="465" y1="215" x2="398.6" y2="189.7"/>
<line stroke="var(--fig-gold)" marker-end="url(#fzs-g)" x1="465" y1="215" x2="490.2" y2="177.2"/>
</g>
<text class="diagram-text" fill="var(--fig-blue)" x="492" y="284">x″</text>
<text class="diagram-text" fill="var(--fig-green)" x="392" y="186" text-anchor="end">y″</text>
<text class="diagram-text" fill="var(--fig-gold)" x="498" y="174">z″</text>
<text class="diagram-text" x="775" y="34" text-anchor="middle">③ Rz″(ψ)：绕新 z″ 转 ψ（自转）</text>
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#fzs-m)" opacity=".75">
<line x1="775" y1="215" x2="792.7" y2="272.8"/>
<line x1="775" y1="215" x2="708.7" y2="189.7"/>
<line x1="775" y1="215" x2="800.2" y2="177.2"/>
</g>
<line stroke="var(--accent-text)" stroke-width="3" x1="775" y1="215" x2="796.9" y2="182.2"/>
<text class="diagram-note" fill="var(--accent-text)" x="824" y="196">轴 z″</text>
<path d="M 816.4 207 A 30 9 33.7 1 1 766.4 173.8 A 30 9 33.7 1 1 816.4 207" fill="none" stroke="var(--accent-text)" stroke-width="1.7" marker-end="url(#fzs-a)"/>
<g stroke-width="2.4">
<line stroke="var(--fig-blue)" marker-end="url(#fzs-b)" x1="775" y1="215" x2="757.1" y2="252.4"/>
<line stroke="var(--fig-green)" marker-end="url(#fzs-n)" x1="775" y1="215" x2="708.7" y2="164.2"/>
<line stroke="var(--fig-gold)" marker-end="url(#fzs-g)" x1="775" y1="215" x2="800.2" y2="177.2"/>
</g>
<text class="diagram-text" fill="var(--fig-blue)" x="750" y="264" text-anchor="end">x′′′</text>
<text class="diagram-text" fill="var(--fig-green)" x="702" y="160" text-anchor="end">y′′′</text>
<text class="diagram-text" fill="var(--fig-gold)" x="790" y="163" text-anchor="end">z′′′</text>
<text class="diagram-note" x="460" y="304" text-anchor="middle">灰虚 = 上一步旧架；粗线与圆环 = 本次转轴（按当前坐标架选轴）</text>
<text class="diagram-note" x="460" y="326" text-anchor="middle">新因子依次往右追加：R = Rz(φ)·Ry′(ϑ)·Rz″(ψ)；ϑ → 0 时 z 与 z″ 平行，φ 与 ψ 不可分（ZYZ 表示奇点）</text>
</svg>
<figcaption>ZYZ 三步当前轴右乘的坐标架演化（取 $\varphi=40^\circ,\vartheta=55^\circ,\psi=30^\circ$，本教程绘）。</figcaption>
</figure>

**手算示例**：取 $(\varphi,\vartheta,\psi)=(90^\circ,90^\circ,0^\circ)$，得 $R=R_z(90^\circ)R_y(90^\circ)=\begin{bmatrix}0&-1&0\\0&0&1\\-1&0&0\end{bmatrix}$，工具三轴分别指向固定系 $-\boldsymbol z_0,-\boldsymbol x_0,+\boldsymbol y_0$。

<a id="sec-2.4.3"></a>

## 2.4.3 $\operatorname{Atan2}(y,x)$ 的象限判别与敏感度边界

单变量 $\arccos r_{33}$ 仅返回 $[0,\pi]$ 且在 $r_{33}\to\pm 1$ 时导数无界；单变量 $\arctan(y/x)$ 丢失象限且在 $x=0$ 处除零。反解统一采用双变量反正切。

::: thm 定理 2.4.A · $\operatorname{Atan2}(y,x)$ 的定义与输入半径边界 {#thm-2.4.A}
对 $(x,y)\neq(0,0)$，$\alpha=\operatorname{Atan2}(y,x)\in(-\pi,\pi]$ 返回向量 $(x,y)$ 的极角；全书与代码实现统一遵循**先纵坐标 $y$、后横坐标 $x$**（部分课件标题简写 $\operatorname{Atan2}(x,y)$ 属于笔误，见 [勘误 E2.2](errata.md)）。其微分与梯度模长为：
$$\mathrm d\alpha=\frac{x\,\mathrm dy-y\,\mathrm dx}{x^2+y^2},\qquad \|\nabla\alpha\|=\frac{1}{\sqrt{x^2+y^2}}=\frac{1}{\rho}.$$
在原点 $(0,0)$ 处角度无定义（数值软件返回 $0$ 不代表几何角为 $0$）。当输入半径 $\rho=\sqrt{x^2+y^2}$ 很小时（如 ZYZ 首末角 $\rho=|\sin\vartheta|$，RPY 首末角 $\rho=|\cos\vartheta|$），微扰会被放大 $1/\rho$ 倍：例如 ZYZ 在 $\vartheta=0.01^\circ$ 时 $\rho\approx 1.7453\times 10^{-4}$，敏感度高达 $5729.6$（近奇点虽可解但对噪声极敏感）。$\operatorname{Atan2}$ 完整保留象限信息，但无法消除表示本身的奇点。
:::

| 待解角度 | $\operatorname{Atan2}$ 输入向量 $(x,y)$ | 输入半径 $\rho$ |
|:--|:--|:--|
| ZYZ $\vartheta$ 主支 | $(r_{33},\ \sqrt{r_{13}^2+r_{23}^2})$ | $1$ |
| ZYZ $\varphi,\ \psi$ | $(r_{13},r_{23})$ 与 $(-r_{31},r_{32})$ | $\|\sin\vartheta\|$ |
| RPY $\varphi,\ \psi$ | $(r_{11},r_{21})$ 与 $(r_{33},r_{32})$ | $\|\cos\vartheta\|$ |

<a id="sec-2.4.4"></a>

## 2.4.4 ZYZ 逆解两支与万向锁表示奇点

给定 $R=[r_{ij}]\in SO(3)$，设 $r_{13},r_{23}$ **不全为零**（即 $\sin\vartheta\neq 0$；无需两者同时非零）。对比正解第 $3$ 列先定 $\varphi,\vartheta$，再由第 $3$ 行定 $\psi$，得两组等价分支（原书式 2.19–2.20）：

1. **第一支（$\vartheta\in(0,\pi)$，$\sin\vartheta>0$）**：
   $$\varphi=\operatorname{Atan2}(r_{23},r_{13}),\qquad
   \vartheta=\operatorname{Atan2}\!\bigl(\sqrt{r_{13}^2+r_{23}^2},\ r_{33}\bigr),\qquad
   \psi=\operatorname{Atan2}(r_{32},-r_{31}).$$
2. **第二支（$\vartheta\in(-\pi,0)$，$\sin\vartheta<0$）**：
   $$\varphi=\operatorname{Atan2}(-r_{23},-r_{13}),\qquad
   \vartheta=\operatorname{Atan2}\!\bigl(-\sqrt{r_{13}^2+r_{23}^2},\ r_{33}\bigr),\qquad
   \psi=\operatorname{Atan2}(-r_{32},r_{31}).$$

注意第二支中 $\vartheta$ 式的第二个实参 $r_{33}=\cos\vartheta$ **绝不能变号**；两支对应等价三元组 $(\varphi+\pi,-\vartheta,\psi+\pi)$（模 $2\pi$ 归约）。

::: thm 定理 2.4.B · ZYZ 表示奇点（万向锁） {#thm-2.4.B}
当 $\sin\vartheta=0$（即 $r_{13}=r_{23}=0$）时，第一转轴与第三转轴共线，发生局部表示退化（物理刚体自由度并未消失）：
- $\vartheta=0$（$r_{33}=+1$）：$R=R_z(\varphi)R_z(\psi)=R_z(\varphi+\psi)$，仅能唯一确定角之**和** $\varphi+\psi$；
- $\vartheta=\pi$（$r_{33}=-1$）：因 $R_y(\pi)R_z(\psi)=R_z(-\psi)R_y(\pi)$，得 $R=R_z(\varphi-\psi)R_y(\pi)$，仅能唯一确定角之**差** $\varphi-\psi$。

若按工程约定取代表解（例如置 $\psi=0$），则 $\vartheta=0$ 时 $\varphi=\operatorname{Atan2}(r_{21},r_{11})$，$\vartheta=\pi$ 时 $\varphi=\operatorname{Atan2}(-r_{21},-r_{11})$。
:::

<a id="sec-2.4.5"></a>

## 2.4.5 RPY 角：固定轴左乘与四奇点对比总表

按标准航空惯例，$\boldsymbol\phi=[\varphi,\vartheta,\psi]^{\mathrm T}$ 中：$\psi$ 为绕固定 $x$ 轴**滚转角**（roll），$\vartheta$ 为绕固定 $y$ 轴**俯仰角**（pitch），$\varphi$ 为绕固定 $z$ 轴**偏航角**（yaw）（原书英文版及课件角名标签互换，矩阵与轴序无误，详见 [勘误 E2.1](errata.md#errata-2.1)）。从 $I_3$ 出发依次绕固定 $x(\psi)\to y(\vartheta)\to z(\varphi)$ 转动，由 [@thm-2.3.B] 逐次左乘（等价于当前轴 $z(\varphi)\to y'(\vartheta)\to x''(\psi)$ 序列，原书式 2.21）：
$$R_{\rm RPY}(\boldsymbol\phi)=R_z(\varphi)\,R_y(\vartheta)\,R_x(\psi)
=\begin{bmatrix}
c_\varphi c_\vartheta & c_\varphi s_\vartheta s_\psi-s_\varphi c_\psi & c_\varphi s_\vartheta c_\psi+s_\varphi s_\psi\\
s_\varphi c_\vartheta & s_\varphi s_\vartheta s_\psi+c_\varphi c_\psi & s_\varphi s_\vartheta c_\psi-c_\varphi s_\psi\\
-s_\vartheta & c_\vartheta s_\psi & c_\vartheta c_\psi
\end{bmatrix}.$$

当 $\cos\vartheta\neq 0$（即 $r_{11},r_{21}$ 不全为零）时，得两支逆解（原书式 2.22–2.23；第二支中 $-r_{31}=\sin\vartheta$ **不变号**，等价角组为 $(\varphi+\pi,\pi-\vartheta,\psi+\pi)$）：
- **第一支（$\vartheta\in(-\pi/2,\pi/2)$，$\cos\vartheta>0$）**：
  $$\varphi=\operatorname{Atan2}(r_{21},r_{11}),\qquad
  \vartheta=\operatorname{Atan2}\!\bigl(-r_{31},\ \sqrt{r_{11}^2+r_{21}^2}\bigr),\qquad
  \psi=\operatorname{Atan2}(r_{32},r_{33}).$$
- **第二支（$\cos\vartheta<0$）**：
  $$\varphi=\operatorname{Atan2}(-r_{21},-r_{11}),\qquad
  \vartheta=\operatorname{Atan2}\!\bigl(-r_{31},\ -\sqrt{r_{11}^2+r_{21}^2}\bigr),\qquad
  \psi=\operatorname{Atan2}(-r_{32},-r_{33}).$$

| 参数序列 | 乘序与两支不变号项 | 奇点 1（可定角组合） | 奇点 2（可定角组合） | 置 $\psi=0$ 代表解 |
|:--|:--|:--|:--|:--|
| ZYZ | 当前轴右乘 $R_z R_y R_z$；$r_{33}=\cos\vartheta$ **不变号** | $\vartheta=0$（$r_{33}=+1$）：定**和** $\varphi+\psi$ | $\vartheta=\pi$（$r_{33}=-1$）：定**差** $\varphi-\psi$ | $0:\operatorname{Atan2}(r_{21},r_{11})$；$\pi:\operatorname{Atan2}(-r_{21},-r_{11})$ |
| RPY | 固定轴左乘 $R_z R_y R_x$；$-r_{31}=\sin\vartheta$ **不变号** | $\vartheta=+\pi/2$（$r_{31}=-1$）：定**差** $\varphi-\psi$ | $\vartheta=-\pi/2$（$r_{31}=+1$）：定**和** $\varphi+\psi$ | 两端均取 $\varphi=\operatorname{Atan2}(-r_{12},r_{22})$ |

::: ex 例 2.4.C · 同一姿态在 ZYZ 非奇异而在 RPY 奇异 {#ex-2.4.C}
取 $R=\begin{bmatrix}0&-1&0\\0&0&1\\-1&0&0\end{bmatrix}$。按 ZYZ 逆解，该姿态位于正常区，得两支孤立解 $(90^\circ,90^\circ,0^\circ)$ 与 $(-90^\circ,-90^\circ,180^\circ)$，回代均恢复 $R$。改用 RPY 表示时，$r_{31}=-1$（$\vartheta=+90^\circ$）处于万向锁奇点，仅能确定 $\varphi-\psi=90^\circ$，$(90^\circ,90^\circ,0^\circ)$ 与 $(120^\circ,90^\circ,30^\circ)$ 均给出同一矩阵 $R$。可见**表示奇点属于所选参数化序列，并非物理姿态本身的奇异**。
:::

::: preview 后续：单位四元数
欧拉角的表示奇点促使我们寻找全局无奇异的参数化方法；[§2.6](sec2-6.md) 将引入 $4$ 参数带单位约束的单位四元数，彻底消去万向锁奇点（但保留离散的 $Q\sim -Q$ 双重覆盖）。
:::

<a id="lab-2.4"></a>

<div class="lab" data-lab="euler3d" hidden></div>

<noscript><p>无脚本环境下可借助上方 ZYZ/RPY 公式与下方练习独立验算。</p></noscript>

<a id="sec-2.4.6"></a>

## 2.4.6 独立练习与闭卷自检

1. 对 RPY 姿态 $(30^\circ,30^\circ,-30^\circ)$，求矩阵第一列，写出第二支等价角组，并说明求第二支 $\vartheta$ 时为何不可将 $-r_{31}$ 同步变号。
2. 不查表写出 ZYZ 在 $0,\pi$ 与 RPY 在 $+\pi/2,-\pi/2$ 处唯一确定的角组合；计算 $\operatorname{Atan2}(1,-1)$ 并说明 $\operatorname{Atan2}(0,0)$ 的意义。
3. ZYZ 在 $\vartheta=0.01^\circ$ 处，$\varphi$ 反解输入半径与最坏一阶误差放大倍数各为多少？该处是否属于精确奇点？

::: sol 练习核对
1. 第一列为 $(3/4,\sqrt{3}/4,-1/2)^{\mathrm T}$；第二支为 $(-150^\circ,150^\circ,150^\circ)$。因 $-r_{31}=\sin\vartheta=1/2$ 决定俯仰正弦符号，同步变号将得 $\sin\vartheta=-1/2$ 而无法重建原矩阵。
2. 依次为 $\varphi+\psi,\ \varphi-\psi,\ \varphi-\psi,\ \varphi+\psi$。$\operatorname{Atan2}(1,-1)=135^\circ$；$(0,0)$ 处无几何方向定义，软件返回 $0$ 不能当作真实角度解。
3. 输入半径 $\rho=\sin 0.01^\circ\approx 1.7453\times 10^{-4}$，一阶敏感度 $1/\rho\approx 5729.6$；仍是非奇点（输入向量 $10^{-8}$ 扰动致最坏误差约 $5.73\times 10^{-5}\,\mathrm{rad}\approx 0.00328^\circ$），但数值病态显著。
:::

## 2.4 小结与常见错误

**主线**：$12$ 种三轴可行序列均需同时声明轴约定与顺序；ZYZ（当前轴右乘）与 RPY（固定轴左乘）各有两支孤立逆解与两个万向锁奇点；$\operatorname{Atan2}(y,x)$ 保留象限却不能消除局部奇点与近奇点高敏感度。

| 公式 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $R_{\rm ZYZ}=R_z(\varphi)R_y(\vartheta)R_z(\psi)$ | 从 $I_3$ 出发绕当前轴右乘 | 第三列不含 $\psi$；只凭名称不能区分固定/当前轴 |
| $R_{\rm RPY}=R_z(\varphi)R_y(\vartheta)R_x(\psi)$ | 绕固定 $x\to y\to z$ 左乘 | 角名滚转($x$)/偏航($z$) 与部分文献对调（E2.1） |
| $\operatorname{Atan2}(y,x),\ \|\nabla\alpha\|=1/\sqrt{x^2+y^2}$ | $(x,y)\neq(0,0)$，先 $y$ 后 $x$ | 误倒实参；把 $\operatorname{Atan2}(0,0)=0$ 当几何角 |
| 逆解第二支不变号项 | ZYZ 保留 $r_{33}$；RPY 保留 $-r_{31}$ | 第二支错改全部三项符号导致重建失败 |

::: think 本节的课堂幻灯片（源料对照）
| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| — | [euler-motivation.jpg](../assets/ch02/euler-motivation.jpg) | 三参数最小表示动机 | §2.4.1 以自由度与 12 种序列严谨重构 |
| 约 0:10 | [zyz-steps.jpg](../assets/ch02/zyz-steps.jpg) | ZYZ 首步旋转示意 | 由三面板坐标架演化 SVG 完整替换 |
| — | [atan2-def.jpg](../assets/ch02/atan2-def.jpg) | 双变量反正切定义 | 凝练为 [@thm-2.4.A] 并统一 $\operatorname{Atan2}(y,x)$ 顺序 |
| 0:15:55–0:17:44 | [zyz-inv-setup.jpg](../assets/ch02/zyz-inv-setup.jpg) | 第三列入手逆解策略 | §2.4.4 完整推导 |
| 约 0:16 | [zyz-inv-solution.jpg](../assets/ch02/zyz-inv-solution.jpg) | ZYZ 逆解两支 | 订正「不同时为零」宽松条件并补全截断项 |
| — | [rpy-def.jpg](../assets/ch02/rpy-def.jpg) | RPY 定义与标签 | 订正航空角名标签（[勘误 E2.1](errata.md#errata-2.1)） |
| — | [rpy-matrix.jpg](../assets/ch02/rpy-matrix.jpg) | RPY 正解矩阵 | §2.4.5 按原书式 (2.21) 完整给出 |
:::
