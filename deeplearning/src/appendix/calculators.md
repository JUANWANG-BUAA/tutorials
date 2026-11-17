# 附录 D · 显存与 LoRA 参数计算器

这两个计算器在浏览器本地运行，不上传输入，也不请求远端服务。修改字段后结果即时更新；也可按 Enter 或选择“重新计算”。禁用 JavaScript 时，请用下面的公式手算。

<style>
.dl-calculator { border: 1px solid var(--line, #888); padding: 1rem; margin: 1.5rem 0; }
.dl-calculator .calc-fields { display: grid; grid-template-columns: repeat(auto-fit, minmax(210px, 1fr)); gap: 1rem; margin: 1rem 0; }
.dl-calculator .calc-fields label { display: flex; flex-direction: column; gap: .35rem; }
.dl-calculator input[type="number"], .dl-calculator select { box-sizing: border-box; width: 100%; padding: .5rem; color: inherit; background: var(--bg, transparent); border: 1px solid var(--line, #888); font: inherit; }
.dl-calculator button { padding: .5rem 1rem; font: inherit; cursor: pointer; }
.dl-calculator [aria-invalid="true"] { outline: 2px solid var(--fg, currentColor); }
.dl-calculator .calc-error { font-weight: bold; }
.dl-calculator .calc-result { font-variant-numeric: tabular-nums; }
.dl-calculator .calc-scroll { max-width: 100%; overflow-x: auto; }
.dl-calculator table { width: 100%; }
.dl-calculator caption { text-align: left; font-weight: bold; margin: .7rem 0; }
.dl-calculator :focus-visible { outline: 2px solid var(--fg, currentColor); outline-offset: 3px; }
</style>

## 1. 混合精度 Adam：每卡静态状态

本工具沿用 [9.1 的混合精度 Adam 账本](../lectures/lec09/sec91.md)：低精度参数与梯度各 2 字节，FP32 主权重、一阶矩、二阶矩各 4 字节。因此未分片时合计为 $16N$ 字节。这里假设全部 $N$ 个参数参与训练，不含 CPU/NVMe offload、张量并行或流水线并行。

<form id="adam-calculator" class="dl-calculator" novalidate aria-label="混合精度 Adam 显存估算">
  <div class="calc-fields">
    <label for="adam-parameters">模型参数总数 N（个；7B = 7,000,000,000）<input id="adam-parameters" name="parameters" type="number" min="1" max="1000000000000" step="1" value="7000000000" required aria-describedby="adam-error"></label>
    <label for="adam-gpus">数据并行分片组 GPU 数 k（张）<input id="adam-gpus" name="gpus" type="number" min="1" max="1000000" step="1" value="8" required aria-describedby="adam-error"></label>
    <label for="adam-stage">查看的策略<select id="adam-stage" name="stage"><option value="0">DP / ZeRO-0：全部复制</option><option value="1">ZeRO-1：分片优化器相关状态</option><option value="2" selected>ZeRO-2：再分片梯度</option><option value="3">ZeRO-3：再分片参数</option></select></label>
  </div>
  <p><label for="adam-extras"><input id="adam-extras" name="extras" type="checkbox"> 加入自行估计的每卡激活与额外缓冲（不随 k 自动均分）</label></p>
  <div class="calc-fields">
    <label for="adam-activation">每卡激活估计<input id="adam-activation" name="activation" type="number" min="0" max="1000000" step="any" value="0" disabled aria-describedby="adam-error"></label>
    <label for="adam-buffer">每卡额外缓冲 / 工作区估计<input id="adam-buffer" name="buffer" type="number" min="0" max="1000000" step="any" value="0" disabled aria-describedby="adam-error"></label>
    <label for="adam-unit">上述两项的输入单位<select id="adam-unit" name="unit" disabled><option value="GB">GB（10⁹ 字节）</option><option value="GiB">GiB（2³⁰ 字节）</option></select></label>
  </div>
  <button type="submit">重新计算显存</button>
  <p id="adam-error" class="calc-error" role="alert"></p>
  <div id="adam-result" class="calc-result" role="status" aria-live="polite" aria-atomic="true"></div>
  <noscript><p>计算器需要启用 JavaScript。默认 ZeRO-2：2N + 14N/k = 26.25 GB，约 24.447 GiB。</p></noscript>
</form>

### 怎样复算与解释结果

所有除法都按理想均匀分片估计，忽略分片对齐和不均衡。优化器相关的 $12N$ 包括 FP32 主权重 $4N$ 及 Adam 的两个矩 $8N$。

| 策略 | 每卡低精度参数 | 每卡低精度梯度 | 每卡优化器相关状态 | 每卡静态合计（字节） |
|---|---:|---:|---:|---:|
| DP / ZeRO-0 | $2N$ | $2N$ | $12N$ | $16N$ |
| ZeRO-1 | $2N$ | $2N$ | $12N/k$ | $4N+12N/k$ |
| ZeRO-2 | $2N$ | $2N/k$ | $12N/k$ | $2N+14N/k$ |
| ZeRO-3 | $2N/k$ | $2N/k$ | $12N/k$ | $16N/k$ |

默认 $N=7\times10^9$、$k=8$，ZeRO-2 的参数为 14 GB、梯度为 1.75 GB、主权重为 3.5 GB、两个矩各 3.5 GB，相加为 **26.25 GB ≈ 24.447 GiB / 卡**。换成 ZeRO-3 得 14 GB / 卡，但这不代表训练峰值只有 14 GB。

- **GB 与 GiB 不同**：1 GB = $10^9$ 字节，1 GiB = $2^{30}$ 字节；输出的两列表示同一份内存，不能相加。
- **静态状态不是实际峰值**：ZeRO-3 在计算前临时 all-gather 参数；通信 bucket、预取、算子工作区、CUDA 上下文和分配器缓存等也可能占显存。缓冲估计只能计一次，且是否与激活同时存活要按运行时间线判断。
- **额外输入不是自动预测**：工具只把你输入的激活和缓冲加到静态账本上，得到预算合计，不保证该预算就是实际峰值，也不判断能否装入某张卡。激活随 micro-batch、序列长度、结构、重计算等变化。
- **数据类型与实现会改账本**：梯度若保留 FP32、没有独立主权重、使用低比特优化器或量化权重，字节系数会变；这里不模拟这些配置。应在目标训练配置下实测 allocated / reserved 峰值，并记录采集方法。参见 [9.2 数据并行](../lectures/lec09/sec92.md) 与 [9.5 显存优化](../lectures/lec09/sec95.md)。

## 2. LoRA：一组同形状线性层的新增参数

对一个 $W\in\mathbb R^{out\times in}$，LoRA 使用 $A\in\mathbb R^{r\times in}$、$B\in\mathbb R^{out\times r}$，新增参数为 $r(in+out)$。下面的“矩阵个数”指**实际注入的同形状线性权重矩阵数**，不一定等于 Transformer block 数。

<form id="lora-calculator" class="dl-calculator" novalidate aria-label="LoRA 新增参数计算">
  <div class="calc-fields">
    <label for="lora-rank">LoRA rank r<input id="lora-rank" name="rank" type="number" min="1" max="1000000000" step="1" value="16" required aria-describedby="lora-error"></label>
    <label for="lora-in">线性层输入维度 in<input id="lora-in" name="input" type="number" min="1" max="1000000000" step="1" value="1024" required aria-describedby="lora-error"></label>
    <label for="lora-out">线性层输出维度 out<input id="lora-out" name="output" type="number" min="1" max="1000000000" step="1" value="1024" required aria-describedby="lora-error"></label>
    <label for="lora-count">同形状矩阵个数 L<input id="lora-count" name="count" type="number" min="1" max="1000000000" step="1" value="1" required aria-describedby="lora-error"></label>
    <label for="lora-base">基座参数总数（可选，留空则不算百分比）<input id="lora-base" name="base" type="number" min="1" max="9007199254740991" step="1" placeholder="例如 7000000000" aria-describedby="lora-error"></label>
  </div>
  <button type="submit">重新计算 LoRA 参数</button>
  <p id="lora-error" class="calc-error" role="alert"></p>
  <div id="lora-result" class="calc-result" role="status" aria-live="polite" aria-atomic="true"></div>
  <noscript><p>计算器需要启用 JavaScript。默认新增 16 × (1024 + 1024) × 1 = 32,768 个参数。</p></noscript>
</form>

默认例子：$16(1024+1024)\times1=32768$。若矩阵个数改成 12，得到 393,216。若再输入基座参数数 7,000,000,000，比例为新增参数 / 基座参数 × 100%，而不是除以“基座 + 新增”。这些都是指定形状的算术例子，不对应某个模型的实际结构。

**不要把全部投影当成相同尺寸。** Q/K/V/O 投影、分组查询注意力中的 K/V 和 MLP 投影可能尺寸不同。应按形状分组分别计算，再相加：$\sum_j r_j(in_j+out_j)L_j$；共享的可训练矩阵只计一次。例如一组 $1024\times1024$ 与一组 $4096\times1024$、各一个矩阵、均取 $r=16$，合计 $32768+81920=114688$ 个新增参数。额外训练的 bias、embedding 或其他模块需另计。本工具不把参数数直接当显存；冻结基座仍要驻留，训练的激活、梯度和优化器状态也要另算。实际目标模块与参数核对方法见 [Lab 3](../labs/lab3.md)。
