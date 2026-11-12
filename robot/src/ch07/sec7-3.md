# 7.3 集中控制

高速运动或直接驱动时，关节间的耦合可能无法再作为小扰动处理。集中控制利用整机状态和动力学模型计算各关节输入。本节从重力补偿开始，用能量函数分析稳定性，然后分别讨论模型精确、误差有界和参数未知时的控制设计。对应录播 00:56:32–01:58:20、课件 §8.5。

控制输入统一记作 $u=\tau$。合并项 $n(q,\dot q)$ 表速度耦合、所选摩擦模型和重力，与关节数 $n$ 区分。误差始终取 $e=\tilde q=q_d-q$，因此每个正负号都可从代回动力学核对。

<a id="sec-7.3.1"></a>

## 7.3.1 为什么需要集中控制

当残余耦合超出单轴反馈允许的范围，可以利用多轴状态和整机模型显式补偿。高速、大加速度和直接驱动都值得重点验算，但不能仅按工况标签断言分散控制一定失效。



“集中”指各关节输入依赖多轴信息和整机模型，运算并不必集中在一颗处理器上。它也不要求测得实际加速度：控制器可以先构造虚拟加速度，再将它输入逆动力学，后面将按此实现。

集中控制的四种方法，按「用模型用到什么程度」排列：

| 方法 | 补偿什么 | 模型要求 | 适用 |
|:--|:--|:--|:--|
| 重力补偿 PD | $\boldsymbol g(\boldsymbol q)$ | 只需重力项 | 点对点、低速 |
| 逆动力学控制 | $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g$ 全部 | 整机模型精确 | 高速高精度跟踪 |
| 鲁棒控制 | 全部 + **不确定项上界** | 模型 + 误差界 | 有界扰动、参数慢变 |
| 自适应控制 | 全部 + **参数在线估计** | 模型结构已知、参数未知 | 负载/参数变化 |

<a id="sec-7.3.2"></a>

## 7.3.2 李雅普诺夫稳定性：够用的版本

稳定性分析要说明：从目标附近稍有偏离时，闭环运动能否保持接近，并最终回到目标。下面选取类似能量的函数 $V$，通过它沿闭环轨迹的变化研究误差。这个函数不必等于真实物理能量。录播00:58:00–01:10:40介绍了这一工具。

考虑自治系统 $\dot{\boldsymbol e}=f(\boldsymbol e)$，平衡点为零。这里 $\boldsymbol e$ 代表完整误差状态；二阶机器人系统通常要同时包含位置误差和速度。假设 $f$ 局部 Lipschitz，存在连续可微函数 $V$，在原点邻域内满足

$$V(0)=0,\qquad V(\boldsymbol e)>0\ (\boldsymbol e\neq0),\qquad
\dot V(\boldsymbol e)<0\ (\boldsymbol e\neq0),\tag{7.3-1}$$

则原点局部渐近稳定。要推出全局渐近稳定，一组常用的充分条件是：系统与上述不等式在整个 $\mathbb R^n$ 上成立，并且 $V$ 径向无界，即 $\|\boldsymbol e\|\to\infty$ 时 $V\to\infty$。这个条件把轨迹限制在有界子水平集中。只写“能量一直下降”，还不足以保证状态不会逃向无穷远。

先看一个可直接验算的标量例子：$\dot e=-2e$，取 $V=e^2/2$，则 $\dot V=e\dot e=-2e^2<0$（$e\ne0$）。判断下降时，必须把闭环方程代入导数，不能只看 $V$ 本身的形状。

多维系统常用二次型：

$$V(\boldsymbol e)=\boldsymbol e^{\mathrm T}Q\boldsymbol e,\qquad Q=Q^{\mathrm T}\succ0
\quad\Longrightarrow\quad
\dot V=2\boldsymbol e^{\mathrm T}Qf(\boldsymbol e).\tag{7.3-2}$$



很多机器人系统只能得到 $\dot V\le0$，例如 $\dot V=-\dot{\boldsymbol q}^{\mathrm T}K_D\dot{\boldsymbol q}$。机械臂停在错误位置的一瞬间，速度也是零，因而 $\dot V=0$；但位置反馈随后会让它动起来。证明时必须区分“此刻不动”和“以后一直不动”。

