# 2.2 旋转矩阵与特殊正交群 $SO(3)$

> **本节定位**：`核心必考` ｜ 将 $9$ 个方向余弦组织为列矩阵并证明正交群 $SO(3)$ 的两条代数性质；从右手定则逐列推出三个基本旋转矩阵 $R_z,R_y,R_x$；厘清同一旋转矩阵的**三重几何身份**，辨析主动旋转算子（$R$）与被动坐标变换（$R^{\mathrm T}$）的适用边界。原书对应 §2.2。

<a id="sec-2.2.1"></a>

## 2.2.1 定义、正交性与特殊正交群 $SO(3)$

::: def 定义 2.2.1 · 旋转矩阵（方向余弦阵） {#def-2.2.1}
将固连坐标系 $O'\text{-}x'y'z'$ 的三轴单位向量按列排成 $3\times 3$ 矩阵（原书式 2.3）：
$$R=\begin{bmatrix}\boldsymbol x' & \boldsymbol y' & \boldsymbol z'\end{bmatrix}
=\begin{bmatrix}x'_x & y'_x & z'_x\\ x'_y & y'_y & z'_y\\ x'_z & y'_z & z'_z\end{bmatrix}.$$
矩阵 $R$ 称为**旋转矩阵**（rotation matrix）或**方向余弦阵**（每个元素均为两单位轴的点积余弦，无量纲）。记作 $R_j^i$ 时读作**「右下在右上」**：$R_j^i$ 的三列是系 $j$ 三轴在系 $i$ 中的坐标表达。
:::

由 [§2.1](sec2-1.md) 的 $6$ 条正交归一约束与右手性条件，直接推得两条基本代数性质：

1. **正交性与逆即转置**：记 $R$ 的三列为 $\boldsymbol c_1=\boldsymbol x',\boldsymbol c_2=\boldsymbol y',\boldsymbol c_3=\boldsymbol z'$。$R^{\mathrm T}$ 的第 $i$ 行为 $\boldsymbol c_i^{\mathrm T}$，故乘积元素满足 $(R^{\mathrm T}R)_{ij}=\boldsymbol c_i\cdot\boldsymbol c_j=\delta_{ij}$，即
   $$R^{\mathrm T}R = I_3 \quad\Longrightarrow\quad R^{-1} = R^{\mathrm T}, \qquad R R^{\mathrm T} = I_3.$$
   从行向量视角看，$R$ 的三行依次为参考系 $x,y,z$ 轴在动系中的方向余弦。
2. **行列式恒为 $+1$**：对 $R^{\mathrm T}R=I_3$ 两边取行列式得 $(\det R)^2=1$，即 $\det R=\pm 1$。利用三重积展开 $\det R = \boldsymbol x'\cdot(\boldsymbol y'\times\boldsymbol z')$，由右手系 $\boldsymbol y'\times\boldsymbol z'=\boldsymbol x'$ 必有 $\det R=+1$；从单位阵 $I_3$ 出发做任何连续刚体转动，$\det R$ 连续变化且仅能取离散值 $\pm 1$，故不可能跃迁到 $-1$。正交群 $O(3)$ 包含 $\det=-1$ 的左手镜像分支，仅 $\det=+1$ 的连通分支描述物理刚体转动。

::: def 定义 2.2.2 · 特殊正交群 $SO(3)$ {#def-2.2.2}
$$SO(3)=\bigl\{R\in\mathbb R^{3\times 3} : R^{\mathrm T}R=I_3,\ \det R=1\bigr\}.$$
一般地，$m$ 维**特殊正交群** $SO(m)$ 由全体列标准正交且行列式为 $+1$ 的 $m\times m$ 实矩阵构成（平面旋转取 $m=2$，三维空间旋转取 $m=3$）。
:::

::: note 参数计数：9 个元素、6 条约束、3 个自由度 {#note-2.2.2}
矩阵 $R$ 的 $9$ 个元素受正交条件 $R^{\mathrm T}R=I_3$（对角元 $3$ 个单位长等式 $+$ 对称非对角元 $3$ 个垂直等式，共 $6$ 个独立约束）限制，仅余 $9-6=3$ 个连续独立参数；$\det R=+1$ 选择右手连通分支，不额外扣除连续自由度。该计数是局部流形维数，并不代表任意选 $3$ 个角度参数在全局都能无奇异地唯一覆盖 $SO(3)$。
:::

::: note 选读 · 李群 $SO(3)$ 与李代数 $so(3)$ 切空间 {#note-2.2.group}
$SO(3)$ 在矩阵乘法下满足封闭性、结合律、单位元 $I_3$ 与逆元 $R^{\mathrm T}$，且乘法与求逆均光滑可微，构成一个 $3$ 维光滑流形（**李群**）。其在单位元 $I_3$ 处的切空间描述无穷小旋转，记作李代数 $so(3)$，由全体 $3\times 3$ 实反对称矩阵构成（见 [§2.5.3](sec2-5.md#sec-2.5.3)）。
:::

<a id="sec-2.2.2"></a>

## 2.2.2 基本旋转矩阵

保持参考系固定，使初始与参考系重合、共原点的动系绕某一参考坐标轴按**右手定则**（右拇指指向转轴正向，四指卷曲方向为正；从转轴正端朝原点观察为逆时针）旋转，逐列投影即得三个基本旋转矩阵（简记 $c_\alpha=\cos\alpha,\ s_\alpha=\sin\alpha$，弧度制输入）。

绕参考 $z$ 轴转 $\alpha$（原书式 2.6）：
$$\boldsymbol x'=\begin{bmatrix}c_\alpha\\s_\alpha\\0\end{bmatrix},\quad
\boldsymbol y'=\begin{bmatrix}-s_\alpha\\c_\alpha\\0\end{bmatrix},\quad
\boldsymbol z'=\begin{bmatrix}0\\0\\1\end{bmatrix}
\quad\Longrightarrow\quad
R_z(\alpha)=\begin{bmatrix}c_\alpha & -s_\alpha & 0\\ s_\alpha & c_\alpha & 0\\ 0&0&1\end{bmatrix}.$$

<figure>
<svg class="figure-svg" viewBox="0 0 920 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-22-title fig-22-desc">
<title id="fig-22-title">绕 z 轴基本旋转的几何与矩阵</title>
<desc id="fig-22-desc">左图从 z 轴正端俯视：x′ 转过角 α，其在 x 轴投影为 cosα、在 y 轴投影为 sinα；y′ 的投影给出 −sα 与 cα。右图为 Rz(α) 矩阵，彩色元素与左图彩色标注一一对应，第三行第三列钉住为 0 0 1。</desc>
<defs>
<marker id="f22-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
<marker id="f22-b" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-blue)"/></marker>
<marker id="f22-s" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--sage)"/></marker>
<marker id="f22-g" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--fig-gold)"/></marker>
</defs>
<text class="diagram-text" x="230" y="26" text-anchor="middle">绕 z 转 α：从 +z 端往下看</text>
<text class="diagram-text" x="674" y="26" text-anchor="middle">Rz(α) = 左图几何的矩阵化</text>
<circle cx="230" cy="180" r="95" fill="none" stroke="var(--line)" stroke-dasharray="3 5"/>
<line class="diagram-axis" x1="100" y1="180" x2="375" y2="180" marker-end="url(#f22-m)"/>
<line class="diagram-axis" x1="230" y1="277" x2="230" y2="55" marker-end="url(#f22-m)"/>
<text class="diagram-note" x="384" y="185">x</text>
<text class="diagram-note" x="222" y="50" text-anchor="end">y</text>
<line stroke="var(--fig-blue)" stroke-width="2.6" marker-end="url(#f22-b)" x1="230" y1="180" x2="284" y2="102"/>
<line stroke="var(--sage)" stroke-width="2.2" marker-end="url(#f22-s)" x1="230" y1="180" x2="152" y2="126"/>
<text class="diagram-text" fill="var(--fig-blue)" x="292" y="98">x′</text>
<text class="diagram-text" fill="var(--sage)" x="136" y="120" text-anchor="end">y′</text>
<g stroke="var(--line)" stroke-dasharray="4 4">
<line x1="284" y1="102" x2="284" y2="180"/><line x1="284" y1="102" x2="230" y2="102"/>
<line x1="152" y1="126" x2="152" y2="180"/><line x1="152" y1="126" x2="230" y2="126"/>
</g>
<text class="diagram-text" fill="var(--fig-blue)" x="257" y="197" text-anchor="middle">cα</text>
<text class="diagram-text" fill="var(--fig-green)" x="218" y="141" text-anchor="end">sα</text>
<text class="diagram-text" fill="var(--fig-gold)" x="176" y="197" text-anchor="middle">−sα</text>
<path d="M270 180 A40 40 0 0 0 252.77 147.11" fill="none" stroke="var(--fig-gold)" stroke-width="1.8" marker-end="url(#f22-g)"/>
<text class="diagram-note" x="277" y="157">α</text>
<text class="diagram-note" x="230" y="290" text-anchor="middle">先写 x′ 列，再写 y′ 列；z′ = z</text>
<g fill="none" stroke="var(--line)">
<rect x="590" y="88" width="168" height="120"/><line x1="646" y1="88" x2="646" y2="208"/><line x1="702" y1="88" x2="702" y2="208"/>
<line x1="590" y1="128" x2="758" y2="128"/><line x1="590" y1="168" x2="758" y2="168"/>
</g>
<rect x="586" y="84" width="120" height="88" rx="6" fill="none" stroke="var(--fig-blue)" stroke-width="1.4"/>
<text class="diagram-text" fill="var(--fig-blue)" x="618" y="113" text-anchor="middle">cα</text>
<text class="diagram-text" fill="var(--fig-gold)" x="674" y="113" text-anchor="middle">−sα</text>
<text class="diagram-note" x="730" y="113" text-anchor="middle">0</text>
<text class="diagram-text" fill="var(--fig-green)" x="618" y="153" text-anchor="middle">sα</text>
<text class="diagram-text" fill="var(--fig-blue)" x="674" y="153" text-anchor="middle">cα</text>
<text class="diagram-note" x="730" y="153" text-anchor="middle">0</text>
<text class="diagram-note" x="618" y="193" text-anchor="middle">0</text>
<text class="diagram-note" x="674" y="193" text-anchor="middle">0</text>
<text class="diagram-text" fill="var(--fig-purple)" x="730" y="193" text-anchor="middle">1</text>
<text class="diagram-note" x="674" y="238" text-anchor="middle">第 1、2 列分别对应 x′、y′</text>
<text class="diagram-note" x="674" y="260" text-anchor="middle">第 3 行为 [0 0 1]，第 3 列为其转置</text>
</svg>
<figcaption>绕 $z$ 轴基本旋转的几何投影与矩阵构造对照（本教程绘）。</figcaption>
</figure>

同理按右手定则检查 $+90^\circ$ 轴向变化，得绕 $y$ 轴与绕 $x$ 轴的基本旋转矩阵（原书式 2.7–2.9）：
$$R_y(\beta)=\begin{bmatrix}c_\beta & 0 & s_\beta\\ 0&1&0\\ -s_\beta & 0 & c_\beta\end{bmatrix},\qquad
R_x(\gamma)=\begin{bmatrix}1&0&0\\ 0&c_\gamma & -s_\gamma\\ 0&s_\gamma & c_\gamma\end{bmatrix},\qquad
R_k(-\vartheta)=R_k^{\mathrm T}(\vartheta)\quad (k\in\{x,y,z\}).$$

::: note 三个基本旋转矩阵的结构核对 {#note-2.2.Ry}
**绕哪根坐标轴旋转，该轴对应的行与列即固定为单位基向量：**
- $R_z(\alpha)$ 钉住第 $3$ 行与第 $3$ 列；$+90^\circ$ 时 $+x\to +y$、$+y\to -x$。
- $R_y(\beta)$ 钉住第 $2$ 行与第 $2$ 列；因 $\boldsymbol z\times\boldsymbol x=\boldsymbol y$，绕 $+y$ 转 $+90^\circ$ 把 $+x$ 带至 $-z$、把 $+z$ 带至 $+x$，故 $(3,1)$ 元为 $-s_\beta$ 而 $(1,3)$ 元为 $+s_\beta$，不可机械照搬 $R_z$ 块符号。
- $R_x(\gamma)$ 钉住第 $1$ 行与第 $1$ 列；$+90^\circ$ 时 $+y\to +z$、$+z\to -y$。
:::

<a id="sec-2.2.3"></a>

## 2.2.3 坐标变换与旋转算子

设空间点 $P$（在两系**共原点**前提下）在参考系 $0$ 与固连系 $1$ 下的坐标列分别为 $\boldsymbol p$（即 $\boldsymbol p^0$）与 $\boldsymbol p'$（即 $\boldsymbol p^1$）。将 $\overrightarrow{OP}=p'_x\boldsymbol x'+p'_y\boldsymbol y'+p'_z\boldsymbol z'$ 写成列矩阵乘积（原书式 2.10–2.11）：

::: thm 定理 2.2.A · 共原点坐标变换与逆变换 {#thm-2.2.A}
$$\boldsymbol p = R\,\boldsymbol p', \qquad \boldsymbol p' = R^{\mathrm T}\boldsymbol p.$$
其中 $R=R_1^0$ 将动系坐标换算至参考系，而 $R^{\mathrm T}=(R_1^0)^{\mathrm T}=R_0^1$ 执行反向换算。当两系原点不重合时，点的坐标换算须叠加原点平移，自由方向向量的换算仍仅使用 $R$。
:::

::: ex 例 2.1（原书）· 绕 z 轴转动后的坐标换算 {#ex-book-2.1}
两系共原点且相差绕 $z$ 轴转角 $\alpha$，设 $\boldsymbol p=(\rho_x,\rho_y,\rho_z)^{\mathrm T}$ 与 $\boldsymbol p'=(\rho'_x,\rho'_y,\rho'_z)^{\mathrm T}$，则几何投影直接给出：
$$\rho_x=\rho'_x\cos\alpha-\rho'_y\sin\alpha,\qquad
\rho_y=\rho'_x\sin\alpha+\rho'_y\cos\alpha,\qquad
\rho_z=\rho'_z \quad\Longleftrightarrow\quad \boldsymbol p=R_z(\alpha)\boldsymbol p'.$$
:::

<a id="sec-2.2.4"></a>

## 2.2.4 旋转算子与三重几何身份

同一个乘法表达式也可视为**主动旋转算子**：在同一固定坐标系内把向量 $\boldsymbol p'$ 绕原点主动旋转到新向量 $\boldsymbol p=R\boldsymbol p'$。由 $R^{\mathrm T}R=I_3$ 可知主动旋转保持向量欧氏模长不变：$\|\boldsymbol p\|^2 = \boldsymbol p'^{\mathrm T}R^{\mathrm T}R\boldsymbol p' = \|\boldsymbol p'\|^2$。

::: ex 例 2.2（原书）· 固定系内平面向量的主动旋转 {#ex-book-2.2}
在固定系 $xy$ 平面内将向量 $\boldsymbol p'$ 绕 $+z$ 轴主动转动 $\alpha$ 角得 $\boldsymbol p$，其分量关系仍为：
$$p_x=p'_x\cos\alpha-p'_y\sin\alpha,\qquad
p_y=p'_x\sin\alpha+p'_y\cos\alpha,\qquad
p_z=p'_z \quad\Longleftrightarrow\quad \boldsymbol p=R_z(\alpha)\boldsymbol p'.$$
式形与例 2.1 一致，但几何语义不同：此处是在**同一坐标系内**转动向量，例 2.1 是**两个坐标系间**切换基底。
:::

::: thm 定理 2.2.B · 旋转矩阵的三重几何身份 {#thm-2.2.B}
同一个旋转矩阵 $R=R_1^0\in SO(3)$ 具有三种等价且须严加区分的含义：
1. **姿态描述**：动系 $1$ 的三轴单位向量相对参考系 $0$ 的方向余弦按列排列，$R_1^0=[\boldsymbol x_1^0,\ \boldsymbol y_1^0,\ \boldsymbol z_1^0]$；
2. **被动坐标变换**：两系共原点时，静止点的坐标换算遵循上下标消去律 $\boldsymbol p^0 = R_1^0 \boldsymbol p^1$，逆换算为 $\boldsymbol p^1 = (R_1^0)^{\mathrm T}\boldsymbol p^0 = R_0^1\boldsymbol p^0$；
3. **主动旋转算子**：同一固定参考系内将向量绕原点旋转至新方向，$\boldsymbol v_{\rm after}^0 = R\boldsymbol v_{\rm before}^0$（若转轴不过原点，须先平移至轴上再旋转并加回）。
:::

::: ex 数值对照 · $R$ 与 $R^{\mathrm T}$ 区分（仅核对模长不充分） {#ex-2.2.compare}
取 $R=R_z(90^\circ)$，输入列 $\boldsymbol a=(1,0.5,0)^{\mathrm T}$（共原点前提）。

| 物理情境 | 保持不变的对象 | 表达式与数值结果 |
|:--|:--|:--|
| 主动转向量 | 参考系固定，向量逆时针转动 $90^\circ$ | $\boldsymbol v_{\rm after}=R\boldsymbol a=(-0.5,1,0)^{\mathrm T}$ |
| 被动换坐标 | 空间点静止（$\boldsymbol p^0=\boldsymbol a$），动系正转 $90^\circ$ | $\boldsymbol p^1=R^{\mathrm T}\boldsymbol p^0=(0.5,-1,0)^{\mathrm T}$ |

两结果的欧氏长度均为 $\sqrt{1.25}\approx 1.118$，故**单凭模长守恒无法检验 $R$ 与 $R^{\mathrm T}$ 是否用反**；此外在 $\alpha=180^\circ$ 处 $R_z(180^\circ)=R_z^{\mathrm T}(180^\circ)=\operatorname{diag}(-1,-1,1)$ 亦会掩盖转置错误，测试必须选用 $\pm 90^\circ$ 等非对称角度。
:::

<div class="lab" data-lab="rotation2d" hidden></div>

<noscript><p>无脚本模式下可直接按上表公式与下方练习手算对照。</p></noscript>

::: think 练习 · 反转角、对称角盲区与 $R_y$ 校验 {#practice-2.2.rotation}
1. 令 $\alpha=-90^\circ$、$\boldsymbol a=(1,0.5,0)^{\mathrm T}$，分别求主动转向量与被动换坐标的结果。
2. 说明为何测试程序时不能仅测 $\alpha=180^\circ$。
3. 计算主动旋转算子 $R_y(90^\circ)$ 作用在 $(1,0,0)^{\mathrm T}$ 上的结果，并用右手定则核对符号。

::: sol 练习核对
1. 主动转向量得 $R_z(-90^\circ)\boldsymbol a=(0.5,-1,0)^{\mathrm T}$；被动换坐标得 $R_z^{\mathrm T}(-90^\circ)\boldsymbol a=(-0.5,1,0)^{\mathrm T}$。
2. $R_z(180^\circ)$ 为对称矩阵，转置等于自身，无法暴露 $R$ 与 $R^{\mathrm T}$ 用反的错误。
3. $R_y(90^\circ)(1,0,0)^{\mathrm T}=(0,0,-1)^{\mathrm T}$。右拇指指 $+y$，正转 $90^\circ$ 将 $+x$ 旋至 $-z$，验证 $R_y$ 中 $(3,1)$ 元为 $-\sin\beta$。
:::
:::

<a id="sec-2.2"></a>

::: think 课后默写与核对 {#sec-2.2-recall}
1. 默写基本旋转矩阵 $R_x(\gamma)$、$R_y(\beta)$、$R_z(\alpha)$，并说明 $R_y$ 非对角负号位置。
2. 写出 $SO(3)$ 的两条定义约束，说明为何共有 $3$ 个连续独立参数。
3. 简述 $R_1^0$ 的三重几何身份，并写出各身份的对应公式。

::: sol 课后默写核对
1. 见 [2.2.2](#sec-2.2.2)；$R_y(\beta)$ 第 $(3,1)$ 元为 $-\sin\beta$、$(1,3)$ 元为 $+\sin\beta$。
2. $R^{\mathrm T}R=I_3$（$6$ 个独立正交归一约束留 $9-6=3$ 个连续参数）与 $\det R=+1$（离散排除左手镜像）。
3. 姿态描述 $R_1^0=[\boldsymbol x_1^0,\boldsymbol y_1^0,\boldsymbol z_1^0]$；被动换坐标 $\boldsymbol p^0=R_1^0\boldsymbol p^1$；主动旋转算子 $\boldsymbol v_{\rm after}=R\boldsymbol v_{\rm before}$。
:::
:::

## 2.2 小结与常见错误

**主线**：由固连三轴按列构造旋转矩阵 $R\in SO(3)$（正交且 $\det=+1$，留 $3$ 自由度），以基本旋转 $R_x,R_y,R_z$ 为基本积木，区分同一矩阵在姿态、换坐标与主动算子三种情境中的正逆用法。

| 公式 | 条件与假设 | 易错点 |
|:--|:--|:--|
| $R^{\mathrm T}R=I_3,\ R^{-1}=R^{\mathrm T},\ \det R=+1$ | 右手标准正交基，无量纲 | 遗漏 $\det R=+1$ 条件而把左手镜像归入 $SO(3)$ |
| $R_x(\gamma),\ R_y(\beta),\ R_z(\alpha),\ R_k(-\vartheta)=R_k^{\mathrm T}(\vartheta)$ | 绕固定轴按右手定则取正，弧度制 | 错将 $R_y$ 的 $(3,1)$ 元写作 $+\sin\beta$ |
| $\boldsymbol p^0=R_1^0\boldsymbol p^1,\ \boldsymbol p^1=(R_1^0)^{\mathrm T}\boldsymbol p^0$ | 两系共原点 | 把 $R$ 与 $R^{\mathrm T}$ 用反却只凭模长相等误判正确 |

::: think 本节的课堂幻灯片（源料对照）
| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 约 2:07–2:08 | [basic-rotation.jpg](../assets/ch02/basic-rotation.jpg) | 绕 $z$ 基本旋转的推导页 | 正文逐列投影导出并补齐 $R_y,R_x$ 与结构对照 |
| — | [three-meanings.jpg](../assets/ch02/three-meanings.jpg) | 旋转矩阵三重几何身份归纳 | 凝练为 [@thm-2.2.B] 与数值对照表 |
:::
