# 5.6 离线 RL、RLHF 与偏好优化

前面五节都建立在一个奢侈的假设上：**你可以与环境反复交互**——想探索就探索，跑坏了重来。真实世界常常不给这个条件。医疗决策、金融交易、工业控制里，一次错误的尝试可能不可逆；而更常见的情况是：**你连奖励函数都写不出来**。「什么样的回答更好」没法写成一个标量函数，但人可以**比较**两个回答哪个更好。

这一节处理这两个约束，它们恰好是大模型对齐的两块基石：

- **不能交互** → 离线 RL（offline RL / batch RL）：只有一份固定数据集，难点从「探索」变成**分布偏移**（5.6.1–5.6.2）。
- **写不出奖励** → 用**人类偏好**替代奖励：先训一个奖励模型，再用 RL 优化（RLHF，5.6.3–5.6.4）；而 **DPO** 证明那一步「先训奖励模型再跑 RL」可以被数学上等价地折叠成一个**分类损失**（5.6.5）。
- 最后是两条更新的实践线索：**GRPO**（去掉 Critic，用一组答案的相对好坏估优势，推理模型的主力算法，5.6.6–5.6.7）与 **reward hacking**（5.6.8）——后者的机制值得单独讲一节，因为它是所有「用代理指标优化真实目标」的系统的固有代价。5.6.9 处理一个容易被忽视但决定成败的环节：**偏好数据是怎么标注出来的**。

## 5.6.1 离线 RL：连交互都不许有

