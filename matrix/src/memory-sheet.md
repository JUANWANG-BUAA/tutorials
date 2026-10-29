# 速查背记卡：每件事的最小可背诵单元

[闭卷回忆卡](ch01/recall-cards.md)（[一](ch01/recall-cards.md) / [二](ch02/recall-cards.md) / [三](ch03/recall-cards.md)）是**检索练习**（先想、再核对）；这一页是**压缩层**（先把要背的东西压到最短，再去背）。两者配合：在这里把一句话记住，去那里检验能不能从空白纸上叫出来。

::: note 怎么用这一页
- 每一条都是「**最小可背诵单元**」——不是完整陈述，而是**能让你把完整陈述复述出来**的那根钩子。
- 背不下来时**回正文核对**，不要在这里硬记：压缩层的作用是索引，不是替代品。
- 本页覆盖**四章**：A / B 表各分四段——**A1/B1 第一章**、**A2/B2 第二章**、**A3/B3 第三章**、**A4/B4 第四章（4.1–4.3）**；D / E / F 表各章混排。
- 建议顺序：**先读 A / B 建立骨架 → 用 D 的口诀加固 → 用 E 的对比表分清易混 → 用 F 的反例守住边界**。
- **背完之后去做题**：题型流程、二级结论与验算清单在[解题工具箱](toolbox.md)，限时训练在[考场竞技场](ch03/arena.md)（第三章）。
- 想做成间隔复习卡，见文末「导出到 Anki」。
:::

## A. 定义：一句话 + 最容易漏的那个条件

**A1 · 第一章（线性空间）**

| 概念 | 一句话 | 最容易漏 |
|:--|:--|:--|
| **数域** $F$ | 含 $0,1$、对四则运算封闭的数集 | 含 $0$ 与 $1$；除法要排除除数为零 |
| **加群** $(V,+)$ | 集合 + 加法：封闭、结合、有零元、有负元（且交换） | 零元与负元是**存在性**条件，必须亲验 |
| **线性空间** | 加群 + 数域上的数乘，四条相容律 | 单位律 $1\boldsymbol{\alpha}=\boldsymbol{\alpha}$ **不能省**（唯一不能由其余推出的） |
| **子空间** $W\le V$ | $W\subseteq V$ 非空，且对线性组合封闭 | 「非空」不能省；运算必须**继承**，不能另定 |
| **线性相关** | 存在**非平凡**零组合 | 不是「和为零」，而是「系数可以不全是零」 |
| **线性无关** | 零组合只有**平凡**解 | — |
| **极大无关组 / 秩** | 无关 + 能表示组内每个向量；个数叫秩 | 极大无关组**不唯一**，但**个数唯一**（这才是秩良定义的依据） |
| **基** | 无关 **且** 张成全空间 | 两个条件缺一不可：「够用」+「无冗余」 |
| **坐标** | 在指定基下的唯一系数列 | 坐标依赖基，**不是**向量的固有属性 |
| **过渡矩阵** $P$ | 使「新基 $=$ 旧基 $\times P$」的可逆矩阵 | $P$ 的第 $j$ 列是**新基**第 $j$ 个向量在**旧基**下的坐标 |
| **维数** | 基所含向量个数 | 依赖数域：$\dim_{\mathbb R}\mathbb C=2$，$\dim_{\mathbb C}\mathbb C=1$ |
| **内积** $(\boldsymbol x,\boldsymbol y)$ | 共轭对称 + 对**第一**变元线性 + 正定 | 复空间必须**共轭**转置；正定要求「非零向量长度不为零」 |
| **长度** | $\|\boldsymbol x\|=\sqrt{(\boldsymbol x,\boldsymbol x)}$ | 复空间里是 $\sqrt{\sum|x_i|^2}$，**不是** $\sqrt{\sum x_i^2}$ |
| **正交** | $(\boldsymbol x,\boldsymbol y)=0$ | 复空间中正交**不能**用 $\arccos$ 判定 |
| **标准正交基** | 两两正交 + 每个向量长度为 $1$ | 「正交基」只要求正交，不要求长度是 $1$ |
| **度量（Gram）矩阵** | 固定基后记录两两内积：$g_{ij}=(\boldsymbol{\varepsilon}_j,\boldsymbol{\varepsilon}_i)$ | 下标**反着**放；且**必须先固定基**才谈它 |
| **直和** $W_1\dotplus W_2$ | 和空间中**每个**向量拆法唯一 | 定义写的是「**每个**」；但由判定定理，「**存在一个**」也等价（不唯一性可平移，见 F 表） |
| **投影** | 直和分解 $\boldsymbol x=\boldsymbol y+\boldsymbol z$ 中的分量 $\boldsymbol y$ | **必须说清沿哪个补空间**——投影依附于整个分解 |
| **正交补** $W^{\perp}$ | 与 $W$ 中**每个**向量都正交的向量全体 | 离开内积就没有定义（不是线性结构自带的） |
| **正交投影** | 沿**正交补**落下的投影 | 由 $W$ 与内积**唯一确定**，所以谈它时不必提补空间 |

**A2 · 第二章（线性映射与矩阵）**

| 概念 | 一句话 | 最容易漏 |
|:--|:--|:--|
| **映射 / 像 / 原像** | 按规则给每个原像指定唯一像 | 「唯一」是对**每个**原像说的；原像可以不唯一 |
| **单射 / 满射 / 双射** | 不同原像不同像 / 值域 $=$ 陪域 / 两者兼备 | 单射看**原像**是否打架，满射看**陪域**是否被铺满——两者互不蕴含 |
| **可逆映射** | 存在 $T^{-1}$ 使两个复合都是恒等 | 等价于**双射**；逆映射**唯一** |
| **变换 / 一一变换 / 置换** | $V	o V$ 的映射 / 可逆变换 / $V$ 到自身的双射 | 「置换」是 $V$ 上的双射，不需要线性（[@def-2.1.6]） |
| **线性映射 $T\in L(V,W)$** | 可加 $+$ 齐次（等价于 $T(a\boldsymbol x+b\boldsymbol y)=aT\boldsymbol x+bT\boldsymbol y$） | 两条**缺一不可**；且要求 $V,W$ 是**同一数域**上的空间 |
| **零空间 $N(T)$** | $V$ 中被映成 $\boldsymbol{	heta}'$ 的向量全体 | 是 $V$ 的**子空间**（不是 $W$ 的）；$T$ 单射 $\iff N(T)=\{\boldsymbol{	heta}\}$ |
| **值域 $R(T)$** | 全体像构成的集合 | 是 $W$ 的**子空间**；$\dim R(T)=$ 秩 |
| **零度 / 秩** | $\dim N(T)$ / $\dim R(T)$ | 两个数都**只依赖 $T$**，与基的选取无关 |
| **$L(V,W)$** | 所有线性映射的集合，按点式加法与数乘构成线性空间 | 运算定义在**像**上：$(S+T)\boldsymbol x=S\boldsymbol x+T\boldsymbol x$ |
| **矩阵的读法** | $A$ 的第 $j$ 列 $=$ 第 $j$ 个基向量的像的坐标 | 是**列**不是行；且依赖**两组**基的选取 |
| **同构映射** | 双射且保持线性运算 | 由 $L(V,W)$ 中**可逆**元素给出；等势只是集合层面，同构还要求**数域相同** |
| **相抵 / 相似 / 合同** | $B=PAQ$ / $B=P^{-1}AP$ / $B=P^{\mathrm H}AP$ | 相似只对**方阵**；三者不变量不同（见 E 表） |
| **特征值 / 特征向量** | 存在**非零** $\boldsymbol x$ 使 $T\boldsymbol x=\lambda\boldsymbol x$ | 「非零」是定义的一部分；$T$ 必须是 $V	o V$ 的**线性变换** |
| **特征子空间 $V_\lambda$** | $V_\lambda=\{\boldsymbol x\mid T\boldsymbol x=\lambda\boldsymbol x\}=N(T-\lambda I)$ | 它**包含 $\boldsymbol{	heta}$**，而「特征向量全体」不包含——后者不是子空间 |
| **几何重数 / 代数重数** | $\dim V_\lambda$ / $\lambda$ 作为特征多项式根的重数 | 恒有 $1\le$ 几何 $\le$ 代数；能对角化 $\iff$ 处处取等号 |
| **正交（酉）矩阵** | $A^{\mathrm T}A=I$（$A^{\mathrm H}A=I$） | 实正交是酉的特例；列向量构成**标准正交基** |
| **正交（酉）变换** | 保持内积的线性变换：$(T\boldsymbol x,T\boldsymbol y)=(\boldsymbol x,\boldsymbol y)$ | 等价于保长度、等价于把标准正交基映为标准正交基 |
| **Givens 旋转 $T_{ij}$** | 在坐标平面 $(i,j)$ 内旋转，用来**清零一个分量** | $\det T_{ij}=+1$；连乘时总变换按作用顺序**反**写 |
| **Householder 反射 $H$** | $H=I-2\boldsymbol\omega\boldsymbol\omega^{\mathrm T}$（$\|\boldsymbol\omega\|=1$），关于 $\boldsymbol\omega^{\perp}$ 照镜子 | 是**镜像不是投影**：$H^2=I$、对称、$\det H=-1$ |

**A3 · 第三章（矩阵分解）**

