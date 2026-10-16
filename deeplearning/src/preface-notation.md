# 符号与缩略语表

记号不统一是深度学习阅读的第一道坎：同一篇论文里 $\boldsymbol h$、$\boldsymbol s$、$\boldsymbol z$ 都可能指代不同的东西。这一页给出**本书的约定**——正文、公式、代码注释都用这一套。

## 一、数学符号

| 记号 | 含义 | 备注 |
|:--|:--|:--|
| $x,\ y$ | 标量（斜体） | 一般不用下标区别类型，看上下文 |
| $\boldsymbol x\in\mathbb R^{n}$ | 向量（粗体小写，默认**列向量**） | 代码里通常是一维张量或行向量 |
| $A\in\mathbb R^{m\times n}$ | 矩阵（大写斜体） | 行数 × 列数 |
| $\mathcal X,\ \mathcal D$ | 集合、数据集（花体） | |
| $\boldsymbol\theta$ | 全部可训练参数 | $\nabla_\theta$ 是对它求梯度 |
| $\mathcal L$ | 损失（花体 L） | 有时分写 $\mathcal L_{\mathrm{CE}}$、$\mathcal L_{\mathrm{MSE}}$ |
| $\eta$ | 学习率 | 有时用 $\alpha$（在 RL 里 $\alpha$ 常指学习率） |
| $\phi(\cdot)$ | 激活函数 | 逐元素作用 |
| $\sigma(\cdot)$ | Sigmoid；在 RL/统计中也表示 softmax 或 std | **按上下文判断**，本书会写明 |
| $\odot$ | Hadamard（逐元素）积 | 反传里高频出现 |
| $\lVert\cdot\rVert_p$ | $p$-范数 | 默认 $\lVert\cdot\rVert$ 指 2-范数 |
| $\mathbb E[\cdot],\ \mathrm{Var}[\cdot]$ | 期望、方差 | |
| $\mathrm{KL}(p\|q)$ | KL 散度 | 注意方向：$\mathrm{KL}(q\|p)$ 与 $\mathrm{KL}(p\|q)$ 不同 |
| $\nabla$ | 梯度算子 | $\nabla_\theta\mathcal L$ 是参数梯度 |
| $\sim$ | 服从某分布（如 $\varepsilon\sim\mathcal N(0,I)$） | 行内公式里尽量写成 `\sim` 以免与 Markdown 冲突 |
| $\propto$ | 正比于 | |
| $\arg\max,\ \arg\min$ | 取极值的自变量 | |
| $\mathbf 1[\cdot]$ | 指示函数（条件成立为 1） | 也叫 Iverson 括号 |
| $[\cdot]_+$ | 取正部 $\max(0,\cdot)$ | 等价于 ReLU |

## 二、张量与形状记号

| 记号 | 含义 | 典型场景 |
|:--|:--|:--|
| $B$ | 批大小（batch size） | 张量第 0 维 |
| $T$ | 序列长度（time steps / tokens） | 序列任务 |
| $d$ 或 $d_{\text{model}}$ | 模型维度（hidden size） | Transformer |
| $d_k,\ d_v$ | 单头键/值维度 | 通常 $d_k=d_v=d/h$ |
| $h$ | 注意力头数 | |
| $H_{kv}$ | KV 头数 | GQA 中 $H_{kv}\lt h$ |
| $L$ | 层数 | **注意与损失 $\mathcal L$ 区分**（字体会不同） |
| $N$ | 参数量 | 显存账里用 $N$ |
| $C$ | 通道数（图像）或算力（缩放律） | 看上下文 |
| $K$ | 卷积核尺寸 | |
| $B\times T\times d$ | 批 × 序列长 × 模型维 | **批优先**：批维恒在第 0 位 |
| $B\times C\times H\times W$ | 批 × 通道 × 高 × 宽 | 图像 |
| $B\times H\times T\times T$ | 注意力权重矩阵 | 显存大头 |

**约定**：本书一律**批优先**（batch-first），且**前向过程中批维不变**。凡是形状变化，正文都会给出推演表。

## 三、复杂度与规模记号

| 记号 | 含义 |
|:--|:--|
| $O(\cdot)$ | 渐进复杂度（默认时间；显存会写明） |
| FLOPs | 浮点运算次数（乘加各计一次或两次，本书会写明口径） |
| MFU | 模型算力利用率（model FLOPs utilization）＝实测吞吐 / 峰值算力 |
| $16N$ / $10N$ | 训练静态显存经验式（字节）——**务必写清口径**（精度 + 优化器） |
| PPL | 困惑度（perplexity）＝$\exp(\text{交叉熵})$ |

## 四、缩略语表（按讲次）

### 通用与第 1 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| DL | deep learning | 深度学习 |
| NN | neural network | 神经网络 |
| MLP | multi-layer perceptron | 多层感知机 |
| SGD | stochastic gradient descent | 随机梯度下降 |
| BN / LN | batch/layer normalization | 批／层归一化 |
| ReLU / GELU | rectified linear unit / Gaussian error linear unit | 两种激活函数 |
| CE / MSE | cross-entropy / mean squared error | 交叉熵／均方误差 |
| LR | learning rate | 学习率 |
| GD / BGD | gradient descent / batch GD | 梯度下降／全批梯度下降 |
| VJP | vector-Jacobian product | 向量—雅可比积（反向模式的核心） |

