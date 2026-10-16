# 5.2 马尔可夫决策过程与值函数

上一节把 RL 的问题说清了：与环境交互、只拿标量奖励、最大化长期回报。但「长期回报」这个词还是模糊的——多长算长期？一个动作到底该为多少步之后的结果负责？要给这些问题一个可推导的答案，就必须先把**环境**写成一个数学对象。

这一节做三件事。第一，给出**马尔可夫决策过程**（Markov Decision Process, MDP）：它用五个元素把「状态如何转移、动作得到什么奖励、未来值多少钱」全部写清，并用**马尔可夫性**保证「当前状态 + 当前动作」是预测未来的**充分统计量**——这一步是从「没有标签」走向「可以推导」的关键。第二，在这个框架下定义**策略**、**折扣回报**、**状态值函数** $V^\pi$ 与**动作值函数** $Q^\pi$，并证明它们满足一个自洽的递归关系：**贝尔曼方程**。第三，推出**贝尔曼最优方程**——把期望换成最大化——并说明它为什么有唯一解、以及怎样用**策略迭代**与**值迭代**把它解出来。

这三件事的顺序不能乱：贝尔曼方程是「值函数自洽」的陈述，最优方程是「策略最优」的陈述，而求解算法只是在这两个等式上做不动点迭代。本讲后面所有算法——Q-learning、DQN、Actor–Critic、PPO、DPO——都是在**不完整知道**或**根本不知道** $P$ 与 $R$ 的情况下，用采样替代这两个等式里的求和。

## 5.2.1 马尔可夫决策过程：把环境写成五元组

