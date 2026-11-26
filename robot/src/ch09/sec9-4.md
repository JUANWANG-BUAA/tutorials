# 9.4 位姿估计（二）：图像雅可比与相互作用矩阵

静态 PnP 方程在非共面或含噪情况下非线性程度高，且迭代求解位姿或直接在图像平面构造控制律都需要一阶速度关系。本节将透视投影方程对时间求导，确立**相对速度**映射到特征变化率的**图像雅可比 $J_s$**，进而分解出以**相机绝对运动**为输入的**相互作用矩阵 $L_s$**，逐行推导单点与线段相互作用矩阵，并揭示单目视觉 4 维零空间的深度盲区本质。

<a id="sec-9.4.1"></a>

## 9.4.1 从静态位姿到微分映射：图像雅可比

设目标相对相机的线速度与角速度均表达在当前相机系 $\{c\}$ 中，构成 6 维**相对旋量速度**（教材 (10.16)）：

$$\boldsymbol v^c_{c,o}=\begin{bmatrix}\dot{\boldsymbol o}^c_{c,o}\\[2pt] R_c^{\mathrm T}(\boldsymbol\omega^o-\boldsymbol\omega^c)\end{bmatrix}\in\mathbb R^6,$$

其中 $\boldsymbol o^c_{c,o}=R_c^{\mathrm T}(\boldsymbol o_o-\boldsymbol o_c)$ 为目标原点在相机系下的位置，$\boldsymbol\omega^o,\boldsymbol\omega^c$ 分别为目标与相机在基座系中的角速度。对 $k$ 维图像特征向量 $\boldsymbol s\in\mathbb R^k$ 求时间导数，其与相对旋量速度严格满足线性映射（教材 (10.17)）：

$$\boxed{\ \dot{\boldsymbol s}=J_s(\boldsymbol s,\ T^c_o)\,\boldsymbol v^c_{c,o}\ }\qquad \bigl(J_s\in\mathbb R^{k\times 6}\bigr). \tag{9.4-1}$$

其中 $J_s$ 称为**图像雅可比（image Jacobian）**。需注意 $J_s$ 关于速度 $\boldsymbol v^c_{c,o}$ 线性，但其矩阵元素显式依赖于当前特征 $\boldsymbol s$ 与位姿 $T^c_o$（并非恒常阵）。

<a id="sec-9.4.2"></a>

## 9.4.2 图像雅可比与相互作用矩阵的严格转换

实际机器人在大多数作业中面对的是固定目标，而由控制器直接驱动相机运动；将目标运动与相机运动拆分，引入在当前相机系表达的两个**绝对旋量速度**：

$$\boldsymbol v^c_c=\begin{bmatrix}R_c^{\mathrm T}\dot{\boldsymbol o}_c\\[2pt] R_c^{\mathrm T}\boldsymbol\omega^c\end{bmatrix},\qquad
\boldsymbol v^c_o=\begin{bmatrix}R_c^{\mathrm T}\dot{\boldsymbol o}_o\\[2pt] R_c^{\mathrm T}\boldsymbol\omega^o\end{bmatrix}.$$

对 $\boldsymbol o^c_{c,o}=R_c^{\mathrm T}(\boldsymbol o_o-\boldsymbol o_c)$ 求时间导数，代入旋转矩阵导数 $\dot R_c=R_c S(R_c^{\mathrm T}\boldsymbol\omega^c)\implies \dot R_c^{\mathrm T}=-S(R_c^{\mathrm T}\boldsymbol\omega^c)R_c^{\mathrm T}$ 得：

$$\dot{\boldsymbol o}^c_{c,o} = R_c^{\mathrm T}\dot{\boldsymbol o}_o - R_c^{\mathrm T}\dot{\boldsymbol o}_c - S(R_c^{\mathrm T}\boldsymbol\omega^c)R_c^{\mathrm T}(\boldsymbol o_o-\boldsymbol o_c)
= R_c^{\mathrm T}\dot{\boldsymbol o}_o - R_c^{\mathrm T}\dot{\boldsymbol o}_c + S(\boldsymbol o^c_{c,o})R_c^{\mathrm T}\boldsymbol\omega^c.$$

