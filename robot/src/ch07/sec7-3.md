# 7.3 集中控制

课件 §8.5，**全部是课堂内容**（录播 00:56:32–01:58:20）。这一节是本章最长、理论密度最高的
一段：先说明为什么分散控制不够用，再补一段**李雅普诺夫稳定性**的最小预备知识，然后依次给出
四种集中控制律——**重力补偿 PD、逆动力学、鲁棒、自适应**。它们的关系是一条线：
从「只补重力」到「全补模型」，再到「模型不准时怎么办」。

<a id="sec-7.3.1"></a>

## 7.3.1 为什么需要集中控制

**集中控制的起因**：7.2 中的分散控制方法本质上将关节间的动力学耦合视为外部干扰，并试图依靠局部反馈控制器的鲁棒性进行压制。然而在以下两种工况中，这一策略面临局限：

1. **高动态运行**：当操作速度或加速度较大时，非线性耦合项（如 $C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}$ 和 $\Delta B\ddot{\boldsymbol q}$）随运动状态剧烈变化，导致此时的耦合效应可能超出分散控制器的抑制能力。
2. **特殊结构**：如无大传动比减速器的直接驱动系统，缺乏足够的减速比来将电机侧的惯量效应放大，从而无法有效减弱关节间的耦合。

**集中控制的本质**：不再将耦合项视为待抑制的干扰，而是利用机械手的完整动力学模型进行显式计算，并将这些耦合项直接在控制律中进行补偿。控制器不再是分散的 $n$ 个独立回路，而是基于整机动力学的多输入多输出整体设计。

::: note 「集中」意味着信息聚合
为了按整机模型补偿耦合，控制器需要相关关节的状态信息；具体需要哪些测量量取决于控制律。例如本节的逆动力学控制使用实测 $\boldsymbol q,\dot{\boldsymbol q}$ 和期望加速度，并不要求实测关节加速度。模型准确时才能精确对消耦合项。
:::

集中控制的四种方法，按「用模型用到什么程度」排列：

| 方法 | 补偿什么 | 模型要求 | 适用 |
|:--|:--|:--|:--|
| 重力补偿 PD | $\boldsymbol g(\boldsymbol q)$ | 只需重力项 | 点对点、低速 |
| 逆动力学控制 | $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g$ 全部 | 整机模型精确 | 高速高精度跟踪 |
| 鲁棒控制 | 全部 + **不确定项上界** | 模型 + 误差界 | 有界扰动、参数慢变 |
| 自适应控制 | 全部 + **参数在线估计** | 模型结构已知、参数未知 | 负载/参数变化 |

<a id="sec-7.3.2"></a>

## 7.3.2 李雅普诺夫稳定性：够用的版本

::: note 核心辨析：重力补偿 PD vs 逆动力学控制
重力补偿 PD 只补偿重力项；本节对固定目标 $q_d$ 给出的稳定性证明使用了 $\dot q_d=0$。它也可用于时变参考，但不能直接套用该证明。逆动力学控制使用完整模型跟踪时变轨迹，精确对消以模型准确等条件为前提。
:::


把机械臂停在目标位置附近，轻轻偏离一点，再放开。我们希望它能回到目标，也希望这种判断有证明。本节用一个类似能量的函数 $V$，检查闭环运动是否会持续消耗偏差对应的能量。这里的函数不一定就是实际物理能量。录播 00:58:00 至 01:10:40 介绍了这个工具。

考虑自治系统 $\dot{\boldsymbol e}=f(\boldsymbol e)$，平衡点为零。这里 $\boldsymbol e$ 代表完整误差状态；二阶机器人系统通常要同时包含位置误差和速度。假设 $f$ 局部 Lipschitz，存在连续可微函数 $V$，在原点邻域内满足

$$V(0)=0,\qquad V(\boldsymbol e)>0\ (\boldsymbol e\neq0),\qquad
\dot V(\boldsymbol e)<0\ (\boldsymbol e\neq0),\tag{7.3-1}$$

则原点局部渐近稳定。要推出全局渐近稳定，一组常用的充分条件是：系统与上述不等式在整个 $\mathbb R^n$ 上成立，并且 $V$ 径向无界，即 $\|\boldsymbol e\|\to\infty$ 时 $V\to\infty$。这个条件把轨迹限制在有界子水平集中。只写“能量一直下降”，还不足以保证状态不会逃向无穷远。

最常用的构造是**二次型**（图 7.3-2）：

$$V(\boldsymbol e)=\boldsymbol e^{\mathrm T}Q\boldsymbol e,\qquad Q=Q^{\mathrm T}\succ0
\quad\Longrightarrow\quad
\dot V=2\boldsymbol e^{\mathrm T}Qf(\boldsymbol e).\tag{7.3-2}$$

很多机器人系统只能得到 $\dot V\le0$，例如 $\dot V=-\dot{\boldsymbol q}^{\mathrm T}K_D\dot{\boldsymbol q}$。机械臂停在错误位置的一瞬间，速度也是零，因而 $\dot V=0$；但位置反馈随后会让它动起来。证明时必须区分“此刻不动”和“以后一直不动”。

