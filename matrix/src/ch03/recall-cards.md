# 闭卷回忆卡 · 第三章：定义、定理与第一行

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

> **背不下来？先看[速查背记卡](../memory-sheet.md)。** 那一页把每个定义、定理压成一句「最小可背诵单元」；这一页负责检验你有没有真的记住。第一章与第二章的对应卡片在[第一章回忆卡](../ch01/recall-cards.md)与[第二章回忆卡](../ch02/recall-cards.md)。

::: note 想做成间隔复习
本页每张卡可以导出成 Anki 卡组——命令与导入步骤见[速查背记卡](../memory-sheet.md)文末「导出到 Anki」（脚本会一次解析三章回忆卡）。
:::

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记录三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 定义卡

### D1 · 相抵分解式与相抵标准形

写出分解式与标准形；「分解式不唯一」与「标准形唯一」各指什么？标准形由什么唯一决定？

::: sol D1 核对

$A=P^{-1}\Gamma Q$，$\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}_{m\times n}$（[@lem-3.1.1]）。不唯一：$P$、$Q$ 的取法无穷（同一分解上左乘吸收矩阵 $\begin{bmatrix}I_r&*\\0&I\end{bmatrix}$、右乘 $\begin{bmatrix}I_r&0\\*&I\end{bmatrix}$ 仍是分解，[@note-3.1-nonunique]）；唯一：中间的 $\Gamma$ 由**秩**唯一决定，同型矩阵相抵 $\iff$ 同秩（[@note-3.1-rank]）。两句话对象不同，别写反。
:::

### D2 · 右逆与左逆

各写出定义式；各自的充要条件是什么？方阵情形为什么合一？

::: sol D2 核对

$AB=I$ 称 $B$ 是 $A$ 的右逆；$BA=I$ 称左逆（[@thm-3.1.1]）。判别：$A$ 有右逆 $\iff$ $A$ **行满秩**；$A$ 有左逆 $\iff$ $A$ **列满秩**。方阵情形：单侧满秩 $=$ 双侧满秩（行数 $=$ 列数），故单侧逆即双侧逆即「可逆」。易错：长方阵的 $AB=I$ 不能推出 $BA=I$，也不能称 $B$ 为「逆」。
:::

### D3 · 满秩分解

写出分解式与 $B$、$C$ 的形状、秩；几何读法一句话是什么？$B$ 的列必须取自 $A$ 的列吗？

::: sol D3 核对

$A=BC$：$B\in\mathbb C^{m\times r}$ **列**满秩（列是 $R(A)$ 的一组基）、$C\in\mathbb C^{r\times n}$ **行**满秩（列是 $A$ 各列在该基下的坐标）（[@thm-3.2.1]）。读法：**$B$ 是骨架、$C$ 是图纸**。$B$ 不必取自 $A$ 的列——$A=I_2A$ 也是合法分解（[@note-3.2-columns]）。前提 $r>0$。
:::

### D4 · QR 分解

分别写出「酉三角分解」与「正交三角分解」的定义；「正线上三角阵」的「正线」指什么？不满秩方阵还有 QR 分解吗？

::: sol D4 核对

复方阵 $A=QR$（$Q$ 酉、$R$ 上三角）称 QR 分解 / 酉三角分解；实方阵时 $Q$ 正交称正交三角分解（[@def-3.4.1]）。正线 $=$ 对角元素全为**正实数**（[@thm-3.4.1] 首次使用）。不满秩**仍有**分解，丢的是唯一性——例 3.4.2 的 $R$ 出现零对角元、不再是正线（[@ex-3.4.2]）。
:::

### D5 · 列 / 行正交规范矩阵

写出定义；它与酉矩阵差在哪？它一定满秩吗？$QQ^{\mathrm H}$ 与 $I$ 的关系？

::: sol D5 核对

$Q^{\mathrm H}Q=I_n$（$Q\in\mathbb C^{m\times n}$，不必方阵）称列正交规范，$Q^{\mathrm H}$ 称行正交规范（[@def-3.4.2]）。酉矩阵要求**方阵**；$m>n$ 时 $QQ^{\mathrm H}\ne I_m$（差一个投影）。自动列满秩（列标准正交），且**保范** $\|Q\boldsymbol x\|=\|\boldsymbol x\|$；$Q^{\mathrm H}$ 是它的一个左逆。
:::

### D6 · 矩阵多项式

写出定义；容易漏的一处是什么？它与 $A$ 可交换吗？

::: sol D6 核对

