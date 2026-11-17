# Lab3 决策表完整模板与评分标准

> **目标**：把Lab3从"跟着做"改造为"自己算trade-off"，让学生在约束条件下做出有依据的工程决策。

---

## 一、改造目标

### 当前问题
- 笔记本已经写好：`model="Llama-2-7b"`、`lora_rank=8`、`lr=2e-4`
- 学生只需要：`run_all_cells()`
- 学完后不知道：**为什么这么选**、**换成3B会怎样**、**显存不够怎么办**

### 改造后
- 给定**4个约束条件**（显存、数据、目标指标、硬件）
- 学生必须**自己算**4个决策点（模型大小、量化、LoRA配置、学习率）
- 提交物：**决策表**（预估vs实测）+ **ablation对比** + **生成样例**

---

## 二、约束条件（Lab3 Scenario）

```markdown
## 实验环境与目标

### 硬件约束
- **单卡**：NVIDIA A100-40GB（PCIe版，非SXM4）
- **显存可用**：约38GB（系统保留2GB）
- **推理延迟要求**：生成50-token序列，latency < 100ms

### 数据约束
- **训练集**：10,000条指令微调样例（alpaca格式）
- **验证集**：500条
- **不可更换**：数据集固定，不能引入外部数据

### 质量目标
- **困惑度（验证集）**：PPL < 6.5
- **生成质量**：通过3项基础能力测试（见下）
- **无灾难性遗忘**：base模型的常识问答准确率保持≥80%

### 时间约束
- **训练时长**：≤4小时（含验证）
- **推理吞吐**：≥20 tokens/s（批大小=1）
```

---

## 三、决策点清单（4个必选）

### 决策1：模型选型
| 选项 | 参数量 | FP16显存占用（仅权重） | 预期困惑度 | 推理延迟（50-token） |
|------|--------|----------------------|-----------|---------------------|
| Llama-3-1.2B | 1.2B | 2.4GB | 7.5–8.5 | ~25ms |
| Phi-3-mini-3B | 3B | 6GB | 6.0–7.0 | ~50ms |
| Llama-3-8B | 8B | 16GB | 5.5–6.5 | ~120ms ❌ 超限 |

**计算公式**：
```python
# 权重显存（FP16）
weight_memory_gb = params * 2 / (1024**3)

# 训练显存估算（含优化器状态+激活）
train_memory_gb = weight_memory_gb * 8  # Adam: 2(权重)+12(状态)+2(梯度)+激活
```

**你的选择**：________  
**理由**：________

---

### 决策2：量化策略
| 选项 | 权重精度 | 显存占用（vs FP16） | 困惑度影响 | 推理加速 |
|------|---------|-------------------|-----------|---------|
| FP16全精度 | 16-bit | 100% | 基线 | 1.0× |
| INT8-W | 8-bit权重，FP16激活 | ~60% | +0.2–0.5 PPL | 1.2–1.5× |
| INT4-AWQ | 4-bit权重+激活感知量化 | ~35% | +0.5–1.0 PPL | 1.5–2.0× |

**公式**：
```python
# INT8-W的显存节省（只压权重，激活仍是FP16）
int8_memory_gb = weight_memory_gb * 0.5 + activation_memory_gb

# 推理延迟（理论）
latency_ms = (params / throughput_tokens_per_sec) * token_count / batch_size
```

**你的选择**：________  
**trade-off分析**：________

---

### 决策3：LoRA配置
| 参数 | 选项 | 可训参数量 | 训练显存增量 | 质量影响 |
|------|------|-----------|-------------|---------|
| **rank** | 4 / 8 / 16 / 32 | 见公式 | ~rank×1.5GB | rank↑质量↑但边际递减 |
| **target_modules** | `["q_proj", "v_proj"]` | 最少 | 基线 | 足够 |
|  | `["q_proj", "k_proj", "v_proj", "o_proj"]` | +50% | +30%显存 | 略好 |
|  | 全部线性层 | +200% | +100%显存 | 边际收益<10% |
| **alpha** | rank / 2·rank / 4·rank | 不影响参数量 | 0 | 调节学习尺度 |

