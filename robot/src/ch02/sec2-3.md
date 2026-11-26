# 2.3 旋转矩阵的合成

> **本节定位**：`核心必考` ｜ 建立多坐标系级联换算链 $R_n^0=R_1^0 R_2^1\cdots R_n^{n-1}$，严格证明**当前轴右乘**与**固定轴左乘**的更新规则及其相似变换换系关系，界定非单位初始姿态边界与旋转乘法不可交换性。原书对应 §2.3。

<a id="sec-2.3.1"></a>

## 2.3.1 级联换算、当前轴右乘与固定轴左乘

设三个共原点坐标系 $0,1,2$，其中 $R_j^i$ 表示坐标系 $j$ 相对坐标系 $i$ 的姿态矩阵。由 [@thm-2.2.A]，对空间任意点均有 $\boldsymbol p^1=R_2^1\boldsymbol p^2$ 与 $\boldsymbol p^0=R_1^0\boldsymbol p^1$，代入得 $\boldsymbol p^0=R_1^0 R_2^1\boldsymbol p^2$。因该等式对一切 $\boldsymbol p^2\in\mathbb R^3$ 成立，推广至 $n$ 级连杆即得级联公式与逆关系（原书式 2.12–2.16）：

$$R_2^0 = R_1^0 R_2^1, \qquad R_n^0 = R_1^0 R_2^1\cdots R_n^{n-1}, \qquad R_i^j = (R_j^i)^{-1} = (R_j^i)^{\mathrm T}.$$

在连续转动过程中，设刚体当前姿态为 $R$（初始姿态 $R_0$ 未必为 $I_3$）。新增旋转若在**当前工具坐标系**下描述，记为 $B$；若在**固定参考坐标系**下描述，记为 $S$。