$\varphi(\lambda)=\sum a_i\lambda^i$ 给定后，$\varphi(A)=a_nA^n+\cdots+a_1A+a_0I$（[@def-3.5.1]）。最容易漏：**常数项要补成 $a_0I$**。$\varphi(A)$ 是 $A$ 的多项式，故与 $A$ 可交换（$A\varphi(A)=\varphi(A)A$）——这是 H–C 证明里「因子按次序乘」的背景前提。
:::

### D7 · 零化多项式

定义是什么？一个矩阵的零化多项式有多少个？给出两个已知的零化多项式。

::: sol D7 核对

$g(A)=O$ 则 $g$ 是 $A$ 的零化多项式（[@def-3.5.2]）。有无穷多个：若 $g$ 零化，则任意 $gh$ 也零化（[$g(A)$ 与 $h(A)$ 可交换]）。两个现成成员：$f_A$（H–C 定理）与 $m_A$（本身）（[@note-3.5-annihil-many]）。
:::

### D8 · 最小多项式

写出定义（「最小」指什么、「首 1」指什么）；它与特征多项式的两项核心关系是什么？

::: sol D8 核对

零化多项式中**次数最小**的**首 1**（最高次项系数为 $1$）多项式，记 $m_A$（[@def-3.5.3]）。两项关系（[@thm-3.5.5]）：① $m_A$ **唯一**，且**整除**任何零化多项式——特别地 $m_A\mid f_A$；② $m_A$ 与 $f_A$ **根相同**（不计重数）。$m_A$ 的重数记「必要重数」：$I_2$ 的 $f_A=(\lambda-1)^2$ 而 $m_A=\lambda-1$。
:::

### D9 · 单纯矩阵

写出定义；它与 Schur 分解是什么关系？「单纯」是否等价于「有 $n$ 个互异特征值」？

::: sol D9 核对

$A$ 相似于对角阵：存在可逆 $P$ 使 $P^{-1}AP=\Lambda$（[@def-3.6.1]）。它是 Schur 分解 $U^{\mathrm H}AU=\Lambda_{\text{上三角}}$ 当上方 $\ast$ 全为零时的特例（[@note-3.6-schur-special]）。**不等价**：互异特征值只是充分条件（[@cor-3.6.1]），$I_n$ 只有一重特征值却已是对角阵。准确的充要条件是 [@thm-3.6.1] 的五条。
:::

### D10 · 酉相似对角化

写出定义；它等价于什么样的一组特征向量？与「相似对角化」差在哪？

::: sol D10 核对

存在**酉矩阵** $U$ 使 $U^{\mathrm H}AU=\Lambda$（[@def-3.6.2]）。等价说法：$A$ 有 $n$ 个特征向量构成 $\mathbb C^n$ 的**标准正交基**（把 $U$ 按列读出即得；反之拼起来即得 $U$）。与普通相似对角化的差别只在「$P$ 可逆」升级为「$U$ 酉」——几何上是从「任意基」升级为「标准正交基」，代价是 $A$ 必须正规（[@thm-3.6.2]）。
:::

### D11 · 正规矩阵

写出定义；举四个例子与一个反例；它与单纯矩阵的关系是什么？

::: sol D11 核对

$A^{\mathrm H}A=AA^{\mathrm H}$（[@def-3.6.3]）。四个例子：Hermite（$A^{\mathrm H}=A$）、反 Hermite（$A^{\mathrm H}=-A$）、酉矩阵（$A^{\mathrm H}A=I$）、正交矩阵（实酉矩阵）。反例：$\begin{bmatrix}1&1\\0&2\end{bmatrix}$ 可对角化但不正规（[@ex-3.6.C]）。关系：**正规 $\subset$ 单纯**；正规 $\iff$ 酉相似于对角阵（[@thm-3.6.2]），单纯只保证相似于对角阵。
:::

### D12 · 谱分解与谱阵

写出定义式；谱阵 $E_j$ 怎么从 $P$、$P^{-1}$ 读出来？它的几何意义是什么？

::: sol D12 核对

$A=\sum_{j=1}^{m}\lambda_jE_j$（[@def-3.7.1]）。把 $P$ 按**列**读成 $\boldsymbol\alpha_1,\cdots,\boldsymbol\alpha_n$、把 $P^{-1}$ 按**行**读成 $\boldsymbol\beta_1^{\mathrm H},\cdots,\boldsymbol\beta_n^{\mathrm H}$，则

$$E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H};$$

等价地 $E_j=P\operatorname{diag}(0,\cdots,1,\cdots,0)P^{-1}$（[@note-3.7-projector-identity]）。几何上 $E_j$ 是到特征子空间 $E(\lambda_j)$ 的投影（沿其余特征子空间的直和）；正规时还是**正交**投影（[@prop-3.7.2]）。
:::

