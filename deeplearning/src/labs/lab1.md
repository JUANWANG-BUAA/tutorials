# Lab 1 · 深度学习入门与音乐生成

本实验对应第 1、2 讲：先用一层网络跑通「前向 → 损失 → 反向 → 更新」，熟悉张量与自动微分的用法；再用字符级 RNN 学习一段旋律的序列规律，从初始片段续写新乐句。全程不需要大数据集。

## 1. 环境与数据

- **运行环境**：Python 3.9+。本书示例用 PyTorch。官方 2026 年仓库 [MITDeepLearning/introtodeeplearning](https://github.com/MITDeepLearning/introtodeeplearning) 的 `lab1/` 同时给出 `PT_Part1_Intro.ipynb`、`PT_Part2_Music_Generation.ipynb` 和对应的 `TF_` 笔记本。TensorFlow 版本使用 **TensorFlow 2 的即时执行 + Keras**，不使用 `tf.Session` / `placeholder`。两个版本的计算图语义相同，但接口不同，不要直接把一套接口换名后抄到另一套里。
- **数据**：ABC 记谱（官方 Part 2 载入爱尔兰民间曲调，再以字符级 RNN 预测乐谱的下一个字符；曲目数量以实际数据版本为准）。基础练习可先截取少量曲目，研究挑战则使用完整导出语料并按曲目划分。把它看成 token 序列，与[第 2 讲](../lectures/lec02/overview.md)处理离散符号序列的方式相同。也可以使用 MIDI 事件序列，但这就不再是官方笔记本的任务。

::: note 小样本不等于作曲系统
本实验的目的是看清训练循环与序列模型的行为，不是训练一个能谱曲的模型。若基础练习只取几 KB 片段，模型可能主要学到局部的音符搭配与节奏模式；研究挑战使用完整语料，仍需通过留出曲目和对照判断它学到了什么。
:::

## 2. 第一部分：用自动微分训练一层网络

把一个简单函数（如 $y=\sin(3x)$ 在若干采样点上）当作回归问题，用一层网络拟合。**每一步都对应第 1 讲的四个动作**：

```python
import torch
from torch import nn

torch.manual_seed(17)
x = torch.linspace(-1, 1, 256).reshape(-1, 1)
y = torch.sin(3 * x)

model = nn.Sequential(nn.Linear(1, 64), nn.ReLU(), nn.Linear(64, 1))
opt = torch.optim.Adam(model.parameters(), lr=1e-2)
loss_fn = nn.MSELoss()

for step in range(2000):
    pred = model(x)          # ① 前向
    loss = loss_fn(pred, y)  # ② MSE（回归，见第 1 讲 1.4）
    opt.zero_grad()
    loss.backward()          # ③ 反向
    opt.step()               # ④ 更新
```

`zero_grad()` 放在 `backward()` 之前。PyTorch 默认把梯度**累加**到 `.grad` 上；顺序反了，这一步就会叠加上一步的梯度。官方笔记本用的也是 `torch.nn` 与 `torch.optim`，不是已经删除的 `torch.autograd.Variable`。

::: note 逐行对应的讲次
`model(x)` = [定义 1.1](../lectures/lec01/overview.md) 的前向；`loss_fn` = [定义 1.2](../lectures/lec01/overview.md) 的 MSE；`loss.backward()` = [定理 1.2](../lectures/lec01/overview.md) 的反向传播；`opt.step()` = [定义 1.3](../lectures/lec01/overview.md) 的梯度下降。这四步构成深度学习训练的基本框架，读代码时要能逐一对应。
:::

::: ex 观察题 · 去掉激活会怎样 {#lab1-q1}
把 `nn.ReLU()` 删掉再训一次，拟合效果如何？为什么？（提示：见[第 1 讲 1.2](../lectures/lec01/overview.md)的「线性变换 + 非线性」。）

::: proof 参考结论
拟合会退化——两层线性等价于一层线性，无法表达 $\sin$ 的弯曲。损失停留在一个较高的平台，加大训练步数也无济于事。这从反面印证了激活函数的作用。
:::
:::

## 3. 第二部分：字符级 RNN 生成旋律

**建模思路**（第 2 讲）：把旋律表示成 token 序列 $x_1,x_2,\dots,x_T$，模型在每个时刻读入当前 token（概念上可用 one-hot，下面代码用可学习的 embedding），输出**下一个 token 的概率分布** $\hat p(x_{t+1}\mid x_{\le t})$。

```python
class RNN(nn.Module):
    def __init__(self, vocab, hidden=128):
        super().__init__()
        self.emb = nn.Embedding(vocab, 32)
        self.rnn = nn.GRU(32, hidden, batch_first=True)   # 第 2 讲 2.3
        self.out = nn.Linear(hidden, vocab)
    def forward(self, x, h=None):
        z, h = self.rnn(self.emb(x), h)
        return self.out(z), h          # 每个时刻的下一 token logits

# 训练目标：交叉熵（分类损失，第 1 讲 1.4）
loss = nn.functional.cross_entropy(logits[:, :-1].reshape(-1, V), tokens[:, 1:].reshape(-1))
```

训练方式叫 **teacher forcing**：每个时刻用**真实**的上一 token 作为输入，预测下一个 token，与真值算交叉熵。

## 4. 生成：温度采样

生成时从初始片段开始，根据模型输出的分布采样出下一个 token，再把采样的 token 作为下一步输入（**自回归**）。采样用**温度** $\tau$ 调节：

$$\hat p_i=\frac{\exp(z_i/\tau)}{\sum_j\exp(z_j/\tau)}.$$

| 温度 | 分布形态 | 生成时可能观察到的现象 |
|:--|:--|:--|
| $\tau\to0$ | 若最大 logit 唯一，趋近该位置的 one-hot | 选择更集中，可能重复或单调 |
| $\tau=1$ | softmax 原分布 | 按训练模型的原分布采样 |
| $\tau\gt1$ | 更平坦 | 低概率字符出现机会增大，合法性和多样性须实测 |

::: intuition 温度在调"胆量"
低温度下，模型倾向于选择概率最高的音符，于是容易陷入循环（「总在同一个音上打转」）；高温度下，低概率音符被选中的机会增加，旋律更多变，但也可能出现训练数据里没有的音符组合。温度没有唯一的「正确值」，它用来调节生成风格。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 880 330" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-temp-title fig-temp-desc">
<title id="fig-temp-title">温度对采样分布的影响</title>
<desc id="fig-temp-desc">同一组 logits 在三个温度下的 softmax 分布。低温 0.5 时概率集中到最优音；温度 1 为原分布；高温 2 时分布被摊平，低概率音获得可观的质量。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="66.3" y1="40" x2="66.3" y2="230"/><line x1="132.1" y1="40" x2="132.1" y2="230"/><line x1="197.9" y1="40" x2="197.9" y2="230"/><line x1="263.7" y1="40" x2="263.7" y2="230"/><line x1="40" y1="230.0" x2="290" y2="230.0"/><line x1="40" y1="185.6" x2="290" y2="185.6"/><line x1="40" y1="141.3" x2="290" y2="141.3"/><line x1="40" y1="96.9" x2="290" y2="96.9"/><line x1="40" y1="52.5" x2="290" y2="52.5"/></g>
<g><line x1="66.3" y1="230" x2="66.3" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="66.3" y="245" text-anchor="middle">0</text><line x1="132.1" y1="230" x2="132.1" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="132.1" y="245" text-anchor="middle">2</text><line x1="197.9" y1="230" x2="197.9" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="197.9" y="245" text-anchor="middle">4</text><line x1="263.7" y1="230" x2="263.7" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="263.7" y="245" text-anchor="middle">6</text><line x1="36" y1="230.0" x2="40" y2="230.0" stroke="var(--ink-2)"/><text class="fg-muted" x="33" y="234.0" text-anchor="end">0</text><line x1="36" y1="141.3" x2="40" y2="141.3" stroke="var(--ink-2)"/><text class="fg-muted" x="33" y="145.3" text-anchor="end"></text><line x1="36" y1="52.5" x2="40" y2="52.5" stroke="var(--ink-2)"/><text class="fg-muted" x="33" y="56.5" text-anchor="end">1</text><rect x="40" y="40" width="250" height="190" fill="none" stroke="var(--line-strong)"/></g>
<rect x="55.8" y="226.5" width="21.1" height="3.5" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="66.3" y="245.0" text-anchor="middle">音0</text>
<text class="diagram-mono" x="66.3" y="221.5" text-anchor="middle">0.02</text>
<rect x="88.7" y="216.9" width="21.1" height="13.1" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="99.2" y="245.0" text-anchor="middle">音1</text>
<text class="diagram-mono" x="99.2" y="211.9" text-anchor="middle">0.07</text>
<rect x="121.6" y="74.3" width="21.1" height="155.7" fill="var(--fig-blue)" fill-opacity="0.85" stroke="var(--fig-blue)"/>
<text class="diagram-note" x="132.1" y="245.0" text-anchor="middle">音2</text>
<text class="diagram-mono" x="132.1" y="69.3" text-anchor="middle">0.88</text>
<rect x="154.5" y="229.9" width="21.1" height="0.1" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="165.0" y="245.0" text-anchor="middle">音3</text>
<text class="diagram-mono" x="165.0" y="224.9" text-anchor="middle">0.00</text>
<rect x="187.4" y="229.5" width="21.1" height="0.5" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="197.9" y="245.0" text-anchor="middle">音4</text>
<text class="diagram-mono" x="197.9" y="224.5" text-anchor="middle">0.00</text>
<rect x="220.3" y="230.0" width="21.1" height="0.0" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="230.8" y="245.0" text-anchor="middle">音5</text>
<text class="diagram-mono" x="230.8" y="225.0" text-anchor="middle">0.00</text>
<rect x="253.2" y="225.4" width="21.1" height="4.6" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="263.7" y="245.0" text-anchor="middle">音6</text>
<text class="diagram-mono" x="263.7" y="220.4" text-anchor="middle">0.03</text>
<text class="diagram-note" fill="var(--accent)" x="165.0" y="26.0" text-anchor="middle" font-weight="700">τ = 0.5（保守）</text>
<text class="diagram-note" fill="var(--muted)" x="165.0" y="262.0" text-anchor="middle" font-size="13px">次概率高 → 分布尖</text>
<g class="diagram-grid"><line x1="352.3" y1="40" x2="352.3" y2="230"/><line x1="418.1" y1="40" x2="418.1" y2="230"/><line x1="483.9" y1="40" x2="483.9" y2="230"/><line x1="549.7" y1="40" x2="549.7" y2="230"/><line x1="326" y1="230.0" x2="576" y2="230.0"/><line x1="326" y1="176.9" x2="576" y2="176.9"/><line x1="326" y1="123.8" x2="576" y2="123.8"/><line x1="326" y1="70.7" x2="576" y2="70.7"/></g>
<g><line x1="352.3" y1="230" x2="352.3" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="352.3" y="245" text-anchor="middle">0</text><line x1="418.1" y1="230" x2="418.1" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="418.1" y="245" text-anchor="middle">2</text><line x1="483.9" y1="230" x2="483.9" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="483.9" y="245" text-anchor="middle">4</text><line x1="549.7" y1="230" x2="549.7" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="549.7" y="245" text-anchor="middle">6</text><line x1="322" y1="230.0" x2="326" y2="230.0" stroke="var(--ink-2)"/><text class="fg-muted" x="319" y="234.0" text-anchor="end">0</text><line x1="322" y1="163.6" x2="326" y2="163.6" stroke="var(--ink-2)"/><text class="fg-muted" x="319" y="167.6" text-anchor="end"></text><line x1="322" y1="97.3" x2="326" y2="97.3" stroke="var(--ink-2)"/><text class="fg-muted" x="319" y="101.3" text-anchor="end"></text><rect x="326" y="40" width="250" height="190" fill="none" stroke="var(--line-strong)"/></g>
<rect x="341.8" y="206.6" width="21.1" height="23.4" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="352.3" y="245.0" text-anchor="middle">音0</text>
<text class="diagram-mono" x="352.3" y="201.6" text-anchor="middle">0.09</text>
<rect x="374.7" y="184.9" width="21.1" height="45.1" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="385.2" y="245.0" text-anchor="middle">音1</text>
<text class="diagram-mono" x="385.2" y="179.9" text-anchor="middle">0.17</text>
<rect x="407.6" y="74.3" width="21.1" height="155.7" fill="var(--fig-blue)" fill-opacity="0.85" stroke="var(--fig-blue)"/>
<text class="diagram-note" x="418.1" y="245.0" text-anchor="middle">音2</text>
<text class="diagram-mono" x="418.1" y="69.3" text-anchor="middle">0.59</text>
<rect x="440.5" y="226.7" width="21.1" height="3.3" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="451.0" y="245.0" text-anchor="middle">音3</text>
<text class="diagram-mono" x="451.0" y="221.7" text-anchor="middle">0.01</text>
<rect x="473.4" y="221.4" width="21.1" height="8.6" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="483.9" y="245.0" text-anchor="middle">音4</text>
<text class="diagram-mono" x="483.9" y="216.4" text-anchor="middle">0.03</text>
<rect x="506.3" y="227.4" width="21.1" height="2.6" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="516.8" y="245.0" text-anchor="middle">音5</text>
<text class="diagram-mono" x="516.8" y="222.4" text-anchor="middle">0.01</text>
<rect x="539.2" y="203.3" width="21.1" height="26.7" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="549.7" y="245.0" text-anchor="middle">音6</text>
<text class="diagram-mono" x="549.7" y="198.3" text-anchor="middle">0.10</text>
<text class="diagram-note" fill="var(--accent)" x="451.0" y="26.0" text-anchor="middle" font-weight="700">τ = 1.0（原分布）</text>
<text class="diagram-note" fill="var(--muted)" x="451.0" y="262.0" text-anchor="middle" font-size="13px">softmax 原样</text>
<g class="diagram-grid"><line x1="638.3" y1="40" x2="638.3" y2="230"/><line x1="704.1" y1="40" x2="704.1" y2="230"/><line x1="769.9" y1="40" x2="769.9" y2="230"/><line x1="835.7" y1="40" x2="835.7" y2="230"/><line x1="612" y1="230.0" x2="862" y2="230.0"/><line x1="612" y1="168.7" x2="862" y2="168.7"/><line x1="612" y1="107.4" x2="862" y2="107.4"/><line x1="612" y1="46.1" x2="862" y2="46.1"/></g>
<g><line x1="638.3" y1="230" x2="638.3" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="638.3" y="245" text-anchor="middle">0</text><line x1="704.1" y1="230" x2="704.1" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="704.1" y="245" text-anchor="middle">2</text><line x1="769.9" y1="230" x2="769.9" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="769.9" y="245" text-anchor="middle">4</text><line x1="835.7" y1="230" x2="835.7" y2="234" stroke="var(--ink-2)"/><text class="fg-muted" x="835.7" y="245" text-anchor="middle">6</text><line x1="608" y1="230.0" x2="612" y2="230.0" stroke="var(--ink-2)"/><text class="fg-muted" x="605" y="234.0" text-anchor="end">0</text><line x1="608" y1="153.4" x2="612" y2="153.4" stroke="var(--ink-2)"/><text class="fg-muted" x="605" y="157.4" text-anchor="end"></text><line x1="608" y1="76.8" x2="612" y2="76.8" stroke="var(--ink-2)"/><text class="fg-muted" x="605" y="80.8" text-anchor="end"></text><rect x="612" y="40" width="250" height="190" fill="none" stroke="var(--line-strong)"/></g>
<rect x="627.8" y="188.3" width="21.1" height="41.7" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="638.3" y="245.0" text-anchor="middle">音0</text>
<text class="diagram-mono" x="638.3" y="183.3" text-anchor="middle">0.14</text>
<rect x="660.7" y="172.2" width="21.1" height="57.8" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="671.2" y="245.0" text-anchor="middle">音1</text>
<text class="diagram-mono" x="671.2" y="167.2" text-anchor="middle">0.19</text>
<rect x="693.6" y="122.5" width="21.1" height="107.5" fill="var(--fig-blue)" fill-opacity="0.85" stroke="var(--fig-blue)"/>
<text class="diagram-note" x="704.1" y="245.0" text-anchor="middle">音2</text>
<text class="diagram-mono" x="704.1" y="117.5" text-anchor="middle">0.35</text>
<rect x="726.5" y="214.4" width="21.1" height="15.6" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="737.0" y="245.0" text-anchor="middle">音3</text>
<text class="diagram-mono" x="737.0" y="209.4" text-anchor="middle">0.05</text>
<rect x="759.4" y="204.7" width="21.1" height="25.3" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="769.9" y="245.0" text-anchor="middle">音4</text>
<text class="diagram-mono" x="769.9" y="199.7" text-anchor="middle">0.08</text>
<rect x="792.3" y="216.0" width="21.1" height="14.0" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="802.8" y="245.0" text-anchor="middle">音5</text>
<text class="diagram-mono" x="802.8" y="211.0" text-anchor="middle">0.05</text>
<rect x="825.2" y="185.5" width="21.1" height="44.5" fill="var(--fig-neutral)" fill-opacity="0.38" stroke="var(--fig-neutral)"/>
<text class="diagram-note" x="835.7" y="245.0" text-anchor="middle">音6</text>
<text class="diagram-mono" x="835.7" y="180.5" text-anchor="middle">0.15</text>
<text class="diagram-note" fill="var(--accent)" x="737.0" y="26.0" text-anchor="middle" font-weight="700">τ = 2.0（冒险）</text>
<text class="diagram-note" fill="var(--muted)" x="737.0" y="262.0" text-anchor="middle" font-size="13px">分布被摊平</text>
</svg>
<figcaption>温度改变采样分布（本教程计算绘制；同一组 logits，柱上数字为概率）。最大 logit 唯一时，τ→0 使分布趋近该位置的 one-hot；τ>1 使分布更平坦。生成音乐时可比较不同温度，但重复率与乐谱合法性需要实际测量。</figcaption>
</figure>

## 5. 排错清单（训练不收敛时按序查）

1. **数据编码**：token→id 的映射有没有错位（差一位的 off-by-one 是序列任务最常见的 bug）？
2. **损失配对**：预测 `logits[:, :-1]` 对真值 `tokens[:, 1:]`——即「用 $x_t$ 预测 $x_{t+1}$」了吗？
3. **学习率**：太大→损失震荡/NaN；太小→几千步不动。先试 $10^{-3}$ 与 $10^{-4}$。
4. **隐状态**：RNN 的 $h_0$ 是否正确初始化、是否在 epoch 之间断开（detach）？
5. **序列长度**：截断太短→学不到长程模式；太长→显存爆。

## 6. 提交与自检

- 一张**训练损失曲线**（观察总体趋势，不要求逐步单调下降；随机小批量、Adam 更新甚至固定批量上的离散步长都可能造成局部上升），同时给出固定验证集曲线；
- 一段**续写样例**（给定初始 8 个 token，续写 ≥32 个 token）；
- 一段**温度对比**（$\tau=0.5$ 与 $\tau=1.5$ 各生成一段），并用一两句话解释差异。

**自检**：能说清「前向 / 损失 / 反向 / 更新」在代码的哪几行；能解释为什么回归用 MSE、分类用交叉熵；能说明温度如何改变采样分布。做到这三条，本实验达标。

## 7. 代码 ↔ 讲次对照表

| 代码 | 对应结论 |
|:--|:--|
| `nn.Linear(1,64) → ReLU → Linear(64,1)` | [1.2 多层感知机与通用逼近](../lectures/lec01/sec12.md)：非线性让深度有意义 |
| `loss_fn = nn.MSELoss()` | [1.4 损失函数](../lectures/lec01/sec14.md)：回归用 MSE、分类用交叉熵 |
| `loss.backward()` | [1.5 反向传播](../lectures/lec01/sec15.md)：链式法则的线性时间实现 |
| `opt.step()` + `zero_grad()` | [1.6 优化器](../lectures/lec01/sec16.md)：Adam 的自适应步长；梯度默认累积 |
| `nn.GRU(32, 128)` | [2.3 门控](../lectures/lec02/sec23.md)：门控与细胞/隐状态的作用 |
| `logits[:, :-1]` 对 `tokens[:, 1:]` | [2.2 BPTT 与教师强制](../lectures/lec02/sec22.md)：用 $x_t$ 预测 $x_{t+1}$ |
| 温度采样 | [2.8 应用导读](../lectures/lec02/sec28.md)：$\tau$ 是风格旋钮 |

## 8. 扩展任务（选做 1–2 项）

1. **换结构对比**：把 GRU 换成 LSTM、纯 RNN 与单层 Transformer（[2.5](../lectures/lec02/sec25.md)），在**同参数量**下比较收敛速度与生成质量，观察结构选择带来的收益与代价。
2. **采样策略对比**：实现 top-k 与 top-p（核采样），与温度采样对照（[2.8](../lectures/lec02/sec28.md)）：哪种策略在「保持音乐性」上更稳？
3. **序列长度实验**：把 BPTT 的截断长度从 16 改到 64，观察损失与生成质量；再打开梯度裁剪（[2.2](../lectures/lec02/sec22.md)），记录梯度范数曲线。
4. **困惑度报告**：计算验证集困惑度 $\mathrm{PPL}=\exp(\text{cross-entropy})$（[6.1](../lectures/lec06/sec61.md)），并解释它与损失的关系。主要指标使用未调温的模型分布；另算不同温度下的验证集 PPL 时，必须标明这是重标定后的分布，而不是训练所得原模型的 PPL，不能用生成片段的自评分代替验证集评估。
5. **从零写一遍反向传播**：用 numpy 手写这一层网络的 forward/backward，与 PyTorch 的 `x.grad` 逐元素对照（误差 < 1e-6），以此检验是否掌握了 [1.5](../lectures/lec01/sec15.md) 的反向传播。

## 9. 研究挑战：模型真的利用了长上下文吗？

一段续写能遵守局部音符拼写，并不能证明模型记住了前一乐句。这里把问题改成可被数据否定的判断：**固定模型与待预测位置后，增加可见的历史字符，是否降低未见曲目的下一字符负对数似然？** 本节及配套程序是本书的研究扩展，不是 MIT 官方 Lab 1 的任务或评分要求；前八节的自动微分、RNN 与采样实验仍然保留。

### 9.1 先固定语料，再产生窗口

三个模型都使用官方 [PyTorch Part 2 音乐生成笔记本](https://github.com/MITDeepLearning/introtodeeplearning/blob/master/lab1/PT_Part2_Music_Generation.ipynb) 载入的真实 ABC 曲目。按笔记本原有环境运行数据加载单元，在得到 `songs`（每个元素是一首曲目的字符串）后导出；不要用几行手写音符替代语料。官方仓库的分支可能更新，报告中保留所用笔记本的提交标识、数据加载依赖版本和导出文件的 SHA-256；以下程序也记录语料哈希。

```python
from pathlib import Path

# 在官方笔记本的数据加载单元之后运行；songs 是其真实曲目列表。
Path("official_songs.abc").write_text(
    "\n\n".join(song.strip() for song in songs) + "\n", encoding="utf-8"
)
```

也可直接取得同一仓库中加载器读取的原始 ABC 文件，跳过安装官方笔记本依赖：

```bash
curl -fL https://raw.githubusercontent.com/MITDeepLearning/introtodeeplearning/master/mitdeeplearning/data/irish.abc -o official_songs.abc
```

`master` 会变化；运行时记录文件哈希与所用仓库提交。直接读取原始文件按 `X:` 分曲，可能与笔记本按空行提取的边界有差别，应在报告中注明来源与曲目数。

将文件放到运行命令可访问的位置。这里的程序不下载数据，也不代替官方笔记本中的音频合成或播放组件。

::: method Lab 1 研究协议 · 数据与泄漏边界
1. 以行首 `X:` 划分完整 tune，统一 CRLF/CR 为 LF，不跨曲目拼接历史。先分组、再按组做 80%/10%/10% 的训练/验证/测试划分，最后才产生窗口；比例按组计，不保证字符数相同。所有模型共享同一划分。
2. 配套程序的分组键是规范化乐谱的 SHA-256：去掉 `%` 后的注释、空白和除 `K:`/`M:`/`L:` 外的行首元数据字段。同键曲目整体进入一侧，训练仍保留组内各曲目，报告 tune ID。这能挡住一部分「换标题的同曲」，**不能保证近重复隔离**：移调、装饰音、不同分句、内联字段与不同记谱法都可能漏掉，规范化也可能误并。抽查跨集合最相近的乐谱；若用编辑距离或转调不变指纹扩大分组，先冻结规则并重做全部模型，不能看过测试成绩才挑曲目删除。
3. tokenizer 为 Unicode 字符；词表只从训练集取得并按字符排序，ID 0 固定为 `<UNK>`。验证/测试的新字符映射到它，分别报告 OOV 字符比例；这时 PPL 衡量的是映射后序列，而非原始未知字符的精确预测。高 OOV 会使成绩失真，不能把两种词表下的 PPL 直接比较。
4. 固定随机种子、目标位置清单、训练抽样顺序、软件/硬件与线程数。程序的 `--split-seed` 固定分组划分和评估清单，`--seed` 控制初始化、训练抽样与生成，二者默认均为 17。保留同一个 `--split-seed`，将 `--seed` 至少换成三个值，区分训练波动和数据划分变化；固定种子不保证跨设备逐位一致。tune ID 的第一个冒号前是组哈希，可据此做按组配对统计。
:::

### 9.2 三种模型、一个目标、明确的预算

程序入口是仓库根目录的 `tools/lab1_context.py`，要求 Python 3.11+、PyTorch 2.x，使用标准库 `resource`，因此资源统计命令面向 macOS/Linux。官方数据加载的依赖由官方笔记本提供；只有启用 `--abc-check` 才另需 `music21`。程序实际训练并保存模型与 JSON 报告，不预置任何实验成绩。先做小规模执行检查：

```bash
python tools/lab1_context.py --abc official_songs.abc --out runs/lab1-smoke \
  --steps 2 --batch 2 --contexts 8 16 --eval-targets 8 --generate 32
```

`--out` 必须是尚不存在的目录，以免覆盖结果。默认 CPU、单线程，默认 `20 × 8` 个监督目标只是检查流程的预算，不是足以支持结论的训练量。语料必须至少有十个规范化组，每个集合须有长于最大上下文的曲目。确认目标错位、掩码、输出与资源记录正常后，再依据自己的耗时逐级增加预算，例如：

```bash
python tools/lab1_context.py --abc official_songs.abc --out runs/lab1-seed17 \
  --seed 17 --steps 200 --batch 8 --contexts 8 32 64 --eval-targets 512 --generate 256
```

这只是起始配置，不承诺收敛、耗时或内存。CUDA 环境可显式加 `--device cuda`；不支持时程序报错，不静默换设备。

| 模型 | 条件分布与实际配置 | 能检验的边界 |
|:--|:--|:--|
| 字符 5-gram | 最多看前 4 个字符；用最长已见后缀计数，未见则回退到更短后缀，add-0.1 平滑 | 可见历史超过 4 后预测严格不变，是上下文干预的负对照；报告计数表规模而非「神经网络参数量」 |
| GRU | embedding 32，隐藏维 64，单层，线性输出 | 每个窗口从零隐状态开始，不能携带窗口之外的历史；遗忘或训练不足都可能使长历史无效 |
| 因果 Transformer | embedding/位置向量维 32，4 头、2 层，前馈维 64，Pre-LN、dropout 0 | 上三角布尔掩码禁止看未来；学习式绝对位置只覆盖训练窗口长度，不能据此声称支持外推长度 |

三个模型在同一份抽样清单上学习。令 $L=\max C$，从训练曲目中所有满足 $t\ge L$ 的目标位置有放回、按位置均匀抽取 `steps × batch` 对 $(\text{tune},t)$；长曲目因此有更大权重。每个样本输入 $x_{t-L:t}$，**仅末端的 $x_t$ 计一个监督目标**，不把窗口内每个位置都算成独立监督。神经网络使用交叉熵、AdamW（学习率 $10^{-3}$、weight decay 0.01）、梯度范数裁剪 1；n-gram 对相同目标事件累计计数，重复抽到的目标也重复计数。窗口之间既不传隐状态，也不跨曲目。

因此每个模型接收相同的 `steps × batch × L` 个输入字符与 `steps × batch` 个监督目标，5-gram 只利用其中最后至多 4 个历史字符。**相同数据暴露不是相同计算量、相同容量或相同优化难度**：本配置不声称参数量匹配，报告神经模型实际参数数和 n-gram 表规模。若另外研究「固定时间谁更好」，为每个模型单独设置相同墙钟上限，报告它实际消费的目标数，作为另一张表，不与等目标预算混称。验证集可用于选择预算、学习率或模型；每种结构的候选配置数也应相同并公布，不能只给某一种模型充分调参。

配套入口默认使用固定步数的最终权重，不做基于验证集的早停。研究报告如改为选取最佳验证 checkpoint，须对所有模型应用预先声明的选择规则；测试集只用于冻结方案后的报告。

### 9.3 上下文干预：必须预测同一批字符

训练完成后固定参数，只改评估时可见的历史长度 $C\in\{8,32,64\}$。程序先在每个评估集合列出所有 $t\ge L$ 的位置，用固定种子无放回抽取至多 `--eval-targets` 个位置；每个模型、每个 $C$ 都用这同一张清单。短曲目及每首的前 $L$ 个字符不计分，覆盖率限制必须随结果报告。**不能**分别从长度 8 与长度 64 的窗口起点采样、再比较平均损失，那会同时改变预测难度。

$$
\operatorname{NLL}(C)=-\frac{1}{N}\sum_{(i,t)\in\mathcal T}
\log p_\theta\!\left(x_{i,t}\mid x_{i,t-C:t}\right),
\qquad \operatorname{PPL}(C)=\exp\bigl(\operatorname{NLL}(C)\bigr).
$$

取自然对数、按真实目标字符平均，不能先逐曲目求 PPL 再平均。程序输出总体及逐曲目 NLL/目标数。用 $\Delta=\operatorname{NLL}(8)-\operatorname{NLL}(64)$ 表示长历史收益；正值才是本指标下的改善。对同一首 tune 的目标做配对，再按 tune（若一组有多首，则按规范化组）重采样计算置信区间，不能把高度重叠的窗口当成独立重复实验。报告至少三个训练种子的结果，不只展示最好的一个。

::: think Lab 1 研究限制 · 长窗口不等于远处信息的因果贡献
缩短窗口还会改变 GRU 的预热长度，以及 Transformer 的绝对位置编号：程序在每个窗口内从位置 0 重新编号。因此 $\Delta>0$ 支持「这个训练方案受益于更长输入」，还不能排除位置或状态预热效应。更强的对照是保留长度、位置和最近 8 个字符，只把更早的前缀换成同集合另一曲目的等长前缀，对完全相同的目标再评分；替换规则、随机种子与边界必须预先固定。替换产生的分布外拼接本身也可能提高损失，应与截短结果一起解释。该替换对照需读者在现有评估函数中实现，不是配套入口已计算的结果。
:::

还应增加掩码检查：保持前缀不变、修改未来输入时，Transformer 在更早位置的 logits 不得变化。当前入口仅训练末端目标，但保留因果掩码，避免今后改为所有位置监督时发生泄漏。teacher forcing 评分时使用真实历史与原模型概率，**温度恒为 1**；温度采样的好听程度与这张 PPL 表是不同问题。

### 9.4 生成质量与资源也要可核查

入口从测试目标清单中第一首曲目取前 $L$ 个字符作为所有模型共享的提示，在 $\tau=0.5,1,1.5$ 下各续写固定字符数。只保留最近 $L$ 个字符作为条件，GRU 重新从零运行，与评分的上下文语义一致。采样固定 CPU 随机生成器种子；不使用 top-k/top-p、语法修复或挑选最好样本，**仅禁止输出 `<UNK>`**，这一生成限制不用于 NLL。提示可能截断在 ABC 头部或乐句中，记录完整提示，不把提示已有字段当作模型学会格式的证据。

程序保存所有原始生成文本和重复 8-gram 比例 $1-\#\text{distinct 8-grams}/\#\text{8-grams}$（只统计新生成部分），并给出是否存在行首 `X:` 与 `K:` 的弱检查。弱检查不等于合法 ABC。安装 `music21` 后加 `--abc-check` 可记录解析器是否接受且包含音符以及失败信息；保留解析器版本，抽查接受样本的节拍、音高与未闭合结构。解析成功不保证乐理正确，更不保证音乐性；解析失败也应区分不完整续写与真正语法错误。比较生成质量时使用同一提示集合与新字符上限，报告全部样本的合法率、重复率以及人工盲评的规则，不能只选可播放的一首。

资源表记录机器、CPU 线程数、设备、PyTorch 版本、参数量、监督目标数、训练与评估秒数。入口用 `perf_counter`，CUDA 计时前后同步，报告训练峰值 `max_memory_allocated`；它不是 reserved 内存，也不包含驱动与其他进程。`train_seconds` 不含模型序列化，含优化器建立与训练循环；评估时间不含生成。严格比较性能还需预热和重复计时，不能把单次微型运行当成吞吐基准。CPU 的 `process_peak_rss_raw` 是整个进程至今的 RSS 高水位：macOS 单位为字节、Linux 为 KiB，后运行模型继承前面的高水位，**不能当作各模型独立峰值**；逐模型内存比较应在独立进程中测量。`tracemalloc` 也不能代替 PyTorch 原生张量内存统计。入口没有宣称测量推理吞吐或 KV cache 优势。

### 9.5 预注册判断与提交物

运行前先写下假设，例如「在当前语料与等目标预算下，GRU 和 Transformer 的 $\Delta>0$，而 5-gram 的 $\Delta=0$」。同时写出反驳条件：按曲目配对的区间包含 0、跨种子符号不稳定，或长上下文模型不优于短历史基线，都不能报告为长程建模已成功。5-gram 在所有 $C\ge4$ 上的 NLL 应一致，否则先查目标清单、回退实现或计分代码。Transformer 不胜过 GRU、长历史无收益、生成合法率下降，都是可以提交的负结果。

在基础提交物之外，研究挑战提交以下证据：

- 语料哈希、官方笔记本版本、分组规则、各集合 tune/组/字符数、OOV、窗口覆盖范围与近重复抽查记录；
- `report.json`、模型文件、运行命令和依赖版本，固定测试位置上的「模型 × 上下文长度」NLL/PPL 表，配对 $\Delta$ 及跨种子不确定性；不填入任何预想成绩；
- 训练和验证曲线、真实耗时与资源口径；配套程序的 `losses` 是逐步训练曲线，验证曲线需在固定验证清单上按预定间隔另行记录，不得用训练 loss 冒充；
- 同一提示/温度协议下的全部续写、重复与解析记录，以及一个最有诊断价值的失败案例；
- 一段只覆盖证据范围的结论：区分欠拟合、局部统计已足够、长程信息确有帮助和数据泄漏等解释，说明还需要哪项对照才能区分它们。

本实验比较的是有限语料、有限预算下的条件预测，不是架构优劣的普遍排名。若只完成小预算执行检查，应明确写「流程检查」，不能写成研究结论。
