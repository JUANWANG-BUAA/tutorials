# 习题集 · 第三章（3.1–3.2 与 3.4–3.8）

三组分层：A 组概念判断（快速自检）、B 组推理证明（考试大题）、C 组计算实操。**全部附解答**（默认折叠），建议先独立完成再展开对照。所有题目只使用 [3.1](sec31.md)、[3.2](sec32.md)、[3.4](sec34.md)、[3.5](sec35.md)、[3.6](sec36.md)、[3.7](sec37.md)、[3.8](sec38.md) 的概念与第一、二章先修知识。

本页 A、B、C 三组 82 题：A 组（27 题）、B 组（21 题）、C 组（34 题）。

| 组 | 定位 | 建议时长 | 卡壳时怎么办 |
|:--|:--|:--|:--|
| **A 组**（27 题） | 概念判断，口答即可 | 每题 1–2 分钟 | 直接看解答，回到对应小节的「即时自测」重读 |
| **B 组**（21 题） | 推理证明，需完整写出 | 每题 8–12 分钟 | 先看提示，再用 10 分钟；仍无思路才展开解答 |
| **C 组**（34 题） | 计算实操，注意验算 | 每题 5–8 分钟 | 看提示定位方法，算完**一定代回验证** |

::: note 关于「提示」层

B5、B7、B8、B11、B15、B18、C4、C13、C14、C17 这 10 题提供了折叠的「提示」——它只给**从哪里下手**，不给完整过程。先看提示、自己推完，再对照解答，学习效果远好于直接读解答。
:::

::: note 关于难度分布

A 组覆盖全部「辨析点」：相抵分解不唯一 / 标准形唯一、相抵与相似的分野、单侧逆的存在判别与「方阵前提」、$\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ 的四个等式、满秩分解的形状与读法、两种分解各自「不唯一的程度」、$AXA=A$ 的解（A1–A12）；QR 分解的存在 / 唯一 / 正线、列正交规范与酉矩阵的分野、QR 算法的相似性与收敛条件（A13–A16）；Schur 引理的适用范围、实数域边界、谱映射与特征向量继承的单向性、最小多项式的四条事实、逆矩阵公式（A17–A20）；对角化五判据、正规 / 单纯 / Hermite 的包含关系、实对称正交对角化、谱分解与谱阵（A21–A24）；$\lambda$ 矩阵的秩、满秩与可逆的分界（A25）。

B 组以**相抵 $\iff$ 同秩**、**单侧逆的构造与判别**、**满秩分解的两条主干证明**（$\operatorname{rank}C=r$、[@thm-3.2.2]）与 **$AXA=A\iff CXB=I_r$** 为重心（B1–B10，B9 把 3.1 的结论接回第一章的正定矩阵）；B11–B13 补 QR 的两条主干（对角酉阵刻画、迭代相似链与等模卡死），B14–B17 补 Schur / 谱映射 / 最小多项式的证明重做（B15 给出不依赖定理 3.5.1 的直接构造路线）；B18–B20 补正规谱定理、实正规矩阵的对称判别与谱分解驱动的逆 / 指数 / 酉性（B18 给出上三角正规阵必对角的完整归纳）；B21 把幂等阵的空间分解与「伴随矩阵仍是幂等阵」收进一题。

C 组训练十件基本功：**相抵分解（含分块矩阵法求 $P^{-1}$、$Q^{-1}$）**、**用相抵标准形解方程组**、**单侧逆的构造与「全部右逆」的写法**、**满秩分解的三种算法**（取列 / RREF / 从相抵分解读）、**GS 手算 QR 与长方阵补齐**（C17、C18、C22）、**H–C 与最小多项式驱动的三套计算**（C19–C21、C23、C24）、**对角化的判定与正交化**（C25、C26、C27）、**谱分解与 Lagrange 公式**（C28）、**正交投影矩阵与最小二乘**（C29）、**$\lambda$ 矩阵的秩 / 可逆 / 初等变换**（C30、C31）、**Smith 标准形 / 初等因子 / Jordan 标准形**（C32–C34）。3.3 与 3.9 及以后素材到位后，本页按同样的三组结构续写。
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