### 第 2 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| RNN | recurrent neural network | 循环神经网络 |
| BPTT | backpropagation through time | 沿时间反向传播 |
| LSTM / GRU | long short-term memory / gated recurrent unit | 两种门控 RNN |
| MHA / MQA / GQA | multi-head / multi-query / grouped-query attention | 多头／多查询／分组查询注意力 |
| RoPE | rotary position embedding | 旋转位置编码 |
| FFN | feed-forward network | 前馈网络（Transformer 里的逐位置 MLP） |
| KV cache | key-value cache | 推理缓存 |
| SSM | state space model | 状态空间模型 |
| MoE | mixture of experts | 混合专家 |

### 第 3 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| CNN | convolutional neural network | 卷积神经网络 |
| ViT | vision transformer | 视觉 Transformer |
| IoU | intersection over union | 交并比 |
| NMS | non-maximum suppression | 非极大值抑制 |
| mAP | mean average precision | 平均精度均值 |
| SAM | segment anything model | 提示式分割模型 |
| SSL | self-supervised learning | 自监督学习 |
| CLIP | contrastive language–image pretraining | 图文对比预训练 |

### 第 4 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| AE / VAE | (variational) autoencoder | （变分）自编码器 |
| ELBO | evidence lower bound | 证据下界 |
| GAN | generative adversarial network | 生成对抗网络 |
| DDPM / DDIM | denoising diffusion probabilistic model / implicit model | 扩散模型及其确定性采样变体 |
| LDM | latent diffusion model | 潜空间扩散 |
| DiT | diffusion transformer | 扩散 Transformer |
| CFG | classifier-free guidance | 无分类器引导 |
| VQ | vector quantization | 向量量化 |

### 第 5 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| RL | reinforcement learning | 强化学习 |
| MDP | Markov decision process | 马尔可夫决策过程 |
| TD | temporal difference | 时序差分 |
| DQN | deep Q-network | 深度 Q 网络 |
| PG / AC | policy gradient / actor-critic | 策略梯度／演员—评论家 |
| GAE | generalized advantage estimation | 广义优势估计 |
| PPO / TRPO | proximal policy optimization / trust region policy optimization | 两种策略优化方法 |
| RLHF | reinforcement learning from human feedback | 人类反馈强化学习 |
| DPO | direct preference optimization | 直接偏好优化 |
| GRPO | group relative policy optimization | 组相对策略优化 |

### 第 6 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| LLM | large language model | 大语言模型 |
| SFT | supervised fine-tuning | 监督微调 |
| CoT | chain-of-thought | 思维链 |
| ICL | in-context learning | 上下文学习 |
| VLM | vision-language model | 视觉语言模型 |
| VLA | vision-language-action model | 视觉—语言—动作模型 |
| PRM / ORM | process / outcome reward model | 过程／结果奖励模型 |
| MCP | model context protocol | 模型上下文协议（工具调用协议） |
| RAG | retrieval-augmented generation | 检索增强生成 |

### 第 7 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| SAE | sparse autoencoder | 稀疏自编码器 |
| ECE | expected calibration error | 期望校准误差 |
| FGSM / PGD | fast gradient sign method / projected gradient descent | 两种对抗攻击 |
| DP / EO | demographic parity / equal opportunity | 两种公平性度量 |
| RMF | risk management framework | 风险管理框架（NIST 等） |
| GPAI | general-purpose AI | 通用目的 AI（欧盟 AI Act 的分类） |

### 第 8 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| AF2 / AF3 | AlphaFold 2 / 3 | 蛋白质结构预测模型 |
| pLDDT | predicted local distance difference test | 结构预测的局部置信度指标 |
| DFT | density functional theory | 密度泛函理论（第一性原理计算） |
| PINN | physics-informed neural network | 物理信息神经网络 |
| FNO / DeepONet | Fourier neural operator / deep operator network | 神经算子的两类实现 |
| ERA5 | ECMWF Reanalysis v5 | 常用气象再分析数据集 |
| ACC / RMSE | anomaly correlation coefficient / root mean squared error | 预报常用指标 |

### 第 9 讲

| 缩写 | 全称 | 中文 |
|:--|:--|:--|
| DP / DDP | (distributed) data parallel | （分布式）数据并行 |
| ZeRO | zero redundancy optimizer | 零冗余优化器（分片） |
| FSDP | fully sharded data parallel | 全分片数据并行 |
| TP / PP / SP / CP | tensor / pipeline / sequence / context parallelism | 张量／流水线／序列／上下文并行 |
| AMP | automatic mixed precision | 自动混合精度 |
| PEFT | parameter-efficient fine-tuning | 参数高效微调 |
| LoRA / QLoRA | low-rank adaptation / quantized LoRA | 低秩适配／量化低秩适配 |
| MFU (复现) | model FLOPs utilization | 算力利用率 |
| NCCL | NVIDIA collective communications library | 集合通信库 |

## 五、常见「同名不同义」提醒

| 记号 | 在这个语境下 | 在另一个语境下 |
|:--|:--|:--|
| $\alpha$ | 学习率（RL 常用） | 缩放律的指数；LeakyReLU 斜率；EMA 系数 |
| $\beta$ | 动量系数（Adam） | DPO/KL 正则强度；β-VAE 的 KL 权重；扩散的方差 schedule |
| $\gamma$ | 折扣因子（RL） | 归一化层的可学习缩放；GAE 的折扣 |
| $\lambda$ | 正则强度（权重衰减） | GAE 的偏差方差旋钮；特征值；损失权重 |
| $\sigma$ | Sigmoid 函数 | 标准差；softmax；在扩散里常指噪声 schedule |
| $\varepsilon$ | 数值稳定项（优化器） | PPO 的裁剪半径；对抗扰动的幅度；DP 的隐私预算 |
| $\tau$ | 温度（采样） | 时间常数；目标网络的软更新系数 |

**遇到歧义时以正文的局部定义为准**；本书在每个首次出现的符号处都会说明其含义。
