# 习题集 · 第三章（3.1–3.2）

三组分层：A 组概念判断（快速自检）、B 组推理证明（考试大题）、C 组计算实操。**全部附解答**（默认折叠），建议先独立完成再展开对照。所有题目只使用 [3.1](sec31.md)、[3.2](sec32.md) 的概念与第一、二章先修知识。

本页 A、B、C 三组 38 题：A 组（12 题）、B 组（10 题）、C 组（16 题）。

| 组 | 定位 | 建议时长 | 卡壳时怎么办 |
|:--|:--|:--|:--|
| **A 组**（12 题） | 概念判断，口答即可 | 每题 1–2 分钟 | 直接看解答，回到对应小节的「即时自测」重读 |
| **B 组**（10 题） | 推理证明，需完整写出 | 每题 8–12 分钟 | 先看提示，再用 10 分钟；仍无思路才展开解答 |
| **C 组**（16 题） | 计算实操，注意验算 | 每题 5–8 分钟 | 看提示定位方法，算完**一定代回验证** |

::: note 关于「提示」层

B5、B7、B8、C4、C13、C14 这 6 题提供了折叠的「提示」——它只给**从哪里下手**，不给完整过程。先看提示、自己推完，再对照解答，学习效果远好于直接读解答。
:::

::: note 关于难度分布

A 组覆盖本节全部「辨析点」：相抵分解不唯一 / 标准形唯一、相抵与相似的分野、单侧逆的存在判别与「方阵前提」、$\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 的四个等式、满秩分解的形状与读法、两种分解各自「不唯一的程度」、$AXA=A$ 的解。

B 组以**相抵 $\iff$ 同秩**、**单侧逆的构造与判别**、**满秩分解的两条主干证明**（$\operatorname{rank}C=r$、[@thm-3.2.2]）与 **$AXA=A\iff CXB=I_r$** 为重心；B9 把 3.1 的结论接回第一章的正定矩阵。

C 组训练四件基本功：**相抵分解（含分块矩阵法求 $P^{-1}$、$Q^{-1}$）**、**用相抵标准形解方程组**、**单侧逆的构造与「全部右逆」的写法**、**满秩分解的三种算法**（取列 / RREF / 从相抵分解读）。3.3 及以后素材到位后，本页按同样的三组结构续写。
:::

## A 组 · 概念判断

::: ex A1 · 相抵分解的四个基本事实

判断对错并说明理由：

(a) 任何矩阵都有相抵分解；(b) 矩阵的相抵分解是唯一的；(c) 矩阵的相抵标准形是唯一的；(d) 两个同型矩阵相抵 $\iff$ 它们的秩相等。

::: sol 解答

(a) **对**（[@lem-3.1.1]；零矩阵也成立：$r=0$ 时 $\Gamma=O$，取 $P=Q=I$）。(b) **错**——分解式 $A=P^{-1}\Gamma Q$ 中的 $P$、$Q$ 有无穷多种取法（对任意 $*$，把 $\begin{bmatrix}I_r&*\\0&I\end{bmatrix}$ 并进 $P^{-1}$、$\begin{bmatrix}I_r&0\\*&I\end{bmatrix}$ 并进 $Q$ 仍给出分解，见 [3.1.1](sec31.md#sec-3.1.1)）。(c) **对**——$\Gamma$ 只由秩 $r$ 决定（秩在相抵下不变）。(d) **对**（[@note-3.1-rank]：同秩者都相抵于同一个 $\Gamma$，再用相抵的传递性）。

**要点**：「不唯一」说的是**分解式**，「唯一」说的是**标准形**——两句话各有对象，不能互换。
:::
:::

::: ex A2 · 相抵与相似

$B=P^{-1}AQ$ 与 $B=P^{-1}AP$ 分别刻画什么？它们之间是什么关系？何时两者重合？

::: sol 解答

- $B=P^{-1}AQ$（$A,B$ **同型**）是**相抵**：[@thm-2.3.5] 的换基公式——同一个线性映射、出发端换基 $Q$、到达端换基 $P$（$P,Q$ 相互独立），或更一般地「$A$ 经初等变换化为 $B$」；
- $B=P^{-1}AP$ 是**相似**（[@cor-2.3.4]）：同一个**线性变换**（同一空间 $V\to V$）换一组基，两侧用**同一个** $P$。

关系：**相似是相抵的特例**（取 $Q=P$），故相似必相抵；反之不然（相抵允许 $P,Q$ 独立，且不要求方阵——$2\times3$ 矩阵也谈相抵，但只有同阶方阵才谈相似）。两者重合：当 $A,B$ 同阶方阵且换基在出发端与到达端是同一件事时（$Q=P$）。
:::
:::

::: ex A3 · 单侧逆的存在性判断

判断下列矩阵是否有左逆、右逆（有则说明理由，没有也说明理由）：

(a) $A_1=\begin{bmatrix}1&0&0\\ 0&1&0\end{bmatrix}$；(b) $A_2=\begin{bmatrix}1&0\\ 0&1\\ 0&0\end{bmatrix}$；(c) $A_3=\begin{bmatrix}1&2\\ 2&4\end{bmatrix}$；(d) $A_4=[1\ \ 0]$。

::: sol 解答

由 [@thm-3.1.1]：**右逆 $\iff$ 行满秩；左逆 $\iff$ 列满秩**。

(a) $2\times3$、秩 $2=m$：**行满秩，有右逆**；列不满秩（$2<3$），无左逆。
(b) $3\times2$、秩 $2=n$：**列满秩，有左逆**；行不满秩，无右逆。
(c) 秩 $1<\min\{2,2\}$：**两者都没有**（顺带：方阵行满秩 $\iff$ 可逆，故也可直接说「不可逆」）。
(d) $1\times2$、秩 $1=m$：**行满秩，有右逆**（如 $\begin{bmatrix}1\\0\end{bmatrix}$）；无左逆。

**要点**：先看形状定方向（行满秩还是列满秩），再看秩是否达到该方向的上限。
:::
:::

::: ex A4 · 乘积为单位阵与「方阵前提」

(a) 设 $A$ 是 $n$ 阶**方阵**，若 $AB=I_n$，$B$ 是什么？唯一吗？(b) 设 $A=\begin{bmatrix}1&0\end{bmatrix}$，$AB=I_1$ 说明什么？$B$ 唯一吗？(c) 把「乘积为单位阵的两矩阵必可逆」改成一个正确的命题。

::: sol 解答

(a) $A$ 可逆且 $B=A^{-1}$，**唯一**（这正是「方阵乘积为单位阵」的结论：$AB=I\Rightarrow B=A^{-1}\Rightarrow BA=I$）。
(b) 只说明 $A$ 行满秩、$B$ 是**右逆**：设 $B=(b_1,b_2)^{\mathrm T}$，则 $AB=b_1=1$，$B=\begin{bmatrix}1\\ t\end{bmatrix}$（$t$ 任意）——**不唯一**；此时 $BA=\begin{bmatrix}1&0\\ t&0\end{bmatrix}\neq I_2$，「逆矩阵」的语言完全失效。
(c) 正确说法：**若两个方阵的乘积为单位阵，则这两个方阵都可逆**（且互为逆矩阵）。——「方阵」是关键词；长方阵情形只能谈单侧逆（[@thm-3.1.1]）。
:::
:::

::: ex A5 · 秩等式的四个判断

设 $A\in\mathbb C^{m\times n}$。判断对错：

(a) $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 恒成立；(b) $A^{\mathrm H}A$ 可逆 $\iff$ $A$ 列满秩；(c) $\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})$ 恒成立；(d) $N(A)=N(A^{\mathrm H}A)$。

::: sol 解答

四个全**对**。

(a)(c)(d) 都是 [@prop-3.1.1] 的内容：证明主线是 $N(A)=N(A^{\mathrm H}A)$（「$\subseteq$」两边左乘 $A^{\mathrm H}$；「$\supseteq$」用内积正定性），再用亏加秩；对 $A^{\mathrm H}$ 重复一遍得 $\operatorname{rank}(A^{\mathrm H})=\operatorname{rank}(AA^{\mathrm H})$，结合 $\operatorname{rank}A=\operatorname{rank}A^{\mathrm H}$ 得四项等式链。
(b) 由 (a)：$A^{\mathrm H}A$（$n$ 阶）可逆 $\iff$ $\operatorname{rank}(A^{\mathrm H}A)=n$ $\iff$ $\operatorname{rank}A=n$ $\iff$ $A$ 列满秩。

