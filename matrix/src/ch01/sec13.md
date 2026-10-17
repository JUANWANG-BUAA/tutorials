# 1.3 基与坐标

线性空间一旦有了「不含冗余的生成组」——**基**——每个向量就获得唯一的「编号」：**坐标**。本节就沿这条线索展开：先为「冗余」下定义（线性相关性），再据此建立基、坐标、极大无关组、维数与过渡矩阵，并证明两条大定理（唯一表示、维数公式）；最后以课件[@ex-1.3.6] 的勘误重解收尾，示范「和与交」的标准算法。

::: preview 先抓住一件事

贯穿本节的一对要求是：**既要能表示全部向量，又不要携带冗余。**「张成」保证够用，「线性无关」排除多余；两者同时成立就是基，唯一表示由此而来，坐标就是那组唯一系数。
:::

<a id="sec-1.3.1"></a>

## 1.3.1 线性相关与线性无关

1.2 节判断「能不能生成」，靠的是线性方程组有没有解。现在换一个问题：**这组向量本身有没有多余的方向？**回答它只需看零向量能由这组向量写出多少种表示——用零组合去试探冗余，得到的就是线性相关与线性无关。

::: def 定义 1.3.1 · 线性相关与线性无关 linear dependence / independence {#def-1.3.1}

设 $V$ 是 $F$ 上的线性空间，$\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 是 $V$ 中一组向量。若向量方程

$$k_1\boldsymbol{\alpha}_1+\cdots+k_n\boldsymbol{\alpha}_n=\boldsymbol{\theta},\qquad k_i\in F$$

只有平凡解，即 $k_1=k_2=\cdots=k_n=0$，则称向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ **线性无关**；否则（存在不全为零的解）称向量组 **线性相关**。

:::

用定义判定并不顺手。下面的等价刻画把「相关」翻译成一句几何直觉更强的话：

**等价刻画（$n\geq2$ 时）：**向量组线性相关 $\Longleftrightarrow$ 组中**某个**向量可由其余向量线性表示。

::: proof 证

「$\Longrightarrow$」设相关，取一组不全为零的系数 $k_1,\cdots,k_n$，其中不妨 $k_i\neq0$，则移项得

$$\boldsymbol{\alpha}_i=-\frac{k_1}{k_i}\boldsymbol{\alpha}_1-\cdots-\frac{k_{i-1}}{k_i}\boldsymbol{\alpha}_{i-1}-\frac{k_{i+1}}{k_i}\boldsymbol{\alpha}_{i+1}-\cdots-\frac{k_n}{k_i}\boldsymbol{\alpha}_n,$$

即 $\boldsymbol{\alpha}_i$ 可由其余表示。「$\Longleftarrow$」设 $\boldsymbol{\alpha}_i=k'_1\boldsymbol{\alpha}_1+\cdots+k'_{i-1}\boldsymbol{\alpha}_{i-1}+k'_{i+1}\boldsymbol{\alpha}_{i+1}+\cdots+k'_n\boldsymbol{\alpha}_n$，则

$$k'_1\boldsymbol{\alpha}_1+\cdots+(-1)\boldsymbol{\alpha}_i+\cdots+k'_n\boldsymbol{\alpha}_n=\boldsymbol{\theta}$$

是系数不全为零（$\boldsymbol{\alpha}_i$ 的系数为 $-1$）的表示，故相关。

:::

<figure aria-labelledby="fig-depend-caption" class="concept-figure" data-figure="FIG. 1–05">
<svg aria-labelledby="fig-depend-title fig-depend-desc" role="img" viewBox="0 0 680 280">
<title id="fig-depend-title">线性无关与线性相关的几何对照</title>
<desc id="fig-depend-desc">左侧两向量不共线，可张成平面；右侧两向量共线，后者是前者的倍数，只张成直线。</desc>
<defs>
<marker id="dep-arrow-a" markerHeight="6" markerWidth="6" orient="auto-start-reverse" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker>
<marker id="dep-arrow-s" markerHeight="6" markerWidth="6" orient="auto-start-reverse" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--sage)"></path></marker>
</defs>
<line class="diagram-axis" x1="340" x2="340" y1="34" y2="246"></line>
<text class="diagram-mono" x="56" y="42">INDEPENDENT</text><text class="diagram-text" x="56" y="65">线性无关</text>
<path class="diagram-fill-sage" d="M74 222 L272 222 L238 92 L74 222 Z"></path>
<line class="diagram-accent" marker-end="url(#dep-arrow-a)" x1="74" x2="266" y1="222" y2="222"></line>
<line class="diagram-sage" marker-end="url(#dep-arrow-s)" x1="74" x2="235" y1="222" y2="96"></line>
<text class="diagram-note" x="56" y="258">没有冗余，张成一个平面</text>
<text class="diagram-mono" x="390" y="42">DEPENDENT</text><text class="diagram-text" x="390" y="65">线性相关</text>
<line class="diagram-muted" x1="390" x2="626" y1="222" y2="88"></line>
<line class="diagram-accent" marker-end="url(#dep-arrow-a)" x1="406" x2="516" y1="213" y2="151"></line>
<line class="diagram-sage" marker-end="url(#dep-arrow-s)" x1="406" x2="610" y1="213" y2="97"></line>
<text class="diagram-mono" x="468" y="204">α₁</text><text class="diagram-mono" x="572" y="135">α₂=2α₁</text>
<text class="diagram-note" x="390" y="258">一个方向多余，仍只张成直线</text>
</svg>
<figcaption id="fig-depend-caption"><b>判断的本质是「有无冗余」。</b>无关组的每个方向都带来新的自由度；相关组中至少有一个向量没有增加新方向。</figcaption>
</figure>

在把相关性用于判定之前，先把两条最常用的事实固定下来。

::: thm 注 1 与注 2 · 相关性的两条基本事实

**注 1。**单个零向量线性相关（$1\cdot\boldsymbol{\theta}=\boldsymbol{\theta}$ 是非平凡表示）；单个非零向量线性无关（若 $k\boldsymbol{\alpha}=\boldsymbol{\theta}$ 且 $\boldsymbol{\alpha}\neq\boldsymbol{\theta}$，由 [1.1](sec11.md) 节注 1(4) 只能 $k=0$）。**推论：含零向量的向量组必线性相关。**

**注 2。**线性无关向量组的任一**部分组**（子集）是线性无关的；线性相关向量组的任一**扩集**仍是线性相关的。

::: proof 注 2 的证明

设 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 无关，取其部分组（不妨记 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_r,\ r\leq n$）。若该部分组相关，则有不全为零的 $k_1,\cdots,k_r$ 使 $k_1\boldsymbol{\alpha}_1+\cdots+k_r\boldsymbol{\alpha}_r=\boldsymbol{\theta}$；补上 $k_{r+1}=\cdots=k_n=0$，得到全组的一个非平凡零组合，与全组无关矛盾。故部分组无关。后半句：若 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 相关，其非平凡零组合直接看作扩大后向量组的零组合（新增向量系数取 $0$），故扩集相关。

:::

:::

::: note

**两句口语化翻译。**「相关 = 有冗余（某个向量可由其余向量表示）」「无关 = 零向量的表示方式只有平凡一种」。做证明时先想这两句。

:::

<a id="sec-1.3.2"></a>

## 1.3.2 相关性判定例题：数域的影响与 Casorati 行列式

相关与无关不只取决于向量组本身，还取决于「在哪个数域上讨论」与「向量长什么样」。下面两个例题分别把这两点说透。

