# 4.5 扩散模型：把生成拆成多步去噪

GAN 用博弈换锐利，换来的是不稳定（[4.4](sec44.md)）；VAE 用似然换稳定，换来的是模糊（[4.3](sec43.md)）。**扩散模型**（diffusion model）给出第三条路：**不要一次从噪声跳到样本，而是把它拆成几百上千步「稍微去一点噪声」的小任务**。

这个想法有两个直接收益：每一步的监督信号是**我们亲手加进去的那份噪声**——已知、无歧义，所以训练是回归任务而不是博弈，稳定、可复现；网络只被要求做「局部去一点噪声」这种小改动，比「从纯噪声一步生成样本」容易得多。代价也很直接：采样要跑很多次网络前向。

本节要把这条路线拆干净：前向加噪为什么有闭式解、反向过程为什么可以写成变分下界、下界又怎么化简成「预测噪声的 MSE」、DDPM 与 DDIM 的采样差在哪里、条件引导（CFG）在数学上到底是什么。

## 4.5.1 前向过程：一个固定的加噪马尔可夫链

::: def 定义 4.5.1 · 前向加噪与反向去噪 {#def-4.5.1}
**前向加噪**（forward / diffusion process，**无参数**，纯固定过程）：在 $T$ 步内逐步往数据里注入高斯噪声，
$$q(x_t\mid x_{t-1})=\mathcal N\Bigl(\sqrt{1-\beta_t}\,x_{t-1},\ \beta_t I\Bigr),\qquad t=1,\dots,T,$$
其中 $\{\beta_t\in(0,1)\}$ 是**噪声调度**（noise schedule，常见设定如 $\beta_t$ 从 $10^{-4}$ 线性增长到 $0.02$）。记 $\alpha_t=1-\beta_t$、$\bar\alpha_t=\prod_{s=1}^{t}\alpha_s$，则任意一步都能一步到位地写出（见 [@thm-4.5.1]）：
$$q(x_t\mid x_0)=\mathcal N\bigl(\sqrt{\bar\alpha_t}\,x_0,\ (1-\bar\alpha_t)I\bigr)\ \Longleftrightarrow\ x_t=\sqrt{\bar\alpha_t}\,x_0+\sqrt{1-\bar\alpha_t}\,\varepsilon,\quad \varepsilon\sim\mathcal N(0,I).$$
当 $T$ 足够大、$\bar\alpha_T\to0$ 时，$x_T$ 已近似纯高斯噪声——**这条链的终点是一个已知分布**，这正是它能被用来生成的原因。

**反向去噪**（reverse process，**要学参数**）：让网络逐步把 $x_t$ 还原成 $x_{t-1}$，
$$p_\theta(x_{t-1}\mid x_t)=\mathcal N\bigl(\mu_\theta(x_t,t),\ \Sigma_\theta(x_t,t)\bigr),\qquad p(x_T)=\mathcal N(0,I).$$
:::

::: intuition 前向链的三件事：契约、桥梁、终点
- **契约（加噪是固定的）**：前向过程不含任何可学参数，它只是「把数据摧毁成噪声」的一段程序。我们随时可以对任意 $x_0$ 采样出任意时刻的 $x_t$——这意味着**监督信号是自带的**（我们知道自己加了多少噪声），不需要任何标签，也不存在「两个网络互相追赶」。
- **桥梁（闭式解）**：$x_t$ 可以从 $x_0$ **一步**得到，不必跑 $t$ 次加噪。这条性质让训练成本与 $T$ 无关（每次只随机抽一个 $t$），是整个方法高效的关键。
- **终点（已知分布）**：$\bar\alpha_T\to0$ 时 $x_T\approx\varepsilon$ 是标准高斯。于是采样有一个明确的起点：从 $\mathcal N(0,I)$ 抽一个 $x_T$，剩下的任务就是「逆着走回去」。

**反向过程为什么需要均值与方差都学？** 结构上写全是为了变分推导方便；实践中 $\Sigma_\theta$ 常固定为 $\beta_t I$ 或 $\tilde\beta_t I$，只学均值——因为在 $\sigma_x^2$ 尺度下学方差对样本质量的收益远小于它的训练代价（后续工作发现让网络同时预测方差也能提升，但那是额外的工程选择）。
:::

::: thm 定理 4.5.1 · 前向过程的一步到位闭式 {#thm-4.5.1}
设 $q(x_t\mid x_{t-1})=\mathcal N(\sqrt{\alpha_t}x_{t-1},\beta_t I)$，$\alpha_t=1-\beta_t$，$\bar\alpha_t=\prod_{s=1}^{t}\alpha_s$。则对任意 $t\ge1$，
$$q(x_t\mid x_0)=\mathcal N\bigl(\sqrt{\bar\alpha_t}\,x_0,\ (1-\bar\alpha_t)I\bigr).$$
:::

::: proof 证明（对 $t$ 归纳，用高斯线性组合）
**$t=1$**：$\bar\alpha_1=\alpha_1$，$q(x_1\mid x_0)=\mathcal N(\sqrt{\alpha_1}x_0,\beta_1I)$，与定义一致。

**归纳步**：设 $q(x_{t-1}\mid x_0)=\mathcal N(\sqrt{\bar\alpha_{t-1}}x_0,(1-\bar\alpha_{t-1})I)$。把两步合成一步：
$$x_t=\sqrt{\alpha_t}\,x_{t-1}+\sqrt{\beta_t}\,\boldsymbol\epsilon_1,\qquad x_{t-1}=\sqrt{\bar\alpha_{t-1}}\,x_0+\sqrt{1-\bar\alpha_{t-1}}\,\boldsymbol\epsilon_2,$$
其中 $\boldsymbol\epsilon_1,\boldsymbol\epsilon_2\sim\mathcal N(0,I)$ 独立。代入得
$$x_t=\underbrace{\sqrt{\alpha_t}\sqrt{\bar\alpha_{t-1}}}_{=\sqrt{\bar\alpha_t}}x_0+\underbrace{\bigl(\sqrt{\alpha_t(1-\bar\alpha_{t-1})}\,\boldsymbol\epsilon_2+\sqrt{\beta_t}\,\boldsymbol\epsilon_1\bigr)}_{\text{零均值、独立高斯之和}} .$$
两个独立零均值高斯线性组合仍是零均值高斯，方差相加（协方差恒同）：
$$\operatorname{Var}=\alpha_t(1-\bar\alpha_{t-1})I+\beta_t I=\bigl(\alpha_t-\alpha_t\bar\alpha_{t-1}+\beta_t\bigr)I=\bigl(1-\bar\alpha_t\bigr)I,$$
最后一步用了 $\alpha_t-\alpha_t\bar\alpha_{t-1}+\beta_t=\alpha_t(1-\bar\alpha_{t-1})+1-\alpha_t=1-\alpha_t\bar\alpha_{t-1}=1-\bar\alpha_t$。故结论成立。$\blacksquare$
:::

::: intuition 闭式解的两个可直接使用的读法
**读法一（训练时）**：给定 $x_0$、随机抽一个 $t$，立刻能造出 $x_t$，不必回放整条链。所以每步训练成本是 $O(1)$ 次网络前向。

**读法二（手算）**：$\sqrt{\bar\alpha_t}$ 是**信号权重**，$\sqrt{1-\bar\alpha_t}$ 是**噪声权重**，二者平方和为 $1$。这意味着加噪过程保持「总能量」不变（在数据已归一到零均值单位方差的尺度下），因此不同 $t$ 的输入尺度是可比、可控的——这也是为什么归一化范围（如 $[-1,1]$）必须训练与采样一致（见本节陷阱框）。
:::

::: ex 例 4.5.1 · 手算一次加噪系数 {#ex-4.5.1}
给定一个极简调度 $T=4$、$\beta_1=\beta_2=\beta_3=\beta_4=0.1$，求 $t=4$ 时 $x_4$ 中信号与噪声各占多少权重；再求「$t=2$ 到 $t=3$ 的单步合成与一步到位是否一致」（用方差核对）。

::: proof 解
**① 累乘系数。** $\alpha_t=1-\beta_t=0.9$（每步相同），故
$$\bar\alpha_1=0.9,\quad \bar\alpha_2=0.81,\quad \bar\alpha_3=0.729,\quad \bar\alpha_4=0.6561 .$$
**② 代入闭式。** $t=4$ 时
$$\sqrt{0.6561}=0.81,\qquad \sqrt{1-0.6561}=\sqrt{0.3439}\approx0.586 .$$
即 $x_4=0.81\,x_0+0.586\,\varepsilon$：原始信号权重掉到 $0.81$，噪声权重升到约 $0.586$。随 $t$ 增大，$\bar\alpha_t$ 单调下降，信号被越来越厚的噪声淹没——这正是「$T$ 步后趋近纯噪声」的机制。

**③ 一致性核对（单步 vs 一步到位）。** 用归纳步的公式从 $t=2$ 推 $t=3$：$\sqrt{\alpha_3}\sqrt{\bar\alpha_2}=\sqrt{0.9\times0.81}=\sqrt{0.729}=\sqrt{\bar\alpha_3}$ ✓；方差项
$$\alpha_3(1-\bar\alpha_2)+\beta_3=0.9\times0.19+0.1=0.271=1-\bar\alpha_3\ \checkmark .$$
两条都与一步到位的闭式吻合。

**④ 到第几步就「几乎纯噪声」了？** 用 $\sqrt{1-\bar\alpha_t}$ 逼近 $1$ 的时刻衡量：$\bar\alpha_t=0.9^t$，$t=20$ 时 $\bar\alpha_{20}\approx0.122$（噪声权重 $\approx0.937$），$t=40$ 时 $\bar\alpha_{40}\approx0.015$（噪声权重 $\approx0.993$）。这个玩具调度比常见设定（线性到 $0.02$、共 $T=1000$）快得多，但形态相同：**信噪比随 $t$ 单调下降，在末尾几个百分点里数据被彻底淹没**。$\blacksquare$
:::
:::

## 4.5.2 反向过程与变分下界 {#sec-4.5.2}

现在要把「逆着走回去」写成可优化的目标。思路与 VAE 完全一致（[4.3](sec43.md)）：写一个变分下界，把不可解的积分换成可采样的期望。

::: def 定义 4.5.2 · 扩散的变分下界 {#def-4.5.2}
把 $x_{0:T}$ 看成一整条隐变量序列，则数据的对数似然为
$$\log p_\theta(x_0)=\log\int p_\theta(x_{0:T})\,dx_{1:T},\qquad p_\theta(x_{0:T})=p(x_T)\prod_{t=1}^{T}p_\theta(x_{t-1}\mid x_t).$$
用前向链 $q(x_{1:T}\mid x_0)=\prod_{t=1}^{T}q(x_t\mid x_{t-1})$ 作变分分布，Jensen 不等式给出（与 [4.3](sec43.md#thm-4.3.1) 的 ELBO 同款推导）
$$\log p_\theta(x_0)\ \ge\ \mathbb E_{q}\Bigl[\log\frac{p_\theta(x_{0:T})}{q(x_{1:T}\mid x_0)}\Bigr]
=-\underbrace{\mathrm{KL}\bigl(q(x_T\mid x_0)\,\|\,p(x_T)\bigr)}_{L_T}
-\underbrace{\sum_{t=2}^{T}\mathbb E_q\bigl[\mathrm{KL}\bigl(q(x_{t-1}\mid x_t,x_0)\,\|\,p_\theta(x_{t-1}\mid x_t)\bigr)\bigr]}_{L_{t-1}}
+\underbrace{\mathbb E_q\bigl[\log p_\theta(x_0\mid x_1)\bigr]}_{L_0}.$$
写成「损失」形式：$\mathcal L_{\mathrm{VLB}}=\mathbb E_q\bigl[-\log\frac{p_\theta(x_{0:T})}{q(x_{1:T}\mid x_0)}\bigr]=L_T+\sum_{t=2}^{T}L_{t-1}-L_0$，**最小化 VLB 即最大化似然下界**。
:::

::: intuition 下界里的每一项在说什么
这个式子看起来吓人，但每一项的角色都很清楚：

- $L_T$ **没有可学参数**：它比较「前向链的终点」与「先验 $\mathcal N(0,I)$」。只要 $\bar\alpha_T$ 足够小，这一项就是常数（实践中直接忽略）。
- $L_{t-1}$ 是**主项**，占 99% 以上的贡献：它要求「模型的反向分布 $p_\theta(x_{t-1}\mid x_t)$ 去逼近**真实的后验** $q(x_{t-1}\mid x_t,x_0)$」。注意这里出现了 $x_0$——**知道原图之后，加噪过程是可以精确求逆的**（下面命题 4.5.1 给出闭式），而模型在采样时看不到 $x_0$，所以它必须学会「猜 $x_0$ 或猜噪声」。
- $L_0$ 是最后一步的「像素级似然」，形式上是单独一项；实践中它与 $L_{t-1}$ 用同一套损失处理。

**与 VAE 的对应关系**（这张对应表把两节串起来）：

| VAE（[4.3](sec43.md)） | 扩散（本节） |
|:--|:--|
| 单层潜变量 $z$ | $T$ 层潜变量 $x_1,\dots,x_T$ |
| 编码器 $q_\phi(z\mid\boldsymbol x)$（要学的） | 前向 $q(x_t\mid x_{t-1})$（**固定的**） |
| 先验 $p(z)=\mathcal N(0,I)$ | 终点先验 $p(x_T)=\mathcal N(0,I)$ |
| 解码器 $p_\theta(\boldsymbol x\mid z)$ | 反向链 $p_\theta(x_{t-1}\mid x_t)$ |
| 重建项 + KL | $L_0$ + $\sum L_{t-1}$ |
| 重参数化让采样可导 | 闭式 $x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\varepsilon$ 让采样可导 |

**一句话**：扩散 = 一个「编码器固定且分层、解码器分 $T$ 步」的 VAE。
:::

::: prop 命题 4.5.1 · 真实后验的闭式（加噪可以精确求逆） {#prop-4.5.1}
在前向过程下，给定 $x_0$ 与 $x_t$ 的条件分布是高斯：
$$q(x_{t-1}\mid x_t,x_0)=\mathcal N\bigl(\tilde{\boldsymbol\mu}_t(x_t,x_0),\ \tilde\beta_t I\bigr),$$
$$\tilde{\boldsymbol\mu}_t(x_t,x_0)=\frac{\sqrt{\bar\alpha_{t-1}}\,\beta_t}{1-\bar\alpha_t}\,x_0+\frac{\sqrt{\alpha_t}(1-\bar\alpha_{t-1})}{1-\bar\alpha_t}\,x_t,\qquad \tilde\beta_t=\frac{1-\bar\alpha_{t-1}}{1-\bar\alpha_t}\,\beta_t .$$
:::

::: proof 推导（配方，把两个高斯乘起来）
由马尔可夫性与贝叶斯公式，
$$q(x_{t-1}\mid x_t,x_0)=\frac{q(x_t\mid x_{t-1})\,q(x_{t-1}\mid x_0)}{q(x_t\mid x_0)}\ \propto\ \exp\Bigl[-\frac{1}{2}\bigl(A+B-C\bigr)\Bigr],$$
其中（下略 $I$，只写标量系数）
$$A=\frac{\lVert x_t-\sqrt{\alpha_t}x_{t-1}\rVert^2}{\beta_t},\quad
B=\frac{\lVert x_{t-1}-\sqrt{\bar\alpha_{t-1}}x_0\rVert^2}{1-\bar\alpha_{t-1}},\quad
C=\frac{\lVert x_t-\sqrt{\bar\alpha_t}x_0\rVert^2}{1-\bar\alpha_t}\ \ (\text{与 }x_{t-1}\text{ 无关，可当常数}).$$
把 $A+B$ 中与 $x_{t-1}$ 有关的部分整理成 $x_{t-1}$ 的二次式：$x_{t-1}$ 的系数为
$$\Bigl(\frac{\alpha_t}{\beta_t}+\frac{1}{1-\bar\alpha_{t-1}}\Bigr)x_{t-1}^2
-2\Bigl(\frac{\sqrt{\alpha_t}}{\beta_t}x_t+\frac{\sqrt{\bar\alpha_{t-1}}}{1-\bar\alpha_{t-1}}x_0\Bigr)^{\mathrm T}x_{t-1}.$$
记二次系数 $\kappa=\frac{\alpha_t}{\beta_t}+\frac{1}{1-\bar\alpha_{t-1}}=\frac{\alpha_t(1-\bar\alpha_{t-1})+\beta_t}{\beta_t(1-\bar\alpha_{t-1})}=\frac{1-\bar\alpha_t}{\beta_t(1-\bar\alpha_{t-1})}$（分子用了 $1-\bar\alpha_t=\alpha_t(1-\bar\alpha_{t-1})+\beta_t$）。高斯密度的形式是 $\exp\bigl[-\frac{\kappa}{2}\lVert x_{t-1}-\boldsymbol m\rVert^2\bigr]$，故方差 $\tilde\beta_t=1/\kappa$，均值
$$\tilde{\boldsymbol\mu}_t=\frac{1}{\kappa}\Bigl(\frac{\sqrt{\alpha_t}}{\beta_t}x_t+\frac{\sqrt{\bar\alpha_{t-1}}}{1-\bar\alpha_{t-1}}x_0\Bigr)
=\frac{\sqrt{\bar\alpha_{t-1}}\beta_t}{1-\bar\alpha_t}x_0+\frac{\sqrt{\alpha_t}(1-\bar\alpha_{t-1})}{1-\bar\alpha_t}x_t .$$
即 $q(x_{t-1}\mid x_t,x_0)=\mathcal N(\tilde{\boldsymbol\mu}_t,\tilde\beta_tI)$，逆过程是可以精确求的——**只是它需要 $x_0$，而采样时我们恰好没有**。$\blacksquare$
:::

## 4.5.3 从 VLB 到简化损失：预测噪声就够了 {#sec-4.5.3}

::: thm 定理 4.5.2 · 简化训练目标（去噪噪声回归） {#thm-4.5.2}
从 $t\sim\mathcal U\{1,\dots,T\}$、$x_0\sim p_{\text{data}}$、$\varepsilon\sim\mathcal N(0,I)$、$x_t=\sqrt{\bar\alpha_t}\,x_0+\sqrt{1-\bar\alpha_t}\,\varepsilon$ 中采样，最小化
$$\mathcal L_{\text{simple}}=\mathbb E_{t,\,x_0,\,\varepsilon}\Bigl[\bigl\lVert\varepsilon-\varepsilon_\theta(x_t,t)\bigr\rVert^2\Bigr].$$
即：**给网络看「加过噪的图」和「当前是第几步 $t$」，让它把当初加进去的那份噪声 $\varepsilon$ 猜出来**。它与完整 VLB 只差一个与 $t$ 有关的权重：完整下界的每个 $L_{t-1}$ 项等价于 $\dfrac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}\bigl\lVert\varepsilon-\varepsilon_\theta\bigr\rVert^2$（$\sigma_t^2$ 是反向方差），DDPM 的做法正是**把这个权重置为 1**。
:::

::: proof 推导（从 KL 到噪声 MSE 的三步）
**第一步：把 $L_{t-1}$ 里两个高斯都写成「以 $x_0,\varepsilon$ 为参数」的形式。** 真实后验的均值（[命题 4.5.1](#prop-4.5.1)）把 $x_0=\dfrac{x_t-\sqrt{1-\bar\alpha_t}\varepsilon}{\sqrt{\bar\alpha_t}}$ 代入，消掉 $x_0$：
$$\tilde{\boldsymbol\mu}_t=\frac{\sqrt{\bar\alpha_{t-1}}\beta_t}{1-\bar\alpha_t}\cdot\frac{x_t-\sqrt{1-\bar\alpha_t}\varepsilon}{\sqrt{\bar\alpha_t}}+\frac{\sqrt{\alpha_t}(1-\bar\alpha_{t-1})}{1-\bar\alpha_t}x_t
=\frac{1}{\sqrt{\alpha_t}}\Bigl(x_t-\frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\,\varepsilon\Bigr).$$
模型的反向均值写成同样的形状（**只把 $\varepsilon$ 换成网络的预测 $\varepsilon_\theta(x_t,t)$**）：
$$\mu_\theta(x_t,t)=\frac{1}{\sqrt{\alpha_t}}\Bigl(x_t-\frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\,\varepsilon_\theta(x_t,t)\Bigr).$$

**第二步：两个同方差高斯的 KL 就是均值差的平方。** 取 $\Sigma_\theta=\sigma_t^2I$、真实后验方差 $\tilde\beta_tI$；当两者相同（或按固定方差近似）时
$$\mathrm{KL}\bigl(\mathcal N(\mu_\theta,\sigma_t^2I)\,\|\,\mathcal N(\tilde{\boldsymbol\mu}_t,\tilde\beta_tI)\bigr)=\frac{\lVert\mu_\theta-\tilde{\boldsymbol\mu}_t\rVert^2}{2\sigma_t^2}+\text{const}
=\frac{1}{2\sigma_t^2}\cdot\frac{\beta_t^2}{\alpha_t(1-\bar\alpha_t)}\bigl\lVert\varepsilon-\varepsilon_\theta(x_t,t)\bigr\rVert^2+\text{const}.$$

**第三步：把所有项的权重统一。** 于是完整的训练损失是
$$\mathcal L_{\mathrm{VLB}}=\sum_{t=1}^{T}\underbrace{\frac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}}_{=:\,w_t}\mathbb E\bigl[\lVert\varepsilon-\varepsilon_\theta(x_t,t)\rVert^2\bigr]+\text{const},$$
其中 $w_t$ 在 $t$ 小时很小（$\beta_t^2$ 小）、在 $t$ 大时较大。DDPM 的实验发现：**把 $w_t$ 全部置为 1**（即 $\mathcal L_{\text{simple}}$）不仅能训练，而且样本质量明显更好——因为它在训练早期把注意力从「几乎无噪声的 $t$」（$w_t$ 极小、几乎不提供信号）那里挪开，转而均摊到所有噪声水平上。**代价是它不再严格是似然的下界**：高噪声步被相对放大，低噪声步被相对缩小。

**顺带一个漂亮结论（去噪 = 得分）**：由 Tweedie 公式，最优的噪声预测器满足
$$\mathbb E[\varepsilon\mid x_t]=\nabla_{x_t}\log q(x_t\mid x_0)\quad\Longrightarrow\quad \nabla_{x_t}\log p_t(x_t)=-\frac{1}{\sqrt{1-\bar\alpha_t}}\,\mathbb E\bigl[\varepsilon\mid x_t\bigr].$$
也就是说，**「预测噪声」等价于「估计对数密度的梯度（得分）」**——扩散与 [4.2.4](sec42.md) 提到的去噪 AE、以及 [4.1](sec41.md) 的得分—能量路线在这里合流。$\blacksquare$
:::

::: intuition 「预测噪声」和「预测原图」是同一件事的两种参数化
三种参数化在数学上互相等价（都只是同一条件的重新参数化）：

| 参数化 | 网络输出 | 与其他两个的关系 |
|:--|:--|:--|
| 噪声预测 $\varepsilon_\theta$ | $\hat\varepsilon$ | $\hat x_0=\dfrac{x_t-\sqrt{1-\bar\alpha_t}\hat\varepsilon}{\sqrt{\bar\alpha_t}}$ |
| 原图预测 $x_{0,\theta}$ | $\hat x_0$ | $\hat\varepsilon=\dfrac{x_t-\sqrt{\bar\alpha_t}\hat x_0}{\sqrt{1-\bar\alpha_t}}$ |
| 速度预测 $v_\theta$ | $\hat v$ | $\hat v=\sqrt{\bar\alpha_t}\hat\varepsilon-\sqrt{1-\bar\alpha_t}\hat x_0$（$(x_0,\varepsilon)$ 坐标系里的「旋转」） |

**为什么工程上偏爱噪声预测？** 因为在任意 $t$ 上，$\varepsilon$ 的边际分布始终是标准正态（尺度稳定），而 $x_0$ 的量级依赖数据。用固定的 MSE 去回归一个**尺度稳定**的目标，比回归尺度随 $t$ 剧烈变化的目标更稳定——不需要按 $t$ 调损失权重。速度预测（$v$-param）在极端信噪比下更稳，是后续一些工作（如 [4.6](sec46.md) 要讲的整流流近亲）的常用选择。
:::

## 4.5.4 采样：DDPM 与 DDIM {#sec-4.5.4}

::: method DDPM 采样（随机、$T$ 步） {#method-4.5.1}
训练好 $\varepsilon_\theta$ 后，采样就是一个**固定步数的迭代**：先从纯噪声出发 $x_T\sim\mathcal N(0,I)$，然后对 $t=T,\dots,1$ 依次
$$x_{t-1}=\frac{1}{\sqrt{\alpha_t}}\Bigl(x_t-\frac{1-\alpha_t}{\sqrt{1-\bar\alpha_t}}\,\varepsilon_\theta(x_t,t)\Bigr)+\sigma_t\,z,\qquad z\sim\mathcal N(0,I)\ (t\gt1),\quad z=0\ (t=1).$$
每一步都做两件事：用网络**估计当前噪声并减掉一部分**（把样本往高密度区推），再**注入一点点新噪声**（$\sigma_t$ 项，理论取 $\sigma_t^2=\tilde\beta_t$ 或 $\beta_t$；$t=1$ 时不再加，避免最后一步破坏细节）。
:::

::: method DDIM 采样（确定性、可少步） {#method-4.5.2}
DDIM 用一族**非马尔可夫**的前向过程作桥梁：
$$q_\sigma(x_{t-1}\mid x_t,x_0)=\mathcal N\Bigl(\sqrt{\bar\alpha_{t-1}}x_0+\sqrt{1-\bar\alpha_{t-1}-\sigma_t^2}\cdot\frac{x_t-\sqrt{\bar\alpha_t}x_0}{\sqrt{1-\bar\alpha_t}},\ \sigma_t^2I\Bigr),$$
它保持所有边际 $q(x_t\mid x_0)$ 不变（因此**可以用同一个训练好的 $\varepsilon_\theta$**），只改变「步与步之间的连接方式」。取 $\sigma_t=0$ 得到**确定性**采样：
$$x_{t-1}=\sqrt{\bar\alpha_{t-1}}\,\hat x_0(x_t)+\sqrt{1-\bar\alpha_{t-1}}\,\hat\varepsilon(x_t),\qquad
\hat x_0=\frac{x_t-\sqrt{1-\bar\alpha_t}\,\varepsilon_\theta(x_t,t)}{\sqrt{\bar\alpha_t}},\quad \hat\varepsilon=\varepsilon_\theta(x_t,t).$$
实践的关键：**可以把 $t$ 的取值换成任意递增子序列**（如 $1000$ 步里挑 $50$ 步），用同样的公式跳着走。这就是「$T$ 从上千压到几十」的来源。
:::

::: intuition DDIM 为什么能少步而 DDPM 不能
- **DDPM 的链是马尔可夫的**：$x_{t-1}$ 只依赖 $x_t$，两者之间的「距离」固定为一个很小的步长。若直接跳过中间的步（从 $t$ 接到 $t-k$），加噪链与去噪链的统计就对不上，样本崩坏。
- **DDIM 把「步」重新参数化成一条连续路径上的点**：由 $\hat x_0$ 与 $\hat\varepsilon$ 这两个量可以算出路径上任意位置 $t'$ 的样本（下面这个式子就是全部秘密）：
$$x_{t'}=\underbrace{\sqrt{\bar\alpha_{t'}}\,\hat x_0}_{\text{信号部分}}+\underbrace{\sqrt{1-\bar\alpha_{t'}}\,\hat\varepsilon}_{\text{噪声部分}},\qquad \text{对任意 } t'\lt t .$$
**只要 $t'$ 在 $[0,t]$ 之间，这样外推出来的 $x_{t'}$ 就是自洽的**——因为它只是把同一个 $(\hat x_0,\hat\varepsilon)$ 分解在另一个信噪比上。于是「跳步」不再破坏结构，只是把路径采样得更稀疏。
- **确定性带来的额外好处**：同一起点 $x_T$ 始终给出同一个样本（可复现）；且因为确定性映射在数学上对应一个 ODE 的欧拉离散，才出现了「用更高阶 ODE 求解器加速」这一整条技术线（[4.6](sec46.md) 的整流流会把它推到极致）。

**代价**：$\sigma_t=0$ 时样本多样性略降（少了那一点随机注入），且更依赖 $\hat x_0$ 的准确度——**步数太少时，$\hat x_0$ 的单次估计误差会被放大成可见的失真**。这是在 $10$ 步、$20$ 步、$50$ 步之间做取舍的核心矛盾。
:::

::: method 采样步数—质量—成本对照（量级示意，用于建立方向感） {#method-4.5.3}
下表给出「同一个训练好的模型、不同采样器 / 步数」的典型关系（**具体数字随数据与模型而变，此表只描述趋势**）：

| 采样器 | 网络前向次数 | 随机性 | 质量趋势 | 成本（相对 $T=1000$ 的 DDPM） |
|:--|:--|:--|:--|:--|
| DDPM | $T$（常 1000） | 随机 | 基线质量 | $1\times$ |
| DDIM | $50\sim100$ | 确定性 | 与 DDPM 相当或更好（同样步数下） | $0.05\sim0.1\times$ |
| DDIM | $10\sim20$ | 确定性 | 细节开始退化（糊、纹理丢失） | $0.01\sim0.02\times$ |
| 蒸馏 / 一致性模型（[4.6](sec46.md)） | $1\sim4$ | 随机或确定性 | 少步质量明显优于同步数 DDIM | $0.001\sim0.004\times$ |
| 整流流重流化后（[4.6](sec46.md)） | $1\sim8$ | 确定性 | 直线化后少步误差小 | 同上量级 |

**读表方式**：这张表的行间差异不是「谁更好」，而是「把训练成本挪到哪」。一致性模型与蒸馏要额外训练一个学生网络，换来推理时的常数级前向；DDIM 不改训练，只用更聪明的路径参数化换步数。**先决定推理预算（延迟 / 吞吐），再决定用哪一档。**
:::

## 4.5.5 条件引导：CFG 的公式与作用 {#sec-4.5.5}

::: def 定义 4.5.3 · 无分类器引导（classifier-free guidance, CFG） {#def-4.5.3}
把条件 $c$（文本、类别、动作）作为额外输入喂给网络，得到条件噪声预测 $\varepsilon_\theta(x_t,t,c)$。训练时以一定概率把 $c$ 置为空标记 $\varnothing$（如 $10\%$ 的样本），使**同一个网络同时学会条件与无条件两个预测**。采样时用两者之差外推：
$$\tilde\varepsilon_\theta(x_t,t,c)=\varepsilon_\theta(x_t,t,\varnothing)+w\bigl(\varepsilon_\theta(x_t,t,c)-\varepsilon_\theta(x_t,t,\varnothing)\bigr),$$
其中 $w\ge0$ 是**引导尺度**。$w=1$ 回到普通条件采样；$w\gt1$ 放大「条件方向」，样本更贴合提示；$w$ 过大时多样性下降、画面过饱和 / 结构僵化。
:::

::: intuition $w$ 的作用：沿着「条件的方向」多走几步
从贝叶斯公式出发可以看清它在做什么。真实的条件得分满足
$$\nabla_{x_t}\log p(x_t\mid c)=\nabla_{x_t}\log p(x_t)+\nabla_{x_t}\log p(c\mid x_t),$$
而 CFG 的那条差 $\varepsilon_\theta(\cdot,c)-\varepsilon_\theta(\cdot,\varnothing)$（乘上 $-\frac{1}{\sqrt{1-\bar\alpha_t}}$）正是 $\nabla_{x_t}\log p(c\mid x_t)$ 的一个**无需分类器的估计**——它把「$c$ 指向哪个方向」直接算了出来。于是 CFG 的更新相当于

$$\nabla\log p(x_t)+w\nabla\log p(c\mid x_t)$$

在采样步上做外推：**先沿着「像数据」的方向走，再额外沿「像 $c$」的方向多走 $(w-1)$ 倍**。这就是「$w$ 越大越听话」的机制来源。

**它为什么是一个「取舍旋钮」而不是「越大越好」**：$w$ 放大的是条件方向，同时也放大了该方向上的一切误差。$w$ 过大时，采样轨迹被推到条件似然极高的狭窄区域（那里数据似然很低），于是出现常见的三种退化——**色彩过饱和 / 对比度异常、构图僵化重复、多样性显著下降**。工程上的经验做法是固定一组提示词，扫 $w\in\{1,3,5,7.5,12\}$ 看「对齐度—多样性」曲线的拐点（**具体最优值随模型与数据而变，需实测**）。

**与 [4.3.7](sec43.md) CVAE 的对照**：CVAE 把条件写进网络结构（$q_\phi(z\mid\boldsymbol x,c)$、$p_\theta(\boldsymbol x\mid z,c)$），CFG 则不加结构、只改采样公式——代价是训练时要随机丢条件（否则学不出无条件分支），换来推理时可自由调节引导强度。
:::

::: think CFG 与「分类器引导」的区别，以及为什么后者被淘汰
早期的**分类器引导**（classifier guidance）是另训一个噪声分类器 $p_\phi(c\mid x_t)$，用它的梯度 $\nabla_{x_t}\log p_\phi(c\mid x_t)$ 来推样本。它有效，但有两个硬伤：① 分类器必须在**每个噪声水平**上都能工作（要额外训练一整套噪声条件分类器）；② 训练分类器需要带标签数据，而生成模型的大规模优势恰恰来自无标签 / 弱标签数据。CFG 用「同一网络的条件与无条件之差」替代了分类器，去掉了这两个约束——**这也是它成为事实标准的直接原因**。

代价也有：训练时必须**随机丢条件**，因此模型有一部分容量被花在「无条件生成」上；且 $w$ 的最优点依赖任务，没有普适值。
:::

## 4.5.6 形状与计算量表

以 $64\times64\times3$ 图像的像素空间扩散为例（批 $B=16$）：

<table class="shape-table">
<thead><tr><th>量</th><th>形状</th><th>说明</th></tr></thead>
<tbody>
<tr><td>$x_t$</td><td>$16\times3\times64\times64$</td><td>与数据同形状；扩散在**像素空间**直接操作（潜空间版见 [4.6](sec46.md)）</td></tr>
<tr><td>$t$</td><td>$16$（标量时间步）</td><td>经正弦位置编码后注入网络（与 Transformer 的位置编码同族）</td></tr>
<tr><td>条件 $c$</td><td>$16\times L\times d_c$</td><td>文本 token 序列；$L$ 为提示长度</td></tr>
<tr><td>U-Net 编码器各级</td><td>$16\times64\times32\times32\ \to\ 16\times128\times16\times16\ \to\ 16\times256\times8\times8$</td><td>每级「残差块 + 下采样」；通道翻倍、空间减半</td></tr>
<tr><td>瓶颈 + 注意力</td><td>$16\times512\times4\times4$</td><td>条件通过交叉注意力注入</td></tr>
<tr><td>U-Net 解码器各级</td><td>与编码器镜像（含跳连）</td><td>跳连保留高频细节——这是它比纯编码—解码强的关键</td></tr>
<tr><td>输出 $\varepsilon_\theta$</td><td>$16\times3\times64\times64$</td><td>与输入 $x_t$ **同形状**（噪声预测是逐像素的）</td></tr>
<tr><td>训练时每步网络前向次数</td><td>$1$</td><td>随机抽一个 $t$，一次前向、一次反向</td></tr>
<tr><td>采样时网络前向次数</td><td>$S$（DDPM 时 $S=T$）</td><td>CFG 时每步 **2 次**前向（条件 + 无条件）或 1 次批量前向</td></tr>
</tbody>
</table>

::: method 显存与算力的第一遍估算 {#method-4.5.4}
三条足以做首轮决策的算术：

1. **训练显存** ≈ 激活值（与「图像面积 × 通道 × 批大小 × 层数」成正比）+ 参数与优化器状态。像素空间扩散在 $64\times64$ 上尚可，到 $1024\times1024$ 时激活显存按面积增长 $256$ 倍——这是 [4.6](sec46.md) 的 LDM 出现的最直接经济原因（潜空间把空间尺寸降 $8$ 倍，即面积降 $64$ 倍）。
2. **采样总前向次数** $=S\times(\text{CFG 是否为 2})\times(\text{样本数})$。$1000$ 步 × 无 CFG × 单张图 = $1000$ 次前向；这是「扩散比 GAN 慢三个数量级」的由来，也是所有少步方法要解决的问题。
3. **推理成本与样本质量不是线性关系**：从 $1000$ 步降到 $100$ 步（DDIM）质量几乎不变，从 $20$ 步降到 $4$ 步则必须换模型（蒸馏 / 一致性 / 整流流），而不是继续压步数。
:::

```python
import torch, torch.nn as nn

def make_schedule(T=1000, beta_start=1e-4, beta_end=0.02):
    """线性噪声调度：返回前向计算所需的五个常量张量。"""
    betas = torch.linspace(beta_start, beta_end, T)
    alphas = 1.0 - betas
    alphas_cumprod = torch.cumprod(alphas, dim=0)           # ᾱ_t
    return dict(
        betas=betas,
        alphas=alphas,
        alphas_cumprod=alphas_cumprod,
        sqrt_alphas_cumprod=alphas_cumprod.sqrt(),          # √ᾱ_t：信号权重
        sqrt_one_minus=torch.sqrt(1.0 - alphas_cumprod),    # √(1-ᾱ_t)：噪声权重
    )

def q_sample(x0, t, sch):
    """定理 4.5.1 的闭式：一步从 x0 得到 x_t（不需要回放整条链）。"""
    a = sch["sqrt_alphas_cumprod"][t].view(-1, 1, 1, 1)     # 按样本广播
    b = sch["sqrt_one_minus"][t].view(-1, 1, 1, 1)
    eps = torch.randn_like(x0)                              # 标准正态噪声（尺度稳定 → 固定 MSE 即可）
    return a * x0 + b * eps, eps                            # 返回 eps 作为监督目标

def train_step(model, x0, sch, T=1000, p_uncond=0.1, cond=None):
    """一次扩散训练步：随机抽 t → 加噪 → 预测噪声 → MSE。"""
    B = x0.shape[0]
    t = torch.randint(0, T, (B,), device=x0.device)
    x_t, eps = q_sample(x0, t, sch)
    if cond is not None:
        # CFG 训练：以 p_uncond 的概率把条件置空，让同一网络学会无条件分支
        mask = (torch.rand(B, device=x0.device) < p_uncond).view(-1, 1, 1)
        cond_in = torch.where(mask, torch.zeros_like(cond), cond)
    else:
        cond_in = None
    eps_pred = model(x_t, t, cond_in)                       # 输出与 x_t 同形状
    return nn.functional.mse_loss(eps_pred, eps)            # 这就是 L_simple

@torch.no_grad()
def ddpm_sample(model, sch, shape, T=1000, guidance_w=1.0, cond=None):
    """DDPM 采样（随机）。CFG：每步调用两次网络（条件 / 无条件）并按式外推。"""
    x = torch.randn(shape)
    betas, alphas, ac = sch["betas"], sch["alphas"], sch["alphas_cumprod"]
    for t in reversed(range(T)):
        tt = torch.full((shape[0],), t, dtype=torch.long)
        if cond is not None and guidance_w != 1.0:
            e_u = model(x, tt, None)                        # 无条件预测
            e_c = model(x, tt, cond)                        # 条件预测
            eps = e_u + guidance_w * (e_c - e_u)            # CFG（定义 4.5.3）
        else:
            eps = model(x, tt, cond)
        # 反向均值：μ_θ = (1/√α_t)(x_t − (1−α_t)/√(1−ᾱ_t) · ε_θ)
        mean = (x - (1 - alphas[t]) / sch["sqrt_one_minus"][t] * eps) / alphas[t].sqrt()
        if t > 0:
            var = betas[t]                                  # 理论取 β_t 或 β̃_t；两者常被混用
            x = mean + var.sqrt() * torch.randn_like(x)     # 注入新噪声（最后一步不加）
        else:
            x = mean
    return x

@torch.no_grad()
def ddim_sample(model, sch, shape, steps=50, T=1000, eta=0.0, cond=None):
    """DDIM 采样（确定性，eta=0）：在任意递增子序列上跳着走。"""
    ac = sch["alphas_cumprod"]
    ts = torch.linspace(T - 1, 0, steps).long()             # 从 T-1 递减到 0 的子序列
    x = torch.randn(shape)
    ts_next = torch.cat([ts[1:], torch.tensor([-1])])       # 每步的「前一时刻」
    for t, t_prev in zip(ts, ts_next):
        tt = torch.full((shape[0],), int(t), dtype=torch.long)
        eps = model(x, tt, cond)
        x0_hat = (x - (1 - ac[t]).sqrt() * eps) / ac[t].sqrt()          # 估计的原图
        x0_hat = x0_hat.clamp(-1, 1)                                    # 数值稳定：限制在数据范围
        if int(t_prev) >= 0:
            a_prev, a_cur = ac[t_prev], ac[t]
            # x_{t'} = √ᾱ_{t'} · x̂₀ + √(1 − ᾱ_{t'}) · ε̂ ，η=0 时为确定性路径
            x = a_prev.sqrt() * x0_hat + torch.sqrt(1 - a_prev) * eps
        else:
            x = x0_hat
    return x
```

::: errata 本节五个高频误解
1. **「扩散模型采样一步到位」**：DDPM 需要上百到上千步迭代去噪，单步从纯噪声直接预测样本不可行（那相当于要求网络完成整条链的复合映射）。想加速要用 DDIM、蒸馏或潜空间扩散（[4.6](sec46.md)），而不是「一步生成」。
2. **「训练与采样可以各自用不同的噪声调度 / 数值范围」**：$\beta_t$、$\bar\alpha_t$ 与像素归一化（例如归到 $[-1,1]$）必须**训练与推理一致**，否则加噪/去噪的统计对不上，采样结果直接崩坏。这是新手最常踩的一脚，而且症状很剧烈（输出全灰噪声）。
3. **「$\mathcal L_{\text{simple}}$ 就是变分下界」**：它是把下界各项权重置为 1 后的**加权版本**（[定理 4.5.2](#thm-4.5.2)）。它的样本质量更好，但**不再是似然下界**——若你要报似然数字（如 bits/dim），必须用完整的 $w_t$ 重新计算。
4. **「CFG 的 $w$ 越大越好」**：$w$ 放大的是条件方向连同其误差，过大时多样性下降、过饱和。而且 $w=1$ 并不是「没有引导」的默认值——很多模型的甜点区在 $3\sim8$（需实测），写代码时必须把它当超参而不是常数。
5. **「DDIM 是另一个模型」**：DDIM 只改了**采样时的路径参数化**（非马尔可夫桥梁 + 跳步），前向边际 $q(x_t\mid x_0)$ 完全不变，因此**可以复用同一个训练好的 $\varepsilon_\theta$**。这也是它在发布后立刻被广泛采用的原因：零训练成本换 $20\sim50$ 倍的采样加速。
:::

::: method 即时自测 · 4.5
**Q1** 写出前向过程的单步形式与一步到位形式，并说明后者为什么让训练成本与 $T$ 无关。

**Q2** 用一句话说明 $L_T$、$L_{t-1}$、$L_0$ 各自在约束什么；哪个项占主导？

**Q3** 给定 $T=3$、$\beta_1=0.1$、$\beta_2=0.2$、$\beta_3=0.4$，求 $\bar\alpha_3$ 与 $x_3$ 中信号 / 噪声的权重。

**Q4** DDIM 为什么可以跳步而 DDPM 不能？跳步的代价是什么？

**Q5** CFG 中 $w=1$ 与 $w=7.5$ 的样本会有什么可观察的差别？为什么会出现这种差别？

::: sol 参考要点
**Q1** 单步：$q(x_t\mid x_{t-1})=\mathcal N(\sqrt{1-\beta_t}x_{t-1},\beta_tI)$。一步到位：$x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\varepsilon$（$\bar\alpha_t=\prod_{s\le t}(1-\beta_s)$）。因为可以从 $x_0$ 直接采样任意 $t$ 的 $x_t$，训练时只需「随机抽一个 $t$、一次加噪、一次预测、一次 MSE」，不需要前向链的递推，所以每步成本是 $O(1)$ 且与 $T$ 无关。

**Q2** $L_T$ 约束「前向链终点与先验 $\mathcal N(0,I)$ 的匹配」（无可学参数，$\bar\alpha_T\to0$ 时为常数）；$L_{t-1}$ 约束「反向分布逼近真实后验 $q(x_{t-1}\mid x_t,x_0)$」（**主项**，承担绝大部分贡献）；$L_0$ 是最后一步的像素级似然（$\log p_\theta(x_0\mid x_1)$）。主项是 $L_{t-1}$（$t=2,\dots,T$ 的和）。

**Q3** $\alpha_1=0.9,\alpha_2=0.8,\alpha_3=0.6$，故 $\bar\alpha_3=0.9\times0.8\times0.6=0.432$。信号权重 $\sqrt{0.432}\approx0.657$，噪声权重 $\sqrt{1-0.432}=\sqrt{0.568}\approx0.754$。核对：$0.657^2+0.754^2=0.432+0.568=1$ ✓。

**Q4** DDPM 的链是马尔可夫的，步长固定，跳步会让加噪链与去噪链的统计失配；DDIM 用非马尔可夫桥梁把「步」重新参数化成同一路径上的点，由 $(\hat x_0,\hat\varepsilon)$ 可以外推任意 $t'$ 处的样本 $x_{t'}=\sqrt{\bar\alpha_{t'}}\hat x_0+\sqrt{1-\bar\alpha_{t'}}\hat\varepsilon$，因此跳步仍自洽。代价：$\eta=0$ 时采样确定性、多样性略降；步数过少时 $\hat x_0$ 的单次估计误差被放大成可见失真。

**Q5** $w=1$：普通条件采样，样本多样、与提示的贴合度一般。$w=7.5$：更贴合提示、对比度与饱和度更高、同一提示下的样本差异变小（多样性下降），极端情况下构图僵化或出现重复纹理。原因：$w$ 放大的是 $\nabla\log p(c\mid x_t)$ 这一「条件方向」连同其误差，把轨迹推向条件似然高但数据似然低的狭窄区域。
:::

::: note[skip] 延伸阅读
- Sohl-Dickstein et al., *Deep Unsupervised Learning using Nonequilibrium Thermodynamics*（2015，arXiv:1503.03585）——扩散思想的原始论文（从非平衡热力学类比而来），读它可以看清「前向破坏 / 反向恢复」这一构想的来源。
- Ho, Jain & Abbeel, *Denoising Diffusion Probabilistic Models*（2020，arXiv:2006.11239）——DDPM 现代形式；本节 [4.5.2](#sec-4.5.2)、[4.5.3](#sec-4.5.3) 的推导与它附录 A 的写法一致，值得对照。
- Song, Meng & Ermon, *Denoising Diffusion Implicit Models*（2020，arXiv:2010.02502）——DDIM 原始论文；非马尔可夫桥梁与跳步采样都在其第 4 节。
- Song et al., *Score-Based Generative Modeling through Stochastic Differential Equations*（2020，arXiv:2011.13456）——把离散 $t$ 推广到连续 SDE，统一了「去噪」与「得分匹配」两条线；[4.6](sec46.md) 的整流流与一致性模型都建立在这个连续时间视角上。
- Ho & Salimans, *Classifier-Free Diffusion Guidance*（2022，arXiv:2207.12598）——CFG 原始论文（含 $w$ 的消融实验）。
- Dhariwal & Nichol, *Diffusion Models Beat GANs on Image Synthesis*（2021，arXiv:2105.05233）——分类器引导与 U-Net 结构改进，是「扩散质量超越 GAN」的转折点论文。
- Nichol & Dhariwal, *Improved Denoising Diffusion Probabilistic Models*（2021，arXiv:2102.09672）——余弦噪声调度与「让网络学习方差」的系统实验（本节形状表里 $\Sigma_\theta$ 的实践依据）。
:::
:::

**本节小结**：扩散把生成拆成「固定的加噪链 + 要学的去噪链」。前向有闭式 $x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\varepsilon$（[定理 4.5.1](#thm-4.5.1)），因此训练成本与 $T$ 无关；反向过程通过变分下界训练，下界的主项是「反向分布逼近真实后验 $q(x_{t-1}\mid x_t,x_0)$」，把权重统一后化简为**预测所加噪声的 MSE**（[定理 4.5.2](#thm-4.5.2)），而这个任务在数学上等价于估计对数密度的梯度（去噪 = 得分）。采样有两条路线：DDPM 的随机 $T$ 步，与 DDIM 的确定性可跳步（[4.5.4](#sec-4.5.4)）。条件生成用 CFG：训练时随机丢条件、采样时用「条件 − 无条件」的差外推，$w$ 是「贴合度 vs 多样性」的旋钮。结构上，扩散 = 编码器固定且分层、解码器分 $T$ 步的 VAE——这也解释了它与 [4.2.4](sec42.md) 去噪 AE、[4.1](sec41.md) 得分路线的关系。

扩散唯一的短板是采样步数。下一节处理三件事：**把扩散搬到 VAE 潜空间里**（省算力）、**用 Transformer 替换 U-Net**（吃到架构红利）、**把「多步去噪」压缩成一步或几步**（一致性模型与整流流）。
