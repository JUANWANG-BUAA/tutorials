# 9.3 位姿估计（一）：PnP 问题与解析解

在基于位置的视觉伺服（PBVS）中，控制律需要目标相对于相机的三维齐次变换矩阵 $T^c_o\in SE(3)$，而单目相机只给出图像上的二维特征点。正如第 2 章由末端位姿反求关节角的逆运动学一样，本节解决如何从 $n$ 对「目标系已知 3D 坐标 $\leftrightarrow$ 图像实测 2D 投影」反解 $T^c_o$（即 **Perspective-$n$-Point, PnP** 问题），重点推导工程最常见的共面四点平面单应线性解析解与含噪环境下的 $SO(3)$ 正交投影修正。

<a id="sec-9.3.1"></a>

## 9.3.1 透视投影方程与 PnP 多解歧义

设目标坐标系 $\{o\}$ 固连在刚体目标上，其上 $n$ 个特征点在目标系中的已知几何坐标为 $\boldsymbol r^o_{o,i}=[r_{x,i},\ r_{y,i},\ r_{z,i}]^{\mathrm T}\in\mathbb R^3$。相机内参 $\Omega$ 已知时，实测像素坐标预先换算为无量纲归一化坐标 $\boldsymbol s_i=[X_i,\ Y_i]^{\mathrm T}$，由正面透视投影方程（教材 (10.6)）建立：

$$\boxed{\ \lambda_i\,\tilde{\boldsymbol s}_i = \Pi\,T^c_o\,\tilde{\boldsymbol r}^o_{o,i}\ },\qquad
T^c_o=\begin{bmatrix}R^c_o & \boldsymbol o^c_o \\ \mathbf 0^{\mathrm T} & 1\end{bmatrix},\quad
\tilde{\boldsymbol s}_i=\begin{bmatrix}X_i\\Y_i\\1\end{bmatrix},\quad
\Pi=\begin{bmatrix}1&0&0&0\\0&1&0&0\\0&0&1&0\end{bmatrix}. \tag{9.3-1}$$

其中未知正标量 $\lambda_i=z_{c,i}>0$ 为第 $i$ 个特征点在相机系中的深度，$R^c_o=[\boldsymbol r_1\ \boldsymbol r_2\ \boldsymbol r_3]\in SO(3)$ 为旋转矩阵，$\boldsymbol o^c_o=[o_x,\ o_y,\ o_z]^{\mathrm T}$ 为目标原点在相机系中的位置。

**采用归一化坐标的核心优势**：方程 (9.3-1) **不再显含任何相机内参**（$\alpha_x,\alpha_y,X_0,Y_0$ 已被预处理吸收），使位姿估计成为纯粹的欧氏投影几何问题。

由于单目图像丢失了每个特征点沿视线的深度信息 $\lambda_i$，已知对数 $n$ 与特征共面性直接决定解析解是否唯一：

| 特征点配置 | 解析解个数 | 几何与代数原因 |
|:--|:--|:--|
| $3$ 点不共线（P3P） | 最多 $4$ 个正深度解 | 余弦定理消元得四次方程，存在深度翻折多解 |
| $4$ 点或 $5$ 点不共面 | 至少 $2$ 个 | 仍可能出现二次曲面退化产生多解 |
| **$4$ 点共面且无三点共线** | **唯一** | 降维为 $3\times 3$ 平面单应 $H$，$SO(3)$ 正交性锁定尺度与符号 |
| **$\ge 6$ 点不共面（一般位置）** | **唯一** | $2n\ge 12$ 个线性方程配合正交约束唯一确定 |

<a id="sec-9.3.2"></a>

## 9.3.2 共面四点 PnP：平面单应与反对称消尺度

工业装配零件或标定靶标的特征点大多位于同一平面上。不失一般性，将目标系 $\{o\}$ 的坐标平面 $z_o=0$ 置于该特征平面，使所有特征点满足 $r_{z,i}=0$，$\tilde{\boldsymbol r}^o_{o,i}=[r_{x,i},\ r_{y,i},\ 0,\ 1]^{\mathrm T}$。展开式 (9.3-1) 右端：

