# 综合自测卷

**用途：**在学完 2.1–2.5 之后，检验自己是否真的掌握了第二章。**请计时、闭卷、独立完成**——查书或看解答做出来的分数没有意义。

**建议用时：90 分钟 · 满分 100 分。**做完后对照文末评分标准给自己打分，再用[学习目标自检表](checklist.md)反查到正文薄弱小节。

::: note 使用说明

本卷题目**绝大多数为新增**，覆盖与[习题集](exercises.md)相同的知识点，并逐条对准[自检表](checklist.md)里 2.4–2.5 的关键目标（K2.23–K2.28、S2.5–S2.6、A2.5）。**第 16 题与习题 B4 考的是同一条定理（亏加秩），有意保留**——它是第二章的不变量主干，隔一段时间再完整证一遍，正好检验是不是真的会写「基扩充」那四步。**第 13 题把 2.1 的友矩阵与 2.4 的特征对串成一题**，考的是「矩阵 → 特征值 → 坐标 → 乘回基」这条完整流程，最后一步最容易漏。解答默认折叠，便于自测。若某题完全无从下手，先做后面的题；全部做完后再回看。
:::

## 第一部分 · 概念判断（每题 3 分，共 30 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**1.** 判断以下三句：**(a)** 映射的三要素是定义域、值域与对应法则；**(b)** 映射 $f:V\to W$ 的值域 $R(f)$ 是 $W$ 的子集，$R(f)=W$ 是「满射」的额外要求，而**不是**映射定义的一部分；**(c)** 又，「变换」指 $V$ 到自身的映射，「一一变换」指 $V$ 到自身的双射，「置换」指有限集上的一一变换，故 $\mathbb R^2$ 上的恒等映射是变换、是一一变换，但不是置换。

**2.** 设 $T$ 是线性空间 $V$ 到 $W$ 的线性映射，$\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_p\in V$。判断以下两句：**(a)** 若 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_p$ 线性相关，则 $T(\boldsymbol{\alpha}_1),\cdots,T(\boldsymbol{\alpha}_p)$ 线性相关；**(b)** 反之，若 $T(\boldsymbol{\alpha}_1),\cdots,T(\boldsymbol{\alpha}_p)$ 线性相关，则 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_p$ 线性相关。

**3.** 单射判据「$T$ 是单射 $\iff$ $V$ 中任一线性无关向量组的像仍线性无关」本身**不需要**任何维数假设；但由「$T$ 是单射」推出「$T$ 是双射」时，必须补上 $\dim V=\dim W$ 这个前提。

**4.** 设 $T:\mathbb C\to\mathbb C$ 定义为 $T(z)=\bar z$（取共轭），则 $T$ 是 $\mathbb C$ 上的线性变换。

**5.** 设 $T\in L(V,W)$ 在 $V$ 的基 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n$ 与 $W$ 的基 $\boldsymbol{\eta}_1,\cdots,\boldsymbol{\eta}_m$ 下的矩阵为 $A$。判断以下三句：**(a)** $A$ 的第 $j$ 列是 $T(\boldsymbol{\varepsilon}_j)$ 在基 $\boldsymbol{\eta}$ 下的坐标；**(b)** $A$ 是 $m\times n$ 矩阵，且对任意 $\boldsymbol{x}\in V$，$T(\boldsymbol{x})$ 的坐标 $\boldsymbol{\beta}$ 与 $\boldsymbol{x}$ 的坐标 $\boldsymbol{\alpha}$ 满足 $\boldsymbol{\beta}=A\boldsymbol{\alpha}$；**(c)** 取定这两组基后，$L(V,W)$ 中每个 $T$ 恰好对应一个矩阵 $A$，且每个矩阵 $A$ 也恰好对应一个 $T$。

**6.** 设 $A,B$ 是 $n$ 阶方阵，$V,W$ 是同一数域上两个有限维线性空间。判断以下三句：**(a)** $A\sim B$（相似）$\Longrightarrow$ $A\cong B$（相抵）；**(b)** $A\cong B$（相抵）$\Longrightarrow$ $A\sim B$（相似）；**(c)** $V$ 与 $W$ 等势 $\Longrightarrow$ $V$ 与 $W$ 同构。

**7.** 若两个 $n$ 阶矩阵的特征多项式相同，则它们的属于同一特征值的**特征子空间维数**也相同。

**8.** 设 $A\sim B$（相似）。则 $\operatorname{tr}A=\operatorname{tr}B$、$\det A=\det B$、$\operatorname{rank}A=\operatorname{rank}B$，且对每个特征值 $\lambda$ 有 $\dim V_\lambda(A)=\dim V_\lambda(B)$；但 $A$ 与 $B$ 的属于同一特征值的特征向量（作为 $\mathbb C^n$ 中的坐标列）一般**不**相同。

**9.** 判断以下两句：**(a)** 实正交矩阵的特征值只能是 $\pm1$；**(b)** Givens 矩阵 $T_{ij}(\varphi)$ 是「旋转」（$\det T_{ij}=1$），Householder 矩阵 $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$ 是「镜像」（$\det H=-1$），两者都是正交矩阵。

**10.** 判断以下两句：**(a)** 设 $V$ 是欧氏空间、$T\in L(V)$。若 $T$ 保长度（$\|T\boldsymbol{x}\|=\|\boldsymbol{x}\|$ 对一切 $\boldsymbol{x}\in V$），则 $T$ 保内积；**(b)** 在本课程约定的复内积下（对第一变元线性、对第二变元共轭线性），对任意 $t\in\mathbb C$ 有 $(\boldsymbol{x},t\boldsymbol{y})=t\,(\boldsymbol{x},\boldsymbol{y})$。

::: sol 第一部分答案（每题 3 分：判断 1 分 + 理由 2 分）

**1. 对。**三句都对。**(a)** 三要素见 [@def-2.1.1]：定义域 $V$、值域 $R(f)$ 与对应法则；判「是不是映射」时先问「是不是对**每个** $x$ 都有像、像是否**唯一**」。**(b)** $R(f)\subseteq W$ 是定义的一部分，$R(f)=W$ 则是**满射**这条额外性质（[@def-2.1.2]）——把两者混为一谈是判「满射」时最常见的错。**(c)** 这正是 [@def-2.1.6] 的三个定义：变换 $=V\to V$ 的映射；一一变换 $=V\to V$ 的**双射**；置换 $=$ **有限集**上的一一变换。$\mathbb R^2$ 上的恒等映射是 $\mathbb R^2\to\mathbb R^2$ 的双射，故是变换与一一变换；但 $\mathbb R^2$ 不是有限集，故**不是**置换。**失分点：**把「置换」误当成「任意集合上的一一变换」——它多出的条件正是「$V$ 有限」。（顺带记住：$I_V$ 与 $I_W$ 因定义域不同而不相等，[@def-2.1.3]。）

**2. (a) 对，(b) 假。****(a)** 就是 [@cor-2.2.1]（3）：由相关存在**不全为零**的 $k_1,\cdots,k_p$ 使 $k_1\boldsymbol{\alpha}_1+\cdots+k_p\boldsymbol{\alpha}_p=\boldsymbol{\theta}$；作用 $T$ 并用保持线性组合（[@thm-2.2.1]）与 $T(\boldsymbol{\theta})=\boldsymbol{\theta}'$ 得

