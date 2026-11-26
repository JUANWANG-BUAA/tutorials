# 9.6 相机标定

[§9.3](sec9-3.md)–[§9.5](sec9-5.md) 的全部位姿估计与控制推导均假定相机**内参矩阵 $\Omega$** 与**外参位姿（$T^b_c$ 或 $T^e_c$）**事先已知。本节阐明如何利用已知几何标定板在线性或非线性框架下同时确定内参与外参（属于工程前置基础，了解主线）。

<a id="sec-9.6.1"></a>

## 9.6.1 标定参数的两类对象

- **内参（intrinsic parameters）**：决定相机成像光学与传感器像素采样映射的内参矩阵 $\Omega\in\mathbb R^{3\times 3}$（见 [§9.2.1](sec9-2.md#sec-9.2.1) 与 [§5.4](../ch05/sec5-4.md) (5.41)），包含焦距像素等效比 $\alpha_x,\alpha_y$（或 $f\alpha_x,f\alpha_y$）以及像平面主点偏置 $(X_0,Y_0)$；
- **外参（extrinsic parameters）**：描述相机坐标系 $\{c\}$ 相对于机器人基座系（眼到手 $T^b_c$）或末端执行器系（眼在手 $T^e_c$）的刚体安装齐次变换。

<a id="sec-9.6.2"></a>

## 9.6.2 内参已知时由共面 PnP 直接反解外参

当相机已完成出厂内参标定（$\Omega$ 已知）时，可先通过 $\tilde{\boldsymbol s}_i=\Omega^{-1}\tilde{\boldsymbol c}_i$ 将实测角点像素坐标换算为归一化图像坐标，再把特征几何位置精确已知的平面标定靶摆放至相对基座（或末端）已知的位姿 $T^b_o$（或 $T^e_o$）。利用 [§9.3](sec9-3.md) 的共面 PnP 解析求解 $T^c_o$ 后，直接由齐次变换链反解外参：

$$\boxed{\ T^b_c = T^b_o\,(T^c_o)^{-1}\ \text{（眼到手）},\qquad T^e_c = T^e_o\,(T^c_o)^{-1}\ \text{（眼在手）}.\ } \tag{9.6-3}$$

<a id="sec-9.6.3"></a>

## 9.6.3 内参未知时的三阶段线性标定法

若内参 $\Omega$ 同样未知，无法提前算出归一化坐标 $\tilde{\boldsymbol s}_i$，只能直接对**像素齐次坐标** $\tilde{\boldsymbol c}_i=[X_{I,i},\ Y_{I,i},\ 1]^{\mathrm T}=\Omega\tilde{\boldsymbol s}_i$ 建立共面投影模型（结合式 (9.3-2)）：

$$\lambda_i\,\tilde{\boldsymbol c}_i = H'\begin{bmatrix}r_{x,i}\\r_{y,i}\\1\end{bmatrix},\qquad
\boxed{\ H' = \Omega H = \Omega\begin{bmatrix}\boldsymbol r_1 & \boldsymbol r_2 & \boldsymbol o^c_o\end{bmatrix}\in\mathbb R^{3\times 3}.\ } \tag{9.6-5}$$

由此分三阶段在线性代数框架下同时求解 $\Omega$ 与各姿态下的外参（教材 §10.5）：

::: thm 定理 9.6.1 · 三阶段线性平面标定与内参闭式提取 {#thm-9.6.1}
对同一已知尺寸平面标定板拍摄 $k\ge 3$ 幅不同倾斜姿态的图像（每幅提取 $n\ge 4$ 个无三点共线角点）：

1. **阶段一（逐幅求解像素单应 $\hat H'_j$）**：对第 $j$ 幅图直接以像素坐标 $\tilde{\boldsymbol c}_i$ 代入消尺度方程 $S(\tilde{\boldsymbol c}_i)\hat H'_j[r_{x,i},r_{y,i},1]^{\mathrm T}=\mathbf 0$ (9.6-4)，求得仅差全局尺度因子 $\zeta_j$ 的像素单应矩阵 $\hat H'_j=[\boldsymbol h'_{1,j}\ \boldsymbol h'_{2,j}\ \boldsymbol h'_{3,j}]$，满足 $\zeta_j\hat H'_j=\Omega[\boldsymbol r_{1,j}\ \boldsymbol r_{2,j}\ \boldsymbol o^c_{o,j}]$；
2. **阶段二（利用旋转矩阵正交等长约束求解 $B=\Omega^{-\mathrm T}\Omega^{-1}$）**：由 $\boldsymbol r_1=\zeta\Omega^{-1}\boldsymbol h'_1,\ \boldsymbol r_2=\zeta\Omega^{-1}\boldsymbol h'_2$，施加正交性 $\boldsymbol r_1^{\mathrm T}\boldsymbol r_2=0$ 与等长性 $\boldsymbol r_1^{\mathrm T}\boldsymbol r_1=\boldsymbol r_2^{\mathrm T}\boldsymbol r_2=1$，消去 $\zeta^2$ 后得关于对称矩阵 $B=\Omega^{-\mathrm T}\Omega^{-1}$ 的两条线性约束（教材 (10.61)）：

$$\boxed{\ \boldsymbol h_1'^{\mathrm T} B\,\boldsymbol h'_2 = 0,\qquad
\boldsymbol h_1'^{\mathrm T} B\,\boldsymbol h'_1 = \boldsymbol h_2'^{\mathrm T} B\,\boldsymbol h'_2.\ } \tag{9.6-6}$$

零斜切假设下对称矩阵 $B$ 的显式结构为：

$$B = \Omega^{-\mathrm T}\Omega^{-1} = \begin{bmatrix}
\dfrac{1}{\alpha_x^2} & 0 & -\dfrac{X_0}{\alpha_x^2} \\[6pt]
0 & \dfrac{1}{\alpha_y^2} & -\dfrac{Y_0}{\alpha_y^2} \\[6pt]
-\dfrac{X_0}{\alpha_x^2} & -\dfrac{Y_0}{\alpha_y^2} & 1 + \dfrac{X_0^2}{\alpha_x^2} + \dfrac{Y_0^2}{\alpha_y^2}
\end{bmatrix}. \tag{9.6-8}$$

将 $B$ 的 $6$ 个独立对称元素拉直为向量 $\boldsymbol b=[b_{11},\ b_{12},\ b_{22},\ b_{13},\ b_{23},\ b_{33}]^{\mathrm T}\in\mathbb R^6$，汇总 $k$ 个姿态的 $2k$ 条线性方程组成 $A'\boldsymbol b=\mathbf 0$ (9.6-7)。当使用 **$k\ge 3$ 个互不平行倾斜姿态**（$2k\ge 6$ 条独立约束；纯平移不增加新约束）时，由 SVD 求得 $\boldsymbol b$（对应真实矩阵的缩放倍数 $\gamma B$），按闭式公式提取内参（已按原书代数校验修正排印错位）：

$$X_0 = -\frac{b_{13}}{b_{11}},\quad
Y_0 = -\frac{b_{23}}{b_{22}},\quad
\gamma = b_{33} - \frac{b_{13}^2}{b_{11}} - \frac{b_{23}^2}{b_{22}},\quad
\alpha_x = \sqrt{\frac{\gamma}{b_{11}}},\quad
\alpha_y = \sqrt{\frac{\gamma}{b_{22}}}. \tag{9.6-9}$$

3. **阶段三（还原归一化单应与外参）**：利用已求得的内参矩阵 $\Omega$ 计算 $H_j=\Omega^{-1}\hat H'_j$，再按 [§9.3](sec9-3.md) 定理 9.3.1–9.3.2 求出第 $j$ 幅图对应的位姿 $T^c_{o,j}$，最后由式 (9.6-3) 求出外参 $T^b_c$ 或 $T^e_c$。
:::

<a id="sec-9.6.4"></a>

## 9.6.4 工程实践：从概念线性解到张氏平面标定

教材 §10.5 末尾明确指出：上述纯线性三阶段法**只是概念性的**，因为在真实相机中同时存在像素测量噪声以及广角/标准镜头的**径向与切向畸变**，仅靠纯线性解法无法得到满意的标定精度（尤其是内参焦距与主点对噪声高度敏感）。

工程标准方案是以棋盘格、圆点阵等高精度标定靶标配合**张氏平面标定法（Z. Zhang, IEEE TPAMI, 2000）**：先以上述三阶段闭式线性解作为良好初值，随后构建纳入镜头畸变系数的非线性最小二乘重投影误差目标函数，利用 **Levenberg–Marquardt（LM）** 迭代联合优化全部内参、畸变参数与各帧外参，是完成后续一切单目位姿估计与视觉伺服不可或缺的前置步骤。

<a id="sec-9.6.5"></a>

## 9.6 小结与常见错误

1. **内参已知求外参**：直接 $\tilde{\boldsymbol s}_i=\Omega^{-1}\tilde{\boldsymbol c}_i$ 后套用共面 PnP 与式 (9.6-3)。
2. **三阶段线性标定逻辑**：像素单应 $H'=\Omega H$ → 正交等长两条方程定 $B=\Omega^{-\mathrm T}\Omega^{-1}$ → 回代求位姿与外参。
3. **多姿态不可简化为纯平移**：每个姿态只提供 $2$ 条方程，至少需要 **$k\ge 3$ 个不同倾斜姿态**方能定出 $B$（且不可仅作纯平移运动）。
4. **工程闭环步骤**：线性解仅作初值，实际标定须由张氏标定配合非线性畸变优化完成。

<a id="sec-9.6.check"></a>
<details>
<summary>检查理解：为什么标定板必须倾斜摆拍至少 3 个不同姿态，只拍一两张或只平移不行？</summary>

每个单应姿态通过 $\boldsymbol r_1\perp\boldsymbol r_2$ 与 $\|\boldsymbol r_1\|=\|\boldsymbol r_2\|$ 仅提供关于对称矩阵 $B$（含 $5$ 个独立比例自由度：$\alpha_x,\alpha_y,X_0,Y_0$ 与 $b_{12}$ 或整体缩放 $\gamma$）的 **$2$ 条**标量线性约束，因此至少需要 $k\ge 3$ 组姿态获得 $2k\ge 6$ 条方程才能解出唯一一维零空间。同时，若标定板仅在像面内平移而不改变旋转姿态，各幅图单应矩阵的前两列仅在平移或整体比例上有冗余关联，所列方程线性相关，同样无法唯一求解 $\Omega$。

</details>

**核心公式速查**：

| 条目 | 公式 | 易错点 |
|:--|:--|:--|
| 内参已知外参反解 | $T^b_c=T^b_o(T^c_o)^{-1},\quad T^e_c=T^e_o(T^c_o)^{-1}$ | 上下标不可写反（确保中间相机系消去） |
| 像素单应与正交约束 | $H'=\Omega H$；$\boldsymbol h_1'^{\mathrm T}B\boldsymbol h'_2=0$，$\boldsymbol h_1'^{\mathrm T}B\boldsymbol h'_1=\boldsymbol h_2'^{\mathrm T}B\boldsymbol h'_2$ | $B=\Omega^{-\mathrm T}\Omega^{-1}$ 为对称阵，$k\ge 3$ 非平行倾斜姿态 |
| 内参尺度 $\gamma$ 提取 | $\gamma = b_{33} - \dfrac{b_{13}^2}{b_{11}} - \dfrac{b_{23}^2}{b_{22}}$ | 勿漏除主点平方项（即非简单相加 $b_{13}+b_{23}+b_{33}$） |

::: think 本节的课堂幻灯片（源料对照）

本节正文已自足；下列课件页保留以备核对，**不构成正文的替代**（对应录播 105:50 前后）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 105:50 | [calib-plane.jpg](../assets/ch09/calib-plane.jpg) | 棋盘格标定板 | 正文 9.6.3–9.6.4 三阶段线性标定与张氏标定展开 |
:::
