# 公式速查卡

七章的核心公式、9 张 DH 参数表、3 套逆解公式——它们散在 60 余个小节里。本页把它们**按「表示 → 传递 → 反解 → 微分 → 力 → 驱动与测量 → 控制」的顺序压成一页**，每条后面给出正文出处，供做题与复习时单点查阅。

::: note 怎么用这一页
- **做题卡壳时**：按下面的分节标题定位，不用翻正文；括号里的链接跳回推导与上下文。
- **考前自测时**：遮住右栏，只看「要算什么」，默写公式，再对答案。
- **符号约定**：$c_\vartheta=\cos\vartheta$、$s_\vartheta=\sin\vartheta$、$c_{12}=\cos(\vartheta_1+\vartheta_2)$；上下标读法「上标是参考系、下标是被描述对象」（$R_j^i$ = 系 $j$ 相对系 $i$），见[符号表](preface-notation.md)。
:::

---

## A · 姿态表示（第 2 章）

### A1 旋转矩阵的三条性质

| 要算什么 | 公式 | 出处 |
|:--|:--|:--|
| 正交性 | $R^{\mathrm T}R=I$，即 $R^{-1}=R^{\mathrm T}$ | [@def-2.2.2] |
| 行列式 | $\det R=+1$（$=-1$ 是镜像，不是旋转） | [@def-2.2.2] |
| 独立参数 | $9$ 量 $-6$ 约束 $=3$ | [@def-2.2.1] |
| 列的含义 | $R_j^i$ 的第 1、2、3 列分别为系 $j$ 的 $x_j,y_j,z_j$ 三轴在系 $i$ 中的坐标 | [@def-2.2.1] |

**三重身份**（同一矩阵、三种读法）：姿态**描述** / 坐标**变换** / 旋转**算子**——[@thm-2.2.B]。

### A2 基本旋转

$$R_x(\vartheta)=\begin{bmatrix}1&0&0\\0&c_\vartheta&-s_\vartheta\\0&s_\vartheta&c_\vartheta\end{bmatrix},\quad
R_y(\vartheta)=\begin{bmatrix}c_\vartheta&0&s_\vartheta\\0&1&0\\-s_\vartheta&0&c_\vartheta\end{bmatrix},\quad
R_z(\vartheta)=\begin{bmatrix}c_\vartheta&-s_\vartheta&0\\s_\vartheta&c_\vartheta&0\\0&0&1\end{bmatrix}$$

正方向：从转轴正端朝原点看为逆时针（右手定则）。主动转向量：$\boldsymbol v_{\rm after}=R\boldsymbol v_{\rm before}$；共原点坐标换算：$\boldsymbol p^i=R_j^i\boldsymbol p^j$，反向用转置。两系原点不同时，点坐标还须处理平移。

### A3 合成规则（一切序列的母规则）

| 情形 | 做法 | 出处 |
|:--|:--|:--|
| 绕**当前**轴（动系）依次转 $B_1,B_2,B_3$ | **右乘** $R=R_0B_1B_2B_3$ | [@thm-2.3.A] |
| 绕**固定**轴（定系）依次转 $S_1,S_2,S_3$ | **左乘** $R=S_3S_2S_1R_0$ | [@thm-2.3.B] |
| 一般不可交换 | 一般有 $R_1R_2\neq R_2R_1$；同轴、零角等情况可相等 | [@ex-book-2.3] |

> **口诀**：当前右、固定左，保留初始姿态 $R_0$。从 $I$ 出发，固定轴序列与轴角成对倒序的当前轴序列终态相同；ZYZ 与 RPY 的轴序列不同，不能把同一组三个角直接互换。

### A4 ZYZ 欧拉角（绕当前轴，右乘）

