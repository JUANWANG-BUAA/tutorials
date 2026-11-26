# 2.6 单位四元数

> **本节定位**：`补充·精简`（原书 §2.6，课外核心补充） ｜ 采用 **Hamilton 约定、标量在前**存储格式，建立角轴半角打包的单位四元数 $Q=\{\eta,\boldsymbol\epsilon\}\in S^3$；证明 $Q$ 消除同步反号但保留 $Q\sim -Q$ 双重覆盖；给出精确半圈失效反例（勘误 E2.7）与 $H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ 最大对角主元全局稳定提取法；推导 Hamilton 乘法与符号对齐后的球面线性插值（SLERP）。

<a id="sec-2.6.1"></a>

## 2.6.1 定义、单位约束与双重覆盖

::: def 定义 2.6.1 · 单位四元数（欧拉参数） {#def-2.6.1}
将角轴参数 $(\vartheta,\boldsymbol r)$ 按半角打包为**单位四元数** $Q=\{\eta,\boldsymbol\epsilon\}$（采用 **Hamilton 乘法、标量在前**列存储 $\boldsymbol q=[\eta,\epsilon_x,\epsilon_y,\epsilon_z]^{\mathrm T}$，并保持主动列向量约定 $\boldsymbol p_{\rm new}=R(\boldsymbol q)\boldsymbol p$；原书式 2.30–2.32）：
$$\eta = \cos\frac{\vartheta}{2},\qquad
\boldsymbol\epsilon = \sin\frac{\vartheta}{2}\,\boldsymbol r = \begin{bmatrix}\epsilon_x\\ \epsilon_y\\ \epsilon_z\end{bmatrix},\qquad
\eta^2 + \epsilon_x^2 + \epsilon_y^2 + \epsilon_z^2 = 1.$$
$4$ 个参数受 $1$ 条单位模长约束落在四维空间的三维单位球面 $S^3\subset\mathbb R^4$ 上，局部独立参数为 $3$。零四元数 $\{0,\boldsymbol 0\}$ 无旋转意义，严禁归一化。与其他程序交互时须先核对标量在前还是在后及乘法约定。
:::

::: thm 定理 2.6.A · 半角打包合并的参数与保留的覆盖 {#thm-2.6.A}
1. **合并同步反号**：将 $(-\vartheta,-\boldsymbol r)$ 代入半角式，$\cos(-\vartheta/2)=\cos(\vartheta/2)$ 且 $\sin(-\vartheta/2)(-\boldsymbol r)=\sin(\vartheta/2)\boldsymbol r$，两组冗余参数映为**同一个**四元数 $Q$；零角时给出唯一单位元 $\{1,\boldsymbol 0\}$，无需指定转轴。
2. **保留 $Q\sim -Q$ 双重覆盖**：转角增加 $2\pi$ 使半角增加 $\pi$，故 $Q$ 与 $-Q$（$S^3$ 上对径点）表示**同一物理旋转**，转角加 $4\pi$ 才回到 $Q$。非半圈处可取 $\eta>0$ 选代表；半圈 $\eta=0$ 时仍需额外规则选路。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-26-title fig-26-desc">
<title id="fig-26-title">角轴参数到四元数，再到旋转矩阵</title>
<desc id="fig-26-desc">第一行与第二行的同步反号角轴参数给出同一个 Q；第三行转角增加整圈得到 −Q。Q 与 −Q 均正向映射到同一旋转矩阵 R。右侧文字说明单位四元数在四维空间的三维单位球面上。</desc>
<defs><marker id="f26-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<text class="diagram-text" x="130" y="38" text-anchor="middle">角轴参数</text>
<text class="diagram-text" x="360" y="38" text-anchor="middle">半角打包</text>
<text class="diagram-text" x="590" y="38" text-anchor="middle">旋转矩阵</text>
<g class="diagram-node">
<rect x="35" y="65" width="190" height="45" rx="8"/>
<rect x="35" y="150" width="190" height="45" rx="8"/>
<rect x="35" y="235" width="190" height="45" rx="8"/>
<rect x="300" y="105" width="120" height="50" rx="8"/>
<rect x="300" y="235" width="120" height="45" rx="8"/>
<rect x="535" y="165" width="110" height="50" rx="8"/>
</g>
<g class="diagram-text" text-anchor="middle">
<text x="130" y="94">(ϑ, r)</text>
<text x="130" y="179">(−ϑ, −r)</text>
<text x="130" y="264">(ϑ + 2π, r)</text>
<text x="360" y="137">Q</text>
<text x="360" y="264">−Q</text>
<text x="590" y="197">同一个 R</text>
</g>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f26-m)">
<path d="M225 87 L298 120"/>
<path d="M225 173 L298 140"/>
<path d="M225 257 H298"/>
<path d="M420 130 L533 180"/>
<path d="M420 257 L533 200"/>
</g>
<g class="diagram-note">
<text x="690" y="105">Q 与 −Q 是 S³ 上的对径点</text>
<text x="690" y="143">S³ 位于四维空间 R⁴ 中</text>
<text x="690" y="181">η² + ‖ε‖² = 1</text>
<text x="690" y="219">它们表示同一物理姿态</text>
<text x="690" y="257">逆向提取需要选代表</text>
</g>
<text class="diagram-note" x="460" y="320" text-anchor="middle">同步反号合并成同一个 Q；增加 2π 得到 −Q；增加 4π 才回到 Q。</text>
</svg>
<figcaption>角轴参数合并与单位四元数 $Q\sim -Q$ 对径点双重覆盖关系（本教程绘）。</figcaption>
</figure>

<a id="sec-2.6.2"></a>

## 2.6.2 正解、全局稳定提取算法与 Hamilton 乘法

### 2.6.2.1 正解矩阵（原书式 2.33）

设 $\eta^2+\|\boldsymbol\epsilon\|^2=1$，单位四元数对应的旋转矩阵为：
$$R(\eta,\boldsymbol\epsilon)=\begin{bmatrix}
2(\eta^2+\epsilon_x^2)-1 & 2(\epsilon_x\epsilon_y-\eta\epsilon_z) & 2(\epsilon_x\epsilon_z+\eta\epsilon_y)\\
2(\epsilon_x\epsilon_y+\eta\epsilon_z) & 2(\eta^2+\epsilon_y^2)-1 & 2(\epsilon_y\epsilon_z-\eta\epsilon_x)\\
2(\epsilon_x\epsilon_z-\eta\epsilon_y) & 2(\epsilon_y\epsilon_z+\eta\epsilon_x) & 2(\eta^2+\epsilon_z^2)-1
\end{bmatrix}.$$

::: proof 证明 · 半角二倍角代换与共轭逆
将 $\eta=\cos\frac{\vartheta}{2}$、$\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\boldsymbol r$ 代入 Rodrigues 紧凑形式 $R=c_\vartheta I_3+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$。利用二倍角公式 $c_\vartheta=2\eta^2-1=1-2\sin^2\frac{\vartheta}{2}$ 与 $s_\vartheta=2\sin\frac{\vartheta}{2}\cos\frac{\vartheta}{2}$，以及 $S(\boldsymbol\epsilon)=\sin\frac{\vartheta}{2}S(\boldsymbol r)$ 的线性性，三项依次化为：
$$c_\vartheta I_3=(2\eta^2-1)I_3,\qquad
(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}=2\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T},\qquad
s_\vartheta S(\boldsymbol r)=2\eta S(\boldsymbol\epsilon).$$
合并得四元数紧凑表达式：
$$R=(2\eta^2-1)I_3 + 2\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T} + 2\eta S(\boldsymbol\epsilon).$$
逐元素展开即得式 (2.33)。将 $\boldsymbol\epsilon$ 替换为 $-\boldsymbol\epsilon$ 使反对称部分反号、对称部分不变，故共轭即逆（原书式 2.36）：$Q^{-1}=\bar Q=\{\eta,-\boldsymbol\epsilon\}\iff R(Q^{-1})=R^{\mathrm T}(Q)$。□
:::