**注意**：结论依赖 $A^{\mathrm H}$（实 / 复内积空间）；对一般数域 $F$ 上没有共轭转置，此命题不适用。
:::
:::

::: ex A6 · 满秩分解的形状

设 $A\in\mathbb C^{3\times5}$，$\operatorname{rank}A=2$。若 $A=BC$ 是满秩分解，$B$、$C$ 分别是几乘几、秩各是多少？$B$ 的列与 $C$ 的内容各有什么几何含义？

::: sol 解答

$B\in\mathbb C^{3\times2}$，$\operatorname{rank}B=2$（**列**满秩，$2$ 列无关）；$C\in\mathbb C^{2\times5}$，$\operatorname{rank}C=2$（**行**满秩，$2$ 行无关）。

几何含义：$B$ 的 $2$ 列是列空间 $R(A)$（$\dim=2$）的一组**基**；$C$ 的**每一列**是 $A$ 对应列在这组基下的**坐标**（$C=[\boldsymbol{c}_1,\cdots,\boldsymbol{c}_5]$，$\boldsymbol{a}_i=B\boldsymbol{c}_i$）。

**形状记忆**：$B$ 的行数 $=m$、列数 $=r$；$C$ 的行数 $=r$、列数 $=n$——**中间夹着 $r$**。
:::
:::

::: ex A7 · 满秩分解的「读法」

判断对错：

(a) $R(A)=R(B)$；(b) $N(A)=N(C)$；(c) $A$ 的列之间的全部线性关系都记录在 $C$ 里；(d) 满秩分解中的 $B$ 必须由 $A$ 的列向量组成。

::: sol 解答

(a) **对**（[@thm-3.2.2] 证明的第一步：由 $C$ 行满秩、$C$ 满射得 $R(A)=R(BC)=R(B)$）。
(b) **对**：$C\boldsymbol{x}=\boldsymbol{0}\Rightarrow BC\boldsymbol{x}=\boldsymbol{0}\Rightarrow A\boldsymbol{x}=\boldsymbol{0}$；反之 $A\boldsymbol{x}=\boldsymbol{0}\Rightarrow B(C\boldsymbol{x})=\boldsymbol{0}\Rightarrow C\boldsymbol{x}=\boldsymbol{0}$（$B$ 的列无关）。故两零空间相等——这正是 (c) 的严格含义：$\sum k_i\boldsymbol{a}_i=\boldsymbol{0}\iff\sum k_i\boldsymbol{c}_i=\boldsymbol{0}$。
(c) **对**（即 (b) 的改述）。
(d) **错**：[@note-3.2-columns]（注 2）的反例 $A=I_2A$：$B=I_2$ 的任一列都不是 $A$ 的列向量，但仍是合法的满秩分解。
:::
:::

::: ex A8 · 「不唯一」的两种程度

(a) 相抵分解不唯一到什么程度？(b) 满秩分解不唯一到什么程度？两句话的精确表述各是什么？

::: sol 解答

(a) 相抵分解 $A=P^{-1}\Gamma Q$：$P$、$Q$ **各自独立**地有无穷多种取法（可被形如 $\begin{bmatrix}I_r&*\\0&I\end{bmatrix}$、$\begin{bmatrix}I_r&0\\*&I\end{bmatrix}$ 的可逆矩阵吸收）；没有「相差一个矩阵」式的统一刻画，因为自由度分散在两侧。
(b) 满秩分解 $A=BC$：任意两种分解**恰好相差一个可逆矩阵** $D$：

$$B_1=B_2D,\qquad C_1=D^{-1}C_2$$

（这就是 [@thm-3.2.2]。）

且 $D$ 必可逆（是两组基之间的过渡矩阵）。反过来，任取可逆 $D$，$(B_1D)(D^{-1}C_1)=A$ 仍给出满秩分解——**一个分解即生成全部**（[@note-3.2.unique]）。

**要点**：满秩分解的不唯一被「一个 $D$」精确刻画；相抵分解的不唯一更「松散」（两侧独立），但标准形唯一。
:::
:::

::: ex A9 · 矩阵方程 $AXA=A$

(a) 若 $A$ 可逆，方程 $AXA=A$ 的解是什么？唯一吗？(b) 一般情形（$A\in\mathbb C^{m\times n}_r$）课件是用什么办法把方程「降维」的？用一句话说清。

::: sol 解答

(a) $A$ 可逆时两边左乘 $A^{-1}$、右乘 $A^{-1}$ 得 $X=A^{-1}$，**唯一**（这也是 [@ex-3.2.2] 中「不能直接约掉 $A$」这句话的反面：可逆时才能约）。
(b) 用**满秩分解** $A=BC$：方程变成 $BCXBC=BC$，其中 $CXB$ 是 $r$ 阶方阵——把 $m\times n$ 的未知量 $X$ 的问题「夹」成了 $r$ 阶方阵上的条件 $CXB=I_r$；再由 [@note-3.2-axa-iff]，二者**等价**（课件写「充分条件」，其实是充要条件）。
:::
:::

::: ex A10 · 秩不等式的使用

(a) 判断：$\operatorname{rank}(BC)\le\min\{\operatorname{rank}B,\operatorname{rank}C\}$。(b) 满秩分解中「$\operatorname{rank}C=r$」的两步夹逼各是什么？(c) 为什么 $\operatorname{rank}(BC)\le\operatorname{rank}C$？

::: sol 解答

(a) **对**：$R(BC)\subseteq R(B)$ 给出 $\operatorname{rank}(BC)\le\operatorname{rank}B$；$N(C)\subseteq N(BC)$ 加亏加秩给出 $\operatorname{rank}(BC)\le\operatorname{rank}C$。
(b) 上界：$C$ 只有 $r$ 行，故 $\operatorname{rank}C\le r$；下界：$N(C)\subseteq N(A)$（$A=BC$）加亏加秩得 $\operatorname{rank}C=n-\dim N(C)\ge n-\dim N(A)=\operatorname{rank}A=r$。故 $\operatorname{rank}C=r$。
(c) 若 $C\boldsymbol{x}=\boldsymbol{0}$ 则 $BC\boldsymbol{x}=\boldsymbol{0}$，即 $N(C)\subseteq N(BC)$；两个矩阵列数相同（都是 $n$），亏加秩给出 $\operatorname{rank}(BC)=n-\dim N(BC)\le n-\dim N(C)=\operatorname{rank}C$。
:::
:::

::: ex A11 · 相抵标准形的「几何」翻译

用基与线性映射的语言复述 [@lem-3.1.1]：$\Gamma$ 的存在性等价于「总可以选到两组基，使映射的矩阵长成 $\Gamma$ 的样子」。请说清这两组基是怎么选的。

::: sol 解答

设 $T$ 是「以 $A$ 为矩阵」的映射（取定标准基后由 [@thm-2.3.1] 唯一确定）。做法（[@lem-3.1.1] 的本编证明）：

1. **出发端**：取零空间 $N(T)$ 的一组基（$n-r$ 个），用基扩充定理补成 $F^n$ 的一组基 $\xi_1,\cdots,\xi_{n-r},\xi_{n-r+1},\cdots,\xi_n$；
2. **到达端**：证明后 $r$ 个基向量的像 $\xi_{n-r+1},\cdots,\xi_n$ 的像是 $R(T)$ 的基（无关性由 $\xi_1,\cdots,\xi_{n-r}$ 是零空间的基得出），把它们排在前面，扩充成 $F^m$ 的基 $\eta_1,\cdots,\eta_m$；
3. **读出矩阵**：在这两组基下 $T(\xi_1)=\cdots=T(\xi_{n-r})=\boldsymbol{0}$、$T(\xi_{n-r+i})=\eta_i$，故矩阵恰为 $\Gamma$；换基公式（[@thm-2.3.5]）给出 $A=P^{-1}\Gamma Q$。

**一句话**：**零空间的基排前面、值域的基接后面**——$\Gamma$ 就是「把 $A$ 的活与死的部分分开摆好」的样子。
:::
:::

::: ex A12 · 纠错四句

改正下列说法：

(a)「相抵分解是唯一的」；(b)「行满秩矩阵有左逆」；(c)「$A^{\mathrm H}A$ 与 $A$ 的秩相等，因为它们是同一个二次型的矩阵」；(d)「满秩分解的 $B$、$C$ 可以随意取，只要 $BC=A$」。

::: sol 解答

