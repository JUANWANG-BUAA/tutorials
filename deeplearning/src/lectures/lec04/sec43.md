# 4.3 变分自编码器：把潜空间变成可采样的空间

[4.2](sec42.md)的诊断很清楚：自编码器的潜空间是一张「只在对数据有效的窄带上成立的编码—解码表」，没有概率结构，从 $\mathcal N(0,I)$ 采一个 $z$ 解码出来是垃圾。修法也因此很直接——**给潜空间指定一个先验，并强迫编码结果贴近它**。这样潜空间每一处都有定义，我们就可以从先验里随便采点、解码出新样本。

这个想法一句话就说完，但要让它**可训练**，需要三样东西同时到位：一个可算的目标（ELBO）、一个让采样可导的技巧（重参数化）、一个能写出闭式的正则项（高斯 KL）。三样缺一，VAE 都训不起来——这是本节的主干。学完本节你应当能：独立推出 ELBO 并说清缺口是哪个 KL；解释重参数化为什么让「采样」这一步变得可导；手算一个样本的 VAE 损失；诊断后验坍塌。

## 4.3.1 从「一个点」到「一个分布」

::: def 定义 4.3.1 · 变分自编码器（variational autoencoder, VAE） {#def-4.3.1}
VAE 把编码器的输出从**一个点**换成**一个分布**，并给潜变量指定一个**简单先验**：

- **先验**（prior）：$p(z)=\mathcal N(\boldsymbol 0,I)$，$z\in\mathbb R^d$；
- **近似后验**（approximate posterior，即编码器）：$q_\phi(z\mid\boldsymbol x)=\mathcal N\bigl(\boldsymbol\mu_\phi(\boldsymbol x),\operatorname{diag}(\boldsymbol\sigma_\phi^2(\boldsymbol x))\bigr)$，网络输出均值与对数方差两组参数；
- **似然**（likelihood，即解码器）：$p_\theta(\boldsymbol x\mid z)$，连续数据取 $\mathcal N\bigl(g_\theta(z),\sigma_x^2I\bigr)$，二值 / 计数数据取 Bernoulli / 泊松。

模型要最大化的对象是数据的对数似然
$$\log p_\theta(\boldsymbol x)=\log\int p_\theta(\boldsymbol x\mid z)\,p(z)\,dz,$$
它对任意神经网络解码器都**不可解**（要对全部潜变量积分）。VAE 转而最大化它的**证据下界**（Evidence Lower BOund, ELBO）
$$\mathcal L_{\mathrm{ELBO}}=\underbrace{\mathbb E_{q_\phi(z\mid\boldsymbol x)}\bigl[\log p_\theta(\boldsymbol x\mid z)\bigr]}_{\text{重建项}}-\underbrace{\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p(z)\bigr)}_{\text{正则项}} .$$
训练目标是最大化 $\mathcal L_{\mathrm{ELBO}}$，等价于最小化 $\mathcal L_{\mathrm{VAE}}=-\mathcal L_{\mathrm{ELBO}}$。
:::

::: intuition VAE 是在「把潜空间填满、变连续」
把潜空间想成一张地图。AE 只在地图上标出了**训练样本的营地**，营地之间是空白；VAE 的 KL 项做的是另一件事——它要求每个样本的营地**互相重叠、并共同覆盖标准高斯的支撑**。

KL 项 $\frac12\sum_j(\mu_j^2+\sigma_j^2-1-\log\sigma_j^2)$ 是一个**双向的力**：$\mu_j^2$ 把每个样本的均值拉向原点，而 $\sigma_j^2-1-\log\sigma_j^2$ 在 $\sigma_j^2=1$ 处取最小值 $0$，把方差推向 $1$。结果是近似后验被压成一个个**互相重叠**的团，共同铺满 $\mathcal N(0,I)$ 的支撑。

于是潜空间里**没有空洞**：任意一个从先验采出的 $z$ 都落在某个样本的团附近，解码器在那里被训练过，输出合理。也正因相邻的 $z$ 解码相似，我们可以做**插值**——在两个潜码之间线性走一遍，解码结果平滑地从一张图过渡到另一张。

**三件套的分工**：先验 $p(z)$ 定**采样起点**，ELBO 定**优化目标**，重参数化让**目标可导**。三者缺一不可，这一点是本节的骨架。
:::

## 4.3.2 ELBO：从 $\log p(\boldsymbol x)$ 到下界

读者现在有两个立刻要问的问题：ELBO 是怎么冒出来的？为什么是它？下面给出**两种推导**——第一种通过 Jensen 不等式把它「造」出来，第二种把缺口精确定位成两个后验之间的距离。

::: thm 定理 4.3.1 · ELBO 是 log 似然的下界 {#thm-4.3.1}
对任意分布 $q_\phi(z\mid\boldsymbol x)$（不必是真后验），有
$$\log p_\theta(\boldsymbol x)\ \ge\ \mathcal L_{\mathrm{ELBO}}=\mathbb E_{q_\phi(z\mid\boldsymbol x)}\bigl[\log p_\theta(\boldsymbol x\mid z)\bigr]-\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p(z)\bigr),$$
且缺口恰为近似后验与真后验的距离：
$$\log p_\theta(\boldsymbol x)-\mathcal L_{\mathrm{ELBO}}=\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p_\theta(z\mid\boldsymbol x)\bigr)\ \ge\ 0 .$$
:::

