# 项目总览与验收路线

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>全书的两个综合实战项目分别解决什么工业场景问题？项目的 Stage 阶段如何划分？验收的硬性质量门禁标准是什么？</p></div>
<div><span class="ci-label">读完你会</span><p>能从架构高度把握算法系统落地的两座里程碑；明确算法竞赛评测引擎与 A/B 测试因果分析流水线的设计边界；清晰知晓每个阶段必须交付的技术证据。</p></div>
</div>

## 0.1 两个工业级项目，两种核心价值

| 维度 | 项目一：算法竞赛评测系统 (OJ Engine) | 项目二：A/B 测试因果分析流水线 (A/B Pipeline) |
|:--|:--|:--|
| **对应章节** | 第 13 章 | 第 14 章 |
| **所属领域** | 高性能系统、代码安全沙箱、自动化判题 | 统计推断、实验设计、动态收益最大化 |
| **核心问题** | 如何安全、确定、高并发地运行不可信任的外部算法代码？ | 如何在最短实验时间内，消除背景噪声并给出可信因果结论？ |
| **核心挑战** | 纳秒级资源测量、防 Fork 炸弹、拦截非法系统调用、代码抄袭检测 | 假阳性控制、偷看早停（Peeking）防御、CUPED 降噪、异质效应识别 |
| **交付物** | 包含 seccomp 规则、cgroup 限流与 Winnowing 查重的评测执行器 | 包含 SRM 检验、CUPED 引擎、mSPRT 序贯器与 CATE 模型的分析包 |

---

## 0.2 项目一：算法竞赛评测系统的 Stage 验收路线

评测系统的实现分为 5 个循序渐进的阶段：

- **Stage 1 · 判题状态机与数据模型**：
  - 建立标准裁决模型（AC, WA, TLE, MLE, RE, CE）；
  - 实现输入输出比对器，支持浮点相对容差（Special Judge）。
- **Stage 2 · 资源测量与精确计时**：
  - 读取 Linux `/proc/[pid]/stat` 剥离系统抖动，只计用户态 + 内核态 CPU 运行 ticks；
  - 接入 cgroup `memory.peak` 捕捉瞬时物理内存最高水位（High-Water Mark）。
- **Stage 3 · 安全沙箱加固**：
  - 载入 `seccomp-bpf` 规则白名单，拦截任意网络 `socket`、进程派生 `clone/fork`；
  - 绑定 cgroup v2 控制器，设定 `pids.max = 1` 物理杜绝 Fork 炸弹。
- **Stage 4 · 自动化对拍测试（Stress Testing）**：
  - 构建随机用例与对抗图生成器，以暴力朴素算法为真值 Oracle 持续对拍。
- **Stage 5 · 代码抄袭检测引擎**：
  - 实现 Winnowing 局部敏感指纹算法，在变量名混淆下实现稳健查重。

**验收命令**：
```bash
python3 projects/planner/run_tests.py
```

---

## 0.3 项目二：A/B 测试因果分析流水线的 Stage 验收路线

A/B 测试流水线分为 5 个标准数据阶段：

- **Stage 1 · 样本量规划与功效预估**：
  - 输入 MDE 相对提升、基线均值与方差，自动输出单组所需样本量与功效曲线。
- **Stage 2 · 数据健康与 SRM 自动拦截**：
  - 实现卡方拟合优度检验，当出现样本比率不匹配（$p < 0.001$）时自动熔断。
- **Stage 3 · CUPED 方差缩减引擎**：
  - 利用实验前历史数据计算最优去偏系数 $\theta^*$，实测方差缩减比例需达 $30\% \sim 50\%$。
- **Stage 4 · 序贯检验（mSPRT）安全早停**：
  - 计算混合似然比统计量，提供支持随时查看仪表盘且假阳性严格 $\le 5\%$ 的早停准则。
- **Stage 5 · 多臂老虎机与 CATE Uplift 建模**：
  - 实现 UCB1 与 Thompson Sampling 动态调权；
  - 基于 T-Learner 预测个体处理效应并绘制增益累积曲线（Cumulative Gain）。

**验收命令**：
```bash
python3 projects/pipeline/run_tests.py
```
