# 1.6 优化器：从 SGD 到 AdamW

[1.5 节](sec15.md)解决了「梯度怎么算」。剩下的问题是：**拿到梯度之后怎么走**。同一个梯度，用不同的更新规则会得到完全不同的训练轨迹——收敛速度差几倍、最终损失差一截、甚至一个能训一个发散。

这个问题的重要性常被低估，因为它看起来只是个「选超参」的事。但把优化器拆开看，它其实在回答三个独立的问题：**方向**（要不要用梯度的历史平滑噪声？）、**步长**（所有参数用同一个步长，还是每个参数各自一个？）、**约束**（权重衰减该不该和自适应缩放混在一起？）。SGD、Momentum、AdaGrad、RMSProp、Adam、AdamW 恰好对应着对这些问题的不同回答，而它们之间的差别常被一句「Adam 收敛快」掩盖掉。

这一节按演化顺序把它们讲清楚，重点放在三个容易被跳过的地方：Adam 的**偏差修正**为什么要那样写；**AdamW 与 L2 正则的区别**为什么在数学上不是等价的；以及**学习率调度**为什么在自适应方法里成了必需品而不是可选项。

## 1.6.1 从 SGD 的两个毛病说起

SGD 的更新 $\theta\leftarrow\theta-\eta\widehat{\boldsymbol g}$ 有两个已知毛病。

**毛病一：方向噪声大、跨方向不一致。** 在损失曲面上，不同方向的曲率可能相差几个数量级（叫**病态条件（ill-conditioning）**）。SGD 的每一步都被当前小批量的噪声扰动，于是在陡的方向上来回震荡、在平的方向上前进缓慢。**Momentum 族要解决的就是这个：用历史梯度平滑方向。**

**毛病二：所有参数共用一个步长。** 稀疏特征（很少被激活的维度，如自然语言里的低频词嵌入）每一步只收到很少的梯度信号，用全局步长会导致「常出现的特征已经过训、罕见的特征还差得远」。**自适应学习率族要解决的就是这个：给每个参数一个自己的有效步长。**

