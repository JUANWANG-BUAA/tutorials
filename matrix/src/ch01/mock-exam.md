# 综合自测卷

**用途：**在学完六节之后，检验自己是否真的掌握了第一章。**请计时、闭卷、独立完成**——查书或看解答做出来的分数没有意义。

**建议用时：90 分钟 · 满分 100 分。**做完后对照文末评分标准给自己打分，再用[自检表](checklist.md)反查到正文薄弱小节。

::: note 使用说明

本卷题目**绝大多数为新增**，覆盖与[习题集](exercises.md)相同的知识点；**第 9 题与习题 A14(c) 是同一道判断题，有意保留**——它是「直和的『存在唯一』等价刻画」这一最容易记反的判据，隔一段时间再做一次正好检验是否真的记住。解答默认折叠，便于自测。若某题完全无从下手，先做后面的题；全部做完后再回看。
:::

## 第一部分 · 概念判断（每题 3 分，共 30 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**1.** 若 $V$ 是数域 $F$ 上的线性空间，$\boldsymbol{\alpha}\in V$，则 $0\boldsymbol{\alpha}=\boldsymbol{\theta}$，其中左边的 $0$ 是数域 $F$ 的零、右边的 $\boldsymbol{\theta}$ 是 $V$ 的零向量。

**2.** 若 $W$ 是线性空间 $V$ 的非空子集，且对加法与数乘都封闭，则 $W$ 是 $V$ 的子空间。

**3.** 同一线性空间的两组不同基，所含向量个数一定相同。

**4.** 设 $A\in\mathbb{C}^{n\times n}$ 满足 $A^{\mathrm H}=A$，则对一切 $\boldsymbol{x}\in\mathbb{C}^n$，$\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$ 是实数。

**5.** 若向量组 $\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3$ 中任何两个都不成比例，则该向量组线性无关。

**6.** 设 $A\in\mathbb{C}^{m\times n}$，则 $\dim N(A)+\dim R(A)=n$。

**7.** 分别判断以下两句在任意实或复内积空间中是否成立：(a) Cauchy–Schwarz 取等号 $|(\boldsymbol{x},\boldsymbol{y})|=\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 当且仅当 $\boldsymbol{x},\boldsymbol{y}$ 线性相关；(b) $\boldsymbol{x}\perp\boldsymbol{y}$ 当且仅当 $\|\boldsymbol{x}+\boldsymbol{y}\|^2=\|\boldsymbol{x}\|^2+\|\boldsymbol{y}\|^2$。

**8.** 复向量 $\boldsymbol{x}=(1,i)^{\mathrm T}\in\mathbb{C}^2$ 的长度为 $\sqrt{1^2+i^2}=0$。

**9.** 若和空间 $W_1+W_2$ 中**存在**一个向量表法唯一，则 $W_1+W_2$ 是直和。

**10.** 若 $A\in\mathbb{C}^{n\times n}$ 满足 $A^2=A$，则 $\mathbb{C}^n=R(A)\dotplus N(A)$。

::: sol 第一部分答案（每题 3 分：判断 1 分 + 理由 2 分）

**1. 对。**这正是 [@thm-basic-props] 性质 (3)：$0\boldsymbol{\alpha}=\boldsymbol{\theta}$ 对任意 $\boldsymbol{\alpha}$ 成立。注意两边的「零」是不同对象的零——左边是数、右边是向量，这正是该式的意义所在。

**2. 对。**但结论依赖一个隐含前提：**数乘的数是 $V$ 所在数域 $F$ 中的数**，且 $W$ 非空。若 $W$ 非空且对 $F$ 的数乘、加法都封闭，则 [@thm-1.2.1] 条件 (2) 满足，$W$ 是子空间（零元与负元由封闭性自动造出）。**失分点：**漏掉「$W$ 必须先是 $V$ 的子集」或漏掉非空性。

**3. 对。**这就是 [@thm-1.3.3]。**理由必须落到计数引理：**若两基个数分别为 $m>n$，则 $m$ 个向量可由 $n$ 个表示，由计数引理必相关，与「是基」矛盾。

