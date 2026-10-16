# 第 2 讲总结 · 深度序列建模

> 本页把[导览](overview.md)与 [2.1](sec21.md)–[2.8](sec28.md) 压成一张可复习的骨架。用法：先只看「核心问题」列自问，答不全再读「关键结论」列，最后用「典型陷阱」列做校核。

## 节一览

| 节 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **[2.1 为什么需要序列模型](sec21.md)** | 序列的哪些性质让 MLP 失效？ | 三个要求：**变长 / 保序 / 参数共享**（[定义 2.1.1](sec21.md#def-2.1.1)）；四种任务形态的关键差别是**因果约束**（[定义 2.1.2](sec21.md#def-2.1.2)）；n-gram 的表规模约 $V^n$，5-gram 达 $3.1\times10^{23}$，结构上不支持长程（[例 2.1.1](sec21.md#ex-2.1.1)） | 把序列当无序集合；以为「pad 到定长 + MLP」可行；在线任务误用双向 |
| **[2.2 RNN：沿时间展开的权值共享与 BPTT](sec22.md)** | 递推怎么定义、梯度怎么回去、为什么回不去？ | $\boldsymbol h_t=\phi(W_{hh}\boldsymbol h_{t-1}+W_{xh}\boldsymbol x_t+\boldsymbol b_h)$，参数量 $(d_x+d_h)d_h+d_h+d_yd_h$ **与 $T$ 无关**；BPTT 含 $\operatorname{diag}(\phi')W_{hh}$ 的连乘，$\rho\lt1$ 指数消失、$\rho\gt1$ 指数爆炸，有效记忆跨度 $n^\star=-7/\log_{10}\rho$（[例 2.2.1](sec22.md#ex-2.2.1)） | 以为裁剪能治消失；以为换 ReLU 能治消失；把 $\boldsymbol h_t$ 当完整记忆 |
| **[2.3 门控：LSTM 与 GRU](sec23.md)** | 用什么替换「矩阵连乘」？ | 加法通道：$\partial\boldsymbol c_t/\partial\boldsymbol c_{t-1}=\operatorname{diag}(\boldsymbol f_t)$，**不含 $W$、只能衰减**；$f\equiv0.99$ 时 100 步仍留 $37\%$；参数量 $\text{RNN}:\text{GRU}:\text{LSTM}=1:3:4$（$20{,}608/61{,}824/82{,}432$） | 以为门控根治消失；以为 LSTM 训练可并行；跨 batch 忘了 `detach()` |
| **[2.4 注意力机制](sec24.md)** | 不压缩历史，怎么把它写成一个算子？ | $\operatorname{softmax}(\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_k})\boldsymbol V$，softmax 沿**键维**；$\operatorname{Var}(\boldsymbol q^{\mathrm T}\boldsymbol k)=d_k$；因果掩码在 softmax **之前**加 $-\infty$；纯注意力**置换等变**（[定理 2.4.2](sec24.md#thm-2.4.2)） | softmax 方向做错；掩码加 0；以为聚合的是 $K$；把权重当解释 |
| **[2.5 Transformer](sec25.md)** | 只靠注意力 + 前馈能否建序列模型？ | 多头**不改变参数量**（$4d^2+4d$）；FFN 占块内 $2/3$；$d=768$ 单块约 $7.09$M；Pre-LN 让梯度尺度与深度解耦；KV cache $2LB\,T n_{kv}d_h$ 字节 | 漏因果掩码（训练漂亮、生成崩坏）；LN 位置写反；把训练并行当推理并行 |
| **[2.6 位置编码、长序列与高效注意力](sec26.md)** | 位置怎么注入？平方复杂度怎么摊薄？ | 三类注入：**嵌入加性**（正弦 / 学习式）/ **QK 乘性**（RoPE：分数只依赖 $n-m$）/ **分数加性**（ALiBi、T5 分桶）；三笔账 $O(T^2)$ 显存、$O(T^2d)$ FLOPs、$O(T)$ KV cache；FlashAttention **精确**、FLOPs 不变 | 以为位置可有可无；以为 RoPE 无限外推；以为 FlashAttention 是近似 |
| **[2.7 现代序列架构](sec27.md)** | 注意力之外的路线各自换了什么、代价是什么？ | 线性 SSM 有「卷积 ⇄ 递推」双读法（[定理 2.7.1](sec27.md#thm-2.7.1)）；选择性 SSM 用**并行扫描**换回训练并行；SSD 对偶 $\boldsymbol Y=(M\odot\boldsymbol Q\boldsymbol K^{\mathsf T})\boldsymbol V$；线性注意力把 $T\times T$ 折成 $d\times d$ 状态；MoE 用 $N/k$ 解耦「总参数」与「每 token 计算量」 | 说「Mamba 已全面替代」；说线性注意力无损；以为 MoE 省显存；直接比 $O(T)$ 与 $O(T^2)$ |
| **[2.8 应用导读：Lab 1](sec28.md)** | 理论怎么落成一个能跑的实验？ | 旋律 → token → **错位一位**的自回归交叉熵 → 温度 / top-k / top-p 采样；$\mathrm{PPL}=e^{H}$，$\tau$ 只改「分数差被放大的倍数」；「训练好、自由跑崩」的分布偏移即 exposure bias | 用 argmax 生成；把损失下降当质量提升；只报 teacher-forced 损失 |

> **一条主线**：因为序列要求**变长 / 保序 / 参数共享**（2.1），所以必须沿序列方向复用同一套函数——最朴素的做法是**递推状态**（2.2），而它的训练病根是沿时间的**连乘雅可比**；为了保住长程梯度，把状态更新从「乘」改成「加」（2.3 门控），但**逐步递推的串行**与**定长状态瓶颈**一个都没解决；于是干脆不压缩，改成**按需对所有位置加权聚合**（2.4），代价是平方复杂度与置换等变（2.5 堆成主干、2.6 补位置与摊账）；此后所有工作都是在「**记忆容量 / 计算成本 / 并行度**」三笔账之间做交换（2.6 高效注意力、2.7 SSM、线性注意力、MoE），最后收束到一个可运行的自回归生成实验（2.8）。

## 三句话带走

1. **递推省内存、卷积省结构、注意力省路径**——三者的代价分别是「不能并行」「感受野要堆」「平方开销」。三代架构不是谁淘汰谁，而是在同一对矛盾（长程依赖要稳、序列要能并行）上不断挪动平衡点。
2. **两个数字决定 RNN 的命运**：跨了几步 $n$、单步伸缩率 $\rho$（长期由谱半径主导）。梯度量级按 $\rho^{\,n}$ 变化：$\rho\lt1$ 指数消失、$\rho\gt1$ 指数爆炸，**没有安全中间地带**；裁剪只治爆炸，消失必须改结构（加法通道）。
3. **注意力的一切都在一行里**：$\operatorname{softmax}(\boldsymbol Q\boldsymbol K^{\mathrm T}/\sqrt{d_k})\boldsymbol V$——softmax 沿键维，$\sqrt{d_k}$ 控制工作点，键指路、值交货；它置换等变，所以**位置必须显式注入**；它训练可并行、推理必须串行（KV cache）。

## 值得记住的定量结论

| 结论 | 数值 / 形式 | 出处 |
|:--|:--|:--|
| n-gram 参数表 | $V^n$：$V=5\times10^4$ 时 5-gram 约 $3.1\times10^{23}$ | [例 2.1.1](sec21.md#ex-2.1.1) |
| 有效记忆跨度 | $n^\star=-7/\log_{10}\rho$：$\rho=0.9\to153$ 步，$0.98\to798$ 步 | [例 2.2.1](sec22.md#ex-2.2.1) |
| 门控参数量对账 | $d_x=32,d_h=128$：$20{,}608/61{,}824/82{,}432$（$1:3:4$） | [例 2.3.1](sec23.md#ex-2.3.1) |
| 点积的方差 | $\operatorname{Var}(\boldsymbol q^{\mathrm T}\boldsymbol k)=d_k$，缩放后回到 $1$ | [定理 2.4.1](sec24.md#thm-2.4.1) |
| 单块参数量 | $d=768$：约 $7.09$M，注意力 $33.3\%$ / FFN $66.6\%$ | [例 2.5.1](sec25.md#ex-2.5.1) |
| KV cache | $L=32,B=1,T=8192$、FP16：MHA $4$ GiB / GQA $1$ GiB / MQA $0.125$ GiB | [方法 2.5.3](sec25.md#method-2.5.3) |
| 三笔账的增长阶 | $T$ 乘 $4$：分数矩阵与 FLOPs 各乘 $16$，KV cache 只乘 $4$ | [方法 2.6.1](sec26.md#method-2.6.1) |
| 采样三件套 | $\hat p_i\propto\exp(z_i/\tau)$；top-$p$：最小 $\mathcal S$ 使累积质量 $\ge p$ | [定义 2.8.3](sec28.md#def-2.8.3)、[例 2.8.1](sec28.md#ex-2.8.1) |

## 与后续的连接

- **[第 3 讲·深度计算机视觉](../lec03/overview.md)**：把本讲的注意力搬进视觉骨干，与卷积组成混合结构；[2.6](sec26.md) 讲的「位置注入 + 平方复杂度」在那里换成「patch 顺序 + 图像分辨率」。
- **[第 4 讲·深度生成建模](../lec04/overview.md)**：自回归、扩散与流匹配共用同一个「逐步生成」框架；本讲 [2.8](sec28.md) 的采样三件套是其中一支。
- **[第 6 讲·新前沿](../lec06/overview.md) 与 [第 9 讲·规模](../lec09/overview.md)**：注意力成为默认主干后的预训练与缩放律、以及张量并行 / 序列并行 / 显存工程，分别接在 [2.5](sec25.md) 与 [2.6](sec26.md) 的工程账上。
- **动手**：[Lab 1 · 音乐生成](../../labs/lab1.md)（与 [2.8](sec28.md) 的对照表逐条对应）；推导收口见[附录 C.3–C.5](../../appendix/derivations.md) 与 [C.18](../../appendix/derivations.md)。
- **自检路径**：[习题集](exercises.md)（A/B/C/D 四组）→ [回忆卡](recall-cards.md)（当天 / 隔天 / 第 3 天 / 第 7 天）→ [综合自测卷](mock-exam.md)（闭卷计时 100 分）；[学习目标自检表](checklist.md) 逐条对账 K2.x / S2.x / A2.x。全书的公式收口见[公式与结论卡](../../review/formula-cards.md)，成对概念辨析见[易混对照卡](../../review/contrast-cards.md)。