### D13 · 幂等矩阵与正交投影

分别写出定义；两者差在哪？$E^2=E$ 时 $R(E)$ 与 $N(E)$ 有什么关系？

::: sol D13 核对

幂等：$E^2=E$（[@def-3.7.2]）；正交投影：$E^2=E=E^{\mathrm H}$（[@def-3.7.3]）。差别在 $E^{\mathrm H}=E$：幂等只保证 $\mathbb C^n=R(E)\oplus N(E)$、$E$ 沿 $N(E)$ 投到 $R(E)$；Hermite 再保证 $R(E)\perp N(E)$。幂等阵的特征值只能是 $0,1$，且 $\operatorname{rank}E=\operatorname{tr}E$（[@note-3.7-idempotent]）。
:::

## B. 定理卡

### T1 · 引理 3.1.1（相抵标准形存在性）

证明第一行怎么做（选基路线）？零空间的基与值域的基各排在哪里？

::: sol T1 核对

把 $A$ 读成映射 $T$，取**出发端**的一组基：核的基 $\boldsymbol\xi_1,\cdots,\boldsymbol\xi_{n-r}$ 排**前面**、扩充的向量 $\boldsymbol\xi_{n-r+1},\cdots,\boldsymbol\xi_n$ 排后面；它们的像 $f_i=T(\boldsymbol\xi_{n-r+i})$ 是 $R(T)$ 的基（无关性由表示唯一性逼出），扩充为**到达端**的基。两组基下矩阵恰为 $\Gamma$，换基公式收尾 $A=P^{-1}\Gamma Q$（[@lem-3.1.1]）。一句话：**「零空间的基排前、值域的基接后，让映射只剩骨架」**。
:::

### T2 · 定理 3.1.1（单侧逆判别）

陈述完整；两条充分性证明路线各是什么？「注 1」的三条存在性小结说了什么？

::: sol T2 核对

行满秩 $\iff$ 有右逆；列满秩 $\iff$ 有左逆（[@thm-3.1.1]）。路线：法 1 用相抵构造（从 $\Gamma$ 的竖条横条拼出单侧逆）；法 2 用闭式公式 $B=A^{\mathrm H}(AA^{\mathrm H})^{-1}$、$(A^{\mathrm H}A)^{-1}A^{\mathrm H}$。注 1：方阵时单侧即双侧（可逆）；满秩非方阵的单侧逆**不唯一**（通式 $B_0+Z$，$Z$ 每列属于对应的零空间）。必要性证明：$AB=I$ 时 $B$ 的列给出 $A$ 的行满秩结构（[@thm-3.1.1] 的左右逆两条，左逆必要性本编补）。
:::

### T3 · 命题 3.1.1（秩等式链）

写出四项链；证明第一行是什么（同解路线）？正定性用在哪一步？这条结论为什么叫「可逆性转换器」？

::: sol T3 核对

$\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})=\operatorname{rank}(A^{\mathrm H})$（[@prop-3.1.1]）。证明入口：证 $N(A)=N(A^{\mathrm H}A)$——「$\subseteq$」显然，「$\supseteq$」由 $A^{\mathrm H}A\boldsymbol x=\boldsymbol 0$ 左乘 $\boldsymbol x^{\mathrm H}$ 得 $(A\boldsymbol x,A\boldsymbol x)=0$，**正定性**逼出 $A\boldsymbol x=\boldsymbol 0$。用途：把长方阵的满秩问题转成方阵 $A^{\mathrm H}A$ 的可逆问题——单侧逆公式、伪逆、最小二乘都从它出发。
:::

### T4 · 定理 3.2.1（满秩分解）

两条构造路线各是什么？RREF 算法怎么取 $B$ 和 $C$？

::: sol T4 核对

$A=BC$ 存在，$B$ 列满秩、$C$ 行满秩（[@thm-3.2.1]）。构造法 1（相抵）：$A=P^{-1}\begin{bmatrix}I_r\\0\end{bmatrix}[I_r,0]Q$，取前 $r$ 列 / 前 $r$ 行；构造法 2（列空间基）：任取 $R(A)$ 的基拼成 $B$、坐标拼成 $C$——$\operatorname{rank}C=r$ 要两边夹（行数上界 $+$ $N(C)\subseteq N(A)$ 下界）。RREF 算法（[@method-3.2-rref]）：$B$ 取 $A$ 的**主元列**、$C$ 取 RREF 的**非零行**；原理是「行变换保持列间线性关系」。
:::