::: def 定义 5.2.1 · 马尔可夫决策过程 {#def-5.2.1}
一个 **MDP** 由五元组 $(\mathcal S,\mathcal A,P,R,\gamma)$ 给出：

- $\mathcal S$：**状态空间**（可以是离散集合，也可以是连续空间，如机器人关节角）；$\mathcal A$：**动作空间**。
- $P(s'\mid s,a)=\Pr\{s_{t+1}=s'\mid s_t=s,\ a_t=a\}$：**转移概率**（环境动力学）。
- $R$：**奖励函数**，常用 $r(s,a)=\mathbb E[r_{t+1}\mid s_t=s,a_t=a]$（也可写成 $r(s,a,s')$，即奖励依赖转移结果）。
- $\gamma\in[0,1)$：**折扣因子**，把未来的奖励按几何级数打折。

**马尔可夫性**：未来只依赖当前的状态与动作，与更早的历史无关，
$$P(s_{t+1}\mid s_t,a_t,\dots,s_0)=P(s_{t+1}\mid s_t,a_t).$$
因此 $(s_t,a_t)$ 是关于未来的一切**充分统计量**——记住当前状态就够了，不必回放整段历史。

一个固定的**策略** $\pi(a\mid s)$ 与一个 MDP 一起**完全确定**了一条轨迹的分布；求解一个 MDP 就是找到一个策略，使期望折扣回报最大。
:::

::: intuition 马尔可夫性就是「状态里没有欠账」
马尔可夫性听起来抽象，实际含义是一句工程话：**当前状态已经把过去的全部影响总结完了**。如果做不到，就说明状态「记性不够」——过去的某个信息还会影响未来，而你没有把它写进 $s_t$。三个常见补救措施：① **帧堆叠**（Atari 里把连续 4 帧拼成一个状态，让「速度」这类信息可被推断）；② **把历史压进状态**（用 RNN / Transformer 的隐状态当 $s_t$）；③ 显式建模**部分可观测**（POMDP，用「信念」 $b(s)$ 当状态）。工程上最常见的 bug 是：以为状态够用，实际上「上一帧的动作」也被环境用到了（例如格斗游戏的方向键惯性）。

第二个要点是：**奖励是设计变量，不是自然常数**。$r(s,a)$ 是人写进去的，它决定策略最终学会什么。把它当成「客观的任务描述」，是后面所有对齐灾难的起点（[5.6](sec56.md)）。
:::

| 记号 | 含义 | 典型规模（工程直觉） |
|:--|:--|:--|
| $\mathcal S$ | 状态空间 | 表格：$10^2$–$10^6$；图像/语言：连续高维，只能函数逼近 |
| $\mathcal A$ | 动作空间 | 离散：$2$–$10^2$；连续控制：$\mathbb R^{d_a}$ |
| $P(s'\mid s,a)$ | 转移概率 | 表格形式需 $\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert$ 个数；真实环境里**通常未知** |
| $r(s,a)$ | 期望即时奖励 | $\lvert\mathcal S\rvert\lvert\mathcal A\rvert$；**由人设计** |
| $\gamma$ | 折扣因子 | 标量超参数，常取 $0.9$–$0.999$ |
| $\pi(a\mid s)$ | 策略 | 表格：$\lvert\mathcal S\rvert\lvert\mathcal A\rvert$；参数化：$\theta$ |
| $V^\pi(s)$ | 状态值 | $\lvert\mathcal S\rvert$ 个数 |
| $Q^\pi(s,a)$ | 动作值 | $\lvert\mathcal S\rvert\lvert\mathcal A\rvert$ 个数（**比 $V$ 大一个动作维**） |

::: think 什么时候「没有 $P$ 与 $R$ 的表格」反而更好
表格方法的上限由 $\lvert\mathcal S\rvert$ 决定：围棋的状态数是天文数字，任何表格都放不下。但反过来，函数逼近虽然能处理连续状态，却带来了**泛化误差**这个新问题——它会把「相似状态」的经验混在一起，于是出现「邻域干扰」（一个状态的更新破坏了另一个状态的值）。第 1 讲讲的偏差—方差权衡在这里以新面目出现：**表格 = 零泛化、零干扰；函数逼近 = 有泛化、有干扰**。5.3 节开始就在这两种表示之间做取舍。
:::

## 5.2.2 策略、轨迹与折扣回报

::: def 定义 5.2.2 · 策略 {#def-5.2.2}
**策略** $\pi$ 是从状态到动作分布的映射：

- **随机策略**（stochastic）：$\pi(a\mid s)=\Pr\{a_t=a\mid s_t=s\}$，满足 $\sum_a\pi(a\mid s)=1$；
- **确定性策略**（deterministic）：$a=\mu(s)$，是随机策略的退化情形（某个动作概率为 1）。

由 $\pi$、$P$、初始状态分布 $\rho(s_0)$ 共同确定轨迹 $\tau=(s_0,a_0,r_1,s_1,\dots)$ 的分布：
$$p_\pi(\tau)=\rho(s_0)\prod_{t\ge0}\pi(a_t\mid s_t)\,P(s_{t+1}\mid s_t,a_t).$$
:::

::: intuition 为什么要允许「策略是随机的」
三个理由，从弱到强：① **探索**需要随机性（[5.1](sec51.md)）；② 有些任务的最优策略**本身就是随机的**——石头剪刀布里任何确定性策略都会被针对，只有均匀随机才是均衡；③ 在部分可观测或存在对抗的环境里，随机策略是对「对手/不确定性」的稳健回应。工程上还有一个隐藏理由：随机策略天然带熵，训练过程更平滑、更不容易坍缩到局部最优。
:::

::: def 定义 5.2.3 · 折扣回报 {#def-5.2.3}
从时刻 $t$ 出发的**折扣回报**（discounted return）是
$$G_t=\sum_{k=0}^{\infty}\gamma^{k}r_{t+k+1}=r_{t+1}+\gamma r_{t+2}+\gamma^2 r_{t+3}+\cdots$$
其中 $\gamma\in[0,1)$。若任务是**回合制**（episodic，有终止状态），$G_t=\sum_{k=0}^{T-1-t}\gamma^{k}r_{t+k+1}$；无限时域下必须有 $\gamma\lt1$ 才能保证收敛。

**RL 的优化目标**：找一个策略 $\pi$ 最大化
$$J(\pi)=\mathbb E_{s_0\sim\rho}\bigl[V^\pi(s_0)\bigr]=\mathbb E_{\tau\sim p_\pi}[G_0].$$
:::

::: intuition 为什么必须打折：三个理由
1. **数学必要性**：无限时域下若 $\gamma=1$ 且奖励有正的下界，$G_0$ 发散（$1+1+1+\cdots$），值函数失去定义。只要 $\gamma\lt1$，几何级数收敛，且**等效视野约为 $\frac{1}{1-\gamma}$ 步**。
2. **表达偏好**：眼前的奖励比遥远的奖励更值钱——这既符合人类决策，也把「不确定性随时间的增长」折算进去（未来越远，越不可控）。
3. **降方差**：折扣让远期的随机量权重指数衰减，$G_t$ 的方差显著变小；这也是「折扣是稳定训练的超参数」这一经验说法的来源。

反过来说，**$\gamma$ 是被选择的**：它决定智能体「看多远」，也决定它愿意为目标推迟多久的满足。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 860 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-discount-title fig-discount-desc">
<title id="fig-discount-title">折扣因子 γ 对未来奖励权重的影响</title>
<desc id="fig-discount-desc">三组柱形分别为 γ=0.5、0.9、0.99 时未来第 k 步奖励的折扣权重 γᵏ。γ 越接近 1，智能体的「视界」越长。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="126.9" y1="46" x2="126.9" y2="236"/><line x1="255.7" y1="46" x2="255.7" y2="236"/><line x1="384.5" y1="46" x2="384.5" y2="236"/><line x1="513.3" y1="46" x2="513.3" y2="236"/><line x1="642.1" y1="46" x2="642.1" y2="236"/><line x1="770.8" y1="46" x2="770.8" y2="236"/><line x1="96" y1="236.0" x2="776" y2="236.0"/><line x1="96" y1="194.7" x2="776" y2="194.7"/><line x1="96" y1="153.4" x2="776" y2="153.4"/><line x1="96" y1="112.1" x2="776" y2="112.1"/><line x1="96" y1="70.8" x2="776" y2="70.8"/></g>
<g><line x1="126.9" y1="236" x2="126.9" y2="240" stroke="var(--ink-2)"/><text class="fg-muted" x="126.9" y="251" text-anchor="middle">0</text><line x1="384.5" y1="236" x2="384.5" y2="240" stroke="var(--ink-2)"/><text class="fg-muted" x="384.5" y="251" text-anchor="middle">5</text><line x1="642.1" y1="236" x2="642.1" y2="240" stroke="var(--ink-2)"/><text class="fg-muted" x="642.1" y="251" text-anchor="middle">1</text><line x1="92" y1="236.0" x2="96" y2="236.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="240.0" text-anchor="end">0</text><line x1="92" y1="194.7" x2="96" y2="194.7" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="198.7" text-anchor="end"></text><line x1="92" y1="153.4" x2="96" y2="153.4" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="157.4" text-anchor="end"></text><line x1="92" y1="112.1" x2="96" y2="112.1" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="116.1" text-anchor="end">1</text><line x1="92" y1="70.8" x2="96" y2="70.8" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="74.8" text-anchor="end">1</text><rect x="96" y="46" width="680" height="190" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="436.0" y="269" text-anchor="middle">未来的第 k 步</text><text class="fg-label" x="56.0" y="141.0" text-anchor="middle" transform="rotate(-90 56.0 141.0)">折扣权重 γᵏ</text></g>
<rect x="106.8" y="70.8" width="12.4" height="165.2" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="158.3" y="153.4" width="12.4" height="82.6" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="209.8" y="194.7" width="12.4" height="41.3" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="261.4" y="215.3" width="12.4" height="20.7" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="312.9" y="225.7" width="12.4" height="10.3" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="364.4" y="230.8" width="12.4" height="5.2" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="415.9" y="233.4" width="12.4" height="2.6" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="467.4" y="234.7" width="12.4" height="1.3" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="518.9" y="235.4" width="12.4" height="0.6" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="570.5" y="235.7" width="12.4" height="0.3" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="622.0" y="235.8" width="12.4" height="0.2" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="673.5" y="235.9" width="12.4" height="0.1" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="725.0" y="236.0" width="12.4" height="0.0" fill="var(--fig-gold)" fill-opacity="0.34" stroke="var(--fig-gold)"/>
<rect x="120.7" y="70.8" width="12.4" height="165.2" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="172.2" y="87.3" width="12.4" height="148.7" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="223.8" y="102.2" width="12.4" height="133.8" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="275.3" y="115.6" width="12.4" height="120.4" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="326.8" y="127.6" width="12.4" height="108.4" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="378.3" y="138.4" width="12.4" height="97.6" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="429.8" y="148.2" width="12.4" height="87.8" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="481.3" y="157.0" width="12.4" height="79.0" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="532.8" y="164.9" width="12.4" height="71.1" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="584.4" y="172.0" width="12.4" height="64.0" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="635.9" y="178.4" width="12.4" height="57.6" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="687.4" y="184.2" width="12.4" height="51.8" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="738.9" y="189.3" width="12.4" height="46.7" fill="var(--fig-blue)" fill-opacity="0.34" stroke="var(--fig-blue)"/>
<rect x="134.6" y="70.8" width="12.4" height="165.2" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="186.2" y="72.4" width="12.4" height="163.6" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="237.7" y="74.1" width="12.4" height="161.9" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="289.2" y="75.7" width="12.4" height="160.3" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="340.7" y="77.3" width="12.4" height="158.7" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="392.2" y="78.9" width="12.4" height="157.1" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="443.7" y="80.5" width="12.4" height="155.5" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="495.2" y="82.0" width="12.4" height="154.0" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="546.8" y="83.5" width="12.4" height="152.5" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="598.3" y="85.1" width="12.4" height="150.9" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="649.8" y="86.6" width="12.4" height="149.4" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="701.3" y="88.1" width="12.4" height="147.9" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<rect x="752.8" y="89.6" width="12.4" height="146.4" fill="var(--fig-green)" fill-opacity="0.34" stroke="var(--fig-green)"/>
<g><line x1="116" y1="272" x2="142" y2="272" stroke="var(--fig-gold)" stroke-width="2.2"/><text class="diagram-note" x="148" y="276">γ=0.5：几乎只看眼前（半衰期 1 步）</text><line x1="116" y1="291" x2="142" y2="291" stroke="var(--fig-blue)" stroke-width="2.2"/><text class="diagram-note" x="148" y="295">γ=0.9：约 7 步半衰期（常用起点）</text><line x1="116" y1="310" x2="142" y2="310" stroke="var(--fig-green)" stroke-width="2.2"/><text class="diagram-note" x="148" y="314">γ=0.99：长视界，接近累计总奖励</text></g>
</svg>
<figcaption>Gₜ = Σ γᵏ·rₜ₊ₖ 里的 γ 决定「看得多远」（本教程计算绘制）。γ 小 → 贪心短视；γ→1 → 关心长期回报，但信用分配更难、训练更不稳定。γ = 0.9 是常用起点。</figcaption>
</figure>

::: ex 例 5.2.1 · 折扣回报怎么算，以及 $\gamma$ 到底改变了什么 {#ex-5.2.1}
某轨迹长度为 3，奖励 $r_1=r_2=r_3=1$。求 $\gamma=0.9$ 与 $\gamma=0.99$ 时的 $G_0$；再看一个「有限时域」版本：一局最多 10 步，每步奖励 1（$\gamma=0.9$）。最后说明为什么要打折。
::: proof 解
**直接求和**：$G_0=\gamma^{0}r_1+\gamma^{1}r_2+\gamma^{2}r_3$。

- $\gamma=0.9$：$G_0=1+0.9+0.81=2.71$；
- $\gamma=0.99$：$G_0=1+0.99+0.9801=2.9701$。**递归验证**：$\gamma=0.9$ 时 $G_1=1+0.9=1.9$，于是 $G_0=r_1+\gamma G_1=1+0.9\times1.9=2.71$，与上式一致——这正是 5.2.4 贝尔曼方程「当前奖励 + 折扣的未来」的来源。

**无限时域的量级**：若奖励恒为 1 且无穷延续，$G_0=\sum_{k\ge0}\gamma^k=\frac{1}{1-\gamma}$：$\gamma=0.9$ 给 10，$\gamma=0.99$ 给 100，$\gamma=0.5$ 给 2。**「等效视野」就是它**：$\gamma=0.9$ 相当于「把未来约 10 步当成一回事」，$\gamma=0.99$ 相当于 100 步。

**为什么要折扣**：若 $\gamma=1$ 且奖励持续为 1、时域无穷，$G_0$ 发散，值函数失去定义；只要 $\gamma\lt1$ 就收敛。折扣同时表达偏好（眼前比远期值钱）并降低估计方差。代价是：**$\gamma$ 越大，信用分配要跨的步数越多、方差越大、训练越不稳**——所以它是超参数而不是常数。
:::
:::

## 5.2.3 状态值函数与动作值函数

给定策略 $\pi$，我们关心两件事：站在某个状态好不好（**状态值函数**），以及站在那里做某个动作好不好（**动作值函数**）。

::: def 定义 5.2.4 · 值函数与动作值函数 {#def-5.2.4}
$$\underbrace{V^\pi(s)=\mathbb E_\pi[G_t\mid s_t=s]}_{\text{状态值（state value）}},\qquad
\underbrace{Q^\pi(s,a)=\mathbb E_\pi[G_t\mid s_t=s,\ a_t=a]}_{\text{动作值（action value）}} .$$
两者的期望都是对**策略 $\pi$ 与环境 $P$ 的后续随机性**取的。特别地，$Q^\pi$ 比 $V^\pi$ 多承载了「某动作一旦选定」这一信息，因此**更适合直接用于选择动作**：$\pi'(s)=\arg\max_a Q^\pi(s,a)$。
:::

::: intuition 两个函数各自回答什么问题
$V^\pi(s)$ 回答「按现在的策略走下去，从这个状态出发平均能拿多少分」——它是**评估**用的。$Q^\pi(s,a)$ 回答「先做这个动作、之后再按策略走，平均能拿多少分」——它是**选择**用的。差别是「动作是否已被决定」。

这个差别在工程上非常关键：判断「换一个动作会不会更好」必须用 $Q$，因为 $V$ 已经把动作按老策略平均掉了。所有值方法（[5.3](sec53.md)）学的都是 $Q$，所有 Actor–Critic（[5.5](sec55.md)）学的都是 $V$ 加一个策略网络——后者的动作选择由策略网络承担，所以只需要 $V$ 就够用。
:::

::: prop 命题 5.2.1 · $V$ 与 $Q$ 的关系 {#prop-5.2.1}
对任意策略 $\pi$：
$$V^\pi(s)=\sum_{a}\pi(a\mid s)\,Q^\pi(s,a),\qquad
Q^\pi(s,a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\,V^\pi(s').$$
若 $\pi$ 是确定性策略 $\mu$，第一式退化为 $V^\mu(s)=Q^\mu(s,\mu(s))$。
:::

::: proof 证明（两次全期望公式）
**第一式**：由 $\mathbb E[G_t\mid s_t=s]=\mathbb E\bigl[\mathbb E[G_t\mid s_t=s,a_t=a]\bigr]$（全期望公式，外层对 $a\sim\pi(\cdot\mid s)$ 取）立得 $V^\pi(s)=\sum_a\pi(a\mid s)\,Q^\pi(s,a)$。

**第二式**：把 $G_t=r_{t+1}+\gamma G_{t+1}$ 代入，
$$Q^\pi(s,a)=\mathbb E_\pi\bigl[r_{t+1}+\gamma G_{t+1}\mid s_t=s,a_t=a\bigr]
=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\,\mathbb E_\pi[G_{t+1}\mid s_{t+1}=s'],$$
最后一步用到马尔可夫性：给定 $s_{t+1}=s'$，未来的期望只依赖 $s'$，即 $V^\pi(s')$。$\blacksquare$
:::

::: intuition 这两条关系式的用处与代价
注意第二式里**没有再对动作求和**：$a$ 是给定的。把两式合起来就得到贝尔曼方程，这正是下一小节要做的事。同时记住这两条式子的**规模差异**：$Q$ 的表比 $V$ 的表大 $\lvert\mathcal A\rvert$ 倍，这一条决定了后续算法在动作空间很大时会更偏向学 $V$（Actor–Critic）而不是 $Q$。
:::

## 5.2.4 贝尔曼期望方程：值函数的自洽递归

把 $G_t$ 按「当前奖励 + 折扣的未来」递归展开，就得到 RL 的中心方程。

::: thm 定理 5.2.1 · 贝尔曼期望方程（Bellman expectation equation） {#thm-5.2.1}
对任意固定策略 $\pi$，值函数满足
$$V^\pi(s)=\sum_{a}\pi(a\mid s)\Bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\,V^\pi(s')\Bigr],$$
$$Q^\pi(s,a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\sum_{a'}\pi(a'\mid s')\,Q^\pi(s',a').$$
矩阵形式：记 $r^\pi(s)=\sum_a\pi(a\mid s)r(s,a)$、$P^\pi(s'\mid s)=\sum_a\pi(a\mid s)P(s'\mid s,a)$，则 $\boldsymbol v^\pi=\boldsymbol r^\pi+\gamma P^\pi\boldsymbol v^\pi$，其解为
$$\boldsymbol v^\pi=(I-\gamma P^\pi)^{-1}\boldsymbol r^\pi .$$
**这是线性方程组**（不是优化问题）：$V^\pi$ 是它唯一解（$\gamma\lt1$ 时 $I-\gamma P^\pi$ 可逆）。
:::

::: intuition 「一期前瞻」：这条方程说的是一件很小的事
把等式右边读出来：**「在这个状态的值 = 立即拿到的奖励 + 折扣后的下一个状态的值」（再对动作与转移取期望）**。它没有引入任何新东西，只是把「无穷远的回报」折叠成了「一步 + 剩下的值」——这就是自举（bootstrapping）的思想来源。

它的重要性在于把**无穷求和**变成了**单步关系**：只要有一个满足该方程的 $V$，它一定等于真实的期望回报。于是「求值」从「跑无穷多局取平均」变成了「解一个方程组」或「找一个不动点」——后者才是可计算的。
:::

::: proof 推导（期望贝尔曼方程）
设 $G_t=\sum_{k\ge0}\gamma^{k}r_{t+k+1}$。把 $k=0$ 项拆出来：
$$G_t=r_{t+1}+\gamma\sum_{k\ge0}\gamma^{k}r_{t+k+2}=r_{t+1}+\gamma G_{t+1}.$$
两边在 $s_t=s$ 下取条件期望，并用全期望公式对 $(a_t,s_{t+1})$ 展开：
$$V^\pi(s)=\mathbb E_\pi[r_{t+1}+\gamma G_{t+1}\mid s_t=s]
=\sum_a\pi(a\mid s)\Bigl[r(s,a)+\gamma\,\mathbb E_\pi\bigl[G_{t+1}\mid s_t=s,a_t=a\bigr]\Bigr].$$
内层期望再对 $s_{t+1}$ 用一次全期望公式，并由**马尔可夫性**把「给定 $s_t,a_t$ 求 $G_{t+1}$ 的期望」化归为「给定 $s_{t+1}=s'$ 求 $G_{t+1}$ 的期望」，后者按定义就是 $V^\pi(s')$：
$$\mathbb E_\pi[G_{t+1}\mid s_t=s,a_t=a]=\sum_{s'}P(s'\mid s,a)\,\mathbb E_\pi[G_{t+1}\mid s_{t+1}=s']=\sum_{s'}P(s'\mid s,a)V^\pi(s').$$
代入即得第一式。

第二式同理，只需注意 $a$ 已被固定：把 $r_{t+1}$ 与 $\gamma G_{t+1}$ 分别处理后，$G_{t+1}$ 的期望要对 $(s',a')$ 两个随机量展开，即
$Q^\pi(s,a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\sum_{a'}\pi(a'\mid s')Q^\pi(s',a')$。

矩阵形式的可逆性：$\gamma\lt1$ 时 $\lVert\gamma P^\pi\rVert_\infty\le\gamma\lt1$，故 $I-\gamma P^\pi$ 可逆且 $(I-\gamma P^\pi)^{-1}=\sum_{k\ge0}\gamma^k(P^\pi)^k$，把它作用在 $\boldsymbol r^\pi$ 上恰好展开成 $\sum_k\gamma^k(P^\pi)^k\boldsymbol r^\pi$，即「沿策略走 $k$ 步的期望折扣奖励之和」。$\blacksquare$
:::

**代价提醒**：闭式解 $(I-\gamma P^\pi)^{-1}$ 需要 $O(\lvert\mathcal S\rvert^3)$ 的矩阵求逆（或 $O(\lvert\mathcal S\rvert^2)$ 的每步迭代求解），在 $\lvert\mathcal S\rvert=10^6$ 时完全不可行——这就是为什么工程上几乎从不真的解方程，而是**迭代**（5.2.6）或用**采样**替代求和（5.3）。

| 量 | 规模（表格情形） | 用途 | 是否需要 $P$ |
|:--|:--|:--|:--|
| $\pi(a\mid s)$ | $\lvert\mathcal S\rvert\lvert\mathcal A\rvert$ | 决策 | 否 |
| $V^\pi(s)$ | $\lvert\mathcal S\rvert$ | 评估策略 | 否（但我们不知道真值） |
| $Q^\pi(s,a)$ | $\lvert\mathcal S\rvert\lvert\mathcal A\rvert$ | 选择动作 | 否 |
| $P(s'\mid s,a)$ | $\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert$ | 规划（值迭代 / 策略迭代） | **是** |
| $r(s,a)$ | $\lvert\mathcal S\rvert\lvert\mathcal A\rvert$ | 目标定义 | **是**（或由采样估计） |

## 5.2.5 贝尔曼最优方程与最优策略

上一小节固定了 $\pi$。现在问：**是否存在一个策略，在所有状态下都不差于其它任何策略？** 答案是肯定的，而且它满足一个更简洁的方程。

::: thm 定理 5.2.2 · 贝尔曼最优方程（Bellman optimality equation） {#thm-5.2.2}
记 $V^\ast(s)=\max_\pi V^\pi(s)$、$Q^\ast(s,a)=\max_\pi Q^\pi(s,a)$。它们满足
$$V^\ast(s)=\max_{a}\Bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\,V^\ast(s')\Bigr],\qquad
Q^\ast(s,a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\max_{a'}Q^\ast(s',a').$$
与期望方程的唯一差别是：**对动作的（加权）期望 $\sum_a\pi(a\mid s)$ 被换成了 $\max_a$**。作为代价，方程变成**非线性**的，不能再写成线性方程组求解。
:::

::: intuition $\max$ 那一步把「评估」变成了「决策」
期望方程回答「按这个策略会怎样」，所以要对动作按 $\pi$ 加权平均；最优方程回答「怎么做最好」，所以在每个状态**直接挑最好的动作**——这是一个「可以在每一步独立做」的贪心选择。它之所以成立，靠的是**贝尔曼最优性原理**：一个最优策略的子策略（从任何中间状态往后看）也必须是最优的。否则你可以在那个中间状态换一条更好的尾巴，从而改进整体。代价集中在一点：$\max$ 是非线性的，所以不能像期望方程那样一次矩阵求逆解出；而且 $\max$ 会把估计噪声**向上偏**（[5.3](sec53.md) 的 Double DQN 就是治这个病的）。
:::

::: proof 推导（最优方程：从「两步改进」到极限）
**第一步：任何策略都不如「对 $V^\pi$ 贪心」的策略。** 记贪心策略 $\pi'(s)=\arg\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^\pi(s')\bigr]$。由定义
$$V^{\pi'}(s)=\max_a\Bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^\pi(s')\Bigr]\ \ge\ \sum_a\pi(a\mid s)\Bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^\pi(s')\Bigr]=V^\pi(s).$$
**第二步：上式对任意状态同时成立，且可以无限制地迭代下去。** 把 $\pi'\to\pi''\to\cdots$ 的序列记作策略改进序列，则值序列 $V^{\pi^{(k)}}$ 单调不减、有上界（$\le\frac{R_{\max}}{1-\gamma}$），故收敛到某个 $V^\infty$，其对应策略的贪心改进不再变化——即 $V^\infty$ 满足 $\max_a$ 形式的等式，从而是最优值 $V^\ast$。

**第三步：唯一性**。定义最优算子 $(\mathcal TV)(s)=\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V(s')\bigr]$。对任意两个有界函数 $V,U$，用 $\lvert\max_a f(a)-\max_a g(a)\rvert\le\max_a\lvert f(a)-g(a)\rvert$ 得
$$\lVert\mathcal TV-\mathcal TU\rVert_\infty\le\gamma\lVert V-U\rVert_\infty,$$
即 $\mathcal T$ 是压缩映射（收缩因子 $\gamma\lt1$）。由 Banach 不动点定理，$\mathcal T$ 有**唯一**不动点，故 $V^\ast$ 唯一（更详尽的两行证明见[附录 C.9](../../appendix/derivations.md)）。$Q^\ast$ 的版本同理：把 $V^\ast(s')=\max_{a'}Q^\ast(s',a')$ 代入 $V^\ast$ 的定义即得。$\blacksquare$
:::

::: thm 定理 5.2.3 · 最优策略的存在性与贪心性 {#thm-5.2.3}
（i）存在**确定性**的最优策略：$\mu^\ast(s)=\arg\max_a Q^\ast(s,a)$，且它在所有状态上同时最优。
（ii）任何策略 $\pi$ 是最优策略，当且仅当它在 $Q^\ast$ 的支撑集上取正概率：$\pi(a\mid s)\gt0\Rightarrow a\in\arg\max_{a'}Q^\ast(s,a')$。
（iii）$V^\ast(s)=\max_a Q^\ast(s,a)$，且对任意 $\pi$、任意 $s$ 有 $V^\pi(s)\le V^\ast(s)$。
:::

::: intuition 为什么「一个确定性策略就能同时最优」需要论证
在一般的多目标或博弈问题里，「同时最优」往往不存在；MDP 之所以特殊，靠的是两件事：**折扣（$\gamma\lt1$）保证了压缩性**，以及**状态是充分统计量**（马尔可夫性）保证了「每个状态可以独立做贪心而不伤害别的状态」。注意第二条的脆弱性——一旦马尔可夫性被破坏（部分可观测），「一个确定性最优策略」的结论就不成立了：你可能会需要随机化，或者需要把历史纳入状态。

第三条（$V^\ast=\max_aQ^\ast$）在工程上非常有用：它说明**只要有了准确的最优 $Q$ 函数，决策就不需要再学**——这就是值方法（5.3）的全部理论基础。
:::

## 5.2.6 怎么解：策略迭代与值迭代 {#sec-5.2.6}

环境已知（$P$、$R$ 给定）时，求解 MDP 属于**规划**问题，两条经典路线都建立在两个贝尔曼方程上。

::: method 策略迭代（policy iteration） {#method-5.2.1}
交替执行两个步骤，直到策略不再改变：

1. **策略评估（policy evaluation）**：解期望贝尔曼方程（[定理 5.2.1](sec52.md#thm-5.2.1)）得到 $V^{\pi_k}$。实践上用迭代法扫 $J$ 遍：$V\leftarrow \boldsymbol r^{\pi}+ \gamma P^{\pi}\boldsymbol V$，每扫一遍误差按 $\gamma$ 收缩。
2. **策略改进（policy improvement）**：令 $\pi_{k+1}(s)=\arg\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V^{\pi_k}(s')\bigr]$。

由 [定理 5.2.2](sec52.md#thm-5.2.2) 的推导第一步，$V^{\pi_{k+1}}\ge V^{\pi_k}$ 处处成立且存在严格改进的状态；状态数有限 ⇒ 在有限步内收敛到 $\pi^\ast$。

**复杂度**：每次改进 $O(\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert)$；每次完整评估 $O(J\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert)$。**特点**：迭代轮数少（往往十几轮），但每轮很贵。
:::

::: method 值迭代（value iteration） {#method-5.2.2}
跳过显式策略，直接在最优方程上做不动点迭代：
$$V_{k+1}(s)=\max_{a}\Bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V_k(s')\Bigr],\qquad V_0\text{ 任意（常取 }0\text{）}.$$
由 $V^\ast$ 的唯一性与 $\mathcal T$ 的压缩性：$\lVert V_k-V^\ast\rVert_\infty\le\gamma^{k}\lVert V_0-V^\ast\rVert_\infty\le \gamma^k\frac{R_{\max}}{1-\gamma}$。因此要把误差压到 $\varepsilon$ 以内，需要的迭代轮数是
$$k=O\!\left(\frac{\log(1/\varepsilon)}{\log(1/\gamma)}\right),$$
**每一轮只做一次「$\max$ + 加权和」**，成本 $O(\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert)$。

**最后一步**：迭代结束后取 $\mu^\ast(s)=\arg\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V_k(s')\bigr]$。**注意这会丢失一步精度**：$V_k$ 是近似值，但贪心策略往往仍能是真正最优的（实践中常见）。
:::

| 算法 | 每轮成本 | 收敛速度 | 何时选 | 主要代价 |
|:--|:--|:--|:--|:--|
| 线性求解 $\boldsymbol v=(I-\gamma P)^{-1}\boldsymbol r$ | $O(\lvert\mathcal S\rvert^3)$ | 一次解出（给定 $\pi$） | 小规模、只评估固定策略 | 求逆贵；只评估不改进 |
| **策略迭代** | $O(J\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert)$ | 轮数少（每轮评估要扫很多遍） | 动作少、状态中等 | 每轮贵；需 $P$ |
| **值迭代** | $O(\lvert\mathcal S\rvert^2\lvert\mathcal A\rvert)$ | 每轮 $\gamma$ 收缩；$\gamma\to1$ 时很慢 | 通用默认 | 收敛慢；需 $P$ |
| 异步 / 原位值迭代 | 更低（只更新一部分状态） | 视更新顺序 | 大状态空间、稀疏结构 | 收敛性分析更细 |
| 采样型（Q-learning，[5.3](sec53.md)） | 每步 $O(1)$（表格） | 依步长条件 | **$P$ 未知** | 方差、样本量 |

::: ex 例 5.2.2 · 两状态 MDP：手算 $V^\pi$、$Q^\pi$、验证最优性与 $\gamma$ 的作用 {#ex-5.2.2}
状态 $\mathcal S=\{s_1,s_2\}$，动作 $\mathcal A=\{\mathrm L,\mathrm R\}$，$\gamma=0.9$。奖励与转移如下（除下表外无其它转移）：

| 状态 | 动作 | 奖励 $r$ | 转移到 |
|:--|:--|:--|:--|
| $s_1$ | $\mathrm L$ | $1$ | $s_1$（原地） |
| $s_1$ | $\mathrm R$ | $0$ | $s_2$ |
| $s_2$ | $\mathrm L$ | $0$ | $s_1$ |
| $s_2$ | $\mathrm R$ | $2$ | $s_2$（原地） |

**(1)** 求策略 $\pi=$「永远选 $\mathrm R$」下的 $V^\pi(s_1),V^\pi(s_2)$。
**(2)** 求该策略下的 $Q^\pi$，并做一次策略改进，判断 $\pi$ 是否已最优。
**(3)** 用最优方程验证 $V^\ast$；再说明把 $\gamma$ 换成 $0.5$ 会怎样改变决策。

::: proof 解
**(1) 评估**：对 $\pi=$ 永远 $\mathrm R$，期望贝尔曼方程（$P$ 是确定性的，无需对 $s'$ 求和）给出
$$V^\pi(s_2)=2+0.9\,V^\pi(s_2)\ \Longrightarrow\ V^\pi(s_2)=\frac{2}{1-0.9}=20,\qquad
V^\pi(s_1)=0+0.9\,V^\pi(s_2)=18 .$$
（这就是「原地刷奖励」的资本化价值：每步拿 2、永久持续，折现值 $2/(1-\gamma)=20$。）

**(2) 动作值**（用[命题 5.2.1](sec52.md#prop-5.2.1) 第二式）：
$$Q^\pi(s_1,\mathrm L)=1+0.9V^\pi(s_1)=1+16.2=17.2,\qquad Q^\pi(s_1,\mathrm R)=0+0.9V^\pi(s_2)=18,$$
$$Q^\pi(s_2,\mathrm L)=0+0.9V^\pi(s_1)=16.2,\qquad Q^\pi(s_2,\mathrm R)=2+0.9V^\pi(s_2)=20 .$$
**改进**：$s_1$ 处 $\max(17.2,18)=18$ 取 $\mathrm R$；$s_2$ 处 $\max(16.2,20)=20$ 取 $\mathrm R$。贪心策略与 $\pi$ 相同 ⇒ **$\pi$ 已是最优**，$V^\ast=(18,20)$。

**(3) 最优方程验证**：
$$V^\ast(s_1)=\max\{1+0.9\times18,\ 0+0.9\times20\}=\max\{17.2,\ 18\}=18\ \checkmark$$
$$V^\ast(s_2)=\max\{0+0.9\times18,\ 2+0.9\times20\}=\max\{16.2,\ 20\}=20\ \checkmark$$
两式都自洽，说明 $(18,20)$ 是不动点。

**$\gamma=0.5$ 时**：$V^\pi(s_2)=\frac{2}{1-0.5}=4$，$V^\pi(s_1)=0+0.5\times4=2$，于是
$$Q^\pi(s_1,\mathrm L)=1+0.5\times2=2.0,\qquad Q^\pi(s_1,\mathrm R)=0+0.5\times4=2.0 .$$
**两个动作打平**——折扣变小之后，「立刻拿 1 分并留在原地」变得与「放弃 1 分去追未来」等价。这个例子说明：**$\gamma$ 不只是数值技巧，它决定了动作的排序**（在 $\gamma=0.9$ 时 $\mathrm R$ 严格占优 0.8，在 $\gamma=0.5$ 时完全打平）。工程上把 $\gamma$ 调大往往会让「短视的即时收益」输给「长期布局」——但这同时把信用分配的跨度拉长，训练更难。$\blacksquare$
:::
:::

## 5.2.7 代码：值迭代求解一个小网格世界

下面的代码把 [5.2.6](sec52.md#sec-5.2.6) 的值迭代写成张量运算：**内层循环只有一行 `max`**——这就是贝尔曼最优方程的向量化形式。环境完全自包含（不需要任何环境库）。

```python
import torch

# 4×4 网格世界：动作 0=上 1=右 2=下 3=左；撞墙则原地不动
# 奖励约定：每走一步 −1；进入右上 (0,3) 或右下 (3,3) 的目标格再额外 +10
N, GAMMA, EPS = 4, 0.9, 1e-6
MOVE = [(-1, 0), (0, 1), (1, 0), (0, -1)]
STATES = [(i, j) for i in range(N) for j in range(N)]
IDX = {s: k for k, s in enumerate(STATES)}
GOALS = {(0, 3): 10.0, (3, 3): 10.0}

def env_step(s, a):
    """确定性转移：返回 (下一个状态, 即时奖励)。真实环境里这一步是黑箱。"""
    i, j = s
    di, dj = MOVE[a]
    s2 = (min(max(i + di, 0), N - 1), min(max(j + dj, 0), N - 1))
    return s2, -1.0 + GOALS.get(s2, 0.0)

# 把环境「表格化」：S2[k, a] 是转移目标索引，R[k, a] 是即时奖励。
# 注意：这一步在真实问题里做不到（P、R 未知），此处是为了演示「已知环境下的规划」。
S2, R = torch.zeros(len(STATES), 4, dtype=torch.long), torch.zeros(len(STATES), 4)
for k, s in enumerate(STATES):
    if s in GOALS:                       # 终止状态：自环、零奖励（值恒为 0）
        S2[k] = k
        continue
    for a in range(4):
        s2, r = env_step(s, a)
        S2[k, a], R[k, a] = IDX[s2], r

V = torch.zeros(len(STATES))
for it in range(1, 20001):
    # 贝尔曼最优方程的一轮迭代：max over a of [r(s,a) + γ V(s')]
    V_new = (R + GAMMA * V[S2]).max(dim=1).values
    V_new[torch.tensor([IDX[s] for s in GOALS])] = 0.0   # 终止状态的值恒为 0
    delta = (V_new - V).abs().max().item()
    V = V_new
    if delta < EPS:
        break

Q = R + GAMMA * V[S2]                      # 收敛后顺手得到 Q*，用于取贪心策略
ARROW = "↑→↓←"
print(f"收敛轮数 {it}（理论量级 O(log(1/ε)/log(1/γ)) ≈ {int(18.4/0.105)+1}），起点 V = {V[IDX[(0,0)]].item():.3f}")
for i in range(N):
    print("  " + " ".join("G" if (i, j) in GOALS else ARROW[int(Q[IDX[(i, j)]].argmax())] for j in range(N)))

# 判据：① 收敛轮数应落在 100–250 之间（γ=0.9、ε=1e-6 的量级估算 ≈ 174 轮）；② 起点 (0,0) 的最优值为
# 负数（每步 −1、约 3 步到目标）；③ 非目标格的最优动作应形成朝向目标的流场，出现原地打转即说明奖励写错。
```

三点读代码的提示：

1. **第 5 行的奖励设计是本实验唯一「人为」的部分**：如果不给 $+10$、只保留每步 $-1$，最优策略会变成「尽快结束」之外的任意绕路——这正是奖励设计决定行为的直接体现（[5.6](sec56.md)）。
2. **`V[S2]` 是函数逼近思想的最小演示**：用一个状态值张量 + 一个索引表表示 $P(s'\mid s,a)$ 的效果。在真实问题里，`S2` 由环境采样得到、`V[S2]` 由一个网络近似。
3. **终止状态的值必须手动钉住**：这是 RL 代码里最常见的 off-by-one 错误来源；[5.3](sec53.md) 的 DQN 循环用 `(1 - done)` 掩码做同一件事。

::: errata 本节常见误解
1. **「贝尔曼方程在估计 $V^\ast$」**：期望方程（[定理 5.2.1](sec52.md#thm-5.2.1)）评的是**给定策略**的值 $V^\pi$；最优方程（[定理 5.2.2](sec52.md#thm-5.2.2)）才给 $V^\ast$——把两者混用会导致「以为在评估、实际在改进」的策略退化。**「$\gamma=1$ 更客观」**同样错：无限时域下 $\gamma=1$ 会让回报发散、值函数无定义（有限时域取 $\gamma=1$ 时必须显式带终止条件）；工程上 $\gamma$ 要和任务时间尺度匹配：控制任务常取 $0.99$，回合制游戏 $0.99$–$0.999$，短期任务 $0.9$ 也够。
2. **「$V$ 和 $Q$ 差不多，随便用一个」**：差一个动作维，用途也不同。**评估**用 $V$，**决策**用 $Q$；Actor–Critic 里之所以用 $V$，是因为决策交给了策略网络。
4. **「最优策略一定是确定性的」**：在 MDP 里对，但**必须**满足马尔可夫性与已知奖励结构；在部分可观测（POMDP）或对抗博弈中，最优策略通常是随机的——这也是「石头剪刀布不能用贪心打」的原因。
5. **「策略迭代与值迭代差别很大」**：两者都收敛到同一个 $V^\ast$；差别是**评估的粒度**（扫很多遍 vs 只扫一遍）。在每轮成本相差一个 $J$ 倍、而轮数相差不多的情形下，值迭代通常更划算。
:::

::: method 即时自测 · 5.2
**Q1** 写出 MDP 五元组，并说明「马尔可夫性」在工程上最实用的那句推论是什么。**Q2** 从 $G_t=r_{t+1}+\gamma G_{t+1}$ 出发，写出 $Q^\pi$ 的贝尔曼期望方程，并指出推导中用到了哪一步「马尔可夫性」。

**Q3** 为什么 $V^\pi(s)=\sum_a\pi(a\mid s)Q^\pi(s,a)$，而最优版本却是 $V^\ast(s)=\max_aQ^\ast(s,a)$？「期望变 $\max$」这一步为何需要额外的论证？**Q4** 用[例 5.2.2](sec52.md#ex-5.2.2)的数据，若 $\gamma=0.99$（其余不变），$Q^\pi(s_1,\mathrm R)-Q^\pi(s_1,\mathrm L)$ 会变大还是变小？先算数再解释。

::: sol 参考要点
**Q1** $(\mathcal S,\mathcal A,P,R,\gamma)$。最实用的推论：**$(s_t,a_t)$ 是未来的充分统计量**——只要状态定义得足够（必要时用帧堆叠 / 隐状态补足），就不必回放整段历史；反之，如果发现「同样的状态、同样的动作、结果分布不同」，说明状态定义不够高。

**Q2** $Q^\pi(s,a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)\sum_{a'}\pi(a'\mid s')Q^\pi(s',a')$。马尔可夫性用在把 $\mathbb E_\pi[G_{t+1}\mid s_t=s,a_t=a]$ 化归为「给定 $s_{t+1}=s'$ 的期望」那一步——它保证 $G_{t+1}$ 的分布只依赖 $s'$，与更早的历史无关。

**Q3** 因为 $V$ 是「按当前策略平均」，所以对动作取 $\pi$ 加权期望；而 $V^\ast$ 是「最好能有多好」，所以对动作取 $\max$。$\max$ 与期望不同，它是**非线性**的，因此不能像期望方程那样用矩阵求逆一次解出；而且「$\max$ 版本的方程」写成等式需要先证明**贪心改进不会变差**（策略改进引理），再用压缩映射保证唯一不动点——这正是[定理 5.2.2](sec52.md#thm-5.2.2) 的证明内容。

**Q4** 变大。$V^\pi(s_2)=2/(1-0.99)=200$、$V^\pi(s_1)=0.99\times200=198$，于是 $Q^\pi(s_1,\mathrm R)=0.99\times200=198$、$Q^\pi(s_1,\mathrm L)=1+0.99\times198=197.02$，差距 $0.98$；而 $\gamma=0.9$ 时差距是 $18-17.2=0.8$。**解释**：$\gamma$ 越大，$s_2$ 上「每步 +2」的长期资本化价值越高（$2/(1-\gamma)$ 从 20 涨到 200），「去 $s_2$」这条路的吸引力随之放大；而「留在原地拿 1」的资本化价值只有 $1/(1-\gamma)$，相对被压低。注意差距的**绝对值**只从 0.8 涨到 0.98（量级不大），但**相对决策的重要性**提高了——这也解释了为什么大 $\gamma$ 下值函数的数值尺度会膨胀（[5.3](sec53.md) 要用奖励缩放和优势归一化）。
:::
:::

::: note[skip] 延伸阅读
- Sutton & Barto, *Reinforcement Learning: An Introduction*（2nd ed., 2018）——第 3 章（MDP、回报、值函数）、第 4 章（动态规划：策略迭代与值迭代）。本节的推导顺序与它一致，可作为对照阅读。
- Puterman, *Markov Decision Processes: Discrete Stochastic Dynamic Programming*（Wiley, 1994）与 Bertsekas, *Dynamic Programming and Optimal Control*, Vol. II（4th ed., 2012）——前者是 MDP 的经典严格教材（最优策略存在性与压缩映射的完整证明），后者从最优控制视角讲同一套方程，适合想看连续状态（HJB 方程）延伸的读者。
- 母本 MIT 6.S191 的强化学习讲次（官网当期排课，**需核实**）与 OpenAI Spinning Up 的 *Key Concepts in RL*——前者用于对照「课程里只给结论」与本教程的展开程度，后者把 $V$、$Q$、$A$ 与折扣的关系做成了一页速查。
:::

**本节小结**：MDP 用五元组把交互问题写成可推导的对象，马尔可夫性让 $(s_t,a_t)$ 成为未来的充分统计量；在折扣回报下 $V^\pi$、$Q^\pi$ 满足**线性**的贝尔曼期望方程，而最优值 $V^\ast$、$Q^\ast$ 满足**非线性**的贝尔曼最优方程——它有无解、有唯一解、且有确定性贪心最优策略。求解的两条路线（策略迭代 / 值迭代）都需要已知 $P$ 与 $R$；下一节去掉这个前提：**只有采样，怎么估计这些值**。
