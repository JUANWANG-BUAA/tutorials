# 第七章勘误与记号对照

本章梳理自由空间运动控制（原书第 8 章）在章节编号、控制律术语、符号正负号、参数口径以及仿真比较中常见且易导致推导出错的约定差异。

## E7.1 章节编号与原书对照

本教程按课程体系把动力学编为第六章（原书第 7 章）、把运动控制编为**第七章（原书第 8 章 Motion Control）**；各节正文中公式按本教程节号标注（如 (7.2-15)、(7.3-9)），与原书按对应小节名称及核心结构检索一致。

## E7.2 术语辨析：“计算转矩前馈” vs “计算力矩 / 逆动力学控制”

- **计算转矩前馈（7.2.6 节）**：采用规划好的**期望轨迹** $(\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d)$ 计算补偿电压 $\boldsymbol v_{c,\mathrm{ff}}$，可完全离线生成，不改变系统反馈闭环极点（注：补 $\Delta B$ 而非完整 $B$，以免与分散名义前馈中的 $\bar B$ 重复）。
- **计算力矩 / 逆动力学控制（7.3.3 节）**：采用传感器**实时测得**的 $(\boldsymbol q,\dot{\boldsymbol q})$ 在线计算补偿 $B(\boldsymbol q),\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})$，属于大范围反馈线性化。两者在无跟踪误差且模型精确时数值一致，但在误差产生后的闭环动力学上截然不同。

## E7.3 “鲁棒控制”的架构定位与力矩切换项符号

- 本章 [7.3.4 节](sec7-3.md#sec-7.3.5) 中的鲁棒控制特指基于 **Lyapunov 再设计** 的滑模边界层方法，而非频域 $H_2/H_\infty$ 控制。
- 切换矢量 $\boldsymbol z$ 与外加控制律写法必须匹配：采用 $\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$、控制律 $\boldsymbol u=\hat B\boldsymbol y+\hat{\boldsymbol n}+\boldsymbol\omega$ 及系统 $\hat B\ddot{\boldsymbol q}+\hat{\boldsymbol n}+\boldsymbol\eta=\boldsymbol u$ 时，误差方程含 $\hat B^{-1}(\boldsymbol\eta-\boldsymbol\omega)$，从而 $\dot V$ 中的扰动项是 $+2\boldsymbol z^{\mathrm T}(\boldsymbol\eta-\boldsymbol\omega)$，切换矢量必须保留逆转置因子 $\boldsymbol z = \hat B^{-\mathrm T}D^{\mathrm T}Q\boldsymbol\xi$（若部分讲义把补偿放入内环辅助加速度，则零集合等价为 $D^{\mathrm T}Q\boldsymbol\xi=\boldsymbol 0$，但对应不确定界量纲由力矩变为加速度）。边界层内线性化切换项一般仅保证误差**一致最终有界（UUB）**。

## E7.4 传函符号、阻尼项正负号与两套整定口径

1. **PI 环节符号**：本教程统一记位置环零点时间常数为 $T_p$、电机时间常数为 $T_m$、位置传感器静态增益为 $k_{tp}$（原书常写作 $\tau_p,\tau_m,K_{tp}$），Routh 稳定判据恒为 $T_p>T_m$。
2. **重力补偿 PD 阻尼号**：在 $\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$ 且定点控制（$\dot{\boldsymbol q}_d=\boldsymbol 0$）下，实际速度反馈必须写为 $-K_D\dot{\boldsymbol q}$（即 $+K_D\dot{\tilde{\boldsymbol q}}$），否则 $\dot V$ 出现正项而非耗散。
3. **两套 PD 整定量纲**：单轴直接力矩整定（7.2.3 口径二）需乘等效惯量：$K_{P_i}=J_i\omega_n^2,\ K_{D_i}=2\zeta J_i\omega_n-F_i$（含单位 $\mathrm{N\cdot m/rad}$）；经逆动力学反馈线性化消去 $B(\boldsymbol q)$ 后的外环增益（7.3.3）直接取加速度量纲：$K_P=\omega_n^2,\ K_D=2\zeta\omega_n$，**绝不可再乘惯量 $J_i$**。

## E7.5 操作空间共轭接触力与欧拉角限制

在操作空间动力学（7.4 节）采用分析坐标 $\boldsymbol x=[\boldsymbol p^{\mathrm T},\boldsymbol\phi^{\mathrm T}]^{\mathrm T}$ 及分析雅可比 $J_A$ 时，与之功率共轭的末端广义力必须经 $T_A^{\mathrm T}$ 转换写为 $\boldsymbol h_A = T_A^{\mathrm T}\boldsymbol h_e$，不可直接把几何旋量力 $\boldsymbol h_e$ 混入分析空间方程；且欧拉角差 $\tilde{\boldsymbol x}$ 的求导限制在同一无表示奇异的局部光滑分支内，$\dot J_A\dot{\boldsymbol q}$ 为几何运动学二阶加速度项。

## E7.6 基准仿真参数口径与误差纵轴读法

- **两组 2R 参数区分**：7.3.3 例 7.3.1 使用教学手算均匀轻杆参数（$m_1=m_2=1\,\mathrm{kg}$）；[7.5 节](sec7-5.md)（原书 §8.7）与[作业七](homework07.md)使用真实重型两连杆参数（$m_1=m_2=5\,\mathrm{kg}$，绕各自质心转动惯量 $I_{\ell_i}=10\,\mathrm{kg\cdot m^2}$，换算至杆轴端需按平行轴定理加 $m_i\ell_i^2$ 成为 $11.25\,\mathrm{kg\cdot m^2}$；注意原书英文本第 7.2 节部分例题取 $m=50\,\mathrm{kg}$，答题时须声明所选基准）。
- **误差表读法澄清**：7.5 节九方案对比（表 A–H、J 与 K、L，略去字母 `I` 沿用原始标签）中的误差量级为末端平面位置误差 $\tilde x,\tilde y$，单位为 **$\mathrm m$**（而非关节角 $\mathrm{rad}$），且不同图的纵轴缩放倍率不同（$10^{-1}$ 至 $10^{-4}\,\mathrm m$），不可不查工况直接作为通用选型阈值。
