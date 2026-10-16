# 工程工具箱：环境、形状、排查与显存

本书的正讲讲「为什么」，这一页讲「**动手时怎么不出错**」。九讲里的方法散落在正文与三个 Lab，这里按「遇到问题时的使用顺序」重新编排：先保证环境与形状正确，再学会按顺序排查不收敛，最后学会算显存、管实验、上性能。

::: note 五件工具，各司其职

| 工具 | 管什么 | 什么时候用 |
|:--|:--|:--|
| [先修工具箱](prerequisite.md) | **基础层**：向量、概率、求导、张量与自动微分的直觉 | 开学前、遇到数学卡壳时 |
| **本页** | **操作层**：环境、形状、排查树、显存账、实验管理、性能 | 每一行训练代码落地时 |
| [速查背记卡](memory-sheet.md) | **压缩层**：每讲压成一句「最小可背诵单元」 | 背之前先把要背的压到最短 |
| [闭卷回忆卡](lectures/lec01/recall-cards.md) | **检索层**：从空白纸上把定义与公式叫出来 | 当天 / 1 / 3 / 7 天间隔复习（可导出 Anki） |
| [面试与答辩竞技场](training/arena.md) | **输出层**：限时讲清一个技术判断 | 面试前、项目答辩前 |
:::

## 一、环境与依赖：先把地基打平