| 概念 | 一句话 | 最容易漏 |
|:--|:--|:--|
| **相抵分解式** | $A=P^{-1}\Gamma Q$，$\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$ | 分解**式不唯一**、标准形**唯一**（由 $r$ 决定）——两句话别写反 |
| **相抵（矩阵等价）** | $A$ 经有限次初等变换化为 $B$（即 $B=P^{-1}AQ$） | 与空间的「同构」**同名不同义**；同型矩阵相抵 $\iff$ 秩相等 |
| **右逆 / 左逆** | $AB=I$ / $BA=I$ | 右逆 $\iff$ **行**满秩，左逆 $\iff$ **列**满秩；方阵情形才合一为「逆」 |
| **单侧逆不唯一** | 满秩非方阵的单侧逆有无穷多个 | 右逆的通式 $=B_0+Z$，$Z$ 的**每一列** $\in N(A)$ |
| **秩等式** | $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})=\operatorname{rank}(A^{\mathrm H})$ | 证明靠**内积正定性**（由 $N(A)=N(A^{\mathrm H}A)$ 出发）——只对实 / 复内积空间成立 |
| **满秩分解** | $A=BC$：$B$ **列**满秩（$m\times r$，列是 $R(A)$ 的基），$C$ **行**满秩（$r\times n$，列是坐标） | $B$ 不必取自 $A$ 的列（$A=I_2A$ 也是分解）；要求 $r>0$ |
| **满秩分解不唯一** | 相差一个**可逆**因子：$B_1=B_2D$、$C_1=D^{-1}C_2$ | $D$ 是两组基之间的**过渡矩阵**（必可逆）；任取可逆 $D$ 都能造新分解 |
| **伪逆雏形** | $X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}$ | 它是 $AXA=A$ 的一个解（即 Moore–Penrose 伪逆 $A^+$），**不是唯一解** |
| **QR 分解** | $A=QR$：$Q$ 酉（实：正交）、$R$ 上三角；实情形叫正交三角分解 | 「**正线**」$=$ 对角元素全为**正实数**（唯一性的开关）；不满秩仍有分解、丢唯一性 |
| **列 / 行正交规范** | $Q^{\mathrm H}Q=I_n$（方阵才叫酉矩阵） | $QQ^{\mathrm H}\ne I_m$（$m>n$）；自动列满秩、**保范**；$Q^{\mathrm H}$ 是左逆 |
| **矩阵多项式** | $\varphi(A)=\sum a_iA^i$ | 常数项补成 $a_0I$；$\varphi(A)$ 与 $A$ 可交换 |
| **零化多项式** | $g(A)=O$ | 有无穷多个（$g$ 零化则 $gh$ 也零化）；$f_A$ 与 $m_A$ 都是成员 |
| **最小多项式** | 零化多项式中**次数最小**的**首 $1$** 多项式 $m_A$ | 唯一；**整除**一切零化多项式（$m_A\mid f_A$）；与 $f_A$ **根相同**（不计重数） |
| **单纯矩阵** | 可对角化：存在可逆 $P$ 使 $P^{-1}AP=\Lambda$ | Schur 型上方 $\ast$ 全消的特例；**不等于**「有 $n$ 个互异特征值」 |
| **五条判据** | （1）$P^{-1}AP=\Lambda$；（2）$n$ 个独立特征向量；（3）$d_i=g_i$；（4）$\sum\dim E=n$；（5）$m_A$ 无重根 | 充要的是（3）（4）（5）；互异特征值、无重根零化多项式只是**充分** |
| **酉相似对角化** | 存在酉 $U$ 使 $U^{\mathrm H}AU=\Lambda$ | 等价于「有标准正交特征向量基」；$P$ 升级为 $U$，条件是正规 |
| **正规矩阵** | $A^{\mathrm H}A=AA^{\mathrm H}$ | Hermite / 反 Hermite / 酉 / 正交都是；正规 $\subset$ 单纯，反之不然 |
| **谱分解** | $A=\sum_j\lambda_jE_j$，$E_j$ 为谱阵 | $E_j=\sum_{\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$；谱阵**唯一**，$P$ 不唯一 |
| **幂等 / 正交投影** | $E^2=E$ / $E^2=E=E^{\mathrm H}$ | 幂等 $=$ 投影（$R(E)\oplus N(E)$）；Hermite 幂等才是正交投影（$R(E)\perp N(E)$） |

**A4 · 第四章（矩阵分析：范数）**

| 概念 | 一句话 | 最容易漏 |
|:--|:--|:--|
| **向量范数** | 正定 $+$ 齐次 $+$ 三角，三条公理 | **不需要内积**；内积只是充分条件 |
| **$p$-范数** | $\|x\|_p=\big(\sum|x_i|^p\big)^{1/p}$，$1\le p\le\infty$ | $0\lt p\lt1$ 三角不等式失效（只有「准范数」） |
| **范数等价** | $k_1\|x\|_\beta\le\|x\|_\alpha\le k_2\|x\|_\beta$ | 常数是**正数**不是正整数；换范数不换极限 |
| **矩阵的向量范数** | 把矩阵拉直，只查三条公理 | 只是「元素大小」，**不管乘法** |
| **矩阵范数** | 三条公理 $+$ $\|AB\|\le\|A\|\|B\|$ | 第四条保证 $\|A^k\|\le\|A\|^k$，不能反向 |
| **Frobenius 范数** | $\|A\|_F=\sqrt{\operatorname{tr}(A^{\mathrm H}A)}=\sqrt{\sum\sigma_i^2}$ | 满足乘法相容，但**不是**诱导范数 |
| **相容** | $\|Ax\|_v\le\|A\|_m\|x\|_v$ | 管「矩阵乘向量」，与「矩阵乘矩阵」不同 |
| **诱导（算子）范数** | $\|A\|=\max_{\|x\|=1}\|Ax\|_v$ | 与给定向量范数**配套且最紧**；$\|I\|=1$ |
| **列和 / 行和 / 谱** | $\|A\|_1=\max_j\sum_i|a_{ij}|$；$\|A\|_\infty=\max_i\sum_j|a_{ij}|$；$\|A\|_2=\sigma_{\max}$ | 口诀「**1 列 $\infty$ 行**」；谱范数要算 $A^{\mathrm H}A$ |
| **Rayleigh 商** | $R(x)=x^{\mathrm H}Ax/x^{\mathrm H}x$，$\lambda_n\le R\le\lambda_1$ | Hermite 矩阵才有这套上下界 |

## B. 定理：触发词 → 第一动作

看到左边，就应该想起右边；想不起就回对应小节。

> 本表是**检索索引**：按「触发词」反查该调用哪条定理。若你要的是「拿到一道题先做什么」的解题顺序，见[全章总结的「看到题目，先选工具」](ch01/summary.md#看到题目先选工具)。

**B1 · 第一章（线性空间）**

| 触发词 | 该用的定理 | 第一动作 |
|:--|:--|:--|
| 「是不是子空间」 | 子空间判定定理 | 先查 $W\subseteq V$ 且 $\boldsymbol{\theta}\in W$，再验 $a\boldsymbol x+b\boldsymbol y\in W$ |
| 「表示唯一 / 坐标唯一」 | 唯一表示定理 | 假设两种表示，**相减**得零组合，用无关性逼系数相等 |
| 「无关组最多几个」 | 计数引理 | 用基表示 → 得 $n$ 个方程 $m$ 个未知量 → 未知量多于方程必有非零解 |
| 「两组基个数相同」 | 基的个数不变 | 双向计数：$m\le n$ 且 $n\le m$ |
| 「补成一组基」 | 基扩充定理 | 从无关组出发，逐个**添加**不在当前张成里的向量（加法优先） |
| 「求 $\dim(W_1\cap W_2)$」 | 维数公式 | 各求秩 → 拼矩阵求和的秩 → 代 $r_1+r_2-r_{\text{和}}$ |
| 「换基后内积怎么变」 | 合同变换 | $G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P$（左右各一个 $P$，**左侧**取共轭转置） |
| 「证明不等式 / 估计」 | Cauchy–Schwarz | 构造非负量 $\|\boldsymbol x-\lambda\boldsymbol y\|^2\ge0$，取 $\lambda$ 使残差正交 |
| 「正交组是否无关」 | 正交组必无关 | 与 $\boldsymbol x_j$ 作内积，正交性消掉其余项 |
| 「判直和」 | 直和判定定理 | **优先查交**：$W_1\cap W_2=\{\boldsymbol{\theta}\}$；只给维数时才用 (4) |
| 「正交 ⟹ 直和」 | 定理 1.6.2 | 一行：取 $\boldsymbol u\in W_1\cap W_2$，$(\boldsymbol u,\boldsymbol u)=0$ 逼出 $\boldsymbol u=\boldsymbol{\theta}$ |
| 「找补空间 / 唯一补」 | 正交分解定理 | 用 Gram–Schmidt 造前段属于 $W_1$ 的正交基，拆任意向量 |
| 「求正交投影」 | 正交基投影公式 | **先查基是否正交**：正交 → 套公式；不正交 → 先 GS 或解 Gram 方程组 |
| 「最近点 / 残差最小」 | 最佳逼近 | 拆 $\boldsymbol x-\boldsymbol w=(\boldsymbol y-\boldsymbol w)+(\boldsymbol x-\boldsymbol y)$，两项正交 → 勾股 |
| 「矩阵分解」 | Gram–Schmidt 的副产物 | $(\boldsymbol x\text{ 组})=(\boldsymbol z\text{ 组})A$，$A$ 正线上三角 → QR 雏形 |
| 「任意方阵的白送分解」 | 例 1.6.7 | $\mathbb C^n=N(A)\oplus R(A^{\mathrm H})$，三步：正交 → 秩相等 → 维数凑满 |

**B2 · 第二章（线性映射与矩阵）**

| 触发词 | 该用的定理 | 第一动作 |
|:--|:--|:--|
| 「$T$ 是不是线性的」 | 线性映射定义 | 先验 $T(\boldsymbol{\theta})=\boldsymbol{\theta}'$（最快否证法），再验 $T(a\boldsymbol x+b\boldsymbol y)=aT\boldsymbol x+bT\boldsymbol y$ |
| 「求 $T$ 的像 / 核」 | $N(T)$、$R(T)$ 的定义 | 解 $T\boldsymbol x=\boldsymbol{\theta}'$ 得核；把 $T$ 作用在**一组基**上，张成值域 |
| 「核与值域维数关系」 | 亏加秩定理 | $\dim N(T)+\dim R(T)=\dim V$；先算好算的那个，另一个用减法 |
| 「$T$ 是不是单射」 | 单射判据（三种等价说法） | 首选 $N(T)=\{\boldsymbol{\theta}\}$（比直接证 $T\boldsymbol x=T\boldsymbol y\Rightarrow\boldsymbol x=\boldsymbol y$ 快） |
| 「$T$ 是不是满射 / 双射」 | 维数相等时的单射 $\iff$ 满射 | 只在 $\dim V=\dim W$ 时可用；否则必须分别验 |
| 「由基上的像定映射」 | 存在唯一性定理 | 先在一组**基**上随意指定像，再线性延拓——这是「造映射」的标准手法 |
| 「$T$ 的矩阵是什么」 | 矩阵的读法 | 逐个算 $T(\boldsymbol\varepsilon_j)$，把它的**坐标写成第 $j$ 列** |
| 「换基后矩阵怎么变」 | 换基公式 | $B=P^{-1}AQ$；同一空间换基（相似）时 $Q=P$，得 $B=P^{-1}AP$ |
| 「两个矩阵像不像」 | 同构 $\iff$ 维数相等 | 先比形状与维数，再用相抵/相似/合同对号（见 E 表） |
| 「矩阵的秩 = 映射的秩」 | 定理 2.3.6 | 把 $A$ 看成某个 $T$ 的矩阵，则 $\operatorname{rank}A=\dim R(T)$ |
| 「求特征值」 | 特征多项式 | 解 $\det(\lambda I-A)=0$；**先算 $\operatorname{tr}A$ 与 $\det A$ 备用验算** |
| 「求特征向量」（矩阵给的） | 解 $(A-\lambda I)\boldsymbol x=\boldsymbol 0$ | 求基础解系；**若题给的是变换，还要乘回基** $\boldsymbol\xi=(\boldsymbol\varepsilon_1,\cdots)\boldsymbol\alpha$ |
| 「能不能对角化」 | 几何重数 $\le$ 代数重数 | 逐个特征值比两种重数；全取等号才可对角化，$P$ 由特征向量拼成 |
| 「特征值有什么共性」 | 相似不变量 | $\operatorname{tr}A=\sum\lambda_i$、$\det A=\prod\lambda_i$，两者都是相似不变量 |
| 「$n$ 个不同特征值」 | 不同特征值的特征向量线性无关 | 直接可对角化（互异是**充分**不必要） |
| 「设计一组基使矩阵为指定形式」 | 反向考题 | 把想要的矩阵反推成 $T$ 在目标基上的作用，再解出基向量 |
| 「正交矩阵有什么性质」 | 四条等价刻画 | 保内积 $\iff$ 保长度 $\iff$ 标准正交基 $\to$ 标准正交基 $\iff$ $A^{\mathrm H}A=I$ |
| 「正交矩阵的特征值」 | 特征值模为 $1$ | 由 $\|U\boldsymbol x\|=\|\boldsymbol x\|$ 得 $|\lambda|=1$；**复特征值完全可能**，别写「必为 $\pm1$」 |
| 「怎么把某个分量清零」 | Givens 旋转 | 取角使 $\cos\varphi,\sin\varphi$ 把目标分量消掉；每步用**更新后**的向量取角 |
| 「怎么把一个向量对准 $\boldsymbol e_1$」 | Householder 反射 | 取 $\boldsymbol\omega$ 为 $\boldsymbol x-\|\boldsymbol x\|\boldsymbol e_1$ 方向的单位向量，则 $H\boldsymbol x=\|\boldsymbol x\|\boldsymbol e_1$ |

**B3 · 第三章（矩阵分解）**

| 触发词 | 该用的定理 | 第一动作 |
|:--|:--|:--|
| 「任给矩阵能拆出什么」 | 引理 3.1.1（相抵标准形） | 先求秩 $r$；用分块矩阵 $\begin{bmatrix}A&I\\I&*\end{bmatrix}$ 做行 / 列变换，读出 $E=P$、$F=Q^{-1}$，验算 $EAF=\Gamma$ |
| 「$AB=I$ 说明了什么」 | 定理 3.1.1（单侧逆） | 先看**方向**：$AB=I$ 问右逆（要行满秩），$BA=I$ 问左逆（要列满秩）；方阵情形才直接说「可逆」 |
| 「要造一个右逆」 | 法 1 相抵 / 法 2 公式 | 法 2 快：先由 [@prop-3.1.1] 得 $\operatorname{rank}(AA^{\mathrm H})=m$，再取 $B=A^{\mathrm H}(AA^{\mathrm H})^{-1}$ |
| 「$A^{\mathrm H}A$ 能不能求逆」 | $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)$ | 可逆 $\iff$ $A$ 列满秩；换成 $A^2$ 就失效 |
| 「把矩阵写成两个满秩矩阵之积」 | 满秩分解定理 | 选 $R(A)$ 的一组基做 $B$（常用 $A$ 的主元列），坐标拼成 $C$；回代验 $BC=A$ |
| 「给定 $B$ 求 $C$」 | 单侧逆公式 | $C=(B^{\mathrm H}B)^{-1}B^{\mathrm H}A$（$B$ 列满秩）；对偶地 $B=AC^{\mathrm H}(CC^{\mathrm H})^{-1}$ |
| 「两种满秩分解什么关系」 | 定理 3.2.2 | $B_1=B_2D$、$C_1=D^{-1}C_2$，$D$ 可逆（过渡矩阵）；先证 $R(B_1)=R(A)=R(B_2)$ |
| 「解 $AXA=A$」 | 满秩分解 | 代 $A=BC$ 得 $CXB=I_r$（**充要**），构造 $X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}$ |
| 「求 QR 分解」 | 定理 3.4.1（GS 即算法） | 逐列 GS：对角元取**残差范数** $\|\boldsymbol y_k\|$，上三角元取 $(\boldsymbol a_k,\boldsymbol z_i)$；写完必验 $QR=A$ |
| 「QR 分解唯一吗」 | 正线约定 | 正线下唯一；去正线差**对角酉阵**（实：$2^n$ 种，[@ex-3.4.B]）；不满秩丢唯一性 |
| 「长方阵求完全分解」 | 推论 3.4.1 | $A=U\begin{bmatrix}R_1\\O\end{bmatrix}$：GS 得 $Q_1R_1$ → 补标准正交基 → 拼酉阵；补列时对**整组**重 GS（前缀原样保留） |
| 「用 QR 算法求特征值」 | 迭代式 $A_{k+1}=R_kQ_k$ | 先证 $=Q_k^{\mathrm H}A_kQ_k$（酉相似、特征值不变）；模互异不足以保证全矩阵收敛；须核对结构、初始分量与相位 |
| 「求最小多项式」 | 候选法 | $f_A$ 因式分解 → 列候选（各根重数 $1$ 到 $d_j$）→ **从低往高**试 $g(A)=O$；第一个通过即 $m_A$ |
| 「算 $g(A)$ / $A^m$ / $A^{-1}$」 | H–C 降次三件套 | $g(A)$ 除 $m_A$ 最省；$A^m$ 在特征值处定系数；$A^{-1}=-\frac{1}{a_0}(\cdots)$，$a_0=(-1)^n\det A$ |
| 「为什么对角元是特征值」 | QR 算法 + 相似 | 迭代链 $A_k=(Q_1\cdots Q_{k-1})^{\mathrm H}A(Q_1\cdots Q_{k-1})$ 保持相似；极限上三角阵对角元即特征值 |
| 「能不能对角化」 | 定理 3.6.1（五条判据） | 先算 $g_i=n-\operatorname{rank}(A-\lambda_iI)$，与 $d_i$ 比；有一个 $g_i<d_i$ 就停；也可用 $m_A$ 是否无重根 |
| 「求 $P$ 使 $P^{-1}AP=\Lambda$」 | 特征向量拼列 | 每个 $\lambda_i$ 取 $g_i$ 个独立特征向量；**列序与 $\Lambda$ 对角元逐列配对**；验 $AP=P\Lambda$ |
| 「实对称 / Hermite 求正交 / 酉 $Q$」 | 推论 3.6.3 / 3.6.4 | 跨特征值自动正交；**只在重特征值内部 GS**；$Q=[\boldsymbol u_1,\cdots]$，验 $Q^{\mathrm H}AQ=\Lambda$ |
| 「这矩阵正规吗」 | 定理 3.6.2 | 算 $A^{\mathrm H}A$ 与 $AA^{\mathrm H}$ 是否相等；相等则一定可酉对角化，不等则只能普通对角化或不可 |
| 「求谱分解」 | 三步法 / 定理 3.7.2 | $P$ 按列读 $\boldsymbol\alpha_i$、$P^{-1}$ 按行读 $\boldsymbol\beta_i^{\mathrm H}$，按特征值分组；或 $E_i=f_i(A)/f_i(\lambda_i)$ |
| 「用谱分解算 $A^k$ / $f(A)$ / $e^{At}$」 | 定理 3.7.1 | $f(A)=\sum_jf(\lambda_j)E_j$；先验 $\sum E_j=I$、$E_iE_j=0$，再逐项代 |
| 「谱阵是不是正交投影」 | 命题 3.7.2 | 正规 $\Rightarrow$ $E_j^{\mathrm H}=E_j$；非正规单纯矩阵只有 $E_j^2=E_j$（斜投影） |
| 「幂等阵怎么拆空间」 | 命题 3.7.3 | $\mathbb C^n=R(E)\oplus N(E)$、$N(E)=R(I-E)$；$E\boldsymbol x=\boldsymbol x\iff\boldsymbol x\in R(E)$；$E$ 相似于 $\operatorname{diag}(I_r,0)$ |
| 「求到子空间的正交投影矩阵」 | 例 3.7.3 | $A=[\boldsymbol a_1,\cdots,\boldsymbol a_m]$ 列满秩，$E=A(A^{\mathrm H}A)^{-1}A^{\mathrm H}$；先验 $A^{\mathrm H}A$ 可逆、$E^{\mathrm H}=E$、$E^2=E$ |
| 「解最小二乘」 | 例 3.7.4 | 法方程 $A^{\mathrm H}A\boldsymbol x=A^{\mathrm H}\boldsymbol b$；$\boldsymbol x=(A^{\mathrm H}A)^{-1}A^{\mathrm H}\boldsymbol b$；拟合值 $A\boldsymbol x=E\boldsymbol b$，残差与 $R(A)$ 正交 |
| 「判断 $\lambda$ 矩阵的秩」 | 定义 3.8.2 / 注 3 | 找最高阶**不恒为零**的子式；不是逐点数值秩（$\operatorname{diag}(\lambda,\lambda)$ 的秩是 $2$，不是 $0$） |
| 「判断 $\lambda$ 矩阵可逆」 | 定理 3.8.1 | $\det A(\lambda)$ 是**非零常数**才可逆；满秩不够（$\operatorname{diag}(\lambda,\lambda+1)$ 满秩但不可逆） |
| 「$\lambda$ 矩阵怎么消元」 | 定义 3.8.4 | 三种初等变换；第三种乘子必须是**多项式**；行变换左乘、列变换右乘；初等变换保秩 |
| 「求 Smith 标准形」 | 定理 3.8.2 | 消成 $\operatorname{diag}(d_1,\cdots,d_r,0)$：$d_i$ 首 $1$、$d_1\mid\cdots\mid d_r$；除不尽时作带余除法把余式换到左上角 |
| 「行列式因子 / 不变因子互换」 | 注 | $D_k=d_1\cdots d_k$，$d_k=D_k/D_{k-1}$；$D_k$ 是全部 $k$ 阶子式的首 $1$ 最大公因式 |
| 「求初等因子」 | 定义 3.8.7 | 把每个 $d_i$ 拆成**素因子幂**，所有指数 $>0$ 的幂收进来；**重复的不能去重** |
| 「初等因子反装不变因子」 | 注 | 同一素因子的幂**从大到小**依次填 $d_r,d_{r-1},\dots$，空缺填 $1$ |
| 「两个 $\lambda$ 矩阵相抵吗」 | 定理 3.8.4 | 比「初等因子组 $\mathbf{+}$ 秩」；只比秩或只比初等因子都会错 |
| 「$A\sim B$ 怎么判」 | 定理 3.8.5 | 比 $\lambda I-A$ 与 $\lambda I-B$ 的初等因子（特征矩阵秩自动相同，秩条件可省） |
| 「写 Jordan 标准形」 | 定义 3.8.9 / 3.8.10 | 一个初等因子 $=(\lambda-\lambda_0)^s$ 对应一个 $s$ 阶块；块的分法唯一、次序自由 |
| 「$A$ 可对角化吗」 | 推论 3.8.3 | 初等因子全一次 $\iff$ 不变因子无重根 $\iff m_A$ 无重根 |
| 「求最小多项式（最快）」 | 定理 3.8.6 | $m_A=d_n=f_A/D_{n-1}$；或取初等因子的最小公倍式（指数最大者） |
| 「求 $P$ 使 $P^{-1}AP=J$」 | 例 3.8.12 | 从**最高阶**广义特征向量反推：先解 $(A-\lambda I)^s\boldsymbol v=0$ 且低一阶不为 $0$，再逐次乘 $(A-\lambda I)$ |

