# 第 2 讲 · 闭卷回忆卡

> **用法**：遮住答案，在**空白纸**上写；写完再展开对照。每张卡末尾标记号：**✓** 能完整写出 / **△** 有关键词但缺条件 / **×** 完全想不起，只重做 △ 与 ×。共 40 张卡，一轮约 35 分钟。

## A. 定义卡

**A1.** 写出「序列建模问题」的三条要求，并各配一个「违反它」的做法。
::: sol
① **参数不变性**——$\lvert\theta\rvert\neq\mathcal O(T)$（违反者：把序列摊平、给每个位置配一套权重的 MLP）；② **顺序敏感**——$f_\theta(\boldsymbol x_{1:T})\neq f_\theta(\boldsymbol x_{\pi(1:T)})$（违反者：对所有词向量取平均的词袋模型）；③ **一致性**——同一组 $\theta$ 能作用到训练时未见过的长度（违反者：pad 到最大长度再喂固定形状网络）。三条合起来只剩一条路：**沿序列方向共享同一套函数**（[定义 2.1.1](sec21.md#def-2.1.1)）。（✓ / △ / ×）
:::

**A2.** 序列任务按输出形态分哪四类？其中哪两类**必须因果**，为什么？
::: sol
**序列 → 标签**（句级分类，可双向）、**同步对齐**（$T_{\text{out}}=T_{\text{in}}$，因果）、**异步序列 → 序列**（编码器可双向 + 解码器因果）、**自回归生成**（因果）。必须因果的是**同步对齐**（逐帧在线，未来数据还没产生）与**自回归生成**（第 $t$ 步只能看 $\le t$）——这是任务约束，不是模型偏好（[定义 2.1.2](sec21.md#def-2.1.2)）。（✓ / △ / ×）
:::

**A3.** 写出 RNN 的递推式与参数量，并说明「参数与 $T$ 无关」的代价。
::: sol
$\boldsymbol z_t=W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h$、$\boldsymbol h_t=\phi(\boldsymbol z_t)$、$\hat{\boldsymbol y}_t=\psi(W_{hy}\boldsymbol h_t+\boldsymbol b_y)$；参数量 $(d_x+d_h)d_h+d_h+d_y d_h$。代价三条：① 沿时间**不能并行**（串行深度 $T$）；② 梯度要穿过 $T$ 次状态转移（连乘 ⇒ 消失 / 爆炸）；③ 全部历史压进固定 $d_h$ 维状态——**有损摘要**（[定义 2.2.1](sec22.md#def-2.2.1)、[定理 2.2.1](sec22.md#thm-2.2.1)）。（✓ / △ / ×）
:::

**A4.** 写出 BPTT 的**单步雅可比** $J_k$、跨多步的雅可比与误差信号 $\boldsymbol\delta_t$ 的定义。
::: sol
$\boldsymbol z_k=W_{hh}\boldsymbol h_{k-1}+W_{xh}\boldsymbol x_k+\boldsymbol b_h$，$J_k=\dfrac{\partial\boldsymbol h_k}{\partial\boldsymbol h_{k-1}}=\operatorname{diag}\bigl(\phi'(\boldsymbol z_k)\bigr)W_{hh}$；$\dfrac{\partial\boldsymbol h_s}{\partial\boldsymbol h_t}=\prod_{k=t+1}^{s}J_k$；$\boldsymbol\delta_t=\operatorname{diag}(\phi'(\boldsymbol z_t))\Bigl(W_{hy}^{\mathrm T}\dfrac{\partial\mathcal L_t}{\partial\hat{\boldsymbol y}_t}+W_{hh}^{\mathrm T}\boldsymbol\delta_{t+1}\Bigr)$，且 $\dfrac{\partial\mathcal L}{\partial W_{hh}}=\sum_t\boldsymbol\delta_t\boldsymbol h_{t-1}^{\mathrm T}$（[定义 2.2.2](sec22.md#def-2.2.2)、[定理 2.2.2](sec22.md#thm-2.2.2)）。（✓ / △ / ×）
:::

**A5.** 写出 LSTM 的三门与细胞状态更新式，并说明 $\boldsymbol c_t$ 与 $\boldsymbol h_t$ 的分工。
::: sol
$\boldsymbol f_t,\boldsymbol i_t,\boldsymbol o_t=\sigma(W[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b)$，$\tilde{\boldsymbol c}_t=\tanh(\cdot)$，$\boldsymbol c_t=\boldsymbol f_t\odot\boldsymbol c_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol c}_t$，$\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t)$。$\boldsymbol c_t$ 是内部**长期记忆**（不对外输出），$\boldsymbol h_t$ 是读出来给输出层与门控用的部分；$\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}=\operatorname{diag}(\boldsymbol f_t)$ 就是那条**加法通道**（[定义 2.3.1](sec23.md#def-2.3.1)）。（✓ / △ / ×）
:::

**A6.** 写出 GRU 的两个门与更新式，并说明它与 LSTM 在自由度上的差别。
::: sol
$\boldsymbol z_t,\boldsymbol r_t=\sigma(W[\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b)$，$\tilde{\boldsymbol h}_t=\tanh\bigl(W[\boldsymbol r_t\odot\boldsymbol h_{t-1},\boldsymbol x_t]+\boldsymbol b_h\bigr)$，$\boldsymbol h_t=(1-\boldsymbol z_t)\odot\boldsymbol h_{t-1}+\boldsymbol z_t\odot\tilde{\boldsymbol h}_t$；加法通道对应因子是 $\operatorname{diag}(1-\boldsymbol z_t)$。差别：GRU 用**一个**门同时决定「写入」与「保留」（互补），且 $\boldsymbol h_t$ 既当记忆又当输出；LSTM 有**两个独立**的门，且 $(\boldsymbol c_t,\boldsymbol h_t)$ 分离——记忆可以存在而不对外暴露（[定义 2.3.2](sec23.md#def-2.3.2)）。（✓ / △ / ×）
:::

**A7.** 写出缩放点积注意力，说明 softmax 沿哪一维、输出形状，以及 Q / K / V 各扮演什么角色。
::: sol
$\operatorname{Attention}(\boldsymbol Q,\boldsymbol K,\boldsymbol V)=\operatorname{softmax}\!\left(\dfrac{\boldsymbol Q\boldsymbol K^{\mathrm T}}{\sqrt{d_k}}\right)\boldsymbol V$；$\boldsymbol Q\in\mathbb R^{T_q\times d_k}$、$\boldsymbol K\in\mathbb R^{T_k\times d_k}$、$\boldsymbol V\in\mathbb R^{T_k\times d_v}$，softmax 沿**键维**（每一行），输出 $T_q\times d_v$，每个位置是 $\boldsymbol V$ 各行的**凸组合**。Q 是「想找什么」、K 是「挂出的匹配标签」、V 是「真正被取走的内容」——**键指路、值交货**（[定义 2.4.4](sec24.md#def-2.4.4)）。（✓ / △ / ×）
:::

**A8.** 写出因果掩码的定义，并列出三条实现细节。
::: sol
$\boldsymbol S\leftarrow\boldsymbol S+\boldsymbol M$，$M_{ij}=0\ (j\le i)$、$M_{ij}=-\infty\ (j\gt i)$，且**必须在 softmax 之前**加：$\boldsymbol P=\operatorname{softmax}(\boldsymbol S/\sqrt{d_k}+\boldsymbol M)$。三条细节：① 位置不可交换（加在之后行和不为 1）；② 用 $-\infty$ 或该 dtype 的 `finfo.min`（加 0 等于不掩码，固定的 $-10^9$ 在低精度下不可靠）；③ 整行全被掩码时 softmax 给出 `NaN`，要保证「至少可见自己」或做重归一化 / `nan_to_num`（[定义 2.4.5](sec24.md#def-2.4.5)）。（✓ / △ / ×）
:::

**A9.** 写出多头自注意力与一个 Pre-LN 块的公式。
::: sol
$\boldsymbol Q_j=\boldsymbol XW_j^Q$、$\boldsymbol K_j=\boldsymbol XW_j^K$、$\boldsymbol V_j=\boldsymbol XW_j^V$（$W_j^\bullet\in\mathbb R^{d\times d_h}$，$d_h=d/H$），$\operatorname{head}_j=\operatorname{Attention}(\boldsymbol Q_j,\boldsymbol K_j,\boldsymbol V_j)$，$\operatorname{MHA}(\boldsymbol X)=[\operatorname{head}_1;\dots;\operatorname{head}_H]W^O$；Pre-LN 块：$\boldsymbol Y=\boldsymbol X+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X))$（两个子层各一次，收尾再归一化）（[定义 2.5.1](sec25.md#def-2.5.1)、[定义 2.5.3](sec25.md#def-2.5.3)）。（✓ / △ / ×）
:::

**A10.** 自回归解码里 KV cache 缓存的是什么？每步算多少？复杂度怎么变？
::: sol
缓存的是历史位置的**键与值** $\boldsymbol K_{1:t},\boldsymbol V_{1:t}$（每头一份、$t\times d_h$，头数为 $n_{kv}$）；每一步只为新 token 计算 $\boldsymbol Q_t$，再与缓存的 $\boldsymbol K_{1:t}$ 做注意力。增量计算量由 $O(t^2d)$ 降为 $O(td)$；显存 $2LB\,Tn_{kv}d_h$ 字节，随 $B\cdot T$ **线性**增长（[定义 2.5.4](sec25.md#def-2.5.4)、[方法 2.5.3](sec25.md#method-2.5.3)）。（✓ / △ / ×）
:::

## B. 结论卡

**B1.** 为什么说「参数与 $T$ 无关」是 RNN 全部价值的来源？它的三条代价是什么？
::: sol
因为 $W_{hh},W_{xh},\boldsymbol b_h$ 在**所有时间步复用**，参数量与序列长度无关，且同一模式出现在任何位置都由同一组参数识别，因此可以外推到训练时未见的长度。代价：不能沿时间并行（串行深度 $T$）、梯度必须穿过 $T$ 次状态转移（连乘雅可比）、状态是**有损摘要**（容量固定而历史任意长）（[定理 2.2.1](sec22.md#thm-2.2.1)、[方法 2.2.1](sec22.md#method-2.2.1)）。（✓ / △ / ×）
:::

**B2.** 为什么梯度裁剪**只能**治爆炸、不能治消失？给一句严格理由。
::: sol
裁剪是**等比缩小**：$\boldsymbol g\leftarrow\boldsymbol g\cdot\min(1,c/\lVert\boldsymbol g\rVert)$，方向不变、只改尺度。梯度已经衰减到 $10^{-9}$ 时，乘一个 $\le1$ 的系数还是 $10^{-9}$ 量级——**救不回已被连乘吞掉的信号**。它治的是爆炸方向（防溢出与 `NaN`），是一场安全网而不是疗法（[方法 2.2.2](sec22.md#method-2.2.2)、[2.2.5](sec22.md#sec-2.2.5)）。（✓ / △ / ×）
:::

**B3.** 为什么说「门控只是缓解、不是根治」？给出至少两条理由，并各配一个可观测判据。
::: sol
① **读出路径被打折**：损失经 $\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t)$ 读出，每步都乘 $\operatorname{diag}(\boldsymbol o_t)\operatorname{diag}(1-\tanh^2)$——判据：按时间差统计梯度范数，看长程梯度是否仍随距离衰减；② **门值严格小于 1**：$f\equiv0.99$ 时 100 步只剩 $37\%$、$700$ 步只剩 $8.8\times10^{-4}$——判据：打印遗忘门均值是否被学到 $0.99$ 以上、再算 $\prod f$；③ **间接项仍含 $W$**：完整雅可比不只是 $\operatorname{diag}(\boldsymbol f_t)$，经 $\boldsymbol h_{t-1}$ 反传到门与候选的项依旧含矩阵连乘（[定理 2.3.1](sec23.md#thm-2.3.1)、[2.3.8](sec23.md#sec-2.3.8)）。（✓ / △ / ×）
:::

**B4.** 为什么注意力要除以 $\sqrt{d_k}$？它防的是溢出吗？
::: sol
独立零均值单位方差下 $\operatorname{Var}(\boldsymbol q^{\mathrm T}\boldsymbol k)=d_k$、标准差 $\sqrt{d_k}$，不缩放时分数尺度随维度增大，softmax 被推入**饱和区**（最大权重趋 1、其余趋 0），其对输入的导数 $p(1-p)$ 趋 0，反向梯度被掐断。除 $\sqrt{d_k}$ 把方差拉回 $1$，让 softmax 工作在梯度良好的区间。**它防的不是数值溢出**（$d_k=1024$ 时标准差才 32），而是**工作点 / 饱和**——与第 1 讲 Sigmoid 饱和同源（[定理 2.4.1](sec24.md#thm-2.4.1)）。（✓ / △ / ×）
:::

**B5.** 为什么位置编码是必需品？掩码为什么不能替代它？
::: sol
纯注意力**置换等变**：$\operatorname{Attention}(\boldsymbol P_\pi\boldsymbol X,\dots)=\boldsymbol P_\pi\operatorname{Attention}(\boldsymbol X,\dots)$——打乱输入的行，输出只是被同样打乱、每个位置拿到的上下文一模一样，因此模型分不清「狗咬人」与「人咬狗」。掩码只提供「谁在谁左边」这一位**方向**信息，不提供**距离与位置**：它能学出「只看前一个 token」，无法表达「相隔 7 步」。所以位置必须**显式注入**（嵌入加性 / QK 乘性 / 分数加性三选一）（[定理 2.4.2](sec24.md#thm-2.4.2)、[2.6.1](sec26.md#sec-2.6.1)）。（✓ / △ / ×）
:::

**B6.** 「训练可并行、推理必须串行」是工程缺陷吗？为什么？
::: sol
不是——是**自回归目标的结构性后果**：训练时知道正确答案，可用因果掩码在**同一次前向**里模拟出「每个位置只看左边」并一次算完 $T$ 个位置；推理时 $p(x_{t+1}\mid x_{\le t})$ 的条件里含**模型自己**的采样结果，第 $t+1$ 个 token 必须先生成才能作为下一步输入。三条推论：长上下文推理瓶颈常在**显存带宽**、batch 内长度不齐要连续批处理、KV cache 必须靠 GQA / 量化 / 滑窗压缩（[2.5.6](sec25.md#sec-2.5.6)）。（✓ / △ / ×）
:::

**B7.** Pre-LN 与 Post-LN 的差别是什么？各自付出什么代价？
::: sol
Post-LN：$\boldsymbol Y=\operatorname{LN}(\boldsymbol X+\operatorname{Sub}(\boldsymbol X))$；Pre-LN：$\boldsymbol Y=\boldsymbol X+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X))$。论文报告：Post-LN 靠近输出层的参数梯度尺度较大（形如 $d\ln d$ 的量级项），需要**学习率预热**；Pre-LN 的梯度尺度与深度基本无关、去掉预热也能训。代价：Pre-LN 主干是恒等累加，$\lVert\boldsymbol X_L\rVert=\mathcal O(\sqrt L)$ 随深度累积，**必须加收尾归一化**才能接输出头；此外该结论是「训练稳定性」层面的，不是「效果一定更好」的承诺（[定理 2.5.2](sec25.md#thm-2.5.2)）。（✓ / △ / ×）
:::

**B8.** FlashAttention 为什么快？它是近似算法吗？它减少了什么、没减少什么？
::: sol
它把不物化的分数矩阵留在**片上内存**、用**在线 softmax** 边算边累积（运行最大值 $m_j$ + 指数和 $\ell_j$ 的重缩放递推），反向传播用**重计算**代替保存。**不是近似**：分块递推与整块 softmax 的数学结果完全相同，差别只有浮点舍入（所以要用 FP32 累积统计量）。**FLOPs 不变**（$4BHT^2d_h$ 一步没少）；省的是 $T\times T$ 中间矩阵在 HBM 上的读写与存放（中间显存 $O(T^2)\to O(T)$）——「快的根因是少搬了几趟数据」（[定理 2.6.4](sec26.md#thm-2.6.4)）。（✓ / △ / ×）
:::

**B9.** 线性 SSM 为什么能同时做到「训练并行」与「推理 $O(1)$ 状态」？Mamba 改了什么、又怎么找回并行度？
::: sol
因为转移是**线性且时不变**的，递推可以展开成固定核的**因果卷积**（$\boldsymbol y=\bar K*\boldsymbol x$，$\bar K_t=C\bar A^t\bar B$）：训练用一次卷积（分块 / FFT）并行算完，推理换回递推、只带固定大小状态。Mamba 让 $\Delta_t,B_t,C_t$ **依赖输入**（不再是时不变），固定核不存在、卷积形式失效——换回并行度的办法是**并行扫描**（块内串行、块间前缀扫描，并行深度 $O(T/C)$，中间状态留在片上）。Mamba-2 进一步证明：在「标量×恒等」约束下 SSM 与带因果掩码的注意力**同族**（[定理 2.7.1](sec27.md#thm-2.7.1)、[定理 2.7.2](sec27.md#thm-2.7.2)、[方法 2.7.1](sec27.md#method-2.7.1)）。（✓ / △ / ×）
:::

**B10.** MoE 把什么解耦了？它省的是显存还是计算量？代价是什么？
::: sol
把「**总参数量**」与「**每 token 计算量**」解耦：$N$ 个专家、每 token 选 $k$ 个时，专家参数 $\approx NP$、每 token 计算 $\approx kP$，比值 $N/k$。**省的是每 token 计算量（换来吞吐），不是显存**——全部专家参数必须常驻，MoE 的显存需求反而更大。代价还有 all-to-all 通信（dispatch / combine）与负载不均造成的设备空转，必须靠辅助损失 / 动态偏置与容量因子共同控制（[定理 2.7.4](sec27.md#thm-2.7.4)、[方法 2.7.2](sec27.md#method-2.7.2)）。（✓ / △ / ×）
:::

**B11.** 困惑度是什么？它「说明什么、不说明什么」？温度会改变它吗？
::: sol
$\mathrm{PPL}=\exp(H)$，$H$ 是每 token 平均负对数似然（nat）——读作「模型在每个位置相当于在多少个等概率候选之间犹豫」，取值 $[1,V]$，均匀分布时 $\mathrm{PPL}=V$。它说明「给定真实前缀，下一个 token 猜得准不准」，**不说明**生成质量：背下训练集的模型可以有极低 PPL，自由跑时却三步内复读；也不含误差累积（exposure bias）。温度与 PPL 的关系**取决于口径**：用重标定分布算 NLL 时 $\tau$ 变小会变差，用自己生成的序列算 NLL 时 $\tau$ 越小越好——报告必须写清是哪一个（[定理 2.8.1](sec28.md#thm-2.8.1)、[2.8.6](sec28.md#sec-2.8.6)）。（✓ / △ / ×）
:::

## C. 公式卡

**C1.** 写出 RNN 的参数量表达式，并说说它与「摊平的 MLP」差在哪。
::: sol
$(d_x+d_h)d_h+d_h+d_y d_h$，**与 $T$ 无关**；摊平 MLP 的第一层是 $d_h(Td_x)$——随长度线性增长，且 $T$ 一变就得重来（[方法 2.2.1](sec22.md#method-2.2.1)）。（✓ / △ / ×）
:::

**C2.** 写出跨 $n$ 步的雅可比、范数界与**有效记忆跨度**公式。
::: sol
$\dfrac{\partial\boldsymbol h_s}{\partial\boldsymbol h_t}=\prod_{k=t+1}^{s}\operatorname{diag}(\phi'(\boldsymbol z_k))W_{hh}$；$\Bigl\lVert\prod_k J_k\Bigr\rVert_2\le\bigl(\max_k\lVert J_k\rVert_2\bigr)^{n}\le\lVert W_{hh}\rVert_2^{\,n}$（长期由**谱半径**主导）；以「低于 $10^{-7}$ 视为被吞掉」为判据得 $n^\star=\dfrac{-7}{\log_{10}\rho}$：$\rho=0.9\to153$ 步、$0.98\to798$ 步、$0.99\to1604$ 步（[定理 2.2.3](sec22.md#thm-2.2.3)、[例 2.2.1](sec22.md#ex-2.2.1)）。（✓ / △ / ×）
:::

**C3.** 写出 LSTM 的加法通道雅可比，以及门值「学到接近 1」需要多大预激活。
::: sol
直接路径 $\dfrac{\partial\boldsymbol c_t}{\partial\boldsymbol c_{t-1}}=\operatorname{diag}(\boldsymbol f_t)$，跨 $k$ 步 $=\operatorname{diag}\bigl(\prod_j\boldsymbol f_j\bigr)$（逐元素标量连乘，只衰减不放大）。要把 $k$ 步的保留率做到 $1-\epsilon$ 以上，需要每步衰减 $\gamma\lesssim\epsilon/k$，即门预激活 $z\gtrsim\ln(k/\epsilon)$：$k=100,\epsilon=0.1$ 时 $z\gtrsim\ln1000\approx6.9$——远大于偏置 1 的起手值 $\sigma(1)\approx0.73$（[定理 2.3.1](sec23.md#thm-2.3.1) 后的推导）。（✓ / △ / ×）
:::

**C4.** 写出门控参数量对照表（$d_x=32,d_h=128$ 与一般式）。
::: sol
一般式：朴素 RNN $d_h(d_x+d_h)+d_h$；GRU $3\times$、LSTM $4\times$ 同一块。$d_x=32,d_h=128$ 时基准块 $20{,}608$ ⇒ 朴素 RNN $20{,}608$、GRU $61{,}824$、LSTM $82{,}432$；框架实现每门多一组 `bias_hh`，得 $20{,}736/62{,}208/82{,}944$，**倍数仍是 $1:3:4$**（[例 2.3.1](sec23.md#ex-2.3.1)）。（✓ / △ / ×）
:::

**C5.** 写出注意力的形状链与「一行等于什么」。
::: sol
$\boldsymbol S=\boldsymbol Q\boldsymbol K^{\mathrm T}\in\mathbb R^{T_q\times T_k}$（内积相似度）→ $\boldsymbol S/\sqrt{d_k}$（缩放）→ $\boldsymbol P=\operatorname{softmax}(\cdot)$ 沿键维（每行和为 1）→ $\boldsymbol O=\boldsymbol P\boldsymbol V\in\mathbb R^{T_q\times d_v}$。$\boldsymbol O$ 的第 $i$ 行是 $\boldsymbol V$ 各行的**凸组合**（权重非负、和为 1）；自注意力里 $T_q=T_k=T$ 且三路投影自同一输入（[定义 2.4.4](sec24.md#def-2.4.4)）。（✓ / △ / ×）
:::

**C6.** 写出注意力三笔账的复杂度与倍数关系。
::: sol
分数 / 权重矩阵（单层）$B\cdot H\cdot T^2$ 个元素、FP16 占 $BH\,T^2\times2$ 字节；注意力 FLOPs（前向）约 $4B\,H\,T^2d_h$；KV cache（整模型）$2LB\,Tn_{kv}d_h\times2$ 字节。$T$ 每乘 $4$：前两者乘 $16$、KV cache 只乘 $4$（[定理 2.4.3](sec24.md#thm-2.4.3)、[方法 2.6.1](sec26.md#method-2.6.1)）。（✓ / △ / ×）
:::

**C7.** 写出多头注意力、FFN 与「每层 $12d^2$」的参数量。
::: sol
多头 $4d^2+4d$（与 $H$ 无关）；经典 FFN $d\to4d\to d$ 是 $8d^2+5d$；合计每层 $\approx12d^2$，FFN 占 $2/3$、注意力占 $1/3$（$d=768$ 时单块 $7{,}087{,}872$，12 层 $\approx85$M）（[定理 2.5.1](sec25.md#thm-2.5.1)、[例 2.5.1](sec25.md#ex-2.5.1)）。（✓ / △ / ×）
:::

**C8.** 写出 LN 与 RMSNorm 的公式，以及 Post-LN / Pre-LN 两种布局。
::: sol
$\operatorname{LN}(\boldsymbol x)=\boldsymbol\gamma\odot\dfrac{\boldsymbol x-\mu}{\sqrt{\sigma^2+\epsilon}}+\boldsymbol\beta$（$\mu,\sigma^2$ 是该位置在**特征维**上的统计量）；$\operatorname{RMSNorm}(\boldsymbol x)=\boldsymbol\gamma\odot\dfrac{\boldsymbol x}{\sqrt{\operatorname{mean}(\boldsymbol x^2)+\epsilon}}$（去掉去均值与偏置）。布局：Post-LN $\boldsymbol Y=\operatorname{LN}(\boldsymbol X+\operatorname{Sub}(\boldsymbol X))$；Pre-LN $\boldsymbol Y=\boldsymbol X+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X))$（[定义 2.5.3](sec25.md#def-2.5.3)）。（✓ / △ / ×）
:::

**C9.** 写出正弦位置编码、RoPE 的内积性质与 ALiBi 的偏差形式。
::: sol
$PE_{(pos,2i)}=\sin(pos/10000^{2i/d})$、$PE_{(pos,2i+1)}=\cos(pos/10000^{2i/d})$，**加到**词嵌入上；RoPE：$\langle\boldsymbol R_m\boldsymbol q,\boldsymbol R_n\boldsymbol k\rangle=\langle\boldsymbol q,\boldsymbol R_{n-m}\boldsymbol k\rangle$——缩放前分数只依赖相对位移 $n-m$；ALiBi：$s_{ij}\mathrel{+}=-m_h(i-j)$（每头一个斜率）；T5：$s_{ij}\mathrel{+}=b_{\text{bucket}(i-j)}$（分桶可学习偏差）（[定义 2.6.1](sec26.md#def-2.6.1)、[定理 2.6.3](sec26.md#thm-2.6.3)、[定义 2.6.4](sec26.md#def-2.6.4)、[定义 2.6.5](sec26.md#def-2.6.5)）。（✓ / △ / ×）
:::

**C10.** 写出 KV cache 的字节公式，并复算「$L=32,d=4096,H=32,d_h=128,B=1,T=8192$、FP16」的三档数字。
::: sol
$2\cdot L\cdot B\cdot T\cdot n_{kv}\cdot d_h\times2$ 字节。MHA（$n_{kv}=32$）$=4.0$ GiB；GQA（$n_{kv}=8$，每 4 个查询头共享一组）$=1.0$ GiB；MQA（$n_{kv}=1$）$=0.125$ GiB。而 $d=4096,L=32$ 的模型权重约 $12Ld^2\approx6.4$B 参数、FP16 约 12.8 GB——**$T$ 一大 KV cache 就会逼近甚至超过权重**（[方法 2.5.3](sec25.md#method-2.5.3)）。（✓ / △ / ×）
:::

**C11.** 写出温度采样、top-p 的定义与困惑度的关系。
::: sol
$\hat p_i=\dfrac{\exp(z_i/\tau)}{\sum_j\exp(z_j/\tau)}$（等价于「把 logits 除以 $\tau$ 再 softmax」；$\tau\to0^+$ 趋近 argmax、$\tau=1$ 是原分布、$\tau\gt1$ 被摊平）；top-p（核采样）：取最小 $\mathcal S$ 使 $\sum_{i\in\mathcal S}\hat p_i\ge p$（跨过阈值的那个保留），再在 $\mathcal S$ 上重归一化。**分布越平（$\tau$ 大）核越大**——因为需要更多候选才能凑够同样的概率质量。$\mathrm{PPL}=e^{H}$，与采样策略无关（[定义 2.8.3](sec28.md#def-2.8.3)、[定义 2.8.4](sec28.md#def-2.8.4)、[定理 2.8.1](sec28.md#thm-2.8.1)）。（✓ / △ / ×）
:::

## D. 陷阱卡（每题给一个错误说法，请指出错在哪）

**D1.** 「把序列 pad 到定长再喂 MLP，是可行的工程折中」；「序列就是一堆符号，顺序不影响训练」。
::: sol
两处都错。① pad + MLP 的参数量随最长长度线性增长、且无法外推到更长输入，违反参数不变性与一致性（pad 只适合长度高度集中的窄场景，且 pad 位置必须在损失端屏蔽）。② 顺序当然影响：词袋式平均对「狗咬人 / 人咬狗」毫无区分能力，**保序**是三条要求之一（[定义 2.1.1](sec21.md#def-2.1.1)、[2.1.6](sec21.md#sec-2.1.6)）。（✓ / △ / ×）
:::

**D2.** 「换成 ReLU 就不梯度消失了」；「梯度裁剪能解决梯度消失」。
::: sol
两处都错。① 界 $\lVert J_k\rVert_2\le\lVert W_{hh}\rVert_2$ 与激活无关，ReLU 只去掉饱和项；真正有效的是正交 / 单位初始化 + 门控加法通道 + 残差。② 裁剪是等比缩小，梯度已到 $10^{-9}$ 时乘一个 $\le1$ 的系数仍是 $10^{-9}$——**裁剪只防爆炸**（[定理 2.2.3](sec22.md#thm-2.2.3)、[方法 2.2.2](sec22.md#method-2.2.2)）。（✓ / △ / ×）
:::

**D3.** 「$\boldsymbol h_t$ 记住了前面所有信息」；「LSTM 的状态只有 $\boldsymbol h_t$」；「双向结构可以用在生成任务上」。
::: sol
三处都错。① $d_h$ 固定而 $t$ 任意大，$\boldsymbol h_t$ 是**按当前参数认为重要**的**有损摘要**，不是完整记忆。② LSTM 的状态是 $(\boldsymbol h_t,\boldsymbol c_t)$ 一对：`output` 只含各步 $\boldsymbol h$，`c_n` 单独返回；状态传递与断点恢复要带两个。③ 后向递推要求先看到整句，生成第 $t$ 个 token 时未来还不存在——训练期偷看未来会让离线指标虚高、部署崩坏（[定理 2.2.1](sec22.md#thm-2.2.1)、[2.3.8](sec23.md#sec-2.3.8)、[2.3.5](sec23.md#sec-2.3.5)）。（✓ / △ / ×）
:::

**D4.** 「softmax 沿查询维归一化」；「因果掩码加 0 也行」；「掩码加在 softmax 之后也一样」。
::: sol
三处都错。① 必须沿**键维**（每一行）归一化：含义是「这个查询把 100% 的注意力按比例分给各键」；按查询维归一化得到的是「每个键分完所有查询的注意力」，语义完全不同。② 加 0 等于不掩码（$\exp0=1$，未来位置拿到正常权重）；要用 $-\infty$ 或 `finfo.min`。③ 加在 softmax 之后只是把权重改小，行和不再为 1、输出尺度被破坏（[定义 2.4.5](sec24.md#def-2.4.5)、[2.4.5](sec24.md#sec-2.4.5)）。（✓ / △ / ×）
:::

**D5.** 「聚合的是 $K$，因为分数是 $\boldsymbol Q\boldsymbol K^{\mathrm T}$ 算出来的」；「注意力权重高就说明该位置重要，可以当解释用」。
::: sol
两处都错。① 分数只决定**权重**，真正被加权求和的是 $\boldsymbol V$——把 $\boldsymbol V$ 换成随机数，输出立刻变随机。② 权重不是贡献：权重与贡献之间隔着 $\boldsymbol V$；残差与后续层会稀释；softmax 权重和恒为 1，一个位置上升必然压低其他位置；多头冗余使「能剪掉的头」不足以承载唯一解释。要检验解释，至少要做消融 + 跨初始化稳定性 + 与梯度归因对照（[2.4.7](sec24.md#sec-2.4.7)）。（✓ / △ / ×）
:::

**D6.** 「多头让参数量随头数增长」；「FFN 只是装饰」；「Pre-LN 主干上有归一化，尺度不漂」。
::: sol
三处都错。① 多头参数量 $4d^2+4d$ 与 $H$ 无关（$Hd_h=d$）：$H$ 只改变「怎么切」，改变的是归纳偏置与 $d_h$。② FFN 占块内约 $2/3$ 参数，承担**位置内**的非线性变换；删掉它模型退化成多层加权平均。③ Pre-LN 的归一化在**子层内部**，主干是纯加法，$\lVert\boldsymbol X_L\rVert$ 随 $\sqrt L$ 增长，必须加收尾归一化（[定理 2.5.1](sec25.md#thm-2.5.1)、[例 2.5.1](sec25.md#ex-2.5.1)、[定理 2.5.2](sec25.md#thm-2.5.2)）。（✓ / △ / ×）
:::

**D7.** 「位置编码可有可无」；「RoPE 天然支持无限外推」；「FlashAttention 是近似算法」。
::: sol
三处都错。① 纯注意力置换等变，没有位置注入时目标函数对语序置换不变，模型学到的是词袋式预测（症状：困惑度尚可、语序任务崩坏）。② 内积只依赖相对位移是**表示**层面性质，外推时高频维度相位混叠、分布相对训练区间偏移；ALiBi 的结论也只在「短训长测」的特定设定下成立。③ FlashAttention 是**精确**注意力（在线 softmax 等价、只差浮点舍入），**FLOPs 不变**，省的是中间显存与 HBM 读写（[定理 2.6.1](sec26.md#thm-2.6.1)、[定理 2.6.3](sec26.md#thm-2.6.3)、[定理 2.6.4](sec26.md#thm-2.6.4)）。（✓ / △ / ×）
:::

**D8.** 「MoE 省显存」；「线性注意力是无损的」；「$O(T)$ 一定比 $O(T^2)$ 快」。
::: sol
三处都错。① MoE 省的是**每 token 计算量**，总参数显存反而更大（全部专家常驻）。② 线性注意力把 softmax 的锐化换成核函数相似度、把历史压进固定容量的 $d\times d$ 状态，「精确挑一个键并原样复制」变成近似操作（论文报告在关联回忆类任务上弱于 softmax 注意力）。③ 渐近阶只描述大 $T$ 行为：稠密注意力是矩阵乘、能跑满硬件，而扫描 / 逐元素算子常是访存受限的——中小 $T$ 上线性方案**更慢**是常见现象；任何「线性更快」的论断都必须附上 $T$、硬件与实现（[2.7.11](sec27.md#sec-2.7.11)、[定理 2.7.3](sec27.md#thm-2.7.3)）。（✓ / △ / ×）
:::

## 导出到 Anki / CSV

1. **建卡组**：打开 Anki → 新建卡组「DL-第 2 讲」，与「DL-全书」卡组并列（不要混进默认卡组）。
2. **逐条录入**：正面放「编号 + 题干」，背面放「答案 + 依据 + 记号」；纯文本批量导入时用 `Tab` 分隔「正面 / 背面」，一行一张卡（本页 40 张按 A1–A10 / B1–B11 / C1–C11 / D1–D8 顺序录入）。
3. **复习节点（当天 / 隔天 / 第 3 天 / 第 7 天）**：当天 → 第 1 天 → 第 3 天 → 第 7 天，四轮；每轮只重做标 **△** 与 **×** 的卡。四轮后仍未「✓」的卡，抄进[勘误与补注](errata.md)第四节的待核实条目，作为个人薄弱点单独跟踪。
4. **两类卡要特殊处理**：**公式卡（C 组）**背面附一张手写照片——手写的记忆强度高于打字；**陷阱卡（D 组）**背面必须写出「为什么错」而不只是「对 / 错」。
5. **配合使用**：本页负责**检索**（从空白纸把定义与公式叫出来）；[速查背记卡](../../memory-sheet.md)负责**压缩**、[公式与结论卡](../../review/formula-cards.md)负责**收口**、[易混对照卡](../../review/contrast-cards.md)负责**辨析**——四件不要重复劳动。