$$R(\boldsymbol\phi)=R_z(\varphi)R_{y'}(\vartheta)R_{z''}(\psi)=
\begin{bmatrix}
c_\varphi c_\vartheta c_\psi-s_\varphi s_\psi & -c_\varphi c_\vartheta s_\psi-s_\varphi c_\psi & c_\varphi s_\vartheta\\
s_\varphi c_\vartheta c_\psi+c_\varphi s_\psi & -s_\varphi c_\vartheta s_\psi+c_\varphi c_\psi & s_\varphi s_\vartheta\\
-s_\vartheta c_\psi & s_\vartheta s_\psi & c_\vartheta
\end{bmatrix}$$

**逆解**（$s_\vartheta\neq0$，原书式 2.19；两支等价）：

$$\varphi=\operatorname{Atan2}(r_{23},r_{13}),\quad
\vartheta=\operatorname{Atan2}\!\Big(\sqrt{r_{13}^2+r_{23}^2},\ r_{33}\Big),\quad
\psi=\operatorname{Atan2}(r_{32},-r_{31})$$

第二支可取 $(\varphi+\pi,-\vartheta,\psi+\pi)$，首末角按周期规范；$\vartheta$ 式的 $r_{33}$ 不变号。**奇点**：$\vartheta=0$ 只定 $\varphi+\psi$，$\vartheta=\pi$ 只定 $\varphi-\psi$，见 [@thm-2.4.B]。

### A5 RPY 角（绕固定轴，左乘）

从 $I$ 出发，实际发生顺序为固定 $x$ 轴转 $\psi$（滚转）→ 固定 $y$ 轴转 $\vartheta$（俯仰）→ 固定 $z$ 轴转 $\varphi$（偏航）。因子从左追加，得到下式；也可读为当前轴 $z(\varphi)\to y(\vartheta)\to x(\psi)$。

$$R(\boldsymbol\phi)=R_z(\varphi)R_y(\vartheta)R_x(\psi)=
\begin{bmatrix}
c_\varphi c_\vartheta & c_\varphi s_\vartheta s_\psi-s_\varphi c_\psi & c_\varphi s_\vartheta c_\psi+s_\varphi s_\psi\\
s_\varphi c_\vartheta & s_\varphi s_\vartheta s_\psi+c_\varphi c_\psi & s_\varphi s_\vartheta c_\psi-c_\varphi s_\psi\\
-s_\vartheta & c_\vartheta s_\psi & c_\vartheta c_\psi
\end{bmatrix}$$

**逆解**（$\vartheta\in(-\pi/2,\pi/2)$）：

$$\varphi=\operatorname{Atan2}(r_{21},r_{11}),\quad
\vartheta=\operatorname{Atan2}\!\Big(-r_{31},\sqrt{r_{11}^2+r_{21}^2}\Big),\quad
\psi=\operatorname{Atan2}(r_{32},r_{33})$$

第二支可取 $(\varphi+\pi,\pi-\vartheta,\psi+\pi)$，各角按周期规范。$\vartheta$ 的第二支为 $\operatorname{Atan2}(-r_{31},-\sqrt{r_{11}^2+r_{21}^2})$，其中 $-r_{31}$ 不变号。**奇点**：$\vartheta=+90°$ 只定 $\varphi-\psi$，$\vartheta=-90°$ 只定 $\varphi+\psi$。角名：roll 绕 $x$、pitch 绕 $y$、yaw 绕 $z$。

> **Atan2 的用途与边界**：$\operatorname{Atan2}(y,x)$ 用两个符号保留象限；输入半径 $\rho=\sqrt{x^2+y^2}$ 时，梯度模为 $1/\rho$。ZYZ 首末角的 $\rho=|\sin\vartheta|$，RPY 为 $|\cos\vartheta|$，趋零仍病态；原点无方向。$\arccos$ 可用于已选定的 $[0,\pi]$ 主支，但单个余弦不足以判完整象限，且近 $\pm1$ 敏感。见 [@thm-2.4.A]。

### A6 角和轴（4 参数，Rodrigues 公式）

$$R(\vartheta,\boldsymbol r)=\begin{bmatrix}
r_x^2(1-c_\vartheta)+c_\vartheta & r_xr_y(1-c_\vartheta)-r_zs_\vartheta & r_xr_z(1-c_\vartheta)+r_ys_\vartheta\\
r_xr_y(1-c_\vartheta)+r_zs_\vartheta & r_y^2(1-c_\vartheta)+c_\vartheta & r_yr_z(1-c_\vartheta)-r_xs_\vartheta\\
r_xr_z(1-c_\vartheta)-r_ys_\vartheta & r_yr_z(1-c_\vartheta)+r_xs_\vartheta & r_z^2(1-c_\vartheta)+c_\vartheta
\end{bmatrix}$$

| 要算什么 | 公式 | 出处 |
|:--|:--|:--|
| 合成路径 | $R_z(\alpha)R_y(\beta)R_z(\vartheta)R_y(-\beta)R_z(-\alpha)$（全左乘） | [@def-2.5.1] |
| 紧凑形式 | $R=c_\vartheta I+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$ | [@pf-2.5.rodrigues] |
| 由 $R$ 求角（取迹） | $\cos\vartheta=\dfrac{r_{11}+r_{22}+r_{33}-1}{2}$ | [@def-2.5.1] |
| 由 $R$ 求轴（取反对称部分） | $\boldsymbol r=\dfrac{1}{2\sin\vartheta}[r_{32}-r_{23},\ r_{13}-r_{31},\ r_{21}-r_{12}]^{\mathrm T}$，仅限 $0<\vartheta<\pi$；先查正交性与 det=1 | [@thm-2.5.B] |
| 指数映射 | $R=\exp(\vartheta S)=I+\sin\vartheta S+(1-\cos\vartheta)S^2$；$\phi=\vartheta\boldsymbol r$ 是三维指数坐标；$S^2=\boldsymbol r\boldsymbol r^{\mathrm T}-I$、$S^3=-S$，非零幂四周期 | [@thm-2.5.D] |
| 对数映射 | $\operatorname{Log}R=\dfrac{\vartheta}{2\sin\vartheta}(R-R^{\mathrm T})$，$0<\vartheta<\pi$；摘帽为 $\phi=\vartheta\boldsymbol r$；主支 $\operatorname{Log}I=0$，半圈取 $\pm\pi S(\boldsymbol r)$ | [@thm-2.5.E] |
| 不唯一 | $R(-\vartheta,-\boldsymbol r)=R(\vartheta,\boldsymbol r)$ | [@thm-2.5.A] |
| 逆解端点 | 主角 $[0,\pi]$；零角轴任意、主向量为零；半圈 $B=(R+I)/2$，取最大 $B_{kk}$，$r_k=\sqrt{B_{kk}}$、$r_i=B_{ik}/r_k$，整体正负等价 | [@thm-2.5.B] |

### A7 单位四元数（4 参数，提取须选稳定支路）

$$\eta=\cos\frac{\vartheta}{2},\qquad\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\,\boldsymbol r,\qquad\eta^2+|\boldsymbol\epsilon|^2=1$$

$$R(\eta,\boldsymbol\epsilon)=\begin{bmatrix}
2(\eta^2+\epsilon_x^2)-1 & 2(\epsilon_x\epsilon_y-\eta\epsilon_z) & 2(\epsilon_x\epsilon_z+\eta\epsilon_y)\\
2(\epsilon_x\epsilon_y+\eta\epsilon_z) & 2(\eta^2+\epsilon_y^2)-1 & 2(\epsilon_y\epsilon_z-\eta\epsilon_x)\\
2(\epsilon_x\epsilon_z-\eta\epsilon_y) & 2(\epsilon_y\epsilon_z+\eta\epsilon_x) & 2(\eta^2+\epsilon_z^2)-1
\end{bmatrix}$$

稳定提取：确认 $R\in SO(3)$ 后，按 [@method-2.6.extract] 用矩阵元素构造对称矩阵 $H=4qq^{\mathrm T}$。其对角依次为 $1+r_{11}+r_{22}+r_{33}$、$1+r_{11}-r_{22}-r_{33}$、$1-r_{11}+r_{22}-r_{33}$、$1-r_{11}-r_{22}+r_{33}$；非对角为 $H_{01}=r_{32}-r_{23}$、$H_{02}=r_{13}-r_{31}$、$H_{03}=r_{21}-r_{12}$、$H_{12}=r_{12}+r_{21}$、$H_{13}=r_{13}+r_{31}$、$H_{23}=r_{23}+r_{32}$。

$$k=\arg\max_j H_{jj},\qquad q_k=\tfrac12\sqrt{H_{kk}}\ge\tfrac12,\qquad q_i=\frac{H_{ik}}{4q_k}.$$

原书式 2.34–2.35 的逐分量符号法在 $\eta>0$ 时可用，精确半圈不能从反对称差定相对符号，见 [E2.7](ch02/errata.md#errata-2.7)。选最大分量为正仍可能跨支整体反号；连续跟踪另需相邻四维点积对齐。

逆 $Q^{-1}=\{\eta,-\boldsymbol\epsilon\}$；Hamilton 乘积 $Q_1\otimes Q_2=\{\eta_1\eta_2-\boldsymbol\epsilon_1^{\mathrm T}\boldsymbol\epsilon_2,\ \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\}$ 对应 $R_1R_2$，右侧 $Q_2$ 先作用。见 [@ex-2.6.C]。

### A8 齐次变换（$SE(3)$）

$$\tilde{\boldsymbol p}=\begin{bmatrix}\boldsymbol p\\1\end{bmatrix},\qquad
A_1^0=\begin{bmatrix}R_1^0&\boldsymbol o_1^0\\\boldsymbol 0^{\mathrm T}&1\end{bmatrix},\qquad
A_0^1=(A_1^0)^{-1}=\begin{bmatrix}R_1^{0\mathrm T}&-R_1^{0\mathrm T}\boldsymbol o_1^0\\\boldsymbol 0^{\mathrm T}&1\end{bmatrix}$$

点 $[p;1]$，方向 $[d;0]$；$A[x;w]=[Rx+wo;w]$，方向不能除以末分量 0。整体转置等于逆当且仅当 $o=0$。

连乘 $A_2^0=A_1^0A_2^1$，块为 $R_1^0R_2^1$、$o_1^0+R_1^0o_2^1$；右侧先作用，坐标系接口须相接。一般链为 $\tilde p^0=A_1^0\cdots A_n^{n-1}\tilde p^n$。见 [@thm-2.7.A]、[@ex-2.7.C]。

> **两条纪律**：$A^{-1}\neq A^{\mathrm T}$（正交性只在旋转块内成立）；方向向量（自由向量）的变换只用左上块 $R$，不吃平移。

---

## B · 正运动学与 DH 法

### B1 单关节变换 $A_i^{i-1}$（**值得默写**）

$$A_i^{i-1}(q_i)=\begin{bmatrix}
c_{\vartheta_i} & -s_{\vartheta_i}c_{\alpha_i} & s_{\vartheta_i}s_{\alpha_i} & a_ic_{\vartheta_i}\\
s_{\vartheta_i} & c_{\vartheta_i}c_{\alpha_i} & -c_{\vartheta_i}s_{\alpha_i} & a_is_{\vartheta_i}\\
0 & s_{\alpha_i} & c_{\alpha_i} & d_i\\
0&0&0&1
\end{bmatrix}$$

两步分解：先「沿 $z_{i-1}$ 平移 $d_i$ + 绕 $z_{i-1}$ 转 $\vartheta_i$」，再「沿 $x_i$ 平移 $a_i$ + 绕 $x_i$ 转 $\alpha_i$」，右乘合成（[@method-2.8.A]）。

第 4 列前三项 $(a_ic_{\vartheta_i},\ a_is_{\vartheta_i},\ d_i)$ 是新系原点在旧系中的位置；旋转块为 $R_z(\vartheta_i)R_x(\alpha_i)$。

### B2 DH 建系与四参数

**记忆主线 · 看守模型（[@method-2.8.watch]）**：系 $i-1$ 看守关节 $i$——$z_{i-1}$ 就是关节 $i$ 的轴线；杆 $i$ 固连系 $i$（i<n 时原点在关节 i+1 轴上，末杆系另选）。建系四步实例见 [@method-2.8.anthro]。

| 规则 | 服务的参数 | 为什么 |
|:--|:--|:--|
| $z_{i-1}$ 沿**关节 $i$** 的轴线 | $\vartheta_i$ 或 $d_i$ 为变量 | 关节运动在 $A$ 里表现为绕 $z_{i-1}$ 转或沿 $z_{i-1}$ 移 |
| 原点 $o_i$ 取在公垂线交点、$x_i$ 沿公垂线 | $a_i$（常数） | 公垂线给两轴的间距；垂足相对旧原点的位置还须用 $d_i$ 描述 |
| 同一对 $z$ 轴的方向关系 | $\alpha_i$（常数） | 方向差只剩绕 $x_i$ 的一个转角 |
| $y_i$ 右手系补齐 | — | 只保证 $R\in SO(3)$ |

**特殊情形**：平行 R 可选 $d_i=0$，P 则在参考行程选固连原点，运动后 $d_i$ 仍变；相交但不平行时 $x_i$ 须垂直两轴；反向平行轴可取扭角 $\pi$。合法简化固定项，不能改几何或消掉活动量。

**3 常 1 变**：$a_i,\alpha_i$ 恒为常数；$d_i,\vartheta_i$ 中恰有一个是关节变量 $q_i$（转动关节 $q_i=\vartheta_i$、移动关节 $q_i=d_i$）——[@def-2.8.3]。

### B3 十步流程（[@method-2.8.steps]）

1. 关节轴编号，定 $z_0,\dots,z_{n-1}$；2. 选系 0；3. 对 $i=1..n-1$ 定 $o_i$；
4. 沿公垂线取 $x_i$；5. 右手系补 $y_i$；6. 选系 $n$；7. 列 $4n$ 参数表；
8. 逐个算 $A_i^{i-1}$；9. 连乘得 $T_n^0(q)$；10. 串常值变换 $T_0^b,T_e^n$ 得 $T_e^b$。

> 先标正轴与零位，再建系、列参数、连乘，并用独立几何核对。

### B4 两个空间、工作空间与冗余

$$\boldsymbol x_e=k(\boldsymbol q),\qquad T_e^b(\boldsymbol q)=T_0^b\,T_n^0(\boldsymbol q)\,T_e^n,\qquad
T_n^0=A_1^0A_2^1\cdots A_n^{n-1}$$

| 概念 | 内容 | 出处 |
|:--|:--|:--|
| 可达 ⊇ 灵活 | 可达位置是整个允许关节域的像；灵活须能实现规定方向集合中的每一种方向 | [@def-2.10.2] |
| 精度 ≠ 重复精度 | 定位精度看目标偏差；重复精度看同条件回访散布，须统一测试口径 | [@note-2.10.acc] |
| 冗余与瞬时核 | $n$ 独立关节数、$m$ 结构适配的完整位姿维数、$r$ 任务独立约束数；正常点行满秩时局部自由度 $n-r$，一般核维数 $n-\operatorname{rank}J_{\rm task}$ | [@def-2.10.3] |

### B5 运动学标定

$$\Delta\boldsymbol x=\Phi\,\Delta\boldsymbol\xi,\qquad
\Delta\boldsymbol\xi=(\Phi^{*\mathrm T}\Phi^*)^{-1}\Phi^{*\mathrm T}\Delta\boldsymbol x^*,\qquad
\boldsymbol\xi'=\boldsymbol\xi+\Delta\boldsymbol\xi$$

$\Phi$ 为 $m\times p$ 标定矩阵，$\Delta\boldsymbol\xi$ 为实际可辨识参数子集的偏差，且 $p\le4n$；$4n$ 只是把四列 DH 表项全部列出的上限写法。量测条件是 $tm\ge p$（**宜远大于**，还须列满秩、条件数可接受）；因 $k$ 非线性，须**迭代**。见 [@method-2.11.steps]。

---

## C · 逆运动学

**四难点**（[@thm-2.12.A]）：非线性（解方程而非算函数）、多解、可能无解 / 无穷多解、无通用解析法。

**闭合解门槛**（[@thm-2.12.B]）：球形腕（三轴交一点）或三轴平行 ⇒ 可解耦。

**解耦五步**（[@method-2.12.decouple]）——这是全书最实用的一套流程：

1. 由末端位姿反推**腕心**：
$$\boldsymbol p_w=\boldsymbol p_e-d_6\,\boldsymbol a_e$$
（$d_6$ = 腕心到末端原点的「外移长度」，沿接近向量 $\boldsymbol a_e$ 反推。）
2. 解**臂**：由 $\boldsymbol p_w$ 求 $(q_1,q_2,q_3)$（$\boldsymbol p_w$ 只依赖前三个关节）；
3. 算 $R_3^0=R_1^0R_2^1R_3^2$；
4. 解**腕**：由 $(R_3^0)^{\mathrm T}R_e=R_6^3$ 反解 $(q_4,q_5,q_6)$；
5. 整理全部解支。

**本表腕 = ZYZ 反解**：§2.9.5 的扭角与零位给出 $R_6^3=R_z(\vartheta_4)R_y(\vartheta_5)R_z(\vartheta_6)$，可用 A4 并保留奇异分支；其他选系先换算，不能只凭三轴共点直接套关节读数。

> **数解支的口诀**：位置解给「臂」的支数（平面臂 2 支 = 肘上 / 肘下，拟人臂 4 支），方向解给「腕」的支数（球腕 2 支 = 翻转），总数 = 臂 × 腕。

---

## D · 微分运动学（第 3 章）

### D1 微分运动学方程与旋转矩阵求导

$$\begin{bmatrix}\dot{\boldsymbol p}_e\\\boldsymbol\omega_e\end{bmatrix}=J(\boldsymbol q)\,\dot{\boldsymbol q},\qquad
J=\begin{bmatrix}J_P\\J_O\end{bmatrix}\in\mathbb R^{6\times n}$$

$$\dot R=S(\boldsymbol\omega)R,\qquad
S(\boldsymbol\omega)=\begin{bmatrix}0&-\omega_z&\omega_y\\\omega_z&0&-\omega_x\\-\omega_y&\omega_x&0\end{bmatrix},\qquad
S(\boldsymbol\omega)\boldsymbol p\equiv\boldsymbol\omega\times\boldsymbol p$$

推导链：$RR^{\mathrm T}=I$ 求导 ⇒ $\dot RR^{\mathrm T}$ 反对称 ⇒ 认出 $S(\boldsymbol\omega)$（[@thm-3.1.A]）。共轭关系见 [@thm-3.1.B]。$\boldsymbol\omega=(\dot RR^{\mathrm T})^\vee\in\mathbb R^3$ 是基系角速度，$R^{\mathrm T}\dot R$ 给刚体系分量；$S(\boldsymbol\omega)\in so(3)$，不能混淆向量与矩阵。

### D2 逐列构造（绿框，**必考**）

$$J=\begin{bmatrix}J_1&\cdots&J_n\end{bmatrix},\qquad
J_i=\begin{bmatrix}J_{P_i}\\J_{O_i}\end{bmatrix},\qquad
\begin{cases}\text{关节 }i\text{ 转动：}& J_{P_i}=z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1}),\quad J_{O_i}=z_{i-1}\\[1mm]\text{关节 }i\text{ 移动：}& J_{P_i}=z_{i-1},\quad J_{O_i}=\boldsymbol 0\end{cases}$$