**可训参数量公式**：
```python
# 假设模型：L层，d_model维度，每层有Q/K/V/O四个投影
params_lora = 2 * rank * d_model * num_layers * num_target_modules

# 例：Llama-3-3B，rank=16，target=["q_proj","v_proj"]
# d_model=3072, L=32, target=2
params_lora = 2 * 16 * 3072 * 32 * 2 = 6,291,456  # ~6M
```

**你的配置**：
- rank = ________
- target_modules = ________
- alpha = ________
- **预估可训参数**：________ M
- **实测可训参数**（运行后填）：________ M
- **误差**：________%

---

### 决策4：学习率schedule
| 学习率 | warmup步数 | 预期行为 | 风险 |
|--------|-----------|---------|------|
| **2e-5** | 100 | 稳定但慢，可能欠拟合 | 4小时内可能不收敛 |
| **1e-4** | 200 | 平衡选择 | 中等风险 |
| **5e-4** | 500 | 快速收敛 | 高风险：可能震荡或遗忘base能力 |

**必做**：plot学习率曲线 vs loss曲线，找拐点。

**你的选择**：________  
**warmup理由**：________

---

## 四、决策表（提交模板）

```markdown
# Lab3 LoRA微调决策报告

## 学生信息
- 姓名：________
- 学号：________
- 实验日期：________

---

## 决策汇总表

| 决策点 | 选项 | 预估指标 | 实测指标 | 误差 | 备注 |
|--------|------|---------|---------|------|------|
| **模型** | Phi-3-mini-3B | 显存26GB | ___GB | ___% | |
| **量化** | INT8-W | 困惑度+0.3 | PPL=___ | ___ | |
| **LoRA rank** | 16 | 可训参数6.3M | ___M | ___% | |
| **LoRA target** | q_proj, v_proj | — | — | — | |
| **学习率** | 1e-4 | 收敛于2.5h | ___h | ___ | |

---

## 计算过程（必填，每项给公式+数值）

### 1. 显存预算

**权重**：3B × 1字节（INT8） = 3GB  
**优化器状态**（LoRA参数）：6.3M × 12字节 = 75.6MB  
**激活**（gradient checkpointing开启）：  
```python
# 公式：L × B × T × d × 2（BF16）
activation_gb = 32 × 1 × 512 × 3072 × 2 / (1024**3)
             ≈ 0.1 GB
```
**梯度**：6.3M × 2字节 = 12.6MB  
**KV cache**（推理）：  
```python
# 公式：2 × L × n_kv × T × d_h × B × 2
kv_cache_gb = 2 × 32 × 32 × 512 × 96 × 1 × 2 / (1024**3)
            ≈ 0.38 GB
```

**预估总和**：3 + 0.076 + 0.1 + 0.013 + 0.38 ≈ **3.57 GB** ✓（远低于38GB上限）

**实测峰值**（nvidia-smi）：________ GB

---

### 2. 推理延迟分析

**公式**：
```python
# 单token生成时间（prefill后的decode阶段）
ms_per_token = (FLOPs_per_token / GPU_TFLOPs) * 1000

# Phi-3-mini-3B在A100上
# FLOPs ≈ 2 × 3e9（前向）
# A100 INT8 Tensor Core峰值：624 TFLOPS（理论）
# 实际利用率：~40%（memory-bound）

ms_per_token ≈ (2 × 3e9) / (624e12 × 0.4) × 1000
             ≈ 24 ms/token

