# 第九章总结 · 视觉伺服

视觉伺服把相机观测的二维像素反馈变为驱动机械手运动的实时调节误差。全章围绕「**图像提取 → 特征映射与位姿估计 → 标定支撑 → 闭环控制**」四环节建立完整的单目视觉伺服理论与实现框架。

## 一条主线

$$\text{图像阵列} \;\xrightarrow{\;\S9.2\;}\; \text{归一化特征}\ \boldsymbol s \;\xrightarrow{\;\S9.3\text{–}9.5\;}\; \text{位姿}\ T^c_o\ \text{或交互矩阵}\ L_s \;\xrightarrow{\;\S9.7\text{–}9.9\;}\; \text{控制律}\ \boldsymbol u\ \text{或}\ \dot{\boldsymbol q}_r$$

| 章节模块 | 核心方法与结论 | 适用前提与关键局限 |
|:--|:--|:--|
| **[9.1](sec9-1.md) 视觉与控制分类** | 区分 look-and-move 开环抓拍与实时闭环伺服；界定 PBVS / IBVS 与眼在手 / 眼到手变换链 | 被控量须经视觉算法二次加工；眼到手易遭连杆遮挡 |
| **[9.2](sec9-2.md) 投影与图像基础** | $\lambda\tilde{\boldsymbol s}=\Pi T^c_o\tilde{\boldsymbol r}^o$，$\tilde{\boldsymbol c}=\Omega\tilde{\boldsymbol s}$；阈值分割（双峰谷值）、Sobel/Laplacian 边缘、图像矩 | 了解层面；阈值法失效时改用边缘法 |
| **[9.3](sec9-3.md) PnP 解析解** | 共面四点降为单应 $H=[\boldsymbol r_1\ \boldsymbol r_2\ \boldsymbol o^c_o]$，左乘 $S(\tilde{\boldsymbol s}_i)$ 消 $\lambda_i$ 得 $\operatorname{rank}A=8$ 线性解；SVD 求最近 $SO(3)$ 旋转阵 | 须由深度 $z_{c,i}>0$ 定 $\zeta$ 符号（不可硬编码）；3 点 4 解，4 点共面及 $\ge 6$ 点不共面唯一 |
| **[9.4](sec9-4.md) 交互矩阵与零空间** | $\boldsymbol v^c_{c,o}=\boldsymbol v^c_o+\Gamma(\boldsymbol o^c_{c,o})\boldsymbol v^c_c$；$L_s=J_s\Gamma$ 将相机绝对速度映射至 $\dot{\boldsymbol s}$；单点 $L_p\in\mathbb R^{2\times 6}$ 与线段特征 | 平动前三列带 $1/z_c$，后三列旋转项纯几何；单点 $L_p$ 有 4 维零空间（含沿视线平移/自转） |
| **[9.5](sec9-5.md) 数值位姿估计** | 位姿雅可比 $J_{A_s}=L_s\Gamma(-\boldsymbol o)\operatorname{diag}(I_3,T_A^{-1})$；$\dot{\tilde{\boldsymbol x}}=J_{A_s}^{-1}K_s\boldsymbol e_s$（等价 GN / LM） | 可逆时 $\dot{\boldsymbol e}_s+K_s\boldsymbol e_s=\mathbf 0$ 指数收敛；$k>m$ 伪逆可能卡在 $\mathcal N(L_s^{\mathrm T})$ 降级为仅稳定 |
| **[9.6](sec9-6.md) 相机标定** | 内参已知用 PnP 求外参；内参未知用 $k\ge 3$ 不同倾斜姿态求 $B=\Omega^{-\mathrm T}\Omega^{-1}$ 闭式解 | 教材三阶段线性解仅具概念性；工程用张氏平面标定+畸变 LM 非线性优化 |
| **[9.7](sec9-7.md)–[9.10](sec9-10.md) 伺服比较与控制律** | PBVS 与 IBVS 的重力补偿 PD（LaSalle 证稳）及速度分解（内外环带宽 $\ge 5$ 倍分离） | PBVS 怕出视野且标定误差在反馈路径；IBVS 强鲁棒但存在相机后退（$\Delta\alpha\to\pi$ 失稳） |

## 两类伺服核心对比

| 评价维度 | 基于位置的视觉伺服（PBVS） | 基于图像的视觉伺服（IBVS） |
|:--|:--|:--|
| 反馈误差空间 | 三维操作空间 $\boldsymbol x=[\boldsymbol o^{d\mathrm T}_c,\ \boldsymbol\varphi^{d\mathrm T}_c]^{\mathrm T}$（源于 $T^d_c=T^d_o(T^c_o)^{-1}$） | 二维图像特征空间 $\boldsymbol e_s=\boldsymbol s_d-\boldsymbol s$ |
| 标定误差所在环路 | **反馈路径**（低抗扰 → 高度敏感，产生稳态偏差） | **前向路径**（高抗扰 → 鲁棒，示教下稳态无偏） |
| 单目物体几何先验 | **必须已知**（PnP 所需） | **原则上不需要**（示教拍图即可；仅需深度近似 $\hat z_c$） |
| 速度分解路径表现 | 位置等权对角 $K$ 下相机原点走**完美直线**（$0\%$ 后退） | 像面特征走直线，但三维相机发生**Chaumette 后退**（C 约 $300\%$，D 约 $50\%$） |

## 核心公式速览

1. **共面四点 PnP 与最近旋转阵投影**（[§9.3](sec9-3.md)）：

$$A_i(\boldsymbol s_i)\boldsymbol h=\mathbf 0,\quad
A_i(\boldsymbol s_i)=\begin{bmatrix}r_{x,i}S(\tilde{\boldsymbol s}_i) & r_{y,i}S(\tilde{\boldsymbol s}_i) & S(\tilde{\boldsymbol s}_i)\end{bmatrix},\quad
|\zeta|=\frac{1}{\|\boldsymbol h_1\|},\quad
R^c_o=U\operatorname{diag}\bigl(1,\ 1,\ \det(UV^{\mathrm T})\bigr)V^{\mathrm T}.$$

2. **单点特征相互作用矩阵与旋量转换阵**（[§9.4](sec9-4.md)）：

$$L_p(\boldsymbol s,z_c)=\begin{bmatrix}
-\dfrac{1}{z_c} & 0 & \dfrac{X}{z_c} & XY & -(1+X^2) & Y \\[6pt]
0 & -\dfrac{1}{z_c} & \dfrac{Y}{z_c} & 1+Y^2 & -XY & -X
\end{bmatrix},\qquad
\Gamma(\boldsymbol o)=\begin{bmatrix}-I_3 & S(\boldsymbol o)\\ O & -I_3\end{bmatrix}.$$

3. **两类速度分解外环与相机后退极限**（[§9.8](sec9-8.md)–[§9.9](sec9-9.md)）：

$$\text{PBVS：}\ \dot{\boldsymbol q}_r=J_{A_d}^{-1}K\boldsymbol x\implies\dot{\boldsymbol x}+K\boldsymbol x=\mathbf 0;\qquad
\text{IBVS：}\ \boldsymbol v_c^{\,r}=L_s^+(\boldsymbol s,\hat{\boldsymbol z}_c)K_s\boldsymbol e_s,\qquad
z_{\mathrm{mid}}=\frac{z_0}{\cos(\Delta\alpha/2)}.$$

勘误细节、教材印误对照与仿真边界补充见[勘误与补注](errata.md)；作业求解与验算见[作业九](homework09.md)与 `robot/tools/verify_homework09.py`。

全 章 完
