# 4.2 自编码器：压缩，不是生成

[4.1](sec41.md)把生成建模的目标定成两件事：**给出密度（或相对分数）+ 从中采样**。这一节要先把最简单的一副骨架拆开——**自编码器**（autoencoder, AE）。它学得又快又稳、重建效果好得惊人，看起来「已经学会了这批数据」，却**不是一个生成模型**。

这不是历史八卦。AE 为什么不行，正好暴露了后面每一节都在修的那个缺口：**潜空间上没有概率结构**。VAE 给它补先验，GAN 绕过它，扩散干脆不压到潜空间里（而是让时间步充当那条「分层的潜空间」）。所以这一节是后面七节的诊断书。

本节要回答四个问题：AE 由什么组成、它到底在优化什么？重建误差低意味着什么、不意味着什么？为什么从 $\mathcal N(0,I)$ 采一个 $z$ 解码出来是垃圾？以及在普通 AE 上加正则（去噪、稀疏、收缩）能不能把它救成生成模型——答案是不能，但那些正则化 AE 已经在敲 VAE 的门了。

## 4.2.1 自编码器的结构：编码—解码与重建损失

::: def 定义 4.2.1 · 自编码器（autoencoder） {#def-4.2.1}
自编码器由两部分组成：**编码器**（encoder）把数据压成低维潜码，**解码器**（decoder）再把它还原回数据空间：

$$z=f_\phi(\boldsymbol x)\quad(\text{编码}),\qquad \hat{\boldsymbol x}=g_\theta(z)\quad(\text{解码}),$$

其中 $\boldsymbol x\in\mathbb R^D$、$z\in\mathbb R^d$（通常 $d\ll D$）。训练只用一个**重建损失**让输出逼近输入：

$$\mathcal L_{\mathrm{AE}}(\theta,\phi)=\mathbb E_{\boldsymbol x\sim p_{\text{data}}}\bigl[\lVert\boldsymbol x-g_\theta(f_\phi(\boldsymbol x))\rVert_2^2\bigr].$$

连续数值（归一化后的像素、动作量、传感器读数）用均方误差；二值像素或计数数据改用逐元素交叉熵 / 泊松损失——**损失必须与数据类型的似然函数对应**（这一点在 [4.3](sec43.md) 会用「高斯解码器」的说法重新出现）。
:::

::: intuition AE 是一台有损压缩器，不是一个概率模型
把 $f_\phi$ 想成「把一本书缩写成一张便签」，$g_\theta$ 想成「照便签把书重写出来」。训练的唯一要求是**重写结果像原书**。为了在 $d\ll D$ 的约束下做到这一点，模型必须自己发现「书里哪些内容重要」——这就是 AE 的价值：**表示学习**（降维、去噪、特征提取）与**数据压缩**，而非生成。

注意这里的措辞：AE 从来**没有**被要求说清「一张合法便签长什么样」。它只被要求「给定原书，写出能还原的便签」。**训练信号只覆盖了真实数据的像**，潜空间的其余部分是无人区——这是下一节所有麻烦的根。
:::

### 4.2.1.1 线性 AE 学到的是 PCA {#sec-4.2.1.1}

在深入「不能生成」之前，先看一个能算清的例子。它给出两个收益：一是 AE 的优化目标确实在压缩信息，二是「潜空间没有被规定分布」这件事在数学上有多直白。

::: prop 命题 4.2.1 · 线性自编码器的最优解与 PCA 同子空间 {#prop-4.2.1}
设编码器与解码器均为线性映射 $f_\phi(\boldsymbol x)=\boldsymbol xW$（$W\in\mathbb R^{D\times d}$）、$g_\theta(z)=zV^{\mathrm T}$（$V\in\mathbb R^{D\times d}$），数据已中心化（$\mathbb E[\boldsymbol x]=\mathbf 0$）且协方差 $\Sigma=\mathbb E[\boldsymbol x\boldsymbol x^{\mathrm T}]$。则

$$\min_{W,V}\ \mathbb E\bigl[\lVert\boldsymbol x-\boldsymbol xWV^{\mathrm T}\rVert_2^2\bigr]\quad\text{的最优解满足：}\ \operatorname{span}(V)=\operatorname{span}\bigl(\boldsymbol u_1,\dots,\boldsymbol u_d\bigr),$$

其中 $\boldsymbol u_1,\dots,\boldsymbol u_d$ 是 $\Sigma$ 的最大 $d$ 个特征值对应的特征向量。**即：线性 AE 的最优解张成与 PCA 主成分相同的子空间**（差别只在于 $W,V$ 的尺度如何分摊，即解不唯一）。
:::

::: proof 推导（把问题化成一个投影）
记复合映射 $P=WV^{\mathrm T}\in\mathbb R^{D\times D}$。因为 $W$ 的形状是 $D\times d$、$V$ 的形状是 $D\times d$，乘积 $WV^{\mathrm T}$ 的秩不超过 $d$，所以目标函数等价于

$$\min_{P:\ \operatorname{rank}(P)\le d}\ \mathbb E\bigl[\lVert\boldsymbol x-P\boldsymbol x\rVert_2^2\bigr].$$

**第一步：最优 $P$ 必为到某个 $d$ 维子空间的正交投影。** 展开目标：
$$\mathbb E\lVert\boldsymbol x-P\boldsymbol x\rVert^2=\operatorname{tr}\bigl((I-P)\Sigma(I-P)^{\mathrm T}\bigr)=\operatorname{tr}\bigl(\Sigma(I-P)^{\mathrm T}(I-P)\bigr).$$
固定 $P$ 的像空间 $\mathcal S=\operatorname{Im}(P)$，$\operatorname{tr}\bigl(\Sigma(I-P)^{\mathrm T}(I-P)\bigr)\ge\operatorname{tr}\bigl(\Sigma(I-\Pi_{\mathcal S})^{\mathrm T}(I-\Pi_{\mathcal S})\bigr)$，其中 $\Pi_{\mathcal S}$ 是到 $\mathcal S$ 的正交投影——因为投影算子在所有「像含于 $\mathcal S$」的算子中使 $(I-P)^{\mathrm T}(I-P)$ 在 $\Sigma$ 下最小（残差的范数下界由正交分解给出）。于是问题化为

$$\min_{\dim\mathcal S=d}\ \mathbb E\bigl[\lVert\boldsymbol x-\Pi_{\mathcal S}\boldsymbol x\rVert_2^2\bigr]=\min_{\dim\mathcal S=d}\Bigl(\operatorname{tr}\Sigma-\sum_{j=1}^{d}\boldsymbol v_j^{\mathrm T}\Sigma\boldsymbol v_j\Bigr),$$
其中 $\{\boldsymbol v_j\}$ 是 $\mathcal S$ 的任意标准正交基。

**第二步：最大化瑞利和即取最大特征方向。** 上式等价于在标准正交约束下最大化 $\sum_{j=1}^{d}\boldsymbol v_j^{\mathrm T}\Sigma\boldsymbol v_j$，这正是 Ky Fan 定理的结论：最优值等于 $\Sigma$ 的前 $d$ 大特征值之和，取到它的子空间由对应特征向量张成。$\blacksquare$
:::

::: intuition 这个命题的两层意思
**第一层（好消息）**：AE 的压缩确实是「有信息论意义」的压缩——线性情形下它精确地找到了方差最大的方向，和 PCA 一致。这也解释了为什么实践中拿 AE 的潜码做下游任务常常有效。

**第二层（坏消息）**：命题里的解**不唯一**（$W,V$ 可以互相乘一个可逆矩阵而不改变 $P$）。在深度非线性情形下，这种不唯一性会变得更糟：网络可以在潜空间上施加任意光滑可逆变换而不改变重建误差。**这直接说明「潜空间坐标系」没有一个被目标函数钉住的标准形态**——因此也不存在一个「自然的」先验分布可以从它采样。想让 $z$ 上的分布有意义，必须**在损失里显式写出来**，这正是 [4.3](sec43.md) 要加的 KL 项。
:::

## 4.2.2 瓶颈与信息压缩

::: thm 定理 4.2.1 · 瓶颈约束蕴含「信息压缩」 {#thm-4.2.1}
设编码器 $f:\mathcal X\subseteq\mathbb R^D\to\mathcal Z\subseteq\mathbb R^d$ 满足以下**任一**条件：

1. **维数瓶颈**：$f$ 局部 Lipschitz 连续，且 $\mathcal Z$ 是 $d$ 维（$d\lt D$）的光滑子流形；
2. **量化瓶颈**：$f$ 的取值被量化到有限集合（如 $d$ 个坐标各 $K$ 档，共 $K^d$ 个码字）。

则：（i）在情形 1 下，$f(\mathcal X)$ 的 $d$ 维 Lebesgue 测度为零，即 $f$ 不可能「保住」目标集的体积，重建必然有损；（ii）在情形 2 下，$f$ 的像至多含 $K^d$ 个不同码，若 $|\mathcal X|$（或数据分布的有效支撑的度量）超过 $K^d$，则**存在两个不同数据被压成同一码**，即信息损失不可避免。
:::

::: intuition 瓶颈就是「预算」
这个结论几乎是废话，但它有一个容易被忽略的推论：**「重建误差低」与「信息保真」不是同一件事**。

- 在维数瓶颈下，编码器可以在数据支撑上近乎完美地重建（数据点都落在一个 $d$ 维流形附近时，$f$ 可以是单射），但**潜空间的绝大部分区域从没被训练过**——解码器在那里是任意外推。
- 在量化瓶颈下，误差必然存在，但只要码本足够大就能压到很小。VAE 的连续潜空间在数值精度上也是一种「量化到 float32」的情形，所以这条在实践里意味着：**潜空间被「用满」的区域只占极小一部分体积**。

所以判据不是「重建好不好」，而是**「从先验采出的点落在哪里」**。[4.2.3](#sec-4.2.3) 给出这条判据的定量版本。
:::

## 4.2.3 为什么 AE 不能当生成模型 {#sec-4.2.3}

理由可以压缩成一句话：**采样需要在潜空间上有一个已知分布，而 AE 从未定义过它**。但这句话背后的机制值得写清楚，因为每一个机制在后面都对应一节的修补方案。

::: prop 命题 4.2.2 · 潜空间「空洞」与采样落点 {#prop-4.2.2}
设 AE 已训练到重建误差很小，记训练数据在潜空间的像为 $\mathcal M=\{f_\phi(\boldsymbol x):\boldsymbol x\in\operatorname{supp}(p_{\text{data}})\}$，并设：

1. **潜空间无先验**：模型输出里没有任何关于 $z$ 的分布约定，先验「$\mathcal N(0,I)$」纯属外部假设；
2. **$\mathcal M$ 是高 d 维流形上的低维子集**（例如数据含 $K$ 个明显模态时，$\mathcal M$ 可能聚成 $K$ 个孤立团），而先验质量在整个 $\mathbb R^d$ 上连续铺开。

则：从 $p(z)=\mathcal N(0,I)$ 采出的 $z$ 落在 $\mathcal M$ 之外的相对体积为 $1$（因为 $\mathcal M$ 的 $d$ 维体积为零），解码器在这些位置的行为**完全由外推决定**，不受重建损失约束。
:::

::: intuition 「无分布」「不连续」「敏感」三件事
- **无分布可采**：采样是「先按某个已知分布取 $z$，再解码」。AE 定义了第二步，却没定义第一步。没有第一步，就没有样本来源。
- **空洞**：即使数据在真实世界里连续（比如所有人脸的连续变化），训练信号也只覆盖**出现过的那些点**的像。让潜空间「填满」，需要额外一项损失去逼它——这是 VAE 的 KL 项干的活。
- **对 $z$ 的敏感**：把某一个潜维从 $1.5$ 挪到 $1.6$，解码结果可能从「像一张脸」跳到「像一团糊」。因为在这段距离里，解码器从没被训练过，网络内部的插值不受任何约束。

**一句话**：AE 学到的是一张**只在对数据有效的窄带上成立的编码—解码表**，而不是覆盖整个潜空间的概率模型。生成需要后者。
:::

::: think 三条常见的「抢救」路线，分别为什么不够
1. **「那就从训练集的潜码上加噪声再解码」**：加多大噪声？没有原则。噪声小 → 仍只在团的内部打转，多样性不足；噪声大 → 落到空洞里，样本崩坏。**噪声尺度要靠试**，这本身就是「缺少一个先验」的症状。（这条路线的一个正规化版本恰恰是 VAE：用 KL 项自动决定每个坐标上应有多大的方差）
2. **「用 $k$ 近邻在潜空间做插值」**：这只在**训练样本之间**做插值，本质上是在插值数据而不是在采样分布；它永远无法走到训练集支撑之外，也就不可能生成「新类别」的组合。
3. **「加正则让它连续」**：正则化 AE（去噪、稀疏、收缩）确实改善了局部连续性与抗噪性（[4.2.4](#sec-4.2.4)），但它们改变的是**编码器的性质**，仍然没有回答「$z$ 服从什么分布」。
:::

## 4.2.4 正则化 AE：通往 VAE 的过渡

在 VAE 出现前后，有一族「给 AE 加正则」的做法，它们各自解决了一部分问题。理解它们的**动机**，比记住名字更重要——VAE 的每一项损失都能在这族方法里找到对应物。

| 变体 | 加的约束 | 病，治好了没有 | 与 VAE 的关系 |
|:--|:--|:--|:--|
| **欠完备 AE** | $d\lt D$，纯瓶颈 | 只保住了表示，没管潜空间结构 | 无 |
| **去噪 AE（DAE）** | 输入加噪 $T(\tilde{\boldsymbol x}\mid\boldsymbol x)$，重建**干净**的 $\boldsymbol x$ | 局部鲁棒性与流形附近的连续性变好 | 数据增广版的「重建项」，同样的思想在 [4.5](sec45.md) 变成加噪过程 |
| **稀疏 AE** | 加 $\lVert f_\phi(\boldsymbol x)\rVert_1$（或 KL 稀疏惩罚），逼迫只有少数单元激活 | 表示更可解释、更接近「特征」 | 相当于给潜变量一个**稀疏先验**（拉普拉斯类），是「先验」概念的前身 |
| **收缩 AE（CAE）** | 惩罚编码器雅可比 $\lVert\partial f_\phi/\partial\boldsymbol x\rVert_F^2$ | 让 $f$ 局部更平滑，抑制对输入的敏感 | 直接对「潜空间几何」动手；VAE 用 KL 从统计侧达到类似目的 |
| **VQ-VAE** | 潜码量化到有限码本 | 得到离散表示，配合自回归先验可做生成 | 用**学习到的离散先验**替代 $\mathcal N(0,I)$（见 [4.7](sec47.md)） |

::: method 去噪 AE 与「分数」的联系（只给结论，推导见 4.5 的旁注） {#method-4.2.1}
给数据加小高斯噪声 $\tilde{\boldsymbol x}=\boldsymbol x+\sigma\boldsymbol\epsilon$，并以**平方误差**训练网络从 $\tilde{\boldsymbol x}$ 预测 $\boldsymbol x$（即预测噪声 $\boldsymbol\epsilon$）。在 $\sigma\to0$ 的极限下，最优解满足

$$\hat{\boldsymbol x}(\tilde{\boldsymbol x})=\tilde{\boldsymbol x}+\sigma^2\nabla_{\tilde{\boldsymbol x}}\log p_\sigma(\tilde{\boldsymbol x}),$$

即**最优去噪器把「加噪样本」沿对数密度的梯度方向推回高密度区**。这就是扩散模型（[4.5](sec45.md)）与得分匹配（[4.1](sec41.md)）之间的桥：**去噪任务本身就在估计分布的对数梯度**。
:::

::: intuition 为什么「去噪」比「重建」更接近生成
重建任务可以偷懒：只要把输入抄到输出，损失就是零——**恒等映射是重建问题的一个平凡最优解**（这也是为什么必须加瓶颈，否则 AE 会退化成 $g\circ f=\mathrm{id}$）。去噪任务偷不了懒：输入本身被污染了，抄输出必然带着噪声。网络必须学会「**什么内容属于数据流形**」，才能把噪声成分去掉。这个「什么属于数据流形」的知识，恰恰是采样时需要的知识——所以 DAE 已经在做生成建模的核心工作了，只是它**仍然没有给出一个可以采样的潜空间或分布**。
:::

## 4.2.5 形状与参数量表

以 MNIST（$28\times28$ 灰度）上的一个标准全连接 AE 为例，逐层写出形状与参数量。批大小 $B=64$，潜维 $d=16$：

<table class="shape-table">
<thead><tr><th>层</th><th>运算</th><th>输出形状</th><th>参数量</th></tr></thead>
<tbody>
<tr><td>输入</td><td>—</td><td>$64\times1\times28\times28$</td><td>$0$</td></tr>
<tr><td>Flatten</td><td>展平（不产生参数）</td><td>$64\times784$</td><td>$0$</td></tr>
<tr><td>编码器 Linear 1</td><td>$\boldsymbol h_1=\mathrm{ReLU}(\boldsymbol xW_1+\boldsymbol b_1)$</td><td>$64\times256$</td><td>$784\times256+256=200{,}960$</td></tr>
<tr><td>编码器 Linear 2</td><td>$z=\boldsymbol h_1W_2+\boldsymbol b_2$（**不加激活**）</td><td>$64\times16$</td><td>$256\times16+16=4{,}112$</td></tr>
<tr><td>解码器 Linear 3</td><td>$\boldsymbol h_3=\mathrm{ReLU}(zW_3+\boldsymbol b_3)$</td><td>$64\times256$</td><td>$16\times256+256=4{,}352$</td></tr>
<tr><td>解码器 Linear 4</td><td>$\hat{\boldsymbol x}=\sigma(z_3)$（Sigmoid 到 $[0,1]$）</td><td>$64\times784$</td><td>$256\times784+784=201{,}488$</td></tr>
<tr><td>—</td><td>总参数量 $P$</td><td>—</td><td>$410{,}912$</td></tr>
</tbody>
</table>

三条读表要点：① **潜层不加激活**，否则 $z$ 的取值范围被压进 $(-1,1)$ 等区间，重建端要花容量去补偿；② 编解码器**对称**只是惯例，不对称完全合法（现代 LDM 的潜空间编码器就是不对称的，见 [4.6](sec46.md)）；③ 参数量与批大小无关（[第 1 讲](../lec01/sec12.md)的结论在这里照样成立），批大小只影响激活的显存。

::: ex 例 4.2.1 · 数一遍参数量与压缩率 {#ex-4.2.1}
用上表结构，回答三问：(a) 编码器的参数量是多少？(b) 潜码相对原始输入的**数值**压缩率是多少？(c) 如果把这套 AE 用在 $256\times256\times3$ 的彩色图上、并保持潜维 $d=16$，Encoder 第一层的参数量会变成多少？说明了什么工程后果？

::: proof 解
**(a)** 编码器 = Linear 1 + Linear 2：$200{,}960+4{,}112=205{,}072$。

**(b)** 输入是 $784$ 个 float32（$784\times4=3136$ 字节），潜码是 $16$ 个 float32（$64$ 字节），**数值压缩率** $=784/16=49$ 倍（按字节算也是 49 倍，因为精度相同）。但要注意：这个「压缩率」不包含解码器参数本身的开销——**存储数据**省了，**存储模型**没省。

**(c)** 第一层输入维度变成 $256\times256\times3=196{,}608$，取第一隐藏层 $256$ 维，则参数量为
$$196{,}608\times256+256=50{,}331{,}904\approx5.03\times10^{7}.$$
仅**一层**就五千万参数，而整个 $28\times28$ 版 AE 才 41 万参数。**后果**：全连接 AE 在图像上不可扩展——它既丢掉了平移等变性（[第 3 讲](../lec03/sec31.md)），又让参数量与像素数成正比。这就是 4.6 的 LDM 必须用**卷积自编码器**（且先下采样 8 倍）来构造潜空间的原因。$\blacksquare$
:::
:::

## 4.2.6 代码：AE、DAE 与「采样失败」的实测

```python
import torch, torch.nn as nn, torch.nn.functional as F

class AE(nn.Module):
    """一个最简全连接自编码器；decoder 与 encoder 对称。"""
    def __init__(self, D=784, d=16):
        super().__init__()
        self.enc = nn.Sequential(nn.Linear(D, 256), nn.ReLU(), nn.Linear(256, d))       # 潜层不加激活
        self.dec = nn.Sequential(nn.Linear(d, 256), nn.ReLU(), nn.Linear(256, D), nn.Sigmoid())  # 输出归到 [0,1]

    def forward(self, x):
        z = self.enc(x)          # (B, 784) -> (B, 16)
        return self.dec(z), z    # 返回潜码，便于后面做诊断

def train_ae(model, loader, steps=2000, lr=1e-3, denoise_sigma=0.0):
    opt = torch.optim.Adam(model.parameters(), lr=lr)
    it = iter(loader)
    for _ in range(steps):
        try:
            x, _ = next(it)
        except StopIteration:
            it = iter(loader); x, _ = next(it)
        x = x.view(x.size(0), -1)                      # (B, 784)
        if denoise_sigma > 0:                          # 去噪 AE：输入被污染，目标仍用干净的 x
            x_in = (x + denoise_sigma * torch.randn_like(x)).clamp(0, 1)
        else:
            x_in = x
        x_hat, _ = model(x_in)
        loss = F.mse_loss(x_hat, x)                    # 注意：DAE 的重建目标必须是干净输入
        opt.zero_grad(); loss.backward(); opt.step()
    return model

# ---- 诊断一：先在真实数据上看重建（应当很好） ----
# x_hat, z = model(x); print(F.mse_loss(x_hat, x).item())

# ---- 诊断二：再从「先验」采样并解码（应当很差） ----
@torch.no_grad()
def sample_from_prior(model, n=16, d=16):
    """按 VAE 的采样方式对待 AE：从 N(0, I) 取 z，再解码。
    预期结果：多数样本是无意义的糊团——这正是「AE 不是生成模型」的实测证据。"""
    z_prior = torch.randn(n, d)
    return model.dec(z_prior)

# ---- 诊断三：量一量潜码与先验的「距离」 ----
@torch.no_grad()
def latent_stats(model, loader, n=2048):
    """统计训练数据潜码的均值/方差与先验 N(0,I) 的差距：
    均值范数越大、各维方差与 1 差得越远，说明可采样性越差。"""
    xs = []
    for x, _ in loader:
        z = model.enc(x.view(x.size(0), -1))
        xs.append(z)
        if sum(t.size(0) for t in xs) >= n:
            break
    Z = torch.cat(xs)[:n]
    return Z.mean(0).norm().item(), Z.var(0)

# 判据（可直接作为实验验收标准）：
#   AE      : 重建 MSE 很低，但 latent_stats 的均值范数明显 > 0、方差远离 1，采样图糊
#   DAE     : 重建略变差，潜码分布更「平滑」，但均值范数与方差仍不受约束
#   VAE(4.3): 重建略变差，latent_stats 的均值范数接近 0、方差接近 1，采样图可辨识
```

::: method 三步诊断法：判断一个潜空间是否「可采样」 {#method-4.2.2}
1. **重建基线**：在验证集上算重建 MSE（或 PSNR）。这一步只证明编码—解码表有效，与生成能力无关。
2. **潜码统计**：算训练集潜码的均值范数 $\lVert\bar z\rVert_2$ 与逐维方差。若均值范数显著大于 0、或某几维方差远小于 1，则从 $\mathcal N(0,I)$ 采样的点会落到训练从未覆盖的区域——**先验与后验错位**。（VAE 的 KL 项会把这两项分别拉向 $0$ 与 $1$）
3. **采样对照**：分别从 $\mathcal N(0,I)$ 采样与从「训练潜码 + 小噪声」采样，人眼看两组样本的差距。**差距越大，先验错位越严重**。这条也是后面判断 VAE 是否后验坍塌（[4.3.5](sec43.md)）的同一把尺子。
:::

::: errata 本节五个高频误解
1. **「重建损失很低说明模型学会了分布」**：重建只约束了**数据点上的像**，对潜空间的其余部分没有任何约束（[命题 4.2.2](#prop-4.2.2)）。
2. **「潜维越小越好（压缩率越高越好）」**：潜维过小时编码器被迫做有损压缩，重建误差上限被卡住；同时欠训练时 AE 可能退化成「恒等映射 + 瓶颈处随机丢弃」——**瓶颈太小会隐藏 bug 而不是暴露 bug**。
3. **「把 AE 的潜码当 GAN / 扩散的条件就够了，不用管先验」**：如果潜码只作为**条件特征**（例如 ControlNet 式的条件注入），这句话成立；但若要让潜码本身承担**采样起点**的角色，就必须规定它的分布。区分这两种用法是 [4.6](sec46.md) 读懂 LDM 的关键。
4. **「去噪 AE 就是 VAE」**：DAE 只有重建项、没有 KL（或等价的先验项），因此它仍然没有可采样的潜空间。它和 VAE 的相似之处在于「都引入了随机性」，区别在于**随机性加在输入上（数据侧）还是加在潜码上（隐变量侧）**。
5. **「线性 AE 与 PCA 等价，所以 AE 就是 PCA 的非线性版，已经够用」**：命题 4.2.1 只说明最优**子空间**一致；PCA 无法表达「数据分布的形状」（它是二阶统计量），而生成需要的是完整分布。非线性 AE 也继承了这一局限。
:::

::: method 即时自测 · 4.2
**Q1** 写出 AE 的编码—解码公式与重建损失；说明为什么潜层通常**不加**激活函数。

**Q2** 一个 AE 在验证集上的重建 MSE 是 $0.003$（很理想）。列出三条「这不能证明它可以生成」的理由。

**Q3** 描述一个具体操作，能定量判断「某 AE 的潜空间是否可采样」。你会看哪两个数字？

**Q4** 为什么「无瓶颈的全连接 AE」会退化成恒等映射？这对训练结果有什么实际危害？

::: sol 参考要点
**Q1** $z=f_\phi(\boldsymbol x)$、$\hat{\boldsymbol x}=g_\theta(z)$，$\mathcal L=\mathbb E\lVert\boldsymbol x-g_\theta(f_\phi(\boldsymbol x))\rVert_2^2$（连续数据）或逐元素交叉熵（二值 / 计数数据）。潜层不加激活是因为加激活会把 $z$ 限制在某个有界区间（如 Sigmoid 的 $(0,1)$），而高斯先验 $\mathcal N(0,I)$ 的支撑是整个 $\mathbb R^d$——一旦潜码被限制在紧集内，先验与该集合的错配会进一步加重；此外不加激活可以让潜码保持零均值、单位方差的可能（VAE 的 KL 项正依赖这一点）。

**Q2** （任意三条）① 重建只约束了训练数据点的像，潜空间其余部分无约束（[命题 4.2.2](#prop-4.2.2)）；② 潜空间没有先验分布，无法定义「采样起点」；③ 潜空间的解不唯一（[命题 4.2.1](#prop-4.2.1)），坐标系没有标准形态；④ 低重建误差还有一个廉价来源——模型容量过剩时把训练样本近似记住（记忆而非泛化）；⑤ 没有测量潜码与 $\mathcal N(0,I)$ 的错位程度。

**Q3** 算**训练集潜码的均值范数** $\lVert\bar z\rVert_2$（理想接近 0）与**逐维方差**（理想接近 1）；再补一个操作：分别从 $\mathcal N(0,I)$ 与「训练潜码 + 小噪声」采样并解码，做 A/B 盲看对比。均值范数大或方差严重偏离 1，就说明先验与后验错位。

**Q4** 若 $d\ge D$，令 $f,g$ 都为线性且 $g=f^{-1}$ 型可逆映射，则恒等映射 $g(f(\boldsymbol x))=\boldsymbol x$ 使损失为 $0$，是全局最优解。危害：损失曲线看起来完美（逼近 0），但潜码维数与输入同阶，**没有学到任何压缩与抽象**；下游用这个潜码做特征反而等价于原始输入，还多背了一份参数。判据是「参数少、损失低、但下游任务不比原始输入好」。
:::
:::

::: note[skip] 延伸阅读
- Hinton & Salakhutdinov, *Reducing the Dimensionality of Data with Neural Networks*（Science 313:504, 2006）——深度 AE 的里程碑论文（**无 arXiv 编号**，可引 Science 卷期），实验上证明逐层预训练能让深层 AE 超过 PCA。
- Vincent et al., *Extracting and Composing Robust Features with Denoising Autoencoders*（ICML 2008，arXiv:1206.6398 收录于该合辑）——去噪 AE 的原始论文；与本节 [4.2.4](#sec-4.2.4) 的「分数」结论相关。
- Kingma & Welling, *Auto-Encoding Variational Bayes*（2013，arXiv:1312.6114）——下一节要精读的 VAE 论文；读它时留意作者如何用一句话把「加噪声」从输入侧搬到潜码侧。
- Vincent et al., *Stacked Denoising Autoencoders*（2010，JMLR 11:3371–3408）——堆叠去噪 AE 的完整实践，适合想看「正则化 AE 谱系」的读者。
- Eckart & Young, *The Approximation of One Matrix by Another of Lower Rank*（Psychometrika 1:211, 1936）——命题 4.2.1 用到的低秩逼近定理原始出处（**无 arXiv**）；想补 PCA 的最优性证明可从这里入手。
:::

**本节小结**：自编码器 = 编码 + 解码 + 重建损失，价值在**表示学习与压缩**，不在生成。线性情形的解与 PCA 同子空间（[命题 4.2.1](#prop-4.2.1)），但解不唯一——潜空间坐标系没有被目标函数钉住。瓶颈约束保证信息必然有损（[定理 4.2.1](#thm-4.2.1)），而**重建误差低只说明「数据点的像」被覆盖**；潜空间的其余部分是无人区，从 $\mathcal N(0,I)$ 采样会落在那里，解码出无意义结果（[命题 4.2.2](#prop-4.2.2)）。去噪、稀疏、收缩这些正则化 AE 改善的是编码器的局部性质，仍未回答「$z$ 服从什么分布」。当然，去噪 AE 已经暴露了一个重要线索：**去噪任务在对数密度的梯度方向上工作**——这条线索会直接长成 [4.5](sec45.md) 的扩散模型，也会在下一节以 KL 项的形式第一次被写进损失函数。

下一节给潜空间补上缺失的那一半：先验、变分下界与重参数化。