### T5 · 定理 3.2.2（满秩分解的唯一性）

陈述；证明的两步各是什么？$D$ 的身份是什么？

::: sol T5 核对

两种满秩分解相差一个**可逆**因子：$B_1=B_2D$、$C_1=D^{-1}C_2$（[@thm-3.2.2]）。证明第一步：$C_1$ 行满秩（满射）$\Rightarrow R(B_1)=R(B_1C_1)=R(A)$，同理 $R(B_2)=R(A)$——两组 $B$ 的列是**同一个子空间** $R(A)$ 的两组基；第二步：取过渡矩阵 $D$（必可逆），再由 $B_2(C_2-DC_1)=O$ 与 $B_2$ 列无关得 $C_2=DC_1$。$D$ 的身份：$R(A)$ 两组基之间的**过渡矩阵**（[@note-3.2.unique]：一个分解生成全部）。
:::

### T6 · 定理 3.4.1（QR 分解定理）

陈述（存在 + 唯一）；分析里的「$R$ 是过渡矩阵」指哪两组基之间？GS 给出的 $R$ 的元素公式是什么？

::: sol T6 核对

满秩复方阵存在酉阵 $Q$ 与正线上三角阵 $R$ 使 $A=QR$，且**唯一**（[@thm-3.4.1]）。读法：记 $A=[\boldsymbol a_1,\cdots,\boldsymbol a_n]$、$Q=[\boldsymbol z_1,\cdots,\boldsymbol z_n]$，则 $[\boldsymbol a_1,\cdots]=[\boldsymbol z_1,\cdots]R$——$R$ 是从 $\boldsymbol z$ 基到 $\boldsymbol a$ 基的**过渡矩阵**。GS 公式：对角元 $r_{kk}=\|\boldsymbol y_k\|$（**残差**的范数，不是 $\|\boldsymbol a_k\|$），上三角元 $r_{ik}=(\boldsymbol a_k,\boldsymbol z_i)$（$i<k$）。
:::

### T7 · QR 唯一性的证明与「不唯一的精确刻画」

唯一性证明的第一行怎么做？在哪一步用到「正线」？去掉正线后，任意两种分解相差什么？实方阵一共几种？

::: sol T7 核对

第一行：设 $A=Q_1R_1=Q_2R_2$，则 $W=Q_2^{\mathrm H}Q_1=R_2R_1^{-1}$（**满秩**保证 $R_i$ 可逆）——$W$ 双重身份：酉阵之积（酉）$+$ 上三角之积之逆（上三角）。引理：上三角 $\wedge$ 酉 $\Rightarrow$ 对角且 $|w_{ii}|=1$（逐列归纳）；**正线**在最后一步把 $w_{ii}=1$ 逼出来 $\Rightarrow W=I$。去正线后：任意两种分解相差一个**对角酉阵** $W=\operatorname{diag}(w_i)$、$|w_i|=1$；实方阵恰 $2^n$ 种（[@ex-3.4.1] 的 $I_2$ 两种即 $n=1$ 情形；[@ex-3.4.B] 给出完整四种）。
:::

### T8 · 推论 3.4.1（长方阵完全分解）

陈述；构造证明的三步；$R$ 的形状。

::: sol T8 核对

$A\in\mathbb C^{m\times n}_n$（列满秩，$n\le m$）可分解为 $A=UR$，$U$ 是 $m$ 阶酉阵、$R=\begin{bmatrix}R_1\\O\end{bmatrix}$ 上块为正线上三角（[@cor-3.4.1]）。三步：① GS 得 $A=Q_1R_1$（$Q_1$ 列正交规范）；② 基扩充把列补成标准正交基；③ 拼 $U=[\boldsymbol z_1,\cdots,\boldsymbol z_m]$，$U\begin{bmatrix}R_1\\O\end{bmatrix}=[\boldsymbol z_1,\cdots,\boldsymbol z_n]R_1=A$。要点：补齐时对**扩充后整组**重新 GS，前缀因「张成不变」原样保留。
:::

### T9 · QR 算法

写出迭代式与全文最重要的那条恒等式；收敛条件是什么（充分还是必要）？等模时会怎样，反例是什么？

::: sol T9 核对