拉萨尔不变性原理处理这个区别。在自治系统的紧致正向不变集上，若 $\dot V\le0$，轨迹趋向 $\dot V=0$ 集合内的最大不变集。对下面的重力补偿 PD，可按以下步骤检查：

1. 用 $V$ 的子水平集证明轨迹有界，并且不会离开这个集合。
2. 在 $\dot V=0$ 的候选状态中，要求 $\dot q\equiv0$，再代回闭环方程，求出能够一直保持静止的状态。
3. 若只剩目标平衡点，才得到位置和速度误差都趋于零。不能直接由 $\dot V\le0$ 跳到速度收敛。

::: intuition 回用第六章的结构性质
下面用位置误差 $\tilde q=q_d-q$ 构造 $V=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}+\frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}$。求导后会出现 $\dot B-2C$；第六章证明的反对称性让相应二次型消失。先试着找到这一项，再看下一段的完整计算。
:::

<a id="sec-7.3.3"></a>

## 7.3.3 重力补偿 PD：只补最大的那一项

最简单的集中控制只补重力。它针对的是**点对点控制**：期望关节角 $\boldsymbol q_d$ 是**常数**，
让 $\boldsymbol q$ 收敛到 $\boldsymbol q_d$。

取误差 $\tilde{\boldsymbol q}=\boldsymbol q_d-\boldsymbol q$，构造

$$V(\dot{\boldsymbol q},\tilde{\boldsymbol q})
=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}
+\frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}>0
\quad\bigl((\dot{\boldsymbol q},\tilde{\boldsymbol q})\neq(0,0)\bigr).\tag{7.3-3}$$

对时间求导，注意 $\boldsymbol q_d$ 是常数（$\dot{\boldsymbol q}_d=0$，$\dot{\tilde{\boldsymbol q}}=-\dot{\boldsymbol q}$）：

$$\dot V=\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\ddot{\boldsymbol q}
+\frac12\dot{\boldsymbol q}^{\mathrm T}\dot B(\boldsymbol q)\dot{\boldsymbol q}
-\dot{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q}.\tag{7.3-4}$$

本节令 $\boldsymbol u=\boldsymbol\tau$ 为关节侧指令、$F=F_{\mathrm v}$ 为黏性摩擦矩阵，暂不包含库仑/静摩擦；否则光滑模型和不变集的讨论必须重写。全章误差统一为「期望减实际」。转动轴的力矩型 PD 增益单位分别为 $\mathrm{N\cdot m/rad}$ 与 $\mathrm{N\cdot m\cdot s/rad}$；它们不同于下一节加速度指令内的增益。现在用动力学方程解出 $B\ddot{\boldsymbol q}$，代入 $\dot V$：


$$\dot V=\frac12\dot{\boldsymbol q}^{\mathrm T}\bigl(\dot B(\boldsymbol q)-2C(\boldsymbol q,\dot{\boldsymbol q})\bigr)\dot{\boldsymbol q}
-\dot{\boldsymbol q}^{\mathrm T}F\dot{\boldsymbol q}
+\dot{\boldsymbol q}^{\mathrm T}\bigl(\boldsymbol u-\boldsymbol g(\boldsymbol q)-K_P\tilde{\boldsymbol q}\bigr).\tag{7.3-5}$$

**第一项为零**——这正是第六章性质一（$\dot B-2C$ 反对称）的用处。取控制律

$$\boxed{\ \boldsymbol u=\boldsymbol g(\boldsymbol q)+K_P\tilde{\boldsymbol q}-K_D\dot{\boldsymbol q}\ }\tag{7.3-6}$$

这里 $K_P,K_D$ 对称正定，$F$ 对称半正定。由于目标固定，$\dot{\tilde q}=-\dot q$，所以阻尼项也可写成 $+K_D\dot{\tilde q}$。若用实际速度 $\dot q$，必须取负号。可以用一个瞬间检查：已到目标但仍向正方向运动时，阻尼应产生反向力矩。

代回得

$$\dot V=-\dot{\boldsymbol q}^{\mathrm T}(F+K_D)\dot{\boldsymbol q}\le0.\tag{7.3-7}$$

假设采用无关节限位的展开坐标 $q\in\mathbb R^n$、模型光滑、重力补偿精确且驱动力矩不限幅，并有 $B(q)\succeq b_*I$（常数 $b_*>0$）。则 $V$ 径向无界，其子水平集紧致且正向不变。$\dot V=0$ 要求 $\dot q=0$；若要一直保持在该集合内，还必须有 $\ddot q=0$。代回闭环方程，得 $K_P\tilde q=0$，故最大不变集只有目标平衡点。于是该理想模型在这些坐标与假设下全局渐近稳定。

**三个必须记住的限制**：

1. **本证明只适用于固定目标**。推导里用了 $\dot{\boldsymbol q}_d=0$；跟踪时 $\boldsymbol q_d(t)$ 不是常数，
   $\dot{\tilde{\boldsymbol q}}\neq-\dot{\boldsymbol q}$，(7.3-4) 多出 $\tilde{\boldsymbol q}^{\mathrm T}K_P\dot{\boldsymbol q}_d$
   一项，不能沿用这个证明。控制律可用于时变参考，但要另行分析跟踪误差；下一节给出逆动力学控制。
