# 7.3 集中控制

当机械臂高速大加速运动或采用直驱/低减速比驱动时，惯性耦合、科氏力与重力不可再当作微小扰动压制。**集中控制（Centralized Control）** 将整机视作统一多输入多输出非线性系统，按模型掌握深度依次递进出四套经典方案：
**重力补偿 PD（定点控制） $\to$ 逆动力学/计算力矩（精确跟踪） $\to$ 鲁棒滑模控制（有界失配） $\to$ 自适应控制（未知定常参数在线更新）**（对应原书 §8.5）。

<a id="sec-7.3.1"></a>
<a id="sec-7.3.2"></a>

## 7.3.1 集中控制对象与 Lyapunov / LaSalle 稳定性基础

考察无环境接触、含粘性摩擦 $F=F_{\mathrm v}\succeq 0$ 的多关节动力学被控对象（设驱动器已提供关节力矩接口 $\boldsymbol u=\boldsymbol\tau$）：

$$B(\boldsymbol q)\ddot{\boldsymbol q} + C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q} + F\dot{\boldsymbol q} + \boldsymbol g(\boldsymbol q) = \boldsymbol u. \tag{7.3-plant}$$

本节严格采用追踪误差定义 $\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$（期望减实际）。稳定性的核心工具是 **Lyapunov 第二方法**与 **LaSalle 不变性原理**：
- 若正定连续可微能量函数 $V(\boldsymbol e)$ 在全空间满足径向无界（$\|\boldsymbol e\|\to\infty\implies V(\boldsymbol e)\to\infty$）且沿着闭环轨线严格负定（$\dot V(\boldsymbol e)<0\ (\boldsymbol e\neq\boldsymbol 0)$），则原点全局渐近稳定；
- 当能量仅通过速度阻尼项耗散时（如 $\dot V = -\dot{\boldsymbol q}^{\mathrm T}(F+K_D)\dot{\boldsymbol q}\le 0$ 仅半负定，速度为零而位置有误差时 $\dot V=0$），则必须结合自治系统的 **LaSalle 不变性原理**：先由 $\dot V\le 0$ 确认状态轨线留在紧致正向不变集 $\Omega_c=\{V\le c\}$ 中，再证明集 $S=\{\dot V=0\}$ 内不包含除平衡点原点以外的任何完整动力学不变轨线（最大不变集 $M=\{\boldsymbol 0\}$），即可推知全球渐近收敛。

<a id="sec-7.3.3"></a>

## 7.3.2 重力补偿 PD 控制（点对点镇定）

在诸多点位搬运与定点悬停任务中，期望角位置 $\boldsymbol q_d$ 为常数矢量（$\dot{\boldsymbol q}_d=\ddot{\boldsymbol q}_d=\boldsymbol 0 \implies \dot{\tilde{\boldsymbol q}}=-\dot{\boldsymbol q}$）。此时仅补偿实际重力的 PD 控制律完全不需要知道精确的 $B(\boldsymbol q)$ 与 $C(\boldsymbol q,\dot{\boldsymbol q})$，只需使用当前实测角补偿重力：

$$\boxed{\ \boldsymbol u = \boldsymbol g(\boldsymbol q) + K_P\tilde{\boldsymbol q} - K_D\dot{\boldsymbol q}\ } \tag{7.3-6}$$

其中比例与微分增益矩阵均为对称正定阵（$K_P=K_P^{\mathrm T}\succ 0,\ K_D=K_D^{\mathrm T}\succ 0$；因 $\dot{\tilde{\boldsymbol q}}=-\dot{\boldsymbol q}$，阻尼项也可等价写作 $+K_D\dot{\tilde{\boldsymbol q}}$）。

::: thm[core] 定理 7.3.A · 重力补偿 PD 定点控制全局渐近稳定性
在无关节限位约束展开坐标 $\boldsymbol q\in\mathbb R^n$、惯性矩阵一致有界正定（$B(\boldsymbol q)\succeq b_* I\succ 0$）、按 Christoffel 符号选取 $C$ 使 $\dot B-2C$ 反对称、重力模型 $\boldsymbol g(\boldsymbol q)$ 精确补偿且执行器力矩不饱和的理想前提下，闭环系统对任意固定目标 $\boldsymbol q_d$ 均保证平衡点 $(\tilde{\boldsymbol q},\dot{\boldsymbol q})=(\boldsymbol 0,\boldsymbol 0)$ **全局渐近稳定**。
:::