拉萨尔不变性原理处理这个区别。在自治系统的紧致正向不变集上，若 $\dot V\le0$，轨迹趋向 $\dot V=0$ 集合内的最大不变集。对下面的重力补偿 PD，可按以下步骤检查：

1. 用 $V$ 的子水平集证明轨迹有界，并且不会离开这个集合。
2. 在 $\dot V=0$ 的候选状态中，要求 $\dot q\equiv0$，再代回闭环方程，求出能够一直保持静止的状态。
3. 若只剩目标平衡点，才得到位置和速度误差都趋于零。不能直接由 $\dot V\le0$ 跳到速度收敛。

::: intuition 回用第六章的结构性质
下面用位置误差 $\tilde q=q_d-q$ 构造 $V=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}+\frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}$。求导后会出现 $\dot B-2C$；第六章证明的[反对称性](../recall.md#christoffel)让相应二次型消失。先试着找到这一项，再看下一段的完整计算。
:::

<a id="sec-7.3.3"></a>

## 7.3.3 固定目标的重力补偿PD

先取固定目标 $q_d$，使用 $B\ddot q+C\dot q+F\dot q+g=u$，其中 $F\succeq0$ 是对称黏性摩擦矩阵，$C$ 采用第六章满足能量恒等式的表示。所需的是位置调节结论，暂不加入移动参考。




取误差 $\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$，构造

$$V(\dot{\boldsymbol q},\tilde{\boldsymbol q})
=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}
+\frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}>0
\quad\bigl((\dot{\boldsymbol q},\tilde{\boldsymbol q})\neq(0,0)\bigr).\tag{7.3-3}$$

对时间求导，注意 $\boldsymbol q_d$ 是常数（$\dot{\boldsymbol q}_d=0$，$\dot{\tilde{\boldsymbol q}}=-\dot{\boldsymbol q}$）：

$$\dot V=\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\ddot{\boldsymbol q}
+\frac12\dot{\boldsymbol q}^{\mathrm T}\dot B(\boldsymbol q)\dot{\boldsymbol q}
-\dot{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}.\tag{7.3-4}$$

用动力学方程解出 $B\ddot{\boldsymbol q}$ 代进去：

$$\dot V=\frac12\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B(\boldsymbol q)-2C(\boldsymbol q,\dot{\boldsymbol q})\bigr)\dot{\boldsymbol q}
-\dot{\boldsymbol q}^{\mathrm T}F\dot{\boldsymbol q}
+\dot{\boldsymbol q}^{\mathrm T}\bigl(\boldsymbol u-\boldsymbol g(\boldsymbol q)-K_P\tilde{\boldsymbol q}\bigr).\tag{7.3-5}$$



**第一项为零**：第六章的能量恒等式使相应二次型消失；采用Christoffel选法时，也可由 $\dot B-2C$ 的反对称性验证。于是取控制律

$$\boxed{\ \boldsymbol u=\boldsymbol g(\boldsymbol q)+K_P\tilde{\boldsymbol q}-K_D\dot{\boldsymbol q}\ }\tag{7.3-6}$$

这里 $K_P,K_D$ 对称[正定](../recall.md#positive)，$F$ 对称半正定。由于目标固定，$\dot{\tilde q}=-\dot q$，所以阻尼项也可写成 $+K_D\dot{\tilde q}$。若用实际速度 $\dot q$，必须取负号。可以用一个瞬间检查：已到目标但仍向正方向运动时，阻尼应产生反向力矩。

代回得

$$\dot V=-\dot{\boldsymbol q}^{\mathrm T}(F+K_D)\dot{\boldsymbol q}\le0.\tag{7.3-7}$$

假设采用无关节限位的展开坐标 $q\in\mathbb R^n$、模型光滑、重力补偿精确且驱动力矩不限幅，并有 $B(q)\succeq b_*I$（常数 $b_*>0$）。则 $V$ 径向无界，其子水平集紧致且正向不变。$\dot V=0$ 要求 $\dot q=0$；若要一直保持在该集合内，还必须有 $\ddot q=0$。代回闭环方程，得 $K_P\tilde q=0$，故最大不变集只有目标平衡点。于是该理想模型在这些坐标与假设下全局渐近稳定。

上述结论以固定目标、当前构形处的准确重力和可实现力矩为前提。目标移动时，$\dot e=\dot q_d-\dot q$，能量导数增加参考运动项，须重新分析。对于固定目标，也不能仅因速度较高就否定这个理想模型的位置调节稳定性；还需分别检查动态指标与执行器限制。

例如重力估计少补0.2 N·m，局部近似为常偏差 $\delta g$。静止时有 $K_Pe=\delta g$，标量刚度20 N·m/rad对应0.01 rad的残余误差。反馈能提供保持力矩，但“精确补偿后零偏差”的结论已经改变。

<a id="sec-7.3.4"></a>

## 7.3.4 逆动力学控制：把非线性整块抵消

跟踪轨迹时，$\boldsymbol q_d(t)$ 不是常数。课件把机器人方程写成

$$B(\boldsymbol q)\ddot{\boldsymbol q}+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})=\boldsymbol u,
\qquad
\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})
=C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+F\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q).\tag{7.3-8}$$