# 50-token生成
latency_50 = 24 × 50 = 1200 ms
```

**结论**：不满足<100ms要求，但任务本身是**训练验收**，推理延迟作为**参考指标**

**实测**（time.time()包裹generate）：________ ms

---

### 3. 困惑度预估

根据Hugging Face leaderboard的scaling law：
- Base PPL（Phi-3-mini-3B on validation）：~7.2
- LoRA微调后（10k样本）：预期降至 **6.5–7.0**

**实测验证集PPL**：________

---

## Ablation实验（固定其他变量，单独改rank）

| LoRA rank | 可训参数 | 验证PPL | 训练时长 | 推理latency |
|-----------|---------|---------|---------|------------|
| 4 | ___M | ___ | ___h | ___ms |
| **16**（你的选择） | ___M | ___ | ___h | ___ms |
| 32 | ___M | ___ | ___h | ___ms |

**发现**：rank从4→16，PPL降低___；16→32，PPL只降低___（边际递减）

---

## 生成样例（灾难性遗忘检验）

### Base能力测试（3题）

**Q1**：世界上最高的山峰是？  
**Base模型**：珠穆朗玛峰  
**微调后**：________

**Q2**：写一个Python函数计算斐波那契数列第n项。  
**Base模型**：（正确代码）  
**微调后**：________

**Q3**：解释什么是"温室效应"。  
**Base模型**：（科学解释）  
**微调后**：________

**结论**：3题中答对___题，base能力保持率 = ____%

---

## 反思与改进

1. **最大的坑**：________（如显存OOM、学习率过大导致loss爆炸）
2. **如果重做**：会把________改成________，因为________
3. **量化的代价**：INT8-W让困惑度上升了___，但显存节省了___GB，trade-off是否值得？________

---

## 附件
- [ ] `training_log.txt`（完整训练日志）
- [ ] `lr_vs_loss.png`（学习率曲线+loss曲线）
- [ ] `ablation_rank.png`（rank ablation对比图）
- [ ] `generate_samples.txt`（至少10条生成样例）
```

---

## 五、自动评分脚本