**4. 对。**这是 [@prop-1.4.1]。理由：$\overline{\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}}=(\boldsymbol{x}^{\mathrm H}A\boldsymbol{x})^{\mathrm H}=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}$（用了 $(BC)^{\mathrm H}=C^{\mathrm H}B^{\mathrm H}$ 与 $A^{\mathrm H}=A$）。一个数等于自身共轭当且仅当它是实数。

**5. 假。**两两不成比例**不能**推出三个向量无关。反例：$(1,0)^{\mathrm T},(0,1)^{\mathrm T},(1,1)^{\mathrm T}$ 两两不成比例，但 $(1,0)^{\mathrm T}+(0,1)^{\mathrm T}-(1,1)^{\mathrm T}=\boldsymbol{0}$，相关。（两两不成比例只保证组内没有两个相关的子组，但三向量相关可以不需要任何一对成比例。）

**6. 对。**这是秩–零化度定理的内容，[1.3.10](sec13.md#sec-1.3.10) 思考 3、4 合起来即此（那里只作为课程预告给出，此处能用消元直观验证即可）。严格证明见第二章：[2.2.5](../ch02/sec22.md#thm-2.2.5) 的亏加秩定理是它的一般形式，[定理 2.3.6](../ch02/sec23.md#thm-2.3.6) 给出矩阵版本。

**7. (a) 对，(b) 假。**(a) 带模的 C-S 等号条件在**实、复内积空间中都成立**：取等号当且仅当二者线性相关。若把模误删，写成 $(\boldsymbol{x},\boldsymbol{y})=\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$，结论才会出错，例如 $\boldsymbol{y}=-\boldsymbol{x}$。(b) 「正交 $\Rightarrow$ 勾股」在实、复空间都对，但逆命题在复空间失效：$x=1,y=i\in\mathbb{C}^1$ 满足 $\|x+y\|^2=\|x\|^2+\|y\|^2$，却 $(x,y)=-i\neq0$（勘误 E7）。**评分：**两小问各判断 1 分，能给出复空间反例 1 分。

**8. 假。**复空间的长度要逐分量取**模平方**：$\|\boldsymbol{x}\|=\sqrt{|1|^2+|i|^2}=\sqrt2$。用 $x_i^2$ 求和会把非零向量算成长度为零，违反正定性。

**9. 对。**定义要求的是「任意向量表法唯一」，但**只要有一个**就够了——因为不唯一性在直和里可以**平移**。反设和不是直和，则零元素有非平凡表法 $\boldsymbol{\theta}=\boldsymbol{w}_1+\boldsymbol{w}_2$（$\boldsymbol{w}_1\in W_1,\boldsymbol{w}_2\in W_2$ 不全为零）；把它叠加到任意拆法 $\boldsymbol{v}=\boldsymbol{v}_1+\boldsymbol{v}_2$ 上，得第二拆法 $\boldsymbol{v}=(\boldsymbol{v}_1+\boldsymbol{w}_1)+(\boldsymbol{v}_2+\boldsymbol{w}_2)$，且两者不同。所以「有一个向量表法唯一」与「不是直和」不能共存。**评分：**判断 1 分；能说出「非直和的不唯一性可平移」这一机制得 2 分。**易错提醒：**$xoy$ 与 $yoz$ 平面的和常被误当反例，但那里 $(1,0,0)^{\mathrm T}=(1,\mu,0)^{\mathrm T}+(0,-\mu,0)^{\mathrm T}$ 对任意 $\mu$ 成立，**并没有**表法唯一的向量。

**10. 对。**$A^2=A$ 时 $N(A)=R(I-A)$（双向包含，见 [1.6.4](sec16.md#sec-1.6.4) 思考框），而 [@ex-1.6.4] 已证 $\mathbb{C}^n=R(A)\dotplus R(I-A)$。**注意：**不能只说「$R(A)\cap N(A)=\{\boldsymbol{0}\}$」——那只给了直和，还需 $R(A)+N(A)$ 覆盖整个 $\mathbb{C}^n$。

:::

## 第二部分 · 计算题（每题 8 分，共 40 分）

**11.（8 分）**$\mathbb{R}^3$ 中取 $\boldsymbol{\alpha}_1=(1,1,1)^{\mathrm T}$，$\boldsymbol{\alpha}_2=(1,2,3)^{\mathrm T}$，$\boldsymbol{\alpha}_3=(1,4,9)^{\mathrm T}$。

(1) 判断 $\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3$ 是否构成 $\mathbb{R}^3$ 的一组基；
(2) 若构成，求 $\boldsymbol{x}=(1,0,1)^{\mathrm T}$ 在该基下的坐标。

**12.（8 分）**设 $W_1=\operatorname{span}\{(1,0,1)^{\mathrm T},(1,1,0)^{\mathrm T}\}$，$W_2=\operatorname{span}\{(0,1,1)^{\mathrm T},(1,1,1)^{\mathrm T}\}$。

(1) 求 $\dim(W_1+W_2)$ 与 $\dim(W_1\cap W_2)$；
(2) 写出 $W_1\cap W_2$ 的一组基。

**13.（8 分）**在 $\mathbb{R}^2$ 的标准内积下取基 $\boldsymbol{\varepsilon}_1=(1,0)^{\mathrm T}$，$\boldsymbol{\varepsilon}_2=(1,1)^{\mathrm T}$。

(1) 求度量矩阵 $G$；
(2) 用坐标公式计算 $\boldsymbol{x}=2\boldsymbol{\varepsilon}_1-\boldsymbol{\varepsilon}_2$ 与 $\boldsymbol{y}=\boldsymbol{\varepsilon}_1+3\boldsymbol{\varepsilon}_2$ 的内积，并直接回代验证；
(3) 这组基是正交基吗？若不是，用 Gram–Schmidt 把它化为标准正交基。

**14.（8 分）**设 $A=\begin{pmatrix}2&i\\-i&2\end{pmatrix}$。

(1) 验证 $A$ 是 Hermite 矩阵；
(2) 判断 $A$ 是否正定（用配方），并说明它能否定义 $\mathbb{C}^2$ 上的内积 $\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$。

**15.（8 分）**设 $W=\operatorname{span}\{(1,-1,0)^{\mathrm T},(1,0,-1)^{\mathrm T}\}$（$\mathbb R^3$ 标准内积），$\boldsymbol x=(1,2,3)^{\mathrm T}$。

(1) 求 $W^{\perp}$ 及其维数，并据此写出 $\mathbb R^3=W\oplus W^{\perp}$；
(2) 求 $\boldsymbol x$ 在 $W$ 与 $W^{\perp}$ 上的正交投影；
(3) 所给基 $(1,-1,0)^{\mathrm T},(1,0,-1)^{\mathrm T}$ 是正交基吗？这对 (2) 的计算有何影响，你如何处理？

::: sol 第二部分答案与评分要点

**11.（1）**（3 分）拼成矩阵取行列式：

$$\det(\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3)=\begin{vmatrix}1&1&1\\1&2&4\\1&3&9\end{vmatrix}.$$

这是三阶 Vandermonde 行列式（节点 $1,2,3$）：$\det=\prod_{i<j}(x_j-x_i)=(2-1)(3-1)(3-2)=2\neq0$。故三向量线性无关；又 $\dim\mathbb{R}^3=3$，由基扩充定理（[@cor-1.3.1] 前半：$n$ 个无关向量即为基），它们构成一组基。**评分：**算出非零 2 分，引用「$n$ 个无关向量是基」1 分。

**（2）**（5 分）设 $\boldsymbol{x}=a\boldsymbol{\alpha}_1+b\boldsymbol{\alpha}_2+c\boldsymbol{\alpha}_3$，按分量得

$$\begin{cases}a+b+c=1\\ a+2b+4c=0\\ a+3b+9c=1\end{cases}$$

用后两式减第一式：$b+3c=-1$，$2b+8c=0$，解得 $b=-4,\ c=1$，代回 $a-4+1=1$ 得 $a=4$。故坐标为 $(4,-4,1)^{\mathrm T}$。

**验证：**$4(1,1,1)-4(1,2,3)+(1,4,9)=(4-4+1,\ 4-8+4,\ 4-12+9)=(1,0,1)$ ✓。**评分：**列对方程组 2 分，解对 2 分，代回验证 1 分。**未验算扣 1 分。**

**12.（1）**（4 分）各组内两向量不成比例，故 $\dim W_1=\dim W_2=2$。四个向量拼成矩阵：

$$\begin{pmatrix}1&1&0&1\\0&1&1&1\\1&0&1&1\end{pmatrix}\xrightarrow{r_3-r_1}\begin{pmatrix}1&1&0&1\\0&1&1&1\\0&-1&1&0\end{pmatrix}\xrightarrow{r_3+r_2}\begin{pmatrix}1&1&0&1\\0&1&1&1\\0&0&2&1\end{pmatrix},$$

三个主元，故 $\dim(W_1+W_2)=3$。由维数公式 $\dim(W_1\cap W_2)=2+2-3=1$。

**（2）**（4 分）设公共向量

$$k_1(1,0,1)^{\mathrm T}+k_2(1,1,0)^{\mathrm T}=l_1(0,1,1)^{\mathrm T}+l_2(1,1,1)^{\mathrm T},$$

按分量比较得三个方程：

$$k_1+k_2=l_2,\qquad k_2=l_1+l_2,\qquad k_1=l_1+l_2.$$

后两式相减立刻得 $k_1=k_2$，记这个公共值为 $t$。代回：

- 第一式：$l_2=k_1+k_2=2t$；
- 第三式：$t=k_1=l_1+l_2=l_1+2t$，解得 $l_1=-t$。

（再把 $l_1=-t,\ l_2=2t$ 代回第二式核对：$l_1+l_2=t=k_2$ ✓，三个方程同时满足。）

于是公共向量恰为 $t(2,1,1)^{\mathrm T}$，即 $W_1\cap W_2=\operatorname{span}\{(2,1,1)^{\mathrm T}\}$，这组基含 1 个向量，与（1）中 $\dim(W_1\cap W_2)=1$ 一致。

**验证：**$(2,1,1)=(1,0,1)+(1,1,0)\in W_1$ ✓；$(2,1,1)=-(0,1,1)+2(1,1,1)=(2,1,1)\in W_2$ ✓。

**评分：**（1）两个维数各 1 分、和空间维数 2 分；（2）列对方程组 2 分，解对向量 1 分，验证 1 分。

**13.（1）**（3 分）按约定 $g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$：

$$G=\begin{pmatrix}(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_1)&(\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_1)\\(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2)&(\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_2)\end{pmatrix}=\begin{pmatrix}1&1\\1&2\end{pmatrix}.$$

**（2）**（3 分）坐标 $\boldsymbol{\xi}=(2,-1)^{\mathrm T}$、$\boldsymbol{\eta}=(1,3)^{\mathrm T}$，故

$$(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm T}G\boldsymbol{\xi}=\begin{pmatrix}1&3\end{pmatrix}\begin{pmatrix}1&1\\1&2\end{pmatrix}\begin{pmatrix}2\\-1\end{pmatrix}=1.$$

**回代：**$\boldsymbol{x}=2(1,0)-(1,1)=(1,-1)^{\mathrm T}$，$\boldsymbol{y}=(1,0)+3(1,1)=(4,3)^{\mathrm T}$，点积 $1\cdot4+(-1)\cdot3=1$ ✓。

**（3）**（2 分）**不是**正交基：$(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2)=1\neq0$（对应 $G$ 非对角元非零）。Gram–Schmidt：

$$\boldsymbol{y}_1=\boldsymbol{\varepsilon}_1=(1,0)^{\mathrm T},\qquad \boldsymbol{y}_2=\boldsymbol{\varepsilon}_2-\frac{(\boldsymbol{\varepsilon}_2,\boldsymbol{y}_1)}{(\boldsymbol{y}_1,\boldsymbol{y}_1)}\boldsymbol{y}_1=(1,1)^{\mathrm T}-1\cdot(1,0)^{\mathrm T}=(0,1)^{\mathrm T}.$$

单位化后即为 $\boldsymbol{q}_1=(1,0)^{\mathrm T}$、$\boldsymbol{q}_2=(0,1)^{\mathrm T}$ —— 原来的斜基化为标准正交基。

**评分：**$G$ 正确 3 分（下标约定错则 0 分）；内积算对并回代 3 分（漏回代扣 1 分）；正交性判断 + Gram–Schmidt 2 分。

**14.（1）**（2 分）$A^{\mathrm H}=\overline{A^{\mathrm T}}=\overline{\begin{pmatrix}2&-i\\i&2\end{pmatrix}}=\begin{pmatrix}2&i\\-i&2\end{pmatrix}=A$，故是 Hermite 矩阵。（对角元为实数、非对角元互为共轭，外观亦满足。）

**（2）**（6 分）令 $\boldsymbol{x}=(x_1,x_2)^{\mathrm T}$，把二次型展开：

$$\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}=2|x_1|^2+i\overline{x_1}x_2-i\overline{x_2}x_1+2|x_2|^2.$$

关键是认出中间的交叉项。由 $|x_1+ix_2|^2=(x_1+ix_2)(\overline{x_1}-i\overline{x_2})=|x_1|^2+|x_2|^2+i\overline{x_1}x_2-i\overline{x_2}x_1$ 可得

$$i\overline{x_1}x_2-i\overline{x_2}x_1=|x_1+ix_2|^2-|x_1|^2-|x_2|^2.$$

代回即得配方结果

$$\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}=|x_1+ix_2|^2+|x_1|^2+|x_2|^2.$$