2. **$\boldsymbol g$ 必须用实测 $\boldsymbol q$**。用 $\boldsymbol q_d$ 算等于开环补偿，位形偏差时补错。
3. **它只补了重力**。$B\ddot{\boldsymbol q}$ 与 $C\dot{\boldsymbol q}$ 没补，速度一高就露馅。

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

合起来就是**逆动力学控制律**（也叫计算力矩控制）：

$$\boxed{\ \boldsymbol u=B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d
+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}\bigr)
+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})\ }\tag{7.3-9}$$

代入 (7.3-8)，$B$ 可逆（第六章性质一：对称正定），得

$$\ddot{\boldsymbol q}=\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}
\quad\Longrightarrow\quad
\boxed{\ \ddot{\tilde{\boldsymbol q}}+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}=0\ }\tag{7.3-10}$$

若模型精确、驱动能实现所求力矩，且 $K_P,K_D$ 取正对角阵，则各轴误差方程互不耦合，每轴都是稳定的二阶系统，误差指数收敛。若增益是一般正定矩阵，不能直接说各轴互不耦合。

回到第六章的均匀两连杆，看看这里的误差究竟改变了哪一项。仍在竖直平面内，两杆各长 $1\,\mathrm m$、质量均为 $1\,\mathrm{kg}$，质心惯量各为 $1/12\,\mathrm{kg\cdot m^2}$；$q_1$ 相对固定 $x$ 轴、$q_2$ 相对第一杆逆时针量起。沿用无接触、无摩擦、忽略转子与传动惯量的模型，令关节侧指令 $\tau=\boldsymbol u$。它的模型是

$$B(q)=\begin{bmatrix}5/3+\cos q_2&1/3+\tfrac12\cos q_2\\1/3+\tfrac12\cos q_2&1/3\end{bmatrix}\,\mathrm{kg\cdot m^2},$$

$$\boldsymbol g(q)=(1\,\mathrm{kg})(9.81\,\mathrm{m/s^2})(1\,\mathrm m)
\begin{bmatrix}\tfrac32\cos q_1+\tfrac12\cos(q_1+q_2)\\\tfrac12\cos(q_1+q_2)\end{bmatrix},$$

$$C(q,\dot q)\dot q=(1\,\mathrm{kg\cdot m^2})
\begin{bmatrix}-\tfrac12\sin q_2(2\dot q_1\dot q_2+\dot q_2^2)\\\tfrac12\sin q_2\dot q_1^2\end{bmatrix}.$$

其中速度项的单位也是 $\mathrm{N\cdot m}$。现在用实际测得的 $q,\dot q$ 算模型，定义 $e=q_d-q$，即上式中的 $\tilde{\boldsymbol q}$。若实际位置落后，$e$ 为正；控制器不是只按计划好的轨迹算一遍力矩，而是每一时刻根据这个误差重新算。取 $K_P=25I\,\mathrm{s^{-2}}$、$K_D=10I\,\mathrm{s^{-1}}$，使 $\ddot q_d+K_D\dot e+K_Pe$ 的单位为 $\mathrm{rad/s^2}$。

例如某时刻实际 $q=q_A=(0,\pi/2)$、$\dot q=0$，而期望 $q_d=q_A+(0.01,0)\,\mathrm{rad}$、$\dot q_d=\ddot q_d=0$。这时 $e=(0.01,0)\,\mathrm{rad}$、$\dot e=0$，反馈要求的加速度为 $(0.25,0)\,\mathrm{rad/s^2}$，因此

$$\tau=\begin{bmatrix}5/3&1/3\\1/3&1/3\end{bmatrix}\,(0.25,0)^{\mathrm T}
+\begin{bmatrix}14.715\\0\end{bmatrix}
\approx\begin{bmatrix}15.132\\0.0833\end{bmatrix}\,\mathrm{N\cdot m}.$$

矩阵的单位是 $\mathrm{kg\cdot m^2}$，加速度列的单位是 $\mathrm{rad/s^2}$。相比只保持 $q_A$ 的 $(14.715,0)\,\mathrm{N\cdot m}$，新增力矩让第一关节追赶；第二关节也得到耦合补偿，并不是误差为零就不出力。

把同一个控制律完整代回实际对象，消项过程是

$$\begin{aligned}
B(q)\ddot q+C(q,\dot q)\dot q+\boldsymbol g(q)
&=B(q)(\ddot q_d+10\dot e+25e)+C(q,\dot q)\dot q+\boldsymbol g(q),\\
B(q)(\ddot q-\ddot q_d-10\dot e-25e)&=0,\\
\ddot e+10\dot e+25e&=0.
\end{aligned}$$

由于 $B$ 正定可逆，两通道各自的特征方程为

$$\lambda^2+(10\,\mathrm{s^{-1}})\lambda+25\,\mathrm{s^{-2}}=0,
\qquad \lambda_1=\lambda_2=-5\,\mathrm{s^{-1}}.$$

每个通道都是临界阻尼，$e_i(t)=(a_i+b_it)e^{-5t}$（这里 $t$ 以秒计，常数由初始误差决定）。非零初始误差会逐渐衰减，不会在施加控制律的一瞬间消失；只有初始位置和速度误差都为零，理想模型才一直保持零误差。

