# 习题集

三组分层：A 组概念判断（快速自检）、B 组推理证明（考试大题）、C 组计算（动手实操）。**全部附解答**；建议先独立完成再展开对照。所有题目只使用本课程的概念与先修线性代数知识。

## 怎么用这份习题集

**做题的节奏比做题的数量重要。**推荐的循环是：

1. 先读题，**不看解答也不看提示**，给自己 2–3 分钟找思路；
2. 卡住了，点开「提示」拿一句方向，**再自己往下推**；
3. 推完（或确实推不动）才点开「解答」对照，重点看自己的思路在哪一步偏了；
4. 做错的题在旁边记一个记号，三天后回来**只重做做过记号的题**。

| 组 | 定位 | 建议时长 | 卡壳时怎么办 |
|:--|:--|:--|:--|
| **A 组**（16 题） | 概念判断，口答即可 | 每题 1–2 分钟 | 直接看解答，回到对应小节的「即时自测」重读 |
| **B 组**（14 题） | 推理证明，需完整写出 | 每题 8–12 分钟 | 先看提示，再用 10 分钟；仍无思路才展开解答 |
| **C 组**（17 题） | 计算实操，注意验算 | 每题 5–8 分钟 | 看提示定位方法，算完**一定代回验证** |

::: note 关于「提示」层

B1、B8、B11、B12、B13、C5、C6、C7、C16 这几题提供了折叠的「提示」——它只给**从哪里下手**，不给完整过程。先看提示、自己推完，再对照解答，学习效果远好于直接读解答。
:::

## 按正文进度练：每节最小练习包

不必等全章读完才来刷题。每读完一节，先做下表的「最低闭环」；做对且能解释，再选拓展题。这样可以把错误留在刚学完的局部，而不是到章末才发现整条概念链已经断了。

| 读完 | 最低闭环（先做） | 想加深再做 | 重点检查 |
|:--:|:--|:--|:--|
| **1.1** | A1、B2 | B1、C7 | 数域、八条公理、反例意识 |
| **1.2** | A6、B3、C1 | A2、A3、A7、A8、B4、C8 | 零向量、线性组合封闭、$N(A)$ / $R(A)$ |
| **1.3** | A10、B6、C5、C6 | A4、A5、A9、B5、B8、C2–C4 | 无关与张成、坐标方向、维数公式 |
| **1.4** | A11、B10、C10 | A12、A13、B9、C9、C11 | 共轭、正定、Gram 下标 |
| **1.5** | A15、B12、C13 | C12 | 实/复边界、正交残差、单位化 |
| **1.6** | A14、A16、B11、C14 | B7、B13、B14、C15、C16、C17 | 交为零、分解唯一、投影依赖补空间；正交基公式的适用条件 |

**做完的标准不是答案相同。**概念题要能给反例，证明题要能指出每一步依据，计算题要完成代回或维数核对。三者缺一，说明「会算」还没有变成「会用」。

## A 组 · 概念判断

::: ex A1 · 数域判断

下列数集是否为数域？(a) $\mathbb{Z}$；(b) $\mathbb{Q}(\sqrt3)=\{a+b\sqrt3\mid a,b\in\mathbb{Q}\}$；(c) $\mathbb{R}^+\cup\{0\}$（非负实数）。

::: sol 解答

(a) 不是：$1\div2\notin\mathbb{Z}$，商不封闭。(b) 是：验证方式与 $\mathbb{Q}(\sqrt2)$ 完全相同（和差积逐条；商用 $(a+b\sqrt3)(a-b\sqrt3)=a^2-3b^2\neq0$，因为 $(a/b)^2=3$ 与 $\sqrt3$ 无理矛盾）。(c) 不是：$1-2=-1\lt0$，差不封闭。

:::

:::

::: ex A2 · 封闭性的充分性

命题：「若 $V$ 的非空子集 $W$ 对加法封闭，则 $W$ 是 $V$ 的子空间。」对吗？

::: sol 解答

不对。数乘也须封闭。反例：$W=\{(a_1,a_2)^{\mathrm T}\mid a_1\geq0\}\subset\mathbb{R}^2$ 对加法封闭，但 $(-1)\cdot(1,0)^{\mathrm T}=(-1,0)^{\mathrm T}\notin W$。判定[@thm-1.2.1] 的条件 (2)a 与 (2)b 缺一不可。

:::

:::

::: ex A3 · 直线子空间

$W=\{(x,\,2x)^{\mathrm T}\mid x\in\mathbb{R}\}$ 是 $\mathbb{R}^2$ 的子空间吗？给出它的一组基与维数。

::: sol 解答

是：$(x,2x)^{\mathrm T}+(y,2y)^{\mathrm T}=(x+y,\,2(x+y))^{\mathrm T}\in W$；$k(x,2x)^{\mathrm T}=(kx,\,2kx)^{\mathrm T}\in W$；含零元。它是过原点直线 $y=2x$。基：$\{(1,2)^{\mathrm T}\}$，$\dim W=1$。（对照[@ex-1.2.D]：$W=N((-2,\ 1))$，即 $1\times2$ 矩阵 $(-2\ 1)$ 的零空间。）

:::

:::

::: ex A4 · 平面与直线

$\mathbb{R}^3$ 中 $W_1=xOy$ 平面，$W_2=z$ 轴。求 $W_1\cap W_2$、$W_1+W_2$，并验证维数公式。

::: sol 解答

$W_1\cap W_2=\{\boldsymbol{\theta}\}$（平面与垂线只交于原点），$\dim=0$；$W_1+W_2=\mathbb{R}^3$（$(a,b,c)=(a,b,0)+(0,0,c)$），$\dim=3$。公式：$3=2+1-0$ ✓。

:::

:::

::: ex A5 · 单向量组

单向量组 $\{\boldsymbol{\alpha}\}$（$\boldsymbol{\alpha}\neq\boldsymbol{\theta}$）线性相关还是无关？$\{\boldsymbol{\theta}\}$ 呢？两个向量的向量组何时相关？

::: sol 解答

$\{\boldsymbol{\alpha}\}$（$\boldsymbol{\alpha}\neq\boldsymbol{\theta}$）无关：$k\boldsymbol{\alpha}=\boldsymbol{\theta}$ 由 [1.1](sec11.md) 注 1(4) 得 $k=0$。$\{\boldsymbol{\theta}\}$ 相关（$1\cdot\boldsymbol{\theta}=\boldsymbol{\theta}$ 非平凡）。两个向量 $\boldsymbol{\alpha},\boldsymbol{\beta}$ 相关 $\Longleftrightarrow$ 其中一个可由另一个表示 $\Longleftrightarrow$ 二者成比例（或其一为零向量）。

:::

:::

::: ex A6 · 不过原点的直线

$W=\{(1,2,3)^{\mathrm T}+t(1,1,1)^{\mathrm T}\mid t\in\mathbb{R}\}$（一条不过原点的直线）是 $\mathbb{R}^3$ 的子空间吗？$\{(t,t,t)^{\mathrm T}\mid t\in\mathbb{R}\}$ 呢？

::: sol 解答

第一个不是：$\boldsymbol{\theta}$ 不在直线上（要求 $1+t=0,\ 2+t=0$ 同时成立，不可能）；等价地，它是非齐次方程组的解集形。第二个是：过原点直线，封闭且含零元，基 $\{(1,1,1)^{\mathrm T}\}$，$\dim=1$。

:::

:::

::: ex A7 · span 的极端情形

$\operatorname{span}(\boldsymbol{\theta})=?$ $\operatorname{span}(\boldsymbol{\alpha})$（$\boldsymbol{\alpha}\neq\boldsymbol{\theta}$）= ? 维数各是多少？

::: sol 解答

$\operatorname{span}(\boldsymbol{\theta})=\{k\boldsymbol{\theta}\}=\{\boldsymbol{\theta}\}$，维数 0；$\operatorname{span}(\boldsymbol{\alpha})=\{k\boldsymbol{\alpha}\mid k\in F\}$（一条「直线」），由 A5 的无关性，$\{\boldsymbol{\alpha}\}$ 是基，维数 1。

:::

:::

::: ex A8 · 非齐次解集

设 $A\boldsymbol{x}=\boldsymbol{b}$（$\boldsymbol{b}\neq\boldsymbol{\theta}$）有解，其解集 $S_b$ 是子空间吗？为什么？

::: sol 解答

不是。$\boldsymbol{\theta}\in S_b$ 将意味着 $A\boldsymbol{\theta}=\boldsymbol{b}\neq\boldsymbol{\theta}$，矛盾——零向量必不在解集中（子空间第一否决项）。另外：若 $\boldsymbol{x}_1,\boldsymbol{x}_2$ 都是解，$A(\boldsymbol{x}_1+\boldsymbol{x}_2)=2\boldsymbol{b}\neq\boldsymbol{b}$，加法也不封闭。对照[@ex-1.2.1]：右端为零时解集才是子空间。

:::

:::

::: ex A9 · 矩阵空间的维数（数域！）

$\dim_{\mathbb{C}}\mathbb{C}^{2\times3}=?$ 把 $\mathbb{C}^{2\times3}$ 视为 $\mathbb{R}$ 上的线性空间，维数又是多少？

::: sol 解答