(a) 应说：「相抵**分解式**不唯一，相抵**标准形**唯一」——见 A1。
(b) 应说：「行满秩矩阵有**右**逆；**列**满秩矩阵有**左**逆」（[@thm-3.1.1]）。方向由 $AB=I$（右）与 $BA=I$（左）决定：行满秩 $A$ 是「宽」的，可以右乘一个「高」的 $B$ 凑出 $I$。
(c) 二者秩相等**对**，但理由不对：理由不是「同一个二次型」（$A^{\mathrm H}A$ 与 $A$ 甚至不同型），而是 [@prop-3.1.1] 的同解方程组证明（$N(A)=N(A^{\mathrm H}A)$，再用亏加秩）。
(d) 不够：还要 $B$ **列满秩**、$C$ **行满秩**（[@thm-3.2.1]）；否则如 $\begin{bmatrix}1&2\\3&4\end{bmatrix}=\begin{bmatrix}1\\2\end{bmatrix}[1\ \ 2]$ 之类根本不成立，或退化成「秩不足」的分解（$B$ 的列不满秩 $\Rightarrow$ $B$ 的列不是 $R(A)$ 的基）。
:::
:::

## B 组 · 推理证明

::: ex B1 · 相抵 $\iff$ 同秩

证明：两个 $m\times n$ 矩阵 $A,B$ 相抵（存在可逆 $P,Q$ 使 $B=P^{-1}AQ$）**当且仅当** $\operatorname{rank}A=\operatorname{rank}B$。

::: sol 解答

**必要性（$\Longrightarrow$）**：初等变换不改变秩（本编提示：逐个验证三类行 / 列初等变换，或直接用「相抵 $\Rightarrow$ 秩相等」的通用论证——$P,Q$ 可逆给出 $\operatorname{rank}B=\operatorname{rank}(P^{-1}AQ)=\operatorname{rank}A$，因为乘可逆矩阵不改变秩：$\operatorname{rank}(P^{-1}AQ)=\operatorname{rank}(AQ)=\operatorname{rank}A$，每一步都用了「乘可逆矩阵不改变秩」。这里 $\operatorname{rank}(XA)=\operatorname{rank}A$ 对可逆 $X$ 成立，理由：$R(XA)=X(R(A))$ 且 $X$ 是同构（[@prop-2.3.1]（5）），维数不变）。

**充分性（$\Longleftarrow$）**：设 $\operatorname{rank}A=\operatorname{rank}B=r$。由 [@lem-3.1.1]，$A=P_1^{-1}\Gamma P_2$、$B=Q_1^{-1}\Gamma Q_2$（同一个 $\Gamma$，因为秩都是 $r$）。于是

$$B=Q_1^{-1}\Gamma Q_2=Q_1^{-1}(P_1AP_2^{-1})Q_2=(Q_1^{-1}P_1)\,A\,(P_2^{-1}Q_2),$$

其中 $Q_1^{-1}P_1$、$P_2^{-1}Q_2$ 都可逆，故 $A\cong B$。∎
:::
:::

::: ex B2 · 右逆的必要性（并说明左逆如何对称）

证明：若 $AB=I_m$，则 $A$ 行满秩。

::: sol 解答

由 [@thm-2.3.6]，$\operatorname{rank}(AB)=\dim R(AB)$；而 $R(AB)\subseteq R(A)$，故

$$\operatorname{rank}(AB)\le\operatorname{rank}A .$$

取 $B=I_m$ 的情形即 $\operatorname{rank}(AB)=m$（$AB$ 本身就是 $I_m$，秩为 $m$），于是 $m\le\operatorname{rank}A$；另一方面 $A$ 是 $m$ 行矩阵，$\operatorname{rank}A\le m$。两边夹得 $\operatorname{rank}A=m$，即 $A$ 行满秩。∎

**左逆对称处理**：设 $BA=I_n$，两边共轭转置得 $A^{\mathrm H}B^{\mathrm H}=I_n$，即 $A^{\mathrm H}$ 有右逆；刚刚证的结论给出 $\operatorname{rank}(A^{\mathrm H})=n$；又 $\operatorname{rank}A=\operatorname{rank}A^{\mathrm H}$，故 $A$ 列满秩。（也可直接对 $BA$ 用 $\operatorname{rank}(BA)\le\operatorname{rank}A$。）
:::
:::

::: ex B3 · 列满秩时的左逆公式

证明：若 $A\in\mathbb C^{m\times n}$ 列满秩，则 $B=(A^{\mathrm H}A)^{-1}A^{\mathrm H}$ 是 $A$ 的左逆。

::: sol 解答

**可逆性**：由 [@prop-3.1.1]，$\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}A=n$，故 $n$ 阶方阵 $A^{\mathrm H}A$ 满秩、可逆。

**验算**：

$$BA=(A^{\mathrm H}A)^{-1}A^{\mathrm H}A=I_n\ \checkmark$$

**要点**：这与 [@thm-3.1.1]「法 2」的右逆公式 $A^{\mathrm H}(AA^{\mathrm H})^{-1}$ 完全对称——把 $A$ 换成 $A^{\mathrm H}$ 即得。∎
:::
:::

::: ex B4 · 满秩分解中 $\operatorname{rank}C=r$

设 $A=BC$ 是满秩分解（$A\in\mathbb C^{m\times n}_r$）。证明 $\operatorname{rank}C=r$（写出两步夹逼的完整理由）。

::: sol 解答

**上界**：$C$ 是 $r\times n$ 矩阵，其秩不超过行数：

$$\operatorname{rank}C\le r .$$

**下界**：设 $C\boldsymbol{x}=\boldsymbol{0}$，两端左乘 $B$ 得 $A\boldsymbol{x}=BC\boldsymbol{x}=\boldsymbol{0}$，故 $N(C)\subseteq N(A)$。由亏加秩定理（[@thm-2.2.5]，两矩阵列数同为 $n$）：

$$\operatorname{rank}C=n-\dim N(C)\ \ge\ n-\dim N(A)=\operatorname{rank}A=r .$$

**结论**：$r\le\operatorname{rank}C\le r$，故 $\operatorname{rank}C=r$。∎

（$B$ 的满秩是构造的一部分：$B$ 的列取成 $R(A)$ 的基，故 $\operatorname{rank}B=r$ 显然。）
:::
:::

::: ex B5 · 满秩分解的唯一性（定理 3.2.2）

设 $A=B_1C_1=B_2C_2$ 是 $A\in\mathbb C^{m\times n}_r$ 的两种满秩分解。证明：存在可逆矩阵 $D\in\mathbb C^{r\times r}$ 使 $B_1=B_2D$、$C_1=D^{-1}C_2$。

::: hint 提示

先证两种分解的**列空间相同**（都要等于 $R(A)$，其中「$R(B_1)\subseteq R(A)$」这一步需要 $C_1$ 满射）；然后把 $B_1$、$B_2$ 都看作 $R(A)$ 的基，用过渡矩阵取 $D$；最后用 $B_2$ 的列无关把 $C$ 的关系「约」出来。
:::

