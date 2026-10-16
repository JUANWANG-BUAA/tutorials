# 一页速览 · 公式与结论卡

九讲的必记公式与结论收口于此。**复习时只读这一页**，逐条自问：能否默写、能否解释每个符号、能否说出适用条件。

::: note 怎么用这一页
- **默写模式**：遮住右列，只看「项」名，把公式写出来。
- **追问模式**：每条公式追问三句——符号是什么？从哪来？什么条件下失效？
- **配套**：[速查背记卡](../memory-sheet.md)（最小可背诵单元）、[易混对照卡](contrast-cards.md)（成对辨析）、[闭卷回忆卡](../lectures/lec01/recall-cards.md)（检索练习）。
:::

## 第 1 讲 · 基础

| 项 | 公式 / 结论 |
|:--|:--|
| 神经元 | $z=\boldsymbol w^{\mathrm T}\boldsymbol x+b,\quad a=\phi(z)$ |
| MLP 前向 | $\boldsymbol z^{(l)}=\boldsymbol a^{(l-1)}W^{(l)}+\boldsymbol b^{(l)},\quad \boldsymbol a^{(l)}=\phi(\boldsymbol z^{(l)})$ |
| 通用逼近（陈述） | 紧集上连续函数可被足够宽的单隐层网络一致逼近；**不含**「宽度可寻 / 可训练 / 样本高效」的保证 |
| Softmax | $\hat y_c=\dfrac{e^{z_c}}{\sum_{c'}e^{z_{c'}}}$ |
| 交叉熵 | $\mathcal L_{\mathrm{CE}}=-\sum_c y_c\log\hat y_c$ |
| CE + softmax 的梯度 | $\dfrac{\partial\mathcal L}{\partial\boldsymbol z}=\hat{\boldsymbol y}-\boldsymbol y$（**不随饱和消失**） |
| MSE | $\mathcal L_{\mathrm{MSE}}=\dfrac1N\sum_i(\hat y_i-y_i)^2$ |
| 梯度下降 | $\theta\leftarrow\theta-\eta\nabla_\theta\mathcal L$ |
| 反向传播 | $\boldsymbol\delta^{(l)}=\bigl(\boldsymbol\delta^{(l+1)}W^{(l+1)\mathrm T}\bigr)\odot\phi'(\boldsymbol z^{(l)})$，$\ \nabla_{W^{(l)}}=\boldsymbol a^{(l-1)\mathrm T}\boldsymbol\delta^{(l)}$ |
| Momentum | $\boldsymbol v\leftarrow\beta\boldsymbol v+\nabla_\theta\mathcal L,\quad \theta\leftarrow\theta-\eta\boldsymbol v$ |
| Adam 偏差修正 | $\hat m=\dfrac{m}{1-\beta_1^t},\ \hat v=\dfrac{v}{1-\beta_2^t},\ \theta\leftarrow\theta-\eta\dfrac{\hat m}{\sqrt{\hat v}+\epsilon}$ |
| AdamW | 权重衰减**解耦**：$\theta\leftarrow\theta-\eta\bigl(\hat m/(\sqrt{\hat v}+\epsilon)+\lambda\theta\bigr)$ |
| 线性缩放规则 | 批大小 $\times k\ \Rightarrow$ 学习率 $\times k$（配 warmup） |
| Dropout（推理） | 期望等价：$a\leftarrow p\,a$（inverted dropout 在训练期已除以 $p$） |

## 第 2 讲 · 序列