::: thm 定理 2.3.A · 相对当前轴右乘 {#thm-2.3.A}
若新增旋转 $B$ 相对当前工具坐标系描述，则新姿态矩阵为**右乘**更新：
$$R_{\rm new} = R\,B.$$
从一般初始姿态 $R_0$ 出发，依次绕当前轴施加 $M_1\to M_2$，终态为 $R_{\rm final}=R_0 M_1 M_2$。
:::

::: thm 定理 2.3.B · 相对固定轴左乘 {#thm-2.3.B}
若新增旋转 $S$ 相对固定参考坐标系描述，则新姿态矩阵为**左乘**更新：
$$R_{\rm new} = S\,R.$$
从一般初始姿态 $R_0$ 出发，依次绕固定轴施加 $M_1\to M_2$，终态为 $R_{\rm final}=M_2 M_1 R_0$（新因子从左侧接入）。
:::

::: proof 证明 · 右乘、左乘规则与相似变换换系关系
设 $\boldsymbol u$ 为固连在刚体上某向量在当前工具系下的坐标，则在固定参考系下的坐标为 $R\boldsymbol u$。
1. 若相对固定参考系施加旋转 $S$，固定系下新坐标变为 $S(R\boldsymbol u)=(SR)\boldsymbol u$，故新姿态矩阵为 $R_{\rm new}=SR$。
2. 若相对当前工具系施加旋转 $B$，旋转后该向量在**原工具系**下坐标变为 $B\boldsymbol u$，再经转动前姿态 $R$ 换算回固定系得 $R(B\boldsymbol u)=(RB)\boldsymbol u$，故新姿态矩阵为 $R_{\rm new}=RB$。

当 $S$ 与 $B$ 描述同一次物理旋转时，两式相等要求 $RB=SR$，从而两者满足相似变换换系公式（其中 $R$ 为转动前的姿态）：
$$B = R^{\mathrm T} S R \quad\Longleftrightarrow\quad S = R B R^{\mathrm T}.$$
原书式 (2.17) 所写的分解 $R(R^{-1}SR)=SR$ 表达的正是该相似变换换系关系，并不表示刚体先退回原位再重新旋转。
:::

| 转轴参考基准 | 单步更新（当前姿态 $R$） | 从 $R_0$ 依次施加 $M_1\to M_2$ | 典型应用 |
|:--|:--|:--|:--|
| 当前运动系（动轴） | **右乘**：$R_{\rm new}=R\,B$ | $R_{\rm final}=R_0 M_1 M_2$ | ZYZ 欧拉角、标准 DH 四步连乘 |
| 固定参考系（定轴） | **左乘**：$R_{\rm new}=S\,R$ | $R_{\rm final}=M_2 M_1 R_0$ | RPY 欧拉角、角轴五步构造 |

**初态境界辨析**：从**单位初始姿态 $R_0=I_3$** 出发，绕固定轴依次施加 $A\to B$ 得 $BA$，绕当前轴依次施加 $B\to A$ 亦得 $BA$，即从 $I_3$ 出发时「固定轴序列」与「轴和角成对倒序的当前轴序列」终态相同；但当初始姿态为一般 $R_0\neq I_3$ 时，固定轴方案给 $BA R_0$、当前轴倒序方案给 $R_0 BA$，二者一般不等。各系原点不重合时，姿态链仍按此相乘，位置平移见 [§2.7 齐次变换](sec2-7.md)。

<a id="sec-2.3.2"></a>

## 2.3.2 旋转的不可交换性

::: ex 例 2.3（原书）· 旋转合成一般不可交换 {#ex-book-2.3}
矩阵乘法一般不满足交换律（$AB\neq BA$），故连续旋转的发生次序通常不可互换。特例例外包括同轴连续旋转 $R_z(\alpha)R_z(\beta)=R_z(\alpha+\beta)$、零角旋转以及特定 $180^\circ$ 对称轴旋转。同时，因向量加法可交换而旋转不可交换，**严禁用角度三元组逐分量相加代替旋转合成**。
:::

::: ex 例 2.3.C · $90^\circ+90^\circ$ 顺序交换数值与三轴校验 {#ex-2.3.C}
从 $R_0=I_3$ 出发，取 $\alpha=90^\circ$（绕 $y$ 轴）、$\beta=90^\circ$（绕 $z$ 轴）。代入基本旋转矩阵得：
$$R_A=R_z(\beta)R_y(\alpha)=\begin{bmatrix}0&-1&0\\0&0&1\\-1&0&0\end{bmatrix},\qquad
R_B=R_y(\alpha)R_z(\beta)=\begin{bmatrix}0&0&1\\1&0&0\\0&1&0\end{bmatrix}.$$

| 旋转指令（按实际发生顺序） | 乘积表达式 | 终态工具三轴在固定系中的方向 |
|:--|:--|:--|
| 固定轴先 $y$ 后 $z$；或当前轴先 $z$ 后 $y'$ | $R_A=R_z(90^\circ)R_y(90^\circ)$ | $\boldsymbol x_2=-\boldsymbol z_0,\ \boldsymbol y_2=-\boldsymbol x_0,\ \boldsymbol z_2=+\boldsymbol y_0$ |
| 固定轴先 $z$ 后 $y$；或当前轴先 $y$ 后 $z'$ | $R_B=R_y(90^\circ)R_z(90^\circ)$ | $\boldsymbol x_2=+\boldsymbol y_0,\ \boldsymbol y_2=+\boldsymbol z_0,\ \boldsymbol z_2=+\boldsymbol x_0$ |

仅查第 $1$ 列即可见差异：$R_A\boldsymbol e_x=(0,0,-1)^{\mathrm T}\neq R_B\boldsymbol e_x=(0,1,0)^{\mathrm T}$。注意：验证两矩阵相等必须核对全部三列；仅凭某一测试向量在两矩阵下像相同（如 $I_3\boldsymbol e_x=R_x(90^\circ)\boldsymbol e_x$）不足以判定姿态一致。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 920 420" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-23-title fig-23-desc">
<title id="fig-23-title">旋转顺序交换，终态姿态不同</title>
<desc id="fig-23-desc">三个立方体：左为初始姿态，体轴与固定系重合；中为先绕固定 y 轴再绕固定 z 轴各转 90 度后的终态；右为先 z 后 y 的终态。两终态的体轴指向不同，说明旋转不可交换。</desc>
<defs>
<marker id="f23-b" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-blue)"/></marker>
<marker id="f23-n" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-green)"/></marker>
<marker id="f23-g" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-gold)"/></marker>
<marker id="f23-m" markerWidth="8" markerHeight="8" refX="6" refY="2.5" orient="auto"><path d="M0,0 L6,2.5 L0,5 Z" fill="var(--muted)"/></marker>
</defs>
<text class="diagram-text" x="150" y="36" text-anchor="middle">初始姿态</text>
<text class="diagram-text" x="470" y="36" text-anchor="middle">先 y 后 z（固定轴）</text>
<text class="diagram-text" x="790" y="36" text-anchor="middle">先 z 后 y（固定轴）</text>
<g fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1" stroke-linejoin="round">
<polygon points="150,215 129.3,203 129.3,157 150,169"/>
<polygon points="150,215 194.2,227 194.2,181 150,169"/>
<polygon points="150,169 194.2,181 173.5,169 129.3,157"/>
</g>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f23-b)" x1="150" y1="215" x2="207" y2="231"/>
<line stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#f23-n)" x1="150" y1="215" x2="123" y2="200"/>
<line stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#f23-g)" x1="150" y1="215" x2="150" y2="155"/>
<text class="diagram-text" fill="var(--fig-blue)" x="214" y="240">x</text>
<text class="diagram-text" fill="var(--fig-green)" x="112" y="202" text-anchor="end">y</text>
<text class="diagram-text" fill="var(--fig-gold)" x="150" y="148" text-anchor="middle">z</text>
<text class="diagram-note" x="150" y="272" text-anchor="middle">体系 x y z 与固定系重合</text>
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#f23-m)">
<line x1="470" y1="215" x2="492" y2="221"/>
<line x1="470" y1="215" x2="460" y2="209"/>
<line x1="470" y1="215" x2="470" y2="193"/>
</g>
<text class="diagram-mono" x="496" y="228">x<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="456" y="206" text-anchor="end">y<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="478" y="196">z<tspan class="sp">0</tspan></text>
<g fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1" stroke-linejoin="round">
<polygon points="470,215 470,261 425.8,249 425.8,203"/>
<polygon points="470,215 425.8,203 405.1,191.1 449.3,203"/>
<polygon points="425.8,203 425.8,249 405.1,237.1 405.1,191.1"/>
</g>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f23-b)" x1="470" y1="215" x2="470" y2="275"/>
<line stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#f23-n)" x1="470" y1="215" x2="413" y2="199"/>
<line stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#f23-g)" x1="470" y1="215" x2="443" y2="199"/>
<text class="diagram-text" fill="var(--fig-blue)" x="470" y="290" text-anchor="middle">x</text>
<text class="diagram-text" fill="var(--fig-green)" x="406" y="196" text-anchor="end">y</text>
<text class="diagram-text" fill="var(--fig-gold)" x="449" y="191" text-anchor="end">z</text>
<g stroke="var(--muted)" stroke-width="1.1" stroke-dasharray="3 4" marker-end="url(#f23-m)">
<line x1="790" y1="215" x2="812" y2="221"/>
<line x1="790" y1="215" x2="780" y2="209"/>
<line x1="790" y1="215" x2="790" y2="193"/>
</g>
<text class="diagram-mono" x="816" y="228">x<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="776" y="206" text-anchor="end">y<tspan class="sp">0</tspan></text>
<text class="diagram-mono" x="798" y="196">z<tspan class="sp">0</tspan></text>
<g fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1" stroke-linejoin="round">
<polygon points="790,215 790,169 834.2,181 834.2,227"/>
<polygon points="790,169 769.3,157 813.5,169 834.2,181"/>
<polygon points="790,215 769.3,203 769.3,157 790,169"/>
</g>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f23-b)" x1="790" y1="215" x2="763" y2="199"/>
<line stroke="var(--fig-green)" stroke-width="2.6" marker-end="url(#f23-n)" x1="790" y1="215" x2="790" y2="155"/>
<line stroke="var(--fig-gold)" stroke-width="2.6" marker-end="url(#f23-g)" x1="790" y1="215" x2="847" y2="231"/>
<text class="diagram-text" fill="var(--fig-blue)" x="756" y="196" text-anchor="end">x</text>
<text class="diagram-text" fill="var(--fig-green)" x="790" y="148" text-anchor="middle">y</text>
<text class="diagram-text" fill="var(--fig-gold)" x="854" y="240">z</text>
<text fill="var(--fig-red)" font-size="26" font-weight="700" x="310" y="222" text-anchor="middle">≠</text>
<text fill="var(--fig-red)" font-size="26" font-weight="700" x="630" y="222" text-anchor="middle">≠</text>
<text class="diagram-mono" x="470" y="312" text-anchor="middle">R = Rz(90°)·Ry(90°)</text>
<text class="diagram-mono" x="790" y="312" text-anchor="middle">R = Ry(90°)·Rz(90°)</text>
<text class="diagram-text" x="460" y="356" text-anchor="middle">同样的两次旋转，交换顺序 → 终态姿态不同：旋转不可交换</text>
<text class="diagram-note" x="460" y="382" text-anchor="middle">灰虚线 = 固定轴；彩色 = 工具轴。两例均从单位姿态出发。</text>
</svg>
<figcaption>例 2.3 几何对照（本教程绘）：彩色轴表示终态工具三轴方向。</figcaption>
</figure>