$$\Pi\,T^c_o\,\tilde{\boldsymbol r}^o_{o,i}
= \begin{bmatrix}\boldsymbol r_1 & \boldsymbol r_2 & \boldsymbol r_3 & \boldsymbol o^c_o\end{bmatrix}
\begin{bmatrix}r_{x,i}\\r_{y,i}\\0\\1\end{bmatrix}
= \begin{bmatrix}\boldsymbol r_1 & \boldsymbol r_2 & \boldsymbol o^c_o\end{bmatrix}
\begin{bmatrix}r_{x,i}\\r_{y,i}\\1\end{bmatrix}.$$

旋转矩阵第三列 $\boldsymbol r_3$ 与 $0$ 相乘自动消去，三维投影方程自然降维为 $3\times 3$ **平面单应（planar homography）**方程：

$$\boxed{\ \lambda_i\,\tilde{\boldsymbol s}_i = H\begin{bmatrix}r_{x,i}\\r_{y,i}\\1\end{bmatrix},\qquad
H=\begin{bmatrix}\boldsymbol r_1 & \boldsymbol r_2 & \boldsymbol o^c_o\end{bmatrix}\in\mathbb R^{3\times 3}.\ } \tag{9.3-2}$$

暂时省去的第三列 $\boldsymbol r_3$ 并不是丢失，待求得前两列后直接由右手法则 $\boldsymbol r_3=\boldsymbol r_1\times\boldsymbol r_2$ 补回。

