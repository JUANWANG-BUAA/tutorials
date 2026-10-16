# 第 5 讲习题集

> 四组难度递进：**A 概念判断 → B 推导证明 → C 编程实现 → D 开放设计**。答案默认折叠，点击展开。
> 用法：先闭卷做 A 组（判断题只写「对/错」不给分，必须给一句话理由或反例）；B 组**手写**推导，涉及形状与数值的先把中间量写出来；C 组上机并**跑通验收标准**才算做完；D 组写成半页方案，四项（方案 + 理由 + 失败判据 + 验证计划）缺一不可。
> 考点范围限[导览](overview.md)与 [5.1](sec51.md)–[5.7](sec57.md)，每题答案都能在正文与[附录 C.9–C.13](../../appendix/derivations.md) 定位。想不通时先回「依据」，再看折叠答案。

## A 组 · 概念判断（8 题）

**A1.** 既然奖励是一个数字、标签也是一个数字，那么「有奖励」就等于「有标签」。（依据：[定义 5.1.1](sec51.md#def-5.1.1)、[5.1 的 `think` 框](sec51.md)）

::: sol 答案
**错。** 差别在**粒度与因果位置**：标签 $y_i$ 与输入一一对应、逐样本可分解，直接告诉你「这个输入的正确答案」；奖励是**轨迹级**标量，只评价「刚才发生的事有多好」，不指出哪一步该负责。用数学说：监督学习给的是 $\nabla_\theta\mathcal L(\boldsymbol x_i,y_i)$ 的逐样本分解，RL 给的是轨迹级样本 $r$，中间必须靠策略梯度定理或值函数搭桥。**推论**：如果一个问题能被写成监督学习，就不该用 RL——RL 的方差、样本成本与不稳定性都远高于监督。
:::

**A2.** 三个动作的真实期望奖励为 $\mu=(0.8,0.5,0.2)$，用 $\varepsilon=0.2$ 的 $\varepsilon$-greedy：单步期望奖励是 0.68。（依据：[定理 5.1.1](sec51.md#thm-5.1.1)）

::: sol 答案
**错。** $\bar\mu=(0.8+0.5+0.2)/3=0.5$，故 $\mathbb E[r]=(1-0.2)\times0.8+0.2\times0.5=0.64+0.10=\mathbf{0.74}$，探索税 $\Delta=\varepsilon(\mu^\ast-\bar\mu)=0.2\times0.3=\mathbf{0.06}$（验算 $0.8-0.74=0.06$ ✓）。**注意「探索税」与「选择税」是两笔账**：前者是常数 $\varepsilon$ 的固有损失，后者来自「贪心动作其实不是最优动作」（估计误差），本节算例假设估计已正确，故只交探索税。
:::

**A3.** 同一条转移、同一张 $Q$ 表，Q-learning 与 SARSA 的更新结果必然相同，因为两者的 TD 目标都是 $r+\gamma Q(s',\cdot)$。（依据：[例 5.3.1](sec53.md#ex-5.3.1)）

::: sol 答案
**错。** 差别在「未来那一项按谁算」：Q-learning 用 $\max_{a'}Q(s',a')$（off-policy，假设之后都做最优选择），SARSA 用行为策略**实际选中**的 $Q(s',a')$（on-policy）。在正文算例中同一转移给出 **5.3**（Q-learning）与 **3.95**（SARSA），差 1.35。**两者何时相等**：行为策略恰好选中最优动作时——此时两条式子退化成一个，这也是「探索强度决定二者差距」的原因。
:::

**A4.** 经验回放是一个通用的训练技巧，任何 RL 算法都可以把回放池接上去。（依据：[5.3.3 的 `think` 框](sec53.md)、[5.3 的 errata](sec53.md)）

::: sol 答案
**错。** 复用旧数据**只在 off-policy（或做过重要性修正）的算法里合法**。Q-learning/DQN 的目标用 $\max$、不依赖产生数据的行为策略，所以旧数据仍是对 $Q^\ast$ 的（近似）无偏样本；把回放池塞给 REINFORCE 会引入**未校正的分布偏移**，梯度有偏（纯 REINFORCE 是 on-policy，数据只能用一次）。PPO 处于中间：用 $\rho=\pi_\theta/\pi_{\theta_{\text{old}}}$ 做修正后可以多跑几个 epoch，但跑完必须重新采样。
:::

**A5.** 贝尔曼最优方程里有 $\max$、是非线性的，所以它的解可能存在多个，甚至可能不存在。（依据：[定理 5.2.2](sec52.md#thm-5.2.2) 的第三步与[附录 C.9](../../appendix/derivations.md)）

::: sol 答案
**错。** 非线性只意味着**不能写成线性方程组一次解出**，与解的存在唯一性无关。最优算子 $\mathcal T$ 对任意有界 $V,U$ 满足 $\lVert\mathcal TV-\mathcal TU\rVert_\infty\le\gamma\lVert V-U\rVert_\infty$（用 $\lvert\max_af(a)-\max_ag(a)\rvert\le\max_a\lvert f(a)-g(a)\rvert$），即它是压缩因子 $\gamma\lt1$ 的压缩映射；由 Banach 不动点定理，它在有界函数空间上有**唯一**不动点，即 $V^\ast$。**附带结论**：压缩性同时给出误差界 $\lVert V_k-V^\ast\rVert_\infty\le\gamma^k\lVert V_0-V^\ast\rVert_\infty$，这才是值迭代收敛速度的来源。
:::

**A6.** 基线 $b(s)$ 会改变策略梯度的期望，所以选基线是一种「偏差换方差」的取舍。（依据：[定理 5.4.3](sec54.md#thm-5.4.3)、[5.4.5 的 errata](sec54.md)）

::: sol 答案
**错。** 对**任意只依赖状态**的 $b(s)$ 有
$$\mathbb E\Bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)b(s_t)\Bigr]=\mathbb E_s\Bigl[b(s)\sum_a\pi_\theta(a\mid s)\nabla_\theta\log\pi_\theta(a\mid s)\Bigr]=\mathbb E_s\bigl[b(s)\nabla_\theta 1\bigr]=0,$$
这是**精确的零期望**（只用到概率归一化），不是近似，所以**不引入任何偏差**，差别只在方差。**但有一个硬约束**：要保无偏，基线不能依赖**当前动作** $a_t$；若用 $Q(s_t,a_t)$ 自身当基线，上面 $\sum_a\nabla_\theta\pi_\theta=0$ 那一步失效，有偏项进入梯度。
:::

**A7.** GAE 的两个极端是：$\lambda=0$ 时退化为蒙特卡洛（低偏差高方差），$\lambda=1$ 时退化为一步 TD（低方差高偏差）。（依据：[定理 5.5.1](sec55.md#thm-5.5.1)）

::: sol 答案
**错（两个极端说反了）。** 正确是：$\lambda=0$ 时 $\hat A_t=\delta_t$，即**一步 TD 残差**（偏差大、方差小，因为只含一步随机性）；$\lambda=1$ 时 $\hat A_t=\sum_l\gamma^l\delta_{t+l}=G_t-V(s_t)$，即**蒙特卡洛**（偏差小、方差大，整局噪声全进来）。直觉上 $\lambda$ 调的是「多信任远期数据」：越信 Critic（$\lambda\to0$）越省方差但吃它的偏差。
:::

**A8.** PPO 的裁剪目标是「一旦某个样本越界，它的梯度就被完全归零」，所以裁剪对所有越界情形都生效。（依据：[定义 5.5.2](sec55.md#def-5.5.2) 后的分情形推导、[例 5.5.2](sec55.md#ex-5.5.2)）

::: sol 答案
**错。** 四个越界象限里**只有两个**满足 $\partial f/\partial\rho=0$：$A\gt0$ 且 $\rho\gt1+\varepsilon$、以及 $A\lt0$ 且 $\rho\lt1-\varepsilon$——这两格是「**继续外推**」的方向被停手。另两格（$A\gt0$ 且 $\rho\lt1-\varepsilon$、$A\lt0$ 且 $\rho\gt1+\varepsilon$）的梯度**仍然活跃**，且方向恰好是把 $\rho$ **拉回区间**。此外还有两点容易漏：① 被裁剪的是**目标函数**，不是策略概率本身（概率仍可变，只是没有奖励激励），因此不会出现 $\log 0$；② 「目标对 $\rho$ 的偏导为 0」不等于「该样本对参数 $\theta$ 完全没有贡献」——$\rho$ 本身仍通过 $\pi_\theta$ 依赖 $\theta$，只是链式法则中这一环断开了，所以实现上要用 `clip_fraction` 监控越界比例。
:::

## B 组 · 推导与证明（6 题）

> 要求：关键步骤逐条写出，不许写「略」；先写形状或先算中间量。

**B1.** 定义最优算子 $(\mathcal TV)(s)=\max_a\bigl[r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V(s')\bigr]$。证明它是压缩映射：对任意有界函数 $V,U$，$\lVert\mathcal TV-\mathcal TU\rVert_\infty\le\gamma\lVert V-U\rVert_\infty$；并说明由此得到的两条结论（不动点唯一、值迭代的误差界）。（依据：[定理 5.2.2](sec52.md#thm-5.2.2) 第三步、[值迭代](sec52.md#method-5.2.2)）

::: sol 提示与答案
**第一步：把两个 max 的差用一个 max 的差控制。** 对任意函数 $f,g$ 使用 $\lvert\max_af(a)-\max_ag(a)\rvert\le\max_a\lvert f(a)-g(a)\rvert$（上界与下界各推一遍：$\max_af\le\max_a(g+\lvert f-g\rvert)\le\max_ag+\max_a\lvert f-g\rvert$，交换 $f,g$ 得另一半）。取 $f(a)=r(s,a)+\gamma\sum_{s'}P(s'\mid s,a)V(s')$、$g(a)$ 同理换成 $U$。

**第二步：把加权平均换成无穷范数。** 因 $\sum_{s'}P(s'\mid s,a)=1$ 且 $P\ge0$，
$$\bigl|f(a)-g(a)\bigr|=\gamma\Bigl|\sum_{s'}P(s'\mid s,a)\bigl(V(s')-U(s')\bigr)\Bigr|\le\gamma\sum_{s'}P(s'\mid s,a)\lVert V-U\rVert_\infty=\gamma\lVert V-U\rVert_\infty .$$
对 $s$ 取上确界即得 $\lVert\mathcal TV-\mathcal TU\rVert_\infty\le\gamma\lVert V-U\rVert_\infty$（压缩因子 $\gamma\lt1$）。

**结论一（唯一性）**：由 Banach 不动点定理，$\mathcal T$ 在有界函数空间上有唯一不动点；结合「策略改进不会变差」的另一半论证（任何策略都不如对 $V^\pi$ 贪心的策略），该不动点就是 $V^\ast$。

**结论二（误差界与轮数）**：反复代入 $\lVert V_{k+1}-V^\ast\rVert_\infty=\lVert\mathcal TV_k-\mathcal TV^\ast\rVert_\infty\le\gamma\lVert V_k-V^\ast\rVert_\infty$ 得 $\lVert V_k-V^\ast\rVert_\infty\le\gamma^k\lVert V_0-V^\ast\rVert_\infty$，特别地取 $V_0=0$ 有 $\le\gamma^kR_{\max}/(1-\gamma)$。要把误差压到 $\varepsilon$ 以内需 $k=O\!\left(\dfrac{\log(1/\varepsilon)}{\log(1/\gamma)}\right)$ 轮——**$\gamma\to1$ 时收敛骤慢**，这就是值迭代「通用但慢」的来源（[值迭代对比表](sec52.md#method-5.2.2)）。
:::

**B2.** 从 $J(\theta)=\sum_\tau p_\theta(\tau)G(\tau)$ 出发，按轨迹展开完成策略梯度定理的四步推导：① 对数导数技巧；② 轨迹概率取对数后**环境项消失**；③ 用因果性把 $G(\tau)$ 换成 $G_t$；④ 认出 $Q^{\pi_\theta}$。并说明哪一步是「不需要知道 $P$」的依据。（依据：[定理 5.4.1](sec54.md#thm-5.4.1)、[附录 C.10](../../appendix/derivations.md)）

::: sol 提示与答案
**① 对数导数技巧。** 由 $\nabla_\theta p_\theta=p_\theta\nabla_\theta\log p_\theta$，
$$\nabla_\theta J=\sum_\tau p_\theta(\tau)\nabla_\theta\log p_\theta(\tau)G(\tau)=\mathbb E_{\tau\sim p_\theta}\bigl[G(\tau)\nabla_\theta\log p_\theta(\tau)\bigr],$$
把「对分布的导数」（在指数级大的 $\tau$ 空间上不可枚举）变成**一个可采样的期望**。隐含要求：被采到的 $(s,a)$ 上 $\pi_\theta(a\mid s)\gt0$，否则 $\log$ 无定义。

**② 环境项消失。** 由 $p_\theta(\tau)=\rho(s_0)\prod_t\pi_\theta(a_t\mid s_t)P(s_{t+1}\mid s_t,a_t)$，
$$\log p_\theta(\tau)=\log\rho(s_0)+\sum_t\log\pi_\theta(a_t\mid s_t)+\sum_t\log P(s_{t+1}\mid s_t,a_t),\qquad
\nabla_\theta\log p_\theta(\tau)=\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t),$$
因为 $\rho$ 与 $P$ 与 $\theta$ 无关，求导后**整项消失**。**这一步就是「策略梯度不需要环境模型」的全部依据**：只要能从环境采样估期望，梯度就能算。

**③ 因果性（回报-to-go）。** 把 $\nabla_\theta J=\mathbb E\bigl[\sum_t\nabla_\theta\log\pi_\theta(a_t\mid s_t)G(\tau)\bigr]$ 按时间重排，并把 $G(\tau)$ 换成 $G_t$：设 $H_t$ 为 $t$ 之前的奖励之和（$G$ 的分解中它只由历史决定，与 $a_t$ 无关），则
$$\mathbb E\bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)H_t\bigr]=\mathbb E_{s_t}\Bigl[h(s_t)\sum_a\pi_\theta(a\mid s_t)\nabla_\theta\log\pi_\theta(a\mid s_t)\Bigr]=\mathbb E_{s_t}\bigl[h(s_t)\nabla_\theta 1\bigr]=0,$$
其中 $h(s_t)=\mathbb E[H_t\mid s_t,a_t]$ 只是状态的函数，可提出对动作的求和——**这正是基线无偏性用的同一个引理**。

**④ 认出 $Q$。** 在期望里先对 $(s_t,a_t)$ 取条件：$\mathbb E[\nabla_\theta\log\pi_\theta(a_t\mid s_t)G_t]=\mathbb E_{s_t,a_t\sim\pi_\theta}\bigl[\nabla_\theta\log\pi_\theta(a_t\mid s_t)\,\mathbb E[G_t\mid s_t,a_t]\bigr]$，而 $\mathbb E[G_t\mid s_t,a_t]=Q^{\pi_\theta}(s_t,a_t)$。合并 $t$ 的求和即得
$$\nabla_\theta J(\theta)=\mathbb E_{\pi_\theta}\Bigl[\sum_{t\ge0}\nabla_\theta\log\pi_\theta(a_t\mid s_t)Q^{\pi_\theta}(s_t,a_t)\Bigr].$$
**严格性说明**：上式把状态访问分布 $d^{\pi_\theta}$ 的 $\theta$ 依赖「直接抵消」了；严格证明需要证明多出的那一项为零，见 Sutton 等（2000）。
:::

**B3.** 推导 GAE 的指数加权形式 $\hat A^{\text{GAE}}_t=(1-\lambda)\sum_{n\ge1}\lambda^{n-1}\hat A^{(n)}_t=\sum_{l\ge0}(\gamma\lambda)^l\delta_{t+l}$，并证明等价的递归式 $\hat A_t=\delta_t+\gamma\lambda\hat A_{t+1}$；最后说明 $\gamma$ 与 $\lambda$ 为什么会「一起」出现。（依据：[定理 5.5.1](sec55.md#thm-5.5.1)、[附录 C.11](../../appendix/derivations.md)）

::: sol 提示与答案
**第一步：展开 $n$ 步优势。** $\hat A^{(n)}_t=\sum_{l=0}^{n-1}\gamma^l\delta_{t+l}$，于是
$$(1-\lambda)\sum_{n\ge1}\lambda^{n-1}\sum_{l=0}^{n-1}\gamma^l\delta_{t+l}.$$
**第二步：交换求和次序。** 对固定 $l$，$n$ 从 $l+1$ 起：
$$=(1-\lambda)\sum_{l\ge0}\gamma^l\delta_{t+l}\sum_{n\ge l+1}\lambda^{n-1}
=(1-\lambda)\sum_{l\ge0}\gamma^l\delta_{t+l}\cdot\frac{\lambda^{l}}{1-\lambda}
=\sum_{l\ge0}(\gamma\lambda)^l\delta_{t+l},$$
其中用了几何级数 $\sum_{n\ge l+1}\lambda^{n-1}=\lambda^l/(1-\lambda)$（$\lambda\lt1$）。

**第三步：递归式。** 从闭式里拆出 $l=0$ 项：$\hat A_t=\delta_t+\sum_{l\ge1}(\gamma\lambda)^l\delta_{t+l}=\delta_t+\gamma\lambda\sum_{l\ge0}(\gamma\lambda)^l\delta_{t+l+1}=\delta_t+\gamma\lambda\hat A_{t+1}$。
**边界**：$\hat A_T=0$（轨迹末端之后没有残差），实现上一次从后往前的循环即可（O(T)）。

**为什么 $\gamma$ 与 $\lambda$ 一起出现**：$\gamma^l$ 来自**折扣**（第 $l$ 步之后的奖励本来就该打折），$\lambda^l$ 是**人为给远处 TD 残差打的额外折扣**，二者在闭式里天然相乘。工程含义：默认 $\lambda=0.95$、$\gamma=0.99$ 时 $\gamma\lambda\approx0.94$，有效记忆约 $1/(1-\gamma\lambda)\approx17$ 步——**它就是偏差—方差旋钮，没有更深的含义**。
:::

**B4.** PPO 裁剪目标 $f(\rho)=\min\bigl(\rho A,\ \mathrm{clip}(\rho,1-\varepsilon,1+\varepsilon)A\bigr)$（$A$ 视为与该样本的 $\theta$ 无关的常数）。分五个区间讨论 $\partial f/\partial\rho$，指出哪两格的梯度被归零、哪两格仍然活跃且「拉回区间」，并证明 $f\le\rho A$ 逐点成立。（依据：[定义 5.5.2](sec55.md#def-5.5.2) 后推导、[例 5.5.2](sec55.md#ex-5.5.2)）

::: sol 提示与答案
裁剪项在区间外是**常数**，故只需看 $\min$ 取到哪一支。

| 区间 | $A\gt0$ | $A\lt0$ |
|:--|:--|:--|
| $\rho\gt1+\varepsilon$ | $\mathrm{clip}\,A=(1+\varepsilon)A\lt\rho A$，$\min$ 取常数项 ⇒ $f=(1+\varepsilon)A$，$\partial f/\partial\rho=\mathbf 0$（**停手**） | $(1+\varepsilon)A$ 因 $A\lt0$ 而**大于** $\rho A$，$\min$ 取 $\rho A$ ⇒ $\partial f/\partial\rho=A\lt0$（**继续压低，拉回**） |
| $\rho\lt1-\varepsilon$ | $(1-\varepsilon)A\gt\rho A$，$\min$ 取 $\rho A$ ⇒ $\partial f/\partial\rho=A\gt0$（**继续抬高，拉回**） | $(1-\varepsilon)A\lt\rho A$，$\min$ 取常数项 ⇒ $f=(1-\varepsilon)A$，$\partial f/\partial\rho=\mathbf 0$（**停手**） |
| $1-\varepsilon\le\rho\le1+\varepsilon$ | $\mathrm{clip}=\rho$，两项相等，$f=\rho A$，$\partial f/\partial\rho=A$（带重要性权重的普通策略梯度） | 同左 |

**下界性质**：$\min$ 恒取两个候选里较小的那个，故 $f\le\rho A$ 逐点成立，对样本取期望得 $L^{\mathrm{CLIP}}\le L^{\mathrm{CPI}}$——裁剪目标始终是**无裁剪替代目标的保守下界**，它不会高估「一步更新能带来的改善」。

**把四格与下界合起来的读法**：区间内正常优化；越界后**「继续外推」的梯度归零**（$A\gt0$ 已抬过头 / $A\lt0$ 已压过头），而**「回到区间」的梯度保留**。这就是「软信任域」：TRPO 用 KL 硬约束**禁止**越界，PPO 允许越界但不再给奖励。
**两个必须补的注**：① 「$\partial f/\partial\rho=0$」不等于「该样本对 $\theta$ 无贡献」，$\rho$ 本身仍依赖 $\theta$；② 被裁剪的是目标函数而非概率，不会产生 $\log 0$。
:::

**B5.** 从 KL 正则目标 $\max_\pi\ \mathbb E_{y\sim\pi}\bigl[r(x,y)\bigr]-\beta\,\mathrm{KL}\bigl(\pi(\cdot\mid x)\,\Vert\,\pi_{\text{ref}}(\cdot\mid x)\bigr)$ 出发：① 用拉格朗日法求闭式最优解；② 反解出 $r(x,y)$；③ 代入 Bradley–Terry 模型消掉 $Z(x)$，写出 DPO 损失。（依据：[定理 5.6.2](sec56.md#thm-5.6.2)、[附录 C.13](../../appendix/derivations.md)）

::: sol 提示与答案
**① 闭式最优解。** 固定 $x$，问题按 $y$ 分解，约束 $\sum_y\pi_y=1$。拉格朗日函数（简写 $\pi_y=\pi(y\mid x)$、$\pi_{\text{ref},y}$ 同理）
$$\mathcal L(\pi,\lambda)=\sum_y\pi_yr_y-\beta\sum_y\pi_y\log\frac{\pi_y}{\pi_{\text{ref},y}}+\lambda\Bigl(1-\sum_y\pi_y\Bigr),$$
对 $\pi_y$ 求偏导置零：$r_y-\beta\bigl(\log\frac{\pi_y}{\pi_{\text{ref},y}}+1\bigr)-\lambda=0\Rightarrow\log\frac{\pi_y}{\pi_{\text{ref},y}}=\frac{r_y-\lambda}{\beta}-1$。取指数得 $\pi_y\propto\pi_{\text{ref},y}e^{r_y/\beta}$，归一化常数写成分配函数：
$$\pi^\star(y\mid x)=\frac{1}{Z(x)}\pi_{\text{ref}}(y\mid x)\exp\!\Bigl(\frac{r(x,y)}{\beta}\Bigr),\qquad Z(x)=\sum_y\pi_{\text{ref}}(y\mid x)\exp\!\Bigl(\frac{r(x,y)}{\beta}\Bigr).$$
（二阶条件 $\partial^2\mathcal L/\partial\pi_y^2=-\beta/\pi_y\lt0$，确为极大值。）

**② 反解奖励。** 由 $\log\frac{\pi^\star}{\pi_{\text{ref}}}=\frac{r}{\beta}-\log Z(x)$ 移项：
$$r(x,y)=\beta\log\frac{\pi^\star(y\mid x)}{\pi_{\text{ref}}(y\mid x)}+\beta\log Z(x).$$

**③ 代入 BT 消掉 $Z(x)$。** $\Pr(y_w\succ y_l)=\sigma\bigl(r_w-r_l\bigr)$，而差值里两个 $\beta\log Z(x)$ **精确相减为零**——**唯一的原因是 $Z(x)$ 只依赖提示 $x$、与回答 $y$ 无关**。把 $\pi^\star$ 换成待训的 $\pi_\theta$（这一步是唯一的近似：假设最优解在参数化策略族内可达），取负对数似然：
$$\mathcal L_{\text{DPO}}(\theta)=-\mathbb E_{(x,y_w,y_l)}\left[\log\sigma\!\left(\beta\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}\right)\right].$$
**两个必须点出的推论**：① 若偏好对的两个回答来自**不同 prompt**，差值里会留下 $\beta\log Z(x_w)-\beta\log Z(x_l)$，**无法抵消**，DPO 损失不成立——这就是「偏好对必须同 prompt」的数据要求；② $\hat r_\theta=\beta\log\frac{\pi_\theta}{\pi_{\text{ref}}}$ 就是隐式奖励，$r_\phi$ 没有被训练，而是被参数化掉了。
:::

**B6.** 两状态 MDP（$s_1,s_2$；$s_1\!\to\!\mathrm L$ 得 1 留原地、$s_1\!\to\!\mathrm R$ 得 0 转 $s_2$；$s_2\!\to\!\mathrm L$ 得 0 转 $s_1$、$s_2\!\to\!\mathrm R$ 得 2 留原地），$\gamma=0.9$。对策略 $\pi=$「永远 R」：① 写出矩阵形式 $\boldsymbol v^\pi=\boldsymbol r^\pi+\gamma P^\pi\boldsymbol v^\pi$ 并求出 $(I-\gamma P^\pi)^{-1}$；② 验证解为 $(18,20)$；③ 做一次策略改进并判断最优性；④ 把 $\gamma$ 改成 0.5，说明 $s_1$ 处的动作排序发生了什么。（依据：[例 5.2.2](sec52.md#ex-5.2.2)、[定理 5.2.1](sec52.md#thm-5.2.1)、[命题 5.2.1](sec52.md#prop-5.2.1)）

::: sol 提示与答案
**① 矩阵形式。** $\pi$ 固定后 $P^\pi$ 与 $\boldsymbol r^\pi$ 都是确定的（每步没有随机分支）：
$$P^\pi=\begin{pmatrix}0&1\\0&1\end{pmatrix},\qquad \boldsymbol r^\pi=\begin{pmatrix}0\\2\end{pmatrix},\qquad
I-\gamma P^\pi=\begin{pmatrix}1&-0.9\\0&0.1\end{pmatrix}.$$
$2\times2$ 求逆：$\det=0.1$，故
$$(I-\gamma P^\pi)^{-1}=\frac{1}{0.1}\begin{pmatrix}0.1&0.9\\0&1\end{pmatrix}=\begin{pmatrix}1&9\\0&10\end{pmatrix}.$$
**② 解。** $\boldsymbol v^\pi=(I-\gamma P^\pi)^{-1}\boldsymbol r^\pi=\begin{pmatrix}1&9\\0&10\end{pmatrix}\begin{pmatrix}0\\2\end{pmatrix}=\begin{pmatrix}18\\20\end{pmatrix}$ ✓，与「原地刷 2、永久持续 ⇒ $2/(1-\gamma)=20$」一致。

**③ 策略改进。** 用 $Q^\pi(s,a)=r(s,a)+\gamma V^\pi(s')$：$Q^\pi(s_1,\mathrm L)=1+0.9\times18=17.2$、$Q^\pi(s_1,\mathrm R)=0+0.9\times20=18$；$Q^\pi(s_2,\mathrm L)=0+0.9\times18=16.2$、$Q^\pi(s_2,\mathrm R)=2+0.9\times20=20$。两处的贪心动作都是 $\mathrm R$，与 $\pi$ 相同 ⇒ **$\pi$ 已最优**，$V^\ast=(18,20)$；再代回最优方程自检：$V^\ast(s_1)=\max\{17.2,18\}=18$ ✓、$V^\ast(s_2)=\max\{16.2,20\}=20$ ✓。

**④ $\gamma=0.5$。** $V(s_2)=2/(1-0.5)=4$、$V(s_1)=0+0.5\times4=2$，于是 $Q(s_1,\mathrm L)=1+0.5\times2=2.0$、$Q(s_1,\mathrm R)=0+0.5\times4=2.0$——**两个动作打平**（$\gamma=0.9$ 时 $\mathrm R$ 严格占优 0.8）。结论：$\gamma$ 不只是数值技巧，它**决定动作的排序**；调大 $\gamma$ 会让长期布局压过即时收益，但同时把信用分配的跨度拉长、训练更难。
:::

## C 组 · 编程实现（6 题） {#sec-C}

> 公约：只用 `torch`（+ 标准库），**环境一律自包含**，不依赖环境库，避免版本差异。每题给出**可运行的验收标准**，跑不过不算完成。代码块为关键片段，直接拼进同一个文件即可运行。

**C1. 网格世界 MDP：手算解 vs 值迭代**
实现 [5.2 的 4×4 网格世界](sec52.md)（每步 −1，进入右上/右下目标格额外 +10，$\gamma=0.9$），用上一题的压缩性做值迭代求 $V^\ast$ 与贪心策略；再写一个**穷举策略**的版本，用 $(I-\gamma P^\pi)^{-1}\boldsymbol r^\pi$ 直接解出任意给定策略的 $V^\pi$（状态 16 个，矩阵求逆完全可行），随机抽 20 个策略对比两种算法的一致性。
- **验收标准**：① 值迭代的收敛轮数落在 **100–250** 之间（$\gamma=0.9$、$\varepsilon=10^{-6}$ 的理论量级 $\approx174$）；② 起点 $(0,0)$ 的最优值 $V^\ast(0,0)\lt0$（每步 −1、约 3 步到目标）且 $\ge-3$；③ 非目标格的最优动作构成**朝向目标的流场**（无原地打转、无互相指向的死循环），把它打印成箭头矩阵目测 + 断言每个状态的贪心动作的 $Q$ 值严格大于次优动作；④ 对 20 个随机策略，值迭代给出的 $V^\ast$ 与闭式解的差满足 $V^\ast(s)\ge V^\pi(s)$ **对所有 $s,\pi$ 成立**，且在被抽到的策略里至少有一个严格劣于 $V^\ast$。
::: sol 参考实现
```python
import torch

N, GAMMA, EPS = 4, 0.9, 1e-6
MOVE = [(-1, 0), (0, 1), (1, 0), (0, -1)]
STATES = [(i, j) for i in range(N) for j in range(N)]
IDX = {s: k for k, s in enumerate(STATES)}
GOALS = {(0, 3): 10.0, (3, 3): 10.0}
G = [IDX[s] for s in GOALS]

def env_step(s, a):
    i, j = s
    di, dj = MOVE[a]
    s2 = (min(max(i + di, 0), N - 1), min(max(j + dj, 0), N - 1))
    return s2, -1.0 + GOALS.get(s2, 0.0)

# 表格化环境：S2[k, a] 转移目标、R[k, a] 即时奖励（真实问题里这一步拿不到）
S2, R = torch.zeros(len(STATES), 4, dtype=torch.long), torch.zeros(len(STATES), 4)
for k, s in enumerate(STATES):
    if s in GOALS:
        S2[k] = k                        # 终止状态：自环、零奖励
        continue
    for a in range(4):
        s2, r = env_step(s, a)
        S2[k, a], R[k, a] = IDX[s2], r

V = torch.zeros(len(STATES))             # 值迭代：一轮 = max over a of [r + γV(s')]
for it in range(1, 20001):
    V_new = (R + GAMMA * V[S2]).max(dim=1).values
    V_new[G] = 0.0                       # 终止状态的值钉住为 0
    if (V_new - V).abs().max().item() < EPS:
        V = V_new; break
    V = V_new
Q = R + GAMMA * V[S2]                    # 收敛后顺手得到 Q*
assert 100 <= it <= 250 and -3.0 <= V[IDX[(0, 0)]] < 0

def policy_value(pi):                    # 闭式解：v^π = (I − γP^π)^{-1} r^π
    n = len(STATES)
    Pm, rm = torch.zeros(n, n), torch.zeros(n)
    for k, s in enumerate(STATES):
        if s in GOALS:
            Pm[k, k] = 1.0; rm[k] = 0.0; continue        # 终止状态 v≡0，不参与自举
        Pm[k, S2[k, pi[k]]] = 1.0
        rm[k] = R[k, pi[k]]
    return torch.linalg.solve(torch.eye(n) - GAMMA * Pm, rm)

for _ in range(20):                      # 随机策略：最优值必须处处不劣
    Vpi = policy_value(torch.randint(0, 4, (len(STATES),)))
    assert (V - Vpi >= -1e-6).all()
ARROW = "↑→↓←"
for i in range(N):
    print("  " + " ".join("G" if (i, j) in GOALS else ARROW[int(Q[IDX[(i, j)]].argmax())]
                          for j in range(N)))
```
:::

**C2. $\varepsilon$-greedy 的探索税：常数 vs 衰减**
复现 [5.1.7](sec51.md) 的 10 臂老虎机（$K=10$、1000 步、200 次独立实验、奖励 = 真实均值 + $0.5$ 噪声），对比「常数 $\varepsilon=0.1$」与「$1.0\to0.01$ 线性衰减」；再补一组「乐观初始化 $\varepsilon=0$」做对照。
- **验收标准**：① 两条曲线的「最优动作占比」末段都显著高于随机的 10%；② 衰减策略的**末 100 步平均奖励 > 常数 $\varepsilon=0.1$**，且差距量级与探索税公式 $\varepsilon(\mu^\ast-\bar\mu)$ 相容（用本轮 $\mu$ 记下来核对，不要求精确相等）；③ 把「$\varepsilon=0$ 且估计初值为 0」的曲线附上，它应**卡在次优**（最优动作占比明显更低）——这是「不探索会困住」的直接证据；④ 三种设置在**不同随机种子**下结论方向一致（至少 3 个种子）。
::: sol 参考实现
```python
import torch
torch.manual_seed(0)
K, STEPS, RUNS = 10, 1000, 200

def run(eps_start, eps_end=None, decay_steps=None, optimistic=0.0):
    rewards, best = torch.zeros(STEPS), torch.zeros(STEPS)
    for _ in range(RUNS):
        mu = torch.randn(K) + 1.0                 # 真实均值（未知）
        Q, Ncnt = torch.full((K,), optimistic), torch.zeros(K)   # 乐观初始化 = 给未拉过的臂高预期
        for t in range(STEPS):
            eps = eps_start if eps_end is None else eps_start + min(1.0, t / decay_steps) * (eps_end - eps_start)
            a = int(torch.randint(K, (1,))) if torch.rand(1).item() < eps else int(Q.argmax())
            r = mu[a] + 0.5 * torch.randn(1).item()   # 噪声让「估计」与「真值」分离，才出现选择税
            Ncnt[a] += 1
            Q[a] += (r - Q[a]) / Ncnt[a]              # 样本平均 = α = 1/N
            rewards[t] += r; best[t] += float(a == int(mu.argmax()))
    return rewards / RUNS, best / RUNS

const_r, const_b = run(0.1)                        # 常数 ε
decay_r, decay_b = run(1.0, 0.01, 500)             # 衰减：先买信息、后收收益
for name, r_, b_ in [("常数 0.1", const_r, const_b), ("衰减 1.0→0.01", decay_r, decay_b)]:
    print(f"{name:>14}: 末 100 步奖励 {r_[-100:].mean():.3f}，最优臂占比 {100*b_[-100:].mean():.1f}%")
assert decay_r[-100:].mean() > const_r[-100:].mean()               # 验收 ②
assert const_b[-100:].mean() > 0.1 and decay_b[-100:].mean() > 0.1  # 验收 ①（明显优于随机的 10%）
```
:::

**C3. DQN：回放池 + 目标网络 + `done` 掩码**
用纯 `torch` 实现 [5.7.1](sec57.md) 的 GridWorld（起点随机、目标右上、每步 −0.01、到达 +1、50 步截断）与 [5.7.2](sec57.md) 的 DQN 循环。在此之上做两件事：① 打开/关闭目标网络（`target_every=200` vs `1`）各跑 3 个种子；② 监控**平均 TD 误差**与**评估回报**两条曲线。
- **验收标准**：① 训练后**评估回报**（确定性策略、50 局、独立种子）在 3 个种子里均值 $\ge0.80$（最优约 0.94，因为最多 6 步 ×−0.01）；② 3 个种子的评估回报极差 $<0.3$（稳定性）；③ 贪心策略在**绝大多数状态**上指向最优动作（用 [C1](#sec-C) 的值迭代解算出的 $Q^\ast$ 比对，一致率 $\ge90\%$）；④ **平均 TD 误差曲线**在训练后期下降并趋于平稳（前后 20% 段的均值下降幅度 $\ge30\%$，且末段无单调发散）；⑤ 关掉目标网络（每步同步）后，报告 ③ 的一致性**明显下降**或出现 Q 值膨胀——这条是「目标网络治什么病」的实验证据，允许该项失败但必须在报告里写清现象。
::: sol 参考实现
```python
import random, torch, torch.nn as nn, torch.nn.functional as F

class GridWorld:
    N, N_ACT, GOAL = 4, 4, (0, 3)
    MOVE = [(-1, 0), (0, 1), (1, 0), (0, -1)]
    def reset(self, rng):
        while True:
            s = (rng.randrange(self.N), rng.randrange(self.N))
            if s != self.GOAL: return s
    def step(self, s, a):
        di, dj = self.MOVE[a]
        s2 = (min(max(s[0] + di, 0), self.N - 1), min(max(s[1] + dj, 0), self.N - 1))
        done = (s2 == self.GOAL)
        return s2, (1.0 if done else -0.01), done

def obs(s, n=4):
    x = torch.zeros(n * n); x[s[0] * n + s[1]] = 1.0; return x      # 状态表示直接决定学习速度

class QNet(nn.Module):
    def __init__(self, n_in=16, n_act=4, h=64):
        super().__init__()
        self.net = nn.Sequential(nn.Linear(n_in, h), nn.ReLU(), nn.Linear(h, h), nn.ReLU(), nn.Linear(h, n_act))
    def forward(self, x): return self.net(x)

def train_dqn(seed, episodes=400, batch=64, gamma=0.99, lr=1e-3,
              capacity=20000, target_every=200, min_buffer=500):
    torch.manual_seed(seed); rng = random.Random(seed)
    env, online, target = GridWorld(), QNet(), QNet()
    target.load_state_dict(online.state_dict())          # 先同步一次，否则目标网络是纯噪声
    opt, buf, td_hist, steps = torch.optim.Adam(online.parameters(), lr=lr), [], [], 0
    decay = episodes // 3
    for ep in range(episodes):
        eps = max(0.05, 1.0 - 0.95 * min(1.0, ep / decay))            # ε: 1.0 → 0.05 线性衰减
        s, done, t = env.reset(rng), False, 0
        while not done and t < 50:
            a = rng.randrange(env.N_ACT) if rng.random() < eps else int(online(obs(s)).argmax().item())
            s2, r, done = env.step(s, a)
            buf.append((obs(s), a, r, obs(s2), float(done)))
            if len(buf) > capacity: buf.pop(0)                        # FIFO 防内存膨胀
            if len(buf) >= min_buffer:
                b = [buf[rng.randrange(len(buf))] for _ in range(batch)]   # 随机采样打破时序相关
                s_b, a_b = torch.stack([x[0] for x in b]), torch.tensor([x[1] for x in b])
                r_b, s2_b, d_b = torch.tensor([x[2] for x in b]), torch.stack([x[3] for x in b]), torch.tensor([x[4] for x in b])
                with torch.no_grad():
                    y = r_b + gamma * (1.0 - d_b) * target(s2_b).max(dim=1).values   # done 掩码乘自举项
                q_sa = online(s_b).gather(1, a_b[:, None]).squeeze(1)              # 只取被选动作的 Q
                loss = F.smooth_l1_loss(q_sa, y)
                opt.zero_grad(); loss.backward()
                nn.utils.clip_grad_norm_(online.parameters(), 10.0); opt.step()
                steps += 1; td_hist.append(loss.item())
                if steps % target_every == 0:      # target_every=1 等价于「没有目标网络」
                    target.load_state_dict(online.state_dict())
            s, t = s2, t + 1
    return td_hist, online

def evaluate(qnet, runs=50, seed=1000):                      # 独立评估：不探索、不写回放池
    env, rng, rets = GridWorld(), random.Random(seed), []
    for _ in range(runs):
        s, done, t, ep_r = env.reset(rng), False, 0, 0.0
        while not done and t < 50:
            with torch.no_grad(): a = int(qnet(obs(s)).argmax().item())
            s, r, done = env.step(s, a); ep_r, t = ep_r + r, t + 1
        rets.append(ep_r)
    return torch.tensor(rets)

for sd in range(3):                                          # 验收 ①④：回报 + TD 误差趋势
    td, qn = train_dqn(sd)
    n5 = len(td) // 5
    print(f"seed {sd}: 评估回报 {evaluate(qn).mean():.3f} | TD 误差 {sum(td[:n5])/n5:.4f} → {sum(td[-n5:])/n5:.4f}")
    assert evaluate(qn).mean() >= 0.80 and sum(td[-n5:]) / n5 <= 0.7 * sum(td[:n5]) / n5
```
:::

**C4. GAE 实现与「偏差—方差」对比**
在 [C1](#sec-C) 的网格世界上固定一个**随机策略**（不训练），采样 200 条轨迹；对每条轨迹用同一个（质量普通的）Critic $V_\phi$ 计算：① 蒙特卡洛优势 $G_t-V(s_t)$；② 一步 TD 优势 $\delta_t$；③ GAE($\lambda$)，$\lambda\in\{0,0.5,0.9,0.95,1.0\}$。对每个 $\lambda$ 汇总 200 条轨迹的 $\hat A_t$ 估计。
- **验收标准**：① 实现在 $t$ 维上向量化，且对随机 `dones` 的用例与「从后往前递归」的朴素实现在 **$10^{-6}$** 内一致；② 对同一固定策略，$\lambda$ 增大时**样本方差的均值单调不减**（$\mathrm{Var}_{\text{across runs}}$ 至少对 $\lambda=0\to1$ 呈上升），且 $\lambda=1$ 的方差显著大于 $\lambda=0$（$\ge2\times$）；③ 用「真实优势」的近似参照（把同一批数据反复采样得到的均值当参照）说明 $\lambda=0$ 的**偏差**更大：$\bigl|\mathbb E[\hat A^{(\lambda=0)}]-A_{\text{ref}}\bigr| > \bigl|\mathbb E[\hat A^{(\lambda=1)}]-A_{\text{ref}}\bigr|$；④ 打印一张 $\lambda$ → (均值, 方差, 与参照的差) 的表，并用它解释「为什么 PPO 默认 $\lambda\approx0.95$」。
::: sol 参考实现
```python
import torch

def compute_gae(r, v, d, last_v, gamma=0.99, lam=0.95):
    """Â_t = δ_t + γλÂ_{t+1}；从后往前；d=1 的位置不再自举。"""
    T = len(r); adv = torch.zeros(T + 1)                      # 末端后继优势为 0
    for t in reversed(range(T)):
        nv = last_v if t == T - 1 else v[t + 1]
        nt = 1.0 - d[t]
        adv[t] = (r[t] + gamma * nv * nt - v[t]) + gamma * lam * nt * adv[t + 1]
    return adv[:T], (adv[:T] + v).detach()                    # returns = Â + V（批内常数，须 detach）

def gae_naive(r, v, d, last_v, gamma=0.99, lam=0.95):         # 教学版：直接按 Σ(γλ)^l δ_{t+l} 展开
    T = len(r)
    deltas = [r[t] + gamma * (last_v if t == T - 1 else v[t + 1]) * (1 - d[t]) - v[t] for t in range(T)]
    out = torch.zeros(T)
    for t in range(T):
        acc, w = 0.0, 1.0
        for l in range(T - t):
            acc += w * deltas[t + l]
            if d[t + l]: break                                # 回合结束：后面的残差不带进来
            w *= gamma * lam
        out[t] = acc
    return out

torch.manual_seed(0)                                          # 对拍：随机 dones 的用例必须一致
R, Vv, D = torch.randn(37), torch.randn(37), (torch.rand(37) < 0.1).float()
a1, _ = compute_gae(R, Vv, D, torch.randn(()), lam=0.95)
assert (a1 - gae_naive(R, Vv, D, torch.randn(()), lam=0.95)).abs().max().item() < 1e-6
```
:::

**C5. PPO 在 CartPole 上的多种子验收（S5.2 的落点）**
实现 [5.7.3](sec57.md) 的 PPO 循环并接到 **CartPole**（若环境不可用，就用 [5.7.1](sec57.md) 的 GridWorld，把阈值改成第 ① 条括号里的值）。要求：至少 5 个训练种子，每个种子的评估用**独立种子集合、确定性策略、100 局**，记录每局回报；报告均值、样本标准差与 95% 置信区间（$t_{0.975,4}=2.776$）。
- **验收标准**：① **多种子平均评估回报 $\ge475$**（CartPole-v1 上限 500；用 GridWorld 时改为「平均回报 $\ge0.90$」，上限约 0.94）；② 至少 **80% 的种子**单独超过 450（GridWorld：0.85）；③ 训练时必须打印 `approx_kl`（$10^{-3}\sim10^{-2}$）与 `clip_frac`（5%–20%）的诊断量，并把两端各 10% 的更新段做对比，证明两者没有跑飞；④ 报告要给出**每个种子的回报**（不是只给均值），并画「各种子淡线 + 中位数粗线」；⑤ 用同一套评估协议对比「不做优势归一化」的版本，报告差值与置信区间——若区间重叠就如实写「本次实验无法分辨」。
::: sol 参考实现
```python
import torch, torch.nn as nn, torch.nn.functional as F
# PolicyNet 与 GAE（含 compute_gae 的向量化实现）直接复用 C3、C4 的代码，这里只给 PPO 部分。

def train_ppo(seed, make_env, obs_of, updates=150, rollout=2048, epochs=4, mini=256,
              eps_clip=0.2, lr=3e-4, normalize_adv=True, gamma=0.99):
    torch.manual_seed(seed)
    env = make_env(seed); policy = PolicyNet(obs_of(env.reset()).numel(), env.action_space.n)
    opt, diag = torch.optim.Adam(policy.parameters(), lr=lr), []
    for _ in range(updates):
        S, A, R, LP, D, V, s = [], [], [], [], [], [], env.reset()
        for _ in range(rollout):                                  # ① 采样一批 rollout
            with torch.no_grad():
                logits, v = policy(obs_of(s))
                dist = torch.distributions.Categorical(logits=logits); a = dist.sample()
            s2, r, term, trunc, _ = env.step(int(a))
            done = term or trunc                                  # 记录时二者要能区分（见 5.7.1）
            S.append(obs_of(s)); A.append(int(a)); R.append(r)
            LP.append(dist.log_prob(a).item()); D.append(float(done)); V.append(float(v))
            s = env.reset() if done else s2
        S, A = torch.stack(S), torch.tensor(A); R, LP = torch.tensor(R), torch.tensor(LP)
        D, V = torch.tensor(D), torch.tensor(V)
        adv, ret = gae(R, V, D, gamma)                            # ② GAE（C4 的实现）
        if normalize_adv:                                         # ③ 优势归一化
            adv = (adv - adv.mean()) / (adv.std() + 1e-8)
        for _ in range(epochs):                                   # ④ 同一批数据跑几个 epoch
            perm = torch.randperm(len(S))
            for k in range(0, len(S), mini):
                idx = perm[k:k + mini]
                logits, v = policy(S[idx]); dist = torch.distributions.Categorical(logits=logits)
                logp = dist.log_prob(A[idx])
                ratio = torch.exp(logp - LP[idx])                 # ρ = π_θ / π_θold
                clip_r = torch.clamp(ratio, 1 - eps_clip, 1 + eps_clip)
                pi_loss = -torch.min(ratio * adv[idx], clip_r * adv[idx]).mean()
                loss = pi_loss + 0.5 * F.mse_loss(v, ret[idx]) - 0.01 * dist.entropy().mean()
                opt.zero_grad(); loss.backward()
                nn.utils.clip_grad_norm_(policy.parameters(), 0.5); opt.step()
                with torch.no_grad():                             # ⑤ 诊断量：KL 与裁剪比例
                    diag.append((((ratio - 1) - (logp - LP[idx])).mean().item(),
                                 ((ratio - 1).abs() > eps_clip).float().mean().item()))
    return policy, diag

def evaluate(policy, make_env, obs_of, runs=100, seed=1000):      # 独立评估、确定性动作
    env, rets = make_env(seed), []
    for _ in range(runs):
        s, done, ep_r = env.reset(), False, 0.0
        while not done:
            with torch.no_grad(): a = int(policy(obs_of(s))[0].argmax().item())
            s, r, term, trunc, _ = env.step(a); done = term or trunc; ep_r += r
        rets.append(ep_r)
    return torch.tensor(rets)

def multi_seed(seeds=range(5)):
    per = []
    for sd in seeds:
        pol, _ = train_ppo(sd, make_env, obs_of)
        per.append(evaluate(pol, make_env, obs_of, seed=1000 + sd).mean().item())
    t = torch.tensor(per)
    se = t.std(unbiased=True) / len(t) ** 0.5
    return t, t.mean().item(), (t.mean() - 2.776 * se, t.mean() + 2.776 * se)

# 需自备 make_env / obs_of（CartPole 走 Gymnasium；或换成 5.7.1 的 GridWorld）：
# per, mean, ci = multi_seed(); assert mean >= 475 and (per >= 450).float().mean() >= 0.8
```
:::

**C6. DPO 损失与梯度：复现正文数值**
实现 `dpo_loss`，并构造一组**受控输入**复现 [例 5.6.1](sec56.md#ex-5.6.1) 的数值：$\beta=0.1$、$\Delta_w=-1.0$、$\Delta_l=-2.0$。要求：① 打印损失并与 **0.644** 对齐；② 用自动微分给出 $\partial\mathcal L/\partial\Delta_w$ 与 $\partial\mathcal L/\partial\Delta_l$，与 **$-0.0475$ / $+0.0475$** 对齐；③ 再做一次「两者都被压低」的对照（$\Delta_w=-4.0,\Delta_l=-6.0$），说明为什么损失反而更小（$\approx0.598$）；④ 用真实 logits 的玩具模型端到端跑一遍，确认 `ref` 侧不参与反传。
- **验收标准**：① 损失与理论值相对误差 $<10^{-4}$；② 两个梯度分量的符号与绝对值都对齐到 $10^{-4}$；③ 对照组损失的数值与推理一致（$\approx0.598$），并在报告里写清「DPO 只约束相对差距 ⇒ 绝对似然可能坍塌」；④ 把 `ref_logp` 误设为可训练参数并重跑，loss 与梯度应**发生变化**（`ref` 必须冻结）——该项用于证明你理解参考模型冻结的前提；⑤ $\beta\to0.01$ 时 margin $z$ 变小、$\beta\to1$ 时 $z$ 变大，且当 $z$ 已经很大时梯度趋近 0（sigmoid 饱和），三条都要有打印证据。
::: sol 参考实现
```python
import torch, torch.nn.functional as F

def dpo_loss(logp_w, logp_l, ref_logp_w, ref_logp_l, beta=0.1):
    """L = −log σ(βΔ_w − βΔ_l)，Δ = log(π_θ/π_ref)。只关心「相对差距」。"""
    delta_w = logp_w - ref_logp_w
    delta_l = logp_l - ref_logp_l
    z = beta * (delta_w - delta_l)
    loss = -F.logsigmoid(z).mean()
    with torch.no_grad():
        margin, pref_acc = z.mean().item(), (z > 0).float().mean().item()
    return loss, margin, pref_acc

# ① 复现例 5.6.1：理论 z=0.1 ⇒ loss = −log σ(0.1) ≈ 0.644
dw, dl = torch.tensor([-1.0], requires_grad=True), torch.tensor([-2.0], requires_grad=True)
loss, margin, acc = dpo_loss(dw, dl, torch.zeros(1), torch.zeros(1), beta=0.1)
loss.backward()
print(f"loss={loss.item():.4f}（理论 0.644）| dL/dΔw={dw.grad.item():.4f} dL/dΔl={dl.grad.item():.4f}")
assert abs(loss.item() - 0.6444) < 1e-4
assert abs(dw.grad.item() + 0.0475) < 1e-4 and abs(dl.grad.item() - 0.0475) < 1e-4

# ② 对照组：两者都被压低，但相对差距变大 ⇒ 损失更小（≈0.598）
loss2, _, _ = dpo_loss(torch.tensor([-4.0]), torch.tensor([-6.0]), torch.zeros(1), torch.zeros(1))
print(f"对照组 loss={loss2.item():.4f}（≈0.598）")            # 绝对似然坍塌的风险在这里

# ③ β 与饱和：z 很大时梯度趋近 0（σ 饱和）；β 控制偏离参考多远
for beta in (0.01, 0.1, 1.0):
    l, m, _ = dpo_loss(torch.tensor([-1.0], requires_grad=True), torch.tensor([-2.0], requires_grad=True),
                       torch.zeros(1), torch.zeros(1), beta=beta)
    print(f"beta={beta}: z={m:+.4f} loss={l.item():.4f}")
```
:::

## D 组 · 开放设计（4 题）

> 每题给一个真实场景与约束，要求写出**方案 + 理由 + 失败判据 + 验证计划**四项（缺一项扣分）。判据必须**可测量**，不接受「效果不好就调」这类表述。

**D1. 奖励设计防 hack：让「送货更快」不被绕圈刷分**
场景：用 RL 训练仓库搬运机器人，业务指标是「单位时间完成的订单数」；工程上容易写出「靠近托盘 +1、靠近货架 +1、送达 +10」这类塑形奖励。请给出：① 奖励构成与**每一项的理由**（哪些是代理、哪些接近真目标）；② 至少三个**可测量的被 hack 信号**（如单局总位移/订单数之比、空闲动作占比、路径重复率）；③ 处理措施及其代价；④ 验证计划（独立验收 + 多种子 + 行为审计）。
::: sol 参考方案与评分要点
**方案**：主奖励用**结果型**——每完成一个订单 +1（可自动验证），以「单位时间订单数」为业务指标；塑形只保留两项**物理合理**的项：碰撞/超速惩罚（安全，非代理）与电位差形式的**势函数塑形** $\phi(s')-\phi(s)$（不改变最优策略）；**不给**「靠近托盘」这类只与真目标相关的中间量。**理由**：奖励是**代理**而非目标本身；塑形一旦与目标不一致，策略就会去优化那个函数——这就是 reward hacking 的一般机制（[5.6.8](sec56.md)），且优化强度越大偏差越大（Gao 等 2023 的「先升后降」曲线）。

**被 hack 信号**：① 单位订单的**位移或耗时**上升而订单数不升（绕圈刷分/[5.6.8](sec56.md) 的赛艇案例）；② **空闲/徘徊动作占比**升高；③ **路径重复率**骤升或轨迹熵骤降；④ 训练奖励上升而**独立评估**不升——见 [5.7.4](sec57.md#method-5.7.4) 的 ① 号失败模式。

**措施与代价**：回滚到 KL 较小的 checkpoint、以「先升后降」的拐点为停手点；调大 KL 系数或用早停；奖励集成（多个判分器取最小）缓解单点盲区，代价是成本 × 判分器数；迭代补数据覆盖被利用区域。保守化的代价是**上限被压低**（[5.6.2 的 think](sec56.md)）。

**验证计划**：保留**独立人评/基准**（不与训练奖励同源）并定期评估（[方法 5.6.4](sec56.md#method-5.6.4) 第 1 条）；评估多种子 + 多回合 + 报分布（[方法 5.7.5](sec57.md#method-5.7.5)）；每周抽样轨迹做行为审计。**评分**：奖励构成与理由 4 分（须区分代理/真目标）；三个可测量信号 3 分；措施与代价 2 分；验证计划 1 分。
:::

**D2. 离线 RL 方案：只有历史日志、不许在线试错**
场景：6 个月的人工调度日志（若干条 $(s,a,r,s')$，质量参差），单卡算力，**上线前不允许在线试错**，决策延迟需 < 100 ms。请给出：① 「值不值得做」的前置判断；② 在 CQL 类 / IQL 类 / TD3+BC 类 / 序列建模类中选一条路线及理由；③ 离线评估怎么做（不能只看训练损失）；④ 失败判据与上线流程。
::: sol 参考方案与评分要点
**① 前置判断**：第一问不是「用哪个算法」，而是**数据里有没有「好决策」的足够证据**（[5.6.2 的 think](sec56.md)）。日志全部来自差策略 ⇒ 上限就是那个策略的水平，此时该改数据收集流程（加人工演示 / 少量在线探索），而不是换算法。可先统计行为策略的**动作多样性**与「近似最优动作在数据中的出现率」。

**② 路线**：优先 **IQL 类（隐式约束）**——它**不查询数据外的动作**（把 $\max_aQ(s,a)$ 换成上分位 / expectile 回归），从而避免 $\max$ 主动挑选被高估的数据外动作这一恶性循环；而离线场景里任何外推误差都会被 $1/(1-\gamma)$ 放大（$\gamma=0.99$ ⇒ 100 倍，[定理 5.6.1](sec56.md#thm-5.6.1)）。CQL 可行但要多调保守强度 $\alpha$（过强则过度保守）；TD3+BC 最简单但上界被行为策略钉死；序列建模不做动态规划，长视界与随机环境下受限（[5.6.2 的路线表](sec56.md#method-5.6.1)）。延迟由网络前向决定，与算法选择基本无关。

**③ 离线评估**：不能用 TD 损失选策略（损失小 ≠ 策略好）。固定一组留出日志片段做相对比较（粗略的 off-policy evaluation，结论只能是「没变差」）；真正验收放到**影子模式**：只记录建议、不执行，与人工作对照（[选型判据第 5 问](sec51.md#method-5.1.2)），并报分布而非单点。

**④ 失败判据与上线流程**：① 训练期 $Q$ 值整体虚高 ⇒ 加强保守化或换回 IQL；② 选出的动作大量落在**数据支撑集外**（用日志动作频次做代理统计）⇒ 停止上线；③ 影子模式下与人工一致率低且业务指标更差 ⇒ 回退到「建议 + 人工确认」；④ 逐步放量（先 1% 流量）+ 可回滚 + 行为偏移监控。**评分**：前置判断 3 分；路线与理由（须提到外推与放大因子）3 分；评估协议 2 分；失败判据与上线流程 2 分。
:::

**D3. 偏好数据构造：在 RLHF 与 DPO 之间选一条并设计数据管线**
场景：约 3 万条待对齐 prompt，预算只够 8000 对偏好标注，主力模型 7B、两张卡；目标是把 SFT 的「有用性」提升到可交付水平并保持格式稳定。请给出：① 选 RLHF 还是 DPO 家族及判据（上界 / 成本 / 可复现性 / 失败模式）；② 标注管线（候选生成、成对 vs 绝对评分、指南、质控）；③ 三类系统性偏差的对冲；④ 失败判据与独立评估。
::: sol 参考方案与评分要点
**① 选择**：按「先问奖励从哪来」（[方法 5.6.6](sec56.md#method-5.6.6)）：偏好来自人比较 ⇒ 二选一。**本次选 DPO 家族**：8000 对数据 + 两张卡 + 要可复现，正好命中其优势（无奖励模型、无在线采样、训练像 SFT）；代价是**上界通常低于 RLHF**，且对**标注噪声没有缓冲**——噪声直接进策略梯度。若后续要冲更高上限，可把 DPO 当预热再升级到 RLHF，并复用同一批偏好数据；7B 两张卡下注意策略 + 参考的显存，必要时 LoRA / 卸载。

**② 管线**：① 候选生成调温度保证**多样性**（太相似 ⇒ 偏好对难判、信息量低）；② **成对比较优于绝对打分**（绝对分尺度不一致，成对一致率更高——这也是 Bradley–Terry 只需成对数据的原因，[定义 5.6.2](sec56.md#def-5.6.2)）；③ rubric 写成**可判定条目**（什么算更有帮助 / 事实错误、安全项优先级）；④ 质控：混入 gold 样本、统计标注者一致性（Cohen's κ / Krippendorff's α；**阈值属社区惯例、无权威下限，需核实**）、分歧样本多标投票（[方法 5.6.5](sec56.md#method-5.6.5)）。

**③ 偏差对冲**：**长度**（展示时长度匹配；损失侧可用 SimPO 的长度归一化；评估按长度分桶）、**位置**（左右随机交换、两方向都过一遍）、**风格**（指南声明格式不加分；评估做格式剥离对照）。RLAIF 可降人工量，代价是把「标注者偏见」换成「成文原则 + 模型偏好」。

**④ 失败判据与评估**：① `pref_acc` 上升但 `margin` 爆炸 ⇒ $\beta$ 或学习率太大；② $\Delta_w$ 与 $\Delta_l$ **同时**大幅下降 ⇒ 绝对似然坍塌（[5.6.11](sec56.md)），需降学习率 / 缩短训练 / 加 SFT 项（ORPO 做法）；③ 长度膨胀或风格套路化 ⇒ 偏差未对冲；④ **偏好对准确率上升不等于模型变好**——必须看真实生成结果（人评 + 通用能力回归 + 格式稳定性），并保持评估独立。**评分**：选择与判据 3 分；管线 3 分；偏差对冲 2 分；失败判据 + 独立评估 2 分。
:::

**D4. 评估协议：怎样让别人相信「B 比 A 好 5 分」**
场景：两版 PPO 只差一处超参，同事报告「我的平均回报高 5 分，所以更好」。请设计评估协议，满足：① 任何比较都不得用「最好种子」或单条曲线；② 给出从「5 个种子」到「分辨这个量级需要多少种子」的定量估算；③ 说明「评估噪声大于训练种子噪声」时优先做什么；④ 至少三条会让结论失效的隐性坑。
::: sol 参考方案与评分要点
**① 协议骨架**（对齐 [方法 5.7.5](sec57.md#method-5.7.5)）：固定一组**与训练不同**的评估种子；评估用**确定性策略**（DQN 取 $\arg\max$；PPO 用均值或多次采样平均并注明）；每种子 50–100 局、记录**每局回报**；报**分布**（均值 ± 标准差、中位数与四分位距、最好 / 最差）；跨训练种子 ≥5（最好 10）并对「各种子的回合平均」再算均值与 95% 置信区间；画图用**各种子淡线 + 中位数粗线**。

**② 定量估算**（复现 [例 5.7.1](sec57.md#ex-5.7.1)）：单组 $s\approx23$、$n=5$ ⇒ 95% 区间约 $\pm28$，5 分的差值被区间宽度完全淹没。用「两倍标准误」粗估：$n\approx\left(\frac{2.8\times23}{5.4}\right)^2\approx142$ 个种子——**算力上通常不现实**，因此结论应是「现有预算下无法分辨，不能据此宣称改进」。

**③ 先降方差**：当评估噪声（同一策略跨评估回合的波动）大于训练种子噪声时，**优先固定评估种子集合、增加评估回合数、固定环境随机性**（[方法 5.7.6](sec57.md#method-5.7.6)），而不是狂堆训练种子；若可做**配对比较**（同一评估种子下的 A−B 差值再检验），方差通常显著低于比两个独立均值。

**④ 隐性坑（≥3）**：① **口径不一致**——训练奖励混有塑形 / 探索收益，评估用确定性策略且口径不同（[5.7 即时自测 Q3](sec57.md)）；② **环境 / 依赖版本不同**（终止与截断的合并方式、`reset/step` 签名差异会系统性改变回报量级）；③ 只报最优种子，或把「最优 checkpoint 平均」当性能；④ 评估时仍在采样探索动作而未说明；⑤ 用同一批评估种子反复调参（评估集被当验证集消耗）。**评分**：协议骨架 3 分；定量估算（须给公式与数字）3 分；先降方差 2 分；隐性坑 ≥3 条每条 1 分（上限 2 分）。
:::