<a id="practice-2.3.composition"></a>

### 2.3.2.1 交互实验：分步验证当前轴右乘与固定轴左乘

可在下方 3D 实验台依次核对：(1) 初始 $I_3$ 下固定轴「先 $y$ 后 $z$」各步矩阵；(2) 切换为当前轴后观察第二步物理转轴如何随第一步转动而改变；(3) 切换非单位初始姿态 $R_0=R_x(45^\circ)$ 验证 $BA R_0\neq R_0 BA$。

<div class="lab" data-lab="composition3d" hidden></div>

::: ex 练习 · 非单位初始姿态与交换律边界
1. 令 $R_0=R_x(90^\circ)$。方案 A：绕固定 $y$、固定 $z$ 各转 $90^\circ$；方案 B：绕当前 $z$、新的当前 $y$ 各转 $90^\circ$。判断两终态是否相同，并分别求工具 $x$ 轴在固定系中的方向。
2. 判定并说明理由：(a) 同轴连续旋转可交换；(b) 只要两角非零且不同轴就必然不可交换；(c) 若两个旋转矩阵把 $\boldsymbol e_x$ 映至同一向量，则两矩阵相等。

::: sol 核对
1. 记 $M=R_z(90^\circ)R_y(90^\circ)=R_A$。方案 A 得 $MR_0$，工具 $x$ 轴为 $MR_0\boldsymbol e_x=M\boldsymbol e_x=-\boldsymbol e_z$；方案 B 得 $R_0 M$，工具 $x$ 轴为 $R_0(M\boldsymbol e_x)=R_x(90^\circ)(-\boldsymbol e_z)=+\boldsymbol e_y$，二者不同。
2. (a) 对，$R_z(\alpha)R_z(\beta)=R_z(\alpha+\beta)$；(b) 错，例如 $R_y(180^\circ)R_z(180^\circ)=R_z(180^\circ)R_y(180^\circ)=\operatorname{diag}(1,-1,-1)=R_x(180^\circ)$；(c) 错，$I_3$ 与 $R_x(90^\circ)$ 均保持 $\boldsymbol e_x$ 不变但 $\boldsymbol e_y$ 像不同。
:::
:::

