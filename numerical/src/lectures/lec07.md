# 第 7 讲（09-28）：幂法——规范化、特征值的算法与反幂法；非线性方程迭代法开篇

::: note 本编数学核验补注 · Rayleigh 商的适用条件
课堂中的“算特征值必须取 2-范数”专指省略分母的 $y^{\mathrm T}Ay$ 写法。一般的 Rayleigh 商是 $y^{\mathrm T}Ay/(y^{\mathrm T}y)$，对任意非零 $y$ 都可用，与采用哪种范数归一化无关；仅当 $\lVert y\rVert_2=1$ 才可省略分母。不能把课堂简写当成对其他提取方式的否定。主特征值为负时，归一化向量还可能正负交替，应说方向收敛。完整公式与复算表见[幂法正文](../course/ch03/sec31.md)。
:::


> 课堂实录精编。本讲**无课件、全程板书**（课件流整段「无视频信号」），承接
> [第 6 讲](lec06.md)末尾留下的问题——「求按模最大的特征值及其特征向量」——
> 主线四段：**幂法的收敛性**——实矩阵按模严格最大的特征值必为实数（共轭特征值
> 反证），$A^ku_0$ 中非主特征分量相对衰减，但绝对量仍大且 $\lambda_1^k$ 会溢出，
> 于是每步**先单位化再乘 $A$**，回推得 $y_k\to\alpha_1x_1/\lVert\alpha_1x_1\rVert$；
> **特征值的算法**——特征向量到手后再作用一次 $A$，**取 2-范数时**
> $y_k^{\mathrm T}Ay_k\to\lambda_1$（内积 = 欧氏长度平方），范数取 $\infty$-范数
> 则另作讨论；**反幂法与位移**——把「模最小」用 $A^{-1}$ 翻成「模最大」（实际计算
> 每步解 $Au_{k+1}=y_k$），再用位移 $A-pI$ 把「最接近已知近似 $p$」的目标特征值
> 变成模最小的，三者统一为同一套算法；**非线性方程开篇**——$f(x)=0$ 等价变形为
> $x=\varphi(x)$ 的迭代，先复习二分法（介值定理 + 区间折半），再给出不动点迭代的
> 收敛定理，并当堂证明不动点的**存在性**（唯一性与压缩条件留到下一讲）。
> 对应原书第 3 章（特征值与特征向量计算）与第 4 章（非线性方程）的引入部分。
> 原始转写存档于仓库根目录 `transcripts/`（源文件，不随书构建发布）；
> 本页公式逐条对照教师摄像头板书关键帧核对（板书全程为绿板粉笔手写，见下文各节
> 「板书」标注）。

::: method[core] 10 分钟复习版 · 第 7 讲

**一句话**：**先单位化、再乘 $A$** 的迭代把初始向量的主特征分量放大出来（**幂法**）；$A$ 换成 $A^{-1}$ 即求模最小（**反幂法**），再位移 $A-pI$ 即求最接近已知值的那一个；下半场转入非线性方程，$f(x)=0$ 改写为 $x=\varphi(x)$ 迭代。

**必记结论**

| 内容 | 要点 |
|:--|:--|
| 问题设定 | $A$ 实矩阵，$|\lambda_1|\gt|\lambda_2|\ge\cdots\ge|\lambda_n|$，$x_1,\dots,x_n$ 互异（线性无关） |
| 基本展开 | $u_0=\sum_i\alpha_ix_i\Rightarrow A^ku_0=\lambda_1^k\bigl[\alpha_1x_1+\sum_{i\ge2}\alpha_i(\lambda_i/\lambda_1)^kx_i\bigr]$ |
| **实数性** | 实矩阵的按模严格最大特征值**必为实数**（否则共轭 $\bar\lambda_1$ 也是特征值、模相同且不同，矛盾） |
| 两个障碍 | ① 其他分量只是**相对**变小，绝对量仍大；② $\lambda_1^k$ 增长过快（溢出/下溢） |
| **幂法** | $y_k=\dfrac{u_k}{\lVert u_k\rVert}$，$u_{k+1}=Ay_k$——**先单位化，再乘 $A$**；范数取法任意 |
| 收敛 | $y_k\to\dfrac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}$（$\lambda_1\gt0$）；$\lambda_1\lt0$ 时差一个 $(-1)^k$，符号交替 |
| **特征值** | 取 **2-范数**：$y_k^{\mathrm T}Ay_k\to\lambda_1$（因 $\lVert y_k\rVert_2=1$，且 $x_1^{\mathrm T}x_1=\lVert x_1\rVert_2^2$） |
| **反幂法** | $\lambda_1$ 模**最小** $\Rightarrow$ 对 $A^{-1}$ 用幂法得 $1/\lambda_1$；实际每步解 $Au_{k+1}=y_k$，不构造 $A^{-1}$ |
| **位移反幂法** | 已知 $\lambda_k$ 的近似 $p$（半解析/渐近展开）$\Rightarrow$ 对 $A-pI$ 用反幂法得最小特征值 $\lambda_k-p$，再加回 $p$ |

**三个问题一个算法**：求模最大 → 幂法；求模最小 → $A\mapsto A^{-1}$；求最接近 $p$ → $A\mapsto A-pI$ 后求模最小。后两者都化归到第一种。

**非线性方程开篇**：$f(x)=0\iff x=\varphi(x)$，迭代 $x_{k+1}=\varphi(x_k)$，极限即不动点（变形方式不唯一，如 $\varphi=x+f$）。**二分法**：$f$ 连续且 $f(a)f(b)\lt0$ $\Rightarrow$ 由介值定理有根，反复折半，$|[a_n,b_n]|=(b-a)/2^n$。**收敛定理**：$\varphi$ 在 $[a,b]$ 连续可导 +（i）$\varphi$ 把 $[a,b]$ 映到自身 +（ii）$|\varphi'|\le L\lt1$ $\Rightarrow$ 任取 $x_0\in[a,b]$ 迭代收敛到**唯一**不动点。