见 [@thm-3.1.C]。**所需量全部从正运动学读取**：

| 量 | 从哪读 |
|:--|:--|
| $z_{i-1}$ | $T_{i-1}^0$ 左上 $3\times3$ 块的**第三列**（基系表示，不能预设为 $[0,0,1]^{\mathrm T}$；平面平行轴可恰好相等） |
| $\boldsymbol p_{i-1}$ | $T_{i-1}^0$ 第四列前三行 |
| $\boldsymbol p_e$ | $T_e^0=T_n^0T_e^n$ 第四列前三行；末端点与第 $n$ 系原点重合时才可直接取 $T_n^0$ |

**物理含义**：其余关节全部锁死时，单个关节的单位速度对末端速度的贡献。

### D3 换到别的坐标系

若 $R^u$ 表示把基坐标系中的分量转换为 $u$ 坐标系中的分量（$v^u=R^u v^0$），则

$$J^u=\begin{bmatrix}R^u&0\\0&R^u\end{bmatrix}J$$

此式只改变同一末端点速度向量的表达基；移动取速度的点或求相对于运动参考系的速度，还需要额外项。

### D4 奇点

先固定任务，令 $r_{\max}$ 为该机构在此任务下的最大可达秩：

$$\operatorname{rank}J(q)<r_{\max}.$$

