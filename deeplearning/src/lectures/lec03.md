# 第 3 讲 · 深度计算机视觉

> 本讲回答一个问题：**图像为什么不能用 MLP 硬啃，而要专门设计卷积神经网络（CNN）？** 我们从全连接层的「两宗罪」讲起，引出卷积的**归纳偏置**（局部连接、权值共享、平移等变），把卷积运算、通道、步幅、填充、感受野逐一算清楚，再看池化如何下采样、AlexNet / VGG / ResNet 如何一步步把网络做深，迁移学习为何成为工程默认做法，最后延伸到检测、分割，以及偏见、对抗样本、隐私这些绕不开的安全议题。读完这一讲，你会用同一套「结构 + 损失 + 梯度下降」的语言，读懂几乎所有视觉模型。

<aside class="lesson-brief" aria-label="第 3 讲学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>第 1 讲的 MLP、反向传播与卷积的「线性变换 + 非线性」框架；矩阵乘法的形状对齐；张量的轴含义（批 × 高 × 宽 × 通道）；导数的含义。</p></div>
<div><span class="brief-label">TARGET</span><strong>本讲要建立</strong><p>卷积运算与归纳偏置；输出尺寸公式 $W_{out}=(W_{in}-k+2p)/s+1$；参数量与计算量的复算；感受野随层数增长；1×1 卷积；池化；AlexNet / VGG / ResNet；残差连接为什么解决退化；迁移学习的冻结与微调；检测（两阶段 / 单阶段）与分割（语义 / 实例）；偏见、对抗样本与隐私。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>学完的标准</strong><p>给定输入尺寸、卷积核、步幅、填充，能手算输出尺寸；能算出一层卷积的参数量与计算量；能解释残差连接如何让梯度直通；能判断一个视觉任务该用分类 / 检测 / 分割哪一套，并说出为什么预训练权重是默认起点。</p></div>
</aside>

::: method[core] 10 分钟复习版 · 第 3 讲

**一句话**：卷积 = **局部连接 + 权值共享**的线性模板，用**归纳偏置**把「平移不变」的先验写进结构里，从而用极少参数处理大图像；堆叠卷积 + 池化得到层次化特征，加**残差连接**让网络能真的做深，靠**迁移学习**复用预训练权重，最后接到检测与分割。

**必记结论**

| 内容 | 要点 |
|:--|:--|
| **全连接的两宗罪** | ① **参数爆炸**（$224\times224\times3$ 输入接 $1000$ 维隐层就是约 $1.5\times10^8$ 个权重）；② **无视空间结构**（展平后相邻像素关系被丢弃，位置一动就要重学） |
| **归纳偏置** | **局部连接**（每个输出只看一个小邻域）、**权值共享**（同一个核在整个图上滑动）、**平移等变**（输入平移，输出跟着平移） |
| **卷积运算** | 多通道：$y^{(o)}_{i,j}=\sum_{c}\sum_{u,v}w^{(o,c)}_{u,v}x^{(c)}_{i+u,j+v}+b^{(o)}$；框架实现的是**互相关**，不翻转核 |
| **输出尺寸** | $W_{out}=\left\lfloor\dfrac{W_{in}-k+2p}{s}\right\rfloor+1$；`valid`（$p=0$）变小，`same`（恰当时）不变 |
| **参数量** | 一层卷积 $=C_{out}\times C_{in}\times k^2+C_{out}$，**与图像尺寸无关**——这是卷积省参数的根 |
| **计算量** | 每个输出像素的乘加 $\approx C_{out}\times C_{in}\times k^2$，总量再乘输出面积，是工程上的真正瓶颈 |
| **感受野** | $L$ 层 $3\times3$（步幅 1）堆叠，感受野 $=2L+1$；池化 / 步幅卷积指数级放大它 |
| **1×1 卷积** | 只混合**通道**、不改空间尺寸，用于升降维与加非线性，几乎免费 |
| **池化** | 最大 / 平均池化，取邻域统计量下采样；丢弃位置细节 → 带来一定**平移不变性**并降低计算量 |
| **残差连接** | $y=F(x)+x$；恒等映射易学（令 $F\to0$），梯度 $\partial y/\partial x=I+\partial F/\partial x$ 有直通项，解决**退化**问题 |
| **迁移学习** | ImageNet 预训练特征可迁移；浅层冻结、深层微调、用更小学习率——视觉任务的**工程默认**起点 |
| **检测 / 分割** | 检测 = 定位 + 分类（两阶段 R-CNN 系 / 单阶段 YOLO）；语义分割 FCN / U-Net；实例分割 Mask R-CNN |
| **安全** | 数据集的人口统计偏见会被模型**放大**；**对抗样本**用不可察扰动即可骗过分类器；隐私与监控风险需主动评估 |

**最该记住的四个判断**：① 图像任务**别用 MLP 起手**，卷积的归纳偏置就是为图像量身定的；② 算不清一层卷积的输出尺寸 / 参数量，等于没学会卷积——那两个公式要背下来；③ 网络变深会**退化**（不是过拟合，是训练误差也升），残差连接是标准解药；④ 现实里几乎没人从零训视觉模型，**先加载预训练权重再微调**。

:::

## 3.1 为什么是卷积：全连接的两宗罪与卷积的归纳偏置

先把 MLP 用在图像上会发生什么。一张 $224\times224$ 的 RGB 图有 $224\times224\times3=150{,}528$ 个数。若把它**展平**成一个向量，接一层 $1000$ 维的全连接隐藏层，仅这一层的权重就有

$$150{,}528\times1000\approx1.5\times10^{8}$$

个——接近 1.5 亿个参数，而且这还只是**第一层**。这就是第一宗罪：**参数爆炸**。

第二宗罪是**无视空间结构**。展平操作把二维的像素网格拉成一维向量，相邻像素的空间关系被彻底打散；网络看到的只是「第 137 个像素是 0.7」，完全不知道它旁边是谁。后果有两个：一是模型要为**每个位置**单独学一套权重，图像平移一个像素就得重新学一遍；二是它丢掉了「局部相似」这一最基本的图像先验。

卷积用三件武器同时解决这两宗罪，它们合称卷积的**归纳偏置**（inductive bias）——即「把我们对图像的先验假设写进网络结构」。

