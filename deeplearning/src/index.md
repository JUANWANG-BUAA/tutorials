<section class="chapter-cover">
<div class="kicker">深 度 学 习 导 论 · 定 制 教 程</div>
<h1>从神经元到世界模型：深度学习的一条主线</h1>
<div class="subtitle">依据 MIT 6.S191《Introduction to Deep Learning》整理扩充，把九讲精编为可通读的中文教程，并接上三个动手实验。</div>
<div class="cover-chips">
<span>九讲正文 · 每讲含必记结论</span>
<span>三个 Lab 逐行讲解</span>
<span>术语索引与公式速查</span>
<span>习题与项目提案指南</span>
</div>
<details class="cover-details">
<summary>查看课程范围与资料说明</summary>
<div class="meta">
依据 <b>MIT 6.S191《Introduction to Deep Learning》</b>（公开课，官网 introtodeeplearning.com）的九讲主题与三个软件实验整理扩充。本教程按「一个范式、三条主线」重组：所有网络都是「定义结构 → 定义损失 → 梯度下降」的实例，而序列、视觉、生成、决策四条支线共享同一套训练语言。公式与结论经本地复算核对，代码示例依赖 TensorFlow / PyTorch 的公开接口。
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
<p>每讲先看学习简报，顺着「直觉」框读懂概念的白话版；证明与推导第一遍跳过，二刷再补。</p>
<a href="lectures/lec01.md">从第 1 讲开始 →</a>
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
<p>公式与结论卡 → 术语索引 → 最小必读路径；把九讲的骨架压缩到一次翻完。</p>
<a href="review/study-paths.md">进入复习层 →</a>
</article>
<article class="study-path">
<span class="path-kicker">PROJECT · 课程产出</span>
<strong>写一份能落地的项目提案</strong>
<p>课程唯一计分产出是项目提案；这里给出官方结构、选题方法与自查表。</p>
<a href="exercises/project.md">进入项目指南 →</a>
</article>
</section>

## 本教程怎么读

全书按「卷首 → 学前准备 → 九讲正文 → 三个实验 → 复习与查阅 → 习题与项目 → 附录」组织。**正讲是「学」的地方，复习层是「记」和「查」的地方，实验与习题是「练」的地方**。每讲开头都有一张**学习简报**（先修 / 目标 / 学完标准），页首还有一个「10 分钟复习版」盒子，把全讲压成一页必记结论——预习时先读它，复习时只读它。左侧目录是唯一的导航入口，页面顶部有全文搜索（或按 <kbd>/</kbd>），页脚与键盘 <kbd>←</kbd> <kbd>→</kbd> 可翻页。

<div class="index-cards">
<a href="prerequisite.md">
  <span class="no">0</span>
  <span class="t">学前准备 · 诊断自测与先修工具箱</span>
  <span class="d">10 道诊断题（含答案与去向建议） · 线性代数 / 概率 / 微分的速查 · 张量形状约定 · 自动微分直觉</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec01.md">
  <span class="no">1</span>
  <span class="t">深度学习导论</span>
  <span class="d">神经元与感知机 · MLP 与通用逼近 · 激活函数 · 损失与梯度下降 · 反向传播 · 过拟合与正则化</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec02.md">
  <span class="no">2</span>
  <span class="t">深度序列建模</span>
  <span class="d">RNN 与梯度消失 · LSTM / GRU 门控 · 注意力机制 · Transformer 与位置编码 · 音乐生成导读</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec03.md">
  <span class="no">3</span>
  <span class="t">深度计算机视觉</span>
  <span class="d">卷积与感受野 · 池化 · AlexNet / VGG / ResNet · 迁移学习 · 检测与分割 · 偏见与对抗样本</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec04.md">
  <span class="no">4</span>
  <span class="t">深度生成建模</span>
  <span class="d">自编码器与 VAE · 重参数化与 ELBO · GAN 对抗训练 · 扩散模型去噪目标 · 生成模型的应用谱系</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec05.md">
  <span class="no">5</span>
  <span class="t">深度强化学习</span>
  <span class="d">MDP 与回报 · 值方法 DQN · 策略梯度与 Actor–Critic · PPO · 离线 RL 与 RLHF</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec06.md">
  <span class="no">6</span>
  <span class="t">新前沿</span>
  <span class="d">大语言模型与缩放律 · 思维链与上下文学习 · 多模态与具身智能 · 世界模型与智能体</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec07.md">
  <span class="no">7</span>
  <span class="t">AI 的三条法则</span>
  <span class="d">安全与对齐 · 可解释与可信 · 偏见与公平 · 滥用风险 · 监管与责任</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec08.md">
  <span class="no">8</span>
  <span class="t">AI for Science</span>
  <span class="d">蛋白质结构预测 · 分子与材料设计 · 气候与地球科学 · 可微分仿真 · 科学发现的范式</span>
  <span class="go">进入 →</span>
</a>
<a href="lectures/lec09.md">
  <span class="no">9</span>
  <span class="t">大规模并行训练的秘诀</span>
  <span class="d">数据 / 张量 / 流水线并行 · 混合精度与梯度累积 · ZeRO 与 FSDP · 通信隐藏与工程实践</span>
  <span class="go">进入 →</span>
</a>
<a href="labs/lab1.md">
  <span class="no">Lab 1</span>
  <span class="t">深度学习入门与音乐生成</span>
  <span class="d">张量与自动微分 · 手写一层网络 · 字符级 RNN 生成旋律 · 温度采样的作用</span>
  <span class="go">进入 →</span>
</a>
<a href="labs/lab2.md">
  <span class="no">Lab 2</span>
  <span class="t">人脸检测系统</span>
  <span class="d">滑动窗口与 CNN 检测 · 数据管线 · 训练与评估 · 对抗样本与隐私讨论</span>
  <span class="go">进入 →</span>
</a>
<a href="labs/lab3.md">
  <span class="no">Lab 3</span>
  <span class="t">微调一个大语言模型</span>
  <span class="d">加载预训练模型 · 分词与数据格式 · 参数高效微调 LoRA · 生成与评估</span>
  <span class="go">进入 →</span>
</a>
<a href="review/formula-cards.md">
  <span class="no">复</span>
  <span class="t">复习层 · 公式卡 / 术语索引 / 必读路径</span>
  <span class="d">九讲必记公式压成一页 · 约 90 条术语中英对照 · 按时间与目的规划的四条精确路线</span>
  <span class="go">进入 →</span>
</a>
<a href="exercises/project.md">
  <span class="no">项</span>
  <span class="t">习题集与项目提案指南</span>
  <span class="d">九讲习题（附提示） · 官方七要素提案结构 · 选题方法 · 提交自查表</span>
  <span class="go">进入 →</span>
</a>
</div>

<p class="kbd-hint">提示：解答默认折叠，点击「解答」展开；习题页有「展开全部解答」按钮；打印时自动展开全部解答。</p>