::: def 定义 1.6.1 · 优化器要解决的问题 {#def-1.6.1}
设参数 $\theta\in\mathbb R^{P}$、梯度 $\boldsymbol g_t=\nabla_\theta\mathcal L_t(\theta_{t-1})$（第 $t$ 步的小批量梯度）。一个**优化器**是如下形式的更新规则：

$$\theta_t=\theta_{t-1}-\eta\cdot\boldsymbol u_t(\boldsymbol g_1,\dots,\boldsymbol g_t;\ \theta_{t-1}),$$

其中 $\boldsymbol u_t$ 是与 $\boldsymbol g_t$ 同形状的**更新方向**。不同优化器的差别全部体现在 $\boldsymbol u_t$ 如何由历史梯度构造，以及是**逐元素缩放**还是**整体缩放**。
:::

::: intuition 三个问题分开看，优化器族谱就清楚了
- **只用当前梯度**：SGD，$\boldsymbol u_t=\boldsymbol g_t$；
- **加上历史方向的平滑**：Momentum / Nesterov，$\boldsymbol u_t$ 是 $\boldsymbol g$ 的指数滑动平均；
- **加上逐元素的步长缩放**：AdaGrad / RMSProp / Adam / AdamW，$\boldsymbol u_t$ 的每个坐标被自己的历史梯度平方根缩放；
- **把正则化从更新式里拿出来**：AdamW 把权重衰减改成更新完之后的独立一步。

读后面每一小节时都问一句「它改了上面哪一项」，就不会把它们记混。
:::

## 1.6.2 Momentum 与 Nesterov {#sec-1.6.2}

::: def 定义 1.6.2 · Momentum 与 Nesterov 加速 {#def-1.6.2}
**Momentum（动量）**（Polyak 重球法）：

$$\boldsymbol v_t=\beta\boldsymbol v_{t-1}+\boldsymbol g_t,\qquad \theta_t=\theta_{t-1}-\eta\boldsymbol v_t,\qquad \beta\in[0,1)\ \text{（常取 }0.9\text{）}.$$

**Nesterov 加速梯度（NAG）**：把梯度取在「按动量前瞻一步」的位置上，

$$\boldsymbol v_t=\beta\boldsymbol v_{t-1}+\nabla_\theta\mathcal L\bigl(\theta_{t-1}-\eta\beta\boldsymbol v_{t-1}\bigr),\qquad \theta_t=\theta_{t-1}-\eta\boldsymbol v_t .$$

（实现中等价的一种写法是先按 $\theta'_{t}=\theta_{t-1}-\eta\beta\boldsymbol v_{t-1}$ 计算前瞻点，再在其上求梯度。）
:::

::: intuition 动量是梯度的低通滤波，前瞻是给滤波器加一点预测
Momentum 把梯度序列做了**指数滑动平均**：一致的方向被反复加强，来回跳的噪声被抵消，所以它同时起到「加速沿谷底前进」和「抑制垂直方向的震荡」两个作用。换个说法：它把**梯度的方向记忆**加进了更新里，等价于在参数空间滚动一个重球。

Nesterov 的改动小但意图明确：动量项已经带着你往前走了，那就在**走到的位置上**看坡度——如果前一步是错的，前瞻点的梯度会及时把你拉住（减小过冲）。实践上它常比朴素 Momentum 收敛更快，但也更容易在噪声大的小批量梯度上表现不稳定，所以现在的默认选择往往是**动量 + 自适应学习率**，而不是纯 NAG。
:::

::: prop 命题 1.6.1 · 动量的有效步长与平滑尺度 {#prop-1.6.1}
设梯度近似恒定为 $\boldsymbol g$，则从 $\boldsymbol v_0=\boldsymbol 0$ 出发，$\boldsymbol v_t=\bigl(1+\beta+\cdots+\beta^{t-1}\bigr)\boldsymbol g\to\dfrac{\boldsymbol g}{1-\beta}$。因此：

- **有效步长放大约 $\dfrac{1}{1-\beta}$ 倍**（$\beta=0.9$ 时约 $10$ 倍）；
- **平滑的时间尺度约为 $\dfrac{1}{1-\beta}$ 步**（$\beta=0.9$ 时约 $10$ 步）。

这两条给出工程判据：**加上动量后，学习率通常要相应调小**，否则等效步长变大 $10$ 倍会直接发散。
:::

::: proof 推导（等比级数）
$\boldsymbol v_t=\beta\boldsymbol v_{t-1}+\boldsymbol g$ 展开得 $\boldsymbol v_t=\boldsymbol g\sum_{k=0}^{t-1}\beta^{k}$。当 $t\to\infty$ 时 $\sum_{k\ge0}\beta^k=\frac{1}{1-\beta}$（$\beta\lt1$），即稳定速度是单步梯度的 $1/(1-\beta)$ 倍。另一方面，把 $\boldsymbol v_t$ 写成梯度序列的加权和：$\boldsymbol v_t=\sum_{k=0}^{t-1}\beta^{k}\boldsymbol g_{t-k}$，权重 $\beta^k$ 衰减到 $1/e$ 所需步数约为 $1/(1-\beta)$，即「记忆窗口」。$\blacksquare$
:::

## 1.6.3 自适应学习率：AdaGrad 与 RMSProp

::: def 定义 1.6.3 · AdaGrad 与 RMSProp {#def-1.6.3}
**AdaGrad**（逐元素操作，$\odot$、$\sqrt{\cdot}$、除法都是逐元素）：

$$\boldsymbol s_t=\boldsymbol s_{t-1}+\boldsymbol g_t\odot\boldsymbol g_t,\qquad \theta_t=\theta_{t-1}-\eta\,\frac{\boldsymbol g_t}{\sqrt{\boldsymbol s_t}+\epsilon}.$$

**RMSProp**：把累积改成指数滑动平均（$\gamma$ 常取 $0.9$ 或 $0.99$），从而不让分母无限增大：

$$\boldsymbol s_t=\gamma\boldsymbol s_{t-1}+(1-\gamma)\,\boldsymbol g_t\odot\boldsymbol g_t,\qquad \theta_t=\theta_{t-1}-\eta\,\frac{\boldsymbol g_t}{\sqrt{\boldsymbol s_t}+\epsilon}.$$

**Adadelta**：进一步连分子也做同样的滑平均，从而**不需要显式学习率**（$\eta$ 被 ${\sqrt{\Delta\theta}}$ 的滑平均替代）。
:::

::: intuition 逐元素除法的含义：把每个坐标的更新「归一化到同一量级」
分子是梯度、分母是该坐标历史梯度的均方根。若某坐标的梯度一直很大（陡方向），分母大、有效步长小；若某坐标梯度一直很小（平方向），分母小、有效步长大。**结果是每个坐标的更新量级都被拉到大致相同的尺度上**——这正是 SGD 的毛病二的解药，也是稀疏特征能被训起来的机制。

AdaGrad 的缺陷也来自这里：分母是**累积的**平方和，永远单调增，所以有效步长单调衰减到零——训练到后面几乎不动。RMSProp 用指数滑动平均替代累积，让分母只反映「最近一段时间的梯度量级」，从而修掉了这个缺陷。
:::

| 优化器 | 一阶平滑 | 二阶统计 | 逐元素步长 | 主要缺陷 |
|:--|:--|:--|:--|:--|
| SGD | 无 | 无 | 无 | 病态曲率下震荡；需精调学习率 |
| Momentum / NAG | 有（$\beta$） | 无 | 无 | 有效步长放大 $1/(1-\beta)$，需同步调小 $\eta$ |
| AdaGrad | 无 | 累积平方和 | 有 | 有效步长单调衰减到零 |
| RMSProp | 无 | 平方的滑动平均 | 有 | 无动量，噪声大 |
| Adam | 有（$\beta_1$） | 平方的滑动平均（$\beta_2$） | 有 | 权重衰减被自适应缩放（→ AdamW 修正） |
| AdamW | 有 | 有 | 有 | 解耦权重衰减；其余同 Adam |

## 1.6.4 Adam：一阶矩、二阶矩与偏差修正 {#sec-1.6.4}

::: def 定义 1.6.4 · Adam {#def-1.6.4}
**Adam（adaptive moment estimation）**同时估计梯度的一阶矩（均值）与二阶矩（未中心化的方差）：

$$\boldsymbol m_t=\beta_1\boldsymbol m_{t-1}+(1-\beta_1)\boldsymbol g_t,\qquad
\boldsymbol v_t=\beta_2\boldsymbol v_{t-1}+(1-\beta_2)\boldsymbol g_t\odot\boldsymbol g_t,$$

$$\hat{\boldsymbol m}_t=\frac{\boldsymbol m_t}{1-\beta_1^{t}},\qquad
\hat{\boldsymbol v}_t=\frac{\boldsymbol v_t}{1-\beta_2^{t}},\qquad
\theta_t=\theta_{t-1}-\eta\,\frac{\hat{\boldsymbol m}_t}{\sqrt{\hat{\boldsymbol v}_t}+\epsilon}.$$

默认超参：$\beta_1=0.9$、$\beta_2=0.999$、$\epsilon=10^{-8}$。
:::

::: proof 偏差修正的推导
**问题**：为什么 $\boldsymbol m_t$ 需要除以 $1-\beta_1^t$？因为初始化为零时，滑动平均在前若干步被系统性地拉向零。

展开 $\boldsymbol m_t=(1-\beta_1)\sum_{k=1}^{t}\beta_1^{t-k}\boldsymbol g_k$。若假设各步梯度同分布、期望为 $\boldsymbol\mu$（即 $\mathbb E[\boldsymbol g_k]=\boldsymbol\mu$），则

$$\mathbb E[\boldsymbol m_t]=(1-\beta_1)\sum_{k=1}^{t}\beta_1^{t-k}\boldsymbol\mu=\Bigl[(1-\beta_1)\sum_{k=0}^{t-1}\beta_1^{k}\Bigr]\boldsymbol\mu=\bigl(1-\beta_1^{t}\bigr)\boldsymbol\mu .$$

**注意系数是 $(1-\beta_1^t)$ 而不是 $1$**：$t=1$ 时只有 $(1-0.9)=0.1$，$\boldsymbol m_1$ 只有真实均值的 $1/10$。除以 $(1-\beta_1^t)$ 后期望恢复为 $\boldsymbol\mu$，即修正了「初值取零」引入的偏差。对 $\boldsymbol v_t$ 同理（$\beta_2=0.999$ 时偏差更严重：$t=1$ 时只有 $0.001$，$t=1000$ 时才有 $0.63$）。

**为什么必须修正**：若不做修正，$\boldsymbol m_t$ 偏小而 $\boldsymbol v_t$ 偏小得更厉害，两者相除的有效步长在训练初期会被严重扭曲（通常表现为前几百步异常巨大）。修正后，两个统计量的尺度在早期就正确，训练从头到尾稳定。$\blacksquare$
:::

::: intuition 两个视角看 Adam 的更新量级
**视角一（逐元素归一化）**：忽略 $\epsilon$、假设梯度近似恒定，则 $\hat m_t/\sqrt{\hat v_t}\approx g/\sqrt{g^2}=\operatorname{sign}(g)$。**因此 Adam 每一步在参数空间的移动幅度大约是 $\eta$（逐坐标）**，几乎与梯度大小无关。这解释了它的两个特征：一是**梯度爆炸时它仍然安全**（更新量被压到 $\eta$ 量级）；二是**梯度消失时它反而会放大**（分子被分母同比例缩小后仍在同一量级），所以 Adam 对学习率的敏感性远低于 SGD。

**视角二（信噪比）**：$\hat m_t$ 是梯度的均值估计，$\sqrt{\hat v_t}$ 是它的 RMS。二者之比是**归一化的信噪比**：梯度方向一致时比值接近 $1$（大步走），梯度来回抖动时比值接近 $0$（几乎不动）。于是 Adam 自动在「信心足」的方向上走大、在「犹豫」的方向上走小。
:::

::: errata 关于 Adam 的三个常见误解
1. **「Adam 不需要调学习率」**：它只是对学习率**不敏感**，不是不敏感于任何取值。典型可用区间是 $10^{-4}$ 到 $3\times10^{-3}$（配合 $3\times10^{-4}$ 起步的惯例），超出这个范围仍会发散或不收敛。并且由于更新量被归一化到 $\eta$ 量级，**Adam 的学习率实际上是一个「每步位移尺度」**，与 SGD 的 $\eta$ 含义不同，不能互相照搬。
2. **「Adam 的 $\epsilon$ 无关紧要」**：$\epsilon$ 决定了分母的最小值，从而决定了「梯度极小时更新量还能不能到 $\eta$ 量级」。混合精度 / 低精度训练中 $\epsilon$ 需要放大（如 $10^{-6}$ 或 $10^{-4}$ 量级），否则 $\sqrt{\hat v_t}$ 在数值上可能被下溢成零。
3. **「$\beta_2=0.999$ 总是最好的」**：$\beta_2$ 对应二阶统计的记忆窗口约 $1000$ 步。在小批量很小、任务变化快或序列任务中，常见做法是减小到 $0.98$ 或 $0.99$；大规模语言模型训练中也有显式调 $\beta_2$ 的报告。**这是超参，不是常数**。
:::

## 1.6.5 AdamW：为什么正则项不该进自适应缩放 {#sec-1.6.5}

这一小节是本节最实用的部分，也是最常被误解的一处。

**先看传统 L2 正则下的梯度下降。** 在损失里加 L2 惩罚 $\frac{\lambda}{2}\lVert\theta\rVert^2$，梯度变成 $\boldsymbol g+\lambda\theta$，于是 SGD 更新为

$$\theta_t=\theta_{t-1}-\eta\boldsymbol g_t-\eta\lambda\theta_{t-1}=(1-\eta\lambda)\theta_{t-1}-\eta\boldsymbol g_t .$$

**L2 正则项在 SGD 里表现为「每步把参数乘上 $(1-\eta\lambda)$」**，这就是它被叫做**权重衰减（weight decay）**的原因——两者在 SGD 下**严格等价**。

::: thm 定理 1.6.1 · Adam（自适应缩放）下 L2 与权重衰减不等价 {#thm-1.6.1}
设 $\lambda\gt0$。在自适应优化器中，若把 L2 惩罚加进损失（等价于用 $\boldsymbol g_t+\lambda\theta_{t-1}$ 作为 Adam 的输入梯度），则正则化对参数的**实际作用被逐元素除以了 $\sqrt{\hat v_t}+\epsilon$**：

$$\text{L2-in-Adam 的衰减效果}=\eta\,\frac{\lambda\theta}{\sqrt{\hat v_t}+\epsilon}\quad\text{（逐元素）},$$

它对**不同坐标施加不同强度的衰减**：梯度历史大的坐标衰减少，梯度历史小的坐标衰减多。而**解耦权重衰减（decoupled weight decay, AdamW）**把衰减写成独立一步：

$$\theta_t=\theta_{t-1}-\eta_{t}\,\frac{\hat{\boldsymbol m}_t}{\sqrt{\hat{\boldsymbol v}_t}+\epsilon}-\eta_{t}\,\lambda\,\theta_{t-1},$$

它对所有坐标施加**同一个**相对衰减 $\eta_t\lambda$，与梯度统计无关。
:::

::: intuition 两种做法的区别到底在哪
一句话：**L2 是「在损失里加约束」，AdamW 是「在更新后按比例缩回」**。前者在 SGD 下恰好等价于后者，但 Adam 的逐元素缩放把这个等价性打破了——它连正则化项一起正常化了，于是「该被强烈压制的方向」可能因为梯度大而获得较弱的衰减，而「几乎不动的大权重」（低梯度但绝对值大，最该被收缩）反而衰减得很好或很差，完全取决于梯度历史。**参数范数的约束因此变得不受控**。

公开研究给出的实验观察是：在同样的调参预算下，AdamW 通常比 Adam + L2 获得更好的泛化，且对 $\lambda$ 更稳健。**本书采用的是「AdamW 是默认选择」这一社区惯例**；如果你在为某个特定任务选型，应把两种做法都跑一遍对照。
:::

::: errata 关于权重衰减的四条实践说明
1. **不要对偏置与归一化层参数施加权重衰减**。这些参数只有一个或几个自由度（每通道），衰减它们通常有害；主流实现的做法是把参数分成两组（带衰减 / 不带衰减）。PyTorch 的优化器支持按参数组设置 `weight_decay`。
2. **`torch.optim.Adam(weight_decay=...)` 是 Adam + L2，不是 AdamW**。要真正的解耦权重衰减请用 `torch.optim.AdamW`。这是一个**只看代码就能避免**的低级错误，但非常常见。
3. **$\lambda$ 的取值范围与优化器、批大小、训练轮数有关**：常见量级是 $0.01\sim0.1$（大模型预训练中 $0.1$ 常见，微调任务常用更小值）。**不要跨配置照搬**。
4. **权重衰减不是「越大越正则」**：过大的 $\lambda$ 会让有效容量不足，训练损失都降不下去，表现为欠拟合（[1.7.2](sec17.md)）。
:::

::: ex 例 1.6.1 · 手算三步 Adam 的偏差修正 {#ex-1.6.1}
设某个单参数问题，梯度序列为 $g_1=1.0$、$g_2=0.5$、$g_3=0.5$，$\beta_1=0.9$、$\beta_2=0.999$、$\epsilon=0$。

(1) 逐位算出 $\boldsymbol m_t$、$\hat m_t$、$\boldsymbol v_t$、$\hat v_t$ 与 $\eta=0.01$ 时的参数更新量；(2) 若不修正偏差，第一步的更新量是多少？比值是多少？(3) 解释这个比值为什么在第 1 步异常大。

::: proof 解
**(1) 逐步计算。** $\beta_1=0.9$：$m_t=0.9m_{t-1}+0.1g_t$；$\beta_2=0.999$：$v_t=0.999v_{t-1}+0.001g_t^2$。

| $t$ | $g_t$ | $m_t$ | $\hat m_t=m_t/(1-0.9^t)$ | $v_t$ | $\hat v_t=v_t/(1-0.999^t)$ | $\hat m_t/\sqrt{\hat v_t}$ |
|:--|:--|:--|:--|:--|:--|:--|
| 1 | $1.0$ | $0.1000$ | $0.1/0.1=1.000$ | $0.001000$ | $0.001/0.001=1.000$ | $1.000$ |
| 2 | $0.5$ | $0.1400$ | $0.14/(1-0.81)=0.7368$ | $0.001250$ | $0.00125/(1-0.998001)=0.6254$ | $0.9317$ |
| 3 | $0.5$ | $0.1760$ | $0.176/(1-0.729)=0.6494$ | $0.001249$ | $0.001249/(1-0.997002)=0.4170$ | $1.0054$ |

参数更新量（$\eta=0.01$）为 $\eta\hat m_t/\sqrt{\hat v_t}$：第 1 步 $0.0100$，第 2 步 $0.0093$，第 3 步 $0.0101$。注意三者都在 $0.01$ 附近——这正是 [1.6.4](#sec-1.6.4)「视角一」说的**更新量级约等于 $\eta$**。

**(2) 不修正时。** $m_1=0.1$，$v_1=0.001$，$\sqrt{v_1}=0.03162$，所以 $m_1/\sqrt{v_1}=3.162$，更新量为 $0.0316$。修正后是 $0.0100$，**比值恰为 $3.162\approx\sqrt{10}$**。

**(3) 为什么第 1 步偏差最大。** $m_1=(1-\beta_1)g_1$ 只保留了 $10\%$，而 $v_1=(1-\beta_2)g_1^2$ 只保留了 $0.1\%$；两者相除时，偏差的**开方**进入比值：$\sqrt{(1-\beta_1)^2/(1-\beta_2)}=\sqrt{0.01/0.001}=\sqrt{10}\approx3.16$。一般地，第 $t$ 步的偏差因子为 $\dfrac{1-\beta_1^t}{\sqrt{1-\beta_2^t}}$，在 $\beta_2\gg\beta_1$ 时它趋向 $1-\beta_1^t$（小于 1 表示未修正时步长偏大）。$\blacksquare$
:::
:::

## 1.6.6 学习率调度、梯度裁剪与梯度累积

**学习率调度（learning rate schedule）。** $\eta$ 是单一影响最大的超参，而**固定 $\eta$ 几乎从不是最优**。四类常见方案：

| 调度 | 形式 | 适用 / 动机 | 注意 |
|:--|:--|:--|:--|
| **Warmup** | 前 $T_w$ 步 $\eta_t=\eta_{\max}\cdot t/T_w$（线性） | 自适应优化器早期统计量不可靠；大模型训练几乎必用 | 太短的 warmup 会抹掉它要解决的早期不稳定 |
| **阶梯衰减** | 在里程碑处乘 $0.1$ 或 $0.5$ | 经典 CNN 训练；简单可控 | 需要预先定里程碑，对总步数敏感 |
| **余弦退火** | $\eta_t=\eta_{\min}+\frac12(\eta_{\max}-\eta_{\min})\bigl(1+\cos(\pi t/T)\bigr)$ | 平滑衰减到接近零；**当前最常用的默认** | 需要把总步数 $T$ 定下来 |
| **一周期（one-cycle）** | 先线性升到峰值、再余弦降到接近零 | 在固定计算预算下压缩训练时间 | 峰值较大，需与批大小配合 |

::: intuition 为什么「先小后大再小」
三个阶段各有明确理由。**Warmup（先小）**：Adam 的二阶统计量在最初几十步还没建立，$\hat v_t$ 的估计很差，此时用大学习率容易把参数打进坏区域（或因 $\epsilon$ 过小引发数值问题）；warmup 相当于给统计量「采样时间」。**平台期（大）**：进入稳定区域后尽快走完主要下坡。**退火（小）**：接近收敛时减小步长，让参数落入更平坦的极小值——这一步对最终泛化有明显影响，也是「余弦到零」比「余弦到某个正数」更常见的原因。
:::

**梯度裁剪（gradient clipping）。** 把梯度的整体范数限制在一个阈值内：

$$\boldsymbol g\leftarrow\boldsymbol g\cdot\min\Bigl(1,\ \frac{c}{\lVert\boldsymbol g\rVert_2}\Bigr),\qquad \text{PyTorch: } \texttt{clip\_grad\_norm\_(model.parameters(), c)}.$$

它的作用是**限制单步的最大位移**，主要防护三类情况：序列模型里的长程梯度尖峰、混合精度训练中的溢出前兆、以及数据里的异常样本。判据：训练时打印**裁剪前的梯度范数**，若经常超过阈值，说明阈值过小或学习率过大；若从不触发，可以去掉以节省一次全参数归约的开销。

**梯度累积（gradient accumulation）。** 显存放不下想要的批大小时，把若干个小批次的梯度累加后再更新一次：

$$\text{每 }k\text{ 个小批更新一次},\qquad \text{等效批大小}=k\times B_{\text{micro}}.$$

两个必须注意的细节：① 若损失已按 micro-batch 求均值，累积 $k$ 次后的梯度等于 $k$ 个批梯度的和，**要除以 $k$** 才与「一次大批」等价；② 若模型里有 BatchNorm，累积与真批等效**不成立**，因为 BN 的统计量是在 micro-batch 上算的（[1.7.4](sec17.md)）——这是分布式训练里常见的隐性精度损失来源。

## 1.6.7 大批量训练、LARS 与 LAMB {#sec-1.6.7}

为什么大公司要费劲做大批量训练？因为多卡数据并行的每一步同步的必要通信量决定了扩展效率：**批大小越大，通信开销相对计算越少**。但大批量会带来两个问题：泛化变差（早停的噪声正则减少），以及学习率不再合适。

::: thm 定理 1.6.2 · 线性缩放规则（linear scaling rule） {#thm-1.6.2}
设小批量大小为 $B$、学习率为 $\eta$。把批大小乘 $k$ 倍（$B'=kB$）时，**在批内梯度噪声相对稳定、且步数足够多**的前提下，把学习率同比放大 $k$ 倍（$\eta'=k\eta$）可以得到与原设置近似相同的训练轨迹。这就是**线性缩放规则**。
:::

::: proof 推导思路（为什么是「线性」）
设单样本梯度为 $\boldsymbol g_i$，小批量梯度 $\widehat{\boldsymbol g}=\frac1B\sum_{i\in\mathcal B}\boldsymbol g_i=\nabla\mathcal L+\boldsymbol\xi$，其中噪声项 $\boldsymbol\xi$ 的协方差约为 $O(\sigma^2/B)$（样本独立时），故噪声标准差 $\propto 1/\sqrt{B}$。

把步长与批大小的乘积 $\eta B$ 看作控制量：一步 $B$ 倍大批的更新 $\eta'\widehat{\boldsymbol g}_{B'}$ 与 $k$ 步小批更新之和 $\sum_{j=1}^{k}\eta\widehat{\boldsymbol g}_{B}^{(j)}$ 的前两项（均值项与噪声项）在 $\eta'=k\eta$ 时匹配。这解释了线性的来源；但该近似要求：步长本身小到可忽略二阶项、批内噪声近似高斯、以及训练步数足够多。**当 $k$ 太大（如从 256 到 32768）时近似失效**，此时用**平方根缩放**（$\eta'\propto\sqrt{k}$）往往更稳健，或改用下面的逐层自适应方法。$\blacksquare$
:::

**LARS 与 LAMB：逐层的自适应缩放。** 线性缩放规则对**所有层**用同一个倍数，但深层网络各层的参数范数与梯度范数相差很大（嵌入层与输出层的尺度可能差一个数量级）。这类方法的做法是**逐层**计算一个信任比：

$$\text{层 }l\text{ 的局部学习率}\ \eta_l=\eta\cdot\frac{\lVert\theta^{(l)}\rVert_2}{\lVert\boldsymbol g^{(l)}\rVert_2}\ \text{（形式示意，具体实现含权重衰减项与截断，需核对原文献）},$$

即「相对更新幅度 $=$ 全局学习率」：参数范数大的层走相对小的一步、梯度大的层被压住。**LARS** 用于 ResNet 类视觉模型的大批训练；**LAMB** 把同样的思路用到 Transformer / BERT 的预训练上，使批大小可以放大到数万而保持精度。**具体公式、超参与可复现范围应以原论文与开源实现为准（需核实）。**

::: method 优化器选择的决策清单 {#method-1.6.1}
按顺序问，答完即可选：

1. **训练预算与稳定性哪个优先？** 预算紧、想省调参 → **AdamW**（$\eta=3\times10^{-4}$ 起步，$\lambda=0.01\sim0.1$，配 warmup + 余弦）。要极致泛化且有调参人力 → **SGD + Momentum**（$\eta$ 用 lr finder 估计，$\beta=0.9$，配阶梯或余弦）。
2. **有没有大量稀疏特征 / 变长序列？** 有 → 自适应方法优势明显（稀疏维度需要各自步长）。纯稠密小任务 → Momentum 也能做得很好。
3. **批大小是否被迫很大（多卡）？** 是 → 先启用线性缩放规则；若精度下降，考虑平方根缩放、warmup 加长，或逐层自适应方法（[1.6.7](#sec-1.6.7)）。
4. **是否用混合精度？** 是 → 提高 $\epsilon$、开梯度裁剪，并确认权重衰减用的是 `AdamW` 而不是 `Adam(weight_decay=...)`。
5. **改完设置后至少看三条曲线**：训练损失（是否下降）、裁剪前梯度范数（是否频繁触顶）、以及验证损失（是否与训练同步）。
:::

## 1.6.8 代码：优化器对照实验

```python
import torch, torch.nn as nn, torch.optim as optim

torch.manual_seed(0)
# 一个刻意做成“病态”的二次问题：两个方向曲率相差 20 倍，用来放大优化器差异
A = torch.diag(torch.tensor([1.0, 20.0]))
b = torch.tensor([1.0, 1.0])

def run(opt_name, steps=200, lr=0.05):
    theta = torch.zeros(2, requires_grad=True)
    # ① 三种优化器：SGD / SGD+Momentum / AdamW —— 对照 1.6.2 与 1.6.4
    if opt_name == "sgd":
        opt = optim.SGD([theta], lr=lr)
    elif opt_name == "momentum":        # 注意：加了动量后有效步长放大 1/(1-β) ≈ 10 倍
        opt = optim.SGD([theta], lr=lr, momentum=0.9)
    elif opt_name == "nesterov":        # NAG：梯度取在“前瞻点”上
        opt = optim.SGD([theta], lr=lr, momentum=0.9, nesterov=True)
    elif opt_name == "adamw":           # 解耦权重衰减（见 1.6.5）：λ 独立一步，不进自适应缩放
        opt = optim.AdamW([theta], lr=lr, betas=(0.9, 0.999), weight_decay=0.01)
    losses = []
    for _ in range(steps):
        loss = 0.5 * theta @ A @ theta - b @ theta      # 目标：∇ = Aθ − b
        opt.zero_grad(); loss.backward(); opt.step()
        losses.append(loss.item())
    return losses

for name in ["sgd", "momentum", "nesterov", "adamw"]:
    L = run(name)
    print(f"{name:9s} L0={L[0]:8.4f}  L50={L[50]:8.4f}  L199={L[-1]:.6f}")

# ② Adam vs AdamW：同样的 λ，观察参数范数被约束的方式是否不同
def train_with(kind, lam=0.05, steps=300):
    torch.manual_seed(1)
    model = nn.Sequential(nn.Linear(32, 64), nn.ReLU(), nn.Linear(64, 1))
    x = torch.randn(256, 32); y = (x.sum(1, keepdim=True) > 0).float()
    if kind == "adam_l2":       # ⚠ 这是 Adam + L2：正则项会被 √v 逐元素缩放，与 AdamW 不同
        opt = optim.Adam(model.parameters(), lr=1e-2, weight_decay=lam)
    else:                       # AdamW：解耦权重衰减
        opt = optim.AdamW(model.parameters(), lr=1e-2, weight_decay=lam)
    for _ in range(steps):
        loss = nn.functional.mse_loss(model(x), y)
        opt.zero_grad(); loss.backward(); opt.step()
    # 统计带衰减参数的 L2 范数：AdamW 的约束对所有坐标一致，Adam+L2 则被梯度历史扭曲
    return sum(p.pow(2).sum().item() for p in model.parameters()) ** 0.5

print("||θ||  adam+l2 =", round(train_with("adam_l2"), 3))
print("||θ||  adamw   =", round(train_with("adamw"), 3))

# ③ 梯度裁剪 + 梯度累积 + warmup：三段式训练循环的骨架
model = nn.Sequential(nn.Linear(32, 64), nn.ReLU(), nn.Linear(64, 1))
opt = optim.AdamW(model.parameters(), lr=3e-4, weight_decay=0.01)
total_steps, warmup, accum = 1000, 50, 4
# 调度 = 线性 warmup × 余弦衰减（两项相乘）。写成 lr_lambda 是为了把纯 PyTorch 的实现写全。
def lr_factor(s):
    warm = min(1.0, (s + 1) / warmup)                       # 前 50 步线性升温
    cos = 0.5 * (1 + torch.cos(torch.tensor(min(s, total_steps) / total_steps * 3.14159)).item())
    return warm * cos                                        # 峰值之后余弦退到接近 0
sched = optim.lr_scheduler.LambdaLR(opt, lr_lambda=lr_factor)
for step in range(total_steps):
    for micro in range(accum):                 # 累积 accum 个小批，等效批大小 × accum
        xb, yb = torch.randn(16, 32), torch.randn(16, 1)
        loss = nn.functional.mse_loss(model(xb), yb) / accum   # 除以 accum，让累积后的梯度与大批一致
        loss.backward()
    total_norm = torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)  # 裁剪前范数可用来监控
    opt.step(); sched.step(); opt.zero_grad()   # 顺序：step → 调度 → 清梯度（清梯度不能忘）
    if step % 200 == 0:
        print(f"step {step:4d} lr {sched.get_last_lr()[0]:.2e} grad_norm(before clip) {total_norm:.3f}")
```

## 1.6.9 陷阱与勘误

::: errata 本节八个高频错误
1. **`Adam(weight_decay=λ)` 当成了 AdamW**：这是 Adam + L2，正则项会被 $\sqrt{\hat v_t}$ 缩放（[定理 1.6.1](#sec-1.6.5)）。要解耦权重衰减必须用 `AdamW`。
2. **加了动量却忘了把学习率调小**：有效步长放大约 $1/(1-\beta)=10$ 倍（[命题 1.6.1](#sec-1.6.2)），直接发散。
3. **忘了 `zero_grad()`**：梯度跨步累加，等效学习率随步数增大；症状是「训练几百步后突然爆掉」。
4. **忘记 `opt.step()` 与 `zero_grad()` 的顺序**：正确顺序是「反向 → （可选）裁剪 → `step()` → `zero_grad()`」。在 `zero_grad()` 之后再 `step()` 会用到空梯度（无害但是无效的一步）。
5. **梯度累积时不做缩放**：累积 $k$ 次却不除以 $k$，等效学习率变成 $k$ 倍。
6. **对偏置与归一化层也施加权重衰减**（[1.6.5](#sec-1.6.5)的实践说明 1）。
7. **模型里含 BatchNorm 却指望梯度累积等同于大批**：BN 的批统计量在 micro-batch 上计算，二者不等价；需要改用同步 BN 或 LayerNorm 类归一化。
8. **只盯着优化器换，不动学习率与调度**：优化器的收益常常小于「把学习率与 warmup 调对」。工程顺序应是「先把学习率与调度搞对，再考虑换优化器」。
:::

::: method 即时自测 · 1.6
**Q1** 写出版本中 Adam 的四个式子（含偏差修正），并说明「更新量级约等于 $\eta$」是怎么得到的。

**Q2** 用一句话说出 Adam + L2 与 AdamW 的区别，并说明这个区别为什么在 SGD 下不存在。

**Q3** 动量为什么让有效步长放大 $1/(1-\beta)$ 倍？$\beta=0.99$ 时该倍数是多少，会带来什么工程后果？

**Q4** 把批大小从 256 放大到 4096，按线性缩放规则学习率应如何调整？在什么情况下这个规则会失效，替代方案是什么？

::: sol 参考要点
**Q1** $m_t=\beta_1m_{t-1}+(1-\beta_1)g_t$；$v_t=\beta_2v_{t-1}+(1-\beta_2)g_t^2$；$\hat m_t=m_t/(1-\beta_1^t)$，$\hat v_t=v_t/(1-\beta_2^t)$；$\theta_t=\theta_{t-1}-\eta\hat m_t/(\sqrt{\hat v_t}+\epsilon)$。量级：梯度近似恒定 $g$ 时，$\hat m_t\approx g$、$\sqrt{\hat v_t}\approx|g|$，比值 $\approx\operatorname{sign}(g)$，故每步位移约 $\pm\eta$（逐坐标），与梯度大小基本无关。

**Q2** Adam + L2 把正则项加进梯度，于是该项也被逐元素除以 $\sqrt{\hat v_t}+\epsilon$——梯度历史大的坐标衰减弱、小的衰减强，衰减强度与梯度统计相关；AdamW 把衰减写成更新后的独立一步 $-\eta\lambda\theta$，对全部坐标施加同一相对衰减。对 SGD，因为没有逐元素缩放（更新就是 $-\eta g$），两种写法都化简为 $\theta\leftarrow(1-\eta\lambda)\theta-\eta g$，**严格等价**，所以区别只在自适应方法里显现。

**Q3** 恒定梯度下动量速度收敛到 $g/(1-\beta)$，即单步梯度的 $1/(1-\beta)$ 倍；这就是有效步长的放大倍数（推导为等比级数求和）。$\beta=0.99$ 时为 $100$ 倍——后果是学习率必须比无动量时小两个数量级左右，否则直接发散；同时记忆窗口约 100 步，参数更新对噪声极度平滑，对小批量 / 数据分布快速变化的任务可能反应迟钝。

**Q4** 按线性缩放规则 $\eta'=\eta\times(4096/256)=16\eta$，并通常同步加长 warmup。失效情形：① 放大倍数过大（批大到噪声近似不再成立）；② 各层参数 / 梯度尺度差异悬殊（深层网络）；③ 训练步数太少（近似推导需要足够步数）。替代方案：**平方根缩放**（$\eta'\propto\sqrt{k}$）、**加长 warmup**、或使用**逐层自适应**方法（LARS / LAMB，[1.6.7](#sec-1.6.7)）。
:::
:::

::: note[skip] 延伸阅读
- Polyak, *Some Methods in the Solution of Optimization Problems with Accelerated Convergence*（1964）——重球法（动量）的原始来源。
- Nesterov, *A Method of Solving a Convex Programming Problem with Convergence Rate $O(1/k^2)$*（1983）——加速梯度法。
- Duchi, Hazan & Singer, *Adaptive Subgradient Methods for Online Learning and Stochastic Optimization*（2011，JMLR）——AdaGrad。
- Tieleman & Hinton, *Lecture 6.5 — RMSProp*（2012，Coursera 讲义）——RMSProp（无正式论文，引用形式为课程讲义）。
- Kingma & Ba, *Adam: A Method for Stochastic Optimization*（2015，ICLR；arXiv:1412.6980）——Adam 与偏差修正。
- Loshchilov & Hutter, *Decoupled Weight Decay Regularization*（2019，ICLR；arXiv:1711.05101）——AdamW 与 L2 不等价的论证与实验。
- Goyal et al., *Accurate, Large Minibatch SGD: Training ImageNet in 1 Hour*（2017，arXiv:1706.02677）——线性缩放规则与 warmup。
- You, Gitman & Ginsburg, *Large Batch Optimization for Deep Learning: Training BERT in 76 Minutes*（2020，ICLR；arXiv:1904.00962）——LAMB 与逐层自适应（公式与超参需按原文核实）。
:::

**本节小结**：优化器的演化可以拆成三个独立问题的回答——**方向**（Momentum 用 $1/(1-\beta)$ 的有效步长换取噪声抑制与病态曲率下的加速）、**逐参数步长**（AdaGrad 累积平方和会衰减到零，RMSProp 用滑动平均修正，Adam 在动量与二阶矩上同时做并且需要偏差修正，其更新量级约等于 $\eta$）、**约束的形式**（L2 在 SGD 下等价于权重衰减，但在自适应缩放下被扭曲，AdamW 用解耦的一步修正它）。学习率仍是单一影响最大的超参，调度（warmup + 余弦）不是装饰；梯度裁剪与累积分别处理稳定性与显存约束，但累积与 BatchNorm 不兼容。大批量训练用线性缩放规则起步，失败时退回到平方根缩放或逐层自适应方法。下一节离开「训练误差」，进入这套范式真正的边界：**为什么训练集上做得很好，测试集上却不行。**