::: sol 证明（构造机械能 Lyapunov 函数 + $\dot B-2C$ 反对称消项 + LaSalle 不变集）
1. **构造径向无界 Lyapunov 函数**：取机器人真实动能与虚拟比例弹簧势能之和

$$V(\dot{\boldsymbol q},\tilde{\boldsymbol q}) = \frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q} + \frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}. \tag{7.3-3}$$

   因 $B(\boldsymbol q)\succeq b_*I\succ 0$ 且 $K_P\succ 0$，$V\ge \frac12 b_*\|\dot{\boldsymbol q}\|^2 + \frac12\lambda_{\min}(K_P)\|\tilde{\boldsymbol q}\|^2 \to\infty$，在全状态空间 $\mathbb R^{2n}$ 正定且径向无界。

2. **求时间导数并消去速度耦合项**：注意 $B(\boldsymbol q)$ 随时间变化，且 $\dot{\tilde{\boldsymbol q}}=-\dot{\boldsymbol q}$：

$$\dot V = \dot{\boldsymbol q}^{\mathrm T}B\ddot{\boldsymbol q} + \frac12\dot{\boldsymbol q}^{\ T}\dot B\dot{\boldsymbol q} - \dot{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}.$$

   代回被控对象 $B\ddot{\boldsymbol q}=\boldsymbol u - C\dot{\boldsymbol q} - F\dot{\boldsymbol q} - \boldsymbol g(\boldsymbol q)$ 并重组：

$$\dot V = \frac12\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B(\boldsymbol q)-2C(\boldsymbol q,\dot{\boldsymbol q})\bigr)\dot{\boldsymbol q} - \dot{\boldsymbol q}^{\mathrm T}F\dot{\boldsymbol q} + \dot{\boldsymbol q}^{\mathrm T}\bigl(\boldsymbol u-\boldsymbol g(\boldsymbol q)-K_P\tilde{\boldsymbol q}\bigr).$$

   由第六章性质一（反对称性或动能定理），第一项恒等于零；代入控制律 (7.3-6) 消去 $\boldsymbol g(\boldsymbol q)$ 与 $K_P\tilde{\boldsymbol q}$ 得

$$\dot V = -\dot{\boldsymbol q}^{\mathrm T}(F + K_D)\dot{\boldsymbol q} \le 0. \tag{7.3-7}$$

3. **LaSalle 不变集论证**：由 $\dot V\le 0$ 与径向无界性知全轨线停留在有界闭正向不变集 $\Omega_c=\{V\le V(0)\}$ 内。考察 $\dot V=0$ 子集 $S$：因 $F+K_D\succ 0$，必有 $\dot{\boldsymbol q}=\boldsymbol 0$。若某完整轨线能始终停留在 $S$ 内的不变集 $M$，必有 $\dot{\boldsymbol q}(t)\equiv\boldsymbol 0 \implies \ddot{\boldsymbol q}(t)\equiv\boldsymbol 0$。代回闭环动力学方程：

$$\boldsymbol g(\boldsymbol q) = \boldsymbol g(\boldsymbol q) + K_P\tilde{\boldsymbol q} \implies K_P\tilde{\boldsymbol q}=\boldsymbol 0 \implies \tilde{\boldsymbol q}=\boldsymbol 0.$$

   物理上，若瞬时速度为零而仍存在位置误差（$\tilde{\boldsymbol q}\neq\boldsymbol 0$），弹簧恢复力立即产生非零加速度 $\ddot{\boldsymbol q}=B^{-1}K_P\tilde{\boldsymbol q}\neq\boldsymbol 0$ 将状态拉离静止面。故最大不变集仅含唯一平衡点 $M=\{(\boldsymbol 0,\boldsymbol 0)\}$，全局渐近稳定得证。
:::

> **三个严格前提不可擅自放宽**：(1) 证明依赖固定目标 $\dot{\boldsymbol q}_d=\boldsymbol 0$，若强行套用于时变轨迹，则 $\dot V$ 出现未抵消项 $\tilde{\boldsymbol q}^{\mathrm T}K_P\dot{\boldsymbol q}_d$；(2) 重力必须按**实测角度 $\boldsymbol q$** 补偿，若写为 $\boldsymbol g(\boldsymbol q_d)$ 则是开环前馈而非闭环平衡抵消；(3) 由于未补偿 $B$ 和 $C$，高速大范围运动中的动态跟踪滞后较显著。