这一结论假设**模型精确、无接触无摩擦、状态准确可得、理想连续时间更新且力矩不饱和**，也就是没有有限采样、延迟或执行器动态造成的偏差。数字控制器实际按周期采样，不能仅凭连续时间特征根就断言离散闭环有同样的响应。若实际质量不同、出现接触或力矩被限幅，上面的等号便不能逐项成立；需要先写出剩下的项，再讨论误差，而不能继续照用 $-5$ 的特征根。

**它与 7.2.7 计算转矩前馈的差别，只在「用谁的状态」**：

| | 计算转矩前馈 | 逆动力学控制 |
|:--|:--|:--|
| 模型自变量 | $\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d$ | $\boldsymbol q,\dot{\boldsymbol q}$ |
| 非线性对消 | 近似（跟踪误差小时才准） | 模型精确且力矩可实现时精确 |
| 计算 | 可离线预算 | 每周期在线算 $B,\boldsymbol n$ |
| 本质 | 前馈 | 反馈线性化 |

**代价与失效点**（课件 86:30 专门列了一页）：

1. **模型必须准**。$\hat B\neq B$、$\hat{\boldsymbol n}\neq\boldsymbol n$ 时，非线性只抵消一部分，
   误差方程右边多出不确定性项（见 7.3.5）。
2. **必须实时算整机模型**。$B$ 与 $\boldsymbol n$ 每周期都要算，$O(n^2)$ 甚至 $O(n^3)$；
   用牛顿–欧拉递推可降到 $O(n)$（第六章 6.4），但仍是重计算。
3. **采样与延迟须分析**。采样控制在采样时刻用当前状态计算力矩，并保持到下一次更新；计算和通信还可能增加延迟，但不是必然「上一拍算这一拍」。即使没有额外延迟，保持期间状态变化也会破坏连续时间逐点对消，须检查离散闭环。
4. **未建模动态的影响**：该模型仅考虑了刚体动力学，而忽略了电机的电感、电流环动态、以及减速器可能存在的柔性等因素。在高速运动时，这些被忽略的「未建模动态」会对控制性能产生显著影响，导致理想的非线性对消失效。

::: note 为什么说它是「反馈线性化」
$\boldsymbol u$ 的表达式里显式含有实测的 $\boldsymbol q,\dot{\boldsymbol q}$，所以消掉非线性靠的是
**反馈**，不是在工作点附近做 Taylor 展开。前者大范围有效，后者只在工作点附近有效——这是它与
「小偏差线性化」的本质区别。
:::

<a id="sec-7.3.5"></a>

## 7.3.5 鲁棒控制：模型不准，但知道不准多少

逆动力学控制假设模型精确。现实是 $\hat B=\hat B(\boldsymbol q)$、$\hat{\boldsymbol n}$ 只是估计，
真实对象与标称模型之间有一个**不确定项**：

$$B(\boldsymbol q)\ddot{\boldsymbol q}+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})
=\hat B(\boldsymbol q)\ddot{\boldsymbol q}+\hat{\boldsymbol n}(\boldsymbol q,\dot{\boldsymbol q})
+\boldsymbol\eta(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q}),\tag{7.3-11}$$

$\boldsymbol\eta$ 包含参数误差、未建模动态、外部扰动。**鲁棒控制的思路**：不估计 $\boldsymbol\eta$
的具体值，只假设它**有界**，然后设计一个控制项，使得无论 $\boldsymbol\eta$ 在界内怎么变，
误差都收敛到一个有界集。

控制律取

$$\boxed{\ \boldsymbol u=\hat B(\boldsymbol q)\boldsymbol y+\hat{\boldsymbol n}(\boldsymbol q,\dot{\boldsymbol q})
+\boldsymbol\omega\ }\tag{7.3-12}$$

$$\boldsymbol y=\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q},
\qquad
\boldsymbol\omega=\frac{\rho}{\|\boldsymbol z\|}\boldsymbol z,\qquad
\boldsymbol z=\hat B^{-\mathrm T}D^{\mathrm T}Q\boldsymbol\xi,\qquad D=\begin{bmatrix}0\\I\end{bmatrix}.\tag{7.3-13}$$

这里 $\boldsymbol\xi=[\tilde{\boldsymbol q}^{\mathrm T},\dot{\tilde{\boldsymbol q}}^{\mathrm T}]^{\mathrm T}$，令 $A=\begin{bmatrix}0&I\\-K_P&-K_D\end{bmatrix}$ 为 Hurwitz 矩阵，选 $P\succ0$，由 $A^{\mathrm T}Q+QA=-P$ 求 $Q\succ0$。$\hat B$ 须可逆。式 (7.3-11) 的 $\eta$ 与这里的 $\omega$ 都是力矩型量，因此 $z$ 必须包含惯量逆的转置；不能把加速度型补偿的方向公式直接用于外加力矩。

将式 (7.3-12) 代入 $\hat B\ddot q+\hat n+\eta=u$，可逐项得到

$$\ddot{\tilde q}+K_D\dot{\tilde q}+K_P\tilde q=\hat B^{-1}(\eta-\omega),\qquad
\dot\xi=A\xi+D\hat B^{-1}(\eta-\omega).$$

取 $V=\xi^{\mathrm T}Q\xi$，则