| 项 | 公式 / 结论 |
|:--|:--|
| RNN | $\boldsymbol h_t=\phi(W_{xh}\boldsymbol x_t+W_{hh}\boldsymbol h_{t-1}+\boldsymbol b)$ |
| BPTT 梯度 | $\dfrac{\partial\mathcal L}{\partial\boldsymbol h_t}$ 含 $\prod_{k}\dfrac{\partial\boldsymbol h_{k+1}}{\partial\boldsymbol h_k}$——谱半径 $\lt1$ 时指数衰减（梯度消失） |
| 梯度裁剪 | $\boldsymbol g\leftarrow\boldsymbol g\cdot\min\bigl(1,\ \tau/\lVert\boldsymbol g\rVert\bigr)$ |
| LSTM 门 | $\boldsymbol f_t,\boldsymbol i_t,\boldsymbol o_t=\sigma(\cdot)$；$\boldsymbol C_t=\boldsymbol f_t\odot\boldsymbol C_{t-1}+\boldsymbol i_t\odot\tilde{\boldsymbol C}_t$；$\boldsymbol h_t=\boldsymbol o_t\odot\tanh\boldsymbol C_t$ |
| 注意力 | $\mathrm{Attention}(Q,K,V)=\mathrm{softmax}\!\left(\dfrac{QK^{\mathrm T}}{\sqrt{d_k}}\right)V$ |
| 除 $\sqrt{d_k}$ 的理由 | $\mathrm{Var}(q\cdot k)$ 随 $d_k$ 线性增长 → softmax 饱和 → 梯度消失 |
| 多头 | $\mathrm{head}_i=\mathrm{Attention}(QW_i^Q,KW_i^K,VW_i^V)$，拼接后过 $W_O$ |
| 复杂度 | 时间 $O(T^2d)$；训练显存 $O(T^2)$（FlashAttention 降到 $O(T)$，FLOPs 不变） |
| 正弦位置编码 | $\mathrm{PE}_{(pos,2i)}=\sin\!\bigl(pos/10000^{2i/d}\bigr)$，奇数维用 $\cos$ |
| RoPE | $\langle R_mq,\ R_nk\rangle=\langle q,\ R_{n-m}k\rangle$——位置写进内积，天然含相对距离 |
| KV cache 显存 | $\approx 2\cdot L\cdot H_{kv}\cdot d_{h}\cdot T\cdot B\cdot \text{字节}$（GQA 按 KV 头数等比削减） |
| MoE | $\boldsymbol y=\sum_{i\in\mathrm{TopK}}\!g_i(\boldsymbol x)E_i(\boldsymbol x)$，$g$ 为 softmax 路由；$K$ 常取 1–2 |

## 第 3 讲 · 视觉

| 项 | 公式 / 结论 |
|:--|:--|
| 卷积输出尺寸 | $H_{\text{out}}=\left\lfloor\dfrac{H_{\text{in}}-K+2P}{S}\right\rfloor+1$ |
| 单层参数量 | $K^2\cdot C_{\text{in}}\cdot C_{\text{out}}+C_{\text{out}}$（**与输入分辨率无关**） |
| 卷积 FLOPs | $\approx H_{\text{out}}W_{\text{out}}\cdot C_{\text{out}}\cdot K^2C_{\text{in}}$（乘加各算一次） |
| 感受野递推 | $r_{\text{out}}=r_{\text{in}}+(K-1)\cdot j_{\text{in}}$ |
| 残差块 | $\boldsymbol y=\boldsymbol x+\mathcal F(\boldsymbol x)$，梯度含恒等项 $\to$ 深层可训 |
| BatchNorm | $\hat x=\dfrac{x-\mu_B}{\sqrt{\sigma_B^2+\epsilon}}$，$y=\gamma\hat x+\beta$；**推理用滑动统计** |
| LayerNorm | 在**特征维**逐样本归一化（不跨样本、不依赖批大小） |
| 深度可分卷积 | $K^2C_{\text{in}}$（深度）+ $C_{\text{in}}C_{\text{out}}$（逐点）$\ll K^2C_{\text{in}}C_{\text{out}}$ |

## 第 4 讲 · 生成

