# Lab 3 · 微调一个大语言模型

本实验对应第 6、9 讲：加载一个**预训练**语言模型，用**参数高效微调（LoRA）**在受限显存下把它适配到一个下游任务，并用自回归采样评估输出。它是「小算力撬动大模型」的标准流程。

<aside class="lesson-brief" aria-label="Lab 3 学习简报">
<div><span class="brief-label">PREREQUISITE</span><strong>你需要先会</strong><p>[第 2 讲](../lectures/lec02.md)的 Transformer 与自回归生成；[第 6 讲](../lectures/lec06.md)的预训练/微调/提示三段式；[第 9 讲](../lectures/lec09.md)的显存构成与 LoRA。</p></div>
<div><span class="brief-label">TARGET</span><strong>你将做出</strong><p>一个在你的数据上微调过、会按你的格式作答的模型；一份「全参数微调 vs LoRA」的显存/效果对比。</p></div>
<div><span class="brief-label">CHECKPOINT</span><strong>验收标准</strong><p>微调后模型在你的任务上明显优于微调前；训练只更新极少比例的参数；能解释为什么 LoRA 能在**冻结主干**的前提下工作。</p></div>
</aside>

## 1. 环境与模型

- **库**：`transformers` + `peft`（HuggingFace 生态），或等价的 LoRA 实现。
- **基座模型**：选一个**能在你的显存里加载**的预训练模型（先跑通小模型，再考虑更大的）。本书不绑定具体型号；关键是理解流程。
- **数据**：一个**指令-回答**格式的小数据集（几百到几千条即可）。格式通常是：

```text
<instruction> 把下面这句话翻译成英文。 </instruction>
<input> 今天天气很好。 </input>
<response> The weather is nice today. </response>
```

::: note 先跑通，再调优
第一次务必用**最小配置**（小模型、小数据、几步训练）确认整条链路能跑通，再逐步放大。LLM 微调里「环境没配好、显存不够、数据格式解析失败」占失败原因的绝大多数，与算法本身无关。
:::

## 2. 为什么要"参数高效"微调

全参数微调一个模型要存 **4 份**东西（第 9 讲 9.1）：参数、梯度、优化器的一阶与二阶矩。一个 $N$ 参数的模型在 Adam 下约需 $16N$ 字节——大模型单卡放不下。

**LoRA** 的思想：冻结原权重 $W$，只训练一个**低秩增量** $\Delta W=BA$（$B\in\mathbb R^{d\times r}$，$A\in\mathbb R^{r\times k}$，$r\ll\min(d,k)$），前向变成

$$h=Wx+BAx.$$

只训练 $A,B$ 两个小矩阵，可训参数量降到**不到 1%**；且推理时 $BA$ 可合并回 $W$，不增加推理开销。

::: intuition 低秩假设：适配是"小改动"
从预训练基座跑到下游任务，权重的改变往往落在**低维子空间**里——不需要动整个大矩阵，改一个低秩部分就够了。这与第 9 讲「显存瓶颈在优化器状态」正好对上：不训练 $W$，就不存 $W$ 的梯度和优化器状态，显存骤降。
:::

```python
from peft import LoraConfig, get_peft_model
cfg = LoraConfig(r=8, lora_alpha=16, target_modules=["q_proj", "v_proj"],
                 lora_dropout=0.05, task_type="CAUSAL_LM")
model = get_peft_model(base_model, cfg)
model.print_trainable_parameters()   # 例：trainable 0.1% | total 100%
```

`target_modules` 通常选注意力里的投影矩阵（$Q,V$）；`r` 是秩，越大容量越大、越贵。

## 3. 数据格式与分词

- **分词**（tokenize）：把文本切成 token id。**必须用与基座模型配套的分词器**，否则 id 与模型学过的含义错位。
- **拼接与掩码**：把 instruction / input / response 拼成一条序列；**只对 response 部分计算损失**（prompt 部分 mask 掉），这样模型学的是"如何回答"，而不是"复述问题"。
- **截断与填充**：设最大长度，超长截断、不足填充；注意 padding token 不能参与损失。

::: note 只对 response 算损失，是微调与预训练的关键区别
预训练对**所有** token 算下一个词预测损失；指令微调只对**答案**部分算损失——这才是"教模型按格式回答"的关键。mask 写错（把 prompt 也算进去）会让模型倾向于复述问题而不是回答。
:::

## 4. 训练

与[第 1 讲](../lectures/lec01.md)的循环完全一致，只是模型大：

```python
out  = model(**batch)          # 前向
loss = out.loss                # 交叉熵（对 response token，第 1 讲 1.4）
loss.backward()                # 反向（定理 1.2）
opt.step(); opt.zero_grad()    # 更新（定义 1.3）
```

受限显存时可叠加（第 9 讲）：**梯度累积**模拟大批量、**混合精度**降占用、**梯度检查点**用计算换显存。

## 5. 评估：怎么判断"微调有用"

| 方式 | 说明 |
|:--|:--|
| 定性 | 对若干留出问题采样，人工/对照检查是否按格式作答 |
| 定量 | 在留出集上算 token 级困惑度（perplexity），或任务专属指标（如精确匹配率） |
| 对照 | **必须对比微调前**，否则无法判断提升来自微调还是运气 |

::: think "模型会说话了"不等于"任务学会了"
用自然语言采样很容易产生"看起来像那么回事"的输出。评估要盯**任务指标**（是否答对、格式对不对），而不是输出的流畅度。范式化评估（固定问题集、固定解码参数）才能做前后对比。
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
