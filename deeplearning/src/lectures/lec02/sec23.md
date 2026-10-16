# 2.3 门控：LSTM 与 GRU

[2.2 节](sec22.md) 把 RNN 的困难算成了一条式子：跨 $s-t$ 步的梯度含 $\operatorname{diag}(\phi'(\boldsymbol z_k))W_{hh}$ 的**连乘**。而这一节要换掉的就是这个连乘本身：把状态更新写成「加法」，让梯度有一条**不经过权重矩阵**的通路，同时把「记多久」从权重的副产品变成网络能学的量。

## 2.3.1 病根是「乘」，解法是「加」 {#sec-2.3.1}

连乘的伸缩率与步数是**指数关系**：每个因子比 $1$ 小一点，几十步后就差出十几个数量级；比 $1$ 大一点，几十步后直接溢出。2.2 节给出的第一个对策是**梯度裁剪**——更新前把梯度范数压回阈值内、方向不变。它治得住**爆炸**（防止溢出与 `NaN`），却治不住**消失**：梯度已经接近零，再等比缩小一次仍然是零。

所以这一节改的是**结构本身**，不是训练的补丁。可行的路线有两条。

**路线 A：改初始化与约束。** 把 $W_{hh}$ 初始化成（近似）正交矩阵，或给它加谱约束，先把连乘因子按住。这条路值得做，但它只固定了连乘因子的**一半**：另一半 $\operatorname{diag}(\phi'(\boldsymbol z_k))$ 由当前输入决定、逐步浮动，于是网络**没有表达「这一步该记住、下一步该清空」的自由度**；训练中 $W_{hh}$ 自己还会漂移离开正交簇，约束必须一直维护。更根本的一点是：**记忆时长在路线 A 里不是网络能学的量，而是权重的副产品**。

**路线 B：改更新式。** 让状态写成 $\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+(\cdots)$——求导时 $\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}$ 变成**对角矩阵**，不再含 $W$ 的连乘，而「留多少」由 $\boldsymbol f_t$ 这个**由当前输入算出来的量**决定。这就是**门控**（gating），也是本节的主角。

一句话记住这条路线：**病根是「乘」，解法是「加」**。加法本身不稀奇，稀奇的是它把伸缩率从一个**固定的权重性质**换成了**一个可学、且可以依赖输入的旋钮**——「按需记住、按需清空」这句话，第一次成了模型能表达的东西。本节顺序：LSTM 的三门与加法通道 → 传送带的推导、条件与代价 → GRU 的压缩 → 变体与工程结论 → 组合成编码器 → 形状与参数量 → 代码核对。

## 2.3.2 LSTM：三门与一条加法通道 {#sec-2.3.2}

::: def 定义 2.3.1 · LSTM（long short-term memory） {#def-2.3.1}
用 $[\boldsymbol h_{t-1},\boldsymbol x_t]$ 表示上一步隐状态与当前输入的**拼接**，LSTM 在每个时间步算六个量：

$$\boldsymbol f_t=\sigma\bigl(W_f[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_f\bigr),\qquad
\boldsymbol i_t=\sigma\bigl(W_i[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_i\bigr),\qquad
\boldsymbol o_t=\sigma\bigl(W_o[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_o\bigr),$$

$$\tilde{\boldsymbol c}_t=\tanh\bigl(W_c[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_c\bigr),\qquad
\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t,\qquad
\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t).$$

其中 $\sigma(z)=1/(1+e^{-z})$ 是**门控激活**、$\odot$ 是**逐元素乘**，所有门与状态都是 $d_h$ 维向量：三个门负责「放行多少」（逐元素，取值在开区间 $(0,1)$ 内），候选 $\tilde{\boldsymbol c}_t$ 负责「写入什么」（取值在 $(-1,1)$ 内）。

**状态的分工**：$\boldsymbol c_t$ 是内部的**细胞状态**（cell state），承担长期记忆；$\boldsymbol h_t$ 是**暴露给外部的隐状态**，是把细胞状态「读」出来的一部分，供本步的输出层与下一步的门控使用。$\boldsymbol c_t$ 不对外输出。

**参数的分块形式**：把四个矩阵按输入来源切开即 $W_f=[W_{fh},W_{fx}]$（$W_{fh}\in\mathbb R^{d_h\times d_h}$，$W_{fx}\in\mathbb R^{d_h\times d_x}$，其余同理）——「拼接后一次矩阵乘」与「两个矩阵分别乘再相加」是同一件事，框架实现取哪种都不改变数学模型。

**工程惯例**（非数学结论）：遗忘门偏置 $\boldsymbol b_f$ 常初始化为 $1$、其余偏置为 $0$，使初始遗忘门落在 $\sigma(1)\approx0.73$ 附近，即**起步时默认偏向保留**，而不是从 $\sigma(0)=0.5$ 起步。
:::

::: intuition 一条传送带，三个阀门各管一件事
- **遗忘门** $\boldsymbol f_t$ 管「**要不要留**」：逐元素决定旧记忆 $\boldsymbol c_{t-1}$ 保留多少；
- **输入门** $\boldsymbol i_t$ 管「**要不要写**」：逐元素决定候选 $\tilde{\boldsymbol c}_t$ 写进记忆多少；
- **输出门** $\boldsymbol o_t$ 管「**要不要说**」：记忆可以留在内部不对外暴露——这一步没说，不代表下一步不能用；
- 真正改变梯度命运的，是那个不显眼的 $\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$：**加法**。它让 $\boldsymbol c$ 的传递不经过 $W$ 的连乘，也让「记住多久」变成三个可以学的旋钮。
:::

::: proof 推导 · 常数误差传送带（constant error carousel）
**(i) 直接路径的雅可比。** 在 $\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$ 中对 $\boldsymbol c_{t-1}$ 求偏导，把本步的三个门与候选视为**已给定的系数**、只保留$\boldsymbol c_{t-1}$ 的**直接路径**（间接路径见第 (iii) 条）：

$$\frac{\partial\boldsymbol c_t}{\partial\boldsymbol c_{t-1}}=\operatorname{diag}\bigl(\boldsymbol f_t\bigr).$$

**(ii) 跨 $k$ 步的连乘。** 对角矩阵之积仍是对角矩阵，且对角元逐个相乘，于是

$$\frac{\partial\boldsymbol c_t}{\partial\boldsymbol c_{t-k}}
=\prod_{j=t-k+1}^{t}\operatorname{diag}\bigl(\boldsymbol f_j\bigr)
=\operatorname{diag}\Bigl(\prod_{j=t-k+1}^{t}\boldsymbol f_j\Bigr),$$

即第 $m$ 维的传递系数是**标量连乘** $\prod_j(\boldsymbol f_j)_m$，每个因子都由 $\sigma$ 产生、严格落在 $(0,1)$ 内。

**(iii) 三条必须同时记住的结论。**
1. **它不含 $W$。** 上式里既没有 $W_{hh}$ 也没有 $\phi'$：连乘的伸缩率不再由权重矩阵的谱结构决定。而且逐元素因子均在 $(0,1)$ 内，这条通道**只会衰减、不会放大**——「爆炸」在这条路径上被结构性排除。
2. **$\boldsymbol f_t\approx1$ 时近似恒等传递。** 门值由 $\sigma$ 产生、由网络算出来，因此「保留多久」是一个**可以学的量**，还可以逐维不同、逐步不同。
3. **但「无损耗」是有条件的。** 损失通常经由 $\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t)$ 读出，从 $\boldsymbol h_t$ 反传到 $\boldsymbol c_t$ 仍要乘 $\operatorname{diag}(\boldsymbol o_t)\cdot\operatorname{diag}(1-\tanh^2(\boldsymbol c_t))$：**每一次读出都被输出门与 $\tanh'$ 打一次折**。此外完整雅可比还含有经由 $\boldsymbol h_{t-1}$ 反传到门与候选的**间接项**，那些项依旧含 $W$ 的连乘。所以这条定理说的是：**存在一条不经过权重连乘的加法通道**，而不是「LSTM 无损」。$\blacksquare$
:::

下面这张图把这六个量与那条加法通道摆在一起——图顶那条绿色的 $\boldsymbol c$ 通道，就是上面推导的**直接路径**：

<figure>
<svg class="figure-svg" viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-lstm-title fig-lstm-desc">
<title id="fig-lstm-title">LSTM 单元：三门与细胞状态的加法通道</title>
<desc id="fig-lstm-desc">LSTM 单元结构：遗忘门 f、输入门 i、输出门 o 为 σ 门控；细胞状态 c 沿顶部加法通道传递（c_t = f⊙c_{t−1} + i⊙c̃）；h_t = o⊙tanh(c_t)。</desc>
<defs>
<marker id="mk-green" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-green)"/></marker>
<marker id="mk-gold" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-gold)"/></marker>
<marker id="mk-blue" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-blue)"/></marker>
<marker id="mk-purple" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="var(--fig-purple)"/></marker>
</defs>
<text class="diagram-note" fill="var(--fig-green)" x="30" y="30" text-anchor="start" font-weight="700">细胞状态 c：一条「梯度高速公路」（绿）</text>
<line x1="80" y1="70" x2="760" y2="70" stroke="var(--fig-green)" stroke-width="3.2" marker-end="url(#mk-green)"/>
<text class="diagram-mono" fill="var(--fig-green)" x="70" y="75" text-anchor="end" font-size="14px">cₜ₋₁</text>
<text class="diagram-mono" fill="var(--fig-green)" x="778" y="75" text-anchor="start" font-size="14px">cₜ</text>
<circle cx="330" cy="70" r="15" fill="var(--fig-gold)" fill-opacity="0.10" stroke="var(--fig-gold)" stroke-width="1.6"/>
<text class="diagram-mono" x="330" y="74.5" text-anchor="middle" font-size="16px">×</text>
<circle cx="610" cy="70" r="15" fill="var(--fig-blue)" fill-opacity="0.10" stroke="var(--fig-blue)" stroke-width="1.6"/>
<text class="diagram-mono" x="610" y="74.5" text-anchor="middle" font-size="16px">+</text>
<text class="diagram-mono" fill="var(--fig-gold)" x="300" y="44" text-anchor="end" font-size="12.5px">f ⊙ cₜ₋₁</text>
<rect x="60" y="180" width="150" height="90" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="135.0" y="229.5" text-anchor="middle"></text>
<text class="diagram-mono" fill="ink" x="135" y="212" text-anchor="middle" font-size="14px">[ hₜ₋₁ ; xₜ ]</text>
<text class="diagram-note" fill="muted" x="135" y="236" text-anchor="middle" font-size="12px">拼接输入</text>
<rect x="240" y="100" width="200" height="38" rx="9" fill="var(--fig-gold)" fill-opacity="0.1" stroke="var(--fig-gold)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="123.5" text-anchor="middle" font-size="11.5px">f = σ(W_f·[h,x]+b_f)</text>
<text class="diagram-note" fill="var(--fig-gold)" x="452" y="124" text-anchor="start" font-size="12px">遗忘门</text>
<line x1="212" y1="225" x2="238" y2="119" stroke="var(--fig-gold)" stroke-width="1.3" marker-end="url(#mk-gold)"/>
<rect x="240" y="160" width="200" height="38" rx="9" fill="var(--fig-blue)" fill-opacity="0.1" stroke="var(--fig-blue)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="183.5" text-anchor="middle" font-size="11.5px">i = σ(W_i·[h,x]+b_i)</text>
<text class="diagram-note" fill="var(--fig-blue)" x="452" y="184" text-anchor="start" font-size="12px">输入门</text>
<line x1="212" y1="225" x2="238" y2="179" stroke="var(--fig-blue)" stroke-width="1.3" marker-end="url(#mk-blue)"/>
<rect x="240" y="220" width="200" height="38" rx="9" fill="var(--fig-green)" fill-opacity="0.1" stroke="var(--fig-green)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="243.5" text-anchor="middle" font-size="11.5px">c̃ = tanh(W_c·[h,x]+b_c)</text>
<text class="diagram-note" fill="var(--fig-green)" x="452" y="244" text-anchor="start" font-size="12px">候选记忆</text>
<line x1="212" y1="225" x2="238" y2="239" stroke="var(--fig-green)" stroke-width="1.3" marker-end="url(#mk-green)"/>
<rect x="240" y="300" width="200" height="38" rx="9" fill="var(--fig-purple)" fill-opacity="0.1" stroke="var(--fig-purple)" stroke-width="1.5"/>
<text class="diagram-mono" x="340.0" y="323.5" text-anchor="middle" font-size="11.5px">o = σ(W_o·[h,x]+b_o)</text>
<text class="diagram-note" fill="var(--fig-purple)" x="452" y="324" text-anchor="start" font-size="12px">输出门</text>
<line x1="212" y1="225" x2="238" y2="319" stroke="var(--fig-purple)" stroke-width="1.3" marker-end="url(#mk-purple)"/>
<line x1="330" y1="100" x2="330" y2="88" stroke="var(--fig-gold)" stroke-width="1.6" marker-end="url(#mk-gold)"/>
<circle cx="505" cy="210" r="14" fill="var(--fig-blue)" fill-opacity="0.10" stroke="var(--fig-blue)" stroke-width="1.6"/>
<text class="diagram-mono" x="505" y="214.5" text-anchor="middle" font-size="14px">⊗</text>
<line x1="440" y1="179" x2="493" y2="202" stroke="var(--fig-blue)" stroke-width="1.4" marker-end="url(#mk-blue)"/>
<line x1="440" y1="239" x2="493" y2="218" stroke="var(--fig-green)" stroke-width="1.4" marker-end="url(#mk-green)"/>
<path d="M 517 202 C 570 200 604 150 610 88" fill="none" stroke="var(--fig-blue)" stroke-width="1.6" marker-end="url(#mk-blue)"/>
<text class="diagram-mono" fill="var(--fig-blue)" x="560" y="172" text-anchor="start" font-size="12.5px">i ⊙ c̃</text>
<rect x="590" y="150" width="130" height="38" rx="9" fill="var(--fig-green)" fill-opacity="0.1" stroke="var(--fig-green)" stroke-width="1.5"/>
<text class="diagram-mono" x="655.0" y="173.5" text-anchor="middle" font-size="13px">tanh(cₜ)</text>
<path d="M 700 76 C 700 112 688 132 660 148" fill="none" stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#mk-green)"/>
<circle cx="752" cy="169" r="14" fill="var(--fig-purple)" fill-opacity="0.10" stroke="var(--fig-purple)" stroke-width="1.6"/>
<text class="diagram-mono" x="752" y="173.5" text-anchor="middle" font-size="14px">⊗</text>
<line x1="720" y1="169" x2="738" y2="169" stroke="var(--fig-green)" stroke-width="1.6" marker-end="url(#mk-green)"/>
<path d="M 440 319 C 600 319 700 260 745 183" fill="none" stroke="var(--fig-purple)" stroke-width="1.6" marker-end="url(#mk-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="600" y="292" text-anchor="start" font-size="13px">o</text>
<line x1="766" y1="169" x2="800" y2="169" stroke="var(--fig-purple)" stroke-width="2.0" marker-end="url(#mk-purple)"/>
<text class="diagram-mono" fill="var(--fig-purple)" x="806" y="152" text-anchor="start" font-size="12.5px">hₜ =</text>
<text class="diagram-mono" fill="var(--fig-purple)" x="806" y="172" text-anchor="start" font-size="12.5px">o⊙tanh(cₜ)</text>
<rect x="60" y="358" width="780" height="34" rx="9" fill="var(--paper-soft)" stroke="var(--line-strong)" stroke-width="1.3"/>
<text class="diagram-text" x="450.0" y="379.5" text-anchor="middle"></text>
<text class="diagram-note" fill="ink" x="450" y="374" text-anchor="middle" font-size="12.5px">关键在顶部的加法通道：cₜ = f⊙cₜ₋₁ + i⊙c̃ —— 梯度对 cₜ₋₁ 的雅可比是 f≈1，不随步数连乘衰减</text>
</svg>
<figcaption>LSTM 单元（本教程绘）。三个 σ 门（金=遗忘 f、蓝=输入 i、紫=输出 o）决定信息去留；顶部绿色的细胞状态 c 是一条**加法**通道——cₜ = f⊙cₜ₋₁ + i⊙c̃ 中，梯度对 cₜ₋₁ 的雅可比就是 f≈1，连乘不衰减，长程记忆由此而来。</figcaption>
</figure>

看图时注意两件事：每个 $\sigma$ 门背后都是一次 $d_h\times(d_h+d_x)$ 的矩阵乘（这是参数量的大头，见 [2.3.6](#sec-2.3.6)）；而决定梯度命运的，只有顶部那条既没有矩阵、也没有非线性压缩的横线。

::: thm 定理 2.3.1 · 两条路径的伸缩率对照 {#thm-2.3.1}
设梯度要从 $\boldsymbol h_t$ 跨 $k$ 步传回 $\boldsymbol h_{t-k}$，比较两条路径的伸缩率：

- **朴素 RNN**：含矩阵连乘 $\prod_{j}\operatorname{diag}(\phi'(\boldsymbol z_j))W_{hh}$。取 $\tanh$ 时 $|\phi'|\le1$，故其 2-范数上界为 $\sigma_{\max}(W_{hh})^{k}$（$\sigma_{\max}$ 为最大奇异值）：量级由 $W_{hh}$ 的**谱结构**与 $k$ 次幂共同决定，$\sigma_{\max}\gt1$ 指数爆炸、$\sigma_{\max}\lt1$ 指数消失，**没有中间地带**。
- **LSTM 的细胞通道**：含 $\prod_{j}\operatorname{diag}(\boldsymbol f_j)$，是**逐元素**的标量连乘，每个因子都是 sigmoid 输出：$\prod_j(\boldsymbol f_j)_m\le\prod_j\sigma(z_{j,m})\lt1$。它**只能衰减**，且衰减率可以**随输入、随维度自适应**。
:::

::: intuition 同一个「$k$ 次幂」，两种命运
两者的形状都是「$k$ 次幂」，区别在**底数由谁决定、能不能学**：RNN 的底数由 $W_{hh}$ 的谱结构定死（$\phi'\le1$ 只是再打个折），而且**同一个矩阵**必须同时服务「做计算」与「存信息」两件事；LSTM 的底数是**逐维、逐步算出来的门值**——同一层里第 3 维可以记上千步、第 7 维可以每步清空，网络自己分配预算。**伸缩率从「权重的一个性质」变成「一个可学、可条件化的旋钮」，这是门控的全部秘密。**
:::

::: proof 推导 · 标量对照与 $\sigma$ 的上界
**(i) 标量对照（本书计算）。** 把两条路径各退化成标量，比较跨 $k$ 步的传递系数：

| 路径 | 跨 $k$ 步系数 | $k=30$ | $k=100$ |
|:--|:--|:--|:--|
| RNN，$w=1.05$ | $w^{k}$ | $4.32$ | $1.3\times10^{2}$ |
| RNN，$w=0.95$ | $w^{k}$ | $2.1\times10^{-1}$ | $5.9\times10^{-3}$ |
| LSTM，$f\equiv\sigma(1)=0.731$（偏置 1 的起手值） | $f^{k}$ | $8.3\times10^{-5}$ | $2.5\times10^{-14}$ |
| LSTM，$f\equiv0.99$（学到接近 1） | $f^{k}$ | $7.4\times10^{-1}$ | $3.7\times10^{-1}$ |

前两行说明 RNN 的困境：同一条路径，$w$ 偏大就爆、偏小就灭，而 $w$ 是训练要学的量、不可能长期停在临界点。第三行说明**偏置 1 只是起点**：$\sigma(1)=0.731$ 仍然衰减得很快（30 步 8 万分之一），它买来的是「相对 $0.5$ 起步的起手优势」——同样的 30 步，$0.731^{30}$ 与 $0.5^{30}=9.3\times10^{-10}$ 差了约 $9\times10^{4}$ 倍。第四行说明**真正的解法是让门值被学上去**：$f\to0.99$ 时 100 步仍保留 $37\%$。

**(ii) $\boldsymbol f_t$ 可以学到接近 $1$，但 sigmoid 永远取不到 $1$。** 因 $\sigma(z)\in(0,1)$ 严格成立，写 $(\boldsymbol f_t)_m=1-\gamma_m$ 总有 $\gamma_m\gt0$。设每步衰减同为 $\gamma$，则 $f^{k}=(1-\gamma)^{k}\approx e^{-\gamma k}$；要跨 $k$ 步仍保留 $1-\epsilon$ 以上，需要 $\gamma k\lesssim\epsilon$，即

$$\gamma\lesssim\frac{\epsilon}{k}\quad\Longrightarrow\quad z\gtrsim\ln\frac{k}{\epsilon}\qquad(\text{大 }z\text{ 时 }\gamma\approx e^{-z}).$$

取 $k=100$、$\epsilon=0.1$：需要门预激活 $z\gtrsim\ln1000\approx6.9$。**也就是说，「记住 100 步」这件事在遗忘门上要求预激活大到约 $7$ 的量级**，远大于偏置 1 的起手值——它必须靠训练把某些维推上去。而塑造这些门值的梯度本身又要穿过同一条被门值缩放的通道，这是一种「先有鸡还是先有蛋」的耦合（本书判断），也是长程依赖在 LSTM 上依然困难的算术原因。

**(iii) 矩阵情形多出来的两件事。** 多维时 RNN 的伸缩率是**矩阵**的：$\operatorname{diag}(\phi')W_{hh}$ 的奇异值给出各方向的伸缩，且**方向之间会混合**（$W_{hh}$ 的非对角元把不同维搅在一起）；LSTM 的直接路径是**对角**的：维度之间不混合，每个维度各有一条彼此独立的衰减率。$\blacksquare$
:::

## 2.3.3 GRU：把三个门压成两个 {#sec-2.3.3}

::: def 定义 2.3.2 · GRU（gated recurrent unit） {#def-2.3.2}
输入仍是拼接 $[\boldsymbol h_{t-1},\boldsymbol x_t]$，但只算两个门与一个候选：

$$\boldsymbol z_t=\sigma\bigl(W_z[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_z\bigr),\qquad
\boldsymbol r_t=\sigma\bigl(W_r[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_r\bigr),$$

$$\tilde{\boldsymbol h}_t=\tanh\bigl(W_h[\boldsymbol r_t\odot\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_h\bigr),\qquad
\boldsymbol h_t=(1-\boldsymbol z_t)\odot\boldsymbol h_{t-1}+\boldsymbol z_t\odot\tilde{\boldsymbol h}_t .$$

**更新门** $\boldsymbol z_t$ 在「旧状态」与「新候选」之间做逐元素**插值**；**重置门** $\boldsymbol r_t$ 决定算候选时忽略多少旧状态（$\boldsymbol r_t\to0$ 时候选只由 $\boldsymbol x_t$ 决定，相当于「从头起写」，与后面要不要留无关）。
:::

::: intuition GRU 是一个「没有 $\boldsymbol c$」的 LSTM
把两条更新式并排看：LSTM 用 $\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$ 分两步完成「留下旧的 + 写入新的」；GRU 用一条插值 $\boldsymbol h_t=(1-\boldsymbol z_t)\odot\boldsymbol h_{t-1}+\boldsymbol z_t\odot\tilde{\boldsymbol h}_t$ **一次写完**：$\boldsymbol z_t$ 同时是「写入多少」和「保留多少」——**两个量被绑成一个**（这正是 [2.3.4](#sec-2.3.4) 里「耦合门」的思路）。它的加法通道对应因子是 $\operatorname{diag}(1-\boldsymbol z_t)$，与 LSTM 的 $\operatorname{diag}(\boldsymbol f_t)$ 地位相同。

代价也随之而来：**GRU 没有独立暴露的细胞状态**——同一份 $\boldsymbol h_t$ 既当记忆又当输出，因此少了「内部 $\boldsymbol c$ 记着、对外 $\boldsymbol h$ 不说」这个自由度（少一组参数、少一层保护）。此外注意候选分支：$\partial\tilde{\boldsymbol h}_t/\partial\boldsymbol h_{t-1}$ 里仍含 $W$ 的连乘，**门控只保护那条直通项**——这一点 LSTM 也一样。
:::

## 2.3.4 变体：peephole 与「谁真正有用」 {#sec-2.3.4}

::: def 定义 2.3.3 · peephole 连接与耦合门 {#def-2.3.3}
- **peephole 连接**（窥孔）：把细胞状态本身接进门控的输入，例如遗忘门改为

$$\boldsymbol f_t=\sigma\bigl(W_{fh}\boldsymbol h_{t-1}+W_{fx}\boldsymbol x_t+\boldsymbol w_{fc}\odot\boldsymbol c_{t-1}+\boldsymbol b_f\bigr),$$

让「记忆里现在有什么」直接参与决定「下一步留多少」；输入门与输出门也可以同样接入 $\boldsymbol c_{t-1}$（或 $\boldsymbol c_t$）。
- **耦合门**（coupled gates）：强制 $\boldsymbol f_t=1-\boldsymbol i_t$，把两个门压成一组参数——「写多少」与「留多少」互补，与 GRU 的插值同构。
:::

::: intuition 一个在加通路，一个在减自由度
peephole 增加的是**信息通路**（门能直接读到 $\boldsymbol c$ 本身，而不只读到 $\boldsymbol h$）；耦合门减少的是**自由度与参数**（$\boldsymbol f$ 不再独立）。一加一减，但目标相同：改变「门看到什么」与「门由谁决定」。
:::

::: think 门越多越好吗？——两次大规模对照给出的答案
**论文报告**：Greff 等（2015）在若干任务上系统对照了 8 种 LSTM 变体（去掉输入门 / 去掉遗忘门 / 去掉输出门 / 去掉门的激活函数 / 耦合门 / peephole 等，具体清单以原文为准），结论是**各变体之间的差别整体并不显著**——删掉一两个门通常不会让效果明显变差；被反复确认真正重要的只有一条：**保留遗忘门，并给它合适的偏置**。Jozefowicz 等（2015）在语言建模上检索了一万余种循环网络架构，报告确实存在优于标准 LSTM 的变体，但**架构改动带来的收益整体小于超参与初始化带来的差异**，而「遗忘门偏置初始化为 1 的 LSTM」始终是稳妥的默认。

**本书判断**：这两份对照合起来给出一条工程纪律——**先把标准 LSTM（或 GRU）配好超参、跑成 baseline，再考虑换变体**；在换变体之前，先确认你的瓶颈是「记忆时长」而不是学习率、初始化、数据量或归一化。反过来，「门越多、结构越花哨越强」在文献对照中**没有**得到支持。
:::

## 2.3.5 双向与堆叠：把门控单元组合成编码器 {#sec-2.3.5}

::: def 定义 2.3.4 · 双向 RNN 与残差堆叠 {#def-2.3.4}
**双向 RNN**（bidirectional RNN）：用两套独立参数在同一序列上分别前向与后向递推，再把两个方向拼起来：

$$\overrightarrow{\boldsymbol h}_t=f_{\text{fwd}}\bigl(\boldsymbol x_t,\overrightarrow{\boldsymbol h}_{t-1}\bigr),\qquad
\overleftarrow{\boldsymbol h}_t=f_{\text{bwd}}\bigl(\boldsymbol x_t,\overleftarrow{\boldsymbol h}_{t+1}\bigr),\qquad
\boldsymbol h_t=\bigl[\overrightarrow{\boldsymbol h}_t;\overleftarrow{\boldsymbol h}_t\bigr]\in\mathbb R^{2d_h}.$$

**多层堆叠**（stacking）：第 $l$ 层的输入是第 $l-1$ 层的输出序列 $H^{(l-1)}\in\mathbb R^{B\times T\times d_h}$，即 $H^{(l)}=\mathrm{RNN}^{(l)}(H^{(l-1)})$，逐层加高；层数多时可用**残差连接**把每层写成 $H^{(l)}=H^{(l-1)}+\mathcal F^{(l)}(H^{(l-1)})$，给梯度一条不经过非线性与权重连乘的短路（思想来自 ResNet，He 等 2015）。
:::

::: intuition 一个看过去、一个看未来；代价是「必须等整句到手」
双向让**同一个位置**同时拿到左右两份上下文，因此对「标注 / 编码整句」类任务（词性标注、命名实体识别、句子编码）特别有效。

但这也写死了它的适用范围：后向递推要求 $\boldsymbol x_T$ 先到齐，所以双向**必须**看到整句，**不能**用于自回归生成、也不能用于任何因果场景——生成第 $t$ 个 token 时未来的 token 还不存在；若训练时用双向编码器「偷看」了右边的真实 token，训练损失会很漂亮，一旦改为逐 token 生成就立刻崩坏（[2.8](sec28.md) 的生成流程会把这个不一致暴露出来）。同理，流式 / 在线场景（每来一个新样本就要立刻输出）也不能直接用双向，除非接受固定延迟。
:::

## 2.3.6 形状与参数量 {#sec-2.3.6}

::: ex 例 2.3.1 · 三种循环单元的参数量对比 {#ex-2.3.1}
取输入维 $d_x=32$、隐状态维 $d_h=128$，只统计**循环单元本身**（不含输出层——三者共用同一个输出投影 $\boldsymbol W_{hy}\in\mathbb R^{d_y\times d_h}$，不影响倍数）。分别求朴素 RNN、GRU、LSTM 的参数量（含偏置），以及各自相对朴素 RNN 的倍数。

::: proof 解
**(0) 先记一个「基准块」。** 三者都是由若干组「输入投影 + 循环投影 + 偏置」构成，一组的大小是

$$d_h\,d_x+d_h\,d_h+d_h=128\times32+128\times128+128=4096+16{,}384+128=20{,}608 .$$

**(1) 朴素 RNN**：只有一组（$W_{xh},W_{hh},\boldsymbol b_h$），即 $1\times20{,}608=20{,}608$。

**(2) GRU**：三组（$\boldsymbol z_t$ 一组、$\boldsymbol r_t$ 一组、候选 $\tilde{\boldsymbol h}_t$ 一组；候选那组同样以 $[\boldsymbol h_{t-1},\boldsymbol x_t]$ 为输入，故块大小相同，重置门只改变输入的值、不改变形状）：

$$3\times20{,}608=61{,}824,\qquad \frac{61{,}824}{20{,}608}=3.00 .$$

**(3) LSTM**：四组（$\boldsymbol f_t,\boldsymbol i_t,\boldsymbol o_t,\tilde{\boldsymbol c}_t$ 各一组），$4\times20{,}608=82{,}432$，倍数 $4.00$。

**(4) 与框架实现对账。** 用 `nn.RNN / nn.GRU / nn.LSTM(32, 128)` 直接 `sum(p.numel() for p in m.parameters())`，会看到略大的数：实现里每个门同时挂 `bias_ih` 与 `bias_hh` 两组偏置（各 $d_h$），于是 $(20{,}608+128)\times\{1,3,4\}=\{20{,}736,\ 62{,}208,\ 82{,}944\}$——**倍数仍是 $3$ 与 $4$**，差别只在偏置项，不影响结论（具体数值以你所用版本的实现为准）。

**读法**：门控不是免费的——LSTM 的参数量是朴素 RNN 的 $4$ 倍、GRU 是 $3$ 倍；相对 GRU，LSTM 多出的那一组参数买到的正是「记忆与输出分离」这个自由度。$\blacksquare$
:::
:::

::: method 形状与参数量对照表 {#method-2.3.1}
本书统一「批优先」（batch-first）：输入 $\boldsymbol X$ 形状 $(B,T,d_x)$，$B$ 为批大小、$T$ 为时间步。单步的形状推演是：$\boldsymbol X$ 沿 $T$ 切片得 $\boldsymbol x_t:(B,d_x)$ → 拼接 $[\boldsymbol h_{t-1},\boldsymbol x_t]:(B,d_h+d_x)$ → 四个门各 $(B,d_h)$ → $\boldsymbol c_t,\boldsymbol h_t:(B,d_h)$ → 逐步堆叠输出 $(B,T,d_h)$。**$T$ 个时间步共享同一个 $W_f$，因此参数量与 $T$ 无关**——这正是 2.1 节「参数不随序列长度变化」的要求。

| 量 | 形状 | 说明 |
|:--|:--|:--|
| 输入 $\boldsymbol X$ | $(B,T,d_x)$ | `batch_first=True` |
| 单元状态（RNN / GRU） | $(B,d_h)$ | 只有一个；$\boldsymbol h_0$ 常取零向量 |
| 单元状态（LSTM） | $(B,d_h)$ 两组 | $(\boldsymbol h_t,\boldsymbol c_t)$ **成对出现，跨步都要传** |
| 逐时间步输出 | $(B,T,d_h)$，双向为 $(B,T,2d_h)$ | `nn.LSTM` 的第一个返回值 |
| `h_n` / `c_n` | $(\text{num\_layers}\times\text{num\_directions},\ B,\ d_h)$ | 只有**最后一个时间步**的状态；`c_n` 仅 LSTM 有 |

| 单元 | 参数量（含单组偏置） | 相对倍数 | $d_x=32,\ d_h=128$ |
|:--|:--|:--|:--|
| 朴素 RNN | $d_h(d_x+d_h)+d_h$ | $1\times$ | $20{,}608$ |
| GRU | $3\bigl[d_h(d_x+d_h)+d_h\bigr]$ | $3\times$ | $61{,}824$ |
| LSTM | $4\bigl[d_h(d_x+d_h)+d_h\bigr]$ | $4\times$ | $82{,}432$ |

多层与双向的推广：层数 $L$、方向数 $D\in\{1,2\}$ 时，参数量约为单层的 $L\times D$ 倍——**这是个近似**，因为只有第一层的输入维是 $d_x$、其后每层是 $D\,d_h$，所以 $L\gt1$ 时该估计会有偏差（首层偏小或偏大取决于 $d_x$ 与 $D\,d_h$ 的大小关系）；状态形状里的 $\text{num\_layers}\times\text{num\_directions}$ 就是 $L\times D$。
:::

## 2.3.7 代码：手写 LSTM 单元并与 nn.LSTM 对齐 {#sec-2.3.7}

```python
import torch, torch.nn as nn

torch.manual_seed(0)
d_x, d_h, B = 8, 16, 4

class LSTMCellManual(nn.Module):
    """手写 LSTM 单元；门序与 PyTorch 一致：i, f, g, o"""
    def __init__(self, d_x, d_h):
        super().__init__()
        # 一个 Linear 同时接收 [x_t, h_{t-1}]：等价于把 W_i|W_f|W_g|W_o 四块拼起来（定义 2.3.1 的分块形式）
        self.W = nn.Linear(d_x + d_h, 4 * d_h)

    def forward(self, x, state):
        h, c = state
        z = self.W(torch.cat([x, h], dim=-1))            # (B, 4*d_h)
        i, f, g, o = z.chunk(4, dim=-1)                  # 关键：chunk 顺序必须是 i, f, g, o
        i, f, o = torch.sigmoid(i), torch.sigmoid(f), torch.sigmoid(o)  # 三个门取值 (0,1)
        g = torch.tanh(g)                                # 候选可以写「负」内容，故用 tanh 而非 sigmoid
        c_new = f * c + i * g                            # 加法通道：不经过 W，梯度不必连乘矩阵
        h_new = o * torch.tanh(c_new)                    # 输出门：记忆可以留在内部「不说出来」
        return h_new, (h_new, c_new), f                  # f 只为观察，不参与接口对齐

# ① 与 nn.LSTMCell 数值对齐：把参考实现的两组参数搬进同一个 Linear
ref, mine = nn.LSTMCell(d_x, d_h), LSTMCellManual(d_x, d_h)
with torch.no_grad():
    mine.W.weight.copy_(torch.cat([ref.weight_ih, ref.weight_hh], dim=1))  # 列方向拼接 = [x|h]
    mine.W.bias.copy_(ref.bias_ih + ref.bias_hh)                           # 两组偏置数学上合成一组

x  = torch.randn(B, d_x)
st = (torch.randn(B, d_h), torch.randn(B, d_h))      # 用随机初态：非零状态也必须对得上
with torch.no_grad():
    h_ref, c_ref = ref(x, st)
    h_my, (_, c_my), _ = mine(x, st)
print("max|Δh| =", (h_ref - h_my).abs().max().item(),
      " max|Δc| =", (c_ref - c_my).abs().max().item())
assert torch.allclose(h_ref, h_my, atol=1e-5) and torch.allclose(c_ref, c_my, atol=1e-5)

# ② 顺手把遗忘门偏置设为 1（定义 2.3.1 提过的工程惯例）：偏置顺序是 i|f|g|o，故取第 2 段
with torch.no_grad():
    mine.W.bias[d_h:2 * d_h].fill_(1.0)              # 注意：此后 mine 与 ref 的偏置不再相同（① 已完成）

# ③ 观察遗忘门：小任务要求「每一步都报出第 1 步输入的第 0 维」——要做到就得记住很久
T, readout = 20, nn.Linear(d_h, 1)
opt = torch.optim.Adam(list(mine.parameters()) + list(readout.parameters()), lr=5e-3)

for step in range(1, 401):
    xs  = torch.randn(B, T, d_x)
    tgt = xs[:, 0, 0:1].unsqueeze(1).expand(B, T, 1)  # 整段都要回忆第 1 步：逼着门学「别忘」
    h, c, fs, preds = torch.zeros(B, d_h), torch.zeros(B, d_h), [], []
    for t in range(T):                               # 时间维只能串行——这一步依赖上一步（见 2.3.8）
        h, (h, c), f = mine(xs[:, t], (h, c))
        fs.append(f.detach().mean())                 # 只记录数值，切断反传
        preds.append(readout(h))
    loss = nn.functional.mse_loss(torch.stack(preds, dim=1), tgt)
    loss.backward(); opt.step(); opt.zero_grad()     # 每个 batch 从零状态起步，故无需 detach
    if step % 100 == 0:
        print(f"step {step:3d}  loss {loss.item():.4f}  mean(f) {torch.stack(fs).mean():.3f}")
```

两个观察点。一是 `loss`：数值对齐（`max|Δh|` 约 $6\times10^{-8}$）已经证明这个手写单元与框架实现是**同一个函数**，「能训练」是定义的推论而非巧合。二是 `mean(f)`：它是**训练出来的量**，不是常数。本书在这一设定下的一次运行（种子 0）中，它从 $0.745$ 缓慢爬到 $0.813$，而 `loss` 从 $1$ 上下落到 $0.26$——**门被训练推着走，但并没有趋近 1**：本任务只要求记住 $20$ 步，门值不需要更大；把 ② 那段去掉（不做偏置初始化）时，起点回落到约 $0.5$，跑满同样 400 步也只爬到约 $0.58$——**初始化的作用，就是替门挑一个工作点**。要带走的是定理 2.3.1 的算术：**门值离 $1$ 有多远，决定了它能记多久**；具体数值随随机种子与超参而变，你的运行结果不必与这里相同。

## 2.3.8 陷阱与勘误 {#sec-2.3.8}

::: errata 本节五个常见误解
1. **「门控根治了梯度消失」**：只是**缓解**，而且有三处代价同时存在——① 读出路径 $\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t)$ 每次都要被 $\boldsymbol o_t$ 与 $\tanh'$ 打折；② 完整雅可比里经由 $\boldsymbol h_{t-1}$ 反传到门与候选的间接项仍含 $W$ 的连乘；③ 遗忘门严格小于 $1$，衰减仍按步数累积（$0.99^{100}\approx0.37$，$0.99^{700}\approx8.8\times10^{-4}$）。**判据**：训练时按距离（时间差）统计梯度范数或门均值，看长程梯度是否仍随距离衰减。
2. **「LSTM 训练可以并行」**：不能。状态沿时间**串行**依赖，前向要一步步推进、反向（BPTT）要一步步回退；能并行的是批维 $B$、特征维与同一层内各步**矩阵乘的批量下发**（cuDNN 把逐 step 的 GEMM 调用批量化，但并不消除依赖链）。要让时间维并行，必须换掉递推本身——那是 [2.4](sec24.md) 及之后的主题。
3. **「$\boldsymbol h_t$ 是 LSTM 的唯一状态」**：LSTM 的状态是**一对** $(\boldsymbol h_t,\boldsymbol c_t)$。框架接口也这么写：`nn.LSTM` 返回 `output`（只含各步 $\boldsymbol h$）与 `(h_n, c_n)`；`c_n` 不会出现在 `output` 里。做状态传递或从检查点恢复时，两个都要带上——这也是 `nn.GRU` 只有一个状态而 `nn.LSTM` 有两个的原因。
4. **「双向可以用在生成任务上」**：不能。后向递推要求先看到整句，生成第 $t$ 个 token 时未来还不存在；训练期「偷看未来」会让离线指标虚高、部署时崩坏（见 [2.3.5](#sec-2.3.5)）。
5. **「状态跨 batch 传不传都行」**（两种典型 bug）：若把上一步的状态直接带进下一个 batch，等于让 BPTT 跨过 batch 边界——计算图会跨迭代累积（显存持续增长，乃至 `backward` 报「再次反向同一张图」），你以为在做截断 BPTT，实际做的是「跨 batch 的完整 BPTT」。**正确写法只有两种**：每 batch 把状态重置为零（最常见），或显式 `h = h.detach()`（LSTM 还要 `c = c.detach()`）后传递状态值——**两者语义不同，必须明确选一个**。
:::

::: method 即时自测 · 2.3 {#method-2.3.2}
**Q1** 写出 LSTM 的细胞状态更新式，并说明 $\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}$ 为什么**不含** $W$，以及它「只能衰减、不会放大」的理由。

**Q2**（算参数量）$d_x=64$、$d_h=256$ 时，GRU 与 LSTM 各有多少参数（单组偏置）？各自是朴素 RNN 的几倍？

**Q3** 为什么说「门控只是缓解、不是根治」？给出至少两条理由，并各配一个可观测的判据。

**Q4** GRU 与 LSTM 的加法通道分别对应哪个因子？二者在「自由度」上的差别是什么？

::: sol 参考要点
**Q1** $\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$；直接路径下 $\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}=\operatorname{diag}(\boldsymbol f_t)$——该项里只有本步门值，没有 $W_{hh}$，也没有 $\phi'$。跨 $k$ 步是对角矩阵连乘 $=\operatorname{diag}(\prod_j\boldsymbol f_j)$，对角元是标量连乘，每个因子 $\in(0,1)$，故整条路径的传递系数的绝对值不会超过 $1$：只能衰减，不可能放大（爆炸在这条路径上被排除）。

**Q2** 基准块 $=256\times64+256\times256+256=16{,}384+65{,}536+256=82{,}176$。GRU $=3\times82{,}176=246{,}528$（$3$ 倍）；LSTM $=4\times82{,}176=328{,}704$（$4$ 倍）；朴素 RNN 为 $82{,}176$。（框架实现里每个门多挂一组 `bias_hh`，数值略大，但倍数不变。）

**Q3** ① 读出路径被打折：损失经 $\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t)$ 读出，每步都乘 $\operatorname{diag}(\boldsymbol o_t)\operatorname{diag}(1-\tanh^2(\boldsymbol c_t))$——判据：固定时间差绘制梯度范数，若随距离单调衰减说明读出/间接项在起作用。② 门值严格小于 $1$：$f\equiv0.99$ 时 100 步只剩 $37\%$——判据：打印遗忘门均值是否能被学到 $0.99$ 以上，算一算 $\prod f$ 还剩多少。③ 间接项含 $W$：完整雅可比不只是 $\operatorname{diag}(\boldsymbol f_t)$——判据：把门输入梯度与细胞路径梯度分开统计，看后者是否也有非零贡献。

**Q4** GRU 是 $\operatorname{diag}(1-\boldsymbol z_t)$，LSTM 是 $\operatorname{diag}(\boldsymbol f_t)$。自由度差别：GRU 用**一个**门同时决定「写入」与「保留」（两者互补，和为 1），且状态 $\boldsymbol h_t$ 既当记忆又当输出；LSTM 有**两个独立**的门（$\boldsymbol i_t$ 与 $\boldsymbol f_t$ 互不约束），并且 $(\boldsymbol c_t,\boldsymbol h_t)$ 分离——记忆可以存在而不对外暴露。这是 LSTM 多出的那一组参数买到的东西。
:::
:::

::: note[skip] 延伸阅读
- Hochreiter & Schmidhuber, *Long Short-Term Memory*（1997, Neural Computation 9(8):1735–1780）——原论文，读「常数误差传送带」与门控动机的原始论证。
- Cho 等, *Learning Phrase Representations using RNN Encoder–Decoder*（2014, arXiv:1406.1078）——GRU 的提出与它作为编码器—解码器的应用。
- Greff 等, *LSTM: A Search Space Odyssey*（2015, arXiv:1503.04069）——8 种 LSTM 变体的大范围对照，读它的结论表与「哪一部件重要」的排序。
- Jozefowicz 等, *An Empirical Exploration of Recurrent Network Architectures*（2015, ICML）——一万余种循环架构的经验检索，读它对「架构 vs 超参」的相对贡献的讨论。
- Pascanu, Mikolov & Bengio, *On the Difficulty of Training Recurrent Neural Networks*（2013, arXiv:1211.5063）——连乘雅可比、爆炸与裁剪的分析，与 [2.2](sec22.md) 合读。
- Olah, *Understanding LSTM Networks*（2015, colah.github.io）——用图理解三门与细胞状态的入门读物，配合本节插图看。
:::

**本节小结**：门控把「梯度怎么穿过很多时间步」这个问题从**乘法**换成了**加法**——$\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$ 的直接路径雅可比是 $\operatorname{diag}(\boldsymbol f_t)$，不含 $W$ 的连乘，且「保留多久」成为可学、可条件化的门值；GRU 把三个门压成两个，用插值一次完成遗忘与写入。代价有两条：参数变为朴素 RNN 的 $3\sim4$ 倍，且**训练仍沿时间串行**——门控没有解决并行问题，也没有根治衰减（$\sigma$ 永远取不到 $1$）。还有一个更基础的瓶颈没被动过：无论 LSTM 还是 GRU，历史最终都要压进**定长的向量** $\boldsymbol h_t$。2.4 节的注意力正是来拆这个瓶颈的：不再压缩，而是让每个位置**直接回看所有位置**。