$A_1=A$，$A_k=Q_kR_k$，$A_{k+1}=R_kQ_k$（[@method-qr-algo]）。关键恒等式：$A_{k+1}=Q_k^{\mathrm H}A_kQ_k$——**每步都是酉相似**，特征值全程不变；链式 $A_k=(Q_1\cdots Q_{k-1})^{\mathrm H}A(Q_1\cdots Q_{k-1})$。仅“特征值模互异”不保证整个矩阵收敛：$\begin{bmatrix}-1&1\\0&2\end{bmatrix}$ 的正线 QR 上三角元在 $1,-1$ 间交替。排序还取决于初始坐标旗标；$\operatorname{diag}(1,2)$ 不会自行交换顺序。实对称正定、简单正谱及适当初始分量可给出更强收敛结论，见 [@method-qr-algo]。等模也可能使子对角元不消失，例如正交旋转阵原地不动。
:::

### T10 · 定理 3.5.1（Schur 引理，相似版）

陈述；证明的归纳策略（每步吃掉什么）？对角元为何是特征值？

::: sol T10 核对

任意复方阵相似于上三角阵：$P^{-1}AP=\Lambda$，$\Lambda$ 对角元为特征值（[@thm-3.5.1]）。归纳：取特征值 $\lambda_1$ 与特征向量 $\boldsymbol x_1$（复方阵必有）$\to$ 扩充为基、相似变换得 $\begin{bmatrix}\lambda_1&\boldsymbol\beta\\\boldsymbol 0&A_1\end{bmatrix}$ $\to$ 对 $A_1$ 用归纳假设 $\to$ 分块对角拼收尾。对角元是特征值：分块三角行列式 $f_A=(\lambda-\lambda_1)f_{A_1}$ $+$ 相似不改特征多项式。对照注 1：**三角化人人有份，对角化不是**（[@note-3.5-diag]）。
:::

### T11 · 定理 3.5.2（Schur 引理，酉版）

陈述；证明只用了哪三行（对谁作 QR）？为什么它比定理 3.5.1「更便利」？

::: sol T11 核对

任意复方阵**酉**相似于上三角阵：$U^{\mathrm H}AU=\Lambda$（[@thm-3.5.2]）。证明：对定理 3.5.1 的可逆阵 $P$ 作 QR 分解 $P=UR$（$U$ 酉、$R$ 正线上三角）$\to$ 代入得 $U^{\mathrm H}AU=R\Lambda R^{-1}$ $\to$ 上三角对乘法、求逆封闭，右边仍上三角。便利之处（[@note-3.5-unitary-why]）：酉矩阵保范、条件数 1，数值稳定——可逆阵 $P$ 的列可以接近相关，酉阵不会。
:::

### T12 · 定理 3.5.3（实方阵 Schur 引理）

陈述前提；反例分析的三步（为什么实旋转阵不行）？注 3 的警告怎么复述？

::: sol T12 核对

实方阵且**特征值均为实数**时，存在正交阵 $Q$ 使 $Q^{\mathrm T}AQ$ 为上三角（[@thm-3.5.3]）。反例（[@note-3.5-real-warn]）：$A=\begin{bmatrix}0&-1\\1&0\end{bmatrix}$，$f_A=\lambda^2+1$，$\lambda=\pm\mathrm i$；若存在实正交 $Q$，则 $Q^{\mathrm T}AQ$ 必为**实**阵，实上三角阵的特征值（对角元）全实，与 $\pm\mathrm i$ 矛盾。警告：实阵的特征值不全是实数，处理实矩阵时**不要轻易套用复矩阵结论**——前提「特征值全实」不可丢。
:::

### T13 · 推论 3.5.1（谱映射）

陈述；证明的三行框架；注 4 的「继承」是单向还是双向？举例说明反向为什么失败。

::: sol T13 核对

$A$ 的特征值 $\lambda_i$ $\Rightarrow$ $\varphi(A)$ 的特征值为 $\varphi(\lambda_i)$，特别地 $A^m$ 的特征值为 $\lambda_i^m$（[@cor-3.5.1]）。证明：Schur 型 $A=U\Lambda U^{\mathrm H}$ $\to$ $\varphi(A)=U\left(\sum a_i\Lambda^i\right)U^{\mathrm H}$（上三角的幂仍是上三角，对角元取幂）$\to$ 相似不改特征值。注 4（[@note-3.5-eigvec]）：$A$ 的特征向量也是 $\varphi(A)$ 的（$A^k\boldsymbol\alpha=\lambda^k\boldsymbol\alpha$ 归纳）；**反向不成立**——$\varphi$ 会把不同特征值黏起来：$A=\operatorname{diag}(1,-1)$、$\varphi=\lambda^2$ 时 $\varphi(A)=I$，一切向量都是它的特征向量。
:::

### T14 · 定理 3.5.4（Hamilton–Cayley）

陈述；证明为什么不能只验「对角元全零」？正确的证明心脏是什么（次序 + 什么性质）？

::: sol T14 核对