::: sol 解答（本编补，与 [3.2.3](sec32.md#sec-3.2.3) 正文一致）

**第一步（列空间相等）**：$C_1$ 行满秩，故有右逆（[@thm-3.1.1]），即 $C_1$ 满射。任取 $\boldsymbol{y}=B_1\boldsymbol{u}\in R(B_1)$，取 $\boldsymbol{x}$ 使 $C_1\boldsymbol{x}=\boldsymbol{u}$，则 $\boldsymbol{y}=B_1C_1\boldsymbol{x}=A\boldsymbol{x}\in R(A)$——故 $R(B_1)\subseteq R(A)$；反向 $R(A)\subseteq R(B_1)$ 显然。于是 $R(B_1)=R(A)$；同理 $R(B_2)=R(A)$。

**第二步（过渡矩阵）**：$B_1$、$B_2$ 的列都是 $r$ 维子空间 $R(A)$ 的基。由过渡矩阵的存在唯一性（[@def-1.3.5]、[@prop-1.3.1]），存在可逆 $D$ 使 $B_1=B_2D$。

**第三步（$C$ 的关系）**：$B_2C_2=A=B_1C_1=B_2DC_1$，移项得 $B_2(C_2-DC_1)=O$。$B_2$ 列满秩即列无关，$B_2X=O$ 只有零解（按列用 [@thm-1.3.2]），故 $C_2=DC_1$，即 $C_1=D^{-1}C_2$。∎
:::
:::

::: ex B6 · 给定 $B$ 后 $C$ 唯一

设 $A=BC$ 是满秩分解。证明：$C=(B^{\mathrm H}B)^{-1}B^{\mathrm H}A$（即 $C$ 由 $B$ 唯一确定）。

::: sol 解答

$B$ 列满秩 $\Rightarrow$ $B^{\mathrm H}B$ 可逆（[@prop-3.1.1]）。两边左乘 $(B^{\mathrm H}B)^{-1}B^{\mathrm H}$：

$$(B^{\mathrm H}B)^{-1}B^{\mathrm H}A=(B^{\mathrm H}B)^{-1}B^{\mathrm H}BC=(B^{\mathrm H}B)^{-1}(B^{\mathrm H}B)C=C\ \checkmark$$

∎

**对偶结论**：给定 $C$ 时 $B=AC^{\mathrm H}(CC^{\mathrm H})^{-1}$（同样的一句话验算）——见 [3.2.2](sec32.md#sec-3.2.2) 的本编补注。
:::
:::

::: ex B7 · $R(A)=R(B)$ {#ex-B7}

证明：满秩分解 $A=BC$ 中 $R(A)=R(B)$。

::: hint 提示

两个包含方向难度不同：一个方向连乘法都不用（$B$ 的列组合）；另一个方向要「解 $C\boldsymbol{x}=\boldsymbol{u}$」，这正是 $C$ 行满秩的用处。
:::

::: sol 解答

**$R(A)\subseteq R(B)$**：任取 $\boldsymbol{y}=A\boldsymbol{x}=B(C\boldsymbol{x})$，它是 $B$ 的列的线性组合，故 $\boldsymbol{y}\in R(B)$。（不需要任何前提。）

**$R(B)\subseteq R(A)$**：任取 $\boldsymbol{y}=B\boldsymbol{u}\in R(B)$。因 $C$ 行满秩，由 [@thm-3.1.1] 它有右逆，即 $C$ 作为映射 $\mathbb C^n\to\mathbb C^r$ 是满射，故存在 $\boldsymbol{x}$ 使 $C\boldsymbol{x}=\boldsymbol{u}$。于是

$$\boldsymbol{y}=B\boldsymbol{u}=BC\boldsymbol{x}=A\boldsymbol{x}\in R(A)\ \checkmark$$

故 $R(A)=R(B)$。∎

**推论**：$\dim R(A)=\dim R(B)=r$——满秩分解把列空间「显式地」交给了 $B$。∎
:::
:::

::: ex B8 · $AXA=A$ 与 $CXB=I_r$ 等价

设 $A=BC\in\mathbb C^{m\times n}_r$ 是满秩分解。证明：对方阵 $X\in\mathbb C^{n\times m}$，

$$AXA=A\iff CXB=I_r .$$

::: hint 提示

「$\Longleftarrow$」直接把 $CXB$ 换成 $I_r$；「$\Longrightarrow$」分别左乘 $B$ 的左逆、右乘 $C$ 的右逆——两条单侧逆的存在性由 [@thm-3.1.1] 与 [@prop-3.1.1] 保证。
:::

::: sol 解答

**（$\Longleftarrow$）** 若 $CXB=I_r$，则

$$AXA=BCXBC=B\,(CXB)\,C=BC=A\ \checkmark$$

**（$\Longrightarrow$）** 设 $BCXBC=BC$。先左乘 $B$ 的左逆 $B^{\mathrm L}=(B^{\mathrm H}B)^{-1}B^{\mathrm H}$：

$$B^{\mathrm L}BCXBC=B^{\mathrm L}BC\ \Longrightarrow\ CXBC=C ;$$

再右乘 $C$ 的右逆 $C^{\mathrm R}=C^{\mathrm H}(CC^{\mathrm H})^{-1}$：

$$CXBCC^{\mathrm R}=CC^{\mathrm R}\ \Longrightarrow\ CXB=I_r\ \checkmark$$

两个单侧逆都存在（$B^{\mathrm H}B$、$CC^{\mathrm H}$ 可逆，[@prop-3.1.1]）。∎
:::
:::

::: ex B9 · 行满秩 $\Longrightarrow$ $AA^{\mathrm H}$ 正定

证明：若 $A\in\mathbb C^{m\times n}$ 行满秩，则 $AA^{\mathrm H}$ 是正定 Hermite 矩阵（用第一章的正定定义 [@def-1.4.3] 与 [@prop-3.1.1] 各自完成一部分）。

::: sol 解答

**Hermite 性**：直接算 $(AA^{\mathrm H})^{\mathrm H}=A\,(A^{\mathrm H})^{\mathrm H}=AA^{\mathrm H}$ ✓（共轭转置取两次回到自身）。

**正定性**：对任意非零 $\boldsymbol{x}\in\mathbb C^m$，

$$\boldsymbol{x}^{\mathrm H}(AA^{\mathrm H})\boldsymbol{x}=(A^{\mathrm H}\boldsymbol{x})^{\mathrm H}(A^{\mathrm H}\boldsymbol{x})=\|A^{\mathrm H}\boldsymbol{x}\|^2\ge0 .$$

等号成立 $\iff$ $A^{\mathrm H}\boldsymbol{x}=\boldsymbol{0}$。而 $A$ 行满秩 $\iff$ $\operatorname{rank}(A^{\mathrm H})=m$ $\iff$ $A^{\mathrm H}$ 列满秩 $\iff$ $A^{\mathrm H}$ 单射（[@cor-2.2.2] 或 [@thm-2.2.2]），故 $A^{\mathrm H}\boldsymbol{x}=\boldsymbol{0}\iff\boldsymbol{x}=\boldsymbol{0}$。于是对非零 $\boldsymbol{x}$ 恒有 $\boldsymbol{x}^{\mathrm H}AA^{\mathrm H}\boldsymbol{x}\gt0$，$AA^{\mathrm H}$ 正定。∎

**对照**：[3.1.4](sec31.md#sec-3.1.4) 用 [@prop-3.1.1] 说明「$A$ 行满秩 $\Rightarrow$ $AA^{\mathrm H}$ 可逆」；本题进一步指出可逆的**类型**——它是正定 Hermite 矩阵（可逆只是正定的一个推论）。
:::
:::

::: ex B10 · 相抵不唯一的「吸收」公式

验证 [3.1.1](sec31.md#sec-3.1.1) 的不唯一性构造：对 $\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$ 与任意适当阶数矩阵 $*$，证明

$$\begin{bmatrix}I_r&*\\0&I\end{bmatrix}\Gamma=\Gamma,\qquad \Gamma\begin{bmatrix}I_r&0\\*&I\end{bmatrix}=\Gamma,$$

并说明这两个三角块都可逆。

::: sol 解答

**第一式**（$m\times m$ 的块左乘）：记 $\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$（分块尺寸 $r+(m-r)$、$r+(n-r)$）。按分块乘法：

$$\begin{bmatrix}I_r&*\\0&I\end{bmatrix}\begin{bmatrix}I_r&0\\0&0\end{bmatrix}=\begin{bmatrix}I_r\cdot I_r+*\cdot 0&\ I_r\cdot 0+*\cdot 0\\ 0\cdot I_r+I\cdot 0&\ 0\cdot0+I\cdot0\end{bmatrix}=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}=\Gamma\ \checkmark$$

（关键：$\Gamma$ 的后 $n-r$ 列全零，故 $*$ 乘上去没有贡献。）

**第二式**（$n\times n$ 的块右乘）：$\Gamma$ 的后 $m-r$ **行**全零，故

$$\begin{bmatrix}I_r&0\\0&0\end{bmatrix}\begin{bmatrix}I_r&0\\*&I\end{bmatrix}=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}=\Gamma\ \checkmark$$

**可逆性**：两块都是「单位块 + 严格三角块」，行列式为 $1\cdot\det I=1\neq0$，可逆。

**用法**：由两式得 $P^{-1}\Gamma Q=\big(P^{-1}\begin{bmatrix}I_r&*\\0&I\end{bmatrix}\big)\Gamma\big(\begin{bmatrix}I_r&0\\*&I\end{bmatrix}Q\big)$，右边仍是合法的相抵分解式——取不同的 $*$ 即得不同的 $P$、$Q$。∎
:::
:::

## C 组 · 计算实操

::: ex C1 · 相抵分解全流程（$2\times3$、秩 $1$）{#ex-C1}

求 $A=\begin{bmatrix}1&2&3\\ 2&4&6\end{bmatrix}$ 的相抵分解式：写出 $\Gamma$、$E$、$F$（即 $P$ 与 $Q^{-1}$），再写出 $P^{-1}$、$Q$ 并回代验证。

::: sol 解答

**第一步（定秩）**：第二行 $=2\times$ 第一行，故 $r=1$，$\Gamma=\begin{bmatrix}1&0&0\\ 0&0&0\end{bmatrix}$。

**第二步（建分块矩阵并消元）**：挂上 $\begin{bmatrix}A&I_2\\ I_3&*\end{bmatrix}$，只动前 $2$ 行、前 $3$ 列。

- 行变换（记总积 $E$）：$r_2\leftarrow r_2-2r_1$，即 $E=\begin{bmatrix}1&0\\ -2&1\end{bmatrix}$；
- 列变换（记总积 $F$）：$c_2\leftarrow c_2-2c_1$、$c_3\leftarrow c_3-3c_1$，即 $F=\begin{bmatrix}1&-2&-3\\ 0&1&0\\ 0&0&1\end{bmatrix}$。

**第三步（回代验算，用 $EAF=\Gamma$）**：

$$EAF=\begin{bmatrix}1&0\\-2&1\end{bmatrix}\begin{bmatrix}1&2&3\\2&4&6\end{bmatrix}\begin{bmatrix}1&-2&-3\\0&1&0\\0&0&1\end{bmatrix}
=\begin{bmatrix}1&2&3\\0&0&0\end{bmatrix}\begin{bmatrix}1&-2&-3\\0&1&0\\0&0&1\end{bmatrix}=\begin{bmatrix}1&0&0\\0&0&0\end{bmatrix}=\Gamma\ \checkmark$$

**第四步（写成 $A=P^{-1}\Gamma Q$）**：由 $EAF=\Gamma$ 得 $A=E^{-1}\Gamma F^{-1}$，与 $A=P^{-1}\Gamma Q$ 对照（[@method-3.1-augmented]）：

$$\boxed{\,P^{-1}=E^{-1}=\begin{bmatrix}1&0\\ 2&1\end{bmatrix},\qquad Q=F^{-1}=\begin{bmatrix}1&2&3\\ 0&1&0\\ 0&0&1\end{bmatrix},\qquad P=E,\qquad Q^{-1}=F\,}$$

**最终验证**：

$$P^{-1}\Gamma Q=\begin{bmatrix}1&0\\2&1\end{bmatrix}\begin{bmatrix}1&0&0\\0&0&0\end{bmatrix}\begin{bmatrix}1&2&3\\0&1&0\\0&0&1\end{bmatrix}
=\begin{bmatrix}1&0&0\\2&0&0\end{bmatrix}\begin{bmatrix}1&2&3\\0&1&0\\0&0&1\end{bmatrix}=\begin{bmatrix}1&2&3\\2&4&6\end{bmatrix}=A\ \checkmark$$

**要点**：读出的两块是「变换的总积」$E$、$F$，满足 $EAF=\Gamma$；写分解式时**要取逆**（$P^{-1}=E^{-1}$、$Q=F^{-1}$）。用 $EAF=\Gamma$ 验算比用 $P^{-1}\Gamma Q$ 少两步矩阵乘法，也不容易把栏目记错。∎
:::
:::

::: ex C2 · 用相抵标准形解方程组

用 [@ex-C1] 的分解解 $A\boldsymbol{x}=\boldsymbol{b}$（$A=\begin{bmatrix}1&2&3\\2&4&6\end{bmatrix}$，$\boldsymbol{b}=(1,2)^{\mathrm T}$），写出通解；再判断 $\boldsymbol{b}'=(1,3)^{\mathrm T}$ 是否有解。

::: sol 解答

取 $E=\begin{bmatrix}1&0\\-2&1\end{bmatrix}$（$EAF=\Gamma$）。方程 $\Gamma\boldsymbol{y}=E\boldsymbol{b}$，$\boldsymbol{x}=F\boldsymbol{y}$（因为 $A=E^{-1}\Gamma F^{-1}$，故 $\Gamma(F^{-1}\boldsymbol{x})=E\boldsymbol{b}$，记 $\boldsymbol{y}=F^{-1}\boldsymbol{x}$）。

**(a)** $E\boldsymbol{b}=\begin{bmatrix}1&0\\-2&1\end{bmatrix}\begin{bmatrix}1\\2\end{bmatrix}=\begin{bmatrix}1\\0\end{bmatrix}$，后 $m-r=1$ 个分量为 $0$ ✓ 有解。由 $\Gamma\boldsymbol{y}=(y_1,0)^{\mathrm T}$ 得 $y_1=1$、$y_2,y_3$ 任意（记 $y_2=s,y_3=t$）：

$$\boldsymbol{x}=F\boldsymbol{y}=\begin{bmatrix}1&-2&-3\\0&1&0\\0&0&1\end{bmatrix}\begin{bmatrix}1\\s\\t\end{bmatrix}=\begin{bmatrix}1-2s-3t\\ s\\ t\end{bmatrix}.$$

**验算**：$A\boldsymbol{x}=(1-2s-3t+2s+3t,\ 2-4s-6t+4s+6t)^{\mathrm T}=(1,2)^{\mathrm T}=\boldsymbol{b}$ ✓；自由参数 $2=n-r$ ✓。

**(b)** $E\boldsymbol{b}'=\begin{bmatrix}1\\-2+3\end{bmatrix}=\begin{bmatrix}1\\1\end{bmatrix}$，第二个分量 $\neq0$，**无解** ✓（与经典判据一致：$\operatorname{rank}(A|\boldsymbol{b}')=2>\operatorname{rank}A=1$，因为 $\boldsymbol{b}'$ 不满足「第二分量 $=2\times$ 第一分量」）。
:::
:::

::: ex C3 · 相抵分解重做（例 3.1.A）{#ex-C3}

求 $A=\begin{bmatrix}1&2&3\\ 2&5&7\\ 3&7&10\end{bmatrix}$ 的相抵分解式（$\Gamma$、$E$、$F$，并写出 $A=P^{-1}\Gamma Q$）。

::: sol 解答

过程见 [@ex-3.1.A]（分行、列两步；$r=2$）：

$$\Gamma=\begin{bmatrix}1&0&0\\ 0&1&0\\ 0&0&0\end{bmatrix},\qquad
E=\begin{bmatrix}1&0&0\\ -2&1&0\\ -1&-1&1\end{bmatrix},\qquad
F=\begin{bmatrix}1&-2&-1\\ 0&1&-1\\ 0&0&1\end{bmatrix},\qquad EAF=\Gamma\ \checkmark$$

$$A=E^{-1}\Gamma F^{-1},\qquad
E^{-1}=\begin{bmatrix}1&0&0\\ 2&1&0\\ 3&1&1\end{bmatrix},\qquad
F^{-1}=\begin{bmatrix}1&2&3\\ 0&1&1\\ 0&0&1\end{bmatrix}.$$

**验算**：$E^{-1}\Gamma F^{-1}=\begin{bmatrix}1&0&0\\2&1&0\\3&1&0\end{bmatrix}\begin{bmatrix}1&2&3\\0&1&1\\0&0&1\end{bmatrix}=\begin{bmatrix}1&2&3\\2&5&7\\3&7&10\end{bmatrix}=A$ ✓。∎
:::
:::

::: ex C4 · 全部右逆

求 $A=\begin{bmatrix}1&2&0\\ 0&1&1\end{bmatrix}$ 的**全部**右逆。

::: hint 提示

先用公式 $B_0=A^{\mathrm H}(AA^{\mathrm H})^{-1}$ 造一个，再考虑「差」：$A(B-B_0)=O$，即 $B-B_0$ 的每一列都属于 $N(A)$——把 $N(A)$ 的基求出来后加上参数即可。
:::

::: sol 解答

**基本解**：$AA^{\mathrm H}=\begin{bmatrix}5&2\\2&2\end{bmatrix}$，$(AA^{\mathrm H})^{-1}=\dfrac16\begin{bmatrix}2&-2\\-2&5\end{bmatrix}$，

$$B_0=A^{\mathrm H}(AA^{\mathrm H})^{-1}=\dfrac16\begin{bmatrix}2&-2\\ 2&1\\ -2&5\end{bmatrix},\qquad AB_0=I_2\ \checkmark$$

**通式**：设 $B=B_0+Z$，则 $AB=B_0$ 与 $A=I$ 的关系为 $AB=A(B_0+Z)=I_2+AZ$；要 $AB=I_2$ 只需 $AZ=O$，即 $Z$ 的**每一列**属于 $N(A)$。解 $A\boldsymbol{x}=\boldsymbol{0}$：$x_1+2x_2=0$、$x_2+x_3=0$，取 $x_3=1$ 得 $\boldsymbol{n}=(2,-1,1)^{\mathrm T}$，$N(A)=\operatorname{span}\{\boldsymbol{n}\}$（$\dim=n-r=1$ ✓）。

于是全部右逆为

$$B=\dfrac16\begin{bmatrix}2&-2\\ 2&1\\ -2&5\end{bmatrix}+\begin{bmatrix}2s&2t\\ -s&-t\\ s&t\end{bmatrix},\qquad s,t\in\mathbb C$$

（每个参数配一列）。**验算**：$A\begin{bmatrix}2s&2t\\-s&-t\\ s&t\end{bmatrix}=\begin{bmatrix}2s-2s&2t-2t\\ -s+s&-t+t\end{bmatrix}=O$ ✓，故 $AB=I_2$ ✓。**两个自由参数** $=$ $n-r$（每列一个）$\times$ $m$（$m=2$ 列）$\div$ ⋯——不背计数公式，只记住「**多余的自由度来自 $N(A)$**」。
:::
:::

::: ex C5 · 判断并构造单侧逆

判断下列矩阵是否有右逆 / 左逆；对存在的，用公式构造一个：

(a) $A_1=\begin{bmatrix}1&0&0\\ 0&1&0\end{bmatrix}$；(b) $A_2=\begin{bmatrix}1&0\\ 0&1\\ 0&0\end{bmatrix}$；(c) $A_3=\begin{bmatrix}1&2\\ 2&4\end{bmatrix}$。

::: sol 解答

**(a)** 行满秩（$r=2=m$）：有右逆。$A_1A_1^{\mathrm H}=I_2$（$A_1$ 的行已标准正交），故 $B=A_1^{\mathrm H}(A_1A_1^{\mathrm H})^{-1}=A_1^{\mathrm H}=\begin{bmatrix}1&0\\0&1\\0&0\end{bmatrix}$；验算 $A_1B=I_2$ ✓。

**(b)** 列满秩（$r=2=n$）：有左逆。$A_2^{\mathrm H}A_2=I_2$，故 $B=(A_2^{\mathrm H}A_2)^{-1}A_2^{\mathrm H}=A_2^{\mathrm H}=[1\ 0\ 0;\ 0\ 1\ 0]$，即 $\begin{bmatrix}1&0&0\\0&1&0\end{bmatrix}$；验算 $BA_2=I_2$ ✓。

**(c)** 秩 $1<2$：两者都没有（若硬算会发现 $A_3^{\mathrm H}A_3=\begin{bmatrix}5&10\\10&20\end{bmatrix}$ 不可逆，公式失效——这与 [@thm-3.1.1] 的判断一致）。

**要点**：(a)(b) 互为「转置镜像」，两个公式也互为镜像。
:::
:::

::: ex C6 · 右逆公式实操

设 $A=\begin{bmatrix}1&1&0\\ 0&1&1\end{bmatrix}$：判断 $A$ 是否有右逆；用公式构造一个右逆并验算；说明为什么不用相抵分解也能得到答案。

::: sol 解答

**判断**：$2\times3$、两行不成比例 $\Rightarrow$ $\operatorname{rank}A=2=m$，**行满秩，有右逆**。

**构造**：

$$AA^{\mathrm H}=\begin{bmatrix}1&1&0\\0&1&1\end{bmatrix}\begin{bmatrix}1&0\\1&1\\0&1\end{bmatrix}=\begin{bmatrix}2&1\\1&2\end{bmatrix},\qquad
(AA^{\mathrm H})^{-1}=\frac13\begin{bmatrix}2&-1\\-1&2\end{bmatrix},$$

$$B=A^{\mathrm H}(AA^{\mathrm H})^{-1}=\frac13\begin{bmatrix}1&0\\1&1\\0&1\end{bmatrix}\begin{bmatrix}2&-1\\-1&2\end{bmatrix}=\frac13\begin{bmatrix}2&-1\\1&1\\-1&2\end{bmatrix}.$$

**验算**：$AB=\dfrac13\begin{bmatrix}1&1&0\\0&1&1\end{bmatrix}\begin{bmatrix}2&-1\\1&1\\-1&2\end{bmatrix}=\dfrac13\begin{bmatrix}3&0\\0&3\end{bmatrix}=I_2$ ✓。

**为什么不用相抵分解**：法 2 的公式依赖 [@prop-3.1.1]（$\operatorname{rank}(AA^{\mathrm H})=\operatorname{rank}A=m$，故 $AA^{\mathrm H}$ 可逆），而这一命题的证明只用**方程组同解 + 内积正定性**，与相抵分解无关——所以公式法比相抵法短得多。
:::
:::

::: ex C7 · 满秩分解（取 $A$ 的列）

求 $A=\begin{bmatrix}1&2&3\\ 0&1&1\end{bmatrix}$ 的满秩分解，并写出 $R(A)$ 的一组基。

::: sol 解答

**定基**：$\boldsymbol{a}_1=(1,0)^{\mathrm T}$、$\boldsymbol{a}_2=(2,1)^{\mathrm T}$、$\boldsymbol{a}_3=(3,1)^{\mathrm T}$。$\boldsymbol{a}_1,\boldsymbol{a}_2$ 无关；$\boldsymbol{a}_3=\boldsymbol{a}_1+\boldsymbol{a}_2$ ✓。$r=\operatorname{rank}A=2$，故 $\boldsymbol{a}_1,\boldsymbol{a}_2$ 是 $R(A)$ 的基。

**满秩分解**：

$$B=[\boldsymbol{a}_1,\boldsymbol{a}_2]=\begin{bmatrix}1&2\\ 0&1\end{bmatrix},\qquad
C=\begin{bmatrix}1&0&1\\ 0&1&1\end{bmatrix}\quad(\text{坐标：}\boldsymbol{a}_3=\boldsymbol{a}_1+\boldsymbol{a}_2),$$

$$BC=\begin{bmatrix}1&2\\ 0&1\end{bmatrix}\begin{bmatrix}1&0&1\\ 0&1&1\end{bmatrix}=\begin{bmatrix}1&2&3\\ 0&1&1\end{bmatrix}=A\ \checkmark$$

$R(A)=\operatorname{span}\{(1,0)^{\mathrm T},(2,1)^{\mathrm T}\}$。∎
:::
:::

::: ex C8 · 满秩分解（RREF 法）

用 [@method-3.2-rref] 求 $A=\begin{bmatrix}1&1&2&1\\ 2&3&5&2\\ 1&2&3&1\end{bmatrix}$ 的满秩分解，并读出 $A$ 的列之间的线性关系。

::: sol 解答

**化 RREF**：$r_2-2r_1=(0,1,1,0)$；$r_3-r_2=(0,0,0,0)$；回代 $r_1-r_2=(1,0,1,1)$。得

$$R=\begin{bmatrix}1&0&1&1\\ 0&1&1&0\\ 0&0&0&0\end{bmatrix},\qquad r=2,\ \text{主元列}=1,2 .$$

**取 $B$、$C$**：$B=A$ 的第 1、2 列 $=\begin{bmatrix}1&1\\2&3\\1&2\end{bmatrix}$，$C=R$ 的前两行 $=\begin{bmatrix}1&0&1&1\\ 0&1&1&0\end{bmatrix}$。

**验算**：$\begin{bmatrix}1&1\\2&3\\1&2\end{bmatrix}\begin{bmatrix}1&0&1&1\\0&1&1&0\end{bmatrix}=\begin{bmatrix}1&1&2&1\\2&3&5&2\\1&2&3&1\end{bmatrix}=A$ ✓。

**列关系**：$C$ 的第三列 $(1,1)^{\mathrm T}$ ⟹ $\boldsymbol{a}_3=\boldsymbol{a}_1+\boldsymbol{a}_2$；第四列 $(1,0)^{\mathrm T}$ ⟹ $\boldsymbol{a}_4=\boldsymbol{a}_1$。代入验算：$\boldsymbol{a}_3=(2,5,3)$ 而 $\boldsymbol{a}_1+\boldsymbol{a}_2=(1,1)+(1,2)=(2,3,1)$——**不对**！查 $A$：$\boldsymbol{a}_3=(2,5,3)^{\mathrm T}$，$\boldsymbol{a}_1+\boldsymbol{a}_2=(1,1,1)+(2,3,2)=(3,4,3)$，都不等于。重新核对 $R$ 的行 $r_1=(1,0,1,1)$、$r_2=(0,1,1,0)$，且 $B$ 取的是 $A$ 的**第 1、2 列**：$\boldsymbol{a}_1=(1,2,1)$、$\boldsymbol{a}_2=(1,3,2)$。则列关系应为 $\boldsymbol{a}_3=1\cdot\boldsymbol{a}_1+1\cdot\boldsymbol{a}_2=(2,5,3)$ ✓（正是 $A$ 的第三列）；$\boldsymbol{a}_4=1\cdot\boldsymbol{a}_1+0\cdot\boldsymbol{a}_2=(1,2,1)$ ✓。上面「不对」的检查把 $B$ 的列抄着用了 $A$ 的行，属笔误——**教训：$B$ 是 $A$ 的列拼成的矩阵，核对时要用列向量**。∎
:::
:::

::: ex C9 · 两种满秩分解与过渡矩阵

对 $A=\begin{bmatrix}1&2&3\\ 0&1&1\end{bmatrix}$：写出两种不同的满秩分解 $A=B_1C_1=B_2C_2$，求出 [@thm-3.2.2] 中的 $D$，并验证 $B_1=B_2D$、$C_1=D^{-1}C_2$。

::: sol 解答

**分解一**（取第 1、2 列）：$B_1=\begin{bmatrix}1&2\\ 0&1\end{bmatrix}$，$C_1=\begin{bmatrix}1&0&1\\ 0&1&1\end{bmatrix}$（$B_1$ 可逆，$C_1=B_1^{-1}A$）。

**分解二**（取第 1、3 列）：$B_2=\begin{bmatrix}1&3\\ 0&1\end{bmatrix}$，$C_2=\begin{bmatrix}1&-1&0\\ 0&1&1\end{bmatrix}$。验算：$\begin{bmatrix}1&3\\0&1\end{bmatrix}\begin{bmatrix}1&-1&0\\0&1&1\end{bmatrix}=\begin{bmatrix}1&2&3\\0&1&1\end{bmatrix}=A$ ✓。

**求 $D$**：由 $B_1=B_2D$ 得

$$D=B_2^{-1}B_1=\begin{bmatrix}1&-3\\ 0&1\end{bmatrix}\begin{bmatrix}1&2\\ 0&1\end{bmatrix}=\begin{bmatrix}1&-1\\ 0&1\end{bmatrix},\qquad \det D=1\neq0\ \checkmark$$

**验算 $C_1=D^{-1}C_2$**：$D^{-1}=\begin{bmatrix}1&1\\ 0&1\end{bmatrix}$，

$$D^{-1}C_2=\begin{bmatrix}1&1\\ 0&1\end{bmatrix}\begin{bmatrix}1&-1&0\\ 0&1&1\end{bmatrix}=\begin{bmatrix}1&0&1\\ 0&1&1\end{bmatrix}=C_1\ \checkmark$$

**读 $D$**：$D$ 是「由 $B_2$ 的列到 $B_1$ 的列」的过渡矩阵——即 $([\boldsymbol{a}_1,\boldsymbol{a}_3])=([\boldsymbol{a}_1,\boldsymbol{a}_2])D$，与 [@note-3.2.unique] 一致。∎
:::
:::

::: ex C10 · 相抵分解（$3\times2$、秩 $1$）

求 $A=\begin{bmatrix}1&-1\\ 0&0\\ 2&-2\end{bmatrix}$ 的相抵分解式。

::: sol 解答

**秩**：$r=1$（三行都与 $(1,-1)$ 成比例；实际 $\boldsymbol{r}_3=2\boldsymbol{r}_1$、$\boldsymbol{r}_2=\boldsymbol{0}$）。

**消元**：$r_3\leftarrow r_3-2r_1$；$c_2\leftarrow c_2+c_1$。得 $E=\begin{bmatrix}1&0&0\\ 0&1&0\\ -2&0&1\end{bmatrix}$、$F=\begin{bmatrix}1&1\\ 0&1\end{bmatrix}$，$EAF=\begin{bmatrix}1&0\\0&0\\0&0\end{bmatrix}=\Gamma$ ✓。

**分解式**：$A=E^{-1}\Gamma F^{-1}$，

$$E^{-1}=\begin{bmatrix}1&0&0\\ 0&1&0\\ 2&0&1\end{bmatrix},\qquad F^{-1}=\begin{bmatrix}1&-1\\ 0&1\end{bmatrix},\qquad
E^{-1}\Gamma F^{-1}=\begin{bmatrix}1&-1\\ 0&0\\ 2&-2\end{bmatrix}=A\ \checkmark$$

∎
:::
:::

::: ex C11 · 四个秩的核对

对 $A=\begin{bmatrix}1&2\\ 2&4\\ 3&6\end{bmatrix}$：计算 $A^{\mathrm H}A$、$AA^{\mathrm H}$，并核对 [@prop-3.1.1] 的四个秩。

::: sol 解答

$$A^{\mathrm H}A=\begin{bmatrix}1&2&3\\2&4&6\end{bmatrix}\begin{bmatrix}1&2\\2&4\\3&6\end{bmatrix}=\begin{bmatrix}14&28\\ 28&56\end{bmatrix},\qquad
AA^{\mathrm H}=\begin{bmatrix}1&2\\2&4\\3&6\end{bmatrix}\begin{bmatrix}1&2&3\\2&4&6\end{bmatrix}=\begin{bmatrix}5&10&15\\ 10&20&30\\ 15&30&45\end{bmatrix}.$$

**秩**：$\operatorname{rank}A=1$（列成比例）；$A^{\mathrm H}A$ 第二行 $=2\times$ 第一行 $\Rightarrow$ 秩 $1$；$AA^{\mathrm H}$ 的各行成比例 $\Rightarrow$ 秩 $1$；$\operatorname{rank}(A^{\mathrm H})=1$。四项相等 ✓：

$$\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})=\operatorname{rank}(A^{\mathrm H})=1 .$$

**要点**：$A^{\mathrm H}A$、$AA^{\mathrm H}$ 与 $A$ 同秩，但**尺寸不同**（$A^{\mathrm H}A$ 是 $2\times2$、$AA^{\mathrm H}$ 是 $3\times3$）——秩相同、零空间不同（$N(A^{\mathrm H}A)=N(A)$，而 $N(AA^{\mathrm H})=N(A^{\mathrm H})$）。∎
:::
:::

::: ex C12 · 满秩分解与四个子空间

对 $A=\begin{bmatrix}1&0&1\\ 0&1&1\\ 1&1&2\end{bmatrix}$：求满秩分解；由此写出 $R(A)$ 的基、$\operatorname{rank}A$ 与 $N(A)$ 的基。

::: sol 解答

**满秩分解**：$\boldsymbol{a}_3=\boldsymbol{a}_1+\boldsymbol{a}_2$，$r=2$，取第 1、2 列：

$$B=\begin{bmatrix}1&0\\ 0&1\\ 1&1\end{bmatrix},\qquad C=\begin{bmatrix}1&0&1\\ 0&1&1\end{bmatrix},\qquad BC=\begin{bmatrix}1&0&1\\0&1&1\\1&1&2\end{bmatrix}=A\ \checkmark$$

**$R(A)$ 的基**：$B$ 的两列，$R(A)=\operatorname{span}\{(1,0,1)^{\mathrm T},(0,1,1)^{\mathrm T}\}$，$\operatorname{rank}A=2$。

**$N(A)$ 的基**：解 $A\boldsymbol{x}=\boldsymbol{0}$：$x_1+x_3=0$、$x_2+x_3=0$，取 $x_3=1$：$\boldsymbol{n}=(-1,-1,1)^{\mathrm T}$。验算 $A\boldsymbol{n}=(-1+1,-1+1,-1-1+2)^{\mathrm T}=\boldsymbol{0}$ ✓。$N(A)=\operatorname{span}\{\boldsymbol{n}\}$，$\dim=1=n-r$ ✓。

**一句话**：满秩分解给出「活的」部分（$R(A)$ 的基在 $B$ 里），而「死的」部分（$N(A)$）要另解方程——但两者的维数由 $r$ 一分为二：$2+1=3$ ✓。
:::
:::

::: ex C13 · 右逆与全部右逆（$2\times3$）

设 $A=\begin{bmatrix}1&2&3\\ 0&1&1\end{bmatrix}$：用公式构造一个右逆，并写出全部右逆。

::: hint 提示

先算 $AA^{\mathrm H}$ 与其逆；「全部右逆」的差集是「每列属于 $N(A)$」的矩阵——$N(A)$ 的基是 $(-1,-1,1)^{\mathrm T}$。
:::

::: sol 解答

**基本解**：$AA^{\mathrm H}=\begin{bmatrix}14&5\\5&2\end{bmatrix}$，$\det=3$，$(AA^{\mathrm H})^{-1}=\dfrac13\begin{bmatrix}2&-5\\-5&14\end{bmatrix}$，

$$B_0=A^{\mathrm H}(AA^{\mathrm H})^{-1}=\frac13\begin{bmatrix}1&0\\2&1\\3&1\end{bmatrix}\begin{bmatrix}2&-5\\-5&14\end{bmatrix}=\frac13\begin{bmatrix}2&-5\\ -1&4\\ 1&-1\end{bmatrix},\qquad AB_0=I_2\ \checkmark$$

**$N(A)$**：$x_1+2x_2+3x_3=0$、$x_2+x_3=0$ 得 $\boldsymbol{n}=(-1,-1,1)^{\mathrm T}$（验算 $A\boldsymbol{n}=(-1-2+3,-1+1)^{\mathrm T}=\boldsymbol{0}$ ✓）。

**全部右逆**：

$$B=B_0+\begin{bmatrix}-s&-t\\ -s&-t\\ s&t\end{bmatrix},\qquad s,t\in\mathbb C$$

**验算**：$A\begin{bmatrix}-s&-t\\-s&-t\\s&t\end{bmatrix}=\begin{bmatrix}-s-2s+3s&-t-2t+3t\\ -s+s&-t+t\end{bmatrix}=O$ ✓。∎
:::
:::

::: ex C14 · $AXA=A$ 的一个解

设 $A=\begin{bmatrix}1&1\\ 1&1\end{bmatrix}$：用满秩分解求出 $AXA=A$ 的一个解 $X$ 并验证。

::: hint 提示

$r=1$：取 $B=\begin{bmatrix}1\\1\end{bmatrix}$、$C=[1\ \ 1]$，代 $X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}$ 再验算 $AXA=A$。
:::

::: sol 解答

**满秩分解**：$B=\begin{bmatrix}1\\1\end{bmatrix}$、$C=[1\ \ 1]$，$BC=A$ ✓。

**构造 $X$**：

$$X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}
=\begin{bmatrix}1\\1\end{bmatrix}\cdot\frac12\cdot\frac12\cdot[1\ \ 1]
=\frac14\begin{bmatrix}1&1\\ 1&1\end{bmatrix}.$$

