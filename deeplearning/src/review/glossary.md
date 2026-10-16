# 术语索引（中英对照）

按讲次分组，列出全书核心术语的中英对照、一句话含义与出处。**查阅时用浏览器的页内搜索**（<kbd>⌘F</kbd> / <kbd>Ctrl+F</kbd>）最快；构建后全站还提供术语的悬浮释义。

**收录原则**：只收「读到会卡住」的术语；每条给一句话含义（含关键公式或判据），并指向**首次系统出现**的小节。

## 第 1 讲 · 深度学习导论

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 神经元 | neuron | 加权求和加偏置再过一次非线性：$z=\boldsymbol w^{\mathrm T}\boldsymbol x+b,\ a=\phi(z)$ | [1.1](../lectures/lec01/sec11.md) |
| 感知机 | perceptron | 激活为阶跃的单层线性分类器，只能划分线性可分数据 | [1.1](../lectures/lec01/sec11.md) |
| 线性可分 | linearly separable | 存在超平面把两类完全分开；XOR 是最小反例 | [1.1](../lectures/lec01/sec11.md) |
| 多层感知机 | MLP | 多层「线性 + 非线性」堆叠的前馈网络 | [1.2](../lectures/lec01/sec12.md) |
| 预激活 | pre-activation | 线性变换后、过激活前的量 $\boldsymbol z^{(l)}$ | [1.2](../lectures/lec01/sec12.md) |
| 通用逼近定理 | universal approximation | 足够宽的单隐层可逼近紧集上的连续函数（不含可训练与样本效率保证） | [1.2](../lectures/lec01/sec12.md) |
| 权重初始化 | weight initialization | 按层宽度缩放初始方差（Xavier/Kaiming）以稳住前向与反向信号 | [1.2](../lectures/lec01/sec12.md) |
| 激活函数 | activation function | 提供非线性的逐元素函数；隐藏层默认 ReLU 族 | [1.3](../lectures/lec01/sec13.md) |
| 饱和 | saturation | 激活进入平坦区、导数趋零，导致梯度消失 | [1.3](../lectures/lec01/sec13.md) |
| 交叉熵 | cross-entropy | 分类损失 $-\sum_c y_c\log\hat y_c$；配 softmax 时梯度为 $\hat{\boldsymbol y}-\boldsymbol y$ | [1.4](../lectures/lec01/sec14.md) |
| 均方误差 | MSE | 回归损失，预测与真值之差的平方平均 | [1.4](../lectures/lec01/sec14.md) |
| 最大似然估计 | maximum likelihood | 把损失写成负对数似然，是选择损失函数的统一视角 | [1.4](../lectures/lec01/sec14.md) |
| 梯度下降 | gradient descent | $\theta\leftarrow\theta-\eta\nabla_\theta\mathcal L$ | [1.5](../lectures/lec01/sec15.md) |
| 随机梯度下降 | SGD | 用小批量梯度作为真梯度的无偏估计 | [1.5](../lectures/lec01/sec15.md) |
| 反向传播 | backpropagation | 链式法则的线性时间实现：一次前向 + 一次反向得全部梯度 | [1.5](../lectures/lec01/sec15.md) |
| 计算图 | computation graph | 把前向写成有向图，反向即在图上做反向模式自动微分 | [1.5](../lectures/lec01/sec15.md) |
| 动量 | momentum | 累积历史梯度方向以抑制震荡 | [1.6](../lectures/lec01/sec16.md) |
| Adam | Adam | 一阶 + 二阶动量、逐参数自适应步长的优化器 | [1.6](../lectures/lec01/sec16.md) |
| AdamW | AdamW | 把权重衰减从梯度中解耦的 Adam 变体（现代默认） | [1.6](../lectures/lec01/sec16.md) |
| 学习率调度 | learning rate schedule | warmup / cosine / 阶梯等对学习率随训练变化的安排 | [1.6](../lectures/lec01/sec16.md) |
| 线性缩放规则 | linear scaling rule | 批大小放大 $k$ 倍时学习率同步放大 $k$ 倍（配 warmup） | [1.6](../lectures/lec01/sec16.md) |
| 梯度裁剪 | gradient clipping | 按范数上限缩放梯度，抑制爆炸 | [1.5](../lectures/lec01/sec15.md) |
| 过拟合 | overfitting | 训练损失降、验证损失升（高方差） | [1.7](../lectures/lec01/sec17.md) |
| 欠拟合 | underfitting | 训练与验证都差（高偏置） | [1.7](../lectures/lec01/sec17.md) |
| 正则化 | regularization | 抑制过拟合的手段总和（Dropout、权重衰减、早停、增强、标签平滑） | [1.7](../lectures/lec01/sec17.md) |
| Dropout | dropout | 训练时按概率置零激活，近似集成子网络 | [1.7](../lectures/lec01/sec17.md) |
| 权重衰减 | weight decay | 参数范数惩罚；L2 惩罚与解耦衰减在自适应优化器下不等价 | [1.7](../lectures/lec01/sec17.md) |
| 批归一化 | BatchNorm | 按批维统计的归一化；推理用滑动统计量，依赖批大小 | [1.7](../lectures/lec01/sec17.md) |
| 层归一化 | LayerNorm | 按特征维逐样本归一化，不依赖批大小；Transformer 默认 | [1.7](../lectures/lec01/sec17.md) |
| 双下降 | double descent | 容量继续增大时测试误差再次下降的现象，超出经典偏置-方差图景 | [1.7](../lectures/lec01/sec17.md) |