三项都是模的平方，故 $\boldsymbol{x}^{\mathrm H}A\boldsymbol{x}\geq0$；若它等于 $0$，则三项各自为零，由 $|x_1|=|x_2|=0$ 得 $\boldsymbol{x}=\boldsymbol{0}$。因此 $A$ 正定。

由 [@ex-1.4.4] 的充要条件（$A$ 为 Hermite 且正定 $\Longleftrightarrow$ $\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 是内积），**$\boldsymbol{y}^{\mathrm H}A\boldsymbol{x}$ 确实定义 $\mathbb{C}^2$ 上的内积**。

**评分：**Hermite 判定 2 分；配方写成平方和 3 分（未真正配方、只作定性断言扣分）；结论引用 [@ex-1.4.4] 的充要条件 1 分。

**15.（1）**（3 分）设 $\boldsymbol u=(a,b,c)^{\mathrm T}\perp W$：$a-b=0$、$a-c=0$，解得 $a=b=c$，故

$$W^{\perp}=\operatorname{span}\{(1,1,1)^{\mathrm T}\},\qquad\dim W^{\perp}=1=3-2\ \checkmark .$$

由正交分解定理（[@thm-1.6.4]），$\mathbb R^3=W\oplus W^{\perp}$。**评分：**解出方程组并给出基 2 分，维数核算 + 引用定理 1 分。

