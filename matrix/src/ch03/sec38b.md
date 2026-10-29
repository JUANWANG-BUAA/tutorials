# 3.8 Jordan 分解（下）· Smith 标准形与 Jordan 标准形

[3.8 上半](sec38.md)把 $\lambda$ 矩阵的「零件」摆齐了：秩看子式、可逆看行列式是否为非零常数、初等变换可逆且保秩。但零件本身还不构成答案——上半页末尾留下一句话：**可逆的 $\lambda$ 矩阵总能化成 $I$，一般的能化成什么？**

这一页回答它。路线是一条完整的流水线：

$$\text{行列式因子 }D_k\ \longrightarrow\ \text{Smith 标准形}\ \longrightarrow\ \text{不变因子 }d_i\ \longrightarrow\ \text{初等因子}\ \longrightarrow\ \text{Jordan 块}\ \longrightarrow\ \text{Jordan 标准形}.$$

这条流水线的每一步都在做同一件事：**把「相差一个可逆因子」的自由度挤干净，只留下相似意义下真正不变的整数数据**。走到终点，Jordan 标准形就是「复方阵在相似意义下的最简阵」——除块的排列次序外，它由 $A$ 唯一决定。

<figure aria-labelledby="fig-pipeline-caption" class="concept-figure" data-figure="FIG. 3–02">
<svg aria-labelledby="fig-pipeline-title fig-pipeline-desc" role="img" viewBox="0 0 680 306">
<title id="fig-pipeline-title">从 λ 矩阵到 Jordan 标准形的六步流水线</title>
<desc id="fig-pipeline-desc">第一行三步：取全部 k 阶子式的首 1 最大公因式得行列式因子；经初等变换化 Smith 标准形；作商得不变因子。第二行三步：把不变因子拆成素因子幂得初等因子；每个幂配一个同阶 Jordan 块；把块拼成分块对角阵。</desc>
<defs>
<marker id="pipe-arrow" markerHeight="7" markerWidth="7" orient="auto-start-reverse" refX="7.5" refY="4" viewBox="0 0 8 8"><path d="M0,0 L8,4 L0,8 Z" fill="var(--line-strong)"></path></marker>
</defs>
<text class="diagram-mono" x="30" y="26">上半场 · 多项式的账</text>
<rect fill="var(--fig-blue)" height="84" opacity="0.10" rx="8" width="190" x="30" y="38"></rect>
<text class="diagram-text" x="45" y="64">① 行列式因子</text>
<text class="diagram-note" x="45" y="84">D_k = 全部 k 阶子式的</text>
<text class="diagram-note" x="45" y="101">首 1 最大公因式</text>
<line marker-end="url(#pipe-arrow)" stroke="var(--line-strong)" stroke-width="1.4" x1="226" x2="250" y1="80" y2="80"></line>
<rect fill="var(--fig-purple)" height="84" opacity="0.10" rx="8" width="190" x="254" y="38"></rect>
<text class="diagram-text" x="269" y="64">② Smith 标准形</text>
<text class="diagram-note" x="269" y="84">初等变换 ⇒ 对角形</text>
<text class="diagram-note" x="269" y="101">diag(d₁,…,d_r, 0)</text>
<line marker-end="url(#pipe-arrow)" stroke="var(--line-strong)" stroke-width="1.4" x1="450" x2="474" y1="80" y2="80"></line>
<rect fill="var(--fig-green)" height="84" opacity="0.12" rx="8" width="176" x="478" y="38"></rect>
<text class="diagram-text" x="493" y="64">③ 不变因子 d_i</text>
<text class="diagram-note" x="493" y="84">作商 d_k = D_k / D_{k−1}</text>
<text class="diagram-note" x="493" y="101">首 1，且 d₁ | d₂ | ⋯</text>
<path d="M566,126 L566,152" fill="none" marker-end="url(#pipe-arrow)" stroke="var(--line-strong)" stroke-width="1.4"></path>
<text class="diagram-mono" x="576" y="145">拆</text>
<rect fill="var(--fig-green)" height="84" opacity="0.12" rx="8" width="176" x="478" y="156"></rect>
<text class="diagram-text" x="493" y="182">④ 初等因子（组）</text>
<text class="diagram-note" x="493" y="202">把每个 d_i 拆成</text>
<text class="diagram-note" x="493" y="219">素因子幂，重复计数</text>
<line marker-end="url(#pipe-arrow)" stroke="var(--line-strong)" stroke-width="1.4" x1="474" x2="450" y1="198" y2="198"></line>
<rect fill="var(--fig-gold)" height="84" opacity="0.12" rx="8" width="190" x="254" y="156"></rect>
<text class="diagram-text" x="269" y="182">⑤ Jordan 块</text>
<text class="diagram-note" x="269" y="202">一个幂 (λ−λ₀)^s</text>
<text class="diagram-note" x="269" y="219">⇔ 一个 s 阶块 J_s(λ₀)</text>
<line marker-end="url(#pipe-arrow)" stroke="var(--line-strong)" stroke-width="1.4" x1="250" x2="226" y1="198" y2="198"></line>
<rect fill="var(--fig-red)" height="84" opacity="0.10" rx="8" width="190" x="30" y="156"></rect>
<text class="diagram-text" x="45" y="182">⑥ Jordan 标准形</text>
<text class="diagram-note" x="45" y="202">J = diag(J₁,…,J_s)</text>
<text class="diagram-note" x="45" y="219">除块次序外唯一</text>
<text class="diagram-mono" x="30" y="272">下半场 · 把账翻成形状</text>
<text class="diagram-note" x="30" y="294">两组数据都可逆地互推：①⇄③（前缀积与差商）；④⇄⑤⇄⑥（幂与块一一对应）。</text>
</svg>
<figcaption id="fig-pipeline-caption"><b>一条流水线，两个半场。</b>上半场（①②③）把 $\lambda$ 矩阵压成一串多项式不变量，只用初等变换与整除，不涉及任何「基」；下半场（④⑤⑥）把这串多项式翻译成分块对角阵。真正携带全部信息的是<b>不变因子</b>；<b>初等因子</b>只比它少一个「秩」。</figcaption>
</figure>

