# 9.8 基于位置的视觉伺服（PBVS）

本节围绕位置式视觉伺服（PBVS）实现两套经典控制律：**重力补偿 PD 控制律**与**速度分解（Resolved-Velocity）控制律**，前者在力矩层级给出严格的 Lyapunov + LaSalle 渐近稳定性保证，后者通过**内外环级联分离**解决「视觉更新慢、电机控制快」的工程采样冲突，并使相机原点走出可预测的三维直线。

<a id="sec-9.8.1"></a>

## 9.8.1 操作空间位姿误差定义

设目标相对相机的期望位姿为 $T^d_o$（常量目标前提下，期望相机相对基座位姿 $T^d=T^c(T^d_c)^{-1}$ 亦为常阵且必须落在机械臂灵巧工作空间内，教材 (10.70)），实时视觉估计输出当前目标相对相机的齐次位姿 $T^c_o$。首先计算当前相机系 $\{c\}$ 相对期望相机系 $\{d\}$ 的位姿变换（教材 (10.68)）：

$$T^d_c = T^d_o\,(T^c_o)^{-1} = \begin{bmatrix}R^d_c & \boldsymbol o^d_c \\ \mathbf 0^{\mathrm T} & 1\end{bmatrix}.$$

从中抽取描述相对姿态的最小欧拉角向量 $\boldsymbol\varphi^d_c$，定义 PBVS 操作空间误差向量（教材 (10.69)）：

$$\boxed{\ \boldsymbol x = \begin{bmatrix}\boldsymbol o^d_c \\ \boldsymbol\varphi^d_c\end{bmatrix} \in \mathbb R^m.\ } \tag{9.8-1}$$

**关键注意**：误差 $\boldsymbol x$ **并不等于** 两个坐标向量的直接相减 $\boldsymbol x^d_o-\boldsymbol x^c_o$（特别是位置偏差已在期望系 $d$ 中经过方向对齐，且三维旋转群不能直接线性相减）。该定义与物体在基座系下的绝对位置无关，当 $\boldsymbol x\to\mathbf 0$ 时即实现 $T^c_o\to T^d_o$。

<a id="sec-9.8.2"></a>

## 9.8.2 重力补偿 PD 控制律与稳定性证明

假设末端系与相机系重合（$\boldsymbol v_c=J(\boldsymbol q)\dot{\boldsymbol q}$）且目标相对基座静止，按教材式 (10.71)–(10.73) 的符号约定，误差向量的时间微分映射记为：

$$\dot{\boldsymbol x} = -\begin{bmatrix}I_3&O\\O&T_A^{-1}(\boldsymbol\varphi^d_c)\end{bmatrix}
\begin{bmatrix}R_d^{\mathrm T}&O\\O&R_d^{\mathrm T}\end{bmatrix}\boldsymbol v_c
= -J_{A_d}(\boldsymbol q,\ \boldsymbol x)\,\dot{\boldsymbol q}, \tag{9.8-2}$$

其中 PBVS 操作空间分析雅可比为：

$$\boxed{\ J_{A_d}(\boldsymbol q,\ \boldsymbol x) = \begin{bmatrix}I_3&O\\O&T_A^{-1}(\boldsymbol\varphi^d_c)\end{bmatrix}\begin{bmatrix}R_d^{\mathrm T}&O\\O&R_d^{\mathrm T}\end{bmatrix}J(\boldsymbol q).\ } \tag{9.8-3}$$

> **几何求导口径辨析**：若按 $\boldsymbol o^d_c=R_d^{\mathrm T}(\boldsymbol o_c-\boldsymbol o_d)$ 对基座系速度 $\boldsymbol v_c$ 直接求导，结果不带外层负号；若改写于相机系速度 $\boldsymbol v_c^c$，位置块旋转为 $R_d^{\mathrm T}R_c=R^d_c$。教材 (10.71) 中的负号相当于将误差反定义为 $\boldsymbol e=-\boldsymbol x$。两种写法仅差常线性变换，闭环极点完全相同，只需在控制律与仿真（[§9.10](sec9-10.md)/[作业九](homework09.md)）中保持 $\dot{\boldsymbol x}=-J_{A_d}\dot{\boldsymbol q}$ 正负号自洽即可（详见[勘误](errata.md)）。

::: thm 定理 9.8.1 · PBVS 重力补偿 PD 控制律与渐近稳定性 {#thm-9.8.1}
考虑无外力、含正定粘滞阻尼 $F_{\mathrm v}\succ 0$ 的刚体机械臂动力学 $B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)=\boldsymbol u$。采用 PBVS 控制律（教材 (10.74)）：

$$\boxed{\ \boldsymbol u = \boldsymbol g(\boldsymbol q) + J_{A_d}^{\mathrm T}(\boldsymbol q,\ \boldsymbol x)\bigl(K_P\,\boldsymbol x - K_D\,J_{A_d}(\boldsymbol q,\ \boldsymbol x)\dot{\boldsymbol q}\bigr),\ } \tag{9.8-4}$$

