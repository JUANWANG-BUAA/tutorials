# 第 1 讲 · 闭卷回忆卡

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起，只重做 △ 与 ×。共 40 张卡，一轮约 35 分钟。

## A. 定义卡

**A1.** 请写出「神经元」的定义，说明三个符号各控制什么，并区分**预激活**与**激活**。
::: sol
$z=\boldsymbol w^{\mathrm T}\boldsymbol x+b$（预激活），$a=\phi(z)$（激活）。$w$ 控制各输入的重要性、$b$ 控制激活门槛（平移自由度）、$\phi$ 决定输出形态与值域。**预激活 $z$ 是反向传播里误差信号 $\boldsymbol\delta^{(l)}$ 的定义对象**，激活 $a$ 是层的输出（[定义 1.1.1](sec11.md#def-1.1.1)、[定义 1.5.3](sec15.md#def-1.5.3)）。（✓ / △ / ×）
:::
**A2.** 「线性可分」的精确定义是什么？请写出判定不等式。
::: sol
数据集 $\{(\boldsymbol x_i,y_i)\}$（$y_i\in\{-1,+1\}$）线性可分，指**存在** $\boldsymbol w,b$ 使 $y_i(\boldsymbol w^{\mathrm T}\boldsymbol x_i+b)>0$ 对所有 $i$ 成立（[定义 1.1.2](sec11.md#def-1.1.2)）。**注意**：是「存在一组参数」，不是「某个算法一定能找到」。（✓ / △ / ×）
:::
**A3.** 写出 MLP 的逐层前向定义（含 $l$ 层、宽度 $d_l$、参数形状）。
::: sol
$\boldsymbol z^{(l)}=\boldsymbol a^{(l-1)}W^{(l)}+\boldsymbol b^{(l)}$，$\boldsymbol a^{(l)}=\phi(\boldsymbol z^{(l)})$；$W^{(l)}\in\mathbb R^{d_{l-1}\times d_l}$、$\boldsymbol b^{(l)}\in\mathbb R^{d_l}$；$1..L-1$ 为隐藏层，第 $L$ 层输出即预测；$\theta=\{W^{(l)},\boldsymbol b^{(l)}\}_{l=1}^{L}$（[定义 1.2.1](sec12.md#def-1.2.1)）。（✓ / △ / ×）
:::
**A4.** 「批优先」约定是什么？逐层形状推演只有哪三条规则？
::: sol
张量**第 0 维永远是批维**，且前向过程中批维大小不变。三条规则：① 线性层把**最后一维**换掉（$B\times d_{l-1}\to B\times d_l$）；② 逐元素激活**不改变形状**；③ 没有池化 / 卷积 stride 这类算子时 $B$ 全程不变（[方法 1.1.1](sec11.md#method-1.1.1)、[方法 1.2.1](sec12.md#method-1.2.1)）。（✓ / △ / ×）
:::
**A5.** 写出交叉熵与均方误差的定义，并说明交叉熵在 one-hot 下退化成什么。
::: sol
$\mathcal L_{\mathrm{CE}}=-\sum_c y_c\log\hat y_c$，one-hot 时退化为 $-\log\hat y_{y_{\text{true}}}$（只惩罚正确类的概率）；$\mathcal L_{\mathrm{MSE}}=\frac1N\sum_i(\hat y_i-y_i)^2$。另有 MAE（对应拉普拉斯噪声）与 Huber（阈值内平方、超出后线性）（[定义 1.4.2](sec14.md#def-1.4.2)）。（✓ / △ / ×）
:::
**A6.** 「误差信号 $\boldsymbol\delta^{(l)}$」的定义是什么？本讲约定 $\mathcal L$ 对批**求和**还是**平均**？
::: sol
$\boldsymbol\delta^{(l)}=\partial\mathcal L/\partial\boldsymbol Z^{(l)}\in\mathbb R^{B\times d_l}$。本书为公式简洁采用**批求和**；若损失取批平均，则 $\boldsymbol\delta^{(l)}$ 再乘 $1/B$——**两种约定只差一个常数因子**，但代码里不能重复除（[定义 1.5.3](sec15.md#def-1.5.3)）。（✓ / △ / ×）
:::
**A7.** 「计算图」「雅可比」「VJP」分别是什么？为什么反向传播只做 VJP 而不显式构造雅可比？
::: sol
计算图 = 把计算表示成有向无环图（节点是张量、边是基本运算）；雅可比 $J=\partial\boldsymbol v/\partial\boldsymbol u\in\mathbb R^{m\times n}$；VJP 是 $\bar{\boldsymbol u}=J^{\mathrm T}\bar{\boldsymbol v}$。**不构造 $J$** 是因为只需它与某个具体向量的乘积，而该乘积可用矩阵乘法在 $O(d_{\text{in}}d_{\text{out}})$ 内算完（[定义 1.5.2](sec15.md#def-1.5.2)）。（✓ / △ / ×）
:::
**A8.** 「学习率」与「更新方向 $\boldsymbol u_t$」的关系式是什么？不同优化器的差别体现在哪两处？
::: sol
$\theta_t=\theta_{t-1}-\eta\,\boldsymbol u_t(\boldsymbol g_1,\dots,\boldsymbol g_t;\theta_{t-1})$。差别全部体现在：① $\boldsymbol u_t$ 如何由**历史梯度**构造；② 是**逐元素缩放**还是**整体缩放**（[定义 1.6.1](sec16.md#def-1.6.1)）。（✓ / △ / ×）
:::
**A9.** 写出 AdamW 的「解耦权重衰减」更新式，并说明它与把 L2 加进损失的区别。
::: sol
$\theta_t=\theta_{t-1}-\eta_t\dfrac{\hat{\boldsymbol m}_t}{\sqrt{\hat{\boldsymbol v}_t}+\epsilon}-\eta_t\lambda\theta_{t-1}$。衰减是**独立一步**，对所有坐标施加同一相对衰减 $\eta_t\lambda$；而 L2 加进损失后会被逐元素除以 $\sqrt{\hat v_t}+\epsilon$，衰减强度依赖各坐标的梯度历史（[定理 1.6.1](sec16.md#thm-1.6.1)）。（✓ / △ / ×）
:::
**A10.** 「经验误差」「泛化误差」「泛化间隙」分别是什么？验证集与测试集各做什么？
::: sol
$\hat R_S(\theta)=\frac1N\sum_i\mathcal L(f(\boldsymbol x_i;\theta),y_i)$ 是经验（训练）误差；$R(\theta)=\mathbb E_{(\boldsymbol x,y)\sim\mathcal D}[\mathcal L]$ 是泛化误差；泛化间隙 $=R-\hat R_S$。**验证集做决策**（选模型、调超参、早停），**测试集只用于最终报告且只应使用一次**（[定义 1.7.1](sec17.md#def-1.7.1)）。（✓ / △ / ×）
:::
**A11.** 「正则化」的统一定义是什么？它作用于哪四类对象？
::: sol
任何「在训练目标之外、以降低泛化误差为目的」的手段。作用于**参数**（约束范数 / 结构）、**数据**（扩充或改造）、**训练过程**（早停、噪声注入）、**损失**（软化目标）；统一理解是**把有限数据能提供的「能力预算」重新分配**（[定义 1.7.2](sec17.md#def-1.7.2)）。（✓ / △ / ×）
:::
**A12.** 写出归一化层的一般形式，并说明 BN / LN / RMSNorm 的差别在哪一个量上。
::: sol
$\hat{\boldsymbol H}=(\boldsymbol H-\mu_{\mathcal S})/\sqrt{\sigma^2_{\mathcal S}+\epsilon}$，$\boldsymbol Y=\gamma\odot\hat{\boldsymbol H}+\beta$。三者的差别在**统计量覆盖的集合 $\mathcal S$**：BN 跨批 + 空间；LN 跨最后若干特征维（单样本）；RMSNorm 去掉减均值与平移，只用均方根缩放（[定义 1.7.3](sec17.md#def-1.7.3)）。（✓ / △ / ×）
:::

## B. 结论卡

**B1.** 为什么说「去掉非线性，深度就退化」？给出结论与直觉。
::: sol
若 $\phi$ 为恒等，任意层数的网络都等价于一个仿射变换 $\hat{\boldsymbol y}=\boldsymbol x W^\star+\boldsymbol b^\star$、$W^\star=\prod_l W^{(l)}$——**表达能力与单层相同，参数量却更多**（[定理 1.2.1](sec12.md#thm-1.2.1)）。症状：损失降到某平台后不动，且训练与验证损失几乎重合。（✓ / △ / ×）
:::
**B2.** 通用逼近定理保证了什么？三条「没保证」是什么？
::: sol
保证：紧集上、激活非常数有界单调连续时，**存在有限宽的单隐藏层网络**一致逼近任意连续函数。没保证：① 所需宽度（可能随维度指数增长）；② 梯度下降能否找到那组权重；③ 需要多少样本（[定理 1.2.2](sec12.md#thm-1.2.2)、[1.2.3](sec12.md#sec-1.2.3)）。（✓ / △ / ×）
:::
**B3.** 感知机收敛定理说了哪三件事？为什么说它是「条件结论」？
::: sol
① 线性可分时**一定**收敛；② 步数上界 $k\le(R/\gamma)^2$，由数据尺度 $R$ 与间隔 $\gamma$ 决定，**与学习率无关**；③ 不可分时定理不作保证（事实上持续震荡）。「条件」指要求**严格线性可分且范数有界**，真实数据几乎不满足前者（[定理 1.1.1](sec11.md#thm-1.1.1)）。（✓ / △ / ×）
:::
**B4.** 全 Sigmoid 深层网络的梯度衰减上界是多少？为什么说它「越自信越学不动」？
::: sol
跨 $L$ 层至少乘 $\prod_l\max_z\sigma'(z)=(1/4)^{L}$：$L=10$ 约 $9.5\times10^{-7}$。因为 $\sigma'$ 在 $|z|$ 大时极小，而大 $|z|$ 恰恰对应「网络很自信」的样本——**越自信，传给浅层的梯度越小**（[定理 1.3.1](sec13.md#thm-1.3.1)）。（✓ / △ / ×）
:::
**B5.** 死亡 ReLU 与 Sigmoid 饱和的机制差别是什么？各自首选处置？
::: sol
饱和：导数**很小但非零**，输入分布改变后单元可恢复；死亡：导数**恒为 0**，参数永不更新、**不能自愈**。处置：饱和 → 换 ReLU 族并配对 Xavier / Kaiming 初始化；死亡 → 换 GELU / SiLU、降学习率、加 warmup、加归一化层（[1.3.4](sec13.md)）。（✓ / △ / ×）
:::
**B6.** softmax + 交叉熵的梯度是什么？这个「干净」结果说明什么工程含义？
::: sol
$\nabla_{\boldsymbol z}\mathcal L=\hat{\boldsymbol p}-\boldsymbol y$，**只依赖残差**，与 softmax 的显式导数无关（二者在数学上互相抵消）。工程含义：无论 logits 多大多小，梯度都落在 $[-1,1]$ 附近，**不饱和、不放大**——分类训练比回归稳定，一半功劳在这里（[定理 1.4.2](sec14.md#thm-1.4.2)）。（✓ / △ / ×）
:::
**B7.** 为什么深度学习训练一定用反向模式自动微分？
::: sol
因为它适合「**输入多、输出少**」：一次反向传播给出对**全部输入**的导数，代价 $O(m\cdot\text{图规模})$。深度学习里输入是参数量 $P$（$10^6\sim10^{11}$）、输出是一个标量损失（$m=1$），故一次反向就够；前向模式需要 $P$ 次。代价是必须保存前向中间结果（显存开销）（[定理 1.5.2](sec15.md#thm-1.5.2)）。（✓ / △ / ×）
:::
**B8.** 误差信号 $\boldsymbol\delta^{(l)}$ 在每层被用于哪两件事？这与哪个算法同构？
::: sol
① 乘 $W^{(l+1)\mathrm T}$ 继续往上游（传给第 $l-1$ 层）；② 乘 $\boldsymbol A^{(l-1)\mathrm T}$ 得本层权重梯度。**共享同一份误差信号**是复杂度从指数降到线性的关键，与**动态规划**的「用表格保存子问题解」完全同构——正确的说法是「链式法则 + 记忆化」，不是「一种新数学」（[1.5.3](sec15.md)）。（✓ / △ / ×）
:::
**B9.** 动量的两个「$1/(1-\beta)$」分别指什么？$\beta=0.9$ 时各是多少？
::: sol
① **有效步长放大** $1/(1-\beta)$ 倍（稳态速度 $=\boldsymbol g/(1-\beta)$）；② **平滑时间尺度（记忆窗口）**约 $1/(1-\beta)$ 步。$\beta=0.9$ 时两者都约 $10$。**工程判据**：加动量后学习率通常要相应调小，否则等效步长放大 10 倍会发散（[命题 1.6.1](sec16.md#prop-1.6.1)）。（✓ / △ / ×）
:::
**B10.** 为什么 Adam 需要偏差修正？不修正会发生什么？
::: sol
因为 $m_0=v_0=0$，滑动平均在前若干步被系统性拉向零：$\mathbb E[\boldsymbol m_t]=(1-\beta_1^t)\boldsymbol\mu\neq\boldsymbol\mu$。不修正时 $\sqrt{\hat v}$ 偏小得更厉害，比值被扭曲——**前几百步的有效步长异常巨大**，训练不稳定（[定义 1.6.4](sec16.md#def-1.6.4)）。（✓ / △ / ×）
:::
**B11.** 「Adam 的更新量级约等于 $\eta$」是怎么来的？由此解释它对梯度爆炸 / 消失的表现。
::: sol
梯度近似恒定时 $\hat m_t/\sqrt{\hat v_t}\approx g/\sqrt{g^2}=\operatorname{sign}(g)$，故每步位移约 $\pm\eta$（逐坐标）。推论：① 梯度爆炸时仍**安全**（更新被压到 $\eta$ 量级）；② 梯度消失时反而**放大**（分子分母同比例缩小）。所以 Adam 对学习率的敏感性远低于 SGD（[定义 1.6.4](sec16.md#def-1.6.4)）。（✓ / △ / ×）
:::
**B12.** 线性缩放规则说什么？什么情况下失效？
::: sol
批大小乘 $k$ 时学习率同比放大 $k$ 倍（$\eta'=k\eta$），在**批内梯度噪声相对稳定且步数足够多**时可得近似相同的轨迹。失效情形：$k$ 过大、各层尺度差异悬殊、训练步数太少。替代：**平方根缩放**（$\eta'\propto\sqrt{k}$）、加长 warmup、逐层自适应（LARS / LAMB）（[定理 1.6.2](sec16.md#thm-1.6.2)）。（✓ / △ / ×）
:::
**B13.** 近似误差、估计误差、优化误差分别对应什么问题？处置手段能互换吗？
::: sol
近似误差 = 模型族能力不足（→ 加容量 / 换架构 / 加特征）；估计误差 = 样本有限（→ 加数据 / 加正则 / 简化模型）；优化误差 = 没找到最优（→ 调优化器 / 学习率 / 归一化 / 初始化）。**三类手段互不通用**：用正则治优化误差、用加容量治估计误差都是常见的无效努力（[推论 1.7.1](sec17.md#cor-1.7.1)）。（✓ / △ / ×）
:::
**B14.** 双下降现象的内容是什么？它推翻了什么流行说法？
::: sol
随模型参数量（或训练轮数、样本量）增大，测试误差呈「先降 → 升到峰值 → 再降到比第一个谷更低」的形态，峰值出现在**插值阈值**附近（参数量≈样本量）。它推翻「参数比样本多就一定过拟合」——**参数量本身既不是过拟合的充分条件也不是必要条件**，起决定作用的是隐式 / 显式正则化（[定理 1.7.3](sec17.md#thm-1.7.3)）。（✓ / △ / ×）
:::

## C. 公式卡

**C1.** 写出神经元前向与批量矩阵形式（含各张量形状），并写出 MLP 全网络参数总量公式（说明它与批大小的关系）。
::: sol
单元：$z=\boldsymbol w^{\mathrm T}\boldsymbol x+b,\ a=\phi(z)$；批量：$\boldsymbol Z=\boldsymbol XW+\mathbf 1\boldsymbol b^{\mathrm T}$、$\boldsymbol A=\phi(\boldsymbol Z)$，其中 $\boldsymbol X: B\times n$、$W: n\times m$、$\boldsymbol b: m$、$\boldsymbol Z,\boldsymbol A: B\times m$（[方法 1.1.1](sec11.md#method-1.1.1)）。参数总量 $P=\sum_{l=1}^{L}(d_{l-1}d_l+d_l)$，**与批大小 $B$ 无关**（[方法 1.2.1](sec12.md#method-1.2.1)）。（✓ / △ / ×）
:::
**C2.** 写出 Xavier 与 Kaiming 的方差公式及各自适配的激活。
::: sol
Xavier：$\operatorname{Var}(w)=\dfrac{2}{d_{\text{in}}+d_{\text{out}}}$（均匀版上界 $\sqrt{6/(d_{\text{in}}+d_{\text{out}})}$），配 Sigmoid / tanh；Kaiming：$\operatorname{Var}(w)=\dfrac{2}{d_{\text{in}}}$，配 ReLU 族（因 ReLU 半区截断使方差减半，故增益乘 2）（[方法 1.2.2](sec12.md#method-1.2.2)）。（✓ / △ / ×）
:::
**C3.** 写出反向传播的完整递推（输出层、逐层回传、两个参数梯度）。
::: sol
$$\boldsymbol\delta^{(L)}=\frac{\partial\mathcal L}{\partial\boldsymbol A^{(L)}}\odot\phi'(\boldsymbol Z^{(L)}),\quad \boldsymbol\delta^{(l)}=(\boldsymbol\delta^{(l+1)}W^{(l+1)\mathrm T})\odot\phi'(\boldsymbol Z^{(l)}),\quad \frac{\partial\mathcal L}{\partial W^{(l)}}=\boldsymbol A^{(l-1)\mathrm T}\boldsymbol\delta^{(l)},\quad \frac{\partial\mathcal L}{\partial\boldsymbol b^{(l)}}=\sum_{i=1}^{B}\boldsymbol\delta^{(l)}_{i:}.$$
偏置梯度**沿批维求和**，不是复制（[定理 1.5.3](sec15.md#thm-1.5.3)）。（✓ / △ / ×）
:::
**C4.** 写出中心差分与相对误差公式，并给三档阈值。
::: sol
$\dfrac{\partial\mathcal L}{\partial\theta_j}\approx\dfrac{\mathcal L(\theta_j+h)-\mathcal L(\theta_j-h)}{2h}$（误差 $O(h^2)$）；$\text{rel\_err}=\dfrac{\lvert g^{\text{num}}_j-g^{\text{ana}}_j\rvert}{\max(1,\lvert g^{\text{num}}_j\rvert,\lvert g^{\text{ana}}_j\rvert)}$。$h=10^{-5}\sim10^{-6}$、**双精度**下：$<10^{-7}$ 正确；$10^{-5}$ 量级可疑；$\ge10^{-3}$ 基本确定有 bug（[定义 1.5.4](sec15.md#def-1.5.4)）。（✓ / △ / ×）
:::
**C5.** 写出 Momentum 与 Nesterov 的更新式。
::: sol
Momentum：$\boldsymbol v_t=\beta\boldsymbol v_{t-1}+\boldsymbol g_t$，$\theta_t=\theta_{t-1}-\eta\boldsymbol v_t$（$\beta$ 常取 $0.9$）。Nesterov：$\boldsymbol v_t=\beta\boldsymbol v_{t-1}+\nabla_\theta\mathcal L(\theta_{t-1}-\eta\beta\boldsymbol v_{t-1})$（梯度取在**前瞻点**上）（[定义 1.6.2](sec16.md#def-1.6.2)）。（✓ / △ / ×）
:::
**C6.** 写出 RMSProp 与 AdaGrad 的更新式，并说明 RMSProp 修掉了 AdaGrad 的什么问题。
::: sol
AdaGrad：$\boldsymbol s_t=\boldsymbol s_{t-1}+\boldsymbol g_t\odot\boldsymbol g_t$，$\theta_t=\theta_{t-1}-\eta\dfrac{\boldsymbol g_t}{\sqrt{\boldsymbol s_t}+\epsilon}$；RMSProp 把累积改成指数滑动平均 $\boldsymbol s_t=\gamma\boldsymbol s_{t-1}+(1-\gamma)\boldsymbol g_t\odot\boldsymbol g_t$（$\gamma$ 常取 $0.9$ 或 $0.99$）。修掉的是「分母单调增 → 有效步长衰减到零」（[定义 1.6.3](sec16.md#def-1.6.3)）。（✓ / △ / ×）
:::
**C7.** 写出 Adam 的四个式子（含偏差修正与默认超参）。
::: sol
$\boldsymbol m_t=\beta_1\boldsymbol m_{t-1}+(1-\beta_1)\boldsymbol g_t$，$\boldsymbol v_t=\beta_2\boldsymbol v_{t-1}+(1-\beta_2)\boldsymbol g_t\odot\boldsymbol g_t$，$\hat{\boldsymbol m}_t=\dfrac{\boldsymbol m_t}{1-\beta_1^{t}}$，$\hat{\boldsymbol v}_t=\dfrac{\boldsymbol v_t}{1-\beta_2^{t}}$，$\theta_t=\theta_{t-1}-\eta\dfrac{\hat{\boldsymbol m}_t}{\sqrt{\hat{\boldsymbol v}_t}+\epsilon}$。默认 $\beta_1=0.9$、$\beta_2=0.999$、$\epsilon=10^{-8}$（[定义 1.6.4](sec16.md#def-1.6.4)）。（✓ / △ / ×）
:::
**C8.** 写出梯度裁剪与梯度累积的公式。
::: sol
裁剪：$\boldsymbol g\leftarrow\boldsymbol g\cdot\min(1,\ c/\lVert\boldsymbol g\rVert_2)$（PyTorch：`clip_grad_norm_(params, c)`，**返回值是裁剪前的范数**）；累积：每 $k$ 个小批更新一次，等效批大小 $=k\times B_{\text{micro}}$，**损失须除以 $k$**（[1.6.6](sec16.md)）。（✓ / △ / ×）
:::
**C9.** 写出偏置-方差分解的三项。
::: sol
$$\mathbb E_{S,\epsilon}\bigl[(y-\hat f_S(\boldsymbol x))^2\bigr]=\underbrace{\sigma^2}_{\text{不可约噪声}}+\underbrace{\bigl(\mathbb E_S[\hat f_S]-f^\star\bigr)^2}_{\text{偏置}^2}+\underbrace{\mathbb E_S\bigl[(\hat f_S-\mathbb E_S[\hat f_S])^2\bigr]}_{\text{方差}} .$$
高偏置 = 模型族太小（欠拟合）；高方差 = 对训练集噪声过度敏感（过拟合）（[定理 1.7.1](sec17.md#thm-1.7.1)）。（✓ / △ / ×）
:::
**C10.** 写出标签平滑的定义式，并说明它改变了什么。
::: sol
$y_c^{\text{LS}}=(1-\epsilon)\,\mathbf 1[c=c_{\text{true}}]+\dfrac{\epsilon}{C}$，$c=1,\dots,C$。它同时改变了 $H(p)$ 与最优解：给 logit 差距设了**有限的最优值**，因此既是正则手段、又会**降低概率校准质量**（蒸馏场景下可能反而不如不加平滑的老师）（[定义 1.4.4](sec14.md#def-1.4.4)）。（✓ / △ / ×）
:::
**C11.** 写出交叉熵与 KL 散度的关系式，并说明哪两种比较等价、哪一种不可比。
::: sol
$H(p,q)=\mathrm{KL}(p\|q)+H(p)$。目标分布固定（同一数据集）时 $H(p)$ 与参数无关，故「最小化交叉熵」与「最小化 KL」**训练中等价**；但**跨数据集比较交叉熵不可比**，因为 $H(p)$ 不同（[定理 1.4.3](sec14.md#thm-1.4.3)）。（✓ / △ / ×）
:::

## D. 陷阱卡（先指出错在哪，再给正确说法）

**D1.** 「单层网络换了 Sigmoid 就能解决 XOR」；「通用逼近定理说明大网络能拟合任何东西，所以建大一点就对了」。
::: sol
两处都错。① 单层的判决面仍是同一个超平面 $z=0$，能表达的函数族没变——换激活只让它**可以用梯度训练**，跨过能力边界要靠**分层**（[1.1.4](sec11.md)）。② 定理只说明**存在**这样的权重：宽度可能指数级（不可寻）、优化可能到不了（不可训）、样本可能不够（不保样本效率）；它给的是**能力下限**，不是设计目标（[1.2.3](sec12.md#sec-1.2.3)）。（✓ / △ / ×）
:::
**D2.** 「隐藏层用 Sigmoid 更『神经』，而且更光滑」；「ReLU 的稀疏性是天然优点，越稀疏越好」。
::: sol
两处都错。① 直接落进 $(1/4)^{L}$ 陷阱：$L=10$ 时梯度上界约 $9.5\times10^{-7}$；隐藏层默认 ReLU 族，Sigmoid 只用在需要 $(0,1)$ 输出的位置（二分类输出层、门控里的门）。② 负区输出为零意味着**该路径没有学到任何东西**，只有网络足够宽、且负区分布是数据驱动（而非初始化偏差导致）时，稀疏才无害（[1.3.8](sec13.md)）。（✓ / △ / ×）
:::
**D3.** 「网络里已经加了 `Softmax`，再接 `CrossEntropyLoss` 是标准做法」；「`BCELoss` 与 `BCEWithLogitsLoss` 随便用哪个都行」。
::: sol
两处都错。① `CrossEntropyLoss` 内部已含 `log_softmax`，等于做了**两次**归一化，梯度被额外雅可比改写，表现为收敛变慢、概率过自信；判据是检查喂进去的是 **logits** 还是概率。② `BCELoss` 期望**概率**（需先过 Sigmoid），`BCEWithLogitsLoss` 期望 **logits**；用 `BCELoss` 却喂 logits，梯度会在饱和区几乎消失（[1.4.10](sec14.md) 错误 1、7）。（✓ / △ / ×）
:::
**D4.** 「反向传播是一种近似方法，误差来自它本身」；「偏置的梯度就是 $\boldsymbol\delta^{(l)}$」。
::: sol
两处都错。① 它是链式法则的**精确**实现（沿计算图逆序执行 VJP），唯一近似之处是你是否用有限差分去**近似**它。② 批量下偏置被 $B$ 个样本**共享**，必须**沿批维求和**：$\partial\mathcal L/\partial\boldsymbol b^{(l)}=\sum_{i=1}^{B}\boldsymbol\delta^{(l)}_{i:}$，形状 $d_l$；直接写 $\boldsymbol\delta^{(l)}$ 会得到 $B\times d_l$（报错或静默广播放大 $B$ 倍）（[1.5.6](sec15.md) 错误 1、4）。（✓ / △ / ×）
:::
**D5.** 「`Adam(weight_decay=λ)` 就是 AdamW」；「加了动量，学习率不用动」。
::: sol
两处都错。① 前者是 **Adam + L2**，正则项被 $\sqrt{\hat v_t}$ 逐元素缩放，各坐标衰减强度依赖梯度历史；要解耦权重衰减必须用 `AdamW`。② 动量把有效步长放大约 $1/(1-\beta)=10$ 倍（$\beta=0.9$），不调小会直接发散（[1.6.9](sec16.md) 错误 1、2；[命题 1.6.1](sec16.md#prop-1.6.1)）。（✓ / △ / ×）
:::
**D6.** 「推理时 BatchNorm 用当前 batch 的均值与方差」；「Dropout 忘了 `eval()` 也没关系」。
::: sol
两处都错。推理时 BN 用训练期累积的 **running statistics**（否则 batch=1 时统计量无定义）；忘记 `model.eval()` 会让 Dropout 继续随机置零、BN 继续用当前批统计量，判据是**同一输入连续两次推理结果不同**（[定理 1.7.2](sec17.md#thm-1.7.2)、[1.7.8](sec17.md) 错误 3）。（✓ / △ / ×）
:::
**D7.** 「用验证集调参、再用验证集报结果」；「预处理放在划分之前做省事」。
::: sol
两处都错。① 反复用验证集选择 = 在验证集上过拟合，报告指标系统性偏高。② 预处理（标准化 / 特征选择 / 编码）在划分前拟合，是把验证集统计量**泄漏**进训练——这是最高频、最隐蔽的一处泄漏。正确做法：先划分，只在训练集 `fit`，最终报告用一次性测试集（[1.7.6 的数据泄漏清单](sec17.md)、[方法 1.7.2](sec17.md#method-1.7.2)）。（✓ / △ / ×）
:::

## 导出到 Anki / CSV

1. **建卡组**：打开 Anki → 新建卡组「DL-第 1 讲」，与「DL-全书」卡组并列（不要混在默认卡组里）。
2. **逐条录入**：正面放「编号 + 题干」，背面放「答案 + 依据」；纯文本批量导入时用 `Tab` 分隔「正面 / 背面」，一行一张卡（本页 40 张可按 A1–A12 / B1–B14 / C1–C11 / D1–D7 顺序录入）。
3. **复习节点（1 / 3 / 7 天）**：当天 → 隔天（第 1 天）→ 第 3 天 → 第 7 天，四轮；每轮只重做标 **△** 与 **×** 的卡。四轮后仍未「✓」的卡，抄进[勘误与补注](errata.md)第四节的待核实条目，作为个人薄弱点单独跟踪。
4. **加一道保险**：公式卡（C 组）背面附一张**手写照片**——公式打字的记忆强度低于手写。与[速查背记卡](../../memory-sheet.md)、[公式与结论卡](../../review/formula-cards.md)、[易混对照卡](../../review/contrast-cards.md)配合使用：本页负责**检索**，它们分别负责**压缩**、**收口**、**辨析**。
