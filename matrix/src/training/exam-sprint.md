# 考场冲刺 · 综合自测卷（跨三章 · 100 分制）

> **像考试那样练，才不会在考场上手生。** 这一页是一份**闭卷、计时、100 分制**的综合自测卷：覆盖**全三章**（1.1–1.6 线性空间 · 2.1–2.5 线性映射与矩阵 · 3.1–3.2 与 3.4–3.5 矩阵分解），题目一律**跨章编排**——第一部分的判断题就能同时碰到「子空间」「亏加秩」「相抵」，第四部分一道题里连起「满秩分解 → 解方程组 → 列空间与零空间」。
>
> 与[必考点竞技场](arena.md)的分工：竞技场练**单点反射**（快、碎、口述），这里练**整卷节奏**（慢、整、按点给分）。
>
> **建议用时 90 分钟 · 满分 100 分。** 请自备计时器；做完先按文末[评分标准](#exam-rubric)打分，再按[漏点定位表](#exam-map)回正文与习题。

::: note 应试要点（阅卷口径，先读这五条）
- **判断题的「对」必须带完整前提**：方阵还是长方阵？满秩还是不满？实还是复？——缺条件的「对」几乎都是陷阱。
- **一句话理由也要写**：只写「对 / 错」只得 1 分，剩下 2 分在**理由或反例**上。
- **证明题按结构给分**：第一行 + 三步结构写全才拿满；写结论不写过程最多 2 分。
- **计算题先写验算式再写答案**：$QR=A$、$BC=A$、$AA^{-1}=I$、$\operatorname{tr}$ 与 $\det$ 的对照，都是免费的保险。
- **本卷不出 3.3（三角分解）**：该节素材尚未入库；本卷只覆盖 3.1–3.2 与 3.4–3.5。
:::

## 第一部分 · 概念判断（每题 3 分，共 30 分）

判断对错，**并给出一句话理由或反例**。只写「对 / 错」不得分。

**1.** 设 $V=\mathbb{R}_{>0}$（全体正实数），规定 $\boldsymbol{x}\oplus\boldsymbol{y}=xy$、$k\odot\boldsymbol{x}=x^{k}$。判断：**(a)** $(V,\oplus,\odot)$ 是 $\mathbb{R}$ 上的线性空间；**(b)** 它的零元是实数 $0$；**(c)** 每个元素 $\boldsymbol{x}$ 的负元是 $1/\boldsymbol{x}$。

**2.** 设 $W_1=\{A\in\mathbb{R}^{2\times2}\mid\operatorname{tr}A=0\}$、$W_2=\{A\in\mathbb{R}^{2\times2}\mid\det A=0\}$。判断：**(a)** $W_1$ 是子空间；**(b)** $W_2$ 也是子空间。

**3.** 设 $\boldsymbol{\varepsilon}_1,\boldsymbol{\varepsilon}_2$ 是 $V$ 的基，$\boldsymbol{f}_1=2\boldsymbol{\varepsilon}_1$、$\boldsymbol{f}_2=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2$。判断：**(a)** 满足「新基＝旧基 $\times P$」的过渡矩阵是 $P=\begin{pmatrix}2&1\\0&1\end{pmatrix}$；**(b)** 向量 $\boldsymbol{x}=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2$ 在**新基**下的坐标是 $\begin{pmatrix}1/2\\1\end{pmatrix}$。

**4.** 判断：**(a)** $\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2)$ 对 $\mathbb{R}^n$ 中任意两个子空间成立；**(b)** 把它的容斥形式直接推广到**三个**子空间仍然成立。

**5.** 判断：**(a)** 谈投影必须说清「沿哪个补空间」——同一个目标子空间换一个补，投影就变；**(b)** 一般投影的残差也一定垂直于目标子空间。

**6.** 设 $T\in L(V,W)$。判断：**(a)** 亏加秩定理 $\dim N(T)+\dim R(T)=\dim V$ 对任意线性映射成立；**(b)** 由它可以推出「$T$ 满射 $\Longrightarrow$ $T$ 单射」，且**不需要**任何额外条件。

**7.** 设 $A\in\mathbb{C}^{n\times n}$。判断：**(a)** $A^{2}=A$ 的特征值只能是 $0$ 或 $1$；**(b)** 若 $A^{2}=A$ 且 $\operatorname{rank}A=2$，则 $\operatorname{tr}A=2$；**(c)** 「有 $n$ 个互异特征值」是**可对角化**的充分不必要条件。

**8.** 关于 Hamilton–Cayley 定理，判断：**(a)** 任何复方阵都满足 $f_A(A)=O$；**(b)** 由此可知「特征值全为 $0$ 的 $n$ 阶矩阵必满足 $A^{n}=O$」；**(c)** 并且此时 $A^{n-1}=O$ 也一定成立。

**9.** 关于分解，判断：**(a)** 相抵分解式不唯一，但标准形 $\Gamma$ 由秩唯一决定；**(b)** 满秩分解 $A=BC$ 中 $B$ 的列必须取自 $A$ 的列；**(c)** 两个同型矩阵相抵 $\iff$ 它们的秩相等。

**10.** 关于不变子空间与 Schur 型，判断：**(a)** 特征向量张成的直线是 $T$ 的一维不变子空间；**(b)** 若 $A=U\Lambda U^{\mathrm H}$（$U$ 酉、$\Lambda$ 上三角），则 $A$ 保 $\operatorname{span}\{U$ 的前 $k$ 列$\}$（$k=1,\cdots,n$）；**(c)** 因此任何复方阵都酉相似于**对角**阵。

::: sol 第 1 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错、(c) 对。**