::: method 读这一页的路线：三种读法，按你的目标选 {#method-3.8-lower-route}

**① 只想知道「怎么算」（考试最快）**：跳过所有证明，只走
[3.8.6](#sec-3.8.6b) 的 [@method-3.8-smith]（三条求 Smith 形的路线）→ [3.8.7](#sec-3.8.7b) 的 [@note-3.8-assemble]（反装不变因子）→ [3.8.10](#sec-3.8.10b) 的 [@method-3.8-jordan]（两条求 Jordan 形的路线）。三张方法卡串起来就是一条完整的计算流水线，**本页开头的流水线图就是它的地图**。

**② 想弄懂「为什么能这么算」（理解向）**：按正文顺序读，重点看五个「本编补」——Smith 存在性（[3.8.6](#sec-3.8.6b)）、Smith 唯一性（[3.8.7](#sec-3.8.7b)）、初等因子 $+$ 秩是完全不变量（[3.8.8](#sec-3.8.8b)）、相似 $\iff$ 特征矩阵相抵（[3.8.9](#sec-3.8.9b)）、Jordan 存在性与 Frobenius（[3.8.10](#sec-3.8.10b)）。这五处课件全部只给结论。

**③ 只想复习（考前 10 分钟）**：直接跳到 [3.8.11](#sec-3.8.11b) 的 [@note-3.8-data-table]（五种多项式数据对照表）、[三句话](#note-3.8-three-takeaways)、[常见错误七条](#think-3.8-mistakes)，再动手走一遍末尾的 [Smith → Jordan 部件](#sec-3.8.11b)。

**三者的关系**：①是②的算法摘要，②是①的合法性来源，③是两者的压缩包。**只背①会在「对角阵 ≠ Smith 形」这种地方翻车；只读②会在考场上来不及写完。**
:::

::: note 素材与说明（本节无录播）

本页依据课程第三章课件 **3.8 Jordan 分解** 的后半部分（`_sources/matrix/3.8-Jordan分解.pdf` 第 15–50 页，共 50 页；上半页用的是同批的前 14 页）整理。**本节无对应录播**，故不引用课堂口述与时间戳：课件的定义、定理、推论、注记与例题**照录并保留原编号**（定义 3.8.5–3.8.10、定理 3.8.2–3.8.6、推论 3.8.1–3.8.4、注 5–注 10、例 3.8.4 续至例 3.8.13）。

四件事先交代清楚：

- **补全证明**：课件对 Smith 标准形的存在性、唯一性、相抵判别、相似判别、Jordan 标准形定理与 Frobenius 定理都只给结论或骨架，本页逐条补出完整证明并标注「本编补」；
- **编号处理**：课件有**两处都编「定理 3.8.5」**（相似判别、Jordan 标准形定理）与**两处都编「例 3.8.8」**（相抵反例、Jordan 块不单纯），本页把后一处分别记为「定理 3.8.5′」「例 3.8.8′」，详见[勘误 E3.13](errata.md#errata-3.8)；
- **可视化**：本页配三张图解——六步流水线总览（本页开头的图）、Smith 形的「塔形」与整除链、Jordan 块的断点判定；末尾配一个可点击的「λ 矩阵 → Smith 形 → 初等因子 → Jordan 形」步进部件，三个预置矩阵各埋一个坑（[3.8.11](#sec-3.8.11b)）。图形纯 SVG/CSS，暗色主题与打印自动跟随，不依赖任何外部资源；
- **新增例题**：本编新增例 3.8.D–3.8.G（[Smith 标准形直接计算](#ex-3.8.D)、[初等因子反装不变因子](#ex-3.8.E)、[秩公式求 Jordan 形与 $P$](#ex-3.8.F)、[Jordan 形算幂与矩阵指数](#ex-3.8.G)），全部经 `tools/verify_teaching_examples.py` 以多项式系数精确算术复算。
:::

<a id="sec-3.8.5b"></a>

## 3.8.5 行列式因子：从子式里读出「公因子」

上半页说 $\lambda$ 矩阵的秩是「存在不恒为零的 $r$ 阶子式」的最大 $r$。但秩只记了**有没有**非零子式，没记这些子式**长什么样**。要读出更细的信息，就把所有 $k$ 阶子式放在一起，取它们的公因子。

::: def 定义 3.8.5 · $k$ 阶行列式因子 {#def-3.8.5}

设 $\lambda$ 矩阵 $A(\lambda)$ 的秩为 $r$。对于正整数 $1\le k\le r$，$A(\lambda)$ 的**全部 $k$ 阶子式的首 $1$ 最大公因式**称为 $k$ 阶**行列式因子**，记为 $D_k(\lambda)$。
:::

「首 $1$」是一个规范化约定：多项式环里最大公因式只在差一个非零常数倍的意义下唯一，把首项系数规定为 $1$，$D_k$ 就唯一了。这与 [3.8.6](#sec-3.8.6b) 里 Smith 标准形要求 $d_i$ 首 $1$ 是同一套约定。

::: ex 例 3.8.4（课件原文）· 各阶行列式因子 {#ex-3.8.4}

求

$$A(\lambda)=\begin{bmatrix}1-\lambda&\lambda^2&\lambda\\ \lambda&\lambda&-\lambda\\ 1+\lambda^2&\lambda^2&-\lambda^2\end{bmatrix}$$

各阶行列式因子。

::: sol 解答（课件原文）

一阶子式共有 $9$ 个，经计算得 $D_1(\lambda)=1$；

二阶子式共有 $9$ 个，经计算得 $D_2(\lambda)=\lambda$；

$$D_3(\lambda)=|A(\lambda)|=\lambda^3+\lambda^2. \qquad\blacksquare$$
:::
:::

::: note 本编注 · 为什么 $D_1=1$ 而 $D_2=\lambda$ {#note-3.8-d1}

$D_1$ 是全部 $9$ 个**元素**的首 $1$ 最大公因式。矩阵里有 $1-\lambda$、$\lambda$、$1+\lambda^2$ 这些互素的多项式（例如 $\lambda$ 与 $1-\lambda$ 的最大公因式为 $1$），所以 $D_1=1$。

$D_2$ 是全部 $9$ 个二阶子式的公因式。有些二阶子式含因子 $\lambda$（例如左上角 $\begin{bmatrix}1-\lambda&\lambda^2\\ \lambda&\lambda\end{bmatrix}$ 的行列式 $\lambda(1-\lambda)-\lambda^3$），而所有二阶子式恰好都被 $\lambda$ 整除——这就是「$D_2=\lambda$」的信息：**二阶子式全体有一个共同的零点 $\lambda=0$**。

$D_3$ 只有一个子式，就是行列式本身，$\lambda^3+\lambda^2=\lambda^2(\lambda+1)$。注意 $D_2=\lambda$ 整除 $D_3=\lambda^2(\lambda+1)$——这不是巧合，而是 [3.8.6](#sec-3.8.6b) 的核心事实。
:::

::: note 本编注 · 行列式因子的三条基本性质 {#note-3.8-dk-props}

设 $A(\lambda)$ 的秩为 $r$，则：

1. **整除链**：$D_1\mid D_2\mid\cdots\mid D_r$；
2. **末项是行列式**：$D_r(\lambda)=\big|A(\lambda)\big|$（若 $A$ 是 $n$ 阶方阵且 $r=n$）；
3. **初等变换不变**：$D_k$ 在初等变换下不变（证明见 [@cor-3.8.1]）。

第 1 条的理由（本编补）：把任一 $k$ 阶子式按第一行展开，

$$M_k=\sum_{j=1}^{k}(-1)^{1+j}a_{1j}M_{k-1}^{(j)},$$

每个 $M_{k-1}^{(j)}$ 都是 $A(\lambda)$ 的 $k-1$ 阶子式，故都被 $D_{k-1}$ 整除；于是 $D_{k-1}$ 整除**每一个** $k$ 阶子式，当然整除它们的首 $1$ 最大公因式 $D_k$。第 2 条只在 $A$ 为 $n$ 阶方阵且秩为 $n$ 时成立——此时 $n$ 阶子式只有一个，就是行列式（见 [@note-3.8-d3-zero] 对「$D_3=0$」的辨析）。第 3 条是 [@cor-3.8.1] 的证明核心。三条合起来，就把「行列式因子」与「Smith 标准形」两条路线接上了：$D_k=d_1\cdots d_k$（[@note-3.8-dk-smith]）。
:::

::: ex 例 3.8.D（新增）· 用行列式因子法算 Smith 标准形 {#ex-3.8.D}

求

$$A(\lambda)=\begin{bmatrix}\lambda&1&1\\ 1&\lambda&1\\ 1&1&\lambda\end{bmatrix}$$

的各阶行列式因子、不变因子与 Smith 标准形。

::: sol 解答

**一阶**：元素为 $\lambda,1,1,\dots$，其中 $1$ 是常数，故

$$D_1(\lambda)=1.$$

**二阶**：九个二阶子式分三类。

- 取第 $1,2$ 行：$\begin{vmatrix}\lambda&1\\1&\lambda\end{vmatrix}=\lambda^2-1$，$\begin{vmatrix}\lambda&1\\1&1\end{vmatrix}=\lambda-1$，$\begin{vmatrix}1&1\\\lambda&1\end{vmatrix}=1-\lambda$；
- 取第 $1,3$ 行：$\begin{vmatrix}\lambda&1\\1&\lambda\end{vmatrix}=\lambda^2-1$，$\begin{vmatrix}\lambda&1\\1&1\end{vmatrix}=\lambda-1$，$\begin{vmatrix}1&1\\1&\lambda\end{vmatrix}=\lambda-1$；
- 取第 $2,3$ 行：$\begin{vmatrix}1&\lambda\\1&1\end{vmatrix}=1-\lambda$，$\begin{vmatrix}1&1\\1&\lambda\end{vmatrix}=\lambda-1$，$\begin{vmatrix}\lambda&1\\1&\lambda\end{vmatrix}=\lambda^2-1$。

全体二阶子式的首 $1$ 最大公因式：$\lambda^2-1=(\lambda-1)(\lambda+1)$ 与 $\lambda-1$ 的最大公因式是 $\lambda-1$，且其余子式都是 $\pm(\lambda-1)$ 或 $\pm(\lambda^2-1)$，故

$$D_2(\lambda)=\lambda-1.$$

**三阶**：只有一个子式，

$$D_3(\lambda)=|A(\lambda)|=\lambda(\lambda^2-1)-1\cdot(\lambda-1)+1\cdot(1-\lambda)=\lambda^3-3\lambda+2=(\lambda-1)^2(\lambda+2).$$

于是不变因子为

$$d_1=D_1=1,\qquad d_2=\frac{D_2}{D_1}=\lambda-1,\qquad d_3=\frac{D_3}{D_2}=(\lambda-1)(\lambda+2).$$

Smith 标准形为

$$A(\lambda)\cong\operatorname{diag}\big(1,\ \lambda-1,\ (\lambda-1)(\lambda+2)\big).$$

**验算**：$d_1\mid d_2\mid d_3$ 成立（$1\mid\lambda-1\mid(\lambda-1)(\lambda+2)$）；三项乘积 $=(\lambda-1)^2(\lambda+2)=D_3$ ✓。∎
:::
:::

::: note 本编注 · 这个例子同时是一道「可对角化」题 {#note-3.8-d-example}

$A(\lambda)$ 恰好是 $A_0=\begin{bmatrix}0&-1&-1\\-1&0&-1\\-1&-1&0\end{bmatrix}$ 的特征矩阵 $\lambda I-A_0$。由上面的计算：

- 特征多项式 $f_{A_0}=D_3=(\lambda-1)^2(\lambda+2)$，特征值为 $1$（代数重数 $2$）与 $-2$（代数重数 $1$）；
- 最小多项式 $m_{A_0}=d_3=(\lambda-1)(\lambda+2)$（Frobenius 定理，见 [@thm-3.8.6]），**无重根**；
- 故由 [3.6.1](sec36.md#thm-3.6.1) 的（5）$\Rightarrow$（1），$A_0$ 可对角化，且 $A_0\sim\operatorname{diag}(1,1,-2)$。

这正是本节的用法：**一个 $3\times3$ 矩阵的可对角化问题，被压缩成「$d_3$ 有没有重根」这一句话**。第 3.8.9 节把这条判据写成推论。
:::

<a id="sec-3.8.6b"></a>

## 3.8.6 Smith 标准形：$\lambda$ 矩阵的相抵标准形

数字矩阵在相抵下的标准形是 $\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$（[3.1](sec31.md)）。$\lambda$ 矩阵在初等变换下也有标准形，但中间的对角元不是 $1$，而是一串**首 $1$、依次整除**的多项式。

::: thm 定理 3.8.2 · Smith 标准形 {#thm-3.8.2}

设 $\lambda$ 矩阵 $A(\lambda)$ 的秩为 $r$，则 $A(\lambda)$ 经有限次初等变换可化为

$$A(\lambda)\cong\begin{bmatrix}
d_1(\lambda)&&&\\
&\ddots&&0\\
&&d_r(\lambda)&\\
&0&&0
\end{bmatrix},$$

式中 $d_i(\lambda)$ 是**首 $1$ 多项式**，且 $d_1\mid d_2\mid\cdots\mid d_r$。此标准形称为 $A(\lambda)$ 的 **Smith 标准形**。
:::

::: note 注 5（课件原文）· 不一定是方阵 {#note-3.8-note5}

$A(\lambda)$ 不一定是方阵，故 Smith 标准形不一定是**对角阵**——它是对角形，但四条边上的零块尺寸由 $A(\lambda)$ 的行数、列数与秩共同决定。
:::

<figure aria-labelledby="fig-smith-wall-caption" class="concept-figure" data-figure="FIG. 3–03">
<svg aria-labelledby="fig-smith-wall-title fig-smith-wall-desc" role="img" viewBox="0 0 680 272">
<title id="fig-smith-wall-title">Smith 标准形的两条硬性要求，与「对角阵」的区别</title>
<desc id="fig-smith-wall-desc">左侧是错误做法：把元素直接摆到对角线上，各元素互不整除，只是一般的对角阵。右侧是 Smith 标准形：对角元首 1 且依次整除，形如层层堆叠的塔，信息全部压在右下角。</desc>
<text class="diagram-mono" x="26" y="22">不是 Smith 形 · 只是对角</text>
<rect fill="var(--fig-red)" height="116" opacity="0.08" rx="8" width="252" x="26" y="32"></rect>
<text class="diagram-text" x="42" y="56">diag(λ−1, λ−2, λ−3)</text>
<text class="diagram-note" x="42" y="80">✓ 首 1</text>
<text class="diagram-note" x="42" y="100">✗ 前一个不整除后一个</text>
<text class="diagram-note" x="42" y="120">⇒ 不满足整除链</text>
<line marker-end="url(#pipe-arrow)" stroke="var(--line-strong)" stroke-width="1.4" x1="284" x2="318" y1="88" y2="88"></line>
<text class="diagram-mono" x="286" y="74">初等变换</text>
<text class="diagram-mono" x="342" y="22">Smith 标准形 · 塔形</text>
<rect fill="var(--fig-green)" height="26" opacity="0.16" rx="4" width="56" x="342" y="32"></rect>
<text class="diagram-text" x="406" y="51">d₁ = 1</text>
<rect fill="var(--fig-green)" height="26" opacity="0.26" rx="4" width="126" x="342" y="60"></rect>
<text class="diagram-text" x="476" y="79">d₂ = λ−2</text>
<rect fill="var(--fig-green)" height="26" opacity="0.38" rx="4" width="196" x="342" y="88"></rect>
<text class="diagram-text" x="546" y="107">d₃ = (λ−2)²(λ−3)</text>
<text class="diagram-note" x="342" y="136">每个都整除下一个（塔只增不减）</text>
<text class="diagram-mono" x="26" y="180">为什么整除链必须成立</text>
<text class="diagram-note" x="26" y="202">清空第 1 行第 1 列时，若左下块有元素不被左上元整除，</text>
<text class="diagram-note" x="26" y="222">带余除法就会造出次数更低的非零元素，逼你把左上元换小；</text>
<text class="diagram-note" x="26" y="242">化到不能再化时，右下块必被它整除。归纳即得整条整除链。</text>
</svg>
<figcaption id="fig-smith-wall-caption"><b>「对角」不等于「标准形」。</b>Smith 标准形是两个条件同时成立：每个对角元首 $1$，且<b>前一个整除后一个</b>。第二个条件把整理工作全推向右下角——于是 $d_r$ 总是最长的那一个，$m_A=d_n$ 这条定理才成立。</figcaption>
</figure>

::: ex 例 3.8.4 续（课件原文）· Smith 标准形 {#ex-3.8.4b}

求上例 $A(\lambda)$ 的 Smith 标准形。

::: sol 解答（课件原文；本编补每步的读法）

采用初等变换法：

$$\begin{aligned}
A(\lambda)&\xrightarrow{C_1+C_3}
\begin{bmatrix}1&\lambda^2&\lambda\\0&\lambda&-\lambda\\1&\lambda^2&-\lambda^2\end{bmatrix}
\xrightarrow{C_2-\lambda^2C_1}
\begin{bmatrix}1&0&\lambda\\0&\lambda&-\lambda\\1&0&-\lambda^2\end{bmatrix}\\
&\xrightarrow{C_3-\lambda C_1}
\begin{bmatrix}1&0&0\\0&\lambda&-\lambda\\1&0&-\lambda^2-\lambda\end{bmatrix}
\xrightarrow{R_3-R_1}
\begin{bmatrix}1&0&0\\0&\lambda&-\lambda\\0&0&-\lambda^2-\lambda\end{bmatrix}\\
&\xrightarrow{C_3+C_2}
\begin{bmatrix}1&0&0\\0&\lambda&0\\0&0&-\lambda^2-\lambda\end{bmatrix}
\xrightarrow{C_3(-1)}
\begin{bmatrix}1&0&0\\0&\lambda&0\\0&0&\lambda^2+\lambda\end{bmatrix}.
\end{aligned}$$

于是 $D_1=1$、$D_2=\lambda$、$D_3=\lambda^3+\lambda^2$，与例 3.8.4 直接算子式的结果一致。∎
:::
:::

::: note 本编注 · 第一步为什么能「造出 $1$」 {#note-3.8-make-one}

第一列是 $(1-\lambda,\ \lambda,\ 1+\lambda^2)^{\mathrm T}$，第一行第三元是 $\lambda$。把第 $3$ 列加到第 $1$ 列，$(1,1)$ 元变成

$$(1-\lambda)+\lambda=1.$$

这就是「**造 $1$**」：只要一列（或一行）里有两个元素之和是常数，一次第三种列变换就能把常数搬到左上角。一旦左上角是 $1$，它整除任何多项式，就可以放心地用它清空第一行和第一列——不会出现「除不尽」的麻烦。

一般情形没有这么幸运。下面是存在性证明，它说明了「除不尽时怎么办」。
:::

::: proof 证明（定理 3.8.2；本编补）

对矩阵的阶数（更准确地说，对非零元素的个数与次数）作归纳。若 $A(\lambda)=0$，取 $r=0$，结论平凡。否则设 $A(\lambda)\ne0$。

**第一步：把次数最低的非零元素搬到左上角。** 在所有非零元素中取一个次数最小者，经行、列互换（第 1 种初等变换）把它移到 $(1,1)$ 位置。以下记 $a=a_{11}(\lambda)$。

**第二步：$a$ 整除第一行与第一列的所有元素。** 设第一行有元素 $b=a_{1j}$ 不被 $a$ 整除。作带余除法

$$b=qa+s,\qquad \deg s\lt\deg a,\quad s\ne0.$$

对第 $j$ 列作变换 $C_j\leftarrow C_j-qC_1$，则 $(1,j)$ 元变为

$$b-q\cdot a=s,$$

而 $(1,1)$ 元不变。于是矩阵中出现了一个次数比 $a$ **更低**的非零元素 $s$，与 $a$ 的「次数最小」矛盾。故 $a$ 整除第一行的每个元素；同理整除第一列的每个元素。

**第三步：清空第一行与第一列。** 既然 $a\mid a_{1j}$、$a\mid a_{i1}$，乘子 $a_{1j}/a$、$a_{i1}/a$ 都是多项式，用第三种初等变换即可把第一行、第一列除 $(1,1)$ 外全部化为零：

$$\begin{bmatrix}a&0\\0&A_1(\lambda)\end{bmatrix}.$$

**第四步：$a$ 整除 $A_1$ 的每个元素。** 若某个 $a_{ij}$（$i,j\ge2$）不被 $a$ 整除，把第 $i$ 行加到第 $1$ 行，则新的 $(1,j)$ 元就是 $a_{ij}$（因为原 $(1,j)$ 元已为 $0$），于是回到第二步的情形：可作出一个次数更低的非零元素，矛盾。故 $a$ 整除 $A_1$ 的全部元素。

**第五步：归纳。** $A_1$ 的元素都是 $a$ 的倍式，对 $A_1$ 重复上述过程得 $\operatorname{diag}(a,a_2,\dots)$，且 $a\mid a_2$。由归纳假设 $A_1$ 可化为 Smith 形 $\operatorname{diag}(d_2,\dots,d_r)$，且每个 $d_i$ 都是 $a$ 的倍式（因为初等变换不改变「元素都是 $a$ 的倍式」这一性质），故 $a\mid d_2$。把 $a$ 首 $1$ 化（除以它的首项系数，这是第 2 种初等变换，乘子是非零常数），即得 $d_1=a$ 与 $d_1\mid d_2\mid\cdots\mid d_r$。$\blacksquare$
:::

::: note 本编注 · 两条路线的桥：$D_k=d_1\cdots d_k$ {#note-3.8-dk-smith}

在 Smith 标准形上直接算行列式因子：$\operatorname{diag}(d_1,\dots,d_r)$ 的 $k$ 阶子式，要么含零行（为零），要么是 $k$ 个对角元的乘积。全部 $k$ 阶子式的首 $1$ 最大公因式就是 $d_1d_2\cdots d_k$（因为 $d_1\mid\cdots\mid d_k$，最小的那个乘积 $d_1\cdots d_k$ 整除其余所有乘积）。所以

$$D_k(\lambda)=d_1(\lambda)d_2(\lambda)\cdots d_k(\lambda),\qquad
d_k(\lambda)=\frac{D_k(\lambda)}{D_{k-1}(\lambda)}\quad(D_0=1).$$

这两行是**双向**的：由 $D_k$ 可以算 $d_k$，由 $d_k$ 可以算 $D_k$。它同时给出两件事：

- **Smith 标准形的唯一性**：$D_k$ 由 $A(\lambda)$ 本身（与初等变换无关）决定，故 $d_k$ 也被唯一决定；
- **两条计算路线**：直接算子式求 $D_k$（适合小矩阵），或作初等变换化成对角形再读 $d_k$（适合结构清晰的矩阵）。
:::

::: method 方法 · 求 Smith 标准形的三条路线 {#method-3.8-smith}

**路线 1（初等变换法）**：把 $A(\lambda)$ 当普通矩阵消元，但乘子必须是多项式。

1. 在非零元素中挑**次数最低**者，换到 $(1,1)$；
2. 用它清空第一行、第一列——**只有当它整除该行该列的元素时才能直接除**；除不尽就作带余除法 $b=qa+s$，用 $C_j-qC_1$ 把余式 $s$ 造出来，再换到 $(1,1)$，重复；
3. 若 $(1,1)$ 不整除右下块某个元素，把这个元素所在行加到第 $1$ 行，回到第 2 步；
4. 对右下块递归。

**路线 2（行列式因子法）**：算 $D_1,\dots,D_r$（$D_k=$ 全部 $k$ 阶子式的首 $1$ 最大公因式），再作除法 $d_k=D_k/D_{k-1}$。$3\times3$ 以内最稳，因为子式可以逐个列出来。

**路线 3（初等因子组装法）**：若已经有对角形 $\operatorname{diag}(f_1,\dots,f_r)$（不必满足整除链），把每个 $f_i$ 分解成首 $1$ 不可约因式的幂，**所有**这些幂就是初等因子；再按「同一素因子的幂从大到小分配给 $d_r,d_{r-1},\dots$」重新组装（见 [@note-3.8-assemble]）。

**验算**：$d_1\mid d_2\mid\cdots\mid d_r$，且 $\prod_{i=1}^r d_i=\big|A(\lambda)\big|$（方阵、满秩时）。这两条对不上，计算必有错。
:::

<a id="sec-3.8.7b"></a>

## 3.8.7 不变因子与初等因子

Smith 标准形唯一，于是它对角线上的那串多项式值得单独命名。

::: cor 推论 3.8.1（课件原文）· Smith 标准形的唯一性 {#cor-3.8.1}

$\lambda$ 矩阵的 Smith 标准形是唯一的。

::: proof 证明（本编补）

设 $A(\lambda)$ 经初等变换化为两个 Smith 形
$\operatorname{diag}(d_1,\dots,d_r,0,\dots)$ 与 $\operatorname{diag}(d'_1,\dots,d'_r,0,\dots)$。

初等变换 $=$ 左乘、右乘可逆 $\lambda$ 矩阵。若 $B=P A Q$，$P,Q$ 可逆，则 $B$ 的任一 $k$ 阶子式是 $A$ 的 $k$ 阶子式的多项式线性组合（由 Cauchy–Binet 公式，展开后每项都是 $P$ 的一个 $k$ 阶子式、$A$ 的一个 $k$ 阶子式、$Q$ 的一个 $k$ 阶子式的乘积），故 $A$ 的全部 $k$ 阶子式的公因式整除 $B$ 的全部 $k$ 阶子式，即 $D_k(A)\mid D_k(B)$；交换 $A,B$ 的角色得反向整除。于是 $D_k(A)=D_k(B)$。

由 [@note-3.8-dk-smith]，Smith 形的 $D_k=d_1\cdots d_k$，故两个 Smith 形的 $D_k$ 相同；再由 $d_k=D_k/D_{k-1}$ 得 $d_k=d'_k$（$k=1,\dots,r$）。$\blacksquare$
:::
:::

::: def 定义 3.8.6 · 不变因子 {#def-3.8.6}

在 $\lambda$ 矩阵 $A(\lambda)$ 的 Smith 标准形中，$d_1(\lambda),\dots,d_r(\lambda)$ 由 $A(\lambda)$ 唯一确定，称为 $A(\lambda)$ 的**不变因子**。
:::

::: ex 例 3.8.4 续（课件原文）· 不变因子 {#ex-3.8.4c}

由

$$A(\lambda)\cong\begin{bmatrix}1&0&0\\0&\lambda&0\\0&0&\lambda(\lambda+1)\end{bmatrix}$$

直接读出

$$d_1(\lambda)=1,\qquad d_2(\lambda)=\lambda,\qquad d_3(\lambda)=\lambda(\lambda+1).$$
:::

「不变」两个字有两层意思：一是在初等变换下不变（[3.8.8](#sec-3.8.8b) 的定理 3.8.3），二是它们构成 $\lambda$ 矩阵在相抵下的**完全不变量**（[3.8.8](#sec-3.8.8b) 的推论 3.8.2）。

::: def 定义 3.8.7 · 初等因子（组）{#def-3.8.7}

设 $\lambda$ 矩阵 $A(\lambda)$ 的不变因子为 $d_1(\lambda),\dots,d_r(\lambda)$，且有分解式

$$\begin{aligned}
d_1(\lambda)&=(\lambda-\lambda_1)^{e_{11}}(\lambda-\lambda_2)^{e_{12}}\cdots(\lambda-\lambda_s)^{e_{1s}},\\
d_2(\lambda)&=(\lambda-\lambda_1)^{e_{21}}(\lambda-\lambda_2)^{e_{22}}\cdots(\lambda-\lambda_s)^{e_{2s}},\\
&\ \ \vdots\\
d_r(\lambda)&=(\lambda-\lambda_1)^{e_{r1}}(\lambda-\lambda_2)^{e_{r2}}\cdots(\lambda-\lambda_s)^{e_{rs}},
\end{aligned}$$

则所有**幂指数大于零**的因子 $(\lambda-\lambda_j)^{e_{ij}}$（$i=1,\dots,r$，$j=1,\dots,s$）统称为 $\lambda$ 矩阵 $A(\lambda)$ 的**初等因子（组）**。
:::

::: ex 例 3.8.4 续（课件原文）· 初等因子 {#ex-3.8.4d}

由 $d_1=1$、$d_2=\lambda$、$d_3=\lambda(\lambda+1)$，按定义读出初等因子为

$$\lambda,\quad\lambda,\quad\lambda+1.$$
:::

::: note 注 6（课件原文）· 初等因子可以重复 {#note-3.8-note6}

初等因子可能存在相同的因子。例 3.8.4 中 $\lambda$ 就出现了两次——它分别来自 $d_2$ 与 $d_3$。**「组」是多重集**，数个数时不能去重；这一点在拼 Jordan 标准形时直接决定块的个数。
:::

::: ex 例 3.8.5（课件原文）· Jordan 块的特征矩阵 {#ex-3.8.5}

求 $A(\lambda)$ 的 Smith 标准形、不变因子和初等因子，其中

$$A(\lambda)=\begin{bmatrix}
\lambda-a&-1&&&\\
&\lambda-a&-1&&\\
&&\lambda-a&\ddots&\\
&&&\ddots&-1\\
&&&&\lambda-a
\end{bmatrix}_{n\times n}.$$

::: sol 解答（课件原文）

$k$ 阶子式中，取第 $1,\dots,k$ 行与第 $2,\dots,k+1$ 列，得到一个上三角子式，其对角元全为 $-1$，故 $|{-1}|$、$\begin{vmatrix}-1&0\\ \lambda-a&-1\end{vmatrix}$、$\dots$ 这些子式都等于 $\pm1$。于是

$$D_1(\lambda)=D_2(\lambda)=\cdots=D_{n-1}(\lambda)=1,\qquad D_n(\lambda)=(\lambda-a)^n.$$

**分析（课件原文）**：$A(\lambda)$ 的不变因子为

$$d_1=d_2=\cdots=d_{n-1}=1,\qquad d_n=|A(\lambda)|=(\lambda-a)^n.$$

其 Smith 标准形为

$$\begin{bmatrix}1&&&&\\&1&&&\\&&\ddots&&\\&&&1&\\&&&&(\lambda-a)^n\end{bmatrix},$$

相应的初等因子为 $(\lambda-a)^n$。∎
:::
:::

这个例子是整节的技术心脏。它算的不是随便一个矩阵，而是**单个 Jordan 块的特征矩阵** $\lambda I-J_n(a)$：把 $J_n(a)$ 的对角元搬到左边、超对角元的 $-1$ 留在原处，正是上面的形状。于是结论可以读成：

> **$n$ 阶 Jordan 块 $J_n(a)$ 的特征矩阵，Smith 标准形是 $\operatorname{diag}(1,\dots,1,(\lambda-a)^n)$，初等因子只有一个 $(\lambda-a)^n$。**

[3.8.10](#sec-3.8.10b) 证明 Jordan 标准形存在性时，正是把这句话反过来用：**给定初等因子 $(\lambda-a)^n$，就能造出一个特征矩阵与它相抵的矩阵，那就是 $J_n(a)$。**

::: ex 例 3.8.6（课件原文）· 由对角阵读初等因子 {#ex-3.8.6}

求 $A(\lambda)=\operatorname{diag}\big(\lambda^2(\lambda+1),\ \lambda(\lambda+1)^2,\ 0\big)$ 的初等因子。

::: sol 解答（课件原文）

先求 $A(\lambda)$ 的行列式因子：

$$D_1(\lambda)=\lambda(\lambda+1),\qquad D_2(\lambda)=\lambda^3(\lambda+1)^3,\qquad D_3(\lambda)=0.$$

所以 $A(\lambda)$ 的不变因子为

$$d_1(\lambda)=D_1(\lambda)=\lambda(\lambda+1),\qquad d_2(\lambda)=\frac{D_2(\lambda)}{D_1(\lambda)}=\lambda^2(\lambda+1)^2,$$

且 $A(\lambda)$ 的初等因子为

$$\lambda,\quad\lambda+1,\quad\lambda^2,\quad(\lambda+1)^2. \qquad\blacksquare$$
:::
:::

::: note 本编注 · $D_3=0$ 是什么意思（课件这一行要改读） {#note-3.8-d3-zero}

课件写「$D_3(\lambda)=0$」。按 [@def-3.8.5]，$D_k$ 只对 $1\le k\le r$ 定义；这里 $\operatorname{rank}A(\lambda)=2$（第三个对角元是 $0$），所以**三阶行列式因子根本不存在**，能说的是「$\big|A(\lambda)\big|=0$」。

这不是文字游戏：如果真把 $D_3$ 当成 $0$，那么 $d_3=D_3/D_2=0$，会凭空多出一个零不变因子。正确读法是「$r=2$，只到 $d_2$ 为止」，与 $d_1\mid d_2$、$d_1d_2=D_2$ 完全一致。详见[勘误 E3.14](errata.md#errata-3.8)。
:::

::: ex 例 3.8.6 续（课件原文）· 由初等因子反装 Smith 标准形 {#ex-3.8.6b}

求 $A(\lambda)=\operatorname{diag}\big(\lambda^2(\lambda+1),\ \lambda(\lambda+1)^2,\ 0\big)$ 的 Smith 标准形。

::: sol 解答（课件原文）

利用初等因子 $\lambda,\ \lambda+1,\ \lambda^2,\ (\lambda+1)^2$ 直接构建不变因子。$r=2$，故

$$A(\lambda)\cong\begin{bmatrix}d_1&0&0\\0&d_2&0\\0&0&0\end{bmatrix},\qquad
d_2=\lambda^2(\lambda+1)^2,\qquad d_1=\lambda(\lambda+1).$$

**分析（课件原文）**：$A(\lambda)$ 的初等因子恰是 $A(\lambda)$ 对角线元素分解出的一次因子的幂。

**小结（课件原文）**：$\lambda$ 对角阵的对角线元素分解出的一次因子的幂，就是该矩阵的初等因子。∎
:::
:::

::: note 本编注 · 反装的规则：同一素因子的幂从大到小分配 {#note-3.8-assemble}

课件的小结只说了「怎么从对角阵读出初等因子」，反方向（从初等因子装回不变因子）需要一条明确的规则。设共有 $r$ 个不变因子，把每个素因子 $\lambda-\lambda_j$ 的全部幂**按指数从大到小排成一列**：

$$(\lambda-\lambda_j)^{e_{(1)}}\ \ge\ (\lambda-\lambda_j)^{e_{(2)}}\ \ge\ \cdots$$

最大的那个放进 $d_r$，第二大的放进 $d_{r-1}$，依此类推；没有对应幂的名额用 $1$ 填。对每个素因子都这样做，再把各素因子的贡献乘起来。这样装出来的 $d_i$ 自动满足 $d_1\mid d_2\mid\cdots\mid d_r$，而「同一素因子的幂从小到大排」会让你得到反的整除链，是这一节最常见的错误。

回到例 3.8.6：素因子 $\lambda$ 的幂是 $\lambda^2,\lambda$，$\lambda+1$ 的幂是 $(\lambda+1)^2,(\lambda+1)$。$r=2$，故 $d_2=\lambda^2(\lambda+1)^2$、$d_1=\lambda(\lambda+1)$ ✓。若错误地把小的幂放进 $d_2$，会得到 $d_1=\lambda^2(\lambda+1)^2$、$d_2=\lambda(\lambda+1)$，整除方向立刻反了。
:::

::: ex 例 3.8.E（新增）· 对角阵不等于 Smith 标准形 {#ex-3.8.E}

设 $A(\lambda)=\operatorname{diag}\big(\lambda-1,\ (\lambda-1)(\lambda-2),\ (\lambda-2)^2\big)$。它已经是**对角阵**，但它是不是 Smith 标准形？若不是，求出 Smith 标准形与初等因子。

::: sol 解答

**先查整除链**：对角元是 $\lambda-1$、$(\lambda-1)(\lambda-2)$、$(\lambda-2)^2$。第二项能被第一项整除，但第三项 $(\lambda-2)^2$ **不能**被第二项 $(\lambda-1)(\lambda-2)$ 整除（差一个因子 $\lambda-1$）。所以它**不是** Smith 标准形——「对角」不等于「Smith」。

**按定义算行列式因子**：

- 一阶：$D_1=\gcd(\lambda-1,\ (\lambda-1)(\lambda-2),\ (\lambda-2)^2)=1$（有两项互素）；
- 二阶：二阶子式包括 $(\lambda-1)\cdot(\lambda-1)(\lambda-2)$、$(\lambda-1)(\lambda-2)^2$、$(\lambda-1)(\lambda-2)\cdot(\lambda-2)^2$ 等，首 $1$ 最大公因式为 $(\lambda-1)(\lambda-2)$；
- 三阶：$D_3=|A|=\lambda-1\cdot(\lambda-1)(\lambda-2)\cdot(\lambda-2)^2=(\lambda-1)^2(\lambda-2)^3$。

于是

$$d_1=1,\qquad d_2=\frac{D_2}{D_1}=(\lambda-1)(\lambda-2),\qquad d_3=\frac{D_3}{D_2}=(\lambda-1)(\lambda-2)^2.$$

Smith 标准形为 $\operatorname{diag}\big(1,\ (\lambda-1)(\lambda-2),\ (\lambda-1)(\lambda-2)^2\big)$。

**初等因子**：把三个不变因子分解，得

$$\lambda-1,\quad \lambda-2,\quad \lambda-1,\quad (\lambda-2)^2,$$

即 $\{\lambda-1,\ \lambda-1,\ \lambda-2,\ (\lambda-2)^2\}$。

**验算**：$\prod d_i=d_3=(\lambda-1)^2(\lambda-2)^3=D_3$ ✓；$d_1\mid d_2\mid d_3$ ✓；初等因子的乘积 $=(\lambda-1)^2(\lambda-2)^3$ ✓。

**要点**：对角元 $(\lambda-1)$、$(\lambda-1)(\lambda-2)$、$(\lambda-2)^2$ 是**可约的**，它们不是初等因子；初等因子必须是**素因子的幂**。直接拿对角元当不变因子，或直接拿对角元当初等因子，都会错。∎
:::
:::

<a id="sec-3.8.8b"></a>

## 3.8.8 相抵的判别：三个不变量够不够

上半页把初等变换的可逆性说清楚了，于是「能互相化过去」是一个等价关系，值得给它一个名字。

::: def 定义 3.8.8 · $\lambda$ 矩阵相抵 {#def-3.8.8}

若 $\lambda$ 矩阵 $A(\lambda)$ 经过有限次初等变换化为 $B(\lambda)$，则称 $A(\lambda)$ 与 $B(\lambda)$ **相抵**，记为

$$A(\lambda)\cong B(\lambda).$$
:::

::: ex 例 3.8.7（课件原文）· 同秩但不相抵 {#ex-3.8.7}

判断 $A(\lambda)=\begin{bmatrix}\lambda&0\\0&\lambda\end{bmatrix}$ 和 $B(\lambda)=\begin{bmatrix}1&0\\0&\lambda^2\end{bmatrix}$ 是否相抵。

::: sol 解答（课件原文）

$A(\lambda)$ 和 $B(\lambda)$ 均为 Smith 标准形（对角元首 $1$、满足整除链：$\lambda\mid\lambda$；$1\mid\lambda^2$），故 $A(\lambda)$ 和 $B(\lambda)$ **不相抵**。∎
:::
:::

::: note 注 7（课件原文）· 同秩推不出相抵 {#note-3.8-note7}

$\lambda$ 矩阵相抵则其秩相同，反之则不然——这与数字矩阵是有区别的。例 3.8.7 的两个矩阵秩都是 $2$，但一个的初等因子是 $\lambda,\lambda$，另一个是 $\lambda^2$，所以不相抵。
:::

::: thm 定理 3.8.3（课件原文）· 相抵保持的不变量 {#thm-3.8.3}

相抵的 $\lambda$ 矩阵具有相同的 Smith 标准形、秩、各阶行列式因子、不变因子和初等因子。
:::

::: note 注 8（课件原文）· 换个说法 {#note-3.8-note8}

$\lambda$ 矩阵作初等变换时，不改变它的 Smith 标准形、秩、各阶行列式因子、不变因子以及初等因子。
:::

课件随后提出四问。这四问的顺序设计得极好：它把「不变量」与「完全不变量」的区别逼出来。

::: think 课件四问（本编补答）{#think-3.8-four-questions}

1. 具有相同**秩**的 $\lambda$ 矩阵相抵吗？
2. 具有相同的**各阶行列式因子**的 $\lambda$ 矩阵相抵吗？
3. 具有相同的**不变因子**的 $\lambda$ 矩阵相抵吗？
4. 具有相同的**初等因子**的 $\lambda$ 矩阵相抵吗？

**答**：

1. **否**。例 3.8.7 是同秩不相抵的标本。
2. **是**。$D_k$ 相同 $\Rightarrow$ 由 $d_k=D_k/D_{k-1}$ 得不变因子相同 $\Rightarrow$ Smith 标准形相同 $\Rightarrow$ 相抵（[3.8.6](#sec-3.8.6b) 的定理 3.8.2）。
3. **是**。不变因子相同 $\Rightarrow$ Smith 标准形相同 $\Rightarrow$ 相抵。
4. **否**（对一般 $\lambda$ 矩阵）。例 3.8.8 的两个矩阵初等因子都是 $\lambda$，但秩不同，故不相抵。要补上「秩相同」这个条件，才是充要条件（定理 3.8.4）。
:::

::: cor 推论 3.8.2（课件原文）· 相抵的充要条件 {#cor-3.8.2}

$\lambda$ 矩阵 $A(\lambda)$ 与 $B(\lambda)$ 相抵，当且仅当它们具有相同的各阶行列式因子，当且仅当它们具有完全一致的不变因子。
:::

::: ex 例 3.8.8（课件原文）· 初等因子相同但秩不同 {#ex-3.8.8}

判断 $A(\lambda)=\begin{bmatrix}0&0\\0&\lambda\end{bmatrix}$ 和 $B(\lambda)=\begin{bmatrix}1&0\\0&\lambda\end{bmatrix}$ 是否相抵。

::: sol 解答（课件原文）

$A(\lambda)$ 和 $B(\lambda)$ 均是 Smith 标准形。尽管其初等因子相同，都是 $\lambda$，但两者 Smith 标准形不同（$A$ 的秩为 $1$，$B$ 的秩为 $2$），故 $A(\lambda)$ 和 $B(\lambda)$ **不相抵**。∎
:::
:::

::: thm 定理 3.8.4（课件原文）· 初等因子 $+$ 秩 $=$ 完全不变量 {#thm-3.8.4}

$\lambda$ 矩阵 $A(\lambda)\cong B(\lambda)$ 当且仅当它们有**完全相同**的初等因子，且 $\operatorname{rank}A(\lambda)=\operatorname{rank}B(\lambda)$。

::: proof 证明（本编补「充分性」）

**必要性**：由定理 3.8.3，相抵保持秩、不变因子与初等因子。

**充分性**：设两者秩同为 $r$，且初等因子（作为多重集）完全相同。由 [@note-3.8-assemble] 的组装规则，不变因子 $d_1,\dots,d_r$ 由初等因子组与 $r$ **唯一**决定：对每个素因子，把它的幂按指数从大到小排，依次填入 $d_r,d_{r-1},\dots$，空缺填 $1$。初等因子组相同、$r$ 相同，装出的 $d_1,\dots,d_r$ 就相同，于是两者的 Smith 标准形相同。再由定理 3.8.2（存在性）与推论 3.8.1（唯一性），Smith 标准形相同即相抵。$\blacksquare$
:::
:::

这条定理是整节的**引擎**。它说的是：想要两个矩阵相抵，只需核对两样东西——**秩**（管零块的尺寸）与**初等因子组**（管非零对角元的素因子结构）。[3.8.10](#sec-3.8.10b) 证明 Jordan 标准形存在时，正是先造出一个 Jordan 块矩阵 $J$，再验证 $\lambda I-J$ 与 $\lambda I-A$ 的秩、初等因子都相同，然后由这条定理宣布相抵，最后由 [3.8.9](#sec-3.8.9b) 的相似判别宣布 $A\sim J$。

::: think 读法 · 四条判据的层次 {#note-3.8-four-levels}

| 判据 | 是否完全 | 反例 |
|:--|:--|:--|
| 秩相同 | 否 | 例 3.8.7（$\operatorname{diag}(\lambda,\lambda)$ vs $\operatorname{diag}(1,\lambda^2)$） |
| 行列式因子相同 | 是 | —（推论 3.8.2） |
| 不变因子相同 | 是 | —（推论 3.8.2） |
| 初等因子相同 | 否 | 例 3.8.8（$\operatorname{diag}(0,\lambda)$ vs $\operatorname{diag}(1,\lambda)$） |
| 初等因子相同 $+$ 秩相同 | 是 | —（定理 3.8.4） |

**记忆**：秩管「有几个零」，初等因子管「非零部分长什么样」；两者合起来才是完整的户口本。不变因子是二者的「合并报表」——它同时编码了秩（$d$ 的个数）与非零结构，所以单独一项就够。
:::

<a id="sec-3.8.9b"></a>

## 3.8.9 相似 $\iff$ 特征矩阵相抵

到这里为止，讨论的都是「$\lambda$ 矩阵之间」的关系。现在把它拉回**数字矩阵**：两个方阵相似，等价于它们的特征矩阵相抵。这条定理把相似问题整个翻译成 $\lambda$ 矩阵问题。

::: thm 定理 3.8.5（课件原文）· 相似的特征矩阵判别 {#thm-3.8.5}

复方阵 $A$ 和 $B$ 相似，当且仅当它们的特征矩阵 $\lambda I-A$ 与 $\lambda I-B$ 相抵。

::: proof 证明（必要性本编补完整；充分性为标准结果，本编给路线与关键引理）

**必要性（$\Rightarrow$）**：设 $B=P^{-1}AP$，则

$$\lambda I-B=\lambda I-P^{-1}AP=P^{-1}(\lambda I-A)P.$$

$P^{-1}$、$P$ 都是可逆常数矩阵，当然也是可逆 $\lambda$ 矩阵（行列式为非零常数），故 $\lambda I-A\cong\lambda I-B$。

**充分性（$\Leftarrow$）**：设

$$\lambda I-B=P(\lambda)(\lambda I-A)Q(\lambda),\tag{$*$}$$

其中 $P,Q$ 为可逆 $\lambda$ 矩阵。目标是说明 $P,Q$ 可以取成常数矩阵。证明的最后一步很简单，难在前面。

*最后一步（若 $P,Q$ 已是常数）*：$(*)$ 变成 $\lambda I-B=P(\lambda I-A)Q$。比较 $\lambda$ 的系数得 $I=PQ$，故 $Q=P^{-1}$、$P$ 可逆；比较常数项得 $-B=-PAQ$，即

$$B=PAP^{-1},\qquad A\sim B.$$

*前面要做的（标准路线）*：把 $P,Q$ 降成常数。两步。

**第一步：把其中一个因子换成多项式矩阵的伴随。** 由 [@thm-3.8.1]，$Q$ 可逆等价于 $\det Q=q$ 是非零**常数**，于是 $Q^{-1}=Q^*/q$ 是多项式矩阵。在 $(*)$ 两边右乘 $Q^{-1}$，得同形等式

$$(\lambda I-B)\,Q^*(\lambda)=q\,P(\lambda)(\lambda I-A), \tag{$\dagger$}$$

两边都是多项式矩阵，且两边的次数相等（左、右各有一个首系数为单位阵的一次因子，次数不会被零因子吃掉，见 [@note-3.8-eval-trap]）。

**第二步：对次数作归纳，逐层剥掉首项。** 记 $r=\deg P=\deg Q^*$。比较 $(\dagger)$ 两边 $\lambda^{r+1}$ 的系数，得首系数之间的关系 $Q^*_r=qP_r$；把这一层首项从两边同时剥掉，重新比较，次数降为 $r-1$。如此逐层剥到 $r=0$，剩下的就是常数矩阵 $P_0,Q^*_0$，再代入 $(*)$ 用「最后一步」读出 $B=P_0AP_0^{-1}$。

**本编的诚实标注**：「逐层剥」在系数层面上是标准做法（见任意一本讲多项式矩阵的教材，如 Gantmacher《矩阵论》中「多项式矩阵」一章），但写全需要同时比较每一层的全部系数，篇幅长且每一步都要处理「矩阵乘积的首系数可能为零」这个陷阱（[@note-3.8-eval-trap]）。**本课不要求掌握这段技术细节**；考试若考这条定理，通常只考必要性方向，或要求准确叙述结论。上半部分的「$\lambda I-A$ 总是满秩」与本节的做法（算初等因子、比秩）才是考点。

**为什么不能更省事**：有人会说「在 $(*)$ 里令 $\lambda=A$，右边含 $AI-A=O$，故 $A-B=O$，所以 $A=B$」。这个推理错在矩阵多项式的代入不是环同态（$A$ 与系数矩阵不交换），结论 $A=B$ 也显然荒谬（$\operatorname{diag}(1,2)\sim\operatorname{diag}(2,1)$ 但两者不等）。见 [@note-3.8-eval-trap]。
:::
:::

::: note 本编注 · 两个陷阱：代入与零因子 {#note-3.8-eval-trap}

**陷阱 1：对矩阵多项式「代入 $\lambda=A$」。** 初学者常想：在 $\lambda I-B=P(\lambda)(\lambda I-A)Q(\lambda)$ 里令 $\lambda=A$，右边含因子 $AI-A=O$，故左边 $A-B=O$，于是 $A=B$。这个推理是**错的**：矩阵多项式的代入不是环同态，$(MN)(A)\ne M(A)N(A)$，因为 $A$ 与系数矩阵不一定交换。结论 $A=B$ 也显然荒谬——$\operatorname{diag}(1,2)\sim\operatorname{diag}(2,1)$，但两者不相等。**凡是推出「相似即相等」的论证，都是在这一步偷换了。**

**陷阱 2：以为「两个多项式矩阵相乘，次数会相加」。** 对数字多项式这是对的，对**矩阵**多项式不对：若两个因子都是矩阵多项式，$M_pN_q$ 可能为零矩阵（矩阵有零因子），首项被抵消，乘积次数会**小于** $p+q$。例如 $M=\begin{bmatrix}\lambda&0\\0&0\end{bmatrix}$、$N=\begin{bmatrix}0&0\\0&\lambda\end{bmatrix}$，$MN=O$。

但当**其中一个因子形如 $\lambda I-C$**（首系数是单位阵）时，这个麻烦消失：$(\lambda I-C)M$ 的 $\lambda^{m+1}$ 系数就是 $M_m\ne O$，次数严格等于 $\deg M+1$。这正是相似判别的充分性证明必须绕道「$Q^{-1}=Q^*/q$」的原因——把等式改写成「$\lambda I-B$ 左乘一个多项式矩阵」的形式，才能放心地比较次数。
:::

::: method 方法 · 相似判别的推论链 {#method-3.8-similar-chain}

对数字方阵 $A,B$，下面五句话等价：

$$A\sim B\iff \lambda I-A\cong\lambda I-B\iff \lambda I-A,\lambda I-B\ \text{的 Smith 标准形相同}$$
$$\iff \lambda I-A,\lambda I-B\ \text{的不变因子相同}\iff \lambda I-A,\lambda I-B\ \text{的初等因子相同}.$$

最后一条对**特征矩阵**成立，而对一般 $\lambda$ 矩阵不成立（例 3.8.8）：特征矩阵总是 $n$ 阶满秩（[例 3.8.3](sec38.md#ex-3.8.3)），秩自动相同，于是定理 3.8.4 里「秩相同」这个附加条件自动满足，初等因子单独就够了。**这是「相似」比「相抵」好用的地方：不变量少一个。**

**用法**：判断 $A\sim B$，不必找 $P$——算 $\lambda I-A$ 与 $\lambda I-B$ 的初等因子，比较即可。
:::

::: think 课件思考 · 方阵可对角化的充要条件（本编补答）{#think-3.8-diagonalizable}

课件先把 [3.6.1](sec36.md#thm-3.6.1) 的五条判据复习一遍，再问：用初等因子怎么讲？

$$A\sim\Lambda=\operatorname{diag}(\lambda_1,\dots,\lambda_n)
\iff \lambda I-A\cong\lambda I-\Lambda=\operatorname{diag}(\lambda-\lambda_1,\dots,\lambda-\lambda_n).$$

右边这个对角阵的初等因子是 $\lambda-\lambda_1,\dots,\lambda-\lambda_n$——**全是一次式**。于是：

> **$A$ 单纯（可对角化）$\iff$ $\lambda I-A$ 的初等因子全是一次式。**

这就是推论 3.8.3。它还有两个等价说法：不变因子无重根（推论 3.8.4），或最小多项式无重根（[3.6.1](sec36.md#thm-3.6.1)（5））。三者是同一件事的三种语言：**初等因子全一次 $\iff$ 每个 $d_i$ 是互异一次因子之积 $\iff$ $d_n=m_A$ 无重根**。
:::

::: cor 推论 3.8.3（课件原文）· 单纯矩阵的初等因子刻画 {#cor-3.8.3}

复方阵 $A$ 是单纯矩阵的充分必要条件是：它的特征矩阵 $\lambda I-A$ 的初等因子为一次的。

::: proof 证明（本编补）

**必要性**：若 $A\sim\Lambda=\operatorname{diag}(\lambda_1,\dots,\lambda_n)$，则 $\lambda I-A\cong\lambda I-\Lambda=\operatorname{diag}(\lambda-\lambda_1,\dots,\lambda-\lambda_n)$，后者的初等因子就是这些一次式（重复的合并计数）。

**充分性**：若 $\lambda I-A$ 的初等因子全是一次式，则每个不变因子 $d_i$ 都是互异一次因子的乘积，故 $d_i=\prod(\lambda-\lambda_j)$ 形如无重根多项式。于是 $d_n=m_A$ 无重根，由 [3.6.1](sec36.md#thm-3.6.1)（5）$\Rightarrow$（1），$A$ 可对角化。$\blacksquare$
:::
:::

::: cor 推论 3.8.4（课件原文）· 不变因子的说法 {#cor-3.8.4}

复方阵 $A$ 是单纯矩阵的充分必要条件是：它的特征矩阵 $\lambda I-A$ 的不变因子无重根。

::: proof 证明（本编补）

不变因子无重根 $\iff$ 每个 $d_i$ 的素因子分解中每个一次因子只出现一次 $\iff$ 全部初等因子都是一次的（因为初等因子正是「$d_i$ 中素因子的幂」，指数全为 $1$）$\iff$ 由推论 3.8.3，$A$ 单纯。$\blacksquare$
:::
:::

::: ex 例 3.8.8′（课件原文；原编号与相抵反例重复，见勘误 E3.13）· 单个 Jordan 块不单纯 {#ex-3.8.8j}

判断矩阵

$$A=\begin{bmatrix}a&1&&&\\&a&1&&\\&&a&\ddots&\\&&&\ddots&1\\&&&&a\end{bmatrix}_{n\times n}\qquad(n\gt1)$$

是否为单纯矩阵。

::: sol 解答（课件原文）

$$\lambda I-A=\begin{bmatrix}
\lambda-a&-1&0&\cdots&0\\
0&\lambda-a&-1&\cdots&0\\
0&0&\lambda-a&\ddots&\vdots\\
\vdots&\vdots&\vdots&\ddots&-1\\
0&0&0&\cdots&\lambda-a
\end{bmatrix}.$$

由 [例 3.8.5](#ex-3.8.5)，$\lambda I-A$ 的初等因子为 $(\lambda-a)^n$。它不是一次式，故由 [@cor-3.8.3]，$A$ **不是**单纯阵。∎
:::
:::

这个例子的价值在于给出「不单纯」的**最小标本**：$n=2$ 时 $A=\begin{bmatrix}a&1\\0&a\end{bmatrix}$，代数重数 $2$、几何重数 $1$，凑不出两个线性无关的特征向量。它的初等因子 $(\lambda-a)^2$ 就是「缺陷」的定量记录——[3.8.10](#sec-3.8.10b) 要造的 Jordan 块，正是为了把这类缺陷收纳成标准零件。

<a id="sec-3.8.10b"></a>

## 3.8.10 Jordan 块与 Jordan 标准形

::: note 课堂信号（10-27）· Jordan 只考「用」，不考「证」

老师明确说：考试主要考**如何利用 Jordan 分解的性质做矩阵分解**；“几乎不会考‘为什么可以 Jordan 分解’的证明”（10-27 00:16）。所以本节的存在性证明（本编补）用来建立结构直觉，**应试重点是**：由初等因子写 Jordan 形、由 Jordan 形读最小多项式、以及用 Jordan 形算幂与矩阵函数。原话见[课堂口述与考点信号](../lecture-signals.md)。
:::

现在把流水线的最后两站接上：初等因子 $\to$ Jordan 块 $\to$ Jordan 标准形。

::: def 定义 3.8.9 · Jordan 块 {#def-3.8.9}

设复方阵 $A$ 的特征矩阵 $\lambda I-A$ 的初等因子为

$$(\lambda-\lambda_1)^{n_1},\ (\lambda-\lambda_2)^{n_2},\ \dots,\ (\lambda-\lambda_s)^{n_s}.$$

对 $(\lambda-\lambda_i)^{n_i}$ 作 $n_i$ 阶方阵

$$J_i=\begin{bmatrix}
\lambda_i&1&&\\
&\lambda_i&1&\\
&&\ddots&\ddots\\
&&&\lambda_i&1\\
&&&&\lambda_i
\end{bmatrix}_{n_i\times n_i},$$

则称矩阵 $J_i$（$i=1,\dots,s$）为 $A$ 的 **Jordan 块**。
:::

<figure aria-labelledby="fig-block-caption" class="concept-figure" data-figure="FIG. 3–04">
<svg aria-labelledby="fig-block-title fig-block-desc" role="img" viewBox="0 0 680 300">
<title id="fig-block-title">Jordan 块的三个判定要点：对角元相同、1 落在超对角、断点在哪里</title>
<desc id="fig-block-desc">上排左：一个合法的四阶块，对角元全为 2，超对角全为 1。上排右：对角元 2,2,3,3 但 (2,3) 处多了一个 1，跨过了对角元变化的位置，不是分块对角阵。下排：写出的三个矩阵分别是一个块、两个块、一个块被拆错。</desc>
<text class="diagram-mono" x="24" y="22">✓ 一个四阶块</text>
<rect fill="var(--fig-green)" height="98" opacity="0.10" rx="6" width="150" x="24" y="30"></rect>
<text class="diagram-text" text-anchor="middle" x="78" y="54">2</text>
<text class="diagram-text" text-anchor="middle" x="110" y="54">1</text>
<text class="diagram-note" text-anchor="middle" x="142" y="54">0</text>
<text class="diagram-note" text-anchor="middle" x="174" y="54">0</text>
<text class="diagram-note" text-anchor="middle" x="78" y="76">0</text>
<text class="diagram-text" text-anchor="middle" x="110" y="76">2</text>
<text class="diagram-text" text-anchor="middle" x="142" y="76">1</text>
<text class="diagram-note" text-anchor="middle" x="174" y="76">0</text>
<text class="diagram-note" text-anchor="middle" x="78" y="98">0</text>
<text class="diagram-note" text-anchor="middle" x="110" y="98">0</text>
<text class="diagram-text" text-anchor="middle" x="142" y="98">2</text>
<text class="diagram-text" text-anchor="middle" x="174" y="98">1</text>
<text class="diagram-note" text-anchor="middle" x="78" y="120">0</text>
<text class="diagram-note" text-anchor="middle" x="110" y="120">0</text>
<text class="diagram-note" text-anchor="middle" x="142" y="120">0</text>
<text class="diagram-text" text-anchor="middle" x="174" y="120">2</text>
<text class="diagram-note" x="24" y="146">对角元全同、1 连成一条链</text>
<text class="diagram-mono" x="200" y="22">✗ 断点处多了一个 1</text>
<rect fill="var(--fig-red)" height="98" opacity="0.09" rx="6" width="150" x="200" y="30"></rect>
<text class="diagram-text" text-anchor="middle" x="254" y="54">2</text>
<text class="diagram-text" text-anchor="middle" x="286" y="54">1</text>
<text class="diagram-note" text-anchor="middle" x="318" y="54">0</text>
<text class="diagram-note" text-anchor="middle" x="350" y="54">0</text>
<text class="diagram-note" text-anchor="middle" x="254" y="76">0</text>
<text class="diagram-text" text-anchor="middle" x="286" y="76">2</text>
<text class="diagram-text" text-anchor="middle" x="318" y="76">1</text>
<text class="diagram-note" text-anchor="middle" x="350" y="76">0</text>
<text class="diagram-note" text-anchor="middle" x="254" y="98">0</text>
<text class="diagram-note" text-anchor="middle" x="286" y="98">0</text>
<text class="diagram-text" text-anchor="middle" x="318" y="98">3</text>
<text class="diagram-text" text-anchor="middle" x="350" y="98">1</text>
<text class="diagram-note" text-anchor="middle" x="254" y="120">0</text>
<text class="diagram-note" text-anchor="middle" x="286" y="120">0</text>
<text class="diagram-note" text-anchor="middle" x="318" y="120">0</text>
<text class="diagram-text" text-anchor="middle" x="350" y="120">3</text>
<text class="diagram-note" x="200" y="146">(2,3) 处的 1 跨过 2→3</text>
<text class="diagram-mono" x="380" y="22">块结构 = 一种「台阶图」</text>
<rect fill="var(--fig-gold)" height="88" opacity="0.12" rx="6" width="276" x="380" y="30"></rect>
<text class="diagram-note" x="396" y="52">块的个数 = 几何重数</text>
<text class="diagram-note" x="396" y="72">最大块阶 = m_A 中该因子的幂次</text>
<text class="diagram-note" x="396" y="92">总阶数 = 代数重数</text>
<text class="diagram-note" x="396" y="110">（三者相等 ⟺ 可对角化）</text>
<text class="diagram-mono" x="24" y="182">同一个特征值可以有多块：三例对照</text>
<rect fill="var(--fig-blue)" height="66" opacity="0.09" rx="6" width="196" x="24" y="192"></rect>
<text class="diagram-text" x="40" y="214">J₃(2)</text>
<text class="diagram-note" x="40" y="234">初等因子（λ−2)³ · 一块</text>
<text class="diagram-note" x="40" y="250">m_A = (λ−2)³</text>
<rect fill="var(--fig-blue)" height="66" opacity="0.09" rx="6" width="196" x="240" y="192"></rect>
<text class="diagram-text" x="256" y="214">J₂(2) ⊕ J₁(2)</text>
<text class="diagram-note" x="256" y="234">(λ−2)², λ−2 · 两块</text>
<text class="diagram-note" x="256" y="250">m_A = (λ−2)²</text>
<rect fill="var(--fig-blue)" height="66" opacity="0.09" rx="6" width="196" x="456" y="192"></rect>
<text class="diagram-text" x="472" y="214">J₁ ⊕ J₁ ⊕ J₁</text>
<text class="diagram-note" x="472" y="234">三个一次因子 · 三块</text>
<text class="diagram-note" x="472" y="250">m_A = λ−2（可对角化）</text>
<text class="diagram-note" x="24" y="284">三者总阶数都是 3、特征多项式都是 (λ−2)³，但互不相似——块的分法由初等因子固定。</text>
</svg>
<figcaption id="fig-block-caption"><b>判断 Jordan 块只看一条：超对角的 $1$ 必须连接「相同」的对角元。</b>对角元一变，块就在那里断开。右下的三个例子总阶数与特征多项式完全相同，却互不相似——这正是「$f_A$ 不够、必须看初等因子」的最短反例集。</figcaption>
</figure>

::: note 本编注 · 记号的两处小疵 {#note-3.8-jordan-notation}

课件这一页把初等因子写成 $(\lambda-\lambda_1)^{n_1},\dots,(\lambda-\lambda_t)^{n_s}$——上标用 $s$、下标用 $t$，两个字母混了；随后又说「$J_i\ (i=1,\dots,s)$」。按上下文，初等因子共有 $s$ 个，故统一写成 $(\lambda-\lambda_i)^{n_i}\ (i=1,\dots,s)$ 即可。本页按统一后的写法排版，数学内容不变。

另一处要留意：**不同的 $i$ 可以有相同的 $\lambda_i$**。Jordan 块由「初等因子」逐个对应，而不是由「特征值」逐个对应；同一个特征值出现三次初等因子，就对应三个 Jordan 块（大小可以不同）。
:::

::: ex 例 3.8.9（课件原文）· 判断 Jordan 块 {#ex-3.8.9}

判断下列矩阵是否为 Jordan 块，其中

$$A_1=\begin{bmatrix}\mathrm i+1&1&\\&\mathrm i+1&1\\&&\mathrm i+1\end{bmatrix},\qquad
A_2=\begin{bmatrix}1&1&\\&1&0\\&&1\end{bmatrix},$$

$$A_3=\begin{bmatrix}3&1&&\\&3&&\\&&3&1\\&&&3\end{bmatrix},\qquad
A_4=\begin{bmatrix}2&1&&\\&2&&\\&&3&1\\&&&3\end{bmatrix}.$$

::: sol 解答（课件原文）

由 Jordan 块定义知，只有 $A_1$ 是 Jordan 块；$A_2$、$A_3$ 和 $A_4$ 均包含 $2$ 个 Jordan 块。∎
:::
:::

::: note 本编注 · 逐个核对这四问 {#note-3.8-jordan-check}

- $A_1$：对角元全为 $\mathrm i+1$、超对角元全为 $1$、其余为 $0$——**一个** $3$ 阶 Jordan 块 $J_3(\mathrm i+1)$ ✓；
- $A_2=\begin{bmatrix}1&1&0\\0&1&0\\0&0&1\end{bmatrix}=J_2(1)\oplus J_1(1)$——**两个**块（$J_1(1)$ 就是一阶块 $[1]$）✓；
- $A_3=J_2(3)\oplus J_2(3)$——**两个**块，对角元相同但被分成了两块 ✓；
- $A_4$ 按印刷版是 $\begin{bmatrix}2&1&0&0\\0&2&1&0\\0&0&3&1\\0&0&0&3\end{bmatrix}$：对角元 $2,2,3,3$，但 $(2,3)$ 处还有一个 $1$ 跨在「$2$ 跳到 $3$」的位置上。严格说它**不是**分块对角阵，那个 $1$ 不合法；按答案「含 $2$ 个 Jordan 块」的意图，应为 $\operatorname{diag}\big(J_2(2),J_2(3)\big)$。这是一处**印刷多出的 $1$**，见[勘误 E3.15](errata.md#errata-3.8)。判断方法记住一条就够：**超对角元的 $1$ 必须落在「左右对角元相等」的位置上**，否则就不是 Jordan 块。

**口诀**：看对角元分组——「相同且连续」的一段配一个 $1$ 链，就是一块；对角元一变，块就断。
:::

::: ex 例 3.8.10（课件原文）· Jordan 块的最小多项式 {#ex-3.8.10}

求 Jordan 块

$$J_i=\begin{bmatrix}\lambda_i&1&&\\&\ddots&\ddots&\\&&\ddots&1\\&&&\lambda_i\end{bmatrix}_{n_i\times n_i}$$

的最小多项式。

::: sol 解答（课件原文；本编补「为什么 $(\lambda_iI-J_i)^j\ne O$」）

$J_i$ 的特征多项式为 $(\lambda-\lambda_i)^{n_i}$，其最小多项式可能为

$$\lambda-\lambda_i,\quad(\lambda-\lambda_i)^2,\quad\dots,\quad(\lambda-\lambda_i)^{n_i}.$$

经计算知，对 $j=1,2,\dots,n_i-1$，$(\lambda_iI-J_i)^j\ne O$。因此 $J_i$ 的最小多项式为

$$m_{J_i}(\lambda)=(\lambda-\lambda_i)^{n_i}. \qquad\blacksquare$$
:::
:::

::: note 本编补 · $(\lambda_iI-J_i)^j$ 到底长什么样 {#note-3.8-nilpotent-power}

记 $N=\lambda_iI-J_i$，则 $N$ 只有超对角元为 $-1$，其余为 $0$；$N$ 就是「把向量整体上移一格」的位移矩阵：

$$N=\begin{bmatrix}0&-1&&\\&0&-1&\\&&\ddots&-1\\&&&0\end{bmatrix},\qquad
N^j\ne O\ (1\le j\lt n_i),\qquad N^{n_i}=O.$$

具体地，$N^j$ 的第 $(k,k+j)$ 元为 $(-1)^j$，其余为 $0$。所以 $N^j$ 对 $j\lt n_i$ 确实非零（$n_i$ 阶方阵的「位移距离」最大是 $n_i-1$），而 $N^{n_i}=O$。

这条计算一箭双雕：

- 它证明了 $m_{J_i}=(\lambda-\lambda_i)^{n_i}$（低一次幂都不零化）；
- 它也说明 **$J_i$ 的初等因子正是 $(\lambda-\lambda_i)^{n_i}$**（[例 3.8.5](#ex-3.8.5)：$\lambda I-J_i$ 的 Smith 形只有一个非平凡不变因子 $(\lambda-\lambda_i)^{n_i}$）。
:::

::: note 注 9（课件原文）· 三件事是同一个数 {#note-3.8-note9}

任一 Jordan 块的最小多项式等于它的特征多项式，也是该 Jordan 块所对应特征矩阵的初等因子。从 Jordan 块的形式看，**给定初等因子所作的最简 $\lambda$ 矩阵，就是 Jordan 块的特征矩阵**。

那么，对复方阵 $A$ 的所有初等因子作最简 $\lambda$ 矩阵，并构造对角块矩阵，即可得 $A$ 相似的最简阵 $B$。
:::

注 9 的最后一句话就是存在性证明的提纲。先把定义补齐，再把它证成定理。

::: def 定义 3.8.10 · Jordan 标准形 {#def-3.8.10}

设 $n$ 阶复方阵 $A$ 的特征矩阵 $\lambda I-A$ 的初等因子为

$$(\lambda-\lambda_1)^{n_1},\ (\lambda-\lambda_2)^{n_2},\ \dots,\ (\lambda-\lambda_s)^{n_s},$$

对应的 Jordan 块分别记为 $J_1,\dots,J_s$，则由 $s$ 个 Jordan 块作成的 $n$ 阶对角块矩阵

$$J=\operatorname{diag}(J_1,\dots,J_s)$$

称为 $A$ 的 **Jordan 标准形**（或 **Jordan 法式**）。
:::

::: ex 例 3.8.11（课件原文）· 由 Smith 形写 Jordan 标准形 {#ex-3.8.11}

设 $A$ 的特征矩阵

$$\lambda I-A\cong\operatorname{diag}\big(\lambda^2,\ \lambda(\lambda+1)^2,\ 1,\ 1,\ 1\big),$$

求 $A$ 的 Jordan 标准形。

::: sol 解答（课件原文）

$\lambda I-A$ 的初等因子为 $\lambda^2,\ \lambda,\ (\lambda+1)^2$（把中间那个可约的 $\lambda(\lambda+1)^2$ 拆成素因子幂）。作 Jordan 块

$$J_1=\begin{bmatrix}0&1\\0&0\end{bmatrix},\qquad
J_2=[\,0\,],\qquad
J_3=\begin{bmatrix}-1&1\\0&-1\end{bmatrix},$$

故

$$J=\begin{bmatrix}
0&1&0&0&0\\
0&0&0&0&0\\
0&0&0&0&0\\
0&0&0&-1&1\\
0&0&0&0&-1
\end{bmatrix}. \qquad\blacksquare$$
:::
:::

**读法**：$A$ 是 $5$ 阶方阵，所以 $J$ 是 $5$ 阶；三个初等因子给出三个块，阶数为 $2,1,2$，和为 $5$ ✓。其中 $\lambda^2$ 与 $\lambda$ 对应同一个特征值 $0$，故 $J$ 里出现了两块以 $0$ 为对角元的块（$2$ 阶与 $1$ 阶），它们**不能合并**成一块 $3$ 阶的——合并会改变初等因子。

::: note 本编注 · 题设那个对角阵并不是 Smith 标准形 {#note-3.8-3811-order}

题设写 $\lambda I-A\cong\operatorname{diag}(\lambda^2,\lambda(\lambda+1)^2,1,1,1)$。这个对角阵**不满足整除链**：按位置排，$d_1=\lambda^2$ 不整除 $d_2=\lambda(\lambda+1)^2$（缺因子 $\lambda+1$），而 $d_2$ 更不整除 $d_3=1$。所以它只是一个「与 $\lambda I-A$ 相抵的对角阵」，**不是** Smith 标准形。

它的 Smith 标准形要把对角元按整除链重排：

$$\lambda I-A\cong\operatorname{diag}\big(1,\ 1,\ 1,\ \lambda,\ \lambda^2(\lambda+1)^2\big).$$

**为什么课件可以直接读**：读初等因子不依赖次序——只需把**每个**对角元拆成素因子幂再取并集（[@note-3.8-assemble] 的说法），得到 $\{\lambda^2,\lambda,(\lambda+1)^2\}$，与排序无关。但若要写「不变因子」，就必须先排序；直接把题设的五个对角元当 $d_1,\dots,d_5$ 会得到错误的整除链与错误的 $m_A$。**「读初等因子可以乱序，读不变因子必须先排序」**——这一条是本页最实用的一句操作纪律。
:::

::: thm 定理 3.8.5′（课件原文；原编号与相似判别重复，见勘误 E3.13）· Jordan 标准形定理 {#thm-3.8.5j}

设矩阵 $J$ 是复方阵 $A$ 的 Jordan 标准形，则矩阵 $A$ 与矩阵 $J$ 相似。

::: proof 证明（本编补：存在性与唯一性）

**存在性**。设 $\lambda I-A$ 的初等因子为 $(\lambda-\lambda_1)^{n_1},\dots,(\lambda-\lambda_s)^{n_s}$，按定义 3.8.9 造出 $J_1,\dots,J_s$ 与 $J=\operatorname{diag}(J_1,\dots,J_s)$。分三步。

*第一步：单个块的 Smith 形。* 由 [例 3.8.5](#ex-3.8.5)（取 $a=\lambda_i$、$n=n_i$），

$$\lambda I-J_i\cong\operatorname{diag}\big(1,\dots,1,(\lambda-\lambda_i)^{n_i}\big).$$

*第二步：对角块矩阵的 Smith 形。* 设 $B_1$ 是 $m$ 阶、$B_2$ 是 $n$ 阶 $\lambda$ 矩阵。$\operatorname{diag}(B_1,B_2)$ 的 $k$ 阶子式分两类：

- **整块落在某一侧**：取 $B_1$ 的 $k$ 行 $k$ 列，得 $B_1$ 的 $k$ 阶子式；同理得 $B_2$ 的；
- **跨两块**：取 $B_1$ 的 $i$ 行 $i$ 列与 $B_2$ 的 $j$ 行 $j$ 列（$i+j=k$），子式等于两者之积（分块对角阵按 Laplace 展开）。

于是 $k$ 阶子式全体就是这三族之并，取首 $1$ 最大公因式（约定 $D_0=1$）：

$$D_k\big(\operatorname{diag}(B_1,B_2)\big)=\gcd_{i+j=k}\Big(D_i(B_1)\,D_j(B_2)\Big).\tag{$**$}$$

**注意交叉项不能丢**。若以为「只需 $\gcd(D_k(B_1),D_k(B_2))$」，取 $B_1=\operatorname{diag}(1,\lambda)$、$B_2=\operatorname{diag}(\lambda,1)$ 就立刻出错：两者各自的 $D_2$ 都是 $\lambda$，但

$$\operatorname{diag}(1,\lambda,\lambda,1)\ \text{的 Smith 形是}\ \operatorname{diag}(1,1,\lambda,\lambda),$$

它的 $D_2=1$——正是被 $i=j=1$ 那个交叉项 $D_1(B_1)D_1(B_2)=1\cdot1=1$ 拉下来的。

**结论（本步真正要用的）**：固定一个素因子 $\lambda-\lambda_0$，记它在 $B_1$ 的不变因子中的指数为 $a_1\le\cdots\le a_m$（整除链保证**非降**；不足处补 $0$），在 $B_2$ 中为 $b_1\le\cdots\le b_n$。则

$$v_p\big(D_k(B_1)\big)=a_1+\cdots+a_k,\qquad v_p\big(D_k(B_2)\big)=b_1+\cdots+b_k,$$

且 $k>m$ 时 $D_k(B_1)=0$（该拆分项在 gcd 中作废）。把 $(**)$ 的两边取 $v_p$，gcd 变成**逐点取小**：

$$c_k=\min_{i+j=k}\big(A_i+B_j\big),\qquad A_i=a_1+\cdots+a_i,\ B_j=b_1+\cdots+b_j .$$

$A,B$ 都是**凸**序列（增量 $a_i,b_j$ 非降），而凸序列的 min-plus 卷积仍是凸的，且其增量 $c_k-c_{k-1}$ 恰是两串增量**合并后按升序排列**：

$$(c_1,c_2,\dots)=\operatorname{sort}_{\uparrow}\big(a_1,\dots,a_m,\ b_1,\dots,b_n\big).$$

**验算这个结论**：取 $B_1=\operatorname{diag}(\lambda,\lambda^3)$（指数 $1,3$）、$B_2=[\lambda^2]$（指数 $2$）。升序归并得 $(0,1,2,3)$，即 $B_1\oplus B_2$ 的不变因子应为 $1,\lambda,\lambda^2,\lambda^3$——直接算 $\operatorname{diag}(\lambda,\lambda^3,\lambda^2)$ 的 Smith 形，确实是 $1,\lambda,\lambda^2,\lambda^3$ ✓（其 $D_k$ 的指数为 $0,1,3,6$，正是上式的累加）。

因为升序归并只是把两组指数**放在一起排序**，所以**指数为正的那些幂**（即初等因子）合起来就是多重集之并：

$$\text{初等因子}\big(\operatorname{diag}(B_1,B_2)\big)=\text{初等因子}(B_1)\ \uplus\ \text{初等因子}(B_2).$$

反复使用，得

$$\lambda I-J\cong\operatorname{diag}\Big(1,\dots,1,\ (\lambda-\lambda_1)^{n_1},\ \dots,\ (\lambda-\lambda_s)^{n_s}\Big),$$

其中 $1$ 的个数为 $n-s$。

*第三步：套定理 3.8.4 与定理 3.8.5。* $\lambda I-J$ 与 $\lambda I-A$ 都是 $n$ 阶满秩 $\lambda$ 矩阵（[例 3.8.3](sec38.md#ex-3.8.3)），秩同为 $n$；初等因子组按构造完全相同。由 [@thm-3.8.4]，$\lambda I-J\cong\lambda I-A$；再由 [@thm-3.8.5]，$A\sim J$。

**唯一性**。设 $A\sim J$ 且 $A\sim J'$，则 $\lambda I-J\cong\lambda I-A\cong\lambda I-J'$。相抵保持初等因子（定理 3.8.3），故 $J$ 与 $J'$ 的初等因子组相同；而 Jordan 块与初等因子一一对应（[例 3.8.5](#ex-3.8.5)、[注 9](#note-3.8-note9)），所以 $J$ 与 $J'$ 的块作为多重集相同，只可能相差块的**排列次序**。$\blacksquare$
:::

::: note 本编注 · 这条证明的逻辑状态（读了不会误以为全证完）{#note-3.8-logic-status}

上面的存在性证明有三步，其中两处依赖本页已建立的结果、一处依赖**标准结果**：

| 步骤 | 依据 | 状态 |
|:--|:--|:--|
| 单块的 Smith 形 | [例 3.8.5](#ex-3.8.5) | 本页已完整证明（上三角子式 $=\pm1$） |
| 对角块拼起来 | Cauchy–Binet $+$ 初等因子取并 | 本页已说明理由 |
| $\lambda I-J\cong\lambda I-A$ | [@thm-3.8.4] | 本页已完整证明 |
| $A\sim J$ | [@thm-3.8.5] | **必要性已证；充分性引用标准结果**（见该定理证明末尾的标注） |

**所以链条的形状是**：Jordan 存在性 $=$ 「Smith 形唯一」 $+$ 「初等因子 $=$ 完全不变量」 $+$ 「相似 $\iff$ 特征矩阵相抵（充分性为引用）」。前两条本页自足，第三条的充分性方向是 20 世纪初的标准定理。

**独立路线（不引用相似判别）**：可以用秩公式直接构造——对每个特征值 $\lambda_0$ 定义广义特征子空间 $V_k=N\big((A-\lambda_0I)^k\big)$，证明 $\mathbb C^n$ 是这些子空间（对各特征值）的直和，再在每个 $V_k$ 内从**最高阶**向量反推循环基，直接读出 Jordan 块与过渡矩阵。这条路就是 [@method-3.8-jordan] 路线 2 的理论版，本页在 [例 3.8.F](#ex-3.8.F) 里把它的操作层走了一遍。考试里若要求「求 $P$」，走的正是这条路。
:::
:::

::: note 本编注 · 「除块次序外唯一」的准确含义 {#note-3.8-unique-order}

定理说的是：Jordan 标准形在**同时允许重排块**的意义下唯一。若把某个特征值的两块 $J_2(1)$、$J_1(1)$ 写成 $J_1(1)\oplus J_2(1)$，这只是换了基的排列，仍然相似。但把 $J_2(1)\oplus J_1(1)$ 换成 $J_3(1)$ 就**不**相似——后者的初等因子是 $(\lambda-1)^3$，前者的初等因子是 $(\lambda-1)^2,\lambda-1$。**块的「分法」由初等因子固定，块的「顺序」才是自由的。**

为消除这个自由度，考试与教材通常约定：**按特征值从小到大（或按块阶数从大到小）排列**。约定之后，Jordan 标准形就完全唯一了。
:::

::: note 本编注 · 三个「重数」各管什么 {#note-3.8-three-multiplicities}

设 $\lambda_0$ 是 $A$ 的特征值。在 Jordan 标准形里，$\lambda_0$ 的信息被拆成三个数：

| 量 | 在 Jordan 形里的含义 | 怎么算 |
|:--|:--|:--|
| 代数重数 | 以 $\lambda_0$ 为对角元的**总阶数** | $f_A$ 中 $(\lambda-\lambda_0)$ 的幂次 |
| 几何重数 | 以 $\lambda_0$ 为对角元的**块的个数** | $n-\operatorname{rank}(A-\lambda_0I)$ |
| 最大块阶数 | 这些块中**最大**的阶 | $m_A$ 中 $(\lambda-\lambda_0)$ 的幂次，即 $d_n$ 中该因子的幂次 |

**可对角化 $\iff$ 几何重数 $=$ 代数重数 $\iff$ 最大块阶数 $=1$。** 这三行把 [3.6](sec36.md) 的重数不等式、[3.5](sec35.md) 的最小多项式与本节的 Jordan 块连成一张表：同一个缺陷，从三个角度看。
:::

::: ex 例 3.8.12（课件原文）· 求 Jordan 标准形与过渡矩阵 $P$ {#ex-3.8.12}

求 $A=\begin{bmatrix}-1&-2&6\\-1&0&3\\-1&-1&4\end{bmatrix}$ 的 Jordan 标准形 $J$，并求 $P$ 使得 $P^{-1}AP=J$。

::: sol 解答（课件原文；本编补「为什么第一次取的 $\boldsymbol p_2$ 不行」）

对矩阵 $A$ 的特征矩阵作初等变换，得

$$\lambda I-A\cong\begin{bmatrix}1&0&0\\0&\lambda-1&0\\0&0&(\lambda-1)^2\end{bmatrix}.$$

则 $\lambda I-A$ 的初等因子为 $\lambda-1,\ (\lambda-1)^2$，故 $A$ 的 Jordan 标准形为

$$J=\begin{bmatrix}1&0&0\\0&1&1\\0&0&1\end{bmatrix}.$$

记 $P=[\boldsymbol p_1,\boldsymbol p_2,\boldsymbol p_3]$，由 $A[\boldsymbol p_1,\boldsymbol p_2,\boldsymbol p_3]=[\boldsymbol p_1,\boldsymbol p_2,\boldsymbol p_3]J$ 逐列读出

$$\begin{cases}
A\boldsymbol p_1=\boldsymbol p_1,\\
A\boldsymbol p_2=\boldsymbol p_2,\\
A\boldsymbol p_3=\boldsymbol p_2+\boldsymbol p_3.
\end{cases}$$

由 $A\boldsymbol p_i=\boldsymbol p_i$ 解得两个线性无关的向量

$$\boldsymbol p_1=[3,0,1]^{\mathrm T},\qquad \boldsymbol p_2=[0,3,1]^{\mathrm T}.$$

将 $\boldsymbol p_2=[0,3,1]^{\mathrm T}$ 代入 $A\boldsymbol p_3=\boldsymbol p_2+\boldsymbol p_3$，此时**方程无解**。若将 $\boldsymbol p_1$ 和 $\boldsymbol p_2$ 调整顺序，定义 $\boldsymbol p_2=[3,0,1]^{\mathrm T}$，再代入，方程**仍无解**。

**思考（课件原文）**：为什么找不到可逆阵 $P$ 使得 $P^{-1}AP=J$？

**回答（课件原文）**：$\boldsymbol p_2$ 是 $A\boldsymbol p_i=\boldsymbol p_i$ 的任一非零解，之前选取的 $\boldsymbol p_2$ 不合适，应重新选取：

$$\boldsymbol p_2=k_1\begin{bmatrix}3\\0\\1\end{bmatrix}+k_2\begin{bmatrix}0\\3\\1\end{bmatrix}.$$

代入 $A\boldsymbol p_3=\boldsymbol p_2+\boldsymbol p_3$，得

$$\begin{bmatrix}-2&-2&6\\-1&-1&3\\-1&-1&3\end{bmatrix}\boldsymbol p_3
=k_1\begin{bmatrix}3\\0\\1\end{bmatrix}+k_2\begin{bmatrix}0\\3\\1\end{bmatrix}.$$

观察知 $\boldsymbol p_2$ 应表示为 $\boldsymbol p_2=k[2,1,1]^{\mathrm T}$。取 $k=1$，解方程组

$$k_1\begin{bmatrix}3\\0\\1\end{bmatrix}+k_2\begin{bmatrix}0\\3\\1\end{bmatrix}=\begin{bmatrix}2\\1\\1\end{bmatrix},$$

解得 $k_1=\tfrac23$、$k_2=\tfrac13$。这表明向量 $\boldsymbol p_2=[2,1,1]^{\mathrm T}$ 是合适的解。此时 $\boldsymbol p_1=[3,0,1]^{\mathrm T}$、$\boldsymbol p_2=[2,1,1]^{\mathrm T}$，解得 $\boldsymbol p_3=[-1,0,0]^{\mathrm T}$。因此

$$P=\begin{bmatrix}3&2&-1\\0&1&0\\1&1&0\end{bmatrix}.$$

**验算**：$\det P=1\ne0$；逐列核对 $A\boldsymbol p_1=\boldsymbol p_1=(3,0,1)^{\mathrm T}$、$A\boldsymbol p_2=\boldsymbol p_2=(2,1,1)^{\mathrm T}$、$A\boldsymbol p_3=(1,1,1)^{\mathrm T}=\boldsymbol p_2+\boldsymbol p_3$，即 $AP=PJ$ ✓。∎
:::
:::

::: note 本编注 · 挑选 $\boldsymbol p_2$ 的规则：它必须同时是特征向量与 $(A-I)$ 的像 {#note-3.8-chain-rule}

课件用「试两次都不行，再观察」的方式找到 $\boldsymbol p_2$。这个「观察」有明确的判别标准，可以一次到位。

要解 $A\boldsymbol p_3=\boldsymbol p_2+\boldsymbol p_3$，即

$$(A-I)\boldsymbol p_3=\boldsymbol p_2.$$

**方程有解 $\iff$ $\boldsymbol p_2\in R(A-I)$**（[3.1](sec31.md) 的可解判据）。而 $\boldsymbol p_2$ 本身又必须是特征向量：$\boldsymbol p_2\in N(A-I)$。所以

$$\boldsymbol p_2\in R(A-I)\cap N(A-I).$$

在本例中 $A-I=\begin{bmatrix}-2&-2&6\\-1&-1&3\\-1&-1&3\end{bmatrix}$，秩为 $1$：列空间 $R(A-I)=\operatorname{span}\{(2,1,1)^{\mathrm T}\}$，零空间 $N(A-I)=\operatorname{span}\{(3,0,1)^{\mathrm T},(0,3,1)^{\mathrm T}\}$。两者的交是一维的，生成元正是 $(2,1,1)^{\mathrm T}$——这就是「观察」到的那个向量。

**为什么随便取特征向量不行**：$\boldsymbol p_2=(0,3,1)^{\mathrm T}$ 虽然在 $N(A-I)$ 里，却不在 $R(A-I)$ 里，方程 $(A-I)\boldsymbol p_3=\boldsymbol p_2$ 无解，链就断了。几何上，Jordan 链 $\boldsymbol p_1,\boldsymbol p_2,\boldsymbol p_3$ 要求 $\boldsymbol p_2=(A-I)\boldsymbol p_3$、$\boldsymbol p_1=(A-I)\boldsymbol p_2$——**除链头外，每个向量都必须落在前一个映射的像里**。

**一般算法（本编补）**：对每个 Jordan 块，从**最高阶**的广义特征向量开始反推：先解 $(A-\lambda I)^{s}\boldsymbol v=0$ 且 $(A-\lambda I)^{s-1}\boldsymbol v\ne0$，再令 $\boldsymbol v_{s-1}=(A-\lambda I)\boldsymbol v$、$\boldsymbol v_{s-2}=(A-\lambda I)\boldsymbol v_{s-1},\dots$。这样倒着走，每一步都在像里，不会出现「无解」。
:::

::: method 方法 · 求 Jordan 标准形的两条路线 {#method-3.8-jordan}

**路线 1（Smith 形 / 初等因子）**——适合阶数小、或题目已给 Smith 形：

1. 作初等变换把 $\lambda I-A$ 化成 Smith 形 $\operatorname{diag}(d_1,\dots,d_n)$；
2. 把 $d_i$ 分解成素因子幂，得初等因子组（重复计数）；
3. 每个初等因子 $(\lambda-\lambda_0)^s$ 写一个 $s$ 阶块 $J_s(\lambda_0)$；
4. 拼成 $J=\operatorname{diag}(J_1,\dots,J_s)$。

**路线 2（秩公式 / 零空间）**——适合只问块结构、或要顺便求 $P$：

对每个特征值 $\lambda_0$，算 $n_k=\dim N\big((A-\lambda_0I)^k\big)$，$k=1,2,\dots$（到稳定为止）。则

$$\#\{\text{阶数}\ge k\text{ 的块}\}=n_k-n_{k-1},\qquad
\#\{\text{阶数恰为 }k\text{ 的块}\}=2n_k-n_{k-1}-n_{k+1}.$$

由此读出该特征值的全部块阶数；再用 [@note-3.8-chain-rule] 的「从高阶往低阶解」法求 $P$。

**两条路线的对账**：路线 2 的「块数」应等于路线 1 的「该特征值的初等因子个数」，最大块阶应等于「$m_A$ 中该因子的幂次」。对不上就是算错。
:::

::: ex 例 3.8.F（新增）· 秩公式定块结构并求 $P$ {#ex-3.8.F}

设

$$A=\begin{bmatrix}2&1&1&0\\0&2&0&1\\0&0&2&1\\0&0&0&2\end{bmatrix}.$$

求 $A$ 的 Jordan 标准形 $J$ 与可逆阵 $P$ 使 $P^{-1}AP=J$。

::: sol 解答

**第一步：特征值。** 上三角，对角元全为 $2$，故 $f_A(\lambda)=(\lambda-2)^4$，唯一特征值 $\lambda_0=2$。

**第二步：秩公式。** 记 $N=A-2I=\begin{bmatrix}0&1&1&0\\0&0&0&1\\0&0&0&1\\0&0&0&0\end{bmatrix}$。逐次算秩：

- $\operatorname{rank}N=2$（第 $1$、$2$ 行线性无关），故 $n_1=4-2=2$；
- $N^2=\begin{bmatrix}0&0&0&1\\0&0&0&0\\0&0&0&0\\0&0&0&0\end{bmatrix}$，$\operatorname{rank}N^2=1$，故 $n_2=3$；
- $N^3=O$，$n_3=4$；$n_4=4$。

于是块的个数 $=n_1=2$；阶数 $\ge2$ 的块数 $=n_2-n_1=1$；阶数 $\ge3$ 的块数 $=n_3-n_2=1$。故两块，阶数分别为 $3$ 与 $1$：

$$J=\begin{bmatrix}2&1&0&0\\0&2&1&0\\0&0&2&0\\0&0&0&2\end{bmatrix}.$$

**第三步：求 $P$。** 按 [@note-3.8-chain-rule] 的规则，链必须从「落在像里的那个向量」开始。这里 $N=A-2I$ 的列空间是 $R(N)=\operatorname{span}\{(1,0,0,0)^{\mathrm T},(0,1,1,0)^{\mathrm T}\}$，而 $(1,0,0,0)^{\mathrm T}$ 同时属于 $N(N)$，正好可选作链头。取 $\boldsymbol p_1=(1,0,0,0)^{\mathrm T}$，然后顺着链**向前**解

$$N\boldsymbol p_2=\boldsymbol p_1,\qquad N\boldsymbol p_3=\boldsymbol p_2.$$

（顺着解与「从最高阶反推」是同一件事的两种操作：反推法先定链尾 $\boldsymbol p_3$ 再逐次取像；顺解法先定链头 $\boldsymbol p_1$ 再逐次解方程。**关键是链头必须选在 $N(N)\cap R(N)$ 里**，否则第一步就无解——这正是例 3.8.12 第一次失败的原因。）

第一式：$N\boldsymbol p_2=(p_{22}+p_{23},\ p_{24},\ p_{24},\ 0)^{\mathrm T}=(1,0,0,0)^{\mathrm T}$，取 $\boldsymbol p_2=(0,\tfrac12,\tfrac12,0)^{\mathrm T}$。

第二式：$N\boldsymbol p_3=(p_{32}+p_{33},\ p_{34},\ p_{34},\ 0)^{\mathrm T}=(0,\tfrac12,\tfrac12,0)^{\mathrm T}$，得 $p_{34}=\tfrac12$、$p_{32}+p_{33}=0$，取 $\boldsymbol p_3=(0,-\tfrac12,\tfrac12,\tfrac12)^{\mathrm T}$。

最后补一个与 $\boldsymbol p_1$ 线性无关的特征向量（$1$ 阶块）：$\boldsymbol p_4=(0,1,-1,0)^{\mathrm T}$。

$$P=[\boldsymbol p_1,\boldsymbol p_2,\boldsymbol p_3,\boldsymbol p_4]
=\begin{bmatrix}1&0&0&0\\0&\tfrac12&-\tfrac12&1\\0&\tfrac12&\tfrac12&-1\\0&0&\tfrac12&0\end{bmatrix}.$$

**验算**：$\det P=\tfrac12\ne0$；逐列核对 $A\boldsymbol p_1=2\boldsymbol p_1$、$A\boldsymbol p_2=\boldsymbol p_1+2\boldsymbol p_2$、$A\boldsymbol p_3=\boldsymbol p_2+2\boldsymbol p_3$、$A\boldsymbol p_4=2\boldsymbol p_4$，即 $AP=PJ$ ✓。

**对账**：初等因子为 $(\lambda-2)^3$ 与 $\lambda-2$（可由 [@method-3.8-jordan] 路线 1 复算），故 $m_A=(\lambda-2)^3$，与「最大块阶 $=3$」一致。∎
:::
:::

::: ex 例 3.8.13（课件原文）· 由初等因子读最小多项式 {#ex-3.8.13}

求矩阵

$$A=\begin{bmatrix}3&&&&\\&3&1&&\\&&3&1&\\&&&3\end{bmatrix}$$

的最小多项式。

::: sol 解答（课件原文）

矩阵 $\lambda I-A$ 的初等因子为

$$\lambda-3,\qquad(\lambda-3)^3.$$

这也是对应两个 Jordan 块的最小多项式。故 $A$ 的最小多项式为

$$m_A(\lambda)=(\lambda-3)^3. \qquad\blacksquare$$
:::
:::

这个例子把「最小多项式 $=$ 初等因子的最小公倍式」用到了极致：两个块的最小多项式分别是 $(\lambda-3)^1$ 与 $(\lambda-3)^3$，取最小公倍式（即**指数最大**的那个）得 $(\lambda-3)^3$。若错误地把两者相乘，会得到 $(\lambda-3)^4$——次数超过了 $A$ 的阶数 $4$，一眼可辨。

::: thm 定理 3.8.6（课件原文）· Frobenius 定理 {#thm-3.8.6}

设 $A\in\mathbb C^{n\times n}$，其特征矩阵 $\lambda I-A$ 的 Smith 标准形为 $\operatorname{diag}\big(d_1(\lambda),\dots,d_n(\lambda)\big)$，则 $A$ 的最小多项式

$$m_A(\lambda)=d_n(\lambda).$$

::: proof 证明（本编补）

设 $\lambda I-A$ 的初等因子组为 $\big\{(\lambda-\lambda_j)^{e}\big\}$。对每个特征值 $\lambda_j$，记 $E_j=\max\{e:(\lambda-\lambda_j)^e\ \text{是初等因子}\}$。

**第一步：$m_A=\prod_j(\lambda-\lambda_j)^{E_j}$。** 最小多项式是「零化 $A$ 的次数最低的首 $1$ 多项式」。$A$ 相似于 Jordan 形 $J=\operatorname{diag}(J_1,\dots,J_s)$（[定理 3.8.5′](#thm-3.8.5j)），而多项式对相似矩阵的零化性不变，故 $m_A$ 是「同时零化所有块」的最低次首 $1$ 多项式。块 $J_i$ 的最小多项式是 $(\lambda-\lambda_i)^{n_i}$（[例 3.8.10](#ex-3.8.10)），故 $m_A$ 必须被每个 $(\lambda-\lambda_i)^{n_i}$ 整除，最低次者就是它们的最小公倍式：

$$m_A(\lambda)=\operatorname{lcm}_i(\lambda-\lambda_i)^{n_i}=\prod_j(\lambda-\lambda_j)^{E_j}.$$

**第二步：$d_n=\prod_j(\lambda-\lambda_j)^{E_j}$。** 不变因子满足整除链 $d_1\mid\cdots\mid d_n$，故对每个素因子 $\lambda-\lambda_j$，它在 $d_1,\dots,d_n$ 中的指数是**非降**的；初等因子恰是这些指数的「正部分」。于是最大的指数 $E_j$ 一定出现在 $d_n$ 中，且 $d_n$ 不再含更高的幂。对所有 $j$ 相乘即得。

两步合起来：$m_A=d_n$。$\blacksquare$
:::
:::

::: note 注 10（课件原文）· 最小公倍式的说法 {#note-3.8-note10}

$\lambda I-A$ 的初等因子的最小公倍式，即为矩阵 $A$ 的最小多项式 $m_A(\lambda)$。
:::

::: note 本编注 · 这条定理把 3.5 与 3.8 接上了 {#note-3.8-frobenius-link}

[3.5.4](sec35.md#sec-3.5.4) 的最小多项式是靠「候选法」试出来的（$f_A$ 的因式逐个试），[3.8](sec38.md) 上半页则把 $\lambda I-A$ 摆上了台面。Frobenius 定理给出第三条路：

$$m_A(\lambda)=d_n(\lambda)=\frac{D_n(\lambda)}{D_{n-1}(\lambda)}=\frac{f_A(\lambda)}{D_{n-1}(\lambda)}.$$

**用法**：只要求最小多项式，不必完整化 Smith 形——算出 $D_{n-1}$（全部 $n-1$ 阶子式的首 $1$ 最大公因式），一次除法即得。对 $3\times3$、$4\times4$ 的题，这比候选法更省。

**与可对角化的关系**：$A$ 单纯 $\iff$ $m_A$ 无重根 $\iff$ $d_n$ 无重根 $\iff$ 初等因子全一次（推论 3.8.3、3.8.4）。四个说法同值。
:::

::: ex 例 3.8.G（新增）· 用 Jordan 形算幂与矩阵指数 {#ex-3.8.G}

设 $A=J_3(2)=\begin{bmatrix}2&1&0\\0&2&1\\0&0&2\end{bmatrix}$。求 $A^m$（$m$ 为正整数）与 $e^{At}$。

::: sol 解答

**第一步：拆成「数量阵 $+$ 幂零阵」。** $A=2I+N$，其中 $N=\begin{bmatrix}0&1&0\\0&0&1\\0&0&0\end{bmatrix}$，$N^2=\begin{bmatrix}0&0&1\\0&0&0\\0&0&0\end{bmatrix}$，$N^3=O$。$2I$ 与 $N$ 交换，故二项式定理可用：

$$A^m=(2I+N)^m=\sum_{k=0}^{m}\binom{m}{k}2^{m-k}N^k
=\begin{bmatrix}
2^m&m2^{m-1}&\binom{m}{2}2^{m-2}\\[2pt]
0&2^m&m2^{m-1}\\[2pt]
0&0&2^m
\end{bmatrix},$$

其中 $\binom{m}{2}2^{m-2}=0$ 当 $m\lt2$（按组合数约定）。

**第二步：矩阵指数。** 同理

$$e^{At}=e^{2tI+tN}=e^{2t}e^{tN}
=e^{2t}\left(I+tN+\frac{t^2}{2}N^2\right)
=e^{2t}\begin{bmatrix}1&t&\tfrac{t^2}{2}\\[2pt]0&1&t\\[2pt]0&0&1\end{bmatrix}.$$

**验算（$m=5$）**：公式给

$$A^5=\begin{bmatrix}32&5\cdot16=80&\binom52\cdot8=80\\0&32&80\\0&0&32\end{bmatrix};$$

直接乘 $A^2=\begin{bmatrix}4&4&1\\0&4&4\\0&0&4\end{bmatrix}$、$A^4=\begin{bmatrix}16&32&24\\0&16&32\\0&0&16\end{bmatrix}$、$A^5=A^4A=\begin{bmatrix}32&80&80\\0&32&80\\0&0&32\end{bmatrix}$ ✓。∎
:::
:::

::: note 本编注 · $t^ke^{\lambda t}$ 是从哪里冒出来的 {#note-3.8-tkexp}

[3.7](sec37.md) 的回忆卡曾问：非单纯矩阵的矩阵指数为什么会多出 $t^ke^{\lambda t}$ 项？现在有了完整答案。

对 Jordan 块 $J_s(\lambda)$，

$$e^{J_s(\lambda)t}=e^{\lambda t}\sum_{k=0}^{s-1}\frac{t^k}{k!}N^k
=e^{\lambda t}\begin{bmatrix}
1&t&\dfrac{t^2}{2!}&\cdots&\dfrac{t^{s-1}}{(s-1)!}\\
&1&t&\ddots&\vdots\\
&&\ddots&\ddots&\dfrac{t^2}{2!}\\
&&&1&t\\
&&&&1
\end{bmatrix}.$$

**幂零部分是 $t$ 的多项式，指数部分是 $e^{\lambda t}$**——两者相乘就是 $t^ke^{\lambda t}$。幂零指数 $s$ 越大，多项式的次数越高；$s=1$（可对角化）时多项式退化为常数，只剩纯指数项。

这也解释了为什么 [3.7](sec37.md) 的谱分解 $e^{At}=\sum_j e^{\lambda_jt}E_j$ 只对**单纯**矩阵成立：谱阵是投影，投影的任意次幂还是自身，产生不了 $t$ 的因子；一旦有 Jordan 块，就必须换成「块对角 $+$ 幂零展开」的算法。
:::

<a id="sec-3.8.11b"></a>

## 3.8.11 小结与常见错误

<div class="widget" data-widget="smith-jordan">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">把一整条流水线走完：λ 矩阵 → Smith 形 → 初等因子 → Jordan 形</strong></p>
<p class="widget-hint">先选一个矩阵，再按「下一步」逐步走：<b>λI−A</b> → <b>行列式因子</b> → <b>Smith 形</b> → <b>初等因子</b> → <b>Jordan 形</b> → <b>三个重数</b>。三个矩阵各埋了一个坑：第一个的 Smith 形<b>不是</b>特征值对角阵；第二个只有一个非平凡不变因子却有<b>两个</b>块；第三个的同一个特征值对应<b>两个不同阶</b>的块。每步下面的说明都在解释「这一步为什么会这样」。</p>
</div>

::: note 一张表：五种「多项式数据」各自记什么 {#note-3.8-data-table}

| 对象 | 定义位置 | 记的是什么 | 在 Jordan 形里对应什么 |
|:--|:--|:--|:--|
| 特征多项式 $f_A$ | [3.5](sec35.md) | 特征值 $+$ 代数重数 | 全部对角元（含重复） |
| 最小多项式 $m_A=d_n$ | [@thm-3.8.6] | 特征值 $+$ **最大块阶数** | 每块的最小零化多项式之 lcm |
| 行列式因子 $D_k$ | [@def-3.8.5] | 全部 $k$ 阶子式的公因子 | $D_k=d_1\cdots d_k$ |
| 不变因子 $d_i$ | [@def-3.8.6] | $D_k/D_{k-1}$，整除链 | 块的「累积账本」 |
| 初等因子 | [@def-3.8.7] | $d_i$ 的素因子幂（多重集） | **一块一个**，阶数 $=$ 幂次 |

**一句话**：$f_A$ 记「有几个特征值」，$m_A$ 记「最大的块多大」，初等因子记「每一块多大」，三者层层细化。
:::

::: note 三句话带走 {#note-3.8-three-takeaways}

1. **Smith 标准形是 $\lambda$ 矩阵的「相抵身份证」**：$d_1\mid\cdots\mid d_r$，$D_k=d_1\cdots d_k$，唯一且可算（[@thm-3.8.2]、[@cor-3.8.1]、[@note-3.8-dk-smith]）。
2. **相似 $=$ 特征矩阵相抵**：$A\sim B\iff\lambda I-A\cong\lambda I-B$；对特征矩阵，「初等因子相同」一个条件就够，因为秩自动相同（[@thm-3.8.5]、[@method-3.8-similar-chain]）。
3. **Jordan 标准形 $=$ 初等因子的可视化**：每个初等因子 $(\lambda-\lambda_0)^s$ 画一个 $s$ 阶块；块的分法唯一，块的顺序自由（[@thm-3.8.5j]、[@note-3.8-unique-order]）。
:::

::: think 常见错误清单 · 自查七条 {#think-3.8-mistakes}

1. **把「对角阵」当 Smith 标准形**：对角元必须首 $1$ 且满足整除链；$\operatorname{diag}(\lambda-1,(\lambda-1)(\lambda-2),(\lambda-2)^2)$ 不是（[例 3.8.E](#ex-3.8.E)）。
2. **把可约的对角元当初等因子**：初等因子必须是**素因子的幂**；$(\lambda-1)(\lambda-2)$ 要拆成两个。
3. **反装不变因子时把指数排反**：同一素因子的幂要**从大到小**分配给 $d_r,d_{r-1},\dots$（[@note-3.8-assemble]）。
4. **以为同秩就相抵**：$\operatorname{diag}(\lambda,\lambda)$ 与 $\operatorname{diag}(1,\lambda^2)$ 同秩不相抵（[例 3.8.7](#ex-3.8.7)）。
5. **以为初等因子相同就相抵**：还要加「秩相同」；$\operatorname{diag}(0,\lambda)$ 与 $\operatorname{diag}(1,\lambda)$ 是反例（[例 3.8.8](#ex-3.8.8)）。
6. **在相似判别里「代 $\lambda=A$」**：矩阵多项式代入不是环同态；正确做法是把等式改写成「$\lambda I-B$ 左乘多项式矩阵」的形式再比较次数（[@note-3.8-eval-trap]）。
7. **求 $P$ 时随便取特征向量当 $\boldsymbol p_2$**：$\boldsymbol p_2$ 必须在 $R(A-\lambda I)\cap N(A-\lambda I)$ 里；正确做法是从最高阶广义特征向量反推（[@note-3.8-chain-rule]）。
:::

::: ex 即时自测（不看上文，8 分钟）{#ex-3.8-lower-quiz}

1. 写出 $k$ 阶行列式因子 $D_k$、不变因子 $d_i$、初等因子的定义，并写出三者的换算关系；
2. 求 $A(\lambda)=\operatorname{diag}\big(\lambda^2,\ \lambda(\lambda+1),\ (\lambda+1)^2\big)$ 的不变因子、初等因子与 Smith 标准形；
3. 设 $\lambda I-A\cong\operatorname{diag}(1,1,\lambda-2,(\lambda-2)^2(\lambda+3))$，写出 $A$ 的 Jordan 标准形与最小多项式；
4. 证明：$A\sim B\iff\lambda I-A\cong\lambda I-B$ 的「$\Leftarrow$」方向（写出「换成伴随矩阵 $\to$ 比较次数」的关键两步）；
5. 设 $A=J_2(1)\oplus J_1(1)$，求 $A^m$ 与 $e^{At}$，并说明 $t$ 的幂次由什么决定。

::: sol 参考要点

1. 见 [@def-3.8.5]、[@def-3.8.6]、[@def-3.8.7]；换算：$D_k=d_1\cdots d_k$，$d_k=D_k/D_{k-1}$，初等因子是 $d_i$ 分解出的素因子幂（指数 $>0$）。
2. 三个对角元**不满足**整除链（$\lambda^2\nmid\lambda(\lambda+1)$），故它不是 Smith 标准形。按定义算：$D_1=1$（$\lambda^2$ 与 $(\lambda+1)^2$ 互素）、$D_2=\lambda(\lambda+1)$、$D_3=\lambda^3(\lambda+1)^3$，于是 $d_1=1$、$d_2=\lambda(\lambda+1)$、$d_3=\lambda^2(\lambda+1)^2$。初等因子：$\lambda,\ \lambda+1,\ \lambda^2,\ (\lambda+1)^2$。Smith 形 $\operatorname{diag}\big(1,\ \lambda(\lambda+1),\ \lambda^2(\lambda+1)^2\big)$。
3. 秩 $4$，初等因子 $\lambda-2$、$(\lambda-2)^2$、$\lambda+3$，故 $J=J_1(2)\oplus J_2(2)\oplus J_1(-3)$，即 $\operatorname{diag}\big([2],\begin{bmatrix}2&1\\0&2\end{bmatrix},[-3]\big)$（按块序可重排）；$m_A=(\lambda-2)^2(\lambda+3)=d_4$。
4. 写法见 [@thm-3.8.5] 的证明。骨架：由 $\det Q$ 是非零常数得 $Q^{-1}=Q^*/q$；两边右乘得 $(\lambda I-B)Q^*=qP(\lambda I-A)$，此时左右各含一个首系数为单位阵的一次因子，次数可靠；比较最高次系数得首系数关系，逐层剥掉，降到常数矩阵 $P_0,Q_0$；最后比较 $\lambda$ 的系数与常数项得 $I=P_0Q_0$、$B=P_0AP_0^{-1}$。**不要**走「对 $P$ 作带余除法」那条路——它默认了「$P_0Q_d\ne O$」，而矩阵有零因子。
5. $A=\operatorname{diag}\big(\begin{bmatrix}1&1\\0&1\end{bmatrix},[1]\big)$。$J_2(1)^m=\begin{bmatrix}1&m\\0&1\end{bmatrix}$，故 $A^m=\operatorname{diag}\big(\begin{bmatrix}1&m\\0&1\end{bmatrix},[1]\big)$；$e^{At}=\operatorname{diag}\big(\begin{bmatrix}e^t&te^t\\0&e^t\end{bmatrix},[e^t]\big)$。$t$ 的幂次由最大 Jordan 块的阶数（$=$ 最小多项式中该特征值的重数）决定：这里最大块为 $2$ 阶，故最高只到 $t^1$。
:::
:::

> **下一站**：第三章的矩阵分解到此收束——相抵（3.1）、满秩（3.2）、QR（3.4）、Schur（3.5）、对角化（3.6）、谱分解（3.7）、Jordan（3.8）。下一批素材到位后接奇异值分解与广义逆：前者把「两组标准正交基」同时用上，后者把「不可逆」也纳入可计算的框架。本章的[总结](summary.md)与[考场竞技场](arena.md)已经把 3.8 下半的新增考点并进去。
