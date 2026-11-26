# 第七章总结 · 运动控制

> 本章建立自由空间机械臂运动控制（对应原书第 8 章）的完整方法体系：**以关节/操作空间决定闭环比较量，以分散/集中划分动力学耦合补偿深度，最终通过电机五式接口下发控制电压或电流指令**。

## 一页核心公式

### 1. 分散控制（7.2 节）

- **电机轴解耦近似**：

$$K_r^{-1}\bar BK_r^{-1}\ddot{\boldsymbol q}_m + F_m\dot{\boldsymbol q}_m + \boldsymbol d = \boldsymbol\tau_m,\qquad \boldsymbol d = K_r^{-1}\Delta BK_r^{-1}\ddot{\boldsymbol q}_m + K_r^{-1}CK_r^{-1}\dot{\boldsymbol q}_m + K_r^{-1}\boldsymbol g.$$

- **位置 PI Routh 稳定性与干扰抑制**：

$$L(s)=\frac{k_mK_Pk_{tp}(1+sT_p)}{s^2(1+sT_m)} \implies \text{稳定}\iff T_p>T_m,\qquad X_R=K_Pk_{tp},\qquad T_R=\max\!\left\{T_p,\ \frac{1}{\zeta\omega_n}\right\}.$$

- **驱动五式接口与速度源近似条件**：

$$\boldsymbol\tau = K_rK_tR_a^{-1}(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q}),\qquad |R_{a_i}i_{a_i}|\ll|k_{v_i}k_{r_i}\dot q_i| \implies G_v\boldsymbol v_c\approx K_vK_r\dot{\boldsymbol q}.$$

  配备理想高频宽电流内环时直接获得力矩接口：$\boldsymbol\tau=K_rK_tG_i\boldsymbol v_c$。

- **两级离线计算前馈**（用期望状态 $\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d$）：计算转矩前馈补残余 $\Delta B,C,\boldsymbol g$（注意保 $G_v^{-1}$ 且勿重复加 $\bar B$）。

### 2. 集中控制四档方法（7.3 节，$\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$）

- **重力补偿 PD（定点控制 $\dot{\boldsymbol q}_d=\boldsymbol 0$）**：

$$\boldsymbol u = \boldsymbol g(\boldsymbol q)+K_P\tilde{\boldsymbol q}-K_D\dot{\boldsymbol q},\qquad V=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}+\frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q},\qquad \dot V=-\dot{\boldsymbol q}^{\mathrm T}(F+K_D)\dot{\boldsymbol q}\le 0\quad(\text{LaSalle}).$$

- **逆动力学 / 计算力矩（精确反馈线性化）**：

$$\boldsymbol u = B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}\bigr)+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q}) \implies \ddot{\tilde{\boldsymbol q}}+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}=\boldsymbol 0.$$

- **鲁棒滑模 + 边界层（有界扰动 $\rho\ge\|\boldsymbol\eta\|$）**：

$$\boldsymbol u=\hat B\boldsymbol y+\hat{\boldsymbol n}+\boldsymbol\omega,\qquad \boldsymbol z=\hat B^{-\mathrm T}D^{\mathrm T}Q\boldsymbol\xi,\qquad \boldsymbol\omega=\begin{cases}\frac{\rho}{\|\boldsymbol z\|}\boldsymbol z,&\|\boldsymbol z\|\ge\varepsilon\\ \frac{\rho}{\varepsilon}\boldsymbol z,&\|\boldsymbol z\|<\varepsilon\end{cases}\implies \dot V\le-\lambda_{\min}(P)\|\boldsymbol\xi\|^2+\frac{\rho\varepsilon}{2}.$$

- **直接自适应控制（回归线化 $Y\boldsymbol\pi$）**：

$$\dot{\boldsymbol q}_r=\dot{\boldsymbol q}_d+\Lambda\tilde{\boldsymbol q},\quad \boldsymbol\sigma=\dot{\tilde{\boldsymbol q}}+\Lambda\tilde{\boldsymbol q},\qquad \boldsymbol u=Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)\hat{\boldsymbol\pi}+K_D\boldsymbol\sigma,\qquad \dot{\hat{\boldsymbol\pi}}=K_\pi^{-1}Y^{\mathrm T}\boldsymbol\sigma.$$

### 3. 操作空间控制（7.4 节 选学）

- **重力补偿 PD 与平衡**：$\boldsymbol u=\boldsymbol g(\boldsymbol q)+J_A^{\mathrm T}K_P\tilde{\boldsymbol x}-J_A^{\mathrm T}K_DJ_A\dot{\boldsymbol q}$，平衡条件 $J_A^{\mathrm T}K_P\tilde{\boldsymbol x}=\boldsymbol 0$（奇异卡死与冗余零空间失耗散）。
- **逆动力学**：$\boldsymbol y=J_A^{-1}(\ddot{\boldsymbol x}_d+K_D\dot{\tilde{\boldsymbol x}}+K_P\tilde{\boldsymbol x}-\dot J_A\dot{\boldsymbol q}),\ \boldsymbol u=B\boldsymbol y+\boldsymbol n$。

## 三句话核心规律

1. **分散与集中本质差异**：分散控制依靠高减速比与局部增益把耦合视为外扰 $\boldsymbol d$，集中控制则显式对消非线性或借助界与在线估计镇定；切勿把“关节空间 vs 操作空间”同“分散 vs 集中”混为一谈。
2. **前馈与反馈严格分工**：[7.2.6](sec7-2.md#sec-7.2.7)计算转矩前馈基于期望轨迹可离线生成，[7.3.3](sec7-3.md#sec-7.3.4)计算力矩控制依靠实测反馈做实时全空间对消；一旦存在参数摄动（如质量 $+10\%$）或力矩限幅，必须以鲁棒边界层或在线自适应兜底。
3. **稳定性证明严格绑定条件**：重力补偿 PD 的 LaSalle 证明仅覆盖固定目标；逆动力学极点直接按加速度量纲整定（$K_P=\omega_n^2, K_D=2\zeta\omega_n$，不乘惯量）；直接自适应借助 Barbalat 引理仅保跟踪误差收敛，参数辨识真值还需持续激励 PE。

## 与后续章节的衔接

本章均假定机械臂不与外部物体发生力学接触（$\boldsymbol h_e=\boldsymbol 0$）。一旦需要打磨、插孔、拧紧等约束交互，须进入[第八章 · 力控制](../ch08/overview.md)处理接触力反馈与阻抗/力位混合控制。配套数值与仿真校验见 `tools/verify_homework07.py` 与[作业七（8-12 完整求解）](homework07.md)。