$$\dot V=-\xi^{\mathrm T}P\xi+2z^{\mathrm T}(\eta-\omega)
\le-\xi^{\mathrm T}P\xi+2\|z\|(\|\eta\|-\rho).$$

因此必须在所分析工作域内建立有效的界 $\rho\ge\|\eta\|$。由于 $\eta$ 还可能含实际加速度，不能只凭「参数误差有界」就断言已有可用的力矩界；需结合运动与驱动范围检查。理想不连续律在 $z=0$ 按集合值解释，不能直接除以零。若解存在、轨迹留在界有效的区域且力矩可实现，上式给出误差衰减的依据。

**几何图像**：课件用 $D^{\mathrm T}Q\xi=0$ 表示滑动子空间。本文外加力矩型写法的 $z=\hat B^{-\mathrm T}D^{\mathrm T}Q\xi$ 与它有相同的零集合，但方向一般不同；上面的导数计算说明了为什么要这样配套。课件示意的是理想切换运动，不能据图就断言有限采样、饱和执行器也精确到达并沿面滑动。

**问题是抖振**。$\boldsymbol\omega=\rho\boldsymbol z/\|\boldsymbol z\|$ 是一个**符号函数**：
$\boldsymbol z$ 一过零，控制量立刻反向，实际执行器跟不上，就在滑模面附近高频抖振。

**工程修正**：在滑模面附近设一个**边界层** $\varepsilon$：

$$\boldsymbol\omega=
\begin{cases}
\dfrac{\rho}{\|\boldsymbol z\|}\boldsymbol z, & \|\boldsymbol z\|\ge\varepsilon,\\[6pt]
\dfrac{\rho}{\varepsilon}\boldsymbol z, & \|\boldsymbol z\|<\varepsilon.
\end{cases}\tag{7.3-14}$$

边界层内有 $2z^{\mathrm T}(\eta-\omega)\le2\rho(r-r^2/\varepsilon)\le\rho\varepsilon/2$，其中 $r=\|z\|<\varepsilon$。若 $\rho$ 为有限常数上界，则

$$\dot V\le-\lambda_{\min}(P)\|\xi\|^2+\rho\varepsilon/2.$$

这给出最终有界的估计，而不是保证误差恰好落在 $\|z\|<\varepsilon$ 或必定非零。由 $\lambda_{\min}(Q)\|\xi\|^2\le V\le\lambda_{\max}(Q)\|\xi\|^2$ 可把估计换成状态范数界；该界还取决于增益和不确定性大小，不能把 $\varepsilon$ 直接当成位置误差。较小的边界层通常减小理论残差界，但会增大局部斜率、增加对噪声和采样的敏感性；平滑切换也不保证真实系统完全没有抖振。

::: think 鲁棒控制的一句话
**「一年四季穿同一件衣服」**——老师 01:29:28 的原话。控制器只有一套，设计时把温度（参数）变化的
最坏情况都考虑进去；不管怎么变，系统都能工作，但性能不是最优。
:::

<a id="sec-7.3.6"></a>

## 7.3.6 自适应控制：参数在线改，控制器跟着变

鲁棒控制用「一套固定增益」对抗所有参数变化；自适应控制则**在线估计参数，让控制器跟着变**。
它的前提是第六章性质二：**动力学参数具有线性性**——

$$\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi,\tag{7.3-15}$$

$Y$ 是已知的回归矩阵，$\boldsymbol\pi$ 是未知但**常数**的动力学参数向量（质量、惯量、质心位置、
摩擦系数……）。

**控制律的构造**（课件 §8.5.4）：

1. 定义**修正速度**与**修正误差**：
   $$\dot{\boldsymbol q}_r=\dot{\boldsymbol q}_d+\Lambda\tilde{\boldsymbol q},\qquad
   \boldsymbol\sigma=\dot{\boldsymbol q}_r-\dot{\boldsymbol q}
   =\dot{\tilde{\boldsymbol q}}+\Lambda\tilde{\boldsymbol q},\qquad \Lambda\succ0.\tag{7.3-16}$$
2. 为看清参数消去过程，先考虑不含摩擦的模型，构造满足
   $$Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)\boldsymbol\pi
   =B\ddot{\boldsymbol q}_r+C\dot{\boldsymbol q}_r+\boldsymbol g$$
   的回归矩阵，取控制律
   $$\boldsymbol u=Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)
   \hat{\boldsymbol\pi}+K_D\boldsymbol\sigma.\tag{7.3-17}$$
3. 参数**在线更新**：
   $$\boxed{\ \dot{\hat{\boldsymbol\pi}}
   =K_\pi^{-1}Y^{\mathrm T}(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)
   \boldsymbol\sigma\ }\tag{7.3-18}$$

用 $\tilde{\boldsymbol\pi}=\hat{\boldsymbol\pi}-\boldsymbol\pi$ 表示参数估计误差。由 $\boldsymbol\sigma=\dot{\boldsymbol q}_r-\dot{\boldsymbol q}$，结合动力学方程和控制律，得

$$B\dot{\boldsymbol\sigma}+C\boldsymbol\sigma
=-Y\tilde{\boldsymbol\pi}-K_D\boldsymbol\sigma.$$

取李雅普诺夫函数

