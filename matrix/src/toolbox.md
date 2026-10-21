# 解题工具箱：题型流程 · 二级结论 · 反例弹药

前三章的方法已经散落在正文、例题与习题里；这一页把它们**按「做题时怎么用」重新编排**：看到题目先对号入座找到流程，算完用验算清单核账，判断正误时从反例弹药库抽一颗，所有**二级结论**（可以直接引用的中间结论）集中在第二节。

::: note 本页在复习体系里的位置（五件工具，各司其职）

| 工具 | 管什么 | 什么时候用 |
|:--|:--|:--|
| [速查背记卡](memory-sheet.md) | **压缩层**：每个定义、定理压成一句「最小可背诵单元」 | 背之前先把要背的压到最短 |
| [闭卷回忆卡（一](ch01/recall-cards.md)[/二](ch02/recall-cards.md)[/三）](ch03/recall-cards.md) | **检索层**：从空白纸上把定义、定理、第一行叫出来 | 当天 / 1 / 3 / 7 天间隔复习（可导出 Anki） |
| **本页** | **操作层**：题型流程、二级结论、反例弹药、验算清单 | 做题时、考试前查漏 |
| [证明怎么下笔](proof-workshop.md) | **证明专用**：六种证明骨架 | 拿到证明题、不知第一行写什么时 |
| [考场竞技场](ch03/arena.md)（第三章） | **考试特化**：必考点、限时赛制、步骤分引擎 | 考前限时训练、把「会做」练成「拿分」 |
:::

## 一、题型 → 标准流程

每一张流程卡：**入口**（题目长什么样）→ **步骤**（照做即可）→ **验算**（最短的一行）→ **易错**（一句话 + 出处）。流程之外的慢工细活（如推导）仍回正文；这里只管「会了之后怎么做快、做对」。

