# 2.6 奇异值分解与低秩逼近

> **本节属“补充篇 · 数值线性代数工具箱”**：2.x 是补充篇内部编号，不是课堂第 2 章的节号。课堂第 2 章是[线性方程组的解法](../course/ch02/overview.md)。

本节把前面所有工具收拢到一个分解里。**SVD 是现代数值线性代数的中心**：它同时给出四个基本子空间的标准正交基（2.2）、2-范数与条件数（2.4）、对称谱理论向任意矩阵的推广（2.5）、低秩逼近的最优答案（2.6.5）、伪逆与秩亏最小二乘（2.6.4），也是 PCA、推荐系统、图像压缩的方法基础。线索是：SVD 怎样从对称矩阵的谱里长出来 → 两种几何读法 → 四个基本子空间、伪逆与数值秩、最优低秩逼近 → 压缩与 PCA 两个应用。一句话：**如果只能带一件工具走，就带 SVD。**

<a id="sup-2.6.1"></a>


{{#include ../assets/figures/numerical-svd.md}}

## 2.6.1 奇异值的来源：把长方形矩阵「对称化」

::: intuition 直觉 · 从 $A^{\mathrm T}A$ 里「偷」一个答案
对**长方形**矩阵 $A$（$m\neq n$）根本谈不上特征值——$A\boldsymbol{v}=\lambda\boldsymbol{v}$ 这个式子两头维数就对不上。但 $A^{\mathrm T}A\in\mathbb{R}^{n\times n}$ 不一样：它既是**方阵，又对称半正定**，而它的谱理论（[2.5.4](sec25.md#sup-2.5.4)）我们已经完全掌握。于是可以问：

> **$A^{\mathrm T}A$ 的特征值都非负（$\ge0$，所以能开方），它们能告诉我们 $A$ 有多「大」吗？**

能。$\lambda_{\max}(A^{\mathrm T}A)=\lVert A\rVert_2^2$ 这条公式 [1.3.4](../ch01/sec13.md#sec-1.3.4) 已经用过。现在把**全部**特征值都用上，再对 $A^{\mathrm T}$ 做一次同样的分解，就得到 SVD。**奇异值就是「把长方形矩阵变成对称方阵之后，特征值再开方」。**
:::

::: thm 定理 2.6.1（新增） · 奇异值分解的存在性 {#thm-sup-2.6.1}
设 $A\in\mathbb{R}^{m\times n}$（$m,n$ 任意，$m\ge n$ 或 $m\lt n$ 均可），则存在**正交矩阵** $U\in\mathbb{R}^{m\times m}$、$V\in\mathbb{R}^{n\times n}$ 与非负对角阵 $\Sigma\in\mathbb{R}^{m\times n}$，使

$$A=U\Sigma V^{\mathrm T}, \tag{2.29}$$

其中 $\Sigma$ 的对角元 $\sigma_1\ge\sigma_2\ge\cdots\ge\sigma_{\min(m,n)}\ge0$ 称为 $A$ 的**奇异值**（singular values）。

**结构形式（$m\ge n$ 情形）：** 写成列向量形式

$$U=[\underbrace{\boldsymbol{u}_1,\dots,\boldsymbol{u}_n}_{U_1},\ \underbrace{\boldsymbol{u}_{n+1},\dots,\boldsymbol{u}_m}_{U_0}],\qquad
\Sigma=\begin{pmatrix}\Sigma_1\\O\end{pmatrix}\ (\Sigma_1=\operatorname{diag}(\sigma_1,\dots,\sigma_n)\ \text{取前 }n\text{ 个，列满秩时全部非零}),\qquad
V=[\boldsymbol{v}_1,\dots,\boldsymbol{v}_n],$$

则

$$A\,V=U\,\Sigma\quad\Longleftrightarrow\quad A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i\ (i=1,\dots,n),\qquad A^{\mathrm T}\boldsymbol{u}_i=\sigma_i\boldsymbol{v}_i\ (i=1,\dots,n).$$

特别地，**$\{\boldsymbol{v}_i\}$ 是 $A^{\mathrm T}A$ 的标准正交特征向量**（特征值 $\sigma_i^2$），**$\{\boldsymbol{u}_i\}$ 是 $AA^{\mathrm T}$ 的标准正交特征向量**（同样对应 $\sigma_i^2$）。

::: proof 证明
**第一步：对称化。** $A^{\mathrm T}A$ 对称半正定（$\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x}=\lVert A\boldsymbol{x}\rVert_2^2\ge0$）。由谱定理（[@thm-sup-2.5.1] 第 5 条）存在正交矩阵 $V$ 使

$$V^{\mathrm T}(A^{\mathrm T}A)V=\Lambda=\operatorname{diag}(\lambda_1,\dots,\lambda_n),\qquad \lambda_1\ge\cdots\ge\lambda_n\ge0 .$$

记 $\sigma_i=\sqrt{\lambda_i}$。设前 $r$ 个特征值为正，即 $\lambda_1,\dots,\lambda_r\gt0$（$r=\operatorname{rank}A$，因为 $\operatorname{rank}(A^{\mathrm T}A)=\operatorname{rank}A$，见 [@thm-sup-2.2.6] 的证明），$\lambda_{r+1}=\cdots=\lambda_n=0$。

**第二步：构造 $U$ 的前 $r$ 列。** 令 $\boldsymbol{v}_i$ 为 $V$ 的第 $i$ 列。对 $i\le r$，定义

$$\boldsymbol{u}_i=\frac{A\boldsymbol{v}_i}{\sigma_i}\in\mathbb{R}^m .$$

验证 $\{\boldsymbol{u}_1,\dots,\boldsymbol{u}_r\}$ 标准正交：

$$\boldsymbol{u}_i^{\mathrm T}\boldsymbol{u}_j=\frac{\boldsymbol{v}_i^{\mathrm T}A^{\mathrm T}A\boldsymbol{v}_j}{\sigma_i\sigma_j}
=\frac{\lambda_j\boldsymbol{v}_i^{\mathrm T}\boldsymbol{v}_j}{\sigma_i\sigma_j}=\frac{\lambda_j\delta_{ij}}{\sigma_i\sigma_j}=\delta_{ij} .$$

**第三步：补全 $U$。** 先考虑 $m\ge n$。把 $\{\boldsymbol u_1,\dots,\boldsymbol u_r\}$ 扩充为 $\mathbb R^m$ 的标准正交基，得正交矩阵 $U$。对 $i\le r$，$A\boldsymbol v_i=\sigma_i\boldsymbol u_i$；对 $i>r$，$A^{\mathrm T}A\boldsymbol v_i=0$ 给出

$$\lVert A\boldsymbol{v}_i\rVert_2^2=\boldsymbol{v}_i^{\mathrm T}A^{\mathrm T}A\boldsymbol{v}_i=0\ \Longrightarrow\ A\boldsymbol{v}_i=\boldsymbol{0}=\sigma_i\boldsymbol{u}_i .$$

当 $m\ge n$ 时，对 $i=1,\dots,n$ 有 $A\boldsymbol v_i=\sigma_i\boldsymbol u_i$，因此 $AV=U\Sigma$，右乘 $V^{\mathrm T}$ 即得（2.29）。当 $m<n$ 时，对 $A^{\mathrm T}$ 应用同一构造并转置即可；此时不能把不存在的 $\boldsymbol u_i$ 写到 $i=n$。

这是存在性证明，不是推荐的浮点算法。显式形成 $A^{\mathrm T}A$ 可能使小奇异值的信息丢失；实际计算通常直接对 $A$ 作双对角化，再求 SVD。
:::

:::

::: note[skip] 三种情形，一个公式

- **紧致 SVD：** 只保留 $r$ 个非零奇异值，得到 $A=U_r\Sigma_rV_r^{\mathrm T}$，三者尺寸分别为 $m\times r$、$r\times r$、$n\times r$。它不同于库函数的经济型 SVD：`full_matrices=False` 通常保留 $p=\min(m,n)$ 列（或行），即使其中含零奇异值，也不会自动截到秩 $r$。
- **「满」SVD：** 如（2.29），$U,V$ 都是方阵、正交。理论推导用它。
- **秩亏 / 长方形：** 若 $r\lt n$，$\Sigma$ 的对角元从 $\sigma_{r+1}$ 起全为零；若 $m\lt n$，把 $A^{\mathrm T}$ 的 SVD 转置就得到 $A$ 的 SVD（$A=U\Sigma V^{\mathrm T}$ 依然成立，只是 $\Sigma$ 变成「矮」的）。
:::

::: ex 例 2.6.1（新增） · 手算一个 SVD {#ex-sup-2.6.1}
求

$$A=\begin{pmatrix}3&0\\4&5\end{pmatrix}$$

的 SVD（写出 $\sigma_i$、$U$、$V$，并验证）。

::: proof 解
**第 1 步：算 $A^{\mathrm T}A$。**

$$A^{\mathrm T}A=\begin{pmatrix}3&4\\0&5\end{pmatrix}\begin{pmatrix}3&0\\4&5\end{pmatrix}=\begin{pmatrix}25&20\\20&25\end{pmatrix}.$$

**第 2 步：特征值。** $\det(A^{\mathrm T}A-\lambda I)=(25-\lambda)^2-400=0\Rightarrow\lambda=25\pm20$，即 $\lambda_1=45,\ \lambda_2=5$。故

$$\sigma_1=\sqrt{45}=3\sqrt5\approx6.7082,\qquad\sigma_2=\sqrt5\approx2.2361 .$$

**第 3 步：特征向量（$V$）。** 对 $\lambda_1=45$：$(25-45)v_1+20v_2=0\Rightarrow-20v_1+20v_2=0\Rightarrow v_1=v_2$，归一化得 $\boldsymbol{v}_1=\frac{1}{\sqrt2}(1,1)^{\mathrm T}$。对 $\lambda_2=5$：$(25-5)v_1+20v_2=0\Rightarrow20v_1+20v_2=0\Rightarrow v_1=-v_2$，得 $\boldsymbol{v}_2=\frac{1}{\sqrt2}(1,-1)^{\mathrm T}$。

$$V=\frac{1}{\sqrt2}\begin{pmatrix}1&1\\1&-1\end{pmatrix}.$$

**第 4 步：$U$ 由公式 $\boldsymbol{u}_i=A\boldsymbol{v}_i/\sigma_i$ 得到。**

$$\boldsymbol{u}_1=\frac{A\boldsymbol{v}_1}{\sigma_1}=\frac{1}{3\sqrt5}\cdot\frac{1}{\sqrt2}\begin{pmatrix}3\\4+5\end{pmatrix}=\frac{1}{3\sqrt{10}}\begin{pmatrix}3\\9\end{pmatrix}=\frac{1}{\sqrt{10}}\begin{pmatrix}1\\3\end{pmatrix},$$

$$\boldsymbol{u}_2=\frac{A\boldsymbol{v}_2}{\sigma_2}=\frac{1}{\sqrt5}\cdot\frac{1}{\sqrt2}\begin{pmatrix}3\\4-5\end{pmatrix}=\frac{1}{\sqrt{10}}\begin{pmatrix}3\\-1\end{pmatrix}.$$

$$U=\frac{1}{\sqrt{10}}\begin{pmatrix}1&3\\3&-1\end{pmatrix}.$$

**验证：**

$$U\Sigma V^{\mathrm T}=\frac{1}{\sqrt{10}}\begin{pmatrix}1&3\\3&-1\end{pmatrix}\begin{pmatrix}3\sqrt5&0\\0&\sqrt5\end{pmatrix}\frac{1}{\sqrt2}\begin{pmatrix}1&1\\1&-1\end{pmatrix}
=\frac{\sqrt5}{\sqrt{20}}\begin{pmatrix}1&3\\3&-1\end{pmatrix}\begin{pmatrix}3&3\\1&-1\end{pmatrix}
=\frac12\begin{pmatrix}3+3&3-3\\9-1&9+1\end{pmatrix}=\begin{pmatrix}3&0\\4&5\end{pmatrix}\ \checkmark$$

**顺带得到的量：** $\lVert A\rVert_2=\sigma_1=6.7082$；$\lVert A\rVert_F=\sqrt{\sigma_1^2+\sigma_2^2}=\sqrt{45+5}=\sqrt{50}=7.0711$（核对：$\sqrt{9+0+16+25}=\sqrt{50}$ ✓）；$\mathrm{cond}_2(A)=\sigma_1/\sigma_2=3$；$\det A=3\times5-0=15=\sigma_1\sigma_2=6.7082\times2.2361$ ✓（$=15$）。

**外积形式（下面要用）：**

$$A=\sigma_1\boldsymbol{u}_1\boldsymbol{v}_1^{\mathrm T}+\sigma_2\boldsymbol{u}_2\boldsymbol{v}_2^{\mathrm T}=6.7082\,\boldsymbol{u}_1\boldsymbol{v}_1^{\mathrm T}+2.2361\,\boldsymbol{u}_2\boldsymbol{v}_2^{\mathrm T}.$$

截去第二项后，误差 $\lVert A-A_1\rVert_2=\sigma_2=2.2361$ **恰好等于被丢掉的奇异值**——见 [@thm-sup-2.6.4]。
:::

:::

<a id="sup-2.6.2"></a>

<aside class="margin-note"><span class="mn-label">NOTE / SVD</span>奇异值是单位球像的椭圆半轴长度；只保留前 k 个奇异值，就是秩 k 的最优逼近。</aside>

## 2.6.2 SVD 的两种几何读法

::: intuition 直觉 · 读法一：旋转 → 拉伸 → 旋转
$A=U\Sigma V^{\mathrm T}$ 不只是计算公式，还可以按从右到左的顺序「读」出来：

$$\boldsymbol{x}\ \xrightarrow{\ V^{\mathrm T}\ }\ \text{换坐标}\ \xrightarrow{\ \Sigma\ }\ \text{沿坐标轴拉伸}\ \xrightarrow{\ U\ }\ \text{再换坐标}.$$

第一步和第三步都是正交变换，**只旋转或镜像、不改变长度**（[2.1.3](sec21.md#sup-2.1.3)）；只有中间的 $\Sigma$ 在做真正的拉伸，而且只沿坐标轴拉，第 $i$ 根轴的拉伸倍数正是 $\sigma_i$（取零就等于把这根轴压扁）。因此：

> **任何矩阵 = 一次旋转 + 一次沿轴拉伸 + 一次旋转。**

这是矩阵最本质的几何图像，它立刻解释了两件事：① 单位球被 $A$ 映成**椭球**，各个半轴长就是 $\sigma_i$（于是 $\lVert A\rVert_2=\sigma_1$ 就是最大拉伸）；② 只要有某个 $\sigma_i=0$，就有一个方向被压扁到零——这正是 $A$ 奇异、矩阵降秩的几何含义。
:::

::: intuition 直觉 · 读法二：两组「配对」的正交方向
$A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i$ 说明：输入方向 $\boldsymbol{v}_i$（$V$ 的第 $i$ 列）经过 $A$ 之后，**恰好落在输出方向 $\boldsymbol{u}_i$（$U$ 的第 $i$ 列）上**，长度乘上 $\sigma_i$。于是 $A$ 做的事就是「把 $V$ 这组标准正交基映到 $U$ 这组标准正交基，并逐轴缩放」。

**这是 SVD 最有用的一种读法**：它把矩阵拆成「一组输入方向 + 一组输出方向 + 一组缩放倍数」。只改缩放倍数 $\sigma_i$、方向全部保留，就得到**最优低秩逼近**（2.6.5）——这也是 SVD 在数据科学里全部用法（PCA、压缩、去噪、推荐）的共同原理。
:::

<figure>
<svg font-size="12" height="290" viewBox="0 0 700 290" width="700" xmlns="http://www.w3.org/2000/svg">
<defs><marker id="svax" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="2.6"><path d="M0,0 L6.5,2.6 L0,5.2 Z" fill="var(--fig-neutral)"></path></marker></defs>
<!-- 左：单位圆 -->
<g transform="translate(20,20)">
<line marker-end="url(#svax)" stroke="var(--fig-neutral)" stroke-width="1.2" x1="20" x2="200" y1="130" y2="130"></line>
<line marker-end="url(#svax)" stroke="var(--fig-neutral)" stroke-width="1.2" x1="110" x2="110" y1="250" y2="10"></line>
<circle cx="110" cy="130" fill="none" r="70" stroke="var(--fig-blue)" stroke-width="2"></circle>
<line stroke="var(--fig-blue)" stroke-dasharray="4 3" stroke-width="1.2" x1="110" y1="130" x2="159.5" y2="80.5"></line>
<line stroke="var(--fig-blue)" stroke-dasharray="4 3" stroke-width="1.2" x1="110" y1="130" x2="159.5" y2="179.5"></line>
<text fill="var(--fig-blue)" x="163" y="76">v₁</text>
<text fill="var(--fig-blue)" x="163" y="188">v₂</text>
<text fill="var(--muted)" x="60" y="272">单位球（输入）</text>
</g>
<text fill="var(--ink)" x="235" y="136">—A→</text>
<!-- 右：椭球 -->
<g transform="translate(300,20)">
<line marker-end="url(#svax)" stroke="var(--fig-neutral)" stroke-width="1.2" x1="20" x2="200" y1="130" y2="130"></line>
<line marker-end="url(#svax)" stroke="var(--fig-neutral)" stroke-width="1.2" x1="110" x2="110" y1="250" y2="10"></line>
<ellipse cx="110" cy="130" fill="none" rx="88" ry="44" stroke="var(--fig-green)" stroke-width="2"></ellipse>
<line stroke="var(--fig-green)" stroke-width="2" x1="110" y1="130" x2="198" y2="130"></line>
<line stroke="var(--fig-green)" stroke-width="2" x1="110" y1="130" x2="110" y2="86"></line>
<text fill="var(--fig-green)" x="176" y="148">σ₁u₁</text>
<text fill="var(--fig-green)" x="116" y="82">σ₂u₂</text>
<text fill="var(--muted)" x="46" y="272">椭球（输出半轴 σ₁, σ₂）</text>
</g>
<text fill="var(--muted)" x="555" y="120">σ₁ ≥ σ₂ ≥ 0</text>
<text fill="var(--muted)" x="555" y="140">σ₂ = 0 ⟹ 压扁</text>
<text fill="var(--muted)" x="555" y="160">（矩阵降秩）</text>
</svg>
<figcaption>图 2-1 · SVD 的几何：$A$ 把单位球映成椭球，$\boldsymbol{v}_i$ 方向被映射到 $\boldsymbol{u}_i$ 方向并乘以 $\sigma_i$。$\sigma_1$ 是最大拉伸（$\lVert A\rVert_2$），若某轴被压成零则矩阵奇异。</figcaption>
</figure>

::: ex 例 2.6.2（新增） · 用几何读法看一个「压扁」的矩阵 {#ex-sup-2.6.2}
$A=\begin{pmatrix}1&2\\2&4\\3&6\end{pmatrix}$（一眼就能看出第 2 列 $=2\times$第 1 列，秩 1）。求 SVD 并解释几何。

::: proof 解
$A^{\mathrm T}A=\begin{pmatrix}1&2&3\\2&4&6\end{pmatrix}\begin{pmatrix}1&2\\2&4\\3&6\end{pmatrix}=\begin{pmatrix}14&28\\28&56\end{pmatrix}=14\begin{pmatrix}1&2\\2&4\end{pmatrix}$。

特征值：$\operatorname{tr}=70$，$\det=14^2(4-4)=0$，故 $\lambda_1=70,\ \lambda_2=0$。于是

$$\sigma_1=\sqrt{70}\approx8.3666,\qquad\sigma_2=0 .$$

$\lambda_1=70$ 的特征向量满足 $-56v_1+28v_2=0$，即 $v_2=2v_1$。取 $\boldsymbol v_1=(1,2)^{\mathrm T}/\sqrt5$，与之正交的 $\boldsymbol v_2=(2,-1)^{\mathrm T}/\sqrt5$。

$$\boldsymbol{u}_1=\frac{A\boldsymbol{v}_1}{\sigma_1}=\frac{1}{\sqrt{70}}\cdot\frac{1}{\sqrt5}\begin{pmatrix}1+4\\2+8\\3+12\end{pmatrix}=\frac{1}{\sqrt{70}}\cdot\frac{5}{\sqrt5}\begin{pmatrix}1\\2\\3\end{pmatrix}=\frac{1}{\sqrt{14}}\begin{pmatrix}1\\2\\3\end{pmatrix}.$$

**几何解释：** $\sigma_2=0$ 意味着 $\boldsymbol{v}_2$ 这个方向被 $A$ **压扁到零**，于是整个单位圆被映成**一条线段**（退化的一维椭球）。线段的方向是 $\boldsymbol{u}_1=(1,2,3)^{\mathrm T}/\sqrt{14}$，长度 $2\sigma_1=16.7$（直径）。

**验证：** $\operatorname{rank}A=1$（恰有一个非零奇异值）；$\det A$ 无从谈起（$A$ 不是方阵），但 $AA^{\mathrm T}$ 的秩也是 1 ✓。$\lVert A\rVert_2=8.3666$，$\lVert A\rVert_F=\sqrt{70}=8.3666$（**秩 1 时两者相等**，因为 $\lVert A\rVert_F^2=\sum\sigma_i^2=\sigma_1^2$）。

**数据含义：** 这个矩阵的两列完全相关（第 2 列是第 1 列的 2 倍），所以它携带的信息**本质上只有 1 维**——SVD 只用一个非零奇异值就把这件事精确说了出来。**「有效维度 = 非零奇异值的个数」**，这就是 SVD 在数据分析里的核心读法。
:::

:::

<a id="sup-2.6.3"></a>

## 2.6.3 奇异值与四个基本子空间

上一小节的两种读法告诉我们，$\boldsymbol{v}_i$ 和 $\boldsymbol{u}_i$ 是一对一对配好的方向。这些方向还有另一重身份：它们恰好就是四个基本子空间的标准正交基。**SVD 一口气把这四组基全部交出来——这是它的「结构性回报」，其他任何分解都没有这么完整。**

::: thm 定理 2.6.2（新增） · SVD 与四个基本子空间 {#thm-sup-2.6.2}
设 $A\in\mathbb{R}^{m\times n}$，$\operatorname{rank}A=r$，SVD 为 $A=U\Sigma V^{\mathrm T}$，$\sigma_1\ge\cdots\ge\sigma_r\gt0=\sigma_{r+1}=\cdots$。则

| 子空间 | 维数 | 标准正交基 | 出处 |
|:--|:--:|:--|:--|
| $C(A)$（列空间） | $r$ | $\boldsymbol{u}_1,\dots,\boldsymbol{u}_r$ | $U$ 的前 $r$ 列 |
| $N(A^{\mathrm T})$（左零空间） | $m-r$ | $\boldsymbol{u}_{r+1},\dots,\boldsymbol{u}_m$ | $U$ 的后 $m-r$ 列 |
| $C(A^{\mathrm T})$（行空间） | $r$ | $\boldsymbol{v}_1,\dots,\boldsymbol{v}_r$ | $V$ 的前 $r$ 列 |
| $N(A)$（零空间） | $n-r$ | $\boldsymbol{v}_{r+1},\dots,\boldsymbol{v}_n$ | $V$ 的后 $n-r$ 列 |

且

$$\lVert A\rVert_2=\sigma_1,\qquad \lVert A\rVert_F=\sqrt{\sigma_1^2+\cdots+\sigma_r^2},\qquad \mathrm{cond}_2(A)=\frac{\sigma_1}{\sigma_r}\ (\text{可逆时}). \tag{2.30}$$

::: proof 证明
**列空间：** 由 $A=U\Sigma V^{\mathrm T}$ 与 $\Sigma$ 的结构，$A$ 的列是 $U$ 前 $r$ 列的线性组合（系数来自 $\Sigma_rV^{\mathrm T}$ 的行），且 $\operatorname{rank}A=r$，故 $C(A)=\operatorname{span}\{\boldsymbol{u}_1,\dots,\boldsymbol{u}_r\}$；这 $r$ 个向量标准正交，故是标准正交基。

**行空间：** 同法对 $A^{\mathrm T}=V\Sigma^{\mathrm T}U^{\mathrm T}$ 得 $C(A^{\mathrm T})=\operatorname{span}\{\boldsymbol{v}_1,\dots,\boldsymbol{v}_r\}$。

**零空间：** $i=r+1,\dots,n$ 时 $A\boldsymbol v_i=0$；这些向量共有 $n-r$ 个，构成 $N(A)$ 的标准正交基。**左零空间：** 同理，$i=r+1,\dots,m$ 时 $A^{\mathrm T}\boldsymbol u_i=0$，它们构成 $N(A^{\mathrm T})$ 的标准正交基。矩形矩阵两侧的零空间维数可以不同。

**（2.30）：** $\lVert A\rVert_2=\sigma_1$ 由 [@thm-1.3.5] 与 $\lambda_{\max}(A^{\mathrm T}A)=\sigma_1^2$；$\lVert A\rVert_F^2=\operatorname{tr}(A^{\mathrm T}A)=\sum_i\sigma_i^2$；条件数由 [@thm-sup-2.4.1] 第 4 条。[第 3 讲整理稿](../lectures/lec03.md#lec03-S2)记录矩阵 2-范数留作自学，原录音待核；这里的 SVD 推导是正文补充，不是课堂原话。

SVD 给出标准正交基，但不意味着病态问题不会丢数字。若某些奇异值与输入误差同量级，对应的秩和子空间本身就可能不确定；应报告阈值并检查谱间隙。列主元 QR 也可用于较便宜的数值秩估计，但普通列主元策略不对所有矩阵提供同样强的秩揭示保证。
:::

:::

::: ex 例 2.6.3（新增） · 从 SVD 读出四个子空间 {#ex-sup-2.6.3}
对例 2.2.1 的 $A=\begin{pmatrix}1&2&3&1\\2&4&6&3\\1&2&3&2\end{pmatrix}$（$r=2$）用 SVD 求出四个基本子空间的标准正交基，并与例 2.2.1 的手算结果对照。

::: proof 解
```python
import numpy as np
A = np.array([[1.,2,3,1],[2,4,6,3],[1,2,3,2]])
U, s, Vt = np.linalg.svd(A)
print("sigma =", np.round(s, 6))
print("rank =", (s > 1e-12*s[0]).sum())
```

```text
sigma = [9.877729 0.656096 0.      ]
rank = 2
```

完整数值（$\lVert A\rVert_F=\sqrt{98}=9.8995$ 与 $\sqrt{\sigma_1^2+\sigma_2^2}=\sqrt{9.8777^2+0.6561^2}=\sqrt{98}$ ✓，这一条是自检）：

$$U=\begin{pmatrix}-0.3892&-0.7178&\mathbf{0.5774}\\-0.8162&-0.0218&\mathbf{-0.5774}\\-0.4270&0.6959&\mathbf{0.5774}\end{pmatrix},\qquad
V^{\mathrm T}=\begin{pmatrix}-0.2479&-0.4958&-0.7437&-0.3738\\-0.0999&-0.1998&-0.2997&\mathbf{0.9275}\\\hdashline -0.9634&0.1321&0.2331&0\\-0.0187&0.8348&-0.5503&0\end{pmatrix}.$$

（虚线以下为 $V^{\mathrm T}$ 的后 $n-r=2$ 行。）

**四个基本子空间（标准正交基）：**

| 子空间 | 维数 | SVD 给出的标准正交基 | 例 2.2.1 的手算基 |
|:--|:--:|:--|:--|
| $C(A)$ | $2$ | $U$ 的前 2 列 | $(1,2,1)^{\mathrm T},\ (1,3,2)^{\mathrm T}$（**不正交**，需再正交化） |
| $N(A^{\mathrm T})$ | $1$ | $U$ 第 3 列 $=(0.5774,-0.5774,0.5774)^{\mathrm T}$ | $(1,-1,1)^{\mathrm T}$——单位化后**完全相同** ✓ |
| $C(A^{\mathrm T})$ | $2$ | $V$ 的前 2 列 | $(1,2,3,0)^{\mathrm T},\ (0,0,0,1)^{\mathrm T}$ |
| $N(A)$ | $2$ | $V$ 的后 2 列 | $(-2,1,0,0)^{\mathrm T},\ (-3,0,1,0)^{\mathrm T}$ |

**SVD 与手算给出的是同样的子空间**（子空间本身唯一，这是必然的）；差别只在**基的选择**：

- **$N(A^{\mathrm T})$ 那一行完全吻合**：$U$ 的第 3 列恰好就是 $(1,-1,1)^{\mathrm T}/\sqrt3$（一维子空间，两组基只差单位化）。
- **后两行不同**：SVD 给出的基是**标准正交**的，而手算的 $(-2,1,0,0)$ 与 $(-3,0,1,0)$ 内积 $=6\neq0$（**不正交**）；$C(A)$ 那一行的手算基同理。

**这正是 SVD 优于手算的实质：** 它不仅告诉你「哪些向量张成子空间」，还直接把一组**标准正交**的坐标轴送到手上——可以直接拿来做投影（[2.2.3](sec22.md#sup-2.2.3)）、判正交、算距离，不必再补一次 Gram–Schmidt。

**顺带核对几个范数关系：** $\lVert A\rVert_2=\sigma_1=9.8777$（**大于** $\lVert A\rVert_F/\sqrt2=7.0$，因为 $\lVert A\rVert_2$ 量的是最大拉伸、$\lVert A\rVert_F$ 量的是全部奇异值的平方和开方）；$\lVert A\rVert_2\le\lVert A\rVert_F$ ✓（[1.3.4](../ch01/sec13.md#sec-1.3.4) 的结论）。
:::

:::

::: ex 例 2.6.4（新增） · von Neumann 迹不等式 {#ex-sup-2.6.4}
证明：对任意 $A,B\in\mathbb{R}^{m\times n}$（同形），

$$\lvert\operatorname{tr}(A^{\mathrm T}B)\rvert\le\sum_{i=1}^{\min(m,n)}\sigma_i(A)\sigma_i(B) . \tag{2.31}$$

**用途：** 它是许多扰动界证明的起点（信号处理里的匹配滤波、矩阵近似理论都会用到它），而且很容易做数值验证。

::: proof 证明（归约到「对称情形 + 奇异子空间的对齐」；完整推导见附录）
核心是三条工具链，全部细节在[附录 A.2.3–A.2.4](../appendix/derivations.md#app-a-2-3)：

1. **对称迹不等式**（附录引理 A.3.3）：对称阵 $S,T$ 满足 $\operatorname{tr}(ST)\le\sum_i\lambda_i(S)\lambda_i(T)$（特征值降序配对）。它由「特征基展开 ⟹ 系数方阵 $(\boldsymbol{u}_i^{\mathrm T}\boldsymbol{v}_j)^2$ 双随机 ⟹ Birkhoff 定理拆成置换的凸组合 ⟹ 逐个置换用标量重排不等式」四步组成；
2. **对称化膨胀**：把矩形问题化为对称问题——令 $S=\begin{pmatrix}O&A\\A^{\mathrm T}&O\end{pmatrix}$、$T=\begin{pmatrix}O&B\\B^{\mathrm T}&O\end{pmatrix}$，则 $S,T$ 对称，$S$ 的特征值恰为 $\pm\sigma_i(A)$，且 $\operatorname{tr}(ST)=2\operatorname{tr}(A^{\mathrm T}B)$；
3. 对 $S,T$ 套用第 1 步（特征值降序逐项相乘，两块恰好各贡献一个 $\sum\sigma_i(A)\sigma_i(B)$），除以 $2$ 即得（2.31）；对 $-B$ 再用一次得绝对值版本。

**数值验证：**

```python
import numpy as np
rng = np.random.default_rng(3)
for m, n in [(5, 4), (4, 5)]:
    A, B = rng.normal(size=(m, n)), rng.normal(size=(m, n))
    lhs = abs(np.trace(A.T @ B))
    rhs = np.linalg.svd(A, compute_uv=False) @ np.linalg.svd(B, compute_uv=False)
    print(f"|tr(A^T B)| = {lhs:.6f}  ≤  Σσ_i(A)σ_i(B) = {rhs:.6f}")
```

```text
|tr(A^T B)| = 7.009041  ≤  Σσ_i(A)σ_i(B) = 26.317431
|tr(A^T B)| = 0.839841  ≤  Σσ_i(A)σ_i(B) = 19.541253
```

**注意两者的差距很大**（$7.0$ 对 $26.3$）：随机矩阵的左右奇异方向通常并不对齐。特例取 $B=A$，则 $\operatorname{tr}(A^{\mathrm T}A)=\lVert A\rVert_F^2=\sum_i\sigma_i^2$，恰好取等，因此（2.31）是紧界。
:::

:::

<a id="sup-2.6.4"></a>

## 2.6.4 伪逆与秩亏最小二乘

::: intuition 直觉 · 伪逆 = 「能求逆的地方求逆，不能求逆的地方记零」
四个子空间把 $A$ 的「结构」说清楚了；接下来该解方程了——$A$ 不可逆时怎么办？若 $A$ 奇异（或者根本就是长方形），$A^{-1}$ 就不存在。但在 SVD 给出的两组基下，$A$ 做的事很简单：「沿 $\boldsymbol{v}_i$ 方向乘 $\sigma_i$」——那么只要**把非零的 $\sigma_i$ 取倒数、把为零的 $\sigma_i$ 还记为零**，就得到一个「最接近逆」的矩阵：伪逆 $A^{+}$。$A^{+}$ 满足 Penrose 四条件，是唯一的最优「广义逆」。

对秩亏最小二乘，$A^{+}\boldsymbol{b}$ 给出的是**最小范数最小二乘解**——在所有能最小化 $\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert$ 的 $\boldsymbol{x}$ 中，它挑出「$\lVert\boldsymbol{x}\rVert$ 最小」的那一个。这样一来，[2.2.4](sec22.md#sup-2.2.4) 里「列满秩时最小二乘解才唯一」的结论就被补全了。
:::

::: def 定义 2.6.1 · Moore–Penrose 伪逆 {#def-sup-2.6.1}
设 $A=U\Sigma V^{\mathrm T}\in\mathbb{R}^{m\times n}$ 的 SVD，$\Sigma=\operatorname{diag}(\sigma_1,\dots,\sigma_r,0,\dots,0)$。定义

$$\Sigma^{+}=\operatorname{diag}\Bigl(\frac1{\sigma_1},\dots,\frac1{\sigma_r},0,\dots,0\Bigr)\in\mathbb{R}^{n\times m},\qquad
A^{+}=V\Sigma^{+}U^{\mathrm T}\in\mathbb{R}^{n\times m} . \tag{2.32}$$

称 $A^{+}$ 为 $A$ 的 **Moore–Penrose 伪逆**（pseudoinverse）。
:::

::: thm 定理 2.6.3（新增） · 伪逆的性质与秩亏最小二乘 {#thm-sup-2.6.3}
$A^{+}$ 由（2.32）定义，则

1. **Penrose 四条件：** $AA^{+}A=A$；$A^{+}AA^{+}=A^{+}$；$(AA^{+})^{\mathrm T}=AA^{+}$；$(A^{+}A)^{\mathrm T}=A^{+}A$。**满足这四条的唯一矩阵就是 $A^{+}$**；
2. 若 $A$ 可逆，$A^{+}=A^{-1}$；
3. $AA^{+}$ 是到 $C(A)$ 上的正交投影；$A^{+}A$ 是到 $C(A^{\mathrm T})$ 上的正交投影；
4. **秩亏最小二乘：** 对任意 $\boldsymbol{b}\in\mathbb{R}^m$，$\hat{\boldsymbol{x}}=A^{+}\boldsymbol{b}$ 是**唯一**的最小范数最小二乘解

$$\hat{\boldsymbol{x}}=\arg\min\Bigl\{\lVert\boldsymbol{x}\rVert_2:\boldsymbol{x}\ \text{最小化}\ \lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2\Bigr\} ;$$

5. **列满秩时** $A^{+}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$；**行满秩时** $A^{+}=A^{\mathrm T}(AA^{\mathrm T})^{-1}$。

::: proof 证明（3 与 4 的要点）
**（3）：** $AA^{+}=U\Sigma\underbrace{V^{\mathrm T}V}_{I}\Sigma^{+}U^{\mathrm T}=U\Sigma\Sigma^{+}U^{\mathrm T}=U\operatorname{diag}(1,\dots,1,0,\dots,0)U^{\mathrm T}$——这是一个「保留 $U$ 前 $r$ 列、丢掉其余」的对角投影矩阵，对称、幂等，列空间 $=C(U_r)=C(A)$，故由 [@thm-sup-2.2.5]（反之部分）它正是到 $C(A)$ 的正交投影。同法可得 $A^{+}A=V\operatorname{diag}(1,\dots,1,0,\dots,0)V^{\mathrm T}$。

**（4）：** 在 SVD 坐标下令 $\boldsymbol{y}=V^{\mathrm T}\boldsymbol{x}$、$\boldsymbol{c}=U^{\mathrm T}\boldsymbol{b}$，则 $\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2=\lVert\Sigma\boldsymbol{y}-\boldsymbol{c}\rVert_2$、$\lVert\boldsymbol{x}\rVert_2=\lVert\boldsymbol{y}\rVert_2$（这就是正交不变性），问题就此完全解耦成逐个分量：

$$\sum_{i=1}^{\min(m,n)}(\sigma_i y_i-c_i)^2+\sum_{i=n+1}^{m}c_i^2,$$

其中第二项只在 $m>n$ 时出现。对 $i\le r$，取 $y_i=c_i/\sigma_i$；其余与残差无关的 $y_i$ 是自由分量，最小范数要求它们为零。若 $m>n$，多余的输出分量 $c_i$ 无法由 $\Sigma y$ 改变；若 $n>m$，多余的输入分量则同样取零。

故最优解 $\boldsymbol{y}=\Sigma^{+}\boldsymbol{c}$，即 $\boldsymbol{x}=V\Sigma^{+}U^{\mathrm T}\boldsymbol{b}=A^{+}\boldsymbol{b}$，且在每个「自由」分量上都取了零（**这正是最小范数条件**）。

**（1）的唯一性**：满足 Penrose 四条件的矩阵唯一（标准事实，见 [习题 B4](exercises.md)）。
:::

:::

::: ex 例 2.6.5（新增） · 秩亏最小二乘的伪逆解 {#ex-sup-2.6.5}
求

$$A=\begin{pmatrix}1&2\\2&4\\3&6\end{pmatrix},\qquad\boldsymbol{b}=\begin{pmatrix}1\\1\\1\end{pmatrix}$$

的最小范数最小二乘解。

::: proof 解
由例 2.6.2 已得 $A$ 的 SVD：$\sigma_1=\sqrt{70}$、$\sigma_2=0$，$\boldsymbol{v}_1=\frac{1}{\sqrt5}(1,2)^{\mathrm T}$、$\boldsymbol{v}_2=\frac{1}{\sqrt5}(2,-1)^{\mathrm T}$，$\boldsymbol{u}_1=\frac{1}{\sqrt{14}}(1,2,3)^{\mathrm T}$。

**伪逆（只用 $\sigma_1$ 一项）：**

$$A^{+}=\boldsymbol{v}_1\frac{1}{\sigma_1}\boldsymbol{u}_1^{\mathrm T}
=\frac{1}{\sqrt5}\begin{pmatrix}1\\2\end{pmatrix}\cdot\frac{1}{\sqrt{70}}\cdot\frac{1}{\sqrt{14}}\begin{pmatrix}1&2&3\end{pmatrix}
=\frac{1}{\sqrt{4900}}\begin{pmatrix}1&2&3\\2&4&6\end{pmatrix}
=\frac{1}{70}\begin{pmatrix}1&2&3\\2&4&6\end{pmatrix}=\frac{1}{70}A^{\mathrm T}.$$

（秩 1 矩阵的伪逆就是转置除以 $\lVert A\rVert_F^2=70$。）

$$\hat{\boldsymbol{x}}=A^{+}\boldsymbol{b}=\frac{1}{70}\begin{pmatrix}1&2&3\\2&4&6\end{pmatrix}\begin{pmatrix}1\\1\\1\end{pmatrix}=\frac{1}{70}\begin{pmatrix}6\\12\end{pmatrix}=\begin{pmatrix}0.0857\\0.1714\end{pmatrix}.$$

**核对正交条件 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$：** $A\hat{\boldsymbol{x}}=\frac{3}{35}\begin{pmatrix}1+4\\2+8\\3+12\end{pmatrix}=\frac{3}{35}(5,10,15)^{\mathrm T}=\frac37(1,2,3)^{\mathrm T}=(0.4286,0.8571,1.2857)^{\mathrm T}$，故

$$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}=(0.5714,\ 0.1429,\ -0.2857)^{\mathrm T},\qquad
A^{\mathrm T}\boldsymbol{r}=\begin{pmatrix}0.5714+0.2857-0.8571\\1.1429+0.5714-1.7143\end{pmatrix}=\begin{pmatrix}0\\0\end{pmatrix}\ \checkmark$$

残差平方和 $=\lVert\boldsymbol{r}\rVert_2^2=0.4286=3/7$。

**验证「最小范数」：** 正态方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ 是

$$\begin{pmatrix}14&28\\28&56\end{pmatrix}\boldsymbol{x}=\begin{pmatrix}6\\12\end{pmatrix}\ \Longleftrightarrow\ x_1+2x_2=\frac37 ,$$

**一条直线**——最小二乘解不唯一。取此直线上的另一点 $\boldsymbol x'=(3/7,0)^{\mathrm T}$，它有相同的残差，残差平方为 $3/7$；但 $\|\boldsymbol x'\|_2=3/7>\|\hat{\boldsymbol x}\|_2\approx0.1917$。伪逆给出的点沿 $(1,2)$ 方向，与解直线的方向正交，故离原点最近。

**这个例子重要在哪里：** $A$ 的列相关（第 2 列 $=2\times$第 1 列），最小二乘解因此成为**一条直线**。`np.linalg.lstsq` 与 `np.linalg.pinv` 默认返回这条直线上**最小范数**的那一点；而直接消元解正态方程，得到的是直线上**任意**一点（取到哪一点取决于主元选择）——**这就是伪逆与正态方程在秩亏问题上的本质区别**。
:::

:::

::: think 思考 · 伪逆的截断参数：数值秩的判定
真实数据里没有「精确为零的奇异值」，只有「相对很小的奇异值」。`np.linalg.pinv(A, rcond=t)` 会把满足 $\sigma_i\le t\cdot\sigma_1$ 的奇异值直接当作零。**$t$ 该怎么选？** 常用准则有三条：

1. **机器精度准则：** $t=\max(m,n)\cdot u$（LAPACK 默认 $u$ 的若干倍）。适合**矩阵本身精确、只是数值上降秩**的情形。
2. **噪声水平准则：** 若已知矩阵噪声的谱范数界 $\|E\|_2\le\delta$，可用绝对阈值约 $\delta$，即相对阈值 $t\approx\delta/\sigma_1$。低于这一尺度的奇异值难以与矩阵误差区分，但不能断言其方向只有噪声；恢复信号子空间还需要谱间隙等条件。每个元素的噪声标准差不等于整个矩阵的谱范数。
3. **能量准则：** 保留前 $k$ 项使 $\sum_{i\le k}\sigma_i^2/\sum_i\sigma_i^2\ge99\%$，适合控制压缩的相对 F-范数误差，却不能单独决定逆问题的安全截断点。

**为什么小奇异值危险？** 在 $u_i$ 方向上的右端噪声 $\delta c_i$，求逆后变成 $v_i$ 方向的 $\delta c_i/\sigma_i$，绝对放大率为 $1/\sigma_i$，不是条件数本身。相对误差界才会出现 $\sigma_1/\sigma_r$。是否截断应结合噪声与目标精度决定，并非所有小非零奇异值都必须丢弃。
:::

<a id="sup-2.6.5"></a>

## 2.6.5 Eckart–Young：为什么截断 SVD 是最优压缩

::: intuition 直觉 · SVD 按「重要性」排序，砍掉尾巴就是最优删减
读法二已经预告过：保留方向、只改缩放倍数，就能得到最优低秩逼近。这一小节把这句话变成一条定理，先看外积和：

$$A=\sum_{i=1}^{r}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm{T}} .$$

每一项 $\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm{T}}$ 都是一个秩 1 矩阵，**贡献大小由 $\sigma_i$ 度量**。于是要找「秩 $k$ 的最佳逼近」，最自然的做法就是**保留最大的 $k$ 项、砍掉其余的**。Eckart–Young 定理断言：**这个自然做法恰好就是最优的**——不存在别的秩 $k$ 矩阵比它更接近 $A$；而且误差**精确等于**被砍掉的第一个奇异值。

这里的最优性有明确范围：对一个已知完整矩阵，在不加其他约束的秩限制下，按谱范数或 Frobenius 范数衡量误差。带缺失数据的推荐、带权拟合、非负约束或不同噪声模型不自动归结为同一个最优化问题。
:::

::: thm 定理 2.6.4（新增） · Eckart–Young–Mirsky 定理 {#thm-sup-2.6.4}
设 $A\in\mathbb{R}^{m\times n}$ 的 SVD 为 $A=U\Sigma V^{\mathrm T}$，$\operatorname{rank}A=r$。对 $k\lt r$ 记

$$A_k=\sum_{i=1}^{k}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T} \tag{2.33}$$

（$A$ 的**秩 $k$ 截断 SVD**），则

$$\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_2=\lVert A-A_k\rVert_2=\sigma_{k+1}, \tag{2.34}$$

$$\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_F=\lVert A-A_k\rVert_F=\sqrt{\sigma_{k+1}^2+\cdots+\sigma_r^2} . \tag{2.35}$$

即 $A_k$ 是 $A$ 在 $\lVert\cdot\rVert_2$ 与 $\lVert\cdot\rVert_F$ 意义下的**最佳秩 $k$ 逼近**。

::: proof 证明（$\lVert\cdot\rVert_2$ 情形，用 Courant–Fischer）
**先证上界 $\lVert A-A_k\rVert_2=\sigma_{k+1}$。** $A-A_k=\sum_{i\gt k}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$ 是「把后 $r-k$ 项留下来」的形式，它的奇异值就是 $\sigma_{k+1},\dots,\sigma_r$（后面补零），故 $\lVert A-A_k\rVert_2=\sigma_{k+1}$。

**再证下界（任何秩 $\le k$ 的 $B$ 都不可能更好）。** 设 $\operatorname{rank}B\le k$，则 $\dim N(B)\ge n-k$（[@thm-sup-2.2.1]）。考虑

$$\mathcal{S}=\operatorname{span}\{\boldsymbol{v}_1,\dots,\boldsymbol{v}_{k+1}\},\qquad\dim\mathcal{S}=k+1 .$$

由维数公式 $\dim(\mathcal{S}\cap N(B))\ge(k+1)+(n-k)-n=1$，故存在**单位向量** $\boldsymbol{x}\in\mathcal{S}\cap N(B)$。写 $\boldsymbol{x}=\sum_{i\le k+1}c_i\boldsymbol{v}_i$。则 $B\boldsymbol{x}=\boldsymbol{0}$，故

$$\lVert A-B\rVert_2^2\ge\lVert(A-B)\boldsymbol{x}\rVert_2^2=\lVert A\boldsymbol{x}\rVert_2^2
=\Bigl\lVert\sum_{i\le k+1}\sigma_ic_i\boldsymbol{u}_i\Bigr\rVert_2^2=\sum_{i\le k+1}\sigma_i^2c_i^2\ \ge\ \sigma_{k+1}^2\sum_{i\le k+1}c_i^2=\sigma_{k+1}^2 .$$

（最后一步用了 $\sigma_i\ge\sigma_{k+1}$（$i\le k+1$），以及 $\lVert\boldsymbol{x}\rVert_2^2=\sum c_i^2=1$。）故 $\lVert A-B\rVert_2\ge\sigma_{k+1}$。上下界合起来即得（2.34）。

**Frobenius 情形**（（2.35））的证法走另一条路（对称化膨胀 + Hoffman–Wielandt 不等式），见 [习题 B6](exercises.md) 与[附录 A.2.5](../appendix/derivations.md#app-a-2-5)。

也可直接用前面的迹不等式补齐 F-范数证明。记 $p=\min(m,n)$，任意秩不超过 $k$ 的 $B$ 只有前 $k$ 个奇异值可能非零，则

$$\|A-B\|_F^2=\|A\|_F^2+\|B\|_F^2-2\operatorname{tr}(A^{\mathrm T}B)\ge\sum_{i=1}^{p}(\sigma_i(A)-\sigma_i(B))^2\ge\sum_{i>k}\sigma_i(A)^2.$$

截断矩阵达到此下界。对非奇异方阵取 $k=n-1$，就得到 $\min_{\det B=0}\|A-B\|_2=\sigma_n$，除以 $\|A\|_2=\sigma_1$ 后，其相对距离为 $1/\mathrm{cond}_2(A)$；这补齐了 2.4 节“离奇异有多远”的解释。

**这个证明值得记住：** 只用一次「维数计数」，加上一个 Courant–Fischer 型的二次型估计，就把「最优低秩逼近」这件看起来非用优化理论不可的事彻底解决了。**这是线性代数结构力量的又一次展示。**
:::

:::

::: ex 例 2.6.6（新增） · 低秩逼近的误差恰好等于下一个奇异值 {#ex-sup-2.6.6}
构造一个奇异值指数衰减的 $60\times40$ 矩阵，对 $k=1,2,3,5,8,10$ 计算 $\lVert A-A_k\rVert_2$、$\lVert A-A_k\rVert_F$，与理论值对照。

::: proof 解
```python
import numpy as np
rng = np.random.default_rng(0); m, n = 60, 40
# 先随机取正交基，再指定奇异值（指数衰减）——精确控制谱
U_, _, Vt_ = np.linalg.svd(rng.normal(size=(m, n)), full_matrices=False)
dec = np.exp(-np.arange(n) / 2.5)
A = (U_ * dec) @ Vt_                      # 奇异值 = dec
U, S, Vt = np.linalg.svd(A)

for k in [1, 2, 3, 5, 8, 10]:
    Ak = (U[:, :k] * S[:k]) @ Vt[:k]
    e2 = np.linalg.norm(A - Ak, 2); eF = np.linalg.norm(A - Ak, 'fro')
    print(f"k={k:2d}  ||A-Ak||_2={e2:.6e} (=σ{k+1}={S[k]:.6e})  "
          f"||A-Ak||_F={eF:.6e} (=√Σσ²={np.sqrt((S[k:]**2).sum()):.6e})  "
          f"能量={((S[:k]**2).sum()/(S**2).sum()):.4%}")
```

```text
k= 1  ||A-Ak||_2=6.703200e-01 (=σ2=6.703200e-01)  ||A-Ak||_F=9.033085e-01 (=√Σσ²=9.033085e-01)  能量=55.07%
k= 2  ||A-Ak||_2=4.493290e-01 (=σ3=4.493290e-01)  ||A-Ak||_F=6.055058e-01 (=√Σσ²=6.055058e-01)  能量=79.81%
k= 3  ||A-Ak||_2=3.011942e-01 (=σ4=3.011942e-01)  ||A-Ak||_F=4.058827e-01 (=√Σσ²=4.058827e-01)  能量=90.93%
k= 5  ||A-Ak||_2=1.353353e-01 (=σ6=1.353353e-01)  ||A-Ak||_F=1.823748e-01 (=√Σσ²=1.823748e-01)  能量=98.17%
k= 8  ||A-Ak||_2=4.076220e-02 (=σ9=4.076220e-02)  ||A-Ak||_F=5.493025e-02 (=√Σσ²=5.493025e-02)  能量=99.83%
k=10  ||A-Ak||_2=1.831564e-02 (=σ11=1.831564e-02)  ||A-Ak||_F=2.468175e-02 (=√Σσ²=2.468175e-02)  能量=99.97%
```

**每行的两个等号都精确成立到机器精度**——这是 [@thm-sup-2.6.4] 最直接的验证。**再看能量列：** 只用 $k=3$ 个奇异值就抓住了 $90.9\%$ 的能量，$k=8$ 就有 $99.8\%$——**这正是「低秩结构」的定量含义：少数几个奇异值就主导了整个矩阵。**

```python
# 用随机秩 k 矩阵「挑战」最优性：误差必然不小于 σ_{k+1}
for k in [3, 5]:
    best = np.inf
    for _ in range(200):
        B = rng.normal(size=(m, n)) @ rng.normal(size=(n, n))   # 一般满秩
        Bk = (lambda u, s, vt: (u[:, :k] * s[:k]) @ vt[:k])(*np.linalg.svd(B, full_matrices=False))
        best = min(best, np.linalg.norm(A - Bk, 2))
    print(f"k={k}: 200 个随机秩 {k} 阵的最小误差 = {best:.6e}  ≥  σ{k+1} = {S[k]:.6e}")
```

**结论：** 随机秩 $k$ 矩阵的误差都**严格大于**（通常是远大于）$\sigma_{k+1}$，从没有更小的——**Eckart–Young 保证 $A_k$ 的误差最小**。
:::

:::

<a id="sup-2.6.6"></a>

## 2.6.6 低秩逼近的应用：图像压缩与 PCA

::: method 应用一 · 图像与矩阵的低秩压缩

Eckart–Young 说截断 SVD 是最优的，那么它到底怎么用？先看最直观的一类：压缩。

$A_k$ 的直接因子存储需 $k(m+n+1)$ 个数：$U$、$V$ 的各 $k$ 列以及 $k$ 个奇异值；原矩阵需 $mn$ 个数。若把奇异值吸收到某个因子中，可存为 $k(m+n)$ 个数，下表采用后一种计数。存储占比为 $k(m+n)/(mn)$。

**本章实测（合成图像，$120\times120$，包含几个二维正弦叠加与一条亮带）：**

| $k$ | 存储占比 $2k/120$ | $\lVert E\rVert_F/\lVert A\rVert_F$ | RMSE | PSNR |
|:--:|:--:|:--:|:--:|:--:|
| 1 | 1.7% | 0.7243 | 0.6642 | 17.3 dB |
| 2 | 3.3% | 0.3182 | 0.2917 | 24.4 dB |
| 3 | 5.0% | 0.2336 | 0.2142 | 27.1 dB |
| 5 | 8.3% | 0.1938 | 0.1777 | 28.7 dB |
| 8 | 13.3% | 0.1122 | 0.1029 | 33.5 dB |
| 12 | 20.0% | 0.0152 | 0.0140 | 50.8 dB |

**读表：** 旧表给出 $k=12$ 时存储占比 $20\%$、PSNR 为 $50.8$ dB，$k=3\to5$ 与 $k=8\to12$ 的收益不同。一般应由尾部平方和解释这种变化，不能把某几个奇异值分别归属于某个图像部件：多个矩阵项叠加后的奇异值并不逐项相加。本表与对应脚本的既有记录缺少环境说明，数值应以实际复现为准，不据此断言肉眼质量或通用图像压缩水平。
:::

::: method 应用二 · PCA（主成分分析）

给定中心化数据矩阵 $X\in\mathbb R^{n\times d}$（$n>1$ 个样本、$d$ 个特征，每列均值为零），PCA（principal component analysis，主成分分析）寻找投影方差最大的单位方向。对方向 $v$，投影样本为 $Xv$，样本方差为 $\|Xv\|_2^2/(n-1)=v^{\mathrm T}Cv$，因此 Rayleigh 商的最大化给出首主方向，之后在正交补中依次求解。

1. 记协方差矩阵 $C=X^{\mathrm T}X/(n-1)$；它用于说明原理，不必显式形成；
2. 对 $X$ 做 SVD：$X=U\Sigma V^{\mathrm T}$；
3. **主方向 = $V$ 的列**（即 $C$ 的特征向量）；**主成分方差 = $\sigma_i^2/(n-1)$**（$C$ 的特征值）；
4. 取前 $k$ 列降维：$\boldsymbol{z}=V_k^{\mathrm T}\boldsymbol{x}\in\mathbb{R}^k$，方差解释比 $=\sum_{i\le k}\sigma_i^2/\sum_i\sigma_i^2$。

**为什么直接对 $X$ 做 SVD？** 列满秩时 $\mathrm{cond}_2(X^{\mathrm T}X)=\mathrm{cond}_2(X)^2$，显式形成协方差矩阵会增加小奇异值的计算困难。秩亏时二者通常的条件数均为无穷，不能继续套用有限条件数的位数估算。直接 SVD 可避免这一步，但不保证每个小奇异值都有高相对精度。数据单位也会影响主方向；若先标准化各特征，回答的是不同的方差优化问题。

**本章实测（$400$ 个二维样本，真实协方差 $\begin{pmatrix}3&2\\2&2\end{pmatrix}$，其理论特征值 $4.5616/0.4384$）：** 样本协方差 $\begin{pmatrix}3.0504&2.0862\\2.0862&2.0822\end{pmatrix}$，其特征值 $4.7080/0.4247$（采样波动，与理论值同量级）；主方向 $\approx(-0.783,-0.622)$（对应 $3$ 号种子下的样本方向），第一主成分解释 $91.7\%$ 的方差。

最后核对两条路径的关系：**SVD 与特征值分解给出完全一致的结果**：$\sigma_i(X_c)=\sqrt{(n-1)\lambda_i(C)}$（实测 $43.3414/13.0172$ 与 $\sqrt{399\times4.7080}=43.34$、$\sqrt{399\times0.4247}=13.02$ ✓）。详见 [2.7](sec27.md#sup-2.7.3) 实验三。
:::

::: think 思考 · 低秩逼近的三种「正则化」用法

同一个「截断奇异值」操作，在不同场景有不同的名字：

1. **压缩：** 保留前 $k$ 个奇异值 → 用少量参数重建矩阵（图像、视频、模型权重）。
2. **去噪：** 若 $A=L+E$，信号 $L$ 的秩为 $k$ 且 $\|E\|_2\le\delta$，截断的最优性给出 $\|A-A_k\|_2\le\|A-L\|_2\le\delta$，故 $\|A_k-L\|_2\le2\delta$。这是矩阵误差保证，不表示 $A_k=L$；稳定恢复奇异方向还需信号与噪声间的谱间隙。
3. **正则化 / 求解病态问题：** 截断伪逆 $A_k^{+}=\sum_{i\le k}\boldsymbol v_i\boldsymbol u_i^{\mathrm T}/\sigma_i$ 丢弃小奇异值方向。这是截断 SVD 正则化，与采用平滑滤波的 Tikhonov 正则化不同，见[习题 D2](exercises.md)。

**三者的共同点：都由奇异值的大小决定信谁、不信谁。** 这就是 SVD 成为数据科学核心工具的深层原因——它提供了一个**有原则的「取舍」框架**。
:::

<a id="sup-2.6.7"></a>

## 2.6.7 小结与常见错误

::: method[core] 本节公式速查

| 概念 | 公式 / 结论 |
|:--|:--|
| SVD | $A=U\Sigma V^{\mathrm T}$，$U,V$ 正交，$\sigma_1\ge\cdots\ge\sigma_r\gt0$ |
| 与特征值的关系 | $A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i$；$A^{\mathrm T}A\boldsymbol{v}_i=\sigma_i^2\boldsymbol{v}_i$；$AA^{\mathrm T}\boldsymbol{u}_i=\sigma_i^2\boldsymbol{u}_i$ |
| 外积形式 | $A=\sum_{i\le r}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$ |
| 四个子空间 | $C(A)=$ span$\{\boldsymbol{u}_1..\boldsymbol{u}_r\}$；$N(A^{\mathrm T})=$ span$\{\boldsymbol{u}_{r+1}..\boldsymbol{u}_m\}$；$C(A^{\mathrm T})=$ span$\{\boldsymbol{v}_1..\boldsymbol{v}_r\}$；$N(A)=$ span$\{\boldsymbol{v}_{r+1}..\boldsymbol{v}_n\}$ |
| 范数与条件数 | $\lVert A\rVert_2=\sigma_1$；$\lVert A\rVert_F=\sqrt{\sum\sigma_i^2}$；$\mathrm{cond}_2=\sigma_1/\sigma_r$；$\lvert\det A\rvert=\prod\sigma_i$（方阵） |
| 伪逆 | $A^{+}=V\Sigma^{+}U^{\mathrm T}$；Penrose 四条件；秩亏最小二乘的最小范数解 |
| 列/行满秩简化 | 列满秩：$A^{+}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}$；行满秩：$A^{+}=A^{\mathrm T}(AA^{\mathrm T})^{-1}$ |
| Eckart–Young | $\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_2=\sigma_{k+1}$；$A_k=\sum_{i\le k}\sigma_i\boldsymbol{u}_i\boldsymbol{v}_i^{\mathrm T}$ |
| 迹不等式 | $\lvert\operatorname{tr}(A^{\mathrm T}B)\rvert\le\sum\sigma_i(A)\sigma_i(B)$ |
| 数值秩 | $\#\{i:\sigma_i\gt t\sigma_1\}$，阈值 $t$ 需按数据噪声水平选定 |

:::

::: think[core] 常见错误清单 · 自查七条
1. **把奇异值当特征值。** $\sigma_i(A)=\lvert\lambda_i(A)\rvert$ 一般不成立（只有对称 / 正规矩阵才有 $\sigma_i=\lvert\lambda_i\rvert$）。反例：$A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$ 的 $\lambda_i=0$ 而 $\sigma_1=1$。**奇异值总非负、总有 $\min(m,n)$ 个；特征值可负可复。**
2. **把存在性证明当计算方案。** 列满秩时形成 $A^{\mathrm T}A$ 会平方 2-范数条件数，可能损失小奇异值信息，但不是固定损失一半位数。一般直接调用 `np.linalg.svd(A)`。
3. **不考察噪声就求小奇异值的倒数。** 绝对放大率为 $1/\sigma_i$；截断 SVD 或 Tikhonov 可以降低噪声放大，同时会引入偏差，阈值须按任务选择。
4. **把 `np.linalg.matrix_rank` 的默认阈值当真理。** 这个函数的默认阈值是 $\max(m,n)\cdot\mathrm{eps}\cdot\sigma_1$，只适合「精确矩阵数值降秩」；**真实带噪数据的秩判定必须按噪声水平设阈值**（[2.6.4](#sup-2.6.4) 的思考题）。
5. **以为 SVD 的向量唯一。** 单个奇异向量可成对反号；重的正奇异值块中，左右向量须作相同正交旋转才能保持乘积；左右零空间的基则可独立选择。
6. **把未中心化的 SVD 当作方差 PCA。** 未中心化时得到的是二阶矩方向，均值项可能主导，但首方向不必恰好沿均值。中心化后再谈解释方差。
7. **以为两种范数下最优矩阵的唯一性相同。** 当 $0<k<r$ 且 $\sigma_k>\sigma_{k+1}$ 时，F-范数最佳秩 $k$ 逼近唯一；边界重值时不唯一。谱范数下即使有间隙也可能不唯一，例如 $A=\operatorname{diag}(3,1)$ 的 $\operatorname{diag}(c,0)$ 在 $2\le c\le4$ 时误差均为 1。
:::

::: preview 课程预告 · 本节之后
- **SVD 的计算算法**：Golub–Kahan 双对角化 + QR 迭代，复杂度 $O(mn\min(m,n))$——原书第 3 章 3.3（QR 方法）是其基础；实践用 LAPACK `gesdd`（`np.linalg.svd` 默认）；
- **秩亏最小二乘与正则化**：原书第 2 章 2.3.2「关于病态线性方程组的求解问题」与 Tikhonov 正则化；
- **PCA / 潜在语义分析 / 推荐系统**：数据科学的应用层，数学内核就是本节；
- **本章的 SVD 与第一章的条件数在此汇合**：$\mathrm{cond}_2(A)=\sigma_1/\sigma_r$（[2.6.3](#sup-2.6.3)），「离奇异有多远」有了精确答案。
:::