**（2）**（3 分）先投补再相减（[@ex-1.6.6] 方法一）：$(\boldsymbol x,\boldsymbol u)=1+2+3=6$、$(\boldsymbol u,\boldsymbol u)=3$，故

$$\boldsymbol z=\operatorname{Proj}_{W^{\perp}}\boldsymbol x=\frac63(1,1,1)^{\mathrm T}=(2,2,2)^{\mathrm T},\qquad
\boldsymbol y=\boldsymbol x-\boldsymbol z=(-1,0,1)^{\mathrm T}.$$

**验证：**$\boldsymbol y\cdot\boldsymbol u=-1+0+1=0$，即 $\boldsymbol y\in W$ ✓；$\boldsymbol y+\boldsymbol z=\boldsymbol x$ ✓；勾股 $14=2+12$ ✓。**评分：**两个投影各 1 分，验证 1 分（未验算扣 1 分）。

**（3）**（2 分）**不是**正交基：$(1,-1,0)\cdot(1,0,-1)=1\neq0$。因此命题 1.6.1 的投影公式**不能直接用**（勘误 E12）；处理办法任选其一：① 走 (2) 的「先补后投」路线（$W^{\perp}$ 一维好投）；② 先 Gram–Schmidt 化为正交基再用公式：$\boldsymbol y_1=(1,-1,0)^{\mathrm T}$、$\boldsymbol y_2=(1,0,-1)^{\mathrm T}-\tfrac12(1,-1,0)^{\mathrm T}=(\tfrac12,\tfrac12,-1)^{\mathrm T}$，则 $\operatorname{Proj}_{W}\boldsymbol x=-\tfrac12\boldsymbol y_1-\boldsymbol y_2=(-1,0,1)^{\mathrm T}$，与 (2) 一致；③ 解 Gram 方程组（[@ex-1.6.3] 的通用算法）。**评分：**判断正交性 1 分，说出任一正确处理路线 1 分。