通常可逆的方阵才等价于 $\det J=0$。下表取正杆长，角度条件按模 $2\pi$ 理解。

| 结构 | 判据 | 出处 |
|:--|:--|:--|
| 两连杆平面臂 | $\det J=a_1a_2s_2=0\iff\vartheta_2=0,\pi$ | [@def-3.3.1] |
| 六轴、末三转轴交于一点（腕心参考） | $\det J=\det J_{11}\cdot\det J_{22}$（$J_{11}$ 为腕心位置块、$J_{22}$ 为腕角速度块） | [@thm-3.3.A] |
| 腕奇点 | $\det J_{22}\propto s_5$ ⇒ $\vartheta_5=0,\pi$ | [@thm-3.3.A] |
| 拟人臂肘 / 肩 | $\det J_{11}=-a_2a_3s_3(a_2c_2+a_3c_{23})$ ⇒ $s_3=0$（肘）或 $a_2c_2+a_3c_{23}=0$（肩腕点落轴） | [@thm-3.3.A] |

### D5 冗余与零空间

$$n>r\ \Longrightarrow\ \mathcal N(J)\neq\{0\},\qquad
P=NN^{\mathrm T}\ (\text{秩 }n-\operatorname{rank}J;\ \text{行满秩时 }n-r),\qquad
\dot{\boldsymbol q}=\dot{\boldsymbol q}^*+P\dot{\boldsymbol q}_0$$

这里 $N$ 的列须标准正交；普通基 $B$ 应用 $P=B(B^{\mathrm T}B)^{-1}B^{\mathrm T}$。$P\dot{\boldsymbol q}_0$ 不增加所选任务的瞬时速度（$JP\dot{\boldsymbol q}_0=0$）——用来做内部运动 / 再配置（避障、躲关节极限、远离奇异）。见 [@def-3.4.1]、[@thm-3.4.B]。

### D6 逆微分运动学：三味药

| $J$ 的形状 | 工具 | 公式 | 条件 |
|:--|:--|:--|:--|
| 方阵满秩 | $J^{-1}$ | $\dot{\boldsymbol q}=J^{-1}\boldsymbol v_e$，配数值积分 $\boldsymbol q_{k+1}=\boldsymbol q_k+J^{-1}\boldsymbol v_e\Delta t$ | $n=r$、无奇异 |
| 长方（冗余） | $J^\dagger$ | $\dot{\boldsymbol q}=J^\dagger\boldsymbol v_e+(I-J^\dagger J)\dot{\boldsymbol q}_0$，$J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$ | $r<n$、行满秩 |
| 速度与残差权衡（含奇异邻域） | $J^*$ | $J^{*}=W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T}+K^{-1})^{-1}$；$W=I,K=k^{-2}I,k>0$ 时 $J^{*}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I)^{-1}$ | $W,K\succ0$；容许任务速度残差 $\delta$ |

见 [@def-3.5.1]、[@def-3.5.2]。

> **范围**：右伪逆闭式要求行满秩；一般Moore–Penrose伪逆任意秩下存在。DLS用于权衡速度与残差，不限于降秩时使用。
> **参数别混**：取 $K=k^{-2}I$、$k>0$。奇点邻域可增大阻尼 $k$（减小误差权重 $K$），以任务误差限制关节速度；$J$ 行满秩时 $k\to0^+$ 才趋于右伪逆。

**$\dot{\boldsymbol q}_0$ 的三种取法**（都取 $k_0(\partial g/\partial\boldsymbol q)^{\mathrm T}$，最大化 $g$）：

| 目标 $g$ | 作用 |
|:--|:--|
| $w=\sqrt{\det(JJ^{\mathrm T})}$（可操作度） | 增大速度椭球体积，不等于增大到奇点的距离 |
| $-\frac1{2n}\sum_i((q_i-\bar q_i)/\Delta_i)^2$ | 尝试靠近关节中点，不能保证不越限 |
| 臂上点到障碍表面的**最小**距离 | 尝试增大间距，最近点切换处可能不可微 |

这里 $\bar q_i$ 为关节中点，$\Delta_i=q_{iM}-q_{im}>0$ 为行程。投影梯度只描述局部次目标的贡献，还需计入主任务运动。

### D7 分析雅可比

$$\boldsymbol\omega_e=T(\boldsymbol\varphi_e)\dot{\boldsymbol\varphi}_e,\qquad
T(\boldsymbol\varphi)=\begin{bmatrix}0&-s_\varphi&s_\vartheta c_\varphi\\0&c_\varphi&s_\vartheta s_\varphi\\1&0&c_\vartheta\end{bmatrix}\ (\text{ZYZ}),\qquad
J_A=T_A^{-1}J,\qquad
T_A=\begin{bmatrix}I_3&0\\0&T\end{bmatrix}$$

$T$ 三列是基系表示的ZYZ瞬时转轴；系数一般不等于逐轴点积。$\det T=-\sin\vartheta$，上面的逆换算仅适用于 $\sin\vartheta\ne0$ 的光滑分支。同一参考点和表达系中，两种雅可比前三行相同，且此时秩相等；表示奇点不能直接判定机构奇异。见 [@def-3.6.1]、[@thm-3.6.A]。

---

## E · 静力学

$$\boxed{\ \boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\,F_e\ },\qquad
F_e=\begin{bmatrix}\boldsymbol f_e\\\boldsymbol\mu_e\end{bmatrix}\in\mathbb R^6$$