联合角速度差 $R_c^{\mathrm T}(\boldsymbol\omega^o-\boldsymbol\omega^c)$，得到严格的速度合成关系（教材 (10.18)）：

$$\boldsymbol v^c_{c,o} = \boldsymbol v^c_o + \Gamma(\boldsymbol o^c_{c,o})\,\boldsymbol v^c_c,\qquad
\Gamma(\boldsymbol o) = \begin{bmatrix}-I_3 & S(\boldsymbol o)\\ O & -I_3\end{bmatrix}\in\mathbb R^{6\times 6}. \tag{9.4-2}$$

直接分块矩阵乘法可验证 $\Gamma(\boldsymbol o)$ 处处可逆，且其逆阵为 $\Gamma(\boldsymbol o)^{-1}=\begin{bmatrix}-I_3 & -S(\boldsymbol o)\\ O & -I_3\end{bmatrix}=\Gamma(-\boldsymbol o)$。（注意 $3\times 3$ 反对称矩阵 $S(\boldsymbol o)$ 本身奇异不可逆，不可误写为 $S^{-1}$。）

::: def 定义 9.4.1 · 相互作用矩阵 {#def-9.4.1}
将式 (9.4-2) 代入式 (9.4-1) 得 $\dot{\boldsymbol s} = J_s\boldsymbol v^c_o + L_s\boldsymbol v^c_c$，其中**相互作用矩阵（interaction matrix）** $L_s\in\mathbb R^{k\times 6}$ 定义为：

$$\boxed{\ L_s = J_s(\boldsymbol s,\ T^c_o)\,\Gamma(\boldsymbol o^c_{c,o})\ \iff\ J_s(\boldsymbol s,\ T^c_o) = L_s\,\Gamma(-\boldsymbol o^c_{c,o}).\ } \tag{9.4-3,9.4-4}$$

当目标在基座系中**静止不动**（$\boldsymbol v^c_o=\mathbf 0$）时，退化为：

$$\dot{\boldsymbol s} = L_s\,\boldsymbol v^c_c.$$
:::

::: note $J_s$ 与 $L_s$ 的本质区别
- **输入对象不同**：$J_s$ 的输入是**目标相对相机的运动** $\boldsymbol v^c_{c,o}$；$L_s$ 的输入是**相机自身在相机系的运动** $\boldsymbol v^c_c$（前提是目标固定）；
- **代数关系**：二者通过处处可逆的伴随变换阵 $\Gamma(\pm\boldsymbol o^c_{c,o})$ 相互转换，矩阵秩完全相等。后续视觉控制直接驱动相机，因此控制律普遍基于 $L_s$ 写出；且单点 $L_s$ 仅显含当前图像坐标 $(X,Y)$ 与深度 $z_c$，闭式形式极其简洁。
:::

<a id="sec-9.4.3"></a>

## 9.4.3 单点特征相互作用矩阵的逐行推导

::: thm 定理 9.4.2 · 单点特征相互作用矩阵公式 {#thm-9.4.2}
设固定空间点 $P$ 在相机系下的坐标为 $\boldsymbol r^c=[x_c,\ y_c,\ z_c]^{\mathrm T}$（$z_c>0$），归一化图像特征为 $\boldsymbol s=[X,\ Y]^{\mathrm T}=[x_c/z_c,\ y_c/z_c]^{\mathrm T}$。当相机以相机系旋量速度 $\boldsymbol v^c_c=[v_x,v_y,v_z,\omega_x,\omega_y,\omega_z]^{\mathrm T}$ 运动时，$\dot{\boldsymbol s}=L_p(\boldsymbol s,z_c)\,\boldsymbol v^c_c$，其中：

$$\boxed{\ L_p(\boldsymbol s,z_c) = \begin{bmatrix}
-\dfrac{1}{z_c} & 0 & \dfrac{X}{z_c} & XY & -(1+X^2) & Y \\[8pt]
0 & -\dfrac{1}{z_c} & \dfrac{Y}{z_c} & 1+Y^2 & -XY & -X
\end{bmatrix} \in \mathbb R^{2\times 6}.\ } \tag{9.4-7}$$
:::

::: proof 证明：链式法则三步展开
1. **投影雅可比 $\dfrac{\partial\boldsymbol s}{\partial\boldsymbol r^c}$**：由 $X=x_c/z_c,\ Y=y_c/z_c$ 求偏导，得（教材 (10.25)）：
$$\frac{\partial\boldsymbol s}{\partial\boldsymbol r^c} = \frac{1}{z_c}\begin{bmatrix}1 & 0 & -X\\ 0 & 1 & -Y\end{bmatrix}. \tag{9.4-5}$$
2. **固定点在相机系中的速度 $\dot{\boldsymbol r}^c$**：目标点基座坐标 $\boldsymbol p$ 为常向量（$\dot{\boldsymbol p}=\mathbf 0$），其在相机系坐标为 $\boldsymbol r^c = R_c^{\mathrm T}(\boldsymbol p-\boldsymbol o_c)$。对时间求导并令 $\boldsymbol v_c^{\mathrm{lin}}=R_c^{\mathrm T}\dot{\boldsymbol o}_c,\ \boldsymbol\omega_c^c=R_c^{\mathrm T}\boldsymbol\omega^c$：
$$\dot{\boldsymbol r}^c = -R_c^{\mathrm T}\dot{\boldsymbol o}_c - S(\boldsymbol\omega_c^c)\boldsymbol r^c = -\boldsymbol v_c^{\mathrm{lin}} + S(\boldsymbol r^c)\boldsymbol\omega_c^c = \begin{bmatrix}-I_3 & S(\boldsymbol r^c)\end{bmatrix}\boldsymbol v^c_c. \tag{9.4-6}$$
3. **两阵相乘并消元**：计算 $\dot{\boldsymbol s}=\frac{\partial\boldsymbol s}{\partial\boldsymbol r^c}\begin{bmatrix}-I_3 & S(\boldsymbol r^c)\end{bmatrix}\boldsymbol v^c_c$：
   - 第一行平动块为 $\frac{1}{z_c}[1,0,-X](-I_3)=\begin{bmatrix}-1/z_c & 0 & X/z_c\end{bmatrix}$；转动块为 $\frac{1}{z_c}[1,0,-X]\begin{bmatrix}0&-z_c&y_c\\z_c&0&-x_c\\-y_c&x_c&0\end{bmatrix}=\frac{1}{z_c}[Xy_c,\ -z_c-Xx_c,\ y_c]=[XY,\ -(1+X^2),\ Y]$；
   - 第二行平动块为 $\frac{1}{z_c}[0,1,-Y](-I_3)=\begin{bmatrix}0 & -1/z_c & Y/z_c\end{bmatrix}$；转动块为 $\frac{1}{z_c}[z_c+Yy_c,\ -Yx_c,\ -x_c]=[1+Y^2,\ -XY,\ -X]$。

合并两行即得式 (9.4-7)。
:::

::: note 符号与结构自检（避免三处常见错写）
1. **矩阵外无公共因子 $1/z_c$**：$-1/z_c$ 与 $X/z_c$ 已在平动前三列内，切勿在矩阵外再乘一次 $1/z_c$；
2. **旋转后三列完全不含深度 $z_c$**：只有相机平移列带 $1/z_c$（目标越远像点位移越小），而绕光心纯旋转导致的视场角变化与深度无关；
3. **第三列为正号 $+X/z_c,\ +Y/z_c$**：源于 $-I_3$ 与 $-X,-Y$ 负负得正；直观对应当相机沿 $+z_c$ 前进接近物体（$v_z>0$）时，第一象限特征点（$X>0,Y>0$）向画面外围径向扩张（$\dot X>0,\dot Y>0$）。
:::

<a id="sec-9.4.4"></a>

## 9.4.4 多点堆叠与线段特征相互作用矩阵

单个点仅提供 $2$ 条方程而相机运动有 $6$ 个自由度，实际系统需组合多项特征：

1. **多点特征**：取 $n$ 个特征点 $\boldsymbol s=[\boldsymbol s_1^{\mathrm T},\dots,\boldsymbol s_n^{\mathrm T}]^{\mathrm T}\in\mathbb R^{2n}$，对应深度向量 $\boldsymbol z_c=[z_{c,1},\dots,z_{c,n}]^{\mathrm T}$，直接按行纵向堆叠：

$$L_s(\boldsymbol s,\ \boldsymbol z_c)=\begin{bmatrix}L_{p,1}(\boldsymbol s_1,z_{c,1})\\ \vdots \\ L_{p,n}(\boldsymbol s_n,z_{c,n})\end{bmatrix}\in\mathbb R^{2n\times 6}. \tag{9.4-8}$$

2. **线段特征（4 维）**：以目标两点在归一化平面的投影 $\boldsymbol s_1=[X_1,Y_1]^{\mathrm T},\ \boldsymbol s_2=[X_2,Y_2]^{\mathrm T}$（记 $\Delta X=X_2-X_1,\ \Delta Y=Y_2-Y_1$）构造中点、长度与倾角向量（教材 (10.28)）：

$$\boxed{\ \boldsymbol s = \begin{bmatrix}\bar x\\ \bar y\\ L\\ \alpha\end{bmatrix}
= \begin{bmatrix}\dfrac{X_1+X_2}{2}\\[6pt]\dfrac{Y_1+Y_2}{2}\\[6pt]\sqrt{\Delta X^2+\Delta Y^2}\\[4pt]\operatorname{Atan2}(\Delta Y,\ \Delta X)\end{bmatrix}.\ } \tag{9.4-9}$$

由链式法则得 $4\times 6$ 线段相互作用矩阵 $L_s=\dfrac{\partial\boldsymbol s}{\partial\boldsymbol s_1}L_{p,1}+\dfrac{\partial\boldsymbol s}{\partial\boldsymbol s_2}L_{p,2}$，偏导分块为：

$$\frac{\partial\boldsymbol s}{\partial\boldsymbol s_1}=\begin{bmatrix}1/2&0\\0&1/2\\-\Delta X/L&-\Delta Y/L\\\Delta Y/L^2&-\Delta X/L^2\end{bmatrix},\qquad
\frac{\partial\boldsymbol s}{\partial\boldsymbol s_2}=\begin{bmatrix}1/2&0\\0&1/2\\\Delta X/L&\Delta Y/L\\-\Delta Y/L^2&\Delta X/L^2\end{bmatrix}.$$

线段特征额外提供尺度 $L$（对深度敏感）与角度 $\alpha$（对绕光轴旋转敏感）两条直观约束，是 SCARA（$m=4$）视觉伺服习题的核心特征。

<a id="sec-9.4.5"></a>

## 9.4.5 单点零空间（教材例 10.2）与超定最小二乘

单点相互作用矩阵 $L_p\in\mathbb R^{2\times 6}$ 由前两列 $-I_2/z_c$ 可见恒有 $\operatorname{rank}L_p=2$，故其**右零空间维数为 $6-2=4$**。教材例 10.2 给出其中两个最直观的正交相机运动方向（另有 2 个横向平移与俯仰/偏航角速度互相抵消的耦合方向共同张成 $4$ 维零空间）：

$$\boldsymbol v_1=\begin{bmatrix}X&Y&1&0&0&0\end{bmatrix}^{\mathrm T}\quad\text{（沿视线射线径向平移）},\qquad
\boldsymbol v_2=\begin{bmatrix}0&0&0&X&Y&1\end{bmatrix}^{\mathrm T}\quad\text{（绕视线射线轴自转）}.$$

直接代入式 (9.4-7) 验算即可得 $L_p\boldsymbol v_1=\mathbf 0$ 与 $L_p\boldsymbol v_2=\mathbf 0$：相机沿目标点视线推进或绕该视线自转时，图像平面上的单点投影纹丝不动。这从微分层面解释了单目视觉「至少需多个不共线特征点（工程常取 $n\ge 4$）消去零空间歧义并抑制噪声」的原因。

当特征数 $k>6$（超定方程）时，需改用左伪逆求最小二乘速度解（教材 (10.30)）：

$$\boldsymbol v^c_{c,o} = \Gamma(\boldsymbol o^c_{c,o})\,(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}\,\dot{\boldsymbol s}.$$

但同时由于 $\dim\mathcal N(L_s^{\mathrm T})=k-\operatorname{rank}L_s>0$，转置零空间非空将为后续迭代与 IBVS 控制律埋下「局部极小值卡住」的隐患。

<a id="sec-9.4.6"></a>

## 9.4 小结与常见错误

1. **概念区分**：$J_s$ 映射目标相对相机速度 $\boldsymbol v^c_{c,o}$，$L_s=J_s\Gamma(\boldsymbol o^c_{c,o})$ 在目标固定时映射相机速度 $\boldsymbol v^c_c$；$\Gamma(\boldsymbol o)=\begin{bmatrix}-I_3&S(\boldsymbol o)\\O&-I_3\end{bmatrix}$ 且 $\Gamma(\boldsymbol o)^{-1}=\Gamma(-\boldsymbol o)$。
2. **单点 $L_p$ 结构**：$2\times 6$ 矩阵中仅前三列平移项含 $1/z_c$，后三列旋转项只与 $(X,Y)$ 有关；第三列为 $+X/z_c,+Y/z_c$。
3. **零空间本质**：单点矩阵秩 2 零空间 4 维（含沿视线平移与绕视线自转），多点特征消除运动盲区但超过自由度数后转置零空间可能诱发局部极小。

<a id="sec-9.4.check"></a>
<details>
<summary>检查理解：图像雅可比和相互作用矩阵到底差在哪？</summary>

两者只差输入旋量所代表的物理运动：$J_s$ 的输入是目标相对相机的相对速度 $\boldsymbol v^c_{c,o}$，$L_s$ 的输入是相机自身速度 $\boldsymbol v^c_c$（在目标固定假设下）。二者通过处处可逆阵 $\Gamma(\pm\boldsymbol o^c_{c,o})$ 严格等价变换，秩相同。控制相机时一般目标静止且我们直接控制相机运动，故控制律普遍写成 $L_s$，且其单点表达式不显含完整位姿 $T^c_o$、仅含图像坐标与深度 $z_c$。

</details>

**核心公式速查**：

| 条目 | 公式 | 易错点 |
|:--|:--|:--|
| 相对与绝对旋量转换 | $\Gamma(\boldsymbol o)=\begin{bmatrix}-I_3&S(\boldsymbol o)\\O&-I_3\end{bmatrix}$，$\Gamma^{-1}(\boldsymbol o)=\Gamma(-\boldsymbol o)$ | 上右块是 $S(\boldsymbol o)$，下左块是 $O$；不可写 $S^{-1}$ |
| 相互作用矩阵关系 | $\dot{\boldsymbol s}=J_s\boldsymbol v^c_o+L_s\boldsymbol v^c_c$，$L_s=J_s\Gamma(\boldsymbol o^c_{c,o})$ | 目标固定（$\boldsymbol v^c_o=\mathbf 0$）时 $\dot{\boldsymbol s}=L_s\boldsymbol v^c_c$ |
| 单点相互作用矩阵 | $L_p=\begin{bmatrix}-1/z_c&0&X/z_c&XY&-(1+X^2)&Y\\0&-1/z_c&Y/z_c&1+Y^2&-XY&-X\end{bmatrix}$ | 矩阵外**无**公因子 $1/z_c$；后三列不含 $z_c$ |

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导；下列课件页保留以备核对，**不构成正文的替代**（对应录播 78:40–81:40）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 78:40 | [interaction-matrix.jpg](../assets/ch09/interaction-matrix.jpg) | 特征速度与相对速度的线性关系 | 正文 9.4.2–9.4.3 完整推导 |
| 81:40 | [interaction-eq.jpg](../assets/ch09/interaction-eq.jpg) | 线段特征的相互作用矩阵 | 正文 9.4.4 展开 |
:::
