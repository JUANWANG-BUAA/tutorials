# 闭卷回忆卡 · 第二章：运动学

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。全章共 33 张卡（定义 9 / 结论 8 / 公式 8 / 陷阱 8），一轮约 40 分钟。

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾用三种记号标记自己：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起。下一轮只重做 △ 与 ×。公式卡请**手写默写**（C 组），不要只在心里过。

## A. 定义卡

### A1 · 旋转矩阵与 $SO(3)$

写出旋转矩阵的列是什么、两条代数性质，以及 $SO(3)$ 的定义式。

::: note A1 核对
把 9 个方向余弦**按列**排成 $R=\begin{bmatrix}\boldsymbol x'&\boldsymbol y'&\boldsymbol z'\end{bmatrix}$，**每一列就是固连系对应轴在参考系中的表示**（故又称方向余弦阵）。两条性质：**正交性** $R^{\mathrm T}R=I_3$（等价 $R^{-1}=R^{\mathrm T}$）、行列式 $\det R=+1$（右手系；$\det=-1$ 是含镜像的左手系，不属于 $SO(3)$）。$SO(3)=\{R\in\mathbb R^{3\times3}:R^{\mathrm T}R=I_3,\ \det R=1\}$。（[@def-2.2.1]、[@def-2.2.2]）
:::

### A2 · 9 量、6 约束、3 独立

写出这本账的三步，并指出它是哪些表示的出发点。

::: note A2 核对
$R$ 表面 9 个元素；三列**模长为 1** 给 3 个约束、三列**两两垂直**再给 3 个约束 ⇒ **一共 6 个约束压掉 6 个自由度，独立参数只剩 3 个**。这本账是 ZYZ / RPY 欧拉角（3 参数）、角和轴（4 参数 − 1 约束 = 3）、单位四元数（4 − 1 = 3）以及操作空间取最简表示的共同出发点。（[@note-2.2.2]）
:::

### A3 · 旋转矩阵的三重几何身份

同一个 $R$ 有哪三种读法？各配一个工程例子。

::: note A3 核对
① **姿态描述**（两坐标系之间的相对指向，列 = 动系轴在参考系中的方向余弦）；② **坐标变换**（同一点在两系**原点重合**时坐标之间的关系，$\boldsymbol p=R\boldsymbol p'$）；③ **旋转算子**（**同一坐标系内**把向量转到新方向的算子）。例：报工具相对法兰的朝向 / 把相机系坐标搬到基座系 / 把刀尖向量绕刀轴转 $30°$。注意 [@ex-book-2.1] 与 [@ex-book-2.2] 形式完全相同而语义不同——读公式先问「同一点还是同一个系」。（[@thm-2.2.B]）
:::

### A4 · ZYZ 与 RPY 的序列与轴族

分别写出两种欧拉角的旋转序列、各绕哪一族轴、乘法的方向。

