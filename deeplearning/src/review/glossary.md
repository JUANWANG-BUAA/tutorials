# 术语索引（中英对照）

按讲次分组，列出全书核心术语的中英对照、一句话含义与出处。**查阅时用浏览器的页内搜索**（<kbd>⌘F</kbd> / <kbd>Ctrl+F</kbd>）最快。

## 第 1 讲 · 基础

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 神经元 | neuron | 输入加权求和后过一次非线性激活的基本单元 | [1.1](../lectures/lec01.md) |
| 感知机 | perceptron | 无隐藏层的线性分类器，只能划分线性可分数据 | [1.1](../lectures/lec01.md) |
| 多层感知机 | MLP | 多个「线性 + 非线性」层堆叠而成的前馈网络 | [1.2](../lectures/lec01.md) |
| 预激活 | pre-activation | 线性变换后、过激活前的量 $\boldsymbol z^{(l)}$ | [1.2](../lectures/lec01.md) |
| 激活函数 | activation function | 提供非线性的逐元素函数（ReLU / GELU 等） | [1.3](../lectures/lec01.md) |
| 通用逼近 | universal approximation | 够宽的 MLP 可在紧集上逼近任意连续函数 | [1.2](../lectures/lec01.md) |
| 交叉熵 | cross-entropy | 分类损失，只惩罚正确类别的预测概率 | [1.4](../lectures/lec01.md) |
| 均方误差 | MSE | 回归损失，预测与真值之差的平方平均 | [1.4](../lectures/lec01.md) |
| 随机梯度下降 | SGD | 用小批量梯度估计真梯度的更新方式 | [1.5](../lectures/lec01.md) |
| 反向传播 | backpropagation | 链式法则的线性时间实现，一次前向 + 一次反向得到全部梯度 | [1.5](../lectures/lec01.md) |
| 动量 | momentum | 累积历史梯度方向以抑制震荡的优化技巧 | [1.6](../lectures/lec01.md) |
| Adam | Adam | 自适应学习率 + 动量的优化器 | [1.6](../lectures/lec01.md) |
| 过拟合 | overfitting | 训练好、验证差的「高方差」现象 | [1.7](../lectures/lec01.md) |
| Dropout | dropout | 训练时随机置零神经元，近似集成大量子网络 | [1.7](../lectures/lec01.md) |
| 权重衰减 | weight decay | 在损失里加参数范数惩罚（L2） | [1.7](../lectures/lec01.md) |

## 第 2 讲 · 序列

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 循环神经网络 | RNN | 带隐状态递推、权值沿时间共享的序列模型 | [2.2](../lectures/lec02.md) |
| 梯度消失 | vanishing gradient | 反向传播沿时间连乘导致远距离梯度趋零 | [2.2](../lectures/lec02.md) |
| 长短期记忆 | LSTM | 用门控与细胞状态稳住梯度通道的门控 RNN | [2.3](../lectures/lec02.md) |
| 门控循环单元 | GRU | LSTM 的简化版，用更新门与重置门 | [2.3](../lectures/lec02.md) |
| 注意力机制 | attention | 对序列任意位置加权聚合，路径长度恒为 1 | [2.4](../lectures/lec02.md) |
| 自注意力 | self-attention | Q、K、V 都来自同一序列的注意力 | [2.5](../lectures/lec02.md) |
| 多头注意力 | multi-head attention | 并行多组注意力，捕获不同子空间的依赖 | [2.5](../lectures/lec02.md) |
| Transformer | Transformer | 纯注意力 + 前馈 + 残差/归一化构成的架构 | [2.5](../lectures/lec02.md) |
| 位置编码 | positional encoding | 给注意力注入顺序信息，破其置换等变 | [2.5](../lectures/lec02.md) |
| 温度采样 | temperature sampling | 缩放 logits 调节生成分布的平坦程度 | [Lab 1](../labs/lab1.md) |

## 第 3 讲 · 视觉

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 卷积 | convolution | 局部连接 + 权值共享的滑窗算子 | [3.2](../lectures/lec03.md) |
| 感受野 | receptive field | 输出单元受输入影响的区域大小 | [3.2](../lectures/lec03.md) |
| 步幅 | stride | 滑窗的移动步长 | [3.2](../lectures/lec03.md) |
| 填充 | padding | 在边界补零以控制输出尺寸 | [3.2](../lectures/lec03.md) |
| 池化 | pooling | 局部下采样，带来一定平移不变性 | [3.3](../lectures/lec03.md) |
| 残差连接 | residual connection | $\boldsymbol y=\mathcal F(\boldsymbol x)+\boldsymbol x$，使极深网络可训练 | [3.4](../lectures/lec03.md) |
| 迁移学习 | transfer learning | 复用预训练特征到小数据下游任务 | [3.5](../lectures/lec03.md) |
| 交并比 | IoU | 检测里框的匹配准则与评价指标 | [Lab 2](../labs/lab2.md) |
| 非极大值抑制 | NMS | 去掉重叠重复框的后处理 | [Lab 2](../labs/lab2.md) |
| 对抗样本 | adversarial example | 人眼不可察的扰动导致模型误判 | [3.7](../lectures/lec03.md) |

