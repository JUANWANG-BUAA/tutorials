# 勘误与补注（第 9 章 视觉伺服）

本页汇总对照 Siciliano 等《Robotics: Modelling, Planning and Control》英文原版第 10 章（印刷页 407–461）及仿真核验中发现的排印勘误、符号口径与课程范围边界。

## 一、课程讲授与习题范围

- **不展开内容**：立体视觉（原书 §10.4）与混合/复合视觉伺服（原书 §10.10）不在本课程讲授与考核范围；图像处理（[§9.2](sec9-2.md)）与相机标定（[§9.6](sec9-6.md)）属于基础准备与概念了解层面；
- **课后作业**：原书习题 **10.4（必做）** 与 **10.8–10.11（任选其一，给出控制设计、仿真程序与结果）**，完整推演与交叉验算见[作业九](homework09.md)及 `robot/tools/verify_homework09.py`。

## 二、教材排印勘误与符号口径核正

### 1. 例 10.1 的 $R^o_c$ 数值排印（印刷页 422）

电子文本抽取工具易将例 10.1 中的旋转矩阵误转置为 $\begin{bmatrix}0.7071&0&-0.7071\\0&1&0\\0.7071&0&0.7071\end{bmatrix}$；核对英文原版印刷页，正确矩阵应为：

$$R^c_o=R_y(\pi/4)=\begin{bmatrix}0.7071&0&0.7071\\0&1&0\\-0.7071&0&0.7071\end{bmatrix}.$$

按此矩阵正向投影所得四个像点 $[0,0]^{\mathrm T},\ [0.1647,0]^{\mathrm T},\ [0.1647,0.2329]^{\mathrm T},\ [0,0.2]^{\mathrm T}$ 与原书印刷值吻合至 $4.3\times 10^{-5}$。

### 2. 单点相互作用矩阵 (10.27) 的正确结构（印刷页 426）

单点相互作用矩阵 $L_p(\boldsymbol s,z_c)$ 为

$$L_p(\boldsymbol s,z_c)=\begin{bmatrix}
-\dfrac{1}{z_c}&0&\dfrac{X}{z_c}&XY&-(1+X^2)&Y\\[6pt]
0&-\dfrac{1}{z_c}&\dfrac{Y}{z_c}&1+Y^2&-XY&-X
\end{bmatrix},$$

平动前三列已自带 $1/z_c$，矩阵外侧**不存在**额外的公共因子 $1/z_c$，且后三列旋转项完全不含深度 $z_c$。

<a id="err-3"></a>

### 3. 例 10.1 线性解「$\zeta H$」记号勘误（印刷页 422–423）

教材在例 10.1 将 SVD 求出的 $3\times 3$ 矩阵印作「$\zeta H$」，随后又写出「取 $\zeta=-1.5$ 得精确解」。对照关系式 $\boldsymbol r_1=\zeta\boldsymbol h_1,\ \boldsymbol r_2=\zeta\boldsymbol h_2,\ \boldsymbol o^c_o=\zeta\boldsymbol h_3$ 可知，该印刷矩阵实质上是尚未缩放的**一维零空间单位基向量列排 $[\boldsymbol h_1\ \boldsymbol h_2\ \boldsymbol h_3]$**，乘以 $\zeta=-1.5$ 方得真实单应矩阵 $H=[\boldsymbol r_1\ \boldsymbol r_2\ \boldsymbol o^c_o]$。此外，数值 SVD 返回向量的整体符号完全任意，编程时**不可硬编码 $\zeta$ 正负号**，必须依据「目标在相机前方（$o_z>0$ 或各点 $z_{c,i}>0$）」实时判定。

### 4. 式 (10.71) PBVS 误差导数的符号与旋转块口径（印刷页 446）

教材式 (10.71) 将 PBVS 误差导数记作 $\dot{\boldsymbol x}=-T_A^{-1}(\boldsymbol\varphi^d_c)\begin{bmatrix}R_d^{\mathrm T}&O\\O&R_d^{\mathrm T}\end{bmatrix}\boldsymbol v_c$。严格按 $\boldsymbol o^d_c=R_d^{\mathrm T}(\boldsymbol o_c-\boldsymbol o_d)$ 对基座系速度 $\boldsymbol v_c$ 直接求导并不产生外层负号；教材式 (10.71) 中的负号相当于反向定义了误差向量（仅相差一个常线性坐标变换，不影响闭环极点与稳定性）。本教程 [§9.8.2](sec9-8.md#sec-9.8.2) 沿用教材符号约定并保持控制律正负号自洽，[作业九](homework09.md)仿真采用几何自洽导数（两种实现收敛特性完全一致）。

### 5. §10.9 仿真算例中的 SCARA 连杆臂长自洽补充

教材 §10.9 给出 SCARA 仿真初/终相机位姿 $[1,1,0.5]^{\mathrm T}\,\mathrm m$ 与 $[1.07071,1.12247,0.4]^{\mathrm T}\,\mathrm m$，其相对 $z_0$ 轴径向距离分别为 $1.414\,\mathrm m$ 与 $1.551\,\mathrm m$，而原书图 2.36 的标准 SCARA 臂长仅 $a_1=a_2=0.5\,\mathrm m$（最大可达半径 $1.0\,\mathrm m$，若直接沿用则两端均不可达）。由于原书 §10.9 与习题 7.3 均未写明仿真臂长，[作业九](homework09.md)与 `verify_homework09.py` 选用 $a_1=a_2=1.0\,\mathrm m$ 使位姿落在工作空间内，该设定不改变 PBVS 走直线（后退 $0\%$）与 IBVS 相机后退（方案 D 实测 $47.8\%$、教材约 $50\%$）的所有定性结论。

### 6. 张氏平面标定的文献出处（[§9.6.4](sec9-6.md#sec-9.6.4)）

平面棋盘格非线性标定方法出自 Z. Zhang, *A Flexible New Technique for Camera Calibration*, IEEE Transactions on Pattern Analysis and Machine Intelligence (TPAMI), Vol. 22, No. 11, pp. 1330–1334, 2000（本教程一律以正式发表年份 2000 年为准）。

## 三、课程口述转写常见错词订正

| 转写常见误字 | 正确专业术语 |
|:--|:--|
| 视觉似乎 / 视觉思路 / 四股 | 视觉伺服 |
| 奇思变化针 / 奇思变化证 | 齐次变换矩阵 |
| 亚克比 / 亚盖 / 投降亚盖 | 雅可比 / 图像雅可比 |
| 交互矩阵阵 / 体重矩 | 相互作用矩阵 / 图像矩 |
| 钢琴 / 完全加大振 | 刚体 / 惯性张量 |
| 沟位直 / 沟位治 | 构型 / 位形 |
