# 2.2 旋转矩阵

§2.1 的练习 1 要求工具点 $P$ 在参考系中的坐标。当时从 $O'$ 出发沿 $\boldsymbol x'$ 走了 $0.10\,\mathrm m$，写出 $\boldsymbol p=\boldsymbol o'+0.10\boldsymbol x'$。如果点在固连系中的三个坐标都不为零，就要把三根轴各乘一个系数再相加。把三根轴按列排成矩阵，这件事就变成一次矩阵乘法。本节研究这个矩阵：它必须满足哪些条件，绕坐标轴的三个最简单转动对应什么矩阵，以及它乘到向量上时表示什么。

最后一个问题最容易出错。同一个矩阵既能把同一点的坐标从一个坐标系换到另一个坐标系，也能把一个向量真的转过去。两件事写出来都是 $R$ 乘向量，物理过程却不同，弄混了就会把 $R$ 和 $R^{\mathrm T}$ 用反。§2.2.4 用同一组数把两种情形并排算一遍，通过读数判断该乘哪一个。原书对应 §2.2，印刷页 40–45；本教程分四部分讲：定义与性质、基本旋转、坐标变换、旋转算子。



<a id="sec-2.2.1"></a>

## 2.2.1 定义与两条代数性质

::: def 定义 2.2.1 · 旋转矩阵 {#def-2.2.1}
把式 2.2 的 9 个方向余弦**按列**排成（3×3）矩阵

$$R=\begin{bmatrix}\boldsymbol x'&\boldsymbol y'&\boldsymbol z'\end{bmatrix}
=\begin{bmatrix}x'_x & y'_x & z'_x\\ x'_y & y'_y & z'_y\\ x'_z & y'_z & z'_z\end{bmatrix}\qquad(\text{原书式 }2.3)$$

称为**[旋转矩阵](../recall.md#rotation)**，又称**方向余弦阵**。这里沿用两系均为右手正交系的约定；第 1、2、3 列依次表示本体系 $x'$、$y'$、$z'$ 轴在参考系中的坐标。
:::

定义直接给出两条代数性质（原书式 2.4–2.5），不需要另记。$R^{\mathrm T}$ 的第 $i$ 行就是 $R$ 的第 $i$ 列，所以 $R^{\mathrm T}R$ 的 $(i,j)$ 元是第 $i$ 列与第 $j$ 列的点积。记三列为 $\boldsymbol c_1=\boldsymbol x',\boldsymbol c_2=\boldsymbol y',\boldsymbol c_3=\boldsymbol z'$，则

$$(R^{\mathrm T}R)_{ij}=\boldsymbol c_i^{\mathrm T}\boldsymbol c_j=\boldsymbol c_i\cdot\boldsymbol c_j
=\begin{cases}\|\boldsymbol c_i\|^2=1,& i=j\\[1mm] 0,& i\ne j\end{cases}
\qquad\Longrightarrow\qquad
R^{\mathrm T}R=I_3,\qquad R^{-1}=R^{\mathrm T}.$$

对角线上的 $1$ 来自三根轴都是单位长度，非对角线上的 $0$ 来自三根轴两两垂直。所以“$R$ 是正交矩阵”和“三列构成标准正交组”说的是同一件事。$R^{-1}=R^{\mathrm T}$ 在 §2.2.3 会直接用到：从参考系坐标反求本体系坐标时，只需转置，不必求逆。

对 $R^{\mathrm T}R=I_3$ 两边取行列式，由 $\det R^{\mathrm T}=\det R$ 得 $(\det R)^2=1$，故 $\det R=\pm1$。正交条件本身选不出符号，符号由坐标系的手性决定。$3\times3$ 矩阵的行列式等于三列的混合积：

$$\det R=\boldsymbol x'\cdot(\boldsymbol y'\times\boldsymbol z').$$

右手系满足 $\boldsymbol y'\times\boldsymbol z'=\boldsymbol x'$，于是 $\det R=\boldsymbol x'\cdot\boldsymbol x'=1$。把某一根轴反向，就得到“照镜子”的左手系，混合积变号，$\det R=-1$；§2.1 练习 2 中的 $\operatorname{diag}(1,1,-1)$ 就是这种情形。刚体连续转动时，$\det R$ 是矩阵元素的连续函数，又只能取 $\pm1$，途中不可能从 $+1$ 跳到 $-1$。所以右手固连系怎样转都还是右手系，镜像不能靠转动得到。据此定义：

::: def 定义 2.2.2 · 特殊正交群 SO(3) {#def-2.2.2}
$$SO(3)=\{R\in\mathbb{R}^{3\times3}:\ R^TR=I_3,\ \det(R)=1\}.$$

把维数推广一步：$SO(m)$ 的列是**标准正交**向量（单位长且两两正交），行列式也取 1；空间旋转取 $m=3$，平面旋转取 $m=2$（原书 orthonormal）。
:::

::: note 9 个量、6 个约束、3 个独立参数 {#note-2.2.2}
$R$ 有 9 个元素。按列看，三列单位长度给 3 个约束，两两垂直再给 3 个约束。按矩阵看，$R^{\mathrm T}R$ 总是对称矩阵，所以 $R^{\mathrm T}R=I_3$ 虽有 9 个元素，独立的方程只有对角线 3 个和上三角 3 个，下三角重复上三角。两种看法都留下 **3 个连续独立参数**。$\det R=+1$ 只在 $\pm1$ 中选定右手性，不再扣一个连续自由度。

这是在某个姿态附近的局部计数：它说明姿态需要三个数来描述，没有说该用哪三个数。随手挑三个矩阵元素一般不行，$R_z(30^\circ)$ 与 $R_z(-30^\circ)$ 的三个对角元都是 $(\cos30^\circ,\cos30^\circ,1)$，却是两个不同的姿态。改用三个角也会在某些姿态处失效：[§2.4](sec2-4.md) 的欧拉角有表示奇点，[§2.5](sec2-5.md) 的角和轴在零角与半圈处退化，[§2.10](sec2-10.md) 选择操作空间的姿态参数时也要面对同一问题。
:::

$SO(3)$ 对矩阵乘法还有四条性质，§2.3 合成旋转时都要用到：

1. **封闭**：两个旋转矩阵之积仍是旋转矩阵。因为 $(R_1R_2)^{\mathrm T}(R_1R_2)=R_2^{\mathrm T}(R_1^{\mathrm T}R_1)R_2=R_2^{\mathrm T}R_2=I_3$，且 $\det(R_1R_2)=\det R_1\det R_2=1$。
2. **结合律**：矩阵乘法本来满足 $(R_1R_2)R_3=R_1(R_2R_3)$。
3. **单位元**：$I_3$ 表示不转。
4. **逆元**：$R^{-1}=R^{\mathrm T}$ 同样满足两条判据，表示转回去。

带一种乘法、满足这四条的集合叫**群**（group），$SO(3)$ 名字里的“群”由此而来。封闭性保证连续做几次旋转后，结果仍能用一个旋转矩阵描述。四条里没有交换律：§2.3 会看到，两次旋转换个顺序，结果一般不同。

::: note 选读 · 李群与李代数 {#note-2.2.group}
$SO(3)$ 也构成一个光滑流形（可以局部用连续参数描述的空间），而且矩阵乘法与求逆都是光滑映射，因此它是**李群**（Lie group）。直观上，全体姿态构成嵌在九维矩阵空间中的三维“曲面”，机器人转动时 $R(t)$ 沿着这张“曲面”变化。

这张“曲面”在单位元 $I_3$ 处的**切空间**描述无穷小旋转，记作 $so(3)$（小写）；它由 $3\times3$ 反对称矩阵组成，并带有矩阵交换子运算，称为李代数。[§2.5.3](sec2-5.md#sec-2.5.3) 会说明它怎样连接角和轴、指数映射与角速度。本节后面的计算只用到上面的群性质和旋转矩阵判据。
:::

<a id="sec-2.2.2"></a>

## 2.2.2 基本旋转

一般的 $R$ 有 9 个元素，直接看不出转了什么。先研究最简单的情形：只绕一根坐标轴转一次。按合适的顺序做三次这样的基本旋转，就能表示任意姿态；例如绕当前轴的 $Z\!Y\!Z$ 序列就是 [§2.4](sec2-4.md) 的一套欧拉角约定。任选三次却不一定行，连续三次绕同一轴只能得到绕这根轴的转动。三次旋转怎样相乘，由 [§2.3](sec2-3.md) 解释。

保持参考系不动，让与它最初同向、**共原点**的本体系绕一根参考轴转动，得到三个基本旋转。正方向用**右手定则**确定：右拇指指向转轴正方向，四指弯曲方向为正。等价地，从转轴正端朝原点看，逆时针为正；从另一端看，视觉方向相反。

下文用 $c_\alpha=\cos\alpha$、$s_\alpha=\sin\alpha$ 等缩写。矩阵元素无量纲，角度需采用一致的单位；编程时三角函数通常接收弧度。

先以绕 $z$ 轴转 $\alpha$ 为例（图 2.2），按定义逐列写出新轴在参考系中的投影：

$$\boldsymbol x'=\begin{bmatrix}c_\alpha\\ s_\alpha\\ 0\end{bmatrix},\quad
\boldsymbol y'=\begin{bmatrix}-s_\alpha\\ c_\alpha\\ 0\end{bmatrix},\quad
\boldsymbol z'=\begin{bmatrix}0\\0\\1\end{bmatrix}
\;\Longrightarrow\;
R_z(\alpha)=\begin{bmatrix}c_\alpha & -s_\alpha & 0\\ s_\alpha & c_\alpha & 0\\ 0&0&1\end{bmatrix}\qquad(\text{原书式 }2.6)$$

![课堂幻灯片：绕 z 轴的基本旋转推导，标题为“2.2.1 基本旋转”](../assets/ch02/basic-rotation.jpg)

下面把同一推导画成从 $+z$ 朝原点看的平面图。$\boldsymbol x'$ 在 $x$、$y$ 上的投影分别是 $c_\alpha,s_\alpha$；与它垂直的 $\boldsymbol y'$ 则给出 $-s_\alpha,c_\alpha$。逐列读图，就不必孤立地背负号。

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
<figcaption>绕 z 基本旋转的几何 → 矩阵（本教程绘）：逐列投影给出 $R_z(\alpha)$ 的全部元素；蓝 / 绿 / 金三色把左图的 $c_\alpha,s_\alpha,-s_\alpha$ 与右图矩阵元素对应起来，第三行第三列的「钉住」结构对应「绕谁转谁不动」。</figcaption>
</figure>

绕 $y$ 轴和 $x$ 轴也用同样的逐列方法，但正负号的位置要重新判断。绕 $y$ 轴转 $\beta$ 时，$\boldsymbol y'=\boldsymbol y$ 不动，$\boldsymbol z'$ 和 $\boldsymbol x'$ 在 $zx$ 平面内转动。右拇指沿 $+y$，四指从 $+z$ 弯向 $+x$（与 $\boldsymbol z\times\boldsymbol x=\boldsymbol y$ 一致），所以正转把 $\boldsymbol z$ 带向 $\boldsymbol x$，把 $\boldsymbol x$ 带向 $-\boldsymbol z$：

$$\boldsymbol x'=\begin{bmatrix}c_\beta\\0\\-s_\beta\end{bmatrix},\quad
\boldsymbol y'=\begin{bmatrix}0\\1\\0\end{bmatrix},\quad
\boldsymbol z'=\begin{bmatrix}s_\beta\\0\\c_\beta\end{bmatrix}.$$

绕 $x$ 轴转 $\gamma$ 时，$\boldsymbol x'=\boldsymbol x$ 不动；四指从 $+y$ 弯向 $+z$，正转把 $\boldsymbol y$ 带向 $\boldsymbol z$，把 $\boldsymbol z$ 带向 $-\boldsymbol y$：

$$\boldsymbol x'=\begin{bmatrix}1\\0\\0\end{bmatrix},\quad
\boldsymbol y'=\begin{bmatrix}0\\c_\gamma\\s_\gamma\end{bmatrix},\quad
\boldsymbol z'=\begin{bmatrix}0\\-s_\gamma\\c_\gamma\end{bmatrix}.$$

把三列并排，得到（原书式 2.7–2.8）：

$$R_y(\beta)=\begin{bmatrix}c_\beta & 0 & s_\beta\\ 0&1&0\\ -s_\beta & 0 & c_\beta\end{bmatrix},\qquad
R_x(\gamma)=\begin{bmatrix}1&0&0\\ 0&c_\gamma & -s_\gamma\\ 0&s_\gamma & c_\gamma\end{bmatrix}$$

::: note 逐格读法 · 「钉住」的是哪一行、哪一列 {#note-2.2.Ry}
三个基本旋转矩阵的三列，都是本体系经过一次单轴转动后的三轴朝向。它们的共同结构是：**绕哪个轴转，哪个轴就被「钉住」不动**。绕 $x,y,z$ 时，不动轴对应的列分别为 $(1,0,0)^{\mathrm T}$、$(0,1,0)^{\mathrm T}$、$(0,0,1)^{\mathrm T}$，相应的行是它们的转置。只有绕 $z$ 时，才是第 3 行、第 3 列的 $001$ 结构。

| 矩阵 | 被钉住的部分 | 剩下的是什么 |
|:--|:--|:--|
| $R_z(\alpha)$ | 第 3 列为 $(0,0,1)^{\mathrm T}$，第 3 行为 $(0,0,1)$ | $+90^\circ$ 时，$x\to+y$、$y\to-x$ |
| $R_y(\beta)$ | 第 2 列为 $(0,1,0)^{\mathrm T}$，第 2 行为 $(0,1,0)$ | $+90^\circ$ 时，$x\to-z$、$z\to+x$；因此 $(3,1)$ 元为 $-s_\beta$ |
| $R_x(\gamma)$ | 第 1 列为 $(1,0,0)^{\mathrm T}$，第 1 行为 $(1,0,0)$ | $+90^\circ$ 时，$y\to+z$、$z\to-y$ |

负号的位置有统一规律：正转时若轴 $a$ 转向轴 $b$，新轴 $\boldsymbol b'=c\,\boldsymbol b-s\,\boldsymbol a$，所以 $-s$ 落在第 $a$ 行、第 $b$ 列。绕 $z$ 是 $x\to y$，得 $(1,2)$ 元；绕 $x$ 是 $y\to z$，得 $(2,3)$ 元；绕 $y$ 是 $z\to x$，得 $(3,1)$ 元。前两个在对角线上方，$R_y$ 的落到下方，因为循环次序 $x\to y\to z\to x$ 中只有 $z\to x$ 是从后面的编号回到前面。

所以写这三个矩阵时，先写不动轴对应的列，再按右手定则写另外两列。比如 $R_y(90^\circ)$ 的第一列必须是 $(0,0,-1)^{\mathrm T}$，不能因为熟悉 $R_z$ 就把正弦符号直接照搬。
:::

另有一条常用关系：负角旋转等于转置（原书式 2.9）。

$$R_k(-\vartheta)=R_k^T(\vartheta),\qquad k=x,y,z .$$

从矩阵看，余弦是偶函数、正弦是奇函数，角度变号时只有两个正弦元变号，结果正好是转置。从几何看，绕同一轴转 $-\vartheta$ 恰好抵消转 $\vartheta$，所以 $R_k(-\vartheta)=R_k^{-1}(\vartheta)$，再由正交性得到转置。

<a id="sec-2.2.3"></a>

## 2.2.3 向量的表示：坐标变换

有了三个基本旋转，接着看旋转矩阵怎样作用于向量。先从两系**原点重合**的最简情形说起（图 2.3）：空间中同一点 $P$ 在两个系中的坐标分别为 $\boldsymbol p$ 与 $\boldsymbol p'$。$\boldsymbol p'$ 的三个分量说明从原点出发沿 $\boldsymbol x'$、$\boldsymbol y'$、$\boldsymbol z'$ 各走多远，所以

$$\boldsymbol p=p'_x\boldsymbol x'+p'_y\boldsymbol y'+p'_z\boldsymbol z'=R\,\boldsymbol p' .\qquad(\text{原书式 }2.10)$$

第二个等号是矩阵乘法的列观点：$R\boldsymbol p'$ 就是把 $R$ 的三列分别乘 $p'_x,p'_y,p'_z$ 再相加，而由式 2.3，这三列正是 $\boldsymbol x',\boldsymbol y',\boldsymbol z'$ 在参考系中的坐标。§2.1 练习 1 手算的 $0.10\boldsymbol x'$ 就是 $R(0.10,0,0)^{\mathrm T}$，即 $R$ 的第一列乘 $0.10$；那里两系原点不同，所以还加了 $\boldsymbol o'$。

本节带撇号表示本体系坐标，不表示时间上的“转动之前”。点 $P$ 没有移动，只是两套基底给出不同读数。写成下一节的上下标，就是 $\boldsymbol p^0=R_1^0\boldsymbol p^1$；这里 $R=R_1^0$。

::: thm 原理 2.2.A · 坐标变换与逆变换 {#thm-2.2.A}
$R$ 是把同一点在**动系**中的坐标换算到**参考系**的**变换矩阵**。由正交性，逆变换只需转置（原书式 2.11）：

$$\boldsymbol p'=R^T\boldsymbol p .$$

$R^{\mathrm T}$ 的三行就是 $\boldsymbol x'^{\mathrm T},\boldsymbol y'^{\mathrm T},\boldsymbol z'^{\mathrm T}$，所以 $p'_x=\boldsymbol x'\cdot\boldsymbol p$：本体系坐标就是 $\boldsymbol p$ 在本体系各轴上的投影。若问“已知参考系坐标，求本体系坐标”，就用 $R^{\mathrm T}$。两系原点不重合时，点的位置变换还须加减平移；自由方向的坐标换算则不需要平移。
:::

::: ex 例 2.1（原书）· 绕 z 轴转动后的坐标关系 {#ex-book-2.1}
两系只相差一个绕 $z$ 轴的转角 $\alpha$。令 $\boldsymbol p=(\rho_x,\rho_y,\rho_z)$、$\boldsymbol p'=(\rho'_x,\rho'_y,\rho'_z)$。把 $\boldsymbol p=\rho'_x\boldsymbol x'+\rho'_y\boldsymbol y'+\rho'_z\boldsymbol z'$ 投影到参考轴 $\boldsymbol x$ 上，平面几何给出 $\boldsymbol x'\cdot\boldsymbol x=\cos\alpha$、$\boldsymbol y'\cdot\boldsymbol x=\cos(90^\circ+\alpha)=-\sin\alpha$、$\boldsymbol z'\cdot\boldsymbol x=0$；投影到 $\boldsymbol y$、$\boldsymbol z$ 上同理。于是

$$\rho_x=\rho'_x\cos\alpha-\rho'_y\sin\alpha,\qquad
\rho_y=\rho'_x\sin\alpha+\rho'_y\cos\alpha,\qquad
\rho_z=\rho'_z .$$

即 $\boldsymbol p=R_z(\alpha)\boldsymbol p'$。式 2.6 的同一个矩阵既描述两系的相对指向，又给出原点重合时的坐标换算；原书据此把“姿态描述”与“坐标变换”两种解释统一起来。
:::

<a id="sec-2.2.4"></a>

## 2.2.4 旋转算子与三重几何身份

同一个乘积 $\boldsymbol p=R\boldsymbol p'$ 还有第三种读法：把 $R$ 当**旋转算子**，在同一个固定参考系里把向量转过去。这时两列坐标都写在参考系中，$\boldsymbol p'$ 表示转动前的向量，$\boldsymbol p$ 表示转动后的向量。

换坐标用的矩阵为什么也能转向量？设想把一个向量固连在本体系上。转动之前本体系与参考系重合，向量在两系中的坐标相同，记为 $\boldsymbol v_{\rm before}$。本体系转到姿态 $R$ 后，向量跟着转，它在本体系中的坐标仍是 $\boldsymbol v_{\rm before}$；由 §2.2.3，它在参考系中的坐标就是 $R\boldsymbol v_{\rm before}$。所以“用 $R$ 转一个向量”等于“保留它的本体系坐标，改到参考系里读数”。为避免撇号的双重用途，下方数值对照与演示都用 $\boldsymbol v_{\rm before}$、$\boldsymbol v_{\rm after}$。

因 $R$ 正交，转动保持模长（原书）：

$$\|\boldsymbol p\|^2=\boldsymbol p'^T R^TR\,\boldsymbol p'=\boldsymbol p'^T\boldsymbol p'=\|\boldsymbol p'\|^2 .$$

::: ex 例 2.2（原书）· xy 平面内的向量旋转 {#ex-book-2.2}
$xy$ 平面上的向量 $\boldsymbol p'$ 绕 $z$ 轴转 $\alpha$ 得 $\boldsymbol p$，其分量仍为

$$p_x=p'_x\cos\alpha-p'_y\sin\alpha,\qquad
p_y=p'_x\sin\alpha+p'_y\cos\alpha,\qquad
p_z=p'_z\;\Longrightarrow\;\boldsymbol p=R_z(\alpha)\boldsymbol p' .$$

形式上与例 2.1 完全相同，但语义不同：这里是**同一个系内**把向量旋转，那里是**两个系之间**换算坐标（原书特别区分了这两种用法）。
:::

![课堂幻灯片：归纳中的相对指向与坐标变换两条；旋转算子这一条见原书印刷页 44–45](../assets/ch02/three-meanings.jpg)

::: thm 定理 2.2.B · 旋转矩阵的三重几何身份 {#thm-2.2.B}
同一个 $R$ 有三种等价解读：
1. **姿态描述**：两个坐标系之间的相对指向，列向量为动系轴在参考系中的方向余弦；
2. **坐标变换**：同一点在两系（原点重合）下坐标之间的变换，$\boldsymbol p=R\boldsymbol p'$；
3. **旋转算子**：同一坐标系内把一个向量旋转到新方向的算子。

计算前先写清楚：哪两列在比较、各用哪个坐标系、是否真的发生转动。几何解释相互对应，但求解方向决定使用 $R$ 还是 $R^{\mathrm T}$。
:::

### 同一组数，两种不同的问题

::: ex 数值对照 · 都是 +90°，为什么读数正负不同？ {#ex-2.2.compare}
取 $R=R_z(90^\circ)$，输入列 $\boldsymbol a=(1,0.5,0)^{\mathrm T}$。以下向量坐标为无量纲示例；若它们表示点的位置，则统一乘长度单位，并要求两系共原点。

| 情境 | 保持不变的是什么？ | 计算与结果 |
|---|---|---|
| 转向量 | 参考坐标系不动，向量从 $\boldsymbol a$ 真正正转 $90^\circ$ | $\boldsymbol v_{\rm after}=R\boldsymbol a=(-0.5,1,0)^{\mathrm T}$ |
| 换坐标 | 点 $P$ 不动，它的参考系坐标为 $\boldsymbol p^0=\boldsymbol a$；本体系相对参考系正转 $90^\circ$ | $\boldsymbol p^1=R^{\mathrm T}\boldsymbol p^0=(0.5,-1,0)^{\mathrm T}$ |

第二行得到的不是点向下移动，而是同一个点在旋转后基底中的新读数。两种情境都保持模长 $\sqrt{1.25}\approx1.118$，所以**只查模长不能判断你是否把 $R$ 与 $R^{\mathrm T}$ 用反**。
:::

先在纸上预测 $\alpha=90^\circ$ 时两种情境的输出，再操作下方演示。切换模式时观察：蓝色向量是否改变方向？虚线坐标轴是否转动？读数用的是哪一套坐标？角度控件可用方向键调整，“重置”恢复 $30^\circ$ 与“转向量”。

<div class="lab" data-lab="rotation2d" hidden></div>

<noscript><p>使用上面的数值表和下面的折叠练习，可以完成同样的判断。</p></noscript>

::: think 练习 · 不看演示先判断 {#practice-2.2.rotation}
1. 令 $\alpha=-90^\circ$，仍用 $\boldsymbol a=(1,0.5,0)^{\mathrm T}$：转向量与换坐标分别得到什么？
2. 令 $\alpha=180^\circ$，为什么只做这一角度的测试不容易发现 $R$ 与 $R^{\mathrm T}$ 用反？
3. 对绕 $+y$ 轴正转 $90^\circ$ 的主动旋转，$(1,0,0)^{\mathrm T}$ 变成什么？请用右手定则验证。

::: sol 练习核对
1. 转向量用 $R_z(-90^\circ)$，得到 $(0.5,-1,0)^{\mathrm T}$；换坐标用它的转置，得到 $(-0.5,1,0)^{\mathrm T}$。与上表的两项恰好交换。
2. $R_z(180^\circ)=R_z^{\mathrm T}(180^\circ)=\operatorname{diag}(-1,-1,1)$，两项都得到 $(-1,-0.5,0)^{\mathrm T}$。还应测试 $\pm90^\circ$ 等能区分二者的角度。
3. 得到 $(0,0,-1)^{\mathrm T}$。右拇指沿 $+y$，正转把 $+x$ 带到 $-z$，这也检查了 $R_y$ 第一列正弦项的负号。
:::
:::

<a id="sec-2.2"></a>

::: think 默写点 · 合上书再写（主动回忆）

不看正文与速查卡，先写再展开核对。

1. 默写 $R_x(\vartheta)$、$R_y(\vartheta)$、$R_z(\vartheta)$。
2. 写出旋转矩阵的三条性质（正交性、行列式、独立参数）。
3. 旋转矩阵的三重身份是什么？各举一例。

::: sol 核对

三个矩阵见[公式速查卡 A2](../preface-formulas.md#a2-基本旋转)。先检查不动轴那一列，再检查 $+90^\circ$ 时另外两轴的方向；例如 $R_y$ 必须把 $+x$ 带到 $-z$。

$R^{\mathrm T}R=I$（即 $R^{-1}=R^{\mathrm T}$）、$\det R=+1$、独立参数 3 个。

姿态描述：三列说明工具系相对法兰系的三轴朝向。坐标变换：共原点时，$\boldsymbol p^0=R_1^0\boldsymbol p^1$；若相机与基座原点不同，点坐标还需平移。旋转算子：同一固定系中，$\boldsymbol v_{\rm after}=R\boldsymbol v_{\rm before}$；若转轴不过原点，转动点的位置还需先减去轴上参考点再旋转、最后加回。

:::

:::

## 2.2 小结与常见错误

本节从 9 个方向余弦出发，按列排成 $R$（式 2.3）。正交性给出 $R^{-1}=R^{\mathrm T}$，并只留下 $9-6=3$ 个独立参数（[@note-2.2.2]）；右手系对应 $\det R=+1$。三个基本旋转 $R_x,R_y,R_z$ 是后面合成任意姿态的积木。同一个矩阵有三重身份：姿态描述、坐标变换、旋转算子。例 2.1（[@ex-book-2.1]，坐标变换）与例 2.2（[@ex-book-2.2]，旋转算子）形式相同、语义不同。读公式时先问：比较的是同一点在两个系中的坐标，还是同一个系中转动前后的两个向量。

::: think 常见错误清单 · 自查三条
1. 只靠模长检查乘法方向：$R$ 与 $R^{\mathrm T}$ 都保持模长，仍须说明输入和输出分别在哪个系；
2. 混淆「姿态描述」与「坐标变换」：$R_1^0$ 的**列**是系 1 的轴在系 0 中的像（把系 1 坐标搬到系 0），上下标读反就全错；
3. 认为 $\det R$ 取 $\pm1$ 无所谓：$\det=-1$ 是左手系（含镜像），不属于 $SO(3)$，用它会得到「照镜子」的假姿态。
:::