::: proof 推导一（Jensen 不等式：把下界「造」出来）
目标不可直接算，因为要对全部潜变量积分：
$$\log p_\theta(\boldsymbol x)=\log\int p_\theta(\boldsymbol x\mid z)\,p(z)\,dz .$$
乘除同一个 $q_\phi(z\mid\boldsymbol x)$（把积分写成对它求期望），再用 Jensen 不等式把 $\log$ 移进期望：
$$\log p_\theta(\boldsymbol x)=\log\mathbb E_{q_\phi(z\mid\boldsymbol x)}\!\left[\frac{p_\theta(\boldsymbol x\mid z)\,p(z)}{q_\phi(z\mid\boldsymbol x)}\right]\ \ge\ \mathbb E_{q_\phi(z\mid\boldsymbol x)}\!\left[\log\frac{p_\theta(\boldsymbol x\mid z)\,p(z)}{q_\phi(z\mid\boldsymbol x)}\right].$$
把右边按 $\log(ab)=\log a+\log b$ 拆开，第二项正好凑出一个 KL：
$$\mathbb E_q\bigl[\log p_\theta(\boldsymbol x\mid z)\bigr]+\mathbb E_q\!\left[\log\frac{p(z)}{q_\phi(z\mid\boldsymbol x)}\right]=\underbrace{\mathbb E_q\bigl[\log p_\theta(\boldsymbol x\mid z)\bigr]}_{\text{重建项}}-\underbrace{\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p(z)\bigr)}_{\text{正则项}} .$$
**Jensen 取等号的条件正是 $q_\phi(z\mid\boldsymbol x)=p_\theta(z\mid\boldsymbol x)$**：近似后验越贴近真后验，下界越紧。

**推导二（贝叶斯分解：把缺口精确定位）**。由 $\log p_\theta(\boldsymbol x)=\mathbb E_q[\log p_\theta(\boldsymbol x)]$（与 $z$ 无关，期望是常数）且 $p_\theta(\boldsymbol x)=\dfrac{p_\theta(\boldsymbol x,z)}{p_\theta(z\mid\boldsymbol x)}$，有
$$\log p_\theta(\boldsymbol x)=\mathbb E_q\!\left[\log\frac{p_\theta(\boldsymbol x,z)}{q_\phi(z\mid\boldsymbol x)}\right]+\mathbb E_q\!\left[\log\frac{q_\phi(z\mid\boldsymbol x)}{p_\theta(z\mid\boldsymbol x)}\right]=\mathcal L_{\mathrm{ELBO}}+\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p_\theta(z\mid\boldsymbol x)\bigr).$$
其中第一个等号来自「乘除同一个 $q_\phi$」这一恒等变形（对任意 $q_\phi\gt0$ 都成立，无需任何近似）；第二个等号里，右边第二项按定义就是后验与近似后验之间的 KL，而第一项 $\mathbb E_q\!\left[\log\frac{p_\theta(\boldsymbol x,z)}{q_\phi(z\mid\boldsymbol x)}\right]$ 正是 $\mathcal L_{\mathrm{ELBO}}$（把 $p_\theta(\boldsymbol x,z)=p_\theta(\boldsymbol x\mid z)p(z)$ 展开即可看出）。

于是缺口 $=\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\|p_\theta(z\mid\boldsymbol x)\bigr)\ge0$：**下界不紧的唯一原因是近似后验偏离真后验**。$\blacksquare$
:::

::: intuition 两种推导分别告诉你什么
- **推导一（Jensen）** 告诉你 ELBO「长什么样」：它是把「不可积的积分」换成「可采样的期望」之后必然出现的下界。它也解释了为什么必须有一个 $q_\phi$：Jensen 不等式需要一个在 $z$ 上的分布才能把积分改写成期望。
- **推导二（贝叶斯分解）** 告诉你 ELBO「缺了什么」：缺口是 $\mathrm{KL}(q_\phi\|p_\theta(z\mid\boldsymbol x))$。这条式子有一个立刻可用的推论——**当你看到一个 VAE 的重建很差、KL 又很小的时候，缺口可能很大**（近似后验远不是真后验），此时「最大化下界」并不等于「最大化似然」。

**工程上最常用的读法**：ELBO 的两项在做拉锯。重建项要求 $q_\phi(z\mid\boldsymbol x)$ 是一个「精确的、把质量集中在单个点上的」后验（方差趋 0，才能无损编码）；KL 项要求它「就是先验」（方差趋 1、均值趋 0）。两个要求互相矛盾，最优解在中间——**这种张力是 VAE 模糊感的来源，也是它可采样的来源**。
:::

## 4.3.3 重参数化技巧：让采样可导

现在两个具体障碍要跨过去才能真的训练：期望里含「从 $q_\phi$ 中采样」这一步，怎么对 $\phi$ 求导？KL 项又怎么算（4.3.4 解决）？

::: method 重参数化技巧（reparameterization trick） {#method-4.3.1}
**障碍**：重建项是 $\mathbb E_{z\sim q_\phi(z\mid\boldsymbol x)}[\cdot]$，求梯度时要面对
$$\nabla_\phi\,\mathbb E_{z\sim q_\phi(z\mid\boldsymbol x)}\bigl[f(z)\bigr],$$
而被求期望的**分布本身依赖 $\phi$**，「采样」这一步在计算图上是个不可导的断点。用 REINFORCE 型的对数导数估计 $\mathbb E_q\bigl[f(z)\nabla_\phi\log q_\phi(z\mid\boldsymbol x)\bigr]$ 虽然无偏，但方差极大（在高维离散 / 连续空间中它只利用了标量回报 $f(z)$ 的信息，丢掉了 $f$ 对 $z$ 的梯度），训练慢到不可用。

**解法**：把随机性**搬出**求导路径。把采样写成「一份与 $\phi$ 无关的噪声」经确定性变换：
$$z=\boldsymbol\mu_\phi(\boldsymbol x)+\boldsymbol\sigma_\phi(\boldsymbol x)\odot\boldsymbol\varepsilon,\qquad \boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I).$$
于是期望变成对 $\boldsymbol\varepsilon$ 的期望，$\phi$ 只出现在确定性路径上，梯度可以直接穿过去：
$$\nabla_\phi\,\mathbb E_{z\sim q_\phi}\bigl[f(z)\bigr]=\mathbb E_{\boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)}\bigl[\nabla_z f(z)\cdot\nabla_\phi\bigl(\boldsymbol\mu_\phi(\boldsymbol x)+\boldsymbol\sigma_\phi(\boldsymbol x)\odot\boldsymbol\varepsilon\bigr)\bigr].$$
采样节点现在就是一个「加一份独立高斯噪声」的可微运算，普通反向传播即可。**这是 VAE 能端到端训练的关键**，而且几乎不增加计算成本。

