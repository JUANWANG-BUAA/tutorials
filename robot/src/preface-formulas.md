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
| 列的含义 | $R$ 的第 $j$ 列 = 系 $j$ 的 $x_j$ 轴在系 $i$ 中的方向余弦 | [@def-2.2.1] |

**三重身份**（同一矩阵、三种读法）：姿态**描述** / 坐标**变换** / 旋转**算子**——[@thm-2.2.B]。

### A2 基本旋转

$$R_x(\vartheta)=\begin{bmatrix}1&0&0\\0&c_\vartheta&-s_\vartheta\\0&s_\vartheta&c_\vartheta\end{bmatrix},\quad
R_y(\vartheta)=\begin{bmatrix}c_\vartheta&0&s_\vartheta\\0&1&0\\-s_\vartheta&0&c_\vartheta\end{bmatrix},\quad
R_z(\vartheta)=\begin{bmatrix}c_\vartheta&-s_\vartheta&0\\s_\vartheta&c_\vartheta&0\\0&0&1\end{bmatrix}$$

### A3 合成规则（一切序列的母规则）

| 情形 | 做法 | 出处 |
|:--|:--|:--|
| 绕**当前**轴（动系）连续转 | **右乘** $R=R_1R_2R_3$ | [@thm-2.3.A] |
| 绕**固定**轴（定系）连续转 | **左乘** $R=R_3R_2R_1$ | [@thm-2.3.B] |
| 旋转不可交换 | $R_1R_2\neq R_2R_1$ | [@ex-book-2.3] |

> **口诀**：右乘当前轴、左乘固定轴。ZYZ / RPY 的对偶、DH 的 $A_i$ 连乘、角和轴的五步序列，全是这一条的换装登场。

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

第二支：三个宗量整体变号（$\vartheta$ 取 $(-\pi,0)$）。**奇点** $s_\vartheta=0$：只能定 $\varphi\pm\psi$，见 [@thm-2.4.B]。

### A5 RPY 角（绕固定轴，左乘）

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

**奇点** $c_\vartheta=0$（俯仰 $\pm90°$）。角名：roll 绕纵轴 $x$、pitch 绕 $y$、yaw 绕竖轴 $z$。

> **为什么反解一律用 Atan2**：$\arccos$ 的值域只有 $[0,\pi]$（不唯一），且导数 $(\arccos x)'=-1/\sqrt{1-x^2}$ 在 $x\to\pm1$ 处无界（误差被无限放大）；$(\arctan x)'=1/(1+x^2)\le1$ 处处有界。见 [@thm-2.4.A]。

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
| 由 $R$ 求轴（取反对称部分） | $\boldsymbol r=\dfrac{1}{2s_\vartheta}[r_{32}-r_{23},\ r_{13}-r_{31},\ r_{21}-r_{12}]^{\mathrm T}$ | [@def-2.5.1] |
| 指数映射 | $R(\vartheta,\boldsymbol r)=\exp\big(\vartheta S(\boldsymbol r)\big)=I+\sin\vartheta\,S+(1-\cos\vartheta)\,S^2$（幂次三循环 $S^2=\boldsymbol r\boldsymbol r^{\mathrm T}-I$、$S^3=-S$） | [@thm-2.5.D] |
| 对数映射 | $\log R=\vartheta S(\boldsymbol r)=\dfrac{\vartheta}{2s_\vartheta}(R-R^{\mathrm T})$ | [@thm-2.5.E] |
| 不唯一 | $R(-\vartheta,-\boldsymbol r)=R(\vartheta,\boldsymbol r)$ | [@thm-2.5.A] |
| 失效 | $s_\vartheta=0$：$\vartheta=0$ 轴任意；$\vartheta=\pi$ 反对称部分为零（对角线 $r_i^2=(r_{ii}+1)/2$ 另解） | [@thm-2.5.B] |

### A7 单位四元数（4 参数，无逆解奇点）