:::

## 第三部分 · 证明题（每题 15 分，共 30 分）

**16.（15 分）**设 $W_1,W_2$ 是线性空间 $V$ 的子空间。证明：$W_1\cup W_2$ 是 $V$ 的子空间当且仅当 $W_1\subseteq W_2$ 或 $W_2\subseteq W_1$。

**17.（15 分）**设 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n$ 是线性空间 $V$ 的一组基，$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n\in V$ 满足

$$\boldsymbol{y}_j=\sum_{i=1}^{n}a_{ij}\boldsymbol{\varepsilon}_i,\qquad j=1,\cdots,n.$$

证明：$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n$ 是 $V$ 的基，当且仅当矩阵 $A=(a_{ij})$ 可逆。

::: sol 第三部分答案与评分要点

**16.（15 分）**

**「$\Longleftarrow$」（5 分）**若 $W_1\subseteq W_2$，则 $W_1\cup W_2=W_2$ 是子空间；若 $W_2\subseteq W_1$，则 $W_1\cup W_2=W_1$ 是子空间。

**「$\Longrightarrow$」（10 分）**反设 $W_1\not\subseteq W_2$ 且 $W_2\not\subseteq W_1$，即存在 $\boldsymbol{\alpha}\in W_1\setminus W_2$ 与 $\boldsymbol{\beta}\in W_2\setminus W_1$。

