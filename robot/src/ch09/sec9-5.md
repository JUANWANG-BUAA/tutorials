# 9.5 位姿估计（三）：数值算法解

[§9.3](sec9-3.md) 的平面 PnP 解析解依赖共面假设且在含噪或一般非共面情形下处理繁琐。本节利用 [§9.4](sec9-4.md) 建立的微分线性映射，在最小独立位姿参数化下构造连续时间误差调节跟踪算法（及其离散等价 Gauss–Newton 与 Levenberg–Marquardt 迭代），并分析超定伪逆下的稳定性降级现象。

<a id="sec-9.5.1"></a>

## 9.5.1 位姿最小参数化与位姿雅可比

为避免对冗余矩阵元素施加以正交单位约束，选取**最小独立坐标向量**参数化目标相对相机的位姿（教材 (10.31)）：

$$\boxed{\ \boldsymbol x^c_o = \begin{bmatrix}\boldsymbol o^c_o \\ \boldsymbol\varphi^c_o\end{bmatrix}\in\mathbb R^m.\ } \tag{9.5-1}$$

其中 $\boldsymbol o^c_o\in\mathbb R^3$ 为目标原点位置，$\boldsymbol\varphi^c_o$ 为欧拉角姿态向量；维数 $m$ 取决于任务自由度：一般三维刚体为 $m=6$；在 SCARA 机械手例 10.3 中（光轴 $z_c$ 与平面目标法向 $z_o$ 平行且同向），仅允许三维平移及绕 $z_c$ 轴单角旋转 $\alpha$，此时 $m=4$，$\boldsymbol x^c_o=[o_x,\ o_y,\ o_z,\ \alpha]^{\mathrm T}\in\mathbb R^4$。

求时间导数时，由于欧拉角变化率 $\dot{\boldsymbol\varphi}^c_o$ 与物理角速度之间存在转换阵 $T_A(\boldsymbol\varphi^c_o)$（见 [§3.6](../ch03/sec3-6.md)；教材 (10.32) 记作 $\dot{\boldsymbol\varphi}^c_o=T_A\boldsymbol\omega^c_{c,o}$，SCARA 单轴转角下 $T_A=1$），反解得旋量速度表达为 $\boldsymbol v^c_{c,o}=\begin{bmatrix}I_3&O\\O&T_A^{-1}(\boldsymbol\varphi^c_o)\end{bmatrix}\dot{\boldsymbol x}^c_o$（令 $T_{\mathrm{ang}}=T_A^{-1}$）。代回式 (9.4-1)(9.4-4) 即得**位姿雅可比** $J_{A_s}\in\mathbb R^{k\times m}$（教材 (10.35)，角色与第 3 章机械臂分析雅可比 $J_A$ 完全同构）：

$$\dot{\boldsymbol s} = J_{A_s}(\boldsymbol s,\ \boldsymbol x^c_o)\,\dot{\boldsymbol x}^c_o,\qquad
\boxed{\ J_{A_s}(\boldsymbol s,\ \boldsymbol x^c_o) = L_s(\boldsymbol s,\ \boldsymbol z_c)\,\Gamma(-\boldsymbol o^c_{c,o})\begin{bmatrix}I_3&O\\O&T_A^{-1}(\boldsymbol\varphi^c_o)\end{bmatrix}.\ } \tag{9.5-4}$$

<a id="sec-9.5.2"></a>

## 9.5.2 连续时间追踪律、奇异拆分与 GN / LM 迭代

设相机实测当前帧图像特征向量为 $\boldsymbol s$（在针对单帧做数值估计的迭代过程中 $\boldsymbol s$ 保持不变，故 $\dot{\boldsymbol s}=\mathbf 0$），当前估计位姿 $\tilde{\boldsymbol x}^c_o$ 经针孔投影模型正算出的预测特征向量为 $\tilde{\boldsymbol s}(\tilde{\boldsymbol x}^c_o)$。定义重投影图像误差：

$$\boldsymbol e_s = \boldsymbol s - \tilde{\boldsymbol s}(\tilde{\boldsymbol x}^c_o)\in\mathbb R^k. \tag{9.5-5}$$

对时间求导得误差动力学 $\dot{\boldsymbol e}_s = -J_{A_s}(\tilde{\boldsymbol s},\tilde{\boldsymbol x}^c_o)\,\dot{\tilde{\boldsymbol x}}^c_o$。当特征维数与位姿自由度相等（$k=m$）且 $J_{A_s}$ 非奇异时，选取追踪更新律（教材 (10.38)）：

$$\boxed{\ \dot{\tilde{\boldsymbol x}}^c_o = J_{A_s}^{-1}(\tilde{\boldsymbol s},\ \tilde{\boldsymbol x}^c_o)\,K_s\,\boldsymbol e_s\ }\qquad \bigl(K_s\succ 0\bigr), \tag{9.5-8}$$