::: def 定义 3.1 · 卷积的三种归纳偏置 {#def-3-1}
设输入图像为 $x$，卷积核（filter / kernel）为一个小窗口 $w$。

- **局部连接（local connectivity）**：每个输出位置只与输入的**一个局部邻域**（大小 $k\times k$）相连，而不是与整张图相连。
- **权值共享（weight sharing）**：**同一个**核在图像上逐位置滑动，所有空间位置共用这一组权重。
- **平移等变（translation equivariance）**：把输入平移 $\Delta$，输出也只是被平移 $\Delta$（在边界处理允许的范围内），记为 $f(\mathrm{shift}(x))=\mathrm{shift}(f(x))$。
:::

::: intuition 为什么权值共享既省参数又带来平移等变
**省参数**：一层全连接要给每个位置一套权重；权值共享后，整张图共用一组核权重，参数量只跟**核大小与通道数**有关，与图像尺寸无关。**平移等变**：因为核在所有位置用的是同一套权重，同一个图案出现在图像左上角还是右下角，都会被同一个检测器"激活"，输出只是位置跟着移动。这正好对应视觉世界的基本事实——**物体是什么，与它在哪里无关**。
:::

::: note 等变 vs 不变，一次说清
**平移等变**：输入平移，输出特征图也平移（卷积本身具有的性质）。**平移不变**：不管物体在哪，**最终标签**都一样（分类任务需要的性质）。二者不是一回事：卷积提供等变，而**池化 / 全局池化**把"在哪"这个信息进一步抹掉，才把等变升级为不变。这也是为什么分类网络结尾常用全局平均池化。
:::

## 3.2 卷积运算：从单通道到多通道

深度学习里的"卷积"严格说是**互相关（cross-correlation）**：核不在运算时翻转。

::: def 定义 3.2 · 二维卷积与多通道卷积 {#def-3-2}
**单通道**：输入 $x\in\mathbb R^{H\times W}$，核 $w\in\mathbb R^{k\times k}$，偏置 $b$，输出

$$y_{i,j}=\sum_{u=0}^{k-1}\sum_{v=0}^{k-1}w_{u,v}\,x_{i\cdot s+u,\,j\cdot s+v}+b .$$

**多通道**：输入 $x\in\mathbb R^{H\times W\times C_{in}}$，要输出 $C_{out}$ 个通道，则每个输出通道 $o$ 有自己的一整套核 $w^{(o)}\in\mathbb R^{k\times k\times C_{in}}$：

$$y^{(o)}_{i,j}=\sum_{c=1}^{C_{in}}\sum_{u=0}^{k-1}\sum_{v=0}^{k-1}w^{(o,c)}_{u,v}\,x^{(c)}_{i\cdot s+u,\,j\cdot s+v}+b^{(o)},\qquad o=1,\dots,C_{out}.$$
:::

要点：**核的通道数必须等于输入通道数**（每个输入通道配一个 $k\times k$ 切片，全部求和），**输出通道数 = 核的个数**。输出张量形状因此是 $H_{out}\times W_{out}\times C_{out}$。

两个超参数控制空间尺寸：

- **填充 padding $p$**：在图像边界外补 $p$ 圈（通常补 0）。作用是 (i) 保住边缘信息不被过早吃掉，(ii) 让输出尺寸可控。
- **步幅 stride $s$**：核每次滑动的步长。$s=1$ 是逐像素滑动；$s=2$ 相当于边卷积边下采样。

综合起来就是必须背下来的**输出尺寸公式**：

$$W_{out}=\left\lfloor\frac{W_{in}-k+2p}{s}\right\rfloor+1,\qquad H_{out}=\left\lfloor\frac{H_{in}-k+2p}{s}\right\rfloor+1 .$$

两种常见命名：`valid` 指不填充（$p=0$，输出变小）；`same` 指通过合适的 $p$（当 $s=1$ 时取 $p=\lfloor k/2\rfloor$）让输出尺寸与输入相等。

::: ex 例 3.1（输出尺寸怎么算） {#ex-3-1}
输入 $W_{in}=32$，核 $k=3$，分别求：(a) $p=0,\ s=1$；(b) $p=1,\ s=1$；(c) $p=1,\ s=2$ 时的输出尺寸。

::: proof 解
直接代入公式：

| 情形 | 计算 | $W_{out}$ |
|:--|:--|:--|
| (a) $p=0,s=1$ | $\lfloor(32-3+0)/1\rfloor+1=29+1$ | $30$ |
| (b) $p=1,s=1$ | $\lfloor(32-3+2)/1\rfloor+1=31+1$ | $32$（`same`） |
| (c) $p=1,s=2$ | $\lfloor(32-3+2)/2\rfloor+1=\lfloor31/2\rfloor+1=15+1$ | $16$ |

**记住规律**：$s=1$ 且 $p=\lfloor k/2\rfloor$ 时尺寸不变；每个 $s=2$ 大致把尺寸减半。
:::

:::

参数与计算量是卷积的"成本表"，必须能复算。

::: ex 例 3.2（$3\times3\times64$ 卷积的参数量与计算量） {#ex-3-2}
一层卷积：核 $3\times3$，输入通道 $C_{in}=64$，输出通道 $C_{out}=64$，输入特征图 $56\times56\times64$，$p=1,s=1$。求参数量与乘加次数（MACs）。

::: proof 解
**参数**：每个输出通道要一整套 $3\times3\times64$ 的核，再加一个偏置：

$$C_{out}\times C_{in}\times k^2+C_{out}=64\times64\times9+64=36{,}864+64=36{,}928 .$$

**输出尺寸**：$p=1,k=3,s=1$，$56$ 不变，得 $56\times56\times64$。

**每个输出像素的乘加**：$C_{in}\times k^2=64\times9=576$。一个输出通道共 $56\times56$ 个位置，再乘 $C_{out}$ 个通道：

$$\underbrace{64\times64\times9}_{\text{每像素每通道}}\times\underbrace{56\times56}_{\text{输出位置}}=36{,}864\times3136\approx1.16\times10^{8}\ \text{MACs}.$$

**对比结论**：参数量只有 $3.7$ 万（远小于全连接的 1.5 亿），但计算量已达上亿次——**卷积的瓶颈是算力，不是参数**，这正是 GPU 与各种高效卷积的意义所在。
:::

:::

卷积为什么有效，一大半原因在于**一层一层地扩大感受野**。

::: def 定义 3.3 · 感受野（receptive field） {#def-3-3}
某个输出神经元**能"看到"的原始输入区域**的大小，称为它的感受野。卷积、池化、大步幅都能扩展感受野。
:::

::: prop 命题 3.1 · 感受野的递推公式 {#prop-3-1}
设第 $l$ 层输出上某神经元的感受野为 $r_l$、该层相邻神经元在**原始输入**上相距 $j_l$（称为**跳距**，jump）。在其上再堆一层 $k\times k$、步幅 $s$ 的卷积，则

$$r_{l+1}=r_l+(k-1)\,j_l,\qquad j_{l+1}=j_l\cdot s,\qquad r_1=k,\ j_1=s .$$

::: proof 推导
第 $l+1$ 层的一个输出神经元是 $k\times k$ 个第 $l$ 层神经元的加权和。这 $k$ 行（列）神经元**相邻两个的中心**在原始输入上相距 $j_l$，所以它们覆盖的区间从第一个的中心延伸到最后一个的中心，长度为 $(k-1)j_l$；再向两侧各扩半个第一个/最后一个神经元的视野，即加上 $r_l$：

$$r_{l+1}=r_l+(k-1)j_l .$$

跳距方面：第 $l+1$ 层相邻神经元各用一组第 $l$ 层神经元，两组起点在原始输入上相差 $s$ 个第 $l$ 层位置、即 $s\cdot j_l$：

$$j_{l+1}=s\,j_l .$$

初始情形（第 1 层直接作用于输入）：$r_1=k$，$j_1=s$。$\blacksquare$
:::

:::

**两个直接推论**：① 全部步幅 1 时 $j_l\equiv1$，$r_L=k+(L-1)(k-1)$——$k=3$ 时即 $2L+1$（例 3.3 的 (a)）；② 步幅 2 的层让 $j$ 翻倍，此后每层的贡献 $(k-1)j_l$ 随之翻倍——**下采样让感受野滚雪球**（例 3.3 的 (b)）。设计网络时「浅层小步幅看细节、深层大跳距看全局」的直觉，全部由这两条递推定量支撑。

::: ex 例 3.3（感受野随深度增长） {#ex-3-3}
考察两种堆叠方式下的感受野：(a) $L$ 层 $3\times3$、步幅 1 的卷积；(b) 每两层 $3\times3$ 后接一次 $2\times2$ 最大池化。

::: proof 解
**(a)** 单层 $3\times3$ 感受野为 $3$，每多一层向外扩 $2$ 个像素，所以

$$\text{RF}=3+2(L-1)=2L+1 .$$

即 2 层看 $5\times5$、3 层看 $7\times7$。这正是 VGG 的思路：**用多个小核堆叠代替一个大核**——3 层 $3\times3$ 能覆盖 $7\times7$ 的感受野，但参数是 $3\times(3^2C^2)=27C^2$，而一个 $7\times7$ 核是 $49C^2$，且前者中间多了两层非线性。

**(b)** 池化（步幅 2）会在已有的感受野上加倍扩张：感受野像滚雪球一样随下采样**指数级**增长。所以深层神经元看到的是整张图尺度的大区域，这就是"深层学语义、浅层学纹理"的结构基础。
:::

:::

**1×1 卷积**（$k=1$）看着没用，其实是主力零件：单通道上它的核只有 1 个像素，跨通道才能做事。它把 $C_{in}$ 个通道线性组合成 $C_{out}$ 个通道，等价于在**每个像素位置上做一次全连接**，同时：

- **改变通道数**（$C_{in}\to C_{out}$）来做**降维 / 升维**，压缩计算量；
- 因为后面接 ReLU，它**额外引入非线性**，提升表达能力；
- **几乎不增加计算量**——空间尺寸不变，只做通道混合。ResNet 的瓶颈块、Inception 的降维都靠它。

<figure>
<svg class="figure-svg" viewBox="0 0 900 380" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-conv-title fig-conv-desc">
<title id="fig-conv-title">二维卷积：滑窗 · 步幅与填充 · 输出尺寸公式</title>
<desc id="fig-conv-desc">左侧为 7×7 输入特征图上 3×3 卷积核（步幅 2、填充 1）滑动的示意；高亮一个输出位置对应的感受窗口。右侧给出输出尺寸公式与参数量公式，并代入本例。</desc>
<defs></defs>
<rect x="44" y="44" width="234" height="234" fill="none" stroke="var(--fig-gold)" stroke-width="1.4" stroke-dasharray="6 4"/>
<rect x="70" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="70" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="70" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="96" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="70" y="122" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="122" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="122" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="122" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="122" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="122" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="122" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="70" y="148" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="148" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="148" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="148" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="148" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="148" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="148" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="70" y="174" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="174" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="174" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="174" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="174" width="26" height="26" fill="var(--fig-blue)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="174" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="174" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="70" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="200" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="70" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="96" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="148" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="174" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="200" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="226" y="226" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="122" y="122" width="78" height="78" fill="none" stroke="var(--fig-blue)" stroke-width="2.4"/>
<text class="diagram-note" fill="var(--fig-gold)" x="161.0" y="30" text-anchor="middle" font-size="13px">输入 7×7（金色虚线 = padding=1）</text>
<text class="diagram-note" fill="var(--fig-blue)" x="44" y="319.6" text-anchor="middle" font-size="12.5px">一次窗口 = 输出的一个像素</text>
<rect x="420" y="90" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="446" y="90" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="472" y="90" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="420" y="116" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="446" y="116" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="472" y="116" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="420" y="142" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="446" y="142" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="472" y="142" width="26" height="26" fill="var(--fig-purple)" stroke="var(--line-strong)" stroke-width="1"/>
<text class="diagram-note" fill="var(--fig-purple)" x="459.0" y="74" text-anchor="middle" font-size="13px">卷积核 3×3</text>
<text class="diagram-note" fill="muted" x="459.0" y="186" text-anchor="middle" font-size="12.5px">逐位置相乘再求和</text>
<text class="diagram-mono" fill="muted" x="386" y="129.0" text-anchor="middle" font-size="20px">×</text>
<text class="diagram-note" fill="muted" x="386" y="147.2" text-anchor="middle" font-size="12px">滑动 s=2</text>
<rect x="620" y="100" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="646" y="100" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="672" y="100" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="698" y="100" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="620" y="126" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="646" y="126" width="26" height="26" fill="var(--fig-green)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="672" y="126" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="698" y="126" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="620" y="152" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="646" y="152" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="672" y="152" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="698" y="152" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="620" y="178" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="646" y="178" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="672" y="178" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="698" y="178" width="26" height="26" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1"/>
<rect x="646" y="126" width="26" height="26" fill="none" stroke="var(--fig-green)" stroke-width="2.4"/>
<text class="diagram-note" fill="var(--fig-green)" x="672" y="84" text-anchor="middle" font-size="13px">输出 4×4</text>
<line x1="512" y1="129.0" x2="604" y2="152" stroke="var(--fig-green)" stroke-width="2" marker-end="url(#mk-green)"/>
<rect x="420" y="240" width="420" height="116" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="630.0" y="302.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="630" y="264" text-anchor="middle" font-size="14px">W_out = ⌊(W_in − k + 2p)/s⌋ + 1</text>
<text class="diagram-mono" fill="var(--fig-green)" x="630" y="290" text-anchor="middle" font-size="14px">= ⌊(7 − 3 + 2·1)/2⌋ + 1 = 4</text>
<text class="diagram-mono" fill="ink" x="630" y="316" text-anchor="middle" font-size="13px">参数量 = k·k·C_in·C_out + C_out</text>
<text class="diagram-mono" fill="var(--fig-purple)" x="630" y="340" text-anchor="middle" font-size="12.5px">本例（C=1）：3·3·1·1 + 1 = 10</text>
</svg>
<figcaption>卷积的三个旋钮（本教程绘）：**核 k、步幅 s、填充 p**。蓝色高亮是当前感受窗口——它逐位置滑动（s=2 即每步跳两格），每个窗口给输出的一个像素（绿色）；金色虚线是 p=1 的补零。代入公式：⌊(7−3+2)/2⌋+1 = 4。能当场算出这一格，3.2 节就算过关。</figcaption>
</figure>

## 3.3 池化与下采样

卷积之后常接**池化（pooling）**：在一个小窗口里取一个统计量，把特征图缩小。

::: def 定义 3.4 · 池化 {#def-3-4}
在 $k\times k$（步幅通常等于 $k$）的窗口内：

- **最大池化（max pooling）**：取窗口内**最大值**，保留最强的激活。
- **平均池化（average pooling）**：取窗口内**平均值**，更平滑。

两者都把 $k\times k$ 的窗口压成 $1$ 个数，输出尺寸仍服从 $W_{out}=\lfloor(W_{in}-k+2p)/s\rfloor+1$（池化通常无参数）。
:::

::: intuition 池化为什么带来一定平移不变性
最大池化只回答"这个窗口里**有没有**某个特征"，不关心它在窗口内的**精确位置**。于是特征在窗口内挪动几个像素，池化输出可能完全不变——这就在局部给了平移鲁棒性。同时它缩小了特征图，让后面同样大小的核能覆盖更大的感受野，还顺带降低了计算量与显存。**代价**是丢弃了位置细节，这对"物体在哪"很关键的任务（如分割、检测的定位分支）不利，所以现代架构更倾向用**步幅卷积**替代池化，以保留可学习的位置信息。
:::

现代分类网络的结尾常用**全局平均池化（global average pooling）**：对每个通道的整张特征图取平均，直接得到长度等于通道数 $C_{out}$ 的向量，再接一层全连接做分类。它替代了传统的大展平 + 巨型全连接层，既**大幅减少参数**，又更不容易过拟合。

<figure>
<svg class="figure-svg" viewBox="0 0 880 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-convparams-title fig-convparams-desc">
<title id="fig-convparams-title">全连接与卷积的参数量和计算量对比（对数轴）</title>
<desc id="fig-convparams-desc">左：全连接一层（输入 150528 维到 1000 维）约 1.5 亿参数，卷积一层（3×3×64→64）约 3.7 万参数，相差四个数量级。右：两者的乘加计算量却同为亿级——卷积省参数但不省算力。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="103.9" y1="52" x2="103.9" y2="252"/><line x1="182.4" y1="52" x2="182.4" y2="252"/><line x1="261.0" y1="52" x2="261.0" y2="252"/><line x1="339.6" y1="52" x2="339.6" y2="252"/><line x1="418.1" y1="52" x2="418.1" y2="252"/><line x1="96" y1="252.0" x2="426" y2="252.0"/><line x1="96" y1="216.9" x2="426" y2="216.9"/><line x1="96" y1="181.8" x2="426" y2="181.8"/><line x1="96" y1="146.7" x2="426" y2="146.7"/><line x1="96" y1="111.6" x2="426" y2="111.6"/><line x1="96" y1="76.5" x2="426" y2="76.5"/></g>
<g><line x1="103.9" y1="252" x2="103.9" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="103.9" y="267" text-anchor="middle">-0.5</text><line x1="182.4" y1="252" x2="182.4" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="182.4" y="267" text-anchor="middle">0</text><line x1="261.0" y1="252" x2="261.0" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="261.0" y="267" text-anchor="middle">0.5</text><line x1="339.6" y1="252" x2="339.6" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="339.6" y="267" text-anchor="middle">1</text><line x1="418.1" y1="252" x2="418.1" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="418.1" y="267" text-anchor="middle">1.5</text><line x1="92" y1="252.0" x2="96" y2="252.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="256.0" text-anchor="end">10³</text><line x1="92" y1="216.9" x2="96" y2="216.9" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="220.9" text-anchor="end">10⁴</text><line x1="92" y1="181.8" x2="96" y2="181.8" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="185.8" text-anchor="end">10⁵</text><line x1="92" y1="146.7" x2="96" y2="146.7" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="150.7" text-anchor="end">10⁶</text><line x1="92" y1="111.6" x2="96" y2="111.6" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="115.6" text-anchor="end">10⁷</text><line x1="92" y1="76.5" x2="96" y2="76.5" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="80.5" text-anchor="end">10⁸</text><rect x="96" y="52" width="330" height="200" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="56.0" y="152.0" text-anchor="middle" transform="rotate(-90 56.0 152.0)">参数量（对数轴）</text></g>
<rect x="147.9" y="70.3" width="69.1" height="181.7" fill="var(--fig-red)" fill-opacity="0.30" stroke="var(--fig-red)" stroke-width="1.4"/>
<text class="diagram-mono" x="182.4" y="64.3" text-anchor="middle">150,528,000</text>
<text class="diagram-note" x="182.4" y="269.0" text-anchor="middle">全连接 150528→1000</text>
<rect x="305.0" y="197.0" width="69.1" height="55.0" fill="var(--fig-green)" fill-opacity="0.30" stroke="var(--fig-green)" stroke-width="1.4"/>
<text class="diagram-mono" x="339.6" y="191.0" text-anchor="middle">36,928</text>
<text class="diagram-note" x="339.6" y="269.0" text-anchor="middle">卷积 3×3×64→64</text>
<text class="diagram-note" fill="var(--ink)" x="261.0" y="30.0" text-anchor="middle" font-weight="700">参数量：相差 4 个数量级</text>
<g class="diagram-grid"><line x1="527.1" y1="52" x2="527.1" y2="252"/><line x1="598.6" y1="52" x2="598.6" y2="252"/><line x1="670.0" y1="52" x2="670.0" y2="252"/><line x1="741.4" y1="52" x2="741.4" y2="252"/><line x1="812.9" y1="52" x2="812.9" y2="252"/><line x1="520" y1="252.0" x2="820" y2="252.0"/><line x1="520" y1="206.5" x2="820" y2="206.5"/><line x1="520" y1="161.1" x2="820" y2="161.1"/><line x1="520" y1="115.6" x2="820" y2="115.6"/><line x1="520" y1="70.2" x2="820" y2="70.2"/></g>
<g><line x1="527.1" y1="252" x2="527.1" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="527.1" y="267" text-anchor="middle">-0.5</text><line x1="598.6" y1="252" x2="598.6" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="598.6" y="267" text-anchor="middle">0</text><line x1="670.0" y1="252" x2="670.0" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="670.0" y="267" text-anchor="middle">0.5</text><line x1="741.4" y1="252" x2="741.4" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="741.4" y="267" text-anchor="middle">1</text><line x1="812.9" y1="252" x2="812.9" y2="256" stroke="var(--ink-2)"/><text class="fg-muted" x="812.9" y="267" text-anchor="middle">1.5</text><line x1="516" y1="252.0" x2="520" y2="252.0" stroke="var(--ink-2)"/><text class="fg-muted" x="513" y="256.0" text-anchor="end">0</text><line x1="516" y1="70.2" x2="520" y2="70.2" stroke="var(--ink-2)"/><text class="fg-muted" x="513" y="74.2" text-anchor="end">200,000,000</text><rect x="520" y="52" width="300" height="200" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="480.0" y="152.0" text-anchor="middle" transform="rotate(-90 480.0 152.0)">乘加次数</text></g>
<rect x="567.1" y="115.2" width="62.9" height="136.8" fill="var(--fig-red)" fill-opacity="0.30" stroke="var(--fig-red)" stroke-width="1.4"/>
<text class="diagram-mono" x="598.6" y="109.2" text-anchor="middle">1.5 亿</text>
<text class="diagram-note" x="598.6" y="269.0" text-anchor="middle">全连接一层</text>
<rect x="710.0" y="146.9" width="62.9" height="105.1" fill="var(--fig-green)" fill-opacity="0.30" stroke="var(--fig-green)" stroke-width="1.4"/>
<text class="diagram-mono" x="741.4" y="140.9" text-anchor="middle">1.2 亿</text>
<text class="diagram-note" x="741.4" y="269.0" text-anchor="middle">卷积一层</text>
<text class="diagram-note" fill="var(--ink)" x="670.0" y="30.0" text-anchor="middle" font-weight="700">计算量：同一量级</text>
<text class="diagram-note" fill="var(--muted)" x="670.0" y="292.0" text-anchor="middle" font-size="13px">卷积省参数、不省算力 → GPU 的用武之地</text>
</svg>
<figcaption>卷积「省参数、不省算力」（本教程按 3.1–3.2 节的例子计算绘制；左为参数量对数轴、右为乘加次数）。权值共享把参数压掉 4 个数量级，但滑窗在每个位置都要算一遍——这正是视觉网络「吃显存更吃算力」、GPU 与算子优化成为刚需的原因。</figcaption>
</figure>

## 3.4 经典网络演进：AlexNet → VGG → ResNet

把"卷积 + 激活 + 池化"堆起来，就是 CNN。三代经典网络的贡献，恰好对应三个关键工程问题。

**AlexNet**：证明深度 CNN 在图像分类上可行，是视觉深度学习的引爆点。它的贡献是一套**可训练的配方**：用 **ReLU** 替代饱和激活加速收敛；用 **Dropout** 抑制过拟合；用**数据增强**（翻转、裁剪）人工扩大数据；用 **GPU** 承担卷积的海量计算。它的结构是「卷积 + 池化」堆叠后接若干全连接层——注意结尾仍带着**大全连接**，参数量大头在这里。

**VGG**：把结构**规整化**——反复用 **$3\times3$ 小卷积堆叠**，配 $2\times2$ 池化逐级下采样，通道数逐段翻倍。它的洞见是 3.4 节算过的：**小核堆叠 = 同等感受野 + 更少参数 + 更多非线性**。VGG 证明「**深度本身**」是关键变量，也让"用预训练 VGG 提特征"一度成为标配。

**ResNet**：把网络做到上百层。人们发现：单纯加深到某个程度后，**训练误差反而上升**——这不是过拟合（训练误差也升），而是**退化（degradation）**问题——更深网络的优化景观更难走。ResNet 用一个极简的改动解决它：**残差连接**。

::: def 定义 3.5 · 残差块与残差连接 {#def-3-5}
一个残差块把「直接学目标映射」改成「学**残差**再加回输入」：

$$y=F(x)+x,$$

其中 $x$ 是块输入，$F$ 是该块内若干卷积层的输出，$x$ 经**恒等映射**（identity，$+x$ 这条跳连，shortcut / skip connection）直接加到输出上。当空间尺寸或通道数不匹配时，$F(x)+x$ 这一项用**线性投影** $W_s x$ 对齐，即 $y=F(x)+W_s x$。
:::

::: prop 命题 3.2 · 残差为何缓解退化、让梯度直通 {#prop-3-2}
(i) **恒等映射易学**：若某层的最优行为是"什么都不做"，普通网络要学着逼近恒等映射 $y\approx x$（一堆非线性层拼出恒等并不容易）；残差块只需把 $F$ 学成 $\approx0$，因为 $y=F(x)+x\approx x$ 已通过跳连免费得到，优化起点天然靠近恒等。

(ii) **梯度直通**：设损失 $\mathcal L$，由链式法则

$$\frac{\partial\mathcal L}{\partial x}=\frac{\partial\mathcal L}{\partial y}\cdot\frac{\partial y}{\partial x}=\frac{\partial\mathcal L}{\partial y}\Bigl(I+\frac{\partial F}{\partial x}\Bigr)=\underbrace{\frac{\partial\mathcal L}{\partial y}}_{\text{直通项}}+\frac{\partial\mathcal L}{\partial y}\frac{\partial F}{\partial x} .$$

那个 $I$ 让梯度有一条**不经过任何非线性层的恒等通路**直接回传，即使 $\partial F/\partial x$ 很小（深层里常见），直通项也保证梯度不会整体消失。这是 ResNet 能稳定训练上百层网络的核心机制。
:::

::: intuition 残差思想的普适性
"学增量、留一条恒等旁路"不是视觉专属：Transformer 的每个子层都是 `x + Sublayer(x)` 的残差形式，扩散模型的去噪网络、各种深度骨干都沿用同一配方。可以说，残差连接是**让"深"从难训变成可训**的一个通用工程答案。它也呼应了第 1 讲对梯度消失的讨论——ReLU 解决单层不饱和，残差解决跨多层连乘衰减。
:::

| 网络 | 关键贡献 | 深度 | 该记住的一句话 |
|:--|:--|:--|:--|
| **AlexNet** | ReLU + Dropout + 数据增强 + GPU | 较浅，含大全连接 | 深度 CNN 可训起来的「配方」奠基 |
| **VGG** | $3\times3$ 小核堆叠、结构规整 | 十几到十九层 | 小核堆叠 = 同感受野、更省参数、更多非线性 |
| **ResNet** | **残差连接** $y=F(x)+x$ | 数十到上百层 | 残差解决退化，使超深网络可训 |

<figure>
<svg class="figure-svg" viewBox="0 0 900 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-resnet-title fig-resnet-desc">
<title id="fig-resnet-title">普通块与残差块：恒等捷径让梯度直通</title>
<desc id="fig-resnet-desc">左：普通块把输入完全经过两层变换；右：残差块额外引入恒等捷径，输出 y = F(x) + x。反向传播时梯度可经加法直接流回输入，深网络因此可训练。</desc>
<defs></defs>
<text class="diagram-note" fill="var(--fig-red)" x="80" y="34" text-anchor="start" font-weight="700">普通块：y = F(x)</text>
<rect x="90" y="90" width="80" height="44" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-mono" x="130.0" y="116.5" text-anchor="middle" font-size="15px">x</text>
<line x1="172" y1="112" x2="232" y2="112" stroke="var(--fig-red)" stroke-width="1.7" marker-end="url(#mk-red)"/>
<rect x="234" y="90" width="130" height="44" rx="9" fill="var(--fig-red)" fill-opacity="0.1" stroke="var(--fig-red)" stroke-width="1.5"/>
<text class="diagram-mono" x="299.0" y="116.5" text-anchor="middle" font-size="13px">层₁ → ReLU</text>
<line x1="366" y1="112" x2="426" y2="112" stroke="var(--fig-red)" stroke-width="1.7" marker-end="url(#mk-red)"/>
<rect x="428" y="90" width="130" height="44" rx="9" fill="var(--fig-red)" fill-opacity="0.1" stroke="var(--fig-red)" stroke-width="1.5"/>
<text class="diagram-mono" x="493.0" y="116.5" text-anchor="middle" font-size="13px">层₂</text>
<line x1="560" y1="112" x2="610" y2="112" stroke="var(--fig-red)" stroke-width="1.7" marker-end="url(#mk-red)"/>
<text class="diagram-mono" fill="ink" x="620" y="117" text-anchor="start" font-size="15px">y</text>
<text class="diagram-note" fill="muted" x="350" y="176" text-anchor="middle" font-size="13px">梯度必须穿过两层变换</text>
<text class="diagram-note" fill="muted" x="350" y="194" text-anchor="middle" font-size="13px">（深了就衰减 → 退化问题）</text>
<text class="diagram-note" fill="ink" x="80" y="234" text-anchor="start" font-weight="700"></text>
<rect x="90" y="188" width="80" height="44" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-mono" x="130.0" y="214.5" text-anchor="middle" font-size="15px">x</text>
<line x1="172" y1="210" x2="232" y2="210" stroke="var(--fig-blue)" stroke-width="1.7" marker-end="url(#mk-blue)"/>
<rect x="234" y="188" width="130" height="44" rx="9" fill="var(--fig-blue)" fill-opacity="0.1" stroke="var(--fig-blue)" stroke-width="1.5"/>
<text class="diagram-mono" x="299.0" y="214.5" text-anchor="middle" font-size="13px">F(x)：两层</text>
<line x1="366" y1="210" x2="426" y2="210" stroke="var(--fig-blue)" stroke-width="1.7" marker-end="url(#mk-blue)"/>
<circle cx="446" cy="210" r="15" fill="var(--fig-green)" fill-opacity="0.10" stroke="var(--fig-green)" stroke-width="1.6"/>
<text class="diagram-mono" x="446" y="214.5" text-anchor="middle" font-size="17px">+</text>
<path d="M 130 186 C 130 124 400 124 446 192" fill="none" stroke="var(--fig-green)" stroke-width="2" stroke-dasharray="6 4" marker-end="url(#mk-green)"/>
<text class="diagram-note" fill="var(--fig-green)" x="288" y="118" text-anchor="middle" font-size="13px">恒等捷径（skip connection）</text>
<line x1="462" y1="210" x2="512" y2="210" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="522" y="215" text-anchor="start" font-size="14.5px">y = F(x) + x</text>
<text class="diagram-note" fill="muted" x="470" y="254" text-anchor="middle" font-size="13px">∂y/∂x = ∂F/∂x + I：多了恒等项，</text>
<text class="diagram-note" fill="muted" x="470" y="272" text-anchor="middle" font-size="13px">梯度可「抄近路」直通浅层</text>
</svg>
<figcaption>残差连接（本教程绘）。上：普通块的梯度必须穿过每层变换，深层连乘后衰减，网络越深训练误差反而越高（**退化**，不是过拟合）；下：捷径 x 直接汇入输出，∂y/∂x = ∂F/∂x + I 多了个恒等项——梯度永远有通路，上百层的网络由此可训练（3.4 节）。</figcaption>
</figure>

## 3.5 迁移学习：别从零开始

在视觉任务里，**从随机初始化开始训练**（training from scratch）几乎总是下策。原因是：

- 大规模图像数据集（如 ImageNet）上预训练的卷积核，学到的是**通用视觉基元**——浅层是边缘、角点、颜色斑块，中层是纹理、部件，深层才偏向具体类别。这些浅层特征对绝大多数视觉任务都适用。
- 自己的任务往往**数据少**，从零训练必然过拟合；而预训练权重提供了一个**离解很近的起点**，小数据也能收敛出好结果。

::: def 定义 3.6 · 迁移学习 {#def-3-6}
把在**源任务**（如大规模图像分类）上预训练好的网络参数，迁移到**目标任务**上，作为初始化，再在目标任务数据上继续训练。常见两种策略：

- **特征提取（冻结）**：把预训练网络当作固定的特征提取器，**冻结**（freeze）其权重（不让梯度更新），只训练新加的**分类头**。适合目标数据很少、与源任务相近。
- **微调（fine-tuning）**：**解冻**部分或全部层（通常是最深的若干层），用小学习率继续训练，让特征适配新任务。适合目标数据较多、与源任务差异较大。
:::

::: method 迁移学习实操流程
```text
1. 选一个在大规模数据上预训练的骨干（如 ResNet），载入其权重
2. 换掉原分类头，替换为适配自己类别数的新头（随机初始化）
3. 第一轮：冻结骨干，只训新头（让它先学会读特征）——学习率可大些
4. 第二轮：解冻骨干后段（或全部），用更小的学习率联合微调
5. 常见技巧：骨干学习率比新头小 10 倍左右；配合数据增强、早停
```
**判别表**：目标数据**少且相似** → 只训头（冻结）；**少但差异大** → 只微调后段、防过拟合；**多且相似** → 微调全网络；**很多且差异很大** → 可考虑从零训练或大改结构。
:::

::: think 为什么迁移学习是工程默认
它同时满足工程的三个诉求：**省数据**（少样本也能用好模型）、**省算力**（不必每人重训一个骨干）、**更稳**（预训练权重是已被验证的优良初始化，训练更不容易翻车）。所以真实项目里，"下载预训练权重 → 换头 → 微调"应当是你的**第一反应**，而"从零搭一个网络"是最后手段。这条思路在 [第 6 讲](lec06.md)的大模型时代被推到极致——微调一个大语言模型正是同一个逻辑（见 [Lab 3](../labs/lab3.md)）。
:::

## 3.6 检测与分割：分类之外的任务

分类回答"图里**是什么**"，但很多应用要的是"**在哪里**、**每个像素是什么**"。

| 任务 | 输出 | 典型方法 |
|:--|:--|:--|
| **图像分类** | 整图一个类别 | CNN + 全局池化 + 分类头 |
| **目标检测** | 若干**框** + 每个框的类别 | 两阶段 R-CNN 系 / 单阶段 YOLO |
| **语义分割** | 每个**像素**的类别（不区分同类实例） | FCN、U-Net |
| **实例分割** | 每个**实例**的像素级掩码 | Mask R-CNN |

**从分类到「定位 + 分类」**。最朴素的想法是**滑动窗口**：用一个固定大小的窗口在图上逐位置、逐尺度滑动，每滑到一处就裁出窗口、送进 CNN 分类器判断"这里有没有目标"。它概念直白、易于实现，但要对每个位置每个尺度都跑一次网络，**极其低效**——这既是它的教学价值，也直接引出更聪明的做法。

**目标检测**有两条主流路线：

- **两阶段（two-stage）**：先由**区域提议（region proposal）**找出可能含目标的候选框（可能有上千个），再对每个候选框做**分类 + 回归边界框**。代表是 **R-CNN 家族**——R-CNN 起初对每个提议框单独跑 CNN，代价高；后续的 Fast / Faster R-CNN 通过共享卷积特征、把提议网络也做成可学习的模块，大幅提速。两阶段通常精度高、速度慢。
- **单阶段（one-stage）**：不做独立的提议步骤，直接在一次前向中于密集的位置上同时预测类别和框。代表是 **YOLO**（You Only Look Once）。单阶段结构更简单、速度更快，适合实时场景，早期精度略逊于两阶段，后续不断改进。

**语义分割**把分类做到像素级。**FCN（全卷积网络）** 把分类网络尾部的全连接层换成卷积，使网络能接受任意尺寸输入并输出**同分辨率的稠密预测**特征图；由于中间下采样会丢分辨率，再用**上采样 / 转置卷积**把它放大回原尺寸。**U-Net** 采用**编码器-解码器**结构，并在对应尺度间加**跳连**，把编码器保留的高分辨率细节直接送给解码器，对医学影像等精细边界任务是经典选择。

**实例分割**要区分「同一类的不同个体」，因此需要**逐实例的掩码**。**Mask R-CNN** 在 Faster R-CNN 的检测分支旁**并联一个掩码分支**，为每个候选框输出一个像素级掩码，同时完成检测与实例分割。

::: note 别把三种「分割」混为一谈
**语义分割**只标类别：两只猫都是同一个"猫"标签，无法区分。**实例分割**区分类别**且**区分个体：第一只猫与第二只猫是不同实例，各有一块掩码。**全景分割**再进一步，把"可数的东西"（实例）与"不可数的背景"（天空、道路）统一标注。任务定义不同，评价指标与网络结构也随之不同。
:::

## 3.7 伦理与安全：视觉模型的暗面

视觉模型的强大，来自它对数据先验的拟合——因此它也会**忠实继承甚至放大数据的缺陷**。

- **数据集的人口统计偏见会被放大**。图像数据集的采集与标注带有历史性的不均衡：某些肤色、性别、地域、年龄的样本偏少。模型在这些群体上表现显著变差，而部署到人脸识别、招聘筛选、医疗影像等场景时，这种差距会直接变成**不公平的决策**。更糟的是，若用模型输出反过来生成训练数据或做筛选，偏见会被**正反馈放大**。
- **对抗样本**。一个对人有用的模型，可能对**人眼几乎不可察的微小扰动**极其敏感：在图像上加一层精心设计的噪声，肉眼看着一模一样，分类器却可能给出完全错误的标签。这说明模型的决策依据与人的**语义感知并不一致**，也意味着靠肉眼审查输出来保证安全是不可靠的。
- **隐私与监控**。人脸识别、行人重识别、行为分析等技术可以大规模、无感地识别与追踪个人。技术本身有其正当用途（如安防、无障碍），但它对**隐私、知情同意与滥用风险**提出了尖锐问题：谁有权采集、存储、比对生物特征数据？误识别导致的后果由谁承担？

::: def 定义 3.7 · 对抗样本（adversarial example） {#def-3-7}
给定已训练的分类器 $f$ 与输入 $x$（正确标签为 $y$），对抗样本指 $x'=x+\delta$，其中扰动 $\delta$ 的幅度**小到人眼几乎无法分辨**（常用 $\lVert\delta\rVert$ 约束），却使 $f(x')\neq y$（通常是被判成攻击者指定的类别）。这类扰动通常可以**跨模型迁移**——在一模型上生成的对抗样本，也可能骗过结构相近的另一模型。
:::

::: think 把伦理当工程约束，而不是事后补丁
正确的做法不是"先做出模型再讨论伦理"，而是把它当作**设计约束**贯穿全程：**数据上**主动检查与补齐各人口统计子群的代表性，并在**分群指标**上评估而非只看总体平均；**模型上**用对抗训练、输入净化、置信度校准等手段提升鲁棒性；**流程上**明确告知数据用途、最小化采集生物特征、建立误判的申诉与追责机制。技术上"能识别"不等于伦理上"该部署"。
:::

## 3.8 课堂应用导读：Lab 2 人脸检测系统

[Lab 2](../labs/lab2.md) 把本讲的零件组装成一个**人脸检测系统**，核心正是**滑动窗口 + CNN**：

1. **数据**：一组带框的人脸图像；把图像切成许多固定大小的窗口，含人脸的窗口做**正样本**，不含的（及艰难负样本）做**负样本**，构成分类器的训练集。
2. **模型**：一个小型 CNN 分类器，输入一个窗口，输出"是 / 不是人脸"的概率——这就是 3.6 节滑动窗口检测器的可训练核心。
3. **训练**：用第 1 讲的正则化配方（Dropout、早停、数据增强）训练，关注验证集表现，防止在负样本上过拟合。
4. **推理**：在多尺度上滑动窗口，对每个窗口打分；把高分窗口通过**非极大值抑制（NMS）**去重，得到最终人脸框。

你会亲手体会到滑动窗口的**低效**（要对大量窗口重复前向），从而理解为什么后来的检测器要共享特征、要单阶段——**这正是从"课堂实现"走向"现代检测器"的动机**。Lab 里也安排了对抗样本与隐私的讨论环节，把 3.7 节的议题落到代码上。

::: preview 与第 4、6 讲的连接
本讲的卷积骨干是后续一切视觉系统的底座：第 6 讲的**多模态模型**用视觉编码器把图像映射成与文本同空间的表示；第 4 讲的**扩散模型**用（通常是卷积或 Transformer 的）去噪网络在像素空间上工作。理解了「局部性 + 层次化特征 + 残差」，你就掌握了这些系统的视觉半边。
:::

## 3.9 本讲陷阱

::: errata 常见误解清单
1. **"卷积"到底翻不翻核**：深度学习的卷积实现的是**互相关**，不翻转核；名字叫卷积只是历史约定，别在推导时多此一举地翻转。
2. **通道对不上**：多层卷积里，**核的输入通道数必须等于上一层输出通道数**，输出通道数等于**核的个数**。形状报错十有八九是这里。
3. **步幅与填充一起乱设**：输出尺寸一定用 $W_{out}=\lfloor(W_{in}-k+2p)/s\rfloor+1$ 验算；想要尺寸不变，$s=1$ 时取 $p=\lfloor k/2\rfloor$（奇数核）。别凭感觉。
4. **以为卷积参数量跟图像大小有关**：参数量 $=C_{out}C_{in}k^2+C_{out}$，**与 $H\times W$ 无关**；图像变大只增加**计算量**，不增加参数。
5. **把"更深"等同于"更好"**：不加残差地盲目加深会**退化**（训练误差也升，见 3.4 节），这不是过拟合，靠加正则救不了，得靠残差/归一化等结构手段。
6. **混淆等变与不变**：卷积给的是**等变**，分类需要的**不变**要靠池化 / 全局池化来获得，别把两者当同一回事。
7. **从零训练自己的视觉模型**：除非数据极大且与通用图像分布差异很大，否则**先上预训练权重再微调**（3.5 节）。从零训练是最后手段。
8. **只看总体指标**：人脸/医学等敏感场景必须做**分群评估**，否则总体准确率会掩盖对特定人群的系统性失败（3.7 节）。
9. **把滑动窗口当现代检测器**：滑动窗口是**教学起点**，现代检测靠区域提议或单阶段密集预测 + NMS，效率与精度都不同量级。
:::

## 3.10 本讲小结

**三句话带走**：

1. 卷积用**局部连接 + 权值共享**的归纳偏置，把图像的空间先验与平移等变写进结构，从而用极少参数处理大图；**输出尺寸**与**参数量/计算量**两个公式必须能随手手算。
2. **池化 / 下采样**扩大感受野并带来局部平移不变，**小核堆叠**以更低代价换更大感受野，**残差连接** $y=F(x)+x$ 让超深网络可训——这三件事共同构成现代视觉骨干的骨架。
3. 工程上**先迁移再微调**是默认起点；任务从分类扩展到**检测（两阶段 / 单阶段）与分割（语义 / 实例）**；而偏见、对抗样本与隐私要求把**伦理当作设计约束**，全程评估、分群评估。

**与后续的连接**：[第 1 讲](lec01.md)给了「结构 + 损失 + 梯度下降 + 反向传播」的通用范式，本讲把它落到图像上；[第 2 讲](lec02.md)是另一条支线（序列与注意力），两讲的骨干在第 6 讲的多模态模型里汇合；[第 4 讲](lec04.md)的生成模型常在视觉骨干上工作；[第 6 讲](lec06.md)的视觉-语言模型正是"预训练 + 迁移"思路在大规模多模态上的延伸；动手部分见 [Lab 2 · 人脸检测系统](../labs/lab2.md)。