由虚功原理推出：$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau=\boldsymbol v_e^{\mathrm T}F_e=(J\dot{\boldsymbol q})^{\mathrm T}F_e=\dot{\boldsymbol q}^{\mathrm T}J^{\mathrm T}F_e$。**速度变换的转置就是力变换**（对偶），长方阵也成立，无需满秩。见 [@def-3.8.1]。

**两坐标系间的速度 / 力变换**：

令 A 为系 0 原点、B 为系 1 原点，$r=p_B^0-p_A^0$、$R=R_1^0$。速度从 A（系 0 分量）传到 B（系 1 分量），广义力反向折回：

$$v_B^1=Mv_A^0,\quad
M=\begin{bmatrix}R^{\mathrm T}&-R^{\mathrm T}S(r)\\0&R^{\mathrm T}\end{bmatrix},\qquad
F_A^0=M^{\mathrm T}F_B^1=\begin{bmatrix}R&0\\S(r)R&R\end{bmatrix}F_B^1.$$

功率不变 $F_B^{1\mathrm T}Mv_A^0=F_A^{0\mathrm T}v_A^0$ 给出反向转置；若两种量都从 A 换到 B，则 $F_B^1=M^{-\mathrm T}F_A^0$。同一点只换基时，速度与力都用 $\operatorname{diag}(R,R)$；不要把它们误称为同方向互为转置。

---

## F · 轨迹规划（第 4 章）

### F1 点对点：三次与五次

**三次（4 个系数 ↔ 4 个约束）**：$q(t)=a_3t^3+a_2t^2+a_1t+a_0$，由 $q(0)=q_i,\ \dot q(0)=\dot q_i,\ q(t_f)=q_f,\ \dot q(t_f)=\dot q_f$ 定系数。

**规范化形式**（初终速度为零时与数据无关，$q_i=0,q_f=\pi,t_f=1$ 时 $a_2=3\pi,a_3=-2\pi$）：

$$q(t)=q_i+(q_f-q_i)\Big[3\eta^2-2\eta^3\Big],\qquad \eta=\frac{t}{t_f}$$

**五次（6 个系数 ↔ 位置/速度/加速度 × 两端）**：

$$q(t)=q_i+(q_f-q_i)\Big[10\eta^3-15\eta^4+6\eta^5\Big]$$

**关键点**：固定初终位置与速度、常惯量模型下，平方力矩最优解为三次；固定加速度后可另研究平方 jerk 指标，其最优解为五次（[@thm-4.2.A]、[@def-4.2.2]）。

### F2 梯形速度曲线（LSPB，工业重点）

速度梯形：起段常加速度 $\ddot q_c$、中段巡航 $\dot q_c$、末段常减速度；位置 = 直线段 + 两端抛物线。

$$t_m=\frac{t_f}{2},\quad q_m=\frac{q_f+q_i}{2},\qquad
\ddot q_ct_c=\frac{q_m-q_c}{t_m-t_c},\quad q_c=q_i+\tfrac12\ddot q_ct_c^2$$

$$\Longrightarrow\quad \ddot q_ct_c^2-\ddot q_ct_ft_c+(q_f-q_i)=0$$

$$t_c=\frac{t_f}{2}-\frac12\sqrt{\frac{t_f^2\ddot q_c-4(q_f-q_i)}{\ddot q_c}},
\qquad |\ddot q_c|\ge\frac{4|q_f-q_i|}{t_f^2}$$

**指定巡航速度**（替代指定加速度）：

$$\frac{|q_f-q_i|}{t_f}<|\dot q_c|\le\frac{2|q_f-q_i|}{t_f},\qquad
t_c=\frac{q_i-q_f+\dot q_ct_f}{\dot q_c},\qquad
\ddot q_c=\frac{\dot q_c^2}{q_i-q_f+\dot q_ct_f}$$

**分段位置**（(4.8)）：

$$q(t)=\begin{cases}q_i+\tfrac12\ddot q_ct^2 & 0\le t\le t_c\\ q_i+\ddot q_ct_c(t-t_c/2) & t_c<t\le t_f-t_c\\ q_f-\tfrac12\ddot q_c(t_f-t)^2 & t_f-t_c<t\le t_f\end{cases}$$

**极限**：下界取等 ⇒ **三角形**速度曲线（无巡航段）；代价：平方力矩指标在族内最优 $t_c/T=1/3$ 时比三次高 **12.5%**（[@def-4.2.3]、[@thm-4.2.C]）。

### F3 系列点：四条路线

**① 指定路径点速度**：$\Pi_k(t_k)=q_k,\ \Pi_k(t_{k+1})=q_{k+1},\ \dot\Pi_k(t_k)=\dot q_k,\ \dot\Pi_k(t_{k+1})=\dot q_{k+1}$（每段独立四方程）。

**② 按规则计算速度**（(4.12)，$v_k=\dfrac{q_k-q_{k-1}}{t_k-t_{k-1}}$）：

$$\dot q_1=0,\qquad \dot q_k=\begin{cases}0 & \operatorname{sgn}v_k\ne\operatorname{sgn}v_{k+1}\\ \frac{v_k+v_{k+1}}{2} & \operatorname{sgn}v_k=\operatorname{sgn}v_{k+1}\end{cases},\qquad \dot q_N=0$$

**③ 三次样条（加速度连续）**——方程计数与降维：

$$\underbrace{4(N-2)+6}_{4N-2\ \text{个方程}}\ \text{vs}\ \underbrace{4(N-1)}_{\text{未知数}}\ \Rightarrow\ \text{差 }2\ \Rightarrow\ \text{两个虚拟点}\ \Rightarrow\ 4(N+1)=4(N+1)$$

$$\ddot\Pi_k(t)=\frac{\ddot\Pi_k(t_k)}{\Delta t_k}(t_{k+1}-t)+\frac{\ddot\Pi_k(t_{k+1})}{\Delta t_k}(t-t_k)\quad\Longrightarrow\quad A\,\boldsymbol\Pi=b$$

$A$ 为**三对角**、**非奇异**，且只依赖 $\Delta t_k$——**对所有关节相同**（[@thm-4.2.H]）。

**④ 抛物线 + 线性混合（经由点）**：

