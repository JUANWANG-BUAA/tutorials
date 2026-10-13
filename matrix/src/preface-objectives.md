# 学习目标

按「能……」句式给出可检验的目标；每条目标后括注认知层级，并在[章末自检表](ch01/checklist.md)中对应到正文小节与习题。

> **第二章（2.1–2.5）的目标**：2.1–2.2 随第 3 周录播追加、2.3 随官方课件追加、2.4–2.5 随第 5 周录播追加，见「K2 / S2 / A2」三组，与[第二章自检表](ch02/checklist.md)对应；2.6–2.7 到位后继续补充。
>
> **第三章（3.1–3.2）的目标**：3.1、3.2 随官方课件追加（两节均无录播），见本节末尾「K3 / S3 / A3」三组，与[第三章自检表](ch03/checklist.md)对应；3.3 及以后到位后继续补充。

## K · 知识目标（概念与理论）

<ul class="objlist">
<li><span class="obj-id">K1.1</span>能陈述数域的定义，并对给定数集（$\mathbb{Q}$、$\mathbb{R}$、$\mathbb{C}$、$\mathbb{Z}$、$\mathbb{Q}(\sqrt2)$ 等）作出是否为数域的判断且说明理由。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.2</span>能完整写出线性空间定义中的八条运算律（加法四条 + 数乘四条），并指出验证一个具体空间时哪些条款「自动继承」、哪些必须逐一检验。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.3</span>能陈述子空间判定定理的三个等价命题，并解释「先检验零向量是否在集合中」这一步骤的依据。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.4</span>能陈述线性相关 / 无关、极大无关组、基、坐标、过渡矩阵、维数的定义，并说明「基给线性空间强加了坐标系」的含义。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.5</span>能陈述复内积的四条公理、Hermite 矩阵与正定性的定义，并解释内积、坐标和度量矩阵之间的关系。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.6</span>能陈述长度、夹角、正交、正交向量组、正交基与标准正交基的定义，并写出长度的四条性质（正定、齐次、平行四边形法则、三角不等式）与 Cauchy–Schwarz 不等式（含等号条件）。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.7</span>能陈述直和与直和分解的定义、直和判定定理的四条等价命题，以及投影的定义与「投影依赖于整个分解」这一要点。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.8</span>能陈述向量与子空间正交、两子空间正交、正交直和、正交补与正交投影的定义，写出正交基下的投影公式（一般正交基与标准正交基两个版本），并说明「正交投影只由子空间与内积决定、且是最近点」。<span class="obj-lv">记忆 / 理解</span></li>
</ul>

## S · 技能目标（判定与计算）

<ul class="objlist">
<li><span class="obj-id">S1.1</span>能对给定集合（新定义运算的 $\mathbb{R}^+$、矩阵集合、函数集合、信号集合）逐条验证八条公理，或用判定定理 / 反例快速否定其线性空间资格。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S1.2</span>能求给定矩阵 $A$ 的零空间 $N(A)$ 与列空间 $R(A)$，并用「$b\in R(A)$」判断线性方程组 $A\boldsymbol{x}=\boldsymbol{b}$ 的可解性。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S1.3</span>能判定向量组的线性相关性：$\mathbb{R}^n$ / $\mathbb{C}^n$ 中的向量组用秩，离散信号组用 Casorati 行列式。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.4</span>能求向量在给定基下的坐标、求两组基之间的过渡矩阵并完成坐标变换（含多项式空间的 Taylor 基）。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S1.5</span>能用维数公式 $\dim(W_1+W_2)=\dim W_1+\dim W_2-\dim(W_1\cap W_2)$ 计算 $\dim(W_1\cap W_2)$，并具体求出交空间。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.6</span>能判断给定二元函数是否构成内积，并由正定 Hermite 矩阵构造加权内积。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.7</span>能在给定基下计算度量矩阵，并用 $(\boldsymbol{x},\boldsymbol{y})=\boldsymbol{\eta}^{\mathrm H}G\boldsymbol{\xi}$ 完成内积计算与换基验证。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S1.8</span>能计算向量的长度与夹角，判定正交性，并用 Gram–Schmidt 正交化把给定基化为正交基 / 标准正交基。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.9</span>能对给定子空间判定其和是否为直和，并把向量沿直和分解拆成各子空间上的投影（含解 Gram 方程组求投影）。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.10</span>能求给定子空间的正交补（含维数核算），用「先补后投」与「正交基公式」两种方法求正交投影，并把 Gram–Schmidt 的换基关系写成正线上三角过渡矩阵。<span class="obj-lv">应用 / 分析</span></li>
</ul>

