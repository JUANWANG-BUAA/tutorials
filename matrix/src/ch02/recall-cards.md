# 闭卷回忆卡 · 第二章：定义、定理与第一行

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

> **背不下来？先看[速查背记卡](../memory-sheet.md)。** 那一页把每个定义、定理压成一句「最小可背诵单元」；这一页负责检验你有没有真的记住。两页配合使用：先在速查卡把钩子记住，再来这里从空白纸上叫出来。第一章的对应卡片在[第一章回忆卡](../ch01/recall-cards.md)，第三章的在[第三章回忆卡](../ch03/recall-cards.md)。

::: note 想做成间隔复习
本页每张卡可以导出成 Anki 卡组——命令与导入步骤见[速查背记卡](../memory-sheet.md)文末「导出到 Anki」（脚本会一次解析三章回忆卡）。
:::

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记录三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 定义卡

### D1 · 映射与单射 / 满射 / 双射

写出映射的要素；再分别说清单射、满射、双射各「否定什么、保证什么」。它们之间谁蕴含谁？

::: sol D1 核对

映射 $f:A\to B$ 给**每个**原像指定**唯一**像。单射：不同原像给不同像（等价写法 $f(x_1)=f(x_2)\Rightarrow x_1=x_2$）；满射：值域 $=$ 陪域；双射：两者兼备（[@def-2.1.2]）。方向记号：单射看原像是否打架，满射看陪域是否被铺满——**互不蕴含**。易漏：无限集上「单射」与「满射」可以只成立一边（$\mathbb N\to\mathbb N$，$n\mapsto2n$ 是单不满）。
:::

### D2 · 可逆映射与逆映射

写出「$f$ 可逆」的定义（两个复合等式）；可逆与双射什么关系？逆映射唯一吗？

::: sol D2 核对

存在 $g:B\to A$ 使 $g\circ f=\mathrm{id}_A$ 且 $f\circ g=\mathrm{id}_B$，则称 $f$ 可逆、$g$ 为逆（[@def-2.1.5]）。**可逆 $\iff$ 双射**（[@thm-2.1.2]），**逆映射唯一**（[@thm-2.1.1]）。证明第一行（唯一性）：设 $g_1,g_2$ 都是逆，则 $g_1=g_1\circ(f\circ g_2)=(g_1\circ f)\circ g_2=g_2$——**只靠结合律与两个复合等式**。
:::

### D3 · 线性映射

写出两条要求；它与「保持线性组合」的等价形式是什么？线性映射必有 $T(\boldsymbol\theta)=\boldsymbol\theta'$ 吗？判断题里最快的一票否决是什么？

::: sol D3 核对

可加性 $T(\boldsymbol x+\boldsymbol y)=T\boldsymbol x+T\boldsymbol y$ 与齐次性 $T(k\boldsymbol x)=kT\boldsymbol x$ 缺一不可，且要求**同一数域**（[@def-2.2.1]）。等价形式：$T(a\boldsymbol x+b\boldsymbol y)=aT\boldsymbol x+bT\boldsymbol y$，进一步「保持任意线性组合」（[@thm-2.2.1]）。$T(\boldsymbol\theta)=\boldsymbol\theta'$ 必成立（取 $k=0$），所以**先算 $T(\boldsymbol\theta)$ 是否为零向量，是最快的否证法**（[@cor-2.2.1]）。
:::

### D4 · 零空间与值域

写出 $N(T)$、$R(T)$ 的集合定义；它们分别是**谁**的子空间？与单射、满射的关系？两个维数的名字叫什么？

::: sol D4 核对

