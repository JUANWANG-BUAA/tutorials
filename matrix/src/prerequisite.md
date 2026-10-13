# 先修工具箱

正文多处标注「先修知识」——这些是本科线性代数已经讲过的结论，本教程直接引用，不再重证。若其中任何一条记忆模糊，**先花二十分钟读完本页再进正文**，比在正文里反复卡壳划算。本页只列出本教程真正用到的部分，不做完整复习。

每一条都给出「用在哪」，读的时候可对照正文回查。

## 1. 矩阵乘法的两种读法

设 $A=(a_{ij})\in F^{m\times n}$，$\boldsymbol{x}=(x_1,\cdots,x_n)^{\mathrm T}\in F^n$。乘积 $A\boldsymbol{x}$ 有两种同样正确的读法，本教程两种都在用：

**行观点（逐行点积）：**$A\boldsymbol{x}$ 的第 $i$ 个分量是 $A$ 的第 $i$ 行与 $\boldsymbol{x}$ 的内积。这是「一个方程一个约束」的来源。

**列观点（列的线性组合）：**把 $A$ 按列分块为 $A=(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)$，则

$$A\boldsymbol{x}=x_1\boldsymbol{\alpha}_1+x_2\boldsymbol{\alpha}_2+\cdots+x_n\boldsymbol{\alpha}_n.$$

也就是说：**$A\boldsymbol{x}$ 是 $A$ 的列以 $\boldsymbol{x}$ 的分量为系数组合出来的向量。**