::: method 流程 1 · 相抵分解（求 $P$、$Q$）{#flow-31}

**入口**：给任意矩阵 $A$，要求「相抵分解式 $A=P^{-1}\Gamma Q$」或「化成相抵标准形」。

**步骤**：① 消元求秩 $r$（或直接进第 ② 步，消元过程给出）；② 用分块矩阵 $\begin{bmatrix}A&I\\ I&*\end{bmatrix}$ 只对**前块**做行、列变换，直到前块变成 $\Gamma=\begin{bmatrix}I_r&0\\0&0\end{bmatrix}$；③ 读块：分块矩阵右上角是 $E=P$、左下角是 $F=Q^{-1}$；④ 写答案 $A=E^{-1}\Gamma F^{-1}$。

**验算**：$EAF=\Gamma$（一代就穿帮，别凭感觉）。**易错**：把读出的 $E$ 直接当 $P^{-1}$ 代入（[勘误 E3.1](ch03/errata.md)）；对未知元做了列变换忘记「乘回」（[@method-3.1-augmented]）。
:::

::: method 流程 2 · 用相抵标准形解方程组 {#flow-32}

**入口**：「解 $A\boldsymbol x=\boldsymbol b$」或「判断有无解、有几个自由度」。

**步骤**：① 先有相抵分解（流程 1）；② 换元 $\boldsymbol x=F\boldsymbol y$，方程化为 $\Gamma\boldsymbol y=E\boldsymbol b$；③ 看 $E\boldsymbol b$ 的**后 $m-r$ 个分量**：不全为零 ⇒ 无解，结束；④ 有解时，$\boldsymbol y$ 的前 $r$ 个分量由 $E\boldsymbol b$ 前 $r$ 个分量直接读出，后 $n-r$ 个自由；⑤ 通解 $\boldsymbol x=F\boldsymbol y$。

**验算**：把通解代回原方程抽查一个参数值；自由度数目 $=n-r$。**易错**：用 $\boldsymbol b$ 而不是 $E\boldsymbol b$ 判可解（判据要看**变换后**的后 $m-r$ 个分量）；读出 $\boldsymbol y$ 后忘乘 $F$（[@ex-3.1.1]、[@ex-3.1.B]）。
:::

::: method 流程 3 · 单侧逆：判断与构造 {#flow-33}

**入口**：「$A$ 是否有左 / 右逆」「构造一个右逆」「写出全部右逆」。

**步骤**：① 算秩判方向——**行**满秩（$\operatorname{rank}A=m$）$\iff$ 有**右**逆；**列**满秩（$\operatorname{rank}A=n$）$\iff$ 有**左**逆（[@thm-3.1.1]）；② 用闭式公式构造：右逆 $B_0=A^{\mathrm H}(AA^{\mathrm H})^{-1}$、左逆 $B_0=(A^{\mathrm H}A)^{-1}A^{\mathrm H}$（可逆性由 [@prop-3.1.1] 保证）；③ 「全部右逆」：$B=B_0+Z$，其中 $Z$ 的**每一列**都属于 $N(A)$（参数形式按 $N(A)$ 的基写出）。

**验算**：$AB_0=I$（或 $B_0A=I$）逐元素一战。**易错**：左右方向写反；忘记前提是「行满秩 / 列满秩」而不是「满秩」（长方阵两边不可能同时满）；方阵才有「单侧即双侧，称为逆」。
:::

::: method 流程 4 · 满秩分解 {#flow-34}

**入口**：「求 $A$ 的满秩分解 $A=BC$」。

**步骤**（RREF 法最快，[@method-3.2-rref]）：① 消元化为行简化阶梯形 $R$，记秩 $r$ 与**主元列号**；② $B=A$ 的第 $p_1,\cdots,p_r$ 列（**取 $A$ 的列**，不是 $R$ 的）；③ $C=R$ 的前 $r$ 行；④ 写 $A=BC$。备选：从相抵分解读（取 $P^{-1}$ 前 $r$ 列、$Q$ 前 $r$ 行）或任取 $R(A)$ 的基拼坐标。

**验算**：$BC=A$。**易错**：主元列取成 RREF 里的单位列（必须回到 $A$ 里取）；$C$ 取 RREF 的非零行（不是前 $r$ 行——除非恰好没有零行夹在中间，标准做法就是非零行）；忘记前提 $r>0$。**另一种分解的换算**：若给出两种分解，$D=B_2^{\mathrm L}B_1=(B_2^{\mathrm H}B_2)^{-1}B_2^{\mathrm H}B_1$（[@thm-3.2.2]）。
:::

::: method 流程 5 · QR 分解（手算）{#flow-35}

**入口**：「求 QR 分解」「求正交三角分解」；方阵需满秩，长方阵需列满秩。

**步骤**（GS 法）：① 验满秩；② 逐列 Gram–Schmidt：$\boldsymbol y_k=\boldsymbol a_k-\sum_{i<k}(\boldsymbol a_k,\boldsymbol z_i)\boldsymbol z_i$，$\boldsymbol z_k=\boldsymbol y_k/\|\boldsymbol y_k\|$；③ 填 $R$：**对角元 $r_{kk}=\|\boldsymbol y_k\|$**（残差的范数！）、上三角元 $r_{ik}=(\boldsymbol a_k,\boldsymbol z_i)$（$i<k$）；④ $Q=[\boldsymbol z_1,\cdots,\boldsymbol z_n]$。长方阵（推论 3.4.1）：把 $Q$ 补成 $m$ 阶酉阵、$R$ 底下垫零块（补齐列取正交补方向）。

**验算**：$QR=A$（必做）；$R$ 对角全正（正线）；$Q^{\mathrm T}Q=I$。**易错**：$r_{kk}$ 写成 $\|\boldsymbol a_k\|$（先减成分、再量长度）；符号 / 正线未规约（[勘误 E3.7](ch03/errata.md)）；长方阵把 $R$ 写成 $n\times n$（要 $\begin{bmatrix}R_1\\O\end{bmatrix}$，[@ex-3.4.3]）。
:::

::: method 流程 6 · QR 算法求特征值 {#flow-36}

**入口**：「用 QR 算法求特征值」，或矩阵较大不便手算特征多项式。

**步骤**：① $A_1=A$；② 对 $A_k$ 作 QR 分解 $A_k=Q_kR_k$；③ $A_{k+1}=R_kQ_k$（交换左右再乘回）；④ 反复迭代（题目常指定 $k=10$、$20$）；⑤ 对角元即特征值（收敛条件：模互异；顺序为模从大到小）。

**验算**：任取一步检查 $\operatorname{tr}(A_{k+1})=\operatorname{tr}(A)$（相似不变量）；收敛后对角元和应等于 $\operatorname{tr}A$。**易错**：迭代式写成 $Q_kA_kQ_k^{\mathrm H}$（方向错，应为 $R_kQ_k=Q_k^{\mathrm H}A_kQ_k$）；仅凭「模互异」保证全矩阵收敛；异模也可能两周期，等模还可能无法三角化（旋转阵反例，[@ex-3.4.4] 的本编注）。
:::

::: method 流程 7 · 最小多项式 {#flow-37}

**入口**：「求 $A$ 的最小多项式」，或需要它来化简 $g(A)$、$A^m$。

**步骤**（候选法，[@method-minpoly]）：① 求 $f_A(\lambda)$ 并**因式分解**；② 列全部候选：每个根 $\lambda_j$（重数 $d_j$）在候选里取幂 $1$ 到 $d_j$，组合共 $\prod d_j$ 个（一般 $2^s$ 个）；③ **从低次到高次**逐个试算 $g(A)\stackrel{?}{=}O$；④ 第一个通过的即 $m_A$。

**验算**：$m_A\mid f_A$（次数分配对不对）；$m_A$ 与 $f_A$ 根相同（不漏根）。**易错**：**次序不能反**——从高次试，第一个通过的是 $f_A$ 而不是 $m_A$；低次候选的「淘汰」要写出乘积式子（$I_2$ 型反例：几何重数不足时低次必被淘汰，[@ex-3.5.B]）。
:::

::: method 流程 8 · 矩阵多项式三件套：$g(A)$、$A^m$、$A^{-1}$ {#flow-38}

**入口**：「计算 $A^4-2A^2+I$」「求 $A^{100}$」「用 H–C 公式求 $A^{-1}$」。

**步骤**（三件套，先求 $f_A$ 或 $m_A$ 作燃料）：① **$g(A)$**：带余除法 $g=qm_A+r$（本编注：除以 $m_A$ 比除以 $f_A$ 更省——[@ex-3.5.2b]），代入 $g(A)=r(A)$；② **$A^m$**：由 $f_A$ 得递推（如 $A^2=\alpha A+\beta I$）后迭代，或在特征值处定系数：解 $\lambda_i^m=\alpha\lambda_i+\beta$ 得 $A^m=\alpha A+\beta I$；③ **$A^{-1}$**：$A^{-1}=-\frac{1}{a_0}(A^{n-1}+a_{n-1}A^{n-2}+\cdots+a_1I)$，$a_0=f_A(0)=(-1)^n\det A\ne0$（[@cor-3.5.2]）。

**验算**：$AA^{-1}=I$；$A^m$ 的对角元 / 迹与 $\sum\lambda_i^m$ 对照；对称阵的 $A^m$ 必对称。**易错**：$g$、$m_A$、$f_A$ 三者的角色混用（$g=qm_A+r$ 才是标准式）；逆公式的**负号**与 $a_i$ 的配对（[勘误 E3.5](ch03/errata.md) 的三连错就是这个雷）。
:::

::: method 流程 9 · 特征值、特征向量与可对角化 {#flow-39}

**入口**：「求特征值 / 特征向量」「判断能否对角化」「求过渡矩阵 $P$」。

**步骤**：① $f_A(\lambda)=\det(\lambda I-A)$；**用 $\operatorname{tr}A=\sum\lambda_i$、$\det A=\prod\lambda_i$ 验根**（[@thm-eig-trace]）；② 对每个 $\lambda$ 解 $(A-\lambda I)\boldsymbol x=\boldsymbol 0$ 得特征向量（变换问题要乘回基坐标/基向量，[@method-eig-procedure]）；③ 逐个比对几何重数（$=n-\operatorname{rank}(A-\lambda I)$）与代数重数（[@thm-geom-mult]、[@thm-mult-ineq]）；④ 全部取等才可对角化，$P$ 由特征向量拼成，验 $P^{-1}AP=\Lambda$。

**验算**：迹、行列式的两个对照式；$P^{-1}AP$ 一代。**易错**：特征向量必须**非零**；忘掉重数的比较直接下结论；2.5 的「设计基」反向题要按 [@method-design-basis] 流程反推。
:::

::: method 流程 10 · 正交化与投影（第一章工具链）{#flow-310}

**入口**：Gram–Schmidt 正交化、求投影 / 最近点、把向量对准坐标轴。

**步骤**：① 正交化（[@method-gs]）：先查要用的基是否**已经正交**，正交 → 直接套投影公式；不正交 → 先 GS；② 投影（正交基版本）：$\operatorname{Proj}_W\boldsymbol y=\sum\frac{(\boldsymbol y,\boldsymbol x_i)}{(\boldsymbol x_i,\boldsymbol x_i)}\boldsymbol x_i$；标准正交基版本去掉分母；③ 「对准轴」用 Householder 或 Givens（[@method-givens-align]）。

**验算**：残差与基向量逐个内积为零；投影的幂等性 $P^2=P$。**易错**：对**非正交**基直接套投影公式（[勘误 E12](ch01/errata.md)）；Householder 是镜像不是投影。
:::

::: method 流程 11 · 对角化分解：判断、求 $P$、算 $A^m$ {#flow-311}

**入口**：「判断 $A$ 能否对角化」「求可逆 $P$ 使 $P^{-1}AP=\Lambda$」「用对角化算 $A^{100}$ / 解 $\dot{\boldsymbol x}=A\boldsymbol x$」。

**步骤**：① 求 $f_A(\lambda)$，因式分解出互异根 $\lambda_i$ 与代数重数 $d_i$；用 $\operatorname{tr}A=\sum d_i\lambda_i$、$\det A=\prod\lambda_i^{d_i}$ 验根（[@thm-eig-trace]）；② 算 $g_i=n-\operatorname{rank}(A-\lambda_iI)$（[@thm-geom-mult]）；只要有一个 $g_i<d_i$，**立刻停**：不可对角化（[@thm-3.6.1]）；③ 对每个 $\lambda_i$ 解 $(A-\lambda_iI)\boldsymbol x=\boldsymbol 0$，取 $g_i$ 个独立特征向量；④ 拼 $P$，**列序与 $\Lambda$ 对角元逐列配对**；⑤ 验 $AP=P\Lambda$（或 $P^{-1}AP=\Lambda$）；⑥ 算 $A^m=P\Lambda^mP^{-1}$，或解 $\boldsymbol y'=\Lambda\boldsymbol y$ 再乘回 $\boldsymbol x=P\boldsymbol y$。

**验算**：$\operatorname{tr}\Lambda=\operatorname{tr}A$、$\det\Lambda=\det A$；$AP=P\Lambda$ 抽查一列；$A^m$ 的迹 $=\sum\lambda_i^m$。

**易错**：把「互异特征值」当必要条件（$I_n$ 反例）；重特征值只找到一个向量就宣布可对角化；$P$ 与 $\Lambda$ 列序错配；把 $P^{-1}AP$ 写成 $PAP^{-1}$。
:::

::: method 流程 12 · 谱分解：求 $E_j$、算 $f(A)$ {#flow-312}

**入口**：「求 $A$ 的谱分解」「用谱分解算 $A^{100}$ / $e^{At}$ / $A^{-1}$」「证明谱阵是正交投影」。

**步骤**：① 先对角化（流程 11），得 $A=P\Lambda P^{-1}$；② 把 $P$ 按**列**读成 $\boldsymbol\alpha_1,\cdots,\boldsymbol\alpha_n$，把 $P^{-1}$ 按**行**读成 $\boldsymbol\beta_1^{\mathrm H},\cdots,\boldsymbol\beta_n^{\mathrm H}$（关键：$\boldsymbol\beta_i^{\mathrm H}\boldsymbol\alpha_k=\delta_{ik}$）；③ 按特征值分组 $E_j=\sum_{i:\lambda_i=\lambda_j}\boldsymbol\alpha_i\boldsymbol\beta_i^{\mathrm H}$；④ 若只想求某个 $E_i$，用 Lagrange 公式 $E_i=f_i(A)/f_i(\lambda_i)$，$f_i=\prod_{l\ne i}(\lambda-\lambda_l)$（[@thm-3.7.2]）；⑤ 算 $f(A)=\sum_jf(\lambda_j)E_j$（[@thm-3.7.1]）；⑥ 若是正规矩阵，可改用 $E_j=\sum\boldsymbol u_i\boldsymbol u_i^{\mathrm H}$，此时 $E_j^{\mathrm H}=E_j$（[@prop-3.7.2]）。

**验算**：$\sum_jE_j=I$；$E_iE_j=0$；$E_j^2=E_j$；$AE_j=\lambda_jE_j$；$\operatorname{tr}E_j=d_j$。正规时再加 $E_j^{\mathrm H}=E_j$。

**易错**：把 $P^{-1}$ 的**列**当 $\boldsymbol\beta_i$（应读**行**）；$E_j$ 下标与 $\lambda_j$ 错配；把幂等当正交投影（只有正规矩阵才有 $E_j^{\mathrm H}=E_j$）；对非单纯矩阵硬写谱分解。
:::

## 二、二级结论速查（可直接引用）

「二级结论」= 正文已证结论的一次性推论，做题时可以直接引用（引用请写出它来自哪条正定理，或现场一行验证——本表列出两样都给你）。每条都标**前提**：前提不满足时结论作废，这是判断题最爱设的坑。

### 2.1 秩与可逆

| # | 结论 | 前提 | 典型用途 |
|:--|:--|:--|:--|
| 1 | 方阵 $A$ 可逆 $\iff$ $\det A\ne0$ $\iff$ $\operatorname{rank}A=n$ $\iff$ 列（行）满秩 $\iff$ $N(A)=\{\boldsymbol 0\}$ $\iff$ 有单侧逆 $\iff$ $A^{\mathrm H}A$ 可逆 $\iff$ 特征值全非零 | 方阵 | 概念判断题的万能替换链；本编汇总，各环出处见 [@thm-2.1.2]、[@thm-3.1.1]、[@prop-3.1.1] |
| 2 | $\operatorname{rank}(A)=\operatorname{rank}(A^{\mathrm H}A)=\operatorname{rank}(AA^{\mathrm H})=\operatorname{rank}(A^{\mathrm H})$ | 实 / 复内积空间 | 长方阵满秩 $\leftrightarrow$ 方阵可逆的桥梁（[@prop-3.1.1]） |
| 3 | 左右乘可逆矩阵不改变秩；相抵 $\iff$ 同秩 | 任意 | 秩的计算与判定（[@note-3.1-rank]） |
| 4 | 行满秩 $\iff$ 有**右**逆；列满秩 $\iff$ 有**左**逆；通式 $B=B_0+Z$，$Z$ 各列 $\in N(A)$ | 长方阵 | 单侧逆的构造与「全部右逆」（[@thm-3.1.1]） |
| 5 | $N(C)\subseteq N(A)$ 时 $\operatorname{rank}C\ge\operatorname{rank}A$ | 任意 | 由解集包含关系夹逼秩（[@thm-3.2.1] 方法 2 的引擎） |
| 6 | $R(B)=R(A)$（当 $A=BC$ 且 $C$ 行满秩） | 行满秩 $C$ | 满秩分解把列空间收进 $B$（[@thm-3.2.2] 证明第一步） |

### 2.2 特征值、迹与相似

| # | 结论 | 前提 | 典型用途 |
|:--|:--|:--|:--|
| 7 | $\operatorname{tr}A=\sum\lambda_i$，$\det A=\prod\lambda_i$（含重数） | 任意方阵 | 求根后的**第一步验算**（[@thm-eig-trace]） |
| 8 | 相似不变量：特征多项式、特征值（含重数）、迹、行列式、秩 | 相似 | 换基 / 相似变换后的账本（[@thm-sim-invariants]） |
| 9 | $\varphi(A)$ 的特征值为 $\varphi(\lambda_i)$；特款：$A^m\to\lambda_i^m$、可逆时 $A^{-1}\to\lambda_i^{-1}$ | 任意多项式 $\varphi$ | 谱映射；幂、逆、多项式的特征值一步到位（[@cor-3.5.1]、[@thm-eig-power]） |
| 10 | 几何重数 $\le$ 代数重数；**处处取等 $\iff$ 可对角化** | 任意方阵 | 可对角化判据（[@thm-mult-ineq]、[@thm-geom-mult]） |
| 11 | $n$ 个**互异**特征值 $\Rightarrow$ 可对角化（充分不必要） | 方阵 | 快速判定（[@thm-eig-independent]） |
| 12 | 上三角（下三角）阵的特征值 $=$ 对角元；可逆 $\iff$ 对角全非零 | 三角阵 | 三角化之后一切从简（多处使用，如 [@thm-3.5.4] 证明） |
| 13 | 正交阵特征值 $|\lambda|=1$、$\det=\pm1$（酉：$|\det|=1$）；**实特征值**才是 $\pm1$ | 正交 / 酉 | 高频陷阱题（[@thm-orth-eig]、[@thm-orth-algebra]） |

### 2.3 分解专线（只列最常引用的一行版）

| # | 结论 | 前提 | 典型用途 |
|:--|:--|:--|:--|
| 14 | 相抵：标准形 $\Gamma$ 唯一（由秩定）；分解式不唯一（差吸收矩阵） | 任意 | 「不唯一」与「唯一」的对号（[@note-3.1-nonunique]、[@note-3.1-rank]） |
| 15 | 满秩分解：$R(B)=R(A)$；两种分解差**可逆** $D$：$B_1=B_2D$、$C_1=D^{-1}C_2$；任取可逆 $D$ 生成新分解 | $r>0$ | 「一个生成全部」（[@thm-3.2.2]、[@note-3.2.unique]） |
| 16 | QR 唯一性：**正线**下唯一；去正线后两种分解差**对角酉阵**（实：$2^n$ 种） | 满秩方阵 | 唯一性的精确刻度（[@thm-3.4.1]、[@ex-3.4.B]） |
| 17 | **上三角 $\wedge$ 酉 $\Rightarrow$ 对角**、$\lvert w_{ii}\rvert=1$；再正对角 $\Rightarrow I$ | — | QR 唯一性证明的引擎（习题 B12） |
| 18 | 列满秩长方阵：$A=U\begin{bmatrix}R_1\\O\end{bmatrix}$，$U$ 酉 | $n\le m$ | 完全分解、最小二乘的入口（[@cor-3.4.1]） |
| 19 | QR 迭代保相似：$A_{k+1}=Q_k^{\mathrm H}A_kQ_k$；模互异 $\Rightarrow$ 对角元 $\to$ 特征值 | 可逆 | QR 算法的全部算术意义（[@method-qr-algo]） |
| 20 | Schur：复方阵总酉相似于上三角；实方阵需**特征值全实**才有正交三角化 | 复数 / 实+全实 | 「能不能三角化」的判据与实数域边界（[@thm-3.5.2]、[@thm-3.5.3]） |
| 21 | H–C：$f_A(A)=O$；$g(A)=r(A)$（$g=qm_A+r$ 或 $=qf_A+r$） | 任意 | 一切高次多项式降次（[@thm-3.5.4]） |
| 22 | $m_A$ 唯一、整除一切零化多项式（$\Rightarrow m_A\mid f_A$）、与 $f_A$ 同根（不计重数） | 任意 | 候选法的全部依据（[@thm-3.5.5]） |
| 23 | $A^{-1}=\pm\frac{1}{\cdot}$ 公式：$A^{-1}=-\frac{1}{a_0}(A^{n-1}+a_{n-1}A^{n-2}+\cdots+a_1I)$ | $A$ 可逆（$a_0\ne0$） | 「求逆」与「特征多项式」互相翻译（[@cor-3.5.2]） |

### 2.4 常用小事实（一行可验，背下来省事）

- **二阶矩阵速算**：$f_A(\lambda)=\lambda^2-(\operatorname{tr}A)\lambda+\det A$——二阶题先在草稿角上写下 $(\operatorname{tr},\det)$，特征值即刻可试凑整数根。
- **严格三角阵幂零**：$n$ 阶严格上（下）三角阵 $N$ 满足 $N^n=O$（[@ex-3.5.3] 的 $3$ 阶情形用了 $N^3=O$）；它的多项式 / 几何级数可截断。
- **分块三角的行列式**：$\det\begin{bmatrix}B&C\\O&D\end{bmatrix}=\det B\cdot\det D$（[@thm-3.5.1] 证明用过）。
- **$A$ 与 $A^{\mathrm T}$ 同特征多项式**：$\det(\lambda I-A^{\mathrm T})=\det\big((\lambda I-A)^{\mathrm T}\big)=\det(\lambda I-A)$——一行验证，转置不改变特征值的常用依据。
- **幂等 / 对合**：$A^2=A\Rightarrow$ 特征值 $\in\{0,1\}$；$A^2=I\Rightarrow$ 特征值 $\in\{\pm1\}$——由 $A^2\boldsymbol x=\lambda^2\boldsymbol x$ 一行即得。
- **正交阵的逆**：$A^{-1}=A^{\mathrm H}$，且 $A^{\mathrm H}A=I$ 逐列读就是「标准正交基」（[@thm-orth-columns]）。

## 三、反例弹药库（判断题专用）

判断题的通行策略：**先找反例，再考虑证明**。下表是最短反例（多数一行可验），靠前的是出现频率最高的坑。

| 错误主张 | 一颗就够了 | 出处 |
|:--|:--|:--|
| 「实矩阵总能正交（三角）化」 | 旋转阵 $\begin{bmatrix}0&-1\\1&0\end{bmatrix}$，特征值 $\pm\mathrm i$ | [@thm-3.5.3] 反例 |
| 「QR 分解唯一」 | $I_2$ 有两种分解（正线才唯一；$\begin{bmatrix}-1&0\\0&1\end{bmatrix}$ 作 $Q$） | [@ex-3.4.1] |
| 「正交阵特征值是 $\pm1$」 | 旋转阵（$\pm\mathrm i$，模 1 而非实） | [@thm-orth-eig] 后的勘误注 |
| 「$r_{kk}=\|\boldsymbol a_k\|$」 | [@ex-3.4.A] 中 $r_{22}=\tfrac25$，而 $\|\boldsymbol a_2\|=\sqrt5$ | [@ex-3.4.A] |
| 「不满秩不能 QR 分解」 | $\begin{bmatrix}1&1\\0&0\end{bmatrix}=I_2\begin{bmatrix}1&1\\0&0\end{bmatrix}$ | [@ex-3.4.2] |
| 「对角元全零 $\Rightarrow$ 零矩阵」（「特征值全零 $\Rightarrow$ $A=O$」） | $\begin{bmatrix}0&1\\0&0\end{bmatrix}$ | [@thm-3.5.4] 证明前的提醒 |
| 「最小多项式 $=f_A$」 | $I_2$：$f_A=(\lambda-1)^2$，$m_A=\lambda-1$ | [@ex-3.5.1] 后 |
| 「$AB=I$（长方阵）可推出 $BA=I$」 | $A=\begin{bmatrix}1&0&0\\0&1&0\end{bmatrix}$、$B=A^{\mathrm T}$ | [@thm-3.1.1] 注 |
| 「满秩分解唯一」 | $A=I_2A$ 与从 $A$ 的列取基的分解 | [@note-3.2-columns] |
| 「相抵分解可唯一」 | 吸收矩阵一乘就出新分解 | [@note-3.1-nonunique] |
| 「行满秩有左逆」 | 方向反了：$2\times3$ 矩阵只有右逆 | [@thm-3.1.1] |
| 「复空间内积用转置」 | $\mathbb C^1$，$x=1$、$y=\mathrm i$：$y^{\mathrm T}x=\mathrm i$ 但不是实数长度 | 第一章勘误注 |
| 「$\varphi(A)$ 的特征向量都是 $A$ 的特征向量」 | $A=\operatorname{diag}(1,-1)$、$\varphi=\lambda^2$：$\varphi(A)=I$ | [@note-3.5-eigvec] |

## 四、验算清单（每道题的最后 30 秒）

| 题型 | 最短验算 | 不过先查 |
|:--|:--|:--|
| 相抵分解 | $EAF=\Gamma$ | $E$、$F$ 的身份（读块）没弄反？ |
| 解方程组 | 通解代回；自由数 $n-r$ | 判可解用的是 $E\boldsymbol b$？$\boldsymbol x=F\boldsymbol y$ 乘回了？ |
| 单侧逆 | $AB=I$ / $BA=I$ | 方向（行满秩配右逆）？ |
| 满秩分解 | $BC=A$ | $B$ 是 $A$ 的主元列？$C$ 是非零行？ |
| QR 分解 | $QR=A$；对角全正 | 对角元取了残差范数？长方阵 $R$ 垫零块？ |
| QR 算法 | 每步 $\operatorname{tr}$ 不变；终值验特征值 | 迭代方向 $Q^{\mathrm H}(\cdot)Q$？ |
| 最小多项式 | $m_A\mid f_A$；同根；$m_A(A)=O$ | 候选从低往高试了？ |
| $g(A)$ | $g=qm_A+r$ 的除法回乘；$r(A)$ 代回 | 除以 $f_A$ 还是 $m_A$？余式度数 $<\deg m_A$？ |
| $A^m$ | 迹 / 对角元与 $\sum\lambda^m$；对称形 | 系数在特征值处兑现了？ |
| $A^{-1}$ | $AA^{-1}=I$ | $-\frac{1}{a_0}$ 的负号？ |
| 特征值 | $\sum\lambda=\operatorname{tr}$、$\prod\lambda=\det$ | 因式分解漏根 / 丢重数？ |
| GS / 投影 | 残差与基名内积为零 | 基真的正交吗？ |
| Givens / Householder | $T^{\mathrm T}T=I$、$T\boldsymbol x$ 的目标分量为零 | 用**更新后**的向量取角？ |

::: note 把验算变成习惯的三句话

1. **先写下验算式再写答案**——验算式是免费的保险，写完整答案再验是赌运气的重建；
2. **数字丑不是错，结构错才是错**——$\sqrt{205}$ 之类的丑数照样对（[习题 C22](ch03/exercises.md#ex-C22) 就是），但「对称阵的幂不对称」「三角阵的平方不三角」一定是错；
3. **每张流程卡的「易错」一句话，考前一晚过一遍**——它们基本就是本教程全部勘误与错题的死因汇总。
:::

## 五、做题前 10 秒：前提雷达

任何结论之前，先把题目里的**关键词**扫一遍，对照下表——每个箭头都是「前提 → 前提不满足时会发生什么」。

| 雷达词 | 要问的 | 反例警告 |
|:--|:--|:--|
| **方阵还是长方阵？** | 相抵 / 相似 / 特征值 / 单侧逆的适用面不同 | 长方阵谈「相似」「可逆」都无定义；$AB=I$ 不等于 $BA=I$ |
| **满秩还是不满？** | QR 唯一性、$R$ 正线、单侧逆的存在都要满秩 | 不满秩 QR 仍存在但不唯一；满秩分解要求 $r>0$ |
| **实还是复？** | 内积用 $\mathrm H$；正交 vs 酉；Schur 是否需要实数前提 | 实旋转阵不能正交三角化；复空间少共轭就出错 |
| **特征值全实吗？** | 实方阵 Schur 引理（定理 3.5.3）的硬前提 | 旋转阵就是反例 |
| **对角元为正吗？** | QR 的「正线」约定是唯一性的开关 | 去正线差一个对角酉阵 |
| **多项式是 $f_A$ 还是 $m_A$ 还是随便 $g$？** | 降次除谁：除以 $m_A$ 最省 | 三者角色混用是连锁错之源（勘误 E3.5） |
| **结构、初始分量和相位条件齐全吗？** | QR 算法的收敛与排序须单独论证 | 异模两周期、等模旋转阵不三角化 |
| **基是正交的吗？** | 投影公式、GS 简化都要先验正交 | 非正交基直接套公式必错（勘误 E12） |

---

**依据**第一至三章正文的全部定理、推论与勘误汇总整理 · 二级结论均给出前提与出处，可逐条回正文核对 · 流程卡的算例链接指向各章例题与习题 · 与[考场竞技场](ch03/arena.md)的分工：本页管「怎么算对」，竞技场管「限时怎么拿分」 · 整理日期 2026-10-15。
