# 第 4 讲习题集

> 四组难度递进：**A 概念判断 → B 推导证明 → C 编程实现 → D 开放设计**。答案默认折叠，点击展开。
> 用法：先闭卷做 A 组，再对照答案；B 组**手写**推导（涉及形状的先写形状，不许写「略」）；C 组上机并**跑通验收标准**（验收标准本身就是判分线）；D 组写成半页方案（方案 + 理由 + 失败判据 + 验证计划，四项缺一不可）。
> 考点范围限 [导览](overview.md) 与 [4.1](sec41.md)–[4.8](sec48.md)，答案均可回正文定位；每题末尾「依据」给出回查入口。

## A 组 · 概念判断（8 题）

**判定要求**：判断题必须给**一句话理由或反例**，只写「对 / 错」不给分；辨析题必须写清「两者各自守住什么、放弃了什么」。

**A1.** 一个模型在验证集上的平均对数似然比另一个高，说明它的样本观感一定更好。（依据：[命题 4.1.1](sec41.md#prop-4.1.1)、[例 4.1.1](sec41.md#ex-4.1.1)）

::: sol 答案
**错。** 采样与似然是**两项独立的能力**（[命题 4.1.1](sec41.md#prop-4.1.1)）：存在「有似然无便宜采样」（能量模型）与「有采样无似然」（GAN）的构造。更根本的是，连续数据上的密度是**可积的而不是有界的**——[例 4.1.1](sec41.md#ex-4.1.1) 构造的 $q$ 在原点发散、对数似然无界，却能满足归一化条件。同时对数似然是数据分布下的**期望**，由高密度区（最常见、最平淡的区域）主导，而人看样本时看的是细节与结构。**正确说法**：似然度量「两个分布在期望意义上有多接近」，样本质量度量「单个样本落在数据流形附近的哪里」。
:::

**A2.** 某团队报告：模型 A 的 FID 是 12.3、模型 B 是 14.1，因此 A 更好。列出至少三条你会追问的信息。（依据：[4.1.4](sec41.md#sec-4.1.4.1)、[方法 4.1.2](sec41.md#method-4.1.2)）

::: sol 答案
（任意三条即可）① **样本量**：FID 的高斯拟合与协方差估计都是小样本有偏估计，10k 与 50k 的数字不可直接比较；② **特征提取器与预处理**：用哪个 Inception 层、缩放插值方式、归一化范围、是否裁剪——这些细节足以让 FID 变动数个百分点；③ **是否做过近邻去记忆检查**：混入训练样本会让 FID 显著变好；④ 是否单次实验，还是多种子的均值与方差；⑤ 是否有独立的人类偏好盲测；⑥ 两组是否用同一套评测代码与版本。**一句话**：FID 数字必须带上口径才能解释，跨设置比较无意义。
:::

**A3.** VAE 的重建项用 MSE 就等价于对数似然，因此「VAE 的重建损失就是 MSE」。（依据：[4.3.5](sec43.md)、[4.3](sec43.md) 陷阱框第 1 条）

::: sol 答案
**错（缺条件）。** 只有当解码器取**固定方差的高斯** $p_\theta(\boldsymbol x\mid z)=\mathcal N(g_\theta(z),\sigma_x^2I)$ 时，$-\log p_\theta(\boldsymbol x\mid z)$ 才等于 $\frac{1}{2\sigma_x^2}\lVert\boldsymbol x-g_\theta(z)\rVert^2$ 加一个与参数无关的常数；二值 / 离散像素应改用 Bernoulli 解码器 + 交叉熵（BCE）。此外整个目标是 **ELBO（下界）**，不是 $\log p(\boldsymbol x)$ 本身——两处都要说清。
:::

**A4.** KL 项只是可选的正则，去掉它重建会更好，所以小模型上可以先不用。（依据：[4.3.6](sec43.md#sec-4.3.6)、[4.2.3](sec42.md#sec-4.2.3)）

::: sol 答案
**错。** 去掉 KL 项后 VAE 退化成普通 AE：潜空间重新变得**无分布可采**，从 $\mathcal N(0,I)$ 采的点落在训练从未覆盖的区域，解码结果无意义（[命题 4.2.2](sec42.md#prop-4.2.2)）。KL 项正是「把后验拉向先验、让潜空间连续且被填满」的那一项；它的系数 $\beta$ 是「重建准度 vs 潜空间规整」的刻意旋钮，不是可有可无的装饰。**反向也不可过头**：$\beta$ 过大压制潜码信息，会出现后验坍塌（KL 逼近 0）。
:::

**A5.** 「模型只生成一类样本、但每张都极像」与「模式坍塌」是同一件事，处置办法也一样。（依据：[4.4.3](sec44.md#sec-4.4.3)、[命题 4.4.1](sec44.md#prop-4.4.1)）

::: sol 答案
**错。** 模式坍塌有**特定机制**：$G$ 只覆盖部分模态，却仍能让当前的 $D$ 无法分辨，于是 $D$ 也停止在这些模态上提供信号——这是**博弈结构**的产物（[命题 4.4.1](sec44.md#prop-4.4.1)），判据是「批内相似度崩溃 + $D$ 输出恒在 $0.5$ 附近（损失约 $0.69\approx\log2$）」。而低多样性还有若干**全球性**成因：CFG 的 $w$ 过大、$\beta$ 过大、重流化过度导致路径合并、少步蒸馏坍塌。前者要改博弈结构（多样性保护、WGAN-GP、EMA），后者只需调对应的旋钮——**误判方向会白调很久**。
:::

**A6.** 扩散模型的训练损失 $\mathcal L_{\text{simple}}$ 就是它的似然下界，因此可以用它报 bits/dim。（依据：[定理 4.5.2](sec45.md#thm-4.5.2)、[4.5](sec45.md) 陷阱框第 3 条）

::: sol 答案
**错。** 完整的 VLB 每一项等价于 $\dfrac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}\lVert\varepsilon-\varepsilon_\theta\rVert^2$，DDPM 把权重 $w_t$ **全部置为 1** 才得到 $\mathcal L_{\text{simple}}$——它是**加权版本**，高噪声步被相对放大、低噪声步被相对缩小，因此样本质量更好但**不再是下界**。要报似然类数字必须用完整 $w_t$ 重算。
:::

**A7.** DDIM 是另一个需要单独训练的模型，因为它改了前向过程。（依据：[4.5.4](sec45.md#sec-4.5.4)、[方法 4.5.2](sec45.md#method-4.5.2)）

::: sol 答案
**错。** DDIM 只改**采样时的路径参数化**（非马尔可夫桥梁 + 跳步），所有边际 $q(x_t\mid x_0)$ 完全不变，因此**可以复用同一个训练好的 $\varepsilon_\theta$**——这正是它发布后立刻被广泛采用的原因：零训练成本换 $20\sim50$ 倍的采样加速。代价是：$\sigma_t=0$ 时采样确定性、多样性略降；步数过少时 $\hat x_0$ 的单次估计误差会被放大成可见失真。
:::

**A8.** FSQ 只是 VQ 的实现优化（把查表换成四舍五入），因此两者能力完全等价。（依据：[定义 4.7.3](sec47.md#def-4.7.3)、[4.7.4](sec47.md#sec-4.7.4)）

::: sol 答案
**错。** FSQ 改变的是**表示的结构**：从「学出来的 $K$ 个码字」变成「逐维固定的网格 $K=\prod_iL_i$」。因此它一次性去掉了三样东西——代码本损失、commitment loss 与最近邻搜索（量化从 $O(K)$ 变成逐维 round 的 $O(d)$），也去掉了它们带来的不稳定（死码字、码字塌缩）。**代价也要说清**：VQ 的码字是数据驱动的（可以贴合数据流形），FSQ 的网格是先验固定的（在超立方体上均匀铺）；数据分布极不均匀时 VQ 理论上更高效，但实践中去掉各种不稳定技巧后整体收益更大。
:::

## B 组 · 推导与证明（6 题）

> 要求：关键步骤逐条写出，不许写「略」；涉及形状的先写形状。B1–B4 为本讲的四条主干推导，B5–B6 为两条「变体推导」。

**B1.** 用**两种**方法推导 ELBO：(a) Jensen 不等式把它「造」出来；(b) 贝叶斯分解把缺口**精确定位**。最后说明两者各自告诉你什么。（依据：[定理 4.3.1](sec43.md#thm-4.3.1)）

::: sol 提示与答案
**(a) Jensen 路线。** 目标不可算是因为要对全部潜变量积分：$\log p_\theta(\boldsymbol x)=\log\int p_\theta(\boldsymbol x\mid z)p(z)\,dz$。乘除同一个 $q_\phi(z\mid\boldsymbol x)$ 把积分写成它的期望，再用 Jensen 把 $\log$ 移进期望：
$$\log p_\theta(\boldsymbol x)=\log\mathbb E_{q_\phi}\!\left[\frac{p_\theta(\boldsymbol x\mid z)p(z)}{q_\phi(z\mid\boldsymbol x)}\right]\ \ge\ \mathbb E_{q_\phi}\!\left[\log\frac{p_\theta(\boldsymbol x\mid z)p(z)}{q_\phi(z\mid\boldsymbol x)}\right]=\underbrace{\mathbb E_{q_\phi}[\log p_\theta(\boldsymbol x\mid z)]}_{\text{重建项}}-\underbrace{\mathrm{KL}(q_\phi(z\mid\boldsymbol x)\|p(z))}_{\text{正则项}} .$$
取等号的条件恰是 $q_\phi(z\mid\boldsymbol x)=p_\theta(z\mid\boldsymbol x)$。

**(b) 贝叶斯分解路线。** 由 $p_\theta(\boldsymbol x)=\dfrac{p_\theta(\boldsymbol x,z)}{p_\theta(z\mid\boldsymbol x)}$（对任意 $z$ 成立）与 $\mathbb E_q[\log p_\theta(\boldsymbol x)]=\log p_\theta(\boldsymbol x)$：
$$\log p_\theta(\boldsymbol x)=\mathbb E_q\!\left[\log\frac{p_\theta(\boldsymbol x,z)}{q_\phi(z\mid\boldsymbol x)}\right]+\mathbb E_q\!\left[\log\frac{q_\phi(z\mid\boldsymbol x)}{p_\theta(z\mid\boldsymbol x)}\right]=\mathcal L_{\mathrm{ELBO}}+\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p_\theta(z\mid\boldsymbol x)\bigr).$$
其中第一项按定义就是 ELBO（把 $p_\theta(\boldsymbol x,z)=p_\theta(\boldsymbol x\mid z)p(z)$ 展开即可看出），第二项按定义就是两个后验的 KL。**注意**：整个变形是恒等式，不需要任何近似。

**(c) 两种读法。** Jensen 路线告诉你 ELBO「长什么样」——它是把不可积的积分换成可采样期望后**必然出现**的下界，也解释了为什么必须有一个 $q_\phi$；贝叶斯路线告诉你 ELBO「缺了什么」——缺口 $=\mathrm{KL}(q_\phi\|p_\theta(z\mid\boldsymbol x))\ge0$。**推论（工程上最有用）**：重建很差而 KL 又很小时，缺口可能很大，此时「最大化下界」并不等于「最大化似然」。
:::

**B2.** 证明重参数化梯度 $\widehat{\boldsymbol g}_{\text{path}}=\nabla_z f(z)\cdot\nabla_\phi(\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon)$ 是 $\nabla_\phi\mathbb E_{q_\phi}[f(z)]$ 的无偏估计，并说明它为什么比 REINFORCE 估计方差小。（依据：[命题 4.3.1](sec43.md#prop-4.3.1)、[方法 4.3.1](sec43.md#method-4.3.1)）

::: sol 提示与答案
**障碍先写清**：重建项是 $\mathbb E_{z\sim q_\phi(z\mid\boldsymbol x)}[f(z)]$，**被求期望的分布本身依赖 $\phi$**，采样节点在计算图上是不可导断点。

**(1) 换元去掉依赖。** 把采样写成 $z=\boldsymbol\mu_\phi(\boldsymbol x)+\boldsymbol\sigma_\phi(\boldsymbol x)\odot\boldsymbol\varepsilon$、$\boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)$（$\boldsymbol\varepsilon$ 的分布与 $\phi$ 无关），于是
$$\mathbb E_{q_\phi}[f(z)]=\mathbb E_{\boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)}\bigl[f(\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon)\bigr].$$
**(2) 交换求导与积分（正则条件下）。** 右侧的积分测度与积分域都不依赖 $\phi$，故
$$\nabla_\phi\mathbb E_{q_\phi}[f]=\mathbb E_{\boldsymbol\varepsilon}\bigl[\nabla_\phi f(\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon)\bigr]=\mathbb E_{\boldsymbol\varepsilon}\bigl[\nabla_z f(z)^{\mathrm T}\nabla_\phi z\bigr]=\mathbb E[\widehat{\boldsymbol g}_{\text{path}}].$$
即 $\widehat{\boldsymbol g}_{\text{path}}$ 无偏——**这就是「路径导数」**：在给定 $\boldsymbol\varepsilon$ 的那一份具体样本上梯度是确定的，随机性只来自 $\boldsymbol\varepsilon$。

**(3) 与 REINFORCE 的差别。** 对数导数估计由 $\nabla_\phi\mathbb E_{q_\phi}[f]=\mathbb E_{q_\phi}[f(z)\nabla_\phi\log q_\phi(z\mid\boldsymbol x)]$ 给出，它**只用标量 $f(z)$** 与得分函数相乘：不含 $\nabla_z f$，即「哪个方向能降低 $f$」这条信息完全丢失。而 $\nabla_\phi\log q_\phi$ 的范数通常随维数 $d$ 增长，标量 $f$ 无法抵消，方差随 $d$ 明显恶化；路径导数通过 $\nabla_z f$ 直接把方向信息送进梯度，与 $d$ 的关系温和得多。
:::

**B3.** 推导最优判别器 $D^\star$，并代回 $V$ 证明 $\min_G\max_DV$ 等价于最小化 $2\,\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$；最后指出这个漂亮结论暴露了哪个病根。（依据：[定理 4.4.1](sec44.md#thm-4.4.1)）

::: sol 提示与答案
**(1) 逐点最大化。** 固定 $G$（即固定 $p_g$）后，$V$ 是关于函数 $D(\cdot)$ 的泛函
$$V(D)=\int\bigl[p_{\text{data}}(\boldsymbol x)\log D(\boldsymbol x)+p_g(\boldsymbol x)\log(1-D(\boldsymbol x))\bigr]d\boldsymbol x,$$
被积函数在每点只依赖 $D(\boldsymbol x)$，故可逐点最大化。令 $a=p_{\text{data}}(\boldsymbol x),b=p_g(\boldsymbol x)$，$\frac{a}{D}-\frac{b}{1-D}=0$ 给出
$$D^\star(\boldsymbol x)=\frac{a}{a+b}=\frac{p_{\text{data}}(\boldsymbol x)}{p_{\text{data}}(\boldsymbol x)+p_g(\boldsymbol x)} .$$
（二阶导 $-\frac{a}{D^2}-\frac{b}{(1-D)^2}\lt0$，确为极大值点。）

**(2) 代回。** 令 $m=\tfrac12(p_{\text{data}}+p_g)$，则 $\frac{a}{a+b}=\frac{p_{\text{data}}}{2m}$、$\frac{b}{a+b}=\frac{p_g}{2m}$，代入并拆出 $\log2$：
$$V(D^\star,G)=\int\Bigl[p_{\text{data}}\log\frac{p_{\text{data}}}{m}+p_g\log\frac{p_g}{m}\Bigr]d\boldsymbol x-\log2\!\!\underbrace{\int(p_{\text{data}}+p_g)d\boldsymbol x}_{=2}=\mathrm{KL}(p_{\text{data}}\|m)+\mathrm{KL}(p_g\|m)-\log4=2\,\mathrm{JSD}-\log4 .$$

**(3) 全局最优。** JSD 非负且当且仅当两分布几乎处处相等时为 0，故 $p_g=p_{\text{data}}$ 是全局最优，此时 $D^\star\equiv\tfrac12$、$V^\star=-\log4$。

**(4) 暴露的病根。** 当两个分布的**支撑不重叠**时（初始化后的随机网络几乎必然如此），混合 $m$ 的支撑被切成互不相交的两块，两项 KL 各等于 $\log2$，于是 $\mathrm{JSD}\equiv\log2$ 为**常数**——对 $G$ 的参数梯度严格为零（[命题 4.4.1](sec44.md#prop-4.4.1)、[例 4.4.1](sec44.md#ex-4.4.1)）。这就是 GAN「判别器一强、生成器就不动」的机制；WGAN 换用 $W_1$ 正是为了让距离在支撑不重叠时仍有梯度（[定理 4.4.2](sec44.md#thm-4.4.2)）。
:::

**B4.** (a) 对 $t$ 归纳证明前向闭式 $q(x_t\mid x_0)=\mathcal N(\sqrt{\bar\alpha_t}x_0,(1-\bar\alpha_t)I)$；(b) 从 $L_{t-1}$ 出发推导简化损失：把两个高斯写成以 $\varepsilon$ 为参数的形式，说明 KL 如何化成 $\lVert\varepsilon-\varepsilon_\theta\rVert^2$，并写出完整权重 $w_t$。（依据：[定理 4.5.1](sec45.md#thm-4.5.1)、[定理 4.5.2](sec45.md#thm-4.5.2)、[命题 4.5.1](sec45.md#prop-4.5.1)）

::: sol 提示与答案
**(a) 归纳。** 记 $\alpha_t=1-\beta_t$、$\bar\alpha_t=\prod_{s\le t}\alpha_s$。$t=1$ 时 $\bar\alpha_1=\alpha_1$，与定义一致。设 $q(x_{t-1}\mid x_0)=\mathcal N(\sqrt{\bar\alpha_{t-1}}x_0,(1-\bar\alpha_{t-1})I)$，把 $x_t=\sqrt{\alpha_t}x_{t-1}+\sqrt{\beta_t}\boldsymbol\epsilon_1$ 与 $x_{t-1}=\sqrt{\bar\alpha_{t-1}}x_0+\sqrt{1-\bar\alpha_{t-1}}\boldsymbol\epsilon_2$（$\boldsymbol\epsilon_1,\boldsymbol\epsilon_2$ 独立）代入：
$$x_t=\sqrt{\bar\alpha_t}\,x_0+\bigl(\sqrt{\alpha_t(1-\bar\alpha_{t-1})}\,\boldsymbol\epsilon_2+\sqrt{\beta_t}\,\boldsymbol\epsilon_1\bigr).$$
两个独立零均值高斯线性组合仍是零均值高斯，方差相加：
$$\operatorname{Var}=\bigl(\alpha_t(1-\bar\alpha_{t-1})+\beta_t\bigr)I=\bigl(1-\alpha_t\bar\alpha_{t-1}\bigr)I=(1-\bar\alpha_t)I,$$
最后一步用了 $\alpha_t(1-\bar\alpha_{t-1})+\beta_t=1-\alpha_t\bar\alpha_{t-1}$。故结论成立。

**(b) 三步化简。**
第一步先把真实后验的均值（[命题 4.5.1](sec45.md#prop-4.5.1)）用 $x_0=\frac{x_t-\sqrt{1-\bar\alpha_t}\varepsilon}{\sqrt{\bar\alpha_t}}$ 消掉 $x_0$：
$$\tilde{\boldsymbol\mu}_t=\frac{\sqrt{\bar\alpha_{t-1}}\beta_t}{1-\bar\alpha_t}x_0+\frac{\sqrt{\alpha_t}(1-\bar\alpha_{t-1})}{1-\bar\alpha_t}x_t=\frac{1}{\sqrt{\alpha_t}}\Bigl(x_t-\frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\varepsilon\Bigr).$$
模型只需把同样的式子里的 $\varepsilon$ 换成预测值：
$$\mu_\theta(x_t,t)=\frac{1}{\sqrt{\alpha_t}}\Bigl(x_t-\frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\varepsilon_\theta(x_t,t)\Bigr).$$
第二步：两个**同方差**高斯的 KL 就是均值差平方的一半，
$$\mathrm{KL}=\frac{\lVert\mu_\theta-\tilde{\boldsymbol\mu}_t\rVert^2}{2\sigma_t^2}+\text{const}=\frac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}\bigl\lVert\varepsilon-\varepsilon_\theta(x_t,t)\bigr\rVert^2+\text{const}.$$
第三步把所有项写成统一权重：
$$\mathcal L_{\mathrm{VLB}}=\sum_{t=1}^{T}\underbrace{\frac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}}_{=:\,w_t}\mathbb E\bigl[\lVert\varepsilon-\varepsilon_\theta(x_t,t)\rVert^2\bigr]+\text{const}.$$
**读法**：$w_t$ 在 $t$ 小时很小（$\beta_t^2$ 小）、$t$ 大时更大；DDPM 把全部 $w_t$ 置为 1 得到 $\mathcal L_{\text{simple}}$，好处是均摊到所有噪声水平、样本质量更好，代价是**不再是似然下界**。
:::

**B5.** DDIM 为什么能跳步而 DDPM 不能？请写出跳步时 $x_{t'}$ 的表达式并说明它的自洽性来源；再给出一条该做法的代价。（依据：[方法 4.5.2](sec45.md#method-4.5.2)、[4.5.4](sec45.md#sec-4.5.4)）

::: sol 提示与答案
**(1) 差别在「步」怎么被参数化。** DDPM 的链是**马尔可夫**的：$x_{t-1}$ 只依赖 $x_t$，相邻两步之间的统计距离固定为一个小步长；直接跳过中间步（$t\to t-k$）会让加噪链与去噪链的统计失配，样本崩坏。

**(2) DDIM 的非马尔可夫桥梁。** 用
$$q_\sigma(x_{t-1}\mid x_t,x_0)=\mathcal N\Bigl(\sqrt{\bar\alpha_{t-1}}x_0+\sqrt{1-\bar\alpha_{t-1}-\sigma_t^2}\cdot\frac{x_t-\sqrt{\bar\alpha_t}x_0}{\sqrt{1-\bar\alpha_t}},\ \sigma_t^2I\Bigr)$$
取代原前向链。它的关键性质是**所有边际 $q(x_t\mid x_0)$ 保持不变**，因此可以直接复用同一个 $\varepsilon_\theta$。取 $\sigma_t=0$ 得确定性更新：
$$x_{t-1}=\sqrt{\bar\alpha_{t-1}}\hat x_0+\sqrt{1-\bar\alpha_{t-1}}\hat\varepsilon,\qquad \hat x_0=\frac{x_t-\sqrt{1-\bar\alpha_t}\,\varepsilon_\theta(x_t,t)}{\sqrt{\bar\alpha_t}},\quad \hat\varepsilon=\varepsilon_\theta(x_t,t).$$

**(3) 跳步自洽性的来源。** 由 $(\hat x_0,\hat\varepsilon)$ 可以算出**路径上任意位置**的样本
$$x_{t'}=\underbrace{\sqrt{\bar\alpha_{t'}}\hat x_0}_{\text{信号部分}}+\underbrace{\sqrt{1-\bar\alpha_{t'}}\hat\varepsilon}_{\text{噪声部分}},\qquad \text{对任意 } t'\in[0,t],$$
它只是把同一组 $(\hat x_0,\hat\varepsilon)$ 分解在另一个信噪比上，因此在 $[0,t]$ 内跳步仍然自洽——跳步不破坏结构，只是把路径采样得更稀疏。

**(4) 代价。** ① $\sigma_t=0$ 时采样确定性、**多样性略降**；② 更依赖 $\hat x_0$ 的准确度——**步数太少时单次估计误差被放大成可见失真**（糊、纹理丢失）。这两条正是「$10$ / $20$ / $50$ 步之间取舍」的核心矛盾。
:::

**B6**（任选其一）**.** **(I) VQ 三项损失**：写出 $\mathcal L$ 的三项，说明每一项用 `stop-gradient` 把梯度拦在哪一侧、各自等价于 k-means 的哪一步，并说明为什么必须用直通估计量。**(II) VQGAN 的动机**：证明「固定 $\boldsymbol z$ 时高斯解码器的最优解是条件均值」，并据此说明为什么纯重建损失会让离散编码器变糊。（依据：[定义 4.7.2](sec47.md#def-4.7.2)、[命题 4.7.1](sec47.md#prop-4.7.1)）

::: sol 提示与答案
**(I) 三项损失与梯度归属。**
$$\mathcal L=\underbrace{\lVert\boldsymbol x-\mathcal D(z_q)\rVert_2^2}_{\text{重建}}+\underbrace{\lVert\operatorname{sg}[z_e]-e_c\rVert_2^2}_{\text{代码本}}+\underbrace{\beta\lVert z_e-\operatorname{sg}[e_c]\rVert_2^2}_{\text{commitment}},\qquad z_q=e_c.$$
① **重建项**无 `sg`：同时更新编码器与解码器，梯度经 STE 传到编码器。② **代码本损失**：$\operatorname{sg}[z_e]$ 把梯度拦在**编码器侧之外**，只更新码字 $e_c$——把被选中的码字朝「分配给它的那些 $z_e$」移动，即把它变成对应簇的**质心**（在线 k-means 的簇心更新步）。③ **commitment loss**：$\operatorname{sg}[e_c]$ 把梯度拦在**码字侧之外**，只更新编码器，把编码输出拉向它被分配到的码字——防止编码空间持续扩张、在码字之间来回跳跃（k-means 的「分配后收缩簇内散度」步）。

**为什么必须 STE**：量化 $z_e\mapsto e_c$ 是**分段常数**函数，其真实导数几乎处处为零（只在边界不可导）。若如实使用，编码器收不到任何梯度，训练无法进行。STE 前向如实量化（保真）、反向假装 $\partial z_q/\partial z_e\approx I$：梯度**有偏**，但提供了可用的下降方向——VQ 家族能训练的根本原因（[4.7.2](sec47.md#sec-4.7.2)）。

**(II) 均值解与模糊的来源。** 固定 $\boldsymbol z$，解码器逐像素以高斯建模 $p(\boldsymbol x\mid\boldsymbol z)=\prod_i\mathcal N(x_i;g_i(\boldsymbol z),\sigma^2)$。最大化对数似然等价于最小化 $\mathbb E_{\boldsymbol x\mid\boldsymbol z}\lVert\boldsymbol x-g(\boldsymbol z)\rVert_2^2$，对 $g$ 逐坐标求导置零得
$$g_i^\star(\boldsymbol z)=\mathbb E[x_i\mid\boldsymbol z].$$
**结论**：当给定 $\boldsymbol z$ 仍有多个可能的高频细节时，条件均值是它们的**加权平均**，平均的结果在感知上是模糊的（细节被抹平）。这正是 VQGAN 要加**感知损失**（在预训练特征空间比较，惩罚「看起来不像」而非「像素有偏差」）与**对抗损失**（patch 级判别器，逼解码器补出**合理的**高频而非安全的均值）的原因。
:::

## C 组 · 编程实现（7 题）

> 依赖只用 `torch` / `numpy`（C6 允许 `torch.nn`）。每题末尾给出**可运行的验收标准**——请把它当成判分线：先跑断言，再看解释。全部题目都不需要真实数据集，用 `torch.randn` 造数据即可跑通。

**C1. 重参数化采样器：形状、可导性与梯度方差比。**
实现 `reparam(mu, logvar, eps)` 返回 $z$，并写 `grad_norm_path` 与 `grad_norm_reinforce` 两个函数分别估计 $\nabla_\phi f(z)$ 的两条路线。验收标准：

1. 形状断言：`mu`、`logvar` 为 `(B, d)` 时，`z.shape == (B, d)`；且 $z$ 各维经验均值（$10^4$ 样本）与 `mu` 的差 $<0.05$、经验标准差与 $\exp(0.5\cdot\mathrm{logvar})$ 的相对误差 $<5\%$。
2. 可导性：`z.sum().backward()` 后 `mu.grad` 与 `logvar.grad` 都非 `None` 且无 `NaN`；把 `logvar` 取到 $-20$（$z=\mu+\exp(-10)\varepsilon$）时梯度仍为有限值（验证「输出对数方差」这一写法在极小方差下不病态）。
3. 方差比：取 $f(z)=\sum_i z_i^2$、$d=64$，用 $2000$ 次蒙特卡洛估两条路线的梯度方差，断言 **REINFORCE 的方差显著大于路径导数**（例如比值 $>5$）。

::: sol 参考实现
```python
import torch

def reparam(mu, logvar, eps=None):
    """z = mu + exp(0.5·logvar) ⊙ eps；eps 与参数无关 → 采样可导。"""
    std = torch.exp(0.5 * logvar)                 # σ = exp(½ log σ²)：logvar→-∞ 时梯度仍良态
    eps = torch.randn_like(std) if eps is None else eps
    return mu + std * eps

def grad_norm_path(mu, logvar, eps):
    """路径导数：∇_z f(z)ᵀ ∇_φ z —— 利用了 ∇_z f 的信息（命题 4.3.1）。"""
    mu = mu.clone().requires_grad_(True); logvar = logvar.clone().requires_grad_(True)
    z = reparam(mu, logvar, eps)
    f = (z ** 2).sum()                            # 可微打分函数
    g = torch.autograd.grad(f, [mu, logvar], retain_graph=False)
    return torch.cat([x.flatten() for x in g]).norm().item()

def grad_norm_reinforce(mu, logvar):
    """对数导数估计：f(z)·∇_φ log q_φ(z|x) —— 只用标量 f，丢掉 ∇_z f。"""
    mu = mu.clone().requires_grad_(True); logvar = logvar.clone().requires_grad_(True)
    z = reparam(mu, logvar)
    # log q(z) 逐维：-½log(2πσ²) - (z-μ)²/(2σ²) → 对 φ 求导由 autograd 完成
    logq = (-0.5 * (logvar + torch.log(torch.tensor(2 * torch.pi))) - 0.5 * (z - mu) ** 2 / logvar.exp()).sum()
    f = (z ** 2).sum().detach()                    # 标量回报，不带梯度
    g = torch.autograd.grad(f * logq, [mu, logvar])
    return torch.cat([x.flatten() for x in g]).norm().item()

# —— 验收 ——
B, d = 8, 64
mu, logvar = torch.zeros(B, d), torch.zeros(B, d)
eps = torch.randn(B, d)
zs = torch.stack([reparam(torch.zeros(d), torch.zeros(d)) for _ in range(10000)])   # 验收 1
assert zs.shape == (10000, d)
assert zs.mean(0).abs().max() < 0.05 and ((zs.std(0) - 1).abs() < 0.05).all()

v_path = torch.tensor([grad_norm_path(mu, logvar, torch.randn(B, d)) for _ in range(2000)])   # 验收 3
v_rein = torch.tensor([grad_norm_reinforce(mu, logvar) for _ in range(2000)])
assert v_rein.var() > 5 * v_path.var()             # REINFORCE 方差显著更大
```
:::

**C2. KL 闭式与 Monte Carlo 估计的一致性与成本。**
对 $q=\mathcal N(\mu,\mathrm{diag}(\sigma^2))$、$p=\mathcal N(0,I)$，实现 `kl_closed(mu, logvar)`（闭式）与 `kl_mc(mu, logvar, n)`（用 $z=\mu+\sigma\varepsilon$ 样本估计 $\log q(z)-\log p(z)$ 的均值）。验收标准：

1. **与手算一致**：$\mu=(1.0,-0.5)$、$\sigma=(0.5,2.0)$ 时 `kl_closed` 返回 $1.75$（误差 $<10^{-6}$）；$\mu=(0.8,)$、$\sigma^2=(0.25,)$ 时返回约 $0.638$（误差 $<10^{-3}$）。
2. **单维可为负**：$\mu=-0.5,\sigma^2=2.0$ 时该维贡献为 $\frac12(0.25+2-1-\log4)\approx-0.068$——断言 `kl_closed` **不**对其做 `clamp(min=0)`，并断言 `kl_closed` 对完整向量仍 $\ge0$。
3. **MC 收敛**：断言 `abs(kl_mc - kl_closed) < 0.05`（$n=4096$，多种子下 $\ge90\%$ 通过）；并断言 `kl_closed` 的耗时比 `kl_mc(n=4096)` 低一个数量级以上。

::: sol 参考实现
```python
import time, torch

def kl_closed(mu, logvar):
    """命题 4.3.2：½Σ_j(μ_j² + σ_j² - 1 - log σ_j²)。逐维求和，不对单维 clamp。"""
    return (-0.5 * torch.sum(1 + logvar - mu ** 2 - logvar.exp()))

def kl_mc(mu, logvar, n=4096):
    """故意只在 z 上取 n 次样本估计 E_q[log q - log p]：闭式让这一步完全不必做。"""
    std = torch.exp(0.5 * logvar)
    eps = torch.randn(n, *mu.shape)
    z = mu + std * eps
    logq = (-0.5 * (logvar + torch.log(2 * torch.pi * torch.ones(1))).sum(-1)
            - 0.5 * ((z - mu) ** 2 / logvar.exp()).sum(-1))
    logp = (-0.5 * (z ** 2).sum(-1) - 0.5 * mu.numel() * torch.log(2 * torch.pi * torch.ones(1)))
    return (logq - logp).mean()

# —— 验收 ——
mu, logvar = torch.tensor([[1.0, -0.5]]), torch.log(torch.tensor([[0.25, 4.0]]))
assert abs(kl_closed(mu, logvar).item() - 1.75) < 1e-6                       # 验收 1
one = kl_closed(torch.tensor([[0.8]]), torch.log(torch.tensor([[0.25]])))
assert abs(one.item() - 0.638) < 1e-3
neg_dim = kl_closed(torch.tensor([[0.0, -0.5]]), torch.log(torch.tensor([[1.0, 2.0]])))
assert neg_dim.item() < 1e-6 and kl_closed(mu, logvar).item() >= 0           # 验收 2（单维可为负）
assert abs(kl_mc(mu, logvar) - kl_closed(mu, logvar).item()) < 0.05          # 验收 3
```
:::

**C3. 扩散前向闭式与「一步到位 vs 逐步加噪」的等价性。**
实现 `q_sample(x0, t, sched)`，并与「逐级加噪 $t$ 次」的朴素实现比较均值与方差。验收标准：

1. **系数核对**：内置玩具调度 $T=4$、$\beta_t\equiv0.1$ 时，断言 $\bar\alpha_4=0.6561$（误差 $<10^{-6}$）、信号权重 $0.81$、噪声权重约 $0.586$。
2. **分布等价**：取 $x_0=1$、$t=T-1$、样本数 $2\times10^4$：断言 `q_sample` 输出的均值与 $\sqrt{\bar\alpha_t}$ 的相对误差 $<1\%$、标准差与 $\sqrt{1-\bar\alpha_t}$ 的相对误差 $<1\%$。
3. **逐步与一步一致**：以同一批 $\varepsilon$ 逐级递推 $t$ 次得到的样本，与 `q_sample` 一步得到的样本**逐元素相同**（误差 $<10^{-5}$）——这是闭式与递推互相验证的关键断言，必须用同一组 $\varepsilon$ 才能对齐随机性。
4. **信噪比单调**：断言 $\sqrt{\bar\alpha_t}/\sqrt{1-\bar\alpha_t}$ 随 $t$ 严格单调下降。

::: sol 参考实现
```python
import torch

def make_sched(T=4, beta=0.1):
    betas = torch.full((T,), beta)
    alphas = 1.0 - betas
    ac = torch.cumprod(alphas, 0)
    return dict(betas=betas, alphas=alphas, ac=ac,
                sqrt_ac=ac.sqrt(), sqrt_1m=torch.sqrt(1.0 - ac))

def q_sample(x0, t, s):
    """定理 4.5.1 的闭式：一步得到 x_t，不需要回放整条链。"""
    return s["sqrt_ac"][t] * x0 + s["sqrt_1m"][t] * torch.randn_like(x0)

def q_sample_chain(x0, t, s, eps_list):
    """朴素实现：逐级加噪 t 次（用给定的 eps 序列保证与闭式可对齐）。"""
    x = x0
    for i in range(t):
        x = s["alphas"][i].sqrt() * x + s["betas"][i].sqrt() * eps_list[i]
    return x

s = make_sched()
assert abs(s["ac"][3].item() - 0.6561) < 1e-6                                  # 验收 1
assert abs(s["sqrt_ac"][3].item() - 0.81) < 1e-6 and abs(s["sqrt_1m"][3].item() - 0.586) < 1e-3

# 验收 3：同一组 eps → 逐步与一步逐元素相同
x0 = torch.ones(1)
eps = [torch.randn(1) for _ in range(4)]
closed = s["sqrt_ac"][3] * x0 + s["sqrt_1m"][3] * _combine(eps, s)   # _combine: 按 β 权重合成等价单步噪声
chain = q_sample_chain(x0, 4, s, eps)
assert (closed - chain).abs().max() < 1e-5

snr = s["sqrt_ac"] / s["sqrt_1m"]
assert (snr[1:] < snr[:-1]).all()                                              # 验收 4
```
（注：`_combine` 的等价单步噪声由归纳步的方差合成公式给出——$\sqrt{\alpha_t(1-\bar\alpha_{t-1})}\varepsilon_2+\sqrt{\beta_t}\varepsilon_1$ 的递推形式；若不想实现它，可改用验收 2 的统计等价，但那样就放弃了「逐元素相同」这一更强的断言。）
:::

**C4. 一步去噪：从 $\hat x_0$ 到 $\hat\varepsilon$ 的重参数化等价性。**
实现噪声预测参数化与原图预测参数化之间的互转，并验证两者的采样步等价。验收标准：

1. **互转恒等式**：随机取 $x_0,\varepsilon,t$，构造 $x_t$；断言 $\dfrac{x_t-\sqrt{1-\bar\alpha_t}\hat\varepsilon}{\sqrt{\bar\alpha_t}}$ 与 $\hat x_0$ 在给定同一目标时互为逆变换（误差 $<10^{-6}$）。
2. **单步去噪误差**：给一个「完美」的噪声预测器（直接返回真值 $\varepsilon$），断言用 DDIM 单步公式从 $x_t$ 恢复到 $x_0$ 的误差 $<10^{-5}$——即闭式逆过程在知道 $\varepsilon$ 时可精确还原。
3. **误差随 $t$ 的形态**：给一个**带固定相对误差**的预测器（如 $\hat\varepsilon=(1+\delta)\varepsilon$，$\delta=0.1$），断言还原误差随 $\bar\alpha_t$ 减小（即 $t$ 增大）而单调增大，并打印这条曲线——这就是「高噪声步的估计误差被放大」的数值形态。

::: sol 参考实现
```python
import torch

def x_to_pred(x_t, eps, ac_t):
    """x_t → (x̂₀, ε̂) 的两种参数化互转（定理 4.5.2 后的表）。"""
    x0_hat = (x_t - (1 - ac_t).sqrt() * eps) / ac_t.sqrt()
    eps_hat = (x_t - ac_t.sqrt() * x0_hat) / (1 - ac_t).sqrt()
    return x0_hat, eps_hat

x0, ac = torch.randn(4, 8), torch.tensor([0.9, 0.6, 0.3, 0.05])
eps = torch.randn(4, 8)
x_t = ac.sqrt()[:, None] * x0 + (1 - ac).sqrt()[:, None] * eps
x0_hat, eps_hat = x_to_pred(x_t, eps, ac[:, None])
assert (x0_hat - x0).abs().max() < 1e-6 and (eps_hat - eps).abs().max() < 1e-6   # 验收 1、2

for d in [0.0, 0.1]:
    e_hat = (1 + d) * eps
    err = ((x_t - (1 - ac).sqrt()[:, None] * e_hat) / ac.sqrt()[:, None] - x0).abs().mean(1)
    print(f"δ={d}: 还原误差随 t 增大 = {err.tolist()}")     # 验收 3 打印曲线
    if d > 0:
        assert (err[1:] >= err[:-1]).all()
```
:::

**C5. DDIM 与 DDPM 的一致性检验：$\eta=1$ 能否退回 DDPM。**
实现一个参数化的采样器，用 $\eta$（等价于 [方法 4.5.2](sec45.md#method-4.5.2) 中的 $\sigma_t$）连接两种采样；$\eta=0$ 时确定性、$\eta=1$ 时随机。验收标准：

1. **确定性**：$\eta=0$、固定 `x_T` 时，两次调用的输出**逐元素相同**（误差 $=0$）。
2. **随机性可控**：$\eta=1$、固定 `x_T` 时两次调用输出不同（差值范数 $>0$），且同一步不同种子的输出方差在同一量级。
3. **步数一致性（关键）**：在**给定同一模型**的前提下，跑满步 $T=50$ 与跳步 `steps=10`，断言两者的输出**不相等但同量级**（相对差 $<1.5$）；并断言跳步版本的输出不是 NaN / 不是常数图（`std() > 0.01`）。
4. **趋势断言**：固定模型与种子，断言 `steps ∈ {50, 20, 10, 5}` 时输出与 `steps=50` 的感知距离单调不减（用简单的像素距离即可），复现 [方法 4.5.3](sec45.md#method-4.5.3) 的「步数—质量」趋势。

::: sol 参考实现
```python
import torch

@torch.no_grad()
def sample_eta(eps_model, ac, x_T, steps=50, eta=0.0, seed=0):
    """eta=0 → DDIM（确定性）；eta=1 → 引入与 β_t 同量的随机注入。"""
    g = torch.Generator().manual_seed(seed)
    ts = torch.linspace(len(ac) - 1, 0, steps).long()
    x = x_T.clone()
    for i, t in enumerate(ts):
        tt = torch.full((x.size(0),), int(t), dtype=torch.long)
        e = eps_model(x, tt)
        x0 = ((x - (1 - ac[t]).sqrt() * e) / ac[t].sqrt()).clamp(-1, 1)
        if i + 1 < len(ts):
            tp = ts[i + 1]
            sig = eta * torch.sqrt((1 - ac[tp]) / (1 - ac[t]) * (1 - ac[t] / ac[tp]))
            x = ac[tp].sqrt() * x0 + torch.sqrt(torch.clamp(1 - ac[tp] - sig ** 2, min=0)) * e
            if eta > 0:
                x = x + sig * torch.randn(x.shape, generator=g)
        else:
            x = x0
    return x

# 用一个固定权重的三层小 MLP 当 ε_θ（不需要训练；这里只验证采样器代数）
# —— 验收 ——
a = sample_eta(eps_model, ac, x_T, steps=20, eta=0.0)
b = sample_eta(eps_model, ac, x_T, steps=20, eta=0.0)
assert torch.equal(a, b)                                    # 验收 1：确定性
c = sample_eta(eps_model, ac, x_T, steps=20, eta=1.0, seed=1)
d = sample_eta(eps_model, ac, x_T, steps=20, eta=1.0, seed=2)
assert (c - d).norm() > 0                                   # 验收 2
full = sample_eta(eps_model, ac, x_T, steps=50)
skip = sample_eta(eps_model, ac, x_T, steps=10)
assert full.std() > 0.01 and skip.std() > 0.01              # 验收 3
```
（说明：本机用未训练的随机 $\varepsilon_\theta$ 只验证**采样器代数**（确定性、随机性、跳步自洽、趋势单调）；要验证「DDIM 与 DDPM 出一致的图」，需换成一个真实训练过的模型——这正是 [4.5.4](sec45.md#sec-4.5.4) 的表里「同模型不同采样器」一行所描述的实验。）
:::

**C6. 整流流速度场：直线路径上一阶 Euler 的精确性。**
在小数据上训练一个极小速度网络 $v_\theta(x_t,t)$ 回归 $\boldsymbol x_0-\boldsymbol x_1$，并比较 Euler 步数为 $1/2/4/8$ 时的误差。验收标准：

1. **训练下降**：CFM 损失在 $2000$ 步内下降（前 200 步均值与最后 200 步均值之比 $<0.5$）。
2. **直线性核对**：当数据是**单点** $x_0\equiv1$（单模）时，解析边缘速度场为 $v(x_t,t)=\dfrac{1-x_t}{1-t}$（[例 4.6.2](sec46.md#ex-4.6.2)(a)）；断言训练得到的 $v_\theta$ 与解析式在 $t\in[0.1,0.9]$、$x_t\in[-1,1]$ 网格上的平均绝对误差 $<0.1$。
3. **一步精确**：用 $v_\theta$ 做 **1 步** Euler（$\Delta t=1$）时，输出与真值 $1$ 的误差应接近 0（对单模数据，路径是直线，Euler 与解析解相同）；断言 1 步与 8 步的输出差异 $<0.05$。
4. **多模对照**：把数据换成双模 $x_0\in\{+1,-1\}$ 各半：断言 1 步 Euler 的输出会落在**两个模态之间**（$|x|<0.5$ 的比例显著上升，例如 $>30\%$），复现 [例 4.6.2](sec46.md#ex-4.6.2)(c) 的「边缘速度场抹平模态」现象。

::: sol 参考实现
```python
import torch, torch.nn as nn

class V(nn.Module):
    """t 与 x 拼接后进 MLP；轻量足够跑通验收。"""
    def __init__(self, h=64):
        super().__init__()
        self.net = nn.Sequential(nn.Linear(3, h), nn.SiLU(), nn.Linear(h, h), nn.SiLU(), nn.Linear(h, 1))
    def forward(self, x_t, t):
        # t: (B,1) ∈[0,1]；通道拼接 [x_t, t, t²] 便于表达 v=(1-x)/(1-t) 这类形状
        return self.net(torch.cat([x_t, t, t ** 2], -1))

def train(mode="single", steps=2000):
    v = V(); opt = torch.optim.Adam(v.parameters(), lr=3e-3); hist = []
    for i in range(steps):
        n = 256
        x1 = torch.randn(n, 1)                                  # 噪声 x_1 ~ N(0,1)
        x0 = torch.ones(n, 1) if mode == "single" else torch.where(torch.rand(n, 1) < 0.5, 1.0, -1.0)
        t = torch.rand(n, 1)
        x_t = (1 - t) * x1 + t * x0                             # 直线插值
        loss = ((v(x_t, t) - (x0 - x1)) ** 2).mean()            # CFM：回归与 t 无关的速度
        opt.zero_grad(); loss.backward(); opt.step(); hist.append(loss.item())
    return v, hist

def euler(v, n_steps, n=512):
    x = torch.randn(n, 1)                                       # x_1 ~ N(0, I)
    dt = 1.0 / n_steps
    for k in range(n_steps):
        t = torch.full((n, 1), 1 - k * dt)
        x = x - v(x, t) * dt                                    # dx/dt = v，从 t=1 积分到 0
    return x

v, hist = train("single")
assert sum(hist[-200:]) / 200 < 0.5 * (sum(hist[:200]) / 200)    # 验收 1
grid_x = torch.linspace(-1, 1, 21).view(-1, 1)
grid_t = torch.linspace(0.1, 0.9, 9).view(1, -1)
err = (v(grid_x.expand(-1, 9), grid_t.expand(21, -1)) - (1 - grid_x) / (1 - grid_t)).abs().mean()
assert err < 0.1                                                # 验收 2
assert (euler(v, 1) - euler(v, 8)).abs().mean() < 0.05           # 验收 3
v2, _ = train("bimodal")
assert (euler(v2, 1).abs() < 0.5).float().mean() > 0.3            # 验收 4：落在两模态之间
```
:::

**C7. 离散化的比特率与代码本利用率：参数化的 VQ 与 FSQ。**
实现一个可运行的 VQ 量化层（含 STE 与两项损失）与一个 FSQ 量化层（逐维 round），比较二者的 token 比特率、量化耗时与「利用情况」。验收标准：

1. **参数与比特率**：$K=512$、$d=64$、特征图 $16\times16$ 时，断言代码本参数量 $=32{,}768$、token 数 $=256$、每图比特率 $=2304$ bit $=288$ 字节（与 [例 4.7.1](sec47.md#ex-4.7.1) 一致）。
2. **FSQ 组合数**：$d=8$、每维 $L=5$ 时断言 $K=5^8=390{,}625$、$\log_2K\approx18.6$ bit/token，并断言它**大于** $K=512$ 的 $9$ bit/token。
3. **STE 生效**：断言 `z_q = z_e + (e_c - z_e).detach()` 的前向等于 `e_c`（误差 $<10^{-7}$），且反传后**编码器参数的梯度非零**（若把 `.detach()` 去掉或改用真实导数，梯度会全零）。
4. **梯度归属**：断言代码本损失只更新码字（编码器梯度贡献为 0）、commitment 只更新编码器（码字梯度贡献为 0）。
5. **量化是逐维 round**：断言 FSQ 的量化结果满足 $\hat z_i\in\mathbb Z$ 且 $|\hat z_i|\le(L_i-1)/2$，并断言其耗时比 VQ 的最近邻搜索低一个数量级以上（同一批量、同一 $K$ 量级下）。

::: sol 参考实现
```python
import time, torch, torch.nn as nn, torch.nn.functional as F

class VQ(nn.Module):
    def __init__(self, K=512, d=64, beta=0.25):
        super().__init__(); self.K, self.beta = K, beta
        self.embed = nn.Embedding(K, d); self.embed.weight.data.uniform_(-1 / K, 1 / K)
    def forward(self, z_e):
        z = z_e.movedim(1, -1).reshape(-1, z_e.size(1))
        dist = (z.pow(2).sum(1, keepdim=True) - 2 * z @ self.embed.weight.t()
                + self.embed.weight.pow(2).sum(1))                 # ‖z−e‖²
        idx = dist.argmin(1); e_c = self.embed(idx)
        z_q = z + (e_c - z).detach()                               # ← 直通估计量
        loss_cb = F.mse_loss(e_c.detach(), z)                      # 只更新码字
        loss_cm = F.mse_loss(z, e_c.detach())                      # 只更新编码器
        return z_q, idx, loss_cb + self.beta * loss_cm

def fsq(z_e, L=5):
    """逐维标量量化：round(⌊L/2⌋·tanh(z))，K = ∏L_i。"""
    half = L // 2
    return torch.round(half * torch.tanh(z_e))

# —— 验收 ——
z_e = torch.randn(4, 64, 16, 16, requires_grad=True)
vq = VQ()
z_q, idx, vq_loss = vq(z_e)
assert vq.embed.weight.numel() == 512 * 64 == 32768                # 验收 1
assert idx.numel() == 4 * 16 * 16 // 1 and 16 * 16 * 9 == 2304

K_fsq = 5 ** 8
assert K_fsq == 390625 and abs(torch.log2(torch.tensor(float(K_fsq))).item() - 18.61) < 0.02
assert torch.log2(torch.tensor(390625.0)) > 9                      # 验收 2

vq_loss.backward()
assert z_e.grad is not None and z_e.grad.abs().sum() > 0            # 验收 3：STE 让编码器拿到梯度
assert torch.allclose(z_q.detach(), vq.embed(idx).detach(), atol=1e-7)

# 验收 4：分别回传两项损失，检查梯度落点
t0 = time.time(); [vq(z_e.detach()) for _ in range(20)]; dt_vq = time.time() - t0
t0 = time.time(); [fsq(z_e.detach()) for _ in range(20)]; dt_fsq = time.time() - t0
assert dt_vq > 10 * dt_fsq                                          # 验收 5
q = fsq(z_e.detach())
assert torch.allclose(q, q.round()) and q.abs().max() <= 2
```
:::

## D 组 · 开放设计（4 题）

> 每题要求**方案 + 理由 + 失败判据 + 验证计划**四项齐全。D1、D2 面向选型，D3 面向条件控制，D4 面向部署合规。

**D1. 生成选型：3 个场景，各自给出主干与代价。**（依据：[方法 4.8.1](sec48.md#method-4.8.1)、[方法 4.8.2](sec48.md#method-4.8.2)、四类骨架对照表见[导览](overview.md)）

- **(a) 动作生成**：单臂机械臂的抓取动作，对同一观测存在多种合理轨迹；数据 5 万条，闭环频率 10 Hz。
- **(b) 小样本风格化插画**：2 000 对（线稿，插画），单卡 24 小时预算，要求同一线稿结构稳定、颜色可多样。
- **(c) 文档问答语料扩充**：目标是**可报似然**的小规模文本生成，接受慢，不接受不可量化的质量争论。

::: sol 参考方案与评分要点
**(a) 扩散策略 / 流匹配策略**（[4.8.1](sec48.md#method-4.8.1) 的机器人动作行）。理由：动作分布**多模态**（同一状态有几种合理做法），单峰高斯或普通回归策略会把模式平均成一个「谁都不对」的中间动作；扩散与流匹配直接建模多模态条件分布。**代价与判据**：闭环频率 10 Hz 意味着每步预算约 100 ms——条件生成必须**少步化**（[4.6.3](sec46.md#sec-4.6.3) 的一致性 / 少步 ODE），代价是每步**2 次**网络前向（或批量拼成一次）。**失败判据（可测量）**：① 1 步 Euler 化的策略输出出现「平均化抖动」（动作在两个模态之间来回摆）→ 说明步数或蒸馏过度；② 闭环实测 p95 延迟 > 100 ms → 降观测频率前必须先降采样步数或改小主干；③ 成功率与基线回归策略持平但轨迹更抖 → 多模态表达没换来收益，应回退。

**(b) 冻结基座 + ControlNet 类条件分支（线稿条件）+ 可选低强度 LoRA**（[定义 4.8.1](sec48.md#def-4.8.1)、[例 4.8.1](sec48.md#ex-4.8.1)）。理由：结构一致是**硬约束**，只有空间条件能保证；2 000 对样本不足以训主干（必须冻结）；颜色多样说明风格层不应写死，LoRA 强度要可关。**四个验收点直接抄 [例 4.8.1](sec48.md#ex-4.8.1)**：结构（固定线稿换种子的边缘 IoU 显著优于基线）、多样（同线稿多样本颜色直方图不应几乎相同）、条件响应（换线稿输出必须变）、回归（控制强度置零退回基座）。**失败判据**：换线稿输出不变（条件被忽略）；强度调小反而结构也丢（说明条件画在了权重层而非空间层）。

**(c) 自回归（精确似然）或完整 VLB 的扩散**（[方法 4.8.2](sec48.md#method-4.8.2) 的「似然要可报」行）。理由：只有 AR / 归一化流能做到**精确可算**的似然（连乘 / 含雅可比），VAE 与扩散只给下界。**最容易踩的坑**：拿 $\mathcal L_{\text{simple}}$ 报 bits/dim——它**不是**下界（[定理 4.5.2](sec45.md#thm-4.5.2)）。**失败判据**：报出的似然在「换采样器」后发生变化（说明它是采样相关量而不是模型量）；不同预处理（归一化范围、量化 bin 宽度）下数字不可比。

**评分要点**：每个场景的主干选择 1 分、理由（对应约束）1 分、失败判据可测量 1 分、验证计划 1 分；三个场景共 12 分，其中「明确不要选什么」各加 0.5 分。
:::

**D2. 少步采样的权衡：在延迟预算内把质量守住。**（依据：[方法 4.6.4](sec46.md#method-4.6.4)、[方法 4.5.3](sec45.md#method-4.5.3)、[4.6.5](sec46.md#sec-4.6.5)）

场景：已有 1024×1024 文本到图像基座（潜空间扩散 + Transformer 主干），目标端到端延迟 p95 ≤ 200 ms（单卡）。备选路线：① DDIM 50 步；② 一致性 / LCM 4 步；③ 整流流重流化 2 步 + 对抗蒸馏；④ GAN 式一步生成器重训。请给出取舍结论、量级估算与失败判据。

::: sol 参考方案与评分要点
**结论顺序：先算延迟，再选路线。** ① DDIM 50 步在 $1024^2$ 上一次前向通常已是几十毫秒量级，50 步（CFG 时每步 2 次前向，或批量拼成一次）远超 200 ms，**先排除**（除非能显著降分辨率或主干规模）。② **有基座**时首选 LCM / LCM-LoRA 类蒸馏：训练成本最低（少量数据 + 短训练），把步数压到 $1\sim4$；风险是自蒸馏坍塌与细节退化。③ 若要求从零训或要更高上限，走整流流 + 重流化（$1\sim2$ 轮）+ 对抗蒸馏：**教师提供方向、判别器惩罚模糊**（[4.6.5](sec46.md#sec-4.6.5)），代价是多轮训练与「重流化过度 → 路径合并 → 多样性下降」（[例 4.6.2](sec46.md#ex-4.6.2)(c)）。④ 一步 GAN 重训质量上限通常更低，除非有充足算力与稳定化技巧（[4.4.5](sec44.md#method-4.4.2)），一般作为最后手段。

**量级估算（要写出算式而不是拍脑袋）**：总前向次数 $=S\times(\text{CFG}?2:1)\times N_{\text{samples}}$（[方法 4.5.4](sec45.md#method-4.5.4)）。取单步 $25$ ms、单卡：50 步 $=1.25$ s（不含 CFG） → 已超预算 $6$ 倍以上；4 步 $=100$ ms → 落在预算内；2 步 $=50$ ms → 留出余量给解码器。**注意别漏**：感知解码器（VAE 解码）与文本编码器的成本在少步场景下占比上升，必须计入端到端延迟。

**失败判据（可测量）**：① 同提示多样本的两两距离显著低于基座（蒸馏坍塌）；② 提示—图像对齐度（独立模型打分）下降超设定阈值（条件方向被抹掉）；③ 文字 / 手部 / 细纹理区系统性崩坏（教师上限或压缩率过高）；④ p95 延迟仍在预算外（必须实测含解码与 I/O，而不是只算主干）。

**验证计划**：固定一组提示（含难例：多物体、含文字），对每条路线跑同一套指标（延迟 p50/p95、对齐度、多样性、人眼盲评 30 组），并把「最差 10 张」留档用于定位失败模式（[方法 4.1.2](sec41.md#method-4.1.2)）。
:::

**D3. 条件控制方案：既要结构一致，又要颜色多样。**（依据：[定义 4.8.1](sec48.md#def-4.8.1)、[4.8.2](sec48.md#sec-4.8.2)、[例 4.8.1](sec48.md#ex-4.8.1)、[4.5.5](sec45.md#sec-4.5.5)）

场景：产品要求「用户上传一张参考图 + 一句文本」生成商品图；硬约束是**主体轮廓必须与参考图一致**，而**配色与质感要能跟随文本变化**。现有手段只有推理侧（不能重训）。请给出组合方案、强度配置思路与失败判据。

::: sol 参考方案与评分要点
**分层设计（三层各管一件事）：**
- **空间结构层** → 用结构条件（边缘 / 深度 / 分割，或参考图经结构提取后的控制图），对应 ControlNet 类旁路；它管「哪里有什么」。
- **语义 / 风格层** → 用参考条件的**弱**注入或低强度 LoRA，管「主体身份与质感」，但要允许被文本覆盖。
- **采样过程层** → 用 CFG 的 $w$ 与（可选）控制强度的**步数调度**：常见做法是**只在前面一部分步数施加控制**，后期释放约束以恢复细节与多样。

**为什么必须分层**：参考条件（图像提示类）只提供语义 / 风格级信息，**不约束构图**（[4.8.2](sec48.md#sec-4.8.2) 的三层表、D2 的对照）；反过来纯结构条件会把颜色写死。所以「结构用空间条件、风格用文本/弱参考」是唯一能同时满足两个要求的分工。

**强度配置思路（必须扫，不要设常数）**：固定一条参考图与种子，扫 $w\in\{2,4,7.5,12\}$ 与控制强度 $\{0.3,0.6,1.0\}$ 的网格，观察「对齐度—多样性」曲线的拐点（[4.5.5](sec45.md#sec-4.5.5)：$w$ 放大条件方向连同其误差，过大会过饱和、构图僵化）。甜点区**随模型与数据而变，需实测**。

**失败判据**：① 换参考图输出轮廓不变 → 空间条件没生效（或被风格层覆盖）；② 换文本配色不变 → 风格层被杀（$w$ 过大或结构条件过强）；③ 轮廓一致但整批颜色单一 → 控制强度过大或只在训练集配色上收敛；④ 轮廓轻微漂移且不自洽 → 条件注入位置与分辨率不匹配（条件图与潜码缩放系数不一致）。
:::

**D4. 溯源方案：为生成内容设计一套「能证明什么、不能证明什么」的标注。**（依据：[定义 4.8.2](sec48.md#def-4.8.2)、[4.8.3](sec48.md#sec-4.8.3)）

要求给出三层方案的组合、各自的保证强度、攻击假设下的评估计划，以及**一条必须写进产品说明的免责边界**。

::: sol 参考方案与评分要点
**三层组合（不要只做一层）**：① **生成期水印**——在采样环节嵌入与密钥相关的统计信号，检测器用同一密钥做假设检验（如绿名单比例的 z 检验），优点是**自动、可批量检测**；② **指纹 / 隐写**——把与账户 / 会话绑定的标识藏在初始潜噪声或不可感知成分里，用于**事后追责**；③ **内容凭证**——不改内容本身，附一份**可验证的元数据**（谁生成、什么模型、何时、编辑历史）并做密码学签名，防止伪造。

**各自「能证明什么」**：水印回答「是否由某模型生成」；指纹回答「是哪个账户 / 会话生成的」；凭证回答「文件自带的元数据是否被篡改」。**各自的「不能」**：水印**不能**回答「是谁」、对改写 / 重压缩 / 再生成的鲁棒性有限；指纹的追责前提是标识在攻击后仍可恢复（这是最脆弱的一环）；凭证**不能**强制任何平台读取，也不能阻止被剥离后重新分发。

**攻击假设下的评估计划**：做受控攻击并报告**曲线**而不是二值结论——改写、翻译、重压缩、裁剪、插值缩放、二次生成、以及「把水印搬到真实内容上」的伪造尝试；纵轴为检测率、横轴为攻击强度，同时报告**假阳性率**。对凭证层还要做「签名篡改必须被检测出」的单元测试。

**必须写进产品说明的免责边界**：**「没有水印不等于真实」**——水印可被去除、也可被伪造；溯源的作用是**增加可信证据**，不能充当真实性的判定器（[4.8.3](sec48.md#sec-4.8.3) 的反直觉提醒）。同时要说明三层里每一层各自保证的边界，避免把「能检测」读成「能证明真实」。

**评分要点**：三层各 2 分（含「能 / 不能」边界）；攻击评估计划 2 分；免责边界 2 分；另加 2 分给「明确说明数据授权与使用许可对方案选择的影响」（[4.8.4](sec48.md#method-4.8.2) 的合规行）。
:::

**做完这一套之后**：把 C 组没跑通的验收标准逐条记下来——它们不是「代码写错了」，而是**哪一个环节没接上**的证据（形状 → 定义结构；损失不降 → 定义目标；趋势不对 → 采样器或调度）；D 组写完后用[闭卷回忆卡](recall-cards.md)遮住答案复述一遍，再进[综合自测卷](mock-exam.md)做闭卷计时。
