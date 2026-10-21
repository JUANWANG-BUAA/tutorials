# 3.6 对角化分解

[3.5](sec35.md) 的 Schur 引理把「对角化」放松成「三角化」：任何复方阵都酉相似于上三角阵，对角线上摆着全部特征值。注 1 同时提醒：**三角化人人有份，对角化不是**。本节回到那个更苛刻的问题——**什么样的矩阵真的能对角化？** 答案有五张面孔（[@thm-3.6.1]），分别从特征向量、重数、特征子空间与最小多项式四个角度刻画同一件事；其中「最小多项式无重根」这一条，把 [3.5.4](sec35.md#sec-3.5.4) 的记账工具直接变成了判别工具。

判据之后是两件「用处」：把 $A^m$ 压成 $P\Lambda^mP^{-1}$（[@ex-3.6.3]），把线性常微分方程组 $\dot{\boldsymbol x}=A\boldsymbol x$ 解耦成 $n$ 个独立的一元方程（[@ex-3.6.4]）。随后进入本节的后半程——**酉相似对角化**：把「可逆的 $P$」升级成「酉的 $U$」，代价是矩阵必须满足更强的条件。Hermite 矩阵与实对称矩阵先过关（[@ex-3.6.5]、[@ex-3.6.6]），完整的答案由**正规矩阵**给出（[@thm-3.6.2]）：$A^{\mathrm H}A=AA^{\mathrm H}$ 当且仅当 $A$ 酉相似于对角阵。这条定理是本章与第二章的汇合点：2.4 的特征值、2.5 的酉矩阵、3.5 的 Schur 型在此合流。

::: note 素材与说明（本节无录播）

本页依据课程第三章课件 **3.6 对角化分解** 整理，课件分两份：**3.6 对角化分解 1**（13 页）与 **3.6 对角化分解 2**（14 页），均存于本地归档 `_sources/matrix/`（文件名 `3.6-对角化分解1.pdf`、`3.6-对角化分解2.pdf`）。**本节无对应录播**，故不引用课堂口述与时间戳：课件的定义、定理、推论、注记与例题**照录并保留原编号**（定义 3.6.1–3.6.3、定理 3.6.1–3.6.2、推论 3.6.1–3.6.7、注 1–注 4、例 3.6.1–3.6.7）；课件省略的证明（定理 3.6.1 的五条等价、推论 3.6.3/3.6.4 的反方向、定理 3.6.2、推论 3.6.5）由本编补出并逐处标注「本编补」；例 3.6.7 课件 $P^{-1}$ 的一处符号笔误见[勘误与补注](errata.md)（E3.9），正文按正确值演算。本编新增例题用字母编号（[@ex-3.6.A]、[@ex-3.6.C]），新增引理用 3.6.A、3.6.B 编号（字母编号在节内与引理共用：3.6.B 已留给引理，故例题跳号为 3.6.A、3.6.C）。
:::

<a id="sec-3.6.1"></a>

## 3.6.1 单纯矩阵：五个等价刻画

先把名字定下来。课件给的定义与 [2.4](../ch02/sec24.md) 的「可对角化」是同一件事，只是换了一个更短的说法：

::: def 定义 3.6.1 · 单纯矩阵（可对角化矩阵） {#def-3.6.1}

若 $n$ 阶复方阵 $A$ 相似于对角阵 $\Lambda$，即存在 $n$ 阶可逆阵 $P$ 使得

$$P^{-1}AP=\Lambda,$$

则称矩阵 $A$ 为**可对角化矩阵**（或**单纯矩阵**）。
:::

::: note 注 1（课件原文）· 定义式就是分解式 {#note-3.6-schur-special}

单纯矩阵的定义式就是单纯矩阵的**对角化分解式**，它实际上是 **Schur 分解的一种特殊表达**。

（本编补一句对照：[3.5](sec35.md) 的 Schur 引理说 $U^{\mathrm H}AU=\Lambda$ 中的 $\Lambda$ 只能是上三角；当上三角阵的非对角元恰好全为零时，它就退化成对角阵——这正是「对角化」与「三角化」的差别。所以对角化不是另一套理论，而是 Schur 型的一个**退化特例**（上方的 $\ast$ 恰好全消）：Schur 保证「总可以三角化」，本节追问「什么时候上方的 $\ast$ 能全部消掉」。）
:::

课件的主题目把「能对角化」拆成五条，并宣布它们等价：

::: thm 定理 3.6.1 · 单纯矩阵的五个等价刻画 {#thm-3.6.1}

设矩阵 $A\in\mathbb C^{n\times n}$ 的全部互异特征根为 $\lambda_1,\cdots,\lambda_m$（$m\le n$），则以下命题等价：

（1）$A$ 是单纯矩阵；

（2）$A$ 有 $n$ 个线性无关的特征向量；

（3）特征值 $\lambda_i$（$i=1,\cdots,m$）的代数重数等于其几何重数；

（4）$\sum_{i=1}^{m}\dim E(\lambda_i)=n$；

（5）最小多项式 $m_A(\lambda)$ 无重根。
:::

（记号：$E(\lambda_i)$ 即 [2.4](../ch02/sec24.md) 的特征子空间 $V_{\lambda_i}=N(A-\lambda_iI)$（[@def-eigenspace]）；本节沿用课件的 $E(\lambda)$ 记法，两者是同一个对象。）

这五条不是五个定理，而是同一件事的五种说法。读法先摆清楚：

| 条目 | 说的是什么 | 怎么算 / 怎么查 |
|:--|:--|:--|
| （1） | 存在可逆 $P$ 把 $A$ 变成对角阵 | 直接构造 $P$，或验证 $P^{-1}AP=\Lambda$ |
| （2） | 特征向量「够用」——$n$ 个线性无关 | 解 $(A-\lambda I)\boldsymbol x=\boldsymbol 0$，数独立解 |
| （3） | 每个特征值的「方向数」追平「根数」 | 算 $g_i=n-\operatorname{rank}(A-\lambda_iI)$，与 $d_i$ 比 |
| （4） | 全部特征子空间的维数之和顶满 $n$ | 把各 $g_i$ 相加 |
| （5） | 最小多项式没有重根 | 用 [@method-minpoly] 求 $m_A$，看因式次数 |

其中（3）与（4）是同一件事的两种写法：$\sum_i d_i=n$ 恒成立，而 $g_i\le d_i$（[@thm-mult-ineq]），故「每个 $g_i=d_i$」与「$\sum_i g_i=n$」等价。（1）与（2）是同一件事的两种写法：$P$ 的列就是 $n$ 个线性无关的特征向量。真正需要单独证明的是（5）与它们的关系——它是唯一一条用**多项式**而不是用**向量**说话的判据。

::: proof 证明（课件未给，本编补：(1)–(4) 是同一件事的四种说法）

**（1）$\iff$（2）**：若 $P^{-1}AP=\Lambda=\operatorname{diag}(\mu_1,\cdots,\mu_n)$，则 $AP=P\Lambda$。把 $P$ 按列写成 $[\boldsymbol p_1,\cdots,\boldsymbol p_n]$，逐列读出 $A\boldsymbol p_i=\mu_i\boldsymbol p_i$；$P$ 可逆故各列线性无关，且每列非零——正好是 $n$ 个线性无关的特征向量。反过来，若 $\boldsymbol p_1,\cdots,\boldsymbol p_n$ 线性无关且 $A\boldsymbol p_i=\mu_i\boldsymbol p_i$，令 $P=[\boldsymbol p_1,\cdots,\boldsymbol p_n]$、$\Lambda=\operatorname{diag}(\mu_1,\cdots,\mu_n)$，则 $AP=P\Lambda$，左乘 $P^{-1}$ 即得 $P^{-1}AP=\Lambda$。

**（2）$\iff$（4）**：对每个 $\lambda_i$，取特征子空间 $E(\lambda_i)$ 的一组基，合起来共有 $\sum_i g_i$ 个向量。不同特征值的特征向量线性无关（[@thm-eig-independent]），同一特征子空间内的基当然无关，故这 $\sum_i g_i$ 个向量整体无关；它们又张成全部特征向量。于是「存在 $n$ 个线性无关的特征向量」当且仅当 $\sum_i g_i=n$——这正是（4）。

**（3）$\iff$（4）**：$\sum_i d_i=n$ 恒成立（特征多项式的次数），而每个 $g_i\le d_i$（[@thm-mult-ineq]）。于是

$$\sum_i g_i=n=\sum_i d_i\iff g_i=d_i\quad(\forall i).$$

两条合起来，（1）$\iff$（2）$\iff$（4）$\iff$（3）。
:::

真正有含量的是（5）。它把 [3.5.5](sec35.md#thm-3.5.5) 的「最小多项式与特征多项式同根、且整除一切零化多项式」变成了判别工具：**无重根**四个字，恰好对应「每个特征值只配一个因子」，也就对应「每个特征子空间都能顶满」。

::: proof 证明（课件未给，本编补：(1)$\iff$(5)，含一条 Lagrange 投影构造）

**（1）$\Rightarrow$（5）**：设 $A=P\Lambda P^{-1}$，$\Lambda=\operatorname{diag}(\mu_1,\cdots,\mu_n)$（$\mu_i$ 中允许重复）。对任意多项式 $g$，

$$g(A)=P\,g(\Lambda)\,P^{-1}=P\operatorname{diag}\big(g(\mu_1),\cdots,g(\mu_n)\big)P^{-1}.$$

故 $g(A)=O\iff g(\mu_i)=0$ 对每个 $i$ 成立 $\iff g(\lambda_j)=0$ 对每个**互异**特征值 $\lambda_j$ 成立。于是每个零化多项式都被

$$M(\lambda)=\prod_{j=1}^{m}(\lambda-\lambda_j)$$

整除，而 $M$ 本身零化 $A$（它在每个 $\lambda_j$ 处取零）。由最小多项式的「次数最小 $+$ 首一」定义（[3.5.3](sec35.md#def-3.5.3)），$m_A=M$；$M$ 的 $m$ 个根互异，故 $m_A$ 无重根。

**（5）$\Rightarrow$（1）**：设 $m_A$ 无重根。由 [@thm-3.5.5]，$m_A$ 与 $f_A$ 同根且 $m_A\mid f_A$，故

$$m_A(\lambda)=\prod_{j=1}^{m}(\lambda-\lambda_j).$$

令

$$f_j(\lambda)=\frac{m_A(\lambda)}{\lambda-\lambda_j}=\prod_{l\ne j}(\lambda-\lambda_l),\qquad
E_j=\frac{f_j(A)}{f_j(\lambda_j)}\quad(j=1,\cdots,m).$$

**第一步：$\sum_j E_j=I$。** 多项式 $h(\lambda)=\sum_{j=1}^{m}\dfrac{f_j(\lambda)}{f_j(\lambda_j)}-1$ 的次数不超过 $m-1$，却在 $\lambda_1,\cdots,\lambda_m$ 这 $m$ 个点处取零（代入 $\lambda=\lambda_i$ 时只有第 $i$ 项存活，且等于 $1$）。故 $h\equiv0$，即 $\sum_j f_j(\lambda)/f_j(\lambda_j)=1$ 恒成立；代入 $A$ 得 $\sum_j E_j=I$。

**第二步：$E_iE_j=O$（$i\ne j$）。** 乘积 $f_i(\lambda)f_j(\lambda)$ 含有 $m_A$ 的每一个因式（$i\ne j$ 时，$\lambda-\lambda_i$ 来自 $f_j$，$\lambda-\lambda_j$ 来自 $f_i$，其余因式两边都有），故被 $m_A$ 整除：$f_if_j=m_A\,q_{ij}$。代入 $A$：$f_i(A)f_j(A)=m_A(A)q_{ij}(A)=O$，于是 $E_iE_j=O$。

**第三步：$E_j$ 的列都是 $\lambda_j$ 的特征向量。** 因为

$$(A-\lambda_jI)f_j(A)=m_A(A)=O,$$

两边除以非零常数 $f_j(\lambda_j)$ 得 $(A-\lambda_jI)E_j=O$，即 $AE_j=\lambda_jE_j$。对任意 $\boldsymbol x$，$E_j\boldsymbol x$ 满足 $A(E_j\boldsymbol x)=\lambda_j(E_j\boldsymbol x)$——若 $E_j\boldsymbol x\ne\boldsymbol 0$，它就是属于 $\lambda_j$ 的特征向量。

**收尾**：对任意 $\boldsymbol x\in\mathbb C^n$，

$$\boldsymbol x=\Big(\sum_{j=1}^{m}E_j\Big)\boldsymbol x=\sum_{j=1}^{m}E_j\boldsymbol x,$$

右边每一项或为零、或为特征向量，故 $\boldsymbol x$ 是特征向量的线性组合；亦即 $\mathbb C^n=\sum_j E(\lambda_j)$。不同特征值的特征子空间交集为零（[@thm-eig-independent]），故这是直和，$\sum_j\dim E(\lambda_j)=n$，由（4）$\iff$（1）得 $A$ 可对角化。

**读法**：这组 $E_j$ 不是临时拼出来的辅助矩阵，它们正是 [3.7](sec37.md) 的**谱阵**——[3.7.2](sec37.md#thm-3.7.2) 会给出同一个公式 $E_j=f_j(A)/f_j(\lambda_j)$。换句话说，（5）$\Rightarrow$（1）的证明已经在「用投影多项式把空间拆成特征子空间的直和」；3.7 只是把这个构造正式命名为谱分解。
:::

::: note 本编注 · 第五条为什么是「判定神器」 {#note-3.6-minpoly-power}

五条判据里，（2）（3）（4）都要「解方程 / 算秩」，对 $n$ 较大的矩阵是实打实的计算；（5）则常常只要算一个多项式。更关键的是，**（5）是充要条件**。下面两条推论是两条便于上手的判别口诀，但它们的逻辑地位不同（这正是本节最容易混淆的地方，[@note-3.6-sufficient]）：

- 「有 $n$ 个互异特征值」$\Rightarrow$ 单纯，但反之不然（$I_n$ 只有一个特征值，却是对角阵）——这条**只是充分**；
- 「存在无重根的零化多项式」$\Rightarrow$ 单纯；反过来，单纯时取 $g=m_A$ 也确有这样一个多项式——所以按字面读，它其实是**充要**的。课件把它写成「充分」，是因为实际使用时 $g$ 往往是题目给出的那一个，不一定恰好等于 $m_A$。容易混淆的是「**每个**零化多项式都无重根」，那才是假的：$I_2$ 的 $f_A=(\lambda-1)^2$ 就是反例。
:::

先看课件的第一道例题。它同时演示了（5）与（3）两条路：

::: ex 例 3.6.1（课件原文）· 判断线性变换可否对角化 {#ex-3.6.1}

设线性变换 $T\in L(\mathbb R^3)$ 在 $\mathbb R^3$ 的基 $\boldsymbol\epsilon_1,\boldsymbol\epsilon_2,\boldsymbol\epsilon_3$ 下的矩阵为 $A$，即 $T[\boldsymbol\epsilon_1,\boldsymbol\epsilon_2,\boldsymbol\epsilon_3]=[\boldsymbol\epsilon_1,\boldsymbol\epsilon_2,\boldsymbol\epsilon_3]A$，其中

$$A=\begin{bmatrix}1&0&-2\\ 0&0&0\\ -2&0&4\end{bmatrix}.$$

问：线性变换 $T$ 可否对角化？

::: sol 解答（课件路线；两方法的补充验算由本编补）

**分析**：线性变换可否对角化，等价于它在**任意一组基**下的矩阵是否为单纯矩阵（相似不改可对角化性，[@thm-sim-invariants]）。故只需判断 $A$。

**特征多项式**：

$$f_A(\lambda)=\det(\lambda I-A)=\lambda^2(\lambda-5)$$

（快验：$\operatorname{tr}A=1+0+4=5=0+0+5$ ✓；$\det A=0$ ✓）。

**方法一（最小多项式）**：直接计算

$$A(A-5I)=O.$$

（逐行验算：$A-5I=\begin{bmatrix}-4&0&-2\\0&-5&0\\-2&0&-1\end{bmatrix}$，$A$ 的第一行 $(1,0,-2)$ 乘它得 $(0,0,0)$；第二行全零；第三行 $(-2,0,4)$ 乘它也得 $(0,0,0)$。）于是 $m_A\mid\lambda(\lambda-5)$。又 $A\ne O$（排除 $m_A=\lambda$）、$A\ne5I$（排除 $m_A=\lambda-5$），故

$$m_A(\lambda)=\lambda(\lambda-5).$$

两个根 $0,5$ 互异，$m_A$ 无重根；由 [@thm-3.6.1]（5）$\Rightarrow$（1），$A$ 是单纯矩阵，即 $T$ 可对角化。

（课件此步直接写「故 $m_A=\lambda(\lambda-5)$」，省略了排除 $\lambda$ 与 $\lambda-5$ 的两句；严格说这两句不能省——$A=O$ 时 $m_A=\lambda$，$A=5I$ 时 $m_A=\lambda-5$，都仍无重根，结论不变，但「最小」二字的依据要交代。）

**方法二（重数比对）**：特征值 $\lambda_1=\lambda_2=0$ 的几何重数为

$$n-\operatorname{rank}(0I-A)=3-\operatorname{rank}A=3-1=2=d_1;$$

特征值 $\lambda_3=5$ 的几何重数为

$$n-\operatorname{rank}(5I-A)=3-2=1=d_3.$$

（$\operatorname{rank}A=1$：三行成比例，第一行 $(1,0,-2)$ 与第三行 $(-2,0,4)=-2\cdot$第一行；$\operatorname{rank}(5I-A)=2$：第二行 $(0,5,0)$ 独立，第一、三行成比例。）所有特征值的代数重数均等于几何重数，由 [@thm-3.6.1]（3）$\Rightarrow$（1），$A$ 是单纯矩阵。

**方法三（本编补：把 $P$ 写出来）**：解 $A\boldsymbol x=\boldsymbol 0$：$x_1-2x_3=0$，$x_2$ 自由，基础解系 $(2,0,1)^{\mathrm T}$、$(0,1,0)^{\mathrm T}$；解 $(A-5I)\boldsymbol x=\boldsymbol 0$：$-4x_1-2x_3=0$、$-5x_2=0$，得 $(1,0,-2)^{\mathrm T}$。取

$$P=\begin{bmatrix}0&2&1\\ 1&0&0\\ 0&1&-2\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(0,0,5),$$

则 $\det P=5\ne0$，且 $P^{-1}AP=\Lambda$——把「存在 $P$」落到了具体矩阵上。∎
:::
:::

::: note 注 2（课件原文）· 单重特征值的几何重数 {#note-3.6-alg1}

复方阵某一特征值的代数重数为 $1$，则它的几何重数必为 $1$。

（本编补一行：几何重数至少为 $1$（特征向量非零），又不超过代数重数（[@thm-mult-ineq]），夹在 $1$ 与 $1$ 之间只能取 $1$。这条小注是下面推论的直接燃料。）
:::

::: cor 推论 3.6.1 · 互异特征值是充分条件 {#cor-3.6.1}

若 $n$ 阶复方阵 $A$ 恰好有 $n$ 个互异特征值，则它必可对角化；反之则不然。

（证明：$n$ 个互异特征值意味着每个代数重数都是 $1$，由注 2 每个几何重数也是 $1$，故（3）成立。反之不然：$I_2$ 只有特征值 $1$（二重），却已经是对角阵；更一般地，$\operatorname{diag}(1,1,2)$ 有重特征值但可对角化。故「互异」只是**充分**条件，不是必要条件。）
:::

下一道例题把「零化多项式」这条判据用到了极致：

::: ex 例 3.6.2（课件原文）· 幂等矩阵必可对角化 {#ex-3.6.2}

复方阵 $A$ 满足 $A^2=A$，判断 $A$ 是否可对角化。

::: sol 解答（课件路线）

由 $A^2=A$ 知

$$g(\lambda)=\lambda^2-\lambda=\lambda(\lambda-1)$$

是 $A$ 的零化多项式。注意 $g$ **不一定**是 $A$ 的最小多项式，但 $m_A\mid g$，故 $m_A$ 只能是

$$m_A(\lambda)=\lambda,\qquad m_A(\lambda)=\lambda-1,\qquad m_A(\lambda)=\lambda^2-\lambda.$$

三种可能都无重根，因此 $A$ 的最小多项式也无重根，即 $A$ 是单纯矩阵。

（读法：$A=O$ 对应 $m_A=\lambda$；$A=I$ 对应 $m_A=\lambda-1$；其余情形对应 $m_A=\lambda(\lambda-1)$。三种情形的共同点是 $m_A$ 的根全在 $\{0,1\}$ 中且都是一重——这正是「幂等」二字的代数痕迹。）∎
:::
:::

::: cor 推论 3.6.2 · 无重根的零化多项式 {#cor-3.6.2}

若复方阵 $A$ 的零化多项式 $g(\lambda)$ 无重根，则矩阵 $A$ 是单纯矩阵。

（证明：$m_A\mid g$（[@thm-3.5.5]），而 $g$ 无重根，故 $m_A$ 也无重根；由 [@thm-3.6.1]（5）$\Rightarrow$（1）即得。）
:::

::: note 注 3（课件原文）· 两个推论的适用范围 {#note-3.6-sufficient}

上述两推论仅作为 $A$ 为单纯矩阵的**充分非必要**条件。

（本编补一段辨析，因为注 3 的措辞很容易被读成「两个推论都不必要」，从而误以为「互异特征值 / 无重根零化多项式」对判断毫无必要。准确的说法是：

- **推论 3.6.1**：$n$ 个互异特征值 $\Rightarrow$ 单纯；单纯 $\nRightarrow$ $n$ 个互异特征值（$I_n$）。它是充分条件，不是必要条件；
- **推论 3.6.2**：若**存在**一个无重根的零化多项式 $g$，则单纯；但单纯**不意味着**「**每个**零化多项式都无重根」——$I_2$ 的 $f_A=(\lambda-1)^2$ 就是一个有重根的零化多项式。不过，单纯矩阵**总存在**一个无重根的零化多项式，那就是 $m_A$ 本身。所以「存在无重根零化多项式」其实是**充要**条件（取 $g=m_A$ 即得必要性），只是课件把「$g$ 是事先给定的、方便验证的那一个」当成了充分条件的表述。

一句话：**真正的充要条件是（5）「$m_A$ 无重根」；两个推论是两条便于上手的判别口诀——3.6.1 只是充分，3.6.2 按字面是充要**。判断题若写「$A$ 有重特征值，故不可对角化」，错在用推论 3.6.1 的逆否；若写「$A$ 可对角化，故 $A$ 的每个零化多项式都无重根」，错在把「存在」偷换成「任意」。）
:::

::: ex 例 3.6.A（新增）· 幂等矩阵的谱分解雏形 {#ex-3.6.A}

设 $A=\begin{bmatrix}1&1\\ 0&0\end{bmatrix}$。验证 $A^2=A$，求它的对角化分解，并说明 $A$ 是不是正交投影。

::: sol 解答

**幂等**：$A^2=\begin{bmatrix}1&1\\0&0\end{bmatrix}\begin{bmatrix}1&1\\0&0\end{bmatrix}=\begin{bmatrix}1&1\\0&0\end{bmatrix}=A$ ✓。由 [@ex-3.6.2]，$A$ 可对角化，特征值只能是 $0$ 或 $1$。

**特征值**：$\operatorname{tr}A=1$、$\det A=0$，故特征值为 $1,0$。对应特征向量：$\lambda=1$ 时 $(A-I)\boldsymbol x=\begin{bmatrix}0&1\\0&-1\end{bmatrix}\boldsymbol x=\boldsymbol 0$，得 $(1,0)^{\mathrm T}$；$\lambda=0$ 时 $A\boldsymbol x=\boldsymbol 0$，得 $(-1,1)^{\mathrm T}$。取

$$P=\begin{bmatrix}1&-1\\ 0&1\end{bmatrix},\qquad \Lambda=\operatorname{diag}(1,0),\qquad P^{-1}AP=\Lambda.$$

**读法**：$A$ 就是「把向量投影到 $x$ 轴、沿方向 $(-1,1)$ 投出去」的**斜投影**：$R(A)=\operatorname{span}\{(1,0)^{\mathrm T}\}$，$N(A)=\operatorname{span}\{(-1,1)^{\mathrm T}\}$，两者不垂直（内积 $-1\ne0$）。因此 $A$ 是幂等阵，但**不是正交投影**——$A^{\mathrm T}\ne A$，也不是正规阵（$A^{\mathrm T}A=\begin{bmatrix}1&1\\1&1\end{bmatrix}$，$AA^{\mathrm T}=\begin{bmatrix}2&0\\0&0\end{bmatrix}$）。正交投影的判别要等到 [3.7.4](sec37.md#sec-3.7.4)。∎
:::
:::

到此，3.6 的第一半——「能不能对角化」——已经闭合。下面先看它换来的两笔计算红利，再转向「能不能用酉矩阵对角化」这个几何问题。

<a id="sec-3.6.2"></a>

## 3.6.2 对角化分解的用法：幂与微分方程

对角化分解最直接的用处，是把「矩阵的乘法」降级成「对角元的乘法」。$A=P\Lambda P^{-1}$ 时，

$$A^m=(P\Lambda P^{-1})(P\Lambda P^{-1})\cdots(P\Lambda P^{-1})=P\Lambda^mP^{-1},$$

中间的 $P^{-1}P$ 逐对相消——$m$ 次矩阵乘法变成 $n$ 次标量幂。

::: ex 例 3.6.3（课件原文）· 用对角化分解求 $A^{100}$ {#ex-3.6.3}

设 $A=\begin{bmatrix}2&1\\ 2&3\end{bmatrix}$，求 $A^{100}$。

::: sol 解答（课件路线；$P^{-1}$ 与终值验算由本编补）

**特征多项式**：

$$f_A(\lambda)=\lambda^2-5\lambda+4=(\lambda-1)(\lambda-4)$$

（$\operatorname{tr}A=5=1+4$ ✓，$\det A=4=1\cdot4$ ✓）。两个特征值 $1,4$ 互异，由 [@cor-3.6.1] 可对角化。

**特征向量与 $P$**：$\lambda=1$ 时 $(A-I)\boldsymbol x=\begin{bmatrix}1&1\\2&2\end{bmatrix}\boldsymbol x=\boldsymbol 0$，取 $(1,-1)^{\mathrm T}$；$\lambda=4$ 时 $(A-4I)\boldsymbol x=\begin{bmatrix}-2&1\\2&-1\end{bmatrix}\boldsymbol x=\boldsymbol 0$，取 $(1,2)^{\mathrm T}$。于是

$$P=\begin{bmatrix}1&1\\ -1&2\end{bmatrix},\qquad
P^{-1}=\frac13\begin{bmatrix}2&-1\\ 1&1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(1,4),$$

验算 $P^{-1}AP=\Lambda$：第一列 $P^{-1}A(1,-1)^{\mathrm T}=P^{-1}(1,-1)^{\mathrm T}=(1,0)^{\mathrm T}$ ✓；第二列 $P^{-1}A(1,2)^{\mathrm T}=P^{-1}(4,8)^{\mathrm T}=(0,4)^{\mathrm T}$ ✓。

**求幂**：

$$A^m=P\Lambda^mP^{-1}=P\begin{bmatrix}1&0\\0&4^m\end{bmatrix}P^{-1}.$$

当 $m=100$ 时，逐项乘开：

$$A^{100}=\begin{bmatrix}
\dfrac{4^{100}+2}{3}&\dfrac{4^{100}-1}{3}\\[6pt]
\dfrac{2(4^{100}-1)}{3}&\dfrac{2\cdot4^{100}+1}{3}
\end{bmatrix}.$$

（验算：$(1,1)$ 元 $=\dfrac{2+4^{100}}{3}$ ✓；$(1,2)$ 元 $=\dfrac{-1+4^{100}}{3}$ ✓；$(2,1)$ 元 $=\dfrac{2(4^{100}-1)}{3}$ ✓；$(2,2)$ 元 $=\dfrac{-1+2\cdot4^{100}}{3}$ ✓。本编双精度复核与直接连乘逐位一致。）

**三条路对照**：同一道题在 [3.5.5](sec35.md#ex-3.5.5) 已用 Hamilton–Cayley 递推做过，答案相同；[3.7.2](sec37.md#ex-3.7.2) 还会用谱分解 $A^{100}=E_1+4^{100}E_2$ 再做一遍。三条路的适用面不同：递推**不要求可对角化**，对角化要求单纯，谱分解要求单纯但把「求 $P^{-1}$」换成了「求谱阵」——见 [3.7.3](sec37.md#sec-3.7.3) 的对照表。∎
:::
:::

对角化分解的第二笔红利是**解耦微分方程**。这是它在工程里最常见的出场方式：

::: ex 例 3.6.4（课件原文）· 用对角化分解解线性常微分方程组 {#ex-3.6.4}

求解线性常微分方程组

$$\begin{cases}
\dot x_1=x_1-3x_2+3x_3,\\
\dot x_2=3x_1-5x_2+3x_3,\\
\dot x_3=6x_1-6x_2+4x_3.
\end{cases}$$

::: sol 解答（课件路线；$P$、$P^{-1}$ 与矩阵指数由本编补）

**写成向量方程**：记 $\boldsymbol x(t)=(x_1(t),x_2(t),x_3(t))^{\mathrm T}$，

$$A=\begin{bmatrix}1&-3&3\\ 3&-5&3\\ 6&-6&4\end{bmatrix},\qquad \dot{\boldsymbol x}(t)=A\boldsymbol x(t).$$

**对角化**：$f_A(\lambda)=(\lambda-4)(\lambda+2)^2$（$\operatorname{tr}A=0=4-2-2$ ✓，$\det A=-16=4\cdot(-2)\cdot(-2)$ ✓）。取特征向量

$$\boldsymbol p_1=(1,1,2)^{\mathrm T}\ (\lambda=4),\qquad
\boldsymbol p_2=(1,1,0)^{\mathrm T}\ (\lambda=-2),\qquad
\boldsymbol p_3=(0,1,1)^{\mathrm T}\ (\lambda=-2),$$

拼成

$$P=\begin{bmatrix}1&1&0\\ 1&1&1\\ 2&0&1\end{bmatrix},\qquad
P^{-1}=\begin{bmatrix}\tfrac12&-\tfrac12&\tfrac12\\[2pt] \tfrac12&\tfrac12&-\tfrac12\\[2pt] -1&1&0\end{bmatrix},\qquad
P^{-1}AP=\operatorname{diag}(4,-2,-2)=\Lambda.$$

（验算 $A\boldsymbol p_1=(4,4,8)^{\mathrm T}=4\boldsymbol p_1$ ✓；$A\boldsymbol p_2=(-2,-2,0)^{\mathrm T}=-2\boldsymbol p_2$ ✓；$A\boldsymbol p_3=(0,-2,-2)^{\mathrm T}=-2\boldsymbol p_3$ ✓；$\det P=2\ne0$ ✓。）

**换元解耦**：令 $\boldsymbol y(t)=P^{-1}\boldsymbol x(t)$，即 $\boldsymbol x=P\boldsymbol y$。代入 $\dot{\boldsymbol x}=A\boldsymbol x$：

$$P\dot{\boldsymbol y}=AP\boldsymbol y\quad\Longrightarrow\quad \dot{\boldsymbol y}=P^{-1}AP\,\boldsymbol y=\Lambda\boldsymbol y.$$

三个方程彻底解耦：

$$\dot y_1=4y_1,\qquad \dot y_2=-2y_2,\qquad \dot y_3=-2y_3,$$

解得 $y_1=c_1e^{4t}$、$y_2=c_2e^{-2t}$、$y_3=c_3e^{-2t}$。再乘回 $\boldsymbol x=P\boldsymbol y$：

$$\begin{aligned}
x_1(t)&=c_1e^{4t}+c_2e^{-2t},\\
x_2(t)&=c_1e^{4t}+(c_2+c_3)e^{-2t},\\
x_3(t)&=2c_1e^{4t}+c_3e^{-2t}.
\end{aligned}$$

（与课件一致。初始条件由 $\boldsymbol c=P^{-1}\boldsymbol x(0)$ 定出：$c_1=\tfrac12(x_1(0)-x_2(0)+x_3(0))$、$c_2=\tfrac12(x_1(0)+x_2(0)-x_3(0))$、$c_3=-x_1(0)+x_2(0)$。）

**矩阵指数读法（本编补）**：把解写成 $\boldsymbol x(t)=e^{At}\boldsymbol x(0)$，则

$$e^{At}=Pe^{\Lambda t}P^{-1}=P\operatorname{diag}(e^{4t},e^{-2t},e^{-2t})P^{-1}.$$

它满足 $\dfrac{d}{dt}e^{At}=Ae^{At}$、$e^{A\cdot0}=I$——这正是「对角化把矩阵指数变成标量指数」的一般事实。**稳定性**也一眼读出：特征值 $4,-2,-2$ 中有一个正实部，故 $t\to+\infty$ 时解沿 $\boldsymbol p_1$ 方向指数增长，方程组**不是**渐近稳定的；若三个特征值实部全负，才有 $e^{At}\to O$。∎
:::
:::

::: method 对角化分解的标准流程 {#method-diag}

**入口**：「判断 $A$ 能否对角化」「求 $P$ 使 $P^{-1}AP=\Lambda$」「用对角化算 $A^m$ / 解 $\dot{\boldsymbol x}=A\boldsymbol x$」。

1. **求特征多项式** $f_A(\lambda)=\det(\lambda I-A)$，因式分解得互异根 $\lambda_1,\cdots,\lambda_m$ 与代数重数 $d_i$；用 $\operatorname{tr}A=\sum d_i\lambda_i$、$\det A=\prod\lambda_i^{d_i}$ 先验根（[@thm-eig-trace]）。
2. **算几何重数** $g_i=n-\operatorname{rank}(A-\lambda_iI)$（[@thm-geom-mult]）。只要有一个 $g_i<d_i$，**立刻停**：不可对角化（[@thm-3.6.1]）。
3. **求特征向量**：对每个 $\lambda_i$ 解 $(A-\lambda_iI)\boldsymbol x=\boldsymbol 0$，取 $g_i$ 个线性无关解；合起来 $n$ 个，拼成 $P$。
4. **配对 $\Lambda$**：$\Lambda$ 的对角元次序必须与 $P$ 的列次序**逐列对应**；写 $P^{-1}AP=\Lambda$，或等价地验 $AP=P\Lambda$。
5. **回代验算**：$\operatorname{tr}\Lambda=\operatorname{tr}A$、$\det\Lambda=\det A$；$AP=P\Lambda$ 抽查一列；求 $P^{-1}$ 后抽查 $P^{-1}P=I$。

**易错**：把 $P$ 的列顺序与 $\Lambda$ 的对角顺序写岔（最常见）；$g_i$ 用 $n-\operatorname{rank}(\lambda_iI-A)$ 算成 $n-\operatorname{rank}(A-\lambda_iI)$ 的负数（两者秩相同，结果一样，但符号别丢）；重特征值只找到一个特征向量就宣布「可对角化」；用 $P^{-1}AP$ 与 $PAP^{-1}$ 写反。
:::

<a id="sec-3.6.3"></a>

## 3.6.3 酉相似对角化：从 Hermite 矩阵到对称矩阵

[3.6.1](#sec-3.6.1) 的 $P$ 只要求可逆，它的列可以又长又斜、甚至接近线性相关。若把 $P$ 升级成**酉矩阵**，几何意义立刻变清楚：换基不再「拉扯」空间，而是刚性地旋转 / 镜像。代价是矩阵要满足更强的条件。

::: def 定义 3.6.2 · 酉相似对角化 {#def-3.6.2}

若 $n$ 阶复方阵 $A$ **酉相似**于对角矩阵 $\Lambda$，即存在 $n$ 阶酉矩阵 $U$ 使得

$$U^{\mathrm H}AU=\Lambda,$$

则称矩阵 $A$ 是**可酉相似对角化的**。
:::

课件紧接着问：**何种矩阵可酉相似对角化？** 分析只有三行，但已经把答案的形状说出来了：

> 假设存在酉阵 $U$ 使得 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$，并令 $U=[\boldsymbol u_1,\cdots,\boldsymbol u_n]$，则
> $$A[\boldsymbol u_1,\cdots,\boldsymbol u_n]=[\boldsymbol u_1,\cdots,\boldsymbol u_n]\operatorname{diag}(\lambda_1,\cdots,\lambda_n),\qquad A\boldsymbol u_i=\lambda_i\boldsymbol u_i.$$
> 这表明 $\boldsymbol u_i$ 是属于特征值 $\lambda_i$ 的特征向量。特征向量 $\boldsymbol u_i$ 和 $\boldsymbol u_j$（$i\ne j$）两两正交，这表明 $A$ 有 $n$ 个正交的特征向量。

把这段话翻译成一句话：**酉相似对角化 $\iff$ $A$ 有一组由特征向量构成的标准正交基**。必要性是上面三行；充分性只需把这句话倒过来——若 $\boldsymbol u_1,\cdots,\boldsymbol u_n$ 是标准正交的特征向量基，令 $U=[\boldsymbol u_1,\cdots,\boldsymbol u_n]$，则 $U$ 酉且 $U^{\mathrm H}AU=\Lambda$。

于是问题变成：**哪些矩阵的特征向量自动正交？** 课件先处理最重要的一类——Hermite 矩阵：

::: ex 例 3.6.5（课件原文）· Hermite 矩阵可酉相似对角化 {#ex-3.6.5}

考查 Hermite 矩阵 $A$ 是否可作酉相似对角化。

::: sol 解答（课件路线；反方向由本编补）

**利用 Schur 引理**：由 [@thm-3.5.2]，存在酉矩阵 $U$ 使

$$U^{\mathrm H}AU=\Lambda$$

为上三角阵。对上式两端取共轭转置：

$$U^{\mathrm H}A^{\mathrm H}U=\Lambda^{\mathrm H}.$$

（推导：$(U^{\mathrm H}AU)^{\mathrm H}=U^{\mathrm H}A^{\mathrm H}U$，右边取 $\mathrm H$ 即 $\Lambda^{\mathrm H}$。）由于 $A=A^{\mathrm H}$，两式左边相同，故

$$\Lambda=\Lambda^{\mathrm H}.$$

$\Lambda$ 既是上三角阵，又等于自己的共轭转置（即 $\Lambda^{\mathrm H}$ 是下三角阵），故 $\Lambda$ 只能是对角阵；对角元满足 $\lambda_i=\overline{\lambda_i}$，必为实数。于是 $A$ 可酉相似对角化，且特征值全实。

**反方向（本编补）**：若 $A$ 的所有特征值 $\lambda_i$ 为实数，且存在酉矩阵 $U$ 使 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$，则

$$A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H},\qquad
A^{\mathrm H}=U\operatorname{diag}(\overline{\lambda_1},\cdots,\overline{\lambda_n})U^{\mathrm H}=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}=A,$$

故 $A$ 是 Hermite 矩阵。∎
:::
:::

把两个方向合起来，就是 Hermite 矩阵的**谱定理**：

::: cor 推论 3.6.3 · Hermite 矩阵的谱定理 {#cor-3.6.3}

复方阵 $A$ 是 Hermite 矩阵**当且仅当** $A$ 的所有特征值 $\lambda_1,\cdots,\lambda_n$ 为实数，且存在酉矩阵 $U\in\mathbb C^{n\times n}$ 使得

$$U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n).$$
:::

::: cor 推论 3.6.4 · 实对称矩阵的谱定理 {#cor-3.6.4}

实方阵 $A$ 是对称阵**当且仅当** $A$ 的所有特征值 $\lambda_1,\cdots,\lambda_n$ 为实数，且存在正交矩阵 $Q\in\mathbb R^{n\times n}$ 使得

$$Q^{\mathrm T}AQ=\operatorname{diag}(\lambda_1,\cdots,\lambda_n).$$
:::

::: proof 证明（课件未给，本编补：推论 3.6.4 由 3.6.3 取实部）

**（$\Rightarrow$）** 设 $A$ 实对称。把 $A$ 看作复矩阵，它满足 $A^{\mathrm H}=A^{\mathrm T}=A$，故是 Hermite 矩阵；由 [@cor-3.6.3]，存在酉矩阵 $U$ 使 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_i)$，$\lambda_i$ 全实。还需把 $U$ 换成**实正交**矩阵：对每个实特征值 $\lambda_i$，$(A-\lambda_iI)\boldsymbol x=\boldsymbol 0$ 是实系数方程组，其解空间有实基（[3.5](sec35.md) 定理 3.5.3 的证明已用过同一事实）；取实特征向量并正交化，即得实正交 $Q$。

**（$\Leftarrow$）** 若 $Q^{\mathrm T}AQ=\operatorname{diag}(\lambda_i)$ 且 $\lambda_i$ 全实，则 $A=Q\operatorname{diag}(\lambda_i)Q^{\mathrm T}$，于是

$$A^{\mathrm T}=Q\operatorname{diag}(\lambda_i)Q^{\mathrm T}=A,$$

即 $A$ 实对称。

（读法：推论 3.6.4 是线性代数里最常用的「谱定理」版本——**实对称矩阵一定可以正交对角化，且特征值全实**。它比 [@cor-3.6.1] 强的地方在于：不要求特征值互异；比 [@thm-3.5.3] 强的地方在于：不仅三角化，而且对角化。）
:::

课件用一道 $4$ 阶实对称矩阵的题把「重特征值内部还要正交化」这件事演了一遍：

::: ex 例 3.6.6（课件原文）· 实对称矩阵的正交对角化 {#ex-3.6.6}

求正交矩阵 $Q$ 使得 $Q^{\mathrm T}BQ$ 为对角阵，其中

$$B=\begin{bmatrix}
-1&-3&3&-3\\
-3&-1&-3&3\\
3&-3&-1&-3\\
-3&3&-3&-1
\end{bmatrix}.$$

::: sol 解答（课件路线；$Q^{\mathrm T}Q$ 与 $Q^{\mathrm T}BQ$ 的验算由本编补）

**特征多项式**：

$$f_B(\lambda)=(\lambda-8)(\lambda+4)^3$$

（快验：$\operatorname{tr}B=-4=8+3\cdot(-4)$ ✓；$\det B=-512=8\cdot(-4)^3$ ✓）。解得

$$\lambda_1=8,\qquad \lambda_2=\lambda_3=\lambda_4=-4.$$

**$\lambda_1=8$ 的特征向量**：解 $(B-8I)\boldsymbol x=\boldsymbol 0$，得

$$\boldsymbol x_1=(-1,1,-1,1)^{\mathrm T}.$$

**$\lambda=-4$ 的特征向量**：$B+4I$ 的四行都成比例（第一行 $(3,-3,3,-3)$，其余是它的倍数），方程只有 $x_1-x_2+x_3-x_4=0$，解空间三维。课件取

$$\boldsymbol x_2=(1,0,0,1)^{\mathrm T},\qquad
\boldsymbol x_3=(1,1,0,0)^{\mathrm T},\qquad
\boldsymbol x_4=(1,0,-1,0)^{\mathrm T}.$$

它们确实线性无关，但**并不两两正交**：$\boldsymbol x_2^{\mathrm T}\boldsymbol x_3=1$、$\boldsymbol x_2^{\mathrm T}\boldsymbol x_4=1$、$\boldsymbol x_3^{\mathrm T}\boldsymbol x_4=1$。这正是课件那句提醒的来由——**「存在 $4$ 个正交特征向量」不等于「任意 $4$ 个线性无关特征向量都正交」**；属于不同特征值的特征向量（$\boldsymbol x_1$ 与 $\boldsymbol x_2,\boldsymbol x_3,\boldsymbol x_4$）由实对称性自动正交（$\boldsymbol x_1^{\mathrm T}\boldsymbol x_2=\boldsymbol x_1^{\mathrm T}\boldsymbol x_3=\boldsymbol x_1^{\mathrm T}\boldsymbol x_4=0$），需要动手的只是**重特征值内部**。

**单位化与正交化**：

$$\boldsymbol z_1=\frac12(-1,1,-1,1)^{\mathrm T};$$

对 $\boldsymbol x_2,\boldsymbol x_3,\boldsymbol x_4$ 做 Gram–Schmidt（[@method-gs]）：

$$\boldsymbol z_2=\frac{1}{\sqrt2}(1,0,0,1)^{\mathrm T},\qquad
\boldsymbol z_3=\frac{1}{\sqrt6}(1,2,0,-1)^{\mathrm T},\qquad
\boldsymbol z_4=\frac{\sqrt3}{6}(1,-1,-3,-1)^{\mathrm T}.$$

（逐步验算：$\boldsymbol y_3=\boldsymbol x_3-(\boldsymbol x_3^{\mathrm T}\boldsymbol z_2)\boldsymbol z_2=(\tfrac12,1,0,-\tfrac12)^{\mathrm T}$，$\|\boldsymbol y_3\|=\sqrt{3/2}=\sqrt6/2$，故 $\boldsymbol z_3=(1,2,0,-1)^{\mathrm T}/\sqrt6$；$\boldsymbol y_4=\boldsymbol x_4-(\boldsymbol x_4^{\mathrm T}\boldsymbol z_2)\boldsymbol z_2-(\boldsymbol x_4^{\mathrm T}\boldsymbol z_3)\boldsymbol z_3=(\tfrac13,-\tfrac13,-1,-\tfrac13)^{\mathrm T}$，$\|\boldsymbol y_4\|=2/\sqrt3$，故 $\boldsymbol z_4=\tfrac{\sqrt3}{6}(1,-1,-3,-1)^{\mathrm T}$。）

**拼装与验算**：令 $Q=[\boldsymbol z_1,\boldsymbol z_2,\boldsymbol z_3,\boldsymbol z_4]$，则 $Q^{\mathrm T}Q=I_4$（各列标准正交），且

$$Q^{\mathrm T}BQ=\operatorname{diag}(8,-4,-4,-4).$$

（直接验算：$B\boldsymbol z_1=8\boldsymbol z_1$、$B\boldsymbol z_2=B\boldsymbol z_3=B\boldsymbol z_4=-4\boldsymbol z_i$；再用 $Q^{\mathrm T}Q=I$ 即得对角阵。本编逐列复核通过。）∎
:::
:::

::: note 本编注 · 为什么只在重特征值内部正交化 {#note-3.6-why-gs-inside}

实对称（更一般地，正规）矩阵有一个**免费的正交性**：属于不同特征值的特征向量自动正交。证明只需一行（以实对称为例）：设 $A\boldsymbol u=\lambda\boldsymbol u$、$A\boldsymbol v=\mu\boldsymbol v$，则

$$\lambda\boldsymbol u^{\mathrm T}\boldsymbol v=(A\boldsymbol u)^{\mathrm T}\boldsymbol v=\boldsymbol u^{\mathrm T}A^{\mathrm T}\boldsymbol v=\boldsymbol u^{\mathrm T}A\boldsymbol v=\mu\boldsymbol u^{\mathrm T}\boldsymbol v,$$

故 $(\lambda-\mu)\boldsymbol u^{\mathrm T}\boldsymbol v=0$；$\lambda\ne\mu$ 时 $\boldsymbol u\perp\boldsymbol v$。所以**跨特征值**的正交性不用做任何事；只有同一个特征值的特征子空间内部，随便取的基可能斜，才需要 Gram–Schmidt。例 3.6.6 中 $\boldsymbol x_1$ 与 $\boldsymbol x_2,\boldsymbol x_3,\boldsymbol x_4$ 的正交性正是免费的，$\boldsymbol z_2,\boldsymbol z_3,\boldsymbol z_4$ 才是 GS 的产物。
:::

::: note 勘误提示（例 3.6.6 的文字） {#note-3.6-errata-e38}

课件此页的文字有两处笔误：「尽管 **Q 阵**存在 4 个正交特征向量使得 **Q 可相似对角化**」应为「尽管 **B** 存在 4 个正交特征向量使得 **B 可正交对角化**」；「但**并意味**它的任意 4 个线性无关的特征向量都正交」应为「但**并不意味着**……」。数学内容不受影响，正文按更正后的表述讲解；详见[勘误 E3.8](errata.md)。
:::

<a id="sec-3.6.4"></a>

## 3.6.4 正规矩阵：酉对角化的完整答案

Hermite 矩阵与实对称矩阵只是「酉可对角化」的两个重要成员。课件接着追问：**除了 Hermite 矩阵，还有哪些矩阵可作酉相似对角化？** 答案是一整类——正规矩阵。

::: def 定义 3.6.3 · 正规矩阵 {#def-3.6.3}

设 $A\in\mathbb C^{n\times n}$，若

$$A^{\mathrm H}A=AA^{\mathrm H},$$

则称 $A$ 为**正规矩阵**（或**规范矩阵**）。
:::

课件列了一串现成成员：**Hermite 阵、反 Hermite 阵、正交阵、酉矩阵等都是正规阵**。逐条验证都只有一行：

- $A^{\mathrm H}=A$：$A^{\mathrm H}A=A^2=AA^{\mathrm H}$；
- $A^{\mathrm H}=-A$：$A^{\mathrm H}A=-A^2=AA^{\mathrm H}$；
- $A^{\mathrm H}A=I$（酉矩阵）：$A^{\mathrm H}A=I=AA^{\mathrm H}$（后者由 $A^{-1}=A^{\mathrm H}$ 得到）；
- 正交阵是酉矩阵的实特例。

课件还给了一个「非平凡」的例子：

$$B=U^{\mathrm H}\operatorname{diag}(3+5\mathrm i,\,2-\mathrm i)\,U$$

也是正规阵，其中 $U$ 为任意二阶酉矩阵。验证：$B^{\mathrm H}B=U^{\mathrm H}\operatorname{diag}(|3+5\mathrm i|^2,|2-\mathrm i|^2)U=BB^{\mathrm H}$——对角阵的两个方向可交换，$U$ 从两侧一夹，正规性就传给了 $B$。这个例子说明：**「酉相似于对角阵」这件事本身会遗传正规性**；反过来，正规矩阵一定能酉相似于对角阵，这就是下面的主定理。

::: lem 引理 3.6.A（本编补）· 上三角正规阵必为对角阵 {#lem-3.6.A}

设 $T\in\mathbb C^{n\times n}$ 既是上三角阵又是正规阵（$T^{\mathrm H}T=TT^{\mathrm H}$），则 $T$ 是对角阵。

::: proof 证明（本编补：比较第一行 / 第一列的长度，再归纳）

对 $n$ 归纳。$n=1$ 显然。设 $n\ge2$。比较 $T^{\mathrm H}T$ 与 $TT^{\mathrm H}$ 的 $(1,1)$ 元：

$$(T^{\mathrm H}T)_{11}=\sum_{k=1}^{n}\overline{t_{k1}}\,t_{k1}=|t_{11}|^2$$

（$T$ 上三角，第一列只有 $t_{11}$ 一个可能非零的分量）；而

$$(TT^{\mathrm H})_{11}=\sum_{k=1}^{n}t_{1k}\,\overline{t_{1k}}=\sum_{k=1}^{n}|t_{1k}|^2.$$

两者相等，故 $\sum_{k=2}^{n}|t_{1k}|^2=0$，即 $t_{12}=\cdots=t_{1n}=0$。于是 $T$ 形如

$$T=\begin{bmatrix}t_{11}&0&\cdots&0\\ 0&&&\\ \vdots&&T'&\\ 0&&&\end{bmatrix},$$

其中 $T'$ 是 $n-1$ 阶上三角阵。把 $T^{\mathrm H}T=TT^{\mathrm H}$ 写成同样的分块，比较右下块得 $T'^{\mathrm H}T'=T'T'^{\mathrm H}$，即 $T'$ 正规；由归纳假设 $T'$ 对角。故 $T$ 对角。
:::
:::

::: thm 定理 3.6.2 · 正规矩阵的谱定理 {#thm-3.6.2}

复方阵 $A$ 是正规矩阵**当且仅当** $A$ 酉相似于对角阵，即

$$A^{\mathrm H}A=AA^{\mathrm H}\quad\Longleftrightarrow\quad\text{存在酉矩阵 }U\text{ 使得 }U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n).$$
:::

::: proof 证明（课件未给，本编补：Schur 型 $+$ 引理 3.6.A）

**（$\Rightarrow$）** 由 Schur 引理（[@thm-3.5.2]），存在酉矩阵 $U$ 使 $T=U^{\mathrm H}AU$ 为上三角阵。正规性在酉相似下不变：

$$T^{\mathrm H}T=U^{\mathrm H}A^{\mathrm H}UU^{\mathrm H}AU=U^{\mathrm H}A^{\mathrm H}AU,\qquad
TT^{\mathrm H}=U^{\mathrm H}AA^{\mathrm H}U,$$

而 $A^{\mathrm H}A=AA^{\mathrm H}$，故 $T^{\mathrm H}T=TT^{\mathrm H}$——$T$ 正规。由 [@lem-3.6.A]，$T$ 只能是对角阵。于是 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$。

**（$\Leftarrow$）** 若 $A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}$，则

$$A^{\mathrm H}A=U\operatorname{diag}(\overline{\lambda_1},\cdots,\overline{\lambda_n})\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}
=U\operatorname{diag}(|\lambda_1|^2,\cdots,|\lambda_n|^2)U^{\mathrm H},$$

同理 $AA^{\mathrm H}=U\operatorname{diag}(|\lambda_1|^2,\cdots,|\lambda_n|^2)U^{\mathrm H}$，两者相等。

**读法**：这个证明把 [3.5](sec35.md) 的两件工具接在了一起——**Schur 保证「总能把 $A$ 变成上三角」**，**正规性保证「这个上三角其实是对角」**。所以正规矩阵是「Schur 型恰好退化为对角型」的那一类矩阵；Hermite 矩阵是其中一个子类（其特征值还必须全实）。
:::

::: lem 引理 3.6.B（本编补）· 正规阵不同特征值的特征向量正交 {#lem-3.6.B}

设 $A$ 是正规矩阵，$A\boldsymbol u=\lambda\boldsymbol u$、$A\boldsymbol v=\mu\boldsymbol v$，且 $\lambda\ne\mu$，则 $\boldsymbol u\perp\boldsymbol v$。

::: proof 证明（本编补：$A-\mu I$ 也正规，长度等式逼出 $A^{\mathrm H}\boldsymbol v=\overline{\mu}\boldsymbol v$）

$A-\mu I$ 与 $A$ 同为正规阵：直接展开

$$(A-\mu I)^{\mathrm H}(A-\mu I)=A^{\mathrm H}A-\overline{\mu}A-\mu A^{\mathrm H}+|\mu|^2I=(A-\mu I)(A-\mu I)^{\mathrm H}$$

（用了 $A^{\mathrm H}A=AA^{\mathrm H}$）。于是对 $\boldsymbol v\in E(\mu)$，

$$\|(A-\mu I)^{\mathrm H}\boldsymbol v\|^2=\big((A-\mu I)^{\mathrm H}\boldsymbol v,(A-\mu I)^{\mathrm H}\boldsymbol v\big)
=\big(\boldsymbol v,(A-\mu I)(A-\mu I)^{\mathrm H}\boldsymbol v\big)
=\|(A-\mu I)\boldsymbol v\|^2=0,$$

故 $(A^{\mathrm H}-\overline{\mu}I)\boldsymbol v=\boldsymbol 0$，即 $A^{\mathrm H}\boldsymbol v=\overline{\mu}\boldsymbol v$。再用内积算：

$$\lambda(\boldsymbol u,\boldsymbol v)=(A\boldsymbol u,\boldsymbol v)=(\boldsymbol u,A^{\mathrm H}\boldsymbol v)=(\boldsymbol u,\overline{\mu}\boldsymbol v)=\mu(\boldsymbol u,\boldsymbol v),$$

故 $(\lambda-\mu)(\boldsymbol u,\boldsymbol v)=0$；$\lambda\ne\mu$ 时 $\boldsymbol u\perp\boldsymbol v$。

（注意最后一步用了全书「第一变元线性」的内积约定（[1.4](ch01/sec14.md)）：$(\boldsymbol u,\overline{\mu}\boldsymbol v)=\mu(\boldsymbol u,\boldsymbol v)$。若你的教材用第二变元线性，公式要相应改写，但结论不变。）
:::
:::

有了引理 3.6.B，定理 3.6.2 可以改写成「特征向量版」：

::: cor 推论 3.6.5 · 正规矩阵的特征向量刻画 {#cor-3.6.5}

复方阵 $A$ 是正规矩阵**当且仅当** $A$ 有 $n$ 个特征向量构成 $\mathbb C^n$ 空间的一组标准正交基，且属于 $A$ 的不同特征值的特征向量正交。
:::

::: proof 证明（课件未给，本编补）

**（$\Rightarrow$）** 由 [@thm-3.6.2]，存在酉矩阵 $U=[\boldsymbol u_1,\cdots,\boldsymbol u_n]$ 使 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$。逐列读出 $A\boldsymbol u_i=\lambda_i\boldsymbol u_i$；$U$ 酉故各列构成标准正交基。不同特征值的特征向量正交由 [@lem-3.6.B] 给出。

**（$\Leftarrow$）** 若 $\boldsymbol u_1,\cdots,\boldsymbol u_n$ 是标准正交的特征向量基，令 $U=[\boldsymbol u_1,\cdots,\boldsymbol u_n]$，则 $U$ 酉且 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$；由 [@thm-3.6.2] 的（$\Leftarrow$）方向，$A$ 正规。

（读法：推论 3.6.5 里的「且属于不同特征值的特征向量正交」其实**是标准正交基的自动推论**——既然是标准正交基，任意两列都正交。课件保留这句话，是在强调正规矩阵的几何特征：**不同特征子空间不仅线性无关，而且互相垂直**。对一般的单纯矩阵，不同特征子空间只保证直和，不一定正交——例 3.6.A 的 $A=\begin{bmatrix}1&1\\0&0\end{bmatrix}$ 就是反例：$E(1)=\operatorname{span}\{(1,0)^{\mathrm T}\}$ 与 $E(0)=\operatorname{span}\{(-1,1)^{\mathrm T}\}$ 不垂直。）
:::

现在用「反求矩阵」的题型检验这套理论——已知特征值和部分特征向量，把矩阵还原出来：

::: ex 例 3.6.7（课件原文）· 由特征向量反求实对称矩阵 {#ex-3.6.7}

设 $A$ 是 $3$ 阶实对称矩阵，若 $A$ 相似于对角矩阵 $\Lambda=\operatorname{diag}(3,9,3)$，且 $\boldsymbol x_1=(1,2,3)^{\mathrm T}$、$\boldsymbol x_2=(1,1,1)^{\mathrm T}$ 是矩阵 $A$ 的特征向量，求矩阵 $A$。

::: sol 解答（课件路线；$P^{-1}$ 的符号勘误见 E3.9，本编已更正）

**第一步：判断 $\boldsymbol x_1,\boldsymbol x_2$ 属于哪个特征值。** 计算内积

$$(\boldsymbol x_1,\boldsymbol x_2)=1+2+3=6\ne0,$$

故 $\boldsymbol x_1$ 与 $\boldsymbol x_2$ **不**正交。$A$ 实对称，属于不同特征值的特征向量必正交（[@cor-3.6.4] 或 [@lem-3.6.B]）；现在它们不正交，只能属于**同一个**特征值。$\Lambda$ 的特征值是 $3,9,3$，其中 $3$ 是二重的，故

$$A\boldsymbol x_1=3\boldsymbol x_1,\qquad A\boldsymbol x_2=3\boldsymbol x_2.$$

**第二步：求属于 $9$ 的特征向量。** 设 $\boldsymbol x_3$ 属于 $9$，则它必须与 $\boldsymbol x_1,\boldsymbol x_2$ 都正交：

$$(\boldsymbol x_1,\boldsymbol x_3)=0,\qquad (\boldsymbol x_2,\boldsymbol x_3)=0.$$

解这个 $2\times3$ 方程组（或直接取叉积 $\boldsymbol x_1\times\boldsymbol x_2=(-1,2,-1)^{\mathrm T}$），得

$$\boldsymbol x_3=(1,-2,1)^{\mathrm T}.$$

**第三步：拼 $P$ 与 $\Lambda$。** 注意**列序与对角元必须配对**：取

$$P=[\boldsymbol x_1,\boldsymbol x_3,\boldsymbol x_2]=\begin{bmatrix}1&1&1\\ 2&-2&1\\ 3&1&1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(3,9,3).$$

（$P$ 的三列依次对应 $\Lambda$ 的三个对角元 $3,9,3$；若写成 $P=[\boldsymbol x_1,\boldsymbol x_2,\boldsymbol x_3]$，则 $\Lambda$ 必须写成 $\operatorname{diag}(3,3,9)$，两者不能混。）

**第四步：求逆并乘开。** 计算

$$P^{-1}=\begin{bmatrix}
-\tfrac12&0&\tfrac12\\[2pt]
\tfrac16&-\tfrac13&\tfrac16\\[2pt]
\tfrac43&\tfrac13&-\tfrac23
\end{bmatrix}$$

（逐项验算 $PP^{-1}=I$；课件此页 $P^{-1}$ 的 $(2,1)$ 元印作 $-\tfrac16$，应为 $+\tfrac16$，否则 $PP^{-1}\ne I$，见[勘误 E3.9](errata.md)）。于是

$$A=P\Lambda P^{-1}=\begin{bmatrix}
4&-2&1\\
-2&7&-2\\
1&-2&4
\end{bmatrix}.$$

**第五步：回代验算。** $A\boldsymbol x_1=(3,6,9)^{\mathrm T}=3\boldsymbol x_1$ ✓；$A\boldsymbol x_2=(3,3,3)^{\mathrm T}=3\boldsymbol x_2$ ✓；$A\boldsymbol x_3=(9,-18,9)^{\mathrm T}=9\boldsymbol x_3$ ✓；$A^{\mathrm T}=A$ ✓。

**谱分解预告**：由 $A$ 的谱分解（[3.7.4](sec37.md#sec-3.7.4)），$A=3E_1+9E_2$，其中 $E_2$ 是到 $\operatorname{span}\{\boldsymbol x_3\}$ 的正交投影：

$$E_2=\frac16\begin{bmatrix}1&-2&1\\ -2&4&-2\\ 1&-2&1\end{bmatrix},\qquad E_1=I-E_2=\frac16\begin{bmatrix}5&2&-1\\ 2&2&2\\ -1&2&5\end{bmatrix}.$$

直接验算 $3E_1+9E_2=3I+6E_2=A$ ✓。这组 $E_1,E_2$ 就是 [3.7](sec37.md) 要正式定义的谱阵。∎
:::
:::

最后两条推论把「酉矩阵 / 正交矩阵」也纳入了同一个框架：

::: cor 推论 3.6.6 · 酉矩阵的谱刻画 {#cor-3.6.6}

$n$ 阶复方阵 $A$ 是**酉矩阵**当且仅当 $A$ 的所有特征值的模值为 $1$，且存在酉矩阵 $U$ 使得

$$U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n),$$

其中 $\lambda_1,\cdots,\lambda_n$ 是 $A$ 的 $n$ 个特征值。
:::

::: cor 推论 3.6.7 · 正交矩阵的谱刻画 {#cor-3.6.7}

$n$ 阶实方阵 $A$ 是**正交矩阵**当且仅当 $A$ 的所有特征值的模值为 $1$，且存在酉矩阵 $U$ 使得

$$U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n),$$

其中 $\lambda_1,\cdots,\lambda_n$ 是 $A$ 的 $n$ 个特征值。
:::

::: proof 证明（课件未给，本编补：两个方向都用定理 3.6.2）

**（$\Rightarrow$）** 酉矩阵满足 $A^{\mathrm H}A=I=AA^{\mathrm H}$，故正规；由 [@thm-3.6.2] 存在酉 $U$ 使 $U^{\mathrm H}AU=\operatorname{diag}(\lambda_i)$。又由 [2.5](ch02/sec25.md) 的 [@thm-orth-eig]，酉（正交）矩阵的每个特征值模为 $1$。

**（$\Leftarrow$）** 若 $A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}$ 且 $|\lambda_i|=1$，则

$$A^{\mathrm H}A=U\operatorname{diag}(|\lambda_1|^2,\cdots,|\lambda_n|^2)U^{\mathrm H}=UIU^{\mathrm H}=I,$$

故 $A$ 是酉矩阵。实情形下 $A^{\mathrm H}=A^{\mathrm T}$，$A^{\mathrm T}A=I$ 即正交。
:::

::: note 注 4（课件原文）· 变换矩阵是酉矩阵 {#note-3.6-unitary-transform}

**正交阵酉相似对角化时的变换阵是酉矩阵。**

（本编补一句关键的辨析：这里的 $U$ 一般**不是实正交阵**。实正交矩阵的特征值可以是复数（[2.5](ch02/sec25.md) 的旋转阵 $\pm\mathrm i$），其特征向量也是复向量，所以对角化只能在 $\mathbb C$ 上、用酉矩阵完成。若硬要求 $Q$ 是实正交阵且 $Q^{\mathrm T}AQ$ 为实对角阵，则对角元（特征值）必须全实——旋转阵做不到。这正是 [3.5](sec35.md) 注 3「实阵警告」在谱分解里的回声。）
:::

::: note 本编补 · 注 4 的最小反例：旋转阵的酉对角化 {#note-3.6-rotation}

取 $A=\begin{bmatrix}0&-1\\ 1&0\end{bmatrix}$（平面旋转 $90^\circ$，实正交）。特征值 $\lambda_1=\mathrm i$、$\lambda_2=-\mathrm i$，模都为 $1$。对应的特征向量

$$\boldsymbol u_1=\frac{1}{\sqrt2}\begin{bmatrix}1\\ -\mathrm i\end{bmatrix}\ (\lambda=\mathrm i),\qquad
\boldsymbol u_2=\frac{1}{\sqrt2}\begin{bmatrix}1\\ \mathrm i\end{bmatrix}\ (\lambda=-\mathrm i).$$

令 $U=[\boldsymbol u_1,\boldsymbol u_2]=\dfrac{1}{\sqrt2}\begin{bmatrix}1&1\\ -\mathrm i&\mathrm i\end{bmatrix}$，则 $U^{\mathrm H}U=I_2$ 且

$$U^{\mathrm H}AU=\operatorname{diag}(\mathrm i,-\mathrm i).$$

但**不存在实正交** $Q$ 使 $Q^{\mathrm T}AQ$ 为对角阵：实正交相似保持实性，实对角阵的特征值全实，而 $A$ 的特征值是 $\pm\mathrm i$——矛盾。这个例子同时说明：**「正交矩阵」$\ne$「能用实正交阵对角化」**；后者只有对称阵才做得到（[@cor-3.6.4]）。
:::

::: ex 例 3.6.C（新增）· 正规与单纯的边界 {#ex-3.6.C}

（a）$A=\begin{bmatrix}1&1\\ 0&2\end{bmatrix}$ 是否单纯？是否正规？

（b）$B=\begin{bmatrix}1&1\\ -1&1\end{bmatrix}$ 是否正规？是否 Hermite？求出它的酉对角化。

::: sol 解答

**（a）单纯但不正规。** 特征值 $1,2$ 互异，由 [@cor-3.6.1] 可对角化（单纯）。但

$$A^{\mathrm T}A=\begin{bmatrix}1&1\\ 1&5\end{bmatrix},\qquad
AA^{\mathrm T}=\begin{bmatrix}2&2\\ 2&4\end{bmatrix},$$

两者不等，故 $A$ 不正规。特征向量 $(1,0)^{\mathrm T}$（$\lambda=1$）与 $(1,1)^{\mathrm T}$（$\lambda=2$）的内积为 $1$，不正交——这正是「单纯只保证有 $n$ 个独立特征向量，不保证它们正交」的实例。

**（b）正规但不是 Hermite。** 计算

$$B^{\mathrm T}B=\begin{bmatrix}1&-1\\ 1&1\end{bmatrix}\begin{bmatrix}1&1\\ -1&1\end{bmatrix}=\begin{bmatrix}2&0\\ 0&2\end{bmatrix},\qquad
BB^{\mathrm T}=\begin{bmatrix}1&1\\ -1&1\end{bmatrix}\begin{bmatrix}1&-1\\ 1&1\end{bmatrix}=\begin{bmatrix}2&0\\ 0&2\end{bmatrix},$$

故 $B$ 正规。但 $B^{\mathrm T}\ne B$，故不是 Hermite（也不是对称阵）。

**特征值与酉对角化**：$f_B(\lambda)=(\lambda-1)^2+1$，特征值 $1\pm\mathrm i$。对应特征向量：

$$\boldsymbol v_+=\frac{1}{\sqrt2}\begin{bmatrix}1\\ \mathrm i\end{bmatrix}\ (\lambda=1+\mathrm i),\qquad
\boldsymbol v_-=\frac{1}{\sqrt2}\begin{bmatrix}1\\ -\mathrm i\end{bmatrix}\ (\lambda=1-\mathrm i).$$

（验算：$B(1,\mathrm i)^{\mathrm T}=(1+\mathrm i,-1+\mathrm i)^{\mathrm T}=(1+\mathrm i)(1,\mathrm i)^{\mathrm T}$ ✓。）它们正交（$\boldsymbol v_+^{\mathrm H}\boldsymbol v_-=0$），令 $U=[\boldsymbol v_+,\boldsymbol v_-]=\dfrac{1}{\sqrt2}\begin{bmatrix}1&1\\ \mathrm i&-\mathrm i\end{bmatrix}$，则 $U^{\mathrm H}BU=\operatorname{diag}(1+\mathrm i,1-\mathrm i)$。

**几何读法**：$B=\begin{bmatrix}1&1\\ -1&1\end{bmatrix}=\sqrt2\begin{bmatrix}\cos45^\circ&\sin45^\circ\\ -\sin45^\circ&\cos45^\circ\end{bmatrix}$，是「旋转 $-45^\circ$ 再放大 $\sqrt2$ 倍」；特征值 $\sqrt2e^{\mp\mathrm i\pi/4}=1\pm\mathrm i$ 正是「放大倍数 $\times$ 旋转相角」。实正规矩阵的两类基本形态由此显形：**对称型**（特征值实、特征向量实）与**旋转–缩放型**（特征值共轭复、特征向量复）。∎
:::
:::

::: note 本编注 · 正规矩阵在矩阵世界里的位置 {#note-3.6-normal-class}

把本节的包含关系画成一张图：

$$\{\text{Hermite}\}\subset\{\text{正规}\}\subset\{\text{单纯}\},\qquad
\{\text{实对称}\}\subset\{\text{实正规}\}\subset\{\text{实单纯}\}.$$

- **Hermite $\subset$ 正规**：$A^{\mathrm H}=A\Rightarrow A^{\mathrm H}A=A^2=AA^{\mathrm H}$；
- **正规 $\subset$ 单纯**：定理 3.6.2 的酉对角化本身就是一种对角化；
- 两个包含都**严格**：例 3.6.C 的 $B$ 正规但非 Hermite；$A=\begin{bmatrix}1&1\\0&2\end{bmatrix}$ 单纯但非正规。

一个实用的判据链是：**实对称 / Hermite $\Rightarrow$ 正规 $\Rightarrow$ 单纯**；反过来每退一步都会丢掉「特征向量正交」或「酉变换」的保证。考试里若题目要求「求正交矩阵 $Q$」，前提必须是实对称（或至少实正规且特征值全实）；若只要求「求可逆矩阵 $P$」，单纯即可。
:::

::: preview 课程预告 · 从谱分解到奇异值分解

3.6 的酉对角化有一个前提：**同一个标准正交基**既要当定义域基、又要当值域基。一般矩阵 $A\in\mathbb C^{m\times n}$ 做不到这一点——它甚至不是方阵。但若允许**定义域与值域各用一组**标准正交基，则任意矩阵都能写成

$$A=U\Sigma V^{\mathrm H},$$

其中 $U,V$ 酉、$\Sigma$ 是非负对角阵。这就是**奇异值分解**（SVD）：它是「长方形矩阵的谱定理」，也是 [3.7](sec37.md) 谱分解的直接推广。3.7 先把方阵的谱分解写透，SVD 便只差「两组基」这一步。
:::

::: note 考情速递（本编依据课件小结与前章课堂考情整理；本讲无录播，未见老师原话）

课件小结页亲排：「**基本概念：单纯矩阵、酉相似对角化、正规矩阵；重要结论：判定单纯矩阵和正规矩阵充要条件；重要计算：正规矩阵酉相似对角化计算**」。三条对应三类题：**判断题**最爱考「充分 vs 充要」（互异特征值、无重根零化多项式、$m_A$ 无重根三者的层次，[注 3](sec36.md#note-3.6-sufficient)）；**计算大题**是「求 $P$ / 求正交 $Q$ 使 $P^{-1}AP$ 或 $Q^{\mathrm T}AQ$ 为对角阵」，评分点集中在重特征值内部的正交化与列序配对（例 3.6.6、例 3.6.7）；**证明题**的两条主干是「正规 $\iff$ 酉对角化」（[@thm-3.6.2]，Schur $+$ 上三角正规阵必对角）与「Hermite / 实对称的谱定理」（[@cor-3.6.3]、[@cor-3.6.4]）。跨章联动：2.4 的重数不等式、2.5 的酉矩阵特征值模为 $1$、3.5 的 Schur 型与最小多项式，在本节全部再次出场。分级清单与限时赛制集中在[考场竞技场](arena.md)。
:::

## 3.6 小结与常见错误

- **一条主线**：**Schur 兜底**（[@thm-3.5.2]：总可酉三角化）$\Rightarrow$ **对角化的五张面孔**（[@thm-3.6.1]：（1）存在 $P$ $\iff$（2）$n$ 个独立特征向量 $\iff$（3）$d_i=g_i$ $\iff$（4）$\sum\dim E=n$ $\iff$（5）$m_A$ 无重根）$\Rightarrow$ **两条判别口诀**（互异特征值——只是充分：[@cor-3.6.1]；存在无重根零化多项式——按字面是充要，真正的充要是 $m_A$ 无重根：[@cor-3.6.2]、[@note-3.6-sufficient]）$\Rightarrow$ **两笔红利**（$A^m=P\Lambda^mP^{-1}$：[@ex-3.6.3]；$\dot{\boldsymbol x}=A\boldsymbol x$ 解耦：[@ex-3.6.4]）$\Rightarrow$ **几何升级**（酉相似：[@def-3.6.2]；Hermite / 实对称：[@cor-3.6.3]、[@cor-3.6.4]；例 3.6.5、例 3.6.6）$\Rightarrow$ **完整答案**（正规矩阵：[@thm-3.6.2]；特征向量版：[@cor-3.6.5]；酉 / 正交矩阵：[@cor-3.6.6]、[@cor-3.6.7]）。
- **两句话记住它**：**对角化 $=$ 特征向量「够用」**——$n$ 个线性无关，等价于每个特征值的几何重数追平代数重数，等价于最小多项式无重根。**酉对角化 $=$ 特征向量「够用且互相垂直」**——这把 $P$ 升级成 $U$，把「相似」升级成「酉相似」，完整的门槛是正规性 $A^{\mathrm H}A=AA^{\mathrm H}$。

| 名称 | 分解式 | 特征向量 | 特征值 | 变换矩阵 |
|:--|:--|:--|:--|:--|
| 单纯（可对角化） | $P^{-1}AP=\Lambda$ | $n$ 个线性无关 | 任意复 | $P$ 可逆 |
| 正规 | $U^{\mathrm H}AU=\Lambda$ | $n$ 个标准正交 | 任意复 | $U$ 酉 |
| Hermite | $U^{\mathrm H}AU=\Lambda$ | $n$ 个标准正交 | 全实 | $U$ 酉 |
| 实对称 | $Q^{\mathrm T}AQ=\Lambda$ | $n$ 个标准正交（实） | 全实 | $Q$ 实正交 |

（读法：从上到下前提越来越强，结论也越来越强：特征向量从「够用」升级到「正交」，变换矩阵从「可逆」升级到「酉 / 实正交」，特征值从「任意复」收紧到「全实」。）

::: think 常见错误清单 · 自查六条

1. **把「单纯」与「正规」混为一谈**：单纯只要求 $n$ 个独立特征向量，正规还要求它们正交。$\begin{bmatrix}1&1\\0&2\end{bmatrix}$ 单纯但不正规（[@ex-3.6.C]）；反过来正规一定单纯（[@thm-3.6.2]）。
2. **把充分条件当必要条件（或把「每个」偷换成「存在」）**：$n$ 个互异特征值 $\Rightarrow$ 单纯，但 $I_n$ 说明反之不然；「**存在**无重根零化多项式」其实是**充要**的（取 $g=m_A$），容易错的是把它读成「**每个**零化多项式都无重根」——$I_2$ 的 $f_A=(\lambda-1)^2$ 就是反例。真正要背的层次见 [@note-3.6-sufficient]。
3. **几何重数算错**：$g_i=n-\operatorname{rank}(A-\lambda_iI)$（[@thm-geom-mult]），不是 $n-\operatorname{rank}(\lambda_iI-A)$ 的符号问题（两者秩相同），也不是「特征向量的个数」——要的是**线性无关**的个数。
4. **重特征值内部忘记正交化**：实对称 / 正规矩阵只在**不同**特征值之间免费正交；同一特征子空间内随便取基可能斜（例 3.6.6 的 $\boldsymbol x_2,\boldsymbol x_3,\boldsymbol x_4$），必须 Gram–Schmidt。
5. **$P$ 与 $\Lambda$ 的列序错配**：$P$ 的第 $j$ 列必须对应 $\Lambda$ 的第 $j$ 个对角元；写 $P^{-1}AP$ 还是 $PAP^{-1}$、$AP=P\Lambda$ 还是 $PA=P\Lambda$，也要一致。
6. **实矩阵硬套复结论**：实正交矩阵的特征值可以是复数（旋转阵 $\pm\mathrm i$），其特征向量是复向量，酉对角化中的 $U$ 一般不是实正交阵（[@note-3.6-unitary-transform]）；要求实正交 $Q$ 时，前提是实对称（[@cor-3.6.4]），不是「实正规」就够。
:::

::: ex 即时自测（不看上文，5 分钟）{#ex-3.6.quiz}

1. 复述 [@thm-3.6.1] 的五条，并说出（3）与（4）为什么等价、（5）的证明里 $E_j=f_j(A)/f_j(\lambda_j)$ 起什么作用；
2. 判断 $A=\begin{bmatrix}2&0&0\\ 1&2&0\\ 0&0&3\end{bmatrix}$ 是否可对角化，并说明理由；
3. $A=\begin{bmatrix}0&1\\ 1&0\end{bmatrix}$ 是实对称阵：求正交 $Q$ 使 $Q^{\mathrm T}AQ$ 为对角阵，并写出 $\Lambda$；
4. $A=\begin{bmatrix}1&1\\ 0&2\end{bmatrix}$ 可对角化吗？正规吗？这两件事的差别用一句话说清；
5. 证明：若 $A$ 正规且 $A^2=A$，则 $A$ 是 Hermite 矩阵（即正交投影）。

::: sol 参考要点

1. 五条见 [@thm-3.6.1]。（3）$\iff$（4）：$\sum d_i=n$ 恒成立、$g_i\le d_i$，故「每个 $g_i=d_i$」与「$\sum g_i=n$」等价。（5）的 $E_j$ 是**投影多项式**：$\sum E_j=I$、$E_iE_j=0$、$(A-\lambda_jI)E_j=O$，于是任意 $\boldsymbol x=\sum E_j\boldsymbol x$ 被拆成特征向量之和，$\mathbb C^n=\oplus E(\lambda_j)$。
2. **不可对角化**。$f_A=(\lambda-2)^2(\lambda-3)$；$\lambda=2$ 的代数重数 $2$，而 $A-2I=\begin{bmatrix}0&0&0\\1&0&0\\0&0&1\end{bmatrix}$ 的秩为 $2$，几何重数 $3-2=1<2$——（3）不成立。也可用最小多项式：$m_A=(\lambda-2)^2(\lambda-3)$ 有重根。
3. $A$ 的特征值 $1,-1$，特征向量 $(1,1)^{\mathrm T}/\sqrt2$、$(1,-1)^{\mathrm T}/\sqrt2$。$Q=\dfrac{1}{\sqrt2}\begin{bmatrix}1&1\\ 1&-1\end{bmatrix}$（对称正交，$Q^{\mathrm T}=Q$），$Q^{\mathrm T}AQ=\operatorname{diag}(1,-1)$。
4. **可对角化**（特征值 $1,2$ 互异）；**不正规**（$A^{\mathrm T}A\ne AA^{\mathrm T}$，见 [@ex-3.6.C]）。一句话：可对角化只要求特征向量「够用」，正规还要求它们「互相垂直」——前者是相似，后者是酉相似。
5. $A$ 正规 $\Rightarrow$ 由 [@thm-3.6.2] 存在酉 $U$ 使 $A=U\Lambda U^{\mathrm H}$，$\Lambda=\operatorname{diag}(\lambda_i)$。$A^2=A\Rightarrow\Lambda^2=\Lambda\Rightarrow\lambda_i\in\{0,1\}$，全为实数；于是 $A^{\mathrm H}=U\Lambda^{\mathrm H}U^{\mathrm H}=U\Lambda U^{\mathrm H}=A$，即 $A$ 是 Hermite 矩阵。又 $A^2=A=A^{\mathrm H}$，故 $A$ 是正交投影（[3.7.3](sec37.md#def-3.7.3)）。
:::
:::

> **下一节**：[3.7 谱分解与幂等阵](sec37.md) 把 $A=P\Lambda P^{-1}$ 按特征值拆成 $A=\sum_j\lambda_jE_j$——特征值是系数，谱阵是投影。
