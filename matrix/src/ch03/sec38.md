# 3.8 Jordan 分解（上）· $\lambda$ 矩阵

[3.6](sec36.md) 与 [3.7](sec37.md) 回答的是同一个问题的「好情形」：矩阵什么时候能对角化？答案是单纯矩阵；一旦可对角化，谱分解 $A=\sum_j\lambda_jE_j$ 就把特征值与特征子空间拆得干干净净。

但一般复方阵不一定单纯。最典型的反例是二阶 Jordan 块

$$J_2(\lambda_0)=\begin{bmatrix}\lambda_0&1\\0&\lambda_0\end{bmatrix},\qquad \lambda_0\in\mathbb C.$$

它只有一个特征值 $\lambda_0$，特征子空间是一维的 $\operatorname{span}\{(1,0)^{\mathrm T}\}$，凑不出 $\mathbb C^2$ 的基，所以**任何**可逆 $P$ 都不能把它对角化。于是 3.6 的问题在一般情形下必须换一个问法：

> **在相似意义下，一个复方阵最简能简到什么程度？**
>
> 等价地：**一个线性变换在适当基下的矩阵，最简形式是什么？**

这个问题的答案就是 **Jordan 标准形**。本页覆盖 3.8 的第一部分：为了造出 Jordan 标准形，先把 $\lambda I-A$ 当成一个「元素是多项式的矩阵」来研究——定义 $\lambda$ 矩阵，讨论它的秩、可逆性与初等变换。[3.8 下半](sec38b.md)再用初等变换把 $\lambda I-A$ 化成 Smith 标准形，从不变因子与初等因子读出 Jordan 块。

::: note 素材与说明（本节无录播）

本页依据课程第三章课件 **3.8 Jordan 分解** 的前 14 页（`_sources/matrix/3.8-Jordan分解.pdf` 共 50 页；后 36 页见[下半页](sec38b.md)）整理。**本节无对应录播**，故不引用课堂口述与时间戳：课件的定义、注记、例题与定理**照录并保留原编号**（定义 3.8.1–3.8.4、注 1–注 4、例 3.8.1–3.8.3、定理 3.8.1）。课件只给结论或只给一半推导的地方（定理 3.8.1 的必要性、充分性，命题式注记的证明）由本编补出并标注「本编补」；本编新增例题用字母编号（[@ex-3.8.A]–[@ex-3.8.C]），新增注记用「本编注」标注。课件有两处都标「注 3」，本页把后一处记为「注 3′」，并在[勘误](errata.md)中说明。