```python
#!/usr/bin/env python3
"""
Lab3自动评分脚本
检查项：
1. 决策表完整性（每格都填了）
2. 计算公式正确性（显存/参数量/延迟）
3. 预估vs实测误差（<20%为合格）
4. Ablation实验完整性（至少3个rank）
5. 生成样例质量（base能力保持≥80%）

用法：
python grade_lab3.py --report decision_report.md --log training_log.txt
"""

import re
import json
from pathlib import Path

class Lab3Grader:
    def __init__(self, report_path, log_path):
        self.report = Path(report_path).read_text()
        self.log = Path(log_path).read_text() if log_path else ""
        self.score = 0
        self.feedback = []
    
    def check_completeness(self):
        """检查决策表是否填完（每个____都填了）"""
        blanks = len(re.findall(r'_{3,}', self.report))
        if blanks > 5:  # 允许少量未填（如可选项）
            self.feedback.append(f"❌ 决策表未填完，剩余{blanks}个空白")
            return 0
        else:
            self.feedback.append("✅ 决策表完整")
            return 10
    
    def check_memory_calculation(self):
        """检查显存计算公式是否正确"""
        # 提取"权重显存"那一行的数值
        match = re.search(r'权重.*?(\d+\.?\d*)GB', self.report)
        if not match:
            self.feedback.append("❌ 未找到权重显存计算")
            return 0
        
        weight_gb = float(match.group(1))
        
        # 检查公式：3B × 2字节(FP16) = 6GB；3B × 1字节(INT8) = 3GB
        if "INT8" in self.report:
            expected = 3.0
        else:
            expected = 6.0
        
        error_pct = abs(weight_gb - expected) / expected * 100
        if error_pct < 10:
            self.feedback.append(f"✅ 权重显存计算正确（{weight_gb}GB，误差{error_pct:.1f}%）")
            return 15
        else:
            self.feedback.append(f"❌ 权重显存计算错误（应为{expected}GB，实际{weight_gb}GB）")
            return 0
    
    def check_lora_params(self):
        """检查LoRA参数量公式"""
        # 提取"可训参数"那一行
        match = re.search(r'可训参数.*?(\d+\.?\d*)\s*M', self.report)
        if not match:
            self.feedback.append("❌ 未找到LoRA参数量计算")
            return 0
        
        params_m = float(match.group(1))
        
        # 粗略验证：rank=16, d=3072, L=32, target=2
        # 公式：2 × rank × d × L × target / 1e6
        rank_match = re.search(r'rank\s*=\s*(\d+)', self.report)
        if rank_match:
            rank = int(rank_match.group(1))
            expected = 2 * rank * 3072 * 32 * 2 / 1e6  # ~6.3M for rank=16
            error_pct = abs(params_m - expected) / expected * 100
            if error_pct < 20:
                self.feedback.append(f"✅ LoRA参数量正确（{params_m}M）")
                return 15
        
        self.feedback.append("⚠️  LoRA参数量无法验证（需手动检查）")
        return 10
    
    def check_ablation(self):
        """检查ablation表格是否有至少3组对比"""
        # 查找"LoRA rank"表格
        ablation_section = re.search(
            r'## Ablation实验.*?(\|.*?\|.*?\n)+',
            self.report,
            re.DOTALL
        )
        if not ablation_section:
            self.feedback.append("❌ 缺少ablation实验")
            return 0
        
        # 统计有数据的行（非表头）
        rows = re.findall(r'\|\s*\d+\s*\|.*?\|', ablation_section.group(0))
        if len(rows) >= 3:
            self.feedback.append(f"✅ Ablation实验完整（{len(rows)}组）")
            return 20
        else:
            self.feedback.append(f"❌ Ablation实验不足（只有{len(rows)}组，需要≥3组）")
            return 10
    
    def check_generation_quality(self):
        """检查生成样例（base能力保持率）"""
        match = re.search(r'base能力保持率\s*=\s*(\d+)', self.report)
        if not match:
            self.feedback.append("❌ 未找到base能力保持率")
            return 0
        
        retention = int(match.group(1))
        if retention >= 80:
            self.feedback.append(f"✅ Base能力保持{retention}%（≥80%）")
            return 20
        else:
            self.feedback.append(f"⚠️  Base能力下降（只有{retention}%，目标≥80%）")
            return 10
    
    def check_final_ppl(self):
        """检查最终困惑度是否达标"""
        match = re.search(r'实测验证集PPL.*?(\d+\.?\d*)', self.report)
        if not match:
            self.feedback.append("❌ 未找到最终PPL")
            return 0
        
        ppl = float(match.group(1))
        if ppl < 6.5:
            self.feedback.append(f"✅ 困惑度达标（PPL={ppl} < 6.5）")
            return 20
        elif ppl < 7.5:
            self.feedback.append(f"⚠️  困惑度接近（PPL={ppl}，目标<6.5）")
            return 15
        else:
            self.feedback.append(f"❌ 困惑度未达标（PPL={ppl} ≥ 7.5）")
            return 5
    
    def grade(self):
        """执行全部检查"""
        self.score += self.check_completeness()      # 10分
        self.score += self.check_memory_calculation() # 15分
        self.score += self.check_lora_params()        # 15分
        self.score += self.check_ablation()           # 20分
        self.score += self.check_generation_quality() # 20分
        self.score += self.check_final_ppl()          # 20分
        
        # 输出结果
        print("\n" + "="*60)
        print("Lab3 自动评分报告")
        print("="*60)
        for fb in self.feedback:
            print(fb)
        print("="*60)
        print(f"总分：{self.score} / 100")
        print("="*60)
        
        return self.score

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", required=True, help="决策报告markdown文件")
    parser.add_argument("--log", help="训练日志txt文件（可选）")
    args = parser.parse_args()
    
    grader = Lab3Grader(args.report, args.log)
    score = grader.grade()
    
    # 返回码：满分0，不满分1
    exit(0 if score == 100 else 1)
```

---

## 六、辅助工具：显存/参数量计算器