$$V=\frac12\boldsymbol\sigma^{\mathrm T}B\boldsymbol\sigma
+\frac12\tilde{\boldsymbol\pi}^{\mathrm T}K_\pi\tilde{\boldsymbol\pi},
\qquad K_D,K_\pi\succ0.\tag{7.3-19}$$

利用 $\dot B-2C$ 的结构性质，并注意真实参数 $\boldsymbol\pi$ 为常数，逐项求导得到

$$\dot V=-\boldsymbol\sigma^{\mathrm T}K_D\boldsymbol\sigma
+\tilde{\boldsymbol\pi}^{\mathrm T}(K_\pi\dot{\hat{\boldsymbol\pi}}-Y^{\mathrm T}\boldsymbol\sigma).\tag{7.3-20}$$

更新律 (7.3-18) 恰好消去第二项，所以 $\dot V=-\boldsymbol\sigma^{\mathrm T}K_D\boldsymbol\sigma\le0$。在惯量一致正定、参考轨迹及闭环信号满足有界性等常用条件下，利用 Barbalat 引理可得 $\boldsymbol\sigma\to0$；再由 $\dot{\tilde{\boldsymbol q}}+\Lambda\tilde{\boldsymbol q}=\boldsymbol\sigma$ 得跟踪误差趋于零。

**把课件保留的摩擦和位置误差项也写出来。** 课件 §8.5.4（第 9 周原帧 `s0664.jpg`、`s0667.jpg`–`s0671.jpg`、`s0679.jpg`–`s0697.jpg`）还给出下面一条推导。它与上面的简化证明相容，但不能只贴截图、略去中间的消项。

先假定模型参数已知，令

$$\boldsymbol u=B\ddot{\boldsymbol q}_r+C\dot{\boldsymbol q}_r+F\dot{\boldsymbol q}_r+\boldsymbol g+K_D\boldsymbol\sigma.$$

代入含黏性摩擦的对象，得到

$$B\dot{\boldsymbol\sigma}+C\boldsymbol\sigma+(F+K_D)\boldsymbol\sigma=0.$$

按课件的整定取 $\Lambda,K_D$ 为正对角阵，$F\succeq0$，在动能型项之外加入位置误差项：

$$V_c=\frac12\boldsymbol\sigma^{\mathrm T}B\boldsymbol\sigma
+\tilde{\boldsymbol q}^{\mathrm T}\Lambda K_D\tilde{\boldsymbol q}.$$

这相当于课件候选函数中的 $M=2\Lambda K_D$。利用 $\dot B-2C$，再把 $\boldsymbol\sigma=\dot{\tilde{\boldsymbol q}}+\Lambda\tilde{\boldsymbol q}$ 展开，得

$$\begin{aligned}
\dot V_c&=-\boldsymbol\sigma^{\mathrm T}(F+K_D)\boldsymbol\sigma
+2\tilde{\boldsymbol q}^{\mathrm T}\Lambda K_D\dot{\tilde{\boldsymbol q}}\\
&=-\boldsymbol\sigma^{\mathrm T}F\boldsymbol\sigma
-\dot{\tilde{\boldsymbol q}}^{\mathrm T}K_D\dot{\tilde{\boldsymbol q}}
-\tilde{\boldsymbol q}^{\mathrm T}\Lambda K_D\Lambda\tilde{\boldsymbol q}.
\end{aligned}$$

第二行的关键是交叉项抵消，而不是丢掉摩擦或位置误差。若增益只是任意正定矩阵，不能未经检查就沿用 $M=2\Lambda K_D$，因为该乘积未必对称。

参数未知时，把 $F\dot{\boldsymbol q}_r$ 也纳入回归项，使 $Y\boldsymbol\pi=B\ddot{\boldsymbol q}_r+C\dot{\boldsymbol q}_r+F\dot{\boldsymbol q}_r+\boldsymbol g$，仍用 (7.3-17) 和 (7.3-18)。此时误差方程右端多出 $-Y\tilde{\boldsymbol\pi}$，而

$$V_a=V_c+\frac12\tilde{\boldsymbol\pi}^{\mathrm T}K_\pi\tilde{\boldsymbol\pi}$$

的导数为

$$\begin{aligned}
\dot V_a={}&-\boldsymbol\sigma^{\mathrm T}F\boldsymbol\sigma
-\dot{\tilde{\boldsymbol q}}^{\mathrm T}K_D\dot{\tilde{\boldsymbol q}}
-\tilde{\boldsymbol q}^{\mathrm T}\Lambda K_D\Lambda\tilde{\boldsymbol q}\\
&+\tilde{\boldsymbol\pi}^{\mathrm T}(K_\pi\dot{\hat{\boldsymbol\pi}}-Y^{\mathrm T}\boldsymbol\sigma).
\end{aligned}$$

更新律恰好消去最后一行，留下三个非正项。这里用的是未知但固定的参数，因而 $\dot{\tilde{\boldsymbol\pi}}=\dot{\hat{\boldsymbol\pi}}$；结合前述有界性条件才能得到跟踪收敛。这个含摩擦的回归矩阵与前面的无摩擦矩阵结构不同，实际实现时须选定一套模型，不能只给无摩擦的 $Y$ 套上含摩擦的导数结论。