代回立即消去雅可比，得到解耦的自治线性误差系统：

$$\dot{\boldsymbol e}_s + K_s\,\boldsymbol e_s = \mathbf 0. \tag{9.5-7}$$

当增益阵 $K_s$ 正定时，图像特征误差 $\boldsymbol e_s(t)$ 以 $K_s$ 特征值决定的速率**指数收敛于零**。只要初值 $\tilde{\boldsymbol x}^c_o(0)$ 位于真实位姿的吸引域内，投影残差归零即对应估计位姿收敛至真值（注意：因单目投影多解歧义，初值若落在虚假极小或另一解吸引域内，可能收敛至错误分支）。

::: method 数值位姿估计的两项工程实施要点
1. **奇异拆分两步计算（教材 (10.40)–(10.41)）**：为隔离欧拉角表示奇异（$T_A$）与特征几何奇异（$L_s$），工程常拆为两步执行：
$$\boldsymbol v^c_{c,o} = \Gamma(\tilde{\boldsymbol o}^c_{c,o})\,L_s^{-1}K_s\boldsymbol e_s,\qquad
\dot{\tilde{\boldsymbol x}}^c_o = \begin{bmatrix}I_3&O\\O&T_A(\tilde{\boldsymbol\varphi}^c_o)\end{bmatrix}\boldsymbol v^c_{c,o}.$$
2. **视觉跟踪与 Gauss–Newton / LM 等价性**：记目标函数 $E(\tilde{\boldsymbol x})=\frac12\|\boldsymbol s-\tilde{\boldsymbol s}(\tilde{\boldsymbol x})\|^2$，梯度 $\nabla E=-J_{A_s}^{\mathrm T}\boldsymbol e_s$，忽略残差二阶导后的 **Gauss–Newton (GN)** 步 $\Delta\tilde{\boldsymbol x}=(J_{A_s}^{\mathrm T}J_{A_s})^{-1}J_{A_s}^{\mathrm T}\boldsymbol e_s$ 恰等于上式取 $\Delta t\,K_s=I$ 时的前向欧拉步；若在 $J_{A_s}$ 病态或初值较远时加入阻尼因子 $\mu>0$，即得到更稳健的 **Levenberg–Marquardt (LM)** 格式 $\Delta\tilde{\boldsymbol x}=(J_{A_s}^{\mathrm T}J_{A_s}+\mu I_m)^{-1}J_{A_s}^{\mathrm T}\boldsymbol e_s$。
:::

<a id="sec-9.5.3"></a>

## 9.5.3 超定特征（$k>m$）下的伪逆降级

为避开 3 点奇异并抑制测量噪声而取 $k>m$（如 4 点 $k=8>6$）时，改用左伪逆 $L_s^+=(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}$ 构造迭代律（教材 (10.42)）：

$$\boldsymbol v^c_{c,o} = \Gamma(\tilde{\boldsymbol o}^c_{c,o})\,(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}K_s\,\boldsymbol e_s. \tag{9.5-9}$$

构造正定 Lyapunov 备选函数 $V(\boldsymbol e_s)=\frac12\boldsymbol e_s^{\mathrm T}K_s\boldsymbol e_s>0$（$K_s=K_s^{\mathrm T}\succ 0$），沿误差系统 $\dot{\boldsymbol e}_s=-L_s(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}K_s\boldsymbol e_s$ 求导：

$$\dot V(\boldsymbol e_s) = -\boldsymbol e_s^{\mathrm T}K_s L_s(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}K_s\boldsymbol e_s \le 0.$$

由于 $L_s^{\mathrm T}\in\mathbb R^{m\times k}$ 列多行少，其零空间 $\mathcal N(L_s^{\mathrm T})$ 维数至少为 $k-m>0$。只要出现非零残差满足 $K_s\boldsymbol e_s\in\mathcal N(L_s^{\mathrm T})$（即 $L_s^{\mathrm T}K_s\boldsymbol e_s=\mathbf 0$），便有 $\dot V=0$ 且更新步长归零——算法将**卡在非零残差的局部极小值处**。因此，改用伪逆后闭环稳定性从方阵可逆下的**指数渐近稳定**降级为仅能保证**李雅普诺夫意义下稳定（有界但非渐近稳定）**。

<a id="sec-9.5.4"></a>

## 9.5.4 单点零空间（例 10.2）对特征选取的约束

