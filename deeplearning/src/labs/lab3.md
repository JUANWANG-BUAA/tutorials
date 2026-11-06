# Lab 3 · 微调一个大语言模型

本实验对应第 6、9 讲：加载一个**预训练**语言模型，用**参数高效微调（LoRA）**在受限显存下把它适配到一个下游任务，并用自回归采样评估输出。它是「小算力撬动大模型」的标准流程。

## 1. 环境与模型

- **库**：`transformers` + `peft`。官方 2026 年笔记本是仓库里的 `lab3/LLM_Finetuning.ipynb`，没有单独的 TensorFlow 版。
- **基座模型**：笔记本以 Liquid AI 的 **LFM2-1.2B** 为例（它自己写的量级是约十亿参数）。本书不要求你用同一权重；先用能放进显存的因果语言模型跑通。换模型时，`target_modules` 的名字会变，以 `model.named_modules()` 为准，不要照抄字符串。
- **数据**：一个**指令-回答**格式的小数据集（几百到几千条即可）。格式通常是：

```text
<instruction> 把下面这句话翻译成英文。 </instruction>
<input> 今天天气很好。 </input>
<response> The weather is nice today. </response>
```

::: note 先跑通，再调优
第一次务必用**最小配置**（小模型、小数据、几步训练）确认整条链路能跑通，再逐步放大。LLM 微调里「环境没配好、显存不够、数据格式解析失败」占失败原因的绝大多数，与算法本身无关。
:::

## 2. 为什么要「参数高效」微调

全参数微调一个模型要存 **4 份**东西（第 9 讲 9.1）：参数、梯度、优化器的一阶与二阶矩。一个 $N$ 参数的模型在 Adam 下约需 $16N$ 字节——大模型单卡放不下。

**LoRA** 的思想：冻结原权重 $W$，只训练一个**低秩增量** $\Delta W=BA$（$B\in\mathbb R^{d\times r}$，$A\in\mathbb R^{r\times k}$，$r\ll\min(d,k)$），前向变成

$$h=Wx+BAx.$$

只训练 $A,B$ 两个小矩阵，可训参数量降到**不到 1%**；且推理时 $BA$ 可合并回 $W$，不增加推理开销。

::: intuition 低秩假设：适配是"小改动"
从预训练基座跑到下游任务，权重的改变往往落在**低维子空间**里——不需要动整个大矩阵，改一个低秩部分就够了。这与第 9 讲「显存瓶颈在优化器状态」正好对上：不训练 $W$，就不存 $W$ 的梯度和优化器状态，显存骤降。
:::

```python
from peft import LoraConfig, get_peft_model

cfg = LoraConfig(
    r=8,
    task_type="CAUSAL_LM",
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj",
                    "gate_proj", "up_proj", "down_proj"],
)
model = get_peft_model(base_model, cfg)
model.print_trainable_parameters()
```

这组 `target_modules` 来自 2026 年官方笔记本：注意力的四块投影，加上 SwiGLU 前馈的三块。只训 `q_proj` 和 `v_proj` 仍然是合法的 LoRA，只是和那份笔记本不是同一个实验。`r` 越大容量越大、也越贵。`lora_alpha` 与 `lora_dropout` 有默认值；要和别人的结果对比时，把实际用到的字段写进配置，而不是假设默认值不变。

官方训练循环用的优化器是 **Lion**，不是 AdamW。Lion 不在 PyTorch 核心的 `torch.optim` 里，导入路径以你安装的包为准。换优化器会改变同样学习率下的步长，所以「lr = 1e-4」不能从 Adam 的经验直接搬过来。笔记本里的 `1e-4` 只是那份作业的起点。

## 3. 数据格式与分词

- **分词**（tokenize）：把文本切成 token id。**必须用与基座模型配套的分词器**，否则 id 与模型学过的含义错位。
- **拼接与掩码**：把 instruction / input / response 拼成一条序列；**只对 response 部分计算损失**（prompt 部分 mask 掉），这样模型学的是「如何回答」，而不是「复述问题」。
- **截断与填充**：设最大长度，超长截断、不足填充；注意 padding token 不能参与损失。

::: note 只对 response 算损失，是微调与预训练的关键区别
预训练对**所有** token 算下一个词预测损失；指令微调只对**答案**部分算损失——这才是「教模型按格式回答」的关键。mask 写错（把 prompt 也算进去）会让模型倾向于复述问题而不是回答。
:::

## 4. 训练

