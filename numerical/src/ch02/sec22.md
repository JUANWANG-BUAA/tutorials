# 2.2 四个基本子空间与投影

2.1 建立了正交的语言，本节把它用到**矩阵**上，回答一个看似简单、却撑起半本数值线性代数的问题：**矩阵 $A$ 把空间分成哪几块？它们的维数与正交关系是什么？** 答案由四个基本子空间给出（2.2.1–2.2.2）：四个空间分成两对，每对互为正交补，输入与输出空间因此各被唯一地拆开。有了这种拆法，「求一个不相容方程组的最优解」「把向量投影到子空间」就有了统一的几何图像（2.2.3–2.2.5），最小二乘也随之落地。

<aside class="lesson-brief" aria-label="2.2 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>矩阵乘法与转置；线性相关与秩；齐次方程组解空间的结构；2.1 的正交与正交基坐标公式。</p></div>
<div><span class="brief-label">TARGET</span><strong>本节要建立</strong><p>四个基本子空间 + 两对正交补 + 秩定理；正交分解定理；投影矩阵 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ 的三条性质；最小二乘的正交条件 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>给定一个具体矩阵，能写出四个子空间的一组基与维数；能画出/说出「$\boldsymbol{b}$ 分解为列空间分量 + 左零空间分量」的几何图；能自己推导正态方程，并说清它为什么就是「余项垂直」的代数翻译。</p></div>
</aside>

<a id="sec-2.2.1"></a>

## 2.2.1 四个基本子空间

::: intuition 直觉 · 一张图装下全部
把 $A\boldsymbol{x}=\boldsymbol{b}$ 想成一条**流水线**：输入 $\boldsymbol{x}\in\mathbb{R}^n$ 进去，输出 $\boldsymbol{b}\in\mathbb{R}^m$ 出来。

- **输入侧**分成两块：能被送到输出的那部分（**行空间**），和进去就被「吃掉」、直接变零的那部分（**零空间**）。这两块**正交**，合起来正好是整个输入空间。
- **输出侧**也分成两块：能被送到的那些点（**列空间**），和永远到不了的那些点（**左零空间**）。这两块同样**正交**，合起来是整个输出空间。

于是整条流水线的信息，被压缩成四个数（维数）：$r,\ n-r,\ r,\ m-r$。所谓「四个基本子空间」，说到底就是这四个数。
:::