<a id="sec-7.3.4"></a>

## 7.3.3 逆动力学（计算力矩）控制

面对时变轨迹 $\boldsymbol q_d(t)$ 的动态高精度跟踪，将系统整理为 $B(\boldsymbol q)\ddot{\boldsymbol q}+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})=\boldsymbol u$，其中 $\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})=C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+F\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)$。构造内环非线性补偿 $\boldsymbol u=B(\boldsymbol q)\boldsymbol y+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})$ 与外环双积分器线性稳定器 $\boldsymbol y=\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}$，合成为**逆动力学（计算力矩）控制律**：

$$\boxed{\ \boldsymbol u = B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d + K_D\dot{\tilde{\boldsymbol q}} + K_P\tilde{\boldsymbol q}\bigr) + \boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})\ } \tag{7.3-9}$$

由于 $B(\boldsymbol q)\succ 0$ 恒可逆，将控制律完整代入被控对象消去全部非线性与耦合，闭环化为线性定常解耦误差方程：

$$\ddot{\tilde{\boldsymbol q}} + K_D\dot{\tilde{\boldsymbol q}} + K_P\tilde{\boldsymbol q} = \boldsymbol 0. \tag{7.3-10}$$

::: thm[core] 定理 7.3.B · 逆动力学反馈线性化与指数收敛
当模型 $(B,\boldsymbol n)$ 精确、状态 $(\boldsymbol q,\dot{\boldsymbol q})$ 准确可得、理想连续更新且执行器不饱和时，选取正对角阵 $K_P=\operatorname{diag}\{\omega_{n_1}^2,\dots,\omega_{n_n}^2\}$（单位 $\mathrm{s^{-2}}$）与 $K_D=\operatorname{diag}\{2\zeta_1\omega_{n_1},\dots,2\zeta_n\omega_{n_n}\}$（单位 $\mathrm{s^{-1}}$），即可实现全工作空间精确**反馈线性化**——使各关节误差完全解耦并按给定极点指数收敛至零。
:::

注意此线性化依靠实测状态大范围精确对消非线性，与在某平衡点做 Taylor 展开的“小偏差线性化”有本质差异；同时因 $B(\boldsymbol q)$ 已在乘法中抵消，增益 $K_P,K_D$ 直接取加速度环量纲，**绝对不可再乘关节惯量 $J_i$**。

