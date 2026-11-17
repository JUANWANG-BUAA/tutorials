# Lab 3 · 微调一个大语言模型

本实验对应第 6、9 讲：加载一个预训练语言模型，用参数高效微调（LoRA）在受限显存下将它适配到下游任务，再用自回归采样评估输出。这是在小算力条件下微调大模型的标准流程。

## 决策前置：在显存约束下规划实验

假设单卡标称 **12 GB = 12 × 10⁹ 字节**（约 11.18 GiB，1 GiB = 2³⁰ 字节）；系统占用和其他进程会减少实际可用量。先记录实际 GPU、驱动、CUDA、PyTorch、transformers、PEFT 及优化器包版本、可用显存。基础任务是指令—回答微调；参考官方 LFM2-1.2B，若放不下或不兼容，可换实际能运行的因果语言模型，并记录名称、版本与原因。

训练前固定数据来源、随机种子和互不重叠的训练/验证/测试划分，保存样本 ID、分组规则与划分文件；所有组使用相同划分、分词、截断、response mask 与留出问题。验证集用于训练过程诊断，测试集在配置、比较方向和终点冻结后统一评估，不按测试结果调参。先填写表中的选择、理由和估算，再运行实验，填入实测结果：

| 决策 | 选择与理由 | 估算 | 实测及口径 |
|:--|:--|:--|:--|
| 基座、精度或量化 | ______ | 权重 ______ GB | 名称/版本、实际精度 ______ |
| LoRA 目标矩阵、rank、alpha、dropout | ______ | 可训参数 ______ | `print_trainable_parameters()` ______ |
| 优化器、学习率、warmup/schedule | ______ | 训练时长 ______ s | ______ s |
| micro-batch、累积、设备数 | ______ | 有效批量 ______ 样本 | 有效监督 token ______ |
| 训练峰值 | ______ | ______ GB，列出假设 | ______ GB，采集方法 ______ |
| 固定生成任务延迟 | 输入/输出长度和解码 ______ | ______ ms，写依据 | ______ ms |
| 留出指标及方向 | ______ | 不必预言数值 | 基座 ______；微调后 ______ |

对于线性层 $W\in\mathbb R^{out\times in}$，LoRA 的 $A\in\mathbb R^{r\times in}$、$B\in\mathbb R^{out\times r}$，故新增 $r(in+out)$ 个参数；对实际被替换的每个矩阵求和，矩阵大小、层数和共享权重以模型为准。若训练 bias 或其他模块，另加其参数。比如假设一个 $4096\times4096$ 矩阵、$r=8$，新增 $8(4096+4096)=65536$ 个参数；这只是算术例子，不是某模型的结构。

预算以字节计算：权重参数数 × 每参数字节数，加可训参数、梯度和优化器状态，再估计激活、临时工作区、量化元数据与分配器开销；不要将推理 KV cache 默认计入关闭缓存的训练。量化格式和混合精度的状态字节数依实现而定。全参对比可在 FP32 参数、梯度及 Adam 两个 FP32 矩的假设下用 $16N$ 字节，LoRA 则冻结基座，只为可训参数计梯度和状态；两者都另计激活和临时内存。预估难以覆盖所有实现细节，不设误差门槛，解释差异即可。

候选 rank 为 8、16、32；其中必做实验使用下文的 $r\in\{8,16\}$ 完整四格设计，32 留给扩展。Lion 的 `3e-5` 和 AdamW 的 `1e-4` 是各自需要实测的起点，不等效，也不存在通用固定换算。单卡有效批量 = micro-batch × 梯度累积步数；候选 micro-batch 1、2、4 可分别配累积 16、8、4 得到 16 样本。实际 token 数仍受长度和掩码影响；累积时按损失归一化正确处理最后不足一组的 micro-batch。

先用同一个假想的 $4096\times4096$ 目标矩阵比较秩；真实模型需要把全部目标矩阵逐一算入。

| rank $r$ | 单矩阵新增参数 | 与 $r=8$ 对比 |
|:--|--:|:--|
| 8 | 65,536 | 基准 |
| 16 | 131,072 | 2 倍 |
| 32 | 262,144 | 4 倍 |

标准 LoRA 的增量为 $\Delta W=(\alpha/r)BA$。固定 $\alpha$ 扫 rank 会同时改变容量与缩放，不能把差异单独归因于容量。本实验必须交叉改变 rank 与 $s=\alpha/r$，而非把恒定缩放作为选做消融。即使固定 $s$，改变 rank 仍会改变参数化、初始化分布和优化轨迹；下文的“容量比较”是控制显式缩放后的 rank 干预，不是对纯表达能力的因果证明。