::: def 定义 2.2.1 · 四个基本子空间 {#def-2.2.1}
设 $A\in\mathbb{R}^{m\times n}$，记 $\operatorname{rank}A=r$，$C(A)$ 与 $N(A)$ 分别为其列空间与零空间。定义

$$\text{列空间：}\quad C(A)=\{A\boldsymbol{x}:\boldsymbol{x}\in\mathbb{R}^n\}\subseteq\mathbb{R}^m,\qquad
\text{零空间：}\quad N(A)=\{\boldsymbol{x}\in\mathbb{R}^n:A\boldsymbol{x}=\boldsymbol{0}\}\subseteq\mathbb{R}^n,$$

$$\text{行空间：}\quad C(A^{\mathrm T})=\{A^{\mathrm T}\boldsymbol{y}:\boldsymbol{y}\in\mathbb{R}^m\}\subseteq\mathbb{R}^n,\qquad
\text{左零空间：}\quad N(A^{\mathrm T})=\{\boldsymbol{y}\in\mathbb{R}^m:A^{\mathrm T}\boldsymbol{y}=\boldsymbol{0}\}\subseteq\mathbb{R}^m .$$
:::

::: thm 定理 2.2.1（新增） · 秩定理与维数公式 {#thm-2.2.1}
设 $A\in\mathbb{R}^{m\times n}$，则

$$\operatorname{rank}A=\dim C(A)=\dim C(A^{\mathrm T})\qquad(\text{行秩}=\text{列秩}=r), \tag{2.5}$$

$$\dim N(A)=n-r,\qquad \dim N(A^{\mathrm T})=m-r . \tag{2.6}$$

::: proof 证明
**（2.6）：** 零空间就是齐次方程组 $A\boldsymbol{x}=\boldsymbol{0}$ 的解空间。对 $A$ 做行变换（不改变解空间，见[第三章](../ch01/sec11.md#roadmap)）化为行简化阶梯形，设主元个数为 $r$，则自由未知量有 $n-r$ 个，每个自由未知量给一个基向量，故 $\dim N(A)=n-r$。同法作用于 $A^{\mathrm T}$ 得 $\dim N(A^{\mathrm T})=m-r$。**且主元个数 = 线性无关的行数 = 行秩**。

**（2.5）：** 行简化阶梯形的主元个数既等于行秩（主元所在行给出极大无关行组）也等于列秩（主元所在列给出极大无关列组）。也可以换个角度看：对 $A$ 做**初等行变换** $A\to PA$（$P$ 可逆）不改变列向量间的线性关系（$\sum c_i\boldsymbol{a}_i=\boldsymbol{0}\iff\sum c_i(P\boldsymbol{a}_i)=\boldsymbol{0}$），故 $\operatorname{rank}$ 在行变换下不变；化到阶梯形后非零行数即秩。∎

**四个数的速记法：** 输入空间 $\mathbb{R}^n$ 被 $r$ 与 $n-r$ 分完，输出空间 $\mathbb{R}^m$ 被 $r$ 与 $m-r$ 分完。**两个 $r$ 一样大**——这正是行秩 = 列秩的内容，也是「$A$ 与 $A^{\mathrm T}$ 秩相同」的依据。
:::

:::

::: thm 定理 2.2.2（新增） · 两对正交补 {#thm-2.2.2}
设 $A\in\mathbb{R}^{m\times n}$，则

$$C(A^{\mathrm T})=N(A)^{\perp}\qquad\text{（行空间 = 零空间的正交补）}, \tag{2.7}$$

$$C(A)=N(A^{\mathrm T})^{\perp}\qquad\text{（列空间 = 左零空间的正交补）}. \tag{2.8}$$

即 $\mathbb{R}^n=C(A^{\mathrm T})\oplus N(A)$、$\mathbb{R}^m=C(A)\oplus N(A^{\mathrm T})$ 是**正交直和分解**。

::: proof 证明
**先看（2.7）的「$\subseteq$」。** 设 $\boldsymbol{v}\in C(A^{\mathrm T})$，即 $\boldsymbol{v}=A^{\mathrm T}\boldsymbol{y}$ 对某 $\boldsymbol{y}$。对任意 $\boldsymbol{x}\in N(A)$，

$$\boldsymbol{v}^{\mathrm T}\boldsymbol{x}=(A^{\mathrm T}\boldsymbol{y})^{\mathrm T}\boldsymbol{x}=\boldsymbol{y}^{\mathrm T}A\boldsymbol{x}=\boldsymbol{y}^{\mathrm T}\boldsymbol{0}=0,$$

故 $\boldsymbol{v}\perp N(A)$，即 $C(A^{\mathrm T})\subseteq N(A)^{\perp}$。

**再用维数夹逼证相等。** 一个子空间的正交补的维数是 $\dim \mathcal{S}^{\perp}=n-\dim\mathcal{S}$（因为「与 $\mathcal{S}$ 的每个基向量内积为零」是 $\dim\mathcal{S}$ 个独立线性约束）。由（2.6），$\dim N(A)^{\perp}=n-(n-r)=r$。而 $\dim C(A^{\mathrm T})=r$（行秩）。**子空间包含 + 维数相等 ⟹ 相等**，故（2.7）成立。

**（2.8）：** 把 $A$ 换成 $A^{\mathrm T}$ 代入（2.7）：$C(A)=N(A^{\mathrm T})^{\perp}$。∎
:::

:::

**这两条定理的用处，远不止「知道四个维数」。** 由（2.8），$\mathbb{R}^m$ 中**任何**向量 $\boldsymbol{b}$ 都能唯一地分解为

$$\boldsymbol{b}=\underbrace{\boldsymbol{p}}_{\in C(A)}+\underbrace{\boldsymbol{e}}_{\in N(A^{\mathrm T})},\qquad \boldsymbol{p}\perp\boldsymbol{e} . \tag{2.9}$$

这一步分解是下面投影与最小二乘的全部基础：**$A\boldsymbol{x}=\boldsymbol{b}$ 有解 ⟺ $\boldsymbol{b}\in C(A)$（即 $\boldsymbol{e}=\boldsymbol{0}$）；无解时，能做的只剩让 $\boldsymbol{e}$ 尽量小——而（2.9）说明，「垂直的那个 $\boldsymbol{e}$」是最短的。**

::: ex 例 2.2.1（新增） · 四个子空间的基与维数 {#ex-2.2.1}
设 $A\in\mathbb{R}^{3\times4}$，

$$A=\begin{pmatrix}1&2&3&1\\2&4&6&3\\1&2&3&2\end{pmatrix}.$$

求 $r$、四个子空间的一组基与维数。

::: proof 解
**化行简化阶梯形。** 第 2 行减 $2\times$第 1 行、第 3 行减第 1 行：

$$\begin{pmatrix}1&2&3&1\\0&0&0&1\\0&0&0&1\end{pmatrix}\ \xrightarrow{\ \text{第 3 行减第 2 行}\ }\ 
\begin{pmatrix}1&2&3&1\\0&0&0&1\\0&0&0&0\end{pmatrix}\ \xrightarrow{\ \text{第 1 行减第 2 行}\ }\
\begin{pmatrix}1&2&3&0\\0&0&0&1\\0&0&0&0\end{pmatrix}.$$

主元在第 1、4 列，故 $r=2$。

**列空间（$\subseteq\mathbb{R}^3$，维数 $2$）：** 主元所在列（第 1、4 列）给出极大无关列组：

$$C(A)=\operatorname{span}\bigl\{(1,2,1)^{\mathrm T},\ (1,3,2)^{\mathrm T}\bigr\}.$$

（要用 $A$ 的**原始**列，而不是化简后的列——行变换不保持列空间。）

**行空间（$\subseteq\mathbb{R}^4$，维数 $2$）：** 化简后的非零行给出基：

$$C(A^{\mathrm T})=\operatorname{span}\bigl\{(1,2,3,0)^{\mathrm T},\ (0,0,0,1)^{\mathrm T}\bigr\}.$$

**零空间（$\subseteq\mathbb{R}^4$，维数 $4-2=2$）：** 解 $A\boldsymbol{x}=\boldsymbol{0}$，化简后的方程组是 $x_1+2x_2+3x_3=0,\ x_4=0$。自由未知量 $x_2,x_3$ 各取一组：

$$N(A)=\operatorname{span}\bigl\{(-2,1,0,0)^{\mathrm T},\ (-3,0,1,0)^{\mathrm T}\bigr\}.$$

**左零空间（$\subseteq\mathbb{R}^3$，维数 $3-2=1$）：** 解 $A^{\mathrm T}\boldsymbol{y}=\boldsymbol{0}$。由 $A$ 的行关系「第 3 行 $-$ 第 2 行 $+$ 第 1 行 $=\boldsymbol{0}$」（核对：$(1-2+1,\ 2-4+2,\ 3-6+3,\ 2-3+1)=(0,0,0,0)$ ✓），得

$$N(A^{\mathrm T})=\operatorname{span}\bigl\{(1,-1,1)^{\mathrm T}\bigr\}.$$

**正交性核对：** $(1,-1,1)^{\mathrm T}$ 与 $C(A)$ 的每个基向量内积为零：$(1,-1,1)\cdot(1,2,1)=1-2+1=0$ ✓；$(1,-1,1)\cdot(1,3,2)=1-3+2=0$ ✓——正是（2.8）。$(-2,1,0,0)$ 与行空间基向量内积：$-2+2+0+0=0$ ✓；$(-3,0,1,0)\cdot(1,2,3,0)=-3+0+3+0=0$ ✓——正是（2.7）。∎
:::

:::

<a id="sec-2.2.2"></a>

## 2.2.2 正交补与正交分解

上一小节末尾的（2.9）值得单独讲成一条定理：后面所有「投影类算法」的合法性，都来自它。

::: def 定义 2.2.2 · 正交补 {#def-2.2.2}
设 $\mathcal{S}$ 是内积空间 $V$ 的子空间。称

$$\mathcal{S}^{\perp}=\{\boldsymbol{x}\in V:\langle\boldsymbol{x},\boldsymbol{s}\rangle=0\ \ \forall\boldsymbol{s}\in\mathcal{S}\}$$

为 $\mathcal{S}$ 的**正交补**（orthogonal complement）。
:::

::: thm 定理 2.2.3（新增） · 正交分解定理 {#thm-2.2.3}
设 $\mathcal{S}$ 是内积空间 $V$（有限维）的子空间，则每个 $\boldsymbol{x}\in V$ 都可以**唯一**地写成

$$\boldsymbol{x}=\boldsymbol{p}+\boldsymbol{e},\qquad \boldsymbol{p}\in\mathcal{S},\quad \boldsymbol{e}\in\mathcal{S}^{\perp},$$

且 $\lVert\boldsymbol{x}\rVert^2=\lVert\boldsymbol{p}\rVert^2+\lVert\boldsymbol{e}\rVert^2$。称 $\boldsymbol{p}$ 为 $\boldsymbol{x}$ 在 $\mathcal{S}$ 上的**正交投影**，$\boldsymbol{e}$ 为**正交余项**。

进一步，若 $\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_k\}$ 是 $\mathcal{S}$ 的标准正交基，则投影有**显式公式**

$$\boldsymbol{p}=\sum_{i=1}^{k}\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i . \tag{2.10}$$

::: proof 证明
**存在性。** 取 $\mathcal{S}$ 的标准正交基 $\{\boldsymbol{q}_1,\dots,\boldsymbol{q}_k\}$（由 Gram–Schmidt，见 [2.3.1](sec23.md#sec-2.3.1)，总是可以构出）。令

$$\boldsymbol{p}=\sum_{i=1}^{k}\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i,\qquad \boldsymbol{e}=\boldsymbol{x}-\boldsymbol{p} .$$

显然 $\boldsymbol{p}\in\mathcal{S}$。验证 $\boldsymbol{e}\perp\mathcal{S}$：只需验证 $\boldsymbol{e}$ 与基向量正交。对任意 $j$，

$$\langle\boldsymbol{e},\boldsymbol{q}_j\rangle=\langle\boldsymbol{x},\boldsymbol{q}_j\rangle-\sum_{i=1}^{k}\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\langle\boldsymbol{q}_i,\boldsymbol{q}_j\rangle=\langle\boldsymbol{x},\boldsymbol{q}_j\rangle-\langle\boldsymbol{x},\boldsymbol{q}_j\rangle=0$$

（用标准正交性 $\langle\boldsymbol{q}_i,\boldsymbol{q}_j\rangle=\delta_{ij}$）。故 $\boldsymbol{e}\in\mathcal{S}^{\perp}$，存在性得证，且（2.10）成立。

**唯一性。** 设 $\boldsymbol{x}=\boldsymbol{p}_1+\boldsymbol{e}_1=\boldsymbol{p}_2+\boldsymbol{e}_2$ 是两种分解。相减得 $(\boldsymbol{p}_1-\boldsymbol{p}_2)+(\boldsymbol{e}_1-\boldsymbol{e}_2)=\boldsymbol{0}$，其中第一项属于 $\mathcal{S}$、第二项属于 $\mathcal{S}^{\perp}$。两边与 $\boldsymbol{p}_1-\boldsymbol{p}_2$ 作内积：

$$0=\lVert\boldsymbol{p}_1-\boldsymbol{p}_2\rVert^2+\langle\boldsymbol{e}_1-\boldsymbol{e}_2,\ \boldsymbol{p}_1-\boldsymbol{p}_2\rangle=\lVert\boldsymbol{p}_1-\boldsymbol{p}_2\rVert^2 .$$

故 $\boldsymbol{p}_1=\boldsymbol{p}_2$，进而 $\boldsymbol{e}_1=\boldsymbol{e}_2$。（**「子空间与它的正交补只交于零向量」，这就是唯一性的本质**：$\mathcal{S}\cap\mathcal{S}^{\perp}=\{\boldsymbol{0}\}$。）

**勾股：** $\boldsymbol{p}\perp\boldsymbol{e}$，故 $\lVert\boldsymbol{x}\rVert^2=\lVert\boldsymbol{p}+\boldsymbol{e}\rVert^2=\lVert\boldsymbol{p}\rVert^2+2\langle\boldsymbol{p},\boldsymbol{e}\rangle+\lVert\boldsymbol{e}\rVert^2=\lVert\boldsymbol{p}\rVert^2+\lVert\boldsymbol{e}\rVert^2$。∎
:::

:::

::: intuition 直觉 · 投影 = 影子，余项 = 垂直距离
把 $\mathcal{S}$ 想成地面，$\boldsymbol{x}$ 是一根斜插在地上的杆子。太阳当头时，杆子在地面的**影子**就是 $\boldsymbol{p}$，杆子离开地面的**垂直高度**就是余项 $\boldsymbol{e}$。影子、垂高和杆子本身构成直角三角形，勾股定理自然成立。投影的「最优性」也就一眼可见：**要在地面上找一个点离杆顶最近，那就是正下方的影子**——挪到任何别处，都会多走一段斜路。
:::

::: thm 定理 2.2.4（新增） · 投影是最近点 {#thm-2.2.4}
设 $\boldsymbol{p}$ 是 $\boldsymbol{x}$ 在子空间 $\mathcal{S}$ 上的正交投影，则对任意 $\boldsymbol{s}\in\mathcal{S},\boldsymbol{s}\neq\boldsymbol{p}$，

$$\lVert\boldsymbol{x}-\boldsymbol{p}\rVert\lt\lVert\boldsymbol{x}-\boldsymbol{s}\rVert .$$

即 $\boldsymbol{p}$ 是 $\mathcal{S}$ 中与 $\boldsymbol{x}$ **距离最小**的唯一向量。

::: proof 证明
对任意 $\boldsymbol{s}\in\mathcal{S}$，$\boldsymbol{p}-\boldsymbol{s}\in\mathcal{S}$，故 $\boldsymbol{p}-\boldsymbol{s}\perp\boldsymbol{e}=\boldsymbol{x}-\boldsymbol{p}$。于是

$$\lVert\boldsymbol{x}-\boldsymbol{s}\rVert^2=\lVert(\boldsymbol{x}-\boldsymbol{p})+(\boldsymbol{p}-\boldsymbol{s})\rVert^2=\lVert\boldsymbol{e}\rVert^2+\lVert\boldsymbol{p}-\boldsymbol{s}\rVert^2\ge\lVert\boldsymbol{e}\rVert^2=\lVert\boldsymbol{x}-\boldsymbol{p}\rVert^2,$$

等号成立当且仅当 $\boldsymbol{p}=\boldsymbol{s}$。∎
:::

:::

::: ex 例 2.2.2（新增） · 把向量分解到「直线 + 垂直方向」 {#ex-2.2.2}
把 $\boldsymbol{x}=(1,1,1)^{\mathrm T}$ 分解为它在 $\mathcal{S}=\operatorname{span}\{(1,1,0)^{\mathrm T}\}$ 上的投影与余项，并用定理 2.2.4 验证最近性。

::: proof 解
把基向量单位化：$\boldsymbol{q}=\frac{1}{\sqrt2}(1,1,0)^{\mathrm T}$。由（2.10）：

$$p=\langle\boldsymbol{x},\boldsymbol{q}\rangle=\frac{1+1+0}{\sqrt2}=\sqrt2\ \Longrightarrow\ \boldsymbol{p}=\sqrt2\,\boldsymbol{q}=\frac{\sqrt2}{\sqrt2}\begin{pmatrix}1\\1\\0\end{pmatrix}=\begin{pmatrix}1\\1\\0\end{pmatrix}.$$

$$\boldsymbol{e}=\boldsymbol{x}-\boldsymbol{p}=\begin{pmatrix}0\\0\\1\end{pmatrix}.$$

**核对：** $\boldsymbol{e}^{\mathrm T}\boldsymbol{p}=0+0+0=0$ ✓；$\lVert\boldsymbol{p}\rVert^2+\lVert\boldsymbol{e}\rVert^2=2+1=3=\lVert\boldsymbol{x}\rVert^2$ ✓（勾股）。

**最近性验证（数值）：** 在 $\mathcal{S}$ 中任意取 $\boldsymbol{s}=t(1,1,0)^{\mathrm T}$，则

$$\lVert\boldsymbol{x}-\boldsymbol{s}\rVert^2=(1-t)^2+(1-t)^2+1=2(1-t)^2+1\ \ge1=\lVert\boldsymbol{e}\rVert^2,$$

等号仅在 $t=1$（即 $\boldsymbol{s}=\boldsymbol{p}$）取到。**「最近」等价于「余项垂直于 $\mathcal{S}$」**——这一点在最小二乘里会变成可解的方程（正态方程）。∎
:::

:::

<a id="sec-2.2.3"></a>

## 2.2.3 投影矩阵

（2.10）要求先有 $\mathcal{S}$ 的标准正交基。可实际拿到手的，往往只是 $\mathcal{S}$ 的**任意**一组生成向量（矩阵 $A$ 的列），未必正交。投影矩阵要解决的就是这件事：不先正交化，也能直接把投影写出来。

::: intuition 直觉 · 用「斜」的基算出「正」的投影
设 $\mathcal{S}=C(A)$。$A$ 的列 $\boldsymbol{a}_1,\dots,\boldsymbol{a}_k$ 通常**不正交**，但投影照样写得出来。要算的 $\boldsymbol{p}$ 一定在列空间里，就把它写成 $\boldsymbol{p}=A\hat{\boldsymbol{x}}$，再让余项与 $C(A)$ 垂直：$A^{\mathrm T}(\boldsymbol{b}-A\hat{\boldsymbol{x}})=\boldsymbol{0}$。展开就是 $A^{\mathrm T}A\hat{\boldsymbol{x}}=A^{\mathrm T}\boldsymbol{b}$，于是

$$\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b},\qquad \boldsymbol{p}=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}=P\boldsymbol{b}.$$

**「先解一个 $k$ 阶小方程组（$A^{\mathrm T}A$ 是 $k\times k$、$k$ 为列数），再乘回去」**——投影的全部机制就这一句话。其中的 $P$ 就是投影矩阵。
:::

::: thm 定理 2.2.5（新增） · 投影矩阵与它的三条性质 {#thm-2.2.5}
设 $A\in\mathbb{R}^{m\times n}$ **列满秩**（$\operatorname{rank}A=n$，即各列线性无关），记

$$P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}\in\mathbb{R}^{m\times m}, \tag{2.11}$$

则 $P$ 是「到 $C(A)$ 上的正交投影算子」，即对任意 $\boldsymbol{b}\in\mathbb{R}^m$，$\boldsymbol{p}=P\boldsymbol{b}$ 是 $\boldsymbol{b}$ 在 $C(A)$ 上的正交投影。并且：

1. **对称：** $P^{\mathrm T}=P$；
2. **幂等：** $P^2=P$；
3. **特征值只能是 $0$ 或 $1$，且 $\operatorname{tr}P=\operatorname{rank}P=\operatorname{rank}A=n$**；相应地 $\lVert P\rVert_2=1$（当 $P\neq O$）。

反之，任何满足「对称 + 幂等」的实矩阵都是某个子空间上的正交投影矩阵。

::: proof 证明
**先证 $A^{\mathrm T}A$ 可逆。** 设 $A^{\mathrm T}A\boldsymbol{x}=\boldsymbol{0}$，左乘 $\boldsymbol{x}^{\mathrm T}$ 得 $\lVert A\boldsymbol{x}\rVert_2^2=\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x}=0$，故 $A\boldsymbol{x}=\boldsymbol{0}$；由 $A$ 列满秩得 $\boldsymbol{x}=\boldsymbol{0}$。即齐次方程 $A^{\mathrm T}A\boldsymbol{x}=\boldsymbol{0}$ 只有零解，故 $A^{\mathrm T}A$ 非奇异。

**$P\boldsymbol{b}\in C(A)$：** 显然——它就是 $A$ 乘上向量 $(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}$。

**余项垂直：** $A^{\mathrm T}(\boldsymbol{b}-P\boldsymbol{b})=A^{\mathrm T}\boldsymbol{b}-A^{\mathrm T}A(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}=A^{\mathrm T}\boldsymbol{b}-A^{\mathrm T}\boldsymbol{b}=\boldsymbol{0}$，即 $\boldsymbol{b}-P\boldsymbol{b}\in N(A^{\mathrm T})=C(A)^{\perp}$（用（2.8））。由 [@thm-2.2.3] 的唯一性，$P\boldsymbol{b}$ 就是正交投影。

**性质 1：** $(A(A^{\mathrm T}A)^{-1}A^{\mathrm T})^{\mathrm T}=A\bigl((A^{\mathrm T}A)^{-1}\bigr)^{\mathrm T}A^{\mathrm T}=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}=P$（$A^{\mathrm T}A$ 对称，其逆也对称）。

**性质 2：** $P^2=A(A^{\mathrm T}A)^{-1}\underbrace{A^{\mathrm T}A(A^{\mathrm T}A)^{-1}}_{I}A^{\mathrm T}=P$。

**性质 3：** 由 $P^2=P$，$P(\boldsymbol{v})=\lambda\boldsymbol{v}\Rightarrow\lambda^2=\lambda\Rightarrow\lambda\in\{0,1\}$。$P$ 可对角化（对称），故 $\operatorname{tr}P=\operatorname{rank}P=$ 非零特征值个数 $=\ \dim C(A)=n$。范数：对任意 $\boldsymbol{b}$，$\lVert P\boldsymbol{b}\rVert\le\lVert\boldsymbol{b}\rVert$（因为 $\lVert\boldsymbol{b}\rVert^2=\lVert P\boldsymbol{b}\rVert^2+\lVert\boldsymbol{b}-P\boldsymbol{b}\rVert^2$，勾股），且取 $\boldsymbol{b}\in C(A)$ 时 $\lVert P\boldsymbol{b}\rVert=\lVert\boldsymbol{b}\rVert$，故 $\lVert P\rVert_2=1$（$P\neq O$）。

**反之：** 若实矩阵 $S$ 满足 $S^{\mathrm T}=S=S^2$，记它的列空间为 $\mathcal{S}=C(S)$，则 $S$ 在 $\mathcal{S}$ 上恒等（$S\boldsymbol{s}=\boldsymbol{s}$）、在 $\mathcal{S}^{\perp}$ 上为零（由对称性，$\boldsymbol{y}\perp C(S)\Rightarrow S\boldsymbol{y}\in C(S)$ 且 $\boldsymbol{y}^{\mathrm T}S\boldsymbol{y}=0\Rightarrow S\boldsymbol{y}=\boldsymbol{0}$），故 $S$ 正是 $\mathcal{S}$ 上的正交投影。∎
:::

:::

::: note 三条性质的「指纹」作用
给定一个矩阵，**只要查「对称 + 幂等」就能判定它是正交投影**——比直接验证 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ 方便得多。[第三章](../ch01/sec11.md#roadmap)的 LU 稳定性分析、[第五章](../ch01/sec11.md#roadmap)的迭代法，都靠幂等性识别投影。反过来，矩阵若幂等但**不**对称（$S^2=S$，$S^{\mathrm T}\neq S$），它仍然是投影，只是不再是正交投影，而是**斜投影**（oblique projection）——余项不再垂直于子空间。见[习题 A2(b)](exercises.md)。
:::

::: ex 例 2.2.3（新增） · 手算一个投影矩阵 {#ex-2.2.3}
设 $A=\begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix}$（列满秩），求 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$，并验证三条性质；再把 $\boldsymbol{b}=(1,2,4)^{\mathrm T}$ 投影到 $C(A)$ 上。

::: proof 解
$$A^{\mathrm T}A=\begin{pmatrix}1&0&1\\0&1&1\end{pmatrix}\begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix}=\begin{pmatrix}2&1\\1&2\end{pmatrix},\qquad
(A^{\mathrm T}A)^{-1}=\frac{1}{3}\begin{pmatrix}2&-1\\-1&2\end{pmatrix}.$$

$$P=\frac13\begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix}\begin{pmatrix}2&-1\\-1&2\end{pmatrix}\begin{pmatrix}1&0&1\\0&1&1\end{pmatrix}
=\frac13\begin{pmatrix}1&0\\0&1\\1&1\end{pmatrix}\begin{pmatrix}2&-1&1\\-1&2&1\end{pmatrix}
=\frac13\begin{pmatrix}2&-1&1\\-1&2&1\\1&1&2\end{pmatrix}.$$

**验证：** $P^{\mathrm T}=P$ ✓（矩阵对称）。$P^2=\frac19\begin{pmatrix}2&-1&1\\-1&2&1\\1&1&2\end{pmatrix}^2=\frac19\begin{pmatrix}6&-3&3\\-3&6&3\\3&3&6\end{pmatrix}=\frac13\begin{pmatrix}2&-1&1\\-1&2&1\\1&1&2\end{pmatrix}=P$ ✓。$\operatorname{tr}P=\frac{2+2+2}{3}=2=\operatorname{rank}A$ ✓，$\lVert P\rVert_2=1$ ✓（数值：$P$ 的特征值为 $1,1,0$）。

**投影 $\boldsymbol{b}=(1,2,4)^{\mathrm T}$：**

$$\boldsymbol{p}=P\boldsymbol{b}=\frac13\begin{pmatrix}2-2+4\\-1+4+4\\1+2+8\end{pmatrix}=\frac13\begin{pmatrix}4\\7\\11\end{pmatrix}\approx\begin{pmatrix}1.3333\\2.3333\\3.6667\end{pmatrix}.$$

$$\boldsymbol{e}=\boldsymbol{b}-\boldsymbol{p}=\Bigl(-\frac13,-\frac13,\frac13\Bigr)^{\mathrm T},\qquad A^{\mathrm T}\boldsymbol{e}=\begin{pmatrix}1&0&1\\0&1&1\end{pmatrix}\boldsymbol{e}=\begin{pmatrix}-\frac13+\frac13\\-\frac13+\frac13\end{pmatrix}=\begin{pmatrix}0\\0\end{pmatrix}\ \checkmark .$$

**核对最小二乘解：** $\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}=\frac13\begin{pmatrix}2&-1\\-1&2\end{pmatrix}\begin{pmatrix}5\\6\end{pmatrix}=\frac13\begin{pmatrix}4\\7\end{pmatrix}=\bigl(\frac43,\frac73\bigr)^{\mathrm T}$，而 $A\hat{\boldsymbol{x}}=\frac13(4,7,11)^{\mathrm T}=\boldsymbol{p}$ ✓。**投影完全等价于最小二乘。**∎
:::

:::

<a id="sec-2.2.4"></a>

## 2.2.4 最小二乘与正态方程

::: intuition 直觉 · 无解时怎么办：找个「最像的」
$A\boldsymbol{x}=\boldsymbol{b}$ 无解，意味着 $\boldsymbol{b}$ 不在 $C(A)$ 里（$A$ 的列怎么组合都拼不出 $\boldsymbol{b}$）。这时退而求其次：**在 $C(A)$ 里找离 $\boldsymbol{b}$ 最近的向量**。由 [@thm-2.2.4]，最近点就是正交投影 $\boldsymbol{p}=P\boldsymbol{b}$，它的「原像」$\hat{\boldsymbol{x}}$ 就是最小二乘解。名字里的「最小二乘」来自要最小化的东西——残差向量的平方和

$$\lVert\boldsymbol{b}-A\boldsymbol{x}\rVert_2^2=\sum_{i=1}^{m}\bigl(b_i-\boldsymbol{a}_i^{\mathrm T}\boldsymbol{x}\bigr)^2$$

而「最近的充要条件就是垂直」这一条，把优化问题直接翻译成了线性方程组——这就引出下面的正态方程。
:::

::: def 定义 2.2.3 · 最小二乘解 {#def-2.2.3}
设 $A\in\mathbb{R}^{m\times n}$、$\boldsymbol{b}\in\mathbb{R}^m$。称 $\hat{\boldsymbol{x}}\in\mathbb{R}^n$ 为 $A\boldsymbol{x}=\boldsymbol{b}$ 的**最小二乘解**（least squares solution），若

$$\lVert A\hat{\boldsymbol{x}}-\boldsymbol{b}\rVert_2=\min_{\boldsymbol{x}\in\mathbb{R}^n}\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2 .$$

$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$ 称为**残差**（residual）。
:::

::: thm 定理 2.2.6（新增） · 正态方程与最小二乘解的刻画 {#thm-2.2.6}
设 $A\in\mathbb{R}^{m\times n}$、$\boldsymbol{b}\in\mathbb{R}^m$。

1. $\hat{\boldsymbol{x}}$ 是最小二乘解 $\iff$ $A^{\mathrm T}(\boldsymbol{b}-A\hat{\boldsymbol{x}})=\boldsymbol{0}$ $\iff$ $\hat{\boldsymbol{x}}$ 满足**正态方程**

$$A^{\mathrm T}A\,\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}; \tag{2.12}$$

2. 最小二乘解**总是存在**；且当 $A$ 列满秩时**唯一**，此时

$$\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b},\qquad
A\hat{\boldsymbol{x}}=P\boldsymbol{b},\qquad
\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}=(I-P)\boldsymbol{b}\in N(A^{\mathrm T});$$

3. 最小残差值的平方为 $\lVert\boldsymbol{r}\rVert_2^2=\boldsymbol{b}^{\mathrm T}(I-P)\boldsymbol{b}=\lVert\boldsymbol{b}\rVert_2^2-\lVert A\hat{\boldsymbol{x}}\rVert_2^2$（勾股分解）。

::: proof 证明
**（1）必要性：** 设 $\hat{\boldsymbol{x}}$ 最小化 $f(\boldsymbol{x})=\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2^2$。$f$ 是可微的凸二次函数，在极小点梯度为零：

$$\nabla f(\boldsymbol{x})=2A^{\mathrm T}(A\boldsymbol{x}-\boldsymbol{b})\Big|_{\boldsymbol{x}=\hat{\boldsymbol{x}}}=\boldsymbol{0}\ \Longleftrightarrow\ A^{\mathrm T}A\hat{\boldsymbol{x}}=A^{\mathrm T}\boldsymbol{b}.$$

**充分性**（这一步给出「最小」而非仅「驻点」）：若 $A^{\mathrm T}(\boldsymbol{b}-A\hat{\boldsymbol{x}})=\boldsymbol{0}$，记 $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}\in N(A^{\mathrm T})=C(A)^{\perp}$。对任意 $\boldsymbol{x}$，由勾股：

$$\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_2^2=\lVert A(\boldsymbol{x}-\hat{\boldsymbol{x}})\rVert_2^2+\lVert\boldsymbol{r}\rVert_2^2\ge\lVert\boldsymbol{r}\rVert_2^2 .$$

（交叉项 $\langle A(\boldsymbol{x}-\hat{\boldsymbol{x}}),\boldsymbol{r}\rangle=(A(\boldsymbol{x}-\hat{\boldsymbol{x}}))^{\mathrm T}\boldsymbol{r}=(\boldsymbol{x}-\hat{\boldsymbol{x}})^{\mathrm T}A^{\mathrm T}\boldsymbol{r}=0$。）故 $\hat{\boldsymbol{x}}$ 最小，且残差正是那个垂直分量。**几何与代数在此完全对应：正态方程就是「余项垂直」的代数写法。**

**（2）存在性：** 齐次方程 $A^{\mathrm T}A\boldsymbol{x}=\boldsymbol{0}$ 与 $A\boldsymbol{x}=\boldsymbol{0}$ 同解（一边显然，另一边左乘 $\boldsymbol{x}^{\mathrm T}$ 得 $\lVert A\boldsymbol{x}\rVert^2=0$），故

$$\operatorname{rank}(A^{\mathrm T}A)=\operatorname{rank}A\qquad\text{（两个矩阵的核相同，维数相同）}.$$

于是 $A^{\mathrm T}\boldsymbol{b}\in C(A^{\mathrm T})=C(A^{\mathrm T}A)$（因为 $\operatorname{rank}A^{\mathrm T}=\operatorname{rank}A=\operatorname{rank}(A^{\mathrm T}A)$ 且 $C(A^{\mathrm T}A)\subseteq C(A^{\mathrm T})$，维数相等即相等），正态方程有解。

**唯一性：** $A$ 列满秩 $\Rightarrow A^{\mathrm T}A$ 非奇异（[@thm-2.2.5] 证明第一段）$\Rightarrow$ 解唯一。

**（3）** 由 $\boldsymbol{b}=\boldsymbol{p}+\boldsymbol{r}$、$\boldsymbol{p}\perp\boldsymbol{r}$ 的勾股分解与 $\boldsymbol{p}=P\boldsymbol{b}$。∎
:::

:::

::: method 最小二乘的三种解法（本次只铺路，[第三章](../ch01/sec11.md#roadmap)细讲）

| 方法 | 方程 / 公式 | 复杂度 | 数值稳定性 |
|:--|:--|:--:|:--|
| **正态方程** | 解 $(A^{\mathrm T}A)\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$ | $mn^2+\frac13n^3$ | **差**：把 $\mathrm{cond}$ 平方了 |
| **QR 分解** | $A=QR$，解 $R\boldsymbol{x}=(Q^{\mathrm T}\boldsymbol{b})$ 的前 $n$ 行 | $2mn^2$ | **好**（[2.3.5](sec23.md#sec-2.3.5)） |
| **SVD** | $\boldsymbol{x}=V\Sigma^{+}U^{\mathrm T}\boldsymbol{b}$ | $\sim 2mn^2+11n^3$ | **最好**，且秩亏也能处理（[2.6.4](sec26.md#sec-2.6.4)） |

正态方程公式最简单、手算最方便，但它在浮点下会把问题的条件数**平方**——这是本章最重要的实用结论之一；[2.3.5](sec23.md#sec-2.3.5) 与 [2.7.2](sec27.md#sec-2.7.2) 实验二会用数值把它钉死。
:::

::: ex 例 2.2.4（新增） · 直线拟合：从数据到正态方程 {#ex-2.2.4}
用直线 $y=c_0+c_1x$ 拟合数据 $(0,1),(1,2),(2,2),(3,4)$，求最小二乘解并给出残差。

::: proof 解
设计矩阵与右端（每行是一个观测方程 $c_0+c_1x_i=y_i$）：

$$A=\begin{pmatrix}1&0\\1&1\\1&2\\1&3\end{pmatrix},\qquad\boldsymbol{b}=\begin{pmatrix}1\\2\\2\\4\end{pmatrix}
\ \Longrightarrow\
A^{\mathrm T}A=\begin{pmatrix}4&6\\6&14\end{pmatrix},\quad A^{\mathrm T}\boldsymbol{b}=\begin{pmatrix}9\\18\end{pmatrix}.$$

（$A^{\mathrm T}\boldsymbol{b}$ 的两个分量分别是 $\sum_iy_i=9$ 与 $\sum_ix_iy_i=0\cdot1+1\cdot2+2\cdot2+3\cdot4=18$——**第二个分量要用 $x_i$ 加权，不是简单求和**，这是最容易出错的一步。）

解正态方程（$\det(A^{\mathrm T}A)=4\times14-36=20$）：

$$\hat{\boldsymbol{x}}=\frac{1}{20}\begin{pmatrix}14&-6\\-6&4\end{pmatrix}\begin{pmatrix}9\\18\end{pmatrix}=\frac{1}{20}\begin{pmatrix}126-108\\-54+72\end{pmatrix}=\frac{1}{20}\begin{pmatrix}18\\18\end{pmatrix}=\begin{pmatrix}0.9\\0.9\end{pmatrix}.$$

**拟合直线：** $y=0.9+0.9x$。预测值 $(0.9,\ 1.8,\ 2.7,\ 3.6)^{\mathrm T}$，残差 $\boldsymbol{r}=(0.1,\ 0.2,\ -0.7,\ 0.4)^{\mathrm T}$。

**核对正交条件（这是最该做的检查）：**

$$A^{\mathrm T}\boldsymbol{r}=\begin{pmatrix}1&1&1&1\\0&1&2&3\end{pmatrix}\begin{pmatrix}0.1\\0.2\\-0.7\\0.4\end{pmatrix}=\begin{pmatrix}0.1+0.2-0.7+0.4\\0+0.2-1.4+1.2\end{pmatrix}=\begin{pmatrix}0\\0\end{pmatrix}\ \checkmark .$$

残差平方和 $\lVert\boldsymbol{r}\rVert_2^2=0.01+0.04+0.49+0.16=0.70$。

**本题的两个收获：** ① 计算 $A^{\mathrm T}\boldsymbol{b}$ 时，第二个分量极易算错，而 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$ 是一个免费**自检**——只要它不成立，前面就一定算错了；② 拟合结果对数据敏感：把最后一个点从 $4$ 改成 $5$，$\hat{\boldsymbol{x}}$ 就会明显移动——这正是 [2.4](sec24.md) 要量化的敏感性。∎
:::

:::

<a id="sec-2.2.5"></a>

## 2.2.5 加权最小二乘与一般内积下的投影

最后把「内积可以换」落到实处：换了内积，投影和最小二乘也就跟着换——这件事在统计与工程里每天都在发生。

::: intuition 直觉 · 换内积 = 换「距离的度量」 = 换「谁说了算」
普通最小二乘对每个观测**一视同仁**（残差平方等权）。可要是某个观测精度高一倍（方差小 4 倍），它就该「更说了算」——办法就是给残差**加权**。加权最小二乘的几何解释非常干净：它就是在**加权内积** $\langle\boldsymbol{x},\boldsymbol{y}\rangle_W=\boldsymbol{x}^{\mathrm T}W\boldsymbol{y}$ 之下做**正交投影**。**换内积 ⟹ 换「垂直」的定义 ⟹ 换投影 ⟹ 换最优解**，公式结构完全一样。
:::

::: note 课堂对照（2026 秋·庞刚）
「换内积 = 换几何」在课堂上出现过预告：[第 2 讲精编](../lectures/lec02.md)里讲范数等价性时老师点评「换个距离，这事就简单」——死磕欧氏距离解决不了的问题，换一种度量常常就豁然开朗。本节的加权最小二乘正是这句话的兑现：换一把尺子（内积），投影与最优解随之而变，公式结构却不变。
:::

::: thm 定理 2.2.7（新增） · 加权最小二乘 {#thm-2.2.7}
设 $W\in\mathbb{R}^{m\times m}$ 对称正定（权矩阵），$A\in\mathbb{R}^{m\times n}$ 列满秩。则最小化

$$\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_W^2=(A\boldsymbol{x}-\boldsymbol{b})^{\mathrm T}W(A\boldsymbol{x}-\boldsymbol{b})$$

的唯一解为

$$\hat{\boldsymbol{x}}=(A^{\mathrm T}WA)^{-1}A^{\mathrm T}W\boldsymbol{b}, \tag{2.13}$$

满足**加权正态方程** $A^{\mathrm T}W(A\boldsymbol{x}-\boldsymbol{b})=\boldsymbol{0}$。而 $A\hat{\boldsymbol{x}}$ 正是 $\boldsymbol{b}$ 在 $C(A)$ 上、按**加权内积**作正交投影的结果。

::: proof 证明
令 $f(\boldsymbol{x})=(A\boldsymbol{x}-\boldsymbol{b})^{\mathrm T}W(A\boldsymbol{x}-\boldsymbol{b})$。由 $W$ 对称，$\nabla f(\boldsymbol{x})=2A^{\mathrm T}W(A\boldsymbol{x}-\boldsymbol{b})$，令其为零得加权正态方程。$A^{\mathrm T}WA$ 非奇异：若 $A^{\mathrm T}WA\boldsymbol{x}=\boldsymbol{0}$，左乘 $\boldsymbol{x}^{\mathrm T}$：$(\boldsymbol{x}^{\mathrm T}A^{\mathrm T})W(A\boldsymbol{x})=(A\boldsymbol{x})^{\mathrm T}W(A\boldsymbol{x})=0$，由 $W$ 正定得 $A\boldsymbol{x}=\boldsymbol{0}$，再由 $A$ 列满秩得 $\boldsymbol{x}=\boldsymbol{0}$。

**与一般内积的联系：** 令 $W=L^{\mathrm T}L$（例如 Cholesky），则 $\lVert A\boldsymbol{x}-\boldsymbol{b}\rVert_W=\lVert L(A\boldsymbol{x}-\boldsymbol{b})\rVert_2=\lVert (LA)\boldsymbol{x}-L\boldsymbol{b}\rVert_2$——**加权最小二乘，等价于先把方程两边乘上 $L$，再做普通最小二乘**。∎
:::

:::

::: ex 例 2.2.5（新增） · 加权拟合的数值对照 {#ex-2.2.5}
对例 2.2.4 的数据，分成「前两点可靠、后两点不可靠」两组：取 $W=\operatorname{diag}(10,10,1,1)$，比较加权与不加权的拟合直线。

::: proof 解
直接代入（2.13）。$A$、$\boldsymbol{b}$ 同例 2.2.4。先算 $WA$ 与 $W\boldsymbol{b}$：$WA=[w_i\boldsymbol{a}_i^{\mathrm T}]$ 的第 $i$ 行为 $w_i(1,x_i)$，故

$$A^{\mathrm T}WA=\begin{pmatrix}1&1&1&1\\0&1&2&3\end{pmatrix}\begin{pmatrix}10&0\\10&10\\1&2\\1&3\end{pmatrix}=\begin{pmatrix}22&15\\15&23\end{pmatrix},$$

其中逐个分量为 $(A^{\mathrm T}WA)_{11}=\sum_iw_i=22$，$(A^{\mathrm T}WA)_{12}=\sum_iw_ix_i=10(0)+10(1)+1(2)+1(3)=15$，$(A^{\mathrm T}WA)_{22}=\sum_iw_ix_i^2=10(0)+10(1)+1(4)+1(9)=23$。右端

$$A^{\mathrm T}W\boldsymbol{b}=\begin{pmatrix}\sum_iw_iy_i\\\sum_iw_ix_iy_i\end{pmatrix}=\begin{pmatrix}10(1)+10(2)+1(2)+1(4)\\0+10(2)+1\cdot2\cdot2+1\cdot3\cdot4\end{pmatrix}=\begin{pmatrix}36\\36\end{pmatrix}.$$

解 $2\times2$ 系统（$\det=22\times23-15^2=506-225=281$）：

$$\hat{\boldsymbol{x}}_W=\frac{1}{281}\begin{pmatrix}23&-15\\-15&22\end{pmatrix}\begin{pmatrix}36\\36\end{pmatrix}=\frac{36}{281}\begin{pmatrix}8\\7\end{pmatrix}=\begin{pmatrix}1.0249\\0.8968\end{pmatrix}.$$

**对照：** 不加权（例 2.2.4）得 $y=0.9+0.9x$；加权得 $y\approx1.0249+0.8968x$。**权重把直线「拉向」可靠的前两点**（它们 $y$ 的平均值为 $1.5$，而整体平均为 $2.25$，故截距升高到 $1.0249$），代价是对后两点的拟合变差。

**验证加权正交条件：** $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}_W$。预测值 $(1.0249,\ 1.9217,\ 2.8185,\ 3.7153)^{\mathrm T}$，残差 $(-0.0249,\ 0.0783,\ -0.8185,\ 0.2847)^{\mathrm T}$。

$$A^{\mathrm T}W\boldsymbol{r}=\begin{pmatrix}\sum_iw_ir_i\\\sum_iw_ix_ir_i\end{pmatrix}=\begin{pmatrix}-0.2491+0.7829-0.8185+0.2847\\0+0.7829-1.6370+0.8541\end{pmatrix}=\begin{pmatrix}0\\0\end{pmatrix}\ \checkmark$$

（数值上用 NumPy 复核：$A^{\mathrm T}W\boldsymbol{r}$ 的两个分量均 $\sim10^{-16}$，即机器精度。）

**结论：** 加权最小二乘**不改公式结构，只改内积**——这正是「内积是几何的源头」这一直觉的兑现。[第五章](../ch01/sec11.md#roadmap)的预条件迭代法、加权内积下的 Rayleigh 商（[2.5.4](sec25.md#sec-2.5.4)）走的也都是这条路。∎
:::

:::

<a id="sec-2.2.6"></a>

## 2.2.6 小结与常见错误

::: method[core] 本节公式速查

| 概念 | 公式 |
|:--|:--|
| 四个子空间 | $C(A)\subseteq\mathbb{R}^m$、$N(A)\subseteq\mathbb{R}^n$、$C(A^{\mathrm T})\subseteq\mathbb{R}^n$、$N(A^{\mathrm T})\subseteq\mathbb{R}^m$（[@def-2.2.1]） |
| 维数 | $\dim C(A)=\dim C(A^{\mathrm T})=r$；$\dim N(A)=n-r$；$\dim N(A^{\mathrm T})=m-r$ |
| 正交补 | $C(A^{\mathrm T})=N(A)^{\perp}$；$C(A)=N(A^{\mathrm T})^{\perp}$ |
| 正交分解 | $\mathbb{R}^m=C(A)\oplus N(A^{\mathrm T})$：$\boldsymbol{b}=\boldsymbol{p}+\boldsymbol{e}$，$\boldsymbol{p}\perp\boldsymbol{e}$ |
| 投影（正交基） | $\boldsymbol{p}=\sum_i\langle\boldsymbol{x},\boldsymbol{q}_i\rangle\boldsymbol{q}_i$ |
| 投影矩阵 | $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$；$P^{\mathrm T}=P$，$P^2=P$，$\operatorname{tr}P=r$，$\lVert P\rVert_2=1$ |
| 最小二乘 | 正态方程 $A^{\mathrm T}A\boldsymbol{x}=A^{\mathrm T}\boldsymbol{b}$；$\hat{\boldsymbol{x}}=(A^{\mathrm T}A)^{-1}A^{\mathrm T}\boldsymbol{b}$（列满秩） |
| 残差性质 | $\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}\in N(A^{\mathrm T})$，即 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$（**免费自检**） |
| 加权版 | $\hat{\boldsymbol{x}}=(A^{\mathrm T}WA)^{-1}A^{\mathrm T}W\boldsymbol{b}$ |

:::

::: think[core] 常见错误清单 · 自查六条
1. **把 $A^{\mathrm T}A$ 当成恒可逆。** 只有 $A$ 列满秩时才是（[习题 A2](exercises.md)）。秩亏时 $A^{\mathrm T}A$ 奇异，正态方程有无穷多解——此时要么用伪逆（[2.6.4](sec26.md#sec-2.6.4)），要么加正则化。
2. **以为「有方程就一定有解」。** $A\boldsymbol{x}=\boldsymbol{b}$ 有解的充要条件是 $\boldsymbol{b}\in C(A)$，等价于 $\boldsymbol{b}\perp N(A^{\mathrm T})$（[习题 A1](exercises.md)）。$m\gt n$ 时一般无解——这才需要最小二乘。
3. **用行变换后的矩阵取列空间。** 例 2.2.1 里化简后的矩阵第 1 列已经变了，**列空间当然也变了**（必须回到原始列取基）。行变换保持的是**行空间**与**零空间**，不是列空间。
4. **算出 $\hat{\boldsymbol{x}}$ 后不做 $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$ 自检。** 这是最省事的错误探测器（例 2.2.4 就靠它发现了 $A^{\mathrm T}\boldsymbol{b}$ 的加法错误）；残差和为零**不代表** $A^{\mathrm T}\boldsymbol{r}=\boldsymbol{0}$，必须是**按 $x_i$ 加权**的和也为零。
5. **以为幂等矩阵都是正交投影。** 幂等 + **对称**才是正交投影；只幂等、不对称的，是斜投影（[习题 A2(b)](exercises.md)），余项不垂直。
6. **混淆「残差小」与「误差小」。** $\lVert\boldsymbol{r}\rVert$ 只说明方程被满足到什么程度，与 $\hat{\boldsymbol{x}}$ 离真解多远是两回事——病态矩阵上残差可以很小而误差巨大（[2.4.4](sec24.md#sec-2.4.4)）。QR 与正态方程的差别正在这里（[2.3.5](sec23.md#sec-2.3.5)）。
:::

::: preview 课程预告 · 本节之后
- **怎么稳定地算投影？** 正态方程把 $\mathrm{cond}$ 平方，改用 QR 分解（[2.3](sec23.md)）或 SVD（[2.6](sec26.md)）——这是下一节与 2.6 的主题；
- **行空间、零空间怎样才能算得稳定？** 也是靠正交变换（QR 与 SVD），而不是手算行简化；
- **$\hat{\boldsymbol{x}}$ 到底有多准？** 由 $\mathrm{cond}(A)$ 决定（[2.4](sec24.md)）——**正态方程解的是 $\mathrm{cond}^2$ 的问题**，这是它最致命的缺点。
:::
