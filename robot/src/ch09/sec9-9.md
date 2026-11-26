# 9.9 基于图像的视觉伺服（IBVS）

与 [§9.8](sec9-8.md) 的 PBVS 平行，基于图像的视觉伺服（IBVS）彻底跳过三维位姿反演，直接用图像特征偏差 $\boldsymbol e_s=\boldsymbol s_d-\boldsymbol s$ 构造闭环反馈。结构上只需将位置式的 $(\boldsymbol x,\ J_{A_d})$ 替换为 $(\boldsymbol e_s,\ J_L)$，但其物理特性、深度估计需求与三维相机运动轨迹却呈现出截然不同的风险特征——最典型的即**伪逆局部极小值**与 **Chaumette 相机后退**。

<a id="sec-9.9.1"></a>

## 9.9.1 图像特征误差定义与期望特征获取

IBVS 将控制误差直接定义在 $k$ 维归一化图像特征空间（教材 (10.80)）：

$$\boxed{\ \boldsymbol e_s = \boldsymbol s_d - \boldsymbol s \in \mathbb R^k.\ } \tag{9.9-1}$$

（文献亦常记 $\boldsymbol s_d$ 为 $\boldsymbol s^*$，取相反符号 $\boldsymbol e=\boldsymbol s-\boldsymbol s^*$ 时相应速度律反号，完全等价。）期望特征 $\boldsymbol s_d$ 可由透视模型从期望位姿提前计算，或在工业现场采用**示教拍摄（teach-by-showing）**：人工将机械臂引导至期望抓取位姿直接拍取一帧图像记录特征（无需物体几何模型也不受内/外参建模偏差影响）。为保证控制自由度完备，6 自由度机械手通常需取 $n\ge 4$ 个共面无三点共线点（或 $n\ge 6$ 个不共面点）；对 $m=4$ 的 SCARA 臂则取两点（$k=4$）或一条线段（$k=4$）即可。

<a id="sec-9.9.2"></a>

## 9.9.2 IBVS 重力补偿 PD 控制律与稳定性证明

假设目标相对基座静止（$\dot{\boldsymbol s}_d=\mathbf 0$）且相机系与末端系重合（$\boldsymbol v^c_c=\begin{bmatrix}R_c^{\mathrm T}&O\\O&R_c^{\mathrm T}\end{bmatrix}J(\boldsymbol q)\dot{\boldsymbol q}$），结合 $\dot{\boldsymbol s}=L_s(\boldsymbol s,\boldsymbol z_c)\boldsymbol v^c_c$ 得到图像误差微分映射（教材 (10.82)–(10.83)）：

$$\dot{\boldsymbol e}_s = -\dot{\boldsymbol s} = -J_L(\boldsymbol s,\ \boldsymbol z_c,\ \boldsymbol q)\,\dot{\boldsymbol q},\qquad
\boxed{\ J_L(\boldsymbol s,\ \boldsymbol z_c,\ \boldsymbol q) = L_s(\boldsymbol s,\ \boldsymbol z_c)\begin{bmatrix}R_c^{\mathrm T}&O\\O&R_c^{\mathrm T}\end{bmatrix}J(\boldsymbol q).\ } \tag{9.9-3}$$

其中 $J_L\in\mathbb R^{k\times n}$ 称为融合了机械臂几何雅可比与相互作用矩阵的**图像雅可比**。

::: thm 定理 9.9.1 · IBVS 重力补偿 PD 控制律与稳定性 {#thm-9.9.1}
在含正定粘滞阻尼 $F_{\mathrm v}\succ 0$ 的刚体动力学模型下，采用 IBVS 重力补偿 PD 控制律（教材 (10.84)）：

$$\boxed{\ \boldsymbol u = \boldsymbol g(\boldsymbol q) + J_L^{\mathrm T}(\boldsymbol s,\ \boldsymbol z_c,\ \boldsymbol q)\bigl(K_{P_s}\boldsymbol e_s - K_{D_s}J_L(\boldsymbol s,\ \boldsymbol z_c,\ \boldsymbol q)\dot{\boldsymbol q}\bigr),\ } \tag{9.9-4}$$

其中 $K_{P_s},\ K_{D_s}\in\mathbb R^{k\times k}$ 对称正定。若特征深度 $\boldsymbol z_c$ 精确已知且沿轨迹相互作用矩阵 $L_s$ 与几何雅可比 $J(\boldsymbol q)$ 均满秩，则平衡点 $(\boldsymbol e_s,\ \dot{\boldsymbol q})=(\mathbf 0,\ \mathbf 0)$ **局部渐近稳定**。
:::

::: proof 证明：Lyapunov + LaSalle 证明
取正定备选函数（教材 (10.81)）：
$$V(\dot{\boldsymbol q},\ \boldsymbol e_s) = \frac{1}{2}\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q} + \frac{1}{2}\boldsymbol e_s^{\mathrm T}K_{P_s}\boldsymbol e_s > 0.$$
沿系统轨迹求导，并应用 $\dot B-2C$ 反对称性消去哥氏力耦合项：
$$\dot V = \dot{\boldsymbol q}^{\mathrm T}(\boldsymbol u-\boldsymbol g-F_{\mathrm v}\dot{\boldsymbol q}) - \dot{\boldsymbol q}^{\mathrm T}J_L^{\mathrm T}K_{P_s}\boldsymbol e_s.$$
将控制律 (9.9-4) 代入精确消去比例项，仅余负半定耗散项（教材 (10.85)）：
$$\dot V = -\dot{\boldsymbol q}^{\mathrm T}F_{\mathrm v}\dot{\boldsymbol q} - \dot{\boldsymbol q}^{\ T}J_L^{\mathrm T}K_{D_s}J_L\dot{\boldsymbol q} \le 0.$$
令 $\dot V\equiv 0$ 得最大不变集上恒有 $\dot{\boldsymbol q}\equiv\mathbf 0\implies\ddot{\boldsymbol q}\equiv\mathbf 0$，代回闭环方程给出静态条件 $J_L^{\mathrm T}K_{P_s}\boldsymbol e_s=\mathbf 0$。当 $L_s$ 与 $J(\boldsymbol q)$ 满秩使得 $J_L$ 满行秩（$J_L^{\mathrm T}$ 列满秩）且 $K_{P_s}\succ 0$ 时，唯一解为 $\boldsymbol e_s=\mathbf 0$，由 LaSalle 原理即证局部渐近稳定。
:::