::: ex 例 7.3.1 · 均匀两连杆平面臂的逆动力学计算与耦合前瞻补偿
沿用[6.3.2 节](../ch06/sec6-3.md#part-6.3.2)竖直平面两连杆模型（$a_1=a_2=1\,\mathrm m,\ m_1=m_2=1\,\mathrm{kg},\ \ell_1=\ell_2=0.5\,\mathrm m,\ I_1=I_2=1/12\,\mathrm{kg\cdot m^2}$，忽略摩擦与转子惯量）：

$$B(\boldsymbol q)=\begin{bmatrix}5/3+\cos q_2&1/3+\frac12\cos q_2\\1/3+\frac12\cos q_2&1/3\end{bmatrix},\quad \boldsymbol g(\boldsymbol q)=9.81\begin{bmatrix}\frac32 c_1+\frac12 c_{12}\\\frac12 c_{12}\end{bmatrix}.$$

取外环增益 $K_P=25I_2\,\mathrm{s^{-2}}$、$K_D=10I_2\,\mathrm{s^{-1}}$。在某瞬时测得实际位形 $\boldsymbol q_A=(0,\pi/2)^{\mathrm T}$、$\dot{\boldsymbol q}=\boldsymbol 0$，而期望位置 $\boldsymbol q_d=(0.01,\pi/2)^{\mathrm T}$、$\dot{\boldsymbol q}_d=\ddot{\boldsymbol q}_d=\boldsymbol 0$（故 $\tilde{\boldsymbol q}=(0.01,0)^{\mathrm T}\,\mathrm{rad},\ \dot{\tilde{\boldsymbol q}}=\boldsymbol 0$）。此时要求加速度 $\boldsymbol y=(0.25,0)^{\mathrm T}\,\mathrm{rad/s^2}$，控制律算得：

$$\boldsymbol u = \begin{bmatrix}5/3&1/3\\1/3&1/3\end{bmatrix}\begin{bmatrix}0.25\\0\end{bmatrix} + \begin{bmatrix}14.715\\0\end{bmatrix} \approx \begin{bmatrix}15.132\\0.0833\end{bmatrix}\,\mathrm{N\cdot m}.$$

虽然第 2 轴当前误差为零，控制器仍借助 $b_{21}=1/3$ 主动向第 2 轴施加 $0.0833\,\mathrm{N\cdot m}$ 前瞻抵消力矩，防止第 1 轴加速诱发连杆 2 偏离。闭环方程特征根为二重根 $\lambda_{1,2}=-5\,\mathrm{s^{-1}}$（临界阻尼衰减 $(a_i+b_i t)e^{-5t}$）；注意这是连续模型假设下结果，实际采样延迟、模型失配与限幅都会破坏完美对消。
:::

**逆动力学的工程失效边界**：(1) 模型失配 $\hat B\neq B,\hat{\boldsymbol n}\neq\boldsymbol n$ 留下未抵消扰动；(2) 每周期需用 $O(n)$ 牛顿–欧拉或矩阵算整机 $B,\boldsymbol n$；(3) 零阶保持离散化使连续消元产生 $O(T_s)$ 离散残差；(4) 忽视关节传动柔性与电枢延迟。

<a id="sec-7.3.5"></a>

## 7.3.4 鲁棒控制（基于 Lyapunov 再设计的滑模边界层方法）

当机械臂参数只掌握标称估计值 $(\hat B(\boldsymbol q),\hat{\boldsymbol n}(\boldsymbol q,\dot{\boldsymbol q}))$ 时，将实际动力学整理为标称模型加有界不确定广义力矩 $\boldsymbol\eta$:

$$B\ddot{\boldsymbol q}+\boldsymbol n = \hat B\ddot{\boldsymbol q}+\hat{\boldsymbol n}+\boldsymbol\eta,\qquad \boldsymbol\eta \triangleq (B-\hat B)\ddot{\boldsymbol q} + (\boldsymbol n-\hat{\boldsymbol n}).$$

在标称逆动力学结构中附加外加鲁棒力矩项 $\boldsymbol\omega$：

$$\boldsymbol u = \hat B(\boldsymbol q)\boldsymbol y + \hat{\boldsymbol n}(\boldsymbol q,\dot{\boldsymbol q}) + \boldsymbol\omega,\qquad \boldsymbol y = \ddot{\boldsymbol q}_d + K_D\dot{\tilde{\boldsymbol q}} + K_P\tilde{\boldsymbol q}.\tag{7.3-12}$$

代入系统并记状态向量 $\boldsymbol\xi=[\tilde{\boldsymbol q}^{\mathrm T},\,\dot{\tilde{\boldsymbol q}}^{\mathrm T}]^{\mathrm T}\in\mathbb R^{2n}$，即得受扰线性误差状态方程：

$$\dot{\boldsymbol\xi} = A\boldsymbol\xi + D\hat B^{-1}(\boldsymbol\eta-\boldsymbol\omega),\qquad A = \begin{bmatrix}O&I\\-K_P&-K_D\end{bmatrix},\quad D = \begin{bmatrix}O\\I\end{bmatrix}.$$

::: thm 定理 7.3.C · 鲁棒滑模切换律与边界层一致最终有界性（UUB）
因 $K_P,K_D\succ 0$，矩阵 $A$ 为 Hurwitz 稳定阵。对任意对称正定阵 $P=P^{\mathrm T}\succ 0$，解 Lyapunov 方程 $A^{\mathrm T}Q+QA=-P$ 得唯一对称正定解 $Q=Q^{\mathrm T}\succ 0$，构造力矩型切换矢量 $\boldsymbol z=\hat B^{-\mathrm T}D^{\mathrm T}Q\boldsymbol\xi$。设工作域内不确定界 $\rho\ge\|\boldsymbol\eta\|$ 已知，为消除理想不连续切换律（$\boldsymbol\omega=\rho\boldsymbol z/\|\boldsymbol z\|$）引发的高频抖振，引入厚度 $\varepsilon>0$ 的边界层：

$$\boldsymbol\omega = \begin{cases}
\dfrac{\rho}{\|\boldsymbol z\|}\boldsymbol z, & \|\boldsymbol z\|\ge\varepsilon,\\[6pt]
\dfrac{\rho}{\varepsilon}\boldsymbol z, & \|\boldsymbol z\|<\varepsilon.
\end{cases} \tag{7.3-14}$$

沿闭环轨线取 $V(\boldsymbol\xi)=\boldsymbol\xi^{\mathrm T}Q\boldsymbol\xi$，全状态空间恒满足 $\dot V \le -\lambda_{\min}(P)\|\boldsymbol\xi\|^2 + \frac{\rho\varepsilon}{2}$，从而保证跟踪误差 $\boldsymbol\xi$ **一致最终有界（Uniformly Ultimately Bounded, UUB）**。
:::

::: sol 证明关键步（力矩型 $\boldsymbol z$ 的严格推导）
求导并代入误差状态方程：

$$\dot V = \boldsymbol\xi^{\mathrm T}(A^{\mathrm T}Q+QA)\boldsymbol\xi + 2\boldsymbol\xi^{\mathrm T}QD\hat B^{-1}(\boldsymbol\eta-\boldsymbol\omega) = -\boldsymbol\xi^{\mathrm T}P\boldsymbol\xi + 2\boldsymbol z^{\mathrm T}(\boldsymbol\eta-\boldsymbol\omega).$$

- 在边界层外（$\|\boldsymbol z\|\ge\varepsilon$）：$2\boldsymbol z^{\mathrm T}(\boldsymbol\eta-\frac{\rho}{\|\boldsymbol z\|}\boldsymbol z) \le 2\|\boldsymbol z\|(\|\boldsymbol\eta\|-\rho)\le 0 \implies \dot V \le -\lambda_{\min}(P)\|\boldsymbol\xi\|^2$；
- 在边界层内（$\|\boldsymbol z\|<\varepsilon$）：记 $r=\|\boldsymbol z\|\in[0,\varepsilon)$，代入线性增益律得

$$2\boldsymbol z^{\mathrm T}\!\left(\boldsymbol\eta-\frac{\rho}{\varepsilon}\boldsymbol z\right) \le 2\rho\left(r-\frac{r^2}{\varepsilon}\right) = 2\rho\left[\frac{\varepsilon}{4}-\frac{1}{\varepsilon}\left(r-\frac{\varepsilon}{2}\right)^2\right] \le \frac{\rho\varepsilon}{2}.$$

当 $\|\boldsymbol\xi\| > \sqrt{\rho\varepsilon/[2\lambda_{\min}(P)]}$ 时必有 $\dot V<0$，误差被压回并在有限半径椭球内滞留（注意采用外加力矩型 (7.3-12) 时，$\boldsymbol z$ 不可略去 $\hat B^{-\mathrm T}$ 因子）。
:::

<a id="sec-7.3.6"></a>

## 7.3.5 自适应控制（在线估计惯性参数）

如果不止要抵抗固定上界，而希望借在线参数调节实现精确零误差跟踪，则调用[6.2.2 节](../ch06/sec6-2.md#part-6.2.2)的参数线性回归结构 $Y\boldsymbol\pi$。令 $\Lambda=\operatorname{diag}\{\lambda_1,\dots,\lambda_n\}\succ 0$，定义免测加速度的**参考速度** $\dot{\boldsymbol q}_r$ 与**复合误差** $\boldsymbol\sigma$：

$$\dot{\boldsymbol q}_r = \dot{\boldsymbol q}_d + \Lambda\tilde{\boldsymbol q},\qquad \boldsymbol\sigma = \dot{\boldsymbol q}_r - \dot{\boldsymbol q} = \dot{\tilde{\boldsymbol q}} + \Lambda\tilde{\boldsymbol q}. \tag{7.3-16}$$

以 $(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)$（完全不含实测 $\ddot{\boldsymbol q}$）构造线性回归式 $B\ddot{\boldsymbol q}_r+C\dot{\boldsymbol q}_r+F\dot{\boldsymbol q}_r+\boldsymbol g = Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)\boldsymbol\pi$，并设计自适应控制律与参数更新律（$K_D\succ 0$ 正对角，$K_\pi=K_\pi^{\mathrm T}\succ 0$）：

$$\boxed{\ \boldsymbol u = Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)\hat{\boldsymbol\pi} + K_D\boldsymbol\sigma,\qquad \dot{\hat{\boldsymbol\pi}} = K_\pi^{-1}Y^{\mathrm T}(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)\boldsymbol\sigma\ } \tag{7.3-17, 7.3-18}$$

