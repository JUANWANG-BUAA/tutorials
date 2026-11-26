# 闭卷回忆卡 · 第七章：运动控制

这页不是摘要，而是一组**检索练习**。先只看问题，必须开口说或落笔写；「看着熟」不算会。
每张卡答完再展开核对。全章共 20 张卡（定义 4 / 结论 5 / 公式 7 / 陷阱 4），一轮约 35 分钟。

> **用法**：遮住答案，在空白纸上写；写完再展开对照。标记：**✓** 能完整写出 / **△** 有关键词
> 但缺条件 / **×** 完全想不起。下一轮只重做 △ 与 ×。

## A. 定义卡

### A1 · 分散控制

用一句话定义分散控制，并说出它把哪三类东西塞进了 $d$。

::: sol A1 核对
把机械手看成 $n$ 个独立单输入单输出系统，每个关节单独设计控制器，**忽略关节间耦合**。
塞进 $d$ 的三类：**位形依赖的惯量偏差** $\Delta B\ddot q_m$、**科氏/离心项** $C\dot q_m$、
**重力项** $\boldsymbol g$（库仑摩擦也在这里；黏性摩擦留在左边）。（[7.2.1](sec7-2.md#sec-7.2.1)）
:::

### A2 · 独立关节近似

写出分散控制的等效单轴方程，并说明 $\bar B$ 怎么取。

::: sol A2 核对
$K_r^{-1}\bar B K_r^{-1}\ddot q_m+F_m\dot q_m+d=\tau_m$，其中 $B=\bar B+\Delta B$，
$\bar B=\operatorname{diag}\{\bar b_i\}$ 取各关节惯量的**平均值**（常数对角阵）；
$d$ 收全部非对角项、$\Delta B$ 项、$C$ 项、重力项。（[7.2.1](sec7-2.md#sec-7.2.1)）
:::

### A3 · 重力补偿 PD

写出重力补偿 PD 的控制律与它的适用前提。

::: sol A3 核对
$\boldsymbol u=\boldsymbol g(\boldsymbol q)+K_P\tilde{\boldsymbol q}-K_D\dot{\boldsymbol q}$，
$\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$。本节的证明针对固定 $\boldsymbol q_d$，补偿用实测 $q$，还假设精确重力、理想力矩执行和相应有界性条件。控制律可用于时变参考，但不能沿用该点对点证明。（[7.3.3](sec7-3.md#sec-7.3.3)）
:::

### A4 · 逆动力学控制

写出逆动力学控制律，并说明它为什么叫「反馈线性化」。

::: sol A4 核对
$\boldsymbol u=B(\boldsymbol q)(\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}
+K_P\tilde{\boldsymbol q})+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})$，
$\boldsymbol n=C\dot{\boldsymbol q}+F\dot{\boldsymbol q}+\boldsymbol g$。
控制律里显式含**实测** $\boldsymbol q,\dot{\boldsymbol q}$，用反馈把非线性对象改造成
$\ddot{\boldsymbol q}=\boldsymbol y$ 的双积分器；大范围有效，区别于工作点附近的小偏差线性化。
（[7.3.4](sec7-3.md#sec-7.3.4)）
:::

## B. 结论卡

### B1 · 分散控制成立的两条结论

写出定理 7.2.A 的两条结论，并说明它们各自依赖哪条假设。

::: sol B1 核对
**结论一（近似式不显含连杆参数）**：电压—速度比例式不显含质量、惯量，但这些参数仍影响电流和近似误差。**结论二（逐轴关系）**：参数矩阵为对角阵时比例式逐轴分离。真正条件是各轴电阻压降远小于反电动势；大减速比、小电阻、小转矩仅为课件的定性工况描述，不能替代检查，也不证明整机闭环稳定。（[7.2.5](sec7-2.md#sec-7.2.5)、[@thm-7.2.A]）
:::

### B2 · 根轨迹三种情形

位置环开环传递函数为 $k_mK_Pk_{tp}(1+sT_p)/[s^2(1+sT_m)]$。$T_p<T_m$、$T_p>T_m$、$T_p\gg T_m$
分别对应什么稳定性/响应？

::: sol B2 核对
正参数理想模型下，$T_p<T_m$ 不稳定，$T_p>T_m$ 稳定，$T_p=T_m$ 为临界；$T_p\gg T_m$ 不单独保证更快。渐近线交点为 $(1/T_p-1/T_m)/2>-1/(2T_m)$，不是所有闭环极点的位置界。（[7.2.3](sec7-2.md#sec-7.2.3)）
:::

### B3 · 四种集中控制的分工

按「补什么」排列重力补偿 PD、逆动力学、鲁棒、自适应。

::: sol B3 核对
重力补偿 PD：只补 $\boldsymbol g$，点对点；逆动力学：全补 $B,C,\boldsymbol g$，模型精确时误差解耦；
鲁棒：全补 + 不确定项上界 $\rho$，保证有界误差；自适应：全补 + 参数在线估计 $\hat\pi$，
保证跟踪收敛但不保证参数辨识。（[7.3.3](sec7-3.md#sec-7.3.3)–[7.3.6](sec7-3.md#sec-7.3.6)）
:::

### B4 · 鲁棒控制的边界层

为什么加边界层？加了以后误差还能到零吗？

::: sol B4 核对
归一化切换项会使实际执行器产生抖振。边界层内改成 $(\rho/\varepsilon)z$ 以减轻高频切换；在正文给定界与实现假设下，一般只保证最终有界。误差界取决于增益、惯量及不确定性，不能直接写成 $\varepsilon$，也不是说最终误差必定非零。（[7.3.5](sec7-3.md#sec-7.3.5)）
:::

### B5 · 自适应控制保证什么

自适应控制能保证 $\tilde{\boldsymbol q}\to0$ 吗？能保证 $\hat{\boldsymbol\pi}\to\boldsymbol\pi$ 吗？

::: sol B5 核对
在正文的固定未知参数、精确模型结构、惯量一致正定及参考/闭环信号有界等条件下，能得到 $\sigma\to0$、$\tilde q\to0$、$\dot{\tilde q}\to0$；估计参数有界但未必到真值。真值收敛还需可辨识性与持续激励；噪声、负载突变和限幅不自动包含在该证明中。（[7.3.6](sec7-3.md#sec-7.3.6)）
:::

## C. 公式卡

### C1 · 驱动五式

默写五式并消元推出 $\boldsymbol\tau$ 与 $\boldsymbol v_c$ 的关系。

::: sol C1 核对
$q_m=K_rq$；$\tau_m=K_r^{-1}\tau=K_t i_a$；$v_a=R_ai_a+K_v\dot q_m$；$v_a=G_vv_c$。
消元：$\tau=K_rK_tR_a^{-1}(G_vv_c-K_vK_r\dot q)$。（[7.2.5](sec7-2.md#sec-7.2.5)）
:::

### C2 · 电流环

加电流环后 $\boldsymbol\tau$ 与 $\boldsymbol v_c$ 的关系是什么？为什么它能消掉反电动势项？

::: sol C2 核对
$\tau\approx K_rK_tG_iv_c$。在电流环带宽内且电压/电流不饱和时，内环近似实现 $i_a\approx G_iv_c$，并通过调节电压抑制反电动势的影响；它不是把反电动势物理上消掉。（[7.2.5](sec7-2.md#sec-7.2.5)）
:::

### C3 · 干扰抑制因子与收敛时间

写出 $X_R$ 与 $T_R$，并说明 $K_P$ 的取舍。

::: sol C3 核对
$X_R=K_Pk_{tp}$；$T_R=\max\{T_p,1/(\zeta\omega_n)\}$ 是相应近似下的时间尺度估计。增大增益会改变完整扰动频率响应、阻尼及噪声响应；不能只凭 $X_R$ 推出任意频率都改善，或推出实际闭环稳定。（[7.2.4](sec7-2.md#sec-7.2.4)）
:::

### C4 · 计算转矩前馈

写出 $d_d$ 与 $\boldsymbol v_{c,\rm ff}$，并说明它与逆动力学的区别。

::: sol C4 核对
$d_d=K_r^{-1}\Delta B(q_d)K_r^{-1}\ddot q_{md}+K_r^{-1}C(q_d,\dot q_d)K_r^{-1}\dot q_{md}
+K_r^{-1}g(q_d)$；$v_{c,\rm ff}=G_v^{-1}R_aK_t^{-1}d_d$。用**期望值**、可离线；逆动力学用**实测值**、在线。仅当放大器增益归一化为单位阵时才可省 $G_v^{-1}$。
（[7.2.7](sec7-2.md#sec-7.2.7)）
:::

### C5 · 重力补偿 PD 的稳定性

写出 $V$ 与 $\dot V$，指出哪一步用了 $\dot B-2C$ 的反对称性。

::: sol C5 核对
$V=\frac12\dot q^{\mathrm T}B\dot q+\frac12\tilde q^{\mathrm T}K_P\tilde q$；
$\dot V=\frac12\dot q^{\mathrm T}(\dot B-2C)\dot q-\dot q^{\mathrm T}F\dot q
+\dot q^{\mathrm T}(u-g-K_P\tilde q)$；第一项由反对称性为零，取 $u=g+K_P\tilde q-K_D\dot q$
得 $\dot V=-\dot q^{\mathrm T}(F+K_D)\dot q\le0$。这里的负号对应实际速度；若改用误差速度，才写 $+K_D\dot{\tilde q}$。渐近收敛还需在有界不变集中应用拉萨尔原理，不能仅凭 $\dot V\le0$ 判断。（[7.3.3](sec7-3.md#sec-7.3.3)）
:::

### C6 · 逆动力学的误差方程

把逆动力学律代入 $B\ddot q+n=u$，推出误差方程。

::: sol C6 核对
$u=B(\ddot q_d+K_D\dot{\tilde q}+K_P\tilde q)+n$，代入得
$\ddot q=\ddot q_d+K_D\dot{\tilde q}+K_P\tilde q$，即
$\ddot{\tilde q}+K_D\dot{\tilde q}+K_P\tilde q=0$；$B$ 正定保证可逆。（[7.3.4](sec7-3.md#sec-7.3.4)）
:::

### C7 · 操作空间两种实现

写出转置雅可比与逆雅可比两种控制律，各说一个优缺点。

::: sol C7 核对
转置：$F=K_P(x_d-x)$，$\tau=J_A^{\mathrm T}F$；**不求逆**、奇异附近也能算，但不保证最短路径。
逆雅可比：例如 $\dot q_{\rm cmd}=J_A^{-1}(\dot x_d+K\tilde x)$，需准确的关节速度伺服才能得到一阶任务误差式；它不是把误差直接折成力矩，也不自动保证最短路径。奇异/冗余需另行处理。（[7.4.3](sec7-4.md#sec-7.4.3)）
:::

## D. 陷阱卡

### D1 · 三种控制器串起来

位置、速度、加速度三套 PI 能不能串成三环？

::: sol D1 核对
不能把方框图里的每个环节都未经配合地各塞一套 PID。单环设计里其余通道保持单位增益或纯比例，针对的是所讨论的单一内环结构，并不禁止工业常用的串级控制（例如「位置比例 + 速度 PI」方案本身就是内外双环）。工业位置、速度、电流串级还须按驱动动态分配带宽并逐环整定。（[7.2.2](sec7-2.md#sec-7.2.2)）
:::

### D2 · 重力补偿 PD 做跟踪

为什么不能将重力补偿 PD 的固定目标稳定性证明直接用于轨迹跟踪？

::: sol D2 核对
该证明用了 $\dot q_d=0$。时变参考下 $\dot{\tilde q}=\dot q_d-\dot q$，位置误差能量求导多出 $\tilde q^{\mathrm T}K_P\dot q_d$，原耗散结论不能直接沿用。不是控制律「不能用」，而是要重新分析跟踪误差；逆动力学是本章给出的另一种设计。（[7.3.3](sec7-3.md#sec-7.3.3)）
:::

### D3 · 逆动力学写错自变量

把逆动力学律里的 $\boldsymbol q$ 写成 $\boldsymbol q_d$，会变成什么？

::: sol D3 核对
变成**计算转矩前馈**（7.2.7）：不再是反馈线性化，误差方程不再解耦，模型误差/跟踪误差大时对消失效。
（[7.3.4](sec7-3.md#sec-7.3.4)、[7.2.7](sec7-2.md#sec-7.2.7)）
:::

### D4 · 操作空间用几何雅可比

为什么操作空间模型必须用 $J_A$ 而不是 $J$？

::: sol D4 核对
位置部分两者相同；姿态部分 $J$ 给的是角速度 $\omega$，$J_A$ 给的是欧拉角导数 $\dot\phi$，
二者差一个矩阵（$\dot\phi\neq\omega$）。用错雅可比，姿态误差与 $\dot J_A\dot q$ 项都会错。
（[7.4.2](sec7-4.md#sec-7.4.2)、[3.6](../ch03/sec3-6.md)）
:::