### 2.6.2.2 逆解提取：原书半圈失效反例与 $H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ 稳定算法

由紧凑式可得 $\operatorname{tr}R=4\eta^2-1$、$r_{ii}=2\eta^2-1+2\epsilon_i^2$ 与 $R-R^{\mathrm T}=4\eta S(\boldsymbol\epsilon)$。因此仅在 $\eta>0$ 时，原书式 (2.34)–(2.35) 的反对称差定符号公式有效（原书约定 $\operatorname{sgn}(0)=+1$）：
$$\eta=\frac{1}{2}\sqrt{\operatorname{tr}R+1},\qquad
\boldsymbol\epsilon=\frac{1}{2}\begin{bmatrix}
\operatorname{sgn}(r_{32}-r_{23})\sqrt{1+r_{11}-r_{22}-r_{33}}\\
\operatorname{sgn}(r_{13}-r_{31})\sqrt{1-r_{11}+r_{22}-r_{33}}\\
\operatorname{sgn}(r_{21}-r_{12})\sqrt{1-r_{11}-r_{22}+r_{33}}
\end{bmatrix}.$$

::: ex 例 2.6.B · 原书符号公式在精确半圈的失效反例（勘误 E2.7） {#ex-2.6.B}
取 $R_\pi=\begin{bmatrix}0&-1&0\\-1&0&0\\0&0&-1\end{bmatrix}$（绕轴 $\frac{1}{\sqrt 2}(1,-1,0)^{\mathrm T}$ 旋转 $\pi$）。真解为 $\pm(0,\frac{1}{\sqrt 2},-\frac{1}{\sqrt 2},0)^{\mathrm T}$。但因 $\eta=0\implies R_\pi-R_\pi^{\mathrm T}=O$，原书符号式将三个反对称差均判为 $+1$，给出：
$$\boldsymbol q_{\rm sign}=(0,\tfrac{1}{\sqrt 2},\tfrac{1}{\sqrt 2},0)^{\mathrm T},\qquad
R(\boldsymbol q_{\rm sign})=\begin{bmatrix}0&1&0\\1&0&0\\0&0&-1\end{bmatrix}\neq R_\pi,$$
重建非对角元素误差达 $2$（见 [勘误 E2.7](errata.md#errata-2.7)）。
:::

::: method 稳定提取算法 · $H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ 最大对角主元法 {#method-2.6.extract}
先检验输入矩阵满足 $R^{\mathrm T}R\approx I_3,\ \det R\approx +1$。由正解元素构造 $4\times 4$ 对称矩阵 $H=4\boldsymbol q\boldsymbol q^{\mathrm T}$（下标 $0\text{–}3$ 依次对应 $\eta,\epsilon_x,\epsilon_y,\epsilon_z$）：
$$H=\begin{bmatrix}
1+r_{11}+r_{22}+r_{33}&r_{32}-r_{23}&r_{13}-r_{31}&r_{21}-r_{12}\\
r_{32}-r_{23}&1+r_{11}-r_{22}-r_{33}&r_{12}+r_{21}&r_{13}+r_{31}\\
r_{13}-r_{31}&r_{12}+r_{21}&1-r_{11}+r_{22}-r_{33}&r_{23}+r_{32}\\
r_{21}-r_{12}&r_{13}+r_{31}&r_{23}+r_{32}&1-r_{11}-r_{22}+r_{33}
\end{bmatrix}.$$
1. 因 $\operatorname{tr}H=4$，最大对角元 $H_{kk}\ge 1$，取主元 $q_k=\frac{1}{2}\sqrt{H_{kk}}\ge\frac{1}{2}$（绝对避开小分母）；
2. 由对称非对角交叉项同列恢复其余三分量：$q_i=\frac{H_{ik}}{4q_k}$（$i\neq k$）；
3. 检验 $\|\boldsymbol q\|=1$ 并回代 $R(\boldsymbol q)$ 验证重构残差。

对例 2.6.B，$H$ 对角元为 $(0,2,2,0)$，取 $k=1\implies q_1=1/\sqrt 2$，由 $H_{21}=r_{12}+r_{21}=-2$ 恢复 $q_2=-1/\sqrt 2$，精确还原 $R_\pi$。
:::

<a id="lab-2.6"></a>

<div class="lab" data-lab="quaternion3d" hidden></div>

::: think 练习 1 · 零角提取、半圈符号与存储次序 {#practice-2.6.extract}
对 $R=I_3$，$H$ 最大主元法选中哪个分量？在例 2.6.B 中若只对对角元开正根错在哪里？将正确四元数从「标量在前」改写为「标量在后」。

::: sol 核对
$R=I_3$ 时 $\operatorname{diag}H=(4,0,0,0)$，取 $k=0$ 得 $\boldsymbol q=(1,0,0,0)^{\mathrm T}$。半圈只取对角正根会丢失 $H_{21}=-2$ 携带的负号。标量在前为 $(0,1/\sqrt 2,-1/\sqrt 2,0)$，标量在后为 $(1/\sqrt 2,-1/\sqrt 2,0,0)$（同一物理姿态）。
:::
:::

### 2.6.2.4 Hamilton 乘法：右侧旋转先作用

按 Hamilton 规则（虚单位 $i^2=j^2=k^2=ijk=-1$），两个单位四元数的乘积满足 $R(Q_1\otimes Q_2)=R_1 R_2$（作用到列向量时**右侧 $Q_2$ 先作用**；原书式 2.37）：
$$Q_1\otimes Q_2=\bigl\{\eta_1\eta_2-\boldsymbol\epsilon_1^{\mathrm T}\boldsymbol\epsilon_2,\quad \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\bigr\}.$$
若物理指令按时间先后为「先施加 $R_1$，再绕固定轴施加 $R_2$」，合成四元数为 $Q_2\otimes Q_1$；因叉积 $\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2$ 反对称，四元数乘法一般不可交换。利用纯向量四元数夹乘 $(0,R(Q)\boldsymbol p)=Q\otimes(0,\boldsymbol p)\otimes Q^{-1}$ 与指数关系 $Q=\exp((0,\frac{\vartheta}{2}\boldsymbol r))$（对纯向量四元数 $U=(0,\boldsymbol u)$ 有 $U^2=(-\|\boldsymbol u\|^2,\boldsymbol 0)$，从而 $\exp((0,\boldsymbol u))=(\cos\|\boldsymbol u\|,\ \sin\|\boldsymbol u\|\frac{\boldsymbol u}{\|\boldsymbol u\|})$），也可与 [§2.5.3](sec2-5.md#sec-2.5.3) 的指数表示一一对照。

::: ex 例 2.6.C · 两个 90° 旋转的 Hamilton 乘法顺序 {#ex-2.6.C}
令 $Q_x=(\frac{1}{\sqrt 2},\frac{1}{\sqrt 2},0,0)$、$Q_z=(\frac{1}{\sqrt 2},0,0,\frac{1}{\sqrt 2})$。直接计算得：
$$Q_z\otimes Q_x = \bigl(\tfrac{1}{2},\ \tfrac{1}{2},\ \tfrac{1}{2},\ \tfrac{1}{2}\bigr),\qquad
Q_x\otimes Q_z = \bigl(\tfrac{1}{2},\ \tfrac{1}{2},\ -\tfrac{1}{2},\ \tfrac{1}{2}\bigr).$$
前者对应 $R_z(90^\circ)R_x(90^\circ)$（先绕固定 $x$ 后绕固定 $z$，将 $(0,1,0)^{\mathrm T}$ 映至 $(0,0,1)^{\mathrm T}$）；后者对应 $R_x(90^\circ)R_z(90^\circ)$（将 $(0,1,0)^{\mathrm T}$ 映至 $(-1,0,0)^{\mathrm T}$）。
:::

::: think 练习 2 · 乘法次序与逆检验 {#practice-2.6.product}
先绕固定 $z$ 转 $90^\circ$，再绕固定 $x$ 转 $90^\circ$。写出合成四元数、逆四元数与等效旋转矩阵，并验证点 $(0,1,0)^{\mathrm T}$ 正逆变换闭环。

::: sol 核对
合成四元数为 $Q_x\otimes Q_z=(\frac12,\frac12,-\frac12,\frac12)$，逆为 $(\frac12,-\frac12,\frac12,-\frac12)$。等效矩阵 $R_x(90^\circ)R_z(90^\circ)=\begin{bmatrix}0&-1&0\\0&0&-1\\1&0&0\end{bmatrix}$ 将 $(0,1,0)^{\mathrm T}$ 送至 $(-1,0,0)^{\mathrm T}$，左乘 $R^{\mathrm T}$ 精确返回 $(0,1,0)^{\mathrm T}$。
:::
:::

<a id="sec-2.6.3"></a>

## 2.6.3 连续符号对齐与球面线性插值（SLERP）

从每帧旋转矩阵独立提取四元数时，代表可能因主元切换在 $\boldsymbol q$ 与 $-\boldsymbol q$ 间跳变。插值或连续跟踪前，必须先算四维内积 $d=\boldsymbol q_0^{\mathrm T}\boldsymbol q_1$：若 $d<0$，则令 $\boldsymbol q_1\leftarrow -\boldsymbol q_1,\ d\leftarrow -d$ 以选择同半球较近代表。置 $\Omega=\arccos d\in[0,\pi/2]$（对应物理转角 $2\Omega$）：
- 当 $d=1$（端点相同）时直接返回 $\boldsymbol q_0$（不可除以 $\sin\Omega=0$）；
- 当 $0<\Omega\le\pi/2$ 时，沿大圆弧的**球面线性插值（SLERP）**为：
  $$\boldsymbol q(s) = \frac{\sin\bigl((1-s)\Omega\bigr)}{\sin\Omega}\boldsymbol q_0 + \frac{\sin(s\Omega)}{\sin\Omega}\boldsymbol q_1, \qquad 0\le s\le 1.$$
$s$ 线性变化时，刚体以恒定角速度走两点间的最短姿态弧线，等价于 [§2.5.3](sec2-5.md#sec-2.5.3) 的相对指数插值 $R_0\exp(s\operatorname{Log}(R_0^{\mathrm T}R_1))$。

::: think 练习 3 · 对径点线性插值零四元数陷阱 {#practice-2.6.interpolate}
对 $\boldsymbol q_0=(1,0,0,0)^{\mathrm T}$ 与 $\boldsymbol q_1=(-1,0,0,0)^{\mathrm T}$ 直接作四分量线性插值在 $s=1/2$ 处得到什么？若绕固定 $+z$ 从 $170^\circ$ 转至 $190^\circ$，写出保持连续符号的历史代表及 SLERP 中点。

::: sol 核对
直接线性插值在 $s=1/2$ 得零四元数 $\boldsymbol 0$（无法归一化）；先对齐内积符号将 $\boldsymbol q_1$ 取反后轨迹恒为单位姿态。从 $170^\circ$ 至 $190^\circ$ 应保留 $\boldsymbol q_{170}=(\cos 85^\circ,0,0,\sin 85^\circ)^{\mathrm T}$ 与 $\boldsymbol q_{190}=(\cos 95^\circ,0,0,\sin 95^\circ)^{\mathrm T}$（内积 $\cos 10^\circ>0$），不可机械强制 $\eta\ge 0$；中点为 $(0,0,0,1)^{\mathrm T}$ 即 $R_z(180^\circ)$。
:::
:::

<a id="sec-2.6"></a>

::: think 默写点 · 合上书再写 {#sec-2.6-recall}
1. 写出 $(\vartheta,\boldsymbol r)\to\{\eta,\boldsymbol\epsilon\}$ 转换、单位约束与四元数紧凑正解公式。
2. 说明原书分量符号法在何处失效，以及 $H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ 最大主元法为何全局稳定。
3. 说明 Hamilton 乘法 $Q_1\otimes Q_2$ 的作用次序与 SLERP 前点积符号对齐规则。

::: sol 核对
1. $\eta=\cos(\vartheta/2),\ \boldsymbol\epsilon=\sin(\vartheta/2)\boldsymbol r$，$\eta^2+\|\boldsymbol\epsilon\|^2=1$；$R=(2\eta^2-1)I_3+2\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T}+2\eta S(\boldsymbol\epsilon)$。
2. 精确半圈 $\eta=0$ 时 $R-R^{\mathrm T}=O$，符号法丢失相对负号；$H$ 必有 $H_{kk}\ge 1$，同列交叉项 $q_i=H_{ik}/(4q_k)$ 保留完整符号。
3. $R(Q_1\otimes Q_2)=R_1 R_2$（右侧先作用）；若 $\boldsymbol q_0^{\mathrm T}\boldsymbol q_1<0$ 先取反 $\boldsymbol q_1$ 再插值。
:::
:::

## 2.6 小结与常见错误

**主线**：单位四元数以半角消去角轴的同步反号重复性，但留有 $Q\sim -Q$ 双重覆盖；提取采用 $H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ 最大主元法彻底规避半圈退化，合成遵循 Hamilton 右侧先作用，插值先对齐内积符号。

| 公式 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $Q=\{\cos\frac{\vartheta}{2},\sin\frac{\vartheta}{2}\boldsymbol r\},\ \eta^2+\|\boldsymbol\epsilon\|^2=1$ | Hamilton 约定、标量在前 | 零四元数禁止归一化；不同软件标量顺序可能不同 |
| $R=(2\eta^2-1)I_3+2\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T}+2\eta S(\boldsymbol\epsilon)$ | 单位四元数 | 原书式 (2.34)-(2.35) 在 $\eta=0$ 半圈处失效（E2.7） |
| $q_k=\frac12\sqrt{H_{kk}},\ q_i=H_{ik}/(4q_k)$ | $R\in SO(3)$，$H_{kk}=\max_j H_{jj}\ge 1$ | 提取后发生主元切换时需做连续符号对齐 |
| $Q_1\otimes Q_2=\{\eta_1\eta_2-\boldsymbol\epsilon_1^{\mathrm T}\boldsymbol\epsilon_2,\ \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\}$ | $R(Q_1\otimes Q_2)=R_1 R_2$ | 误按时间从左到右乘；SLERP 未对齐内积致插出零四元数 |
