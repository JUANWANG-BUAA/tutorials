# 3.7 谱分解与幂等阵

[3.6](sec36.md) 把可对角化的矩阵写成 $A=P\Lambda P^{-1}$：特征值摆在对角线上，特征向量拼在 $P$ 的列里。这个式子已经很好用，但它把两件不同的事捆在了一起——**数**（特征值 $\lambda_j$）与**空间**（特征子空间 $E(\lambda_j)$）——都塞进了一个 $P$ 里。

本节把同一个式子重新分组，写成

$$A=\sum_{j=1}^{m}\lambda_jE_j,$$

其中每个 $E_j$ 是一个**矩阵**，负责把向量投影到第 $j$ 个特征子空间上。这个形式叫**谱分解**（spectral decomposition），$E_j$ 叫**谱阵**（spectral matrix）。它不是新的分解，而是对角化分解的「按特征值分块」版本：$\lambda_j$ 是系数，$E_j$ 是「住在哪个子空间」的账本。分开之后，两件事各自变得更强：

- **函数演算**：对任意多项式 $f$，$f(A)=\sum_j f(\lambda_j)E_j$（[@thm-3.7.1]）——[3.5.2](sec35.md#sec-3.5.2) 的谱映射从「特征值」升级成「整个矩阵」；
- **直接求谱阵**：不必先求 $P^{-1}$，用 $E_j=f_j(A)/f_j(\lambda_j)$ 一步到位（[@thm-3.7.2]）——这是 Lagrange 插值在矩阵上的化身；
- **几何升级**：若 $A$ 正规，每个 $E_j$ 都是**正交投影**（[@prop-3.7.2]）——谱分解于是变成「把空间正交地拆成特征子空间」的谱定理。

::: note 素材与说明（本节无录播）

本页依据课程第三章课件 **3.7 谱分解与幂等阵**（22 页，存于本地归档 `_sources/matrix/3.7-谱分解1.pdf`）整理。**本节无对应录播**，故不引用课堂口述与时间戳：课件的定义、定理、命题、注记与例题**照录并保留原编号**（定义 3.7.1–3.7.3、定理 3.7.1–3.7.2、命题 3.7.1–3.7.2、注 1–注 2、例 3.7.1–3.7.2 及例 3.7.2 续）；课件省略的证明（命题 3.7.1 的（5）唯一性、定理 3.7.1、定理 3.7.2、命题 3.7.2）由本编补出并逐处标注「本编补」。本编新增例题用字母编号（[@ex-3.7.A]–[@ex-3.7.C]），新增注记用「本编注」标注。
:::

<a id="sec-3.7.1"></a>

## 3.7.1 从对角化分解到谱分解

先把定义摆出来。注意它假设 $A$ 是**单纯矩阵**——谱分解不是人人有份的，它的门票是 [3.6.1](sec36.md#sec-3.6.1) 的五条判据。

::: def 定义 3.7.1 · 单纯矩阵的谱分解 {#def-3.7.1}

设 $\lambda_1,\cdots,\lambda_m$ 是单纯矩阵 $A$ 的 $m$ 个互异特征值，其代数重数分别为 $d_1,\cdots,d_m$，则矩阵 $A$ 的**谱分解式**定义为

$$A=\sum_{j=1}^{m}\lambda_jE_j,$$

其中 $E_j$（$j=1,\cdots,m$）称为 $A$ 的**谱阵**。
:::

::: note 注 1（课件原文）· 代数重数等于几何重数 {#note-3.7-mult}

单纯矩阵特征值的代数重数等于其几何重数。

（本编补一句：这正是 [@thm-3.6.1]（3）；它保证每个特征子空间 $E(\lambda_j)$ 的维数恰好是 $d_j$，于是谱阵 $E_j$ 的秩也恰好是 $d_j$——见 [3.7.2](#sec-3.7.2) 的本编补。）
:::

课件的思考题是：**单纯矩阵的谱分解存在吗？** 它没有先给抽象证明，而是先用一个 $3$ 阶例子把谱阵「算出来」：

::: ex 例 3.7.1（课件原文）· 求谱分解 {#ex-3.7.1}

求矩阵 $A=\begin{bmatrix}4&6&0\\ -3&-5&0\\ -3&-6&1\end{bmatrix}$ 的谱分解。

::: sol 解答（课件路线；全部矩阵乘法由本编复核）

**特征值与特征向量**：$f_A(\lambda)=(\lambda-1)^2(\lambda+2)$（$\operatorname{tr}A=0=1+1-2$ ✓，$\det A=-2=1\cdot1\cdot(-2)$ ✓）。解得

$$\lambda_1=\lambda_2=1,\qquad \lambda_3=-2,$$

对应特征向量分别为

$$\boldsymbol\alpha_1=(2,-1,0)^{\mathrm T},\qquad
\boldsymbol\alpha_2=(0,0,1)^{\mathrm T},\qquad
\boldsymbol\alpha_3=(-1,1,1)^{\mathrm T}.$$

（验算：$A\boldsymbol\alpha_1=(2,-1,0)^{\mathrm T}$ ✓；$A\boldsymbol\alpha_2=(0,0,1)^{\mathrm T}$ ✓；$A\boldsymbol\alpha_3=(2,-2,-2)^{\mathrm T}=-2\boldsymbol\alpha_3$ ✓。）三个特征向量线性无关，故 $A$ 是单纯矩阵。

**对角化分解**：令

$$P=[\boldsymbol\alpha_1,\boldsymbol\alpha_2,\boldsymbol\alpha_3]=\begin{bmatrix}2&0&-1\\ -1&0&1\\ 0&1&1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(1,1,-2),$$

则

$$P^{-1}=\begin{bmatrix}1&1&0\\ -1&-2&1\\ 1&2&0\end{bmatrix},\qquad P^{-1}AP=\Lambda.$$

（验算 $PP^{-1}=I$ ✓；$P^{-1}AP=\Lambda$ 逐列可验。）

**把 $P\Lambda$ 按列读**：

$$P\Lambda=[\boldsymbol\alpha_1,\boldsymbol\alpha_2,\boldsymbol\alpha_3]\begin{bmatrix}1&0&0\\ 0&1&0\\ 0&0&-2\end{bmatrix}
=[\boldsymbol\alpha_1,\boldsymbol\alpha_2,-2\boldsymbol\alpha_3].$$

**把 $P^{-1}$ 按行读**：定义

$$P^{-1}=\begin{bmatrix}\boldsymbol\beta_1^{\mathrm H}\\ \boldsymbol\beta_2^{\mathrm H}\\ \boldsymbol\beta_3^{\mathrm H}\end{bmatrix},$$

即 $\boldsymbol\beta_1^{\mathrm H}=(1,1,0)$、$\boldsymbol\beta_2^{\mathrm H}=(-1,-2,1)$、$\boldsymbol\beta_3^{\mathrm H}=(1,2,0)$。于是

$$P\Lambda P^{-1}=[\boldsymbol\alpha_1,\boldsymbol\alpha_2,-2\boldsymbol\alpha_3]\begin{bmatrix}\boldsymbol\beta_1^{\mathrm H}\\ \boldsymbol\beta_2^{\mathrm H}\\ \boldsymbol\beta_3^{\mathrm H}\end{bmatrix}
=\boldsymbol\alpha_1\boldsymbol\beta_1^{\mathrm H}+\boldsymbol\alpha_2\boldsymbol\beta_2^{\mathrm H}-2\boldsymbol\alpha_3\boldsymbol\beta_3^{\mathrm H}
\triangleq E_1-2E_2.$$

**算出谱阵**：

$$E_1=\boldsymbol\alpha_1\boldsymbol\beta_1^{\mathrm H}+\boldsymbol\alpha_2\boldsymbol\beta_2^{\mathrm H}
=\begin{bmatrix}2&2&0\\ -1&-1&0\\ -1&-2&1\end{bmatrix},\qquad
E_2=\boldsymbol\alpha_3\boldsymbol\beta_3^{\mathrm H}
=\begin{bmatrix}-1&-2&0\\ 1&2&0\\ 1&2&0\end{bmatrix}.$$

**验算**：

$$E_1+E_2=I_3,\qquad E_1E_2=E_2E_1=O,\qquad E_1^2=E_1,\quad E_2^2=E_2,\qquad A=E_1-2E_2.$$

（逐项验算：$E_1+E_2=\begin{bmatrix}1&0&0\\0&1&0\\0&0&1\end{bmatrix}$ ✓；$E_1E_2$ 的四块乘积中，$\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_j=\delta_{ij}$ 使交叉项全消 ✓；$A=E_1-2E_2$ 逐元核对 ✓。另：$\operatorname{rank}E_1=2$、$\operatorname{rank}E_2=1$，恰是特征值 $1$ 与 $-2$ 的代数重数；$\operatorname{tr}E_1=2$、$\operatorname{tr}E_2=1$——这不是巧合，见 [3.7.2](#sec-3.7.2)。）∎
:::
:::

::: note 注 2（课件原文）· 谱分解总存在 {#note-3.7-existence}

上述过程对任意单纯阵都适用，故单纯阵的谱分解总存在。

（本编补一句「为什么」：证明就是对 $A=P\Lambda P^{-1}$ 做上面的「按列读 $P$、按行读 $P^{-1}$、按特征值分组」三步。写成一般式就是下面的 [@method-spectral]；它不依赖 $A$ 的特殊形状，只用到 $P^{-1}P=I$ 给出的 $\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_j=\delta_{ij}$。）
:::

::: method 从对角化分解读出谱分解（三步法） {#method-spectral}

**入口**：已知 $A$ 单纯，要求谱分解 $A=\sum_j\lambda_jE_j$。

1. **对角化**：求 $P=[\boldsymbol\alpha_1,\cdots,\boldsymbol\alpha_n]$ 与 $\Lambda=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$，使 $P^{-1}AP=\Lambda$；把 $P^{-1}$ 按**行**写成 $[\boldsymbol\beta_1^{\mathrm H};\cdots;\boldsymbol\beta_n^{\mathrm H}]$。
2. **拆成秩一和**：$A=\sum_{i=1}^{n}\lambda_i\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$（这一步只是把矩阵乘法按列 $\times$ 行展开）。
3. **按特征值分组**：对每个互异特征值 $\lambda_j$，令
   $$E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H},$$
   则 $A=\sum_{j=1}^{m}\lambda_jE_j$，且 $E_j$ 就是第 $j$ 个谱阵。

**验算**：$\sum_jE_j=I$；$E_iE_j=\delta_{ij}E_i$；$AE_j=\lambda_jE_j$；$\operatorname{tr}E_j=d_j$。**易错**：把 $P^{-1}$ 的**列**当成 $\boldsymbol\beta_i$（应是**行**）；分组时把不同特征值的项混进同一个 $E_j$；忘记 $\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_k=\delta_{ik}$ 是全部性质的来源。
:::

::: note 本编注 · 谱阵的矩阵身份：$E_j=P\,\operatorname{diag}(0,\cdots,1,\cdots,0)\,P^{-1}$ {#note-3.7-projector-identity}

把 $E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$ 写成矩阵乘法：若 $D_j$ 是对角阵，在第 $j$ 个特征值对应的那些位置取 $1$、其余取 $0$，则

$$E_j=P D_j P^{-1}.$$

这个写法一眼看出三件事：① $E_j$ 与 $\Lambda$ 的**分块**一一对应；② $E_j$ 是**投影**（$D_j^2=D_j$）；③ $E_j$ 的秩 $=\operatorname{tr}D_j=d_j$。它也解释了「谱分解不是新分解」：$A=P\Lambda P^{-1}=P\big(\sum_j\lambda_jD_j\big)P^{-1}=\sum_j\lambda_jE_j$——只是把 $\Lambda$ 按特征值拆成了若干块对角阵。
:::

::: ex 例 3.7.A（新增）· 非正规矩阵的谱分解：斜投影 {#ex-3.7.A}

求 $A=\begin{bmatrix}1&1\\ 0&2\end{bmatrix}$ 的谱分解，并解释两个谱阵的几何意义。

::: sol 解答

**对角化**：特征值 $1,2$，特征向量 $\boldsymbol\alpha_1=(1,0)^{\mathrm T}$、$\boldsymbol\alpha_2=(1,1)^{\mathrm T}$。

$$P=\begin{bmatrix}1&1\\ 0&1\end{bmatrix},\qquad
P^{-1}=\begin{bmatrix}1&-1\\ 0&1\end{bmatrix},\qquad
\Lambda=\operatorname{diag}(1,2).$$

**秩一和**：$P^{-1}$ 的两行是 $\boldsymbol\beta_1^{\mathrm H}=(1,-1)$、$\boldsymbol\beta_2^{\mathrm H}=(0,1)$，故

$$A=\boldsymbol\alpha_1\boldsymbol\beta_1^{\mathrm H}+2\boldsymbol\alpha_2\boldsymbol\beta_2^{\mathrm H}
=\begin{bmatrix}1&-1\\ 0&0\end{bmatrix}+2\begin{bmatrix}0&1\\ 0&1\end{bmatrix}
\triangleq E_1+2E_2.$$

**验算**：

$$E_1+E_2=\begin{bmatrix}1&0\\0&1\end{bmatrix},\qquad
E_1E_2=\begin{bmatrix}1&-1\\0&0\end{bmatrix}\begin{bmatrix}0&1\\0&1\end{bmatrix}=O,\qquad
E_1^2=E_1,\ E_2^2=E_2.$$

**几何意义**：$E_1$ 的值域是 $E(1)=\operatorname{span}\{(1,0)^{\mathrm T}\}$，核是 $E(2)=\operatorname{span}\{(1,1)^{\mathrm T}\}$——它把向量沿 $(1,1)$ 方向「斜着」投到 $x$ 轴上；$E_2$ 则沿 $x$ 轴投到 $(1,1)$ 方向。两个投影都**不是正交投影**（$E_1^{\mathrm T}\ne E_1$、$E_2^{\mathrm T}\ne E_2$），因为 $A$ 不是正规矩阵（[@ex-3.6.C]）。这正是「单纯」与「正规」的差别在谱阵上的体现：**单纯只保证 $E_j$ 是投影，正规才保证 $E_j$ 是正交投影**（[3.7.4](#sec-3.7.4)）。∎
:::
:::

<a id="sec-3.7.2"></a>

## 3.7.2 谱阵的性质与幂等矩阵

例 3.7.1 的两个谱阵满足一组漂亮的关系。课件把它们逐条验算后抽成命题；先给「投影」这类矩阵一个名字：

::: def 定义 3.7.2 · 幂等矩阵 {#def-3.7.2}

设 $E\in\mathbb C^{n\times n}$，若

$$E^2=E,$$

则称 $E$ 为**幂等矩阵**。
:::

::: prop 命题 3.7.1 · 单纯矩阵的谱阵性质 {#prop-3.7.1}

设 $E_1,\cdots,E_m$ 是单纯矩阵 $A$ 的 $m$ 个谱阵，则 $\forall i,j=1,\cdots,m$ 且 $i\ne j$，有

（1）$E_j=(E_j)^2$；

（2）$E_iE_j=0$；

（3）$E_iA=AE_i=\lambda_iE_i$；

（4）$\sum_{k=1}^{m}E_k=I$；

（5）谱阵集 $\{E_1,\cdots,E_m\}$ 唯一。
:::

::: proof 证明（课件给出 (1)–(4) 的验算，(5) 由本编补）

设 $A=P\Lambda P^{-1}$，$P=[\boldsymbol\alpha_1,\cdots,\boldsymbol\alpha_n]$，$P^{-1}=[\boldsymbol\beta_1^{\mathrm H};\cdots;\boldsymbol\beta_n^{\mathrm H}]$，则 $\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_j=\delta_{ij}$，且

$$E_j=\sum_{p:\lambda_p=\lambda_j}\boldsymbol\alpha_p\boldsymbol\beta_p^{\mathrm H}.$$

**（1）** 用 $\boldsymbol\beta_p^{\mathrm H}\boldsymbol\alpha_q=\delta_{pq}$：

$$E_j^2=\sum_{p,q:\lambda_p=\lambda_q=\lambda_j}\boldsymbol\alpha_p(\boldsymbol\beta_p^{\mathrm H}\boldsymbol\alpha_q)\boldsymbol\beta_q^{\mathrm H}
=\sum_{p:\lambda_p=\lambda_j}\boldsymbol\alpha_p\boldsymbol\beta_p^{\mathrm H}=E_j.$$

**（2）** 若 $i\ne j$，则 $\lambda_p=\lambda_i$ 与 $\lambda_q=\lambda_j$ 不可能同时成立，故 $\boldsymbol\beta_p^{\mathrm H}\boldsymbol\alpha_q=\delta_{pq}=0$：

$$E_iE_j=\sum_{p:\lambda_p=\lambda_i}\sum_{q:\lambda_q=\lambda_j}\boldsymbol\alpha_p(\boldsymbol\beta_p^{\mathrm H}\boldsymbol\alpha_q)\boldsymbol\beta_q^{\mathrm H}=O.$$

**（3）** 由 $A=\sum_k\lambda_kE_k$ 与（2）：

$$AE_i=\Big(\sum_k\lambda_kE_k\Big)E_i=\lambda_iE_i;$$

同理 $E_iA=\lambda_iE_i$（$E_i$ 与 $A$ 可交换）。

**（4）** 按列 $\times$ 行展开 $PP^{-1}=I$：

$$PP^{-1}=\sum_{k=1}^{n}\boldsymbol\alpha_k\boldsymbol\beta_k^{\mathrm H}=I.$$

右边按特征值分组，恰好是 $\sum_{j=1}^{m}E_j$。

**（5）唯一性（本编补）**：设另有 $F_1,\cdots,F_m$ 满足（1）–（4），且

$$A=\sum_{j=1}^{m}\lambda_jF_j.$$

对任意多项式 $p$，由（1）（2）（4）用归纳法可得

$$p(A)=\sum_{j=1}^{m}p(\lambda_j)F_j$$

（$A^k=(\sum_j\lambda_jF_j)^k=\sum_j\lambda_j^kF_j$，交叉项由 $F_iF_j=0$ 消去；再线性组合）。取 $p=f_i(\lambda)=\prod_{l\ne i}(\lambda-\lambda_l)$，则 $f_i(\lambda_j)=0$（$j\ne i$），故

$$f_i(A)=f_i(\lambda_i)F_i.$$

$f_i(\lambda_i)\ne0$（互异特征值），于是

$$F_i=\frac{f_i(A)}{f_i(\lambda_i)}.$$

对原来的 $E$ 族重复同一计算（把 $F$ 换成 $E$），得 $f_i(A)=f_i(\lambda_i)E_i$，故 $F_i=E_i$。谱阵集唯一。

**读法**：这五条把「谱阵」刻画成一组**两两正交的幂等元**，且它们的和是 $I$、每个与 $A$ 交换并给出特征值 $\lambda_i$。第（5）条说这组东西由 $A$ 唯一决定——所以「谱分解」虽然从 $P$ 出发，结果却与 $P$ 的选取无关（$P$ 可以换，$E_j$ 不能换）。
:::

::: note 本编补 · 幂等矩阵的三件事 {#note-3.7-idempotent}

设 $E^2=E$，则：

1. **特征值只能是 $0$ 或 $1$**：$E\boldsymbol x=\lambda\boldsymbol x$ 且 $\boldsymbol x\ne\boldsymbol 0$ $\Rightarrow$ $\lambda^2\boldsymbol x=E^2\boldsymbol x=E\boldsymbol x=\lambda\boldsymbol x$ $\Rightarrow$ $\lambda(\lambda-1)=0$。
2. **$E$ 可对角化，且 $\operatorname{rank}E=\operatorname{tr}E$**：由 [@ex-3.6.2]，$E$ 的最小多项式整除 $\lambda(\lambda-1)$，无重根，故单纯；其特征值只有 $0,1$，故对角化后 $\operatorname{diag}(1,\cdots,1,0,\cdots,0)$。秩 $=$ 非零特征值个数 $=$ 迹。
3. **$\mathbb C^n=R(E)\oplus N(E)$，$E$ 是沿 $N(E)$ 到 $R(E)$ 的投影**：对任意 $\boldsymbol x$，$\boldsymbol x=E\boldsymbol x+(I-E)\boldsymbol x$，第一项在 $R(E)$，第二项在 $N(E)$（因 $E(I-E)=E-E^2=O$）；若 $\boldsymbol y\in R(E)\cap N(E)$，写 $\boldsymbol y=E\boldsymbol x$，则 $\boldsymbol y=E\boldsymbol x=E^2\boldsymbol x=E\boldsymbol y=\boldsymbol 0$。正交性另需 $E^{\mathrm H}=E$：此时 $(E\boldsymbol x,(I-E)\boldsymbol y)=(\boldsymbol x,E(I-E)\boldsymbol y)=0$，故 $R(E)\perp N(E)$。

**一句话**：**幂等 $=$ 投影；Hermite 幂等 $=$ 正交投影**（[@def-3.7.3]）。谱阵是幂等阵，但一般不是 Hermite 的；正规矩阵的谱阵才是（[@prop-3.7.2]）。
:::

::: ex 例 3.7.B（新增）· 一个幂等阵的谱分解 {#ex-3.7.B}

设 $E=\begin{bmatrix}1&1\\ 0&0\end{bmatrix}$（[@ex-3.6.A]）。把 $E$ 本身写成谱分解，并验证「幂等 $=$ 投影」。

::: sol 解答

$E^2=E$，特征值 $1,0$。取 $\lambda=1$ 的特征向量 $(1,0)^{\mathrm T}$、$\lambda=0$ 的特征向量 $(-1,1)^{\mathrm T}$，则

$$E=1\cdot E_1+0\cdot E_0,\qquad E_1=E,\quad E_0=I-E=\begin{bmatrix}0&-1\\ 0&1\end{bmatrix}.$$

验证：$E_1+E_0=I$、$E_1E_0=O$、$E_1^2=E_1$、$E_0^2=E_0$。几何上 $E_1=E$ 把向量沿 $(-1,1)$ 方向投到 $x$ 轴，$E_0$ 把向量沿 $x$ 轴投到 $(-1,1)$ 方向；$R(E)=\operatorname{span}\{(1,0)^{\mathrm T}\}$ 与 $N(E)=\operatorname{span}\{(-1,1)^{\mathrm T}\}$ 不垂直，故这是**斜投影**，不是正交投影（$E^{\mathrm T}\ne E$）。∎
:::
:::

::: note 本编注 · 谱阵的秩恰好是代数重数 {#note-3.7-rank}

由 [@note-3.7-projector-identity]，$E_j=P D_jP^{-1}$，其中 $D_j$ 是对角元为 $0/1$ 的对角阵，$1$ 的个数是 $d_j$。相似不改变秩，故

$$\operatorname{rank}E_j=\operatorname{rank}D_j=d_j.$$

又 $E_j$ 幂等，$\operatorname{rank}E_j=\operatorname{tr}E_j$（[@note-3.7-idempotent]），故 $\operatorname{tr}E_j=d_j$。这条小结论在例 3.7.1 里已经露过面（$\operatorname{rank}E_1=2=d_1$、$\operatorname{rank}E_2=1=d_2$）；它也说明**谱阵的「大小」精确记录了特征值的重数**——$E_j$ 不是随便一个投影，而是投到 $d_j$ 维特征子空间上的投影。
:::

<a id="sec-3.7.3"></a>

## 3.7.3 谱分解的计算：函数演算与 Lagrange 公式

谱分解最直接的用处，是把「矩阵的函数」变成「特征值的函数」。先看多项式：

::: thm 定理 3.7.1 · 谱分解的函数演算 {#thm-3.7.1}

设 $f(\lambda)$ 为数域 $\mathbb C$ 上的任一多项式，单纯阵 $A\in\mathbb C^{n\times n}$ 的谱分解式为 $A=\sum_{j=1}^{m}\lambda_jE_j$，则

$$f(A)=\sum_{j=1}^{m}f(\lambda_j)E_j.$$

式中 $\lambda_1,\cdots,\lambda_m$ 为 $A$ 的 $m$ 个互异特征值，$E_j$（$j=1,\cdots,m$）是 $A$ 的谱阵。特别地，当 $f(\lambda)=\lambda^k$（$k\in\mathbb N$）时，

$$A^k=\sum_{j=1}^{m}\lambda_j^kE_j.$$
:::

::: proof 证明（课件未给，本编补：对单项式归纳，再用线性性）

先证 $A^k=\sum_j\lambda_j^kE_j$。$k=0$ 时 $A^0=I=\sum_jE_j$（[@prop-3.7.1]（4））；$k=1$ 时就是谱分解本身。归纳：

$$A^{k+1}=A\cdot A^k=\Big(\sum_i\lambda_iE_i\Big)\Big(\sum_j\lambda_j^kE_j\Big)
=\sum_{i,j}\lambda_i\lambda_j^kE_iE_j
=\sum_j\lambda_j^{k+1}E_j,$$

最后一步用了 $E_iE_j=\delta_{ij}E_i$（[@prop-3.7.1]（2））。对一般多项式 $f(\lambda)=\sum_k a_k\lambda^k$，由线性性：

$$f(A)=\sum_k a_kA^k=\sum_k a_k\sum_j\lambda_j^kE_j=\sum_j\Big(\sum_k a_k\lambda_j^k\Big)E_j=\sum_jf(\lambda_j)E_j.$$
:::

（读法：这条定理把 [3.5.2](sec35.md#sec-3.5.2) 的谱映射从「$f(A)$ 的特征值是 $f(\lambda_j)$」升级成「$f(A)$ **整个矩阵**是 $\sum_jf(\lambda_j)E_j$」。前者只告诉你特征值，后者连特征向量、幂、逆、指数都一并给出——因为 $E_j$ 已经把「住在哪个特征子空间」编码进去了。）

接下来是本节的计算核心。课件的思考题是：**能否直接由 $A$ 求出谱阵，而不经过 $P$？** 答案是肯定的——用 Lagrange 插值多项式，把「在 $\lambda_i$ 处取 $1$、在其余 $\lambda_j$ 处取 $0$」的函数直接作用在 $A$ 上。

::: thm 定理 3.7.2 · 谱阵的 Lagrange 公式 {#thm-3.7.2}

设单纯阵 $A$ 的谱分解式为 $A=\sum_{j=1}^{m}\lambda_jE_j$，则 $\forall i=1,\cdots,m$，

$$E_i=\frac{1}{\prod_{l=1,\,l\ne i}^{m}(\lambda_i-\lambda_l)}\prod_{l=1,\,l\ne i}^{m}(A-\lambda_lI).$$
:::

::: note 注 2（课件原文）· 最小多项式与 $f_i$ {#note-3.7-minpoly}

$A$ 的最小多项式为 $m_A(\lambda)=\prod_{l=1}^{m}(\lambda-\lambda_l)$；定义

$$f_i(\lambda)=\prod_{l=1,\,l\ne i}^{m}(\lambda-\lambda_l),$$

则 $E_i=f_i(A)/f_i(\lambda_i)$。
:::

::: proof 证明（课件未给，本编补：把 $f_i$ 代进定理 3.7.1）

令 $f_i(\lambda)=\prod_{l\ne i}(\lambda-\lambda_l)$。由 [@thm-3.7.1]（取 $f=f_i$）：

$$f_i(A)=\sum_{j=1}^{m}f_i(\lambda_j)E_j.$$

当 $j\ne i$ 时，$f_i(\lambda_j)$ 的乘积中含因子 $(\lambda_j-\lambda_j)=0$，故 $f_i(\lambda_j)=0$；当 $j=i$ 时，$f_i(\lambda_i)=\prod_{l\ne i}(\lambda_i-\lambda_l)\ne0$（互异特征值）。于是

$$f_i(A)=f_i(\lambda_i)E_i\quad\Longrightarrow\quad E_i=\frac{f_i(A)}{f_i(\lambda_i)}.$$

**读法**：这就是 **Lagrange 插值**的矩阵版——$f_i$ 是「在 $\lambda_i$ 处取 $1$、在其余 $\lambda_j$ 处取 $0$」的插值多项式（除以 $f_i(\lambda_i)$ 归一化），$E_i$ 就是它在 $A$ 处的值。与 [3.6.1](sec36.md#sec-3.6.1) 的（5）$\Rightarrow$（1）证明对照：那里用 $E_i=f_i(A)/f_i(\lambda_i)$ 把空间拆成特征子空间，这里则把它正式命名为谱阵——**同一个公式，两种读法**。
:::

::: ex 例 3.7.2（课件原文，续）· 用谱分解求 $A^{100}$ {#ex-3.7.2}

设 $A=\begin{bmatrix}2&1\\ 2&3\end{bmatrix}$，求 $A^{100}$。

::: sol 解答（课件路线）

**谱分解式**：

$$A=\boldsymbol\alpha_1\boldsymbol\beta_1^{\mathrm H}+4\boldsymbol\alpha_2\boldsymbol\beta_2^{\mathrm H}\triangleq E_1+4E_2.$$

（这是课件直接给出的形式；下面例 3.7.2 续会用定理 3.7.2 把 $E_1,E_2$ 算出来。）

**求幂**：

$$A^2=(E_1+4E_2)^2=E_1^2+8E_1E_2+16E_2^2=E_1+16E_2,$$

（用了 $E_1^2=E_1$、$E_2^2=E_2$、$E_1E_2=0$。）归纳得

$$A^k=E_1+4^kE_2.$$

当 $k=100$ 时，

$$A^{100}=E_1+4^{100}E_2.$$
:::
:::

::: ex 例 3.7.2 续（课件原文）· 直接求谱阵 {#ex-3.7.2b}

求 $A=\begin{bmatrix}2&1\\ 2&3\end{bmatrix}$ 的谱分解。

::: sol 解答（课件路线）

**特征值与最小多项式**：$\lambda_1=1$、$\lambda_2=4$，故

$$m_A(\lambda)=(\lambda-1)(\lambda-4).$$

（两个特征值互异，最小多项式就是特征多项式；也可由 [3.5.5](sec35.md#thm-3.5.5) 直接读。）

**定义插值多项式**：

$$f_1(\lambda)=\lambda-4,\qquad f_2(\lambda)=\lambda-1.$$

于是

$$f_1(A)=A-4I,\qquad f_2(A)=A-I.$$

**代公式**：

$$E_1=\frac{f_1(A)}{f_1(\lambda_1)}=\frac{A-4I}{1-4}=-\frac13(A-4I)=\frac13\begin{bmatrix}2&-1\\ -2&1\end{bmatrix},$$

$$E_2=\frac{f_2(A)}{f_2(\lambda_2)}=\frac{A-I}{4-1}=\frac13\begin{bmatrix}1&1\\ 2&2\end{bmatrix}.$$

**验算**：$E_1+E_2=I_2$ ✓；$E_1E_2=O$ ✓；$E_1^2=E_1$、$E_2^2=E_2$ ✓；$E_1+4E_2=\begin{bmatrix}2&1\\2&3\end{bmatrix}=A$ ✓。于是

$$A^{100}=E_1+4^{100}E_2
=\frac13\begin{bmatrix}4^{100}+2&4^{100}-1\\ 2(4^{100}-1)&2\cdot4^{100}+1\end{bmatrix},$$

与 [@ex-3.6.3]、[3.5.5](sec35.md#ex-3.5.5) 的答案逐位一致——三条路（H–C 递推 / 对角化 / 谱分解）在此会师。∎
:::
:::

::: note 本编注 · 谱分解与对角化分解的分工 {#note-3.7-compare}

| 维度 | 对角化分解 $A=P\Lambda P^{-1}$ | 谱分解 $A=\sum_j\lambda_jE_j$ |
|:--|:--|:--|
| 输入 | 需要 $n$ 个特征向量（含重数） | 只需 $m$ 个互异特征值与 $m_A$ |
| 输出 | $P$、$\Lambda$、$P^{-1}$ 三个矩阵 | $m$ 个谱阵（一般 $m\ll n$） |
| 算 $A^k$ | $P\Lambda^kP^{-1}$（要做两次矩阵乘法） | $\sum_j\lambda_j^kE_j$（$m$ 个秩一 / 低秩项） |
| 算 $f(A)$ | 先算 $f(\Lambda)$ 再夹 | 直接 $\sum_jf(\lambda_j)E_j$ |
| 几何 | 特征向量基（可能斜） | 投影到各特征子空间（正规时正交） |
| 唯一性 | $P$ 不唯一（差对角 / 分块因子） | $E_j$ **唯一**（[@prop-3.7.1]（5）） |

一句话：**对角化分解按「向量」记账，谱分解按「子空间」记账**。前者适合手算 $P$、$P^{-1}$；后者适合反复算 $A^k$、$f(A)$，也适合看清几何。
:::

::: note 本编补 · 谱分解是预解式的部分分式 {#note-3.7-resolvent}

对 $\lambda\notin\{\lambda_1,\cdots,\lambda_m\}$，有

$$(\lambda I-A)^{-1}=\sum_{j=1}^{m}\frac{E_j}{\lambda-\lambda_j}.$$

**验证**：两边右乘 $(\lambda I-A)$：

$$\sum_j\frac{E_j}{\lambda-\lambda_j}(\lambda I-A)=\sum_j\frac{(\lambda-\lambda_j)E_j}{\lambda-\lambda_j}=\sum_jE_j=I.$$

（用了 $(\lambda I-A)E_j=(\lambda-\lambda_j)E_j$，即 [@prop-3.7.1]（3）。）这个恒等式把谱分解解释成**预解式 $(\lambda I-A)^{-1}$ 的部分分式分解**：极点正是特征值，留数正是谱阵。它也解释了为什么 $E_j$ 可以用 Lagrange 公式算——部分分式的系数本来就是插值。逆矩阵公式（[3.5.2](sec35.md#cor-3.5.2)）只是它在 $\lambda=0$ 处的特款：

$$A^{-1}=-\sum_j\frac{E_j}{\lambda_j}\qquad(0\notin\sigma(A)).$$
:::

::: ex 例 3.7.C（新增）· 用谱分解算矩阵指数 {#ex-3.7.C}

设 $A=\begin{bmatrix}2&1\\ 2&3\end{bmatrix}$（例 3.7.2），求 $e^{At}$。

::: sol 解答

由 [@thm-3.7.1] 的「函数版」（把多项式换成幂级数，或直接对 $e^{At}=\sum_k\frac{t^k}{k!}A^k$ 逐项用 $A^k=E_1+4^kE_2$）：

$$e^{At}=e^{1\cdot t}E_1+e^{4t}E_2
=\frac13\begin{bmatrix}2e^t+e^{4t}&-e^t+e^{4t}\\ -2e^t+2e^{4t}&e^t+2e^{4t}\end{bmatrix}.$$

**验算**：$t=0$ 时 $\frac13\begin{bmatrix}3&0\\0&3\end{bmatrix}=I$ ✓；求导后在 $t=0$ 处 $\frac13\begin{bmatrix}6&3\\6&9\end{bmatrix}=\begin{bmatrix}2&1\\2&3\end{bmatrix}=A$ ✓；且 $\frac{d}{dt}e^{At}=Ae^{At}$ 对一切 $t$ 成立（逐项求导，$E_1,E_2$ 与 $A$ 可交换）。

**读法**：这正是 [3.6.4](sec36.md#ex-3.6.4) 的「解耦」在谱语言下的写法——$e^{At}$ 按特征值拆成两项，每项是一个谱阵乘上对应的标量指数。若 $A$ 不是单纯矩阵，$e^{At}$ 会出现 $t^ke^{\lambda t}$ 项（Jordan 块），谱分解的「干净」形式就不够了；这正是 [3.5](sec35.md) 的 Schur 型仍然必要的原因。∎
:::
:::

::: note 本编补 · 谱分解能定义哪些函数 {#note-3.7-functional}

定理 3.7.1 的证明只用了多项式的线性性与 $E_iE_j=\delta_{ij}E_i$，所以只要 $f$ 在谱 $\sigma(A)=\{\lambda_1,\cdots,\lambda_m\}$ 上有定义，就可以令

$$f(A)=\sum_{j=1}^{m}f(\lambda_j)E_j.$$

常用的三例：

- **逆**：$0\notin\sigma(A)$ 时 $A^{-1}=\sum_j\lambda_j^{-1}E_j$（与 [@note-3.7-resolvent] 一致）；
- **指数**：$e^{At}=\sum_je^{\lambda_jt}E_j$（[@ex-3.7.C]）；
- **平方根**：若所有 $\lambda_j\ge0$（实谱），$\sqrt A=\sum_j\sqrt{\lambda_j}E_j$，且 $(\sqrt A)^2=A$。

这条「函数演算」是矩阵分析的门票：矩阵对数、矩阵符号函数、矩阵的任意解析函数，都是同一个公式。前提始终是**$A$ 单纯**；非单纯矩阵要改用 Jordan 型 / Schur 型上的函数演算，形式会多出 $f^{(k)}(\lambda)$ 项。
:::

<a id="sec-3.7.4"></a>

## 3.7.4 正规矩阵的谱分解：正交投影

[3.6.4](sec36.md#sec-3.6.4) 的定理 3.6.2 说：正规矩阵可以酉对角化。把这句话翻译成谱分解的语言，会得到本节最漂亮的结论——**谱阵不仅是投影，还是正交投影**。

设 $A$ 正规，$U=[\boldsymbol u_1,\cdots,\boldsymbol u_n]$ 酉，$U^{\mathrm H}AU=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$。与 3.7.1 的推导逐字相同，只是 $P$ 换成了 $U$、$P^{-1}$ 换成了 $U^{\mathrm H}$：

$$A=U\operatorname{diag}(\lambda_1,\cdots,\lambda_n)U^{\mathrm H}
=\sum_{i=1}^{n}\lambda_i\boldsymbol u_i\boldsymbol u_i^{\mathrm H}.$$

按特征值分组：

$$A=\sum_{j=1}^{m}\lambda_j\underbrace{\Big(\sum_{i:\lambda_i=\lambda_j}\boldsymbol u_i\boldsymbol u_i^{\mathrm H}\Big)}_{E_j}.$$

这里的 $E_j$ 与 3.7.1 的谱阵是同一个东西（谱阵唯一，[@prop-3.7.1]（5）），但形状特殊：每一项 $\boldsymbol u_i\boldsymbol u_i^{\mathrm H}$ 都是 Hermite 的（$(\boldsymbol u\boldsymbol u^{\mathrm H})^{\mathrm H}=\boldsymbol u\boldsymbol u^{\mathrm H}$），求和仍是 Hermite 的。于是 $E_j^{\mathrm H}=E_j$。这正是「正交投影」的定义：

::: def 定义 3.7.3 · 正交投影矩阵 {#def-3.7.3}

设 $E\in\mathbb C^{n\times n}$，若

$$E^2=E=E^{\mathrm H},$$

则称 $E$ 为**正交投影矩阵**。
:::

（与 [@def-3.7.2] 对照：幂等只要求 $E^2=E$，那是「投影」；再加 $E^{\mathrm H}=E$ 才是「正交投影」。几何上，$E^2=E$ 保证 $\mathbb C^n=R(E)\oplus N(E)$、$E$ 沿 $N(E)$ 投到 $R(E)$；$E^{\mathrm H}=E$ 进一步保证 $R(E)\perp N(E)$——见 [@note-3.7-idempotent] 第 3 条。）

::: prop 命题 3.7.2 · 正规阵的谱阵性质 {#prop-3.7.2}

设复正规阵 $A$ 有谱分解式 $A=\sum_{j=1}^{m}\lambda_jE_j$，其中 $\lambda_1,\cdots,\lambda_m$ 是 $A$ 的 $m$ 个互异特征值，$E_1,\cdots,E_m$ 是 $A$ 的 $m$ 个谱阵，则 $\forall i,j=1,\cdots,m$ 且 $i\ne j$，有

（1）$E_j=(E_j)^2=E_j^{\mathrm H}$；

（2）$E_iE_j=0$；

（3）$E_iA=AE_i=\lambda_iE_i$；

（4）$\sum_{k=1}^{m}E_k=I$；

（5）谱阵集合 $\{E_1,\cdots,E_m\}$ 唯一。
:::

::: proof 证明（课件给出 (1) 的 Hermite 验算，其余由本编补）

由上面的推导，$E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol u_i\boldsymbol u_i^{\mathrm H}$，故

$$E_j^{\mathrm H}=\sum_i(\boldsymbol u_i\boldsymbol u_i^{\mathrm H})^{\mathrm H}=\sum_i\boldsymbol u_i\boldsymbol u_i^{\mathrm H}=E_j.$$

（1）的 $E_j^2=E_j$ 与（2）–（5）与 [@prop-3.7.1] 逐字相同——正规阵是单纯阵的特例，那五条性质自动成立；本命题的新内容是 $E_j^{\mathrm H}=E_j$。

**读法**：正规矩阵的谱分解 $A=\sum_j\lambda_jE_j$ 是一组**两两正交的 Hermite 幂等元**之和。用几何语言说：$\mathbb C^n$ 被**正交地**拆成特征子空间 $E(\lambda_1)\oplus\cdots\oplus E(\lambda_m)$，$E_j$ 是到第 $j$ 块的正交投影，$A$ 在每块上只是数乘 $\lambda_j$。这就是**谱定理**（spectral theorem）的矩阵形式。
:::

::: ex 例 3.7.D（新增，承接例 3.6.7）· 实对称矩阵的谱分解 {#ex-3.7.D}

设 $A=\begin{bmatrix}4&-2&1\\ -2&7&-2\\ 1&-2&4\end{bmatrix}$（[3.6.7](sec36.md#ex-3.6.7) 反求出的实对称矩阵）。求它的谱分解，并验证两个谱阵都是正交投影。

::: sol 解答

**特征值与特征向量**：由 [3.6.7](sec36.md#ex-3.6.7)，$\lambda=3$（二重）对应 $\boldsymbol x_1=(1,2,3)^{\mathrm T}$、$\boldsymbol x_2=(1,1,1)^{\mathrm T}$；$\lambda=9$ 对应 $\boldsymbol x_3=(1,-2,1)^{\mathrm T}$。

**正交化与单位化**：$\lambda=3$ 的特征子空间内部做 Gram–Schmidt：

$$\boldsymbol u_1=\frac{1}{\sqrt{14}}(1,2,3)^{\mathrm T},\qquad
\boldsymbol u_2=\frac{1}{\sqrt{21}}(4,1,-2)^{\mathrm T};$$

$\lambda=9$ 的特征向量单位化：

$$\boldsymbol u_3=\frac{1}{\sqrt6}(1,-2,1)^{\mathrm T}.$$

（验算：$\boldsymbol u_1^{\mathrm T}\boldsymbol u_2=0$、$\boldsymbol u_1^{\mathrm T}\boldsymbol u_3=0$、$\boldsymbol u_2^{\mathrm T}\boldsymbol u_3=0$；$\|\boldsymbol u_i\|=1$。）

**谱阵**：

$$E_2=\boldsymbol u_3\boldsymbol u_3^{\mathrm H}=\frac16\begin{bmatrix}1&-2&1\\ -2&4&-2\\ 1&-2&1\end{bmatrix},\qquad
E_1=\boldsymbol u_1\boldsymbol u_1^{\mathrm H}+\boldsymbol u_2\boldsymbol u_2^{\mathrm H}=I-E_2.$$

**验算**：

$$E_1+E_2=I,\qquad E_1E_2=O,\qquad E_1^2=E_1,\ E_2^2=E_2,\qquad E_1^{\mathrm T}=E_1,\ E_2^{\mathrm T}=E_2,$$

$$3E_1+9E_2=3I+6E_2=\begin{bmatrix}4&-2&1\\ -2&7&-2\\ 1&-2&4\end{bmatrix}=A.$$

**几何**：$E_2$ 是到 $\operatorname{span}\{(1,-2,1)^{\mathrm T}\}$ 的正交投影，$E_1$ 是到其正交补（$\lambda=3$ 的特征子空间）的正交投影；$\operatorname{rank}E_1=2=d_1$、$\operatorname{rank}E_2=1=d_2$，与 [@note-3.7-rank] 一致。∎
:::
:::

::: note 本编注 · 正交投影的几何：值域与核互相垂直 {#note-3.7-orth-proj}

设 $E^2=E=E^{\mathrm H}$。对任意 $\boldsymbol x,\boldsymbol y$，

$$(E\boldsymbol x,(I-E)\boldsymbol y)=(\boldsymbol x,E^{\mathrm H}(I-E)\boldsymbol y)=(\boldsymbol x,E(I-E)\boldsymbol y)=0,$$

故 $R(E)\perp N(E)$。又 $\boldsymbol x=E\boldsymbol x+(I-E)\boldsymbol x$ 给出 $\mathbb C^n=R(E)+N(E)$，两者交集为零（[@note-3.7-idempotent]），故

$$\mathbb C^n=R(E)\oplus N(E),\qquad R(E)\perp N(E).$$

反过来，若 $E$ 是沿 $N(E)$ 到 $R(E)$ 的投影且 $R(E)\perp N(E)$，则 $E$ 是正交投影（内积一算即得 $E^{\mathrm H}=E$）。所以「正交投影」四个字可以完全用**子空间的正交直和**来读：$E$ 是到 $R(E)$ 上的正交投影，当且仅当 $R(E)$ 的正交补就是 $N(E)$。谱定理说的正是：正规矩阵把整个空间拆成**互相正交**的特征子空间，每个 $E_j$ 都是到其中一块的正交投影。
:::

::: note 本编注 · 旋转阵的谱分解：复特征值、Hermite 谱阵 {#note-3.7-rotation}

[3.6](sec36.md#note-3.6-rotation) 的旋转阵 $A=\begin{bmatrix}0&-1\\ 1&0\end{bmatrix}$ 是正规阵，特征值 $\pm\mathrm i$，单位特征向量

$$\boldsymbol u_+=\frac{1}{\sqrt2}\begin{bmatrix}1\\ -\mathrm i\end{bmatrix},\qquad
\boldsymbol u_-=\frac{1}{\sqrt2}\begin{bmatrix}1\\ \mathrm i\end{bmatrix}.$$

谱阵

$$E_+=\boldsymbol u_+\boldsymbol u_+^{\mathrm H}=\frac12\begin{bmatrix}1&\mathrm i\\ -\mathrm i&1\end{bmatrix},\qquad
E_-=\boldsymbol u_-\boldsymbol u_-^{\mathrm H}=\frac12\begin{bmatrix}1&-\mathrm i\\ \mathrm i&1\end{bmatrix}.$$

验证：$E_++E_-=I$、$E_+E_-=O$、$E_+^{\mathrm H}=E_+$、$E_-^{\mathrm H}=E_-$，且

$$\mathrm iE_+-\mathrm iE_-=\begin{bmatrix}0&-1\\ 1&0\end{bmatrix}=A.$$

**读法**：$E_+$、$E_-$ 是**复**矩阵，但都是 Hermite 正交投影；特征值 $\pm\mathrm i$ 是复数，谱分解仍然成立。这再次说明：**正规矩阵的谱定理在 $\mathbb C$ 上永远有效**；若要求实谱阵 / 实特征值，就要回到 Hermite（实对称）的情形（[3.6.3](sec36.md#sec-3.6.3)）。
:::

::: note 本编注 · 谱定理的三层版本 {#note-3.7-three-levels}

把 3.6–3.7 的结论按「越来越强的前提」排成三层：

| 前提 | 结论 | 谱阵的性质 | 出处 |
|:--|:--|:--|:--|
| 单纯（可对角化） | $A=\sum_j\lambda_jE_j$ | $E_j^2=E_j$，$E_iE_j=0$，$\sum E_j=I$ | [@prop-3.7.1] |
| 正规（$A^{\mathrm H}A=AA^{\mathrm H}$） | $A=U\Lambda U^{\mathrm H}=\sum_j\lambda_jE_j$ | 再加 $E_j^{\mathrm H}=E_j$（正交投影） | [@prop-3.7.2] |
| Hermite / 实对称 | 同上，且 $\lambda_j\in\mathbb R$ | 同上，特征值全实 | [@cor-3.6.3]、[@cor-3.6.4] |

三层的前提依次加强，结论也依次加强：**投影 $\to$ 正交投影 $\to$ 实正交投影**。考试里看到「求正交矩阵 $Q$」，就要落到第三层；看到「求可逆 $P$」，第二层都用不上，第一层足够。
:::

::: preview 课程预告 · 从谱分解到奇异值分解

谱定理的适用范围有一个硬边界：$A$ 必须是**方阵**，而且必须**正规**。一般的长方矩阵 $A\in\mathbb C^{m\times n}$ 两条都不满足，但它仍有一套「几乎一样好」的分解——**奇异值分解**：

$$A=U\Sigma V^{\mathrm H},$$

其中 $U\in\mathbb C^{m\times m}$、$V\in\mathbb C^{n\times n}$ 酉，$\Sigma\in\mathbb R^{m\times n}$ 是非负对角阵。它的证明正是把谱定理用在 $A^{\mathrm H}A$（Hermite、半正定）上：$A^{\mathrm H}A=V\Sigma^{\mathrm T}\Sigma V^{\mathrm H}$，奇异值是 $A^{\mathrm H}A$ 特征值的平方根，右奇异向量是 $V$ 的列；对非零奇异值，左奇异向量由 $U=AV\Sigma^{-1}$ 给出，零奇异值方向再补齐。所以 3.7 的谱分解不是终点，而是 SVD 的「方阵预演」；[3.2](sec32.md) 预告的广义逆、最小二乘，也都从 SVD 出发。
:::

::: note 考情速递（本编依据课件小结与前章课堂考情整理；本讲无录播，未见老师原话）

3.7 的课件没有单独的小结页（3.6 的小结已把「正规矩阵酉相似对角化计算」列为核心），但本节内容是它的**计算内核**：求谱阵（例 3.7.1、例 3.7.2）、用谱阵算 $A^k$ / $f(A)$（[@thm-3.7.1]）、判断正交投影（[@prop-3.7.2]）。考试里常见的三种问法：① 「求 $A$ 的谱分解」——按 [@method-spectral] 或 [@thm-3.7.2] 算，验算 $\sum E_j=I$、$E_iE_j=0$；② 「用谱分解求 $A^{100}$ / $e^{At}$」——套 $\sum\lambda_j^kE_j$ / $\sum e^{\lambda_jt}E_j$；③ 「证明谱阵是正交投影 / 谱阵唯一」——用 [@prop-3.7.1]（5）与 [@prop-3.7.2]。跨章联动：3.5 的最小多项式给出 $m_A=\prod(\lambda-\lambda_j)$（[@note-3.7-minpoly]），3.6 的正规矩阵给出 $E_j^{\mathrm H}=E_j$，2.4 的特征子空间给出 $\operatorname{rank}E_j=d_j$。分级清单与限时赛制集中在[考场竞技场](arena.md)。
:::

## 3.7 小结与常见错误

- **一条主线**：**对角化分解**（$A=P\Lambda P^{-1}$）$\Rightarrow$ **按特征值分组**（$A=\sum_j\lambda_jE_j$，[@def-3.7.1]；三步法 [@method-spectral]；例 3.7.1）$\Rightarrow$ **谱阵五性质**（幂等、两两正交、与 $A$ 交换、求和为 $I$、唯一；[@prop-3.7.1]）$\Rightarrow$ **函数演算**（$f(A)=\sum_jf(\lambda_j)E_j$，[@thm-3.7.1]）$\Rightarrow$ **Lagrange 公式**（$E_i=f_i(A)/f_i(\lambda_i)$，[@thm-3.7.2]；例 3.7.2）$\Rightarrow$ **正规 $\Rightarrow$ 正交投影**（[@prop-3.7.2]；[@def-3.7.3]；例 3.7.D）。
- **两句话记住它**：**谱分解 $=$ 把对角化按特征值拆成「系数 $\times$ 投影」**——$\lambda_j$ 是数，$E_j$ 是投到第 $j$ 个特征子空间的投影；$A$ 在每块上只是数乘。**正规 $=$ 这些投影还能取正交**——$E_j^{\mathrm H}=E_j$，于是谱分解升级为谱定理。

::: think 常见错误清单 · 自查六条

1. **把 $P^{-1}$ 的列当成 $\boldsymbol\beta_i$**：$P^{-1}=[\boldsymbol\beta_1^{\mathrm H};\cdots;\boldsymbol\beta_n^{\mathrm H}]$ 是**按行**读，$\boldsymbol\beta_i^{\mathrm H}$ 是第 $i$ 行；写成列就得不到 $\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_j=\delta_{ij}$。
2. **谱阵下标与特征值错配**：$E_j$ 必须对应 $\lambda_j$；例 3.7.1 中 $E_1$ 对应 $\lambda=1$、$E_2$ 对应 $\lambda=-2$，写成 $E_1-2E_2$ 而不是 $E_1+2E_2$。
3. **把「幂等」与「正交投影」混为一谈**：$E^2=E$ 只保证是投影；$E^{\mathrm H}=E$ 才保证正交（[@def-3.7.3]）。非正规单纯矩阵的谱阵是斜投影（例 3.7.A）。
4. **忘记谱分解的前提是单纯**：不可对角化的矩阵没有这种「按特征值拆成投影」的谱分解；若硬写 $A=\sum\lambda_jE_j$，$E_j$ 不再是幂等的（会出现 Jordan 块的多项式项）。
5. **函数演算直接套到非单纯矩阵**：$f(A)=\sum_jf(\lambda_j)E_j$ 只对单纯矩阵成立；非单纯时要加 $f^{(k)}(\lambda)$ 项（Jordan 演算），指数会出现 $t^ke^{\lambda t}$。
6. **以为正规矩阵的谱阵一定是实矩阵**：正规矩阵的特征值可以是复数（旋转阵 $\pm\mathrm i$），谱阵也可以是复 Hermite 矩阵（[@note-3.7-rotation]）；「Hermite 谱阵」不等于「实谱阵」。
:::

::: ex 即时自测（不看上文，5 分钟）{#ex-3.7.quiz}

1. 写出谱分解的定义与谱阵的五条性质；说明为什么 $E_j$ 与 $P$ 的选取无关；
2. 设 $A=\begin{bmatrix}3&1\\ 0&2\end{bmatrix}$，求谱分解，并用它算 $A^5$；
3. 用定理 3.7.2 求 $A=\begin{bmatrix}2&1\\ 2&3\end{bmatrix}$ 的 $E_1,E_2$，并验证 $E_1+E_2=I$；
4. 证明：若 $A$ 正规，则它的每个谱阵都是正交投影；
5. 设 $E$ 是幂等阵，证明 $\operatorname{rank}E=\operatorname{tr}E$，并说明 $\mathbb C^n=R(E)\oplus N(E)$。

::: sol 参考要点

1. 定义见 [@def-3.7.1]；五条见 [@prop-3.7.1]：$E_j^2=E_j$、$E_iE_j=0$、$E_iA=AE_i=\lambda_iE_i$、$\sum E_k=I$、唯一。唯一性：若另有 $F_j$ 满足五条，则对 $f_i=\prod_{l\ne i}(\lambda-\lambda_l)$ 有 $f_i(A)=f_i(\lambda_i)F_i$，故 $F_i=f_i(A)/f_i(\lambda_i)=E_i$——与 $P$ 无关。
2. 特征值 $3,2$，特征向量 $(1,0)^{\mathrm T}$、$(1,-1)^{\mathrm T}$。$P=\begin{bmatrix}1&1\\0&-1\end{bmatrix}$，$P^{-1}=\begin{bmatrix}1&1\\0&-1\end{bmatrix}$（自逆），$\Lambda=\operatorname{diag}(3,2)$。$E_1=P\operatorname{diag}(1,0)P^{-1}=\begin{bmatrix}1&1\\0&0\end{bmatrix}$，$E_2=P\operatorname{diag}(0,1)P^{-1}=\begin{bmatrix}0&-1\\0&1\end{bmatrix}$。$A^5=3^5E_1+2^5E_2=243\begin{bmatrix}1&1\\0&0\end{bmatrix}+32\begin{bmatrix}0&-1\\0&1\end{bmatrix}=\begin{bmatrix}243&211\\0&32\end{bmatrix}$。（验算 $A^5$ 的对角元 $3^5,2^5$ ✓，迹 $275=243+32$ ✓。）
3. $E_1=\frac13\begin{bmatrix}2&-1\\-2&1\end{bmatrix}$，$E_2=\frac13\begin{bmatrix}1&1\\2&2\end{bmatrix}$（[@ex-3.7.2b]）；相加得 $I$ ✓。
4. 由 [@thm-3.6.2]，$A=U\Lambda U^{\mathrm H}$，$U$ 酉；按特征值分组得 $E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol u_i\boldsymbol u_i^{\mathrm H}$。每项 $\boldsymbol u_i\boldsymbol u_i^{\mathrm H}$ Hermite，求和仍 Hermite：$E_j^{\mathrm H}=E_j$；又 $E_j^2=E_j$（[@prop-3.7.1]），故 $E_j$ 是正交投影。
5. $E^2=E$ $\Rightarrow$ $E$ 可对角化、特征值 $0/1$（[@note-3.7-idempotent]）；对角化后秩 $=$ 非零特征值个数 $=$ 迹。对任意 $\boldsymbol x$，$\boldsymbol x=E\boldsymbol x+(I-E)\boldsymbol x$，第一项在 $R(E)$、第二项在 $N(E)$；若 $\boldsymbol y\in R(E)\cap N(E)$，写 $\boldsymbol y=E\boldsymbol x$，则 $\boldsymbol y=E\boldsymbol x=E^2\boldsymbol x=E\boldsymbol y=\boldsymbol 0$，故是直和。
:::
:::

> **下一站**：奇异值分解（3.8，待素材）——把「同一个标准正交基」放宽成「定义域与值域各一组」，一般矩阵也能写成 $A=U\Sigma V^{\mathrm H}$。
