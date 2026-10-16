# Lab 1 · 深度学习入门与音乐生成

本实验对应第 1、2 讲：先用**一层网络**把「前向 → 损失 → 反向 → 更新」跑通，建立张量与自动微分的手感；再用**字符级 RNN** 学习一段旋律的序列规律，并**从初始片段续写**出新乐句。全程不需要大数据集。

<aside class="lesson-brief" aria-label="Lab 1 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>Python 基础；[第 1 讲](../lectures/lec01.md)的 MLP 前向与反向传播；[第 2 讲](../lectures/lec02.md)的 RNN 隐状态递推。</p></div>
<div><span class="brief-label">TARGET</span><strong>你将做出</strong><p>一个用梯度下降拟合的简单函数；一个字符级 RNN 音乐模型；一段由模型续写的旋律，并观察**温度**如何改变生成风格。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>验收标准</strong><p>损失曲线单调下降（非发散）；模型能从给定片段续写出语法上「像」训练数据的乐句；能解释温度趋近 0 与趋近 1 时生成结果的差异。</p></div>
</aside>

## 1. 环境与数据

- **运行环境**：Python 3.9+，TensorFlow 或 PyTorch 任选其一（本书示例给出 PyTorch 版本，思路与框架无关）。
- **数据**：一小段符号化的旋律（如 ABC 记谱或 MIDI 转成的音符事件序列）。把它当作**一串 token**——这正是[第 2 讲](../lectures/lec02.md)把序列当作离散符号序列的翻版。

::: note 数据很小，所以别期待"作曲"
本实验的目的是**看清训练循环与序列模型的行为**，不是训练一个能谱曲的模型。数据集只有几 KB 时，模型能学会**局部**的音符搭配与节奏模式就已经达到目标。判断标准是"续写像训练数据"，不是"续写好不好听"。
:::

## 2. 第一部分：用自动微分训练一层网络

把一个简单函数（如 $y=\sin(3x)$ 在若干采样点上）当作回归问题，用一层网络拟合。**每一步都对应第 1 讲的四个动作**：

```python
import torch, torch.nn as nn

model = nn.Sequential(nn.Linear(1, 64), nn.ReLU(), nn.Linear(64, 1))
opt   = torch.optim.Adam(model.parameters(), lr=1e-2)
loss_fn = nn.MSELoss()

for step in range(2000):
    pred = model(x)                 # ① 前向：得到预测
    loss = loss_fn(pred, y)         # ② 损失：MSE（回归用 MSE，见第 1 讲 1.4）
    opt.zero_grad()                 #    清空上一轮梯度
    loss.backward()                 # ③ 反向：自动微分求梯度（定理 1.2）
    opt.step()                      # ④ 更新：θ ← θ − η∇L
```

::: note 逐行对应的讲次
`model(x)` = [定义 1.1](../lectures/lec01.md) 的前向；`loss_fn` = [定义 1.2](../lectures/lec01.md) 的 MSE；`loss.backward()` = [定理 1.2](../lectures/lec01.md) 的反向传播；`opt.step()` = [定义 1.3](../lectures/lec01.md) 的梯度下降。**把这条对应关系记住，你就掌握了所有深度学习的骨架。**
:::

::: ex 观察题 · 去掉激活会怎样 {#lab1-q1}
把 `nn.ReLU()` 删掉再训一次，拟合效果如何？为什么？（提示：见[第 1 讲 1.2](../lectures/lec01.md)的"线性变换 + 非线性"。）

::: proof 参考结论
拟合会退化——两层线性等价于一层线性，无法表达 $\sin$ 的弯曲。损失停留在一个较高的平台，加大训练步数也无济于事。这从反面印证了激活函数的作用。
:::
:::

## 3. 第二部分：字符级 RNN 生成旋律

**建模思路**（第 2 讲）：把旋律表示成 token 序列 $x_1,x_2,\dots,x_T$，模型在每个时刻读入当前 token 的 one-hot，输出**下一个 token 的概率分布** $\hat p(x_{t+1}\mid x_{\le t})$。

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

生成时从初始片段开始，把模型输出的分布**采样**出下一个 token，再把采样的 token 作为下一步输入（**自回归**）。采样用**温度** $\tau$ 调节：

$$\hat p_i=\frac{\exp(z_i/\tau)}{\sum_j\exp(z_j/\tau)}.$$

| 温度 | 分布形态 | 生成风格 |
|:--|:--|:--|
| $\tau\to0$ | 趋近 one-hot（argmax） | **保守**：重复、单调，但不易出错 |
| $\tau=1$ | softmax 原分布 | 均衡 |
| $\tau\gt1$ | 更平坦 | **冒险**：多样、惊喜，也更容易跑调 |

::: intuition 温度在调"胆量"
低温度下模型只敢选概率最高的音符，于是容易陷入循环（"总在同一个音上打转"）；高温度下给低概率音符更多机会，旋律更多变，但也可能蹦出训练数据里没出现过的怪组合。**温度不是一个要"调对"的参数，而是一个风格旋钮。**
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
<figcaption>温度是「风格旋钮」不是「待调参数」（本教程计算绘制；同一组 logits，柱上数字为概率）。τ→0 分布趋近 one-hot——保守、易复读；τ>1 分布摊平——多样、易跑调。生成音乐时通常在 0.7～1.2 之间试。</figcaption>
</figure>

## 5. 排错清单（训练不收敛时按序查）

1. **数据编码**：token→id 的映射有没有错位（差一位的 off-by-one 是序列任务最常见的 bug）？
2. **损失配对**：预测 `logits[:, :-1]` 对真值 `tokens[:, 1:]`——即"用 $x_t$ 预测 $x_{t+1}$"了吗？
3. **学习率**：太大→损失震荡/NaN；太小→几千步不动。先试 $10^{-3}$ 与 $10^{-4}$。
4. **隐状态**：RNN 的 $h_0$ 是否正确初始化、是否在 epoch 之间断开（detach）？
5. **序列长度**：截断太短→学不到长程模式；太长→显存爆。

## 6. 提交与自检

- 一张**训练损失曲线**（应单调下降）；
- 一段**续写样例**（给定初始 8 个 token，续写 ≥32 个 token）；
- 一段**温度对比**（$\tau=0.5$ 与 $\tau=1.5$ 各生成一段），并用一两句话解释差异。

**自检**：能说清「前向 / 损失 / 反向 / 更新」在代码的哪几行；能解释为什么回归用 MSE、分类用交叉熵；能说明温度如何改变采样分布。做到这三条，本实验达标。
