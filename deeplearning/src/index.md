<section class="chapter-cover">
<div class="kicker">深 度 学 习 导 论 · 定 制 教 程</div>
<h1>从神经元到世界模型：深度学习的一条主线</h1>
<div class="subtitle">依据 MIT 6.S191《Introduction to Deep Learning》整理扩充，把九讲精编为「节页 + 讲末脚手架 + 复习与特训」的完整体系，并接上三个动手实验。</div>
<div class="cover-chips">
<span>九讲正文 · 47 节</span>
<span>每讲附习题 / 自检 / 回忆卡 / 自测卷</span>
<span>三个 Lab 逐行讲解</span>
<span>面试竞技场与综合自测卷</span>
</div>
<details class="cover-details">
<summary>查看课程范围与资料说明</summary>
<div class="meta">
依据 <b>MIT 6.S191《Introduction to Deep Learning》</b>（公开课，官网 introtodeeplearning.com）的九讲主题与三个软件实验整理扩充。本教程按「一个范式、四条支线」重组：所有网络都是「定义结构 → 定义损失 → 梯度下降」的实例，而序列、视觉、生成、决策四条支线共享同一套训练语言。公式与结论经本地复算核对；涉及 2023–2025 年的前沿内容均标注来源与「需核实」事项，代码示例依赖 TensorFlow / PyTorch 的公开接口。
</div>
</details>
</section>

<section class="study-paths" aria-label="建议学习路径">
<article class="study-path">
<span class="path-kicker">25 MIN · QUICK START</span>
<strong>先看懂主线</strong>
<p>先读知识地图与九讲导览，建立「表示 → 损失 → 优化 → 泛化 → 规模化」的全局图。</p>
<a href="preface-map.md">开始快速预习 →</a>
</article>
<article class="study-path">
<span class="path-kicker">ENTRY TEST · 15 MIN</span>
<strong>先测出自己的起点</strong>
<p>先做入学诊断自测，按得分决定是从第 1 讲通读，还是直接跳到序列或视觉。</p>
<a href="entry-test.md">进入诊断自测 →</a>
</article>
<article class="study-path">
<span class="path-kicker">120 MIN · STANDARD</span>
<strong>按讲次通读</strong>
<p>每讲先看导览与学习简报，顺着「直觉」框读概念白话版；证明与推导第一遍跳过，二刷再补。</p>
<a href="lectures/lec01/overview.md">从第 1 讲开始 →</a>
</article>
<article class="study-path">
<span class="path-kicker">HANDS-ON · THREE LABS</span>
<strong>动手跑三个实验</strong>
<p>音乐生成、人脸检测、大模型微调——每个 Lab 给出数据、模型、训练的逐行解释与排错清单。</p>
<a href="labs/lab1.md">进入 Lab 1 →</a>
</article>
<article class="study-path">
<span class="path-kicker">REVIEW · 2 HOURS</span>
<strong>考前一晚只看这几页</strong>
<p>公式与结论卡 → 速查背记卡 → 易混对照卡 → 最小必读路径；把九讲骨架压缩到一次翻完。</p>
<a href="review/study-paths.md">进入复习层 →</a>
</article>
<article class="study-path">
<span class="path-kicker">INTERVIEW · ARENA</span>
<strong>把「知道」练成「讲得出」</strong>
<p>面试与答辩竞技场：60 秒速答、5 分钟白板、10 分钟系统设计三轮计时特训。</p>
<a href="training/arena.md">进入竞技场 →</a>
</article>
</section>

## 本教程怎么读

全书按「卷首 → 学前准备 → 九讲正文 → 三个实验 → 复习与查阅 → 特训 → 习题与项目 → 附录」组织。**正讲是「学」的地方，讲末脚手架是「查」和「练」的地方，复习层是「记」的地方，特训层是「输出」的地方**。

每一讲的结构固定：**讲导览**（节一览表 + 本讲地图）→ **节页**（动机 → 定义 → 直觉 → 推导 → 例题 → 代码 → 陷阱 → 即时自测）→ **讲末六件套**（总结、勘误、习题、自检表、回忆卡、自测卷）。每讲页首另有「10 分钟复习版」盒子，把全讲压成一页必记结论——预习时先读它，复习时只读它。

左侧目录是唯一的导航入口，页面顶部有全文搜索（或按 <kbd>/</kbd>），页脚与键盘 <kbd>←</kbd> <kbd>→</kbd> 可翻页。

<div class="index-cards">
<a href="prerequisite.md">
  <span class="no">0</span>
  <span class="t">学前准备 · 诊断自测与先修工具箱</span>
  <span class="d">10 道诊断题（含答案与去向建议） · 线性代数 / 概率 / 微分的速查 · 张量形状约定 · 自动微分直觉</span>
  <span class="go">进入 →</span>
