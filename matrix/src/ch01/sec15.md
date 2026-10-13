# 1.5 向量长度与夹角

[1.4](sec14.md) 为线性空间装上了内积，但还没有真正「用」它。本节从内积中提取三个几何量——长度、夹角、正交，并证明第一个不平凡的定理：Cauchy–Schwarz 不等式。有了它，三角不等式、夹角公式、Gram 行列式的面积解释才能逐一落地。随后把「两两正交」的向量组升级为正交基与标准正交基：在这组特殊的基下，[1.4](sec14.md) 的度量矩阵坍缩为单位矩阵，内积计算退化为坐标的标准内积——这是贯穿后续全课程的技术支点。

::: preview 先抓住一件事

本节公式虽多，核心动作只有一个：**从向量中减去已有方向上的成分，留下正交残差。**Cauchy–Schwarz 的证明、Gram–Schmidt 算法与下一节的投影都围绕这个动作展开。
:::

<aside class="lesson-brief" aria-label="1.5 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>先回顾 1.4</strong><p>内积四公理、「第一变元线性」约定、正定性与度量矩阵 $G_{\mathcal E}$。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>长度四条性质、Cauchy–Schwarz 不等式、夹角与正交、Gram–Schmidt 正交化、标准正交基。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>能独立证明 Cauchy–Schwarz 不等式，并对一组给定的基执行 Gram–Schmidt 正交化。</p></div>
</aside>

<a id="sec-1.5.1"></a>

## 1.5.1 长度：从内积中提取「大小」

内积把一对向量变成了一个数；本节要做的第一件事，是让向量与自己做内积再开方，从中取出它的长度——三维空间里熟悉的长度公式，从此适用于任意内积空间。