课件最后还区分了**直接自适应**与**间接自适应**：这里在线调整 $\hat{\boldsymbol\pi}$，是为了让控制律满足跟踪目标，不是先保证识别出真实参数再据此设计控制器。因此，即使某时刻 $Y(\hat{\boldsymbol\pi}-\boldsymbol\pi)=0$，也不能反推 $\hat{\boldsymbol\pi}=\boldsymbol\pi$；回归矩阵可能有非零零空间，参数收敛还取决于其结构以及期望、实际轨迹提供的激励。这正是下面「跟踪收敛不等于参数辨识成功」的原因。

**必须说清的三件事**：

1. **参数估计不一定收敛到真值**。更新律只保证 $\boldsymbol\sigma\to0$，不保证
   $\hat{\boldsymbol\pi}\to\boldsymbol\pi$；$\hat{\boldsymbol\pi}$ 只要求**有界**。
   老师原话（01:47:23–01:57:46）：「参数它并没有收敛到真值，但它不影响跟踪误差趋向零。」
2. **不需要测加速度**。回归矩阵 $Y$ 用的是 $\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r$
   （由期望轨迹与误差算出），不是实测 $\ddot{\boldsymbol q}$——这是这套设计最实用的一点。
3. **计算量比逆动力学更大**：每周期要算 $Y$、更新 $\hat{\boldsymbol\pi}$、再算控制律。

::: think 鲁棒与自适应各依赖什么
这里的鲁棒控制利用不确定项的已知上界设计补偿；加入边界层后的结论是误差进入有界区域。自适应控制利用已知的参数线性模型在线调整参数估计。对本节理想的固定未知参数模型，跟踪误差收敛不等于参数估计收敛到真值；要进一步保证参数收敛，还需持续激励等条件。两种方法对模型和扰动的假设不同，不能仅凭“参数变化快慢”断定该选哪一种。
:::
<a id="sec-7.3.7"></a>

## 7.3.7 小结与常见错误

**四条实现约束**（对逆动力学/鲁棒/自适应都成立）：

1. **按所选算法评估计算量**。逆动力学可用牛顿–欧拉递推计算；显式构造 $B$ 或整个回归矩阵 $Y$ 的成本不能一律写成 $O(n)$。
2. **检查限幅**。误差大时所求 $u$ 可能超过驱动能力；限幅后精确误差方程及鲁棒/自适应证明不再原样成立，不能只把原假设「放宽」就保留结论。
3. **检查离散实现**。采样、保持和延迟共同改变闭环；「采样频率高于闭环带宽约十倍」至多是起始经验，不能代替离散稳定性分析，也不能保证周期缩短时误差单调下降。
4. **区分参数假设**。自适应推导允许未知的固定参数，但不自动涵盖突变负载或持续变化的参数；初值与不确定界应按实际对象设置，不能保证初值越准所有瞬态指标都单调改善。

- **一句话主线**：重力补偿 PD 只补偿 $\boldsymbol g$；逆动力学使用整机模型；鲁棒控制还利用不确定性上界，自适应控制在线更新参数估计。
- **一个工具**：李雅普诺夫函数 + 拉萨尔原理；核心技巧是用 $\dot B-2C$ 的反对称性消掉交叉项。
- **一个取舍**：模型、扰动上界、参数线性结构与计算能力分别限制不同控制律的适用范围。
- **下一节**：[7.4 操作空间控制](sec7-4.md) 把集中控制搬到末端——用第六编 6.7 的 $B_A,C_A,\boldsymbol g_A$ 直接闭 $x$ 的环；[7.5](sec7-5.md) 再把九种方案放到同一台两连杆臂上比一比。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 重力补偿 PD (7.3-6)：$\boldsymbol u=\boldsymbol g(\boldsymbol q)+K_P\tilde q-K_D\dot q$；$\dot V=-\dot q^{\mathrm T}(F+K_D)\dot q$ | **固定目标**、模型精确、无限幅；证明用拉萨尔原理 | N·m | $\boldsymbol g$ 用实测 $q$；跟踪时证明不适用 |
| 逆动力学 (7.3-9)：$\boldsymbol u=B(q)(\ddot q_d+K_D\dot{\tilde q}+K_P\tilde q)+\boldsymbol n(q,\dot q)$ | 模型精确、力矩可实现 | N·m | 误差方程 $\ddot{\tilde q}+K_D\dot{\tilde q}+K_P\tilde q=0$；与计算转矩前馈差在「用谁的状态」 |
| 鲁棒 (7.3-12)：$\boldsymbol u=\hat B y+\hat{\boldsymbol n}+\boldsymbol\omega$，$\boldsymbol\omega=\rho\boldsymbol z/\|\boldsymbol z\|$，$\boldsymbol z=\hat B^{-\mathrm T}D^{\mathrm T}Q\xi$ | $\|\eta\|\le\rho$ 在工作域内成立 | N·m | $z$ 须含 $\hat B^{-\mathrm T}$（力矩型）；边界层只给最终有界 |
| 自适应 (7.3-17)–(7.3-18)：$\boldsymbol u=Y\hat{\boldsymbol\pi}+K_D\boldsymbol\sigma$，$\dot{\hat{\boldsymbol\pi}}=K_\pi^{-1}Y^{\mathrm T}\boldsymbol\sigma$，$\boldsymbol\sigma=\dot{\tilde q}+\Lambda\tilde q$ | 参数线性性、参数固定、有界性条件 | N·m | 不需实测加速度；$\hat{\boldsymbol\pi}$ 有界即可，收敛真值需激励 |
| 四法梯度：只补 $g$ → 全模型 → +不确定界 → +在线估计 | 模型用量递增 | — | 各法假设不同，不能混用证明 |