::: thm 定理 9.3.1 · 共面四点 PnP 线性求解定理 {#thm-9.3.1}
设平面 $z_o=0$ 上有 $n=4$ 个无三点共线的已知特征点。对式 (9.3-2) 两边左乘像点反对称矩阵 $S(\tilde{\boldsymbol s}_i)$（利用 $S(\boldsymbol v)\boldsymbol v=\boldsymbol v\times\boldsymbol v=\mathbf 0$ 消去各点独立深度 $\lambda_i$），得关于列拉直向量 $\boldsymbol h=[\boldsymbol r_1^{\mathrm T},\ \boldsymbol r_2^{\mathrm T},\ \boldsymbol o_o^{c\mathrm T}]^{\mathrm T}\in\mathbb R^9$ 的线性齐次方程组 $A(\boldsymbol s)\boldsymbol h=\mathbf 0$，其中 $A(\boldsymbol s)\in\mathbb R^{12\times 9}$ 恒有 $\operatorname{rank}A=8$。取其一维零空间基向量 $\boldsymbol h=[\boldsymbol h_1^{\mathrm T},\ \boldsymbol h_2^{\mathrm T},\ \boldsymbol h_3^{\mathrm T}]^{\mathrm T}$，位姿各列唯一恢复为：

$$\boldsymbol r_1=\zeta\boldsymbol h_1,\qquad \boldsymbol r_2=\zeta\boldsymbol h_2,\qquad \boldsymbol o^c_o=\zeta\boldsymbol h_3,\qquad
|\zeta|=\frac{1}{\|\boldsymbol h_1\|}=\frac{1}{\|\boldsymbol h_2\|}, \tag{9.3-6,9.3-7}$$

其中 $\zeta$ 的符号按物理可见性「目标位于相机前方」（$o_z=(\zeta\boldsymbol h_3)_z>0$ 或各点 $\lambda_i>0$）选取，旋转阵第三列由

$$\boldsymbol r_3=\boldsymbol r_1\times\boldsymbol r_2 \tag{9.3-8}$$

唯一补出。
:::

::: proof 证明：四步解析消元与尺度确定
1. **消去每点未知深度 $\lambda_i$**：定义向量 $\tilde{\boldsymbol v}=[v_1,v_2,v_3]^{\mathrm T}$ 的叉乘反对称矩阵
$$S(\tilde{\boldsymbol v})=\begin{bmatrix}0&-v_3&v_2\\v_3&0&-v_1\\-v_2&v_1&0\end{bmatrix},\qquad S(\tilde{\boldsymbol v})\tilde{\boldsymbol v}=\mathbf 0.$$
对式 (9.3-2) 左乘 $S(\tilde{\boldsymbol s}_i)$，左端 $\lambda_i S(\tilde{\boldsymbol s}_i)\tilde{\boldsymbol s}_i=\mathbf 0$，从而一举消去随点变化的深度因子 $\lambda_i$：
$$S(\tilde{\boldsymbol s}_i)\,H\begin{bmatrix}r_{x,i}\\r_{y,i}\\1\end{bmatrix}=S(\tilde{\boldsymbol s}_i)\bigl(r_{x,i}\boldsymbol r_1+r_{y,i}\boldsymbol r_2+\boldsymbol o^c_o\bigr)=\mathbf 0. \tag{9.3-3}$$
（消去 $\lambda_i$ 并非丢弃深度信息：各点的相对深度比已保留在 $\boldsymbol h$ 各分量及整体比例的线性耦合中。）
2. **组装线性齐次方程组**：将 $H$ 按列堆叠为 $\boldsymbol h\in\mathbb R^9$，单点方程改写为：
$$\boxed{\ A_i(\boldsymbol s_i)\boldsymbol h=\mathbf 0,\qquad A_i(\boldsymbol s_i)=\begin{bmatrix}r_{x,i}S(\tilde{\boldsymbol s}_i) & r_{y,i}S(\tilde{\boldsymbol s}_i) & S(\tilde{\boldsymbol s}_i)\end{bmatrix}\in\mathbb R^{3\times 9}.\ } \tag{9.3-4}$$
注意 $S(\tilde{\boldsymbol s}_i)$ 第 3 行等于 $-X_i\times(\text{第 1 行})-Y_i\times(\text{第 2 行})$，故 $\operatorname{rank}S(\tilde{\boldsymbol s}_i)=2$，每点实际提供 $2$ 条独立方程。将 4 个无三点共线的点纵向堆叠：
$$A(\boldsymbol s)\boldsymbol h=\mathbf 0,\qquad A(\boldsymbol s)=\begin{bmatrix}A_1(\boldsymbol s_1)\\A_2(\boldsymbol s_2)\\A_3(\boldsymbol s_3)\\A_4(\boldsymbol s_4)\end{bmatrix}\in\mathbb R^{12\times 9}, \tag{9.3-5}$$
共含 $8$ 条独立约束（$\operatorname{rank}A=8$），其零空间 $\mathcal N(A)$ 为一维子空间。求解 $A=U_A\Sigma_A V_A^{\mathrm T}$ 中最小奇异值 $\sigma_9$ 对应的右奇异向量即可得到归一化零空间基向量 $\boldsymbol h$（有噪声或 $n>4$ 时仍为总最小二乘解）。
3. **定尺度与定符号**：因 $\boldsymbol r_1,\boldsymbol r_2\in SO(3)$ 前两列均为单位向量，故 $|\zeta|=1/\|\boldsymbol h_1\|=1/\|\boldsymbol h_2\|$（含噪时可取 $2/(\|\boldsymbol h_1\|+\|\boldsymbol h_2\|)$ 对称平均）。由于数值 SVD 返回的奇异向量符号任意，**绝不可在代码中硬编码 $\zeta$ 正负号**，必须依据「点在相机光轴前方（$z_{c,i}>0$）」确定符号，最后计算 $\boldsymbol r_3=\boldsymbol r_1\times\boldsymbol r_2$ 构成 $Q=[\boldsymbol r_1\ \boldsymbol r_2\ \boldsymbol r_3]$。
:::

<a id="sec-9.3.3"></a>

## 9.3.3 噪声下的最近旋转矩阵投影

当像点坐标存在测量噪声或内参有偏差时，式 (9.3-6)–(9.3-8) 求出的 $\boldsymbol r_1,\boldsymbol r_2$ 未必严格等长正交，拼接矩阵 $Q=[\boldsymbol r_1\ \boldsymbol r_2\ \boldsymbol r_3]$ 一般不再满足 $R^{\mathrm T}R=I_3$ 与 $\det R=+1$。工程上须在 $SO(3)$ 上寻找 Frobenius 范数意义下距 $Q$ 最近的合法旋转矩阵（教材 Problem 10.3）：

::: thm 定理 9.3.2 · Frobenius 范数下的最近旋转矩阵投影 {#thm-9.3.2}
给定矩阵 $Q\in\mathbb R^{3\times 3}$，设其奇异值分解为 $Q=U\Sigma V^{\mathrm T}$（$U,V\in O(3)$，$\sigma_1\ge\sigma_2\ge\sigma_3\ge 0$）。优化问题

$$\min_{R\in SO(3)}\|R^c_o-Q\|_F = \min_{R\in SO(3)}\sqrt{\operatorname{Tr}\bigl((R^c_o-Q)^{\mathrm T}(R^c_o-Q)\bigr)} \tag{9.3-9}$$

等价于最大化 $\operatorname{Tr}(R^{\mathrm T}Q)$，其全局最优解为：

$$\boxed{\ R^c_o=U\begin{bmatrix}1&0&0\\0&1&0\\0&0&\sigma\end{bmatrix}V^{\mathrm T},\qquad \sigma=\det(UV^{\mathrm T})\in\{+1,-1\}.\ } \tag{9.3-10}$$
:::

::: proof 证明：迹循环与奇异值上界
展开 $\|R-Q\|_F^2 = \operatorname{Tr}(R^{\mathrm T}R)+\operatorname{Tr}(Q^{\mathrm T}Q)-2\operatorname{Tr}(R^{\mathrm T}Q)$。因 $R\in SO(3)$ 恒有 $\operatorname{Tr}(R^{\mathrm T}R)=3$，故最小化 Frobenius 范数等价于最大化 $\operatorname{Tr}(R^{\mathrm T}Q)$。代入 $Q=U\Sigma V^{\mathrm T}$ 并利用迹循环不变性：
$$\operatorname{Tr}(R^{\mathrm T}Q)=\operatorname{Tr}(V^{\mathrm T}R^{\mathrm T}U\Sigma)=\operatorname{Tr}(W\Sigma)=\sum_{k=1}^3 w_{kk}\sigma_k,$$
其中正交阵 $W=V^{\mathrm T}R^{\mathrm T}U\in O(3)$ 满足 $|w_{kk}|\le 1$ 且 $\det W = \det(UV^{\mathrm T})\equiv \sigma$。当 $\sigma=+1$ 时取 $W=I_3$；当 $\sigma=-1$ 时须反号最小奇异值 $\sigma_3$ 项，即取 $W=\operatorname{diag}(1,1,-1)$。两种情形统一为 $W=\operatorname{diag}(1,1,\sigma)$，解出 $R=U\operatorname{diag}(1,1,\sigma)V^{\mathrm T}$ 且 $\det R=\det(UV^{\mathrm T})\sigma=\sigma^2=+1$。
:::

<a id="sec-9.3.4"></a>

## 9.3.4 算例核对：教材例 10.1

设正方形平面板边长 $l=0.1\,\mathrm m$，四个顶点在目标系 $z_o=0$ 中的坐标为：

$$\boldsymbol r^o_{o,1}=\begin{bmatrix}0\\0\\0\end{bmatrix},\quad
\boldsymbol r^o_{o,2}=\begin{bmatrix}0.1\\0\\0\end{bmatrix},\quad
\boldsymbol r^o_{o,3}=\begin{bmatrix}0.1\\0.1\\0\end{bmatrix},\quad
\boldsymbol r^o_{o,4}=\begin{bmatrix}0\\0.1\\0\end{bmatrix}\,\mathrm m.$$

给定真实位姿（按英文原书数值校核，参见[勘误](errata.md)）：

$$R^c_o=R_y(\pi/4)=\begin{bmatrix}0.7071&0&0.7071\\0&1&0\\-0.7071&0&0.7071\end{bmatrix},\qquad
\boldsymbol o^c_o=\begin{bmatrix}0\\0\\0.5\end{bmatrix}\,\mathrm m.$$

1. **正向透视投影验证**：以 $P_2$ 为例，先换算相机系坐标 $\boldsymbol r^c_2 = R^c_o[0.1,0,0]^{\mathrm T}+\boldsymbol o^c_o = [0.07071,\ 0,\ 0.42929]^{\mathrm T}\,\mathrm m$，故归一化投影 $X_2=0.07071/0.42929=0.1647,\ Y_2=0$。四点归一化像点依次为：

$$\boldsymbol s_1=\begin{bmatrix}0\\0\end{bmatrix},\quad
\boldsymbol s_2=\begin{bmatrix}0.1647\\0\end{bmatrix},\quad
\boldsymbol s_3=\begin{bmatrix}0.1647\\0.2329\end{bmatrix},\quad
\boldsymbol s_4=\begin{bmatrix}0\\0.2\end{bmatrix}.$$

2. **反向线性解析还原**：代入式 (9.3-4)–(9.3-5) 组装 $12\times 9$ 矩阵 $A(\boldsymbol s)$（测得 $\operatorname{rank}A=8$），对零空间右奇异向量按列重排得：

$$[\boldsymbol h_1\ \ \boldsymbol h_2\ \ \boldsymbol h_3]=\begin{bmatrix}-0.4714&0&0\\0&-0.6667&0\\0.4714&0&-0.3333\end{bmatrix}.$$

由式 (9.3-7) 得 $|\zeta|=1/\|\boldsymbol h_1\|=1/0.6667=1.5$；因深度 $o_z=(\zeta\boldsymbol h_3)_z=-0.3333\,\zeta>0$，取 $\zeta=-1.5$。代回式 (9.3-6) 得 $\boldsymbol r_1=[0.7071,0,-0.7071]^{\mathrm T}$、$\boldsymbol r_2=[0,1,0]^{\mathrm T}$、$\boldsymbol o^c_o=[0,0,0.5]^{\mathrm T}$，再算 $\boldsymbol r_3=\boldsymbol r_1\times\boldsymbol r_2=[0.7071,0,0.7071]^{\mathrm T}$，精确恢复原位姿（无噪时 $Q$ 本身正交，式 (9.3-10) 退化为恒等映射）。

::: note 教材印刷记号辨析
英文教材与中译本在例 10.1 中将上述零空间向量列排矩阵错印为「$\zeta H$」，紧接着又写「取 $\zeta=-1.5$ 得精确解」。按式 (9.3-6) 记号对照可知，原书印出的 $3\times 3$ 矩阵实为尚未乘以尺度因子的**零空间基向量 $[\boldsymbol h_1\ \boldsymbol h_2\ \boldsymbol h_3]$**，乘以 $-1.5$ 后方为真实单应矩阵 $H=[\boldsymbol r_1\ \boldsymbol r_2\ \boldsymbol o^c_o]$（详见[勘误](errata.md)）。
:::

<a id="sec-9.3.5"></a>

## 9.3.5 非共面直接线性变换（DLT）

若特征点不共面（$r_{z,i}$ 不全为零），则无法消去 $\boldsymbol r_3$，须直接对 $3\times 4$ 位姿块 $[R^c_o\ \boldsymbol o^c_o]$ 左乘反对称矩阵消尺度，得到非共面**直接线性变换（DLT）**方程（教材 (10.13)）：

$$S(\tilde{\boldsymbol s}_i)\begin{bmatrix}R^c_o&\boldsymbol o^c_o\end{bmatrix}\tilde{\boldsymbol r}^o_{o,i}=\mathbf 0. \tag{9.3-11}$$

每个点提供 $2$ 条独立约束，$n=6$ 个一般位置不共面点给出 $12$ 个方程与 $12$ 个未知量，系数矩阵秩为 $11$，仍需借助旋转矩阵正交单位性锁定全局尺度与符号；有噪声时取 $n>6$ 点作 SVD 最小二乘求解，并按式 (9.3-10) 投影回 $SO(3)$。

<a id="sec-9.3.6"></a>

## 9.3.6 坐标系输出接口转换

线性解输出的 $T^c_o$ 描述目标相对相机系位姿；控制时按配置乘以外参转换为相对机座或末端位姿：

- **眼到手**：$T^b_o=T^b_c\,T^c_o$；
- **眼在手**：$T^e_o=T^e_c\,T^c_o$。

<a id="sec-9.3.7"></a>

## 9.3 小结与常见错误

1. **归一化消除内参**：式 (9.3-1) 通过 $\tilde{\boldsymbol s}=\Omega^{-1}\tilde{\boldsymbol c}$ 剥离相机内参；单目深度模糊导致 3 点 4 解、4/5 点不共面至少 2 解、4 点共面无三点共线及 $\ge 6$ 点不共面解唯一。
2. **反对称消尺度**：左乘 $S(\tilde{\boldsymbol s}_i)$ 利用 $\boldsymbol v\times\boldsymbol v=\mathbf 0$ 消去 $\lambda_i$，化非线性透视为齐次线性系统 $A\boldsymbol h=\mathbf 0$（共面 4 点 $\operatorname{rank}A=8$）。
3. **定尺、定号与正交化**：$|\zeta|=1/\|\boldsymbol h_1\|$，**符号必须由 $z_{c,i}>0$ 判定而绝不硬编码**；含噪时由 SVD 最近旋转矩阵投影 (9.3-10) 返回 $SO(3)$。

<a id="sec-9.3.check"></a>
<details>
<summary>检查理解：为什么反对称矩阵能把未知尺度消掉？</summary>

因对任何向量 $\tilde{\boldsymbol v}$ 均有 $S(\tilde{\boldsymbol v})\tilde{\boldsymbol v}=\tilde{\boldsymbol v}\times\tilde{\boldsymbol v}=\mathbf 0$，左乘 $S(\tilde{\boldsymbol s}_i)$ 直接消去了每点各异的标量因子 $\lambda_i$。消去的是每点孤立尺度，深度比例信息已转为齐次单应矩阵 $H$ 各列比例与整体缩放因子 $\zeta$，最终由正交列模长为 $1$ 与目标位于光轴前方唯一恢复。

</details>

**核心公式速查**：

| 条目 | 公式 | 条件与易错点 |
|:--|:--|:--|
| 透视投影方程 | $\lambda_i\tilde{\boldsymbol s}_i=\Pi T^c_o\tilde{\boldsymbol r}^o_{o,i}$ | $\lambda_i=z_{c,i}>0$，归一化坐标不含内参 |
| 共面单应与线性系 | $\lambda_i\tilde{\boldsymbol s}_i=H[r_{x,i},r_{y,i},1]^{\mathrm T}$，$A_i\boldsymbol h=\mathbf 0$ | 共面 $z_o=0$；四点 12 方程秩 8 |
| 尺度与第三列恢复 | $\boldsymbol r_{1,2}=\zeta\boldsymbol h_{1,2},\ \boldsymbol o^c_o=\zeta\boldsymbol h_3$，$|\zeta|=1/\|\boldsymbol h_1\|$，$\boldsymbol r_3=\boldsymbol r_1\times\boldsymbol r_2$ | $\zeta$ 符号由 $o_z>0$ 定，不可硬编码 |
| SVD 最近旋转阵 | $R^c_o=U\operatorname{diag}(1,1,\det(UV^{\mathrm T}))V^{\mathrm T}$ | 噪声下 $Q=U\Sigma V^{\mathrm T}$ 投影至 $SO(3)$ |

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导与例题复核；下列课件页保留以备核对，**不构成正文的替代**（对应录播 55:10–72:20）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 55:10 | [pnp-setup.jpg](../assets/ch09/pnp-setup.jpg) | 眼在手相机的目标系/相机系定义 | 正文 9.3.1 展开 |
| 63:10 | [pnp-skew.jpg](../assets/ch09/pnp-skew.jpg) | 斜对称矩阵消尺度 | 正文 9.3.2 完整推导 |
| 72:20 | [pnp-example.jpg](../assets/ch09/pnp-example.jpg) | 例 10.1 平面目标四特征点 | 正文 9.3.4 正算与反解逐项核对 |
:::