**老师强调的考点**：**本讲记号先单位化再乘**——「先单位化，单位化之后的那个东西我再给它乘 $A$」；计算**特征向量**时范数随便取，省略 Rayleigh 分母时**须作 2-范数单位化**；「**严格**按模最大」这个前提缺不得，全部推导都建在它上面；反幂法记住**不构造 $A^{-1}$、每步解一个方程组**；不动点定理的**两个条件各管什么**（第一条管迭代值不越界，第二条管收敛）。

**对应正文**：[第 3 章](../course/ch03/overview.md) + [第 4 章](../course/ch04/overview.md)开篇；谱半径与谱理论见[补充篇 2.5](../supplement/sec25.md)
:::

## 课堂时间线 {#lec07-S1}

| 时间 | 内容 |
|---|---|
| 01:53–08:16 | 问题设定：$A$ 实、$|\lambda_1|$ 严格最大、特征向量互异；$A^ku_0$ 展开与主分量占优 |
| 08:16–14:00 | $\lambda_1$ 必为实数：特征多项式系数为实 + 共轭特征值反证 |
| 14:00–19:30 | 两个障碍（绝对量仍大、$\lambda_1^k$ 溢出）与「单位化」的动机 |
| 19:30–29:00 | 规范化幂法的回推推导：$y_k$ 溯源到 $A^ku_0$，取极限分 $\lambda_1$ 正负两种情形 |
| 29:00–34:00 | 特征值怎么算：有了特征向量，再作用一次 $A$ |
| 34:00–44:00 | **取 2-范数**：$y_k^{\mathrm T}Ay_k\to\lambda_1$；内积 = 欧氏长度平方（三维例子） |
| 44:00–46:50 | 计算方案总结（板书框出算法）；$\infty$-范数情形留给同学 |
| 46:51–51:45 | 课间休息（转写为环境噪声） |
| 51:45–54:46 | 教材与方法论闲谈：本国教材「跳细节」vs 国外教材「全展开」 |
| 54:46–58:00 | 定理陈述：算法、两种极限情形与特征值公式 |
| 58:00–1:07:00 | 情况二：$\lambda_1$ 模最小 → 反幂法；实际每步解 $Au_{k+1}=y_k$ |
| 1:07:00–1:15:30 | 情况三：量子力学能级 → 已知近似 $p$ → 位移 $A-pI$ → 反幂法 |
| 1:15:30–1:16:40 | 线性方程组部分收束，转入非线性方程 |
| 1:16:40–1:18:10 | $f(x)=0\iff x=\varphi(x)$；迭代格式与不动点方程 |
| 1:18:10–1:26:30 | 二分法：介值定理、折半定位、区间长度 $(b-a)/2^n$ |
| 1:26:30–1:29:00 | 回到迭代：与线性方程组迭代法同构的框架 |
| 1:29:00–1:33:00 | 收敛定理的两个条件（自映射 + 压缩）及其含义 |
| 1:33:00–1:37:00 | 不动点**存在性**证明：$F=x-\varphi(x)$ 两端异号 + 介值定理 |
| 1:37:00–1:39:03 | 下课 |

## 一、问题设定与基本思想（01:53–08:16） {#lec07-S2}

[第 6 讲](lec06.md)末尾从薛定谔方程的能级计算引出「求按模最大的特征值」。本讲
开场先把问题写清楚（板书①）：

$$A\ \text{为实矩阵},\qquad |\lambda_1|\gt|\lambda_2|\ge|\lambda_3|\ge\cdots\ge|\lambda_n|,
\qquad x_1,x_2,\dots,x_n\ \text{互异},$$

「我们要计算的情况是：$A$ 是实矩阵，并且有一个（特征）根，它的绝对值要**严格**大于
其他所有特征根。」特征向量互异是**假设**，用来保证 $x_1,\dots,x_n$ **线性无关**、能张成整个
空间——「因为 $A$ 的特征（向量）是能张成整个空间的，所以我随便给一个初始向量，
它一定可以由这些特征向量**线性表示**」。任取非零初始向量

$$u_0=\alpha_1x_1+\alpha_2x_2+\cdots+\alpha_nx_n .$$

由 $Ax_i=\lambda_ix_i$ 得 $A^kx_i=\lambda_i^kx_i$（板书把三条并列写出：
$Ax_i=\lambda_ix_i$、$A^kx_i=\lambda_i^kx_i$、$A^nx_i=\lambda_i^nx_i$），于是（板书逐行写出）：

$$A^ku_0=\alpha_1A^kx_1+\alpha_2A^kx_2+\cdots+\alpha_nA^kx_n
=\alpha_1\lambda_1^kx_1+\alpha_2\lambda_2^kx_2+\cdots+\alpha_n\lambda_n^kx_n,$$

提出公因子 $\lambda_1^k$：

$$\boxed{\ A^ku_0=\lambda_1^k\Bigl[\alpha_1x_1+\alpha_2\Bigl(\frac{\lambda_2}{\lambda_1}\Bigr)^kx_2
+\cdots+\alpha_n\Bigl(\frac{\lambda_n}{\lambda_1}\Bigr)^kx_n\Bigr]\ }$$