## 第 2 讲 · 深度序列建模

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 循环神经网络 | RNN | 带隐状态递推、参数沿时间共享的序列模型 | [2.2](../lectures/lec02/sec22.md) |
| 沿时间反向传播 | BPTT | 把 RNN 展开在时间轴上求梯度；连乘导致长程衰减 | [2.2](../lectures/lec02/sec22.md) |
| 梯度消失 | vanishing gradient | 雅可比连乘使远距离梯度指数衰减 | [2.2](../lectures/lec02/sec22.md) |
| 教师强制 | teacher forcing | 训练时用真值作为下一步输入，缓解误差累积 | [2.2](../lectures/lec02/sec22.md) |
| 长短期记忆 | LSTM | 用门控与细胞状态维持梯度通道的门控 RNN | [2.3](../lectures/lec02/sec23.md) |
| 门控循环单元 | GRU | LSTM 的简化版：更新门 + 重置门 | [2.3](../lectures/lec02/sec23.md) |
| 注意力机制 | attention | 对序列任意位置加权聚合，路径长度恒为 1 | [2.4](../lectures/lec02/sec24.md) |
| 查询—键—值 | query-key-value | 用 Q 与 K 算相似度、对 V 加权求和的三元抽象 | [2.4](../lectures/lec02/sec24.md) |
| 缩放点积注意力 | scaled dot-product attention | $\mathrm{softmax}(QK^{\mathrm T}/\sqrt{d_k})V$ | [2.4](../lectures/lec02/sec24.md) |
| 因果掩码 | causal mask | 把未来位置权重置零，保证自回归生成不泄漏未来 | [2.4](../lectures/lec02/sec24.md) |
| 自注意力 | self-attention | Q、K、V 都来自同一序列的注意力 | [2.5](../lectures/lec02/sec25.md) |
| 多头注意力 | multi-head attention | 多组子空间并行注意力，输出拼接后线性变换 | [2.5](../lectures/lec02/sec25.md) |
| Transformer | Transformer | 纯注意力 + 前馈 + 残差/归一化堆叠的架构 | [2.5](../lectures/lec02/sec25.md) |
| 前馈网络层 | feed-forward network | 逐位置的两层 MLP，中间维通常为 $4d$（大模型常换 SwiGLU） | [2.5](../lectures/lec02/sec25.md) |
| 预归一化 | pre-LN | 把归一化放在子层之前，深层训练更稳（现代默认） | [2.5](../lectures/lec02/sec25.md) |
| 位置编码 | positional encoding | 注入顺序信息，破除注意力对置换的等变性 | [2.6](../lectures/lec02/sec26.md) |
| 旋转位置编码 | RoPE | 把位置写成旋转矩阵，使内积只依赖相对位移 | [2.6](../lectures/lec02/sec26.md) |
| 分组查询注意力 | GQA | 多个 Q 头共享少量 KV 头，按比例削减 KV cache | [2.6](../lectures/lec02/sec26.md) |
| KV 缓存 | KV cache | 推理时缓存历史键值避免重算；显存随序列长线性增长 | [2.6](../lectures/lec02/sec26.md) |
| 闪存注意力 | FlashAttention | IO 感知的分块精确注意力，显存 $O(T)$ 而 FLOPs 不变 | [2.6](../lectures/lec02/sec26.md) |
| 状态空间模型 | SSM | 用线性递推与并行扫描建模序列，复杂度线性（Mamba 系） | [2.7](../lectures/lec02/sec27.md) |
| 混合专家 | MoE | 每 token 只激活 top-k 专家，总参数大而计算量近似不变 | [2.7](../lectures/lec02/sec27.md) |
| 温度采样 | temperature sampling | 缩放 logits 调节生成分布平坦程度 | [2.8](../lectures/lec02/sec28.md) |