**B4 · 第四章（矩阵分析：范数）**

| 触发词 | 该用的定理 | 第一动作 |
|:--|:--|:--|
| 「这是不是范数」 | 定义 4.1.1（三公理） | 先查**正定性**（最常翻车：$\|x\|=|x_1-x_2|$ 不行），再查齐次；三角最后 |
| 「这是不是矩阵范数」 | 定义 4.2.2（四公理） | 前三条之后**必查 $\|AB\|\le\|A\|\|B\|$**；反例优先试 $2\times2$ |
| 「求 $\|A\|_1,\|A\|_\infty$」 | 定理 4.3.3 | 列和 / 行和取最大；口诀「1 列 $\infty$ 行」 |
| 「求 $\|A\|_2$」 | 定理 4.3.3 | 先算 $A^{\mathrm H}A$，再求最大特征值开方（$=\sigma_{\max}$） |
| 「证明两个范数等价」 | 定理 4.1.2 | 上界**算**（$\|x\|\le M\|x\|_2$），下界**紧**（反证 $+$ 单位球面有界闭） |
| 「证明矩阵范数与向量范数相容」 | 定义 4.3.1 / 定理 4.3.2 | 若矩阵范数是诱导的，直接写 $\max$ 定义；否则用 $\|Ax\|\le\|A\|\|x\|$ 逐项验 |
| 「造一个新的矩阵范数」 | 例 4.2.3 | $\|P^{-1}AP\|$；关键是 $P^{-1}ABP=(P^{-1}AP)(P^{-1}BP)$ |
| 「$I-A$ 可逆吗」 | 定理 4.3.6 | 验 $\|A\|\lt1$（任选一把好算的范数）；逆的界 $\|(I-A)^{-1}\|\le\|I\|/(1-\|A\|)$ |
| 「特征值的最大 / 最小」 | 推论 4.3.1 | Rayleigh 商：$\lambda_1=\max R$、$\lambda_n=\min R$；中间的第 $i$ 个用 Courant–Fischer |
| 「特征值被扰动多少」 | 定理 4.3.5（Weyl） | 用 $\lambda_i(A)+\lambda_n(E)\le\lambda_i(A+E)\le\lambda_i(A)+\lambda_1(E)$；$\|E\|_2\le\varepsilon$ 时漂移 $\le\varepsilon$ |