在 $\mathbb{C}$ 上：基 $E_{11},E_{12},E_{13},E_{21},E_{22},E_{23}$，$\dim=6$。在 $\mathbb{R}$ 上：复系数 $c=a+bi$ 拆成实虚部，基为 $\{E_{ij},\ iE_{ij}\}$，$\dim=12$。**同一集合，数域不同维数翻倍**（与[@ex-1.3.5] 的 $\mathbb{C}$ 同理：$\dim_{\mathbb{R}}\mathbb{C}^{n}=2n$）。

:::

:::

::: ex A10 · 坐标与基

命题：「基不同，同一向量的坐标必定不同。」对吗？

::: sol 解答

不对。反例：零向量 $\boldsymbol{\theta}$ 在**任何**基下坐标都是 $(0,\cdots,0)^{\mathrm T}$。一般向量换基后坐标「通常会变」，但「必定变」是过强命题：例如 $\mathbb{R}^2$ 中取基 $\{e_1,e_2\}$ 与 $\{e_1,e_1+e_2\}$，向量 $e_1$ 在两组基下的坐标都是 $(1,0)^{\mathrm T}$。

:::

:::

::: ex A11 · 复空间里为什么不能只用转置

在 $\mathbb C^n$ 上令 $(\boldsymbol x,\boldsymbol y)=\boldsymbol y^{\mathrm T}\boldsymbol x$。它是内积吗？只需给出一个最短反例。

::: sol 解答

不是。取 $n=1$、$\boldsymbol x=(i)$，则 $(\boldsymbol x,\boldsymbol x)=i^2=-1<0$，违反正定性。复内积需要共轭转置：标准形式是 $\boldsymbol y^{\mathrm H}\boldsymbol x$。

:::

:::

::: ex A12 · 半正定够不够

若 Hermite 矩阵 $A\succeq0$ 但不正定，$\boldsymbol y^{\mathrm H}A\boldsymbol x$ 能否定义内积？

::: sol 解答

不能。半正定但不正定意味着存在非零 $\boldsymbol x$ 使 $\boldsymbol x^{\mathrm H}A\boldsymbol x=0$，于是 $(\boldsymbol x,\boldsymbol x)=0$ 却有 $\boldsymbol x\neq\boldsymbol0$，违反正定性的「等号仅在零向量处成立」。它至多定义半内积。

:::

:::

::: ex A13 · 「一一对应」缺了什么

判断：「一个内积唯一对应一个度量矩阵。」这句话是否完整？

::: sol 解答

不完整，必须补上「**固定一组有序基后**」。换基会把同一个内积的矩阵表示变成 $C^{\mathrm H}GC$，所以内积没有脱离基的唯一矩阵；固定基后，内积与正定 Hermite 矩阵才一一对应。

:::

:::

::: ex A14 · 直和的判据

设 $W_1,W_2$ 是 $V$ 的子空间。判断下列说法的真假：(a)「$W_1+W_2$ 是直和」等价于「$W_1\cap W_2=\{\boldsymbol{\theta}\}$」；(b) 若 $\dim(W_1+W_2)=\dim W_1+\dim W_2$，则 $W_1+W_2$ 是直和；(c) 若和空间中**存在**一个向量表法唯一，则 $W_1+W_2$ 是直和。

::: sol 解答

(a) **真**，这正是 [@thm-1.6.1] 的 (1) ⟺ (3)。(b) **真**，(1) ⟺ (4)。

**(c) 真——这一条与前两条不同，不能拿「定义写的是『任意』」去否定它。** 定义确实要求「任意向量表法唯一」，但**只要有一个**就够了，因为不唯一性在直和里是**可以平移**的。反设和不是直和，则存在零元素的非平凡表法

$$\boldsymbol{\theta}=\boldsymbol{w}_1+\boldsymbol{w}_2,\qquad \boldsymbol{w}_1\in W_1,\ \boldsymbol{w}_2\in W_2,\ \text{两者不全为零}.$$

把它叠加到**任意**一个拆法 $\boldsymbol{v}=\boldsymbol{v}_1+\boldsymbol{v}_2$ 上，得第二个拆法

$$\boldsymbol{v}=(\boldsymbol{v}_1+\boldsymbol{w}_1)+(\boldsymbol{v}_2+\boldsymbol{w}_2),$$

且它与原拆法不同（相同则 $\boldsymbol{w}_1=\boldsymbol{w}_2=\boldsymbol{\theta}$，与「非平凡」矛盾）。于是「有一个向量表法唯一」与「不是直和」不能共存：**存在唯一 ⟹ 每个都唯一 ⟹ 直和**。

**顺带纠正一个常见误判。** [@ex-1.6.1] 常被当成 (c) 的反例（"$xoy$ 与 $yoz$ 平面的和中 $(1,0,0)$ 表法唯一"），但那里 $(1,0,0)$ **同样**有多种表法：

$$(1,0,0)^{\mathrm T}=(1,\mu,0)^{\mathrm T}+(0,-\mu,0)^{\mathrm T}\qquad(\forall\,\mu\in\mathbb R),$$

正与上面的平移论证一致——非直和中一个"漏网"的向量都不会有。

:::

:::

::: ex A15 · 长度、夹角与复空间

判断：(a) 复向量 $\boldsymbol{x}=(1,i)^{\mathrm T}\in\mathbb{C}^2$ 的长度是 $\sqrt{1^2+i^2}=0$；(b) Cauchy–Schwarz 不等式中 $|(\boldsymbol{x},\boldsymbol{y})|\leq\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 的等号当且仅当 $\boldsymbol{x},\boldsymbol{y}$ 线性相关；(c) 在复内积空间中「$\boldsymbol{x}\perp\boldsymbol{y}$」可以用 $\arccos\frac{(\boldsymbol{x},\boldsymbol{y})}{\|\boldsymbol{x}\|\|\boldsymbol{y}\|}=\frac{\pi}{2}$ 来验证。

::: sol 解答

(a) **假**。复空间的长度必须逐分量取**模平方**：$\|\boldsymbol{x}\|=\sqrt{|1|^2+|i|^2}=\sqrt2$。用 $x_i^2$ 求和会把非零向量算成长度为零。
(b) **真**，注意等号作用在**模**上（[@thm-1.5.1]）。不带模的 $(\boldsymbol{x},\boldsymbol{y})=\|\boldsymbol{x}\|\,\|\boldsymbol{y}\|$ 只在「正相关」时成立（$\boldsymbol{y}=k\boldsymbol{x}$，$k\gt0$）。
(c) **假**。复空间中 $(\boldsymbol{x},\boldsymbol{y})$ 一般是复数，$\arccos$ 无定义；正交应直接用 $(\boldsymbol{x},\boldsymbol{y})=0$ 判定（详见勘误 E6）。

:::

:::

::: ex A16 · 正交子空间与正交投影的概念判断

判断真假，并给出一句话理由或反例：

(a) 若平面 $W_1$ 与 $W_2$ 在几何上互相垂直（如墙角的两面），则 $W_1\perp W_2$；
(b) 若 $V=W_1\oplus W_2$ 是正交直和分解，则 $W_2$ 必为 $W_1^{\perp}$；
(c) 对子空间 $W$ 的**任意**基 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k$，都有 $\operatorname{Proj}_{W}\boldsymbol{y}=\sum_i\frac{(\boldsymbol{y},\boldsymbol{x}_i)}{(\boldsymbol{x}_i,\boldsymbol{x}_i)}\boldsymbol{x}_i$；
(d) 对任意 $A\in\mathbb C^{n\times n}$，$N(A)\cap R(A^{\mathrm H})=\{\boldsymbol{\theta}\}$。

::: sol 解答

(a) **假**。墙角反例（[@ex-1.6.5]）：两平面的交线 $W_3$ 是非零公共向量，取交线上非零 $\boldsymbol u$ 有 $(\boldsymbol u,\boldsymbol u)\neq0$，与「正交 ⟹ 交为零」（[@thm-1.6.2]）矛盾。几何「垂直」是逐方向的，子空间正交是每一个对每一个。