因为 $|\lambda_1|$ 严格最大，每个 $|\lambda_i/\lambda_1|\lt1\ (i\ge2)$，括号里除第一项外
全部随 $k$ 衰减——**主特征分量逐渐占据主导**。「这就是我们要的效果。」

**但有两个问题**（老师特意在此停顿，第 14 分钟起展开）：

1. **相对衰减 ≠ 绝对衰减**。其他分量只是**占比**在缩小，其绝对数值仍然不小，
   「并没有起到把其他那些组分消除掉的作用」；
2. **溢出**。整个括号还被 $\lambda_1^k$ 乘着，「如果这个 $\lambda_1$ 的绝对值很大，
   那前面这一整块就都变成一个很大的数」——计算过程中增长过快，机器装不下
   （$|\lambda_1|\lt1$ 时反向下溢）。

「现在我们要设计一种算法……把其他这些组分真正滤掉，把前面的 $\alpha_1$
也算出来，**并且不出现增长很快的情况**。」

## 二、$\lambda_1$ 必为实数（08:16–14:00） {#lec07-S3}

在设计算法之前，先补一个性质：**实矩阵按模严格最大的特征值一定是实数**。

设 $f(\lambda)=\det(\lambda I-A)$ 为特征多项式。$A$ 是实矩阵 $\Rightarrow$ 各系数为实：

$$f(\lambda)=a_n\lambda^n+a_{n-1}\lambda^{n-1}+\cdots+a_0,\qquad a_n,\dots,a_0\in\mathbb R .$$

$\lambda_1$ 是它的根：$a_n\lambda_1^n+a_{n-1}\lambda_1^{n-1}+\cdots+a_0=0$。

**反设** $\lambda_1$ 不是实数，即 $\operatorname{Im}\lambda_1\neq0$，则其共轭
$\overline{\lambda_1}\neq\lambda_1$（共轭把虚部符号反过来，必与原数不同）。对上式两边取
共轭，用两条性质——**乘积的共轭 = 共轭的乘积**、**实数的共轭是自身**（$a_i\in\mathbb R$）：

$$a_n\overline{\lambda_1}^{\,n}+a_{n-1}\overline{\lambda_1}^{\,n-1}+\cdots+a_0=0 .$$

这说明 $\overline{\lambda_1}$ **也是** $A$ 的特征值。而

$$|\overline{\lambda_1}|=|\lambda_1|,\qquad \overline{\lambda_1}\neq\lambda_1,$$

于是出现**两个**模相等的特征值，且它们的模都等于最大值——与「$\lambda_1$ 的模**严格**大于
其他所有特征值的模」矛盾。故 $\lambda_1\in\mathbb R$。$\blacksquare$

::: note 课上的一处停顿
共轭的乘积性质（$\overline{z_1z_2}=\overline{z_1}\,\overline{z_2}$）老师原本以为人人都知道：
「我跟上个班讲，他们好像不知道这个性质啊——我记得这个性质应该是高中就学的。」
:::

**这条结论的实际意义**：$\lambda_1$ 是实数，故 $\lambda_1^k$ 只会单调增长或正负交替，
不会出现复数旋转；后面的极限分析只需分 $\lambda_1\gt0$ 与 $\lambda_1\lt0$ 两种情形。

## 三、两个障碍与「单位化」的动机（14:00–19:30） {#lec07-S4}

回到第 1 节的两个问题。最直观的办法是**每算一步就把迭代向量拉回单位长度**：

> 「我不想让迭代向量在迭代过程中长得太快，最直观的办法就是——我每做一次（乘 $A$），
> 就给它**单位化**一次。」

单位化即除以自身的范数：$y=\dfrac{u}{\lVert u\rVert}$。**范数取哪一种都行**：

$$\Bigl\lVert\frac{u}{\lVert u\rVert}\Bigr\rVert
=\frac{1}{\lVert u\rVert}\,\lVert u\rVert=1
\qquad(\text{范数齐次性：}\lVert cu\rVert=|c|\,\lVert u\rVert,\ c\ \text{为实数}).$$

老师把这一步单独强调了一遍：分母 $\lVert u\rVert$ 是一个实数，可以按齐次性提到范数号外，
里外两个范数**是同一种范数**，相消即为 $1$。「我这么做，就是为了让它的长度是 1。
因为所有向量范数都是等价的，你这个长度是 1，其他范数下的长度也就是有界的、跑不出去。」

::: note 范数只在这里「随便取」
计算**特征向量**时，范数取哪种都行（第 4 节的极限与范数无关）；但计算**特征值**时
若使用不带分母的特征值估计式，须作 **2-范数**单位化——见第五节。老师把黑板分成两区来写：最上面那一片是「只求特征向量」，
下面那一片才是「求特征值」。
:::

## 四、规范化幂法：先单位化，再乘 $A$（19:30–29:00） {#lec07-S5}

**算法**（板书框出）：

$$\begin{cases}
u_0\ \text{任取（非零）}\\[2pt]
y_k=\dfrac{u_k}{\lVert u_k\rVert}\\[4pt]
u_{k+1}=A\,y_k
\end{cases}\qquad k=0,1,2,\dots$$

板书写作 $u_k=Ay_{k-1}$、$y_k=u_k/\lVert u_k\rVert$，并顺手列出头两步
$u_1=Ay_0,\ y_1=u_1/\lVert u_1\rVert$、$u_2=Ay_1,\ y_2=u_2/\lVert u_2\rVert$ 作示范——
与上式是同一个递推，只是下标起点不同。

**顺序是关键**：「你要记住是**先单位化**，单位化之后的那个东西我再给它乘 $A$，
而不是直接就往上乘 $A$。」直接累乘 $A$ 就是第 1 节那个会溢出的版本；本算法每乘一次
$A$ 就立刻把结果拉回单位长度，于是「它就不会长得太快」。