::: note 隐藏的先验门槛：单目深度 $\boldsymbol z_c$ 的近似估计
虽然 IBVS 省去了完整物体三维位姿估计，但相互作用矩阵 $L_s(\boldsymbol s,\boldsymbol z_c)$ 的平动前三列仍显含每个特征点的当前深度 $z_{c,i}$。单目相机无法直接测深，工程上常假设目标处于已知近似高度平面、在线采用深度观测器，或直接代入常值估计 $\hat z_c$（例如期望位姿深度 $z_d$）构成近似矩阵 $\tilde L_s=L_s(\boldsymbol s,\hat{\boldsymbol z}_c)$。IBVS 对适度深度估计误差具备一定容忍度（只要 $L_s\tilde L_s^+$ 特征值实部仍正即可稳定收敛），但严格稳定性分析大为复杂且大深度误差将扭曲相机三维轨迹。
:::

<a id="sec-9.9.3"></a>

## 9.9.3 IBVS 速度分解控制与局部极小值

为解决「视觉慢、电机快」采样冲突，IBVS 同样采用内外环级联分离（内环带宽 $\ge 5$ 倍外环使 $\boldsymbol q\approx\boldsymbol q_r$）。图像式速度分解外环（教材 (10.87)）写为：

$$\boxed{\ \dot{\boldsymbol q}_r = J_L^{-1}(\boldsymbol s,\ \boldsymbol z_c,\ \boldsymbol q_r)\,K_s\,\boldsymbol e_s \quad\Longrightarrow\quad \dot{\boldsymbol e}_s + K_s\,\boldsymbol e_s = \mathbf 0.\ } \tag{9.9-7,9.9-8}$$

更稳健的双层解耦写法将视觉特征逆与机械臂逆运动学分离（教材 (10.89)–(10.90)）：

$$\boldsymbol v_c^{\,r} = L_s^+(\boldsymbol s,\ \hat{\boldsymbol z}_c)\,K_s\,(\boldsymbol s_d-\boldsymbol s) = -\lambda\,L_s^+(\boldsymbol s,\ \hat{\boldsymbol z}_c)(\boldsymbol s-\boldsymbol s^*),\qquad
\dot{\boldsymbol q}_r = J^{-1}(\boldsymbol q)\begin{bmatrix}R_c&O\\O&R_c\end{bmatrix}\boldsymbol v_c^{\,r}.$$

当特征参数多于操作自由度（$k>m$）而采用左伪逆 $L_s^+=(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}$ 时，构造 Lyapunov 函数 $V(\boldsymbol e_s)=\frac12\boldsymbol e_s^{\mathrm T}K_s\boldsymbol e_s$ 求导得：

$$\dot V = -\boldsymbol e_s^{\mathrm T}K_s L_s(L_s^{\mathrm T}L_s)^{-1}L_s^{\mathrm T}K_s\boldsymbol e_s \le 0.$$

由于 $L_s^{\mathrm T}$ 存在非平凡零空间 $\mathcal N(L_s^{\mathrm T})$，当存在非零特征误差满足 $K_s\boldsymbol e_s\in\mathcal N(L_s^{\mathrm T})$ 时，$\boldsymbol v_c^{\,r}=\mathbf 0$ 且 $\dot V=0$——控制器将**卡在非零残差的局部极小值处**，稳定性从渐近稳定降级为**仅李雅普诺夫稳定（有界但不一定收敛到零）**。