其中 $K_P,\ K_D$ 为对称正定增益矩阵。若机械手始终处于 $J_{A_d}$ 满行秩的非奇异工作区，则平衡点 $(\boldsymbol x,\ \dot{\boldsymbol q})=(\mathbf 0,\ \mathbf 0)$ **局部渐近稳定**。
:::

::: proof 证明：Lyapunov 能量函数与 LaSalle 不变集原理
构造「动能 + 人工势能」正定备选函数：
$$V(\dot{\boldsymbol q},\ \boldsymbol x) = \frac{1}{2}\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q} + \frac{1}{2}\boldsymbol x^{\mathrm T}K_P\,\boldsymbol x > 0.$$
沿闭环轨迹对时间求导，并代入 $B\ddot{\boldsymbol q}=\boldsymbol u-C\dot{\boldsymbol q}-F_{\mathrm v}\dot{\boldsymbol q}-\boldsymbol g$ 与 $\dot{\boldsymbol x}=-J_{A_d}\dot{\boldsymbol q}$：
$$\dot V = \dot{\boldsymbol q}^{\mathrm T}(\boldsymbol u-\boldsymbol g-F_{\mathrm v}\dot{\boldsymbol q}) + \frac{1}{2}\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q} - \dot{\boldsymbol q}^{\mathrm T}J_{A_d}^{\mathrm T}K_P\boldsymbol x.$$
由第 6 章斜对称守恒性 $\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q}\equiv 0$，代入控制律 (9.8-4) 恰好精确抵消势能交叉项 $\dot{\boldsymbol q}^{\mathrm T}J_{A_d}^{\mathrm T}K_P\boldsymbol x$，剩余纯耗散项：
$$\dot V = -\dot{\boldsymbol q}^{\mathrm T}F_{\mathrm v}\dot{\boldsymbol q} - \dot{\boldsymbol q}^{\mathrm T}J_{A_d}^{\mathrm T}K_D J_{A_d}\dot{\boldsymbol q} \le 0.$$
（注：工程中将微分反馈简化为纯关节阻尼 $-K_D\dot{\boldsymbol q}$ 亦同理成立。）在 $\dot V\equiv 0$ 的最大不变集中必有 $\dot{\boldsymbol q}\equiv\mathbf 0\implies\ddot{\boldsymbol q}\equiv\mathbf 0$，代回闭环动力学得静态平衡方程 $J_{A_d}^{\mathrm T}K_P\boldsymbol x=\mathbf 0$。因 $J_{A_d}$ 满行秩（$J_{A_d}^{\mathrm T}$ 列满秩）且 $K_P\succ 0$，唯一解为 $\boldsymbol x=\mathbf 0$，由 LaSalle 原理即证渐近稳定。
:::

**PD 方案的动态缺点**：尽管平衡点渐近稳定，由于闭环惯性 $B(\boldsymbol q)$ 与雅可比 $J_{A_d}$ 均随构型耦合变化，即使增益 $K_P,K_D$ 固定，不同起始构型下的瞬态空间轨迹也会大幅改变。

<a id="sec-9.8.3"></a>

## 9.8.3 速度分解控制与内外环级联分离

将低频视觉信号直接闭环至电机力矩（式 (9.8-4)）在数字实现中面临严重的带宽冲突：**相机采图与 PnP 位姿计算周期较长**（受相机帧率制约，通常为 $25\sim 30\,\mathrm{Hz}$ 或秒级处理延时，比运动控制低至少一个数量级），而**电机底层关节/速度控制环刷新极快**（$50\,\mathrm{Hz}$ 至数百赫兹以上）。若强行在同一低频节拍下直接给电机发力矩指令，为避免采样滞后导致剧烈振荡，必须压低控制增益，使响应极慢、抗扰很差。

**速度分解控制（Resolved-Velocity Control）**利用级联内外环彻底化解上述矛盾（教材 (10.76)）：

1. **高速内环（运动控制）**：保留原有高带宽关节位置/速度控制器不作任何修改，实时跟踪参考关节位置 $\boldsymbol q_r(t)$，使其近似表现为一个理想运动学定位器 $\boldsymbol q(t)\approx\boldsymbol q_r(t)$；
2. **慢速外环（视觉伺服）**：仅依据当前操作空间误差生成参考关节速度并积分得 $\boldsymbol q_r(t)$（式 (9.8-5)–(9.8-6)）：

$$\boxed{\ \dot{\boldsymbol q}_r = J_{A_d}^{-1}(\boldsymbol q_r,\ \boldsymbol x)\,K\,\boldsymbol x\ }\qquad \bigl(K\succ 0\bigr). \tag{9.8-6}$$

在理想内环跟踪 $\dot{\boldsymbol q}\approx\dot{\boldsymbol q}_r$ 下代入式 (9.8-2)，精确消去非线性雅可比，得到解耦的**线性定常误差动力学**：