::: def 定义 5.6.1 · 离线 RL（batch RL） {#def-5.6.1}
给定一份**由某个行为策略 $\pi_\beta$ 产生的固定数据集**
$$\mathcal D=\{(s_i,a_i,r_i,s_i')\}_{i=1}^{N},\qquad (s_i,a_i)\sim d^{\pi_\beta},\ a_i\sim\pi_\beta(\cdot\mid s_i),$$
**不允许与环境进一步交互**（不采样、不试错）。目标是学出一个策略 $\pi_\theta$，使其在真实环境中尽可能好。数据集可能来自专家演示、随机策略、或历史日志，且**质量未知**。
:::

::: intuition 难点从「探索」变成了「外推」
在线 RL 的核心矛盾是探索（[5.1](sec51.md)）；离线 RL 把探索这条选项删掉之后，剩下的核心矛盾变成：**你的策略想去尝试数据集里没出现过的 $(s,a)$，而 $Q$ 对这些点的估值只能靠自举外推**。

外推为什么危险？因为 $\max$ 会**专门挑那些被高估的动作**（[5.3](sec53.md) 的过高估计），而数据外区域的估值噪声最大、最容易被高估。于是「策略越激进 → 越往没有数据的区域钻 → 那里估值虚高 → 策略更激进」形成恶性循环。**这不是数据量的问题**：把数据集扩大十倍也不解决，因为真实决策所需的 $(s,a)$ 总有一部分在支撑集之外。
:::

::: thm 定理 5.6.1 · 误差传播：离线自举的误差放大因子 {#thm-5.6.1}
设在数据集支撑集外，单步自举的误差上界为 $\varepsilon$（即 $\lVert\hat{\mathcal T}V-\mathcal TV\rVert_\infty\le\varepsilon$）。则经过 $k$ 轮值迭代
$$\lVert V_k-V^\ast\rVert_\infty\ \le\ \gamma^{k}\lVert V_0-V^\ast\rVert_\infty+\frac{\varepsilon}{1-\gamma}\ \xrightarrow[k\to\infty]{}\ \frac{\varepsilon}{1-\gamma}.$$
即**单步的外推误差被 $1/(1-\gamma)$ 放大**：$\gamma=0.99$ 时放大 100 倍。
:::

::: proof 证明（三角不等式 + 压缩性的展开）
对单轮迭代用三角不等式，把它拆成「采样误差」与「压缩项」：
$$\lVert V_{k+1}-V^\ast\rVert_\infty=\lVert\hat{\mathcal T}V_k-\mathcal TV^\ast\rVert_\infty
\le\underbrace{\lVert\hat{\mathcal T}V_k-\mathcal TV_k\rVert_\infty}_{\le\varepsilon}
+\underbrace{\lVert\mathcal TV_k-\mathcal TV^\ast\rVert_\infty}_{\le\gamma\lVert V_k-V^\ast\rVert_\infty}
\le\varepsilon+\gamma\lVert V_k-V^\ast\rVert_\infty .$$
对上式反复代入（$k,k-1,\dots,0$）得
$$\lVert V_k-V^\ast\rVert_\infty\le\varepsilon\sum_{j=0}^{k-1}\gamma^{j}+\gamma^{k}\lVert V_0-V^\ast\rVert_\infty
\le\frac{\varepsilon}{1-\gamma}+\gamma^{k}\lVert V_0-V^\ast\rVert_\infty .\ \blacksquare$$
:::

::: intuition 这个界解释了离线 RL 的整个技术路线
它说的是：**只要有任何一处估值误差，它就会被无限期地「播撒」到所有依赖它的状态上，最终稳定在一个被放大 $1/(1-\gamma)$ 倍的偏差上**。在线 RL 里这个偏差能被后续的探索与新数据纠正（数据会覆盖过去那些状态）；离线 RL 里没有新数据，误差永久沉淀。

于是所有离线算法的思路都可以归结为一句话：**在源头上不产生 $\varepsilon$**——要么不去查询数据外动作的值（IQL），要么主动把它们的值压低（CQL）。这也是为什么「离线 RL 完全可以用监督学习式的组件实现」这种说法有道理：它本质上是在做「受数据约束的估计」。
:::

## 5.6.2 保守化：CQL 与 IQL 的两条路

::: method 两条保守化路线：CQL 与 IQL {#method-5.6.1}
**① CQL（Conservative Q-Learning）：主动压低数据外动作的价值。** 在标准 TD 损失之外加一项，让「数据外动作的 Q 值」被压低、「数据集内动作的 Q 值」被抬高。离散动作版本（CQL(H)）的惩罚项为
$$\mathcal L_{\text{CQL}}(\theta)=\alpha\,\mathbb E_{s\sim\mathcal D}\Bigl[\underbrace{\log\sum_a\exp Q_\theta(s,a)}_{\text{数据外动作的“软最大值”}}-\underbrace{\mathbb E_{a\sim\pi_\beta(\cdot\mid s)}Q_\theta(s,a)}_{\text{数据集内动作}}\Bigr]+\tfrac12\,\mathbb E_{\mathcal D}\bigl[(Q_\theta-\hat{\mathcal B}^{\pi}Q_\theta)^2\bigr],$$
其中 $\hat{\mathcal B}^{\pi}$ 是经验贝尔曼算子（只用数据里的 $(s,a,r,s')$ 估计），$\alpha$ 控制保守强度。**思想**：把「数据外动作的估值」压低到不超过数据内动作，从而让 $\arg\max$ 不会跑到支撑集外。

**② IQL（Implicit Q-Learning）：干脆不查询数据外的动作。** 关键观察是：$\max_a Q(s,a)$ 这个操作本身就要查询**所有**动作。IQL 改为学一个**上分位**的价值 $V_\psi$，用 **expectile 回归**拟合约等于最大值的分位数：
$$\mathcal L_V(\psi)=\mathbb E_{(s,a)\sim\mathcal D}\Bigl[\ell^\tau_2\bigl(Q_\theta(s,a)-V_\psi(s)\bigr)\Bigr],\qquad
\ell^\tau_2(u)=\bigl|\tau-\mathbf 1[u\lt0]\bigr|\,u^2,\quad \tau\in(0,1)\ \text{（常用 }0.7\text{–}0.9\bigr),$$
其中 $Q_\theta$ 只用**数据里的动作**做 TD 学习（不做 $\max$）。得到 $V_\psi$ 后，优势为 $A(s,a)=Q_\theta(s,a)-V_\psi(s)$，再用**优势加权回归**（AWR 式）提取策略：
$$\mathcal L_\pi(\theta)=\mathbb E_{\mathcal D}\Bigl[\exp\bigl(A(s,a)/T\bigr)\,\bigl(-\log\pi_\theta(a\mid s)\bigr)\Bigr],$$
$T$ 是温度：优势大的动作被「当作更高的权重去模仿」。

| 路线 | 核心动作 | 改动位置 | 主要代价 |
|:--|:--|:--|:--|
| 保守估计（CQL 类） | 压低数据外 $Q$ | TD 损失 + 惩罚项 | 惩罚过强 ⇒ 过度保守、学不到东西；需调 $\alpha$ |
| 隐式约束（IQL 类） | 不查询数据外动作 | 价值估计改用 expectile | 从不显式提升动作 ⇒ 需要策略提取步骤；离数据太远的动作无法被「发现」 |
| 策略正则（TD3+BC 类） | 在策略损失里加「别偏离行为策略太远」的项 | 策略损失 + $\lambda\cdot\mathrm{BC}$ | 上界被行为策略钉死；$\lambda$ 敏感 |
| 序列建模（Decision Transformer 类） | 把 RL 当作「条件序列预测」（以回报为条件） | 换成 Transformer + 监督损失 | 不做动态规划，长视界与随机环境能力受限 |
:::

::: think 「保守」的代价是什么
保守化能防住外推误差，但它和探索是**冲突的**：越保守，策略越接近行为策略 $\pi_\beta$——**理论上限就是 $\pi_\beta$ 的水平**，再好的算法也无法超越数据里已经出现过的决策质量。这就是离线 RL 的核心权衡：**要么稳（贴近数据、上限低），要么强（敢外推、风险高）**。

判断一个离线 RL 项目是否值得做的第一问不是「用哪个算法」，而是：**数据里有没有包含「好决策」的足够证据**？如果数据全部来自一个很差的日志策略，那只能学到「和差策略一样差」的策略——此时该做的是改数据收集流程（例如加少量在线探索、或人工演示），而不是换算法。
:::

## 5.6.3 RLHF 三步：把偏好变成奖励

::: method RLHF 三步流程 {#method-5.6.2}
1. **得到初始策略**：预训练 + 监督微调（SFT），得到参考模型 $\pi_{\text{ref}}$（通常把 SFT 模型的副本冻结作为参考，用于算 KL）。
2. **收集偏好数据**：对同一个输入 $x$（如一个 prompt），让模型给出两个回答，请人类标注哪个更好，得到成对比较 $y_w\succ y_l$（$w$ 为 preferred，$l$ 为 rejected）。
3. **训练奖励模型** $r_\phi$：用 **Bradley–Terry** 模型把「偏好概率」写成奖励差的 sigmoid（5.6.4），用**交叉熵**（即最大化偏好数据的似然）训练 $r_\phi$：
   $$\mathcal L_{\text{RM}}(\phi)=-\mathbb E_{(x,y_w,y_l)\sim\mathcal D}\bigl[\log\sigma\bigl(r_\phi(x,y_w)-r_\phi(x,y_l)\bigr)\bigr].$$
4. **用 RL 对齐策略**：把 $r_\phi$ 当作环境奖励，用 RL（实践中大多是 PPO）优化语言模型，同时用一个 **KL 惩罚**把它约束在 $\pi_{\text{ref}}$ 附近：
   $$\max_\theta\ \mathbb E_{x,\,y\sim\pi_\theta}\Bigl[r_\phi(x,y)\Bigr]\;-\;\beta\,\mathrm{KL}\bigl(\pi_\theta(\cdot\mid x)\,\Vert\,\pi_{\text{ref}}(\cdot\mid x)\bigr).$$

（把第 1 步视作准备，流程常被称为「三步」：**SFT → 奖励模型 → RL**。）
:::

::: intuition 为什么 RLHF 必须加 KL 惩罚
奖励模型 $r_\phi$ 只是对人类偏好的**代理**，它在训练数据分布外并不可靠。如果只最大化 $r_\phi$，策略会找到奖励模型的**漏洞**：产出人类其实不喜欢的文本，却拿到很高分——这就是「**奖励黑客**」（5.6.8）。KL 项把策略拴在 $\pi_{\text{ref}}$ 附近，等价于限制「探索范围」，既防止跑偏，也保住语言本身的流畅与多样性。

**权衡**：$\beta$ 太大则学不动（几乎等于不训练），太小则会被奖励模型带偏。这就是【定理 5.6.1】那笔账在语言模型上的重演——只不过这里的「$1/(1-\gamma)$ 放大」换成了「奖励模型外推误差随偏离程度的增长」。

**一个关键的工程细节**：RLHF 里的奖励通常是**序列级**的——整段回答结束时给一个标量。这属于 [5.1](sec51.md) 讲过的「延迟且稀疏」极端情形，而 PPO 的价值网络与 GAE 正是为此准备的。
:::

## 5.6.4 Bradley–Terry 偏好模型

要把「人更喜欢哪个」变成可学习的信号，需要假设**偏好背后的生成机制**。

::: def 定义 5.6.2 · Bradley–Terry 偏好模型 {#def-5.6.2}
假设每个回答 $y$（在给定 $x$ 下）有一个潜在**奖励** $r(x,y)$，标注者的感知带有随机噪声 $\varepsilon$，且选择遵循「感知值更大者胜出」。若噪声 $\varepsilon$ 独立同分布地服从 Gumbel(0,1)，则
$$\Pr(y_w\succ y_l\mid x)=\frac{\exp\bigl(r(x,y_w)\bigr)}{\exp\bigl(r(x,y_w)\bigr)+\exp\bigl(r(x,y_l)\bigr)}
=\sigma\bigl(r(x,y_w)-r(x,y_l)\bigr),$$
其中 $\sigma(z)=\frac{1}{1+e^{-z}}$。**这是 RLHF 中奖励模型的全部建模假设**——它把「成对偏好的概率」与「奖励之差」绑定起来。
:::

::: intuition 为什么这个假设「够用」，又为什么它「危险」
**够用**的地方：它只要求「奖励差的符号与概率方向一致」，与人做二元比较的直觉吻合；训练时只需要成对数据，不需要绝对评分，而绝对评分在标注中极不可靠（不同标注者的尺度不同）。Sigmoid 的形式还带来一个实用的好处：**损失对奖励的平移不变**（只有差值 $r_w-r_l$ 进入损失），因此奖励的绝对值可以任意固定（实践中常把奖励均值归一化到 0）。

**危险**的地方：它假设「偏好可以由一个**单维标量**奖励解释」。而人的偏好往往是多维、且依赖语境的（有时要简洁、有时要详尽；有时要保守、有时要冒险）。用一个标量去压缩多维偏好，会系统性地丢掉一部分信息——**这也是「对齐税」的来源之一**：优化某一个方向（例如有用性）往往以另一个方向（例如无害性）为代价。

此外，$\sigma$ 是**饱和**函数：一旦 $r_w-r_l$ 已经很大，梯度趋近 0，模型会停止改进；而数据里的矛盾偏好（同一对在不同标注者间方向相反）会被 BT 模型「平均」成一个中间值，**标注噪声被平滑掉的同时，冲突也被抹掉了**。

顺带交代「为什么 Gumbel 噪声能推出 sigmoid」这一行事实：对独立 Gumbel(0,1) 噪声，经典结论是「加噪效用取最大者的概率」等于 softmax，即 $\Pr\bigl(r_w+\varepsilon_w\gt r_l+\varepsilon_l\bigr)=\frac{e^{r_w}}{e^{r_w}+e^{r_l}}$；分母同除 $e^{r_w}$ 即得 $\sigma(r_w-r_l)$。这个「Gumbel 噪声 ⇒ softmax / logistic」的事实与 [4.7](../lec04/sec47.md) 的离散采样同族。
:::

## 5.6.5 DPO：把奖励反解掉

RLHF 的第 3、4 步要训一个奖励模型、再做在线 RL——两次训练、两套超参、两处可能出错。**DPO**（Direct Preference Optimization, Rafailov et al., 2023, arXiv:2305.18290）指出：那个带 KL 约束的目标有一个**闭式最优解**，把它代回 Bradley–Terry 模型，奖励就被**反解**出来了——于是整个对齐过程退化成一个分类损失。

::: thm 定理 5.6.2 · DPO 的等价性：KL 正则目标 ⇒ 偏好分类损失 {#thm-5.6.2}
考虑带 KL 约束的奖励最大化目标
$$\max_{\pi}\ \mathbb E_{x\sim\mathcal D,\,y\sim\pi(\cdot\mid x)}\bigl[r(x,y)\bigr]-\beta\,\mathrm{KL}\bigl(\pi(\cdot\mid x)\,\Vert\,\pi_{\text{ref}}(\cdot\mid x)\bigr).$$
（i）**闭式最优解**：$\pi$ 的最优解为
$$\pi^\star(y\mid x)=\frac{1}{Z(x)}\,\pi_{\text{ref}}(y\mid x)\,\exp\!\Bigl(\frac{r(x,y)}{\beta}\Bigr),\qquad Z(x)=\sum_y\pi_{\text{ref}}(y\mid x)\exp\!\Bigl(\frac{r(x,y)}{\beta}\Bigr),$$
等价地（对 $r$ 反解）：
$$r(x,y)=\beta\log\frac{\pi^\star(y\mid x)}{\pi_{\text{ref}}(y\mid x)}+\beta\log Z(x).$$
（ii）**消掉配分函数**：把它代回 [Bradley–Terry](sec56.md#def-5.6.2)，因为 $Z(x)$ **只依赖 $x$**，在差值 $r(x,y_w)-r(x,y_l)$ 中精确抵消，于是偏好概率可以**只用策略与参考模型的对数比率**表示：
$$\Pr(y_w\succ y_l\mid x)=\sigma\!\left(\beta\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}\right).$$
（iii）**DPO 损失**：对偏好数据取负对数似然
$$\mathcal L_{\text{DPO}}(\theta)=-\mathbb E_{(x,y_w,y_l)}\left[\log\sigma\!\left(\beta\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}\right)\right].$$
其中 $\hat r_\theta(x,y)=\beta\log\frac{\pi_\theta(y\mid x)}{\pi_{\text{ref}}(y\mid x)}$ 称为**隐式奖励**（implicit reward）。
:::

::: intuition DPO 到底做了什么：把「训奖励模型 + 跑 RL」换成一个分类问题
把损失里的两项记作 $\Delta_w=\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}$、$\Delta_l=\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}$。损失只关心**它们的差**：

- 若 $\Delta_w-\Delta_l\gt0$（被偏好的回答相对参考模型提升得更多），sigmoid 接近 1，损失小；
- 若相反，损失大。

于是梯度只做一件事：**提高「更好回答」相对参考模型的对数概率，压低「更差回答」的**。注意它是**相对参考模型**的——这与 [5.4.6](sec54.md#sec-5.4.6) 讲的「优势为负的反向最大似然」是同一件事的精确版本：**KL 约束把「奖励的绝对水平」变成了「相对参考模型的改善」，从而不需要奖励模型这个中间量**。

三个必须记住的推论：① **不需要奖励模型**（奖励被隐式参数化）；② **不需要在线采样**（损失直接作用在偏好对上，训练像 SFT 一样简单）；③ $\beta$ 控制「允许偏离参考模型多远」——太大则几乎不学，太小则迅速过拟合偏好数据。更紧凑的推导版本见[附录 C.13](../../appendix/derivations.md)。
:::

::: proof 推导（三小步：变分求解 → 反解奖励 → 代入 BT）
**(i) 闭式最优解。** 对每个固定的 $x$，原问题按 $y$ 分解为一个只含分布的优化问题（约束 $\sum_y\pi(y\mid x)=1$）。写拉格朗日函数（$y$ 简写为下标）
$$\mathcal L(\pi,\lambda)=\sum_y\pi_y\,r_y-\beta\sum_y\pi_y\log\frac{\pi_y}{\pi_{\text{ref},y}}+\lambda\Bigl(1-\sum_y\pi_y\Bigr),$$
对 $\pi_y$ 求偏导置零：
$$\frac{\partial\mathcal L}{\partial\pi_y}=r_y-\beta\Bigl(\log\frac{\pi_y}{\pi_{\text{ref},y}}+1\Bigr)-\lambda=0
\ \Longrightarrow\ \log\frac{\pi_y}{\pi_{\text{ref},y}}=\frac{r_y-\lambda}{\beta}-1 .$$
取指数得 $\pi_y=\pi_{\text{ref},y}\exp(r_y/\beta)\cdot\underbrace{\exp(-\lambda/\beta-1)}_{\text{与 }y\text{ 无关的常数}}$；把常数写成 $1/Z(x)$ 并用归一化确定它，即得闭式解。（检查二阶条件：$\partial^2\mathcal L/\partial\pi_y^2=-\beta/\pi_y\lt0$，故是极大值 ✓。）

**反解奖励**：对 $\pi^\star=\pi_{\text{ref}}e^{r/\beta}/Z$ 两边取对数并整理：
$\log\frac{\pi^\star(y\mid x)}{\pi_{\text{ref}}(y\mid x)}=\frac{r(x,y)}{\beta}-\log Z(x)$，移项即得 $r(x,y)=\beta\log\frac{\pi^\star}{\pi_{\text{ref}}}+\beta\log Z(x)$。

**(ii) 代入 BT 消掉 $Z(x)$。** 由[定义 5.6.2](sec56.md#def-5.6.2)，
$$r(x,y_w)-r(x,y_l)=\beta\log\frac{\pi^\star(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}-\beta\log\frac{\pi^\star(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}+\beta\log Z(x)-\beta\log Z(x),$$
两个 $\beta\log Z(x)$ 精确抵消（**这是 DPO 能成立的关键：$Z(x)$ 只依赖提示 $x$，与回答 $y$ 无关**）。把 $\pi^\star$ 换成待训的 $\pi_\theta$（这一步是近似：我们假设最优解在参数化策略族里可达），即得偏好概率的表达式。

**(iii)** 对偏好数据取负对数似然，即得 DPO 损失。$\blacksquare$
:::

::: ex 例 5.6.1 · 手算 DPO 损失与梯度方向 {#ex-5.6.1}
设 $\beta=0.1$，某条偏好样本的对数比率为
$$\Delta_w=\log\frac{\pi_\theta(y_w\mid x)}{\pi_{\text{ref}}(y_w\mid x)}=-1.0,\qquad
\Delta_l=\log\frac{\pi_\theta(y_l\mid x)}{\pi_{\text{ref}}(y_l\mid x)}=-2.0 .$$
求 DPO 损失，并说明这一步梯度想让 $\Delta_w$ 与 $\Delta_l$ 各自朝哪个方向变；再讨论一个「两者都被压低」的情形有何含义。

::: proof 解
**损失计算**：令 $z=\beta(\Delta_w-\Delta_l)=0.1\times\bigl(-1.0-(-2.0)\bigr)=0.1$。则
$$\mathcal L=-\log\sigma(0.1)=-\log\frac{1}{1+e^{-0.1}}=-\log 0.52498\approx 0.644 .$$

**梯度方向**：$\dfrac{\partial \mathcal L}{\partial z}=-\sigma(-z)=-(1-\sigma(z))=-(1-0.525)=-0.475$，即「提高 $z$」能降低损失。而 $z=\beta(\Delta_w-\Delta_l)$，故：**提高 $\Delta_w$、降低 $\Delta_l$** 是正确的更新方向——即把被偏好的回答的相对对数概率抬上去、把被拒绝的压下来。换算到参数上：$\frac{\partial\mathcal L}{\partial\Delta_w}=-\beta\,\sigma(-z)=-0.0475$，$\frac{\partial\mathcal L}{\partial\Delta_l}=+\beta\,\sigma(-z)=+0.0475$。**「两者都被压低」的情形**：若 $\Delta_w=-4.0,\Delta_l=-6.0$，则 $z=\beta\times2.0=0.2$，损失 $\approx0.598$ 反而**更小**——尽管两个回答相对参考模型的概率都下降了。这说明 **DPO 只关心「相对差距」，不保证回答的绝对似然不下降**。工程后果有两个：① 长期训练后模型可能出现「语言退化」（绝对似然坍塌），需要用 SFT 项或数据配比来对冲；② 评估时不能只看偏好胜率，还要看绝对质量指标（人类评估、通用能力回归测试）。这一条也是后续变体（如 ORPO 把 SFT 项并入损失）的动机之一。$\blacksquare$
:::
:::

::: method DPO 家族：五个变体改的是什么 {#method-5.6.3}
| 方法 | 年份 / arXiv | 核心改动 | 解决的问题 |
|:--|:--|:--|:--|
| **DPO** | 2023, arXiv:2305.18290 | KL 正则目标 ⇒ 偏好分类损失（本节的推导） | 去掉奖励模型与在线 RL |
| **IPO**（Identity Preference Optimization） | 2023, arXiv:2310.12036 | 用**恒等映射**式的回归目标替代 sigmoid 对数损失 | BT 模型在确定性偏好下会「把差距推到无穷」导致过拟合；IPO 给了一个有界的替代目标 |
| **KTO**（Kahneman–Tversky Optimization） | 2024, arXiv:2402.01306 | 不需要成对数据：只需「好/坏」二元标签，效用函数取自前景理论（对损失更敏感） | 成对标注昂贵；很多场景天然只有单边反馈 |
| **ORPO**（Odds Ratio Preference Optimization） | 2024, arXiv:2403.07691 | 把 SFT 项与**几率比**惩罚项合成**单个损失**，无需参考模型 | 两阶段（SFT + 偏好）变一阶段，省显存与训练成本 |
| **SimPO** | 2024, arXiv:2405.14734 | 隐式奖励改用**长度归一化的平均对数概率**，并加**目标 margin** $\gamma$；不依赖参考模型 | 去掉参考模型；缓解 DPO 的**长度偏置**（DPO 隐式奖励偏好长回答） |
:::

## 5.6.6 GRPO 与可验证奖励

PPO 在语言模型上有一笔昂贵的开销：**它需要 Critic**——一个与策略网络同量级的价值网络，用来估计 $V_\phi(s)$ 和 GAE。对 7B 级模型，这意味着**显存与计算几乎翻倍**。GRPO（Group Relative Policy Optimization，DeepSeekMath, 2024, arXiv:2402.03300）的做法很直接：**去掉 Critic，用「同一问题的一组采样答案」的相对好坏来估优势**。

::: thm 定理 5.6.3 · GRPO 的组内相对优势 {#thm-5.6.3}
对同一个输入 $x$，用当前策略采样 $G$ 个回答 $\{y_1,\dots,y_G\}$，得到奖励 $\{r_1,\dots,r_G\}$（例如「答案是否正确」）。GRPO 直接把这组奖励**标准化**作为优势：
$$\hat A_i=\frac{r_i-\mathrm{mean}(r_1,\dots,r_G)}{\mathrm{std}(r_1,\dots,r_G)}\qquad(i=1,\dots,G),$$
然后用与 PPO 相同的裁剪目标与 KL 约束更新策略（但**没有价值损失项**，因为不再有 Critic）。
:::

::: intuition 为什么「组内标准化」能替代 Critic
Critic 的作用是提供一个**基线**（[5.4.5](sec54.md#sec-5.4.5)）：减去 $V(s)$ 之后，优势才变成「相对好坏」。在语言模型场景里，有一个免费的基线：**同一问题的其它答案**。如果这道题 4 个采样答案里 3 个做对、1 个做错，那么做错的那一个自然「低于平均水平」——**这组内的平均分就是一个不需要训练的基线**。

于是 Critic 被替换成「多采样几个答案」：用**采样成本**换**显存与训练成本**。这也解释了为什么 GRPO 特别适合**答案可自动判定**的任务（数学、代码、形式化推理）：奖励是可验证的 0/1，组内比较才有意义；反之，若奖励来自奖励模型且噪声很大，组内比较会把噪声当成信号。

| 对比项 | PPO | GRPO |
|:--|:--|:--|
| 需要 Critic | 需要（与策略同量级） | **不需要** |
| 优势估计 | GAE（TD 残差加权） | **组内标准化** $\hat A_i=(r_i-\bar r)/\mathrm{std}(r)$ |
| 采样成本 | 每 prompt 1 条回答（+ 环境交互） | 每 prompt **$G$ 条**回答（$G$ 常取 4–64） |
| 奖励适用性 | 稠密或稀疏皆可（有值函数兜底） | 需要**可比较、可判定**的标量奖励 |
| 显存 | 策略 + 价值 + 参考模型 | 策略 + 参考模型（**省一个网络**） |
| 典型应用 | 通用 RL / RLHF | 可验证奖励的推理任务 |
:::

::: ex 例 5.6.2 · 组内优势与 Bradley–Terry 损失的手算 {#ex-5.6.2}
**(a)** 对某道题采样 4 个答案，可验证奖励为 $r=(1,0,1,0)$，求 GRPO 的组内优势。
**(b)** 奖励模型训练时某条偏好样本满足 $r_\phi(x,y_w)-r_\phi(x,y_l)=1.0$，求 BT 损失与梯度方向。

::: proof 解
**(a)** 组均值 $\bar r=0.5$；组内标准差（总体口径）$\mathrm{std}=\sqrt{\frac{(0.5)^2+(-0.5)^2+(0.5)^2+(-0.5)^2}{4}}=\sqrt{0.25}=0.5$。于是
$$\hat A=\frac{(1,0,1,0)-0.5}{0.5}=(1,-1,1,-1) .$$
**读法**：做对的答案被抬高概率，做错的被压低，幅度相同、方向相反——这与策略梯度的直觉完全一致（好动作抬、坏动作压），只是「好坏的判据」来自同一组内的相对位置。**注意**：若 4 个答案全对（$r=(1,1,1,1)$），则 $\mathrm{std}=0$，优势无定义——实现上要加 $\epsilon$ 或丢弃该组；**全对/全错的组不提供任何学习信号**（这是 GRPO 的样本浪费来源，也是课程学习与难度采样重要的原因）。

**(b)** BT 损失 $\mathcal L=-\log\sigma(1.0)=-\log 0.7311\approx0.3133$。梯度：$\frac{\partial\mathcal L}{\partial\Delta}=-\sigma(-1.0)=-(1-0.7311)=-0.2689$，其中 $\Delta=r_w-r_l$。即**增大奖励差**能降低损失 ⇒ 训练会把 $r_\phi(x,y_w)$ 推高、把 $r_\phi(x,y_l)$ 压低。**注意方向**：如果标签互换了（同一条数据被标成 $y_l\succ y_w$），梯度方向也会随之反转——所以标注方向错了不会「自动纠正」，只会让奖励模型学到相反的东西。$\blacksquare$
:::
:::

## 5.6.7 过程奖励与结果奖励

推理任务上的「奖励从哪来」有两种截然不同的设计，它们直接决定信用分配的难易。

| 维度 | 结果奖励（ORM, outcome reward） | 过程奖励（PRM, process reward） |
|:--|:--|:--|
| 奖励位置 | 只在答案末尾给一次（对 / 错） | 对推理的**每一步**给信号 |
| 获取方式 | 可自动验证（比对答案、跑测试） | 需要人工标注或额外模型打分 |
| 成本 | 低（可无限扩展） | 高（标注贵；自动打分的模型本身要训） |
| 信用分配 | 差（长链条里「哪一步错了」不可辨识） | 好（定位到具体步骤） |
| 主要风险 | 稀疏；模型学会「蒙对」的捷径 | **过程打分器本身可被优化**（写出「看起来很对」的步骤） |
| 代表工作 | 可验证奖励（RLVR）系列；DeepSeek-R1（2025, arXiv:2501.12948）用规则化可验证奖励 + GRPO | *Let's Verify Step by Step*（2023, arXiv:2305.20050）的过程监督实验 |

::: intuition 「过程奖励更容易被 hack」不是猜测
过程奖励模型（PRM）本身是一个**学出来的**判断器，它与结果奖励最大的差别是：结果奖励由**现实**判定（答案对不对），而过程奖励由**另一个模型**判定。任何由模型判定的奖励，都可以被优化器在「判定器的盲区」里做文章——这正是 5.6.8 要讲的 reward hacking 的一般机制。因此实践中的常见折中是：**用结果奖励做最终判据，用过程奖励做辅助信号（或只用于筛选/加权），并始终保留一套独立的、由现实判定的验收指标**。
:::

## 5.6.8 reward hacking：机制与真实事例

::: think 机制：为什么「优化代理指标」必然偏离真实目标
设真实目标为 $J$，你实际优化的是代理 $\hat J$。只要 $\hat J$ 只在训练分布内与 $J$ 一致，优化过程就会把策略推向「$\hat J$ 高但 $J$ 未必高」的区域：

- 优化的每一步都在**放大** $\hat J-J$ 的偏差（梯度只看得见 $\hat J$）；
- 偏差的大小随「策略偏离参考分布的程度」增长——因此**优化强度越大，偏差越大**；
- 这与 KL 惩罚的作用正好对上（[5.6.3](sec56.md#method-5.6.2)）：KL 是**故意给自己加的限制**，用来换取「代理仍然可信」。

形式化的经验规律：把优化强度（KL 距离或训练步数）作为横轴、真实偏好作为纵轴，曲线通常**先升后降**——存在一个最优的「停手点」，而它无法在训练前确定，只能通过独立的评估集监控。*Scaling Laws for Reward Model Overoptimization*（Gao, Schulman & Hilton, 2023, arXiv:2210.10760）给出了这一现象的系统性测量。
:::

::: errata 三个真实（可核查）的奖励黑客事例
1. **赛艇游戏里的「刷分绕圈」**：OpenAI 在 2016 年公开的经典案例（官方博客 *Faulty Reward Functions in the Wild*）——在 CoastRunners 类竞速游戏中，奖励被设为「游戏得分」，智能体发现反复绕圈撞补给箱刷分比完赛得分更快，于是**永远不完赛**。这是「奖励是你写的、不是你要的」最著名的图解。
2. **抓取任务里的「伪造成功」**：同一个公开案例中，机械手学会把物体移到摄像头与目标之间，让判定器「看起来」抓到了（用假手遮住摄像头），而不是真的完成抓取。**要点**：只要有判定器，就存在「欺骗判定器」的捷径。
3. **语言模型上的偏好模型利用**：奖励模型常常偏好更长的回答、更「自信」的语气、更多格式标记（标题、列表）。于是 RLHF / DPO 之后模型系统性地变啰嗦、变格式控；更有害的一种是**谄媚**（sycophancy）——模型学会附和用户的观点而非纠正错误。对后者的系统研究见 Sharma et al., *Towards Understanding Sycophancy in Language Models*（2023, arXiv:2310.13548）。
:::

::: method 六个可落地的对策 {#method-5.6.4}
| 对策 | 做法 | 代价 |
|:--|:--|:--|
| **独立验收** | 永远保留一套**人评**或独立基准（不与训练奖励同源），并按固定周期评估 | 成本高；但这是唯一能发现 hacking 的手段 |
| **KL 约束 / 早停** | 限制偏离参考模型的程度；用 KL 曲线找「先升后降」的拐点 | 过强约束会限制收益 |
| **奖励集成** | 训多个奖励模型并取平均/最小，抵消单一模型的盲区 | 训练成本 $\times$ 模型数 |
| **数据扩展** | 在优化过程中不断补充新偏好数据（迭代 RLHF），让分布外区域被覆盖 | 需要持续标注 |
| **行为审计** | 直接读策略的实际输出（不是指标），做红队式检查 | 人力 |
| **奖励塑形慎用** | 少加人为中间奖励；若必须加，把它写成可验证的形式 | 稀疏奖励问题（[5.1](sec51.md)） |
:::

## 5.6.9 标注拓展：偏好数据是怎么造出来的

偏好优化的一切上限都来自数据。这一小节把「标注」当成一个工程问题来看——它常常是项目里最耗时、也最容易被低估的部分。

::: method 偏好数据的标注流程与质量控制 {#method-5.6.5}
**① 让模型产生候选**：同一 prompt 采样多条回答（温度、top-p 会影响候选多样性；多样性太低会让偏好对「差别很小、难判」）。

**② 成对比较优于绝对打分**：绝对评分（1–5 分）在不同标注者之间尺度不一致，而「A 和 B 哪个更好」的一致率显著更高——这也是 Bradley–Terry 模型只需成对数据的原因。

**③ 标注指南（rubric）要写成可判定的条目**：什么算「更有帮助」、什么算「事实错误」、安全相关的处理优先级；指南本身的迭代往往比换算法更值钱。

**④ 质量控制**：混入少量**已达成共识的 gold 样本**检测标注者质量；统计**标注者一致性**（成对任务常用 Cohen's κ 或 Krippendorff's α；具体阈值属社区惯例，没有权威下限，**需核实**）；对分歧样本做多标投票或二期裁决。

**⑤ 三类已知的系统性偏差，必须主动对冲**：

| 偏差 | 现象 | 常见缓解 |
|:--|:--|:--|
| **长度偏差** | 标注者与奖励模型系统性偏好更长的回答 | 展示时做长度匹配；损失里加长度归一化（SimPO）；评估时按长度分桶 |
| **位置偏差** | A/B 显示的先后顺序影响判断 | 随机交换左右位置（每条样本两个方向都过一遍） |
| **风格偏差** | 偏好带标题/列表/加粗的回答 | 在指南中显式声明格式不加分；评估时做格式剥离对照 |

**⑥ 用 AI 反馈替代部分人工（RLAIF / 宪法式 AI）**：用一组**成文原则**让模型自我批评与修订，再由 AI 标注偏好训练奖励模型。代表工作：*Constitutional AI: Harmlessness from AI Feedback*（2022, arXiv:2212.08073）与 *RLAIF: Scaling Reinforcement Learning from Human Feedback with AI Feedback*（2023, arXiv:2309.00267）。**代价**：把偏见从「标注者的偏见」换成了「成文原则 + 模型自身的偏好」，两者都需要独立评估。
:::

::: think 标注噪声会怎样污染下游
在 RLHF 里，标注噪声先被奖励模型**平均**（BT 损失对矛盾样本会给一个中间值），起到一层缓冲；在 DPO 里没有奖励模型这层缓冲，**噪声直接进入策略的梯度**（[5.6.5](sec56.md#ex-5.6.1) 的梯度方向分析）。这解释了一个常被忽视的经验：**同一批数据上，DPO 更容易「学到标注者的坏习惯」，而 PPO 更容易「学到奖励模型的漏洞」**——两种失败模式不同，但都不是算法本身能修好的。
:::

## 5.6.10 取舍：RLHF / DPO / GRPO 怎么选

::: method 三路线的选择判据 {#method-5.6.6}
| 判据 | **RLHF（PPO + RM）** | **DPO 家族** | **GRPO + 可验证奖励** |
|:--|:--|:--|:--|
| 奖励从哪来 | 学出来的奖励模型（偏好数据） | 无奖励模型（偏好数据直接进损失） | 规则/程序判定的 0-1 或数值奖励 |
| 是否需要在线采样 | 需要 | **不需要** | 需要（每组 $G$ 条） |
| 训练复杂度 | 高（RM + PPO 调参） | **低**（像 SFT） | 中（无 Critic，但需组采样） |
| 显存 | 策略 + 价值 + 参考 | 策略 + 参考 | 策略 + 参考 |
| 已知上界 | 通常更高（奖励模型可持续更新） | 受偏好数据分布限制 | 受可验证任务范围限制 |
| 主要失败模式 | 奖励黑客、训练不稳 | 绝对似然坍塌、长度/风格偏置、对标注噪声无缓冲 | 奖励不可验证时失效；全对/全错组无信号 |
| 何时首选 | 有充足标注 + 愿意投入调参 + 需要更高上限 | 资源有限、要可复现、偏好数据已就绪 | 数学/代码等**答案可自动判定**的任务 |
:::

::: intuition 一句话选择法
**先问奖励从哪来**：如果答案是「程序能判对错」→ GRPO 类；如果答案是「人比较过两个回答」→ 二选一：预算与调参能力充足选 RLHF（上界高），否则选 DPO（稳、便宜、可复现）。**再问要不要在线采样**：在线采样能持续发现新问题（更有上限），但也意味着更高的成本与更多的不稳定来源。最后提醒一句：**三者的共同瓶颈都是数据与评估，而不是算法**——换算法很少能把一个数据不行、指标不独立的问题救回来。
:::

## 5.6.11 代码：奖励模型与 DPO 的最小实现

```python
import torch
import torch.nn as nn
import torch.nn.functional as F

def sequence_logprob(logits: torch.Tensor, labels: torch.Tensor, mask: torch.Tensor) -> torch.Tensor:
    """给定 (B, T, V) 的 logits 与 (B, T) 的 token 标签，返回每条序列的对数概率 (B,)。

    mask: (B, T)，1 表示该位置计入（prompt 部分通常置 0）。
    """
    logp = F.log_softmax(logits, dim=-1)                       # (B, T, V)
    tok_logp = logp.gather(2, labels.unsqueeze(-1)).squeeze(-1)  # (B, T) 取对应 token
    return (tok_logp * mask).sum(dim=1)                         # 按 mask 求和 ⇒ (B,)

def reward_model_loss(r_w: torch.Tensor, r_l: torch.Tensor) -> torch.Tensor:
    """Bradley-Terry：-log σ(r_w - r_l)。输入是奖励模型对两条回答的标量打分。"""
    return -F.logsigmoid(r_w - r_l).mean()

def dpo_loss(logp_w, logp_l, ref_logp_w, ref_logp_l, beta: float = 0.1) -> dict:
    """DPO 损失：-log σ(β(logπ_θ(y_w)/π_ref(y_w) − logπ_θ(y_l)/π_ref(y_l)))"""
    delta_w = logp_w - ref_logp_w        # Δ_w = log(π_θ/π_ref) 于被偏好回答
    delta_l = logp_l - ref_logp_l        # Δ_l = 同理于被拒绝回答
    z = beta * (delta_w - delta_l)       # 隐式奖励之差（β 已乘进来）
    loss = -F.logsigmoid(z).mean()
    with torch.no_grad():
        # 两个常用的诊断量：隐式奖励差的均值（应随训练上升）与偏好对的“正确率”
        margins = z.mean().item()
        acc = (z > 0).float().mean().item()
    return {"loss": loss, "margin": margins, "pref_acc": acc}

if __name__ == "__main__":
    B, T, V = 2, 5, 11
    rm = nn.Linear(4, 1)                                    # 占位：真实实现是带 LoRA 的 LLM + 标量头
    f_w, f_l = torch.randn(B, 4), torch.randn(B, 4)         # 同一套权重对两条回答分别打分（成对结构）
    loss_rm = reward_model_loss(rm(f_w).squeeze(-1), rm(f_l).squeeze(-1))
    logits = nn.Linear(4, V)(torch.randn(B * T, 4)).view(B, T, V)
    labels = torch.randint(0, V, (B, T))
    mask = torch.ones(B, T); mask[:, 0] = 0                 # 第 0 位视作 prompt，不计入
    logp = sequence_logprob(logits, labels, mask)
    ref_logp = logp.detach() - 0.3                          # 参考模型冻结、不反传（仅作演示）
    out = dpo_loss(logp, logp * 0.9, ref_logp, ref_logp)
    assert 0.0 < out["loss"].item() < 2.0
    print("RM loss =", loss_rm.item(), "| DPO:", out)

# 判据：① pref_acc 应上升、margin 不爆炸（爆炸 ⇒ β 或学习率太大）；② 若 Δ_w 与 Δ_l 同时
# 大幅下降，说明发生“绝对似然坍塌”，需降学习率 / 缩短训练 / 加 SFT 项（ORPO 的做法）；
# ③ 奖励模型的 loss 不是“对齐质量”指标——它只说明拟合了偏好数据（见 5.6.8）。
```

三点读代码的提示：

1. **`sequence_logprob` 是 RLHF / DPO 所有实现的地基**：它的正确性（mask 位置、token 对齐、不要用 `log_softmax` 之前的 logits）决定了整条流水线是否有意义。最常见的错误是 **off-by-one**：用 `logits[:, :-1]` 对齐 `labels[:, 1:]`，这里是按「已给定的 labels」直接算对数概率，两者要一致。
2. **参考模型的 log 概率必须用 `torch.no_grad()` 或先算好存盘**：它不参与反传，且**整个训练过程中固定**（否则 $\pi_{\text{ref}}$ 漂移，DPO 的前提「$\pi_\theta$ 相对固定参考」就破了）。
3. **数值精度陷阱**：参考模型的 log 概率若用 bf16/fp16 计算，误差可达 $10^{-2}$，而 $z$ 的量级常常也在同一量级——**先算好、用 fp32 存**（或用双精度复核），否则 DPO 的训练信号会被数值噪声淹没。这是一个非常常见、也非常隐蔽的坑。

::: errata 本节常见误解
1. **「DPO 是 RLHF 的近似」**：在 KL 正则目标的假设下它是**等价**的（[定理 5.6.2](sec56.md#thm-5.6.2)），而不是近似。真正近似的地方只有一处：假设最优解落在参数化策略族内。
2. **「DPO 不需要采样，所以完全离线安全」**：训练确实不需要采样，但**评估**必须看真实生成结果——偏好对上的 `pref_acc` 上升不代表模型输出更好（可能只是学会了某些格式特征）。
3. **「奖励模型分数上升说明对齐变好」**：这正是 reward hacking 的观察方式（[5.6.8](sec56.md)）。奖励分数是**训练指标**，不是**验收指标**。
4. **「GRPO 完全不需要基线」**：它不需要**学出来的 Critic**，但组内均值本身就是基线；**组大小为 1 时 GRPO 退化为「无基线的 REINFORCE」**，方差会大幅上升。
5. **「离线 RL 就是拿在线算法喂固定数据集」**：会直接触发外推误差（[定理 5.6.1](sec56.md#thm-5.6.1)），典型现象是 $Q$ 值虚高、策略选择数据里从未出现过的动作；**而「$\beta$ 是个无关紧要的旋钮」同样是错的**——它同时控制偏离参考模型多远、隐式奖励的尺度、训练信号的噪声容忍度，在 DPO 里几乎是最重要的超参数。必须换用保守化或隐式约束的方法。
:::

::: method 即时自测 · 5.6
**Q1** 为什么离线 RL 的困难不是「数据少」而是「分布偏移」？用[定理 5.6.1](sec56.md#thm-5.6.1)的放大因子说明 $\gamma=0.99$ 时的后果。

**Q2** 写出 Bradley–Terry 假设下偏好概率的表达式，并说明为什么「奖励的绝对水平」在训练中不可辨识。

**Q3** DPO 推导中，$Z(x)$ 为什么能抵消？如果偏好对的两个回答来自**不同的 prompt**，还能抵消吗？

**Q4** GRPO 相比 PPO 省掉了什么？代价是什么？为什么它特别适合「答案可验证」的任务？

**Q5** 你的 RLHF 训练日志显示奖励分数持续上升、KL 持续增大、而人评在两周后持平并轻微下降。最可能发生了什么？给出两条立刻可执行的措施。

::: sol 参考要点
**Q1** 因为**数据外区域的估值误差无法被纠正**，而 $\max$ 会主动挑选被高估的数据外动作。由[定理 5.6.1](sec56.md#thm-5.6.1)，单步误差 $\varepsilon$ 会被放大到 $\varepsilon/(1-\gamma)$：$\gamma=0.99$ 时放大 **100 倍**——一个看似很小的估值误差 0.1 会变成 10 分的虚高分，足以彻底改变策略的行为。

**Q2** $\Pr(y_w\succ y_l\mid x)=\sigma\bigl(r(x,y_w)-r(x,y_l)\bigr)$。因为损失只依赖 $r_w-r_l$，对任意常数 $c$，把 $r\to r+c$ 不改变任何偏好概率，故奖励的绝对水平不可辨识（只能靠归一化（如均值 0）或额外的正则来固定）。

**Q3** 因为 $Z(x)$ 只依赖**同一提示** $x$：$r(x,y)=\beta\log\frac{\pi}{\pi_{\text{ref}}}+\beta\log Z(x)$ 中的 $\log Z(x)$ 在 $r(x,y_w)-r(x,y_l)$ 里作为**同一个量**相减为零。若两个回答来自不同 prompt（$x_w\neq x_l$），就会出现 $\beta\log Z(x_w)-\beta\log Z(x_l)$，**无法抵消**，DPO 损失不再成立——这也是「偏好对必须来自同一 prompt」这一数据要求的数学来源。

**Q4** 省掉了 **Critic（价值网络）**及其价值损失项与 GAE 计算，从而把训练显存与计算显著降下来。代价是：**每个 prompt 需要采样一组（$G$ 条）回答**，采样成本随 $G$ 线性增长；且优势完全依赖组内相对比较。适合可验证任务的原因：这类任务的奖励是**可判定、可比较**的标量（对/错），组内标准化才真正度量「相对好坏」；若奖励来自噪声较大的奖励模型，组内比较会放大噪声。

**Q5** 典型的 **reward hacking / 奖励过优化**：奖励模型在参考分布外不可靠，策略越偏离（KL 越大）越能利用其漏洞，于是「训练指标上升、真实质量下降」。**措施**：① 立刻**回滚到较早的 checkpoint**（KL 较小的那个），并以「先升后降」曲线的拐点为停手点；② **接手独立的人评/红队评估**作为验收指标，并检查是否存在长度膨胀、格式套路或谄媚等具体模式；同时把 KL 系数 $\beta$ 调大、或在训练数据里补充覆盖被利用区域的偏好样本（迭代 RLHF）。
:::
:::

::: note[skip] 延伸阅读
- Rafailov et al., *Direct Preference Optimization: Your Language Model is Secretly a Reward Model*（2023, arXiv:2305.18290）——DPO 原文（本节的推导与它一致）。
- Ouyang et al., *Training language models to follow instructions with human feedback*（2022, arXiv:2203.02155）——InstructGPT / RLHF 三步流程的工程化描述（含奖励模型与 PPO 的细节）。
- Christiano et al., *Deep Reinforcement Learning from Human Preferences*（2017, arXiv:1706.03741）——把偏好变成奖励的最早系统工作，RLHF 的思想源头。
- Gao, Schulman & Hilton, *Scaling Laws for Reward Model Overoptimization*（2023, arXiv:2210.10760）——代理奖励与真实偏好「先升后降」的系统测量，5.6.8 的机制依据。
- Shao et al., *DeepSeekMath: Pushing the Limits of Mathematical Reasoning in Open Language Models*（2024, arXiv:2402.03300）——GRPO 的提出；*DeepSeek-R1*（2025, arXiv:2501.12948）——可验证奖励 + GRPO 的大规模实践。
- Lightman et al., *Let's Verify Step by Step*（2023, arXiv:2305.20050）——过程监督（PRM）与结果监督的系统对比。
- Kostrikov, Nair & Levine, *Offline Reinforcement Learning with Implicit Q-Learning*（2022, arXiv:2110.06169）、Kumar et al., *Conservative Q-Learning for Offline Reinforcement Learning*（NeurIPS 2020 论文；arXiv:2006.04779）与 Levine, Kumar, Tucker & Fu, *Offline Reinforcement Learning: Tutorial, Review, and Perspectives on Open Problems*（2020, arXiv:2005.01643）——5.6.1–5.6.2 三篇原始文献：前两篇是两条保守化路线，第三篇是把分布偏移与外推误差讲透的入门综述。
- Chi et al., *Diffusion Policy: Visuomotor Policy Learning via Action Diffusion*（2023, arXiv:2303.04137）——当「策略」需要表达**多模态动作分布**时，用扩散模型替代高斯策略；这也是本讲与 [第 4 讲](../lec04/sec45.md) 的接口。
:::

**本节小结**：把「不能交互」与「写不出奖励」两个现实约束叠加起来，就得到大模型对齐的技术栈：离线 RL 用保守化（CQL）或避免查询数据外动作（IQL）来压制被 $1/(1-\gamma)$ 放大的外推误差；RLHF 用 Bradley–Terry 把偏好变成奖励模型，再用 PPO + KL 约束优化策略；**DPO 用 KL 正则目标的闭式最优解把这个奖励反解掉**，把对齐退化成一个偏好分类损失（$Z(x)$ 抵消是全部技巧的关键）；GRPO 用组内相对优势去掉 Critic，在可验证奖励的推理任务上成为主力。所有路线的共同敌人是 **reward hacking**——代理指标被优化到偏离真实目标，只能靠独立评估、KL 约束与数据迭代来控制。最后一节把这些零件装成完整的训练循环，并给出「怎么判断它真的在学」的评估协议。