<a id="sec-2.3"></a>

::: think 课后默写与核对 {#sec-2.3-recall}
1. 当前姿态为 $R$ 时，相对当前工具系增量 $B$ 与相对固定参考系增量 $S$ 分别怎样左／右乘更新？同一物理转动下 $B$ 与 $S$ 满足什么换算？
2. 为什么从一般初始姿态 $R_0\neq I_3$ 出发时，「固定轴先 $A$ 后 $B$」不等于「当前轴先 $B$ 后 $A$」？

::: sol 课后默写核对
1. $R_{\rm new}=RB$（当前轴右乘）、$R_{\rm new}=SR$（固定轴左乘）；$B=R^{\mathrm T}SR$。
2. 前者给出 $BA R_0$，后者给出 $R_0 BA$，一般 $R_0$ 不与 $BA$ 可交换。
:::
:::

## 2.3 小结与常见错误

**主线**：坐标级联链给出 $R_n^0=R_1^0 R_2^1\cdots R_n^{n-1}$；连续更新遵循当前轴右乘 $RB$、固定轴左乘 $SR$，同一次转动在两系矩阵间由相似变换 $B=R^{\mathrm T}SR$ 联系。

| 公式 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $R_2^0=R_1^0R_2^1,\ R_i^j=(R_j^i)^{\mathrm T}$ | 共原点坐标系链，列向量表达 | 级联乘法顺序写反或上下标未对齐 |
| $R_{\rm new}=RB,\ R_{\rm new}=SR$ | $B$ 相对当前系，$S$ 相对固定系 | 遗漏初始姿态 $R_0$；不经换系将同一矩阵同时作固定/当前指令 |
| $B=R^{\mathrm T}SR$ | $R$ 为施加增量前的当前姿态 | 误将原书虚拟分解 $RR^{-1}SR$ 理解为物体退回原位 |