::: thm 定理 7.3.D · 直接自适应控制跟踪收敛与参数辨识边界
在精确未知定常参数回归结构成立、$b_*I\preceq B(\boldsymbol q)\preceq b^*I$、期望轨迹有界连续及 Christoffel 阵满足 $\dot B-2C$ 反对称前提下，闭环系统确保：
1. 参数估计 $\hat{\boldsymbol\pi}$ 与全部状态信号全局一致有界；
2. 关节跟踪与速度误差均渐近趋零：$\lim_{t\to\infty}\tilde{\boldsymbol q}(t)=\boldsymbol 0,\ \lim_{t\to\infty}\dot{\tilde{\boldsymbol q}}(t)=\boldsymbol 0$；
3. **关键边界**：直接自适应**不保证**参数收敛到真值（$\hat{\boldsymbol\pi}\to\boldsymbol\pi$ 还额外要求期望轨迹满足**持续激励 PE 条件**）。
:::

::: sol 证明骨架（含显式位置误差 Lyapunov 构造 + Barbalat 引理）
由 $\dot{\boldsymbol q}=\dot{\boldsymbol q}_r-\boldsymbol\sigma$ 代入系统并补配 $Y\boldsymbol\pi$ 得复合误差方程 $B\dot{\boldsymbol\sigma}+C\boldsymbol\sigma+(F+K_D)\boldsymbol\sigma = -Y\tilde{\boldsymbol\pi}$（$\tilde{\boldsymbol\pi}=\hat{\boldsymbol\pi}-\boldsymbol\pi$）。取