**为什么这就等于「采样可导」**：$\boldsymbol\varepsilon$ 的分布不依赖任何参数，参数 $\phi$ 的影响全部通过 $\boldsymbol\mu_\phi,\boldsymbol\sigma_\phi$ 这两个确定性函数注入。改变 $\phi$ 只是把同一份噪声「平移伸缩」，梯度自然可算。

**实现细节（两条都会影响成败）**：
1. 网络输出的应是**对数方差** $\log\boldsymbol\sigma_\phi^2$ 而不是 $\boldsymbol\sigma_\phi^2$——否则必须加约束（如 softplus）保证方差为正，且梯度在方差接近 0 时会病态。
2. 换元时写 $z=\boldsymbol\mu+\exp(\tfrac12\log\boldsymbol\sigma^2)\odot\boldsymbol\varepsilon$。这一形式在 $\log\sigma^2\to-\infty$ 时梯度仍然良态，是框架里的标准写法。
:::

::: intuition 重参数化的几何图像：同一份噪声被平移伸缩
想象先验是一个固定的「噪声星座」$\boldsymbol\varepsilon$。参数 $\phi$ 不改变星座，只改变**把星座搬到潜空间哪里的那套变换**（均值是平移、标准差是各轴缩放）。于是「采样」不再是「从参数化的分布里抽签」这种不可导动作，而是「搬运一份固定的随机样本」这种可导动作。

**一个常见误解值得当场拆掉**：「重参数化让采样变得确定」——不是。采样依然是随机的，只是随机性来自 $\boldsymbol\varepsilon$；我们求的梯度是**对参数**的梯度，在给定 $\boldsymbol\varepsilon$ 的那一份具体样本上是确定的（这叫路径导数，pathwise derivative）。在多次采样下取平均，仍然是随机梯度的无偏估计，只是方差远小于 REINFORCE。
:::

::: prop 命题 4.3.1 · 重参数化梯度的无偏性与方差优势 {#prop-4.3.1}
设 $f$ 可微、$q_\phi(z\mid\boldsymbol x)=\mathcal N(\boldsymbol\mu_\phi,\operatorname{diag}(\boldsymbol\sigma_\phi^2))$，且可交换积分与求导（$f$ 与 $q_\phi$ 满足常规正则条件）。则路径导数估计
$$\widehat{\boldsymbol g}_{\text{path}}=\nabla_z f(z)\big|_{\,z=\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon}\cdot\nabla_\phi\bigl(\boldsymbol\mu_\phi(\boldsymbol x)+\boldsymbol\sigma_\phi(\boldsymbol x)\odot\boldsymbol\varepsilon\bigr),\qquad \boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)$$
是 $\nabla_\phi\mathbb E_{q_\phi}[f(z)]$ 的**无偏**估计；而 REINFORCE 估计 $\widehat{\boldsymbol g}_{\text{LR}}=f(z)\nabla_\phi\log q_\phi(z\mid\boldsymbol x)$ 同样无偏，但**不利用 $f$ 的梯度信息**，其方差随 $d$ 增长显著更快。
:::

::: proof 证明（无偏性与「梯度信息」的来源）
**（i）路径导数的无偏性。** 由 $z=\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon$ 与 $\boldsymbol\varepsilon$ 的分布与 $\phi$ 无关，
$$\mathbb E_{q_\phi}\bigl[f(z)\bigr]=\mathbb E_{\boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)}\bigl[f\bigl(\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon\bigr)\bigr].$$
在可交换求导与积分的条件下，对 $\phi$ 求导可以直接作用在被积函数上（积分域与测度 $\boldsymbol\varepsilon$ 都不依赖 $\phi$）：
$$\nabla_\phi\,\mathbb E_{q_\phi}[f]=\mathbb E_{\boldsymbol\varepsilon}\Bigl[\nabla_\phi f\bigl(\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon\bigr)\Bigr]=\mathbb E_{\boldsymbol\varepsilon}\Bigl[\nabla_z f(z)^{\mathrm T}\,\nabla_\phi z\Bigr],$$
右侧就是 $\widehat{\boldsymbol g}_{\text{path}}$，故无偏。

**（ii）为什么它比 REINFORCE 方差小。** 对数导数估计的形式是
$$\nabla_\phi\,\mathbb E_{q_\phi}[f]=\int f(z)\,\nabla_\phi\log q_\phi(z\mid\boldsymbol x)\,q_\phi(z)\,dz=\mathbb E_{q_\phi}\bigl[f(z)\,\nabla_\phi\log q_\phi(z\mid\boldsymbol x)\bigr],$$
它只通过**标量** $f(z)$ 与分布的得分相乘来传播信息，完全不含 $\nabla_z f$。在一个 $d$ 维空间中，$\nabla_\phi\log q_\phi$ 的范数通常随 $d$ 增长，而 $f(z)$ 作为标量无法抵消这种增长，故方差随 $d$ 明显恶化；路径导数则通过 $\nabla_z f$ 直接把「哪个方向能降低 $f$」的信息送进梯度，与 $d$ 的关系温和得多。$\blacksquare$
:::

::: think 高斯之外，还有哪些分布可以重参数化
只要能把 $z$ 写成「固定分布 $\boldsymbol\varepsilon$ 的可微变换」，就能用路径导数。常见构造：**Logistic 分布**（$z=\mu+s\cdot\mathrm{logit}(u)$，$u\sim\mathcal U(0,1)$，用于 Gumbel-Softmax 的连续松弛）、**Gumbel-Softmax**（离散类别分布的连续松弛，见 [4.7](sec47.md) 的 VQ 与离散生成）、**Student-t**、**Laplace**、**可逆流**（把简单分布的样本过一层可逆网络）。**反例**：离散分布的「直接采样」没有这样的重参数化（因为样本空间不连通、梯度无法定义），这才需要 Gumbel-Softmax 这类**松弛**技巧——代价是引入了偏差或需要退火。
:::