::: def 定义 1.5.1 · 长度 length / 模 norm {#def-1.5.1}

设 $F$ 是实数域或复数域，$V$ 是定义在 $F$ 上的内积空间。对任意 $\boldsymbol{x}\in V$，实数

$$\|\boldsymbol{x}\|=\sqrt{(\boldsymbol{x},\boldsymbol{x})}$$

称为 $\boldsymbol{x}$ 的**长度**（或**模**）。长度为 $1$ 的向量称为**单位向量**。

:::

::: note

**注 1。**实数的绝对值和复数的模值都是向量长度的特例：取 $V=\mathbb R^1$ 或 $\mathbb C^1$，标准内积下的 $\|x\|=\sqrt{(x,x)}$ 恰好就是 $|x|$。定义 1.5.1 把「数的大小」推广成了「向量的大小」。

:::

正定性（[@def-1.4.1] 第 (4) 条）保证了根号下的数非负、且只有零向量长度为零，所以这个定义是合法的。但定义只是一行公式，好不好用要看它在具体空间里算出什么——下面三个空间共用同一个定义，内积却各不相同。

::: ex 例 1.5.A · 三个空间中的长度 {#ex-1.5.A}

(1) $\boldsymbol{x}=(1,i)^{\mathrm T}\in\mathbb C^2$（标准内积）；(2) $p(t)=t\in P_2(t)$（[1.4.5](sec14.md#sec-1.4.5) 的积分内积 $(p,q)=\int_0^1p(t)q(t)\,\mathrm dt$）；(3) 单位矩阵 $I_n\in\mathbb C^{n\times n}$（Frobenius 内积，[@ex-1.4.C]）。分别求长度。

::: sol 解答

**(1)** $\|\boldsymbol{x}\|=\sqrt{|1|^2+|i|^2}=\sqrt2$。复向量的长度必须逐分量取**模平方** $|x_i|^2=x_i\overline{x_i}$，而不是平方 $x_i^2$——后者对 $x_1=1,x_2=i$ 会算出 $0$，与「非零向量长度非零」矛盾。

**(2)** $\|t\|=\sqrt{\int_0^1t^2\,\mathrm dt}=\sqrt{\tfrac13}=\tfrac{1}{\sqrt3}$。同一多项式换成区间 $[-\pi,\pi]$ 上的内积长度就不同——**长度由内积决定，内积变了长度就变**（对照 [1.4.5](sec14.md#sec-1.4.5) 的内积例库）。

**(3)** $\|I_n\|_F=\sqrt{\operatorname{tr}(I_n^{\mathrm H}I_n)}=\sqrt n$。

:::

:::

长度有下面**四条**基本性质；其中第 (4) 条三角不等式的证明要等 [1.5.2](sec15.md#sec-1.5.2) 的 Cauchy–Schwarz 不等式就位后再补（这正是课件此处留白的原因，见下方勘误 E5）。

::: thm 命题 1.5.1 · 长度性质 {#prop-1.5.1}

$\forall\boldsymbol{x},\boldsymbol{y}\in V$ 和 $k\in F$，有：

（1）**正定性**：$\|\boldsymbol{x}\|\geq0$，且 $\|\boldsymbol{x}\|=0$ 当且仅当 $\boldsymbol{x}=\boldsymbol{\theta}$；<br> （2）**齐次性**：$\|k\boldsymbol{x}\|=|k|\,\|\boldsymbol{x}\|$；<br> （3）**平行四边形法则**：$\|\boldsymbol{x}+\boldsymbol{y}\|^2+\|\boldsymbol{x}-\boldsymbol{y}\|^2=2\big(\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2\big)$；<br> （4）**三角不等式**：$\|\boldsymbol{x}+\boldsymbol{y}\|\leq\|\boldsymbol{x}\|+\|\boldsymbol{y}\|$。

（(4) 与 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 等价——把 $\|\boldsymbol{x}+\boldsymbol{y}\|^2$ 按内积展开、两边约去 $\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2$ 即见。后者是 Cauchy–Schwarz 的直接推论，故不在命题内单列，证明见 [1.5.2](sec15.md#sec-1.5.2)。）

::: proof 证（(1)–(3)）

**(1)** 即内积的正定性，开方不改变「非负、等于零」的判断。

**(2)** $\|k\boldsymbol{x}\|^2=(k\boldsymbol{x},k\boldsymbol{x})=k\overline{k}(\boldsymbol{x},\boldsymbol{x})=|k|^2\|\boldsymbol{x}\|^2$，开方即得。数乘系数取的是**模** $|k|$，而不是 $k$ 本身——复空间中 $k$ 可以是复数。

**(3)** 按「第一变元线性、第二变元共轭线性」展开（利用 $(\boldsymbol{y},\boldsymbol{x})=\overline{(\boldsymbol{x},\boldsymbol{y})}$）：

$$\|\boldsymbol{x}+\boldsymbol{y}\|^2=(\boldsymbol{x},\boldsymbol{x})+(\boldsymbol{x},\boldsymbol{y})+(\boldsymbol{y},\boldsymbol{x})+(\boldsymbol{y},\boldsymbol{y})=\|\boldsymbol{x}\|^2+2\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})+\|\boldsymbol{y}\|^2,$$

把 $\boldsymbol{y}$ 换成 $-\boldsymbol{y}$ 得 $\|\boldsymbol{x}-\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2-2\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})+\|\boldsymbol{y}\|^2$。两式相加，交叉项抵消：

$$\|\boldsymbol{x}+\boldsymbol{y}\|^2+\|\boldsymbol{x}-\boldsymbol{y}\|^2=2\big(\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2\big).$$

:::

:::

<figure aria-labelledby="fig-para-caption" class="concept-figure" data-figure="FIG. 1–09">
<svg aria-labelledby="fig-para-title fig-para-desc" role="img" viewBox="0 0 680 260">
<title id="fig-para-title">平行四边形法则的几何图像</title>
<desc id="fig-para-desc">以 x 与 y 为邻边的平行四边形，两条对角线分别是 x+y 与 x−y；两对角线长度的平方和等于四边长度的平方和。</desc>
<g class="diagram-geo">
<line class="diagram-accent" x1="80" y1="205" x2="470" y2="205" stroke-width="2.6"></line>
<line class="diagram-accent" x1="80" y1="205" x2="230" y2="60" stroke-width="2.6"></line>
<line x1="230" y1="60" x2="620" y2="60" stroke="var(--fig-purple)" stroke-width="2.6"></line>
<line x1="470" y1="205" x2="620" y2="60" stroke="var(--fig-purple)" stroke-width="2.6"></line>
<line x1="80" y1="205" x2="620" y2="60" stroke="var(--fig-gold)" stroke-width="2.2" stroke-dasharray="7 5"></line>
<line x1="230" y1="60" x2="470" y2="205" stroke="var(--fig-gold)" stroke-width="2.2" stroke-dasharray="7 5"></line>
<text class="diagram-text" x="270" y="230">x</text>
<text class="diagram-text" x="140" y="125">y</text>
<text class="diagram-note" x="205" y="112">x + y</text>
<text class="diagram-note" x="425" y="150">x − y</text>
<text class="diagram-note" x="480" y="240">对角线 = 和向量与差向量</text>
</g>
</svg>
<figcaption id="fig-para-caption">平行四边形法则（命题 1.5.1 (3)）：两条对角线的平方和恒等于 $2(\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2)$，与夹角无关。</figcaption>
</figure>

::: note

平行四边形法则反过来刻画了内积空间：一般的线性空间没有长度；即便在赋范空间里，平行四边形法则也**不是**每条范数都满足——它恰好刻画「这个范数能否由某个内积诱导」。遇到新范数时，可以用它作第一道检验。

:::

<a id="sec-1.5.2"></a>

## 1.5.2 Cauchy–Schwarz 不等式

长度之后，下一个自然的问题是：内积能有多大？下面的不等式把「内积的大小」钉死在「长度的乘积」之内，是本节其余全部结论的共同源头。

::: thm 定理 1.5.1 · Cauchy–Schwarz 不等式 {#thm-1.5.1}

设 $V$ 是 $F$ 上的内积空间，$\forall\boldsymbol{x},\boldsymbol{y}\in V$，

$$|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|,$$

其中等号 $|(\boldsymbol{x},\boldsymbol{y})|=\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 当且仅当 $\boldsymbol{x},\boldsymbol{y}$ 线性相关时成立。

::: proof 证

若 $\boldsymbol{y}=\boldsymbol{\theta}$，两边都是零，结论成立（零向量与任何向量线性相关）。设 $\boldsymbol{y}\neq\boldsymbol{\theta}$，则 $(\boldsymbol{y},\boldsymbol{y})\gt0$。对任意 $\lambda\in F$，由正定性，

$$\boldsymbol{0}\leq(\boldsymbol{x}-\lambda\boldsymbol{y},\,\boldsymbol{x}-\lambda\boldsymbol{y})
=(\boldsymbol{x},\boldsymbol{x})-\overline{\lambda}(\boldsymbol{x},\boldsymbol{y})-\lambda(\boldsymbol{y},\boldsymbol{x})+|\lambda|^2(\boldsymbol{y},\boldsymbol{y}).$$

记 $c=(\boldsymbol{x},\boldsymbol{y})$、$d=(\boldsymbol{y},\boldsymbol{y})>0$，取 $\lambda=c/d$（于是 $\overline\lambda=\overline c/d$，且 $(\boldsymbol y,\boldsymbol x)=\overline c$）。三个含 $\lambda$ 的项逐项成为

$$-\overline\lambda c=-\frac{|c|^2}{d},\qquad-\lambda\overline c=-\frac{|c|^2}{d},\qquad |\lambda|^2d=\frac{|c|^2}{d}.$$

前两项与后一项合并，净剩 $-|c|^2/d$，于是

$$\boldsymbol{0}\leq(\boldsymbol{x},\boldsymbol{x})-\frac{|(\boldsymbol{x},\boldsymbol{y})|^2}{(\boldsymbol{y},\boldsymbol{y})},$$

即 $|(\boldsymbol{x},\boldsymbol{y})|^2\leq(\boldsymbol{x},\boldsymbol{x})(\boldsymbol{y},\boldsymbol{y})$，开方即得。

**等号条件。**上述推导中等号成立当且仅当 $(\boldsymbol{x}-\lambda\boldsymbol{y},\,\boldsymbol{x}-\lambda\boldsymbol{y})=0$，即 $\boldsymbol{x}=\lambda\boldsymbol{y}$。反过来，若 $\boldsymbol{x},\boldsymbol{y}$ 线性相关，不妨设 $\boldsymbol{x}=k\boldsymbol{y}$（$k\in F$），则 $|(\boldsymbol{x},\boldsymbol{y})|=|k|\,(\boldsymbol{y},\boldsymbol{y})=\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$，等号成立。

:::

:::

::: note

**证明的几何读法。**取 $\lambda=(\boldsymbol{x},\boldsymbol{y})/(\boldsymbol{y},\boldsymbol{y})$ 后，向量 $\boldsymbol{x}-\lambda\boldsymbol{y}$ 满足

$$(\boldsymbol{x}-\lambda\boldsymbol{y},\boldsymbol{y})=(\boldsymbol{x},\boldsymbol{y})-\lambda(\boldsymbol{y},\boldsymbol{y})=0,$$

即**残差与 $\boldsymbol{y}$ 正交**：从 $\boldsymbol{x}$ 里减去它沿 $\boldsymbol{y}$ 方向的「成分」，剩下的部分垂直于 $\boldsymbol{y}$。Cauchy–Schwarz 不等式说的正是「成分不超过全长」；这个「减掉投影、留下正交残差」的动作，就是 [1.5.6](sec15.md#sec-1.5.6) Gram–Schmidt 正交化的每一步，也是 [1.6](sec16.md) 投影概念的雏形。

:::

<figure aria-labelledby="fig-cs-residual-caption" class="concept-figure">
<svg aria-labelledby="fig-cs-residual-title fig-cs-residual-desc" role="img" viewBox="0 0 680 275">
<title id="fig-cs-residual-title">向量分成投影成分与正交残差</title>
<desc id="fig-cs-residual-desc">向量 x 分解为沿 y 方向的投影和与 y 正交的残差，形成直角三角形。</desc>
<defs><marker id="cs-arrow-blue" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-blue)"></path></marker><marker id="cs-arrow-red" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-red)"></path></marker></defs>
<line stroke="var(--line-strong)" stroke-width="1.5" x1="70" x2="620" y1="220" y2="220"></line>
<text class="diagram-note" x="588" y="210">span{y}</text>
<line marker-end="url(#cs-arrow-blue)" stroke="var(--fig-blue)" stroke-width="3" x1="105" x2="470" y1="220" y2="82"></line>
<text class="diagram-text" x="278" y="132">x</text>
<line marker-end="url(#cs-arrow-red)" stroke="var(--fig-red)" stroke-width="3" x1="105" x2="470" y1="220" y2="220"></line>
<text class="diagram-text" text-anchor="middle" x="288" y="246">λy（沿 y 的成分）</text>
<line stroke="var(--fig-green)" stroke-dasharray="6 4" stroke-width="3" x1="470" x2="470" y1="220" y2="82"></line>
<text class="diagram-text" x="485" y="150">r=x−λy</text>
<path d="M452,220 L452,202 L470,202" fill="none" stroke="var(--fig-neutral)" stroke-width="2"></path>
<circle cx="105" cy="220" fill="var(--fig-neutral)" r="4"></circle>
<text class="diagram-note" x="88" y="240">O</text>
<text class="diagram-mono" x="86" y="42">x = λy + r</text>
<text class="diagram-note" x="86" y="65">其中 (r,y)=0；等号成立 ⇔ r=0 ⇔ x 与 y 共线</text>
</svg>
<figcaption id="fig-cs-residual-caption"><b>C–S 的等号条件也能直接看见。</b>投影成分不可能比斜边 $\boldsymbol x$ 更长；只有残差消失、两向量共线时，投影才等于全长。</figcaption>
</figure>

<div class="widget" data-widget="cauchy-schwarz">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">Cauchy–Schwarz 的两端，永远差一个夹角余弦</strong></p>
<p class="widget-hint">拖动两个向量，看 $|(\boldsymbol{x},\boldsymbol{y})|$ 与 $\|\boldsymbol{x}\|\|\boldsymbol{y}\|$ 的比值。它恒 $\le 1$，只在两向量共线时取到 $1$——这就是等号条件的几何含义。</p>
</div>

::: ex 例 1.5.C · 用一个数值例子看见 C–S 证明里的每个对象 {#ex-1.5.C}

在 $\mathbb R^2$ 的标准内积下，取 $\boldsymbol x=(2,1)^{\mathrm T}$、$\boldsymbol y=(1,0)^{\mathrm T}$。求证明中选择的 $\lambda$、正交残差 $\boldsymbol r$，并验证 Cauchy–Schwarz 不等式。再说明怎样修改 $\boldsymbol x$ 才会取等号。

::: sol 解答

$$\lambda=\frac{(\boldsymbol x,\boldsymbol y)}{(\boldsymbol y,\boldsymbol y)}=\frac2{1}=2,\qquad
\boldsymbol r=\boldsymbol x-\lambda\boldsymbol y=(0,1)^{\mathrm T}.$$

确有 $(\boldsymbol r,\boldsymbol y)=0$。不等式两边分别是

$$|(\boldsymbol x,\boldsymbol y)|=2,\qquad \|\boldsymbol x\|\,\|\boldsymbol y\|=\sqrt5,$$

所以 $2<\sqrt5$。证明中的「余量」也可直接核对：

$$\|\boldsymbol x\|^2-\frac{|(\boldsymbol x,\boldsymbol y)|^2}{\|\boldsymbol y\|^2}=5-4=1=\|\boldsymbol r\|^2.$$

若把 $\boldsymbol x$ 改成 $(2,0)^{\mathrm T}=2\boldsymbol y$，残差变为零，此时两边都等于 $2$，恰好取等号。这个例子把「严格不等号来自非零正交残差」完整显示出来。

:::

:::

::: note

**注 2。**定义不同内积，可得到不同的 Cauchy 不等式。对 $\boldsymbol{x}=(x_1,\cdots,x_n)^{\mathrm T}$、$\boldsymbol{y}=(y_1,\cdots,y_n)^{\mathrm T}\in\mathbb R^n$，标准内积给出经典 Cauchy 不等式：

$$\Big|\sum_{i=1}^{n}x_i y_i\Big|\leq\Big(\sum_{i=1}^{n}x_i^2\Big)^{1/2}\Big(\sum_{i=1}^{n}y_i^2\Big)^{1/2};$$

把内积换成 [@ex-1.4.B] 的积分内积 $(f,g)=\int_0^1f(t)g(t)\,\mathrm dt$，同一份证明逐字照抄，就得到 **Schwarz 不等式**：

$$\Big|\int_0^1f(t)g(t)\,\mathrm dt\Big|\leq\Big(\int_0^1f(t)^2\,\mathrm dt\Big)^{1/2}\Big(\int_0^1g(t)^2\,\mathrm dt\Big)^{1/2}.$$

一个定理、两副面孔——差别只在「内积是什么」。

:::

现在回头补上命题 1.5.1 (4) 欠下的证明。

::: proof 命题 1.5.1 (4) 的证明（此时 C-S 已就位）

利用 [1.5.1](sec15.md#sec-1.5.1) 证明 (3) 时展开的 $\|\boldsymbol{x}+\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+2\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})+\|\boldsymbol{y}\|^2$，把实部放缩成模、再用 C-S：

$$\|\boldsymbol{x}+\boldsymbol{y}\|^2
\leq\|\boldsymbol{x}\|^2+2|(\boldsymbol{x},\boldsymbol{y})|+\|\boldsymbol{y}\|^2
\leq\|\boldsymbol{x}\|^2+2\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|+\|\boldsymbol{y}\|^2
=\big(\|\boldsymbol{x}\|+\|\boldsymbol{y}\|\big)^2,$$

开方即得三角不等式。特别地，链条的第一环 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})\leq|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 正是课件与命题并列写出的那条不等式。

:::

::: errata 勘误 E5 · 课件页 4 的占位框与证明顺序

课件在三角不等式一页只画了平行四边形示意图，证明处留下一个「在此处键入公式。」的空占位框（PowerPoint 模板残留），证明没有给出；且**此时证不了**——三角不等式需要 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})\leq|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$，而 Cauchy–Schwarz 不等式在课件下一页才出现，构成循环。本教程的处理：先证 (1)–(3)，把 (4) 悬置到 C-S 之后补全（如上）。

:::

<a id="sec-1.5.3"></a>

## 1.5.3 夹角：内积与方向的桥梁

夹角的定义不是凭空写下的，它从平面几何的余弦定理**倒推**出来。设三角形两边由向量 $\boldsymbol{a}=\overrightarrow{AB}$、$\boldsymbol{b}=\overrightarrow{AC}$ 构成，夹角 $\alpha$ 在顶点 $A$ 处，第三边对应 $\boldsymbol{c}=\boldsymbol{b}-\boldsymbol{a}$。余弦定理说

$$\cos\alpha=\frac{\|\boldsymbol{b}\|^2+\|\boldsymbol{a}\|^2-\|\boldsymbol{c}\|^2}{2\|\boldsymbol{a}\|\,\|\boldsymbol{b}\|}.$$

把 $\boldsymbol{c}=\boldsymbol{b}-\boldsymbol{a}$ 代入分子，用 [1.5.1](sec15.md#sec-1.5.1) 展开差的平方（实空间中 $\operatorname{Re}(\boldsymbol{a},\boldsymbol{b})=(\boldsymbol{a},\boldsymbol{b})$）：

$$\|\boldsymbol{b}\|^2+\|\boldsymbol{a}\|^2-\|\boldsymbol{b}-\boldsymbol{a}\|^2=2(\boldsymbol{a},\boldsymbol{b}),$$

分子恰好是内积的两倍。于是余弦定理**等价于**

$$\cos\alpha=\frac{(\boldsymbol{a},\boldsymbol{b})}{\|\boldsymbol{a}\|\,\|\boldsymbol{b}\|}.$$

既然右边只用到内积与长度，就把它**当作定义**搬进任意（实）内积空间：

::: def 定义 1.5.2 · 向量夹角 angle {#def-1.5.2}

设 $V$ 是**实**内积空间，$\forall\boldsymbol{x},\boldsymbol{y}\in V$（$\boldsymbol{x},\boldsymbol{y}\neq\boldsymbol{\theta}$），定义向量 $\boldsymbol{x}$ 和 $\boldsymbol{y}$ 的夹角为

$$\alpha=\arccos\frac{(\boldsymbol{x},\boldsymbol{y})}{\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|}\in[0,\pi].$$

:::

定义的合法性由 C-S 保证：比值落在 $[-1,1]$ 内，$\arccos$ 有定义；夹角与「谁先谁后」无关（实空间内积对称）。复空间的情况见下方勘误 E6——复空间里真正有定义的对象是正交，而不是夹角。

::: note

**注 3。**夹角是内积带来的新概念，它给线性空间补上了一层「图形化」的理解：$\cos\alpha=0$ 对应垂直，$\cos\alpha=\pm1$ 对应平行（即线性相关——与 [@thm-1.5.1] 的等号条件一致），介于其间的角度把「方向接近程度」变成了可以计算的数。

:::

::: errata 勘误 E6 · 课件页 8 的夹角定义未区分实与复

课件把定义 1.5.2 写在一般内积空间上，但复内积空间中 $(\boldsymbol{x},\boldsymbol{y})$ 是**复数**，而 $\arccos$ 只接受 $[-1,1]$ 内的实参数，公式无定义。标准处理有两种：① 夹角概念限于实内积空间（本教程采用）；② 复空间中把分子换成 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})$（它仍满足 $\big|\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})\big|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$）。复空间中真正重要、且定义无歧义的是「正交」：$(\boldsymbol{x},\boldsymbol{y})=0$ 对复数照样有意义，见 [1.5.5](sec15.md#sec-1.5.5)。

:::

<a id="sec-1.5.4"></a>

## 1.5.4 Gram 行列式的几何意义

夹角可算之后，1.4 节引入的度量矩阵就不再只是记账工具。二阶情形最简单，也最能把它的几何含义说清楚：一个行列式，恰好等于一块面积。

::: ex 例 1.5.1 · $\mathbb R^2$ 中度量矩阵行列式的几何含义 {#ex-1.5.1}

$\mathbb R^2$ 关于基 $\boldsymbol{x}_1,\boldsymbol{x}_2$ 的度量矩阵为

$$G(\boldsymbol{x}_1,\boldsymbol{x}_2)=\begin{pmatrix}(\boldsymbol{x}_1,\boldsymbol{x}_1)&(\boldsymbol{x}_1,\boldsymbol{x}_2)\\(\boldsymbol{x}_2,\boldsymbol{x}_1)&(\boldsymbol{x}_2,\boldsymbol{x}_2)\end{pmatrix}$$

（按 [@def-1.4.4] 的下标约定 $g_{ij}=(\boldsymbol{x}_j,\boldsymbol{x}_i)$，实空间中 $(\boldsymbol{x}_2,\boldsymbol{x}_1)=(\boldsymbol{x}_1,\boldsymbol{x}_2)$）。问：行列式 $\det G(\boldsymbol{x}_1,\boldsymbol{x}_2)$ 的几何含义是什么？

::: sol 解答

直接展开（实空间，$(\boldsymbol{x}_1,\boldsymbol{x}_2)$ 是实数）：

$$\det G(\boldsymbol{x}_1,\boldsymbol{x}_2)
=(\boldsymbol{x}_1,\boldsymbol{x}_1)(\boldsymbol{x}_2,\boldsymbol{x}_2)-(\boldsymbol{x}_1,\boldsymbol{x}_2)^2
=\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2-\big(\|\boldsymbol{x}_1\|\,\|\boldsymbol{x}_2\|\cos\alpha\big)^2,$$

其中 $\alpha$ 是 $\boldsymbol{x}_1$ 与 $\boldsymbol{x}_2$ 的夹角（定义 1.5.2）。于是

$$\det G(\boldsymbol{x}_1,\boldsymbol{x}_2)=\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2\big(1-\cos^2\alpha\big)=\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2\sin^2\alpha.$$

而「$\|\boldsymbol{x}_1\|\,\|\boldsymbol{x}_2\|\sin\alpha$」正是以 $\boldsymbol{x}_1,\boldsymbol{x}_2$ 为邻边的平行四边形的面积。所以：

**$\det G(\boldsymbol{x}_1,\boldsymbol{x}_2)$ 恰是以 $\boldsymbol{x}_1$ 与 $\boldsymbol{x}_2$ 为邻边的平行四边形面积的平方。**

:::

:::

<figure aria-labelledby="fig-gram2-caption" class="concept-figure" data-figure="FIG. 1–10">
<svg aria-labelledby="fig-gram2-title fig-gram2-desc" role="img" viewBox="0 0 680 250">
<title id="fig-gram2-title">Gram 行列式 = 平行四边形面积的平方</title>
<desc id="fig-gram2-desc">两个基向量张成的平行四边形，其面积等于两个向量长度之积乘以夹角的正弦；面积的平方恰是 Gram 矩阵的行列式。</desc>
<g>
<line class="diagram-accent" x1="90" y1="200" x2="400" y2="200" stroke-width="2.6"></line>
<line class="diagram-accent" x1="90" y1="200" x2="210" y2="70" stroke-width="2.6"></line>
<line x1="210" y1="70" x2="520" y2="70" stroke="var(--fig-purple)" stroke-width="2.6"></line>
<line x1="400" y1="200" x2="520" y2="70" stroke="var(--fig-purple)" stroke-width="2.6"></line>
<line x1="90" y1="200" x2="165" y2="200" stroke="var(--fig-gold)" stroke-width="2"></line>
<line x1="165" y1="200" x2="165" y2="169" stroke="var(--fig-gold)" stroke-width="2"></line>
<line x1="152" y1="179" x2="163" y2="190" stroke="var(--fig-gold)" stroke-width="2"></line>
<path d="M158,200 A34,34 0 0 1 145,181" fill="none" stroke="var(--muted)" stroke-width="1.6"></path>
<text class="diagram-text" x="170" y="192">α</text>
<text class="diagram-text" x="240" y="224">x₁</text>
<text class="diagram-text" x="135" y="120">x₂</text>
<text class="diagram-note" x="480" y="142">面积 = ‖x₁‖‖x₂‖ sin α</text>
<text class="diagram-note" x="480" y="168">det G = 面积²</text>
</g>
</svg>
<figcaption id="fig-gram2-caption">基「张开」的程度被 Gram 行列式精确记录：$\det G=0$ ⟺ 面积为零 ⟺ $\boldsymbol{x}_1,\boldsymbol{x}_2$ 线性相关 ⟺ $G$ 奇异。</figcaption>
</figure>

这个几何解释与 [1.4](sec14.md) 的代数结论严丝合缝：$\boldsymbol{x}_1,\boldsymbol{x}_2$ 是基（线性无关）$\Longleftrightarrow$ $G$ 正定 $\Longleftrightarrow$ $\det G\gt0$（面积非零）。几何（面积）与代数（正定性）在此对齐。

::: note

**复空间中的推广。**课件中该例限定在 $\mathbb R^2$（实空间），上式成立。若要把结论搬到复内积空间，只需把平方换成模平方（因为此时 $(\boldsymbol{x}_1,\boldsymbol{x}_2)$ 是复数，而 $(\boldsymbol{x}_2,\boldsymbol{x}_1)=\overline{(\boldsymbol{x}_1,\boldsymbol{x}_2)}$）：

$$\det G(\boldsymbol{x}_1,\boldsymbol{x}_2)=\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2-\big|(\boldsymbol{x}_1,\boldsymbol{x}_2)\big|^2=\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2\left(1-\frac{\big|(\boldsymbol{x}_1,\boldsymbol{x}_2)\big|^2}{\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2}\right)\geq0,$$

非负性正是 C-S。**这里刻意保留了比值、没有写成 $\cos\alpha$**：复空间中夹角 $\alpha$ 本身没有定义（见 [@def-1.5.2] 与勘误 E6），只有这个比值有意义；实空间中该比值就是 $\cos^2\alpha$，于是与课件的写法一致。

:::

::: think 推广 · 高维的「体积」

$\mathbb R^n$ 中 $n$ 个向量 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 拼成的平行多面体，其体积的平方同样等于 $\det G(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)$（完整归纳证明见[附录 A.2](../appendix/appendix-a.md#sec-A.2)，那里还顺带得到著名的 Hadamard 不等式）。于是「$G$ 正定 ⟺ 基」的几何读法在高维依然成立：**基就是张满体积的向量组**。这个观点在数值分析中化身为「矩阵体积」与最小二乘的法方程条件数，此处只埋个伏笔。

:::

<a id="sec-1.5.5"></a>

## 1.5.5 正交、勾股定理与正交向量组

夹角里有一个取值值得单独定义——$\tfrac{\pi}{2}$，此时内积恰好为零。抓住「内积为零」这个条件，就可以脱离夹角公式本身来定义垂直：

::: def 定义 1.5.3 · 正交与正交向量组 orthogonal {#def-1.5.3}

设 $V$ 是内积空间。对 $V$ 中向量 $\boldsymbol{x}$ 和 $\boldsymbol{y}$，若 $(\boldsymbol{x},\boldsymbol{y})=0$，则称 $\boldsymbol{x}$ 与 $\boldsymbol{y}$ **正交**（或**垂直**），记为 $\boldsymbol{x}\perp\boldsymbol{y}$。若一组**非零**向量两两正交，则称为**正交向量组**。单位向量构成的正交向量组称为**标准正交向量组**。

:::

::: note

**注 4。**零向量 $\boldsymbol{\theta}$ 与任何向量均正交（$(\boldsymbol{\theta},\boldsymbol{y})=0$，见 [@ex-1.4.1]）；正因如此，「正交向量组」的定义里必须写明**非零**，否则零向量混进来会破坏下面定理 1.5.2 的价值。$(\boldsymbol{x},\boldsymbol{y})=0$ 这条判据在复空间中同样合法——共轭对称性保证 $(\boldsymbol{x},\boldsymbol{y})=0\Longleftrightarrow(\boldsymbol{y},\boldsymbol{x})=0$，正交关系是对称的。

:::

::: note

**注 5 · 勾股定理。**（实内积空间中）$\boldsymbol{x}$ 与 $\boldsymbol{y}$ 正交当且仅当

$$\|\boldsymbol{x}+\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2,$$

该结果可推广至任意有限多个两两正交的向量：$\|\boldsymbol{x}_1+\cdots+\boldsymbol{x}_s\|^2=\|\boldsymbol{x}_1\|^2+\cdots+\|\boldsymbol{x}_s\|^2$。

**证：**由 [1.5.1](sec15.md#sec-1.5.1) 的展开式 $\|\boldsymbol{x}+\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+2\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})+\|\boldsymbol{y}\|^2$，实空间中 $(\boldsymbol{x},\boldsymbol{y})=0$ 就是 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})=0$，反之亦然。多向量情形对展开式逐项观察：两两正交使全部交叉项消失。

:::

::: errata 勘误 E7 · 课件页 11 注 5 的「当且仅当」在复空间不成立

复内积空间中，正交（$(\boldsymbol{x},\boldsymbol{y})=0$）仍**推出**勾股等式，但反过来不行：勾股等式只约束 $\operatorname{Re}(\boldsymbol{x},\boldsymbol{y})=0$，虚部可以非零。反例：$V=\mathbb C^1$，$x=1$，$y=i$，则 $\|x+y\|^2=|1+i|^2=2=\|x\|^2+\|y\|^2$，但 $(x,y)=\overline{i}\cdot1=-i\neq0$。故「当且仅当」需限定在实内积空间（或把条件加强为 $\operatorname{Re}$ 与 $\operatorname{Im}$ 同时为零，那恰好就是 $(\boldsymbol{x},\boldsymbol{y})=0$）。

:::

::: errata 勘误 E8 · 课件 1.5 的注编号重复

课件 1.5 的注依次编为：页 2「注 1」、页 5「注 2」、页 8「注 3」、页 11「注 4」「注 5」、页 18 又出现一个「注 4」（内容与前面无关，讲标准正交基与单位度量矩阵），且**没有注 6**。本教程按出现顺序重排为注 1–6，正文相应处已注明（见 [1.5.7](sec15.md#sec-1.5.7)）。

:::

::: thm 定理 1.5.2 · 正交向量组线性无关 {#thm-1.5.2}

设 $\boldsymbol{x}_1,\boldsymbol{x}_2,\cdots,\boldsymbol{x}_s$（$s\geq1$）是内积空间 $V$ 的正交向量组，则它们线性无关。

::: proof 证

考查方程

$$k_1\boldsymbol{x}_1+k_2\boldsymbol{x}_2+\cdots+k_s\boldsymbol{x}_s=\boldsymbol{\theta}.$$

用 $\boldsymbol{x}_i$（$i=1,2,\cdots,s$）与上式两端作内积。右端 $(\boldsymbol{\theta},\boldsymbol{x}_i)=0$；左端由第一变元线性逐项展开：

$$\big(k_1\boldsymbol{x}_1+\cdots+k_s\boldsymbol{x}_s,\ \boldsymbol{x}_i\big)
=\sum_{j=1}^{s}k_j(\boldsymbol{x}_j,\boldsymbol{x}_i)
=k_i(\boldsymbol{x}_i,\boldsymbol{x}_i),$$

最后一步用了两两正交：$j\neq i$ 时 $(\boldsymbol{x}_j,\boldsymbol{x}_i)=0$。于是

$$k_i(\boldsymbol{x}_i,\boldsymbol{x}_i)=0.$$

由正交向量组的定义 $\boldsymbol{x}_i\neq\boldsymbol{\theta}$，故 $(\boldsymbol{x}_i,\boldsymbol{x}_i)=\|\boldsymbol{x}_i\|^2\gt0$，迫使 $k_i=0$。$i$ 任意，故线性无关。

:::

:::

::: thm 推论 1.5.1 · 正交组规模的上界 {#cor-1.5.1}

在 $n$ 维内积空间中，正交向量组中的向量不会超过 $n$ 个。

::: proof 证

正交向量组线性无关（[@thm-1.5.2]），而 $n$ 维空间中无关组至多含 $n$ 个向量（[1.3.6](sec13.md#sec-1.3.6) 计数引理）。

:::

:::

::: think 思考 · 上界能达到吗？

在 $n$ 维内积空间 $V$ 中，能否**一定**找到包含 $n$ 个向量的正交向量组（从而凑成正交基）？——能。任取一组基，用下一小节的 Gram–Schmidt 正交化即可。直观上：$n$ 维空间里有 $n$ 个互相独立的方向，就容得下 $n$ 根互相垂直的「轴」。

:::

<a id="sec-1.5.6"></a>

## 1.5.6 Gram–Schmidt 正交化

上一小节的思考题已给出答案：任取一组基，执行 Gram–Schmidt 正交化。下面把它展开成可逐步执行的公式——逐个减掉新向量里属于已有方向的成分，剩下的部分自动与前面全部正交。

::: method Gram–Schmidt 正交化 {#method-gs}

设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是 $V$ 的一组基，$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 是待定的正交向量组。构造：

$$\boldsymbol{y}_1=\boldsymbol{x}_1,\qquad
\boldsymbol{y}_k=\boldsymbol{x}_k-\sum_{i=1}^{k-1}\frac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\,\boldsymbol{y}_i,\qquad k=2,\cdots,n.$$

**读法：**从 $\boldsymbol{x}_k$ 里逐个减掉它在已有正交方向 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_{k-1}$ 上的「成分」$\dfrac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\boldsymbol{y}_i$——这正是 [@thm-1.5.1] 证明中「减成分、留垂直残差」的动作重复 $k-1$ 次。

:::

::: proof 验证（正交性 · 张成不变 · 非零性）

**正交性。**对 $k\gt j$，用 $\boldsymbol{y}_j$ 与 $\boldsymbol{y}_k$ 的构造式作内积（第一变元线性）：

$$(\boldsymbol{y}_k,\boldsymbol{y}_j)=(\boldsymbol{x}_k,\boldsymbol{y}_j)-\sum_{i=1}^{k-1}\frac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}(\boldsymbol{y}_i,\boldsymbol{y}_j)=(\boldsymbol{x}_k,\boldsymbol{y}_j)-\frac{(\boldsymbol{x}_k,\boldsymbol{y}_j)}{(\boldsymbol{y}_j,\boldsymbol{y}_j)}(\boldsymbol{y}_j,\boldsymbol{y}_j)=0,$$

中间一步用了已归纳建立的两两正交（$i\neq j$ 的项全为零）。

**张成不变。**$\boldsymbol{y}_k$ 是 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k$ 的线性组合；反过来构造式可改写为 $\boldsymbol{x}_k=\boldsymbol{y}_k+\sum_i\frac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\boldsymbol{y}_i$。故对每个 $k$ 都有 $\operatorname{span}(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_k)=\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k)$。

**非零性。**若 $\boldsymbol{y}_k=\boldsymbol{\theta}$，则 $\boldsymbol{x}_k\in\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_{k-1})$（由张成不变），与 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是基矛盾。

三者合起来：$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 是含 $n$ 个向量的正交向量组——回答了课件的思考题。再逐个单位化 $\boldsymbol{q}_k=\boldsymbol{y}_k/\|\boldsymbol{y}_k\|$，即得**标准正交向量组**。

:::

<figure aria-labelledby="fig-gs-caption" class="concept-figure" data-figure="FIG. 1–11">
<svg aria-labelledby="fig-gs-title fig-gs-desc" role="img" viewBox="0 0 680 250">
<title id="fig-gs-title">Gram–Schmidt 的每一步：减掉成分，留下垂直残差</title>
<desc id="fig-gs-desc">向量 x2 减去它在 y1 方向上的投影成分，得到与 y1 垂直的 y2。</desc>
<defs><marker id="gs-arrow" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<g>
<line class="diagram-accent" x1="70" y1="205" x2="400" y2="205" stroke-width="2.8"></line>
<defs><marker id="gs-arrow2" markerHeight="6" markerWidth="6" orient="auto" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--fig-green)"></path></marker></defs>
<line x1="70" y1="205" x2="356" y2="109" stroke="var(--fig-purple)" stroke-width="2.4" marker-end="url(#gs-arrow)"></line>
<line x1="70" y1="205" x2="358" y2="205" stroke="var(--fig-gold)" stroke-width="2.2" stroke-dasharray="6 5"></line>
<line x1="360" y1="205" x2="360" y2="112" stroke="var(--fig-green)" stroke-width="2.8" marker-end="url(#gs-arrow2)"></line>
<line x1="360" y1="205" x2="346" y2="205" stroke="var(--fig-green)" stroke-width="1.8"></line>
<line x1="360" y1="191" x2="346" y2="191" stroke="var(--fig-green)" stroke-width="1.8"></line>
<line x1="346" y1="205" x2="346" y2="191" stroke="var(--fig-green)" stroke-width="1.8"></line>
<text class="diagram-text" x="405" y="228">y₁ = x₁</text>
<text class="diagram-text" x="368" y="98">x₂</text>
<text class="diagram-note" x="150" y="192">成分（沿 y₁，虚线）</text>
<text class="diagram-text" x="382" y="160">y₂ ⊥ y₁</text>
<text class="diagram-note" x="470" y="150">减掉在已有正交方向上的</text>
<text class="diagram-note" x="470" y="174">全部成分，剩下的必垂直</text>
</g>
</svg>
<figcaption id="fig-gs-caption">「减成分、留垂直残差」重复 $n-1$ 轮，就把任意基变成正交基；单位化后得标准正交基。</figcaption>
</figure>

<div class="widget" data-widget="gram-schmidt">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">一步步看 Gram–Schmidt 把斜基掰成正交基</strong></p>
<p class="widget-hint">按「下一步」看构造过程。拖动图中金色端点可以换一个 $\boldsymbol{x}_2$，观察 $\boldsymbol{b}_2$ 始终垂直于 $\boldsymbol{b}_1$——无论 $\boldsymbol{x}_2$ 怎么动，减掉投影之后剩下的必然垂直。</p>
</div>

::: ex 例 1.5.B · 对一组基执行 Gram–Schmidt {#ex-1.5.B}

(1) 基取自 [@ex-1.4.D]：$\boldsymbol{x}_1=(1,0)^{\mathrm T}$，$\boldsymbol{x}_2=(1,1)^{\mathrm T}$（$\mathbb R^2$ 标准内积）；(2) $\boldsymbol{x}_1=(1,1,0)^{\mathrm T}$，$\boldsymbol{x}_2=(1,0,1)^{\mathrm T}$，$\boldsymbol{x}_3=(0,1,1)^{\mathrm T}$（$\mathbb R^3$ 标准内积）。分别正交化并单位化。

::: sol 解答

**(1)** $\boldsymbol{y}_1=(1,0)^{\mathrm T}$；

$$\boldsymbol{y}_2=\boldsymbol{x}_2-\frac{(\boldsymbol{x}_2,\boldsymbol{y}_1)}{(\boldsymbol{y}_1,\boldsymbol{y}_1)}\boldsymbol{y}_1=(1,1)^{\mathrm T}-\frac{1}{1}(1,0)^{\mathrm T}=(0,1)^{\mathrm T}.$$

单位化：$\boldsymbol{q}_1=(1,0)^{\mathrm T}$，$\boldsymbol{q}_2=(0,1)^{\mathrm T}$——斜基化为标准正交基。用 $\boldsymbol{q}_1,\boldsymbol{q}_2$ 算内积当然比用原来的斜基（$G=\begin{pmatrix}1&1\\1&2\end{pmatrix}$）省事，这正是标准正交基的价值。

**(2)** $\boldsymbol{y}_1=(1,1,0)^{\mathrm T}$，$(\boldsymbol{y}_1,\boldsymbol{y}_1)=2$；

$$\boldsymbol{y}_2=\boldsymbol{x}_2-\frac{(\boldsymbol{x}_2,\boldsymbol{y}_1)}{2}\boldsymbol{y}_1=(1,0,1)^{\mathrm T}-\tfrac12(1,1,0)^{\mathrm T}=\big(\tfrac12,-\tfrac12,1\big)^{\mathrm T},\qquad(\boldsymbol{y}_2,\boldsymbol{y}_2)=\tfrac32;$$

$$\boldsymbol{y}_3=\boldsymbol{x}_3-\frac{(\boldsymbol{x}_3,\boldsymbol{y}_1)}{2}\boldsymbol{y}_1-\frac{(\boldsymbol{x}_3,\boldsymbol{y}_2)}{3/2}\boldsymbol{y}_2=(0,1,1)^{\mathrm T}-\tfrac12(1,1,0)^{\mathrm T}-\tfrac13\big(\tfrac12,-\tfrac12,1\big)^{\mathrm T}=\big(-\tfrac23,\tfrac23,\tfrac23\big)^{\mathrm T}.$$

核算：$(\boldsymbol{y}_1,\boldsymbol{y}_2)=\tfrac12-\tfrac12+0=0$ ✓，$(\boldsymbol{y}_1,\boldsymbol{y}_3)=-\tfrac23+\tfrac23=0$ ✓，$(\boldsymbol{y}_2,\boldsymbol{y}_3)=-\tfrac13-\tfrac13+\tfrac23=0$ ✓。单位化（$\|\boldsymbol{y}_1\|=\sqrt2$，$\|\boldsymbol{y}_2\|=\sqrt{3/2}$，$\|\boldsymbol{y}_3\|=\tfrac{2}{\sqrt3}$）：

$$\boldsymbol{q}_1=\tfrac{1}{\sqrt2}(1,1,0)^{\mathrm T},\qquad
\boldsymbol{q}_2=\tfrac{1}{\sqrt6}(1,-1,2)^{\mathrm T},\qquad
\boldsymbol{q}_3=\tfrac{1}{\sqrt3}(-1,1,1)^{\mathrm T}.$$

（$\boldsymbol{y}_2$ 乘以 $2$、$\boldsymbol{y}_3$ 乘以 $\tfrac32$ 只改变长度不改变方向，正交性不受影响——用整数形式验证更方便。）

:::

:::

<a id="sec-1.5.7"></a>

## 1.5.7 正交基、标准正交基与三角函数系

正交组的规模有上界（推论 1.5.1）。达到这个上界的正交组最有用：它恰好能像普通基那样给向量安上坐标，内积的计算也随之简化。这类正交组值得单独命名。

::: def 定义 1.5.4 · 正交基与标准正交基 {#def-1.5.4}

在 $n$ 维内积空间中，由 $n$ 个向量组成的正交向量组称为**正交基**。由单位向量组成的正交基称为**标准正交基**。

:::

定义的合理性由 [@thm-1.5.2] 保证：$n$ 个两两正交的非零向量自动线性无关，从而自动是基。标准正交基 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 满足

$$(\boldsymbol{q}_i,\boldsymbol{q}_j)=\delta_{ij}=\begin{cases}1,&i=j,\\0,&i\neq j,\end{cases}$$

其中 $\delta_{ij}$ 是 Kronecker 记号。

::: note

**注 6。**设 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 是 $V$ 的一组**基**，则它是标准正交基，当且仅当 $V$ 关于它的度量矩阵为单位矩阵：$G(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)=I_n$。在标准正交基下，内积的运算变得更加简单（见例 1.5.3）。（**前提不可省**：度量矩阵按 [@def-1.4.4] 只对**基**定义，所以「$G=I$」这句话本身已经假定了 $\boldsymbol{q}$ 组是基；若把 $G$ 推广到任意向量组，$\dim V>n$ 时 $G=I$ 不再蕴含「是基」。课件的注编号有重复，本教程按出现顺序重排，详见勘误 E8。）

:::

::: ex 例 1.5.2 · 光滑函数空间与三角函数系：正交不等于代数基 {#ex-1.5.2}

考查定义在 $[-\pi,\pi]$ 的光滑函数空间 $S$，定义内积为 $\forall f(t),g(t)\in S$，

$$(f,g)=\int_{-\pi}^{\pi}f(t)g(t)\,\mathrm dt.$$

证明三角函数组 $1,\ \cos t,\ \sin t,\ \cdots,\ \cos kt,\ \sin kt,\ \cdots$ 是正交向量组，并辨析课件把它称为线性空间 $S$ 的「正交基」时省略了什么前提。

::: sol 解答

内积合法性（对称、线性、正定）与 [@ex-1.4.B] 完全同理。逐类验证正交性——被积函数的奇偶性与积化和差使积分直接为零：

- 与常数 $1$ 正交：$k\geq1$ 时 $\displaystyle\int_{-\pi}^{\pi}\cos kt\,\mathrm dt=\int_{-\pi}^{\pi}\sin kt\,\mathrm dt=0$（整周期积分；$\sin kt$ 还是奇函数）；
- $\sin$ 与 $\cos$ 交叉：$\displaystyle\int_{-\pi}^{\pi}\sin mt\cos nt\,\mathrm dt=0$（对任意 $m,n$：被积函数是奇函数，对称区间积分自动为零）；
- 同类不同频（$m\neq n$）：积化和差把 $\cos mt\cos nt$、$\sin mt\sin nt$ 化为 $\tfrac12\big[\cos(m-n)t\pm\cos(m+n)t\big]$，而 $\int_{-\pi}^{\pi}\cos lt\,\mathrm dt=0$（$l\neq0$ 整数），故两个积分都为零。

各向量的长度平方为：$(1,1)=2\pi$，$(\cos kt,\cos kt)=(\sin kt,\sin kt)=\pi$。于是三角函数系两两正交、每个函数都非零，确实构成一个**正交向量组**。

但按本章[@def-1.3.3] 的代数定义，「基」要求每个向量都能写成基向量的**有限**线性组合。三角函数系的有限线性组合只是三角多项式，不能覆盖所有光滑函数；因此它不是光滑函数空间 $S$ 的 Hamel 基。傅里叶分析中常说的「正交基」，实际指在 $L^2[-\pi,\pi]$ 的范数与收敛意义下的**完备正交系**：允许用无穷级数逼近或表示函数。这需要先给空间规定范数、极限和完备性，已经超出本章的纯代数框架。

::: note 这一段可以稍后再读

上面这段辨析用到了「范数、极限、完备性、$L^2$」等后续课程的概念。**它不属于本章的考核范围**——现在只需记住结论：「代数基（有限组合）」与「完备正交系（无穷级数）」是两件事，课件把它们混用了（勘误 E10）。等学过函数分析或傅里叶分析后回来重读，这一段会变得完全透明。
:::

在满足相应收敛条件时，光滑函数 $f(t)$ 的傅里叶级数写成

$$f(t)=\frac{a_0}{2}+\sum_{n=1}^{\infty}\big(a_n\cos nt+b_n\sin nt\big)\qquad\text{（傅里叶三角级数）},$$

各系数由「与对应的正交函数作内积、再除以该函数自身的长度平方」得到。这与有限维正交基求坐标的公式同构，但无穷级数还多了一道必须单独处理的**收敛问题**。

:::

:::

::: errata 勘误 E10 · 「正交向量组」不能直接升级为「光滑函数空间的基」

课件把上述三角函数系称为光滑函数空间 $S$ 的正交基。按本章的 Hamel 基定义，这不成立：有限线性组合只能得到三角多项式。若要使用傅里叶分析中的「正交基」说法，应把空间与拓扑语境改为 $L^2[-\pi,\pi]$，并说明这里的「基」是完备正交系，展开按 $L^2$ 范数收敛。正文已将「代数基」和「完备正交系」分开陈述。

:::

::: preview 课程预告 · 傅里叶系数

用 $\cos nt$、$\sin nt$ 与展开式两边作内积，正交性使无穷多项里只剩一项，立刻得到

$$a_n=\frac{(f,\cos nt)}{\pi}=\frac{1}{\pi}\int_{-\pi}^{\pi}f(t)\cos nt\,\mathrm dt,\qquad
b_n=\frac{(f,\sin nt)}{\pi}=\frac{1}{\pi}\int_{-\pi}^{\pi}f(t)\sin nt\,\mathrm dt,\qquad
a_0=\frac{(f,1)}{\pi}.$$

「正交系 + 内积 = 广义坐标」这套机制从 $\mathbb R^n$ 搬到了函数空间，这正是傅里叶分析的起点。有限维里求和总会停止；函数空间里通常出现无穷级数，因此「能否展开、以什么方式收敛、极限是否仍在空间中」都成为新问题。它们属于后续的函数分析或傅里叶分析课程。

:::

最后回到有限维，看标准正交基在内积计算上究竟省掉了哪一步：

::: ex 例 1.5.3 · 标准正交基下的内积公式 {#ex-1.5.3}

设 $\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n$ 是线性空间 $V$ 的标准正交基，$\boldsymbol{\alpha}$ 和 $\boldsymbol{\beta}$ 分别是 $V$ 中向量 $\boldsymbol{x}$ 和 $\boldsymbol{y}$ 在该基下的坐标。证明：

$$(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\beta}^{\mathrm H}G(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)\boldsymbol{\alpha}=\boldsymbol{\beta}^{\mathrm H}\boldsymbol{\alpha}.$$

::: sol 解答

这是 [@def-1.4.4] 坐标公式 $(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm H}G_{\mathcal E}\boldsymbol{\xi}$ 的特例：标准正交基满足 $(\boldsymbol{q}_i,\boldsymbol{q}_j)=\delta_{ij}$，故度量矩阵的每个元素恰按 $I_n$ 摆放，$G(\boldsymbol{q}_1,\cdots,\boldsymbol{q}_n)=I_n$，于是

$$(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\beta}^{\mathrm H}\boldsymbol{\alpha}=\sum_{i=1}^{n}\alpha_i\overline{\beta_i}.$$

**标准正交基把任意（实 / 复）内积空间的内积运算，变成坐标向量的标准内积**——长度与正交的判定全部可以在 $\mathbb C^n$ 里完成（夹角只对实空间有定义，见勘误 E6）。1.4 节引入的「度量矩阵」在此兑现：它一般不是 $I$，但 Gram–Schmidt 正交化保证**总能换到一组使它是 $I$ 的基**。

:::

:::

<a id="sec-1.5.8"></a>

## 1.5.8 小结与常见错误

下表把本节的对象与易错点放在一起对照：第三列几乎覆盖了本节的全部勘误，值得逐条读一遍。

| 核心对象 | 必须记住 | 高频错误 |
|:--|:--|:--|
| 长度 $\|\boldsymbol{x}\|$ | $\sqrt{(\boldsymbol{x},\boldsymbol{x})}$；齐次性取 $|k|$ | 复向量长度用 $x_i^2$ 而非 $|x_i|^2$ 求和 |
| C-S 不等式 | $|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$，等号 ⟺ 相关（实、复空间都成立） | 等号条件漏掉**模**（写成 $(\boldsymbol{x},\boldsymbol{y})=\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 会把 $y=-x$ 判错）；先证三角不等式后证 C-S（顺序颠倒，勘误 E5） |
| 夹角 | $\arccos\dfrac{(\boldsymbol{x},\boldsymbol{y})}{\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|}$ 限**实**空间 | 在复空间直接套 arccos（勘误 E6） |
| Gram 行列式 | $=\|\boldsymbol{x}_1\|^2\|\boldsymbol{x}_2\|^2-\big|(\boldsymbol{x}_1,\boldsymbol{x}_2)\big|^2$ = 面积² | 复情形把模平方写成平方（见 [1.5.4](sec15.md#sec-1.5.4) 的推广注） |
| 正交 | $(\boldsymbol{x},\boldsymbol{y})=0$；正交组必无关 | 把「零向量与一切都正交」当成正交组成员；复空间勾股「当且仅当」误用（勘误 E7） |
| Gram–Schmidt | $\boldsymbol{y}_k=\boldsymbol{x}_k-\sum\dfrac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\boldsymbol{y}_i$ | 减错方向（拿 $\boldsymbol{x}_i$ 当被投影对象）；忘记单位化才能得「标准」正交基 |
| 标准正交基 | $G=I$，$(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\beta}^{\mathrm H}\boldsymbol{\alpha}$ | 在一般基下直接用 $\boldsymbol{\beta}^{\mathrm H}\boldsymbol{\alpha}$ 算内积（漏乘 $G$） |

**本节主线：**内积给出长度；C-S 不等式把「内积的大小」钉死在「长度的乘积」之内，三角不等式与夹角定义随之落地；正交是夹角的极端情形，正交组自动无关；Gram–Schmidt 把任意基改造成正交基，单位化后度量矩阵成为 $I$——一切内积计算退化为坐标的标准内积。

::: method 即时自测 · 1.5

本节最容易失分的地方：**复空间与实空间的差别**（C-S 必须带模、夹角公式只限实空间、勾股逆命题在复空间失效）与 **Gram–Schmidt 的公式细节**。

::: hint 第 1 题 · 记忆

写出长度的定义与**四条**性质（正定、齐次、平行四边形法则、三角不等式）。齐次性里为什么是 $|k|$ 而不是 $k$？（对应 [1.5.1](sec15.md#sec-1.5.1)）
:::

::: sol 第 1 题答案

$\|\boldsymbol{x}\|=\sqrt{(\boldsymbol{x},\boldsymbol{x})}$；(1) $\|\boldsymbol{x}\|\geq0$ 且 $=0\Longleftrightarrow\boldsymbol{x}=\boldsymbol{\theta}$；(2) $\|k\boldsymbol{x}\|=|k|\|\boldsymbol{x}\|$；(3) $\|\boldsymbol{x}+\boldsymbol{y}\|^2+\|\boldsymbol{x}-\boldsymbol{y}\|^2=2(\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2)$；(4) $\|\boldsymbol{x}+\boldsymbol{y}\|\leq\|\boldsymbol{x}\|+\|\boldsymbol{y}\|$（证明见 [1.5.2](sec15.md#sec-1.5.2)）。

齐次性推导 $\|k\boldsymbol{x}\|^2=k\overline{k}(\boldsymbol{x},\boldsymbol{x})=|k|^2\|\boldsymbol{x}\|^2$：复空间中 $k$ 是复数，$k^2$ 可能是负数或复数，只有 $|k|^2= k\overline{k}$ 保证非负实数，开方后得到 $|k|$。
:::

::: hint 第 2 题 · 证明

完整证明 Cauchy–Schwarz 不等式，并说明证明中 $\lambda$ 的选取有什么几何含义。等号何时成立？（对应 [1.5.2](sec15.md#sec-1.5.2)）
:::

::: sol 第 2 题答案

$\boldsymbol{y}\neq\boldsymbol{\theta}$ 时对 $0\leq(\boldsymbol{x}-\lambda\boldsymbol{y},\boldsymbol{x}-\lambda\boldsymbol{y})$ 取 $\lambda=\frac{(\boldsymbol{x},\boldsymbol{y})}{(\boldsymbol{y},\boldsymbol{y})}$，展开得 $(\boldsymbol{x},\boldsymbol{x})-\lambda(y,x)-\overline{\lambda}(x,y)+|\lambda|^2(\boldsymbol{y},\boldsymbol{y})$；三项合并为 $-\frac{|(\boldsymbol{x},\boldsymbol{y})|^2}{(\boldsymbol{y},\boldsymbol{y})}$（**两项带负号、一项带正号**：$\overline{\lambda}(\boldsymbol{x},\boldsymbol{y})$ 与 $\lambda(\boldsymbol{y},\boldsymbol{x})$ 各贡献 $-\frac{|(\boldsymbol{x},\boldsymbol{y})|^2}{(\boldsymbol{y},\boldsymbol{y})}$，$|\lambda|^2(\boldsymbol{y},\boldsymbol{y})$ 贡献 $+\frac{|(\boldsymbol{x},\boldsymbol{y})|^2}{(\boldsymbol{y},\boldsymbol{y})}$），于是

$$0\leq(\boldsymbol{x},\boldsymbol{x})-\frac{|(\boldsymbol{x},\boldsymbol{y})|^2}{(\boldsymbol{y},\boldsymbol{y})}\quad\Longrightarrow\quad(\boldsymbol{x},\boldsymbol{x})\geq\frac{|(\boldsymbol{x},\boldsymbol{y})|^2}{(\boldsymbol{y},\boldsymbol{y})}.$$

几何含义：这个 $\lambda$ 恰好使残差 $\boldsymbol{x}-\lambda\boldsymbol{y}$ 与 $\boldsymbol{y}$ 正交（$(\boldsymbol{x}-\lambda\boldsymbol{y},\boldsymbol{y})=0$）——「减掉沿 $\boldsymbol{y}$ 的成分」。等号成立 ⟺ 残差为零 ⟺ $\boldsymbol{x}=\lambda\boldsymbol{y}$ ⟺ 线性相关。
:::

::: hint 第 3 题 · 应用

对 $\boldsymbol{x}_1=(1,1,0)^{\mathrm T}$、$\boldsymbol{x}_2=(1,0,1)^{\mathrm T}$、$\boldsymbol{x}_3=(0,1,1)^{\mathrm T}$ 执行 Gram–Schmidt，并把结果单位化。（对应 [1.5.6](sec15.md#sec-1.5.6)）
:::

::: sol 第 3 题答案

$\boldsymbol{y}_1=(1,1,0)^{\mathrm T}$；$\boldsymbol{y}_2=(\tfrac12,-\tfrac12,1)^{\mathrm T}$；$\boldsymbol{y}_3=(-\tfrac23,\tfrac23,\tfrac23)^{\mathrm T}$（计算过程见 [@ex-1.5.B]）。单位化：

$\boldsymbol{q}_1=\tfrac{1}{\sqrt2}(1,1,0)^{\mathrm T}$，$\boldsymbol{q}_2=\tfrac{1}{\sqrt6}(1,-1,2)^{\mathrm T}$，$\boldsymbol{q}_3=\tfrac{1}{\sqrt3}(-1,1,1)^{\mathrm T}$。

自检：三个向量长度均为 $1$，两两内积为 $0$；行列式 $\det(\boldsymbol{q}_1,\boldsymbol{q}_2,\boldsymbol{q}_3)$ 应为 $\pm1$（正交矩阵的行列式）。
:::

::: hint 第 4 题 · 辨析

标准正交基下度量矩阵是什么？此时 $(\boldsymbol{x},\boldsymbol{y})$ 的坐标公式如何退化？「夹角」「勾股定理的当且仅当」各在什么空间里成立？（对应 [1.5.7](sec15.md#sec-1.5.7)、勘误 E6 / E7）
:::

::: sol 第 4 题答案

$G=I_n$（$(\boldsymbol{q}_i,\boldsymbol{q}_j)=\delta_{ij}$ 恰按单位矩阵摆放），于是 $(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\beta}^{\mathrm H}\boldsymbol{\alpha}=\sum_i\alpha_i\overline{\beta_i}$——任意内积空间的计算退化为 $\mathbb C^n$ 的标准内积。

夹角公式（arccos）与「正交 ⟺ 勾股等式」的**当且仅当**都只在**实**内积空间成立；复空间中：正交 ⟹ 勾股成立，反之不然（反例 $x=1,y=i$：勾股成立但 $(x,y)=-i\neq0$）。
:::

:::
