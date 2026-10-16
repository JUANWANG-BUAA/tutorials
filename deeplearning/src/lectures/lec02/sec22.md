# 2.2 RNN：沿时间展开的权值共享与 BPTT

上一节把要求提出来了：**变长、保序、参数与长度无关**。现在兑现它。最朴素的想法是给网络装一块「记忆」：每读入一个输入 $\boldsymbol x_t$，就用它和上一步的记忆一起更新出一份新记忆，再据此给出这一步的输出。所有时间步用**同一组权重**做这件事——这就是循环神经网络（recurrent neural network, RNN）。

这个设计只用三行数学就写完了，但它的训练问题要用一整节来算清楚：**梯度要沿时间倒着传回去，而这条路径上全是连乘**。连乘的伸缩率由权重矩阵的谱性质决定，于是要么指数衰减（梯度消失）、要么指数增长（梯度爆炸），两者都让「长程依赖」变得几乎不可学。这一节的推导是整讲的技术地基——[2.3](sec23.md) 的门控是在改这里的结构，[2.4](sec24.md) 的注意力是在绕开这里的路径，[2.7](sec27.md) 的状态空间模型是在保住 $O(1)$ 状态的同时重写这里的递推。

## 2.2.1 递推的定义与形状约定 {#sec-2.2.1}

::: def 定义 2.2.1 · 循环神经网络（RNN） {#def-2.2.1}
给定输入序列 $\boldsymbol x_{1:T}$、初始状态 $\boldsymbol h_0=\boldsymbol 0$，RNN 用一个 $d_h$ 维隐状态递推：

$$\boldsymbol z_t=W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h,\qquad
\boldsymbol h_t=\phi(\boldsymbol z_t),$$
$$\hat{\boldsymbol y}_t=\psi\bigl(W_{hy}\boldsymbol h_t+\boldsymbol b_y\bigr),$$

其中 $W_{hh}\in\mathbb R^{d_h\times d_h}$、$W_{xh}\in\mathbb R^{d_h\times d_x}$、$\boldsymbol b_h\in\mathbb R^{d_h}$、$W_{hy}\in\mathbb R^{d_y\times d_h}$；$\phi$ 常取 $\tanh$（也可用 ReLU 族），$\psi$ 按任务选（分类配 softmax，回归可省略）。**同一组 $W_{hh},W_{xh},\boldsymbol b_h$ 在所有时间步复用**，这就是 [2.1](sec21.md) 要求的参数共享。
:::

::: intuition 一次只看三个符号：状态、输入、输出
把递推式读成三个问题：**$\boldsymbol h_{t-1}$ 里存着什么**（历史摘要）、**$\boldsymbol x_t$ 带来什么**（当前证据）、**$\boldsymbol h_t$ 该丢什么留什么**（由 $W_{hh}$ 与 $\phi$ 共同决定）。注意 $\boldsymbol h_t$ 同时承担两个角色：它既是**输出层的输入**（现在要预测什么），又是**下一步的输入**（记忆里要留什么）。同一个向量被两个任务拉扯，这是 RNN 表达能力的一个先天限制——LSTM 用一条独立的细胞状态把这两个角色拆开（[2.3](sec23.md)），正是为了缓解它。
:::

::: method 形状与参数量 {#method-2.2.1}
批优先约定下（$B$ 为批大小、$T$ 为时间步数）：

| 量 | 形状 | 参数量 | 说明 |
|:--|:--|:--|:--|
| $\boldsymbol X$ | $B\times T\times d_x$ | — | 一批序列，第 1 维是时间 |
| $\boldsymbol h_t$ | $B\times d_h$ | — | 每一步的状态，随 $t$ 更新 |
| $W_{xh}$ | $d_h\times d_x$ | $d_h d_x$ | 输入投影 |
| $W_{hh}$ | $d_h\times d_h$ | $d_h^2$ | 状态转移（**与 $T$ 无关**） |
| $\boldsymbol b_h$ | $d_h$ | $d_h$ | 状态偏置 |
| $W_{hy}$ | $d_y\times d_h$ | $d_y d_h$ | 输出投影 |
| **合计** | — | $(d_x+d_h)d_h+d_h+d_y d_h$ | 与序列长度 $T$ **完全无关** |

对照一下：若把 $\boldsymbol x_{1:T}$ 摊平后交给 MLP，第一层的参数量是 $d_h(Td_x)$——随长度线性增长，而且 $T$ 一变就得重来。**参数量与 $T$ 无关**是 RNN 全部价值的来源。
:::

## 2.2.2 沿时间展开：一个 T 层、共享权重的网络 {#sec-2.2.2}

把 $t=1,\dots,T$ 的递推式摊平写开，就得到「**沿时间展开**」（unrolling）这幅图：RNN 等价于一个 $T$ 层的网络，每层结构相同、**权重完全相同**，相邻层之间除了前向的输入通路，还有一条隐状态通路。

<figure>
<svg class="figure-svg" viewBox="0 0 900 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-rnn-title fig-rnn-desc">
<title id="fig-rnn-title">RNN 沿时间展开：同一组权重在每一步复用</title>
<desc id="fig-rnn-desc">将 RNN 的隐状态递推沿时间展开成链：每步读入 xₜ、结合上一步的 hₜ₋₁ 计算新的 hₜ 并输出 yₜ。所有时间步共享同一组 W_hh、W_xh、W_y；反向传播沿时间连乘每步的雅可比。</desc>
<defs>
<marker id="mk-neutral" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-neutral)"/></marker>
<marker id="mk-blue" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-blue)"/></marker>
<marker id="mk-green" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-green)"/></marker>
<marker id="mk-gold" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-gold)"/></marker>
</defs>
<text class="diagram-note" fill="ink" x="30" y="32" text-anchor="start" font-weight="700">展开前：h_t = φ(W_hh h_{t−1} + W_xh x_t)　→　展开后：一条链</text>
<rect x="58" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" fill="ink" x="110" y="132" text-anchor="middle" font-size="16px">h₁</text>
<text class="diagram-note" fill="var(--fig-blue)" x="110" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="110" y1="220" x2="110" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="110" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="110" y="240.5" text-anchor="middle" font-size="14px">x₁</text>
<line x1="110" y1="106" x2="110" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="118" y="52" text-anchor="start" font-size="13px">y₁</text>
<line x1="166" y1="138" x2="262" y2="138" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#mk-blue)"/>
<rect x="268" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" fill="ink" x="320" y="132" text-anchor="middle" font-size="16px">h₂</text>
<text class="diagram-note" fill="var(--fig-blue)" x="320" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="320" y1="220" x2="320" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="320" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="320" y="240.5" text-anchor="middle" font-size="14px">x₂</text>
<line x1="320" y1="106" x2="320" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="328" y="52" text-anchor="start" font-size="13px">y₂</text>
<line x1="376" y1="138" x2="472" y2="138" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#mk-blue)"/>
<rect x="478" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" fill="ink" x="530" y="132" text-anchor="middle" font-size="16px">h₃</text>
<text class="diagram-note" fill="var(--fig-blue)" x="530" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="530" y1="220" x2="530" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="530" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="530" y="240.5" text-anchor="middle" font-size="14px">x₃</text>
<line x1="530" y1="106" x2="530" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="538" y="52" text-anchor="start" font-size="13px">y₃</text>
<line x1="586" y1="138" x2="682" y2="138" stroke="var(--fig-blue)" stroke-width="2.2" marker-end="url(#mk-blue)"/>
<rect x="688" y="110" width="104" height="56" rx="9" fill="var(--paper-soft)" stroke="var(--fig-blue)" stroke-width="1.3"/>
<text class="diagram-mono" fill="ink" x="740" y="132" text-anchor="middle" font-size="16px">h_T</text>
<text class="diagram-note" fill="var(--fig-blue)" x="740" y="152" text-anchor="middle" font-size="12px">RNN 单元</text>
<line x1="740" y1="220" x2="740" y2="172" stroke="var(--fig-neutral)" stroke-width="1.7" marker-end="url(#mk-neutral)"/>
<circle cx="740" cy="236" r="15" fill="var(--fig-neutral)" fill-opacity="0.10" stroke="var(--fig-neutral)" stroke-width="1.6"/>
<text class="diagram-mono" x="740" y="240.5" text-anchor="middle" font-size="14px">x_T</text>
<line x1="740" y1="106" x2="740" y2="62" stroke="var(--fig-green)" stroke-width="1.7" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="748" y="52" text-anchor="start" font-size="13px">y_T</text>
<path d="M 110 196 C 110 240 320 240 320 196" fill="none" stroke="var(--fig-gold)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-gold)"/>
<path d="M 320 196 C 320 240 530 240 530 196" fill="none" stroke="var(--fig-gold)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-gold)"/>
<path d="M 530 196 C 530 240 740 240 740 196" fill="none" stroke="var(--fig-gold)" stroke-width="1.7" stroke-dasharray="4 3" marker-end="url(#mk-gold)"/>
<text class="diagram-mono" fill="var(--fig-gold)" x="215.0" y="262" text-anchor="middle" font-size="12.5px">同一组 (W_hh, W_xh, W_y)</text>
<line x1="40" y1="138" x2="54" y2="138" stroke="var(--fig-blue)" stroke-width="1.7" marker-end="url(#mk-blue)"/>
<text class="diagram-mono" fill="var(--fig-blue)" x="36" y="142" text-anchor="end" font-size="13px">h₀</text>
<rect x="560" y="20" width="310" height="40" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-note" fill="var(--fig-red)" x="715" y="38" text-anchor="middle" font-size="13px">BPTT：∂L/∂h₀ 含 ∏ 雅可比 → 梯度消失 / 爆炸</text>
</svg>
<figcaption>RNN 的「展开」视角（本教程绘）。折叠时是一**个**带反馈的单元；展开后是一**条**共享权重的链。序列建模的能力（状态记忆）与缺陷（沿时间的连乘雅可比，即 BPTT）都来自这条链——这正是 2.2 节梯度分析与 2.3 节门控改造的出发点。</figcaption>
</figure>