$$\eta=\cos\frac{\vartheta}{2},\qquad\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\,\boldsymbol r,\qquad\eta^2+|\boldsymbol\epsilon|^2=1$$

$$R(\eta,\boldsymbol\epsilon)=\begin{bmatrix}
2(\eta^2+\epsilon_x^2)-1 & 2(\epsilon_x\epsilon_y-\eta\epsilon_z) & 2(\epsilon_x\epsilon_z+\eta\epsilon_y)\\
2(\epsilon_x\epsilon_y+\eta\epsilon_z) & 2(\eta^2+\epsilon_y^2)-1 & 2(\epsilon_y\epsilon_z-\eta\epsilon_x)\\
2(\epsilon_x\epsilon_z-\eta\epsilon_y) & 2(\epsilon_y\epsilon_z+\eta\epsilon_x) & 2(\eta^2+\epsilon_z^2)-1
\end{bmatrix}$$

$$\eta=\tfrac12\sqrt{r_{11}+r_{22}+r_{33}+1},\qquad
\boldsymbol\epsilon=\tfrac12\begin{bmatrix}\operatorname{sgn}(r_{32}-r_{23})\sqrt{r_{11}-r_{22}-r_{33}+1}\\ \operatorname{sgn}(r_{13}-r_{31})\sqrt{r_{22}-r_{33}-r_{11}+1}\\ \operatorname{sgn}(r_{21}-r_{12})\sqrt{r_{33}-r_{11}-r_{22}+1}\end{bmatrix}$$

逆 $Q^{-1}=\{\eta,-\boldsymbol\epsilon\}$；乘积 $Q_1\otimes Q_2=\{\eta_1\eta_2-\boldsymbol\epsilon_1^{\mathrm T}\boldsymbol\epsilon_2,\ \eta_1\boldsymbol\epsilon_2+\eta_2\boldsymbol\epsilon_1+\boldsymbol\epsilon_1\times\boldsymbol\epsilon_2\}$。见 [@def-2.6.1]、[@thm-2.6.A]。

### A8 齐次变换（$SE(3)$）

$$\tilde{\boldsymbol p}=\begin{bmatrix}\boldsymbol p\\1\end{bmatrix},\qquad
A_1^0=\begin{bmatrix}R_1^0&\boldsymbol o_1^0\\\boldsymbol 0^{\mathrm T}&1\end{bmatrix},\qquad
A_0^1=(A_1^0)^{-1}=\begin{bmatrix}R_1^{0\mathrm T}&-R_1^{0\mathrm T}\boldsymbol o_1^0\\\boldsymbol 0^{\mathrm T}&1\end{bmatrix}$$

连乘：$\tilde{\boldsymbol p}^0=A_1^0A_2^1\cdots A_n^{n-1}\tilde{\boldsymbol p}^n$（[@thm-2.7.A]）。

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

**第 4 列就是三参数的「肉身」**：$(a_ic_{\vartheta_i},\ a_is_{\vartheta_i},\ d_i)$；旋转块 = 绕 $z$ 转 $\vartheta$ $\oplus$ 绕 $x$ 转 $\alpha$。

### B2 DH 四规则（每条各管一个参数）

**记忆主线 · 看守模型（[@method-2.8.watch]）**：系 $i-1$ 看守关节 $i$——$z_{i-1}$ 就是关节 $i$ 的轴线；杆 $i$ 固连系 $i$（原点在关节 $i+1$ 轴上）。建系四步实例见 [@method-2.8.anthro]。

| 规则 | 服务的参数 | 为什么 |
|:--|:--|:--|
| $z_i$ 沿**关节 $i+1$** 的轴线 | $\vartheta_i,d_i$（**变量**） | 关节运动就是「绕/沿自己的轴」，在 $A$ 里恰表现为绕 $z_{i-1}$ 转 / 沿 $z_{i-1}$ 移 |
| 原点 $o_i$ 取在公垂线交点、$x_i$ 沿公垂线 | $a_i$（常数） | 两根 $z$ 轴的相对位置由公垂线一锤定音 |
| 同一对 $z$ 轴的方向关系 | $\alpha_i$（常数） | 方向差只剩绕 $x_i$ 的一个转角 |
| $y_i$ 右手系补齐 | — | 只保证 $R\in SO(3)$ |

