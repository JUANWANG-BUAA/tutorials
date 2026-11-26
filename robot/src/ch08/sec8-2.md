# 8.2 柔顺控制：两个刚度决定平衡

直接面对接触任务时，最自然的设想不是去测力，而是让机械臂在碰到物体后学会“让一让”——就像手拿着弹簧压向桌面，压得越深，反抗力越大，最终停在一个折中位置。这种在静态下将位置偏差与接触力挂钩的能力称为**柔顺（Compliance）**。本节先证明第七章的位置 PD 控制器本质上就是一个主动弹簧，再解决三维大姿态下如何重新定义旋转误差，最后用双弹簧串联模型算出“停在哪里、力有多大”。

<a id="sec-8.2.1"></a>

## 8.2.1 接触后的 PD 控制像一根主动弹簧

沿用第七章基于分析雅可比的操作空间 PD 加重力补偿控制律：

$$\boldsymbol{u} = \boldsymbol{g}(\boldsymbol{q}) + J_A^{\mathrm T}(\boldsymbol{q})\bigl(K_P\boldsymbol{e} - K_D J_A(\boldsymbol{q})\dot{\boldsymbol{q}}\bigr), \qquad \boldsymbol{e} = \boldsymbol{x}_d - \boldsymbol{x}_e,$$