**收敛性推导**（板书：一步步倒推）。要看清 $y_k$ 的极限，先问：$y_k$ 是从哪来的？

- $y_k$ 是 $u_k$ 的单位化：$y_k=\dfrac{u_k}{\lVert u_k\rVert}$；
- 由算法，$u_k=A\,y_{k-1}$，故 $y_k=\dfrac{Ay_{k-1}}{\lVert Ay_{k-1}\rVert}$；
- 而 $y_{k-1}$ 又是 $u_{k-1}$ 的单位化，$u_{k-1}=Ay_{k-2}$……

一路回推到 $u_0$，中间那些 $\lVert\cdot\rVert$ 都是**常数**，可按齐次性提到范数号外并
逐次相消，最终只剩

$$y_k=\frac{A^ku_0}{\lVert A^ku_0\rVert}.$$

板书把这一串等式完整写成一列：

$$y_k=\frac{u_k}{\lVert u_k\rVert}=\frac{A^ku_0}{\lVert A^ku_0\rVert}
=\frac{\lambda_1^k\bigl[\alpha_1x_1+\sum_{i\ge2}\alpha_i(\lambda_i/\lambda_1)^kx_i\bigr]}
{|\lambda_1|^k\bigl\lVert\alpha_1x_1+\sum_{i\ge2}\alpha_i(\lambda_i/\lambda_1)^kx_i\bigr\rVert}
=\Bigl(\frac{\lambda_1}{|\lambda_1|}\Bigr)^{k}
\frac{\alpha_1x_1+\sum_{i\ge2}\alpha_i(\lambda_i/\lambda_1)^kx_i}
{\bigl\lVert\alpha_1x_1+\sum_{i\ge2}\alpha_i(\lambda_i/\lambda_1)^kx_i\bigr\rVert}.$$

（第二、三步把标量 $\lambda_1^k$ 按范数齐次性提到分母，得 $|\lambda_1|^k$。）
令 $k\to\infty$，括号中除第一项外全部趋零，于是

$$\boxed{\ y_k\ \longrightarrow\ \Bigl(\frac{\lambda_1}{|\lambda_1|}\Bigr)^{k}
\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ }$$

分两种情形：

| 情形 | $(\lambda_1/|\lambda_1|)^k$ | 极限 |
|:--|:--|:--|
| $\lambda_1\gt0$ | $1$ | $y_k\to\dfrac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}$，即 $x_1$ 的单位向量 |
| $\lambda_1\lt0$ | $(-1)^k$ | $y_k\to(-1)^k\dfrac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}$，**符号交替** |

$\lambda_1\lt0$ 时迭代值不断变号，「但说白了，它还是你的特征向量，只不过在迭代过程中
符号一直在变来变去」——不影响迭代值仍是 $x_1$ 的单位向量。

::: note 归一化的副产品
每步单位化还有一层「防溢出」之外的用处：**所有迭代值都被限制在单位球面上**，
数值范围完全可控，这是幂法能在有限精度下长期迭代的前提。
:::

## 五、特征值的计算：为什么必须取 2-范数（29:00–44:00） {#lec07-S6}

**特征向量已经到手，特征值怎么求？** 「你已经有了特征向量，那在这个特征向量上再
作用一个 $A$，特征值不就出来了」：

$$Ay_k\ \longrightarrow\ \lambda_1\cdot\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\qquad(\lambda_1\gt0).$$

但直接取 $Ay_k$ 与 $y_k$ 的对应分量之比会被 $(-1)^k$ 干扰，需要一个**对称的**组合。
取 **2-范数**，并注意 2-范数单位化保证 $\lVert y_k\rVert_2=1$，于是
$y_k^{\mathrm T}y_k=\lVert y_k\rVert_2^2=1$，计算

$$\frac{y_k^{\mathrm T}(Ay_k)}{y_k^{\mathrm T}y_k}=y_k^{\mathrm T}Ay_k .$$

**代入极限看它趋于什么**（以 $\lambda_1\gt0$ 为例）：

$$y_k\to\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert_2},\qquad
Ay_k\to\frac{\lambda_1\alpha_1x_1}{\lVert\alpha_1x_1\rVert_2},$$

$$\frac{y_k^{\mathrm T}(Ay_k)}{y_k^{\mathrm T}y_k}\ \longrightarrow\
\frac{\dfrac{\alpha_1^2\lambda_1\,x_1^{\mathrm T}x_1}{\lVert\alpha_1x_1\rVert_2^2}}
{\dfrac{\alpha_1^2\,x_1^{\mathrm T}x_1}{\lVert\alpha_1x_1\rVert_2^2}}=\lambda_1
\qquad\text{（分子分母都有 }x_1^{\mathrm T}x_1\text{，相消）}.$$

板书把两种情形并排写成一个大括号（左边先写 $\lVert\cdot\rVert=\lVert\cdot\rVert_2$ 作为前提）：

$$y_k^{\mathrm T}Ay_k\ \xrightarrow[\ k\to\infty\ ]{}\
\begin{cases}
\Bigl(\dfrac{\lambda_1\alpha_1x_1}{\lVert\alpha_1x_1\rVert_2}\Bigr)\cdot
\Bigl(\dfrac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert_2}\Bigr)
=\lambda_1\dfrac{\alpha_1^2x_1^{\mathrm T}x_1}{\lVert\alpha_1x_1\rVert_2^2}
=\lambda_1\dfrac{\alpha_1^2\lVert x_1\rVert_2^2}{\lVert\alpha_1x_1\rVert_2^2}=\lambda_1,
&\lambda_1\gt0\\[8pt]
(-1)^k\dfrac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert_2}\cdot(-1)^k
\dfrac{\lambda_1\alpha_1x_1}{\lVert\alpha_1x_1\rVert_2}
=\lambda_1\dfrac{\alpha_1^2x_1^{\mathrm T}x_1}{\lVert\alpha_1x_1\rVert_2^2}=\lambda_1,
&\lambda_1\lt0
\end{cases}$$