**总原则**：能自由选取的地方「**让参数尽量为零**」（[@method-2.8.zero]）——2.9 各表里成片的 $0$ 就是这条的兑现。

**3 常 1 变**：$a_i,\alpha_i$ 恒为常数；$d_i,\vartheta_i$ 中恰有一个是关节变量 $q_i$（转动关节 $q_i=\vartheta_i$、移动关节 $q_i=d_i$）——[@def-2.8.3]。

### B3 十步流程（[@method-2.8.steps]）

1. 关节轴编号，定 $z_0,\dots,z_{n-1}$；2. 选系 0；3. 对 $i=1..n-1$ 定 $o_i$；
4. 沿公垂线取 $x_i$；5. 右手系补 $y_i$；6. 选系 $n$；7. 列 $4n$ 参数表；
8. 逐个算 $A_i^{i-1}$；9. 连乘得 $T_n^0(q)$；10. 串常值变换 $T_b^0,T_e^n$ 得 $T_e^b$。

> **课堂口诀**：编号、建系（能零则零）、列参数表、代入、连乘。

### B4 两个空间、工作空间与冗余

$$\boldsymbol x_e=k(\boldsymbol q),\qquad T_e^b(\boldsymbol q)=T_b^0\,T_n^0(\boldsymbol q)\,T_e^n,\qquad
T_n^0=A_1^0A_2^1\cdots A_n^{n-1}$$

| 概念 | 内容 | 出处 |
|:--|:--|:--|
| 可达 ⊇ 灵活 | 可达 = 至少一个方向能到；灵活 = 任意方向都能到 | [@def-2.10.2] |
| 精度 ≠ 重复精度 | 精度 = 指令位姿与真实位姿的差；重复精度 = 多次回同一点的散布 | [@def-2.10.2] |
| 冗余判据 | $n$ 关节数、$m$ 操作空间维数、$r$ 任务实际用到的维数；$n>r$ 即冗余 | [@def-2.10.3] |

### B5 运动学标定

$$\Delta\boldsymbol x=\Phi\,\Delta\boldsymbol\xi,\qquad
\Delta\boldsymbol\xi=(\Phi^{*\mathrm T}\Phi^*)^{-1}\Phi^{*\mathrm T}\Delta\boldsymbol x^*,\qquad
\boldsymbol\xi'=\boldsymbol\xi+\Delta\boldsymbol\xi$$

$\Phi$ 为 $m\times4n$ 标定矩阵，$\Delta\boldsymbol\xi$ 为 $4n$ 维参数偏差。量测条件 $tm\ge4n$（**宜远大于**，防 $\Phi$ 病态）；因 $k$ 非线性，须**迭代**。见 [@method-2.11.steps]。

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

**腕 = ZYZ 反解**：球形腕的姿态部分与 ZYZ 欧拉角反解同构（A4 的公式直接可用）。

> **数解支的口诀**：位置解给「臂」的支数（平面臂 2 支 = 肘上 / 肘下，拟人臂 4 支），方向解给「腕」的支数（球腕 2 支 = 翻转），总数 = 臂 × 腕。

---

## D · 微分运动学（第 3 章）

### D1 微分运动学方程与旋转矩阵求导

$$\begin{bmatrix}\dot{\boldsymbol p}_e\\\boldsymbol\omega_e\end{bmatrix}=J(\boldsymbol q)\,\dot{\boldsymbol q},\qquad
J=\begin{bmatrix}J_P\\J_O\end{bmatrix}\in\mathbb R^{6\times n}$$

