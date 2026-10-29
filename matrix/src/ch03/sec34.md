# 3.4 QR 分解

[3.2](sec32.md) 的满秩分解把 $A$ 拆成「基 $\times$ 坐标」：$B$ 的列撑起列空间，$C$ 逐列记账。但这组基是**斜的**——第一章 [1.5](../ch01/sec15.md) 已经算过账：在斜基下做内积要拖着度量矩阵，在标准正交基下一切公式都短（[@ex-1.5.B] 末尾那句「这正是标准正交基的价值」）。而 [1.5.6](../ch01/sec15.md#sec-1.5.6) 的 Gram–Schmidt 正交化恰好保证：**任何一组基都能掰成标准正交基**。把这两件事拼起来，就得到本章的又一副眼镜——把满秩分解里的「斜骨架」掰直，让左因子成为**酉矩阵**：

$$A=QR,\qquad Q\ \text{酉}，\ R\ \text{上三角}.$$

右边这个形状就是**QR 分解**。它在本节先以「方阵分解定理」的面貌出现（满秩方阵存在、且在「正线」约定下唯一，[@thm-3.4.1]），随后被推广到长方阵（[@cor-3.4.1]），最后变成一台机器——**QR 算法**：反复做 QR 分解，就能把矩阵的**全部特征值**一个一个挤到对角线上（[@method-qr-algo]）。一台「分解」喂养出一台「算法」，这是本章前面两节没有的待遇。

::: note 素材与说明（本节无录播）

本页依据课程第三章课件 **3.4 QR 分解**（16 页，存于 `_sources/matrix/3.4-QR分解.pdf`）整理。**本节无对应录播**，故不引用课堂口述与时间戳：课件的定义、定理、注记与例题**照录并保留原编号**（定义 3.4.1、定理 3.4.1、注 1、例 3.4.1–例 3.4.4、定义 3.4.2、推论 3.4.1）；课件省略的证明（定理 3.4.1 的唯一性、推论 3.4.1 的构造）由本编补出并逐处标注「本编补」；例 3.4.3、例 3.4.4 的课件笔误见[勘误与补注](errata.md)（E3.6、E3.7），正文按核算后的自洽写法演算。本编新增例题用字母编号（[@ex-3.4.A]、[@ex-3.4.B]）。
:::

<a id="sec-3.4.1"></a>

## 3.4.1 定义与分解定理：把「骨架」掰直

先交代定义。课件把复、实两个版本并列给出——差别只在「酉 / 正交」这一对词：

::: def 定义 3.4.1 · QR 分解（酉三角分解 / 正交三角分解） {#def-3.4.1}

若复方阵 $A$ 可分解为

$$A=QR,$$

其中 $Q$ 为**酉矩阵**，$R$ 为**上三角矩阵**，则称矩阵 $A$ 可作 **QR 分解**或**酉三角分解**。若在分解式 $A=QR$ 中，矩阵 $A$ 是实方阵，$Q$ 为**正交矩阵**，$R$ 为上三角矩阵，则称分解式 $A=QR$ 为**正交三角分解**。
:::


课件紧接着抛出思考题：**复方阵 $A$ 在何种条件下可进行 QR 分解？** 答案是：满秩就够了——而且满秩时还能附送一份「唯一性」，前提是给 $R$ 戴上一条约定：**「正线上三角阵」指对角元素全为正实数的上三角矩阵**（课件在定理 3.4.1 中首次使用这个词，此处先立此存照）。

::: thm 定理 3.4.1 · QR 分解定理 {#thm-3.4.1}

若复方阵 $A$ 满秩，则存在酉矩阵 $Q$ 及正线上三角阵 $R$ 满足

$$A=QR$$

**且分解唯一**。
:::


课件给的分析只有三行，但字字有用——它把 QR 分解放回了 [1.3](../ch01/sec13.md) 的「换基」框架：

> 记 $A=[\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n]$，$Q=[\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n]$，则 $\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n$ 和 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n$ 均为 $\mathbb C^n$ 的一组基。根据 QR 分解式知 $[\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n]=[\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n]R$，其中矩阵 $R$ 是**从基 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n$ 到基 $\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n$ 的过渡矩阵**。

于是「$A$ 能否 QR 分解」被翻译成：「能否选一组标准正交基 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n$，使得旧基 $\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n$ 在它下的过渡矩阵 $R$ 是**上三角**（再配正对角）」。而 Gram–Schmidt（[@method-gs]）恰好就是干这个的：它的构造顺序「先定 $\boldsymbol{z}_1$，再用 $\boldsymbol{z}_1$ 加工 $\boldsymbol{z}_2$，……」天然保证**每个 $\boldsymbol{a}_k$ 只用到前 $k$ 个 $\boldsymbol{z}$**——这正是「上三角」三个字的算法化身。

::: proof 存在性证明（课件路线：Gram–Schmidt 即算法，本编展开）

$A$ 满秩 $\Rightarrow$ $\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n$ 线性无关，是 $\mathbb C^n$ 的基。对它执行 Gram–Schmidt（[@method-gs]）并单位化：

$$\boldsymbol{y}_1=\boldsymbol{a}_1,\qquad
\boldsymbol{y}_k=\boldsymbol{a}_k-\sum_{i=1}^{k-1}(\boldsymbol{a}_k,\boldsymbol{z}_i)\,\boldsymbol{z}_i,\qquad
\boldsymbol{z}_k=\frac{\boldsymbol{y}_k}{\|\boldsymbol{y}_k\|},\quad k=2,\cdots,n,$$

（标准正交组下 $\dfrac{(\boldsymbol{a}_k,\boldsymbol{z}_i)}{(\boldsymbol{z}_i,\boldsymbol{z}_i)}=(\boldsymbol{a}_k,\boldsymbol{z}_i)$；各 $\boldsymbol{y}_k\neq\boldsymbol{0}$ 由列无关保证——若 $\boldsymbol{y}_k=\boldsymbol{0}$，则 $\boldsymbol{a}_k$ 落进前 $k-1$ 列的张成，[@method-gs] 的「张成不变」）。把构造式移项：

$$\boldsymbol{a}_k=\sum_{i=1}^{k-1}(\boldsymbol{a}_k,\boldsymbol{z}_i)\,\boldsymbol{z}_i+\|\boldsymbol{y}_k\|\,\boldsymbol{z}_k
=\sum_{i=1}^{k}r_{ik}\boldsymbol{z}_i,\qquad
r_{ik}=\begin{cases}(\boldsymbol{a}_k,\boldsymbol{z}_i),& i<k,\\[2pt] \|\boldsymbol{y}_k\|,& i=k,\end{cases}$$

即 $[\boldsymbol{a}_1,\cdots,\boldsymbol{a}_n]=[\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n]R$，$R$ 的元素恰如课件所列：

$$R=\begin{bmatrix}
\|\boldsymbol{y}_1\|&(\boldsymbol{a}_2,\boldsymbol{z}_1)&\cdots&(\boldsymbol{a}_n,\boldsymbol{z}_1)\\
&\|\boldsymbol{y}_2\|&\cdots&(\boldsymbol{a}_n,\boldsymbol{z}_2)\\
&&\ddots&\vdots\\
\boldsymbol{0}&&&\|\boldsymbol{y}_n\|
\end{bmatrix}.$$

令 $Q=[\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n]$：各列标准正交的方阵是酉矩阵（[@thm-orth-columns]），而 $R$ 是上三角阵、对角元 $\|\boldsymbol{y}_k\|>0$ 为正实数——正线 ✓。故 $A=QR$ 为所求分解。∎
:::


（注意对角元是**残差 $\boldsymbol{y}_k$ 的范数**，不是 $\|\boldsymbol{a}_k\|$：先减掉在已有方向上的成分，剩下的才量长度。另外本节内积沿用全书的「第一变元线性」约定（[@def-1.4.1] 后的说明），系数 $(\boldsymbol{a}_k,\boldsymbol{z}_i)$ 正是按这个约定从移项中读出来的。）

课件对唯一性只字未证。它值得补——因为证明里藏着一个此后反复使用的小事实（上三角的酉阵必为对角阵）：

::: proof 唯一性证明（课件未给，本编补：相差的只能是对角酉阵）

设 $A=Q_1R_1=Q_2R_2$，两组都满足「$Q_i$ 酉、$R_i$ 正线上三角」。**满秩在这里进场**：$\operatorname{rank}R_i=\operatorname{rank}A=n$（乘酉矩阵不改秩，[@thm-sim-invariants] 的秩款），故 $R_1$、$R_2$ 可逆。于是

$$Q_2^{\mathrm H}Q_1=R_2R_1^{-1}=:W .$$

左边是酉矩阵之积，仍是酉矩阵（[@thm-orth-algebra]）；右边是上三角阵之积再求逆，仍是上三角阵，且对角元 $=$ 正 $/$ 正 $>0$。下面证明：**既是上三角又是酉、且对角为正的矩阵只能是 $I$**。对列归纳：

- 第 $1$ 列只有 $w_{11}$ 一个可能非零的分量（下三角部分为零），而酉矩阵各列范数为 $1$，故 $|w_{11}|=1$；
- 设前 $j-1$ 列已是 $\boldsymbol{e}_1,\cdots,\boldsymbol{e}_{j-1}$。第 $j$ 列与它们正交：$\langle\text{列}j,\text{列}i\rangle=\overline{w_{ii}}\,w_{ij}=0$，逐个推出 $w_{ij}=0$（$i<j$）；再由范数 $1$ 得 $|w_{jj}|=1$。

于是 $W$ 是对角阵且 $|w_{ii}|=1$；对角为正实数迫使 $w_{ii}=1$，即 $W=I$。代回：$Q_2^{\mathrm H}Q_1=I\Rightarrow Q_1=Q_2$，$R_2R_1^{-1}=I\Rightarrow R_2=R_1$。∎

**读出两件事**：① 唯一性的全部关键在「正线」——它把对角酉阵那一圈自由度（相角 / 正负号）锁死成 $1$；② 证明第一步就用了 $R_1$ 可逆，**不满秩时论证整体失效**（届时分解是否存在、是否唯一都要重新问，见 [3.4.2](#sec-3.4.2) 的例 3.4.2）。
:::

先看手算一遍的感觉——一个小而完整的 GS 分解：

::: ex 例 3.4.A（新增）· 用 Gram–Schmidt 手算一个 QR 分解 {#ex-3.4.A}

求 $A=\begin{bmatrix}3&1\\ 4&2\end{bmatrix}$ 的 QR 分解（$Q$ 正交、$R$ 正线上三角）。

::: sol 解答

$\det A=2\neq0$，满秩 ✓，可套 [@thm-3.4.1]。记 $\boldsymbol{a}_1=(3,4)^{\mathrm T}$、$\boldsymbol{a}_2=(1,2)^{\mathrm T}$。

**第一步（正交化）**：$\boldsymbol{y}_1=\boldsymbol{a}_1$，$\|\boldsymbol{y}_1\|=5$，$\boldsymbol{z}_1=\left(\tfrac35,\tfrac45\right)^{\mathrm T}$；

$$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac35+\tfrac85=\tfrac{11}{5},\qquad
\boldsymbol{y}_2=\boldsymbol{a}_2-\tfrac{11}{5}\boldsymbol{z}_1=\left(-\tfrac{8}{25},\ \tfrac{6}{25}\right)^{\mathrm T},\qquad
\|\boldsymbol{y}_2\|=\tfrac{2}{5},\ \ \boldsymbol{z}_2=\left(-\tfrac45,\ \tfrac35\right)^{\mathrm T}.$$

**第二步（读出 $R$）**：$r_{11}=\|\boldsymbol{y}_1\|=5$，$r_{22}=\|\boldsymbol{y}_2\|=\tfrac25$，$r_{12}=(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{11}{5}$。

**拼装与验算**：

$$Q=\begin{bmatrix}\tfrac35&-\tfrac45\\ \tfrac45&\tfrac35\end{bmatrix},\qquad
R=\begin{bmatrix}5&\tfrac{11}{5}\\ 0&\tfrac25\end{bmatrix},\qquad
QR=\begin{bmatrix}3&\tfrac{33}{25}-\tfrac{8}{25}\\ 4&\tfrac{44}{25}+\tfrac{6}{25}\end{bmatrix}=\begin{bmatrix}3&1\\ 4&2\end{bmatrix}=A\ \checkmark$$

且 $Q^{\mathrm T}Q=I$、$\det Q=\tfrac{9}{25}+\tfrac{16}{25}=1$ ✓，$R$ 正线上三角 ✓。

**读法**：$R$ 是「从 $\boldsymbol{z}$ 基到 $\boldsymbol{a}$ 基」的过渡矩阵——$\boldsymbol{a}_2=\tfrac{11}{5}\boldsymbol{z}_1+\tfrac25\boldsymbol{z}_2$ 正是 $R$ 第二列。另外这个 $Q=\begin{bmatrix}\cos\theta&-\sin\theta\\ \sin\theta&\cos\theta\end{bmatrix}$（$\cos\theta=\tfrac35$，$\sin\theta=\tfrac45$）就是 [2.5](../ch02/sec25.md) 的 **Givens 旋转**（[@def-givens]）：二维的 QR 分解 = 把坐标系转正——这不是巧合，是把平面「掰直」的代数痕迹。∎
:::
:::

课件用一个最小的反例说明「正线」这根线不能抽掉：

::: note 注 1（课件原文）· 不要求对角元为正实数，则 QR 分解不唯一 {#note-3.4-sign}

若不要求上三角阵 $R$ 的对角元素全为正实数，则导致矩阵 $A$ 的 QR 分解不唯一。
:::

::: ex 例 3.4.1（课件原文）· 单位阵的两种 QR 分解 {#ex-3.4.1}

考查 $I_2$ 的 QR 分解：

$$I_2=\begin{bmatrix}1&0\\ 0&1\end{bmatrix}\begin{bmatrix}1&0\\ 0&1\end{bmatrix}\triangleq QR,\qquad
I_2=\begin{bmatrix}-1&0\\ 0&1\end{bmatrix}\begin{bmatrix}-1&0\\ 0&1\end{bmatrix}\triangleq Q_1R_1 .$$

两个分解里的 $Q$、$Q_1$ 都是正交矩阵、$R$、$R_1$ 都是上三角矩阵，但 $R_1$ 的第一个对角元是 $-1$——正线被破坏，唯一性随之失效。

（本编补一句：$I_2$ 的这两个分解连 $R$ 都不同，说明自由度在「符号 / 相角」而不只在 $Q$；下一个注把自由度数清。）
:::


::: note 本编补注 · 不唯一的程度：恰好相差一个对角酉阵

唯一性证明的最后一步其实已经把账算清了：若 $A=QR=Q'R'$ 是满秩方阵的两种 QR 分解（只要求 $R$、$R'$ 为**可逆**上三角阵），则

$$W=R'R^{-1}=Q'^{\mathrm H}Q$$

既是酉阵又是上三角阵，故 $W=\operatorname{diag}(w_1,\cdots,w_n)$，$|w_i|=1$（上面归纳证明的前半段，不需要正线）。于是**任意两种分解恰好相差一个对角酉阵**：

$$Q'=QW,\qquad R'=W^{\mathrm H}R\quad(\text{对角元变为 }\overline{w_i}\,r_{ii}).$$

- **实方阵**：$w_i=\pm1$，故 $n$ 阶实满秩方阵恰有 $2^n$ 种 QR 分解——「正线」从 $2^n$ 里选出唯一的 $1$ 个；
- **复方阵**：$w_i=e^{\mathrm i\theta_i}$ 可以连续取值，不要求正线时分解有无穷多（一族 $n$ 维相角）。

这也解释了注 1 的措辞为什么是「**导致**不唯一」：正线不是存在性条件，而是从这一族分解里**挑出唯一代表**的规约。
:::

::: ex 例 3.4.B（新增 · 承接例 3.4.A）· 数清一个矩阵的全部 QR 分解 {#ex-3.4.B}

写出 $A=\begin{bmatrix}3&1\\ 4&2\end{bmatrix}$（[@ex-3.4.A]）的**全部** QR 分解（$Q$ 正交、$R$ 可逆上三角，不要求正线），并指出其中哪一个是正线版本。

::: sol 解答

由本编补注，全部分解由对角正交阵 $D=\operatorname{diag}(\pm1,\pm1)$ 从正线版本 $(Q,R)$ 生成：$(QD,\ DR)$。共 $2^2=4$ 种：

$$\begin{aligned}
&\left(\begin{bmatrix}\tfrac35&-\tfrac45\\ \tfrac45&\tfrac35\end{bmatrix},\ \begin{bmatrix}5&\tfrac{11}{5}\\ 0&\tfrac25\end{bmatrix}\right),
&&\left(\begin{bmatrix}-\tfrac35&-\tfrac45\\ -\tfrac45&\tfrac35\end{bmatrix},\ \begin{bmatrix}-5&-\tfrac{11}{5}\\ 0&\tfrac25\end{bmatrix}\right),\\[6pt]
&\left(\begin{bmatrix}\tfrac35&\tfrac45\\ \tfrac45&-\tfrac35\end{bmatrix},\ \begin{bmatrix}5&\tfrac{11}{5}\\ 0&-\tfrac25\end{bmatrix}\right),
&&\left(\begin{bmatrix}-\tfrac35&\tfrac45\\ -\tfrac45&-\tfrac35\end{bmatrix},\ \begin{bmatrix}-5&-\tfrac{11}{5}\\ 0&-\tfrac25\end{bmatrix}\right).
\end{aligned}$$

（验算其一：$D=\operatorname{diag}(1,-1)$ 时 $(QD)(DR)=Q D^2 R=QR=A$ ✓，且 $DR$ 仍上三角、对角 $(5,-\tfrac25)$。）**正线版本只有第一个**——$r_{11}>0$ 逼出 $d_1=1$，$r_{22}>0$ 逼出 $d_2=1$，两条合起来 $D=I$。∎
:::
:::

<a id="sec-3.4.2"></a>

## 3.4.2 放宽前提：不满秩与长方阵

::: note 课堂信号（10-15）· 考试给的是「不满秩」矩阵

老师明确说：**考试和测试时通常不会给满秩矩阵，而是给一个不满秩矩阵做 QR 分解**（10-15 00:41）；**长方阵的 QR 分解也考过**（10-15 00:42）。所以本节不是「拓展阅读」，而是**考试主战场**：GS 中途遇到零残差怎么办、$R$ 的对角元出现 $0$ 后唯一性如何失效、长方阵如何补列——都要能独立走完。原话见[课堂口述与考点信号](../lecture-signals.md)。
:::

定理 3.4.1 只管满了秩的方阵。课件接着追问两步：**不满秩的复方阵是否可作 QR 分解？长方矩阵呢？** 两个答案都在例子里。

::: ex 例 3.4.2（课件原文）· 不满秩方阵：分解仍在，正线没了 {#ex-3.4.2}

考察矩阵 $A=\begin{bmatrix}1&1\\ 0&0\end{bmatrix}$ 的 QR 分解。

::: sol 解答（课件路线，本编补细节）

$\operatorname{rank}A=1<2$：不满秩。取 $\boldsymbol{a}_1=(1,0)^{\mathrm T}$，它张成列空间 $R(A)$ 且已是单位向量——$R(A)$ 的标准正交基；再补 $\boldsymbol{e}_2$ 得 $\mathbb C^2$ 的标准正交基，于是 $Q=I_2$，且

$$A=\begin{bmatrix}1&0\\ 0&1\end{bmatrix}\begin{bmatrix}1&1\\ 0&0\end{bmatrix}\triangleq QR,$$

其中 $R$ 的第二行全零（$\boldsymbol{a}_2=\boldsymbol{a}_1$ 落在已有方向上，GS 的残差 $\boldsymbol{y}_2=\boldsymbol{0}$）——**$R$ 不再是正线上三角矩阵**（$r_{22}=0$）。

（本编补：此时 [@thm-3.4.1] 的唯一性彻底失效——$R$ 不可逆，唯一性证明第一步就走不动；而且自由度比「对角酉阵」大得多：第二个标准正交向量可换成 $e^{\mathrm i\theta}\boldsymbol{e}_2$（任意相角），更高维、秩亏更多的情形里，「补齐」一列甚至可以在整个正交补里任选。结论：**存在性常在，唯一性需要满秩 $+$ 正线**。）∎
:::
:::


长方阵的例子需要先安一个定义——「列正交」的矩阵不必是方阵，酉矩阵的刻画（[@thm-orth-columns]）要放宽使用：

::: def 定义 3.4.2 · 列 / 行正交规范矩阵 {#def-3.4.2}

设 $Q\in\mathbb C^{m\times n}$。若

$$Q^{\mathrm H}Q=I_n,$$

则矩阵 $Q$ 称为**列正交规范矩阵**，$Q^{\mathrm H}$ 称为**行正交规范矩阵**。
:::


（读法：$Q^{\mathrm H}Q=I_n$ 逐元读出即「各列长度 $1$、两两正交」——正是 [@thm-orth-columns] 对**长方**情形的自然放宽：$n$ 列标准正交，但 $m>n$ 时它们只是 $\mathbb C^m$ 的一部分基。注意 $QQ^{\mathrm H}\neq I_m$（把 $m$ 维向量先压到 $n$ 维再放回去，补空间被抹掉了），故**列正交规范的长方阵不是酉矩阵**。它自动列满秩，$Q^{\mathrm H}$ 是它的一个左逆——[@thm-3.1.1] 的一号应用；它还保范：$\|Q\boldsymbol{x}\|^2=\boldsymbol{x}^{\mathrm H}Q^{\mathrm H}Q\boldsymbol{x}=\|\boldsymbol{x}\|^2$。）

::: ex 例 3.4.3（课件原文，含一处课件笔误，见 E3.6）· 长方矩阵的分解 {#ex-3.4.3}

考察矩阵 $B=\begin{bmatrix}3&3\\ 0&1\\ 4&4\end{bmatrix}$（$3\times2$，列满秩）的分解问题。

::: sol 解答（课件路线；B 的 $(3,2)$ 元课件印作 $0$，据其后全部公式反推应为 $4$，见勘误 E3.6）

**第一步（GS 正交化两列）**：$\boldsymbol{a}_1=(3,0,4)^{\mathrm T}$，$\|\boldsymbol{a}_1\|=5$，$\boldsymbol{z}_1=\left(\tfrac35,0,\tfrac45\right)^{\mathrm T}$；

$$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{9}{5}+\tfrac{16}{5}=5,\qquad
\boldsymbol{y}_2=\boldsymbol{a}_2-5\boldsymbol{z}_1=(0,1,0)^{\mathrm T},\qquad
\|\boldsymbol{y}_2\|=1,\ \ \boldsymbol{z}_2=(0,1,0)^{\mathrm T}.$$

（$\boldsymbol{y}_2$ 正好落在 $\boldsymbol{e}_2$ 上——这正是课件选这组数据的原因：第二列减掉在 $\boldsymbol{z}_1$ 上的成分后残差是现成的坐标向量。）

$$B=\begin{bmatrix}\tfrac35&0\\ 0&1\\ \tfrac45&0\end{bmatrix}\begin{bmatrix}5&5\\ 0&1\end{bmatrix}\triangleq Q_1R_1,\qquad Q_1\in\mathbb C^{3\times2},\ R_1\in\mathbb C^{2\times2},$$

其中 $Q_1$ 是列正交规范矩阵（验算 $Q_1^{\mathrm H}Q_1=I_2$ ✓），$R_1$ 是正线上三角阵 ✓。验算 $Q_1R_1$：第一列 $5\boldsymbol{z}_1=(3,0,4)^{\mathrm T}$ ✓，第二列 $5\boldsymbol{z}_1+\boldsymbol{z}_2=(3,1,4)^{\mathrm T}$ ✓。∎
:::
:::


::: ex 例 3.4.3 续（课件原文）· 补齐成完全分解

再考察矩阵 $B=\begin{bmatrix}3&3\\ 0&1\\ 4&4\end{bmatrix}$ 的分解问题：把 $Q_1$ 的两列补齐 $\mathbb C^3$ 的一组标准正交基。

::: sol 解答（第二步：补齐）

**补齐 $\mathbb C^3$ 的标准正交基**：再取 $\boldsymbol{z}_3=\left(-\tfrac45,0,\tfrac35\right)^{\mathrm T}$——与 $\boldsymbol{z}_1$（内积 $-\tfrac{12}{25}+\tfrac{12}{25}=0$ ✓）、$\boldsymbol{z}_2$（内积 $0$ ✓）都正交且单位。于是

$$Q_1=\begin{bmatrix}\tfrac35&0\\ 0&1\\ \tfrac45&0\end{bmatrix}\ \longrightarrow\ Q=\begin{bmatrix}\tfrac35&0&-\tfrac45\\ 0&1&0\\ \tfrac45&0&\tfrac35\end{bmatrix}\quad(\text{酉矩阵})，$$

$$B=\begin{bmatrix}\tfrac35&0&-\tfrac45\\ 0&1&0\\ \tfrac45&0&\tfrac35\end{bmatrix}\begin{bmatrix}5&5\\ 0&1\\ 0&0\end{bmatrix}=QR .$$

$R=\begin{bmatrix}R_1\\ \boldsymbol{0}\end{bmatrix}_{3\times2}$：上面是 $2\times2$ 正线上三角 $R_1$，下面垫一行零。∎
:::
:::


把这个例子的结构抽出来，就是课件的推论——**列满秩长方阵的完全 QR 分解**：

::: cor 推论 3.4.1 · 列满秩长方阵 {#cor-3.4.1}

设 $A\in\mathbb C^{m\times n}_n$（列满秩，$n\le m$），则 $A$ 可分解为

$$A=UR,\qquad R=\begin{bmatrix}R_1\\ \boldsymbol{0}_{(m-n)\times n}\end{bmatrix}_{m\times n},$$

其中 $U$ 是 $m$ 阶酉矩阵，$R_1$ 为正线上三角阵。
:::


::: proof 证明（课件未给，本编补：GS $+$ 基扩充）

**GS**：$A$ 列满秩 $\Rightarrow$ 各列线性无关 $\Rightarrow$ GS 各步残差 $\boldsymbol{y}_k\neq\boldsymbol{0}$，得标准正交组 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n$ 与 $A=Q_1R_1$（$Q_1\in\mathbb C^{m\times n}$ 列正交规范，$R_1$ 正线上三角——[@thm-3.4.1] 存在性证明逐字照搬，只是不再补满 $n$ 列）。

**补齐**：把 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n$ 扩充为 $\mathbb C^m$ 的一组基（[@cor-1.3.1]），再对扩充后的整组做 GS——由「张成不变」（[@method-gs]），**前 $n$ 个向量原封不动**，只把新添的向量逐一正交化、单位化，得标准正交基 $\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n,\boldsymbol{z}_{n+1},\cdots,\boldsymbol{z}_m$。令 $U=[\boldsymbol{z}_1,\cdots,\boldsymbol{z}_m]$（列标准正交的方阵，酉，[@thm-orth-columns]），则

$$U\begin{bmatrix}R_1\\ \boldsymbol{0}\end{bmatrix}=[\boldsymbol{z}_1,\cdots,\boldsymbol{z}_n]R_1+\boldsymbol{0}=Q_1R_1=A.\qquad\blacksquare$$
:::

::: note 读法（本编提炼）· QR 分解是满秩分解的「正交升级」

对照 [3.2](sec32.md)：满秩分解 $A=BC$ 里，$B$ 的列是 $R(A)$ 的**任意**一组基。现在 [@cor-3.4.1] 说：$A$ 列满秩时，把 $B$ 的列**掰成标准正交基**（$Q_1$）、坐标表 $C$ 就自动变成**上三角**（$R_1$）：

$$A=\underbrace{Q_1}_{B\ \text{的正交版}}\ \underbrace{R_1}_{C\ \text{的上三角版}}\qquad\text{（列满秩时 } r=n \text{）}.$$

「上三角」的含义在过渡矩阵读法里看得分明：**每个 $\boldsymbol{a}_k$ 只用前 $k$ 个标准正交方向表出**——第 $k$ 根梁只搭在更早立好的轴上。所以 QR 分解 = 满秩分解 $+$ 「基按 GS 顺序立轴」。方阵满秩时（[@thm-3.4.1]），$A=QR$ 本身就是一个满秩分解（$Q$ 列满秩、$R$ 满秩方阵自然行满秩）；不满秩时（例 3.4.2 型），坐标表出现**零行**——对应 GS 中「残差为零、无需新轴」的退化步。
:::

::: method 用刚算出的 QR 做一次最小二乘

例 3.4.3 已得 $B=Q_1R_1$。分解不仅可以验乘积，还能回答：若 $B\boldsymbol{x}=\boldsymbol{b}$ 无精确解，怎样找离 $\boldsymbol{b}$ 最近的 $B\boldsymbol{x}$？先用 [1.6.7 的正交投影](../ch01/sec16.md#sec-1.6.7) 把 $\boldsymbol{b}$ 分成列空间内外两部分：

$$\|B\boldsymbol{x}-\boldsymbol{b}\|_2^2=\|R_1\boldsymbol{x}-Q_1^{\mathrm T}\boldsymbol{b}\|_2^2+\|(I-Q_1Q_1^{\mathrm T})\boldsymbol{b}\|_2^2.$$

第二项不随 $\boldsymbol{x}$ 改变；第一项可通过解上三角方程降为零。取 $\boldsymbol{b}=(0,1,5)^{\mathrm T}$，得到

$$Q_1^{\mathrm T}\boldsymbol{b}=\begin{pmatrix}4\\1\end{pmatrix},\qquad \begin{pmatrix}5&5\\0&1\end{pmatrix}\widehat{\boldsymbol{x}}=\begin{pmatrix}4\\1\end{pmatrix},\qquad \widehat{\boldsymbol{x}}=\begin{pmatrix}-1/5\\1\end{pmatrix}.$$

于是 $B\widehat{\boldsymbol{x}}=(12/5,1,16/5)^{\mathrm T}$，残差 $\boldsymbol{r}=\boldsymbol{b}-B\widehat{\boldsymbol{x}}=(-12/5,0,9/5)^{\mathrm T}$。检查 $B^{\mathrm T}\boldsymbol{r}=\boldsymbol0$，最小残差范数为 $3$。注意 $Q_1^{\mathrm T}\boldsymbol{b}$ 是投影在正交基下的坐标，而非原来两列 $B$ 下的系数；还需回代 $R_1$ 才能得到 $\widehat{\boldsymbol{x}}$。

**迁移练习。**若右端改为 $\boldsymbol{b}'=\boldsymbol{b}+B(1,-1)^{\mathrm T}=(0,0,5)^{\mathrm T}$，最小二乘解和最小残差会怎样变？先用几何分解预测，再算。

::: sol 核对与回查

解变为 $\widehat{\boldsymbol{x}}'=(4/5,0)^{\mathrm T}$；残差完全不变，因为右端只增加了列空间中的向量。若投影部分不清楚，回看 [1.6.7](../ch01/sec16.md#sec-1.6.7)；若把 $Q_1^{\mathrm T}\boldsymbol{b}$ 直接当作解，重看例 3.4.3 中 $R_1$ 的列坐标含义。能解释这两个步骤后，再进入下一节的 QR 特征值迭代：那是同一分解的另一种用途。
:::
:::

<a id="sec-3.4.3"></a>

## 3.4.3 QR 算法：分解怎样变成特征值算法

到此为止，QR 只是「一种好看的分解」。课件接下来的一页给它加了一个头衔——

> **QR 算法**：计算小规模矩阵所有特征值稳定有效的方法，二十世纪在科学和工程上有最大贡献与影响的**十大算法**之一。

（本编注：所谓「十大算法」指 2000 年 IEEE《Computing in Science & Engineering》评选的「世纪十大算法」，与快速傅里叶变换、单纯形法等并列；QR 算法由 J. G. F. Francis 于 1961 年前后提出，至今仍是稠密矩阵特征值计算的标准内核。）算法本身只有三行：



::: method QR 算法（课件原文，格式化排版）{#method-qr-algo}

**输入**：可逆阵 $A$（$n$ 阶复方阵）。令 $A_1=A$。对 $k=1,2,\cdots$ 循环：

1. 对 $A_k$ 作 QR 分解：$A_k=Q_kR_k$；
2. 令 $A_{k+1}=R_kQ_k$（**交换左右**）。

**收敛条件必须区分层次**：仅有「特征值模值互异」不能保证正线 QR 的**整个矩阵序列**收敛。反例
$$A=\begin{bmatrix}-1&1\\0&2\end{bmatrix},\quad Q_1=\operatorname{diag}(-1,1),\quad R_1=\begin{bmatrix}1&-1\\0&2\end{bmatrix}$$
使 $A_2=R_1Q_1=\begin{bmatrix}-1&-1\\0&2\end{bmatrix}$、$A_3=A$。特征值模为 $1,2$，但上三角非对角元符号交替，整个矩阵没有极限；对角元却从开始就是特征值。

一个可用的较强充分条件是：$A$ 为实对称正定阵，特征值 $\lambda_1>\cdots>\lambda_n>0$，且按此顺序排列的正交特征向量矩阵 $S$ 使 $S^{\mathrm T}$ 的各顺序主子式非零（保证初始坐标旗标含有所需的主特征分量）。此时正线 QR 迭代趋于按该顺序排列的对角阵。一般矩阵须另行分析子对角元、分块与相位，不能只凭「模互异」断言全矩阵收敛。
:::

为什么「交换左右再乘回去」能挤出一个上三角阵？课件用一道思考题点破了机关——**每一步迭代都是一次酉相似**：

::: proof 思考的解答（课件分析）：为什么收敛的上三角阵的对角元素就是 $A$ 的特征值

由 $A_k=Q_kR_k$ 得 $R_k=Q_k^{\mathrm H}A_k$，代回迭代式：

$$A_{k+1}=R_kQ_k=Q_k^{\mathrm H}A_kQ_k,$$

即 $A_{k+1}$ 与 $A_k$ **相似**（而且是酉相似），它们具有相同的特征值。递推成链：

$$A_k=(Q_1Q_2\cdots Q_{k-1})^{\mathrm H}\,A\,(Q_1Q_2\cdots Q_{k-1}),\qquad k=1,2,\cdots,$$

故**每个 $A_k$ 都与 $A$ 相似**、特征值始终不变（[@thm-sim-invariants]）。若 $A_k\to\Lambda$（上三角），则由特征多项式各系数随矩阵元连续，$\Lambda$ 的特征值也是 $A$ 的特征值；而上三角阵的特征值就是对角元——**对角元素即 $A$ 的特征值**。QR 算法利用矩阵乘法和 QR 分解实现了特征值求解。∎
:::


相似链保证的是：**如果**迭代收敛到上三角阵，其对角元必为原矩阵的特征值。它本身不保证收敛或排序；即使 $A=\operatorname{diag}(1,2)$ 已经不动，也不会自动把对角元改成按模递减。下面的实对称正定算例满足更强的条件，不能用它代表全部可逆矩阵。

::: ex 例 3.4.4（课件原文，本编核算并改一处印误，见 E3.7）· 用 QR 算法求特征值 {#ex-3.4.4}

利用 QR 分解求矩阵 $A=\begin{bmatrix}2&1&0\\ 1&3&1\\ 0&1&4\end{bmatrix}$ 的特征值。

::: sol 解答（课件路线；数值由本编按同一算法双精度复核）

**第一步（分解 $A_1$）**：$A_1=A=Q_1R_1$。按 GS（正线版本，四位小数）：

$$Q_1=\begin{bmatrix}0.8944&-0.4082&0.1826\\ 0.4472&0.8165&-0.3651\\ 0&0.4082&0.9129\end{bmatrix},\qquad
R_1=\begin{bmatrix}2.2361&2.2361&0.4472\\ 0&2.4495&2.4495\\ 0&0&3.2863\end{bmatrix}.$$

（课件此页把 $Q_1$ 的第 $1$、$2$ 列连同 $R_1$ 的第 $1$、$2$ 行取了相反符号——$R_1$ 对角出现两个负数，不合正线约定；又把 $Q_1$ 的 $(2,3)$ 元印作 $-0.3561$，按 GS 应为 $-0.3651$，见勘误 E3.7。上面给出的是规约后的正确版本，验算 $Q_1R_1=A$ 至四位小数 ✓。）

**第二步（迭代）**：$A_2=R_1Q_1$，再分解、再交换，往复。课件报告：

$$A_{10}=\begin{bmatrix}4.7282&0.0781&0\\ 0.0781&3.0035&-0.0020\\ 0&0.0048&1.2680\end{bmatrix},\qquad
A_{20}=\begin{bmatrix}4.7321&0.0008&0\\ 0.0008&3.0000&0\\ 0&0&1.2679\end{bmatrix}.$$

非对角元逐轮衰减：$k=10$ 时约 $10^{-2}$，$k=20$ 时约 $10^{-3}$——序列肉眼可见地收敛到上三角阵。

（本编复算注：用双精度 Householder QR 复核同一迭代，$A_{10}$ 的最大非对角元约 $5\times10^{-2}$、$A_{20}$ 约 $5\times10^{-4}$，与课件的 $0.0781$、$0.0008$ 同数量级但不逐位相同——中间数值随实现与舍入（课件全程四位数）而异；**对角元的收敛位置则完全一致**。）

**第三步（读特征值）**：对比该矩阵特征值精确解（本编补推导）：

$$f_A(\lambda)=\det(\lambda I-A)=(\lambda-3)\big[(\lambda-3)^2-3\big],\qquad
\lambda_1=3+\sqrt3=4.7321,\quad \lambda_2=3,\quad \lambda_3=3-\sqrt3=1.2679,$$

（展开：$\lambda^3-9\lambda^2+24\lambda-18$；$\lambda=3$ 代入为 $0$，再解二次 $\lambda^2-6\lambda+6=0$。）与 $A_{20}$ 的对角元逐位吻合 ✓。∎
:::
:::



::: note 本编注 · 收敛条件的边界：等模特征值会卡住

等模特征值可以阻止三角化；而上面的异模反例说明，模互异也不足以保证整个矩阵序列收敛。先看 [3.5](sec35.md) 即将出场的那张旋转矩阵：

$$A=\begin{bmatrix}0&-1\\ 1&0\end{bmatrix}\quad(\text{正交矩阵，特征值 }\pm\mathrm i\ \text{等模}).$$

它自己的 QR 分解（正线版）是 $A=A\cdot I$（$Q=A$ 酉、$R=I$ 正线），于是 $A_2=R_1Q_1=I\cdot A=A$——**迭代卡死在原地**，$\{A_k\}$ 恒为 $A$，永远不收敛到上三角阵。等模特征值（如实的旋转阵、含 $\pm\lambda$ 对的矩阵）都会出现这类「原地打转或极限不为三角」的现象；实用中的补救（先化成 Hessenberg 形、加位移）是《数值分析》课程的主题。这也提示 QR 算法的**极限**其实是 $A$ 的一个 Schur 型——正是下一节的内容。
:::

::: preview 课程预告 · 从分解到 Schur 型

QR 算法的收敛极限「酉相似于上三角阵」并不是迭代碰巧的礼物：**任何复方阵都酉相似于上三角阵**（Schur 引理，[3.5](sec35.md) 的定理 3.5.2）——QR 算法只是在数值上把这个存在的事实**算出来**。更有趣的是证明：对相似变换矩阵 $P$ 作 QR 分解 $P=UR$，普通相似立刻升级成酉相似。两节在此接轨。
:::

::: note 考情速递（本编依据课件小结与前章课堂考情整理；本讲无录播，未见老师原话）

课件小结页亲排：「**重要结论：QR 分解定理；重要算法：QR 算法**」——对应两条考试主线：**计算大题手算 QR**（GS 全流程，正线规约是隐形评分点）与**概念 / 小计算考 QR 算法**（相似性论证、收敛条件的充分性）。课件的思考题三连问（满秩？不满秩？长方？）是判断题的题源，注 1 与例 3.4.1 的「不唯一」几乎必考其一。跨章联动：二维 QR 的 $Q$ 常常就是 Givens 旋转（[@ex-3.4.A]）或 Householder 反射（习题 R2-1，见[竞技场](arena.md)）——2.5 老师原话点名这两个矩阵「容易变形」（01:14:16）。分级清单、限时赛制与计时器集中在[考场竞技场](arena.md)。
:::

## 3.4 小结与常见错误

- **一条主线**：**满秩分解的正交化** $\Rightarrow$ 定义 3.4.1（$A=QR$：酉 $\times$ 上三角）$\Rightarrow$ 定理 3.4.1（满秩方阵存在且正线下唯一；$R$ 是「$\boldsymbol z$ 基到 $\boldsymbol a$ 基」的过渡矩阵，GS 即算法）$\Rightarrow$ 不唯一 $=$ 对角酉阵自由度（实：$2^n$ 种）$\Rightarrow$ 放宽前提（例 3.4.2 不满秩：零行；定义 3.4.2 列正交规范；例 3.4.3 $+$ 推论 3.4.1：长方阵补零块）$\Rightarrow$ QR 算法（$A_{k+1}=Q_k^{\mathrm H}A_kQ_k$ 酉相似链，相似链保谱；收敛与排序须补齐条件）。
- **两句话记住它**：**GS 立轴，坐标上三角**——把 $A$ 的列逐个减掉在已有标准正交方向上的成分，坐标表自动变成「只用前 $k$ 个轴」的三角形。**正线锁相角**——不规定对角为正，分解就差一圈子符号 / 相角。

::: think 常见错误清单 · 自查五条

1. **把 $r_{kk}$ 写成 $\|\boldsymbol{a}_k\|$**：对角元是 GS **残差** $\boldsymbol{y}_k$ 的范数（先减成分、再量长度）；$\|\boldsymbol{a}_k\|$ 只有在 $\boldsymbol{a}_k$ 与前各轴已正交时才等于 $r_{kk}$；
2. **复数情形系数的共轭放错边**：本节系数是 $(\boldsymbol{a}_k,\boldsymbol{z}_i)$——第一变元线性（[@def-1.4.1] 约定）；若你的教材用第二变元线性，公式要相应换成 $r_{ik}=(\boldsymbol{z}_i,\boldsymbol{a}_k)$，两套不能混用；
3. **对长方阵硬套定理 3.4.1**：那是**方阵**定理；长方阵（列满秩）用推论 3.4.1，$R$ 是 $m\times n$ 的「上三角 $+$ 零块」，写成 $n\times n$ 会形状对不上；
4. **以为不满秩就没有 QR 分解**：例 3.4.2 说明分解常在，丢掉的是**唯一性**（$R$ 不可逆，证明失效；且自由度不再只是对角酉阵）；也别忘了列正交规范（$Q^{\mathrm H}Q=I_n$）与酉矩阵（还需为方阵）的区别；
5. **QR 算法两条方向性错误**：迭代式是 $A_{k+1}=Q_k^{\mathrm H}A_kQ_k$（把 $Q_k$ **左乘 $\mathrm H$、右乘原样**），写成 $Q_kA_kQ_k^{\mathrm H}$ 就错了；仅凭「模互异」判全矩阵收敛，或把旋转阵的常值序列误当成三角化成功；应区分全矩阵极限与子对角消失。
:::

::: ex 即时自测（不看上文，5 分钟）{#ex-3.4.quiz}

1. 背写定义 3.4.1 与定理 3.4.1，并说出「正线」在唯一性证明的哪一步把自由度锁死；
2. 求 $A=\begin{bmatrix}1&1\\ 2&0\end{bmatrix}$ 的 QR 分解（$Q$ 正交、$R$ 正线上三角）并回代验证；
3. $Q\in\mathbb C^{3\times2}$ 满足 $Q^{\mathrm H}Q=I_2$：它是酉矩阵吗？$QQ^{\mathrm H}=$？$\|Q\boldsymbol{x}\|$ 与 $\|\boldsymbol{x}\|$ 有何关系？
4. 复述推论 3.4.1 的构造证明，「补齐」一步为什么不会破坏前 $n$ 个标准正交向量？
5. 旋转阵 $A=\begin{bmatrix}0&-1\\ 1&0\end{bmatrix}$ 的 QR 迭代为什么卡死？这暴露了收敛条件的什么缺口？

::: sol 参考要点

1. $A=QR$，$Q$ 酉（实：正交）、$R$ 上三角（正线 $=$ 对角全正实数）；满秩方阵存在且唯一。锁死的一步：$W=R_2R_1^{-1}$ 既酉又上三角 $\Rightarrow$ 对角 $|w_{ii}|=1$，**对角为正** $\Rightarrow w_{ii}=1\Rightarrow W=I$。
2. $\boldsymbol{z}_1=\tfrac{1}{\sqrt5}(1,2)^{\mathrm T}$；$(\boldsymbol{a}_2,\boldsymbol{z}_1)=\tfrac{1}{\sqrt5}$，$\boldsymbol{y}_2=(\tfrac45,-\tfrac25)^{\mathrm T}$，$\|\boldsymbol{y}_2\|=\tfrac{2}{\sqrt5}$，$\boldsymbol{z}_2=\tfrac{1}{\sqrt5}(2,-1)^{\mathrm T}$。$Q=\tfrac{1}{\sqrt5}\begin{bmatrix}1&2\\ 2&-1\end{bmatrix}$（对称且正交，$\det=-1$），$R=\begin{bmatrix}\sqrt5&\tfrac{1}{\sqrt5}\\ 0&\tfrac{2}{\sqrt5}\end{bmatrix}$；验算 $QR=\begin{bmatrix}1&\tfrac15+\tfrac45\\ 2&\tfrac25-\tfrac25\end{bmatrix}=\begin{bmatrix}1&1\\ 2&0\end{bmatrix}$ ✓。
3. 不是（非方阵）；$QQ^{\mathrm H}$ 是到 $R(Q)$ 的正交投影矩阵 $\neq I_3$（被抹掉的是 $R(Q)^\perp$，未必是标准坐标 $\boldsymbol e_3$ 方向）；$\|Q\boldsymbol{x}\|=\|\boldsymbol{x}\|$（保范）。
4. GS（列满秩 $\Rightarrow$ 各步残差非零）给 $A=Q_1R_1$；基扩充（[@cor-1.3.1]）后对整组重做 GS——「张成不变」保证前缀的 $\operatorname{span}$ 不变，而已标准正交的前 $n$ 个向量重走 GS 公式**每个减项内积为零**、原样保留；只有新添的向量被正交化。$U=[Q_1,U_2]$ 列标准正交的方阵即酉。
5. $A$ 本身正交，其正线 QR 分解为 $A=A\cdot I$，故 $A_2=R_1Q_1=A$，迭代恒为 $A$ 不动。此例的矩阵序列本身有极限，但极限不是上三角阵；不能将「迭代序列收敛」和「成功三角化」混为一谈。等模反例也不意味着模互异就充分，前面的两周期例子已否定后一说法。
:::
:::