（第二支里两个 $(-1)^k$ 相乘即为 $1$，与第一支完全一样。）板书在这块区域的第三行
另写了「$\lVert\cdot\rVert=\lVert\cdot\rVert_\infty$」，提示范数换成 $\infty$-范数时
公式要另作调整——留给同学自己验算。

**为什么 $x_1^{\mathrm T}x_1$ 恰好是「长度的平方」**：三维例子最直观——设
$f_1=(x,y,z)$，则

$$f_1\cdot f_1=x^2+y^2+z^2,\qquad \lVert f_1\rVert_2^2=\Bigl(\sqrt{x^2+y^2+z^2}\Bigr)^2=x^2+y^2+z^2 .$$

两者是同一个数。一般地 $x_1^{\mathrm T}x_1=\lVert x_1\rVert_2^2$，于是上式分子分母完全相同。

$\lambda_1\lt0$ 时 $y_k$ 与 $Ay_k$ 各带一个 $(-1)^k$，点乘时**两次相消**，结果同样是
$\lambda_1$。于是

$$\boxed{\ \lim_{k\to\infty}y_k^{\mathrm T}Ay_k=\lambda_1\ }\qquad(\text{仅当范数取 2-范数}).$$

::: note 范数选择为什么在这里才起作用
计算特征向量时范数无所谓；一旦要算**特征值**，范数就进了公式。取 2-范数时
$y_k^{\mathrm T}y_k=1$，比值化简得干净；若取 $\infty$-范数，「你算出来的东西就
稍微有一点变化」——老师留给同学自己验算（板书：「取无穷范数这个情况大家可以
自己看一下」）。本教程在[2.5 节](../supplement/sec25.md)用 Rayleigh 商的语言重述了
这一条：$y_k^{\mathrm T}Ay_k$ 正是单位向量处的 **Rayleigh 商**。
:::

## 六、定理与计算方案（44:00–46:50；54:46–58:00） {#lec07-S7}

**计算方案（板书框出）**：

$$\textbf{算法（幂法）}\qquad
\begin{cases}
u_0\ \text{任取}\\
y_k=u_k/\lVert u_k\rVert &\text{范数任取}\\
u_{k+1}=Ay_k
\end{cases}$$

**定理**（板书总结，原文照录）：

$$\textbf{定理}\quad A\ \text{是实矩阵},\quad
|\lambda_1|\gt|\lambda_2|\ge\cdots\ge|\lambda_n|,\quad(\lambda_i\ \text{实});$$

则任取非零 $u_0=\sum_i\alpha_ix_i$（分解存在但**不必知道**），按上式迭代，有

$$(\mathrm i)\quad y_k\to\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ (\lambda_1\gt0),\qquad
y_k\to(-1)^k\frac{\alpha_1x_1}{\lVert\alpha_1x_1\rVert}\ (\lambda_1\lt0);$$

$$(\mathrm{ii})\quad \text{取 2-范数时}\quad y_k^{\mathrm T}Ay_k\to\lambda_1 .$$

「虽然 $u_0$ 是任取的、$\alpha_i$ 是任意的，但是不影响我最后得到的结论。」

**$\infty$-范数下的补充**（老师说算法要「稍微换一下」）：若改取 $\infty$-范数，
特征向量的极限不变（单位化只是把长度拉回 1，与范数种类无关），但特征值的提取公式
需相应改动——「如果你不用这个二范数，就改用这个……最后出来的就是你要的那个绝对
值最大的特征值」，细节留给同学自行验算。
下面把另外两种目标——「模最小」与「最接近已知值」——也化归到幂法。

## 七、反幂法：把「模最小」翻成「模最大」（58:00–1:07:00） {#lec07-S8}

**情况二**：$A$ 仍是实矩阵，但有一个特征值 $\lambda_1$ 的模**严格最小**：
$|\lambda_1|\lt|\lambda_i|\ (\forall i\ge2)$。怎么算？

**思路**：仍想用已经设计好的幂法——「其实我们只需要把刚刚那个东西稍微变形一下」。

关键观察：$|\lambda_1|$ 最小 $\Rightarrow\lambda_1\neq0\Rightarrow A$ **可逆**，而 $A^{-1}$
的特征值是

$$\frac{1}{\lambda_1},\ \frac{1}{\lambda_2},\ \dots,\ \frac{1}{\lambda_n}
\qquad(\text{全部取倒数}),$$

其中 $\Bigl|\dfrac{1}{\lambda_1}\Bigr|$ **最大**（因为 $|\lambda_1|$ 严格最小）。
板书按模从大到小排开：设 $|\lambda_n|\ge|\lambda_{n-1}|\ge\cdots\gt|\lambda_1|\gt0$，则

$$\Bigl|\frac{1}{\lambda_1}\Bigr|\gt\Bigl|\frac{1}{\lambda_2}\Bigr|\ge
\Bigl|\frac{1}{\lambda_3}\Bigr|\ge\cdots\ge\Bigl|\frac{1}{\lambda_n}\Bigr| .$$