$$k_1T(\boldsymbol{\alpha}_1)+\cdots+k_pT(\boldsymbol{\alpha}_p)=\boldsymbol{\theta}',$$

系数 $k_i$ 仍不全为零，故像组相关。**(b)** 反例：零映射 $T(\boldsymbol{x})=\boldsymbol{\theta}'$ 把任何线性无关组都映成零组（相关），而原组无关——它正是那个「逆命题不真」的标准反例。**评分：**两个判断各 1 分，正确反例 1 分。

**3. 对。**两句都对，且合起来正是 [@thm-2.2.2] 之后的「维数陷阱」。判据本身只谈「单射 $\iff$ 无关组的像无关」，与维数无关：$\dim W<\dim V$ 时不存在单射，但**两边同时为假**，等价依然成立。而「单射 $\Longrightarrow$ 双射」必须先设 $\dim V=\dim W$（[@cor-2.2.2]）：否则单射只给出 $\dim R(T)=\dim V\le\dim W$，满射无从谈起。**做题前先看题目给没给「同维」条件**，不要默认。

**4. 假。**$T$ **不是** $\mathbb C$ 上的线性变换：齐次性对 $\lambda=i$ 失败——取 $z\neq0$，

$$T(iz)=\overline{iz}=-i\bar z=-i\,T(z)\neq i\,T(z).$$

它只是把 $\mathbb C$ 看作**实**线性空间时的线性变换（可加性成立、对实数 $\lambda$ 齐次）。**要点：**「线性」必须绑定数域（[@def-2.2.1] 的注记 1）——判线性之前先问「在哪个数域上线性」。

**5. 对。**三句分别是 [@def-2.3.1] 的读法、坐标公式（[@thm-2.3.4]）与存在唯一性（[@thm-2.3.1]）。**(a)** 的定义方式就是「$A$ 的第 $j$ 列 $=T(\boldsymbol{\varepsilon}_j)$ 的坐标」——注意是**像的坐标**，不是「$T$ 的第 $j$ 个分量」。**(b)** $A$ 是 $m\times n$：**行数 $=$ 到达空间维数 $\dim W$、列数 $=$ 出发空间维数 $\dim V$**（「横着读像、竖着数向量」）。**(c)** 存在性（满射）$+$ 唯一性（单射）就是「$T\mapsto A$ 是双射」，这也是 $L(V,W)\cong F^{m\times n}$ 的前半（[@thm-2.3.2]）。**失分点：**把形状写成 $n\times m$（把行数记成 $\dim V$）。