::: ex A13 · QR 分解的四个基本事实 {#ex-A13}

判断对错并说明理由：

(a) 任何满秩复方阵都有唯一的 QR 分解；(b) 不满秩的方阵一定没有 QR 分解；(c) 列满秩的长方阵 $A\in\mathbb C^{m\times n}_n$（$n\le m$）可分解为 $A=U\begin{bmatrix}R_1\\O\end{bmatrix}$；(d) $n$ 阶实满秩方阵在不要求「正线」时恰有 $2^n$ 种正交三角分解。

::: sol 解答

(a) **对**（[@thm-3.4.1]：满秩保证存在；「正线」约定保证唯一）。(b) **错**——[@ex-3.4.2] 的 $A=\begin{bmatrix}1&1\\0&0\end{bmatrix}$ 有 $A=I_2\begin{bmatrix}1&1\\0&0\end{bmatrix}$，丢掉的只是**唯一性**（$R$ 不可逆）。(c) **对**（[@cor-3.4.1]：GS $+$ 基扩充）。(d) **对**——任意两种分解相差对角正交阵 $D=\operatorname{diag}(\pm1,\cdots,\pm1)$（$2^n$ 个），见 [3.4.1](sec34.md#sec-3.4.1) 的本编补注。

**要点**：存在性的保底比想象中宽（不满秩、长方阵都常有分解），唯一性的门槛比想象中高（要满秩**加**正线）。
:::
:::

::: ex A14 · 数清一个矩阵的全部 QR 分解 {#ex-A14}

写出 $A=\begin{bmatrix}0&1\\ 1&0\end{bmatrix}$ 的**全部**正交三角分解（$Q$ 正交、$R$ 可逆上三角，不要求正线），指出其中正线的版本，并说明为什么没有第五种。

::: sol 解答

$A$ 本身是正交矩阵（置换阵，且 $A^2=I$），两列 $\boldsymbol{e}_2,\boldsymbol{e}_1$ 已标准正交。GS 直接给出正线版本 $Q=A$、$R=I$（第一列 $r_{11}=\|\boldsymbol{e}_2\|=1$，$r_{12}=(\boldsymbol{e}_1,\boldsymbol{e}_2)=0$，$r_{22}=1$）。由对角正交阵生成全部 $2^2=4$ 种，形如 $\big(A\cdot D,\ D\big)$（$R=I$ 被 $D$ 左乘后仍是上三角）：

$$(A,\ I),\qquad\big(A\operatorname{diag}(-1,1),\ \operatorname{diag}(-1,1)\big),\qquad\big(A\operatorname{diag}(1,-1),\ \operatorname{diag}(1,-1)\big),\qquad\big(A\operatorname{diag}(-1,-1),\ \operatorname{diag}(-1,-1)\big).$$

（验算其一：$A\operatorname{diag}(-1,1)=\begin{bmatrix}0&1\\-1&0\end{bmatrix}$ 正交 ✓，$\operatorname{diag}(-1,1)$ 上三角 ✓，乘积 $=\begin{bmatrix}0&1\\1&0\end{bmatrix}=A$ ✓。）**正线版本**：只有 $(A,I)$（对角全 $1>0$）。**没有第五种**：若 $A=Q'R'$ 是任一分解，则 $W=R'R^{-1}=Q'^{\mathrm T}Q$ 既酉又上三角，故为对角阵且 $|w_{ii}|=1$（[3.4.1](sec34.md#sec-3.4.1) 的归纳），实数情形 $w_i=\pm1$——恰好穷尽。∎
:::
:::

::: ex A15 · 列正交规范矩阵辨析 {#ex-A15}

设 $Q\in\mathbb C^{m\times n}$（$m>n$）满足 $Q^{\mathrm H}Q=I_n$。判断：

(a) $Q$ 是酉矩阵；(b) 对一切 $\boldsymbol{x}\in\mathbb C^n$ 有 $\|Q\boldsymbol{x}\|=\|\boldsymbol{x}\|$；(c) $Q$ 列满秩，$Q^{\mathrm H}$ 是它的一个左逆；(d) $QQ^{\mathrm H}=I_m$。

::: sol 解答

(a) **错**——酉矩阵必须是方阵（[@def-orth-matrix]）；$Q$ 只是**列正交规范矩阵**（[@def-3.4.2]）。(b) **对**：$\|Q\boldsymbol{x}\|^2=\boldsymbol{x}^{\mathrm H}Q^{\mathrm H}Q\boldsymbol{x}=\|\boldsymbol{x}\|^2$。(c) **对**：$Q^{\mathrm H}Q=I_n$ 本身就是「列满秩 $+$ 给出左逆」（[@thm-3.1.1]）。(d) **错**：$QQ^{\mathrm H}$ 是把 $\mathbb C^m$ 先投影到 $n$ 维再放回的算子，与 $I_m$ 差一个 $m-n$ 维的正交补——例如 $Q=\begin{bmatrix}1\\0\\0\end{bmatrix}$ 时 $QQ^{\mathrm H}=\operatorname{diag}(1,0,0)$。

**要点**：$Q^{\mathrm H}Q=I_n$ 与 $QQ^{\mathrm H}=I_m$ 只在 $m=n$（方阵）时可能同时成立——**形状就是命题的一部分**。
:::
:::

::: ex A16 · QR 算法四问 {#ex-A16}

判断对错：

(a) 迭代的每个 $A_k$ 都与 $A$ 相似；(b)「各特征值模值互不相同」是 QR 算法收敛的必要条件；(c) 模互异时，收敛所得上三角阵的对角元按模从大到小排定；(d) 特征值等模时 QR 迭代一定不收敛。

::: sol 解答

(a) **对**：$A_{k+1}=Q_k^{\mathrm H}A_kQ_k$，链起来 $A_k=(Q_1\cdots Q_{k-1})^{\mathrm H}A(Q_1\cdots Q_{k-1})$（[@method-qr-algo]）。(b) **错**——须结合结构与初始分量讨论，不能仅据此保证全矩阵收敛；它也不是必要条件（例如 $A$ 已经是对角元全正的上三角阵时迭代一步不动、天然「收敛」，无论对角元模是否互异）。(c) **错**：$\operatorname{diag}(1,2)$ 的正线 QR 不动，对角元没有按模递减。(d) **错**：等模时**可能**卡死（旋转阵：$A=A\cdot I\Rightarrow A_2=A$），但「一定不收敛」过强——见 (b) 的三角阵例子，特征值 $\lambda_1=\lambda_2$（等模）迭代照样稳定。

**要点**：模互异本身也不保证全矩阵收敛；异模上三角两周期反例见 [@method-qr-algo]。相似链、三角化、极限与排序是不同问题。
:::
:::

::: ex A17 · Schur 引理辨析 {#ex-A17}

判断对错：

(a) 任意复方阵都酉相似于上三角阵；(b) 任意实方阵都正交相似于上三角阵；(c) 特征值全实的实方阵正交相似于上三角阵；(d) 任意复方阵都相似于对角阵。

::: sol 解答

(a) **对**（[@thm-3.5.2]）。(b) **错**——旋转阵 $\begin{bmatrix}0&-1\\1&0\end{bmatrix}$ 特征值 $\pm\mathrm i$：正交相似保持实性，实上三角阵特征值全实，矛盾（[3.5.1](sec35.md#sec-3.5.1) 的反例分析）。(c) **对**（[@thm-3.5.3]，前提正是「特征值均为实数」）。(d) **错**（注 1：三角化人人有份，对角化不是——[@ex-jordan-three]）。

**要点**：(a) 与 (d) 的差别就是「对角化」与「三角化」的差别；(b) 与 (c) 的差别就是复结论进入实数域时要补的门票。
:::
:::

::: ex A18 · 谱映射与特征向量继承 {#ex-A18}

设 $A$ 的特征值为 $1,-1$（各一重，$A$ 为二阶）。判断：

(a) $A^2+I$ 的特征值为 $2,2$；(b) $A$ 的特征向量都是 $A^2+I$ 的特征向量；(c) $A^2+I$ 的特征向量都是 $A$ 的特征向量；(d) $A^{2026}$ 的特征值为 $1,1$。

::: sol 解答

(a) **对**（[@cor-3.5.1]：$\varphi(\lambda)=\lambda^2+1$，$\varphi(\pm1)=2$）。(b) **对**（注 4 继承：$A\boldsymbol{\alpha}=\lambda\boldsymbol{\alpha}\Rightarrow\varphi(A)\boldsymbol{\alpha}=\varphi(\lambda)\boldsymbol{\alpha}$）。(c) **错**：$A=\operatorname{diag}(1,-1)$ 时 $A^2+I=2I$，一切非零向量都是它的特征向量，而 $\boldsymbol{e}_1+\boldsymbol{e}_2$ 不是 $A$ 的特征向量——$\varphi$ 把两个特征值黏在一起了。(d) **对**：$\varphi(\lambda)=\lambda^{2026}$，$\varphi(\pm1)=1$（偶次幂把 $\pm1$ 黏成 $1$，与 (c) 同源）。
:::
:::

::: ex A19 · 最小多项式四问 {#ex-A19}

判断对错：

(a) 任何复方阵的最小多项式存在且唯一；(b) 最小多项式恒等于特征多项式；(c) $m_A(\lambda)$ 整除 $f_A(\lambda)$；(d) $m_A$ 与 $f_A$ 的根相同（不计重数）。

::: sol 解答

(a) **对**（存在：$f_A$ 本身零化（H–C），次数取最小；唯一：互相整除 $+$ 同次首一，[@thm-3.5.5]（1））。(b) **错**：$A=I_2$ 时 $f_A=(\lambda-1)^2$ 而 $m_A=\lambda-1$；一般 $m_A=f_A$ 当且仅当每个特征值的「最大块」都顶到代数重数（例 3.5.B 的情形）。(c) **对**（$f_A$ 是零化多项式，$m_A$ 整除一切零化多项式）。(d) **对**（[@thm-3.5.5]（2）：正向由整除，反向由特征向量继承）。
:::
:::

::: ex A20 · 逆矩阵公式辨析 {#ex-A20}

设 $f_A(\lambda)=\lambda^n+a_{n-1}\lambda^{n-1}+\cdots+a_1\lambda+a_0$。判断：

(a) $a_0=0\iff A$ 不可逆；(b) $A$ 可逆时，$A^{-1}$ 可以写成 $A$ 的多项式；(c) 推论 3.5.2 的公式是 $A^{-1}=\frac{1}{a_0}(A^{n-1}+a_{n-1}A^{n-2}+\cdots+a_1I)$；(d) 例 3.5.3 课件把答案 $(1,3)$ 元印成 $0$，与它前面的特征多项式符号错无关，是独立的抄写错误。

::: sol 解答

(a) **对**：$a_0=f_A(0)=\det(-A)=(-1)^n\det A$（[@cor-3.5.2] 证明）。(b) **对**——推论 3.5.2 的公式就是一个这样的多项式（这补上了谱映射讨论里「$1/\lambda$ 不是多项式」的口子）。(c) **错**——差一个负号：正确为 $-\frac{1}{a_0}(\cdots)$（由 $A(\cdots)=-a_0I$ 移项而来）。(d) **错**——三处错误同源连锁：特征多项式符号错（$(\lambda-1)^3$ 印成 $(\lambda+1)^3$）$\Rightarrow$ 公式行系数全错 $\Rightarrow$ 答案矩阵错；即使按印错的公式行计算，答案也不是印出的那个矩阵（见 E3.5 的逐条核算）。
:::
:::

::: ex A21 · 单纯矩阵五问 {#ex-A21}

判断对错并说明理由：

(a) 任意复方阵都相似于对角阵；(b) $A$ 有 $n$ 个互异特征值，则 $A$ 可对角化，反之亦然；(c) $A$ 可对角化 $\iff$ 最小多项式 $m_A$ 无重根；(d) $A$ 可对角化 $\Rightarrow$ $A$ 存在一个无重根的零化多项式；(e) $A$ 有重特征值 $\Rightarrow$ $A$ 不可对角化。

::: sol 解答

(a) **错**——只有 Schur 保底：任意复方阵酉相似于上三角，但不一定对角（[@thm-3.5.2]、[@note-3.5-diag]）。(b) **前半对、后半错**：互异 $\Rightarrow$ 可对角化（[@cor-3.6.1]），但 $I_n$ 只有一重特征值却可对角化——反之不然。(c) **对**（[@thm-3.6.1]（5）$\iff$（1））。(d) **对**——取 $g=m_A$ 即可；注意不能加强成「每个零化多项式都无重根」（$I_2$ 的 $f_A=(\lambda-1)^2$ 是反例，[@note-3.6-sufficient]）。(e) **错**——$I_n$、$\operatorname{diag}(1,1,2)$ 都有重特征值且可对角化；重特征值只说明「可能不够」，是否够要看 $g_i=d_i$。
:::
:::

::: ex A22 · 正规、单纯与 Hermite 的辨析 {#ex-A22}

判断对错：

(a) Hermite 矩阵一定是正规矩阵；(b) 正规矩阵一定是 Hermite 矩阵；(c) 可对角化矩阵一定是正规矩阵；(d) 实对称矩阵一定可以正交对角化；(e) 实正交矩阵一定可以用实正交矩阵对角化；(f) 正规矩阵若特征值全实，则它是 Hermite 矩阵；(g) 酉矩阵的特征值模为 $1$，且一定可以酉对角化。

::: sol 解答

(a) **对**：$A^{\mathrm H}=A\Rightarrow A^{\mathrm H}A=A^2=AA^{\mathrm H}$。(b) **错**：$\begin{bmatrix}1&1\\-1&1\end{bmatrix}$ 正规但 $B^{\mathrm T}\ne B$（[@ex-3.6.C]）。(c) **错**：$\begin{bmatrix}1&1\\0&2\end{bmatrix}$ 可对角化但不正规（[@ex-3.6.C]）。(d) **对**（[@cor-3.6.4]）。(e) **错**：旋转阵 $\begin{bmatrix}0&-1\\1&0\end{bmatrix}$ 的特征值是 $\pm\mathrm i$，不存在实正交 $Q$ 把它对角化（[@note-3.6-rotation]）；只能用酉 $U$ 在 $\mathbb C$ 上对角化。(f) **对**：正规 $\Rightarrow$ 酉对角化，$A=U\Lambda U^{\mathrm H}$，$\lambda_i$ 全实 $\Rightarrow A^{\mathrm H}=U\Lambda^{\mathrm H}U^{\mathrm H}=U\Lambda U^{\mathrm H}=A$。(g) **对**：酉矩阵正规，故可酉对角化；模为 $1$ 由 [@thm-orth-eig]。
:::
:::

::: ex A23 · 实对称正交对角化的四个判断 {#ex-A23}

判断对错：

(a) 实对称矩阵属于不同特征值的特征向量必正交；(b) 实对称矩阵属于同一特征值的任意两个特征向量必正交；(c) 若 $Q$ 是正交矩阵且 $Q^{\mathrm T}AQ$ 为对角阵，则 $A$ 必为实对称矩阵；(d) 实对称矩阵的特征值全为实数。

::: sol 解答

(a) **对**（[@cor-3.6.4] 或 [@note-3.6-why-gs-inside] 的一行证明）。(b) **错**——同一特征子空间内可以取到不正交的基（例 3.6.6 的 $\boldsymbol x_2,\boldsymbol x_3,\boldsymbol x_4$），需要 Gram–Schmidt。(c) **对**：$A=Q\Lambda Q^{\mathrm T}$，$\Lambda$ 实对角，故 $A^{\mathrm T}=Q\Lambda Q^{\mathrm T}=A$。(d) **对**（[@cor-3.6.4]；也可由特征多项式为实系数且根成共轭对、对称性逼出实根）。
:::
:::

::: ex A24 · 谱分解五问 {#ex-A24}

判断对错：

(a) 单纯矩阵的谱分解总存在；(b) 谱阵一定是幂等阵；(c) 谱阵一定是正交投影；(d) 对任意多项式 $f$，$f(A)=\sum_jf(\lambda_j)E_j$；(e) 不可对角化的矩阵也可以写成 $A=\sum_j\lambda_jE_j$，其中 $E_j$ 是幂等阵。

::: sol 解答

(a) **对**（[@note-3.7-existence]、[@method-spectral]）。(b) **对**（[@prop-3.7.1]（1））。(c) **错**——只有正规矩阵的谱阵才是正交投影；非正规单纯矩阵的谱阵是斜投影（[@ex-3.7.A]、[@prop-3.7.2]）。(d) **对**（[@thm-3.7.1]）。(e) **错**——谱分解的门票是单纯；不可对角化时只能退到 Schur 型 / Jordan 型，$E_j$ 不再是幂等的（会出现 Jordan 块的多项式项）。
:::
:::

::: ex A25 · $\lambda$ 矩阵与投影六问 {#ex-A25}

判断对错：

(a) $\lambda$ 矩阵的秩等于「对每个 $\lambda$ 代入后数值矩阵的秩」；

(b) $\lambda$ 矩阵满秩就一定有逆矩阵；

(c) 若 $\lambda$ 方阵的行列式是非零常数，则它可逆；

(d) 对 $\lambda$ 矩阵作初等变换不改变它的秩；

(e) 若 $A$ 列满秩，则 $E=A(A^{\mathrm H}A)^{-1}A^{\mathrm H}$ 是正交投影矩阵；

(f) 最小二乘问题 $\min\|A\boldsymbol x-\boldsymbol b\|$ 总有唯一解。

::: sol 解答

(a) **错**——秩看「存在不恒为零的子式」，不是逐点数值秩（[@note-3.8-pointwise]）。(b) **错**——满秩只保证 $\det\not\equiv0$；可逆要求 $\det$ 是非零常数，$\operatorname{diag}(\lambda,\lambda+1)$ 是反例（[@thm-3.8.1]）。(c) **对**——这正是 [@thm-3.8.1] 的充分性。(d) **对**——初等矩阵可逆，乘以可逆矩阵不改变秩（[@note-3.8-invariants]）。(e) **对**——$A^{\mathrm H}A$ 可逆、$E^{\mathrm H}=E$、$E^2=E$（[@ex-3.7.3]）。(f) **错**——唯一性需要 $A$ 列满秩；$A$ 秩亏时 $A^{\mathrm H}A$ 奇异，最小二乘解不唯一（[@ex-3.7.4]）。
:::
:::

::: ex A26 · Smith 标准形与初等因子七问 {#ex-A26}

判断对错并说明理由：

(a) 对角 $\lambda$ 矩阵的 Smith 标准形就是它自己；

(b) 若 $A(\lambda)$ 与 $B(\lambda)$ 的秩相同，则它们相抵；

(c) 若 $A(\lambda)$ 与 $B(\lambda)$ 的初等因子相同，则它们相抵；

(d) 不变因子相同的两个 $\lambda$ 矩阵一定相抵；

(e) 复方阵 $A\sim B$ 当且仅当 $\lambda I-A$ 与 $\lambda I-B$ 的初等因子相同；

(f) 若 $\lambda I-A$ 的初等因子全是一次式，则 $A$ 可对角化；

(g) 两个初等因子相同的复方阵一定相似。

::: sol 解答

(a) **错**——还要求对角元首 $1$ 且满足整除链 $d_1\mid d_2\mid\cdots$；例 3.8.E 的 $\operatorname{diag}(\lambda-1,(\lambda-1)(\lambda-2),(\lambda-2)^2)$ 是对角阵但不是 Smith 形（[@ex-3.8.E]）。

(b) **错**——$\operatorname{diag}(\lambda,\lambda)$ 与 $\operatorname{diag}(1,\lambda^2)$ 同秩不相抵（[@ex-3.8.7]）。

(c) **错**——还要加「秩相同」；$\operatorname{diag}(0,\lambda)$ 与 $\operatorname{diag}(1,\lambda)$ 初等因子都是 $\lambda$ 但秩不同（[@ex-3.8.8]、[@thm-3.8.4]）。

(d) **对**——不变因子相同 $\Rightarrow$ Smith 形相同 $\Rightarrow$ 相抵（[@cor-3.8.2]）。

(e) **对**——$A\sim B\iff\lambda I-A\cong\lambda I-B$；特征矩阵都满秩，秩条件自动满足，故定理 3.8.4 退化为「初等因子相同」（[@thm-3.8.5]、[@method-3.8-similar-chain]）。

(f) **对**——这是推论 3.8.3（[@cor-3.8.3]）。

(g) **对**——由 (e)：特征矩阵的初等因子相同 $\Rightarrow$ 相抵 $\Rightarrow$ 相似（[@thm-3.8.5]）。注意与 (c) 的区别：那里的对象是一般的 $\lambda$ 矩阵，秩不自动相同；这里的对象是特征矩阵，秩恒为 $n$。
:::
:::

::: ex A27 · Jordan 块与最小多项式五问 {#ex-A27}

判断对错：

(a) 单个 $s$ 阶 Jordan 块 $J_s(\lambda_0)$ 的最小多项式是 $(\lambda-\lambda_0)^s$；

(b) 若 $A$ 的 Jordan 标准形里 $\lambda_0$ 对应 $k$ 个块，则 $\lambda_0$ 的几何重数为 $k$；

(c) 若 $f_A=(\lambda-1)^3$，则 $A$ 必相似于 $J_3(1)$；

(d) Jordan 标准形除块的排列次序外唯一；

(e) 若 $A^2=A$，则 $A$ 的 Jordan 块全是一阶的。

::: sol 解答

(a) **对**——[例 3.8.10](sec38b.md#ex-3.8.10)（幂零指标为 $s$）。

(b) **对**——$\dim N(A-\lambda_0I)$ 等于以 $\lambda_0$ 为对角元的块的个数（[@note-3.8-three-multiplicities]）。

(c) **错**——$f_A=(\lambda-1)^3$ 只定了特征值 $1$ 的代数重数为 $3$；初等因子可能是 $(\lambda-1)^3$（一个 $3$ 阶块）、$(\lambda-1)^2(\lambda-1)$（$2$ 阶 $+$ $1$ 阶）、$(\lambda-1)^3$ 个一次（对角化）。三者互不相似（[@note-3.8-unique-order]）。

(d) **对**——[@thm-3.8.5j] 的唯一性。

(e) **对**——$A^2=A$ 给出零化多项式 $\lambda^2-\lambda=\lambda(\lambda-1)$ 无重根，故 $A$ 可对角化（[3.6.1](sec36.md#thm-3.6.1)（5）$\Rightarrow$（1）），Jordan 块全为一阶。
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

::: ex B11 · 两种 QR 分解恰好相差一个对角酉阵 {#ex-B11}

设 $A$ 为 $n$ 阶满秩复方阵，$A=Q_1R_1=Q_2R_2$ 是两种 QR 分解（$Q_i$ 酉、$R_i$ 可逆上三角，不要求正线）。证明：存在对角酉阵 $W=\operatorname{diag}(w_1,\cdots,w_n)$（$|w_i|=1$）使 $Q_2=Q_1W$、$R_2=W^{\mathrm H}R_1$。

::: hint 提示

考虑 $W=R_2R_1^{-1}=Q_2^{\mathrm H}Q_1$，证它「既酉又上三角」；再对列归纳证上三角酉阵必为对角。
:::

::: sol 解答

**$W$ 良定且两种身份**：$R_1$ 可逆（$A$ 满秩 $\Rightarrow\operatorname{rank}R_1=n$，上三角满秩 $\iff$ 对角全非零）。由 $Q_1R_1=Q_2R_2$ 左乘 $Q_1^{\mathrm H}$、右乘 $R_1^{-1}$：

$$W:=Q_1^{\mathrm H}Q_2=R_1R_2^{-1} .$$

左边是酉阵之积，酉（[@thm-orth-algebra]）；右边是上三角阵之积再求逆，上三角。**上三角且酉 $\Rightarrow$ 对角、$|w_{ii}|=1$**（对列归纳：第 $1$ 列只有 $w_{11}$ 非零而范数为 $1$；设前 $j-1$ 列已是 $w_{ii}\boldsymbol{e}_i$，第 $j$ 列与它们的内积为 $\overline{w_{ii}}w_{ij}=0$，逐个逼出 $w_{ij}=0$（$i<j$），范数给出 $|w_{jj}|=1$）。于是 $W$ 是对角酉阵。

**收尾**：$W=Q_1^{\mathrm H}Q_2\Rightarrow Q_2=Q_1W$（两边左乘 $Q_1$）；$W=R_1R_2^{-1}\Rightarrow R_2=W^{-1}R_1=W^{\mathrm H}R_1$（酉阵 $W^{-1}=W^{\mathrm H}$），其第 $i$ 个对角元为 $\overline{w_i}\,r_{ii}^{(1)}$。∎

**推论**：实数情形 $w_i=\pm1$，恰 $2^n$ 种；再要求两个分解都正线（$r_{ii}^{(1)}>0$、$\overline{w_i}r_{ii}^{(1)}>0$）则逼出 $w_i=1$——唯一性（[@thm-3.4.1]）。
:::
:::

::: ex B12 · 上三角酉阵必为对角阵 {#ex-B12}

证明：若 $W=(w_{ij})$ 既是 $n$ 阶上三角阵（$w_{ij}=0,\ i>j$）又是酉矩阵，则 $w_{ij}=0$（$i<j$）且 $|w_{ii}|=1$。

::: sol 解答

对列 $j$ 归纳，断言「第 $j$ 列 $=w_{jj}\boldsymbol{e}_j$ 且 $|w_{jj}|=1$」。

$j=1$：上三角使第一列只有 $w_{11}$ 可能非零；酉矩阵各列范数为 $1$（$W^{\mathrm H}W=I$ 的 $(1,1)$ 元），故 $|w_{11}|=1$，第 $1$ 列 $=w_{11}\boldsymbol{e}_1$。

$j\Rightarrow j+1$：第 $j+1$ 列的非零分量只在行 $1\cdots j+1$。对每个 $i\le j$，酉矩阵不同列正交（$W^{\mathrm H}W=I$ 的 $(i,j+1)$ 元）：

$$0=\sum_{k\le i}\overline{w_{ki}}\,w_{k,j+1}=\overline{w_{ii}}\,w_{i,j+1}\quad(\text{归纳假设：第 }i\text{ 列 }=w_{ii}\boldsymbol{e}_i,\ k>i\text{ 项为零}),$$

而 $\overline{w_{ii}}\neq0$，故 $w_{i,j+1}=0$。于是第 $j+1$ 列只剩 $w_{j+1,j+1}$，范数 $1$ 给出 $|w_{j+1,j+1}|=1$。∎

（这条小事实是 [@thm-3.4.1] 唯一性与 B11 的共同引擎；它对「行满 $+$ 酉」版本（下三角）同样成立，对 $A^{\mathrm H}$ 说一遍即可。）
:::
:::

::: ex B13 · QR 迭代的相似链与「卡死」分析 {#ex-B13}

(a) 证明 QR 迭代满足 $A_k=(Q_1Q_2\cdots Q_{k-1})^{\mathrm H}A(Q_1Q_2\cdots Q_{k-1})$，从而每个 $A_k$ 与 $A$ 相似；
(b) 证明：旋转阵 $A=\begin{bmatrix}0&-1\\1&0\end{bmatrix}$ 的迭代序列恒为 $A_k=A$，永不收敛到上三角阵。

::: sol 解答

**(a)** 归纳。$k=1$：空积为 $I$，$A_1=A$ ✓。设 $A_k=W_{k-1}^{\mathrm H}AW_{k-1}$，$W_{k-1}=Q_1\cdots Q_{k-1}$。由迭代式与 $R_k=Q_k^{\mathrm H}A_k$：

$$A_{k+1}=R_kQ_k=Q_k^{\mathrm H}A_kQ_k=Q_k^{\mathrm H}W_{k-1}^{\mathrm H}AW_{k-1}Q_k=(W_{k-1}Q_k)^{\mathrm H}A(W_{k-1}Q_k)=W_k^{\mathrm H}AW_k,$$

其中 $W_k=W_{k-1}Q_k=Q_1\cdots Q_k$（酉阵之积仍酉）。故 $A_k\sim A$，特征值全程不变（[@thm-sim-invariants]）。

**(b)** $A$ 是正交矩阵，其正线 QR 分解是 $A=A\cdot I$：唯一性（[@thm-3.4.1]）保证 GS 只能给出这一组——事实上 GS 对 $A$ 的两列 $\boldsymbol{e}_2,\boldsymbol{e}_1$ 原样通过（已标准正交），$Q_1=A$、$R_1=I$。于是

$$A_2=R_1Q_1=I\cdot A=A,$$

归纳得 $A_k=A$ 对一切 $k$ 成立；而 $A$ 不是上三角阵，序列不收敛于上三角阵。根源：特征值 $\pm\mathrm i$ **等模**，违反收敛的充分条件（[@method-qr-algo]）。∎
:::
:::

::: ex B14 · 重写定理 3.5.1 的归纳证明（不看正文）{#ex-B14}

不翻正文，独立写出 Schur 引理（复数域版本）的完整证明：任意 $n$ 阶复方阵相似于上三角阵，且对角元为其特征值。

::: sol 解答

**对 $n$ 归纳**。$n=1$ 平凡。设对 $n-1$ 成立。$A$ 的特征多项式在 $\mathbb C$ 上有根 $\lambda_1$（代数基本定理），取特征向量 $\boldsymbol{x}_1\neq\boldsymbol{0}$（$A\boldsymbol{x}_1=\lambda_1\boldsymbol{x}_1$），扩充为 $\mathbb C^n$ 的基（[@cor-1.3.1]）并拼成可逆阵 $P_1=[\boldsymbol{x}_1,\cdots]$。则 $P_1^{-1}AP_1$ 的第一列为 $P_1^{-1}A\boldsymbol{x}_1=\lambda_1\boldsymbol{e}_1$：

$$P_1^{-1}AP_1=\begin{bmatrix}\lambda_1&\boldsymbol{\beta}\\\boldsymbol{0}&A_1\end{bmatrix}.$$

对 $A_1$（$n-1$ 阶）用归纳假设：存在可逆 $Q$ 使 $Q^{-1}A_1Q=\Lambda_1$ 上三角。令 $P=P_1\operatorname{diag}(1,Q)$，则

$$P^{-1}AP=\begin{bmatrix}\lambda_1&\boldsymbol{\beta}Q\\\boldsymbol{0}&\Lambda_1\end{bmatrix}$$

上三角。对角元：分块三角行列式给 $f_A(\lambda)=(\lambda-\lambda_1)f_{A_1}(\lambda)$，故对角元全体（计重数）$=\lambda_1$ 加 $A_1$ 的特征值 $=A$ 的特征值。∎

**自查两处**：① 第一步为什么必能取到特征向量？（复数域上特征多项式必有根——这是「复」字在定理里干的活。）② 收尾为什么对角元恰是 $A$ 的特征值？（相似不改特征多项式 $+$ 分块三角行列式。）
:::
:::

::: ex B15 · 直接构造酉矩阵（不走定理 3.5.1 的路）{#ex-B15}

不经过定理 3.5.1，直接用「单位特征向量 $+$ Gram–Schmidt 扩充」归纳证明定理 3.5.2：任意复方阵酉相似于上三角阵。

::: hint 提示

取**单位**特征向量 $\boldsymbol{u}_1$，用基扩充 $+$ GS 把它扩成标准正交基；$[\boldsymbol{u}_1,\cdots]$ 拼成的矩阵是酉矩阵，算出它的第一列象。
:::

::: sol 解答

**对 $n$ 归纳**。$n=1$ 平凡。设对 $n-1$ 成立。取 $A$ 的特征值 $\lambda_1$ 与**单位**特征向量 $\boldsymbol{u}_1$（$\|\boldsymbol{u}_1\|=1$；特征向量除以范数仍是特征向量）。把 $\boldsymbol{u}_1$ 扩充为 $\mathbb C^n$ 的基（[@cor-1.3.1]），再 GS 并单位化（[@method-gs]；「张成不变」保证 $\boldsymbol{u}_1$ 原样保留），得标准正交基 $\boldsymbol{u}_1,\boldsymbol{u}_2,\cdots,\boldsymbol{u}_n$。令 $U_1=[\boldsymbol{u}_1,\cdots,\boldsymbol{u}_n]$：列标准正交的方阵，酉（[@thm-orth-columns]）。计算 $U_1^{\mathrm H}AU_1$ 的第一列：

$$U_1^{\mathrm H}A\boldsymbol{u}_1=\lambda_1U_1^{\mathrm H}\boldsymbol{u}_1=\lambda_1\boldsymbol{e}_1,$$

故 $U_1^{\mathrm H}AU_1=\begin{bmatrix}\lambda_1&\boldsymbol{\beta}\\\boldsymbol{0}&A_1\end{bmatrix}$。对 $A_1$ 用归纳假设：存在酉阵 $V$ 使 $V^{\mathrm H}A_1V=\Lambda_1$ 上三角。令 $U=U_1\operatorname{diag}(1,V)$（酉阵之积，酉），则

$$U^{\mathrm H}AU=\operatorname{diag}(1,V^{\mathrm H})\begin{bmatrix}\lambda_1&\boldsymbol{\beta}\\\boldsymbol{0}&A_1\end{bmatrix}\operatorname{diag}(1,V)=\begin{bmatrix}\lambda_1&\boldsymbol{\beta}V\\\boldsymbol{0}&\Lambda_1\end{bmatrix}$$

上三角。∎

**与正文路线的对照**：正文（[@thm-3.5.2]）「先相似再 QR 升级」是一步到位的代数戏法；本题是「边归纳边正交化」的施工图。两条路在二阶情形的差别值得一眼：前者需要先有可逆 $P$，后者从第一个特征向量起就全程保范。
:::
:::

::: ex B16 · 谱映射的一半与反例的另一半 {#ex-B16}

(a) 不用 Schur 分解，证明：若 $\boldsymbol{\alpha}$ 是 $A$ 的属于 $\lambda$ 的特征向量，则 $\boldsymbol{\alpha}$ 是 $\varphi(A)$ 的属于 $\varphi(\lambda)$ 的特征向量（注 4），且 $\varphi(\lambda_1),\cdots,\varphi(\lambda_n)$（计重数）都是 $\varphi(A)$ 的特征值；
(b) 举反例说明 $\varphi(A)$ 的特征向量不必是 $A$ 的特征向量。

::: sol 解答

**(a)** 由 $A\boldsymbol{\alpha}=\lambda\boldsymbol{\alpha}$ 归纳得 $A^k\boldsymbol{\alpha}=\lambda^k\boldsymbol{\alpha}$（$k\ge0$，含 $A^0=I$）。线性组合：

$$\varphi(A)\boldsymbol{\alpha}=\sum_ia_iA^i\boldsymbol{\alpha}=\Big(\sum_ia_i\lambda^i\Big)\boldsymbol{\alpha}=\varphi(\lambda)\boldsymbol{\alpha},$$

即 $\boldsymbol{\alpha}$ 是 $\varphi(A)$ 的特征向量（特征值 $\varphi(\lambda)$）。于是对每个特征值 $\lambda_i$ 取一个特征向量 $\boldsymbol{\alpha}_i$，$\varphi(\lambda_i)$ 就**有证人**地成为 $\varphi(A)$ 的特征值；重数叙述「计重数」的完整版需数齐 $n$ 个，那一步用三角化最省（[@cor-3.5.1] 的证明）。

**(b)** $A=\operatorname{diag}(1,-1)$、$\varphi(\lambda)=\lambda^2$：$\varphi(A)=A^2=I$，任何非零向量都是 $I$ 的特征向量（特征值 $1$），但 $\boldsymbol{e}_1+\boldsymbol{e}_2$ 不是 $A$ 的特征向量。∎

**要点**：继承是单向的——$\varphi$ 可以把不同的特征值黏到同一个值上，信息只减不增（这正是最小多项式要「计账」的对象）。
:::
:::

::: ex B17 · 重写定理 3.5.5（不看正文）{#ex-B17}

独立证明最小多项式的两条性质：(1) $m_A$ 唯一、整除 $A$ 的任一零化多项式（特别地 $m_A\mid f_A$）；(2) $f_A$ 与 $m_A$ 同根（不计重数）。

::: sol 解答

**(1) 存在性**（备查）：$f_A$ 零化 $A$（H–C，[@thm-3.5.4]），故零化多项式之族非空，取次数最小者再除以首项系数（仍零化、次数不变）得首一的最小者 $m_A$。

**整除**：设 $g$ 任一零化多项式。带余除法（[@thm-2.1.3]）：$g=qm_A+r$，$\deg r<\deg m_A$ 或 $r=0$。代入矩阵并注意同一矩阵的多项式可交换：

$$O=g(A)=q(A)\underbrace{m_A(A)}_{=O}+r(A)\ \Longrightarrow\ r(A)=O .$$

若 $r\neq0$，则 $r$（除以首项系数后首一）是次数**更低**的零化多项式，与最小性矛盾。故 $r=0$，$m_A\mid g$；取 $g=f_A$ 得 $m_A\mid f_A$。

**唯一**：若 $m_1,m_2$ 都是最小的首一零化多项式，则 $m_1\mid m_2$ 且 $m_2\mid m_1$；两者同次（都最小）且首一，故 $m_1=m_2$（互相整除的同次首一多项式只能相差 $1$ 倍）。

**(2) 同根**：「$m_A$ 的根 $\subseteq f_A$ 的根」：$m_A\mid f_A$，根只会少不会多。「$f_A$ 的根 $\subseteq m_A$ 的根」：设 $\lambda_0$ 是 $A$ 的特征值，取特征向量 $\boldsymbol{\alpha}\neq\boldsymbol{0}$。由注 4（B16 的 (a)）：

$$\boldsymbol{0}=m_A(A)\boldsymbol{\alpha}=m_A(\lambda_0)\boldsymbol{\alpha}\ \Longrightarrow\ m_A(\lambda_0)=0 .\qquad\blacksquare$$

**一处易错**：不能用「$f_A(A)=O\Rightarrow f_A=m_A$」——零化多项式有无数个（注 5），$f_A$ 只是其中之一；同根但重数可以差（$I_2$：$f_A=(\lambda-1)^2$，$m_A=\lambda-1$）。
:::
:::

::: ex B18 · 重写定理 3.6.2（正规 $\iff$ 酉对角化）{#ex-B18}

证明：复方阵 $A$ 正规（$A^{\mathrm H}A=AA^{\mathrm H}$）当且仅当存在酉矩阵 $U$ 使 $U^{\mathrm H}AU$ 为对角阵。

::: hint 提示

（$\Rightarrow$）对 $A$ 作 Schur 分解，证明上三角正规阵必为对角阵（比较第一行与第一列的长度）；（$\Leftarrow$）直接把 $A=U\Lambda U^{\mathrm H}$ 代进 $A^{\mathrm H}A$ 与 $AA^{\mathrm H}$。
:::

::: sol 解答

**（$\Rightarrow$）** 由 [@thm-3.5.2]，存在酉 $U$ 使 $T=U^{\mathrm H}AU$ 上三角。正规性在酉相似下不变：

$$T^{\mathrm H}T=U^{\mathrm H}A^{\mathrm H}UU^{\mathrm H}AU=U^{\mathrm H}A^{\mathrm H}AU,\qquad
TT^{\mathrm H}=U^{\mathrm H}AA^{\mathrm H}U,$$

故 $T^{\mathrm H}T=TT^{\mathrm H}$。下面证明上三角正规阵 $T$ 必对角：比较 $(1,1)$ 元，

$$(T^{\mathrm H}T)_{11}=|t_{11}|^2,\qquad (TT^{\mathrm H})_{11}=\sum_{k=1}^{n}|t_{1k}|^2,$$

故 $t_{12}=\cdots=t_{1n}=0$。于是 $T=\operatorname{diag}(t_{11},T')$，$T'$ 为上三角正规阵；对 $T'$ 归纳，得 $T$ 对角。

**（$\Leftarrow$）** 若 $A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}$，则

$$A^{\mathrm H}A=U\operatorname{diag}(|\lambda_1|^2,\cdots,|\lambda_n|^2)U^{\mathrm H}=AA^{\mathrm H}.$$

故 $A$ 正规。∎
:::
:::

::: ex B19 · 实正规矩阵：实特征值 $\Rightarrow$ 对称 {#ex-B19}

(a) 设 $A$ 是实正规矩阵，且全部特征值为实数，证明 $A$ 是实对称矩阵。(b) 用旋转阵说明：实正规矩阵不一定对称。

::: sol 解答

**(a)** 由 [@thm-3.6.2]，存在酉 $U$ 使 $A=U\Lambda U^{\mathrm H}$，$\Lambda=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$ 且 $\lambda_i\in\mathbb R$。于是

$$A^{\mathrm H}=U\Lambda^{\mathrm H}U^{\mathrm H}=U\Lambda U^{\mathrm H}=A.$$

又 $A$ 实，$A^{\mathrm H}=A^{\mathrm T}$，故 $A^{\mathrm T}=A$，即 $A$ 实对称。

**(b)** $R=\begin{bmatrix}0&-1\\1&0\end{bmatrix}$ 实正规（$R^{\mathrm T}R=I=RR^{\mathrm T}$），特征值 $\pm\mathrm i$ 不是实数，故不能由 (a) 推出对称；事实上 $R^{\mathrm T}=-R\ne R$。它的酉对角化需要复矩阵 $U$（[@note-3.6-rotation]），不存在实正交 $Q$ 使 $Q^{\mathrm T}RQ$ 为实对角阵。∎

**要点**：实正规矩阵在正交相似下的基本块只有两类——实特征值给出 $1\times1$ 块（特征值全实时整体对称），共轭复特征值给出 $2\times2$ 的「旋转–缩放」块（如 $\begin{bmatrix}a&-b\\b&a\end{bmatrix}$，特征值 $a\pm\mathrm ib$）。这正是 [@ex-3.6.C] 的几何读法；$2\times2$ 时就是「分两类」，$n>2$ 时要按块分解来读。
:::
:::

::: ex B20 · 谱分解驱动的逆、指数与酉性 {#ex-B20}

设单纯矩阵 $A$ 的谱分解为 $A=\sum_{j=1}^{m}\lambda_jE_j$。证明：

(a) $A$ 可逆 $\iff$ $0$ 不是特征值；此时 $A^{-1}=\sum_j\lambda_j^{-1}E_j$；

(b) $e^{At}=\sum_j e^{\lambda_jt}E_j$ 满足 $\frac{d}{dt}e^{At}=Ae^{At}$ 且 $e^{A\cdot0}=I$；

(c) 若 $A$ 正规且所有特征值都是纯虚数，则对一切 $t\in\mathbb R$，$e^{At}$ 是酉矩阵。

::: sol 解答

**(a)** $\det A=\prod_j\lambda_j^{d_j}$（[@thm-eig-trace]），故 $A$ 可逆 $\iff$ 每个 $\lambda_j\ne0$。此时令 $B=\sum_j\lambda_j^{-1}E_j$，用 $E_iE_j=\delta_{ij}E_i$：

$$AB=\Big(\sum_i\lambda_iE_i\Big)\Big(\sum_j\lambda_j^{-1}E_j\Big)=\sum_jE_j=I.$$

方阵单侧逆即逆，故 $B=A^{-1}$。

**(b)** 逐项求导（有限和）：

$$\frac{d}{dt}e^{At}=\sum_j\lambda_je^{\lambda_jt}E_j
=A\sum_je^{\lambda_jt}E_j=Ae^{At},$$

且 $t=0$ 时 $\sum_jE_j=I$。由一阶线性 ODE 解的唯一性，这就是 $e^{At}$（也说明 $e^{At}$ 与 $A$ 可交换）。

**(c)** 正规时 $E_j^{\mathrm H}=E_j$（[@prop-3.7.2]）；$\lambda_j=\mathrm i\omega_j$（$\omega_j\in\mathbb R$），故 $\overline{e^{\lambda_jt}}=e^{-\mathrm i\omega_jt}=e^{-\lambda_jt}$。于是

$$(e^{At})^{\mathrm H}e^{At}=\Big(\sum_i e^{-\lambda_it}E_i\Big)\Big(\sum_j e^{\lambda_jt}E_j\Big)=\sum_jE_j=I,$$

故 $e^{At}$ 是酉矩阵。∎

**读法**：这条把 [3.6.4](sec36.md#ex-3.6.4) 的「对角化解耦」升级成「谱分解演算」；也解释了为什么纯虚谱的线性系统（如无阻尼振动、量子演化）保持能量 / 范数。
:::
:::

::: ex B21 · 幂等阵的空间分解与伴随 {#ex-B21}

设 $E\in\mathbb C^{n\times n}$ 满足 $E^2=E$，$r=\operatorname{rank}E$。证明：

(a) $\mathbb C^n=R(E)\oplus N(E)$，且 $N(E)=R(I-E)$；

(b) $E\boldsymbol x=\boldsymbol x\iff\boldsymbol x\in R(E)$；

(c) $E$ 的伴随矩阵 $E^*$ 也是幂等阵。

::: sol 解答

**(a)** 对任意 $\boldsymbol x$，$\boldsymbol x=E\boldsymbol x+(I-E)\boldsymbol x$，第一项属于 $R(E)$，第二项属于 $R(I-E)$，故 $\mathbb C^n=R(E)+R(I-E)$。又 $E\boldsymbol x=\boldsymbol 0\iff\boldsymbol x=(I-E)\boldsymbol x$，故 $N(E)=R(I-E)$。若 $\boldsymbol y\in R(E)\cap N(E)$，写 $\boldsymbol y=E\boldsymbol x$，则

$$\boldsymbol y=E\boldsymbol x=E^2\boldsymbol x=E(E\boldsymbol x)=E\boldsymbol y=\boldsymbol 0.$$

故和是直和。

**(b)** 若 $E\boldsymbol x=\boldsymbol x$，则 $\boldsymbol x$ 是 $E$ 的像，故 $\boldsymbol x\in R(E)$。反之若 $\boldsymbol x=E\boldsymbol y$，则 $E\boldsymbol x=E^2\boldsymbol y=E\boldsymbol y=\boldsymbol x$。

**(c)** 幂等阵可对角化，特征值为 $1$（$r$ 个）与 $0$（$n-r$ 个）。分三种情形：$r=n$ 时 $E=I$，$E^*=I$；$r\le n-2$ 时所有 $n-1$ 阶子式为 $0$，$E^*=O$；$r=n-1$ 时 $E^*$ 秩一，且由 $EE^*=(\det E)I=O$ 与 $\operatorname{tr}E^*=1$ 得 $(E^*)^2=E^*$（细节见 [@note-3.7-adjugate-idempotent]）。三种情形都幂等。∎

**要点**：$E^2=E$ 的几何内容就是「沿 $N(E)$ 投到 $R(E)$」；(a) 是直和分解，(b) 是不动点性质。若再加 $E^{\mathrm H}=E$，则 $R(E)\perp N(E)$，投影升级为正交投影（[@note-3.7-orth-proj]）。
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

::: ex C17 · GS 手算 QR 分解（$2\times2$）{#ex-C17}

求 $A=\begin{bmatrix}2&1\\ 1&2\end{bmatrix}$ 的 QR 分解（$Q$ 正交、$R$ 正线上三角），并回代验证。

::: hint 提示

照 [@thm-3.4.1] 存在性证明的流程：先正交化得 $\boldsymbol{y}_k$，对角元取 $\|\boldsymbol{y}_k\|$（残差的范数，不是 $\|\boldsymbol{a}_k\|$），非对角元取 $(\boldsymbol{a}_k,\boldsymbol{z}_i)$。
:::

::: sol 解答

$\det A=3\neq0$，满秩 ✓。$\boldsymbol{a}_1=(2,1)^{\mathrm T}$、$\boldsymbol{a}_2=(1,2)^{\mathrm T}$。

**GS**：$\|\boldsymbol{y}_1\|=\|\boldsymbol{a}_1\|=\sqrt5$，$\boldsymbol{z}_1=\tfrac{1}{\sqrt5}(2,1)^{\mathrm T}$；$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{4}{\sqrt5}$，

$$\boldsymbol{y}_2=\boldsymbol{a}_2-\tfrac{4}{\sqrt5}\boldsymbol{z}_1=(1,2)^{\mathrm T}-\tfrac45(2,1)^{\mathrm T}=\left(-\tfrac35,\ \tfrac65\right)^{\mathrm T},\qquad
\|\boldsymbol{y}_2\|=\frac{3}{\sqrt5},\quad \boldsymbol{z}_2=\frac{1}{\sqrt5}(-1,2)^{\mathrm T}.$$

**拼装**：

$$Q=\frac{1}{\sqrt5}\begin{bmatrix}2&-1\\ 1&2\end{bmatrix},\qquad R=\begin{bmatrix}\sqrt5&\tfrac{4}{\sqrt5}\\ 0&\tfrac{3}{\sqrt5}\end{bmatrix}.$$

**验算**：$QR=\begin{bmatrix}2&\tfrac85-\tfrac35\\ 1&\tfrac45+\tfrac65\end{bmatrix}=\begin{bmatrix}2&1\\ 1&2\end{bmatrix}=A$ ✓；$Q^{\mathrm T}Q=I$ ✓、$\det Q=\tfrac{4+1}{5}=1$（这又是一个 Givens 旋转，$Q=\begin{bmatrix}\cos\theta&-\sin\theta\\\sin\theta&\cos\theta\end{bmatrix}$，$\cos\theta=\tfrac2{\sqrt5}$——对称矩阵的 QR 因子常常「长得好看」）。∎
:::
:::

::: ex C18 · 长方阵的完全 QR 分解（推论 3.4.1 实操）{#ex-C18}

设 $B=\begin{bmatrix}1&0\\ 0&1\\ 1&1\end{bmatrix}$。(a) 求 $B=Q_1R_1$（$Q_1$ 列正交规范、$R_1$ 正线上三角）；(b) 补齐 $\mathbb C^3$ 的标准正交基，写出 $B=QR$（$Q$ 酉、$R=\begin{bmatrix}R_1\\O\end{bmatrix}$），并验证 $Q^{\mathrm H}Q=I_3$。

::: sol 解答

**(a)** $\boldsymbol{a}_1=(1,0,1)^{\mathrm T}$：$\|\boldsymbol{a}_1\|=\sqrt2$，$\boldsymbol{z}_1=\tfrac{1}{\sqrt2}(1,0,1)^{\mathrm T}$。$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{1}{\sqrt2}$（$\boldsymbol{a}_2=(0,1,1)^{\mathrm T}$）：

$$\boldsymbol{y}_2=\boldsymbol{a}_2-\tfrac12(1,0,1)^{\mathrm T}=\left(-\tfrac12,\ 1,\ \tfrac12\right)^{\mathrm T},\qquad
\|\boldsymbol{y}_2\|=\frac{\sqrt6}{2},\quad \boldsymbol{z}_2=\frac{1}{\sqrt6}(-1,2,1)^{\mathrm T}.$$

$$Q_1=\begin{bmatrix}\tfrac{1}{\sqrt2}&-\tfrac{1}{\sqrt6}\\ 0&\tfrac{2}{\sqrt6}\\ \tfrac{1}{\sqrt2}&\tfrac{1}{\sqrt6}\end{bmatrix},\qquad
R_1=\begin{bmatrix}\sqrt2&\tfrac{1}{\sqrt2}\\ 0&\tfrac{\sqrt6}{2}\end{bmatrix},\qquad
Q_1^{\mathrm H}Q_1=I_2\ \checkmark$$

验算 $Q_1R_1$：第一列 $\sqrt2\boldsymbol{z}_1=(1,0,1)^{\mathrm T}$ ✓；第二列 $\tfrac{1}{\sqrt2}\boldsymbol{z}_1+\tfrac{\sqrt6}2\boldsymbol{z}_2=(\tfrac12,0,\tfrac12)^{\mathrm T}+(-\tfrac12,1,\tfrac12)^{\mathrm T}=(0,1,1)^{\mathrm T}$ ✓。

**(b)** 取 $\boldsymbol{z}_3$ 同时垂直于 $\boldsymbol{z}_1\parallel(1,0,1)$ 与 $\boldsymbol{z}_2\parallel(-1,2,1)$：叉积 $(1,0,1)\times(-1,2,1)=(-2,-2,2)$，单位化得 $\boldsymbol{z}_3=\tfrac{1}{\sqrt3}(1,1,-1)^{\mathrm T}$（两两内积为零 ✓）。于是

$$Q=\begin{bmatrix}\tfrac{1}{\sqrt2}&-\tfrac{1}{\sqrt6}&\tfrac{1}{\sqrt3}\\ 0&\tfrac{2}{\sqrt6}&\tfrac{1}{\sqrt3}\\ \tfrac{1}{\sqrt2}&\tfrac{1}{\sqrt6}&-\tfrac{1}{\sqrt3}\end{bmatrix}\ (\text{酉})，\qquad
B=Q\begin{bmatrix}\sqrt2&\tfrac{1}{\sqrt2}\\ 0&\tfrac{\sqrt6}{2}\\ 0&0\end{bmatrix}\ \checkmark$$

$Q^{\mathrm H}Q=I_3$ 逐列验算 ✓。∎
:::
:::

::: ex C19 · 高次幂的两条路 {#ex-C19}

设 $A=\begin{bmatrix}4&-1\\ 2&1\end{bmatrix}$。(a) 求 $f_A(\lambda)$；(b) 用 H–C 定理把 $A^{10}$ 写成 $A$ 的**一次**多项式并算出显式结果；(c) 该矩阵可对角化吗？用对角化路复核 (b) 的系数。

::: sol 解答

**(a)** $\operatorname{tr}A=5$、$\det A=6$，$f_A(\lambda)=\lambda^2-5\lambda+6=(\lambda-2)(\lambda-3)$。

**(b)** H–C：$A^2=5A-6I$，故 $A^{10}=\alpha A+\beta I$。在特征值处定系数（$h(\lambda)=\lambda^{10}-\alpha\lambda-\beta$ 在 $2,3$ 处为零 $\Rightarrow f_A\mid h\Rightarrow h(A)=O$）：

$$2^{10}=2\alpha+\beta,\qquad 3^{10}=3\alpha+\beta\ \Longrightarrow\ \alpha=3^{10}-2^{10}=58025,\quad \beta=2^{11}-3^{10}=-115026 .$$

$$A^{10}=58025\,A-115026\,I=\begin{bmatrix}4\times58025-115026&-58025\\ 2\times58025&58025-115026\end{bmatrix}
=\begin{bmatrix}117074&-58025\\ 116050&-57001\end{bmatrix}.$$

（本编数值复核：与双精度 $A^{10}$ 逐位一致 ✓。）

**(c)** $f_A$ 无重根 $\Rightarrow$ 可对角化（[@thm-eig-independent]）：$\lambda=2$ 时 $(A-2I)\boldsymbol{x}=\boldsymbol{0}$ 给 $\boldsymbol{p}_1=(1,2)^{\mathrm T}$；$\lambda=3$ 给 $\boldsymbol{p}_2=(1,1)^{\mathrm T}$。$P=[\boldsymbol{p}_1,\boldsymbol{p}_2]$，$P^{-1}AP=\operatorname{diag}(2,3)$，$A^{10}=P\operatorname{diag}(2^{10},3^{10})P^{-1}$。系数复核：$\alpha,\beta$ 满足的方程组正是「$\lambda^m=\alpha\lambda+\beta$ 在 $\lambda=2,3$ 处成立」，两条路的定系数步骤相同——对角化路把 $P$ 显式算出来，H–C 路根本不需要 $P$（且对不可对角化的矩阵照用，见 [@ex-3.5.2]）。∎
:::
:::

::: ex C20 · 带余除法与最小多项式算 $A^4$ {#ex-C20}

设 $A=\begin{bmatrix}1&1&0\\ 0&1&0\\ 0&0&-1\end{bmatrix}$。(a) 求 $f_A$ 与 $m_A$；(b) 用「除以 $m_A$」计算 $A^4$；(c) 直接计算 $A^4$ 核对。

::: sol 解答

**(a)** 分块三角：$f_A(\lambda)=(\lambda-1)^2(\lambda+1)$。候选 $(\lambda-1)(\lambda+1)$、$(\lambda-1)^2(\lambda+1)$。试低次：$(A-I)(A+I)=\begin{bmatrix}0&2&0\\0&0&0\\0&0&0\end{bmatrix}\neq O$，落选；故 $m_A=(\lambda-1)^2(\lambda+1)=f_A$。

**(b)** $\lambda^4=m_A\cdot(\lambda+1)+\big(2\lambda^2-1\big)$（验算：$(\lambda-1)^2(\lambda+1)^2+2\lambda^2-1=(\lambda^2-1)^2+2\lambda^2-1=\lambda^4$ ✓）。故

$$A^4=m_A(A)(A+I)+2A^2-I=2A^2-I .$$

**(c)** $A^2=\begin{bmatrix}1&2&0\\0&1&0\\0&0&1\end{bmatrix}$（$(-1)^2=1$），故 $A^4=2A^2-I=\begin{bmatrix}1&4&0\\0&1&0\\0&0&1\end{bmatrix}$。直接核对：$A^4=(A^2)^2$，上三角块 $\begin{bmatrix}1&2\\0&1\end{bmatrix}^2=\begin{bmatrix}1&4\\0&1\end{bmatrix}$ ✓，右下 $(−1)^4=1$ ✓。∎
:::
:::

::: ex C21 · 候选法求最小多项式（低次落选型）{#ex-C21}

求 $A=\begin{bmatrix}2&1&0\\ 0&2&1\\ 0&0&4\end{bmatrix}$ 的最小多项式。

::: sol 解答

$f_A(\lambda)=(\lambda-2)^2(\lambda-4)$（上三角，对角 $2,2,4$）。候选：$(\lambda-2)(\lambda-4)$ 与 $(\lambda-2)^2(\lambda-4)$。

**试低次**：$A-2I=\begin{bmatrix}0&1&0\\0&0&1\\0&0&2\end{bmatrix}$，$A-4I=\begin{bmatrix}-2&1&0\\0&-2&1\\0&0&0\end{bmatrix}$。乘积第一行 $=A-2I$ 第一行 $(0,1,0)$ 乘开 $=A-4I$ 的第二行 $=(0,-2,1)\neq\boldsymbol{0}$——落选。

**试高次**：$(A-2I)^2=\begin{bmatrix}0&0&1\\0&0&2\\0&0&4\end{bmatrix}$，$(A-2I)^2(A-4I)$ 的每一行都是 $(0,0,*)$ 乘 $A-4I$（第三行为零行），故 $=O$ ✓。

$$m_A(\lambda)=(\lambda-2)^2(\lambda-4).$$

**读法**：$\lambda=2$ 的特征子空间 $N(A-2I)$ 由 $\boldsymbol{e}_1$ 张成（解方程得 $x_2=x_3=0$），几何重数 $1<$ 代数重数 $2$（[@thm-geom-mult]）——最小多项式里 $(\lambda-2)$ 必须带平方，与 [@ex-3.5.B] 同型。∎
:::
:::

::: ex C22 · QR 迭代手算三轮（分数精确）{#ex-C22}

对 $A=\begin{bmatrix}2&1\\ 1&2\end{bmatrix}$（即 [@ex-C17]）执行 QR 算法三轮：写出 $A_2$、$A_3$（精确分数）与 $A_4$（四位小数），观察对角元向何值收敛、非对角元衰减多快。

::: sol 解答

**第一轮**：$A_1=Q_1R_1$ 用 [@ex-C17] 的结果，$A_2=R_1Q_1$：

$$A_2=\begin{bmatrix}\sqrt5&\tfrac{4}{\sqrt5}\\0&\tfrac{3}{\sqrt5}\end{bmatrix}\cdot\frac{1}{\sqrt5}\begin{bmatrix}2&-1\\1&2\end{bmatrix}
=\begin{bmatrix}\tfrac{14}{5}&\tfrac35\\ \tfrac35&\tfrac65\end{bmatrix}
=\begin{bmatrix}2.8&0.6\\ 0.6&1.2\end{bmatrix}.$$

**第二轮**：对 $A_2$ 再 GS（$\boldsymbol{z}_1=\tfrac1{\sqrt{205}}(14,3)^{\mathrm T}$，$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{12}{\sqrt{205}}$，$\boldsymbol{y}_2\parallel(-3,14)^{\mathrm T}$、$\|\boldsymbol{y}_2\|=\tfrac{3\sqrt{205}}{41}$）：

$$Q_2=\frac{1}{\sqrt{205}}\begin{bmatrix}14&-3\\ 3&14\end{bmatrix},\qquad
R_2=\begin{bmatrix}\tfrac{\sqrt{205}}{5}&\tfrac{12}{\sqrt{205}}\\ 0&\tfrac{3\sqrt{205}}{41}\end{bmatrix},\qquad
A_3=R_2Q_2=\begin{bmatrix}\tfrac{122}{41}&\tfrac9{41}\\ \tfrac9{41}&\tfrac{42}{41}\end{bmatrix}
\approx\begin{bmatrix}2.9756&0.2195\\ 0.2195&1.0244\end{bmatrix}.$$

**第三轮**（数值）：$A_4\approx\begin{bmatrix}2.9973&-0.0740\\ -0.0740&1.0027\end{bmatrix}$。

**观察**：特征值精确解 $3,1$（$f_A=(\lambda-3)(\lambda-1)$，本例对称正定、简单正谱且初始主分量非零，满足相应收敛条件）。对角元 $2.8\to2.976\to2.997\to3$、$1.2\to1.024\to1.003\to1$（按模从大到小排定 ✓）；非对角元 $0.6\to0.22\to0.074$——每轮约缩小到三分之一（收敛率由相邻特征值模比 $\tfrac{|\lambda_2|}{|\lambda_1|}=\tfrac13$ 决定，本编注）。∎
:::
:::

::: ex C23 · 用推论 3.5.2 求逆 {#ex-C23}

设 $A=\begin{bmatrix}1&2&0\\ 0&1&0\\ 0&0&2\end{bmatrix}$。(a) 求 $f_A(\lambda)$；(b) 用逆矩阵公式求 $A^{-1}$；(c) 回代验证。

::: sol 解答

**(a)** 上三角：$f_A(\lambda)=(\lambda-1)^2(\lambda-2)=\lambda^3-4\lambda^2+5\lambda-2$。

**(b)** $n=3$，$a_2=-4$、$a_1=5$、$a_0=-2\neq0$（$\det A=2$，$(-1)^3\det A=-2$ ✓）：

$$A^{-1}=-\frac{1}{a_0}\big(A^2+a_2A+a_1I\big)=\frac12\big(A^2-4A+5I\big).$$

$A^2=\begin{bmatrix}1&4&0\\0&1&0\\0&0&4\end{bmatrix}$，故

$$A^2-4A+5I=\begin{bmatrix}2&-4&0\\0&2&0\\0&0&1\end{bmatrix},\qquad
A^{-1}=\begin{bmatrix}1&-2&0\\ 0&1&0\\ 0&0&\tfrac12\end{bmatrix}.$$

**(c)** $AA^{-1}=\begin{bmatrix}1&2&0\\0&1&0\\0&0&2\end{bmatrix}\begin{bmatrix}1&-2&0\\0&1&0\\0&0&\frac12\end{bmatrix}=\begin{bmatrix}1&-2+2&0\\0&1&0\\0&0&1\end{bmatrix}=I$ ✓。∎
:::
:::

::: ex C24 · 最小多项式与矩阵多项式综合 {#ex-C24}

设 $A=\begin{bmatrix}4&1&0\\ 0&4&0\\ 0&0&2\end{bmatrix}$。(a) 求 $f_A$ 与 $m_A$；(b) 用 $m_A$ 计算 $A^3$；(c) 直接乘 $A^3$ 核对。

::: sol 解答

**(a)** $f_A(\lambda)=(\lambda-4)^2(\lambda-2)$。试低次 $(\lambda-4)(\lambda-2)$：$(A-4I)(A-2I)$ 的第一行 $=A-4I$ 第一行 $(0,1,0)$ 乘开 $=A-2I$ 第二行 $=(0,2,0)\neq\boldsymbol{0}$，落选（$\lambda=4$ 的几何重数 $1<2$，同 [@ex-3.5.B] 型）。故 $m_A=(\lambda-4)^2(\lambda-2)=f_A$。

**(b)** $\lambda^3=m_A\cdot1+\big(10\lambda^2-32\lambda+32\big)$（验算：$(\lambda-4)^2(\lambda-2)=\lambda^3-10\lambda^2+32\lambda-32$，$\lambda^3-(\lambda^3-10\lambda^2+32\lambda-32)=10\lambda^2-32\lambda+32$ ✓）。故

$$A^3=10A^2-32A+32I .$$

**(c)** $A^2=\begin{bmatrix}16&8&0\\0&16&0\\0&0&4\end{bmatrix}$，$10A^2-32A+32I=\begin{bmatrix}160-128+32&80-32&0\\0&160-128+32&0\\0&0&40-64+32\end{bmatrix}=\begin{bmatrix}64&48&0\\0&64&0\\0&0&8\end{bmatrix}$。直接核对：$\begin{bmatrix}4&1\\0&4\end{bmatrix}^3=\begin{bmatrix}64&48\\0&64\end{bmatrix}$（超对角元 $3\times4^2=48$ ✓）、$2^3=8$ ✓。∎
:::
:::

::: ex C25 · 两个矩阵：一个不可对角化，一个可 {#ex-C25}

判断下列矩阵是否可对角化；可对角化的求出 $P$ 与 $\Lambda$，并回代验算。

(a) $A_1=\begin{bmatrix}2&1&0\\ 0&2&0\\ 0&0&3\end{bmatrix}$；

(b) $A_2=\begin{bmatrix}1&1&0\\ 0&2&0\\ 0&0&2\end{bmatrix}$。

::: sol 解答

**(a)** $f_{A_1}(\lambda)=(\lambda-2)^2(\lambda-3)$。对 $\lambda=2$：

$$A_1-2I=\begin{bmatrix}0&1&0\\ 0&0&0\\ 0&0&1\end{bmatrix},\qquad \operatorname{rank}(A_1-2I)=2,$$

故几何重数 $g_2=3-2=1<d_2=2$——由 [@thm-3.6.1]（3），$A_1$ **不可对角化**。直观：$\lambda=2$ 只有一个特征向量 $(1,0,0)^{\mathrm T}$，Jordan 块长度 $2$。

**(b)** $f_{A_2}(\lambda)=(\lambda-1)(\lambda-2)^2$。对 $\lambda=2$：

$$A_2-2I=\begin{bmatrix}-1&1&0\\ 0&0&0\\ 0&0&0\end{bmatrix},\qquad \operatorname{rank}(A_2-2I)=1,$$

故 $g_2=3-1=2=d_2$；$\lambda=1$ 单重，$g_1=1$。所有 $g_i=d_i$，$A_2$ **可对角化**。

**求 $P$**：$\lambda=1$ 的特征向量 $(1,0,0)^{\mathrm T}$；$\lambda=2$ 的特征向量取 $(1,1,0)^{\mathrm T}$、$(0,0,1)^{\mathrm T}$。令

$$P=\begin{bmatrix}1&1&0\\ 0&1&0\\ 0&0&1\end{bmatrix},\qquad
P^{-1}=\begin{bmatrix}1&-1&0\\ 0&1&0\\ 0&0&1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(1,2,2).$$

**验算**：

$$P^{-1}A_2P=\begin{bmatrix}1&-1&0\\0&1&0\\0&0&1\end{bmatrix}\begin{bmatrix}1&1&0\\0&2&0\\0&0&2\end{bmatrix}\begin{bmatrix}1&1&0\\0&1&0\\0&0&1\end{bmatrix}
=\begin{bmatrix}1&0&0\\0&2&0\\0&0&2\end{bmatrix}=\Lambda\ \checkmark$$

（也可直接验 $A_2\boldsymbol p_i=\lambda_i\boldsymbol p_i$。）∎
:::
:::

::: ex C26 · 实对称矩阵的正交对角化与高次幂 {#ex-C26}

设 $A=\begin{bmatrix}2&1&1\\ 1&2&1\\ 1&1&2\end{bmatrix}$。

(a) 求正交矩阵 $Q$ 使 $Q^{\mathrm T}AQ=\Lambda$；

(b) 用 (a) 求 $A^{10}$。

::: sol 解答

**(a)** $A=I_3+J$，其中 $J$ 是元素全为 $1$ 的矩阵。$J$ 的特征值为 $3$（特征向量 $(1,1,1)^{\mathrm T}$）与 $0$（二重，特征子空间 $x_1+x_2+x_3=0$），故 $A$ 的特征值为

$$\lambda_1=4,\qquad \lambda_2=\lambda_3=1.$$

$\lambda=4$ 的单位特征向量 $\boldsymbol u_1=\tfrac{1}{\sqrt3}(1,1,1)^{\mathrm T}$；$\lambda=1$ 的特征子空间内取正交基

$$\boldsymbol u_2=\tfrac{1}{\sqrt2}(1,-1,0)^{\mathrm T},\qquad
\boldsymbol u_3=\tfrac{1}{\sqrt6}(1,1,-2)^{\mathrm T}.$$

（验算：$\boldsymbol u_2^{\mathrm T}\boldsymbol u_3=\tfrac{1}{\sqrt{12}}(1-1+0)=0$ ✓。）令 $Q=[\boldsymbol u_1,\boldsymbol u_2,\boldsymbol u_3]$，则 $Q^{\mathrm T}Q=I_3$ 且

$$Q^{\mathrm T}AQ=\operatorname{diag}(4,1,1).$$

**(b)** 由 $A=I+J$ 与 $J^2=3J$，归纳得

$$(I+J)^m=I+\frac{4^m-1}{3}J.$$

（验算：$m=1$ 时右边 $=I+J$ ✓；$(I+\alpha J)(I+J)=I+(1+\alpha)J+\alpha J^2=I+(1+4\alpha)J$，系数递推 $\alpha_{m+1}=1+4\alpha_m$，解出 $\alpha_m=(4^m-1)/3$ ✓。）当 $m=10$：

$$A^{10}=I+\frac{4^{10}-1}{3}J=I+349525\,J
=\begin{bmatrix}349526&349525&349525\\ 349525&349526&349525\\ 349525&349525&349526\end{bmatrix}.$$

（$4^{10}=1048576$，$(1048576-1)/3=349525$。也可由 $A^{10}=Q\operatorname{diag}(4^{10},1,1)Q^{\mathrm T}$ 得到同一结果；本编双精度复核一致。）∎
:::
:::

::: ex C27 · 由特征值与部分特征向量反求实对称矩阵 {#ex-C27}

设 $A$ 是 $3$ 阶实对称矩阵，特征值为 $2,5,5$。已知 $\boldsymbol x_1=(1,1,0)^{\mathrm T}$ 是属于 $2$ 的特征向量，$\boldsymbol x_2=(1,-1,2)^{\mathrm T}$ 是属于 $5$ 的特征向量。求 $A$。

::: sol 解答

**第一步：补第三个特征向量。** $A$ 实对称，属于 $5$ 的特征子空间是 $\boldsymbol x_1$ 的正交补（因为不同特征值的特征向量正交），且是二维的；$\boldsymbol x_2$ 已在其中。取 $\boldsymbol x_3$ 与 $\boldsymbol x_1,\boldsymbol x_2$ 都正交：

$$\boldsymbol x_3=\boldsymbol x_1\times\boldsymbol x_2=(1\cdot2-0\cdot(-1),\ 0\cdot1-1\cdot2,\ 1\cdot(-1)-1\cdot1)^{\mathrm T}=(2,-2,-2)^{\mathrm T}\sim(1,-1,-1)^{\mathrm T}.$$

（验算：$\boldsymbol x_3^{\mathrm T}\boldsymbol x_1=1-1+0=0$、$\boldsymbol x_3^{\mathrm T}\boldsymbol x_2=1+1-2=0$ ✓。）

**第二步：拼 $P$ 与 $\Lambda$。** 取

$$P=[\boldsymbol x_1,\boldsymbol x_2,\boldsymbol x_3]=\begin{bmatrix}1&1&1\\ 1&-1&-1\\ 0&2&-1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(2,5,5).$$

（列序 $\boldsymbol x_1,\boldsymbol x_2,\boldsymbol x_3$ 对应 $2,5,5$。）

**第三步：求逆并乘开。**

$$P^{-1}=\begin{bmatrix}\tfrac12&\tfrac12&0\\[2pt] \tfrac16&-\tfrac16&\tfrac13\\[2pt] \tfrac13&-\tfrac13&-\tfrac13\end{bmatrix},$$

$$A=P\Lambda P^{-1}=\begin{bmatrix}\tfrac72&-\tfrac32&0\\[2pt] -\tfrac32&\tfrac72&0\\[2pt] 0&0&5\end{bmatrix}.$$

**验算**：$A\boldsymbol x_1=(2,2,0)^{\mathrm T}=2\boldsymbol x_1$ ✓；$A\boldsymbol x_2=(5,-5,10)^{\mathrm T}=5\boldsymbol x_2$ ✓；$A\boldsymbol x_3=(5,-5,-5)^{\mathrm T}=5\boldsymbol x_3$ ✓；$A^{\mathrm T}=A$ ✓。∎

**要点**：$\boldsymbol x_2$ 属于 $5$、$\boldsymbol x_1$ 属于 $2$，两者自动正交（$1-1+0=0$）——这是实对称性的「免费正交」。第三个向量不能随便取，必须在 $\boldsymbol x_1$ 的正交补里再与 $\boldsymbol x_2$ 正交，否则 $P^{-1}AP$ 不是对角阵。
:::
:::

::: ex C28 · 非正规单纯矩阵的谱分解与高次幂 {#ex-C28}

设 $A=\begin{bmatrix}1&1&0\\ 0&2&0\\ 0&0&2\end{bmatrix}$（[@ex-C25]（b））。

(a) 求 $A$ 的谱分解 $A=\lambda_1E_1+\lambda_2E_2$；

(b) 验算谱阵五性质；

(c) 用谱分解求 $A^{10}$，并与直接计算核对。

::: sol 解答

**(a) 对角化**：由 [@ex-C25]（b），

$$P=\begin{bmatrix}1&1&0\\ 0&1&0\\ 0&0&1\end{bmatrix},\qquad
P^{-1}=\begin{bmatrix}1&-1&0\\ 0&1&0\\ 0&0&1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(1,2,2).$$

把 $P$ 按列读成 $\boldsymbol\alpha_1=(1,0,0)^{\mathrm T}$、$\boldsymbol\alpha_2=(1,1,0)^{\mathrm T}$、$\boldsymbol\alpha_3=(0,0,1)^{\mathrm T}$；把 $P^{-1}$ 按行读成 $\boldsymbol\beta_1^{\mathrm H}=(1,-1,0)$、$\boldsymbol\beta_2^{\mathrm H}=(0,1,0)$、$\boldsymbol\beta_3^{\mathrm H}=(0,0,1)$。按特征值分组：$\lambda_1=1$ 只有一项，$\lambda_2=2$ 有两项：

$$E_1=\boldsymbol\alpha_1\boldsymbol\beta_1^{\mathrm H}
=\begin{bmatrix}1&-1&0\\ 0&0&0\\ 0&0&0\end{bmatrix},$$

$$E_2=\boldsymbol\alpha_2\boldsymbol\beta_2^{\mathrm H}+\boldsymbol\alpha_3\boldsymbol\beta_3^{\mathrm H}
=\begin{bmatrix}0&1&0\\ 0&1&0\\ 0&0&0\end{bmatrix}+\begin{bmatrix}0&0&0\\ 0&0&0\\ 0&0&1\end{bmatrix}
=\begin{bmatrix}0&1&0\\ 0&1&0\\ 0&0&1\end{bmatrix}.$$

故

$$A=1\cdot E_1+2\cdot E_2.$$

**(b) 验算**：

$$E_1+E_2=I_3,\qquad E_1E_2=O,\qquad E_1^2=E_1,\ E_2^2=E_2,$$

$$AE_1=E_1,\qquad AE_2=2E_2.$$

（逐项：$E_1+E_2=\begin{bmatrix}1&0&0\\0&1&0\\0&0&1\end{bmatrix}$ ✓；$E_1E_2$ 的第一行 $(1,-1,0)$ 乘 $E_2$ 的三列分别得 $0$ ✓；$E_1^2=E_1$ 因 $\boldsymbol\beta_1^{\mathrm H}\boldsymbol\alpha_1=1$ ✓。）注意 $E_1,E_2$ **不是**对称阵（$E_1^{\mathrm T}\ne E_1$），因为 $A$ 不是正规矩阵——这是 [@prop-3.7.1] 而非 [@prop-3.7.2] 的情形。

**(c) 求幂**：由 [@thm-3.7.1]，

$$A^{10}=1^{10}E_1+2^{10}E_2=E_1+1024E_2
=\begin{bmatrix}1&1023&0\\ 0&1024&0\\ 0&0&1024\end{bmatrix}.$$

**直接核对**：$A$ 是上三角，$A^{10}$ 的对角元为 $1^{10},2^{10},2^{10}$；超对角元 $(1,2)$ 为 $\sum_{k=0}^{9}1^k\cdot1\cdot2^{9-k}=2^{10}-1=1023$（等比级数），其余超对角元为 $0$。逐位一致 ✓。∎
:::
:::

::: ex C29 · 正交投影矩阵与最小二乘 {#ex-C29}

设

$$A=\begin{bmatrix}1&0\\0&1\\1&1\end{bmatrix},\qquad \boldsymbol b=\begin{bmatrix}1\\1\\1\end{bmatrix}.$$

(a) 求到 $R(A)$ 的正交投影矩阵 $E$，并验证 $E^{\mathrm T}=E$、$E^2=E$；

(b) 求 $\boldsymbol b$ 在 $R(A)$ 上的投影 $E\boldsymbol b$，并验残差与 $R(A)$ 正交；

(c) 解最小二乘问题 $\min\|A\boldsymbol x-\boldsymbol b\|$，核对 $A\boldsymbol x=E\boldsymbol b$。

::: sol 解答

**(a)** 

$$A^{\mathrm T}A=\begin{bmatrix}2&1\\1&2\end{bmatrix},\qquad
(A^{\mathrm T}A)^{-1}=\frac13\begin{bmatrix}2&-1\\-1&2\end{bmatrix},$$

故

$$E=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}
=\frac13\begin{bmatrix}2&-1&1\\-1&2&1\\1&1&2\end{bmatrix}.$$

$E^{\mathrm T}=E$ 显然。直接乘：

$$E^2=\frac19\begin{bmatrix}2&-1&1\\-1&2&1\\1&1&2\end{bmatrix}^2
=\frac19\cdot3\begin{bmatrix}2&-1&1\\-1&2&1\\1&1&2\end{bmatrix}=E.$$

（也可用 $A^{\mathrm T}A$ 消去中间项，见 [@ex-3.7.3]。）$\operatorname{tr}E=2=\operatorname{rank}E$ ✓。

**(b)** 

$$E\boldsymbol b=\frac13\begin{bmatrix}2-1+1\\-1+2+1\\1+1+2\end{bmatrix}
=\frac13\begin{bmatrix}2\\2\\4\end{bmatrix}
=\begin{bmatrix}\tfrac23\\[2pt]\tfrac23\\[2pt]\tfrac43\end{bmatrix}.$$

残差

$$\boldsymbol b-E\boldsymbol b=\frac13\begin{bmatrix}1\\1\\-1\end{bmatrix},$$

与 $A$ 的两列都正交：

$$\frac13\big(1\cdot1+1\cdot0+(-1)\cdot1\big)=0,\qquad
\frac13\big(1\cdot0+1\cdot1+(-1)\cdot1\big)=0. \checkmark$$

**(c)** 法方程：

$$A^{\mathrm T}A\boldsymbol x=A^{\mathrm T}\boldsymbol b
\Longrightarrow
\begin{bmatrix}2&1\\1&2\end{bmatrix}\begin{bmatrix}x_1\\x_2\end{bmatrix}
=\begin{bmatrix}2\\2\end{bmatrix}.$$

解

$$\boldsymbol x=\frac13\begin{bmatrix}2&-1\\-1&2\end{bmatrix}\begin{bmatrix}2\\2\end{bmatrix}
=\begin{bmatrix}\tfrac23\\[2pt]\tfrac23\end{bmatrix}.$$

于是

$$A\boldsymbol x=\begin{bmatrix}1&0\\0&1\\1&1\end{bmatrix}\begin{bmatrix}\tfrac23\\[2pt]\tfrac23\end{bmatrix}
=\begin{bmatrix}\tfrac23\\[2pt]\tfrac23\\[2pt]\tfrac43\end{bmatrix}=E\boldsymbol b\ \checkmark$$

最小残差范数 $\|\boldsymbol b-A\boldsymbol x\|=\sqrt{1/9+1/9+1/9}=1/\sqrt3$。∎

**要点**：投影矩阵的分母是 $A^{\mathrm T}A$（$2\times2$），不是 $A^{\mathrm T}$；最小二乘的解由法方程给出，拟合值一定等于投影 $E\boldsymbol b$。两者是同一件事的两种写法。
:::
:::

::: ex C30 · $\lambda$ 矩阵的秩、可逆性与求逆 {#ex-C30}

(a) 设

$$A(\lambda)=\begin{bmatrix}\lambda&1&0\\0&\lambda&1\\1&0&\lambda\end{bmatrix}.$$

求 $\det A(\lambda)$、$\operatorname{rank}A(\lambda)$，并判断是否可逆。

(b) 设

$$B(\lambda)=\begin{bmatrix}1&\lambda&0\\0&2&1\\0&0&1\end{bmatrix}.$$

判断是否可逆；若可逆，求 $B(\lambda)^{-1}$ 并验算。

::: sol 解答

**(a)** 按第一行展开：

$$\det A(\lambda)=\lambda(\lambda^2-0)-1(0\cdot\lambda-1\cdot1)+0=\lambda^3+1.$$

这是首一三次多项式，不恒为零，故 $\operatorname{rank}A(\lambda)=3$（满秩）。但它**不是非零常数**，故由 [@thm-3.8.1] $A(\lambda)$ **不可逆**。代入 $\lambda=-1$ 时 $\det=0$，这只是「逐点数值秩」降为 $2$，不改变 $\lambda$ 矩阵的秩为 $3$（[@note-3.8-pointwise]）。

**(b)** $\det B(\lambda)=1\cdot2\cdot1=2$，是非零常数，故 $B(\lambda)$ 可逆。设 $B(\lambda)\boldsymbol x=\boldsymbol y$，回代：

$$x_3=y_3,\qquad 2x_2+x_3=y_2\Rightarrow x_2=\frac{y_2-y_3}{2},\qquad x_1+\lambda x_2=y_1\Rightarrow x_1=y_1-\frac{\lambda}{2}(y_2-y_3).$$

故

$$B(\lambda)^{-1}=
\begin{bmatrix}
1&-\tfrac\lambda2&\tfrac\lambda2\\[2pt]
0&\tfrac12&-\tfrac12\\[2pt]
0&0&1
\end{bmatrix}.$$

验算：

$$\begin{bmatrix}1&\lambda&0\\0&2&1\\0&0&1\end{bmatrix}
\begin{bmatrix}1&-\tfrac\lambda2&\tfrac\lambda2\\0&\tfrac12&-\tfrac12\\0&0&1\end{bmatrix}
=\begin{bmatrix}1&0&0\\0&1&0\\0&0&1\end{bmatrix}. \checkmark$$

**要点**：(a) 是「满秩但不可逆」的标准标本——行列式 $\lambda^3+1$ 非零但非常数；(b) 的行列式是常数 $2$，所以逆矩阵的元素仍是 $\lambda$ 的多项式（含 $-\lambda/2$，是多项式，不是 $1/\lambda$）。∎
:::
:::

::: ex C31 · 用初等变换化对角形 {#ex-C31}

用初等变换把下列 $\lambda$ 矩阵化成对角形，并写出每一步的变换类型：

(a) $\begin{bmatrix}\lambda&0\\0&\lambda+1\end{bmatrix}$；(b) $\begin{bmatrix}\lambda&1\\1&\lambda\end{bmatrix}$。

::: sol 解答

**(a)**

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

依次为：第 3 种（行）、第 3 种（列）、第 1 种、第 2 种（乘 $-1$）、第 3 种（列）、第 3 种（行）。乘子 $-\lambda$、$\lambda+1$ 都是多项式。

**(b)**

$$\begin{aligned}
\begin{bmatrix}\lambda&1\\1&\lambda\end{bmatrix}
&\xrightarrow{R_1\leftrightarrow R_2}
\begin{bmatrix}1&\lambda\\\lambda&1\end{bmatrix}
\xrightarrow{R_2-\lambda R_1}
\begin{bmatrix}1&\lambda\\0&1-\lambda^2\end{bmatrix}\\
&\xrightarrow{C_2-\lambda C_1}
\begin{bmatrix}1&0\\0&1-\lambda^2\end{bmatrix}
\xrightarrow{R_2\leftarrow -R_2}
\begin{bmatrix}1&0\\0&\lambda^2-1\end{bmatrix}.
\end{aligned}$$

依次为：第 1 种、第 3 种（行）、第 3 种（列）、第 2 种（乘 $-1$）。原矩阵 $\det=\lambda^2-1$，最终矩阵 $\det=\lambda^2-1$（交换行改变一次符号，最后乘 $-1$ 又改回来）。∎

**要点**：第三种变换的乘子可以是多项式，这正是 $\lambda$ 矩阵比数字矩阵「更灵活」的地方；但乘子不能是有理函数。最终对角形中 $d_1=1$ 整除 $d_2=\lambda(\lambda+1)$（或 $\lambda^2-1$），这就是 Smith 标准形的雏形（[3.8 下半](sec38b.md#thm-3.8.2)）。
:::
:::

::: ex C32 · Smith 标准形三连算 {#ex-C32}

求下列 $\lambda$ 矩阵的 Smith 标准形、不变因子与初等因子：

(a) $\begin{bmatrix}\lambda&1\\1&\lambda\end{bmatrix}$；(b) $\operatorname{diag}\big(\lambda(\lambda+1),\ (\lambda+1)^2,\ 0\big)$；(c) $\begin{bmatrix}\lambda-1&1&0\\0&\lambda-1&1\\0&0&\lambda-1\end{bmatrix}$。

::: sol 解答

**(a)** 已在 [@ex-C31] (b) 中化成 $\operatorname{diag}(1,\lambda^2-1)$。故 Smith 形为 $\operatorname{diag}(1,(\lambda-1)(\lambda+1))$，不变因子 $d_1=1$、$d_2=\lambda^2-1$，初等因子 $\lambda-1,\ \lambda+1$。

**验算**：$\det=\lambda^2-1=d_1d_2$ ✓；初等因子全一次 $\Rightarrow$ 该矩阵（作为某个 $A$ 的特征矩阵）对应的 $A$ 可对角化。

**(b)** 对角元是 $\lambda(\lambda+1)$、$(\lambda+1)^2$、$0$，秩为 $2$。检查整除链：$\lambda(\lambda+1)\mid(\lambda+1)^2$？**不**（缺因子 $\lambda$），故不是 Smith 形。算行列式因子：

- $D_1=\gcd\big(\lambda(\lambda+1),\ (\lambda+1)^2\big)=\lambda+1$（首 $1$ 化后）；
- $D_2=\lambda(\lambda+1)\cdot(\lambda+1)^2=\lambda(\lambda+1)^3$；
- $D_3=|A|=0$，但 $r=2$，不定义 $D_3$（见 [@note-3.8-d3-zero]）。

于是

$$d_1=D_1=\lambda+1,\qquad d_2=\frac{D_2}{D_1}=\lambda(\lambda+1)^2.$$

Smith 形 $\operatorname{diag}\big(\lambda+1,\ \lambda(\lambda+1)^2,\ 0\big)$，初等因子 $\lambda+1,\ \lambda,\ (\lambda+1)^2$（共三个：来自 $d_1$ 的 $\lambda+1$，来自 $d_2$ 的 $\lambda$ 与 $(\lambda+1)^2$）。

**验算**：$d_1d_2=\lambda(\lambda+1)^3=D_2$ ✓；$d_1\mid d_2$ ✓；秩 $2$ = 非零对角元个数 ✓。

**(c)** 这是 $J_3(1)$ 的特征矩阵。由 [例 3.8.5](sec38b.md#ex-3.8.5)（$a=1$、$n=3$），

$$D_1=D_2=1,\qquad D_3=(\lambda-1)^3.$$

故 $d_1=d_2=1$、$d_3=(\lambda-1)^3$，Smith 形 $\operatorname{diag}\big(1,1,(\lambda-1)^3\big)$，初等因子只有一个 $(\lambda-1)^3$。

**要点**：三小题的初等因子个数分别是 $2$、$3$、$1$，恰好对应「块数」。若把它们当作某个 $A$ 的特征矩阵，Jordan 块个数就是 $2$、$3$、$1$。∎
:::
:::

::: ex C33 · 由 Smith 形写 Jordan 形并求 $P$ {#ex-C33}

设 $A=\begin{bmatrix}2&1&1\\0&2&1\\0&0&3\end{bmatrix}$。

(a) 求 $\lambda I-A$ 的 Smith 标准形与初等因子；(b) 写出 $A$ 的 Jordan 标准形 $J$ 与最小多项式；(c) 求可逆 $P$ 使 $P^{-1}AP=J$。

::: sol 解答

**(a)** 上三角，$f_A=(\lambda-2)^2(\lambda-3)$。算行列式因子：

- $D_1=1$（元素中有 $1$）；
- $D_2$：$(1,2)$ 与 $(1,3)$ 位置都是 $1$，取第 $1,2$ 行第 $1,2$ 列得 $(\lambda-2)^2$，取第 $1,2$ 行第 $1,3$ 列得 $1\cdot 1-1\cdot 0=1$，故 $D_2=1$；
- $D_3=(\lambda-2)^2(\lambda-3)$。

于是

$$d_1=1,\quad d_2=1,\quad d_3=(\lambda-2)^2(\lambda-3).$$

Smith 形 $\operatorname{diag}\big(1,1,(\lambda-2)^2(\lambda-3)\big)$；初等因子 $(\lambda-2)^2$ 与 $\lambda-3$。

**(b)** 两个初等因子 $\Rightarrow$ 两个块：

$$J=\begin{bmatrix}2&1&0\\0&2&0\\0&0&3\end{bmatrix}=J_2(2)\oplus J_1(3),\qquad m_A=d_3=(\lambda-2)^2(\lambda-3).$$

**(c)** 记 $P=[\boldsymbol p_1,\boldsymbol p_2,\boldsymbol p_3]$，由 $AP=PJ$ 逐列读出

$$A\boldsymbol p_1=2\boldsymbol p_1,\qquad A\boldsymbol p_2=\boldsymbol p_1+2\boldsymbol p_2,\qquad A\boldsymbol p_3=3\boldsymbol p_3.$$

先解 $(A-2I)\boldsymbol p_1=\boldsymbol 0$：$A-2I=\begin{bmatrix}0&1&1\\0&0&1\\0&0&1\end{bmatrix}$，得 $\boldsymbol p_1=(1,0,0)^{\mathrm T}$。

再解 $(A-2I)\boldsymbol p_2=\boldsymbol p_1$：方程是 $p_{22}+p_{23}=1$、$p_{23}=0$、$p_{23}=0$，故 $p_{22}=1$、$p_{23}=0$，取 $\boldsymbol p_2=(0,1,0)^{\mathrm T}$。

最后解 $(A-3I)\boldsymbol p_3=\boldsymbol 0$：$A-3I=\begin{bmatrix}-1&1&1\\0&-1&1\\0&0&0\end{bmatrix}$，得 $\boldsymbol p_3=(2,1,1)^{\mathrm T}$。

$$P=\begin{bmatrix}1&0&2\\0&1&1\\0&0&1\end{bmatrix}.$$

**验算**：$\det P=1\ne0$；$A\boldsymbol p_1=(2,0,0)^{\mathrm T}=2\boldsymbol p_1$ ✓；$A\boldsymbol p_2=(1,2,0)^{\mathrm T}=\boldsymbol p_1+2\boldsymbol p_2$ ✓；$A\boldsymbol p_3=(6,3,3)^{\mathrm T}=3(2,1,1)^{\mathrm T}$ ✓。∎

**要点**：这里 $\boldsymbol p_1$ 恰好也在 $R(A-2I)$ 里（$R(A-2I)=\operatorname{span}\{(1,0,0)^{\mathrm T}\}$），链才接得上；若由 $(A-2I)\boldsymbol p_2=\boldsymbol p_1$ 解不出，就得换一个 $\boldsymbol p_1$——这正是 [@note-3.8-chain-rule] 的规则。
:::
:::

::: ex C34 · 用 Jordan 形算高次幂与矩阵指数 {#ex-C34}

设 $A=\begin{bmatrix}1&1&0\\0&1&1\\0&0&1\end{bmatrix}$。求 $A^{10}$ 与 $e^{At}$。

::: sol 解答

**拆成 $I+N$**：$A=I+N$，$N=\begin{bmatrix}0&1&0\\0&0&1\\0&0&0\end{bmatrix}$，$N^2=\begin{bmatrix}0&0&1\\0&0&0\\0&0&0\end{bmatrix}$，$N^3=O$。$I$ 与 $N$ 交换，二项式定理可用：

$$A^{m}=(I+N)^m=I+mN+\binom{m}{2}N^2
=\begin{bmatrix}1&m&\binom m2\\[2pt]0&1&m\\[2pt]0&0&1\end{bmatrix}.$$

取 $m=10$：

$$A^{10}=\begin{bmatrix}1&10&45\\0&1&10\\0&0&1\end{bmatrix}.$$

**矩阵指数**：

$$e^{At}=e^{It}e^{Nt}=e^{t}\left(I+tN+\frac{t^2}{2}N^2\right)
=e^{t}\begin{bmatrix}1&t&\tfrac{t^2}{2}\\[2pt]0&1&t\\[2pt]0&0&1\end{bmatrix}.$$

**验算（$m=2,3$）**：$A^2=I+2N+N^2=\begin{bmatrix}1&2&1\\0&1&2\\0&0&1\end{bmatrix}$；直接乘 $A\cdot A$ 得同一结果 ✓。$A^3=I+3N+3N^2=\begin{bmatrix}1&3&3\\0&1&3\\0&0&1\end{bmatrix}$，与 $\binom32=3$ 一致 ✓。∎

**要点**：$J_s(\lambda)$ 的幂与指数只依赖 $N$ 的幂零性；$t$ 的最高幂次为 $s-1$，这里 $s=3$，故 $e^{At}$ 的最高次项是 $t^2/2$（[@note-3.8-tkexp]）。
:::
:::

---

**依据**本课程第三章课件 3.1 相抵分解（15 页）、3.2 满秩分解（9 页）、3.4 QR 分解（16 页）、3.5 Schur 分解（22 页）、3.6 对角化分解（13 + 14 页）、3.7 谱分解（22 + 15 页）、3.8 Jordan 分解（50 页：上 14 + 下 36，后七份 PDF 存于 `_sources/matrix/`）整理 · 七节均无录播 · 整理日期 2026-10-22（3.8 下半 2026-10-27 续）· 新增例题与全部计算题均经回代验算（C19、C22 另做双精度复核；C25–C28 另用 SymPy 复核；C29–C34 由 `tools/verify_teaching_examples.py` 以有理数与多项式系数精确算术复算）· 3.3 与 3.9 及以后素材到位后本页续写。