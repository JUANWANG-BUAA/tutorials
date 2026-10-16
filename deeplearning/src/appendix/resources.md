# 附录 B · 开源项目与工具地图

这张地图回答一个问题：**「想动手时，从哪里开始？」** 九讲的正讲给原理，三个 Lab 给一次完整流程，而真实的工程能力来自读代码、跑代码、改代码。下面按「用途」而不是「知名度」分组，每条给出**仓库/项目名 + 一句话用途 + 对应哪一讲**。

::: note 使用纪律
- 项目名与仓库地址以官方页面为准；活跃项目迭代快，**版本与接口以你安装时的文档为准**。
- 每组的顺序是「从教学到生产」：先拿小的读透，再上工业级工具。
- ⭐ 标记的是**最适合作为第一站**的项目（体量小、能在一两天内读完主流程）。
:::

## 一、从零实现（读代码学原理的第一站）

| 项目 | 一句话 | 体量 | 对应讲次 |
|:--|:--|:--|:--|
| ⭐ **micrograd** | 100 行左右的自动微分引擎（标量版反向传播），Karpathy 的脚手架 | 极小 | 1.5 反向传播 |
| ⭐ **nanoGPT** | 一个文件级的 GPT 训练/采样脚本（含 data prep），读它就懂 GPT 的工程骨架 | 小 | 2.5 Transformer、6.1 |
| **minGPT** | 同一作者的更教材化实现，带大量注释 | 小 | 2.5 |
| **minbpe** | BPE 分词器的最小实现（含 GPT-2/GPT-4 两类规则） | 极小 | 6.1 tokenizer |
| **llama2.c** | 用纯 C 跑 Llama 2 推理，理解推理期数据流与内存 | 小 | 2.5、9.6 |
| **llm.c** | 用 C/CUDA 从零训练 GPT-2，看底层算子与优化 | 中 | 9.5、9.6 |
| **nanochat** | 「全栈」小规模 ChatGPT 复现（预训练 → SFT → RL 一条龙） | 中 | 6.1、5.6 |
| **tinygrad** | 极简张量框架，理解框架与编译器如何生成 kernel | 中 | 1.5、9.6 |
| **TinyStories** | 用合成小故事训练小模型，研究「数据质量决定能力」 | 小 | 6.1、6.2 |

**读法建议**：先跑通，再删代码——**删除法**（把某一部分换成恒等操作，看结果怎么坏）是理解实现最快的路径。

## 二、训练框架与大规模并行

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| **PyTorch** + `torch.distributed` | 默认底座：DDP / FSDP / `pipelining` / `checkpoint` | 9.2–9.5 |
| **Megatron-LM**（NVIDIA） | 工业级张量并行/流水线并行参考实现，TP/PP/SP 的教科书 | 9.3、9.4 |
| **DeepSpeed**（Microsoft） | ZeRO 三阶段与 MoE 训练；ZeRO-Offload / ZeRO-Infinity | 9.2、9.5 |
| **TorchTitan** | PyTorch 官方「最小可复现」大模型训练栈（含 3D 并行示例） | 9.2–9.6 |
| **nanotron**（Hugging Face） | 轻量 3D 并行训练库，代码量适中、适合读 | 9.3–9.6 |
| **LitGPT**（Lightning AI） | 开源 LLM 的「配方集合」：预训练/微调/部署一条龙 | 6.1、9.7 |
| **LLaMA-Factory** | 一站式微调工具箱（界面友好，适合快速实验） | 9.7、Lab 3 |
| **colossalai** | 多种并行与显存优化策略的实验平台 | 9.5 |

**读代码的顺序建议**：`TorchTitan`（结构清晰）→ `nanotron`（并行细节）→ `Megatron-LM`（工业级复杂度）。

## 三、微调与参数高效方法（PEFT）

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| ⭐ **peft**（Hugging Face） | LoRA / DoRA / Prefix Tuning 等 PEFT 方法的标准实现 | 9.5、Lab 3 |
| **TRL** | SFT / DPO / PPO / GRPO 的训练器集合（对齐实验首选） | 5.6、6.1 |
| **Unsloth** | 单卡微调的速度与显存优化（LoRA 加速） | 9.5 |
| **Axolotl** | 配置驱动的微调框架（YAML 一次跑通多任务） | 9.7 |
| **bitsandbytes** | 8-bit 优化器与 4-bit 量化（QLoRA 的组件之一） | 9.5 |
| **OpenRLHF / verl** | 大规模 RLHF 训练框架（PPO/GRPO 工程化） | 5.6、6.3 |

## 四、推理、部署与服务化

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| ⭐ **llama.cpp** | CPU/GPU 混合推理的事实标准（GGUF 量化格式） | 2.5、9.5 |
| **vLLM** | 高吞吐服务引擎（PagedAttention 管理 KV cache） | 2.6、9.6 |
| **SGLang** | 结构化生成与高并发服务（RadixAttention） | 6.6 |
| **Ollama** | 本地一键跑模型（打包 llama.cpp） | 工程入门 |
| **TensorRT-LLM** | NVIDIA 的极致推理优化（FP8/INT4、图优化） | 9.5 |
| **MInference / H2O 一类 KV 压缩实现** | 长上下文推理的显存压缩 | 2.6 |

## 五、生成模型

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| ⭐ **diffusers**（Hugging Face） | 扩散/流匹配模型的标准库（含训练与推理脚本） | 4.5–4.7 |
| **ComfyUI** | 节点式生成工作流（理解条件控制、ControlNet 的好工具） | 4.8 |
| **tiny-diffusion / minDiffusion** | 教学级扩散实现，几百行看懂加噪与采样 | 4.5 |
| **consistency_models** | 一致性模型官方实现（少步采样） | 4.6 |
| **FSQ / VQ 相关实现** | 离散潜码与自回归生成的部件 | 4.7 |