## 第 3 讲 · 深度计算机视觉

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 归纳偏置 | inductive bias | 架构内置的先验假设（局部性、平移等变、对称性） | [3.1](../lectures/lec03/sec31.md) |
| 互相关 | cross-correlation | 深度学习常说的「卷积」实际是互相关（不翻转核） | [3.2](../lectures/lec03/sec32.md) |
| 步幅 | stride | 滑动步长，直接决定输出尺寸与下采样倍率 | [3.2](../lectures/lec03/sec32.md) |
| 填充 | padding | 边界补零，控制尺寸与边界信息利用 | [3.2](../lectures/lec03/sec32.md) |
| 感受野 | receptive field | 输出单元能「看到」的输入区域；逐层递推 | [3.2](../lectures/lec03/sec32.md) |
| 池化 | pooling | 固定规则的降采样（最大/平均），现代常被步幅卷积替代 | [3.3](../lectures/lec03/sec33.md) |
| 残差连接 | residual connection | $\boldsymbol y=\boldsymbol x+\mathcal F(\boldsymbol x)$，梯度含恒等项 | [3.4](../lectures/lec03/sec34.md) |
| 退化问题 | degradation problem | 深层网络训练误差反而变差，可由残差结构缓解 | [3.4](../lectures/lec03/sec34.md) |
| 瓶颈结构 | bottleneck | 用 $1\times1$ 降维再升维，降低计算量 | [3.4](../lectures/lec03/sec34.md) |
| 视觉 Transformer | ViT | 图像切 patch 当 token 的注意力架构，数据饥渴但可扩展 | [3.5](../lectures/lec03/sec35.md) |
| 迁移学习 | transfer learning | 复用预训练骨干，再按数据量选择冻结或微调 | [3.6](../lectures/lec03/sec36.md) |
| 对比学习 | contrastive learning | 拉近正样本、推远负样本（InfoNCE）以学表征 | [3.6](../lectures/lec03/sec36.md) |
| 掩码自编码 | masked autoencoder | 遮住部分输入再重建，做自监督预训练 | [3.6](../lectures/lec03/sec36.md) |
| 交并比 | IoU | 预测框与真值框的重叠程度，检测的匹配与评估基础 | [3.7](../lectures/lec03/sec37.md) |
| 非极大值抑制 | NMS | 按置信度去重相邻框 | [3.7](../lectures/lec03/sec37.md) |
| 平均精度 | mAP | 按 IoU 阈值与类别平均的检测指标 | [3.7](../lectures/lec03/sec37.md) |
| 提示式分割 | promptable segmentation | 用点/框/文本提示生成掩码（SAM 范式） | [3.7](../lectures/lec03/sec37.md) |
| 对抗样本 | adversarial example | 微小扰动即可翻转预测（FGSM/PGD） | [3.9](../lectures/lec03/sec39.md) |
| 数据集偏见 | dataset bias | 数据分布偏差被模型放大，导致群体性误判 | [3.9](../lectures/lec03/sec39.md) |