验证特征向量确实不变：由 $Ax_1=\lambda_1x_1$ 两边乘 $\lambda_1^{-1}A^{-1}$，得
$\lambda_1^{-1}x_1=A^{-1}x_1$，即 $x_1$ 是 $A^{-1}$ 关于 $1/\lambda_1$ 的特征向量
（板书把这一行写成 $Ax_i=\lambda_ix_i\Rightarrow\lambda_i^{-1}x_i=A^{-1}x_i$）。

于是「这不就变回咱们刚刚那个问题了」——对 $A^{-1}$ 直接用幂法：

$$y_k=\frac{u_k}{\lVert u_k\rVert},\qquad u_k=A^{-1}y_{k-1}\quad(\text{板书记法}),$$

得到的「模最大特征值」是 $1/\lambda_1$，特征向量仍是 $x_1$（板书把极限写成
$y_k\to\dfrac{(1/\lambda_1)x_1}{\lVert x_1\rVert}$，并同样分 $1/\lambda_1\gt0$ 与
$1/\lambda_1\lt0$ 两支）。**要的是 $\lambda_1$，所以最后必须再取一次倒数逆回去**：

$$\boxed{\ \lambda_1=\frac{1}{\ \text{幂法算出的值}\ }\ }$$

::: note 实际计算里不构造 $A^{-1}$
「我们并不知道 $A$ 逆，我们只知道 $A$。」把 $u_k=A^{-1}y_{k-1}$ 改写成**解线性方程组**

$$A\,u_{k+1}=y_k,$$

每步解一次——「然后就采用我们以前讲的各种方法：不管是迭代法、LU 分解法还是高斯消去法」。
板书在算法大括号**下面又单独框出**了这个方程（框内即 $Au_{k+1}=y_k$），与算法框并列，
是这一节最要紧的一行。这正是[第 3、4 讲](lec04.md)那些直接法/迭代法的用武之地：
**反幂法每迭代一步，就解一个以 $A$ 为系数矩阵的线性方程组**。
:::

## 八、位移反幂法：求最接近已知 $p$ 的特征值（1:07:00–1:15:30） {#lec07-S9}

**情况三**（量子力学背景）：$A$ 是对称正定（自伴算子离散化）的实矩阵，特征值就是
可观测的能级，按大小排开 $\lambda_1\le\lambda_2\le\cdots\le\lambda_n$。想知道**第 $k$ 个**
能级 $\lambda_k$，但用解析/半解析方法（如渐近展开）只能得到**近似值** $p$，它满足

$$|\lambda_k-p|\lt|\lambda_i-p|\qquad(\forall i\neq k),$$

即 $p$ 离 $\lambda_k$ **最近**。「我虽然没办法把 $\lambda_k$ 真实地算出来，但是我可以
算出一个和它足够接近的特征根。」

**做法：位移（平移）**。板书把能级按大小排开、在目标那一个下面标上 $p$：

$$\lambda_1\le\lambda_2\le\lambda_3\le\cdots\le\underset{\uparrow\ p}{\lambda_k}\le\cdots\le\lambda_n,
\qquad|\lambda_k-p|\lt|\lambda_i-p|\quad(\forall i\neq k),$$

再记 $\tilde A=A-pI$，考察它的特征值

$$\lambda_1-p,\ \lambda_2-p,\ \dots,\ \lambda_k-p,\ \dots,\ \lambda_n-p .$$

由 $p$ 的选取，$|\lambda_k-p|$ **最小**——「是不是就转化为我来求一个最小的特征值？
把最小的特征值求出来，我再给它加个 $p$，就是我要的那个 $\lambda_k$。」

于是：对 $A-pI$ 用**反幂法**求出最小的 $\lambda_k-p$ 及其特征向量 $x_k$，再加回 $p$：

$$\boxed{\ \lambda_k=(\lambda_k-p)+p\ }$$

老师把这一步命名为**位移法**：「我把它移动一下，移动成一个新的矩阵，这个矩阵的
（目标）特征值就是我所有特征值里绝对值最小的，然后我再用刚刚的算法把它解出来，
解出来之后再把 $p$ 加进去，就是我要的。」

**三种情况的统一**（板书收束）：

| 目标 | 手段 | 关键变换 |
|:--|:--|:--|
| 模最大的特征值 | **幂法** | 直接用 $A$ |
| 模最小的特征值 | **反幂法** | $A\mapsto A^{-1}$（实际每步解 $Au_{k+1}=y_k$） |
| 最接近已知 $p$ 的特征值 | **位移反幂法** | $A\mapsto A-pI$，再用反幂法，最后 $+p$ |

「说白了就是：第一种你学会之后，后边这个东西你可以转化成第一种就 OK 了——
想办法给它转变成第一种。」

## 九、非线性方程：不动点形式与二分法（1:16:00–1:26:30） {#lec07-S10}

线性方程组部分到此告一段落，下半场转入**非线性方程（组）**。

**问题的形式**：求 $f(x)=0$ 的根。为了套用迭代，常把方程改写成**等价的不动点形式**。
板书在右板另起一块、标题写作「**非线性方程（组）迭代算法**」，内容是一串等价变形：

$$\begin{cases}
f(x)=0\ \Longleftrightarrow\ x=\varphi(x)\\
x=x+f(x)\\
\phantom{x}=\varphi(x)
\end{cases}$$

即变形**不唯一**，视具体函数而定；最省事的构造是两边同时加 $x$：

$$f(x)=0\ \Longleftrightarrow\ x+f(x)=x\ \Longrightarrow\ \varphi(x)=x+f(x).$$