**思路分两步**（课件 §8.5.2，图 7.3-4）：

1. **非线性补偿**：令 $\boldsymbol u=B(\boldsymbol q)\boldsymbol y+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})$，
   代回得 $\ddot{\boldsymbol q}=\boldsymbol y$——原来的非线性对象变成了 $n$ 个双积分器；
2. **线性控制**：对双积分器取
   $\boldsymbol y=\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}$。

{{#include ../assets/figures/robot-control.md}}

合起来就是**逆动力学控制律**（也叫计算力矩控制）：

$$\boxed{\ \boldsymbol u=B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d
+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}\bigr)
+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})\ }\tag{7.3-9}$$



代入 (7.3-8)，$B$ 可逆（第六章性质一：对称正定），得

$$\ddot{\boldsymbol q}=\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}
\quad\Longrightarrow\quad
\boxed{\ \ddot{\tilde{\boldsymbol q}}+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}=0\ }\tag{7.3-10}$$

模型精确且无饱和时，得到常系数线性二阶误差系统。对角正增益才可逐关节看成互不耦合的标量方程；一般常对称正定增益仍给稳定系统，但各坐标未必彼此独立。实际结论还须满足模型、状态和执行器假设。

这里括号内是加速度，故反馈增益 $K_P$ 的单位为 $\mathrm{s^{-2}}$、$K_D$ 为 $\mathrm{s^{-1}}$；上一段直接加到力矩上的PD刚度与阻尼不是这组单位。若取对角增益 $K_P=\operatorname{diag}(\omega_i^2)$、$K_D=\operatorname{diag}(2\zeta_i\omega_i)$，就能逐轴指定理想误差极点。

前馈和反馈线性化的模型输入及反馈作用位置不同：

| | 计算转矩前馈 | 逆动力学控制 |
|:--|:--|:--|
| 模型自变量 | $\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d$ | $\boldsymbol q,\dot{\boldsymbol q}$ |
| 非线性补偿 | 按期望状态计算，偏离参考时可能留有残差 | 按实际状态计算，精确性依赖模型与执行假设 |
| 计算 | 可离线预算 | 每周期在线算 $B,\boldsymbol n$ |
| 本质 | 前馈 | 反馈线性化 |

这种线性化由实际状态参与非线性补偿实现，并非在某工作点取一阶近似。模型准确、状态可用和力矩可执行仍是前提；加入采样、计算延迟与驱动动态后，应重新验证离散闭环，不能假定每次采样都能精确抵消。

实现时可把 $y$ 作为加速度参数调用[牛顿–欧拉逆动力学](../ch06/sec6-4.md)，直接计算 $By+n$，未必需要显式构造整个 $B$。模型不准的情形则由下一段重新建立误差项。

<a id="sec-7.3.5"></a>

## 7.3.5 鲁棒控制：模型不准，但知道不准多少

鲁棒控制先规定不确定量的范围，再设计反馈。为把符号与证明讲完整，这里先取**惯性矩阵 $B$ 已知、其余合并项 $n$ 只有估计 $\hat n$** 的模型；它足以说明鲁棒项的方向。惯量也未知时，需要额外处理输入增益不确定性，不能只沿用同一个界。

取 $e=q_d-q$、$\xi=[e;\dot e]\in\mathbb R^{2n}$，$y=\ddot q_d+K_D\dot e+K_Pe$。定义力矩不确定量与控制律：

$$\eta=n-\hat n,\qquad \|\eta\|\le\rho,\qquad
u=By+\hat n+\omega.\tag{7.3-11}$$

