# 5.3 值方法：Q-learning 与 DQN

上一节的所有结论都建立在一个前提上：**你已知 $P$ 与 $R$**，于是可以对着贝尔曼方程做不动点迭代。真实环境里这两个东西通常都拿不到——机器人不知道「关节加 0.3 牛米之后会转到哪里」，推荐系统也不知道「用户看到这条内容后会不会继续滑动」。你能做的只有一件事：**走一步，看结果**。

这一节要回答的是：在**只能采样**的条件下，怎样估计出值函数？答案的核心是**时序差分（temporal difference, TD）学习**——它用一个极其朴素的想法替代了「跑完整局再平均」：**用「走一步实际得到的结果」去修正「当前的估计」**。这个想法催生了 RL 里最有名的算法 Q-learning；而当状态变成图像这种高维连续量、表格存不下时，Q-learning 加上两个工程技巧（**经验回放**与**目标网络**）就成了 DQN。

这一节的组织是「一个想法、两个技巧、一串改良」：5.3.1 讲 TD 这个想法为什么成立；5.3.2 讲 Q-learning 的更新式与它的收敛前提；5.3.3 说明为什么「表格 → 神经网络」会炸；5.3.4 讲 DQN 的两个技巧各自治什么病；5.3.5–5.3.6 补齐 Double DQN、Dueling、优先回放、多步回报与 Rainbow。5.4 会切换到另一条主干——不学值、直接学策略。

## 5.3.1 时序差分：用「走一步」替代「等一局」

先看两种极端的估计方式。**蒙特卡洛（MC）**用一条完整轨迹的实际回报 $G_t$ 当目标：无偏（它的期望正是 $V^\pi(s_t)$），但必须等到一局结束，而且 $G_t$ 里累积了**所有后续步骤的随机性**，方差很大。**动态规划（DP）**用贝尔曼方程的一步展开 $r+\gamma V(s')$ 当目标：方差小，但需要 $P$ 的显式求和。TD 学习是二者的折中：**用一步的真实转移（采样）替代 $P$ 的求和，用当前估计 $V(s')$（自举）替代未知的未来。**