$$\dot R=S(\boldsymbol\omega)R,\qquad
S(\boldsymbol\omega)=\begin{bmatrix}0&-\omega_z&\omega_y\\\omega_z&0&-\omega_x\\-\omega_y&\omega_x&0\end{bmatrix},\qquad
S(\boldsymbol\omega)\boldsymbol p\equiv\boldsymbol\omega\times\boldsymbol p$$

推导链：$RR^{\mathrm T}=I$ 求导 ⇒ $\dot RR^{\mathrm T}$ 反对称 ⇒ 用常模向量比对 $\boldsymbol\omega\times\boldsymbol r$ 认出 $S=S(\boldsymbol\omega)$（[@thm-3.1.A]）。共轭关系 $RS(\boldsymbol\omega)R^{\mathrm T}=S(R\boldsymbol\omega)$（[@thm-3.1.B]，已在 [2.5](ch02/sec2-5.md#sec-2.5.1) 作为工具证明）。李代数读法：$\boldsymbol\omega=(\dot RR^{\mathrm T})^\vee$（基系读数），$R^{\mathrm T}\dot R$ 给刚体系读数（[@note-3.1.lie]）——「角速度 = $so(3)$ 的元素」（[2.5.3](ch02/sec2-5.md#sec-2.5.3)）。

### D2 逐列构造（绿框，**必考**）

$$J=\begin{bmatrix}J_1&\cdots&J_n\end{bmatrix},\qquad
J_i=\begin{bmatrix}J_{P_i}\\J_{O_i}\end{bmatrix},\qquad
\begin{cases}\text{关节 }i\text{ 转动：}& J_{P_i}=z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1}),\quad J_{O_i}=z_{i-1}\\[1mm]\text{关节 }i\text{ 移动：}& J_{P_i}=z_{i-1},\quad J_{O_i}=\boldsymbol 0\end{cases}$$

见 [@thm-3.1.C]。**所需量全部从正运动学读取**：

| 量 | 从哪读 |
|:--|:--|
| $z_{i-1}$ | $T_{i-1}^0$ 左上 $3\times3$ 块的**第三列**（基系表示，**不是** $[0,0,1]^{\mathrm T}$！） |
| $\boldsymbol p_{i-1}$ | $T_{i-1}^0$ 第四列前三行 |
| $\boldsymbol p_e$ | $T_n^0$ 第四列前三行 |

**物理含义**：其余关节全部锁死时，单个关节的单位速度对末端速度的贡献。

### D3 换到别的坐标系

$$J^u=\begin{bmatrix}R^u&0\\0&R^u\end{bmatrix}J$$

### D4 奇点

$$\det J(\boldsymbol q)=0$$

| 结构 | 判据 | 出处 |
|:--|:--|:--|
| 两连杆平面臂 | $\det J=a_1a_2s_2=0\iff\vartheta_2=0,\pi$ | [@def-3.3.1] |
| 带球腕机械手（解耦） | $\det J=\det J_{11}\cdot\det J_{22}$（$J_{11}$ 只含臂、$J_{22}$ 只含腕） | [@thm-3.3.A] |
| 腕奇点 | $\det J_{22}\propto s_5$ ⇒ $\vartheta_5=0,\pi$ | [@thm-3.3.A] |
| 拟人臂肘 / 肩 | $\det J_{11}=-a_2a_3s_3(a_2c_2+a_3c_{23})$ ⇒ $s_3=0$（肘）或 $a_2c_2+a_3c_{23}=0$（肩腕点落轴） | [@thm-3.3.A] |

### D5 冗余与零空间

$$n>r\ \Longrightarrow\ \mathcal N(J)\neq\{0\},\qquad
P=NN^{\mathrm T}\ (\text{秩 }n-r),\qquad
\dot{\boldsymbol q}=\dot{\boldsymbol q}^*+P\dot{\boldsymbol q}_0$$

$P\dot{\boldsymbol q}_0$ 在零空间里，**不惊动末端**（$JP\dot{\boldsymbol q}_0=0$）——用来做内部运动 / 再配置（避障、躲关节极限、远离奇异）。见 [@def-3.4.1]、[@thm-3.4.B]。