令 $\boldsymbol{\gamma}=\boldsymbol{\alpha}+\boldsymbol{\beta}$。由假设 $W_1\cup W_2$ 对加法封闭，故 $\boldsymbol{\gamma}\in W_1\cup W_2$，即 $\boldsymbol{\gamma}\in W_1$ 或 $\boldsymbol{\gamma}\in W_2$。

- 若 $\boldsymbol{\gamma}\in W_1$：因 $\boldsymbol{\alpha}\in W_1$ 且 $W_1$ 是子空间，$\boldsymbol{\beta}=\boldsymbol{\gamma}-\boldsymbol{\alpha}\in W_1$，与 $\boldsymbol{\beta}\notin W_1$ 矛盾。
- 若 $\boldsymbol{\gamma}\in W_2$：同理 $\boldsymbol{\alpha}=\boldsymbol{\gamma}-\boldsymbol{\beta}\in W_2$，与 $\boldsymbol{\alpha}\notin W_2$ 矛盾。

两种情形都矛盾，故必有一个包含关系成立。

**评分：**「$\Longleftarrow$」5 分（两种包含情形各 2 分，说清「并集等于较大者」1 分）；「$\Longrightarrow$」10 分：反证假设 2 分；取到「互不包含」的两个向量 3 分；两种情况各 2 分；指出矛盾并收尾 1 分。**关键给分点：**必须显式用到「子空间对减法封闭」（即 $-\boldsymbol{\beta}\in W_1$），只写「由封闭性」而不交代减法合法性会扣 1 分。

**17.（15 分）**

记 $E=(\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n)$、$Y=(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_n)$，则题设即 $Y=EA$。