::: def 定义 5.3.1 · 时序差分（TD）误差与 TD(0) 更新 {#def-5.3.1}
走一步得到 $(s_t,a_t,r_{t+1},s_{t+1})$ 后，定义**TD 目标**与 **TD 误差**：
$$\underbrace{y_t=r_{t+1}+\gamma V(s_{t+1})}_{\text{TD 目标}},\qquad
\underbrace{\delta_t=y_t-V(s_t)=r_{t+1}+\gamma V(s_{t+1})-V(s_t)}_{\text{TD 误差}} .$$
**TD(0) 更新**（用于策略评估）：
$$V(s_t)\leftarrow V(s_t)+\alpha\,\delta_t .$$
其中 $\alpha\in(0,1]$ 是学习率（步长）。三点特征：**自举**（目标里含当前估计）、**在线**（每走一步就更新，不必等一局结束）、**只用一步的随机性**（方差小）。
:::

::: intuition TD 误差就是「意外程度」
把 $\delta_t=r_{t+1}+\gamma V(s_{t+1})-V(s_t)$ 读成一句话：**「实际发生的（奖励 + 折扣后的下一状态值）比原来预期的（当前状态值）好了多少」**。

- $\delta_t\gt0$：结果比预期好 → 把 $V(s_t)$ 往上调；
- $\delta_t\lt0$：结果比预期差 → 往下调；
- $\delta_t=0$：恰好符合预期 → 不动。

这个「没意外就不学」的性质是 TD 最美的部分：一旦值函数满足贝尔曼方程，所有 $\delta_t$ 的期望为 0，学习自动停止。它也直接解释了后面两个概念：**优势函数 $A=Q-V$**（[5.5](sec55.md)）其实就是「一步 TD 误差的多步版本」，而 **Critic 的训练目标**就是这个 $\delta$ 的平方。
:::

::: thm 定理 5.3.1 · TD 目标的偏差与方差 {#thm-5.3.1}
（i）**给定 $V=V^\pi$ 时，TD 目标是 $V^\pi(s_t)$ 的无偏估计**：
$$\mathbb E\bigl[r_{t+1}+\gamma V^\pi(s_{t+1})\mid s_t=s,a_t\sim\pi\bigr]=V^\pi(s).$$
（ii）$V$ 是估计值而非真值时，自举引入**偏差**：偏差量级正比于 $\gamma\lVert V-V^\pi\rVert_\infty$。
（iii）对比蒙特卡洛目标 $G_t$：$G_t$ 对 $V^\pi(s_t)$ 无偏但方差随视界增长；TD 目标方差小但（在 $V\ne V^\pi$ 时）有偏。二者构成偏差—方差的两端。
:::

::: proof 证明（(i) 一步全期望；(ii) 偏差上界）
**(i)** 对 $(a_{t+1},s_{t+1})$ 用全期望公式，并把 $V^\pi$ 代入贝尔曼方程：
$$\mathbb E[r_{t+1}+\gamma V^\pi(s_{t+1})\mid s_t=s]
=\sum_a\pi(a\mid s)\Bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^\pi(s')\Bigr]=V^\pi(s),$$
最后一步正是[定理 5.2.1](sec52.md#thm-5.2.1) 的贝尔曼期望方程。

**(ii)** 把 (i) 中的 $V^\pi$ 换成估计 $V$：
$$\Bigl|\mathbb E[r_{t+1}+\gamma V(s_{t+1})\mid s_t=s]-V^\pi(s)\Bigr|
\le\gamma\sum_{s'}P(s'\mid s,a)\,\bigl|V(s')-V^\pi(s')\bigr|\le\gamma\lVert V-V^\pi\rVert_\infty .$$
即自举偏差被 $\gamma$ 与值误差的无穷范数**双重压制**：这也解释了为什么小 $\gamma$ 的 TD 收敛快、大 $\gamma$ 的 TD 更依赖值函数的准确性。$\blacksquare$
:::

::: intuition 这条定理给出了「TD 该不该信」的判据
三句话：① 只要 $V$ 是**精确的**，一步 TD 目标就是无偏的——这是 TD 学习的合法性基础；② 一旦 $V$ 有误差，每一步自举都会**转发**这个误差，且转发系数只有 $\gamma$，所以小 $\gamma$ 的任务里 Critic 可以粗糙一些；③ 由此得到实现上的取舍：$\gamma$ 大时应当**多相信实际回报**（把 GAE 的 $\lambda$ 调大，或直接 Monte Carlo），$\gamma$ 小时可以大胆依赖 Critic（[5.5](sec55.md) 的 $\lambda$ 就是在做这件事）。
:::

| 目标类型 | 用到的信息 | 偏差 | 方差 | 可否在线更新 | 需要 $P$ |
|:--|:--|:--|:--|:--|:--|
| 动态规划（DP） | $r+\gamma\sum_{s'}P(\cdot)V(s')$ | 仅来自 $V$ 的误差 | 最小（无采样） | 是 | **需要** |
| **TD(0)** | $r_{t+1}+\gamma V(s_{t+1})$ | 自举偏差（$\le\gamma\lVert V-V^\pi\rVert$） | 小（只含一步随机性） | 是 | 否 |
| $n$ 步 TD | $r_{t+1}+\cdots+\gamma^{n-1}r_{t+n}+\gamma^nV(s_{t+n})$ | 随 $n$ 减小 | 随 $n$ 增大 | 是（延迟 $n$ 步） | 否 |
| 蒙特卡洛（MC） | 实际回报 $G_t$ | 无偏（在回合制下） | 大（含整局随机性） | 否（需等一局结束） | 否 |

## 5.3.2 Q-learning：off-policy 自举

TD(0) 解决的是「评估一个已知策略」。要**控制**（找到最优策略），最直接的做法是把同样的想法用在 $Q$ 上，并把「按策略取平均」换成「取最大」——对齐贝尔曼最优方程。

::: def 定义 5.3.2 · Q-learning 更新 {#def-5.3.2}
以状态—动作值 $Q(s,a)$ 为表，每走一步就更新一次：
$$Q(s_t,a_t)\leftarrow Q(s_t,a_t)+\alpha\underbrace{\Bigl[\underbrace{r_{t+1}+\gamma\max_{a'}Q(s_{t+1},a')}_{\text{TD 目标}}-Q(s_t,a_t)\Bigr]}_{\text{TD 误差 }\delta_t},$$
其中 $\alpha\in(0,1]$ 是学习率。三个关键词：

- **自举（bootstrapping）**：目标里用的是**当前**对 $Q(s_{t+1},\cdot)$ 的估计，而不是等真值；
- **off-policy**：行为策略（带探索的 $\varepsilon$-greedy）与目标策略（$\max$ 贪心）分离，因此可以用**任意来源**的经验去逼近**最优** $Q^\ast$；
- **收敛条件**：表格形式下，只要每个 $(s,a)$ 被访问无穷多次、且步长满足 Robbins–Monro 条件
  $$\sum_{t}\alpha_t=\infty,\qquad \sum_t\alpha_t^2\lt\infty,$$
  $Q$ 以概率 1 收敛到 $Q^\ast$。
:::

::: intuition 「off-policy」到底省下了什么
on-policy 的意思是「**只能学你正在做的事**」：SARSA 的更新用行为策略真正选出的下一个动作 $a'$，
$$Q(s_t,a_t)\leftarrow Q(s_t,a_t)+\alpha\bigl[r_{t+1}+\gamma Q(s_{t+1},a')\bigr],$$
所以它会**把探索的代价学进去**（如果因为 $\varepsilon$ 随机走了一步坏棋，SARSA 会把这条路的价值调低）。off-policy 的 Q-learning 用 $\max$，学的是「假设之后都做最优选择」的价值——**探索只影响数据来源，不影响学习目标**。

这个区别带来两个直接工程后果：① Q-learning 可以**复用旧数据**（包括别的策略、甚至人类产生的数据），这是经验回放的前提；② 学到的是**最优策略**的价值，而不是「带噪声的行为策略」的价值，因此部署时可以直接关掉探索拿 $\arg\max$。代价是它更「激进」：在危险环境（悬崖行走）里，off-policy 的策略会贴着悬崖走，因为 $\max$ 假设不会失手。
:::

::: proof 收敛性证明的骨架（随机近似视角）
把 Q-learning 写成对**贝尔曼最优算子** $\mathcal T$ 的随机近似迭代：
$$Q_{k+1}(s_t,a_t)=Q_k(s_t,a_t)+\alpha_k\bigl[(\mathcal TQ_k)(s_t,a_t)-\underbrace{Q_k(s_t,a_t)+\xi_k}_{=Q_k(s_t,a_t)}+\xi_k\bigr],$$
其中噪声 $\xi_k=r_{t+1}+\gamma\max_{a'}Q_k(s_{t+1},a')-(\mathcal TQ_k)(s_t,a_t)$ 的**条件期望为 0**（因为 $s_{t+1}\sim P(\cdot\mid s_t,a_t)$ 是无偏采样），且方差有界。两条事实合起来给出结论：

1. $\mathcal T$ 是 $\gamma$-压缩（[定理 5.2.2](sec52.md#thm-5.2.2)），其不动点唯一，即 $Q^\ast$；
2. Robbins–Monro 条件保证「无穷次平均 + 步长平方可和」使噪声项被平均掉，而「步长之和发散」保证还能移动足够远。

因此 $Q_k\to Q^\ast$ 几乎必然成立。**严格证明需要额外的有界性与可测性条件**（如 $Q$ 值有界、更新用的样本对每个 $(s,a)$ 无穷次访问）；本教程只给出骨架，完整论述见 Sutton & Barto 第 2 章与 Bertsekas & Tsitsiklis 的随机近似专著。$\blacksquare$
:::

::: ex 例 5.3.1 · 用同一条转移比较 Q-learning 与 SARSA {#ex-5.3.1}
$Q$ 表（$\gamma=0.9$、$\alpha=0.5$）：

| | $a=\mathrm L$ | $a=\mathrm R$ |
|:--|:--|:--|
| $s_1$ | 2 | 5 |
| $s_2$ | 1 | 4 |

一次交互：从 $s_1$ 出发，$\varepsilon$-greedy 抽到 $a=\mathrm R$，环境返回 $r=2$ 并转到 $s_2$；在 $s_2$ 处行为策略**又抽到了** $a=\mathrm L$。分别写出 Q-learning 与 SARSA 的更新结果，并解释差异。

::: proof 解
**Q-learning（off-policy，用 $\max$）**：
$$y=2+0.9\times\max\{Q(s_2,\mathrm L),Q(s_2,\mathrm R)\}=2+0.9\times4=5.6,\qquad \delta=5.6-5=0.6,$$
$$Q(s_1,\mathrm R)\leftarrow 5+0.5\times0.6=5.3 .$$

**SARSA（on-policy，用实际选中的 $a'=\mathrm L$）**：
$$y=2+0.9\times Q(s_2,\mathrm L)=2+0.9\times1=2.9,\qquad \delta=2.9-5=-2.1,$$
$$Q(s_1,\mathrm R)\leftarrow 5+0.5\times(-2.1)=3.95 .$$

**解释**：同一条转移、同样的 $Q$ 表，两个算法给出的新值差了 1.35。差别只在于「未来怎么算」——Q-learning 认为「之后会做最优选择」所以乐观（5.6），SARSA 把行为策略实际会做的（次优）选择算进去所以保守（2.9）。这正是 **off-policy 与 on-policy 的实操分水岭**：如果探索带来的坏结果不该被记入策略价值（例如探索只是训练手段），用 Q-learning；如果「行为策略的失误本来就该计入风险」（例如安全攸关的部署），SARSA 的更保守估计反而更贴合真实代价。$\blacksquare$
:::
:::

## 5.3.3 从表格到函数逼近：为什么直接上神经网络会炸

表格 Q-learning 有三个硬限制：$\lvert\mathcal S\rvert$ 稍大就存不下；没见过状态只能给 0（**没有泛化**）；每个 $(s,a)$ 都要被访问很多次才能收敛（**样本效率低**）。自然的想法是用神经网络 $Q_\theta(s,a)$ 逼近 $Q^\ast$——把 TD 误差的平方当损失：

$$\mathcal L(\theta)=\mathbb E_{(s,a,r,s')\sim\mathcal D}\Bigl[\bigl(r+\gamma\max_{a'}Q_\theta(s',a')-Q_\theta(s,a)\bigr)^2\Bigr].$$

但**朴素地这么做会剧烈震荡甚至发散**。两个病因必须分开看：

1. **样本高度相关且非平稳**：相邻的 $(s_t,a_t,r,s_{t+1})$ 由转移连接，几乎必然强相关；策略一改，数据分布随之漂移。而监督学习的所有收敛性结论都依赖「i.i.d. 采样」。
2. **目标在动**：损失里的**目标** $r+\gamma\max_{a'}Q_\theta(s',a')$ 自己含 $\theta$。每更新一次参数，目标就跟着变——等于在追一个**自己也在跑的靶子**。这与监督学习中「标签固定」有本质区别。

::: think 为什么 RL 的样本不是 i.i.d.，以及回放为什么「合法」
监督学习可以打乱数据集，是因为各样本本来就近乎独立。RL 不同：$s_{t+1}$ 由 $(s_t,a_t)$ 决定，直接拿连续样本更新会像反复端详同一张图——梯度被同一段轨迹主导，容易灾难性遗忘其他状态。回放池把不同时刻、不同策略的经历混合后随机抽样，等于人为地把「非平稳、相关的数据流」改造成「近似平稳的样本集合」。

它之所以**合法**，是因为 Q-learning 本身 off-policy：目标里对 $s'$ 取 $\max$，**不依赖产生这条数据的那个策略**。换成纯 on-policy 方法（如 REINFORCE）就不能随意复用旧数据了——除非像 PPO 那样做重要性修正（[5.5](sec55.md)），或像离线 RL 那样额外处理分布偏移（[5.6](sec56.md)）。
:::

## 5.3.4 DQN：两个技巧，两个病因

::: method DQN 的两大稳定技巧 {#method-5.3.1}
**技巧一 · 经验回放（experience replay）**：把每条转移 $(s,a,r,s')$ 存入回放池 $\mathcal D$，训练时从中**随机采样**一个 mini-batch。

- 打破相邻轨迹的**时序相关**，让梯度更接近 i.i.d. 假设；
- 同一条经验能被**反复使用**，样本效率远高于用一次就丢的在线更新；
- 不同策略（不同时刻、不同探索率）产生的旧数据混在一起，也天然满足 off-policy 的复用需求；
- **代价**：内存（Atari 设置下 $10^6$ 条 $\times\,4$ 帧 $\times\,84\times84$ 像素 $\approx$ 28 GB 的 uint8 存储）与「数据陈旧」（池里可能塞满早期坏策略的经历）。

**技巧二 · 目标网络（target network）**：复制一份参数 $\theta^-$ 专门用来算 TD 目标，它**每隔 $C$ 步才与在线网络同步**（或做缓慢 Polyak 平均 $\theta^-\leftarrow\tau\theta+(1-\tau)\theta^-$）：
$$\mathcal L(\theta)=\mathbb E_{(s,a,r,s')\sim\mathcal D}\Bigl[\bigl(\underbrace{r+\gamma\max_{a'}Q_{\theta^-}(s',a')}_{\text{目标：}\theta\text{ 被冻结}}-\underbrace{Q_\theta(s,a)}_{\text{预测：要反传}}\bigr)^2\Bigr].$$

目标里的 $\theta^-$ 在若干步内**冻结不动**，相当于把「移动靶」钉住一段时间，回归问题才稳定。**注意**：只有 $Q_\theta(s,a)$ 侧要反传梯度，$\theta^-$ 侧视为常数（实现上用 `torch.no_grad()` 包住目标计算）。

**探索**：用 $\varepsilon$-greedy 选动作——以概率 $\varepsilon$ 均匀随机、否则取 $\arg\max_aQ_\theta(s,a)$，并让 $\varepsilon$ 从约 1.0 衰减到一个小值（如 0.05–0.1）。

**终止状态的处理**：TD 目标里的自举项必须用掩码关掉——$y=r+\gamma(1-\text{done})\max_{a'}Q_{\theta^-}(s',a')$。忘了这个掩码，等于告诉网络「游戏结束后还能继续得分」，是最常见的隐性 bug。
:::

::: intuition 两个技巧分别治什么病（一句话对照）
**回放治「数据相关」，目标网络治「目标在动」。** 诊断训练不稳时，先按这两条各查一遍：如果 loss 曲线像噪声（高频抖动），多半是数据相关性/批太小；如果 Q 值整体膨胀到离谱（或突然塌成常数），多半是目标不稳或学习率太大。这两条检查也直接对应 [5.7](sec57.md) 的失败模式表。

还有一个容易忽视的细节：**回放池里的数据来自旧策略，而 Q-learning 的 $\max$ 目标不关心这一点**——这就是「合法」的技术原因。但它也埋下伏笔：当数据完全无法更新（离线 RL）时，$\max$ 会去查询**数据里不存在的动作**，于是估值外推失控（[5.6](sec56.md)）。
:::

| 算法 | 每步计算复杂度 | 内存 | 关键超参数（Mnih et al. 2015 的 Atari 配置） | 主要代价 |
|:--|:--|:--|:--|:--|
| 表格 Q-learning | $O(1)$（查表） | $O(\lvert\mathcal S\rvert\lvert\mathcal A\rvert)$ | $\alpha$、$\varepsilon$ 调度 | 无泛化；状态稍大就爆 |
| **DQN** | 一次前向 + 一次反向，$O(\#\text{params})$ | 网络参数 + 回放池 | 回放 $10^6$；目标同步每 $10^4$ 步；batch 32；$\gamma=0.99$；RMSProp lr $2.5\times10^{-4}$，momentum 0.95；$\varepsilon$ 在首个 $10^6$ 帧内从 1.0 线性降到 0.1；帧跳 4 | 样本量（常需 $10^7$ 级帧数）；调参敏感 |
| Double DQN | 同 DQN（多一次前向） | 同 DQN | 同 DQN | 几乎零额外成本 |
| Dueling DQN | 同 DQN | 同 DQN | 同 DQN | 改网络头部结构 |
| Prioritized Replay | 同 DQN + 采样 $O(\log N)$ | 回放池 + 优先级树 | 指数 $\alpha_{\text{per}}$、重要性采样指数 $\beta$ | 实现复杂；对异常 TD 误差敏感 |
| Rainbow | 同 DQN（多分布式头） | 同 DQN | 六个组件的超参数叠加 | 代码复杂度高；复现门槛高 |

## 5.3.5 取 $\max$ 的代价：过高估计与 Double DQN

::: intuition 取 $\max$ 为什么会让 DQN「过于乐观」
TD 目标里有一个 $\max_{a'}$。无论 $Q$ 的估计噪声是正是负，**取最大值都会倾向挑到那些被偶然高估的动作**，于是目标被系统性地抬高，$Q$ 值整体虚高。这不是实现 bug，而是 $\max$ 的数学性质：对随机变量取凸函数（$\max$ 是凸的）不满足「期望与函数可交换」。

修正思路是**把「选动作」和「评估动作」拆开**：**Double DQN** 用在线网络 $\theta$ 选出最优动作，却用目标网络 $\theta^-$ 去评估它的价值，
$$y=r+\gamma\,Q_{\theta^-}\bigl(s',\ \arg\max_{a'}Q_\theta(s',a')\bigr).$$
这样一次噪声很难同时骗过两个网络，过高估计显著缓解。这里只需记住结论：**单网络取 $\max$ 会乐观，双网络分工可纠偏**。
:::

::: thm 定理 5.3.2 · 过高估计的下界与量级 {#thm-5.3.2}
设真实值 $Q^\star(s',a)=\bar Q$ 对所有动作相同，而估计为 $\hat Q(s',a)=\bar Q+\varepsilon_a$，其中 $\{\varepsilon_a\}$ 是均值为 0 的独立噪声。则
$$\mathbb E\bigl[\max_a\hat Q(s',a)\bigr]\ \ge\ \max_a\mathbb E[\hat Q(s',a)]=\bar Q,$$
即**单步 TD 目标至少与真值一样乐观，且通常严格更大**。若 $\{\varepsilon_a\}$ 近似 i.i.d. 正态 $\mathcal N(0,\sigma^2)$、动作数为 $N$，则极值近似给出
$$\mathbb E\bigl[\max_a\varepsilon_a\bigr]\approx\sigma\sqrt{2\ln N}.$$
:::

::: proof 证明（Jensen 不等式 + 极值近似）
**第一步（下界）**：$\max$ 是凸函数，由 Jensen 不等式 $\mathbb E[\max_a\hat Q_a]\ge\max_a\mathbb E[\hat Q_a]=\bar Q$。等号仅在「所有动作的估计以概率 1 排序一致」时成立，而噪声下这不成立，故一般严格大于。

**第二步（量级）**：对 i.i.d. $\mathcal N(0,\sigma^2)$ 的 $N$ 个样本，最大值近似服从 Gumbel 分布，其均值为 $\sigma\sqrt{2\ln N}\bigl(1-\frac{\ln\ln N+O(1)}{4\ln N}\bigr)$。忽略修正项即得 $\sigma\sqrt{2\ln N}$。**注意方向**：噪声越大（$\sigma$ 大）、动作越多（$N$ 大），过高估计越严重——这与经验一致。

**第三步（为什么它会累积）**：自举把这一步的偏差塞进下一轮目标，在 Q-learning 的迭代里被反复放大；Double DQN 原论文附录给出了一维与二维 MDP 的严格分析（结论以原论文为准），工程上的经验法则是：**$\gamma$ 越接近 1，虚高越明显**。$\blacksquare$
:::

::: intuition 为什么「乐观」是有害的而不只是「不精确」
虚高的 Q 值本身不致命——致命的是它**改变了动作排序**：策略会系统性地偏好那些「估值噪声大」的动作（通常是少见动作或在探索边缘的动作），于是数据分布进一步偏向这些区域，噪声继续变大。这与离线 RL 的外推失控（[5.6](sec56.md)）是同一个机制的不同版本：**$\max$ 总在寻找最乐观的那条路，而不是最可靠的那条路**。
:::

::: ex 例 5.3.2 · 过高估计的量级估算 {#ex-5.3.2}
某离散控制任务有 $N=10$ 个动作，$Q$ 网络对 $s'$ 的估值误差近似 i.i.d. 正态、$\sigma=1$（真值相同，为 $\bar Q$）。问单步 TD 目标平均高估多少？若把动作数换成 $N=100$ 呢？

::: proof 解
用 $\sigma\sqrt{2\ln N}$：

- $N=10$：$\sqrt{2\ln 10}=\sqrt{2\times2.3026}=\sqrt{4.605}\approx2.15$，即平均高估约 **2.15**（与奖励尺度同量级！）。
- $N=100$：$\sqrt{2\ln 100}=\sqrt{9.210}\approx3.03$，平均高估约 **3.03**。

**结论**：当奖励数量级是 $O(1)$ 时，一个 $\sigma=1$ 的估值噪声就能带来同量级的高估——这解释了为什么朴素 DQN 常出现「Q 值一路膨胀、策略却在退化」。两个降噪手段直接对症：**加大 batch / 多步回报降低 $\sigma$**，或**用 Double DQN 去掉 $\max$ 的偏置**。注意这个估算是「噪声独立同分布」的理想化假设，实际误差有相关性，数值会不同——它给的是量级，不是精确预测。$\blacksquare$
:::
:::

## 5.3.6 一串改良：Dueling、优先回放、多步回报与 Rainbow

DQN 之后的几年，社区沿着「更准的值、更高的样本效率」做了四类明确的改良；它们彼此正交，最后被组合成一个条目式的算法 **Rainbow**。

::: method Dueling / 优先回放 / 多步回报 {#method-5.3.2}
**① Dueling 网络（优势—价值分解）**：把输出拆成「状态本身有多好」与「动作相对好多少」两条支路，
$$Q_\theta(s,a)=V_\eta(s)+\Bigl(A_\psi(s,a)-\frac{1}{\lvert\mathcal A\rvert}\sum_{a'}A_\psi(s,a')\Bigr).$$
减去均值是为了**消除不可辨识性**（否则 $V$ 与 $A$ 可以同时加减同一个常数而 $Q$ 不变）。收益：在「动作选择无所谓」的状态上，$V$ 支路能高效学到东西，而不必逐动作试。

**② 优先回放（Prioritized Experience Replay, PER）**：按 TD 误差的大小采样——误差大说明「还没学会」。
$$P(i)=\frac{p_i^{\alpha_{\text{per}}}}{\sum_k p_k^{\alpha_{\text{per}}}},\qquad p_i=|\delta_i|+\epsilon_{\text{per}} .$$
优先采样改变了数据分布，因此必须用**重要性采样权重**修正梯度偏差：
$$w_i=\Bigl(\frac{1}{N\cdot P(i)}\Bigr)^{\beta},\qquad \mathcal L=\mathbb E_i\bigl[w_i\cdot(\text{TD 误差})_i^2\bigr],$$
$\beta$ 从初始值线性退火到 1（完全修正）。**代价**：异常 TD 误差（例如奖励尖峰）会被过度反复训练，需要用 $|\delta|$ 截断或 $p_i$ 上限来保护。

**③ 多步回报（$n$-step return）**：把 TD 目标从一步推广到 $n$ 步，
$$y_t^{(n)}=\sum_{k=0}^{n-1}\gamma^{k}r_{t+k+1}+\gamma^{n}\max_{a'}Q_{\theta^-}(s_{t+n},a'),$$
用一点偏差换更多方差下降。实践中 $n=3$ 或 $5$ 常带来明显加速；它与 [5.5](sec55.md) 的 **GAE** 是同一族思想（那里用指数加权把不同 $n$ 混起来）。
:::

::: intuition 三个改良各自的「靶子」
Dueling 改的是**表示**（让网络更容易表达「状态好坏」）；PER 改的是**采样**（把梯度花在还没学会的样本上）；多步回报改的是**目标**（少依赖自举、多信实际数据）。它们与 Double DQN 分别对应「表示 / 采样 / 目标 / 偏置」四个不同层面，因此可以叠加——这正是 Rainbow 的出发点。

工程顺序建议：**先 Double + 多步（几乎零成本）→ 再 Dueling（改结构）→ 最后 PER（实现最复杂、最需要调参）**。反过来一次性上 Rainbow，出问题时很难定位是哪一块造成的。
:::

::: note Rainbow 一句话
**Rainbow**（Hessel et al., 2017, arXiv:1710.02298）把六个组件——Double Q-learning、优先回放、Dueling、多步回报、分布式值（C51）、噪声网络（NoisyNet）——合并进同一个 DQN 框架，并给出逐组件消融：**单个组件都有正收益，且大部分收益可以叠加**。它本身不是新算法，而是「这一族改良的工程量清单」，也是复现课程作业时最值得参照的组织方式。
:::

| 组件 | 解决的问题 | 改动位置 | 额外成本 |
|:--|:--|:--|:--|
| Double Q-learning | $\max$ 带来的过高估计 | TD 目标 | 一次额外前向 |
| 优先回放 | 均匀采样把梯度浪费在已学会的样本上 | 采样策略 + 重要性权重 | 采样 $O(\log N)$、需调 $\alpha_{\text{per}},\beta$ |
| Dueling | 「动作无关紧要的状态」学得慢 | 网络头 | 改结构，无额外前向 |
| 多步回报 | 自举偏差太大 | TD 目标 | 需存 $n$ 步缓存 |
| 分布式值（C51） | 只学期望丢掉了回报分布信息 | 输出层（分位数/直方图） | 输出维数 $\times$ 原子数 |
| 噪声网络 | $\varepsilon$-greedy 探索效率低 | 参数化（可学习噪声） | 参数翻倍 |

## 5.3.7 代码：DQN 的目标构造与更新（含 `done` 掩码）

完整的训练循环在 [5.7](sec57.md) 逐行讲解；这里只把最容易写错的两处——**TD 目标的构造**与**目标网络的同步**——单独拎出来，并用形状断言钉住。

```python
import torch
import torch.nn as nn

class QNet(nn.Module):
    def __init__(self, obs_dim: int, n_act: int, hidden: int = 128):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(obs_dim, hidden), nn.ReLU(),
            nn.Linear(hidden, hidden), nn.ReLU(),
            nn.Linear(hidden, n_act),
        )

    def forward(self, s: torch.Tensor) -> torch.Tensor:      # (B, obs_dim) -> (B, n_act)
        return self.net(s)

def td_target(target_net, online_net, s2, r, done, gamma, double=True):
    """构造 TD 目标。double=True 即 Double DQN：在线网络选动作、目标网络评估。"""
    with torch.no_grad():                                    # θ⁻ 侧永远不反传
        if double:
            a_star = online_net(s2).argmax(dim=1, keepdim=True)       # (B,1) 选动作
            q_next = target_net(s2).gather(1, a_star).squeeze(1)      # (B,)  评估动作
        else:
            q_next = target_net(s2).max(dim=1).values
        return r + gamma * (1.0 - done) * q_next             # done=1 时不再自举

def dqn_update(online, target, optimizer, batch, gamma=0.99, tau=None):
    """batch = (s, a, r, s2, done)，done 用 0/1 浮点掩码。"""
    s, a, r, s2, done = batch
    q_sa = online(s).gather(1, a[:, None]).squeeze(1)         # (B,) 只对预测侧求梯度
    y = td_target(target, online, s2, r, done, gamma, double=True)
    # Huber：对大 TD 误差是线性而非平方，抑制离群值（DQN 原论文即用误差裁剪）
    loss = nn.functional.smooth_l1_loss(q_sa, y)
    optimizer.zero_grad()
    loss.backward()
    # 梯度裁剪是 DQN 的实用默认做法，防止单批异常样本把网络推翻
    nn.utils.clip_grad_norm_(online.parameters(), max_norm=10.0)
    optimizer.step()
    if tau is None:
        return loss.item(), None
    # 软同步（Polyak）：θ⁻ ← τθ + (1−τ)θ⁻，比硬拷贝更平滑
    for p_t, p in zip(target.parameters(), online.parameters()):
        p_t.data.mul_(1.0 - tau).add_(p.data, alpha=tau)
    return loss.item(), None

# 硬同步：每 C 步拷一次参数（C 常取 10^3–10^4；太频繁等于没有目标网络）
def hard_sync(online, target):
    target.load_state_dict(online.state_dict())

if __name__ == "__main__":
    B, OBS, ACT = 32, 8, 4
    online, target = QNet(OBS, ACT), QNet(OBS, ACT)
    hard_sync(online, target)
    opt = torch.optim.Adam(online.parameters(), lr=1e-3)
    s  = torch.randn(B, OBS); s2 = torch.randn(B, OBS)
    a  = torch.randint(0, ACT, (B,)); r = torch.randn(B); done = (torch.rand(B) < 0.2).float()
    # 形状断言：TD 目标与 Q(s,a) 都必须是 (B,)，否则广播会「静默地」训练错东西
    y = td_target(target, online, s2, r, done, 0.99)
    assert y.shape == (B,) and online(s).gather(1, a[:, None]).squeeze(1).shape == (B,)
    print("首个 batch loss =", dqn_update(online, target, opt, (s, a, r, s2, done))[0])
```

三点读代码的提示：

1. **`gather` 这一行是最常见的错误来源**：`online(s)` 的形状是 `(B, n_act)`，直接减 $y$ 会广播成 `(B, n_act)`，损失看起来「在下降」但学的是全动作的均方误差。必须用 `gather(1, a[:, None])` 精确取出 $Q(s,a)$。
2. **`with torch.no_grad()` 不是可选优化**：漏掉它，梯度会流进 $\theta^-$，两个网络被同一个损失「一起拽」，目标网络就退化了。
3. **`done` 掩码的位置**：它乘在**自举项**上，不乘即时奖励 $r$。写反了会让终止前的最后一步奖励被抹掉（一个非常隐蔽的性能损失）。

::: errata 本节常见误解
1. **「Q-learning 和 DQN 是两件事」**：DQN = Q-learning + 函数逼近 + 两个稳定化技巧。把 DQN 的损失写出来，它和表格更新式的差别只是「用梯度替代了逐项赋值」。
2. **「经验回放可以随便用在任何算法上」**：只有在 **off-policy**（或做了重要性修正）的算法里才能复用旧数据。把回放池塞给 REINFORCE，会引入未校正的分布偏移，梯度有偏。
3. **「$\varepsilon$ 衰减得越快越好」**：衰减太快等于提前放弃探索，回报曲线会「早早封顶」在次优；这是 [5.7](sec57.md) 的失败模式之一。经验做法是把 $\varepsilon$ 的衰减周期设为总步数的 $1/10$–$1/5$。
4. **「目标网络每步同步也无所谓」**：每步同步等价于没有目标网络，训练极易发散。目标网络的稳定来自「目标在若干步内不动」，同步周期 $C$ 是**关键**超参数。
5. **「Q 值变大说明学得好」**：Q 值整体膨胀既可能来自学习，也可能来自**过高估计**（[定理 5.3.2](sec53.md#thm-5.3.2)）。判断依据是**回报曲线**，不是 Q 值曲线。
6. **「连续动作空间用 DQN + 动作离散化就行」**：$y=r+\gamma\max_{a'}Q(s',a')$ 中的 $\max$ 在连续动作上是一个**内层优化**，逐点枚举不可行。连续控制应改用策略方法（PPO 直接参数化高斯策略）或专门的 Actor–Critic 变体（DDPG / TD3 / SAC）。
:::

::: method 即时自测 · 5.3
**Q1** 写出 TD 误差的定义，并用一句话解释「$\delta_t=0$ 时学习应该停止」的原因。

**Q2** 用[例 5.3.1](sec53.md#ex-5.3.1)的 $Q$ 表，若那次在 $s_2$ 处行为策略抽到的是 $a=\mathrm R$ 而不是 $\mathrm L$，Q-learning 与 SARSA 的更新结果会变得一样吗？

**Q3** DQN 的「经验回放」与「目标网络」分别针对哪个病因？如果只去掉目标网络但保留回放，训练会怎样变化（现象层面）？

**Q4** 动作数 $N=4$、估值噪声 $\sigma=0.5$ 时，$\max$ 的平均高估量级是多少？为什么加大 batch 能减轻它？

::: sol 参考要点
**Q1** $\delta_t=r_{t+1}+\gamma V(s_{t+1})-V(s_t)$（或 $Q$ 版本）。若所有 $\delta_t$ 的期望为 0，说明当前值函数已满足贝尔曼方程，继续更新只会把噪声写成参数，因此学习应当停止（这也是「TD 误差收敛」作为停止判据的原理）。

**Q2** 会。此时 SARSA 的目标也是 $2+0.9\times Q(s_2,\mathrm R)=2+3.6=5.6$，与 Q-learning 的 $\max$ 目标相同（因为贪心动作恰好就是行为策略选中的动作）。**要点**：两个算法的差异只在「下一步动作按谁选」——行为策略恰好选中最优动作时二者重合；差异大小取决于探索强度与策略次优程度。

**Q3** 回放治「样本相关 + 数据只能用一次」，目标网络治「目标随参数移动」。只去掉目标网络（TD 目标用在线网络现算）：目标与预测共享同一组参数，等于在追自己——典型现象是 **loss 剧烈抖动、Q 值单调膨胀或突然塌缩、成功率在不同种子间差异极大**；基础回放仍在，所以样本相关性不是主因，但两条病因会互相放大。

**Q4** $\sigma\sqrt{2\ln N}=0.5\times\sqrt{2\ln 4}=0.5\times\sqrt{2.773}\approx0.83$。**加大 batch 为什么有用**：过高估计来自「对 $Q$ 估计噪声取 $\max$」。在给定训练数据量下，减小 batch 会提高梯度噪声 → 估值噪声 $\sigma$ 变大 → $\max$ 的偏移变大；反过来，大 batch / 更多数据 / 多步回报都能降低 $\sigma$，从而减小虚高。更彻底的办法是 Double DQN：**直接去掉 $\max$ 的偏置**，而不是只降噪。
:::
:::

::: note[skip] 延伸阅读
- Sutton & Barto, *Reinforcement Learning: An Introduction*（2nd ed., 2018）——第 6 章（TD 学习、SARSA、Q-learning、$n$ 步自举）。本节 5.3.1–5.3.2 的推导与之同源。
- Mnih et al., *Human-level control through deep reinforcement learning*（*Nature* 518:529–533, 2015）——DQN 的 Nature 版本（含回放池、目标网络与 Atari 配置）；更早的会议版本为 *Playing Atari with Deep Reinforcement Learning*（2013, arXiv:1312.5602）。
- van Hasselt, Guez & Silver, *Deep Reinforcement Learning with Double Q-learning*（2016, arXiv:1509.06461）——过高估计的分析与 Double DQN。
- Wang et al., *Dueling Network Architectures for Deep Reinforcement Learning*（2016, arXiv:1511.06581）——优势—价值分解与不可辨识性的处理。
- Schaul et al., *Prioritized Experience Replay*（2016, arXiv:1511.05952）——优先采样与重要性权重退火。
- Hessel et al., *Rainbow: Combining Improvements in Deep Reinforcement Learning*（2018, arXiv:1710.02298）——六组件合并与消融表。也是本讲「工程清单」的参照。
- OpenAI Spinning Up 的 *Intro to Policy Optimization*——从「为什么不用 $Q$」过渡到 5.4，衔接自然。
:::

**本节小结**：TD 学习用一个朴素的想法绕过了「已知 $P$」与「等一局结束」两个限制——**用走一步的实际结果去修正估计**；Q-learning 把它用在最优方程上，成为 off-policy、可复用旧数据的表格算法，其收敛需要「充分访问 + Robbins–Monro 步长」。换成神经网络后，两个新病因（样本相关、目标移动）分别由**经验回放**与**目标网络**压制；而 $\max$ 带来的过高估计由 **Double DQN** 纠偏，另外三类改良（Dueling / PER / 多步）与 Double 一起组成 Rainbow 的清单。下一节换一条主干：**不学值函数，直接对策略求梯度**。
