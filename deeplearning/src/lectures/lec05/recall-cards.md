# 第 5 讲 · 闭卷回忆卡

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起，只重做 △ 与 ×。共 42 张卡（定义 12 + 结论 10 + 公式 10 + 陷阱 10），一轮约 45 分钟。
> 卡后括号里的链接指向正文依据，自检时若「写得出来但讲不清依据」，回到对应节。

## A. 定义卡

**A1.** 写出 MDP 五元组，并说明「马尔可夫性」在工程上最实用的那句推论。
::: sol
$(\mathcal S,\mathcal A,P,R,\gamma)$：状态空间、动作空间、转移概率 $P(s'\mid s,a)$、奖励函数 $r(s,a)$、折扣因子 $\gamma\in[0,1)$。马尔可夫性 $P(s_{t+1}\mid s_t,a_t,\dots,s_0)=P(s_{t+1}\mid s_t,a_t)$ ⇒ **$(s_t,a_t)$ 是未来的充分统计量**：状态定义得足够（必要时帧堆叠 / 隐状态 / POMDP 信念）就不必回放历史；反之，若「同样状态同样动作的结果分布不同」，说明状态不够（[定义 5.2.1](sec52.md#def-5.2.1)）。（✓ / △ / ×）
:::

**A2.** 写出折扣回报 $G_t$ 与 RL 的优化目标 $J$，并说出必须打折的三个理由。
::: sol
$G_t=\sum_{k\ge0}\gamma^{k}r_{t+k+1}$；$J(\pi)=\mathbb E_{s_0\sim\rho}[V^\pi(s_0)]=\mathbb E_{\tau\sim p_\pi}[G_0]$。三个理由：① **数学必要性**（无限时域 $\gamma=1$ 且奖励有正下界时 $G_0$ 发散、值函数无定义）；② **表达偏好**（远期更不可控、更不值钱）；③ **降方差**（远期随机量被指数衰减）。等效视野约 $1/(1-\gamma)$（[定义 5.2.3](sec52.md#def-5.2.3)）。（✓ / △ / ×）
:::

**A3.** 写出 $V^\pi$ 与 $Q^\pi$ 的定义与两者的关系式；为什么「换动作会不会更好」必须用 $Q$？
::: sol
$V^\pi(s)=\mathbb E_\pi[G_t\mid s_t=s]$、$Q^\pi(s,a)=\mathbb E_\pi[G_t\mid s_t=s,a_t=a]$；关系 $V^\pi(s)=\sum_a\pi(a\mid s)Q^\pi(s,a)$、$Q^\pi(s,a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^\pi(s')$。$V$ 回答「按现在的策略走下去能拿多少分」（**评估**），$Q$ 回答「先做这个动作、之后按策略走能拿多少分」（**选择**）；$V$ 已经把动作按老策略平均掉了，所以不能用来比较动作（[定义 5.2.4](sec52.md#def-5.2.4)、[命题 5.2.1](sec52.md#prop-5.2.1)）。（✓ / △ / ×）
:::

**A4.** 「贝尔曼期望方程」与「贝尔曼最优方程」各是什么？差别在哪一步？
::: sol
期望方程：$V^\pi(s)=\sum_a\pi(a\mid s)\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^\pi(s')\bigr]$（**线性**方程组，解 $(I-\gamma P^\pi)^{-1}\boldsymbol r^\pi$）；最优方程：把 $\sum_a\pi(a\mid s)$ 换成 $\max_a$，得 $V^\ast$、$Q^\ast$（**非线性**不动点）。差别的代价：$\max$ 不可线性求解，但换来了「唯一最优值 + 确定性贪心最优策略」（[定理 5.2.1](sec52.md#thm-5.2.1)、[定理 5.2.2](sec52.md#thm-5.2.2)）。（✓ / △ / ×）
:::

**A5.** 定义 TD 目标、TD 误差与 TD(0) 更新；三个特征是什么？
::: sol
$y_t=r_{t+1}+\gamma V(s_{t+1})$、$\delta_t=y_t-V(s_t)$、$V(s_t)\leftarrow V(s_t)+\alpha\delta_t$。三个特征：**自举**（目标含当前估计）、**在线**（走一步就能更新）、**只用一步随机性**（方差小）。直觉：$\delta_t$ 是「意外程度」——$\delta\gt0$ 上调、$\lt0$ 下调、$=0$ 不动；当值函数满足贝尔曼方程时所有 $\delta$ 期望为 0，学习自动停止（[定义 5.3.1](sec53.md#def-5.3.1)）。（✓ / △ / ×）
:::

**A6.** 写出 Q-learning 更新式与它的三个关键词；收敛需要什么条件？
::: sol
$Q(s_t,a_t)\leftarrow Q(s_t,a_t)+\alpha\bigl[r_{t+1}+\gamma\max_{a'}Q(s_{t+1},a')-Q(s_t,a_t)\bigr]$。关键词：**自举**、**off-policy**（行为策略带探索、目标策略取 $\max$，所以能复用任意来源的经验逼近 $Q^\ast$）、**收敛条件**（每个 $(s,a)$ 被访问无穷多次 + 步长满足 Robbins–Monro：$\sum\alpha_t=\infty$、$\sum\alpha_t^2\lt\infty$）（[定义 5.3.2](sec53.md#def-5.3.2)）。（✓ / △ / ×）
:::

**A7.** 策略梯度定理的两种写法（轨迹形式与状态分布形式）与一句话直觉。
::: sol
$\nabla_\theta J(\theta)=\mathbb E_{\pi_\theta}\bigl[\sum_{t\ge0}\nabla_\theta\log\pi_\theta(a_t\mid s_t)Q^{\pi_\theta}(s_t,a_t)\bigr]=\mathbb E_{s\sim d^{\pi_\theta}}\bigl[\sum_a\pi_\theta(a\mid s)\nabla_\theta\log\pi_\theta(a\mid s)Q^{\pi_\theta}(s,a)\bigr]$。直觉：**好动作抬概率、坏动作压概率**。注意 $d^{\pi_\theta}$ 依赖 $\theta$ 但未出现在梯度的显式式子里——它被数学抵消了（[定理 5.4.1](sec54.md#thm-5.4.1)）。（✓ / △ / ×）
:::

**A8.** 优势函数与它的两条基本性质；它与「一步 TD 误差」是什么关系？
::: sol
$A^\pi(s,a)=Q^\pi(s,a)-V^\pi(s)$，其中 $V^\pi(s)=\sum_a\pi(a\mid s)Q^\pi(s,a)$。性质：① $\sum_a\pi(a\mid s)A^\pi(s,a)=0$（基线无偏性的推论）；② $A=0$ 是「平均水平」，只有 $A\gt0$ 才值得抬概率。$\delta_t=r_{t+1}+\gamma V(s_{t+1})-V(s_t)$ 是**一步**残差；当 $V=V^\pi$ 时 $A^\pi(s_t,a_t)=\mathbb E[\sum_{l\ge0}\gamma^l\delta_{t+l}]$，即**多步版本**，GAE 就是把这条关系做成了连续的 $\lambda$（[定义 5.5.1](sec55.md#def-5.5.1)、[定理 5.5.1](sec55.md#thm-5.5.1)）。（✓ / △ / ×）
:::

**A9.** GAE 的闭式与递归式；$\lambda=0$ 与 $\lambda=1$ 各退化成什么？
::: sol
$\hat A_t^{\text{GAE}}=\sum_{l\ge0}(\gamma\lambda)^l\delta_{t+l}=\delta_t+\gamma\lambda\hat A_{t+1}$（$\hat A_T=0$，一次从后往前的循环即可算完）。$\lambda=0\Rightarrow\hat A_t=\delta_t$（一步 TD：偏差大、方差小）；$\lambda=1\Rightarrow\hat A_t=G_t-V(s_t)$（蒙特卡洛：偏差小、方差大）（[定理 5.5.1](sec55.md#thm-5.5.1)）。（✓ / △ / ×）
:::

**A10.** PPO 的概率比 $\rho_t$、裁剪替代目标与完整目标（三项）分别是什么？
::: sol
$\rho_t(\theta)=\pi_\theta(a_t\mid s_t)/\pi_{\theta_{\text{old}}}(a_t\mid s_t)$；$L^{\text{CLIP}}=\mathbb E_t[\min(\rho_t\hat A_t,\mathrm{clip}(\rho_t,1-\varepsilon,1+\varepsilon)\hat A_t)]$；完整目标 $L^{\text{PPO}}=\mathbb E[\text{裁剪项}]-c_1\mathbb E[(V_\phi-\hat R)^2]+c_2\mathbb E[\mathcal H(\pi_\theta)]$，即策略项 − 价值项 + 熵正则（$\varepsilon$ 常 0.1–0.2，$c_1\approx0.5$，$c_2$ 常 0–0.01）（[定义 5.5.2](sec55.md#def-5.5.2)、[方法 5.5.3](sec55.md#method-5.5.3)）。（✓ / △ / ×）
:::

**A11.** Bradley–Terry 偏好模型与 RLHF 三步各是什么？
::: sol
BT：$\Pr(y_w\succ y_l\mid x)=\sigma\bigl(r(x,y_w)-r(x,y_l)\bigr)$，由 Gumbel(0,1) 噪声 + 「感知值大者胜」推出。RLHF 三步：**SFT 得参考模型 $\pi_{\text{ref}}$ → 用 $\mathcal L_{\text{RM}}=-\mathbb E\log\sigma(r_\phi(x,y_w)-r_\phi(x,y_l))$ 训奖励模型 → 用 RL（多为 PPO）最大化 $\mathbb E_{y\sim\pi_\theta}[r_\phi(x,y)]-\beta\mathrm{KL}(\pi_\theta\Vert\pi_{\text{ref}})$**（[定义 5.6.2](sec56.md#def-5.6.2)、[方法 5.6.2](sec56.md#method-5.6.2)）。（✓ / △ / ×）
:::

**A12.** DPO 的损失与「隐式奖励」；它替掉了哪两个环节？
::: sol
$\mathcal L_{\text{DPO}}=-\mathbb E_{(x,y_w,y_l)}\bigl[\log\sigma\bigl(\beta\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}\bigr)\bigr]$；隐式奖励 $\hat r_\theta(x,y)=\beta\log\frac{\pi_\theta(y\mid x)}{\pi_{\text{ref}}(y\mid x)}$。它替掉**训练奖励模型**与**在线采样**两个环节，$\beta$ 控制「允许偏离参考模型多远」（[定理 5.6.2](sec56.md#thm-5.6.2)）。（✓ / △ / ×）
:::

## B. 结论卡

**B1.** 为什么说「有奖励」不等于「有标签」？给出两个决定「该不该用 RL」的判据。
::: sol
因为**粒度与因果位置**不同：标签与输入一一对应、逐样本可分解，直接给出正确答案；奖励是轨迹级标量，只评价结果、不指出哪一步负责，必须靠策略梯度或值函数搭桥。判据：① 能否为每个输入构造出正确的输出？能 ⇒ 监督/模仿学习；② 决策是否影响后续状态、能否大量重复尝试或已有离线日志？**三条同时成立才轮到 RL**（[5.1 的 `think`](sec51.md)、[方法 5.1.2](sec51.md#method-5.1.2)）。（✓ / △ / ×）
:::

**B2.** 常数 $\varepsilon$ 的代价为什么可以精确算出来？推论是什么？
::: sol
把「是否探索」当一个 Bernoulli 事件拆开：$\mathbb E[r]=(1-\varepsilon)\mu^\ast+\varepsilon\bar\mu$，故 $\Delta(\varepsilon)=\mu^\ast-\mathbb E[r]=\varepsilon(\mu^\ast-\bar\mu)$。推论：**常数 $\varepsilon$ 下永远拿不到满分**，上限是 $\mu^\ast-\varepsilon(\mu^\ast-\bar\mu)$；想突破就要让 $\varepsilon\to0$（衰减调度）或改用不确定性驱动的探索（UCB / Thompson）。注意探索税与「选择税」（贪心动作本身不是最优）是两笔账（[定理 5.1.1](sec51.md#thm-5.1.1)）。（✓ / △ / ×）
:::

**B3.** Q-learning 与 SARSA 在**同一条转移**上为什么不同？一句话说出判据。
::: sol
判据只有一条：**产生数据的行为策略与被评估/改进的目标策略是否同一个**。SARSA 用行为策略实际选出的 $a'$（on-policy，会把探索的代价学进去），Q-learning 用 $\max$（off-policy，学「假设之后都做最优选择」的价值）。同一条转移的算例：4 → **5.3**（Q-learning）vs **3.95**（SARSA）；行为策略恰好选中最优动作时两者相等（[例 5.3.1](sec53.md#ex-5.3.1)）。（✓ / △ / ×）
:::

**B4.** DQN 的两个技巧各治什么病？各有什么代价？
::: sol
**经验回放**治「样本相关 + 只能用一次」：打破时序相关、让梯度接近 i.i.d.、同一条经验可反复用；代价是内存（Atari 设置下约 28 GB 的 uint8 存储）与「数据陈旧」。**目标网络**治「目标在动」：让 TD 目标里的 $\theta^-$ 在若干步内冻结（或 Polyak 平均），把移动靶钉住；代价是多一份参数、多一个关键超参数（同步周期 $C$，常 $10^3$–$10^4$）。一句话：**回放治数据相关，目标网络治目标移动**（[方法 5.3.1](sec53.md#method-5.3.1)）。（✓ / △ / ×）
:::

**B5.** $\max$ 为什么会让 Q 值系统性虚高？为什么「乐观」比「不精确」更危险？
::: sol
对随机变量取凸函数（$\max$ 是凸的）不满足期望与函数可交换，故 $\mathbb E[\max_a\hat Q]\ge\max_a\mathbb E[\hat Q]=\bar Q$，噪声让等号一般不成立；i.i.d. 正态噪声下量级约 $\sigma\sqrt{2\ln N}$（$N=10,\sigma=1$ ⇒ 2.15）。危险之处在于它**改变了动作排序**：策略会偏好「噪声大、被偶然高估」的动作（少见动作、数据边缘），于是数据更偏向那里、噪声更大，形成恶性循环——与离线 RL 的外推失控是同一机制（[定理 5.3.2](sec53.md#thm-5.3.2)）。（✓ / △ / ×）
:::

**B6.** 策略梯度为什么**不需要知道环境模型**？哪一步是关键？
::: sol
关键在轨迹概率取对数那一步：$\log p_\theta(\tau)=\log\rho(s_0)+\sum_t\log\pi_\theta(a_t\mid s_t)+\sum_t\log P(s_{t+1}\mid s_t,a_t)$，其中 $\rho$ 与 $P$ **与 $\theta$ 无关**，求导后整项消失，只剩 $\nabla_\theta\log p_\theta(\tau)=\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)$。于是「对分布的导数」变成可采样估计的期望，而采样不需要模型（[定理 5.4.1](sec54.md#thm-5.4.1) 推导第二步）。（✓ / △ / ×）
:::

**B7.** 基线的无偏性来自哪条引理？它为什么在 GAE 与 DPO 里都出现？
::: sol
来自「**任何只依赖状态的量在策略梯度期望里可自由加减**」：$\sum_a\pi_\theta(a\mid s)\nabla_\theta\log\pi_\theta(a\mid s)b(s)=b(s)\nabla_\theta\sum_a\pi_\theta(a\mid s)=b(s)\nabla_\theta1=0$（只用到概率归一化）。这条引理也是因果性证明里 $H_t$ 那一步的同一件事；它在 5.5 里变成优势 $A=Q-V$（减去只依赖状态的 $V$），在 5.6 里变成 DPO 里的参考模型对数比率（把「奖励的绝对水平」换成「相对参考的改善」）（[定理 5.4.3](sec54.md#thm-5.4.3)）。（✓ / △ / ×）
:::

**B8.** PPO 的裁剪目标为什么能替代 TRPO 的 KL 约束？它比 TRPO 省下了什么？
::: sol
两者都只想达到一个目的：**限制一次更新把策略推多远**。TRPO 用硬约束 $\mathbb E_s[\mathrm{KL}(\pi_{\text{old}}\Vert\pi_\theta)]\le\delta$（需要二阶近似、Fisher 矩阵、共轭梯度、线搜索）；PPO 用 $\min(\rho\hat A,\mathrm{clip}(\rho,1-\varepsilon,1+\varepsilon)\hat A)$，在「继续外推」的两格把梯度归零、在另两格保留「拉回区间」的梯度，并保证 $L^{\text{CLIP}}\le L^{\text{CPI}}$（保守下界）。省下的是二阶信息与约束优化：**只需一阶梯度、实现简单、对超参数更鲁棒**（[方法 5.5.2](sec55.md#method-5.5.2)、[定义 5.5.2](sec55.md#def-5.5.2) 后的推导）。（✓ / △ / ×）
:::

**B9.** 离线 RL 的困难为什么不是「数据少」？所有离线算法的思路可以归成哪一句话？
::: sol
因为**数据外区域的估值误差无法被纠正**，而 $\max$ 会主动挑选被高估的数据外动作：单步自举误差 $\varepsilon$ 经 $k$ 轮迭代会被放大到 $\varepsilon/(1-\gamma)$（$\gamma=0.99$ ⇒ **100 倍**），而离线场景里没有新数据把它洗掉。所以整条技术路线的目标只有一个：**在源头上不产生 $\varepsilon$**——要么不查询数据外动作（IQL 用 expectile 上分位价值），要么主动把它们压低（CQL 的保守惩罚项）（[定理 5.6.1](sec56.md#thm-5.6.1)、[方法 5.6.1](sec56.md#method-5.6.1)）。（✓ / △ / ×）
:::

**B10.** reward hacking 为什么是**必然**的？两个可操作的控制手段是什么？
::: sol
因为你优化的是代理 $\hat J$ 而不是真实目标 $J$：只要 $\hat J$ 只在训练分布内与 $J$ 一致，梯度就会把策略推向「$\hat J$ 高而 $J$ 未必高」的区域，且**优化强度越大偏差越大**（真实偏好随优化强度呈「先升后降」，存在无法事先确定的最优停手点）。控制手段：① **独立验收**——保留人评/独立基准（不与训练奖励同源）并按周期评估；② **KL 约束 / 早停**——限制偏离参考模型的程度，用 KL 曲线找拐点；配合奖励集成、数据迭代、行为审计（[5.6.8](sec56.md)、[方法 5.6.4](sec56.md#method-5.6.4)）。（✓ / △ / ×）
:::

## C. 公式卡

**C1.** 写出最优贝尔曼算子与它的压缩性；值迭代轮数怎么估？
::: sol
$(\mathcal TV)(s)=\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V(s')\bigr]$，$\lVert\mathcal TV-\mathcal TU\rVert_\infty\le\gamma\lVert V-U\rVert_\infty$（用 $\lvert\max_af-\max_ag\rvert\le\max_a\lvert f-g\rvert$ + 加权平均 ≤ 上确界）。误差界 $\lVert V_k-V^\ast\rVert_\infty\le\gamma^k\lVert V_0-V^\ast\rVert_\infty$，故 $k=O\bigl(\frac{\log(1/\varepsilon)}{\log(1/\gamma)}\bigr)$（$\gamma=0.9,\varepsilon=10^{-6}$ ⇒ 约 174 轮）（[定理 5.2.2](sec52.md#thm-5.2.2)）。（✓ / △ / ×）
:::

**C2.** 写出 $\boldsymbol v^\pi$ 的矩阵解，并说出它的代价。
::: sol
记 $r^\pi(s)=\sum_a\pi(a\mid s)r(s,a)$、$P^\pi(s'\mid s)=\sum_a\pi(a\mid s)P(s'\mid s,a)$，则 $\boldsymbol v^\pi=(I-\gamma P^\pi)^{-1}\boldsymbol r^\pi$（$\gamma\lt1$ 时 $I-\gamma P^\pi$ 可逆，且逆 = $\sum_k\gamma^k(P^\pi)^k$）。代价：$O(\lvert\mathcal S\rvert^3)$ 求逆，$\lvert\mathcal S\rvert=10^6$ 时不可行——所以工程上几乎从不真解方程，而是迭代或用采样替代求和（[定理 5.2.1](sec52.md#thm-5.2.1)）。（✓ / △ / ×）
:::

**C3.** 写出 $\varepsilon$-greedy 的期望奖励与探索税。
::: sol
$\mathbb E[r]=(1-\varepsilon)\mu^\ast+\varepsilon\bar\mu$，$\Delta(\varepsilon)=\mu^\ast-\mathbb E[r]=\varepsilon(\mu^\ast-\bar\mu)=\varepsilon\cdot\frac{K-1}{K}(\mu^\ast-\bar\mu_-)$。算例：$\mu=(0.8,0.5,0.2)$、$\varepsilon=0.2$ ⇒ $\bar\mu=0.5$、$\mathbb E[r]=0.74$、税 $=0.06$（[定理 5.1.1](sec51.md#thm-5.1.1)）。（✓ / △ / ×）
:::

**C4.** 写出 TD 目标的偏差与方差结论（定理 5.3.1）。
::: sol
(i) 若 $V=V^\pi$，则一步 TD 目标无偏：$\mathbb E[r_{t+1}+\gamma V^\pi(s_{t+1})\mid s_t=s]=V^\pi(s)$（代入贝尔曼期望方程）；(ii) 若 $V\ne V^\pi$，自举偏差满足 $\bigl|\mathbb E[\hat y]-V^\pi(s)\bigr|\le\gamma\lVert V-V^\pi\rVert_\infty$；(iii) 与蒙特卡洛目标 $G_t$ 构成偏差—方差的两端——**小 $\gamma$ 的 TD 收敛快、大 $\gamma$ 更依赖值的准确性**（[定理 5.3.1](sec53.md#thm-5.3.1)）。（✓ / △ / ×）
:::

**C5.** 写出过高估计的量级公式，并算 $N=10,\sigma=1$ 与 $N=16,\sigma=0.25$。
::: sol
$\mathbb E[\max_a\varepsilon_a]\approx\sigma\sqrt{2\ln N}$（$N$ 个 i.i.d. $\mathcal N(0,\sigma^2)$ 极值的 Gumbel 近似）。$N=10,\sigma=1$：$\sqrt{2\ln10}\approx2.15$；$N=100$：$\approx3.03$；$N=16,\sigma=0.25$：$0.25\times\sqrt{2\ln16}\approx0.69$。方向：噪声 $\sigma$ 越大、动作数 $N$ 越多，虚高越严重（[定理 5.3.2](sec53.md#thm-5.3.2)、[例 5.3.2](sec53.md#ex-5.3.2)）。（✓ / △ / ×）
:::

**C6.** 写出 REINFORCE 的更新式与它的两个无偏性事实（因果性、基线）。
::: sol
$\nabla_\theta J\approx\sum_{t=0}^{T-1}\nabla_\theta\log\pi_\theta(a_t\mid s_t)G_t$，$\theta\leftarrow\theta+\eta\nabla_\theta J$。两个无偏性：① **因果性** $\mathbb E[\nabla_\theta\log\pi_\theta(a_t\mid s_t)(G(\tau)-G_t)]=0$（用 $G_t$ 不引入偏差，还降方差）；② **基线** $\mathbb E[\nabla_\theta\log\pi_\theta(a_t\mid s_t)b(s_t)]=0$（任意只依赖状态的 $b$，减它不改变期望）。用 $A=Q-V$ 时就是「好动作抬、坏动作压」（[方法 5.4.1](sec54.md#method-5.4.1)、[定理 5.4.2](sec54.md#thm-5.4.2)、[定理 5.4.3](sec54.md#thm-5.4.3)）。（✓ / △ / ×）
:::

**C7.** 写出 GAE 的递归实现式与「有效记忆」的估算。
::: sol
$\hat A_t=\delta_t+\gamma\lambda\hat A_{t+1}$，$\hat A_T=0$；实现上一次 `for t in reversed(range(T))` 即可。$\gamma\lambda=0.99\times0.95=0.9405$，有效记忆约 $1/(1-\gamma\lambda)\approx17$ 步。$\lambda\to0$ 更信 Critic（低方差高偏差），$\lambda\to1$ 更信实际回报（高方差低偏差）（[定理 5.5.1](sec55.md#thm-5.5.1)、[例 5.5.1](sec55.md#ex-5.5.1)）。（✓ / △ / ×）
:::

**C8.** 写出 PPO 裁剪目标的四格结论（$\varepsilon=0.2$）。
::: sol
区间 $[0.8,1.2]$ 内：$f=\rho A$，梯度 $=\hat A$。**梯度归零的两格**：$A\gt0$ 且 $\rho\gt1.2$（已抬过头）、$A\lt0$ 且 $\rho\lt0.8$（已压过头）。**仍活跃、方向为「拉回」的两格**：$A\gt0$ 且 $\rho\lt0.8$（继续抬高 $\rho$）、$A\lt0$ 且 $\rho\gt1.2$（继续压低 $\rho$）。另有 $L^{\text{CLIP}}\le L^{\text{CPI}}$ 逐点成立。数值例：$(A{=}2,\rho{=}1.5)\Rightarrow\min(3.0,2.4)=2.4$ 截断；$(A{=}{-}2,\rho{=}0.5)\Rightarrow\min(-1.0,-1.6)=-1.6$ 截断（[定义 5.5.2](sec55.md#def-5.5.2)、[例 5.5.2](sec55.md#ex-5.5.2)）。（✓ / △ / ×）
:::

**C9.** 写出 DPO 的三步推导骨架（闭式解 → 反解奖励 → 代入 BT）。
::: sol
① 对 $\max_\pi\mathbb E_{\pi}[r]-\beta\mathrm{KL}(\pi\Vert\pi_{\text{ref}})$ 用拉格朗日法（约束 $\sum_y\pi_y=1$）得 $\pi^\star\propto\pi_{\text{ref}}e^{r/\beta}$，即 $\pi^\star=\frac{1}{Z(x)}\pi_{\text{ref}}\exp(r/\beta)$；② 反解 $r(x,y)=\beta\log\frac{\pi^\star}{\pi_{\text{ref}}}+\beta\log Z(x)$；③ 代入 $\Pr(y_w\succ y_l)=\sigma(r_w-r_l)$——**两个 $\beta\log Z(x)$ 因只依赖 $x$ 而精确抵消**，得 DPO 损失。若偏好对来自不同 prompt，$Z$ 项无法抵消（[定理 5.6.2](sec56.md#thm-5.6.2)、[附录 C.13](../../appendix/derivations.md)）。（✓ / △ / ×）
:::

**C10.** 写出 GRPO 的组内优势与 DPO 的梯度（例 5.6.1 的数值）。
::: sol
GRPO：$\hat A_i=(r_i-\bar r)/\mathrm{std}(r)$；$r=(1,0,1,0)$ ⇒ $\bar r=0.5$、$\mathrm{std}=0.5$、$\hat A=(1,-1,1,-1)$（全对或全错时 $\mathrm{std}=0$，该组无信号）。DPO：$\Delta_w=-1,\Delta_l=-2,\beta=0.1\Rightarrow z=0.1$，$\mathcal L=-\log\sigma(0.1)\approx0.644$，$\partial\mathcal L/\partial\Delta_w=-\beta\sigma(-z)=-0.0475$、$\partial\mathcal L/\partial\Delta_l=+0.0475$（[定理 5.6.3](sec56.md#thm-5.6.3)、[例 5.6.1](sec56.md#ex-5.6.1)）。（✓ / △ / ×）
:::

## D. 陷阱卡（每题给一个错误说法，请指出错在哪）

**D1.** 「奖励是目标的数值化，所以只要把业务目标写成一个数字，RL 就会去优化它。」
::: sol
错在把**代理**当**目标**。奖励是你写进环境的东西，策略优化的必然是你写的那个函数；二者不一致时策略会精确地利用缺口（[5.6.8](sec56.md) 的赛艇绕圈刷分就是最著名的图解）。正确做法：结果型奖励 + 独立验收指标 + 行为审计（[方法 5.6.4](sec56.md#method-5.6.4)）。（✓ / △ / ×）
:::

**D2.** 「Q-learning 是 off-policy，所以我可以随便用旧数据、也不用担心样本来源。」
::: sol
前半对、后半错。off-policy 的合法性来自「目标用 $\max$、不依赖行为策略」，所以**复用旧数据是允许的**；但**收敛仍需要每个 $(s,a)$ 被充分访问**（否则 $\max$ 会把从未被采样、只是被估计得很高的动作当成最优），而且数据陈旧会带来分布偏差——这正是离线 RL 要专门处理的问题（[5.3.3 的 `think`](sec53.md)、[5.6.1](sec56.md)）。（✓ / △ / ×）
:::

**D3.** 「Q 值一路变大说明学得好，曲线越漂亮模型越强。」
::: sol
错。Q 值膨胀既可能来自学习，也可能来自**过高估计**（$\max$ 的凸性副作用，量级 $\sigma\sqrt{2\ln N}$）。判断依据是**回报曲线与独立评估**，不是 Q 值曲线；尤其不要把「训练奖励」当验收指标（[5.3 的 errata](sec53.md) 第 5 条、[方法 5.7.4](sec57.md#method-5.7.4)）。（✓ / △ / ×）
:::

**D4.** 「PPO 是 on-policy，所以一批数据只能用一次；要多次用就失去理论保证，结果必然变差。」
::: sol
不准确。PPO 用 $\rho=\pi_\theta/\pi_{\theta_{\text{old}}}$ 做了**重要性修正**，因此可以在同一批数据上跑几个 epoch（论文常用 3–10）——这是「近似 on-policy」。但**能跑几轮有上限**，`approx_kl` 与 `clip_frac` 就是这个上限的仪表盘：KL 持续 $>0.03$ 或裁剪比例长期 $>50\%$ 说明数据已严重 off-policy，必须重新采样（[方法 5.5.4](sec55.md#method-5.5.4)、[5.5 的 errata](sec55.md)）。（✓ / △ / ×）
:::

**D5.** 「PPO 的裁剪会把越过区间的样本梯度全部清零，所以训练天然安全。」
::: sol
错两处：① 四个越界象限里**只有两个**梯度归零（$A\gt0,\rho\gt1+\varepsilon$ 与 $A\lt0,\rho\lt1-\varepsilon$），另两个仍活跃且方向是「拉回区间」；② 被裁剪的是**目标函数**而非策略概率，且「$\partial f/\partial\rho=0$」不等于「该样本对参数无贡献」（$\rho$ 本身仍依赖 $\theta$）。还要用 `clip_fraction` 监控实际越界比例（[定义 5.5.2](sec55.md#def-5.5.2) 后的推导）。（✓ / △ / ×）
:::

**D6.** 「基线是启发式，用了就会把偏差引进策略梯度；所以要么不用，要么必须用精确的 $V^\pi$。」
::: sol
错。对**任意只依赖状态**的 $b(s)$，期望贡献**精确为 0**（只用概率归一化），与 $b$ 的形式无关；差别只在方差。「必须精确」也不成立——工程上用一个学出来的 $V_\phi$ 就够（它同时当基线、当 GAE 的自举来源、当「是否值得做」的参照）。**唯一的硬约束**：$b$ 不能依赖当前动作 $a_t$，否则证明失效、真的引入偏差（[定理 5.4.3](sec54.md#thm-5.4.3)、[5.4.5 的 errata](sec54.md)）。（✓ / △ / ×）
:::

**D7.** 「奖励整体乘以 10 倍，信号更强，RL 会学得更快。」
::: sol
错。奖励乘以常数会让梯度**与噪声同时**放大同倍数，**信噪比不变**——等价于把有效学习率乘了同倍数，通常只会让训练发散。正确做法是让奖励尺度与学习率、优势归一化一起定；优势归一化（batch 级标准化）就是为「让不同任务的学习率可比」准备的（[5.4.7 即时自测 Q4](sec54.md)、[方法 5.7.1](sec57.md#method-5.7.1)）。（✓ / △ / ×）
:::

**D8.** 「DPO 是 RLHF 的近似版，省了奖励模型但效果必然差一点；而且它的损失只关心相对差距，所以一定会保持回答的绝对质量。」
::: sol
两处错。① 在「KL 正则目标 + Bradley–Terry」假设下两者**等价**（不是近似），唯一近似是「假设最优解在参数化策略族内」；差别在失败模式——RLHF 容易被奖励模型漏洞带偏，DPO 对标注噪声没有缓冲。② DPO 只约束**相对差距**：$\Delta_w$ 与 $\Delta_l$ **同时**下降时损失反而更小，因此**不保证绝对似然不下降**（语言退化风险），评估不能只看 `pref_acc`（[定理 5.6.2](sec56.md#thm-5.6.2)、[例 5.6.1](sec56.md#ex-5.6.1)、[5.6 的 errata](sec56.md)）。（✓ / △ / ×）
:::

**D9.** 「离线 RL 效果不好的原因是数据量不够；把日志规模扩大十倍就能追平在线算法。」
::: sol
错。离线 RL 的失败不是数据量问题，而是**分布外动作的估值外推**：单步误差被 $1/(1-\gamma)$ 放大（$\gamma=0.99$ ⇒ 100 倍），而 $\max$ 会专门挑被高估的数据外动作，扩大数据集也改变不了「真实决策所需的 $(s,a)$ 总有一部分在支撑集之外」。第一问应是「数据里有没有好决策的足够证据」（[定理 5.6.1](sec56.md#thm-5.6.1)、[5.6.2 的 think](sec56.md)）。（✓ / △ / ×）
:::

**D10.** 「我的 PPO 平均回报比别人高 5 分，所以我的改动更好；跑一个种子就够，因为曲线很平滑。」
::: sol
错。RL 对随机种子极度敏感，单条曲线在统计上几乎不提供信息；5 分的差值往往被区间宽度完全淹没（例 5.7.1：$s\approx23$、5 种子时 95% 区间约 $\pm28$，要分辨 5 分需约 142 个种子）。协议要求：独立评估种子 + 确定性策略 + 多回合 + **多种子均值与置信区间**，并用「各种子淡线 + 中位数粗线」作图（[方法 5.7.5](sec57.md#method-5.7.5)、[例 5.7.1](sec57.md#ex-5.7.1)）。（✓ / △ / ×）
:::

## 导出到 Anki / CSV

1. 打开 Anki → **新建卡组**「DL-第 5 讲」；建议再建四个子卡组（定义 / 结论 / 公式 / 陷阱），便于按类复习。
2. **逐条录入**：每条卡片就是一行「问题 → 答案」（把 `::: sol` 里的内容去掉标记后当答案）。也可在纯文本编辑器里用 `Tab` 分隔成两列（字段 1 = 问题，字段 2 = 答案），保存为 UTF-8 的 `.txt` 后用「文件 → 导入」。
3. 卡片的**标注**建议写成 `K5.1`、`S5.2` 这类目标编号（见[自检表](checklist.md)），导入时映射到 Anki 的 `Tags` 字段——这样按 `tag:K5.*` 过滤就能只刷某一条目标。
4. **复习节点**：当天 / 隔天 / 第 3 天 / 第 7 天（与[自检表](checklist.md)的判定配合使用）。
5. **每轮只重做标 △ 与 × 的卡**；✓ 的卡可以隔两轮再抽查一次，防止「背过就忘」。
6. 陷阱卡（D 组）建议用 Anki 的 **Cloze（填空）** 类型：把错误说法里的关键词挖空，强迫自己写出「错在哪」而不是只选对错。