::: note 主线 · 两连杆（第八关 · 用反馈修正偏差）
第七关算出了保持与加速两张力矩账单；本关（[两连杆第八关](../training/two-link.md#mission-feedback)）把 7.3.4 的控制律代回同一台臂的动力学方程消项，得误差方程 $\ddot e+K_D\dot e+K_Pe=0$，并检查扰动下的稳态误差——§7.3.4 的两连杆带数例就是本关的完整过程。至此两连杆主线的八个关卡走完：位置（第一关）→ 速度（第二关）→ 奇点（第三关）→ 力（第四关）→ 轨迹（第五关）→ 传动（第六关）→ 动力学（第七关）→ 反馈（本关），全部公式都是同一台 2R 臂在不同章节里的「再出场」。
:::

::: think 常见错误清单
1. **重力补偿 PD 拿来做轨迹跟踪**：它的稳定性证明用了 $\dot{\boldsymbol q}_d=0$，跟踪时证不出来。
2. **逆动力学里把 $\boldsymbol q$ 写成 $\boldsymbol q_d$**：一写就退回前馈，不再是反馈线性化。
3. **鲁棒项无限加大 $\rho$**：界必须足够覆盖不确定性，但更大补偿还受抖振、噪声和饱和约束，不能据此保证实际闭环更稳定。
4. **忘了边界层的代价**：一般只能保证最终有界，不能无条件宣称渐近收敛；但这也不表示每条轨迹的最终误差必定非零。
5. **以为自适应一定辨识真参数**：理想证明给出参数估计有界和跟踪收敛；真值收敛还需可辨识性与持续激励。噪声和未建模扰动下还可能出现参数漂移，不能混作理想定理结论。
6. **忽略限幅**：限幅是逆动力学最常见的失效原因，也是鲁棒/自适应证明里最容易被忽略的假设。
:::

::: think 默写点 · 合上书再写
1. 写出重力补偿 PD 的 $V$ 与 $\dot V$，说明哪一步用了 $\dot B-2C$ 的反对称性。
2. 写出逆动力学控制律与误差方程，说明它与计算转矩前馈的区别。
3. 写出鲁棒控制律的三部分，解释滑动子空间与边界层的作用。
4. 写出自适应控制的 $\boldsymbol\sigma$、控制律与参数更新律，说明为什么不需要测加速度。
5. 说明自适应控制能保证什么、不能保证什么。
:::

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导、数值例与两种证明；下列课件页保留以备核对，**不构成正文的替代**（对应录播 00:56:32–01:58:20）。

| 时间点 | 幻灯片 | 提供了什么 | 本书如何处理 |
|:--|:--|:--|:--|
| 57:50 | [centralized-intro.jpg](../assets/ch07/centralized-intro.jpg) | 集中控制的定位 | 四法梯度表 + 本质说明替代 |
| 60:40 | [lyapunov.jpg](../assets/ch07/lyapunov.jpg) | 二次型李雅普诺夫函数 | (7.3-1)–(7.3-2) + 拉萨尔三步替代 |
| 72:00 | [gravity-pd-V.jpg](../assets/ch07/gravity-pd-V.jpg) | 重力补偿 PD 的 $V$ | (7.3-3)–(7.3-4) 完整推导替代 |
| 74:50 | [gravity-pd-Vdot.jpg](../assets/ch07/gravity-pd-Vdot.jpg) | $\dot B-2C$ 消项 | (7.3-5)–(7.3-7) + 不变集论证替代 |
| 84:50 | [inverse-dynamics.jpg](../assets/ch07/inverse-dynamics.jpg) | 逆动力学双回路 | 两步思路 + 误差方程 + 两连杆带数例替代 |
| 99:10 | [robust-law.jpg](../assets/ch07/robust-law.jpg) | 鲁棒控制律三部分 | (7.3-11)–(7.3-13) 完整推导，含 $z$ 的力矩型修正 |
| 104:50 | [sliding-subspace.jpg](../assets/ch07/sliding-subspace.jpg) | 滑动子空间示意 | 正文几何说明 + 理想切换边界注明 |
| 105:40 | [boundary-layer.jpg](../assets/ch07/boundary-layer.jpg) | 边界层 | (7.3-14) + 最终有界估计替代 |
| 108:10 | [adaptive-linearity.jpg](../assets/ch07/adaptive-linearity.jpg) | 参数线性性 | (7.3-15) + 与 6.2.2 互链替代 |
| 114:10 | [adaptive-lyapunov.jpg](../assets/ch07/adaptive-lyapunov.jpg) | 自适应李雅普诺夫证明 | (7.3-16)–(7.3-20) + 含摩擦扩展证明替代 |
| 117:40 | [adaptive-structure.jpg](../assets/ch07/adaptive-structure.jpg) | 自适应控制律三部分 | 控制律结构 + 三件必说清的事替代 |
:::