$$V_a(\boldsymbol\sigma,\tilde{\boldsymbol q},\tilde{\boldsymbol\pi}) = \frac12\boldsymbol\sigma^{\mathrm T}B(\boldsymbol q)\boldsymbol\sigma + \tilde{\boldsymbol q}^{\mathrm T}\Lambda K_D\tilde{\boldsymbol q} + \frac12\tilde{\boldsymbol\pi}^{\mathrm T}K_\pi\tilde{\boldsymbol\pi}.$$

求导并分别借助 $\dot B-2C$ 反对称性消去 $\frac12\boldsymbol\sigma^{\mathrm T}(\dot B-2C)\boldsymbol\sigma$ 及更新律 (7.3-18) 消去 $\tilde{\boldsymbol\pi}^{\mathrm T}(K_\pi\dot{\hat{\boldsymbol\pi}}-Y^{\mathrm T}\boldsymbol\sigma)$，展开交叉项得

$$\dot V_a = -\boldsymbol\sigma^{\mathrm T}F\boldsymbol\sigma - \dot{\tilde{\boldsymbol q}}^{\mathrm T}K_D\dot{\tilde{\boldsymbol q}} - \tilde{\boldsymbol q}^{\mathrm T}\Lambda K_D\Lambda\tilde{\boldsymbol q} \le 0.$$

由于轨迹时变（非自治系统），不能直接套用自治 LaSalle 原理，而必须调用 **Barbalat 引理**：由 $V_a\ge 0,\ \dot V_a\le 0$ 推出 $\boldsymbol\sigma,\tilde{\boldsymbol q},\tilde{\boldsymbol\pi},\dot{\tilde{\boldsymbol q}}$ 全有界，代回方程证 $\dot{\boldsymbol\sigma},\ddot{\tilde{\boldsymbol q}}\in\mathcal L_\infty$ 从而 $\ddot V_a\in\mathcal L_\infty$（即 $\dot V_a$ 一致连续），最终证明 $\lim_{t\to\infty}\dot V_a(t)=0 \implies \tilde{\boldsymbol q}\to\boldsymbol 0,\ \dot{\tilde{\boldsymbol q}}\to\boldsymbol 0$。
:::

<a id="sec-7.3.7"></a>

## 本节小结