```python
#!/usr/bin/env python3
"""
Lab3 显存与参数量计算器
用法：
python lab3_calculator.py --model llama-3-3b --quant int8 --lora-rank 16
"""

def calc_memory(model_size_b, quant="fp16", lora_rank=0, batch_size=1, seq_len=512):
    """
    计算训练显存占用
    
    Args:
        model_size_b: 模型参数量（单位：十亿）
        quant: 量化方式（fp16/int8/int4）
        lora_rank: LoRA rank（0表示全参数微调）
        batch_size: 批大小
        seq_len: 序列长度
    
    Returns:
        dict: 各项显存占用（GB）
    """
    bytes_per_param = {"fp16": 2, "int8": 1, "int4": 0.5}[quant]
    
    # 1. 权重
    weight_gb = model_size_b * bytes_per_param
    
    # 2. 优化器状态（Adam：momentum + variance，各占与梯度相同的空间）
    if lora_rank > 0:
        # LoRA: 只训练adapter参数
        # 近似：2 * rank * d_model * num_layers * num_targets / 1e9
        # 假设3B模型：d=3072, L=32, targets=2
        trainable_params_b = 2 * lora_rank * 3072 * 32 * 2 / 1e9
        optimizer_gb = trainable_params_b * 12  # Adam: 4(param) + 4(m) + 4(v)
    else:
        # 全参数微调
        optimizer_gb = model_size_b * 12
    
    # 3. 梯度
    gradient_gb = trainable_params_b * 2 if lora_rank > 0 else model_size_b * 2
    
    # 4. 激活（gradient checkpointing假设开启，只保留每层输入）
    # 公式：L * B * T * d * 2（BF16）
    # 3B模型近似：L=32, d=3072
    activation_gb = 32 * batch_size * seq_len * 3072 * 2 / (1024**3)
    
    # 5. KV cache（推理时）
    # 公式：2(K+V) * L * n_heads * T * d_head * B * 2
    # 3B模型：L=32, n_heads=32, d_head=96
    kv_cache_gb = 2 * 32 * 32 * seq_len * 96 * batch_size * 2 / (1024**3)
    
    total_train_gb = weight_gb + optimizer_gb + gradient_gb + activation_gb
    total_infer_gb = weight_gb + kv_cache_gb
    
    return {
        "weight": weight_gb,
        "optimizer": optimizer_gb,
        "gradient": gradient_gb,
        "activation": activation_gb,
        "kv_cache": kv_cache_gb,
        "total_train": total_train_gb,
        "total_infer": total_infer_gb
    }

def calc_lora_params(model_size_b, lora_rank, target_modules=["q_proj", "v_proj"]):
    """计算LoRA可训参数量"""
    # 近似：d_model ≈ sqrt(model_size_b * 1e9 / num_layers)
    # 3B模型：d=3072, L=32
    d_model = 3072
    num_layers = 32
    num_targets = len(target_modules)
    
    params = 2 * lora_rank * d_model * num_layers * num_targets
    return params / 1e6  # 返回百万为单位

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", choices=["llama-3-1.2b", "phi-3-3b", "llama-3-8b"], required=True)
    parser.add_argument("--quant", choices=["fp16", "int8", "int4"], default="fp16")
    parser.add_argument("--lora-rank", type=int, default=0)
    parser.add_argument("--batch-size", type=int, default=1)
    parser.add_argument("--seq-len", type=int, default=512)
    args = parser.parse_args()
    
    model_sizes = {"llama-3-1.2b": 1.2, "phi-3-3b": 3.0, "llama-3-8b": 8.0}
    model_size_b = model_sizes[args.model]
    
    mem = calc_memory(model_size_b, args.quant, args.lora_rank, args.batch_size, args.seq_len)
    lora_params_m = calc_lora_params(model_size_b, args.lora_rank) if args.lora_rank > 0 else 0
    
    print(f"\n{'='*60}")
    print(f"模型：{args.model} ({model_size_b}B参数)")
    print(f"量化：{args.quant}")
    print(f"LoRA rank：{args.lora_rank} → 可训参数：{lora_params_m:.2f}M")
    print(f"批大小：{args.batch_size}，序列长度：{args.seq_len}")
    print(f"{'='*60}")
    print(f"权重显存：       {mem['weight']:.2f} GB")
    print(f"优化器状态：     {mem['optimizer']:.2f} GB")
    print(f"梯度：           {mem['gradient']:.2f} GB")
    print(f"激活（训练）：   {mem['activation']:.2f} GB")
    print(f"KV cache（推理）：{mem['kv_cache']:.2f} GB")
    print(f"{'='*60}")
    print(f"训练峰值显存：   {mem['total_train']:.2f} GB")
    print(f"推理峰值显存：   {mem['total_infer']:.2f} GB")
    print(f"{'='*60}\n")
    
    # 判断是否超出A100-40GB限制
    if mem['total_train'] > 38:
        print("⚠️  警告：训练显存超出A100-40GB限制！")
        print("建议：")
        if args.quant == "fp16":
            print("  - 尝试INT8量化（显存降至~60%）")
        if args.lora_rank == 0:
            print("  - 必须使用LoRA（推荐rank=8或16）")
        if args.batch_size > 1:
            print("  - 降低batch_size到1")
```

