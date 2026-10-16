# 第 4 讲 · 闭卷回忆卡

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起，只重做 △ 与 ×。
> 共 40 张卡（A 定义 10 · B 结论 10 · C 公式 10 · D 陷阱 10），一轮约 45 分钟。所有答案都能在 [4.1](sec41.md)–[4.8](sec48.md) 定位。

## A. 定义卡

**A1.** 生成模型的定义是什么？它至少要提供哪两项能力？
::: sol
建模数据自身分布 $p(\boldsymbol x)$（或联合分布 $p(\boldsymbol x,y)$）的模型（[定义 4.1.1](sec41.md#def-4.1.1)）。两项能力：① **密度（或其代理）**——给定 $\boldsymbol x$ 能给出 $p(\boldsymbol x)$、它的下界、或一个单调相关的相对分数；② **采样**——能从 $p(\boldsymbol x)$ 或近似里抽出**训练集没出现过**的新样本。**两项独立**：能量模型有密度无便宜采样，GAN 有采样无密度（[命题 4.1.1](sec41.md#prop-4.1.1)）。（✓ / △ / ×）
:::

**A2.** 生成模型的三支谱系分别是什么？各自「守住」什么、「放弃」什么？
::: sol
① **显式似然**：守住**刻度**（归一化密度或可算下界），放弃采样速度（自回归串行、流要求可逆）；② **隐式**：守住**比较**（判别器给的相对信号），放弃目标稳定性（博弈、模式坍塌）；③ **得分—能量**：守住**方向**（密度梯度），放弃便宜采样（需 MCMC / 迭代积分）（[定义 4.1.2](sec41.md#def-4.1.2)）。**一句话记忆**：显式守刻度、隐式守比较、得分守方向。（✓ / △ / ×）
:::

**A3.** FID 与 IS 各在度量什么？为什么它们不能单独作结论？
::: sol
**FID** 把真实集与生成集的（固定特征提取器）激活各拟合成多元高斯，度量两个高斯拟合的**形状差**：均值项惩罚整体位置偏移、协方差项惩罚尺度与相关性不匹配，越低越好。**IS** 只吃生成集，度量「单样本预测要尖 × 生成集类别覆盖要平」，越高越好（[定义 4.1.3](sec41.md#def-4.1.3)）。不能单独作结论的原因：FID 口径依赖样本量 / 特征提取器 / 预处理、不惩罚记忆、与人类偏好只是中等相关；IS 完全不看真实数据，可被「锐利但离谱」的样本抬高。（✓ / △ / ×）
:::

**A4.** VAE 的定义：先验、近似后验、似然分别是什么？训练目标是什么？
::: sol
先验 $p(z)=\mathcal N(0,I)$；近似后验（编码器）$q_\phi(z\mid\boldsymbol x)=\mathcal N(\boldsymbol\mu_\phi(\boldsymbol x),\operatorname{diag}(\boldsymbol\sigma_\phi^2(\boldsymbol x)))$，网络输出 $\boldsymbol\mu$ 与 $\log\boldsymbol\sigma^2$ 两组参数；似然（解码器）$p_\theta(\boldsymbol x\mid z)$，连续取高斯、二值取 Bernoulli。目标是最大化 **ELBO** $=\mathbb E_q[\log p_\theta(\boldsymbol x\mid z)]-\mathrm{KL}(q_\phi\|p(z))$（[定义 4.3.1](sec43.md#def-4.3.1)）。（✓ / △ / ×）
:::

**A5.** 重参数化技巧是什么？一句话说清它为什么让采样可导。
::: sol
把采样写成 $z=\boldsymbol\mu_\phi(\boldsymbol x)+\boldsymbol\sigma_\phi(\boldsymbol x)\odot\boldsymbol\varepsilon$、$\boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)$（[方法 4.3.1](sec43.md#method-4.3.1)）。**为什么可导**：随机性来自与 $\phi$ 无关的 $\boldsymbol\varepsilon$，$\phi$ 只出现在「平移 + 伸缩」这条**确定性**路径上，所以「对参数求梯度」可以在给定 $\boldsymbol\varepsilon$ 的那份样本上直接做（路径导数），既无偏又利用了 $\nabla_z f$，方差远小于 REINFORCE（[命题 4.3.1](sec43.md#prop-4.3.1)）。（✓ / △ / ×）
:::

**A6.** 后验坍塌的定义是什么？可观察的判据是什么？
::: sol
训练后 $q_\phi(z\mid\boldsymbol x)\approx p(z)$ 对所有输入都成立，即 KL 项被压到接近 0、$z\perp\boldsymbol x$，解码器完全忽略潜码、靠自身容量重建（[定义 4.3.2](sec43.md#def-4.3.2)）。**判据**：KL 逼近 0（如 $d=16$ 时低于 $0.1$）；确认实验是把 $z$ 换成另一个样本的 $z$（或置零），若重建几乎不变即确诊。$\beta\gt1$ 的 β-VAE 与过强的自回归解码器都会加剧坍塌。（✓ / △ / ×）
:::

**A7.** 最优判别器 $D^\star$ 是什么？它把博弈变成了什么？
::: sol
$D^\star(\boldsymbol x)=\dfrac{p_{\text{data}}(\boldsymbol x)}{p_{\text{data}}(\boldsymbol x)+p_g(\boldsymbol x)}$（逐点最大化 $a\log D+b\log(1-D)$ 得到）。代回得 $V(D^\star,G)=2\,\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$，于是 $\min_G\max_DV$ 等价于**最小化两分布的 JS 散度**，全局最优是 $p_g=p_{\text{data}}$、此时 $D^\star\equiv\frac12$、$V^\star=-\log4$（[定理 4.4.1](sec44.md#thm-4.4.1)）。（✓ / △ / ×）
:::

**A8.** 写出扩散的前向单步与一步到位形式；反向过程为什么要学参数？
::: sol
单步：$q(x_t\mid x_{t-1})=\mathcal N(\sqrt{1-\beta_t}x_{t-1},\beta_tI)$；一步到位：$q(x_t\mid x_0)=\mathcal N(\sqrt{\bar\alpha_t}x_0,(1-\bar\alpha_t)I)$，即 $x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\varepsilon$（[定义 4.5.1](sec45.md#def-4.5.1)、[定理 4.5.1](sec45.md#thm-4.5.1)）。**前向是无参数固定过程**（摧毁数据），**反向要从纯噪声还原数据，没有闭式可查**（真实后验需要 $x_0$，采样时恰好没有），所以必须学 $p_\theta(x_{t-1}\mid x_t)$。（✓ / △ / ×）
:::

**A9.** 无分类器引导（CFG）的公式是什么？$w$ 的作用与代价是什么？
::: sol
$\tilde\varepsilon_\theta(x_t,t,c)=\varepsilon_\theta(x_t,t,\varnothing)+w\bigl(\varepsilon_\theta(x_t,t,c)-\varepsilon_\theta(x_t,t,\varnothing)\bigr)$。训练时以一定概率把 $c$ 置空（如 $10\%$），使同一网络同时会做条件与无条件预测。**作用**：$w$ 等于在采样步上沿条件方向 $\nabla\log p(c\mid x_t)$ 多走 $(w-1)$ 倍（$w=1$ 回到普通条件采样）。**代价**：放大条件方向的同时也放大该方向的误差——过大时多样性下降、色彩过饱和、构图僵化；且每步要两次前向（[定义 4.5.3](sec45.md#def-4.5.3)）。（✓ / △ / ×）
:::

**A10.** LDM（潜空间扩散）是什么？一致性模型、整流流、FSQ 各自的一句话定义？
::: sol
**LDM**：先用带感知损失与对抗损失的编码器把图像压到潜空间（典型空间 $8$ 倍、通道 $4$ 或 $16$），再在潜空间上做扩散，采样后一次性解码（[定义 4.6.1](sec46.md#def-4.6.1)）。**一致性模型**：学一个 $f$ 使同一条前向轨迹上任意两点都映到同一个起点（自一致性），从而一步出图（[定义 4.6.3](sec46.md#def-4.6.3)）。**整流流**：在噪声与数据间取直线插值，回归与 $t$ 无关的速度场 $\boldsymbol x_0-\boldsymbol x_1$，再用重流化把轨迹拉直（[定义 4.6.4](sec46.md#def-4.6.4)）。**FSQ**：逐维把实数四舍五入到 $L_i$ 个格子，代码本大小 $K=\prod_iL_i$，无需代码本损失与最近邻搜索（[定义 4.7.3](sec47.md#def-4.7.3)）。（✓ / △ / ×）
:::

**A 组标记**：A1 ☐ / A2 ☐ / A3 ☐ / A4 ☐ / A5 ☐ / A6 ☐ / A7 ☐ / A8 ☐ / A9 ☐ / A10 ☐（✓ / △ / ×）

## B. 结论卡

**B1.** 为什么说「似然高」不能证明「样本好」？给出三条理由。
::: sol
① **似然是加权期望、观感是逐点判断**：对数似然由高密度区（最常见、最平淡的区域）主导，而人看样本时看细节与结构；② **连续密度可以被「偷」**：密度可积但不必有界，[例 4.1.1](sec41.md#ex-4.1.1) 构造的 $q$ 在原点发散使对数似然无界；③ **似然不衡量多样性本身**：「覆盖全部模式但都偏糊」与「只覆盖一个模式但极锐利」可以在同一对数似然下打平。**工程结论**：训练用似然（或其代理），评价同时看感知指标，并对两者的分歧保持警觉。（✓ / △ / ×）
:::

**B2.** VAE 的三件套是哪三件，各自解决什么？少一件会怎样？
::: sol
**先验** $p(z)=\mathcal N(0,I)$ 定采样起点；**ELBO** 定优化目标（下界，缺口是后验与近似后验的 KL）；**重参数化** $z=\boldsymbol\mu+\boldsymbol\sigma\odot\boldsymbol\varepsilon$ 让采样可导。**少先验** → 无法定义从哪采（退化成 AE）；**少 ELBO** → 没有可训练的目标（重建 + KL 的组合正是它）；**少重参数化** → 期望里的采样节点不可导，只能用高方差 REINFORCE，训练慢到不可用。（✓ / △ / ×）
:::

**B3.** 为什么 GAN 天生脆弱？说出三个结构性失效模式。
::: sol
① **支撑不重叠时梯度消失**：初始化的随机网络几乎必然使 $p_{\text{data}}$ 与 $p_g$ 的支撑交集测度为零，此时 $\mathrm{JSD}=\log2$ 为常数、对 $G$ 的梯度**严格为零**；② **非饱和损失只是把病挪位置**：$-\log D(G(z))$ 在 $D(G(z))\to0$ 时不消失（早期可用），但 $D(G(z))\to1$ 时梯度也趋于 0、且早期可能过大而震荡；③ **模式坍塌**：$G$ 只覆盖部分模态却仍让当前 $D$ 无法分辨，$D$ 也不再在这些模态上提供信号——它是**博弈结构**的产物而非调参疏漏（[命题 4.4.1](sec44.md#prop-4.4.1)）。（✓ / △ / ×）
:::

**B4.** 扩散为什么比 GAN 稳、比 VAE 锐？这条结论的代价是什么？
::: sol
**稳**：监督信号是**我们亲手加进去的那份噪声**（已知、无歧义），训练是回归而不是博弈，可复现、无鞍点问题。**锐**：多步去噪逐步修正，且它的参数化不对多个模式做平均（对比 VAE 的高斯解码器把细节平均成均值）。**代价**：采样要 $T$ 次网络前向（DDPM 常 $1000$ 步），CFG 时每步还要 2 次前向；且有「训练与采样的噪声调度 / 归一化范围必须一致」这条硬约束（[4.5](sec45.md) 陷阱框第 2 条）。（✓ / △ / ×）
:::

**B5.** LDM 为什么必须两阶段训练？它的算力收益和代价各是什么？
::: sol
**必须两阶段**：编码器与扩散网络不能端到端一起训——否则 KL 会重新变成可优化对象，训练不稳且丧失「潜空间固定」的工程优势（[方法 4.6.1](sec46.md#method-4.6.1) 的坑 ②）。**收益**：注意力算力比 $\approx3f^4/c$，$f=8,c=4$ 时 **3072 倍**；$512^2\to64^2$ 使单图激活面积下降 $64$ 倍（[命题 4.6.1](sec46.md#prop-4.6.1)）。**代价**：编码器的**重建误差是整条管线的上限**（在小文字、细纹理、医学图像上直接可见），且潜码尺度必须与先验对齐（统计缩放因子 $s$）。（✓ / △ / ×）
:::

**B6.** 为什么整流流更省步数？为什么这**不是**「模型更强」？
::: sol
因为**路径更直**：用欧拉法积分 ODE 时单步误差与轨迹**曲率**成正比——扩散的轨迹在「数据分量 × 噪声分量」平面上是**四分之一圆弧**（速度方向从噪声方向连续转到数据方向，扫过约 $90^\circ$），而整流流的直线路径 $d\boldsymbol x/dt$ 是常数（对直线，欧拉法与解析解相同）。所以同步数下扩散误差更大（[例 4.6.2](sec46.md#ex-4.6.2)）。**不是模型更强**：是路径的**方向变化更小**；而且重流化并非免费——多模态分布上可能让不同路径合并，损失多样性（[例 4.6.2](sec46.md#ex-4.6.2)(c)）。（✓ / △ / ×）
:::

**B7.** 一致性模型的两条训练路线各有什么风险？为什么它能做到 $1\sim4$ 步？
::: sol
**能少步的原因**：前向加噪对应的概率流 ODE 是**确定性**的——给定轨迹上的点，起点唯一确定，因此「任意点 → 起点」是一个良定义、可学的映射。**两条路线**：**一致性蒸馏（CD）** 用教师模型的轨迹训练，配 EMA 目标网络；**一致性训练（CT）** 不用教师，直接构造「同一条链上的两点」。**风险**：CD 的上限受教师限制、且自蒸馏容易坍塌（目标漂移，靠 EMA 稳定）；CT 在高噪声端链的曲率大、更难学（[定义 4.6.3](sec46.md#def-4.6.3)）。（✓ / △ / ×）
:::

**B8.** 为什么说「离散表示天生能表达多模态，连续回归天生产生平均化」？
::: sol
离散化把生成变成**分类**：自回归预测一个 $K$ 类分布，下一个 token 可以是 $A$ 也可以是 $B$，概率各半——分类目标天然表达多峰。而回归目标的最优解是**条件均值**（[命题 4.7.1](sec47.md#prop-4.7.1) 的一步推导），在多模态目标下会把两个模态平均成一个都不像的中间值。**这条差别解释了三件事**：VAE 偏糊、纯回归式蒸馏偏糊（[4.6.5](sec46.md#sec-4.6.5)，所以需要判别器惩罚「糊」）、以及语言模型这条路线在离散 token 上为何如此顺手。（✓ / △ / ×）
:::

**B9.** 四种条件注入手段各作用于哪一层？它们的共同工程前提是什么？
::: sol
**inpainting** → 局部冻结空间结构（只在部分区域去噪，每步回填已知区域）；**ControlNet 类** → 空间结构层（边缘 / 深度 / 姿态逐位置约束，零初始化旁路）；**LoRA** → 权重风格层（$W=W_0+BA$，改风格 / 概念，$B$ 零初始化）；**参考条件** → 语义 / 风格层（另一编码器把参考图变成 token 注入，控制粒度比 ControlNet 粗，**不保证构图**）。**共同前提**：**新增分支必须从恒等（零初始化）开始**，否则随机初始化的分支会立刻破坏预训练模型的行为；这条在本讲出现三次（adaLN-Zero 门、ControlNet 旁路、LoRA 的 $B$）。（✓ / △ / ×）
:::

**B10.** 溯源三层各能证明什么、不能证明什么？
::: sol
**生成期水印**：能回答「是否由某模型生成」（有可计算的检测误差界），不能回答「是谁」，对改写 / 重压缩 / 再生成的鲁棒性有限；**指纹 / 隐写**：能回答「是哪个账户 / 会话生成的」，前提是标识在攻击后仍可恢复（最脆弱的一环）；**内容凭证**：能回答「文件自带元数据是否被篡改」（密码学保证），但不能强制任何平台读取，也不能阻止被剥离后重新分发。**必须写进产品说明**：**没有水印不等于真实**——水印可被去除也可被伪造，溯源只增加可信证据、不是真实性判定器（[4.8.3](sec48.md#sec-4.8.3)）。（✓ / △ / ×）
:::

**B 组标记**：B1 ☐ / B2 ☐ / B3 ☐ / B4 ☐ / B5 ☐ / B6 ☐ / B7 ☐ / B8 ☐ / B9 ☐ / B10 ☐（✓ / △ / ×）

## C. 公式卡

**C1.** 写出 ELBO 及其与真实对数似然的差距。
::: sol
$\mathcal L_{\mathrm{ELBO}}=\mathbb E_{q_\phi(z\mid\boldsymbol x)}[\log p_\theta(\boldsymbol x\mid z)]-\mathrm{KL}(q_\phi(z\mid\boldsymbol x)\|p(z))$；缺口 $\log p_\theta(\boldsymbol x)-\mathcal L_{\mathrm{ELBO}}=\mathrm{KL}(q_\phi(z\mid\boldsymbol x)\|p_\theta(z\mid\boldsymbol x))\ge0$，取等号当且仅当近似后验等于真后验（[定理 4.3.1](sec43.md#thm-4.3.1)）。（✓ / △ / ×）
:::

**C2.** 写出重参数化采样与路径导数梯度。
::: sol
$z=\boldsymbol\mu_\phi(\boldsymbol x)+\boldsymbol\sigma_\phi(\boldsymbol x)\odot\boldsymbol\varepsilon$、$\boldsymbol\varepsilon\sim\mathcal N(\boldsymbol 0,I)$；实现写 $z=\boldsymbol\mu+\exp(\frac12\log\boldsymbol\sigma^2)\odot\boldsymbol\varepsilon$。
$\nabla_\phi\mathbb E_{z\sim q_\phi}[f(z)]=\mathbb E_{\boldsymbol\varepsilon}\bigl[\nabla_z f(z)^{\mathrm T}\nabla_\phi(\boldsymbol\mu_\phi+\boldsymbol\sigma_\phi\odot\boldsymbol\varepsilon)\bigr]$（[命题 4.3.1](sec43.md#prop-4.3.1)）。（✓ / △ / ×）
:::

**C3.** 写出对角高斯与标准正态之间的 KL 闭式，并说明每项的惩罚方向。
::: sol
$\mathrm{KL}\bigl(\mathcal N(\boldsymbol\mu,\operatorname{diag}(\boldsymbol\sigma^2))\,\|\,\mathcal N(0,I)\bigr)=\frac12\sum_{j=1}^{d}\bigl(\mu_j^2+\sigma_j^2-1-\log\sigma_j^2\bigr)$（[命题 4.3.2](sec43.md#prop-4.3.2)）。**读法**：$\mu_j^2$ 把均值拉向原点；$\sigma_j^2$ 惩罚方差过大、$-\log\sigma_j^2$ 惩罚方差过小，二者之和在 $\sigma_j^2=1$ 处取最小 $0$——**单维可以为负**，非负性只对总和成立。（✓ / △ / ×）
:::

**C4.** 写出 GAN 的极小极大目标与最优判别器下的等价距离。
::: sol
$\min_G\max_DV(D,G)=\mathbb E_{\boldsymbol x\sim p_{\text{data}}}[\log D(\boldsymbol x)]+\mathbb E_{z\sim p_z}[\log(1-D(G(z)))]$；$D^\star=\frac{p_{\text{data}}}{p_{\text{data}}+p_g}$；$V(D^\star,G)=2\,\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$（[定义 4.4.1](sec44.md#def-4.4.1)、[定理 4.4.1](sec44.md#thm-4.4.1)）。生成器实操用**非饱和形式** $-\mathbb E_z[\log D(G(z))]$。（✓ / △ / ×）
:::

**C5.** 写出 WGAN 的对偶形式与 WGAN-GP 的损失。
::: sol
$W_1(p,q)=\sup_{\lVert f\rVert_L\le1}\bigl(\mathbb E_{p}[f(\boldsymbol x)]-\mathbb E_{q}[f(\boldsymbol y)]\bigr)$（Kantorovich–Rubinstein 对偶）；WGAN 目标 $\min_G\max_{f\in\mathcal F}\mathbb E_{\text{data}}[f(\boldsymbol x)]-\mathbb E_z[f(G(z))]$，$f$ 去 Sigmoid、称 critic。
WGAN-GP：$\mathcal L=\mathbb E_z[f(G(z))]-\mathbb E_{\boldsymbol x}[f(\boldsymbol x)]+\lambda\mathbb E_{\hat{\boldsymbol x}}\bigl[(\lVert\nabla_{\hat{\boldsymbol x}}f(\hat{\boldsymbol x})\rVert_2-1)^2\bigr]$，$\hat{\boldsymbol x}=\epsilon\boldsymbol x+(1-\epsilon)G(z)$、$\lambda$ 常取 $10$（[定理 4.4.2](sec44.md#thm-4.4.2)）。（✓ / △ / ×）
:::

**C6.** 写出扩散前向闭式、真实后验均值与简化损失。
::: sol
$x_t=\sqrt{\bar\alpha_t}x_0+\sqrt{1-\bar\alpha_t}\varepsilon$（$\bar\alpha_t=\prod_{s\le t}(1-\beta_s)$，两权重平方和为 $1$）；真实后验 $q(x_{t-1}\mid x_t,x_0)=\mathcal N(\tilde{\boldsymbol\mu}_t,\tilde\beta_tI)$，$\tilde{\boldsymbol\mu}_t=\frac{1}{\sqrt{\alpha_t}}\bigl(x_t-\frac{\beta_t}{\sqrt{1-\bar\alpha_t}}\varepsilon\bigr)$、$\tilde\beta_t=\frac{1-\bar\alpha_{t-1}}{1-\bar\alpha_t}\beta_t$；简化损失 $\mathcal L_{\text{simple}}=\mathbb E_{t,x_0,\varepsilon}\bigl[\lVert\varepsilon-\varepsilon_\theta(x_t,t)\rVert^2\bigr]$（[定理 4.5.1](sec45.md#thm-4.5.1)、[命题 4.5.1](sec45.md#prop-4.5.1)、[定理 4.5.2](sec45.md#thm-4.5.2)）。（✓ / △ / ×）
:::

**C7.** 写出完整 VLB 的权重 $w_t$，并说明「预测噪声、预测原图、预测速度」三者的互转。
::: sol
$\mathcal L_{\mathrm{VLB}}=\sum_tw_t\mathbb E[\lVert\varepsilon-\varepsilon_\theta\rVert^2]+\text{const}$，$w_t=\dfrac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}$；DDPM 把全部 $w_t$ 置 1（因此 $\mathcal L_{\text{simple}}$ 不再是下界）。
互转：$\hat x_0=\frac{x_t-\sqrt{1-\bar\alpha_t}\hat\varepsilon}{\sqrt{\bar\alpha_t}}$、$\hat\varepsilon=\frac{x_t-\sqrt{\bar\alpha_t}\hat x_0}{\sqrt{1-\bar\alpha_t}}$、$\hat v=\sqrt{\bar\alpha_t}\hat\varepsilon-\sqrt{1-\bar\alpha_t}\hat x_0$——网络输出是同一条件的三种参数化（[4.5.3](sec45.md#sec-4.5.3)）。（✓ / △ / ×）
:::

**C8.** 写出 DDPM 与 DDIM 的采样更新式。
::: sol
**DDPM（随机，$T$ 步）**：$x_{t-1}=\frac{1}{\sqrt{\alpha_t}}\bigl(x_t-\frac{1-\alpha_t}{\sqrt{1-\bar\alpha_t}}\varepsilon_\theta(x_t,t)\bigr)+\sigma_tz$，$t\gt1$ 时 $z\sim\mathcal N(0,I)$、$t=1$ 时 $z=0$。
**DDIM（$\sigma_t=0$，确定性、可跳步）**：$x_{t'}=\sqrt{\bar\alpha_{t'}}\hat x_0+\sqrt{1-\bar\alpha_{t'}}\hat\varepsilon$，对任意 $t'\in[0,t]$ 自洽（[方法 4.5.1](sec45.md#method-4.5.1)、[方法 4.5.2](sec45.md#method-4.5.2)）。（✓ / △ / ×）
:::

**C9.** 写出整流流/流匹配的插值、速度目标与重流化做法；再写出其算力比。
::: sol
$\boldsymbol x_t=(1-t)\boldsymbol x_1+t\boldsymbol x_0$，$\boldsymbol v=\frac{d\boldsymbol x_t}{dt}=\boldsymbol x_0-\boldsymbol x_1$（与 $t$ 无关）；训练 $\mathcal L_{\text{CFM}}=\mathbb E\lVert\boldsymbol v_\theta(\boldsymbol x_t,t)-(\boldsymbol x_0-\boldsymbol x_1)\rVert^2$；采样解 ODE $\frac{d\boldsymbol x}{dt}=\boldsymbol v_\theta$，从 $t=1$ 积分到 $t=0$。**重流化**：用训好的速度场把噪声—数据重新配对，再训一轮，反复 $1\sim2$ 轮使轨迹变直。
**算力比**：注意力 $\frac{N_2^2c}{N_1^2\cdot3}=\frac{c}{3f^4}$ → 像素侧是潜空间侧的 $3f^4/c$ 倍（$f=8,c=4$ 时 $3072$）（[定义 4.6.4](sec46.md#def-4.6.4)、[命题 4.6.1](sec46.md#prop-4.6.1)）。（✓ / △ / ×）
:::

**C10.** 写出 VQ-VAE 的三项损失与 FSQ 的量化式；给出 $K$ 与比特率算法。
::: sol
$\mathcal L=\lVert\boldsymbol x-\mathcal D(z_q)\rVert_2^2+\lVert\operatorname{sg}[z_e]-e_c\rVert_2^2+\beta\lVert z_e-\operatorname{sg}[e_c]\rVert_2^2$，$z_q=e_c$；STE 写成 `z_q = z_e + (e_c - z_e).detach()`。
FSQ：$\hat z_i=\operatorname{round}\bigl(\lfloor L_i/2\rfloor\tanh(z_i)\bigr)$，$K=\prod_iL_i$。**比特率** $N\log_2K$：$K=512$、$16\times16$ 潜码 → $256\times9=2304$ bit $=288$ 字节/图（[定义 4.7.2](sec47.md#def-4.7.2)、[定义 4.7.3](sec47.md#def-4.7.3)、[例 4.7.1](sec47.md#ex-4.7.1)）。（✓ / △ / ×）
:::

**C 组标记**：C1 ☐ / C2 ☐ / C3 ☐ / C4 ☐ / C5 ☐ / C6 ☐ / C7 ☐ / C8 ☐ / C9 ☐ / C10 ☐（✓ / △ / ×）

## D. 陷阱卡（每题给一个错误说法，请指出错在哪）

**D1.** 「模型 A 的对数似然更高，所以它的样本更好。」
::: sol
**错。** 似然与采样是**两项独立能力**（[命题 4.1.1](sec41.md#prop-4.1.1)）：能量模型有密度无便宜采样、GAN 有采样无密度。而且连续密度**可积不必有界**，[例 4.1.1](sec41.md#ex-4.1.1) 的 $q$ 在原点发散使对数似然无界；对数似然又是加权期望，由高密度区主导。**正确做法**：似然（或代理）与感知指标、覆盖指标、人类盲评**分别度量**。（✓ / △ / ×）
:::

**D2.** 「生成时用编码器对这张图的后验取 $z$，再解码，就得到了新样本。」
::: sol
**错——那是重建，不是生成。** 从 $q_\phi(z\mid\boldsymbol x)$ 取 $z$ 需要给定 $\boldsymbol x$，输出必然贴着该输入；生成必须从**先验** $p(z)=\mathcal N(0,I)$ 采样（[4.3](sec43.md) 陷阱框第 2 条）。这行代码只差一行，但含义完全不同：前者是「压缩—还原 / 条件编辑」，后者才是「无中生有」。（✓ / △ / ×）
:::

**D3.** 「GAN 训不好基本都是代码 bug。」
::: sol
**错。** 极小极大博弈本身就是**鞍点问题**，可能震荡、发散或陷入局部平衡；模式坍塌是**博弈结构**的产物（$D$ 与 $G$ 同时被更新，$D$ 在没见过的模态处永远不会批评它）。正确顺序是**结构 → 超参 → 代码**（[方法 4.4.3](sec44.md#method-4.4.3)）；只在结构（Sigmoid 与损失形式是否匹配、归一化层、输出值域）与超参（学习率比、更新次数比、EMA）都排除后才审代码。（✓ / △ / ×）
:::

**D4.** 「生成批里 64 张几乎一样、$D$ 损失稳在 0.69，说明训练已经很平衡了。」
::: sol
**错——大概率是模式坍塌。** $0.69\approx\log2$ 恰是「$D$ 输出恒为 $0.5$」时二分类交叉熵的值，意味着 $D$ 对真假完全无法分辨；配合「批内样本几乎相同」，说明 $G$ 只覆盖了能让当前 $D$ 无法分辨的少数模态，二者已达**局部平衡**（[4.4.3](sec44.md#sec-4.4.3)）。**处理**：加批内多样性信号（历史缓冲 / mini-batch discrimination）、降 $D$ 的更新频率或容量、打开 EMA、换 WGAN-GP。**判据**：同时记录批内两两相似度与类别覆盖，而不是只看 $D$ 的损失。（✓ / △ / ×）
:::

**D5.** 「扩散模型的 $\mathcal L_{\text{simple}}$ 就是变分下界，可以直接报 bits/dim。」
::: sol
**错。** 完整 VLB 每一项带权重 $w_t=\frac{\beta_t^2}{2\sigma_t^2\alpha_t(1-\bar\alpha_t)}$；$\mathcal L_{\text{simple}}$ 是把**全部 $w_t$ 置 1** 后的加权版本——高噪声步被相对放大、低噪声步被相对缩小，样本质量更好但**不再是下界**。报似然类数字必须用完整 $w_t$ 重算（[定理 4.5.2](sec45.md#thm-4.5.2)、[4.5](sec45.md) 陷阱框第 3 条）。（✓ / △ / ×）
:::

**D6.** 「DDIM 是另一个模型，得重新训练。」
::: sol
**错。** DDIM 只改了**采样时的路径参数化**（非马尔可夫桥梁 + 跳步），所有边际 $q(x_t\mid x_0)$ 完全不变，因此**可以直接复用同一个训练好的 $\varepsilon_\theta$**——零训练成本换 $20\sim50$ 倍加速。代价：$\sigma_t=0$ 时确定性、多样性略降；步数过少时 $\hat x_0$ 的单次估计误差被放大成可见失真（[4.5.4](sec45.md#sec-4.5.4)）。（✓ / △ / ×）
:::

**D7.** 「训练用一套噪声调度，采样时换个更快的调度，或者把像素范围改成 $[0,1]$，都没问题。」
::: sol
**错，这是症状最剧烈的一脚。** $\beta_t$、$\bar\alpha_t$ 与像素归一化范围（如 $[-1,1]$）必须**训练与采样一致**，否则加噪与去噪的统计对不上，采样会直接崩坏（典型表现：输出全灰噪声）——这正是 [4.5](sec45.md) 陷阱框第 2 条的「采样直接崩坏」。同理，LDM 里潜码的**尺度**必须与先验匹配（先统计缩放因子 $s$，令 $z\leftarrow sz$ 后再做扩散，采样后除以 $s$）（[方法 4.6.1](sec46.md#method-4.6.1) 的坑 ①）。（✓ / △ / ×）
:::

**D8.** 「代码本利用率只有 8%，说明 $K$ 设太大了——砍小 $K$ 就行。」
::: sol
**错（这是左右为难的权衡，不是单向优化）。** 砍小 $K$ 确实能提高利用率百分比，但代价是**每 token 信息量下降**（$\log_2K$ 减少），序列要更长才能表达同样信息。正确判据是**重构质量与生成质量的联合表现**，而不是单独盯利用率。要处理死码字，应调 $\beta$（太大压制编码器表达、太小追不上漂移）、检查编码器尺度，或改用 FSQ 这类不需要代码本学习的方案（[4.7.4](sec47.md#sec-4.7.4)）。（✓ / △ / ×）
:::

**D9.** 「少步就是一步——反正蒸馏到位了效果一样。」
::: sol
**错。** 一致性模型与 LCM 论文验证的是 $1\sim4$ 步的**可用性**，而在复杂条件（长文本、多物体）下少步质量下降明显；且少步路线各自有明确上限与风险：蒸馏路线**上限受教师限制**、自蒸馏易坍塌（靠 EMA 稳定）；重流化在**多模态分布**上可能让路径合并、损失多样性（[例 4.6.2](sec46.md#ex-4.6.2)(c)）。**正确说法**：先定**延迟预算**，再在「步数 × 每步成本 × 额外训练」三者的表里选一行（[方法 4.6.4](sec46.md#method-4.6.4)），并实测而不是照搬论文。（✓ / △ / ×）
:::

**D10.** 「我们的图带水印，所以不可能是伪造的 / 没有水印的图一定真实。」
::: sol
**两个方向都错。** 生成期水印能被改写、重压缩、再生成削弱甚至去除，也能被**伪造到真实内容上**；它只能回答「是否由某模型生成」，不回答「是谁」。因此**没有水印不等于真实**——这是 [4.8.3](sec48.md#sec-4.8.3) 的反直觉提醒。工程上要做的是三层组合（生成期水印 + 指纹 + 内容凭证）并交付**受控攻击下的检测率曲线与假阳性率**，同时明确每层「能证明什么、不能证明什么」，把溯源定位成「增加可信证据」而不是真实性判定器。（✓ / △ / ×）
:::

**D 组标记**：D1 ☐ / D2 ☐ / D3 ☐ / D4 ☐ / D5 ☐ / D6 ☐ / D7 ☐ / D8 ☐ / D9 ☐ / D10 ☐（✓ / △ / ×）

## 导出到 Anki / CSV

1. **打开 Anki → 新建卡组「DL-第 4 讲」**（建议再按 A/B/C/D 建四个子卡组：定义 / 结论 / 公式 / 陷阱，方便按组复习）。
2. **用「问题 → 答案」逐条录入**：最简单的方式是在纯文本里按 `问题<Tab>答案` 组织（答案里的公式保留 `$...$` 原文，Anki 会原样显示；装了 LaTeX 插件可正常渲染），再用 Anki 的「文件 → 导入」选 `Tab` 分隔，把第一列映射为「正面」、第二列映射为「背面」。答案里请保留**依据链接的编号**（例如 `定义 4.5.1`），它比正文链接更适合当检索线索。
3. **复习节点：当天 / 隔天 / 第 3 天 / 第 7 天**。当天只做 A 组（定义）与 C 组（公式）；隔天做 B 组（结论）；第 3 天做 D 组（陷阱）；第 7 天做全卡组混排，同时用[综合自测卷](mock-exam.md)做一次闭卷计时。
4. **每轮只重做标 △ 与 × 的卡**；出现「能背出结论但说不出适用条件」的情况一律按 △ 处理——本讲绝大多数错误都发生在**条件**上（扩散稳的条件、CFG 有效的条件、离散表示多模态的条件、少步可用的条件、零初始化必要的条件）。
5. **建议的先修顺序**：若 A4–A6（VAE 定义 / 重参数化 / 后验坍塌）大面积卡住，先回 [4.3](sec43.md) 重读，再刷 B2、B4、C1–C3；若 B6、B9 卡住，说明 [4.6](sec46.md) 与 [4.8.2](sec48.md#sec-4.8.2) 的机制还没串起来，先做[习题集](exercises.md) B4、C6 与 D3。