- **集中四档递进对照**：

| 控制律 | 核心算式 | 适用任务与假设 | 关键短板 / 边界 |
|:--|:--|:--|:--|
| 重力补偿 PD | $\boldsymbol u=\boldsymbol g(\boldsymbol q)+K_P\tilde{\boldsymbol q}-K_D\dot{\boldsymbol q}$ | **固定点位**镇定；实测角算 $\boldsymbol g$ | 仅对固定目标证得稳定；动态耦合大时跟踪差 |
| 逆动力学 | $\boldsymbol u=B(\boldsymbol q)(\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q})+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})$ | 精确整机模型高精度轨迹跟踪 | 对参数失配 $\hat B\neq B$ 及零阶保持延迟极敏感 |
| 鲁棒滑模 | $\boldsymbol u=\hat B\boldsymbol y+\hat{\boldsymbol n}+\boldsymbol\omega$（$\boldsymbol z=\hat B^{-\mathrm T}D^{\mathrm T}Q\boldsymbol\xi$） | 已知力矩扰动上界 $\rho\ge\|\boldsymbol\eta\|$ | 边界层以有界误差（UUB）换取消振 |
| 自适应控制 | $\boldsymbol u=Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)\hat{\boldsymbol\pi}+K_D\boldsymbol\sigma$ | 未知定常参数线性回归，免测 $\ddot{\boldsymbol q}$ | 只证误差趋零；参数辨识到真值须满足持续激励 PE |

::: note 主线 · 两连杆（第八关 · 闭环反馈消项）
沿用例 7.3.1 将同一套两连杆模型代回闭环计算力矩律，消去 $B,C,\boldsymbol g$ 后即得出完全解耦误差方程 $\ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e=\boldsymbol 0$，并在[两连杆训练第八关](../training/two-link.md#mission-feedback)完成全书两连杆主线八关闭环。
:::

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 57:50 | [centralized-intro.jpg](../assets/ch07/centralized-intro.jpg) | 集中控制四方法框架 | 7.3 开篇梳理阶梯关系与适用定位 |
| 60:40 | [lyapunov.jpg](../assets/ch07/lyapunov.jpg) | 二次型 Lyapunov 与 LaSalle 原理 | 7.3.1 系统总结方法论边界 |
| 72:00 | [gravity-pd-V.jpg](../assets/ch07/gravity-pd-V.jpg) | 重力补偿 PD 的 $V$ 构造 | 定理 7.3.A 第 1 步详细推导 |
| 74:50 | [gravity-pd-Vdot.jpg](../assets/ch07/gravity-pd-Vdot.jpg) | $\dot B-2C$ 消项与不变集 | 定理 7.3.A 第 2–3 步完整证明 |
| 84:50 | [inverse-dynamics.jpg](../assets/ch07/inverse-dynamics.jpg) | 逆动力学内外双回路 | 7.3.3 导出式 (7.3-9)–(7.3-10) + 例 7.3.1 数值验算 |
| 99:10 | [robust-law.jpg](../assets/ch07/robust-law.jpg) | 鲁棒控制三部分结构 | 7.3.4 给出式 (7.3-12) 并严格保留 $\hat B^{-\mathrm T}$ |
| 104:50 | [sliding-subspace.jpg](../assets/ch07/sliding-subspace.jpg) | 滑动子空间与切换律 | 定理 7.3.C 并入几何与代数阐述 |
| 105:40 | [boundary-layer.jpg](../assets/ch07/boundary-layer.jpg) | 边界层消除抖振 | 式 (7.3-14) + UUB 半径严谨推导 |
| 108:10 | [adaptive-linearity.jpg](../assets/ch07/adaptive-linearity.jpg) | 参数线性化回归接口 | 7.3.5 衔接 6.2.2 并引入 $\dot{\boldsymbol q}_r$ 免测加速度 |
| 114:10 | [adaptive-lyapunov.jpg](../assets/ch07/adaptive-lyapunov.jpg) | 自适应含位置项的 Lyapunov 证明 | 定理 7.3.D 完整给出含摩擦证明与 Barbalat 论证 |
| 117:40 | [adaptive-structure.jpg](../assets/ch07/adaptive-structure.jpg) | 自适应控制律结构图 | 小结对照表中给出前馈/PD/更新三部分分工 |
:::
