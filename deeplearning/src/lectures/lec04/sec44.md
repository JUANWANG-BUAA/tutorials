# 4.4 生成对抗网络：用博弈换锐利

VAE 靠一个显式的似然目标工作，代价是样本偏模糊。**生成对抗网络**（Generative Adversarial Network, GAN）换了一条路：**不写似然，直接让「造假者」和「鉴定者」互相较劲**。

这条路走通之后，样本锐利度立刻上了一个台阶——因为判别器能看见的区域是**整张图**，任何局部的不真实（糊边、错位的纹理）都会被抓到；而 VAE 的高斯解码器是按像素独立建模的，压根没有一个「整体看起来真不真」的信号。代价同样立刻出现：两个网络目标相反，训练变成一个**没有稳定收敛保证的鞍点博弈**，会出现震荡、梯度消失与模式坍塌。

本节要回答的问题有三层：这个博弈的目标函数是什么、最优点在哪？为什么最优点附近反而训不动（梯度消失）？以及工程上用什么手段让它在实践中可用（非饱和损失、WGAN、谱归一化、TTUR、EMA）。

## 4.4.1 极小极大博弈

::: def 定义 4.4.1 · GAN 的极小极大目标 {#def-4.4.1}
GAN 有两个网络：**生成器** $G(z;\theta_g)$ 把噪声 $z\sim p_z$ 映射成样本（$p_z$ 常取 $\mathcal N(0,I)$），其诱导的分布记作 $p_g$（即 $G$ 对 $p_z$ 的推前分布）；**判别器** $D(\boldsymbol x;\theta_d)\in(0,1)$ 输出「$\boldsymbol x$ 是真实数据的概率」。二者玩一个**极小极大博弈**：

$$\min_G\max_D\ V(D,G)=\mathbb E_{\boldsymbol x\sim p_{\text{data}}}\bigl[\log D(\boldsymbol x)\bigr]+\mathbb E_{z\sim p_z}\bigl[\log\bigl(1-D(G(z))\bigr)\bigr].$$
:::

::: intuition 目标函数要分开读
$D$ 想**最大化** $V$——让真实样本的 $D$ 趋近 $1$、生成样本的 $D$ 趋近 $0$；$G$ 想**最小化** $V$——让 $D(G(z))$ 趋近 $1$，也就是把假的做得让 $D$ 认不出来。二者目标相反，构成一场零和博弈。

三个容易读错的点：

1. **$G$ 并不试图「骗过人类」，只试图骗过当前的 $D$**。$D$ 是唯一的评价者，$D$ 的盲区就是 $G$ 的毕业考试范围。这一点直接导致模式坍塌（[4.4.3](#sec-4.4.3)）。
2. **$D$ 的输出是概率而非分数**。这个设计选择让推导漂亮（见 [4.4.2](#sec-4.4.2)），但也带来了饱和问题；WGAN 的做法之一是干脆去掉 Sigmoid（[4.4.4](#sec-4.4.4)）。
3. **没有 $\log$ 就没有「均匀关注」**。取对数后，$D$ 对两类样本的关注度是非线性的；这一点在对抗蒸馏（[4.6](sec46.md)）里会以几乎相反的方式再出现。
:::

::: method 交替训练算法（最外层循环） {#method-4.4.1}
GAN 的训练是**交替**的：固定一方，更新另一方。最朴素的版本（每轮更新 $k$ 次 $D$、$1$ 次 $G$）：

```text
for 每个训练轮次:
    for k 次:                                   # 判别器：最大化 V
        取一个真实批 x ~ p_data，一个噪声批 z ~ p_z
        梯度上升：∇_{θ_d} [ log D(x) + log(1 - D(G(z))) ]
    for 1 次:                                   # 生成器：最小化 V（或其等价形式）
        取一个噪声批 z ~ p_z
        梯度下降：∇_{θ_g} [ log(1 - D(G(z))) ]    # 实操中常用非饱和形式，见 4.4.3
```

**两个必须记住的实现细节**：

1. **更新 $G$ 时要把 $D$ 的梯度切掉**（`D(G(z)).detach()` 之类的写法在交替训练里并不需要，但更新 $G$ 时只对 $\theta_g$ 做 `step()`、不给 $D$ 的参数更新）；反之亦然。
2. **$k$ 与学习率比是重要的超参**，它们控制的正是「$D$ 有多强」。$D$ 太弱 → $G$ 拿到的是噪声信号；$D$ 太强 → $G$ 的梯度消失（[4.4.3](#sec-4.4.3)）。
:::

## 4.4.2 最优判别器与 JS 散度

关键问题是：这场博弈的最优点是什么？

::: thm 定理 4.4.1 · 最优判别器与 JS 散度 {#thm-4.4.1}
固定 $G$（即固定 $p_g$），使 $V(D,G)$ 最大的判别器为
$$D^\star(\boldsymbol x)=\frac{p_{\text{data}}(\boldsymbol x)}{p_{\text{data}}(\boldsymbol x)+p_g(\boldsymbol x)} .$$
代回 $V$，得
$$V(D^\star,G)=-\log4+2\,\mathrm{JSD}\bigl(p_{\text{data}}\,\|\,p_g\bigr),$$
其中 $\mathrm{JSD}$ 是**对称化的 KL 散度**：$\mathrm{JSD}(p\|q)=\tfrac12\mathrm{KL}(p\|m)+\tfrac12\mathrm{KL}(q\|m)$，$m=\tfrac12(p+q)$，取值在 $[0,\log2]$。因此当 $D$ 被训到最优时，$\min_G\max_D V$ 等价于**最小化数据分布与生成分布之间的 JS 散度**；全局最优解为 $p_g=p_{\text{data}}$，此时 $D^\star\equiv\tfrac12$、$V^\star=-\log4$。
:::

::: proof 推导（最优 $D$ 与 JS 散度）
固定 $G$ 后，$p_g$ 固定，$V$ 是一个关于函数 $D(\cdot)$ 的泛函：
$$V(D)=\int\Bigl[p_{\text{data}}(\boldsymbol x)\log D(\boldsymbol x)+p_g(\boldsymbol x)\log\bigl(1-D(\boldsymbol x)\bigr)\Bigr]d\boldsymbol x .$$
被积函数只在每个 $\boldsymbol x$ 处单独依赖 $D(\boldsymbol x)$，可以**逐点**最大化。令 $a=p_{\text{data}}(\boldsymbol x)$、$b=p_g(\boldsymbol x)$，对 $a\log D+b\log(1-D)$ 关于 $D$ 求导并置零：
$$\frac{a}{D}-\frac{b}{1-D}=0\ \Longrightarrow\ D^\star(\boldsymbol x)=\frac{a}{a+b}=\frac{p_{\text{data}}(\boldsymbol x)}{p_{\text{data}}(\boldsymbol x)+p_g(\boldsymbol x)} .$$
（二阶导 $-\frac{a}{D^2}-\frac{b}{(1-D)^2}\lt0$，故为极大值点。）

把 $D^\star$ 代回，令 $m=\tfrac12(p_{\text{data}}+p_g)$，则 $p_{\text{data}}+p_g=2m$，且 $\tfrac{a}{a+b}=\tfrac{p_{\text{data}}}{2m}$、$\tfrac{b}{a+b}=\tfrac{p_g}{2m}$：
$$V(D^\star,G)=\int\Bigl[p_{\text{data}}\log\frac{p_{\text{data}}}{2m}+p_g\log\frac{p_g}{2m}\Bigr]d\boldsymbol x
=\int\Bigl[p_{\text{data}}\log\frac{p_{\text{data}}}{m}+p_g\log\frac{p_g}{m}\Bigr]d\boldsymbol x-\log2\int(p_{\text{data}}+p_g)\,d\boldsymbol x .$$
（最后一步把 $\log\frac{1}{2m}=\log\frac{1}{m}-\log2$ 拆开。）两个分布都积分为 $1$，故末项为 $\log2\cdot2=\log4$；括号内积分恰为 $2\,\mathrm{JSD}$：
$$\int\Bigl[p_{\text{data}}\log\frac{p_{\text{data}}}{m}+p_g\log\frac{p_g}{m}\Bigr]d\boldsymbol x
=\mathrm{KL}(p_{\text{data}}\|m)+\mathrm{KL}(p_g\|m)=2\,\mathrm{JSD}(p_{\text{data}}\|p_g).$$
即 $V(D^\star,G)=2\,\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$。**JSD 非负且当且仅当两个分布几乎处处相等时取 $0$**，故全局最优是 $p_g=p_{\text{data}}$，此时 $m=p_{\text{data}}=p_g$、$\mathrm{JSD}=0$、$V^\star=-\log4$。$\blacksquare$
:::

::: intuition 「最优判别器」告诉了我们三件事
**第一，GAN 的目标被翻译成了一个我们能看懂的距离**——JS 散度。这是理论上最漂亮的一步：一个纯博弈居然等价于一个分布距离的最小化。

**第二，也正因为翻译成了 JS，我们看到了病根。** JS 散度有两个致命性质，它们在训练早期几乎必然出现（详见 [4.4.3](#sec-4.4.3)）：当两个分布的**支撑不重叠**时，JS 是常数 $\log2$（对 $G$ 的梯度为零）；当 $D$ 训得越好、越接近 $D^\star$，$G$ 在生成样本处的梯度越接近零。

**第三，最优点本身是「谁都赢不了」的状态**：$D^\star\equiv\tfrac12$ 意味着判别器对真实与生成样本完全无法分辨。这个状态在实践中极难达到，也不该追求——它对应「$G$ 与 $D$ 完全对消」，此时 $D$ 再也提供不了任何有用信号。
:::

::: ex 例 4.4.1 · 手算一次「梯度消失」 {#ex-4.4.1}
设数据分布是单点质量的连续化版本：$p_{\text{data}}=\mathcal N(0,\,10^{-4})$，生成分布是 $p_g=\mathcal N(\theta,\,10^{-4})$（一个只含一个参数的生成器：$G$ 就输出常数 $\theta$）。求 $D^\star$，并说明当 $|\theta|\gg10^{-2}$（两个分布的标准差是 $10^{-2}$）时，生成器收到的梯度有多小。

::: proof 解
**① 两个密度在支撑上几乎不重叠。** 两者标准差都是 $\sigma=10^{-2}$。两个高斯在均值相距 $d$ 时，只有当 $d\lesssim\sigma$ 才有显著重叠；本例中 $|\theta|\gg10^{-2}$ 意味着 $d\gg\sigma$。

**② 逐点最优判别器几乎是一个阶跃函数。** 在 $\boldsymbol x=0$ 附近（真实密度显著非零处），$p_g(0)/p_{\text{data}}(0)=\exp\bigl(-\frac{0^2-\theta^2}{2\sigma^2}\bigr)=\exp\bigl(\frac{\theta^2}{2\sigma^2}\bigr)$，于是
$$D^\star(0)=\frac{1}{1+\exp(\theta^2/(2\sigma^2))}\ \approx\ \begin{cases}0.12 & |\theta|=0.02\\ 1.4\times10^{-22} & |\theta|=0.05\\ 0 & |\theta|\ge0.1\end{cases}$$
同理在 $\boldsymbol x=\theta$ 附近 $D^\star(\theta)\to1$。**判别器只要学会「离 0 近判真、离 θ 近判假」，就把 $V$ 几乎顶到了理论上界。**

**③ 生成器的梯度：理论值与网络实测值的差别。** 生成器的目标是 $\min_\theta\log\bigl(1-D^\star(\theta)\bigr)$（此处 $D^\star(\theta)$ 表示在生成样本所在处的取值）。把 $D^\star=\frac{1}{1+e^{\theta^2/(2\sigma^2)}}$（由 ② 的等比式 $p_{\text{data}}/(p_{\text{data}}+p_g)=\frac{1}{1+p_g/p_{\text{data}}}$ 得到）代入：
$$\log\bigl(1-D^\star(\theta)\bigr)=-\log\bigl(1+e^{\theta^2/(2\sigma^2)}\bigr)\ \overset{|\theta|\gg\sigma}{\approx}\ -\frac{\theta^2}{2\sigma^2}
\quad\Longrightarrow\quad \Bigl|\frac{d}{d\theta}\log(1-D^\star)\Bigr|\approx\frac{|\theta|}{\sigma^2}.$$
取 $\theta=0.05,\ \sigma^2=10^{-4}$：$|g'|\approx500$——**解析最优 $D^\star$ 给出的梯度并不小**。

**④ 但网络学到的 $D$ 不是解析的 $D^\star$，而是它的一个「偏移版」。** 真实的 $D$ 用 Sigmoid 输出，训练后典型形态是 $D(\theta)=1-\varepsilon$（$\varepsilon$ 极小，例如 $10^{-6}$）。此时
$$\Bigl|\frac{d}{d\theta}\log\bigl(1-D(\theta)\bigr)\Bigr|=\frac{1}{1-D}\Bigl|\frac{dD}{d\theta}\Bigr|\approx\frac{|D'(\theta)|}{\varepsilon}.$$
关键在于：$D$ 学到的边界近似会让 $|D'(\theta)|$ 也随 $\varepsilon$ 同阶缩小（判别器的输出在该点已被压到几乎饱和的平台上，斜率趋零），于是乘积趋于零 —— **梯度的量级与 $\varepsilon$ 一起消失，数值上等价于「梯度为零」。** 这正是实践中的观察：$D$ 的损失降到很低时，$G$ 就不再动了。

**⑤ 用 $2\,\mathrm{JSD}$ 读同一件事。** 由定理 4.4.1，$V(D^\star,G)=2\,\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$。当支撑不重叠时 $\mathrm{JSD}$ 恒等于 $\log2$（此时 $m=\frac{p_{\text{data}}+p_g}{2}$ 的支撑被切成互不相交的两块，两项 KL 各等于 $\log2$）——**与 $\theta$ 无关，梯度严格为零**。这才是「梯度消失」的准确表述：它发生在最优 $D$ 的极限处，而不是在 $D$ 的半成品状态。

**结论**：原始 GAN 目标在「判别器足够好」时会给出指数级/零梯度。工程上有三条出路——换非饱和损失、限制 $D$ 的强度（谱归一化 / 梯度惩罚）、换一个在支撑不重叠时仍有梯度的距离（WGAN，[4.4.4](#sec-4.4.4)）。$\blacksquare$
:::
:::

## 4.4.3 为什么 GAN 天生脆弱 {#sec-4.4.3}

::: prop 命题 4.4.1 · GAN 的三个结构性失效模式 {#prop-4.4.1}
**（i）支撑不重叠时梯度消失。** 若 $p_{\text{data}}$ 与 $p_g$ 的支撑交集测度为零（初始化的随机网络几乎必然如此），则 $\mathrm{JSD}(p_{\text{data}}\|p_g)=\log2$ 为常数，**关于 $G$ 的梯度严格为零**；$G$ 得不到任何方向信息。

**（ii）非饱和损失把病挪了位置。** 生成器改用 $-\mathbb E_z\bigl[\log D(G(z))\bigr]$（等价的目标，梯度方向相同但尺度不同）后，在 $D(G(z))\to0$ 时它的梯度**不会消失**（$-\log$ 在 $0$ 附近发散），因此在早期更可用；但代价是当 $D(G(z))\to1$ 时梯度趋于 $0$、且早期梯度可能**过大导致震荡**。

**（iii）模式坍塌（mode collapse）。** 存在一个 $G$ 使 $p_g$ 只覆盖 $p_{\text{data}}$ 的少数模态，却仍能让当前的 $D$ 接近最优：因为 $D$ 只需在这几个模态上判对，而在没见过的模态处，$D$ 与 $G$ **同时**被更新，永远不会停下来批评它。它是**博弈结构**的产物，而不是调参疏漏。
:::

::: intuition 模式坍塌：一场「没有老师」的考试
把训练想成考试：$G$ 是学生，$D$ 是出题人，$p_{\text{data}}$ 是唯一的课本。经典监督学习里，课本固定、考试范围固定；GAN 里**出题人也在跟学生一起学**——学生发现「只回答一个知识点就能及格」，出题人接下来就只考那一个知识点，二者达成局部平衡，学生再也不会去学其他章节。

这条机制有三个可观察的后果：

- **样本多样性崩溃**：不同 $z$ 解码出几乎相同的图（把 $z$ 网格化后看，输出几乎没有变化）。
- **训练指标「看起来很好」**：$D(G(z))$ 稳定在 $0.5$ 附近，$V\approx-\log4$，像达成了最优——但 $p_g\ne p_{\text{data}}$。
- **重启一次结果不同**：因为坍塌到的模态是随机的（取决于初始化与随机种子）。

**判据（可直接写进实验报告）**：生成 $n=64$ 组不同 $z$ 的样本，计算它们的两两相似度（如 LPIPS 或像素距离的中位数）。中位数异常低（样本过于相似）就应怀疑坍塌；再对比**类别覆盖**（生成样本过分类器后的类别分布与数据集的类别分布距离）。这两个数字比 $D$ 的损失曲线可靠得多。
:::

::: think 判别器一定要训到最优吗
不需要，也**不应该**。定理 4.4.1 说的是「$D$ 最优时 $G$ 等价于在最小化 JS 散度」，但训练是交替的：若每步都把 $D$ 训到最优，$G$ 反而困在梯度消失区（[例 4.4.1](#ex-4.4.1)）。实践中的平衡是——让 $D$ 强到能提供有区分度的信号，又弱到让 $G$ 有可用的梯度。这个「既不能太强也不能太弱」的窗口很窄，正是 GAN 调参痛苦的来源（两网学习率比、更新次数比都围绕它调）。

**一个有用的替代视角**：与其问「$D$ 该多强」，不如问「$D$ 提供的信息谱有多宽」。一个只判别「真/假」的 $D$ 提供的是标量信号；一个能对**局部**（patch）判别的 $D$（如 PatchGAN）提供的是空间分辨的信号，即使容量不高也能给出更丰富的梯度。这解释了为什么图像 GAN 普遍用 patch 级判别器。
:::

## 4.4.4 WGAN：换一个距离，把梯度找回来 {#sec-4.4.4}

要修的是「支撑不重叠时距离是常数」这个病。数学上有现成的工具：**推土机距离**（Earth Mover's Distance, EMD，又称 Wasserstein-1 距离）在整个空间中都是连续的。

::: thm 定理 4.4.2 · Kantorovich–Rubinstein 对偶与 WGAN {#thm-4.4.2}
设 $\Pi(p,q)$ 为所有以 $p,q$ 为边缘的联合分布的集合，Wasserstein-1 距离定义为
$$W_1(p,q)=\inf_{\gamma\in\Pi(p,q)}\mathbb E_{(\boldsymbol x,\boldsymbol y)\sim\gamma}\bigl[\lVert\boldsymbol x-\boldsymbol y\rVert\bigr].$$
则由 Kantorovich–Rubinstein 对偶，
$$W_1(p,q)=\sup_{\lVert f\rVert_L\le1}\Bigl(\mathbb E_{\boldsymbol x\sim p}\bigl[f(\boldsymbol x)\bigr]-\mathbb E_{\boldsymbol y\sim q}\bigl[f(\boldsymbol y)\bigr]\Bigr),$$
其中上确界取遍所有**1-Lipschitz** 函数（$\lvert f(\boldsymbol x)-f(\boldsymbol y)\rvert\le\lVert\boldsymbol x-\boldsymbol y\rVert$）。因此 WGAN 用下面的目标替代原始 GAN：
$$\min_G\max_{f\in\mathcal F}\ \mathbb E_{\boldsymbol x\sim p_{\text{data}}}\bigl[f(\boldsymbol x)\bigr]-\mathbb E_{z\sim p_z}\bigl[f(G(z))\bigr],$$
其中 $\mathcal F$ 是「1-Lipschitz 约束下的函数族」——网络**去掉最后的 Sigmoid**（判别器变成「评论家」critic，输出实数分数）。其关键性质是：**$W_1$ 对两个分布的移动是连续的**，尤其在支撑不重叠时仍然给出与「距离」成正比的非零梯度。
:::

::: intuition 「推土机」比「有没有重叠」更细腻
JS 散度问的是「两个分布有没有重叠」——一旦不重叠，它就一律回答「完全没有」（$\log2$），不管两者是紧邻还是相隔十万八千里。**EMD 问的是「需要多少搬运功才能把一个分布堆成另一个」**：两个相距 0.01 的高斯转移代价很小，相距 10 的高斯代价很大。于是无论重叠与否，它都给出**方向明确、大小成比例**的梯度。

「1-Lipschitz 约束」为什么要加？它是对偶公式成立的前提，也给了距离的尺度（把 $f$ 的斜率放大 $k$ 倍，$\mathbb E f$ 的差也会放大 $k$ 倍，不约束就让上确界发散）。**WGAN 的全部工程困难都来自「怎么高效地施加这个约束」**：

| 做法 | 机制 | 特点 |
|:--|:--|:--|
| 权重裁剪 | 每次更新后把 $f$ 的权重逐元素裁到 $[-c,c]$ | 简单，但会把网络逼成「极端稀疏 / 饱和」的形态，容量被浪费；$c$ 敏感 |
| **梯度惩罚（WGAN-GP）** | 不裁权重，改为惩罚 $\bigl(\lVert\nabla_{\hat{\boldsymbol x}}f(\hat{\boldsymbol x})\rVert_2-1\bigr)^2$，其中 $\hat{\boldsymbol x}$ 是真实与生成样本的随机插值 | 实践中最常用；每个 batch 多算一次（图上）梯度 |
| **谱归一化** | 对每层权矩阵做幂迭代，把谱范数归一到 1 | 对判别器整体 Lipschitz 常数给出可控上界，无需额外的梯度惩罚项 |

WGAN-GP 的完整目标（$\lambda$ 常取 $10$）：
$$\mathcal L=\underbrace{\mathbb E_{z}\bigl[f(G(z))\bigr]-\mathbb E_{\boldsymbol x}\bigl[f(\boldsymbol x)\bigr]}_{\text{评论家：最大化搬动距离}}+\lambda\,\underbrace{\mathbb E_{\hat{\boldsymbol x}}\Bigl[\bigl(\lVert\nabla_{\hat{\boldsymbol x}}f(\hat{\boldsymbol x})\rVert_2-1\bigr)^2\Bigr]}_{\text{梯度惩罚}},\qquad \hat{\boldsymbol x}=\epsilon\boldsymbol x+(1-\epsilon)G(z),\ \epsilon\sim\mathcal U(0,1).$$
:::

::: errata WGAN 的理论与实践差距
1. **对偶公式要求 $f$ 在整个空间上 1-Lipschitz**，而实践只能在一个批次的点上近似施加约束。因此「训练 WGAN 就等于最小化 $W_1$」只是近似说法，不能当作严格保证。
2. **梯度惩罚里的插值点是启发式选择**。理论上的约束与「只在真实—生成连线附近」无关；这个选择来自「最优 critic 的梯度范数在这条线上最接近 1」的经验观察。
3. **BatchNorm 要换成 LayerNorm / 无归一化**。梯度惩罚是对**每个样本**的梯度做约束，BatchNorm 让样本之间产生耦合，破坏惩罚的含义（WGAN-GP 论文明确建议不用 BatchNorm）。
4. **$W_1$ 的数值与样本尺度绑定**：比较两次实验的 critic 损失时，必须确认数据归一化方式相同；否则「损失变好了」可能只是尺度变了。
:::

## 4.4.5 训练技巧清单

::: method GAN 工程清单（按「先做什么」排序） {#method-4.4.2}
1. **损失形式**：生成器用**非饱和损失** $-\mathbb E_z[\log D(G(z))]$（或 hinge / WGAN 形式）。这是最低成本的改进，先做它。
2. **把判别器压住**：谱归一化（推荐默认）或 WGAN-GP 的梯度惩罚。二者的目的相同——让 $D$ 在提供有用信号的同时不至于把梯度吃掉。
3. **TTUR（两时间尺度更新规则）**：给 $D$ 与 $G$ 不同的学习率（常见做法是 $D$ 的学习率略高、或 $G$ 略高，需按任务试），让两个网络的更新速度不失衡。
4. **EMA（指数滑动平均）**：维护 $\theta_g^{\text{EMA}}\leftarrow\tau\theta_g^{\text{EMA}}+(1-\tau)\theta_g$，用它生成样本。EMA 抹掉最近几步的震荡，几乎是图像 GAN 的默认配置。
5. **噪声注入**：给 $D$ 的输入加微小噪声（或标签平滑，如真实标签取 $0.9$ 而非 $1.0$），防止 $D$ 变得过于自信。
6. **批统计与多样性保护**：图像 GAN 常用「历史样本缓冲」或 mini-batch discrimination 之类的机制，让 $D$ 能看见生成批内的多样性并惩罚坍塌。
7. **监控指标**：不只看 $D$ 与 $G$ 的损失。至少同时记录——生成批内的两两相似度（多样性）、生成样本过分类器后的类别覆盖、以及按固定种子生成的样本栅格图。
8. **评估**：用 [4.1](sec41.md) 的口径记录 FID 与近邻去记忆检查；单次实验的数字不可作结论。
:::

## 4.4.6 代码：DCGAN 骨架 + 谱归一化 + TTUR + EMA

```python
import copy, torch, torch.nn as nn

def sn(module):
    """给卷积 / 线性层加谱归一化：对权矩阵做幂迭代，把谱范数归一。
    这是「压住判别器」最省事的手段，也是 WGAN 之外的现代默认做法。"""
    return nn.utils.parametrizations.spectral_norm(module)

class D(nn.Module):
    """判别器（评论家）：末尾**不加 Sigmoid**，直接给实数分数。
    用 hinge / WGAN 类损失时这是必需的；若用原始 GAN 损失，在 forward 里显式加 sigmoid。"""
    def __init__(self, ch=64, sn_on=True):
        super().__init__()
        mk = (lambda f: sn(f)) if sn_on else (lambda f: f)
        self.net = nn.Sequential(
            mk(nn.Conv2d(3, ch, 4, 2, 1)), nn.LeakyReLU(0.2, inplace=True),   # 64 -> 32
            mk(nn.Conv2d(ch, ch * 2, 4, 2, 1)), nn.LeakyReLU(0.2, inplace=True),  # 32 -> 16
            mk(nn.Conv2d(ch * 2, ch * 4, 4, 2, 1)), nn.LeakyReLU(0.2, inplace=True),  # 16 -> 8
            nn.Flatten(), mk(nn.Linear(ch * 4 * 8 * 8, 1)),                   # 输出 (B, 1) 实数
        )
        # 注意：不要用 BatchNorm —— 见 4.4.4 的 errata 第 3 条

    def forward(self, x):
        return self.net(x)

class G(nn.Module):
    """生成器：把 (B, d) 的噪声映射成 (B, 3, 64, 64) 的图像。"""
    def __init__(self, d=128, ch=64):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(d, ch * 8 * 4 * 4), nn.BatchNorm1d(ch * 8 * 4 * 4), nn.ReLU(True),
            nn.Unflatten(1, (ch * 8, 4, 4)),                                  # (B, 512, 4, 4)
            nn.ConvTranspose2d(ch * 8, ch * 4, 4, 2, 1), nn.BatchNorm2d(ch * 4), nn.ReLU(True),  # 4 -> 8
            nn.ConvTranspose2d(ch * 4, ch * 2, 4, 2, 1), nn.BatchNorm2d(ch * 2), nn.ReLU(True),  # 8 -> 16
            nn.ConvTranspose2d(ch * 2, ch, 4, 2, 1), nn.BatchNorm2d(ch), nn.ReLU(True),          # 16 -> 32
            nn.ConvTranspose2d(ch, 3, 4, 2, 1), nn.Tanh(),                    # 32 -> 64，输出归到 [-1, 1]
        )

    def forward(self, z):
        return self.net(z)

def train_step(G, D, real, d=128, device="cpu", use_wgan_gp=False, lam=10.0):
    B = real.size(0)
    z = torch.randn(B, d, device=device)
    fake = G(z)

    if use_wgan_gp:
        # WGAN-GP：评论家最大化 E[f(G(z))] - E[f(x)]，外加梯度惩罚
        x_hat = (torch.rand(B, 1, 1, 1, device=device) * real +
                 (1 - torch.rand(B, 1, 1, 1, device=device)) * fake).requires_grad_(True)
        f_hat = D(x_hat)
        grad = torch.autograd.grad(f_hat.sum(), x_hat, create_graph=True)[0]
        gp = ((grad.flatten(1).norm(2, dim=1) - 1) ** 2).mean()
        d_loss = D(fake.detach()).mean() - D(real).mean() + lam * gp   # 最小化它 = 最大化搬动距离
    else:
        # 原始 GAN + Sigmoid；判别器是标准二分类器
        d_loss = (nn.functional.binary_cross_entropy_with_logits(D(real), torch.ones(B, 1, device=device)) +
                  nn.functional.binary_cross_entropy_with_logits(D(fake.detach()), torch.zeros(B, 1, device=device)))

    # 生成器：**非饱和损失** —— 直接最大化 log D(G(z))，而不是最小化 log(1 - D(G(z)))
    g_loss = -nn.functional.logsigmoid(D(fake)).mean() if not use_wgan_gp else -D(fake).mean()
    return d_loss, g_loss

# 训练循环骨架：TTUR（判别器学习率略高）+ 生成器 EMA
def train(G, D, loader, steps=10000, lr_d=4e-4, lr_g=1e-4, d=128):
    opt_d = torch.optim.Adam(D.parameters(), lr=lr_d, betas=(0.5, 0.999))   # GAN 用 beta1=0.5 是惯例
    opt_g = torch.optim.Adam(G.parameters(), lr=lr_g, betas=(0.5, 0.999))   # lr_d != lr_g 即 TTUR
    G_ema = copy.deepcopy(G).eval()
    for p in G_ema.parameters():
        p.requires_grad_(False)
    it = iter(loader)
    for i in range(steps):
        try:
            real, _ = next(it)
        except StopIteration:
            it = iter(loader); real, _ = next(it)
        d_loss, _ = train_step(G, D, real, d, use_wgan_gp=USE_WGAN_GP)
        opt_d.zero_grad(); d_loss.backward(); opt_d.step()          # 只更新 D

        _, g_loss = train_step(G, D, real, d, use_wgan_gp=USE_WGAN_GP)
        opt_g.zero_grad(); g_loss.backward(); opt_g.step()          # 只更新 G

        for p_ema, p in zip(G_ema.parameters(), G.parameters()):    # EMA：生成样本时用它
            p_ema.mul_(0.999).add_(p, alpha=0.001)
        if i % 1000 == 0:
            print(f"{i:6d} d {d_loss.item():.3f} g {g_loss.item():.3f}")
            # 同时应记录：批内两两相似度（多样性）、固定种子样本栅格（人眼）
    return G_ema
```

::: method 调试顺序：先怀疑结构，再怀疑超参，最后怀疑代码 {#method-4.4.3}
一个可执行的三段排查：

1. **结构段**：判别器是否有 Sigmoid 与损失形式不匹配？归一化层是否用了 BatchNorm（WGAN-GP 下应换掉）？生成器最后一层是否把输出归到了与真实数据一致的取值范围（如 `Tanh` 对 $[-1,1]$）？
2. **超参段**：把 $D$ 与 $G$ 的学习率比、更新次数比各扫三档；把 $k$ 从 $1$ 改成 $2$ 或 $5$；打开 EMA；把 $D$ 的容量减半再看。**这些实验每次只改一个变量**。
3. **代码段**：只在上面两段都排除后才审代码——最常见的三条是「更新 $G$ 时顺手更新了 $D$」「真实与生成样本的标签写反」「忘了 `.detach()` 导致 $G$ 的梯度回流到 $D$，把判别器也拖着一起动」。
:::

::: errata 本节的四条高频误解
1. **「GAN 训不好就是代码 bug」**：极小极大博弈本身就是鞍点问题，可能震荡或发散。先按 [4.4.5](#sec-4.4.5) 的清单与 [@method-4.4.3] 的顺序排查，再把矛头指向代码。
2. **「WGAN 就是加了个梯度惩罚」**：核心差别在**距离的选择**（$W_1$ vs JS）与 $D$ 的角色（评论家输出实数），梯度惩罚只是施加 Lipschitz 约束的一种手段。只改惩罚不改损失形式，得到的不是 WGAN。
3. **「$D$ 的损失下降说明训练在变好」**：当 $D$ 的损失一路降到接近 0，通常意味着 $G$ 的梯度已经消失。理想的健康状态是 $D$ 损失在一个缓变的区间内抖动。
4. **「用了 hinge 损失 / 谱归一化就不需要调参」**：这些手段扩大的是「可用的工作区间」，不是「免调参」。TTUR 与批量大小仍然显著影响结果（这些是现代图像 GAN 的社区默认经验，不是定理）。
:::

::: method 即时自测 · 4.4
**Q1** 写出 GAN 的极小极大目标，并指出式子里哪一个期望来自真实数据、哪一个来自生成器。

**Q2** 证明最优判别器是 $D^\star=p_{\text{data}}/(p_{\text{data}}+p_g)$（说出逐点最大化的依据即可），并说明它把博弈变成了什么。

**Q3** 用一句话说清「支撑不重叠 → 梯度消失」的机制；WGAN 靠什么绕开这一点？

**Q4** 一个 GAN 的生成批里，64 张图看起来几乎一样，但 $D$ 的损失稳定在 $0.69$ 附近。诊断是什么？给两个可操作的缓解手段。

**Q5** 为什么 WGAN-GP 不建议在判别器里用 BatchNorm？

::: sol 参考要点
**Q1** $\min_G\max_D\ V(D,G)=\mathbb E_{\boldsymbol x\sim p_{\text{data}}}[\log D(\boldsymbol x)]+\mathbb E_{z\sim p_z}[\log(1-D(G(z)))]$。第一项期望对真实数据取（$D$ 想抬高它），第二项期望对噪声 / 生成分布取（$D$ 想压低它、$G$ 想抬高它）。

**Q2** 固定 $G$ 后把 $V$ 写成对 $\boldsymbol x$ 的积分，被积函数在每点只依赖 $D(\boldsymbol x)$，故可逐点最大化：$\frac{a}{D}-\frac{b}{1-D}=0\Rightarrow D^\star=\frac{a}{a+b}$（$a=p_{\text{data}},b=p_g$）。代回得 $V(D^\star,G)=2\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$：于是 $\min_G\max_D V$ 等价于最小化两个分布的 JS 散度，全局最优 $p_g=p_{\text{data}}$。

**Q3** 支撑不重叠时两个分布的混合 $m$ 的支撑被切成互不相交的两块，JSD 恒为 $\log2$，与 $G$ 的参数无关 → 梯度严格为零（对应 [例 4.4.1](#ex-4.4.1) 中 $D$ 把生成样本判到 $1-\varepsilon$ 时梯度量级约为 $\varepsilon$）。WGAN 改用 $W_1$：它借 Kantorovich–Rubinstein 对偶写成「1-Lipschitz 函数上的期望差」，即使支撑不重叠，搬动距离仍随「两个分布的距离」连续变化，因此给出非零且方向正确的梯度；Lipschitz 约束用权重裁剪 / 梯度惩罚 / 谱归一化实现。

**Q4** 诊断：**模式坍塌**。$D$ 损失约 $0.69\approx\log2$ 恰是「$D$ 输出恒为 $0.5$」时二分类交叉熵的值，说明 $G$ 只覆盖了能让当前 $D$ 无法分辨的少数模态，二者已达局部平衡。缓解：① 用 mini-batch 级多样性信号（历史缓冲 / mini-batch discrimination / 批内多样性惩罚）让 $D$ 能看见并惩罚坍塌；② 降低 $D$ 的更新频率或容量、打开 EMA、换 WGAN-GP；③ 提高噪声维度并检查「$z\to$ 输出」是否近常数（确认诊断）。

**Q5** 梯度惩罚是对**每个样本**的 $\nabla_{\hat{\boldsymbol x}}f$ 施加约束，而 BatchNorm 使用批内统计，让一个样本的输出依赖同批其他样本——批内样本互相耦合，使逐样本梯度范数不再是该点局部性质的度量，惩罚的含义被破坏。因此 WGAN-GP 通常改用 LayerNorm 或干脆不加归一化层（改用谱归一化）。
:::

::: note[skip] 延伸阅读
- Goodfellow et al., *Generative Adversarial Nets*（2014，arXiv:1406.2661）——原始论文；其第 4 节给出定理 4.4.1 的完整推导与「最优 $D$」的两种论证。
- Arjovsky & Bottou, *Towards Principled Methods for Training Generative Adversarial Networks*（2017，arXiv:1701.04862）——把「支撑不重叠 → JS 梯度为零」讲得最清楚的一篇，是理解 GAN 病根的关键文献。
- Arjovsky, Chintala & Bottou, *Wasserstein GAN*（2017，arXiv:1701.07875）——WGAN 原始论文（含 Kantorovich–Rubinstein 对偶的引用与权重裁剪方案）。
- Gulrajani et al., *Improved Training of Wasserstein GANs*（2017，arXiv:1704.00028）——WGAN-GP 论文，梯度惩罚的具体形式与「不用 BatchNorm」的建议来源。
- Miyato et al., *Spectral Normalization for Generative Adversarial Networks*（2018，arXiv:1802.05957）——谱归一化的原始论文。
- Radford, Metz & Chintala, *Unsupervised Representation Learning with Deep Convolutional Generative Adversarial Networks*（2015，arXiv:1511.06434）——DCGAN，本节代码骨架所依据的经典结构（含「生成器用转置卷积、判别器不用池化」等实践约定）。
- Karras et al., *Training Generative Adversarial Networks with Limited Data*（2020，arXiv:2006.06676）——ADA（自适应判别器增广），数据量小的时候最实用的一条改进。
:::
:::

**本节小结**：GAN 用「生成器 vs 判别器」的极小极大博弈替代显式似然：$D$ 要最大化 $V$、$G$ 要最小化 $V$。固定 $G$ 时最优判别器为 $D^\star=p_{\text{data}}/(p_{\text{data}}+p_g)$，代回后博弈等价于最小化 $2\,\mathrm{JSD}(p_{\text{data}}\|p_g)-\log4$（[定理 4.4.1](#thm-4.4.1)）——这个漂亮的翻译同时暴露了病根：支撑不重叠时 JSD 是常数、梯度为零（[命题 4.4.1](#prop-4.4.1)、[例 4.4.1](#ex-4.4.1)）。工程对策分三层：**换损失**（非饱和 / hinge / WGAN）、**压住判别器**（梯度惩罚 / 谱归一化）、**稳住生成器**（TTUR、EMA、多样性保护）。模式坍塌是博弈结构问题而非调参疏漏，只能用多样性指标持续监控。

GAN 的训练困难换来的是「一次前向出样本 + 锐利」。下一节换一条完全不同的路线：**放弃博弈，用一个有明确答案的回归任务替代它**——把生成拆成几百上千步「去一点噪声」。它会同时拿到稳定与高质量，代价只剩采样步数。
