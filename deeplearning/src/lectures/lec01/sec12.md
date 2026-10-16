# 1.2 多层感知机与通用逼近

[1.1 节](sec11.md)的结论是：**单个神经元划一刀，只能处理线性可分的数据**，而 XOR 是这条边界的最小反例。节末留了一句断言——出路是「先变换、再切分」。这一节要把这句话兑现成一台可以计算的机器：把单元堆成**层**，把层堆成**网络**，然后回答三个问题。

第一，这台机器的**前向计算长什么样**，一批数据进来，每一层的张量形状怎么变？这不是形式主义：据统计，初学阶段的报错里绝大多数是形状不对，而形状推演是唯一不用运行代码就能定位它们的技能。

第二，堆起来之后**表达能力涨到了什么程度**？通用逼近定理（universal approximation theorem）会给出一个让人安心的答案，但它附带的条件常被简化成「大网络什么都能拟合」。本节会把它的**边界**完整写出来。

第三，既然「大」不解决一切，那**深度和宽度哪个更划算**、参数该**初始化成什么分布**？这两问直接决定网络能不能训起来。

## 1.2.1 从单元到层：MLP 的前向定义

::: def 定义 1.2.1 · 多层感知机（multi-layer perceptron, MLP） {#def-1.2.1}
设输入 $\boldsymbol x\in\mathbb R^{d_0}$，网络共 $L$ 层，第 $l$ 层宽度为 $d_l$。取 $\boldsymbol a^{(0)}=\boldsymbol x$，对 $l=1,\dots,L$：

$$\boldsymbol z^{(l)}=\boldsymbol a^{(l-1)}W^{(l)}+\boldsymbol b^{(l)},\qquad \boldsymbol a^{(l)}=\phi\bigl(\boldsymbol z^{(l)}\bigr),$$

其中 $W^{(l)}\in\mathbb R^{d_{l-1}\times d_l}$、$\boldsymbol b^{(l)}\in\mathbb R^{d_l}$、$\phi$ 为逐元素（elementwise）作用的激活函数。$\boldsymbol z^{(l)}$ 称**预激活**（pre-activation），$\boldsymbol a^{(l)}$ 称**激活**；$l=1,\dots,L-1$ 的层称**隐藏层**（hidden layer），第 $L$ 层输出即预测 $\hat{\boldsymbol y}=\boldsymbol a^{(L)}$。全部可训练参数为 $\theta=\{W^{(l)},\boldsymbol b^{(l)}\}_{l=1}^{L}$。
:::

::: intuition 层是什么：一次「仿射变换 + 一次逐元素弯曲」
一层做两件事：先用 $W$ 把上一层的 $d_{l-1}$ 维特征**线性重组**成 $d_l$ 维新特征，再用 $\phi$ 把每个坐标**单独弯曲**一次。矩阵乘法负责「混」，激活函数负责「弯」。混而不弯，多层等于一层；弯而不混，每个坐标各自为政。二者交替出现，网络才有能力逐层重构表示空间——[1.1.3](sec11.md)把 XOR 的两个「AND」单元手工设计出来了，MLP 的意思是：**这些中间特征由梯度自己学**。
:::

下面这个结论说明了 $\phi$ 为什么不能省，它是「深度有意义」的前提。

::: thm 定理 1.2.1 · 去掉非线性则深度退化 {#thm-1.2.1}
若定义 1.2.1 中取 $\phi$ 为恒等映射（$\phi(z)=z$），则对任意层数 $L$，整个网络等价于一个仿射变换：

$$\hat{\boldsymbol y}=\boldsymbol xW^{\star}+\boldsymbol b^{\star},\qquad W^{\star}=\prod_{l=1}^{L}W^{(l)},\quad \boldsymbol b^{\star}=\sum_{l=1}^{L}\boldsymbol b^{(l)}\prod_{j=l+1}^{L}W^{(j)} .$$

换句话说：**表达能力与单层相同，参数量却更多**。
:::

::: proof 证明（对层数归纳）
$L=1$ 时结论平凡。设前 $L-1$ 层已合成为仿射映射 $\boldsymbol a^{(L-1)}=\boldsymbol xW'+\boldsymbol b'$，则

$$\boldsymbol a^{(L)}=\bigl(\boldsymbol xW'+\boldsymbol b'\bigr)W^{(L)}+\boldsymbol b^{(L)}=\boldsymbol x\bigl(W'W^{(L)}\bigr)+\bigl(\boldsymbol b'W^{(L)}+\boldsymbol b^{(L)}\bigr),$$

仍是仿射映射，由此归纳得结论。$\blacksquare$
:::

::: intuition 为什么这条「去掉非线性就退化」的结论必须写下来
因为工程上它经常被违反而不被发现：调试时把激活层注释掉、或者用了一个在某些区间恒等（如 LeakyReLU 的某个错误实现）的激活，代码照跑不报错，损失也下降一点，但模型其实退化成了一个**带更多参数的线性回归**。它的症状很典型——训练损失降到某个平台后怎么都不动，且训练与验证损失几乎重合。记住判据：**只要网络里有至少一层非线性激活被跳过，深度的事就没发生。**
:::

## 1.2.2 前向与张量形状：批优先约定 {#sec-1.2.2}

真实训练一次处理一批样本。设批大小 $B$：

$$\boldsymbol Z^{(l)}=\boldsymbol A^{(l-1)}W^{(l)}+\mathbf 1\boldsymbol b^{(l)\mathrm T},\qquad \boldsymbol A^{(l)}=\phi\bigl(\boldsymbol Z^{(l)}\bigr),$$

其中 $\boldsymbol A^{(0)}=\boldsymbol X\in\mathbb R^{B\times d_0}$，$\mathbf 1$ 是全 $1$ 列向量（把偏置广播到批内每个样本）。偏置在批内的作用等价于同一个向量加到每一行——数学上可写成 $+\boldsymbol b$（按行广播），本书按行广播约定书写。

::: method 形状约定与逐层推演模板 {#method-1.2.1}
本书统一「**批优先**」：张量第 0 维是批维。逐层推演只需三条规则：

1. 线性层读入 $B\times d_{l-1}$、输出 $B\times d_{l}$，把**最后一维**换掉；
2. 逐元素激活**不改变形状**；
3. 只要不出现池化、卷积的 stride 等改变空间尺寸的算子，**批维 $B$ 全程不变**。

| 量 | 形状 | 说明 |
|:--|:--|:--|
| $\boldsymbol X$ | $B\times d_0$ | 一批输入，一行一个样本 |
| $W^{(l)}$ | $d_{l-1}\times d_l$ | 权矩阵；一列是第 $l$ 层一个单元的全部权重 |
| $\boldsymbol b^{(l)}$ | $d_l$ | 偏置（按行广播） |
| $\boldsymbol Z^{(l)},\boldsymbol A^{(l)}$ | $B\times d_l$ | 预激活与激活 |
| $\hat{\boldsymbol Y}$ | $B\times d_L$ | 预测（分类时再过 softmax） |

第 $l$ 层参数量为 $d_{l-1}d_l+d_l$，全网络参数总量为

$$P=\sum_{l=1}^{L}\bigl(d_{l-1}d_l+d_l\bigr).$$

注意 $P$ 与批大小 $B$ **无关**：批大小只影响激活值与显存，不影响模型容量。这一条是「显存估算」与「参数量估算」必须分开算的根本原因。
:::

::: ex 例 1.2.1 · 两层 MLP 的形状与参数量 {#ex-1.2.1}
输入一个 mini-batch $\boldsymbol X\in\mathbb R^{32\times784}$（32 张 $28\times28$ 灰度图展平）。结构：`Linear(784,128) → ReLU → Linear(128,64) → ReLU → Linear(64,10)`。不运行代码，写出每层输出形状、该层参数量与总参数量；并说明批维在何处变化。

::: proof 解
记 $d_0=784,d_1=128,d_2=64,d_3=10$，$B=32$。

| 步骤 | 运算 | 输出形状 | 该层参数量 |
|:--|:--|:--|:--|
| 输入 | — | $32\times784$ | $0$ |
| Linear(784,128) | $\boldsymbol XW^{(1)}+\boldsymbol b^{(1)}$，$W^{(1)}\in\mathbb R^{784\times128}$ | $32\times128$ | $784\times128+128=100{,}480$ |
| ReLU | 逐元素 $\max(0,\cdot)$ | $32\times128$ | $0$ |
| Linear(128,64) | $W^{(2)}\in\mathbb R^{128\times64}$ | $32\times64$ | $128\times64+64=8{,}256$ |
| ReLU | 逐元素 | $32\times64$ | $0$ |
| Linear(64,10) | $W^{(3)}\in\mathbb R^{64\times10}$ | $32\times10$ | $64\times10+10=650$ |

总参数量 $P=100{,}480+8{,}256+650=109{,}386$。批维 $32$ 自始至终不变——三条规则的第 2、3 条在这里都只用到了「形状不变」这条性质。若把 $B$ 从 $32$ 改成 $256$，$P$ 一个数字都不变，变的只是各中间激活的形状（$256\times128$ 等）。$\blacksquare$
:::
:::

::: errata 形状推演最常见的四类错误
1. **忘记批维**：把 $\boldsymbol X$ 写成 $784$ 而不是 $B\times784$，于是和 $W$ 的乘法维度对不上。判据：只要看到「参数量随样本数变化」的结论，一定是把两层搞混了。
2. **$W$ 的方向写反**：约定 $W^{(l)}\in\mathbb R^{d_{l-1}\times d_l}$（前一维是输入维）。有的教材用转置约定，两套不能混用——混用的典型症状是形状「差一个转置」，而这在梯度推导里会变成两个完全不同的公式。
3. **把激活当成改变形状的算子**：激活永远是逐元素的，形状不变；改变形状的是池化、卷积、view/reshape 这类算子。
4. **偏置维度错**：偏置是 $d_l$ 而不是 $B\times d_l$；写成后者虽然广播后也能算，但在反向传播对 $\boldsymbol b$ 求导时会得到错误的批形状（正确做法是沿批维求和，见 [1.5.3](sec15.md)）。
:::

## 1.2.3 通用逼近定理与它的边界 {#sec-1.2.3}

单层网络的表达能力止于线性可分；一旦允许隐藏层，能力发生**质变**。

::: thm 定理 1.2.2 · 通用逼近定理（universal approximation, 陈述） {#thm-1.2.2}
设激活函数 $\phi$ 为非常数、有界、单调递增的连续函数（如 Sigmoid），$K\subset\mathbb R^{n}$ 为紧集，$f:K\to\mathbb R$ 连续。则对任意 $\varepsilon\gt0$，存在有限宽的单隐藏层网络

$$g(\boldsymbol x)=\sum_{i=1}^{m}v_i\,\phi\bigl(\boldsymbol w_i^{\mathrm T}\boldsymbol x+b_i\bigr),$$

使 $\sup_{\boldsymbol x\in K}\lvert f(\boldsymbol x)-g(\boldsymbol x)\rvert\lt\varepsilon$，即单隐藏层网络在紧集上对连续函数**一致逼近**。
:::

::: intuition 「能表示」≠「能学会」，这句话值一整节课
定理回答的是**表示问题**：给定一个函数，是否存在一组权重让网络输出接近它？它完全没有回答另外三个问题——(i) 这组权重的 $m$ 有多大（可能大得离谱）；(ii) 用梯度下降能否找到这组权重（优化问题是否可解）；(iii) 需要多少样本才能学到（统计问题）。把这三个问题当成「大网络自动解决」是本节最大的误读。正确的读法是：**它给架构选择提供了一个理论下限，同时把真正的问题推向优化与统计。**
:::

::: think 定理的边界：三条不能越过的线
1. **不保证宽度可寻。** 定理对 $m$ 的存在性是抽象的：固定精度 $\varepsilon$ 所需的 $m$ 可能随输入维度指数增长，实践中无法先验算出「需要多宽」。
2. **不保证可训练。** 存在性证明通常依赖「构造」（如阶梯函数的叠加），而构造出的权重往往对应损失曲面上极难到达的点；梯度下降找到的是它自己的解，不一定是定理保证的那一个。
3. **不保证样本效率。** 存在一组权重能拟合 $f$，不等于用有限样本训练能得到它。模型的**归纳偏置**（inductive bias，即结构对解的偏好）决定了它在该数据上「容易学到哪一类函数」——这才是 CNN / RNN / Transformer 存在的理由，也是[第 3 讲](../lec03/overview.md)「为什么是卷积」的出发点。
:::

::: note[skip] 延伸阅读 · 定理的谱系与后续
- Cybenko, *Approximation by Superpositions of a Sigmoidal Function*（1989）——Sigmoid 激活下的一致逼近定理原始论文。
- Hornik, Stinchcombe & White, *Multilayer Feedforward Networks are Universal Approximators*（1989）——把结论推广到更一般的激活类。
- Leshno et al., *Multilayer Feedforward Networks with a Nonpolynomial Activation Function Can Approximate Any Function*（1993）——把条件弱化为「激活非多项式」，这条解释了 ReLU 为什么也适用。
- Pinkus, *Approximation Theory of the MLP Model in Neural Networks*（1999，综述）——进一步讨论**逼近速率**（给定 $m$ 的误差界），比「存在性」更有工程意义。
:::

## 1.2.4 深度 vs 宽度：分段线性视角与表达效率

通用逼近定理对「单隐藏层」和「深网络」一视同仁，这容易让人误以为深没有额外价值。**深度的价值在于表达效率**：达到同样的逼近精度，深网络往往能用少得多的参数，或者说同样的参数量能表达更复杂的函数。

**ReLU 网络的分段线性视角。** 取 $\phi(z)=\max(0,z)$，则网络是输入的一个**分段线性（piecewise-linear）函数**：每个单元在它自己的超平面 $\boldsymbol w_i^{\mathrm T}\boldsymbol x+b_i=0$ 上「折」一次，网络把输入空间切成许多**多面体区域**（线性区域），在每个区域内网络退化为一个线性函数。

::: prop 命题 1.2.1 · 线性区域数量的增长 {#prop-1.2.1}
对输入维 $n$、$L$ 个 ReLU 隐藏层、每层宽度 $m$ 的网络，其线性区域数上界随深度**超线性**增长；对单隐藏层网络，区域数最多随宽度多项式增长。因此**深而窄的网络可以用线性量级的参数切出指数级别的区域，而宽而浅的网络需要指数级参数**——这是「深度优先」在表达效率上的定量依据。
:::

::: intuition 逐层折纸
把一个薄片的纸折一次得到 2 个区间；折 $k$ 次可以得到 $2^k$ 个区间，而纸还是那张纸。ReLU 的折点由各层的超平面决定，**第 $l$ 层的折点依赖于第 $l-1$ 层的折点**，所以折的次数是「层层复合」而不是「一次折很多下」——这正是深度比宽度便宜的原因。代价也来自同一处：层数越深，反向传播要连乘的导数越多，[1.3 节](sec13.md)将给出何时会连乘到消失。
:::

| 视角 | 单隐藏层（宽） | 多隐藏层（深） | 工程含义 |
|:--|:--|:--|:--|
| 表达 | 一致逼近任何连续函数 | 同样可以，但更省参数 | 精度要求高时优先加深 |
| 区域数 | 随宽度多项式增长 | 随深度超线性 / 指数增长 | 复杂决策边界靠深度 |
| 优化 | 更接近凸问题，但宽度巨大 | 非凸性强，但参数少、正则性好 | 深网络更依赖初始化与归一化 |
| 实践 | 极少单独使用 | 现代默认 | 通用逼近是下限，不是设计目标 |

::: think 那还学通用逼近定理干什么
因为它给出的是**能力下限**，作用有三个：① 当某任务用任何网络都学不好时，可以排除「表达能力不够」这一类病因，转去查数据与优化；② 它解释了为什么 MLP 可以作为通用的「函数拟合器」，是后续所有架构（CNN、Transformer）输出头部分的默认组件；③ 它把「架构设计」这件事重新定义为**归纳偏置的选择**问题——既然任何函数都能表示，那架构的价值就在于「让目标函数变得容易学」，这正是第 2 讲的注意力与第 3 讲的卷积要回答的。
:::

## 1.2.5 初始化：为什么不能全零，也不能随便乱掷

::: method 初始化问题的由来与两组推荐公式 {#method-1.2.2}
**全零初始化的致命问题**：若某层所有权重与偏置都相同，则该层所有单元的预激活、激活、以及反向传播时的梯度**完全相同**（对称性不破），训练过程等价于「一个单元的层」——这叫**对称性问题**。因此初始化必须引入随机性。

**尺度问题**：随机还不够，尺度也要对。若权重方差过大，前向激活值逐层放大直至饱和或溢出；过小则逐层缩小直至下溢。目标是让**每层的激活方差与梯度方差大致保持不变**，即「方差守恒」。

| 初始化 | 增益（方差）公式 | 适配 | 动机 |
|:--|:--|:--|:--|
| **Xavier / Glorot** | $\operatorname{Var}(w)=\dfrac{2}{d_{\text{in}}+d_{\text{out}}}$ | Sigmoid / tanh 等对称饱和激活 | 同时守恒前向激活方差与反向梯度方差（两端的调和平均） |
| **Kaiming / He** | $\operatorname{Var}(w)=\dfrac{2}{d_{\text{in}}}$ | ReLU 及其变体 | ReLU 半区截断使方差减半，故把增益乘 2 补回 |

对应到框架里：`nn.init.xavier_uniform_`（均匀分布版本，上界为 $\sqrt{6/(d_{\text{in}}+d_{\text{out}})}$）与 `nn.init.kaiming_normal_(..., nonlinearity='relu')`。
:::

::: proof 方差守恒的推导（前向，单层、无偏置）
设 $z=\sum_{i=1}^{d_{\text{in}}}w_ix_i$，各 $x_i$ 独立同分布、均值 $0$、方差 $\sigma_x^2$，各 $w_i$ 独立同分布、均值 $0$、方差 $\sigma_w^2$ 且与 $x$ 独立。则

$$\operatorname{Var}(z)=\sum_{i=1}^{d_{\text{in}}}\operatorname{Var}(w_ix_i)=d_{\text{in}}\,\sigma_w^2\sigma_x^2 .$$

**要让 $\operatorname{Var}(z)=\sigma_x^2$，只需 $\sigma_w^2=1/d_{\text{in}}$。** 若还要照顾反向（梯度从 $d_{\text{out}}$ 侧回传，条件为 $\sigma_w^2=1/d_{\text{out}}$），两端折中即得 $\sigma_w^2=\dfrac{2}{d_{\text{in}}+d_{\text{out}}}$（Xavier）。对 ReLU：因 $\operatorname{Var}(\max(0,z))=\tfrac12\operatorname{Var}(z)$（零均值对称分布下），前向要把增益翻倍，得 $\sigma_w^2=\dfrac{2}{d_{\text{in}}}$（Kaiming）。$\blacksquare$
:::

::: intuition 初始化的本质是「增益守恒」
把它想成信号沿一条**衰减线**传播：每层都会把方差乘一个因子 $g$。若平均增益 $g\lt1$，$L$ 层后方差乘 $g^{L}$，信号湮灭；若 $g\gt1$，信号爆炸。初始化的任务就是把 $g$ 校准到 $1$ 附近。**这也是为什么归一化层可以部分替代精细初始化**——它每层都把尺度强行拉回来（见 [1.7.4](sec17.md)），而残差连接则给信号提供了一条增益恒为 $1$ 的旁路（[第 3 讲](../lec03/overview.md)）。
:::

::: errata 初始化的三个常见误解
1. **「随机小数值就行了」**：`randn()*0.01` 在浅层网络上看不出问题，在几十层网络上会让第一层几乎不动、最后一层的梯度爆炸。尺度不是风格问题，是数学问题。
2. **「Kaiming 初始化也能用在 Sigmoid 上」**：它把增益按 ReLU 的「半区截断」多乘了 2，配 Sigmoid 会系统性偏大；Sigmoid 应配 Xavier。
3. **「有了归一化层就不必管初始化」**：归一化让**前向**尺度稳定，但反向的梯度尺度仍与初始权重有关；实践中二者配合使用，而不是二选一。
:::

::: method 编译期错误与运行期错误的分类学 {#method-1.2.3}
形状错误分两类，处置方式完全不同：

| 类型 | 症状 | 典型原因 | 处置 |
|:--|:--|:--|:--|
| **编译期（直接报错）** | `mat1 and mat2 shapes cannot be multiplied`、`size mismatch` | 上一层的输出维与下一层的 `in_features` 不一致；`view/reshape` 后维度错了 | 按 [1.2.2](#sec-1.2.2) 的三条规则手写形状表，逐层对照 |
| **运行期（静默错误）** | 不报错但损失异常、精度上不去、某些样本恒错 | 把 $(B,d)$ 误转置为 $(d,B)$（方阵维度恰好能算通）；广播把 $B\times1$ 扩成了 $B\times d$；漏了 `Flatten` 导致空间维被当成特征维 | 打印每个中间张量的形状，并**断言**：`assert h.shape == (B, d_l)`；对可疑算子写单样本测试 |

**为什么第二类更危险**：它不产生任何报错，只是让模型「学得很差」。判据是「形状复核」而不是「看报错」。一个高性价比的习惯是：在模块的 `forward` 开头加一行 `assert x.dim() == 2 and x.shape[1] == self.in_features`，把静默错误变成显式错误。
:::

## 1.2.6 代码：形状推演做成断言，以及一次初始化对照

```python
import torch, torch.nn as nn

# ① 用 nn.Sequential 搭出例 1.2.1 的结构，并给每层起名以便对照形状推演表
model = nn.Sequential(
    nn.Flatten(),                 # 把 (B,1,28,28) 展平成 (B,784)：这一步不产生参数
    nn.Linear(784, 128), nn.ReLU(),
    nn.Linear(128, 64), nn.ReLU(),
    nn.Linear(64, 10),            # 输出 logits：不加 softmax（见 1.4 节的陷阱）
)

x = torch.randn(32, 1, 28, 28)
# ② 逐层手动前向，打印形状：把 1.2.2 的表变成可验证的断言
h = x
for name, layer in model.named_children():
    h = layer(h)
    print(f"{name:12s} {type(layer).__name__:10s} -> {tuple(h.shape)}")
# Flatten      (32, 784) / Linear (32, 128) / ReLU (32, 128) / ... / Linear (32, 10)

# ③ 参数量核对：应与手算的 109,386 一致
total = sum(p.numel() for p in model.parameters() if p.requires_grad)
print("params:", total)           # 输出 109386

# ④ 初始化对照：同一网络分别用 Kaiming 与「随手乘 0.01」初始化，看第一层激活的尺度
def init_with(model, kind):
    for m in model.modules():
        if isinstance(m, nn.Linear):
            if kind == "kaiming":
                # ReLU 网络的标准做法：a=0（fan_in 模式）等价于 Var=2/fan_in
                nn.init.kaiming_normal_(m.weight, nonlinearity="relu")
            else:
                # 反例：尺度与 fan_in 无关，层数一深就会整体衰减
                nn.init.normal_(m.weight, std=0.01)
            nn.init.zeros_(m.bias)     # 偏置初始化为 0 是安全的（对称性由权重打破）

init_with(model, "kaiming")
with torch.no_grad():
    a = model[0](x)                      # 展平后的输入
    for idx in range(1, 5):              # 过完两个 Linear+ReLU 组
        a = model[idx](a)
    print("kaiming 第一层激活 std:", a.std().item())   # 量级接近输入尺度，不塌缩

init_with(model, "naive")
with torch.no_grad():
    a = model[0](x)
    for idx in range(1, 5):
        a = model[idx](a)
    print("naive  第一层激活 std:", a.std().item())    # 明显更小：逐层衰减的直接证据
```

::: method 从形状推演到参数的「三步核对法」
1. **写表**：手算每个 Linear 的入 / 出维度与 $d_{l-1}d_l+d_l$ 参数量（例 1.2.1）。
2. **跑一遍打印形状**：用上面的循环打印 `tuple(h.shape)`，逐行比对——不匹配的那一层就是出错点。
3. **核对参数量**：`sum(p.numel())` 与手算总和比对。形状对但参数量不对，通常是漏了偏置或某层被写了两次。
:::

## 1.2.7 陷阱与勘误

::: errata 本节五个高频误解
1. **「通用逼近定理说明大网络能拟合任何东西」**：只说明**存在**这样的权重；宽度可能指数级、优化可能到不了、样本可能不够。三条边界缺一不可（[1.2.3](#sec-1.2.3)）。
2. **「深度只是宽度的高效替代，效果一样」**：在表达效率上不等价（[命题 1.2.1](#sec-1.2.3)），在优化条件数上也不同；深度带来的非凸性需要初始化、归一化、残差连接共同配合。
3. **「参数量大 = 模型强」**：容量只是必要条件。$P$ 与数据量、正则强度必须匹配（[1.7 节](sec17.md)），参数远超数据量时泛化靠的是正则与早停，不是参数量本身。
4. **「偏置可以全部初始化为随机值」**：偏置初始化为 $0$ 是标准做法；对称性由权重的随机性打破，偏置再随机只会引入额外噪声。
5. **「只要用了 `nn.Linear` 就自动做对了形状」**：框架只保证形状能算通，不保证语义正确。把 $(B,d)$ 的输入误转置成 $(d,B)$ 在方阵维度上也能算通，但训练结果会莫名其妙变差——这类错误只能靠「手算 + 打印」双轨核对发现。
:::

::: method 即时自测 · 1.2
**Q1** 给定输入 $B=64$、$d_0=100$，结构 `Linear(100,32) → tanh → Linear(32,1)`：写出每层输出形状与该层参数量，并给出总参数量。该网络中的非线性来自哪里？

**Q2** 用自己的话说明通用逼近定理保证了什么、没保证什么（至少说出两个「没保证」）。

**Q3** 一个 20 层、每层宽度 512 的 ReLU 网络，若所有层都用 `std=1e-3` 的正态初始化，预判前向激活的尺度会怎样变化？应改用哪个初始化公式？

**Q4** 为什么 ReLU 网络的初始化增益要比 Xavier 大一倍？

::: sol 参考要点
**Q1** 输入 $64\times100$；`Linear(100,32)` → $64\times32$，参数 $100\times32+32=3232$；`tanh` → $64\times32$（形状不变，参数 $0$）；`Linear(32,1)` → $64\times1$，参数 $32\times1+1=33$。总参数 $3232+33=3265$。非线性全部来自 $\tanh$；两个线性层若抽掉 $\tanh$ 会合成为一个 $100\times1$ 的线性映射（定理 1.2.1）。

**Q2** 保证：在紧集上存在一个**有限宽的单隐藏层**网络一致逼近任意连续函数（前提是激活为非常数、有界、单调递增的连续函数）。没保证：① 所需的宽度 $m$ 有多大（可能随维度指数增长）；② 用梯度下降能否找到这组权重；③ 需要多少训练样本。此外它只谈连续函数与一致逼近，不涉及泛化与鲁棒性。

**Q3** 每层的方差增益约为 $d_{\text{in}}\sigma_w^2=512\times10^{-6}\approx5\times10^{-4}$，即每层衰减约 2000 倍，20 层后前向信号下溢到几乎为零，反向梯度同量级衰减。应改用 Kaiming 正态初始化，$\operatorname{Var}(w)=2/d_{\text{in}}=2/512$，即 `std ≈ 0.0625`（`nn.init.kaiming_normal_(w, nonlinearity='relu')`）。

**Q4** ReLU 把输入的一半（负半区）截断为 $0$，在零均值对称的输入分布下使输出方差减半；要维持方差守恒，就得把权重增益翻倍，即从 $1/d_{\text{in}}$ 到 $2/d_{\text{in}}$。Xavier 的 $2/(d_{\text{in}}+d_{\text{out}})$ 则是在「前向守恒」与「反向守恒」两个条件之间取折中。
:::
:::

::: note[skip] 延伸阅读
- Hornik, Stinchcombe & White, *Multilayer Feedforward Networks are Universal Approximators*（1989）——本节点定理 1.2.2 的来源之一。
- Glorot & Bengio, *Understanding the Difficulty of Training Deep Feedforward Neural Networks*（2010）——Xavier 初始化的原始动机与实验。
- He, Zhang, Ren & Sun, *Delving Deep into Rectifiers: Surpassing Human-Level Performance on ImageNet Classification*（2015）——Kaiming 初始化（在 ReLU 网络上的方差推导）。
- Montúfar, Pascanu, Cho & Bengio, *On the Number of Linear Regions of Deep Neural Networks*（2014）——命题 1.2.1 所依据的分段线性分析。
:::

**本节小结**：MLP 的前向是「矩阵混 + 逐元素弯」交替 $L$ 次，形状推演只需三条规则（换掉最后一维、激活不改形状、批维不变），参数量与批大小无关。非线性一旦去掉，深度立即退化为单层（定理 1.2.1）。通用逼近定理保证存在性，但**不保证宽度可寻、可训练、样本高效**——真正的架构价值在于归纳偏置而非表达能力上限。最后，能不能训起来从第一秒就被**初始化尺度**决定：方差守恒给出 Xavier 与 Kaiming 两组公式。下一节转向那唯一的非线性来源——激活函数，它是深层网络能否训动的直接开关。
