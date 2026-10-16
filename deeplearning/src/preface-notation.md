# 符号与缩略语表

记号全书统一。张量维度沿用框架习惯（PyTorch 风格：批优先），数学记号沿用线性代数标准。

## 数学符号

| 记号 | 含义 |
|:--|:--|
| $\boldsymbol{x}\in\mathbb R^n$ | 向量（粗体小写） |
| $A\in\mathbb R^{m\times n}$ | 矩阵（大写） |
| $\boldsymbol{x}^{\mathrm T}$ | 转置 |
| $\odot$ | 逐元素乘（Hadamard 积） |
| $\langle\boldsymbol x,\boldsymbol y\rangle$ | 内积，同 $\boldsymbol x^{\mathrm T}\boldsymbol y$ |
| $\lVert\boldsymbol x\rVert$ | 范数（默认 2-范数） |
| $\mathbb E[\cdot]$ | 期望 |
| $\nabla_\theta\mathcal L$ | 损失对参数 $\theta$ 的梯度 |
| $\mathcal N(\boldsymbol\mu,\Sigma)$ | 均值 $\boldsymbol\mu$、协方差 $\Sigma$ 的高斯分布 |
| $\sigma(\cdot)$ | Sigmoid 函数，$\sigma(z)=1/(1+e^{-z})$ |
| $\mathrm{softmax}(\cdot)$ | 归一化指数函数 |
| $\eta$ | 学习率 |
| $\lambda$ | 正则强度 / 特征值（按上下文） |
| $\theta$ | 全部可训练参数（含 $W,\boldsymbol b$） |

## 网络与训练记号

| 记号 | 含义 |
|:--|:--|
| $\boldsymbol x$ | 输入；$y$ 真值标签；$\hat y$ 预测 |
| $W^{(l)},\boldsymbol b^{(l)}$ | 第 $l$ 层的权矩阵与偏置 |
| $\boldsymbol z^{(l)}=\boldsymbol a^{(l-1)}W^{(l)}+\boldsymbol b^{(l)}$ | 第 $l$ 层的**预激活** |
| $\boldsymbol a^{(l)}=\phi(\boldsymbol z^{(l)})$ | 第 $l$ 层的**激活**（$a^{(0)}=\boldsymbol x$） |
| $\phi$ | 激活函数（ReLU / GELU / tanh…） |
| $\mathcal L$ | 损失函数 |
| $B$ | 批大小（batch size） |
| $T$ | 序列长度（time steps） |
| $C$ | 通道数 / 类别数（按上下文） |
| $d$ / $d_k$ | 特征维度 / 注意力键维度 |

## 缩略语（中英对照）

| 缩写 | 英文 | 中文 |
|:--|:--|:--|
| MLP | Multi-Layer Perceptron | 多层感知机 |
| CNN | Convolutional Neural Network | 卷积神经网络 |
| RNN | Recurrent Neural Network | 循环神经网络 |
| LSTM | Long Short-Term Memory | 长短期记忆网络 |
| GRU | Gated Recurrent Unit | 门控循环单元 |
| GAN | Generative Adversarial Network | 生成对抗网络 |
| VAE | Variational Autoencoder | 变分自编码器 |
| ELBO | Evidence Lower BOund | 证据下界 |
| MDP | Markov Decision Process | 马尔可夫决策过程 |
| DQN | Deep Q-Network | 深度 Q 网络 |
| PPO | Proximal Policy Optimization | 近端策略优化 |
| RLHF | Reinforcement Learning from Human Feedback | 人类反馈强化学习 |
| LLM | Large Language Model | 大语言模型 |
| VLM / VLA | Vision-Language (Action) Model | 视觉-语言（动作）模型 |
| LoRA | Low-Rank Adaptation | 低秩适配 |
| PEFT | Parameter-Efficient Fine-Tuning | 参数高效微调 |
| FSDP | Fully Sharded Data Parallel | 全分片数据并行 |
| SOTA | State Of The Art | 当前最优 |