## A · 素养目标（辨析与迁移）

<ul class="objlist">
<li><span class="obj-id">A1.1</span>能识别子空间判定中的常见陷阱（$\mathbb{R}^2$ 不是 $\mathbb{R}^3$ 的子空间、非齐次方程解集、子空间的并集等），并对每个错误命题给出具体反例。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A1.2</span>能说明「线性相关性依赖于所取数域」「坐标依赖于所取基」这两件事的典型例证，并在计算中主动标注数域与基。<span class="obj-lv">分析</span></li>
<li><span class="obj-id">A1.3</span>能复核课件与教材中的论证（如例 1.3.6、例 1.6.4），发现「声称线性无关」与「矩阵两行相同」矛盾、或「不同空间的向量直接相等」这类跳跃，并给出改正。<span class="obj-lv">评价</span></li>
<li><span class="obj-id">A1.4</span>能主动声明复内积的线性变元约定，核对 Gram 矩阵下标，并指出「内积与度量矩阵一一对应」必须先固定基。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A1.5</span>能写出结构完整、每步指明依据的证明（存在性 / 唯一性分开处理，反证法假设与矛盾都写清楚），而不只是罗列算式。<span class="obj-lv">综合 / 评价</span></li>
<li><span class="obj-id">A1.6</span>能辨别实、复内积空间的边界：Cauchy–Schwarz 的模形式及等号条件在二者中都成立；不带模的等式、实夹角公式与勾股逆命题不能直接搬到复空间，并能给出反例。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A1.7</span>能辨析「几何垂直」与「子空间正交」的差异（墙角反例），指出正交基投影公式对非正交基失效的原因，并复述例 1.6.7 的三步证明骨架与「包含 + 等维」技巧。<span class="obj-lv">分析 / 评价</span></li>
</ul>

## 第二章 · 线性映射与矩阵（2.1–2.5）

### K · 知识目标

<ul class="objlist">
<li><span class="obj-id">K2.1</span>能陈述映射、单射、满射、双射、映射相等、复合映射、可逆映射、变换、一一变换、置换的定义，并解释「可逆 ⟺ 双射」。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K2.2</span>能构造 $\mathbb N\to\mathbb Z$ 的双射，说明等势的含义，并复述 $\mathbb N\sim\mathbb Z\sim\mathbb Q$、$\mathbb R$ 不可数的结论与证明思路。<span class="obj-lv">理解 / 应用</span></li>
<li><span class="obj-id">K2.3</span>能陈述带余除法、整除、因式 / 倍式、公因式 / 公倍式、友矩阵的定义，并写出友矩阵的两种形状。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K2.4</span>能写出线性映射定义的两条性质（可加性、齐次性）及合并形式，说明两条注记（同一数域、左右两端的运算空间）的作用。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K2.5</span>能列举至少八个线性映射的例子（几何三类、微分、积分、投影、两组基、矩阵诱导 / 转置），并说明平移为何不是线性映射。<span class="obj-lv">理解</span></li>
<li><span class="obj-id">K2.6</span>能陈述并证明「保持线性组合」、「$T(\boldsymbol{\theta})=\boldsymbol{\theta}'$」、「相关组的像相关」三条性质；能陈述单射判据及其两条注、推论（同维 + 单射 ⟹ 双射）。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K2.7</span>能陈述线性映射空间 $L(V,W)$ 的定义与维数公式 $\dim L=\dim V\cdot\dim W$；能陈述零空间、值空间、零度与秩的定义，并完整证明亏加秩定理。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K2.8</span>能定义线性映射（线性变换）在给定两对基下的矩阵，说出「$A$ 的第 $j$ 列是 $T(\varepsilon_j)$ 的坐标」这一读法，并陈述矩阵的存在唯一性。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K2.9</span>能定义同构映射，陈述并证明「同构 ⟺ 维数相等」，说明「同构 $=$ 等势 $+$ 保持线性运算」与 $L(V,W)\cong F^{m\times n}$。<span class="obj-lv">理解 / 证明</span></li>
<li><span class="obj-id">K2.10</span>能陈述坐标公式 $\beta=A\alpha$、换基公式 $B=P^{-1}AQ$ 与相似公式 $B=P^{-1}AP$，说明 $P$、$Q$ 各自作用的端与「相似 = 同一变换换基」的含义。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K2.11</span>能陈述并证明 $\dim N(T)=\dim N(A)$、$\dim R(T)=\dim R(A)=\operatorname{rank}A$，说明它们与亏加秩定理的关系。<span class="obj-lv">理解 / 证明</span></li>
</ul>