---

## 七、使用流程（教师视角）

### Week 1：发布任务
1. 在课程平台发布：
   - `lab3_decision_template.md`（决策表模板）
   - `lab3_calculator.py`（计算器）
   - `grade_lab3.py`（评分脚本）
2. 要求学生**先用计算器**算出各选项的显存/参数量，再决定

### Week 2：中期检查
- 学生提交**初步决策表**（只填预估列）
- TA运行计算器验证公式是否正确
- 反馈："你的INT8显存算错了，应该是3GB而不是6GB"

### Week 3：实验与迭代
- 学生训练模型，填写**实测列**
- 对比预估vs实测，分析误差来源
- 至少做一次ablation（改rank）

### Week 4：提交与评分
- 提交`decision_report.md` + `training_log.txt` + ablation图
- TA运行：`python grade_lab3.py --report decision_report.md --log training_log.txt`
- 自动给出初步分数（60%权重），人工审核生成样例质量（40%权重）

---

## 八、常见问题FAQ

### Q1：学生算出的显存需求超过40GB怎么办？
**A**：这正是决策训练的价值！引导学生：
1. 换小模型（8B → 3B）
2. 开INT8量化（显存降40%）
3. 用gradient checkpointing（激活降至1/10）
4. 降低batch_size到1

### Q2：ablation实验需要训练多次，时间成本高？
**A**：可以**降低训练步数**（如500步 vs 完整的5000步），只看趋势不看收敛。或者提供**预训练checkpoint**，学生只需fine-tune最后几百步。

### Q3：困惑度达不到6.5怎么办？
**A**：设置**阶梯目标**：
- PPL < 6.5：满分
- 6.5 ≤ PPL < 7.5：80%分数
- PPL ≥ 7.5但完成决策表：60%分数

### Q4：学生直接抄别人的决策表？
**A**：要求提交：
- `training_log.txt`（时间戳不可伪造）
- ablation图（每个人的曲线应该略有不同）
- 最后增加**答辩环节**："为什么你选rank=16而不是32？"

---

## 九、与原Lab3的对比

| 维度 | 原Lab3 | 改造后Lab3 |
|------|--------|-----------|
| **学习目标** | 跑通LoRA流程 | 理解显存/参数量/质量的trade-off |
| **决策空间** | 无（参数已写死） | 4个决策点×3–4个选项 |
| **提交物** | 笔记本+生成样例 | 决策表+计算过程+ablation图 |
| **评分标准** | "能跑"即80分 | 公式正确性（30%）+实测误差（30%）+质量（40%） |
| **时间成本** | 1–2小时 | 4–6小时（含ablation） |
| **可迁移技能** | 调包 | **工程决策能力**（显存预算、模型选型） |

---

## 十、Phase 1 执行清单

- [x] 编写决策表模板（markdown）
- [x] 设计评分标准（6大检查项）
- [x] 实现自动评分脚本（Python）
- [x] 实现显存/参数量计算器
- [ ] **下一步**：编写新的`lab3_README.md`（替换现有README）
- [ ] **下一步**：设计ablation对比图的绘图脚本