</a>
<a href="toolbox.md">
  <span class="no">0+</span>
  <span class="t">工程工具箱 · 环境、形状、排查与显存</span>
  <span class="d">可复现环境 · 张量形状四步排查 · 训练不收敛排查树 · 显存五账单与 16N 规则 · 实验管理 · 性能四步</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec01/overview.md">
  <span class="no">1</span>
  <span class="t">深度学习导论</span>
  <span class="d">神经元与感知机 · MLP 与通用逼近 · 激活函数 · 损失与反向传播 · 优化器 · 泛化与归一化</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec02/overview.md">
  <span class="no">2</span>
  <span class="t">深度序列建模</span>
  <span class="d">RNN 与 BPTT · LSTM/GRU · 注意力机制 · Transformer · RoPE/GQA/FlashAttention · Mamba 与 MoE</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec03/overview.md">
  <span class="no">3</span>
  <span class="t">深度计算机视觉</span>
  <span class="d">卷积与感受野 · 经典骨干演进 · ViT 与现代架构 · 迁移与自监督 · 检测分割 · 多模态 · 偏见与对抗</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec04/overview.md">
  <span class="no">4</span>
  <span class="t">深度生成建模</span>
  <span class="d">自编码器与 VAE · GAN · 扩散与 CFG · 潜空间扩散与整流流 · VQ 家族与自回归生成 · 选型谱系</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec05/overview.md">
  <span class="no">5</span>
  <span class="t">深度强化学习</span>
  <span class="d">MDP 与贝尔曼 · DQN · 策略梯度与 GAE · PPO · 离线 RL / RLHF / DPO / GRPO</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec06/overview.md">
  <span class="no">6</span>
  <span class="t">新前沿</span>
  <span class="d">大模型三段式 · 缩放律与涌现之争 · 推理模型与测试时计算 · 多模态 · VLA · 智能体 · 评测污染</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec07/overview.md">
  <span class="no">7</span>
  <span class="t">AI 的三条法则</span>
  <span class="d">可控与对齐 · 可解释与信任（SAE / 校准 / 水印）· 公平与责任 · 风险框架 · 安全即设计约束</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec08/overview.md">
  <span class="no">8</span>
  <span class="t">AI for Science</span>
  <span class="d">蛋白质与分子 · 材料设计 · 神经算子与 PINN · 气候预报 · 拟合与理解的边界</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec09/overview.md">
  <span class="no">9</span>
  <span class="t">大规模并行训练</span>
  <span class="d">显存五账单 · DP/ZeRO/FSDP · 张量并行 · 流水线并行与气泡 · 混合精度 · LoRA · 通信与容错</span>
  <span class="go">进入 →</span>
</a>
<a href="labs/lab1.md">
  <span class="no">Lab 1</span>
  <span class="t">深度学习入门与音乐生成</span>
  <span class="d">张量与自动微分 · 手写一层网络 · 字符级 RNN 生成旋律 · 温度采样与评估</span>
  <span class="go">进入 →</span>
</a>
<a href="labs/lab2.md">
  <span class="no">Lab 2</span>
  <span class="t">人脸检测系统</span>
  <span class="d">滑动窗口与 CNN 检测 · 数据管线与增强 · 训练与评估 · 对抗样本与隐私讨论</span>
  <span class="go">进入 →</span>
</a>
<a href="labs/lab3.md">
  <span class="no">Lab 3</span>
  <span class="t">微调一个大语言模型</span>
  <span class="d">加载预训练模型 · 分词与数据格式 · LoRA 参数高效微调 · 生成与评测 · 实验记录</span>
  <span class="go">进入 →</span>
</a>
<a href="review/study-paths.md">
  <span class="no">复</span>
  <span class="t">复习层 · 公式卡 / 对照卡 / 术语 / 路径</span>
  <span class="d">九讲公式收口 · 24 张易混对照卡 · 约 180 条术语中英对照 · 五条按时间与目的规划的路线</span>
  <span class="go">进入 →</span>
</a>
<a href="memory-sheet.md">
  <span class="no">记</span>
  <span class="t">速查背记卡 · 最小可背诵单元</span>
  <span class="d">每讲压成「一句结论 + 一个公式 + 一个陷阱」，考前与面试前 10 分钟扫一遍</span>
  <span class="go">进入 →</span>
</a>
<a href="training/arena.md">
  <span class="no">训</span>
  <span class="t">面试与答辩竞技场</span>
  <span class="d">必考点清单（S/A/B 三级）· 60 秒速答 · 白板推导 · 系统设计 · 段位表与抢救室</span>
  <span class="go">进入 →</span>
</a>
<a href="training/exam-sprint.md">
  <span class="no">测</span>
  <span class="t">综合自测卷 · 100 分制</span>
  <span class="d">四部分闭环：概念判断 / 填空简答 / 推导计算 / 开放设计，附评分标准与漏点定位表</span>
  <span class="go">进入 →</span>
</a>
<a href="reading.md">
  <span class="no">阅</span>
  <span class="t">延伸阅读地图 · 课程 / 论文 / 开源项目</span>
  <span class="d">母本与对标课程 · 体系化教材 · 交互式可视化 · 从零实现 · 工程框架 · 中文资源 · 按讲速查</span>
  <span class="go">进入 →</span>
</a>
<a href="appendix/resources.md">
  <span class="no">附</span>
  <span class="t">附录 · 开源项目与工具地图 + 选题路线</span>
  <span class="d">从零实现 / 训练框架 / 微调 / 推理部署 / 生成 / RL / 视觉 / 评测工具；从九讲到研究选题</span>
  <span class="go">进入 →</span>
</a>
</div>

<p class="kbd-hint">提示：解答默认折叠，点击「解答」展开；习题页有「展开全部解答」按钮；打印时自动展开全部解答。</p>