::: method 流程 1 · 一个可复现的环境（15 分钟）{#flow-env}
**步骤**：

1. **Python 3.10+ 虚拟环境**：`python -m venv .venv && source .venv/bin/activate`（或 `conda create -n dl python=3.11`）。
2. **装 PyTorch**：按官网选择器装（`pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124` 一类）；**CUDA 版本要与驱动匹配**，别硬拉最新。
3. **锁版本**：`pip freeze > requirements.txt`（或 `uv lock` / `poetry lock`）。深度学习代码的可复现性**首先死在依赖漂移**上。
4. **自检**：

```python
import torch, sys
print(sys.version, torch.__version__, torch.cuda.is_available())          # 环境
print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else "CPU only")  # 设备
x = torch.randn(4, 3, device="cuda" if torch.cuda.is_available() else "cpu")
print(x.mean().item(), torch.softmax(x, dim=-1).sum(-1))                  # 唯一一条"端到端通"的证据
```

**常见坑**：`torch.cuda.is_available() == False` 而驱动正常 → 多半是装了 CPU 版；多卡机器上忘了 `CUDA_VISIBLE_DEVICES`；M 系列 Mac 用 `device="mps"`（部分算子回退 CPU，性能结论不可直接比较）。
:::

::: errata 环境层面的三类高频事故
1. **设备不一致**（`Expected all tensors on same device`）：模型在 cuda、数据在 cpu，或某个手写的常量张量没 `.to(device)`。排查：`print(next(model.parameters()).device, x.device)`。
2. **dtype 不一致**（`expected scalar type Half but found Float`）：混合精度下模型权重是 fp16/bf16 而输入是 fp32。用 `torch.autocast` 统一管理（见第六节），不要手工对每一层 `.half()`。
3. **随机性不可复现**：`torch.manual_seed` 只管 PyTorch，还要管 `numpy.random`、Python `random`，以及 DataLoader 的 `worker_init_fn` 与 `generator`。做结论对比时**至少固定种子并重复三次**。
:::

## 二、张量形状：调试的第一技能

深度学习代码里 **80% 的报错本质是形状错**。形状推演是本书反复训练的基本功（[1.1 形状约定](lectures/lec01/sec11.md#method-1.1.1)、[1.2 前向推演](lectures/lec01/sec12.md)、[2.5 Transformer 形状表](lectures/lec02/sec25.md)）。

::: method 流程 2 · 形状排查四步{#flow-shape}
1. **写下约定**：第 0 维永远是批维（本书统一「批优先」）。序列任务记 $B\times T\times d$，图像记 $B\times C\times H\times W$。
2. **逐层标注**：把每个算子的输入输出形状写在纸上或注释里（例如 `x: [32, 128] -> Linear -> [32, 10]`），**不要靠脑补**。
3. **用断言固化**：训练脚本里加 `assert`，让错误停在第一现场。

```python
B, T, d = x.shape
assert x.dim() == 3 and d == model.d_model, (x.shape, model.d_model)
x = x.transpose(0, 1)  # 只在确实需要 (T, B, d) 时转置，并在下一行写回来的理由
```

4. **定位广播**：形状不匹配却**没有报错**时，几乎一定是广播在「帮你」做错事——形状相同的维或为 1 的维才会广播；`[B, 1]` 与 `[B]` 相加会得到 `[B, B]`（典型的静默错误）。
:::

| 操作 | 语义 | 何时用 | 常见误用 |
|:--|:--|:--|:--|
| `view` | 按内存连续顺序重排 | 确定张量连续时 | 转置后直接 `view` → 报错或结果错 |
| `reshape` | 尽量零拷贝，必要时复制 | 大多数场景 | 以为它一定零拷贝（其实可能复制） |
| `permute` / `transpose` | 换维序（**内存仍非连续**） | 换轴（如 (B,T,C)→(B,C,T)） | 之后直接 `view`；忘记 `.contiguous()` |
| `squeeze` / `unsqueeze` | 增删长度为 1 的维 | 对齐批维 | 无参 `squeeze` 误删了批维（batch=1 时） |
| `expand` / `repeat` | 广播复制（expand 不占内存） | mask、位置嵌入 | 对 `expanded` 张量做原地写 |
| `einsum` | 显式下标收缩 | 复杂张量运算 | 可读性差、忘记 `optimize=True` |

## 三、训练不收敛：按顺序排查

「不收敛」是四类问题的统称：**损失不降、损失震荡、损失降但指标不涨、NaN/Inf**。排查要**按代价从低到高**，而不是随手调学习率。

::: method 流程 3 · 排查树（照这个顺序走）{#flow-debug}

**第 0 步 · 用一个样本过拟合。** 取 1–8 个样本，关掉正则（dropout=0、weight decay=0），训练几百步。**如果连这几个样本都拟合不了，问题一定在代码或数据，不在超参数**（这是最高性价比的一步）。

**第 1 步 · 数据与标签。**
- 可视化 5 个样本（图像/音频直接看图；文本打印原文与标签映射）。
- 检查标签对齐（`shuffle` 与 `sampler` 是否错位）、类别映射是否颠倒。
- 检查归一化（均值方差是否来自**训练集**，而非全量数据——后者是数据泄漏）。

**第 2 步 · 损失与输出层。**
- 分类：`CrossEntropyLoss` 内部含 softmax，**网络输出层不要再加 softmax**（加了等于算两次）。
- 回归：目标是否标准化？未标准化时 MSE 的梯度尺度可能极端。
- 打印初始损失：$C$ 分类的随机初始损失应接近 $\ln C$（如 10 类 ≈ 2.30）。偏离很远说明输出层或标签有问题。

**第 3 步 · 学习率（最关键的超参数）。**
- 做一次**学习率扫描**：从 $10^{-6}$ 到 $10^{-1}$ 每档跑 100 步，画出 loss-$\eta$ 曲线，取最低点附近。
- 症状对照：loss 爆到 NaN → 太大或需 loss scaling；loss 长期不降 → 太小；loss 周期性震荡 → 太大且批太小。

**第 4 步 · 初始化与归一化。**
- 深层网络用 Kaiming/Xavier，残差分支的最后一层可置零（很多现代骨干这么做）。
- 检查是否忘了 LayerNorm/BatchNorm；BatchNorm 在小批（<8）下统计量不稳，考虑 GroupNorm/LayerNorm。

**第 5 步 · 数值稳定性。**
- 混合精度下出现 NaN：检查 `GradScaler` 是否启用、softmax/exp 是否在 fp32 下计算（`autocast` 会自动处理常见算子）。
- 梯度爆炸：`torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)`；同时打印梯度范数，确认它真的在爆。
- 打印 `loss` 与 `grad_norm` 的**原始值**（不是四舍五入后的），NaN 会留下第一现场的痕迹。

**第 6 步 · 也只有到这一步，才怀疑模型容量与结构。** 加大/加深、加正则、换结构——在这些之前，前五步没走完，都还轮不到架构。
:::

::: think 为什么「先过拟合一个小批」这么有效
它把「优化器能否驱动这个模型」与「数据分布是否可学」两个变量**解耦**：小批上损失降不下来，说明**优化通路**断了（梯度没连上、学习率错、标签错）；损失能降但测试差，说明是**泛化**问题（数据少、正则不够、分布偏移）。两类问题的处方完全不同，混在一起调参必然来回打转。
:::

## 四、显存估算：五个账单

训练时显存不是只装参数。**五份账单**：

::: method 流程 4 · 显存估算公式{#flow-mem}
设参数量为 $N$（单位：个），优化器用 Adam 系，混合精度训练（bf16/fp16 计算 + fp32 主权重）：

| 账单 | 内容 | 字节数（混合精度） | 纯 fp32 |
|:--|:--|:--|:--|
| ① 参数 | 权重本身 | $2N$ | $4N$ |
| ② 梯度 | 与参数同形 | $2N$ | $4N$ |
| ③ 优化器状态 | Adam 的一阶/二阶动量 | $8N$（fp32） | $8N$ |
| ④ 主权重副本 | master weights（fp32） | $4N$ | 0 |
| ⑤ 激活 | 前向中间结果（与批、序列长、层数成正比） | 与 $B\!\cdot\!T\!\cdot\!L$ 成正比 | 同 |

**静态部分合计 ≈ $16N$ 字节**（混合精度）或 $16N$（纯 fp32 时 4+4+8=16N，但无主权重）。于是：

- 7B 模型：$16\times7\times10^{9}\ \text{字节}\approx 112\ \text{GB}$ → **单卡 80GB 放不下**，必须分片（ZeRO-2/3、FSDP）或换 8-bit 优化器（`bitsandbytes`，可把优化器状态压到 ~$2N$）。
- 1.5B 模型：$\approx 24\ \text{GB}$ 静态 + 激活 → 单张 40GB 卡通常可行（批要小）。
- 推理（仅前向）：权重 $2N$（bf16）即可，7B ≈ 14GB；KV cache 另算（见 [2.5](lectures/lec02/sec25.md)）。

**激活显存怎么估**：粗略按「每层激活张量数 × 元素数 × 字节数」累加，注意力层的 $B\!\cdot\!H\!\cdot\!T^2$ 往往是大头。**激活重计算（gradient checkpointing）**用「多算一遍前向」换显存，通常把激活降到 $O(\sqrt L)$ 量级——代价是约 30% 的前向额外开销。

**实操建议**：先按公式估，再用 `torch.cuda.max_memory_allocated()` 实测对账；两张表对不上时，差额往往来自碎片（`PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True`）或临时张量峰值。
:::

## 五、实验管理：让每一次训练都可追溯

::: method 流程 5 · 一次训练的最小记录集{#flow-log}
每次跑实验记录**六件事**：

1. **代码版本**：git commit hash（未提交的改动记 `git diff` 摘要）；深度学习论文复现失败的第一原因就是「不知道当时跑的哪版代码」。
2. **配置**：所有超参数进一个 `config.yaml`（Hydra / argparse 落盘），**不要写死在代码里**。
3. **随机种子**：数据划分、权重初始化、采样器分别是什么种子。
4. **数据版本**：数据集名字 + 划分方式 + 预处理脚本版本（划分泄漏是最隐蔽的错误）。
5. **曲线与指标**：训练/验证损失、学习率、梯度范数、吞吐（samples/s）、显存峰值。用 TensorBoard 或 W&B 一类的工具，**不要只靠终端滚动输出**。
6. **一次性结论**：跑完立刻写三行结论（最好的是什么、失败假设是什么、下一步做什么）。**没有结论的实验等于没做。**

**目录约定**（简单即可）：

```text
runs/2026-10-16-1432-baseline/
  config.yaml   # 完整配置
  metrics.jsonl # 每步/每轮的指标
  ckpt/         # 检查点（保留 best + last）
  notes.md      # 三行结论
```
:::

## 六、性能与吞吐：先证明瓶颈在哪

::: method 流程 6 · 提速四步（顺序不可颠倒）{#flow-perf}
1. **测基线**：报告 `samples/s` 或 `tokens/s`，并说明硬件、精度、批大小。
2. **找瓶颈**：`torch.profiler` 看 GPU 利用率与算子时间；**GPU 利用率低 = 数据管线或 Python 开销在卡脖子**，不是算力不够。
3. **改数据管线**：`DataLoader(num_workers=4~8, pin_memory=True, persistent_workers=True, prefetch_factor=2)`；把重预处理（解码、增强）挪到 worker 或用更快的库。
4. **再动计算**：混合精度（`torch.autocast("cuda", dtype=torch.bfloat16)` + `GradScaler` 仅在 fp16 下需要）、`torch.compile(model)`、算子融合、增大批大小（并同步调学习率——见[线性缩放规则](lectures/lec01/sec16.md)）。

**记住**：批大小翻倍不等于吞吐翻倍；先看瓶颈在数据还是计算，再决定改哪一头。（大规模并行训练的系统性做法见[第 9 讲](lectures/lec09/overview.md)。）
:::

## 七、调试小工具

| 需求 | 工具 | 一句话用法 |
|:--|:--|:--|
| 交互式断点 | `breakpoint()` / `pdb` | 在训练循环里插一行，直接查张量 |
| 张量健康检查 | 自写 `check_tensor(x)` | `torch.isnan(x).any()`、`x.abs().max()`、`x.std()` |
| 梯度健康检查 | `torch.autograd.gradcheck` | 手写层与数值梯度对比（[1.5 节](lectures/lec01/sec15.md)） |
| 前向/反向钩子 | `register_forward_hook` / `register_full_backward_hook` | 逐层打印形状与梯度范数 |
| 显存对账 | `torch.cuda.memory_summary()` | 定位碎片与峰值 |
| 确定性排查 | `torch.use_deterministic_algorithms(True)` | 先把随机性钉死，再找别的问题 |
| 单元测试 | `pytest` + 小张量 | 形状断言、mask 正确性、注意力权重和是否为 1 |

## 八、提交训练前的 20 条清单

::: method 上线前自检{#checklist-preflight}
**数据**：① 训练/验证/测试无重叠；② 归一化统计只来自训练集；③ 样本可视化过；④ 类别分布已知（含长尾）。
**代码**：⑤ 单样本过拟合通过；⑥ 形状断言齐全；⑦ 设备与 dtype 统一；⑧ 损失与输出层匹配（softmax 只做一次）。
**超参**：⑨ 学习率扫过；⑩ 批大小与学习率联动；⑪ 权重初始化明确；⑫ 梯度裁剪已开。
**训练**：⑬ 损失、学习率、梯度范数三条曲线都会记录；⑭ 种子固定且记录；⑮ 保存 best 与 last 检查点；⑯ 断点可续训。
**评估**：⑰ 指标口径与论文/基准一致；⑱ 报告多轮均值（不只挑最好的一轮）；⑮ 消融只改一个变量；⑳ 结论写进 `notes.md`。

**最后一条**：如果某条清单没打勾，就把它写进结论里——「没做」比「假装做了」安全得多。
:::

## 九、把这页接到正文

| 你现在遇到的事 | 回去读 |
|:--|:--|
| 形状推不出来 | [1.1 形状约定](lectures/lec01/sec11.md#method-1.1.1)、[1.2 前向推演](lectures/lec01/sec12.md) |
| 梯度不对/想手推 | [1.5 反向传播](lectures/lec01/sec15.md) |
| 学习率、优化器选择 | [1.6 优化器](lectures/lec01/sec16.md)（含线性缩放与 warmup） |
| 过拟合/欠拟合 | [1.7 泛化与正则化](lectures/lec01/sec17.md) |
| 序列长度爆显存 | [2.6 长序列与高效注意力](lectures/lec02/sec26.md) |
| 多卡训练与显存分片 | [第 9 讲](lectures/lec09/overview.md) |
| 想让实验结果可复现 | 本页第五节 + [附录 C](appendix/derivations.md) |
