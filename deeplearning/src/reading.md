# 延伸阅读地图：课程、论文与开源项目

这一页回答：**「读完这本书之后，往哪儿走？」** 按「**读什么 / 何时读**」组织，分四类：母本与对标课程、体系化教材、交互式与可视化、从零实现与工程实践。每条都给可核查的入口。

::: note 使用纪律
- 链接可达性与热度数据（★）为**调研时点实测值**，会随时间变化；引用时以官方页面为准。
- **先读正文，再读外部**：本节只在你需要「更细的推导 / 更多实现 / 更强直觉」时接手。
- 与[附录 B · 开源项目与工具地图](appendix/resources.md)的分工：本页管「**学**」（课程、书、论文、可视化），附录 B 管「**用**」（框架、库、工具箱）。
:::

## 一、母本与直接对标

| 资料 | 入口 | 读什么 / 何时读 |
|:--|:--|:--|
| **MIT 6.S191《Introduction to Deep Learning》**（母本） | [introtodeeplearning.com](http://introtodeeplearning.com/) ｜ 实验仓库 [github.com/aamini/introtodeeplearning](https://github.com/aamini/introtodeeplearning) | 每讲讲义 PDF 与三个 Lab 的 Notebook；**本教程的九讲顺序与实验题目以它为骨架**。想核对「课程原话」时读它 |
| 本教程的姊妹书（同仓） | [矩阵论](../matrix/index.html) ｜ [数值分析](../numerical/index.html) ｜ [机器人控制技术](../robot/index.html) | 数学基础（矩阵、数值稳定、优化）在别处的系统展开 |

## 二、体系化教材与公开课（按「先读谁」排序）

| 名称 | 入口 | 组织方式与借鉴点 |
|:--|:--|:--|
| ⭐ **《动手学深度学习》(d2l)** | [d2l.ai](https://d2l.ai) ｜ 中文 [zh.d2l.ai](https://zh.d2l.ai) | 约 20 章；每节「导语 → 公式/代码/结果 → 小结 → 练习 → 讨论」+ 每节 Colab 入口。**与本教程结构最接近的对标**，中文术语表与讨论区很实用 |
| **《Understanding Deep Learning》(S. Prince)** | [udlbook.github.io](https://udlbook.github.io/udlbook/) ｜ [代码](https://github.com/udlbook/udlbook) | 21 章、图形直觉优先，**每章配 Jupyter notebook**——「一章一 notebook」是最值得抄的组织方式 |
| **《Deep Learning》(Goodfellow 等)** | [deeplearningbook.org](https://www.deeplearningbook.org) | 术语与定义的权威来源；第 6–8 章（前馈网络、正则化、优化）适合作为第 1 讲的深水区 |
| **fast.ai《Practical Deep Learning for Coders》** | [course.fast.ai](https://course.fast.ai) | **自上而下**：先跑通可用模型再回填原理。与本教程「先直觉后推导」互补，适合动手优先的读者 |
| **斯坦福 CS231n（视觉）** | [cs231n.stanford.edu](http://cs231n.stanford.edu) | 课程笔记（notes）粒度适中，检测/分割/自监督章节可作第 3 讲的外部讲义 |
| **斯坦福 CS224n（NLP）** | [web.stanford.edu/class/cs224n](https://web.stanford.edu/class/cs224n) | 从词向量到 Transformer 的完整推导；第 2 讲的外部对照 |
| **斯坦福 CS336（从零训练语言模型）** | [stanford-cs336.github.io](https://stanford-cs336.github.io) | 作业即实现（分词器、Transformer、GPU kernel、训练、对齐）。**第 6/9 讲与 Lab 3 的硬核支线** |
| **斯坦福 CS25（Transformers United）** | [web.stanford.edu/class/cs25](https://web.stanford.edu/class/cs25) | 客座讲座制，前沿速览；第 6 讲的补充视野 |
| **斯坦福 CS236（生成模型）** | [deepgenerativemodels.github.io](https://deepgenerativemodels.github.io) | 自回归 / flow / VAE / GAN / 能量 / 扩散的完整脉络；**第 4 讲首选外部对照** |
| **斯坦福 CS324（基础模型）** | [stanford-cs324.github.io](https://stanford-cs324.github.io/winter2022/) | 阅读清单驱动的研讨课；第 6、7 讲的参考文献源 |
| **Berkeley CS285（深度 RL）** | [rail.eecs.berkeley.edu/deeprlcourse](https://rail.eecs.berkeley.edu/deeprlcourse/) | 第 5 讲的外部主线；作业用 PyTorch |
| **CMU 11-785** | [deeplearning.cs.cmu.edu](https://deeplearning.cs.cmu.edu) | 「正课 + 习题课 + 自动评分作业」的工程化范本 |
| **NYU Deep Learning (LeCun)** | [atcold.github.io/NYU-DLSP21](https://atcold.github.io/NYU-DLSP21/) | 视频/幻灯片/notebook 三件套同源开源；能量与自监督视角独特 |
| **Hugging Face Courses** | [LLM 课程](https://huggingface.co/learn/llm-course)（[中文版](https://huggingface.co/learn/llm-course/zh-CN/chapter1/1)）｜[扩散课程](https://huggingface.co/learn/diffusion-course)｜[智能体课程](https://huggingface.co/learn/agents-course)｜[深度 RL 课程](https://huggingface.co/learn/deep-rl-course/unit0/introduction) | 章节制 + 可运行 notebook + 结课认证；**中文版是中文读者的第一落点** |
| **PyTorch 官方教程** | [pytorch.org/tutorials](https://pytorch.org/tutorials/) | 分「基础 / Recipes / 专题」；「60 分钟速览」可作 Lab 0 的预习 |
| **Keras 指南** | [keras.io/guides](https://keras.io/guides/) | 按任务域（CV/NLP/生成/RL）组织，代码极短，适合快速出原型 |

## 三、交互式与可视化（建立直觉的第二课堂）

| 资源 | 入口 | 用它做什么 |
|:--|:--|:--|
| ⭐ **3Blue1Brown 神经网络系列** | [3blue1brown.com/topics/neural-networks](https://www.3blue1brown.com/topics/neural-networks) | 第 1 讲的第一遍预习：几何直觉的动画课（含 2024 起新增的注意力与 LLM 专题） |
| ⭐ **TensorFlow Playground** | [playground.tensorflow.org](https://playground.tensorflow.org) | 亲手调层数/激活/学习率/正则，**实时看决策边界**——讲泛化与正则化的最佳教具 |
| **CNN Explainer** | [poloclub.github.io/cnn-explainer](https://poloclub.github.io/cnn-explainer/) | 逐层展开卷积核与特征图；第 3.2 节的视觉化对照 |
| **Transformer Explainer** | [poloclub.github.io/transformer-explainer](https://poloclub.github.io/transformer-explainer/) | 浏览器里跑 GPT-2，看 embedding → 注意力 → MLP；可调 temperature/top-k |
| **Diffusion Explainer** | [poloclub.github.io/diffusion-explainer](https://poloclub.github.io/diffusion-explainer/) | 文生图流水线（文本编码器 → U-Net → VAE）的可视化 |
| **LLM Visualization** | [bbycroft.net/llm](https://bbycroft.net/llm) | 3D 走查 GPT 的权重与数据流；第 2.5 / 6.1 节的空间直觉 |
| **Distill.pub（归档）** | [distill.pub](https://distill.pub) ｜ [特征可视化](https://distill.pub/2017/feature-visualization/) ｜ [ Circuits](https://distill.pub/2020/circuits/) ｜ [动量](https://distill.pub/2017/momentum/) | 「一文一交互」的范式；第 7.3 节机制可解释性的起点 |
| **The Illustrated Transformer** | [jalammar.github.io/illustrated-transformer](https://jalammar.github.io/illustrated-transformer/) | 第 2.5 节的经典图解基线 |
| **Lil'Log（Lilian Weng）** | [lilianweng.github.io](https://lilianweng.github.io) | 综述型长文（注意力/扩散/RLHF/智能体）；第 6、7 讲的延伸 |
| **Sebastian Raschka** | [magazine.sebastianraschka.com](https://magazine.sebastianraschka.com) ｜ [LLMs-from-scratch](https://github.com/rasbt/LLMs-from-scratch) | 「逐章从零实现 LLM」；Lab 3 与 6.1 的循序模板 |
| **MLU-Explain** | [mlu-explain.github.io](https://mlu-explain.github.io) | 一图讲清一个概念（决策树/ROC/网络）的补充卡 |
| **Seeing Theory** | [seeing-theory.brown.edu](https://seeing-theory.brown.edu) | 概率与统计的交互可视化；[先修工具箱](prerequisite.md)的概率部分 |
| **Neural Networks and Deep Learning (Nielsen)** | [neuralnetworksanddeeplearning.com](http://neuralnetworksanddeeplearning.com) | 免费在线、代码可跑；第 3 章「为何深度学习难」值得一读 |

## 四、从零实现（读代码学原理）

| 项目 | 入口 | 适合什么时候读 |
|:--|:--|:--|
| ⭐ **micrograd** | [github.com/karpathy/micrograd](https://github.com/karpathy/micrograd) | 读完 [1.5 反向传播](lectures/lec01/sec15.md) 当天，约百行看懂自动微分 |
| ⭐ **nanoGPT** | [github.com/karpathy/nanoGPT](https://github.com/karpathy/nanoGPT) | 读完 [2.5](lectures/lec02/sec25.md)，看一个能真训的 GPT |
| **minGPT / minbpe / llama2.c / llm.c** | [minGPT](https://github.com/karpathy/minGPT)｜[minbpe](https://github.com/karpathy/minbpe)｜[llama2.c](https://github.com/karpathy/llama2.c)｜[llm.c](https://github.com/karpathy/llm.c) | GPT 实现对照 / 分词器 / 纯 C 推理 / 纯 C 训练 |
| **nanochat** | [github.com/karpathy/nanochat](https://github.com/karpathy/nanochat) | 想要「端到端全栈案例」：分词 → 预训练 → SFT → RL → Web UI |
| **Neural Networks: Zero to Hero** | [karpathy.ai/zero-to-hero.html](https://karpathy.ai/zero-to-hero.html) | 从反向传播一路手写到 GPT 的视频课；**第 1、2 讲的最佳伴读** |
| **LLMs-from-scratch** | [github.com/rasbt/LLMs-from-scratch](https://github.com/rasbt/LLMs-from-scratch) | 逐章实现 GPT → 预训练 → 微调；Lab 3 的配套 |
| **tinygrad** | [github.com/tinygrad/tinygrad](https://github.com/tinygrad/tinygrad) | 想看框架如何生成 kernel、后端如何调度 |
| **tiny-diffusion / minDiffusion** | [tiny-diffusion](https://github.com/tanelp/tiny-diffusion)｜[minDiffusion](https://github.com/cloneofsimo/minDiffusion) | 读完 [4.5 扩散](lectures/lec04/sec45.md)，用几百行看懂加噪与采样 |
| **CleanRL / Spinning Up** | [CleanRL](https://github.com/vwxyzjn/cleanrl)｜[Spinning Up](https://spinningup.openai.com) | 单文件 RL 实现；Spinning Up 是「概念—公式—代码」三件套范本 |
| **dive-into-cv-pytorch** | [github.com/datawhalechina/dive-into-cv-pytorch](https://github.com/datawhalechina/dive-into-cv-pytorch) | 中文 CV 实战（数据管线、检测、分割） |

## 五、工程与框架（成长路线从这里开始）

| 项目 | 入口 | 用到它的地方 |
|:--|:--|:--|
| **Megatron-LM** | [github.com/NVIDIA/Megatron-LM](https://github.com/NVIDIA/Megatron-LM) | 张量并行/流水线并行的工业级参考（[9.3–9.4](lectures/lec09/sec93.md)） |
| **DeepSpeed** | [github.com/microsoft/DeepSpeed](https://github.com/microsoft/DeepSpeed) | ZeRO 分片与显存优化（[9.2](lectures/lec09/sec92.md)、[9.5](lectures/lec09/sec95.md)） |
| **TorchTitan / nanotron** | [torchtitan](https://github.com/pytorch/torchtitan)｜[nanotron](https://github.com/huggingface/nanotron) | 3D 并行的「最小可复现」与「适合通读」两个版本 |
| **LitGPT / axolotl / unsloth** | [litgpt](https://github.com/Lightning-AI/litgpt)｜[axolotl](https://github.com/axolotl-ai-cloud/axolotl)｜[unsloth](https://github.com/unslothai/unsloth) | 微调流水线（Lab 3）；`unsloth` 主打速度与显存 |
| **TRL** | [github.com/huggingface/trl](https://github.com/huggingface/trl) | SFT / DPO / PPO / GRPO 的训练器集合（[5.6](lectures/lec05/sec56.md)） |
| **vLLM / llama.cpp / SGLang** | [vLLM](https://github.com/vllm-project/vllm)｜[llama.cpp](https://github.com/ggml-org/llama.cpp)｜[SGLang](https://github.com/sgl-project/sglang) | 推理与部署：吞吐、KV cache、端侧量化（[6.7](lectures/lec06/sec67.md)） |
| **diffusers** | [github.com/huggingface/diffusers](https://github.com/huggingface/diffusers) | 扩散/流匹配的标准工具箱（[4.5–4.7](lectures/lec04/sec45.md)） |
| **timm** | [github.com/huggingface/pytorch-image-models](https://github.com/huggingface/pytorch-image-models) | 几百个预训练骨干与配方（[3.4–3.6](lectures/lec03/sec34.md)） |
| **lm-evaluation-harness / HELM** | [harness](https://github.com/EleutherAI/lm-evaluation-harness)｜[HELM](https://crfm.stanford.edu/helm/) | 亲手跑一次评测，理解基准的构造与陷阱（[6.7](lectures/lec06/sec67.md)） |
| **HarmBench / JailbreakBench** | [HarmBench](https://github.com/centerforaisafety/HarmBench)｜[JailbreakBench](https://github.com/JailbreakBench/jailbreakbench) | 安全评测与红队（[7.2](lectures/lec07/sec72.md)、[7.5](lectures/lec07/sec75.md)） |

## 六、中文资源（母语读者的加速带）

| 名称 | 入口 | 定位 |
|:--|:--|:--|
| **李沐《动手学深度学习》视频** | [B 站空间](https://space.bilibili.com/1567748478) | d2l 的配套讲解；第 1–3 讲的伴读 |
| **莫烦 Python** | [mofanpy.com](https://mofanpy.com) | 中文入门（图文 + 视频），上手门槛最低 |
| **DataWhale 开源学习路线** | [pumpkin-book](https://github.com/datawhalechina/pumpkin-book)（机器学习公式详解）｜[happy-llm](https://github.com/datawhalechina/happy-llm)｜[self-llm](https://github.com/datawhalechina/self-llm)（大模型部署与微调）｜[llm-universe](https://github.com/datawhalechina/llm-universe)（应用开发）｜[torch-rechub](https://github.com/datawhalechina/torch-rechub)（推荐系统） | 中文社区最成体系的开源教辅，**习题与实操并重** |
| **李宏毅课程笔记（leedl-tutorial）** | [github.com/datawhalechina/leedl-tutorial](https://github.com/datawhalechina/leedl-tutorial) | 中文课程笔记；生成模型与自监督章节讲得透 |
| **Hugging Face 中文课程** | [huggingface.co/learn/llm-course/zh-CN](https://huggingface.co/learn/llm-course/zh-CN/chapter1/1) | 官方中文翻译；LLM 全流程实操 |
| **Microsoft 教学仓库** | [generative-ai-for-beginners](https://github.com/microsoft/generative-ai-for-beginners)｜[ML-For-Beginners](https://github.com/microsoft/ML-For-Beginners)｜[AI-For-Beginners](https://github.com/microsoft/AI-For-Beginners) | 周课程式组织，含多语言翻译；适合做教学设计的参考 |

## 七、按讲次速查（我该往哪讲补资源）

| 讲次 | 首选三家 |
|:--|:--|
| 先修 | [3Blue1Brown](https://www.3blue1brown.com/topics/neural-networks)、[Seeing Theory](https://seeing-theory.brown.edu)、[CS229 讲义](https://cs229.stanford.edu) |
| [第 1 讲](lectures/lec01/overview.md) | [micrograd](https://github.com/karpathy/micrograd)、[TF Playground](https://playground.tensorflow.org)、[d2l 第 3–4 章](https://zh.d2l.ai) |
| [第 2 讲](lectures/lec02/overview.md) | [Transformer Explainer](https://poloclub.github.io/transformer-explainer/)、[CS224n](https://web.stanford.edu/class/cs224n)、[nanoGPT](https://github.com/karpathy/nanoGPT) |
| [第 3 讲](lectures/lec03/overview.md) | [CNN Explainer](https://poloclub.github.io/cnn-explainer/)、[CS231n](http://cs231n.stanford.edu)、[timm](https://github.com/huggingface/pytorch-image-models) |
| [第 4 讲](lectures/lec04/overview.md) | [Diffusion Explainer](https://poloclub.github.io/diffusion-explainer/)、[tiny-diffusion](https://github.com/tanelp/tiny-diffusion)、[CS236](https://deepgenerativemodels.github.io) |
| [第 5 讲](lectures/lec05/overview.md) | [CS285](https://rail.eecs.berkeley.edu/deeprlcourse/)、[Spinning Up](https://spinningup.openai.com)、[CleanRL](https://github.com/vwxyzjn/cleanrl) |
| [第 6 讲](lectures/lec06/overview.md) | [HF LLM 课程（中文）](https://huggingface.co/learn/llm-course/zh-CN/chapter1/1)、[CS336](https://stanford-cs336.github.io)、[nanochat](https://github.com/karpathy/nanochat) |
| [第 7 讲](lectures/lec07/overview.md) | [Distill Circuits](https://distill.pub/2020/circuits/)、[HELM](https://crfm.stanford.edu/helm/)、[HarmBench](https://github.com/centerforaisafety/HarmBench) |
| [第 8 讲](lectures/lec08/overview.md) | [第 8 讲扩展阅读](lectures/lec08/overview.md)（蛋白质/材料/气候各自的专业库） |
| [第 9 讲](lectures/lec09/overview.md) | [Megatron-LM](https://github.com/NVIDIA/Megatron-LM)、[TorchTitan](https://github.com/pytorch/torchtitan)、[llm.c](https://github.com/karpathy/llm.c) |

## 八、一份最小阅读清单（只有两周时按这个顺序）

::: method[core] 两周路线{#reading-plan}
1. **3Blue1Brown 神经网络 4 集**（≈3 小时）——先建立几何直觉；
2. **本教程第 1 讲**（≈4 小时）+ **micrograd 仓库通读**（≈2 小时）——把反向传播焊进脑子；
3. **Transformer Explainer 玩 30 分钟** + **本教程 2.4–2.5**（≈3 小时）+ **nanoGPT 跑通一次小规模训练**（≈3 小时）；
4. **HF LLM 课程（中文）第 1–4 章**（≈6 小时）——把「预训练 → 微调 → 部署」的工具链走一遍；
5. **本教程第 9 讲**（≈3 小时）+ **TorchTitan 的并行示例**（≈2 小时）——知道大模型怎么被切开放进多卡；
6. **跑一次真实评测**（lm-evaluation-harness，≈2 小时）——亲手体会基准分数的脆弱性。

**读完应能做到**：讲清一个 GPT 从数据到部署的全流程，并指出其中三个最容易被高估的环节。
:::

::: note 关于「中文 vs 英文」的选择
中文资源的**第一落点**是 d2l、HF 课程中文版、DataWhale 系列与李沐视频；但**前沿内容的最新表述几乎总是英文**（论文 + 官方文档 + 技术报告）。
实用策略：**概念与实操先读中文，公式与前沿回英文**；遇到术语不一致（如「自注意力」vs self-attention），以[术语索引](review/glossary.md)为准并保留英文原名。
:::