### S · 技能目标

<ul class="objlist">
<li><span class="obj-id">S2.1</span>能按「先证是映射、再验两条」的规范书写格式，证明给定映射是线性映射（含由基定义的映射）并计算指定像。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S2.2</span>能对具体线性映射求 $N(T)$、$R(T)$ 的一组基与维数，并验证亏加秩定理。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S2.3</span>能利用亏加秩定理反推维数（如由满射推零度），并结合单射判据判断映射类型。<span class="obj-lv">分析</span></li>
<li><span class="obj-id">S2.4</span>能给定映射与两对基逐列写出矩阵，也能由矩阵与基还原映射；能用 $\beta=A\alpha$ 计算像的坐标。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S2.5</span>能求过渡矩阵、用 $B=P^{-1}AP$ 计算换基后的矩阵，并用「逐列验证」自查结果。<span class="obj-lv">应用 / 分析</span></li>
</ul>

### A · 素养目标

<ul class="objlist">
<li><span class="obj-id">A2.1</span>能主动核对「数域」前提（$\mathbb R$-线性还是 $\mathbb C$-线性），并给出可加 / 齐次只满足其一的映射反例。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A2.2</span>使用单射判据前先核对前提（是否整组向量、维数是否相同），能解释「注 2 的反例」与「维数陷阱」。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A2.3</span>能识别并纠正常见书写错误：复合顺序写反、$I_V$ 与 $I_W$ 混同、把「变换」当任意映射、把推论的前提（维数相同）丢掉。<span class="obj-lv">评价</span></li>
<li><span class="obj-id">A2.4</span>书写矩阵与换基公式前先核对形状（$m\times n$）与基的对应关系；能区分「相抵 / 相似」「等势 / 同构」「同一个矩阵 / 同一个映射」三对概念。<span class="obj-lv">分析 / 评价</span></li>
</ul>

## 第三章 · 矩阵分解（3.1–3.2）

### K · 知识目标