「我举这个例子是想告诉大家，$f(x)=0$ 与 $x=\varphi(x)$ 这两个东西确实可以互相
转化。」框架与线性方程组的迭代法**完全同构**：给初值 $x_0$，反复代入——板书写作
$x_1=\varphi(x_0)$、$x_2=\varphi(x_1)$、……、$x_k=\varphi(x_{k-1})$；若 $x_k\to x^*$，
对迭代式两边取极限得

$$x^*=\varphi(x^*),$$

即 $x^*$ 是 $\varphi$ 的**不动点**，也就是原方程的根。

**二分法**（古典的解析与迭代方法，先复习）。板书在左板画出函数图像并写下：

$$f(x)\ \text{连续},\quad f(a)f(b)\lt0\ \Longrightarrow\ \exists\,\xi\in[a,b]:\ f(\xi)=0,$$

- **折半**：取中点 $c=\dfrac{a+b}{2}$，比较符号（板书分两支写出）
  - $f(a)f(c)\lt0$ $\Rightarrow$ $\xi\in[a,c]$，取 $[a_1,b_1]=[a,c]$；
  - $f(c)f(b)\lt0$ $\Rightarrow$ $\xi\in[c,b]$，取 $[a_1,b_1]=[c,b]$；
- 对新区间重复折半，得 $[a_0,b_0]\supset[a_1,b_1]\supset[a_2,b_2]\supset\cdots$，
  每步区间长度减半（板书末行：$\xi\in[a_n,b_n]$，「逐次二分」）：

$$|[a_n,b_n]|=\frac{b-a}{2^n}\lt\varepsilon .$$

根始终被夹在其中，故**误差随区间长度一起变小**——「只要你这个区间长度缩得足够小，
$\xi$ 落在里面，它的误差也会足够小」。

## 十、不动点迭代的收敛定理与存在性证明（1:26:30–1:37:00） {#lec07-S11}

**定理**（板书）：设 $\varphi$ 在 $[a,b]$ 上连续可导，且满足两条

$$(\mathrm i)\quad\varphi([a,b])\subseteq[a,b]\qquad(\text{自映射：把区间映到自身}),$$
$$(\mathrm{ii})\quad|\varphi'(x)|\le L\lt1,\quad x\in[a,b]\qquad(\text{压缩}),$$

则对任意初值 $x_0\in[a,b]$，迭代 $x_{k+1}=\varphi(x_k)$ 收敛到 $[a,b]$ 内的**唯一**不动点。
板书把结论写成一条链：

$$\begin{cases}x_{k+1}=\varphi(x_k)\\ x_0\in[a,b]\end{cases}
\ \Longrightarrow\ x_k\ \xrightarrow[\ k\to\infty\ ]{}\ x^{*} .$$

**第一条（自映射）的作用**——保证迭代值不跑出区间（本讲解释）：

$$x_0\in[a,b]\ \Rightarrow\ x_1=\varphi(x_0)\in[a,b]\ \Rightarrow\
x_2=\varphi(x_1)\in[a,b]\ \Rightarrow\ \cdots$$

「在我这个计算过程中，那些 $x_k$ 一直是在 $[a,b]$ 区间里，它跳不出这个框去。」
第二条（压缩）的作用是把误差逐次缩小，留到下一讲展开。

**不动点存在性的证明**（本讲完成）。构造辅助函数

$$F(x)=x-\varphi(x).$$

板书一口气把这条链写成（$F$ 与 $\varphi$ 的记号左右并列）：

$$F(a)=a-\varphi(a)\le0,\qquad F(b)=b-\varphi(b)\ge0
\ \Longrightarrow\ \exists\,\xi\in[a,b]:\ F(\xi)=0
\ \Longrightarrow\ \xi=\varphi(\xi).$$

逐步说清：

- **左端点**：$\varphi$ 把 $[a,b]$ 映到自身 $\Rightarrow\varphi(a)\in[a,b]
  \Rightarrow\varphi(a)\ge a$，故 $F(a)=a-\varphi(a)\le0$；
- **右端点**：同理 $\varphi(b)\in[a,b]\Rightarrow\varphi(b)\le b$，故
  $F(b)=b-\varphi(b)\ge0$；
- $F$ 连续（$\varphi$ 连续可导），一端 $\le0$、一端 $\ge0$，由**介值定理**存在
  $\xi\in[a,b]$ 使

$$F(\xi)=0\ \Longleftrightarrow\ \xi-\varphi(\xi)=0\ \Longleftrightarrow\ \xi=\varphi(\xi).$$

即不动点存在。$\blacksquare$

::: preview 下一讲起点
老师当堂只证了**存在性**，收尾一句「咱们下次再去试试看」——**唯一性**（需第二条）
与压缩条件下的收敛速度、收敛阶，留到下一讲；随后才进入 Newton 法等具体格式。
:::

## 十一、记号与考注（本讲特有） {#lec07-S12}

1. **板书分区**：本讲黑板上半区写「只求特征向量」的算法与极限，下半区写「求特征值」
   的公式与定理——同一块板两套范数要求，读板书时不要串。
2. **范数记号**：板书把 2-范数写作 $\lVert\cdot\rVert_2$、$\infty$-范数写作
   $\lVert\cdot\rVert_\infty$；课堂口述常简称「二范数」「无穷范数」。本编保留板书记号。
3. **「位移」的课堂叫法**：老师把 $A-pI$ 这一步称为**位移法**（转写作「贵宜法」，
   音近致误），标准术语为**原点位移 / 位移反幂法**（shifted inverse iteration）。