**范围提醒**：本页只到「初等变换」为止，**尚未**给出 Jordan 标准形本身。Smith 标准形、不变因子、初等因子与 Jordan 块的构造在 [3.8 下半](sec38b.md)；本页末尾的「课程预告」只勾画路线，不当作已证结论使用（其证明见[下半页](sec38b.md#thm-3.8.5j)）。
:::

::: preview 课程预告 · Jordan 标准形长什么样（[下半页](sec38b.md)已给出证明）

把 $s$ 阶 Jordan 块记为

$$J_s(\lambda_0)=\begin{bmatrix}\lambda_0&1&&\\&\lambda_0&\ddots&\\&&\ddots&1\\&&&\lambda_0\end{bmatrix}\in\mathbb C^{s\times s},$$

即对角元全为 $\lambda_0$、上一次对角元全为 $1$、其余为 $0$。[3.8 下半](sec38b.md)将证明：**每个复方阵 $A$ 都相似于一个分块对角阵**

$$J=\operatorname{diag}\big(J_{s_1}(\lambda_1),\cdots,J_{s_k}(\lambda_k)\big),$$

称为 $A$ 的 **Jordan 标准形**；除 Jordan 块的排列次序外，它由 $A$ 唯一决定。$J$ 的对角元是 $A$ 的全部特征值（按代数重数计），每个特征值对应的 Jordan 块阶数由 $\lambda I-A$ 的初等因子决定。

**本页的位置**：要证明这件事，先得把 $\lambda I-A$ 当独立对象研究。$\lambda I-A$ 的元素都是 $\lambda$ 的多项式——这就是 $\lambda$ 矩阵；它的「秩」和「可逆性」与数字矩阵有微妙差别，正是本页的主题。
:::

<a id="sec-3.8.1"></a>

## 3.8.1 $\lambda$ 矩阵：把多项式当成矩阵元素

数字矩阵的元素是数；把数换成 $\lambda$ 的多项式，就得到 $\lambda$ 矩阵。这不是为了 generality 而 generality：**特征矩阵 $\lambda I-A$ 天生就是 $\lambda$ 矩阵**，而相似、特征值、Jordan 块的全部信息都藏在它里面。

::: def 定义 3.8.1 · $\lambda$ 矩阵 {#def-3.8.1}

以 $\lambda$ 的多项式为元素的矩阵称为 **$\lambda$ 矩阵**，记为 $A(\lambda)$，即

$$A(\lambda)=\big[a_{ij}(\lambda)\big]_{m\times n},\qquad a_{ij}(\lambda)\in P_n(\lambda).$$
:::

::: note 本编注 · $P_n(\lambda)$ 与「次数不必统一」 {#note-3.8-pn}

课件写 $a_{ij}(\lambda)\in P_n(\lambda)$，其中 $P_n(\lambda)$ 表示次数不超过 $n$ 的多项式。但 $\lambda$ 矩阵各元素的次数**不必统一**：例 3.8.1 的 $A(\lambda)$ 中同时出现 $1-\lambda$（一次）、$\lambda^2$（二次）与常数。真正使用的对象是所有多项式构成的环 $P[\lambda]$；次数上限不影响任何定义与结论。本页按课件的 $P_n(\lambda)$ 记法照录，理解时把它读成「某个多项式」即可。
:::

::: ex 例 3.8.1（课件原文）· 判断 $\lambda$ 矩阵 {#ex-3.8.1}

判断 $A(\lambda)$ 和 $B(\lambda)$ 是否为 $\lambda$ 矩阵，其中

$$A(\lambda)=\begin{bmatrix}1-\lambda&\lambda^2&\lambda\\ \lambda&\lambda&-\lambda\\ 1+\lambda^2&\lambda^2&-\lambda^2\end{bmatrix},\qquad
B(\lambda)=\begin{bmatrix}\lambda&\lambda^2&\lambda\\ \lambda&\lambda&-\lambda\\ \lambda^{-2}&\lambda^2&-\lambda^2\end{bmatrix}.$$

::: sol 解答（课件原文）

$A(\lambda)$ 各元素均为 $\lambda$ 多项式，故 $A(\lambda)$ 是 $\lambda$ 矩阵；$B(\lambda)$ 的元素 $\lambda^{-2}$ 不是 $\lambda$ 多项式，故 $B(\lambda)$ 不是 $\lambda$ 矩阵。∎
:::
:::

::: note 注 1（课件原文）· 数字矩阵是特殊的 $\lambda$ 矩阵 {#note-3.8-numeric}

数字矩阵是特殊的 $\lambda$ 矩阵（常数是零次多项式）；复方阵 $A$ 的**特征矩阵** $\lambda I-A$ 是 $\lambda$ 矩阵。
:::

::: note 注 2（课件原文）· 运算与行列式、子式、秩 {#note-3.8-operations}

$\lambda$ 矩阵和数字矩阵一样有加、减、乘等运算，且具有相同的运算规律。同样可定义**正方 $\lambda$ 矩阵的行列式、子式及 $\lambda$ 矩阵的秩**等。
:::

::: note 本编注 · 哪些运算「原样搬过来」，哪些要小心 {#note-3.8-caveats}

- **原样成立**：同型矩阵的加法、减法；$m\times k$ 与 $k\times n$ 的乘法；转置、共轭、共轭转置；方阵的行列式（按 Leibniz 公式展开，结果仍是 $\lambda$ 的多项式）；子式。
- **要小心**：**不能做除法**。$1/\lambda$ 不是多项式，所以 $\lambda$ 矩阵一般没有「逐元除法」；「可逆」必须单独定义（[3.8.4](#sec-3.8.4)），不能像数字矩阵那样看到行列式非零就宣布可逆。
- **秩的定义不变**：仍然是「非零子式的最高阶数」，但「非零」指**多项式不恒为零**，不是「某个 $\lambda$ 代入后不为零」——这正是下一小节要强调的。
:::

<a id="sec-3.8.2"></a>

## 3.8.2 $\lambda$ 矩阵的秩：看「恒不为零的子式」

::: def 定义 3.8.2 · $\lambda$ 矩阵的秩 {#def-3.8.2}

$\lambda$ 矩阵 $A(\lambda)$ 中非零子式的最高阶数 $r$ 定义为 $A(\lambda)$ 的**秩**，记为

$$\operatorname{rank}\big(A(\lambda)\big)=r.$$
:::

这里的「非零子式」是一个**多项式**；说它非零，是指它**不恒等于零**。这一点与数字矩阵的秩有一道容易踩空的沟。

::: ex 例 3.8.2（课件原文）· 行列式与秩 {#ex-3.8.2}

求 $A(\lambda)=\begin{bmatrix}\lambda&0\\0&\lambda+1\end{bmatrix}$ 的行列式和秩。

::: sol 解答（课件原文）

由于 $|A(\lambda)|=\lambda(\lambda+1)$，故 $\operatorname{rank}\big(A(\lambda)\big)=2$。∎
:::
:::

::: note 注 3（课件原文）· 秩不是「逐点秩」 {#note-3.8-pointwise}

在 $\lambda$ 矩阵理论中，「当 $\lambda=0$ 或 $\lambda=-1$ 时，$\lambda$ 矩阵的秩为 $1$，其余情况矩阵的秩为 $2$」——这种说法是**错误**的。
:::

::: note 本编补 · 为什么错：秩是「恒不为零」，不是「代入后不为零」 {#note-3.8-rank-why}

例 3.8.2 的 $2\times 2$ 子式只有一个，就是 $\det A(\lambda)=\lambda(\lambda+1)$。它作为多项式**不恒为零**（只在 $\lambda=0$、$\lambda=-1$ 两点取零，但不是零多项式），所以 $2$ 阶子式非零，秩为 $2$。

若把 $\lambda=0$ 代进去，数字矩阵 $\begin{bmatrix}0&0\\0&1\end{bmatrix}$ 的秩确实是 $1$；但 $\lambda$ 矩阵的秩问的是「**存在**一个不恒为零的 $r$ 阶子式」，不是「对**每个** $\lambda$ 代入后秩都等于 $r$」。一个非零多项式可以在有限个点取零，这不影响它是非零多项式。

**更刺眼的例子**：$A(\lambda)=\begin{bmatrix}\lambda&0\\0&\lambda\end{bmatrix}$。代入 $\lambda=0$ 得到零矩阵（数值秩 $0$），但 $\det A(\lambda)=\lambda^2\not\equiv0$，故 $\lambda$ 矩阵的秩为 $2$。两个「秩」问的是不同的问题：

- **数值秩**：固定一个 $\lambda_0$，把 $A(\lambda_0)$ 当数字矩阵算秩；
- **$\lambda$ 矩阵的秩**：在多项式环上，看哪个阶数的子式**不恒为零**。

本课程说的「秩」都是后者。一个常用的直观说法：$\lambda$ 矩阵的秩等于「对绝大多数 $\lambda$ 代入后的数值秩」（例外至多是有限个点），但严格定义只看子式是否为零多项式。
:::

::: ex 例 3.8.3（课件原文）· 特征矩阵总是满秩 {#ex-3.8.3}

设 $A\in\mathbb C^{n\times n}$，则 $f_A(\lambda)=|\lambda I-A|$ 是关于 $\lambda$ 的一元 $n$ 次多项式。因此，$A$ 的特征矩阵 $\lambda I-A$ 的秩为 $n$，即 $\lambda I-A$ 总是满秩的。

::: sol 解答（本编补一句）

$f_A(\lambda)=\lambda^n+\cdots+(-1)^n\det A$ 是首项系数为 $1$ 的 $n$ 次多项式，**不恒为零**；它本身是 $\lambda I-A$ 的 $n$ 阶子式，故秩至少为 $n$；又矩阵只有 $n$ 阶，故秩恰为 $n$。∎
:::
:::

**读法**：例 3.8.3 把「特征多项式」翻译成了「特征矩阵满秩」。这件事看起来平平，却是整条路线的起点：我们要用 $\lambda I-A$ 的「秩」与「初等变换」反读出 $A$ 的相似不变量，而 $\lambda I-A$ **永远满秩**，所以「秩」本身不足以区分不同的 $A$——真正携带信息的是它的**子式的公因子结构**（[下半页](sec38b.md#thm-3.8.2) 的 Smith 标准形）。

<figure aria-labelledby="fig-lambda-levels-caption" class="concept-figure" data-figure="FIG. 3–01">
<svg aria-labelledby="fig-lambda-levels-title fig-lambda-levels-desc" role="img" viewBox="0 0 680 296">
<defs>
<marker id="level-arrow" markerHeight="7" markerWidth="7" orient="auto-start-reverse" refX="7.5" refY="4" viewBox="0 0 8 8"><path d="M0,0 L8,4 L0,8 Z" fill="var(--line-strong)"></path></marker>
</defs>

<title id="fig-lambda-levels-title">数字矩阵与 λ 矩阵的三组对照：秩、可逆、初等变换</title>
<desc id="fig-lambda-levels-desc">上排是数字矩阵：秩由非零子式决定，满秩等价于行列式非零，等价于可逆。中排是 λ 矩阵：秩由不恒为零的子式决定，满秩只说明行列式不是零多项式，可逆还要求它是非零常数。下排指出两者之间隔着一整类非零非常数多项式，并举特征矩阵为例。</desc>
<text class="diagram-mono" x="24" y="20">数字矩阵</text>
<text class="diagram-mono" x="360" y="20">λ 矩阵</text>
<rect fill="var(--fig-blue)" height="74" opacity="0.08" rx="8" width="306" x="24" y="30"></rect>
<text class="diagram-note" x="42" y="52">元素是数；秩 = 非零子式最高阶</text>
<text class="diagram-note" x="42" y="74">行列式是一个数：非零就行</text>
<text class="diagram-text" x="42" y="96">满秩 ⟺ 可逆（同一句话）</text>
<rect fill="var(--fig-purple)" height="74" opacity="0.08" rx="8" width="306" x="360" y="30"></rect>
<text class="diagram-note" x="378" y="52">元素是多项式；秩 = 不恒为零最高阶</text>
<text class="diagram-note" x="378" y="74">行列式是多项式：非零还不够</text>
<text class="diagram-text" x="378" y="96">满秩 ⇏ 可逆（裂成两层）</text>
<path d="M170,110 L170,132" fill="none" marker-end="url(#level-arrow)" stroke="var(--fig-blue)" stroke-width="1.6"></path>
<path d="M506,110 L506,132" fill="none" marker-end="url(#level-arrow)" stroke="var(--fig-purple)" stroke-width="1.6"></path>
<text class="diagram-mono" x="24" y="152">差在哪一层</text>
<rect fill="var(--fig-red)" height="86" opacity="0.10" rx="8" width="644" x="24" y="162"></rect>
<text class="diagram-text" x="42" y="186">中间那一层：非零非常数多项式</text>
<text class="diagram-note" x="42" y="210">例 diag(λ, λ+1) 的行列式 = λ(λ+1)：不恒为零（秩 2）✓，但不是常数（不可逆）✗</text>
<text class="diagram-note" x="42" y="232">这一类多项式既通过了「满秩」，又通不过「可逆」——本节全部陷阱都出在这里。</text>
<text class="diagram-mono" x="24" y="272">由此得的反直觉推论</text>
<text class="diagram-note" x="24" y="290">特征矩阵 λI−A 的行列式是首 1 的 n 次多项式，永不是常数 ⇒ λI−A 永远满秩、（n ≥ 1 时）永远不可逆。</text>
</svg>
<figcaption id="fig-lambda-levels-caption"><b>三组概念，各差一层。</b>数字矩阵里「满秩 $=$ 可逆」是一句话；到了 $\lambda$ 矩阵，这句话裂成两半：<b>满秩</b>只要求行列式不是零多项式，<b>可逆</b>要求它是非零常数，中间隔着一整类「非零非常数」的多项式。由此还得到一个反直觉的推论：特征矩阵 $\lambda I-A$ 永远满秩、却（$n\ge1$ 时）永远不可逆。</figcaption>
</figure>

<a id="sec-3.8.3"></a>

## 3.8.3 $\lambda$ 矩阵的逆：满秩不等于可逆

数字方阵里，「满秩」与「可逆」是同一句话：行列式非零 $\iff$ 存在逆矩阵。到了 $\lambda$ 矩阵，这句话**只对了一半**。

::: def 定义 3.8.3 · $\lambda$ 矩阵的逆矩阵 {#def-3.8.3}

设 $A(\lambda)$ 是 $n$ 阶 $\lambda$ 方阵，若存在 $n$ 阶 $\lambda$ 方阵 $B(\lambda)$ 满足

$$A(\lambda)B(\lambda)=B(\lambda)A(\lambda)=I,$$

则称 $\lambda$ 矩阵 $A(\lambda)$ 是**可逆的**，并称 $B(\lambda)$ 为 $A(\lambda)$ 的**逆矩阵**，记作 $A(\lambda)^{-1}$。
:::

课件的思考题是：**在数字方阵中，满秩和可逆等价；这一结论适用于 $\lambda$ 矩阵吗？**

答案是否定的。回到例 3.8.2：

$$A(\lambda)=\begin{bmatrix}\lambda&0\\0&\lambda+1\end{bmatrix},\qquad
\operatorname{rank}A(\lambda)=2.$$

它满秩。若它可逆，按数字矩阵的习惯，逆矩阵「应该」是

$$B(\lambda)=\begin{bmatrix}\dfrac1\lambda&0\\[4pt]0&\dfrac1{\lambda+1}\end{bmatrix}.$$

但 $1/\lambda$ 与 $1/(\lambda+1)$ **不是多项式**，所以 $B(\lambda)$ 不是 $\lambda$ 矩阵；形式上乘起来虽然是 $I$，却越出了「$\lambda$ 矩阵」这个范围。$A(\lambda)$ 因此**不可逆**。

::: thm 定理 3.8.1 · $\lambda$ 矩阵可逆的充要条件 {#thm-3.8.1}

$\lambda$ 方阵 $A(\lambda)$ 可逆的充分必要条件是其行列式 $|A(\lambda)|$ 为**非零常数**。
:::

::: proof 证明（课件原文；本编补足每步的理由）

**必要性**。若存在 $\lambda$ 矩阵 $B(\lambda)$ 使得 $A(\lambda)B(\lambda)=I_n$，两边取行列式：

$$|A(\lambda)|\,|B(\lambda)|=1.$$

$|A(\lambda)|$、$|B(\lambda)|$ 均为 $\lambda$ 的多项式。两个多项式的乘积是常数 $1$，故两者的次数都为 $0$，即它们都是**非零常数**。特别地，$|A(\lambda)|$ 是非零常数。

**充分性**。设 $|A(\lambda)|=r\ne0$（$r$ 是常数），$A^*(\lambda)$ 为 $A(\lambda)$ 的**伴随矩阵**，则伴随矩阵的基本恒等式给出

$$A(\lambda)A^*(\lambda)=A^*(\lambda)A(\lambda)=rI_n.$$

取

$$B(\lambda)=\frac1rA^*(\lambda).$$

$A^*(\lambda)$ 的元素是 $A(\lambda)$ 的 $n-1$ 阶子式（再带符号），仍是 $\lambda$ 的多项式；$1/r$ 是常数，故 $B(\lambda)$ 是 $\lambda$ 矩阵，且 $A(\lambda)B(\lambda)=B(\lambda)A(\lambda)=I_n$。所以 $A(\lambda)$ 可逆。$\blacksquare$
:::

::: note 本编注 · 真正的分界线：多项式环里的「单位」 {#note-3.8-units}

在数域里，任何非零数都可以做除数；在多项式环 $P[\lambda]$ 里，**只有非零常数**有乘法逆元（若 $p(\lambda)q(\lambda)=1$，则两者次数都为 $0$）。这就是定理 3.8.1 的全部内容：

- **满秩**：$|A(\lambda)|$ 是**非零多项式**（可以是非常数，如 $\lambda(\lambda+1)$）；
- **可逆**：$|A(\lambda)|$ 是**非零常数**（多项式环里的单位）。

中间差的那一类，正是「非零非常数多项式」。所以 $\lambda$ 矩阵的「满秩」比「可逆」严格更弱；例 3.8.2 就是满秩但不可逆的标本。

**与数字矩阵对照**：数字矩阵的行列式是一个**数**；数非零就可逆。$\lambda$ 矩阵的行列式是一个**多项式**；多项式非零不一定可逆——它可能取零值，也可能次数大于 $0$。把「非零」误当成「可逆」，是这一节最常见的错误。
:::

::: ex 例 3.8.A（新增）· 判断可逆并求逆 {#ex-3.8.A}

判断下列 $\lambda$ 矩阵是否可逆；可逆的求出逆矩阵。

$$A(\lambda)=\begin{bmatrix}\lambda&1\\1&0\end{bmatrix},\qquad
B(\lambda)=\begin{bmatrix}\lambda&1\\0&\lambda+1\end{bmatrix},\qquad
C(\lambda)=\begin{bmatrix}2&\lambda\\0&1\end{bmatrix}.$$

::: sol 解答

**$A(\lambda)$**：$|A(\lambda)|=-1$，是非零常数，故可逆。由二阶伴随矩阵公式（主对角互换、副对角变号），

$$A(\lambda)^{-1}=\frac1{-1}\begin{bmatrix}0&-1\\-1&\lambda\end{bmatrix}
=\begin{bmatrix}0&1\\1&-\lambda\end{bmatrix}.$$

验算：

$$\begin{bmatrix}\lambda&1\\1&0\end{bmatrix}\begin{bmatrix}0&1\\1&-\lambda\end{bmatrix}
=\begin{bmatrix}1&\lambda-\lambda\\0&1\end{bmatrix}=I_2.$$

**$B(\lambda)$**：$|B(\lambda)|=\lambda(\lambda+1)$，不是常数，故**不可逆**（尽管它满秩，秩为 $2$）。形式上写出的 $\operatorname{diag}(1/\lambda,1/(\lambda+1))$ 不是 $\lambda$ 矩阵。

**$C(\lambda)$**：$|C(\lambda)|=2$，是非零常数，故可逆。直接解或套二阶公式：

$$C(\lambda)^{-1}=\frac12\begin{bmatrix}1&-\lambda\\0&2\end{bmatrix}
=\begin{bmatrix}\tfrac12&-\tfrac\lambda2\\[2pt]0&1\end{bmatrix}.$$

验算：

$$\begin{bmatrix}2&\lambda\\0&1\end{bmatrix}\begin{bmatrix}\tfrac12&-\tfrac\lambda2\\0&1\end{bmatrix}
=\begin{bmatrix}1&-\lambda+\lambda\\0&1\end{bmatrix}=I_2. \qquad\blacksquare$$
:::
:::

::: note 本编注 · 三个层次，一张表说清 {#note-3.8-three-levels}

| 层次 | 判据 | 例 |
|:--|:--|:--|
| 零矩阵 | 所有元素为零 | $O$ |
| 满秩（秩 $=n$） | 存在 $n$ 阶子式不恒为零，即 $\det A(\lambda)\not\equiv0$ | $\operatorname{diag}(\lambda,\lambda+1)$ |
| 可逆 | $\det A(\lambda)$ 是**非零常数** | $\operatorname{diag}(2,3)$、$\begin{bmatrix}\lambda&1\\1&0\end{bmatrix}$ |

从「满秩」到「可逆」，要额外跨过「行列式不能是次数 $\ge1$ 的多项式」这一关。考试里判断 $\lambda$ 矩阵可逆，先算行列式，再看它是不是常数——不要只看秩。
:::

<a id="sec-3.8.4"></a>

## 3.8.4 初等变换与初等矩阵

数字矩阵的初等变换是消元法的动作；$\lambda$ 矩阵的初等变换形式相同，只是第三种变换的乘子可以是**多项式**。这套动作是把 $\lambda I-A$ 化成标准形的工具。

::: def 定义 3.8.4 · $\lambda$ 矩阵的初等变换 {#def-3.8.4}

下列三种变换称为 $\lambda$ 矩阵的**初等变换**：

（1）$\lambda$ 矩阵的两行 / 列互换位置；

（2）$\lambda$ 矩阵的某一行 / 列乘以非零常数 $k$；

（3）$\lambda$ 矩阵的某一行 / 列的 $\varphi(\lambda)$ 倍加到另一行 / 列，其中 $\varphi(\lambda)\in P_n(\lambda)$。
:::

对单位阵施行三种初等变换，得到三种**初等矩阵**：

1. 任两行 / 列互换，记为 $P(i,j)$；
2. 用不为零的数 $k$ 乘某行 / 列，记为 $P(i(k))$；
3. 用 $\varphi(\lambda)$ 乘第 $j$ 行 / 列并加到第 $i$ 行 / 列上去，记为 $P(i,j(\varphi))$。

::: note 注 3′（课件原文；原编号与 3.8.2 的注 3 重复，见[勘误 E3.11](errata.md#errata-3.8)）· 左乘与右乘 {#note-3.8-left-right}

与数字矩阵一样，对 $\lambda$ 矩阵作一次**初等行变换**意味着**左乘**相应的初等矩阵；作一次**初等列变换**意味着**右乘**相应的初等矩阵。
:::

::: note 注 4（课件原文）· 初等矩阵都可逆，初等变换不改变秩 {#note-3.8-invariants}

由于三种初等矩阵的行列式均为非零常数，故初等矩阵都是可逆的，且对 $\lambda$ 矩阵作初等变换不改变它的秩。
:::

::: note 本编补 · 三种初等矩阵的行列式与显式形状 {#note-3.8-elementary-det}

- $P(i,j)$：交换单位阵的第 $i$、$j$ 行，$|P(i,j)|=-1$；
- $P(i(k))$：把单位阵的第 $i$ 行乘以 $k\ne0$，$|P(i(k))|=k$；
- $P(i,j(\varphi))$：把单位阵的第 $j$ 行的 $\varphi(\lambda)$ 倍加到第 $i$ 行，$|P(i,j(\varphi))|=1$。

三者都是非零常数，故由 [@thm-3.8.1] 都可逆。具体地，若把 $P(i,j(\varphi))$ 定义为「第 $j$ 行的 $\varphi$ 倍加到第 $i$ 行」，则

$$P(i,j(\varphi))=I+\varphi(\lambda)\boldsymbol e_i\boldsymbol e_j^{\mathrm T}\quad(i\ne j),$$

左乘它实现同名行变换；右乘它的转置 $P(i,j(\varphi))^{\mathrm T}=I+\varphi(\lambda)\boldsymbol e_j\boldsymbol e_i^{\mathrm T}$ 实现同名列变换（把第 $j$ 列的 $\varphi$ 倍加到第 $i$ 列）。记不住转置也没关系：只要记住「行变换左乘、列变换右乘，且乘子放在正确的下标位置」。

**为什么秩不变**：初等矩阵可逆，而乘以可逆矩阵不改变秩——这与 [3.1](sec31.md) 的相抵变换同一个道理；区别只在于这里的「可逆」是 $\lambda$ 矩阵意义下的可逆（行列式为非零常数）。
:::

::: note 本编注 · 初等变换是「可逆动作」，因此定义了一种相抵 {#note-3.8-equivalence}

每种初等变换都有同类型的逆变换：

- 交换两次回到原样；
- 乘以 $k$ 后再乘以 $k^{-1}$ 回到原样；
- 把第 $j$ 行的 $\varphi$ 倍加到第 $i$ 行后，再把第 $j$ 行的 $-\varphi$ 倍加到第 $i$ 行，回到原样。

所以「$A(\lambda)$ 能经有限次初等变换化成 $B(\lambda)$」是一个**等价关系**，称为 $\lambda$ 矩阵的**相抵**。它与 [3.1](sec31.md) 数字矩阵的相抵完全平行；[下半页](sec38b.md)要找的，正是这个等价关系下的**标准形**（Smith 标准形）。

注意第三种变换的乘子必须是**多项式**。像 $1/\lambda$ 这样的有理函数不能当乘子——那会把 $\lambda$ 矩阵变成有理函数矩阵，越出讨论范围。
:::

::: ex 例 3.8.B（本编例，为下半铺路）· 可逆的 $\lambda$ 矩阵相抵于 $I$ {#ex-3.8.B}

用初等变换把 $A(\lambda)=\begin{bmatrix}\lambda&1\\1&0\end{bmatrix}$ 化为单位阵。

::: sol 解答

$$A(\lambda)=\begin{bmatrix}\lambda&1\\1&0\end{bmatrix}
\xrightarrow{R_1\leftrightarrow R_2}
\begin{bmatrix}1&0\\\lambda&1\end{bmatrix}
\xrightarrow{R_2-\lambda R_1}
\begin{bmatrix}1&0\\0&1\end{bmatrix}=I_2.$$

两步都是初等变换（交换、用 $-\lambda$ 乘第 $1$ 行加到第 $2$ 行）。这与 [@ex-3.8.A] 的结论一致：$|A(\lambda)|=-1$ 是非零常数，$A(\lambda)$ 可逆；而**可逆的 $\lambda$ 矩阵总能化成 $I$**（[下半页](sec38b.md#cor-3.8.1) 的唯一性 $\Rightarrow$ 可逆者只能化到 $I$；这与数字矩阵「可逆矩阵相抵于 $I$」是同一件事）。∎
:::
:::

::: ex 例 3.8.C（本编例，预告 Smith 标准形）· 不改变秩，但能造出 $1$ {#ex-3.8.C}

用初等变换把 $A(\lambda)=\begin{bmatrix}\lambda&0\\0&\lambda+1\end{bmatrix}$ 化成 $\begin{bmatrix}1&0\\0&\lambda(\lambda+1)\end{bmatrix}$。

::: sol 解答

$$\begin{aligned}
\begin{bmatrix}\lambda&0\\0&\lambda+1\end{bmatrix}
&\xrightarrow{R_2+R_1}
\begin{bmatrix}\lambda&0\\\lambda&\lambda+1\end{bmatrix}
\xrightarrow{C_1-C_2}
\begin{bmatrix}\lambda&0\\-1&\lambda+1\end{bmatrix}\\
&\xrightarrow{R_1\leftrightarrow R_2}
\begin{bmatrix}-1&\lambda+1\\\lambda&0\end{bmatrix}
\xrightarrow{R_1\leftarrow -R_1}
\begin{bmatrix}1&-(\lambda+1)\\\lambda&0\end{bmatrix}\\
&\xrightarrow{C_2+(\lambda+1)C_1}
\begin{bmatrix}1&0\\\lambda&\lambda(\lambda+1)\end{bmatrix}
\xrightarrow{R_2-\lambda R_1}
\begin{bmatrix}1&0\\0&\lambda(\lambda+1)\end{bmatrix}.
\end{aligned}$$

每一步都是定义 3.8.4 允许的初等变换；乘子 $-\lambda$、$\lambda+1$ 都是多项式。最终矩阵与 $A(\lambda)$ 相抵，秩仍为 $2$，行列式仍为 $\lambda(\lambda+1)$（交换行与乘 $-1$ 各改变一次符号，相互抵消）。∎
:::
:::

**读法**：例 3.8.C 是 [下半页](sec38b.md)的缩影。原矩阵没有常数元素，但通过初等变换可以「造出」一个 $1$，然后把第一行 / 列清干净，剩下右下角的 $\lambda(\lambda+1)$。对一般的 $\lambda I-A$，反复做这件事，就会得到对角形

$$\operatorname{diag}\big(d_1(\lambda),\cdots,d_r(\lambda),0,\cdots,0\big),\qquad d_1\mid d_2\mid\cdots\mid d_r,$$

这就是 **Smith 标准形**；$d_i(\lambda)$ 称为**不变因子**。Jordan 块的阶数由这些不变因子的根与重数（初等因子）决定。本页只把工具摆好，标准形的存在与唯一性见[下半页](sec38b.md#thm-3.8.2)。

<a id="sec-3.8.5"></a>

## 3.8.5 小结与常见错误

::: note 一张表：数字矩阵 vs $\lambda$ 矩阵 {#note-3.8-compare}

| 概念 | 数字矩阵 | $\lambda$ 矩阵 |
|:--|:--|:--|
| 元素 | 数 | $\lambda$ 的多项式 |
| 秩 | 非零子式的最高阶数（子式是数） | 非零子式的最高阶数（子式是**多项式**，「非零」$=$ 不恒为零） |
| 满秩 | $\det A\ne0$ | $\det A(\lambda)\not\equiv0$ |
| 可逆 | $\det A\ne0$ | $\det A(\lambda)$ 是**非零常数** |
| 初等变换的乘子 | 非零数 | 非零常数（第 2 种）、**多项式**（第 3 种） |
| 初等变换的效果 | 左乘 / 右乘初等矩阵，不改变秩 | 完全相同，不改变秩 |

**三句话带走**：

1. **秩看子式**：$\lambda$ 矩阵的秩是「存在不恒为零的 $r$ 阶子式」的最大 $r$，不是某个 $\lambda$ 代入后的数值秩（[@note-3.8-pointwise]）。
2. **可逆看常数**：$\lambda$ 方阵可逆 $\iff$ 行列式是非零**常数**（[@thm-3.8.1]）；满秩只是必要条件，$\operatorname{diag}(\lambda,\lambda+1)$ 是标准反例。
3. **初等变换是工具**：三种变换对应三类初等矩阵，乘子可以是多项式；变换可逆、不改变秩，为[下半页](sec38b.md#method-3.8-smith)化 Smith 标准形做准备（[@def-3.8.4]、[@note-3.8-equivalence]）。
:::

::: think 常见错误清单 · 自查五条

1. **把 $\lambda$ 矩阵的秩当成逐点数值秩**：$\operatorname{diag}(\lambda,\lambda+1)$ 在 $\lambda=0$ 时数值秩为 $1$，但 $\lambda$ 矩阵的秩是 $2$（[@note-3.8-pointwise]）。
2. **认为满秩 $\Rightarrow$ 可逆**：$\operatorname{diag}(\lambda,\lambda+1)$ 满秩但不可逆；可逆要求行列式为非零常数（[@thm-3.8.1]）。
3. **求逆时把 $1/\lambda$ 当成多项式**：$1/\lambda$ 不是 $\lambda$ 矩阵的元素；形式上的「逆」若含 $1/\lambda$，就说明原矩阵不可逆。
4. **初等变换第三种乘子用了有理函数**：乘子必须是多项式 $\varphi(\lambda)$，不能用 $1/\lambda$。
5. **行列式非零就宣布可逆**：行列式是非零多项式还不够，必须是**非零常数**；先看次数，再看是否为零。
:::

::: ex 即时自测（不看上文，5 分钟）{#ex-3.8.quiz}

1. 写出 $\lambda$ 矩阵、$\lambda$ 矩阵的秩、$\lambda$ 矩阵可逆的定义；
2. 判断 $A(\lambda)=\begin{bmatrix}\lambda-1&0\\0&\lambda^2+1\end{bmatrix}$ 是否为 $\lambda$ 矩阵，求其秩，并判断是否可逆；
3. 设 $B(\lambda)=\begin{bmatrix}1&\lambda\\0&2\end{bmatrix}$，判断是否可逆；若可逆，求 $B(\lambda)^{-1}$；
4. 证明：对 $\lambda$ 矩阵作一次初等行变换不改变其秩；
5. 用初等变换把 $\begin{bmatrix}\lambda&0\\0&\lambda+1\end{bmatrix}$ 化成 $\begin{bmatrix}1&0\\0&\lambda(\lambda+1)\end{bmatrix}$，并说明每一步用了哪条初等变换。

::: sol 参考要点

1. 定义见 [@def-3.8.1]、[@def-3.8.2]、[@def-3.8.3]。秩：非零子式的最高阶数，「非零」指多项式不恒为零；可逆：存在同阶 $\lambda$ 矩阵 $B(\lambda)$ 使 $A(\lambda)B(\lambda)=B(\lambda)A(\lambda)=I$。
2. 是 $\lambda$ 矩阵（元素都是多项式）；$\det A(\lambda)=(\lambda-1)(\lambda^2+1)$ 不恒为零，故秩为 $2$；但行列式不是常数，故**不可逆**。
3. $|B(\lambda)|=2$ 是非零常数，故可逆。由二阶伴随公式，
   $$B(\lambda)^{-1}=\frac12\begin{bmatrix}2&-\lambda\\0&1\end{bmatrix}
   =\begin{bmatrix}1&-\tfrac\lambda2\\[2pt]0&\tfrac12\end{bmatrix}.$$
   验算 $B(\lambda)B(\lambda)^{-1}=I_2$。
4. 初等行变换 $=$ 左乘初等矩阵 $P$；$|P|$ 是非零常数，故 $P$ 可逆。乘以可逆矩阵不改变秩（与 [3.1](sec31.md) 的相抵论证相同）：若 $r$ 阶子式 $M$ 非零，则 $PA$ 的相应子式等于同一个非零常数乘 $M$，仍是不恒为零的多项式；反之亦然。
5. 步骤见 [@ex-3.8.C]：$R_2+R_1$、$C_1-C_2$、$R_1\leftrightarrow R_2$、$R_1\leftarrow -R_1$、$C_2+(\lambda+1)C_1$、$R_2-\lambda R_1$——依次是第 3、3、1、2、3、3 种初等变换。
:::
:::

> **下一站**：[3.8 下半 · Smith 标准形与 Jordan 标准形](sec38b.md)——把本页的秩、可逆性与初等变换接成一条流水线：行列式因子 $\to$ Smith 标准形 $\to$ 不变因子 $\to$ 初等因子 $\to$ Jordan 块 $\to$ Jordan 标准形，最后落到「相似意义下的最简阵」与 Frobenius 定理。