<ul class="objlist">
<li><span class="obj-id">K3.1</span>能陈述相抵分解式 $A=P^{-1}\Gamma Q$ 与相抵标准形 $\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$，说明「分解式不唯一、标准形唯一」各自的含义。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K3.2</span>能证明「同型矩阵相抵 $\iff$ 秩相等」，并说明相抵标准形存在性证明的选基路线（零空间的基排前、值域的基接后）。<span class="obj-lv">理解 / 证明</span></li>
<li><span class="obj-id">K3.3</span>能用分块矩阵法求 $P$、$Q$：说清读出的 $E$、$F$ 与 $A=P^{-1}\Gamma Q$ 中 $P$、$Q$ 的对应关系，并用 $EAF=\Gamma$ 回代验证。<span class="obj-lv">理解 / 应用</span></li>
<li><span class="obj-id">K3.4</span>能用相抵标准形解线性方程组：写出 $\Gamma\boldsymbol y=P\boldsymbol b$ 的解法、可解判据（$P\boldsymbol b$ 后 $m-r$ 个分量）与自由度数 $n-r$。<span class="obj-lv">理解 / 应用</span></li>
<li><span class="obj-id">K3.5</span>能陈述并应用右逆 / 左逆的存在判别（行满秩 $\iff$ 右逆，列满秩 $\iff$ 左逆），说明方阵情形为何合一，给出两条充分性证明（相抵构造与闭式公式）。<span class="obj-lv">理解 / 证明</span></li>
<li><span class="obj-id">K3.6</span>能陈述并证明 $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})=\operatorname{rank}(A^{\mathrm H})$，指出证明中内积正定性的作用，并用作「可逆性转换器」。<span class="obj-lv">理解 / 证明</span></li>
<li><span class="obj-id">K3.7</span>能陈述满秩分解定理 $A=BC$ 与 $B$、$C$ 的形状、秩与几何含义，给出两条构造路线并补全 $\operatorname{rank}C=r$ 的理由。<span class="obj-lv">理解 / 证明</span></li>
<li><span class="obj-id">K3.8</span>能陈述并证明满秩分解的唯一性刻画（$B_1=B_2D$、$C_1=D^{-1}C_2$，$D$ 可逆且是过渡矩阵），说明「一个分解生成全部」。<span class="obj-lv">理解 / 证明</span></li>
<li><span class="obj-id">K3.9</span>能写出矩阵方程 $AXA=A$ 的一个解（经满秩分解构造），并陈述 $AXA=A\iff CXB=I_r$ 的等价刻画。<span class="obj-lv">理解 / 应用</span></li>
</ul>

### S · 技能目标

<ul class="objlist">
<li><span class="obj-id">S3.1</span>能对任意矩阵（含长方阵、零矩阵）完成相抵分解：消元、读块、写出 $P^{-1}$ 与 $Q$，并回代验证。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S3.2</span>能用相抵标准形求出方程组的通解或判定无解，并核对可解判据与自由度数。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S3.3</span>能用公式 $A^{\mathrm H}(AA^{\mathrm H})^{-1}$、$(A^{\mathrm H}A)^{-1}A^{\mathrm H}$ 构造单侧逆并验算；能写出「全部右（左）逆」的参数形式。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S3.4</span>能用三种算法求满秩分解（取列 / RREF / 从相抵分解读），并由分解读出 $R(A)$ 的基、列关系与 $N(A)$。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S3.5</span>能在两种满秩分解之间用过渡矩阵 $D$ 换算，并在具体矩阵上验证定理 3.2.2。<span class="obj-lv">应用</span></li>
</ul>

### A · 素养目标

<ul class="objlist">
<li><span class="obj-id">A3.1</span>用任何结论前先核对前提：方阵还是长方阵、$r>0$、实还是复（共轭转置的适用范围）。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A3.2</span>书写分解式前先核对记号角色：谁左乘谁右乘、谁取逆、$E$、$F$ 与 $P$、$Q$ 的对应（勘误 E3.1、E3.3 的教训）。<span class="obj-lv">评价</span></li>
<li><span class="obj-id">A3.3</span>养成「算完必回代」的习惯：相抵分解验 $EAF=\Gamma$，满秩分解验 $BC=A$，单侧逆验 $AB=I$ 或 $BA=I$。<span class="obj-lv">评价</span></li>
<li><span class="obj-id">A3.4</span>能辨析三对易混：「相抵 / 相似」「分解式不唯一 / 标准形唯一」「充分条件 / 充要条件」，并各举一例说明差别。<span class="obj-lv">分析 / 评价</span></li>
</ul>