**验算**：

$$AXA=\frac14\begin{bmatrix}1&1\\1&1\end{bmatrix}\begin{bmatrix}1&1\\1&1\end{bmatrix}\begin{bmatrix}1&1\\1&1\end{bmatrix}
=\frac14\begin{bmatrix}2&2\\2&2\end{bmatrix}\begin{bmatrix}1&1\\1&1\end{bmatrix}=\frac14\begin{bmatrix}4&4\\4&4\end{bmatrix}=\begin{bmatrix}1&1\\1&1\end{bmatrix}=A\ \checkmark$$

**补充核对**（用 [@note-3.2-axa-iff]）：$CXB=[1\ \ 1]\cdot\frac14\begin{bmatrix}1&1\\1&1\end{bmatrix}\cdot\begin{bmatrix}1\\1\end{bmatrix}=[1\ \ 1]\cdot\frac14\begin{bmatrix}2\\2\end{bmatrix}=1=I_1$ ✓。

**观察**：解**不唯一**——所有元素之和为 $1$ 的 $2\times2$ 矩阵都满足 $AXA=A$（因为 $AXA=(\sum_{ij}x_{ij})\,A$）。∎
:::
:::

::: ex C15 · 判断是否为满秩分解

指出下列各式是否为满秩分解（说明理由）：

