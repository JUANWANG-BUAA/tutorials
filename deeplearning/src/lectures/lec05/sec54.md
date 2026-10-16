# 5.4 策略梯度与 REINFORCE

值方法的思路是「先学 $Q$，再隐式地由 $\arg\max$ 得到策略」。它有两处不便。第一是**连续动作空间**：$\max_a Q(s,a)$ 不再是查表，而是一个内层优化——[5.3](sec53.md) 的 TD 目标里那个 $\max$ 直接失效。第二是**随机策略**：有些任务的**最优策略本身就是随机的**（石头剪刀布、部分可观测环境、对抗博弈），硬取 $\arg\max$ 会把策略压成确定性策略，反而变差。

这一节换一条主干：**直接把策略参数化，然后对「期望回报」求梯度**。数学上的核心困难一开始就很显眼——目标 $J(\theta)$ 里的期望是**对策略自身的分布**取的，你要对「分布的参数」求导，而分布本身又在决定样本。绕开这个困难的工具只有一个恒等式：**对数导数技巧**（log-derivative trick）。它在测度论上的名字是 score function 恒等式，在本节里只有一行：$\nabla_\theta\pi_\theta=\pi_\theta\nabla_\theta\log\pi_\theta$。

围绕它，本节要讲清四件事：策略梯度定理的完整推导（5.4.3）、REINFORCE 算法与它的两个实用改进——**因果性**与**基线**（5.4.4–5.4.5）、它与最大似然的关系（5.4.6，这是理解 RLHF / DPO 的关键桥梁），以及一个能跑的最小实现（5.4.7）。5.5 会把基线的选择升级成 Actor–Critic，并最终落到 PPO。

## 5.4.1 策略参数化与目标函数

