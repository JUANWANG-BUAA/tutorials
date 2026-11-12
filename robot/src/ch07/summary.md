# 第七章总结 · 运动控制

先确认驱动接口和误差定义，再代回动力学推导闭环。下面统一取 $e=q_d-q$；同名字母增益在不同控制结构中的单位可能不同。

## 单轴反馈与驱动接口

电机侧单轴近似为 $J\ddot q_m+b\dot q_m+d=\tau_m$。固定目标的转矩PD给

$$\tau_m=k_pe+k_d\dot e,\qquad
J\ddot e+(b+k_d)\dot e+k_pe=d.$$

所以 $k_p=J\omega_n^2$，$k_d=2\zeta J\omega_n-b$。常负载偏差为 $d/k_p$；若加入 $k_i\int e\,dt$，正参数下稳定还要求 $(b+k_d)k_p>Jk_i$，稳定以后才能用终值定理证明常负载偏差为零。

课堂电压位置对象使用另一组PI参数：

$$L(s)=\frac{k_mK_Pk_{tp}(1+sT_p)}{s^2(1+sT_m)},\qquad
T_ms^3+s^2+\kappa T_ps+\kappa=0,\quad\kappa=k_mK_Pk_{tp}>0.$$

Routh条件为 $T_p>T_m$。这里 $K_P$ 是PI参数化中的积分增益，比例项为 $K_PT_p$，不要与力矩PD刚度混用。

忽略电感、采用理想传动时，

$$q_m=K_rq,\qquad\tau_m=K_r^{-1}\tau=K_ti_a,$$

$$v_a=R_ai_a+K_v\dot q_m=G_vv_c,$$

$$\tau=K_rK_tR_a^{-1}(G_vv_c-K_vK_r\dot q).$$

只有电阻压降造成的速度偏差足够小，才能近似电压与速度成比例；静止带载时尤其不能由反电动势估保持力矩。电流环在带宽和限幅范围内近似实现转矩命令。接口本身不决定分散还是集中。

## 前馈与反馈线性化

名义单轴前馈 $J\ddot q_{md}+b\dot q_{md}$ 先提供参考运动所需的转矩，反馈再修正实际误差。整机前馈可用

$$\tau_{\rm ff}=\hat B(q_d)\ddot q_d+\hat C(q_d,\dot q_d)\dot q_d+\hat g(q_d)+\hat F\dot q_d.$$

若其中某些项已由其他通道补偿，只添加残余项。$B$ 与 $\Delta B$ 的选取取决于分工，不是区分前馈和反馈的标准。

逆动力学反馈使用当前状态：

$$u=B(q)y+n(q,\dot q),\qquad
y=\ddot q_d+K_D\dot e+K_Pe.$$

精确模型、无限幅时，先得 $\ddot q=y$，再得

$$\ddot e+K_D\dot e+K_Pe=0.$$

这里 $K_P$ 用 $\mathrm{s^{-2}}$，$K_D$ 用 $\mathrm{s^{-1}}$。对角正增益给逐轴二阶误差系统；一般对称正定增益仍可稳定，但坐标未必解耦。前馈与此式的区别还包括反馈作用位置，不能仅替换一个自变量就互相代用。

## 固定目标的重力补偿

对 $B\ddot q+C\dot q+F\dot q+g=u$，取固定 $q_d$，

$$u=g(q)+K_Pe-K_D\dot q,$$

$$V=\frac12\dot q^{\mathrm T}B\dot q+\frac12e^{\mathrm T}K_Pe,$$

$$\dot V=-\dot q^{\mathrm T}(F+K_D)\dot q\le0.$$

抵消用了 $\dot q^{\mathrm T}(\dot B-2C)\dot q=0$。在正文的有界性、精确补偿等条件下，再用LaSalle检查最大不变集：一直静止还须满足 $K_Pe=0$，才推出目标收敛。移动参考不能照搬这段证明。