**「$\Longleftarrow$」（7 分）**设 $A$ 可逆。考虑 $k_1\boldsymbol{y}_1+\cdots+k_n\boldsymbol{y}_n=\boldsymbol{\theta}$，写成矩阵式 $Y\boldsymbol{k}=\boldsymbol{\theta}$，其中 $\boldsymbol{k}=(k_1,\cdots,k_n)^{\mathrm T}$。代入 $Y=EA$：

$$EA\boldsymbol{k}=\boldsymbol{\theta}\quad\Longrightarrow\quad A\boldsymbol{k}=\boldsymbol{\theta},$$

（第二步：$E$ 是基、其表示唯一，故 $A\boldsymbol{k}$ 的每个分量必为零；也可直接由基向量无关得到。）

由 $A$ 可逆，$\boldsymbol{k}=\boldsymbol{\theta}$，故 $\boldsymbol{y}$ 组线性无关。又 $\boldsymbol{y}$ 组恰含 $n$ 个向量而 $\dim V=n$，由基扩充定理（[@cor-1.3.1] 前半）它是基。

**「$\Longrightarrow$」（6 分）**设 $\boldsymbol{y}$ 组是基。由基表示唯一性，$A$ 的每一列是 $\boldsymbol{y}_j$ 在基 $E$ 下**唯一**的坐标，故 $A$ 由 $\boldsymbol{y}$ 组唯一确定。

反设 $A$ 不可逆，则齐次方程组 $A\boldsymbol{k}=\boldsymbol{\theta}$ 有非零解 $\boldsymbol{k}\neq\boldsymbol{\theta}$。于是

$$k_1\boldsymbol{y}_1+\cdots+k_n\boldsymbol{y}_n=Y\boldsymbol{k}=EA\boldsymbol{k}=E\boldsymbol{\theta}=\boldsymbol{\theta},$$

这是 $\boldsymbol{y}$ 组的一个非平凡零组合，与 $\boldsymbol{y}$ 组线性无关矛盾。故 $A$ 可逆。

**评分：**写出 $Y=EA$ 2 分；充分性 7 分（构造零组合、由可逆得 $\boldsymbol{k}=\boldsymbol{\theta}$、引用「$n$ 个无关向量是基」）；必要性 6 分（反设不可逆 2 分、取到非零解 2 分、导出矛盾 2 分）。

**另一种思路（加分不改分）：**必要性也可用「$A$ 不可逆 $\Longrightarrow$ 存在非零 $\boldsymbol{k}$ 使 $A\boldsymbol{k}=\boldsymbol{0}$」直接反证，与 [@prop-1.3.1]（1）的证明同构。本题正是「过渡矩阵可逆」这条性质的一般形式。

:::

## 评分标准与后续

**总分 100 分。**各部分建议的达标线：

| 分数段 | 含义 | 下一步 |
|:--:|:--|:--|
| **90–100** | 概念与计算都扎实，能独立完成证明 | 可直接进入第二章（矩阵的标准形）。 |
| **75–89** | 主干掌握，个别细节不稳 | 用[自检表](checklist.md)找出失分条目对应的小节，重读该节的「即时自测」。 |
| **60–74** | 定义记得住，但用起来会混 | 重做[习题集](exercises.md) B 组，重点练「证明的书写」；把每节的「常见错误」清单抄一遍。 |
| **< 60** | 需要系统性重学 | 回到[先修工具箱](../prerequisite.md)确认先修无缺口，再从 [1.1](sec11.md) 按标准路径重读一遍，每节末做「即时自测」。 |

::: method 复盘比分数重要

无论得多少分，做完后请**为每道错题写一行复盘**，格式固定为一句话：

> 「我在 `____` 这一步错了，原因是 `____`，正确做法是 `____`。」

如果同一类错误（如「忘记验证零元」「坐标用错基」「把合同当相似」「复空间硬套实空间结论」「谈投影不说补空间」）出现两次以上，那不是粗心，而是概念缺口——回到对应小节，而不是多做题。
:::