$f_A(A)=O$（[@thm-3.5.4]）。只验对角元不够：**对角元全零的上三角阵可以非零**（反例 $\begin{bmatrix}0&1\\0&0\end{bmatrix}$，特征值全零却非零）。证明心脏：在 Schur 型 $\Lambda$ 上把 $f_A(\Lambda)=\prod_i(\Lambda-\lambda_iI)$ 的因子**按 $\lambda_1,\lambda_2,\cdots$ 的次序从右往左乘**，归纳证明第 $k$ 个部分积清掉前 $k$ 列——关键用到 $\Lambda$ **上三角**（$\Lambda\boldsymbol e_j$ 不漏到后面的分量）。$A$ 的情形由 $f_A(A)=Uf_A(\Lambda)U^{\mathrm H}$ 归结。
:::

### T15 · 推论 3.5.2（逆矩阵公式）

写出公式；$a_0$ 与可逆性什么关系？证明只有两行，第一行是什么？

::: sol T15 核对

$A^{-1}=-\dfrac{1}{a_0}\big(A^{n-1}+a_{n-1}A^{n-2}+\cdots+a_1I\big)$（[@cor-3.5.2]）。$a_0=f_A(0)=(-1)^n\det A$，故 **$a_0\ne0\iff A$ 可逆**。证明第一行：H–C 给出 $A^n+a_{n-1}A^{n-1}+\cdots+a_0I=O$，提取 $A$ 得 $A(\cdots)=-a_0I$，两边除以 $-a_0$。用途（[@ex-3.5.3]）：把求逆变成算多项式——例 3.5.3 双路验算（公式 $+$ 几何级数 $I+N+N^2+\cdots$）。
:::

### T16 · 定理 3.5.5（最小多项式的性质）与候选法

两条性质；证明「同根」的反方向用哪条工具？候选法的三步流程？

::: sol T16 核对

（1）$m_A$ 唯一、整除一切零化多项式（特别地 $m_A\mid f_A$）；（2）$f_A$ 与 $m_A$ 同根（不计重数）（[@thm-3.5.5]）。整除证明：带余除法 $g=qm_A+r$，代入得 $r(A)=O$，若 $r\ne0$ 违反最小性。同根反方向：$m_A(A)\boldsymbol\alpha=m_A(\lambda_0)\boldsymbol\alpha=\boldsymbol 0$，用**特征向量继承**（注 4）。候选法（[@method-minpoly]）：① 求 $f_A$ 并因式分解；② 列候选（每个根取重数 1 到 $d_j$，共 $\prod d_j$ 个）；③ **从低次到高次**逐个试 $g(A)=O$，第一个通过的即 $m_A$——次序不能反（低次通过则高次必通过）。
:::

### T17 · 定理 3.6.1（单纯矩阵的五条等价）

完整陈述五条；证明的「两条主干」分别是什么？（1）$\iff$（2）与（5）$\Rightarrow$（1）各用了什么构造？

::: sol T17 核对

（1）$A$ 单纯；（2）$A$ 有 $n$ 个线性无关特征向量；（3）$d_i=g_i$；（4）$\sum\dim E(\lambda_i)=n$；（5）$m_A$ 无重根（[@thm-3.6.1]）。第一条主干：（1）$\iff$（2）把 $P$ 按列读出特征向量；（2）$\iff$（4）用「不同特征值特征向量无关」数 $\sum g_i$；（3）$\iff$（4）用 $\sum d_i=n$ 与 $g_i\le d_i$。第二条主干：（1）$\Rightarrow$（5）在 $P\Lambda P^{-1}$ 上算 $g(A)$，得 $m_A=\prod_j(\lambda-\lambda_j)$；（5）$\Rightarrow$（1）构造 Lagrange 投影 $f_j=m_A/(\lambda-\lambda_j)$、$E_j=f_j(A)/f_j(\lambda_j)$，验证 $\sum E_j=I$、$E_iE_j=O$、$(A-\lambda_jI)E_j=O$，于是 $\mathbb C^n=\oplus E(\lambda_j)$。
:::

### T18 · 推论 3.6.1 / 3.6.2（两条判别口诀）

陈述两条推论；它们各自的反例是什么？「存在无重根零化多项式」到底是充分还是充要？

::: sol T18 核对