如 [§9.4.5](sec9-4.md#sec-9.4.5) 所证，单点特征（$2\times 6$）存在 4 维零空间（包含沿视线方向平移 $\boldsymbol v_1=[X,Y,1,0,0,0]^{\mathrm T}$ 与绕视线旋转 $\boldsymbol v_2=[0,0,0,X,Y,1]^{\mathrm T}$）。因此在数值求解位姿时，所选特征维数 $k$ 必须不低于操作空间自由度 $m$ 且特征分布应避开共线、共圆等退化构型，或直接采用带长度与角度信息的线段特征，以尽量消去零空间盲区。

<a id="sec-9.5.5"></a>

## 9.5.5 例 10.3 的 SCARA 视觉跟踪仿真结果

教材例 10.3 对 SCARA 机械手（$m=4$，平面目标）实施上述数值位姿估计跟踪：在控制周期 $T_s=0.04\,\mathrm s$ 内，取欧拉积分步长 $\Delta t=1\,\mathrm{ms}$、增益 $K_s=160I_4$，即使存在初始位置与偏角偏差，重投影特征误差 $\boldsymbol e_s$ 在约 $0.03\,\mathrm s$ 内即迅速指数收敛至零，准确还原出目标位置与姿态（具体四步手算与 400 步数值验算见[作业九 10.4](homework09.md)）。

<a id="sec-9.5.6"></a>

## 9.5.6 适用场景：视觉跟踪模式与两种奇异

教材 §10.3.3 强调了该数值算法的适用前提与局限：

1. **视觉跟踪（visual tracking）初值链**：算法的精度与收敛速度高度依赖初值 $\tilde{\boldsymbol x}^c_o(0)$ 靠近真值；因此在连续视频流视觉伺服中，以上一帧收敛后的位姿估计作为当前帧迭代初值，既缩减步数，又借运动连续性锁住正确解分支而避免跳入 PnP 多解歧义；
2. **区分两类奇异**：$J_{A_s}$ 的奇异源于欧拉角表示奇异（$T_A$）或交互矩阵奇异（$L_s$），后者取决于所选图像特征点/线构型，在规划特征集合时应重点回避退化几何。

<a id="sec-9.5.7"></a>

## 9.5 小结与常见错误

1. **最小参数化**：$m=6$（一般刚体）或 $m=4$（SCARA），须用 $T_A$ 连接欧拉角变化率与物理角速度。
2. **方阵可逆 vs 超定伪逆**：方阵非奇异时 $\dot{\boldsymbol e}_s+K_s\boldsymbol e_s=\mathbf 0$ 保证指数渐近收敛；$k>m$ 采用左伪逆时可能因 $K_s\boldsymbol e_s\in\mathcal N(L_s^{\mathrm T})$ 卡住，仅保证有界稳定。
3. **连续帧视觉跟踪**：用上一帧估计值作下一帧初值，保证收敛速度与单峰分支跟踪。

<a id="sec-9.5.check"></a>
<details>
<summary>检查理解：为什么数值迭代解出的位姿算「收敛了」，仍要小心多解？</summary>

迭代收敛的直接判据是重投影图像残差 $\boldsymbol e_s\to\mathbf 0$（预测像点与实测像点一致），而单目投影在深度不足或点数不够时本质上具有多解性（如 PnP 4 点/3 点歧义）。若初始位姿落在虚假解的吸引域内，算法也会以误差归零收敛到错误位姿。工程上靠特征充足且不共线，以及连续视频帧间利用上一帧位姿作初值的「视觉跟踪」模式保证不跳分支。

</details>

**核心公式速查**：

| 条目 | 公式 | 易错点 |
|:--|:--|:--|
| 位姿雅可比 | $J_{A_s}=L_s(\boldsymbol s,\boldsymbol z_c)\Gamma(-\boldsymbol o^c_{c,o})\begin{bmatrix}I_3&O\\O&T_A^{-1}(\boldsymbol\varphi^c_o)\end{bmatrix}$ | 注意逆向映射 $T_A^{-1}$ 把欧拉角导数变为物理角速度 |
| 可逆追踪更新律 | $\dot{\tilde{\boldsymbol x}}^c_o=J_{A_s}^{-1}K_s\boldsymbol e_s\implies\dot{\boldsymbol e}_s+K_s\boldsymbol e_s=\mathbf 0$ | 迭代时 $\boldsymbol s$ 固定，只对预测 $\tilde{\boldsymbol s}(\tilde{\boldsymbol x}^c_o)$ 求导 |
| 超定伪逆 / LM | $\Delta\tilde{\boldsymbol x}=(J_{A_s}^{\mathrm T}J_{A_s}+\mu I_m)^{-1}J_{A_s}^{\mathrm T}\boldsymbol e_s$ | $k>m$ 伪逆降级为稳定非渐近稳定，可能卡在 $\mathcal N(L_s^{\mathrm T})$ |

::: think 本节的课堂幻灯片（源料对照）

本节正文已自足；下列课件页保留以备核对，**不构成正文的替代**（对应录播 90:00 前后）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 90:00 | [algorithmic-solution.jpg](../assets/ch09/algorithmic-solution.jpg) | 数值迭代收敛到真实位姿 | 正文 9.5.2 迭代算法展开 |
:::