$$q_{k-1,k}=\frac{q_k-q_{k-1}}{\Delta t_k},\qquad
\ddot q_k=\frac{q_{k,k+1}-q_{k-1,k}}{\Delta t'_k},\qquad
b_{k0}=q_k+\frac{(\dot q_{k,k+1}-\dot q_{k-1,k})\Delta t'_k}{8}$$

轨迹**不经过**路径点（削角量 = 上式第二项），故称**经由点**（[@def-4.2.7]）。

### F4 操作空间：路径基元与位置

**参数化与 Frenet 标架**：

$$p=f(s),\qquad t=\frac{\mathrm dp}{\mathrm ds},\qquad
n=\frac{\mathrm d^2p/\mathrm ds^2}{\|\mathrm d^2p/\mathrm ds^2\|},\qquad b=t\times n$$

**直线**（$p_l\to p_f$）：$p(s)=p_l+\dfrac{s}{\|p_f-p_l\|}(p_f-p_l)$，$\dfrac{\mathrm d^2p}{\mathrm ds^2}=\mathbf 0$（法向无法定义）。

**圆弧**（轴 $r$、轴上点 $d$、圆上点 $p_l$，$\delta=p_l-d$，退化条件 $|\delta^{\mathrm T}r|<\| \delta\|$）：

$$c=d+(\delta^{\mathrm T}r)r,\qquad
p(s)=c+R\,p'(s),\qquad
p'(s)=\big[\rho\cos(s/\rho),\ \rho\sin(s/\rho),\ 0\big]^{\mathrm T}$$

**位置轨迹 = 几何 × 时间**：

$$\dot p_e=\dot s\,t,\qquad
\ddot p_e=\underbrace{\frac{\dot s^2}{\rho}n}_{\text{向心：改方向}}+\underbrace{\ddot s\,t}_{\text{切向：改大小}}$$

**多段路径与时间超前**：$p_e=p_0+\sum_j\frac{s_j}{\|p_j-p_{j-1}\|}(p_j-p_{j-1})$；$\Delta t_j=\Delta t_{j-1}+\delta t_j$（[@thm-4.3.D]）。

### F5 操作空间：指向

**旋转矩阵不能逐元素插值**（破坏正交性）⇒ 两条正路：

**欧拉角**：$\varphi_e=\varphi_i+\dfrac{s}{\|\varphi_f-\varphi_i\|}(\varphi_f-\varphi_i)$，再经 $\omega_e=T(\varphi_e)\dot\varphi_e$ 换回基系。

**角和轴**（$R_i^f=R_i^{\mathrm T}R_f$）：

$$\theta_f=\arccos\!\Big(\frac{r_{11}+r_{22}+r_{33}-1}{2}\Big),\qquad
r'=\frac{1}{2\sin\theta_f}\begin{bmatrix}r_{32}-r_{23}\\ r_{13}-r_{31}\\ r_{21}-r_{12}\end{bmatrix},\qquad
\omega'=\dot\theta\,r'$$

角轴逆解中的轴公式只适用于 $0<\theta_f<\pi$；零角和半圈按 [@thm-2.5.B] 处理。相对插值 $R_i\exp(s\operatorname{Log}(R_i^{\mathrm T}R_f))$ 的轴分量在初始工具系中，半圈需选路径。

**两次降维**：位置落在 $s(t)$、姿态落在 $\theta(t)$，固定路径后可复用一维标量规划。

---

## G · 执行器与传感器（第 5 章）

### G1 执行系统功率链与功率符号

**能源 → 功率放大器 → 伺服发动机 → 传动装置 → 关节**（[@def-5.1.1]）。功率恒为「力 × 速度」，由此可辨功率种类（[@note-5.1.1]）。

$$P_c\ \text{（控制信号）}\Rightarrow P_a\ \text{（供给发动机）}\Rightarrow P_m\ \text{（发动机输出）}\Rightarrow P_u\ \text{（关节所需）}$$

三处损失：$P_{da}$ 放大器、$P_{dm}$ 发动机、$P_{dt}$ 传动装置（[@def-5.1.2]）。

### G2 工况矛盾与传动装置三重作用

关节要**低速度、高转矩**；伺服发动机最优工况是**高速度、低转矩**（[@thm-5.1.B]）⇒ 必须加传动装置。三重作用：**定量（降速增矩）/ 定性（转动→平动）/ 减重优化有效载荷**（[@def-5.1.3]）。无间隙刚性传动 ⇒ **输入输出纯比例**（[@thm-5.1.F]）。

### G3 电气驱动的四个基本方程

$$V_a=(R_a+sL_a)I_a+V_g,\qquad V_g=k_v\Omega_m$$

$$C_m=(sI_m+F_m)\Omega_m+C_l,\qquad C_m=k_tI_a$$

**$k_t=k_v$**（标准国际单位下数值相等）（[@def-5.2.1]）。放大器 $\dfrac{V_a}{V_c}=\dfrac{G_v}{1+sT_v}$，$T_v$ 在 $10^{-5}$–$10^{-4}$ s 量级。

### G4 两种发电机与统一传递函数

$$M(s)=\frac{k_m}{s(1+sT_m)}$$

| | $k_m$ | $T_m$ | 干扰增益 |
|:--|:--|:--|:--|
| **速度控制**（$k_i=0$） | $1/k_v$ | $R_aI_m/(k_vk_t)$ | $R_a/(k_vk_t)$ |
| **力矩控制**（$Kk_i\gg R_a$） | $k_t/(k_iF_m)$ | $I_m/F_m$ | $1/F_m$ |

速度控制抗干扰更好 ⇒ **独立关节控制不加电流反馈**；保护改用**死区非线性**的电流反馈（[@thm-5.2.A]、[@thm-5.2.B]）。

### G5 液压驱动的六条方程

$$Q=Q_m+Q_l+Q_c,\qquad Q_l=k_lp,\qquad Q_c=\gamma Vsp,\qquad Q_m=k_q\Omega_m,\qquad C_m=(sI_m+F_m)\Omega_m+C_l,\qquad C_m=k_pp$$

伺服阀 $\dfrac{x}{V_c}=\dfrac{G_c}{1+sT_c}$（毫秒级）；分布器线性化 $p=k_xx-k_qQ$（[@def-5.2.3]）。**旋转式** $k_c=\gamma V$ 为常数，**直线式**随工作点变。

### G6 减速比的两个折算因子（**必背**）

$$k_r=\frac{\omega_m}{\omega}=\frac{r}{r_m}\ (\text{典型 }几十\sim几百)$$

$$C_m=I_{eq}\dot\omega_m+F_{eq}\omega_m+\frac{C_l}{k_r},\qquad
I_{eq}=I_m+\frac{I}{k_r^2},\qquad F_{eq}=F_m+\frac{F}{k_r^2}$$

**惯量与摩擦按 $1/k_r^2$、负载力矩与非线性按 $1/k_r$**（[@thm-5.2.C]）。摆的例子：$C_m=I_{eq}\dot\omega_m+F_{eq}\omega_m+\dfrac{mgl}{k_r}\sin\dfrac{\vartheta_m}{k_r}$——$k_r$ 缩小电机端幅值；固定电机行程时便于局部线性化，固定关节行程时不能据此消除非线性（[@ex-5.2.D]）。

### G7 位置与速度反馈控制

原驱动 $M(s)=k_m/[s(1+sT_m)]$ 只有一个原点极点，另一个为 $-1/T_m$。对 $I_{eq}\ddot\theta+b\dot\theta=ku-d$，比例控制给稳态偏差 $e_{ss}=d/(kK_P)$；积分可保存抵消恒定负载所需的输入，但必须检查闭环稳定性。PI 对应三阶特征式 $I_{eq}s^3+bs^2+kK_Ps+kK_I$，正参数下还须 $bK_P>I_{eq}K_I$。速度反馈增加阻尼，不自动消除恒定负载误差。见 [@thm-5.2.D]。

### G8 编码器分辨率

$n$ 轨绝对式：每圈 $2^n$ 个角位置，电机侧 $2\pi/2^n$；经减速比 $k_r$ 后关节侧分辨率提高 $k_r$ 倍（[@ex-5.3.A]）。12 轨 ⇒ $360^{\circ}/4096\approx0.0879^{\circ}$。**格雷码**：相邻码位只变一位，避免过渡错误的累积（[@thm-5.3.B]）。

### G9 力/力矩的坐标变换（作业 5.6 用）

$$\begin{bmatrix}f^c_c\\ \mu^c_c\end{bmatrix}=
\begin{bmatrix}R^c_s & O\\ S(r^c_{cs})R^c_s & R^c_s\end{bmatrix}
\begin{bmatrix}f_s\\ \mu_s\end{bmatrix},\qquad
S(r)=\begin{bmatrix}0&-r_z&r_y\\ r_z&0&-r_x\\ -r_y&r_x&0\end{bmatrix}$$

六维腕力传感器的 8 个张力经**校准矩阵**重构成 6 个分量（[@def-5.4.3]、[@thm-5.4.A]）。

### G10 声纳测距与音速修正（作业 5.7 用相机模型）

$$d=\frac{vt}{2},\qquad v\approx331.4+0.6T\ (\mathrm{m/s},\ T\ \text{为摄氏温度})$$

**相机投影**：$\begin{bmatrix}x_I&y_I&\lambda\end{bmatrix}^{\mathrm T}=\Omega\tilde p_c$，$\Omega=\begin{bmatrix}fa_x&0&X_0\\0&fa_Y&Y_0\\0&0&1\end{bmatrix}$；像素 $X_I=x_I/\lambda,\ Y_I=y_I/\lambda$。整体合成**相机校准矩阵** $\Xi=\Omega\Pi T_b^c$（[@def-5.4.5]、[@thm-5.4.B]）。

## H · 动力学（第 6 章，对应原书第 7 章）

### H1 拉格朗日公式与广义力（**值得默写**）

$$L=T-U,\qquad \frac{\mathrm d}{\mathrm dt}\Bigl(\frac{\partial L}{\partial\dot q_i}\Bigr)-\frac{\partial L}{\partial q_i}=\xi_i$$

**广义力四件套**：$\xi_i=\tau_i-(F_{\mathrm v}\dot q)_i-(F_{\mathrm s}\operatorname{sgn}\dot q)_i-(J^{\mathrm T}\boldsymbol h_e)_i$。**约束力不做虚功** ⇒ 不画受力图；非保守力自己补（[@def-6.1.1]）。三步流程：**选坐标 → 写 $T,U$ → 代方程**。

### H2 动能与惯性矩阵

$$T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q},\qquad
B=\sum_{i=1}^{n}\Bigl[m_iJ_P^{(i)\mathrm T}J_P^{(i)}+J_O^{(i)\mathrm T}\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}J_O^{(i)}
+m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)}+J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\Bigr]$$