（a）$n$ 个互异特征值 $\Rightarrow$ 单纯；反之不然（$I_n$）（[@cor-3.6.1]）。（b）若**存在**无重根零化多项式 $g$，则单纯（[@cor-3.6.2]）。反例要分清：推论 3.6.2 若读成「单纯 $\Rightarrow$ 每个零化多项式无重根」，$I_2$ 的 $f_A=(\lambda-1)^2$ 是反例；但「存在」无重根零化多项式其实是**充要**的——取 $g=m_A$。注 3 的准确意思是：这两条是**便于验证的判别口诀**——3.6.1 只是充分，3.6.2 按字面是充要；真正要背的充要条件仍是 [@thm-3.6.1]（5）（[@note-3.6-sufficient]）。
:::

### T19 · Hermite / 实对称谱定理

陈述推论 3.6.3 与 3.6.4；证明的第一行（Schur 路线）是什么？反方向为什么只有一行？

::: sol T19 核对

Hermite $\iff$ 特征值全实且存在酉 $U$ 使 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_i)$（[@cor-3.6.3]）；实对称 $\iff$ 特征值全实且存在实正交 $Q$ 使 $Q^{\mathrm T}AQ=\operatorname{diag}(\lambda_i)$（[@cor-3.6.4]）。证明第一行：Schur 给 $U^{\mathrm H}AU=\Lambda$ 上三角，取共轭转置得 $U^{\mathrm H}A^{\mathrm H}U=\Lambda^{\mathrm H}$，$A=A^{\mathrm H}$ 推出 $\Lambda=\Lambda^{\mathrm H}$，故 $\Lambda$ 是实对角阵（[@ex-3.6.5]）。反方向：若 $A=U\Lambda U^{\mathrm H}$ 且 $\lambda_i$ 全实，则 $A^{\mathrm H}=U\Lambda^{\mathrm H}U^{\mathrm H}=U\Lambda U^{\mathrm H}=A$；实情形取转置即得对称。
:::

### T20 · 定理 3.6.2（正规 $\iff$ 酉对角化）

陈述；证明的两步各是什么？「上三角正规阵必为对角阵」怎么证？

::: sol T20 核对

$A^{\mathrm H}A=AA^{\mathrm H}$ $\iff$ 存在酉 $U$ 使 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_i)$（[@thm-3.6.2]）。两步：① 对 $A$ 作 Schur 分解 $T=U^{\mathrm H}AU$ 上三角；正规性在酉相似下不变（$T^{\mathrm H}T=U^{\mathrm H}A^{\mathrm H}AU=U^{\mathrm H}AA^{\mathrm H}U=TT^{\mathrm H}$），故 $T$ 正规。② 上三角正规阵必对角（[@lem-3.6.A]）：比较 $T^{\mathrm H}T$ 与 $TT^{\mathrm H}$ 的 $(1,1)$ 元，得 $|t_{11}|^2=\sum_k|t_{1k}|^2$，故第一行非对角元全零；对右下块归纳。反方向：$A=U\Lambda U^{\mathrm H}$ 时 $A^{\mathrm H}A=U|\Lambda|^2U^{\mathrm H}=AA^{\mathrm H}$。
:::

### T21 · 谱分解的存在与三步法

写出谱分解式；从 $P\Lambda P^{-1}$ 到 $\sum_j\lambda_jE_j$ 的三步是什么？$E_j$ 的秩是多少？

::: sol T21 核对

$A=\sum_{j=1}^{m}\lambda_jE_j$（[@def-3.7.1]）。三步（[@method-spectral]）：① 对角化 $A=P\Lambda P^{-1}$，$P$ 按列读 $\boldsymbol\alpha_i$、$P^{-1}$ 按行读 $\boldsymbol\beta_i^{\mathrm H}$；② 拆成 $A=\sum_i\lambda_i\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$；③ 按特征值分组 $E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$。关键恒等式 $\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_k=\delta_{ik}$（来自 $P^{-1}P=I$）。$\operatorname{rank}E_j=d_j$（[@note-3.7-rank]）。
:::

### T22 · 命题 3.7.1（谱阵五性质）

列出五条；唯一性怎么证？这五条为什么能刻画「投影」？

::: sol T22 核对

（1）$E_j^2=E_j$；（2）$E_iE_j=0$；（3）$E_iA=AE_i=\lambda_iE_i$；（4）$\sum E_k=I$；（5）谱阵集唯一（[@prop-3.7.1]）。唯一性：若另有 $F_j$ 满足（1）–（4），对 $f_i=\prod_{l\ne i}(\lambda-\lambda_l)$ 有 $f_i(A)=f_i(\lambda_i)F_i$；对 $E$ 族同样有 $f_i(A)=f_i(\lambda_i)E_i$，故 $F_i=E_i$。五条合起来说：$E_j$ 是一组两两正交的幂等元、和为 $I$、与 $A$ 交换且给出特征值 $\lambda_j$——这正是「沿其余特征子空间投到第 $j$ 个特征子空间」的代数刻画。
:::