> **用在哪：**列观点是 [1.2.7](ch01/sec12.md#sec-1.2.7) 列空间 $R(A)$ 与「$\boldsymbol{y}=A\boldsymbol{x}$ 可解 $\Longleftrightarrow$ $\boldsymbol{y}\in R(A)$」的全部依据。本节反复使用，值得先把它读顺。

## 2. 转置、共轭转置与迹

**转置** $A^{\mathrm T}$：行列互换，$(A^{\mathrm T})_{ij}=a_{ji}$。

**共轭转置** $A^{\mathrm H}$：先逐元素取复共轭，再转置。即 $A^{\mathrm H}=\overline{A^{\mathrm T}}$，分量形式 $(A^{\mathrm H})_{ij}=\overline{a_{ji}}$。

三条恒等式，本教程直接用：

$$(AB)^{\mathrm T}=B^{\mathrm T}A^{\mathrm T},\qquad (AB)^{\mathrm H}=B^{\mathrm H}A^{\mathrm H},\qquad (A^{\mathrm H})^{\mathrm H}=A.$$

**注意顺序要反过来**——这是最容易记错的一条。

**迹** $\operatorname{tr}A$：方阵对角线元素之和。线性性 $\operatorname{tr}(kA+lB)=k\operatorname{tr}A+l\operatorname{tr}B$ 在本教程中反复使用；另一条常用的性质是 $\operatorname{tr}(XY)=\operatorname{tr}(YX)$（方阵可乘时）。

> **用在哪：**$(AB)^{\mathrm H}=B^{\mathrm H}A^{\mathrm H}$ 是 [1.4.4](ch01/sec14.md#sec-1.4.4) 证明「Hermite 矩阵的二次型取实值」的关键一步；$\operatorname{tr}$ 的线性性用在 [1.2.3](ch01/sec12.md#sec-1.2.3) 的迹零子空间判定。

## 3. 行列式、可逆与齐次方程组的解

对**方阵** $A\in F^{n\times n}$，以下四条等价：

| 表述 | 等价的说法 |
|:--|:--|
| $A$ 可逆 | 存在 $B$ 使 $AB=BA=I$ |
| $\det A\neq0$ | 行列式非零 |
| 齐次方程组 $A\boldsymbol{x}=\boldsymbol{0}$ **只有零解** | 列向量组线性无关 |
| 对任意右端 $\boldsymbol{b}$，$A\boldsymbol{x}=\boldsymbol{b}$ **有唯一解** | 列向量组张成 $F^n$ |

最后两行正是本教程 1.3 节「基」的语言：**$n$ 个 $n$ 维向量构成基，等价于把它们拼成的方阵可逆。**

::: note 怎么用这张表

在具体题目里，判断「三个三维向量是不是一组基」的最快办法就是拼成矩阵算行列式：非零 ⟹ 是基。这是 [@ex-1.3.A] 的做法。反过来，若已知是一组基，就可以断言对应矩阵可逆——这是 [@prop-1.3.1]（1） 的论证方式。
:::

## 4. 秩、主元与自由未知量

对矩阵作初等**行**变换（交换两行、某行乘非零数、某行加上另一行的倍数）不改变：

- 矩阵的**秩**（$\operatorname{rank}A$，即行阶梯形中非零行的个数）；
- 齐次方程组 $A\boldsymbol{x}=\boldsymbol{0}$ 的**解集**。

把 $A$ 消成行阶梯形后：

- **主元**所在的列对应「受约束」的未知量，主元个数 = $\operatorname{rank}A$；
- 其余未知量称为**自由未知量**，个数为 $n-\operatorname{rank}A$。

由此得到本教程反复调用的两条结论：

**结论 A（解的存在性）：**$n$ 个方程 $m$ 个未知量的齐次方程组，若**未知量多于方程个数**（$m>n$），则必有非零解——因为自由未知量个数为 $m-\operatorname{rank}A$，而 $\operatorname{rank}A\leq n$，所以

$$m-\operatorname{rank}A\geq m-n>0.$$

至少有一个自由未知量，齐次方程组因而存在非零解。这里的 $m$ 始终表示未知量（矩阵列数），$n$ 表示方程个数（矩阵行数），不要与下一条 $A\in F^{m\times n}$ 的常用尺寸记号混用。

> **用在哪：**这是 [1.3.6](ch01/sec13.md#sec-1.3.6) 计数引理（「多于基数的向量必线性相关」）证明的最后一步，也是整个「维数」概念能成立的支点。

**结论 B（零空间维数）：**$\dim N(A)=n-\operatorname{rank}A$。

> **用在哪：**[@ex-1.2.B] 计算完 $N(A)$ 后都顺带核对「两者之和 = $n$」，依据即此。

## 5. 矩阵的秩 = 行秩 = 列秩

矩阵的秩可以用三种同样正确的方式理解：行阶梯形的非零行数、**行**向量组的极大无关组个数（行秩）、**列**向量组的极大无关组个数（列秩）。三者相等。

> **用在哪：**这是 [1.3.10](ch01/sec13.md#sec-1.3.10) 思考 4「$\dim R(A)=\operatorname{rank}A$」的依据；$\operatorname{rank}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)=r$ 与 $\dim\operatorname{span}(\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n)=r$ 能画等号，也靠这条。

## 6. 正定矩阵的判定

本科阶段主要处理**实对称矩阵**。对实对称 $A$，以下等价：$A$ 正定（对一切非零实向量 $\boldsymbol{x}$ 有 $\boldsymbol{x}^{\mathrm T}A\boldsymbol{x}>0$）$\Longleftrightarrow$ $A$ 的**全部特征值大于零** $\Longleftrightarrow$ $A$ 的**各阶顺序主子式全大于零**。

1.4 节不涉及特征值判定，实际使用的是**配方**：把一个具体的二次型写成若干完全平方之和，再检查是否存在非零向量使全部平方项同时为零。例如 [1.4.4](ch01/sec14.md#sec-1.4.4) 节的 [@ex-1.4.6] 中

$$\boldsymbol{x}^{\mathrm H}A_1\boldsymbol{x}=|x_1+ix_2|^2+|x_2|^2,$$

两个平方项同时为零强制 $x_1=x_2=0$，故正定；把系数改小后只剩一个平方项，就能找到非零向量让它为零，于是只得半正定。**「非零向量能否取到零」正是正定与半正定的分界。**

## 7. 特征值、特征多项式与对角化（第二章 2.4 的直接前置）

第二章 [2.4](ch02/sec24.md) 一开头就写「先修线性代数中矩阵特征值 / 特征向量的求法」，随后只做**翻译**（把矩阵的特征对翻译成线性变换的特征对），不再重复求法。所以这一节把那份「先修」补齐——如果你本科算过特征值，可以只扫一眼确认记号一致。

**特征值与特征向量。**设 $A\in F^{n\times n}$。若存在**非零**向量 $\boldsymbol{x}\in F^n$ 与数 $\lambda\in F$ 使

$$A\boldsymbol{x}=\lambda\boldsymbol{x},$$

则称 $\lambda$ 为 $A$ 的**特征值**，$\boldsymbol{x}$ 为 $A$ 的属于 $\lambda$ 的**特征向量**。「非零」是定义的一部分：若允许 $\boldsymbol{x}=\boldsymbol{0}$，则任何 $\lambda$ 都满足上式，这个概念就没有内容了。

**怎么求。**把 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 移项得 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$。这是一个**齐次**方程组，它要有非零解，当且仅当系数矩阵奇异：

$$\det(\lambda I-A)=0\quad(\text{与 }\det(A-\lambda I)=0\text{ 等价，差一个符号}).$$

左边是 $\lambda$ 的 $n$ 次多项式，称为 $A$ 的**特征多项式**；它的根就是全部特征值（在复数域上恰好 $n$ 个，按重数计）。求出 $\lambda$ 后，回代解 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$，其**基础解系**就是属于 $\lambda$ 的特征向量——注意这一步正是「零空间」，见第 4 节与 [1.2.2](ch01/sec12.md#sec-1.2.2)。

**两个立刻可用的验算公式**（考试用来对答案，比重新算一遍快）：

$$\operatorname{tr}A=\lambda_1+\cdots+\lambda_n,\qquad \det A=\lambda_1\lambda_2\cdots\lambda_n.$$

行列式那一条还有一层含义：$\det A=0\iff$ 某个 $\lambda_i=0$。所以**不可逆**等价于**有零特征值**。

**迹。**$\operatorname{tr}A$ 是主对角线元素之和（见第 2 节）。它和行列式都是**相似不变量**：若 $B=P^{-1}AP$，则 $\operatorname{tr}B=\operatorname{tr}A$、$\det B=\det A$，特征多项式也完全相同——这正是 [2.4](ch02/sec24.md) 反复要用的那条性质。

**对角化。**若存在可逆 $P$ 使 $P^{-1}AP=\operatorname{diag}(\lambda_1,\cdots,\lambda_n)$，就说 $A$ **可对角化**。充要条件是：$A$ 有 $n$ 个线性无关的特征向量。一个常用**充分**条件：$n$ 个特征值互不相同（此时特征向量自动线性无关）。反例说明「充分」不能改成「充要」：

$$A=\begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad \lambda=1\ \text{是二重根，但}\ A-I=\begin{pmatrix}0&1\\0&0\end{pmatrix}\ \text{的零空间只有一维},$$

所以 $A$ 凑不出两个线性无关的特征向量，**不能**对角化。（这条反例在 [2.4.3](ch02/sec24.md#sec-2.4.3) 里会用「几何重数 / 代数重数」的语言重新解释。）

::: note 与后文的分工

本节的求法在**坐标里**（矩阵语言）完成；[2.4](ch02/sec24.md) 要做的第一件事，是证明「$A$ 的特征值就是线性变换 $T$ 的特征值、$A$ 的特征向量就是 $T$ 的特征向量的坐标」——即**特征值与基的选取无关**。先把这里的算法练熟，那一节才读得动。
:::

## 8. 两个语言的对照表

本教程把本科熟悉的矩阵语言翻译成线性空间语言。先看一眼这张对照表，正文读起来会顺很多：

| 本科的说法 | 本教程的说法 |
|:--|:--|
| $\{\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n\}$ 线性无关 | 去掉任何一个都「少了方向」 |
| 「拼成矩阵求秩」 | 求向量组的秩（= 张成空间的维数） |
| 齐次方程组的基础解系 | 零空间 $N(A)$ 的一组基 |
| 齐次方程组的自由未知量个数 | $\dim N(A)=n-\operatorname{rank}A$ |
| 矩阵可逆 $\Longleftrightarrow$ $\det A\neq0$ | $n$ 个向量构成基 |
| $\det(\lambda I-A)=0$ 的根 | 特征值（与基的选取无关） |
| $(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$ 的基础解系 | 特征子空间 $V_\lambda=N(A-\lambda I)$ 的一组基 |

::: method 本页怎么用

不要背。把本页当成**工具抽屉**：正文里遇到「先修知识」四个字时，回来查对应的小节即可。真正需要记住的只有三件事——**列观点、可逆的四种等价说法、自由未知量的个数公式**，其余都可以现查。
:::