## 第 4 讲 · 深度生成建模

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 生成建模 | generative modeling | 学数据分布以采样新样本，而非只做判别 | [4.1](../lectures/lec04/sec41.md) |
| 自编码器 | autoencoder | 编码-解码重建；潜空间无先验，**不能**直接当生成模型 | [4.2](../lectures/lec04/sec42.md) |
| 变分自编码器 | VAE | 用变分下界同时学编码分布与解码器 | [4.3](../lectures/lec04/sec43.md) |
| 证据下界 | ELBO | 重建项减 KL 正则项，是 $\log p(x)$ 的下界 | [4.3](../lectures/lec04/sec43.md) |
| 重参数化技巧 | reparameterization trick | $z=\mu+\sigma\odot\varepsilon$，把采样随机性移出可导路径 | [4.3](../lectures/lec04/sec43.md) |
| 后验坍塌 | posterior collapse | KL 项过强使潜变量不携带信息，解码退化 | [4.3](../lectures/lec04/sec43.md) |
| 生成对抗网络 | GAN | 生成器与判别器的极小极大博弈 | [4.4](../lectures/lec04/sec44.md) |
| 模式坍塌 | mode collapse | 生成器只覆盖少数模式 | [4.4](../lectures/lec04/sec44.md) |
| 扩散模型 | diffusion model | 逐步加噪再学反向去噪，训练目标为噪声预测 | [4.5](../lectures/lec04/sec45.md) |
| 无分类器引导 | classifier-free guidance | 有条件与无条件预测的线性外推，权衡贴合度与多样性 | [4.5](../lectures/lec04/sec45.md) |
| 潜空间扩散 | latent diffusion | 在 VAE 潜空间做扩散，大幅降低计算 | [4.6](../lectures/lec04/sec46.md) |
| 一致性模型 | consistency model | 学「任意噪声到原图」的一步映射，实现少步采样 | [4.6](../lectures/lec04/sec46.md) |
| 整流流 | rectified flow | 学直线速度场，采样步数降到 1–4 步 | [4.6](../lectures/lec04/sec46.md) |
| 向量量化 | VQ | 把连续潜变量映射到代码本，接口对接自回归生成 | [4.7](../lectures/lec04/sec47.md) |
| 尺度自回归 | next-scale prediction | 逐尺度预测更清晰图像（VAR），复用 LLM 式扩展律 | [4.7](../lectures/lec04/sec47.md) |