::: ex 例 1.3.1 · 相关性依赖数域 {#ex-1.3.1}

考查定义在 $\mathbb{C}$ 上的线性空间 $\mathbb{C}$，讨论空间中向量 $i$ 和向量 $1$ 的线性相关性。

::: sol 解答

考查方程 $k_1\cdot i+k_2\cdot 1=\boldsymbol{\theta}$，$k_1,k_2\in\mathbb{C}$。取 $k_1=-1,\ k_2=i$，直接代入得 $(-1)\,i+i\cdot 1=-i+i=0$；系数不全为零，所以向量 $i$ 和向量 $1$ 线性**相关**。

**思考：若定义在 $\mathbb{R}$ 上的线性空间 $\mathbb{C}$ 呢？**此时 $k_1,k_2$ 只能取实数。由 $k_1 i+k_2=0$：比较实部与虚部得 $k_2=0$ 与 $k_1=0$，方程在实数域上仅有平凡解，即向量 $i$ 和向量 $1$ 线性**无关**。

:::

::: note

同一组对象，数域从 $\mathbb{R}$ 换成 $\mathbb{C}$，相关性结论就翻转——这正是 1.1 节读线性空间定义时提醒过的「换个数域，结论可能变」。所以「线性相关性」永远是相对数域 $F$ 而言的性质，写结论时要先交代在哪个数域上。

:::

:::

下一例把战场挪到信号空间：那里的「向量」是无穷长的序列，写不成有限维数组，判定需要一件专门的工具。

::: ex 例 1.3.2 · 信号空间与 Casorati 行列式 {#ex-1.3.2}

设信号子空间 $W=\operatorname{span}\{x_k,\,y_k,\,z_k\}$，其中 $x_k=(-1)^k,\ y_k=2^k,\ z_k=3^k$。试判断信号 $x_k,y_k,z_k$ 的线性相关性。

::: sol 解答

设 $l_1x_k+l_2y_k+l_3z_k=0$（对**所有** $k=0,\pm1,\pm2,\cdots$ 成立）。分别取 $k,k+1,k+2$ 三个下标，得线性方程组

$$\begin{pmatrix}x_k&y_k&z_k\\ x_{k+1}&y_{k+1}&z_{k+1}\\ x_{k+2}&y_{k+2}&z_{k+2}\end{pmatrix}\begin{pmatrix}l_1\\l_2\\l_3\end{pmatrix}=\begin{pmatrix}0\\0\\0\end{pmatrix},\qquad \forall k,$$

其中的系数矩阵称为信号组 $x_k,y_k,z_k$ 的 **Casorati 矩阵**，其行列式称为 **Casorati 行列式**。

取 $k=0$，Casorati 矩阵为

$$C=\begin{pmatrix}1&1&1\\ -1&2&3\\ 1&4&9\end{pmatrix},\qquad \det C=1(2\cdot9-3\cdot4)-1\big((-1)\cdot9-3\cdot1\big)+1\big((-1)\cdot4-2\cdot1\big)=6+12-6=12\neq0,$$

该矩阵可逆，齐次方程组只有零解 $l_1=l_2=l_3=0$。因此信号 $x_k,y_k,z_k$ 线性无关。

:::

::: method 方法 · Casorati 判定（只此一个方向可用）

**这个工具从哪来？**学过常微分方程的同学可能见过**朗斯基行列式**（Wronskian）：把 $m$ 个解函数连同各阶导数拼成方阵，用行列式探测相关性。Casorati 行列式是它的**离散版**——「求导」换成「移位」：把 $m$ 个信号在连续 $m$ 个下标 $k,k+1,\cdots,k+m-1$ 处的取值按行拼成方阵（即 Casorati 矩阵）。两者的使用规则也一致：都只有「行列式非零 ⟹ 无关」这一个方向可用。

**为什么这个方向可用（证明）。**设信号组 $u^{(1)}_k,\cdots,u^{(m)}_k$ 线性相关，则存在不全为零的 $l_1,\cdots,l_m$ 使组合成为零信号，即对**每个**下标 $k$ 都有 $\sum_j l_j u^{(j)}_k=0$。固定任一 $k$，把这组等式在 $k,k+1,\cdots,k+m-1$ 处逐行写出，正是 $C(k)\boldsymbol{l}=\boldsymbol{0}$（$C(k)$ 为该处的 Casorati 矩阵）：齐次方程组有非零解 $\boldsymbol{l}$，故 $\det C(k)=0$。逆否命题：

$$\text{若存在某个 }k_0\text{ 使 Casorati 行列式}\neq0\ \Longrightarrow\ \text{信号组线性无关}.$$

**反方向为什么不可用（反例）。**取脉冲信号 $x=e^{(0)}$（仅在 $k=0$ 处取 $1$，记号在例 1.3.4 正式登场）与 $y=e^{(0)}+e^{(2)}$（仅在 $k=0,2$ 处取 $1$）。若 $ax+by$ 是零信号，在 $k=0$ 处读出 $a+b=0$，在 $k=2$ 处读出 $b=0$，得 $a=b=0$：两信号线性**无关**。但 $2\times2$ Casorati 行列式 $x_ky_{k+1}-y_kx_{k+1}$ 对**一切** $k$ 为零：$k\notin\{-1,0\}$ 时 $x_k=x_{k+1}=0$，行列式第一列全零；$k=-1$ 时 $x_{-1}y_0-y_{-1}x_0=0\cdot1-0\cdot1=0$；$k=0$ 时 $x_0y_1-y_0x_1=1\cdot0-1\cdot0=0$。原因很直观：Casorati 只窥探宽度为 $2$ 的相邻窗口，这两个脉冲的「活动时刻」彼此错开，任何窗口里都至多看到一个非零信号。此外 $\mathbb{R}^n$ / $\mathbb{C}^n$ 中的普通向量组直接用「拼成矩阵求秩」判定（先修线性代数工具，[@ex-1.3.6] 与习题 C2 使用）。

在 [1.2.4](sec12.md#sec-1.2.4) 中已经指出，本例的三个信号 $(-1)^k,2^k,3^k$ 恰是某个三阶齐次差分方程的解——用 Casorati 判别「解信号组」的相关性，与微分方程用朗斯基行列式判别「解函数组」如出一辙。

:::

:::

<a id="sec-1.3.3"></a>

## 1.3.3 唯一表示定理（定理 1.3.1）

「有没有冗余」由相关性回答；表示法是否唯一是另一个问题，而两者只差一步：给无关组添上 $\boldsymbol{\beta}$ 后出现冗余，$\boldsymbol{\beta}$ 的表示法就随之唯一。坐标的唯一性（1.3.5）正建立在这条定理上。

::: thm 定理 1.3.1 · 唯一表示定理 {#thm-1.3.1}

设线性空间 $V$ 中向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 线性无关，而向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n,\boldsymbol{\beta}$ 线性相关，则 $\boldsymbol{\beta}$ 可由向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 线性表示，**且表示法唯一**。

:::

::: proof 证（存在性 + 唯一性）

**存在性。**由相关性，存在不全为零的数 $c_1,\cdots,c_n,d\in F$ 使

$$c_1\boldsymbol{\alpha}_1+\cdots+c_n\boldsymbol{\alpha}_n+d\boldsymbol{\beta}=\boldsymbol{\theta}.$$

断言 $d\neq0$：若 $d=0$，则 $c_1\boldsymbol{\alpha}_1+\cdots+c_n\boldsymbol{\alpha}_n=\boldsymbol{\theta}$ 且 $c_1,\cdots,c_n$ 不全为零，与 $\boldsymbol{\alpha}$ 组无关矛盾。于是可解出

$$\boldsymbol{\beta}=-\frac{c_1}{d}\boldsymbol{\alpha}_1-\cdots-\frac{c_n}{d}\boldsymbol{\alpha}_n.$$

**唯一性（反证法）。**假设有两种表示

$$\boldsymbol{\beta}=k_1\boldsymbol{\alpha}_1+\cdots+k_n\boldsymbol{\alpha}_n=l_1\boldsymbol{\alpha}_1+\cdots+l_n\boldsymbol{\alpha}_n,$$

且两组系数不全相同。两式相减得 $(k_1-l_1)\boldsymbol{\alpha}_1+\cdots+(k_n-l_n)\boldsymbol{\alpha}_n=\boldsymbol{\theta}$，系数不全为零——这与 $\boldsymbol{\alpha}$ 组线性无关矛盾。故表示法唯一。

:::

::: note

**直觉。**「无关」= 基底无冗余；一旦加入 $\boldsymbol{\beta}$ 出现冗余，冗余恰好把 $\boldsymbol{\beta}$ 钉死在唯一的位置上。这条定理是「坐标」唯一性的全部依据。

:::

<a id="sec-1.3.4"></a>

## 1.3.4 极大线性无关组与秩

接着问两个问题：一个向量组里最多能挑出多少个线性无关的向量？挑出的这几个，又能不能代表组里其余的向量？把「无关」与「能代表其余」两条要求合在一起，就是极大线性无关组。

::: def 定义 1.3.2 · 极大线性无关组与秩 {#def-1.3.2}

考查线性空间 $V$ 的向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$。若该向量组存在 $r$ 个线性无关的向量 $\boldsymbol{\alpha}_{i_1},\cdots,\boldsymbol{\alpha}_{i_r}$，且 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 中**任一**向量均可由向量组 $\boldsymbol{\alpha}_{i_1},\cdots,\boldsymbol{\alpha}_{i_r}$ 线性表示，则称 $\boldsymbol{\alpha}_{i_1},\cdots,\boldsymbol{\alpha}_{i_r}$ 为向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 的**极大线性无关组**，数 $r$ 称为向量组的**秩**，记作 $\operatorname{rank}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)=r$。

:::

于是向量组中的任一向量都可由极大线性无关组唯一表示——存在性来自「极大」（定义要求），唯一性来自「无关」（[@thm-1.3.1] 的逻辑）。定义还留着两个必须澄清的问题：

**① 极大无关组唯一吗？——不唯一。**例：$\mathbb{R}^2$ 中向量组 $(1,0),(0,1),(1,1)$，其中 $\{(1,0),(0,1)\}$ 与 $\{(1,0),(1,1)\}$、$\{(0,1),(1,1)\}$ 都是极大无关组。

**② 极大无关组所含向量个数唯一吗？——唯一。**这正是 [1.3.6](sec13.md#sec-1.3.6) [@thm-1.3.3] 的内容（极大无关组是其张成子空间 $\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$ 的基，而基的个数相同），因此「秩 $r$」的定义是良性的。矩阵的秩 $\operatorname{rank}A$（先修概念）= 列向量组的秩，本节直接使用（[@ex-1.3.6]）。

<a id="sec-1.3.5"></a>

## 1.3.5 基与坐标

先看 $\mathbb{R}^2$ 的图景：取 $\boldsymbol{e}_1,\boldsymbol{e}_2$，则任一向量 $(a,b)=a\boldsymbol{e}_1+b\boldsymbol{e}_2$，且表示唯一（由[@thm-1.3.1]：$\boldsymbol{e}_1,\boldsymbol{e}_2$ 无关，添加任一向量后相关）。**向量 $\boldsymbol{e}_1$ 与 $\boldsymbol{e}_2$ 给 $\mathbb{R}^2$ 强加了一个「坐标系」**。

<figure aria-labelledby="fig-basis-cs-caption">
<svg font-size="12" height="240" viewBox="0 0 360 240" width="360" xmlns="http://www.w3.org/2000/svg" aria-labelledby="fig-basis-cs-title fig-basis-cs-desc" role="img" aria-describedby="fig-basis-cs-caption">
<title id="fig-basis-cs-title">用 e₁、e₂ 给平面装上坐标系</title>
<desc id="fig-basis-cs-desc">向量 e₁ 与 e₂ 线性无关，平面内任一向量 α 都能唯一地写成 a·e₁ + b·e₂，两个系数 a、b 就是 α 在这组基下的坐标。</desc>
<defs><marker id="a3" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="2.6"><path d="M0,0 L6.5,2.6 L0,5.2 Z" fill="var(--fig-neutral)"></path></marker>
<marker id="a3b" markerHeight="8" markerWidth="8" orient="auto" refX="6" refY="2.6"><path d="M0,0 L6.5,2.6 L0,5.2 Z" fill="var(--fig-blue)"></path></marker></defs>
<line marker-end="url(#a3)" stroke="var(--fig-neutral)" stroke-width="1.3" x1="30" x2="340" y1="200" y2="200"></line>
<line marker-end="url(#a3)" stroke="var(--fig-neutral)" stroke-width="1.3" x1="30" x2="30" y1="200" y2="20"></line>
<text fill="var(--fig-neutral)" x="342" y="205">x</text><text fill="var(--fig-neutral)" x="24" y="16">y</text><text fill="var(--fig-neutral)" x="22" y="216">O</text>
<!-- unit vectors -->
<line marker-end="url(#a3)" stroke="var(--fig-red)" stroke-width="2.4" x1="30" x2="95" y1="200" y2="200"></line>
<line marker-end="url(#a3)" stroke="var(--fig-red)" stroke-width="2.4" x1="30" x2="30" y1="200" y2="135"></line>
<text fill="var(--fig-red)" x="92" y="192">e₁</text><text fill="var(--fig-red)" x="38" y="146">e₂</text>
<!-- parallelogram dashed -->
<line stroke="var(--line-strong)" stroke-dasharray="4 3" stroke-width="1" x1="240" x2="240" y1="200" y2="75"></line>
<line stroke="var(--line-strong)" stroke-dasharray="4 3" stroke-width="1" x1="30" x2="240" y1="75" y2="75"></line>
<!-- vector a -->
<line marker-end="url(#a3b)" stroke="var(--fig-blue)" stroke-width="2.4" x1="30" x2="240" y1="200" y2="75"></line>
<text fill="var(--fig-blue)" font-style="italic" x="140" y="145">α = a e₁ + b e₂</text>
<text fill="var(--muted)" x="128" y="212">a 个 e₁</text><text fill="var(--muted)" x="10" y="130">b 个 e₂</text>
</svg>
<figcaption>图 1-3 · 基给空间强加「坐标系」：坐标 $(a,b)$ 是沿基向量的「刻度读数」</figcaption>
<figcaption id="fig-basis-cs-caption">向量 e₁ 与 e₂ 线性无关，平面内任一向量 α 都能唯一地写成 a·e₁ + b·e₂，两个系数 a、b 就是 α 在这组基下的坐标。</figcaption>
</figure>

把这次的观察抽象出来，就是「基」的定义。

::: def 定义 1.3.3 · 基 basis {#def-1.3.3}

设 $V$ 是 $F$ 上的线性空间，$\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 是 $V$ 中一组向量。若<br> （1）向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 线性无关；<br> （2）$V$ 中任一向量均可由 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 线性表示；<br> 则称 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 是 $V$ 的一组**基**（或一个基底）。

:::

::: note

明确一组基的意义，就在于给线性空间强加一个「坐标系」。对照[@def-1.3.2] 看：「基」正是「把整个空间当作向量组时的极大线性无关组」——「无关」与「能生成」两条要求同时用在整个空间上。

:::

::: thm 定理 1.3.2 · 唯一表示定理（基版本） {#thm-1.3.2}

设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是线性空间 $V$ 的一组基，则 $V$ 中任一向量 $\boldsymbol{x}$ 均可由基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ **唯一**表示。

::: proof 证

「可表示」即[@def-1.3.3] 条件 (2)；「唯一」：若 $\boldsymbol{x}=\sum k_i\boldsymbol{x}_i=\sum l_i\boldsymbol{x}_i$，相减得 $\sum(k_i-l_i)\boldsymbol{x}_i=\boldsymbol{\theta}$，由条件 (1) 基无关得 $k_i=l_i$（$i=1,\cdots,n$）。与[@thm-1.3.1] 的唯一性论证完全一致。

:::

:::

::: def 定义 1.3.4 · 坐标 coordinates {#def-1.3.4}

设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是 $F$ 上线性空间 $V$ 的一组基，$\forall\boldsymbol{x}\in V$，令

$$\boldsymbol{x}=\sum_{i=1}^{n}a_i\boldsymbol{x}_i=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)\begin{pmatrix}a_1\\ \vdots\\ a_n\end{pmatrix},$$

称有序数组 $(a_1,\cdots,a_n)^{\mathrm T}\in F^n$ 是 $\boldsymbol{x}$ 在基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 下的**坐标**，它由 $\boldsymbol{x}$ 与基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ **唯一**确定。

:::

坐标的算法说到底只有一条：解线性方程组。但向量住在哪里，方程组就得写成什么样子——下面三例分别在 $\mathbb{R}^3$、带约束方程的子空间和多项式空间中，做同一件事。

::: ex 例 1.3.A · $\mathbb{R}^3$ 中非标准基下的坐标 {#ex-1.3.A}

设 $\boldsymbol{x}_1=(1,1,0)^{\mathrm T},\ \boldsymbol{x}_2=(0,1,1)^{\mathrm T},\ \boldsymbol{x}_3=(1,0,1)^{\mathrm T}$。(1) 证明它们是 $\mathbb{R}^3$ 的一组基；(2) 求 $\boldsymbol{x}=(2,-1,1)^{\mathrm T}$ 在该基下的坐标。

::: sol 解答

**(1)** 拼成矩阵并取行列式：

$$\det(\boldsymbol{x}_1,\boldsymbol{x}_2,\boldsymbol{x}_3)=\begin{vmatrix}1&0&1\\ 1&1&0\\ 0&1&1\end{vmatrix}=1(1\cdot1-0\cdot1)-0+1(1\cdot1-1\cdot0)=2\neq0,$$

故三个向量线性无关；3 个无关向量张成 $\mathbb{R}^3$（任何 $\boldsymbol{y}$ 必可表示——也可用「系数矩阵可逆 ⟹ 对任意右端有唯一解」），故是基。

**(2)** 设 $\boldsymbol{x}=a\boldsymbol{x}_1+b\boldsymbol{x}_2+c\boldsymbol{x}_3$，按分量写开：

$$\begin{cases}a+c=2\\ a+b=-1\\ b+c=1\end{cases}$$

三式相加得 $2(a+b+c)=2$，即 $a+b+c=1$；分别减去三式得 $b=1-2=-1$，$c=1-(-1)=2$，$a=1-1=0$。坐标为 $(0,-1,2)^{\mathrm T}$。验证：$0\boldsymbol{x}_1-1\boldsymbol{x}_2+2\boldsymbol{x}_3=(0+2,\ -1,\ -1+2)=(2,-1,1)$ ✓。

:::

:::

::: ex 例 1.3.D · 从一个约束方程读出基、维数与坐标 {#ex-1.3.D}

设

$$W=\{(x_1,x_2,x_3)^{\mathrm T}\in\mathbb R^3\mid x_1+x_2+x_3=0\}.$$

(1) 求 $W$ 的一组基与维数；(2) 求 $\boldsymbol x=(2,-1,-1)^{\mathrm T}$ 在该基下的坐标；(3) 解释为什么「一条独立线性约束通常少一个自由方向」。

::: sol 解答

令自由变量 $x_2=s,x_3=t$，则 $x_1=-s-t$，所以

$$
\begin{pmatrix}x_1\\x_2\\x_3\end{pmatrix}
=s\begin{pmatrix}-1\\1\\0\end{pmatrix}
+t\begin{pmatrix}-1\\0\\1\end{pmatrix}.
$$

记 $\boldsymbol v_1=(-1,1,0)^{\mathrm T}$、$\boldsymbol v_2=(-1,0,1)^{\mathrm T}$。上式说明它们张成 $W$；二者不成比例，因此线性无关。故 $(\boldsymbol v_1,\boldsymbol v_2)$ 是 $W$ 的一组基，$\dim W=2$。

对 $\boldsymbol x=(2,-1,-1)^{\mathrm T}$，由第二、第三分量立刻读出 $s=-1,t=-1$，故

$$[\boldsymbol x]_{(\boldsymbol v_1,\boldsymbol v_2)}=(-1,-1)^{\mathrm T}.$$

验算：$-\boldsymbol v_1-\boldsymbol v_2=(2,-1,-1)^{\mathrm T}$。

空间中原本有三个自由坐标，独立方程 $x_1+x_2+x_3=0$ 决定掉其中一个，于是只剩两个自由参数——这正是以后秩–零化度定理「未知量个数 − 独立约束个数」的最小模型。

:::

:::

::: ex 例 1.3.3 · 多项式空间：Taylor 坐标 {#ex-1.3.3}

设 $f(x)\in P_n(x)$，求 $f(x)=f(0)+f'(0)x+\cdots+\dfrac{f^{(n)}(0)}{n!}x^n$ 在基 $1,x,\cdots,x^n$ 下的坐标。

::: sol 解答

把 $f(x)$ 按「基的顺序」对齐书写：

$$f(x)=(1,x,\cdots,x^n)\begin{pmatrix}f(0)\\ f'(0)\\ \vdots\\ f^{(n)}(0)/n!\end{pmatrix},$$

故 $f(x)$ 在基 $1,x,\cdots,x^n$ 下的坐标为 $\left(f(0),\,f'(0),\,\cdots,\,\dfrac{f^{(n)}(0)}{n!}\right)^{\mathrm T}$——坐标的分量恰是 Maclaurin 展开系数。

**同法可得 $f(x)$ 在基 $1,(x-x_0),\cdots,(x-x_0)^n$ 下的坐标**（Taylor 展开）：

$$f(x)=f(x_0)+f'(x_0)(x-x_0)+\cdots+\frac{f^{(n)}(x_0)}{n!}(x-x_0)^n=(1,(x-x_0),\cdots,(x-x_0)^n)\begin{pmatrix}f(x_0)\\ f'(x_0)\\ \vdots\\ f^{(n)}(x_0)/n!\end{pmatrix},$$

即坐标为 $\left(f(x_0),\,f'(x_0),\,\cdots,\,\dfrac{f^{(n)}(x_0)}{n!}\right)^{\mathrm T}$。

:::

这个例子顺带引出两个问题：① 同一空间不同基所包含的向量个数一定相同吗？——是，[@thm-1.3.3]。② 同一空间不同的基有何关系？——过渡矩阵（[@def-1.3.5]）。接下来的两小节依次回答。

:::

<a id="sec-1.3.6"></a>

## 1.3.6 同一空间不同基所含向量数目相同（定理 1.3.3）

要让「维数」这个词将来站得住，先得证明：同一个空间的不同基，所含向量的个数一样多。证明分两步——先造一条便于计数的引理，再用它比较两组基。

::: thm 引理 · 多于基数的向量必相关

设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 是线性空间 $V$ 的一组基，$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_m\in V$。若 $m\gt n$，则 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_m$ 线性相关。

:::

::: proof 证

考查零组合 $\sum_{j=1}^m k_j\boldsymbol{y}_j=\boldsymbol{\theta}$。由基的张成性，每个 $\boldsymbol{y}_j$ 都可表示为 $\boldsymbol{y}_j=\sum_{i=1}^n a_{ij}\boldsymbol{x}_i$。代入并交换求和次序：

$$\boldsymbol{\theta}=\sum_{j=1}^m k_j\sum_{i=1}^n a_{ij}\boldsymbol{x}_i=\sum_{i=1}^n\Big(\sum_{j=1}^m a_{ij}k_j\Big)\boldsymbol{x}_i.$$

由[@thm-1.3.2]（基表示唯一），$\boldsymbol{\theta}$ 的坐标全为零，故每个括号为零：

$$\sum_{j=1}^m a_{ij}k_j=0,\qquad i=1,\cdots,n.$$

这是 $n$ 个方程、$m$ 个未知量 $k_1,\cdots,k_m$ 的齐次线性方程组。由先修知识（高斯消元：未知量多于方程个数时必有自由未知量），它存在**非零解** $(k_1,\cdots,k_m)$。非零解使 $\sum k_j\boldsymbol{y}_j=\boldsymbol{\theta}$ 成立，故 $\boldsymbol{y}$ 组线性相关。

:::

::: thm 定理 1.3.3 · 基的个数不变 {#thm-1.3.3}

同一空间不同基所包含的向量数目相同。

::: proof 证

设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 与 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_m$ 都是 $V$ 的基。每个 $\boldsymbol{y}_j\in V$ 都可由基 $\boldsymbol{x}$ 组表示。若 $m\gt n$，由引理，$\boldsymbol{y}$ 组线性相关，与其是基（条件 (1) 无关）矛盾，故 $m\leq n$。对调两基的角色，同理 $n\leq m$。故 $m=n$。

:::

这条定理立刻带来两个收获：① $n$ 维空间中任何无关组至多含 $n$ 个向量（引理的直接推论）；② [@def-1.3.2] 的秩 $r$ 良定义——向量组的任一极大无关组都是 $\operatorname{span}$ 的基（极大无关组无关；由极大性，组中每个向量可由它表示，故张成整个 $\operatorname{span}$），由[@thm-1.3.3]，其个数都等于 $\dim\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$。

:::

<a id="sec-1.3.7"></a>

## 1.3.7 过渡矩阵与坐标变换

同一个空间可以有很多组基。向量本身不随基改变，变的只是它的坐标；而两组基之间的换算关系，被一个矩阵完整记录下来，这个矩阵就是过渡矩阵。

::: def 定义 1.3.5 · 过渡矩阵 transition matrix {#def-1.3.5}

设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 和 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 是数域 $F$ 上线性空间 $V$ 的两组基，令

$$\boldsymbol{y}_i=a_{1i}\boldsymbol{x}_1+\cdots+a_{ni}\boldsymbol{x}_n=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)\begin{pmatrix}a_{1i}\\ \vdots\\ a_{ni}\end{pmatrix},\qquad i=1,\cdots,n.$$

引入矩阵表示：

$$(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n)=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)A,\qquad A=(a_{ij})\in F^{n\times n},$$

称 $A$ 是由基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 到基 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 的**过渡矩阵**（或变换矩阵）。**读法：**$A$ 的第 $i$ 列是「新基」向量 $\boldsymbol{y}_i$ 在「旧基」$\boldsymbol{x}$ 组下的坐标。

:::

<figure aria-labelledby="fig-basis-caption" class="concept-figure" data-figure="FIG. 1–06">
<svg aria-labelledby="fig-basis-title fig-basis-desc" role="img" viewBox="0 0 680 270">
<title id="fig-basis-title">换基时向量不变、坐标改变</title>
<desc id="fig-basis-desc">同一向量在旧基和新基下有两列不同坐标，两者通过可逆过渡矩阵连接。</desc>
<defs><marker id="basis-arrow" markerHeight="6" markerWidth="6" orient="auto-start-reverse" refX="8.5" refY="5" viewBox="0 0 10 10"><path d="M0,0 L10,5 L0,10 Z" fill="var(--accent)"></path></marker></defs>
<rect class="diagram-node" height="138" rx="12" width="190" x="34" y="66"></rect>
<text class="diagram-mono" x="57" y="94">OLD BASIS / X</text><text class="diagram-text" x="57" y="121">旧基下的坐标</text>
<text class="diagram-note" x="57" y="158">α = (α₁, …, αₙ)ᵀ</text><text class="diagram-note" x="57" y="184">用 x₁,…,xₙ 测量</text>
<rect class="diagram-node" height="138" rx="12" width="190" x="456" y="66"></rect>
<text class="diagram-mono" x="479" y="94">NEW BASIS / Y</text><text class="diagram-text" x="479" y="121">新基下的坐标</text>
<text class="diagram-note" x="479" y="158">β = (β₁, …, βₙ)ᵀ</text><text class="diagram-note" x="479" y="184">用 y₁,…,yₙ 测量</text>
<line class="diagram-accent" marker-end="url(#basis-arrow)" x1="240" x2="440" y1="117" y2="117"></line>
<line class="diagram-sage" x1="440" x2="240" y1="161" y2="161"></line>
<text class="diagram-mono" x="297" y="104">β = A⁻¹α</text><text class="diagram-mono" x="304" y="186">α = Aβ</text>
<circle cx="340" cy="139" fill="var(--paper)" r="20" stroke="var(--line-strong)"></circle>
<text class="diagram-text" x="333" y="145">A</text>
<text class="diagram-note" x="171" y="240">向量 x 本身没动；变的只是描述它的「刻度」</text>
</svg>
<figcaption id="fig-basis-caption"><b>换基不是变向量，而是换尺子。</b>过渡矩阵 $A$ 记录新基在旧基中的样子，所以「旧坐标 $=A\times$ 新坐标」。</figcaption>
</figure>

<div class="widget" data-widget="change-basis">
<p class="widget-head"><span class="widget-kicker">动手</span><strong class="widget-title">同一个向量，在两族基下的坐标不一样</strong></p>
<p class="widget-hint">拖动蓝色向量 $\boldsymbol{x}$，或转动新基 $\boldsymbol{f}_1$。同一个 $\boldsymbol{x}$，在标准基与 $\{\boldsymbol{f}_1,\boldsymbol{f}_2\}$ 下的两列坐标随之改变——「换基不改向量，只改坐标」，这正是过渡矩阵在做的事。</p>
</div>

下面的三条性质，把换基时真正会用到的两件事说清楚：矩阵能不能反向使用，坐标到底该乘 $A$ 还是 $A^{-1}$。

::: thm 命题 1.3.1 · 过渡矩阵的性质 {#prop-1.3.1}

设 $V$ 是 $F$ 上的线性空间，$A\in F^{n\times n}$ 是由基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 到基 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 的过渡矩阵，则：<br> （1）过渡矩阵 $A$ 可逆；<br> （2）由基 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 到基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n$ 的过渡矩阵为 $A^{-1}$；<br> （3）任取 $\boldsymbol{x}\in V$，设 $\boldsymbol{x}=\sum_i\alpha_i\boldsymbol{x}_i=\sum_i\beta_i\boldsymbol{y}_i$，则

$$\begin{pmatrix}\beta_1\\ \vdots\\ \beta_n\end{pmatrix}=A^{-1}\begin{pmatrix}\alpha_1\\ \vdots\\ \alpha_n\end{pmatrix}\qquad\text{或}\qquad\begin{pmatrix}\alpha_1\\ \vdots\\ \alpha_n\end{pmatrix}=A\begin{pmatrix}\beta_1\\ \vdots\\ \beta_n\end{pmatrix}.$$

:::

::: proof 证

**（1）**反设 $A$ 不可逆，则齐次方程组 $A\boldsymbol{k}=\boldsymbol{0}$ 有非零解 $\boldsymbol{k}=(k_1,\cdots,k_n)^{\mathrm T}\neq\boldsymbol{0}$。于是

$$k_1\boldsymbol{y}_1+\cdots+k_n\boldsymbol{y}_n=(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n)\boldsymbol{k}=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)A\boldsymbol{k}=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)\boldsymbol{0}=\boldsymbol{\theta},$$<!-- consistency-ok：此式里的 $\boldsymbol{0}$ 是 $F^n$ 中的零向量（$A\boldsymbol{k}$ 的结果），$\boldsymbol{\theta}$ 是 $V$ 中的零向量，两者分属不同空间，不是同一个对象换写 -->

即 $\boldsymbol{y}$ 组线性相关，与 $\boldsymbol{y}$ 组是基矛盾。故 $A$ 可逆。

**（2）**设由 $\boldsymbol{y}$ 组到 $\boldsymbol{x}$ 组的过渡矩阵为 $B$：$(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)=(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n)B$。代入过渡关系：

$$(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)AB.$$

写 $AB=(c_{ij})$，比较两边：对每个 $j$，$\boldsymbol{x}_j=\sum_i c_{ij}\boldsymbol{x}_i$。另一方面，$\boldsymbol{x}_j$ 的自身表示为 $\boldsymbol{x}_j=\sum_i\delta_{ij}\boldsymbol{x}_i$（**Kronecker 记号** $\delta_{ij}$ 在 $i=j$ 时取 $1$、否则取 $0$——正是单位矩阵 $I$ 的 $(i,j)$ 元）。由基表示的唯一性（[@thm-1.3.2]），$c_{ij}=\delta_{ij}$，即 $AB=I$。故 $B=A^{-1}$。

**（3）**把两种基下的表示写成矩阵式，并代入 $(\boldsymbol{y}\text{ 组})=(\boldsymbol{x}\text{ 组})A$：

$$\boldsymbol{x}=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)\begin{pmatrix}\alpha_1\\ \vdots\\ \alpha_n\end{pmatrix}=(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n)\begin{pmatrix}\beta_1\\ \vdots\\ \beta_n\end{pmatrix}=(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_n)\,A\begin{pmatrix}\beta_1\\ \vdots\\ \beta_n\end{pmatrix}.$$

左右两式都是 $\boldsymbol{x}$ 在基 $\boldsymbol{x}$ 组下的表示，由坐标唯一性，$(\alpha_1,\cdots,\alpha_n)^{\mathrm T}=A(\beta_1,\cdots,\beta_n)^{\mathrm T}$；$A$ 可逆，移项得另一形式。

:::

::: method 记忆与陷阱

**记忆：**「新基 = 旧基 × 过渡阵」「旧坐标 = 过渡阵 × 新坐标」——矩阵总是「贴着旧的一侧」。<br> **陷阱：**$(3)$ 中的 $(\alpha_1,\cdots,\alpha_n)^{\mathrm T}$ 是 $\boldsymbol{x}$ 在**旧基 $\boldsymbol{x}$ 组**下的坐标，不是自然坐标（除非旧基恰为标准基）！例题 C5 专门演示这个坑。

:::

::: ex 例 1.3.3 续 · 多项式两组基之间的过渡矩阵 {#ex-1.3.3-2}

求 $P_n(x)$ 的两组基 $1,x,\cdots,x^n$ 与 $1,(x-x_0),\cdots,(x-x_0)^n$ 之间的过渡矩阵。

::: sol 解答

由二项式展开，对 $j=0,1,\cdots,n$：

$$(x-x_0)^j=\sum_{i=0}^{j}\binom{j}{i}x^i(-x_0)^{\,j-i},$$

即第 $j$ 列（$j$ 从 0 数起）在旧基 $1,x,\cdots,x^n$ 下的坐标为 $\big((-x_0)^j,\ \binom{j}{1}(-x_0)^{j-1},\ \cdots,\ 1,\ 0,\cdots,0\big)^{\mathrm T}$。于是

$$(1,(x-x_0),\cdots,(x-x_0)^n)=(1,x,\cdots,x^n)\,A,\qquad A_{i+1,\,j+1}=\binom{j}{i}(-x_0)^{\,j-i}\ (i\leq j),\quad A_{i+1,\,j+1}=0\ (i\gt j).$$

例如 $n=2$ 时：

$$A=\begin{pmatrix}1&-x_0&x_0^2\\ 0&1&-2x_0\\ 0&0&1\end{pmatrix},$$

上三角且对角线全为 $1$，$\det A=1$——与[@prop-1.3.1]（1）「过渡矩阵可逆」相互印证。第 $2$ 行**最后一列**（第 $n+1$ 列，即 $i=1,\,j=n$）的元素为 $n(-x_0)^{n-1}=\binom{n}{1}(-x_0)^{n-1}$，与课件所列一般形式一致。（本页的 $A_{i+1,j+1}$ 用的是**1 基**行号/列号，而 $i,j$ 从 $0$ 数起，两者相差 $1$；写成「第 $2$ 行第 $n$ 列」便会与公式对不上。）

:::

:::

::: ex 例 1.3.B · $\mathbb{R}^2$ 的过渡矩阵与坐标变换全流程 {#ex-1.3.B}

$\mathbb{R}^2$ 中取基 Ⅰ：$\boldsymbol{e}_1=(1,0)^{\mathrm T},\ \boldsymbol{e}_2=(0,1)^{\mathrm T}$（标准基），基 Ⅱ：$\boldsymbol{y}_1=(1,1)^{\mathrm T},\ \boldsymbol{y}_2=(1,-1)^{\mathrm T}$。(1) 求由基 Ⅰ 到基 Ⅱ 的过渡矩阵；(2) 求 $\boldsymbol{x}=(3,1)^{\mathrm T}$ 在基 Ⅱ 下的坐标。

::: sol 解答

**(1)** 把 $\boldsymbol{y}_1,\boldsymbol{y}_2$ 的坐标按列排好（在标准基下坐标就是自身）：

$$(\boldsymbol{y}_1,\boldsymbol{y}_2)=(\boldsymbol{e}_1,\boldsymbol{e}_2)\,A,\qquad A=\begin{pmatrix}1&1\\ 1&-1\end{pmatrix},\qquad \det A=-2\neq0\ (\text{可逆})$$

**(2)** 方法一（按[@prop-1.3.1]（3））：$\boldsymbol{x}$ 在标准基（旧基）下坐标为 $(3,1)^{\mathrm T}$，故新坐标

$$\begin{pmatrix}\beta_1\\ \beta_2\end{pmatrix}=A^{-1}\begin{pmatrix}3\\ 1\end{pmatrix}=\frac{1}{-2}\begin{pmatrix}-1&-1\\ -1&1\end{pmatrix}\begin{pmatrix}3\\ 1\end{pmatrix}=\begin{pmatrix}2\\ 1\end{pmatrix}.$$

方法二（直接解组合）：$2\boldsymbol{y}_1+1\boldsymbol{y}_2=2(1,1)+(1,-1)=(3,1)$ ✓。两法一致。

:::

:::

<a id="sec-1.3.8"></a>

## 1.3.8 维数

换基可以有很多种方式，但定理 1.3.3 保证：无论怎么换，基所含向量的个数不变。这个公共的个数于是可以脱离具体的基，当作空间自身的属性——这就是维数。

::: def 定义 1.3.6 · 维数 dimension {#def-1.3.6}

若线性空间 $V$ 有一组含 $n$ 个向量的基，则称 $V$ 为**有限维空间**，并定义 $V$ 的**维数**为 $n$，记为 $\dim V=n$。[@thm-1.3.3] 保证这个数不依赖基的选取。若 $V$ 没有任何有限基，则称 $V$ 为**无限维空间**，在本课程语境中记作 $\dim V=\infty$。<br> **等价读法：**有限维情形下，$\dim V$ 也等于 $V$ 中线性无关向量的最大个数。

:::

::: thm 定理 1.3.4 · 维数与基的关系 {#thm-1.3.4}

设 $V$ 是有限维线性空间，则 $\dim V=n$ 当且仅当 $V$ 的任一基底的向量个数为 $n$。

::: proof 证

「$\Longrightarrow$」：$\dim V=n$ 意为最大无关组含 $n$ 个向量；基是无关组，不超过 $n$ 个；基又可表示全空间，若只含 $r\lt n$ 个向量，则空间中 $n$ 个无关向量每个都可由 $r$ 个基向量表示，由计数引理这 $n$ 个向量相关，与「存在 $n$ 个无关向量」矛盾。故基恰含 $n$ 个。「$\Longleftarrow$」：基本身是含 $n$ 个向量的无关组；又由引理任何无关组不超过基的个数。故最大者为 $n$。

:::

:::

::: note

**注 3。如无特殊说明，本课程仅讨论有限维空间。**无限维的例子见[@ex-1.3.4]。

:::

::: ex 例 1.3.4 · 无限维信号空间 {#ex-1.3.4}

离散时间信号空间 $S$（全部双边序列 $\{x_k\}$，$x_k\in\mathbb{R}$，$k=0,\pm1,\pm2,\cdots$；记号同 [1.1.7](sec11.md#sec-1.1.7) 节）是 $\mathbb{R}$ 上的无限维线性空间。

::: sol 解答

对任意 $N$，考查 $N$ 个「单位脉冲」信号 $\boldsymbol{e}^{(j)}$（第 $j$ 个分量为 1、其余分量全为 0，$j=1,\cdots,N$）。若 $\sum_{j=1}^N k_j\boldsymbol{e}^{(j)}=\boldsymbol{\theta}$（零信号），逐下标比较第 $j$ 个分量得 $k_j=0$，故这 $N$ 个信号线性无关。由 $N$ 的任意性，$S$ 中存在任意大的线性无关组，$\dim S=\infty$，$S$ 是无限维线性空间。

:::

:::

::: ex 例 1.3.5 · $\mathbb{C}$ 的维数：数域再次登场 {#ex-1.3.5}

求空间 $\mathbb{C}$ 在实数域 $\mathbb{R}$ 上和复数域 $\mathbb{C}$ 上的维数。

::: sol 解答

**(1) 考查在实数域 $\mathbb{R}$ 上的线性空间 $\mathbb{C}$：**由[@ex-1.3.1]，向量 $1$ 和 $i$ 线性无关；且 $\mathbb{C}$ 中任一复数 $z=a+bi$ 均可由 $1$ 和 $i$ 线性表示。故 $\{1,i\}$ 是 $\mathbb{C}$（作为 $\mathbb{R}$ 上空间）的一组基，维数为 $2$。

**(2) 考查在复数域 $\mathbb{C}$ 上的线性空间 $\mathbb{C}$：**由[@ex-1.3.1]，向量 $1$ 和 $i$ 线性相关；而任一复数均可由 $1$（或 $i$）单独线性表示（$z=z\cdot 1$，系数 $z\in\mathbb{C}$）。故 $\{1\}$（或 $\{i\}$）构成一组基，维数为 $1$。

:::

::: note

**结论。**$\dim_{\mathbb{R}}\mathbb{C}=2$，$\dim_{\mathbb{C}}\mathbb{C}=1$。**维数是相对数域的性质**——讨论维数前必须先说清「在哪个数域上」。

:::

:::

### 常用空间的维数一览（每组都给出基与理由）

| 空间 | 一组基 | 维数 | 理由（一句话） |
|:--|:--|:--|:--|
| $\mathbb{R}^n$ | $\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n$（标准基） | $n$ | 无关（解方程只剩零解）+ 任意 $(x_1,\ldots,x_n)^{\mathrm T}=\sum_i x_i\boldsymbol e_i$ |
| $\mathbb{C}^{m\times n}$ | $E_{ij}$（$i$ 行 $j$ 列为 1 其余 0），共 $mn$ 个 | $mn$ | $\sum k_{ij}E_{ij}=O$ 逐元素比较得 $k_{ij}=0$ |
| $P_n(x)$ | $1,x,\cdots,x^n$ | $n+1$ | 多项式恒为零 ⟺ 各系数为零（恒等定理：非零 $n$ 次多项式至多 $n$ 个根，不可能在无穷多个点上为零） |
| 对称矩阵 $W_1\subset\mathbb{R}^{n\times n}$ | $E_{ii}\ (i=1..n)$ 与 $E_{ij}+E_{ji}\ (i\lt j)$ | $\dfrac{n(n+1)}2$ | 对称阵由对角元与上三角元完全确定 |
| 反对称矩阵 $W_2$ | $E_{ij}-E_{ji}\ (i\lt j)$ | $\dfrac{n(n-1)}2$ | 对角元必为 0，由上三角元确定 |
| 对角矩阵 | $E_{11},\cdots,E_{nn}$ | $n$ | — |
| 迹零矩阵 | $E_{ij}\,(i\neq j)$ 与 $E_{ii}-E_{nn}\,(i=1..n-1)$ | $n^2-1$ | $n^2$ 个元素、1 个线性约束 |
| 零空间 $\{\boldsymbol{\theta}\}$ | （空组） | $0$ | 任何含 1 个向量的组（$\{\boldsymbol{\theta}\}$）都相关 |

读表要留神两行。「迹零矩阵」的对角部分最容易多算：$E_{11},\cdots,E_{nn}$ 这 $n$ 个矩阵并不线性无关（它们的和是零矩阵），所以表里只取 $n-1$ 个对角差；「零空间」那一行的基是**空组**，维数 $0$ 说的是空间里只有零向量，不是「找不到基」。其余各行都可以用同一句话验证：设一个线性组合等于零，逐分量（或逐系数）比较，看系数是否被迫全为零。

::: note

**数字自检。**$\dim W_1+\dim W_2-\dim(W_1\cap W_2)=\dfrac{n(n+1)}2+\dfrac{n(n-1)}2-0=n^2=\dim\mathbb{R}^{n\times n}=\dim(W_1+W_2)$，与维数公式吻合。

:::

<a id="sec-1.3.9"></a>

## 1.3.9 基扩充定理与维数公式

有了维数，判断「一组无关向量是不是基」变得简单，而且无关组还能被逐步补成基。下面先把这两件事写成一条推论，再把「补基」的办法用到两个子空间上。

::: thm 推论 1.3.1 · 基扩充定理 {#cor-1.3.1}

$n$ 维线性空间中任意 $n$ 个线性无关的向量均为 $V$ 的一组基，且任一线性无关向量组 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_r\ (1\leq r\lt n)$ 可扩充为 $V$ 的一组基。

:::

::: proof 证

**前半：**设 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$ 无关。若它们不张成 $V$，则存在 $\boldsymbol{\beta}\notin\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$。考察 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n,\boldsymbol{\beta}$：设 $\sum k_i\boldsymbol{\alpha}_i+d\boldsymbol{\beta}=\boldsymbol{\theta}$。若 $d\neq0$，则 $\boldsymbol{\beta}=-\frac1d\sum k_i\boldsymbol{\alpha}_i\in\operatorname{span}$，矛盾；故 $d=0$，进而由 $\boldsymbol{\alpha}$ 组无关得诸 $k_i=0$。于是这 $n+1$ 个向量线性无关，但 $n$ 维空间中无关组至多 $n$ 个（计数引理），矛盾。故 $\boldsymbol{\alpha}$ 组张成 $V$，是基。

**后半（扩充流程）：**若 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_r$ 已张成 $V$，它就是基（无关 + 张成）；若不然，取 $\boldsymbol{x}_{r+1}\notin\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_r)$，与前半相同的论证知 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_r,\boldsymbol{x}_{r+1}$ 仍无关。重复此步骤，无关组长度每次加 1 且不超过 $n$，有限步内必然张成，得到基。

:::

::: think 注 5 · 「加法原则」是什么意思

课件在构造子空间的一组基时，建议**优先利用「加法」原则，尽量避免「减法」原则**。含义：① **加法**——从已知的无关组出发，逐个**添加**不属于当前张成的向量（基扩充定理保证每步保持无关、最终成为基）；② **减法**——从一大堆生成向量中**删去**可被表示的向量，直至无关。减法的问题：每次删除都改变剩余组的张成关系，容易「删过头」或讨论繁琐。[@ex-1.3.6]（修正版）与[@ex-1.3.C] 均按「加法 / 拼矩阵求秩」执行。

:::

把两个子空间的基「拼」在一起，就得到和空间的基；不过公共部分会被数两遍，要除掉一次。把这句话写成等式，正是本节最后一条大定理。

::: thm 定理 1.3.5 · 维数公式（维数定理） {#thm-1.3.5}

设 $W_1$ 和 $W_2$ 是线性空间 $V$ 的两个**有限维**子空间，则

$$\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2).$$

:::

::: proof 证

记 $r=\dim(W_1\cap W_2)$，$s=\dim W_1-r$，$t=\dim W_2-r$。

**取基。**取 $W_1\cap W_2$ 的一组基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_r$（当 $r=0$ 时跳过此步）。由基扩充定理，把它分别扩充为：$W_1$ 的基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_r,\ \boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_s$，与 $W_2$ 的基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_r,\ \boldsymbol{\beta}_1,\cdots,\boldsymbol{\beta}_t$。

**断言：**$\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_r,\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_s,\boldsymbol{\beta}_1,\cdots,\boldsymbol{\beta}_t$（共 $r+s+t$ 个）是 $W_1+W_2$ 的一组基。

**张成：**任取 $\boldsymbol{w}\in W_1+W_2$，$\boldsymbol{w}=\boldsymbol{w}_1+\boldsymbol{w}_2$。把 $\boldsymbol{w}_1$ 用 $W_1$ 的基表示、$\boldsymbol{w}_2$ 用 $W_2$ 的基表示，求和即得 $\boldsymbol{w}$ 用断言中 $r+s+t$ 个向量的表示。

**无关：**设

$$\sum_{i=1}^r c_i\boldsymbol{\varepsilon}_i+\sum_{j=1}^s a_j\boldsymbol{\alpha}_j+\sum_{l=1}^t b_l\boldsymbol{\beta}_l=\boldsymbol{\theta}.\tag{*}$$

移项：$\displaystyle\sum_j a_j\boldsymbol{\alpha}_j=-\sum_i c_i\boldsymbol{\varepsilon}_i-\sum_l b_l\boldsymbol{\beta}_l\eqqcolon\boldsymbol{\gamma}$。左边 $\in W_1$；右边是 $W_2$ 的基向量的组合，$\in W_2$。故 $\boldsymbol{\gamma}\in W_1\cap W_2=\operatorname{span}(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_r)$，即存在 $d_i$ 使 $\boldsymbol{\gamma}=\sum_i d_i\boldsymbol{\varepsilon}_i$。于是

$$\sum_j a_j\boldsymbol{\alpha}_j-\sum_i d_i\boldsymbol{\varepsilon}_i=\boldsymbol{\theta}$$

是 $W_1$ 的基向量的零组合，由基无关性得 $a_j=0$（且 $d_i=0$）。代回 $(*)$ 得 $\sum c_i\boldsymbol{\varepsilon}_i+\sum b_l\boldsymbol{\beta}_l=\boldsymbol{\theta}$。这是 $W_2$ 的基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_r,\boldsymbol{\beta}_1,\cdots,\boldsymbol{\beta}_t$ 的零组合，由基的无关性得 $c_i=0,\ b_l=0$。全部系数为零，断言的无关性成立。

**计数：**$\dim(W_1+W_2)=r+s+t=(r+s)+(r+t)-r=\dim W_1+\dim W_2-\dim(W_1\cap W_2)$。

:::

<figure aria-labelledby="fig-dim-count-caption" class="concept-figure">
<svg aria-labelledby="fig-dim-count-title fig-dim-count-desc" role="img" viewBox="0 0 680 260">
<title id="fig-dim-count-title">维数公式中的重复计数</title>
<desc id="fig-dim-count-desc">分别计算两个空间时公共基被计算两次，合并为和空间的基时只保留一次。</desc>
<text class="diagram-mono" x="32" y="34">SEPARATE COUNTS</text>
<rect fill="var(--fig-blue)" opacity="0.22" height="48" rx="8" width="150" x="32" y="52"></rect>
<rect fill="var(--fig-green)" opacity="0.25" height="48" rx="8" width="112" x="182" y="52"></rect>
<text class="diagram-text" text-anchor="middle" x="107" y="82">W₁ 独有：s</text>
<text class="diagram-text" text-anchor="middle" x="238" y="82">公共：r</text>
<rect fill="var(--fig-green)" opacity="0.25" height="48" rx="8" width="112" x="370" y="52"></rect>
<rect fill="var(--fig-red)" opacity="0.20" height="48" rx="8" width="150" x="482" y="52"></rect>
<text class="diagram-text" text-anchor="middle" x="426" y="82">公共：r</text>
<text class="diagram-text" text-anchor="middle" x="557" y="82">W₂ 独有：t</text>
<text class="diagram-note" text-anchor="middle" x="332" y="128">(s+r)+(r+t)：公共方向被数了两次</text>
<path d="M238,108 C238,152 280,156 318,174" fill="none" stroke="var(--accent)" stroke-width="2"></path>
<path d="M426,108 C426,152 388,156 350,174" fill="none" stroke="var(--accent)" stroke-width="2"></path>
<text class="diagram-mono" x="32" y="190">BASIS OF W₁+W₂</text>
<rect fill="var(--fig-blue)" opacity="0.22" height="48" rx="8" width="205" x="32" y="202"></rect>
<rect fill="var(--fig-green)" opacity="0.25" height="48" rx="8" width="160" x="237" y="202"></rect>
<rect fill="var(--fig-red)" opacity="0.20" height="48" rx="8" width="205" x="397" y="202"></rect>
<text class="diagram-text" text-anchor="middle" x="134" y="232">α₁,…,αₛ</text>
<text class="diagram-text" text-anchor="middle" x="317" y="232">ε₁,…,εᵣ（一次）</text>
<text class="diagram-text" text-anchor="middle" x="500" y="232">β₁,…,βₜ</text>
</svg>
<figcaption id="fig-dim-count-caption"><b>为什么减去交空间？</b>不是公式技巧，而是纠正重复计数：公共基在 $\dim W_1+\dim W_2$ 中出现两遍，在和空间的基里只该出现一遍。</figcaption>
</figure>

::: note

**几何直觉（$\mathbb{R}^3$）。**两个过原点的平面（各 2 维）相交于一条过原点的直线（1 维），和为 $\mathbb{R}^3$（3 维）：$3=2+2-1$ ✓；两条过原点的直线交于 $\{\boldsymbol{\theta}\}$（0 维）：若它们不同，和是平面，$2=1+1-0$ ✓。

:::

::: ex 例 1.3.6（含勘误 E2）· 维数公式求交空间维数 {#ex-1.3.6}

设 $W_1=\operatorname{span}(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3)$，$W_2=\operatorname{span}(\boldsymbol{\beta}_1,\boldsymbol{\beta}_2)$，其中 $\boldsymbol{\alpha}_1=(1,2,1)^{\mathrm T},\ \boldsymbol{\alpha}_2=(1,1,1)^{\mathrm T},\ \boldsymbol{\alpha}_3=(1,0,1)^{\mathrm T},\ \boldsymbol{\beta}_1=(2,1,0)^{\mathrm T},\ \boldsymbol{\beta}_2=(0,1,0)^{\mathrm T}$。求 $\dim(W_1\cap W_2)$。

::: errata 勘误 E2 · 课件页 20 的「观察知 $\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3$ 线性无关」是错的

直接验算：$\boldsymbol{\alpha}_1-2\boldsymbol{\alpha}_2+\boldsymbol{\alpha}_3=(1,2,1)^{\mathrm T}-2(1,1,1)^{\mathrm T}+(1,0,1)^{\mathrm T}=(0,0,0)^{\mathrm T}$，系数 $(1,-2,1)\neq\boldsymbol{0}$，故 $\boldsymbol{\alpha}$ 组**线性相关**（课件同页所列矩阵的第 1 行与第 3 行完全相同，这一点已经提示了三者相关）。因此 $\dim W_1=3$ 不成立，课件答案 $\dim(W_1\cap W_2)=2$ 随之错误。**正确答案是 $1$**，完整解法如下。

:::

::: sol 修正后的完整解答

**第 1 步（各空间维数）。**$\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2$ 不成比例，无关；$\boldsymbol{\alpha}_3=2\boldsymbol{\alpha}_2-\boldsymbol{\alpha}_1$（由上式移项），故

$$\dim W_1=\operatorname{rank}(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3)=2,\qquad \dim W_2=\operatorname{rank}(\boldsymbol{\beta}_1,\boldsymbol{\beta}_2)=2\ (\boldsymbol{\beta}_1,\boldsymbol{\beta}_2\ \text{不成比例}).$$

**第 2 步（和空间维数）。**五个向量拼成矩阵求秩（初等行变换，运算细节见下）：

$$(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3,\boldsymbol{\beta}_1,\boldsymbol{\beta}_2)=\begin{pmatrix}1&1&1&2&0\\ 2&1&0&1&1\\ 1&1&1&0&0\end{pmatrix}\longrightarrow\begin{pmatrix}1&1&1&2&0\\ 0&-1&-2&-3&1\\ 0&0&0&-2&0\end{pmatrix}\quad(r_2-2r_1,\ r_3-r_1)$$

阶梯有 3 个主元（第 1、2、4 列），故 $\dim(W_1+W_2)=\operatorname{rank}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\beta}_2)=3$。（顺便读出极大无关组 $\{\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\beta}_1\}$，确实 $\det(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\beta}_1)=2\neq0$。）

**第 3 步（维数公式）。**

$$\dim(W_1\cap W_2)=\dim W_1+\dim W_2-\dim(W_1+W_2)=2+2-3=1.$$

**第 4 步（顺带求出交空间）。**由 $\boldsymbol{\alpha}_1-\boldsymbol{\alpha}_2=(0,1,0)^{\mathrm T}=\boldsymbol{\beta}_2$ 知 $\boldsymbol{\beta}_2\in W_1\cap W_2$，故 $\operatorname{span}(\boldsymbol{\beta}_2)\subseteq W_1\cap W_2$；又交空间维数为 1，二者相等：

$$W_1\cap W_2=\operatorname{span}\big\{(0,1,0)^{\mathrm T}\big\}.$$

**小结。**求 $\dim(W_1\cap W_2)$ 的标准流程 = 「各求秩 → 拼矩阵求和的秩 → 代维数公式」；要求出交空间本身，再找一个非零公共向量（通法见[@ex-1.3.C]：设 $\sum k_i\boldsymbol{\alpha}_i=\sum l_j\boldsymbol{\beta}_j$ 解齐次方程组）。

:::

:::

::: ex 例 1.3.C · 求交空间的通法演示 {#ex-1.3.C}

设 $W_1=\operatorname{span}\{(1,0,1)^{\mathrm T},\ (0,1,0)^{\mathrm T}\}$，$W_2=\operatorname{span}\{(1,1,0)^{\mathrm T},\ (0,0,1)^{\mathrm T}\}$。求 $W_1\cap W_2$（并验证维数公式）。

::: sol 解答

$\dim W_1=\dim W_2=2$（各组内两向量不成比例）。四向量拼起来秩为 3（例如 $(1,0,1),(0,1,0),(1,1,0)$ 的行列式为 $-1\neq0$），故 $\dim(W_1+W_2)=3$，维数公式预言 $\dim(W_1\cap W_2)=2+2-3=1$。

**通法：**公共向量 $\boldsymbol{v}$ 满足 $\boldsymbol{v}=k_1(1,0,1)^{\mathrm T}+k_2(0,1,0)^{\mathrm T}=l_1(1,1,0)^{\mathrm T}+l_2(0,0,1)^{\mathrm T}$。按分量写开：

$$\begin{cases}k_1=l_1\\ k_2=l_1\\ k_1=l_2\end{cases}\Longrightarrow k_1=k_2=l_1=l_2=t,$$

故 $\boldsymbol{v}=t(1,1,1)^{\mathrm T}$，即 $W_1\cap W_2=\operatorname{span}\{(1,1,1)^{\mathrm T}\}$，维数恰为 1，与公式吻合。验证：$(1,1,1)=(1,0,1)+(0,1,0)\in W_1$，且 $(1,1,1)=(1,1,0)+(0,0,1)\in W_2$ ✓。

:::

:::

<a id="sec-1.3.10"></a>

## 1.3.10 课件思考题解答

下面四个问题来自课件，考的都是把本节的定义与公式推到边界情形上；它们同时也为下一章的秩–零化度定理铺路。

::: think 思考 1 · 给定一个线性空间，必然能找到这个空间的一组基吗？

**有限维：必然。**按[@def-1.3.6]，「有限维」就是「存在有限基」。更常见的情形是：已知一个有限生成组 $\boldsymbol{s}_1,\cdots,\boldsymbol{s}_m$。若它无关，它已是基；若相关，由 [1.3.1](sec13.md#sec-1.3.1) 的等价刻画，某向量可由其余表示，删去它不改变张成集；重复删除，有限步后得到「无关 + 张成」的基。这是从有限生成组构造基的证明，不再把「有限维」反过来当作论据，因而避免循环论证。<br> **无限维（超出本课程）：**无限维空间同样存在基（Hamel 基），但其存在性依赖集合论公理（选择公理）；基的势可数或不可数都有可能（例如多项式空间 $\mathbb{R}[x]$ 的基 $\{1,x,x^2,\dots\}$ 可数，而 $\mathbb{R}$ 作为 $\mathbb{Q}$ 上的空间其基不可数）——本课程按注 3 只讨论有限维。

:::

::: think 思考 2 · 线性空间 $\{\boldsymbol{\theta}\}$ 的维数是多少？

**0**。按[@def-1.3.6]，$\{\boldsymbol{\theta}\}$ 中「最大无关组」含 0 个向量（任何单向量组 $\{\boldsymbol{\theta}\}$ 都线性相关，注 1），故 $\dim\{\boldsymbol{\theta}\}=0$。也约定空组（0 个向量）是它的基。对照维数公式：$\dim(W\cap W)$ 型的极端情形都自洽。

:::

::: think 思考 3 · 矩阵 $A$ 的零空间 $N(A)$ 的维数是多少？

结论：$\dim N(A)=n-\operatorname{rank}A$（$A\in\mathbb{C}^{m\times n}$）。直观（高斯消元）：解 $A\boldsymbol{x}=\boldsymbol{0}$ 时，主元个数是 $\operatorname{rank}A$，其余 $n-\operatorname{rank}A$ 个是自由未知量，每个自由量对应一个基础解向量，零空间由它们张成。用[@ex-1.2.B] 验证：$A=\begin{pmatrix}1&1\\2&2\end{pmatrix}$，$\operatorname{rank}A=1$，$\dim N(A)=2-1=1$ ✓。

:::

::: think 思考 4 · 矩阵 $A$ 的列空间 $R(A)$ 的维数是多少？

结论：$\dim R(A)=\operatorname{rank}A$。理由：$R(A)=\operatorname{span}($列向量组$)$，其维数 = 列向量组的极大无关组个数 = 列秩 = $\operatorname{rank}A$（先修知识：矩阵的秩 = 列秩 = 行秩）。

:::

::: preview 课程预告

把思考 3、4 合起来即著名恒等式 $\dim N(A)+\dim R(A)=n$（秩–零化度定理）。本讲只需掌握两个维数结论与消元直观，并能在小例子上验证；它的严格证明在第二章——一般线性映射的亏加秩定理（[2.2.5](../ch02/sec22.md#thm-2.2.5)）**就是它的推广**，而矩阵版本（$\dim N(A)$ 与 $\operatorname{rank}A$ 的同一组等式）由[定理 2.3.6](../ch02/sec23.md#thm-2.3.6)补出。

:::

**小结。**① 基本概念：线性相关与线性无关、基与坐标、维数、过渡矩阵；② 重要定理：唯一表示定理、基扩充定理、维数定理。

::: method 即时自测 · 1.3

本节的三个高频失分点：**数域没标注、坐标用错基、维数公式滥用**。

::: hint 第 1 题 · 记忆

「$n$ 维空间中的无关组至多含 $n$ 个向量」——这条结论的证明用了哪个引理、又用到哪个先修事实？（对应 [1.3.6](sec13.md#sec-1.3.6)）
:::

::: sol 第 1 题答案

用**计数引理**（多于基数的向量必相关）。其证明把零组合化成 $n$ 个方程、$m$ 个未知量的齐次方程组，再用先修事实「**未知量多于方程个数必有非零解**」得非零解，从而相关。

这条链条是「维数」良定义（不依赖基的选取）的全部依据：基的个数不变（[@thm-1.3.3]）的证明就是该引理的一次直接应用。
:::

::: hint 第 2 题 · 辨析

$\mathbb{R}^2$ 中两组基：Ⅰ $\{\boldsymbol{e}_1,\boldsymbol{e}_2\}$（标准基），Ⅱ $\{\boldsymbol{y}_1=(1,1)^{\mathrm T},\boldsymbol{y}_2=(1,-1)^{\mathrm T}\}$。设 $\boldsymbol{x}=(3,1)^{\mathrm T}$。

(1) 由基 Ⅰ 到基 Ⅱ 的过渡矩阵 $A$ 是什么？
(2) $\boldsymbol{x}$ 在基 Ⅱ 下的坐标是多少？
(3) 公式 $(\beta)=A^{-1}(\alpha)$ 里的 $(\alpha)$ 是 $\boldsymbol{x}$ 的坐标 $(3,1)^{\mathrm T}$ 吗？（对应 [1.3.7](sec13.md#sec-1.3.7)、习题 C5）
:::

::: sol 第 2 题答案

**(1)** $A=\begin{pmatrix}1&1\\1&-1\end{pmatrix}$（列 = 新基向量在旧基下的坐标）。

**(2)** $(\beta)=A^{-1}(3,1)^{\mathrm T}=\dfrac{1}{-2}\begin{pmatrix}-1&-1\\-1&1\end{pmatrix}\begin{pmatrix}3\\1\end{pmatrix}=(2,1)^{\mathrm T}$。验证：$2\boldsymbol{y}_1+\boldsymbol{y}_2=(3,1)^{\mathrm T}$ ✓。

**(3) 本题是标准基，所以恰好「是」——但要意识到这是巧合。**公式里的 $(\alpha)$ 指「$\boldsymbol{x}$ 在**旧基**下的坐标」，只有当旧基恰为标准基时才等于自然坐标。习题 C5 把旧基换成非标准基，直接代入就会出错。

**记忆口诀。**「矩阵贴着旧的一侧」——新基 = 旧基 × $A$，旧坐标 = $A$ × 新坐标。
:::

::: hint 第 3 题 · 应用

$W_1=\operatorname{span}\{(1,0,1)^{\mathrm T},(0,1,0)^{\mathrm T}\}$，$W_2=\operatorname{span}\{(1,1,0)^{\mathrm T},(0,0,1)^{\mathrm T}\}$。求 $W_1\cap W_2$。（对应 [1.3.9](sec13.md#sec-1.3.9)）
:::

::: sol 第 3 题答案

各组内两向量不成比例，$\dim W_1=\dim W_2=2$；四向量拼起来秩为 3，故 $\dim(W_1+W_2)=3$。由维数公式 $\dim(W_1\cap W_2)=2+2-3=1$。

**求交空间的通法：**设公共向量 $\boldsymbol{v}=k_1(1,0,1)^{\mathrm T}+k_2(0,1,0)^{\mathrm T}=l_1(1,1,0)^{\mathrm T}+l_2(0,0,1)^{\mathrm T}$，按分量解出 $k_1=k_2=l_1=l_2=t$，得 $W_1\cap W_2=\operatorname{span}\{(1,1,1)^{\mathrm T}\}$，维数确为 1。

**两条纪律。**① 维数公式**只对两个子空间**成立（三个及以上只有不等式，习题 B8）；② 求「交」时先算维数定心，再解方程组求向量。
:::

::: hint 第 4 题 · 迁移

$\dim_{\mathbb{R}}\mathbb{C}=?$ $\dim_{\mathbb{C}}\mathbb{C}=?$ 同一个集合为什么维数不同？（对应 [1.3.8](sec13.md#sec-1.3.8)）
:::

::: sol 第 4 题答案

$\dim_{\mathbb{R}}\mathbb{C}=2$（基 $\{1,i\}$），$\dim_{\mathbb{C}}\mathbb{C}=1$（基 $\{1\}$）。

**原因：**$1$ 与 $i$ 在实数域上线性无关，但在复数域上相关（$i\cdot 1+(-1)\cdot i=0$ 有非零系数）。**维数与线性相关性都是相对数域 $F$ 的性质**——所以写维数时必须标明数域，写作 $\dim_{\mathbb{R}}$ 或 $\dim_{\mathbb{C}}$。

这条性质在 [@ex-1.3.1]（相关性随数域翻转）和习题 A9（矩阵空间维数翻倍）中反复出现。
:::

:::