八条公理逐条对照：结合律 $(xy)z=x(yz)$ ✓；零元是 $1$（因为 $x\oplus 1=x$）——所以 **(b) 错**；负元是倒数（$x\oplus x^{-1}=1$）✓；交换律 ✓。数乘四条：$k\odot(x\oplus y)=(xy)^{k}=x^{k}y^{k}$ ✓、$(k+l)\odot x=x^{k+l}=x^{k}x^{l}$ ✓、$k\odot(l\odot x)=(x^{l})^{k}=x^{kl}$ ✓、$1\odot x=x$ ✓。 **要点**：本题就是[@ex-1.1.3]（$\lg$ 换元一看便知：$x\oplus y=xy$ 即 $\lg x+\lg y$）。这里「零元」改头换面成了 $1$、「负元」变成了倒数——验证新运算时的入手点是**先找零元与负元**（[1.1.8](../ch01/sec11.md#sec-1.1.8)）。**失分点**：写「零元是 $0$」——$0\notin V$，连元素都不是。
:::

::: sol 第 2 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错。**

**(a)** 迹是线性函数：$\operatorname{tr}(aX+bY)=a\operatorname{tr}X+b\operatorname{tr}Y$，故 $W_1$ 是齐次线性方程（$\operatorname{tr}A=0$）的解集，对任意线性组合封闭，含零矩阵。

**(b) 反例**：$E_{11}=\begin{pmatrix}1&0\\0&0\end{pmatrix}$ 与 $E_{22}=\begin{pmatrix}0&0\\0&1\end{pmatrix}$ 的行列式都是 $0$，但 $E_{11}+E_{22}=I_2$ 的行列式是 $1$ ——加法不封闭。（判别口诀：等式 / 线性方程刻画通常是子空间，不等式 / 排除性条件通常不是，[1.2.8](../ch01/sec12.md#sec-1.2.8)。）
:::

::: sol 第 3 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错。**

**(a)** 过渡矩阵的**第 $j$ 列**＝新基第 $j$ 个向量在**旧基**下的坐标：$\boldsymbol{f}_1$ 的坐标是 $(2,0)^{\mathrm T}$、$\boldsymbol{f}_2$ 的坐标是 $(1,1)^{\mathrm T}$，故 $P=\begin{pmatrix}2&1\\0&1\end{pmatrix}$ ✓。

**(b)** 用「旧坐标 $=P\times$ 新坐标」核对：设旧坐标 $\boldsymbol{\xi}=(1,1)^{\mathrm T}$，$P^{-1}=\begin{pmatrix}1/2&-1/2\\0&1\end{pmatrix}$，故新坐标 $=P^{-1}\boldsymbol{\xi}=\begin{pmatrix}0\\1\end{pmatrix}$ ——即 $\boldsymbol{x}=\boldsymbol{f}_2$。直接验证：$\boldsymbol{f}_2=\boldsymbol{\varepsilon}_1+\boldsymbol{\varepsilon}_2=\boldsymbol{x}$ ✓。原答案 $(1/2,1)^{\mathrm T}$ 是**把方向用反**的典型产物（[1.3.7](../ch01/sec13.md#sec-1.3.7)）。
:::

::: sol 第 4 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错。**

**(a)** 就是 [1.3.9](../ch01/sec13.md#sec-1.3.9) 的维数公式（[@thm-1.3.5]）。

**(b) 反例**：取 $\mathbb{R}^2$ 中**三条过原点的不同直线** $L_1,L_2,L_3$。左边 $\dim(L_1+L_2+L_3)=2$；容斥右边 $=1+1+1-0-0-0+0=3$——**不相等**。原因：两两交为零**不足以**保证三个子空间「互不重叠」，朴素容斥需要额外的位置条件。
:::

::: sol 第 5 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错。**

**(a)** 投影是直和分解的产物：$\mathbb{R}^2$ 中 $W_1$ 取 $x$ 轴，配补 $\operatorname{span}\{(1,1)\}$ 时 $\boldsymbol{x}=(1,1)^{\mathrm T}$ 的投影是 $\boldsymbol{\theta}$，配补 $y$ 轴时投影是 $(1,0)^{\mathrm T}$（[1.6.3](../ch01/sec16.md#sec-1.6.3) 与例 1.6.A）。

**(b)** 只有**正交**投影的残差才垂直；上面的例子中残差 $(1,1)^{\mathrm T}$ 与 $x$ 轴的内积是 $1\ne0$。正交投影由 $W$ 与内积唯一确定，是 $W$ 中的最近点——这一条不能平移到一般投影上。
:::

::: sol 第 6 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错。**

**(a)** 亏加秩定理（[@thm-2.2.5]）与维数无关、与 $T$ 是否单 / 满射无关。

**(b)** 满射只给出 $\dim R(T)=\dim W$；要 $T$ 单射还需要 $\dim N(T)=0$，由亏加秩即 $\dim W=\dim V$。**反例**：$T:\mathbb{R}^2\to\mathbb{R}$，$T(x_1,x_2)=x_1$ 是满射（$\dim R=1$）但 $N(T)=\operatorname{span}\{(0,1)\}\neq\{\boldsymbol{\theta}\}$，不是单射。「同维时单射 ⟺ 满射」的前提一个都不能丢。
:::

::: sol 第 7 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 对、(c) 对。**

**(a)** 由 $A\boldsymbol{x}=\lambda\boldsymbol{x}$（$\boldsymbol{x}\neq\boldsymbol{0}$）得 $\lambda^{2}\boldsymbol{x}=A^{2}\boldsymbol{x}=A\boldsymbol{x}=\lambda\boldsymbol{x}$，故 $\lambda^{2}=\lambda$，即 $\lambda\in\{0,1\}$。

**(b)** 由 [1.6.4](../ch01/sec16.md#sec-1.6.4) 的直和分解，$A$ 在 $R(A)$ 上恒等、在 $N(A)$ 上零化，故相似于 $\operatorname{diag}(\underbrace{1,\cdots,1}_{r},\underbrace{0,\cdots,0}_{})$（$r=\operatorname{rank}A$）；迹是相似不变量，故 $\operatorname{tr}A=r=2$。

**(c)** 「互异 ⟹ 可对角化」是 [2.4.3](../ch02/sec24.md#sec-2.4.3) 的结论（充分）；反过来不成立：$A=I_n$ 可对角化但只有一个特征值。**失分点**：把它写成「充要」。
:::

::: sol 第 8 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 对、(c) 错。**

**(a)** [@thm-3.5.4] 的断言（对任何方阵成立；本册在复方阵上证明，再由相似搬回一般情形）。

**(b)** 特征值全为 $0$ 时 $f_A(\lambda)=\lambda^{n}$，代入得 $A^{n}=f_A(A)=O$ ✓。

**(c)** 次数不能降：$A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$（$n=2$）特征值全为 $0$，但 $A^{1}\neq O$。一整个 Jordan 块需要「满重数」的因子才能把它打成零——这正是 $m_A$ 与 $f_A$ 的差别（[3.5.4](../ch03/sec35.md#sec-3.5.4)）。
:::

::: sol 第 9 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 错、(c) 对。**

**(a)** 「分解式不唯一、标准形唯一」是 [3.1.1](../ch03/sec31.md#sec-3.1.1) 的一对结论：任取吸收矩阵就能造新分解，但秩在相抵下不变，故 $\Gamma$ 由 $r$ 唯一决定。

**(b)** 错。$B$ 只需是 $R(A)$ 的**任意一组基**（列满秩、$r$ 列即可），不必取自 $A$。最简单的反例是 $A=I_2A$：$A$ 本身取作 $B$，也可以另取 $A$ 的第 1、3 列（见本卷第 19 题的两个分解）。

**(c)** [@note-3.1-rank]：同型矩阵相抵 $\iff$ 同秩（相抵不变量只有秩）。
:::

::: sol 第 10 题答案（判断 1 分 + 理由 2 分）

**(a) 对、(b) 对、(c) 错。**

**(a)** 设 $T\boldsymbol{\xi}=\lambda\boldsymbol{\xi}$（$\boldsymbol{\xi}\neq\boldsymbol{\theta}$），则 $T(c\boldsymbol{\xi})=\lambda c\boldsymbol{\xi}\in\operatorname{span}\{\boldsymbol{\xi}\}$，故这条直线被映回自己。

**(b)** $\Lambda$ 上三角意味着 $\Lambda$ 保 $\operatorname{span}\{\boldsymbol{e}_1,\cdots,\boldsymbol{e}_k\}$；两边用 $U$ 换基（$A=U\Lambda U^{\mathrm H}$）得 $A\,U\operatorname{span}\{\boldsymbol{e}_1,\cdots,\boldsymbol{e}_k\}\subseteq U\operatorname{span}\{\boldsymbol{e}_1,\cdots,\boldsymbol{e}_k\}$。**这正是 Schur 型的几何内容**：把矩阵三角化＝找一组基让整条「嵌套的不变子空间链」显形。

**(c)** 错。「三角化人人有份、对角化不是」（[@thm-3.5.2] 之后的注 1）：反例 $J=\begin{pmatrix}1&1\\0&1\end{pmatrix}$——特征值 $1$ 的几何重数 $=2-\operatorname{rank}(J-I)=1<$ 代数重数 $2$，不可对角化，但当然可以酉相似于上三角（它本身就是上三角）。
:::

## 第二部分 · 填空简答（每题 4 分，共 20 分）

**11.（4 分）** 在 $\mathbb{C}^2$ 的标准内积下取 $\boldsymbol{x}=(1,\mathrm i)^{\mathrm T}$、$\boldsymbol{y}=(\mathrm i,1)^{\mathrm T}$。求 $\|\boldsymbol{x}\|$、$\|\boldsymbol{y}\|$、$(\boldsymbol{x},\boldsymbol{y})$；判断二者是否正交；并说明 $\|\boldsymbol{x}+\boldsymbol{y}\|^{2}$ 是否等于 $\|\boldsymbol{x}\|^{2}+\|\boldsymbol{y}\|^{2}$。

**12.（4 分）** 在 $\mathbb{R}^4$ 中取 $W_1=\operatorname{span}\{(1,1,0,0)^{\mathrm T},(0,0,1,1)^{\mathrm T}\}$、$W_2=\operatorname{span}\{(1,0,1,0)^{\mathrm T},(0,1,0,1)^{\mathrm T}\}$。求 $\dim W_1$、$\dim W_2$、$\dim(W_1+W_2)$、$\dim(W_1\cap W_2)$，并写出 $W_1\cap W_2$ 的一组基。

**13.（4 分）** 设 $A=\begin{pmatrix}1&2&0\\0&0&1\end{pmatrix}$。判断它有没有左逆、右逆；有的话写出一个，并用一行回代验证。

**14.（4 分）** 设 $A=\begin{pmatrix}4&2\\1&3\end{pmatrix}$。求 $A$ 的特征值与特征向量，写出一组基使 $A$ 相似于对角阵，并写出该对角阵。

**15.（4 分）** 设 $A=\begin{pmatrix}1&1&0\\0&1&0\\0&0&2\end{pmatrix}$。求 $f_A$ 与 $m_A$（写出候选与试算），并用 H–C 公式求 $A^{-1}$（回代验证一行）。

::: sol 第 11 题答案（每题 4 分：结果 2 分 + 依据 2 分）

$\|\boldsymbol{x}\|=\sqrt{|1|^{2}+|\mathrm i|^{2}}=\sqrt2$，$\|\boldsymbol{y}\|=\sqrt{|\mathrm i|^{2}+|1|^{2}}=\sqrt2$（长度一律**逐分量取模平方**）。

内积按「对第一变元线性、对第二变元共轭线性」：$(\boldsymbol{x},\boldsymbol{y})=1\cdot\overline{\mathrm i}+\mathrm i\cdot\overline{1}=-\mathrm i+\mathrm i=0$，故**二者正交**。
正交 ⟹ 勾股（这一方向在复空间同样成立）：$\|\boldsymbol{x}+\boldsymbol{y}\|^{2}=\|(1+\mathrm i,1+\mathrm i)^{\mathrm T}\|^{2}=|1+\mathrm i|^{2}+|1+\mathrm i|^{2}=4=\|\boldsymbol{x}\|^{2}+\|\boldsymbol{y}\|^{2}$ ✓。 **要点**：从第二变元提常数要**取共轭**：$(\boldsymbol{x},t\boldsymbol{y})=\bar{t}(\boldsymbol{x},\boldsymbol{y})$——这里 $(\boldsymbol{y},\boldsymbol{x})=\overline{(\boldsymbol{x},\boldsymbol{y})}=0$，别写成 $1\cdot\mathrm i+\mathrm i\cdot1=2\mathrm i$（[1.4.1](../ch01/sec14.md#sec-1.4.1)）。
:::

::: sol 第 12 题答案（每题 4 分：结果 2 分 + 依据 2 分）

$W_1$、$W_2$ 各自的生成组里两个向量都标准正交（且不成比例），故 $\dim W_1=\dim W_2=2$。

**交集**：设公共向量同时写成两边组合。比较分量，$a(1,1,0,0)+b(0,0,1,1)=(a,a,b,b)$ 与 $c(1,0,1,0)+d(0,1,0,1)=(c,d,c,d)$ 相等要求 $a=c$、$a=d$、$b=c$、$b=d$，故 $a=b=c=d$。于是
$$W_1\cap W_2=\operatorname{span}\{(1,1,1,1)^{\mathrm T}\},\qquad \dim(W_1\cap W_2)=1 .$$
维数公式：$\dim(W_1+W_2)=2+2-1=3$。 **核验**：$(1,1,1,1)^{\mathrm T}=(1,1,0,0)+(0,0,1,1)\in W_1$，同时 $=(1,0,1,0)+(0,1,0,1)\in W_2$ ✓；自由度数 $4-3=1$，与「交是一维」互相印证。
:::

::: sol 第 13 题答案（每题 4 分：结果 2 分 + 依据 2 分）

两行 $(1,2,0)$、$(0,0,1)$ 线性无关，故 $\operatorname{rank}A=2=m$：**行满秩 ⟹ 有右逆**。列数 $3>2$，列不满秩，**无左逆**。
按闭式公式 $B_0=A^{\mathrm H}(AA^{\mathrm H})^{-1}$：$AA^{\mathrm H}=\begin{pmatrix}5&0\\0&1\end{pmatrix}$，
$$B_0=\begin{pmatrix}1&0\\2&0\\0&1\end{pmatrix}\begin{pmatrix}1/5&0\\0&1\end{pmatrix}=\begin{pmatrix}1/5&0\\2/5&0\\0&1\end{pmatrix},\qquad AB_0=\begin{pmatrix}1&0\\0&1\end{pmatrix}=I_2\ \checkmark$$
（一行核对：$1\cdot\tfrac15+2\cdot\tfrac25=1$，$2\cdot0+0\cdot0+0\cdot1=0$，$0\cdot\tfrac15+0\cdot\tfrac25+1\cdot1=1$。） **要点**：**行**满秩配**右**逆（[@thm-3.1.1]）；$B_0$ 只是**一个**右逆，「全部右逆」还要加上「每列属于 $N(A)$」的任意矩阵 $Z$。
:::

::: sol 第 14 题答案（每题 4 分：结果 2 分 + 依据 2 分）

$f_A(\lambda)=\lambda^{2}-7\lambda+10=(\lambda-5)(\lambda-2)$（先用 $\operatorname{tr}=7$、$\det=10$ 试根）。

- $\lambda=5$：解 $(A-5I)\boldsymbol{x}=\boldsymbol{0}$，$A-5I=\begin{pmatrix}-1&2\\1&-2\end{pmatrix}$，取 $\boldsymbol{\xi}_1=(2,1)^{\mathrm T}$；
- $\lambda=2$：解 $(A-2I)\boldsymbol{x}=\boldsymbol{0}$，$A-2I=\begin{pmatrix}2&2\\1&1\end{pmatrix}$，取 $\boldsymbol{\xi}_2=(1,-1)^{\mathrm T}$。

取 $P=\begin{pmatrix}2&1\\1&-1\end{pmatrix}$，$\det P=-3\neq0$，故这两列构成基，且
$$P^{-1}AP=\operatorname{diag}(5,2).$$
**核验**：$5+2=7=\operatorname{tr}A$、$5\cdot2=10=\det A$ ✓；$\boldsymbol{\xi}_1,\boldsymbol{\xi}_2$ 来自不同特征值，必线性无关（不同特征值的特征向量线性无关）。
:::

::: sol 第 15 题答案（每题 4 分：结果 2 分 + 依据 2 分）

上三角阵，故 $f_A(\lambda)=(\lambda-1)^{2}(\lambda-2)=\lambda^{3}-4\lambda^{2}+5\lambda-2$。

**候选**（各根重数从 $1$ 到 $d_j$）：$(\lambda-1)(\lambda-2)$ 与 $(\lambda-1)^{2}(\lambda-2)$。**从低往高试**：
$$(A-I)(A-2I):\quad A-I=\begin{pmatrix}0&1&0\\0&0&0\\0&0&1\end{pmatrix},\quad A-2I=\begin{pmatrix}-1&1&0\\0&-1&0\\0&0&0\end{pmatrix},$$
$(A-I)$ 的第一行 $(0,1,0)$ 乘 $(A-2I)$ 得 $(A-2I)$ 的第二行 $(0,-1,0)\neq\boldsymbol{0}$，故低次候选被淘汰，$m_A=(\lambda-1)^{2}(\lambda-2)$。

**求逆**（$a_2=-4$、$a_1=5$、$a_0=-2$）：
$$A^{-1}=-\frac{1}{a_0}\big(A^{2}+a_2A+a_1I\big)=\frac12\big(A^{2}-4A+5I\big),\qquad A^{2}=\begin{pmatrix}1&2&0\\0&1&0\\0&0&4\end{pmatrix},$$
$$A^{-1}=\frac12\begin{pmatrix}2&-2&0\\0&2&0\\0&0&1\end{pmatrix}=\begin{pmatrix}1&-1&0\\0&1&0\\0&0&\tfrac12\end{pmatrix}.$$
**回代一行**：$A$ 的第 1 行 $(1,1,0)$ 乘 $A^{-1}$ 的第 2 列 $(-1,1,0)^{\mathrm T}$ 得 $0$ ✓（另两列给出 $1$，即 $AA^{-1}=I$）。
:::

## 第三部分 · 推导证明（每题 10 分，共 30 分）

**16.（10 分）** 设 $W_1,W_2$ 是有限维线性空间 $V$ 的子空间。证明维数公式
$$\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2).$$

**17.（10 分）** 设 $T\in L(V,W)$，$V,W$ 有限维。证明亏加秩定理 $\dim N(T)+\dim R(T)=\dim V$，并说明「$\dim V=\dim W$ 时，$T$ 单射 $\iff$ $T$ 满射」用到其中哪一步。

**18.（10 分）** 设 $A\in\mathbb{C}^{m\times n}$。证明 $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$；并回答：这个证明能不能照搬到 $A^{2}$（即**不能**断言 $\operatorname{rank}A=\operatorname{rank}(A^{2})$），为什么？给出一个反例。

::: sol 第 16 题答案（10 分）

**① 取交的基（2 分）**：设 $\boldsymbol{u}_1,\cdots,\boldsymbol{u}_m$ 是 $W_1\cap W_2$ 的一组基（$m$ 可以为 $0$，此时下面的论证自动成立）。

**② 双向扩充（2 分）**：由基扩充定理，把它扩充成 $W_1$ 的基 $\boldsymbol{u}_1,\cdots,\boldsymbol{u}_m,\boldsymbol{v}_1,\cdots,\boldsymbol{v}_s$（$m+s=\dim W_1$），同时扩充成 $W_2$ 的基 $\boldsymbol{u}_1,\cdots,\boldsymbol{u}_m,\boldsymbol{w}_1,\cdots,\boldsymbol{w}_t$（$m+t=\dim W_2$）。

**③ 证明拼起来的 $m+s+t$ 个向量是 $W_1+W_2$ 的基（6 分）**：

- **张成**：任取 $\boldsymbol{z}=\boldsymbol{x}+\boldsymbol{y}$（$\boldsymbol{x}\in W_1$、$\boldsymbol{y}\in W_2$），$\boldsymbol{x}$ 由 $\boldsymbol{u}$ 与 $\boldsymbol{v}$ 表出、$\boldsymbol{y}$ 由 $\boldsymbol{u}$ 与 $\boldsymbol{w}$ 表出，故 $\boldsymbol{z}$ 由全组表出。
- **线性无关**：设 $\sum_i\alpha_i\boldsymbol{u}_i+\sum_j\beta_j\boldsymbol{v}_j+\sum_k\gamma_k\boldsymbol{w}_k=\boldsymbol{\theta}$。记 $\boldsymbol{z}_0=\sum_k\gamma_k\boldsymbol{w}_k$，则 $\boldsymbol{z}_0=-(\sum_i\alpha_i\boldsymbol{u}_i+\sum_j\beta_j\boldsymbol{v}_j)\in W_1$，而它本来就 $\in W_2$，故 $\boldsymbol{z}_0\in W_1\cap W_2$，可写成 $\boldsymbol{z}_0=\sum_i\delta_i\boldsymbol{u}_i$。代入得 $\sum_k\gamma_k\boldsymbol{w}_k-\sum_i\delta_i\boldsymbol{u}_i=\boldsymbol{\theta}$，由 $W_2$ 的基无关得 $\gamma_k=\delta_i=0$（$k,i$ 全部）；代回原式，由 $W_1$ 的基无关得 $\beta_j=\alpha_i=0$。故全组无关。

**④ 计数（随结论写出）**：$\dim(W_1+W_2)=m+s+t=(m+s)+(m+t)-m=\dim W_1+\dim W_2-\dim(W_1\cap W_2)$。$\blacksquare$ **评分**：①②各 2 分；③张成 2 分、无关 4 分（**必须**出现「组合落在 $W_1\cap W_2$ 里 → 用交的基再拆一次 → 回到两边基的无关性」这条链）；只写「拼起来就是基」不得分。
:::

::: sol 第 17 题答案（10 分）

**① 从核取基、扩充到 $V$ 的基（3 分）**：设 $\boldsymbol{h}_1,\cdots,\boldsymbol{h}_m$ 是 $N(T)$ 的基（$m=\dim N(T)$），由基扩充定理添成 $V$ 的基 $\boldsymbol{h}_1,\cdots,\boldsymbol{h}_m,\boldsymbol{h}_{m+1},\cdots,\boldsymbol{h}_n$（$n=\dim V$）。

**② 值域由后 $n-m$ 个像张成（3 分）**：任取 $\boldsymbol{x}=\sum_{i=1}^{n}k_i\boldsymbol{h}_i$。由 $T$ 保持线性组合（[@thm-2.2.1]）与 $T(\boldsymbol{h}_i)=\boldsymbol{\theta}'$（$i\le m$），
$$T(\boldsymbol{x})=k_{m+1}T(\boldsymbol{h}_{m+1})+\cdots+k_nT(\boldsymbol{h}_n),$$
故 $R(T)=\operatorname{span}\{T(\boldsymbol{h}_{m+1}),\cdots,T(\boldsymbol{h}_n)\}$，$\dim R(T)\le n-m$。

**③ 这 $n-m$ 个像线性无关（4 分）**：设 $c_{m+1}T(\boldsymbol{h}_{m+1})+\cdots+c_nT(\boldsymbol{h}_n)=\boldsymbol{\theta}'$。左边 $=T\big(c_{m+1}\boldsymbol{h}_{m+1}+\cdots+c_n\boldsymbol{h}_n\big)$，故 $\boldsymbol{c}:=c_{m+1}\boldsymbol{h}_{m+1}+\cdots+c_n\boldsymbol{h}_n\in N(T)$，可写成 $\boldsymbol{c}=c_1\boldsymbol{h}_1+\cdots+c_m\boldsymbol{h}_m$。于是 $\boldsymbol{h}$ 组有一个系数为 $(-c_1,\cdots,-c_m,c_{m+1},\cdots,c_n)$ 的零组合；由 $\boldsymbol{h}$ 组是基（无关），全部系数为零，特别地 $c_{m+1}=\cdots=c_n=0$。故这 $n-m$ 个像构成 $R(T)$ 的基，$\dim R(T)=n-m$，即 $\dim N(T)+\dim R(T)=\dim V$。$\blacksquare$

**关于同维推论（写在题末即可）**：$T$ 单射 $\iff N(T)=\{\boldsymbol{\theta}\}\iff\dim N(T)=0\iff\dim R(T)=\dim V$；当 $\dim V=\dim W$ 时，$\dim R(T)=\dim W$ 结合 $R(T)\subseteq W$ 得 $R(T)=W$，即 $T$ 满射；反向同理。**用到的正是第 ③ 步给出的等式**（以及「子空间维数等于全空间维数 ⟹ 二者相等」这一步）。
:::

::: sol 第 18 题答案（10 分）

**① 包含方向（2 分）**：若 $A\boldsymbol{x}=\boldsymbol{0}$，两边左乘 $A^{\mathrm H}$ 得 $A^{\mathrm H}A\boldsymbol{x}=\boldsymbol{0}$，故 $N(A)\subseteq N(A^{\mathrm H}A)$。

**② 反方向（4 分）**：设 $A^{\mathrm H}A\boldsymbol{x}=\boldsymbol{0}$，左乘 $\boldsymbol{x}^{\mathrm H}$ 得 $0=\boldsymbol{x}^{\mathrm H}A^{\mathrm H}A\boldsymbol{x}=(A\boldsymbol{x})^{\mathrm H}(A\boldsymbol{x})=\|A\boldsymbol{x}\|^{2}$；由内积的**正定性**（[@def-1.4.1]）得 $A\boldsymbol{x}=\boldsymbol{0}$，即 $N(A^{\mathrm H}A)\subseteq N(A)$。

**③ 换成维数（2 分）**：两矩阵列数相同、零空间相同，由 $\dim N+\operatorname{rank}=$ 列数得 $\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}A$。

**关于 $A^{2}$（2 分）**：整个证明只用到「$A^{\mathrm H}A$ 是 $A$ 的 Gram 组装」这一结构——$\boldsymbol{x}^{\mathrm H}(A^{\mathrm H}A)\boldsymbol{x}=\|A\boldsymbol{x}\|^{2}\ge0$。$A^{2}$ 没有这个结构（$A^{2}$ 与 $A$ 的零空间一般不同），等式不成立。**反例**：$A=\begin{pmatrix}0&1\\0&0\end{pmatrix}$，$\operatorname{rank}A=1$ 而 $A^{2}=O$，$\operatorname{rank}A^{2}=0$。
:::

## 第四部分 · 综合应用（每题 10 分，共 20 分）

**19.（10 分）** 设 $A=\begin{pmatrix}1&1&2\\2&1&3\\1&0&1\end{pmatrix}$。
**(a)**（2 分）求 $\operatorname{rank}A$ 与行简化阶梯形 $R$；
**(b)**（3 分）用 RREF 法求 $A$ 的一个满秩分解 $A=BC$，并回代验证；
**(c)**（3 分）解 $A\boldsymbol{x}=\boldsymbol{b}_1$（$\boldsymbol{b}_1=(1,1,0)^{\mathrm T}$）写出通解，并判断 $A\boldsymbol{x}=\boldsymbol{b}_2$（$\boldsymbol{b}_2=(1,1,1)^{\mathrm T}$）是否有解；
**(d)**（2 分）写出 $R(A)$ 与 $N(A)$ 的基。

**20.（10 分）** 设 $A=\begin{pmatrix}1&1&0\\0&0&0\\0&0&1\end{pmatrix}$。
**(a)**（2 分）验证 $A^{2}=A$；
**(b)**（3 分）求 $R(A)$、$N(A)$ 的基与维数，并验证 $\mathbb{C}^3=R(A)\dotplus N(A)$；
**(c)**（2 分）求 $\operatorname{tr}A$ 与 $\operatorname{rank}A$，并说明二者相等的原因；
**(d)**（3 分）求 $A$ 的全部特征值与特征子空间，写出一组基使 $A$ 相似于对角阵并写出该对角阵。

::: sol 第 19 题答案（10 分）

**(a)（2 分）** $r_3=r_2-r_1$（$(2,1,3)-(1,1,2)=(1,0,1)$），故 $\operatorname{rank}A=2$。消元：
$$\begin{pmatrix}1&1&2\\2&1&3\\1&0&1\end{pmatrix}\xrightarrow{r_2-2r_1,\ r_3-r_1}\begin{pmatrix}1&1&2\\0&-1&-1\\0&-1&-1\end{pmatrix}\xrightarrow{r_3-r_2}\begin{pmatrix}1&1&2\\0&-1&-1\\0&0&0\end{pmatrix}\xrightarrow{-r_2,\ r_1-r_2}\begin{pmatrix}1&0&1\\0&1&1\\0&0&0\end{pmatrix}=R .$$
主元列是第 $1,2$ 列。

**(b)（3 分）** $B=$ $A$ 的第 1、2 列 $=\begin{pmatrix}1&1\\2&1\\1&0\end{pmatrix}$，$C=R$ 的前两行 $=\begin{pmatrix}1&0&1\\0&1&1\end{pmatrix}$。回代：
$$BC=\begin{pmatrix}1&1\\2&1\\1&0\end{pmatrix}\begin{pmatrix}1&0&1\\0&1&1\end{pmatrix}=\begin{pmatrix}1&1&2\\2&1&3\\1&0&1\end{pmatrix}=A\ \checkmark$$
（读法核对：$A$ 的第 3 列 $=$ 第 1 列 $+$ 第 2 列，正是 $C$ 的第 3 列 $(1,1)^{\mathrm T}$。）

**(c)（3 分）** 第三行是「第二行减第一行」，故 $A\boldsymbol{x}=\boldsymbol{b}$ 有解 $\iff b_3=b_2-b_1$。
对 $\boldsymbol{b}_1$：$0=1-1$ ✓ 有解。解前两式 $x_1+x_2+2x_3=1$、$2x_1+x_2+3x_3=1$，相减得 $x_1+x_3=0$，即 $x_1=-x_3$；代回第一式 $x_2+x_3=1$。取 $x_3=t$：
$$\boldsymbol{x}=(-t,\ 1-t,\ t)^{\mathrm T},\qquad t\in\mathbb{C}\quad(\text{自由度数}\ 1=n-r\ \checkmark)$$
对 $\boldsymbol{b}_2$：$1\neq 1-1=0$，**无解**。

**(d)（2 分）** $R(A)=R(B)=\operatorname{span}\{(1,2,1)^{\mathrm T},(1,1,0)^{\mathrm T}\}$；由 $C\boldsymbol{y}=\boldsymbol{0}$（或直接解 $R\boldsymbol{x}=\boldsymbol{0}$）得 $x_1=-x_3$、$x_2=-x_3$，故
$$N(A)=\operatorname{span}\{(-1,-1,1)^{\mathrm T}\}\quad(\dim=1=3-2\ \checkmark)$$
**评分**：(a) 2 分；(b) $B$、$C$ 各 1 分、回代 1 分；(c) 通解 2 分、无解判断与理由 1 分；(d) 两个基各 1 分。
:::

::: sol 第 20 题答案（10 分）

**(a)（2 分）** 逐行相乘：第 1 行 $(1,1,0)\cdot A=(1,1,0)$；第 2 行 $\boldsymbol{0}\cdot A=\boldsymbol{0}$；第 3 行 $(0,0,1)\cdot A=(0,0,1)$。故 $A^{2}=A$ ✓。

**(b)（3 分）** 列空间：$A$ 的第 1、3 列独立、第 2 列 $=$ 第 1 列，故
$$R(A)=\operatorname{span}\{(1,0,0)^{\mathrm T},(0,0,1)^{\mathrm T}\},\qquad \dim R(A)=2 .$$
再解 $A\boldsymbol{x}=\boldsymbol{0}$：$x_1+x_2=0$、$x_3=0$，故 $N(A)=\operatorname{span}\{(1,-1,0)^{\mathrm T}\}$，$\dim N(A)=1$。
直和验证：$R(A)$ 中向量的形状是 $(a,0,c)^{\mathrm T}$，若它同时等于 $t(1,-1,0)^{\mathrm T}$，则由第二分量 $-t=0$ 得 $t=0$，即 $R(A)\cap N(A)=\{\boldsymbol{\theta}\}$；又 $\dim R(A)+\dim N(A)=3=\dim\mathbb{C}^3$，由[@thm-1.6.1] 得 $\mathbb{C}^3=R(A)\dotplus N(A)$ ✓。

**(c)（2 分）** $\operatorname{tr}A=1+0+1=2$，$\operatorname{rank}A=2$，二者相等。**原因**：$A$ 在 $R(A)$ 上恒等、在 $N(A)$ 上零化（(b) 的两组基拼起来就是 $\mathbb{C}^3$ 的基），故 $A$ 在这组基下的矩阵是 $\operatorname{diag}(1,1,0)$；迹是相似不变量，等于特征值之和 $1+1+0=2=$ 特征值 $1$ 的个数 $=\operatorname{rank}A$。

**(d)（3 分）** 由上述对角形：特征值 $\lambda=1$（代数重数 $2$，特征子空间 $V_1=R(A)=\operatorname{span}\{(1,0,0)^{\mathrm T},(0,0,1)^{\mathrm T}\}$）、$\lambda=0$（代数重数 $1$，$V_0=N(A)=\operatorname{span}\{(1,-1,0)^{\mathrm T}\}$）；几何重数 $=$ 代数重数，故可对角化。取
$$P=\begin{pmatrix}1&0&1\\0&0&-1\\0&1&0\end{pmatrix}\quad(\text{三列依次是 }R(A)\text{ 的两列与 }N(A)\text{ 的基}),\qquad \det P=1\neq0,$$
则 $AP=P\operatorname{diag}(1,1,0)$，即 $P^{-1}AP=\operatorname{diag}(1,1,0)$。
**核验**：$A(1,0,0)^{\mathrm T}=(1,0,0)^{\mathrm T}$ ✓、$A(0,0,1)^{\mathrm T}=(0,0,1)^{\mathrm T}$ ✓、$A(1,-1,0)^{\mathrm T}=(0,0,0)^{\mathrm T}$ ✓。 **评分**：(a) 2 分；(b) 两个基与维数 2 分、直和 1 分；(c) 2 分（数值 1 分、理由 1 分）；(d) 特征值与特征子空间 1 分、$P$ 与对角形 1 分、核验 1 分。
:::

<a id="exam-rubric"></a>

## 评分标准

| 部分 | 题量 | 分值 | 给分要点 |
|:--|:--:|:--:|:--|
| 一 · 概念判断 | 10 | 30 | 每题：判断 1 分 + 理由 / 反例 2 分；只写「对 / 错」只得 1 分 |
| 二 · 填空简答 | 5 | 20 | 每题：结果 2 分 + 依据 / 过程 2 分 |
| 三 · 推导证明 | 3 | 30 | 每题：第一行与结构 4 分 + 三步完整 6 分；只写结论 $\le2$ 分 |
| 四 · 综合应用 | 2 | 20 | 每题：方法选择 3 分 + 计算过程 4 分 + 回代验证或理由 3 分 |

**分数段与去向**：

| 得分 | 水平 | 下一步 |
|:--:|:--|:--|
| **90–100** | 可以上考场 | 只做[竞技场](arena.md)的三分钟挑战保持手感，隔 3 天重做第 16、18 题 |
| **75–89** | 过线有把握 | 按[漏点定位表](#exam-map)回读对应小节，再把错题重做一遍 |
| **60–74** | 有漏洞 | 先重做三章习题集的 C 组计算题，再回本卷做第二部分 |
| **$<60$** | 需系统补 | 回[全章知识地图](../preface-map.md)重走主干，用[速查背记卡](../memory-sheet.md)重建骨架，再回来 |

<a id="exam-map"></a>

## 漏点定位表

| 错题 | 回去读 | 立刻补做 |
|:--|:--|:--|
| 1、2 | [1.1.4](../ch01/sec11.md#sec-1.1.4)、[1.1.8](../ch01/sec11.md#sec-1.1.8)、[1.2.2](../ch01/sec12.md#sec-1.2.2) | [第一章习题集](../ch01/exercises.md)：A1、A2、A6 |
| 3 | [1.3.5](../ch01/sec13.md#sec-1.3.5)、[1.3.7](../ch01/sec13.md#sec-1.3.7) | 第一章习题集：C4、C5 |
| 4、12 | [1.3.9](../ch01/sec13.md#sec-1.3.9) | 第一章习题集：C6（再自造一次「三条直线」反例） |
| 5 | [1.6.2](../ch01/sec16.md#sec-1.6.2)–[1.6.7](../ch01/sec16.md#sec-1.6.7) | 第一章习题集：A14、C14、C15 |
| 6、17 | [2.2.3](../ch02/sec22.md#sec-2.2.3)、[2.2.5](../ch02/sec22.md#sec-2.2.5) | [第二章习题集](../ch02/exercises.md)：B4 |
| 7、10、14、20 | [2.4.1](../ch02/sec24.md#sec-2.4.1)–[2.4.3](../ch02/sec24.md#sec-2.4.3)、[1.6.4](../ch01/sec16.md#sec-1.6.4) | 第二章习题集：B10、C11、C12 |
| 8、15 | [3.5.3](../ch03/sec35.md#sec-3.5.3)、[3.5.4](../ch03/sec35.md#sec-3.5.4) | [第三章习题集](../ch03/exercises.md#ex-C21)：C21、[C24](../ch03/exercises.md#ex-C24) |
| 9、19 | [3.1.1](../ch03/sec31.md#sec-3.1.1)、[3.1.2](../ch03/sec31.md#sec-3.1.2)、[3.2.1](../ch03/sec32.md#sec-3.2.1)、[3.2.2](../ch03/sec32.md#sec-3.2.2) | 第三章习题集：[C1](../ch03/exercises.md#ex-C1)、C2、C7 |
| 11 | [1.4.1](../ch01/sec14.md#sec-1.4.1)、[1.5.1](../ch01/sec15.md#sec-1.5.1) | 第一章习题集：A11、C10 |
| 13 | [3.1.3](../ch03/sec31.md#sec-3.1.3) | [第三章习题集](../ch03/exercises.md)：C4、C5 |
| 16 | [1.3.9](../ch01/sec13.md#sec-1.3.9)、[证明工坊 · 骨架六](../proof-workshop.md) | 第一章习题集：B3 |
| 18 | [3.1.4](../ch03/sec31.md#sec-3.1.4) | 第三章习题集：B9、C6 |
| 概念题整体错得多 | [必考点竞技场](arena.md)第一节（快问快答 25 条） | 第二天重刷这 25 条，目标 23 题以上 |

**最后一句**：这张卷子的目的不是打分，而是**把你以为会的地方暴露出来**。凡是有「写得出来但讲不清」的地方，回到[必考点竞技场](arena.md)的推导现场再练一遍——那里练的是**在压力下还讲得出**。

---

**依据**第一至三章正文（1.1–1.6、2.1–2.5、3.1–3.2 与 3.4–3.5）整理 · 覆盖三章、题目均为新增（与各章自测卷不重复，只换数字与场景）· 全部计算经回代验算 · 3.3 三角分解尚未入库，本卷不出题 · 整理日期 2026-10-15。