## 第 4 讲 · 生成

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 自编码器 | autoencoder | 编码—解码重建，用于学潜表示 | [4.2](../lectures/lec04.md) |
| 变分自编码器 | VAE | 引入潜变量与 KL 正则的生成模型 | [4.3](../lectures/lec04.md) |
| 重参数化技巧 | reparameterization trick | 把随机性搬到与参数无关的 $\varepsilon$，使采样可导 | [4.3](../lectures/lec04.md) |
| 证据下界 | ELBO | VAE 的可优化下界：重建项 − KL 正则 | [4.3](../lectures/lec04.md) |
| 生成对抗网络 | GAN | 生成器与判别器对抗博弈的生成模型 | [4.4](../lectures/lec04.md) |
| 模式坍塌 | mode collapse | GAN 只生成少数几类样本的失效模式 | [4.4](../lectures/lec04.md) |
| 扩散模型 | diffusion model | 前向加噪、反向学去噪的生成模型 | [4.5](../lectures/lec04.md) |

## 第 5 讲 · 决策

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 马尔可夫决策过程 | MDP | 强化学习的形式框架：状态/动作/转移/奖励/折扣 | [5.2](../lectures/lec05.md) |
| 回报 | return | 折扣累积奖励 $G_t=\sum\gamma^k r_{t+k}$ | [5.2](../lectures/lec05.md) |
| 值函数 | value function | 某状态下（动作下）的期望回报 | [5.2](../lectures/lec05.md) |
| 深度 Q 网络 | DQN | 用神经网络逼近 Q，配经验回放与目标网络 | [5.3](../lectures/lec05.md) |
| 策略梯度 | policy gradient | 好动作提高概率、坏动作降低概率 | [5.4](../lectures/lec05.md) |
| 优势函数 | advantage | $A=Q-V$，用于降低策略梯度方差 | [5.4](../lectures/lec05.md) |
| 近端策略优化 | PPO | 用裁剪重要性比提升稳定性的策略算法 | [5.5](../lectures/lec05.md) |
| 人类反馈强化学习 | RLHF | 用人类偏好训奖励模型，再用 RL 对齐大模型 | [5.6](../lectures/lec05.md) |

## 第 6–9 讲 · 前沿与规模

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 缩放律 | scaling law | 损失随模型/数据/算力规模按幂律下降的经验规律 | [6.1](../lectures/lec06.md) |
| 思维链 | chain-of-thought | 让模型显式写出中间推理步骤 | [6.2](../lectures/lec06.md) |
| 上下文学习 | in-context learning | 把任务当作提示前缀，无需改参数即完成新任务 | [6.2](../lectures/lec06.md) |
| 视觉-语言-动作模型 | VLA | 把多模态理解接到机器人低层控制 | [6.4](../lectures/lec06.md) |
| 世界模型 | world model | 在内部预测环境演化的模型，用于规划 | [6.5](../lectures/lec06.md) |
| 对齐 | alignment | 让系统行为符合人类意图与价值 | [7.2](../lectures/lec07.md) |
| 奖励黑客 | reward hacking | 钻奖励函数的空子而非真正完成任务 | [7.2](../lectures/lec07.md) |
| 期望校准误差 | ECE | 衡量置信度与真实正确率是否一致 | [7.3](../lectures/lec07.md) |
| 物理信息网络 | PINN | 把方程约束写进损失的网络 | [8.4](../lectures/lec08.md) |
| 可微分仿真 | differentiable simulation | 把物理仿真做成可微的，端到端优化 | [8.4](../lectures/lec08.md) |
| 数据并行 | data parallelism | 每卡一份模型、切分数据、同步梯度 | [9.2](../lectures/lec09.md) |
| 张量并行 | tensor parallelism | 把单层权重切到多卡 | [9.3](../lectures/lec09.md) |
| 流水线并行 | pipeline parallelism | 按层切分到多卡，micro-batch 填气泡 | [9.4](../lectures/lec09.md) |
| 混合精度 | mixed precision | FP16/BF16 + 损失缩放降低显存与加速 | [9.5](../lectures/lec09.md) |
| 梯度检查点 | gradient checkpointing | 用重算换显存，不存全部激活 | [9.5](../lectures/lec09.md) |
| 低秩适配 | LoRA | 冻结主干、只训低秩增量 $BA$ | [9.6](../lectures/lec09.md) |
| 参数高效微调 | PEFT | 只训练极少数参数的微调范式 | [9.6](../lectures/lec09.md) |