::: thm 定理 2.2.1 · 权值共享的收益与代价 {#thm-2.2.1}
设 $\boldsymbol y=f_\theta(\boldsymbol x_{1:T})$ 由 [定义 2.2.1](#def-2.2.1) 的递推给出。

**收益**：$\lvert\theta\rvert$ 与 $T$ 无关（见表 [method 2.2.1](#method-2.2.1)），且同一模式出现在任意位置都由同一组参数识别；对任意 $T'$ 都有定义（可外推到训练时未见过的长度）。

**代价**（三条，都来自展开图）：

1. **不能沿时间并行**：$\boldsymbol h_t$ 依赖 $\boldsymbol h_{t-1}$，第 $t$ 步的计算必须等第 $t-1$ 步完成，前向与反向的**串行深度都是 $T$**；
2. **梯度必须穿过 $T$ 次状态转移**：任意两位置之间的影响力要在链上传播 $T$ 步（见 [定理 2.2.2](#thm-2.2.2)）；
3. **状态是信息瓶颈**：所有历史必须压进固定的 $d_h$ 维向量。
:::

::: proof 推导 · 参数量与「展开等价性」
**参数量**：$W_{hh}$（$d_h^2$）、$W_{xh}$（$d_h d_x$）、$\boldsymbol b_h$（$d_h$）、$W_{hy}$（$d_y d_h$，$\boldsymbol b_y$ 为 $d_y$）相加即为表中合计项；每一项都**不含 $T$**。对照「每步一套权重」的方案，参数量为 $T\left[(d_x d_h + d_h) + \cdots\right]=\mathcal O(T)$。

**展开等价性**：定义 $T$ 个「层」$\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h)$。若把它们看作一个普通的 $T$ 层前馈网络，则它的第 $t$ 层权重矩阵按定义**全部相等**（都等于 $W_{hh}$ 与 $W_{xh}$）。反过来，任何一组「层间权重相等」的 $T$ 层网络都可以折叠回递推式。因此：**RNN = 一个绑定了权重共享约束的 $T$ 层网络**。这个等价关系的价值在于，它把「沿时间反向传播」（[2.2.3](#sec-2.2.3)）变成第 1 讲里已经学过的普通反向传播，只是把「层」换成了「时间步」。$\blacksquare$
:::

::: intuition 展开视角的实用价值：调试顺序
展开之后，很多困惑自动消失。例如「为什么 RNN 训练慢」——因为 $T$ 层网络的**反向传播必须逐层进行**，而这里的层数是序列长度；「为什么同一个词在不同位置得到同样的处理」——因为那是同一条权重；「为什么隐状态不能无限装历史」——因为所有层的中间表示都必须经过同一个 $d_h$ 维瓶颈。请把 $\boldsymbol h_t$ 记成「**前 $t$ 步的有损摘要**」：$\boldsymbol h_t$ 是 $\boldsymbol x_{1:t}$ 的确定性函数，但 $d_h$ 固定而 $t$ 可以任意大，所以它不是完整记忆，而是**按当前参数认为重要**的那部分历史。
:::

## 2.2.3 BPTT：梯度怎么沿时间传回去 {#sec-2.2.3}

序列任务的损失通常是各步损失之和 $\mathcal L=\sum_{t=1}^{T}\mathcal L_t$（逐时刻分类、逐 token 语言模型都是这个形态）。要对 $W_{hh}$ 求梯度，误差就必须传回早期时间步。做法与第 1 讲的反向传播完全一样——仍是链式法则与中间结果复用——只是「层」变成了「时间步」，因此叫**沿时间反向传播**（backpropagation through time, BPTT）。

::: def 定义 2.2.2 · 沿时间反向传播（BPTT） {#def-2.2.2}
令 $\boldsymbol z_k=W_{hh}\boldsymbol h_{k-1}+W_{xh}\boldsymbol x_k+\boldsymbol b_h$，定义**单步雅可比**

$$J_k:=\frac{\partial \boldsymbol h_k}{\partial \boldsymbol h_{k-1}}=\operatorname{diag}\bigl(\phi'(\boldsymbol z_k)\bigr)W_{hh}\in\mathbb R^{d_h\times d_h},$$

并以 $\boldsymbol g_t:=\partial\mathcal L_t/\partial \boldsymbol h_t$ 表示第 $t$ 步损失对状态的直接梯度。BPTT 就是沿 $t=T,T-1,\dots,1$ 反序传播 $\partial\mathcal L/\partial\boldsymbol h_t$。
:::

::: intuition 为什么实现是「一个反序递推」，而不是一条长公式
BPTT 的代码只有一个形态：从 $t=T$ 起，把「本步损失带来的误差」与「下一步回传的误差」相加算出 $\boldsymbol\delta_t$，累加进参数梯度，再把误差传给 $t-1$。它与第 1 讲的反向传播**完全同构**，唯一的区别是「层」被时间步代替、而且层与层之间的权重是**同一份**（共享权重带来一个直接后果：所有时间步的贡献要**累加**到同一个梯度上）。所以 [2.2.2](#sec-2.2.2) 的展开视角很好用——把 $T$ 步递推想成 $T$ 层网络，BPTT 就是普通的逐层反向。请记住 $\boldsymbol\delta_t$ 的定义，本节后面所有关于消失与爆炸的讨论都落在它身上。
:::

::: thm 定理 2.2.2 · BPTT 的连乘结构 {#thm-2.2.2}
沿用 [定义 2.2.2](#def-2.2.2) 的记号，则对 $t\lt s$，

$$\frac{\partial \boldsymbol h_s}{\partial \boldsymbol h_t}=\prod_{k=t+1}^{s}J_k=J_sJ_{s-1}\cdots J_{t+1},$$

于是

$$\frac{\partial \mathcal L}{\partial \boldsymbol h_t}=\sum_{s\ge t}\left(\prod_{k=t+1}^{s}J_k\right)^{\!\mathrm T}\frac{\partial \mathcal L_s}{\partial \boldsymbol h_s},\qquad
\frac{\partial \mathcal L}{\partial W_{hh}}=\sum_{t=1}^{T}\boldsymbol\delta_t\,\boldsymbol h_{t-1}^{\mathrm T},\qquad
\boldsymbol\delta_t=\operatorname{diag}\bigl(\phi'(\boldsymbol z_t)\bigr)\frac{\partial\mathcal L}{\partial \boldsymbol h_t}.$$

**结论**：跨 $n=s-t$ 步的影响，其梯度含 $n$ 个 $J_k$ 的连乘；连乘的伸缩率决定梯度是消失还是爆炸。
:::

::: proof 推导 · 从链式法则到连乘（完整）
**(1) 单步雅可比。** 由 $\boldsymbol h_k=\phi(\boldsymbol z_k)$ 与 $\boldsymbol z_k=W_{hh}\boldsymbol h_{k-1}+(\text{与 }\boldsymbol h_{k-1}\text{ 无关的项})$，逐元素求导得

$$\frac{\partial h_k^{(i)}}{\partial h_{k-1}^{(j)}}=\phi'(z_k^{(i)})\cdot W_{hh}^{(i,j)}
\;\Longrightarrow\;
J_k=\operatorname{diag}\bigl(\phi'(\boldsymbol z_k)\bigr)W_{hh}.$$

注意 $\operatorname{diag}(\phi'(\boldsymbol z_k))$ 是**逐元素**调制，$W_{hh}$ 负责**跨维度**混合——两者交替出现是全部问题的根源。

**(2) 跨多步的雅可比 = 连乘。** 由链式法则（多元情形下逐段相乘）：

$$\frac{\partial \boldsymbol h_s}{\partial \boldsymbol h_t}
=\frac{\partial \boldsymbol h_s}{\partial \boldsymbol h_{s-1}}\cdot\frac{\partial \boldsymbol h_{s-1}}{\partial \boldsymbol h_{s-2}}\cdots\frac{\partial \boldsymbol h_{t+1}}{\partial \boldsymbol h_t}
=\prod_{k=t+1}^{s}J_k .$$

矩阵乘法的顺序**不能交换**：$J_sJ_{s-1}\cdots J_{t+1}$ 与 $J_{t+1}\cdots J_{s}$ 一般不同（反向传播里出现的是转置序列）。

**(3) 损失对状态的梯度。** 因为 $\boldsymbol h_t$ 既影响 $\mathcal L_t$（直接），又通过 $\boldsymbol h_{t+1},\dots,\boldsymbol h_T$ 影响后续所有损失，把 $s$ 从 $t$ 到 $T$ 的所有路径相加：

$$\frac{\partial \mathcal L}{\partial \boldsymbol h_t}
=\sum_{s\ge t}\left(\prod_{k=t+1}^{s}J_k\right)^{\!\mathrm T}\frac{\partial \mathcal L_s}{\partial \boldsymbol h_s},
\qquad\text{其中 } s=t \text{ 一项即 } \boldsymbol g_t \text{（空乘积取单位阵）},$$

其中 $s=t$ 一项就是 $\boldsymbol g_t$（空乘积取单位阵）。这解释了为什么「误差**回传多远**」这个问题必须逐层考虑：远处损失的梯度要先穿过一长串 $J_k$ 才能到达 $\boldsymbol h_t$。

**(4) 对参数的梯度（实现里用的递推形式）。** 由 $\boldsymbol z_t=W_{hh}\boldsymbol h_{t-1}+\cdots$，有 $\partial\boldsymbol z_t/\partial W_{hh}=\boldsymbol h_{t-1}$ 的线性映射，故

$$\frac{\partial\mathcal L}{\partial W_{hh}}=\sum_{t=1}^{T}\boldsymbol\delta_t\boldsymbol h_{t-1}^{\mathrm T},\qquad
\boldsymbol\delta_t=\operatorname{diag}\bigl(\phi'(\boldsymbol z_t)\bigr)\Bigl(\underbrace{W_{hy}^{\mathrm T}\tfrac{\partial \mathcal L_t}{\partial \hat{\boldsymbol y}_t}}_{\text{本步输出带来的误差}}+W_{hh}^{\mathrm T}\boldsymbol\delta_{t+1}\Bigr).$$

这个反向递推式 **就是 BPTT 的实现**：从 $t=T$ 起，每一步用「本步误差 + 下一步回传的误差」算出 $\boldsymbol\delta_t$，再累加进 $W_{hh}$ 的梯度。可以看到整个反向过程的时间复杂度是 $\mathcal O(T\,d_h^2)$，且**必须串行**（$\boldsymbol\delta_t$ 依赖 $\boldsymbol\delta_{t+1}$）。

**(5) 范数界。** 对任意相容矩阵范数，

$$\left\lVert\prod_{k=t+1}^{s}J_k\right\rVert\le\prod_{k=t+1}^{s}\lVert J_k\rVert
\le\Bigl(\max_{k}\lVert J_k\rVert_2\Bigr)^{\,s-t},$$

即**跨 $n$ 步的梯度量级被「单步雅可比的最大奇异值」的 $n$ 次方控制**（严格的最坏情形界；实际谱半径决定长期平均行为）。$\blacksquare$
:::

::: intuition 一句话记住 BPTT 的两个数字
BPTT 只有两个关键数字：**跨了几步 $n$**，以及**每一步的伸缩率 $\rho=\lVert J_k\rVert_2$（长期由谱半径主导）**。梯度量级大致按 $\rho^{\,n}$ 变化。$\rho=0.9$、$n=100$ 时约 $2.7\times10^{-5}$；$\rho=1.1$、$n=100$ 时约 $1.4\times10^{4}$。也就是说：**没有一个「安全的中间地带」可站**——参数稍微小一点就消失，稍微大一点就爆炸，而序列一长，任何偏离 1 的乘数都会被指数放大。这就是为什么「把学习率调好就能学会长依赖」这种想法在朴素 RNN 上不成立。
:::

## 2.2.4 定量分析：谱半径、最大奇异值与连乘 {#sec-2.2.4}

::: thm 定理 2.2.3 · 梯度消失与爆炸的判据 {#thm-2.2.3}
在 [定义 2.2.2](#def-2.2.2) 的记号下，若对所有 $k$ 有 $\lVert J_k\rVert_2\le\rho$：

- $\rho\lt1$：$\left\lVert\partial\boldsymbol h_s/\partial\boldsymbol h_t\right\rVert\le\rho^{\,s-t}\to0$，跨 $n$ 步的梯度**指数消失**；
- $\rho\gt1$：上界随 $n$ 指数增长，梯度可能**指数爆炸**（先是数值变大，随后溢出为 `inf`/`NaN`）；
- 长期行为由 $W_{hh}$ 的谱半径 $\rho(W_{hh})$ 与 $\phi'$ 的取值共同决定；$\tanh$ 满足 $\lvert\phi'\rvert\le1$（在 $0$ 处取到最大值 $1$，饱和区趋于 $0$），因此 $\lVert J_k\rVert_2\le\lVert W_{hh}\rVert_2$。

**推论（两个常被引用的事实）**：① 只把激活换成 ReLU 不能让梯度消失消失（$\lVert J_k\rVert$ 仍由 $W_{hh}$ 决定，见 [errata](#sec-2.2.4)）；② **梯度裁剪只能压制爆炸，对消失无能为力**。
:::

::: proof 推导 · 为什么会指数变化，以及「精度地板」是什么
**(1) 标量情形先看透。** 取 $d_h=1$、$h_t=\phi(w\,h_{t-1}+c)$，则 $J_k=w\,\phi'(z_k)$，跨 $n$ 步的乘积为

$$\frac{\partial h_t}{\partial h_{t-n}}=\prod_{k=t-n+1}^{t}w\,\phi'(z_k)
=w^{n}\prod_{k}\phi'(z_k).$$

取 $\phi=\tanh$（$\lvert\phi'\rvert\le1$）得 $\lvert\partial h_t/\partial h_{t-n}\rvert\le\lvert w\rvert^{n}$——与 [定理 2.2.2](#thm-2.2.2) 的范数界一致。

**(2) 矩阵情形。** 由 $\lVert AB\rVert_2\le\lVert A\rVert_2\lVert B\rVert_2$ 与 $\lVert\operatorname{diag}(\phi')\rVert_2=\max_i\lvert\phi'(z^{(i)})\rvert\le1$ 立得 $\lVert J_k\rVert_2\le\lVert W_{hh}\rVert_2$。更精细的长期刻画用**谱半径**：当 $J_k$ 的分布稳定时，$\lVert J_s\cdots J_{t+1}\rVert^{1/(s-t)}\to\rho(J)$（乘积的渐近指数增长率），因此「平均意义上」梯度量级随 $n$ 以 $\rho(J)^n$ 变化。

**(3) 为什么有一个「地板」。** 浮点数不是实数：单精度（float32）能表示的最小正规数约 $1.2\times10^{-38}$，而实际训练里关心的是**信噪比**——反向传播还要继续与上游梯度、权重相乘，当跨 $n$ 步的因子衰减到 $10^{-7}$ 量级时，它加到参数更新上的贡献通常已经低于学习率与优化器噪声的水平，**在效果上等于零**（这就是「float32 精度地板 $\approx10^{-7}$」这个工程经验值的含义）。同理，爆炸方向一旦使中间量超过 $3.4\times10^{38}$ 就变成 `inf`，随后的 `inf - inf` 或 `0 × inf` 直接产生 `NaN`。

**(4) 与「长程依赖学不到」的联系。** 假设模型需要利用第 5 步的信息来决定第 200 步的输出。该路径的梯度必须经过 $n=195$ 次连乘。由上面的界，梯度量级被 $\rho^{195}$ 控制：$\rho=0.9$ 时为 $10^{-9}$ 量级（已在地板以下），$\rho=1.1$ 时约 $10^{8}$（未被裁剪就会把参数推向发散）。**结论不是「RNN 学不会」，而是「朴素 RNN 对长依赖的学习信号被指数衰减吞掉了」**——这正是门控结构（[2.3](sec23.md)）与注意力（[2.4](sec24.md)）各自要重写的部分。$\blacksquare$
:::

::: intuition 这条判据是可以「看」出来的
定理最实用的推论是：它能在训练日志里被直接观测。做法是把同一个 RNN 用不同的序列长度训练，记录**最远离损失的那一层**（最靠近输入的权重）收到的梯度范数：若它随长度在对数坐标上呈直线下降，梯度在消失；若呈直线上升，梯度在爆炸。§2.2.7 的代码做了这件事。注意由此推出的一个反常识结论：**不存在一个学习率能同时解决这两个方向**——问题出在连乘的**结构**上，而不是步长大小；调参只能改变它发生的快慢，不能改变它的存在。
:::

<figure>
<svg class="figure-svg" viewBox="0 0 880 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-vanish-title fig-vanish-desc">
<title id="fig-vanish-title">梯度随回传时间步数的衰减（对数轴）</title>
<desc id="fig-vanish-desc">横轴为沿时间回传的步数，纵轴为梯度量级（对数刻度）。每步乘 0.25（Sigmoid 饱和）的曲线在 10 步内衰减到百万分之一；乘 0.9（门控改善后）衰减显著变慢；乘 1（ReLU 正区或细胞态加法通道）不衰减。10⁻⁷ 为 float32 的精度地板。</desc>
<defs></defs>
<g class="diagram-grid"><line x1="96.0" y1="44" x2="96.0" y2="254"/><line x1="271.0" y1="44" x2="271.0" y2="254"/><line x1="446.0" y1="44" x2="446.0" y2="254"/><line x1="621.0" y1="44" x2="621.0" y2="254"/><line x1="796.0" y1="44" x2="796.0" y2="254"/><line x1="96" y1="254.0" x2="796" y2="254.0"/><line x1="96" y1="201.5" x2="796" y2="201.5"/><line x1="96" y1="149.0" x2="796" y2="149.0"/><line x1="96" y1="96.5" x2="796" y2="96.5"/><line x1="96" y1="44.0" x2="796" y2="44.0"/></g>
<g><line x1="96.0" y1="254" x2="96.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="96.0" y="269" text-anchor="middle">0</text><line x1="271.0" y1="254" x2="271.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="271.0" y="269" text-anchor="middle">1</text><line x1="446.0" y1="254" x2="446.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="446.0" y="269" text-anchor="middle">2</text><line x1="621.0" y1="254" x2="621.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="621.0" y="269" text-anchor="middle">3</text><line x1="796.0" y1="254" x2="796.0" y2="258" stroke="var(--ink-2)"/><text class="fg-muted" x="796.0" y="269" text-anchor="middle">4</text><line x1="92" y1="254.0" x2="96" y2="254.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="258.0" text-anchor="end">10⁻⁸</text><line x1="92" y1="201.5" x2="96" y2="201.5" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="205.5" text-anchor="end">10⁻⁶</text><line x1="92" y1="149.0" x2="96" y2="149.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="153.0" text-anchor="end">10⁻⁴</text><line x1="92" y1="96.5" x2="96" y2="96.5" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="100.5" text-anchor="end">10⁻²</text><line x1="92" y1="44.0" x2="96" y2="44.0" stroke="var(--ink-2)"/><text class="fg-muted" x="89" y="48.0" text-anchor="end">10⁰</text><rect x="96" y="44" width="700" height="210" fill="none" stroke="var(--line-strong)"/><text class="fg-label" x="446.0" y="287" text-anchor="middle">回传的时间步数 t（从 t=0 算起）</text><text class="fg-label" x="56.0" y="149.0" text-anchor="middle" transform="rotate(-90 56.0 149.0)">梯度量级（对数轴）</text></g>
<polyline fill="none" stroke="var(--fig-red)" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,59.8 131.0,75.6 148.5,91.4 166.0,107.2 183.5,123.0 201.0,138.8 218.5,154.6 236.0,170.4 253.5,186.2 271.0,202.0 288.5,217.8 306.0,233.6 323.5,249.5 341.0,254.0 358.5,254.0 376.0,254.0 393.5,254.0 411.0,254.0 428.5,254.0 446.0,254.0 463.5,254.0 481.0,254.0 498.5,254.0 516.0,254.0 533.5,254.0 551.0,254.0 568.5,254.0 586.0,254.0 603.5,254.0 621.0,254.0 638.5,254.0 656.0,254.0 673.5,254.0 691.0,254.0 708.5,254.0 726.0,254.0 743.5,254.0 761.0,254.0 778.5,254.0 796.0,254.0"/>
<polyline fill="none" stroke="var(--fig-gold)" stroke-width="2.0" stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,51.9 131.0,59.8 148.5,67.7 166.0,75.6 183.5,83.5 201.0,91.4 218.5,99.3 236.0,107.2 253.5,115.1 271.0,123.0 288.5,130.9 306.0,138.8 323.5,146.7 341.0,154.6 358.5,162.5 376.0,170.4 393.5,178.3 411.0,186.2 428.5,194.1 446.0,202.0 463.5,209.9 481.0,217.8 498.5,225.7 516.0,233.6 533.5,241.6 551.0,249.5 568.5,254.0 586.0,254.0 603.5,254.0 621.0,254.0 638.5,254.0 656.0,254.0 673.5,254.0 691.0,254.0 708.5,254.0 726.0,254.0 743.5,254.0 761.0,254.0 778.5,254.0 796.0,254.0"/>
<polyline fill="none" stroke="var(--fig-purple)" stroke-width="2.0" stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,45.2 131.0,46.4 148.5,47.6 166.0,48.8 183.5,50.0 201.0,51.2 218.5,52.4 236.0,53.6 253.5,54.8 271.0,56.0 288.5,57.2 306.0,58.4 323.5,59.6 341.0,60.8 358.5,62.0 376.0,63.2 393.5,64.4 411.0,65.6 428.5,66.8 446.0,68.0 463.5,69.2 481.0,70.4 498.5,71.6 516.0,72.8 533.5,74.0 551.0,75.2 568.5,76.4 586.0,77.6 603.5,78.8 621.0,80.0 638.5,81.2 656.0,82.4 673.5,83.6 691.0,84.8 708.5,86.0 726.0,87.2 743.5,88.4 761.0,89.6 778.5,90.8 796.0,92.0"/>
<polyline fill="none" stroke="var(--fig-green)" stroke-width="2.6" stroke-linejoin="round" stroke-linecap="round" points="96.0,44.0 113.5,44.0 131.0,44.0 148.5,44.0 166.0,44.0 183.5,44.0 201.0,44.0 218.5,44.0 236.0,44.0 253.5,44.0 271.0,44.0 288.5,44.0 306.0,44.0 323.5,44.0 341.0,44.0 358.5,44.0 376.0,44.0 393.5,44.0 411.0,44.0 428.5,44.0 446.0,44.0 463.5,44.0 481.0,44.0 498.5,44.0 516.0,44.0 533.5,44.0 551.0,44.0 568.5,44.0 586.0,44.0 603.5,44.0 621.0,44.0 638.5,44.0 656.0,44.0 673.5,44.0 691.0,44.0 708.5,44.0 726.0,44.0 743.5,44.0 761.0,44.0 778.5,44.0 796.0,44.0"/>
<polyline fill="none" stroke="var(--fig-neutral)" stroke-width="1.2" stroke-linejoin="round" stroke-linecap="round" stroke-dasharray="7 5" points="96.0,227.8 796.0,227.8"/>
<text class="diagram-note" fill="var(--fig-neutral)" x="788.0" y="219.8" text-anchor="end">float32 精度地板 ≈10⁻⁷</text>
<g><line x1="116" y1="282" x2="142" y2="282" stroke="var(--fig-red)" stroke-width="2.6"/><text class="diagram-note" x="148" y="286">每步 ×0.25：Sigmoid 饱和段的最坏情形，10 步即 10⁻⁶</text><line x1="116" y1="301" x2="142" y2="301" stroke="var(--fig-gold)" stroke-width="2.0"/><text class="diagram-note" x="148" y="305">每步 ×0.5：典型 tanh 情形</text><line x1="116" y1="320" x2="142" y2="320" stroke="var(--fig-purple)" stroke-width="2.0"/><text class="diagram-note" x="148" y="324">每步 ×0.9：门控（LSTM/GRU）把通道修到接近 1</text><line x1="116" y1="339" x2="142" y2="339" stroke="var(--fig-green)" stroke-width="2.6"/><text class="diagram-note" x="148" y="343">每步 ×1：ReLU 正区 / 细胞态加法通道，连乘不衰减</text></g>
</svg>
<figcaption>梯度消失有多快（本教程计算绘制，纵轴对数）。反向传播沿时间的梯度是**每步雅可比的连乘**：每步因子 0.25 时 10 步衰减 $10^{6}$ 倍、20 步直接跌破 float32 的工程精度地板——这解释了 2.2 节「RNN 记不住长程依赖」与 2.3 节「门控把通道修到接近 1」的全部动机。</figcaption>
</figure>

::: ex 例 2.2.1 · 算一算梯度能走多远 {#ex-2.2.1}
沿用标量直觉：单步伸缩率 $\rho$ 分别取 $0.25$、$0.5$、$0.9$、$1.0$、$1.1$。

(1) 计算跨 $n=10,20,50,100,200$ 步的梯度量级 $\rho^{n}$，填表。
(2) 以「$10^{-7}$ 以下视为被吞掉」为判据，各种 $\rho$ 的**有效记忆跨度**是多少步？
(3) 若训练中出现 `NaN`，$\rho$ 大概率落在哪一档？此时最先应该检查什么？

::: proof 解
**(1)** 量级表（四舍五入到三位有效数字）：

| $\rho$ | $n=10$ | $n=20$ | $n=50$ | $n=100$ | $n=200$ |
|:--|:--|:--|:--|:--|:--|
| $0.25$ | $9.5\times10^{-7}$ | $9.1\times10^{-13}$ | $7.9\times10^{-31}$ | $6.2\times10^{-61}$ | $3.9\times10^{-121}$ |
| $0.5$ | $9.8\times10^{-4}$ | $9.5\times10^{-7}$ | $8.9\times10^{-16}$ | $7.9\times10^{-31}$ | $6.2\times10^{-61}$ |
| $0.9$ | $0.349$ | $0.122$ | $5.15\times10^{-3}$ | $2.66\times10^{-5}$ | $7.06\times10^{-10}$ |
| $1.0$ | $1$ | $1$ | $1$ | $1$ | $1$ |
| $1.1$ | $2.59$ | $6.73$ | $117$ | $1.38\times10^{4}$ | $1.90\times10^{8}$ |

**(2)** 令 $\rho^{n}=10^{-7}$，解得 $n^\star=\dfrac{-7}{\log_{10}\rho}$：

- $\rho=0.25$：$n^\star\approx11.6$ 步；$\rho=0.5$：$n^\star\approx23.3$ 步；$\rho=0.9$：$n^\star\approx153$ 步；$\rho=1.0$：无衰减（理论上无限，实际受状态容量限制）。
- 也就是说，**即使只把单步衰减控制在 0.9（已经是相当乐观的假设），朴素 RNN 的有效记忆也只有百步量级**；而在 0.25 这种最坏情形下，10 步就没了。

**(3)** 出现 `NaN` 说明中间量溢出，$\rho\gt1$ 是最可能的档位（爆炸方向）。排查顺序：① 先做**梯度裁剪**（[method 2.2.2](#method-2.2.2)）确认能否止住；② 检查学习率是否过大（学习率会把参数推到 $\lVert W_{hh}\rVert_2\gt1$ 的区域）；③ 检查是否有单步损失异常大（如标签错位、`log(0)`）；④ 若发生在混合精度下，检查是否需要 loss scaling（第 9 讲）。**注意：这套流程针对的是爆炸；如果症状是「loss 卡住不降、长依赖学不到」，那是消失方向的问题，裁剪帮不上忙。** $\blacksquare$
:::
:::

## 2.2.5 工程对策一：梯度裁剪（治爆炸） {#sec-2.2.5}

::: method 按全局范数裁剪（global norm clipping） {#method-2.2.2}
设本轮所有参数的梯度拼成一个长向量 $\boldsymbol g$（等价于各参数张量梯度的 L2 范数平方和再开方）。给定阈值 $c$：

$$\boldsymbol g\leftarrow\boldsymbol g\cdot\min\!\left(1,\ \frac{c}{\lVert\boldsymbol g\rVert}\right).$$

- **语义**：当 $\lVert\boldsymbol g\rVert\gt c$ 时，把整个梯度向量**等比缩小**到范数恰为 $c$——**方向不变，只改尺度**；
- **阈值取法**：先跑几十步，打印**未裁剪**的梯度范数，取它的中位数附近的量级（常见经验值在 $1$ 附近，但**必须看自己任务的实际分布**）；
- **与逐元素裁剪的区别**：`clip_by_value`（把每个元素截到 $[-c,c]$）会**改变方向**，可能导致更新指向错误的下降方向；序列任务里推荐按范数裁剪；
- **边界**：它只压得住**爆炸**。梯度已经衰减到 $10^{-9}$ 时，等比缩放救不回来（乘一个系数仍是 $10^{-9}$ 量级）。消失要靠门控结构（[2.3](sec23.md)）、合理的初始化与残差连接。
:::

值得说明裁剪为什么「有效但不治本」：爆炸发生在**更新之前**的瞬间，裁剪把这一步的更新尺度拉回可控范围，于是训练不会崩，但它并没有改变 $J_k$ 的连乘结构——下一次反向仍然是同一串乘积。因此裁剪是安全网，不是疗法。

## 2.2.6 工程对策二：teacher forcing 与它的代价 {#sec-2.2.6}

自回归任务（语言模型、音乐生成、机器翻译的解码器）在训练时要面对一个选择：**第 $t$ 步的输入用真实的 $\boldsymbol x_t$，还是用模型上一步自己猜的 $\hat{\boldsymbol x}_{t-1}$？**

::: def 定义 2.2.3 · teacher forcing 与 exposure bias {#def-2.2.3}
**Teacher forcing**：训练时始终以**真实**前缀作为输入，即对每个位置并行计算

$$\mathcal L=-\sum_{t=1}^{T}\log p_\theta\bigl(x_{t+1}\mid x_{\le t}\bigr),$$

其中条件里的 $x_{\le t}$ 全部来自数据（而非模型采样）。它把训练变成「一次前向、$T$ 个位置同时算」，因此可以并行、且梯度无偏。

**Free-running（自回归）模式**：以模型自己生成的 token 作为下一步输入。它与 teacher forcing 的差别在于**输入分布不同**（train–inference distribution shift），这个偏移被称为 **exposure bias**（曝光偏差）：训练时模型从未见过自己的错误输出，推理时错误会一步步累积。
:::

::: intuition 为什么训练用 teacher forcing、推理只能自由跑
teacher forcing 的本质是把「多步决策问题」松弛成 $T$ 个独立的**一步预测**问题：给定真实上下文，预测下一个 token。这让损失可分解、可并行、方差小。代价是**训练与推理的输入分布不一致**：推理时模型看到的是自己（可能有错）的输出，而它在训练中从没见过这种输入，于是误差会沿时间累积——这也是「训练困惑度很低但生成质量差」的首要原因之一。工程上的折中手段有三类：① **课程式**逐步混入模型自己的预测（scheduled sampling 一类做法）；② 训练时对输入加少量噪声 / 用 beam search 减少推理误差；③ 用更长的上下文与更大的模型把单步错误率压到足够低，让累积误差仍然可接受——大语言模型的实践主要走第三条路。
:::

## 2.2.7 代码：手写 RNN 单元、梯度检查与裁剪 {#sec-2.2.7}

```python
import torch, torch.nn as nn, torch.nn.functional as F

torch.manual_seed(0)
B, T, d_x, d_h = 4, 32, 8, 16
x = torch.randn(B, T, d_x, dtype=torch.float64)      # float64：梯度检查需要高精度
y = torch.randint(0, 3, (B, T))                      # 每步 3 类（同步对齐任务）

class RNNCellManual(nn.Module):
    def __init__(self, d_x, d_h, d_y):
        super().__init__()
        # 与 PyTorch 一致：把 W_hh 与 W_xh 拼成一个矩阵，一次矩阵乘算完（实现技巧，不改变数学）
        self.W = nn.Linear(d_x + d_h, d_h, bias=True)
        self.out = nn.Linear(d_h, d_y, bias=True)

    def forward(self, x, h=None):
        B, T, _ = x.shape
        h = torch.zeros(B, self.W.out_features, dtype=x.dtype) if h is None else h
        hs = []
        for t in range(T):                             # 串行：h_t 依赖 h_{t-1}
            h = torch.tanh(self.W(torch.cat([x[:, t], h], dim=-1)))
            hs.append(h)
        return self.out(torch.stack(hs, dim=1)), h     # (B,T,d_y), (B,d_h)

model = RNNCellManual(d_x, d_h, 3)

# ① 梯度检查：用数值微分验证 BPTT 的实现（第 1 讲 1.5 的做法）
x_small = x[:, :4].clone().requires_grad_(True)      # 只取 4 步，数值梯度才跑得动
logits, _ = model(x_small)
loss = F.cross_entropy(logits.reshape(-1, 3), y[:, :4].reshape(-1))
grads = torch.autograd.grad(loss, model.parameters())

for p, g in zip(model.parameters(), grads):
    assert torch.isfinite(g).all(), "梯度出现 inf/NaN：多半是爆炸方向"

# ② 观察「连乘」：把同一权重复制到不同深度的 RNN，看梯度范数如何随步数变化
for T_try in (4, 8, 16, 32):
    logits, _ = model(x[:, :T_try])
    loss = F.cross_entropy(logits.reshape(-1, 3), y[:, :T_try].reshape(-1))
    model.zero_grad(); loss.backward()
    # 取第一层（最靠近输入）权重的梯度范数：它离损失最远，最先被连乘吞掉
    g0 = model.W.weight.grad.norm().item()
    print(f"T={T_try:3d}  最底层权重梯度范数={g0:.3e}")

# ③ 梯度裁剪：训练循环里的标准写法（放在 backward 之后、step 之前）
opt = torch.optim.AdamW(model.parameters(), lr=1e-3)
model.zero_grad()
logits, _ = model(x)
F.cross_entropy(logits.reshape(-1, 3), y.reshape(-1)).backward()
grad_norm = nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)  # 返回裁剪前的范数
print(f"裁剪前全局梯度范数={grad_norm:.4f}（超过 1.0 时被等比缩放到 1.0）")
opt.step(); opt.zero_grad()
```

这段代码里三个动作对应本节的三条结论：**① 数值梯度检查**确认 BPTT 实现正确（链式法则写错时数值梯度会立刻暴露）；**② 梯度范数随 $T$ 的变化**是 [定理 2.2.3](#thm-2.2.3) 的可观测形式（把 $\tanh$ 换成更陡 / 更平的结构，同一实验的斜率会明显变化）；**③ 裁剪的位置必须在 `backward()` 与 `step()` 之间**——放到更新之后就没用了。

::: errata 本节五个常见误解
1. **「换 ReLU 就能治好梯度消失」**：ReLU 只解决**激活饱和**造成的衰减（$\tanh$ 在饱和区导数趋 0 这一项），但 [定理 2.2.3](#thm-2.2.3) 的界 $\lVert J_k\rVert_2\le\lVert W_{hh}\rVert_2$ 与激活无关：只要权重矩阵的最大奇异值小于 1，连乘照样衰减。真正有效的是**正交 / 单位初始化 + 门控加法通道**（[2.3](sec23.md)）与残差结构。
2. **「梯度裁剪解决了梯度消失」**：裁剪按范数等比缩小梯度，等于**乘一个小于等于 1 的系数**。梯度已经是 $10^{-9}$ 时，它还是 $10^{-9}$ 量级。裁剪只防爆炸。
3. **「$\boldsymbol h_t$ 记住了前面所有的信息」**：$d_h$ 固定、$t$ 任意大，$\boldsymbol h_t$ 是**有损摘要**而非完整记忆；具体丢什么由参数决定。用「模型应该记住第 3 步的细节」这类假设去解释生成结果，往往会失望。
4. **「训练损失很低就说明生成会好」**：teacher forcing 下的低损失只保证「给定真实前缀，下一步预测得准」，不保证模型自己的错误不会累积（[定义 2.2.3](#def-2.2.3) 的 exposure bias）。评估生成质量必须看自由跑（free-running）的结果。
5. **「RNN 因为不能并行，所以一无是处」**：训练不能沿时间并行是事实，但推理每步只需 $O(1)$ 状态与 $O(d_h^2)$ 计算、显存不随序列增长，天然支持**流式与无限长输入**。在设备端、实时信号处理、超长序列与小数据场景里，递推类结构仍有竞争力（[2.7](sec27.md) 的状态空间模型正是沿着这条路重新发力）。
:::

::: method 即时自测 · 2.2 {#method-2.2.3}
**Q1** 写出 RNN 递推式与参数量，并说明「参数量与 $T$ 无关」的代价是什么。

**Q2** 写出 $\partial\boldsymbol h_s/\partial\boldsymbol h_t$ 的表达式，并指出其中每一项的物理含义（哪个因子负责「逐元素压缩」、哪个负责「跨维度混合」）。

**Q3** 设单步伸缩率 $\rho=0.98$，跨 100 步的梯度量级约是多少？这个结果解释了关于长程依赖的什么现象？

**Q4** 为什么「训练损失 0.2、生成质量很差」是自回归模型的常见组合？给出两个缓解方向。

::: sol 参考要点
**Q1** $\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h)$、$\hat{\boldsymbol y}_t=\psi(W_{hy}\boldsymbol h_t+\boldsymbol b_y)$；参数量 $(d_x+d_h)d_h+d_h+d_y d_h$。代价三条：① 沿时间不能并行（串行深度 $T$）；② 梯度要穿过 $T$ 次状态转移，连乘导致消失 / 爆炸；③ 全部历史压进固定 $d_h$ 维状态，是有损瓶颈。

**Q2** $\partial\boldsymbol h_s/\partial\boldsymbol h_t=\prod_{k=t+1}^{s}\operatorname{diag}(\phi'(\boldsymbol z_k))W_{hh}$。其中 $\operatorname{diag}(\phi'(\boldsymbol z_k))$ 是**逐元素**的激活导数调制（决定「每个维度被压缩多少」），$W_{hh}$ 是**跨维度**的线性混合（决定「信息如何重组」）。两者交替连乘，因此衰减既可能来自激活饱和（$\phi'$ 小），也可能来自权重谱性质（$\lVert W_{hh}\rVert_2$ 小）。

**Q3** $0.98^{100}=\exp(100\ln0.98)\approx\exp(-2.02)\approx0.13$。也就是 100 步只衰减到约 $13\%$——比 0.9 的情形好得多，但仍随步数指数下降：跨 1000 步约 $1.7\times10^{-9}$（已被吞掉）。这解释了「单步衰减略小于 1 也救不了长依赖」：**任何严格小于 1 的固定乘数，在足够长的链上都会归零**。

**Q4** 因为训练用 teacher forcing（输入是真实前缀），损失衡量的是「给定正确上下文的一步预测质量」；推理时输入变成模型自己的输出，分布偏移导致误差累积（exposure bias）。缓解方向：① 训练时逐步混入模型自己的预测（scheduled sampling 类做法）或对输入加噪；② 提高单步精度（更大模型 / 更长上下文 / 更好的解码策略），让累积误差落在可接受范围；③ 用生成侧的指标（自由跑困惑度、人工评估、错误传播长度）替代纯 teacher forcing 损失作为模型选择依据。
:::
:::

::: note[skip] 延伸阅读
- Werbos 与后续的教科书章节关于「沿时间反向传播」的经典叙述；本节推导与第 1 讲的反向传播是同一条链式法则，只是把「层」换成「时间步」。
- Bengio, Simard & Frasconi, *Learning Long-Term Dependencies with Gradient Descent is Difficult*（1994, IEEE Transactions on Neural Networks）——「消失的梯度让长依赖学不到」这一结论的经典来源。
- Pascanu, Mikolov & Bengio, *On the Difficulty of Training Recurrent Neural Networks*（2012/2013, arXiv:1211.5063）——梯度爆炸 / 消失的统一分析、**梯度裁剪**的规范化写法与谱半径视角。
- Williams & Zipser, *A Learning Algorithm for Continually Running Fully Recurrent Neural Networks*（1989, Neural Computation）——BPTT 与 RTRL 的历史原文。
- 关于「$\boldsymbol h_t$ 是有损摘要」的直观解释，见 [2.3](sec23.md) 的延伸阅读（Olah, *Understanding LSTM Networks*, 2015）。
:::

**本节小结**：RNN 用「**同一组权重在每个时间步复用**」把参数量从 $\mathcal O(T)$ 压到与 $T$ 无关，代价是**沿时间不能并行**与**梯度必须穿过 $T$ 次状态转移**。BPTT 的推导给出关键结论：跨 $n$ 步的梯度含 $n$ 个单步雅可比 $\operatorname{diag}(\phi')W_{hh}$ 的连乘，伸缩率由范数（长期由谱半径）决定，$\rho\lt1$ 指数消失、$\rho\gt1$ 指数爆炸，没有安全中间地带；**裁剪只治爆炸**，消失需要改结构。下一节把更新式从「乘」改成「加」，用门控造出一条近似恒等的梯度通道。