### D6 逆微分运动学：三味药

| $J$ 的形状 | 工具 | 公式 | 条件 |
|:--|:--|:--|:--|
| 方阵满秩 | $J^{-1}$ | $\dot{\boldsymbol q}=J^{-1}\boldsymbol v_e$，配数值积分 $\boldsymbol q_{k+1}=\boldsymbol q_k+J^{-1}\boldsymbol v_e\Delta t$ | $n=r$、无奇异 |
| 长方（冗余） | $J^\dagger$ | $\dot{\boldsymbol q}=J^\dagger\boldsymbol v_e+(I-J^\dagger J)\dot{\boldsymbol q}_0$，$J^\dagger=J^{\mathrm T}(JJ^{\mathrm T})^{-1}$ | $r<n$、行满秩 |
| 退化（奇异邻域） | $J^*$ | $J^{*}=W^{-1}J^{\mathrm T}(JW^{-1}J^{\mathrm T}+K^{-1})^{-1}$；$W=I,K=k^2I$ 时 $J^{*}=J^{\mathrm T}(JJ^{\mathrm T}+k^2I)^{-1}$ | 容许末端误差 $\delta$ |

见 [@def-3.5.1]、[@def-3.5.2]。

> **口诀**：方阵求逆、矮胖求伪逆、退化加阻尼。
> **$K$ 的取法**：奇点邻域取**大**（压住发散），远离奇点取**小甚至趋 0**（退回伪逆）。

**$\dot{\boldsymbol q}_0$ 的三种取法**（都取 $k_0(\partial g/\partial\boldsymbol q)^{\mathrm T}$，最大化 $g$）：

| 目标 $g$ | 作用 |
|:--|:--|
| $w=\sqrt{\det(JJ^{\mathrm T})}$（可操作度） | 远离奇异 |
| 关节角到**中点**的距离 | 躲关节极限 |
| 臂上点到障碍物的**最小**距离 | 避障 |

### D7 分析雅可比

$$\boldsymbol\omega_e=T(\boldsymbol\varphi_e)\dot{\boldsymbol\varphi}_e,\qquad
T(\boldsymbol\varphi)=\begin{bmatrix}0&-s_\varphi&s_\vartheta c_\varphi\\0&c_\varphi&s_\vartheta s_\varphi\\1&0&c_\vartheta\end{bmatrix}\ (\text{ZYZ}),\qquad
J_A=T_A^{-1}J,\qquad
T_A=\begin{bmatrix}I_3&0\\0&T\end{bmatrix}$$

$T$ 的三列 = 欧拉角三根转轴在基系中的方向（**未必正交**）。线速度部分 $J$ 与 $J_A$ **相同**，姿态部分差一个换基。$s_\vartheta=0$ 时 $T$ 奇异 ⇒ $J_A$ 失效（与 ZYZ 表示奇点同源）。见 [@def-3.6.1]、[@thm-3.6.A]。

---

## E · 静力学

$$\boxed{\ \boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\,F_e\ },\qquad
F_e=\begin{bmatrix}\boldsymbol f_e\\\boldsymbol\mu_e\end{bmatrix}\in\mathbb R^6$$

由虚功原理推出：$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol\tau=\boldsymbol v_e^{\mathrm T}F_e=(J\dot{\boldsymbol q})^{\mathrm T}F_e=\dot{\boldsymbol q}^{\mathrm T}J^{\mathrm T}F_e$。**速度变换的转置就是力变换**（对偶），长方阵也成立，无需满秩。见 [@def-3.8.1]。

**两坐标系间的速度 / 力变换**：

$$\begin{bmatrix}\dot{\boldsymbol p}_1^0\\\boldsymbol\omega_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&-R_1^0S(\tilde{\boldsymbol p})\\0&R_1^0\end{bmatrix}\begin{bmatrix}\boldsymbol v_1\\\boldsymbol\omega_1\end{bmatrix},
\qquad
\begin{bmatrix}\boldsymbol f_1^0\\\boldsymbol\mu_1^0\end{bmatrix}=\begin{bmatrix}R_1^0&0\\R_1^0S(\tilde{\boldsymbol p})&R_1^0\end{bmatrix}\begin{bmatrix}\boldsymbol f_1\\\boldsymbol\mu_1\end{bmatrix}$$