$N(T)=\{\boldsymbol x\in V\mid T\boldsymbol x=\boldsymbol\theta'\}\le V$（定义域一侧）；$R(T)=\{T\boldsymbol x\mid\boldsymbol x\in V\}\le W$（陪域一侧）（[@thm-2.2.4]）。$T$ 单射 $\iff N(T)=\{\boldsymbol\theta\}$（[@thm-2.2.2]）；满射 $\iff R(T)=W$。维数分别是**零度**与**秩**——只依赖 $T$，与基无关。
:::

### D5 · 矩阵的读法

$A$ 的**第 $j$ 列**是什么？它依赖哪两组基？改变基时矩阵按什么公式变？

::: sol D5 核对

第 $j$ 列 $=$ 第 $j$ 个**出发端基向量**的像在**到达端基**下的坐标（[@def-2.3.1]）——是列不是行；依赖**两组**基（出发端 $\boldsymbol\varepsilon$、到达端 $\boldsymbol\eta$）。换基公式：$B=P^{-1}AQ$（左边管出发端、右边管到达端，注意「矩阵贴着旧基一侧」的口诀方向）；同一空间换同一组基（相似）时 $Q=P$，得 $B=P^{-1}AP$（[@thm-2.3.5]、[@cor-2.3.4]）。
:::

### D6 · 同构映射

定义（双射 + 保持运算）；有限维下判别的**唯一**条件是什么？最容易漏的前提是什么？

::: sol D6 核对

同构映射：双射且 $T(a\boldsymbol x+b\boldsymbol y)=aT\boldsymbol x+bT\boldsymbol y$（[@def-2.3.2]）。有限维判别：**维数相等**（$n$ 维都同构于 $F^n$，[@cor-2.3.1]、[@thm-2.3.3]）。易漏前提：**同一数域**——$\mathbb C$ 作为 $\mathbb R$-空间与作为 $\mathbb C$-空间维数不同（2 与 1）；等势只是集合层面，不能替代维数。
:::

### D7 · 特征值与特征向量（矩阵版与变换版）

定义式里哪一个词是「定义的一部分」、不能默许省略？两个版本如何互相翻译？

::: sol D7 核对

矩阵版：存在**非零**向量 $\boldsymbol\alpha$ 使 $A\boldsymbol\alpha=\lambda\boldsymbol\alpha$（[@def-eig-matrix]）——「非零」是定义的一部分；变换版：$T\boldsymbol\alpha=\lambda\boldsymbol\alpha$，$\boldsymbol\alpha\ne\boldsymbol\theta$（[@def-eig-transform]）。互相翻译：矩阵给坐标、变换给向量本身——若题给变换而要求「特征向量」，解完坐标还要乘回基（[@method-eig-procedure] 最后一行，[2.4](sec24.md#sec-2.4.1)）。
:::

### D8 · 特征子空间

$V_\lambda$ 的集合定义是什么？它包含零向量吗？「特征向量的全体」是子空间吗？

::: sol D8 核对

$V_\lambda=\{\boldsymbol x\mid T\boldsymbol x=\lambda\boldsymbol x\}=N(T-\lambda I)$，是子空间、**包含零向量**（[@def-eigenspace]）。「特征向量全体」**不是**子空间——拿掉了零向量，加法也不封闭（两个特征向量之和可能不再是特征向量）。几何重数就是 $\dim V_\lambda$（[@thm-geom-mult]）。
:::

### D9 · 几何重数与代数重数

各是什么？大小关系如何？「可对角化」与它们的关系（一句话判据）？

::: sol D9 核对

几何重数 $=\dim V_\lambda$；代数重数 $=$ $\lambda$ 作为特征多项式根的重数（[@def-eigenspace]、[@thm-mult-ineq]）。恒有 $1\le$ 几何 $\le$ 代数（[@thm-mult-ineq]）。判据：**处处取等号 $\iff$ 可对角化**；$n$ 个互异特征值是充分条件（[@thm-eig-independent]），不是必要条件。
:::

### D10 · 正交矩阵与酉矩阵

各写出定义式；正交是酉的什么？列向量受什么约束（列刻画）？

::: sol D10 核对

实方阵 $A^{\mathrm T}A=I$；复方阵 $A^{\mathrm H}A=I$（[@def-orth-matrix]）。正交矩阵是**实特例**（实矩阵的 $A^{\mathrm H}=A^{\mathrm T}$）。列刻画：各列构成单位圆上的标准正交基——$A^{\mathrm T}A=I$ 的 $(i,j)$ 元即 $(\boldsymbol a_i,\boldsymbol a_j)$，逐元读出来就是「长度 1、两两正交」（[@thm-orth-columns]）。
:::

### D11 · Givens 旋转矩阵

它长什么样（作用在哪个平面）？用来干什么？$\det$ 是多少？连乘时总变换按什么顺序写？

::: sol D11 核对

$T_{ij}$ 只在 $(i,i),(i,j),(j,i),(j,j)$ 四个位置与单位阵不同，其余是单位块：在坐标平面 $(i,j)$ 内旋转（[@def-givens]）。用途：**清零一个指定分量**（[@thm-givens-zero]）——选角使目标分量为零，可精确手算。$\det T_{ij}=+1$（旋转，[@thm-givens-props]）。连乘：总变换 $T=T_k\cdots T_1$，作用顺序**反着写**（每次新的旋转左乘在总积外面）。
:::

### D12 · Householder 矩阵

写出定义式；它几何上是「投影」还是「镜像」？四条代数性质（对称、$H^2$、$\det$、保范）能否数全？怎样用它把向量对准 $\boldsymbol e_1$？

::: sol D12 核对

$H=I-2\boldsymbol\omega\boldsymbol\omega^{\mathrm T}$（$\|\boldsymbol\omega\|=1$），关于超平面 $\boldsymbol\omega^{\perp}$ 的**镜像**（[@def-householder]）——不是投影（投影幂等且降秩，镜像可逆）。性质：对称 $H^{\mathrm T}=H$、对合 $H^2=I$、$\det H=-1$、保长度（正交矩阵）（[@thm-householder-props]）。对准：取 $\boldsymbol\omega$ 为 $\boldsymbol x-\|\boldsymbol x\|\boldsymbol e_1$ 方向的单位向量，则 $H\boldsymbol x=\|\boldsymbol x\|\boldsymbol e_1$（[@method-givens-align] 的对偶版）。
:::

## B. 定理卡

### T1 · 线性映射的判据与「保持线性组合」

写出定义级判据（两条）与定理级的加强（一条）；证明「$T$ 是线性的」标准格式是什么？

::: sol T1 核对

定理 2.2.1：$T$ 线性 $\iff$ 对任意 $\boldsymbol x_i,k_i$ 有 $T(\sum k_i\boldsymbol x_i)=\sum k_iT\boldsymbol x_i$。证明格式：**先证是映射**（每个向量有唯一像），**再验两条**（可加、齐次）——「先证是映射、再验两条」（[@thm-2.2.1]）。快捷否证：先算 $T(\boldsymbol\theta)$。
:::

### T2 · 单射判据

写出当且仅当命题的完整形式；使用时先核对什么前提？为什么它是「考试默认工具」？

::: sol T2 核对

$T$ 单射 $\iff$ 对**任意**整组向量 $\boldsymbol x_1,\cdots,\boldsymbol x_m$：$\{T\boldsymbol x_i\}$ 线性无关 $\iff$ $\{\boldsymbol x_i\}$ 线性无关（[@thm-2.2.2]）。前提：**整组**向量逐个检验（不是只看单个向量的 $T\boldsymbol x\ne\boldsymbol\theta$）。它把「映射层面的单射」翻译成「集合层面的无关性」，是判定可逆、构造同构、证亏加秩的通用引擎（去年考题就考它，见 [2.2](sec22.md#sec-2.2.5)）。
:::

### T3 · 亏加秩定理

写出等式；证明的两半各是什么？哪一个方向用基扩充？

::: sol T3 核对

$\dim N(T)+\dim R(T)=\dim V$（[@thm-2.2.5]）。两半：① $R(T)=\operatorname{span}\{T(h_1),\cdots,T(h_r)\}$——取出发端一组基，核向量映零、其余像张成值域；② 这组像**线性无关**（若相关，组合落进核，与基的表示唯一性矛盾）。$\dim R(T)=r=\dim V-\dim N(T)$。课堂只证到 ① 的目标处下课，② 由本编补完（[2.2.5](sec22.md#sec-2.2.5)）。
:::

### T4 · 存在唯一性定理（由基像定映射）

精确陈述「存在唯一」的双方各指什么？这条定理的两大用途（造映射 / 反推基）？

::: sol T4 核对

设 $\boldsymbol\varepsilon_1,\cdots,\boldsymbol\varepsilon_n$ 是 $V$ 的基，任给 $\boldsymbol\eta_1,\cdots,\boldsymbol\eta_n\in W$，则**存在唯一**线性映射 $T$ 使 $T\boldsymbol\varepsilon_j=\boldsymbol\eta_j$（[@thm-2.3.1]）。存在：对任意 $\boldsymbol x=\sum x_j\boldsymbol\varepsilon_j$ 令 $T\boldsymbol x=\sum x_j\boldsymbol\eta_j$（表示唯一性保证良定义）；唯一：两个映射在基上相同 $\Rightarrow$ 处处相同。「造映射」的标准手法；反向用法：把目标矩阵反推成基像，解出基向量——[2.4](sec24.md#sec-2.4.4) 的「设计基」考题就是它。
:::

### T5 · 坐标公式与换基公式

写出坐标公式 $\beta=A\alpha$ 的含义；换基公式左右两个因子各管哪一端？为什么「矩阵贴着旧基一侧」？

::: sol T5 核对

坐标公式：$\beta=A\alpha$，其中 $\alpha$ 是出发端坐标、$\beta$ 是到达端坐标（[@thm-2.3.4]）——矩阵把抽象映射化成「列向量乘矩阵」。换基：$B=P^{-1}AQ$，$Q$ 把新出发端坐标送回旧出发端、$P^{-1}$ 把旧到达端坐标送进新到达端（[@thm-2.3.5]）。「贴着旧基」的口诀：$A$ 始终读在旧基上，两侧的换基矩阵负责**翻译**新坐标（[1.3](../ch01/sec13.md#sec-1.3.7) 的同一口诀在矩阵版）。
:::

### T6 · 相似不变量

相似保留哪些量？写出证明的入口（一行）？「特征值相同」里重数算不算？

::: sol T6 核对

$B=P^{-1}AP$ 保持：特征多项式（从而特征值**含重数**）、迹、行列式、秩（[@thm-sim-invariants]）。证明入口：$\det(\lambda I-B)=\det\big(P^{-1}(\lambda I-A)P\big)=\det(\lambda I-A)$；迹用 $\operatorname{tr}(XY)=\operatorname{tr}(YX)$；秩用「乘可逆矩阵不改变秩」。**相似不变量清单是概念判断题的底本**——做题先问「这个量变不变」。
:::

### T7 · 不同特征值的特征向量线性无关

陈述；证明第一行是什么？推论「$n$ 个互异特征值 ⟹ 可对角化」怎么来的？

::: sol T7 核对

属于**互异**特征值的特征向量组线性无关（[@thm-eig-independent]）。证明第一行：在 $\sum k_i\boldsymbol\alpha_i=\boldsymbol\theta$ 上作用 $T$，得 $\sum k_i\lambda_i\boldsymbol\alpha_i=\boldsymbol\theta$，与原式消项。推论：$n$ 阶方阵有 $n$ 个互异特征值时，特征向量凑满 $n$ 个、线性无关，直接拼成过渡矩阵即对角化——互异是**充分**不必要（重根也可对角化，只要几何重数够）。
:::

### T8 · 几何重数与可对角化判据

写出判据；「设计基使矩阵为指定形式」的标准流程（若考到反向题）？

::: sol T8 核对

可对角化 $\iff$ 每个特征值的几何重数 $=$ 代数重数（[@thm-geom-mult]、[@thm-mult-ineq]）。设计基流程（[@method-design-basis]、[@method-eig-procedure]）：① 写出**目标形式矩阵** $\Lambda$；② 反推 $T$ 在目标基上的像（$T\boldsymbol\varepsilon_j=$ 第 $j$ 列的组合）；③ 解方程解出基向量；④ 验算 $T$ 在**新基**下的过渡矩阵使 $A=P^{-1}\Lambda P$ 或直接核验 $T$ 的作用。考点提示：这是上一届考题（2.4 课堂原话）。
:::

### T9 · 幂、逆与多项式的特征值

$A^m$、$A^{-1}$、$\varphi(A)$ 的特征值各是什么？前提呢？这条结论为什么在 3.5 又出现一次？

::: sol T9 核对

$A^m$ 特征值 $\lambda_i^m$；$A$ 可逆时 $A^{-1}$ 特征值 $\lambda_i^{-1}$（[@thm-eig-power]）；一般 $\varphi(A)$ 特征值 $\varphi(\lambda_i)$（3.5 的谱映射 [@cor-3.5.1]，用 Schur 型证明）——2.4 的版本是这条的先行特款。前提：特征值按**同一特征向量**对应，不能跨特征向量混搭；幂与逆只对相应特征值逐点作用。3.5 用三角化把散装的「幂 / 逆」一句话统一为「任何多项式」。
:::

### T10 · 正交 / 酉矩阵的运算性质

数一数：逆与转置、乘积、$\det$、特征值的模。哪一条最容易写错成「特征值 $=\pm1$」？

::: sol T10 核对

$A^{-1}=A^{\mathrm T}$（酉：$A^{-1}=A^{\mathrm H}$）；乘积仍正交（酉）；$\det A=\pm1$（酉：$|\det A|=1$）；特征值满足 $|\lambda|=1$（[@thm-orth-algebra]、[@thm-orth-eig]）。易错：**实正交阵的特征值完全可以是复数**（旋转阵 $\pm\mathrm i$），「模为 1」不等于「$\pm1$」——后者只在实特征值上成立（[@errata-orth-false]，考点注记 01:09:19）。
:::

### T11 · 正交变换 / 酉变换的四条等价刻画

背书四条的完整形式；「保内积」与「保长度」为什么等价（证明用到什么）？

::: sol T11 核对

$T$ 正交（酉）$\iff$ 保内积 $\iff$ 保长度 $\iff$ 把标准正交基映为标准正交基 $\iff$ 矩阵满足 $A^{\mathrm H}A=I$（[@thm-orth-equiv]）。「保内积 $\Rightarrow$ 保长度」显然；反向用**极化恒等式**：内积可由长度多项式表示，保长度逐项代入即保内积（复情形用两式组合）。对号入座时先看题给的是「变换」还是「矩阵」。
:::

### T12 · Givens 的分量清零

要清零 $\boldsymbol x=(x_i,\cdot,x_j)^{\mathrm T}$ 的 $x_j$，取什么角？「逐次清零」时每一步取角的对象是什么？

::: sol T12 核对

取 $\cos\varphi,\sin\varphi$ 使 $\binom{x_i\cos\varphi+x_j\sin\varphi}{\ -x_i\sin\varphi+x_j\cos\varphi}$ 的第二分量为零（即 $c=x_i/\sqrt{x_i^2+x_j^2}$、$s=x_j/\sqrt{x_i^2+x_j^2}$ 的适当符号组合）（[@thm-givens-zero]、[@method-givens-align]）。逐次清零时**每一步都要用更新后的向量取角**——不是原向量（这是最容易偷懒出错的地方，2.5 考情注记点名「变形点」）。
:::

### T13 · Householder 记号下的镜像

写出 $H$ 的四条性质；造「把 $\boldsymbol x$ 对准 $\boldsymbol e_1$」的 $H$ 时 $\boldsymbol\omega$ 取什么？为什么 $H$ 不是投影？

::: sol T13 核对

性质：对称、$H^2=I$、$\det H=-1$、正交（保范）（[@thm-householder-props]）。取 $\boldsymbol\omega=\dfrac{\boldsymbol x-\|\boldsymbol x\|\boldsymbol e_1}{\|\boldsymbol x-\|\boldsymbol x\|\boldsymbol e_1\|}$，则 $H\boldsymbol x=\|\boldsymbol x\|\boldsymbol e_1$（[@method-givens-align] 的 Householder 版）。不是投影：投影满足 $P^2=P$ 且不可逆（降维），镜像 $H^2=I$ 可逆、只翻方向不改长度——判断题常拿「$H$ 是投影」当错项。
:::

## C. 一张白纸的最终测试

在白纸中央写「线性映射」，闭卷画出下面这条链，并在每条箭头上写出连接理由：

$$
\text{映射}
\longrightarrow \text{线性映射}
\longrightarrow N(T)\ / \ R(T)
\longrightarrow \text{矩阵}
\longrightarrow \text{相似}
\longrightarrow \text{特征对}
\longrightarrow \text{正交 / 酉}.
$$

然后默写 T2、T4、T5、T6、T8 五条定理。它们分别负责本章最常见的五类动作：**判定、构造、落地、比较、化简**。最后加试一组「考试信号」：① 复述单射判据的**整组**前提并给一个反例；② 写出 2.5 的四条等价刻画并指出哪一条是「去年考题」的形态（设计基）；③ 说明「正交矩阵特征值的模为 1」为什么不能写成「$=\pm1$」，并说出反例矩阵。三组全部通过，第二章才算「可以调用」。