<a id="sec-9.9.4"></a>

## 9.9.4 特征直线轨迹与 Chaumette 相机退缩机制

在速度分解控制 (9.9-8) 中若取各向同性增益 $K_s=\lambda I_k$，各特征误差分量同步按 $e^{-\lambda t}$ 指数衰减，因此**所有图像特征点在像平面上严格沿直线段运动**（几乎不可能飞出像面边界）。

然而，像平面直线的几何代价却落在三维相机运动上——最著名的反直觉病态现象即为 **Chaumette 相机退缩（Camera Retreat）**：设想目标与相机仅需绕光轴 $z_c$ 相对旋转角 $\Delta\alpha$，对称两点距光轴物理半径为 $r$、初终深度均为 $z_0$（故像面初终半径均为 $\rho=r/z_0$）。纯绕光轴旋转本应让像点沿圆弧转动，而 IBVS 强迫像点沿连接初终点的**弦线**收缩，弦中点到像面中心距离缩至 $\rho_{\mathrm{mid}}=\rho\cos(\Delta\alpha/2)$。因刚体物理半径 $r$ 不变，像面收缩唯一等价于相机沿光轴反向远离目标，使中点时刻深度胀大至：

$$\boxed{\ z_{\mathrm{mid}} = \frac{r}{\rho_{\mathrm{mid}}} = \frac{z_0}{\cos(\Delta\alpha/2)}.\ }$$

当转角较小时相机轻微「先退后进」；**一旦期望转角 $\Delta\alpha\to\pi$**，$\cos(\Delta\alpha/2)\to 0$，所需中间退缩深度 $z_{\mathrm{mid}}\to\infty$，导致相机剧烈后退撞向机械极限或引发系统失稳。

<a id="sec-9.9.5"></a>

## 9.9 小结与常见错误

1. **与 PBVS 完整对偶**：IBVS 跳过位姿估计直接定义图像误差 $\boldsymbol e_s=\boldsymbol s_d-\boldsymbol s$，用 $(J_L,\ \boldsymbol e_s)$ 平行替换 $(J_{A_d},\ \boldsymbol x)$ 即可完成 PD 与速度分解设计。
2. **深度隐含依赖**：单目下仍需提供交互矩阵平动列中的深度估计 $\hat{\boldsymbol z}_c$（常用期望深度 $z_d$ 近似）。
3. **伪逆卡住与相机后退**：$k>m$ 伪逆仅保稳定非渐近稳定；$K_s=\lambda I$ 虽保证像面直线轨迹保视野，却会在大角度绕光轴旋转时引发严重 Chaumette 相机后退（$\Delta\alpha\to\pi$ 时失稳）。

<a id="sec-9.9.check"></a>
<details>
<summary>检查理解：图像式不需要物体几何，那么它凭什么知道「到位了」？</summary>

图像式把任务目标定义为「使当前观测特征重现期望示教图像特征 $\boldsymbol s_d$」。只要 $\boldsymbol e_s=\boldsymbol s_d-\boldsymbol s\to\mathbf 0$，相机即认为视觉对准完成；但其代价是不直接求解三维位姿，一方面需要足够多特征点避免单目多解歧义，另一方面若初值偏离过大可能落入局部极小或走上碰撞障碍的三维绕行路径。

</details>

**核心公式速查**：

| 条目 | 公式 | 易错点 |
|:--|:--|:--|
| IBVS 误差导数与图像雅可比 | $\dot{\boldsymbol e}_s=-J_L\dot{\boldsymbol q}$，$J_L=L_s\begin{bmatrix}R_c^{\mathrm T}&O\\O&R_c^{\mathrm T}\end{bmatrix}J(\boldsymbol q)$ | 单目需代深度估计 $\hat{\boldsymbol z}_c$ 构造 $\tilde L_s$ |
| IBVS 重力补偿 PD | $\boldsymbol u=\boldsymbol g+J_L^{\mathrm T}(K_{P_s}\boldsymbol e_s-K_{D_s}J_L\dot{\boldsymbol q})$ | 渐近稳定需 $L_s$ 与 $J$ 满秩且深度精确 |
| IBVS 速度分解外环与后退公式 | $\boldsymbol v_c^{\,r}=L_s^+K_s(\boldsymbol s_d-\boldsymbol s)$；$z_{\mathrm{mid}}=\dfrac{z_0}{\cos(\Delta\alpha/2)}$ | $k>m$ 伪逆可能卡在 $\mathcal N(L_s^{\mathrm T})$；$\Delta\alpha\to\pi$ 后退发散 |

::: think 本节的课堂幻灯片（源料对照）

本节正文已自足；下列课件页保留以备核对，**不构成正文的替代**（对应录播 125:00 前后）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 125:00 | [ibvs-resolved-velocity.jpg](../assets/ch09/ibvs-resolved-velocity.jpg) | 基于图像的速度分解 | 正文 9.9.3–9.9.4 完整推导与 Chaumette 退缩展开 |
:::