$$\boxed{\ \dot{\boldsymbol x} + K\,\boldsymbol x = \mathbf 0.\ } \tag{9.8-7}$$

**几何与瞬态优势**：只要 $K$ 正定，误差 $\boldsymbol x(t)=e^{-Kt}\boldsymbol x(0)$ 按选定增益严格**指数收敛**，瞬态时间常数完全脱离动力学耦合与初值构型。进一步，若取对角阵 $K$ 且三个位置通道增益相同（$K=\operatorname{diag}\{k_p,k_p,k_p,\dots\}$），三个位置误差以同一速率衰减，从而保证**相机原点在三维空间中沿初始点到期望点的完美直线段运动**——使工程人员能事先预测并校核路径遮挡或碰撞。

<a id="sec-9.8.4"></a>

## 9.8.4 内外环级联带宽原则（$\ge 5$ 倍分离准则）

与无人机或自动驾驶的多级串级控制结构相同，「视觉外环输出参考 $\boldsymbol q_r(t)\to$ 原生高带宽运动内环快速跟踪 $\boldsymbol q_r(t)$」得以等效退化为纯运动学模型 $\boldsymbol q\approx\boldsymbol q_r$ 的工程前提是：**内环控制带宽至少要比视觉外环带宽快 $5$ 倍以上**，且内环在一个视觉采样周期内应能基本完成参考增量调节，整个级联系统方能保持稳定与设计动态性能。

<a id="sec-9.8.5"></a>

## 9.8 小结与常见错误

1. **误差定义严格性**：PBVS 误差 $\boldsymbol x=[\boldsymbol o^{d\mathrm T}_c,\ \boldsymbol\varphi^{d\mathrm T}_c]^{\mathrm T}$ 由 $T^d_c=T^d_o(T^c_o)^{-1}$ 提取，**不可**用欧拉坐标直接相减；期望位姿还必须落在机械臂灵巧工作空间内。
2. **PD vs 速度分解**：PD+重力补偿在全动力学下渐近稳定但瞬态耦合；速度分解通过内外环分离将误差方程化简为定常线性 $\dot{\boldsymbol x}+K\boldsymbol x=\mathbf 0$，$K$ 对角等权时原点轨迹为完美直线。
3. **带宽分离硬条件**：内环须至少比视觉外环快 $5$ 倍以上；且两种方案均无法免除「目标移出视野断开反馈」的固有风险。

<a id="sec-9.8.check"></a>
<details>
<summary>检查理解：速度分解控制解决了什么，没解决什么？</summary>

**解决了**因视觉采样周期长迫使增益大幅下调、以及重力补偿 PD 随构型变化导致的动力学耦合问题：将快动态封在原有高速关节控制内环中（内环带宽 $\ge 5$ 倍外环），视觉外环仅按线性系统 $\dot{\boldsymbol x}+K\boldsymbol x=\mathbf 0$ 设定指数瞬态并可令相机走直线。
**没解决**位置式固有的两项短板：标定与 PnP 估计误差仍处在反馈回路上导致稳态偏移，且过渡途中特征点一旦走出相机视野仍会因丢失反馈而失稳。

</details>

**核心公式速查**：

| 条目 | 公式 | 易错点 |
|:--|:--|:--|
| PBVS 误差与导数 | $T^d_c=T^d_o(T^c_o)^{-1}$，$\dot{\boldsymbol x}=-J_{A_d}\dot{\boldsymbol q}$ | $\boldsymbol x$ 不可写成 $\boldsymbol x^d_o-\boldsymbol x^c_o$ |
| PBVS 重力补偿 PD | $\boldsymbol u=\boldsymbol g+J_{A_d}^{\mathrm T}(K_P\boldsymbol x-K_D J_{A_d}\dot{\boldsymbol q})$ | 与第 7 章同构，$J_{A_d}$ 须满行秩 |
| PBVS 速度分解外环 | $\dot{\boldsymbol q}_r=J_{A_d}^{-1}K\boldsymbol x\implies \dot{\boldsymbol x}+K\boldsymbol x=\mathbf 0$ | $K$ 位置同权对角时相机走直线；内环带宽 $\ge 5$ 倍外环 |

::: think 本节的课堂幻灯片（源料对照）

本节正文已自足；下列课件页保留以备核对，**不构成正文的替代**（对应录播 118:30–121:30）。

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 119:10 | [pbvs-block.jpg](../assets/ch09/pbvs-block.jpg) | PBVS 重力补偿 PD 框图 | 正文 9.8.2 结构说明展开 |
| 118:30 | [pbvs-pd.jpg](../assets/ch09/pbvs-pd.jpg) | 误差定义与雅可比读法 | 正文 9.8.1–9.8.2 展开 |
| 121:30 | [pbvs-resolved-velocity.jpg](../assets/ch09/pbvs-resolved-velocity.jpg) | 速度分解框图 | 正文 9.8.3–9.8.4 级联内外环展开 |
:::