## 鲁棒与自适应

鲁棒段采用已知 $B$、$\eta=n-\hat n$ 满足 $\|\eta\|\le\rho$ 的简化模型。取 $\xi=[e;\dot e]$、$u=By+\hat n+\omega$，则

$$\dot\xi=A\xi+D(\eta-\omega),\quad
A=\begin{bmatrix}0&I\\-K_P&-K_D\end{bmatrix},\quad
D=\begin{bmatrix}0\\B^{-1}\end{bmatrix}.$$

解 $A^{\mathrm T}Q+QA=-P$，$P,Q\succ0$，令 $z=D^{\mathrm T}Q\xi$。连续边界层为

$$\omega=\begin{cases}\rho z/\|z\|,&\|z\|\ge\varepsilon,\\
\rho z/\varepsilon,&\|z\|<\varepsilon.
\end{cases}$$

于是 $\dot V\le-\lambda_{\min}(P)\|\xi\|^2+\rho\varepsilon/2$。最终界还取决于 $P,Q$ 的尺度，$\varepsilon$ 不是位置误差阈值；连续近似不提供一般的零误差保证，也不意味着每次实验必有非零误差。

自适应段要求未知**常参数**的线性表示。定义

$$\dot q_r=\dot q_d+\Lambda e,\quad
\sigma=\dot q_r-\dot q=\dot e+\Lambda e,$$

$$Y_r\pi=B\ddot q_r+C(q,\dot q)\dot q_r+g,$$

$$u=Y_r\hat\pi+K_D\sigma,\qquad
\dot{\hat\pi}=K_\pi^{-1}Y_r^{\mathrm T}\sigma.$$

取 $\tilde\pi=\hat\pi-\pi$，则

$$V=\tfrac12\sigma^{\mathrm T}B\sigma+\tfrac12\tilde\pi^{\mathrm T}K_\pi\tilde\pi,
\qquad\dot V=-\sigma^{\mathrm T}K_D\sigma.$$

结合有界性和一致连续性，可得跟踪误差收敛；参数保持有界，但真值辨识还需可辨识性和足够激励。不要直接把时变参考的证明当作自治系统LaSalle证明。

## 任务误差、雅可比与广义力

取局部任务坐标 $x=[p;\phi]$，$\dot x=J_A\dot q$。若 $v=T_A\dot x$，物理力系为 $F$，则任务广义力为 $F_A=T_A^{\mathrm T}F$，关节输入为 $J_A^{\mathrm T}F_A$。欧拉角广义力通常不是物理力矩的原三个分量。

固定任务的弹簧阻尼控制为

$$u=g+J_A^{\mathrm T}K_Pe_x-J_A^{\mathrm T}K_DJ_A\dot q.$$

能量不增以后，还要核查内部阻尼、有界性和任务秩。行满秩时，静止平衡 $J_A^{\mathrm T}K_Pe_x=0$ 才推出 $e_x=0$；降秩处可能停在非目标驻点。

任务逆动力学则在方阵可逆的局部区域取

$$y=J_A^{-1}(\ddot x_d+K_D\dot e_x+K_Pe_x-\dot J_A\dot q),\qquad u=By+n.$$

精确实现才给 $\ddot e_x+K_D\dot e_x+K_Pe_x=0$。冗余时须另选任务解和内部运动，额外力矩应检查 $J_AB^{-1}\tau_0=0$。

## 如何使用仿真结果

[§7.5](sec7-5.md)给出了有完整设置的作业实验：1 ms零阶保持、匹配模型下最大误差约为 $7.94\times10^{-4}$ 与 $4.07\times10^{-4}$ rad；质量失配后变大。这些数值属于该实验，不能变成算法固有精度或固定选型档位。

比较时同时记录误差、力矩、限幅、采样与模型设置。先根据具体失败原因改变补偿或反馈，再在相同条件下重算。