## 4.3.4 KL 项的闭式解

::: prop 命题 4.3.2 · 先验与对角高斯后验的 KL 闭式 {#prop-4.3.2}
当 $p(z)=\mathcal N(\boldsymbol 0,I)$、$q_\phi(z\mid\boldsymbol x)=\mathcal N(\boldsymbol\mu,\operatorname{diag}(\boldsymbol\sigma^2))$ 时，KL 项有闭式解，逐维求和即可：
$$\mathrm{KL}\bigl(\mathcal N(\boldsymbol\mu,\operatorname{diag}(\boldsymbol\sigma^2))\,\|\,\mathcal N(\boldsymbol 0,I)\bigr)=\frac12\sum_{j=1}^{d}\Bigl(\mu_j^2+\sigma_j^2-1-\log\sigma_j^2\Bigr).$$
:::

::: proof 推导（两个对角高斯之间的 KL）
对两个同维高斯 $p=\mathcal N(\boldsymbol\mu_p,\Sigma_p)$、$q=\mathcal N(\boldsymbol\mu_q,\Sigma_q)$，KL 的通式是
$$\mathrm{KL}(p\|q)=\tfrac12\Bigl[\log\frac{\det\Sigma_q}{\det\Sigma_p}-d+\operatorname{tr}\bigl(\Sigma_q^{-1}\Sigma_p\bigr)+(\boldsymbol\mu_q-\boldsymbol\mu_p)^{\mathrm T}\Sigma_q^{-1}(\boldsymbol\mu_q-\boldsymbol\mu_p)\Bigr],$$
它的三项分别来自「熵差」「二次型差的期望」与「对数配分函数差」。本教程的编号约定是 $p$ 在前：这里取 $p=q_\phi=\mathcal N(\boldsymbol\mu,\operatorname{diag}(\boldsymbol\sigma^2))$、$q=p(z)=\mathcal N(\boldsymbol 0,I)$，代入 $\Sigma_q=I$（$\det=1$、$\log\det=0$）、$\boldsymbol\mu_q=\boldsymbol 0$：

$$\mathrm{KL}= \tfrac12\Bigl[\log\frac{1}{\prod_j\sigma_j^2}-d+\sum_j\sigma_j^2+\sum_j\mu_j^2\Bigr]
=\tfrac12\sum_j\Bigl(\mu_j^2+\sigma_j^2-1-\log\sigma_j^2\Bigr).$$

**逐项读法**：$\mu_j^2$ 度量「均值偏离先验中心」的代价；$\sigma_j^2$ 与 $-\log\sigma_j^2$ 是一对：前者惩罚「方差过大」，后者惩罚「方差过小」，二者之和在 $\sigma_j^2=1$ 处取到最小 $0$——即**当且仅当该维后验恰好等于先验时，这一维对 KL 无贡献**。$\blacksquare$
:::

::: intuition 闭式解为什么至关重要
因为**正则项不需要采样、不需要 Monte Carlo**，可以直接算；只有重建项需要采样（用 [@method-4.3.1] 让它可以求导）。于是 VAE 的一步训练就是「采一个 $\varepsilon$ → 前向解码 → 算 $\lVert\boldsymbol x-\hat{\boldsymbol x}\rVert^2$ → 加上闭式 KL → 反向传播」，干净利落。

这条性质在工程上的意义容易被低估：如果 KL 只能靠采样估计，那么每个样本都要抽多次才能把正则项估准，训练成本会翻好几倍。**「选一个与先验配对的、有闭式 KL 的近似后验族」** 因此成了 VAE 设计的硬约束之一。想要更强的后验表达能力（如混合高斯、归一化流后验），就必须接受 KL 只能近似估计的代价——这是 VAE 进阶做法的核心权衡。
:::

## 4.3.5 损失函数、形状表与一个可导的采样

把两块拼起来，得到实际代码里的损失：

$$\mathcal L_{\mathrm{VAE}}=\underbrace{\mathbb E_{q_\phi}\bigl[-\log p_\theta(\boldsymbol x\mid z)\bigr]}_{\text{重建项（负对数似然）}}+\underbrace{\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p(z)\bigr)}_{\text{正则项}} .$$

**重建项的具体形式取决于解码器分布**：高斯解码器 $p_\theta(\boldsymbol x\mid z)=\mathcal N(g_\theta(z),\sigma_x^2I)$ 时，$-\log p_\theta(\boldsymbol x\mid z)=\frac{1}{2\sigma_x^2}\lVert\boldsymbol x-g_\theta(z)\rVert^2+\text{const}$，即「MSE 乘一个系数加常数」；Bernoulli 解码器时是二元交叉熵。**这一点必须写清**，因为「VAE 用 MSE」只在固定方差高斯解码器下成立（见本节陷阱框第 1 条）。

<table class="shape-table">
<thead><tr><th>层</th><th>运算</th><th>输出形状</th><th>参数量（$D=784$，隐藏层 $256$，$d=16$）</th></tr></thead>
<tbody>
<tr><td>输入 $\boldsymbol x$</td><td>—</td><td>$B\times784$</td><td>$0$</td></tr>
<tr><td>共享主干</td><td>$\mathrm{ReLU}(\boldsymbol xW_0+\boldsymbol b_0)$</td><td>$B\times256$</td><td>$784\times256+256=200{,}960$</td></tr>
<tr><td>均值头</td><td>$\boldsymbol\mu=\boldsymbol hW_\mu+\boldsymbol b_\mu$</td><td>$B\times16$</td><td>$256\times16+16=4{,}112$</td></tr>
<tr><td>对数方差头</td><td>$\log\boldsymbol\sigma^2=\boldsymbol hW_{\log\sigma^2}+\boldsymbol b$</td><td>$B\times16$</td><td>$4{,}112$</td></tr>
<tr><td>重参数化</td><td>$z=\boldsymbol\mu+\exp(\tfrac12\log\boldsymbol\sigma^2)\odot\boldsymbol\varepsilon$</td><td>$B\times16$</td><td>$0$（无参数，可导）</td></tr>
<tr><td>解码器隐藏</td><td>$\mathrm{ReLU}(zW_1+\boldsymbol b_1)$</td><td>$B\times256$</td><td>$16\times256+256=4{,}352$</td></tr>
<tr><td>解码器输出</td><td>$\hat{\boldsymbol x}=\sigma(z_1W_2+\boldsymbol b_2)$</td><td>$B\times784$</td><td>$256\times784+784=201{,}488$</td></tr>
<tr><td>—</td><td>总参数量</td><td>—</td><td>$415{,}024$</td></tr>
</tbody>
</table>