(a) $\begin{bmatrix}1&2\\ 3&4\end{bmatrix}=\begin{bmatrix}1\\2\end{bmatrix}[1\ \ 2]$；(b) $\begin{bmatrix}1&2\\ 3&4\end{bmatrix}=I_2\begin{bmatrix}1&2\\ 3&4\end{bmatrix}$；(c) $\begin{bmatrix}2&4\\ 1&2\end{bmatrix}=\begin{bmatrix}2\\1\end{bmatrix}[1\ \ 2]$；(d) $\begin{bmatrix}2&4\\ 1&2\end{bmatrix}=\begin{bmatrix}1\\1\end{bmatrix}[2\ \ 4]$。

::: sol 解答

**(a) 不是**：右边乘积 $=\begin{bmatrix}1&2\\2&4\end{bmatrix}\neq A$（且 $A$ 可逆、秩 $2$，而右边秩 $\le1$——秩都不等，必不是）。
**(b) 是**：$I_2$ 列满秩（秩 $2$）、$A$ 行满秩（$2\times2$ 秩 $2$），而 $A=I_2A$——注意这正是 [@note-3.2-columns]（注 2）型的「平凡但合法」的分解。
**(c) 是**：$B=\begin{bmatrix}2\\1\end{bmatrix}$ 列满秩（$1$ 列，非零）、$C=[1\ \ 2]$ 行满秩（$1$ 行，非零），乘积 $=\begin{bmatrix}2&4\\1&2\end{bmatrix}=A$ ✓；$r=1$ ✓。
**(d) 不是**：乘积 $=\begin{bmatrix}2&4\\2&4\end{bmatrix}\neq\begin{bmatrix}2&4\\1&2\end{bmatrix}$（$B$ 的列不在 $R(A)$ 的方向上：$R(A)=\operatorname{span}\{(2,1)^{\mathrm T}\}$，而 $(1,1)^{\mathrm T}$ 不属于它）。