(b) **真**。$W_2\subseteq W_1^{\perp}$（正交直和的定义），且 $\dim W_2=n-\dim W_1=\dim W_1^{\perp}$（判据 (4) 用两次），包含 + 等维即相等（[1.6.6](sec16.md#sec-1.6.6) 末注）。

(c) **假**。公式只对**正交基**成立（[@prop-1.6.1]，勘误 E12）。反例：$W=\mathbb R^2$，基 $\boldsymbol{x}_1=(1,0)^{\mathrm T}$、$\boldsymbol{x}_2=(1,1)^{\mathrm T}$（内积为 $1\neq0$），取 $\boldsymbol{y}=(1,0)^{\mathrm T}$：公式给出 $1\cdot\boldsymbol{x}_1+\tfrac12\boldsymbol{x}_2=(\tfrac32,\tfrac12)^{\mathrm T}\neq\boldsymbol{y}$，而全空间上的投影应得 $\boldsymbol{y}$ 本身。

(d) **真**。[@ex-1.6.7] 第一步：$R(A^{\mathrm H})\perp N(A)$，正交的两子空间只能交于零。

:::

:::

## B 组 · 推理证明

::: ex B1 · 一个不是数域的集合

证明 $\{a+b\sqrt[3]{2}\mid a,b\in\mathbb{Q}\}$ 对乘法不封闭，因而不是数域。（提示：证明 $\sqrt[3]{4}$ 不能写成 $a+b\sqrt[3]{2}$。）

::: hint 提示

把 $\sqrt[3]{4}$ 记作 $t^2$（其中 $t=\sqrt[3]{2}$）。反设 $t^2=a+bt$，就得到一个「$t$ 满足二次方程」的结论。接下来用 $t^3=2$ 把 $t^3$ 也算成 $a+bt$ 的形式，两式对比即可导出 $t$ 是有理数——矛盾。

关键是**利用 $t^3=2$ 做降次**：任何 $t$ 的高次幂都可以用 $t^2=a+bt$ 反复替换成 $p+qt$ 的形式。
:::

::: sol 解答

取两个元素 $0+1\cdot\sqrt[3]2$ 与 $0+1\cdot\sqrt[3]2$，其积为 $\sqrt[3]4$。反设 $\sqrt[3]4=a+b\sqrt[3]2$（$a,b\in\mathbb{Q}$）。记 $t=\sqrt[3]2$，则 $t^2=a+bt$，即 $t$ 满足有理系数二次方程 $x^2-bx-a=0$。两边再乘 $t$ 并用 $t^2=a+bt$：

$$2=t^3=t\cdot t^2=t(a+bt)=at+bt^2=at+b(a+bt)=ab+(a+b^2)t.$$

于是 $(ab-2)+(a+b^2)t=0$。若 $a+b^2\neq0$，则 $t=(2-ab)/(a+b^2)\in\mathbb{Q}$，但 $t^3=2$ 而任何有理数的立方是有理数，且 $2$ 的立方根是无理数（有理根检验），矛盾。若 $a+b^2=0$，则须 $ab=2$：由 $a=-b^2$ 得 $-b^3=2$，$b$ 是 $x^3+2=0$ 的有理根，只能 $b\in\{\pm1,\pm2\}$（有理根定理），逐一验证都不是根，矛盾。故 $\sqrt[3]4\notin$ 该集合，乘法不封闭。

:::

:::

::: ex B2 · 八条公理的推论

设 $V$ 是 $F$ 上的线性空间，$\boldsymbol{\alpha}\neq\boldsymbol{\theta}$。证明：对任意 $k\in F$，$k\boldsymbol{\alpha}=\boldsymbol{\theta}\Longleftrightarrow k=0$。（注 1(4) 的「非零向量版」。）

::: sol 解答

「$\Longleftarrow$」即 $0\boldsymbol{\alpha}=\boldsymbol{\theta}$（注 1(3)，已证）。「$\Longrightarrow$」若 $k\neq0$，则 $\boldsymbol{\alpha}=1\boldsymbol{\alpha}=(k^{-1}k)\boldsymbol{\alpha}=k^{-1}(k\boldsymbol{\alpha})=k^{-1}\boldsymbol{\theta}=\boldsymbol{\theta}$，与 $\boldsymbol{\alpha}\neq\boldsymbol{\theta}$ 矛盾。故 $k=0$。

:::

:::

::: ex B3 · 并集何时是子空间

证明：$W_1\cup W_2$ 是 $V$ 的子空间 $\Longleftrightarrow$ $W_1\subseteq W_2$ 或 $W_2\subseteq W_1$。

::: sol 解答

「$\Longleftarrow$」若 $W_1\subseteq W_2$，则 $W_1\cup W_2=W_2$ 是子空间；另一侧同理。<br> 「$\Longrightarrow$」反设互不包含：取 $\boldsymbol{\alpha}\in W_1\setminus W_2$ 与 $\boldsymbol{\beta}\in W_2\setminus W_1$。由假设，$\boldsymbol{\gamma}=\boldsymbol{\alpha}+\boldsymbol{\beta}\in W_1\cup W_2$。若 $\boldsymbol{\gamma}\in W_1$，则 $\boldsymbol{\beta}=\boldsymbol{\gamma}-\boldsymbol{\alpha}\in W_1$（子空间对减法封闭），矛盾；若 $\boldsymbol{\gamma}\in W_2$，则 $\boldsymbol{\alpha}=\boldsymbol{\gamma}-\boldsymbol{\beta}\in W_2$，矛盾。故必有一个包含关系成立。

:::

:::

::: ex B4 · 零空间与列空间的包含关系

设 $A\in\mathbb{C}^{m\times n},\ B\in\mathbb{C}^{n\times p}$ 且 $AB=O$。证明 $R(B)\subseteq N(A)$。

::: sol 解答

任取 $\boldsymbol{y}\in R(B)$，存在 $\boldsymbol{x}\in\mathbb{C}^p$ 使 $\boldsymbol{y}=B\boldsymbol{x}$。则 $A\boldsymbol{y}=A(B\boldsymbol{x})=(AB)\boldsymbol{x}=O\boldsymbol{x}=\boldsymbol{\theta}$，故 $\boldsymbol{y}\in N(A)$。于是 $R(B)\subseteq N(A)$。（顺带一提：这说明 $B$ 的每一列都在 $N(A)$ 中——把 $B$ 按列分块即可看出。）

:::

:::

::: ex B5 · 相关性的等价刻画（n ≥ 2）

证明：向量组 $\boldsymbol{\alpha}_1,\cdots,\boldsymbol{\alpha}_n$（$n\geq2$）线性无关 $\Longleftrightarrow$ 组中任一向量都**不能**由其余 $n-1$ 个向量线性表示。

::: sol 解答

这是 [1.3.1](sec13.md#sec-1.3.1) 等价刻画的逆否形式：相关 $\Longleftrightarrow$ 某个向量可由其余表示。取逆否即得：无关 $\Longleftrightarrow$ 没有向量可由其余表示。为完整起见：若某 $\boldsymbol{\alpha}_i=\sum_{j\neq i}k_j\boldsymbol{\alpha}_j$，则 $\sum_{j\neq i}k_j\boldsymbol{\alpha}_j-\boldsymbol{\alpha}_i=\boldsymbol{\theta}$ 非平凡，相关；反之若相关，取非平凡零组合，某个非零系数对应的向量可解出（[1.3.1](sec13.md#sec-1.3.1) 证明）。

:::

:::

::: ex B6 · 计数引理的练习版

设 $\boldsymbol{\varepsilon}_1,\cdots,\boldsymbol{\varepsilon}_n$ 是 $V$ 的一组基，$\boldsymbol{y}_1,\cdots,\boldsymbol{y}_{n+1}\in V$。证明 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_{n+1}$ 线性相关。（即计数引理取 $m=n+1$。）

::: sol 解答

设 $\sum_{j=1}^{n+1}k_j\boldsymbol{y}_j=\boldsymbol{\theta}$。每个 $\boldsymbol{y}_j=\sum_{i=1}^n a_{ij}\boldsymbol{\varepsilon}_i$，代入交换求和序：$\sum_{i=1}^n\big(\sum_{j=1}^{n+1}a_{ij}k_j\big)\boldsymbol{\varepsilon}_i=\boldsymbol{\theta}$。由基表示唯一性，得 $n$ 个方程、$n+1$ 个未知量 $k_j$ 的齐次线性方程组，未知量多于方程个数，必有非零解。该非零解给出 $\boldsymbol{y}$ 组的非平凡零组合，故相关。（与 [1.3.6](sec13.md#sec-1.3.6) 引理的证明逐字相同，仅代 $m=n+1$。）

:::

:::

::: ex B7 · 分解唯一性

证明：任一 $A\in\mathbb{R}^{n\times n}$ 的「对称 + 反对称」分解 $A=S+K$（$S^{\mathrm T}=S,\ K^{\mathrm T}=-K$）是唯一的。

::: sol 解答

存在性即[@ex-1.2.6]：$S=\frac12(A^{\mathrm T}+A),\ K=\frac12(A-A^{\mathrm T})$。唯一性：设 $A=S_1+K_1=S_2+K_2$。则 $S_1-S_2=K_2-K_1$。记此矩阵为 $X$：左边对称，故 $X^{\mathrm T}=X$；右边反对称，故 $X^{\mathrm T}=-X$。联立得 $X=-X$，即 $X=O$。故 $S_1=S_2,\ K_1=K_2$。（更进一步可问：分解唯一与 $W_1\cap W_2=\{O\}$ 有何关系？——见 [1.2.6](sec12.md#sec-1.2.6) 思考框。）

:::

:::

::: ex B8 · 三个子空间的维数不等式

设 $W_1,W_2,W_3$ 是有限维空间 $V$ 的子空间。证明 $\dim(W_1+W_2+W_3)\leq\dim W_1+\dim W_2+\dim W_3$，并构造等号不成立的例子。（$W_1+W_2+W_3$ 的定义照[@def-1.2.2] 推广：$\{\boldsymbol{w}_1+\boldsymbol{w}_2+\boldsymbol{w}_3\}$。）

::: hint 提示

别想对三个子空间直接套维数公式——**维数公式只管两个**。把 $W_1+W_2$ 打包成一个整体 $U$，就对 $U$ 与 $W_3$ 用公式了。

证明不等号时注意：$\dim(U\cap W_3)\geq0$，这一项扔掉就得到不等式。

反例要找「共享冗余」的三个子空间：在 $\mathbb{R}^2$ 里取三条**不同**的过原点直线。
:::

::: sol 解答

**证明：**记 $U=W_1+W_2$。按和的定义直接验证 $(W_1+W_2)+W_3=W_1+W_2+W_3=:W$。两次使用维数公式：

$$\dim W=\dim(U+W_3)=\dim U+\dim W_3-\dim(U\cap W_3)\leq\dim U+\dim W_3\leq(\dim W_1+\dim W_2)+\dim W_3.$$

**等号不成立：**$\mathbb{R}^2$ 中取三条不同的过原点直线 $W_1,W_2,W_3$（各 1 维）。任两条已张成 $\mathbb{R}^2$，故 $W_1+W_2+W_3=\mathbb{R}^2$，$\dim=2\lt1+1+1=3$。**教训：维数公式只对「两个」子空间成立；三个及以上只有不等式。**（根源：三个子空间可以「共享冗余」。）

:::

:::

::: ex B9 · 从第一变元线性推出第二变元共轭线性

设 $(\cdot,\cdot)$ 满足[@def-1.4.1]。证明 $(\boldsymbol x,a\boldsymbol y+b\boldsymbol z)=\overline a(\boldsymbol x,\boldsymbol y)+\overline b(\boldsymbol x,\boldsymbol z)$，并推出 $(\boldsymbol0,\boldsymbol y)=(\boldsymbol x,\boldsymbol0)=0$。

::: sol 解答

由共轭对称与第一变元线性，

$$ (\boldsymbol x,a\boldsymbol y+b\boldsymbol z)=\overline{(a\boldsymbol y+b\boldsymbol z,\boldsymbol x)}=\overline{a(\boldsymbol y,\boldsymbol x)+b(\boldsymbol z,\boldsymbol x)}=\overline a(\boldsymbol x,\boldsymbol y)+\overline b(\boldsymbol x,\boldsymbol z). $$

再取第一变元为零：$(\boldsymbol0,\boldsymbol y)=(0\boldsymbol x,\boldsymbol y)=0(\boldsymbol x,\boldsymbol y)=0$；由共轭对称，$(\boldsymbol x,\boldsymbol0)=\overline{(\boldsymbol0,\boldsymbol x)}=0$。

:::

:::

::: ex B10 · 加权内积的充要条件

证明：$(\boldsymbol x,\boldsymbol y)_A=\boldsymbol y^{\mathrm H}A\boldsymbol x$ 是 $\mathbb C^n$ 上的内积，当且仅当 $A$ 是正定 Hermite 矩阵。

::: sol 解答

**充分性：**矩阵乘法给第一变元线性；$A=A^{\mathrm H}$ 给 $\overline{(\boldsymbol y,\boldsymbol x)_A}=\boldsymbol y^{\mathrm H}A^{\mathrm H}\boldsymbol x=(\boldsymbol x,\boldsymbol y)_A$；$A\succ0$ 给正定性。**必要性：**正定公理直接给 $\boldsymbol x^{\mathrm H}A\boldsymbol x>0$。共轭对称给任意 $\boldsymbol x,\boldsymbol y$ 有 $\boldsymbol y^{\mathrm H}(A-A^{\mathrm H})\boldsymbol x=0$；依次取标准基向量即可得 $A-A^{\mathrm H}=O$，故 $A=A^{\mathrm H}$。

:::

:::

::: ex B11 · 直和判据的等价性

设 $W_1,W_2$ 是线性空间 $V$ 的子空间。证明：「$W_1+W_2$ 中零元素表法唯一」当且仅当「$W_1\cap W_2=\{\boldsymbol{\theta}\}$」。

::: hint 提示

两个方向都从零元素的一个表法入手：$\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$，其中 $\boldsymbol{u}\in W_1$、$-\boldsymbol{u}\in W_2$ 的充要条件是 $\boldsymbol{u}\in W_1\cap W_2$。再对照平凡表法 $\boldsymbol{\theta}=\boldsymbol{\theta}+\boldsymbol{\theta}$ 看是否另有非平凡表法。
:::

::: sol 解答

零元素的任意表法都可写成 $\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$ 的形式（$\boldsymbol{u}\in W_1$，$-\boldsymbol{u}\in W_2$），而 $-\boldsymbol{u}\in W_2\Longleftrightarrow\boldsymbol{u}\in W_2$，故这种表法与非零公共向量 $\boldsymbol{u}\in W_1\cap W_2$ 一一对应。

**「⟹」**若存在非零 $\boldsymbol{u}\in W_1\cap W_2$，则 $\boldsymbol{\theta}=\boldsymbol{\theta}+\boldsymbol{\theta}$ 与 $\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$ 是零元素的两种不同表法，与表法唯一矛盾。

**「⟸」**若 $W_1\cap W_2=\{\boldsymbol{\theta}\}$，则任何表法 $\boldsymbol{\theta}=\boldsymbol{u}+(-\boldsymbol{u})$ 都强制 $\boldsymbol{u}=\boldsymbol{\theta}$，即 $\boldsymbol{\theta}=\boldsymbol{\theta}+\boldsymbol{\theta}$，表法唯一。

:::

:::

::: ex B12 · 正交组的线性无关与 Gram–Schmidt 不改变张成

(1) 证明：内积空间中的正交向量组必线性无关。 (2) 设 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_k$ 是 Gram–Schmidt 正交化（公式见 [1.5.6](sec15.md#sec-1.5.6)）得到的向量组，证明对每个 $k$ 有 $\operatorname{span}(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_k)=\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k)$。

::: hint 提示

(1) 用 $\boldsymbol{x}_i$ 与零组合两端作内积，正交性让右边只剩 $k_i(\boldsymbol{x}_i,\boldsymbol{x}_i)$ 一项。(2) 双向包含：构造式直接说明每个 $\boldsymbol{y}_k$ 是 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k$ 的组合；把构造式移项解出 $\boldsymbol{x}_k$ 得反向。
:::

::: sol 解答

**(1)** 设 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_s$ 两两正交且非零，考查 $k_1\boldsymbol{x}_1+\cdots+k_s\boldsymbol{x}_s=\boldsymbol{\theta}$。用 $\boldsymbol{x}_i$ 与两端作内积：右端 $(\boldsymbol{\theta},\boldsymbol{x}_i)=0$，左端由两两正交只剩 $k_i(\boldsymbol{x}_i,\boldsymbol{x}_i)$。于是 $k_i\|\boldsymbol{x}_i\|^2=0$；由 $\boldsymbol{x}_i\neq\boldsymbol{\theta}$ 得 $\|\boldsymbol{x}_i\|^2\gt0$，故 $k_i=0$。$i$ 任意，线性无关。

**(2)** 由构造式 $\boldsymbol{y}_k=\boldsymbol{x}_k-\sum_{i\lt k}\dfrac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\boldsymbol{y}_i$ 是 $\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k$ 的线性组合，故 $\operatorname{span}(\boldsymbol{y}_1,\cdots,\boldsymbol{y}_k)\subseteq\operatorname{span}(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k)$。反过来移项得 $\boldsymbol{x}_k=\boldsymbol{y}_k+\sum_{i\lt k}\dfrac{(\boldsymbol{x}_k,\boldsymbol{y}_i)}{(\boldsymbol{y}_i,\boldsymbol{y}_i)}\boldsymbol{y}_i$，是 $\boldsymbol{y}_1,\cdots,\boldsymbol{y}_k$ 的组合，故反包含也成立，两者相等。

:::

:::

::: ex B13 · 最佳逼近定理

设 $V$ 是内积空间，$W$ 是 $V$ 的子空间，$\boldsymbol{x}\in V$，$\boldsymbol{y}=\operatorname{Proj}_{W}\boldsymbol{x}$。证明：对任意 $\boldsymbol{w}\in W$，有

$$\|\boldsymbol{x}-\boldsymbol{y}\|\leq\|\boldsymbol{x}-\boldsymbol{w}\|,$$

且等号成立当且仅当 $\boldsymbol{w}=\boldsymbol{y}$。

::: hint 提示

把 $\boldsymbol{x}-\boldsymbol{w}$ 拆成 $(\boldsymbol{y}-\boldsymbol{w})+(\boldsymbol{x}-\boldsymbol{y})$：两项各属于哪个子空间？它们互相正交吗？剩下的交给勾股定理。
:::

::: sol 解答

由 $\boldsymbol{y},\boldsymbol{w}\in W$ 得 $\boldsymbol{y}-\boldsymbol{w}\in W$；而 $\boldsymbol{x}-\boldsymbol{y}\in W^{\perp}$（正交投影的残差）。两项正交，勾股（[1.5.5](sec15.md#sec-1.5.5) 注 5）给出

$$\|\boldsymbol{x}-\boldsymbol{w}\|^2=\|(\boldsymbol{y}-\boldsymbol{w})+(\boldsymbol{x}-\boldsymbol{y})\|^2=\|\boldsymbol{y}-\boldsymbol{w}\|^2+\|\boldsymbol{x}-\boldsymbol{y}\|^2\ \geq\ \|\boldsymbol{x}-\boldsymbol{y}\|^2,$$

开方即得。等号成立 ⟺ $\|\boldsymbol{y}-\boldsymbol{w}\|=0$ ⟺ $\boldsymbol{w}=\boldsymbol{y}$。∎

**读法。**以 $\boldsymbol{y}$ 为垂足、$\boldsymbol{w}$ 在 $W$ 内走动，$\boldsymbol{x}-\boldsymbol{w}$ 是斜边，垂线段 $\boldsymbol{x}-\boldsymbol{y}$ 永远最短——「正交投影是最近点」，最小二乘法「残差最小」的根据（[1.6.7](sec16.md#sec-1.6.7) 的最近点注）。

:::

:::

::: ex B14 · 幂等 + Hermite = 正交投影矩阵

设 $A\in\mathbb C^{n\times n}$ 满足 $A^2=A$ 且 $A^{\mathrm H}=A$。证明：

(1) $\mathbb C^n=R(A)\oplus N(A)$（正交直和）；
(2) 对每个 $\boldsymbol{x}\in\mathbb C^n$，$A\boldsymbol{x}$ 是 $\boldsymbol{x}$ 在 $R(A)$ 上的正交投影；
(3) 举一个满足 $A^2=A$ 但 $A^{\mathrm H}\neq A$ 的矩阵，说明 (2) 的投影一般是**斜**投影。

::: sol 解答

**(1)** [@ex-1.6.4] 已证 $\mathbb C^n=R(A)\dotplus N(A)$。再由 $A=A^{\mathrm H}$ 得 $R(A)=R(A^{\mathrm H})=(N(A))^{\perp}$（[@ex-1.6.7]），分解升级为正交直和。

**(2)** 恒等式 $\boldsymbol{x}=A\boldsymbol{x}+(I-A)\boldsymbol{x}$ 中，$A\boldsymbol{x}\in R(A)$；$(I-A)\boldsymbol{x}\in R(I-A)=N(A)$（[1.6.4](sec16.md#sec-1.6.4) 思考框的双向包含）$=(R(A))^{\perp}$（由 (1)）。按定义 1.6.7，$A\boldsymbol{x}=\operatorname{Proj}_{R(A)}\boldsymbol{x}$。

**(3)** 取 $A=\begin{pmatrix}1&2\\0&0\end{pmatrix}$（同习题 C15）：$A^2=A$，但 $A^{\mathrm H}=\begin{pmatrix}1&0\\2&0\end{pmatrix}\neq A$。$R(A)$ 为 $x$ 轴，$I-A=\begin{pmatrix}0&-2\\0&1\end{pmatrix}$ 给出 $R(I-A)=\operatorname{span}\{(-2,1)^{\mathrm T}\}$，残差 $\boldsymbol{x}-A\boldsymbol{x}=(x_1,x_2)^{\mathrm T}-(x_1+2x_2,0)^{\mathrm T}=(-2x_2,x_2)^{\mathrm T}$ 与 $x$ 轴的内积为 $-2x_2$，一般非零——沿 $R(I-A)$ 的**斜**投影。（对照：若换成对称幂等阵 $\begin{pmatrix}1&0\\0&0\end{pmatrix}$，残差与 $R(A)$ 正交，投影才是正交投影。）

**会师。**对照命题 1.6.1 的矩阵形式：若 $Z$ 的列是 $R(A)$ 的标准正交基，则正交投影矩阵恰为 $ZZ^{\mathrm H}$（幂等 + Hermite）。(1)(2) 说明这两个条件不只是必要、还是充分的。

:::

:::

## C 组 · 计算题

::: ex C1 · 求零空间与列空间

$A=\begin{pmatrix}1&2&3\\ 2&4&6\end{pmatrix}$。求 $N(A)$ 与 $R(A)$（写成 span 形式），并给出各自维数。

::: sol 解答

$N(A)$：两行成比例，方程即 $x_1+2x_2+3x_3=0$。取 $(x_2,x_3)=(1,0)$ 得 $x_1=-2$；取 $(0,1)$ 得 $x_1=-3$：

$$N(A)=\operatorname{span}\{(-2,1,0)^{\mathrm T},\ (-3,0,1)^{\mathrm T}\}\subseteq\mathbb{C}^3,\qquad \dim N(A)=2.$$

$R(A)$：两列 $(1,2)^{\mathrm T},\ (2,4)^{\mathrm T},\ (3,6)^{\mathrm T}$ 全部成比例，

$$R(A)=\operatorname{span}\{(1,2)^{\mathrm T}\}\subseteq\mathbb{C}^2,\qquad \dim R(A)=1.$$

自检：$\dim N(A)+\dim R(A)=2+1=3=n$ ✓（思考 3、4 的恒等式）。

:::

:::

::: ex C2 · 相关性判定（秩）

判断下列向量组的线性相关性；若相关，写出极大的无关组：

(1) $(1,1,0)^{\mathrm T},\ (2,2,0)^{\mathrm T},\ (0,1,1)^{\mathrm T}$；(2) $(1,2,1)^{\mathrm T},\ (1,1,1)^{\mathrm T},\ (1,0,1)^{\mathrm T}$。

::: sol 解答

(1) 前两个成比例（相关），故整组相关；又 $(1,1,0),(0,1,1)$ 不成比例，极大无关组 $\{(1,1,0)^{\mathrm T},(0,1,1)^{\mathrm T}\}$，秩 2。

(2) 这正是[@ex-1.3.6] 勘误中的 $\boldsymbol{\alpha}$ 组：$\det\begin{pmatrix}1&1&1\\ 2&1&0\\ 1&1&1\end{pmatrix}=0$（第 1、3 行相同），且 $(1,2,1)^{\mathrm T}-2(1,1,1)^{\mathrm T}+(1,0,1)^{\mathrm T}=\boldsymbol{\theta}$，相关；任两个不成比例，极大无关组例如 $\{(1,2,1)^{\mathrm T},(1,1,1)^{\mathrm T}\}$，秩 2。

:::

:::

::: ex C3 · 信号的相关性（Casorati）

判断信号 $x_k=1$（恒为 1）、$y_k=(-1)^k$、$z_k=2^k$ 的线性相关性。

::: sol 解答

设 $l_1x_k+l_2y_k+l_3z_k=0$ 对所有 $k$ 成立。取 $k=0,1,2$ 得 Casorati 方程组：

$$\begin{pmatrix}1&1&1\\ 1&-1&2\\ 1&1&4\end{pmatrix}\begin{pmatrix}l_1\\l_2\\l_3\end{pmatrix}=\begin{pmatrix}0\\0\\0\end{pmatrix},\qquad \det=1(-4-2)-1(4-2)+1(1+1)=-6-2+2=-6\neq0,$$

矩阵可逆，只有零解，三信号线性无关。

:::

:::

::: ex C4 · 求坐标

求 $\boldsymbol{x}=(1,2,3)^{\mathrm T}$ 在 $\mathbb{R}^3$ 的基 $\boldsymbol{b}_1=(1,0,0)^{\mathrm T},\ \boldsymbol{b}_2=(1,1,0)^{\mathrm T},\ \boldsymbol{b}_3=(1,1,1)^{\mathrm T}$ 下的坐标。

::: sol 解答

设 $\boldsymbol{x}=a\boldsymbol{b}_1+b\boldsymbol{b}_2+c\boldsymbol{b}_3$，按分量（从第三行倒着解最省力）：

$$c=3,\qquad b+c=2\Rightarrow b=-1,\qquad a+b+c=1\Rightarrow a=1-(-1)-3=-1.$$

坐标 $(-1,-1,3)^{\mathrm T}$。验证：$-1(1,0,0)-1(1,1,0)+3(1,1,1)=(1,2,3)$ ✓。

:::

:::

::: ex C5 · 过渡矩阵与坐标变换（含「旧坐标 ≠ 自然坐标」辨析）

$\mathbb{R}^2$ 的两组基：Ⅰ $\{\boldsymbol{x}_1=(1,0)^{\mathrm T},\ \boldsymbol{x}_2=(1,1)^{\mathrm T}\}$，Ⅱ $\{\boldsymbol{y}_1=(1,1)^{\mathrm T},\ \boldsymbol{y}_2=(1,-1)^{\mathrm T}\}$。(1) 求由基 Ⅰ 到基 Ⅱ 的过渡矩阵 $A$；(2) 求 $\boldsymbol{x}=(2,3)^{\mathrm T}$ 在基 Ⅱ 下的坐标。

::: hint 提示

第 (1) 问的 $A$ 与 [@ex-1.3.B] 形式相同，但**基 Ⅰ 不再是标准基**——所以不能把 $\boldsymbol{y}_i$ 的数值坐标直接当列。

老老实实解**两组**组合：$\boldsymbol{y}_1=a\boldsymbol{x}_1+b\boldsymbol{x}_2$ 与 $\boldsymbol{y}_2=c\boldsymbol{x}_1+d\boldsymbol{x}_2$，解出的 $(a,b)^{\mathrm T}$、$(c,d)^{\mathrm T}$ 就是 $A$ 的两列。

第 (2) 问的易错点：$(2,3)^{\mathrm T}$ 是 $\boldsymbol{x}$ 的**自然坐标**，而 $A^{-1}$ 要作用在「$\boldsymbol{x}$ 在基 Ⅰ 下的坐标」上，两者不是一回事。先求出后者。
:::

::: sol 解答

**(1)** $A$ 的列 = $\boldsymbol{y}_i$ 在基 Ⅰ 下的坐标。$\boldsymbol{y}_1=(1,1)^{\mathrm T}=0\boldsymbol{x}_1+1\boldsymbol{x}_2$；$\boldsymbol{y}_2=(1,-1)^{\mathrm T}=2\boldsymbol{x}_1-1\boldsymbol{x}_2$（解 $a+b=1,\ b=-1$ 得 $a=2$）。故

$$A=\begin{pmatrix}0&2\\ 1&-1\end{pmatrix},\qquad\det A=-2\neq0\ (\text{可逆}).$$

**(2) 易错点：**$(2,3)^{\mathrm T}$ 是 $\boldsymbol{x}$ 的**自然坐标**，而公式 $(\beta)=A^{-1}(\alpha)$ 里的 $(\alpha)$ 是**基 Ⅰ 下**的坐标！先求 $\boldsymbol{x}=a\boldsymbol{x}_1+b\boldsymbol{x}_2$：$a+b=2,\ b=3\Rightarrow a=-1$，故 $(\alpha)=(-1,3)^{\mathrm T}$。再由 $A^{-1}=\frac1{-2}\begin{pmatrix}-1&-2\\ -1&0\end{pmatrix}=\begin{pmatrix}\tfrac12&1\\ \tfrac12&0\end{pmatrix}$：

$$(\beta)=A^{-1}(\alpha)=\begin{pmatrix}\tfrac12&1\\ \tfrac12&0\end{pmatrix}\begin{pmatrix}-1\\ 3\end{pmatrix}=\begin{pmatrix}\tfrac52\\ -\tfrac12\end{pmatrix}.$$

验证：$\tfrac52\boldsymbol{y}_1-\tfrac12\boldsymbol{y}_2=\tfrac52(1,1)-\tfrac12(1,-1)=(2,3)$ ✓。（若直接把 $(2,3)^{\mathrm T}$ 当 $(\alpha)$ 代入，会得到 $(4,1)^{\mathrm T}$，验证 $4\boldsymbol{y}_1+\boldsymbol{y}_2=(5,3)^{\mathrm T}\neq\boldsymbol{x}$，立刻露馅——养成「代回验证」的习惯。）

:::

:::

::: ex C6 · 维数公式实战

$W_1=\operatorname{span}\{(1,1,0)^{\mathrm T},\ (1,0,1)^{\mathrm T}\}$，$W_2=\operatorname{span}\{(0,1,1)^{\mathrm T},\ (1,1,1)^{\mathrm T}\}$。求 $\dim(W_1\cap W_2)$ 与 $W_1\cap W_2$ 本身。

::: hint 提示

分两步：**先算维数定心，再解方程求向量。**

维数要两个数据：$\dim W_1$、$\dim W_2$（各组内两向量不成比例即为 2）与 $\dim(W_1+W_2)$（四个向量拼起来求秩）。代维数公式即得 $\dim(W_1\cap W_2)$。

求向量本身用通法：设公共向量 $\boldsymbol{v}=k_1(1,1,0)^{\mathrm T}+k_2(1,0,1)^{\mathrm T}=l_1(0,1,1)^{\mathrm T}+l_2(1,1,1)^{\mathrm T}$，**按分量写开成三个方程**，解出系数之间的关系。求出的向量务必代回两个 span 各验证一次。
:::

::: sol 解答

各组内两向量不成比例：$\dim W_1=\dim W_2=2$。前三个向量 $(1,1,0),(1,0,1),(0,1,1)$ 的行列式 $\begin{vmatrix}1&1&0\\1&0&1\\0&1&1\end{vmatrix}=1(0-1)-1(1-0)=-2\neq0$，故四向量拼起来秩 3，$\dim(W_1+W_2)=3$。维数公式：$\dim(W_1\cap W_2)=2+2-3=1$。

求交（通法）：设 $k_1(1,1,0)+k_2(1,0,1)=l_1(0,1,1)+l_2(1,1,1)$。分量比较：

$$k_1+k_2=l_2,\qquad k_1=l_1+l_2,\qquad k_2=l_1+l_2\ \Rightarrow\ k_1=k_2,\ l_2=2k_1,\ l_1=-k_1.$$

取 $k_1=k_2=t$：公共向量 $=t(2,1,1)^{\mathrm T}$，故 $W_1\cap W_2=\operatorname{span}\{(2,1,1)^{\mathrm T}\}$。验证：$(2,1,1)=(1,1,0)+(1,0,1)\in W_1$，且 $(2,1,1)=-(0,1,1)+2(1,1,1)=(2,1,1)\in W_2$ ✓。

:::

:::

::: ex C7 · 2×2 矩阵的表示（Cayley–Hamilton 的 n = 2 特例）

$A=\begin{pmatrix}1&2\\ 0&3\end{pmatrix}$。(1) 直接计算验证 $A^2-(\operatorname{tr}A)A+(\det A)I=O$；(2) 由此把 $A^2$、$A^3$ 写成 $A,\ I$ 的线性组合。

::: hint 提示

第 (1) 问纯计算：先把 $A^2$、$\operatorname{tr}A$、$\det A$ 算出来，再代进式子。

第 (2) 问的关键是**把 $A^2$ 的表达式当成「降次工具」**：由 (1) 移项得 $A^2=(\operatorname{tr}A)A-(\det A)I$。算 $A^3$ 时先写 $A^3=A\cdot A^2$，代入上式消去 $A^2$，再用一遍 $A^2$ 的表达式把剩下的 $A^2$ 也降掉——结果是 $A$ 与 $I$ 的组合。

这正是课件里 [@ex-1.1.5] 那类「$A^k$ 总在由 $A,I$ 张成的世界里」的一般版本（Cayley–Hamilton 的 $n=2$ 特例）。
:::

::: sol 解答

**(1)** $A^2=\begin{pmatrix}1&8\\0&9\end{pmatrix}$，$\operatorname{tr}A=1+3=4$，$\det A=3$：

$$A^2-4A+3I=\begin{pmatrix}1&8\\0&9\end{pmatrix}-\begin{pmatrix}4&8\\0&12\end{pmatrix}+\begin{pmatrix}3&0\\0&3\end{pmatrix}=\begin{pmatrix}0&0\\0&0\end{pmatrix}=O.$$

**(2)** 移项得 $A^2=4A-3I$；两边乘 $A$ 并再代入一次：$A^3=A\cdot A^2=4A^2-3A=4(4A-3I)-3A=13A-12I$。验证：$A^3=\begin{pmatrix}1&26\\0&27\end{pmatrix}$，$13A-12I=\begin{pmatrix}13&26\\0&39\end{pmatrix}-\begin{pmatrix}12&0\\0&12\end{pmatrix}=\begin{pmatrix}1&26\\0&27\end{pmatrix}$ ✓。（一般结论见 [1.1.6](sec11.md#sec-1.1.6) 课程预告：Cayley–Hamilton 定理。）

:::

:::

::: ex C8 · 张成空间的基与维数

求 $\operatorname{span}\{(1,2,1)^{\mathrm T},\ (2,4,2)^{\mathrm T},\ (1,1,1)^{\mathrm T}\}$ 的维数与一组基。

::: sol 解答

把向量按行拼成矩阵并作行变换：$\begin{pmatrix}1&2&1\\ 2&4&2\\ 1&1&1\end{pmatrix}\xrightarrow{r_2-2r_1,\ r_3-r_1}\begin{pmatrix}1&2&1\\ 0&0&0\\ 0&-1&0\end{pmatrix}$，行阶梯形有两个非零行，故秩为 2。又 $(2,4,2)^{\mathrm T}=2(1,2,1)^{\mathrm T}$，而 $(1,2,1)^{\mathrm T}$ 与 $(1,1,1)^{\mathrm T}$ 不成比例，故维数为 2，一组基可取 $\{(1,2,1)^{\mathrm T},\ (1,1,1)^{\mathrm T}\}$。（注意：向量组的秩 = 张成空间的维数，见 [1.3.4](sec13.md#sec-1.3.4) 的说明。）

:::

:::

::: ex C9 · 配方法判断正定并计算内积

令 $A=\begin{pmatrix}2&1\\1&2\end{pmatrix}$。(1) 用配方法证明 $A\succ0$；(2) 对 $\boldsymbol x=(1,i)^{\mathrm T}$、$\boldsymbol y=(1-i,2)^{\mathrm T}$，计算 $(\boldsymbol x,\boldsymbol y)_A=\boldsymbol y^{\mathrm H}A\boldsymbol x$。

::: sol 解答

(1) 对 $\boldsymbol z=(z_1,z_2)^{\mathrm T}\neq\boldsymbol0$，

$$\boldsymbol z^{\mathrm H}A\boldsymbol z=2|z_1|^2+2\operatorname{Re}(\overline z_1z_2)+2|z_2|^2=|z_1+z_2|^2+|z_1|^2+|z_2|^2>0.$$

(2) 先算 $A\boldsymbol x=(2+i,1+2i)^{\mathrm T}$，且 $\boldsymbol y^{\mathrm H}=(1+i,2)$，故

$$ (\boldsymbol x,\boldsymbol y)_A=(1+i)(2+i)+2(1+2i)=3+7i. $$

:::

:::

::: ex C10 · 非标准基下的 Gram 矩阵

在 $\mathbb R^2$ 的标准内积下，取基 $\mathcal E=(\boldsymbol\varepsilon_1,\boldsymbol\varepsilon_2)$，其中 $\boldsymbol\varepsilon_1=(1,0)^{\mathrm T}$、$\boldsymbol\varepsilon_2=(1,1)^{\mathrm T}$。求 $G_{\mathcal E}$，并用它验证 $\boldsymbol x=2\boldsymbol\varepsilon_1-\boldsymbol\varepsilon_2$、$\boldsymbol y=\boldsymbol\varepsilon_1+3\boldsymbol\varepsilon_2$ 的内积。

::: sol 解答

实空间中共轭不起作用，故

$$G_{\mathcal E}=\begin{pmatrix}(\varepsilon_1,\varepsilon_1)&(\varepsilon_2,\varepsilon_1)\\(\varepsilon_1,\varepsilon_2)&(\varepsilon_2,\varepsilon_2)\end{pmatrix}=\begin{pmatrix}1&1\\1&2\end{pmatrix}.$$

坐标为 $\boldsymbol\xi=(2,-1)^{\mathrm T}$、$\boldsymbol\eta=(1,3)^{\mathrm T}$。先算 $G\boldsymbol\xi=(1,0)^{\mathrm T}$，所以 $(\boldsymbol x,\boldsymbol y)=\boldsymbol\eta^{\mathrm T}G\boldsymbol\xi=(1,3)(1,0)^{\mathrm T}=1$。直接核验：$\boldsymbol x=(1,-1)^{\mathrm T}$、$\boldsymbol y=(4,3)^{\mathrm T}$，点积 $1\cdot4+(-1)\cdot3=1$，一致。

:::

:::

::: ex C11 · 复标准内积

在第一变元线性的标准内积 $(\boldsymbol x,\boldsymbol y)=\boldsymbol y^{\mathrm H}\boldsymbol x$ 下，令 $\boldsymbol x=(1+i,2)^{\mathrm T}$、$\boldsymbol y=(i,1-i)^{\mathrm T}$。计算 $(\boldsymbol x,\boldsymbol y)$、$(\boldsymbol y,\boldsymbol x)$ 与 $(\boldsymbol x,\boldsymbol x)$。

::: sol 解答

$\boldsymbol y^{\mathrm H}=(-i,1+i)$，故 $(\boldsymbol x,\boldsymbol y)=(-i)(1+i)+(1+i)2=3+i$。由共轭对称，$(\boldsymbol y,\boldsymbol x)=3-i$。又 $(\boldsymbol x,\boldsymbol x)=|1+i|^2+|2|^2=2+4=6$。

:::

:::

::: ex C12 · 长度、夹角与 C-S 不等式

在 $\mathbb R^3$ 的标准内积下，取 $\boldsymbol x=(1,2,2)^{\mathrm T}$、$\boldsymbol y=(2,2,1)^{\mathrm T}$。求 $\|\boldsymbol x\|$、$\|\boldsymbol y\|$、$(\boldsymbol x,\boldsymbol y)$ 与两向量的夹角 $\alpha$，并验证 Cauchy–Schwarz 不等式取不取等号。

::: sol 解答

$\|\boldsymbol x\|=\sqrt{1+4+4}=3$；$\|\boldsymbol y\|=\sqrt{4+4+1}=3$；$(\boldsymbol x,\boldsymbol y)=1\cdot2+2\cdot2+2\cdot1=8$。

$\cos\alpha=\dfrac{8}{3\cdot3}=\dfrac89$，故 $\alpha=\arccos\frac89\approx27.3^\circ$。

C-S：$|(\boldsymbol x,\boldsymbol y)|=8<9=\|\boldsymbol x\|\|\boldsymbol y\|$，**不取等号**——因为 $\boldsymbol x,\boldsymbol y$ 不成比例（[@thm-1.5.1] 的等号条件）。

:::

:::

::: ex C13 · Gram–Schmidt 正交化

对 $\mathbb R^3$ 的标准内积，把 $\boldsymbol x_1=(1,1,1)^{\mathrm T}$、$\boldsymbol x_2=(1,1,0)^{\mathrm T}$、$\boldsymbol x_3=(1,0,0)^{\mathrm T}$ 化为标准正交组。

::: sol 解答

$\boldsymbol y_1=\boldsymbol x_1=(1,1,1)^{\mathrm T}$，$(\boldsymbol y_1,\boldsymbol y_1)=3$。

$$\boldsymbol y_2=\boldsymbol x_2-\frac{(\boldsymbol x_2,\boldsymbol y_1)}{3}\boldsymbol y_1=(1,1,0)^{\mathrm T}-\tfrac23(1,1,1)^{\mathrm T}=\big(\tfrac13,\tfrac13,-\tfrac23\big)^{\mathrm T},\quad(\boldsymbol y_2,\boldsymbol y_2)=\tfrac69=\tfrac23.$$

$$\boldsymbol y_3=\boldsymbol x_3-\frac{(\boldsymbol x_3,\boldsymbol y_1)}{3}\boldsymbol y_1-\frac{(\boldsymbol x_3,\boldsymbol y_2)}{2/3}\boldsymbol y_2=(1,0,0)^{\mathrm T}-\tfrac13(1,1,1)^{\mathrm T}-\tfrac12\big(\tfrac13,\tfrac13,-\tfrac23\big)^{\mathrm T}=\big(\tfrac12,-\tfrac12,0\big)^{\mathrm T}.$$

核算正交：$(\boldsymbol y_1,\boldsymbol y_2)=\tfrac13+\tfrac13-\tfrac23=0$ ✓，$(\boldsymbol y_1,\boldsymbol y_3)=\tfrac12-\tfrac12=0$ ✓，$(\boldsymbol y_2,\boldsymbol y_3)=\tfrac16-\tfrac16=0$ ✓。单位化（$\|\boldsymbol y_1\|=\sqrt3$，$\|\boldsymbol y_2\|=\sqrt{2/3}$，$\|\boldsymbol y_3\|=\tfrac{\sqrt2}{2}$）：

$$\boldsymbol q_1=\tfrac{1}{\sqrt3}(1,1,1)^{\mathrm T},\quad \boldsymbol q_2=\tfrac{1}{\sqrt6}(1,1,-2)^{\mathrm T},\quad \boldsymbol q_3=\tfrac{1}{\sqrt2}(1,-1,0)^{\mathrm T}.$$

:::

:::

::: ex C14 · 判定直和并求投影

设 $W_1=\operatorname{span}\{(1,1,0)^{\mathrm T}\}$，$W_2=\{(x_1,x_2,x_3)^{\mathrm T}\mid x_1+x_2+x_3=0\}$。(1) 判断 $\mathbb R^3=W_1+W_2$ 是否为直和；(2) 求 $\boldsymbol x=(1,2,3)^{\mathrm T}$ 在 $W_1$、$W_2$ 上的投影（沿此分解）。

::: sol 解答

**(1)** $\dim W_1=1$，$\dim W_2=2$（一个独立线性方程）。考查交：若 $t(1,1,0)^{\mathrm T}\in W_2$，则需 $t+t+0=2t=0$，故 $t=0$——即 $W_1\cap W_2=\{\boldsymbol{\theta}\}$。由 [@thm-1.6.1] (3)，**是直和**（维数也吻合：$1+2=3=\dim\mathbb R^3$，所以 $W_1\dotplus W_2=\mathbb R^3$）。

**(2)** 直和保证拆法唯一，按定义求 $\boldsymbol x=k_1(1,1,0)^{\mathrm T}+\boldsymbol{w}_2$（$\boldsymbol{w}_2\in W_2$）：
设 $\boldsymbol{w}_2=\boldsymbol x-k_1(1,1,0)^{\mathrm T}=(1-k_1,\ 2-k_1,\ 3)^{\mathrm T}$，代入约束 $(1-k_1)+(2-k_1)+3=0$ 得 $k_1=3$。于是

$$\boldsymbol x=\underbrace{(3,3,0)^{\mathrm T}}_{\in W_1}+\underbrace{(-2,-1,3)^{\mathrm T}}_{\in W_2},\qquad \boldsymbol y_{W_1}=(3,3,0)^{\mathrm T},\quad \boldsymbol y_{W_2}=(-2,-1,3)^{\mathrm T}.$$

核对：$(-2)+(-1)+3=0$ 故第二项确在 $W_2$；两项相加 $=(1,2,3)^{\mathrm T}=\boldsymbol x$ ✓。

**变形（这里才是本题的考点）。** 若把 $W_2$ 换成 $x_1-x_2+x_3=0$，则 $(1,1,0)^{\mathrm T}$ 满足 $1-1+0=0$，于是 $W_1\subseteq W_2$、$W_1\cap W_2=W_1\neq\{\boldsymbol{\theta}\}$，**和不是直和**（$\dim(W_1+W_2)=\dim W_2=2\lt3$）。此时「沿此分解求投影」无从谈起——投影只在直和分解下唯一，必须先换一个与 $W_1$ 互补的子空间。**所以做这类题的第一动作永远是：先查 $W_1\cap W_2$。**

:::

:::

::: ex C15 · 幂等矩阵的直和分解

设 $A=\begin{pmatrix}1&2\\0&0\end{pmatrix}$。验证 $A^2=A$，求 $R(A)$ 与 $R(I-A)$，验证 $\mathbb C^2=R(A)\dotplus R(I-A)$，并说明 $A\boldsymbol x$ 是沿哪个方向的投影。

::: sol 解答

$A^2=\begin{pmatrix}1&2\\0&0\end{pmatrix}\begin{pmatrix}1&2\\0&0\end{pmatrix}=\begin{pmatrix}1&2\\0&0\end{pmatrix}=A$，是幂等矩阵。

$R(A)=\operatorname{span}\{(1,0)^{\mathrm T}\}$（第二列为第一列的 2 倍）。$I-A=\begin{pmatrix}0&-2\\0&1\end{pmatrix}$，列向量 $(0,0)^{\mathrm T}$ 与 $(-2,1)^{\mathrm T}$，故 $R(I-A)=\operatorname{span}\{(-2,1)^{\mathrm T}\}$。

直和：$(1,0)^{\mathrm T}$ 与 $(-2,1)^{\mathrm T}$ 不成比例，$\dim R(A)+\dim R(I-A)=1+1=2=\dim\mathbb C^2$，由 [@thm-1.6.1] (4) 得 $\mathbb C^2=R(A)\dotplus R(I-A)$。

投影方向：$A\boldsymbol x=A\binom{x_1}{x_2}=\binom{x_1+2x_2}{0}$，即把 $\boldsymbol x$ 沿 $R(I-A)=N(A)$ 的方向（$(-2,1)^{\mathrm T}$）投到 $x$ 轴上的**斜**投影。残差 $\boldsymbol x-A\boldsymbol x=(x_1,x_2)^{\mathrm T}-(x_1+2x_2,0)^{\mathrm T}=(-2x_2,x_2)^{\mathrm T}$ 确实落在 $R(I-A)$ 中；但它并不总与 $R(A)$ 正交——$(1,0)^{\mathrm T}\cdot(-2x_2,x_2)^{\mathrm T}=-2x_2$，仅当 $x_2=0$ 时为零。所以这不是正交投影，正与 $A^{\mathrm T}\neq A$ 相符。对照：把 $A$ 换成对称幂等矩阵 $\begin{pmatrix}1&0\\0&0\end{pmatrix}$，$R(I-A)$ 变成 $y$ 轴，与 $R(A)$ 正交，投影才是正交投影。

:::

:::

::: ex C16 · 正交补与正交投影（两条路线互相复核）

在 $\mathbb R^3$（标准内积）中设 $W=\operatorname{span}\{(1,1,0)^{\mathrm T},(1,0,1)^{\mathrm T}\}$，$\boldsymbol x=(1,2,3)^{\mathrm T}$。

(1) 求 $W^{\perp}$ 并核对其维数；
(2) 求 $\boldsymbol x$ 在 $W$ 与 $W^{\perp}$ 上的正交投影——先用「先补后投」，再用「先 Gram–Schmidt 后公式」复核。

::: hint 提示

(1) 设 $\boldsymbol u=(a,b,c)^{\mathrm T}$ 与两个基向量正交，得两个齐次方程。(2) 注意所给基**不正交**（内积为 $1$），命题 1.6.1 的公式不能直接用；GS 后 $W$ 的正交基可取 $\boldsymbol y_1=(1,1,0)^{\mathrm T}$、$\boldsymbol y_2=(\tfrac12,-\tfrac12,1)^{\mathrm T}$。
:::

::: sol 解答

**(1)** 由 $a+b=0$、$a+c=0$ 得 $b=c=-a$，故

$$W^{\perp}=\operatorname{span}\{(1,-1,-1)^{\mathrm T}\},\qquad\dim W^{\perp}=1=3-2\ \checkmark .$$

**(2) 路线一（先补后投，[@ex-1.6.6] 方法一）。**$(\boldsymbol x,\boldsymbol u)=1-2-3=-4$，$(\boldsymbol u,\boldsymbol u)=3$，故

$$\boldsymbol z=\operatorname{Proj}_{W^{\perp}}\boldsymbol x=-\frac43(1,-1,-1)^{\mathrm T}=\Big(-\frac43,\frac43,\frac43\Big)^{\mathrm T},\qquad
\boldsymbol y=\boldsymbol x-\boldsymbol z=\Big(\frac73,\frac23,\frac53\Big)^{\mathrm T}.$$

**路线二（先 GS 后公式）。**所给基内积为 $1$，不正交（勘误 E12 的教训：先查！）。GS：$\boldsymbol y_1=(1,1,0)^{\mathrm T}$，$\boldsymbol y_2=(1,0,1)^{\mathrm T}-\tfrac12\boldsymbol y_1=(\tfrac12,-\tfrac12,1)^{\mathrm T}$。用 [@prop-1.6.1]：

$$\operatorname{Proj}_{W}\boldsymbol x=\frac{(\boldsymbol x,\boldsymbol y_1)}{2}\boldsymbol y_1+\frac{(\boldsymbol x,\boldsymbol y_2)}{3/2}\boldsymbol y_2=\frac32\boldsymbol y_1+\frac53\boldsymbol y_2=\Big(\frac73,\frac23,\frac53\Big)^{\mathrm T},$$

其中 $(\boldsymbol x,\boldsymbol y_1)=3$、$(\boldsymbol x,\boldsymbol y_2)=\tfrac12-1+3=\tfrac52$。两路线一致 ✓。

**核对。**$\boldsymbol y\cdot\boldsymbol u=\tfrac73-\tfrac23-\tfrac53=0$，$\boldsymbol y\in W$ ✓；$\boldsymbol y+\boldsymbol z=\boldsymbol x$ ✓；勾股 $\|\boldsymbol x\|^2=14=\tfrac{26}3+\tfrac{16}3=\|\boldsymbol y\|^2+\|\boldsymbol z\|^2$ ✓。**要点：**正交投影由 $W$ 与内积唯一确定，两条路线必然同解——不同答案意味着某条路线用错了（最常见：对非正交基硬套公式）。

:::

:::

::: ex C17 · Gram–Schmidt 的正线上三角过渡矩阵（QR 雏形）

基取自 [@ex-1.5.B] 第 (2) 组：$\boldsymbol x_1=(1,1,0)^{\mathrm T}$、$\boldsymbol x_2=(1,0,1)^{\mathrm T}$、$\boldsymbol x_3=(0,1,1)^{\mathrm T}$（$\mathbb R^3$ 标准内积）。

(1) 写出 GS 得到的标准正交基 $\boldsymbol z_1,\boldsymbol z_2,\boldsymbol z_3$（可直接引用 [@ex-1.5.B] 的结果）；
(2) 求过渡矩阵 $A$ 使 $(\boldsymbol x_1,\boldsymbol x_2,\boldsymbol x_3)=(\boldsymbol z_1,\boldsymbol z_2,\boldsymbol z_3)A$，并验证 $A$ 是正线上三角矩阵；
(3) 验证 $A$ 的第 2、3 列确实组装回 $\boldsymbol x_2,\boldsymbol x_3$，并核验 $|\det A|=|\det(\boldsymbol x_1,\boldsymbol x_2,\boldsymbol x_3)|$。

::: sol 解答

**(1)** 由 [@ex-1.5.B]：$\boldsymbol y_1=(1,1,0)^{\mathrm T}$、$\boldsymbol y_2=(\tfrac12,-\tfrac12,1)^{\mathrm T}=\tfrac12(1,-1,2)^{\mathrm T}$、$\boldsymbol y_3=(-\tfrac23,\tfrac23,\tfrac23)^{\mathrm T}=\tfrac23(-1,1,1)^{\mathrm T}$，单位化：

$$\boldsymbol z_1=\frac{1}{\sqrt2}(1,1,0)^{\mathrm T},\qquad
\boldsymbol z_2=\frac{1}{\sqrt6}(1,-1,2)^{\mathrm T},\qquad
\boldsymbol z_3=\frac{1}{\sqrt3}(-1,1,1)^{\mathrm T}.$$

**(2)** 按 [1.6.8](sec16.md#sec-1.6.8)：对角元 $a_{kk}=\|\boldsymbol y_k\|$，上三角元 $a_{ik}=(\boldsymbol x_k,\boldsymbol z_i)$（$i\lt k$），下三角为 $0$。逐一计算：

$$\|\boldsymbol y_1\|=\sqrt2,\quad\|\boldsymbol y_2\|=\frac{\sqrt6}{2},\quad\|\boldsymbol y_3\|=\frac{2}{\sqrt3};$$
$$a_{12}=(\boldsymbol x_2,\boldsymbol z_1)=\frac{1}{\sqrt2},\qquad
a_{13}=(\boldsymbol x_3,\boldsymbol z_1)=\frac{1}{\sqrt2},\qquad
a_{23}=(\boldsymbol x_3,\boldsymbol z_2)=\frac{0-1+2}{\sqrt6}=\frac{1}{\sqrt6},$$

$$A=\begin{pmatrix}\sqrt2&\dfrac{1}{\sqrt2}&\dfrac{1}{\sqrt2}\\[2pt]0&\dfrac{\sqrt6}{2}&\dfrac{1}{\sqrt6}\\[2pt]0&0&\dfrac{2}{\sqrt3}\end{pmatrix}$$

上三角 ✓，对角元全正 ✓——正线上三角。

**(3)** 第 2 列：$\dfrac{1}{\sqrt2}\boldsymbol z_1+\dfrac{\sqrt6}{2}\boldsymbol z_2=\dfrac12(1,1,0)^{\mathrm T}+\dfrac12(1,-1,2)^{\mathrm T}=(1,0,1)^{\mathrm T}=\boldsymbol x_2$ ✓。第 3 列：

$$\frac{1}{\sqrt2}\boldsymbol z_1+\frac{1}{\sqrt6}\boldsymbol z_2+\frac{2}{\sqrt3}\boldsymbol z_3
=\frac12(1,1,0)^{\mathrm T}+\frac16(1,-1,2)^{\mathrm T}+\frac23(-1,1,1)^{\mathrm T}
=(0,1,1)^{\mathrm T}=\boldsymbol x_3\ \checkmark .$$

行列式：$\det A=\sqrt2\cdot\dfrac{\sqrt6}{2}\cdot\dfrac{2}{\sqrt3}=2$；而 $\det(\boldsymbol x_1,\boldsymbol x_2,\boldsymbol x_3)=-2$，$|\det|=2$ 相等 ✓（符号差来自 $\boldsymbol z$ 组的定向，$\det Q=-1$：正交矩阵的行列式只能是 $\pm1$）。

**收尾。**把结论写成 $X=QA$（$Q$ 的列是 $\boldsymbol z$ 组），这就是 QR 分解的雏形（[1.6.8](sec16.md#sec-1.6.8) 的思考框）——GS 不只是造正交基，还顺手完成了矩阵分解。

:::

:::