4. **原书编号**：本讲两个定理（幂法收敛定理、不动点迭代收敛定理）课堂均**未念编号**，
   本编不注编号，以内容对照原书第 3 章、第 4 章。原书第 3 章为特征值计算、第 4 章为
   非线性方程，与本书第 6、7 章对应（[路线图](../ch01/sec11.md#roadmap)）。
5. **「特征向量互异」的用法**：课堂把「$\lambda_i$ 互异 $\Rightarrow x_i$ 线性无关」
   当作已知事实直接使用（这是标准结论：不同特征值的特征向量线性无关），未证。
6. **反幂法解方程组的代价**：课堂只说「用 LU 分解或迭代法解 $Au_{k+1}=y_k$」，
   未讨论 $A$ 的分解可**预先算一次**并复用（这是反幂法实用化的关键），亦未提
   $A-pI$ 病态时的精度问题。
7. **转录空白**：00:47–00:52 为课间休息（转写多为环境噪声），据上下文此段无板书。
8. **板书核对**：本页公式全部对照板书关键帧（1920×1080 教师摄像头画面）逐条核对，
   主要参照时刻：① 01:53–08:16 展开式；② 08:16–14:00 实数性证明；③ 19:30–29:00
   算法框与 $y_k$ 的极限；④ 36:00–44:00 的 $\lVert\cdot\rVert=\lVert\cdot\rVert_2$
   与 $\infty$-范数两行；⑤ 55:00–58:00 定理；⑥ 58:00–1:07:00 反幂法（含单独框出的
   $Au_{k+1}=y_k$）；⑦ 1:07:00–1:15:30 位移；⑧ 1:16:00–1:37:00 二分法与不动点定理。
9. **板书上的一处「第三行」**：特征值计算那一片板，最上面一行是
   $\lVert\cdot\rVert=\lVert\cdot\rVert_2$、最下面另起一行写
   $\lVert\cdot\rVert=\lVert\cdot\rVert_\infty$——**两行是两种范数的对照**，
   不是同一推导的两步，抄板书时容易连成一行。

## 十二、老师强调 {#lec07-S13}

- **本讲记号先单位化再乘**：先单位化、再乘 $A$。直接累乘 $A$ 会溢出，也压不住其他分量。
- 计算**特征向量**时范数随便取；省略 Rayleigh 分母时**须作 2-范数单位化**——
  「这黑板最上面的东西我只是计算特征向量……但我在计算特征值的时候，就取一个限定的二范数。」
- **三个问题一个算法**：模最大（幂法）→ 模最小（$A^{-1}$）→ 最接近 $p$（$A-pI$），
  后两个都化归到第一个。
- 反幂法的实战写法：**不构造 $A^{-1}$**，每步解 $Au_{k+1}=y_k$——直接法与迭代法在这里汇合。
- 位移的动机来自物理：能级 = 特征值，半解析方法先给一个足够近的 $p$，
  再用位移反幂法把目标特征值「精修」到机器精度。
- 非线性方程部分：$f(x)=0\iff x=\varphi(x)$ 的变形**不唯一**；二分法是「古典方法」，
  保证收敛但收敛慢；迭代法的收敛性由**自映射 + 压缩**两条保证。
- 方法论闲谈（课间后）：本国教材为篇幅与严谨性「跳细节」，国外教材把每一步都展开
  「所以写得那么厚」——**证明的细节不是人人都必须掌握**，「你只需要知道这些东西
  都是有道理的、来源都是有根据的」；但公式必须亲手推、结论必须记得住。

## 十三、课堂口述与标准术语对照（节选） {#lec07-S14}

| 老师口述/转写 | 标准术语 |
|---|---|
| 秘法 / 密法 / 迷法 | 幂法（power method） |
| 反秘法 | 反幂法（inverse power method） |
| 贵宜法 / 被激动 | 位移法（原点位移，shift） |
| 幽灵 / u0 | 初始向量 $u_0$ |
| 外退 / 外配 / 外移 / YP / 外 k | $y_k$ |
| UK / 又可以加一 | $u_k$ / $u_{k+1}$ |
| 2.1 / 二块一 / 二万一 / 二法1 | $\alpha_1$ |
| 蓝白衣 / 郎大一 / 拉姆达 / 拦一 / 雷达马 | $\lambda_1$ / $\lambda_k$ |
| 4 / 2-1 / 2-2 / 三大 N | $\lambda_1$ / $\lambda_2$ / $\lambda_n$ |
| S1 / X1 / F1 / 特征项链 / 特征项目 / 特征效量 | $x_1$ / 特征向量 |
| 十数 / 时数 / 十指针 / 实体占 / 十几卷 / 实举证 | 实数 / 实矩阵 |
| 功课 / 公额 / 共和 / 公论 / 共恶 / 公乐 | 共轭 |
| 特征象式 / 特征多大式 / 特征方式 | 特征多项式 |
| 单位化 / 单元化 / 单类化 / 单律化 | 单位化（规范化） |
| 二半数 / 二范图 / 二败负 / 二方式 | 2-范数 |
| 无穷半数 / 五行范围 / 无穷范图 | $\infty$-范数 |
| 半数 / 万数 / 范畴 / 翻数 | 范数 |
| 大幽灵 / 小幽灵 | 大于零 / 小于零 |
| 借着定理 / 解释定理 | 介值定理 |
| 二分导 / 二分套 / 二能打 | 二分法 |
| 可塞 / 可费 / 可思议 | $\xi$（根） |
| 范 x / Five / 5f | $\varphi(x)$ |
| 运行到 / 硬回到 | 映到（映射） |
| 韩国 / 连续合导 | 函数 / 连续可导 |
| 小移的上限 / 阳根的 | 小于 1 的上界 / 有界的 |
| 叠代 / 结带 / 节带 | 迭代 |
| 收链 | 收敛 |
| 本质生态 | 本征态 |
| 渐渐展开 | 渐近展开 |