## 第 5 讲 · 深度强化学习

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 马尔可夫决策过程 | MDP | $(S,A,P,R,\gamma)$：状态、动作、转移、奖励、折扣 | [5.2](../lectures/lec05/sec52.md) |
| 回报 | return | $G_t=\sum\gamma^k r_{t+k}$，折扣累积奖励 | [5.2](../lectures/lec05/sec52.md) |
| 状态值函数 | state value function | 从状态出发按策略 $\pi$ 的期望回报 $V^\pi(s)$ | [5.2](../lectures/lec05/sec52.md) |
| 动作值函数 | action value function | $Q^\pi(s,a)$，用于比较动作优劣 | [5.2](../lectures/lec05/sec52.md) |
| 贝尔曼方程 | Bellman equation | 值与「即时奖励 + 折扣后继值」的递归关系 | [5.2](../lectures/lec05/sec52.md) |
| 时序差分 | temporal difference | 用自举目标估计值函数，$r+\gamma V(s')-V(s)$ | [5.3](../lectures/lec05/sec53.md) |
| 经验回放 | experience replay | 存历史转移、随机采样打破时序相关 | [5.3](../lectures/lec05/sec53.md) |
| 目标网络 | target network | 冻结一份参数计算 TD 目标，稳定训练 | [5.3](../lectures/lec05/sec53.md) |
| 策略梯度 | policy gradient | $\nabla J=\mathbb E[\nabla\log\pi\,A]$，直接优化策略参数 | [5.4](../lectures/lec05/sec54.md) |
| 优势函数 | advantage function | $A=Q-V$：动作比平均水平好多少 | [5.5](../lectures/lec05/sec55.md) |
| 广义优势估计 | GAE | 用 $\lambda$ 在偏差与方差间折中估计优势 | [5.5](../lectures/lec05/sec55.md) |
| 近端策略优化 | PPO | 用裁剪目标限制策略更新幅度的 Actor-Critic 方法 | [5.5](../lectures/lec05/sec55.md) |
| 离线强化学习 | offline RL | 只用固定数据集学习策略，面临分布偏移 | [5.6](../lectures/lec05/sec56.md) |
| 人类反馈强化学习 | RLHF | SFT → 奖励模型 → PPO 的三步对齐流程 | [5.6](../lectures/lec05/sec56.md) |
| 直接偏好优化 | DPO | 用成对偏好直接优化策略，省去奖励模型与在线采样 | [5.6](../lectures/lec05/sec56.md) |
| 奖励黑客 | reward hacking | 代理奖励上升而真实目标变差（Goodhart 效应） | [5.6](../lectures/lec05/sec56.md) |

## 第 6 讲 · 新前沿

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 自监督语言建模 | self-supervised language modeling | 用下一个 token 预测作训练信号 | [6.1](../lectures/lec06/sec61.md) |
| 字节对编码 | BPE | 从语料统计合并高频符号对的分词算法 | [6.1](../lectures/lec06/sec61.md) |
| 监督微调 | supervised fine-tuning | 用指令-回答数据对齐输出格式与任务行为 | [6.1](../lectures/lec06/sec61.md) |
| 缩放律 | scaling law | 损失随参数/数据/算力的幂律关系，指导资源分配 | [6.2](../lectures/lec06/sec62.md) |
| 涌现能力 | emergent ability | 「规模跨阈值后能力突现」的主张；其**度量方式**存在争议 | [6.2](../lectures/lec06/sec62.md) |
| 上下文学习 | in-context learning | 不改权重、仅靠提示示例完成新任务 | [6.3](../lectures/lec06/sec63.md) |
| 思维链 | chain-of-thought | 让模型显式输出中间推理步骤以提升复杂任务表现 | [6.3](../lectures/lec06/sec63.md) |
| 测试时计算 | test-time compute | 推理期增加采样/搜索/验证以换准确率 | [6.3](../lectures/lec06/sec63.md) |
| 过程奖励模型 | process reward model | 对中间步骤给奖励，而非只评最终答案 | [6.3](../lectures/lec06/sec63.md) |
| 对比语言图像预训练 | CLIP | 图文对比学习得到可迁移的跨模态表征 | [6.4](../lectures/lec06/sec64.md) |
| 视觉语言模型 | VLM | 视觉编码器 + 连接器 + 语言模型的组合架构 | [6.4](../lectures/lec06/sec64.md) |
| 视觉—语言—动作模型 | VLA | 把「画面 + 指令」映射到动作的策略（RT-2/OpenVLA/π0） | [6.5](../lectures/lec06/sec65.md) |
| 扩散策略 | diffusion policy | 用扩散/流匹配建模动作多模态分布 | [6.5](../lectures/lec06/sec65.md) |
| 智能体 | agent | 能规划、调用工具、按观察更新计划的系统 | [6.6](../lectures/lec06/sec66.md) |
| 世界模型 | world model | 在潜空间预测环境动力学，供「想象」中训练 | [6.6](../lectures/lec06/sec66.md) |
| 基准污染 | benchmark contamination | 测试数据泄入训练导致分数虚高 | [6.7](../lectures/lec06/sec67.md) |

## 第 7 讲 · AI 的三条法则

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 对齐 | alignment | 让系统行为符合人类意图与规范的三层工作（目标/行为/监控） | [7.2](../lectures/lec07/sec72.md) |
| 越狱 | jailbreak | 用对抗提示绕过安全约束 | [7.2](../lectures/lec07/sec72.md) |
| 红队 | red teaming | 系统性地寻找失效与滥用路径 | [7.5](../lectures/lec07/sec75.md) |
| 规范博弈 | specification gaming | 精确满足字面目标却违背本意的行为 | [7.2](../lectures/lec07/sec72.md) |
| 机制可解释性 | mechanistic interpretability | 在权重与激活中找可命名的回路与特征 | [7.3](../lectures/lec07/sec73.md) |
| 稀疏自编码器 | sparse autoencoder | 用稀疏瓶颈把叠加激活分解为可解释特征 | [7.3](../lectures/lec07/sec73.md) |
| 激活引导 | activation steering | 推理时加减一个「概念方向」改变行为，不改权重 | [7.3](../lectures/lec07/sec73.md) |
| 幻觉 | hallucination | 生成看似合理但事实错误的内容 | [7.3](../lectures/lec07/sec73.md) |
| 校准 | calibration | 置信度与正确率一致的属性（ECE 度量） | [7.3](../lectures/lec07/sec73.md) |
| 机器遗忘 | unlearning | 从模型中去掉指定数据影响的技术 | [7.3](../lectures/lec07/sec73.md) |
| 公平性度量 | fairness metrics | 人口统计均等/机会均等/预测均等，一般不可同时满足 | [7.4](../lectures/lec07/sec74.md) |
| 威胁模型 | threat model | 明确目标、能力假设、攻击面与残余风险 | [7.5](../lectures/lec07/sec75.md) |

## 第 8 讲 · AI for Science

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 等变网络 | equivariant network | 把对称性写进架构：$f(Rx)=Rf(x)$ | [8.2](../lectures/lec08/sec82.md) |
| 蛋白质语言模型 | protein language model | 在序列上做掩码建模，学出结构与功能信息 | [8.2](../lectures/lec08/sec82.md) |
| 机器学习势函数 | machine-learned potential | 拟合能量面替代第一性原理计算，快数个量级 | [8.3](../lectures/lec08/sec83.md) |
| 生成式材料设计 | generative materials design | 按目标性质反向搜索/生成候选结构 | [8.3](../lectures/lec08/sec83.md) |
| 神经算子 | neural operator | 学「函数到函数」的映射，可跨分辨率泛化 | [8.4](../lectures/lec08/sec84.md) |
| 物理信息神经网络 | PINN | 把 PDE 残差写进损失，用数据 + 物理联合训练 | [8.4](../lectures/lec08/sec84.md) |
| 可微分仿真 | differentiable simulation | 让仿真可回传梯度，用于反演与联合优化 | [8.4](../lectures/lec08/sec84.md) |
| 自回归预报 | autoregressive forecasting | 多步展开预测，误差累积是主要难点 | [8.5](../lectures/lec08/sec85.md) |

## 第 9 讲 · 大规模并行训练

| 中文 | English | 一句话 | 出处 |
|:--|:--|:--|:--|
| 显存五账单 | memory budget | 参数 + 梯度 + 优化器状态 + 主权重 + 激活；混合精度 Adam ≈ $16N$ | [9.1](../lectures/lec09/sec91.md) |
| 数据并行 | data parallelism | 每卡全量副本、切分数据、All-Reduce 同步梯度 | [9.2](../lectures/lec09/sec92.md) |
| 零冗余优化器 | ZeRO | 优化器状态/梯度/参数逐级分片以省显存 | [9.2](../lectures/lec09/sec92.md) |
| 全分片数据并行 | FSDP | PyTorch 的逐层 all-gather + reduce-scatter 分片实现 | [9.2](../lectures/lec09/sec92.md) |
| 张量并行 | tensor parallelism | 层内切矩阵（列并行/行并行），通信密集 | [9.3](../lectures/lec09/sec93.md) |
| 流水线并行 | pipeline parallelism | 按层切段 + micro-batch 流水；代价是气泡 | [9.4](../lectures/lec09/sec94.md) |
| 气泡 | pipeline bubble | 流水线启动/排空的空闲时间，占比 $\approx\frac{P-1}{M+P-1}$ | [9.4](../lectures/lec09/sec94.md) |
| 混合精度 | mixed precision | 低精度计算 + 高精度主权重；fp16 需 loss scaling，bf16 通常不需要 | [9.5](../lectures/lec09/sec95.md) |
| 激活重计算 | activation recomputation | 不存中间激活、反向重算，以算力换显存 | [9.5](../lectures/lec09/sec95.md) |
| 低秩适配 | LoRA | 冻结基座只训 $BA$ 低秩增量，显存与存储都省 | [9.5](../lectures/lec09/sec95.md) |
| 量化微调 | QLoRA | 4-bit 量化基座 + LoRA，使大模型单卡可微调 | [9.5](../lectures/lec09/sec95.md) |
| 序列并行 | sequence parallelism | 沿序列维切分激活与计算，配合 TP/CP 支撑长上下文 | [9.6](../lectures/lec09/sec96.md) |
| 计算通信重叠 | compute-communication overlap | 用分块/异步/双缓冲把通信藏在计算后面 | [9.6](../lectures/lec09/sec96.md) |
| 分片检查点 | sharded checkpoint | 并行分片保存与恢复，支撑万卡级容错 | [9.6](../lectures/lec09/sec96.md) |

::: note 术语使用的三条纪律
1. **首次出现给英文原名**（如「旋转位置编码（RoPE）」），此后可只用中文或缩写。
2. **同一概念全书只用一个译名**；遇到社区多译名时，以本表为准并保留英文。
3. 术语的**一句话**尽量写成「判据」而非「描述」——能拿来判断的才值得背（例如「KV cache 显存随序列长线性增长」）。
:::