与[第 1 讲](../lectures/lec01/overview.md)的循环完全一致，只是损失要自己对齐到「下一个 token」，并且 prompt 的位置不能进损失。官方笔记本走的是这条显式写法，而不是依赖 `outputs.loss` 的默认掩码：

```python
import torch.nn.functional as F

out = model(input_ids=input_ids)
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

`ignore_index=-100` 是 `cross_entropy` 的现行约定。若你改用模型自带的 `labels=` 参数，也必须确认库把 `-100` 当成忽略位；不要假设每个版本都会替你掩掉 prompt。生成用现行的 `generate`：

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
用自然语言采样很容易产生「看起来像那么回事」的输出。评估要盯**任务指标**（是否答对、格式对不对），而不是输出的流畅度。范式化评估（固定问题集、固定解码参数）才能做前后对比。
:::

## 6. 排错清单

1. **分词器不匹配**：用了非配套分词器 → 输出乱码；
2. **损失 mask 写错**：prompt 也算进损失 → 学成复述；
3. **padding 参与损失**：loss 被 padding 拉偏；
4. **显存 OOM**：先降 batch，再上梯度累积；开混合精度；必要时减小 `r` 或 max_length；
5. **过拟合小数据**：几百条数据训太多轮会死记硬背，用早停/验证集。

## 7. 提交与自检

- 一段**微调前后**同一问题的回答对比；
- 一张**可训练参数量**与**显存占用**的对比（全参数 vs LoRA）；
- 一句结论：在你这个任务上，LoRA 用多少可训参数达到了怎样的效果。

**自检**：能解释 LoRA 为何只训练极少参数却有效（低秩假设 + 冻结主干）；能说清指令微调为何只对 response 算损失；能为 OOM 给出三条具体的缓解手段。

## 8. 代码 ↔ 讲次对照表

| 代码 / 步骤 | 对应结论 |
|:--|:--|
| 加载 tokenizer 与 `input_ids` | [6.1 大语言模型](../lectures/lec06/sec61.md)：BPE 分词决定 token 边界与序列长度 |
| 只在 response 上算损失（mask prompt） | [6.1](../lectures/lec06/sec61.md)：监督微调的目标是「学会回答」而非「复述问题」 |
| `LoraConfig` 的 `target_modules` | [9.5 PEFT](../lectures/lec09/sec95.md)：低秩增量 $W=W_0+BA$；模块名随模型而变 |
| `cross_entropy(..., ignore_index=-100)` 与右移一位 | [6.1](../lectures/lec06/sec61.md)：下一个 token；prompt 不进损失 |
| `generate(..., do_sample=True, temperature=)` | [Lab 1](lab1.md) 的温度；贪心解码时温度无效 |
| 4-bit 量化基座 + LoRA（QLoRA） | [9.5](../lectures/lec09/sec95.md)：显存降到 $10N$ 量级 |
| 梯度累积达到有效批大小 | [1.6 优化器](../lectures/lec01/sec16.md)、[9.2 数据并行](../lectures/lec09/sec92.md) |
| 微调前后对比 + 留出集评测 | [6.7 评估](../lectures/lec06/sec67.md)：口径要对齐，且要防污染 |
| 若继续做偏好优化 | [5.6 RLHF 与 DPO](../lectures/lec05/sec56.md)：成对偏好 → DPO 损失 |

## 9. 扩展任务（选做 1–2 项）

1. **LoRA vs 全参**：在你能拿到的硬件上对比两者的显存、吞吐与效果，并给出「什么条件下值得全参」的判据（[9.5](../lectures/lec09/sec95.md)）。
2. **秩与模块扫描**：固定基座，扫 $r\in\{4,8,16,32,64\}$ 与不同 `target_modules`，画「可训参数—指标」曲线，找性价比拐点（[附录 A 选题 4](../appendix/roadmap.md)）。
3. **偏好优化**：用 200–500 对偏好数据做一次 DPO，与 SFT 结果对照；特别观察**风格与格式**的变化和「过度优化」的迹象（[5.6](../lectures/lec05/sec56.md)）。
4. **量化部署**：把模型导出并在 `llama.cpp` 或 `vLLM` 上跑，报告吞吐（tokens/s）与首 token 延迟，解释瓶颈在哪（[6.7](../lectures/lec06/sec67.md)、[工具箱](../toolbox.md)）。
5. **污染自查**：自建 30 道题，做「同义改写 / 选项打乱」对照，比较分数落差并讨论证据的局限（[6.7](../lectures/lec06/sec67.md)）。