### T23 · 定理 3.7.1 / 3.7.2（函数演算与 Lagrange 公式）

写出两个公式；各怎么证？为什么 $E_i$ 与 $P$ 的选取无关？

::: sol T23 核对

$f(A)=\sum_jf(\lambda_j)E_j$（[@thm-3.7.1]）；$E_i=f_i(A)/f_i(\lambda_i)$，$f_i=\prod_{l\ne i}(\lambda-\lambda_l)$（[@thm-3.7.2]）。前者：对单项式归纳 $A^k=\sum\lambda_j^kE_j$（用 $E_iE_j=\delta_{ij}E_i$、$\sum E_j=I$），再线性组合。后者：把 $f_i$ 代入前者，$f_i(\lambda_j)=0$（$j\ne i$），只剩 $f_i(\lambda_i)E_i$。$E_i$ 只由 $\lambda_j$ 与 $A$ 决定（公式里没有 $P$），故与 $P$ 的选取无关；这与命题 3.7.1（5）的唯一性一致。
:::

### T24 · 正规谱阵与正交投影

正规矩阵的谱阵为什么是正交投影？预解式 $(\lambda I-A)^{-1}$ 与 $E_j$ 有什么关系？

::: sol T24 核对

正规时 $A=U\Lambda U^{\mathrm H}$，按特征值分组得 $E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol u_i\boldsymbol u_i^{\mathrm H}$；每项 Hermite，求和仍 Hermite，故 $E_j^{\mathrm H}=E_j$；结合 $E_j^2=E_j$ 即正交投影（[@prop-3.7.2]）。几何：$E_j$ 是到 $E(\lambda_j)$ 的正交投影，$\mathbb C^n$ 被正交地拆成各特征子空间。预解式（[@note-3.7-resolvent]）：

$$(\lambda I-A)^{-1}=\sum_j\frac{E_j}{\lambda-\lambda_j},$$

它是部分分式分解，极点 $\lambda_j$、留数 $E_j$；令 $\lambda=0$ 得 $A^{-1}=-\sum_jE_j/\lambda_j$（$0\notin\sigma(A)$）。
:::

## C. 一张白纸的最终测试

在白纸中央写「矩阵分解」，闭卷画出下面这张全景图，并在每条箭头上写出「工具」与「唯一性」两个标注：

$$
\text{相抵}\ (A=P^{-1}\Gamma Q)
\longrightarrow \text{满秩}\ (A=BC)
\longrightarrow \text{QR}\ (A=QR/UR)
\longrightarrow \text{Schur}\ (U^{\mathrm H}AU=\Lambda)
\longrightarrow \text{对角化}\ (P^{-1}AP=\Lambda)
\longrightarrow \text{谱分解}\ (A=\textstyle\sum_j\lambda_jE_j).
$$

「工具」依次是：分块消元 → 选列空间基（RREF）→ GS 正交化（$+$ 基扩充）→ 对相似阵作 QR → 五条判据（求 $P$ / 正交化）→ 按特征值分组（读谱阵）。「唯一性」依次是：分解不唯一 / 标准形唯一 → 差可逆因子 $D$ → 正线唯一（去正线差对角酉阵）→ 对角元为特征值、顺序由 $U$ 定 → $P$ 可换、$\Lambda$ 的次序随 $P$ 换 → 谱阵 $E_j$ **唯一**（[@prop-3.7.1]（5））。

然后默写 T2、T4、T6、T9、T14、T16、T17、T20、T22、T24 十条定理。它们分别负责本章最常见的十类动作：**构造、分解、掰直、迭代、降次、记账、判定、升级、拆投影、算函数**。最后加试六问（对着[竞技场](arena.md)的必考点清单自评）：

① $r_{kk}$ 何时等于 $\|\boldsymbol a_k\|$？
② 去掉「正线」两个字，$I_2$ 有几种 QR 分解、复方阵有几种？
③ $f_A$ 与 $m_A$ 各自「记」什么——用 $I_2$ 和旋转阵各说一句？
④ 五条判据里哪条是充要？两条判别口诀各是什么逻辑地位（哪条只是充分、哪条按字面是充要）？各举一个反例说明「反过来不成立」。
⑤ 正规矩阵与单纯矩阵差在哪？举出「单纯但不正规」与「正规但不 Hermite」各一例。
⑥ 谱阵的 Lagrange 公式为什么与 $P$ 的选取无关？用一句话说清「谱阵唯一、$P$ 不唯一」。

六问全答对，本章才算「可以调用」。