**$B$ 三性质**：对称、正定（$\dot q^{\mathrm T}B\dot q=2T>0$）、一般随位形变。**连杆动能三块**：平动 + 交叉项（质心定义 ⇒ 为零）+ 转动；惯性张量 $\boldsymbol I_i=\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}$（连杆系里是常数）、平行轴 $\boldsymbol I_O=\boldsymbol I_C+mS^{\mathrm T}(\boldsymbol p_C)S(\boldsymbol p_C)$（[6.1.1](ch06/sec6-1-1.md)）。

### H3 势能与重力项（**两种力矩别混名**）

$$U=-\sum_i\bigl(m_i\boldsymbol g_0^{\mathrm T}\boldsymbol p_i+m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i}\bigr),\qquad
\boldsymbol g(\boldsymbol q)=\frac{\partial U}{\partial\boldsymbol q}=-\boldsymbol\tau_{\mathrm{grav}}$$

$U=U(\boldsymbol q)$（与 $\dot q$ 无关）；$\boldsymbol g$ 是方程**左端**重力项，实际重力广义力是它的相反数；静止保持 $\tau=\boldsymbol g$（[6.1.2](ch06/sec6-1-2.md)、[@ex-6.1.2.A]）。

### H4 运动方程与 $h_{ijk}$

$$h_{ijk}=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i},\qquad
B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}+\boldsymbol g=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e$$

$h_{ijj}\dot q_j^2$ 离心、$h_{ijk}\dot q_j\dot q_k\ (j\neq k)$ 科氏、$b_{ii}$ = 锁住其他关节时关节 $i$ 的等效惯量（含下游全部 + $k_{r_i}^2I_{m_i}$）（[6.1.3](ch06/sec6-1-3.md)）。

### H5 Christoffel 符号与反对称性（两条公式两个条件）

$$c_{ijk}=\frac12\Bigl(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}-\frac{\partial b_{jk}}{\partial q_i}\Bigr),\qquad c_{ij}=\sum_kc_{ijk}\dot q_k$$

- **(7.48)**：Christoffel 选法下 $N=\dot B-2C$ **反对称** ⇒ $\forall\boldsymbol w,\ \boldsymbol w^{\mathrm T}N\boldsymbol w=0$；
- **(7.49)**：**任意**选法下 $\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$（能量守恒）。

方向：(7.48)⇒(7.49)，反向不成立（$N$ 依赖 $\dot q$）（[@thm-6.2.1]、[6.2.1](ch06/sec6-2-1.md)）。

### H6 线性性与回归矩阵

$$\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\,\boldsymbol\pi,\qquad
\pi_i=\bigl[m_i,\ m_i\ell_{C_ix},\ m_i\ell_{C_iy},\ m_i\ell_{C_iz},\ \bar I_{i,xx},\ \bar I_{i,xy},\ \bar I_{i,xz},\ \bar I_{i,yy},\ \bar I_{i,yz},\ \bar I_{i,zz},\ I_{m_i}\bigr]^{\mathrm T}$$

**三个数**：11（刚体/连杆）→ 13（含摩擦/关节）→ 最小参数集 $\le13n$（平面臂 25→8→5）。用途：线性最小二乘辨识、自适应控制、$Y$ 零列筛参数（[6.2.2](ch06/sec6-2-2.md)）。

### H7 两个算例速查（单摆与平面臂）

| 模型 | 方程 |
|:--|:--|
| 带齿轮的摆 | $(I+I_mk_r^2)\ddot\vartheta+(F+F_mk_r^2)\dot\vartheta+mgl\sin\vartheta=\tau$——**自动折算**，与第 5 章 (5.29) 一致 |
| 单摆质点 | $0.5\ddot q+4.905=\tau$（$m=2,l=0.5$）；保持 $4.905$ / 释放 $-9.81$ / 加速 $+2$ 需 $5.905$ |
| 平面臂 | $h=-m_2a_1\ell_2s_2$；$C=\begin{bmatrix}h\dot\vartheta_2&h(\dot\vartheta_1+\dot\vartheta_2)\\-h\dot\vartheta_1&0\end{bmatrix}$，$C\dot q=\begin{bmatrix}h(2\dot\vartheta_1\dot\vartheta_2+\dot\vartheta_2^2)\\-h\dot\vartheta_1^2\end{bmatrix}$；$b_{12}$ 含 $k_{r_2}I_{m_2}$（转子 2 总角速度 $\dot\vartheta_1+k_{r_2}\dot\vartheta_2$）、$b_{22}$ 常数 |
| 笛卡儿臂 | $B$ 常数对角、$C=O$、$g_1=(m_1+m_{m_2}+m_2)g$、$g_2=0$——解耦 = 笛卡儿结构 + 轴正交 |

## I · 运动控制（第7章）

统一取 $e=q_d-q$。使用公式前确认实际驱动输入、参考是否固定，以及增益输出的是力矩还是加速度。

### I1 单轴转矩反馈

$$J\ddot q_m+b\dot q_m+d=\tau_m,\qquad\tau_m=k_pe+k_d\dot e.$$