右边（力）恰是左边（速度）的转置——平移块 $S(\tilde{\boldsymbol p})$ 在速度式里带负号、在力式里移位且不带负号，正是对偶的体现。

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

$$\ddot\Pi_k(t)=\frac{\ddot\Pi_k(t_{k+1})}{\Delta t_k}(t_{k+1}-t)+\frac{\ddot\Pi_k(t_k)}{\Delta t_k}(t-t_k)\quad\Longrightarrow\quad A\,\boldsymbol\Pi=b$$

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

**两次降维**：位置落在 $s(t)$、姿态落在 $\theta(t)$——都是一维标量，直接复用关节空间的方法。

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

位置环需要 **积分**（稳态消除干扰）+ **比例**（稳定与阻尼）——纯比例给不出阻尼瞬态，原因是**前向通路有两个原点极点**（[@thm-5.2.D]）。加**测速反馈**后：干扰点附近两个回路 ⇒ 瞬态抗扰更强、带宽更宽、振荡更少（[@method-5.2.E]）。推广到齿轮耦合：用 $I_{eq},F_{eq}$ 代替 $I_m,F_m$，干扰按 $1/k_r$（[@note-5.2.1]）。

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

## I · 运动控制（第 7 章，对应原书第 8 章）

口径：**任务在操作空间提出，控制动作在关节空间实现**（[7.1.4](ch07/sec7-1.md#sec-7.1.4)）。I1–I3 为**课堂**内容（第 8 周后半），I4–I7 的具体控制律为**教材补**，I8 用于选型。

### I1 控制问题与两套方案（**课堂**）

**控制问题**：设计广义力 $\boldsymbol\tau(t)$ 的时程，使 $\boldsymbol q(t)$ 跟踪 $\boldsymbol q_d(t)$（或 $\boldsymbol x_e$ 跟踪 $\boldsymbol x_d$），并满足瞬态/稳态指标（[7.1.1](ch07/sec7-1.md#sec-7.1.1)）。

| 方案 | 闭环量 | $\boldsymbol x_d\to\boldsymbol x_e$ | 主要误差源 |
|:--|:--|:--|:--|
| 关节空间 | $\boldsymbol q$（编码器直测） | **开环**（只经运动学） | 运动学标定、逆解分支 |
| 操作空间 | $\boldsymbol x_e$（多由 $\boldsymbol q$ 算出） | 闭环（若 $x$ 可测/可估） | $x$ 的测量/估计误差、$J_A$ 奇异 |

**判据**：看闭环通道里有什么量、那个量的信息质量如何——不是看框图上那条线画到哪（[7.1.4.2](ch07/sec7-1.md#sec-7.1.4.2)）。

### I2 驱动接口：$\boldsymbol\tau$ 与控制电压 $\boldsymbol v_c$（**课堂，本讲正题**）

$$\boldsymbol q_m=K_r\boldsymbol q,\qquad
\boldsymbol\tau_m=K_r^{-1}\boldsymbol\tau=K_t\boldsymbol i_a,\qquad
\boldsymbol v_a=R_a\boldsymbol i_a+K_v\dot{\boldsymbol q}_m,\qquad
\boldsymbol v_a=G_v\boldsymbol v_c$$

$$\boldsymbol\tau=K_rK_tR_a^{-1}\bigl(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q}\bigr)$$

**读法**：电压想产生的转矩，一部分驱动关节，一部分被**反电动势**（$\propto\dot{\boldsymbol q}$）吃掉——这一项就是耦合的来源。**加电流环**（$K_r^{-1}\boldsymbol\tau=K_t\boldsymbol i_a$、$\boldsymbol i_a=G_i\boldsymbol v_c$）后 $\boldsymbol\tau=K_rK_tG_i\boldsymbol v_c$，$\dot{\boldsymbol q}$ 消失（[7.2.5](ch07/sec7-2.md#sec-7.2.5)）。
### I3 三条假设 ⇒ 速度源 / 力矩源（**课堂，「为什么能分散控制」的标准答案**）

$$K_r\gg I,\quad R_a\ \text{元素很小},\quad \tau\ \text{较小}
\ \Longrightarrow\quad G_v\boldsymbol v_c\approx K_vK_r\dot{\boldsymbol q}
\ \Longrightarrow\quad \boldsymbol v_c\approx G_v^{-1}K_vK_r\dot{\boldsymbol q}$$

- $\dot{\boldsymbol q}$ 与 $\boldsymbol v_c$ 的比例关系**与机械手参数无关** ⇒ 速度控制对参数变化有固有鲁棒性；
- $G_v^{-1}K_vK_r$ **对角** ⇒ 每关节独立 ⇒ **分散控制**；
- 反之，$\boldsymbol\tau$ 与 $\boldsymbol v_c$ 之间隔着 $\dot{\boldsymbol q}$ ⇒ 精确算 $\tau_i$ 需知**全部关节**运动 ⇒ **集中控制**，且驱动器必须是**力矩源**（[@thm-7.2.A]、[7.2.5.5](ch07/sec7-2.md#sec-7.2.5)）。

### I4 PD/PID 与稳态误差（教材补）

$$\tau_i=K_{P_i}e_i+K_{D_i}\dot e_i
\quad\Longrightarrow\quad
J_i\ddot e_i+K_{D_i}\dot e_i+K_{P_i}e_i=d_i'$$

$$\omega_n=\sqrt{K_P/J},\qquad
\zeta=\frac{K_D}{2\sqrt{K_PJ}},\qquad
e_{\mathrm{ss}}=\frac{d}{K_P}$$

**常值扰动下 PD 有差**（$e_{\rm ss}\neq0$）；要零误差必须加积分：
$\tau_i=K_{P_i}e_i+K_{I_i}\int e_i\,\mathrm dt+K_{D_i}\dot e_i$（1 型系统）（[7.2.2](ch07/sec7-2.md#sec-7.2.2)–[7.2.3](ch07/sec7-2.md#sec-7.2.3)）。

### I5 重力补偿 PD 与增益整定（教材补）

$$\boldsymbol\tau=\boldsymbol g(\boldsymbol q)+K_P\boldsymbol e+K_D\dot{\boldsymbol e}$$

其中 $\boldsymbol g$ 必须用**实测** $\boldsymbol q$ 在线计算（用 $\boldsymbol q_d$ 等于开环补偿），平衡点移到 $\boldsymbol e=0$。整定 $K_P=J\omega_n^2$、$K_D=2\zeta J\omega_n$：$\zeta$ 取 $0.7$–$1$，$\omega_n$ 受采样率（闭环带宽 $\lesssim$ 采样频率的 $1/10$–$1/5$）与结构共振限制（[7.2.4](ch07/sec7-2.md#sec-7.2.4)、[7.2.7](ch07/sec7-2.md#sec-7.2.7)）。

### I6 计算力矩（逆动力学）控制（教材补）

$$\boldsymbol\tau=B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}+K_P\boldsymbol e\bigr)
+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)$$

$$\Longrightarrow\qquad \ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e=\boldsymbol 0
\qquad(\text{模型精确且未限幅})$$

模型不准时右边多出 $B^{-1}[\Delta B\boldsymbol u+\Delta C\dot{\boldsymbol q}+\Delta\boldsymbol g]$ ⇒ 鲁棒/自适应；限幅是它最常见的失效原因（[7.3.2](ch07/sec7-3.md#sec-7.3.2)–[7.3.3](ch07/sec7-3.md#sec-7.3.3)）。

### I7 操作空间（课件 §7.8 + 教材补）

$$\dot{\boldsymbol x}=J_A(\boldsymbol q)\dot{\boldsymbol q},\qquad
B_A\ddot{\boldsymbol x}_e+C_A\dot{\boldsymbol x}_e+\boldsymbol g_A
=\boldsymbol\gamma_A-\boldsymbol h_A$$

课件记 $B_A,C_A,\boldsymbol g_A,\boldsymbol\gamma_A$，文献与本章 7.4 记 $B_x,C_x,\boldsymbol g_x,\boldsymbol\tau_x$——**同义**，对照见 [6.7](ch06/sec6-7.md)。控制律与关节空间逐项对应：

$$\boldsymbol F=B_x\bigl(\ddot{\boldsymbol x}_d+K_D\dot{\boldsymbol e}_x+K_P\boldsymbol e_x\bigr)
+C_x\dot{\boldsymbol x}+\boldsymbol g_x
\quad\Longrightarrow\quad
\ddot{\boldsymbol e}_x+K_D\dot{\boldsymbol e}_x+K_P\boldsymbol e_x=\boldsymbol 0$$

**两处易错**：① 必须用**分析**雅可比 $J_A$（欧拉角导数 $\dot{\boldsymbol\phi}\neq$ 角速度 $\boldsymbol\omega$）；② $\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F$（与静力学 $\boldsymbol\tau=J^{\mathrm T}F_e$ 同源）——别把 $J_A$ 与 $J$、转置与不转置混用（[7.4.2](ch07/sec7-4.md#sec-7.4.2)–[7.4.3](ch07/sec7-4.md#sec-7.4.3)）。

### I8 三方案对照（选型用）

| | 分散控制 | 集中 · 计算力矩 | 操作空间 |
|:--|:--|:--|:--|
| 反馈量 | $\boldsymbol q,\dot{\boldsymbol q}$ | $\boldsymbol q,\dot{\boldsymbol q}$ | $\boldsymbol x,\dot{\boldsymbol x}$（多为估计） |
| 驱动器 | **速度源**（电压控制） | **力矩源**（电流环） | **力矩源** |
| 误差方程 | 带扰动 $d_i'$ 的单轴二阶 | 解耦二阶（模型精确时） | 同左，在 $x$ 空间 |
| 计算量 / 适用 | 最小 / 低速轻载点位 | 大 / 高速高精重载 | 最大 / 柔顺冗余 |

（对照表与选型流程见 [7.4.5](ch07/sec7-4.md#sec-7.4.5)、[@method-7.2.A]。）
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
21. **驱动接口与速度源／力矩源**：五式与 $\boldsymbol\tau=K_rK_tR_a^{-1}(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q})$；三条假设 ⇒ $\boldsymbol v_c\approx G_v^{-1}K_vK_r\dot{\boldsymbol q}$ ⇒ 可分散；要精确算 $\boldsymbol\tau$ 须整机模型 ⇒ 集中（用电流环给力矩源）；
22. **PD 的稳态误差**：$e_{\mathrm{ss}}=d/K_P$（常值扰动下不为零）⇒ 零误差要加积分；重力补偿用**实测** $\boldsymbol q$，把平衡点移到 $\boldsymbol e=0$；
23. **计算力矩律与误差方程**：$\boldsymbol\tau=B(\boldsymbol q)(\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}+K_P\boldsymbol e)+C\dot{\boldsymbol q}+\boldsymbol g$ ⇒ $\ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e=\boldsymbol 0$（靠 $B$ 正定可逆）；模型误差与限幅会让它退回「带扰动的分散系统」；
24. **两套方案一句话**：任务在操作空间提出、控制动作在关节空间实现；关节空间方案的 $\boldsymbol x$ 段**开环**，操作空间方案的 $\boldsymbol x$ **难测**——「闭环通道里有什么量」才是方案判据。

配套的常见错误清单见[易错点总表](preface-pitfalls.md)，术语查不到时用[术语索引](preface-index.md)。