**要点**：判断满秩分解要过三关——乘积等于 $A$、$B$ 列满秩、$C$ 行满秩；且 $B$ 的列必须落在 $R(A)$ 里（(d) 就是这一关不过）。
:::
:::

::: ex C16 · 从相抵分解读出满秩分解

设 $A$ 如 [@ex-C3]（$3\times3$、秩 $2$）。用相抵分解的「方法 1」（[@thm-3.2.1]）从 $E^{-1}$、$F^{-1}$ 直接读出 $A$ 的一个满秩分解，并验算。

::: sol 解答

方法 1 的配方：$A=P^{-1}\Gamma Q=P^{-1}\begin{bmatrix}I_r\\0\end{bmatrix}[I_r,\ 0]Q$，故

$$B=P^{-1}\begin{bmatrix}I_r\\0\end{bmatrix}=\text{（}P^{-1}\ \text{的前 } r \text{ 列）},\qquad C=[I_r,\ 0]Q=\text{（}Q\ \text{的前 } r \text{ 行）}.$$

代入 [@ex-C3] 的结果 $P^{-1}=E^{-1}=\begin{bmatrix}1&0&0\\2&1&0\\3&1&1\end{bmatrix}$、$Q=F^{-1}=\begin{bmatrix}1&2&3\\0&1&1\\0&0&1\end{bmatrix}$，取前 $r=2$ 列 / 行：