固定目标给 $J\ddot e+(b+k_d)\dot e+k_pe=d$，故 $k_p=J\omega_n^2$、$k_d=2\zeta J\omega_n-b$。加入 $k_i\int e\,dt$ 后，正参数还需 $(b+k_d)k_p>Jk_i$；稳定后常负载偏差才为零。见[§7.2.3](ch07/sec7-2.md#sec-7.2.3)–[§7.2.4](ch07/sec7-2.md#sec-7.2.4)。

### I2 电压PI位置环

$$L(s)=\frac{k_mK_Pk_{tp}(1+sT_p)}{s^2(1+sT_m)},\qquad
T_ms^3+s^2+\kappa T_ps+\kappa=0.$$

对 $\kappa=k_mK_Pk_{tp}>0$、$T_m>0$，Routh条件是 $T_p>T_m$。这里比例项为 $K_PT_p$，积分项为 $K_P/s$，不要与上一段的力矩刚度混用。

### I3 驱动接口

$$q_m=K_rq,\quad\tau_m=K_r^{-1}\tau=K_ti_a,\quad
G_vv_c=R_ai_a+K_v\dot q_m,$$

$$\tau=K_rK_tR_a^{-1}(G_vv_c-K_vK_r\dot q).$$

忽略负载压降时的速度偏差为 $(K_vK_r)^{-1}R_aK_t^{-1}K_r^{-1}\tau$。它足够小才支持电压近似速度接口；电流环则在带宽和限幅范围内近似实现转矩。接口不直接决定分散／集中。见[@thm-7.2.A]。

### I4 前馈与反馈线性化

$$\tau_{\rm ff}=\hat B(q_d)\ddot q_d+\hat C(q_d,\dot q_d)\dot q_d+\hat F\dot q_d+\hat g(q_d).$$

已有名义补偿时只添加残余项。反馈线性化另取

$$u=B(q)(\ddot q_d+K_D\dot e+K_Pe)+n(q,\dot q),$$

精确模型且无限幅时得到 $\ddot e+K_D\dot e+K_Pe=0$。这组 $K_P,K_D$ 分别用 $\mathrm{s^{-2}},\mathrm{s^{-1}}$；模型输入、反馈位置和增益单位都与直接转矩PD不同。见[§7.3.4](ch07/sec7-3.md#sec-7.3.4)。

### I5 固定目标的重力补偿

$$u=g(q)+K_Pe-K_D\dot q,\qquad
V=\tfrac12\dot q^{\mathrm T}B\dot q+\tfrac12e^{\mathrm T}K_Pe,$$

$$\dot V=-\dot q^{\mathrm T}(F+K_D)\dot q.$$

除能量恒等式外，还需紧致不变集与LaSalle检查才能推出目标收敛。移动参考不能照搬固定目标的证明。

### I6 模型不确定性

鲁棒段要求可用的误差界；自适应段要求未知常参数的线性表示。边界层的 $\varepsilon$ 不是直接位置误差界；自适应的跟踪收敛也不等于参数辨识。完整符号与证明见[§7.3.5](ch07/sec7-3.md#sec-7.3.5)–[§7.3.6](ch07/sec7-3.md#sec-7.3.6)。

### I7 任务控制

$$\dot x=J_A\dot q,\quad\ddot x=J_A\ddot q+\dot J_A\dot q,\quad
F_A=T_A^{\mathrm T}F,\quad\tau=J_A^{\mathrm T}F_A.$$

$F_A$ 与局部坐标导数配对，$F$ 与物理线、角速度配对。固定任务的弹簧阻尼为

$$u=g+J_A^{\mathrm T}K_Pe_x-J_A^{\mathrm T}K_DJ_A\dot q.$$

任务逆动力学在方阵可逆区域取

$$y=J_A^{-1}(\ddot x_d+K_D\dot e_x+K_Pe_x-\dot J_A\dot q),\quad u=By+n.$$

行满秩决定任务惯量 $(J_AB^{-1}J_A^{\mathrm T})^{-1}$ 是否存在；冗余内部运动与附加力矩另行设计。见[§7.4](ch07/sec7-4.md)。

### I8 检查实现

按实际接口、模型、反馈与限幅验证，不按一次仿真的误差数字给控制器划精度档位。具体流程见[@method-7.2.A]和[§7.5](ch07/sec7-5.md)。

---

## 附 · 一张纸的「最小必背集」

若只背这些条，背下面这**二十四**条（老师明确点过考试权重的在最前）：

1. **绿框逐列构造** $J_i$（转动 / 移动两式）——「肯定是要考的」；
2. **$A_i^{i-1}$ 完整矩阵**与「第 4 列 = 三参数肉身」；
3. **右乘当前轴、左乘固定轴**；
4. **$\tau=J^{\mathrm T}F_e$**——「主要是记住这个公式就可以」；
5. **解耦腕心** $\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$；
6. **ZYZ 正解矩阵**与逆解三式（Atan2）；
7. **$\det J=\det J_{11}\det J_{22}$**（球腕解耦）；
8. **$\dot R=S(\boldsymbol\omega)R$** 与 $S(\boldsymbol\omega)$ 的三分量；
9. **$J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$** 与零空间项 $(I-J^\dagger J)\dot{\boldsymbol q}_0$；
10. **DH 四参数「3 常 1 变」**与「能零则零」；
11. **三次 / 五次的规范化形式** $3\eta^2-2\eta^3$、$10\eta^3-15\eta^4+6\eta^5$（$\eta=t/t_f$）——「约束数 = 系数个数」；
12. **梯形速度曲线**：$t_c$ 二次方程 (4.5)、加速度下界 $|\ddot q_c|\ge4|q_f-q_i|/t_f^2$、巡航速度约束 (4.9)——「重点介绍混合梯形」；
13. **两次降维**：位置 $\dot p_e=\dot s\,t$（圆弧再加向心项 $\dot s^2/\rho\,n$）、姿态（角和轴）$\omega'=\dot\theta r'$；
14. **减速比两个折算因子**：$I_{eq}=I_m+I/k_r^2$、$F_{eq}=F_m+F/k_r^2$，负载力矩 $C_l/k_r$——「$1/k_r^2$ 管惯量、$1/k_r$ 管力矩」；
15. **电气驱动四方程**与**统一传递函数** $M(s)=k_m/[s(1+sT_m)]$，两种发电机的 $k_m,T_m$（速度控制 $1/k_v$、$R_aI_m/(k_vk_t)$；力矩控制 $k_t/(k_iF_m)$、$I_m/F_m$）；
16. **传动装置三重作用**（定量 / 定性 / 减重解耦）与三种装置的适用场合，以及「同步带快、正时链重」；
17. **传感器的三个公式**：编码器 $2\pi/2^n$ 与减速后的分辨率、$d=vt/2$（声纳，含 $v\approx331.4+0.6T$）、相机 $X_I=x_I/\lambda$；
18. **拉格朗日方程**与三步流程（选坐标 → $T,U$ → 代方程）；**广义力四件套**；
19. **完整运动方程那一行** $B\ddot q+C\dot q+F_{\mathrm v}\dot q+F_{\mathrm s}\operatorname{sgn}\dot q+\boldsymbol g=\tau-J^{\mathrm T}h_e$，与 $h_{ijk}=\partial_kb_{ij}-\frac12\partial_ib_{jk}$；
20. **两条结构性质**：(7.48) 反对称（Christoffel 选法）与 (7.49) $\dot q^{\mathrm T}N\dot q=0$（任意选法、能量守恒）；$\tau=Y\pi$ 线性（11/13/最小参数集）。
21. **驱动接口**：保留电阻压降与反电动势，按负载误差、内环带宽与限幅判断近似；接口不直接决定分散／集中。
22. **PD负载偏差**：固定目标常负载下 $e_{\rm ss}=d/k_p$；积分或准确负载前馈均可改变它，须检查相应稳定条件。
23. **逆动力学**：准确模型下先实现 $\ddot q=y$，再推导线性误差方程；失配、采样与限幅改变结论，但不自动使架构变成分散。
24. **两种反馈空间**：关节误差与任务误差都可进入控制；核查实际反馈来源，模型估计不等于独立末端测量。

配套的常见错误清单见[易错点总表](preface-pitfalls.md)，术语查不到时用[术语索引](preface-index.md)。