::: def 定义 5.4.1 · 策略参数化 {#def-5.4.1}
用一个参数为 $\theta$ 的函数逼近策略 $\pi_\theta(a\mid s)$，最常见两种形式：

- **离散动作**：网络输出 logits $\boldsymbol z_\theta(s)\in\mathbb R^{\lvert\mathcal A\rvert}$，经 softmax 得
  $$\pi_\theta(a\mid s)=\frac{\exp z_\theta(s)_a}{\sum_{a'}\exp z_\theta(s)_{a'}};$$
- **连续动作**：网络输出高斯分布的均值与（对数）标准差，
  $$\pi_\theta(a\mid s)=\mathcal N\bigl(a;\ \mu_\theta(s),\ \sigma_\theta(s)^2\bigr),$$
  采样时用重参数化 $a=\mu_\theta(s)+\sigma_\theta(s)\cdot\xi,\ \xi\sim\mathcal N(0,I)$，让采样**可导**（与 VAE 的重参数化是同一个技巧，见 [4.3](../lec04/sec43.md)）。

策略网络的输出维度就是动作空间的结构：离散任务输出 $\lvert\mathcal A\rvert$ 个 logits，连续任务输出 $2d_a$ 个数（均值 + 对数标准差）。
:::

::: intuition 为什么「参数化策略」比「参数化价值」更自然
因为**你最终要用的就是策略**。值方法学了一个中间量 $Q$，部署时还要再套一层 $\arg\max$——这层 $\arg\max$ 在离散动作上是免费的，在连续动作上却是一个要单独求解的优化问题；而且它天然给出确定性策略。

直接参数化策略则把这层「中间商」去掉了：网络的输出**就是**要执行的行为分布，部署时直接采样（或取众数）。代价是你必须解决「对分布参数求期望回报的梯度」这个更难的数学问题——本节剩下的篇幅都在还这笔债。
:::

::: def 定义 5.4.2 · 策略优化的目标函数 {#def-5.4.2}
三种等价写法（本书默认用第一种）：

$$J(\theta)=\mathbb E_{s_0\sim\rho}\bigl[V^{\pi_\theta}(s_0)\bigr]
=\mathbb E_{\tau\sim p_\theta}[G_0]
=\mathbb E_{\tau\sim p_\theta}\Bigl[\sum_{t\ge0}\gamma^{t}r_{t+1}\Bigr],$$

其中 $p_\theta(\tau)=\rho(s_0)\prod_{t\ge0}\pi_\theta(a_t\mid s_t)P(s_{t+1}\mid s_t,a_t)$ 是轨迹分布。目标是
$$\max_\theta J(\theta)\quad\Longleftrightarrow\quad \theta\leftarrow\theta+\eta\nabla_\theta J(\theta)\ (\text{梯度上升}).$$
:::

::: intuition 为什么目标里可以只写 $s_0$，却要优化整条轨迹
$J$ 的三种写法是同一件事：**从初始状态出发的期望回报**。看上去它只关心 $s_0$，但要让 $V^{\pi_\theta}(s_0)$ 变大，必须改善**沿途所有会访问到的状态**上的动作——于是数据（轨迹）成为目标的载体：轨迹是「通往 $s_0$ 回报」的唯一通道。工程上的推论有两个：① 训练数据的**分布**决定了你实际优化的是哪些状态（这也是 on-policy 采样必须用当前策略的原因）；② 如果初始状态分布 $\rho$ 与实际部署的起点不一致，训练出来的策略会在部署时面对「从未优化过的状态」——这是 RL 上线后性能骤降的常见原因之一。
:::

| 量 | 形状（离散任务，批大小 $B$、状态维 $d$、动作数 $K$） | 说明 |
|:--|:--|:--|
| 状态批 $s$ | $B\times d$ | 一行一个状态 |
| logits $z_\theta(s)$ | $B\times K$ | 策略网络输出 |
| 概率 $\pi_\theta(\cdot\mid s)$ | $B\times K$ | softmax 后；每行和为 1 |
| 采样动作 $a$ | $B$（long） | 每行抽一个 |
| $\log\pi_\theta(a\mid s)$ | $B$ | 用 `Categorical(logits=z).log_prob(a)` 直接得到 |
| 参数量 | 举例：$d=8,K=4$、隐层 64 的两层 MLP：$8\times64+64+64\times64+64+64\times4+4=4820$ | 与动作数线性相关 |

## 5.4.2 朴素想法为什么不行

「直接对 $J(\theta)$ 求导」看起来很简单：$J$ 是期望，期望是求和，求和可以逐项求导。问题在于**概率本身依赖 $\theta$**：

$$J(\theta)=\sum_\tau p_\theta(\tau)\,G(\tau)\quad\Longrightarrow\quad
\nabla_\theta J(\theta)=\sum_\tau\nabla_\theta p_\theta(\tau)\,G(\tau).$$

这个式子在数值上几乎无法使用：$\tau$ 的取值空间是**指数级**的（长度为 $T$、动作数 $K$ 的轨迹有 $K^T$ 条），你**枚举不完**；而 $\nabla_\theta p_\theta(\tau)$ 也不是能直接采样的对象——你只能采样 $\tau$，但采样给你的是 $p_\theta(\tau)$ 而不是它的导数。

::: think 出路只有一条：把「对分布的导数」改写成「对数的导数 × 分布」
利用恒等式 $\nabla_\theta p_\theta(\tau)=p_\theta(\tau)\,\nabla_\theta\log p_\theta(\tau)$，把上面那个「不能采样」的式子变成**一个期望**：

$$\nabla_\theta J(\theta)=\sum_\tau p_\theta(\tau)\,\nabla_\theta\log p_\theta(\tau)\,G(\tau)=\mathbb E_{\tau\sim p_\theta}\bigl[G(\tau)\,\nabla_\theta\log p_\theta(\tau)\bigr].$$

这就是**score function 恒等式**（本教程称**对数导数技巧**）的全部威力：它把「对分布的导数」变成了「分布下的期望」，于是可以用**采样**估计。注意这里有个隐含要求：$\pi_\theta(a\mid s)\gt0$ 对所有被采到的 $(s,a)$ 成立（否则 $\log$ 无定义），这也是后面「不能随便裁剪策略概率到 0」的原因（[5.5](sec55.md) 的 PPO 之所以用比率而非硬截断，与此有关）。
:::

## 5.4.3 策略梯度定理

::: thm 定理 5.4.1 · 策略梯度定理（policy gradient theorem） {#thm-5.4.1}
对任意可微的策略参数化 $\pi_\theta$（且 $\pi_\theta(a\mid s)\gt0$ 于所有被访问的 $(s,a)$），有

$$\nabla_\theta J(\theta)=\mathbb E_{\pi_\theta}\Bigl[\sum_{t\ge0}\nabla_\theta\log\pi_\theta(a_t\mid s_t)\;Q^{\pi_\theta}(s_t,a_t)\Bigr],$$

其中期望是对轨迹 $\tau\sim p_\theta$ 取的（即用当前策略 $\pi_\theta$ 与环境交互采到的数据）。也可以写成「先对状态分布求期望」的形式：
$$\nabla_\theta J(\theta)=\mathbb E_{s\sim d^{\pi_\theta}}\Bigl[\sum_a\pi_\theta(a\mid s)\,\nabla_\theta\log\pi_\theta(a\mid s)\,Q^{\pi_\theta}(s,a)\Bigr],$$
$d^{\pi_\theta}$ 是策略 $\pi_\theta$ 下的折扣状态访问分布。
:::

::: intuition 这条定理就是一句人话：**好动作抬概率，坏动作压概率**
$\nabla_\theta\log\pi_\theta(a_t\mid s_t)$ 是「想让动作 $a_t$ 出现得更频繁」的方向（梯度上升方向），而它被 $Q^{\pi_\theta}(s_t,a_t)$ **加权**：

- 若某动作的 $Q$ 为**正**，梯度把它**推高**的权重为正 → 该动作出现的概率上升；
- 若某动作的 $Q$ 为**负**（比平均还差），负号使该方向被**抑制** → 该动作概率下降。

所以策略梯度的本质是「**多做一些回报高的动作，少做一些回报低的动作**」。它不需要 $Q$ 表的 $\max$，天然适用于连续动作与随机策略——代价是它把整局**结果**归因给每一步，信噪比很差（5.4.5 的方差分析）。注意定理里**状态分布 $d^{\pi_\theta}$ 也依赖 $\theta$**，而它没有出现在梯度的显式式子里——这不是遗漏，而是被数学抵消了（见下面的严格性说明）。
:::

::: proof 推导（对数导数技巧 + 轨迹分解 + 因果性）
**第一步：从轨迹概率入手。** 由定义 $J(\theta)=\sum_\tau p_\theta(\tau)G(\tau)$，用 $\nabla p_\theta=p_\theta\nabla\log p_\theta$：

$$\nabla_\theta J=\sum_\tau p_\theta(\tau)\,\nabla_\theta\log p_\theta(\tau)\,G(\tau)
=\mathbb E_{\tau\sim p_\theta}\bigl[G(\tau)\nabla_\theta\log p_\theta(\tau)\bigr].$$

**第二步：轨迹概率取对数后只剩策略项。** 由
$$p_\theta(\tau)=\rho(s_0)\prod_{t\ge0}\pi_\theta(a_t\mid s_t)\,P(s_{t+1}\mid s_t,a_t),\qquad
\log p_\theta(\tau)=\log\rho(s_0)+\sum_{t\ge0}\log\pi_\theta(a_t\mid s_t)+\sum_{t\ge0}\log P(s_{t+1}\mid s_t,a_t),$$

其中 $\rho$（初始分布）与 $P$（环境动力学）**与 $\theta$ 无关**，求导后全部消失：
$$\nabla_\theta\log p_\theta(\tau)=\sum_{t\ge0}\nabla_\theta\log\pi_\theta(a_t\mid s_t).$$
这一步是整个推导最漂亮的地方：**环境的未知性完全不进入梯度**——你不需要知道 $P$ 也能算策略梯度。

**第三步：用因果性把 $G(\tau)$ 换成回报-to-go。** 把第二步的式子代入第一步，并按时间重排：

$$\nabla_\theta J=\mathbb E\Bigl[\sum_{t\ge0}\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,G(\tau)\Bigr]
=\sum_{t\ge0}\mathbb E\Bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\underbrace{G_t}_{\sum_{k\ge0}\gamma^k r_{t+k+1}}\Bigr].$$

从 $G(\tau)$ 到 $G_t$ 之所以合法，是因为**时刻 $t$ 之前的奖励与时序 $t$ 的动作独立**：给定 $(s_t,a_t)$ 之后，历史奖励的分布不再依赖 $a_t$ 是哪个动作；而对 $\log\pi_\theta$ 的期望贡献中，那一部分恰好为 0（形式化说明见[定理 5.4.2](sec54.md#thm-5.4.2)）。

**第四步：把 $\mathbb E[G_t\mid s_t,a_t]$ 认成 $Q^{\pi_\theta}$。** 在期望里先对 $(s_t,a_t)$ 取条件：
$$\mathbb E\bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,G_t\bigr]
=\mathbb E_{s_t,a_t\sim\pi_\theta}\Bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\underbrace{\mathbb E[G_t\mid s_t,a_t]}_{=Q^{\pi_\theta}(s_t,a_t)}\Bigr].$$
合并 $t$ 的求和即得定理。

**严格性说明**：上面用「状态分布依赖 $\theta$」被抵消的直观处理。严格证明需要对 $d^{\pi_\theta}$ 求导并证明多出的一项为零，标准论证见 Sutton 等（*Policy Gradient Methods for Reinforcement Learning with Function Approximation*, 2000）；按轨迹展开的紧凑写法也见[附录 C.10](../../appendix/derivations.md)。两种路线结论一致。$\blacksquare$
:::

## 5.4.4 REINFORCE：用实际回报替代 $Q$

定理里有 $Q^{\pi_\theta}(s_t,a_t)$——这又是一个未知量。最直接的替代品是**实际观测到的回报** $G_t$：它是 $Q^{\pi_\theta}(s_t,a_t)$ 的无偏样本（按定义就是同一个条件期望）。由此得到最早的策略梯度算法。

::: method REINFORCE（蒙特卡洛策略梯度） {#method-5.4.1}
用一条完整轨迹里的**实际回报** $G_t$ 作为 $Q^{\pi}(s_t,a_t)$ 的无偏估计：

$$\nabla_\theta J(\theta)\approx\sum_{t=0}^{T-1}\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,G_t,\qquad \theta\leftarrow\theta+\eta\,\nabla_\theta J(\theta).$$

```text
for episode = 1..M:
    用 π_θ 采样一条完整轨迹 τ = (s_0,a_0,r_1,...,s_{T-1})
    从后往前算回报 G_t = r_{t+1} + γ r_{t+2} + ...（这一步是因果性要求的回报-to-go）
    ∇J ← Σ_t ∇_θ log π_θ(a_t|s_t) · G_t
    θ ← θ + η · ∇J          # 注意：这是同一批数据的第一次也是唯一一次更新（on-policy）
```

**超参数与复杂度**：学习率 $\eta$（常用 $10^{-3}$–$10^{-2}$，比监督学习大）；折扣 $\gamma$；回合数 $M$（常需 $10^3$–$10^4$ 局）；**无 batch 概念**（一条轨迹就是一个 batch，也可平均多条）。每步计算 $O(\#\text{params})$ 前后向，内存 $O(T\cdot\#\text{params})$（要存住整局的 log 概率）。

**优点**：无偏、实现简单、无需值函数；对连续动作与随机策略天然适用。**缺点**：$G_t$ 是单条轨迹的**噪声样本**，方差极大；且必须**等整局结束**才能更新，样本效率低；**on-policy**——更新完参数，这批数据就不能再用了。5.4.5 与 [5.5](sec55.md) 的两把钥匙（基线、Critic）就是为了治这个病。
:::

::: thm 定理 5.4.2 · 因果性与回报-to-go {#thm-5.4.2}
在策略梯度中，用**回报-to-go** 替代整局回报不引入偏差：
$$\mathbb E\Bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)\cdot\bigl(G(\tau)-G_t\bigr)\Bigr]=0 .$$
因此
$$\nabla_\theta J(\theta)=\mathbb E\Bigl[\sum_{t\ge0}\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,G_t\Bigr].$$
:::

::: proof 证明（把「更早的奖励」的贡献算成 0）
记 $H_t=\sum_{k\lt t}\gamma^{k}r_{k+1}$ 为 $t$ 之前的奖励之和（不含折扣平移，量级讨论不受影响），则 $G(\tau)=H_t+\gamma^{t}G_t$ 形式的分解中，$H_t$ **由 $t$ 之前的历史决定**。于是

$$\mathbb E\bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,H_t\bigr]
=\mathbb E_{(s_t,a_t)\sim\pi_\theta}\Bigl[\mathbb E\bigl[H_t\mid s_t,a_t\bigr]\,\nabla_\theta\log\pi_\theta(a_t\mid s_t)\Bigr].$$

关键一步：**给定 $s_t,a_t$，$H_t$ 与 $a_t$ 无关**（$H_t$ 只由更早的动作与转移决定，而马尔可夫性保证 $(s_t,a_t)$ 是未来的充分统计量——它把历史「封箱」了）。于是内层期望 $\mathbb E[H_t\mid s_t,a_t]=h(s_t)$ 只是一个**状态的函数**，可以提出对动作的求和：

$$\sum_a\pi_\theta(a\mid s_t)\,h(s_t)\,\nabla_\theta\log\pi_\theta(a\mid s_t)
=h(s_t)\sum_a\nabla_\theta\pi_\theta(a\mid s_t)=h(s_t)\,\nabla_\theta\Bigl(\sum_a\pi_\theta(a\mid s_t)\Bigr)=h(s_t)\,\nabla_\theta 1=0 .$$

最后一步用到 $\sum_a\pi_\theta(a\mid s)=1$ 对任意 $\theta$ 成立。对 $t$ 求和即得结论。$\blacksquare$
:::

::: intuition 因果性的两层含义
**第一层（计算上的好处）**：$G_t$ 只含 $t$ 之后的奖励，通常比 $G_0$ 的数值更小、方差更低（未来越远越不确定的奖励被排除在外了）。

**第二层（更重要的模式）**：上一条证明里「$h(s_t)\sum_a\nabla_\theta\pi_\theta=0$」这一幕，就是**基线无偏性**的同一个引理。它说明：**任何只依赖状态的量，从策略梯度的期望里都可以自由加减**。这条引理是后面所有降方差技巧的公共底座——它在 [5.5](sec55.md) 里变成了优势函数 $A=Q-V$，在 [5.6](sec56.md) 里变成了 DPO 里的参考模型对数比率。
:::

::: ex 例 5.4.1 · 二动作老虎机：手算梯度、REINFORCE 估计与基线的作用 {#ex-5.4.1}
一个单步问题（视野 1）：两个动作，$\pi_\theta(a_1)=\sigma(\theta)$、$\pi_\theta(a_2)=1-\sigma(\theta)$，奖励确定：$r(a_1)=1$、$r(a_2)=0$。取 $\theta=0$。

**(1)** 写出 $J(\theta)$ 与 $\nabla_\theta J$。
**(2)** 用**一条样本**的 REINFORCE 估计器求其期望与方差。
**(3)** 换成带基线 $b=0.5$ 的估计器，重算期望与方差。

::: proof 解
**(1)** 目标与真梯度。$J(\theta)=\sigma(\theta)\cdot1+(1-\sigma(\theta))\cdot0=\sigma(\theta)$，故 $\nabla_\theta J=\sigma'(\theta)=\sigma(\theta)(1-\sigma(\theta))$。$\theta=0$ 时 $\sigma=0.5$，$\nabla_\theta J=0.25$。

**(2)** 单样本估计器 $\hat g=\nabla_\theta\log\pi_\theta(a)\,r(a)$。两条分支：

| 抽到 | 概率 | $\nabla_\theta\log\pi_\theta(a)$ | 奖励 | $\hat g$ |
|:--|:--|:--|:--|:--|
| $a_1$ | 0.5 | $1-\sigma=0.5$ | 1 | $0.5$ |
| $a_2$ | 0.5 | $-\sigma=-0.5$ | 0 | $0$ |

$$\mathbb E[\hat g]=0.5\times0.5+0.5\times0=0.25=\nabla_\theta J\quad(\text{无偏 }\checkmark),$$
$$\mathrm{Var}[\hat g]=\mathbb E[\hat g^2]-0.25^2=0.5\times0.25-0.0625=0.0625,\qquad \text{标准差}=0.25 .$$
即**单次采样的噪声标准差（0.25）与梯度本身（0.25）同量级**——信噪比 ≈ 1。这正是 REINFORCE 在实践中「抖得厉害」的根源。

**(3)** 加基线：$\hat g_b=\nabla_\theta\log\pi_\theta(a)\,(r(a)-b)$，$b=0.5$。

| 抽到 | 概率 | $\nabla_\theta\log\pi_\theta$ | $r-b$ | $\hat g_b$ |
|:--|:--|:--|:--|:--|
| $a_1$ | 0.5 | $0.5$ | $0.5$ | $0.25$ |
| $a_2$ | 0.5 | $-0.5$ | $-0.5$ | $0.25$ |

$$\mathbb E[\hat g_b]=0.25\quad(\text{期望不变 }\checkmark),\qquad \mathrm{Var}[\hat g_b]=0 .$$
**方差被降到了 0**——因为在这个玩具问题里，基线恰好等于真实平均值，噪声被完全抵消。真实问题中不会这么幸运，但「减去一个接近平均的好基线能把方差压掉一个数量级以上」是常态。$\blacksquare$
:::
:::

## 5.4.5 基线：不改变期望，降低方差 {#sec-5.4.5}

::: thm 定理 5.4.3 · 基线的无偏性 {#thm-5.4.3}
对**任意只依赖状态**的函数 $b(s)$（称基线），
$$\mathbb E_{\pi_\theta}\Bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,b(s_t)\Bigr]=0,$$
因此
$$\nabla_\theta J(\theta)=\mathbb E\Bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\bigl(Q^{\pi_\theta}(s_t,a_t)-b(s_t)\bigr)\Bigr].$$
特别地，取 $b(s)=V^{\pi_\theta}(s)$ 时括号内就是**优势函数**
$$A^{\pi_\theta}(s,a)=Q^{\pi_\theta}(s,a)-V^{\pi_\theta}(s),$$
它回答的是「**这个动作比在该状态下的平均水平好多少**」。
:::

::: proof 证明（一行引理）
对固定的 $s$，把期望里的动作部分展开：
$$\sum_a\pi_\theta(a\mid s)\,b(s)\,\nabla_\theta\log\pi_\theta(a\mid s)
=b(s)\sum_a\pi_\theta(a\mid s)\,\frac{\nabla_\theta\pi_\theta(a\mid s)}{\pi_\theta(a\mid s)}
=b(s)\,\nabla_\theta\sum_a\pi_\theta(a\mid s)=b(s)\,\nabla_\theta 1=0 .$$
因为对所有 $\theta$ 都有 $\sum_a\pi_\theta(a\mid s)=1$，其梯度恒为 0。$\blacksquare$
:::

::: intuition 为什么「减去平均」几乎不花钱却很值
注意上一条证明只用到**概率归一化**，与 $b$ 的具体形式无关——所以「减什么」在期望意义上都合法，差别只在**方差**。而 $Q$ 的数值尺度在不同状态间可以差很多（有的状态值 100、有的值 0.1），不减去参照物，同一个学习率会对不同状态产生天差地别的实际步长。减去 $V(s)$ 之后，剩下的 $A$ 是「相对好坏」，尺度被归一化——**好动作优势为正、坏动作为负**，信号干净得多。

这也解释了 RLHF 里那个 KL 项的作用方式（[5.6](sec56.md)）：它是**只依赖状态（$x$）的基线/惩罚**，用来把「奖励的绝对水平」改成「相对参考模型的改善」，从而稳定优化。
:::

::: prop 命题 5.4.1 · 最优（最小方差）基线 {#prop-5.4.1}
把基线推广为状态相关、甚至与梯度方向相关的标量 $b(s)$，最小化估计器方差等价于最小化
$$\mathbb E_{s,a}\bigl[\lVert\nabla_\theta\log\pi_\theta(a\mid s)\rVert^2\bigl(A(s,a)-b(s)\bigr)^2\bigr].$$
忽略 $\lVert g\rVert^2$ 与 $A$ 之间的相关性（工程近似），最优点是**优势的加权平均**：
$$b^\ast(s)\ \approx\ \mathbb E_{a\sim\pi_\theta(\cdot\mid s)}\bigl[A(s,a)\bigr]=0,\qquad\text{或在状态无关的简化下}\quad b^\ast=\mathbb E_{s,a}\bigl[A(s,a)\bigr].$$
:::

::: proof 证明（对 $b$ 求导置零）
只考虑状态无关的常数基线 $b$，目标函数是
$$f(b)=\mathbb E\bigl[\lVert g\rVert^2(A-b)^2\bigr]=b^2\,\mathbb E[\lVert g\rVert^2]-2b\,\mathbb E[\lVert g\rVert^2A]+\text{常数},$$
这是关于 $b$ 的二次函数，导数为 $2b\mathbb E[\lVert g\rVert^2]-2\mathbb E[\lVert g\rVert^2A]$，置零得
$$b^\ast=\frac{\mathbb E[\lVert g\rVert^2A]}{\mathbb E[\lVert g\rVert^2]} .$$
即「按梯度范数平方加权的平均优势」。

**状态相关版本**：若允许 $b(s)$，可对每个 $s$ 独立最小化，得到 $b^\ast(s)=\frac{\mathbb E[\lVert g\rVert^2A\mid s]}{\mathbb E[\lVert g\rVert^2\mid s]}$，即**按状态分组的同一种加权平均**。

**为什么说「近似取 $V(s)$」就够**：因为由定义 $\mathbb E_{a\sim\pi}[A(s,a)]=0$，所以当 $\lVert g\rVert^2$ 与 $A$ 弱相关时 $b^\ast(s)\approx0$；实践中之所以仍用 $b=V(s)$，是因为我们需要的是**减小数值尺度**，而 $V(s)$ 恰好让 $A$ 的尺度与状态无关——这是一个「工程上够好的近似」，而不是严格的最优解。$\blacksquare$
:::

::: intuition 这条命题的实用结论只有一句
**「基线用什么不必最优化，只要它让优势的尺度稳定」**。理论上最优基线是按梯度范数加权的优势平均，但工程上用一个学出来的 $V_\phi(s)$（[5.5](sec55.md)）就够了——它同时扮演三个角色：降方差的基线、GAE 的自举来源、以及判断「这个动作是否值得做」的参照物。**别为了追求「最优基线」而引入更多噪声**：估计基线本身的方差也会进入梯度。
:::

::: errata 关于基线的两个常见误解
1. **「基线是启发式，会引入偏差」**：不会。[定理 5.4.3](sec54.md#thm-5.4.3) 给出的是**精确的零期望**（不是近似），动机上也只是利用了概率归一化。
2. **「基线必须只是状态的函数」**：要保证无偏，基线不能依赖**当前动作** $a_t$。如果 $b$ 里含 $a_t$（例如用 $Q(s_t,a_t)$ 自身当基线），零期望的证明就失效了——这会把有偏项塞进梯度。
:::

**方差表达的实用形式**：把估计器写成一个随机变量 $X_t=\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\hat A_t$，其方差为
$$\mathrm{Var}[X_t]=\mathbb E\bigl[\lVert\nabla_\theta\log\pi_\theta\rVert^2\,\hat A_t^2\bigr]-\lVert\nabla_\theta J\rVert^2 .$$
这个式子说明降方差有三个旋钮：**优势的尺度**（$\hat A_t$ 用小尺度：基线、归一化）、**策略的锐度**（$\lVert\nabla\log\pi\rVert$ 在策略过于自信时很小、在接近均匀时最大，属于「策略本身的属性」）、以及**估计器本身的噪声**（用 Critic 替代 MC 回报，见 [5.5](sec55.md)）。

## 5.4.6 与最大似然的关系（理解 RLHF 的钥匙） {#sec-5.4.6}

把策略梯度写成「对每个采样到的动作做一次加权最大似然」，会得到本节最有用的一个视角。监督学习里的交叉熵损失（[1.4](../lec01/sec14.md)）是
$$\mathcal L_{\text{SL}}(\theta)=-\mathbb E_{(s,a^\ast)\sim\mathcal D}\log\pi_\theta(a^\ast\mid s),\qquad
\nabla_\theta\mathcal L_{\text{SL}}=-\mathbb E\bigl[\nabla_\theta\log\pi_\theta(a^\ast\mid s)\bigr].$$

把两者并排看：

| 对比项 | 监督学习（最大似然） | 策略梯度 |
|:--|:--|:--|
| 数据 | 固定的、带「正确动作」 $a^\ast$ 的数据集 | 由**当前策略**采样得到 |
| 更新 | $-\nabla_\theta\log\pi_\theta(a^\ast\mid s)$ | $+A(s,a)\cdot\nabla_\theta\log\pi_\theta(a\mid s)$ |
| 权重 | 每个样本权重 1 | 每个样本权重等于**优势** |
| 语义 | 「把这个动作学得更像」 | 「**好的动作**（$A\gt0$）学得更像，**差的动作**（$A\lt0$）学得不像」 |
| 分布 | 与 $\theta$ 无关 | 与 $\theta$ 强耦合（on-policy） |

::: intuition 「优势为负」的样本在做什么
当 $A\lt0$ 时，梯度方向是 $-\nabla_\theta\log\pi_\theta(a\mid s)$，即**降低**该动作的概率。这与「反向最大似然」等价：把 $\nabla\log\pi$ 前面的符号翻过来，就相当于把一个样本从「正样本」变成「负样本」。

这一个观察直接通向 [5.6](sec56.md) 的偏好优化：**如果同一个提示下有两个回答，一个被偏好（$y_w$）、一个不被偏好（$y_l$），那么「提高 $y_w$ 的对数概率、降低 $y_l$ 的对数概率」就非常接近策略梯度在做的事情**。DPO 的损失正是这个直观的、不需要采样奖励模型的精确版本。
:::

## 5.4.7 代码：最小 REINFORCE（自包含环境 + 基线）

下面用一个**完全自包含**的走廊环境（不需要任何环境库，避免版本差异）演示 REINFORCE 的三个关键点：从后往前算回报-to-go、减去基线、以及「更新一次就丢弃数据」。

```python
import torch
import torch.nn as nn

torch.manual_seed(0)

class Corridor:
    """5 个位置 0..4，初始在 2；动作 0=左、1=右。
    走到 4 得 +1 并终止；走到 0 得 −1 并终止；超过 20 步截断。"""
    n_states, n_actions = 5, 2

    def reset(self):
        self.pos, self.t, self.done = 2, 0, False
        return self._obs()

    def _obs(self):
        x = torch.zeros(self.n_states)
        x[self.pos] = 1.0                     # one-hot 状态
        return x

    def step(self, a: int):
        self.pos = min(max(self.pos + (1 if a == 1 else -1), 0), 4)
        self.t += 1
        if self.pos == 4:
            return self._obs(), 1.0, True
        if self.pos == 0:
            return self._obs(), -1.0, True
        return self._obs(), 0.0, self.t >= 20

policy = nn.Sequential(nn.Linear(5, 16), nn.ReLU(), nn.Linear(16, 2))
opt = torch.optim.Adam(policy.parameters(), lr=1e-2)
GAMMA, baseline = 0.95, 0.0

for ep in range(400):
    env, s, done = Corridor(), None, False
    s = env.reset()
    logps, rewards = [], []
    while not done:
        dist = torch.distributions.Categorical(logits=policy(s))   # 策略即分布
        a = dist.sample()
        logps.append(dist.log_prob(a))                             # 记录 ∇_θ log π 的“入口”
        s, r, done = env.step(int(a))
        rewards.append(r)
    # ① 回报-to-go：从后往前累加（因果性：只用 t 之后的奖励）
    G, returns = 0.0, []
    for r in reversed(rewards):
        G = r + GAMMA * G
        returns.append(G)
    returns = torch.tensor(list(reversed(returns)))
    # ② 基线：用“整局回报”的滑动平均当 b（比 V(s) 粗糙，但零成本）
    adv = (returns - baseline).detach()
    # ③ 目标：最大化 Σ log π · A ⇒ 最小化负目标
    loss = -(torch.stack(logps) * adv).sum()
    opt.zero_grad(); loss.backward(); opt.step()
    baseline = 0.9 * baseline + 0.1 * returns[0].item()             # 缓慢更新的基线

# 评估：训练后用确定性策略（取 argmax 概率的动作）跑 100 局
succ = 0
for _ in range(100):
    env, s = Corridor(), None
    s, done, ep_r = env.reset(), False, 0.0
    while not done:
        a = int(torch.argmax(policy(s)).item())                     # 不做探索
        s, r, done = env.step(a)
        ep_r += r
    succ += float(ep_r > 0)
print("成功率 %.0f%%（最优即“一直向右”，两步到达 +1）" % (100 * succ / 100))

# 判据（可直接断言）：
# 1) 400 局后成功率应 > 90%；若停在 ~50%，多半是基线更新太快或学习率过大；
# 2) 把基线一行删掉（adv = returns），成功率会显著下降或震荡 —— 这就是基线的价值；
# 3) 每局数据只用一次（本循环没有回放池）：这是 on-policy 的硬性要求。
```

三点读代码的提示：

1. **`dist.log_prob(a)` 已经替你完成了 $\nabla_\theta\log\pi_\theta$ 的自动微分入口**：PyTorch 的 `Categorical` 在反向时会给出正确的得分函数梯度，不需要手写。
2. **`adv = (returns - baseline).detach()` 里的 `detach()` 必不可少**：基线只是一个**数值参照**，不能让它参与反传（否则会通过基线把梯度引到错误方向；本实现里 baseline 是 Python 标量，影响不大，但换成学习到的 $V_\phi(s)$ 后，**必须** detach，否则策略梯度会与 Critic 的损失耦合）。
3. **环境里「走到 0 得 −1」这条负奖励是必要的**：它给策略提供了「向左会倒霉」的信号。若左右都不给分、只有右边 +1，问题变成稀疏奖励（[5.1](sec51.md) 提到的难点），REINFORCE 需要的样本量会大得多。

::: note CartPole 与 Gymnasium 的版本差异（需注意）
若把上面的环境换成经典控制任务，截至 2025 年的常见接口是 **Gymnasium**（`gym` 的后续维护版本）：`env.reset()` 返回 `(obs, info)` 二元组，`env.step(a)` 返回五元组 `(obs, reward, terminated, truncated, info)`，终止条件要写成 `done = terminated or truncated`。这些签名在 0.26 前后发生过变化，**照抄旧教程的 `obs = env.reset()` 会直接报错或静默错位**。本书的实验代码因此优先使用自包含环境，把外部依赖降到最低。
:::

::: errata 本节常见误解
1. **「策略梯度需要知道环境模型」**：不需要。[推导](sec54.md#thm-5.4.1) 第二步里 $P$ 与 $\rho$ 求导后全部消失——只要能从环境采样，就能估梯度。这是策略梯度相对「规划」的决定性优势。
2. **「$G_t$ 是无偏的，所以 REINFORCE 不需要基线也能训」**：能训，但极慢。无偏只保证「方向对」，不保证「噪声小」；而单样本信噪比常常接近 1（见[例 5.4.1](sec54.md#ex-5.4.1)），需要海量样本才能平均出有效方向。
3. **「可以用旧策略的数据多跑几轮梯度上升」**：纯 REINFORCE 是 on-policy，数据来自 $\pi_{\theta_{\text{old}}}$ 而梯度要求在 $\pi_\theta$ 下求期望。想复用就必须做**重要性采样修正**（PPO 的做法，[5.5](sec55.md)），否则梯度有偏。
4. **「策略概率被压到 0 也没关系」**：$\log\pi_\theta$ 会变成 $-\infty$，梯度爆炸或 NaN；而且一旦某动作概率为 0，探索再也无法恢复它（熵为 0 的死锁）。实现上要保证 softmax 数值稳定，并靠**熵正则**（[5.5](sec55.md)）防止过早坍缩。
5. **「熵越高越好」**：熵只用来维持探索。任务收敛后熵应当下降；若熵一直不降，说明任务没学会或正则系数太大。
:::

::: method 即时自测 · 5.4
**Q1** 写出策略梯度定理，并用一句话解释为什么「好动作抬概率、坏动作压概率」。

**Q2** 为什么必须用回报-to-go $G_t$ 而不是整局回报 $G_0$？给出证明中关键的那一步。

**Q3** 基线 $b(s)$ 为什么不会改变梯度期望？如果基线里混入了当前动作 $a_t$，会发生什么？

**Q4** 用[例 5.4.1](sec54.md#ex-5.4.1)的设定，若把奖励换成 $r(a_1)=2$、$r(a_2)=0$（其余不变），$\theta=0$ 处的真梯度与无基线估计器的标准差分别是多少？

::: sol 参考要点
**Q1** $\nabla_\theta J=\mathbb E_{\pi_\theta}\bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,Q^{\pi_\theta}(s_t,a_t)\bigr]$。$\nabla_\theta\log\pi_\theta(a_t\mid s_t)$ 是「让该动作更频繁」的方向，乘以 $Q$ 后：$Q\gt0$ 的动作为正权重（概率上升），$Q\lt0$ 的动作为负权重（概率下降）。

**Q2** 因为 $t$ 之前的奖励与 $a_t$ **无关**（马尔可夫性把历史封箱在 $(s_t,a_t)$ 里），它们对梯度的期望贡献为 0。关键一步：把 $H_t$ 提出动作求和，得 $h(s_t)\sum_a\nabla_\theta\pi_\theta(a\mid s_t)=h(s_t)\nabla_\theta 1=0$。用 $G_0$ 不会引入偏差，但会把「与当前动作无关的噪声」也乘进去，方差更大。

**Q3** 因为对任意只依赖 $s$ 的 $b$ 有 $\sum_a\pi_\theta(a\mid s)\nabla_\theta\log\pi_\theta(a\mid s)b(s)=b(s)\nabla_\theta\sum_a\pi_\theta(a\mid s)=0$——只用了概率归一化。若 $b$ 依赖 $a_t$（例如用 $Q(s_t,a_t)$ 当基线），这一步的求和不再恒等于 0，梯度期望就**有偏**了：你会同时改变「动作概率」与「参照物」，两者纠缠在一起。

**Q4** $J(\theta)=2\sigma(\theta)$，$\nabla J=2\sigma(1-\sigma)$，$\theta=0$ 时为 $2\times0.25=0.5$。估计器：$a_1$（概率 0.5）给 $\hat g=0.5\times2=1.0$；$a_2$（概率 0.5）给 $\hat g=(-0.5)\times0=0$。期望 $=0.5=\nabla J$ ✓。$\mathrm{Var}=0.5\times1^2-0.25=0.25$，标准差 $0.5$。**结论**：奖励尺度放大两倍，梯度与噪声标准差**同时**放大两倍——信噪比不变。这解释了为什么「只把奖励乘以一个大常数」对 RL 毫无帮助（[5.7](sec57.md) 的失败模式之一）。
:::
:::

::: note[skip] 延伸阅读
- Williams, *Simple Statistical Gradient-Following Algorithms for Connectionist Reinforcement Learning*（*Machine Learning* 8:229–256, 1992）——REINFORCE 原文（含「REINFORCE with baseline」的形式），本节 5.4.4–5.4.5 的历史源头。
- Sutton, McAllester, Singh & Mansour, *Policy Gradient Methods for Reinforcement Learning with Function Approximation*（NIPS 1999 / 2000）——策略梯度定理的严格版本（含状态分布项的抵消论证），附录 C.10 提到的正是这一篇。
- Sutton & Barto, *Reinforcement Learning: An Introduction*（2nd ed., 2018）——第 13 章（策略梯度方法、基线、Actor–Critic 雏形）。
- OpenAI Spinning Up 的 *Intro to Policy Optimization*——用「把策略梯度看作加权最大似然」讲同一件事，与 5.4.6 的视角一致。
- Mohamed, Rosca, Figurnov & Mnih, *Monte Carlo Gradient Estimation in Machine Learning*（2019, arXiv:1906.10652）——把重参数化、score function 与测度变换三类梯度估计统一起来；想弄清「为什么对数导数技巧成立」可读它。
:::

**本节小结**：策略方法跳过了「先学 $Q$ 再取 $\arg\max$」这一步，直接参数化策略并优化期望回报；核心工具是**对数导数技巧**，它把「对分布的导数」变成可采样的期望，并且让**环境动力学从梯度里完全消失**。策略梯度定理的直觉只有一句话：**好动作抬概率、坏动作压概率**。REINFORCE 用实际回报替代 $Q$，无偏但高方差；**因果性**（回报-to-go）与**基线**（优势）是两把几乎零成本的降方差钥匙——而它们的公共引理「只依赖状态的量可以从梯度期望里自由加减」，会在 [5.5](sec55.md) 的 GAE 与 [5.6](sec56.md) 的 DPO 中反复出现。下一节把基线升级成学出来的 Critic，并给出今天最通用的算法：PPO。