| 优化器 | 学习率候选 | 比较时记录 |
|:--|:--|:--|
| Lion | $3\times10^{-5}$ | 实际实现、schedule、训练和验证曲线 |
| AdamW | $10^{-4}$ | 同上；该学习率不与 Lion 等效 |

| micro-batch | 累积步数 | 单卡有效批量 | 需实测的代价 |
|--:|--:|--:|:--|
| 1 | 16 | 16 | 峰值显存、耗时、有效 token |
| 2 | 8 | 16 | 同上 |
| 4 | 4 | 16 | 同上 |

有效批量相同不保证梯度完全相同：序列长度、损失归一化、随机性及最后一个不完整累积组都会影响结果。

---

## 1. 环境与模型

- **库与母本**：`transformers` + `peft`。官方 2026 年笔记本是 [MITDeepLearning/introtodeeplearning · `lab3/LLM_Finetuning.ipynb`](https://github.com/MITDeepLearning/introtodeeplearning/blob/master/lab3/LLM_Finetuning.ipynb)，没有单独的 TensorFlow 版。开始时保存所用 notebook 的 commit 与本地修改；下文四格实验、数据划分与统计要求是**本书扩展**，不是 MIT 官方的原有评分要求。
- **基座模型**：笔记本以 Liquid AI 的 **LFM2-1.2B** 为例（它自己写的量级是约十亿参数），权重 ID 为 [`LiquidAI/LFM2-1.2B`](https://huggingface.co/LiquidAI/LFM2-1.2B)。本书不要求你用同一权重；可用更小的 [`Qwen/Qwen2.5-0.5B`](https://huggingface.co/Qwen/Qwen2.5-0.5B) 作为本书实验的替代基座。下载前查看模型卡、许可及版本依赖，记录模型和 tokenizer 的解析后 revision；四格必须使用同一基座，不能把不同模型的结果混入对比。换模型时，`target_modules` 的名字会变，以 `model.named_modules()` 为准，不要照抄字符串。
- **数据**：官方示例学习文风；本书四格实验可选 [`databricks/databricks-dolly-15k`](https://huggingface.co/datasets/databricks/databricks-dolly-15k)，将 `instruction`、`context`、`response` 映射为指令、输入、回答，保存数据 revision、许可和原始行 ID。它不是官方笔记本数据的替代事实，也不是客观正确性的金标准。也可使用有来源的同类小数据集，但四格必须一致。格式通常是：

```text
<instruction> 把下面这句话翻译成英文。 </instruction>
<input> 今天天气很好。 </input>
<response> The weather is nice today. </response>
```

::: note 先跑通，再调优
先用最小配置做不计入结果的环境试跑，确认实际目标模块、掩码、有限 loss 和梯度正确，再冻结正式配置并从原始基座重新启动四格实验。试跑不算四次正式训练；这里不提供已训练或已取得提升的结果。
:::

## 2. 为什么要「参数高效」微调

全参数微调一个模型要存参数、梯度和优化器的一阶与二阶矩（第 9 讲 9.1）。若四者都用 FP32，Adam 下约需 $16N$ 字节；混合精度等实现的字节数要按实际配置重算，激活和工作区另计。

**LoRA** 的思想：冻结原权重 $W$，只训练一个**低秩增量** $\Delta W=sBA$（$B\in\mathbb R^{d\times r}$，$A\in\mathbb R^{r\times k}$，$r\ll\min(d,k)$），前向变成

$$h=Wx+sBAx,\qquad s=\alpha/r.$$

只训练 $A,B$ 两个小矩阵，可训参数比例取决于 rank 和目标模块，须按实际模型计算；非量化权重在支持合并的实现中可将 $sBA$ 合并回 $W$。量化模型的合并、重新量化及其精度与推理开销应按使用的实现测量。

::: intuition 低秩假设：适配是"小改动"
LoRA 的假设是：对某些预训练模型与下游任务，低秩增量足以达到可接受的适配效果。这是需要在具体任务和预算下验证的假设，不代表权重更新总是低秩，也不保证小 rank 与全参数微调等价。冻结 $W$ 后，无须为它保存梯度与优化器状态；实际节省还取决于激活和基座权重的占比。
:::

```python
from peft import LoraConfig, get_peft_model

cfg = LoraConfig(
    r=8,
    lora_alpha=8,       # 四格中的 r8_s1；其他格按实验表修改
    lora_dropout=0.0,
    bias="none",
    use_rslora=False,
    init_lora_weights=True,
    task_type="CAUSAL_LM",
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                    "gate_proj", "up_proj", "down_proj"],
)
model = get_peft_model(base_model, cfg)
model.print_trainable_parameters()
```

这组 `target_modules` 来自 2026 年官方笔记本：注意力的四块投影，加上 SwiGLU 前馈的三块。只训 `q_proj` 和 `v_proj` 仍然是合法的 LoRA，只是和那份笔记本不是同一个实验。`r` 越大，可表示的最大秩越大、参数也越多，但训练后未必用满秩或得到更好泛化。示例显式填写缩放、dropout 和初始化；正式实验保存 PEFT 完整配置和实际匹配模块清单，不依赖跨版本默认值。

官方训练循环用的优化器是 **Lion**，不是 AdamW。Lion 不在 PyTorch 核心的 `torch.optim` 里，导入路径以你安装的包为准。换优化器会改变同样学习率下的步长，所以「lr = 1e-4」不能从 Adam 的经验直接搬过来。笔记本里的 `1e-4` 只是那份作业的起点。

## 3. 数据格式与分词

- **分词**（tokenize）：把文本切成 token id。**必须用与基座模型配套的分词器**，否则 id 与模型学过的含义错位。
- **拼接与掩码**：把 instruction / input / response 拼成一条序列；**只对 response 部分计算损失**（prompt 部分 mask 掉），这样模型学的是「如何回答」，而不是「复述问题」。
- **截断与填充**：设最大长度，超长截断、不足填充；注意 padding token 不能参与损失。

::: note 对哪些 token 计损失
本实验只对回答算损失，目的是把训练信号集中在答案上；其他指令微调配方也可能对提示计算损失。无论采用哪种方式，都要明确 mask 与 padding 口径，并在比较时保持一致。提示参与损失并不必然导致模型复述问题。
:::

## 4. 训练

与[第 1 讲](../lectures/lec01/overview.md)的循环完全一致，只是损失要自己对齐到「下一个 token」，并且 prompt 的位置不能进损失。官方笔记本走的是这条显式写法，而不是依赖 `outputs.loss` 的默认掩码：

```python
import torch.nn.functional as F

out = model(input_ids=input_ids, attention_mask=attention_mask, use_cache=False)
# logits[t] 预测的是 token[t+1]；labels 里 prompt 和 padding 事先写成 -100
shift_logits = out.logits[:, :-1, :].contiguous()
shift_labels = labels[:, 1:].contiguous()
loss = F.cross_entropy(
    shift_logits.view(-1, shift_logits.size(-1)),
    shift_labels.view(-1),
    ignore_index=-100,
)
opt.zero_grad()
loss.backward()
opt.step()
```

`ignore_index=-100` 是 `cross_entropy` 的现行约定。若你改用模型自带的 `labels=` 参数，也必须确认库把 `-100` 当成忽略位；不要假设每个版本都会替你掩掉 prompt。上面的 mean loss 是单次更新示意；正式梯度累积须把同一次更新内各 micro-batch 的交叉熵总和除以该更新右移后监督 token 总数，不能把不同长度批次的均值再等权平均。生成用现行的 `generate`：

```python
with torch.inference_mode():
    new_ids = model.generate(
        input_ids,
        do_sample=True,
        max_new_tokens=32,
        temperature=0.7,
    )
```

`temperature` 只在 `do_sample=True` 时改变分布。`do_sample=False` 是贪心解码，温度写上去也不起作用。

受限显存时可叠加（第 9 讲）：**梯度累积**模拟大批量、**混合精度**降占用、**梯度检查点**用计算换显存。BF16 用 `torch.autocast("cuda", dtype=torch.bfloat16)` 即可，不必再套 FP16 的 `GradScaler`。

## 5. 评估：怎么判断「微调有用」

| 方式 | 说明 |
|:--|:--|
| 定性 | 对若干留出问题采样，人工/对照检查是否按格式作答 |
| 定量 | 在留出集上算 token 级困惑度（perplexity），或任务专属指标（如精确匹配率） |
| 对照 | **必须对比微调前**，否则无法判断提升来自微调还是运气 |
| 和官方作业的差别 | 2026 年笔记本评的是一种文风是否被学到（风格适配）。流畅不等于风格对，也不等于事实对。报告里写清你测的是格式、风格还是答案 |

::: think "模型会说话了"不等于"任务学会了"
用自然语言采样，很容易得到看起来合理的输出。评估要看**任务指标**（是否答对、格式对不对），不能只看输出是否流畅。要做微调前后对比，必须固定问题集和解码参数。
:::

## 6. 排错清单

1. **分词器不匹配**：用了非配套分词器 → 输出乱码；
2. **损失 mask 与实验口径不符**：检查提示、回答与填充各位置的标签；只训练回答是本实验选择，并非提示参与损失就一定导致复述；
3. **padding 参与损失**：loss 被 padding 拉偏；
4. **显存 OOM**：先降 batch，再上梯度累积；开混合精度；必要时减小模型或 max_length。必做实验不能只替某格降低 rank、长度或预算；试跑后为四格统一改配置并重新训练；
5. **过拟合小数据**：用验证曲线识别训练下降而验证上升；另做早停扩展时可用验证集选 checkpoint，但必做比较用预先固定的 token 终点，不能让各格训练预算随验证结果改变。

## 7. 提交要求与进阶挑战

**实验报告须包含**：
1. **决策表**（填写预估vs实测指标，附显存估算公式）；
2. **回答对比**（微调前后同一问题的回答）；
3. **显存对比**（全参数 vs LoRA，可用上述同口径算式估算全参，不强制全参训练）；
4. **结论**：在你的任务上，LoRA 用多少可训参数达到了怎样的效果。

**必做对照：完整 $2\times2$ 设计，至少四次真实训练。** 对每个预先指定的训练种子，依次完成下表四格，每格独立进程、从同一 revision 的原始基座加载，重新初始化适配器与优化器，不能从另一格继续训练。基座未微调评估是额外的零训练对照，不代替任何一格。

| run 后缀 | rank $r$ | $s=\alpha/r$ | `lora_alpha` | 固定 $s$ 的配对 | 固定 $r$ 的配对 |
|:--|--:|--:|--:|:--|:--|
| `r8_s1` | 8 | 1 | 8 | 与 `r16_s1` | 与 `r8_s2` |
| `r8_s2` | 8 | 2 | 16 | 与 `r16_s2` | 与 `r8_s1` |
| `r16_s1` | 16 | 1 | 16 | 与 `r8_s1` | 与 `r16_s2` |
| `r16_s2` | 16 | 2 | 32 | 与 `r8_s2` | 与 `r16_s1` |

**先锁定数据与训练协议。** 以下是可执行的本书起始配方，不保证其训练充分：

1. 对 Dolly 数据先规范化空白、查重；同一非空 `context`、相同指令、同一来源文档及已识别的近重复/改写样本合为连通分组。不要把所有空 context 合为一组。先按组固定划分约 80%/10%/10% 训练/验证/测试，再按预先写定的规则从训练部分取最多 2,000 条。保存原始 ID、`group_id`、去重/过滤原因和各集实际组数、样本数；少量任务或类别的分布差异也要报告。若数据无来源字段，只能报告所能审计的文本泄漏，不能声称排除了基座预训练污染。
2. 使用配套 tokenizer 和固定文本模板，最大长度 512，固定截断方向、EOS 处理及回答为空/被截光时的丢弃规则。固定右 padding，`attention_mask` 屏蔽填充，只有回答标签保留，其余为 `-100`。pad 与 EOS 共用 ID 时按位置 mask，不能把所有 EOS 标签删掉；位置编码实现、是否 packing 和 packing 边界也须相同，起始配方不开 packing。保存处理后数据哈希及每条右移后的监督 token 数。
3. 单卡 micro-batch=1、累积=16、AdamW `lr=1e-4`、`betas=(0.9,0.999)`、`eps=1e-8`、`weight_decay=0`，前 16 次更新线性 warmup、随后常数学习率，共 256 次更新；每 32 次更新验证一次，并记录终点。用训练种子生成一份可重复遍历的数据 ID 顺序和 256 个更新的批次清单，共 4,096 次样本呈现；提前计算其监督 token 总数 $T_*$。所有格逐批重放同一清单，故同时匹配更新数、顺序及 $T_*$，不靠“相同 epoch 数”近似。不要为了凑预算各自截断最后一批。若采用其他预算或 Lion，先在试跑后统一锁定，不能逐格调学习率。
4. 固定模块清单、dropout=0、bias=none、冻结基座、精度/量化配置、梯度检查点、训练 `use_cache=False`、梯度裁剪设置和全部优化器/schedule 参数。单卡支持 BF16 时可用 BF16；不支持则统一选择可运行精度并记录 scaler。12 GB 不是适配任意配置的保证；小模型、短序列先试跑，再冻结配方。四格均以 $T_*$ 的最终 checkpoint 作为主比较，不按验证最优值挑赢家。
5. 每格开始前重设 Python、NumPy、PyTorch/CUDA 与数据加载种子；同一重复内四格训练种子相同（如 42），数据划分种子另行固定。相同 rank 的两种缩放须核对初始适配器张量哈希一致。标准 `init_lora_weights=True` 通常为随机 $A$、零 $B$，使初始 $sBA=0$；记录本版本实际规则与初始输出一致性检查。不同 rank 的张量形状不同，同种子不保证相同初始化子空间或逐步相同随机流。关闭 rsLoRA（它用 $\alpha/\sqrt r$）、DoRA、rank/alpha pattern 及其他额外缩放；不使用 PiSSA/LoftQ 等改变初始化的方案混入四格。量化若采用随机过程也固定其种子和配置。即便初始增量为零，$s$ 已改变第一步对 $B$ 的梯度，优化器又会影响后续步长，所以不能将 $s$ 解释为与学习率等价。

**预先指定比较和判断。** 主指标为测试集回答 token 的负对数似然（NLL，越小越好），验证集使用同一定义；可另预注册格式正确率、EM 或风格盲评，但不能看完结果再换主指标。对于样本 $i$，令 $n_i=\sum_t\mathbf1[y_{i,t+1}\ne-100]$，$\ell_i=-\sum_{t:y_{i,t+1}\ne-100}\log p(y_{i,t+1}\mid x_{i,\le t})$。在 `eval()`、无梯度、相同模板和掩码下，计算

$$L_{r,s}=\frac{\sum_i\ell_i}{\sum_i n_i},\qquad \mathrm{PPL}_{r,s}=\exp(L_{r,s}).$$

分母是右移后的回答 token，既不是输入总 token，也不是样本数；不得平均 batch loss 或样本 PPL。基座也用同一分母。训练曲线每个区间同样汇总 token 加权 NLL；训练吞吐定义为 $T_*/\text{train\_seconds}$，另报包含 prompt 的非 padding token 数以便解释算量。

在运行前固定实用差异阈值，例如主 NLL 的 $\delta=0.01$ nat/监督 token，并写明这是本次决策阈值而非通用标准。每个种子先计算：

$$C_s=L_{16,s}-L_{8,s}\ (s=1,2),\qquad S_r=L_{r,2}-L_{r,1}\ (r=8,16),$$
$$\bar C=(C_1+C_2)/2,\qquad \bar S=(S_8+S_{16})/2,\qquad I=C_2-C_1=S_{16}-S_8.$$

$C_s$ 是固定显式缩放的 rank 比较，$S_r$ 是固定 rank 的缩放比较；负值分别表示 $r=16$ 优于 $r=8$、$s=2$ 优于 $s=1$。两者都必须报告，不能只展示最优两格。$I$ 检查 rank 差异是否随缩放而变，不把主效应平均掩盖的相反方向说成「没有效应」。另报四格相对基座 $L_{r,s}-L_0$，以区分「比另一格好」与「比不微调好」。

至少一次四格训练是协议验收底线；若要讨论跨训练随机性的稳定性，预先指定至少 3 个训练种子，做 $4K$ 次训练，而非只给赢家补种子。保存每个测试样本的 $(\ell_i,n_i)$，以 `group_id` 为单位配对有放回 bootstrap 2,000 次，四格及基座在每次重采样中使用同一组索引，重新计算分子/分母和所有差值，报告 2.5%–97.5% 分位区间与重采样种子。多训练种子时对每种子报告差值，并报告种子均值；若给合并区间，外层重采样训练种子、内层重采样测试组，同一次重复在所有种子使用同一组索引。只有一个训练种子时，区间仅反映留出组抽样不确定性，不能据此宣称训练稳定；3 个种子的随机性估计也仍粗糙。

上述区间均为逐项区间，不宣称对多项比较有联合 95% 覆盖。预先以 $\bar C$、$\bar S$ 为两个主比较：区间完全低于 $-\delta$ 才称本协议下存在有实用幅度的改善证据；完全落在 $[-\delta,\delta]$ 内才称在此精度下近似等效；跨过边界则证据不足。条件比较和交互同时展示而不事后挑显著项。更高 rank 无益、缩放有害、微调不及基座、方向随 $s$ 反转或区间太宽，都是有效结果。结论限定于此基座、数据、初始化、优化器与预算；固定 $s$ 排除了显式 $\alpha/r$ 的混杂，但没有将表达容量与 rank 所改变的优化动力学分离。

**采集口径**：每格独立重启，记录设备上其他进程。加载基座、注入 LoRA、搬入设备并创建优化器对象后，在第一次训练 forward 前同步 CUDA，重置 `torch.cuda.reset_peak_memory_stats()` 并启动训练计时。计时/峰值范围覆盖全部训练 forward、backward、更新与首次懒分配的优化器状态，不包含模型下载/加载、验证、生成或保存。每个验证/保存边界前同步、累计训练耗时并读取当前峰值，恢复训练前再次同步、重置峰值和计时；最终 `peak_gb` 为各训练段 `max_memory_allocated()` 的最大值除以 $10^9$，`train_seconds` 为训练段耗时之和。最终更新结束后同步再读数。另报加载峰值或验证峰值时单列，不能混入此训练峰值。`max_memory_reserved()` 和 `nvidia-smi` 进程占用可作补充，三者口径不能混用。

生成延迟单独测量：固定相同提示 ID、输入 token、batch、解码方式和 `max_new_tokens`（如 batch=1、贪心、32）；每个模型先预热 3 次、再计时 20 次，在每次 `generate` 前后同步 CUDA，用 `time.perf_counter()` 计时，报告中位数 ms、次数和实际新生成 token 数分布。EOS 提前结束可能造成长度不同，需同时披露，不能仅凭更短输出声称推理更快。质量比较使用同一套提示与解码；定性采样可以保留，但固定采样种子，不替代主 NLL。

**提交的结果行格式**：每个训练种子、每格一行，另列基座行（无训练成本记为不适用，不伪填零测量）。CSV 或 JSONL 的必备字段如下；`manifest_file` 保存完整配置与软件版本，`per_example_file` 保存测试 ID/group、$\ell_i,n_i$ 及可选生成结果：

```text
run_id,seed,rank,alpha,alpha_over_r,model_id,model_revision,tokenizer_revision,data_revision,split_hash,order_hash,manifest_file,trainable_params,optimizer,learning_rate,schedule,updates,effective_tokens,input_nonpad_tokens,train_seconds,supervised_tokens_per_second,peak_gb,peak_scope,val_nll,test_nll,test_ppl,task_metric_name,task_metric_value,latency_ms,latency_repeats,output_tokens_summary,curve_file,per_example_file
```

无额外任务指标时 `task_metric_name/value` 明确记为未测。另提交差值表：`comparison,seed_or_mean,estimate,ci_low,ci_high,delta,bootstrap_seed,bootstrap_repeats,uncertainty_scope`，包含两个 $C_s$、两个 $S_r$、$\bar C,\bar S,I$ 与四个基座差值。曲线至少有两个测量点并保留完整日志，横轴同时标更新数和累计监督 token；短跑不能判断过拟合时如实说明。验收要求四格真实运行、控制变量和原始产物可追溯，不要求训练变好。

### 实验账本 CLI

在仓库根目录将下面内容保存为 `lab3-ledger.json`。**所有数字和模型元数据仅为合成示例，不是实测结果**；此处用缩短的虚构预算展示四格记账，不表示完成了上文的训练协议。真实提交须替换为你的数据、矩阵尺寸、模型元数据、曲线与测量口径。`matrices` 的 `count` 是实际注入的、同形状且不重复的目标矩阵个数；`extra_trainable_params` 是 bias、额外模块等非 LoRA 矩阵的可训参数数；`trainable_params` 是模型实测的全部可训参数。`curve_file` 指向你另行提交的曲线图或日志；两个 loss 数组按同一验证间隔排列，横轴与完整配置写在 `config` 或其引用的 manifest。账本保留 CLI 原有字段，另加 `seed`、`alpha`、`alpha_over_r` 便于人工审计；它是成本估算摘要，不能替代上面的逐行结果、测试样本日志和差值表。`validation_value` 始终填验证 NLL，测试 NLL 另存，不把选参集和终评集混为一列。

```json
{
  "metadata": {
    "model": "synthetic-model", "model_revision": "example-only",
    "task": "synthetic instruction response; shared config: 20 updates, seed 42, identical order/tokenizer/masks/targets; standard LoRA, random A and zero B; no rsLoRA, no packing; right padding; same base weights", "split": "fixed grouped train/validation/test IDs; example-only",
    "environment": "synthetic GPU; software versions example only", "precision": "fp16",
    "targets": "one synthetic linear matrix", "measurement_method": "training-only allocated peak incl first optimizer state, excl loading/validation; synchronized generation median",
    "validation_metric": "validation response-token NLL, lower is better", "baseline_metric": "synthetic base validation NLL 2.4; test stored separately"
  },
  "matrices": [{"name": "synthetic projection", "in": 4096, "out": 4096, "count": 1}],
  "runs": [
    {"name": "seed42_r8_s1", "seed": 42, "rank": 8, "alpha": 8, "alpha_over_r": 1,
     "optimizer": "Lion", "learning_rate": 0.00003,
     "schedule": "constant", "config": "alpha 8; standard scaling 1; dropout 0; evaluate every 10 steps; shared metadata config",
     "batch": 1, "accumulation": 16, "devices": 1, "estimated_peak_gb": 5,
     "peak_gb": 5.5, "estimated_latency_ms": 100, "latency_ms": 110,
     "effective_tokens": 1000, "validation_value": 2.1, "trainable_params": 65536,
     "extra_trainable_params": 0, "train_loss": [2.3, 2.1], "validation_loss": [2.4, 2.1], "curve_file": "seed42_r8_s1.png"},
    {"name": "seed42_r8_s2", "seed": 42, "rank": 8, "alpha": 16, "alpha_over_r": 2,
     "optimizer": "Lion", "learning_rate": 0.00003,
     "schedule": "constant", "config": "alpha 16; standard scaling 2; dropout 0; evaluate every 10 steps; shared metadata config",
     "batch": 1, "accumulation": 16, "devices": 1, "estimated_peak_gb": 5,
     "peak_gb": 5.5, "estimated_latency_ms": 100, "latency_ms": 110,
     "effective_tokens": 1000, "validation_value": 2.0, "trainable_params": 65536,
     "extra_trainable_params": 0, "train_loss": [2.3, 2.0], "validation_loss": [2.4, 2.0], "curve_file": "seed42_r8_s2.png"},
    {"name": "seed42_r16_s1", "seed": 42, "rank": 16, "alpha": 16, "alpha_over_r": 1,
     "optimizer": "Lion", "learning_rate": 0.00003,
     "schedule": "constant", "config": "alpha 16; standard scaling 1; dropout 0; evaluate every 10 steps; shared metadata config",
     "batch": 1, "accumulation": 16, "devices": 1, "estimated_peak_gb": 5.1,
     "peak_gb": 5.6, "estimated_latency_ms": 100, "latency_ms": 112,
     "effective_tokens": 1000, "validation_value": 1.9, "trainable_params": 131072,
     "extra_trainable_params": 0, "train_loss": [2.3, 1.9], "validation_loss": [2.4, 1.9], "curve_file": "seed42_r16_s1.png"},
    {"name": "seed42_r16_s2", "seed": 42, "rank": 16, "alpha": 32, "alpha_over_r": 2,
     "optimizer": "Lion", "learning_rate": 0.00003,
     "schedule": "constant", "config": "alpha 32; standard scaling 2; dropout 0; evaluate every 10 steps; shared metadata config",
     "batch": 1, "accumulation": 16, "devices": 1, "estimated_peak_gb": 5.1,
     "peak_gb": 5.6, "estimated_latency_ms": 100, "latency_ms": 112,
     "effective_tokens": 1000, "validation_value": 2.0, "trainable_params": 131072,
     "extra_trainable_params": 0, "train_loss": [2.3, 1.9], "validation_loss": [2.4, 2.0], "curve_file": "seed42_r16_s2.png"}
  ]
}
```

```bash
python3 tools/lab3_report.py lab3-ledger.json
# 缺字段演示：保存为另一个文件，不覆盖真实账本
printf '{}\n' > /tmp/lab3-incomplete.json
python3 tools/lab3_report.py /tmp/lab3-incomplete.json
```

脚本只依赖 Python 标准库，不需要 GPU；输入不完整、数字无效、JSON 格式错误或文件无法读取时提示字段并返回非零。它计算参数量和有效批量，比较估算/实测显存与延迟，并给每组一个**估算误差得分**：三项相对误差分别为 $|\text{估算}-\text{实测}|/\text{实测}$，每项记 $1-\min(1,\text{相对误差})$，三项等权乘以 100。比如三项误差均为零得到 100 分；某项误差达到或超过 100% 时该项得 0 分。这个分数不评价任务质量、测量真实性或实验设计，也不读取曲线文件；比较前仍须人工核对目标矩阵、额外可训参数、配置和测量范围。

CLI 仍只做原有账本字段检查（至少两行），**不会强制四格齐全**，也不解析 `config` 来验证缩放、种子、token 预算、文件存在性或数据泄漏。输出“完整性检查通过”不等于通过本实验验收；其相对第一行的差值也不是本实验要求的全部 $C_s,S_r,I$。提交前按四格表及独立差值表核对，不能用估算误差得分替代实验结论。

**进阶挑战（可选，答辩加分）**：
1. **秩的过拟合拐点**：扫 $r\in\{4,8,16,32\}$，固定 $s=\alpha/r$（例如 $s=1$、各组设 $\alpha=r$）和其余设置，绘制训练/验证 loss 曲线与可训参数；使用独立于必做测试集的开发数据探索拐点，若无拐点不要强行下结论。若同时研究缩放，另做完整交叉表，不固定 alpha 后称为纯容量扫描。
2. **Lion vs AdamW**：固定基座、rank、$\alpha/r$、初始化、数据、有效批量、训练 token 预算及验证间隔，分别从 Lion `3e-5` 和 AdamW `1e-4` 开始；记录各自 schedule 和训练/验证曲线，比较收敛速度及留出指标，不称学习率等效。调参只用验证集且搜索预算相同，测试集不用于选择学习率。
3. **显存-时间 Trade-off**：固定模型、rank、$\alpha/r$、优化器、数据顺序、监督 token 预算、损失归一化和有效批量，对比 batch=1 accum=16、batch=2 accum=8、batch=4 accum=4；报告实际 token 数、峰值、训练耗时和任务指标，并解释数值差异及可能的随机性。

**自检**：能解释 LoRA 有效性的低秩假设；能说明指令微调只对 response 算损失的原因；能为 OOM 给出三条缓解手段；能从四格表分别算出固定缩放的 rank 差、固定 rank 的缩放差和交互，并说明为什么它们仍不能证明纯容量机制。


## 8. 代码 ↔ 讲次对照表

| 代码 / 步骤 | 对应结论 |
|:--|:--|
| 加载 tokenizer 与 `input_ids` | [6.1 大语言模型](../lectures/lec06/sec61.md)：BPE 分词决定 token 边界与序列长度 |
| 只在 response 上算损失（mask prompt） | [6.1](../lectures/lec06/sec61.md)：本实验将监督信号集中在回答；其他掩码口径也可使用 |
| `LoraConfig` 的 `target_modules` | [9.5 PEFT](../lectures/lec09/sec95.md)：标准缩放的低秩增量 $W=W_0+(\alpha/r)BA$；模块名随模型而变 |
| `cross_entropy(..., ignore_index=-100)` 与右移一位 | [6.1](../lectures/lec06/sec61.md)：下一个 token；prompt 不进损失 |
| `generate(..., do_sample=True, temperature=)` | [Lab 1](lab1.md) 的温度；贪心解码时温度无效 |
| 4-bit 量化基座 + LoRA（QLoRA） | [9.5](../lectures/lec09/sec95.md)：量化冻结基座，并另计量化元数据、可训练适配器及训练开销 |
| 梯度累积达到有效批大小 | [1.6 优化器](../lectures/lec01/sec16.md)、[9.2 数据并行](../lectures/lec09/sec92.md) |
| 微调前后对比 + 留出集评测 | [6.7 评估](../lectures/lec06/sec67.md)：口径要对齐，且要防污染 |
| 若继续做偏好优化 | [5.6 RLHF 与 DPO](../lectures/lec05/sec56.md)：成对偏好 → DPO 损失 |

## 9. 扩展任务（选做 1–2 项）

1. **LoRA vs 全参**：在你能拿到的硬件上对比两者的显存、吞吐与效果，并给出「什么条件下值得全参」的判据（[9.5](../lectures/lec09/sec95.md)）；无法运行全参时报告同假设显存算式，吞吐与效果标为未测。
2. **秩与模块扫描**：固定基座与 $s=\alpha/r$，扫 $r\in\{4,8,16,32,64\}$ 与不同 `target_modules`，分别展示每套模块的“可训参数—指标”曲线，找性价比拐点（[附录 A 选题 4](../appendix/roadmap.md)）。模块集合也改变适配位置，不能把它的影响归为 rank；探索使用开发数据，新终评使用事先封存的数据，不反复消费必做测试集。
3. **偏好优化**：用 200–500 对偏好数据做一次 DPO，与 SFT 结果对照；特别观察**风格与格式**的变化和「过度优化」的迹象（[5.6](../lectures/lec05/sec56.md)）。
4. **量化部署**：把模型导出并在 `llama.cpp` 或 `vLLM` 上跑，报告吞吐（tokens/s）与首 token 延迟，解释瓶颈在哪（[6.7](../lectures/lec06/sec67.md)、[工具箱](../toolbox.md)）。
5. **污染自查**：自建 30 道题，做「同义改写 / 选项打乱」对照，比较分数落差并讨论证据的局限（[6.7](../lectures/lec06/sec67.md)）。