| 项 | 公式 / 结论 |
|:--|:--|
| VAE 重参数化 | $\boldsymbol z=\boldsymbol\mu+\boldsymbol\sigma\odot\boldsymbol\varepsilon,\ \boldsymbol\varepsilon\sim\mathcal N(\boldsymbol0,I)$ |
| ELBO | $\log p(\boldsymbol x)\ge\mathbb E_{q}[\log p_\theta(\boldsymbol x\mid\boldsymbol z)]-\mathrm{KL}\bigl(q_\phi(\boldsymbol z\mid\boldsymbol x)\,\Vert\,p(\boldsymbol z)\bigr)$ |
| KL 闭式（对角高斯） | $\mathrm{KL}=\tfrac12\sum_j\bigl(\mu_j^2+\sigma_j^2-1-\log\sigma_j^2\bigr)$ |
| GAN 目标 | $\min_G\max_D\ \mathbb E_{\boldsymbol x}[\log D(\boldsymbol x)]+\mathbb E_{\boldsymbol z}[\log(1-D(G(\boldsymbol z)))]$ |
| 扩散前向闭式 | $\boldsymbol x_t=\sqrt{\bar\alpha_t}\,\boldsymbol x_0+\sqrt{1-\bar\alpha_t}\,\boldsymbol\varepsilon$，$\bar\alpha_t=\prod_{s\le t}\alpha_s$ |
| 扩散训练损失 | $\mathcal L=\mathbb E_{t,\boldsymbol x_0,\boldsymbol\varepsilon}\bigl[\lVert\boldsymbol\varepsilon-\boldsymbol\varepsilon_\theta(\boldsymbol x_t,t)\rVert^2\bigr]$ |
| DDIM 采样 | 确定性反向：由 $\boldsymbol x_t$ 与预测的 $\boldsymbol x_0$（或 $\boldsymbol\varepsilon$）直接推 $\boldsymbol x_{t-1}$，可跳步 |
| CFG（条件引导） | $\tilde{\boldsymbol\varepsilon}=\boldsymbol\varepsilon_\varnothing+s\bigl(\boldsymbol\varepsilon_{\boldsymbol c}-\boldsymbol\varepsilon_\varnothing\bigr)$；$s$ 越大越贴提示、多样性越低 |
| 流匹配/整流流 | $\boldsymbol x_t=(1-t)\boldsymbol x_0+t\boldsymbol x_1$，回归速度场 $\mathcal L=\lVert v_\theta(\boldsymbol x_t,t)-(\boldsymbol x_1-\boldsymbol x_0)\rVert^2$ |
| VQ 量化 | $z_q=\arg\min_{e_k}\lVert z-e_k\rVert$；损失含代码本损失 + commitment 损失 + 直通估计 |

## 第 5 讲 · 强化学习

