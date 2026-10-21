# 4.7 离散与自回归生成：VQ 家族与视觉自回归

[4.6](sec46.md)解决的是「坐标系与路径」的问题；这一节换一个更根本的问题：**用什么表示来承载生成**。

前面所有模型都用**连续**潜变量（$z\in\mathbb R^d$）或连续像素。但语言模型给了一个极强的示范：把数据切成**离散 token**，用「预测下一个 token」的自回归分解 $\log p(\boldsymbol x)=\sum_t\log p(x_t\mid \boldsymbol x_{<t})$，就能把一整套成熟的架构（Transformer）、训练目标（交叉熵）、推理技巧（采样温度、KV cache）直接搬过来。图像能不能也这样？答案是可以，但需要先解决一个前提：**图像是连续的，必须先把它变成离散 token**。

于是这条路线分成两半：**离散化**（VQ-VAE → VQGAN → FSQ：怎么把一张图变成一串整数）与**建模**（自回归：怎么在这串整数上做「预测下一个」）。本节把两半拆开讲清楚，并回答三个常被混淆的问题：直通估计量到底在估什么？FSQ 为什么能绕开代码本学习？next-scale prediction 为什么优于光栅扫描？

## 4.7.1 为什么要离散表示

::: def 定义 4.7.1 · 离散潜变量与代码本（codebook） {#def-4.7.1}
**离散表示**：把数据 $\boldsymbol x$ 编码成**有限集合**中的一串符号
$$\boldsymbol x\ \longmapsto\ (c_1,c_2,\dots,c_N),\qquad c_i\in\{1,2,\dots,K\},$$
其中 $K$ 是**代码本大小**（vocabulary size），$N$ 是 token 数（序列长度）。

**代码本**：一组可学习的向量 $\{e_1,\dots,e_K\}\subset\mathbb R^d$，$e_k$ 是第 $k$ 个「码字」（codeword）。编码器的连续输出 $z_e$ 被量化成**最近码字**
$$c=\operatorname*{arg\,min}_{k\in\{1,\dots,K\}}\ \lVert z_e-e_k\rVert_2,\qquad z_q=e_c .$$
:::

::: intuition 离散化的三个收益
**第一，接口统一**。一旦数据变成整数序列，生成问题就变成了**语言建模问题**：可以用同一个 Transformer、同一套交叉熵、同一套采样方法处理图像、音频、动作，甚至让一个模型同时生成多种模态（把它们的 token 交替排成一条序列）。多模态大模型能「统一 token 空间」的工程前提就在这里。

**第二，建模目标变成分类而不是回归**。自回归预测一个**类别分布**（$K$ 类的 softmax），而不是回归一个连续值。分类目标天然表达**多模态**：下一个 token 可以是 $A$ 也可以是 $B$，概率各半；而回归目标会把 $A$ 与 $B$ **平均**成一个既不真也不像的中间值（[4.1](sec41.md) 的「似然—质量错位」与 [4.6.5](sec46.md) 的「边缘速度场抹平模态」是同一现象的不同侧面）。

**第三，压缩与接口分离**。编码器负责「把感知上重要的信息压进有限 token」，自回归模型只负责「学 token 序列的分布」。两段可以**分别迭代**：换更强的编码器不需要重训生成器；换更大的生成模型不需要重训编码器。

**代价也要说清**：量化是**有损**的，且损失不可微——这带来两个技术麻烦：梯度怎么穿过去（直通估计量），以及代码本怎么不塌（commitment loss，以及后来的 FSQ 干脆绕开它）。
:::

## 4.7.2 VQ-VAE：量化、直通估计量与 commitment loss {#sec-4.7.2}

::: def 定义 4.7.2 · VQ-VAE 的损失与直通估计量 {#def-4.7.2}
VQ-VAE = 编码器 $\mathcal E$ + 代码本 $\{e_k\}_{k=1}^{K}$ + 解码器 $\mathcal D$。总损失由三项组成
$$\mathcal L=\underbrace{\lVert\boldsymbol x-\mathcal D(z_q)\rVert_2^2}_{\text{重建}}+\underbrace{\lVert\operatorname{sg}[z_e]-e_c\rVert_2^2}_{\text{代码本损失}}+\underbrace{\beta\lVert z_e-\operatorname{sg}[e_c]\rVert_2^2}_{\text{commitment loss}},$$
其中 $\operatorname{sg}[\cdot]$ 是**停止梯度**算子（stop-gradient，前向等同恒等、反向梯度为零），$z_q=e_c$。

**直通估计量（straight-through estimator, STE）**：量化的前向是 $z_q=e_c$（查表），反向让梯度**直接穿过去**：
$$\text{前向：}\ z_q=e_c,\qquad\text{反向：}\ \frac{\partial\mathcal L}{\partial z_e}\ \approx\ \frac{\partial\mathcal L}{\partial z_q}.$$
Python/PyTorch 的等价写法是 `z_q = z_e + (e_c - z_e).detach()`。
:::

::: proof 三项损失的来路（每一项在推谁）
**（i）重建项**约束编码器与解码器合作：$\mathcal D(z_q)$ 要还原 $\boldsymbol x$。梯度经 STE 传到编码器。

**（ii）代码本损失** $\lVert\operatorname{sg}[z_e]-e_c\rVert_2^2$ 只更新**码字** $e_c$（$\operatorname{sg}$ 让编码器侧不动）：把被选中的码字朝「分配给它的那些 $z_e$」移动。它的作用是把「码字」变成对应簇的**质心**——这一步等价于在做**在线 k-means**：给定当前的分配（由最近邻决定），最小化聚类平方误差的变量就是质心。

**（iii）commitment loss** $\beta\lVert z_e-\operatorname{sg}[e_c]\rVert_2^2$ 只更新**编码器**（$\operatorname{sg}$ 让码字侧不动）：把编码输出**拉向**它被分配到的码字。它为什么必要？因为若只有第 (ii) 项，编码器可以自由地「到处乱跑」——它总能找到最近的码字，因此**编码空间可以持续扩张、在码字之间来回跳跃**，而代码本的更新永远追不上。commitment 项给编码器加上「不要离你的码字太远」的惩罚，从而稳定训练。

**（iv）为什么需要 STE。** 量化操作 $z_e\mapsto e_c$ 是**分段常数**函数：它对 $z_e$ 的导数几乎处处为 $0$（只在边界处不可导）。若如实使用这个导数，编码器**收不到任何梯度**。STE 的策略是：前向如实做量化（保真），反向假装它是恒等映射（$\partial z_q/\partial z_e\approx I$）。这样编码器收到的梯度信号是「如果 $z_e$ 能更靠近解码器想要的点，就朝那个方向走」——它**有偏**（真实导数是 0），但在实践中极其有效，是 VQ 家族能训练的根本原因。$\blacksquare$
:::

::: intuition 把「量化」想成一场 k-means
把编码器的输出看成 $N$ 个点，把代码本看成 $K$ 个簇心。训练过程可以读成：

1. **分配**（前向）：每个点归给最近的簇心（这就是「量化」）；
2. **更新簇心**（代码本损失）：把簇心挪向它所辖点的均值；
3. **拉扯点**（commitment loss）：把点拉向它的簇心，避免点漂得太远。

这三条合起来就是**在线 k-means** 的完整循环，只不过「点从哪里来」由编码器决定，而编码器本身也在被重建损失优化——所以这是一个**同时优化表示与聚类的联合问题**。这也解释了 VQ-VAE 的两个常见病：**代码本利用率低**（很多簇心从没被分配过点 → 死码字）与**码字塌缩**（少数簇心吞掉所有点 → 表示退化成常数）。二者都是这场 k-means 没收敛好的表征。
:::

::: ex 例 4.7.1 · 数一遍 VQ-VAE 的参数量与代码本规模 {#ex-4.7.1}
配置：输入 $256\times256\times3$；编码器 4 级下采样（每级空间减半、通道翻倍），输出 $16\times16\times d$，$d=64$；代码本 $K=512$ 个 $d$ 维码字；解码器与编码器镜像。求：(a) 潜码张量的形状与代码本参数量；(b) 若把每个潜码位置看作一个 token，序列长度 $N$ 是多少、序列的**比特率**是多少（每张图的离散信息量）；(c) 与位图压缩率相比，这个 token 表示「压缩」了多少。

::: proof 解
**(a)** 空间尺寸：$256\to128\to64\to32\to16$，故潜码特征图是 $16\times16\times64$。若取每个空间位置的 64 维向量量化成一个码字，则该位置的**索引**是一个 $0\sim511$ 的整数。
代码本参数量 $=K\cdot d=512\times64=32{,}768$。**注意这个规模远小于编码器 / 解码器**（后者通常是数千万到上亿参数）——代码本本身很便宜，麻烦的是它的**优化**（死码字、利用率）。

**(b)** token 数 $N=16\times16=256$。每个 token 有 $K=512$ 种取值，$\log_2 512=9$ bit，故每张图的离散信息量上界为
$$N\log_2 K=256\times9=2304\ \text{bit}=288\ \text{字节}.$$
**读法**：这是「用 288 字节描述一张 $256\times256$ 彩图」的极端压缩，它之所以能成立，是因为解码器**自己带着绝大部分细节知识**（它见过整个数据集）。换句话说：**这不是通用压缩，而是「用解码器当先验」的有损压缩**——换一个数据集或换一个解码器，这 288 字节的含义就完全不同。

**(c)** 原始输入 $256\times256\times3=196{,}608$ 字节（uint8），token 表示按索引存储需 $256\times\lceil9/8\rceil\approx576$ 字节（按 2 字节整数存）或 $288$ 字节（按位打包）。**压缩率约 $341\sim683$ 倍**。但这个数字不能被当作「模型压缩能力」的度量——它与「解码器记忆了多少训练分布」混在一起，后者无从分离（这也是生成模型「压缩即智能」这类论断难以量化的原因之一）。$\blacksquare$
:::
:::

## 4.7.3 VQGAN：给解码器加感知与对抗 {#sec-4.7.3}

::: prop 命题 4.7.1 · 纯重建损失为什么让离散编码器变糊 {#prop-4.7.1}
设解码器逐像素以高斯建模 $p(\boldsymbol x\mid \boldsymbol z)=\prod_i\mathcal N(x_i;g_i(\boldsymbol z),\sigma^2)$。则对数似然最大化的最优解是**条件均值**
$$g^\star(\boldsymbol z)=\mathbb E[\boldsymbol x\mid \boldsymbol z].$$
当给定 $\boldsymbol z$ 仍有多个可能的高频细节时，条件均值是它们的**加权平均**——平均后的结果在感知上是模糊的（细节被抹平）。
:::

::: proof 推导（一步到均值）
$$\max_{g}\ \mathbb E_{\boldsymbol x\mid \boldsymbol z}\Bigl[-\frac{1}{2\sigma^2}\lVert\boldsymbol x-g(\boldsymbol z)\rVert_2^2+\text{const}\Bigr]
\ \Longleftrightarrow\ \min_{g}\ \mathbb E\bigl[\lVert\boldsymbol x-g(\boldsymbol z)\rVert_2^2\bigr],$$
对 $g$ 逐坐标求导置零：$\mathbb E[x_i\mid\boldsymbol z]-g_i(\boldsymbol z)=0$，即 $g_i^\star(\boldsymbol z)=\mathbb E[x_i\mid\boldsymbol z]$。$\blacksquare$
:::

::: intuition VQGAN 的两件补丁
VQ-VAE 的重建项是 MSE，按 [命题 4.7.1](#prop-4.7.1) 会把细节平均掉，于是生成的图偏糊。VQGAN 的思路是把「糊」变成明确惩罚项：

1. **感知损失（perceptual loss）**：不在像素空间比较，而是在一个**预训练特征网络**（如 VGG 类）的中间层比较 $\lVert f(\boldsymbol x)-f(\hat{\boldsymbol x})\rVert$。特征空间对「结构、纹理」敏感、对「像素级微小偏移」不敏感，因此它惩罚的是「看起来不像」而不是「每个像素有偏差」。
2. **对抗损失（adversarial loss）**：加一个 **patch 级判别器**判断「局部图块是真实的还是重建的」，让解码器学会补出**合理的**高频细节而不是「安全的均值」。

三项（重建 + 感知 + 对抗）合起来才得到「离散但锐利」的编码器。**这也是为什么 [4.6](sec46.md) 的 LDM 直接把它的第一阶段称为「感知压缩」**——同一个设计动机。
:::

::: errata 代码本利用率低的三个常见误判
1. **「利用率低就是代码本太大，砍小一点」**：把 $K$ 砍小确实能提高利用率百分比，但代价是**每 token 的信息量下降**（$\log_2K$ 减少），序列需要更长才能表达同样的信息——这是左右为难的权衡，不是单向优化。正确做法是看**重构质量与生成质量的联合表现**，而不是单独盯利用率。
2. **「加 commitment 的 $\beta$ 越大越稳」**：$\beta$ 太大会把编码输出死死压在码字上，编码器失去表达能力（重建变差）；$\beta$ 太小则码字追不上编码器的漂移（死码字变多）。它是一个需要扫的超参，不是「越大越好」。
3. **「VQ-VAE 是生成模型」**：VQ-VAE 本身**只是一套离散自编码器**（和 [4.2](sec42.md) 的 AE 一样只有编码—解码能力）。要能生成，还需要在 token 序列上再训一个**先验模型**（自回归 Transformer 或掩码扩散模型）——这才是「一半」的另一半。把 VQ-VAE 单独称作生成模型是常见误称。
:::

## 4.7.4 FSQ：去掉代码本，用标量量化 {#sec-4.7.4}

::: def 定义 4.7.3 · 有限标量量化（finite scalar quantization, FSQ） {#def-4.7.3}
FSQ 放弃「学习代码本 + 最近邻搜索」，改为在**每一维上独立**地把实数四舍五入到有限个格子：

给定每个维度 $i$ 的**奇数**档位数 $L_i$（如 $L_i=5$），定义
$$\hat z_i=\operatorname{round}\bigl(\lfloor L_i/2\rfloor\cdot\tanh(z_i)\bigr)\ \in\ \Bigl\{-\frac{L_i-1}{2},\dots,\frac{L_i-1}{2}\Bigr\},$$
即先把该维的实数压到 $(-1,1)$，缩放后四舍五入到最近的整数格点。**整个表示的代码本大小就是各维档位数之积**
$$K=\prod_{i=1}^{d}L_i .$$
不需要代码本损失、不需要 commitment loss，也不需要在 $K$ 个码字上做最近邻搜索——**量化就是一次逐维的 round**。
:::

::: intuition 「显式代码本」为什么不必要
VQ 的做法可以概括为「**学一个 $K$ 个点的集合，然后把编码输出投影到最近的点**」。这个投影有两个副作用：① 投影本身要算距离（$K$ 次比较）；② 该把哪些码字拉到哪里，需要一个额外的损失（代码本损失 + commitment）来指导，而这个指导本身又会和重建项打架（→ 死码字、塌缩）。

FSQ 的观察是：**「离散」这件事不一定需要「一个可学的有限集合」**。如果只要求「每一维取有限个值」，那么最简单的选择就是**网格**：维度 $i$ 取 $L_i$ 档，$d$ 维合起来仍然是 $K=\prod L_i$ 个组合（与 VQ 的代码本容量相同量级）。好处是三重的：

- **零额外损失**：网格是固定的，没有「码字该往哪挪」的问题，因此不需要代码本损失与 commitment；
- **零搜索**：量化 = 逐维 round，$O(d)$ 而不是 $O(K)$；
- **零塌缩**：不存在「某几个码字吞掉所有输入」的结构——最多是某些格子没人用（可通过档位数设计避免）。

**要付的代价**：VQ 的码字是**数据驱动**的（码字位置可以贴合数据流形），FSQ 的网格是**先验固定**的（在超立方体上均匀铺）。当数据在潜空间里分布极不均匀时，VQ 理论上更高效；但实践中——这是 FSQ 论文的核心经验结论——**去掉代码本学习的各种不稳定技巧之后，整体收益更大**，且同样的重构质量下 FSQ 可以只用很少的维度（如 $d=5\sim8$）。
:::

::: think 「用 Gumbel-Softmax 松弛量化行不行」
另一条常见路线是把「取最近码字」写成概率化的**类别采样**再软化：用 softmax 权重对码字加权求和，配温度退火逐步逼近期望中的 one-hot（这就是 Gumbel-Softmax 的思路，也是 [4.3.2](sec43.md#method-4.3.1) 重参数化一节的旁注提到的「连续松弛」）。它的优点是**全程可微**（不需要 STE），缺点是：

- 训练时的「软量化」与推理时的「硬 one-hot」之间存在**目标不一致**（训练看到的是混合向量，推理看到的是码字），需要退火把 gap 压小；
- 温度也是一个需要调的旋钮，且过高 / 过低都会导致训练不稳或塌缩。

**它和 VQ 与 FSQ 的关系**：Gumbel-Softmax 是「可微的类别选择」，VQ+STE 是「不可微的类别选择 + 有偏梯度」，FSQ 是「不需要选择的量化」。三条路线都在解决同一个矛盾——**离散化与可微性不相容**——只是妥协的位置不同。
:::

## 4.7.5 自回归视觉生成：从光栅扫描到 next-scale prediction {#sec-4.7.5}

::: def 定义 4.7.4 · next-scale prediction（VAR） {#def-4.7.4}
**VAR**（visual autoregressive modeling）把图像表示成**多尺度 token 金字塔**，并改变自回归的分解顺序：不是「按光栅顺序预测下一个 token」，而是**按尺度**预测——先整体生成最粗的一张小图，再依次生成更高分辨率的残差图：

$$\boldsymbol x=\bigl(R_1,R_2,\dots,R_K\bigr),\qquad
p(\boldsymbol x)=\prod_{k=1}^{K}p\bigl(R_k\mid R_1,\dots,R_{k-1}\bigr),$$

其中 $R_k\in\mathbb R^{h_k\times w_k\times d}$ 是第 $k$ 个尺度上的 token 图（每个尺度由残差量化得到，$h_k,w_k$ 逐级翻倍）。第 $k$ 步的预测是「**在已知所有更粗的尺度下，生成这一尺度的整张 token 图**」——一次前向预测 $h_kw_k$ 个 token（并行），而不是一个一个 token 地吐。
:::

::: intuition 为什么「按尺度」优于「按光栅」
**光栅扫描的两个错配**：
1. **与自然图像的生成顺序错配**。人画图或理解图是「先轮廓大致、再细节」，而光栅顺序是「左上到右下」——它把强相关的相邻像素拆散，又把弱相关的远距离像素排在很晚才看到。
2. **与因果注意力的距离错配**。自回归模型的因果注意力只能看「已生成的位置」，而在光栅顺序下，一个 token 的**空间近邻**可能排在它之前也可能之后（取决于行列方向）。VAR 论文的核心观察之一就是：这种「空间邻接与序列邻接不重合」正是自回归图像生成难以稳定扩展（scaling）的原因之一。

**VAR 的修法**：让「先生成的」= 「更粗的尺度」。这样每个尺度内是**完全并行**的（一次前向出整张 token 图），而跨尺度是串行的（粗 → 细）。好处有两条很实在：
- **序列长度从 $O(N)$ 降到 $O(\log N)$ 个「尺度步」**，每步内是并行的矩阵运算，硬件利用率高；
- **每个 token 的预测都可见到全局的粗结构**，因此没有「生成到一半还不知道整体长什么样」的问题。

**必须写清的代价**：VAR 依赖一个**多尺度残差量化**的编码器（每个尺度存的是残差），这套编码器的设计与训练有成本；且「一次生成整张 token 图」意味着**每个尺度内没有局部修正的机会**，若某个尺度生成错了，误差会被后续尺度继承（这与扩散的「逐步修正」形态相反）。
:::

::: method 一张图看懂四条「图像 token 化 + 建模」路线 {#method-4.7.1}
| 路线 | 离散化方式 | 生成顺序 | 代表工作 | 主要优势 | 主要代价 |
|:--|:--|:--|:--|:--|:--|
| VQ + 光栅自回归 | 单尺度 VQ | token 逐个（行列扫描） | VQ-VAE + PixelCNN / Transformer（早期路线） | 与语言模型最同构 | 长序列、空间邻接与序列邻接错配 |
| VQGAN + 光栅自回归 | VQ + 感知 / 对抗损失 | token 逐个 | VQGAN 系列 | 重建更锐利，序列不太长 | 仍有顺序错配；代码本不稳 |
| **VAR（多尺度）** | 多尺度残差量化 | **按尺度**（粗 → 细） | VAR（2024） | 步数少、并行度高、scaling 行为更好 | 需要多尺度量化器；尺度内无修正 |
| 扩散 / 整流流（[4.5](sec45.md)–[4.6](sec46.md)） | 连续（潜空间） | 多步去噪（逐步修正） | LDM / DiT / 整流流 | 细粒度可控、编辑方便 | 步数与延迟；量化路线不需要迭代 |
| **掩码扩散语言模型** | 离散（来自 VQ 或其他 tokenizer） | **任意顺序**（并行去噪） | MaskGIT（图像）、LLaDA（文本，[4.7.6](#sec-4.7.6)） | 并行解码、双向上下文 | 训练目标与文本 LM 生态不完全兼容 |
:::

## 4.7.6 离散扩散与掩码去噪：文本上的另一条路 {#sec-4.7.6}

::: def 定义 4.7.5 · 掩码去噪的离散生成 {#def-4.7.5}
把「加噪」换成「**遮蔽**」（mask）：设每个 token 独立以概率 $\sigma(t)$ 被替换为 `[MASK]`，得到部分可见的序列；模型学习还原被遮蔽的 token：

$$\mathcal L_{\text{mask}}=-\mathbb E_{t,\ \boldsymbol x,\ \text{mask}}\Bigl[\sum_{i\in\text{masked}}\log p_\theta\bigl(x_i\mid \boldsymbol x_{\text{visible}},t\bigr)\Bigr].$$

**采样（迭代去掩码）**：从「全部是 `[MASK]`」的序列出发，分若干轮「一次预测所有被遮蔽位置的分布 → 按置信度选出最可靠的一部分填入 → 其余仍保留为 `[MASK]`」，直到没有 `[MASK]`。
:::

::: intuition 掩码去噪 vs 自回归：两种「先易后难」的策略
两者都在做「逐步确定 token」，但方向不同：

| 维度 | 自回归（AR） | 掩码去噪（masked diffusion） |
|:--|:--|:--|
| 生成顺序 | 固定（左到右） | **可自由选择**（通常是「先填最有把握的」） |
| 每步并行度 | $1$ 个 token（受 KV cache 加速） | **多个 token**（一轮内并行预测所有遮蔽位） |
| 上下文 | 只用左侧（因果） | **双向**（可见两侧，与 BERT 类目标同族） |
| 纠错能力 | 一旦生成错，后续只能被动适配 | **可重遮蔽**（把低置信度位置重新标回 `[MASK]` 再试） |
| 与语言模型生态 | 完美兼容（KV cache / 流式输出） | 文本上需新的推理与训练栈（这些是研究中的工程问题） |

**一个诚实的评价**：掩码去噪在**并行解码**和**可重掩码修正**上有理论优势，且在图像上（MaskGIT）等任务上表现良好；但在文本上，它与「自回归 + KV cache」这条已经极度优化的工业路线竞争，**在延迟与质量的综合对比上仍没有一边倒的结论**（这也是 2025 年前后这一方向持续活跃的原因：它要证明的不只是数学，而是工程性价比）。教材对此应给出两方证据而不是单边结论。
:::

::: method 一个可运行的最小实验设计（离散生成） {#method-4.7.2}
想真正理解这条路，最小实验的配置建议如下（每一步都有明确的验收标准）：

1. **离散化**：在小图像集上训一个 VQ-VAE（$K=256\sim512$、$d=32\sim64$），验收标准：重建 PSNR 与「token 序列长度 × $\log_2 K$」的比特率同时记录（[例 4.7.1](#ex-4.7.1)）。
2. **先验建模**：在 token 序列上训一个**小自回归 Transformer**（例如 $6$ 层、$d_{\text{model}}=256$），验收标准：验证集上的**逐 token 交叉熵下降**且生成的样本能通过人眼判别「是不是这个数据集的东西」。
3. **消融**：把自回归顺序从光栅改成「按尺度」（用一个两级金字塔近似 VAR 的思路），对比**序列长度**与**生成样本的整体一致性**（例如用「粗尺度与细尺度是否矛盾」这类简单判据或人眼）。
4. **可选进阶**：把第 2 步换成一个**掩码去噪**目标（随机遮蔽比例 $30\%\sim70\%$），比较「同样采样预算下的质量」与「解码轮数」，观察并行解码的收益与代价。
:::

```python
import torch, torch.nn as nn, torch.nn.functional as F

class VQ(nn.Module):
    """向量量化层：最近邻查表 + 直通估计量。"""
    def __init__(self, K=512, d=64, beta=0.25):
        super().__init__()
        self.K, self.d, self.beta = K, d, beta
        self.codebook = nn.Embedding(K, d)                 # 可学码字（代码本）
        self.codebook.weight.data.uniform_(-1.0 / K, 1.0 / K)

    def forward(self, z_e):
        # z_e: (B, d, H, W) → 展平成 (N, d) 做最近邻
        B, d, H, W = z_e.shape
        z = z_e.permute(0, 2, 3, 1).reshape(-1, d)         # (N, d)
        # ① 距离：‖z - e_k‖² = ‖z‖² - 2·zᵀe_k + ‖e_k‖²
        dist = (z.pow(2).sum(1, keepdim=True)
                - 2 * z @ self.codebook.weight.t()
                + self.codebook.weight.pow(2).sum(1))
        idx = dist.argmin(1)                               # (N,) 最近码字索引
        e_c = self.codebook(idx)                           # (N, d) 量化结果

        # ② 直通估计量：前向用 e_c，反向把梯度直接送给 z
        z_q = z + (e_c - z).detach()                       # ∂L/∂z ≈ ∂L/∂z_q

        # ③ 两项损失：代码本损失只更新码字；commitment 只更新编码器
        loss_cb = F.mse_loss(e_c.detach(), z)              # sg[z_e] - e_c
        loss_commit = F.mse_loss(z, e_c.detach())          # β‖z_e - sg[e_c]‖²

        z_q = z_q.reshape(B, H, W, d).permute(0, 3, 1, 2)
        idx = idx.reshape(B, H, W)
        return z_q, idx, loss_cb + self.beta * loss_commit

class VQVAE(nn.Module):
    """最小 VQ-VAE：编码器下采样 4 倍，量化，解码器上采样回去。"""
    def __init__(self, in_ch=3, d=64, K=512, base=32):
        super().__init__()
        self.enc = nn.Sequential(
            nn.Conv2d(in_ch, base, 4, 2, 1), nn.ReLU(),                # H -> H/2
            nn.Conv2d(base, d, 4, 2, 1), nn.ReLU(),                    # H/2 -> H/4
        )
        self.vq = VQ(K=K, d=d)
        self.dec = nn.Sequential(
            nn.ConvTranspose2d(d, base, 4, 2, 1), nn.ReLU(),           # H/4 -> H/2
            nn.ConvTranspose2d(base, in_ch, 4, 2, 1), nn.Tanh(),       # H/2 -> H，输出 [-1,1]
        )

    def forward(self, x):
        z_e = self.enc(x)
        z_q, idx, vq_loss = self.vq(z_e)
        return self.dec(z_q), idx, vq_loss

def train_vqvae(model, loader, steps=2000, lr=1e-3):
    opt = torch.optim.Adam(model.parameters(), lr=lr)
    it = iter(loader)
    for i in range(steps):
        try:
            x, _ = next(it)
        except StopIteration:
            it = iter(loader); x, _ = next(it)
        x_hat, idx, vq_loss = model(x)
        rec = F.mse_loss(x_hat, x)
        loss = rec + vq_loss
        opt.zero_grad(); loss.backward(); opt.step()
        if i % 200 == 0:
            # 关键监控：代码本利用率（用到的码字数 / K）——低于 10% 就要查 β 与编码器尺度
            util = idx.unique().numel() / model.vq.K
            print(f"{i:5d} rec {rec.item():.4f} vq {vq_loss.item():.4f} util {util:.3f}")
    return model

# 编码成 token 序列后，交给自回归 Transformer（与语言模型完全相同的训练循环）
@torch.no_grad()
def encode_to_tokens(model, x):
    """返回 (B, N) 的整数 token 序列，可直接当作语言模型的输入。"""
    _, idx, _ = model(x)
    return idx.flatten(1)          # (B, H/4 * W/4)

# 自回归先验：就是 [第 2 讲](../lec02/sec25.md) 的因果 Transformer + 交叉熵
ar = nn.TransformerEncoderLayer(d_model=256, nhead=8, batch_first=True)  # 实际需加因果掩码
# 训练目标：交叉熵(pred, tokens.shift(-1))
# 采样：温度 / top-k 采样，与文本生成完全一致
```

::: errata 本节四条高频误解
1. **「VQ-VAE / VQGAN 本身就是生成模型」**：它们是**离散自编码器**（把图变成 token），不能直接生成。生成需要第二个模型（自回归或掩码扩散）在 token 序列上学分布（[4.7.3](#sec-4.7.3)）。
2. **「直通估计量是错的，所以 VQ 不严谨」**：STE 确实给出有偏梯度（真实导数为零），但「真实导数」本身在分段常数函数上几乎没有信息。VQ 家族的成功是**经验事实**（大量视觉生成系统都在用），把它当作「有偏但有效」的处理方式，而不是「近似正确」的推导。
3. **「FSQ 只是 VQ 的实现优化」**：改变的是**表示的结构**——从「学出来的 $K$ 个码字」变成「逐维固定的网格」。因此它去掉了代码本损失、commitment loss 与最近邻搜索这三样东西，也去掉了它们带来的不稳定（[4.7.4](#sec-4.7.4)）。
4. **「自回归图像生成只能光栅扫描」**：光栅扫描只是**一种**顺序。VAR 用「按尺度」的顺序，掩码去噪用「按置信度」的任意顺序。选择顺序是一个**建模决策**，会直接影响长序列的可扩展性与生成质量（[4.7.5](#sec-4.7.5)）。
:::

::: method 即时自测 · 4.7
**Q1** 写出 VQ-VAE 的三项损失，并指出每一项用 `stop-gradient` 把梯度拦在了哪一侧。

**Q2** 直通估计量为什么必要？它「估计」的是什么？

**Q3** 代码本大小 $K=512$、潜码分辨率 $16\times16$、$d=64$：给出代码本参数量、token 序列长度与序列的比特率（bit / 图）。

**Q4** FSQ 用 $d=8$ 维、每维 $5$ 档，代码本大小是多少？与 $K=512$ 的 VQ 相比，在「每 token 信息量」上是大还是小？

**Q5** 用一句话说明 VAR 的 `next-scale prediction` 与光栅自回归的关键区别，并指出它的一个代价。

::: sol 参考要点
**Q1** $\mathcal L=\lVert\boldsymbol x-\mathcal D(z_q)\rVert^2+\lVert\operatorname{sg}[z_e]-e_c\rVert^2+\beta\lVert z_e-\operatorname{sg}[e_c]\rVert^2$。第一项无 `sg`（同时更新编码器、解码器，经 STE 传梯度）；第二项的 $\operatorname{sg}[z_e]$ 把梯度拦在**编码器侧之外**，只更新码字；第三项的 $\operatorname{sg}[e_c]$ 把梯度拦在**码字侧之外**，只更新编码器。

**Q2** 因为量化（最近邻查表）是分段常数映射，其真实导数几乎处处为零，若如实使用，编码器收不到任何梯度，训练无法进行。STE 在前向如实量化（保真），反向假设 $\partial z_q/\partial z_e\approx I$（把量化当作恒等映射）。它「估计」的是**量化操作的雅可比**（用单位矩阵替代零矩阵），因此梯度是有偏的，但提供了可用的下降方向。

**Q3** 代码本参数量 $=512\times64=32{,}768$；token 序列长度 $N=16\times16=256$；比特率 $=N\log_2K=256\times9=2304$ bit $=288$ 字节。

**Q4** $K=\prod_i L_i=5^8=390{,}625$，故 $\log_2 K\approx18.6$ bit/token——**比 $K=512$ 的 $9$ bit/token 大**。这意味着同样的 $N$ 个 token 可以承载更多信息（或者说，达到同样的信息量可以用更少的 token / 更少的维度）。这也解释了 FSQ 论文强调「用很少的维度（$d=5\sim8$）就能达到与更高维 VQ 相当的重构质量」。

**Q5** 关键区别：**生成顺序按尺度（粗 → 细）而非按空间位置（光栅）**，且每个尺度内一次并行生成整张 token 图。代价举例：① 需要多尺度残差量化的编码器（额外设计与训练成本）；② 单个尺度内没有逐步修正的机会，粗尺度上的错误会被后续尺度继承（与扩散「逐步修正」的形态相反）。
:::

::: note[skip] 延伸阅读
- van den Oord, Vinyals & Kavukcuoglu, *Neural Discrete Representation Learning*（2017，arXiv:1711.00937）——VQ-VAE 原始论文；直通估计量、代码本损失与 commitment loss 都在其第 3 节。
- Esser, Rombach & Ommer, *Taming Transformers for High-Resolution Image Synthesis*（2020，arXiv:2012.09841）——VQGAN：感知损失 + 对抗损失 + 自回归先验的组合。
- Mentzer et al., *Finite Scalar Quantization: VQ-VAE Made Simple*（2023，arXiv:2309.15505）——FSQ 原始论文（含与 VQ 在重构质量、代码本利用率与所用的工程技巧上的系统对比）。
- Razavi, van den Oord & Vinyals, *Generating Diverse High-Fidelity Images with VQ-VAE-2*（2019，arXiv:1906.00446）——多尺度 / 层级 VQ，可视为 VAR 金字塔表示的前身。
- Tian et al., *Visual Autoregressive Modeling: Scalable Image Generation via Next-Scale Prediction*（2024，arXiv:2404.02905）——VAR 原始论文；「空间邻接与序列邻接不重合」的动机分析与 scaling 实验都在其中。
- Chang et al., *MaskGIT: Masked Generative Image Transformer*（2022，arXiv:2202.07785）——掩码去噪在图像上的代表作（并行解码、置信度重掩码）。
- Austin et al., *Structured Denoising Diffusion Models in Discrete State-Spaces*（2021，arXiv:2107.03006）——离散扩散（D3PM）的通用框架，把「加噪」推广到离散状态空间上的马尔可夫转移。
- Lou, Meng & Ermon, *Discrete Diffusion Modeling by Estimating the Ratios of the Data Distribution*（2023，arXiv:2310.16834）——SEDD：用「比率估计」做离散扩散，是离散得分匹配路线的重要一步。
- Nie et al., *Large Language Diffusion Models*（2025，arXiv:2502.09992）——LLaDA：把掩码扩散做到 8B 参数级的文本模型（本节 [4.7.6](#sec-4.7.6) 的当代依据）。
- Peebles & Xie, *Scalable Diffusion Models with Transformers*（2022，arXiv:2212.09748）——见 [4.6.2](sec46.md)；把 DiT 与 VAR 并读，可以看到「Transformer 主干 + 不同生成顺序」的对照。
:::
:::

**本节小结**：离散路线 = **离散化 + 序列建模**两半。离散化一侧：VQ-VAE 用「最近邻查表 + 直通估计量 + 代码本 / commitment 损失」把连续特征压成整数 token（[定义 4.7.2](#def-4.7.2)）；VQGAN 用感知损失 + 对抗损失把「糊」变成明确惩罚（[命题 4.7.1](#prop-4.7.1)）；FSQ 用逐维标量量化直接去掉代码本学习（[定义 4.7.3](#def-4.7.3)）。建模一侧：自回归可以按光栅扫描，也可以按尺度（VAR 的 next-scale prediction，[定义 4.7.4](#def-4.7.4)）；文本上的另一条路是掩码去噪 / 离散扩散（[定义 4.7.5](#def-4.7.5)），它用并行解码与双向上下文换取与自回归生态的兼容性成本。

**一个横贯全讲的结论**：离散表示把「生成」变成了「分类」，因此天生能表达**多模态**；连续表示把「生成」变成「回归」，因此天生产生**平均化**。这条差别解释了为什么 [4.3](sec43.md) 的 VAE 偏糊、[4.6.5](sec46.md) 的纯蒸馏偏糊，也解释了为什么语言模型这条路在「离散」上如此顺手。

下一节把整讲收束成一张地图：真实任务该怎么选，怎么改（编辑与定制），以及部署时必须处理的水印与溯源。