**6. (a) 对，(b) 假，(c) 假。****(a)** $B=P^{-1}AP$ 就是取 $Q=P$ 的相抵，故相似必相抵。**(b)** 反例：$A=\operatorname{diag}(1,0)$ 与 $B=\operatorname{diag}(2,0)$ 同型同秩，可以经初等变换互化（相抵），但不相似——相似保持特征值（$1$ 与 $2$ 不同），相抵只保持秩；更根本地，相抵允许两侧用**互不相关**的可逆矩阵、且对同型长方阵也有定义，而相似只对**同阶方阵**定义（[@thm-2.3.5]、[@cor-2.3.4]；相抵与相似的关系见[勘误 §五的补注](errata.md#errata-2.5)）。**(c)** 等势只保证**存在**一个双射（[@def-2.1.A]），同构还要求这个双射**保持加法与数乘**（[@def-2.3.2]），判别依据是**维数相等**（[@thm-2.3.3]）：例如 $\mathbb R$ 与 $\mathbb R^2$ 作为集合等势（都是连续统，集合论的标准结论），但 $\dim\mathbb R=1\neq2=\dim\mathbb R^2$，二者不同构。**评分：**三个判断各 1 分。

**7. 假。**反例就是 [三矩阵例](sec24.md#ex-jordan-three)：

$$J_1=\begin{pmatrix}1&&\\&1&\\&&1\end{pmatrix},\qquad
J_2=\begin{pmatrix}1&1&\\&1&\\&&1\end{pmatrix},\qquad
J_3=\begin{pmatrix}1&1&\\&1&1\\&&1\end{pmatrix}.$$

三者的特征多项式都是 $(\lambda-1)^3$（代数重数均为 $3$），但 $\dim V_1$ 依次为 $3-0=3$、$3-1=2$、$3-2=1$。原因是几何重数由**秩**决定：$\dim V_\lambda=n-\operatorname{rank}(A-\lambda I)$（[@thm-geom-mult]），而秩并不是特征多项式的函数。**一句话：**特征多项式没有包含特征结构的全部信息。

**8. 对。**前一半是 [@thm-sim-invariants]：特征多项式（从而特征值含重数）、$\operatorname{tr}$、$\det$、$\operatorname{rank}$ 都是相似不变量；几何重数也是——

$$\dim V_\lambda(A)=n-\operatorname{rank}(A-\lambda I)=n-\operatorname{rank}\big(P^{-1}(A-\lambda I)P\big)=n-\operatorname{rank}(B-\lambda I)=\dim V_\lambda(B).$$

后一半也成立：由 $B=P^{-1}AP$，

$$A\boldsymbol{x}=\lambda\boldsymbol{x}\iff B(P^{-1}\boldsymbol{x})=\lambda (P^{-1}\boldsymbol{x}),$$

故二者的特征向量（坐标列）相差一个 $P^{-1}$，一般并不相同；在变换层面，这正是「$T$ 的特征向量本身不变、而它的**坐标**随基改变」（[@thm-eig-bridge]）。

**9. (a) 假，(b) 对。****(a)** 只能保证 $|\lambda|=1$（[@thm-orth-eig]），复特征值完全可能出现：$A=\begin{pmatrix}0&-1\\1&0\end{pmatrix}$ 是正交矩阵，特征值为 $\pm i$。错误证明的根子在于把 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 当长度——复向量下它可以是 $0$（如 $\boldsymbol{x}=(1,i)^{\mathrm T}$），见 [错误证明警示](sec25.md#errata-orth-false)。**(b)** 对：$T_{ij}$ 在一个坐标平面内转动、$\det T_{ij}=1$；$H$ 关于超平面 $\boldsymbol{\omega}^{\perp}$ 作镜像、$\det H=-1$；两者都满足 $A^{\mathrm T}A=I$（[@thm-givens-props]、[@thm-householder-props]）。**评分：**两个判断各 1 分，给出 $\pm i$ 一类反例 1 分。

**10. (a) 对，(b) 假。****(a)** 这正是 [@thm-orth-equiv] 的 ①$\iff$②：保长度 $+$ 线性 $\Longrightarrow$ 保内积（证明走 ②$\Longrightarrow$③$\Longrightarrow$④$\Longrightarrow$①；酉空间里第二步要用 $\boldsymbol{q}_i+t\boldsymbol{q}_j$ 极化才能把虚部钉死）。**(b)** 从**第二变元**提出复数必须取**共轭**：$(\boldsymbol{x},t\boldsymbol{y})=\bar t\,(\boldsymbol{x},\boldsymbol{y})$；只有从**第一**变元提出才不取共轭（[共轭陷阱](sec25.md#errata-conj-pitfall)）。**评分：**两个判断各 1 分，写出正确的 $(\boldsymbol{x},t\boldsymbol{y})=\bar t(\boldsymbol{x},\boldsymbol{y})$ 1 分。

:::

## 第二部分 · 计算题（每题 8 分，共 40 分）

**11.（8 分）**设 $V=\mathbb R^{2\times2}$ 是全体 $2$ 阶实矩阵构成的线性空间，定义映射

$$T:V\to V,\qquad T(X)=X+X^{\mathrm T}.$$

(1) 验证 $T$ 是 $V$ 上的线性变换；
(2) 求 $N(T)$ 与 $R(T)$ 的基和维数；
(3) 验证亏加秩定理 $\dim N(T)+\dim R(T)=\dim V$；
(4) 求 $\dim L(V,V)$，并说明依据。

**12.（8 分）**设 $\mathbb R^3$ 与 $\mathbb R^2$ 分别取标准基 $\boldsymbol{e}_1,\boldsymbol{e}_2,\boldsymbol{e}_3$ 与 $\boldsymbol{f}_1,\boldsymbol{f}_2$，线性映射 $T:\mathbb R^3\to\mathbb R^2$ 定义为

$$T(\boldsymbol{x})=\begin{pmatrix}x_1+x_2\\ x_2+x_3\end{pmatrix},\qquad \boldsymbol{x}=(x_1,x_2,x_3)^{\mathrm T}.$$

(1) 写出 $T$ 在标准基下的矩阵 $A$，并用坐标公式 $\boldsymbol{\beta}=A\boldsymbol{\alpha}$ 计算 $T(1,2,3)^{\mathrm T}$；
(2) 在 $\mathbb R^3$ 中取新基 $\boldsymbol{\varepsilon}'_1=\boldsymbol{e}_1$、$\boldsymbol{\varepsilon}'_2=\boldsymbol{e}_1+\boldsymbol{e}_2$、$\boldsymbol{\varepsilon}'_3=\boldsymbol{e}_3$，在 $\mathbb R^2$ 中取新基 $\boldsymbol{\eta}'_1=\boldsymbol{f}_1+\boldsymbol{f}_2$、$\boldsymbol{\eta}'_2=\boldsymbol{f}_2$；写出过渡矩阵 $Q$、$P$，并用换基公式求 $T$ 在新基对下的矩阵 $B$；
(3) 逐列验算你算出的 $B$；
(4) 求 $\dim N(T)$ 与 $\operatorname{rank} A$，并核对亏加秩定理。

**13.（8 分）**设 $V$ 是数域 $\mathbb R$ 上的线性空间，$\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_3$ 是 $V$ 的一组基，线性变换 $T\in L(V)$ 在这组基下的矩阵为

$$A=\begin{pmatrix}0&1&0\\ 0&0&1\\ 8&-14&7\end{pmatrix}.$$

(1) 写出 $A$ 所对应的首一多项式 $f(\lambda)$，并说明 $A$ 是它的友矩阵；
(2) 求 $T$ 的全部特征值与各自的代数重数，并用迹、行列式核对；
(3) 对每个特征值求特征子空间 $V_\lambda$ 的基与几何重数，并判断 $T$ 能否对角化；
(4) 写出 $T$ 的属于 $\lambda=2$ 的**全部**特征向量（要求用 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_3$ 表示），并给出一组基使 $T$ 的矩阵为对角形、写出该对角形。

**14.（8 分）**取 $\boldsymbol{x}=(1,2,2)^{\mathrm T}\in\mathbb R^3$，要用 Givens 旋转把它化为 $\|\boldsymbol{x}\|\boldsymbol{e}_1$。

(1) 求 $T_{12}(\varphi)$ 使 $T_{12}\boldsymbol{x}$ 的第 $2$ 个分量为 $0$：写出 $T_{12}$ 并验算；
(2) 对**更新后**的向量再求 $T_{13}(\psi)$ 把第 $3$ 个分量化为 $0$，并验证 $T_{13}T_{12}\boldsymbol{x}=\|\boldsymbol{x}\|\boldsymbol{e}_1$；
(3) 按作用顺序写出总变换，并说明为什么顺序不能写反；
(4) 说明 $T_{13}T_{12}$ 是正交矩阵，并求 $\det(T_{13}T_{12})$。

**15.（8 分）**取 $\boldsymbol{x}=(0,3,4)^{\mathrm T}$，用**一个** Householder 矩阵把 $\boldsymbol{x}$ 映成 $\|\boldsymbol{x}\|\boldsymbol{e}_1$。

(1) 写出所需的单位向量 $\boldsymbol{\omega}$ 与矩阵 $H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$；
(2) 验算 $H\boldsymbol{x}=\|\boldsymbol{x}\|\boldsymbol{e}_1$；
(3) 验证 $H^{\mathrm T}=H$、$H^2=I$、$\det H=-1$；
(4) 写出 $H$ 的几何意义（镜面是哪个超平面），并写出 $H$ 的全部特征值及其重数。

::: sol 第二部分答案与评分要点

**11.（1）**（2 分）先确认 $T$ 是**良定义的映射**：$X+X^{\mathrm T}$ 仍是 $2$ 阶实矩阵，且由 $X$ 唯一确定，故 $T:V\to V$。再验两条（$k\in\mathbb R$）：

$$T(X+Y)=(X+Y)+(X+Y)^{\mathrm T}=X+X^{\mathrm T}+Y+Y^{\mathrm T}=T(X)+T(Y),$$
$$T(kX)=kX+(kX)^{\mathrm T}=kX+kX^{\mathrm T}=k\,T(X)$$

（用了 $(X+Y)^{\mathrm T}=X^{\mathrm T}+Y^{\mathrm T}$、$(kX)^{\mathrm T}=kX^{\mathrm T}$）。故 $T$ 是线性变换。**评分：**良定义 1 分，两条性质 1 分。

**（2）**（4 分）取 $X=\begin{pmatrix}a&b\\c&d\end{pmatrix}$，则 $X+X^{\mathrm T}=\begin{pmatrix}2a&b+c\\ b+c&2d\end{pmatrix}$。

**$N(T)$：**$X+X^{\mathrm T}=O$ 当且仅当 $a=0$、$d=0$、$c=-b$，故

$$N(T)=\left\{\begin{pmatrix}0&b\\ -b&0\end{pmatrix}\ \Big|\ b\in\mathbb R\right\}=\operatorname{span}\left\{\begin{pmatrix}0&1\\ -1&0\end{pmatrix}\right\},\qquad \dim N(T)=1 .$$

**$R(T)$：**$X+X^{\mathrm T}$ 总是**对称**矩阵（$(X+X^{\mathrm T})^{\mathrm T}=X^{\mathrm T}+X$）；反之任一对称矩阵 $S$（$S^{\mathrm T}=S$）取 $X=\tfrac12S$ 即得 $T(X)=\tfrac12(S+S^{\mathrm T})=S$，故

$$R(T)=\left\{S\ \big|\ S^{\mathrm T}=S\right\}=\operatorname{span}\left\{\begin{pmatrix}1&0\\ 0&0\end{pmatrix},\ \begin{pmatrix}0&1\\ 1&0\end{pmatrix},\ \begin{pmatrix}0&0\\ 0&1\end{pmatrix}\right\},\qquad \dim R(T)=3 .$$

三个生成元线性无关（第 1、3 个分别只在 $(1,1)$、$(2,2)$ 位置非零，剩下第 2 个由 $(1,2)$ 位置定）。**评分：**$N(T)$、$R(T)$ 各 2 分（基 1 分 $+$ 维数 1 分）。

**（3）**（1 分）$\dim N(T)+\dim R(T)=1+3=4=\dim\mathbb R^{2\times2}$ ✓，与 [@thm-2.2.5] 一致。

**（4）**（1 分）$\dim L(V,V)=\dim V\cdot\dim V=4\times4=16$。依据：取定一组基后 $L(V,V)\cong\mathbb R^{4\times4}$（[@thm-2.3.2]），而同构的空间维数相等（[@thm-2.3.3]），且 $\dim L(V,W)=\dim V\cdot\dim W$（[@cor-2.3.2]）。

**12.（1）**（2 分）逐列读「基向量被映到哪里」：

$$T(\boldsymbol{e}_1)=\begin{pmatrix}1\\0\end{pmatrix},\qquad T(\boldsymbol{e}_2)=\begin{pmatrix}1\\1\end{pmatrix},\qquad T(\boldsymbol{e}_3)=\begin{pmatrix}0\\1\end{pmatrix}
\ \Longrightarrow\ A=\begin{pmatrix}1&1&0\\ 0&1&1\end{pmatrix}\in\mathbb R^{2\times3}.$$

$\boldsymbol{\alpha}=(1,2,3)^{\mathrm T}$，故 $\boldsymbol{\beta}=A\boldsymbol{\alpha}=\begin{pmatrix}1+2\\ 2+3\end{pmatrix}=\begin{pmatrix}3\\5\end{pmatrix}$，即 $T(1,2,3)^{\mathrm T}=(3,5)^{\mathrm T}$。**直接代入** $x_1+x_2=3$、$x_2+x_3=5$ ✓。**评分：**写出 $A$ 1 分，算对并回代 1 分。

**（2）**（4 分）按「新基 $=$ 旧基 $\times$ 过渡矩阵」的列约定（[@def-1.3.5]）：

$$Q=\begin{pmatrix}1&1&0\\ 0&1&0\\ 0&0&1\end{pmatrix}\ \ (\boldsymbol{e}\to\boldsymbol{\varepsilon}'),\qquad
P=\begin{pmatrix}1&0\\ 1&1\end{pmatrix}\ \ (\boldsymbol{f}\to\boldsymbol{\eta}'),$$

$$Q^{-1}=\begin{pmatrix}1&-1&0\\ 0&1&0\\ 0&0&1\end{pmatrix},\qquad P^{-1}=\begin{pmatrix}1&0\\ -1&1\end{pmatrix}.$$

由换基公式（[@thm-2.3.5]）$B=P^{-1}AQ$：

$$P^{-1}A=\begin{pmatrix}1&0\\ -1&1\end{pmatrix}\begin{pmatrix}1&1&0\\ 0&1&1\end{pmatrix}=\begin{pmatrix}1&1&0\\ -1&0&1\end{pmatrix},\qquad
B=(P^{-1}A)Q=\begin{pmatrix}1&2&0\\ -1&-1&1\end{pmatrix}.$$

**记忆：**$P$ 管到达端、$Q$ 管出发端，谁被换掉谁就乘在那个位置上。**评分：**两个过渡矩阵 2 分，公式用对 1 分，$B$ 算对 1 分。

**（3）**（1 分）逐列验算（每列 $=T(\boldsymbol{\varepsilon}'_j)$ 在 $\boldsymbol{\eta}'$ 下的坐标）：

- $T(\boldsymbol{\varepsilon}'_1)=T(1,0,0)^{\mathrm T}=(1,0)^{\mathrm T}=\boldsymbol{f}_1=\boldsymbol{\eta}'_1-\boldsymbol{\eta}'_2$，坐标 $(1,-1)^{\mathrm T}$ ✓；
- $T(\boldsymbol{\varepsilon}'_2)=T(1,1,0)^{\mathrm T}=(2,1)^{\mathrm T}=2\boldsymbol{f}_1+\boldsymbol{f}_2=2\boldsymbol{\eta}'_1-\boldsymbol{\eta}'_2$，坐标 $(2,-1)^{\mathrm T}$ ✓；
- $T(\boldsymbol{\varepsilon}'_3)=T(0,0,1)^{\mathrm T}=(0,1)^{\mathrm T}=\boldsymbol{f}_2=\boldsymbol{\eta}'_2$，坐标 $(0,1)^{\mathrm T}$ ✓。

三列与 $B$ 完全一致。**未验算扣 1 分。**

**（4）**（1 分）解 $x_1+x_2=0$、$x_2+x_3=0$ 得 $x_2=-x_1$、$x_3=x_1$，故

$$N(T)=\operatorname{span}\{(1,-1,1)^{\mathrm T}\},\qquad \dim N(T)=1 .$$

$A$ 的前两列 $(1,0)^{\mathrm T}$、$(1,1)^{\mathrm T}$ 线性无关，故 $\operatorname{rank}A=2=\dim R(T)$，且

$$\dim N(T)+\operatorname{rank}A=1+2=3=\dim\mathbb R^3\ \checkmark$$

——与 [@thm-2.2.5]、[@thm-2.3.6] 一致。

**13.（1）**（2 分）友矩阵的最后一行是 $-a_0,-a_1,-a_2$（[@def-2.1.11] 的第一种形状），对照 $A$ 的最后一行 $(8,-14,7)$ 得 $a_0=-8$、$a_1=14$、$a_2=-7$，故

$$f(\lambda)=\lambda^3-7\lambda^2+14\lambda-8 .$$

按第一行展开特征多项式：

$$\det(\lambda I-A)=\begin{vmatrix}\lambda&-1&0\\ 0&\lambda&-1\\ -8&14&\lambda-7\end{vmatrix}
=\lambda\big[\lambda(\lambda-7)+14\big]+\big[0\cdot(\lambda-7)-(-1)(-8)\big]
=\lambda^3-7\lambda^2+14\lambda-8=f(\lambda)\ \checkmark$$

——「$f$ 恰是 $A$ 的特征多项式」正是 [@def-2.1.11] 的断言，此处 $n=3$ 直接验证。**评分：**写出 $f$ 1 分，验证它是特征多项式 1 分。

**（2）**（2 分）分解

$$f(\lambda)=(\lambda-1)(\lambda-2)(\lambda-4),$$

故 $T$ 的特征值为 $\lambda_1=1$、$\lambda_2=2$、$\lambda_3=4$，**代数重数都是 1**（由 [@thm-eig-bridge]，$T$ 与 $A$ 的特征值相同）。这里「求根」用的是 2.1 的整除语言：$\lambda_0$ 是 $f$ 的根 $\iff$ $(\lambda-\lambda_0)\mid f(\lambda)$（[@def-2.1.8]），故 $(\lambda-1)(\lambda-2)(\lambda-4)\mid f$，两者次数同为 $3$、首项系数同为 $1$，因而相等。核对：$\operatorname{tr}A=0+0+7=7=1+2+4$ ✓；$\det A=8=1\cdot2\cdot4$ ✓（[@thm-eig-trace]）。**评分：**特征值与重数 1 分，核对 1 分（未核对扣 1 分）。

**（3）**（2 分）对每个特征值解 $(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$：

- $\lambda=1$：$A-I=\begin{pmatrix}-1&1&0\\ 0&-1&1\\ 8&-14&6\end{pmatrix}$，前两行给出 $x_1=x_2=x_3$，基础解系 $\boldsymbol{\alpha}_1=(1,1,1)^{\mathrm T}$（第三行 $8-14+6=0$ 自动满足，秩为 $2$），$\dim V_1=3-2=1$；
- $\lambda=2$：$A-2I=\begin{pmatrix}-2&1&0\\ 0&-2&1\\ 8&-14&5\end{pmatrix}$，给出 $x_2=2x_1$、$x_3=2x_2=4x_1$，基础解系 $\boldsymbol{\alpha}_2=(1,2,4)^{\mathrm T}$（第三行 $8-28+20=0$ ✓），$\dim V_2=1$；
- $\lambda=4$：$A-4I=\begin{pmatrix}-4&1&0\\ 0&-4&1\\ 8&-14&3\end{pmatrix}$，给出 $x_2=4x_1$、$x_3=4x_2=16x_1$，基础解系 $\boldsymbol{\alpha}_3=(1,4,16)^{\mathrm T}$（第三行 $8-56+48=0$ ✓），$\dim V_4=1$。

三个特征值的几何重数都等于代数重数（$1=1$），且 $\boldsymbol{\alpha}_1,\boldsymbol{\alpha}_2,\boldsymbol{\alpha}_3$ 线性无关（不同特征值的特征向量线性无关，[@thm-eig-independent]；$V$ 是 $3$ 维的），故 $T$ **能对角化**（[@thm-mult-ineq]、[@method-design-basis]）。

**（4）**（2 分）**乘回基**（这是本节最高频的失分点，[@method-eig-procedure] 第 4 步）：$T$ 的属于 $\lambda=2$ 的全部特征向量为

$$\boldsymbol{\xi}=k\big(\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2+4\boldsymbol{\varepsilon}_3\big),\qquad k\neq0 .$$

（$k=0$ 给出的是零向量，零向量不是特征向量。）取

$$\boldsymbol{\varepsilon}'_1=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2+\boldsymbol{\varepsilon}_3\ (\lambda=1),\quad
\boldsymbol{\varepsilon}'_2=\boldsymbol{\varepsilon}_1+2\boldsymbol{\varepsilon}_2+4\boldsymbol{\varepsilon}_3\ (\lambda=2),\quad
\boldsymbol{\varepsilon}'_3=\boldsymbol{\varepsilon}_1+4\boldsymbol{\varepsilon}_2+16\boldsymbol{\varepsilon}_3\ (\lambda=4),$$

则 $(\boldsymbol{\varepsilon}'_1,\boldsymbol{\varepsilon}'_2,\boldsymbol{\varepsilon}'_3)=(\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2,\boldsymbol{\varepsilon}_3)P$，其中

$$P=\begin{pmatrix}1&1&1\\ 1&2&4\\ 1&4&16\end{pmatrix},\qquad \det P=(2-1)(4-1)(4-2)=6\neq0$$

（三阶 Vandermonde 行列式），故它们是基，且

$$P^{-1}AP=\operatorname{diag}(1,2,4).$$

**验算**（逐列）：$A(1,1,1)^{\mathrm T}=(1,1,1)^{\mathrm T}$ ✓；$A(1,2,4)^{\mathrm T}=(2,4,8)^{\mathrm T}=2(1,2,4)^{\mathrm T}$ ✓；$A(1,4,16)^{\mathrm T}=(4,16,64)^{\mathrm T}=4(1,4,16)^{\mathrm T}$ ✓。**评分：**乘回基写出特征向量 1 分（写成坐标列 $(1,2,4)^{\mathrm T}$ 只给 0 分），新基与对角形 1 分。**易错提醒：**$(A-\lambda I)\boldsymbol{x}=\boldsymbol{0}$ 的解只是**坐标**；漏掉「乘回基」这一行，第 (4) 问前一半就全错。

**14.（1）**（3 分）$r=\sqrt{x_1^2+x_2^2}=\sqrt{1+4}=\sqrt5$，按 [@thm-givens-zero] 取

$$\cos\varphi=\frac{x_1}{r}=\frac1{\sqrt5},\qquad \sin\varphi=-\frac{x_2}{r}=-\frac2{\sqrt5},$$

$$T_{12}=\begin{pmatrix}\frac1{\sqrt5}&\frac2{\sqrt5}&0\\[2pt] -\frac2{\sqrt5}&\frac1{\sqrt5}&0\\[2pt] 0&0&1\end{pmatrix}.$$

**验算**（按 [@thm-givens-props]（3），只改第 1、2 个分量）：

$$(T_{12}\boldsymbol{x})_1=\frac1{\sqrt5}\cdot1-\Big(-\frac2{\sqrt5}\Big)\cdot2=\frac{1+4}{\sqrt5}=\sqrt5,\qquad
(T_{12}\boldsymbol{x})_2=-\frac2{\sqrt5}\cdot1+\frac1{\sqrt5}\cdot2=0\ \checkmark$$

故 $T_{12}\boldsymbol{x}=(\sqrt5,0,2)^{\mathrm T}$。

**（2）**（3 分）第二个 Givens 必须用**更新后**的向量 $(\sqrt5,0,2)^{\mathrm T}$ 取角：$r'=\sqrt{5+4}=3$，

$$\cos\psi=\frac{\sqrt5}{3},\qquad \sin\psi=-\frac23,\qquad
T_{13}=\begin{pmatrix}\frac{\sqrt5}{3}&0&\frac23\\[2pt] 0&1&0\\[2pt] -\frac23&0&\frac{\sqrt5}{3}\end{pmatrix}.$$

$$T_{13}(T_{12}\boldsymbol{x})=\begin{pmatrix}\frac{\sqrt5}{3}\cdot\sqrt5+\frac23\cdot2\\[2pt] 0\\[2pt] -\frac23\cdot\sqrt5+\frac{\sqrt5}{3}\cdot2\end{pmatrix}=\begin{pmatrix}\frac{5+4}{3}\\[2pt]0\\[2pt]\frac{-2\sqrt5+2\sqrt5}{3}\end{pmatrix}=\begin{pmatrix}3\\0\\0\end{pmatrix}.$$

而 $\|\boldsymbol{x}\|=\sqrt{1+4+4}=3$，故 $T_{13}T_{12}\boldsymbol{x}=3\boldsymbol{e}_1=\|\boldsymbol{x}\|\boldsymbol{e}_1$ ✓。

**（3）**（1 分）总变换是 $T_{13}T_{12}$——**按作用顺序反写**：先作用的 $T_{12}$ 排在最右（[@method-givens-align]）。这来自复合的定义：$(T_{13}T_{12})\boldsymbol{x}=T_{13}(T_{12}\boldsymbol{x})$（[@def-2.1.4]）。写成 $T_{12}T_{13}$ 就把顺序弄反了：那时第 $1$ 个作用的是 $T_{13}$，$T_{12}$ 便不是按 $\boldsymbol{x}$ 的前两个分量取的角，结果的第 $3$ 个分量一般不为 $0$，得不到 $\|\boldsymbol{x}\|\boldsymbol{e}_1$；在第二个矩阵上继续用**未更新**的向量取角同样会错。

**（4）**（1 分）$T_{12}$、$T_{13}$ 都是 Givens 矩阵，故都是正交矩阵（[@thm-givens-props]（1））；正交矩阵的乘积仍正交（[@thm-orth-algebra]（2）），故 $T_{13}T_{12}$ 正交。直接验证也只需两步：

$$(T_{13}T_{12})^{\mathrm T}(T_{13}T_{12})=T_{12}^{\mathrm T}\big(T_{13}^{\mathrm T}T_{13}\big)T_{12}=T_{12}^{\mathrm T}T_{12}=I .$$

行列式：把 $T_{ij}$ 按「二阶主块 $\begin{pmatrix}c&-s\\ s&c\end{pmatrix}$ $+$ 单位块」分块，$\det T_{ij}=c^2+s^2=1$（旋转），故 $\det(T_{13}T_{12})=1\cdot1=1$。**评分：**正交性说明 0.5 分，行列式 0.5 分。

**15.（1）**（2 分）$\|\boldsymbol{x}\|=5$。镜面取「$\boldsymbol{x}$ 与目标方向 $\|\boldsymbol{x}\|\boldsymbol{e}_1$ 的角平分面」，即 $\boldsymbol{\omega}$ 沿 $\boldsymbol{x}-\|\boldsymbol{x}\|\boldsymbol{e}_1$ 的单位向量（[@thm-householder-props] 之后的想一想 2）：

$$\boldsymbol{v}=\boldsymbol{x}-5\boldsymbol{e}_1=(-5,3,4)^{\mathrm T},\qquad \|\boldsymbol{v}\|=\sqrt{25+9+16}=5\sqrt2,$$
$$\boldsymbol{\omega}=\frac{1}{5\sqrt2}\begin{pmatrix}-5\\ 3\\ 4\end{pmatrix},\qquad \|\boldsymbol{\omega}\|=1\ \checkmark$$

**（2）**（2 分）先算

$$2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=\frac{2}{50}\boldsymbol{v}\boldsymbol{v}^{\mathrm T}=\frac1{25}\begin{pmatrix}25&-15&-20\\ -15&9&12\\ -20&12&16\end{pmatrix}
=\begin{pmatrix}1&-\frac35&-\frac45\\[2pt] -\frac35&\frac9{25}&\frac{12}{25}\\[2pt] -\frac45&\frac{12}{25}&\frac{16}{25}\end{pmatrix},$$

故

$$H=I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=\begin{pmatrix}0&\frac35&\frac45\\[2pt] \frac35&\frac{16}{25}&-\frac{12}{25}\\[2pt] \frac45&-\frac{12}{25}&\frac9{25}\end{pmatrix}.$$

**验算：**

$$H\boldsymbol{x}=\begin{pmatrix}0\cdot0+\frac35\cdot3+\frac45\cdot4\\[2pt] \frac35\cdot0+\frac{16}{25}\cdot3-\frac{12}{25}\cdot4\\[2pt] \frac45\cdot0-\frac{12}{25}\cdot3+\frac9{25}\cdot4\end{pmatrix}
=\begin{pmatrix}\frac{9+16}{5}\\[2pt] \frac{48-48}{25}\\[2pt] \frac{-36+36}{25}\end{pmatrix}=\begin{pmatrix}5\\0\\0\end{pmatrix}=5\boldsymbol{e}_1=\|\boldsymbol{x}\|\boldsymbol{e}_1\ \checkmark$$

**评分：**写出 $\boldsymbol{\omega}$ 1 分，写出 $H$ 并验算 1 分（未验算扣 1 分）。

**（3）**（2 分）**对称：**$(\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})^{\mathrm T}=\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}$，故 $H^{\mathrm T}=H$；上面写出的 $H$ 也显然对称。

**自逆：**

$$H^2=(I-2\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T})^2=I-4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}+4\boldsymbol{\omega}\big(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega}\big)\boldsymbol{\omega}^{\mathrm T}=I-4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}+4\boldsymbol{\omega}\boldsymbol{\omega}^{\mathrm T}=I,$$

其中 $\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega}=\|\boldsymbol{\omega}\|^2=1$。（由 $H^{\mathrm T}=H$ 与 $H^2=I$ 立得 $H^{\mathrm T}H=I$，即 $H$ 正交。）

**行列式：**$H\boldsymbol{\omega}=\boldsymbol{\omega}-2\boldsymbol{\omega}(\boldsymbol{\omega}^{\mathrm T}\boldsymbol{\omega})=-\boldsymbol{\omega}$，故 $-1$ 是特征值；而每个与 $\boldsymbol{\omega}$ 正交的向量都满足 $H\boldsymbol{y}=\boldsymbol{y}$，$\dim\boldsymbol{\omega}^{\perp}=n-1$，取它的一组基即得 $n-1$ 个属于 $1$ 的线性无关特征向量。于是 $H$ 的全部特征值（计重数）为 $-1,\underbrace{1,\cdots,1}_{n-1}$，特征值之积即行列式：

$$\det H=(-1)\cdot 1^{\,n-1}=-1 .$$

**本题的具体验算**（$n=3$）：取镜面内两个向量 $(4,0,5)^{\mathrm T}$、$(3,5,0)^{\mathrm T}$（都与 $\boldsymbol{v}=(-5,3,4)^{\mathrm T}$ 正交），直接算得 $H(4,0,5)^{\mathrm T}=(4,0,5)^{\mathrm T}$ ✓、$H(3,5,0)^{\mathrm T}=(3,5,0)^{\mathrm T}$ ✓，而 $H\boldsymbol{v}=-\boldsymbol{v}$ ✓——三个特征向量线性无关，特征值 $-1,1,1$，$\det H=-1$ ✓。

**（4）**（2 分）**几何意义：**$H$ 把向量关于超平面 $\boldsymbol{\omega}^{\perp}=\{\boldsymbol{y}\mid\boldsymbol{\omega}^{\mathrm T}\boldsymbol{y}=0\}$ 作**镜像**：把 $\boldsymbol{y}$ 分解为沿 $\boldsymbol{\omega}$ 的分量与垂直分量 $\boldsymbol{y}=\boldsymbol{y}_{\parallel}+\boldsymbol{y}_{\perp}$，则

$$H\boldsymbol{y}=\boldsymbol{y}_{\perp}-\boldsymbol{y}_{\parallel},$$

即「垂直分量保留、平行分量反向」——**注意不是投影**（投影幂等、一般不保长度）。本题的镜面是与 $\boldsymbol{v}=(-5,3,4)^{\mathrm T}$ 垂直且过原点的平面

$$-5y_1+3y_2+4y_3=0 .$$

**特征值：**$-1$（代数重数 $1$，特征子空间 $\operatorname{span}\{\boldsymbol{\omega}\}$，即 $\boldsymbol{v}$ 方向）；$1$（代数重数 $2$，特征子空间 $\boldsymbol{\omega}^{\perp}$，即镜面本身）。两种重数在这里都相等。**易错提醒：**把 $H$ 说成「投影」是本节的典型错误——投影满足 $P^2=P$ 但一般不保长度；$H$ 满足 $H^2=I$、保长度、$\det H=-1$。**评分：**几何意义 1 分，特征值与重数 1 分。

:::

## 第三部分 · 证明题（每题 15 分，共 30 分）

**16.（15 分）**设 $V$、$W$ 是数域 $F$ 上的线性空间，$T\in L(V,W)$，记

$$N(T)=\{\boldsymbol{x}\in V\mid T(\boldsymbol{x})=\boldsymbol{\theta}'\},\qquad R(T)=T(V)=\{\boldsymbol{y}\in W\mid \exists\,\boldsymbol{x}\in V,\ \boldsymbol{y}=T(\boldsymbol{x})\}.$$

(1) 证明亏加秩定理：$\dim N(T)+\dim R(T)=\dim V$；
(2) 设 $\dim V=\dim W$，利用 (1) 证明：$T$ 是单射 $\iff$ $T$ 是满射。

**17.（15 分）**设 $A$ 是 $n$ 阶**实**正交矩阵（$A^{\mathrm T}A=I$），$\lambda$ 是 $A$ 的一个特征值。

(1) 证明 $|\lambda|=1$；
(2) 下列「证明 $\lambda=\pm1$」错在哪一步？指出错误并给出反例：

> 设 $A\boldsymbol{x}=\lambda\boldsymbol{x}$（$\boldsymbol{x}\neq\boldsymbol{0}$）。两边取转置得 $\boldsymbol{x}^{\mathrm T}A^{\mathrm T}=\lambda\boldsymbol{x}^{\mathrm T}$，两式相乘得 $\boldsymbol{x}^{\mathrm T}A^{\mathrm T}A\boldsymbol{x}=\lambda^2\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$，即 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\lambda^2\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$；约去 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 得 $\lambda^2=1$，故 $\lambda=\pm1$。

(3) 举例说明实正交矩阵可以有非实特征值，并说明 $|\lambda|=1$ 为什么不能加强为 $\lambda=\pm1$；
(4) 对 Givens 旋转（$\varphi\notin\{0,\pi\}$）

$$T_{12}(\varphi)=\begin{pmatrix}\cos\varphi&-\sin\varphi\\ \sin\varphi&\cos\varphi\end{pmatrix},$$

写出它在 $\mathbb C$ 上的两个特征值，并验证 (1) 的结论。

::: sol 第三部分答案与评分要点

**16.（15 分）**

**(1)（11 分）**记 $\dim V=n$、$\dim N(T)=m$，按「取基 → 扩基 → 生成 → 无关」四步走。

**第一步（取 $N(T)$ 的基）**：$N(T)$ 是 $V$ 的子空间（对线性组合封闭，含 $\boldsymbol{\theta}$），设其一组基为 $\boldsymbol{h}_1,\cdots,\boldsymbol{h}_m$（$m\le n$；$m=0$ 时下面论证自动成立，只是不出现 $\boldsymbol{h}_1,\cdots,\boldsymbol{h}_m$ 这几项）。

**第二步（扩充为 $V$ 的基）**：由[基扩充定理](../ch01/sec13.md)，可把 $\boldsymbol{h}_1,\cdots,\boldsymbol{h}_m$ 扩充为 $V$ 的一组基

$$\boldsymbol{h}_1,\cdots,\boldsymbol{h}_m,\ \boldsymbol{h}_{m+1},\cdots,\boldsymbol{h}_n .$$

**第三步（$R(T)$ 由后 $n-m$ 个像张成）**：任取 $\boldsymbol{\beta}=\sum_{i=1}^{n}k_i\boldsymbol{h}_i\in V$。由 [@thm-2.2.1]（保持线性组合），

$$T(\boldsymbol{\beta})=\sum_{i=1}^{n}k_i\,T(\boldsymbol{h}_i)=k_{m+1}T(\boldsymbol{h}_{m+1})+\cdots+k_nT(\boldsymbol{h}_n),$$

因为 $i\le m$ 时 $\boldsymbol{h}_i\in N(T)$，即 $T(\boldsymbol{h}_i)=\boldsymbol{\theta}'$。故

$$R(T)\subseteq\operatorname{span}\{T(\boldsymbol{h}_{m+1}),\cdots,T(\boldsymbol{h}_n)\};$$

反向包含显然（每个 $T(\boldsymbol{h}_i)$ 都是像）。于是 $R(T)=\operatorname{span}\{T(\boldsymbol{h}_{m+1}),\cdots,T(\boldsymbol{h}_n)\}$，$\dim R(T)\le n-m$。

**第四步（后 $n-m$ 个像线性无关）**：设

$$c_{m+1}T(\boldsymbol{h}_{m+1})+\cdots+c_nT(\boldsymbol{h}_n)=\boldsymbol{\theta}'.$$

由 [@thm-2.2.1] 的左到右方向，左边 $=T\big(c_{m+1}\boldsymbol{h}_{m+1}+\cdots+c_n\boldsymbol{h}_n\big)$，故该组合属于 $N(T)$，从而可由 $N(T)$ 的基表出：存在 $c_1,\cdots,c_m$ 使

$$c_{m+1}\boldsymbol{h}_{m+1}+\cdots+c_n\boldsymbol{h}_n=c_1\boldsymbol{h}_1+\cdots+c_m\boldsymbol{h}_m,$$

即

$$(-c_1)\boldsymbol{h}_1+\cdots+(-c_m)\boldsymbol{h}_m+c_{m+1}\boldsymbol{h}_{m+1}+\cdots+c_n\boldsymbol{h}_n=\boldsymbol{\theta}.$$

因 $\boldsymbol{h}_1,\cdots,\boldsymbol{h}_n$ 是 $V$ 的基（线性无关），上式全部系数为零，特别地 $c_{m+1}=\cdots=c_n=0$。故 $T(\boldsymbol{h}_{m+1}),\cdots,T(\boldsymbol{h}_n)$ 线性无关，构成 $R(T)$ 的一组基：

$$\dim R(T)=n-m=\dim V-\dim N(T),$$

即 $\dim N(T)+\dim R(T)=\dim V$。$\blacksquare$

**评分：**取 $N(T)$ 的基并扩充为 $V$ 的基 3 分；证明 $R(T)$ 由后 $n-m$ 个像张成 3 分；证明这 $n-m$ 个像线性无关 5 分（其中「该组合属于 $N(T)$，故可由 $N(T)$ 的基表出」2 分，「用同一组基的无关性让系数全为零」3 分）。**关键给分点：**第四步必须回到 $N(T)$ 的基再收尾；只写「显然线性无关」不得分。

**(2)（4 分）**记 $\dim V=\dim W=n$。

- **单射 $\Longrightarrow$ 满射**：$T$ 单射 $\iff$ $N(T)=\{\boldsymbol{\theta}\}$（若 $T(\boldsymbol{x})=\boldsymbol{\theta}'$ 则 $T(\boldsymbol{x})=T(\boldsymbol{\theta})$，单射给出 $\boldsymbol{x}=\boldsymbol{\theta}$；反之若 $T(\boldsymbol{x})=T(\boldsymbol{y})$ 则 $T(\boldsymbol{x}-\boldsymbol{y})=\boldsymbol{\theta}'$，故 $\boldsymbol{x}-\boldsymbol{y}=\boldsymbol{\theta}$），故 $\dim N(T)=0$。由 (1) 得 $\dim R(T)=n=\dim W$；又 $R(T)\subseteq W$，于是 $R(T)=W$，$T$ 满射。
- **满射 $\Longrightarrow$ 单射**：$T$ 满射即 $R(T)=W$，故 $\dim R(T)=\dim W=n$；由 (1) 得 $\dim N(T)=n-n=0$，即 $N(T)=\{\boldsymbol{\theta}\}$，故 $T$ 单射。

两者合起来说明：**同维数时「单射」「满射」「双射」是一回事**——这正是 [@cor-2.2.2] 的定量版本。**评分：**两个方向各 2 分。**易错提醒：**前提「$\dim V=\dim W$」不能丢：$\dim W<\dim V$ 时单射根本不存在，(1) 给出的只是 $\dim N(T)\ge\dim V-\dim W>0$。

**17.（15 分）**

**(1)（6 分）**实矩阵的特征值可能不是实数，故特征向量要取在 $\mathbb C^n$ 中讨论。设 $A\boldsymbol{x}=\lambda\boldsymbol{x}$，$\boldsymbol{x}\neq\boldsymbol{0}$。**长度的计算一律用共轭转置**：

$$\|A\boldsymbol{x}\|^2=(A\boldsymbol{x})^{\mathrm H}(A\boldsymbol{x})=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}A\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}\big(A^{\mathrm T}A\big)\boldsymbol{x}=\boldsymbol{x}^{\mathrm H}\boldsymbol{x}=\|\boldsymbol{x}\|^2,$$

（$A$ 实，故 $A^{\mathrm H}=A^{\mathrm T}$；这一步正是「正交」用在哪里。）另一方面

$$\|A\boldsymbol{x}\|^2=\|\lambda\boldsymbol{x}\|^2=|\lambda|^2\|\boldsymbol{x}\|^2 .$$

两式相等，且 $\|\boldsymbol{x}\|^2>0$，约去即得 $|\lambda|^2=1$，即 $|\lambda|=1$。

**评分：**用共轭转置算出 $\|A\boldsymbol{x}\|^2=\|\boldsymbol{x}\|^2$ 3 分；代入 $A\boldsymbol{x}=\lambda\boldsymbol{x}$ 得 $|\lambda|^2\|\boldsymbol{x}\|^2=\|\boldsymbol{x}\|^2$ 2 分；由 $\|\boldsymbol{x}\|^2>0$ 收尾 1 分。**易错提醒：**只要写成 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 就已走上错误证明的道路（见 (2)）。

**(2)（5 分）**错误有两处，指出任一即得分：

1. **不能约去 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$。**对**复**向量，$\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\sum_ix_i^2$ 不是长度平方，甚至可以是 $0$：$\boldsymbol{x}=(1,i)^{\mathrm T}$ 时 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=1+i^2=0$。正确做法是用 $\boldsymbol{x}^{\mathrm H}\boldsymbol{x}=\sum_i|x_i|^2>0$；正是在这里「转置」必须换成「共轭转置」。
2. **即使得到 $\lambda^2=1$，也推不出 $\lambda=\pm1$**——除非事先知道 $\lambda$ 是实数。实矩阵的特征值可以是复数，见 (3) 的反例。

（另注：$\boldsymbol{x}^{\mathrm T}A^{\mathrm T}=\lambda\boldsymbol{x}^{\mathrm T}$ 这一步本身没错——转置不引入共轭；错误出在「约去」与「由 $\lambda^2=1$ 开方」两处。）**评分：**指出 $\boldsymbol{x}^{\mathrm T}\boldsymbol{x}$ 可以为 $0$（或必须用共轭转置）3 分；举出 $(1,i)^{\mathrm T}$ 一类反例 1 分；指出 $\lambda^2=1$ 不能给出 $\lambda=\pm1$ 1 分。

**(3)（2 分）**取

$$A=\begin{pmatrix}0&-1\\ 1&0\end{pmatrix},$$

则 $A^{\mathrm T}A=I$（正交），特征多项式 $\det(\lambda I-A)=\lambda^2+1$，特征值为 $\lambda=\pm i$：$|\lambda|=1$ ✓，但 $\pm i\neq\pm1$。原因：实正交矩阵的特征多项式是**实系数**多项式，复根成共轭对出现；$|\lambda|=1$ 只把特征值限制在单位圆上，而单位圆上除 $\pm1$ 外还有无穷多个点（$\mathrm e^{i\varphi}$，$\varphi\notin\{0,\pi\}$）。**评分：**反例 1 分，说明理由 1 分。

**(4)（2 分）**

$$\det\big(\lambda I-T_{12}(\varphi)\big)=(\lambda-\cos\varphi)^2+\sin^2\varphi=\lambda^2-2\lambda\cos\varphi+1,$$

其两根为

$$\lambda_{1,2}=\cos\varphi\pm i\sin\varphi=\mathrm e^{\pm i\varphi}.$$

验证：$|\lambda|=\sqrt{\cos^2\varphi+\sin^2\varphi}=1$ ✓，与 (1) 一致（也可用 $\lambda_1\lambda_2=\det T_{12}=1$、$\lambda_1+\lambda_2=\operatorname{tr}T_{12}=2\cos\varphi$ 核对）。当 $\varphi\notin\{0,\pi\}$ 时两根都**不是实数**，可见 (1) 的结论确实不能再加强。**评分：**算出两根 1 分，验证模为 $1$ 1 分。

:::

## 评分标准与后续

**总分 100 分。**各部分建议的达标线：

| 分数段 | 含义 | 下一步 |
|:--:|:--|:--|
| **90–100** | 概念、计算与证明都扎实 | 可直接进入 2.6（应用：图的矩阵表示）；建议把第 13、16 题再做一遍，练「一次写对」。 |
| **75–89** | 主干掌握，个别细节不稳 | 用[学习目标自检表](checklist.md)找出失分条目对应的小节，重读该节「即时自测」，重点补 2.4 的「乘回基」与 2.5 的实 / 复边界。 |
| **60–74** | 定义记得住，但用起来会混 | 重做[习题集](exercises.md)的 B 组与 C 组；把 [2.4](sec24.md)、[2.5](sec25.md) 两节末的「常见错误」清单抄一遍。 |
| **< 60** | 需要系统性重学 | 回到 [2.2](sec22.md) 重读定义与亏加秩定理，再按 [2.3](sec23.md) → [2.4](sec24.md) → [2.5](sec25.md) 的顺序重读；每节末做「即时自测」并对照[勘误与补注](errata.md)的常见错误。 |

::: method 复盘比分数重要

无论得多少分，做完后请**为每道错题写一行复盘**，格式固定为一句话：

> 「我在 `____` 这一步错了，原因是 `____`，正确做法是 `____`。」

如果同一类错误（如「求完坐标忘乘回基」「复向量用转置算长度」「Givens 连乘顺序写反」「把相抵当相似」「镜像当投影」「谈单射忘了同维前提」）出现两次以上，那不是粗心，而是概念缺口——回到对应小节，而不是多做题。
:::