$\omega\in\mathbb R^n$ 是附加力矩，不是本节的角速度；$\rho$ 与 $\eta$ 采用相同的力矩尺度。代回 $B\ddot q+n=u$，逐项移式：

$$\ddot e=-K_D\dot e-K_Pe+B^{-1}(\eta-\omega),\qquad
\dot\xi=A\xi+D(q)(\eta-\omega),\tag{7.3-12}$$

$$A=\begin{bmatrix}0&I\\-K_P&-K_D\end{bmatrix},\qquad
D(q)=\begin{bmatrix}0\\B(q)^{-1}\end{bmatrix}.$$

$A$ 为 $2n\times2n$，$D$ 为 $2n\times n$。取稳定的正定增益，指定 $P\succ0$，解 Lyapunov 方程 $A^{\mathrm T}Q+QA=-P$ 得 $Q\succ0$。对 $V=\xi^{\mathrm T}Q\xi$ 求导，令 $z=D^{\mathrm T}Q\xi$：

$$\dot V=-\xi^{\mathrm T}P\xi+2z^{\mathrm T}(\eta-\omega).$$

能量导数确定了附加力矩的方向。对 $z\ne0$，取

$$\omega=\rho\frac{z}{\|z\|}.\tag{7.3-13}$$

由 Cauchy–Schwarz，$z^{\mathrm T}\eta\le\rho\|z\|=z^{\mathrm T}\omega$，所以 $\dot V\le-\xi^{\mathrm T}P\xi$。这是符号和增益的依据；不能只说“取很大的 $\rho$ 就稳定”。$z=0$ 时这个表达式不能做除法，理想不连续设计须按集合值/滑模解解释，普通程序应使用下面的连续近似。

取 $\varepsilon>0$，令

$$\omega=\begin{cases}\rho z/\|z\|,&\|z\|\ge\varepsilon,\\
\rho z/\varepsilon,&\|z\|<\varepsilon.
\end{cases}\tag{7.3-14}$$

边界层内，记 $r=\|z\|$，额外项至多为 $2\rho(r-r^2/\varepsilon)\le\rho\varepsilon/2$，故

$$\dot V\le-\lambda_{\min}(P)\|\xi\|^2+\rho\varepsilon/2.$$

令 $c=\rho\varepsilon/2$，利用 $V\le\lambda_{\max}(Q)\|\xi\|^2$，可进一步得到

$$\dot V\le-\alpha V+c,\qquad\alpha=\frac{\lambda_{\min}(P)}{\lambda_{\max}(Q)}.$$

将不等式乘以 $e^{\alpha t}$ 再积分，得 $V(t)\le e^{-\alpha t}V(0)+(c/\alpha)(1-e^{-\alpha t})$。又由 $V\ge\lambda_{\min}(Q)\|\xi\|^2$，可读出

$$\limsup_{t\to\infty}\|\xi(t)\|\le\sqrt{\frac{\rho\varepsilon\lambda_{\max}(Q)}{2\lambda_{\min}(P)\lambda_{\min}(Q)}}.$$

这个最终界包含二次型的尺度。条件 $\|z\|<\varepsilon$ 约束的是映射后的量，不能直接读为位置误差小于 $\varepsilon$，两者的维度与映射不同。边界层越小，连续近似越陡，也会对噪声和执行器带宽更敏感。





实际使用前须核对：不确定界是否在所选区域与输入范围内成立，$B$ 或其界是否已知，力矩是否饱和，离散采样与传感噪声是否破坏假设。本段证明的是明确定义的简化模型，不是所有未知惯量机械臂的通用保证。

<a id="sec-7.3.6"></a>

## 7.3.6 自适应控制：参数在线改，控制器跟着变

前面的鲁棒设计使用预先给定的不确定界；自适应设计则在线更新参数估计，使补偿随之改变。下面利用第六章的动力学参数线性性，推导控制律与配套更新律：

$$\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi,\tag{7.3-15}$$

$Y$ 是已知回归矩阵，$\pi$ 是未知常参数向量。它通常选取质量、质量与质心距离的乘积、惯量组合等；不是把每个质心坐标与质量都任意当成彼此独立的线性参数。



