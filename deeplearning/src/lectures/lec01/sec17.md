# 1.7 泛化、正则化与归一化

前面六节全部在解决同一个问题：**怎样把训练集上的损失降下去**。这一节要问一个更根本的问题：**训练集上的好成绩能不能带到没见过的数据上**。这才是深度学习的实际目标——部署时模型见到的永远是没见过的样本。

这个问题有两种截然不同的失败形态：训练误差和测试误差**都高**（模型根本没学到规律，叫欠拟合），以及训练误差很低而测试误差高（模型记住了训练集，叫过拟合）。两者的处置方向完全相反——欠拟合要**增加能力**，过拟合要**限制能力**——所以先分清症状比急着加正则重要得多。

这一节的结构是：先给出诊断框架（偏置-方差与训练/验证曲线），再给出一张正则化手段的清单（每一条说明它改的是什么）；然后处理一个近年才成为默认组件的东西——**归一化层**，它既改善优化又影响泛化；最后交代经典图景的两个边界：**双下降现象**说明「能力越大越容易过拟合」不是普适规律，而**数据泄漏**说明很多「泛化异常」其实是评估方法本身错了。

## 1.7.1 过拟合与欠拟合的诊断 {#sec-1.7.1}

::: def 定义 1.7.1 · 泛化误差与经验误差 {#def-1.7.1}
设数据来自分布 $\mathcal D$，训练集为 $S\sim\mathcal D^N$。**经验误差（训练误差）**与**泛化误差（测试误差）**分别为

$$\hat R_S(\theta)=\frac1N\sum_{i=1}^{N}\mathcal L\bigl(f(\boldsymbol x_i;\theta),y_i\bigr),\qquad R(\theta)=\mathbb E_{(\boldsymbol x,y)\sim\mathcal D}\bigl[\mathcal L\bigl(f(\boldsymbol x;\theta),y\bigr)\bigr],$$

**泛化间隙（generalization gap）**定义为 $R(\theta)-\hat R_S(\theta)$。在实际工程中 $R$ 用**验证集**或**测试集**上的经验误差估计：验证集用于做决策（选模型、调超参、早停），测试集用于最终报告，且**只应被使用一次**。
:::

| 现象 | 训练误差 | 验证误差 | 诊断 | 处置方向 |
|:--|:--|:--|:--|:--|
| **欠拟合** | 高 | 高（且两者贴近） | 模型容量不足 / 训练不足 / 正则过强 | 加宽加深、训练更久、**减**正则、改进特征与优化（学习率、归一化） |
| **过拟合** | 低 | 高（间隙大且扩大） | 容量相对数据过大 / 正则不足 / 数据泄漏 | 加正则（Dropout、权重衰减、标签平滑）、数据增强、早停、减小模型、清洗数据 |
| **训练不稳定** | 震荡 | 震荡 | 学习率过大 / 批过小 / 数值问题 | 降学习率、加 warmup、梯度裁剪、检查数据 |
| **两边都极好但线上差** | 低 | 低 | 分布漂移 / 划分不随机 / 泄漏 | 重做划分、检查时间顺序、做分布对比 |

::: intuition 为什么「训练与验证都看」还不够，还要看**曲线形状**
单看某个时刻的两个数字只能区分「欠拟合 / 过拟合」，看不出趋势。而三条信息在曲线里：① **两者的绝对高度**（判断容量是否够）；② **两者之间的间隙及其随时间的变化**（间隙持续扩大 = 泛化在恶化，是早停的信号）；③ **训练损失的噪声幅度**（震荡大 = 学习率或批大小有问题，不是容量问题）。**先看这三条，再决定是调容量还是调优化**——这是避免「拿正则治学习率问题」的关键顺序。
:::

## 1.7.2 偏置-方差分解与「近似-估计」误差

::: thm 定理 1.7.1 · 偏置-方差分解 {#thm-1.7.1}
设真实目标 $y=f^\star(\boldsymbol x)+\epsilon$，$\mathbb E[\epsilon]=0$、$\operatorname{Var}(\epsilon)=\sigma^2$，训练集 $S$ 独立采样。对任意学习算法给出的预测 $\hat f_S(\boldsymbol x)$，在点 $\boldsymbol x$ 处的**期望平方误差**分解为

$$\mathbb E_{S,\epsilon}\Bigl[\bigl(y-\hat f_S(\boldsymbol x)\bigr)^2\Bigr]=\underbrace{\sigma^2}_{\text{不可约噪声}}+\underbrace{\Bigl(\mathbb E_S[\hat f_S(\boldsymbol x)]-f^\star(\boldsymbol x)\Bigr)^2}_{\text{偏置}^2}+\underbrace{\mathbb E_S\Bigl[\bigl(\hat f_S(\boldsymbol x)-\mathbb E_S[\hat f_S(\boldsymbol x)]\bigr)^2\Bigr]}_{\text{方差}} .$$

**偏置**度量「平均而言预测偏离真值的程度」（模型族的表达能力不足）；**方差**度量「换一个训练集，预测会变多少」（对训练数据的敏感程度）。
:::

::: proof 推导（把期望拆成三项）
记 $\bar f(\boldsymbol x)=\mathbb E_S[\hat f_S(\boldsymbol x)]$。以 $\mathbb E_{S,\epsilon}[(y-\hat f)^2]=\mathbb E_{S,\epsilon}[(y-f^\star)^2]+2\,\mathbb E[(y-f^\star)(f^\star-\hat f)]+\mathbb E[(f^\star-\hat f)^2]$ 展开。

**第二项为零**：条件于 $S$，$y=f^\star+\epsilon$ 且 $\mathbb E[\epsilon]=0$，故 $\mathbb E_\epsilon[(y-f^\star)(f^\star-\hat f_S)]=\mathbb E_\epsilon[\epsilon]\cdot(\cdot)=0$，再对 $S$ 取期望仍为零。

**第一项**为 $\mathbb E[\epsilon^2]=\sigma^2$。

**第三项**再加一次减项：$\mathbb E_S[(f^\star-\hat f_S)^2]=\mathbb E_S[(f^\star-\bar f+\bar f-\hat f_S)^2]=(f^\star-\bar f)^2+2(f^\star-\bar f)\underbrace{\mathbb E_S[\bar f-\hat f_S]}_{0}+\mathbb E_S[(\hat f_S-\bar f)^2]$，即得偏置平方加方差。$\blacksquare$
:::

::: intuition 偏置与方差是两种完全不同的失败
**高偏置**：所有训练集上跑出来的模型都犯了同一个方向的错——模型族太小，看什么都只能用一把直尺（欠拟合）。**高方差**：每个训练集上跑出来的模型彼此差异很大，模型对训练数据的具体噪声过度敏感（过拟合）。

因此「加大模型」会同时降低偏置、提高方差，最优容量在两者交点。这就是经典图景（U 形测试误差曲线）的来源。**但 1.7.5 会说明这个图景在深度学习里只是局部的**。
:::

::: cor 推论 1.7.1 · 近似误差与估计误差 {#cor-1.7.1}
把总误差按三种不同的差距拆开，比偏置-方差更适合指导实践：

$$R(\theta_{\text{trained}})-R^\star=\underbrace{\bigl[\inf_{\theta\in\Theta}R(\theta)-R^\star\bigr]}_{\text{近似误差（模型族的能力）}}+\underbrace{\bigl[R(\theta^\star_\Theta)-R(\hat\theta_S)\bigr]}_{\text{估计误差（样本有限）}}+\underbrace{\bigl[R(\hat\theta_S)-R(\hat\theta_{\text{trained}})\bigr]}_{\text{优化误差（没找到最优）}} .$$

- **近似误差大** → 加容量、换架构、加更好特征；
- **估计误差大** → 加数据、加正则、简化模型（对应「过拟合」）；
- **优化误差大** → 调优化器 / 学习率 / 归一化 / 初始化（对应「训不动」）。

**三类误差的处置手段互不通用**：用正则去治优化误差、用加容量去治估计误差，都是常见的无效努力。
:::

::: ex 例 1.7.1 · Dropout 在训练期改了什么统计量 {#ex-1.7.1}
设某隐藏单元的激活（未加 Dropout 前）恒为 $a=2.0$，Dropout 概率 $p=0.3$，框架采用「训练期除以 $1-p$」的实现。

(1) 求训练期该单元输出的期望与方差；(2) 求推理期该单元的输出；(3) 若训练期**不做**这个除法，训练与推理的期望各是多少，差几倍？(4) 一个 8 层的网络，每层都是这种情形且都不补偿，推理时的激活尺度会被整体放大几倍？

::: proof 解
**(1)** 训练期输出为 $\tilde a=\dfrac{m\,a}{1-p}$，$m\sim\mathrm{Bernoulli}(0.7)$。于是

$$\mathbb E[\tilde a]=\frac{(1-p)a}{1-p}=a=2.0,\qquad \operatorname{Var}(\tilde a)=\frac{p}{1-p}a^2=\frac{0.3}{0.7}\times4.0\approx1.714 .$$

（方差公式来自 $m$ 的方差 $\mathrm{Var}(m)=p(1-p)$：$\operatorname{Var}\bigl(\frac{ma}{1-p}\bigr)=\frac{a^2p(1-p)}{(1-p)^2}=\frac{pa^2}{1-p}$。）**关键点：期望不变，方差被注入**——既保证了训练与推理的期望一致，又把「乘性噪声」加进了激活。

**(2)** 推理期不做任何随机化、也不缩放，输出恒为 $a=2.0$，与 (1) 的期望一致。**这就是「推理期不需要补偿」的全部理由。**

**(3)** 若训练期不补偿，训练期期望为 $(1-p)a=1.4$，推理期为 $a=2.0$，**差 $1/(1-p)=1/0.7\approx1.43$ 倍**。单层看只是 1.43 倍，似乎无害。

**(4)** 8 层叠加：$1.43^{8}\approx17.2$ 倍。深层网络的激活尺度随层数几何放大，足以把后续层推入饱和区或导致数值溢出——**这是「Dropout 用错」在深层网络里最典型的表现：训练正常，推理输出荒谬。** 这也是为什么框架统一采用「训练期缩放」而不是「推理期缩放」：把因子放在训练期，推理路径就没有任何需要记住的额外操作，导出模型、量化、重写推理代码时都不会遗漏。$\blacksquare$
:::
:::

::: ex 例 1.7.2 · 用偏置-方差分解解释「为什么加更多参数会先变差」 {#ex-1.7.2}
某回归任务在某点 $\boldsymbol x$ 处的真值 $f^\star=0$，噪声标准差 $\sigma=1.0$。三个候选模型的统计量如下（都在该点评估）：A：$\mathbb E_S[\hat f]=0.5$、$\operatorname{Var}_S[\hat f]=0.1$；B：$\mathbb E_S[\hat f]=0.1$、$\operatorname{Var}_S[\hat f]=2.0$；C：$\mathbb E_S[\hat f]=0.1$、$\operatorname{Var}_S[\hat f]=0.5$。

(1) 分别算出三者的期望平方误差；(2) 指出哪个是「高偏置」、哪个是「高方差」；(3) 若你只能观测到「训练误差」与「验证误差」，如何区分 B 与 C？

::: proof 解
**(1)** 用定理 1.7.1 的三项分解 $\mathbb E[(y-\hat f)^2]=\sigma^2+\text{偏置}^2+\text{方差}$，且 $\sigma^2=1.0$：

| 模型 | $\sigma^2$ | 偏置$^2$ | 方差 | 期望平方误差 |
|:--|:--|:--|:--|:--|
| A | $1.0$ | $0.5^2=0.25$ | $0.1$ | $1.35$ |
| B | $1.0$ | $0.1^2=0.01$ | $2.0$ | $3.01$ |
| C | $1.0$ | $0.01$ | $0.5$ | $1.51$ |

**(2)** A 的偏置项（$0.25$）远大于方差项（$0.1$）——**高偏置**，模型族表达能力不足（欠拟合）。B 的方差项（$2.0$）是偏置项的 $200$ 倍——**高方差**，对训练集的具体噪声过度敏感（过拟合）。C 是二者的折中。

**(3)** 观测手段是**训练误差与验证误差的组合**：高偏置的模型在训练集上就做不好（训练误差高、验证误差也高，两者贴近）；高方差的模型在训练集上做得很好（训练误差低）但验证误差高（间隙大）。**因此：训练误差高 → 偏置问题（加容量）；训练误差低而验证误差高 → 方差问题（加正则 / 加数据）。** 这正是 [1.1 诊断表](sec17.md)里那张表的定量依据。

**(4) 顺带读出「先变差」的原因**：从 A 到 B 是典型的「加大容量」路径——偏置从 $0.25$ 降到 $0.01$（收益 $0.24$），但方差从 $0.1$ 涨到 $2.0$（代价 $1.9$），净效应是误差上升到 $3.01$。**代价大于收益，这就是经典 U 形曲线左侧到右侧的「变差」阶段**；再往下继续加容量，如 [1.7.5](#sec-1.7.5) 所述，方差可能因为隐式正则而重新下降，出现双下降的第二个谷。$\blacksquare$
:::

:::

## 1.7.3 正则化清单：每条改的是什么 {#sec-1.7.3}

::: def 定义 1.7.2 · 正则化（regularization） {#def-1.7.2}
**正则化**是任何「在训练目标之外、以降低泛化误差为目的」的手段。它可以作用于**参数**（约束权重的范数或结构）、**数据**（扩充或改造样本）、**训练过程**（提前停止、噪声注入）、或**损失**（软化目标）。统一的理解是：**把有限的数据所能提供的「能力预算」重新分配**——让模型倾向于那些在数据扰动下依然稳定的解。
:::

| 手段 | 机制 | 关键超参 | 推理期的变化 | 典型陷阱 |
|:--|:--|:--|:--|:--|
| **L2 权重衰减** | 每步把参数乘 $(1-\eta\lambda)$（[1.6.5](sec16.md)） | $\lambda$（$10^{-4}\sim10^{-2}$，需按任务调） | 无 | 对偏置 / 归一化参数也施加；与 Adam 混用（应配 AdamW） |
| **L1 正则** | 加 $\lambda\lVert\theta\rVert_1$，其对 $\theta$ 的**次梯度**为常值向量 $\lambda\operatorname{sign}(\theta)$（不像 L2 那样与 $\theta$ 成正比） | $\lambda$ | 无 | 原点是尖点，会产生**精确为零**的解（稀疏），深度学习里不常用 |
| **Dropout** | 训练时以概率 $p$ 将激活置零，推理期按 $1-p$ 缩放（或训练期除以 $1-p$） | $p$（$0.1\sim0.5$） | **关闭** Dropout，改为缩放（见下） | 与 BatchNorm 同用时方差失配；推理忘了 `eval()` |
| **早停** | 验证损失不再改善就停止，保存最佳权重 | 耐心值（patience） | 无 | 用测试集做早停（等于泄漏）；耐心值过小导致过早停 |
| **数据增强** | 对训练样本做保持标签不变 的变换（翻转 / 裁剪 / 色彩抖动 / 回译 / 混音） | 增强强度 | 无（只作用于训练） | 变换破坏了标签语义（如手写数字的垂直翻转）；验证集也被增强 |
| **标签平滑** | 软化目标分布（[1.4.7](sec14.md#sec-1.4.7)） | $\epsilon$（$0.05\sim0.1$） | 无 | 损害置信度校准与蒸馏 |
| **模型平均 / 集成** | 对多个模型（或训练过程中的权重快照）取平均 | 快照间隔、成员数 | 推理开销随成员数增长 | 成员间相关性太高时收益有限 |

::: method Dropout 的推理期缩放：为什么必须乘 $(1-p)$ {#method-1.7.1}
**训练期**：随机掩码 $\boldsymbol m\sim\mathrm{Bernoulli}(1-p)$ 逐元素相乘，$\tilde{\boldsymbol a}=\frac{\boldsymbol m\odot\boldsymbol a}{1-p}$（**注意这里已经除以了 $1-p$**）。于是对每个元素

$$\mathbb E[\tilde a]=\frac{(1-p)\,a}{1-p}=a,\qquad \operatorname{Var}(\tilde a)=\frac{p}{1-p}a^2 .$$

**推理期**：直接使用 $\boldsymbol a$，不做任何随机化、不再缩放。因为训练期那个除法已经保证了「期望输出与推理期一致」。

**为什么不能反着做**（训练期不缩放、推理期乘 $1-p$）：两种做法在数学上等价（把因子从训练搬到推理），但会让推理逻辑多一个只属于训练技巧的因子，容易忘记或写错，而且不利于融合算子。**框架实现的 `nn.Dropout` 采用「训练期缩放」**，因此推理只需 `model.eval()`。

**为什么要缩放**：如果不缩放，训练期每个神经元的期望输出是 $(1-p)a$、推理期是 $a$，两者差一个因子，等于在推理时把每层的激活整体放大 $1/(1-p)$ 倍，多层叠加后会造成严重失配（$p=0.5$、$L=10$ 层时是 $2^{10}$ 倍）。**这是「Dropout 用错」最常见的症状来源：训练正常但推理输出荒谬。**
:::

::: think Dropout、BatchNorm 与权重衰减三者的相互作用
三者在数学上有重叠也有冲突，选型时要一起考虑：

- **Dropout 与 BatchNorm 冲突**：Dropout 在训练期随机置零会改变每个通道的方差，而 BN 正是用批统计量做方差归一化。两者同时打开会让「训练期的统计量」在不同前向之间摆动，推理时的 running statistics 与训练时的瞬时统计量不一致。常见做法是**卷积网络中慎用二者组合**（或在 Dropout 之后加 BN），而 Transformer 里普遍用 Dropout + LayerNorm（LN 的统计量按样本算，与 Dropout 的随机性耦合更弱）。
- **权重衰减与归一化层**：BN/LN 让激活尺度与权重尺度部分解耦，因此权重衰减的效果被削弱（不再直接决定激活幅度）。这解释了「用了 BN 之后 $\lambda$ 的合适取值往往更小、更不敏感」。
- **Dropout 与权重衰减都可看作噪声注入**：Dropout 注入的是**激活空间的乘性噪声**，权重衰减注入的是**参数空间的收缩偏置**；两者的正则收益不独立叠加，同时开满通常不是最优。
:::

## 1.7.4 归一化层：BatchNorm、LayerNorm 与 RMSNorm {#sec-1.7.4}

::: def 定义 1.7.3 · 归一化层 {#def-1.7.3}
设激活张量 $\boldsymbol H$，$\mathcal S$ 是「计算统计量所覆盖的元素集合」（决定归一化沿哪些维度做），$\mu_{\mathcal S}$、$\sigma^2_{\mathcal S}$ 为在该集合上的均值与方差：

$$\hat{\boldsymbol H}=\frac{\boldsymbol H-\mu_{\mathcal S}}{\sqrt{\sigma^2_{\mathcal S}+\epsilon}},\qquad \boldsymbol Y=\gamma\odot\hat{\boldsymbol H}+\beta,$$

其中 $\gamma,\beta$ 为可学习的逐通道（或逐特征）缩放与平移。

- **BatchNorm（BN）**：$\mathcal S$ 取**同一通道、跨批内样本与空间位置**的元素（如输入 $(N,C,H,W)$ 时沿 $N,H,W$ 求统计量）。
- **LayerNorm（LN）**：$\mathcal S$ 取**同一批内样本、跨最后若干特征维**的元素（如输入 $(B,T,d)$ 时沿 $(T,d)$ 或仅沿 $d$ 求统计量）。
- **RMSNorm**：去掉减均值与平移，只用均方根缩放，$\hat h=h/\sqrt{\frac1n\sum_i h_i^2+\epsilon}$，再乘可学习的 $\gamma$。
:::

::: intuition 归一化到底在改善什么：改了曲率，不只是「稳定数值」
把归一化仅仅理解成「防止数值爆炸」是低估了它。它的核心作用是**把各方向的曲率拉到相近尺度**：若某层的输入尺度在不同特征间相差 1000 倍，那么损失曲面在这两个方向上的曲率也相差百万倍（因为梯度随输入尺度成比例），梯度下降可用步长被最陡的方向限制。归一化把每层输入重新标准化到相近尺度，于是所有方向可用同一个步长——这正是 [定理 1.5.1](sec15.md#thm-1.5.1)里 $\beta$（Lipschitz 常数）被压小、允许学习率变大的机制。所以归一化通常表现为**「能开更大的学习率、对初始化更宽容、训练更快」**，而不只是「不会 NaN」。
:::

::: thm 定理 1.7.2 · 训练与推理的差别：BN 用 running statistics {#thm-1.7.2}
BN 在**训练期**用当前小批量的统计量 $(\mu_{\mathcal B},\sigma^2_{\mathcal B})$；同时用指数滑动平均累积**running statistics**

$$\mu_{\text{run}}\leftarrow(1-\alpha)\mu_{\text{run}}+\alpha\mu_{\mathcal B},\qquad \sigma^2_{\text{run}}\leftarrow(1-\alpha)\sigma^2_{\text{run}}+\alpha\sigma^2_{\mathcal B}\quad(\alpha\ \text{为 momentum}).$$

**推理期**使用固定的 $(\mu_{\text{run}},\sigma^2_{\text{run}})$，不再依赖当前批。LN 与 RMSNorm 的统计量**只依赖当前样本**，因此训练与推理**行为一致**，无需 running statistics、也没有批大小依赖。
:::

::: intuition 这条差别决定了 Transformer 为什么不用 BN
BN 的两个性质在序列建模里都变成缺陷：

1. **依赖批内其他样本**：BN 的归一化统计量把同批样本耦合在一起。序列任务里样本长度不一、批内 padding 比例不同，统计量会随之漂移；更严重的是**推理时批量大小为 1**（在线服务、自回归生成每次只生成一个 token），此时只能用训练累积的 running statistics，与训练时的瞬时统计量不一致，造成训练 - 推理差距。
2. **沿批维的统计在变长序列上没有自然定义**：$(B,T,d)$ 的张量里，$T$ 随样本变化，padding 位置会污染统计量；layer 间的 token 数也不固定。

**LN 则对每个位置、每个样本单独归一化**（在特征维上），统计量只与该 token 自身的特征有关——既与批大小无关，也与序列长度无关，且训练/推理完全一致。**这是现代 Transformer 一律使用 LayerNorm 类（LN 或其简化版 RMSNorm）的直接原因**，与「LN 比 BN 效果好」这种笼统说法不同：是**结构约束**决定了选择。

**RMSNorm 的取舍**：去掉了减均值（re-centering）与平移项。公开研究给出的观察是：LN 的收益主要来自缩放（re-scaling）而不是重新居中，因此去掉居中后效果基本相当而计算更省（省去一次减均值与一次求均值的通信，在大模型里可感知）。**结论依赖具体规模与实现，采用前应核实**（见延伸阅读）。
:::

| 维度 | BatchNorm | LayerNorm | RMSNorm |
|:--|:--|:--|:--|
| 统计集合 | 跨批 + 空间 | 跨特征（单样本） | 跨特征（单样本，只用均方） |
| 与批大小相关 | **是**（小时统计不稳） | 否 | 否 |
| 与序列长度相关 | 是（变长序列需小心） | 否 | 否 |
| 训练 / 推理一致 | **否**（需 running stats） | 是 | 是 |
| 可学习参数 | $\gamma,\beta$ | $\gamma,\beta$ | 仅 $\gamma$ |
| 主要使用场景 | CNN 图像分类 | Transformer（原始实现） | 现代大模型（LLaMA 类） |
| 主要风险 | 小批量 / 推理 batch=1 / 与 Dropout 冲突 | 计算量略大 | 极少数任务上因缺少居中而略差（需核实） |

## 1.7.5 双下降：经典图景的边界 {#sec-1.7.5}

经典偏置-方差图景预测：模型容量增大到某个点后，测试误差必然上升。**但在深度网络里，测试误差可以二次下降**——这就是**双下降（double descent）**现象。

::: thm 定理 1.7.3 · 双下降现象（经验陈述） {#thm-1.7.3}
在若干受控实验（小规模数据、可精确控制模型容量）中，随模型参数量（或训练轮数、或样本量变化时的模型规模）增大，**测试误差曲线呈现「先降 → 升到峰值 → 再降到比第一个谷更低」的形态**，而经典 U 形曲线只是它的前半段。峰值出现在「参数数量与训练样本数量相当」的**插值阈值**附近（此时模型刚好能完美拟合训练数据）。
:::

::: intuition 为什么会有第二次下降，以及它为什么反直觉
**插值阈值处最危险**：模型容量恰好够拟合训练集时，它被迫用非常「陡峭」的方式穿过每个训练点，对噪声极度敏感，于是测试误差出现峰值。

**越过阈值之后反而变好**：可选的插值解变得极多，梯度下降的**隐式偏好**（它从初始点附近出发、倾向于「范数小、平滑」的解）会在众多能完美拟合训练集的函数里挑出一个比较平滑的。于是测试误差回落，甚至低于欠参数化区域的最好水平。

**为什么它反直觉**：它说明「模型参数比样本多，所以一定过拟合」这个推论不成立——**在现代深度网络里，参数数量本身既不是过拟合的充分条件也不是必要条件**，起决定作用的是有没有隐式 / 显式的正则化，以及训练方法倾向于哪一类解。因此「减少参数量」不是解决过拟合的默认手段（在很多任务上加大模型反而更好），应当优先考虑数据质量、增强与训练细节。
:::

::: note[skip] 双下降的适用范围与争议
- 已报告的双下降包含多种形式：**模型规模**双下降、**训练轮数**双下降（train time double descent）、以及**样本量**双下降（样本固定、数据越多反而先变差再变好）。
- 它在**受控小规模实验**中较可靠地复现；在大规模真实任务（如 ImageNet 上的标准骨干网络）中不易干净地观察到，是否属于普遍规律仍有争议。
- 对本教程的实用含义有三条：① 不要用「参数量 / 样本量之比」单凭数量判断是否过拟合；② 观察到的「容量增加先变差后变好」的曲线不一定意味着经典理论错了，也可能是学习率、训练轮数、正则强度没有随之调整；③ **报告的结论必须带上全部训练配置**——只报架构不报训练细节的实验无法复现双下降。
:::

## 1.7.6 数据泄漏与验证集设计 {#sec-1.7.6}

「泛化异常地好」的第一嫌疑人**不是**模型，而是评估方法。**数据泄漏（data leakage）**指训练阶段以任何形式接触到了评估阶段的信息，它会让报告指标系统性偏高、且线上部署后立刻崩掉。

::: errata 数据泄漏的六种常见形态
1. **在划分之前做预处理**。对全量数据计算均值 / 方差 / 主成分 / 词频，再做归一化或特征选择——验证集的信息通过统计量泄漏进训练。**正确做法**：先划分，再只用训练集拟合预处理器，然后 `transform` 验证集（`fit` 在训练集，`transform` 在验证集）。
2. **随机划分时间序列**。把时间序列随机切分会让「未来」进入训练集（更强的邻近相关性直接泄漏）。**正确做法**：按时间切分（训练在前、验证在后），并保留一个时间上的 gap 以避免滑窗重叠。
3. **分组数据的随机划分**。同一病人 / 同一用户 / 同一设备的多个样本被随机分到两边，模型只需记住「这个用户是谁」就能答对。**正确做法**：按组划分（GroupKFold 或按实体划分）。
4. **重复样本跨越划分**。数据集里的近似重复样本（爬虫重复、增强后的副本）分别落在训练与验证集。**正确做法**：先去重（含近重复检测）再划分。
5. **用验证集反复调参并报告验证集结果**。每一次基于验证集的选择都在消耗验证集的信息（相当于在验证集上过拟合）。**正确做法**：超参搜索用验证集，最终报告用一次性的测试集。
6. **目标泄漏（target leakage）**。某个特征在真实预测时不可得（如「结案状态」用于预测「是否结案」），训练时却存在。**判据**：逐个特征问「这个值在**预测时刻**能拿到吗」。
:::

::: method 验证集设计检查清单 {#method-1.7.2}
训练开始前逐条过：

1. **划分方式与部署场景一致**：随机划分（独立同分布样本）、时间划分（时序）、分组划分（同一实体多样本）、分层划分（类别极不均衡）。
2. **预处理只在训练集上拟合**（含标准化、缺失值填充、编码、特征选择、目标编码、SMOTE 类过采样）。
3. **测试集封存**：在项目开始时就固定下来，训练过程中不看、不调、不选；最终只评估一次。
4. **记录划分的随机种子与代码版本**：划分不可复现时，任何指标都不可复现（见 [第 9 讲](../lec09/overview.md)与工程工具箱）。
5. **早期检查一次泄漏**：用一个「随机标签」对照实验——把训练标签打乱后重训，如果验证指标仍显著高于随机水平，几乎一定有泄漏。这是最便宜、最直接的泄漏探测手段。
6. **监控训练 - 验证间隙随训练的变化**：间隙突然扩大通常不是模型突然过拟合，而是数据划分或评估代码出了问题。
:::

## 1.7.7 代码：正则化对照、早停与归一化层 {#sec-1.7.7}

```python
import torch, torch.nn as nn, torch.nn.functional as F

torch.manual_seed(0)

# ============ ① Dropout 的缩放：验证训练/推理的期望值一致（方法 1.7.1） ============
p = 0.3
dp = nn.Dropout(p)
a = torch.ones(100000)
dp.train(); train_out = dp(a)                       # 训练期：置零 + 除以 (1-p)
dp.eval();  eval_out  = dp(a)                       # 推理期：恒等映射，不再随机
print("train mean =", round(train_out.mean().item(), 5),   # 应 ≈ 1.0（乘了 1/(1-p) 的补偿）
      " eval mean =", round(eval_out.mean().item(), 5),     # 恒为 1.0
      " 置零比例 ≈", round((train_out == 0).float().mean().item(), 3))   # 应 ≈ p

# ============ ② 归一化层的统计维度：看清 BN 与 LN 各自沿哪些维度求和 ============
h = torch.randn(8, 4, 16, 16)                        # (N,C,H,W)：批 8、通道 4、空间 16×16
bn = nn.BatchNorm2d(4); ln = nn.LayerNorm([4, 16, 16])
bn_out, ln_out = bn(h), ln(h)
# BN 沿 (N,H,W) 求统计 → 每个通道的均值应≈0；LN 沿 (C,H,W) 求统计 → 每个样本的均值应≈0
print("BN 每通道均值:", bn_out.mean(dim=(0, 2, 3)).abs().max().item())
print("LN 每样本均值:", ln_out.mean(dim=(1, 2, 3)).abs().max().item())

# ============ ③ 早停：保存最佳权重而不是最后一轮的权重 ============
class EarlyStopper:
    def __init__(self, patience=5, min_delta=1e-4):
        self.patience, self.min_delta = patience, min_delta
        self.best, self.bad, self.best_state = float("inf"), 0, None
    def step(self, val_loss, model):
        if val_loss < self.best - self.min_delta:       # 有实质改善：刷新记录并快照权重
            self.best, self.bad = val_loss, 0
            self.best_state = {k: v.detach().clone() for k, v in model.state_dict().items()}
        else:                                           # 无改善：累计，超过耐心值就停
            self.bad += 1
        return self.bad >= self.patience                # 返回 True 表示应当停止

def train_once(weight_decay=0.0, dropout=0.0, label_smoothing=0.0, epochs=60, seed=0):
    torch.manual_seed(seed)
    n, d = 200, 20
    x = torch.randn(n, d)
    # 真实规律只依赖前 5 维；其余是噪声维度 → 容量过大时极易过拟合
    w = torch.zeros(d); w[:5] = 1.0
    y = (x @ w > 0).float().unsqueeze(1)
    x_tr, y_tr, x_va, y_va = x[:150], y[:150], x[150:], y[150:]
    model = nn.Sequential(nn.Linear(d, 256), nn.ReLU(), nn.Dropout(dropout),
                          nn.Linear(256, 256), nn.ReLU(), nn.Dropout(dropout),
                          nn.Linear(256, 1))
    opt = torch.optim.AdamW(model.parameters(), lr=1e-3, weight_decay=weight_decay)
    stopper = EarlyStopper(patience=8)
    for ep in range(epochs):
        model.train()
        loss = F.binary_cross_entropy_with_logits(model(x_tr), y_tr)
        opt.zero_grad(); loss.backward(); opt.step()
        model.eval()
        with torch.no_grad():
            vl = F.binary_cross_entropy_with_logits(model(x_va), y_va).item()
        if stopper.step(vl, model):
            break
    model.load_state_dict(stopper.best_state)           # 关键：回滚到最佳权重
    model.eval()
    with torch.no_grad():
        va_acc = ((model(x_va) > 0).float() == y_va).float().mean().item()
    return stopper.best, va_acc

for cfg in [dict(), dict(weight_decay=0.01), dict(dropout=0.3), dict(weight_decay=0.01, dropout=0.3)]:
    best, acc = train_once(**cfg)
    print(f"{str(cfg):55s} best_val={best:.4f}  val_acc={acc:.3f}")

# ============ ④ 泄漏探测：打乱标签后重训，看验证指标是否仍“很好” ============
def leak_probe():
    torch.manual_seed(0)
    x = torch.randn(300, 20); y = torch.randint(0, 2, (300, 1)).float()
    perm = torch.randperm(300)          # 故意破坏样本—标签的对应关系
    x, y = x[perm], y[perm]
    m = nn.Sequential(nn.Linear(20, 64), nn.ReLU(), nn.Linear(64, 1))
    opt = torch.optim.AdamW(m.parameters(), lr=1e-3)
    for _ in range(200):
        loss = F.binary_cross_entropy_with_logits(m(x[:200]), y[:200])
        opt.zero_grad(); loss.backward(); opt.step()
    with torch.no_grad():
        acc = ((m(x[200:]) > 0).float() == y[200:]).float().mean().item()
    return acc                          # 随机标签下应≈0.5；显著更高说明流程里有泄漏
print("leak probe val_acc =", round(leak_probe(), 3))
```

## 1.7.8 陷阱与勘误

::: errata 本节九个高频错误
1. **用测试集调超参 / 早停**：等价于把测试集信息泄漏进模型选择，报告指标系统性偏高。测试集只在最后用一次。
2. **预处理在划分之前做**（[1.7.6](#sec-1.7.6)第 1 条的完整说明）。这是最高频、最隐蔽的一处泄漏。
3. **推理时忘记 `model.eval()`**：Dropout 仍在随机置零、BatchNorm 仍在用当前批统计量，预测结果不稳定且分布偏移。判据：同一输入连续推理两次结果不同。
4. **把 Dropout 当作通用解药**：在卷积网络里它常不如权重衰减与数据增强；与 BatchNorm 同用还可能损害精度（[1.7.3](#sec-1.7.3)的辨析）。
5. **在小批量 / 变长序列上用 BatchNorm**：批量太小时统计量噪声大；变长序列与推理 batch=1 时训练 - 推理不一致（[1.7.4](#sec-1.7.4)）。
6. **把「训练损失降到零」当成训练成功的标志**：过度训练到零训练损失会显著放大泛化间隙（[1.7.5](#sec-1.7.5)的双下降说明这不是单调有害，但需要正则与早停配合）。
7. **正则强度随意照搬**：`weight_decay=0.1`、`dropout=0.5` 这类值来自特定配置（模型规模、批大小、数据量），跨任务照搬常导致欠拟合。
8. **只报告单一指标**：类别不均衡任务上准确率可能虚高，应同时报告精确率 / 召回率 / F1 或 AUC，并给出类别分布。
9. **认为「更多数据一定更好」**：被污染的数据（重复、错标、泄漏样本）会让更多数据变成更差的结果；先做数据审计（重复率、标签一致性、分布对比）再加量。
:::

::: method 即时自测 · 1.7
**Q1** 写出偏置-方差分解的三项，并说明「加大模型容量」同时会怎样影响前两项。

**Q2** Dropout 的推理期为什么不需要再做缩放？如果训练期不缩放、推理期乘 $(1-p)$，会出现什么现象？

**Q3** 说明 Transformer 为什么用 LayerNorm 而不用 BatchNorm，至少给出两条与结构约束相关的理由。

**Q4** 你训练一个模型，验证准确率异常地高（0.99），但同一模型部署后只有 0.6。列出你会依次检查的三件事。

::: sol 参考要点
**Q1** $\mathbb E[(y-\hat f)^2]=\sigma^2+\text{偏置}^2+\text{方差}$，三项分别是不可约噪声、$(\mathbb E_S\hat f-f^\star)^2$、$\mathbb E_S[(\hat f-\mathbb E_S\hat f)^2]$。加大容量会**降低偏置**（模型族更能覆盖真函数）、**提高方差**（对训练集具体噪声更敏感）。经典图景下最优容量出现在两者之和的最小点。

**Q2** 因为训练期已经做了「除以 $1-p$」的补偿（$\tilde a=m\odot a/(1-p)$），使得 $\mathbb E[\tilde a]=a$，与推理期的恒等输出期望一致，所以推理期只需要恒等映射。若反过来（训练不缩放、推理乘 $1-p$），在数学上与正确做法等价（只是把因子搬到推理），但推理代码里多出一个只服务于训练技巧的因子——一旦忘记或写错（尤其在导出模型、重写推理代码、量化转换时），每层激活会被放大 $1/(1-p)$ 倍，多层叠加后输出完全失真。

**Q3** 两条结构理由：① **统计量的定义域**：BN 沿批维统计，而序列数据是变长、带 padding、批量大小随推理而变化（自回归生成时 batch=1），沿批统计在语义上不稳定/无定义；LN 对每个 token 独立统计，与批大小、序列长度都无关。② **训练 - 推理一致性**：BN 需要 running statistics，推理时统计量与训练时的瞬时统计量不一致；LN 训练与推理完全一致，不需要额外状态。此外 LN 在小批量下表现稳定，也便于与张量并行等分布式策略结合（归一化只涉及单样本的特征维）。

**Q4** ① **数据泄漏**：检查预处理是否在划分前拟合（标准化 / 特征选择 / 编码）、是否随机划分了时序或分组数据、是否存在重复样本跨越划分；用「打乱标签重训」探测（[1.7.7](#sec-1.7.7)的 `leak_probe`）。② **评估代码与推理不一致**：验证时是否忘了 `model.eval()`（Dropout / BN 行为差异）、推理管线是否复现了训练时的预处理（归一化参数、输入分辨率、编码方式、tokenization）。③ **分布漂移**：比较线上输入与验证集输入的分布（尺寸、色彩、文本长度、来源渠道），并检查线上指标的计算口径是否与离线一致（阈值、标签定义、去重规则）。
:::
:::

::: note[skip] 延伸阅读
- Ioffe & Szegedy, *Batch Normalization: Accelerating Deep Network Training by Reducing Internal Covariate Shift*（2015，ICML；arXiv:1502.03167）——BatchNorm 原始论文（其「内部协变量偏移」解释后来受到质疑，见下条）。
- Santurkar, Tsipras, Ilyas & Madry, *How Does Batch Normalization Help Optimization?*（2018，NeurIPS；arXiv:1805.11604）——论证 BN 的主要作用是平滑优化曲面（而非减少内部协变量偏移）。
- Ba, Kiros & Hinton, *Layer Normalization*（2016，arXiv:1607.06450）——LayerNorm 原始论文。
- Zhang & Sennrich, *Root Mean Square Layer Normalization*（2019，arXiv:1910.07467）——RMSNorm。
- Srivastava, Hinton, Krizhevsky, Sutskever & Salakhutdinov, *Dropout: A Simple Way to Prevent Neural Networks from Overfitting*（2014，JMLR）——Dropout 的完整论述（含推理期缩放的两种等价写法）。
- Belkin, Hsu, Ma & Mandal, *Reconciling Modern Machine Learning Practice and the Bias-Variance Trade-off*（2019，PNAS；arXiv:1812.11118）——双下降现象的提出。
- Nakkiran, Kaplun, Bansal, Yang, Barak & Sutskever, *Deep Double Descent: Where Bigger Models and More Data Hurt*（2020，ICLR；arXiv:1912.02292）——模型规模、训练轮数与样本量三种双下降的实验研究。
:::

**本节小结**：泛化问题的诊断靠「训练 / 验证两条曲线的三条信息」（绝对高度、间隙变化、噪声幅度），处置方向由「欠拟合加容量、过拟合加正则」分开；统一的分析框架是近似误差 - 估计误差 - 优化误差，三类误差的手段互不通用。正则化清单里的每一种手段都可以理解为「对能力预算的再分配」，其中 Dropout 的关键细节是推理期缩放、权重衰减的关键细节是必须与 AdamW 配对。归一化层的核心作用是压平各方向的曲率从而允许更大学习率，BN / LN / RMSNorm 的差别在于**统计量覆盖哪些维度**，这一差别直接决定 Transformer 必须用 LN 类。经典偏置-方差图景的边界是双下降：参数比样本多不必然过拟合，决定因素是训练方法的隐式偏好。最后，「泛化异常好」的第一嫌疑人是评估方法本身——**在相信任何指标之前，先排除数据泄漏**。

**与后续的连接**：本讲把「结构 → 损失 → 梯度 → 优化 → 泛化」这条完整链条打通了，后面八讲都是在**结构**这一环上换形状：[第 2 讲](../lec02/overview.md)换成适应序列的结构（RNN → 注意力 → Transformer），[第 3 讲](../lec03/overview.md)换成利用空间局部性的卷积并把归一化层放到骨干里，[第 4 讲](../lec04/overview.md)把「预测」换成「采样」，[第 9 讲](../lec09/overview.md)把同一套训练循环放大到数千张卡。判据、形状推演与诊断顺序不变，变的只是张量的排布。