$$B=\begin{bmatrix}1&0\\ 2&1\\ 3&1\end{bmatrix},\qquad C=\begin{bmatrix}1&2&3\\ 0&1&1\end{bmatrix}.$$

**验算**：

$$BC=\begin{bmatrix}1&0\\2&1\\3&1\end{bmatrix}\begin{bmatrix}1&2&3\\0&1&1\end{bmatrix}=\begin{bmatrix}1&2&3\\2&5&7\\3&7&10\end{bmatrix}=A\ \checkmark$$

且 $B$ 列满秩（两列无关）、$C$ 行满秩（两行无关）✓。

**读信息**：$R(A)=\operatorname{span}\{(1,2,3)^{\mathrm T},(0,1,1)^{\mathrm T}\}$——**注意这不是 $A$ 的前两列**（$A$ 的前两列是 $(1,2,3)^{\mathrm T},(2,5,7)^{\mathrm T}$）：同一组基可以由不同的向量担任，正印证了注 2（[@note-3.2-columns]）「基不一定从 $A$ 的列中选取」。∎
:::
:::

---

**依据**本课程第三章课件 3.1 相抵分解（15 页）、3.2 满秩分解（9 页，存于 `raw/decks/`）整理 · 两节均无录播 · 整理日期 2026-10-13 · 3.3 及以后素材到位后本页续写。