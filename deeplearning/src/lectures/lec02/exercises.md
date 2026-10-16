# 第 2 讲习题集

> 四组难度递进：**A 概念判断 → B 推导证明 → C 编程实现 → D 开放设计**。答案默认折叠，点击展开。
> 用法：闭卷做 A 组 → 手写 B 组（涉及形状的先写形状）→ 上机跑通 C 组的验收标准 → D 组写成半页方案。
> 考点范围限[导览](overview.md)与 [2.1](sec21.md)–[2.8](sec28.md)，每题答案都能在正文定位；C 组每题附**可运行验收标准**，与正文「即时自测」不重复。

## A 组 · 概念判断（8 题）

> 判定要求：必须给**一句话理由或反例**，只写「对 / 错」不给分；涉及形状的先写形状。

**A1.** 「只要把 batch 内所有序列 pad 到训练时的最大长度，就可以直接交给 MLP 处理；这与『参数不变性』并不冲突。」（依据：[定义 2.1.1](sec21.md#def-2.1.1)、[2.1.6](sec21.md#sec-2.1.6)）
::: sol 答案
**错。** pad + MLP 的参数量随「最长长度」线性增长（第一层是 $d_h(Td_x)$），直接违反第 1 条；测试长度超过训练最大长度时形状对不上，违反第 3 条（一致性）。pad 只适合样本长度高度集中的窄场景，而且 **pad 位置必须在损失端屏蔽**，否则模型会花容量学「预测 pad」、并把损失均值拉向容易的位置。
:::

**A2.** 「把 RNN 的激活从 $\tanh$ 换成 ReLU，梯度消失就消失了。」（依据：[定理 2.2.3](sec22.md#thm-2.2.3)、[2.2.4](sec22.md#sec-2.2.4)）
::: sol 答案
**错。** 界 $\lVert J_k\rVert_2\le\lVert W_{hh}\rVert_2$ 与激活无关：换 ReLU 只去掉「激活饱和」这一项衰减，连乘的伸缩率仍由权重的谱结构（长期由谱半径）决定，$\sigma_{\max}(W_{hh})\lt1$ 时照样指数消失。有效手段是**正交 / 单位初始化 + 门控加法通道 + 残差连接**——三条都改结构，不靠换激活。
:::

**A3.** 「LSTM 的 $\boldsymbol c_t$ 与 $\boldsymbol h_t$ 是同一个向量的两个名字，框架返回的 `h_n` 就是全部状态。」（依据：[定义 2.3.1](sec23.md#def-2.3.1)、[定理 2.3.1](sec23.md#thm-2.3.1)、[2.3.8](sec23.md#sec-2.3.8)）
::: sol 答案
**错。** $\boldsymbol c_t$ 是内部的**细胞状态**（长期记忆，不对外输出），$\boldsymbol h_t=\boldsymbol o_t\odot\tanh(\boldsymbol c_t)$ 是把记忆读出来的部分。两者的雅可比也不同：$\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}=\operatorname{diag}(\boldsymbol f_t)$（不含 $W$ 的加法通道），而读出路径每次都被 $\operatorname{diag}(\boldsymbol o_t)\operatorname{diag}(1-\tanh^2)$ 打折。框架接口同样如此：`nn.LSTM` 返回 `output`（只含各步 $\boldsymbol h$）与 `(h_n, c_n)` **一对**状态——做状态传递或检查点恢复时两个都要带上（`nn.GRU` 只有一个状态）。
:::

**A4.** 「因果掩码用 `0` 作为被掩位置的值，效果与 $-\infty$ 相同。」（依据：[定义 2.4.5](sec24.md#def-2.4.5)、[2.4.5](sec24.md#sec-2.4.5)）
::: sol 答案
**错。** 加 $0$ 等于不掩码：$\exp(0)=1$，未来位置拿到正常权重，等于偷看。必须用 $-\infty$（或该 dtype 的 `finfo.min`），且**必须在 softmax 之前**加——加在之后只是把权重改小，行和不再为 1、输出尺度被破坏。还要处理「整行都被掩码」（与 padding 掩码叠加时会出现）：softmax 会给出全 `NaN`，工程上要么保证「至少看得到自己」，要么用 `nan_to_num` 兜底或掩码后重归一化。
:::

**A5.** 「注意力必须发生在两个**不同**的序列之间；自注意力只是它的特例，所以两者对位置编码的需求也一样。」（依据：[定义 2.4.4](sec24.md#def-2.4.4)、[方法 2.5.1](sec25.md#method-2.5.1)、[2.4.8](sec24.md#sec-2.4.8)）
::: sol 答案
**错。** 自注意力里 $\boldsymbol Q,\boldsymbol K,\boldsymbol V$ 来自**同一个**序列（三个不同的投影）；交叉注意力的 $\boldsymbol Q$ 来自解码器、$\boldsymbol K,\boldsymbol V$ 来自编码器输出。需求也不同：**自注意力必须配位置编码**（否则置换等变 ⇒ 分不清词序），交叉注意力通常不需要额外注入位置（目标侧位置由解码器自己的位置编码负责）。混淆这两者会同时误判位置编码与掩码的必要性。
:::

**A6.** 「Pre-LN 块里主干上有一层归一化，所以深层激活的范数不会随深度漂移。」（依据：[定义 2.5.3](sec25.md#def-2.5.3)、[定理 2.5.2](sec25.md#thm-2.5.2)）
::: sol 答案
**错。** Pre-LN 是 $\boldsymbol Y=\boldsymbol X+\operatorname{Sub}(\operatorname{LN}(\boldsymbol X))$：归一化在**子层内部**，主干是**纯加法**，于是 $\lVert\boldsymbol X_L\rVert$ 随 $\sqrt L$ 温和增长——这正是现代实现都带一层收尾归一化（final norm）才接输出头的原因。「尺度不漂」是 Post-LN 的性质，而它要为「每层之后都重新归一化」付代价：反向必须穿过这些归一化，靠近输出层的梯度尺度与深度相关，因此需要学习率 warmup。
:::

**A7.** 「有了因果掩码，模型就知道顺序了，所以位置编码可有可无。」（依据：[定理 2.4.2](sec24.md#thm-2.4.2)、[2.6.1](sec26.md#sec-2.6.1)）
::: sol 答案
**错。** 掩码只提供「**谁在谁左边**」这一位方向信息，不提供**距离与位置本身**：只用掩码的模型能表达「只看前一个 token」，无法表达「相隔 7 步」。位置编码回答的是「这个词在左边第几个位置」，而注意力本身**置换等变**，所以位置是必需品而不是调优项。缺失的典型症状：困惑度尚可，但复制 / 排序 / 指代类任务系统性崩坏。
:::

**A8.** 「MoE 用 top-k 稀疏激活，所以 8 个专家、top-2 时显存与算力都降到 $25\%$。」（依据：[定理 2.7.4](sec27.md#thm-2.7.4)、[2.7.11](sec27.md#sec-2.7.11)）
::: sol 答案
**错。** 降到约 $k/N=25\%$ 的只是**专家部分每 token 的计算量**（参数 $NP$、计算 $kP$，比值 $N/k$）。① 全部专家参数必须**常驻显存**，MoE 的显存需求反而更大；② 注意力、嵌入、归一化等**稠密**部分每 token 都要算，整体每 token FLOPs 的比例明显高于 $25\%$；③ 真实开销还要加上 all-to-all 通信与负载不均造成的设备空转。一句话：**MoE 是「显存换吞吐」，不是「省显存」**。
:::

## B 组 · 推导与证明（6 题）

> 要求：关键步骤逐条写出，不许写「略」；涉及形状的先写形状。

**B1.** 取标量直觉 $\boldsymbol h_t=\tanh(w h_{t-1}+c)$。**(a)** 写出 $\partial h_t/\partial h_{t-n}$ 并给出由 $|w|$ 控制的界；**(b)** 取 $\rho=0.9,0.98,1.1$，填 $n=10,50,100$ 的量级表，并算「衰减到 $10^{-7}$ 以下」的有效记忆跨度 $n^\star=-7/\log_{10}\rho$；**(c)** 为什么「把学习率调好」解决不了这个问题？**(d)** 训练出现 `NaN` 时最先做哪三件事？（依据：[定理 2.2.2](sec22.md#thm-2.2.2)、[定理 2.2.3](sec22.md#thm-2.2.3)、[例 2.2.1](sec22.md#ex-2.2.1)）
::: sol 提示与答案
**(a)** 单步雅可比 $J_k=w\,\phi'(z_k)$，于是
$$\frac{\partial h_t}{\partial h_{t-n}}=\prod_{k=t-n+1}^{t}w\,\phi'(z_k)=w^{n}\prod_k\phi'(z_k),\qquad \Bigl|\frac{\partial h_t}{\partial h_{t-n}}\Bigr|\le|w|^{n}\quad(\tanh:\ |\phi'|\le1).$$
矩阵情形给出 $\lVert\prod_k J_k\rVert_2\le\bigl(\max_k\lVert J_k\rVert_2\bigr)^n\le\lVert W_{hh}\rVert_2^{\,n}$，长期平均行为由谱半径决定。

**(b)** 量级表（三位有效数字）：

| $\rho$ | $n=10$ | $n=50$ | $n=100$ | $n^\star=-7/\log_{10}\rho$ |
|:--|:--|:--|:--|:--|
| $0.9$ | $0.349$ | $5.15\times10^{-3}$ | $2.66\times10^{-5}$ | $153$ 步 |
| $0.98$ | $0.817$ | $0.364$ | $0.133$ | $798$ 步 |
| $1.1$ | $2.59$ | $117$ | $1.38\times10^{4}$ | （爆炸方向）涨到 $10^{7}$ 只需约 $169$ 步 |

**(c)** 学习率只决定「参数走到哪、走多快」，**不改变连乘的结构**：跨 $n$ 步的梯度永远含 $n$ 个雅可比之积，只要 $\rho$ 偏离 $1$，$n$ 一长量级就必然失控。而 $\rho$ 是权重的性质，梯度下降不可能让一整组权重长期停在 $\rho=1$ 的临界面上——参数稍微小一点就消失、稍微大一点就爆炸，**没有安全中间地带**。

**(d)** ① 先做**梯度裁剪**，确认能否止住（爆炸方向的安全网）；② 查学习率是否过大（它会把 $\lVert W_{hh}\rVert_2$ 推到 $1$ 之外）；③ 查是否有单步损失异常大（标签错位、`log(0)`、除零）。混合精度下再加一项：检查 loss scaling（第 9 讲）。**这套流程只针对爆炸**；症状若是「loss 卡住不降、长依赖学不到」，那是消失方向，裁剪帮不上忙。
:::

**B2.** 设 $\boldsymbol q,\boldsymbol k\in\mathbb R^{d_k}$ 各分量相互独立、均值为 $0$、方差为 $1$。**(a)** 求 $\mathbb E[\boldsymbol q^{\mathrm T}\boldsymbol k]$ 与 $\operatorname{Var}$，说明为什么该除以 $\sqrt{d_k}$ 而不是 $d_k$；**(b)** 给出缩放后的方差与含义；**(c)** 设某行两个分数为 $0$ 与 $c$，写出 $\partial p_2/\partial c$ 并算 $c=10$ 时的值；**(d)** 为什么说它治的是「softmax 的工作点」而不是「数值溢出」？（依据：[定理 2.4.1](sec24.md#thm-2.4.1)、[2.4.4](sec24.md#sec-2.4.4)）
::: sol 提示与答案
**(a)** 独立性给出 $\mathbb E[q_ik_i]=\mathbb E[q_i]\mathbb E[k_i]=0$，故均值为 $0$；又 $\operatorname{Var}(q_ik_i)=1\cdot1-0=1$ 且各分量乘积独立、方差可加：
$$\operatorname{Var}\bigl(\boldsymbol q^{\mathrm T}\boldsymbol k\bigr)=\sum_{i=1}^{d_k}\operatorname{Var}(q_ik_i)=d_k,\qquad \text{标准差}=\sqrt{d_k}.$$
除以 $\sqrt{d_k}$ 恰好把标准差拉回 $1$；若除以 $d_k$，方差变成 $1/d_k$，分数被**过度压缩**、softmax 输出趋于均匀——同样是坏工作点，只是坏在另一头。

**(b)** $\operatorname{Var}(\boldsymbol q^{\mathrm T}\boldsymbol k/\sqrt{d_k})=d_k/d_k=1$，**与 $d_k$ 无关**：这就是「让分数的尺度与维度解耦」，$d_k$ 变大不再自动把 softmax 推入饱和区。

**(c)** $p_2=e^{c}/(1+e^{c})$，故 $\partial p_2/\partial c=p_2(1-p_2)$：$c$ 很小时约 $0.25$；$c=10$ 时 $p_2\approx0.99995$，导数约 $4.5\times10^{-5}$——**小了四个数量级**，反向梯度被掐断。

**(d)** 溢出是量级问题：$d_k=1024$ 时未缩放分数的标准差只有 $32$，离 float 上限很远。$\sqrt{d_k}$ 真正防的是**饱和**：softmax 输出接近 one-hot 时它对输入的导数趋近 $0$，训练停滞。这与第 1 讲 Sigmoid 饱和同源（输出饱和 ⇒ 反向梯度被掐断），区别是 softmax 的饱和由「输入差异的尺度」控制，Sigmoid 由「单个输入的绝对值」控制。
:::

**B3.** 取 $d=768$、$H=12$（$d_h=64$）、经典 FFN $d_{\text{ff}}=4d$。**(a)** 推导多头注意力参数量 $4d^2+4d$，说明为什么**与 $H$ 无关**；**(b)** 算 FFN 参数量与块内占比，说明「每层 $\approx12d^2$」的来历；**(c)** 把 $H$ 改成 $1$（$d_h=768$）参数量变不变？多头的收益与代价各是什么？**(d)** 12 层堆叠（不含嵌入与输出层）总参数量是多少？（依据：[定理 2.5.1](sec25.md#thm-2.5.1)、[例 2.5.1](sec25.md#ex-2.5.1)）
::: sol 提示与答案
**(a)** 每头三个投影各 $d\times d_h$，单头 $3d\,d_h$；$H$ 头合计 $H\cdot 3d\,d_h=3d\,(Hd_h)=3d^2$（用 $Hd_h=d$），加输出投影 $W^O$ 的 $d^2$ 与偏置 $4d$，得 $4d^2+4d$。**$H$ 只改变「怎么切这块参数」**：把 $d$ 份维度分成更多更小的头，总量不变——所以「多头更好」必须交代控制了什么（同参数量？同计算量？同训练步数？）。

**(b)** $W_1(d\to4d)$ 与 $W_2(4d\to d)$ 合起来 $8d^2$，加偏置 $5d$；块内总计 $\approx12d^2$，FFN 占 $8/12=2/3$、注意力占 $1/3$。$d=768$ 的具体数字：注意力 $4\times768^2=2{,}359{,}296$（$33.3\%$）、FFN $8\times768^2=4{,}718{,}592$（$66.6\%$）、两个 LayerNorm 共 $3{,}072$（$0.04\%$），合计 $\approx7{,}087{,}872$。

**(c)** **完全不变**：还是 $4d^2+4d$。变的是**归纳偏置**——多头能并行给出 $H$ 组互不相同的权重模式（局部语法、指代、复制各占一个头），单头只能给一组、多种依赖被强制平均。代价是 $d_h=d/H$ 变小（每个头的内积空间维度下降、相似度估计变粗），以及 reshape / 转置的访存开销上升，所以 $H$ 是经验超参，不存在「头越多越好」。

**(d)** 每层 $\approx12d^2=7{,}077{,}888$，12 层 $\approx8.51\times10^{7}$，约 **85M** 参数（$768^2=589{,}824$ 可用来快速心算）。若加上 $V=32000$ 的嵌入与输出层（权重绑定只算一次）：$+2.458\times10^{7}\approx1.10\times10^{8}$，约 **110M**。
:::

**B4.** 把键（与值）沿序列维分块，逐块维护运行最大值 $m_j$、指数和 $\ell_j$、未归一化输出 $\boldsymbol O_j$。**(a)** 写出三条递推式；**(b)** 用归纳法证明 $\boldsymbol O_J/\ell_J$ 与整块 softmax 结果相同；**(c)** 重缩放因子 $e^{m_{j-1}-m_j}$ 从哪来、为什么必须有；**(d)** 由此说明 FlashAttention 为什么既不是近似算法、也没有减少 FLOPs。（依据：[定理 2.6.4](sec26.md#thm-2.6.4)）
::: sol 提示与答案
**(a)**
$$m_j=\max\bigl(m_{j-1},\max_i s_{ij}\bigr),\quad \ell_j=e^{m_{j-1}-m_j}\ell_{j-1}+\sum_i e^{s_{ij}-m_j},\quad \boldsymbol O_j=e^{m_{j-1}-m_j}\boldsymbol O_{j-1}+\sum_i e^{s_{ij}-m_j}\boldsymbol v_i .$$

**(b)** 取稳定形式 $\operatorname{softmax}(s)_i=e^{s_i-m}/\sum_{i'}e^{s_{i'}-m}$（分子分母同乘 $e^{-m}$，值不变、指数不溢出）。归纳假设：处理完前 $j-1$ 块后 $\ell_{j-1}=\sum_{i\lt j}e^{s_i-m_{j-1}}$、$\boldsymbol O_{j-1}=\sum_{i\lt j}e^{s_i-m_{j-1}}\boldsymbol v_i$——**以 $m_{j-1}$ 为基准**。第 $j$ 块带来 $m_j\ge m_{j-1}$，把旧累加换成以 $m_j$ 为基准只需每项乘 $e^{m_{j-1}-m_j}$：
$$\ell_j=e^{m_{j-1}-m_j}\sum_{i\lt j}e^{s_i-m_{j-1}}+\sum_{i\in j}e^{s_i-m_j}=\sum_{i\le j}e^{s_i-m_j},$$
$\boldsymbol O_j$ 同理；归纳到最后一个键块，$\boldsymbol O_J/\ell_J$ 正是 softmax 加权和。

**(c)** 它来自**基准的更换**：基准从 $m_{j-1}$ 变成 $m_j$ 后，旧累加里的每一项都要重新乘同一个因子才能与新块相加。没有它，不同块的指数项落在不同基准上，相加没有意义——结果会随分块方式改变，那就不是等价实现而是近似了。

**(d)** 数学上完全恒等，差别只来自不同求和顺序在浮点下的舍入（实现上要用 FP32 累积统计量，工程惯例），所以是**精确**注意力。分块改变的是**运算顺序与中间量的存放位置**，乘加次数 $4BHT^2d_h$ 一步没少：省掉的是 $T\times T$ 中间矩阵在 HBM 上的读写与存放（中间显存从 $O(T^2)$ 降到 $O(T)$）。
:::

**B5.** 线性时不变 SSM：$\boldsymbol h_t=\bar A\boldsymbol h_{t-1}+\bar B\boldsymbol x_t$、$\boldsymbol y_t=C\boldsymbol h_t$，$\boldsymbol h_0=\boldsymbol 0$。**(a)** 展开 $\boldsymbol h_t$ 并证明 $\boldsymbol y=\bar K*\boldsymbol x$，写出核 $\bar K_t$；**(b)** 「核只依赖时差」如何同时带来训练并行与 $O(1)$ 推理状态？**(c)** Mamba 让 $\Delta_t,B_t,C_t$ 依赖输入后，卷积形式为什么失效？它用什么换回并行度？**(d)** SSD 对偶把 SSM 写成什么形式？限定条件至少写两条。（依据：[定理 2.7.1](sec27.md#thm-2.7.1)、[定理 2.7.2](sec27.md#thm-2.7.2)、[方法 2.7.1](sec27.md#method-2.7.1)）
::: sol 提示与答案
**(a)** 逐次代入：$\boldsymbol h_1=\bar B\boldsymbol x_1$，$\boldsymbol h_2=\bar A\bar B\boldsymbol x_1+\bar B\boldsymbol x_2$，归纳得
$$\boldsymbol h_t=\sum_{j=1}^{t}\bar A^{\,t-j}\bar B\boldsymbol x_j\ \Longrightarrow\ \boldsymbol y_t=\sum_{j\le t}\underbrace{\bigl(C\bar A^{\,t-j}\bar B\bigr)}_{\bar K_{t-j}}\boldsymbol x_j,$$
即 $\boldsymbol y=\bar K*\boldsymbol x$，核 $\bar K_t=C\bar A^{t}\bar B$ 只依赖**时差**。形状：$\bar A\in\mathbb R^{N\times N}$、$\bar B\in\mathbb R^{N\times d}$、$C\in\mathbb R^{d\times N}$，故 $\bar K_t\in\mathbb R^{d\times d}$。

**(b)** **训练**：核固定 ⇒ 全部 $T$ 个输出可用一次因果卷积算完（按核长 $L$ 截断是 $O(TL)$，FFT 是 $O(T\log T)$），不必沿时间串行；**推理**：换成递推逐 token 推进，只保留固定大小的状态（$O(N)$；对角结构下与通道数同阶），**与 $T$ 无关**，也不保留历史键值。两种读法做同一件事，根因是「线性 + 时不变」使递推可以展开成卷积。

**(c)** $\bar A_t=\exp(\Delta_tA)$、$\bar B_t$、$C_t$ 都带时间下标，**不存在固定的核** $\bar K_{t-j}$，卷积（与 FFT 并行）不再成立。换回并行度的办法是**并行扫描**：递推是线性算子、满足结合律，于是把序列分块，**块内串行、块间做前缀扫描**（并行深度从 $O(T)$ 降到 $O(T/C)$），并把中间状态尽量留在片上内存、避免反复往返显存。

**(d)** 在「状态转移被限制为标量乘恒等」的结构约束下（$\bar A_t=a_tI$），输出可写成
$$\boldsymbol Y=\bigl(M\odot \boldsymbol Q\boldsymbol K^{\mathsf T}\bigr)\boldsymbol V,\qquad M_{ij}=\prod_{k=j+1}^{i}a_k\ (i\ge j),$$
$M$ 是由累积乘积构成的**半可分下三角矩阵**。限定条件：① 只对满足该结构约束的 SSM 成立，一般 $A$（含低秩修正的时不变 SSM）不自动等于注意力；② 这是**算子层面**的等价，不等于表达能力等价（掩码族宽度不同：硬因果掩码可以是任意精细的逐元素模式，半可分掩码的自由度小得多）；③ 它不解决训练稳定性与数值精度问题。
:::

**B6.** 设 $\phi$ 为逐元素非负核映射，$\boldsymbol Q\in\mathbb R^{T\times d}$、$\boldsymbol K,\boldsymbol V\in\mathbb R^{T\times d}$（暂略头维）。**(a)** 分别数出 $\bigl(\phi(\boldsymbol Q)\phi(\boldsymbol K)^{\mathsf T}\bigr)\boldsymbol V$ 与 $\phi(\boldsymbol Q)\bigl(\phi(\boldsymbol K)^{\mathsf T}\boldsymbol V\bigr)$ 的乘加次数与中间量形状；**(b)** 求比值并代入 $T=8192$、$d=2048$；**(c)** 写出因果情形的状态递推与每步成本，说明推理状态为什么与 $T$ 无关；**(d)** 省下来的复杂度换走了什么能力？（依据：[定义 2.7.3](sec27.md#def-2.7.3)、[定理 2.7.3](sec27.md#thm-2.7.3)）
::: sol 提示与答案
**(a)** 先打分后聚合：中间量 $T\times T$，乘加 $T\cdot T\cdot d+T\cdot T\cdot d=2T^{2}d$；先聚合后查询：中间量 $d\times d$，乘加 $2Td^{2}$。两者是**同一个表达式的两种结合顺序**（矩阵乘法结合律），差别只在中间量形状。

**(b)** 比值 $T^{2}d/(Td^{2})=T/d=8192/2048=4$——序列越长于模型维度，线性顺序越省；反之短序列（$T$ 不远大于 $d$）里每步 $d\times d$ 的状态读出可能比直接算稠密注意力更贵。

**(c)** $S_t=S_{t-1}+\phi(\boldsymbol k_t)\boldsymbol v_t^{\mathsf T}$（外积累积）、$\boldsymbol o_t=\phi(\boldsymbol q_t)^{\mathsf T}S_t$、$z_t=z_{t-1}+\phi(\boldsymbol k_t)$（保证分母归一化，$\boldsymbol o_t\leftarrow\boldsymbol o_t/z_t$）。每步只做一次 $d\times d$ 外积更新与一次 $d\times d$ 读出，状态只含 $S_t$（$d^2$）与 $z_t$（$d$），**与 $T$ 无关**。

**(d)** 换走的是**锐化与精确回忆**：softmax 在分数差异大时饱和成近似 one-hot，模型可以「找出最匹配的那个键、把它的 $\boldsymbol V$ 原样取出」；核化后权重是连续函数，$d\times d$ 的固定容量状态还把历史压成有损摘要——「精确挑一个」与「原值复制」都变成近似操作，在关联回忆 / 复制类任务上明显弱于 softmax 注意力（论文报告的口径；门控线性注意力缩小了差距，但换来的是更好的遗忘控制，不是恢复精确检索）。
:::

## C 组 · 编程实现（6 题）

> 依赖只要 `torch`（≥ 2.0 的 `F.scaled_dot_product_attention` 与 `torch.linalg.qr`）。每题先读**验收标准**，再上机跑通。

**C1.** 实现缩放点积注意力（支持因果掩码与 key padding 掩码），并与官方实现对齐。
- **验收标准**：① 输出形状 $B\times T_q\times d_v$；② `torch.allclose(out, F.scaled_dot_product_attention(Q,K,V,is_causal=True), atol=1e-5)`；③ 每行权重和与 1 的偏差小于 $10^{-6}$；④ 上三角被**精确**置零；⑤ 整行都被 padding 掉时不产生 `NaN`（`torch.isfinite(out).all()`）；⑥ 把掩码移到 softmax **之后**，行和与参考输出的偏差大于 $10^{-2}$（证明「位置」是本质的）。
::: sol 参考实现
```python
import torch, torch.nn.functional as F
def attn(Q, K, V, key_pad=None, causal=False):
    """Q:(B,Tq,dk) K:(B,Tk,dk) V:(B,Tk,dv) key_pad:(B,Tk) bool，True = pad"""
    dk = Q.size(-1)
    S = Q @ K.transpose(-2, -1) / dk ** 0.5            # (B,Tq,Tk) 分数矩阵
    if causal:                                          # 因果掩码：位置 i 只能看 j <= i
        Tq, Tk = S.shape[-2], S.shape[-1]
        S = S.masked_fill(~torch.ones(Tq, Tk, dtype=torch.bool, device=S.device).tril(),
                          float("-inf"))                # 必须在 softmax 之前
    if key_pad is not None:                             # pad 键同样屏蔽
        S = S.masked_fill(key_pad[:, None, :], float("-inf"))
    P = torch.nan_to_num(S.softmax(-1))                 # 沿键维归一；整行全 -inf 时兜底
    return P @ V, P

torch.manual_seed(0)
B, Tq, Tk, dk, dv = 2, 5, 5, 16, 16
Q, K, V = torch.randn(B, Tq, dk), torch.randn(B, Tk, dk), torch.randn(B, Tk, dv)
out, P = attn(Q, K, V, causal=True)
ref = F.scaled_dot_product_attention(Q, K, V, is_causal=True)
assert out.shape == (B, Tq, dv)                                   # ①
assert torch.allclose(out, ref, atol=1e-5)                        # ②
assert torch.allclose(P.sum(-1), torch.ones(B, Tq), atol=1e-6)    # ③
assert torch.allclose(P.triu(1), torch.zeros_like(P.triu(1)))     # ④

key_pad = torch.zeros(B, Tk, dtype=torch.bool); key_pad[0, :] = True
assert torch.isfinite(attn(Q, K, V, key_pad=key_pad)[0]).all()    # ⑤

S_wrong = Q @ K.transpose(-2, -1) / dk ** 0.5
P_wrong = S_wrong.softmax(-1).masked_fill(~torch.ones(Tq, Tk).tril().bool(), 0.0)
assert (P_wrong.sum(-1) - 1).abs().max() > 1e-2                   # ⑥ 行和被破坏
assert not torch.allclose(P_wrong @ V, ref, atol=1e-2)
```
:::

**C2.** 验证因果掩码与置换等变：上三角断言、行和断言，以及「打乱输入行 ⇒ 输出被同样打乱」。
- **验收标准**：① 不带掩码时 `out_perm ≈ out_plain[perm]`（`atol=1e-5`，这就是 [定理 2.4.2](sec24.md#thm-2.4.2)）；② 因果掩码下 `P.triu(1)` 全零、每行和为 1（偏差 $\lt10^{-6}$）；③ 加掩码后置换等变**被破坏**：`not allclose(out_c_perm, out_c[perm], atol=1e-3)`——掩码是有意破坏等变的结构；④ 把掩码改成 softmax 之后再加，`P.triu(1)` 仍非零（说明顺序不可交换）。
::: sol 参考实现
```python
import torch

def attention(X, Wq, Wk, Wv, causal):
    Q, K, V = X @ Wq, X @ Wk, X @ Wv
    S = Q @ K.transpose(-2, -1) / Q.size(-1) ** 0.5
    if causal:
        T = S.size(-1)
        S = S.masked_fill(~torch.ones(T, T, dtype=torch.bool).tril(), float("-inf"))
    P = S.softmax(-1)
    return P @ V, P

torch.manual_seed(0)
T, d = 6, 8
X = torch.randn(T, d)
Wq, Wk, Wv = (torch.randn(d, d) for _ in range(3))

P_c = attention(X, Wq, Wk, Wv, causal=True)[1]
assert torch.allclose(P_c.triu(1), torch.zeros_like(P_c.triu(1)))       # ② 上三角精确为零
assert torch.allclose(P_c.sum(-1), torch.ones(T), atol=1e-6)

perm = torch.randperm(T)
out_plain, _ = attention(X, Wq, Wk, Wv, causal=False)
out_perm, _ = attention(X[perm], Wq, Wk, Wv, causal=False)
assert torch.allclose(out_perm, out_plain[perm], atol=1e-5)             # ① 置换等变

out_c, _ = attention(X, Wq, Wk, Wv, causal=True)
out_c_perm, _ = attention(X[perm], Wq, Wk, Wv, causal=True)
assert not torch.allclose(out_c_perm, out_c[perm], atol=1e-3)           # ③ 掩码破坏等变

S = (X @ Wq) @ (X @ Wk).T / d ** 0.5
P_after = S.softmax(-1).masked_fill(~torch.ones(T, T).tril().bool(), 0.0)
assert not torch.allclose(P_after.triu(1), torch.zeros_like(P_after.triu(1)))  # ④
```
:::

**C3.** 实现带 KV cache 的多头自注意力，验证「增量解码」与「整段前向」逐位置一致。
- **验收标准**：① `max|full − inc| < 1e-5`；② 缓存形状恒为 $B\times H\times T\times d_h$（每步只增长一个时间位）；③ 反面对照：整段前向**去掉**因果掩码后，它与增量解码不再一致（偏差 $\gt10^{-2}$）——掩码不是可选项；④ 单步增量只输入一个位置时不需要再套掩码。
::: sol 参考实现
```python
import torch, torch.nn as nn, math
class MHA(nn.Module):
    def __init__(self, d, H):
        super().__init__()
        self.H, self.d_h = H, d // H
        self.Wq, self.Wk, self.Wv, self.Wo = (nn.Linear(d, d, bias=False) for _ in range(4))
    def _split(self, x):                                   # (B,T,d) -> (B,H,T,d_h)
        B, T, _ = x.shape
        return x.view(B, T, self.H, self.d_h).transpose(1, 2)
    def forward(self, x, cache=None, causal=True):
        B, T, _ = x.shape
        q, k, v = self._split(self.Wq(x)), self._split(self.Wk(x)), self._split(self.Wv(x))
        if cache is not None:                              # 增量：历史 K/V 拼到当前步前面
            k, v = torch.cat([cache[0], k], 2), torch.cat([cache[1], v], 2)
        S = q @ k.transpose(-2, -1) / math.sqrt(self.d_h)
        if causal and cache is None:                       # 只有整段前向才需要掩码
            Tq, Tk = S.shape[-2], S.shape[-1]
            S = S.masked_fill(~torch.ones(Tq, Tk, dtype=torch.bool).tril(), float("-inf"))
        out = (S.softmax(-1) @ v).transpose(1, 2).reshape(B, T, -1)
        return self.Wo(out), (k, v)

torch.manual_seed(0)
B, T, d, H = 2, 12, 64, 8
mha = MHA(d, H).eval()
x = torch.randn(B, T, d)
full, _ = mha(x)                                           # 整段前向（训练路径）
cache, outs = None, []
for t in range(T):                                         # 逐 token 增量解码（推理路径）
    o, cache = mha(x[:, t:t + 1], cache=cache)
    outs.append(o)
inc = torch.cat(outs, 1)
assert full.shape == inc.shape == (B, T, d)
assert (full - inc).abs().max().item() < 1e-5                          # ①
assert cache[0].shape == cache[1].shape == (B, H, T, mha.d_h)          # ②
assert (mha(x, causal=False)[0] - inc).abs().max().item() > 1e-2       # ③ 漏掩码 ⇒ 两条路径不一致
```
:::

**C4.** 写一个 KV cache 显存估算脚本，并复算正文三档数字。
- **验收标准**：① 复算 $L=32,d=4096,H=32,d_h=128,B=1,T=8192$、FP16 的 MHA / GQA（$n_{kv}=8$）/ MQA（$n_{kv}=1$）分别为 $4.0$ / $1.0$ / $0.125$ GiB（相对误差 $\lt10^{-6}$）；② $T$ 与 $B$ 各自翻倍时字节数恰好翻倍（线性性断言）；③ 与权重显存的交叉点：6.4B 参数 FP16（$1.28\times10^{10}$ 字节）对应 $T^\star\approx2.44\times10^{4}$ 个 token（误差 $\lt1\%$）；④ 打印 $T=8192,32768,131072$ 三行的 MHA / GQA 对照表。
::: sol 参考实现
```python
GiB = 1024 ** 3

def kv_bytes(L, B, T, n_kv, d_h, elem_bytes=2):
    """KV cache 字节数 = 2(K 与 V) × L × B × T × n_kv × d_h × 元素字节"""
    return 2 * L * B * T * n_kv * d_h * elem_bytes

cfg = dict(L=32, B=1, T=8192, d_h=128)
mha, gqa, mqa = (kv_bytes(n_kv=n, **cfg) / GiB for n in (32, 8, 1))
assert abs(mha - 4.0) < 1e-6 and abs(gqa - 1.0) < 1e-6 and abs(mqa - 0.125) < 1e-6    # ①

assert kv_bytes(32, 1, 16384, 32, 128) == 2 * kv_bytes(32, 1, 8192, 32, 128)          # ②
assert kv_bytes(32, 2, 8192, 32, 128) == 2 * kv_bytes(32, 1, 8192, 32, 128)

T_star = 1.28e10 / (2 * 32 * 32 * 128 * 2)          # 与 6.4B FP16 权重（12.8 GB）相当
assert abs(T_star - 24414) / 24414 < 0.01           # ③ ≈ 2.44 万 token

for T in (8192, 32768, 131072):                     # ④
    print(f"T={T:7d}  MHA {kv_bytes(32,1,T,32,128)/GiB:7.2f} GiB   GQA {kv_bytes(32,1,T,8,128)/GiB:6.2f} GiB")
```
读法：GQA 只是把 $n_{kv}$ 从 $32$ 降到 $8$，缓存就按 $4$ 倍下降；而 $T$ 每乘 $4$，缓存也乘 $4$——**长上下文的显存是「线性但常数很大」的那一笔**（[方法 2.5.3](sec25.md#method-2.5.3)）。
:::

**C5.** 手写 RNN 单元，做梯度检查，并用线性单元把「连乘的伸缩率」观察出来。
- **验收标准**：① float64 + 中心差分下，$\partial\mathcal L/\partial W_{hh}$ 的相对误差 $\lt10^{-6}$；② 用**线性**单元（$\phi$ 为恒等）与缩放正交矩阵（谱范数 $s$）：从第 8 步到第 48 步，$\lVert\partial\mathcal L/\partial\boldsymbol h_8\rVert$ 之比在 $s=0.7$ 时 $\lt10^{-3}$（理论 $0.7^{40}\approx6.5\times10^{-7}$）、在 $s=1.0$ 时 $\gt0.5$（理论 $\approx1$）；③ 梯度裁剪后全局范数恰为阈值 $1.0$（误差 $\lt10^{-9}$），且返回值等于裁剪前实测的范数。
::: sol 参考实现
```python
import torch

torch.manual_seed(0)
d_x, d_h, B, T, dt = 6, 8, 3, 48, torch.float64

class RNNCell(torch.nn.Module):
    def __init__(self, s):
        super().__init__()
        Q, _ = torch.linalg.qr(torch.randn(d_h, d_h, dtype=dt))     # 正交：谱范数恰为 1
        self.W_hh = torch.nn.Parameter(Q * s)
        self.W_xh = torch.nn.Parameter(torch.randn(d_h, d_x, dtype=dt) * 0.1)
    def forward(self, xs):
        h, hs = torch.zeros(xs.shape[0], d_h, dtype=dt), []
        for t in range(xs.shape[1]):                                # 时间维只能串行
            h = torch.tanh(self.W_hh @ h.T + self.W_xh @ xs[:, t].T).T
            hs.append(h)
        return torch.stack(hs, 1)

cell, x, w = RNNCell(s=0.9), torch.randn(B, T, d_x, dtype=dt), torch.randn(d_h, 1, dtype=dt)
loss = (cell(x)[:, -1] @ w).sum()                                   # 只读出最后一个位置
g_auto = torch.autograd.grad(loss, cell.W_hh)[0]
i, j, eps = 0, 1, 1e-6
with torch.no_grad():
    cell.W_hh[i, j] += eps; lp = (cell(x)[:, -1] @ w).sum().item()
    cell.W_hh[i, j] -= 2 * eps; lm = (cell(x)[:, -1] @ w).sum().item()
    cell.W_hh[i, j] += eps
g_num = (lp - lm) / (2 * eps)
assert abs(g_num - g_auto[i, j].item()) / (abs(g_num) + abs(g_auto[i, j].item()) + 1e-12) < 1e-6  # ①
def tail_grad_norm(s, T, start=8):                                  # φ 为恒等：纯线性递推
    W = torch.linalg.qr(torch.randn(d_h, d_h, dtype=dt))[0] * s
    Wx, xs = torch.randn(d_h, d_x, dtype=dt) * 0.1, torch.randn(B, T, d_x, dtype=dt)
    h = torch.zeros(B, d_h, dtype=dt)
    for t in range(start):
        with torch.no_grad():
            h = (W @ h.T + Wx @ xs[:, t].T).T
    h0 = h.detach().requires_grad_(True); h = h0
    for t in range(start, T):
        h = (W @ h.T + Wx @ xs[:, t].T).T
    return torch.autograd.grad(h.sum(), h0)[0].norm().item()
base = tail_grad_norm(0.7, T=8)                                     # 退化：无额外步数
r07, r10 = tail_grad_norm(0.7, T=48) / base, tail_grad_norm(1.0, T=48) / base
assert r07 < 1e-3 and r10 > 0.5, (r07, r10)                         # ②
p = torch.nn.Parameter(torch.randn(4, 4, dtype=dt))
p.grad = torch.randn(4, 4, dtype=dt) * 10
before = torch.nn.utils.clip_grad_norm_([p], max_norm=1.0)
assert before > 1.0 and abs(p.grad.norm().item() - 1.0) < 1e-9      # ③
```
把 ② 里的 $s=0.7$ 换成 $1.05$，同一个实验会看到比值远大于 $1$——消失与爆炸是同一件事的两侧。
:::

**C6.** 实现温度 / top-k / top-p 截断采样，并用 [例 2.8.1](sec28.md#ex-2.8.1) 的手算值验收。
- **验收标准**：① 用 $\boldsymbol z=(2.0,1.0,0.5,-1.0)$ 复算 $\tau=1$ 的分布为 $(0.609,0.224,0.136,0.030)$（`atol=1e-3`）；② $\tau=0.5$ 与 $\tau=2$ 的分布同样对齐手算；③ $\tau=1$、top-$p=0.9$ 的核是 $\{1,2,3\}$、重新归一化后为 $(0.629,0.231,0.140)$、丢弃质量 $0.030$；④ 三个温度下 argmax 恒为候选 1（softmax 保序）；⑤ top-$p=0.8$ 时 $\tau=1$ 的核大小是 2、$\tau=2$ 是 3（核的自适应）；⑥ 20000 次采样的经验频率与理论概率在最大两个候选上偏差 $\lt0.02$。
::: sol 参考实现
```python
import torch

def truncate(logits, tau=1.0, top_p=None, top_k=None):
    p = (logits / tau).softmax(-1)                    # 温度 = 把 logits 除以 τ
    if top_p is not None:                             # 核采样：按累积质量截断
        sp, si = p.sort(-1, descending=True)
        keep = (sp.cumsum(-1) - sp) <= top_p          # 保留「前缀质量未超阈值」的候选（含跨过阈值者）
        p = torch.zeros_like(p).scatter(-1, si, torch.where(keep, sp, torch.zeros_like(sp)))
        p = p / p.sum(-1, keepdim=True)               # 重新归一化
    if top_k is not None:                             # top-k：按候选个数截断
        kth = p.topk(top_k, -1).values[:, -1:]
        p = torch.where(p >= kth, p, torch.zeros_like(p))
        p = p / p.sum(-1, keepdim=True)
    return p

z = torch.tensor([[2.0, 1.0, 0.5, -1.0]])
assert torch.allclose(truncate(z, tau=1.0)[0], torch.tensor([0.609, 0.224, 0.136, 0.030]), atol=1e-3)  # ①
assert torch.allclose(truncate(z, tau=0.5)[0], torch.tensor([0.842, 0.114, 0.042, 0.002]), atol=1e-3)  # ②
assert torch.allclose(truncate(z, tau=2.0)[0], torch.tensor([0.434, 0.263, 0.205, 0.097]), atol=1e-3)

pk = truncate(z, tau=1.0, top_p=0.9)[0]
assert pk[3].item() == 0 and pk[:3].gt(0).all()                                       # ③ 核 = {1,2,3}
assert torch.allclose(pk[:3], torch.tensor([0.629, 0.231, 0.140]), atol=2e-3)
assert abs((1 - truncate(z, tau=1.0)[0][:3].sum()) - 0.030) < 2e-3

assert all(truncate(z, tau=t)[0].argmax().item() == 0 for t in (0.5, 1.0, 2.0))       # ④
assert int((truncate(z, tau=1.0, top_p=0.8)[0] > 0).sum()) == 2                       # ⑤ 分布尖 ⇒ 核小
assert int((truncate(z, tau=2.0, top_p=0.8)[0] > 0).sum()) == 3                       #    分布平 ⇒ 核大

g = torch.Generator().manual_seed(0)
emp = torch.bincount(torch.multinomial(truncate(z)[0], 20000, generator=g), minlength=4) / 20000
assert (emp[:2] - truncate(z)[0][:2]).abs().max() < 0.02                              # ⑥
```
:::

## D 组 · 开放设计（4 题）

> 每题四项缺一不可：**方案 + 理由 + 失败判据 + 验证计划**；判据必须可测量。

**D1.** 一个代码仓库级问答系统要从 $8$k 上下文扩到 $256$k，任务**依赖精确定位远处的函数定义**；单机 8 卡（每卡 80 GB），首 token 延迟 $\lt2$ s、每 token $\lt50$ ms。给出扩容方案。
::: sol 参考方案与评分要点
- **方案（至少三项，各治一笔账）**：① **不物化中间矩阵**：启用 FlashAttention / SDPA，把单层分数矩阵的 $O(T^2)$ 显存消掉（[定理 2.6.4](sec26.md#thm-2.6.4)）；② **KV 头压缩 + KV 量化**：GQA 把 $n_{kv}$ 从 $H$ 降到 $H/g$、缓存按 $g$ 倍下降，再叠 INT8 量化约 $2$ 倍——这两项**不改变可见范围**，对精确检索相对安全（[方法 2.6.2](sec26.md#method-2.6.2)）；③ **序列并行**：Ring Attention / Ulysses 按序列维切到多卡（[2.6.9](sec26.md#sec-2.6.9)），只摊薄每卡显存、不减算术量；④ **位置扩窗**：RoPE 位置插值 / 频率缩放后再做少量继续训练（细节**需核实**）。
- **理由**：三笔账的增长阶不同——分数矩阵与 FLOPs 是 $O(T^2)$、KV cache 是 $O(T)$ 但常数大（[方法 2.6.1](sec26.md#method-2.6.1)）。先用 ① 治显存，再用 ②③ 治缓存与单卡容量，最后处理位置外推。**不要**把滑窗 / KV 淘汰当主方案：任务要求精确回忆远处内容，这两类会**永久丢弃**信息。
- **失败判据**：① 远端位置的检索准确率比近端低 $10$ 个百分点以上（needle-in-haystack 曲线出现断崖）；② 位置插值后短上下文（$4$k）回归退化 $\gt1\%$；③ 延迟超出预算且随上下文增长持续恶化；④ 显存 OOM 或吞吐塌陷到基线一半以下。
- **验证计划**：按 $4$k / $16$k / $64$k / $256$k 分层测检索准确率并画曲线；固定种子与生成配置；与不扩容的 MHA 基线做单变量对照（每次只改一项）；逐项报告显存 / 延迟收益与质量代价。
- **评分要点**：方案具体且对应账目（4 分）+ 失败判据可测量（3 分）+ 验证计划含分层测试（3 分）。
:::

**D2.** 现有权重只训练过 $8$k 上下文（位置编码为**学习式**），要在不改架构、只做少量继续训练的前提下支持 $32$k。给出选择与迁移步骤。
::: sol 参考方案与评分要点
- **方案**：① 首选**分数加性**方案（ALiBi 或 T5 式分桶）——只改 logits、不加参数表、不动 $\boldsymbol q,\boldsymbol k$ 的计算，因此能挂在任何注意力实现上（[定义 2.6.4](sec26.md#def-2.6.4)、[定义 2.6.5](sec26.md#def-2.6.5)）；ALiBi 的线性惩罚在训练区间内几乎没被激活，**短训长测**行为可预期，但依赖人为先验形状。② 若必须用 **RoPE**：不能直接替换——原位置信息在**嵌入**里，RoPE 作用在 $\boldsymbol q,\boldsymbol k$ 上，需先剥离嵌入中的位置成分（或重训），再叠位置插值 / 频率缩放（**需核实**）做少量继续训练。③ 直接扩**学习式**位置表是最差选项：表外无参数，只能截断 / 插值 / 外推，而插值会改变训练时学到的「相邻步距离」的尺度。
- **理由**：三类方案的代价不同（[2.6.5](sec26.md#sec-2.6.5) 的对照表）——嵌入加性占嵌入预算且有硬上限；QK 乘性表示更干净但对实现细节敏感、扩窗需后处理；分数加性最容易论证与调试，代价是人为先验与远处分辨率牺牲。
- **失败判据**：① $32$k 上的验证困惑度相对 $8$k 基线恶化超过设定阈值；② $8$k–$32$k 区间的检索准确率断崖；③ 短段（$\le8$k）回归退化 $\gt1\%$；④ 插值后相邻位置的内积分布相对训练区间系统性偏移（可直接测量）。
- **验证计划**：长度扫描（$2$k → $32$k 每隔一档）+ 同长度三方对照 + 固定种子重训两次确认结论可重现。
- **评分要点**：方案与理由（4 分，须指出「注入位置不同导致可替换性不同」）+ 失败判据（3 分）+ 验证计划（3 分）。
:::

**D3.** 同一条产品线有两个需求：**(i)** 可穿戴设备的逐拍心电异常检测（流式、连续数小时、端侧显存极小、标注少）；**(ii)** 服务器端的病历长文档检索（离线批处理、需要精确定位远处段落）。分别选型并说明取舍。
::: sol 参考方案与评分要点
- **(i) 流式逐拍检测 → 递推类 / 状态空间模型**：每步只更新固定大小的状态（与 $T$ 无关），不保留历史键值，推理内存 $O(1)$、每 token 成本不随运行时长增长（[2.7.9](sec27.md#sec-2.7.9) 的对照表）；小数据 + 强归纳偏置更抗过拟合（[2.1.5](sec21.md#sec-2.1.5) 的选型清单）。需要「按内容记忆」时用选择性 SSM（[定义 2.7.2](sec27.md#def-2.7.2)）；本任务不需要长程精确回忆，纯 SSM 的短板在这里不构成问题。
- **(ii) 长文档检索 → 注意力（或「少量全局注意力 + 多数线性层」的混合）**：任务需要**精确回忆远处的具体内容**，而滑窗与线性注意力都把「精确挑一个键、原样取出 $\boldsymbol V$」变成近似操作（[定理 2.7.3](sec27.md#thm-2.7.3)）；离线批处理没有流式约束，可以用序列并行 + FlashAttention 把显存与算力摊开（[2.6.9](sec26.md#sec-2.6.9)）。若走混合架构，必须保留少量全局注意力层做检索（[2.7.6](sec27.md#sec-2.7.6)）。
- **共同理由**：两条路线的差别可以归结为「掩码要多宽」——精确、稀疏、任意模式的检索需要硬掩码（全注意力），只需平滑衰减的聚合用半可分掩码更便宜（[定理 2.7.2](sec27.md#thm-2.7.2) 后的讨论）。
- **失败判据**：① 流式任务的**首样本延迟随运行时长增长**（说明状态没保持常数，退化成隐式的缓存增长）；② 状态切换 / 批边界处漏检率上升；③ 检索任务的 recall@k 低于全注意力基线且差距集中在远端位置；④ 混合架构里把全局注意力层全部替换后检索指标显著下降。
- **验证计划**：流式侧做「连续运行 N 小时」的长跑压测 + 分段召回率；检索侧做分层位置（近 / 中 / 远）的 recall 曲线；两侧固定种子并报告与基线的单变量对照。
- **评分要点**：两侧选型各自正确（4 分）+ 理由指到「状态容量 / 精确回忆 / 复杂度」三条张力（3 分）+ 判据可测量（3 分）。
:::

**D4.** 多语言客服模型：8 个语种、token 分布极不均（两种语言占 $70\%$）；总参数预算 $8\times$ 稠密基线、每 token 计算预算 $1\times$。设计 MoE 的路由与训练策略。
::: sol 参考方案与评分要点
- **方案**：① 把 **FFN** 换成 $N$ 个专家（FFN 占块内 $2/3$ 参数，才有参数可换，[2.5.2](sec25.md#sec-2.5.2)）；② **细粒度切分 + 共享专家**：把专家切得更小更多让组合更灵活，并保留若干对每个 token 都激活的共享专家承载通用知识（论文报告优于更粗的切分）；③ **路由与均衡**：$k=2$ 起步，配辅助损失 $L_{\text{aux}}=\alpha N\sum_i f_iP_i$（或按使用率动态调整的专家偏置），$\alpha$ 与容量因子 CF 联合调（[方法 2.7.2](sec27.md#method-2.7.2)）；④ **专家并行**：专家分到不同设备，dispatch / combine 两次 all-to-all 与前后层计算做流水重叠（[2.7.8](sec27.md#sec-2.7.8)）。
- **理由**：MoE 用 $N/k$ 把「总参数量」与「每 token 计算量」解耦——容量由 $N$ 决定、成本由 $k$ 决定；但显存按 $N$ 涨（全部专家常驻），本质是**显存换吞吐**（[定理 2.7.4](sec27.md#thm-2.7.4)）。语种分布不均天然导致路由倾斜，必须用均衡机制 + 容量因子共同控制。
- **失败判据**：① 少数专家吃掉 $\gt50\%$ 的 token（路由坍缩，有效容量下降）；② 容量因子导致的丢弃率 $\gt5\%$；③ 少数语种（低资源语言）指标显著差于稠密基线；④ all-to-all 通信吃掉大部分收益（吞吐低于或接近稠密基线）；⑤ $L_{\text{aux}}$ 长期显著高于均匀基线 $\alpha$。
- **验证计划**：按语种分层报指标并给出每语种的路由分布；扫 $k\in\{1,2,4\}$ 与两档 CF 做单变量对照；监控专家使用率方差 / 最大最小比、丢弃率、通信占比三条曲线；固定种子重训确认。
- **评分要点**：方案含「专家结构 + 路由均衡 + 并行」三件（4 分）+ 理由指向 $N/k$ 与显存换吞吐（3 分）+ 判据可测量（3 分）。
:::