::: ex 例 4.3.1 · 手算一个样本的 VAE 损失 {#ex-4.3.1}
设潜维 $d=2$，某样本编码得到 $\boldsymbol\mu=(1.0,\,-0.5)$、$\boldsymbol\sigma=(0.5,\,2.0)$；解码的平均重建误差为 $\lVert\boldsymbol x-g_\theta(z)\rVert^2=0.36$（取 $\sigma_x^2=1$ 的高斯解码器）。求这一样本的 $-\mathrm{ELBO}$。

::: proof 解
**KL 项**（用 [@prop-4.3.2]）。先算 $\sum_j\mu_j^2=1^2+(-0.5)^2=1.25$。再算 $\sum_j\sigma_j^2=0.25+4=4.25$。对数项 $\sum_j\log\sigma_j^2=\log(0.25\cdot4)=\log1=0$。于是
$$\mathrm{KL}=\frac12\bigl(1.25+4.25-2-0\bigr)=\frac12\times3.5=1.75 .$$
**重建项**。固定方差 $\sigma_x^2=1$ 时，$-\log p_\theta(\boldsymbol x\mid z)=\frac12\lVert\boldsymbol x-g_\theta(z)\rVert^2+\text{const}=\frac12\times0.36=0.18$（忽略与 $\theta,\phi$ 无关的常数）。

**合计**：$-\mathrm{ELBO}=0.18+1.75=1.93$。可见这一个样本上 **KL 正则占了大头**——网络被推着把 $\mu$ 拉向 $0$、$\sigma$ 拉向 $1$。若把 $\sigma$ 压小（想重建更准），KL 会因 $-\log\sigma_j^2$ 增大而变贵；这就是 VAE「重建准度 vs 潜空间规整」的张力。

**顺带检验一下「每维独立」**：第二维的 $(\mu_2^2,\sigma_2^2)=(-0.5,2.0)$ 给出 $\frac12(0.25+2-1-\log4)=\frac12(1.25-1.386)\approx-0.068$，是**负贡献**——因为该维的方差 $2$ 偏大、偏离先验中心不多，整体上比「恰好等于先验」还便宜一点。KL 非负的是**总和**，单维可以被允许为负号出现在这个求和式里。$\blacksquare$
:::

::: intuition 插值：VAE 的招牌演示
因为潜空间连续且各处的解码器都被训练过，我们可以在两个真实样本的潜码之间**线性走一遍**，解码结果会平滑地从一张图过渡到另一张。三个实现细节决定演示是否好看：

1. **用均值 $\boldsymbol\mu$ 而不是采样得到的 $z$** 作为端点——$\mu$ 是「该样本在潜空间的中心」，受随机噪声影响更小；
2. **沿直线插值，而不是球面插值**：潜空间近似各向同性高斯，线性插值的中间态解释性最强（这也是 VAE 与 GAN 潜空间插值的经验差别之一）；
3. **中途的样本要落到先验的高密度区**：插值路径若经过低密度区，中间帧会出现「抽象糊块」；出现这种现象通常意味着 KL 权重 $\beta$ 偏小、潜空间的团没有充分重叠（见 [4.3.6](#sec-4.3.6)）。
:::
:::

## 4.3.6 后验坍塌与 β-VAE {#sec-4.3.6}

::: def 定义 4.3.2 · 后验坍塌（posterior collapse）与 β-VAE {#def-4.3.2}
**后验坍塌**：训练后的近似后验对所有输入都退化到先验附近，即 $q_\phi(z\mid\boldsymbol x)\approx p(z)$，此时

$$\mathcal L_{\mathrm{ELBO}}\approx\mathbb E\bigl[\log p_\theta(\boldsymbol x\mid z)\bigr]-\underbrace{\mathrm{KL}(p(z)\|p(z))}_{=0}\quad\text{且 } z\perp\boldsymbol x,$$

也就是说**解码器完全忽略 $z$、直接靠自身容量重建 $\boldsymbol x$**（自回归解码器时尤其容易发生）。潜码不再携带关于输入的任何信息，生成时的先验采样完全有效，但**可控性与表示能力全部丢失**。

**β-VAE**：把 KL 项的权重显式提到系数 $\beta$ 上，
$$\mathcal L_{\beta}=\mathbb E_{q_\phi}\bigl[\log p_\theta(\boldsymbol x\mid z)\bigr]-\beta\,\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x)\,\|\,p(z)\bigr).$$
$\beta\gt1$ 鼓励解耦（disentangled）表示、潜空间更规整；$\beta\lt1$ 偏向重建精度。$\beta=1$ 时回到标准 ELBO。
:::

::: intuition 后验坍塌是怎么发生的：一条「便宜的下坡路」
从优化角度看，KL 项是一个**可以直接关掉的开关**：让 $\boldsymbol\mu_\phi(\boldsymbol x)\to\boldsymbol 0$、$\boldsymbol\sigma_\phi^2(\boldsymbol x)\to\boldsymbol 1$，这一项就变成 $0$。而重建项想要它变小（把后验压尖、携带信息）。两者相持，谁赢取决于「信息对重建值多少」：

- 如果解码器**很强**（例如自回归解码器、或容量远超数据复杂度），它可以**完全不看 $z$** 就把重建做得很准——此时信息维度上的收益接近 $0$，KL 项却一直是实实在在的成本，于是被压到 $0$。这就是坍塌。
- 如果解码器**不够强**（例如把一个 $784$ 维输入从 $16$ 维潜码还原），它必须依赖 $z$ 携带信息，坍塌就不会发生。

**工程判据（可直接写进实验日志）**：训练若干轮后看 KL 项的数值——
- **KL 接近 $0$**（例如 $d=16$ 时低于 $0.1$）：已经坍塌。诊断实验：把 $z$ 置零或换成另一个样本的 $z$，若重建几乎不变，确认坍塌。
- **KL 稳定在几到几十纳特（nats）**：正常。经验上「每个活跃潜维贡献约 0.5–5 nats」是一个可用的健康区间（量级参考，具体值随 $d$ 与数据而变）。
- **KL 极高**（远大于 $d$）而重建仍差：$\beta$ 太小或解码器过强之前的阶段，潜码过尖，先验采样会落到低密度区。
:::

::: think KL 项到底是「正则」还是「负担」
从优化角度看，KL 项在惩罚「编码出的后验偏离先验」，逼潜空间规整，作用类似 L2 正则：它压低了纯重建的性能，却换来了可采样性。

但把它当纯粹的「正则」会误导两件事。**第一**，它的系数 $\beta$ 与真实的信息瓶颈直接挂钩：最大化「重建 − β·KL」等价于在**率失真（rate-distortion）**意义下寻找一个最优的工作点——β 就是「每个 nats 的信息值多少钱」的价格。**第二**，$\beta$ 并不是「越大越好」或「越小越好」：$\beta$ 大 → 潜表示更解耦、更规整，但重建更糊、更易坍塌（因为 KL 太贵，模型干脆不用潜码）；$\beta$ 小 → 重建更准，潜空间却逐渐退化成普通 AE 的样子、不再像先验。$\beta$ 因此是一个**刻意的权衡旋钮**，必须通过「重建质量 + 先验采样质量 + 下游任务表现」三项联合验证来定。
:::

::: method 三个常用来对付坍塌的手段 {#method-4.3.2}
1. **KL 退火（annealing）**：训练早期把 $\beta$ 从 $0$ 线性升到目标值。早期让模型先用重建把潜空间用起来，再逐步上正则，避免一开局就走「关掉 KL」的捷径。
2. **自由比特（free bits）**：把 KL 项拆成逐维（或逐组）分量，只惩罚**超过阈值**的部分：$\sum_j\max(0,\mathrm{KL}_j-\lambda)$。这样模型可以保留那些「信息量不大但有意义」的维，而不是被一刀切压到 0。
3. **弱化解码器**：降低解码器容量、或用共享参数 / 更少的自回归依赖。这条在文本 VAE 上几乎是必需的——因为文本的自回归解码器实在太强，不给制约就一定坍塌。
:::

## 4.3.7 条件 VAE：让生成可控

::: def 定义 4.3.3 · 条件变分自编码器（conditional VAE, CVAE） {#def-4.3.3}
给定条件 $c$（类别标签、文本、动作指令、另一个模态），把先验、后验与似然全部改成条件分布：

- **条件先验**：$p_\theta(z\mid c)=\mathcal N(\boldsymbol 0,I)$（也可以让 $p_\theta(z\mid c)$ 本身可学，如 $\mathcal N(\boldsymbol\mu_\theta(c),\operatorname{diag}(\boldsymbol\sigma_\theta^2(c)))$）；
- **条件近似后验**：$q_\phi(z\mid\boldsymbol x,c)$；
- **条件似然**：$p_\theta(\boldsymbol x\mid z,c)$。

对应的条件 ELBO 为
$$\mathcal L_{\mathrm{CVAE}}=\mathbb E_{q_\phi(z\mid\boldsymbol x,c)}\bigl[\log p_\theta(\boldsymbol x\mid z,c)\bigr]-\mathrm{KL}\bigl(q_\phi(z\mid\boldsymbol x,c)\,\|\,p_\theta(z\mid c)\bigr).$$
生成时从 $z\sim p_\theta(z\mid c)$ 采样，再解码 $p_\theta(\boldsymbol x\mid z,c)$。
:::

::: intuition CVAE 与「分类器引导」的关系（后面 4.5 会重逢）
条件生成有两种加条件的方式：

- **把 $c$ 喂进网络**（CVAE 的写法）：$q_\phi(z\mid\boldsymbol x,c)$ 与 $p_\theta(\boldsymbol x\mid z,c)$ 都看得见 $c$。生成时只需一个条件分支。
- **不改网络，改采样过程**（[4.5](sec45.md) 的无分类器引导 CFG）：训练时随机把 $c$ 置空，学一个「有条件的」与一个「无条件的」预测；采样时用两者之差当作「$c$ 的方向」外推。

CVAE 的做法更「学术」，CFG 的做法更「工程」——后者不需要为每个条件改结构，且引导强度可以在采样时随手调。**两者背后的愿望是同一个**：让「条件」在生成过程中有一个可调节的杠杆。
:::

## 4.3.8 代码：一个完整的最小 VAE

```python
import torch, torch.nn as nn, torch.nn.functional as F

class VAE(nn.Module):
    def __init__(self, D=784, h=256, d=16):
        super().__init__()
        self.d = d
        self.fc = nn.Sequential(nn.Linear(D, h), nn.ReLU())     # 共享主干
        self.mu = nn.Linear(h, d)                                # 均值头
        self.logvar = nn.Linear(h, d)                            # 对数方差头：输出 log σ² 而非 σ²
        self.dec = nn.Sequential(nn.Linear(d, h), nn.ReLU(), nn.Linear(h, D), nn.Sigmoid())

    def encode(self, x):
        h = self.fc(x)
        return self.mu(h), self.logvar(h)                        # 两个 (B, d)

    def reparameterize(self, mu, logvar):
        # 与参数无关的噪声：整个重参数化技巧就写在这一行里
        std = torch.exp(0.5 * logvar)                            # σ = exp(½·log σ²)：数值稳定
        eps = torch.randn_like(std)                              # ε ~ N(0, I)
        return mu + std * eps                                    # 可导的「采样」

    def forward(self, x):
        mu, logvar = self.encode(x)
        z = self.reparameterize(mu, logvar)
        return self.dec(z), mu, logvar, z

def vae_loss(x_hat, x, mu, logvar, beta=1.0):
    # 重建项：Bernoulli 解码器（像素在 [0,1]）→ 二元交叉熵；高斯解码器则换成 MSE·(1/2σ_x²)
    rec = F.binary_cross_entropy(x_hat, x, reduction="sum") / x.size(0)   # 按批平均
    # 正则项：命题 4.3.2 的闭式 KL，逐维求和后再按批平均
    kl = -0.5 * torch.sum(1 + logvar - mu.pow(2) - logvar.exp()) / x.size(0)
    return rec + beta * kl, rec, kl     # 分别返回，便于监控坍塌

def train_vae(model, loader, steps=5000, lr=1e-3, beta=1.0):
    opt = torch.optim.Adam(model.parameters(), lr=lr)
    it = iter(loader)
    for i in range(steps):
        try:
            x, _ = next(it)
        except StopIteration:
            it = iter(loader); x, _ = next(it)
        x = x.view(x.size(0), -1)
        x_hat, mu, logvar, z = model(x)
        loss, rec, kl = vae_loss(x_hat, x, mu, logvar, beta)
        opt.zero_grad(); loss.backward(); opt.step()
        if i % 500 == 0:
            # 关键监控：kl 接近 0 → 后验坍塌；rec 居高不下且 kl 极大 → β 过小
            print(f"step {i:5d} loss {loss.item():8.3f} rec {rec.item():8.3f} kl {kl.item():6.3f}")
    return model

@torch.no_grad()
def sample(model, n=16):
    """生成：从**先验**采样，而不是从后验 —— 这是本节的第 5 条陷阱。"""
    z = torch.randn(n, model.d)
    return model.dec(z)

@torch.no_grad()
def interpolate(model, x1, x2, steps=8):
    """在潜空间中心（μ）之间线性插值，看解码结果如何平滑过渡。"""
    mu1, _ = model.encode(x1.view(1, -1))
    mu2, _ = model.encode(x2.view(1, -1))
    ts = torch.linspace(0, 1, steps).view(-1, 1)
    zs = (1 - ts) * mu1 + ts * mu2        # (steps, d)
    return model.dec(zs)
```

::: method 从「能跑」到「跑得好」的四步排查 {#method-4.3.3}
1. **先看重建**：把 `x` 与 `x_hat` 并排可视化。重建仍糊 → 增大 $\beta$ 之外的一切（容量、训练步数），或换解码器分布（BCE ↔ MSE 要与数据形态匹配）。
2. **再看 KL 曲线**：接近 0 → 坍塌，按 [4.3.6](#sec-4.3.6) 的三个手段处理；持续上升不收敛 → 学习率过大或 $\beta$ 过小。
3. **看先验采样**：从 `torch.randn` 采样解码是否可辨识。模糊但可辨 → 正常；纯噪声 → 先验与后验错位（检查 KL 是否太小、$\beta$ 是否太小）。
4. **做消融实验**：固定种子，只改 $\beta\in\{0.5,1,4\}$，把「重建 MSE / 先验采样质量 / 插值平滑度」三项画在同一张图上。这条曲线就是 VAE 的率失真权衡图，值得作为实验报告的核心图。
:::

::: errata 本节五个高频误解
1. **「VAE 的重建损失用 MSE 就等于对数似然」**：只有当解码器取**固定方差的高斯** $p_\theta(\boldsymbol x\mid z)=\mathcal N\bigl(g_\theta(z),\sigma_x^2I\bigr)$ 时，$-\log p_\theta(\boldsymbol x\mid z)$ 才等于 $\frac{1}{2\sigma_x^2}\lVert\boldsymbol x-g_\theta(z)\rVert^2$ 加一个与参数无关的常数；而且整个目标是 **ELBO（下界）**，不是 $\log p(\boldsymbol x)$ 本身。二值 / 离散像素应改用 Bernoulli 解码器 + 交叉熵（BCE）。
2. **「采样时从后验取 $z$ 也行」**：生成阶段必须从**先验** $p(z)=\mathcal N(0,I)$ 采样；拿编码器对某张真实图的后验去解码，那是在做**重建**，不是生成。二者的区别在代码里只有一行，但含义完全不同。
3. **「KL 项是可选的正则，去掉能提升重建」**：去掉后 VAE 退化成普通 AE（[4.2](sec42.md)），潜空间重新变得无结构、不可采样。KL 项正是把后验拉向先验、让潜空间连续的那一项，不能省。
4. **「VAE 的模糊都归咎于模型不够大」**：模糊来自高斯解码器 + 重建损失对多个模式的**平均**效应，以及 $\beta$ 过小带来的强正则；加大网络往往无效，通常要调 $\beta$、换更锐利的解码器或改损失。
5. **「重参数化让采样变确定 / 让 VAE 变成确定性模型」**：重参数化只是把随机性从「分布参数里」挪到「与参数无关的噪声 $\varepsilon$ 里」。采样依然是随机的；变可导的是**对参数的梯度**（[命题 4.3.1](#prop-4.3.1)）。
:::

::: method 即时自测 · 4.3
**Q1** 写出 ELBO 的两项，并说明每一项在「把潜空间变得可采样」这件事上负责什么。

**Q2** 为什么不能对 $\nabla_\phi\mathbb E_{z\sim q_\phi}[f(z)]$ 直接用「采样后反向传播」？重参数化怎么绕过这一点？

**Q3** 给 $d=3$ 的一维情形：$\mu=0.8$、$\sigma^2=0.25$，算这一维对 KL 的贡献；再解释 $\sigma^2=1$ 时为什么贡献为 $0$。

**Q4** 训练日志显示：重建损失持续下降，但 KL 项在 500 步后就稳定在 $0.02$（$d=32$）。诊断是什么？给出两个处理手段。

**Q5** 生成样本时用 `q_φ(z|x)` 采样的 $z$ 与用 `N(0,I)` 采样的 $z$，分别对应什么任务？

::: sol 参考要点
**Q1** 重建项 $\mathbb E_{q}[\log p_\theta(\boldsymbol x\mid z)]$ 负责「让潜码携带关于 $\boldsymbol x$ 的信息」（否则解码器无从还原），正则项 $-\mathrm{KL}(q_\phi\|p(z))$ 负责「让后验贴近先验、填满潜空间」（否则先验采样会落到低密度区）。两项方向相反，最优解在中间。

**Q2** 因为采样步骤 $z\sim q_\phi$ 在计算图上是一个不可导节点：$\phi$ 出现在分布的参数里而不是计算路径上。REINFORCE 型估计 $\mathbb E[f(z)\nabla_\phi\log q_\phi]$ 虽无偏但方差巨大。重参数化把 $z$ 写成 $z=\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon$（$\boldsymbol\varepsilon$ 与 $\phi$ 无关），于是期望可以改写成对 $\boldsymbol\varepsilon$ 的期望，$\phi$ 只出现在确定性线性路径上，梯度可以直接穿过去（路径导数），且利用了 $\nabla_z f$，方差远小。

**Q3** 贡献 $=\frac12(\mu^2+\sigma^2-1-\log\sigma^2)=\frac12\bigl(0.64+0.25-1-\log0.25\bigr)$。由于 $\log 0.25=-\log4\approx-1.386$，得 $\frac12(0.64+0.25-1+1.386)=\frac12\times1.276\approx0.638$。当 $\sigma^2=1$ 时该项为 $\frac12(\mu^2+1-1-0)=\frac12\mu^2$；若同时 $\mu=0$，KL 项恰为 $0$——此时该维后验 $=$ 先验，正则项不再对这个维度施加任何力（既不强推也不强拉）。

**Q4** 诊断：**后验坍塌**。KL 接近 0 意味着 $q_\phi(z\mid\boldsymbol x)\approx p(z)$，潜码不携带输入信息；重建仍能下降说明解码器在靠自身容量硬记。处理：① KL 退火（$\beta$ 从 0 缓慢升到目标）；② 自由比特（只惩罚超过阈值 $\lambda$ 的逐维 KL）；③ 弱化解码器（降低容量 / 减少自回归依赖）。另外要先做确认实验：把 $z$ 换成随机 $z$ 重建，若输出几乎不变即确诊。

**Q5** 用 $q_\phi(z\mid\boldsymbol x)$ 采样再解码 = **重建 / 编码**（输入是已知的 $\boldsymbol x$，任务是把信息压进去再还原，也用于「条件于输入的编辑」）。用 $p(z)=\mathcal N(0,I)$ 采样再解码 = **生成**（不从任何具体样本出发，产出训练集之外的新样本）。这也是「AE 为什么不能生成」的同一把尺子：它只有前者。
:::
:::

::: note[skip] 延伸阅读
- Kingma & Welling, *Auto-Encoding Variational Bayes*（2013，arXiv:1312.6114）——VAE 与重参数化技巧的原始论文，第 2 节的推导与本节 [4.3.2](#sec-4.3.2) 的推导二同构。
- Rezende, Mohamed & Wierstra, *Stochastic Backpropagation and Approximate Inference in Deep Latent Gaussian Models*（2014，arXiv:1401.4082）——与 VAE 同期独立提出「重参数化 + 变分下界」的另一条线，读它可以看到该技巧的另一种表述（backpropagation through a Gaussian）。
- Higgins et al., *β-VAE: Learning Basic Visual Concepts with a Constrained Variational Framework*（ICLR 2017，无 arXiv 编号）——β-VAE 与解耦表示的原始论文。
- Bowman et al., *Generating Sentences from a Continuous Space*（2016，arXiv:1511.06349）——文本 VAE 里后验坍塌的经典观察来源；想理解「为什么文本上特别容易坍塌」，这篇是起点。
- Sønderby et al., *Ladder Variational Autoencoders*（2016，arXiv:1602.02282）——层级后验的扩展，对应「更强的近似后验族」这一路线。
- Chen et al., *Variational Lossy Autoencoder*（2017，arXiv:1611.02731）——用率失真视角把 VAE 的「潜变量该编码什么」讲得最清楚的一篇（与本节的「信息值多少钱」读法直接相关）。
:::

**本节小结**：VAE 的修补思路是「给潜空间指定先验并强迫后验贴近它」。三件套缺一不可：**先验** $p(z)=\mathcal N(0,I)$ 定采样起点、**ELBO** 定优化目标（下界，缺口是后验与近似后验的 KL）、**重参数化** $z=\boldsymbol\mu+\boldsymbol\sigma\odot\boldsymbol\varepsilon$ 让采样可导。KL 项有闭式（[命题 4.3.2](#prop-4.3.2)），因此正则项无需 Monte Carlo；重建项的形式取决于解码器分布（高斯 → MSE，Bernoulli → BCE）。潜空间连续且被填满的副产品是**可插值、可编辑**。代价有三条：样本偏糊（高斯解码器 + 平均效应）、率失真权衡要调 $\beta$、以及后验坍塌这个结构性风险（[4.3.6](#sec-4.3.6)）。

VAE 的锐度问题来自「用显式似然换稳定」。下一节换一条完全不同的路：**不写似然，用两个网络的博弈逼出锐利样本**——把代价从「模糊」换成「训练不稳与模式坍塌」。