**先写明本段模型与回归矩阵。** 为集中解释更新律，取无接触、忽略摩擦或已精确补偿摩擦的刚体模型 $B\ddot q+C\dot q+g=u$。沿用[参数线性性](../ch06/sec6-2-2.md)与[Christoffel 恒等式](../recall.md#christoffel)。定义

$$\dot q_r=\dot q_d+\Lambda e,\qquad
\ddot q_r=\ddot q_d+\Lambda\dot e,\qquad
\sigma=\dot q_r-\dot q=\dot e+\Lambda e,\quad\Lambda\succ0.\tag{7.3-16}$$

$\dot q_r$ 是人为构造的参考速度；$\sigma$ 为滤波后的跟踪误差，**不是速度测量本身**。所需回归矩阵 $Y_r$ 按下式定义：

$$Y_r\pi=B(q)\ddot q_r+C(q,\dot q)\dot q_r+g(q).$$

其中 $C$ 仍由**实际** $q,\dot q$ 计算，只将它所乘的速度换成 $\dot q_r$；不是把全部实际状态都换成期望状态。控制与更新取

$$u=Y_r\hat\pi+K_D\sigma,\qquad
\dot{\hat\pi}=K_\pi^{-1}Y_r^{\mathrm T}\sigma,\quad K_D,K_\pi\succ0.\tag{7.3-17}$$

$\hat\pi$ 为估计参数，$\tilde\pi=\hat\pi-\pi$；参数假定恒定，故 $\dot{\tilde\pi}=\dot{\hat\pi}$。先推误差动力学：$B\dot\sigma+C\sigma=B\ddot q_r+C\dot q_r+g-u$，所以

$$B\dot\sigma+C\sigma=-Y_r\tilde\pi-K_D\sigma.\tag{7.3-18}$$

现在取仅含两部分的候选函数：

$$V=\tfrac12\sigma^{\mathrm T}B\sigma+\tfrac12\tilde\pi^{\mathrm T}K_\pi\tilde\pi.\tag{7.3-19}$$

逐项求导并代回误差方程：

$$\begin{aligned}
\dot V&=\sigma^{\mathrm T}(B\dot\sigma+C\sigma)
+\tfrac12\sigma^{\mathrm T}(\dot B-2C)\sigma
+\tilde\pi^{\mathrm T}K_\pi\dot{\hat\pi}\\
&=-\sigma^{\mathrm T}K_D\sigma
+\tilde\pi^{\mathrm T}(K_\pi\dot{\hat\pi}-Y_r^{\mathrm T}\sigma)
=-\sigma^{\mathrm T}K_D\sigma\le0.
\end{aligned}\tag{7.3-20}$$

第二行分别包含跟踪耗散项与参数误差交叉项，更新律恰好抵消后者。更新律的正号与本段 $e=q_d-q$、$\tilde\pi=\hat\pi-\pi$ 的定义配套；若改变误差方向，就必须重新推导符号。

在期望轨迹及所需导数有界、惯性一致正定、闭环信号及 $\dot\sigma$ 有界等条件下，$V$ 有界且 $\int_0^\infty\|\sigma\|^2dt<\infty$。由一致连续性与 Barbalat 引理可得 $\sigma\to0$；再看 $\dot e+\Lambda e=\sigma$，这是以趋零信号驱动的稳定线性系统，故 $e,\dot e\to0$。有时变参考时，不能直接不加条件地套自治系统的 LaSalle 结论。





参考速度 $\dot q_r$ 与参考加速度 $\ddot q_r$ 来自期望运动、位置误差和速度误差，所以这条控制律不要求测量实际关节加速度。它仍需要可用的 $q,\dot q$、正确的回归结构及上述有界性条件。

跟踪收敛与参数辨识是两个结论。即使 $e\to0$，一段运动也可能不足以区分不同参数组合，$\hat\pi$ 不必收敛到真值。进一步辨识需要可辨识的参数选择和足够激励；持续激励不是本段跟踪收敛证明的前提。理想模型已由 $V$ 保证参数误差有界，不能反过来宣称估计必然无限漂移。

<a id="sec-7.3.7"></a>

## 7.3.7 实现要点与小结

重力补偿 PD 用实际构形补重力；逆动力学在精确模型下进一步指定加速度。鲁棒控制需要明确的不确定界，自适应控制需要参数线性结构和适当更新律。它们的收敛证明各有假设，不能仅按补偿项多少排列优劣。