| 项 | 公式 / 结论 |
|:--|:--|
| 回报 | $G_t=\sum_{k\ge0}\gamma^k r_{t+k}$ |
| 动作值 | $Q^\pi(s,a)=\mathbb E_\pi[G_t\mid s_t=s,a_t=a]$ |
| 贝尔曼期望 | $Q^\pi(s,a)=\mathbb E_{s'}\bigl[r+\gamma\,\mathbb E_{a'\sim\pi}Q^\pi(s',a')\bigr]$ |
| 贝尔曼最优 | $Q^\star(s,a)=\mathbb E_{s'}\bigl[r+\gamma\max_{a'}Q^\star(s',a')\bigr]$ |
| Q-learning 更新 | $Q(s,a)\leftarrow Q(s,a)+\alpha\bigl[r+\gamma\max_{a'}Q(s',a')-Q(s,a)\bigr]$ |
| 策略梯度定理 | $\nabla_\theta J=\mathbb E\bigl[\nabla_\theta\log\pi_\theta(a\mid s)\,A^\pi(s,a)\bigr]$ |
| GAE | $A_t=\sum_{l\ge0}(\gamma\lambda)^l\delta_{t+l}$，$\delta_t=r_t+\gamma V(s_{t+1})-V(s_t)$ |
| PPO 裁剪 | $\mathcal L^{\mathrm{clip}}=\mathbb E\bigl[\min\bigl(\rho_tA_t,\ \mathrm{clip}(\rho_t,1-\epsilon,1+\epsilon)A_t\bigr)\bigr]$，$\rho_t=\pi_\theta/\pi_{\theta_{\text{old}}}$ |
| 熵正则 | 目标加 $+\beta\,\mathcal H(\pi_\theta(\cdot\mid s))$ 鼓励探索 |
| Bradley–Terry | $P(y_w\succ y_l)=\sigma\bigl(r(y_w)-r(y_l)\bigr)$ |
| DPO 损失 | $-\log\sigma\Bigl(\beta\log\dfrac{\pi_\theta(y_w)}{\pi_{\text{ref}}(y_w)}-\beta\log\dfrac{\pi_\theta(y_l)}{\pi_{\text{ref}}(y_l)}\Bigr)$ |
| GRPO 优势 | $\hat A_i=\dfrac{r_i-\mathrm{mean}(\boldsymbol r)}{\mathrm{std}(\boldsymbol r)}$（同组内相对，去掉 critic） |

## 第 6 讲 · 新前沿

| 项 | 公式 / 结论 |
|:--|:--|
| 语言建模目标 | $\mathcal L=-\sum_t\log p_\theta(x_t\mid x_{\lt t})$（teacher forcing） |
| 困惑度 | $\mathrm{PPL}=\exp\bigl(-\tfrac1N\sum_i\log p_\theta(x_i)\bigr)$ |
| 缩放律（形式） | $L(N,D)=E+\dfrac{A}{N^{\alpha}}+\dfrac{B}{D^{\beta}}$（Chinchilla 修正了系数与最优配比） |
| 计算最优配比 | 给定算力 $C$：$N^\star\propto C^{0.5}$、$D^\star\propto C^{0.5}$，经验上 $D\approx 20N$ |
| 测试时计算 | 多采样投票期望正确率随样本数上升但**边际递减**；验证器重排可再提升 |
| VLM 三段式 | ① 连接器对齐（冻结 LLM 只训投影）② 指令微调（解冻）③ 偏好优化 |
| Agent 循环 | 推理（Reason）→ 行动（Act，工具）→ 观察（Observe）→ 循环 |
| 基准污染 | 分数受污染影响可能显著高估；对策：私有题集、时间切分、动态基准 |

## 第 7 讲 · 可信 AI

| 项 | 公式 / 结论 |
|:--|:--|
| 期望校准误差 | $\mathrm{ECE}=\sum_m\dfrac{\lvert B_m\rvert}{n}\bigl\lvert\mathrm{acc}(B_m)-\mathrm{conf}(B_m)\bigr\rvert$ |
| 温度缩放 | $p=\mathrm{softmax}(\boldsymbol z/T)$，$T\gt1$ 使分布更平滑（降低过度自信） |
| FGSM 攻击 | $\boldsymbol x'=\boldsymbol x+\epsilon\,\mathrm{sign}\bigl(\nabla_{\boldsymbol x}\mathcal L\bigr)$ |
| PGD 攻击 | 多步 FGSM + 投影回 $\epsilon$-球 |
| 对抗训练 | $\min_\theta\ \mathbb E_{(x,y)}\Bigl[\max_{\lVert\delta\rVert\le\epsilon}\mathcal L\bigl(f_\theta(x+\delta),y\bigr)\Bigr]$ |
| SAE 损失 | $\mathcal L=\lVert\boldsymbol x-\mathrm{Dec}(\mathrm{Enc}(\boldsymbol x))\rVert^2+\lambda\lVert\mathrm{Enc}(\boldsymbol x)\rVert_1$（L1 促稀疏） |
| 公平性冲突 | 人口统计均等、机会均等、预测均等一般**不能同时满足**（不可能性结果）——必须显式选择 |
| 差分隐私（直观） | 相邻数据集上输出分布之比受 $e^{\varepsilon}$ 约束；$\varepsilon$ 越小隐私越强、效用越低 |

## 第 8 讲 · AI for Science

| 项 | 公式 / 结论 |
|:--|:--|
| 等变 / 不变 | 等变：$f(R\boldsymbol x)=Rf(\boldsymbol x)$；不变：$f(R\boldsymbol x)=f(\boldsymbol x)$（能量对旋转不变，力等变） |
| 势函数加速 | 机器学习势函数在近 DFT 精度下比第一性原理快 $10^3$–$10^6$ 量级 |
| PINN 损失 | $\mathcal L=\mathcal L_{\text{data}}+\lambda\lVert\mathcal N[u_\theta]\rVert^2$（$\mathcal N$ 为 PDE 残差算子） |
| 神经算子 | 学「函数 → 函数」映射：$\mathcal G_\theta: a(\cdot)\mapsto u(\cdot)$（FNO 频域截断 / DeepONet 分支-主干） |
| 多步预报误差 | 自回归展开的误差累积是天气类模型的核心难点（训练与推理的分布差异） |

## 第 9 讲 · 并行与显存

| 项 | 公式 / 结论 |
|:--|:--|
| 显存五账单 | 参数 $2N$ + 梯度 $2N$ + 优化器状态 $8N$ + 主权重 $4N$（混合精度 Adam）≈ **$16N$ 字节** |
| 8-bit 优化器 | 优化器状态 $8N\to\sim2N$，总量 ≈ $10N$ |
| 激活显存 | 与 $B\cdot T\cdot L$ 成正比；注意力项含 $B\!\cdot\!H\!\cdot\!T^2$ |
| 数据并行 | 每卡一份模型、切分数据、All-Reduce 同步梯度（通信量 ≈ $2N$ 每步） |
| 张量并行 | 列并行（拼接输出）与行并行（求和输出）；每层多次通信，**层内**并行 |
| 梯度累积 | 累积 $k$ 步再更新 ≈ 批大小放大 $k$ 倍（梯度方差按 $1/k$ 降低） |
| 流水线气泡 | $\dfrac{P-1}{M+P-1}$（$P$ 段、$M$ 个 micro-batch） |
| ZeRO 通信 | ZeRO-1/2 与 DP 相当；ZeRO-3 需 all-gather 参数，通信量更高（约 $1.5\times$ 量级） |
| LoRA | $h=W_0\boldsymbol x+BA\boldsymbol x$，可训参数 $r(d+k)$，初始 $B=0$（起点等价基座） |
| 量化推理 | 4-bit 权重把 7B 模型压到 ≈ 4 GB（近似无损需校准与分组尺度） |

::: method[core] 三句话带走（全书）
1. **一个范式**：结构 + 损失 + 梯度下降；反向传播是链式法则的线性时间实现。
2. **四条支线**：序列用注意力、视觉用卷积、生成学分布、决策学策略——同一个范式换结构。
3. **规模与责任**：大模型训练的核心是显存与通信（第 9 讲）；能力强了以后，可控、可信、公平成为设计约束（第 7 讲）。
:::

::: errata 背公式时最常见的五处混淆
1. **把 $\sqrt{d_k}$ 记成 $\sqrt{d}$**：$d_k$ 是**单头**的键维度（$d/h$），不是模型维度。
2. **把扩散的 $\bar\alpha_t$ 与 $\alpha_t$ 混用**：$\alpha_t=1-\beta_t$ 是单步，$\bar\alpha_t$ 是累乘。
3. **把 PPO 的 $\epsilon$ 与优化器的 $\epsilon$ 混用**：前者是裁剪半径，后者是数值稳定项。
4. **把 ZeRO-3 的通信量记成与 DP 相同**：分片参数必须 all-gather，通信更高。
5. **把 $16N$ 记成「所有情况」**：它对应「混合精度 + Adam 系 + 含主权重」；纯 fp32 或 SGD 的口径不同。
:::