## C. 八条公理：怎么记才不丢

**分组记**：加法四条 + 数乘四条。

| 组 | 四条 | 助记 |
|:--|:--|:--|
| **加法**（说「$V$ 自身是交换群」） | 交换、结合、零元、负元 | **「换、结、零、负」** |
| **数乘**（说「数乘与两种加法相容」） | 对向量加法分配、对标量加法分配、数乘结合、单位律 | **「两分配、一结合、一单位」** |

**必考的一个反例**：只有单位律 $1\boldsymbol{\alpha}=\boldsymbol{\alpha}$ 不能由其余七条推出。反例：令 $k\cdot\boldsymbol{\alpha}\equiv\boldsymbol{\theta}$（数乘恒给零向量）——其余七条全成立，但 $1\boldsymbol{\alpha}=\boldsymbol{\theta}\ne\boldsymbol{\alpha}$。

**验证新运算时的入手点**：**先找零元与负元**（它们往往改头换面），再验其余。例：$x\oplus y=xy$ 的零元是 $1$、负元是倒数。

## D. 口诀索引（正文原话 + 出处）

| 口诀 | 说的是什么 | 出处 |
|:--|:--|:--|
| **「先看子集、再看零元、最后验任意线性组合」** | 子空间判定的固定顺序 | [1.2.2](ch01/sec12.md#sec-1.2.2) |
| **「等式/线性方程刻画 ⟹ 通常是子空间；不等式/排除性条件 ⟹ 通常不是」** | 一眼判断集合像不像子空间 | [1.2.8](ch01/sec12.md#sec-1.2.8) |
| **「解方程 = 问右端是否落在列空间里」** | $A\boldsymbol x=\boldsymbol b$ 的几何含义 | [1.2.7](ch01/sec12.md#sec-1.2.7) |
| **「矩阵贴着旧的一侧」** | 新基 $=$ 旧基 $\times P$；旧坐标 $=P\times$ 新坐标 | [1.3.7](ch01/sec13.md#sec-1.3.7) |
| **「换基不是变向量，而是换尺子」** | 坐标变、向量不变 | [1.3.7](ch01/sec13.md#sec-1.3.7) |
| **「长度由内积决定，内积变了长度就变」** | 内积才是几何的来源 | [1.5.1](ch01/sec15.md#sec-1.5.1) |
| **「不等式从非负量来，最佳系数从正交残差来」** | Cauchy–Schwarz 的证明套路 | [proof-workshop](proof-workshop.md) |
| **「减掉已有方向上的成分，留下正交残差」** | 贯穿 C–S、Gram–Schmidt、投影的母题 | [1.5](ch01/sec15.md) |
| **「死掉的部分 + 活着的部分 = 全部」** | $A^2=A$ 时 $\mathbb C^n=N(A)\dotplus R(A)$ | [1.6.4](ch01/sec16.md#sec-1.6.4) |
| **「除了零向量，两个子空间还共享别的东西吗？」** | 判直和最快的一眼 | [1.6.1](ch01/sec16.md#sec-1.6.1) |
| **「垂直落下，且是最近点」** | 正交投影的两个特征 | [1.6.7](ch01/sec16.md#sec-1.6.7) |
| **「包含 + 等维 ⟹ 相等」** | 有限维里证明两个子空间相等的省力模板 | [1.6.6](ch01/sec16.md#sec-1.6.6) |
| **「先证是映射、再验两条」** | 证明给定映射是线性映射的标准格式 | [2.2.1](ch02/sec22.md#sec-2.2.1) |
| **「同构 $=$ 双射 $+$ 保运算；判别只看维数」** | 同构的定义与判据 | 定义见 [2.3.2](ch02/sec23.md#sec-2.3.2)，判据（**同一数域、有限维**下）见 [定理 2.3.3](ch02/sec23.md#thm-2.3.3) |
| **「先减成分、再量长度」** | GS 的对角元是**残差**范数（不是 $\|\boldsymbol a_k\|$） | [3.4.1](ch03/sec34.md#sec-3.4.1)、[例 3.4.A](ch03/sec34.md#ex-3.4.A) |
| **「GS 立轴，坐标上三角」** | QR 分解 $=$ 满秩分解的正交版——第 $k$ 根梁只搭在前 $k$ 个轴上 | [3.4.1](ch03/sec34.md#sec-3.4.1) 的读法框 |
| **「正线锁相角」** | 不规定对角为正，分解就差一圈符号 / 相角（对角酉阵自由度） | [3.4.1](ch03/sec34.md#sec-3.4.1) 本编补注 |
| **「酉相似链，特征值不变」** | QR 算法每步 $A_{k+1}=Q_k^{\mathrm H}A_kQ_k$ 都是相似 | [QR 算法](ch03/sec34.md#method-qr-algo) |
| **「$f_A$ 记全部，$m_A$ 记必要」** | $f_A$ 带全重数、$m_A$ 只留必要（$I_2$：$f_A=(\lambda-1)^2$，$m_A=\lambda-1$） | [3.5.4](ch03/sec35.md#sec-3.5.4) |
| **「从低往高试」** | 候选法的试算次序不能反（低次通过则高次必通过） | [候选法](ch03/sec35.md#method-minpoly) |
| **「按次序乘因子，逐列清零」** | H–C 证明的心脏：$(\Lambda-\lambda_kI)$ 清第 $k$ 列 | [定理 3.5.4](ch03/sec35.md#thm-3.5.4) 证明 |
| **「三角化人人有份，对角化不是」** | Schur 引理的意义与边界 | [注 1](ch03/sec35.md#note-3.5-diag) |
| **「能用酉就不用一般可逆」** | 酉版本更便于计算与估计（保范、条件数 $1$） | [注 2](ch03/sec35.md#note-3.5-unitary-why) |

## E. 对比表：把易混的一次钉死

**① 一般投影 vs 正交投影**

| | 一般投影 | 正交投影 |
|:--|:--|:--|
| 沿哪个补 | 任意指定的补空间 | 只能是正交补 $W^{\perp}$ |
| 是否唯一 | 换补就变 | 由 $W$ 与内积唯一确定 |
| 残差性质 | 不一定垂直 | 残差 $\perp W$ |
| 额外身份 | — | $W$ 中离 $\boldsymbol x$ **最近**的点 |

**② 直和 $\dotplus$ vs 正交直和 $\oplus$**

$\dotplus$：拆法唯一。$\oplus$：拆法唯一 **且** 两分量互相垂直。正交自动给出直和，反之不真。

**③ 相似 vs 合同 vs 相抵**

| | 公式 | 对象 | 不变量 |
|:--|:--|:--|:--|
| **相似** | $B=P^{-1}AP$ | 同一个线性变换、同一个空间的两组基 | 特征值、行列式、迹、秩 |
| **合同** | $B=P^{\mathrm H}AP$ | 同一个内积（二次型）、同一个空间的两组基 | 秩、正定性 |
| **相抵** | $B=P^{-1}AQ$ | 同一个映射、两端各自换基（甚至不同映射） | 只有秩 |

交汇点：$P$ 是酉矩阵（$P^{\mathrm H}P=I$）时合同 $=$ 相似。

**④ 实内积空间 vs 复内积空间：哪里会失效**

| 陈述 | 实空间 | 复空间 |
|:--|:--|:--|
| Cauchy–Schwarz $\|(\boldsymbol x,\boldsymbol y)\|\le\|\boldsymbol x\|\|\boldsymbol y\|$ | ✅ | ✅（**必须带模**） |
| C–S 等号 $\iff$ 线性相关 | ✅ | ✅ |
| 夹角 $\arccos\frac{(\boldsymbol x,\boldsymbol y)}{\|\boldsymbol x\|\|\boldsymbol y\|}$ | ✅ | ❌ 无定义 |
| 正交 $\iff$ 勾股等式 | ✅ | ❌ 只有「正交 ⟹ 勾股」 |
| 内积用转置 $y^{\mathrm T}x$ | ✅ | ❌ 必须共轭转置 $y^{\mathrm H}x$ |
| 标准正交基存在 | ✅ | ✅（都限**有限维**） |

**⑤ 代数基 vs 完备正交系**

| | 代数（Hamel）基 | 完备正交系 |
|:--|:--|:--|
| 组合方式 | **有限**线性组合 | 允许**无穷级数** |
| 存在范围 | 任意线性空间（用选择公理） | 需要范数与完备性（如 $L^2$） |
| 三角函数系属于 | ❌ 不是（只能得到三角多项式） | ✅ 是（$L^2[-\pi,\pi]$ 中） |

**⑥ 和 vs 并；平凡 vs 真**

$W_1+W_2$ 一定是子空间；$W_1\cup W_2$ 一般**不是**（除非一个有包含关系）。「平凡」按「是否只有 $\{\boldsymbol{\theta}\}$ 与 $V$」分；「真」按 $W\ne V$ 分——两套划分，$\{\boldsymbol{\theta}\}$ 既平凡又真。

**⑦ 满秩分解 vs QR 分解**

| | 满秩分解 $A=BC$ | QR 分解 |
|:--|:--|:--|
| 前提 | $r>0$（不限满秩） | 方阵满秩 / 长方阵列满秩 |
| 左因子 | $B$ 列满秩（列是 $R(A)$ 的**任意**一组基） | $Q$ 酉（方阵）/ 列正交规范（长方） |
| 右因子 | $C$ 行满秩（坐标表，无形状要求） | $R$ **上三角**（正线 $+$ 唯一） |
| 不唯一程度 | 差一个**可逆因子** $D$（$B_1=B_2D$、$C_1=D^{-1}C_2$） | 正线下唯一；去正线差**对角酉阵**（实：$2^n$） |
| 关系 | **QR 是满秩分解把基掰成标准正交后的特例**（列满秩时中间因子数 $r=n$） | |

**⑧ $f_A$ vs $m_A$（都是 $A$ 的「多项式账本」，记账粒度不同）**

| | 特征多项式 $f_A$ | 最小多项式 $m_A$ |
|:--|:--|:--|
| 定义 | $\det(\lambda I-A)$ | 次数最小的首 $1$ 零化多项式 |
| 重数 | 代数重数（全记） | 必要重数（能省则省） |
| 关系 | $m_A\mid f_A$，根相同（不计重数）（[@thm-3.5.5]） | |
| 何时相等 | — | 每个特征值都「顶格」（如例 3.5.B 的 Jordan 型；$m_A=f_A$ 是常态，$I_2$ 型才是例外） |
| 用途 | 谱映射、求特征值、逆公式的系数 | 降次最省、判可对角化（无重根 $\iff$ 可对角化，超出课件范围的拓展） |

**⑨ 相似 / 正交相似 / 酉相似（同一条主线收紧到三种「换基权」）**

| | 换基矩阵 | 保什么 | 典型标准形 |
|:--|:--|:--|:--|
| **相似** | 任意可逆 $P$ | 特征值、迹、$\det$、秩（[@thm-sim-invariants]） | Schur 型（定理 3.5.1：总可以做到上三角） |
| **酉相似** | 酉 $U$ | 上面全部 $+$ 长度、内积 | Schur 型（定理 3.5.2：**每个复方阵**） |
| **正交相似**（实） | 实正交 $Q$ | 上面全部（实数域内） | 需要**特征值全实**（定理 3.5.3）；对角化时即对称阵的正交对角化 |

## F. 高频错误 → 一条反例

各节末的「常见错误清单」（1.1 的 E-a…E-f、1.2 的 E-g…E-k 等）与[全章总结](ch01/summary.md)的「典型陷阱」列，是同一批错误的**详版**与**压缩版**；本表只保留**最短反例**，供考前最后一眼核对，不替代回正文。

| 错误说法 | 反例 |
|:--|:--|
| 「对加法封闭就是子空间」 | $V_5=\{(a_1,a_2)\mid a_1\ge0\}$：加法封闭，但 $(-1)(1,0)\notin V_5$ |
| 「两两不成比例就线性无关」 | $(1,0),(0,1),(1,1)$：两两不成比例，却 $1\cdot(1,0)+1\cdot(0,1)-1\cdot(1,1)=\boldsymbol{\theta}$ |
| 「有一个向量表法唯一就是直和」 | **这条其实是对的**——非直和的不唯一性可以平移，一个漏网的都没有 |
| 「几何上互相垂直就是子空间正交」 | 墙角：两墙面的交线上取非零 $\boldsymbol u$，$(\boldsymbol u,\boldsymbol u)\ne0$ |
| 「投影公式对任意基都能用」 | $W=\mathbb R^2$、基 $(1,0),(1,1)$、$\boldsymbol y=(1,0)$：公式给出 $(\frac32,\frac12)\ne\boldsymbol y$ |
| 「内积与度量矩阵一一对应」 | 缺前提——必须**固定一组基**；换基作合同变换 |
| 「满足七条公理就是线性空间」 | 数乘恒给零向量：七条全成立，$1\boldsymbol\alpha\ne\boldsymbol\alpha$ |
| 「秩为定值的矩阵集合是子空间」 | $E_{11}+E_{22}=I$，秩从 1 跳到 2（$n\ge2$ 时） |
| 「复空间也能算夹角」 | $\mathbb C^1$ 中 $x=1,y=i$：勾股成立但 $(x,y)=-i\ne0$ |
| 「同构看元素个数」 | 无限维空间**可能**彼此等势（甚至不同构也等势，如 $\mathbb R[x]$ 与 $\mathbb R$ 作为 $\mathbb Q$-空间）；判别依据是**维数**，不是元素个数 |
| 「QR 分解的 $r_{22}$ 就是 $\|\boldsymbol a_2\|$」 | [例 3.4.A](ch03/sec34.md#ex-3.4.A)：$r_{22}=\tfrac25$ 而 $\|\boldsymbol a_2\|=\sqrt5$——对角元是**残差**范数 |
| 「实矩阵都能正交三角化」 | 旋转阵 $\begin{bmatrix}0&-1\\1&0\end{bmatrix}$：特征值 $\pm\mathrm i$ 非实 |
| 「不满秩就没有 QR 分解」 | $\begin{bmatrix}1&1\\0&0\end{bmatrix}=I_2\begin{bmatrix}1&1\\0&0\end{bmatrix}$；丢掉的只是唯一性 |
| 「正交阵特征值是 $\pm1$」 | 旋转阵 $\pm\mathrm i$（模为 $1$，不是 $\pm1$） |
| 「对角元全零即零矩阵」 | $\begin{bmatrix}0&1\\0&0\end{bmatrix}$（特征值全零却非零） |
| 「$m_A$ 恒等于 $f_A$」 | $I_2$：$f_A=(\lambda-1)^2$，$m_A=\lambda-1$ |
| 「QR 算法收敛是必然的」 | 旋转阵：正线 QR 分解是 $A=A\cdot I$，迭代原地不动（等模卡死） |
| 「$\varphi(A)$ 的特征向量也是 $A$ 的」 | $A=\operatorname{diag}(1,-1)$、$\varphi=\lambda^2$：$\varphi(A)=I$，任何向量都是它的特征向量 |
| 「$A^m$ 的特征值可以随便配对」 | 必须**按同一条特征向量**对应：$A$ 的特征值 $\lambda_i$ 对 $A^m$ 仍是第 $i$ 个位置 |

## 导出到 Anki（把这一页变成间隔复习）

```bash
python3 tools/export_cards.py                 # 生成 output/cards.tsv
python3 tools/export_cards.py --stats         # 只统计解析到多少张卡
python3 tools/export_cards.py -o my/cards.tsv # 指定输出路径
python3 tools/export_cards.py --tags          # 第三列写章标签（Anki tags 列）
python3 tools/export_cards.py --only ch03     # 只导出第三章
python3 tools/export_cards.py --only ch04     # 只导出第四章
```

脚本会把四章[闭卷回忆卡](ch01/recall-cards.md)（[一](ch01/recall-cards.md) / [二](ch02/recall-cards.md) / [三](ch03/recall-cards.md) / [四](ch04/recall-cards.md)，共 117 张）的每张卡拆成「正面 / 背面」两列 **TSV**（制表符分隔，即 Anki 导入时的「制表符」选项），输出文件自带 `#separator:tab` / `#html:true` 头，Anki 里「文件 → 导入」直接可用；公式保留 `$…$`，需装 MathJax 才渲染（方括号 id 引用会降级为纯 id 文本，方便回教程查证）。复习日程以各章回忆卡页内的说明为准（当天 / 1 / 3 / 7 天，只重做 △ 和 ×）。

> 与[解题工具箱](toolbox.md)的分工：本页（与回忆卡）解决「记不记得住」，工具箱解决「做题时怎么下手、怎么验算」——考前两页各过一遍，再把[考场竞技场](ch03/arena.md)跑一轮计时赛，三件套齐活。

## 术语索引（中英对照）

本表供检索与英文文献对照；一句话释义与上方背记卡一致，术语中列出的是全书正文里出现过的标准叫法，读到英文教材对不上名字时先来这里查。

**一 · 第一章（线性空间、子空间、基与坐标、内积、长度与夹角、直和与投影）**

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 向量 | vector | n 元有序数组，分量取自同一个数域 $F$ | [1.1.2](ch01/sec11.md#sec-1.1.2) |
| 向量空间 | vector space | 对加法与数乘封闭的 n 维向量全体 | [1.1.2](ch01/sec11.md#sec-1.1.2) |
| 数域 | field | 含 $0,1$、对四则运算封闭的数集，是数乘中「数」的资格 | [1.1.3](ch01/sec11.md#sec-1.1.3) |
| 加群 | additive group | 集合配加法：封闭、结合、有零元、有负元、交换 | [1.1.4](ch01/sec11.md#sec-1.1.4) |
| 线性空间 | linear space | 加群再加数乘，且八条公理（含单位律）全成立 | [1.1.4](ch01/sec11.md#sec-1.1.4) |
| 零向量 | zero vector | 加法零元，记 $\boldsymbol{\theta}$；与数 $0$ 不是一回事 | [1.1.5](ch01/sec11.md#sec-1.1.5) |
| 负向量 | negative vector | 使 $\boldsymbol{\alpha}+(-\boldsymbol{\alpha})=\boldsymbol{\theta}$ 的那个向量 | [1.1.5](ch01/sec11.md#sec-1.1.5) |
| 线性组合 | linear combination | $k_1\boldsymbol{\alpha}_1+\cdots+k_m\boldsymbol{\alpha}_m$ 形式的和 | [1.1.6](ch01/sec11.md#sec-1.1.6) |
| 线性表示 | linear representation | 某向量写成一组的线性组合，系数称为表示系数 | [1.1.6](ch01/sec11.md#sec-1.1.6) |
| 子空间 | subspace | 非空子集且对线性组合封闭（判定压缩成两条） | [1.2.1](ch01/sec12.md#sec-1.2.1) |
| 平凡子空间 | trivial subspace | 零子空间 $\{\boldsymbol{\theta}\}$ 与整个空间 $V$ 两个极端 | [1.2.1](ch01/sec12.md#sec-1.2.1) |
| 真子空间 | proper subspace | 不等于 $V$ 的子空间；「平凡」与「真」是两套划分 | [1.2.1](ch01/sec12.md#sec-1.2.1) |
| 零空间 | null space | $A\boldsymbol{x}=\boldsymbol{0}$ 的解集 $N(A)$，也叫核空间 kernel | [1.2.7](ch01/sec12.md#sec-1.2.7) |
| 列空间 | column space | $A$ 的列的全部线性组合，也叫值空间 range | [1.2.7](ch01/sec12.md#sec-1.2.7) |
| 张成子空间 | span | 由一组向量的一切线性组合构成的子空间 | [1.2.7](ch01/sec12.md#sec-1.2.7) |
| 和空间 | sum of subspaces | $W_1+W_2=\{w_1+w_2\}$，一定是子空间 | [1.2.5](ch01/sec12.md#sec-1.2.5) |
| 线性相关 | linear dependence | 存在不全为零的系数使线性组合等于零向量 | [1.3.1](ch01/sec13.md#sec-1.3.1) |
| 线性无关 | linear independence | 只有系数全零才能使组合为零向量 | [1.3.1](ch01/sec13.md#sec-1.3.1) |
| 极大无关组 | maximal linearly independent subset | 无关且能表示组内每个向量；个数唯一 | [1.3.4](ch01/sec13.md#sec-1.3.4) |
| 唯一表示定理 | uniqueness of representation | 用基表示向量时，表示系数唯一 | [1.3.5](ch01/sec13.md#sec-1.3.5) |
| 过渡矩阵的性质 | properties of transition matrix | 过渡矩阵必可逆，且两组基的地位对称 | [1.3.7](ch01/sec13.md#sec-1.3.7) |
| 坐标 | coordinates | 向量在指定基下的唯一系数列，依赖基而非固有 | [1.3.5](ch01/sec13.md#sec-1.3.5) |
| 过渡矩阵 | transition matrix | 新基 = 旧基 × $P$ 中的 $P$，必可逆 | [1.3.7](ch01/sec13.md#sec-1.3.7) |
| 维数 | dimension | 基所含向量的个数；依赖数域 | [1.3.8](ch01/sec13.md#sec-1.3.8) |
| 基扩充 | basis extension | 无关组可以逐个添向量扩成整个空间的一组基 | [1.3.9](ch01/sec13.md#sec-1.3.9) |
| 维数公式 | dimension formula | $\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2)$ | [1.3.9](ch01/sec13.md#sec-1.3.9) |
| 内积 | inner product | 共轭对称、对第一变元线性、正定的二元函数 | [1.4.1](ch01/sec14.md#sec-1.4.1) |
| 内积空间 | inner product space | 线性空间配上一个内积，能谈长度与正交 | [1.4.1](ch01/sec14.md#sec-1.4.1) |
| 标准内积 | standard inner product | 实空间用转置、复空间必须共轭转置的那个内积 | [1.4.2](ch01/sec14.md#sec-1.4.2) |
| Hermite·矩阵 | Hermitian matrix | 满足 $A^{\mathrm H}=A$ 的复方阵；$x^{\mathrm H}Ax$ 必为实数 | [1.4.4](ch01/sec14.md#sec-1.4.4) |
| 正定矩阵 | positive definite matrix | Hermite 且对一切非零 $x$ 有 $x^{\mathrm H}Ax>0$ | [1.4.4](ch01/sec14.md#sec-1.4.4) |
| 半正定矩阵 | positive semidefinite matrix | 把正定条件放宽成 $x^{\mathrm H}Ax\ge0$ | [1.4.4](ch01/sec14.md#sec-1.4.4) |
| 度量矩阵 | metric matrix | 固定基后记录两两内积的矩阵 $g_{ij}=(\varepsilon_j,\varepsilon_i)$，也叫 Gram 矩阵 | [1.4.6](ch01/sec14.md#sec-1.4.6) |
| 合同变换 | congruent transformation | 换基时度量矩阵按 $G_{\mathcal F}=P^{\mathrm H}G_{\mathcal E}P$ 变 | [1.4.7](ch01/sec14.md#sec-1.4.7) |
| 内积诱导的范数 | norm induced by inner product | 由 $\lVert x\rVert=\sqrt{(x,x)}$ 得到的长度 | [1.5.1](ch01/sec15.md#sec-1.5.1) |
| 长度 | length | 内积开平方 $\lVert x\rVert=\sqrt{(x,x)}$，即模 norm | [1.5.1](ch01/sec15.md#sec-1.5.1) |
| Schwarz-不等式 | Cauchy–Schwarz inequality | $\lvert(x,y)\rvert\le\lVert x\rVert\lVert y\rVert$，等号恰在线性相关时 | [1.5.2](ch01/sec15.md#sec-1.5.2) |
| 夹角 | angle | 由 $\cos\theta=(x,y)/(\lVert x\rVert\lVert y\rVert)$ 定义；复空间无定义 | [1.5.3](ch01/sec15.md#sec-1.5.3) |
| Gram·行列式 | Gram determinant | 一组向量两两内积构成的行列式，等于体积的平方 | [1.5.4](ch01/sec15.md#sec-1.5.4) |
| 正交 | orthogonal | $(x,y)=0$；复空间不能用夹角判断 | [1.5.5](ch01/sec15.md#sec-1.5.5) |
| 勾股定理 | Pythagorean theorem | 正交时 $\lVert x+y\rVert^2=\lVert x\rVert^2+\lVert y\rVert^2$ 且反向不成立 | [1.5.5](ch01/sec15.md#sec-1.5.5) |
| Gram·Schmidt | Gram–Schmidt orthogonalization | 逐个减掉已有方向上的分量，得到正交组 | [1.5.6](ch01/sec15.md#sec-1.5.6) |
| 标准正交基 | orthonormal basis | 两两正交且每个向量长度为 $1$ 的基 | [1.5.7](ch01/sec15.md#sec-1.5.7) |
| 直和 | direct sum | 和空间中每个向量拆法唯一，记 $W_1\dotplus W_2$ | [1.6.1](ch01/sec16.md#sec-1.6.1) |
| 补空间 | complementary subspace | 使 $V=W_1\dotplus W_2$ 成立的那个 $W_2$，一般不唯一 | [1.6.1](ch01/sec16.md#sec-1.6.1) |
| 投影 | projection | 直和分解 $x=y+z$ 中落在指定分量的 $y$，必须说清沿哪个补 | [1.6.3](ch01/sec16.md#sec-1.6.3) |
| 幂等矩阵 | idempotent matrix | 满足 $A^2=A$ 的方阵，自动给出 $\mathbb C^n=N(A)\dotplus R(A)$ | [1.6.4](ch01/sec16.md#sec-1.6.4) |
| 子空间正交 | orthogonal subspaces | 每一个对每一个都正交，比「墙角式垂直」强得多 | [1.6.5](ch01/sec16.md#sec-1.6.5) |
| 正交直和 | orthogonal direct sum | 拆法唯一且两个分量互相垂直，记 $\oplus$ | [1.6.5](ch01/sec16.md#sec-1.6.5) |
| 正交补 | orthogonal complement | 与 $W$ 中每个向量都正交的向量全体 $W^{\perp}$ | [1.6.6](ch01/sec16.md#sec-1.6.6) |
| 正交分解 | orthogonal decomposition | $V=W\oplus W^{\perp}$，补空间没有选择余地 | [1.6.6](ch01/sec16.md#sec-1.6.6) |
| 正交投影 | orthogonal projection | 沿正交补落下的投影，由 $W$ 与内积唯一确定 | [1.6.7](ch01/sec16.md#sec-1.6.7) |

**二 · 第二章（映射与多项式、线性映射、矩阵与同构、特征值、正交与酉变换）**

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 映射 | mapping | 按规则给每个原像指定唯一像 | [2.1.1](ch02/sec21.md#sec-2.1.1) |
| 单射 | injection | 不同原像有不同像；看原像是否打架 | [2.1.1](ch02/sec21.md#sec-2.1.1) |
| 满射 | surjection | 值域等于陪域；看陪域是否被铺满 | [2.1.1](ch02/sec21.md#sec-2.1.1) |
| 双射 | bijection | 既单又满，两个方向上都能反推 | [2.1.1](ch02/sec21.md#sec-2.1.1) |
| 复合映射 | composition | 先 $f$ 后 $g$ 的映射乘积，总按作用顺序反写 | [2.1.1](ch02/sec21.md#sec-2.1.1) |
| 可逆映射 | invertible mapping | 存在逆使两个复合都是恒等，等价于双射 | [2.1.1](ch02/sec21.md#sec-2.1.1) |
| 等势 | equipotent | 存在双射即两个集合「元素一样多」，只谈集合不论结构 | [2.1.1](ch02/sec21.md#sec-2.1.1prime) |
| 可数集 | countable set | 与自然数集等势的集合 | [2.1.1](ch02/sec21.md#sec-2.1.1prime) |
| 带余除法 | division algorithm | $f=sg+r$ 且 $\deg r\lt\deg g$，商与余式唯一 | [2.1.2](ch02/sec21.md#sec-2.1.2) |
| 公因式 | common divisor | 同时整除两个多项式的多项式 | [2.1.2](ch02/sec21.md#sec-2.1.2) |
| 公倍式 | common multiple | 同时被两个多项式整除的多项式 | [2.1.2](ch02/sec21.md#sec-2.1.2) |
| 友矩阵 | companion matrix | 把微分或差分方程的系数整整齐齐摆成的矩阵 | [2.1.2](ch02/sec21.md#sec-2.1.2) |
| 线性映射 | linear mapping | 可加且齐次的映射 $T\in L(V,W)$，两条缺一不可 | [2.2.1](ch02/sec22.md#sec-2.2.1) |
| 线性变换 | linear transformation | 定义域与陪域相同的线性映射 $V\to V$ | [2.2.1](ch02/sec22.md#sec-2.2.1) |
| 核空间 | kernel / null space | 被映成零向量的原像全体 $N(T)$，是 $V$ 的子空间 | [2.2.5](ch02/sec22.md#sec-2.2.5) |
| 值域 | range | 全体像构成的集合 $R(T)$，是 $W$ 的子空间 | [2.2.5](ch02/sec22.md#sec-2.2.5) |
| 零度 | nullity | 核空间的维数 $\dim N(T)$ | [2.2.5](ch02/sec22.md#sec-2.2.5) |
| 映射的秩 | rank of a linear map | 值域的维数 $\dim R(T)$，与基的选择无关 | [2.2.5](ch02/sec22.md#sec-2.2.5) |
| 幂等变换 | idempotent transformation | 满足 $T^2=T$ 的线性变换 | [2.2.5](ch02/sec22.md#sec-2.2.5) |
| 零变换 | zero transformation | 把每个向量都映成零向量的线性变换 | [2.2.2](ch02/sec22.md#sec-2.2.2) |
| 亏加秩定理 | rank–nullity theorem | $\dim N(T)+\dim R(T)=\dim V$，死掉的部分加活着的等于全部 | [2.2.5](ch02/sec22.md#sec-2.2.5) |
| 线性映射空间 | space of linear maps | 一切 $V\to W$ 的线性映射按点式运算构成的线性空间 $L(V,W)$ | [2.2.4](ch02/sec22.md#sec-2.2.4) |
| 矩阵的伴随 | transpose of a linear map | 取定两组基后把 $T$ 写成 $F^{m\times n}$ 中的数表 | [2.3.1](ch02/sec23.md#sec-2.3.1) |
| 同构 | isomorphism | 双射且保运算；有限维同数域下等价于维数相等 | [2.3.2](ch02/sec23.md#sec-2.3.2) |
| 坐标公式 | coordinate formula | $\beta=A\alpha$：像的坐标等于矩阵乘原像的坐标 | [2.3.3](ch02/sec23.md#sec-2.3.3) |
| 换基 | change of basis | 两端各自换基后矩阵按 $B=P^{-1}AQ$ 变 | [2.3.4](ch02/sec23.md#sec-2.3.4) |
| 换基公式 | change-of-basis formula | $B=P^{-1}AQ$；同一空间换基时 $Q=P$ 得相似 | [2.3.4](ch02/sec23.md#sec-2.3.4) |
| 矩阵的秩 | rank of a matrix | 把 $A$ 看成某个映射的矩阵，则秩等于映射的秩 | [2.3.5](ch02/sec23.md#sec-2.3.5) |
| 特征值 | eigenvalue | 存在非零向量使 $T\boldsymbol{x}=\lambda\boldsymbol{x}$ 的那个 $\lambda$ | [2.4.1](ch02/sec24.md#sec-2.4.1) |
| 特征向量 | eigenvector | 被 $T$ 作用后只变长度的非零向量 | [2.4.1](ch02/sec24.md#sec-2.4.1) |
| 特征多项式 | characteristic polynomial | $f_A(\lambda)=\lvert\lambda I-A\rvert$，根就是特征值 | [2.4.1](ch02/sec24.md#sec-2.4.1) |
| 迹与行列式 | trace and determinant | 迹是对角线之和，等于全部特征值之和；行列式等于全部特征值之积 | [2.4.2](ch02/sec24.md#sec-2.4.2) |
| 几何重数 | geometric multiplicity | 特征子空间的维数 $\dim V_\lambda$ | [2.4.3](ch02/sec24.md#sec-2.4.3) |
| 代数重数 | algebraic multiplicity | 特征值作为特征多项式根的重数 | [2.4.3](ch02/sec24.md#sec-2.4.3) |
| 特征子空间 | eigenspace | $V_\lambda=N(T-\lambda I)$，包含零向量 | [2.4.3](ch02/sec24.md#sec-2.4.3) |
| 可对角化 | diagonalizable | 两种重数处处相等；等价于有 $n$ 个线性无关的特征向量 | [2.4.3](ch02/sec24.md#sec-2.4.3) |
| 相似矩阵 | similar matrices | 同一个线性变换在不同基下的两个矩阵，$B=P^{-1}AP$ | [2.4.4](ch02/sec24.md#sec-2.4.4) |
| 相似不变量 | similarity invariant | 特征值、迹、行列式、秩在相似下都不变 | [2.4.2](ch02/sec24.md#sec-2.4.2) |
| 正交矩阵 | orthogonal matrix | 实方阵满足 $A^{\mathrm T}A=I$，列向量构成标准正交基 | [2.5.1](ch02/sec25.md#sec-2.5.1) |
| 酉矩阵 | unitary matrix | 复方阵满足 $A^{\mathrm H}A=I$，正交矩阵是它的实特例 | [2.5.1](ch02/sec25.md#sec-2.5.1) |
| 正交变换 | orthogonal transformation | 保持内积的实线性变换，等价于把标准正交基映到标准正交基 | [2.5.2](ch02/sec25.md#sec-2.5.2) |
| 酉变换 | unitary transformation | 复空间上保内积的线性变换 | [2.5.2](ch02/sec25.md#sec-2.5.2) |
| Givens·旋转 | Givens rotation | 在坐标平面 $(i,j)$ 内旋转、每次清零一个分量的正交矩阵 | [2.5.3](ch02/sec25.md#sec-2.5.3) |
| Householder | Householder reflection and transformation | $H=I-2\omega\omega^{\mathrm T}$，关于 $\omega^{\perp}$ 照镜子的正交矩阵 | [2.5.4](ch02/sec25.md#sec-2.5.4) |

**三 · 第三章（相抵分解、满秩分解、QR 分解、Schur 分解、对角化分解、谱分解）**

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 相抵 | equivalence of matrices | 经有限次初等变换化为另一个矩阵，等价于 $B=P^{-1}AQ$ | [3.1.1](ch03/sec31.md#sec-3.1.1) |
| 相抵标准形 | equivalence normal form | 秩为 $r$ 的矩阵都相抵于 $\Gamma=\operatorname{diag}(I_r,O)$ | [3.1.1](ch03/sec31.md#sec-3.1.1) |
| 相抵分解 | equivalence decomposition | $A=P^{-1}\Gamma Q$：分解式不唯一，标准形由秩唯一决定 | [3.1.1](ch03/sec31.md#sec-3.1.1) |
| 单侧逆 | one-sided inverse | 右逆 $AB=I$ 要求行满秩，左逆 $BA=I$ 要求列满秩 | [3.1.3](ch03/sec31.md#sec-3.1.3) |
| 秩等式 | rank identity | $\operatorname{rank}A=\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})$ | [3.1.4](ch03/sec31.md#sec-3.1.4) |
| 满秩分解 | full-rank factorization | $A=BC$：$B$ 列满秩、$C$ 行满秩，把列空间的骨架亮出来 | [3.2.1](ch03/sec32.md#sec-3.2.1) |
| 满秩分解不唯一 | non-uniqueness | 两种满秩分解只差一个可逆因子：$B_1=B_2D$、$C_1=D^{-1}C_2$ | [3.2.3](ch03/sec32.md#sec-3.2.3) |
| 伪逆 | pseudoinverse | $X=C^{\mathrm H}(CC^{\mathrm H})^{-1}(B^{\mathrm H}B)^{-1}B^{\mathrm H}$，是 $AXA=A$ 的一个解 | [3.2.4](ch03/sec32.md#sec-3.2.4) |
| QR·分解 | QR decomposition | $A=QR$：$Q$ 酉、$R$ 上三角，也叫正交三角分解 | [3.4.1](ch03/sec34.md#sec-3.4.1) |
| 正线条件 | positive diagonal condition | 要求 $R$ 的对角元全为正实数，唯一性就锁在这里 | [3.4.1](ch03/sec34.md#sec-3.4.1) |
| 列正交规范矩阵 | column-orthonormal matrix | 长方阵满足 $Q^{\mathrm H}Q=I_n$，自动列满秩且保范 | [3.4.2](ch03/sec34.md#sec-3.4.2) |
| Schur-引理 | Schur's lemma | 每个复方阵都酉相似于上三角阵：三角化人人有份 | [3.5.1](ch03/sec35.md#sec-3.5.1) |
| Schur-型 | Schur form | $A=UTU^{\mathrm H}$ 中的上三角阵 $T$，对角元就是全部特征值 | [3.5.1](ch03/sec35.md#sec-3.5.1) |
| 完全-QR | complete QR | 长方阵补零块后的完全分解 $A=U\begin{bmatrix}R_1\\O\end{bmatrix}$ | [3.4.2](ch03/sec34.md#sec-3.4.2) |
| Schur-分解 | Schur decomposition | $A=UTU^{\mathrm H}$，酉相似地把方阵化成 Schur 型 | [3.5.1](ch03/sec35.md#sec-3.5.1) |
| 正交三角分解 | orthogonal triangular decomposition | 实矩阵的 QR 分解：$Q$ 正交、$R$ 上三角 | [3.4.1](ch03/sec34.md#sec-3.4.1) |
| 矩阵多项式 | matrix polynomial | $\varphi(A)=\sum a_iA^i$，常数项自动补成 $a_0I$ | [3.5.2](ch03/sec35.md#sec-3.5.2) |
| 谱映射 | spectral mapping | $f(A)$ 的特征值恰是 $f(\lambda)$，且特征向量可以继承 | [3.5.2](ch03/sec35.md#sec-3.5.2) |
| Hamilton-定理 | Cayley–Hamilton theorem | 特征多项式零化自己：$f_A(A)=O$ | [3.5.3](ch03/sec35.md#sec-3.5.3) |
| 零化多项式 | annihilating polynomial | 使 $g(A)=O$ 的多项式；有无穷多个 | [3.5.4](ch03/sec35.md#sec-3.5.4) |
| 最小多项式 | minimal polynomial | 次数最小的首一零化多项式 $m_A$：唯一、整除一切零化多项式 | [3.5.4](ch03/sec35.md#sec-3.5.4) |
| 候选法 | candidate method | 由 $f_A$ 的因式从低往高试，找次数最小的那个零化多项式 | [3.5.4](ch03/sec35.md#sec-3.5.4) |
| 逆矩阵的多项式公式 | polynomial formula for inverse | $A^{-1}$ 可由 $m_A$ 或 $f_A$ 的系数写成 $A$ 的多项式 | [3.5.4](ch03/sec35.md#sec-3.5.4) |
| 酉相似 | unitary similarity | 换基矩阵取酉矩阵的相似，额外保住长度与内积 | [3.5.1](ch03/sec35.md#sec-3.5.1) |
| 正交相似 | orthogonal similarity | 换基矩阵取实正交矩阵的相似；对称阵可正交对角化 | [3.5.1](ch03/sec35.md#sec-3.5.1) |
| 上三角阵 | upper triangular matrix | 对角线以下元素全为零的方阵，对角元就是全部特征值 | [3.5.1](ch03/sec35.md#sec-3.5.1) |
| 单纯矩阵 | diagonalizable (semisimple) matrix | 相似于对角阵 $P^{-1}AP=\Lambda$；五条等价判据见 [@thm-3.6.1] | [3.6.1](ch03/sec36.md#sec-3.6.1) |
| 对角化分解 | diagonalization decomposition | $A=P\Lambda P^{-1}$：$P$ 的列是特征向量，列序与 $\Lambda$ 对角元逐列配对 | [3.6.1](ch03/sec36.md#sec-3.6.1) |
| 酉相似对角化 | unitary diagonalization | 存在酉 $U$ 使 $U^{\mathrm H}AU=\Lambda$；等价于存在标准正交特征向量基 | [3.6.3](ch03/sec36.md#sec-3.6.3) |
| 正规矩阵 | normal matrix | $A^{\mathrm H}A=AA^{\mathrm H}$；酉相似于对角阵的充要条件 | [3.6.4](ch03/sec36.md#sec-3.6.4) |
| 谱分解 | spectral decomposition | $A=\sum_j\lambda_jE_j$：按特征值把对角化拆成「系数 $\times$ 投影」 | [3.7.1](ch03/sec37.md#sec-3.7.1) |
| 谱阵 | spectral matrix | $E_j=\sum_{\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$，投到 $E(\lambda_j)$ 的投影（正规时正交） | [3.7.1](ch03/sec37.md#sec-3.7.1) |
| 幂等矩阵 | idempotent matrix | $E^2=E$；投影的代数刻画，特征值只能是 $0,1$ | [3.7.2](ch03/sec37.md#sec-3.7.2) |
| 正交投影矩阵 | orthogonal projection matrix | $E^2=E=E^{\mathrm H}$；$\mathbb C^n=R(E)\oplus N(E)$ 且 $R(E)\perp N(E)$ | [3.7.4](ch03/sec37.md#sec-3.7.4) |
| Lagrange 谱阵公式 | Lagrange formula for spectral matrices | $E_i=f_i(A)/f_i(\lambda_i)$，$f_i=\prod_{l\ne i}(\lambda-\lambda_l)$ | [3.7.3](ch03/sec37.md#sec-3.7.3) |
| 预解式 | resolvent | $(\lambda I-A)^{-1}=\sum_jE_j/(\lambda-\lambda_j)$；谱分解的部分分式形式 | [3.7.3](ch03/sec37.md#sec-3.7.3) |
| 正交投影矩阵（构造） | orthogonal projector | $E=A(A^{\mathrm H}A)^{-1}A^{\mathrm H}$，投到 $R(A)$；要求 $A$ 列满秩 | [3.7.6](ch03/sec37.md#sec-3.7.6) |
| 最小二乘 | least squares | $\min\|A\boldsymbol x-\boldsymbol b\|$；法方程 $A^{\mathrm H}A\boldsymbol x=A^{\mathrm H}\boldsymbol b$ | [3.7.7](ch03/sec37.md#sec-3.7.7) |
| $\lambda$ 矩阵 | lambda-matrix | 元素为 $\lambda$ 多项式的矩阵；特征矩阵 $\lambda I-A$ 是典型例子 | [3.8.1](ch03/sec38.md#sec-3.8.1) |
| $\lambda$ 矩阵的秩 | rank of lambda-matrix | 非零子式的最高阶数；非零指多项式不恒为零 | [3.8.2](ch03/sec38.md#sec-3.8.2) |
| $\lambda$ 矩阵的逆 | inverse of lambda-matrix | 存在同阶 $\lambda$ 矩阵 $B$ 使 $AB=BA=I$；充要条件是 $\det A(\lambda)$ 为非零常数 | [3.8.3](ch03/sec38.md#sec-3.8.3) |
| 初等变换（$\lambda$ 矩阵） | elementary transformations | 换行 / 列、乘非零常数、加多项式倍；对应左乘 / 右乘初等矩阵 | [3.8.4](ch03/sec38.md#sec-3.8.4) |
| 行列式因子 | determinant divisor | 全部 $k$ 阶子式的首 $1$ 最大公因式 $D_k$；只对 $1\le k\le r$ 定义 | [3.8.5](ch03/sec38b.md#def-3.8.5) |
| Smith 标准形 | Smith normal form | $\operatorname{diag}(d_1,\dots,d_r,0)$，$d_i$ 首 $1$、$d_1\mid\cdots\mid d_r$；相抵下的唯一标准形 | [3.8.6](ch03/sec38b.md#thm-3.8.2) |
| 不变因子 | invariant factor | Smith 标准形对角线上的 $d_i$；构成相抵的完全不变量 | [3.8.7](ch03/sec38b.md#def-3.8.6) |
| 初等因子 | elementary divisor | 不变因子分解出的素因子幂的全体（多重集） | [3.8.7](ch03/sec38b.md#def-3.8.7) |
| Jordan 块 | Jordan block | 对角元全 $\lambda_0$、超对角元全 $1$ 的 $s$ 阶方阵 $J_s(\lambda_0)$ | [3.8.10](ch03/sec38b.md#def-3.8.9) |
| Jordan 标准形 | Jordan canonical form | 由初等因子逐个对应 Jordan 块拼成的分块对角阵；除块次序外唯一 | [3.8.10](ch03/sec38b.md#def-3.8.10) |

**四 · 第四章（向量范数、矩阵范数、相容范数）**

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 向量范数 | vector norm | 正定、齐次、三角三条公理；不依赖内积 | [4.1.1](ch04/sec41.md#def-4.1.1) |
| 赋范线性空间 | normed linear space | 带范数的线性空间 $(V,\|\cdot\|)$ | [4.1.1](ch04/sec41.md#def-4.1.1) |
| $p$-范数 | p-norm | $\|x\|_p=\big(\sum|x_i|^p\big)^{1/p}$，$1\le p\le\infty$ | [4.1.2](ch04/sec41.md#ex-4.1.3) |
| 椭圆（加权）范数 | elliptic / weighted norm | $\|x\|_A=\sqrt{x^{\mathrm H}Ax}$，$A$ 正定 Hermite | [4.1.3](ch04/sec41.md#ex-4.1.4) |
| 范数等价 | equivalence of norms | $k_1\|x\|_\beta\le\|x\|_\alpha\le k_2\|x\|_\beta$；有限维空间中任意两范数等价 | [4.1.4](ch04/sec41.md#def-4.1.2) |
| 矩阵的向量范数 | entrywise matrix norm | 把矩阵拉直后的向量范数，只查三条公理 | [4.2.1](ch04/sec42.md#def-4.2.1) |
| 矩阵范数 | matrix norm | 三条公理加乘法相容性 $\|AB\|\le\|A\|\|B\|$ | [4.2.2](ch04/sec42.md#def-4.2.2) |
| Frobenius 范数 | Frobenius norm | $\|A\|_F=\sqrt{\operatorname{tr}(A^{\mathrm H}A)}=\sqrt{\sum\sigma_i^2}$，酉不变 | [4.2.3](ch04/sec42.md#ex-4.2.2) |
| 相容 | compatibility | $\|Ax\|_v\le\|A\|_m\|x\|_v$：矩阵尺子与向量尺子配套 | [4.3.1](ch04/sec43.md#def-4.3.1) |
| 诱导（算子）范数 | induced / operator norm | $\|A\|=\max_{\|x\|_v=1}\|Ax\|_v$，与给定向量范数配套且最紧 | [4.3.1](ch04/sec43.md#thm-4.3.2) |
| 列和范数 | column-sum norm | $\|A\|_1=\max_j\sum_i|a_{ij}|$，由 $\|\cdot\|_1$ 诱导 | [4.3.2](ch04/sec43.md#thm-4.3.3) |
| 行和范数 | row-sum norm | $\|A\|_\infty=\max_i\sum_j|a_{ij}|$，由 $\|\cdot\|_\infty$ 诱导 | [4.3.2](ch04/sec43.md#thm-4.3.3) |
| 谱范数 | spectral norm | $\|A\|_2=\sqrt{\lambda_{\max}(A^{\mathrm H}A)}=\sigma_{\max}(A)$ | [4.3.2](ch04/sec43.md#thm-4.3.3) |
| Rayleigh 商 | Rayleigh quotient | $R(x)=x^{\mathrm H}Ax/x^{\mathrm H}x$，$\lambda_n\le R\le\lambda_1$ | [4.3.3](ch04/sec43.md#note-4.3-rayleigh) |
| 极大极小定理 | Courant–Fischer theorem | $\lambda_i=\max_{V_i}\min_{V_i}R=\min_{V_{n-i+1}}\max_{V}R$ | [4.3.3](ch04/sec43.md#thm-4.3.4) |
| 特征值扰动 | eigenvalue perturbation | $\lambda_i(A)+\lambda_n(E)\le\lambda_i(A+E)\le\lambda_i(A)+\lambda_1(E)$ | [4.3.3](ch04/sec43.md#thm-4.3.5) |
| Neumann 级数 | Neumann series | $\|A\|\lt1$ 时 $(I-A)^{-1}=\sum_{k\ge0}A^k$ | [4.3.4](ch04/sec43.md#sec-4.3.4) |