其中 $K_P, K_D \succ O$ 为正定对角（或对称正定）比例与微分增益矩阵，$\boldsymbol{x}_d$ 为常值期望位姿。当机械臂与固定环境表面达成静态接触平衡时，$\dot{\boldsymbol{q}} = \boldsymbol{0},\,\ddot{\boldsymbol{q}} = \boldsymbol{0}$，将控制律代入[含接触力动力学模型](sec8-1.md#def-8.1.1)并利用 $J^{\mathrm T}\boldsymbol{h}_e = J_A^{\mathrm T}\boldsymbol{h}_A$，可得平衡条件：

::: thm 定理 8.2.1 · 主动柔顺的静态平衡与广义刚度矩阵 {#thm-8.2.1}
在含接触机械臂系统中采用固定目标的操作空间 PD + 重力补偿控制律，若平衡构型处分析雅可比 $J_A(\boldsymbol{q})$ 满行秩（$J_A^{\mathrm T}$ 列满秩，零空间仅含零向量），则静态接触平衡满足线性胡克定律形式：

$$K_P\boldsymbol{e} = \boldsymbol{h}_A \iff \boldsymbol{e} = K_P^{-1}\boldsymbol{h}_A,$$

即控制增益阵 $K_P$ 等效为**主动刚度矩阵**（Active Stiffness），其逆 $C = K_P^{-1}$ 为**主动柔度矩阵**（Active Compliance）。
:::

**证明**：平衡时 $B\ddot{\boldsymbol{q}} + C\dot{\boldsymbol{q}} + F\dot{\boldsymbol{q}} = \boldsymbol{0}$ 且 $\boldsymbol{g}(\boldsymbol{q})$ 与重力补偿抵消，动力学方程化为 $J_A^{\mathrm T}K_P\boldsymbol{e} = \boldsymbol{u} - \boldsymbol{g} = J^{\mathrm T}\boldsymbol{h}_e = J_A^{\mathrm T}\boldsymbol{h}_A$，即 $J_A^{\mathrm T}(K_P\boldsymbol{e} - \boldsymbol{h}_A) = \boldsymbol{0}$。当 $J_A$ 满行秩时，$J_A^{\mathrm T}$ 仅有平凡零空间，故必有 $K_P\boldsymbol{e} = \boldsymbol{h}_A$。$\square$

沿着任意方向增大 $K_P$，同样接触力下的平衡位置偏差 $\boldsymbol{e}$ 减小，机器人显得更“硬”；反之减小 $K_P$ 则使机器人更“软”，从而仅靠软件增益就能在无力传感器的情况下实现主动柔顺。但这个弹簧类比必须附带两项边界条件：第一，它**只描述静态平衡点**，不保证靠近表面时没有剧烈振荡；第二，若末端处于**奇异位形**（$J_A$ 降秩），便存在非零接触力落在 $J^{\mathrm T}\boldsymbol{h}_e = \boldsymbol{0}$ 的零空间内——此时接触力完全由机械臂刚体连杆的内部结构反力承担，无法靠降低 $K_P$ 来卸掉，更不能由 $J_A^{\mathrm T}(K_P\boldsymbol{e} - \boldsymbol{h}_A) = \boldsymbol{0}$ 消去 $J_A^{\mathrm T}$。

<a id="sec-8.2.2"></a>

## 8.2.2 被动柔顺与主动柔顺

顺应接触不必全部交给控制算法，也可以依靠机构自身的弹性元件实现，这称为**被动柔顺（Passive Compliance）**。在同一参考点与小位移协调坐标下，弹性元件把末端小平移 $\delta\boldsymbol{p}$ 和小转角 $\delta\boldsymbol{\theta}$ 映射为物理力与力矩：

$$\begin{bmatrix}\boldsymbol{f}\\\boldsymbol{\mu}\end{bmatrix} = \begin{bmatrix}K_f & K_c\\ K_c^{\mathrm T} & K_\mu\end{bmatrix}\begin{bmatrix}\delta\boldsymbol{p}\\\delta\boldsymbol{\theta}\end{bmatrix},$$

其中 $K_f$ 为平移刚度矩阵，$K_\mu$ 为转动刚度矩阵，$K_c$ 描述平动与转动之间的耦合；理想线弹性体的整体 $6\times 6$ 刚度矩阵对称半正定（$K_c$ 本身不必对称；若存在零刚度自由方向，整体矩阵奇异不可求逆）。

典型的被动柔顺装置是安装于末端法兰与夹爪之间的 **RCC（Remote Centre of Compliance，远心柔顺装置）**：它利用精密连杆和弹性片把柔顺中心投影到远端（例如插销前端面），使轴孔装配时的侧向偏差主要诱发纯平动纠正、角度偏差主要诱发绕远心的纯转动对准，从而极大抑制卡阻。被动柔顺响应零延迟、频带宽，但刚度矩阵与柔顺中心在制造时即已固化，换用新工件或调整柔度通常要更换硬件；主动柔顺通过控制软件修改 $K_P$ 更为灵活，但等效刚度与带宽受限于关节驱动力矩饱和、编码器分辨率和采样周期。

<a id="sec-8.2.3"></a>

## 8.2.3 为什么必须重新定义大转角姿态误差

前文得出 $\boldsymbol{h}_A = K_P\boldsymbol{e}$，而功率配对关系 $\boldsymbol{h}_A = T_A^{\mathrm T}(\boldsymbol{\phi}_e)\boldsymbol{h}_e$ 中带有依赖当前姿态欧拉角的变换矩阵 $T_A$。即便在软件里把 $K_P$ 设为常数对角阵，基座系下真实物理力矩 $\boldsymbol{\mu}_e$ 到欧拉角偏差的比例系数仍会随当前姿态剧烈扭曲，甚至在表示奇异附近完全失效。

为此，不能再用“全局欧拉角简单相减”充当刚度弹簧的变形量。设目标位姿与实际位姿相对于基座系的齐次变换分别为 $T_d, T_e$，先将实际末端位姿表达在目标坐标系 $\{d\}$ 中：

$${}^d T_e = T_d^{-1}T_e = \begin{bmatrix}R_d^{\mathrm T}R_e & R_d^{\mathrm T}(\boldsymbol{p}_e - \boldsymbol{p}_d) \\ \boldsymbol{0}^{\mathrm T} & 1\end{bmatrix}.$$

从相对旋转阵 ${}^d R_e = R_d^{\mathrm T}R_e$ 中提取**局部 XYZ（RPY）角** $\boldsymbol{\phi}_{d,e} = [\varphi_{d,e},\,\vartheta_{d,e},\,\psi_{d,e}]^{\mathrm T}$，重新定义在目标系 $\{d\}$ 下描述的相对位姿误差：

$$\boldsymbol{e}_d = -\begin{bmatrix}R_d^{\mathrm T}(\boldsymbol{p}_e - \boldsymbol{p}_d) \\ \boldsymbol{\phi}_{d,e}\end{bmatrix}.$$

注意此处选用局部 XYZ 角而非 ZYZ 欧拉角：当目标与实际完全重合（${}^d R_e = I_3,\,\boldsymbol{\phi}_{d,e} = \boldsymbol{0}$）时，XYZ 角的变换阵满足 $T_A(\boldsymbol{0}) = I_3$（无奇异），而 ZYZ 角在零姿态 $\vartheta = 0$ 处恰恰存在表示奇异。对固定目标（$\dot R_d = O,\,\dot{\boldsymbol{p}}_d = \boldsymbol{0}$），将 $\boldsymbol{e}_d$ 对时间求导可得相对分析雅可比 $J_{Ad}$：

$$\dot{\boldsymbol{e}}_d = -\begin{bmatrix}I_3 & O \\ O & T_{\mathrm{XYZ}}^{-1}(\boldsymbol{\phi}_{d,e})\end{bmatrix}\begin{bmatrix}R_d^{\mathrm T} & O \\ O & R_d^{\mathrm T}\end{bmatrix} J(\boldsymbol{q})\dot{\boldsymbol{q}} \triangleq -T_A^{-1}(\boldsymbol{\phi}_{d,e})\operatorname{diag}(R_d^{\mathrm T}, R_d^{\mathrm T})J\dot{\boldsymbol{q}} = -J_{Ad}\dot{\boldsymbol{q}}.$$

若将 PD 控制器中的位置误差替换为此 $\boldsymbol{e}_d$（$\boldsymbol{u} = \boldsymbol{g} + J_{Ad}^{\mathrm T}(K_P\boldsymbol{e}_d - K_D J_{Ad}\dot{\boldsymbol{q}})$），则在目标坐标系 $\{d\}$ 下表达的平衡接触力变为：

$${}^d\boldsymbol{h}_e = T_A^{-\mathrm T}(\boldsymbol{\phi}_{d,e}) K_P \boldsymbol{e}_d.$$

当相对姿态偏差较小时（$\boldsymbol{\phi}_{d,e}\to \boldsymbol{0}$），$T_A(\boldsymbol{\phi}_{d,e})\approx I_6$，上式才退化为各向解耦的小位移胡克定律 ${}^d\boldsymbol{h}_e \simeq K_P\delta\boldsymbol{x}_{e,d}$。这一步并没有把大角度非线性旋转彻底变成线性，只是把“坐标系零点”搬到了目标位姿附近，保证在工作偏差较小时三个平动方向和三个转动方向的刚度定义物理直观且互不串扰。

<a id="sec-8.2.balance"></a>
<a id="sec-8.2.4"></a>

## 8.2.4 环境也有一根弹簧：双弹簧串联平衡

在实际接触中，环境表面本身同样具有刚度 $K_e$。把控制器视为一根刚度为 $K_P$ 的弹簧，把环境表面视为另一根刚度为 $K_e$ 的弹簧，末端执行器就夹在两者之间。停在哪里、接触力多大，由两根弹簧串联分压共同决定。

::: thm 定理 8.2.2 · 控制器与环境的双弹簧串联平衡 {#thm-8.2.2}
在小位移坐标中，设从环境未变形静止位置到期望目标位姿的位移向量为 $\boldsymbol{d} = \boldsymbol{x}_d - \boldsymbol{x}_r$，从实际末端位姿到期望目标位姿的误差为 $\boldsymbol{e} = \boldsymbol{x}_d - \boldsymbol{x}_e$，则环境变形量为 $\boldsymbol{d} - \boldsymbol{e} = \boldsymbol{x}_e - \boldsymbol{x}_r$。当 $K_P \succ O$ 且环境刚度 $K_e \succeq O$ 时，$K_P + K_e$ 可逆，静态平衡下的误差与接触力满足：

$$\boldsymbol{e} = (K_P + K_e)^{-1}K_e\boldsymbol{d}, \qquad \boldsymbol{h}_e = K_P(K_P + K_e)^{-1}K_e\boldsymbol{d} = K_{\mathrm{eq}}\boldsymbol{d},$$

且串联等效刚度矩阵满足柔度相加关系（$K_e \succ O$ 时）：

$$K_{\mathrm{eq}}^{-1} = K_P^{-1} + K_e^{-1}.$$
:::

**证明**：同一接触界面的静态平衡要求机械臂主动弹簧产生的力等于环境弹簧承受的力：

$$\boldsymbol{h}_e = K_P\boldsymbol{e} = K_e(\boldsymbol{d} - \boldsymbol{e}).$$

移项合并得 $(K_P + K_e)\boldsymbol{e} = K_e\boldsymbol{d}$；因 $K_P \succ O$ 且 $K_e \succeq O$，矩阵 $K_P + K_e$ 严格正定必然可逆（即便环境在某些自由切向方向刚度为零也成立），立即解出 $\boldsymbol{e} = (K_P + K_e)^{-1}K_e\boldsymbol{d}$。若改由 $\boldsymbol{e} = K_P^{-1}\boldsymbol{h}_e$ 代入 $\boldsymbol{h}_e = K_e(\boldsymbol{d} - \boldsymbol{e})$，则 $\boldsymbol{h}_e = K_e\boldsymbol{d} - K_e K_P^{-1}\boldsymbol{h}_e \implies (I + K_e K_P^{-1})\boldsymbol{h}_e = K_e\boldsymbol{d}$；矩阵乘法一般不可交换，不可像标量分式那样随意颠倒顺序，当 $K_e \succ O$ 时左乘 $K_e^{-1}$ 得 $(K_e^{-1} + K_P^{-1})\boldsymbol{h}_e = \boldsymbol{d}$，即 $K_{\mathrm{eq}}^{-1} = K_P^{-1} + K_e^{-1}$。$\square$

回到单轴标量情形（$x_d > x_r$，处于接触分支），平衡条件 $k_P(x_d - x_e) = k_e(x_e - x_r)$ 直接解出平衡位置与静态接触力：

$$x_e = \frac{k_P x_d + k_e x_r}{k_P + k_e}, \qquad f_e = \frac{k_P k_e}{k_P + k_e}(x_d - x_r).$$

上式清楚揭示了两个刚度的相对强弱如何支配平衡：
- 若 $k_P \gg k_e$，则 $x_e \approx x_d$，$f_e \approx k_e(x_d - x_r)$：环境软而手“硬”，**环境顺应机械臂**；
- 若 $k_P \ll k_e$，则 $x_e \approx x_r$，$f_e \approx k_P(x_d - x_r)$：环境硬而手“软”，**机械臂顺应环境**，此时即便进一步增硬工件，接触力也不会超过上限 $k_P(x_d - x_r)$。

取 $x_r = 1.0\,\mathrm m$、期望目标落入表面内 $x_d = 1.1\,\mathrm m$、控制器刚度 $k_P = 2500\,\mathrm{N/m}$，在两种不同环境下的精确数值对照如下：

| 环境刚度 $k_e$ | 平衡位置 $x_e$ | 环境压入量 $x_e - x_r$ | 静态接触力 $f_e$ |
|:--|:--|:--|:--|
| $1000\,\mathrm{N/m}$（较软） | $1.07143\,\mathrm m$ | $7.143\,\mathrm{cm}$ | $71.43\,\mathrm N$ |
| $10000\,\mathrm{N/m}$（较硬） | $1.02000\,\mathrm m$ | $2.000\,\mathrm{cm}$ | $200.00\,\mathrm N$ |

对照表中数字能立刻纠正一个直觉错误：同一套控制参数碰到 10 倍硬度的工件时，压入深度从 $7.14\,\mathrm{cm}$ 骤降到 $2.00\,\mathrm{cm}$，但稳态接触力反而从 $71.43\,\mathrm N$ 飙升到 $200.00\,\mathrm N$。**“压得浅”绝不代表“力就小”**，因为串联弹簧分担的变形比例改变了。

<details>
<summary>自己算：只把控制刚度 k_P 调小，就能保证末端碰上表面时不振荡吗？</summary>

不能。上述公式只决定**最终停在哪里**，不决定**如何走到平衡点**。压下瞬间会不会超调、撞击后是否来回弹跳振荡，取决于系统的惯量、阻尼以及内环动力学。下一节就把惯量与阻尼一起写入目标方程，把静态柔顺升级为动态阻抗。

</details>

## 8.2 小结与常见错误

- **一条主线**：静态接触下，PD 控制等价于主动弹簧 $K_P\boldsymbol{e} = \boldsymbol{h}_A$；再串联环境弹簧 $K_e$，共同给出平衡位置 $\boldsymbol{e} = (K_P + K_e)^{-1}K_e\boldsymbol{d}$ 与串联柔度相加律 $K_{\mathrm{eq}}^{-1} = K_P^{-1} + K_e^{-1}$。
- **姿态修正要点**：大转角下先算相对齐次阵 ${}^d T_e = T_d^{-1}T_e$ 并提取无零位奇异的局部 XYZ 角 $\boldsymbol{\phi}_{d,e}$，才能保证平衡力矩关系在小偏差下退化为各向线性刚度。
- **反直觉结论**：面对更硬的环境，平衡压入深度变小，但静态接触力反而变大（接近 $k_P(x_d - x_r)$ 上限）。
- **下一节**：[8.3 阻抗与导纳](sec8-3.md) 从静态平衡走向二阶动态关系，直接塑形碰撞瞬态的惯量与阻尼响应。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 主动柔顺平衡：$K_P\boldsymbol{e} = \boldsymbol{h}_A$ | $J_A$ 满行秩、静态平衡 | $\mathrm N,\mathrm{N\cdot m}$ | 奇异位形处接触力可由机构内部承受，不能随意消去 $J_A^{\mathrm T}$ |
| 相对姿态误差：$\boldsymbol{e}_d = -\begin{bmatrix}R_d^{\mathrm T}(\boldsymbol{p}_e - \boldsymbol{p}_d)\\\boldsymbol{\phi}_{d,e}\end{bmatrix}$ | 固定目标、局部 XYZ 欧拉角 | $\mathrm m,\mathrm{rad}$ | 不可用零位有奇异的 ZYZ 角替代 $\boldsymbol{\phi}_{d,e}$ |
| 双弹簧平衡：$x_e = \dfrac{k_P x_d + k_e x_r}{k_P + k_e}$，$f_e = \dfrac{k_P k_e}{k_P + k_e}(x_d - x_r)$ | 单轴接触分支 $x_e \ge x_r$ | $\mathrm m,\mathrm N$ | 压入深度小 $\neq$ 接触力小；矩阵求逆顺序不能照标量交换 |

::: think 常见错误清单 · 自查三条
1. 只调小 $k_P$ 就指望接触过程平顺无振荡：静态刚度不管过渡过程，阻尼和惯量匹配留在 8.3 解决。
2. 看到压入深度减小就以为受力安全：更硬表面压得更浅但把几乎全部目标变形压在了控制器弹簧上，力反而大增。
3. 在奇异构型或大转角下直接对非功率配对坐标用 $K_P\boldsymbol{e} = \boldsymbol{h}_e$：先检查雅可比秩和 $T_A$ 变换。
:::