::: note A4 核对
**ZYZ**：绕参考系 $z$ 转 $\varphi$ → 绕**新** $y'$ 转 $\vartheta$ → 绕**新** $z''$ 转 $\psi$；三步都绕**当前轴** ⇒ **依次右乘** $R_z(\varphi)R_{y'}(\vartheta)R_{z''}(\psi)$，机器人学惯用。**RPY（ZYX）**：绕**固定** $z$ 转 $\varphi$（偏航）→ 绕固定 $y$ 转 $\vartheta$（俯仰）→ 绕固定 $x$ 转 $\psi$（滚转）；全绕**固定轴** ⇒ **依次左乘** $R_z(\varphi)R_y(\vartheta)R_x(\psi)$，航空航海惯用。两者互为左 / 右乘对偶。（[2.4.2](sec2-4.md#sec-2.4.2)、[2.4.5](sec2-4.md#sec-2.4.5)）
:::

### A5 · 角和轴表示与表示不唯一

写出四参数表示、单位约束与不唯一性。

::: note A5 核对
任一旋转由**旋转轴的单位向量** $\boldsymbol r$ 与**旋转角** $\vartheta$（绕 $\boldsymbol r$ 逆时针为正）共同表示，记 $R(\vartheta,\boldsymbol r)$；共 4 个参数，超出最简的 3 个，故为**非最简表示**，但 $\boldsymbol r$ 受 $r_x^2+r_y^2+r_z^2=1$ 约束，扣掉后独立参数仍为 3。**表示不唯一**：$R(-\vartheta,-\boldsymbol r)=R(\vartheta,\boldsymbol r)$——「绕 $-\boldsymbol r$ 转 $-\vartheta$」与「绕 $\boldsymbol r$ 转 $\vartheta$」是同一旋转，两组参数都留在表示里、无人裁决。（[@def-2.5.1]、[@thm-2.5.A]）
:::

### A6 · 齐次坐标与齐次变换矩阵

写出齐次坐标、$A$ 的分块结构，并说明 $A$ 还正交吗。

::: note A6 核对
$\tilde{\boldsymbol p}=\begin{bmatrix}\boldsymbol p\\1\end{bmatrix}$；$A_1^0=\begin{bmatrix}R_1^0&\boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$，属于**特殊欧几里得群** $SE(3)=\mathbb R^3\times SO(3)$。分块职责：**左上 $3\times3$ 管指向、右上 $3\times1$ 管位置、底行占位**（当两系原点重合时退化为纯旋转）。$A$ **不再保持正交性**：一般地 $A^{-1}\neq A^{\mathrm T}$。（[@def-2.7.1]）
:::

### A7 · DH 参数与"3 常 1 变"

写出四个参数的几何含义、哪些恒为常数、变量怎么定。

::: note A7 核对
| 参数 | 含义 | 属性 |
|:--|:--|:--|
| $a_i$ | **杆件长度**（公垂线长度，沿 $x_i$） | 恒为常数 |
| $d_i$ | **关节距离**（$o_i'$ 沿 $z_{i-1}$ 的坐标） | 移动关节时为变量 |
| $\alpha_i$ | **杆件扭角**（$z_{i-1}$ 与 $z_i$ 的夹角，绕 $x_i$ 逆时针为正） | 恒为常数 |
| $\vartheta_i$ | **关节转角**（$x_{i-1}$ 与 $x_i$ 的夹角，绕 $z_{i-1}$ 逆时针为正） | 转动关节时为变量 |

**3 常 1 变**：$a_i,\alpha_i$ 永远常数；$d_i$ 与 $\vartheta_i$ 中**恰有一个**是关节变量 $q_i$，由**关节类型**决定。相邻坐标系本来需要 6 个量，DH 建系规则把它压到 4 个。**注意约定不止一种**：本编与原书用**标准（经典）DH**（$z_{i-1}$ 沿关节 $i$ 的轴），Craig《机器人学导论》用**改进 DH**（$z_i$ 沿关节 $i$ 的轴、次序「先转 $\alpha$ 后转 $\vartheta$」）——两套各自自洽、**混用必错**；读文献遇 DH 表对不上时，先查约定再怀疑自己（[勘误 E2.4](errata.md#errata-2.4)）。（[@def-2.8.3]）
:::

### A8 · 逆运动学的四难点与存在性判据

写出四条难点，并给出解存在的判据。

::: note A8 核对
① **非线性**（三角函数的复合，闭合形式解未必存在）；② **多重解**（同一末端位姿可对应多组关节变量；无穷位限的 6 自由度机械手可多达 **16** 组解）；③ **无穷多解**（运动学冗余）；④ **可能无解**（位姿超出可达 / 灵活工作空间）。**存在性判据**：位姿落在**灵活工作空间**内，解就必然存在。解法版图：正运动学不管什么臂都能算，**逆运动学没有通用解析法，只能针对特殊构型**。**解不出来先查三件事**：① 是否扣了 $d_6$（$\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$）；② 是否落在工作空间内（容许性条件 $|c_2|\le1$、$|c_3|\le1$、$p_{wx}^2+p_{wy}^2\ge d_2^2$ 是否满足）；③ 是否处在奇点（$s_5=0$ 时腕 4、6 轴共线、解不唯一甚至无穷多）。（[@thm-2.12.A]）
:::

### A9 · 解耦的充分条件与腕心

写出闭式逆解的两个充分条件与腕心公式，并说明 $d_6$ 的角色。

::: note A9 核对
6 自由度结构具有**闭合形式逆解**的充分条件（满足其一）：**① 三个连续转动关节的轴交于一点**（球形腕）；**② 三个连续转动关节的轴平行**。解耦点：**腕心** $\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$——沿接近向量从末端原点回退 $d_6$（工具长度）即得。$d_6$ 的角色：它是腕心到末端原点的「外移长度」，**不扣掉它就分不清解出的是腕心的角还是工具端的角**。（[@thm-2.12.B]、[@method-2.12.decouple]）
:::

## B. 结论卡

### B1 · 右乘当前轴、左乘固定轴（以及两者为什么互为镜像）

写出两条规则，并说明「先 $z$ 后 $y'$」与「先 $y$ 后 $z$」的关系。

::: note B1 核对
**绕当前轴**（每次绕上一个旋转产生的新坐标系）⇒ 按发生顺序**依次右乘**：$R_n^0=R_1^0R_2^1\cdots R_n^{n-1}$；**绕固定轴** ⇒ **依次左乘**（前乘），先转的落在右边。两条规则的**时序互为镜像**：当前轴「先 $z$ 后 $y'$」与固定轴「先 $y$ 后 $z$」给出**同一个终态**，且乘积写出来完全相同。所以「固定轴按序 $(\vartheta_1,\vartheta_2)$」=「当前轴按序 $(\vartheta_2,\vartheta_1)$」。（[@thm-2.3.A]、[@thm-2.3.B]、[@ex-2.3.C]）
:::

### B2 · 三个基本旋转的记忆结构

写出一句记忆法，并指出哪一个矩阵的 $\sin$ 项符号与另两个不同。

::: note B2 核对
**绕谁转，谁那一行 / 列就是 $[0\ 0\ 1]$ 型的「钉住」结构**，其余 $2\times2$ 是平面内的 $c,s$ 旋转块（符号按右手准则）。三条常用关系：$R_k(-\vartheta)=R_k^{\mathrm T}(\vartheta)$。**$R_y$ 的 $\sin$ 项符号与 $R_x,R_z$ 相反**（$R_y(\beta)$ 的 $(1,3)$ 元为 $+s_\beta$、$(3,1)$ 元为 $-s_\beta$）——这是默写最常翻车的一处，[2.2](sec2-2.md) 的默写点专门提示过。
:::

### B3 · 27 种组合里为什么只剩 12 种

说明取舍机制，并指出 ZYZ 与 RPY 的奇点各在什么条件。

::: note B3 核对
三个轴共有 27 种排列，其中只有 **12 种可行**：若序列中出现「**连续绕同一轴**」（如 $XXX$、或 $ZXX$ 里的相邻同轴段），两次同轴旋转可以**合并成一次**，三个角实际只贡献两个独立转动方向，任意的终态姿态就「转不出来」了。**奇点**：ZYZ 在 $s_\vartheta=0$（$\vartheta=0,\pi$，进动轴与自转轴重合）时只能确定 $\varphi\pm\psi$ 的和或差；RPY 在 $c_\vartheta=0$（俯仰 $\pm90°$）时只能确定 $\varphi$ 与 $\psi$ 的和或差。（[2.4.1](sec2-4.md#sec-2.4.1)、[@thm-2.4.B]）
:::

### B4 · 为什么反解一律用 Atan2（两条理由）

写出两条理由，并给出两个反函数的导数。

::: note B4 核对
① **不唯一**：$\arccos$ 只在 $[0,\pi]$ 取值，无法覆盖 $(-\pi,\pi]$ 内的完整角度；② **精度不均匀**：$(\arccos x)'=-1/\sqrt{1-x^2}$ 在 $x\to\pm1$（即 $\vartheta\to0$ 或 $\pi$）处**无界**，微小输入误差被无限放大；而 $(\arctan x)'=1/(1+x^2)\in(0,1]$ 处处**有界且不超过 1**。改用双变量 $\varphi=\operatorname{Atan2}(y,x)$，用 $x,y$ 各自的符号判定象限，在 $(-\pi,\pi]$ 内唯一确定角度。（[@thm-2.4.A]）
:::


### B5 · 齐次链式变换与非正交性

写出连乘公式，并说明「为什么 $A^{-1}\neq A^{\mathrm T}$」。

::: note B5 核对
$\tilde{\boldsymbol p}^0=A_1^0A_2^1\cdots A_n^{n-1}\tilde{\boldsymbol p}^n$——一串坐标系对应一串矩阵连乘，这正是 DH 正运动学 $T_n^0=A_1^0\cdots A_n^{n-1}$ 的地基。写 $A$ 的逆按**分块公式**：旋转块取转置、平移块先反向再左乘转置。**非正交的根源**：正交性只在**旋转块**内成立，右上角的平移块使整个 $4\times4$ 矩阵不再满足 $A^{\mathrm T}A=I$。（[@thm-2.7.A]、[2.7.3](sec2-7.md#sec-2.7.3)）
:::

### B6 · 接口一致才能连乘

举出「接口一致」与「接口不一致」各一例，并说明不一致时怎么办。

::: note B6 核对
**接口一致**：斯坦福机械手 = 球形臂 ⊕ 球形腕，而两者的**坐标系 3 一致**，故 $T_6^0=T_3^0T_6^3$ 可以直接连乘（当 $d_6=0$ 时位置向量与单一球形臂相同）。**接口不一致**：带球形腕的拟人臂——拟人臂的系 3 与球腕的系 3 **不一致**（$x_3$ 相差 $\pi/2$、原点相差 $a_3$），不能直接连乘。**出路两条**：插入常值变换把接口对齐，或者**整体重建系**（原书走的是后一条，参数表第 3、4 行随之改变）。（[2.9.6](sec2-9.md#sec-2.9.6)、[2.9.7](sec2-9.md#sec-2.9.7)）
:::

### B7 · 标定为什么必须迭代

写出标定的三步，并说明「一轮线性化」为什么不够。

::: note B7 核对
三步：① **线性化** $\Delta\boldsymbol x=\Phi\Delta\boldsymbol\xi$（$\Phi$ 为 $m\times4n$ 的**运动学标定矩阵**，即参数空间到操作空间的雅可比）；② **超定量测 + 最小二乘** $\Delta\boldsymbol\xi=(\Phi^{*\mathrm T}\Phi^*)^{-1}\Phi^{*\mathrm T}\Delta\boldsymbol x^*$，量测条件 $tm\ge4n$（且建议 $tm\gg4n$ 以免 $\Phi^{*\mathrm T}\Phi^*$ 病态）；③ **修正 + 迭代** $\boldsymbol\xi'=\boldsymbol\xi+\Delta\boldsymbol\xi$。**为什么迭代**：$\boldsymbol x_e=k(\boldsymbol\xi)$ 是**非线性**的，一步线性化只在小偏差假定下成立；每轮都要用新参数**同时刷新三样**——参数、线性化矩阵 $\Phi$、以及新的偏差 $\Delta\boldsymbol x$。（[@method-2.11.steps]）
:::

### B8 · 工作空间与两种冗余

写出两个工作空间的包含关系，以及两种冗余的判据。

::: note B8 核对
**可达工作空间**（至少能从**一个**方向到达的点的集合）⊇ **灵活工作空间**（能从**任意**方向到达的点的集合）。可达工作空间是 $\boldsymbol p_e(\boldsymbol q)$ 在关节限位盒子下的像，作为连续函数的像**有界、闭合、连通**，边界由**平面 / 球形 / 环形 / 圆柱形**曲面元素拼成；厂商手册的俯视 + 侧视图画的就是它（不含末端执行器）。**冗余**：**本质冗余** $m<n$（关节空间维数超过任务位形空间维数）；**功能冗余** 即便 $m=n$，特定任务只用 $r<m$ 个操作分量时也冗余——**冗余总是相对任务而言**。（[@def-2.10.2]、[@def-2.10.3]）
:::

## C. 公式卡

### C1 · 三个基本旋转（默写）

写出 $R_x,R_y,R_z$ 与负角关系。

::: note C1 核对
$$R_x(\gamma)=\begin{bmatrix}1&0&0\\ 0&c_\gamma&-s_\gamma\\ 0&s_\gamma&c_\gamma\end{bmatrix},\quad
R_y(\beta)=\begin{bmatrix}c_\beta&0&s_\beta\\ 0&1&0\\ -s_\beta&0&c_\beta\end{bmatrix},\quad
R_z(\alpha)=\begin{bmatrix}c_\alpha&-s_\alpha&0\\ s_\alpha&c_\alpha&0\\ 0&0&1\end{bmatrix};$$
$$R_k(-\vartheta)=R_k^{\mathrm T}(\vartheta),\qquad k=x,y,z .$$
约定**逆时针方向为正**。默写完先自查两件事：被绕的那一行 / 列是否「钉住」；$R_y$ 的符号是否与另两个相反。
:::

### C2 · ZYZ / RPY 的正解与逆解（第一支）

写出两种表示的正解乘积顺序与逆解三式（ZYZ 给第一支，RPY 给 $\vartheta\in(-\pi/2,\pi/2)$ 一支）。

::: note C2 核对
**ZYZ 正解**：$R=R_z(\varphi)R_{y'}(\vartheta)R_{z''}(\psi)$（第三列 = $[c_\varphi s_\vartheta,\ s_\varphi s_\vartheta,\ c_\vartheta]^{\mathrm T}$）。**ZYZ 逆解（第一支，设 $s_\vartheta\ne0$）**：
$$\varphi=\operatorname{Atan2}(r_{23},r_{13}),\quad \vartheta=\operatorname{Atan2}\!\big(\sqrt{r_{13}^2+r_{23}^2},\,r_{33}\big),\quad \psi=\operatorname{Atan2}(r_{32},-r_{31});$$
第二支三个宗量**整体变号**（在 $(-\pi,0)$ 中选 $\vartheta$）。
**RPY 正解**：$R=R_z(\varphi)R_y(\vartheta)R_x(\psi)$。**RPY 逆解**（$\vartheta\in(-\pi/2,\pi/2)$）：$\varphi=\operatorname{Atan2}(r_{21},r_{11})$、$\vartheta=\operatorname{Atan2}(-r_{31},\sqrt{r_{11}^2+r_{21}^2})$、$\psi=\operatorname{Atan2}(r_{32},r_{33})$。
**反解策略口诀**：**挑只含单个角度的元素——先 $\varphi$ 后 $\vartheta$ 再 $\psi$**（ZYZ 用第三列定 $\varphi,\vartheta$、第三行定 $\psi$）。（[2.4.4](sec2-4.md#sec-2.4.4)、[2.4.5](sec2-4.md#sec-2.4.5)）
:::

### C3 · Rodrigues 紧凑形式、指数映射与逆解

写出紧凑形式、两个幂次关系、$\exp$ 闭式，以及由 $R$ 求 $(\vartheta,\boldsymbol r)$ 的两式。

::: note C3 核对
**紧凑形式**：$R(\vartheta,\boldsymbol r)=c_\vartheta I+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$。**幂次三循环**：$S^2=\boldsymbol r\boldsymbol r^{\mathrm T}-I$、$S^3=-S$。**指数映射**：$\exp(\vartheta S)=I+\sin\vartheta\,S+(1-\cos\vartheta)S^2$，即 $R(\vartheta,\boldsymbol r)=\exp(\vartheta S(\boldsymbol r))$。**逆解**：取**迹**求角 $\cos\vartheta=\dfrac{r_{11}+r_{22}+r_{33}-1}{2}$；取**反对称部分**求轴 $\boldsymbol r=\dfrac{1}{2\sin\vartheta}\begin{bmatrix}r_{32}-r_{23}\\ r_{13}-r_{31}\\ r_{21}-r_{12}\end{bmatrix}$（$s_\vartheta\neq0$）。失效点：$\vartheta=0$ 轴**完全任意**；$\vartheta=\pi$ 反对称部分为零，须由对称部分 $r_i^2=(r_{ii}+1)/2$ 恢复。（[@def-2.5.1]、[@thm-2.5.D]–[@thm-2.5.E]）
:::

### C4 · 四元数正解 / 逆解 / 逆 / 乘

写出四组公式。

::: note C4 核对
**换算与约束**：$\eta=\cos\frac\vartheta2$、$\boldsymbol\epsilon=\sin\frac\vartheta2\boldsymbol r$、$\eta^2+\epsilon_x^2+\epsilon_y^2+\epsilon_z^2=1$。**正解**：$R=(2\eta^2-1)I+2\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T}+2\eta S(\boldsymbol\epsilon)$。**逆解**（取 $\eta\ge0$）：$\eta=\frac12\sqrt{r_{11}+r_{22}+r_{33}+1}$，$\epsilon_i=\frac12\operatorname{sgn}(r_{kj}-r_{jk})\sqrt{r_{ii}-r_{jj}-r_{kk}+1}$（$i,j,k$ 互异）。**逆**：$Q^{-1}=\{\eta,-\boldsymbol\epsilon\}$（单位四元数的共轭就是逆）。**乘**：$Q_1\otimes Q_2=\{\eta_1\eta_2-\boldsymbol\epsilon_1^{\mathrm T}\boldsymbol\epsilon_2,\ \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\}$——含叉积项 ⇒ **不可交换**。（[@def-2.6.1]、式 2.33–2.37）
:::

### C5 · 齐次变换的逆

写出分块公式，并用一句话说明它为什么正确。

::: note C5 核对
$$A_0^1=(A_1^0)^{-1}=\begin{bmatrix}R_1^{0\mathrm T}&-R_1^{0\mathrm T}\boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}
=\begin{bmatrix}R_0^1&-R_0^1\boldsymbol o_1^0\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}.$$

**读法**：旋转块取转置，平移块**先反向、再左乘转置**。一句话验证：分块乘一次即得单位阵（左上用 $R^{\mathrm T}R=I$，右上两项恰好相消）。**边界**：方向向量（自由向量）的变换**只用左上块** $R$——自由向量不吃平移。
:::

### C6 · DH 关节变换 $A_i^{i-1}$

默写 $4\times4$ 矩阵，并指出第 4 列三个元素各对应哪个参数。

::: note C6 核对
$$A_i^{i-1}(q_i)=\begin{bmatrix}
c_{\vartheta_i}&-s_{\vartheta_i}c_{\alpha_i}&s_{\vartheta_i}s_{\alpha_i}&a_ic_{\vartheta_i}\\
s_{\vartheta_i}&c_{\vartheta_i}c_{\alpha_i}&-c_{\vartheta_i}s_{\alpha_i}&a_is_{\vartheta_i}\\
0&s_{\alpha_i}&c_{\alpha_i}&d_i\\
0&0&0&1\end{bmatrix}.$$

**第 4 列** $=(a_ic_{\vartheta_i},\ a_is_{\vartheta_i},\ d_i,\ 1)^{\mathrm T}$——**三个参数的「肉身」**：$d_i$ 躺在转轴上原样保留，$a_i$ 的方向被 $\vartheta_i$ 旋转。旋转块 = 「绕 $z$ 转 $\vartheta\oplus$ 绕 $x$ 转 $\alpha$」的复合。**两个退化自检**：$a_i=\alpha_i=d_i=0$ 退化为 $\mathrm{Rot}_z(\vartheta_i)$；$\vartheta_i=\alpha_i=a_i=0$ 退化为 $\mathrm{Trans}_z(d_i)$。（[@method-2.8.A]）
:::

### C7 · 平面臂、拟人臂、球形腕的正运动学（结果默写）

各写一行位置部分，并指出球形腕旋转块的特别之处。

::: note C7 核对
**三连杆平面臂**：$\boldsymbol p=[a_1c_1+a_2c_{12}+a_3c_{123},\ a_1s_1+a_2s_{12}+a_3s_{123},\ 0]^{\mathrm T}$，且 $z_3\parallel z_0$（三个关节只决定末端在平面内的位置）。**拟人臂**：$\boldsymbol p=[c_1(a_2c_2+a_3c_{23}),\ s_1(a_2c_2+a_3c_{23}),\ a_2s_2+a_3s_{23}]^{\mathrm T}$。**球形腕**：**旋转块 $R_6^3$ 与 ZYZ 合成矩阵完全一致**——$(\vartheta_4,\vartheta_5,\vartheta_6)$ 恰是相对系 3 的 ZYZ 角。这是全章最重要的一次结构观察：正运动学里看出来的东西，直接变成了 [2.12.6](sec2-12.md#sec-2.12.6) 的「腕逆解 = ZYZ 反解」。（[2.9.1](sec2-9.md#sec-2.9.1)、[2.9.4](sec2-9.md#sec-2.9.4)、[2.9.5](sec2-9.md#sec-2.9.5)）
:::

### C8 · 标定方程与量测条件

写出线性化方程、最小二乘解与量测条件。

::: note C8 核对
$$\Delta\boldsymbol x=\Phi\,\Delta\boldsymbol\xi,\qquad
\Delta\boldsymbol\xi=(\Phi^{*\mathrm T}\Phi^*)^{-1}\Phi^{*\mathrm T}\Delta\boldsymbol x^*,\qquad tm\ge4n\ (\text{宜}\ tm\gg4n).$$

$\Phi$ 是 $m\times4n$ 的**运动学标定矩阵**（参数空间到操作空间的雅可比）；$tm$ 是一组位姿量测给出的**方程总数**，$4n$ 是**未知数个数**；$(\Phi^{*\mathrm T}\Phi^*)^{-1}\Phi^{*\mathrm T}$ 即 $\Phi^*$ 的**左广义逆**。**追一句读数**：量测位姿过于集中 ⇒ $\Phi^{*\mathrm T}\Phi^*$ 接近奇异 ⇒ 必须铺满工作空间并留余量。（[@method-2.11.steps]）
:::

## D. 陷阱卡（先指出错在哪，再给正确说法）

### D1 · 「$z_{i-1}$ 就是 $[0,0,1]^{\mathrm T}$」

::: note D1 核对
**错。** $z_{i-1}$ 表示在**基坐标系**下，只有 $z_0$ 才是 $[0,0,1]^{\mathrm T}$；表示在它**自己**的坐标系下才是 $[0,0,1]$，表示在基坐标系下要乘很复杂的旋转矩阵。**正确做法**：$z_{i-1}=R_{i-1}$（即 $T_{i-1}^0$ 左上 $3\times3$ 块）的**第三列**，随位形变化。**连带提醒**：$p_{i-1}$ 是 $T_{i-1}^0$ 第四列前三行、$p_e$ 是 $T_n^0$ 第四列前三行——所需量全部来自正运动学。（[3.1.3](../ch03/sec3-1.md#sec-3.1.3)）
:::

### D2 · 「$\det R$ 取 $\pm1$ 无所谓」

::: note D2 核对
**错。** $\det R=-1$ 是**左手系**（含镜像翻转），不属于 $SO(3)$，用它算出来的是「照镜子」的假姿态。**理由**：正交性只给出 $(\det R)^2=1$；而右手系的固连坐标系总可以**连续**转回与参考系重合，$\det$ 是元素的连续函数、途中不可能从 $+1$ 跳到 $-1$，故右手系必为 $\det R=+1$。（[2.2.1](sec2-2.md#sec-2.2.1)）
:::

### D3 · 「$A^{\mathrm T}$ 就是 $A$ 的逆」

::: note D3 核对
**错。** 正交性只在**旋转块**内成立（原书式 2.46 明确 $A^{-1}\neq A^{\mathrm T}$）。**正确做法**：按分块公式装配——旋转块取转置、平移块 $-R^{\mathrm T}\boldsymbol o$。**顺手的误读**：把 $\boldsymbol o_1^0$ 读成「系 0 原点在系 1 中的坐标」（上下标读反）——记住口令「**右上块 = 动系原点用固定系的话说**」。（[2.7.3](sec2-7.md#sec-2.7.3)）
:::

### D4 · 「角度集合 $\boldsymbol\phi=[\varphi\ \vartheta\ \psi]^{\mathrm T}$ 是向量，可以相加」

::: note D4 核对
**错。** 角度集合只是**打包记号**——旋转**不满足交换律**（$R_1R_2\neq R_2R_1$），所以它**没有向量加法**：$\boldsymbol\phi_1+\boldsymbol\phi_2$ 不对应任何有意义的姿态合成，也不能线性插值（[4.3.3](../ch04/sec4-3-3.md) 的旋转矩阵插值问题同源）。**正确的合成方式**：把每个角写成矩阵（或四元数）再相乘。（[2.3](sec2-3.md) 常见错误 1）
:::

### D5 · 「$\arccos$ 反解角度最省事」

::: note D5 核对
**省事但不准。** 两个问题：**不唯一**（值域只有 $[0,\pi]$）、**精度均匀性最差**（导数 $1/\sqrt{1-x^2}$ 在 $x\to\pm1$ 处无界）。**正确做法**：凡反解一律 `Atan2(y,x)`（第一参数是分子），它用两参数的符号定象限、在 $(-\pi,\pi]$ 内唯一。**量级感**：数值实验里 $|\sin\vartheta|\le10^{-2}$ 的组别，偏差会被放大 $10^5$ 倍——这不是「多算几位」能解决的。（[@thm-2.4.A]）
:::


### D6 · 「四元数 $Q$ 与 $-Q$ 是漏了一个解」

::: note D6 核对
**错，它们表示同一旋转。** 双重覆盖来自 $\vartheta\sim\vartheta+2\pi$：转角多加满一整圈时 $\eta\to-\eta$、$\boldsymbol\epsilon\to-\boldsymbol\epsilon$，于是同一个物理旋转对应两个四元数。**逆解用 $\eta\ge0$ 约定**（$\vartheta\in[-\pi,\pi]$）为每个 $R$ **选定唯一一个** $Q$——「锁定符号」是人为却合法的约定。这与角和轴的**表示不唯一**（[@thm-2.5.A]）不是一回事：那里的两组**参数**都留在表示里、无人裁决。（[2.6](sec2-6.md)）
:::

### D7 · 「解耦矩阵可以拿去做逆解 / 速度控制」

::: note D7 核对
**错。** 奇点解耦（把参考点从末端挪到**腕心**）得到的下三角矩阵 $\begin{bmatrix}\dot{\boldsymbol p}_w\\ \boldsymbol\omega_e\end{bmatrix}=\begin{bmatrix}J_{11}&0\\ J_{21}&J_{22}\end{bmatrix}\begin{bmatrix}\dot{\boldsymbol q}_a\\ \dot{\boldsymbol q}_w\end{bmatrix}$ **只保行列式**、用于奇点分析：它**不再是「关节速度→末端速度」的映射**（参考点已经不是末端了）。**合法性的来源**：运动学奇点是**机械结构固有的特性，与坐标系建在哪里无关**，所以可以为了简化计算而重选参考系；但做完判断就必须**换回末端参考**再谈速度传递。（[@thm-3.3.A] 的适用边界）
:::

### D8 · 「逆解解不出来就是算法有 bug」

::: note D8 核对
**先查三件事再怀疑算法。** ① **是否扣了 $d_6$**：$\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$——手腕偏置没扣，解出来的就是错的关节角；② **是否落在可达 / 灵活工作空间内**：超出则**方程无解**（判据：$|c_2|\le1$、$|c_3|\le1$、$p_{wx}^2+p_{wy}^2\ge d_2^2$ 一类容许性条件不满足）；③ **是否处在奇点**：$s_5=0$ 时腕第 4、6 轴共线、转 $\vartheta_4$ 与 $\vartheta_6$ 效果相同，解不唯一甚至无穷多。**正确做法**：先用容许性条件筛掉工作空间外的点，再按「肘上 / 肘下 × 肩左 / 肩右」整理多支解，最后做回代验证。（[2.12.1](sec2-12.md#sec-2.12.1)、[2.12.4](sec2-12.md#sec-2.12.4)）
:::

## 导出到 Anki / CSV

**建卡组与录入**：Anki → 新建卡组「ROBOT-第 2 章」（与「ROBOT-全书」并列，勿混入默认卡组）；正面放「编号 + 题干」、背面放「核对答案 + 依据（[@def-…] / 章节链接）」，纯文本导入用 `Tab` 分隔正反面、一行一张（本页 33 张按 A1–A9 / B1–B8 / C1–C8 / D1–D8 顺序录入）。
2. **复习节点（1 / 3 / 7 天）与加保险**：**当天 → 第 1 天（隔天）→ 第 3 天 → 第 7 天**，共四轮，每轮只重做标 **△** 与 **×** 的卡；四轮后仍未「✓」的卡抄进 [errata.md](errata.md) 的待核实条目单独跟踪。**加一道保险**：C 组公式卡**必须手写默写**（尤其 C1 三个基本旋转、C6 的 $A_i^{i-1}$、C7 的三条位置式），写完拍照贴回卡背；建模类卡片（A7 DH 表、C7 三种结构）建议把 DH 表**在空白纸上重画一遍**。