## 六、强化学习（含 RLHF 底座）

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| ⭐ **CleanRL** | 单文件实现的 PPO/DQN/SAC（读一遍胜过读十篇博客） | 5.3–5.5 |
| **Stable-Baselines3** | 稳定可靠的 RL 算法库（适合做对照实验） | 5.5 |
| **Gymnasium** | 环境接口标准（CartPole、Atari 等） | 5.1、5.7 |
| **Tianshou / Dopamine** | 研究向 RL 框架 | 5.3–5.5 |
| **LeRobot**（Hugging Face） | 机器人数据与策略库（含模仿学习与扩散策略） | 6.5 |

## 七、视觉与多模态

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| ⭐ **timm** | 预训练骨干的「军火库」（几百个模型与训练配方） | 3.4–3.6 |
| **detectron2 / MMDetection** | 检测与分割的工业级工具箱 | 3.7 |
| **Ultralytics（YOLO 系列）** | 开箱即用的检测/分割/姿态 | 3.7、Lab 2 |
| **segment-anything**（SAM 系列） | 提示式分割范式 | 3.7 |
| **open_clip** | CLIP 类对比预训练的开源实现 | 3.8 |
| **LLaVA / InternVL / Qwen-VL** | 视觉语言模型的训练与推理实现 | 3.8、6.4 |
| **OpenVLA / openpi** | VLA 的开源实现与权重 | 6.5 |

## 八、可解释性与安全工具

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| **Captum** | 归因方法集合（Grad-CAM、Integrated Gradients 等） | 7.3 |
| **TransformerLens** | 机制可解释性工具箱（激活与回路的探查） | 7.3 |
| **SAELens** | 稀疏自编码器训练与特征分析 | 7.3 |
| **torchattacks / ART** | 对抗攻击与防御的实现集合 | 3.9、7.2 |
| **HarmBench / JailbreakBench** | 越狱与有害行为评测集 | 7.2、7.5 |

## 九、数据、评测与实验管理

| 项目 | 一句话 | 对应讲次 |
|:--|:--|:--|
| **datatrove** | 大规模文本清洗、去重与过滤管线 | 6.1 |
| **lm-evaluation-harness** | 语言模型基准评测的事实标准 | 6.7 |
| **HELM** | 多场景全景评测（不只单一分数） | 6.7 |
| **SWE-bench** | 真实软件工程任务评测（issue → 补丁） | 6.6、6.7 |
| **W&B / MLflow / TensorBoard** | 实验追踪与可视化 | [工具箱](../toolbox.md) |
| **Hydra / DVC** | 配置管理与数据版本控制 | [工具箱](../toolbox.md) |

## 十、可视化与交互式教学（建立直觉的第二课堂）

| 资源 | 一句话 | 对应讲次 |
|:--|:--|:--|
| **TensorFlow Playground** | 浏览器里手调网络看决策边界（培养手感最快） | 1.1–1.2 |
| **CNN Explainer** | 卷积逐层可视化的交互页 | 3.2 |
| **Transformer Explainer** | 自注意力与生成过程的可视化 | 2.5 |
| **LLM Visualization**（bbycroft.net） | 3D 解剖 GPT 的推理数据流 | 2.5、6.1 |
| **Distill.pub** | 高质量可交互论文（特征可视化、动量、电路） | 1.6、3.9、7.4 |
| **3Blue1Brown 神经网络系列** | 几何直觉的动画课 | 1.1–1.6 |
| **Karpathy《Neural Networks: Zero to Hero》** | 从 micrograd 一路手写到 GPT 的视频课 | 1.5、2.5 |

## 十一、选型速查：我要做 X，用什么？

::: method 十条选型建议{#resources-choose}
1. **想理解原理** → micrograd / tiny-diffusion / CleanRL：读小仓库，胜过读十篇讲解。
2. **想复现 GPT** → nanoGPT → nanotorch/nanotron：先在单卡跑通，再考虑并行。
3. **想微调开源模型** → peft + trl（或 LLaMA-Factory）：先 LoRA，再考虑全参。
4. **想做对齐实验** → trl（DPO 最简单）→ OpenRLHF/verl（要规模时）。
5. **想部署** → llama.cpp（本地）→ vLLM（服务）。
6. **想做视觉业务** → timm 骨干 + Ultralytics/detectron2；先迁移学习，别从零训。
7. **想做生成应用** → diffusers + ComfyUI 摸清条件控制；定制用 LoRA。
8. **想做 RL** → Gymnasium + CleanRL/Stable-Baselines3；先小环境跑通再看算法细节。
9. **想做大模型训练** → TorchTitan/nanotron 起步，读 Llama 3 / DeepSeek-V3 技术报告对照。
10. **想保证结论可信** → lm-evaluation-harness + 多种子 + 污染检查（[6.7](../lectures/lec06/sec67.md)）。
:::

::: errata 三条容易踩的坑
1. **先学框架后学原理**：框架封装会掩盖关键细节（例如 `CrossEntropyLoss` 里的 softmax）。**先手写一遍，再用库**。
2. **拿工业级代码当教材**：Megatron-LM 的复杂度是为规模服务的；直接读它学 Transformer 会被工程细节淹没。
3. **追最新仓库而忽视基线**：项目星数不等于适配你的场景；选型的判据永远是「数据规模 / 算力 / 延迟要求 / 维护成本」，见[工具箱](../toolbox.md)。
:::

**与延伸阅读的分工**：本页管「**用什么代码**」；[延伸阅读地图](../reading.md)管「**读什么课、什么书、什么论文**」；[附录 A](roadmap.md)管「**怎么从这些资源走向研究选题**」。
